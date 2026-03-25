#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

plan skip_all => 'only for admin2023' unless MT->config->AdminThemeId eq 'admin2023';

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

$test_env->prepare_fixture('db');

my $parent      = MT::Test::Permission->make_website(name => 'parent');
my $child       = MT::Test::Permission->make_blog(parent_id => $parent->id, name => 'child');
my $create_post = MT::Test::Permission->make_role(name => 'Create Post', permissions => "'create_post'");

subtest 'access to dashboard with perms' => sub {
    my $user = create_user('with_both_perms', [$parent, $child]);
    my $app  = MT::Test::App->new('MT::App::CMS');
    $app->login($user);

    my $ret;
    $ret = access_to_dashboard($app);
    is_deeply $ret, { parent => 'linked', child => 'linked' }, 'system';
    $ret = access_to_dashboard($app, $parent);
    is_deeply $ret, { parent => 'linked', child => 'linked' }, 'parent';
    $ret = access_to_dashboard($app, $child);
    is_deeply $ret, { parent => 'hidden', child => 'hidden' }, 'child';
};

subtest 'access to dashboard with child perm first' => sub {
    my $user = create_user('with_child_perm', [$child]);
    my $app  = MT::Test::App->new('MT::App::CMS');
    $app->login($user);

    my $ret;
    $ret = access_to_dashboard($app);
    is_deeply $ret, { parent => 'not_linked', child => 'linked' }, 'system';
    $ret = access_to_dashboard($app, $parent);
    is_deeply $ret, { parent => 'not_linked', child => 'linked' }, 'parent';
    $ret = access_to_dashboard($app, $child);
    is_deeply $ret, { parent => 'hidden', child => 'hidden' }, 'child';
};

subtest 'access to dashboard without parent perm later' => sub {
    my $user = create_user('without_parent_perm_later', [$parent, $child]);
    my $app  = MT::Test::App->new('MT::App::CMS');
    $app->login($user);

    # access sites first
    access_to_dashboard($app);
    access_to_dashboard($app, $parent);
    access_to_dashboard($app, $child);

    MT::Association->unlink($user => $create_post => $parent);

    my $ret;
    $ret = access_to_dashboard($app);
    is_deeply $ret, { parent => 'linked', child => 'linked' }, 'system';
    $ret = access_to_dashboard($app, $parent);
    is_deeply $ret, { parent => 'not_linked', child => 'linked' }, 'parent';
    $ret = access_to_dashboard($app, $child);
    is_deeply $ret, { parent => 'hidden', child => 'hidden' }, 'child';
};

subtest 'access to dashboard with parent perm first' => sub {
    my $user = create_user('with_parent_perm', [$parent]);
    my $app  = MT::Test::App->new('MT::App::CMS');
    $app->login($user);

    my $ret;
    $ret = access_to_dashboard($app);
    is_deeply $ret, { parent => 'linked', child => 'hidden' }, 'system';
    $ret = access_to_dashboard($app, $parent);
    is_deeply $ret, { parent => 'hidden', child => 'hidden' }, 'parent';
    $ret = access_to_dashboard($app, $child);
    is_deeply $ret, { redirected => 1, parent => 'linked', child => 'hidden' }, 'redirect to system';
};

subtest 'access to dashboard without child perm later' => sub {
    my $user = create_user('without_child_perms_later', [$parent, $child]);
    my $app  = MT::Test::App->new('MT::App::CMS');
    $app->login($user);

    # access sites first
    access_to_dashboard($app);
    access_to_dashboard($app, $parent);
    access_to_dashboard($app, $child);

    MT::Association->unlink($user => $create_post => $child);

    my $ret;
    $ret = access_to_dashboard($app);
    is_deeply $ret, { parent => 'linked', child => 'hidden' }, 'system';
    $ret = access_to_dashboard($app, $parent);
    is_deeply $ret, { parent => 'hidden', child => 'hidden' }, 'parent';
    $ret = access_to_dashboard($app, $child);
    is_deeply $ret, { redirected => 1, parent => 'linked', child => 'hidden' }, 'redirect to system';
};

subtest 'access to dashboard without any perms first' => sub {
    my $user = create_user('without_any_perms_first', []);
    my $app  = MT::Test::App->new('MT::App::CMS');
    $app->login($user);

    my $ret;
    $ret = access_to_dashboard($app);
    is_deeply $ret, { parent => 'hidden', child => 'hidden' }, 'system';
    $ret = access_to_dashboard($app, $parent);
    is_deeply $ret, { redirected => 1, parent => 'hidden', child => 'hidden' }, 'redirect to system';
    $ret = access_to_dashboard($app, $child);
    is_deeply $ret, { redirected => 1, parent => 'hidden', child => 'hidden' }, 'redirect to system';
};

subtest 'access to dashboard without any perms later' => sub {
    my $user = create_user('without_any_perms_later', [$parent, $child]);
    my $app  = MT::Test::App->new('MT::App::CMS');
    $app->login($user);

    # access sites first
    access_to_dashboard($app);
    access_to_dashboard($app, $parent);
    access_to_dashboard($app, $child);

    MT::Association->unlink($user => $create_post => $parent);
    MT::Association->unlink($user => $create_post => $child);

    my $ret;
    $ret = access_to_dashboard($app);
    is_deeply $ret, { parent => 'hidden', child => 'hidden' }, 'system';
    $ret = access_to_dashboard($app, $parent);
    is_deeply $ret, { redirected => 1, parent => 'hidden', child => 'hidden' }, 'redirect to system';
    $ret = access_to_dashboard($app, $child);
    is_deeply $ret, { redirected => 1, parent => 'hidden', child => 'hidden' }, 'redirect to system';
};

done_testing;

sub create_user {
    my ($name, $sites) = @_;
    my $user = MT::Test::Permission->make_author(name => $name, nickname => $name);
    for my $site (@{ $sites // [] }) {
        MT::Association->link($user => $create_post => $site);
    }
    return $user;
}

sub access_to_dashboard {
    my ($app, $site) = @_;

    $app->get_ok({
        __mode => 'dashboard',
        ($site ? (blog_id => $site->id) : ()),
    });

    return { error => $app->generic_error } if $app->generic_error;

    my $ret   = {};
    my $elems = $app->wq_find('.mt-primaryNavigation__sites');
    my @links = map { $_->as_html } $elems->find('a');

    for my $link (@links) {
        $link =~ qr{>\s*(\w+)\s*</a>};
        $ret->{$1} = 'linked';
    }

    my $html = $elems->as_html;
    for my $name (qw/parent child/) {
        next if $ret->{$name};
        if ($html =~ qr/>\s*$name\s*</) {
            $ret->{$name} = 'not_linked';
        } else {
            $ret->{$name} = 'hidden';
        }
    }

    $ret->{redirected} = 1 if $app->last_location;

    return $ret;
}
