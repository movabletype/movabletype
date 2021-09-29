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

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

### Make test data

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website(
        name => 'my website',
    );

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'first blog',
    );
    my $second_blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
    );

    # Author
    my $aikawa = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );

    my $ichikawa = MT::Test::Permission->make_author(
        name     => 'ichikawa',
        nickname => 'Jiro Ichikawa',
    );

    my $admin = MT::Author->load(1);

    # Role
    require MT::Role;
    my $designer = MT::Role->load({ name => MT->translate('Designer') });

    require MT::Association;
    MT::Association->link($aikawa   => $designer => $blog);
    MT::Association->link($ichikawa => $designer => $second_blog);
});

my $admin    = MT::Author->load(1);
my $website  = MT::Website->load({ name => 'my website' });
my $blog     = MT::Blog->load({ name => 'first blog' });
my $aikawa   = MT::Author->load({ name => 'aikawa' });
my $ichikawa = MT::Author->load({ name => 'ichikawa' });

subtest 'mode = dashboard' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'dashboard',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("dashboard by admin");

    $app->login($admin);
    $app->post_ok({
        __mode  => 'dashboard',
        blog_id => 0,
    });
    $app->has_no_permission_error("dashboard by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'dashboard',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("dashboard by permitted user (blog)");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'dashboard',
        blog_id => $website->id,
    });
    $app->has_no_permission_error("dashboard by permitted user (parent website)");

    $app->login($aikawa);
    $app->post_ok({
        __mode => 'dashboard',
    });
    $app->has_no_permission_error("dashboard by permitted user (user)");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'dashboard',
        blog_id => $blog->id,
    });
    $app->has_permission_error("dashboard by other blog");
};

done_testing();
