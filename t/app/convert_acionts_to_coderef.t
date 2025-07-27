use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => [qw(TEST_ROOT/plugins)],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    my $config_yaml = 'plugins/ActionsTest/config.yaml';
    $test_env->save_file($config_yaml, <<'YAML');
id: ActionsTest
name: ActionsTest
version: 0
applications:
    cms:
        menu_actions:
            menu_test:
                icon: ic_user
                condition: |
                    sub {
                        my $app = shift;
                        $app->user->is_superuser;
                    }
                mode: cfg_system_general
                label: 'Menu action for System Administrator only'
                href: |
                    sub {
                        my ($app, $param) = @_;
                        'Menu action href for ' . $param->{author_id};
                    }
                order: 999
        user_actions:
            user_test:
                condition: |
                    sub {
                        my $app = shift;
                        $app->user->is_superuser;
                    }
                mode: cfg_system_general
                label: 'User action for System Administrator only'
                href: |
                    sub {
                        my ($app, $param) = @_;
                        'User action href for ' . $param->{author_id};
                    }
                order: 999
YAML
}

use MT::Test;
use MT::Test::App;
use MT::Test::Fixture;

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare({
    author => [{
            name  => 'user',
            roles => [{
                website => 'testsite',
                role    => [qw(User)],
            }],
        }, {
            name => 'another superuser',
        }
    ],
    website => [qw(testsite)],
    role    => {
        User => [qw(comment create_post publish_post upload send_notifications)],
    },
});

my $admin     = MT::Author->load(1);
my $user      = $objs->{author}{user};
my $superuser = $objs->{author}{'another superuser'};
my $site      = $objs->{website}{testsite};

subtest 'Default Superuser' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({ __mode => 'dashboard', blog_id => $site->id });
    is $app->page_title, 'testsite', 'page title is correct';
    my $user_action = $app->wq_find('li#menu-user_test');
    ok $user_action && $user_action->text =~ /User action for System Administrator only/, 'user action exists';
    my $user_href = $user_action->find('a')->attr('href');
    is $user_href => 'User action href for ' . $admin->id, 'user href is correct';
    my $menu_action = $app->wq_find('a#menu-menu_test');
    ok $menu_action && $menu_action->text =~ /Menu action for System Administrator only/, 'menu action exists';
    my $menu_href = $menu_action->attr('href');
    is $menu_href => 'Menu action href for ' . $admin->id, 'menu href is correct';
};

subtest 'Extra Superuser' => sub {
    my $app = MT::Test::App->new;
    $app->login($superuser);
    $app->get_ok({ __mode => 'dashboard', blog_id => $site->id });
    is $app->page_title, 'testsite', 'page title is correct';
    my $user_action = $app->wq_find('li#menu-user_test');
    ok $user_action && $user_action->text =~ /User action for System Administrator only/, 'user action exists';
    my $user_href = $user_action->find('a')->attr('href');
    is $user_href => 'User action href for ' . $superuser->id, 'user href is correct';
    my $menu_action = $app->wq_find('a#menu-menu_test');
    ok $menu_action && $menu_action->text =~ /Menu action for System Administrator only/, 'menu action exists';
    my $menu_href = $menu_action->attr('href');
    is $menu_href => 'Menu action href for ' . $superuser->id, 'menu href is correct';
};

subtest 'Non Superuser' => sub {
    my $app = MT::Test::App->new;
    $app->login($user);
    ok !$user->is_superuser, 'user is not a superuser';
    $app->get_ok({ __mode => 'dashboard', blog_id => $site->id });
    is $app->page_title, 'testsite', 'page title is correct';
    my $user_action = $app->wq_find('li#menu-user_test');
    ok $user_action && !$user_action->html, 'user action does not exist';
    my $menu_action = $app->wq_find('a#menu-menu_test');
    ok $menu_action && !$menu_action->html, 'menu action does not exist';
};

done_testing;
