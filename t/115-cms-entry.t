#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';

    eval 'use Test::Data qw( Array ); 1'
        or plan skip_all => 'Test::Data is not installed';

    eval 'use pQuery; 1'
        or plan skip_all => 'pQuery is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Association;
use MT::Placement;
use MT::Util;

MT::Test->init_app;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website        = MT::Test::Permission->make_website(
        name => 'my website',
    );
    my $second_website = MT::Test::Permission->make_website(
        name => 'second website',
    );
    my $third_website  = MT::Test::Permission->make_website(
        name => 'third website',
    );

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name => 'my blog',
    );
    my $second_blog = MT::Test::Permission->make_blog(
        parent_id => $second_website->id,
        name => 'second blog',
    );
    my $third_blog = MT::Test::Permission->make_blog(
        parent_id => $third_website->id,
        name => 'third blog',
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

    my $designer = MT::Role->load( { name => MT->translate('Designer') } );
    my $website_administrator
        = MT::Role->load( { name => MT->translate('Site Administrator') } );

    MT::Association->link( $aikawa,   $create_post,           $website );
    MT::Association->link( $ogawa,    $designer,              $website );
    MT::Association->link( $kagawa,   $manage_pages,          $website );
    MT::Association->link( $kikkawa,  $create_post,           $website );
    MT::Association->link( $kumekawa, $edit_all_posts,        $website );
    MT::Association->link( $kemikawa, $website_administrator, $website );

    MT::Association->link( $ukawa,    $create_post,           $blog );
    MT::Association->link( $kemikawa, $website_administrator, $blog );

    MT::Association->link( $ichikawa, $create_post, $second_website );
    MT::Association->link( $egawa,    $create_post, $second_blog );

    MT::Association->link( $aikawa, $website_administrator, $third_blog );
    MT::Association->link( $kogawa, $create_post,           $third_blog );

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
    $place->entry_id( $website_cat_entry->id );
    $place->blog_id( $website->id );
    $place->category_id( $website_cat->id );
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

my $website = MT::Website->load( { name => 'my website' } );

my $blog       = MT::Blog->load( { name => 'my blog' } );
my $third_blog = MT::Blog->load( { name => 'third blog' } );

my $aikawa   = MT::Author->load( { name => 'aikawa' } );
my $ichikawa = MT::Author->load( { name => 'ichikawa' } );
my $ukawa    = MT::Author->load( { name => 'ukawa' } );
my $egawa    = MT::Author->load( { name => 'egawa' } );
my $ogawa    = MT::Author->load( { name => 'ogawa' } );
my $kagawa   = MT::Author->load( { name => 'kagawa' } );
my $kikkawa  = MT::Author->load( { name => 'kikkawa' } );
my $kumekawa = MT::Author->load( { name => 'kumekawa' } );
my $kemikawa = MT::Author->load( { name => 'kemikawa' } );
my $kogawa   = MT::Author->load( { name => 'kogawa' } );

my $admin = MT->model('author')->load(1);

my $website_cat  = MT::Category->load( { label => 'Foo' } );
my $website_cat2 = MT::Category->load( { label => 'Bar' } );

my $website_entry = MT::Entry->load( { title => 'Website Entry by Aikawa' } );

my $blog_entry = MT::Entry->load( { title => 'Child Blog Entry by Ukawa' } );

# Run tests
my ( $app, $out );

note 'Test in website scope';
subtest 'Test in website scope' => sub {

    note 'Menu visibility check';
    subtest 'Menu visibility check' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $admin,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );

        my @labels = _get_entries_menu_labels($out);
SKIP: {
        skip "new UI", 2 unless $ENV{MT_TEST_NEW_UI};
        array_any_ok( 'New', @labels,
            '"Entries New" menu in website scope exists if admin' );
        array_any_ok( 'Manage', @labels,
            '"Entries Manage" menu in website scope exists if admin' );
}

        my $fav_action_entry = 'fav-action-entry';
SKIP: {
        skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
        like( $out, qr/$fav_action_entry/,
            '"Entry" in compose menus exists if admin' );
}

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $aikawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );

        @labels = _get_entries_menu_labels($out);
