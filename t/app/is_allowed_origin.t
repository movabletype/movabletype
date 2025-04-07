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

subtest 'empty string' => sub {
    is $app->is_allowed_origin(''), '';
};

subtest 'error: invalid $origin parameter.' => sub {
    local $@;
    eval { $app->is_allowed_origin('invalid $origin') };
    like $@, qr/\AInvalid \$origin parameter\./;
};

subtest 'no TrustedHosts' => sub {
    is $app->config->TrustedHosts,                     0;
    is $app->is_allowed_origin('https://example.com'), '';
};

subtest 'exact match with TrustedHosts' => sub {
    $app->config->TrustedHosts('example.com');
    $app->config->TrustedHosts('sub.example.com');
    die unless scalar $app->config->TrustedHosts == 2;

    is $app->is_allowed_origin('http://example.com'),       'http://example.com';
    is $app->is_allowed_origin('http://sub.example.com'),   'http://sub.example.com';
    is $app->is_allowed_origin('https://sub2.example.com'), '';
};

subtest 'wildcard' => sub {
    $app->config->TrustedHosts('*');

    is $app->is_allowed_origin('http://example.com'),       'http://example.com';
    is $app->is_allowed_origin('http://sub.example.com'),   'http://sub.example.com';
    is $app->is_allowed_origin('https://sub2.example.com'), 'https://sub2.example.com';
};

subtest 'wildcard subdomain' => sub {
    $app->config->TrustedHosts([]);
    die unless $app->config->TrustedHosts == 0;
    $app->config->TrustedHosts('*.example.com');

    is $app->is_allowed_origin('http://example.com'),             '';
    is $app->is_allowed_origin('http://sub.example.com'),         'http://sub.example.com';
    is $app->is_allowed_origin('https://sub2.example.com'),       'https://sub2.example.com';
    is $app->is_allowed_origin('https://subsub.sub.example.com'), '';
};

done_testing;
