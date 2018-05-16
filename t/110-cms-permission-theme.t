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
use MT::Test::Permission;

MT::Test->init_app;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website( name => 'my website' );

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

    my $admin = MT::Author->load(1);

    # Role
    my $manage_themes = MT::Test::Permission->make_role(
       name  => 'Manage Themes',
       permissions => "'manage_themes'",
    );

    my $create_post = MT::Test::Permission->make_role(
       name  => 'Create Post',
       permissions => "'create_post'",
    );

    require MT::Association;
    MT::Association->link( $aikawa => $manage_themes => $blog );
    MT::Association->link( $ichikawa => $create_post => $blog );
    MT::Association->link( $ukawa => $manage_themes => $second_blog );
});

my $website = MT::Website->load( { name => 'my website' } );
my $blog    = MT::Blog->load( { name => 'my blog' } );

my $aikawa   = MT::Author->load( { name => 'aikawa' } );
my $ichikawa = MT::Author->load( { name => 'ichikawa' } );
my $ukawa    = MT::Author->load( { name => 'ukawa' } );

my $admin = MT::Author->load(1);

# Run
my ( $app, $out );

subtest 'mode = apply_theme' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'apply_theme',
            blog_id          => $blog->id,
            theme_id         => 'classic_blog',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: apply_theme" );
    ok( $out =~ m!__mode=list_theme!i, "apply_theme by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'apply_theme',
            blog_id          => $blog->id,
            theme_id         => 'classic_blog',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: apply_theme" );
    ok( $out =~ m!__mode=list_theme!i, "apply_theme by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'apply_theme',
            blog_id          => $blog->id,
            theme_id         => 'classic_blog',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: apply_theme" );
    ok( $out =~ m!permission=1!i, "apply_theme by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'apply_theme',
            blog_id          => $blog->id,
            theme_id         => 'classic_blog',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: apply_theme" );
    ok( $out =~ m!permission=1!i, "apply_theme by other permission" );

    done_testing();
};

subtest 'mode = dialog_select_theme' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'dialog_select_theme',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: dialog_select_theme" );
    ok( $out !~ m!permission=1!i, "dialog_select_theme by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'dialog_select_theme',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: dialog_select_theme" );
    ok( $out =~ m!permission=1!i, "dialog_select_theme by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'dialog_select_theme',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: dialog_select_theme" );
    ok( $out =~ m!permission=1!i, "dialog_select_theme by other permission" );

    done_testing();
};

subtest 'mode = do_export_theme' => sub {
    if ( $^O eq 'MSWin32' ) {
        $app->config->TempDir( File::Spec->tmpdir );
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'do_export_theme',
            blog_id          => $blog->id,
            theme_id         => 'classic_blog',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: do_export_theme" );
    ok( $out =~ m!__mode=export_theme!i, "do_export_theme by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'do_export_theme',
            blog_id          => $blog->id,
            theme_id         => 'classic_blog',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: do_export_theme" );
    ok( $out =~ m!__mode=export_theme!i, "do_export_theme by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'do_export_theme',
            blog_id          => $blog->id,
            theme_id         => 'classic_blog',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: do_export_theme" );
    ok( $out =~ m!permission=1!i, "do_export_theme by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'do_export_theme',
            blog_id          => $blog->id,
            theme_id         => 'classic_blog',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: do_export_theme" );
    ok( $out =~ m!permission=1!i, "do_export_theme by other permission" );

    done_testing();
};

subtest 'mode = theme_element_detail' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'theme_element_detail',
            blog_id          => $blog->id,
            exporter_id      => 'default_categories',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: theme_element_detail" );
    ok( $out !~ m!permission=1!i, "theme_element_detail by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'theme_element_detail',
            blog_id          => $blog->id,
            exporter_id      => 'default_categories',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: theme_element_detail" );
    ok( $out !~ m!permission=1!i, "theme_element_detail by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'theme_element_detail',
            blog_id          => $blog->id,
            exporter_id      => 'default_categories',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: theme_element_detail" );
    ok( $out =~ m!permission=1!i, "theme_element_detail by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'theme_element_detail',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: theme_element_detail" );
    ok( $out =~ m!permission=1!i, "theme_element_detail by other permission" );

    done_testing();
};

subtest 'mode = export_theme' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'export_theme',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: export_theme" );
    ok( $out !~ m!permission=1!i, "export_theme by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'export_theme',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: export_theme" );
    ok( $out !~ m!permission=1!i, "export_theme by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'export_theme',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: export_theme" );
    ok( $out =~ m!permission=1!i, "export_theme by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'export_theme',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: export_theme" );
    ok( $out =~ m!permission=1!i, "export_theme by other permission" );

    done_testing();
};

subtest 'mode = list_theme' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list_theme',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_theme" );
    ok( $out !~ m!permission=1!i, "list_theme by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list_theme',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_theme" );
    ok( $out !~ m!permission=1!i, "list_theme by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'list_theme',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_theme" );
    ok( $out =~ m!permission=1!i, "list_theme by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'list_theme',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_theme" );
    ok( $out =~ m!permission=1!i, "list_theme by other permission" );

    done_testing();
};

subtest 'mode = save_theme_detail' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save_theme_detail',
            blog_id          => $blog->id,
            exporter_id      => 'default_categories',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_theme_detail" );
    ok( $out !~ m!permission=1!i, "save_theme_detail by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save_theme_detail',
            blog_id          => $blog->id,
            exporter_id      => 'default_categories',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_theme_detail" );
    ok( $out !~ m!permission=1!i, "save_theme_detail by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save_theme_detail',
            blog_id          => $blog->id,
            exporter_id      => 'default_categories',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_theme_detail" );
    ok( $out =~ m!permission=1!i, "save_theme_detail by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save_theme_detail',
            blog_id          => $blog->id,
            exporter_id      => 'default_categories',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_theme_detail" );
    ok( $out =~ m!permission=1!i, "save_theme_detail by other permission" );

    done_testing();
};

subtest 'mode = uninstall_theme' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'uninstall_theme',
            blog_id          => $blog->id,
            theme_id         => 'classic_blog',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: uninstall_theme" );
    ok( $out !~ m!permission=1!i, "uninstall_theme by admin" ); #TODO: should use 'Permission=1' instead

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'uninstall_theme',
            theme_id         => 'classic_blog',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: uninstall_theme" );
    ok( $out =~ m!permission=1!i, "uninstall_theme by non permitted user" ); #TODO: should use 'Permission=1' instead

    done_testing();
};

done_testing();
