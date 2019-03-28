#!/usr/bin/perl

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

use MT::Test::Tag;

plan tests => 2 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

my $vars = {};

sub var {
    for my $line (@_) {
        for my $key ( keys %{$vars} ) {
            my $replace = quotemeta "[% ${key} %]";
            my $value   = $vars->{$key};
            $line =~ s/$replace/$value/g;
        }
    }
    @_;
}

filters {
    template       => [qw( var chomp )],
    expected       => [qw( var chomp )],
    expected_error => [qw( chomp )],
};

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $ct = MT::Test::Permission->make_content_type(
            name    => 'test content data',
            blog_id => $blog_id,
        );
        my $ct2 = MT::Test::Permission->make_content_type(
            name    => 'Content Type',
            blog_id => $blog_id,
        );
        my $cf_content_type = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct2->id,
            name            => 'content type',
            type            => 'content_type',
        );
        my $cf_single_line_text = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'single line text',
            type            => 'single_line_text',
        );
        my $cf_single_line_text_no_data
            = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'single line text no data',
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

        my $fields = [
            {   id        => $cf_single_line_text->id,
                order     => 1,
                type      => $cf_single_line_text->type,
                options   => { label => $cf_single_line_text->name },
                unique_id => $cf_single_line_text->unique_id,
            },
            {   id        => $cf_single_line_text_no_data->id,
                order     => 1,
                type      => $cf_single_line_text_no_data->type,
                options   => { label => $cf_single_line_text_no_data->name },
                unique_id => $cf_single_line_text_no_data->unique_id,
            },
            {   id        => $cf_multi_line_text->id,
                order     => 2,
                type      => $cf_multi_line_text->type,
                options   => { label => $cf_multi_line_text->name },
                unique_id => $cf_multi_line_text->unique_id,
            },
            {   id        => $cf_number->id,
                order     => 3,
                type      => $cf_number->type,
                options   => { label => $cf_number->name },
                unique_id => $cf_number->unique_id,
            },
            {   id        => $cf_url->id,
                order     => 4,
                type      => $cf_url->type,
                options   => { label => $cf_url->name },
                unique_id => $cf_url->unique_id,
            },
            {   id        => $cf_embedded_text->id,
                order     => 5,
                type      => $cf_embedded_text->type,
                options   => { label => $cf_embedded_text->name },
                unique_id => $cf_embedded_text->unique_id,
            },
            {   id        => $cf_datetime->id,
                order     => 6,
                type      => $cf_datetime->type,
                options   => { label => $cf_datetime->name },
                unique_id => $cf_datetime->unique_id,
            },
            {   id        => $cf_date->id,
                order     => 7,
                type      => $cf_date->type,
                options   => { label => $cf_date->name },
                unique_id => $cf_date->unique_id,
            },
            {   id        => $cf_time->id,
                order     => 8,
                type      => $cf_time->type,
                options   => { label => $cf_time->name },
                unique_id => $cf_time->unique_id,
            },
            {   id      => $cf_select_box->id,
                order   => 9,
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
                order   => 10,
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
                order   => 11,
                type    => $cf_checkbox->type,
                options => {
                    label  => $cf_checkbox->name,
                    values => [
                        { label => 'abc', value => 1 },
                        { label => 'def', value => 2 },
                        { label => 'ghi', value => 3 },
                    ],
                    multiple => 1,
                    max      => 3,
                    min      => 1,
                },
                unique_id => $cf_checkbox->unique_id,
            },
            {   id        => $cf_list->id,
                order     => 12,
                type      => $cf_list->type,
                options   => { label => $cf_list->name },
                unique_id => $cf_list->unique_id,
            },
            {   id      => $cf_table->id,
                order   => 13,
                type    => $cf_table->type,
                options => {
                    label        => $cf_table->name,
                    initial_row  => 3,
                    initial_cols => 3,
                },
                unique_id => $cf_table->unique_id,
            },
            {   id      => $cf_tag->id,
                order   => 14,
                type    => $cf_tag->type,
                options => {
                    label    => $cf_tag->name,
                    multiple => 1,
                    max      => 5,
                    min      => 1,
                },
                unique_id => $cf_tag->unique_id,
            },
            {   id      => $cf_category->id,
                order   => 15,
                type    => $cf_category->type,
                options => {
                    label        => $cf_category->name,
                    category_set => $category_set->id,
                    multiple     => 1,
                    max          => 5,
                    min          => 1,
                },
                unique_id => $cf_category->unique_id,
            },
            {   id      => $cf_image->id,
                order   => 16,
                type    => $cf_image->type,
                options => {
                    label    => $cf_image->name,
                    multiple => 1,
                    max      => 5,
                    min      => 1,
                    multiple => 1,
                    max      => 5,
                    min      => 1,
                },
                unique_id => $cf_image->unique_id,
            },
            {   id      => $cf_content_type->id,
                order   => 17,
                type    => $cf_content_type->type,
                options => {
                    label  => $cf_content_type->name,
                    source => $ct2->id,
                },
                unique_id => $cf_content_type->unique_id,
            },
        ];
        $ct->fields($fields);
        $ct->save or die $ct->errstr;
        $ct2->fields(
            [   {   id        => $cf_single_line_text->id,
                    order     => 1,
                    type      => $cf_single_line_text->type,
                    options   => { label => $cf_single_line_text->name },
                    unique_id => $cf_single_line_text->unique_id,
                },
                {   id    => $cf_single_line_text_no_data->id,
                    order => 2,
                    type  => $cf_single_line_text_no_data->type,
                    options =>
                        { label => $cf_single_line_text_no_data->name },
                    unique_id => $cf_single_line_text_no_data->unique_id,
                },
                {   id        => $cf_number->id,
                    order     => 3,
                    type      => $cf_number->type,
                    options   => { label => $cf_number->name },
                    unique_id => $cf_number->unique_id,
                },
            ]
        );
        $ct2->save or die $ct2->errstr;
        my $cd2 = MT::Test::Permission->make_content_data(
            blog_id         => $ct->blog_id,
            content_type_id => $ct2->id,
            author_id       => 1,
            data            => {
                $cf_single_line_text->id         => 'test single line text2',
                $cf_single_line_text_no_data->id => '',
                $cf_number->id                   => '12345',
            },
        );
        my $invalid_obj_id = 1000;    # MTC-26364
        my $cd = MT::Test::Permission->make_content_data(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            author_id       => 1,
            data            => {
                $cf_single_line_text->id         => 'test single line text',
                $cf_single_line_text_no_data->id => '',
                $cf_multi_line_text->id => "test multi line text\naaaaa",
                $cf_number->id          => '12345',
                $cf_url->id             => 'https://example.com/~abby',
                $cf_embedded_text->id   => "abc\ndef",
                $cf_datetime->id        => '20170603180500',
                $cf_date->id            => '20170605000000',
                $cf_time->id            => '19700101123456',
                $cf_select_box->id      => [2],
                $cf_radio->id           => [3],
                $cf_checkbox->id        => [ 1, 3 ],
                $cf_list->id            => [ 'aaa', 'bbb', 'ccc' ],
                $cf_table->id => "<tr><td>1</td><td></td><td></td></tr>\n"
                    . "<tr><td></td><td>2</td><td></td></tr>\n"
                    . "<tr><td></td><td></td><td>3</td></tr>",
                $cf_tag->id => [ $tag2->id, $tag1->id, $invalid_obj_id ],
                $cf_category->id =>
                    [ $category2->id, $category1->id, $invalid_obj_id ],
                $cf_image->id =>
                    [ $image2->id, $image1->id, $invalid_obj_id ],
                $cf_content_type->id => [ $cd2->id, $invalid_obj_id ],
            },
        );

        #MTC-25873
        my $content_type_case0 = MT::Test::Permission->make_content_type(
            name    => 'case 0',
            blog_id => $blog_id,
        );

        my $single_line_text_case0 = MT::Test::Permission->make_content_field(
            blog_id         => $content_type_case0->blog_id,
            content_type_id => $content_type_case0->id,
            name            => 'single_line_text',
            type            => 'single_line_text',
        );

        my $multi_line_text_case0 = MT::Test::Permission->make_content_field(
            blog_id         => $content_type_case0->blog_id,
            content_type_id => $content_type_case0->id,
            name            => 'multi_line_text',
            type            => 'multi_line_text',
        );

        my $number_case0 = MT::Test::Permission->make_content_field(
            blog_id         => $content_type_case0->blog_id,
            content_type_id => $content_type_case0->id,
            name            => 'number',
            type            => 'number',
        );

        my $embedded_text_case0 = MT::Test::Permission->make_content_field(
            blog_id         => $content_type_case0->blog_id,
            content_type_id => $content_type_case0->id,
            name            => 'embedded_text',
            type            => 'embedded_text',
        );

        my $select_box_case0 = MT::Test::Permission->make_content_field(
            blog_id         => $content_type_case0->blog_id,
            content_type_id => $content_type_case0->id,
            name            => 'select_box',
            type            => 'select_box',
        );
        my $radio_case0 = MT::Test::Permission->make_content_field(
            blog_id         => $content_type_case0->blog_id,
            content_type_id => $content_type_case0->id,
            name            => 'radio_button',
            type            => 'radio_button',
        );
        my $checkbox_case0 = MT::Test::Permission->make_content_field(
            blog_id         => $content_type_case0->blog_id,
            content_type_id => $content_type_case0->id,
            name            => 'checkboxes',
            type            => 'checkboxes',
        );
        my $list_case0 = MT::Test::Permission->make_content_field(
            blog_id         => $content_type_case0->blog_id,
            content_type_id => $content_type_case0->id,
            name            => 'list',
            type            => 'list',
        );
        my $table_case0 = MT::Test::Permission->make_content_field(
            blog_id         => $content_type_case0->blog_id,
            content_type_id => $content_type_case0->id,
            name            => 'tables',
            type            => 'tables',
        );
        my $tag0 = MT::Test::Permission->make_tag( name => '0' );
        my $tag_case0 = MT::Test::Permission->make_content_field(
            blog_id         => $content_type_case0->blog_id,
            content_type_id => $content_type_case0->id,
            name            => 'tags',
            type            => 'tags',
        );
        my $multi_tag_case0 = MT::Test::Permission->make_content_field(
            blog_id         => $content_type_case0->blog_id,
            content_type_id => $content_type_case0->id,
            name            => 'multi_tags',
            type            => 'tags',
        );

        my $category_set_case0 = MT::Test::Permission->make_category_set(
            blog_id => $content_type_case0->blog_id,
            name    => 'category set 0',
        );

        my $category0 = MT::Test::Permission->make_category(
            blog_id         => $category_set_case0->blog_id,
            category_set_id => $category_set_case0->id,
            label           => '0',
        );

        my $category_case0 = MT::Test::Permission->make_content_field(
            blog_id         => $content_type_case0->blog_id,
            content_type_id => $content_type_case0->id,
            name            => 'categories',
            type            => 'categories',
        );

        my $multi_category_case0 = MT::Test::Permission->make_content_field(
            blog_id         => $content_type_case0->blog_id,
            content_type_id => $content_type_case0->id,
            name            => 'multi_categories',
            type            => 'categories',
        );

        my $fields_case0 = [
            {   id        => $single_line_text_case0->id,
                order     => 1,
                type      => $single_line_text_case0->type,
                options   => { label => $single_line_text_case0->name },
                unique_id => $single_line_text_case0->unique_id,
            },
            {   id        => $multi_line_text_case0->id,
                order     => 2,
                type      => $multi_line_text_case0->type,
                options   => { label => $multi_line_text_case0->name },
                unique_id => $multi_line_text_case0->unique_id,
            },
            {   id        => $number_case0->id,
                order     => 3,
                type      => $number_case0->type,
                options   => { label => $number_case0->name },
                unique_id => $number_case0->unique_id,
            },
            {   id        => $embedded_text_case0->id,
                order     => 5,
                type      => $embedded_text_case0->type,
                options   => { label => $embedded_text_case0->name },
                unique_id => $embedded_text_case0->unique_id,
            },
            {   id      => $select_box_case0->id,
                order   => 9,
                type    => $select_box_case0->type,
                options => {
                    label  => $select_box_case0->name,
                    values => [
                        { label => '0', value => 0 },
                    ],
                },
                unique_id => $select_box_case0->unique_id,
            },
            {   id      => $radio_case0->id,
                order   => 10,
                type    => $radio_case0->type,
                options => {
                    label  => $radio_case0->name,
                    values => [
                        { label => '0', value => 0 },
                        { label => '0', value => 1 },
                        { label => '0', value => 2 },
                    ],
                },
                unique_id => $radio_case0->unique_id,
            },
            {   id      => $checkbox_case0->id,
                order   => 11,
                type    => $checkbox_case0->type,
                options => {
                    label  => $checkbox_case0->name,
                    values => [
                        { label => '0', value => 0 },
                        { label => '0', value => 1 },
                        { label => '0', value => 2 },
                    ],
                    multiple => 1,
                    max      => 3,
                    min      => 1,
                },
                unique_id => $checkbox_case0->unique_id,
            },
            {   id      => $list_case0->id,
                order   => 12,
                type    => $list_case0->type,
                options => { label => $list_case0->name },
            },
            {   id      => $table_case0->id,
                order   => 13,
                type    => $table_case0->type,
                options => {
                    label        => $table_case0->name,
                    initial_row  => 3,
                    initial_cols => 3,
                },
            },
            {   id      => $tag_case0->id,
                order   => 14,
                type    => $tag_case0->type,
                options => {
                    label    => $tag_case0->name,
                    multiple => 0,
                    max      => 5,
                    min      => 1,
                },
            },
            {   id      => $multi_tag_case0->id,
                order   => 14,
                type    => $multi_tag_case0->type,
                options => {
                    label    => $multi_tag_case0->name,
                    multiple => 1,
                    max      => 5,
                    min      => 1,
                },
            },
            {   id      => $category_case0->id,
                order   => 15,
                type    => $category_case0->type,
                options => {
                    label        => $category_case0->name,
                    category_set => $category_set_case0->id,
                    multiple     => 0,
                    max          => 5,
                    min          => 1,
                },
                unique_id => $category_case0->unique_id,
            },
            {   id      => $multi_category_case0->id,
                order   => 16,
                type    => $multi_category_case0->type,
                options => {
                    label        => $multi_category_case0->name,
                    category_set => $category_set_case0->id,
                    multiple     => 1,
                    max          => 5,
                    min          => 1,
                },
            },
        ];

        $content_type_case0->fields($fields_case0);
        $content_type_case0->save or die $content_type_case0->errstr;

        my $content_data_case0 = MT::Test::Permission->make_content_data(
            blog_id         => $content_type_case0->blog_id,
            content_type_id => $content_type_case0->id,
            author_id       => 1,
            label      => '0',
            data            => {
                $single_line_text_case0->id => '0',
                $multi_line_text_case0->id  => "0",
                $number_case0->id           => '0',
                $embedded_text_case0->id    => "0",
                $select_box_case0->id       => "0",
                $radio_case0->id            => "0",
                $checkbox_case0->id         => "0",
                $table_case0->id            => "<tr><th>0</th><td>0</td></tr>"
                    . "<tr><td>0</td><td>0</td></tr>",
                $tag_case0->id              => [ $tag0->id ],
                $category_case0->id  => [ $category0->id ],
                $multi_tag_case0->id        => [ $tag0->id ],
                $multi_category_case0->id   => [ $category0->id ],
                $list_case0->id             => [ '0' ],
            },
        );
        $content_data_case0->convert_breaks(
            MT::Serialize->serialize(
                \{ $multi_line_text_case0->id => 0 }
            )
        );
        $content_data_case0->save or die $content_data_case0->errstr;;

    }
);

