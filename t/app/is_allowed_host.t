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

use MT::Test::App;

$test_env->prepare_fixture('db');

my $test_app = MT::Test::App->new('MT::App::CMS');
my $app      = $test_app->_app;

if ($app->component('cloud')) {
    plan skip_all => 'Cloud.pack is installed';
}

subtest 'no TrustedHosts' => sub {
    is $app->config->TrustedHosts, 0;
    ok !$app->is_allowed_host('example.com');
};

subtest 'exact match with TrustedHosts' => sub {
    $app->config->TrustedHosts('example.com');
    $app->config->TrustedHosts('sub.example.com');
    die unless scalar $app->config->TrustedHosts == 2;

    ok $app->is_allowed_host('example.com');
    ok $app->is_allowed_host('sub.example.com');
    ok !$app->is_allowed_host('sub2.example.com');
};

subtest 'wildcard' => sub {
    $app->config->TrustedHosts('*');

    ok $app->is_allowed_host('example.com');
    ok $app->is_allowed_host('sub.example.com');
    ok $app->is_allowed_host('sub2.example.com');
};

subtest 'wildcard subdomain' => sub {
    $app->config->TrustedHosts([]);
    die unless $app->config->TrustedHosts == 0;
    $app->config->TrustedHosts('*.example.com');

    ok !$app->is_allowed_host('example.com');
    ok $app->is_allowed_host('sub.example.com');
    ok $app->is_allowed_host('sub2.example.com');
    ok !$app->is_allowed_host('subsub.sub.example.com');
    ok !$app->is_allowed_host('sub4 sub3.example.com');
    ok $app->is_allowed_host('sub-5.example.com');
    ok $app->is_allowed_host('sub_6.example.com');
};

subtest 'wildcard subdomain (MTC-30564)' => sub {
    $app->config->TrustedHosts([]);
    die unless $app->config->TrustedHosts == 0;
    $app->config->TrustedHosts('*.111.111.111');

    ok !$app->is_allowed_host('111.111.111.111');
};

done_testing;
