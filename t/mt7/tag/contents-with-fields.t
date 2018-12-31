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
    blog_id  => [qw( var chomp )],
    template => [qw( var chomp )],
    expected => [qw( var chomp )],
    error    => [qw( chomp )],
};

$test_env->prepare_fixture('db');

my $site_path = $test_env->root . "/site";
my $blog      = MT::Test::Permission->make_blog( site_path => $site_path );
my $blog_id   = $blog->id;

my $site_path2 = $test_env->root . "/site2";
my $blog2      = MT::Test::Permission->make_blog( site_path => $site_path2 );
my $blog_id2   = $blog2->id;

my $ct = MT::Test::Permission->make_content_type(
    name    => 'test content data',
    blog_id => $blog_id,
);
my $ct2 = MT::Test::Permission->make_content_type(
    name    => 'Content Type',
    blog_id => $blog_id,
);
my $ct3 = MT::Test::Permission->make_content_type(
    name    => 'Content Type',
    blog_id => $blog_id2,
);
my $ct4 = MT::Test::Permission->make_content_type(
    name    => 'Content Type with Categories',
    blog_id => $blog_id,
);
my $ct5 = MT::Test::Permission->make_content_type(
    name    => 'Content Type with Tags',
    blog_id => $blog_id,
);
my $cf_single_line_text = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    name            => 'single',
    type            => 'single_line_text',
);
my $cf_single_line_text2 = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct2->id,
    name            => 'single',
    type            => 'single_line_text',
);
my $cf_single_line_text3 = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id2,
    content_type_id => $ct3->id,
    name            => 'single',
    type            => 'single_line_text',
);
my $cf_single_line_text4 = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct4->id,
    name            => 'single',
    type            => 'single_line_text',
);
my $cf_single_line_text5 = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct5->id,
    name            => 'single',
    type            => 'single_line_text',
);

my $cf_multi_line_text = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct2->id,
    name            => 'multiline',
    type            => 'multi_line_text',
);

my $cf_date = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct2->id,
    name            => 'date_only',
    type            => 'date_only',
);

my $cf_datetime = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct2->id,
    name            => 'date_and_time',
    type            => 'date_and_time',
);

my ( @catsets, @categories, @cf_categories );
for my $id ( 1 .. 3 ) {
    my $catset = MT::Test::Permission->make_category_set(
        blog_id => $blog_id,
        name    => "category set$id",
    );
    push @catsets, $catset;

    my @cats;
    push @cats,
        MT::Test::Permission->make_category(
        blog_id         => $blog_id,
        category_set_id => $catset->id,
        label           => "Category $id-1",
        );
    push @cats,
        MT::Test::Permission->make_category(
        blog_id         => $blog_id,
        category_set_id => $catset->id,
        label           => "Category $id-2",
        );
    push @categories, \@cats;

    push @cf_categories,
        MT::Test::Permission->make_content_field(
        blog_id            => $blog_id,
        content_type_id    => $ct4->id,
        name               => "cf_category_$id",
        type               => 'categories',
        related_cat_set_id => $catset->id,
        );
}

my ( @tags, @cf_tags );
for my $id ( 1 .. 3 ) {
    my @tags_for_id;
    push @tags_for_id, MT::Test::Permission->make_tag( name => "Tag $id-1" );
    push @tags_for_id, MT::Test::Permission->make_tag( name => "Tag $id-2" );

    push @tags, \@tags_for_id;
    push @cf_tags,
        MT::Test::Permission->make_content_field(
        blog_id         => $blog_id,
        content_type_id => $ct5->id,
        name            => "cf_tag_$id",
        type            => 'tags',
        );
}

