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

plan tests => 3;

use lib qw( plugins/MultiBlog plugins/MultiBlog/lib );
use MT;

$MT::plugin_envelope = 'plugins/MultiBlog';    # Supress warning.
require_ok('multiblog.pl');

require_ok('MultiBlog');
require_ok('MultiBlog::Tags');
