# $Id$

package XML::Atom::Server;
use strict;

use XML::Atom;
use base qw( XML::Atom::ErrorHandler );
use MIME::Base64 qw( encode_base64 decode_base64 );
use Digest::SHA1 qw( sha1 );
use XML::Atom::Util qw( first encode_xml textValue );
use XML::Atom::Entry;

use constant NS_SOAP => 'http://schemas.xmlsoap.org/soap/envelope/';
use constant NS_WSSE => 'http://schemas.xmlsoap.org/ws/2002/07/secext';
use constant NS_WSU => 'http://schemas.xmlsoap.org/ws/2002/07/utility';

sub handler ($$) {
    my $class = shift;
    my($r) = @_;
    require Apache::Constants;
    if (lc($r->dir_config('Filter') || '') eq 'on') {
        $r = $r->filter_register;
    }
    my $server = $class->new or die $class->errstr;
    $server->{apache} = $r;
    $server->run;
    return Apache::Constants::OK();
}

sub new {
    my $class = shift;
    my $server = bless { }, $class;
    $server->init(@_) or return $class->error($server->errstr);
    $server;
}

sub init {
    my $server = shift;
    $server->{param} = {};
    unless ($ENV{MOD_PERL}) {
        require CGI;
        $server->{cgi} = CGI->new({});
    }
    $server;
}

sub run {
    my $server = shift;
    (my $pi = $server->path_info) =~ s!^/!!;
    my @args = split /\//, $pi;
    for my $arg (@args) {
        my($k, $v) = split /=/, $arg, 2;
        $server->request_param($k, $v);
    }
    if (my $action = $server->request_header('SOAPAction')) {
        $server->{is_soap} = 1;
        $action =~ s/"//g;
        my($method) = $action =~ m!/([^/]+)$!;
        $server->request_method($method);
    }
    my $out;
    eval {
        defined($out = $server->handle_request) or die $server->errstr;
        if (defined $out && $server->{is_soap}) {
            $out =~ s!^(<\?xml.*?\?>)!!;
            $out = <<SOAP;
$1
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>$out</soap:Body>
</soap:Envelope>
SOAP
        }
    };
    if ($@) {
        $out = $server->show_error($@);
    }
    $server->send_http_header;
    $server->print($out);
    1;
}

sub handle_request;
sub password_for_user;

sub uri {
    my $server = shift;
    $ENV{MOD_PERL} ? $server->{apache}->uri : $server->{cgi}->url;
}

sub path_info {
    my $server = shift;
    return $server->{__path_info} if exists $server->{__path_info};
    my $path_info;
    if ($ENV{MOD_PERL}) {
        ## mod_perl often leaves part of the script name (Location)
        ## in the path info, for some reason. This should remove it.
        $path_info = $server->{apache}->path_info;
        if ($path_info) {
            my($script_last) = $server->{apache}->location =~ m!/([^/]+)$!;
            $path_info =~ s!^/$script_last!!;
        }
    } else {
        $path_info = $server->{cgi}->path_info;
    }
    $server->{__path_info} = $path_info;
}

sub request_header {
    my $server = shift;
    my($key) = @_;
    if ($ENV{MOD_PERL}) {
        return $server->{apache}->header_in($key);
    } else {
        ($key = uc($key)) =~ tr/-/_/;
        return $ENV{'HTTP_' . $key};
    }
}

sub request_method {
    my $server = shift;
    if (@_) {
        $server->{request_method} = shift;
    } elsif (!exists $server->{request_method}) {
        $server->{request_method} =
            $ENV{MOD_PERL} ? $server->{apache}->method : $ENV{REQUEST_METHOD};
    }
    $server->{request_method};
}

sub request_content {
    my $server = shift;
    unless (exists $server->{request_content}) {
        if ($ENV{MOD_PERL}) {
            ## Read from $server->{apache}
            my $r = $server->{apache};
            my $len = $server->request_header('Content-length');
            $r->read($server->{request_content}, $len);
        } else {
            ## Read from STDIN
            my $len = $ENV{CONTENT_LENGTH} || 0;
            read STDIN, $server->{request_content}, $len;
        }
    }
    $server->{request_content};
}

sub request_param {
    my $server = shift;
    my $k = shift;
    $server->{param}{$k} = shift if @_;
    $server->{param}{$k};
}

sub response_header {
    my $server = shift;
    my($key, $val) = @_;
    if ($ENV{MOD_PERL}) {
        $server->{apache}->header_out($key, $val);
    } else {
        unless ($key =~ /^-/) {
            ($key = lc($key)) =~ tr/-/_/;
            $key = '-' . $key;
        }
        $server->{cgi_headers}{$key} = $val;
    }
}

sub response_code {
    my $server = shift;
    $server->{response_code} = shift if @_;
    $server->{response_code};
}

