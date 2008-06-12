#!/usr/bin/perl
# $Id$
use strict;
use warnings;

use lib 't/lib';
use lib 'lib';
use lib 'extlib';

use MT;
use MT::Test;
use MT::Util;

my @tests = (
    {
        text => 'Siegfried & Roy',
        iso  => 'siegfried_roy',
        utf8 => 'siegfried_roy',
    },
    {
        text => 'Cauchy-Schwartz Inequality',
        iso  => 'cauchy-schwartz_inequality',
        utf8 => 'cauchy-schwartz_inequality',
    },
    {
        text => "M\303\272m",
        utf8 => 'mum',
    },
);

use Test::More tests => 5;

MT->set_language('en_US');

for my $test (@tests) {
    my ($text, $iso, $utf8) = @{ $test }{qw( text iso utf8 )};
    is(MT::Util::iso_dirify($text), $iso, "String '$text' iso_dirifies correctly")
        if $iso;
    is(MT::Util::utf8_dirify($text), $utf8, "String '$text' utf8_dirifies correctly")
        if $utf8;
}

