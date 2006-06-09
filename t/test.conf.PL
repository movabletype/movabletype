#!/usr/bin/perl
use strict;
use warnings;
use IO::File;
(my $f = $0 ) =~ s/\.PL$//;
my $fh = IO::File->new( '> ' . $f );
print $fh $_ while <DATA>;
close $fh;
__DATA__
__FOO__ = 0
