#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
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

subtest 'widgets' => sub {
    subtest 'scope: user' => sub {
        $app->get_ok({ __mode => 'dashboard' });
        my $widget = $app->wq_find('div.dashboard-widget-template');
        ok $widget->html, "test widget exists";
        my $header = $widget->find('h2');
        is $header->html =~ s/^\s+|\s+$//gr, '&lt;user dashboard pinned widget&gt;', 'html escaped name';
        my $form = $widget->find('form');
        ok !$form->attr('action'), 'action attribute is removed';
        ok !$form->attr('method'), 'method attribute is removed';
        is $form->text, 'User Dashboard Pinned Widget', 'content is preserved';

        my $option = $app->wq_find('select[name="widget_id"] option[value^="dashboard_widget_template_' . $user_dashboard_unpinned_widget->id . '"]');
        is $option->html, '&lt;user dashboard unpinned widget&gt;', 'unpinned widget is added to the widget list';

        $option = $app->wq_find('select[name="widget_id"] option[value^="dashboard_widget_template_' . $blog_dashboard_unpinned_widget->id . '"]');
        is $option->html, '&lt;blog dashboard unpinned widget&gt; - ' . $blog_name, 'unpinned widget is added to the widget list';

        is $app->wq_find('select[name="widget_id"] option[value^="dashboard_widget_template_' . $blog_dashboard_pinned_widget->id . '"]')->size, 0, 'pinned widget is not added to the widget list';
    };

    subtest 'scope: website' => sub {
        $app->get_ok({ __mode => 'dashboard', blog_id => $blog->id });
        my $widget = $app->wq_find('div.dashboard-widget-template');
        ok $widget->html, "test widget exists";
        my $header = $widget->find('h2');
        is $header->html =~ s/^\s+|\s+$//gr, '&lt;blog dashboard pinned widget&gt;', 'html escaped name';
        my $form = $widget->find('form');
        ok !$form->attr('action'), 'action attribute is removed';
        ok !$form->attr('method'), 'method attribute is removed';
        is $form->text, "Blog Dashboard Pinned Widget for $blog_name", 'content is preserved';

        my $option = $app->wq_find('select[name="widget_id"] option[value^="dashboard_widget_template_' . $blog_dashboard_unpinned_widget->id . '"]');
        is $option->html, '&lt;blog dashboard unpinned widget&gt;', 'unpinned widget is added to the widget list';
    };
};

done_testing;