$ct->fields(
    [   {   id        => $cf_single_line_text->id,
            order     => 1,
            type      => $cf_single_line_text->type,
            options   => { label => $cf_single_line_text->name },
            unique_id => $cf_single_line_text->unique_id,
        },
    ]
);
$ct->save or die $ct->errstr;
$ct2->fields(
    [   {   id        => $cf_single_line_text2->id,
            order     => 1,
            type      => $cf_single_line_text2->type,
            options   => { label => $cf_single_line_text2->name },
            unique_id => $cf_single_line_text2->unique_id,
        },
        {   id        => $cf_multi_line_text->id,
            order     => 2,
            type      => $cf_multi_line_text->type,
            options   => { label => $cf_multi_line_text->name },
            unique_id => $cf_multi_line_text->unique_id,
        },
        {   id        => $cf_date->id,
            order     => 3,
            type      => $cf_date->type,
            options   => { label => $cf_date->name },
            unique_id => $cf_date->unique_id,
        },
        {   id        => $cf_datetime->id,
            order     => 4,
            type      => $cf_datetime->type,
            options   => { label => $cf_datetime->name },
            unique_id => $cf_datetime->unique_id,
        },
    ]
);
$ct2->save or die $ct2->errstr;
$ct3->fields(
    [   {   id        => $cf_single_line_text3->id,
            order     => 1,
            type      => $cf_single_line_text3->type,
            options   => { label => $cf_single_line_text3->name },
            unique_id => $cf_single_line_text3->unique_id,
        },
    ]
);
$ct3->save or die $ct3->errstr;
my $field_order = 1;
$ct4->fields(
    [   {   id        => $cf_single_line_text4->id,
            order     => 1,
            type      => $cf_single_line_text4->type,
            options   => { label => $cf_single_line_text4->name },
            unique_id => $cf_single_line_text4->unique_id,
        },
        map {
            +{  id      => $_->id,
                order   => $field_order++,
                type    => $_->type,
                options => {
                    label        => $_->name,
                    category_set => $_->related_cat_set_id,
                    multiple     => 1,
                    max          => 5,
                    min          => 1,
                },
                unique_id => $_->unique_id,
                },
        } @cf_categories
    ]
);
$ct4->save or die $ct4->errstr;
$field_order = 1;
$ct5->fields(
    [   {   id        => $cf_single_line_text5->id,
            order     => 1,
            type      => $cf_single_line_text5->type,
            options   => { label => $cf_single_line_text5->name },
            unique_id => $cf_single_line_text5->unique_id,
        },
        map {
            +{  id      => $_->id,
                order   => $field_order++,
                type    => $_->type,
                options => {
                    label    => $_->name,
                    multiple => 1,
                    max      => 5,
                    min      => 1,
                },
                unique_id => $_->unique_id,
                },
        } @cf_tags
    ]
);
$ct5->save or die $ct5->errstr;

my $cd = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    author_id       => 1,
    label           => 'Content Data1',
    data            => { $cf_single_line_text->id => 'single', },
);
my $cd2 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct2->id,
    author_id       => 1,
    label           => 'Content Data2',
    data            => { $cf_single_line_text2->id => 'single', },
);
my $cd3 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id2,
    content_type_id => $ct3->id,
    author_id       => 1,
    label           => 'Content Data3',
    data            => { $cf_single_line_text3->id => 'single', },
);
my $cd4 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct2->id,
    author_id       => 1,
    label           => 'Content Data4',
    data            => {
        $cf_single_line_text2->id => 'single',
        $cf_multi_line_text->id   => 'multiline',
        $cf_date->id              => '2018-12-25',
        $cf_datetime->id          => '2018-12-25 15:23:46',
    },
);
my $cd5 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct2->id,
    author_id       => 1,
    label           => 'Content Data5',
    data            => {
        $cf_single_line_text2->id => 'single2',
        $cf_multi_line_text->id   => 'multiline',
        $cf_date->id              => '2018-12-25',
        $cf_datetime->id          => '2018-12-25 12:34:56',
    },
);
my $cd6 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct4->id,
    author_id       => 1,
    label           => 'Content Data6',
    data            => {
        $cf_single_line_text4->id => 'single1',
        $cf_categories[0]->id     => [ $categories[0][0]->id ],
        $cf_categories[1]->id     => [ $categories[1][0]->id ],
        $cf_categories[2]->id     => [ $categories[2][0]->id ],
    },
);
my $cd7 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct4->id,
    author_id       => 1,
    label           => 'Content Data7',
    data            => {
        $cf_single_line_text4->id => 'single2',
        $cf_categories[0]->id =>
            [ $categories[0][0]->id, $categories[0][1]->id ],
        $cf_categories[1]->id =>
            [ $categories[1][0]->id, $categories[1][1]->id ],
        $cf_categories[2]->id =>
            [ $categories[2][0]->id, $categories[2][1]->id ],
    },
);
my $cd8 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct4->id,
    author_id       => 1,
    label           => 'Content Data8',
    data            => {
        $cf_single_line_text4->id => 'single3',
        $cf_categories[0]->id     => [ $categories[0][1]->id ],
        $cf_categories[1]->id     => [ $categories[1][1]->id ],
        $cf_categories[2]->id     => [ $categories[2][1]->id ],
    },
);
my $cd9 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct5->id,
    author_id       => 1,
    label           => 'Content Data9',
    data            => {
        $cf_single_line_text5->id => 'single1',
        $cf_tags[0]->id           => [ $tags[0][0]->id ],
        $cf_tags[1]->id           => [ $tags[1][0]->id ],
        $cf_tags[2]->id           => [ $tags[2][0]->id ],
    },
);
my $cd10 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct5->id,
    author_id       => 1,
    label           => 'Content Data10',
    data            => {
        $cf_single_line_text5->id => 'single2',
        $cf_tags[0]->id => [ $tags[0][0]->id, $tags[0][1]->id ],
        $cf_tags[1]->id => [ $tags[1][0]->id, $tags[1][1]->id ],
        $cf_tags[2]->id => [ $tags[2][0]->id, $tags[2][1]->id ],
    },
);
my $cd11 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct5->id,
    author_id       => 1,
    label           => 'Content Data11',
    data            => {
        $cf_single_line_text5->id => 'single3',
        $cf_tags[0]->id           => [ $tags[0][1]->id ],
        $cf_tags[1]->id           => [ $tags[1][1]->id ],
        $cf_tags[2]->id           => [ $tags[2][1]->id ],
    },
);

