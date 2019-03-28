use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib"; # t/lib
use Test::More;
use MT::Test::Env;
use Time::Piece;

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

$test_env->prepare_fixture('db');
my $blog_id = 1;
my $blog = MT::Blog->load($blog_id);
$blog->site_path("$ENV{MT_HOME}/t/test_files");
$blog->save or die $blog->errstr;

my $admin = MT::Author->load(1);

my $content_type
    = MT::Test::Permission->make_content_type(blog_id => $blog_id);
my $cf_single = MT::Test::Permission->make_content_field(
    blog_id         => 1,
    content_type_id => $content_type->id,
    name            => 'single',
    type            => 'single_line_text',
);
$content_type->fields(
    [
        {
            id        => $cf_single->id,
            name      => $cf_single->name,
            options   => { label => $cf_single->name, },
            order     => 1,
            type      => $cf_single->type,
            unique_id => $cf_single->unique_id,
        },
    ]
);
$content_type->save or die $content_type->errstr;

my $cd1 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $content_type->id,
    label           => 'label',
    data            => { $cf_single->id => 'single line text' },
    identifier      => 'my content data',
    status          => MT::ContentStatus::RELEASE(),
);

my $ct_archive = MT::Test::Permission->make_template(
    blog_id         => $content_type->blog_id,
    content_type_id => $content_type->id,
    name            => 'Content Type Archive Template',
    type            => 'ct',
);
my $template_map = MT::Test::Permission->make_templatemap(
    blog_id       => $ct_archive->blog_id,
    template_id   => $ct_archive->id,
    archive_type  => 'ContentType',
    file_template => '%y/%m/%d/%b/%i',
    is_preferred  => 1,
);

my $field_name = 'content-field-' . $cf_single->id;
my $file_manager = $blog->file_mgr;

sub create_preview_file_path {
    my ($app) = @_;
    my @parts;
    push @parts, $admin->id;
    push @parts, $blog_id;
    push @parts, $cd1->id;
    push @parts, $content_type->id;
    push @parts, $app->config->SecretToken;
    my $data = join ",", @parts;
    my $preview_file_name = 'mt-preview-' . MT::Util::perl_sha1_digest_hex($data);

    my $preview_date = Time::Piece->strptime(
        scalar $app->param('authored_on_date'),
        '%Y%m%d'
    );

    my $preview_file_path = join(
        '/',
        (
            $blog->site_path,
            $preview_date->year,
            sprintf('%02d', $preview_date->mon),
            sprintf('%02d', $preview_date->mday),
            $preview_file_name,
            $preview_file_name . '.html',
        )
    );

    return ($preview_file_path, $preview_file_name);
};
subtest 'Delete preview file. (PreviewInNewWindow is 0)' => sub {
    my ($app_content_edit, $app_content_preview);
    MT->config->PreviewInNewWindow(0);

    subtest 'Delete preview file when navigating from preview page to edit page.' => sub {
        $app_content_preview = _run_app(
            'MT::App::CMS',
            { __test_user           => $admin,
                __request_method    => 'POST',
                __mode              => 'preview_content_data',
                blog_id             => $blog->id,
                content_type_id     => $content_type->id,
                id                  => $cd1->id,
                data_label          => 'The rewritten label',
                $field_name         => 'The rewritten text',
                authored_on_date    => '20190324',
                authored_on_time    => '000000',
                unpublished_on_date => '20190326',
                unpublished_on_time => '000000',
                rev_numbers         => '0,0',
            }
        );
        my ($preview_file_path, $preview_file_name) = &create_preview_file_path($app_content_preview);

        is($file_manager->exists($preview_file_path), 1, 'Successful creation of preview file.');

        $app_content_edit = _run_app(
            'MT::App::CMS',
            { __test_user        => $admin,
                __request_method => 'POST',
                __mode           => 'edit_content_data',
                blog_id          => $blog->id,
                content_type_id  => $content_type->id,
                id               => $cd1->id,
                _type            => 'content_data',
                _preview_file    => $preview_file_name,
                from_preview     => 1,
                dirty            => 1,
                reedit           => 'reedit',
            }
        );

        ok(
            !$file_manager->exists($preview_file_path),
            'Preview file deleted successfully when navigating from preview page to edit page.'
        );
    };

    subtest 'Delete preview file when saving.' => sub {
        $app_content_preview = _run_app(
            'MT::App::CMS',
            { __test_user           => $admin,
                __request_method    => 'POST',
                __mode              => 'preview_content_data',
                blog_id             => $blog->id,
                content_type_id     => $content_type->id,
                id                  => $cd1->id,
                data_label          => 'The rewritten label',
                $field_name         => 'The rewritten text',
                authored_on_date    => '20190325',
                authored_on_time    => '000000',
                unpublished_on_date => '20190327',
                unpublished_on_time => '000000',
                rev_numbers         => '0,0',
            }
        );

        my ($preview_file_path, $preview_file_name) = &create_preview_file_path($app_content_preview);

        is($file_manager->exists($preview_file_path), 1, 'Successful creation of preview file.');

        my $app_content_save = _run_app(
            'MT::App::CMS',
            {
                __test_user        => $admin,
                __request_method => 'POST',
                __mode           => 'save',
                blog_id          => $blog->id,
                content_type_id  => $content_type->id,
                id               => $cd1->id,
                _type            => 'content_data',
                from_preview     => 1,
                save             => 'save',
                $field_name      => 'The save text',
                status           => 2,
                _preview_file    => $preview_file_name,
            }
        );

        ok(
            !$file_manager->exists($preview_file_path),
            'Preview file deleted successfully when navigating from preview page to saving process.'
        );
    };
};

