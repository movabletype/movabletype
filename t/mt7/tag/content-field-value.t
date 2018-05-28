#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

plan tests => 1 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $ct = MT::Test::Permission->make_content_type(
            name    => 'test content data',
            blog_id => $blog_id,
        );
        my $cf_single_line_text = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'single line text',
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
            {   id      => $cf_list->id,
                order   => 12,
                type    => $cf_list->type,
                options => { label => $cf_list->name },
            },
            {   id      => $cf_table->id,
                order   => 13,
                type    => $cf_table->type,
                options => {
                    label        => $cf_table->name,
                    initial_row  => 3,
                    initial_cols => 3,
                },
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
            },
        ];
        $ct->fields($fields);
        $ct->save or die $ct->errstr;
        my $cd01 = MT::Test::Permission->make_content_data(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            author_id       => 1,
            data            => {
                $cf_single_line_text->id => 'test single line text',
                $cf_multi_line_text->id  => "test multi line text\naaaaa",
                $cf_number->id           => '12345',
                $cf_url->id              => 'https://example.com/~abby',
                $cf_embedded_text->id    => "abc\ndef",
                $cf_datetime->id         => '20170603180500',
                $cf_date->id             => '20170605000000',
                $cf_time->id             => '19700101123456',
                $cf_select_box->id       => [2],
                $cf_radio->id            => [3],
                $cf_checkbox->id         => [ 1, 3 ],
                $cf_list->id             => [ 'aaa', 'bbb', 'ccc' ],
                $cf_table->id => "<tr><td>1</td><td></td><td></td></tr>\n"
                    . "<tr><td></td><td>2</td><td></td></tr>\n"
                    . "<tr><td></td><td></td><td>3</td></tr>",
                $cf_tag->id      => [ $tag2->id,      $tag1->id ],
                $cf_category->id => [ $category2->id, $category1->id ],
                $cf_image->id    => [ $image1->id,    $image2->id ],
            },
        );
        $cd01->convert_breaks(
            MT::Serialize->serialize(
                \{ $cf_multi_line_text->id => '__default__' }
            )
        );
        $cd01->save;
        my $cd02 = MT::Test::Permission->make_content_data(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            author_id       => 1,
            data            => {
                $cf_single_line_text->id => '',
                $cf_multi_line_text->id  => '',
                $cf_number->id           => '',
                $cf_url->id              => '',
                $cf_embedded_text->id    => '',
                $cf_datetime->id         => '',
                $cf_date->id             => '',
                $cf_time->id             => '',
                $cf_select_box->id       => [],
                $cf_radio->id            => [],
                $cf_checkbox->id         => [],
                $cf_list->id             => [],
                $cf_table->id            => '',
                $cf_tag->id              => [],
                $cf_category->id         => [],
                $cf_image->id            => [],
            },
        );

        # Relative
        my $ct2 = MT::Test::Permission->make_content_type(
            name    => 'test content data for relative',
            blog_id => $blog_id,
        );
        my $cf_relative_1 = MT::Test::Permission->make_content_field(
            blog_id         => $ct2->blog_id,
            content_type_id => $ct2->id,
            name            => 'relative_1',
            type            => 'date_and_time',
        );
        my $cf_relative_2 = MT::Test::Permission->make_content_field(
            blog_id         => $ct2->blog_id,
            content_type_id => $ct2->id,
            name            => 'relative_2',
            type            => 'date_and_time',
        );
        my $cf_relative_3 = MT::Test::Permission->make_content_field(
            blog_id         => $ct2->blog_id,
            content_type_id => $ct2->id,
            name            => 'relative_3',
            type            => 'date_and_time',
        );
        my $fields2 = [
            {   id        => $cf_relative_1->id,
                order     => 7,
                type      => $cf_relative_1->type,
                options   => { label => $cf_relative_1->name },
                unique_id => $cf_relative_1->unique_id,
            },
            {   id        => $cf_relative_2->id,
                order     => 7,
                type      => $cf_relative_2->type,
                options   => { label => $cf_relative_2->name },
                unique_id => $cf_relative_2->unique_id,
            },
            {   id        => $cf_relative_3->id,
                order     => 7,
                type      => $cf_relative_3->type,
                options   => { label => $cf_relative_3->name },
                unique_id => $cf_relative_3->unique_id,
            },
        ];
        $ct2->fields($fields2);
        $ct2->save or die $ct2->errstr;
        my $blog = MT->model('blog')->load($blog_id);
        my $now  = MT::Util::epoch2ts( $blog, time() - 3600 );
        my $cd03 = MT::Test::Permission->make_content_data(
            blog_id         => $ct2->blog_id,
            content_type_id => $ct2->id,
            author_id       => 1,
            data            => {
                $cf_relative_1->id => $now,
                $cf_relative_2->id => $now,
                $cf_relative_3->id => $now,
            },
        );

    }
);

