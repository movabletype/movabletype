# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Memcached;
use strict;
use warnings;

sub new {
    my $class = shift;
    my $cfg   = MT->config;

    if ( my @servers = $cfg->MemcachedServers ) {
        my $driver_class = $cfg->MemcachedDriver;
        eval "require $driver_class;";
        my $ns = $cfg->MemcachedNamespace;
        return bless {
            memcached => $driver_class->new(
                {   servers => \@servers,
                    ( $ns ? ( namespace => $ns ) : () ),
                    (   $driver_class eq 'Cache::Memcached'
                        ? ( debug => 0 )
                        : ()
                    ),
                }
            )
        }, $class;
    }
    else {
        return bless {}, $class;
    }
}

my $Is_Available;

sub is_available {
    return if MT->instance->{disable_memcached};
    return $Is_Available if defined $Is_Available;
    my $class        = shift;
    my @servers      = MT->config->MemcachedServers;
    my $driver_class = MT->config->MemcachedDriver;
    $Is_Available = @servers > 0 && eval "require $driver_class;" ? 1 : 0;
    return $Is_Available;
}

our $Instance;

sub instance {
    return $Instance ||= shift->new;
}

sub cleanup {
    undef $Instance;
    undef $Is_Available;
    my $driver_class = MT->config->MemcachedDriver;
    if ( $driver_class->can('disconnect_all') ) {
        $driver_class->disconnect_all;
    }
}

# method for MT::Cache interface
sub purge_stale {
    1;
}

sub __validate_key {
    my $method = shift;

    return 1 if 'disconnect_all' eq $method or 'flush_all' eq $method;

    my @keys;
    if ( 'get_multi' eq $method ) {
        (@keys) = @_;
    }
    else {
        push @keys, shift;
    }

    foreach my $k (@keys) {
        return if $k =~ /[\x00-\x20\x7f-\xff]/ || length($k) > 200;
    }
    1;
}

sub DESTROY { }

sub AUTOLOAD {
    my $cache = shift;
    ( my $method = our $AUTOLOAD ) =~ s/^.*:://;
    return unless $cache->{memcached};
    return unless __validate_key( $method, @_ );
    return $cache->{memcached}->$method(@_);
}

1;
__END__

=head1 NAME

MT::Memcached - Handy wrapper class for Cache::Memcached

=head1 SYNOPSIS

    my $cache = MT::Memcached->instance;
    my $data = $cache->get($key);
    $cache->set($key => $value);

=head1 DESCRIPTION

I<MT::Memcached> provides a singleton wrapper interface around
I<Cache::Memcached>. It automatically loads up the I<Cache::Memcached>
object with the server information defined in the Movable Type
configuration file, in the C<MemcachedServers> variable.

If your server environment doesn't have I<Cache::Memcached> installed,
or if no C<MemcachedServers> are defined in your configuration, all of
the methods on this class are essentially no-ops. This is handy from the
perspective of the calling code, because it can act the same way whether
or not there's a cache defined.

=head1 USAGE

See the I<Cache::Memcached> documentation for information on the
available methods.

In addition, this class defines the following:


=head2 MT::Memcached->new

=head2 MT::Memcached->instance

Returns the singleton object (a I<MT::Memcached> object).

=head2 MT::Memcached->is_available

Returns true if there are memcached servers defined in your Movable Type
configuration and if the I<Cache::Memcached> module can be loaded.

=head2 MT::Memcached->cleanup

Removes the singleton instance of the class, and disconnects any open
connections to I<memcached>.

=head2 MT::Memcached->purge_stale

This is a method for MT::Cache interface. Do nothing.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
