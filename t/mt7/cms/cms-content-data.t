use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
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
$test_env->prepare_fixture('db_data');

my $blog_id = 1;

my $ct_without_archive = MT::Test::Permission->make_content_type(
    blog_id => $blog_id,
    name    => 'ct without ct archive',
);

my $ct_with_archive = MT::Test::Permission->make_content_type(
    blog_id => $blog_id,
    name    => 'ct with ct archive',
);
my $ct_archive = MT::Test::Permission->make_template(
    blog_id         => $ct_with_archive->blog_id,
    content_type_id => $ct_with_archive->id,
    name            => 'Content Type with content_type archive',
    type            => 'ct',
);
MT::Test::Permission->make_templatemap(
    blog_id       => $ct_archive->blog_id,
    template_id   => $ct_archive->id,
    archive_type  => 'ContentType',
    file_template => 'author/%-a/%-f',
    is_preferred  => 1,
);

my $admin = MT->model('author')->load(1) or die MT->model('author')->errstr;

subtest 'preview without content_type archive' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user     => $admin,
            __mode          => 'preview_content_data',
            _type           => 'content_data',
            blog_id         => $ct_without_archive->blog_id,
            content_type_id => $ct_without_archive->id,
        },
    );
    my $out = delete $app->{__test_output};

    ok( $out,             'Request: preview_content_data' );
    ok( $out !~ /error/i, 'No error occurred' );
};

subtest 'preview with content_type archive' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user     => $admin,
            __mode          => 'preview_content_data',
            _type           => 'content_data',
            blog_id         => $ct_with_archive->blog_id,
            content_type_id => $ct_with_archive->id,
        },
    );
    my $out = delete $app->{__test_output};

    ok( $out,                         'Request: preview_content_data' );
    ok( $out =~ /Status: 302 Found/i, 'Status: 302 Found' );
    ok( $out !~ /error|permission=1|dashboard=1/i, 'No error occurred' );
};

done_testing;

