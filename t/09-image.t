#!/usr/bin/perl -w
# $Id$
use strict;
use warnings;

use lib 't/lib';
use lib 'lib';
use lib 'extlib';

use Test::More;
use File::Spec;

use MT::Image;
use MT::ConfigMgr;
use MT;

use vars qw( $BASE @Img @drivers );

require 't/test-common.pl';

BEGIN {
    @Img = (
        [ 'test.gif', 233, 68 ],
        [ 'test.jpg', 640, 480 ],
    );
    @drivers = qw( ImageMagick NetPBM );
    plan tests => scalar @Img + scalar @Img * scalar @drivers * 17;
}

MT->set_language('en-us');

my $File = "test.file";
my $String = "testing";
my $netpbm = '/usr/local/netpbm/bin';

my $cfg = MT::ConfigMgr->instance;
$cfg->NetPBMPath($netpbm) if -x $netpbm;

for my $rec (@Img) {
    my $img_file = File::Spec->catfile($BASE, 't', 'images', $rec->[0]);
    ok(-B $img_file, "$img_file looks like a binary file");

    for my $driver (@drivers) {
        $cfg->ImageDriver($driver);
        my $img = MT::Image->new( Filename => $img_file );
SKIP : {
        skip("no $driver image", 17) unless $img;
        isa_ok($img, 'MT::Image::' . $driver);
#        diag( MT::Image->errstr ) if MT::Image->errstr;

        is($img->{width}, $rec->[1], "width is $rec->[1]");
        is($img->{height}, $rec->[2], "height is $rec->[2]");
        my($w, $h) = $img->get_dimensions;
        is($w, $rec->[1], "width is $rec->[1]");
        is($h, $rec->[2], "height is $rec->[2]");

        ($w, $h) = $img->get_dimensions(Scale => 50);
        my($x, $y) = (int($img->{width} / 2), int($img->{height} / 2));
        is($w, $x, "width is $x");
        is($h, $y, "height is $y");

        ($w, $h) = $img->get_dimensions(Width => 50);
        is($w, 50, 'width is 50');

        ($w, $h) = $img->get_dimensions(Width => 50, Height => 100);
        is($w, 50, 'width is 50');
        is($h, 100, 'height is 100');

        (my($blob), $w, $h) = $img->scale(Scale => 50);
        ($x, $y) = (int($img->{width} / 2), int($img->{height} / 2));
        is($w, $x, "width is $x");
        is($h, $y, "height is $y");

        open FH, $img_file or die $!;
        binmode FH;
        my $data = do { local $/; <FH> };
        close FH;
        (my $type = $img_file) =~ s/.*\.//;
        $img = MT::Image->new( Data => $data, Type => $type );
        isa_ok($img, 'MT::Image::' . $driver);
#            diag( MT::Image->errstr ) if MT::Image->errstr;
        is($img->{width}, $rec->[1], "width is $rec->[1]");
        is($img->{height}, $rec->[2], "height is $rec->[2]");
        ($w, $h) = $img->get_dimensions;
        is($w, $rec->[1], "width is $rec->[1]");
        is($h, $rec->[2], "height is $rec->[2]");
} # END SKIP
    }
}
