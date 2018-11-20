#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use utf8;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use Test::Base;
use MT::Test::ArchiveType;

use MT;
use MT::Test;
my $app = MT->instance;

$test_env->prepare_fixture('archive_type');

filters {
    MT::Test::ArchiveType->filter_spec
};

my $objs    = MT::Test::Fixture::ArchiveType->load_objs;
for my $cd_label ( keys %{$objs->{content_data}} ){
    my $key = $cd_label . '_unique_id';
    my $cd = $objs->{content_data}->{$cd_label};
    MT::Test::ArchiveType->vars->{$key} = $cd->unique_id;
}

MT::Test::ArchiveType->run_tests;

done_testing;

__END__

=== mt:FileTemplate (authored_on, cat_apple)
--- stash
{ entry => 'entry_author1_ruler_eraser', entry_category => 'cat_ruler', page => 'page_author1_coffee', cd => 'cd_same_apple_orange', cat_field => 'cf_same_catset_fruit', category => 'cat_apple', author => 'author1' }
--- template
<mt:If tag="AuthorBasename">%a: <mt:FileTemplate format="%a">
%-a: <mt:FileTemplate format="%-a">
%_a: <mt:FileTemplate format="%_a"></mt:If>
<mt:setvarblock name="can_use_%b"><mtif tag="entryid">1<mtelseif tag="contentid">1</mtif></mtsetvarblock><mt:If name="can_use_%b">%b: <mt:FileTemplate format="%b">
%-b: <mt:FileTemplate format="%-b">
%_b: <mt:FileTemplate format="%_b"></mt:If>
<mt:If tag="CategoryLabel">%c: <mt:FileTemplate format="%c">
%-c: <mt:FileTemplate format="%-c">
%_c: <mt:FileTemplate format="%_c">
%C: <mt:FileTemplate format="%C">
%-C: <mt:FileTemplate format="%-C"></mt:If>
<mt:If tag="ArchiveDate">%d: <mt:FileTemplate format="%d">
%D: <mt:FileTemplate format="%D"></mt:If>
<mt:If tag="EntryID">%e: <mt:FileTemplate format="%e">
%E: <mt:FileTemplate format="%E"></mt:If>
%f: <mt:FileTemplate format="%f">
%-f: <mt:FileTemplate format="%-f">
%F: <mt:FileTemplate format="%F">
%-F: <mt:FileTemplate format="%-F">
<mt:If tag="ArchiveDate">%h: <mt:FileTemplate format="%h">
%H: <mt:FileTemplate format="%H"></mt:If>
%i: <mt:FileTemplate format="%i">
%I: <mt:FileTemplate format="%I">
<mt:If tag="ArchiveDate">%j: <mt:FileTemplate format="%j">
%m: <mt:FileTemplate format="%m">
%n: <mt:FileTemplate format="%n">
%s: <mt:FileTemplate format="%s"></mt:If>
%x: <mt:FileTemplate format="%x">
<mt:If tag="ArchiveDate">%y: <mt:FileTemplate format="%y">
%Y: <mt:FileTemplate format="%Y"></mt:If>
--- expected_author
%a: author1
%-a: author1
%_a: author1




%f: index.html
%-f: index.html
%F: index
%-F: index

%i: index.html
%I: index

%x: .html
--- expected_php_todo_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26148
--- expected_author_daily
%a: author1
%-a: author1
%_a: author1


%d: 03
%D: 3

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 337
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_author_monthly
%a: author1
%-a: author1
%_a: author1


%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 335
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_author_weekly
%a: author1
%-a: author1
%_a: author1


%d: 02
%D: 2

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 336
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_author_yearly
%a: author1
%-a: author1
%_a: author1


%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 001
%m: 01
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_category
%c: cat_clip/cat_compass/cat_ruler
%-c: cat-clip/cat-compass/cat-ruler
%_c: cat_clip/cat_compass/cat_ruler
%C: cat_ruler
%-C: cat-ruler


%f: index.html
%-f: index.html
%F: index
%-F: index

%i: index.html
%I: index

