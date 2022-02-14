#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::Fixture::CmsPermission::Imexport;
use MT::Test::App;

### Make test data
$test_env->prepare_fixture('cms_permission/Imexport');

my $blog = MT::Blog->load({ name => 'my blog' });

my $aikawa   = MT::Author->load({ name => 'aikawa' });
my $ichikawa = MT::Author->load({ name => 'ichikawa' });
my $ukawa    = MT::Author->load({ name => 'ukawa' });

my $admin = MT::Author->load(1);

subtest 'mode = import' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode       => 'import',
        blog_id      => $blog->id,
        import_as_me => 1,
    });
    $app->has_no_permission_error("import by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode       => 'import',
        blog_id      => $blog->id,
        import_as_me => 1,
    });
    $app->has_no_permission_error("import by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode       => 'import',
        blog_id      => $blog->id,
        import_as_me => 1,
    });
    $app->has_permission_error("import by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode       => 'import',
        blog_id      => $blog->id,
        import_as_me => 1,
    });
    $app->has_permission_error("import by other permission");
};

subtest 'mode = start_import' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'start_import',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("start_import by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'start_import',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("start_import by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'start_import',
        blog_id => $blog->id,
    });
    $app->has_permission_error("start_import by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'start_import',
        blog_id => $blog->id,
    });
    $app->has_permission_error("start_import by other permission");
};

done_testing();
