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
        ShowIpInformation => 1,
        DefaultLanguage   => 'en_US',    ## for now
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
    my $website = MT::Test::Permission->make_website();

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
        nickname => 'goro Ogawa',
    );

    my $admin = MT::Author->load(1);

    # Role
    my $edit_config = MT::Test::Permission->make_role(
        name        => 'Edit Config',
        permissions => "'edit_config'",
    );

    my $manage_feedback = MT::Test::Permission->make_role(
        name        => 'Manage Feedback',
        permissions => "'manage_feedback'",
    );

    my $designer = MT::Role->load({ name => MT->translate('Designer') });

    require MT::Association;
    MT::Association->link($aikawa   => $edit_config     => $blog);
    MT::Association->link($ichikawa => $manage_feedback => $blog);
    MT::Association->link($ukawa    => $designer        => $blog);
    MT::Association->link($egawa    => $edit_config     => $second_blog);
    MT::Association->link($ogawa    => $manage_feedback => $second_blog);

    # BanList
    my $banlist = MT::Test::Permission->make_banlist(blog_id => $blog->id,);
});

my $blog = MT::Blog->load({ name => 'my blog' });

my $aikawa   = MT::Author->load({ name => 'aikawa' });
my $ichikawa = MT::Author->load({ name => 'ichikawa' });
my $ukawa    = MT::Author->load({ name => 'ukawa' });
my $egawa    = MT::Author->load({ name => 'egawa' });
my $ogawa    = MT::Author->load({ name => 'ogawa' });

my $admin = MT::Author->load(1);

my $banlist = MT::IPBanList->load({ blog_id => $blog->id });

subtest 'mode = list' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $blog->id,
        _type   => 'banlist',
    });
    $app->has_no_permission_error("list by admin");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $blog->id,
        _type   => 'banlist',
    });
    $app->has_no_permission_error("list by permitted user (manage feedback)");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $blog->id,
        _type   => 'banlist',
    });
    $app->has_permission_error("list by other blog (manage feedback)");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $blog->id,
        _type   => 'banlist',
    });
    $app->has_permission_error("list by other permission");
};

subtest 'mode = save' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'banlist',
        ip      => '1.1.1.1'
    });
    $app->has_no_permission_error("save by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'banlist',
        ip      => '1.1.1.1'
    });
    $app->has_permission_error("save by non permitted user (edit config)");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'banlist',
        ip      => '1.1.1.1'
    });
    $app->has_no_permission_error("save by permitted user (manage feedback)");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'banlist',
        ip      => '1.1.1.1'
    });
    $app->has_permission_error("save by other blog (edit config)");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'banlist',
        ip      => '1.1.1.1'
    });
    $app->has_permission_error("save by other blog (manage feedback)");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'banlist',
    });
    $app->has_permission_error("save by other permission");
};

subtest 'mode = save (type is ipbanlist)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'ipbanlist',
        ip      => '1.1.1.1'
    });
    $app->has_invalid_request("save by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'ipbanlist',
        ip      => '1.1.1.1'
    });
    $app->has_invalid_request("save by non permitted user (edit config)");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'ipbanlist',
        ip      => '1.1.1.1'
    });
    $app->has_invalid_request("save by permitted user (manage feedback)");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'ipbanlist',
        ip      => '1.1.1.1'
    });
    $app->has_permission_error("save by other blog (edit config)");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'ipbanlist',
        ip      => '1.1.1.1'
    });
    $app->has_permission_error("save by other blog (manage feedback)");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'ipbanlist',
    });
    $app->has_invalid_request("save by other permission");
};