my $cf = MT->model('cf')->load( { name => 'single line text' } );

$vars->{cf_unique_id} = $cf->unique_id;
$vars->{cf_name}      = $cf->name;
$vars->{cf_id}        = $cf->id;

MT::Test::Tag->run_perl_tests($blog_id);

MT::Test::Tag->run_php_tests($blog_id);

__END__

=== mt:ContentField without contents context
--- template
<mt:ContentField content_field="single line text"><mt:var name="__value__"></mt:ContentField>
--- expected_error
No Content Type could be found.

=== mt:ContentField content_field="single line text" (unique_id)
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="[% cf_unique_id %]"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
test single line text
Footer

=== mt:ContentField content_field="single line text" (name)
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="[% cf_name %]"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
test single line text
Footer

=== mt:ContentField content_field="single line text" (id)
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="[% cf_id %]"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
test single line text
Footer

=== mt:ContentField with mt:Else
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="single line text no data">
<mt:var name="__value__"><mt:Else>no data
</mt:ContentField></mt:Contents>
--- expected
no data

=== mt:ContentField without content_field modifier (use first field)
--- template
<mt:Contents content_type="test content data"><mt:ContentField><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
test single line text
Footer

=== mt:ContentField no data
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="no_data"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected_error
Error in <mtContentField> tag: No Content Field could be found: "no_data"
--- expected_php_error
No Content Field could be found: "no_data"