MT::Test::Tag->run_perl_tests($blog_id);

# MT::Test::Tag->run_php_tests($blog_id);

__END__

=== mt:ContentFieldValue with mt:Else
--- template
<mt:Contents content_type="test content data" limit="1"><mt:ContentFields><mt:ContentField glue=","><mt:ContentFieldValue><mt:Else>Empty</mt:ContentField>
</mt:ContentFields></mt:Contents>
--- expected
Empty
Empty
Empty
Empty
Empty
Empty
Empty
Empty
Empty
Empty
Empty
Empty
Empty
Empty
Empty
Empty

=== mt:ContentFieldValue no glue
--- template
<mt:Contents content_type="test content data" offset="1" limit="1"><mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField>
</mt:ContentFields></mt:Contents>
--- expected
test single line text
test multi line text
aaaaa
12345
https://example.com/~abby
abc
def
June  3, 2017  6:05 PM
June  5, 2017
12:34 PM
2
3
13
aaabbbccc
<table>
<tr><td>1</td><td></td><td></td></tr>
<tr><td></td><td>2</td><td></td></tr>
<tr><td></td><td></td><td>3</td></tr>
</table>
21
21
12

=== mt:ContentFieldValue with glue
--- template
<mt:Contents content_type="test content data" offset="1" limit="1"><mt:ContentFields><mt:ContentField glue=","><mt:ContentFieldValue></mt:ContentField>
</mt:ContentFields></mt:Contents>
--- expected
test single line text
test multi line text
aaaaa
12345
https://example.com/~abby
abc
def
June  3, 2017  6:05 PM
June  5, 2017
12:34 PM
2
3
1,3
aaa,bbb,ccc
<table>
<tr><td>1</td><td></td><td></td></tr>
<tr><td></td><td>2</td><td></td></tr>
<tr><td></td><td></td><td>3</td></tr>
</table>
2,1
2,1
1,2

=== mt:ContentFieldValue with convert_breaks
--- template
<mt:Contents content_type="test content data" offset="1" limit="1"><mt:ContentField content_field="multi line text"><mt:ContentFieldValue convert_breaks="1"></mt:ContentField></mt:Contents>
--- expected
<p>test multi line text<br />
aaaaa</p>


=== mt:ContentFieldValue with words
--- template
<mt:Contents content_type="test content data" offset="1" limit="1">
<mt:ContentField content_field="single line text"><mt:ContentFieldValue words="1"></mt:ContentField>
<mt:ContentField content_field="multi line text"><mt:ContentFieldValue words="1"></mt:ContentField>
</mt:Contents>
--- expected
test
test

=== mt:ContentFieldValue with date and time format
--- template
<mt:Contents content_type="test content data" offset="1" limit="1">
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%Y"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%y"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%b"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%B"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%m"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%d"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%e"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%j"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%H"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%k"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%I"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%l"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%M"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%S"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%p"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%a"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%A"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%w"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%x"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%X"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format_name="iso8601"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format_name="rfc822"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue language="cz"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue language="dk"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue language="nl"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue language="en"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue language="fr"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue language="de"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue language="is"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue language="it"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue language="no"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue language="pl"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue language="pt"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue language="si"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue language="es"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue language="fi"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue language="se"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue format="%Y-%m-%d"></mt:ContentField>
<mt:ContentField content_field="date and time"><mt:ContentFieldValue utc="1"></mt:ContentField>
</mt:Contents>
--- expected
2017
17
Jun
June
06
03
 3
154
18
18
06
 6
05
00
PM
Sat
Saturday
6
June  3, 2017
 6:05 PM
2017-06-03T18:05:00+00:00
Sat, 03 Jun 2017 18:05:00 +0000
 3. &#268;erven 2017 18:05
03.06.2017 18:05
 3 juni 2017 18:05
June  3, 2017  6:05 PM
 3 juin 2017 18h05
 3.06.17 18:05
03.06.17 18:05
03.06.17 18:05
Juni  3, 2017  6:05 EM
 3 czerwca 2017 18:05
junho  3, 2017  6:05 PM
03.06.17 18:05
 3 de Junio 2017 a las 06:05 PM
