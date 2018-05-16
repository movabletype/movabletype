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

use lib qw(plugins/Markdown);

use MT;

$MT::plugin_envelope = 'plugins/Markdown';    # Supress warning.

$MT::plugin_sig = 'Markdown/Markdown.pl';     # Supress warning.
require_ok('Markdown.pl');

$MT::plugin_sig = 'Markdown/SmartyPants.pl';    # Supress warning.
require_ok('SmartyPants.pl');

done_testing;