subtest 'Delete preview file. (PreviewInNewWindow is 1)' => sub {
    my ($app_content_edit, $app_content_preview);
    MT->config->PreviewInNewWindow(1);
    subtest 'Delete preview file when navigating from preview page to edit page.' => sub {
        $app_content_preview = _run_app(
            'MT::App::CMS',
            { __test_user           => $admin,
                __request_method    => 'POST',
                __mode              => 'preview_content_data',
                blog_id             => $blog->id,
                content_type_id     => $content_type->id,
                id                  => $cd1->id,
                data_label          => 'The rewritten label',
                $field_name         => 'The rewritten text',
                authored_on_date    => '20190326',
                authored_on_time    => '000000',
                unpublished_on_date => '20190327',
                unpublished_on_time => '000000',
                rev_numbers         => '0,0',
            }
        );
        my ($preview_file_path, $preview_file_name) = &create_preview_file_path($app_content_preview);

        is($file_manager->exists($preview_file_path), 1, 'Successful creation of preview file.');

        $app_content_edit = _run_app(
            'MT::App::CMS',
            { __test_user        => $admin,
                __request_method => 'POST',
                __mode           => 'edit_content_data',
                blog_id          => $blog->id,
                content_type_id  => $content_type->id,
                id               => $cd1->id,
                _type            => 'content_data',
                _preview_file    => $preview_file_name,
                from_preview     => 1,
                dirty            => 1,
                reedit           => 'reedit',
            }
        );

        ok(
            !$file_manager->exists($preview_file_path),
            'Preview file deleted successfully when navigating from preview page to edit page.'
        );
    };

    subtest 'Delete preview file when saving.' => sub {
        $app_content_preview = _run_app(
            'MT::App::CMS',
            { __test_user           => $admin,
                __request_method    => 'POST',
                __mode              => 'preview_content_data',
                blog_id             => $blog->id,
                content_type_id     => $content_type->id,
                id                  => $cd1->id,
                data_label          => 'The rewritten label',
                $field_name         => 'The rewritten text',
                authored_on_date    => '20190327',
                authored_on_time    => '000000',
                unpublished_on_date => '20190328',
                unpublished_on_time => '000000',
                rev_numbers         => '0,0',
            }
        );

        my ($preview_file_path, $preview_file_name) = &create_preview_file_path($app_content_preview);

        is($file_manager->exists($preview_file_path), 1, 'Successful creation of preview file.');

        my $app_content_save = _run_app(
            'MT::App::CMS',
            {
                __test_user        => $admin,
                __request_method => 'POST',
                __mode           => 'save',
                blog_id          => $blog->id,
                content_type_id  => $content_type->id,
                id               => $cd1->id,
                _type            => 'content_data',
                from_preview     => 1,
                save             => 'save',
                $field_name      => 'The save text',
                status           => 2,
                _preview_file    => $preview_file_name,
            }
        );

        ok(
            !$file_manager->exists($preview_file_path),
            'Preview file deleted successfully when navigating from preview page to saving process.'
        );
    };
};

subtest 'Delete preview file for task' => sub {
    my $app_content_preview = _run_app(
        'MT::App::CMS',
        { __test_user           => $admin,
            __request_method    => 'POST',
            __mode              => 'preview_content_data',
            blog_id             => $blog->id,
            content_type_id     => $content_type->id,
            id                  => $cd1->id,
            data_label          => 'The rewritten label',
            $field_name         => 'The rewritten text',
            authored_on_date    => '20190326',
            authored_on_time    => '000000',
            unpublished_on_date => '20190327',
            unpublished_on_time => '000000',
            rev_numbers         => '0,0',
        }
    );

    my ($preview_file_path, $preview_file_name) = &create_preview_file_path($app_content_preview);

    is($file_manager->exists($preview_file_path), 1, 'Successful creation of preview file.');

    my $this_test_session = MT::Session->get_by_key(
        {
            kind => 'TF',
            name => $preview_file_path,
        }
    );

    $this_test_session->start(time - 60 * 61);
    $this_test_session->save;

    MT::Core->remove_temporary_files;

    ok(
        !$file_manager->exists($preview_file_path),
        'Preview file deleted successfully for CleanCompiledTemplateFiles task.'
    );
};

File::Path::rmtree($blog->site_path);
done_testing();
