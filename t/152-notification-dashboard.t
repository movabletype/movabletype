#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test qw(:app :db);
use MT::Test::Permission;

my $admin = MT::Author->load(1);

my $app = _run_app(
    'MT::App::CMS',
    {   __test_user => $admin,
        __mode      => 'dashboard',
        blog_id     => 0,
    },
);
ok( !$app->param('loop_notification_dashboard'),
    'Message center does not use param().'
);

done_testing;