sub response_content_type {
    my $server = shift;
    $server->{response_content_type} = shift if @_;
    $server->{response_content_type};
}

sub send_http_header {
    my $server = shift;
    my $type = $server->response_content_type || 'application/x.atom+xml';
    if ($ENV{MOD_PERL}) {
        $server->{apache}->status($server->response_code || 200);
        $server->{apache}->send_http_header($type);
    } else {
        $server->{cgi_headers}{-status} = $server->response_code || 200;
        $server->{cgi_headers}{-type} = $type;
        print $server->{cgi}->header(%{ $server->{cgi_headers} });
    }
}

sub print {
    my $server = shift;
    if ($ENV{MOD_PERL}) {
        $server->{apache}->print(@_);
    } else {
        CORE::print(@_);
    }
}

sub error {
    my $server = shift;
    my($code, $msg) = @_;
    $server->response_code($code) if ref($server);
    return $server->SUPER::error($msg);
}

sub show_error {
    my $server = shift;
    my($err) = @_;
    chomp($err = encode_xml($err));
    if ($server->{is_soap}) {
        my $code = $server->response_code;
        if ($code >= 400) {
            $server->response_code(500);
        }
        return <<FAULT;
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <soap:Fault>
      <faultcode>$code</faultcode>
      <faultstring>$err</faultstring>
    </soap:Fault>
  </soap:Body>
</soap:Envelope>
FAULT
    } else {
        return <<ERR;
<?xml version="1.0" encoding="utf-8"?>
<error>$err</error>
ERR
    }
}

sub get_auth_info {
    my $server = shift;
    my %param;
    if ($server->{is_soap}) {
        my $xml = $server->xml_body;
        my $auth = first($xml, NS_WSSE, 'UsernameToken');
        $param{Username} = textValue($auth, NS_WSSE, 'Username');
        $param{PasswordDigest} = textValue($auth, NS_WSSE, 'Password');
        $param{Nonce} = textValue($auth, NS_WSSE, 'Nonce');
        $param{Created} = textValue($auth, NS_WSSE, 'Created');
    } else {
        my $req = $server->request_header('X-WSSE')
            or return $server->auth_failure(401, 'X-WSSE authentication required');
        $req =~ s/^(?:WSSE|UsernameToken) //;
        for my $i (split /,\s*/, $req) {
            my($k, $v) = split /=/, $i, 2;
            $v =~ s/^"//;
            $v =~ s/"$//;
            $param{$k} = $v;
        }
    }
    \%param;
}

sub authenticate {
    my $server = shift;
    my $auth = $server->get_auth_info or return;
    for my $f (qw( Username PasswordDigest Nonce Created )) {
        return $server->auth_failure(400, "X-WSSE requires $f")
            unless $auth->{$f};
    }
    my $password = $server->password_for_user($auth->{Username});
    defined($password) or return $server->auth_failure(403, 'Invalid login');
    my $expected = encode_base64(sha1(
           decode_base64($auth->{Nonce}) . $auth->{Created} . $password
    ), '');
    return $server->auth_failure(403, 'Invalid login')
        unless $expected eq $auth->{PasswordDigest};
    return 1;
}

sub auth_failure {
    my $server = shift;
    $server->response_header('WWW-Authenticate', 'WSSE profile="UsernameToken"');
    return $server->error(@_);
}

sub xml_body {
    my $server = shift;
    unless (exists $server->{xml_body}) {
        if (LIBXML) {
            my $parser = XML::LibXML->new;
            $server->{xml_body} =
                $parser->parse_string($server->request_content);
        } else {
            $server->{xml_body} =
                XML::XPath->new(xml => $server->request_content);
        }
    }
    $server->{xml_body};
}

sub atom_body {
    my $server = shift;
    my $atom;
    if ($server->{is_soap}) {
        my $xml = $server->xml_body;
        $atom = XML::Atom::Entry->new(Doc => first($xml, NS_SOAP, 'Body'))
            or return $server->error(500, XML::Atom::Entry->errstr);
    } else {
        $atom = XML::Atom::Entry->new(Stream => \$server->request_content)
            or return $server->error(500, XML::Atom::Entry->errstr);
    }
    $atom;
}

1;
__END__

=head1 NAME

XML::Atom::Server - A server for the Atom API

=head1 SYNOPSIS

    package My::Server;
    use base qw( XML::Atom::Server );
    sub handle_request {
        my $server = shift;
        $server->authenticate or return;
        my $method = $server->request_method;
        if ($method eq 'POST') {
            return $server->new_post;
        }
        ...
    }

    my %Passwords;
    sub password_for_user {
        my $server = shift;
        my($username) = @_;
        $Passwords{$username};
    }

    sub new_post {
        my $server = shift;
        my $entry = $server->atom_body or return;
        ## $entry is an XML::Atom::Entry object.
        ## ... Save the new entry ...
    }

    package main;
    my $server = My::Server->new;
    $server->run;

