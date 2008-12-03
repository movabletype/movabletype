# $Id: Fetch.pm 1952 2006-07-25 05:41:24Z btrott $

package URI::Fetch;
use strict;
use base qw( Class::ErrorHandler );

use LWP::UserAgent;
use Carp qw( croak );
use URI;
use URI::Fetch::Response;

our $VERSION = '0.08';

our $HAS_ZLIB;
BEGIN {
    $HAS_ZLIB = eval "use Compress::Zlib (); 1;";
}

use constant URI_OK                => 200;
use constant URI_MOVED_PERMANENTLY => 301;
use constant URI_NOT_MODIFIED      => 304;
use constant URI_GONE              => 410;

sub fetch {
    my $class = shift;
    my($uri, %param) = @_;

    # get user parameters
    my $cache        = delete $param{Cache};
    my $ua           = delete $param{UserAgent};
    my $p_etag       = delete $param{ETag};
    my $p_lastmod    = delete $param{LastModified};
    my $content_hook = delete $param{ContentAlterHook};
    my $p_no_net     = delete $param{NoNetwork};
    my $p_cache_grep = delete $param{CacheEntryGrep};
    my $freeze       = delete $param{Freeze};
    my $thaw         = delete $param{Thaw};
    my $force        = delete $param{ForceResponse};
    croak("Unknown parameters: " . join(", ", keys %param))
        if %param;

    my $ref;
    if ($cache) {
        unless ($freeze && $thaw) {
            require Storable;
            $thaw = \&Storable::thaw;
            $freeze = \&Storable::freeze;
        }
        if (my $blob = $cache->get($uri)) {
            $ref = $thaw->($blob);
        }
    }

    # NoNetwork support (see pod docs below for logic clarification)
    if ($p_no_net) {
        croak("Invalid NoNetworkValue (negative)") if $p_no_net < 0;
        if ($ref && ($p_no_net == 1 || $ref->{CacheTime} > time() - $p_no_net)) {

            my $fetch = URI::Fetch::Response->new;
            $fetch->status(URI_OK);
            $fetch->content($ref->{Content});
            $fetch->etag($ref->{ETag});
            $fetch->last_modified($ref->{LastModified});
            $fetch->content_type($ref->{ContentType});
            return $fetch;
        }
        return undef if $p_no_net == 1;
    }

    $ua ||= LWP::UserAgent->new;
    $ua->agent(join '/', $class, $class->VERSION)
        if $ua->agent =~ /^libwww-perl/;

    my $req = HTTP::Request->new(GET => $uri);
    if ($HAS_ZLIB) {
        $req->header('Accept-Encoding', 'gzip');
    }
    if (my $etag = ($p_etag || $ref->{ETag})) {
        $req->header('If-None-Match', $etag);
    }
    if (my $ts = ($p_lastmod || $ref->{LastModified})) {
        $req->if_modified_since($ts);
    }

    my $res = $ua->request($req);
    my $fetch = URI::Fetch::Response->new;
    $fetch->uri($uri);
    $fetch->http_status($res->code);
    $fetch->http_response($res);
    $fetch->content_type($res->header('Content-Type'));
    if ($res->previous && $res->previous->code == HTTP::Status::RC_MOVED_PERMANENTLY()) {
        $fetch->status(URI_MOVED_PERMANENTLY);
        $fetch->uri($res->previous->header('Location'));
    } elsif ($res->code == HTTP::Status::RC_GONE()) {
        $fetch->status(URI_GONE);
        $fetch->uri(undef);
        return $fetch;
    } elsif ($res->code == HTTP::Status::RC_NOT_MODIFIED()) {
        $fetch->status(URI_NOT_MODIFIED);
        $fetch->content($ref->{Content});
        $fetch->etag($ref->{ETag});
        $fetch->last_modified($ref->{LastModified});
        $fetch->content_type($ref->{ContentType});
        return $fetch;
    } elsif (!$res->is_success) {
        return $force ? $fetch : $class->error($res->message);
        
    } else {
        $fetch->status(URI_OK);
    }
    $fetch->last_modified($res->last_modified);
    $fetch->etag($res->header('ETag'));
    my $content = $res->content;
    if ($res->content_encoding && $res->content_encoding eq 'gzip') {
        $content = Compress::Zlib::memGunzip($content);
    }

    # let caller-defined transform hook modify the result that'll be
    # cached.  perhaps the caller only wants the <head> section of
    # HTML, or wants to change the content to a parsed datastructure
    # already serialized with Storable.
    if ($content_hook) {
        croak("ContentAlterHook is not a subref") unless ref $content_hook eq "CODE";
        $content_hook->(\$content);
    }

    $fetch->content($content);

    # cache by default, if there's a cache.  but let callers cancel
    # the cache action by defining a cache grep hook
    if ($cache &&
        ($p_cache_grep ? $p_cache_grep->($fetch) : 1)) {

        $cache->set($fetch->uri, $freeze->({
            ETag         => $fetch->etag,
            LastModified => $fetch->last_modified,
            Content      => $fetch->content,
            CacheTime    => time(),
            ContentType  => $fetch->content_type,
        }));
    }
    $fetch;
}

1;
__END__

=head1 NAME

URI::Fetch - Smart URI fetching/caching

=head1 SYNOPSIS

    use URI::Fetch;

    ## Simple fetch.
    my $res = URI::Fetch->fetch('http://example.com/atom.xml')
        or die URI::Fetch->errstr;

    ## Fetch using specified ETag and Last-Modified headers.
    my $res = URI::Fetch->fetch('http://example.com/atom.xml',
            ETag => '123-ABC',
            LastModified => time - 3600,
    )
        or die URI::Fetch->errstr;

    ## Fetch using an on-disk cache that URI::Fetch manages for you.
    my $cache = Cache::File->new( cache_root => '/tmp/cache' );
    my $res = URI::Fetch->fetch('http://example.com/atom.xml',
            Cache => $cache
    )
        or die URI::Fetch->errstr;

