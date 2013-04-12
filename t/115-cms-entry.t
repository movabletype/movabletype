#!/usr/bin/perl

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib', '../lib', '../extlib';
use MT::Test qw( :app :db );
use MT::Test::Permission;
use MT::Association;
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
    name => 'kagawa',
    nickname => 'Ichiro Kagawa',
);

my $admin = MT->model('author')->load(1);

# Role
my $create_post = MT::Test::Permission->make_role(
    name        => 'Create Post',
    permissions => "'create_post'",
);
my $manage_pages = MT::Test::Permission->make_role(
    name => 'Manage Pages',
    permissions => "'manage_pages'",
);

my $designer = MT::Role->load( { name => MT->translate('Designer') } );

MT::Association->link( $aikawa, $create_post, $website );
MT::Association->link( $ogawa, $designer, $website );
MT::Association->link( $kagawa, $manage_pages, $website );
MT::Association->link( $ukawa,  $create_post, $blog );

MT::Association->link( $ichikawa, $create_post, $second_website );
MT::Association->link( $egawa,    $create_post, $second_blog );

# Entry
my $website_entry = MT::Test::Permission->make_entry(
    blog_id => $website->id,
    author_id => $aikawa->id,
    title => 'Website Entry by Aikawa',
);
my $blog_entry = MT::Test::Permission->make_entry(
    blog_id => $blog->id,
    author_id => $ukawa->id,
    title => 'Child Blog Entry by Ukawa',
);

my $second_website_entry = MT::Test::Permission->make_entry(
    blog_id => $second_website->id,
    author_id => $ichikawa->id,
    title => 'Other Website Entry by ichikawa',
);

# Page
my $website_page = MT::Test::Permission->make_page(
    blog_id => $website->id,
    author_id => $kagawa->id,
    title => 'Website Page by Kagawa',
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
        my $link
            = $app->uri
            . '?__mode=view&amp;_type=entry&amp;blog_id='
            . $website->id;
        $link = quotemeta $link;
        like( $out, qr/$link/,
            '"Entries New" menu in website scope exists if admin' );
        my $fav_action_entry = 'fav-action-entry';
        like( $out, qr/$fav_action_entry/, '"Entry" in compose menus exists if admin'  );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $aikawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );
        like( $out, qr/$link/,
            '"Entries New" menu in website scope exists if permitted user' );
        like( $out, qr/$fav_action_entry/, '"Entry" in compose menus exists if permitted user' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $ichikawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );
        unlike( $out, qr/$link/,
            '"Entries New" menu in website scope does not exist if other website'
        );
        unlike( $out, qr/$fav_action_entry/, '"Entry" in compose menus exists if other website' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $ukawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );
        unlike( $out, qr/$link/,
            '"Entries New" menu in website scope does not exist if child blog'
        );
        unlike( $out, qr/$fav_action_entry/, '"Entry" in compose menus exists if child blog' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $ekawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );
        unlike( $out, qr/$link/,
            '"Entries New" menu in website scope does not exist if other blog'
        );
        unlike( $out, qr/$fav_action_entry/, '"Entry" in compose menus exists if other blog' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $ogawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );
        unlike( $out, qr/$link/,
            '"Entries New" menu in website scope does not exist if other permission'
        );
        unlike( $out, qr/$fav_action_entry/, '"Entry" in compose menus exists if other permission' );

        done_testing();
    };

    diag 'Entry Feed check';
    subtest 'Entry Feed check' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $admin,
                __mode => 'list',
                _type => 'entry',
                blog_id => $website->id,
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: list" );

        like( $out, qr/Entry Feed/, 'Entry Feed in website scope exists' );

        done_testing();
    };

    diag 'System filter check';
    subtest 'Built in filter check' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $admin,
                __mode => 'list',
                _type => 'entry',
                blog_id => $website->id,
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: list" );

        like( $out, qr/Entries in This Website/, 'System filter "Entries in This Website" exists' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $admin,
                __request_method => 'POST',
                __mode => 'filtered_list',
                datasource => 'entry',
                blog_id => $website->id,
                columns => 'title',
                fid => '_allpass',
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: filtered_list" );

        like( $out, qr/Website Entry by Aikawa/, 'Got an entry in website' );
        like( $out, qr/Child Blog Entry by Ukawa/, 'Got an entry in child blog' );
        unlike( $out, qr/Other Website Entry by ichikawa/, 'Did not get an entry in other website' );
        unlike( $out, qr/Website Page by Kagawa/, 'Did not get an page' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $admin,
                __request_method => 'POST',
                __mode => 'filtered_list',
                datasource => 'entry',
                blog_id => $website->id,
                columns => 'title',
                fid => 'current_website',
                items => "[{\"type\":\"current_context\",\"args\":{\"value\":\"\",\"label\":\"\"}}]",
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: filtered_list" );

        like( $out, qr/Website Entry by Aikawa/, 'Got an entry in website' );
        unlike( $out, qr/Child Blog Entry by Ukawa/, 'Did not get an entry in child blog' );
        unlike( $out, qr/Other Website Entry by ichikawa/, 'Did not get an entry in other website' );
        unlike( $out, qr/Website Page by Kagawa/, 'Did not get an page' );

        done_testing();
    };

    diag 'Batch edit entries check';
    subtest 'Batch edit entries check' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $admin,
                __request_method => 'POST',
                __mode => 'itemset_action',
                _type => 'entry',
                blog_id => $website->id,
                action_name => 'open_batch_editor',
                plugin_action_selector => 'open_batch_editor',
                id => [ $website_entry->id, $blog_entry->id ],
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: open_batch_editor" );

        like( $out, qr/Website Entry by Aikawa/, "Has an entry in website" );
        like( $out, qr/Child Blog Entry by Ukawa/, "Has an entry in child blog" );

        done_testing();
    };

    done_testing();
};

done_testing();
