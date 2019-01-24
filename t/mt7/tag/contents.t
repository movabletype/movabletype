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

# plan tests => 1 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;

use MT::ContentStatus;

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
    expected_error => [qw( var chomp )],
};

$test_env->prepare_fixture('db');

# Blog
my $blog = MT->model('blog')->load($blog_id);
$blog->days_on_index(1);
$blog->entries_on_index(1);
$blog->save;

# Content Type
my $ct = MT::Test::Permission->make_content_type(
    name    => 'test content type 1',
    blog_id => $blog_id,
);
my $cf_single_line_text = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'single line text',
    type            => 'single_line_text',
);
my $category_set = MT::Test::Permission->make_category_set(
    blog_id => $blog_id,
    name    => 'test category set',
);
my $cf_category = MT::Test::Permission->make_content_field(
    blog_id            => $blog_id,
    content_type_id    => $ct->id,
    name               => 'categories',
    type               => 'categories',
    related_cat_set_id => $category_set->id,
);
my $category1 = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $category_set->id,
    label           => 'category1',
);
my $category2 = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $category_set->id,
    label           => 'category2',
);
my $category3 = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $category_set->id,
    label           => 'category3',
    parent          => $category1->id,
);
my $cf_tag = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'tags',
    type            => 'tags',
);
my $tag1 = MT::Test::Permission->make_tag( name => 'tag1' );
my $tag2 = MT::Test::Permission->make_tag( name => 'tag2' );
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
my $fields = [
    {   id        => $cf_single_line_text->id,
        order     => 1,
        type      => $cf_single_line_text->type,
        options   => { label => $cf_single_line_text->name },
        unique_id => $cf_single_line_text->unique_id,
    },
    {   id      => $cf_category->id,
        order   => 2,
        type    => $cf_category->type,
        options => {
            label        => $cf_category->name,
            category_set => $category_set->id,
            multiple     => 1,
            max          => 5,
            min          => 1,
        },
    },
    {   id      => $cf_tag->id,
        order   => 3,
        type    => $cf_tag->type,
        options => {
            label    => $cf_tag->name,
            multiple => 1,
            max      => 5,
            min      => 1,
        },
    },
    {   id        => $cf_datetime->id,
        order     => 4,
        type      => $cf_datetime->type,
        options   => { label => $cf_datetime->name },
        unique_id => $cf_datetime->unique_id,
    },
    {   id        => $cf_date->id,
        order     => 5,
        type      => $cf_date->type,
        options   => { label => $cf_date->name },
        unique_id => $cf_date->unique_id,
    },
];
$ct->fields($fields);
$ct->save or die $ct->errstr;

# Content Data
for my $count ( 1 .. 5 ) {
    my $count_up   = time - ( $count < 5 ? 3600 * 24 * ( 5 - $count ) : 0 );
    my $count_down = time - ( $count > 1 ? 3600 * 24 * ( $count - 1 ) : 0 );
    my @auth_day = MT::Util::offset_time_list( $count_up, $blog_id );
    my $auth_day = sprintf "%04d%02d%02d000000",
        $auth_day[5] + 1900, $auth_day[4] + 1, $auth_day[3];
    my @datetime_day = MT::Util::offset_time_list( $count_down, $blog_id );
    my $datetime_day = sprintf "%04d%02d%02d000000",
        $datetime_day[5] + 1900, $datetime_day[4] + 1, $datetime_day[3];
    my @date_day = MT::Util::offset_time_list( $count_up, $blog_id );
    my $date_day = sprintf "%04d%02d%02d000000",
        $date_day[5] + 1900, $date_day[4] + 1, $date_day[3];

    MT::Test::Permission->make_content_data(
        blog_id         => $blog_id,
        content_type_id => $ct->id,
        status          => MT::ContentStatus::RELEASE(),
        data            => {
            $cf_single_line_text->id => 'test single line text ' . $count,
            (   $count == 2
                ? ( $cf_category->id => [ $category2->id, $category1->id ] )
                : ()
            ),
            (   $count == 4
                ? ( $cf_category->id => [ $category3->id ],
                    $cf_tag->id      => [ $tag2->id, $tag1->id ],
                    )
                : ()
            ),
            $cf_datetime->id => $datetime_day,
            $cf_date->id     => $date_day,
        },
        authored_on => $auth_day,
    );
}

