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
my $blog = MT::Test::Permission->make_blog(
    parent_id => $website->id,
);
my $second_blog = MT::Test::Permission->make_blog(
    parent_id => $website->id,
);

# Author
my $aikawa = MT::Test::Permission->make_author(
    name => 'aikawa',
    nickname => 'Ichiro Aikawa',
);

my $ichikawa = MT::Test::Permission->make_author(
    name => 'ichikawa',
    nickname => 'Jiro Ichikawa',
);

my $ukawa = MT::Test::Permission->make_author(
    name => 'ukawa',
    nickname => 'Saburo Ukawa',
);

my $egawa = MT::Test::Permission->make_author(
    name => 'egawa',
    nickname => 'Shiro Egawa',
);

my $ogawa = MT::Test::Permission->make_author(
    name => 'ogawa',
    nickname => 'Goro Ogawa',
);

my $kagawa = MT::Test::Permission->make_author(
    name => 'kagawa',
    nickname => 'Ichiro Kagawa',
);

my $kikkawa = MT::Test::Permission->make_author(
    name => 'kikkawa',
    nickname => 'Jiro Kikkawa',
);

my $kumekawa = MT::Test::Permission->make_author(
    name => 'kumekawa',
    nickname => 'Saburo Kumekawa',
);

my $kemikawa = MT::Test::Permission->make_author(
    name => 'kemikawa',
    nickname => 'Shiro Kemikawa',
);

my $koishikawa = MT::Test::Permission->make_author(
    name => 'koishikawa',
    nickname => 'Goro Koishikawa',
);

my $sagawa = MT::Test::Permission->make_author(
    name => 'sagawa',
    nickname => 'Ichiro Sagawa',
);

my $shimoda = MT::Test::Permission->make_author(
    name => 'shimoda',
    nickname => 'Jiro Shimoda',
);

my $suda = MT::Test::Permission->make_author(
    name => 'suda',
    nickname => 'Saburo Suda',
);

my $seta = MT::Test::Permission->make_author(
    name => 'seta',
    nickname => 'Shiro Seta',
);

my $admin = MT::Author->load(1);

# Role
my $create_post = MT::Test::Permission->make_role(
   name  => 'Create Post',
   permissions => "'create_post'",
);

my $edit_all_posts = MT::Test::Permission->make_role(
   name  => 'Edit All Posts',
   permissions => "'edit_all_posts'",
);

my $manage_pages = MT::Test::Permission->make_role(
   name  => 'Manage Pages',
   permissions => "'manage_pages'",
);

my $publish_post = MT::Test::Permission->make_role(
   name  => 'Publish Post',
   permissions => "'publish_post'",
);

my $edit_config = MT::Test::Permission->make_role(
   name  => 'Edit Config',
   permissions => "'edit_config'",
);

my $designer = MT::Role->load( { name => MT->translate( 'Designer' ) } );

require MT::Association;
MT::Association->link( $aikawa => $edit_config => $blog );
MT::Association->link( $ichikawa => $create_post => $blog );
MT::Association->link( $ukawa => $edit_all_posts => $blog );
MT::Association->link( $egawa => $manage_pages => $blog );
MT::Association->link( $ogawa => $create_post => $blog );
MT::Association->link( $kagawa => $designer => $blog );
MT::Association->link( $shimoda => $publish_post => $blog );
MT::Association->link( $seta => $publish_post => $blog );

MT::Association->link( $kikkawa => $edit_config => $second_blog );
MT::Association->link( $kumekawa => $create_post => $second_blog );
MT::Association->link( $koishikawa => $edit_all_posts => $second_blog );
MT::Association->link( $kemikawa => $manage_pages => $second_blog );
MT::Association->link( $suda => $publish_post => $second_blog );

# Entry
my $entry = MT::Test::Permission->make_entry(
    blog_id        => $blog->id,
    author_id      => $ichikawa->id,
);

# Page
my $page = MT::Test::Permission->make_page(
    blog_id        => $blog->id,
    author_id      => $egawa->id,
);

# Run
my ( $app, $out );

subtest 'mode = cfg_entry' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'cfg_entry',
            blog_id          => $blog->id,
            _type            => 'entry',
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: cfg_entry" );
    ok( $out !~ m!Permission denied!i, "cfg_entry by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'cfg_entry',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: cfg_entry" );
    ok( $out !~ m!Permission denied!i, "cfg_entry by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'cfg_entry',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: cfg_entry" );
    ok( $out =~ m!Permission denied!i, "cfg_entry by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'cfg_entry',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: cfg_entry" );
    ok( $out =~ m!Permission denied!i, "cfg_entry by other permission" );
};

