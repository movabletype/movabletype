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

my $edit_templates = MT::Test::Permission->make_role(
   name  => 'Edit Templates',
   permissions => "'edit_templates'",
);

my $designer = MT::Role->load( { name => MT->translate( 'Designer' ) } );

require MT::Association;
MT::Association->link( $aikawa => $create_post => $blog );
MT::Association->link( $ichikawa => $edit_all_posts => $blog );
MT::Association->link( $ukawa => $manage_pages => $blog );
MT::Association->link( $egawa => $edit_templates => $blog );
MT::Association->link( $koishikawa => $create_post => $blog );
MT::Association->link( $sagawa => $designer => $blog );

MT::Association->link( $ogawa => $create_post => $second_blog );
MT::Association->link( $kagawa => $edit_all_posts => $second_blog );
MT::Association->link( $kikkawa => $manage_pages => $second_blog );
MT::Association->link( $kumekawa => $edit_templates => $second_blog );

# Assign system privilege.
require MT::Permission;
my $p = MT::Permission->new;
$p->blog_id( 0 );
$p->author_id( $kemikawa->id );
$p->permissions( "'edit_templates'" );
$p->save;

# Entry
my $entry = MT::Test::Permission->make_entry(
    blog_id        => $blog->id,
    author_id      => $aikawa->id,
);

# Template
my $tmpl = MT::Test::Permission->make_template(
    blog_id        => $blog->id,
    name           => 'Test Template',
);

# Template
my $sys_tmpl = MT::Test::Permission->make_template(
    blog_id        => 0,
    name           => 'Test System Template',
);

# Page
my $page = MT::Test::Permission->make_page(
    blog_id        => $blog->id,
    author_id      => $ukawa->id,
);


# Run
my ( $app, $out );

subtest 'mode = list_revision' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list_revision',
            blog_id          => $blog->id,
            _type            => 'entry',
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_revision" );
    ok( $out !~ m!permission=1!i, "list_revision by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list_revision',
            blog_id          => $blog->id,
            _type            => 'entry',
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_revision" );
    ok( $out !~ m!permission=1!i, "list_revision by permitted user (create post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'list_revision',
            blog_id          => $blog->id,
            _type            => 'entry',
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_revision" );
    ok( $out !~ m!permission=1!i, "list_revision by permitted user (edit all posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'list_revision',
            blog_id          => $blog->id,
            _type            => 'page',
            id               => $page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_revision" );
    ok( $out !~ m!permission=1!i, "list_revision by permitted user (manage_page)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'list_revision',
            blog_id          => $blog->id,
            _type            => 'template',
            id               => $tmpl->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_revision" );
    ok( $out !~ m!permission=1!i, "list_revision by permitted user (edit_templates)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemikawa,
            __request_method => 'POST',
            __mode           => 'list_revision',
            blog_id          => $blog->id,
            _type            => 'template',
            id               => $tmpl->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_revision" );
    ok( $out !~ m!permission=1!i, "list_revision by permitted user ( system:edit_templates)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemikawa,
            __request_method => 'POST',
            __mode           => 'list_revision',
            blog_id          => 0,
            _type            => 'template',
            id               => $sys_tmpl->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_revision" );
    ok( $out !~ m!permission=1!i, "list_revision by permitted user ( system:edit_templates: system)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'list_revision',
            blog_id          => $blog->id,
            _type            => 'entry',
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_revision" );
    ok( $out =~ m!permission=1!i, "list_revision by other blog (create post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'list_revision',
            blog_id          => $blog->id,
            _type            => 'entry',
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_revision" );
    ok( $out =~ m!permission=1!i, "list_revision by other blog (edit all posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'list_revision',
            blog_id          => $blog->id,
            _type            => 'page',
            id               => $page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_revision" );
    ok( $out =~ m!permission=1!i, "list_revision by other blog (manage_page)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'list_revision',
            blog_id          => $blog->id,
            _type            => 'template',
            id               => $tmpl->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_revision" );
    ok( $out =~ m!permission=1!i, "list_revision by other blog (edit_templates)" );

     $app = _run_app(
         'MT::App::CMS',
         {   __test_user      => $egawa,
             __request_method => 'POST',
             __mode           => 'list_revision',
             blog_id          => 0,
             _type            => 'template',
             id               => $sys_tmpl->id,
         }
     );
     $out = delete $app->{__test_output};
     ok( $out, "Request: list_revision" );
     ok( $out =~ m!permission=1!i, "list_revision on system template (edit_templates)" );

     $app = _run_app(
         'MT::App::CMS',
         {   __test_user      => $koishikawa,
             __request_method => 'POST',
             __mode           => 'list_revision',
             blog_id          => $blog->id,
             _type            => 'entry',
             id               => $entry->id,
         }
     );
     $out = delete $app->{__test_output};
     ok( $out, "Request: list_revision" );
     ok( $out =~ m!permission=1!i, "list_revision by other user (create post)" );

     $app = _run_app(
         'MT::App::CMS',
         {   __test_user      => $aikawa,
             __request_method => 'POST',
             __mode           => 'list_revision',
             blog_id          => $blog->id,
             _type            => 'entry',
             id               => $page->id,
         }
     );
     $out = delete $app->{__test_output};
     ok( $out, "Request: list_revision" );
     ok( $out =~ m!permission=1!i, "list_revision by class mismatch (create post)" );

     $app = _run_app(
         'MT::App::CMS',
         {   __test_user      => $ukawa,
             __request_method => 'POST',
             __mode           => 'list_revision',
             blog_id          => $blog->id,
             _type            => 'page',
             id               => $entry->id,
         }
     );
     $out = delete $app->{__test_output};
     ok( $out, "Request: list_revision" );
     ok( $out =~ m!permission=1!i, "list_revision by class mismatch (manage_pages)" );


     $app = _run_app(
         'MT::App::CMS',
         {   __test_user      => $sagawa,
             __request_method => 'POST',
             __mode           => 'list_revision',
             blog_id          => $blog->id,
             _type            => 'entry',
             id               => $entry->id,
         }
     );
     $out = delete $app->{__test_output};
     ok( $out, "Request: list_revision" );
     ok( $out =~ m!permission=1!i, "list_revision by other permission" );
 };

 done_testing();
