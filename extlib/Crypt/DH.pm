# $Id: DH.pm 1860 2005-06-11 06:15:44Z btrott $

package Crypt::DH;
use strict;

use Math::BigInt lib => "GMP,Pari";
our $VERSION = '0.06';

sub new {
    my $class = shift;
    my $dh = bless {}, $class;

    my %param = @_;
    for my $w (qw( p g priv_key )) {
        next unless exists $param{$w};
        $dh->$w(delete $param{$w});
    }
    die "Unknown parameters to constructor: " . join(", ", keys %param) if %param;

    $dh;
}

BEGIN {
    no strict 'refs';
    for my $meth (qw( p g pub_key priv_key )) {
        *$meth = sub {
            my $key = shift;
            if (@_) {
                $key->{$meth} = _any2bigint(shift);
            }
            my $ret = $key->{$meth} || "";
            $ret;
        };
    }
}

sub _any2bigint {
    my($value) = @_;
    if (ref $value eq 'Math::BigInt') {
        return $value;
    }
    elsif (ref $value eq 'Math::Pari') {
        return Math::BigInt->new(Math::Pari::pari2pv($value));
    }
    elsif (defined $value && !(ref $value)) {
        return Math::BigInt->new($value);
    }
    elsif (defined $value) {
        die "Unknown parameter type: $value\n";
    }
}

sub generate_keys {
    my $dh = shift;

    unless (defined $dh->{priv_key}) {
        my $i = _bitsize($dh->{p}) - 1;
        $dh->{priv_key} =
            $Crypt::Random::VERSION ?
            Crypt::Random::makerandom_itv(Strength => 0, Uniform => 1,
                                          Lower => 1, Upper => $dh->{p} - 1) :
            _makerandom_itv($i, 1, $dh->{p} - 1);
    }

    $dh->{pub_key} = $dh->{g}->copy->bmodpow($dh->{priv_key}, $dh->{p});
}

sub compute_key {
    my $dh = shift;
    my $pub_key = _any2bigint(shift);
    $pub_key->copy->bmodpow($dh->{priv_key}, $dh->{p});
}
*compute_secret = \&compute_key;

sub _bitsize {
    return length($_[0]->as_bin) - 2;
}

sub _makerandom_itv {
    my ($size, $min_inc, $max_exc) = @_;

    while (1) {
        my $r = _makerandom($size);
        return $r if $r >= $min_inc && $r < $max_exc;
    }
}

sub _makerandom {
    my $size = shift;

    my $bytes = int($size / 8) + ($size % 8 ? 1 : 0);

    my $rand;
    if (-e "/dev/urandom") {
        my $fh;
        open($fh, '/dev/urandom')
            or die "Couldn't open /dev/urandom";
        my $got = sysread $fh, $rand, $bytes;
        die "Didn't read all bytes from urandom" unless $got == $bytes;
        close $fh;
    } else {
        for (1..$bytes) {
            $rand .= chr(int(rand(256)));
        }
    }

    my $bits = unpack("b*", $rand);
    die unless length($bits) >= $size;

    Math::BigInt->new('0b' . substr($bits, 0, $size));
}

1;
__END__

=head1 NAME

Crypt::DH - Diffie-Hellman key exchange system

=head1 SYNOPSIS

    use Crypt::DH;
    my $dh = Crypt::DH->new;
    $dh->g($g);
    $dh->p($p);

    ## Generate public and private keys.
    $dh->generate_keys;

    $my_pub_key = $dh->pub_key;

    ## Send $my_pub_key to "other" party, and receive "other"
    ## public key in return.

    ## Now compute shared secret from "other" public key.
    my $shared_secret = $dh->compute_secret( $other_pub_key );

=head1 DESCRIPTION

I<Crypt::DH> is a Perl implementation of the Diffie-Hellman key
exchange system. Diffie-Hellman is an algorithm by which two
parties can agree on a shared secret key, known only to them.
The secret is negotiated over an insecure network without the
two parties ever passing the actual shared secret, or their
private keys, between them.

=head1 THE ALGORITHM

The algorithm generally works as follows: Party A and Party B
choose a property I<p> and a property I<g>; these properties are
shared by both parties. Each party then computes a random private
key integer I<priv_key>, where the length of I<priv_key> is at
most (number of bits in I<p>) - 1. Each party then computes a
public key based on I<g>, I<priv_key>, and I<p>; the exact value
is

    g ^ priv_key mod p

The parties exchange these public keys.

The shared secret key is generated based on the exchanged public
key, the private key, and I<p>. If the public key of Party B is
denoted I<pub_key_B>, then the shared secret is equal to

    pub_key_B ^ priv_key mod p

The mathematical principles involved insure that both parties will
generate the same shared secret key.

More information can be found in PKCS #3 (Diffie-Hellman Key
Agreement Standard):

    http://www.rsasecurity.com/rsalabs/pkcs/pkcs-3/

=head1 USAGE

I<Crypt::DH> implements the core routines needed to use
Diffie-Hellman key exchange. To actually use the algorithm,
you'll need to start with values for I<p> and I<g>; I<p> is a
large prime, and I<g> is a base which must be larger than 0
and less than I<p>.

I<Crypt::DH> uses I<Math::BigInt> internally for big-integer
calculations. All accessor methods (I<p>, I<g>, I<priv_key>, and
I<pub_key>) thus return I<Math::BigInt> objects, as does the
I<compute_secret> method.  The accessors, however, allow setting with a
scalar decimal string, hex string (^0x), Math::BigInt object, or
Math::Pari object (for backwards compatibility).

=head2 $dh = Crypt::DH->new([ %param ]).

Constructs a new I<Crypt::DH> object and returns the object.
I<%param> may include none, some, or all of the keys I<p>, I<g>, and
I<priv_key>.

=head2 $dh->p([ $p ])

Given an argument I<$p>, sets the I<p> parameter (large prime) for
this I<Crypt::DH> object.

Returns the current value of I<p>.  (as a Math::BigInt object)

=head2 $dh->g([ $g ])

Given an argument I<$g>, sets the I<g> parameter (base) for
this I<Crypt::DH> object.

Returns the current value of I<g>.

=head2 $dh->generate_keys

Generates the public and private key portions of the I<Crypt::DH>
object, assuming that you've already filled I<p> and I<g> with
appropriate values.

If you've provided a priv_key, it's used, otherwise a random priv_key
is created using either Crypt::Random (if already loaded), or
/dev/urandom, or Perl's rand, in that order.

=head2 $dh->compute_secret( $public_key )

Given the public key I<$public_key> of Party B (the party with which
you're performing key negotiation and exchange), computes the shared
secret key, based on that public key, your own private key, and your
own large prime value (I<p>).

The historical method name "compute_key" is aliased to this for
compatibility.

=head2 $dh->priv_key([ $priv_key ])

Returns the private key.  Given an argument I<$priv_key>, sets the
I<priv_key> parameter for this I<Crypt::DH> object.

=head2 $dh->pub_key

Returns the public key.

=head1 AUTHOR & COPYRIGHT

Benjamin Trott, ben@rhumba.pair.com

Brad Fitzpatrick, brad@danga.com

Except where otherwise noted, Crypt::DH is Copyright 2001
Benjamin Trott. All rights reserved. Crypt::DH is free
software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=cut