%x: .html
--- expected_php_todo_category
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26148
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_category_daily
%c: cat_clip/cat_compass/cat_ruler
%-c: cat-clip/cat-compass/cat-ruler
%_c: cat_clip/cat_compass/cat_ruler
%C: cat_ruler
%-C: cat-ruler
%d: 03
%D: 3

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 337
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_php_todo_category_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_category_monthly
%c: cat_clip/cat_compass/cat_ruler
%-c: cat-clip/cat-compass/cat-ruler
%_c: cat_clip/cat_compass/cat_ruler
%C: cat_ruler
%-C: cat-ruler
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 335
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_php_todo_category_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_category_weekly
%c: cat_clip/cat_compass/cat_ruler
%-c: cat-clip/cat-compass/cat-ruler
%_c: cat_clip/cat_compass/cat_ruler
%C: cat_ruler
%-C: cat-ruler
%d: 02
%D: 2

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 336
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_php_todo_category_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_category_yearly
%c: cat_clip/cat_compass/cat_ruler
%-c: cat-clip/cat-compass/cat-ruler
%_c: cat_clip/cat_compass/cat_ruler
%C: cat_ruler
%-C: cat-ruler
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 001
%m: 01
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_php_todo_category_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_contenttype
%b: [% cd_same_apple_orange_unique_id %]
%-b: [% cd_same_apple_orange_unique_id %]
%_b: [% cd_same_apple_orange_unique_id %]
%c: cat_apple
%-c: cat-apple
%_c: cat_apple
%C: cat_apple
%-C: cat-apple


%f: [% cd_same_apple_orange_unique_id %].html
%-f: [% cd_same_apple_orange_unique_id %].html
%F: [% cd_same_apple_orange_unique_id %]
%-F: [% cd_same_apple_orange_unique_id %]

%i: index.html
%I: index

%x: .html
--- expected_php_todo_contenttype
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26060
https://movabletype.atlassian.net/browse/MTC-26148
--- expected_contenttype_author
%a: author1
%-a: author1
%_a: author1




%f: index.html
%-f: index.html
%F: index
%-F: index

%i: index.html
%I: index

%x: .html
--- expected_php_todo_contenttype_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26148
--- expected_contenttype_author_daily
%a: author1
%-a: author1
%_a: author1


%d: 31
%D: 31

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 304
%m: 10
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_contenttype_author_monthly
%a: author1
%-a: author1
%_a: author1


%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 274
%m: 10
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_contenttype_author_weekly
%a: author1
%-a: author1
%_a: author1


%d: 28
%D: 28

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 301
%m: 10
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_contenttype_author_yearly
%a: author1
%-a: author1
%_a: author1


%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 001
%m: 01
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_contenttype_category
%c: cat_apple
%-c: cat-apple
%_c: cat_apple
%C: cat_apple
%-C: cat-apple


%f: index.html
%-f: index.html
%F: index
%-F: index

%i: index.html
%I: index

%x: .html
--- expected_php_todo_contenttype_category
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26148
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_contenttype_category_daily
%c: cat_apple
%-c: cat-apple
%_c: cat_apple
%C: cat_apple
%-C: cat-apple
%d: 31
%D: 31

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 304
%m: 10
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_php_todo_contenttype_category_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_contenttype_category_monthly
%c: cat_apple
%-c: cat-apple
%_c: cat_apple
%C: cat_apple
%-C: cat-apple
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 274
%m: 10
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_php_todo_contenttype_category_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_contenttype_category_weekly
%c: cat_apple
%-c: cat-apple
%_c: cat_apple
%C: cat_apple
%-C: cat-apple
%d: 28
%D: 28

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 301
%m: 10
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_php_todo_contenttype_category_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_contenttype_category_yearly
%c: cat_apple
%-c: cat-apple
%_c: cat_apple
%C: cat_apple
%-C: cat-apple
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 001
%m: 01
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_php_todo_contenttype_category_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_contenttype_daily
%d: 31
%D: 31

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 304
%m: 10
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_contenttype_monthly
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 274
%m: 10
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_contenttype_weekly
%d: 28
%D: 28

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 301
%m: 10
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_contenttype_yearly
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 001
%m: 01
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_individual
%b: entry_author1_ruler_eraser
%-b: entry-author1-ruler-eraser
%_b: entry_author1_ruler_eraser
%c: cat_clip/cat_compass/cat_ruler
%-c: cat-clip/cat-compass/cat-ruler
%_c: cat_clip/cat_compass/cat_ruler
%C: cat_ruler
%-C: cat-ruler

