# -*- perl -*-

package Bundle::Image::Info::SVG;

use strict;
use vars qw($VERSION);
$VERSION = '0.02';

1;

__END__

=head1 NAME

Bundle::Image::Info::SVG - SVG support for Image::Info

=head1 SYNOPSIS

=for test_synopsis BEGIN { die "SKIP: shell code\n"; }

 perl -MCPAN -e 'install Bundle::Image::Info::SVG'

=head1 CONTENTS

Image::Info - the base Image::Info module

XML::LibXML::Reader - parsing the SVG file as XML data

XML::Simple - convert SVG description elements into perl data structures

=head1 DESCRIPTION

This bundle installs everything needed to get SVG support into
L<Image::Info>.

=head1 AUTHOR

Slaven Rezic <srezic@cpan.org>

=cut