=== mt:ContentField content_field="multi line text"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="multi line text"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
test multi line text
aaaaa
Footer

=== mt:ContentField content_field="number"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="number"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
12345
Footer

=== mt:ContentField content_field="url"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="url"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
https://example.com/~abby
Footer

=== mt:ContentField content_field="embedded text"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="embedded text"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
abc
def
Footer

=== mt:ContentField content_field="date and time"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="date and time"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:ContentFieldValue>
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
June  3, 2017  6:05 PM
Footer

=== mt:ContentField content_field="date and time" format_name="iso8601"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="date and time"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:ContentFieldValue format_name="iso8601">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
2017-06-03T18:05:00+00:00
Footer

=== mt:ContentField content_field="date_only"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="date_only"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:ContentFieldValue>
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
June  5, 2017
Footer

=== mt:ContentField content_field="date_only" format_name="iso8601"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="date_only"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:ContentFieldValue format_name="iso8601">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
2017-06-05T00:00:00+00:00
Footer

=== mt:ContentField content_field="time_only"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="time_only"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:ContentFieldValue>
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
12:34 PM
Footer

=== mt:ContentField content_field="time_only" format_name="iso8601"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="time_only"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:ContentFieldValue format_name="iso8601">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
1970-01-01T12:34:56+00:00
Footer