%e: 000001
%E: 1
%f: entry_author1_ruler_eraser.html
%-f: entry-author1-ruler-eraser.html
%F: entry_author1_ruler_eraser
%-F: entry-author1-ruler-eraser

%i: index.html
%I: index

%x: .html
--- expected_php_todo_individual
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26148
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_daily
%d: 03
%D: 3

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 337
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_monthly
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 335
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_page
%b: page_author1_coffee
%-b: page-author1-coffee
%_b: page_author1_coffee
%c: folder_green_tea/folder_cola/folder_coffee
%-c: folder-green-tea/folder-cola/folder-coffee
%_c: folder_green_tea/folder_cola/folder_coffee
%C: folder_coffee
%-C: folder-coffee

%e: 000007
%E: 7
%f: page_author1_coffee.html
%-f: page-author1-coffee.html
%F: page_author1_coffee
%-F: page-author1-coffee

%i: index.html
%I: index

%x: .html
--- expected_php_todo_page
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26148
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_weekly
%d: 02
%D: 2

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 336
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18
--- expected_yearly
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 001
%m: 01
%n: 00
%s: 00
%x: .html
%y: 2018
%Y: 18

=== mt:FileTemplate (date, cat_orange)
--- stash
{ entry => 'entry_author2_pencil_eraser', entry_category => 'cat_pencil', page => 'page_author2_water', cd => 'cd_same_apple_orange', dt_field => 'cf_same_date', cat_field => 'cf_same_catset_other_fruit', category => 'cat_orange' }
--- template
<mt:If tag="AuthorBasename">%a: <mt:FileTemplate format="%a">
%-a: <mt:FileTemplate format="%-a">
%_a: <mt:FileTemplate format="%_a"></mt:If>
<mt:setvarblock name="can_use_%b"><mtif tag="entryid">1<mtelseif tag="contentid">1</mtif></mtsetvarblock><mt:If name="can_use_%b">%b: <mt:FileTemplate format="%b">
%-b: <mt:FileTemplate format="%-b">
%_b: <mt:FileTemplate format="%_b"></mt:If>
<mt:If tag="CategoryLabel">%c: <mt:FileTemplate format="%c">
%-c: <mt:FileTemplate format="%-c">
%_c: <mt:FileTemplate format="%_c">
%C: <mt:FileTemplate format="%C">
%-C: <mt:FileTemplate format="%-C"></mt:If>
<mt:If tag="ArchiveDate">%d: <mt:FileTemplate format="%d">
%D: <mt:FileTemplate format="%D"></mt:If>
<mt:If tag="EntryID">%e: <mt:FileTemplate format="%e">
%E: <mt:FileTemplate format="%E"></mt:If>
%f: <mt:FileTemplate format="%f">
%-f: <mt:FileTemplate format="%-f">
%F: <mt:FileTemplate format="%F">
%-F: <mt:FileTemplate format="%-F">
<mt:If tag="ArchiveDate">%h: <mt:FileTemplate format="%h">
%H: <mt:FileTemplate format="%H"></mt:If>
%i: <mt:FileTemplate format="%i">
%I: <mt:FileTemplate format="%I">
<mt:If tag="ArchiveDate">%j: <mt:FileTemplate format="%j">
%m: <mt:FileTemplate format="%m">
%n: <mt:FileTemplate format="%n">
%s: <mt:FileTemplate format="%s"></mt:If>
%x: <mt:FileTemplate format="%x">
<mt:If tag="ArchiveDate">%y: <mt:FileTemplate format="%y">
%Y: <mt:FileTemplate format="%Y"></mt:If>
--- expected_author
%a: author2
%-a: author2
%_a: author2




%f: index.html
%-f: index.html
%F: index
%-F: index

%i: index.html
%I: index

%x: .html
--- expected_php_todo_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26148
--- expected_author_daily
%a: author2
%-a: author2
%_a: author2


%d: 03
%D: 3

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 338
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2016
%Y: 16
--- expected_author_monthly
%a: author2
%-a: author2
%_a: author2


%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 336
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2016
%Y: 16
--- expected_author_weekly
%a: author2
%-a: author2
%_a: author2


%d: 27
%D: 27

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 332
%m: 11
%n: 00
%s: 00
%x: .html
%y: 2016
%Y: 16
--- expected_author_yearly
%a: author2
%-a: author2
%_a: author2


