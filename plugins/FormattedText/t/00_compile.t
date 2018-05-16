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

BEGIN {
	use File::Basename qw( dirname );
	use File::Spec;
	my $plugin_home = dirname(dirname(File::Spec->rel2abs(__FILE__)));
	push @INC, "$plugin_home/lib", "$plugin_home/extlib";
}

use MT;

use_ok('FormattedText');
use_ok('FormattedText::FormattedText');
use_ok('FormattedText::App');

done_testing;
