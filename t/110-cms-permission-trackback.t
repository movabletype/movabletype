#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib';
use MT::Test qw( :app :db );
use MT::Test::Permission;
use Test::More;

### Make test data

# Website
my $website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );
my $second_blog
    = MT::Test::Permission->make_blog( parent_id => $website->id, );

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
    name     => 'Kikkawa',
    nickname => 'Jiro Kikkawa',
);

my $kumekawa = MT::Test::Permission->make_author(
    name     => 'kumekawa',
    nickname => 'Saburo Kumekawa',
);

my $kemigawa = MT::Test::Permission->make_author(
    name     => 'kemigawa',
    nickname => 'Shiro Kemigawa',
);

my $admin = MT::Author->load(1);

# Role
my $manage_feedback = MT::Test::Permission->make_role(
    name        => 'Manage Feedback',
    permissions => "'manage_feedback'",
);
my $manage_pages = MT::Test::Permission->make_role(
    name        => 'Manage mapes',
    permissions => "'manage_pages'",
);
my $create_post = MT::Test::Permission->make_role(
    name        => 'Create Post',
    permissions => "'create_post'",
);
my $publish_post = MT::Test::Permission->make_role(
    name        => 'Publish Post',
    permissions => "'publish_post','create_post'",
);
my $designer = MT::Role->load( { name => MT->translate('Designer') } );

require MT::Association;
MT::Association->link( $aikawa   => $manage_feedback => $blog );
MT::Association->link( $ichikawa => $manage_feedback => $second_blog );
MT::Association->link( $ukawa    => $designer        => $blog );
MT::Association->link( $egawa    => $manage_pages    => $blog );
MT::Association->link( $ogawa    => $create_post     => $blog );
MT::Association->link( $kagawa   => $manage_pages    => $second_blog );
MT::Association->link( $kikkawa  => $create_post     => $second_blog );
MT::Association->link( $kumekawa => $publish_post    => $blog );
MT::Association->link( $kemigawa => $publish_post    => $second_blog );

# Entry
my $entry = MT::Test::Permission->make_entry(
    blog_id   => $blog->id,
    author_id => $ichikawa->id,
);

# Page
my $page = MT::Test::Permission->make_page(
    blog_id   => $blog->id,
    author_id => $egawa->id,
);

# Trackback
my $tb_entry = MT::Test::Permission->make_tb(
    blog_id  => $blog->id,
    entry_id => $entry->id,
);
my $tb_page = MT::Test::Permission->make_tb(
    blog_id  => $blog->id,
    entry_id => $page->id,
);

# Ping
my $ping_entry = MT::Test::Permission->make_ping(
    blog_id => $blog->id,
    tb_id   => $tb_entry->id,
);

my $ping_page = MT::Test::Permission->make_ping(
    blog_id => $blog->id,
    tb_id   => $tb_page->id,
);

# Run
my ( $app, $out );

subtest 'mode = list' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out !~ m!permission=1!i, "list by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out !~ m!permission=1!i,
        "list by permitted user (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out !~ m!permission=1!i, "list by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out =~ m!permission=1!i, "list by other blog (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out =~ m!permission=1!i, "list by other blog (create post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out =~ m!permission=1!i, "list by other permission" );

    done_testing();
};

subtest 'mode = edit' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out !~ m!permission=1!i, "edit by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out !~ m!permission=1!i,
        "edit by permitted user (manage feedback)" );

    my $entry3 = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ogawa->id,
    );
    my $tb_entry3 = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry3->id,
    );
    my $ping_entry3 = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry3->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry3->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out !~ m!permission=1!i, "edit by permitted user (create post)" );

    my $entry2 = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $kumekawa->id,
    );
    my $tb_entry2 = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry2->id,
    );
    my $ping_entry2 = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry2->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry2->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out !~ m!permission=1!i, "edit by permitted user (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other blog (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemigawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other blog (publish post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_page->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!permission=1!i,
        "edit by non permitted user (create_post)" );

    done_testing();
};

