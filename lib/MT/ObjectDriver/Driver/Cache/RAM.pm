# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ObjectDriver::Driver::Cache::RAM;

use strict;
use warnings;

use base qw( Data::ObjectDriver::Driver::BaseCache );

my $cache_limit;

sub MAX_CACHE_SIZE () {
    return $cache_limit if defined $cache_limit;
    return $cache_limit = MT->config->ObjectCacheLimit || 1000;
}

my %Cache;

my $trigger_installed;

sub init {
    my $driver = shift;
    my %param  = @_;
    $param{cache} ||= 1;    # hack

    unless ( defined $trigger_installed ) {
        MT->add_callback( 'take_down', 9, undef, \&takedown );
        $trigger_installed = 1;
    }

    $driver->SUPER::init(%param);
}

sub takedown {
    __PACKAGE__->clear_cache;
}

sub get_from_cache {
    my $driver = shift;

    $driver->start_query( 'RAMCACHE_GET ?', \@_ );
    my $ret = $Cache{ $_[0] };
    $driver->end_query(undef);

    return if !defined $ret;
    return $ret;
}

sub add_to_cache {
    my $driver = shift;

    if ( scalar keys %Cache > MAX_CACHE_SIZE ) {
        $driver->clear_cache();
    }

    $driver->start_query( 'RAMCACHE_ADD ?', \@_ );
    my $ret = $Cache{ $_[0] } = $_[1];
    $driver->end_query(undef);

    return if !defined $ret;
    return $ret;
}

sub update_cache {
    my $driver = shift;

    $driver->start_query( 'RAMCACHE_SET ?', \@_ );
    my $ret = $Cache{ $_[0] } = $_[1];
    $driver->end_query(undef);

    return if !defined $ret;
    return $ret;
}

sub remove_from_cache {
    my $driver = shift;

    $driver->start_query( 'RAMCACHE_DELETE ?', \@_ );
    my $ret = delete $Cache{ $_[0] };
    $driver->end_query(undef);

    return if !defined $ret;
    return $ret;
}

sub clear_cache {
    my $driver = shift;

    $driver->start_query('RAMCACHE_CLEAR') if ref $driver;
    %Cache = ();
    $driver->end_query(undef) if ref $driver;

    return;
}

1;
