package Math::Random::MT::Perl;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = 1.15;

my $N = 624;
my $M = 397;
my $UP_MASK  = 0x80000000;
my $LOW_MASK = 0x7fffffff;

my $gen = undef;


sub new {
    # Create a Math::Random::MT::Perl object
    my ($class, @seeds) = @_;
    my $self = {};
    bless $self, $class;
    # Seed the random number generator
    $self->set_seed(@seeds);
    return $self;
}


sub rand {
    # Generate a random number in requested range
    my ($self, $range) = @_;
    if (ref $self) {
        return ($range || 1) * $self->_mt_genrand();
    }
    else {
        $range = $self;
        Math::Random::MT::Perl::srand() unless defined $gen;
        return ($range || 1) * $gen->_mt_genrand();
    }
}


sub irand {
    # Generate a random integer
    my ($self) = @_;
    if (ref $self) {
        return $self->_mt_genirand();
    }
    else {
        Math::Random::MT::Perl::srand() unless defined $gen;
        return $gen->_mt_genirand();
    }
}


sub get_seed {
    # Get the seed
    my ($self) = @_;
    return $self->{seed};
}


sub set_seed {
    # Set the seed
    my ($self, @seeds) = @_;
    $self->{mt} = undef;
    $self->{mti} = undef;
    $self->{seed} = undef;
    @seeds > 1 ? $self->_mt_setup_array(@seeds) :
                 $self->_mt_init_seed(defined $seeds[0] ? $seeds[0] : _rand_seed());
    return $self->{seed};
}


sub srand {
    # Seed the random number generator, automatically generating a seed if none
    # is provided
    my (@seeds) = @_;
    if (not @seeds) {
      $seeds[0] = _rand_seed();
    }
    $gen = Math::Random::MT::Perl->new(@seeds);
    my $seed = $gen->get_seed;
    return $seed;
}


sub _rand_seed {
    my ($self) = @_;

    # Get a seed at random through Perl's CORE::rand(). We do not call
    # CORE::srand() to avoid altering the random numbers that other parts of
    # the running script might be using. The seeds obtained by rapid calls to
    # the _rand_seed() function are all different.
    
    return int(CORE::rand(2**32));
}


# Note that we need to use integer some of the time to force integer overflow
# rollover ie 2**32+1 => 0. Unfortunately we really want uint but integer
# casts to signed ints, thus we can't do everything within an integer block,
# specifically the bitshift xor functions below. The & 0xffffffff is required
# to constrain the integer to 32 bits on 64 bit systems.

sub _mt_init_seed {
    my ($self, $seed) = @_;
    my @mt;
    $mt[0] = $seed & 0xffffffff;
    for ( my $i = 1; $i < $N; $i++ ) {
        my $xor = $mt[$i-1]^($mt[$i-1]>>30);
        { use integer; $mt[$i] = (1812433253 * $xor + $i) & 0xffffffff }
    }
    $self->{mt} = \@mt;
    $self->{mti} = $N;
    $self->{seed} = ${$self->{mt}}[0];
}


sub _mt_setup_array {
    my ($self, @seeds) = @_;
    @seeds = map{ $_ & 0xffffffff }@seeds;  # limit seeds to 32 bits
    $self->_mt_init_seed( 19650218 );
    my @mt = @{$self->{mt}};
    my $i = 1;
    my $j = 0;
    my $n = @seeds;
    my $k = $N > $n ? $N : $n;
    my ($uint32, $xor);
    for (; $k; $k--) {
        $xor = $mt[$i-1] ^ ($mt[$i-1] >> 30);
        { use integer; $uint32 = ($xor * 1664525) & 0xffffffff }
        $mt[$i] = ($mt[$i] ^ $uint32);
        { use integer; $mt[$i] = ($mt[$i] + $seeds[$j] + $j) & 0xffffffff }
        $i++; $j++;
        if ($i>=$N) { $mt[0] = $mt[$N-1]; $i=1; }
        if ($j>=$n) { $j=0; }
    }
    for ($k=$N-1; $k; $k--) {
        $xor = $mt[$i-1] ^ ($mt[$i-1] >> 30);
        { use integer; $uint32 = ($xor * 1566083941) & 0xffffffff }
        $mt[$i] = ($mt[$i] ^ $uint32) - $i;
        $i++;
        if ($i>=$N) { $mt[0] = $mt[$N-1]; $i=1; }
    }
    $mt[0] = 0x80000000;
    $self->{mt} = \@mt;
    $self->{seed} = ${$self->{mt}}[0];
}


sub _mt_genrand {
    my ($self) = @_;
    return $self->_mt_genirand*(1.0/4294967296.0);
}


sub _mt_genirand {
    my ($self) = @_;
    my ($kk, $y);
    my @mag01 = (0x0, 0x9908b0df);
    if ($self->{mti} >= $N) {
        for ($kk = 0; $kk < $N-$M; $kk++) {
            $y = ($self->{mt}->[$kk] & $UP_MASK) | ($self->{mt}->[$kk+1] & $LOW_MASK);
            $self->{mt}->[$kk] = $self->{mt}->[$kk+$M] ^ ($y >> 1) ^ $mag01[$y & 1];
        }
        for (; $kk < $N-1; $kk++) {
            $y = ($self->{mt}->[$kk] & $UP_MASK) | ($self->{mt}->[$kk+1] & $LOW_MASK);
            $self->{mt}->[$kk] = $self->{mt}->[$kk+($M-$N)] ^ ($y >> 1) ^ $mag01[$y & 1];
        }
        $y = ($self->{mt}->[$N-1] & $UP_MASK) | ($self->{mt}->[0] & $LOW_MASK);
        $self->{mt}->[$N-1] = $self->{mt}->[$M-1] ^ ($y >> 1) ^ $mag01[$y & 1];
        $self->{mti} = 0;
    }
    $y  = $self->{mt}->[$self->{mti}++];
    $y ^= $y >> 11;
    $y ^= ($y <<  7) & 0x9d2c5680;
    $y ^= ($y << 15) & 0xefc60000;
    $y ^= $y >> 18;
    return $y;
}