%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 001
%m: 01
%n: 00
%s: 00
%x: .html
%y: 2016
%Y: 16
--- expected_category
%c: cat_pencil
%-c: cat-pencil
%_c: cat_pencil
%C: cat_pencil
%-C: cat-pencil


%f: index.html
%-f: index.html
%F: index
%-F: index

%i: index.html
%I: index

%x: .html
--- expected_php_todo_category
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26148
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_category_daily
%c: cat_pencil
%-c: cat-pencil
%_c: cat_pencil
%C: cat_pencil
%-C: cat-pencil
%d: 03
%D: 3

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 338
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2016
%Y: 16
--- expected_php_todo_category_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_category_monthly
%c: cat_pencil
%-c: cat-pencil
%_c: cat_pencil
%C: cat_pencil
%-C: cat-pencil
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 336
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2016
%Y: 16
--- expected_php_todo_category_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_category_weekly
%c: cat_pencil
%-c: cat-pencil
%_c: cat_pencil
%C: cat_pencil
%-C: cat-pencil
%d: 27
%D: 27

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 332
%m: 11
%n: 00
%s: 00
%x: .html
%y: 2016
%Y: 16
--- expected_php_todo_category_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_category_yearly
%c: cat_pencil
%-c: cat-pencil
%_c: cat_pencil
%C: cat_pencil
%-C: cat-pencil
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 001
%m: 01
%n: 00
%s: 00
%x: .html
%y: 2016
%Y: 16
--- expected_php_todo_category_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_contenttype
%b: [% cd_same_apple_orange_unique_id %]
%-b: [% cd_same_apple_orange_unique_id %]
%_b: [% cd_same_apple_orange_unique_id %]
%c: cat_strawberry/cat_orange
%-c: cat-strawberry/cat-orange
%_c: cat_strawberry/cat_orange
%C: cat_orange
%-C: cat-orange


%f: [% cd_same_apple_orange_unique_id %].html
%-f: [% cd_same_apple_orange_unique_id %].html
%F: [% cd_same_apple_orange_unique_id %]
%-F: [% cd_same_apple_orange_unique_id %]

%i: index.html
%I: index

%x: .html
--- expected_php_todo_contenttype
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26060
https://movabletype.atlassian.net/browse/MTC-26148
--- expected_contenttype_author
%a: author1
%-a: author1
%_a: author1




%f: index.html
%-f: index.html
%F: index
%-F: index

%i: index.html
%I: index

%x: .html
--- expected_php_todo_contenttype_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26148
--- expected_contenttype_author_daily
%a: author1
%-a: author1
%_a: author1


%d: 26
%D: 26

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 269
%m: 09
%n: 00
%s: 00
%x: .html
%y: 2019
%Y: 19
--- expected_contenttype_author_monthly
%a: author1
%-a: author1
%_a: author1


%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 244
%m: 09
%n: 00
%s: 00
%x: .html
%y: 2019
%Y: 19
--- expected_contenttype_author_weekly
%a: author1
%-a: author1
%_a: author1


%d: 22
%D: 22

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 265
%m: 09
%n: 00
%s: 00
%x: .html
%y: 2019
%Y: 19
--- expected_contenttype_author_yearly
%a: author1
%-a: author1
%_a: author1


%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 001
%m: 01
%n: 00
%s: 00
%x: .html
%y: 2019
%Y: 19
--- expected_contenttype_category
%c: cat_strawberry/cat_orange
%-c: cat-strawberry/cat-orange
%_c: cat_strawberry/cat_orange
%C: cat_orange
%-C: cat-orange


%f: index.html
%-f: index.html
%F: index
%-F: index

%i: index.html
%I: index

