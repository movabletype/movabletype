#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        PreviewInNewWindow => 0,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

$test_env->prepare_fixture('db');

my $blog_id = 1;
my $blog = MT::Blog->load($blog_id);

my $admin = MT::Author->load(1);

# Content
my $content_type
    = MT::Test::Permission->make_content_type(blog_id => $blog_id);
my $cf = MT::Test::Permission->make_content_field(
    blog_id         => 1,
    content_type_id => $content_type->id,
);

my $cf_multi = MT::Test::Permission->make_content_field(
    blog_id         => 1,
    content_type_id => $content_type->id,
    name            => 'multi',
    type            => 'multi_line_text',
    description            => 'This is a sample multi_line_text field.',
);

$content_type->fields(
    [
        {
            id        => $cf->id,
            name      => $cf->name,
            options   => { label => $cf->name, },
            order     => 1,
            type      => $cf->type,
            unique_id => $cf->unique_id,
        },
        { id        => $cf_multi->id,
            name      => $cf_multi->name,
            options   => { label => $cf_multi->name, },
            order     => 1,
            type      => $cf_multi->type,
            unique_id => $cf_multi->unique_id,
        },
    ]
);

$content_type->save or die $content_type->errstr;

my $cd1 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $content_type->id,
    label           => 'label',
    data            => { $cf->id => 'multi line text test' },
    identifier      => 'my content data',
    status          => MT::ContentStatus::RELEASE(),
);

MT->add_callback(
    'cms_edit',
    1, undef,
    sub {
        my ($cb, $app, $obj, $data) = @_;
        if (my $class = ref($obj)) {
            my $ds = $class->datasource;
            my $data;
            $data = MT->model($ds)->load($obj->id);
            my $saved = $data->save;
            ok($saved,
                "saving $class succeeded in callback");
            warn $data->errstr unless $saved;
        }
    }
);

my ($app, $out);

subtest 'edit by mode view_content_data' => sub {
    my $ref_parameter = {
        __test_user      => $admin,
        __request_method => 'GET',
        __mode           => 'view_content_data',
        blog_id          => $blog->id,
        content_type_id  => $content_type->id,
    };
    $app = _run_app( 'MT::App::CMS', $ref_parameter );
    $out = delete $app->{__test_output};

    ok ($out =~ m/<p class="zero-state">/, 'Content Data template creation succeeded');
};

subtest 'edit by mode edit_content_data' => sub {
    my $ref_parameter = {
        __test_user           => $admin,
        __request_method      => 'GET',
        __mode                => 'edit_content_data',
        blog_id               => $blog->id,
        content_type_id       => $content_type->id,
        id                    => $cd1->id,
    };

    $app = _run_app( 'MT::App::CMS', $ref_parameter );
    $out = delete $app->{__test_output};

    ok ($out !~ m/<p class="zero-state">/, 'Content Data template creation succeeded');
};

subtest 'edit from preview' => sub {
    my $convert_breaks_field_name = 'content-field-' . $cf_multi->id . '_convert_breaks';
    my $ref_parameter = {
        __test_user      => $admin,
        __request_method => 'POST',
        __mode           => 'edit_content_data',
        _type            => 'content_data',
        blog_id          => $blog->id,
        content_type_id  => $content_type->id,
        id               => $cd1->id,
        from_preview     => 1,
        status          => MT::ContentStatus::RELEASE(),
        data_label => 'from preview',
        authored_on_date => '20190304',
        authored_on_time => '00:00:00',
        basename_manual => 0,
        unpublished_on_date=>'20200909',
        unpublished_on_time => '00:00:00',
        $convert_breaks_field_name =>  'markdown',
        reedit => 'reedit',
    };

    $app = _run_app( 'MT::App::CMS', $ref_parameter );
    $out = delete $app->{__test_output};

    ok($out =~ m/<option value="markdown" selected="selected">/, 'parameter setting succeeded.');
    ok($out =~ m/(name="data_label" value="from preview")/, 'Returned parameter setting succeeded.');
};

subtest 'edit by error' => sub {
    my $convert_breaks_field_name = 'content-field-' . $cf_multi->id . '_convert_breaks';
    my $ref_parameter = {
        __test_user                => $admin,
        __request_method           => 'POST',
        __mode                     => 'edit_content_data',
        _type                      => 'content_data',
        blog_id                    => $blog->id,
        content_type_id            => $content_type->id,
        id                         => $cd1->id,
        from_preview               => 1,
        status                     => MT::ContentStatus::RELEASE(),
        data_label                 => 'from preview',
        authored_on_date           => '20190304',
        authored_on_time           => '00:00:00',
        basename_manual            => 0,
        unpublished_on_date        => '20200909',
        unpublished_on_time        => '00:00:00',
        $convert_breaks_field_name => 'markdown',
        reedit                     => 'reedit',
        had_error                  => 1,
        err_msg                    => 'Error Content Data Edit',
    };

    $app = _run_app( 'MT::App::CMS', $ref_parameter );
    $out = delete $app->{__test_output};

    ok($out =~ m/<option value="markdown" selected="selected">/, 'parameter setting succeeded.');
    ok($out =~ m/(name="data_label" value="from preview")/, 'Returned parameter setting succeeded.');

};

subtest 'edit from preview by _convert_breaks value 0' => sub {
    my $convert_breaks_field_name = 'content-field-' . $cf_multi->id . '_convert_breaks';
    my $ref_parameter = {
        __test_user      => $admin,
        __request_method => 'POST',
        __mode           => 'edit_content_data',
        _type            => 'content_data',
        blog_id          => $blog->id,
        content_type_id  => $content_type->id,
        id               => $cd1->id,
        from_preview     => 1,
        status          => MT::ContentStatus::RELEASE(),
        data_label => 'from preview',
        authored_on_date => '20190304',
        authored_on_time => '00:00:00',
        basename_manual => 0,
        unpublished_on_date=>'20200909',
        unpublished_on_time => '00:00:00',
        $convert_breaks_field_name =>  '0',
        reedit => 'reedit',
    };

    $app = _run_app( 'MT::App::CMS', $ref_parameter );
    $out = delete $app->{__test_output};

    ok($out =~ m/<option value="0" selected="selected">/, 'parameter setting succeeded.');
    ok($out =~ m/(name="data_label" value="from preview")/, 'Returned parameter setting succeeded.');
};

done_testing();