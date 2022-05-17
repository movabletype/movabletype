#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;

use_ok('GoogleAnalyticsV4');
use_ok('GoogleAnalyticsV4::App');
use_ok('GoogleAnalyticsV4::OAuth2');
use_ok('GoogleAnalyticsV4::Provider');

done_testing;