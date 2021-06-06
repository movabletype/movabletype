#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
use lib "$FindBin::Bin/lib";
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file( "lib/Comments.pm", 'package Comments; use strict; 1;' );
    unshift @INC, $test_env->path('lib');
}

use MT;
use MT::Test;
use MT::CMS::RebuildTrigger;

MT::Test->init_db;

my $app = MT->instance;

subtest 'add param basic' => sub {
    my $a = MT::CMS::RebuildTrigger::object_type_loop_plugin_reduced($app);
    note explain($a);
    is(@$a, 3, 'right number of loop');
};

subtest 'add param plugin disabled' => sub {
    $app->config->PluginSwitch->{Comments} = 0;
    my $a = MT::CMS::RebuildTrigger::object_type_loop_plugin_reduced($app);
    note explain($a);
    is(@$a, 2, 'right number of loop');
    delete $app->config->PluginSwitch->{Comments};
};

done_testing;