=== mt:ContentField content_field="select box"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="select box"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__key__">,<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
def,2
Footer

=== mt:ContentField content_field="radio button"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="radio button"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__key__">,<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
ghi,3
Footer

=== mt:ContentField content_field="checkboxes"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="checkboxes"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__key__">,<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
abc,1

ghi,3
Footer

=== mt:ContentField content_field="list"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="list" glue=":"><mt:ContentFieldHeader>Header:</mt:ContentFieldHeader><mt:var name="__value__"><mt:ContentFieldFooter>:Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header:aaa:bbb:ccc:Footer

=== mt:ContentField content_field="tables"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="tables"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
<table>
<tr><td>1</td><td></td><td></td></tr>
<tr><td></td><td>2</td><td></td></tr>
<tr><td></td><td></td><td>3</td></tr>
</table>
Footer

=== mt:ContentField content_field="tags"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="tags"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:TagName>
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
tag2

tag1
Footer

=== mt:ContentField content_field="categories"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="categories"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:CategoryLabel>
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
category2

category1
Footer

=== mt:ContentField content_field="asset_image"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="asset_image"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:AssetLabel>
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
Sample Image 2

Sample Image 1
Footer

=== mt:ContentField content_field="content_type"
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="content type"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:ContentFields><mt:ContentField><mt:ContentFieldLabel>: <mt:ContentFieldValue></mt:ContentField>
</mt:ContentFields>
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
single line text: test single line text2

