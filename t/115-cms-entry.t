#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib', '../lib', '../extlib';
use MT::Test qw( :app :db );
use MT::Test::Permission;
use MT::Association;
use MT::Placement;
use MT::Util;
use Test::More;

### Make test data

# Website
my $website        = MT::Test::Permission->make_website();
my $second_website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );
my $second_blog
    = MT::Test::Permission->make_blog( parent_id => $second_website->id, );

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

MT::Association->link( $aikawa,   $create_post,    $website );
MT::Association->link( $ogawa,    $designer,       $website );
MT::Association->link( $kagawa,   $manage_pages,   $website );
MT::Association->link( $kikkawa,  $create_post,    $website );
MT::Association->link( $kumekawa, $edit_all_posts, $website );
MT::Association->link( $ukawa,    $create_post,    $blog );

MT::Association->link( $ichikawa, $create_post, $second_website );
MT::Association->link( $egawa,    $create_post, $second_blog );

# Category
my $website_cat = MT::Test::Permission->make_category(
    blog_id   => $website->id,
    author_id => $admin->id,
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

# Page
my $website_page = MT::Test::Permission->make_page(
    blog_id   => $website->id,
    author_id => $kagawa->id,
    title     => 'Website Page by Kagawa',
);

# Run tests
my ( $app, $out );

diag 'Test in website scope';
subtest 'Test in website scope' => sub {

    diag 'Menu visibility check';
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
        my $link_new
            = $app->uri
            . '?__mode=view&amp;_type=entry&amp;blog_id='
            . $website->id;
        $link_new = quotemeta $link_new;
        like( $out, qr/$link_new/,
            '"Entries New" menu in website scope exists if admin' );
        my $link_manage
            = $app->uri
            . '?__mode=list&amp;_type=entry&amp;blog_id='
            . $website->id;
        $link_manage = quotemeta $link_manage;
        like( $out, qr/$link_manage/,
            '"Entries Manage" menu in website scope exists if admin' );
        my $fav_action_entry = 'fav-action-entry';
        like( $out, qr/$fav_action_entry/,
            '"Entry" in compose menus exists if admin' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $aikawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );
        like( $out, qr/$link_new/,
            '"Entries New" menu in website scope exists if permitted user' );
        like( $out, qr/$link_manage/,
            '"Entries Manage" menu in website scope exists if permitted user'
        );
        like( $out, qr/$fav_action_entry/,
            '"Entry" in compose menus exists if permitted user' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $ichikawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );
        unlike( $out, qr/$link_new/,
            '"Entries New" menu in website scope does not exist if other website'
        );
        unlike( $out, qr/$link_manage/,
            '"Entries Manage" menu in website scope does not exist if other'
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
        unlike( $out, qr/$link_new/,
            '"Entries New" menu in website scope does not exist if child blog'
        );
        like( $out, qr/$link_manage/,
            '"Entries Manage" menu in website scope exists if child blog' );
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
        unlike( $out, qr/$link_new/,
            '"Entries New" menu in website scope does not exist if other blog'
        );
        unlike( $out, qr/$link_manage/,
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
        unlike( $out, qr/$link_new/,
            '"Entries New" menu in website scope does not exist if other permission'
        );
        unlike( $out, qr/$link_manage/,
            '"Entries Manage" menu in website scope does not exist if other permission'
        );
        unlike( $out, qr/$fav_action_entry/,
            '"Entry" in compose menus exists if other permission' );

        done_testing();
    };

    diag 'Entry listing screen visibility check';
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
        like( $out, $column, '"Website/Blog Name" column exists' );

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

    diag 'Filtered list check';
    subtest 'Filtered list check' => sub {
        diag 'Get filtered list by admin';
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

        diag 'Get filtered list by permitted user (create post) in website';
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

        diag
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

        diag
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

        diag 'Get filtered list by permitted user in child blog';
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

        diag 'Get filtered list by other website';
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

        diag 'Get filtered list by other blog';
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

        diag 'Get filtered list by other permission';
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

    diag 'Built in filter check';
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

    diag 'Batch edit entries check';
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

done_testing();
