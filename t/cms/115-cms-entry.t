#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval 'use Test::Data qw( Array ); 1'
        or plan skip_all => 'Test::Data is not installed';
}

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
use MT::Association;
use MT::Placement;
use MT::Util;

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
    my $third_website = MT::Test::Permission->make_website(
        name => 'third website',
    );

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'my blog',
    );
    my $second_blog = MT::Test::Permission->make_blog(
        parent_id => $second_website->id,
        name      => 'second blog',
    );
    my $third_blog = MT::Test::Permission->make_blog(
        parent_id => $third_website->id,
        name      => 'third blog',
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

    my $kogawa = MT::Test::Permission->make_author(
        name     => 'kogawa',
        nickname => 'Goro Kogawa',
    );

    my $admin = MT->model('author')->load(1);

    # Role
    my $create_post = MT::Test::Permission->make_role(
        name        => 'Create Post',
        permissions => "'create_post'",
    );
    my $manage_pages = MT::Test::Permission->make_role(
        name        => 'Manage Pages',
        permissions => "'manage_pages'",
    );
    my $edit_all_posts = MT::Test::Permission->make_role(
        name        => 'Edit All Posts',
        permissions => "'edit_all_posts'",
    );

    my $designer              = MT::Role->load({ name => MT->translate('Designer') });
    my $website_administrator = MT::Role->load({ name => MT->translate('Site Administrator') });

    MT::Association->link($aikawa,   $create_post,           $website);
    MT::Association->link($ogawa,    $designer,              $website);
    MT::Association->link($kagawa,   $manage_pages,          $website);
    MT::Association->link($kikkawa,  $create_post,           $website);
    MT::Association->link($kumekawa, $edit_all_posts,        $website);
    MT::Association->link($kemikawa, $website_administrator, $website);

    MT::Association->link($ukawa,    $create_post,           $blog);
    MT::Association->link($kemikawa, $website_administrator, $blog);

    MT::Association->link($ichikawa, $create_post, $second_website);
    MT::Association->link($egawa,    $create_post, $second_blog);

    MT::Association->link($aikawa, $website_administrator, $third_blog);
    MT::Association->link($kogawa, $create_post,           $third_blog);

    # Category
    my $website_cat = MT::Test::Permission->make_category(
        blog_id   => $website->id,
        author_id => $admin->id,
        label     => 'Foo',
    );
    my $website_cat2 = MT::Test::Permission->make_category(
        blog_id   => $website->id,
        author_id => $admin->id,
        label     => 'Bar',
    );

    # Entry
    my $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $aikawa->id,
        title     => 'Website Entry by Aikawa',
    );
    my $website_cat_entry = MT::Test::Permission->make_entry(
        blog_id     => $website->id,
        author_id   => $aikawa->id,
        category_id => $website_cat->id,
        title       => 'Website Category Entry by Aikawa',
    );
    my $place = MT::Placement->new;
    $place->entry_id($website_cat_entry->id);
    $place->blog_id($website->id);
    $place->category_id($website_cat->id);
    $place->is_primary(1);
    $place->save;

    my $blog_entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ukawa->id,
        title     => 'Child Blog Entry by Ukawa',
    );

    my $second_website_entry = MT::Test::Permission->make_entry(
        blog_id   => $second_website->id,
        author_id => $ichikawa->id,
        title     => 'Other Website Entry by ichikawa',
    );

    my $third_blog_entry_aikawa = MT::Test::Permission->make_entry(
        blog_id   => $third_blog->id,
        author_id => $aikawa->id,
        title     => 'Third blog Entry by aikawa',
    );

    my $third_blog_entry_kogawa = MT::Test::Permission->make_entry(
        blog_id   => $third_blog->id,
        author_id => $kogawa->id,
        title     => 'Third blog Entry by kogawa',
    );

    # Page
    my $website_page = MT::Test::Permission->make_page(
        blog_id   => $website->id,
        author_id => $kagawa->id,
        title     => 'Website Page by Kagawa',
    );
});

my $website = MT::Website->load({ name => 'my website' });

my $blog       = MT::Blog->load({ name => 'my blog' });
my $third_blog = MT::Blog->load({ name => 'third blog' });

