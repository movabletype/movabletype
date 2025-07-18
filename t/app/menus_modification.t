use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(ThemesDirectory => [qw(TEST_ROOT/themes)]);
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file('themes/modify_menus/theme.yaml', <<'YAML');
id: modify_menus
class: website
menus_modification:
  entry: 0
  page: 0
YAML

    $test_env->save_file('themes/modify_menu/theme.yaml', <<'YAML');
id: modify_menu
class: website
menu_modification:
  entry: 0
  page: 0
YAML
}

use MT::Test;
use MT::Test::App;
use MT::Test::Fixture;

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare({
    website => [{
            name     => 'classic_test_site',
            theme_id => 'classic_test_website',
        }, {
            name     => 'modified_site',
            theme_id => 'modify_menus',
        }, {
            name     => 'modified_site2',
            theme_id => 'modify_menu',
        }
    ],
});

my $classic_test_site   = $objs->{website}{classic_test_site};
my $modified_site  = $objs->{website}{modified_site};
my $modified_site2 = $objs->{website}{modified_site2};

my $admin = MT::Author->load(1);

subtest 'Classic site shows entry/page menus' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({ __mode => 'dashboard', blog_id => $classic_test_site->id });
    ok !$app->generic_error, 'no error';
    my $entry_menu = $app->wq_find('li#menu-entry');
    ok $entry_menu && $entry_menu->text =~ /Entries/, 'entry_menu exists';
    my $page_menu = $app->wq_find('li#menu-page');
    ok $page_menu && $page_menu->text =~ /Pages/, 'page_menu exists';
};

subtest 'Modified site (by menus_modification) does not show entry/page menus' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({ __mode => 'dashboard', blog_id => $modified_site->id });
    ok !$app->generic_error, 'no error';
    my $entry_menu = $app->wq_find('li#menu-entry');
    ok $entry_menu && !$entry_menu->html, 'entry_menu is gone';
    my $page_menu = $app->wq_find('li#menu-page');
    ok $page_menu && !$page_menu->html, 'page_menu is gone';
};

subtest 'Modified site (by menu_modification) does not show entry/page menus as well' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({ __mode => 'dashboard', blog_id => $modified_site2->id });
    ok !$app->generic_error, 'no error';
    my $entry_menu = $app->wq_find('li#menu-entry');
    ok $entry_menu && !$entry_menu->html, 'entry_menu is gone';
    my $page_menu = $app->wq_find('li#menu-page');
    ok $page_menu && !$page_menu->html, 'page_menu is gone';
};

done_testing;
