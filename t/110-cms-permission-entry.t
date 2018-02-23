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
my $website       = MT::Test::Permission->make_website();
my $other_website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );
my $second_blog
    = MT::Test::Permission->make_blog( parent_id => $website->id, );
my $other_blog
    = MT::Test::Permission->make_blog( parent_id => $other_website->id, );

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

my $koishikawa = MT::Test::Permission->make_author(
    name     => 'koishikawa',
    nickname => 'Goro Koishikawa',
);

my $sagawa = MT::Test::Permission->make_author(
    name     => 'sagawa',
    nickname => 'Ichiro Sagawa',
);

my $shimoda = MT::Test::Permission->make_author(
    name     => 'shimoda',
    nickname => 'Jiro Shimoda',
);

my $suda = MT::Test::Permission->make_author(
    name     => 'suda',
    nickname => 'Saburo Suda',
);

my $seta = MT::Test::Permission->make_author(
    name     => 'seta',
    nickname => 'Shiro Seta',
);

my $sorimachi = MT::Test::Permission->make_author(
    name     => 'sorimachi',
    nickname => 'Goro Sorimachi',
);

my $tada = MT::Test::Permission->make_author(
    name     => 'tada',
    nickname => 'Ichiro Tada',
);

my $chiyoda = MT::Test::Permission->make_author(
    name     => 'chiyoda',
    nickname => 'Jiro Chiyoda',
);

my $tsuneta = MT::Test::Permission->make_author(
    name     => 'tsuneta',
    nickname => 'Saburo Tsuneta',
);

my $terada = MT::Test::Permission->make_author(
    name     => 'terada',
    nickname => 'Shiro Terada',
);

my $toda = MT::Test::Permission->make_author(
    name     => 'toda',
    nickname => 'Goro Toda',
);

my $nashida = MT::Test::Permission->make_author(
    name     => 'nashida',
    nickname => 'Ichiro Nashida',
);

my $nishioka = MT::Test::Permission->make_author(
    name     => 'nishioka',
    nickname => 'Jiro Nishioka',
);

my $nukita = MT::Test::Permission->make_author(
    name     => 'nukita',
    nickname => 'Saburo Nukita',
);

my $negishi = MT::Test::Permission->make_author(
    name     => 'negishi',
    nickname => 'Shiro Negishi',
);

my $nonoda = MT::Test::Permission->make_author(
    name     => 'nonoda',
    nickname => 'Goro Nonoda',
);

my $hakamada = MT::Test::Permission->make_author(
    name     => 'hakamada',
    nickname => 'Ichiro Hakamada',
);

my $hikita = MT::Test::Permission->make_author(
    name     => 'hikita',
    nickname => 'Jiro Hikita',
);

