use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";
use Test::More;
use MT::Test::Env;

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::DataAPI;
use MT::Test::Permission;

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

use MT::ContentStatus;

my $user = MT->model('author')->load(1);
$user->email('melody@example.com');
$user->save;

$app->user($user);

my $site_id = 1;

irregular_tests_for_preview_by_id();
normal_tests_for_preview_by_id();

irregular_tests_for_preview();
normal_tests_for_preview();

done_testing;

sub irregular_tests_for_preview_by_id {
    my $content_type
        = MT::Test::Permission->make_content_type( blog_id => $site_id );
    my $content_type_id = $content_type->id;

    $user->permissions(0)->rebuild;
    $user->permissions($site_id)->rebuild;

    my $cd = MT::Test::Permission->make_content_data(
        blog_id         => $content_type->blog_id,
        content_type_id => $content_type->id,
    );
    my $cd_id = $cd->id;

    my $tmpl = MT::Test::Permission->make_template(
        blog_id         => $content_type->blog_id,
        content_type_id => $content_type->id,
        type            => 'ct',
    );

    MT::Test::Permission->make_templatemap(
        blog_id      => $tmpl->blog_id,
        template_id  => $tmpl->id,
        archive_type => 'ContentType',
        is_preferred => 1,
    );

    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_data/$cd_id/preview",
            method    => 'POST',
            author_id => 0,
            params    => { content_data => {}, },
            code      => 401,
        }
    );
    test_data_api(
        {   note => 'no permission',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_data/$cd_id/preview",
            method       => 'POST',
            params       => { content_data => {}, },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );
}

sub normal_tests_for_preview_by_id {
    my $content_type
        = MT::Test::Permission->make_content_type( blog_id => $site_id );
    my $content_type_id = $content_type->id;

    $user->permissions(0)->rebuild;
    $user->permissions($site_id)->rebuild;

    my $cd = MT::Test::Permission->make_content_data(
        blog_id         => $content_type->blog_id,
        content_type_id => $content_type->id,
    );
    my $cd_id = $cd->id;

    my $tmpl = MT::Test::Permission->make_template(
        blog_id         => $content_type->blog_id,
        content_type_id => $content_type->id,
        type            => 'ct',
    );

    MT::Test::Permission->make_templatemap(
        blog_id      => $tmpl->blog_id,
        template_id  => $tmpl->id,
        archive_type => 'ContentType',
        is_preferred => 1,
    );

    test_data_api(
        {   note => 'system permission',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_data/$cd_id/preview",
            method       => 'POST',
            params       => { content_data => {}, },
            is_superuser => 1,
            restrictions => {

                # 0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
        }
    );

    test_data_api(
        {   note => 'site permission',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_data/$cd_id/preview",
            method       => 'POST',
            params       => { content_data => {}, },
            is_superuser => 1,
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [

                    # 'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
        }
    );

    test_data_api(
        {   note => 'content_type permission',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_data/$cd_id/preview",
            method       => 'POST',
            params       => { content_data => {}, },
            is_superuser => 1,
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',

                    # 'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
        }
    );

    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_data/$cd_id/preview",
            method       => 'POST',
            params       => { content_data => {}, },
            is_superuser => 1,
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
        }
    );
}

sub irregular_tests_for_preview {
    my $content_type
        = MT::Test::Permission->make_content_type( blog_id => $site_id );
    my $content_type_id = $content_type->id;

    $user->permissions(0)->rebuild;
    $user->permissions($site_id)->rebuild;

    my $cd = MT::Test::Permission->make_content_data(
        blog_id         => $content_type->blog_id,
        content_type_id => $content_type->id,
    );
    my $cd_id = $cd->id;

    my $tmpl = MT::Test::Permission->make_template(
        blog_id         => $content_type->blog_id,
        content_type_id => $content_type->id,
        type            => 'ct',
    );

    MT::Test::Permission->make_templatemap(
        blog_id      => $tmpl->blog_id,
        template_id  => $tmpl->id,
        archive_type => 'ContentType',
        is_preferred => 1,
    );

    test_data_api(
        {   note => 'no logged in',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_data/preview",
            method    => 'POST',
            author_id => 0,
            params    => { content_data => {}, },
            code      => 401,
        }
    );

    test_data_api(
        {   note => 'no permission',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_data/preview",
            method       => 'POST',
            params       => { content_data => {}, },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );
}

sub normal_tests_for_preview {
    my $content_type
        = MT::Test::Permission->make_content_type( blog_id => $site_id );
    my $content_type_id = $content_type->id;

    $user->permissions(0)->rebuild;
    $user->permissions($site_id)->rebuild;

    my $cd = MT::Test::Permission->make_content_data(
        blog_id         => $content_type->blog_id,
        content_type_id => $content_type->id,
    );
    my $cd_id = $cd->id;

    my $tmpl = MT::Test::Permission->make_template(
        blog_id         => $content_type->blog_id,
        content_type_id => $content_type->id,
        type            => 'ct',
    );

    MT::Test::Permission->make_templatemap(
        blog_id      => $tmpl->blog_id,
        template_id  => $tmpl->id,
        archive_type => 'ContentType',
        is_preferred => 1,
    );

    test_data_api(
        {   note => 'system permission',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_data/preview",
            method       => 'POST',
            params       => { content_data => {}, },
            restrictions => {

                # 0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
        }
    );

    test_data_api(
        {   note => 'site permission',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_data/preview",
            method       => 'POST',
            params       => { content_data => {}, },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [

                    # 'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
        }
    );

    test_data_api(
        {   note => 'content_type permission',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_data/preview",
            method       => 'POST',
            params       => { content_data => {}, },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',

                    # 'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
        }
    );

    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_data/preview",
            method       => 'POST',
            params       => { content_data => {}, },
            is_superuser => 1,
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
        }
    );
}

