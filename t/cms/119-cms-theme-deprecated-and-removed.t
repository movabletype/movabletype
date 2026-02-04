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
    $ENV{MT_CONFIG} = $test_env->config_file(
        ThemesDirectory => ['themes', 'TEST_ROOT/themes'],
    );

    $test_env->save_file('themes/deprecated_theme/theme.yaml', <<'YAML');
id: deprecated_theme
name: Deprecated Theme
label: Deprecated Theme
class: both
deprecated: 1
thumbnail_file: thumb.png
thumbnail_file_medium: thumb-medium.png
thumbnail_file_small: thumb-small.png
YAML

    $test_env->save_file('themes/extra_theme/theme.yaml', <<'YAML');
id: extra_theme
name: Extra Theme
label: Extra Theme
class: both
thumbnail_file: thumb.png
thumbnail_file_medium: thumb-medium.png
thumbnail_file_small: thumb-small.png
YAML
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::Fixture;
use MT::Test::App;
use MT::Test::Image;

MT::Test::Image->write(file => $test_env->path('themes/deprecated_theme/thumb.png'));
MT::Test::Image->write(file => $test_env->path('themes/deprecated_theme/thumb-medium.png'));
MT::Test::Image->write(file => $test_env->path('themes/deprecated_theme/thumb-small.png'));

MT::Test::Image->write(file => $test_env->path('themes/extra_theme/thumb.png'));
MT::Test::Image->write(file => $test_env->path('themes/extra_theme/thumb-medium.png'));
MT::Test::Image->write(file => $test_env->path('themes/extra_theme/thumb-small.png'));

MT->instance;

$test_env->prepare_fixture('db');
my $objs = MT::Test::Fixture->prepare({
    website => [qw(first_site second_site third_site fourth_site)],
});

my $admin = MT->model('author')->load(1);

my $website1 = MT::Website->load({ name => 'first_site' });
my $website2 = MT::Website->load({ name => 'second_site' });
my $website3 = MT::Website->load({ name => 'third_site' });
my $website4 = MT::Website->load({ name => 'fourth_site' });

$website1->theme_id('mont-blanc');       $website1->save;
$website2->theme_id('extra_theme');      $website2->save;
$website3->theme_id('deprecated_theme'); $website3->save;
$website4->theme_id('removed_theme');    $website4->save;

subtest 'Bundled theme' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({
        __mode  => 'list_theme',
        blog_id => $website1->id,
    });
    my $current       = $app->wq_find('#current-theme-group .current-theme');
    my $thumbnail_src = $current->find('img.img-thumbnail')->attr('src') // '';
    like $thumbnail_src => qr/mont-blanc/, "thumbnail is from mont-blanc";

    my $title = $current->find('h3.theme-title')->text // '';
    like _trim($title) => qr/Mont-Blanc/, "title is Mont-Blanc";

    my $has_toggle_button = $current->find('div.theme-toggle-button')->text // '';
    ok _trim($has_toggle_button), "has toggle button";

    my @links;
    $current->find('a.apply-theme-link')->each(sub { push @links, $_->attr('href'); });
    ok @links == 2, "has two apply theme links";
    my @modes = map { /__mode=(\w+)/; $1 } @links;
    is $modes[0] => 'dialog_refresh_templates', "first link is to refresh theme";
    is $modes[1] => 'apply_theme',              "second link is to apply theme";
    }
    if 0;

subtest 'Extra theme' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({
        __mode  => 'list_theme',
        blog_id => $website2->id,
    });
    my $current       = $app->wq_find('#current-theme-group .current-theme');
    my $thumbnail_src = $current->find('img.img-thumbnail')->attr('src') // '';
    like $thumbnail_src => qr/extra_theme/, "thumbnail is from extra_theme";

    my $title = $current->find('h3.theme-title')->text // '';
    like _trim($title) => qr/Extra Theme/, "title is Extra Theme";

    my $has_toggle_button = $current->find('div.theme-toggle-button')->text // '';
    ok _trim($has_toggle_button), "has toggle button";

    my @links;
    $current->find('a.apply-theme-link')->each(sub { push @links, $_->attr('href'); });
    ok @links == 2, "has two apply theme links";
    my @modes = map { /__mode=(\w+)/; $1 } @links;
    is $modes[0] => 'dialog_refresh_templates', "first link is to refresh theme";
    is $modes[1] => 'apply_theme',              "second link is to apply theme";
    }
    if 0;

subtest 'Deprecated theme' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({
        __mode  => 'list_theme',
        blog_id => $website3->id,
    });
    my $current       = $app->wq_find('#current-theme-group .current-theme');
    my $thumbnail_src = $current->find('img.img-thumbnail')->attr('src') // '';
    like $thumbnail_src => qr/deprecated_theme/, "thumbnail is from deprecated_theme";

    my $title = $current->find('h3.theme-title')->text // '';
    like _trim($title) => qr/Deprecated Theme/, "title is Deprecated Theme";

    my $has_toggle_button = $current->find('div.theme-toggle-button')->text // '';
    ok !_trim($has_toggle_button), "has no toggle button";

    my @links;
    $current->find('a.apply-theme-link')->each(sub { push @links, $_->attr('href'); });
    ok !@links, "has no apply theme links";
    }
    if 0;

subtest 'Removed theme' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({
        __mode  => 'list_theme',
        blog_id => $website4->id,
    });
    my $current       = $app->wq_find('#current-theme-group .current-theme');
    my $thumbnail_src = $current->find('img.img-thumbnail')->attr('src') // '';
    like $thumbnail_src => qr/default_theme_thumbnail/, "thumbnail is default theme thumbnail";

    my $title = $current->find('h3.theme-title')->text // '';
    like _trim($title) => qr/Removed Theme/, "title is Removed Theme";

    my $has_toggle_button = $current->find('div.theme-toggle-button')->text // '';
    ok !_trim($has_toggle_button), "has no toggle button";

    my @links;
    $current->find('a.apply-theme-link')->each(sub { push @links, $_->attr('href'); });
    ok !@links, "has no apply theme links";
};

done_testing;

sub _trim {
    my $str = shift;
    $str =~ s/^\s+//s;
    $str =~ s/\s+$//s;
    $str;
}