my $fukuda = MT::Test::Permission->make_author(
    name     => 'fukuda',
    nickname => 'Saburo Fukuda',
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

my $manage_pages = MT::Test::Permission->make_role(
    name        => 'Manage Pages',
    permissions => "'manage_pages'",
);

my $publish_post = MT::Test::Permission->make_role(
    name        => 'Publish Post',
    permissions => "'publish_post'",
);

my $edit_config = MT::Test::Permission->make_role(
    name        => 'Edit Config',
    permissions => "'edit_config'",
);

my $designer = MT::Role->load( { name => MT->translate('Designer') } );

require MT::Association;
MT::Association->link( $aikawa   => $edit_config    => $blog );
MT::Association->link( $ichikawa => $create_post    => $blog );
MT::Association->link( $ukawa    => $edit_all_posts => $blog );
MT::Association->link( $egawa    => $manage_pages   => $blog );
MT::Association->link( $ogawa    => $create_post    => $blog );
MT::Association->link( $kagawa   => $designer       => $blog );
MT::Association->link( $shimoda  => $publish_post   => $blog );
MT::Association->link( $seta     => $publish_post   => $blog );

MT::Association->link( $kikkawa    => $edit_config    => $second_blog );
MT::Association->link( $kumekawa   => $create_post    => $second_blog );
MT::Association->link( $koishikawa => $edit_all_posts => $second_blog );
MT::Association->link( $kemikawa   => $manage_pages   => $second_blog );
MT::Association->link( $suda       => $publish_post   => $second_blog );

MT::Association->link( $sorimachi, $edit_config,    $website );
MT::Association->link( $tsuneta,   $create_post,    $website );
MT::Association->link( $terada,    $edit_all_posts, $website );
MT::Association->link( $nishioka,  $create_post,    $website );
MT::Association->link( $nukita,    $designer,       $website );
MT::Association->link( $negishi,   $manage_pages,   $website );
MT::Association->link( $hikita,    $publish_post,   $website );
MT::Association->link( $fukuda,    $publish_post,   $website );

MT::Association->link( $tada,   $edit_config,    $other_website );
MT::Association->link( $toda,   $create_post,    $other_website );
MT::Association->link( $nonoda, $edit_all_posts, $other_website );

MT::Association->link( $chiyoda,  $edit_config,    $other_blog );
MT::Association->link( $nashida,  $create_post,    $other_blog );
MT::Association->link( $hakamada, $edit_all_posts, $other_blog );

# Entry
my $entry = MT::Test::Permission->make_entry(
    blog_id   => $blog->id,
    author_id => $ichikawa->id,
);
my $entry2 = MT::Test::Permission->make_entry(
    blog_id   => $blog->id,
    author_id => $shimoda->id,
);
my $website_entry = MT::Test::Permission->make_entry(
    blog_id   => $website->id,
    author_id => $tsuneta->id,
);
my $other_website_entry = MT::Test::Permission->make_entry(
    blog_id   => $other_website->id,
    author_id => $toda->id,
);

# Page
my $page = MT::Test::Permission->make_page(
    blog_id   => $blog->id,
    author_id => $egawa->id,
);
my $website_page = MT::Test::Permission->make_page(
    blog_id   => $website->id,
    author_id => $negishi->id,
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
    ok( $out,                     "Request: cfg_entry" );
    ok( $out !~ m!permission=1!i, "cfg_entry by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'cfg_entry',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_entry" );
    ok( $out !~ m!permission=1!i, "cfg_entry by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'cfg_entry',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_entry" );
    ok( $out =~ m!permission=1!i, "cfg_entry by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'cfg_entry',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_entry" );
    ok( $out =~ m!permission=1!i, "cfg_entry by other permission" );
};

subtest 'mode = cfg_entry (website)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'cfg_entry',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_entry" );
    ok( $out !~ m!permission=1!i, "cfg_entry by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sorimachi,
            __request_method => 'POST',
            __mode           => 'cfg_entry',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_entry" );
    ok( $out !~ m!permission=1!i, "cfg_entry by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tada,
            __request_method => 'POST',
            __mode           => 'cfg_entry',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_entry" );
    ok( $out =~ m!permission=1!i, "cfg_entry by other website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'cfg_entry',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_entry" );
    ok( $out =~ m!permission=1!i, "cfg_entry by child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $chiyoda,
            __request_method => 'POST',
            __mode           => 'cfg_entry',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_entry" );
    ok( $out =~ m!permission=1!i, "cfg_entry by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'cfg_entry',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_entry" );
    ok( $out =~ m!permission=1!i, "cfg_entry by other permission" );
};

subtest 'mode = delete_entry' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete_entry',
            blog_id          => $website->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete_entry" );
    ok( $out !~ m!permission=1!i, "delete_entry by admin" );

    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ichikawa->id,
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
    ok( $out !~ m!permission=1!i,
        "delete_entry by permitted user (create_post)" );

    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ichikawa->id,
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
    ok( $out !~ m!permission=1!i,
        "delete_entry by permitted user (edit_all_posts)" );

    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ichikawa->id,
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
    ok( $out,                     "Request: delete_entry" );
    ok( $out =~ m!permission=1!i, "delete_entry by other user" );

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
    ok( $out,                     "Request: delete_entry" );
    ok( $out =~ m!permission=1!i, "delete_entry by other permission" );

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
    ok( $out,                     "Request: delete_entry" );
    ok( $out =~ m!permission=1!i, "delete_entry by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'delete_entry',
            blog_id          => $blog->id,
            id               => $page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete_entry" );
    ok( $out =~ m!permission=1!i, "delete_entry by type mismatch" );

};

subtest 'mode = delete_entry (website)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete_entry',
            blog_id          => $blog->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete_entry" );
    ok( $out !~ m!permission=1!i, "delete_entry by admin" );

    $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $tsuneta->id,
    );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuneta,
            __request_method => 'POST',
            __mode           => 'delete_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete_entry" );
    ok( $out !~ m!permission=1!i,
        "delete_entry by permitted user (create_post)" );

    $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $tsuneta->id,
    );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $terada,
            __request_method => 'POST',
            __mode           => 'delete_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete_entry" );
    ok( $out !~ m!permission=1!i,
        "delete_entry by permitted user (edit_all_posts)" );

    $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $tsuneta->id,
    );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nishioka,
            __request_method => 'POST',
            __mode           => 'delete_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete_entry" );
    ok( $out =~ m!permission=1!i, "delete_entry by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nukita,
            __request_method => 'POST',
            __mode           => 'delete_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete_entry" );
    ok( $out =~ m!permission=1!i, "delete_entry by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $toda,
            __request_method => 'POST',
            __mode           => 'delete_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete_entry" );
    ok( $out =~ m!permission=1!i, "delete_entry by other website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete_entry" );
    ok( $out =~ m!permission=1!i, "delete_entry by child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nashida,
            __request_method => 'POST',
            __mode           => 'delete_entry',
            blog_id          => $other_website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete_entry" );
    ok( $out =~ m!permission=1!i, "delete_entry by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $terada,
            __request_method => 'POST',
            __mode           => 'delete_entry',
            blog_id          => $website->id,
            id               => $website_page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete_entry" );
    ok( $out =~ m!permission=1!i, "delete_entry by type mismatch" );

};

subtest 'mode = list' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out !~ m!(redirect|permission)=1|An error occurr?ed!i,
        "list by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out !~ m!(redirect|permission)=1|An error occurr?ed!i,
        "list by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out !~ m!(redirect|permission)=1|An error occurr?ed!i,
        "list by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out =~ m!(redirect|permission)=1|An error occurr?ed!i,
        "list by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out =~ m!(redirect|permission)=1|An error occurr?ed!i,
        "list by other blog" );
};

subtest 'mode = list (website)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out !~ m!(redirect|permission)=1|An error occurr?ed!i,
        "list by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuneta,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out !~ m!(redirect|permission)=1|An error occurr?ed!i,
        "list by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $terada,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out !~ m!(redirect|permission)=1|An error occurr?ed!i,
        "list by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nukita,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out =~ m!(redirect|permission)=1|An error occurr?ed!i,
        "list by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $toda,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out =~ m!(redirect|permission)=1|An error occurr?ed!i,
        "list by other website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out !~ m!(redirect|permission)=1|An error occurr?ed!i,
        "list by child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nashida,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out =~ m!(redirect|permission)=1|An error occurr?ed!i,
        "list by other blog" );
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
    ok( $out,                     "Request: list_entries" );
    ok( $out !~ m!permission=1!i, "list_entries by admin" );

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
    ok( $out !~ m!permission=1!i,
        "list_entries by permitted user (create_post)" );

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
    ok( $out !~ m!permission=1!i,
        "list_entries by permitted user (edit_all_posts)" );

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
    ok( $out,                     "Request: list_entries" );
    ok( $out =~ m!permission=1!i, "list_entries by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'list_entries',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list_entries" );
    ok( $out =~ m!permission=1!i, "list_entries by other blog" );
};

