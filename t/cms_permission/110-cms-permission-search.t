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
    my $second_website = MT::Test::Permission->make_website(
        name => 'second website',
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

    my $kagawa = MT::Test::Permission->make_author(
        name     => 'kagawa',
        nickname => 'Ichiro Kagawa',
    );

    my $kikkawa = MT::Test::Permission->make_author(
        name     => 'kikkawa',
        nickname => 'Jiro Kikkawa',
    );

    my $kumekawa = MT::Test::Permission->make_author(
        name     => 'kumekawa',
        nickname => 'Saburo Kumekawa',
    );

    my $kemikawa = MT::Test::Permission->make_author(
        name     => 'kemikawa',
        nickname => 'Shiro Kemikawa',
    );

    my $komiya = MT::Test::Permission->make_author(
        name     => 'komiya',
        nickname => 'Goro Komiya',
    );

    my $sagawa = MT::Test::Permission->make_author(
        name     => 'sagawa',
        nickname => 'Ichiro Sagawa',
    );

    my $shiki = MT::Test::Permission->make_author(
        name     => 'shiki',
        nickname => 'Jiro Shiki',
    );

    my $suda = MT::Test::Permission->make_author(
        name     => 'suda',
        nickname => 'Saburo Suda',
    );

    my $segawa = MT::Test::Permission->make_author(
        name     => 'segawa',
        nickname => 'Shiro Segawa',
    );

    my $sone = MT::Test::Permission->make_author(
        name     => 'sone',
        nickname => 'Goro Sone',
    );

    my $tachikawa = MT::Test::Permission->make_author(
        name     => 'tachikawa',
        nickname => 'Ichiro Tachikawa',
    );

    my $tsuda = MT::Test::Permission->make_author(
        name     => 'tsuda',
        nickname => 'Saburo Tsuda',
    );

    my $terakawa = MT::Test::Permission->make_author(
        name     => 'terakawa',
        nickname => 'Shiro Terakawa',
    );

    my $toda = MT::Test::Permission->make_author(
        name     => 'toda',
        nickname => 'Goro Toda',
    );

    my $nagayama = MT::Test::Permission->make_author(
        name     => 'nagayama',
        nickname => 'Ichiro Nagayama',
    );

    my $admin = MT::Author->load(1);

    # Role
    my $create_post = MT::Test::Permission->make_role(
        name        => 'Create Post',
        permissions => "'create_post'",
    );
    my $edit_all_posts = MT::Test::Permission->make_role(
        name        => 'Edit All Posts',
        permissions => "'edit_all_posts'",
    );
    my $manage_feedback = MT::Test::Permission->make_role(
        name        => 'Manage Feedback',
        permissions => "'manage_feedback'",
    );
    my $edit_templates = MT::Test::Permission->make_role(
        name        => 'Edit Templates',
        permissions => "'edit_templates'",
    );
    my $edit_assets = MT::Test::Permission->make_role(
        name        => 'Edit Assets',
        permissions => "'edit_assets'",
    );
    my $view_blog_log = MT::Test::Permission->make_role(
        name        => 'View Blog Log',
        permissions => "'view_blog_log'",
    );
    my $manage_pages = MT::Test::Permission->make_role(
        name        => 'Manage Pages',
        permissions => "'manage_pages'",
    );

    my $site_admin = MT::Role->load({ name => MT->translate('Site Administrator') });

    require MT::Association;
    MT::Association->link($aikawa   => $create_post     => $blog);
    MT::Association->link($ichikawa => $edit_all_posts  => $blog);
    MT::Association->link($ukawa    => $manage_feedback => $blog);
    MT::Association->link($egawa    => $edit_templates  => $blog);
    MT::Association->link($ogawa    => $edit_assets     => $blog);
    MT::Association->link($kagawa   => $view_blog_log   => $blog);
    MT::Association->link($kikkawa  => $manage_pages    => $blog);
    MT::Association->link($kumekawa => $site_admin      => $blog);
    MT::Association->link($kemikawa => $site_admin      => $website);

    MT::Association->link($shiki     => $create_post     => $second_blog);
    MT::Association->link($suda      => $edit_all_posts  => $second_blog);
    MT::Association->link($segawa    => $manage_feedback => $second_blog);
    MT::Association->link($sone      => $edit_templates  => $second_blog);
    MT::Association->link($tachikawa => $edit_assets     => $second_blog);
    MT::Association->link($tsuda     => $view_blog_log   => $second_blog);
    MT::Association->link($terakawa  => $manage_pages    => $second_blog);
    MT::Association->link($toda      => $site_admin      => $second_blog);
    MT::Association->link($nagayama  => $site_admin      => $second_website);

    require MT::Permission;
    my $p = MT::Permission->new;
    $p->blog_id(0);
    $p->author_id($komiya->id);
    $p->permissions("'edit_templates'");
    $p->save;

    $p = MT::Permission->new;
    $p->blog_id(0);
    $p->author_id($sagawa->id);
    $p->permissions("'view_log'");
    $p->save;
});

