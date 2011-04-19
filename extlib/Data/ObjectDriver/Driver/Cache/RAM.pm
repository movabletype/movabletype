# $Id$

package Data::ObjectDriver::Driver::Cache::RAM;
use strict;
use warnings;

use base qw( Data::ObjectDriver::Driver::BaseCache );

my %Cache;

sub init {
    my $driver = shift;
    my %param  = @_;
    $param{cache} ||= 1; # hack
    $driver->SUPER::init(%param);
}

sub get_from_cache {
    my $driver = shift;

    $driver->start_query('RAMCACHE_GET ?', \@_);
    my $ret = $Cache{$_[0]};
    $driver->end_query(undef);

    return if !defined $ret;
    return $ret;
}

sub add_to_cache {
    my $driver = shift;

    $driver->start_query('RAMCACHE_ADD ?', \@_);
    my $ret = $Cache{$_[0]} = $_[1];
    $driver->end_query(undef);

    return if !defined $ret;
    return $ret;
}

sub update_cache {
    my $driver = shift;

    $driver->start_query('RAMCACHE_SET ?', \@_);
    my $ret = $Cache{$_[0]} = $_[1];
    $driver->end_query(undef);

    return if !defined $ret;
    return $ret;
}

sub remove_from_cache {
    my $driver = shift;

    $driver->start_query('RAMCACHE_DELETE ?', \@_);
    my $ret = delete $Cache{$_[0]};
    $driver->end_query(undef);

    return if !defined $ret;
    return $ret;
}

sub clear_cache {
    my $driver = shift;

    $driver->start_query('RAMCACHE_CLEAR');
    %Cache = ();
    $driver->end_query(undef);

    return;
}

1;