number: 12345

Footer

=== mt:ContentFieldLabel
--- template
<mt:Contents content_type="test content data"><mt:ContentFields><mt:ContentField><mt:ContentFieldHeader><mt:ContentFieldLabel></mt:ContentFieldHeader></mt:ContentField>
</mt:ContentFields></mt:Contents>
--- expected
single line text

multi line text
number
url
embedded text
date and time
date_only
time_only
select box
radio button
checkboxes
list
tables
tags
categories
asset_image
content type

=== mt:ContentFieldType
--- template
<mt:Contents content_type="test content data"><mt:ContentFields><mt:ContentField><mt:ContentFieldHeader><mt:ContentFieldType></mt:ContentFieldHeader></mt:ContentField>
</mt:ContentFields></mt:Contents>
--- expected
single_line_text

multi_line_text
number
url
embedded_text
date_and_time
date_only
time_only
select_box
radio_button
checkboxes
list
tables
tags
categories
asset_image
content_type

=== mt:ContentField single_line_text value 0
--- template
<mt:Contents content_type="case 0">
<mt:ContentField content_field="single_line_text"><mt:ContentFieldValue language="ja"></mt:ContentField>
</mt:Contents>
--- expected
0

=== mt:ContentField multi_line_text value 0
--- template
<mt:Contents content_type="case 0">
<mt:ContentField content_field="multi_line_text"><mt:ContentFieldValue language="ja"></mt:ContentField>
</mt:Contents>
--- expected
0