%x: .html
--- expected_php_todo_contenttype_category
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26148
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_contenttype_category_daily
%c: cat_strawberry/cat_orange
%-c: cat-strawberry/cat-orange
%_c: cat_strawberry/cat_orange
%C: cat_orange
%-C: cat-orange
%d: 26
%D: 26

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 269
%m: 09
%n: 00
%s: 00
%x: .html
%y: 2019
%Y: 19
--- expected_php_todo_contenttype_category_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_contenttype_category_monthly
%c: cat_strawberry/cat_orange
%-c: cat-strawberry/cat-orange
%_c: cat_strawberry/cat_orange
%C: cat_orange
%-C: cat-orange
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 244
%m: 09
%n: 00
%s: 00
%x: .html
%y: 2019
%Y: 19
--- expected_php_todo_contenttype_category_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_contenttype_category_weekly
%c: cat_strawberry/cat_orange
%-c: cat-strawberry/cat-orange
%_c: cat_strawberry/cat_orange
%C: cat_orange
%-C: cat-orange
%d: 22
%D: 22

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 265
%m: 09
%n: 00
%s: 00
%x: .html
%y: 2019
%Y: 19
--- expected_php_todo_contenttype_category_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_contenttype_category_yearly
%c: cat_strawberry/cat_orange
%-c: cat-strawberry/cat-orange
%_c: cat_strawberry/cat_orange
%C: cat_orange
%-C: cat-orange
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 001
%m: 01
%n: 00
%s: 00
%x: .html
%y: 2019
%Y: 19
--- expected_php_todo_contenttype_category_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_contenttype_daily
%d: 26
%D: 26

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 269
%m: 09
%n: 00
%s: 00
%x: .html
%y: 2019
%Y: 19
--- expected_contenttype_monthly
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 244
%m: 09
%n: 00
%s: 00
%x: .html
%y: 2019
%Y: 19
--- expected_contenttype_weekly
%d: 22
%D: 22

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 265
%m: 09
%n: 00
%s: 00
%x: .html
%y: 2019
%Y: 19
--- expected_contenttype_yearly
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 001
%m: 01
%n: 00
%s: 00
%x: .html
%y: 2019
%Y: 19
--- expected_daily
%d: 03
%D: 3

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 338
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2016
%Y: 16
--- expected_individual
%b: entry_author2_pencil_eraser
%-b: entry-author2-pencil-eraser
%_b: entry_author2_pencil_eraser
%c: cat_pencil
%-c: cat-pencil
%_c: cat_pencil
%C: cat_pencil
%-C: cat-pencil

%e: 000004
%E: 4
%f: entry_author2_pencil_eraser.html
%-f: entry-author2-pencil-eraser.html
%F: entry_author2_pencil_eraser
%-F: entry-author2-pencil-eraser

%i: index.html
%I: index

%x: .html
--- expected_php_todo_individual
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26148
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_monthly
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 336
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2016
%Y: 16
--- expected_page
%b: page_author2_water
%-b: page-author2-water
%_b: page_author2_water
%c: folder_water
%-c: folder-water
%_c: folder_water
%C: folder_water
%-C: folder-water

%e: 000009
%E: 9
%f: page_author2_water.html
%-f: page-author2-water.html
%F: page_author2_water
%-F: page-author2-water

%i: index.html
%I: index

%x: .html
--- expected_php_todo_page
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26148
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_weekly
%d: 27
%D: 27

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 332
%m: 11
%n: 00
%s: 00
%x: .html
%y: 2016
%Y: 16
--- expected_yearly
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 001
%m: 01
%n: 00
%s: 00
%x: .html
%y: 2016
%Y: 16

