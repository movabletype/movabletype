#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',  ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

plan tests => (1 + 2) * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Fixture;
use MT::Test::Fixture::ContentData;

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
    template       => [qw( var chomp )],
    expected       => [qw( var chomp )],
    expected_error => [qw( chomp )],
};

$test_env->prepare_fixture('content_data/dirty');

my $blog    = MT->model('blog')->load( { name => 'My Site' } );
my $blog_id = $blog->id;

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

=== mt:ContentField content_field="categories" with sort
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="categories" sort="label"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:CategoryLabel>
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
category1

category2
Footer

=== mt:ContentField content_field="categories" with lastn=0
--- skip_php
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="categories" lastn="0"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:CategoryLabel>
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected

=== mt:ContentField content_field="categories" with lastn=1
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="categories" lastn="1"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:CategoryLabel>
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
category2
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

=== mt:ContentField content_field="asset_image" with single image
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="asset_image_single"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:AssetLabel>
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
Sample Image 2
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

=== mt:ContentField text label value
--- template
<mt:Contents content_type="test content data"><mt:ContentField content_field="text label"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:ContentFieldValue>
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected


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
asset_image_single
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
<p>0</p>

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
