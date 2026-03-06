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
use MT::Test::App;
use MT::ContentData::Validator;

$test_env->prepare_fixture('db');

my $blog_id = 1;
my $content_type_id;

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    my $ct = MT::Test::Permission->make_content_type(
        name    => 'test content data',
        blog_id => $blog_id,
    );
    my $cf_single_line_text_1 = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'single line text (1)',
        type            => 'single_line_text',
    );

    my $fields = [
        {   id        => $cf_single_line_text_1->id,
            order     => 1,
            type      => $cf_single_line_text_1->type,
            options   => { label => $cf_single_line_text_1->name },
            unique_id => $cf_single_line_text_1->unique_id,
        }
    ];
    $ct->fields($fields);
    $ct->save or die $ct->errstr;

    $content_type_id = $ct->id;
});

subtest 'Prepare validation tests' => sub {
    my $admin = MT::Author->load(1);

    subtest 'Add item of content_data' => sub {
        ok $content_type_id, "ContentType(id: ${content_type_id}) is valid.";
        my $content_data_type = "content_data_${content_type_id}";

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode          => 'view',
            type            => $content_data_type,
            content_type_id => $content_type_id,
            blog_id         => $blog_id,
            _type           => 'content_data',
        });

        $app->post_form_ok(
            'edit-content-type-data-form',
            {   data_label  => 'test-1',
            }
        );

        my @items = MT->model('content_data')->load({
            blog_id         => $blog_id,
            content_type_id => $content_type_id,
        });

        is scalar(@items), 1, "One content data prepared.";
    };
    subtest 'Verify added content_data' => sub {
        my $app = MT->instance;

        my @items = MT->model('content_data')->load({
            blog_id         => $blog_id,
            content_type_id => $content_type_id,
        });
        my $obj = $items[0];
        my $errors = MT::ContentData::Validator::verify_content_data($app, $obj->content_type, $obj);
        is $errors, undef, "Verified.";
    };
};