# Dummy Content Type
my $ct2 = MT::Test::Permission->make_content_type(
    name    => 'test content type 2',
    blog_id => $blog_id,
);
my $cf_single_line_text2 = MT::Test::Permission->make_content_field(
    blog_id         => $ct2->blog_id,
    content_type_id => $ct2->id,
    name            => 'single line text 2',
    type            => 'single_line_text',
);
my $fields2 = [
    {   id        => $cf_single_line_text2->id,
        order     => 1,
        type      => $cf_single_line_text2->type,
        options   => { label => $cf_single_line_text2->name },
        unique_id => $cf_single_line_text2->unique_id,
    },
];
$ct2->fields($fields2);
$ct2->save or die $ct2->errstr;
MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct2->id,
    status          => MT::ContentStatus::RELEASE(),
    author_id       => 2,
    data => { $cf_single_line_text2->id => 'test single line text', },
);

# Empty Content Type
my $ct3 = MT::Test::Permission->make_content_type(
    name    => 'test content type 3',
    blog_id => $blog_id,
);

my $cf1     = MT::ContentField->load( { name => 'single line text' } );
my $cf2     = MT::ContentField->load( { name => 'categories' } );
my $cf3     = MT::ContentField->load( { name => 'tags' } );
my $date_cf = MT::ContentField->load( { name => 'date and time' } );
my $cd4     = MT::ContentData->load(4);

$vars->{ct_name}     = $ct->name;
$vars->{ct_id}       = $ct->id;
$vars->{ct_uid}      = $ct->unique_id;
$vars->{cf1_uid}     = $cf1->unique_id;
$vars->{cf2_uid}     = $cf2->unique_id;
$vars->{cf3_uid}     = $cf3->unique_id;
$vars->{date_cf_uid} = $date_cf->unique_id;
$vars->{cd4_id}      = $cd4->id;
$vars->{cd4_uid}     = $cd4->unique_id;
$vars->{ct3_name}    = $ct3->name;
$vars->{cd4_author}  = $cd4->author->name;

MT::Test::Tag->run_perl_tests($blog_id);

MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT:Contents with content_type="name"
--- template
<mt:Contents content_type="[% ct_name %]">a</mt:Contents>
--- expected
aaaaa

=== MT:Contents with content_type="id"
--- template
<mt:Contents content_type="[% ct_id %]">a</mt:Contents>
--- expected
aaaaa

=== MT:Contents with content_type="unique_id"
--- template
<mt:Contents content_type="[% ct_uid %]">a</mt:Contents>
--- expected
aaaaa

=== MT:Contents with site_id modifier
--- template
<mt:Contents site_id="1" content_type="[% ct_uid %]">a</mt:Contents>
--- expected
aaaaa

=== MT:Contents with content_type modifier and wrong blog_id
--- template
<mt:Contents content_type="test content type 1" blog_id="2">a</mt:Contents>
--- expected_error
Content Type was not found. Blog ID: 2

=== MT:Contents with limit
--- template
<mt:Contents content_type="test content type 1" limit="3">a</mt:Contents>
--- expected
aaa

=== MT:Contents with limit="none"
--- template
<mt:Contents content_type="test content type 1" limit="none">a</mt:Contents>
--- expected
aaaaa

=== MT:Contents with limit & offset
--- template
<mt:Contents content_type="test content type 1" limit="3" offset="1"><mt:ContentID></mt:Contents>
--- expected
432

=== MT:Contents with author
--- template
<mt:Contents content_type="[% ct_uid %]" author="[% cd4_author %]"><mt:ContentID></mt:Contents>
--- expected
54321

