# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ObjectDriver::Driver::CacheWrapper;

use strict;
use warnings;
use MT;

my $CACHE_ENABLED;

sub wrap {
    my $class = shift;
    my ( $fallback, $object_class ) = @_;

    # prevent caching if so configured
    unless ( defined $CACHE_ENABLED ) {
        $CACHE_ENABLED = MT->config->DisableObjectCache ? 0 : 1;
    }
    my $use_caching = 1;
    if ( $CACHE_ENABLED && $object_class ) {
        if ( my $props = $object_class->properties ) {
            $use_caching = 0
                if ( defined $props->{cacheable} )
                && ( !$props->{cacheable} );
        }
    }
    elsif ( !$CACHE_ENABLED ) {
        $use_caching = 0;
    }

    if ($use_caching) {
        ## If running under mod_perl, using request->pnotes; otherwise,
        ## just use a hash.
        my $ram_cache;
        if ( MT::Util::is_mod_perl1() ) {
            require Data::ObjectDriver::Driver::Cache::Apache;
            $ram_cache = 'Data::ObjectDriver::Driver::Cache::Apache';
        }
        else {
            require MT::ObjectDriver::Driver::Cache::RAM;
            $ram_cache = 'MT::ObjectDriver::Driver::Cache::RAM';
        }

        my $driver;

        require MT::Memcached;
        if ( MT::Memcached->is_available ) {
            $driver = sub {
                ## Look first in mod_perl/memory; then in memcached; then fall back
                ## to hitting the database.
                require Data::ObjectDriver::Driver::Cache::Memcached;
                $ram_cache->new(
                    fallback =>
                        Data::ObjectDriver::Driver::Cache::Memcached->new(
                        cache    => MT::Memcached->instance,
                        fallback => $fallback->(),
                        )
                );
            };
        }
        else {
            $driver = sub {
                return $ram_cache->new( fallback => $fallback->(), );
            };
        }
        return $driver;
    }
    else {
        return $fallback;
    }
}

1;
