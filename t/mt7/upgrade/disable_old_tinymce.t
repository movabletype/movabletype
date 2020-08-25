use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Upgrade;

$test_env->prepare_fixture('db');

my $mt        = MT->instance;
my $cfg       = MT->config;
my $cfg_class = MT->model('config');

subtest 'TinyMCE 0' => sub {
    $cfg->PluginSwitch( 'TinyMCE=0', 1 );
    $cfg->save_config;

    MT::Test::Upgrade->upgrade( from => 7.0046 );

    my $data = $cfg_class->load(1)->data;
    ok( $data =~ /PluginSwitch TinyMCE=0/, 'TinyMCE is (still) disabled' );
};

subtest "TinyMCE 1" => sub {
    $cfg->PluginSwitch( 'TinyMCE=1', 1 );
    $cfg->save_config;

    MT::Test::Upgrade->upgrade( from => 7.0046 );

    my $data = $cfg_class->load(1)->data;
    ok( $data =~ /PluginSwitch TinyMCE=0/, 'TinyMCE is disabled' );
};

done_testing;
