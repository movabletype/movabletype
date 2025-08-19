# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.

package MT::Util::Deprecated;

use strict;
use warnings;
use Carp;
use utf8;
use base 'Exporter';
use Cwd;
use File::Spec;
use List::Util qw(sum);

our @EXPORT_OK = qw(perl_sha1_digest_hex);

sub warning {
    my (%args) = @_;
    my ($filename, $subroutine) = (caller)[1, 3];
    $filename = Cwd::realpath($filename) unless File::Spec->file_name_is_absolute($filename);
    $filename =~ s!\\!/!g if $^O eq 'MSWin32';

    $args{name} ||= $subroutine || 'main';

    my $msg;
    local $Carp::CarpLevel = 1;
    if ($args{alterative}) {
        $msg = Carp::shortmess sprintf("%s is deprecated and will be removed in the future. Use %s instead.", $args{name}, $args{alterative});
    } else {
        $msg = Carp::shortmess sprintf("%s is deprecated and will be removed in the future.", $args{name});
    }

    for my $sig (keys %MT::Plugins) {
        my $plugin = $MT::Plugins{$sig}{object};
        if ( $plugin && $plugin->path ) {
            my $plugin_path = $plugin->path;
            $plugin_path =~ s!\\!/!g if $^O eq 'MSWin32';
            if ( $filename =~ m/^\Q$plugin_path\E/ ) {
                eval {
                    MT->log(
                        {   class    => 'plugin',
                            category => $plugin->log_category_for_deprecated_fn,
                            message  => MT->translate( "[_1] plugin is using deprecated call.", $sig ),
                            metadata => $msg,
                        }
                    );
                }
            }
        }
    }
    require MT::Util::Log;
    MT::Util::Log::init();
    chomp($msg);
    MT::Util::Log->warn($msg);
}

{
    eval { require bytes; 1; };

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
