#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}
use MT::Test;

MT::Test->init_db;
is(MT->config('DefaultAccessAllowed'), 1); # core default
my $mgr = MT->config;
$mgr->set('DefaultAccessAllowed', 0, 1);   # write explicitly into DB
is(MT->config('DefaultAccessAllowed'), 0); # value retrieved
MT::Test->init_db;
is(MT->config('DefaultAccessAllowed'), 1); # core default again
$mgr->set('DefaultAccessAllowed', 0, 0);
MT::Test->init_db;
is(MT->config('DefaultAccessAllowed'), 0); # file value is prefered

done_testing;
