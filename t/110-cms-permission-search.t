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

my $komiya = MT::Test::Permission->make_author(
    name => 'komiya',
    nickname => 'Goro Komiya',
);

my $sagawa = MT::Test::Permission->make_author(
    name => 'sagawa',
    nickname => 'Ichiro Sagawa',
);


my $shiki = MT::Test::Permission->make_author(
    name => 'shiki',
    nickname => 'Jiro Shiki',
);

my $suda = MT::Test::Permission->make_author(
    name => 'suda',
    nickname => 'Saburo Suda',
);

my $segawa = MT::Test::Permission->make_author(
    name => 'segawa',
    nickname => 'Shiro Segawa',
);

my $sone = MT::Test::Permission->make_author(
    name => 'sone',
    nickname => 'Goro Sone',
);

my $tachikawa = MT::Test::Permission->make_author(
    name => 'tachikawa',
    nickname => 'Ichiro Tachikawa',
);

my $tsuda = MT::Test::Permission->make_author(
    name => 'tsuda',
    nickname => 'Saburo Tsuda',
);

my $terakawa = MT::Test::Permission->make_author(
    name => 'terakawa',
    nickname => 'Shiro Terakawa',
);

my $toda = MT::Test::Permission->make_author(
    name => 'toda',
    nickname => 'Goro Toda',
);

my $nagayama = MT::Test::Permission->make_author(
    name => 'nagayama',
    nickname => 'Ichiro Nagayama',
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
my $manage_feedback = MT::Test::Permission->make_role(
   name  => 'Manage Feedback',
   permissions => "'manage_feedback'",
);
my $edit_templates = MT::Test::Permission->make_role(
   name  => 'Edit Templates',
   permissions => "'edit_templates'",
);
my $edit_assets = MT::Test::Permission->make_role(
   name  => 'Edit Assets',
   permissions => "'edit_assets'",
);
my $view_blog_log = MT::Test::Permission->make_role(
   name  => 'View Blog Log',
   permissions => "'view_blog_log'",
);
my $manage_pages = MT::Test::Permission->make_role(
   name  => 'Manage Pages',
   permissions => "'manage_pages'",
);

my $blog_admin = MT::Role->load({ name => MT->translate('Blog Administrator') });
my $website_admin = MT::Role->load({ name => MT->translate('Website Administrator') });

require MT::Association;
MT::Association->link( $aikawa => $create_post => $blog );
MT::Association->link( $ichikawa => $edit_all_posts => $blog );
MT::Association->link( $ukawa => $manage_feedback => $blog );
MT::Association->link( $egawa => $edit_templates => $blog );
MT::Association->link( $ogawa => $edit_assets => $blog );
MT::Association->link( $kagawa => $view_blog_log => $blog );
MT::Association->link( $kikkawa => $manage_pages => $blog );
MT::Association->link( $kumekawa => $blog_admin => $blog );
MT::Association->link( $kemikawa => $website_admin => $website );

MT::Association->link( $shiki => $create_post => $blog );
MT::Association->link( $suda => $edit_all_posts => $blog );
MT::Association->link( $segawa => $manage_feedback => $blog );
MT::Association->link( $sone => $edit_templates => $blog );
MT::Association->link( $tachikawa => $edit_assets => $blog );
MT::Association->link( $tsuda => $view_blog_log => $blog );
MT::Association->link( $terakawa => $manage_pages => $blog );
MT::Association->link( $toda => $blog_admin => $blog );
MT::Association->link( $nagayama => $website_admin => $website );


require MT::Permission;
my $p = MT::Permission->new;
$p->blog_id( 0);
$p->author_id( $komiya->id );
$p->permissions( "'edit_templates'" );
$p->save;

$p = MT::Permission->new;
$p->blog_id( 0);
$p->author_id( $sagawa->id );
$p->permissions( "'view_log'" );
$p->save;

# Run
my ( $app, $out );

subtest 'search: entry' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'entry',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:entry" );
    ok( $out !~ m!permission=1!i, "search:entry by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'entry',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:entry" );
    ok( $out !~ m!permission=1!i, "search:entry by permitted user (create post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'entry',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:entry" );
    ok( $out !~ m!permission=1!i, "search:entry by permitted user (edit all posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $shiki,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'entry',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:entry" );
    ok( $out =~ m!permission=1!i, "search:entry by other blog (create post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $suda,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'entry',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:entry" );
    ok( $out =~ m!permission=1!i, "search:entry by other blog (edit all posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'entry',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:entry" );
    ok( $out =~ m!No permissions!i, "search:entry by other permission" );
};

subtest 'search: comment' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'comment',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:comment" );
    ok( $out !~ m!permission=1!i, "search:comment by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'comment',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:comment" );
    ok( $out !~ m!permission=1!i, "search:comment by permitted user (create post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'comment',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:comment" );
    ok( $out !~ m!permission=1!i, "search:comment by permitted user (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'comment',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:comment" );
    ok( $out !~ m!permission=1!i, "search:comment by permitted user (manage pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $shiki,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'comment',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:comment" );
    ok( $out =~ m!permission=1!i, "search:comment by other blog (create post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $segawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'comment',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:comment" );
    ok( $out =~ m!permission=1!i, "search:comment by other blog (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $terakawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'comment',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:comment" );
    ok( $out =~ m!permission=1!i, "search:comment by other blog (manage pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'comment',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:comment" );
    ok( $out =~ m!No permissions!i, "search:comment by other permission" );
};

