#!/usr/bin/perl -w
# $Id: 09-image.t 2713 2008-07-04 05:01:40Z bchoate $

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

use vars qw( @Img @drivers $TESTS_FOR_EACH );
BEGIN {
    $TESTS_FOR_EACH = 25;

    @Img = (
        [ 'test.gif', 400, 300 ],
        [ 'test.jpg', 640, 480 ],
        [ 'test.png', 150, 150 ],
    );
    @drivers = qw( ImageMagick NetPBM GD Imager );
    plan tests => scalar @Img                                        # file exists
                + (scalar @Img * scalar @drivers * $TESTS_FOR_EACH)  # each image by each driver
                + 1                                                  # no driver test
                ;
}

MT->set_language('en-us');

my $File = "test.file";
my $String = "testing";
my $cfg = MT::ConfigMgr->instance;
my $tested = 0;
for my $rec (@Img) {
    my ($img_filename, $img_width, $img_height) = @$rec;
    my $img_file = File::Spec->catfile($ENV{MT_HOME}, 't', 'images', $img_filename);
    ok(-B $img_file, "$img_file looks like a binary file");

    for my $driver (@drivers) {
        note( "----Test $driver for file $img_file" );
        $cfg->ImageDriver($driver);
        my $img = MT::Image->new( Filename => $img_file );
SKIP : {
        skip("no $driver for image $img_file", $TESTS_FOR_EACH) unless $img;
        $tested++;
        isa_ok($img, 'MT::Image::' . $driver, "driver for $img_file");
        note( MT::Image->errstr ) if MT::Image->errstr;
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

        my $blob;
        ($blob, $w, $h) = $img->scale(Scale => 50);
        ok($blob, "do scale");
        ($x, $y) = (int($img_width / 2), int($img_height / 2));
        is($w, $x, "result of scaling $img_filename to 50\% with $driver is $x px wide");
        is($h, $y, "result of scaling $img_filename to 50\% with $driver is $y px high");

        undef $blob;
        ($blob, $w, $h) = $img->crop( Size => 50, X => 10, Y => 10 ) or die $img->errstr;

        ok($blob, "do crop");

        ($x, $y) = (50, 50);
        is($w, $x, "result of cropping $img_filename to 50x50 with $driver is $x px wide");
        is($h, $y, "result of cropping $img_filename to 50x50 with $driver is $y px high");

        (my $type = $img_file) =~ s/.*\.//;
        for my $to ( qw( JPG PNG GIF ) ) {
            next if lc $to eq lc $type;
            my $blob = $img->convert( Type => $to);
            ok($blob, "convert $img_filename to $to with $driver");
        }

        open FH, $img_file or die $!;
        binmode FH;
        my $data = do { local $/; <FH> };
        close FH;
        $img = MT::Image->new( Data => $data, Type => $type );

        isa_ok($img, 'MT::Image::' . $driver);
        note( MT::Image->errstr ) if MT::Image->errstr;
        is($img->{width},  $img_width,  "$driver says $img_filename from blob is $img_width px wide");
        is($img->{height}, $img_height, "$driver says $img_filename from blob is $img_height px high");
        ($w, $h) = $img->get_dimensions;
        is($w, $img_width,  "${driver}'s get_dimensions says $img_filename from blob is $img_width px wide");
        is($h, $img_height, "${driver}'s get_dimensions says $img_filename from blob is $img_height px high");
} # END SKIP
    }
}

ok( $tested > 0, 'At least one of image drivers should be tested');
