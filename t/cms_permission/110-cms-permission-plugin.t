#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website(
        name => 'my website',
    );

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name => 'my blog',
    );
    my $second_blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name => 'second blog',
    );

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

    my $admin = MT::Author->load(1);

    # Role
    require MT::Role;
    my $site_admin
        = MT::Role->load( { name => MT->translate('Site Administrator') } );
    my $designer = MT::Role->load( { name => MT->translate('Designer') } );

    require MT::Association;
    MT::Association->link( $aikawa   => $site_admin => $blog );
    MT::Association->link( $ichikawa => $site_admin => $second_blog );
    MT::Association->link( $ukawa    => $site_admin => $website );
    MT::Association->link( $ogawa    => $designer   => $blog );

    $egawa->can_manage_plugins(1);
    $egawa->save();
});

my $website = MT::Website->load( { name => 'my website' } );

my $blog = MT::Blog->load( { name => 'my blog' } );

my $aikawa   = MT::Author->load( { name => 'aikawa' } );
my $ichikawa = MT::Author->load( { name => 'ichikawa' } );
my $ukawa    = MT::Author->load( { name => 'ukawa' } );
my $egawa    = MT::Author->load( { name => 'egawa' } );
my $ogawa    = MT::Author->load( { name => 'ogawa' } );

my $admin = MT::Author->load(1);

# Run
my ( $app, $out );

subtest 'mode = cfg_plugins' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'cfg_plugins',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_plugins" );
    ok( $out !~ m!permission=1!i, "cfg_plugins by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'cfg_plugins',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_plugins" );
    ok( $out !~ m!permission=1!i, "cfg_plugins by permitted user on blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'cfg_plugins',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: cfg_plugins" );
    ok( $out !~ m!permission=1!i,
        "cfg_plugins by permitted user on website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'cfg_plugins',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_plugins" );
    ok( $out !~ m!permission=1!i, "cfg_plugins by permitted user on system" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'cfg_plugins',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_plugins" );
    ok( $out =~ m!permission=1!i, "cfg_plugins by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'cfg_plugins',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_plugins" );
    ok( $out =~ m!permission=1!i, "cfg_plugins by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'cfg_plugins',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: cfg_plugins" );
    ok( $out =~ m!permission=1!i,
        "cfg_plugins by non permitted user on website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'cfg_plugins',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: cfg_plugins" );
    ok( $out =~ m!permission=1!i,
        "cfg_plugins by non permitted user on blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'cfg_plugins',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: cfg_plugins" );
    ok( $out =~ m!permission=1!i,
        "cfg_plugins by non permitted user on system" );

    done_testing();
};

subtest 'mode = plugin_control' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'plugin_control',
            blog_id          => 0,
            plugin_sig       => '*',
            state            => 'on',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: plugin_control" );
    ok( $out !~ m!permission=1!i, "plugin_control by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'plugin_control',
            blog_id          => 0,
            plugin_sig       => '*',
            state            => 'on',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: plugin_control" );
    ok( $out !~ m!permission=1!i, "plugin_control by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'plugin_control',
            blog_id          => $blog->id,
            plugin_sig       => '*',
            state            => 'on',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: plugin_control" );
    ok( $out =~ m!permission=1!i, "plugin_control by non permitted user" );

    done_testing();
};

subtest 'mode = reset_plugin_config' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'reset_plugin_config',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: reset_plugin_config" );
    ok( $out !~ m!permission=1!i, "reset_plugin_config by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'reset_plugin_config',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reset_plugin_config" );
    ok( $out !~ m!permission=1!i,
        "reset_plugin_config by permitted user on blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'reset_plugin_config',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reset_plugin_config" );
    ok( $out !~ m!permission=1!i,
        "reset_plugin_config by permitted user on website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'reset_plugin_config',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reset_plugin_config" );
    ok( $out !~ m!permission=1!i,
        "reset_plugin_config by permitted user on system" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'reset_plugin_config',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: reset_plugin_config" );
    ok( $out =~ m!permission=1!i, "reset_plugin_config by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'reset_plugin_config',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: reset_plugin_config" );
    ok( $out =~ m!permission=1!i, "reset_plugin_config by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'reset_plugin_config',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reset_plugin_config" );
    ok( $out =~ m!permission=1!i,
        "reset_plugin_config by non permitted user on website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'reset_plugin_config',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reset_plugin_config" );
    ok( $out =~ m!permission=1!i,
        "reset_plugin_config by non permitted user on blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'reset_plugin_config',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reset_plugin_config" );
    ok( $out =~ m!permission=1!i,
        "reset_plugin_config by non permitted user on system" );

    done_testing();
};

subtest 'mode = save_plugin_config' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save_plugin_config',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_plugin_config" );
    ok( $out !~ m!permission=1!i, "save_plugin_config by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save_plugin_config',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_plugin_config" );
    ok( $out !~ m!permission=1!i,
        "save_plugin_config by permitted user on blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save_plugin_config',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_plugin_config" );
    ok( $out !~ m!permission=1!i,
        "save_plugin_config by permitted user on website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'save_plugin_config',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_plugin_config" );
    ok( $out !~ m!permission=1!i,
        "save_plugin_config by permitted user on system" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save_plugin_config',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_plugin_config" );
    ok( $out =~ m!permission=1!i, "save_plugin_config by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'save_plugin_config',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_plugin_config" );
    ok( $out =~ m!permission=1!i, "save_plugin_config by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save_plugin_config',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_plugin_config" );
    ok( $out =~ m!permission=1!i,
        "save_plugin_config by non permitted user on website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save_plugin_config',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_plugin_config" );
    ok( $out =~ m!permission=1!i,
        "save_plugin_config by non permitted user on blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save_plugin_config',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_plugin_config" );
    ok( $out =~ m!permission=1!i,
        "save_plugin_config by non permitted user on system" );

    done_testing();
};

done_testing();
