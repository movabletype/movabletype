use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new();
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;

$test_env->prepare_fixture('db');

my $app = MT::App->instance;
my $ua  = $app->new_ua;
is $ua->agent, 'MovableType/' . $MT::VERSION, 'default UA: ' . $ua->agent;

$ua = $app->new_ua({ agent => 'Test-MT-Agent/1.0' });
is $ua->agent, 'Test-MT-Agent/1.0', 'set UA: ' . $ua->agent;

done_testing;