SKIP: {
        skip "new UI", 2 unless $ENV{MT_TEST_NEW_UI};
        array_any_ok( 'New', @labels,
            '"Entries New" menu in website scope exists if permitted user' );
        array_any_ok( 'Manage', @labels,
            '"Entries Manage" menu in website scope exists if permitted user'
        );
}

SKIP: {
        skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
        like( $out, qr/$fav_action_entry/,
            '"Entry" in compose menus exists if permitted user' );
}

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $ichikawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );

        @labels = _get_entries_menu_labels($out);
        array_none_ok( 'New', @labels,
            '"Entries New" menu and "Entries Manage" menu in website scope does not exist if other website'
        );
        array_none_ok( 'Manage', @labels,
            '"Entries New" menu and "Entries Manage" menu in website scope does not exist if other website'
        );

        unlike( $out, qr/$fav_action_entry/,
            '"Entry" in compose menus exists if other website' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $ukawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );

        @labels = _get_entries_menu_labels($out);
        array_none_ok( 'New', @labels,
            '"Entries New" menu in website scope does not exist if child blog'
        );
SKIP: {
        skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
        array_any_ok( 'Manage', @labels,
            '"Entries Manage" menu in website scope exists if child blog' );
}

        unlike( $out, qr/$fav_action_entry/,
            '"Entry" in compose menus exists if child blog' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $egawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );

        @labels = _get_entries_menu_labels($out);
        array_none_ok( 'New', @labels,
            '"Entries New" menu in website scope does not exist if other blog'
        );
        array_none_ok( 'Manage', @labels,
            '"Entries Manage" menu in website scope does not exist if other blog'
        );

        unlike( $out, qr/$fav_action_entry/,
            '"Entry" in compose menus exists if other blog' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $ogawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );

        @labels = _get_entries_menu_labels($out);
        array_none_ok( 'New', @labels,
            '"Entries New" menu in website scope does not exist if other permission'
        );
        array_none_ok( 'Manage', @labels,
            '"Entries Manage" menu in website scope does not exist if other permission'
        );

        unlike( $out, qr/$fav_action_entry/,
            '"Entry" in compose menus exists if other permission' );

        done_testing();
    };

    note 'Entry listing screen visibility check';
    subtest 'Entry listing screen visibility check' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $admin,
                __mode      => 'list',
                _type       => 'entry',
                blog_id     => $website->id,
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: list" );

        like( $out, qr/Entry Feed/, 'Entry Feed in website scope exists' );
        my $column
            = quotemeta('<span class="col-label">Website/Blog Name</span>');
        $column = qr/$column/;