my $aikawa   = MT::Author->load({ name => 'aikawa' });
my $ichikawa = MT::Author->load({ name => 'ichikawa' });
my $ukawa    = MT::Author->load({ name => 'ukawa' });
my $egawa    = MT::Author->load({ name => 'egawa' });
my $ogawa    = MT::Author->load({ name => 'ogawa' });
my $kagawa   = MT::Author->load({ name => 'kagawa' });
my $kikkawa  = MT::Author->load({ name => 'kikkawa' });
my $kumekawa = MT::Author->load({ name => 'kumekawa' });
my $kemikawa = MT::Author->load({ name => 'kemikawa' });
my $kogawa   = MT::Author->load({ name => 'kogawa' });

my $admin = MT->model('author')->load(1);

my $website_cat  = MT::Category->load({ label => 'Foo' });
my $website_cat2 = MT::Category->load({ label => 'Bar' });

my $website_entry = MT::Entry->load({ title => 'Website Entry by Aikawa' });

my $blog_entry = MT::Entry->load({ title => 'Child Blog Entry by Ukawa' });

subtest 'Filtered list with unknown column' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
    $app->login($admin);
    $app->post_ok({
        __test_user      => $admin,
        __request_method => 'POST',
        __mode           => 'filtered_list',
        datasource       => 'entry',
        blog_id          => $website->id,
        columns          => 'title,unknown',
        fid              => '_allpass',
    });
    my $json = $app->json;
    ok($json->{result}, 'json is returned');
    is($json->{error}, undef, 'no error');
};

