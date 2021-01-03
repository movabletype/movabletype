# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Cache::Negotiate;

use strict;
use warnings;

sub new {
    my $class = shift;
    my (%param) = @_;
    $param{'ttl'} ||= 0;

    require MT::Memcached;
    if ( MT::Memcached->is_available ) {
        $param{'__cache_driver'} = MT::Memcached->instance;
        if ( $param{'expirable'} ) {
            require MT::Memcached::ExpirableProxy;
            $param{'__cache_driver'}
                = MT::Memcached::ExpirableProxy->new( %param,
                'memcached' => $param{'__cache_driver'} );
        }
    }
    else {
        require MT::Cache::Session;
        $param{'__cache_driver'} = MT::Cache::Session->new(%param);
    }

    my $self = bless \%param, $class;
    return $self;
}

sub AUTOLOAD {
    my $self = shift;
    ( my $method = our $AUTOLOAD ) =~ s/^.*:://;
    return unless $self->{'__cache_driver'};
    return $self->{'__cache_driver'}->$method(@_);
}

1;
__END__

=head1 NAME

MT::Cache::Negotiate - Utility package to decide whether to cache data
in memcached or in MT::Session table.

=head1 SYNOPSIS

    # MT::Cache::Session uses the 'kind' parameter
    # which accepts namespace of the cache
    my $cache = MT::Cache::Negotiate->new( ttl => 10, kind => 'XX' );
    my $data = $cache->get($key);
    $cache->set($key => $value);
    my $hash = $cache->get_multi($key1, $key2);
