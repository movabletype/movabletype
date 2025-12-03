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
    my $website = MT::Test::Permission->make_website(name => 'my website');

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'my blog',
    );
    my $second_blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'second blog',
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

    my $ukawa = MT::Test::Permission->make_author(
        name     => 'ukawa',
        nickname => 'Saburo Ukawa',
    );

    my $admin = MT::Author->load(1);

    # Role
    my $manage_themes = MT::Test::Permission->make_role(
        name        => 'Manage Themes',
        permissions => "'manage_themes'",
    );

    my $create_post = MT::Test::Permission->make_role(
        name        => 'Create Post',
        permissions => "'create_post'",
    );

    require MT::Association;
    MT::Association->link($aikawa   => $manage_themes => $blog);
    MT::Association->link($ichikawa => $create_post   => $blog);
    MT::Association->link($ukawa    => $manage_themes => $second_blog);
});

my $website = MT::Website->load({ name => 'my website' });
my $blog    = MT::Blog->load({ name => 'my blog' });

my $aikawa   = MT::Author->load({ name => 'aikawa' });
my $ichikawa = MT::Author->load({ name => 'ichikawa' });
my $ukawa    = MT::Author->load({ name => 'ukawa' });

my $admin = MT::Author->load(1);

subtest 'mode = apply_theme' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode   => 'apply_theme',
        blog_id  => $blog->id,
        theme_id => 'classic_test_blog',
    });
    $app->has_no_permission_error("apply_theme by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode   => 'apply_theme',
        blog_id  => $blog->id,
        theme_id => 'classic_test_blog',
    });
    $app->has_no_permission_error("apply_theme by permitted user");

    $app->login($ukawa);
    $app->post_ok({
        __mode   => 'apply_theme',
        blog_id  => $blog->id,
        theme_id => 'classic_test_blog',
    });
    $app->has_permission_error("apply_theme by other blog");

    $app->login($ichikawa);
    $app->post_ok({
        __mode   => 'apply_theme',
        blog_id  => $blog->id,
        theme_id => 'classic_test_blog',
    });
    $app->has_permission_error("apply_theme by other permission");
};

subtest 'mode = do_export_theme' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode   => 'do_export_theme',
        blog_id  => $blog->id,
        theme_id => 'classic_test_blog',
    });
    $app->has_no_permission_error("do_export_theme by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode   => 'do_export_theme',
        blog_id  => $blog->id,
        theme_id => 'classic_test_blog',
    });
    $app->has_no_permission_error("do_export_theme by permitted user");

    $app->login($ukawa);
    $app->post_ok({
        __mode   => 'do_export_theme',
        blog_id  => $blog->id,
        theme_id => 'classic_test_blog',
    });
    $app->has_permission_error("do_export_theme by other blog");

    $app->login($ichikawa);
    $app->post_ok({
        __mode   => 'do_export_theme',
        blog_id  => $blog->id,
        theme_id => 'classic_test_blog',
    });
    $app->has_permission_error("do_export_theme by other permission");
};

subtest 'mode = theme_element_detail' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode      => 'theme_element_detail',
        blog_id     => $blog->id,
        exporter_id => 'default_categories',
    });
    $app->has_no_permission_error("theme_element_detail by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode      => 'theme_element_detail',
        blog_id     => $blog->id,
        exporter_id => 'default_categories',
    });
    $app->has_no_permission_error("theme_element_detail by permitted user");

    $app->login($ukawa);
    $app->post_ok({
        __mode      => 'theme_element_detail',
        blog_id     => $blog->id,
        exporter_id => 'default_categories',
    });
    $app->has_permission_error("theme_element_detail by other blog");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'theme_element_detail',
        blog_id => $blog->id,
    });
    $app->has_permission_error("theme_element_detail by other permission");
};

subtest 'mode = export_theme' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'export_theme',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("export_theme by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'export_theme',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("export_theme by permitted user");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'export_theme',
        blog_id => $blog->id,
    });
    $app->has_permission_error("export_theme by other blog");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'export_theme',
        blog_id => $blog->id,
    });
    $app->has_permission_error("export_theme by other permission");
};

subtest 'mode = list_theme' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'list_theme',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("list_theme by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'list_theme',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("list_theme by permitted user");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'list_theme',
        blog_id => $blog->id,
    });
    $app->has_permission_error("list_theme by other blog");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'list_theme',
        blog_id => $blog->id,
    });
    $app->has_permission_error("list_theme by other permission");
};

subtest 'mode = save_theme_detail' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode      => 'save_theme_detail',
        blog_id     => $blog->id,
        exporter_id => 'default_categories',
    });
    $app->has_no_permission_error("save_theme_detail by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode      => 'save_theme_detail',
        blog_id     => $blog->id,
        exporter_id => 'default_categories',
    });
    $app->has_no_permission_error("save_theme_detail by permitted user");

    $app->login($ukawa);
    $app->post_ok({
        __mode      => 'save_theme_detail',
        blog_id     => $blog->id,
        exporter_id => 'default_categories',
    });
    $app->has_permission_error("save_theme_detail by other blog");

    $app->login($ichikawa);
    $app->post_ok({
        __mode      => 'save_theme_detail',
        blog_id     => $blog->id,
        exporter_id => 'default_categories',
    });
    $app->has_permission_error("save_theme_detail by other permission");
};

subtest 'mode = uninstall_theme' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode   => 'uninstall_theme',
        blog_id  => $blog->id,
        theme_id => 'classic_test_blog',
    });
    $app->has_no_permission_error("uninstall_theme by admin");    #TODO: should use 'Permission=1' instead

    $app->login($aikawa);
    $app->post_ok({
        __mode   => 'uninstall_theme',
        theme_id => 'classic_test_blog',
    });
    $app->has_permission_error("uninstall_theme by non permitted user");    #TODO: should use 'Permission=1' instead
};

done_testing();
