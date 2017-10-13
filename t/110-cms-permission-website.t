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
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

use MT::Test qw( :app :db );
use MT::Test::Permission;

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
my $sorimachi = MT::Test::Permission->make_author(
    name     => 'sorimachi',
    nickname => 'Goro Sorimachi',
);
my $tada = MT::Test::Permission->make_author(
    name     => 'tada',
    nickname => 'Ichiro Tada',
);

my $admin = MT::Author->load(1);

# Role
my $edit_config = MT::Test::Permission->make_role(
    name        => 'Edit Config',
    permissions => "'edit_config'",
);
my $edit_templates = MT::Test::Permission->make_role(
    name        => 'Edit Templates',
    permissions => "'edit_templates'",
);
my $site_admin
    = MT::Role->load( { name => MT->translate('Site Administrator') } );
my $designer = MT::Role->load( { name => MT->translate('Designer') } );

require MT::Association;
MT::Association->link( $aikawa => $site_admin => $website );
MT::Association->link( $shiki, $designer, $website );
MT::Association->link( $ichikawa => $designer    => $blog );
MT::Association->link( $egawa    => $site_admin  => $second_website );
MT::Association->link( $ogawa    => $edit_config => $website );
MT::Association->link( $kagawa   => $edit_config => $second_website );
MT::Association->link( $koishikawa, $edit_config, $blog );
MT::Association->link( $sagawa,     $edit_config, $second_blog );
MT::Association->link( $suda,       $site_admin,  $blog );
MT::Association->link( $seta,       $site_admin,  $website );
MT::Association->link( $tada,       $site_admin,  $website );

foreach my $w ( MT::Website->load() ) {
    MT::Association->link( $sorimachi, $site_admin, $w );
}

MT::Association->link( $kikkawa  => $edit_templates => $website );
MT::Association->link( $kumekawa => $edit_templates => $second_website );

require MT::Permission;
my $p = MT::Permission->new;
$p->blog_id(0);
$p->author_id( $ukawa->id );
$p->permissions("'create_site'");
$p->save;

$p = MT::Permission->new;
$p->blog_id(0);
$p->author_id( $kemikawa->id );
$p->permissions("'edit_templates'");
$p->save;

$p = MT::Permission->new;
$p->blog_id(0);
$p->author_id( $suda->id );
$p->permissions("'edit_templates'");
$p->save;

$p = MT::Permission->new;
$p->blog_id(0);
$p->author_id( $seta->id );
$p->permissions("'edit_templates'");
$p->save;

$p = MT::Permission->new;
$p->blog_id(0);
$p->author_id( $sorimachi->id );
$p->permissions("'edit_templates'");
$p->save;

$p = MT::Permission->new;
$p->blog_id(0);
$p->author_id( $tada->id );
$p->save;

# Run
my ( $app, $out );

sub _is_error {
    my $out = shift or return;
    $out =~ /(redirect|permission)=1|An error occurr?ed/i;
}

sub _is_not_error {
    !_is_error(shift);
}

