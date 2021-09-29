#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
use JSON;

BEGIN {
    plan skip_all => 'FIXME: Not for external CGI server just for now' if $ENV{MT_TEST_RUN_APP_AS_CGI};

    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Site
    my $site = MT::Test::Permission->make_website(name => 'my website');

    # Author
    my $user = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );

    # Role
    my $manage_category_set_role = MT::Test::Permission->make_role(
        name        => 'Manage Category Set',
        permissions => "'manage_category_set'",
    );

    require MT::Association;
    MT::Association->link($user => $manage_category_set_role => $site);
    my $category_set = MT::Test::Permission->make_category_set(
        blog_id => $site->id,
        name    => 'test category set',
    );
    my $category_set2 = MT::Test::Permission->make_category_set(
        blog_id => $site->id,
        name    => 'test category set2',
    );
    my $category = MT::Test::Permission->make_category(
        label           => 'test category',
        category_set_id => $category_set2->id,
    );
});

require MT::Website;
my $site = MT::Website->load({ name => 'my website' });

require MT::Author;
my $admin = MT::Author->load(1);
my $user  = MT::Author->load({ name => 'aikawa' });

require MT::Role;
my $manage_category_set_role = MT::Role->load({ name => MT->translate('Manage Category Set') });

require MT::CategorySet;
my $category_set  = MT::CategorySet->load({ name => 'test category set' });
my $category_set2 = MT::CategorySet->load({ name => 'test category set2' });

my $category = MT::Category->load({ label => 'test category', category_set_id => $category_set2->id });

subtest 'mode = list' => sub {
    MT::Association->link($user => $manage_category_set_role => $site);
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($user);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'category_set',
        blog_id => $site->id,
    });
    $app->has_no_permission_error("list by permitted user");

    MT::Association->unlink($user => $manage_category_set_role => $site);

    $app->post_ok({
        __mode  => 'list',
        _type   => 'category_set',
        blog_id => $site->id,
    });
    $app->has_permission_error("list by non permitted user");
};

subtest 'mode = view ( new )' => sub {
    MT::Association->link($user => $manage_category_set_role => $site);
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($user);
    $app->post_ok({
        __mode  => 'view',
        _type   => 'category_set',
        blog_id => $site->id,
    });
    $app->has_no_permission_error("view by permitted user");

    MT::Association->unlink($user => $manage_category_set_role => $site);

    $app->post_ok({
        __mode  => 'view',
        _type   => 'category_set',
        blog_id => $site->id,
    });
    $app->has_permission_error("view by non permitted user");
};

subtest 'mode = save' => sub {
    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
    MT::Association->link($user => $manage_category_set_role => $site);
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($user);
    $app->post_ok({
        __mode          => 'bulk_update_category',
        datasource      => 'category',
        is_category_set => 1,
        set_name        => 'category_set2',
        set_id          => $category_set2->id,
        blog_id         => $site->id,
        checksum        => '5dce82de72cde1d23637a9288ca36f0a',
        objects         => JSON::to_json([{
            id       => $category->id,
            parent   => 0,
            label    => 'test category',
            basename => 'test_category'
        }]),
    });
    $app->has_no_permission_error("save by permitted user");

    MT::Association->unlink($user => $manage_category_set_role => $site);

    $app->post_ok({
        __mode          => 'bulk_update_category',
        datasource      => 'category',
        is_category_set => 1,
        set_name        => 'category_set2',
        set_id          => $category_set2->id,
        blog_id         => $site->id,
        checksum        => '5dce82de72cde1d23637a9288ca36f0a',
        objects         => JSON::to_json([{
            id       => $category->id,
            parent   => 0,
            label    => 'test category',
            basename => 'test_category'
        }]),
    });
    $app->has_permission_error("save by non permitted user");
};

subtest 'mode = view ( edit )' => sub {
    MT::Association->link($user => $manage_category_set_role => $site);
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($user);
    $app->post_ok({
        __mode  => 'view',
        _type   => 'category_set',
        blog_id => $site->id,
        id      => $category_set->id,
    });
    $app->has_no_permission_error("edit by permitted user");

    MT::Association->unlink($user => $manage_category_set_role => $site);

    $app->post_ok({
        __mode  => 'view',
        _type   => 'category_set',
        blog_id => $site->id,
        id      => $category_set->id,
    });
    $app->has_permission_error("edit by non permitted user");
};

subtest 'mode = delete' => sub {
    MT::Association->link($user => $manage_category_set_role => $site);
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($user);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'category_set',
        blog_id => $site->id,
        id      => $category_set->id,
    });
    $app->has_no_permission_error("edit by permitted user");

    MT::Association->unlink($user => $manage_category_set_role => $site);

    $app->post_ok({
        __mode  => 'delete',
        _type   => 'category_set',
        blog_id => $site->id,
        id      => $category_set->id,
    });
    $app->has_permission_error("edit by non permitted user");
};

done_testing();
