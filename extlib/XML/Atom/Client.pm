# $Id$

package XML::Atom::Client;
use strict;

use XML::Atom;
use base qw( XML::Atom::ErrorHandler );
use LWP::UserAgent;
use XML::Atom::Entry;
use XML::Atom::Feed;
use XML::Atom::Util qw( first textValue );
use Digest::SHA1 qw( sha1 );
use MIME::Base64 qw( encode_base64 );
use DateTime;

use constant NS_SOAP => 'http://schemas.xmlsoap.org/soap/envelope/';

sub new {
    my $class = shift;
    my $client = bless { }, $class;
    $client->init(@_) or return $class->error($client->errstr);
    $client;
}

sub init {
    my $client = shift;
    my %param = @_;
    $client->{ua} = LWP::UserAgent::AtomClient->new($client);
    $client->{ua}->agent('XML::Atom/' . XML::Atom->VERSION);
    $client->{ua}->parse_head(0);
    $client;
}

sub username {
    my $client = shift;
    $client->{username} = shift if @_;
    $client->{username};
}

sub password {
    my $client = shift;
    $client->{password} = shift if @_;
    $client->{password};
}

sub use_soap {
    my $client = shift;
    $client->{use_soap} = shift if @_;
    $client->{use_soap};
}

sub auth_digest {
    my $client = shift;
    $client->{auth_digest} = shift if @_;
    $client->{auth_digest};
}

sub getEntry {
    my $client = shift;
    my($url) = @_;
    my $req = HTTP::Request->new(GET => $url);
    my $res = $client->make_request($req);
    return $client->error("Error on GET $url: " . $res->status_line)
        unless $res->code == 200;
    XML::Atom::Entry->new(Stream => \$res->content);
}

sub createEntry {
    my $client = shift;
    my($uri, $entry) = @_;
    return $client->error("Must pass a PostURI before posting")
        unless $uri;
    my $req = HTTP::Request->new(POST => $uri);
    $req->content_type($entry->content_type);
    my $xml = $entry->as_xml;
    _utf8_off($xml);
    $req->content_length(length $xml);
    $req->content($xml);
    my $res = $client->make_request($req);
    return $client->error("Error on POST $uri: " . $res->status_line)
        unless $res->code == 201;
    $res->header('Location') || 1;
}

sub updateEntry {
    my $client = shift;
    my($url, $entry) = @_;
    my $req = HTTP::Request->new(PUT => $url);
    $req->content_type($entry->content_type);
    my $xml = $entry->as_xml;
    _utf8_off($xml);
    $req->content_length(length $xml);
    $req->content($xml);
    my $res = $client->make_request($req);
    return $client->error("Error on PUT $url: " . $res->status_line)
        unless $res->code == 200;
    1;
}

sub deleteEntry {
    my $client = shift;
    my($url) = @_;
    my $req = HTTP::Request->new(DELETE => $url);
    my $res = $client->make_request($req);
    return $client->error("Error on DELETE $url: " . $res->status_line)
        unless $res->code == 200;
    1;
}

sub getFeed {
    my $client = shift;
    my($uri) = @_;
    return $client->error("Must pass a FeedURI before retrieving feed")
        unless $uri;
    my $req = HTTP::Request->new(GET => $uri);
    my $res = $client->make_request($req);
    return $client->error("Error on GET $uri: " . $res->status_line)
        unless $res->code == 200;
    my $feed = XML::Atom::Feed->new(Stream => \$res->content)
        or return $client->error(XML::Atom::Feed->errstr);
    $feed;
}

sub make_request {
    my $client = shift;
    my($req) = @_;
    $client->munge_request($req);
    my $res = $client->{ua}->request($req);
    $client->munge_response($res);
    $client->{response} = $res;
    $res;
}

sub munge_request {
    my $client = shift;
    my($req) = @_;
    $req->header(
        Accept => 'application/atom+xml, application/x.atom+xml, application/xml, text/xml, */*',
    );
    my $nonce = $client->make_nonce;
    my $nonce_enc = encode_base64($nonce, '');
    my $now = DateTime->now->iso8601 . 'Z';
    my $digest = encode_base64(sha1($nonce . $now . ($client->password || '')), '');
    if ($client->use_soap) {
        my $xml = $req->content || '';
        $xml =~ s!^(<\?xml.*?\?>)!!;
        my $method = $req->method;
        $xml = ($1 || '') . <<SOAP;
<soap:Envelope
  xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:wsu="http://schemas.xmlsoap.org/ws/2002/07/utility"
  xmlns:wsse="http://schemas.xmlsoap.org/ws/2002/07/secext">
  <soap:Header>
    <wsse:Security>
      <wsse:UsernameToken>
        <wsse:Username>@{[ $client->username || '' ]}</wsse:Username>
        <wsse:Password Type="wsse:PasswordDigest">$digest</wsse:Password>
        <wsse:Nonce>$nonce_enc</wsse:Nonce>
        <wsu:Created>$now</wsu:Created>
      </wsse:UsernameToken>
    </wsse:Security>
  </soap:Header>
  <soap:Body>
    <$method xmlns="http://schemas.xmlsoap.org/wsdl/http/">
$xml
    </$method>
  </soap:Body>
</soap:Envelope>
SOAP
        $req->content($xml);
        $req->content_length(length $xml);
        $req->header('SOAPAction', 'http://schemas.xmlsoap.org/wsdl/http/' . $method);
        $req->method('POST');
        $req->content_type('text/xml');
    } else {
        if ($client->username) {
            $req->header('X-WSSE', sprintf
              qq(UsernameToken Username="%s", PasswordDigest="%s", Nonce="%s", Created="%s"),
              $client->username || '', $digest, $nonce_enc, $now);
            $req->header('Authorization', 'WSSE profile="UsernameToken"');
        }
    }
}