my $website = MT::Website->load({ name => 'my website' });

my $blog = MT::Blog->load({ name => 'my blog' });

my $aikawa    = MT::Author->load({ name => 'aikawa' });
my $ichikawa  = MT::Author->load({ name => 'ichikawa' });
my $ukawa     = MT::Author->load({ name => 'ukawa' });
my $egawa     = MT::Author->load({ name => 'egawa' });
my $ogawa     = MT::Author->load({ name => 'ogawa' });
my $kagawa    = MT::Author->load({ name => 'kagawa' });
my $kikkawa   = MT::Author->load({ name => 'kikkawa' });
my $kumekawa  = MT::Author->load({ name => 'kumekawa' });
my $kemikawa  = MT::Author->load({ name => 'kemikawa' });
my $komiya    = MT::Author->load({ name => 'komiya' });
my $sagawa    = MT::Author->load({ name => 'sagawa' });
my $shiki     = MT::Author->load({ name => 'shiki' });
my $suda      = MT::Author->load({ name => 'suda' });
my $segawa    = MT::Author->load({ name => 'segawa' });
my $sone      = MT::Author->load({ name => 'sone' });
my $tachikawa = MT::Author->load({ name => 'tachikawa' });
my $tsuda     = MT::Author->load({ name => 'tsuda' });
my $terakawa  = MT::Author->load({ name => 'terakawa' });
my $toda      = MT::Author->load({ name => 'toda' });
my $nagayama  = MT::Author->load({ name => 'nagayama' });

my $admin = MT::Author->load(1);