SKIP: {
        skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
        like( $out, $column, '"Website/Blog Name" column exists' );
}

        local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $website->id,
                columns          => 'blog_name',
                fid              => '_allpass',
            },
        );
        $out = delete $app->{__test_output};

        my $blog_name = quotemeta( $website->name . '/' . $blog->name );
        like( $out, qr/$blog_name/,
            '"Website/Blog Name" column\'s format in website scope is correct'
        );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => 0,
                columns          => 'blog_name',
                fid              => '_allpass',
            },
        );
        $out = delete $app->{__test_output};

        like( $out, qr/$blog_name/,
            '"Website/Blog Name" column\'s format in system scope is correct'
        );

        done_testing();
    };

    note 'Filtered list check';
    subtest 'Filtered list check' => sub {
        note 'Get filtered list by admin';
        local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $website->id,
                columns          => 'title',
                fid              => '_allpass',
            },
        );
        $out = delete $app->{__test_output};
        like( $out, qr/Website Entry by Aikawa/, 'Got an entry in website' );
        like(
            $out,
            qr/Website Category Entry by Aikawa/,
            'Got a category entry in website'
        );
        like(
            $out,
            qr/Child Blog Entry by Ukawa/,
            'Got an entry in child blog'
        );

        note 'Get filtered list by website administrator';
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kemikawa,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $website->id,
                columns          => 'title',
                fid              => '_allpass',
            },
        );
        $out = delete $app->{__test_output};
        like( $out, qr/Website Entry by Aikawa/, 'Got an entry in website' );
        like(
            $out,
            qr/Website Category Entry by Aikawa/,
            'Got a category entry in website'
        );
        like(
            $out,
            qr/Child Blog Entry by Ukawa/,
            'Got an entry in child blog'
        );

        note 'Get filtered list by permitted user (create post) in website';
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $website->id,
                columns          => 'title',
                fid              => '_allpass',
            },
        );
        $out = delete $app->{__test_output};
        like( $out, qr/Website Entry by Aikawa/, 'Got an entry in website' );
        like(
            $out,
            qr/Website Category Entry by Aikawa/,
            'Got a category entry in website'
        );
        unlike(
            $out,
            qr/Child Blog Entry by Ukawa/,
            'Did not get an entry in child blog'
        );

        note
            'Get filtered list by other permitted user (create post) in website';
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kikkawa,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $website->id,
                columns          => 'title',
                fid              => '_allpass',
            },
        );
        $out = delete $app->{__test_output};
        unlike(
            $out,
            qr/Website Entry by Aikawa/,
            'Did not get an entry in website'
        );
        unlike(
            $out,
            qr/Website Category Entry by Aikawa/,
            'Did not get a category entry in website'
        );
        unlike(
            $out,
            qr/Child Blog Entry by Ukawa/,
            'Did not get an entry in child blog'
        );

        note
            'Get filtered list by other permitted user (edit all posts) in website';
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kumekawa,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $website->id,
                columns          => 'title',
                fid              => '_allpass',
            },
        );
        $out = delete $app->{__test_output};
        like( $out, qr/Website Entry by Aikawa/, 'Got an entry in website' );
        like(
            $out,
            qr/Website Category Entry by Aikawa/,
            'Got a category entry in website'
        );
        unlike(
            $out,
            qr/Child Blog Entry by Ukawa/,
            'Did not get an entry in child blog'
        );

        note 'Get filtered list by permitted user in child blog';
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $website->id,
                columns          => 'title',
                fid              => '_allpass',
            },
        );
        $out = delete $app->{__test_output};
        unlike(
            $out,
            qr/Website Entry by Aikawa/,
            'Did not get an entry in website'
        );
        unlike(
            $out,
            qr/Website Category Entry by Aikawa/,
            'Did not get a category entry in website'
        );
        like(
            $out,
            qr/Child Blog Entry by Ukawa/,
            'Got an entry in child blog'
        );

        note 'Get filtered list by other website';
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ichikawa,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $website->id,
                columns          => 'title',
                fid              => '_allpass',
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, 'Request: filtered_list' );
        unlike(
            $out,
            qr/Website Entry by Aikawa/,
            'Did not get an entry in website'
        );
        unlike(
            $out,
            qr/Website Category Entry by Aikawa/,
            'Did not get a category entry in website'
        );
        unlike(
            $out,
            qr/Child Blog Entry by Ukawa/,
            'Did not get an entry in child blog'
        );

        note 'Get filtered list by other blog';
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $egawa,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $website->id,
                columns          => 'title',
                fid              => '_allpass',
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, 'Request: filtered_list' );
        unlike(
            $out,
            qr/Website Entry by Aikawa/,
            'Did not get an entry in website'
        );
        unlike(
            $out,
            qr/Website Category Entry by Aikawa/,
            'Did not get a category entry in website'
        );
        unlike(
            $out,
            qr/Child Blog Entry by Ukawa/,
            'Did not get an entry in child blog'
        );

        note 'Get filtered list by other permission';
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $website->id,
                columns          => 'title',
                fid              => '_allpass',
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, 'Request: filtered_list' );
        unlike(
            $out,
            qr/Website Entry by Aikawa/,
            'Did not get an entry in website'
        );
        unlike(
            $out,
            qr/Website Category Entry by Aikawa/,
            'Did not get a category entry in website'
        );
        unlike(
            $out,
            qr/Child Blog Entry by Ukawa/,
            'Did not get an entry in child blog'
        );

    };

    note 'Built in filter check';
    subtest 'Built in filter check' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $admin,
                __mode      => 'list',
                _type       => 'entry',
                blog_id     => $website->id,
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: list" );

        like(
            $out,
            qr/Entries in This Website/,
            'System filter "Entries in This Website" exists'
        );

        local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $website->id,
                columns          => 'title',
                fid              => '_allpass',
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: filtered_list" );

        like( $out, qr/Website Entry by Aikawa/, 'Got an entry in website' );
        like(
            $out,
            qr/Website Category Entry by Aikawa/,
            'Got an category entry in website'
        );
        like(
            $out,
            qr/Child Blog Entry by Ukawa/,
            'Got an entry in child blog'
        );
        unlike(
            $out,
            qr/Other Website Entry by ichikawa/,
            'Did not get an entry in other website'
        );
        unlike( $out, qr/Website Page by Kagawa/, 'Did not get an page' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $website->id,
                columns          => 'title',
                fid              => 'current_website',
                items =>
                    "[{\"type\":\"current_context\",\"args\":{\"value\":\"\",\"label\":\"\"}}]",
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: filtered_list" );

        like( $out, qr/Website Entry by Aikawa/, 'Got an entry in website' );
        like(
            $out,
            qr/Website Category Entry by Aikawa/,
            'Got an category entry in website'
        );
        unlike(
            $out,
            qr/Child Blog Entry by Ukawa/,
            'Did not get an entry in child blog'
        );
        unlike(
            $out,
            qr/Other Website Entry by ichikawa/,
            'Did not get an entry in other website'
        );
        unlike( $out, qr/Website Page by Kagawa/, 'Did not get an page' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $website->id,
                columns          => 'title',
                items => "[{\"type\":\"category_id\",\"args\":{\"value\":\""
                    . $website_cat->id
                    . "\",\"label\":\"\"}}]",
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: filtered_list" );

        like(
            $out,
            qr/Website Category Entry by Aikawa/,
            'Got an category entry in website'
        );
        unlike(
            $out,
            qr/Website Entry by Aikawa/,
            'Did not get an entry in website'
        );
        unlike(
            $out,
            qr/Child Blog Entry by Ukawa/,
            'Did not get an entry in child blog'
        );
        unlike(
            $out,
            qr/Other Website Entry by ichikawa/,
            'Did not get an entry in other website'
        );
        unlike( $out, qr/Website Page by Kagawa/, 'Did not get an page' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $website->id,
                columns          => 'title',
                items =>
                    "[{\"type\":\"category\",\"args\":{\"option\":\"equal\",\"string\":\""
                    . $website_cat->label . "\"}}]",
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: filtered_list" );

        like(
            $out,
            qr/Website Category Entry by Aikawa/,
            'Got an category entry in website'
        );
        unlike(
            $out,
            qr/Website Entry by Aikawa/,
            'Did not get an entry in website'
        );
        unlike(
            $out,
            qr/Child Blog Entry by Ukawa/,
            'Did not get an entry in child blog'
        );
        unlike(
            $out,
            qr/Other Website Entry by ichikawa/,
            'Did not get an entry in other website'
        );
        unlike( $out, qr/Website Page by Kagawa/, 'Did not get an page' );

        done_testing();
    };

    note 'Custom filter check';
    subtest 'Custom filter check' => sub {
        local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
        my ( $headers, $body, $json );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $third_blog->id,
                columns          => 'title',
                items =>
                    "[{\"type\":\"author_name\",\"args\":{\"string\":\"a\",\"option\":\"contains\"}}]",
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: filtered_list" );
        ( $headers, $body ) = split /^\s*$/m, $out;
        $json = MT::Util::from_json($body);
        is( $json->{result}{count}, 2, "Contains 'a'" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $third_blog->id,
                columns          => 'title',
                items =>
                    "[{\"type\":\"author_name\",\"args\":{\"string\":\"g\",\"option\":\"contains\"}}]",
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: filtered_list" );
        ( $headers, $body ) = split /^\s*$/m, $out;
        $json = MT::Util::from_json($body);
        is( $json->{result}{count}, 1, "Contains 'g'" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $third_blog->id,
                columns          => 'title',
                items =>
                    "[{\"type\":\"author_name\",\"args\":{\"string\":\"q\",\"option\":\"contains\"}}]",
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: filtered_list" );
        ( $headers, $body ) = split /^\s*$/m, $out;
        $json = MT::Util::from_json($body);
        is( $json->{result}{count}, 0, "Contains 'q'" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $third_blog->id,
                columns          => 'title',
                items =>
                    "[{\"type\":\"author_name\",\"args\":{\"string\":\"a\",\"option\":\"not_contains\"}}]",
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: filtered_list" );
        ( $headers, $body ) = split /^\s*$/m, $out;
        $json = MT::Util::from_json($body);
        is( $json->{result}{count}, 0, "Not contains 'a'" );

        done_testing();
    };

    subtest 'Batch edit entries check' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user            => $admin,
                __request_method       => 'POST',
                __mode                 => 'itemset_action',
                _type                  => 'entry',
                blog_id                => $website->id,
                action_name            => 'open_batch_editor',
                plugin_action_selector => 'open_batch_editor',
                id => [ $website_entry->id, $blog_entry->id ],
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: open_batch_editor" );

        like( $out, qr/Website Entry by Aikawa/, "Has an entry in website" );
        like(
            $out,
            qr/Child Blog Entry by Ukawa/,
            "Has an entry in child blog"
        );

        done_testing();
    };

    done_testing();
};

note 'The cache of new entry check';
subtest 'The cache of new entry check' => sub {
    my $categories;

    my $mock_entry = Test::MockModule->new('MT::Entry');
    $mock_entry->mock(
        'categories',
        sub {
            $categories = $mock_entry->original('categories')->(@_);
        }
    );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'entry',
            blog_id          => $website->id,
            author_id        => $admin->id,
            status           => 2,
            category_ids     => $website_cat->id . ',' . $website_cat2->id,
        },
    );
    my $out = delete $app->{__test_output};

    is_deeply(
        [ map { $_->id } @$categories ],
        [ $website_cat2->id, $website_cat->id ],
        'A new entry has category "Bar" and category "Foo" in cache.'
    );
};

subtest 'Save prefs check' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save_entry_prefs',
            _type            => 'entry',
            blog_id          => $website->id,
            entry_prefs      => 'Custom',
            custom_prefs =>
                'title,text,keywords,tags,category,feedback,assets',
            sort_only => 'false',
        },
    );
    my $out = delete $app->{__test_output};
    my ( $headers, $body ) = split /^\s*$/m, $out;
    my $json    = MT::Util::from_json($body);
    my %headers = map {
        my ( $k, $v ) = split /\s*:\s*/, $_, 2;
        $v =~ s/(\r\n|\r|\n)\z//;
        lc $k => $v
        }
        split /\n/, $headers;

    ok( $headers{'content-type'} =~ m/application\/json/,
        'Content-Type is application/json' );
    ok( $json->{result}{success}, 'Json result is success' );
};

done_testing();

sub _get_entries_menu_labels {
    my $html = shift;

    my @labels;
    pQuery($html)->find('li#menu-entry > ul.sub-menu > li')->each(
        sub {
            push @labels, $_->find('span')->innerHTML;
        }
    );

    return @labels;
}
