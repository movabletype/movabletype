#!/usr/bin/perl

=head1 NAME

Net::OpenID::URIFetch - fetch and cache content from HTTP URLs

=head1 DESCRIPTION

This is roughly based on Ben Trott's URI::Fetch module, but
URI::Fetch doesn't cache enough headers that Yadis can be implemented
with it, so this is a lame copy altered to allow Yadis support.

Hopefully one day URI::Fetch can be modified to do what we need and
this can go away.

This module is tailored to the needs of Net::OpenID::Consumer and probably
isn't much use outside of it. See URI::Fetch for a more general module.

=cut

package Net::OpenID::URIFetch;

use HTTP::Request;
use HTTP::Status;
use strict;
use warnings;
use Carp;

our $HAS_ZLIB;
BEGIN {
    $HAS_ZLIB = eval "use Compress::Zlib (); 1;";
}

use constant URI_OK                => 200;
use constant URI_MOVED_PERMANENTLY => 301;
use constant URI_NOT_MODIFIED      => 304;
use constant URI_GONE              => 410;

sub fetch {
    my ($class, $uri, $consumer, $content_hook) = @_;

    if ($uri eq 'x-xrds-location') {
        Carp::confess("Buh?");
    }

    my $ua = $consumer->ua;
    my $cache = $consumer->cache;
    my $ref;

    # By prefixing the cache key, we can ensure we won't
    # get left-over cache items from older versions of Consumer
    # that used URI::Fetch.
    my $cache_key = 'URIFetch:'.$uri;

    if ($cache) {
        if (my $blob = $cache->get($cache_key)) {
            $ref = Storable::thaw($blob);
        }
    }

    # We just serve anything from the last 60 seconds right out of the cache,
    # thus avoiding doing several requests to the same URL when we do
    # Yadis, then HTML discovery.
    # TODO: Make this tunable?
    if ($ref && $ref->{CacheTime} > (time() - 60)) {
        $consumer->_debug("Cache HIT for $uri");
        return Net::OpenID::URIFetch::Response->new(
            status => 200,
            content => $ref->{Content},
            headers => $ref->{Headers},
            final_uri => $ref->{FinalURI},
        );
    }
    else {
        $consumer->_debug("Cache MISS for $uri");
    }

    my $req = HTTP::Request->new(GET => $uri);
    if ($HAS_ZLIB) {
        $req->header('Accept-Encoding', 'gzip');
    }
    if ($ref) {
        if (my $etag = ($ref->{Headers}->{etag})) {
            $req->header('If-None-Match', $etag);
        }
        if (my $ts = ($ref->{Headers}->{'last-modified'})) {
            $req->if_modified_since($ts);
        }
    }

    my $res = $ua->request($req);

    # There are only a few headers that OpenID/Yadis care about
    my @useful_headers = qw(last-modified etag content-type x-yadis-location x-xrds-location);

    my %response_fields;

    if ($res->code == HTTP::Status::RC_NOT_MODIFIED()) {
        $consumer->_debug("Server says it's not modified. Serving from cache.");
        return Net::OpenID::URIFetch::Response->new(
            status => 200,
            content => $ref->{Content},
            headers => $ref->{Headers},
            final_uri => $ref->{FinalURI},
        );
    }
    else {
        my $content = $res->content;
        my $final_uri = $res->request->uri->as_string();
        my $final_cache_key = "URIFetch:".$final_uri;

        if ($res->content_encoding && $res->content_encoding eq 'gzip') {
            $content = Compress::Zlib::memGunzip($content);
        }

        if ($content_hook) {
            $content_hook->(\$content);
        }

        my $headers = {};
        foreach my $k (@useful_headers) {
            $headers->{$k} = $res->header($k);
        }

        my $ret = Net::OpenID::URIFetch::Response->new(
            status => $res->code,
            content => $content,
            headers => $headers,
            final_uri => $final_uri,
        );

        if ($cache && $res->code == 200) {
            my $cache_data = {
                Headers => $ret->headers,
                Content => $ret->content,
                CacheTime => time(),
                FinalURI => $final_uri,
            };
            my $cache_blob = Storable::freeze($cache_data);
            $cache->set($final_cache_key, $cache_blob);
            $cache->set($cache_key, $cache_blob);
        }

        return $ret;
    }

}

package Net::OpenID::URIFetch::Response;

sub new {
    my ($class, %opts) = @_;

    my $self = {};
    $self->{final_uri} = delete($opts{final_uri});
    $self->{status} = delete($opts{status});
    $self->{content} = delete($opts{content});
    $self->{headers} = delete($opts{headers});

    return bless $self, $class;
}

sub final_uri {
    return $_[0]->{final_uri};
}

sub status {
    return $_[0]->{status};
}

sub content {
    return $_[0]->{content};
}

sub headers {
    return $_[0]->{headers};
}

sub header {
    return $_[0]->{headers}{lc($_[1])};
}

1;