subtest 'search: entry' => sub {
    MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
        text      => 'aaaaaaa',
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'entry',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_no_permission_error("search:entry by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'entry',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_no_permission_error("search:entry by permitted user (create post)");

    $app->login($ichikawa);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'entry',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_no_permission_error("search:entry by permitted user (edit all posts)");

    $app->login($shiki);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'entry',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_permission_error("search:entry by other blog (create post)");

    $app->login($suda);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'entry',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_permission_error("search:entry by other blog (edit all posts)");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'search_replace',
        _type   => 'entry',
        limit   => 10,
        blog_id => $blog->id,

        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    ok(
        $app->message_text =~ m!No entries were found that match the given criteria!i,
        "search:entry by other permission"
    );
};

subtest 'search: template' => sub {
    MT::Test::Permission->make_template(
        blog_id => $blog->id,
        name    => 'Test Template',
        text    => 'aaaaaaaa',
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'template',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_no_permission_error("search:template by admin");

    $app->login($egawa);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'template',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_no_permission_error("search:template by permitted user (local)");

    $app->login($komiya);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'template',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_no_permission_error("search:template by permitted user (system)");

    $app->login($sone);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'template',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_permission_error("search:template by other blog");

    $app->login($aikawa);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'template',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    ok(
        $app->message_text =~ m!No templates were found that match the given criteria!i,
        "search:template by other permission"
    );
};

subtest 'search: asset' => sub {
    MT::Test::Permission->make_asset(
        file_name => 'aaa.txt',
        blog_id   => $blog->id,
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'asset',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_no_permission_error("search:asset by admin");

    $app->login($ogawa);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'asset',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_no_permission_error("search:asset by permitted user");

    $app->login($tachikawa);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'asset',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_permission_error("search:asset by other blog");

    $app->login($aikawa);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'asset',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    ok(
        $app->message_text =~ m!No assets were found that match the given criteria!i,
        "search:asset by other permission"
    );
};

subtest 'search: log' => sub {
    MT::Test::Permission->make_log(
        blog_id => $blog->id,
        message => 'aaaaaa',
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'log',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_no_permission_error("search:log by admin");

    $app->login($kagawa);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'log',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_no_permission_error("search:log by permitted user (local)");

    $app->login($sagawa);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'log',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
TODO: {
    local $MT::Test::Role::WebQuery::TODO = 'just for now';
    $app->has_no_permission_error("search:log by permitted user (system)");
}

    $app->login($tsuda);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'log',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_permission_error("search:log by other blog");

    $app->login($aikawa);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'log',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    ok(
        $app->message_text =~ m!No log messages were found that match the given criteria!i,
        "search:log by other permission"
    );
};

subtest 'search: author' => sub {
    MT::Test::Permission->make_author(
        name     => 'User ABC',
        nickname => 'aaa',
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'author',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_no_permission_error("search:author by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'author',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    ok(
        $app->message_text =~ m!No users were found that match the given criteria!i,
        "search:author by other permission"
    );
};

subtest 'search: blog' => sub {
    MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'aaaaaa',
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'blog',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_no_permission_error("search:blog by admin");

    $app->login($kumekawa);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'blog',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_no_permission_error("search:blog by permitted user");

    $app->login($toda);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'blog',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_permission_error("search:blog by other blog");

    $app->login($aikawa);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'blog',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    ok(
        $app->message_text =~ m!No child sites were found that match the given criteria!i,
        "search:blog by other permission"
    );
};

subtest 'search: website' => sub {
    MT::Test::Permission->make_website(name => 'aaaaaaaaaaa',);
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'website',
        limit            => 10,
        website_id       => $website->id,
        return_args      => '__mode%3Dsearch_replace%26website_id%3D' . $website->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_no_permission_error("search:website by admin");

    $app->login($kemikawa);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'website',
        limit            => 10,
        website_id       => $website->id,
        return_args      => '__mode%3Dsearch_replace%26website_id%3D' . $website->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
TODO: {
    local $MT::Test::Role::WebQuery::TODO = 'just for now';
    $app->has_no_permission_error("search:website by permitted user");
}

    $app->login($nagayama);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'website',
        limit            => 10,
        blog_id          => $website->id,
        return_args      => '__mode%3Dsearch_replace%26website_id%3D' . $website->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_permission_error("search:website by other website");

    $app->login($aikawa);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'website',
        limit            => 10,
        blog_id          => $website->id,
        return_args      => '__mode%3Dsearch_replace%26website_id%3D' . $website->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_permission_error("search:website by other permission");
};

subtest 'search: page' => sub {
    MT::Test::Permission->make_page(
        blog_id   => $blog->id,
        author_id => $kikkawa->id,
        title     => 'aaaa aaaaaaa a',
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'page',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_no_permission_error("search:page by admin");

    $app->login($kikkawa);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'page',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_no_permission_error("search:page by permitted user");

    $app->login($terakawa);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'page',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    $app->has_permission_error("search:page by other blog");

    $app->login($aikawa);
    $app->post_ok({
        __mode           => 'search_replace',
        _type            => 'page',
        limit            => 10,
        blog_id          => $blog->id,
        return_args      => '__mode%3Dsearch_replace%26blog_id%3D' . $blog->id,
        do_search        => 1,
        search           => 'aaa',
        'dates-disabled' => 1,
    });
    ok(
        $app->message_text =~ m!No pages were found that match the given criteria!i,
        "search:page by other permission"
    );
};

done_testing();