subtest 'search: ping' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'ping',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:ping" );
    ok( $out !~ m!permission=1!i, "search:ping by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'ping',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:ping" );
    ok( $out !~ m!permission=1!i, "search:ping by permitted user (create post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'ping',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:ping" );
    ok( $out !~ m!permission=1!i, "search:ping by permitted user (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'ping',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:ping" );
    ok( $out !~ m!permission=1!i, "search:ping by permitted user (manage pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $shiki,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'ping',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:ping" );
    ok( $out =~ m!permission=1!i, "search:ping by other blog (create post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $segawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'ping',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:ping" );
    ok( $out =~ m!permission=1!i, "search:ping by other blog (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $terakawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'ping',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:ping" );
    ok( $out =~ m!permission=1!i, "search:ping by other blog (manage pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'ping',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:ping" );
    ok( $out =~ m!No permissions!i, "search:ping by other permission" );
};

subtest 'search: template' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'template',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:template" );
    ok( $out !~ m!permission=1!i, "search:template by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'template',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:template" );
    ok( $out !~ m!permission=1!i, "search:template by permitted user (local)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $komiya,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'template',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:template" );
    ok( $out !~ m!permission=1!i, "search:template by permitted user (system)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sone,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'template',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:template" );
    ok( $out =~ m!permission=1!i, "search:template by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'template',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:template" );
    ok( $out =~ m!No permissions!i, "search:template by other permission" );
};

subtest 'search: asset' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'asset',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:asset" );
    ok( $out !~ m!permission=1!i, "search:asset by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'asset',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:asset" );
    ok( $out !~ m!permission=1!i, "search:asset by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tachikawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'asset',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:asset" );
    ok( $out =~ m!permission=1!i, "search:asset by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'asset',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:asset" );
    ok( $out =~ m!No permissions!i, "search:asset by other permission" );
};

subtest 'search: log' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'log',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:log" );
    ok( $out !~ m!permission=1!i, "search:log by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'log',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:log" );
    ok( $out !~ m!permission=1!i, "search:log by permitted user (local)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sagawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'log',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:log" );
    ok( $out !~ m!permission=1!i, "search:log by permitted user (system)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuda,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'log',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:log" );
    ok( $out =~ m!permission=1!i, "search:log by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'log',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:log" );
    ok( $out =~ m!No permissions!i, "search:log by other permission" );
};

subtest 'search: author' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'author',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:author" );
    ok( $out !~ m!permission=1!i, "search:author by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'author',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:author" );
    ok( $out =~ m!No permissions!i, "search:author by other permission" );
};

subtest 'search: blog' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'blog',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:blog" );
    ok( $out !~ m!permission=1!i, "search:blog by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'blog',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:blog" );
    ok( $out !~ m!permission=1!i, "search:blog by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $toda,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'blog',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:blog" );
    ok( $out =~ m!permission=1!i, "search:blog by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'blog',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:blog" );
    ok( $out =~ m!No permissions!i, "search:blog by other permission" );
};

subtest 'search: website' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'website',
            limit            => 10,
            website_id          => $website->id,
            return_args      => '__mode%3Dsearch_replace%26website_id%3D'.$website->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:website" );
    ok( $out !~ m!permission=1!i, "search:website by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemikawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'website',
            limit            => 10,
            website_id          => $website->id,
            return_args      => '__mode%3Dsearch_replace%26website_id%3D'.$website->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:website" );
    ok( $out !~ m!permission=1!i, "search:website by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $nagayama,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'website',
            limit            => 10,
            website_id          => $website->id,
            return_args      => '__mode%3Dsearch_replace%26website_id%3D'.$website->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:website" );
    ok( $out =~ m!permission=1!i, "search:website by other website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'website',
            limit            => 10,
            website_id          => $website->id,
            return_args      => '__mode%3Dsearch_replace%26website_id%3D'.$website->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:website" );
    ok( $out =~ m!No permissions!i, "search:website by other permission" );
};

subtest 'search: page' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'page',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:page" );
    ok( $out !~ m!permission=1!i, "search:page by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'page',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:page" );
    ok( $out !~ m!permission=1!i, "search:page by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $terakawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'page',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:page" );
    ok( $out =~ m!permission=1!i, "search:page by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'search_replace',
            _type            => 'page',
            limit            => 10,
            blog_id          => $blog->id,
            return_args      => '__mode%3Dsearch_replace%26blog_id%3D'.$blog->id,
            do_search        => 1,
            search           => 'aaa',
            'dates-disabled' => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: search:page" );
    ok( $out =~ m!No permissions!i, "search:page by other permission" );
};

done_testing();
