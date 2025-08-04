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
use MT::Test::Upgrade;

$test_env->prepare_fixture('db');

my $cfg = MT->config;

subtest 'Do nothing when upgrading from 9.x' => sub {
    ok $cfg->DisableContentFieldPermission;
    MT::Test::Upgrade::upgrade(from => 9.0000);
    ok $cfg->DisableContentFieldPermission;
};

subtest 'Set to 0 when upgrading from 8.x' => sub {
    ok $cfg->DisableContentFieldPermission;
    MT::Test::Upgrade::upgrade(from => 8.0002);
    ok !$cfg->DisableContentFieldPermission;
};

subtest 'Set to 0 when upgrading from 7.x' => sub {
    $cfg->DisableContentFieldPermission(1, 1);
    $cfg->save_config;
    ok $cfg->DisableContentFieldPermission;
    MT::Test::Upgrade::upgrade(from => 7.0055);
    ok !$cfg->DisableContentFieldPermission;
};

done_testing;