$vars->{blog_id}  = $blog_id;
$vars->{blog_id2} = $blog_id2;

MT::Test::Tag->run_perl_tests($blog_id);

MT::Test::Tag->run_php_tests($blog_id);

__END__

=== mt:Contents with field and sort_by
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type" blog_id="[% blog_id %]" field:single="single" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data2
Content Data4

=== mt:Contents with field and sort_by
--- blog_id
[% blog_id2 %]
--- template
<mt:Contents content_type="Content Type" blog_id="[% blog_id2 %]" field:single="single" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data3

=== mt:Contents with multiple fields and sort_by
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type" blog_id="[% blog_id %]" field:single="single" field:multiline="multiline" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data4

=== mt:Contents with a field and a different field sort_by
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type" blog_id="[% blog_id %]" field:single="single" sort_by="field:multiline"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data4
Content Data2

=== mt:Contents with date_only field
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type" blog_id="[% blog_id %]" field:date_only="2018-12-25"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data5
Content Data4

=== mt:Contents with two fields
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type" blog_id="[% blog_id %]" field:single="single" field:date_only="2018-12-25"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data4

=== mt:Contents with three fields
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type" blog_id="[% blog_id %]" field:single="single2" field:date_only="2018-12-25" field:date_and_time="2018-12-25 12:34:56"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data5

=== mt:Contents with tag field (MTC-26080/26092)
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type with Tags" blog_id="[% blog_id %]"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data11
Content Data10
Content Data9

=== mt:Contents with one category field (MTC-26080/26092)
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type with Categories" blog_id="[% blog_id %]" field:cf_category_1="Category 1-1" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data7
Content Data6

=== mt:Contents with another category field (MTC-26080/26092)
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type with Categories" blog_id="[% blog_id %]" field:cf_category_2="Category 2-1" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data7
Content Data6

=== mt:Contents with two category fields (MTC-26080/26092)
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type with Categories" blog_id="[% blog_id %]" field:cf_category_1="Category 1-1" field:cf_category_2="Category 2-1" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data7
Content Data6

=== mt:Contents with two different category fields (MTC-26080/26092)
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type with Categories" blog_id="[% blog_id %]" field:cf_category_1="Category 1-1" field:cf_category_2="Category 2-2" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data7

=== mt:Contents with two category fields, sort by category (MTC-26080/26092/25897)
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type with Categories" blog_id="[% blog_id %]" field:cf_category_1="Category 1-1" field:cf_category_2="Category 2-1" sort_by="field:cf_category_3"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data7
Content Data6

=== mt:Contents with two different category fields, sort by category (MTC-26080/26092)
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type with Categories" blog_id="[% blog_id %]" field:cf_category_1="Category 1-1" field:cf_category_2="Category 2-2" sort_by="field:cf_category_3"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data7

=== mt:Contents with tag field (MTC-26080/26092)
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type with Tags" blog_id="[% blog_id %]"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data11
Content Data10
Content Data9

=== mt:Contents with one tag field (MTC-26080/26092)
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type with Tags" blog_id="[% blog_id %]" field:cf_tag_1="Tag 1-1" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data10
Content Data9

