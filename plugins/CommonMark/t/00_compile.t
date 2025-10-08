#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    plan skip_all => 'Requires Perl 5.26' if $] < 5.026;

    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use lib qw(plugins/CommonMark/lib);

use MT;

use_ok('CommonMark');

done_testing;