sub import {
    no strict 'refs';
    my $pkg = caller;
    for my $sym (@_) {
       *{"${pkg}::$sym"} = \&$sym  if $sym eq "srand" or $sym eq "rand" or $sym eq "irand";
    }
}


1;

__END__

=pod

=for stopwords Abhijit Makoto Menon-Sen Mersenne Nishimura Takuji almut characterised crypto perlmonks pseudorandom gmail

=head1 NAME

Math::Random::MT::Perl - Pure Perl Mersenne Twister Random Number Generator

=head1 SYNOPSIS

  ## Object-oriented interface:
  use Math::Random::MT::Perl;
  $gen = Math::Random::MT->new()        # or...
  $gen = Math::Random::MT->new($seed);  # or...
  $gen = Math::Random::MT->new(@seeds);
  $seed = $gen->get_seed();             # seed generating the random numbers
  $rand = $gen->rand(42);               # random number in the interval [0, 42)
  $dice = int($gen->rand(6)+1);         # random integer between 1 and 6
  $coin = $gen->rand() < 0.5 ?          # flip a coin
    "heads" : "tails"
  $int = $gen->irand();                 # random integer in [0, 2^32-1]

  ## Function-oriented interface
  use Math::Random::MT::Perl qw(srand rand irand);
  # now use srand() and rand() as you usually do in Perl

=head1 DESCRIPTION

Pure Perl implementation of the Mersenne Twister algorithm. Mersenne Twister is
a 32 bit pseudorandom number generator developed by Makoto Matsumoto and Takuji
Nishimura. The algorithm is characterised by a very uniform distribution but is
not cryptographically secure. What this means in real terms is that it is fine
for modeling but no good for crypto.

Internally, unsigned 32 bit integers are used. The range of possible values for
such integers is 0 .. 4,294,967,295 (0..2**32-1). The generator takes a random
integer from within this range and multiplies it by (1.0/4294967296.0). As a
result the range of possible return values is 0 .. 0.999999999767169. This
number is then multiplied by the argument passed to rand (default=1). In other
words the maximum return value from rand will always be slightly less than the
argument - it will never equal that argument. Only the first 10 digits of the
returned float are mathematically significant.

Math::Random::MT::Perl implements the same pseudorandom number generator found
in Math::Random::MT (implemented in C/XS): their interface and output should be
identical.

=head2 Object-oriented interface

=over

=item new()

Creates a new generator. It can be provided with a single unsigned 32-bit
integer, an array of them, or nothing. If no argument is passed, it is
automatically seeded with a random seed.

=item set_seed()

Seeds the generator and returns the seed used. It takes the same arguments as
I<new()>.

=item get_seed()

Retrieves the value of the seed used.

=item rand($num)

Behaves exactly like Perl's builtin I<rand()>, returning a number uniformly
distributed in [0, $num) ($num defaults to 1), except that the underlying
complexity is 32 bits rather than a fraction of it (~15).

=item irand()

Returns a 32-bit integer, i.e. an integer uniformly distributed in [0, 2^32-1].

=back

=head2 Functional interface

=over

=item srand()

Seed the random number generator. It takes the same arguments as I<new()>, but
returns the seed used. It is strongly recommended that you call I<srand()>
explicitly before you call I<rand()> for the first time.

=item rand($num)

Behaves exactly like Perl's builtin I<rand()>, returning a number uniformly
distributed in [0, $num) ($num defaults to 1), except that the underlying
complexity is 32 bits rather than a fraction of it (~15).

=item irand()

Returns a 32-bit integer, i.e. an integer uniformly distributed in [0, 2^32-1].

=back

=head2 Export

Nothing by default. I<rand()> and I<srand()> on demand.

=head1 SPEED

Runs around 1/3 as fast as the C code of Math::Random::MT, however that still
means a random number generation speed of 100,000/sec on modest hardware.

=head1 SEE ALSO

Math::Random::MT

http://www.math.keio.ac.jp/~matumoto/emt.html

=head1 BUGS

Please report bugs at L<http://rt.cpan.org/Dist/Display.html?Name=Math-Random-MT-Perl>.

The latest development code can be obtained from the git repository
L<git://github.com/fangly/Math-Random-MT-Perl.git>.

=head1 AUTHOR

Dr James Freeman <airmedical [at] gmail [dot] com>

=head1 MAINTAINER

Florent Angly <florent.angly@gmail.com>

=head1 CREDITS

almut from perlmonks for 64 bit debug and fix.

Abhijit Menon-Sen, Philip Newton and Sean M. Burke who contributed to
Math::Random::MT as this module is mostly a translation.

=head1 COPYRIGHT AND LICENSE

(c) Dr James Freeman 2000-08. All rights reserved.

This package is free software and is provided "as is" without express or
implied warranty. It may be used, redistributed and/or modified under the
terms of the Artistic License 2.0. A copy is included in this distribution.

=cut
