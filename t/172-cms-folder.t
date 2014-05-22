#!/usr/bin/perl
use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib', '../lib', '../extlib';

use MT::Test qw( :app :db );
use MT::Test::Permission;
use Test::More;

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
my ( $app, $out );

subtest 'Edit Folder screen check' => sub {
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

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'edit',
            _type       => 'folder',
            blog_id     => $website->id,
            id          => $website_folder->id,
        },
    );
    $out = delete $app->{__test_output};
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
