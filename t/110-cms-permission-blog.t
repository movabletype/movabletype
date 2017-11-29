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
my $website        = MT::Test::Permission->make_website();
my $second_website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );
my $second_blog
    = MT::Test::Permission->make_blog( parent_id => $website->id, );
my $third_blog
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
    nickname => 'Goro ogawa',
);

my $kagawa = MT::Test::Permission->make_author(
    name     => 'kagawa',
    nickname => 'Ichiro kagawa',
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

my $shiki = MT::Test::Permission->make_author(
    name     => 'shiki',
    nickname => 'Jiro Shiki',
);

my $suda = MT::Test::Permission->make_author(
    name     => 'suda',
    nickname => 'Saburo Suda',
);

my $seta = MT::Test::Permission->make_author(
    name     => 'seta',
    nickname => 'Shiro Seta',
);

my $soneda = MT::Test::Permission->make_author(
    name     => 'soneda',
    nickname => 'Goro Soneda',
);

my $taneda = MT::Test::Permission->make_author(
    name     => 'taneda',
    nickname => 'Ichiro Taneda',
);

my $tsuda = MT::Test::Permission->make_author(
    name     => 'tsuda',
    nickname => 'Saburo Tsuda',
);

my $tezuka = MT::Test::Permission->make_author(
    name     => 'tezuka',
    nickname => 'Shiro Tezuka',
);

my $toda = MT::Test::Permission->make_author(
    name     => 'toda',
    nickname => 'Goro Toda',
);

my $namegawa = MT::Test::Permission->make_author(
    name     => 'namegawa',
    nickname => 'Ichiro Namegawa',
);

my $niyagawa = MT::Test::Permission->make_author(
    name     => 'niyagawa',
    nickname => 'Jiro Niyagawa',
);

my $nunota = MT::Test::Permission->make_author(
    name     => 'nunota',
    nickname => 'Saburo Nunota',
);

my $negoro = MT::Test::Permission->make_author(
    name     => 'negoro',
    nickname => 'Shiro Negoro',
);

my $noda = MT::Test::Permission->make_author(
    name     => 'noda',
    nickname => 'Goro Noda',
);

my $hada = MT::Test::Permission->make_author(
    name     => 'hada',
    nickname => 'Ichiro Hada',
);
my $hida = MT::Test::Permission->make_author(
    name     => 'hida',
    nickname => 'Jiro Hida',
);

my $admin = MT::Author->load(1);

# Role
require MT::Role;
my $blog_admin
    = MT::Role->load( { name => MT->translate('Blog Administrator') } );
my $website_admin
    = MT::Role->load( { name => MT->translate('Website Administrator') } );
my $designer = MT::Role->load( { name => MT->translate('Designer') } );

my $create_post = MT::Test::Permission->make_role(
    name        => 'Create Post',
    permissions => "'create_post'",
);

my $manage_pages = MT::Test::Permission->make_role(
    name        => 'Manage Pages',
    permissions => "'manage_pages'",
);

my $rebuild = MT::Test::Permission->make_role(
    name        => 'Rebuild',
    permissions => "'rebuild'",
);

my $edit_config = MT::Test::Permission->make_role(
    name        => 'Edit Config',
    permissions => "'edit_config'",
);

my $edit_all_posts = MT::Test::Permission->make_role(
    name        => 'Edit All Posts',
    permissions => "'edit_all_posts'",
);

my $publish_post = MT::Test::Permission->make_role(
    name        => 'Publish Post',
    permissions => "'publish_post'",
);

my $manage_feedback = MT::Test::Permission->make_role(
    name        => 'Manage Feedback',
    permissions => "'manage_feedback'",
);
my $edit_templates = MT::Test::Permission->make_role(
    name        => 'Edit Templates',
    permissions => "'edit_templates'",
);

require MT::Association;
MT::Association->link( $aikawa   => $blog_admin      => $blog );
MT::Association->link( $ichikawa => $edit_templates  => $blog );
MT::Association->link( $ukawa    => $manage_pages    => $blog );
MT::Association->link( $egawa    => $rebuild         => $blog );
MT::Association->link( $ogawa    => $edit_config     => $blog );
MT::Association->link( $kagawa   => $edit_all_posts  => $blog );
MT::Association->link( $kikkawa  => $publish_post    => $blog );
MT::Association->link( $kumekawa => $manage_feedback => $blog );
MT::Association->link( $tezuka   => $edit_templates  => $blog );
MT::Association->link( $noda     => $blog_admin      => $blog );
MT::Association->link( $hada     => $blog_admin      => $blog );
MT::Association->link( $hida     => $blog_admin      => $blog );

MT::Association->link( $kemikawa   => $blog_admin      => $second_blog );
MT::Association->link( $koishikawa => $designer        => $second_blog );
MT::Association->link( $sagawa     => $manage_pages    => $second_blog );
MT::Association->link( $shiki      => $rebuild         => $second_blog );
MT::Association->link( $suda       => $edit_config     => $second_blog );
MT::Association->link( $seta       => $edit_all_posts  => $second_blog );
MT::Association->link( $soneda     => $publish_post    => $second_blog );
MT::Association->link( $taneda     => $manage_feedback => $second_blog );
MT::Association->link( $toda       => $edit_templates  => $second_blog );
MT::Association->link( $noda       => $blog_admin      => $second_blog );

MT::Association->link( $niyagawa => $website_admin  => $website );
MT::Association->link( $noda     => $edit_all_posts => $website );
MT::Association->link( $nunota   => $website_admin  => $second_website );

MT::Association->link( $kemikawa   => $create_post => $blog );
MT::Association->link( $koishikawa => $create_post => $blog );
MT::Association->link( $sagawa     => $create_post => $blog );
MT::Association->link( $shiki      => $create_post => $blog );
MT::Association->link( $suda       => $create_post => $blog );
MT::Association->link( $seta       => $create_post => $blog );
MT::Association->link( $soneda     => $create_post => $blog );
MT::Association->link( $taneda     => $create_post => $blog );
MT::Association->link( $toda       => $create_post => $blog );

MT::Association->link( $negoro => $create_post => $blog );

require MT::Permission;
my $p = MT::Permission->new;
$p->blog_id(0);
$p->author_id( $tsuda->id );
$p->permissions("'create_blog'");
$p->save;

$p = MT::Permission->new;
$p->blog_id(0);
$p->author_id( $namegawa->id );
$p->permissions("'edit_templates'");
$p->save;

$p = MT::Permission->new;
$p->blog_id(0);
$p->author_id( $hada->id );
$p->permissions("'edit_templates'");
$p->save;

$p = MT::Permission->new;
$p->blog_id(0);
$p->author_id( $hida->id );
$p->save;

# Entry
my $entry = MT::Test::Permission->make_entry(
    blog_id   => $blog->id,
    author_id => $kikkawa->id,
);

# Page
my $page = MT::Test::Permission->make_page(
    blog_id   => $blog->id,
    author_id => $ukawa->id,
);

# Template
my $tmpl
    = MT::Test::Permission->make_template( blog_id => $second_blog->id, );

# Run
my ( $app, $out );

subtest 'mode = cc_return' => sub {
    plan skip_all => 'https://movabletype.fogbugz.com/default.asp?106622';

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'cc_return',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cc_return" );
    ok( $out !~ m!permission=1!i, "cc_return by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'cc_return',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cc_return" );
    ok( $out !~ m!permission=1!i, "cc_return by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $suda,
            __request_method => 'POST',
            __mode           => 'cc_return',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cc_return" );
    ok( $out =~ m!permission=1!i, "cc_return by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'cc_return',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cc_return" );
    ok( $out =~ m!permission=1!i, "cc_return by other permission" );
    done_testing();
};

subtest 'mode = cfg_feedback' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'cfg_feedback',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_feedback" );
    ok( $out !~ m!permission=1!i, "cfg_feedback by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'cfg_feedback',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_feedback" );
    ok( $out !~ m!permission=1!i, "cfg_feedback by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $suda,
            __request_method => 'POST',
            __mode           => 'cfg_feedback',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_feedback" );
    ok( $out =~ m!permission=1!i, "cfg_feedback by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'cfg_feedback',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_feedback" );
    ok( $out =~ m!permission=1!i, "cfg_feedback by other permission" );
    done_testing();
};

subtest 'mode = cfg_prefs' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'cfg_prefs',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_prefs" );
    ok( $out !~ m!permission=1!i, "cfg_prefs by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'cfg_prefs',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_prefs" );
    ok( $out !~ m!permission=1!i, "cfg_prefs by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $suda,
            __request_method => 'POST',
            __mode           => 'cfg_prefs',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_prefs" );
    ok( $out =~ m!permission=1!i, "cfg_prefs by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'cfg_prefs',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_prefs" );
    ok( $out =~ m!permission=1!i, "cfg_prefs by other permission" );
    done_testing();
};

subtest 'mode = cfg_registration' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'cfg_registration',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_registration" );
    ok( $out !~ m!permission=1!i, "cfg_registration by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'cfg_registration',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_registration" );
    ok( $out !~ m!permission=1!i, "cfg_registration by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $suda,
            __request_method => 'POST',
            __mode           => 'cfg_registration',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_registration" );
    ok( $out =~ m!permission=1!i, "cfg_registration by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'cfg_registration',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_registration" );
    ok( $out =~ m!permission=1!i, "cfg_registration by other permission" );
    done_testing();
};

subtest 'mode = cfg_web_services' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'cfg_web_services',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_web_services" );
    ok( $out !~ m!permission=1!i, "cfg_web_services by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'cfg_web_services',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_web_services" );
    ok( $out !~ m!permission=1!i, "cfg_web_services by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $suda,
            __request_method => 'POST',
            __mode           => 'cfg_web_services',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_web_services" );
    ok( $out =~ m!permission=1!i, "cfg_web_services by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'cfg_web_services',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_web_services" );
    ok( $out =~ m!permission=1!i, "cfg_web_services by other permission" );
    done_testing();
};

subtest 'mode = dialog_clone_blog' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'dialog_clone_blog',
            blog_id          => $blog->id,
            id               => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: dialog_clone_blog" );
    ok( $out !~ m!permission=1!i, "dialog_clone_blog by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'dialog_clone_blog',
            blog_id          => $blog->id,
            id               => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: dialog_clone_blog" );
    ok( $out =~ m!permission=1!i, "dialog_clone_blog by blog admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $suda,
            __request_method => 'POST',
            __mode           => 'dialog_clone_blog',
            blog_id          => $blog->id,
            id               => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: dialog_clone_blog" );
    ok( $out =~ m!permission=1!i, "dialog_clone_blog by other blog" );
    done_testing();
};

subtest 'mode = list' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $website->id,
            _type            => 'blog',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                   "Request: list" );
    ok( $out !~ m!redirect=1!i, "list by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $negoro,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $second_website->id,
            _type            => 'blog',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out =~ m!permission=1!i, "list by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $website->id,
            _type            => 'blog',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                   "Request: list" );
    ok( $out !~ m!redirect=1!i, "list by permitted user" );

    foreach my $blog_id ( $website->id, 0 ) {
        note 'blog_id: ' . $blog_id;

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $noda,
                __request_method => 'POST',
                __mode           => 'list',
                blog_id          => $blog_id,
                _type            => 'blog',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: list" );
        ok( $out !~ m!redirect=1!i,
            "list by permitted user who is not parent website administrator"
        );
        my $button = quotemeta '<a href="#delete" class="button">Delete</a>';
        like( $out, qr/$button/, 'There is "Delete" button.' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $hada,
                __request_method => 'POST',
                __mode           => 'list',
                blog_id          => $blog_id,
                _type            => 'blog',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                   "Request: list" );
        ok( $out !~ m!redirect=1!i, "list by not permitted user" );
        unlike( $out, qr/$button/, 'There is not "Delete" button.' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $hida,
                __request_method => 'POST',
                __mode           => 'list',
                blog_id          => $blog_id,
                _type            => 'blog',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                   "Request: list" );
        ok( $out !~ m!redirect=1!i, "list by permitted user" );
        like( $out, qr/$button/, 'There is "Delete" button.' );
        my $refresh_tmpl = quotemeta
            '<option value="refresh_blog_templates">Refresh Template(s)</option>';
        like( $out, qr/$refresh_tmpl/,
            'There is "Refresh Template(s)" action.' );

    }

    done_testing();
};

subtest 'mode = rebuild_confirm' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'rebuild_confirm',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: rebuild_confirm" );
    ok( $out !~ m!permission=1!i, "rebuild_confirm by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'rebuild_confirm',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: rebuild_confirm" );
    ok( $out !~ m!permission=1!i, "rebuild_confirm by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $shiki,
            __request_method => 'POST',
            __mode           => 'rebuild_confirm',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: rebuild_confirm" );
    ok( $out =~ m!permission=1!i, "rebuild_confirm by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemikawa,
            __request_method => 'POST',
            __mode           => 'rebuild_confirm',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: rebuild_confirm" );
    ok( $out =~ m!permission=1!i, "rebuild_confirm by other permission" );

};

subtest 'mode = rebuild_new_phase' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'rebuild_new_phase',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: rebuild_new_phase" );
    ok( $out !~ m!permission=1!i, "rebuild_new_phase by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'rebuild_new_phase',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: rebuild_new_phase" );
    ok( $out !~ m!permission=1!i,
        "rebuild_new_phase by permitted user (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'rebuild_new_phase',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: rebuild_new_phase" );
    ok( $out !~ m!permission=1!i,
        "rebuild_new_phase by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'rebuild_new_phase',
            blog_id          => $blog->id,
            id               => $page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: rebuild_new_phase" );
    ok( $out !~ m!permission=1!i,
        "rebuild_new_phase by permitted user (manage pages)" );

    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $seta,
            __request_method => 'POST',
            __mode           => 'rebuild_new_phase',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: rebuild_new_phase" );
    ok( $out =~ m!permission=1!i,
        "rebuild_new_phase by other blog (edit_all_posts)" );

    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $soneda,
            __request_method => 'POST',
            __mode           => 'rebuild_new_phase',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: rebuild_new_phase" );
    ok( $out =~ m!permission=1!i,
        "rebuild_new_phase by other blog (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sagawa,
            __request_method => 'POST',
            __mode           => 'rebuild_new_phase',
            blog_id          => $blog->id,
            id               => $page->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: rebuild_new_phase" );
    ok( $out =~ m!permission=1!i,
        "rebuild_new_phase by other blog (manage pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'rebuild_new_phase',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: rebuild_new_phase" );
    ok( $out =~ m!permission=1!i, "rebuild_new_phase by other permission" );
    done_testing();
};

subtest 'mode = rebuild' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'rebuild',
            blog_id          => $blog->id,
            type             => 'all',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: rebuild" );
    ok( $out !~ m!permission=1!i, "rebuild by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'rebuild',
            blog_id          => $blog->id,
            type             => 'all',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: rebuild" );
    ok( $out !~ m!permission=1!i, "rebuild by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $shiki,
            __request_method => 'POST',
            __mode           => 'rebuild',
            blog_id          => $blog->id,
            type             => 'all',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: rebuild" );
    ok( $out =~ m!permission=1!i, "rebuild by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'rebuild',
            blog_id          => $blog->id,
            type             => 'all',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: rebuild" );
    ok( $out =~ m!permission=1!i, "rebuild by other permission" );
    done_testing();
};

subtest 'mode = rebuild_phase' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'rebuild_phase',
            blog_id          => $blog->id,
            type             => 'entry',
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: rebuild_phase" );
    ok( $out !~ m!permission=1!i, "rebuild_phase by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'rebuild_phase',
            blog_id          => $blog->id,
            type             => 'entry',
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: rebuild_phase" );
    ok( $out !~ m!permission=1!i, "rebuild_phase by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $shiki,
            __request_method => 'POST',
            __mode           => 'rebuild_phase',
            blog_id          => $blog->id,
            type             => 'entry',
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: rebuild_phase" );
    ok( $out =~ m!permission=1!i, "rebuild_phase by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'rebuild_phase',
            blog_id          => $blog->id,
            type             => 'entry',
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: rebuild_phase" );
    ok( $out =~ m!permission=1!i, "rebuild_phase by other permission" );
    done_testing();
};

subtest 'mode = start_rebuild' => sub {
    plan skip_all => 'https://movabletype.fogbugz.com/default.asp?106807';

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'start_rebuild',
            blog_id          => $blog->id,
            type             => 'Individual',
            next             => 'Individual',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_rebuild" );
    ok( $out !~ m!permission=1!i, "start_rebuild by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'start_rebuild',
            blog_id          => $blog->id,
            type             => 'Individual',
            next             => 'Individual',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_rebuild" );
    ok( $out !~ m!permission=1!i,
        "start_rebuild by permitted user (rebuild)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'start_rebuild',
            blog_id          => $blog->id,
            type             => 'Individual',
            next             => 'Individual',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_rebuild" );
    ok( $out !~ m!permission=1!i,
        "start_rebuild by permitted user (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'start_rebuild',
            blog_id          => $blog->id,
            type             => 'Individual',
            next             => 'Individual',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_rebuild" );
    ok( $out !~ m!permission=1!i,
        "start_rebuild by permitted user (manage_pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'start_rebuild',
            blog_id          => $blog->id,
            type             => 'Individual',
            next             => 'Individual',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_rebuild" );
    ok( $out !~ m!permission=1!i,
        "start_rebuild by permitted user (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'start_rebuild',
            blog_id          => $blog->id,
            type             => 'Individual',
            next             => 'Individual',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_rebuild" );
    ok( $out !~ m!permission=1!i,
        "start_rebuild by permitted user (manage_feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'start_rebuild',
            blog_id          => $second_blog->id,
            type             => 'Individual',
            next             => 'Individual',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_rebuild" );
    ok( $out =~ m!permission=1!i, "start_rebuild by other blog (rebuild)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'start_rebuild',
            blog_id          => $second_blog->id,
            type             => 'Individual',
            next             => 'Individual',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_rebuild" );
    ok( $out =~ m!permission=1!i,
        "start_rebuild by other blog (edit_all_posts)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'start_rebuild',
            blog_id          => $second_blog->id,
            type             => 'Individual',
            next             => 'Individual',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_rebuild" );
    ok( $out =~ m!permission=1!i,
        "start_rebuild by other blog (manage_pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'start_rebuild',
            blog_id          => $second_blog->id,
            type             => 'Individual',
            next             => 'Individual',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_rebuild" );
    ok( $out =~ m!permission=1!i,
        "start_rebuild by other blog (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'start_rebuild',
            blog_id          => $second_blog->id,
            type             => 'Individual',
            next             => 'Individual',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_rebuild" );
    ok( $out =~ m!permission=1!i,
        "start_rebuild by other blog (manage_feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'start_rebuild',
            blog_id          => $blog->id,
            type             => 'Individual',
            next             => 'Individual',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_rebuild" );
    ok( $out =~ m!permission=1!i, "start_rebuild by other permission" );
    done_testing();
};

subtest 'mode = update_welcome_message' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'update_welcome_message',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: update_welcome_message" );
    ok( $out !~ m!permission=1!i, "update_welcome_message by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'update_welcome_message',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: update_welcome_message" );
    ok( $out !~ m!permission=1!i,
        "update_welcome_message by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $suda,
            __request_method => 'POST',
            __mode           => 'update_welcome_message',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: update_welcome_message" );
    ok( $out =~ m!permission=1!i, "update_welcome_message by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'update_welcome_message',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: update_welcome_message" );
    ok( $out =~ m!permission=1!i,
        "update_welcome_message by other permission" );
    done_testing();
};

subtest 'mode = save (new)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'blog',
            name             => 'BlogName',
            parent_id        => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save (new) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuda,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'blog',
            name             => 'BlogName',
            parent_id        => $website->id,

        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save (new) by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'blog',
            name             => 'BlogName',
            parent_id        => $website->id,

        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save (new) by blog admin" );
    done_testing();
};

subtest 'mode = save (edit)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'blog',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save (edit) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'blog',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!permission=1!i,
        "save (edit) by permitted user (blog admin)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'blog',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!permission=1!i,
        "save (edit) by permitted user (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuda,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'blog',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!permission=1!i,
        "save (edit) by non permitted user (create blog)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'blog',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save (edit) by other blog (blog admin)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $suda,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'blog',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save (edit) by other blog (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'blog',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save (edit) by other permission" );
    done_testing();
};

subtest 'mode = save (type is site)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'site',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!Invalid request!i, "save (edit) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'site',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid request!i,
        "save (edit) by permitted user (blog admin)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'site',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid request!i,
        "save (edit) by permitted user (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuda,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'site',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid request!i,
        "save (edit) by non permitted user (create blog)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'site',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!Invalid request!i, "save (edit) by other blog (blog admin)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $suda,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'site',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!Invalid request!i, "save (edit) by other blog (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'site',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!Invalid request!i, "save (edit) by other permission" );
    done_testing();
};

subtest 'mode = edit (new)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'blog',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out !~ m!permission=1!i, "edit (new) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuda,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'blog',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out !~ m!permission=1!i, "edit (new) by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'blog',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit (new) by blog admin" );
    done_testing();
};

subtest 'mode = edit (edit)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'blog',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out !~ m!Permission=1!i, "edit (edit) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'blog',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out !~ m!Permission=1!i,
        "edit (edit) by permitted user (blog admin)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'blog',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out !~ m!Permission=1!i,
        "edit (edit) by permitted user (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuda,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'blog',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Permission=1!i,
        "edit (edit) by non permitted user (create blog)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'blog',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!Permission=1!i, "edit (edit) by other blog (blog admin)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $suda,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'blog',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!Permission=1!i, "edit (edit) by other blog (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'blog',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!Permission=1!i, "edit (edit) by other permission" );
    done_testing();
};

subtest 'mode = edit (type is site)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'site',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit (edit) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'site',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid request!i,
        "edit (edit) by permitted user (blog admin)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'site',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid request!i,
        "edit (edit) by permitted user (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuda,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'site',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid request!i,
        "edit (edit) by non permitted user (create blog)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'site',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit (edit) by other blog (blog admin)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $suda,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'site',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit (edit) by other blog (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'site',
            name             => 'BlogName',
            id               => $blog->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit (edit) by other permission" );
    done_testing();
};

subtest 'action = refresh_blog_templates' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'blog',
            action_name          => 'refresh_blog_templates',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_blog%26blog_id%3D' . $website->id,
            plugin_action_selector => 'refresh_blog_templates',
            id                     => $blog->id,
            plugin_action_selector => 'refresh_blog_templates',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: refresh_blog_templates" );
    ok( $out !~ m!not implemented!i, "refresh_blog_templates by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $tezuka,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'blog',
            action_name          => 'refresh_blog_templates',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_blog%26blog_id%3D' . $website->id,
            plugin_action_selector => 'refresh_blog_templates',
            id                     => $blog->id,
            plugin_action_selector => 'refresh_blog_templates',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: refresh_blog_templates" );
    ok( $out !~ m!not implemented!i,
        "refresh_blog_templates by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $namegawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'blog',
            action_name          => 'refresh_blog_templates',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_blog%26blog_id%3D' . $website->id,
            plugin_action_selector => 'refresh_blog_templates',
            id                     => $blog->id,
            plugin_action_selector => 'refresh_blog_templates',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: refresh_blog_templates" );
    ok( $out !~ m!not implemented!i,
        "refresh_blog_templates by permitted user (system)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $toda,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'blog',
            action_name          => 'refresh_blog_templates',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_blog%26blog_id%3D' . $website->id,
            plugin_action_selector => 'refresh_blog_templates',
            id                     => $blog->id,
            plugin_action_selector => 'refresh_blog_templates',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: refresh_blog_templates" );
    ok( $out =~ m!not implemented!i, "refresh_blog_templates by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kumekawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'blog',
            action_name          => 'refresh_blog_templates',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_blog%26blog_id%3D' . $website->id,
            plugin_action_selector => 'refresh_blog_templates',
            id                     => $blog->id,
            plugin_action_selector => 'refresh_blog_templates',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: refresh_blog_templates" );
    ok( $out =~ m!not implemented!i,
        "refresh_blog_templates by other permission" );
};

subtest 'action = move_blogs' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'blog',
            action_name          => 'move_blogs',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_blog%26blog_id%3D' . $website->id,
            plugin_action_selector => 'move_blogs',
            id                     => $blog->id,
            plugin_action_selector => 'move_blogs',
            dialog                 => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: move_blogs" );
    ok( $out !~ m!not implemented!i, "move_blogs by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $tezuka,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'blog',
            action_name          => 'move_blogs',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_blog%26blog_id%3D' . $website->id,
            plugin_action_selector => 'move_blogs',
            id                     => $blog->id,
            plugin_action_selector => 'move_blogs',
            dialog                 => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: move_blogs" );
    ok( $out =~ m!not implemented!i, "move_blogs by non permitted user" );
};

subtest 'action = clone_blog' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'blog',
            action_name          => 'clone_blog',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_blog%26blog_id%3D' . $website->id,
            plugin_action_selector => 'clone_blog',
            id                     => $blog->id,
            plugin_action_selector => 'clone_blog',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: clone_blog" );
    ok( $out !~ m!not implemented!i, "clone_blog by admin(request)" );
    ok( $out !~ m!permission=1!i,    "clone_blog by admin(permission)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $niyagawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'blog',
            action_name          => 'clone_blog',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_blog%26blog_id%3D' . $website->id,
            plugin_action_selector => 'clone_blog',
            id                     => $blog->id,
            plugin_action_selector => 'clone_blog',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: clone_blog" );
    ok( $out !~ m!not implemented!i,
        "clone_blog by permitted user(request)" );
    ok( $out !~ m!permission=1!i,
        "clone_blog by permitted user(permission)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $nunota,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'blog',
            action_name          => 'clone_blog',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_blog%26blog_id%3D' . $website->id,
            plugin_action_selector => 'clone_blog',
            id                     => $blog->id,
            plugin_action_selector => 'clone_blog',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: clone_blog" );
    ok( $out =~ m!permission=1!i,
        "clone_blog by non permitted user(permission)" );
};

subtest 'mode = delete' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'blog',
            id               => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out !~ m!permission=1!i, "delete by admin" );

    $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );
    MT::Association->link( $aikawa     => $blog_admin      => $blog );
    MT::Association->link( $ichikawa   => $designer        => $blog );
    MT::Association->link( $ukawa      => $manage_pages    => $blog );
    MT::Association->link( $egawa      => $rebuild         => $blog );
    MT::Association->link( $ogawa      => $edit_config     => $blog );
    MT::Association->link( $kagawa     => $edit_all_posts  => $blog );
    MT::Association->link( $kikkawa    => $publish_post    => $blog );
    MT::Association->link( $kumekawa   => $manage_feedback => $blog );
    MT::Association->link( $tezuka     => $edit_templates  => $blog );
    MT::Association->link( $kemikawa   => $create_post     => $blog );
    MT::Association->link( $koishikawa => $create_post     => $blog );
    MT::Association->link( $sagawa     => $create_post     => $blog );
    MT::Association->link( $shiki      => $create_post     => $blog );
    MT::Association->link( $suda       => $create_post     => $blog );
    MT::Association->link( $seta       => $create_post     => $blog );
    MT::Association->link( $soneda     => $create_post     => $blog );
    MT::Association->link( $taneda     => $create_post     => $blog );
    MT::Association->link( $toda       => $create_post     => $blog );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'blog',
            id               => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out !~ m!permission=1!i, "delete by permitted user (blog admin)" );

    $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );
    MT::Association->link( $aikawa     => $blog_admin      => $blog );
    MT::Association->link( $ichikawa   => $designer        => $blog );
    MT::Association->link( $ukawa      => $manage_pages    => $blog );
    MT::Association->link( $egawa      => $rebuild         => $blog );
    MT::Association->link( $ogawa      => $edit_config     => $blog );
    MT::Association->link( $kagawa     => $edit_all_posts  => $blog );
    MT::Association->link( $kikkawa    => $publish_post    => $blog );
    MT::Association->link( $kumekawa   => $manage_feedback => $blog );
    MT::Association->link( $tezuka     => $edit_templates  => $blog );
    MT::Association->link( $kemikawa   => $create_post     => $blog );
    MT::Association->link( $koishikawa => $create_post     => $blog );
    MT::Association->link( $sagawa     => $create_post     => $blog );
    MT::Association->link( $shiki      => $create_post     => $blog );
    MT::Association->link( $suda       => $create_post     => $blog );
    MT::Association->link( $seta       => $create_post     => $blog );
    MT::Association->link( $soneda     => $create_post     => $blog );
    MT::Association->link( $taneda     => $create_post     => $blog );
    MT::Association->link( $toda       => $create_post     => $blog );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'blog',
            id               => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!permission=1!i,
        "delete by non permitted user (edit config)" );

    $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );
    MT::Association->link( $aikawa     => $blog_admin      => $blog );
    MT::Association->link( $ichikawa   => $designer        => $blog );
    MT::Association->link( $ukawa      => $manage_pages    => $blog );
    MT::Association->link( $egawa      => $rebuild         => $blog );
    MT::Association->link( $ogawa      => $edit_config     => $blog );
    MT::Association->link( $kagawa     => $edit_all_posts  => $blog );
    MT::Association->link( $kikkawa    => $publish_post    => $blog );
    MT::Association->link( $kumekawa   => $manage_feedback => $blog );
    MT::Association->link( $tezuka     => $edit_templates  => $blog );
    MT::Association->link( $kemikawa   => $create_post     => $blog );
    MT::Association->link( $koishikawa => $create_post     => $blog );
    MT::Association->link( $sagawa     => $create_post     => $blog );
    MT::Association->link( $shiki      => $create_post     => $blog );
    MT::Association->link( $suda       => $create_post     => $blog );
    MT::Association->link( $seta       => $create_post     => $blog );
    MT::Association->link( $soneda     => $create_post     => $blog );
    MT::Association->link( $taneda     => $create_post     => $blog );
    MT::Association->link( $toda       => $create_post     => $blog );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuda,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'blog',
            id               => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!permission=1!i,
        "delete by non permitted user (create blog)" );

    $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );
    MT::Association->link( $aikawa     => $blog_admin      => $blog );
    MT::Association->link( $ichikawa   => $designer        => $blog );
    MT::Association->link( $ukawa      => $manage_pages    => $blog );
    MT::Association->link( $egawa      => $rebuild         => $blog );
    MT::Association->link( $ogawa      => $edit_config     => $blog );
    MT::Association->link( $kagawa     => $edit_all_posts  => $blog );
    MT::Association->link( $kikkawa    => $publish_post    => $blog );
    MT::Association->link( $kumekawa   => $manage_feedback => $blog );
    MT::Association->link( $tezuka     => $edit_templates  => $blog );
    MT::Association->link( $kemikawa   => $create_post     => $blog );
    MT::Association->link( $koishikawa => $create_post     => $blog );
    MT::Association->link( $sagawa     => $create_post     => $blog );
    MT::Association->link( $shiki      => $create_post     => $blog );
    MT::Association->link( $suda       => $create_post     => $blog );
    MT::Association->link( $seta       => $create_post     => $blog );
    MT::Association->link( $soneda     => $create_post     => $blog );
    MT::Association->link( $taneda     => $create_post     => $blog );
    MT::Association->link( $toda       => $create_post     => $blog );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'blog',
            id               => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other blog (blog admin)" );

    $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );
    MT::Association->link( $aikawa     => $blog_admin      => $blog );
    MT::Association->link( $ichikawa   => $designer        => $blog );
    MT::Association->link( $ukawa      => $manage_pages    => $blog );
    MT::Association->link( $egawa      => $rebuild         => $blog );
    MT::Association->link( $ogawa      => $edit_config     => $blog );
    MT::Association->link( $kagawa     => $edit_all_posts  => $blog );
    MT::Association->link( $kikkawa    => $publish_post    => $blog );
    MT::Association->link( $kumekawa   => $manage_feedback => $blog );
    MT::Association->link( $tezuka     => $edit_templates  => $blog );
    MT::Association->link( $kemikawa   => $create_post     => $blog );
    MT::Association->link( $koishikawa => $create_post     => $blog );
    MT::Association->link( $sagawa     => $create_post     => $blog );
    MT::Association->link( $shiki      => $create_post     => $blog );
    MT::Association->link( $suda       => $create_post     => $blog );
    MT::Association->link( $seta       => $create_post     => $blog );
    MT::Association->link( $soneda     => $create_post     => $blog );
    MT::Association->link( $taneda     => $create_post     => $blog );
    MT::Association->link( $toda       => $create_post     => $blog );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $suda,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'blog',
            id               => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other blog (edit config)" );

    $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );
    MT::Association->link( $aikawa     => $blog_admin      => $blog );
    MT::Association->link( $ichikawa   => $designer        => $blog );
    MT::Association->link( $ukawa      => $manage_pages    => $blog );
    MT::Association->link( $egawa      => $rebuild         => $blog );
    MT::Association->link( $ogawa      => $edit_config     => $blog );
    MT::Association->link( $kagawa     => $edit_all_posts  => $blog );
    MT::Association->link( $kikkawa    => $publish_post    => $blog );
    MT::Association->link( $kumekawa   => $manage_feedback => $blog );
    MT::Association->link( $tezuka     => $edit_templates  => $blog );
    MT::Association->link( $kemikawa   => $create_post     => $blog );
    MT::Association->link( $koishikawa => $create_post     => $blog );
    MT::Association->link( $sagawa     => $create_post     => $blog );
    MT::Association->link( $shiki      => $create_post     => $blog );
    MT::Association->link( $suda       => $create_post     => $blog );
    MT::Association->link( $seta       => $create_post     => $blog );
    MT::Association->link( $soneda     => $create_post     => $blog );
    MT::Association->link( $taneda     => $create_post     => $blog );
    MT::Association->link( $toda       => $create_post     => $blog );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'blog',
            id               => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other permission" );
    done_testing();
};

subtest 'mode = delete ( type is site)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'site',
            id               => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!Invalid request!i, "delete by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'site',
            id               => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!Invalid request!i, "delete by permitted user (blog admin)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'site',
            id               => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!Invalid request!i,
        "delete by non permitted user (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tsuda,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'site',
            id               => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!Invalid request!i,
        "delete by non permitted user (create blog)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'site',
            id               => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!Invalid request!i, "delete by other blog (blog admin)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $suda,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'site',
            id               => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!Invalid request!i, "delete by other blog (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'site',
            id               => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!Invalid request!i, "delete by other permission" );
    done_testing();
};

done_testing();
