#!/usr/bin/perl

use strict;
use warnings;

my $copyright;
my $year = ( localtime(time) )[5] + 1900;

$copyright
    = "Movable Type (r) (C) 2001-$year Six Apart, Ltd. All Rights Reserved";

my %types = (
    css => 'CSS::Minifier',
    js  => 'JavaScript::Minifier',
);

my $file = shift or die "Usage $0 <file>\n";
die "File not found: $file\n" unless ( -e $file );

require File::Basename;
my $ext = ( File::Basename::fileparse( $file, qr/[A-Za-z0-9]+$/ ) )[2];

unless ( defined $ext && exists( $types{ lc($ext) } ) ) {
    die "$0 can only handle filetypes: " . join( ',', keys %types );
}
else {
    $ext = lc($ext);
    eval("use $types{$ext} qw( minify )");
    if ($@) {

        # don't die here, so it won't interrupt make
        warn sprintf(
            "WARNING, %s FILES CAN'T BE MINIFIED, %s IS NOT INSTALLED, skipped\n",
            $ext, $types{$ext} );
        exit 0;
    }
}

open( INFILE, $file ) or die $!;
my $data = join( '', <INFILE> );
close(INFILE);

open( OUTFILE, '>', $file ) or die $!;
print OUTFILE minify(
    input     => $data,
    copyright => qq|$copyright
 * This file is combined from multiple sources.  Consult the source files for their
 * respective licenses and copyrights.
|,
);
close(OUTFILE);

exit 0;