subtest 'Test in website scope' => sub {

    subtest 'Menu visibility check' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode  => 'dashboard',
            blog_id => $website->id
        });

        my @labels = _get_entries_menu_labels($app);
    SKIP: {
            skip "new UI", 2 unless $ENV{MT_TEST_NEW_UI};
            array_any_ok(
                'New', @labels,
                '"Entries New" menu in website scope exists if admin'
            );
            array_any_ok(
                'Manage', @labels,
                '"Entries Manage" menu in website scope exists if admin'
            );
        }

        my $fav_action_entry = 'fav-action-entry';
    SKIP: {
            skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
            $app->content_like(
                qr/$fav_action_entry/,
                '"Entry" in compose menus exists if admin'
            );
        }

        $app->login($aikawa);
        $app->get_ok({
            __mode  => 'dashboard',
            blog_id => $website->id
        });

        @labels = _get_entries_menu_labels($app);
    SKIP: {
            skip "new UI", 2 unless $ENV{MT_TEST_NEW_UI};
            array_any_ok(
                'New', @labels,
                '"Entries New" menu in website scope exists if permitted user'
            );
            array_any_ok(
                'Manage', @labels,
                '"Entries Manage" menu in website scope exists if permitted user'
            );
        }

    SKIP: {
            skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
            $app->content_like(
                qr/$fav_action_entry/,
                '"Entry" in compose menus exists if permitted user'
            );
        }

        $app->login($ichikawa);
        $app->get_ok({
            __mode  => 'dashboard',
            blog_id => $website->id
        });

        @labels = _get_entries_menu_labels($app);
        array_none_ok(
            'New', @labels,
            '"Entries New" menu and "Entries Manage" menu in website scope does not exist if other website'
        );
        array_none_ok(
            'Manage', @labels,
            '"Entries New" menu and "Entries Manage" menu in website scope does not exist if other website'
        );

        $app->content_unlike(
            qr/$fav_action_entry/,
            '"Entry" in compose menus exists if other website'
        );

        $app->login($ukawa);
        $app->get_ok({
            __mode  => 'dashboard',
            blog_id => $website->id
        });

        @labels = _get_entries_menu_labels($app);
        array_none_ok(
            'New', @labels,
            '"Entries New" menu in website scope does not exist if child blog'
        );
    SKIP: {
            skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
            array_any_ok(
                'Manage', @labels,
                '"Entries Manage" menu in website scope exists if child blog'
            );
        }

        $app->content_unlike(
            qr/$fav_action_entry/,
            '"Entry" in compose menus exists if child blog'
        );

        $app->login($egawa);
        $app->get_ok({
            __mode  => 'dashboard',
            blog_id => $website->id
        });

        @labels = _get_entries_menu_labels($app);
        array_none_ok(
            'New', @labels,
            '"Entries New" menu in website scope does not exist if other blog'
        );
        array_none_ok(
            'Manage', @labels,
            '"Entries Manage" menu in website scope does not exist if other blog'
        );

        $app->content_unlike(
            qr/$fav_action_entry/,
            '"Entry" in compose menus exists if other blog'
        );

        $app->login($ogawa);
        $app->get_ok({
            __mode  => 'dashboard',
            blog_id => $website->id
        });

        @labels = _get_entries_menu_labels($app);
        array_none_ok(
            'New', @labels,
            '"Entries New" menu in website scope does not exist if other permission'
        );
        array_none_ok(
            'Manage', @labels,
            '"Entries Manage" menu in website scope does not exist if other permission'
        );

        $app->content_unlike(
            qr/$fav_action_entry/,
            '"Entry" in compose menus exists if other permission'
        );
    };

    subtest 'Entry listing screen visibility check' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode  => 'list',
            _type   => 'entry',
            blog_id => $website->id,
        });

        my $column = quotemeta('<span class="col-label">Website/Blog Name</span>');
        $column = qr/$column/;
    SKIP: {
            skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
            $app->content_like($column, '"Website/Blog Name" column exists');
        }

        local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'entry',
            blog_id    => $website->id,
            columns    => 'blog_name',
            fid        => '_allpass',
        });

        my $blog_name = quotemeta($website->name . '/' . $blog->name);
        $app->content_like(
            qr/$blog_name/,
            '"Website/Blog Name" column\'s format in website scope is correct'
        );
    };

    subtest 'Filtered list check' => sub {
        note 'Get filtered list by admin';
        local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'entry',
            blog_id    => $website->id,
            columns    => 'title',
            fid        => '_allpass',
        });
        $app->content_like(qr/Website Entry by Aikawa/, 'Got an entry in website');
        $app->content_like(
            qr/Website Category Entry by Aikawa/,
            'Got a category entry in website'
        );
        $app->content_like(
            qr/Child Blog Entry by Ukawa/,
            'Got an entry in child blog'
        );

        note 'Get filtered list by website administrator';
        $app->login($kemikawa);
        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'entry',
            blog_id    => $website->id,
            columns    => 'title',
            fid        => '_allpass',
        });
        $app->content_like(qr/Website Entry by Aikawa/, 'Got an entry in website');
        $app->content_like(
            qr/Website Category Entry by Aikawa/,
            'Got a category entry in website'
        );
        $app->content_like(
            qr/Child Blog Entry by Ukawa/,
            'Got an entry in child blog'
        );

        note 'Get filtered list by permitted user (create post) in website';
        $app->login($aikawa);
        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'entry',
            blog_id    => $website->id,
            columns    => 'title',
            fid        => '_allpass',
        });
        $app->content_like(qr/Website Entry by Aikawa/, 'Got an entry in website');
        $app->content_like(
            qr/Website Category Entry by Aikawa/,
            'Got a category entry in website'
        );
        $app->content_unlike(
            qr/Child Blog Entry by Ukawa/,
            'Did not get an entry in child blog'
        );

        note 'Get filtered list by other permitted user (create post) in website';
        $app->login($kikkawa);
        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'entry',
            blog_id    => $website->id,
            columns    => 'title',
            fid        => '_allpass',
        });
        $app->content_unlike(
            qr/Website Entry by Aikawa/,
            'Did not get an entry in website'
        );
        $app->content_unlike(
            qr/Website Category Entry by Aikawa/,
            'Did not get a category entry in website'
        );
        $app->content_unlike(
            qr/Child Blog Entry by Ukawa/,
            'Did not get an entry in child blog'
        );

        note 'Get filtered list by other permitted user (edit all posts) in website';
        $app->login($kumekawa);
        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'entry',
            blog_id    => $website->id,
            columns    => 'title',
            fid        => '_allpass',
        });
        $app->content_like(qr/Website Entry by Aikawa/, 'Got an entry in website');
        $app->content_like(
            qr/Website Category Entry by Aikawa/,
            'Got a category entry in website'
        );
        $app->content_unlike(
            qr/Child Blog Entry by Ukawa/,
            'Did not get an entry in child blog'
        );

        note 'Get filtered list by permitted user in child blog';
        $app->login($ukawa);
        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'entry',
            blog_id    => $website->id,
            columns    => 'title',
            fid        => '_allpass',
        });
        $app->content_unlike(
            qr/Website Entry by Aikawa/,
            'Did not get an entry in website'
        );
        $app->content_unlike(
            qr/Website Category Entry by Aikawa/,
            'Did not get a category entry in website'
        );
        $app->content_like(
            qr/Child Blog Entry by Ukawa/,
            'Got an entry in child blog'
        );

        note 'Get filtered list by other website';
        $app->login($ichikawa);
        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'entry',
            blog_id    => $website->id,
            columns    => 'title',
            fid        => '_allpass',
        });
        $app->content_unlike(
            qr/Website Entry by Aikawa/,
            'Did not get an entry in website'
        );
        $app->content_unlike(
            qr/Website Category Entry by Aikawa/,
            'Did not get a category entry in website'
        );
        $app->content_unlike(
            qr/Child Blog Entry by Ukawa/,
            'Did not get an entry in child blog'
        );

        note 'Get filtered list by other blog';
        $app->login($egawa);
        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'entry',
            blog_id    => $website->id,
            columns    => 'title',
            fid        => '_allpass',
        });
        $app->content_unlike(
            qr/Website Entry by Aikawa/,
            'Did not get an entry in website'
        );
        $app->content_unlike(
            qr/Website Category Entry by Aikawa/,
            'Did not get a category entry in website'
        );
        $app->content_unlike(
            qr/Child Blog Entry by Ukawa/,
            'Did not get an entry in child blog'
        );

        note 'Get filtered list by other permission';
        $app->login($ogawa);
        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'entry',
            blog_id    => $website->id,
            columns    => 'title',
            fid        => '_allpass',
        });
        $app->content_unlike(
            qr/Website Entry by Aikawa/,
            'Did not get an entry in website'
        );
        $app->content_unlike(
            qr/Website Category Entry by Aikawa/,
            'Did not get a category entry in website'
        );
        $app->content_unlike(
            qr/Child Blog Entry by Ukawa/,
            'Did not get an entry in child blog'
        );
    };

    subtest 'Built in filter check' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode  => 'list',
            _type   => 'entry',
            blog_id => $website->id,
        });

        $app->content_like(
            qr/Entries in This Site/,
            'System filter "Entries in This Site" exists'
        );

        local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'entry',
            blog_id    => $website->id,
            columns    => 'title',
            fid        => '_allpass',
        });

        $app->content_like(qr/Website Entry by Aikawa/, 'Got an entry in website');
        $app->content_like(
            qr/Website Category Entry by Aikawa/,
            'Got an category entry in website'
        );
        $app->content_like(
            qr/Child Blog Entry by Ukawa/,
            'Got an entry in child blog'
        );
        $app->content_unlike(
            qr/Other Website Entry by ichikawa/,
            'Did not get an entry in other website'
        );
        $app->content_unlike(qr/Website Page by Kagawa/, 'Did not get an page');

        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'entry',
            blog_id    => $website->id,
            columns    => 'title',
            fid        => 'current_website',
            items      => "[{\"type\":\"current_context\",\"args\":{\"value\":\"\",\"label\":\"\"}}]",
        });

        $app->content_like(qr/Website Entry by Aikawa/, 'Got an entry in website');
        $app->content_like(
            qr/Website Category Entry by Aikawa/,
            'Got an category entry in website'
        );
        $app->content_unlike(
            qr/Child Blog Entry by Ukawa/,
            'Did not get an entry in child blog'
        );
        $app->content_unlike(
            qr/Other Website Entry by ichikawa/,
            'Did not get an entry in other website'
        );
        $app->content_unlike(qr/Website Page by Kagawa/, 'Did not get an page');

        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'entry',
            blog_id    => $website->id,
            columns    => 'title',
            items      => "[{\"type\":\"category_id\",\"args\":{\"value\":\"" . $website_cat->id . "\",\"label\":\"\"}}]",
        });

        $app->content_like(
            qr/Website Category Entry by Aikawa/,
            'Got an category entry in website'
        );
        $app->content_unlike(
            qr/Website Entry by Aikawa/,
            'Did not get an entry in website'
        );
        $app->content_unlike(
            qr/Child Blog Entry by Ukawa/,
            'Did not get an entry in child blog'
        );
        $app->content_unlike(
            qr/Other Website Entry by ichikawa/,
            'Did not get an entry in other website'
        );
        $app->content_unlike(qr/Website Page by Kagawa/, 'Did not get an page');

        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'entry',
            blog_id    => $website->id,
            columns    => 'title',
            items      => "[{\"type\":\"category\",\"args\":{\"option\":\"equal\",\"string\":\"" . $website_cat->label . "\"}}]",
        });

        $app->content_like(
            qr/Website Category Entry by Aikawa/,
            'Got an category entry in website'
        );
        $app->content_unlike(
            qr/Website Entry by Aikawa/,
            'Did not get an entry in website'
        );
        $app->content_unlike(
            qr/Child Blog Entry by Ukawa/,
            'Did not get an entry in child blog'
        );
        $app->content_unlike(
            qr/Other Website Entry by ichikawa/,
            'Did not get an entry in other website'
        );
        $app->content_unlike(qr/Website Page by Kagawa/, 'Did not get an page');
    };

    subtest 'Custom filter check' => sub {
        local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'entry',
            blog_id    => $third_blog->id,
            columns    => 'title',
            items      => "[{\"type\":\"author_name\",\"args\":{\"string\":\"a\",\"option\":\"contains\"}}]",
        });
        my $json = MT::Util::from_json($app->content);
        is($json->{result}{count}, 2, "Contains 'a'");

        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'entry',
            blog_id    => $third_blog->id,
            columns    => 'title',
            items      => "[{\"type\":\"author_name\",\"args\":{\"string\":\"g\",\"option\":\"contains\"}}]",
        });
        $json = MT::Util::from_json($app->content);
        is($json->{result}{count}, 1, "Contains 'g'");

        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'entry',
            blog_id    => $third_blog->id,
            columns    => 'title',
            items      => "[{\"type\":\"author_name\",\"args\":{\"string\":\"q\",\"option\":\"contains\"}}]",
        });
        $json = MT::Util::from_json($app->content);
        is($json->{result}{count}, 0, "Contains 'q'");

        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'entry',
            blog_id    => $third_blog->id,
            columns    => 'title',
            items      => "[{\"type\":\"author_name\",\"args\":{\"string\":\"a\",\"option\":\"not_contains\"}}]",
        });
        $json = MT::Util::from_json($app->content);
        is($json->{result}{count}, 0, "Not contains 'a'");
    };

    subtest 'Batch edit entries check' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode                 => 'itemset_action',
            _type                  => 'entry',
            blog_id                => $website->id,
            action_name            => 'open_batch_editor',
            plugin_action_selector => 'open_batch_editor',
            id                     => [$website_entry->id, $blog_entry->id],
        });

        $app->content_like(qr/Website Entry by Aikawa/, "Has an entry in website");
        $app->content_like(
            qr/Child Blog Entry by Ukawa/,
            "Has an entry in child blog"
        );
    };
};

subtest 'Save prefs check' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    my $res = $app->post_ok({
        __mode       => 'save_entry_prefs',
        _type        => 'entry',
        blog_id      => $website->id,
        entry_prefs  => 'Custom',
        custom_prefs => 'title,text,keywords,tags,category,feedback,assets',
        sort_only    => 'false',
    });
    my $json = MT::Util::from_json($app->content);

    ok(
        $res->header('content-type') =~ m/application\/json/,
        'Content-Type is application/json'
    );
    ok($json->{result}{success}, 'Json result is success');
};

subtest 'Save prefs check type mismatch' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode       => 'save_entry_prefs',
        _type        => 'template',
        blog_id      => $website->id,
        entry_prefs  => 'Custom',
        custom_prefs => 'title,text,keywords,tags,category,feedback,assets',
        sort_only    => 'false',
    });
    $app->has_invalid_request("save_prefs check type mismatch");
};

done_testing();

sub _get_entries_menu_labels {
    my $app = shift;

    my @labels;
    $app->wq_find('li#menu-entry > ul.sub-menu > li')->each(sub {
        push @labels, $_->find('span')->innerHTML;
    });

    return @labels;
}