=head1 DESCRIPTION

I<XML::Atom::Server> provides a base class for Atom API servers. It handles
all core server processing, both the SOAP and REST formats of the protocol,
and WSSE authentication. It can also run as either a mod_perl handler or as
part of a CGI program.

It does not provide functions specific to any particular implementation,
such as posting an entry, retrieving a list of entries, deleting an entry, etc.
Implementations should subclass I<XML::Atom::Server>, overriding the
I<handle_request> method, and handle all functions such as this themselves.

=head1 SUBCLASSING

=head2 Request Handling

Subclasses of I<XML::Atom::Server> must override the I<handle_request>
method to perform all request processing. The implementation must set all
response headers, including the response code and any relevant HTTP headers,
and should return a scalar representing the response body to be sent back
to the client.

For example:

    sub handle_request {
        my $server = shift;
        my $method = $server->request_method;
        if ($method eq 'POST') {
            return $server->new_post;
        }
        ## ... handle GET, PUT, etc
    }
    
    sub new_post {
        my $server = shift;
        my $entry = $server->atom_body or return;
        my $id = save_this_entry($entry);  ## Implementation-specific
        $server->response_header(Location => $server->uri . '/entry_id=' . $id);
        $server->response_code(201);
        $server->response_content_type('application/x.atom+xml');
        return serialize_entry($entry);    ## Implementation-specific
    }

=head2 Authentication

Servers that require authentication for posting or retrieving entries or
feeds should override the I<password_for_user> method. Given a username
(from the WSSE header), I<password_for_user> should return that user's
password in plaintext. This will then be combined with the nonce and the
creation time to generate the digest, which will be compared with the
digest sent in the WSSE header. If the supplied username doesn't exist in
your user database or alike, just return C<undef>.

For example:

    my %Passwords = ( foo => 'bar' );   ## The password for "foo" is "bar".
    sub password_for_user {
        my $server = shift;
        my($username) = @_;
        $Passwords{$username};
    }

=head1 METHODS

I<XML::Atom::Server> provides a variety of methods to be used by subclasses
for retrieving headers, content, and other request information, and for
setting the same on the response.

=head2 Client Request Parameters

=over 4

=item * $server->uri

Returns the URI of the Atom server implementation.

=item * $server->request_method

Returns the name of the request method sent to the server from the client
(for example, C<GET>, C<POST>, etc). Note that if the client sent the
request in a SOAP envelope, the method is obtained from the I<SOAPAction>
HTTP header.

=item * $server->request_header($header)

Retrieves the value of the HTTP request header I<$header>.

=item * $server->request_content

Returns a scalar containing the contents of a POST or PUT request from the
client.

=item * $server->request_param($param)

I<XML::Atom::Server> automatically parses the PATH_INFO sent in the request
and breaks it up into key-value pairs. This can be used to pass parameters.
For example, in the URI

    http://localhost/atom-server/entry_id=1

the I<entry_id> parameter would be set to C<1>.

I<request_param> returns the value of the value of the parameter I<$param>.

=back

=head2 Setting up the Response

=over 4

=item * $server->response_header($header, $value)

Sets the value of the HTTP response header I<$header> to I<$value>.

=item * $server->response_code([ $code ])

Returns the current response code to be sent back to the client, and if
I<$code> is given, sets the response code.

=item * $server->response_content_type([ $type ])

Returns the current I<Content-Type> header to be sent back to the client, and
I<$type> is given, sets the value for that header.

=back

=head2 Processing the Request

=over 4

=item * $server->authenticate

Attempts to authenticate the request based on the authentication
information present in the request (currently just WSSE). This will call
the I<password_for_user> method in the subclass to obtain the cleartext
password for the username given in the request.

=item * $server->atom_body

Returns an I<XML::Atom::Entry> object containing the entry sent in the
request.

=back

=head1 USAGE

Once you have defined your server subclass, you can set it up either as a
CGI program or as a mod_perl handler.

A simple CGI program would look something like this:

    #!/usr/bin/perl -w
    use strict;

    use My::Server;
    my $server = My::Server->new;
    $server->run;

A simple mod_perl handler configuration would look something like this:

    PerlModule My::Server
    <Location /atom-server>
        SetHandler perl-script
        PerlHandler My::Server
    </Location>

=head1 ERROR HANDLING

If you wish to return an error from I<handle_request>, you can use the
built-in I<error> method:

    sub handle_request {
        my $server = shift;
        ...
        return $server->error(500, "Something went wrong");
    }

This will be returned to the client with a response code of 500 and an
error string of C<Something went wrong>. Errors are automatically
serialized into SOAP faults if the incoming request is enclosed in a SOAP
envelope.

=head1 AUTHOR & COPYRIGHT

Please see the I<XML::Atom> manpage for author, copyright, and license
information.

=cut
