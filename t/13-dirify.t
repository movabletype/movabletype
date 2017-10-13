#!/usr/bin/perl
# $Id: 13-dirify.t 2562 2008-06-12 05:12:23Z bchoate $
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

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

plan tests => 5;

MT->set_language('en_US');

for my $test (@tests) {
    my ($text, $iso, $utf8) = @{ $test }{qw( text iso utf8 )};
    $text = Encode::decode_utf8($text);
    is(MT::Util::iso_dirify($text), $iso, "String '$text' iso_dirifies correctly")
        if $iso;
    is(MT::Util::utf8_dirify($text), $utf8, "String '$text' utf8_dirifies correctly")
        if $utf8;
}

