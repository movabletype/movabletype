# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: Image.pm 5319 2010-02-22 00:07:51Z auno $

package MT::Image::GraphicsMagick;
use strict;
use warnings;

use base qw( MT::Image::ImageMagick );
use constant MagickClass => 'Graphics::Magick';

$ENV{MAGICK_THREAD_LIMIT} ||= 1;

1;