=== mt:ContentField number value 0
--- template
<mt:Contents content_type="case 0">
<mt:ContentField content_field="number"><mt:ContentFieldValue language="ja"></mt:ContentField>
</mt:Contents>
--- expected
0

=== mt:ContentField select_box value 0
--- template
<mt:Contents content_type="case 0">
<mt:ContentField content_field="select_box"><mt:ContentFieldValue language="ja"></mt:ContentField>
</mt:Contents>
--- expected
0

=== mt:ContentField radio_button value 0
--- template
<mt:Contents content_type="case 0">
<mt:ContentField content_field="radio_button"><mt:Var name="__key__">:<mt:ContentFieldValue language="ja"></mt:ContentField>
</mt:Contents>
--- expected
0:0

=== mt:ContentField checkboxes value 0
--- template
<mt:Contents content_type="case 0">
<mt:ContentField content_field="checkboxes"><mt:Var name="__key__">:<mt:ContentFieldValue language="ja"></mt:ContentField>
</mt:Contents>
--- expected
0:0

=== mt:ContentField embedded_text value 0
--- template
<mt:Contents content_type="case 0">
<mt:ContentField content_field="embedded_text"><mt:ContentFieldValue language="ja"></mt:ContentField>
</mt:Contents>
--- expected
0

=== mt:ContentField list value 0
--- template
<mt:Contents content_type="case 0">
<mt:ContentField content_field="list"><mt:ContentFieldValue language="ja"></mt:ContentField>
</mt:Contents>
--- expected
0

=== mt:ContentField categories label value
--- template
<mt:Contents content_type="case 0">
<mt:ContentField content_field="categories"><mt:CategoryLabel></mt:ContentField>
</mt:Contents>
--- expected
0

=== mt:ContentField multi categories label value
--- template
<mt:Contents content_type="case 0">
<mt:ContentField content_field="multi_categories"><mt:CategoryLabel></mt:ContentField>
</mt:Contents>
--- expected
0

=== mt:ContentField tag label value
--- template
<mt:Contents content_type="case 0">
<mt:ContentField content_field="tags"><mt:TagLabel></mt:ContentField>
</mt:Contents>
--- expected
0

=== mt:ContentField multi tag label value
--- template
<mt:Contents content_type="case 0">
<mt:ContentField content_field="multi_tags"><mt:TagLabel></mt:ContentField>
</mt:Contents>
--- expected
0

=== mt:ContentField table value
--- template
<mt:Contents content_type="case 0">
<mt:ContentField content_field="tables"><mt:ContentFieldValue language="ja"></mt:ContentField>
</mt:Contents>
--- expected
<table>
<tr><th>0</th><td>0</td></tr><tr><td>0</td><td>0</td></tr>
</table>