=head1 DESCRIPTION

I<URI::Fetch> is a smart client for fetching HTTP pages, notably
syndication feeds (RSS, Atom, and others), in an intelligent,
bandwidth- and time-saving way. That means:

=over 4

=item * GZIP support

If you have I<Compress::Zlib> installed, I<URI::Fetch> will automatically
try to download a compressed version of the content, saving bandwidth (and
time).

=item * I<Last-Modified> and I<ETag> support

If you use a local cache (see the I<Cache> parameter to I<fetch>),
I<URI::Fetch> will keep track of the I<Last-Modified> and I<ETag> headers
from the server, allowing you to only download pages that have been
modified since the last time you checked.

=item * Proper understanding of HTTP error codes

Certain HTTP error codes are special, particularly when fetching syndication
feeds, and well-written clients should pay special attention to them.
I<URI::Fetch> can only do so much for you in this regard, but it gives
you the tools to be a well-written client.

The response from I<fetch> gives you the raw HTTP response code, along with
special handling of 4 codes:

=over 4

=item * 200 (OK)

Signals that the content of a page/feed was retrieved
successfully.

=item * 301 (Moved Permanently)

Signals that a page/feed has moved permanently, and that
your database of feeds should be updated to reflect the new
URI.

=item * 304 (Not Modified)

Signals that a page/feed has not changed since it was last
fetched.

=item * 410 (Gone)

Signals that a page/feed is gone and will never be coming back,
so you should stop trying to fetch it.

=back

=head1 USAGE

=head2 URI::Fetch->fetch($uri, %param)

Fetches a page identified by the URI I<$uri>.

On success, returns a I<URI::Fetch::Response> object; on failure, returns
C<undef>.

I<%param> can contain:

=over 4

=item * LastModified

=item * ETag

I<LastModified> and I<ETag> can be supplied to force the server to only
return the full page if it's changed since the last request. If you're
writing your own feed client, this is recommended practice, because it
limits both your bandwidth use and the server's.

If you'd rather not have to store the I<LastModified> time and I<ETag>
yourself, see the I<Cache> parameter below (and the L<SYNOPSIS> above).

=item * Cache

If you'd like I<URI::Fetch> to cache responses between requests, provide
the I<Cache> parameter with an object supporting the L<Cache> API (e.g.
I<Cache::File>, I<Cache::Memory>). Specifically, an object that supports
C<$cache-E<gt>get($key)> and C<$cache-E<gt>set($key, $value, $expires)>.

If supplied, I<URI::Fetch> will store the page content, ETag, and
last-modified time of the response in the cache, and will pull the
content from the cache on subsequent requests if the page returns a
Not-Modified response.

=item * UserAgent

Optional.  You may provide your own LWP::UserAgent instance.  Look
into L<LWPx::ParanoidUserAgent> if you're fetching URLs given to you
by possibly malicious parties.

=item * NoNetwork

Optional.  Controls the interaction between the cache and HTTP
requests with If-Modified-Since/If-None-Match headers.  Possible
behaviors are:

=over

=item false (default)

If a page is in the cache, the origin HTTP server is always checked
for a fresher copy with an If-Modified-Since and/or If-None-Match
header.

=item C<1>

If set to C<1>, the origin HTTP is never contacted, regardless of the
page being in cache or not.  If the page is missing from cache, the
fetch method will return undef.  If the page is in cache, that page
will be returned, no matter how old it is.  Note that setting this
option means the L<URI::Fetch::Response> object will never have the
http_response member set.

=item C<N>, where N E<gt> 1

The origin HTTP server is not contacted B<if> the page is in cache
B<and> the cached page was inserted in the last N seconds.  If the
cached copy is older than N seconds, a normal HTTP request (full or
cache check) is done.

=back

=item * ContentAlterHook

Optional.  A subref that gets called with a scalar reference to your
content so you can modify the content before it's returned and before
it's put in cache.

For instance, you may want to only cache the E<lt>headE<gt> section of
an HTML document, or you may want to take a feed URL and cache only a
pre-parsed version of it.  If you modify the scalarref given to your
hook and change it into a hashref, scalarref, or some blessed object,
that same value will be returned to you later on not-modified
responses.

=item * CacheEntryGrep

Optional.  A subref that gets called with the I<URI::Fetch::Response>
object about to be cached (with the contents already possibly transformed by
your C<ContentAlterHook>).  If your subref returns true, the page goes
into the cache.  If false, it doesn't.

=item * Freeze

=item * Thaw

Optional. Subrefs that get called to serialize and deserialize, respectively,
the data that will be cached. The cached data should be assumed to be an
arbitrary Perl data structure, containing (potentially) references to
arrays, hashes, etc.

Freeze should serialize the structure into a scalar; Thaw should
deserialize the scalar into a data structure.

By default, I<Storable> will be used for freezing and thawing the cached
data structure.

=item * ForceResponse

Optional. A boolean that indicates a I<URI::Fetch::Response>
should be returned regardless of the HTTP status. By
default C<undef> is returned when a response is not a
"success" (200 codes) or one of the recognized HTTP status
codes listed above. The HTTP status message can then be retreived 
using the C<errstr> method on the class.

=back

=head1 LICENSE

I<URI::Fetch> is free software; you may redistribute it and/or modify it
under the same terms as Perl itself.

=head1 AUTHOR & COPYRIGHT

Except where otherwise noted, I<URI::Fetch> is Copyright 2004 Benjamin
Trott, ben+cpan@stupidfool.org. All rights reserved.

=cut