=== MT:Contents with sort_by content field
--- template
<mt:Contents content_type="test content type 1" sort_by="field:single line text">
<mt:ContentField label="single line text"><mt:ContentFieldValue></mt:ContentField>
</mt:Contents>
--- expected
test single line text 5

test single line text 4

test single line text 3

test single line text 2

test single line text 1


=== MT:Contents with sort_by content field
--- template
<mt:Contents blog_id="1" content_type="[% ct_uid %]" field:[% cf1_uid %]="test single line text 3" sort_by="field:single line text">
<mt:ContentField label="single line text"><mt:ContentFieldValue></mt:ContentField>
</mt:Contents>
--- expected
test single line text 3


=== MT:Contents with category
--- template
<mt:Contents blog_id="1" content_type="[% ct_uid %]" field:[% cf2_uid %]="category1" sort_by="field:[% cf1_uid %]">
<mt:ContentField label="single line text"><mt:ContentFieldValue></mt:ContentField>
</mt:Contents>
--- expected
test single line text 2


=== MT:Contents with tag
--- template
<mt:Contents blog_id="1" content_type="[% ct_uid %]" field:[% cf3_uid %]="tag2" sort_by="field:[% cf1_uid %]">
<mt:ContentField label="single line text"><mt:ContentFieldValue></mt:ContentField>
</mt:Contents>
--- expected
test single line text 4


=== MT:Contents with days
--- template
<mt:Contents blog_id="1" content_type="[% ct_uid %]" days="3"><mt:ContentID></mt:Contents>
--- expected
543


=== MT:Contents with date_field
--- template
<mt:Contents blog_id="1" content_type="[% ct_uid %]" days="2" date_field="[% date_cf_uid %]"><mt:ContentID></mt:Contents>
--- expected
21


=== MT:Contents with glue
--- template
<mt:Contents content_type="[% ct_uid %]" blog_id="1" glue=","><mt:ContentID></mt:Contents>
--- expected
5,4,3,2,1


=== MT:Contents with ID
--- template
<mt:Contents id="4"><mt:ContentID></mt:Contents>
--- expected
4


=== MT:Contents with Unique ID
--- template
<mt:Contents unique_id="[% cd4_uid %]" glue=","><mt:ContentID></mt:Contents>
--- expected
4

=== MT:Contents parameters
--- template
<mt:Contents content_type="[% ct_uid %]"><mt:var name="__counter__">:<mt:if name="__odd__">odd</mt:if><mt:if name="__even__">even</mt:if><mt:if name="__first__"> - first</mt:if><mt:if name="__last__"> - last</mt:if> (ID:<mt:ContentID>)
</mt:Contents>
--- expected
1:odd - first (ID:5)
2:even (ID:4)
3:odd (ID:3)
4:even (ID:2)
5:odd - last (ID:1)

=== MT:Contents with MT:Else
--- template
<mt:Contents content_type="[% ct3_name %]"><mt:ContentID><mt:Else>Content is not found.</mt:Contents>
--- expected
Content is not found.

=== MT:Contents with "field:unique_id" modifier
--- template
<mt:Contents blog_id="1" content_type="test content type 1" field:[% cf1_uid %]="test single line text 1">
<mt:ContentID>
</mt:Contents>
--- expected
1

=== MT:Contents with sort_by="field:hoge" modifier (ascend)
--- template
<mt:Contents blog_id="1" content_type="test content type 1" sort_by="field:date and time" sort_order="ascend">
<mt:ContentID></mt:Contents>
--- expected
5
4
3
2
1

=== MT:Contents with sort_by="field:hoge" modifier (descend)
--- template
<mt:Contents blog_id="1" content_type="test content type 1" sort_by="field:date and time" sort_order="descend">
<mt:ContentID></mt:Contents>
--- expected
1
2
3
4
5

=== MT:Contents with sort_by="authored_on" modifier (ascend)
--- template
<mt:Contents blog_id="1" content_type="test content type 1" sort_by="authored_on" sort_order="ascend">
<mt:ContentID></mt:Contents>
--- expected
1
2
3
4
5

