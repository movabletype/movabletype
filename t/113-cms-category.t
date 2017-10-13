#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}


BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib', '../lib', '../extlib';

use JSON;

use MT::Test;
MT::Test->init_app;
MT::Test->init_db;
use MT::Test::Permission;
use Test::More;

### Make test data

# Website
my $website = MT::Test::Permission->make_website();

my $second_website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );

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

my $admin = MT::Author->load(1);

# Role
my $edit_categories = MT::Test::Permission->make_role(
    name        => 'Edit Categories',
    permissions => "'edit_categories'",
);

my $designer = MT::Role->load( { name => MT->translate('Designer') } );

require MT::Association;
MT::Association->link( $aikawa, $edit_categories, $website );
MT::Association->link( $egawa,  $designer,        $website );

MT::Association->link( $ukawa, $edit_categories, $blog );

MT::Association->link( $ichikawa, $edit_categories, $second_website );

# Run
my $cat_class = MT->model('category');

subtest 'Test on website' => sub {
    subtest 'Menu visibility check' => sub {
        plan tests => 8;

        my $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $admin,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        my $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );
        like( $out, qr/Categories/, '"Categories" menu exists if admin' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $aikawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );
        like( $out, qr/Categories/,
            '"Categories" menu exists if permitted user' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $ukawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );
        unlike( $out, qr/Categories/,
            '"Categories" menu does not exist if child blog' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $egawa,
                __mode      => 'dashboard',
                blog_id     => $website->id
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: website dashboard" );
        unlike( $out, qr/Categories/,
            '"Categories" menu does not exist if other permission' );

        done_testing();
    };

    subtest '"filtered_list" method check' => sub {

        # Make test data
        my $cat = MT::Test::Permission->make_category(
            label     => 'Foo',
            blog_id   => $website->id,
            author_id => $admin->id,
        );

        my $blog_cat = MT::Test::Permission->make_category(
            label     => 'Bar',
            blog_id   => $blog->id,
            author_id => $admin->id,
        );

        my $second_cat = MT::Test::Permission->make_category(
            label     => 'Baz',
            blog_id   => $second_website->id,
            author_id => $admin->id,
        );

        # Do test
        local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
        my $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'category',
                blog_id          => $website->id,
                _type            => 'category',
            }
        );
        my $out = delete $app->{__test_output};
        ok( $out, "Request: filtered_list" );
        like( $out, qr/Foo/, 'Request has "Foo" category' );
        unlike( $out, qr/Bar/, 'Request has not "Bar" category' );
        unlike( $out, qr/Baz/, 'Request has not "Baz" category' );

        done_testing();
    };

    subtest '"save" method check' => sub {

        # Remove previous test data
        $cat_class->remove_all();

        MT::Test::Permission->make_category(
            blog_id => $website->id,
            label   => 'Foo',
        );
        is( $cat_class->count(), 1, "A new category has created" );

        my $cat = $cat_class->load( undef, { limit => 1 } );
        ok( $cat, "Loaded a category" );

        my $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'save',
                blog_id          => $website->id,
                _type            => 'category',
                id               => $cat->id,
                label            => 'Bar',                 # Label
                basename         => 'bar',                 # Basename
                description      => 'Description sample.', # Description
                allow_pings      => 1,                     # Accept Trackbacks
                tb_passphrase => 'Baz',    # Passphrase Protection
                ping_urls => 'http://localhost/dummy',    # Trackback URLs
            }
        );
        my $out = delete $app->{__test_output};
        ok( $out, "Request: save" );
        is( $cat_class->count(), 1, "Number of category has not changed." );

        $cat = $cat_class->load( undef, { limit => 1 } );
        ok( $cat, "Loaded a category" );

        # Check category parameters
        is( $cat->label,    'Bar', 'Category Label is "Bar"' );
        is( $cat->basename, 'bar', 'Category Basename is "bar"' );
        is( $cat->description,
            'Description sample.',
            'Category Description is "Discription sample."'
        );
        is( $cat->allow_pings, 1, 'Category Accept Trackbacks is "1"' );
        is( $cat->ping_urls, "http://localhost/dummy",
            'Category Trackback URLs is "http://localhost/dummy"' );

        # Check Trackback Passphrase
        my $tb_class = MT->model('trackback');
        is( $tb_class->count(), 1, 'Trackback has created' );
        my $tb = MT->model('trackback')->load( { category_id => $cat->id } );
        ok( $tb, 'Loaded trackback' );
        is( $tb->passphrase, 'Baz',
            'Category Trackback Passphrase is "Baz"' );

        done_testing();
    };

    subtest '"bulk_update_category" method check' => sub {

        # Remove previous test data
        $cat_class->remove_all();

        require MT::Util;
        my $to_json = sub {
            my $ret = MT::Util::to_json(shift, {canonical => 1});
            return $ret;
        };

        require Digest::MD5;
        my $make_checksum = sub {
            my @old_objects = $cat_class->load( { blog_id => $website->id } );

            # Test CheckSum
            $website = MT->model('website')->load( $website->id );
            my $text = $website->category_order || '';
            if (@old_objects) {
                $text = join(
                    ':', $text,
                    map {
                        join( ':',
                            $_->id,
                            ( $_->parent || '0' ),
                            Encode::encode_utf8( $_->label ),
                            )
                        }
                        sort { $a->id <=> $b->id } @old_objects
                );
            }

            return Digest::MD5::md5_hex($text);
        };

        local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';

        # (none) => Foo
        subtest 'add a category' => sub {
            my @params = (
                {   id       => 'x1',
                    parent   => '0',
                    label    => 'Foo',
                    basename => 'foo',
                }
            );
            my $json     = $to_json->( \@params );
            my $checksum = $make_checksum->();

            my $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $admin,
                    __request_method => 'POST',
                    __mode           => 'bulk_update_category',
                    datasource       => 'category',
                    blog_id          => $website->id,
                    objects          => $json,
                    checksum         => $checksum,
                }
            );
            my $out = delete $app->{__test_output};
            ok( $out, "Request: bulk_update_category" );
            is( $cat_class->count(), 1, "Added a category" );

            my $cat = $cat_class->load( undef, { limit => 1 } );
            ok( $cat, "Loaded a category" );
            is( $cat->label,    'Foo', 'Category label is "Foo"' );
            is( $cat->basename, 'foo', 'Category basename is "foo"' );
        };

        # Foo => (none)
        subtest 'delete a category' => sub {
            my @params   = ();
            my $json     = $to_json->( \@params );
            my $checksum = $make_checksum->();
            my $app      = _run_app(
                'MT::App::CMS',
                {   __test_user      => $admin,
                    __request_method => 'POST',
                    __mode           => 'bulk_update_category',
                    datasource       => 'category',
                    blog_id          => $website->id,
                    objects          => $json,
                    checksum         => $checksum,
                }
            );
            my $out = delete $app->{__test_output};
            ok( $out, "Request: bulk_update_category" );
            is( $cat_class->count(), 0, "Removed a category" );
        };

        # (none) => parent: Foo, child: Bar
        subtest 'add 2 categories' => sub {
            my @params = (
                {   id       => 'x1',
                    parent   => '0',
                    label    => 'Foo',
                    basename => 'foo',
                },
                {   id       => 'x2',
                    parent   => 'x1',
                    label    => 'Bar',
                    basename => 'bar',
                }
            );
            my $json     = $to_json->( \@params );
            my $checksum = $make_checksum->();
            my $app      = _run_app(
                'MT::App::CMS',
                {   __test_user      => $admin,
                    __request_method => 'POST',
                    __mode           => 'bulk_update_category',
                    datasource       => 'category',
                    blog_id          => $website->id,
                    objects          => $json,
                    checksum         => $checksum,
                }
            );
            my $out = delete $app->{__test_output};
            ok( $out, "Request: bulk_update_category" );
            is( $cat_class->count(), 2, "Created categories" );

            my $cat = $cat_class->load( { parent => 0 } );
            ok( $cat, 'Loaded a parent category' );
            is( $cat->label,    'Foo', 'Category label is "Foo"' );
            is( $cat->basename, 'foo', 'Category basename is "foo"' );

            $cat = $cat_class->load( { parent => { not => 0 } } );
            ok( $cat, 'Loaded a child category' );
            is( $cat->label,    'Bar', 'Category label is "Bar"' );
            is( $cat->basename, 'bar', 'Category basename is "bar"' );
        };

        # parent: Foo, child: Bar => parent: FooBar, child: Baz
        subtest 'rename 2 categories' => sub {
            my $cat = $cat_class->load( { parent => 0 } );
            my @params = (
                {   id       => $cat->id,
                    parent   => 0,
                    label    => 'FooBar',
                    basename => 'foobar',
                }
            );
            $cat = $cat_class->load( { parent => { not => 0 } } );
            push @params,
                {
                id       => $cat->id,
                parent   => $cat->parent,
                label    => 'Baz',
                basename => 'baz',
                };
            my $json     = $to_json->( \@params );
            my $checksum = $make_checksum->();
            my $app      = _run_app(
                'MT::App::CMS',
                {   __test_user      => $admin,
                    __request_method => 'POST',
                    __mode           => 'bulk_update_category',
                    datasource       => 'category',
                    blog_id          => $website->id,
                    objects          => $json,
                    checksum         => $checksum,
                }
            );
            my $out = delete $app->{__test_output};
            ok( $out, "Request: bulk_update_category" );
            is( $cat_class->count(), 2, "Renamed categories" );

            $cat = $cat_class->load( { parent => 0 } );
            ok( $cat, 'Loaded a parent category' );
            is( $cat->label,    'FooBar', 'Category label is "FooBar"' );
            is( $cat->basename, 'foobar', 'Category basename is "foobar"' );

            $cat = $cat_class->load( { parent => { not => 0 } } );
            ok( $cat, 'Loaded a child category' );
            is( $cat->label,    'Baz', 'Category label is "Baz"' );
            is( $cat->basename, 'baz', 'Category basename is "baz"' );
        };

        # parent: FooBar, child: Baz => parent: Baz, child: FooBar
        subtest 'swap 2 categories' => sub {
            my $cat = $cat_class->load( { parent => 0 } );
            my @params = (
                {   id       => $cat->id,
                    parent   => 'dummy',
                    label    => $cat->label,
                    basename => $cat->basename,
                },
                { parent => 0, }
            );
            $cat = $cat_class->load( { parent => { not => 0 } } );
            $params[0]{parent}   = $cat->id;
            $params[1]{id}       = $cat->id;
            $params[1]{label}    = $cat->label;
            $params[1]{basename} = $cat->basename;
            my $json     = $to_json->( \@params );
            my $checksum = $make_checksum->();
            my $app      = _run_app(
                'MT::App::CMS',
                {   __test_user      => $admin,
                    __request_method => 'POST',
                    __mode           => 'bulk_update_category',
                    datasource       => 'category',
                    blog_id          => $website->id,
                    objects          => $json,
                    checksum         => $checksum,
                }
            );
            my $out = delete $app->{__test_output};
            ok( $out, "Request: bulk_update_category" );
            is( $cat_class->count(), 2, "Swapped categories" );

            $cat = $cat_class->load( { parent => 0 } );
            ok( $cat, 'Loaded a parent category' );
            is( $cat->label,    'Baz', 'Category label is "Baz"' );
            is( $cat->basename, 'baz', 'category basename is "baz"' );

            $cat = $cat_class->load( { parent => { not => 0 } } );
            ok( $cat, 'Loaded a child category' );
            is( $cat->label,    'FooBar', 'Category label is "FooBar"' );
            is( $cat->basename, 'foobar', 'Category basename is "foobar"' );
        };

        # parent: Baz, child: FooBar => Baz
        subtest 'remove child category' => sub {
            my $cat = $cat_class->load( { parent => 0 } );
            my @params = (
                {   parent   => 0,
                    id       => $cat->id,
                    label    => $cat->label,
                    basename => $cat->basename,
                }
            );
            my $json     = $to_json->( \@params );
            my $checksum = $make_checksum->();
            my $app      = _run_app(
                'MT::App::CMS',
                {   __test_user      => $admin,
                    __request_method => 'POST',
                    __mode           => 'bulk_update_category',
                    datasource       => 'category',
                    blog_id          => $website->id,
                    objects          => $json,
                    checksum         => $checksum,
                }
            );
            my $out = delete $app->{__test_output};
            ok( $out, "Request: bulk_update_category" );
            is( $cat_class->count(), 1, "Removed a child category" );

            $cat = $cat_class->load();
            ok( $cat, 'Loaded a class' );
            is( $cat->label,    'Baz', 'Category label is "Baz"' );
            is( $cat->basename, 'baz', 'Category basename is "baz"' );
        };

        # Baz => (none)
        $cat_class->remove_all();

        # (none) => Foo, Bar
        subtest 'add 2 categories' => sub {
            my @params = (
                {   id       => 'x1',
                    parent   => 0,
                    label    => 'Foo',
                    basename => 'foo',
                },
                {   id       => 'x2',
                    parent   => 0,
                    label    => 'Bar',
                    basename => 'bar',
                }
            );
            my $json     = $to_json->( \@params );
            my $checksum = $make_checksum->();
            my $app      = _run_app(
                'MT::App::CMS',
                {   __test_user      => $admin,
                    __request_method => 'POST',
                    __mode           => 'bulk_update_category',
                    datasource       => 'category',
                    blog_id          => $website->id,
                    objects          => $json,
                    checksum         => $checksum,
                }
            );
            my $out = delete $app->{__test_output};
            ok( $out, "Request: bulk_update_category" );
            is( $cat_class->count(), 2, "Added categories" );

            my $cat_foo = $cat_class->load( { label => 'Foo' } );
            my $cat_bar = $cat_class->load( { label => 'Bar' } );
            my $cat_order = join ',', ( $cat_foo->id, $cat_bar->id );
            $website = MT->model('website')->load( $website->id );
            ok( $website->category_order, 'Website has category_order' );
            is( $website->category_order, $cat_order,
                'Category order is correct' );
        };

        # For, Bar => Bar, Foo
        subtest 'swap 2 categories' => sub {
            my $cat_foo = $cat_class->load( { label => 'Foo' } );
            my $cat_bar = $cat_class->load( { label => 'Bar' } );
            my @params  = (
                {   id       => $cat_bar->id,
                    parent   => 0,
                    label    => $cat_bar->label,
                    basename => $cat_bar->basename,
                },
                {   id       => $cat_foo->id,
                    parent   => 0,
                    label    => $cat_foo->label,
                    basename => $cat_foo->basename,
                }
            );
            my $json     = $to_json->( \@params );
            my $checksum = $make_checksum->();
            my $app      = _run_app(
                'MT::App::CMS',
                {   __test_user      => $admin,
                    __request_method => 'POST',
                    __mode           => 'bulk_update_category',
                    datasource       => 'category',
                    blog_id          => $website->id,
                    objects          => $json,
                    checksum         => $checksum,
                }
            );
            my $out = delete $app->{__test_output};
            ok( $out, "Request: bulk_update_category" );
            is( $cat_class->count(), 2, "Swapped categories" );

            $cat_foo = $cat_class->load( { label => 'Foo' } );
            $cat_bar = $cat_class->load( { label => 'Bar' } );
            my $cat_order = join ',', ( $cat_bar->id, $cat_foo->id );

            $website = MT->model('website')->load( $website->id );
            ok( $website->category_order, 'Website has category_order' );
            is( $website->category_order, $cat_order,
                'Category order is correct' );
        };

        done_testing();
    };

    done_testing();
};

