# -*- perl -*-

package Bundle::Image::Info::Everything;

use strict;
use vars qw($VERSION);
$VERSION = '0.02';

1;

__END__

=head1 NAME

Bundle::Image::Info::Everything - complete support for Image::Info

=head1 SYNOPSIS

=for test_synopsis BEGIN { die "SKIP: shell code\n"; }

 perl -MCPAN -e 'install Bundle::Image::Info::Everything'

=head1 CONTENTS

Image::Info - the base Image::Info module

Compress::Zlib - everything for PNG processing

XML::LibXML::Reader - everything for SVG processing

XML::Simple - everything for SVG processing

Image::Xbm 1.07 - everything for XBM processing

Image::Xpm 1.10 - everything for XPM processing

=head1 DESCRIPTION

This bundle installs everything needed for L<Image::Info>.

=head2 SOURCE LIST

The L</CONTENTS> list is created by manually resolving all the
contents in the following Bundle files:

=over

=item Bundle::Image::Info::PNG

=item Bundle::Image::Info::SVG

=item Bundle::Image::Info::XBM

=item Bundle::Image::Info::XPM

=back

Unfortunately the L<CPAN> module cannot cope with recursively defined
Bundles, so this had to be done.

=head1 AUTHOR

Slaven Rezic <srezic@cpan.org>

=cut
