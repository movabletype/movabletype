# -*- perl -*-

package Bundle::Image::Info::PNG;

use strict;
use vars qw($VERSION);
$VERSION = '0.02';

1;

__END__

=head1 NAME

Bundle::Image::Info::PNG - full PNG support for Image::Info

=head1 SYNOPSIS

=for test_synopsis BEGIN { die "SKIP: shell code\n"; }

 perl -MCPAN -e 'install Bundle::Image::Info::PNG'

=head1 CONTENTS

Image::Info - the base Image::Info module

Compress::Zlib - reading compressed zTXt chunks in PNG files

=head1 DESCRIPTION

This bundle installs everything needed to get full PNG support into
L<Image::Info>. Without L<Compress::Zlib> the ability to decompress
zTXt chunks is missing.

=head1 AUTHOR

Slaven Rezic <srezic@cpan.org>

=cut
