# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.

package MT::Util::Deprecated;

use strict;
use warnings;
use Carp;
use utf8;
use base 'Exporter';

our @EXPORT_OK = qw(
    dsa_verify dec2bin bin2dec
    perl_sha1_digest perl_sha1_digest_hex perl_sha1_digest_base64
);

sub warning {
    my (%args) = @_;

    $args{name} ||= (caller 1)[3];

    my $msg;
    local $Carp::CarpLevel = 1;
    if ($args{alterative}) {
        $msg = Carp::shortmess sprintf("%s is deprecated and will be removed in the future. Use %s instead.", $args{name}, $args{alterative});
    } else {
        $msg = Carp::shortmess sprintf("%s is deprecated and will be removed in the future.", $args{name});
    }
    require MT::Util::Log;
    MT::Util::Log::init();
    chomp($msg);
    MT::Util::Log->warn($msg);
}

{
    eval { require bytes; 1; };

    sub addbin {
        my ( $left, $right ) = @_;
        my $length
            = ( length $left > length $right ? length $left : length $right );

        $left  = "\0" x ( $length - ( length $left ) ) . $left;
        $right = "\0" x ( $length - ( length $right ) ) . $right;
        my $carry  = 0;
        my $result = '';
        for ( my $i = 1; $i <= $length; $i++ ) {
            my $left_digit  = ord( substr( $left,  -$i, 1 ) );
            my $right_digit = ord( substr( $right, -$i, 1 ) );
            my $rdigit      = $left_digit + $right_digit + $carry;
            $carry  = $rdigit / 256;
            $result = chr( $rdigit % 256 ) . $result;
        }
        if ($carry) {
            return $result = chr($carry) . $result;
        }
        else {
            return $result;
        }
    }

    sub multbindec {
        my ( $a, $b ) = @_;

        # $b is decimal-ascii, $b < 256
        my @result;
        $result[ ( length $a ) ] = 0;
        for ( my $i = 1; $i <= length $a; $i++ ) {
            my $adigit = substr( $a, -$i, 1 );
            $result[ -$i ] = ord($adigit) * $b;
        }

        for ( my $i = 2; $i <= scalar @result; $i++ ) {
            $result[ -$i ] += int( $result[ -$i + 1 ] / 256 );
            $result[ -$i + 1 ] = $result[ -$i + 1 ] % 256;
        }

        shift @result while ( @result && ( $result[0] == 0 ) );

        pack( 'C*', @result );
    }

    sub divbindec {
        my ( $a, $b ) = @_;

        # $b is decimal-ascii, $b < 256

        my $acc = ord( substr( $a, 0, 1 ) );
        my $quot;
        while ( length $a ) {
            $a = substr( $a, 1 );
            $quot .= chr( $acc / $b );
            $acc = $acc % $b;
            if ( length $a ) {
                $acc = $acc * 256 + ord( substr( $a, 0, 1 ) );
            }
        }
        return ( $quot, $acc );
    }

    sub dec2bin {
        MT::Util::Deprecated::warning(since => '7.8');

        my ($decimal) = @_;
        my @digits = split //, $decimal;
        my $result = "";
        foreach my $d (@digits) {
            $result = multbindec( $result, 10 );
            $result = addbin( pack( 'c', $d ), $result );
        }
        while ( substr( $result, 0, 1 ) eq "\0" ) {
            $result = substr( $result, 1 );
        }
        $result;
    }

    sub bin2dec {
        MT::Util::Deprecated::warning(since => '7.8');

        my $bin    = $_[0];
        my $result = '';
        my $rem    = 0;
        while ( ( length $bin ) && ( $bin ne "\0" ) ) {
            ( $bin, $rem ) = divbindec( $bin, 10 );
            $result = $rem . $result;
            $bin = substr( $bin, 1 ) if ( substr( $bin, 0, 1 ) eq "\0" );
        }
        $result;
    }

    sub perl_sha1_digest
    {    # thanks to Adam Back for the starting point of this
        # XXX: suppress this warning until this function is not used in the core (too noisy)
        # warn "perl_sha1_digest() is deprecated and will be removed in the future.";

        my ($message) = @_;
        my $init_string
            = 'D9T4C`>_-JXF8NMS^$#)4=L/2X?!:@GF9;MGKH8\;O-S*8L\'6';

        # 67452301 efcdab89 98badcfe 10325476 c3d2e1f0
        my @A = unpack "N*", unpack 'u', $init_string;
        my @K = splice @A, 5, 4;
        sub M { my ( $x, $m ); ( $x = pop ) - ( $m = 1 + ~0 ) * int $x / $m }; # modulo 0x100000000

        sub L {
            my ( $n, $x );
            $n = pop;
            ( ( $x = pop ) << $n | 2**$n - 1 & $x >> 32 - $n ) & (0xffffffff);
        }    # left-rotate bit vector
             # magic SHA1 functions
        my @F = (
            sub { my ( $a, $b, $c, $d ) = @_; $b & ( $c ^ $d ) ^ $d },
            sub { my ( $a, $b, $c, $d ) = @_; $b ^ $c ^ $d },
            sub { my ( $a, $b, $c, $d ) = @_; ( $b | $c ) & $d | $b & $c },
            sub { my ( $a, $b, $c, $d ) = @_; $b ^ $c ^ $d }
        );
        my $F = sub {
            my $which = shift;
            my ( $a, $b, $c, $d ) = @_;
            if ( $which == 0 ) { $b & ( $c ^ $d ) ^ $d }
            elsif ( $which == 1 ) { $b ^ $c ^ $d }
            elsif ( $which == 2 ) { ( $b | $c ) & $d | $b & $c }
            elsif ( $which == 3 ) { $b ^ $c ^ $d }
        };

        my ( $l, $r, $p, $t, @W, $P );
        do {
            $P = substr( $message, 0, 64 );
            $message = length $message >= 64 ? substr( $message, 64 ) : "";
            $l += $r = length $P;
            $r++, $P .= "\x80" if $r < 64 && !$p++;
            @W = unpack 'N16', $P . "\0" x ( 64 - length($P) );
            $W[15] = $l * 8 if $r < 57;
            for ( 16 .. 79 ) {
                push @W,
                    L(
                    $W[ $_ - 3 ] ^ $W[ $_ - 8 ] ^ $W[ $_ - 14 ]
                        ^ $W[ $_ - 16 ],
                    1
                    );
            }
            my ( $a, $b, $c, $d, $e ) = @A;
            for ( 0 .. 79 ) {
                $t = M(
                      ( $F->( int( $_ / 20 ), $a, $b, $c, $d ) )
                    + $e + $W[$_]
                        + $K[ $_ / 20 ]
                        + L $a,
                    5
                );
                $e = $d;
                $d = $c;
                $c = L( $b, 30 );
                $b = $a;
                $a = $t;
            }
            $A[0] = M( $A[0] + $a );
            $A[1] = M( $A[1] + $b );
            $A[2] = M( $A[2] + $c );
            $A[3] = M( $A[3] + $d );
            $A[4] = M( $A[4] + $e );
        } while $r > 56;

        pack( 'N*', @A[ 0 .. 4 ] );
    }
}