sub munge_response {
    my $client = shift;
    my($res) = @_;
    if ($client->use_soap && (my $xml = $res->content)) {
        my $doc;
        if (LIBXML) {
            my $parser = XML::LibXML->new;
            $doc = $parser->parse_string($xml);
        } else {
            my $xp = XML::XPath->new(xml => $xml);
            $doc = ($xp->find('/')->get_nodelist)[0];
        }
        my $body = first($doc, NS_SOAP, 'Body');
        if (my $fault = first($body, NS_SOAP, 'Fault')) {
            $res->code(textValue($fault, undef, 'faultcode'));
            $res->message(textValue($fault, undef, 'faultstring'));
            $res->content('');
            $res->content_length(0);
        } else {
            $xml = join '', map $_->toString(LIBXML ? 1 : 0),
                LIBXML ? $body->childNodes : $body->getChildNodes;
            $res->content($xml);
            $res->content_length(1);
        }
    }
}

sub make_nonce { sha1(sha1(time() . {} . rand() . $$)) }

sub _utf8_off {
    if ($] >= 5.008) {
        require Encode;
        Encode::_utf8_off($_[0]);
    }
}

package LWP::UserAgent::AtomClient;
use strict;
use Scalar::Util;

use base qw( LWP::UserAgent );

my %ClientOf;
sub new {
    my($class, $client) = @_;
    my $ua = $class->SUPER::new;
    $ClientOf{$ua} = $client;
    Scalar::Util::weaken($ClientOf{$ua});
    $ua;
}

sub get_basic_credentials {
    my($ua, $realm, $url, $proxy) = @_;
    my $client = $ClientOf{$ua} or die "Cannot find $ua";
    return $client->username, $client->password;
}

sub DESTROY {
    my $self = shift;
    delete $ClientOf{$self};
}

1;
__END__

=head1 NAME

XML::Atom::Client - A client for the Atom API

=head1 SYNOPSIS

    use XML::Atom::Client;
    use XML::Atom::Entry;
    my $api = XML::Atom::Client->new;
    $api->username('Melody');
    $api->password('Nelson');

    my $entry = XML::Atom::Entry->new;
    $entry->title('New Post');
    $entry->content('Content of my post.');
    my $EditURI = $api->createEntry($PostURI, $entry);

    my $feed = $api->getFeed($FeedURI);
    my @entries = $feed->entries;

    my $entry = $api->getEntry($EditURI);

=head1 DESCRIPTION

I<XML::Atom::Client> implements a client for the Atom API described at
I<http://bitworking.org/projects/atom/draft-gregorio-09.html>, with the
authentication scheme described at
I<http://www.intertwingly.net/wiki/pie/DifferentlyAbledClients>.

B<NOTE:> the API, and particularly the authentication scheme, are still
in flux.

=head1 USAGE

=head2 XML::Atom::Client->new(%param)

=head2 $api->use_soap([ 0 | 1 ])

I<XML::Atom::Client> supports both the REST and SOAP-wrapper versions of the
Atom API. By default, the REST version of the API will be used, but you can
turn on the SOAP wrapper--for example, if you need to connect to a server
that supports only the SOAP wrapper--by calling I<use_soap> with a value of
C<1>:

    $api->use_soap(1);

If called without arguments, returns the current value of the flag.

=head2 $api->username([ $username ])

If called with an argument, sets the username for login to I<$username>.

Returns the current username that will be used when logging in to the
Atom server.

=head2 $api->password([ $password ])

If called with an argument, sets the password for login to I<$password>.

Returns the current password that will be used when logging in to the
Atom server.

=head2 $api->createEntry($PostURI, $entry)

Creates a new entry.

I<$entry> must be an I<XML::Atom::Entry> object.

=head2 $api->getEntry($EditURI)

Retrieves the entry with the given URL I<$EditURI>.

Returns an I<XML::Atom::Entry> object.

=head2 $api->updateEntry($EditURI, $entry)

Updates the entry at URL I<$EditURI> with the entry I<$entry>, which must be
an I<XML::Atom::Entry> object.

Returns true on success, false otherwise.

=head2 $api->deleteEntry($EditURI)

Deletes the entry at URL I<$EditURI>.

=head2 $api->getFeed($FeedURI)

Retrieves the feed at I<$FeedURI>.

Returns an I<XML::Atom::Feed> object representing the feed returned
from the server.

=head2 ERROR HANDLING

Methods return C<undef> on error, and the error message can be retrieved
using the I<errstr> method.

=head1 AUTHOR & COPYRIGHT

Please see the I<XML::Atom> manpage for author, copyright, and license
information.

=cut
