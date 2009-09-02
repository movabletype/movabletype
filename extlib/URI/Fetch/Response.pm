# $Id: Response.pm 1943 2006-06-25 18:59:50Z btrott $

package URI::Fetch::Response;
use strict;

sub new {
    my $class = shift;
    my $feed = bless { }, $class;
    $feed;
}

sub _var {
    my $feed = shift;
    my $var = shift;
    $feed->{$var} = shift if @_;
    $feed->{$var};
}

sub status        { shift->_var('status',        @_) }
sub http_status   { shift->_var('http_status',   @_) }
sub http_response { shift->_var('http_response', @_) }
sub etag          { shift->_var('etag',          @_) }
sub last_modified { shift->_var('last_modified', @_) }
sub uri           { shift->_var('uri',           @_) }
sub content       { shift->_var('content',       @_) }
sub content_type  { shift->_var('content_type',  @_) }

sub is_success  {
    my $response = shift;
    return $response->http_response->is_success if $response->http_response;
    return 1;
}

sub is_redirect {
    my $response = shift;
    return $response->http_response->is_redirect if $response->http_response;
    return;
}

sub is_error    {
    my $response = shift;
    return $response->http_response->is_error if $response->http_response;
    return;
}

1;
__END__

=head1 NAME

URI::Fetch::Response - Feed response for URI::Fetch

=head1 SYNOPSIS

    use URI::Fetch;
    my $res = URI::Fetch->fetch('http://example.com/atom.xml')
        or die URI::Fetch->errstr;
    print $res->content;

=head1 DESCRIPTION

I<URI::Fetch::Response> encapsulates the response from fetching a feed
using I<URI::Fetch>.

=head1 USAGE

=head2 $res->content

The contents of the feed.

=head2 $res->uri

The URI of the feed. If the feed was moved, this reflects the new URI;
otherwise, it will match the URI that you passed to I<fetch>.

=head2 $res->etag

The ETag that was returned in the response, if any.

=head2 $res->last_modified

The Last-Modified date (in seconds since the epoch) that was returned in
the response, if any.

=head2 $res->status

The status of the response, which will match one of the following
enumerations:

=over 4

=item * URI::Fetch::URI_OK()

=item * URI::Fetch::URI_MOVED_PERMANENTLY()

=item * URI::Fetch::URI_GONE()

=item * URI::Fetch::URI_NOT_MODIFIED()

=back

=head2 $res->http_status

The HTTP status code from the response.

=head2 $res->http_response

The I<HTTP::Response> object returned from the fetch.

=head2 $res->is_success

=head2 $res->is_redirect

=head2 $res->is_error

Wrappers around the C<$res-E<gt>response> methods of the same name, for
convenience.

=head2 $res->content_type

The Content-Type header from the response.

=head1 AUTHOR & COPYRIGHT

Please see the I<URI::Fetch> manpage for author, copyright, and license
information.

=cut
