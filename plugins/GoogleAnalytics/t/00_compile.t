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

use_ok('GoogleAnalytics');
use_ok('GoogleAnalytics::App');
use_ok('GoogleAnalytics::OAuth2');
use_ok('GoogleAnalytics::Provider');

done_testing;
