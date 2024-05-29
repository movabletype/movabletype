# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.

package MT::Util::Deprecated;

use strict;
use warnings;
use Carp;
use utf8;
use base 'Exporter';

our @EXPORT_OK = qw(perl_sha1_digest_hex cc_url cc_rdf cc_name cc_image);

sub warning {
    my (%args) = @_;
    my ($filename, $subroutine) = (caller 1)[1, 3];

    $args{name} ||= $subroutine;

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
            if ( $filename =~ m/^$plugin_path/ ) {
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

my %Data = (
    'by' => {
        name     => 'Attribution',
        abbrev   => 'CC BY 4.0',
        requires => [qw( Attribution Notice )],
        permits  => [qw( Reproduction Distribution DerivativeWorks )],
        url      => 'http://creativecommons.org/licenses/by/4.0/',
    },
    'by-nd' => {
        name     => 'Attribution-NoDerivs',
        abbrev   => 'CC BY-ND 4.0',
        requires => [qw( Attribution Notice )],
        permits  => [qw( Reproduction Distribution )],
        url      => 'http://creativecommons.org/licenses/by-nd/4.0/',
    },
    'by-nc-nd' => {
        name      => 'Attribution-NoDerivs-NonCommercial',
        abbrev    => 'CC BY-NC-ND 4.0',
        requires  => [qw( Attribution Notice )],
        permits   => [qw( Reproduction Distribution )],
        prohibits => [qw( CommercialUse)],
        url       => 'http://creativecommons.org/licenses/by-nc-nd/4.0/',
    },
    'by-nd-nc' => {
        # deprecated; only for 1.0
        name      => 'Attribution-NoDerivs-NonCommercial',
        requires  => [qw( Attribution Notice )],
        permits   => [qw( Reproduction Distribution )],
        prohibits => [qw( CommercialUse)],
    },
    'by-nc' => {
        name      => 'Attribution-NonCommercial',
        abbrev    => 'CC BY-NC 4.0',
        requires  => [qw( Attribution Notice )],
        permits   => [qw( Reproduction Distribution DerivativeWorks )],
        prohibits => [qw( CommercialUse )],
        url       => 'http://creativecommons.org/licenses/by-nc/4.0/',
    },
    'by-nc-sa' => {
        name      => 'Attribution-NonCommercial-ShareAlike',
        abbrev    => 'CC BY-NC-SA 4.0',
        requires  => [qw( Attribution Notice ShareAlike )],
        permits   => [qw( Reproduction Distribution DerivativeWorks )],
        prohibits => [qw( CommercialUse )],
        url       => 'http://creativecommons.org/licenses/by-nc-sa/4.0/',
    },
    'by-sa' => {
        name     => 'Attribution-ShareAlike',
        abbrev   => 'CC BY-SA 4.0',
        requires => [qw( Attribution Notice ShareAlike )],
        permits  => [qw( Reproduction Distribution DerivativeWorks )],
        url      => 'http://creativecommons.org/licenses/by-sa/4.0/',
    },
    'nd' => {
        # only theoretical
        name     => 'NonDerivative',
        requires => [qw( Notice )],
        permits  => [qw( Reproduction Distribution )],
    },
    'nd-nc' => {
        # only theoretical
        name      => 'NonDerivative-NonCommercial',
        requires  => [qw( Notice )],
        permits   => [qw( Reproduction Distribution )],
        prohibits => [qw( CommercialUse )],
    },
    'nc' => {
        # only theoretical
        name      => 'NonCommercial',
        requires  => [qw( Notice )],
        permits   => [qw( Reproduction Distribution DerivativeWorks )],
        prohibits => [qw( CommercialUse )],
    },
    'nc-sa' => {
        # only theoretical
        name      => 'NonCommercial-ShareAlike',
        requires  => [qw( Notice ShareAlike )],
        permits   => [qw( Reproduction Distribution DerivativeWorks )],
        prohibits => [qw( CommercialUse )],
    },
    'sa' => {
        # only theoretical
        name     => 'ShareAlike',
        requires => [qw( Notice ShareAlike )],
        permits  => [qw( Reproduction Distribution DerivativeWorks )],
    },
    'pd' => {
        name    => 'PublicDomain',
        permits => [qw( Reproduction Distribution DerivativeWorks )],
    },
    'pdd' => {
        name    => 'PublicDomainDedication',
        permits => [qw( Reproduction Distribution DerivativeWorks )],
    },
);

sub cc_url {
    MT::Util::Deprecated::warning(since => '8.2.0');
    my ($code) = @_;
    my $url;
    my ($real_code, $license_url, $image_url);
    if (($real_code, $license_url, $image_url) = $code =~ /(\S+) (\S+) (\S+)/) {
        return $license_url;
    }
    $code eq 'pd'
        ? "http://web.resource.org/cc/PublicDomain"
        : "http://creativecommons.org/licenses/$code/1.0/";
}

sub cc_rdf {
    MT::Util::Deprecated::warning(since => '8.2.0');
    my ($code) = @_;
    my $url    = cc_url($code);
    my $rdf    = <<RDF;
<License rdf:about="$url">
RDF
    for my $type (qw( requires permits prohibits )) {
        for my $item (@{ $Data{$code}{$type} }) {
            $rdf .= <<RDF;
<$type rdf:resource="http://web.resource.org/cc/$item" />
RDF
        }
    }
    $rdf . "</License>\n";
}

sub cc_name {
    MT::Util::Deprecated::warning(since => '8.2.0');
    my ($code) = ($_[0] =~ /(\S+) \S+ \S+/);
    $code ||= $_[0];
    $Data{$code}{name};
}

sub cc_image {
    MT::Util::Deprecated::warning(since => '8.2.0');
    my ($code) = @_;
    my $url;
    my ($real_code, $license_url, $image_url);
    if (($real_code, $license_url, $image_url) = $code =~ /(\S+) (\S+) (\S+)/) {
        return $image_url;
    }
    "http://creativecommons.org/images/public/" . ($code eq 'pd' ? 'norights' : 'somerights');
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