=== mt:FileTemplate (datetime, cat_apple)
--- stash
{ entry => 'entry_author1_compass', entry_category => 'cat_compass', page => 'page_author2_no_folder', cd => 'cd_same_apple_orange', dt_field => 'cf_same_datetime', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:If tag="AuthorBasename">%a: <mt:FileTemplate format="%a">
%-a: <mt:FileTemplate format="%-a">
%_a: <mt:FileTemplate format="%_a"></mt:If>
<mt:setvarblock name="can_use_%b"><mtif tag="entryid">1<mtelseif tag="contentid">1</mtif></mtsetvarblock><mt:If name="can_use_%b">%b: <mt:FileTemplate format="%b">
%-b: <mt:FileTemplate format="%-b">
%_b: <mt:FileTemplate format="%_b"></mt:If>
<mt:If tag="CategoryLabel">%c: <mt:FileTemplate format="%c">
%-c: <mt:FileTemplate format="%-c">
%_c: <mt:FileTemplate format="%_c">
%C: <mt:FileTemplate format="%C">
%-C: <mt:FileTemplate format="%-C"></mt:If>
<mt:If tag="ArchiveDate">%d: <mt:FileTemplate format="%d">
%D: <mt:FileTemplate format="%D"></mt:If>
<mt:If tag="EntryID">%e: <mt:FileTemplate format="%e">
%E: <mt:FileTemplate format="%E"></mt:If>
%f: <mt:FileTemplate format="%f">
%-f: <mt:FileTemplate format="%-f">
%F: <mt:FileTemplate format="%F">
%-F: <mt:FileTemplate format="%-F">
<mt:If tag="ArchiveDate">%h: <mt:FileTemplate format="%h">
%H: <mt:FileTemplate format="%H"></mt:If>
%i: <mt:FileTemplate format="%i">
%I: <mt:FileTemplate format="%I">
<mt:If tag="ArchiveDate">%j: <mt:FileTemplate format="%j">
%m: <mt:FileTemplate format="%m">
%n: <mt:FileTemplate format="%n">
%s: <mt:FileTemplate format="%s"></mt:If>
%x: <mt:FileTemplate format="%x">
<mt:If tag="ArchiveDate">%y: <mt:FileTemplate format="%y">
%Y: <mt:FileTemplate format="%Y"></mt:If>
--- expected_author
%a: author1
%-a: author1
%_a: author1




%f: index.html
%-f: index.html
%F: index
%-F: index

%i: index.html
%I: index

%x: .html
--- expected_php_todo_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26148
--- expected_author_daily
%a: author1
%-a: author1
%_a: author1


%d: 03
%D: 3

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 337
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2017
%Y: 17
--- expected_author_monthly
%a: author1
%-a: author1
%_a: author1


%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 335
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2017
%Y: 17
--- expected_author_weekly
%a: author1
%-a: author1
%_a: author1


%d: 03
%D: 3

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 337
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2017
%Y: 17
--- expected_author_yearly
%a: author1
%-a: author1
%_a: author1


%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 001
%m: 01
%n: 00
%s: 00
%x: .html
%y: 2017
%Y: 17
--- expected_category
%c: cat_clip/cat_compass
%-c: cat-clip/cat-compass
%_c: cat_clip/cat_compass
%C: cat_compass
%-C: cat-compass


%f: index.html
%-f: index.html
%F: index
%-F: index

%i: index.html
%I: index

%x: .html
--- expected_php_todo_category
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26148
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_category_daily
%c: cat_clip/cat_compass
%-c: cat-clip/cat-compass
%_c: cat_clip/cat_compass
%C: cat_compass
%-C: cat-compass
%d: 03
%D: 3

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 337
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2017
%Y: 17
--- expected_php_todo_category_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_category_monthly
%c: cat_clip/cat_compass
%-c: cat-clip/cat-compass
%_c: cat_clip/cat_compass
%C: cat_compass
%-C: cat-compass
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 335
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2017
%Y: 17
--- expected_php_todo_category_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_category_weekly
%c: cat_clip/cat_compass
%-c: cat-clip/cat-compass
%_c: cat_clip/cat_compass
%C: cat_compass
%-C: cat-compass
%d: 03
%D: 3

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 337
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2017
%Y: 17
--- expected_php_todo_category_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_category_yearly
%c: cat_clip/cat_compass
%-c: cat-clip/cat-compass
%_c: cat_clip/cat_compass
%C: cat_compass
%-C: cat-compass
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 001
%m: 01
%n: 00
%s: 00
%x: .html
%y: 2017
%Y: 17
--- expected_php_todo_category_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_contenttype
%b: [% cd_same_apple_orange_unique_id %]
%-b: [% cd_same_apple_orange_unique_id %]
%_b: [% cd_same_apple_orange_unique_id %]
%c: cat_apple
%-c: cat-apple
%_c: cat_apple
%C: cat_apple
%-C: cat-apple


%f: [% cd_same_apple_orange_unique_id %].html
%-f: [% cd_same_apple_orange_unique_id %].html
%F: [% cd_same_apple_orange_unique_id %]
%-F: [% cd_same_apple_orange_unique_id %]

%i: index.html
%I: index

%x: .html
--- expected_php_todo_contenttype
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26060
https://movabletype.atlassian.net/browse/MTC-26148
--- expected_contenttype_author
%a: author1
%-a: author1
%_a: author1




%f: index.html
%-f: index.html
%F: index
%-F: index

%i: index.html
%I: index

%x: .html
--- expected_php_todo_contenttype_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26148
--- expected_contenttype_author_daily
%a: author1
%-a: author1
%_a: author1


%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 306
%m: 11
%n: 00
%s: 00
%x: .html
%y: 2008
%Y: 08
--- expected_contenttype_author_monthly
%a: author1
%-a: author1
%_a: author1


%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 306
%m: 11
%n: 00
%s: 00
%x: .html
%y: 2008
%Y: 08
--- expected_contenttype_author_weekly
%a: author1
%-a: author1
%_a: author1


%d: 26
%D: 26

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 300
%m: 10
%n: 00
%s: 00
%x: .html
%y: 2008
%Y: 08
--- expected_contenttype_author_yearly
%a: author1
%-a: author1
%_a: author1


%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 001
%m: 01
%n: 00
%s: 00
%x: .html
%y: 2008
%Y: 08
--- expected_contenttype_category
%c: cat_apple
%-c: cat-apple
%_c: cat_apple
%C: cat_apple
%-C: cat-apple


%f: index.html
%-f: index.html
%F: index
%-F: index

%i: index.html
%I: index

%x: .html
--- expected_php_todo_contenttype_category
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26148
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_contenttype_category_daily
%c: cat_apple
%-c: cat-apple
%_c: cat_apple
%C: cat_apple
%-C: cat-apple
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 306
%m: 11
%n: 00
%s: 00
%x: .html
%y: 2008
%Y: 08
--- expected_php_todo_contenttype_category_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_contenttype_category_monthly
%c: cat_apple
%-c: cat-apple
%_c: cat_apple
%C: cat_apple
%-C: cat-apple
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 306
%m: 11
%n: 00
%s: 00
%x: .html
%y: 2008
%Y: 08
--- expected_php_todo_contenttype_category_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_contenttype_category_weekly
%c: cat_apple
%-c: cat-apple
%_c: cat_apple
%C: cat_apple
%-C: cat-apple
%d: 26
%D: 26

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 300
%m: 10
%n: 00
%s: 00
%x: .html
%y: 2008
%Y: 08
--- expected_php_todo_contenttype_category_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_contenttype_category_yearly
%c: cat_apple
%-c: cat-apple
%_c: cat_apple
%C: cat_apple
%-C: cat-apple
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 001
%m: 01
%n: 00
%s: 00
%x: .html
%y: 2008
%Y: 08
--- expected_php_todo_contenttype_category_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_contenttype_daily
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 306
%m: 11
%n: 00
%s: 00
%x: .html
%y: 2008
%Y: 08
--- expected_contenttype_monthly
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 306
%m: 11
%n: 00
%s: 00
%x: .html
%y: 2008
%Y: 08
--- expected_contenttype_weekly
%d: 26
%D: 26

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 300
%m: 10
%n: 00
%s: 00
%x: .html
%y: 2008
%Y: 08
--- expected_contenttype_yearly
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 001
%m: 01
%n: 00
%s: 00
%x: .html
%y: 2008
%Y: 08
--- expected_daily
%d: 03
%D: 3

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 337
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2017
%Y: 17
--- expected_individual
%b: entry_author1_compass
%-b: entry-author1-compass
%_b: entry_author1_compass
%c: cat_clip/cat_compass
%-c: cat-clip/cat-compass
%_c: cat_clip/cat_compass
%C: cat_compass
%-C: cat-compass

%e: 000003
%E: 3
%f: entry_author1_compass.html
%-f: entry-author1-compass.html
%F: entry_author1_compass
%-F: entry-author1-compass

%i: index.html
%I: index

%x: .html
--- expected_php_todo_individual
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26148
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_monthly
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 335
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2017
%Y: 17
--- expected_page
%b: page_author2_no_folder
%-b: page-author2-no-folder
%_b: page_author2_no_folder


%e: 000010
%E: 10
%f: page_author2_no_folder.html
%-f: page-author2-no-folder.html
%F: page_author2_no_folder
%-F: page-author2-no-folder

%i: index.html
%I: index

%x: .html
--- expected_php_todo_page
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26148
https://movabletype.atlassian.net/browse/MTC-26149
--- expected_weekly
%d: 03
%D: 3

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 337
%m: 12
%n: 00
%s: 00
%x: .html
%y: 2017
%Y: 17
--- expected_yearly
%d: 01
%D: 1

%f: index.html
%-f: index.html
%F: index
%-F: index
%h: 00
%H: 0
%i: index.html
%I: index
%j: 001
%m: 01
%n: 00
%s: 00
%x: .html
%y: 2017
%Y: 17