=== mt:Contents with another tag field (MTC-26080/26092)
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type with Tags" blog_id="[% blog_id %]" field:cf_tag_2="Tag 2-1" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data10
Content Data9

=== mt:Contents with two tag fields (MTC-26080/26092)
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type with Tags" blog_id="[% blog_id %]" field:cf_tag_1="Tag 1-1" field:cf_tag_2="Tag 2-1" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data10
Content Data9

=== mt:Contents with two different tag fields (MTC-26080/26092)
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type with Tags" blog_id="[% blog_id %]" field:cf_tag_1="Tag 1-1" field:cf_tag_2="Tag 2-2" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data10

=== mt:Contents with two tag fields, sort by tag (MTC-26080/26092)
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type with Tags" blog_id="[% blog_id %]" field:cf_tag_1="Tag 1-1" field:cf_tag_2="Tag 2-1" sort_by="field:cf_tag_3"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data10
Content Data9

=== mt:Contents with two different tag fields, sort by tag (MTC-26080/26092)
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type with Tags" blog_id="[% blog_id %]" field:cf_tag_1="Tag 1-1" field:cf_tag_2="Tag 2-2" sort_by="field:cf_tag_3"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data10

=== all tests in 1 template (MTC-26242)
--- template
<mt:Contents content_type="Content Type" blog_id="[% blog_id %]" field:single="single" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type" blog_id="[% blog_id2 %]" field:single="single" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type" blog_id="[% blog_id %]" field:single="single" field:multiline="multiline" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type" blog_id="[% blog_id %]" field:single="single" sort_by="field:multiline"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type" blog_id="[% blog_id %]" field:date_only="2018-12-25"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type" blog_id="[% blog_id %]" field:single="single" field:date_only="2018-12-25"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type" blog_id="[% blog_id %]" field:single="single2" field:date_only="2018-12-25" field:date_and_time="2018-12-25 12:34:56"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type with Tags" blog_id="[% blog_id %]"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type with Categories" blog_id="[% blog_id %]" field:cf_category_1="Category 1-1" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type with Categories" blog_id="[% blog_id %]" field:cf_category_2="Category 2-1" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type with Categories" blog_id="[% blog_id %]" field:cf_category_1="Category 1-1" field:cf_category_2="Category 2-1" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type with Categories" blog_id="[% blog_id %]" field:cf_category_1="Category 1-1" field:cf_category_2="Category 2-2" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type with Categories" blog_id="[% blog_id %]" field:cf_category_1="Category 1-1" field:cf_category_2="Category 2-1" sort_by="field:cf_category_3"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type with Categories" blog_id="[% blog_id %]" field:cf_category_1="Category 1-1" field:cf_category_2="Category 2-2" sort_by="field:cf_category_3"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type with Tags" blog_id="[% blog_id %]"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type with Tags" blog_id="[% blog_id %]" field:cf_tag_1="Tag 1-1" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type with Tags" blog_id="[% blog_id %]" field:cf_tag_2="Tag 2-1" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type with Tags" blog_id="[% blog_id %]" field:cf_tag_1="Tag 1-1" field:cf_tag_2="Tag 2-1" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type with Tags" blog_id="[% blog_id %]" field:cf_tag_1="Tag 1-1" field:cf_tag_2="Tag 2-2" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type with Tags" blog_id="[% blog_id %]" field:cf_tag_1="Tag 1-1" field:cf_tag_2="Tag 2-1" sort_by="field:cf_tag_3"><mt:ContentLabel>
</mt:Contents>
-
<mt:Contents content_type="Content Type with Tags" blog_id="[% blog_id %]" field:cf_tag_1="Tag 1-1" field:cf_tag_2="Tag 2-2" sort_by="field:cf_tag_3"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data2
Content Data4

-
Content Data3

-
Content Data4

-
Content Data4
Content Data2

-
Content Data5
Content Data4

-
Content Data4

-
Content Data5

-
Content Data11
Content Data10
Content Data9

-
Content Data7
Content Data6

-
Content Data7
Content Data6

-
Content Data7
Content Data6

-
Content Data7

-
Content Data7
Content Data6

-
Content Data7

-
Content Data11
Content Data10
Content Data9

-
Content Data10
Content Data9

-
Content Data10
Content Data9

-
Content Data10
Content Data9

-
Content Data10

-
Content Data10
Content Data9

-
Content Data10
