#!/usr/bin/perl -w
# $Id$
use strict;
use warnings;

use lib 't/lib';
use lib 'lib';
use lib 'extlib';

use MT::Test;
use Test::More;
use File::Spec;

use MT::Image;
use MT::ConfigMgr;
use MT;

use vars qw( @Img @drivers );

BEGIN {
    @Img = (
        [ 'test.gif', 233, 68 ],
        [ 'test.jpg', 640, 480 ],
    );
    @drivers = qw( ImageMagick NetPBM GD );
    plan tests => scalar @Img                           # file exists
                + (scalar @Img * scalar @drivers * 19)  # 19 tests each for every image and driver
                ;
}

MT->set_language('en-us');

my $File = "test.file";
my $String = "testing";
my $netpbm = '/usr/local/netpbm/bin';

my $cfg = MT::ConfigMgr->instance;
if (!$cfg->NetPBMPath) {
    $cfg->NetPBMPath($netpbm) if -x $netpbm;
}

for my $rec (@Img) {
    my ($img_filename, $img_width, $img_height) = @$rec;
    my $img_file = File::Spec->catfile($ENV{MT_HOME}, 't', 'images', $img_filename);
    ok(-B $img_file, "$img_file looks like a binary file");

    for my $driver (@drivers) {
        $cfg->ImageDriver($driver);
        my $img = MT::Image->new( Filename => $img_file );
SKIP : {
        skip("no $driver image", 19) unless $img;
        isa_ok($img, 'MT::Image::' . $driver, "driver $driver with image $img_file is an MT::Image::$driver");
#        diag( MT::Image->errstr ) if MT::Image->errstr;

        is($img->{width},  $img_width,  "$driver says $img_filename is $img_width px wide");
        is($img->{height}, $img_height, "$driver says $img_filename is $img_height px high");
        my($w, $h) = $img->get_dimensions();
        is($w, $img_width,  "${driver}'s get_dimensions says $img_filename is $img_width px wide");
        is($h, $img_height, "${driver}'s get_dimensions says $img_filename is $img_height px high");

        ($w, $h) = $img->get_dimensions(Scale => 50);
        my($x, $y) = (int($img_width / 2), int($img_height / 2));
        is($w, $x, "$driver says $img_filename at 50\% scale is $x px wide");
        is($h, $y, "$driver says $img_filename at 50\% scale is $y px high");

        ($w, $h) = $img->get_dimensions();
        is($w, $img_width,  "${driver}'s get_dimensions says $img_filename is still $img_width px wide after theoretical scaling");
        is($h, $img_height, "${driver}'s get_dimensions says $img_filename is still $img_height px high after theoretical scaling");

        ($w, $h) = $img->get_dimensions(Width => 50);
        is($w, 50, "$driver says $img_filename scaled to 50 px wide is 50 px wide");

        ($w, $h) = $img->get_dimensions(Width => 50, Height => 100);
        is($w, 50,  "$driver says $img_filename scaled to 50x100 is 50 px wide");
        is($h, 100, "$driver says $img_filename scaled to 50x100 is 100 px high");

        (my($blob), $w, $h) = $img->scale(Scale => 50);
        ($x, $y) = (int($img_width / 2), int($img_height / 2));
        is($w, $x, "result of scaling $img_filename to 50\% with $driver is $x px wide");
        is($h, $y, "result of scaling $img_filename to 50\% with $driver is $y px high");

        open FH, $img_file or die $!;
        binmode FH;
        my $data = do { local $/; <FH> };
        close FH;
        (my $type = $img_file) =~ s/.*\.//;
        $img = MT::Image->new( Data => $data, Type => $type );
        isa_ok($img, 'MT::Image::' . $driver);
#            diag( MT::Image->errstr ) if MT::Image->errstr;
        is($img->{width},  $img_width,  "$driver says $img_filename from blob is $img_width px wide");
        is($img->{height}, $img_height, "$driver says $img_filename from blob is $img_height px high");
        ($w, $h) = $img->get_dimensions;
        is($w, $img_width,  "${driver}'s get_dimensions says $img_filename from blob is $img_width px wide");
        is($h, $img_height, "${driver}'s get_dimensions says $img_filename from blob is $img_height px high");
} # END SKIP
    }
}
