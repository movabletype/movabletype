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
        nickname => 'Goro Ogawa',
    );

    my $admin = MT::Author->load(1);

    # Role
    my $create_post = MT::Test::Permission->make_role(
        name        => 'Create Post',
        permissions => "'create_post'",
    );

    my $edit_tags = MT::Test::Permission->make_role(
        name        => 'Edit Tags',
        permissions => "'edit_tags'",
    );

    my $designer = MT::Role->load({ name => MT->translate('Designer') });

    require MT::Association;
    MT::Association->link($aikawa   => $create_post => $blog);
    MT::Association->link($ichikawa => $edit_tags   => $blog);
    MT::Association->link($ukawa    => $create_post => $second_blog);
    MT::Association->link($egawa    => $edit_tags   => $second_blog);
    MT::Association->link($ogawa    => $designer    => $blog);

    # Entry
    my $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ichikawa->id,
    );
    $entry->tags('alpha', 'beta');
    $entry->save;
});

my $blog = MT::Blog->load({ name => 'my blog' });

my $aikawa   = MT::Author->load({ name => 'aikawa' });
my $ichikawa = MT::Author->load({ name => 'ichikawa' });
my $ukawa    = MT::Author->load({ name => 'ukawa' });
my $egawa    = MT::Author->load({ name => 'egawa' });
my $ogawa    = MT::Author->load({ name => 'ogawa' });

my $admin = MT::Author->load(1);

require MT::Tag;
my $tag = MT::Tag->load({ name => 'alpha' });

subtest 'mode = js_tag_check' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode   => 'js_tag_check',
        blog_id  => $blog->id,
        tag_name => 'alpha',
    });
    $app->has_no_permission_error("js_tag_check by admin");

    $app->login($ichikawa);
    $app->post_ok({
        __mode   => 'js_tag_check',
        blog_id  => $blog->id,
        tag_name => 'alpha',
    });
    $app->has_no_permission_error("js_tag_check by permitted user");

    $app->login($egawa);
    $app->post_ok({
        __mode   => 'js_tag_check',
        blog_id  => $blog->id,
        tag_name => 'alpha',
    });
    $app->has_permission_error("js_tag_check by other blog");

    $app->login($ogawa);
    $app->post_ok({
        __mode   => 'js_tag_check',
        blog_id  => $blog->id,
        tag_name => 'alpha',
    });
    $app->has_permission_error("js_tag_check by other permission");
};

subtest 'mode = list' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'tag',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("list by admin");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'tag',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("list by permitted user");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'tag',
        blog_id => $blog->id,
    });
    $app->has_permission_error("list by other blog");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'tag',
        blog_id => $blog->id,
    });
    $app->has_permission_error("list by other permission");
};

subtest 'mode = rename_tag' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode   => 'rename_tag',
        blog_id  => $blog->id,
        tag_name => 'Alpha One',
        __id     => $tag->id,
    });
    $app->has_no_permission_error("rename_tag by admin");

    $app->login($ichikawa);
    $app->post_ok({
        __mode   => 'rename_tag',
        blog_id  => $blog->id,
        tag_name => 'Alpha One',
        __id     => $tag->id,
    });
    $app->has_no_permission_error("rename_tag by permitted user");

    $app->login($egawa);
    $app->post_ok({
        __mode   => 'rename_tag',
        blog_id  => $blog->id,
        tag_name => 'Alpha One',
        __id     => $tag->id,
    });
    $app->has_permission_error("rename_tag by other blog");

    $app->login($ogawa);
    $app->post_ok({
        __mode   => 'rename_tag',
        blog_id  => $blog->id,
        tag_name => 'Alpha One',
        __id     => $tag->id,
    });
    $app->has_permission_error("rename_tag by other permission");
};

subtest 'mode = save' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode => 'save',
        _type  => 'tag',
        name   => 'tag name',
    });
    $app->has_invalid_request("save by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode => 'save',
        _type  => 'tag',
        name   => 'tag name',
    });
    $app->has_invalid_request("save by non permitted user");
};

subtest 'mode = edit' => sub {
    my $tag = MT::Test::Permission->make_tag();
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode => 'edit',
        _type  => 'tag',
        id     => $tag->id,
    });
    $app->has_invalid_request("edit by admin");

    $tag = MT::Test::Permission->make_tag();
    $app->login($aikawa);
    $app->post_ok({
        __mode => 'edit',
        _type  => 'session',
        id     => $tag->id,
    });
    $app->has_invalid_request("edit by non permitted user");
};

subtest 'mode = delete' => sub {
    my $tag = MT::Test::Permission->make_tag();
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'tag',
        blog_id => $blog->id,
        id      => $tag->id,
    });
    $app->has_no_permission_error("delete by admin");

    $tag = MT::Test::Permission->make_tag();
    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'tag',
        blog_id => $blog->id,
        id      => $tag->id,
    });
    $app->has_no_permission_error("delete by permitted user");

    $tag = MT::Test::Permission->make_tag();
    $app->login($egawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'tag',
        blog_id => $blog->id,
        id      => $tag->id,
    });
    $app->has_permission_error("delete by other blog");

    $tag = MT::Test::Permission->make_tag();
    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'tag',
        blog_id => $blog->id,
        id      => $tag->id,
    });
    $app->has_permission_error("delete by other permission");
};

done_testing();
