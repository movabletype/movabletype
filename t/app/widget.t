#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;

BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';

    $test_env = MT::Test::Env->new(
        PluginPath => [qw(
            TEST_ROOT/plugins
        )]);
    $ENV{MT_CONFIG} = $test_env->config_file;

    my $config_yaml = 'plugins/TestWidget/config.yaml';
    $test_env->save_file($config_yaml, <<'YAML' );
id: test_widget
key: test_widget
name: TestWidget
applications:
  cms:
    widgets:
      test_user_pinned_widget:
        label: Test User Pinned Widget
        order: 30
        view: user
        pinned: 1
        set: main
      test_blog_pinned_widget:
        label: Test Blog Pinned Widget
        order: 30
        view: blog
        pinned: 1
        set: main
YAML
}

use MT;
use MT::Test;
use MT::Test::Permission;

$test_env->prepare_fixture('db');

MT::Test->init_cms;

# Create records
my $admin = MT::Author->load(1);
ok($admin);

my $app = MT->instance;
$app->user($admin);

my $website = MT::Website->load();
my $blog    = MT::Test::Permission->make_blog(parent_id => $website->id,);
$app->blog($blog);

$admin->widgets({
    'dashboard:user:' . $admin->id => {
        mt_news => {
            order => 100,
            set   => 'sidebar',
        },
        notification_dashboard => {
            order => 0,
            set   => 'main',
        },
        activity_log => {
            order => 200,
            set   => 'sidebar',
        },
    },
    'dashboard:blog:' . $blog->id => {
        activity_log => {
            order => 200,
            set   => 'sidebar',
        },
        site_list => {
            order => 100,
            set   => 'main',
        },
        site_list_for_mobile => {
            order => 50,
            set   => 'main',
        },
    },
});
$admin->save;

subtest 'widgets' => sub {
    my $order;
    my $mock_app = Test::MockModule->new('MT::App');
    $mock_app->mock(
        'build_widgets',
        sub {
            my $app    = shift;
            my %params = @_;
            $order = $params{order};
            $mock_app->original('build_widgets')->($app, %params);
        });

    subtest 'scope: user' => sub {
        $order = undef;
        $app->load_widgets('dashboard', 'user', {});
        is_deeply(
            $order, [qw(
                notification_dashboard
                test_user_pinned_widget
                mt_news
                activity_log
            )],
        );
    };

    subtest 'scope: website' => sub {
        $order = undef;
        $app->load_widgets('dashboard', 'blog', {});
        is_deeply(
            $order, [qw(
                test_blog_pinned_widget
                site_list_for_mobile
                site_list
                activity_log
            )],
        );
    };

    $mock_app->unmock_all;
};

done_testing;
