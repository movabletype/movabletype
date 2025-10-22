#!/usr/bin/perl

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

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

$test_env->prepare_fixture('db');

my $website   = MT::Website->load();
my $blog      = MT::Test::Permission->make_blog(parent_id => $website->id,);
my $blog_name = $blog->name;

my $user_dashboard_unpinned_widget = MT::Test::Permission->make_template(
    name                    => '<user dashboard unpinned widget>',
    type                    => 'dashboard_widget',
    blog_id                 => 0,
    dashboard_widget_pinned => 0,
    text                    => <<MTML,
User Dashboard Unpinned Widget
MTML
);

my $user_dashboard_pinned_widget = MT::Test::Permission->make_template(
    name                    => '<user dashboard pinned widget> ',
    type                    => 'dashboard_widget',
    blog_id                 => 0,
    dashboard_widget_pinned => 1,
    text                    => <<MTML,
<form action="https://external.example.com" method="post">User Dashboard Pinned Widget</form>
MTML
);

my $blog_dashboard_unpinned_widget = MT::Test::Permission->make_template(
    name                    => '<blog dashboard unpinned widget>',
    type                    => 'dashboard_widget',
    blog_id                 => $blog->id,
    dashboard_widget_pinned => 0,
    text                    => <<MTML,
Blog Dashboard Unpinned Widget
MTML
);

my $blog_dashboard_pinned_widget = MT::Test::Permission->make_template(
    name                    => '<blog dashboard pinned widget>',
    type                    => 'dashboard_widget',
    blog_id                 => $blog->id,
    dashboard_widget_pinned => 1,
    text                    => <<MTML,
<form action="https://external.example.com" method="post">Blog Dashboard Pinned Widget for $blog_name</form>
MTML
);

my $admin = MT::Author->load(1);
my $app   = MT::Test::App->new;
$app->login($admin);

subtest 'list_template' => sub {
    subtest 'scope: system' => sub {
        subtest 'without filter_key' => sub {
            $app->get_ok({ __mode => 'list_template' });
            is $app->wq_find('#dashboard_widget-listing')->size, 1;
        };

        subtest 'with filter_key=backup_templates' => sub {
            $app->get_ok({ __mode => 'list_template', filter_key => 'backup_templates' });
            is $app->wq_find('#dashboard_widget-listing')->size, 0;
        };
    };

    subtest 'scope: blog' => sub {
        subtest 'without filter_key' => sub {
            $app->get_ok({ __mode => 'list_template', blog_id => $blog->id });
            is $app->wq_find('#dashboard_widget-listing')->size, 1;
        };

        subtest 'with filter_key=backup_templates' => sub {
            $app->get_ok({ __mode => 'list_template', blog_id => $blog->id, filter_key => 'backup_templates' });
            is $app->wq_find('#dashboard_widget-listing')->size, 0;
        };
    };
};

done_testing;
