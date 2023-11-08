#!/usr/bin/perl -w

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::App;
use MT::Author;

$test_env->prepare_fixture('db_data');
my $user = MT::Author->load(2);

my $app = MT::Test::App->new('MT::App::CMS');
$app->login($user);

local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
$app->post_ok({
    __mode => 'change_to_pc_view',
});

done_testing;