=== MT:Contents with sort_by="authored_on" modifier (descend)
--- template
<mt:Contents blog_id="1" content_type="test content type 1" sort_by="authored_on" sort_order="descend">
<mt:ContentID></mt:Contents>
--- expected
5
4
3
2
1

=== MT:Contents with sort_order="ascend" and no sort_by modifier (MTC-26225)
--- template
<MTContents blog_id="1" content_type="test content type 1" sort_order="ascend"><MTContentID>
</MTContents>
--- expected
1
2
3
4
5

=== MT:Contents with sort_order="descend" and no sort_by modifier (MTC-26225)
--- template
<MTContents blog_id="1" content_type="test content type 1" sort_order="descend"><MTContentID>
</MTContents>
--- expected
5
4
3
2
1

=== MT:Contents with category
--- template
<mt:Contents blog_id="1" content_type="[% ct_uid %]" field:[% cf2_uid %]="category1">
<mt:ContentID>
</mt:Contents>
--- expected
2

=== MT:Contents with tag
--- template
<mt:Contents blog_id="1" content_type="[% ct_uid %]" field:[% cf3_uid %]="tag2">
<mt:ContentID>
</mt:Contents>
--- expected
4

=== MT:Contents with unique
--- template
<mt:Contents content_type="[% ct_name %]" limit="3"><mt:ContentID></mt:Contents>
<mt:Contents content_type="[% ct_name %]" limit="3" unique="1"><mt:ContentID></mt:Contents>
--- expected
543
21

=== nested MTContents with content_type (MTC-26284)
--- template
<MTContents content_type="test content type 1" limit="1"><MTContents content_type="test content type 2"><MTContentField content_field="single line text 2"><MTContentFieldValue>
</MTContentField></MTContents></MTContents>
--- expected
test single line text

=== nested MTContents with id (MTC-26096)
--- template
<MTContents content_type="test content type 1" limit="1"><MTContents id="[% cd4_id %]"><MTContentField content_field="single line text"><MTContentFieldValue>
</MTContentField></MTContents></MTContents>
--- expected
test single line text 4

=== nested MTContents with blog_id (MTC-26096)
--- template
<MTContents content_type="test content type 1" limit="1"><MTContents blog_id="1"><MTContentField content_field="single line text"><MTContentFieldValue>
</MTContentField></MTContents></MTContents>
--- expected
test single line text 5
test single line text 4
test single line text 3
test single line text 2
test single line text 1

=== nested MTContents with site_id (MTC-26096)
--- template
<MTContents content_type="test content type 1" limit="1"><MTContents site_id="1"><MTContentField content_field="single line text"><MTContentFieldValue>
</MTContentField></MTContents></MTContents>
--- expected
test single line text 5
test single line text 4
test single line text 3
test single line text 2
test single line text 1

=== nested MTContents with unique_id (MTC-26096)
--- template
<MTContents content_type="test content type 1" limit="1"><MTContents unique_id="[% cd4_uid %]"><MTContentField content_field="single line text"><MTContentFieldValue>
</MTContentField></MTContents></MTContents>
--- expected
test single line text 4

=== nested MTContents with days (MTC-26096)
--- template
<MTContents content_type="test content type 1" limit="1"><MTContents days="3"><MTContentField content_field="single line text"><MTContentFieldValue>
</MTContentField></MTContents></MTContents>
--- expected
test single line text 5
test single line text 4
test single line text 3

=== nested MTContents with field:??? (MTC-26096)
--- template
<MTContents content_type="test content type 1" limit="1"><MTContents field:[% cf1_uid %]="test single line text 2"><MTContentField content_field="single line text"><MTContentFieldValue>
</MTContentField></MTContents></MTContents>
--- expected
test single line text 2

=== nested MTContents with include_subcategories (MTC-26096)
--- template
<MTContents content_type="test content type 1" limit="1"><MTContents field:[% cf2_uid %]="category1" include_subcategories="1"><MTContentField content_field="single line text"><MTContentFieldValue>
</MTContentField></MTContents></MTContents>
--- expected
test single line text 4
test single line text 2