03.06.17 18:05
juni  3, 2017  6:05 EM
2017-06-03
June  3, 2017  6:05 PM

=== mt:ContentFieldValue with date_only format
--- template
<mt:Contents content_type="test content data" offset="1" limit="1">
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%Y"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%y"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%b"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%B"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%m"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%d"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%e"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%j"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%H"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%k"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%I"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%l"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%M"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%S"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%p"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%a"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%A"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%w"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%x"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%X"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format_name="iso8601"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format_name="rfc822"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue language="cz"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue language="dk"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue language="nl"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue language="en"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue language="fr"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue language="de"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue language="is"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue language="it"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue language="no"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue language="pl"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue language="pt"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue language="si"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue language="es"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue language="fi"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue language="se"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue format="%Y-%m-%d"></mt:ContentField>
<mt:ContentField content_field="date_only"><mt:ContentFieldValue utc="1"></mt:ContentField>
</mt:Contents>
--- expected
2017
17
Jun
June
06
05
 5
156
00
 0
12
12
00
00
AM
Mon
Monday
1
June  5, 2017
12:00 AM
2017-06-05T00:00:00+00:00
Mon, 05 Jun 2017 00:00:00 +0000
 5. &#268;erven 2017  0:00
05.06.2017 00:00
 5 juni 2017  0:00
June  5, 2017 12:00 AM
 5 juin 2017  0h00
 5.06.17  0:00
05.06.17 00:00
05.06.17 00:00
Juni  5, 2017 12:00 FM
 5 czerwca 2017  0:00
junho  5, 2017 12:00 AM
05.06.17 00:00
 5 de Junio 2017 a las 12:00 AM
05.06.17 00:00
juni  5, 2017 12:00 FM
2017-06-05
June  5, 2017 12:00 AM

=== mt:ContentFieldValue with time_only format
--- template
<mt:Contents content_type="test content data" offset="1" limit="1">
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%Y"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%y"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%b"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%B"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%m"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%d"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%e"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%j"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%H"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%k"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%I"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%l"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%M"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%S"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%p"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%a"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%A"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%w"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%x"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%X"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format_name="iso8601"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format_name="rfc822"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue language="cz"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue language="dk"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue language="nl"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue language="en"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue language="fr"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue language="de"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue language="is"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue language="it"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue language="no"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue language="pl"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue language="pt"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue language="si"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue language="es"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue language="fi"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue language="se"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue format="%Y-%m-%d"></mt:ContentField>
<mt:ContentField content_field="time_only"><mt:ContentFieldValue utc="1"></mt:ContentField>
</mt:Contents>
--- expected
1970
70
Jan
January
01
01
 1
001
12
12
12
12
34
56
PM
Thu
Thursday
4
January  1, 1970
12:34 PM
1970-01-01T12:34:56+00:00
Thu, 01 Jan 1970 12:34:56 +0000
 1. Leden 1970 12:34
01.01.1970 12:34
 1 januari 1970 12:34
January  1, 1970 12:34 PM
 1 janvier 1970 12h34
 1.01.70 12:34
01.01.70 12:34
01.01.70 12:34
Januar  1, 1970 12:34 EM
 1 stycznia 1970 12:34
janeiro  1, 1970 12:34 PM
01.01.70 12:34
 1 de Enero 1970 a las 12:34 PM
01.01.70 12:34
januari  1, 1970 12:34 EM
1970-01-01
January  1, 1970 12:34 PM

=== mt:ContentFieldValue with relative
--- template
<mt:Contents content_type="test content data for relative">
<mt:ContentField content_field="relative_1"><mt:ContentFieldValue relative="1"></mt:ContentField>
<mt:ContentField content_field="relative_2"><mt:ContentFieldValue relative="2"></mt:ContentField>
<mt:ContentField content_field="relative_3"><mt:ContentFieldValue relative="3"></mt:ContentField>
</mt:Contents>
--- expected
1 hour ago
1 hour ago
1 hour

=== mt:ContentFieldValue with relative js
--- template
<mt:Contents content_type="test content data" offset="1" limit="1">
<mt:ContentField content_field="date and time"><mt:ContentFieldValue relative="js"></mt:ContentField>
</mt:Contents>
--- expected
<script type="text/javascript">
/* <![CDATA[ */
document.write(mtRelativeDate(new Date(2017,5,03,18,05,00), 'June  3, 2017  6:05 PM'));
/* ]]> */
</script><noscript>June  3, 2017  6:05 PM</noscript>