subtest 'mode = edit (type is tbping)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid request!i,
        "edit by permitted user (manage feedback)" );

    my $entry3 = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ogawa->id,
    );
    my $tb_entry3 = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry3->id,
    );
    my $ping_entry3 = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry3->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry3->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit by permitted user (create post)" );

    my $entry2 = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $kumekawa->id,
    );
    my $tb_entry2 = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry2->id,
    );
    my $ping_entry2 = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry2->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry2->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit by permitted user (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other blog (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemigawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other blog (publish post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_page->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid request!i,
        "edit by non permitted user (create_post)" );

    done_testing();
};

subtest 'mode = edit (type is ping_cat)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid request!i,
        "edit by permitted user (manage feedback)" );

    my $entry3 = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ogawa->id,
    );
    my $tb_entry3 = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry3->id,
    );
    my $ping_entry3 = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry3->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry3->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit by permitted user (create post)" );

    my $entry2 = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $kumekawa->id,
    );
    my $tb_entry2 = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry2->id,
    );
    my $ping_entry2 = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry2->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry2->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit by permitted user (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other blog (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemigawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other blog (publish post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $ping_page->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid request!i,
        "edit by non permitted user (create_post)" );

    done_testing();
};

subtest 'mode = save' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!permission=1!i,
        "save by permitted user (manage feedback)" );

    my $entry2 = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $kumekawa->id,
    );
    my $tb_entry2 = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry2->id,
    );
    my $ping_entry2 = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry2->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_entry2->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other blog (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_page->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other blog (manage pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other blog (create post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_page->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!permission=1!i,
        "save by non permitted user (create_post)" );

    done_testing();
};

subtest 'mode = save (type is tbping)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid request!i,
        "save by permitted user (manage feedback)" );

    my $entry2 = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $kumekawa->id,
    );
    my $tb_entry2 = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry2->id,
    );
    my $ping_entry2 = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry2->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_entry2->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!Invalid request!i, "save by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other blog (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_page->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other blog (manage pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other blog (create post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!INvalid request!i, "save by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_page->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid request!i,
        "save by non permitted user (create_post)" );

    done_testing();
};

subtest 'mode = save (type is ping_cat)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid request!i,
        "save by permitted user (manage feedback)" );

    my $entry2 = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $kumekawa->id,
    );
    my $tb_entry2 = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry2->id,
    );
    my $ping_entry2 = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry2->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_entry2->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!Invalid request!i, "save by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other blog (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_page->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other blog (manage pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other blog (create post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!INvalid request!i, "save by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $ping_page->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid request!i,
        "save by non permitted user (create_post)" );

    done_testing();
};

subtest 'mode = delete' => sub {
    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out !~ m!permission=1!i, "delete by admin" );

    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out !~ m!permission=1!i,
        "delete by permitted user (manage feedback)" );

    my $entry2 = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $kumekawa->id,
    );
    my $tb_entry2 = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry2->id,
    );
    my $ping_entry2 = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry2->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_entry2->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out !~ m!permission=1!i, "delete by permitted user (publish)" );

    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other blog (manage feedback)" );

    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_page->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other blog (manage pages)" );

    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemigawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other blog (publish post)" );

    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other permission" );

    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_page->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!permission=1!i,
        "delete by non permitted user (create_post)" );

    done_testing();
};

subtest 'mode = delete (type is tbping)' => sub {
    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!Invalid request!i, "delete by admin" );

    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!Invalid request!i,
        "delete by permitted user (manage feedback)" );

    my $entry2 = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $kumekawa->id,
    );
    my $tb_entry2 = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry2->id,
    );
    my $ping_entry2 = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry2->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_entry2->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!Invalid request!i, "delete by permitted user (publish)" );

    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other blog (manage feedback)" );

    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_page->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other blog (manage pages)" );

    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemigawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other blog (publish post)" );

    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'tbping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!Invalid request!i, "delete by other permission" );

    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_page->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    print $out;
    ok( $out, "Request: delete" );
    ok( $out =~ m!permission=1!i,
        "delete by non permitted user (create_post)" );

    done_testing();
};

subtest 'mode = delete (type is ping_cat)' => sub {
    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!Invalid request!i, "delete by admin" );

    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!Invalid request!i,
        "delete by permitted user (manage feedback)" );

    my $entry2 = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $kumekawa->id,
    );
    my $tb_entry2 = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry2->id,
    );
    my $ping_entry2 = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry2->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_entry2->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!Invalid request!i, "delete by permitted user (publish)" );

    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other blog (manage feedback)" );

    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_page->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other blog (manage pages)" );

    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemigawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other blog (publish post)" );

    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_entry->id,
            _type            => 'ping_cat',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!Invalid request!i, "delete by other permission" );

    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $ping_page->id,
            _type            => 'ping',
        }
    );
    $out = delete $app->{__test_output};
    print $out;
    ok( $out, "Request: delete" );
    ok( $out =~ m!permission=1!i,
        "delete by non permitted user (create_post)" );

    done_testing();
};

subtest 'mode = list (trackback)' => sub {
    my $trackback = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'trackback',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: list" );
    ok( $out =~ m!Unknown Action!i, "list by admin" );

    $trackback = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'trackback',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: list" );
    ok( $out =~ m!Unknown Action!i, "list by non permitted user" );

    done_testing();
};

subtest 'mode = save (trackback)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'trackback',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'trackback',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save by non permitted user" );

    done_testing();
};

