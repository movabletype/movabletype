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

use MT::Test;
MT::Test->init_app;
MT::Test->init_db;

use MT::Test::Permission;

### Make test data

# Website
my $website = MT::Test::Permission->make_website();

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

my $admin = MT::Author->load(1);

# Role
my $edit_categories = MT::Test::Permission->make_role(
    name        => 'Edit Categories',
    permissions => "'edit_categories'",
);

require MT::Association;
MT::Association->link( $aikawa,   $edit_categories, $website );
MT::Association->link( $ichikawa, $edit_categories, $blog );

# Run

subtest '"bulk_update_folder" method check' => sub {

    my $cat_class = MT->model('folder');

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
        my $text = $website->folder_order || '';
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
    subtest 'add a folder' => sub {
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
                __mode           => 'bulk_update_folder',
                datasource       => 'folder',
                blog_id          => $website->id,
                objects          => $json,
                checksum         => $checksum,
            }
        );
        my $out = delete $app->{__test_output};
        ok( $out, "Request: bulk_update_folder" );
        is( $cat_class->count(), 1, "Added a folder" );

        my $cat = $cat_class->load( undef, { limit => 1 } );
        ok( $cat, "Loaded a folder" );
        is( $cat->label,    'Foo', 'Folder label is "Foo"' );
        is( $cat->basename, 'foo', 'Folder basename is "foo"' );
    };

    # Foo => (none)
    subtest 'delete a folder' => sub {
        my @params;
        my $json     = $to_json->( \@params );
        my $checksum = $make_checksum->();
        my $app      = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'bulk_update_folder',
                datasource       => 'folder',
                blog_id          => $website->id,
                objects          => $json,
                checksum         => $checksum,
            }
        );
        my $out = delete $app->{__test_output};
        ok( $out, "Request: bulk_update_folder" );
        is( $cat_class->count(), 0, "Removed a folder" );
    };

    # (non) => parent: Foo, child: Bar
    subtest 'add 2 folders' => sub {
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
                __mode           => 'bulk_update_folder',
                datasource       => 'folder',
                blog_id          => $website->id,
                objects          => $json,
                checksum         => $checksum,
            }
        );
        my $out = delete $app->{__test_output};
        ok( $out, "Request: bulk_update_folder" );
        is( $cat_class->count(), 2, "Created folders" );

        my $cat = $cat_class->load( { parent => 0 } );
        ok( $cat, 'Loaded a parent folder' );
        is( $cat->label,    'Foo', 'Folder label is "Foo"' );
        is( $cat->basename, 'foo', 'Folder basename is "foo"' );

        $cat = $cat_class->load( { parent => { not => 0 } } );
        ok( $cat, 'Loaded a child folder' );
        is( $cat->label,    'Bar', 'Folder label is "Bar"' );
        is( $cat->basename, 'bar', 'Folder basename is "bar"' );
    };

    # parent: Foo, child: Bar => parent: FooBar, child: Baz
    subtest 'rename 2 folders' => sub {
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
                __mode           => 'bulk_update_folder',
                datasource       => 'folder',
                blog_id          => $website->id,
                objects          => $json,
                checksum         => $checksum,
            }
        );
        my $out = delete $app->{__test_output};
        ok( $out, "Request: bulk_update_folder" );
        is( $cat_class->count(), 2, "Renamed folders" );

        $cat = $cat_class->load( { parent => 0 } );
        ok( $cat, 'Loaded a parent folder' );
        is( $cat->label,    'FooBar', 'Folder label is "FooBar"' );
        is( $cat->basename, 'foobar', 'Folder basename is "foobar"' );

        $cat = $cat_class->load( { parent => { not => 0 } } );
        ok( $cat, 'Loaded a child folder' );
        is( $cat->label,    'Baz', 'Folder label is "Baz"' );
        is( $cat->basename, 'baz', 'Folder basename is "baz"' );
    };

    # parent: FooBar, child: Baz => parent: Baz, child: FooBar
    subtest 'swap 2 folders' => sub {
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
                __mode           => 'bulk_update_folder',
                datasource       => 'folder',
                blog_id          => $website->id,
                objects          => $json,
                checksum         => $checksum,
            }
        );
        my $out = delete $app->{__test_output};
        ok( $out, "Request: bulk_update_folder" );
        is( $cat_class->count(), 2, "Swapped folders" );

        $cat = $cat_class->load( { parent => 0 } );
        ok( $cat, 'Loaded a parent folder' );
        is( $cat->label,    'Baz', 'Folder label is "Baz"' );
        is( $cat->basename, 'baz', 'Folder basename is "baz"' );

        $cat = $cat_class->load( { parent => { not => 0 } } );
        ok( $cat, 'Loaded a child folder' );
        is( $cat->label,    'FooBar', 'Folder label is "FooBar"' );
        is( $cat->basename, 'foobar', 'Folder basename is "foobar"' );
    };

    # parent: Baz, child: FooBar => Baz
    subtest 'remove child folder' => sub {
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
                __mode           => 'bulk_update_folder',
                datasource       => 'folder',
                blog_id          => $website->id,
                objects          => $json,
                checksum         => $checksum,
            }
        );
        my $out = delete $app->{__test_output};
        ok( $out, "Request: bulk_update_folder" );
        is( $cat_class->count(), 1, "Removed a child folder" );

        $cat = $cat_class->load();
        ok( $cat, 'Loaded a folder' );
        is( $cat->label,    'Baz', 'Folder label is "Baz"' );
        is( $cat->basename, 'baz', 'Folder basename is "baz"' );
    };

    # Baz => (none)
    $cat_class->remove_all;

    # (none) => Foo, Bar
    subtest 'add 2 folders' => sub {
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
                __mode           => 'bulk_update_folder',
                datasource       => 'folder',
                blog_id          => $website->id,
                objects          => $json,
                checksum         => $checksum,
            }
        );
        my $out = delete $app->{__test_output};
        ok( $out, "Request: bulk_update_folder" );
        is( $cat_class->count(), 2, "Added folders" );

        my $cat_foo = $cat_class->load( { label => 'Foo' } );
        my $cat_bar = $cat_class->load( { label => 'Bar' } );
        my $cat_order = join ',', ( $cat_foo->id, $cat_bar->id );
        $website = MT->model('website')->load( $website->id );
        ok( $website->folder_order, 'Website has folder_order' );
        is( $website->folder_order, $cat_order, 'Folder order is correct' );
    };

    # Foo, Bar => Bar, Foo
    subtest 'swap 2 folders' => sub {
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
                __mode           => 'bulk_update_folder',
                datasource       => 'folder',
                blog_id          => $website->id,
                objects          => $json,
                checksum         => $checksum,
            }
        );
        my $out = delete $app->{__test_output};
        ok( $out, "Request: bulk_update_folder" );
        is( $cat_class->count(), 2, "Swapped folders" );

        $cat_foo = $cat_class->load( { label => 'Foo' } );
        $cat_bar = $cat_class->load( { label => 'Bar' } );
        my $cat_order = join ',', ( $cat_bar->id, $cat_foo->id );

        $website = MT->model('website')->load( $website->id );
        ok( $website->folder_order, 'Website has folder_order' );
        is( $website->folder_order, $cat_order, 'Folder order is correct' );
    };
};

