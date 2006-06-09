#!/usr/bin/perl -w
use strict;

use Test;
use MT::Image;
use MT::ConfigMgr;
use MT;

#BEGIN {
#    @drivers = qw( ImageMagick NetPBM );
    my @drivers = qw( ImageMagick );
    plan tests => 34 * scalar@drivers;
#}

use vars qw( $BASE );
unshift @INC, 't/';
require 'test-common.pl';
use File::Spec;

MT->set_language('en-us');

my @Img = (
    [ 'test.gif', 233, 68 ],
    [ 'test.jpg', 640, 480 ],
);

my $File = "test.file";
my $String = "testing";

my $cfg = MT::ConfigMgr->instance;
$cfg->PBMPath('/usr/local/netpbm/bin');

for my $rec (@Img) {
    my $img_file = File::Spec->catfile($BASE, 't', 'images', $rec->[0]);
    for my $driver (@drivers) {
        $cfg->ImageDriver($driver);
	print "Trying to get $img_file with driver $driver\n";
        my $img = MT::Image->new( Filename => $img_file );
        ok($img);
        if ($img) {
            ok($img->{width}, $rec->[1]);
            ok($img->{height}, $rec->[2]);
            my($w, $h) = $img->get_dimensions;
            ok($w, $rec->[1]);
            ok($h, $rec->[2]);

            ($w, $h) = $img->get_dimensions(Scale => 50);
            ok($w, int($img->{width} / 2));
            ok($h, int($img->{height} / 2));

            ($w, $h) = $img->get_dimensions(Width => 50);
            ok($w, 50);

            ($w, $h) = $img->get_dimensions(Width => 50, Height => 100);
            ok($w, 50);
            ok($h, 100);

            (my($blob), $w, $h) = $img->scale(Scale => 50);
            ok($w, int($img->{width} / 2));
            ok($h, int($img->{height} / 2));

            open FH, $img_file or die $!;
            binmode FH;
            my $data = do { local $/; <FH> };
            close FH;
            (my $type = $img_file) =~ s/.*\.//;
            $img = MT::Image->new( Data => $data, Type => $type );
            ok($img);
            ok($img->{width}, $rec->[1]);
            ok($img->{height}, $rec->[2]);
            ($w, $h) = $img->get_dimensions;
            ok($w, $rec->[1]);
            ok($h, $rec->[2]);
        } else {
            for (2..17) { skip(1); }
        }
    }
}
