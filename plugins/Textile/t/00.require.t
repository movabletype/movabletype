#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginSwitch => ['Textile/textile2.pl=1'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use lib qw( plugins/Textile );

use MT;

$MT::plugin_sig = 'Textile';
$MT::plugin_envelope = 'plugins/Textile';    # Supress warning.
require_ok('textile2.pl');

done_testing;