subtest 'Edit Folder screen check' => sub {
    plan 'skip_all';

    my $website_folder = MT::Test::Permission->make_folder(
        blog_id   => $website->id,
        author_id => $aikawa->id,
    );
    my $blog_folder = MT::Test::Permission->make_folder(
        blog_id   => $blog->id,
        author_id => $ichikawa->id,
    );
    ok( $website_folder, 'Created a website folder' );
    ok( $blog_folder,    'Created a blog folder' );

    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'edit',
            _type       => 'folder',
            blog_id     => $website->id,
            id          => $website_folder->id,
        },
    );
    my $out = delete $app->{__test_output};
    ok( $out, 'Request: edit(folder)' );

    my $link
        = quotemeta
        '<li id="user"><a href="/cgi-bin/mt.cgi?__mode=view&amp;_type=author&amp;id='
        . $admin->id . '">';
    ok( $out =~ m/$link/, 'Link to Edit Profile in website scope is ok' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'edit',
            _type       => 'folder',
            blog_id     => $blog->id,
            id          => $blog_folder->id,
        },
    );
    $out = delete $app->{__test_output};
    ok( $out, 'Request: edit(folder)' );

    $link
        = quotemeta
        '<li id="user"><a href="/cgi-bin/mt.cgi?__mode=view&amp;_type=author&amp;id='
        . $admin->id . '">';
    ok( $out =~ m/$link/, 'Link to Edit Profile in blog scope is ok' );
};

done_testing;