subtest 'mode = list_entries (website)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list_entries',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list_entries" );
    ok( $out !~ m!permission=1!i, "list_entries by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuneta,
            __request_method => 'POST',
            __mode           => 'list_entries',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_entries" );
    ok( $out !~ m!permission=1!i,
        "list_entries by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $terada,
            __request_method => 'POST',
            __mode           => 'list_entries',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_entries" );
    ok( $out !~ m!permission=1!i,
        "list_entries by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nukita,
            __request_method => 'POST',
            __mode           => 'list_entries',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list_entries" );
    ok( $out =~ m!permission=1!i, "list_entries by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $toda,
            __request_method => 'POST',
            __mode           => 'list_entries',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list_entries" );
    ok( $out =~ m!permission=1!i, "list_entries by other website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'list_entries',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list_entries" );
    ok( $out =~ m!permission=1!i, "list_entries by child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nashida,
            __request_method => 'POST',
            __mode           => 'list_entries',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list_entries" );
    ok( $out =~ m!permission=1!i, "list_entries by other blog" );
};

subtest 'mode = pinged_urls' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: pinged_urls" );
    ok( $out !~ m!permission=1!i, "pinged_urls by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: pinged_urls" );
    ok( $out !~ m!permission=1!i,
        "pinged_urls by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: pinged_urls" );
    ok( $out !~ m!permission=1!i,
        "pinged_urls by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $blog->id,
            entry_id         => $page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: pinged_urls" );
    ok( $out !~ m!permission=1!i,
        "pinged_urls by permitted user (manage_page)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: pinged_urls" );
    ok( $out =~ m!permission=1!i, "pinged_urls by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: pinged_urls" );
    ok( $out =~ m!permission=1!i, "pinged_urls by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $second_blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: pinged_urls" );
    ok( $out =~ m!invalid request!i, "pinged_urls by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: pinged_urls" );
    ok( $out =~ m!permission=1!i, "pinged_urls by type mismatch" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $blog->id,
            entry_id         => $page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: pinged_urls" );
    ok( $out =~ m!permission=1!i, "pinged_urls by type mismatch" );
};

subtest 'mode = pinged_urls (website)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $website->id,
            entry_id         => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: pinged_urls" );
    ok( $out !~ m!permission=1!i, "pinged_urls by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuneta,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $website->id,
            entry_id         => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: pinged_urls" );
    ok( $out !~ m!permission=1!i,
        "pinged_urls by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $terada,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $website->id,
            entry_id         => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: pinged_urls" );
    ok( $out !~ m!permission=1!i,
        "pinged_urls by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $negishi,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $website->id,
            entry_id         => $website_page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: pinged_urls" );
    ok( $out !~ m!permission=1!i,
        "pinged_urls by permitted user (manage_page)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nishioka,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $website->id,
            entry_id         => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: pinged_urls" );
    ok( $out =~ m!permission=1!i, "pinged_urls by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nukita,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $website->id,
            entry_id         => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: pinged_urls" );
    ok( $out =~ m!permission=1!i, "pinged_urls by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $toda,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $other_website->id,
            entry_id         => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: pinged_urls" );
    ok( $out =~ m!invalid request!i, "pinged_urls by other website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $toda,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $other_website->id,
            entry_id         => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: pinged_urls" );
    ok( $out =~ m!invalid request!i, "pinged_urls by child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nashida,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $other_blog->id,
            entry_id         => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: pinged_urls" );
    ok( $out =~ m!invalid request!i, "pinged_urls by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $negishi,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $website->id,
            entry_id         => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: pinged_urls" );
    ok( $out =~ m!permission=1!i, "pinged_urls by type mismatch" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuneta,
            __request_method => 'POST',
            __mode           => 'pinged_urls',
            blog_id          => $website->id,
            entry_id         => $website_page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: pinged_urls" );
    ok( $out =~ m!permission=1!i, "pinged_urls by type mismatch" );
};

subtest 'mode = preview_entry' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: preview_entry" );
    ok( $out !~ m!permission=1!i, "preview_entry by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: preview_entry" );
    ok( $out !~ m!permission=1!i,
        "preview_entry by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: preview_entry" );
    ok( $out !~ m!permission=1!i,
        "preview_entry by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $blog->id,
            id               => $page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: preview_entry" );
    ok( $out !~ m!permission=1!i,
        "preview_entry by permitted user (manage_page)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: preview_entry" );
    ok( $out =~ m!permission=1!i, "preview_entry by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: preview_entry" );
    ok( $out =~ m!permission=1!i, "preview_entry by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $second_blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: preview_entry" );
    ok( $out =~ m!invalid request!i, "preview_entry by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: preview_entry" );
    ok( $out =~ m!permission=1!i, "preview_entry by type mismatch" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $blog->id,
            id               => $page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: preview_entry" );
    ok( $out =~ m!permission=1!i, "preview_entry by type mismatch" );
};

subtest 'mode = preview_entry (website)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: preview_entry" );
    ok( $out !~ m!permission=1!i, "preview_entry by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuneta,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: preview_entry" );
    ok( $out !~ m!permission=1!i,
        "preview_entry by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $terada,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: preview_entry" );
    ok( $out !~ m!permission=1!i,
        "preview_entry by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $negishi,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $website->id,
            id               => $website_page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: preview_entry" );
    ok( $out !~ m!permission=1!i,
        "preview_entry by permitted user (manage_page)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nishioka,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: preview_entry" );
    ok( $out =~ m!permission=1!i, "preview_entry by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nukita,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: preview_entry" );
    ok( $out =~ m!permission=1!i, "preview_entry by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $toda,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $other_website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: preview_entry" );
    ok( $out =~ m!invalid request!i, "preview_entry by other website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $blog->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: preview_entry" );
    ok( $out =~ m!invalid request!i, "preview_entry by child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nashida,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $other_blog->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: preview_entry" );
    ok( $out =~ m!invalid request!i, "preview_entry by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $negishi,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: preview_entry" );
    ok( $out =~ m!permission=1!i, "preview_entry by type mismatch" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuneta,
            __request_method => 'POST',
            __mode           => 'preview_entry',
            blog_id          => $website->id,
            id               => $website_page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: preview_entry" );
    ok( $out =~ m!permission=1!i, "preview_entry by type mismatch" );
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
            _type            => 'entry',
            status           => $entry->status,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entry" );
    ok( $out !~ m!permission=1!i, "save_entry by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
            title            => 'changed',
            _type            => 'entry',
            status           => $entry->status,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entry" );
    ok( $out !~ m!permission=1!i,
        "save_entry by permitted user (create_post)" );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
            title            => 'changed',
            _type            => 'entry',
            status           => $entry->status,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entry" );
    ok( $out !~ m!permission=1!i,
        "save_entry by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
            title            => 'changed',
            _type            => 'entry',
            status           => $entry->status,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entry" );
    ok( $out =~ m!permission=1!i, "save_entry by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
            title            => 'changed',
            _type            => 'entry',
            status           => $entry->status,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entry" );
    ok( $out =~ m!permission=1!i, "save_entry by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
            title            => 'changed',
            _type            => 'entry',
            status           => $entry->status,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entry" );
    ok( $out =~ m!permission=1!i, "save_entry by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $blog->id,
            id               => $entry->id,
            title            => 'changed',
            _type            => 'entry',
            status           => $entry->status,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entry" );
    ok( $out =~ m!permission=1!i, "save_entry by type mismatch" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $blog->id,
            id               => $page->id,
            title            => 'changed',
            _type            => 'entry',
            status           => $page->status,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entry" );
    ok( $out =~ m!permission=1!i, "save_entry by type mismatch" );
};

subtest 'mode = save_entry (website)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
            title            => 'changed',
            _type            => 'entry',
            status           => $website_entry->status,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entry" );
    ok( $out !~ m!permission=1!i, "save_entry by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuneta,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
            title            => 'changed',
            _type            => 'entry',
            status           => $website_entry->status,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entry" );
    ok( $out !~ m!permission=1!i,
        "save_entry by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $terada,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
            title            => 'changed',
            _type            => 'entry',
            status           => $website_entry->status,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entry" );
    ok( $out !~ m!permission=1!i,
        "save_entry by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nishioka,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
            title            => 'changed',
            _type            => 'entry',
            status           => $website_entry->status,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entry" );
    ok( $out =~ m!permission=1!i, "save_entry by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nukita,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
            title            => 'changed',
            _type            => 'entry',
            status           => $website_entry->status,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entry" );
    ok( $out =~ m!permission=1!i, "save_entry by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $toda,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
            title            => 'changed',
            _type            => 'entry',
            status           => $website_entry->status,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entry" );
    ok( $out =~ m!permission=1!i, "save_entry by other website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
            title            => 'changed',
            _type            => 'entry',
            status           => $website_entry->status,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entry" );
    ok( $out =~ m!permission=1!i, "save_entry by child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nashida,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
            title            => 'changed',
            _type            => 'entry',
            status           => $website_entry->status,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entry" );
    ok( $out =~ m!permission=1!i, "save_entry by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $negishi,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
            title            => 'changed',
            _type            => 'entry',
            status           => $website_entry->status,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entry" );
    ok( $out =~ m!permission=1!i, "save_entry by type mismatch" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuneta,
            __request_method => 'POST',
            __mode           => 'save_entry',
            blog_id          => $website->id,
            id               => $website_page->id,
            title            => 'changed',
            _type            => 'entry',
            status           => $website_page->status,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entry" );
    ok( $out =~ m!permission=1!i, "save_entry by type mismatch" );
};

subtest 'mode = save_entries' => sub {
    my $author_id = "author_id_" . $entry->id;
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
    ok( $out,                     "Request: save_entries" );
    ok( $out !~ m!permission=1!i, "save_entries by admin" );

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
    ok( $out =~ m!permission=1!i,
        "save_entries by non permitted user (create_post)" );

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
    ok( $out !~ m!permission=1!i,
        "save_entries by permitted user (edit_all_posts)" );

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
    ok( $out,                     "Request: save_entries" );
    ok( $out =~ m!permission=1!i, "save_entries by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $koishikawa,
            __request_method => 'POST',
            __mode           => 'save_entries',
            blog_id          => $second_blog->id,
            $author_id       => $entry->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entries" );
    ok( $out =~ m!permission=1!i, "save_entries by other blog" );

    $author_id = "author_id_" . $page->id;
    $col_name  = "title_" . $page->id;
    $app       = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save_entries',
            blog_id          => $blog->id,
            $author_id       => $page->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entries" );
    ok( $out =~ m!permission=1!i, "save_entries by type mismatch" );
};

subtest 'mode = save_entries (website)' => sub {
    my $author_id = "author_id_" . $website_entry->id;
    my $col_name  = "title_" . $website_entry->id;

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save_entries',
            blog_id          => $website->id,
            $author_id       => $website_entry->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entries" );
    ok( $out !~ m!permission=1!i, "save_entries by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuneta,
            __request_method => 'POST',
            __mode           => 'save_entries',
            blog_id          => $website->id,
            $author_id       => $website_entry->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entries" );
    ok( $out =~ m!permission=1!i,
        "save_entries by non permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $terada,
            __request_method => 'POST',
            __mode           => 'save_entries',
            blog_id          => $website->id,
            $author_id       => $website_entry->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entries" );
    ok( $out !~ m!permission=1!i,
        "save_entries by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nukita,
            __request_method => 'POST',
            __mode           => 'save_entries',
            blog_id          => $website->id,
            $author_id       => $website_entry->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entries" );
    ok( $out =~ m!permission=1!i, "save_entries by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nonoda,
            __request_method => 'POST',
            __mode           => 'save_entries',
            blog_id          => $other_website->id,
            $author_id       => $website_entry->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entries" );
    ok( $out =~ m!permission=1!i, "save_entries by other website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save_entries',
            blog_id          => $blog->id,
            $author_id       => $website_entry->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entries" );
    ok( $out =~ m!permission=1!i, "save_entries by child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $hakamada,
            __request_method => 'POST',
            __mode           => 'save_entries',
            blog_id          => $other_blog->id,
            $author_id       => $website_entry->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entries" );
    ok( $out =~ m!permission=1!i, "save_entries by other blog" );

    $author_id = "author_id_" . $website_page->id;
    $col_name  = "title_" . $website_page->id;
    $app       = _run_app(
        'MT::App::CMS',
        {   __test_user      => $terada,
            __request_method => 'POST',
            __mode           => 'save_entries',
            blog_id          => $website->id,
            $author_id       => $website_page->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_entries" );
    ok( $out =~ m!permission=1!i, "save_entries by type mismatch" );
};

subtest 'mode = ping' => sub {
    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ichikawa->id,
    );
    $entry2 = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $shimoda->id,
    );
    $page = MT::Test::Permission->make_page(
        blog_id   => $blog->id,
        author_id => $egawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'ping',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: ping" );
    ok( $out !~ m!permission=1!i, "ping by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $shimoda,
            __request_method => 'POST',
            __mode           => 'ping',
            blog_id          => $blog->id,
            entry_id         => $entry2->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: ping" );
    ok( $out !~ m!permission=1!i, "ping by permitted user (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'ping',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: ping" );
    ok( $out !~ m!permission=1!i, "ping by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'ping',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: ping" );
    ok( $out =~ m!permission=1!i, "ping by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'ping',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: ping" );
    ok( $out =~ m!permission=1!i, "ping by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'ping',
            blog_id          => $second_blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: ping" );
    ok( $out =~ m!permission=1!i, "ping by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'ping',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: ping" );
    ok( $out =~ m!permission=1!i, "ping by type mismatch (page)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $shimoda,
            __request_method => 'POST',
            __mode           => 'ping',
            blog_id          => $blog->id,
            entry_id         => $page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: ping" );
    ok( $out =~ m!permission=1!i, "ping by type mismatch (entry)" );

    done_testing();
};

subtest 'mode = ping (website)' => sub {
    $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $tsuneta->id,
    );
    my $website_entry2 = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $hikita->id,
    );
    $website_page = MT::Test::Permission->make_page(
        blog_id   => $website->id,
        author_id => $negishi->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'ping',
            blog_id          => $website->id,
            entry_id         => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: ping" );
    ok( $out !~ m!permission=1!i, "ping by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $hikita,
            __request_method => 'POST',
            __mode           => 'ping',
            blog_id          => $website->id,
            entry_id         => $website_entry2->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: ping" );
    ok( $out !~ m!permission=1!i, "ping by permitted user (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $terada,
            __request_method => 'POST',
            __mode           => 'ping',
            blog_id          => $website->id,
            entry_id         => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: ping" );
    ok( $out !~ m!permission=1!i, "ping by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nishioka,
            __request_method => 'POST',
            __mode           => 'ping',
            blog_id          => $website->id,
            entry_id         => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: ping" );
    ok( $out =~ m!permission=1!i, "ping by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nukita,
            __request_method => 'POST',
            __mode           => 'ping',
            blog_id          => $website->id,
            entry_id         => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: ping" );
    ok( $out =~ m!permission=1!i, "ping by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $toda,
            __request_method => 'POST',
            __mode           => 'ping',
            blog_id          => $other_website->id,
            entry_id         => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: ping" );
    ok( $out =~ m!permission=1!i, "ping by other website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'ping',
            blog_id          => $blog->id,
            entry_id         => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: ping" );
    ok( $out =~ m!permission=1!i, "ping by child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nashida,
            __request_method => 'POST',
            __mode           => 'ping',
            blog_id          => $other_blog->id,
            entry_id         => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: ping" );
    ok( $out =~ m!permission=1!i, "ping by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $negishi,
            __request_method => 'POST',
            __mode           => 'ping',
            blog_id          => $website->id,
            entry_id         => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: ping" );
    ok( $out =~ m!permission=1!i, "ping by type mismatch (page)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $hikita,
            __request_method => 'POST',
            __mode           => 'ping',
            blog_id          => $website->id,
            entry_id         => $website_page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: ping" );
    ok( $out =~ m!permission=1!i, "ping by type mismatch (entry)" );

    done_testing();
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
    ok( $out,                     "Request: edit" );
    ok( $out !~ m!permission=1!i, "edit by admin" );

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
    ok( $out,                     "Request: edit" );
    ok( $out !~ m!permission=1!i, "edit by permitted user (create_post)" );

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
    ok( $out,                     "Request: edit" );
    ok( $out !~ m!permission=1!i, "edit by permitted user (edit_all_posts)" );

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
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other user" );

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
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other permission" );

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
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other blog" );

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
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by type mismatch" );
};

subtest 'mode = edit (website)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out !~ m!permission=1!i, "edit by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuneta,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out !~ m!permission=1!i, "edit by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $terada,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out !~ m!permission=1!i, "edit by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nishioka,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nukita,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $toda,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'entry',
            blog_id          => $other_website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'entry',
            blog_id          => $website->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                   "Request: edit" );
    ok( $out =~ m!redirect=1!i, "edit by child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nashida,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'entry',
            blog_id          => $other_blog->id,
            id               => $website_entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuneta,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'entry',
            blog_id          => $website->id,
            id               => $website_page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by type mismatch" );
};

subtest 'action = set_draft' => sub {
    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $shimoda->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'set_draft',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'set_draft',
            id                     => $entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: set_draft" );
    ok( $out !~ m!not implemented!i, "set_draft by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $shimoda,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'set_draft',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'set_draft',
            id                     => $entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: set_draft" );
    ok( $out !~ m!not implemented!i,
        "set_draft by permitted user (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $ukawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'set_draft',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'set_draft',
            id                     => $entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: set_draft" );
    ok( $out !~ m!not implemented!i,
        "set_draft by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $seta,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'set_draft',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'set_draft',
            id                     => $entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: set_draft" );
    ok( $out =~ m!permission=1!i, "set_draft by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kagawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'set_draft',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'set_draft',
            id                     => $entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: set_draft" );
    ok( $out =~ m!not implemented!i, "set_draft by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $koishikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'set_draft',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'set_draft',
            id                     => $entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: set_draft" );
    ok( $out =~ m!permission=1!i, "set_draft by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kagawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'set_draft',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'set_draft',
            id                     => $page->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: set_draft" );
    ok( $out =~ m!not implemented!i, "set_draft by type mismatch" );

};

subtest 'action = set_draft (website)' => sub {
    $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $hikita->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'set_draft',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'set_draft',
            id                     => $website_entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: set_draft" );
    ok( $out !~ m!not implemented!i, "set_draft by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $hikita,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'set_draft',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'set_draft',
            id                     => $website_entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: set_draft" );
    ok( $out !~ m!not implemented!i,
        "set_draft by permitted user (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $terada,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'set_draft',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'set_draft',
            id                     => $website_entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: set_draft" );
    ok( $out !~ m!not implemented!i,
        "set_draft by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $fukuda,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'set_draft',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'set_draft',
            id                     => $website_entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: set_draft" );
    ok( $out =~ m!permission=1!i, "set_draft by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $nukita,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'set_draft',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'set_draft',
            id                     => $website_entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: set_draft" );
    ok( $out =~ m!not implemented!i, "set_draft by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $nonoda,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'set_draft',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'set_draft',
            id                     => $website_entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: set_draft" );
    ok( $out =~ m!permission=1!i, "set_draft by other website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $ukawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'set_draft',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'set_draft',
            id                     => $website_entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: set_draft" );
    ok( $out !~ m!not implemented!i, "set_draft by child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $hakamada,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'set_draft',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'set_draft',
            id                     => $website_entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: set_draft" );
    ok( $out =~ m!permission=1!i, "set_draft by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $negishi,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'set_draft',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'set_draft',
            id                     => $website_page->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: set_draft" );
    ok( $out =~ m!not implemented!i, "set_draft by type mismatch" );

};

subtest 'action = add_tags' => sub {
    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ichikawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'add_tags',
            id                     => $entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: add_tags" );
    ok( $out !~ m!not implemented!i, "add_tags by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $ichikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'add_tags',
            id                     => $entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out !~ m!not implemented!i,
        "add_tags by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $ukawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'add_tags',
            id                     => $entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out !~ m!not implemented!i,
        "add_tags by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $ogawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'add_tags',
            id                     => $entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: add_tags" );
    ok( $out =~ m!permission=1!i, "add_tags by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kagawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'add_tags',
            id                     => $entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: add_tags" );
    ok( $out =~ m!not implemented!i, "add_tags by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $koishikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'add_tags',
            id                     => $entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: add_tags" );
    ok( $out =~ m!permission=1!i, "add_tags by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kagawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'add_tags',
            id                     => $page->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: add_tags" );
    ok( $out =~ m!not implemented!i, "add_tags by type mismatch" );

};

subtest 'action = add_tags (website)' => sub {
    $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $tsuneta->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'add_tags',
            id                     => $website_entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: add_tags" );
    ok( $out !~ m!not implemented!i, "add_tags by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $tsuneta,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'add_tags',
            id                     => $website_entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out !~ m!not implemented!i,
        "add_tags by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $terada,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'add_tags',
            id                     => $website_entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out !~ m!not implemented!i,
        "add_tags by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $nishioka,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'add_tags',
            id                     => $website_entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: add_tags" );
    ok( $out =~ m!permission=1!i, "add_tags by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $nukita,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'add_tags',
            id                     => $website_entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: add_tags" );
    ok( $out =~ m!not implemented!i, "add_tags by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $nonoda,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'add_tags',
            id                     => $website_entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: add_tags" );
    ok( $out =~ m!permission=1!i, "add_tags by other website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $ukawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'add_tags',
            id                     => $website_entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: add_tags" );
    ok( $out !~ m!not implemented!i, "add_tags by child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $hakamada,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'add_tags',
            id                     => $website_entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: add_tags" );
    ok( $out =~ m!permission=1!i, "add_tags by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $negishi,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'add_tags',
            id                     => $website_page->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: add_tags" );
    ok( $out =~ m!not implemented!i, "add_tags by type mismatch" );

};

subtest 'action = remove_tags' => sub {
    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ichikawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'remove_tags',
            id                     => $entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: remove_tags" );
    ok( $out !~ m!not implemented!i, "remove_tags by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $ichikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'remove_tags',
            id                     => $entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out !~ m!not implemented!i,
        "remove_tags by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $ukawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'remove_tags',
            id                     => $entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out !~ m!not implemented!i,
        "remove_tags by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $ogawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'remove_tags',
            id                     => $entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: remove_tags" );
    ok( $out =~ m!permission=1!i, "remove_tags by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kagawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'remove_tags',
            id                     => $entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: remove_tags" );
    ok( $out =~ m!not implemented!i, "remove_tags by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $koishikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'remove_tags',
            id                     => $entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: remove_tags" );
    ok( $out =~ m!permission=1!i, "remove_tags by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kagawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'remove_tags',
            id                     => $page->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: remove_tags" );
    ok( $out =~ m!not implemented!i, "remove_tags by type mismatch" );

};

subtest 'action = remove_tags (website)' => sub {
    $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $tsuneta->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'remove_tags',
            id                     => $website_entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: remove_tags" );
    ok( $out !~ m!not implemented!i, "remove_tags by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $tsuneta,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'remove_tags',
            id                     => $website_entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out !~ m!not implemented!i,
        "remove_tags by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $terada,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'remove_tags',
            id                     => $website_entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out !~ m!not implemented!i,
        "remove_tags by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $nishioka,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'remove_tags',
            id                     => $website_entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: remove_tags" );
    ok( $out =~ m!permission=1!i, "remove_tags by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $nukita,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'remove_tags',
            id                     => $website_entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: remove_tags" );
    ok( $out =~ m!not implemented!i, "remove_tags by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $nonoda,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'remove_tags',
            id                     => $website_entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: remove_tags" );
    ok( $out =~ m!permission=1!i, "remove_tags by other website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $ukawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'remove_tags',
            id                     => $website_entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: remove_tags" );
    ok( $out !~ m!not implemented!i, "remove_tags by child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $hakamada,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'remove_tags',
            id                     => $website_entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: remove_tags" );
    ok( $out =~ m!permission=1!i, "remove_tags by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $negishi,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'remove_tags',
            id                     => $website_page->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: remove_tags" );
    ok( $out =~ m!not implemented!i, "remove_tags by type mismatch" );

};

subtest 'action = open_batch_editor' => sub {
    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ichikawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'open_batch_editor',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'open_batch_editor',
            id                     => $entry->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: open_batch_editor" );
    ok( $out !~ m!not implemented!i, "open_batch_editor by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $ukawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'open_batch_editor',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'open_batch_editor',
            id                     => $entry->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: open_batch_editor" );
    ok( $out !~ m!not implemented!i,
        "open_batch_editor by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kagawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'open_batch_editor',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'open_batch_editor',
            id                     => $entry->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: open_batch_editor" );
    ok( $out =~ m!not implemented!i,
        "open_batch_editor by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $koishikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'open_batch_editor',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'open_batch_editor',
            id                     => $entry->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: open_batch_editor" );
    ok( $out =~ m!permission=1!i, "open_batch_editor by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kagawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'open_batch_editor',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $blog->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $blog->id,
            plugin_action_selector => 'open_batch_editor',
            id                     => $page->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: open_batch_editor" );
    ok( $out =~ m!not implemented!i, "open_batch_editor by type mismatch" );

};

subtest 'action = open_batch_editor (website)' => sub {
    $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $tsuneta->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'open_batch_editor',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'open_batch_editor',
            id                     => $website_entry->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: open_batch_editor" );
    ok( $out !~ m!not implemented!i, "open_batch_editor by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $terada,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'open_batch_editor',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'open_batch_editor',
            id                     => $website_entry->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: open_batch_editor" );
    ok( $out !~ m!not implemented!i,
        "open_batch_editor by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $nukita,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'open_batch_editor',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'open_batch_editor',
            id                     => $website_entry->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: open_batch_editor" );
    ok( $out =~ m!not implemented!i,
        "open_batch_editor by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $nonoda,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'open_batch_editor',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'open_batch_editor',
            id                     => $website_entry->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: open_batch_editor" );
    ok( $out =~ m!permission=1!i, "open_batch_editor by other website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $ukawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'open_batch_editor',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'open_batch_editor',
            id                     => $website_entry->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: open_batch_editor" );
    ok( $out !~ m!not implemented!i, "open_batch_editor by child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $hakamada,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'open_batch_editor',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'open_batch_editor',
            id                     => $website_entry->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: open_batch_editor" );
    ok( $out =~ m!permission=1!i, "open_batch_editor by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $negishi,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'entry',
            action_name          => 'open_batch_editor',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_entry%26blog_id%3D'
                . $website->id
                . '%26filter_key%3Dmy_posts_on_this_context',
            blog_id                => $website->id,
            plugin_action_selector => 'open_batch_editor',
            id                     => $website_page->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: open_batch_editor" );
    ok( $out =~ m!not implemented!i, "open_batch_editor by type mismatch" );

};

subtest 'mode = save_entry_prefs (entry)' => sub {
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
    ok( $out, "Request: save_entry_prefs" );
    ok( $out !~ m!permission=1!i,
        "save_entry_prefs by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save_entry_prefs',
            _type            => 'entry',
            blog_id          => $blog->id,
            entry_prefs      => 'Custom',
            custom_prefs =>
                'title,text,keywords,tags,category,feedback,assets',
            sort_only => 'false',
        },
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entry_prefs" );
    ok( $out !~ m!permission=1!i,
        "save_entry_prefs by permitted user (create_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save_entry_prefs',
            _type            => 'entry',
            blog_id          => $blog->id,
            entry_prefs      => 'Custom',
            custom_prefs =>
                'title,text,keywords,tags,category,feedback,assets',
            sort_only => 'false',
        },
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entry_prefs" );
    ok( $out !~ m!permission=1!i,
        "save_entry_prefs by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'save_entry_prefs',
            _type            => 'entry',
            blog_id          => $blog->id,
            entry_prefs      => 'Custom',
            custom_prefs =>
                'title,text,keywords,tags,category,feedback,assets',
            sort_only => 'false',
        },
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entry_prefs" );
    ok( $out =~ m!permission=1!i,
        "save_entry_prefs by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'save_entry_prefs',
            _type            => 'entry',
            blog_id          => $blog->id,
            entry_prefs      => 'Custom',
            custom_prefs =>
                'title,text,keywords,tags,category,feedback,assets',
            sort_only => 'false',
        },
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_entry_prefs" );
    ok( $out =~ m!permission=1!i,
        "save_entry_prefs by other blog" );
};

done_testing();
