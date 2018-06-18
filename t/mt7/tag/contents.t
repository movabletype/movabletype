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

# plan tests => 2 * blocks;
plan tests => 1 * blocks;

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
    template => [qw( var chomp )],
    expected => [qw( var chomp )],
    error    => [qw( chomp )],
};

$test_env->prepare_fixture('db');

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
for ( 1 .. 5 ) {
    my $sec_from_epoch = time - ( 60 * 60 * 24 * ( $_ - 1 ) );
    my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst )
        = localtime($sec_from_epoch);

    MT::Test::Permission->make_content_data(
        blog_id         => $blog_id,
        content_type_id => $ct->id,
        status          => MT::ContentStatus::RELEASE(),
        data            => {
            $cf_single_line_text->id => 'test single line text ' . $_,
            (   $_ == 2
                ? ( $cf_category->id => [ $category2->id, $category1->id ] )
                : ()
            ),
            (   $_ == 4 ? ( $cf_tag->id => [ $tag2->id, $tag1->id ] )
                : ()
            ),
            $cf_datetime->id =>
                sprintf( "%04d%02d%02d", $year + 1900, $mon + 1, $mday ),
            $cf_date->id =>
                sprintf( "%04d%02d%02d", $year + 1900, $mon + 1, $mday ),
        },
        authored_on =>
            sprintf( "%04d%02d%02d", $year + 1900, $mon + 1, $mday ),
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
    data => { $cf_single_line_text->id => 'test single line text ', },
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
$vars->{cd4_uid}     = $cd4->unique_id;
$vars->{ct3_name}    = $ct3->name;

MT::Test::Tag->run_perl_tests($blog_id);

# MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT:Contents without modifier
--- template
<mt:Contents>a</mt:Contents>
--- expected
aaaaaa

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

=== MT:Contents with ct_unique_id modifier
--- SKIP
--- template
<mt:Contents ct_unique_id="[% ct_uid %]">a</mt:Contents>
--- expected
aaaaa

=== MT:Contents with content_type modifier
--- template
<mt:Contents content_type="test content type 1">a</mt:Contents>
--- expected
aaaaa

=== MT:Contents with content_type modifier and wrong blog_id
--- template
<mt:Contents content_type="test content type 1" blog_ids="2">a</mt:Contents>
--- error
No Content Type could be found.

=== MT:Contents with limit
--- template
<mt:Contents content_type="test content type 1" limit="3">a</mt:Contents>
--- expected
aaa

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
<mt:Contents blog_id="1" field:[% cf1_uid %]="test single line text 3" sort_by="field:single line text">
<mt:ContentField label="single line text"><mt:ContentFieldValue></mt:ContentField>
</mt:Contents>
--- expected
test single line text 3


=== MT:Contents with category
--- template
<mt:Contents blog_id="1" field:[% cf2_uid %]="category1" sort_by="field:[% cf1_uid %]">
<mt:ContentField label="single line text"><mt:ContentFieldValue></mt:ContentField>
</mt:Contents>
--- expected
test single line text 2


=== MT:Contents with tag
--- template
<mt:Contents blog_id="1" field:[% cf3_uid %]="tag2" sort_by="field:[% cf1_uid %]">
<mt:ContentField label="single line text"><mt:ContentFieldValue></mt:ContentField>
</mt:Contents>
--- expected
test single line text 4


=== MT:Contents with days
--- template
<mt:Contents blog_id="1" days="3"><mt:ContentID></mt:Contents>
--- expected
123


=== MT:Contents with date_field
--- template
<mt:Contents blog_id="1" days="2" date_field="[% date_cf_uid %]"><mt:ContentID></mt:Contents>
--- expected
12


=== MT:Contents with glue
--- template
<mt:Contents content_type="[% ct_uid %]" blog_id="1" glue=","><mt:ContentID></mt:Contents>
--- expected
1,2,3,4,5


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
<mt:Contents><mt:var name="__counter__">:<mt:if name="__odd__">odd</mt:if><mt:if name="__even__">even</mt:if><mt:if name="__first__"> - first</mt:if><mt:if name="__last__"> - last</mt:if>
</mt:Contents>
--- expected
1:odd - first
2:even
3:odd
4:even
5:odd
6:even - last

=== MT:Contents with MT:Else
--- template
<mt:Contents content_type="[% ct3_name %]"><mt:ContentID><mt:Else>Content is not found.</mt:Contents>
--- expected
Content is not found.