subtest 'mode = cfg_prefs' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'cfg_prefs',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                "Request: cfg_prefs" );
    ok( _is_not_error($out), "cfg_prefs by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'cfg_prefs',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                "Request: cfg_prefs" );
    ok( _is_not_error($out), "cfg_prefs by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'cfg_prefs',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,            "Request: cfg_prefs" );
    ok( _is_error($out), "cfg_prefs by other website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $koishikawa,
            __request_method => 'POST',
            __mode           => 'cfg_prefs',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,            "Request: cfg_prefs" );
    ok( _is_error($out), "cfg_prefs by child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sagawa,
            __request_method => 'POST',
            __mode           => 'cfg_prefs',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,            "Request: cfg_prefs" );
    ok( _is_error($out), "cfg_prefs by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $shiki,
            __request_method => 'POST',
            __mode           => 'cfg_prefs',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,            "Request: cfg_prefs" );
    ok( _is_error($out), "cfg_prefs by other permission" );
    done_testing();
};

subtest 'mode = list' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => 0,
            _type            => 'website',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                "Request: list" );
    ok( _is_not_error($out), "list by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => 0,
            _type            => 'website',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                "Request: list" );
    ok( _is_not_error($out), "list by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'website',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                "Request: list" );
    ok( _is_not_error($out), "list by permitted user (system)" );
    my $button = quotemeta '<a href="#delete" class="button">Delete</a>';
    unlike( $out, qr/$button/, 'There is not "Delete" button.' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $suda,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'website',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( _is_not_error($out),
        "list by permitted user (system) with blog administrator permission"
    );
    unlike( $out, qr/$button/, 'There is not "Delete" button.' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $seta,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'website',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( _is_not_error($out),
        "list by permitted user (system) with website administrator permission"
    );
    unlike( $out, qr/$button/, 'There is not "Delete" button.' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $tada,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'website',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( _is_not_error($out),
        "list by permitted user with an empry system permission record." );
SKIP: {
        skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
        like( $out, qr/$button/, 'There is "Delete" button.' );
    }
    my $refresh_tmpl = quotemeta
        '<option value="refresh_website_templates">Refresh Template(s)</option>';
SKIP: {
        skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
        like( $out, qr/$refresh_tmpl/,
            'There is "Refresh Template(s)" action.' );
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sorimachi,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'website',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( _is_not_error($out),
        "list by permitted user (system) with all website administrator permission"
    );
SKIP: {
        skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
        like( $out, qr/$button/, 'There is "Delete" button.' );
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'website',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                "Request: list" );
    ok( _is_not_error($out), "list by child blog" );
};

subtest 'mode = save (new)' => sub {
    my %cookies;
    my $module = Test::MockModule->new('MT::App::CMS');
    $module->mock( 'cookies', sub { wantarray ? %cookies : \%cookies } );

    my $args = $app->start_session($admin);
    %cookies = ( $app->user_cookie() => CGI::Cookie->new(%$args) );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'websiteName',
            website_theme    => 'classic_website',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                "Request: save" );
    ok( _is_not_error($out), "save (new) by admin" );

    $args = $app->start_session($ukawa);
    %cookies = ( $app->user_cookie() => CGI::Cookie->new(%$args) );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'WebsiteName',
            website_theme    => 'classic_website',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                "Request: save" );
    ok( _is_not_error($out), "save (new) by permitted user" );

    $args = $app->start_session($ukawa);
    %cookies = ( $app->user_cookie() => CGI::Cookie->new(%$args) );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'WebsiteName',
            website_theme    => 'classic_website',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,            "Request: save" );
    ok( _is_error($out), "save (new) by blog admin" );
    done_testing();
};

subtest 'mode = save (edit)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                "Request: save" );
    ok( _is_not_error($out), "save (edit) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( _is_not_error($out),
        "save (edit) by permitted user (website admin)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                "Request: save" );
    ok( _is_not_error($out), "save (edit) by permitted user (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( _is_error($out),
        "save (edit) by non permitted user (create website)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,            "Request: save" );
    ok( _is_error($out), "save (edit) by other blog (website admin)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,            "Request: save" );
    ok( _is_error($out), "save (edit) by other blog (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,            "Request: save" );
    ok( _is_error($out), "save (edit) by other permission" );
    done_testing();
};

subtest 'mode = edit (new)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'website',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                "Request: edit" );
    ok( _is_not_error($out), "edit (new) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'website',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                "Request: edit" );
    ok( _is_not_error($out), "edit (new) by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'website',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,            "Request: edit" );
    ok( _is_error($out), "edit (new) by blog admin" );
    done_testing();
};

subtest 'mode = edit (edit)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                "Request: edit" );
    ok( _is_not_error($out), "edit (edit) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( _is_not_error($out),
        "edit (edit) by permitted user (website admin)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                "Request: edit" );
    ok( _is_not_error($out), "edit (edit) by permitted user (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( _is_error($out),
        "edit (edit) by non permitted user (create website)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,            "Request: edit" );
    ok( _is_error($out), "edit (edit) by other blog (website admin)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,            "Request: edit" );
    ok( _is_error($out), "edit (edit) by other blog (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,            "Request: edit" );
    ok( _is_error($out), "edit (edit) by other permission" );
    done_testing();
};

subtest 'mode = move_blogs' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'blog',
            action_name          => 'move_blogs',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_blogs%26blog_id%3D' . $website->id,
            plugin_action_selector => 'move_blogs',
            id                     => $blog->id,
            plugin_action_selector => 'move_blogs',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: move_blogs" );
    ok( $out !~ m!not implemented!i, "move_blogs by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $aikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'blog',
            action_name          => 'move_blogs',
            itemset_action_input => '',
            return_args => '__mode%3Dlist_blogs%26blog_id%3D' . $website->id,
            plugin_action_selector => 'move_blogs',
            id                     => $blog->id,
            plugin_action_selector => 'move_blogs',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: move_blogs" );
    ok( $out =~ m!not implemented!i, "move_blogs by non permitted user" );
};

subtest 'action = refresh_website_templates' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'website',
            action_name          => 'refresh_website_templates',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_website%26blog_id%3D'
                . $website->id,
            plugin_action_selector => 'refresh_website_templates',
            id                     => $website->id,
            plugin_action_selector => 'refresh_website_templates',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                  "Request: refresh_website_templates" );
    ok( $out !~ m!error_id=!i, "refresh_website_templates by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kikkawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'website',
            action_name          => 'refresh_website_templates',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_website%26blog_id%3D'
                . $website->id,
            plugin_action_selector => 'refresh_website_templates',
            id                     => $website->id,
            plugin_action_selector => 'refresh_website_templates',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: refresh_website_templates" );
    ok( $out !~ m!error_id=!i,
        "refresh_website_templates by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kemikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'website',
            action_name          => 'refresh_website_templates',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_website%26blog_id%3D'
                . $website->id,
            plugin_action_selector => 'refresh_website_templates',
            id                     => $website->id,
            plugin_action_selector => 'refresh_website_templates',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: refresh_website_templates" );
    ok( $out !~ m!error_id=!i,
        "refresh_website_templates by permitted user (system)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kumekawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'website',
            action_name          => 'refresh_website_templates',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_website%26blog_id%3D'
                . $website->id,
            plugin_action_selector => 'refresh_website_templates',
            id                     => $website->id,
            plugin_action_selector => 'refresh_website_templates',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                  "Request: refresh_website_templates" );
    ok( $out =~ m!error_id=!i, "refresh_website_templates by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $ogawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'website',
            action_name          => 'refresh_website_templates',
            itemset_action_input => '',
            return_args          => '__mode%3Dlist_website%26blog_id%3D'
                . $website->id,
            plugin_action_selector => 'refresh_website_templates',
            id                     => $website->id,
            plugin_action_selector => 'refresh_website_templates',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: refresh_website_templates" );
    ok( $out =~ m!not implemented!i,
        "refresh_website_templates by other permission" );
};

subtest 'mode = delete' => sub {
    $website = MT::Test::Permission->make_website();
    $app     = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'website',
            id               => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                "Request: delete" );
    ok( _is_not_error($out), "delete by admin" );

    $website = MT::Test::Permission->make_website();
    MT::Association->link( $aikawa => $site_admin => $website );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'website',
            id               => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                "Request: delete" );
    ok( _is_not_error($out), "delete by permitted user (website admin)" );

    $website = MT::Test::Permission->make_website();
    $app     = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'website',
            id               => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,            "Request: delete" );
    ok( _is_error($out), "delete by non permitted user (create website)" );

    $website = MT::Test::Permission->make_website();
    $app     = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'website',
            id               => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,            "Request: delete" );
    ok( _is_error($out), "delete by other blog (website admin)" );

    $website = MT::Test::Permission->make_website();
    $app     = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'website',
            id               => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,            "Request: delete" );
    ok( _is_error($out), "delete by other permission" );
    done_testing();
};

done_testing();
