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
my $cf_multi = MT::Test::Permission->make_content_field(
    blog_id         => 1,
    content_type_id => $content_type->id,
    name            => 'multi',
    type            => 'multi_line_text',
    description            => 'This is a sample multi_line_text field.',
);

$content_type->fields(
    [ { id        => $cf_multi->id,
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
    data            => { $cf_multi->id => 'multi line text' },
    identifier      => 'my content data',
    status          => MT::ContentStatus::RELEASE(),
);

MT->add_callback(
    'cms_pre_preview',
    1, undef,
    sub {
        my ($cb, $app, $obj, $data) = @_;
        if (my $class = ref($obj)) {
            my $ds = $class->datasource;
            my $data;
            $data = MT->model($ds)->load($obj->id);
            my $saved = $data->save;
            ok($saved,
                "saving $class succeeded in  callback");
            warn $data->errstr unless $saved;
        }
    }
);

my ($app, $out);

# This is to check the value of the hidden tag.
# It is for checking the pull down value of multiple line text in PreviewInNewWindow 0
subtest 'review from Content Data edit by PreviewInNewWindow mode 0' => sub {
    my $type = 'multi-';
    my $base_field_name = 'content-field-' . $cf_multi->id;
    my $field_name = $base_field_name . $type . $cf_multi->id;
    my $field_convert_breaks = $base_field_name . '_convert_breaks';
    my $input_format = '<input\stype="hidden"\sname="%s"\svalue="%s"\s\/>';

    my $ref_parameter = {
        __test_user           => $admin,
        __request_method      => 'POST',
        __mode                => 'preview_content_data',
        blog_id               => $blog->id,
        content_type_id       => $content_type->id,
        id                    => $cd1->id,
        data_label            => 'PreviewInNewWindow 0',
        $field_name           => 'PreviewInNewWindow0',
        $field_convert_breaks => 'markdown',
        authored_on_date      => '20190215',
        authored_on_time      => '000000',
        unpublished_on_date   => '20190216',
        unpublished_on_time   => '000000',
        rev_numbers           => '0,0',
    };

    $app = _run_app( 'MT::App::CMS', $ref_parameter );
    $out = delete $app->{__test_output};

    my $format = sprintf(
        $input_format,
        $field_convert_breaks,
        $ref_parameter->{$field_convert_breaks}
    );

    ok( $out, "get template succeeded.");
    ok( $out =~ m/$format/, "$field_convert_breaks Tag creation succeeded .");
};
done_testing;