subtest 'mode = edit (trackback)' => sub {
    my $trackback = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'trackback',
            id               => $trackback->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit by admin" );

    $trackback = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'trackback',
            id               => $trackback->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit by non permitted user" );

    done_testing();
};

subtest 'mode = delete (trackback)' => sub {
    my $trackback = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'trackback',
            id               => $trackback->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: delete" );
    ok( $out =~ m!Invalid Request!i, "delete by admin" );

    $trackback = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'trackback',
            id               => $trackback->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: delete" );
    ok( $out =~ m!Invalid Request!i, "delete by non permitted user" );

    done_testing();
};

subtest 'action = unapprove_ping' => sub {
    $ping_entry = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry->id,
    );
    $ping_page = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_page->id,
    );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            blog_id              => $blog->id,
            _type                => 'ping',
            action_name          => 'unapprove_ping',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_ping%26blog_id%3D' . $blog->id,
            blog_id     => $blog->id,
            plugin_action_selector => 'unapprove_ping',
            id                     => $ping_entry->id,
            plugin_action_selector => 'unapprove_ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: unapprove_ping" );
    ok( $out !~ m!not implemented!i, "unapprove_ping by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $aikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            blog_id              => $blog->id,
            _type                => 'ping',
            action_name          => 'unapprove_ping',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_ping%26blog_id%3D' . $blog->id,
            blog_id     => $blog->id,
            plugin_action_selector => 'unapprove_ping',
            id                     => $ping_entry->id,
            plugin_action_selector => 'unapprove_ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unapprove_ping" );
    ok( $out !~ m!not implemented!i,
        "unapprove_ping by permitted user (manage feedback)" );

    my $entry2 = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $kumekawa->id,
    );
    my $tb_entry2 = MT::Test::Permission->make_tb(
        blog_id  => $blog->id,
        entry_id => $entry2->id,
    );
    my $ping_entry2 = MT::Test::Permission->make_ping(
        blog_id => $blog->id,
        tb_id   => $tb_entry2->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kumekawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            blog_id              => $blog->id,
            _type                => 'ping',
            action_name          => 'unapprove_ping',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_ping%26blog_id%3D' . $blog->id,
            blog_id     => $blog->id,
            plugin_action_selector => 'unapprove_ping',
            id                     => $ping_entry2->id,
            plugin_action_selector => 'unapprove_ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unapprove_ping" );
    ok( $out !~ m!not implemented!i,
        "unapprove_ping by permitted user (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $ichikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            blog_id              => $blog->id,
            _type                => 'ping',
            action_name          => 'unapprove_ping',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_ping%26blog_id%3D' . $blog->id,
            blog_id     => $blog->id,
            plugin_action_selector => 'unapprove_ping',
            id                     => $ping_entry->id,
            plugin_action_selector => 'unapprove_ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unapprove_ping" );
    ok( $out =~ m!permission=1!i,
        "unapprove_ping by other blog (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kagawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            blog_id              => $blog->id,
            _type                => 'ping',
            action_name          => 'unapprove_ping',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_ping%26blog_id%3D' . $blog->id,
            blog_id     => $blog->id,
            plugin_action_selector => 'unapprove_ping',
            id                     => $ping_page->id,
            plugin_action_selector => 'unapprove_ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unapprove_ping" );
    ok( $out =~ m!permission=1!i,
        "unapprove_ping by other blog (manage pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kemigawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            blog_id              => $blog->id,
            _type                => 'ping',
            action_name          => 'unapprove_ping',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_ping%26blog_id%3D' . $blog->id,
            blog_id     => $blog->id,
            plugin_action_selector => 'unapprove_ping',
            id                     => $ping_entry->id,
            plugin_action_selector => 'unapprove_ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unapprove_ping" );
    ok( $out =~ m!permission=1!i,
        "unapprove_ping by other blog (publish post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $ukawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            blog_id              => $blog->id,
            _type                => 'ping',
            action_name          => 'unapprove_ping',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_ping%26blog_id%3D' . $blog->id,
            blog_id     => $blog->id,
            plugin_action_selector => 'unapprove_ping',
            id                     => $ping_entry->id,
            plugin_action_selector => 'unapprove_ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: unapprove_ping" );
    ok( $out =~ m!not implemented!i, "unapprove_ping by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $ogawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            blog_id              => $blog->id,
            _type                => 'ping',
            action_name          => 'unapprove_ping',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_ping%26blog_id%3D' . $blog->id,
            blog_id     => $blog->id,
            plugin_action_selector => 'unapprove_ping',
            id                     => $ping_page->id,
            plugin_action_selector => 'unapprove_ping',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unapprove_ping" );
    ok( $out =~ m!not implemented!i,
        "unapprove_ping by non permitted user (create_post)" );

    done_testing();
};

done_testing();