subtest 'Verify uninitialized fields.' => sub {
    subtest 'Add content fields' => sub {
        my $ct = MT->model('content_type')->load({
            id => $content_type_id,
        }) or die;

        my $cf_single_line_text_2 = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'single line text (2)',
            type            => 'single_line_text',
        );
        my $cf_multi_line_text = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'multi line text',
            type            => 'multi_line_text',
        );
        my $cf_number = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'number',
            type            => 'number',
        );
        my $cf_url = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'url',
            type            => 'url',
        );
        my $cf_embedded_text = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'embedded text',
            type            => 'embedded_text',
        );
        my $cf_datetime = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'date and time',
            type            => 'date_and_time',
        );
        my $cf_date = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'date_only',
            type            => 'date_only',
        );
        my $cf_time = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'time_only',
            type            => 'time_only',
        );
        my $cf_select_box = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'select box',
            type            => 'select_box',
        );
        my $cf_radio = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'radio button',
            type            => 'radio_button',
        );
        my $cf_checkbox = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'checkboxes',
            type            => 'checkboxes',
        );
        my $cf_list = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'list',
            type            => 'list',
        );
        my $cf_table = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'tables',
            type            => 'tables',
        );
        my $cf_tag = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'tags',
            type            => 'tags',
        );
        my $tag1 = MT::Test::Permission->make_tag( name => 'tag1' );
        my $tag2 = MT::Test::Permission->make_tag( name => 'tag2' );

        my $cf_category = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'categories',
            type            => 'categories',
        );
        my $category_set = MT::Test::Permission->make_category_set(
            blog_id => $ct->blog_id,
            name    => 'test category set',
        );
        my $category1 = MT::Test::Permission->make_category(
            blog_id         => $category_set->blog_id,
            category_set_id => $category_set->id,
            label           => 'category1',
        );
        my $category2 = MT::Test::Permission->make_category(
            blog_id         => $category_set->blog_id,
            category_set_id => $category_set->id,
            label           => 'category2',
        );

        my $cf_image = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'asset_image',
            type            => 'asset_image',
        );
        my $image1 = MT::Test::Permission->make_asset(
            class     => 'image',
            blog_id   => $blog_id,
            url       => 'http://narnia.na/nana/images/test.jpg',
            file_path => File::Spec->catfile(
                $ENV{MT_HOME}, "t", 'images', 'test.jpg'
            ),
            file_name    => 'test.jpg',
            file_ext     => 'jpg',
            image_width  => 640,
            image_height => 480,
            mime_type    => 'image/jpeg',
            label        => 'Sample Image 1',
            description  => 'Sample photo',
        );
        my $image2 = MT::Test::Permission->make_asset(
            class     => 'image',
            blog_id   => $blog_id,
            url       => 'http://narnia.na/nana/images/test2.jpg',
            file_path => File::Spec->catfile(
                $ENV{MT_HOME}, "t", 'images', 'test2.jpg'
            ),
            file_name    => 'test2.jpg',
            file_ext     => 'jpg',
            image_width  => 640,
            image_height => 480,
            mime_type    => 'image/jpeg',
            label        => 'Sample Image 2',
            description  => 'Sample photo',
        );

        my $child_ct = MT::Test::Permission->make_content_type(
            name    => 'test child content data',
            blog_id => $blog_id,
        );
        my $child_cd_01 = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $child_ct->id,
            author_id       => 1,
        );
        my $cf_ct = MT::Test::Permission->make_content_field(
            blog_id         => $blog_id,
            content_type_id => $ct->id,
            name            => 'content type',
            type            => 'content_type',
        );

        my @fields = @{ $ct->fields };
        push @fields, (
            {   id        => $cf_single_line_text_2->id,
                order     => 2,
                type      => $cf_single_line_text_2->type,
                options   => { label => $cf_single_line_text_2->name },
                unique_id => $cf_single_line_text_2->unique_id,
            },
            {   id        => $cf_multi_line_text->id,
                order     => 3,
                type      => $cf_multi_line_text->type,
                options   => { label => $cf_multi_line_text->name },
                unique_id => $cf_multi_line_text->unique_id,
            },
            {   id        => $cf_number->id,
                order     => 4,
                type      => $cf_number->type,
                options   => { label => $cf_number->name },
                unique_id => $cf_number->unique_id,
            },
            {   id        => $cf_url->id,
                order     => 5,
                type      => $cf_url->type,
                options   => { label => $cf_url->name },
                unique_id => $cf_url->unique_id,
            },
            {   id        => $cf_embedded_text->id,
                order     => 6,
                type      => $cf_embedded_text->type,
                options   => { label => $cf_embedded_text->name },
                unique_id => $cf_embedded_text->unique_id,
            },
            {   id        => $cf_datetime->id,
                order     => 7,
                type      => $cf_datetime->type,
                options   => { label => $cf_datetime->name },
                unique_id => $cf_datetime->unique_id,
            },
            {   id        => $cf_date->id,
                order     => 8,
                type      => $cf_date->type,
                options   => { label => $cf_date->name },
                unique_id => $cf_date->unique_id,
            },
            {   id        => $cf_time->id,
                order     => 9,
                type      => $cf_time->type,
                options   => { label => $cf_time->name },
                unique_id => $cf_time->unique_id,
            },
            {   id      => $cf_select_box->id,
                order   => 10,
                type    => $cf_select_box->type,
                options => {
                    label  => $cf_select_box->name,
                    values => [
                        { label => 'abc', value => 1 },
                        { label => 'def', value => 2 },
                        { label => 'ghi', value => 3 },
                    ],
                },
                unique_id => $cf_select_box->unique_id,
            },
            {   id      => $cf_radio->id,
                order   => 11,
                type    => $cf_radio->type,
                options => {
                    label  => $cf_radio->name,
                    values => [
                        { label => 'abc', value => 1 },
                        { label => 'def', value => 2 },
                        { label => 'ghi', value => 3 },
                    ],
                },
                unique_id => $cf_radio->unique_id,
            },
            {   id      => $cf_checkbox->id,
                order   => 12,
                type    => $cf_checkbox->type,
                options => {
                    label  => $cf_checkbox->name,
                    values => [
                        { label => 'abc', value => 1 },
                        { label => 'def', value => 2 },
                        { label => 'ghi', value => 3 },
                    ],
                },
                unique_id => $cf_checkbox->unique_id,
            },
            {   id      => $cf_list->id,
                order   => 13,
                type    => $cf_list->type,
                options => { label => $cf_list->name },
            },
            {   id      => $cf_table->id,
                order   => 14,
                type    => $cf_table->type,
                options => {
                    label        => $cf_table->name,
                    initial_rows => 3,
                    initial_cols => 3,
                },
            },
            {   id      => $cf_tag->id,
                order   => 15,
                type    => $cf_tag->type,
                options => {
                    label    => $cf_tag->name,
                },
            },
            {   id      => $cf_category->id,
                order   => 16,
                type    => $cf_category->type,
                options => {
                    label        => $cf_category->name,
                    category_set => $category_set->id,
                },
            },
            {   id      => $cf_image->id,
                order   => 17,
                type    => $cf_image->type,
                options => {
                    label    => $cf_image->name,
                },
            },
            {   id      => $cf_ct->id,
                order   => 18,
                type    => $cf_ct->type,
                options => {
                    label    => $cf_ct->name,
                    source   => $child_ct->id,
                },
            },
        );

        $ct->fields(\@fields);
        $ct->save or die $ct->errstr;

        is scalar(@{ $ct->fields }), 18, "New fields added.";
    };
    subtest 'Verify content_data' => sub {
        my $app = MT->instance;

        my @items = MT->model('content_data')->load({
            blog_id         => $blog_id,
            content_type_id => $content_type_id,
        });
        my $obj = $items[0];
        my $errors = MT::ContentData::Validator::verify_content_data($app, $obj->content_type, $obj);
        is $errors, undef, "Verified.";
    };
};

subtest 'Verify content data including required fields' => sub {
    subtest 'Change all fields to required' => sub {
        my $ct = MT->model('content_type')->load({
            id => $content_type_id,
        }) or die;

        my $fields = $ct->fields;
        for my $f ( @{$fields} ) {
            $f->{options}->{required} = 1;
        }

        $ct->fields($fields);
        $ct->save or die $ct->errstr;

        my $field_objs = $ct->field_objs;
        my $number_of_required = grep {
            $_->options->{required};
        } @{$field_objs};

        is scalar(@{$field_objs}), $number_of_required, "All fields changed.";
    };
    subtest 'Verify content_data' => sub {
        my $app = MT->instance;

        my @items = MT->model('content_data')->load({
            blog_id         => $blog_id,
            content_type_id => $content_type_id,
        });
        my $obj = $items[0];
        my $errors = MT::ContentData::Validator::verify_content_data($app, $obj->content_type, $obj);
        ok @{ $errors }, "Exists errors.";

        my $fields = $obj->content_type->fields;
        is scalar(@{$errors}), scalar(@{$fields}), "All fields are invalid.";
    };
};

done_testing;
