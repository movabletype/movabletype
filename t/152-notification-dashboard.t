#!/usr/bin/perl

use strict;
use warnings;

use lib qw( lib extlib ../lib ../extlib t/lib );

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use MT;
use MT::Test qw(:app :db);
use MT::Test::Permission;
use Test::More;

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
