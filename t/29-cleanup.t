#!/usr/bin/perl
# $Id: 29-cleanup.t 1098 2007-12-12 01:47:58Z hachi $
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

use File::Path qw( rmtree );
plan tests => 1;

ok( 1, 'cleanup' );
