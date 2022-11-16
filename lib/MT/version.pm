# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::version;

use strict;
use warnings;

use version;

sub parse {
    my $class = shift;
    my ($version_string) = @_;
    version->parse( _add_patch_version_if_needed($version_string) );
}

sub _add_patch_version_if_needed {
    my ($version_string) = @_;
    $version_string =~ s/\A(v?[0-9]+(?:\.[0-9]+)?(?:\.[0-9]+)?).*\z/$1/ if $version_string;
    $version_string ||= '0';
    if ( $version_string =~ /^[0-9]+\.[0-9]+$/ ) {
        return "$version_string.0";
    }
    else {
        return $version_string;
    }
}

1;

__END__

=head1 NAME

MT::verson - Movable Type version string parser

=head1 SYNOPSIS

    use MT::version;

    my $true = MT::version->parse( '7.1' ) > MT::version->parse( '7.0.1' );

=head1 DESCRIPTION

I<MT::version> is version string parser. I<parse> class method parses version string
and returns I<version> object.

=head2 MT::version->parse($version_string)

Parses version string and returns I<version> object.

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut

