# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Memcached::ExpirableProxy;

use strict;
use warnings;
use MT::Memcached;

sub new {
    my $class = shift;
    my (%param) = @_;
    $param{ttl} ||= 0;
    $param{memcached} ||= MT::Memcached->instance;
    my $self = bless \%param, $class;
    return $self;
}

sub _is_expired {
    my $self    = shift;
    my $ttl     = $self->{ttl};
    my ($value) = @_;
    !( ref $value && ( !$ttl || $value->{start} >= time() - $ttl ) );
}

sub get {
    my $self  = shift;
    my $value = $self->{memcached}->get(@_);
    if ($value) {
        if ( $self->_is_expired($value) ) {
            $self->{memcached}->delete(@_);
            return undef;
        }
        else {
            return $value->{data};
        }
    }
    else {
        return undef;
    }
}

sub get_multi {
    my $self = shift;
    my $hash = $self->{memcached}->get_multi(@_);
    my $ttl  = $self->{ttl};

    for my $k ( keys(%$hash) ) {
        next unless defined( $hash->{$k} );

        my $value = $hash->{$k};
        if ( $self->_is_expired($value) ) {
            $hash->{$k} = undef;
            $self->{memcached}->delete($k);
        }
        else {
            $hash->{$k} = $value->{data};
        }
    }

    return $hash;
}

sub add {
    _set( 'add', @_ );
}

sub replace {
    _set( 'replace', @_ );
}

sub set {
    _set( 'set', @_ );
}

sub _set {
    my $method = shift;
    my $self   = shift;
    my ( $key, $value, $exptime ) = @_;

    $value = {
        start => time(),
        data  => $value,
    };

    $self->{memcached}->$method( $key, $value, $exptime );
}

sub AUTOLOAD {
    my $self = shift;
    ( my $method = our $AUTOLOAD ) =~ s/^.*:://;
    return unless $self->{memcached};
    return $self->{memcached}->$method(@_);
}

1;
__END__

=head1 NAME

MT::Memcached::ExpirableProxy - Enable I<MT::Memcached> to check expiration time when getting a value.

=head1 SYNOPSIS

    my $driver = MT::Memcached::ExpirableProxy->new(ttl => $ttl);
    my $data = $driver->get($key);
    $driver->set($key => $value);

=head1 DESCRIPTION


I<MT::Memcached::ExpirableProxy> enable I<MT::Memcached> to check expiration
time when getting a value.

=head1 USAGE

See the I<MT::Memcached> and I<Cache::Memcached> documentation for information
on the available methods.

In addition, this class defines the following:

=head2 MT::Memcached::ExpirableProxy->new(%param)

Create new instance with the following parameters.

=over 4

=item * ttl

Delete a cached value if I<ttl> seconds have passed since saving when getting.
a value.

=item * memcached

Specify a memcached instance explicitly.

=back

=head1 EXAMPLE

    my $ttl = 4;

    my $driver = MT::Memcached::ExpirableProxy->new(ttl => $ttl);
    $driver->set($key => $value);

    $ttl = 2;
    sleep $ttl;

    $driver = MT::Memcached::ExpirableProxy->new(ttl => $ttl);
    $driver->get($key); # => undef

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