subtest 'Edit Category screen check' => sub {
    plan 'skip_all';

    my $website_category = MT::Test::Permission->make_category(
        blog_id   => $website->id,
        author_id => $aikawa->id,
    );
    my $blog_category = MT::Test::Permission->make_category(
        blog_id   => $blog->id,
        author_id => $ukawa->id,
    );
    ok( $website_category, 'Created a website category' );
    ok( $blog_category,    'Created a blog category' );

    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'edit',
            _type       => 'category',
            blog_id     => $website->id,
            id          => $website_category->id,
        },
    );
    my $out = delete $app->{__test_output};
    ok( $out, 'Request: edit(category)' );

    my $link
        = quotemeta
        '<li id="user"><a href="/cgi-bin/mt.cgi?__mode=view&amp;_type=author&amp;id='
        . $admin->id . '">';
    ok( $out =~ m/$link/, 'Link to Edit Profile in website scope is ok' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'edit',
            _type       => 'category',
            blog_id     => $blog->id,
            id          => $blog_category->id,
        },
    );
    $out = delete $app->{__test_output};
    ok( $out, 'Request: edit(category)' );

    $link
        = quotemeta
        '<li id="user"><a href="/cgi-bin/mt.cgi?__mode=view&amp;_type=author&amp;id='
        . $admin->id . '">';
    ok( $out =~ m/$link/, 'Link to Edit Profile in blog scope is ok' );
};
done_testing();

