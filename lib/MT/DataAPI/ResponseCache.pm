# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::ResponseCache;

use strict;
use warnings;
use utf8;

use Digest::MD5;
use MT::Util qw(iso2ts ts2epoch);
use Storable qw(nfreeze thaw);

our $disabled;
our $cache_driver;

sub filter {
    my ( $cb, $app, $condition ) = @_;
    $$condition &&= ( lc( $app->request_method ) eq 'get' )
        && !$app->get_header('X-MT-Authorization');
}

sub is_cache_request {
    my $class = shift;
    my ($app) = @_;

    my $condition = 1;
    $app->run_callbacks( 'data_api_response_cache_filter', $app,
        \$condition );

    $condition;
}

sub new_cache_driver {
    my $class = shift;
    my ($app) = @_;
    $app ||= MT->instance;

    my $driver_class = $app->config('DataAPIResponseCacheDriver')
        || (
        $app->config('MemcachedServers')
        ? 'MT::Memcached'
        : 'MT::Cache::File'
        );
    eval "require $driver_class" or die $@;
    $driver_class->new;
}

sub cache_driver {
    my $class = shift;
    my ($app) = @_;

    $cache_driver ||= $class->new_cache_driver(@_);
}

sub set {
    my $class = shift;
    my ( $app, $mime_type, $data ) = @_;

    if ( $class->is_cache_request($app) ) {
        my $cache_data = nfreeze(
            {   time      => time(),
                mime_type => $mime_type,
                headers   => $app->{cgi_headers},
                rendered_headers =>
                    $app->{query}->header( %{ $app->{cgi_headers} } ),
                body => $data,
            }
        );

        my $driver = $class->cache_driver($app);
        $driver->set(
            MT::DataAPI::ResponseCache::cache_key($app) => $cache_data );
    }
}

sub _do_with_app {
    my $class = shift;
    my ( $app, $sub ) = @_;

    if ( !$app ) {
        require MT::App::Minimal;

        local (
            $MT::MT_DIR,   $MT::APP_DIR, $MT::CFG_DIR,
            $MT::CFG_FILE, $MT::SCRIPT_SUFFIX
        );
        local (
            $MT::plugin_sig,      $MT::plugin_envelope,
            $MT::plugin_registry, %MT::Plugins,
            @MT::Components,      %MT::Components,
            $MT::DebugMode,       $MT::mt_inst,
            %MT::mt_inst
        );
        local ($MT::ConfigMgr::cfg);

        $app = MT::App::Minimal->new;

        $sub->( $class, $app );
    }
    else {
        $sub->( $class, $app );
    }
}

our $driver;

sub _get_internal {
    my $class = shift;
    my ($app) = @_;

    my $driver = $class->cache_driver($app);

    my $do_init_db = do {
        if ( $driver->isa('MT::Cache::Session') ) {
            1;
        }
        elsif ( $driver->isa('MT::Cache::Negotiate') ) {
            require MT::Memcached;
            !MT::Memcached->is_available;
        }
        else {
            0;
        }
    };
    $app->init_db if $do_init_db && $app->can('init_db');

    my $regexp   = $app->config('DataAPIResponseCacheBlogRegexp');
    my @blog_ids = ( $app->path_info =~ m{$regexp} );
    unshift @blog_ids, ( @blog_ids ? 0 : 'all' );

    my $cache_key = MT::DataAPI::ResponseCache::cache_key($app);

    my $response;
    my $touched_on = 0;
    my $hash       = $driver->get_multi( $cache_key,
        map {"blog_id::${_}::touch"} @blog_ids );

    while ( my ( $k, $v ) = each %$hash ) {
        if ( $k eq $cache_key ) {
            $response = thaw($v);
        }
        else {
            if ( $v =~ m/\w+:(\d+)/ ) {
                $touched_on = $1 if $1 > $touched_on;
            }
        }
    }

    ( $response && $response->{time} > $touched_on ) ? $response : undef;
}

sub get {
    my $class = shift;
    my ($app) = @_;

    return undef if $disabled;

    $class->_do_with_app( $app, \&_get_internal );
}

sub cache_key {
    my ($q) = @_;
    'response_cache_'
        . Digest::MD5::md5_hex( $q->path_info . '?'
            . ( $ENV{'QUERY_STRING'} || $ENV{'REDIRECT_QUERY_STRING'} || '' )
            . '#'
            . ( $q->get_header('X-MT-Authorization') || '' ) );
}

sub touch_post_save {
    my ( $cb, $touch ) = @_;
    my $app   = MT->instance;
    my $blogs = $app->request('DataAPIResponseCacheTouched')
        || $app->request( 'DataAPIResponseCacheTouched', {} );
    $blogs->{ $touch->blog_id } = 1;
}

sub update_touch {
    my ( $cb, $app ) = @_;
    my $blogs = {
        %{ $app->request('DataAPIResponseCacheTouched') || {} },
        %{ $app->request('blogs_touched') || {} }
    };
    __PACKAGE__->collect_touch( $_, $app ) for keys %$blogs;
}

sub disable {
    my $class = shift;
    $disabled = scalar @_ ? $_[0] : 1;
}

sub collect_touch {
    my $class = shift;
    my ( $blog_id, $app ) = @_;
    $app ||= MT->instance;

    my $driver      = $class->cache_driver($app);
    my $touch_class = $app->model('touch');

    my @objs = $touch_class->load( { blog_id => $blog_id },
        { sort => 'modified_on', direction => 'descend' } );

    $driver->set(
        'blog_id::' . $blog_id . '::touch' => join(
            ',',
            map {
                $_->object_type . ':'
                    . ts2epoch( undef, iso2ts( undef, $_->modified_on ), 1 );
            } @objs
        )
    );

    my $iter = $touch_class->max_group_by(
        undef,
        {   group     => ['object_type'],
            max       => 'modified_on',
            direction => 'descend'
        }
    );
    my @tuples = ();
    while ( my ( $modified_on, $object_type ) = $iter->() ) {
        push @tuples,
            $object_type . ':'
            . ts2epoch( undef, iso2ts( undef, $modified_on ), 1 );
    }
    $driver->set( 'blog_id::all::touch' => join( ',', @tuples ) );
}

1;
__END__

=head1 NAME

MT::DataAPI::ResponseCache

=head1 SYNOPSIS

The I<MT::DataAPI::ResponseCache> module manages cache corresponding
to the response of URL.

=cut
