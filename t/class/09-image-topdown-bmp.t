use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Image;
use MT::Test::Image;
use Image::Size;

BEGIN {
    # Actually both GD and NetPBM supports BMP but MT::Image:: drivrers for them don't recognize it
    my $driver = MT->config->ImageDriver;
    plan skip_all => "$driver (for MT) does not support BMP" if $driver =~ /GD|NetPBM/;
}

my ($guard, $img_file) = MT::Test::Image->tempfile(
    DIR     => $test_env->root,
    SUFFIX  => ".bmp",
    TOPDOWN => 1,
);

my ($image_size_width, $image_size_height) = eval { Image::Size::imgsize($img_file) };
is $image_size_width => 600, "correct width";
isnt $image_size_height => 450, "incorrect height";

my $img = MT::Image->new(Filename => $img_file);

my ($width, $height, $type) = $img->get_image_info(Filename => $img_file);
is $width => 600, "correct width";
is $height => 450, "correct height";

done_testing;
