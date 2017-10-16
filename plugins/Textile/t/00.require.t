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

use lib qw( lib extlib plugins/Textile );

use Test::More;
use MT;

$MT::plugin_envelope = 'plugins/Textile';    # Supress warning.
require_ok('textile2.pl');

done_testing;