sub perl_sha1_digest_hex {
    # XXX: suppress this warning until this function is not used in the core (too noisy)
    # warn "Old Pure Perl implementation of perl_sha1_digest_hex() is deprecated and will be removed in the future.";

    sprintf( "%.8x" x 5, unpack( 'N*', &perl_sha1_digest(@_) ) );
}

sub perl_sha1_digest_base64 {
    MT::Util::Deprecated::warning(since => '7.8');

    require MIME::Base64;
    MIME::Base64::encode_base64( perl_sha1_digest(@_), '' );
}

{
    my $has_crypt_dsa;

    sub dsa_verify {
        my %param = @_;

        MT::Util::Deprecated::warning(since => '7.8');

        unless ( defined $has_crypt_dsa ) {
            eval { require Crypt::DSA; };
            $has_crypt_dsa = $@ ? 0 : 1;
        }
        if ( $has_crypt_dsa && !$param{ForcePerl} ) {
            $param{Key} = bless $param{Key}, 'Crypt::DSA::Key';
            $param{Signature} = bless $param{Signature},
                'Crypt::DSA::Signature';
            return Crypt::DSA->new->verify(%param);
        }
        else {
            require Math::BigInt;

            my ( $key, $dgst, $sig );

            Carp::croak __PACKAGE__ . "dsa_verify: Need a Key"
                unless $key = $param{Key};

            unless ( $dgst = $param{Digest} ) {
                Carp::croak "dsa_verify: Need either Message or Digest"
                    unless $param{Message};
                $dgst = perl_sha1_digest( $param{Message} );
            }
            Carp::croak "dsa_verify: Need a Signature"
                unless $sig = $param{Signature};
            my $r       = new Math::BigInt( $sig->{r} );
            my $s       = new Math::BigInt( $sig->{'s'} );
            my $p       = new Math::BigInt( $key->{p} );
            my $q       = new Math::BigInt( $key->{'q'} );
            my $g       = new Math::BigInt( $key->{g} );
            my $pub_key = new Math::BigInt( $key->{pub_key} );
            my $u2      = $s->bmodinv($q);

            my $u1 = new Math::BigInt( "0x" . unpack( "H*", $dgst ) );

            $u1 = $u1->bmul($u2)->bmod($q);
            $u2 = $r->bmul($u2)->bmod($q);
            my $t1 = $g->bmodpow( $u1, $p );
            my $t2 = $pub_key->bmodpow( $u2, $p );
            $u1 = $t1->bmul($t2)->bmod( $key->{p} );
            $u1 = $u1->bmod( $key->{'q'} );
            my $result = $u1->bcmp( $sig->{r} );
            return defined($result) ? $result == 0 : 0;
        }
    }
}

1;

__END__

=head1 NAME

MT::Util::Deprecated - Deprecated Movable Type utility functions

=head1 SYNOPSIS

    use MT::Util::Deprecated qw( functions );

=head1 DESCRIPTION

I<MT::Util::Deprecated> provides a variety of deprecated utility functions
used by the Movable Type libraries. These functions should not be used any more,
and will be removed in the future.

=head1 FUNCTIONS

=head2 warning

Warning deprecation.

    warning(since => '7.8');

Warning starts immidiately on server log.

=over 4

=item * since

The version number in string that indicates staring version of deprecation. Note that the option is only for
source code notation and has nothing to do with the actual behavior.

=item * alternative

If any, the option suggests an alternative to the function.

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
