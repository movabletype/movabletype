# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Memcached;
use strict;

sub new {
    my $class = shift;
    my $cfg = MT->config;

    if (my @servers = $cfg->MemcachedServers) {
        my $driver_class = $cfg->MemcachedDriver;
        eval "require $driver_class;";
        my $ns = $cfg->MemcachedNamespace;
        return bless {
            memcached => $driver_class->new({
                servers => \@servers,
                ( $ns ? ( namespace => $ns ) : () ),
                debug   => 0,
            })
        }, $class;
    } else {
        return bless { }, $class;
    }
}

{
my $Is_Available;
sub is_available {
    return $Is_Available if defined $Is_Available;
    my $class = shift;
    my @servers = MT->config->MemcachedServers;
    my $driver_class = MT->config->MemcachedDriver;
    $Is_Available = @servers > 0 && eval "require $driver_class;" ? 1 : 0;
    return $Is_Available;
}
}

our $Instance;
sub instance {
    return $Instance ||= shift->new;
}

sub cleanup {
    undef $Instance;
    my $driver_class = MT->config->MemcachedDriver;
    if ($driver_class->can('disconnect_all')) {
        $driver_class->disconnect_all;
    }
}

# method for MT::Cache interface
sub purge_stale {
    1;
}

sub DESTROY { }

sub AUTOLOAD {
    my $cache = shift;
    (my $method = our $AUTOLOAD) =~ s/^.*:://;
    return unless $cache->{memcached};
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

=head2 MT::Memcached->instance

Returns the singleton object (a I<MT::Memcached> object).

=head2 MT::Memcached->is_available

Returns true if there are memcached servers defined in your Movable Type
configuration and if the I<Cache::Memcached> module can be loaded.

=head2 MT::Memcached->cleanup

Removes the singleton instance of the class, and disconnects any open
connections to I<memcached>.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