subtest 'mode = delete_entry' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete_entry" );
    ok( $out !~ m!Permission denied!i, "delete_entry by admin" );

    $entry = MT::Test::Permission->make_entry(
        blog_id        => $blog->id,
        author_id      => $ichikawa->id,
    );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete_entry" );
    ok( $out !~ m!Permission denied!i, "delete_entry by permitted user (create_post)" );

    $entry = MT::Test::Permission->make_entry(
        blog_id        => $blog->id,
        author_id      => $ichikawa->id,
    );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'delete_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete_entry" );
    ok( $out !~ m!Permission denied!i, "delete_entry by permitted user (edit_all_posts)" );

    $entry = MT::Test::Permission->make_entry(
        blog_id        => $blog->id,
        author_id      => $ichikawa->id,
    );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'delete_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete_entry" );
    ok( $out =~ m!Permission denied!i, "delete_entry by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'delete_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete_entry" );
    ok( $out =~ m!Permission denied!i, "delete_entry by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'delete_entry',
            blog_id          => $second_blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete_entry" );
    ok( $out =~ m!Permission denied!i, "delete_entry by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'delete_entry',
            blog_id          => $blog->id,
            id               => $page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete_entry" );
    ok( $out =~ m!Permission denied!i, "delete_entry by type mismatch" );

};

subtest 'mode = list_entries' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list_entries',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_entries" );
    ok( $out !~ m!Permission denied!i, "list_entries by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'list_entries',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_entries" );
    ok( $out !~ m!Permission denied!i, "list_entries by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'list_entries',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_entries" );
    ok( $out !~ m!Permission denied!i, "list_entries by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'list_entries',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_entries" );
    ok( $out =~ m!Permission denied!i, "list_entries by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'list_entries',
            blog_id          => $second_blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_entries" );
    ok( $out =~ m!Permission denied!i, "list_entries by other blog" );
};

subtest 'mode = pinged_url' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'pinged_url',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: pinged_url" );
    ok( $out !~ m!Permission denied!i, "pinged_url by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'pinged_url',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: pinged_url" );
    ok( $out !~ m!Permission denied!i, "pinged_url by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'pinged_url',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: pinged_url" );
    ok( $out !~ m!Permission denied!i, "pinged_url by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'pinged_url',
            blog_id          => $blog->id,
            entry_id         => $page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: pinged_url" );
    ok( $out !~ m!Permission denied!i, "pinged_url by permitted user (manage_page)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'pinged_url',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: pinged_url" );
    ok( $out =~ m!Permission denied!i, "pinged_url by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'pinged_url',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: pinged_url" );
    ok( $out =~ m!Permission denied!i, "pinged_url by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'pinged_url',
            blog_id          => $second_blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: pinged_url" );
    ok( $out =~ m!Permission denied!i, "pinged_url by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'pinged_url',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: pinged_url" );
    ok( $out =~ m!Permission denied!i, "pinged_url by type mismatch" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'pinged_url',
            blog_id          => $blog->id,
            entry_id         => $page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: pinged_url" );
    ok( $out =~ m!Permission denied!i, "pinged_url by type mismatch" );
};

subtest 'mode = preview' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'preview',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: preview" );
    ok( $out !~ m!Permission denied!i, "preview by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'preview',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: preview" );
    ok( $out !~ m!Permission denied!i, "preview by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'preview',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: preview" );
    ok( $out !~ m!Permission denied!i, "preview by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'preview',
            blog_id          => $blog->id,
            id               => $page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: preview" );
    ok( $out !~ m!Permission denied!i, "preview by permitted user (manage_page)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'preview',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: preview" );
    ok( $out =~ m!Permission denied!i, "preview by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'preview',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: preview" );
    ok( $out =~ m!Permission denied!i, "preview by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'preview',
            blog_id          => $second_blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: preview" );
    ok( $out =~ m!Permission denied!i, "preview by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'preview',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: preview" );
    ok( $out =~ m!Permission denied!i, "preview by type mismatch" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'preview',
            blog_id          => $blog->id,
            id               => $page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: preview" );
    ok( $out =~ m!Permission denied!i, "preview by type mismatch" );
};

subtest 'mode = save_entry' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
            title            => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entry" );
    ok( $out !~ m!Permission denied!i, "save_entry by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
            title            => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entry" );
    ok( $out !~ m!Permission denied!i, "save_entry by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
            title            => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entry" );
    ok( $out !~ m!Permission denied!i, "save_entry by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
            title            => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entry" );
    ok( $out =~ m!Permission denied!i, "save_entry by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
            title            => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entry" );
    ok( $out =~ m!Permission denied!i, "save_entry by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $second_blog->id,
            id               => $entry->id,
            title            => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entry" );
    ok( $out =~ m!Permission denied!i, "save_entry by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
            title            => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entry" );
    ok( $out =~ m!Permission denied!i, "save_entry by type mismatch" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $blog->id,
            id               => $page->id,
            title            => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entry" );
    ok( $out =~ m!Permission denied!i, "save_entry by type mismatch" );
};

subtest 'mode = save_entries' => sub {
    my $author_id  = "author_id_" . $entry->id;
    my $col_name  = "title_" . $entry->id;

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save_entries',
            blog_id          => $blog->id,
            $author_id       => $entry->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entries" );
    ok( $out !~ m!Permission denied!i, "save_entries by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save_entries',
            blog_id          => $blog->id,
            $author_id       => $entry->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entries" );
    ok( $out !~ m!Permission denied!i, "save_entries by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save_entries',
            blog_id          => $blog->id,
            $author_id       => $entry->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entries" );
    ok( $out !~ m!Permission denied!i, "save_entries by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'save_entries',
            blog_id          => $blog->id,
            $author_id       => $entry->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entries" );
    ok( $out =~ m!Permission denied!i, "save_entries by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'save_entries',
            blog_id          => $blog->id,
            $author_id       => $entry->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entries" );
    ok( $out =~ m!Permission denied!i, "save_entries by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'save_entries',
            blog_id          => $second_blog->id,
            $author_id       => $entry->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entries" );
    ok( $out =~ m!Permission denied!i, "save_entries by other blog" );

    $author_id  = "author_id_" . $page->id;
    $col_name  = "title_" . $page->id;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save_entries',
            blog_id          => $blog->id,
            $author_id       => $page->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entries" );
    ok( $out =~ m!Permission denied!i, "save_entries by type mismatch" );
};

subtest 'mode = send_pings' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'send_pings',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: send_pings" );
    ok( $out !~ m!Permission denied!i, "send_pings by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'send_pings',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: send_pings" );
    ok( $out !~ m!Permission denied!i, "send_pings by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'send_pings',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: send_pings" );
    ok( $out !~ m!Permission denied!i, "send_pings by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'send_pings',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: send_pings" );
    ok( $out =~ m!Permission denied!i, "send_pings by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'send_pings',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: send_pings" );
    ok( $out =~ m!Permission denied!i, "send_pings by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'send_pings',
            blog_id          => $second_blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: send_pings" );
    ok( $out =~ m!Permission denied!i, "send_pings by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'send_pings',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: send_pings" );
    ok( $out =~ m!Permission denied!i, "send_pings by type mismatch" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'send_pings',
            blog_id          => $blog->id,
            entry_id         => $page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: send_pings" );
    ok( $out =~ m!Permission denied!i, "send_pings by type mismatch" );
};

subtest 'mode = edit' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out !~ m!Permission denied!i, "edit by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out !~ m!Permission denied!i, "edit by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out !~ m!Permission denied!i, "edit by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Permission denied!i, "edit by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Permission denied!i, "edit by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'entry',
            blog_id          => $second_blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Permission denied!i, "edit by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'entry',
            blog_id          => $blog->id,
            id               => $page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Permission denied!i, "edit by type mismatch" );
};

subtest 'action = set_draft' => sub {
    $entry = MT::Test::Permission->make_entry(
        blog_id        => $blog->id,
        author_id      => $shimoda->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'entry',
            action_name      => 'set_draft',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'set_draft',
            id               => $entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: set_draft" );
    ok( $out !~ m!Permission denied!i, "set_draft by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $shimoda,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'entry',
            action_name      => 'set_draft',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'set_draft',
            id               => $entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: set_draft" );
    ok( $out !~ m!Permission denied!i, "set_draft by permitted user (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'set_draft',
            _type            => 'entry',
            action_name      => 'set_draft',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'set_draft',
            id               => $entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: set_draft" );
    ok( $out !~ m!Permission denied!i, "set_draft by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $seta,
            __request_method => 'POST',
            __mode           => 'set_draft',
            _type            => 'entry',
            action_name      => 'set_draft',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'set_draft',
            id               => $entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: set_draft" );
    ok( $out =~ m!Permission denied!i, "set_draft by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'set_draft',
            _type            => 'entry',
            action_name      => 'set_draft',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'set_draft',
            id               => $entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: set_draft" );
    ok( $out =~ m!Permission denied!i, "set_draft by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $koishikawa,
            __request_method => 'POST',
            __mode           => 'set_draft',
            _type            => 'entry',
            action_name      => 'set_draft',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'set_draft',
            id               => $entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: set_draft" );
    ok( $out =~ m!Permission denied!i, "set_draft by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'set_draft',
            _type            => 'entry',
            action_name      => 'set_draft',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'set_draft',
            id               => $page->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: set_draft" );
    ok( $out =~ m!Permission denied!i, "set_draft by type mismatch" );

};

subtest 'action = add_tags' => sub {
    $entry = MT::Test::Permission->make_entry(
        blog_id        => $blog->id,
        author_id      => $ichikawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'entry',
            action_name      => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'add_tags',
            id               => $entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out !~ m!Permission denied!i, "add_tags by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'entry',
            action_name      => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'add_tags',
            id               => $entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out !~ m!Permission denied!i, "add_tags by permitted user (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'add_tags',
            _type            => 'entry',
            action_name      => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'add_tags',
            id               => $entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out !~ m!Permission denied!i, "add_tags by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'add_tags',
            _type            => 'entry',
            action_name      => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'add_tags',
            id               => $entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out =~ m!Permission denied!i, "add_tags by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'add_tags',
            _type            => 'entry',
            action_name      => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'add_tags',
            id               => $entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out =~ m!Permission denied!i, "add_tags by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $koishikawa,
            __request_method => 'POST',
            __mode           => 'add_tags',
            _type            => 'entry',
            action_name      => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'add_tags',
            id               => $entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out =~ m!Permission denied!i, "add_tags by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'add_tags',
            _type            => 'entry',
            action_name      => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'add_tags',
            id               => $page->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out =~ m!Permission denied!i, "add_tags by type mismatch" );

};

subtest 'action = remove_tags' => sub {
    $entry = MT::Test::Permission->make_entry(
        blog_id        => $blog->id,
        author_id      => $ichikawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'entry',
            action_name      => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'remove_tags',
            id               => $entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out !~ m!Permission denied!i, "remove_tags by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'entry',
            action_name      => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'remove_tags',
            id               => $entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out !~ m!Permission denied!i, "remove_tags by permitted user (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'remove_tags',
            _type            => 'entry',
            action_name      => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'remove_tags',
            id               => $entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out !~ m!Permission denied!i, "remove_tags by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'remove_tags',
            _type            => 'entry',
            action_name      => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'remove_tags',
            id               => $entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out =~ m!Permission denied!i, "remove_tags by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'remove_tags',
            _type            => 'entry',
            action_name      => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'remove_tags',
            id               => $entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out =~ m!Permission denied!i, "remove_tags by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $koishikawa,
            __request_method => 'POST',
            __mode           => 'remove_tags',
            _type            => 'entry',
            action_name      => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'remove_tags',
            id               => $entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out =~ m!Permission denied!i, "remove_tags by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'remove_tags',
            _type            => 'entry',
            action_name      => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'remove_tags',
            id               => $page->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out =~ m!Permission denied!i, "remove_tags by type mismatch" );

};

subtest 'action = open_batch_editor' => sub {
    $entry = MT::Test::Permission->make_entry(
        blog_id        => $blog->id,
        author_id      => $ichikawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'entry',
            action_name      => 'open_batch_editor',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'open_batch_editor',
            id               => $entry->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: open_batch_editor" );
    ok( $out !~ m!Permission denied!i, "open_batch_editor by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'entry',
            action_name      => 'open_batch_editor',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'open_batch_editor',
            id               => $entry->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: open_batch_editor" );
    ok( $out !~ m!Permission denied!i, "open_batch_editor by permitted user (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'open_batch_editor',
            _type            => 'entry',
            action_name      => 'open_batch_editor',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'open_batch_editor',
            id               => $entry->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: open_batch_editor" );
    ok( $out !~ m!Permission denied!i, "open_batch_editor by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'open_batch_editor',
            _type            => 'entry',
            action_name      => 'open_batch_editor',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'open_batch_editor',
            id               => $entry->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: open_batch_editor" );
    ok( $out =~ m!Permission denied!i, "open_batch_editor by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'open_batch_editor',
            _type            => 'entry',
            action_name      => 'open_batch_editor',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'open_batch_editor',
            id               => $entry->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: open_batch_editor" );
    ok( $out =~ m!Permission denied!i, "open_batch_editor by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $koishikawa,
            __request_method => 'POST',
            __mode           => 'open_batch_editor',
            _type            => 'entry',
            action_name      => 'open_batch_editor',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'open_batch_editor',
            id               => $entry->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: open_batch_editor" );
    ok( $out =~ m!Permission denied!i, "open_batch_editor by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'open_batch_editor',
            _type            => 'entry',
            action_name      => 'open_batch_editor',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_entry%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'open_batch_editor',
            id               => $page->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: open_batch_editor" );
    ok( $out =~ m!Permission denied!i, "open_batch_editor by type mismatch" );

};

done_testing();
