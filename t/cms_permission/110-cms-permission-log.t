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
        DefaultLanguage => 'en_US',    ## for now
    );
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

    my $egawa = MT::Test::Permission->make_author(
        name     => 'egawa',
        nickname => 'Shiro Egawa',
    );

    my $ogawa = MT::Test::Permission->make_author(
        name     => 'ogawa',
        nickname => 'Goro Ogawa',
    );

    my $admin = MT::Author->load(1);

    # Role
    my $view_blog_log = MT::Test::Permission->make_role(
        name        => 'View Blog Log',
        permissions => "'view_blog_log'",
    );

    my $designer = MT::Role->load({ name => MT->translate('Designer') });

    require MT::Association;
    MT::Association->link($aikawa   => $view_blog_log => $blog);
    MT::Association->link($ichikawa => $view_blog_log => $website);
    MT::Association->link($ukawa    => $view_blog_log => $second_blog);
    MT::Association->link($egawa    => $designer      => $blog);

    $ogawa->can_view_log(1);
    $ogawa->save();
});

my $website = MT::Website->load({ name => 'my website' });
my $blog    = MT::Blog->load({ name => 'my blog' });

my $aikawa   = MT::Author->load({ name => 'aikawa' });
my $ichikawa = MT::Author->load({ name => 'ichikawa' });
my $ukawa    = MT::Author->load({ name => 'ukawa' });
my $egawa    = MT::Author->load({ name => 'egawa' });
my $ogawa    = MT::Author->load({ name => 'ogawa' });

my $admin = MT::Author->load(1);

subtest 'mode = export_log' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    my $res = $app->post_ok({
        __mode  => 'export_log',
        blog_id => $blog->id,
    });
    ok($res->header('Content-disposition') =~ /attachment;/i, "export_log by admin");

    $app->login($aikawa);
    $res = $app->post_ok({
        __mode  => 'export_log',
        blog_id => $blog->id,
    });
    ok($res->header('Content-disposition') =~ /attachment;/i, "export_log by permitted_user");

    $app->login($ichikawa);
    $res = $app->post_ok({
        __mode  => 'export_log',
        blog_id => $website->id,
    });
    ok($res->header('Content-disposition') =~ /attachment;/i, "export_log by permitted user on website");

    $app->login($ogawa);
    $res = $app->post_ok({
        __mode  => 'export_log',
        blog_id => 0,
    });
    ok($res->header('Content-disposition') =~ /attachment;/i, "export_log by permitted user on system");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'export_log',
        blog_id => $blog->id,
    });
    $app->has_permission_error("export_log by other permission");
};

subtest 'mode = reset_log' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'reset_log',
        blog_id => $blog->id,
    });
    ok($app->last_location->query_param('reset'), "reset_log by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'reset_log',
        blog_id => $blog->id,
    });
    ok($app->last_location->query_param('reset'), "reset_log by permitted_user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'reset_log',
        blog_id => $website->id,
    });
    ok($app->last_location->query_param('reset'), "reset_log by permitted user on website");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'reset_log',
        blog_id => 0,
    });
    ok($app->last_location->query_param('reset'), "reset_log by permitted user on system");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'reset_log',
        blog_id => $website->id,
    });
    ok($app->last_location->query_param('reset'), "reset_log by parent website");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'reset_log',
        blog_id => $blog->id,
    });
    $app->has_permission_error("reset_log by child blog");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'reset_log',
        blog_id => 0,
    });
    ok($app->last_location->query_param('reset'), "reset_log by permitted user on system");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'reset_log',
        blog_id => $blog->id,
    });
    $app->has_permission_error("reset_log by other blog");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'reset_log',
        blog_id => $blog->id,
    });
    $app->has_permission_error("reset_log by other permission");
};

subtest 'mode = save' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode => 'save',
        _type  => 'log',
    });
    $app->has_invalid_request("save by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode => 'save',
        _type  => 'log',
    });
    $app->has_invalid_request("save by non permitted user");
};

subtest 'mode = edit' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode => 'edit',
        _type  => 'log',
        id     => 1,
    });
    $app->has_invalid_request("edit by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode => 'edit',
        _type  => 'log',
        id     => 1,
    });
    $app->has_invalid_request("edit by non permitted user");
};

subtest 'mode = delete' => sub {
    my $log = MT::Test::Permission->make_log(blog_id => $blog->id);
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'log',
        id     => $log->id,
    });
    $app->has_invalid_request("delete by admin");

    $log = MT::Test::Permission->make_log(blog_id => $blog->id);
    $app->login($aikawa);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'log',
        id     => $log->id,
    });
    $app->has_invalid_request("delete by non permitted user");
};

subtest 'mode = dialog_list_deprecated_log' => sub {
    for my $sig (keys %MT::Plugins) {
        next unless MT->has_plugin($sig);
        my $plugin = $MT::Plugins{$sig}{object};
        next unless $plugin->isa('MT::Plugin');

        MT::Test::Permission->make_log(
            blog_id  => 0,
            class    => 'plugin',
            category => $plugin->log_category_for_deprecated_fn,
            message  => "${sig} plugin is using deprecaged call.",
            metadata => 'This is a deprecated log message.',
        );

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode     => 'dialog_list_deprecated_log',
            blog_id    => $blog->id,
            dialog     => 1,
            plugin_sig => $sig,
        });
        $app->has_no_permission_error("$sig: dialog_list_deprecated_log by admin");

        $app->login($egawa);
        my $res = $app->get_ok({
            __mode     => 'dialog_list_deprecated_log',
            blog_id    => $blog->id,
            dialog     => 1,
            plugin_sig => $sig,
        });

        $app->has_permission_error("$sig: dialog_list_deprecated_log by other permission");
    }
};

done_testing();
