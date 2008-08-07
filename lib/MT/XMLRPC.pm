# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::XMLRPC;
use strict;

use MT;
use MT::Util qw( encode_xml );
use MT::ErrorHandler;
@MT::XMLRPC::ISA = qw( MT::ErrorHandler );
use MT::I18N qw( encode_text );

sub weblogs_ping {
    my $class = shift;
    my($blog) = @_;
    my $url = MT->config->WeblogsPingURL
        or return $class->error(MT->translate(
            "No WeblogsPingURL defined in the configuration file" ));
    $class->ping_update('weblogUpdates.ping', $blog, $url);
}

sub mt_ping {
    my $class = shift;
    my($blog) = @_;
    my $url = MT->config->MTPingURL
        or return $class->error(MT->translate(
            "No MTPingURL defined in the configuration file" ));
    if (!ref($blog)) {
        require MT::Blog;
        $blog = MT::Blog->load($blog)
            or return $class->error(MT->translate('Can\'t load blog #[_1].', $blog));
    }
    $class->ping_update('mtUpdates.ping', $blog, $url, $blog->mt_update_key);
}

sub ping_update {
    my $class = shift;
    my($method, $blog, $url, $mt_key) = @_;
    if (!ref($blog)) {
        require MT::Blog;
        $blog = MT::Blog->load($blog)
            or return $class->error(MT->translate('Can\'t load blog #[_1].', $blog));
    }
    my $ua = MT->new_ua( { timeout => MT->config->PingTimeout } );
    my $req = HTTP::Request->new('POST', $url);
    $req->header('Content-Type' => 'text/xml');
    my $blog_name = encode_xml(encode_text($blog->name, undef, 'utf-8'));
    my $blog_url = encode_xml($blog->site_url);
    my $text = <<XML;
<?xml version="1.0"?>
<methodCall>
    <methodName>$method</methodName>
    <params>
    <param><value>$blog_name</value></param>
    <param><value>$blog_url</value></param>
XML
    if ($mt_key) {
        $text .= "    <param><value>$mt_key</value></param>\n";
    }
    $text .= <<XML;
    </params>
</methodCall>
XML
    $req->content($text);
    my $res = $ua->request($req);
    if (substr($res->code, 0, 1) ne '2') {
        return $class->error(MT->translate(
            "HTTP error: [_1]", $res->status_line ));
    }
    my $content = $res->content;
    my($error) = $content =~ m!flerror.*?<boolean>(\d+)!s;
    my($msg) = $content =~ m!message.*?<value>(.+?)</value>!s;
    if ($error) {
        return $class->error(MT->translate(
            "Ping error: [_1]", $msg ));
    }
    $msg;
}

1;
__END__

=head1 NAME

MT::XMLRPC - Movable Type XML-RPC client routines

=head1 SYNOPSIS

    use MT::XMLRPC;

    ## Ping weblogs.com.
    MT::XMLRPC->weblogs_ping($blog)
        or die MT::XMLRPC->errstr;

    ## Ping a different service supporting the weblogs.com interface.
    MT::XMLRPC->ping_update('weblogUpdates.ping', $blog,
        'http://my.ping-service.com/RPC')
        or die MT::XMLRPC->errstr;

=head1 DESCRIPTION

I<MT::XMLRPC> provides XML-RPC client functionality for sending pings to
"recently updated" services. It contains built-in methods for sending pings
to I<weblogs.com> and I<movabletype.org>; in addition, it has a more
generic method for sending XML-RPC pings to other services that support the
general weblogs.com API.

=head1 USAGE

=head2 MT::XMLRPC->weblogs_ping($blog)

Send an XML-RPC ping to I<weblogs.com> for the blog I<$blog>, which should be
an I<MT::Blog> object.

On success, returns a true value; on failure, returns C<undef>, and the error
message can be obtained by calling I<errstr> on the class name.

=head2 MT::XMLRPC->mt_ping($blog)

Send an XML-RPC ping to I<movabletype.org> for the blog I<$blog>, which should
be an I<MT::Blog> object, and which should contain a valid Movable Type
Recently Updated Key.

On success, returns a true value; on failure, returns C<undef>, and the error
message can be obtained by calling I<errstr> on the class name.

=head2 MT::XMLRPC->ping_update($method, $blog, $url)

Send an XML-RPC ping to the XML-RPC server at I<$url> for the blog I<$blog>;
the XML-RPC method called will be I<$method>. In most cases (that is, unless
you know otherwise), you should just use C<weblogUpdates.ping> for I<$method>.

On success, returns a true value; on failure, returns C<undef>, and the error
message can be obtained by calling I<errstr> on the class name.

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