subtest 'mode = edit' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'banlist',
        id      => $banlist->id,
    });
    $app->has_invalid_request("edit by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'banlist',
        id      => $banlist->id,
    });
    $app->has_invalid_request("edit by permitted user (edit config)");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'banlist',
        id      => $banlist->id,
    });
    $app->has_invalid_request("edit by permitted user (manage feedback)");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'banlist',
        id      => $banlist->id,
    });
    $app->has_permission_error("edit by other blog (edit config)");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'banlist',
        id      => $banlist->id,
    });
    $app->has_permission_error("edit by other blog (manage feedback)");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'banlist',
        id      => $banlist->id,
    });
    $app->has_invalid_request("edit by other permission");
};

subtest 'mode = edit (type is ipbanlist)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'ipbanlist',
        id      => $banlist->id,
    });
    $app->has_invalid_request("edit by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'ipbanlist',
        id      => $banlist->id,
    });
    $app->has_invalid_request("edit by permitted user (edit config)");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'ipbanlist',
        id      => $banlist->id,
    });
    $app->has_invalid_request("edit by permitted user (manage feedback)");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'banlist',
        id      => $banlist->id,
    });
    $app->has_permission_error("edit by other blog (edit config)");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'ipbanlist',
        id      => $banlist->id,
    });
    $app->has_permission_error("edit by other blog (manage feedback)");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'ipbanlist',
        id      => $banlist->id,
    });
    $app->has_invalid_request("edit by other permission");
};

subtest 'mode = delete' => sub {
    my $banlist = MT::Test::Permission->make_banlist(blog_id => $blog->id,);
    my $app     = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'banlist',
        id      => $banlist->id,
    });
    $app->has_no_permission_error("delete by admin");

    $banlist = MT::Test::Permission->make_banlist(blog_id => $blog->id,);
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'banlist',
        id      => $banlist->id,
    });
    $app->has_permission_error("delete by non permitted user (edit config)");

    $banlist = MT::Test::Permission->make_banlist(blog_id => $blog->id,);
    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'banlist',
        id      => $banlist->id,
    });
    $app->has_no_permission_error("delete by permitted user (manage feedback)");

    $banlist = MT::Test::Permission->make_banlist(blog_id => $blog->id,);
    $app->login($egawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'banlist',
        id      => $banlist->id,
    });
    $app->has_permission_error("delete by other blog (edit config)");

    $banlist = MT::Test::Permission->make_banlist(blog_id => $blog->id,);
    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'banlist',
        id      => $banlist->id,
    });
    $app->has_permission_error("delete by other blog (manage feedback)");

    $banlist = MT::Test::Permission->make_banlist(blog_id => $blog->id,);
    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'banlist',
        id      => $banlist->id,
    });
    $app->has_permission_error("delete by other permission");
};

subtest 'mode = delete (type is ipbanlist)' => sub {
    my $banlist = MT::Test::Permission->make_banlist(blog_id => $blog->id,);
    my $app     = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'ipbanlist',
        id      => $banlist->id,
    });
    $app->has_invalid_request("delete by admin");

    $banlist = MT::Test::Permission->make_banlist(blog_id => $blog->id,);
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'ipbanlist',
        id      => $banlist->id,
    });
    $app->has_invalid_request("delete by non permitted user (edit config)");

    $banlist = MT::Test::Permission->make_banlist(blog_id => $blog->id,);
    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'ipbanlist',
        id      => $banlist->id,
    });
    $app->has_invalid_request("delete by permitted user (manage feedback)");

    $banlist = MT::Test::Permission->make_banlist(blog_id => $blog->id,);
    $app->login($egawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'ipbanlist',
        id      => $banlist->id,
    });
    $app->has_permission_error("delete by other blog (edit config)");

    $banlist = MT::Test::Permission->make_banlist(blog_id => $blog->id,);
    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'ipbanlist',
        id      => $banlist->id,
    });
    $app->has_permission_error("delete by other blog (manage feedback)");

    $banlist = MT::Test::Permission->make_banlist(blog_id => $blog->id,);
    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'ipbanlist',
        id      => $banlist->id,
    });
    $app->has_invalid_request("delete by other permission");
};

done_testing();
