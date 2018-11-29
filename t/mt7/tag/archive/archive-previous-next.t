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

=== mt:ArchivePrevious (authored_on, cat_apple)
--- stash
{ entry => 'entry_author1_ruler_eraser', entry_category => 'cat_ruler', page => 'page_author1_coffee', cd => 'cd_same_apple_orange', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchivePrevious><mt:ArchiveTitle> | <mt:ArchiveLink>
</mt:ArchivePrevious>
--- expected_author
--- expected_author_daily
author1: December  3, 2017 | http://narnia.na/author/author1/2017/12/03/
--- expected_author_monthly
author1: December 2017 | http://narnia.na/author/author1/2017/12/
--- expected_author_weekly
author1: December  3, 2017 - December  9, 2017 | http://narnia.na/author/author1/2017/12/03-week/
--- expected_author_yearly
author1: 2017 | http://narnia.na/author/author1/2017/
--- expected_category
--- expected_category_daily
--- expected_category_monthly
--- expected_category_weekly
--- expected_category_yearly
--- expected_contenttype
cd_same_apple_orange_peach | http://narnia.na/2017/10/[% cd_same_apple_orange_peach_unique_id %].html
--- expected_php_todo_contenttype
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26058
--- expected_contenttype_author
--- expected_contenttype_author_daily
author1: October 31, 2017 | http://narnia.na/author/author1/2017/10/31/
--- expected_contenttype_author_monthly
author1: October 2017 | http://narnia.na/author/author1/2017/10/
--- expected_contenttype_author_weekly
author1: October 29, 2017 - November  4, 2017 | http://narnia.na/author/author1/2017/10/29-week/
--- expected_contenttype_author_yearly
author1: 2017 | http://narnia.na/author/author1/2017/
--- expected_contenttype_category
--- expected_contenttype_category_daily
cat_apple: October 31, 2017 | http://narnia.na/cat-apple/2017/10/31/
--- expected_php_todo_contenttype_category_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_category_monthly
cat_apple: October 2017 | http://narnia.na/cat-apple/2017/10/
--- expected_php_todo_contenttype_category_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_category_weekly
cat_apple: October 29, 2017 - November  4, 2017 | http://narnia.na/cat-apple/2017/10/29-week/
--- expected_php_todo_contenttype_category_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_category_yearly
cat_apple: 2017 | http://narnia.na/cat-apple/2017/
--- expected_php_todo_contenttype_category_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_daily
October 31, 2017 | http://narnia.na/2017/10/31/
--- expected_contenttype_monthly
October 2017 | http://narnia.na/2017/10/
--- expected_contenttype_weekly
October 29, 2017 - November  4, 2017 | http://narnia.na/2017/10/29-week/
--- expected_contenttype_yearly
2017 | http://narnia.na/2017/
--- expected_daily
December  3, 2017 | http://narnia.na/2017/12/03/
--- expected_todo_individual
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26122
--- expected_monthly
December 2017 | http://narnia.na/2017/12/
--- expected_todo_page
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26122
--- expected_weekly
December  3, 2017 - December  9, 2017 | http://narnia.na/2017/12/03-week/
--- expected_yearly
2017 | http://narnia.na/2017/

=== mt:ArchivePrevious (date, cat_apple)
--- stash
{ entry => 'entry_author2_pencil_eraser', entry_category => 'cat_pencil', page => 'page_author2_water', cd => 'cd_same_apple_orange', dt_field => 'cf_same_date', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchivePrevious><mt:ArchiveTitle> | <mt:ArchiveLink>
</mt:ArchivePrevious>
--- expected_author
author1 | http://narnia.na/author/author1/
--- expected_author_daily
author2: December  3, 2015 | http://narnia.na/author/author2/2015/12/03/
--- expected_author_monthly
author2: December 2015 | http://narnia.na/author/author2/2015/12/
--- expected_author_weekly
author2: November 29, 2015 - December  5, 2015 | http://narnia.na/author/author2/2015/11/29-week/
--- expected_author_yearly
author2: 2015 | http://narnia.na/author/author2/2015/
--- expected_category
cat_eraser | http://narnia.na/cat-eraser/
--- expected_category_daily
--- expected_category_monthly
--- expected_category_weekly
--- expected_category_yearly
--- expected_contenttype
cd_same_apple_orange_peach | http://narnia.na/2017/10/[% cd_same_apple_orange_peach_unique_id %].html
--- expected_php_todo_contenttype
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26058
--- expected_contenttype_author
--- expected_contenttype_author_daily
--- expected_php_todo_contenttype_author_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_author_monthly
--- expected_php_todo_contenttype_author_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_author_weekly
--- expected_php_todo_contenttype_author_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_author_yearly
--- expected_php_todo_contenttype_author_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_category
--- expected_contenttype_category_daily
--- expected_contenttype_category_monthly
--- expected_contenttype_category_weekly
--- expected_contenttype_category_yearly
--- expected_contenttype_daily
--- expected_php_todo_contenttype_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26121
--- expected_contenttype_monthly
--- expected_php_todo_contenttype_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26121
--- expected_contenttype_weekly
--- expected_php_todo_contenttype_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26121
--- expected_contenttype_yearly
--- expected_php_todo_contenttype_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26121
--- expected_daily
December  3, 2015 | http://narnia.na/2015/12/03/
--- expected_individual
entry_author2_no_category | http://narnia.na/2015/12/entry-author2-no-category.html
--- expected_monthly
December 2015 | http://narnia.na/2015/12/
--- expected_todo_page
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26122
--- expected_weekly
November 29, 2015 - December  5, 2015 | http://narnia.na/2015/11/29-week/
--- expected_yearly
2015 | http://narnia.na/2015/

=== mt:ArchivePrevious (datetime, cat_apple)
--- stash
{ entry => 'entry_author1_compass', entry_category => 'cat_compass', page => 'page_author2_no_folder', cd => 'cd_same_apple_orange', dt_field => 'cf_same_datetime', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchivePrevious><mt:ArchiveTitle> | <mt:ArchiveLink>
</mt:ArchivePrevious>
--- expected_author
--- expected_author_daily
--- expected_author_monthly
--- expected_author_weekly
--- expected_author_yearly
--- expected_category
--- expected_category_daily
--- expected_category_monthly
--- expected_category_weekly
--- expected_category_yearly
--- expected_contenttype
cd_same_apple_orange_peach | http://narnia.na/2017/10/[% cd_same_apple_orange_peach_unique_id %].html
--- expected_php_todo_contenttype
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26058
--- expected_contenttype_author
--- expected_contenttype_author_daily
author1: November  1, 2006 | http://narnia.na/author/author1/2006/11/01/
--- expected_php_todo_contenttype_author_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_author_monthly
author1: November 2006 | http://narnia.na/author/author1/2006/11/
--- expected_php_todo_contenttype_author_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_author_weekly
author1: October 29, 2006 - November  4, 2006 | http://narnia.na/author/author1/2006/10/29-week/
--- expected_php_todo_contenttype_author_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_author_yearly
author1: 2006 | http://narnia.na/author/author1/2006/
--- expected_php_todo_contenttype_author_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_category
--- expected_contenttype_category_daily
cat_apple: November  1, 2006 | http://narnia.na/cat-apple/2006/11/01/
--- expected_php_todo_contenttype_category_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_category_monthly
cat_apple: November 2006 | http://narnia.na/cat-apple/2006/11/
--- expected_php_todo_contenttype_category_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_category_weekly
cat_apple: October 29, 2006 - November  4, 2006 | http://narnia.na/cat-apple/2006/10/29-week/
--- expected_php_todo_contenttype_category_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_category_yearly
cat_apple: 2006 | http://narnia.na/cat-apple/2006/
--- expected_php_todo_contenttype_category_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_daily
November  1, 2006 | http://narnia.na/2006/11/01/
--- expected_contenttype_monthly
November 2006 | http://narnia.na/2006/11/
--- expected_contenttype_weekly
October 29, 2006 - November  4, 2006 | http://narnia.na/2006/10/29-week/
--- expected_contenttype_yearly
2006 | http://narnia.na/2006/
--- expected_daily
December  3, 2016 | http://narnia.na/2016/12/03/
--- expected_individual
entry_author2_pencil_eraser | http://narnia.na/2016/12/entry-author2-pencil-eraser.html
--- expected_monthly
December 2016 | http://narnia.na/2016/12/
--- expected_php_todo_page
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26122
--- expected_page
page_author2_water | http://narnia.na/folder-water/page-author2-water.html
--- expected_weekly
November 27, 2016 - December  3, 2016 | http://narnia.na/2016/11/27-week/
--- expected_yearly
2016 | http://narnia.na/2016/

=== mt:ArchivePrevious with content_type
--- stash
{ entry => 'entry_author1_ruler_eraser_1', entry_category => 'cat_eraser', page => 'page_author2_no_folder', cd => 'cd_same_apple_orange', cat_field => 'cf_same_catset_fruit', category => 'cat_apple'}
--- template
<mt:ArchivePrevious content_type="[% cd_same_apple_orange_unique_id %]"><mt:ArchiveTitle> | <mt:ArchiveLink>
</mt:ArchivePrevious>
--- expected_todo_error_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_author
--- expected_todo_error_author_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_author_daily
author1: December  3, 2017 | http://narnia.na/author/author1/2017/12/03/
--- expected_todo_error_author_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_author_monthly
author1: December 2017 | http://narnia.na/author/author1/2017/12/
--- expected_todo_error_author_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_author_weekly
author1: December  3, 2017 - December  9, 2017 | http://narnia.na/author/author1/2017/12/03-week/
--- expected_todo_error_author_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_author_yearly
author1: 2017 | http://narnia.na/author/author1/2017/
--- expected_todo_error_category
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_category
--- expected_todo_error_category_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_todo_category_daily
https://movabletype.atlassian.net/browse/MTC-26071
--- expected_todo_error_category_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_todo_category_monthly
https://movabletype.atlassian.net/browse/MTC-26071
--- expected_todo_error_category_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_todo_category_weekly
https://movabletype.atlassian.net/browse/MTC-26071
--- expected_todo_error_category_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_todo_category_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26071
--- expected_contenttype
cd_same_apple_orange_peach | http://narnia.na/2017/10/[% cd_same_apple_orange_peach_unique_id %].html
--- expected_php_todo_contenttype
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26058
--- expected_contenttype_author
--- expected_contenttype_author_daily
author1: October 31, 2017 | http://narnia.na/author/author1/2017/10/31/
--- expected_contenttype_author_monthly
author1: October 2017 | http://narnia.na/author/author1/2017/10/
--- expected_contenttype_author_weekly
author1: October 29, 2017 - November  4, 2017 | http://narnia.na/author/author1/2017/10/29-week/
--- expected_contenttype_author_yearly
author1: 2017 | http://narnia.na/author/author1/2017/
--- expected_contenttype_category
--- expected_contenttype_category_daily
cat_apple: October 31, 2017 | http://narnia.na/cat-apple/2017/10/31/
--- expected_php_todo_contenttype_category_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_category_monthly
cat_apple: October 2017 | http://narnia.na/cat-apple/2017/10/
--- expected_php_todo_contenttype_category_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_category_weekly
cat_apple: October 29, 2017 - November  4, 2017 | http://narnia.na/cat-apple/2017/10/29-week/
--- expected_php_todo_contenttype_category_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_category_yearly
cat_apple: 2017 | http://narnia.na/cat-apple/2017/
--- expected_php_todo_contenttype_category_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_daily
October 31, 2017 | http://narnia.na/2017/10/31/
--- expected_contenttype_monthly
October 2017 | http://narnia.na/2017/10/
--- expected_contenttype_weekly
October 29, 2017 - November  4, 2017 | http://narnia.na/2017/10/29-week/
--- expected_contenttype_yearly
2017 | http://narnia.na/2017/
--- expected_todo_error_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_daily
December  3, 2017 | http://narnia.na/2017/12/03/
--- expected_todo_error_individual
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_individual
entry_author1_ruler_eraser | http://narnia.na/2018/12/entry-author1-ruler-eraser.html
--- expected_todo_error_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_monthly
December 2017 | http://narnia.na/2017/12/
--- expected_php_todo_error_page
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26122
--- expected_todo_error_page
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_page
page_author2_water | http://narnia.na/folder-water/page-author2-water.html
--- expected_todo_error_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_weekly
December  3, 2017 - December  9, 2017 | http://narnia.na/2017/12/03-week/
--- expected_todo_error_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_yearly
2017 | http://narnia.na/2017/

=== mt:ArchiveNext (authored_on, cat_apple)
--- stash
{ entry => 'entry_author1_ruler_eraser', entry_category => 'cat_ruler', page => 'page_author1_coffee', cd => 'cd_same_apple_orange', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchiveNext><mt:ArchiveTitle> | <mt:ArchiveLink>
</mt:ArchiveNext>
--- expected_author
author2 | http://narnia.na/author/author2/
--- expected_author_daily
--- expected_author_monthly
--- expected_author_weekly
--- expected_author_yearly
--- expected_category
--- expected_category_daily
--- expected_category_monthly
--- expected_category_weekly
--- expected_category_yearly
--- expected_contenttype
cd_same_same_date | http://narnia.na/2018/10/[% cd_same_same_date_unique_id %].html
--- expected_php_todo_contenttype
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26058
--- expected_contenttype_author
author2 | http://narnia.na/author/author2/
--- expected_contenttype_author_daily
--- expected_contenttype_author_monthly
--- expected_contenttype_author_weekly
--- expected_contenttype_author_yearly
--- expected_contenttype_category
cat_peach | http://narnia.na/cat-peach/
--- expected_contenttype_category_daily
--- expected_contenttype_category_monthly
--- expected_contenttype_category_weekly
--- expected_contenttype_category_yearly
--- expected_contenttype_daily
--- expected_contenttype_monthly
--- expected_contenttype_weekly
--- expected_contenttype_yearly
--- expected_daily
--- expected_individual
entry_author1_ruler_eraser | http://narnia.na/2018/12/entry-author1-ruler-eraser-1.html
--- expected_monthly
--- expected_page
page_author1_coffee | http://narnia.na/folder-green-tea/folder-cola/folder-coffee/page-author1-publish.html
--- expected_weekly
--- expected_yearly

=== mt:ArchiveNext (date, cat_apple)
--- stash
{ entry => 'entry_author2_pencil_eraser', entry_category => 'cat_pencil', page => 'page_author2_water', cd => 'cd_same_apple_orange', dt_field => 'cf_same_date', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchiveNext><mt:ArchiveTitle> | <mt:ArchiveLink>
</mt:ArchiveNext>
--- expected_author
--- expected_author_daily
--- expected_author_monthly
--- expected_author_weekly
--- expected_author_yearly
--- expected_category
--- expected_category_daily
--- expected_category_monthly
--- expected_category_weekly
--- expected_category_yearly
--- expected_contenttype
cd_same_same_date | http://narnia.na/2018/10/[% cd_same_same_date_unique_id %].html
--- expected_php_todo_contenttype
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26058
--- expected_contenttype_author
author2 | http://narnia.na/author/author2/
--- expected_contenttype_author_daily
author1: September 26, 2020 | http://narnia.na/author/author1/2020/09/26/
--- expected_php_todo_contenttype_author_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_author_monthly
author1: September 2020 | http://narnia.na/author/author1/2020/09/
--- expected_php_todo_contenttype_author_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_author_weekly
author1: September 20, 2020 - September 26, 2020 | http://narnia.na/author/author1/2020/09/20-week/
--- expected_php_todo_contenttype_author_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_author_yearly
author1: 2020 | http://narnia.na/author/author1/2020/
--- expected_php_todo_contenttype_author_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_category
cat_peach | http://narnia.na/cat-peach/
--- expected_contenttype_category_daily
cat_apple: September 26, 2020 | http://narnia.na/cat-apple/2020/09/26/
--- expected_php_todo_contenttype_category_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_category_monthly
cat_apple: September 2020 | http://narnia.na/cat-apple/2020/09/
--- expected_php_todo_contenttype_category_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_category_weekly
cat_apple: September 20, 2020 - September 26, 2020 | http://narnia.na/cat-apple/2020/09/20-week/
--- expected_php_todo_contenttype_category_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_category_yearly
cat_apple: 2020 | http://narnia.na/cat-apple/2020/
--- expected_php_todo_contenttype_category_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_daily
September 26, 2020 | http://narnia.na/2020/09/26/
--- expected_php_todo_contenttype_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26121
--- expected_contenttype_monthly
September 2020 | http://narnia.na/2020/09/
--- expected_php_todo_contenttype_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26121
--- expected_contenttype_weekly
September 20, 2020 - September 26, 2020 | http://narnia.na/2020/09/20-week/
--- expected_php_todo_contenttype_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26121
--- expected_contenttype_yearly
2020 | http://narnia.na/2020/
--- expected_php_todo_contenttype_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26121
--- expected_daily
December  3, 2017 | http://narnia.na/2017/12/03/
--- expected_individual
entry_author1_compass | http://narnia.na/2017/12/entry-author1-compass.html
--- expected_monthly
December 2017 | http://narnia.na/2017/12/
--- expected_todo_page
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26122
--- expected_weekly
December  3, 2017 - December  9, 2017 | http://narnia.na/2017/12/03-week/
--- expected_yearly
2017 | http://narnia.na/2017/

=== mt:ArchiveNext (datetime, cat_apple)
--- stash
{ entry => 'entry_author1_compass', entry_category => 'cat_compass', page => 'page_author2_no_folder', cd => 'cd_same_apple_orange', dt_field => 'cf_same_datetime', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchiveNext><mt:ArchiveTitle> | <mt:ArchiveLink>
</mt:ArchiveNext>
--- expected_author
author2 | http://narnia.na/author/author2/
--- expected_author_daily
author1: December  3, 2018 | http://narnia.na/author/author1/2018/12/03/
--- expected_author_monthly
author1: December 2018 | http://narnia.na/author/author1/2018/12/
--- expected_author_weekly
author1: December  2, 2018 - December  8, 2018 | http://narnia.na/author/author1/2018/12/02-week/
--- expected_author_yearly
author1: 2018 | http://narnia.na/author/author1/2018/
--- expected_category
--- expected_category_daily
--- expected_category_monthly
--- expected_category_weekly
--- expected_category_yearly
--- expected_contenttype
cd_same_same_date | http://narnia.na/2018/10/[% cd_same_same_date_unique_id %].html
--- expected_php_todo_contenttype
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26058
--- expected_contenttype_author
author2 | http://narnia.na/author/author2/
--- expected_contenttype_author_daily
--- expected_php_todo_contenttype_author_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_author_monthly
--- expected_php_todo_contenttype_author_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_author_weekly
--- expected_php_todo_contenttype_author_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_author_yearly
--- expected_php_todo_contenttype_author_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_category
cat_peach | http://narnia.na/cat-peach/
--- expected_contenttype_category_daily
--- expected_contenttype_category_monthly
--- expected_contenttype_category_weekly
--- expected_contenttype_category_yearly
--- expected_contenttype_daily
--- expected_php_todo_contenttype_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26121
--- expected_contenttype_monthly
--- expected_php_todo_contenttype_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26121
--- expected_contenttype_weekly
--- expected_php_todo_contenttype_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26121
--- expected_contenttype_yearly
--- expected_php_todo_contenttype_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26121
--- expected_daily
December  3, 2018 | http://narnia.na/2018/12/03/
--- expected_individual
entry_author1_ruler_eraser | http://narnia.na/2018/12/entry-author1-ruler-eraser.html
--- expected_monthly
December 2018 | http://narnia.na/2018/12/
--- expected_todo_page
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26122?filter=10140
--- expected_weekly
December  2, 2018 - December  8, 2018 | http://narnia.na/2018/12/02-week/
--- expected_yearly
2018 | http://narnia.na/2018/

=== mt:ArchiveNext with content_type
--- stash
{ entry => 'entry_author1_ruler_eraser_1', entry_category => 'cat_eraser', page => 'page_author2_no_folder', cd => 'cd_same_apple_orange', cat_field => 'cf_same_catset_fruit', category => 'cat_apple'}
--- template
<mt:ArchiveNext content_type="[% cd_same_apple_orange_unique_id %]"><mt:ArchiveTitle> | <mt:ArchiveLink>
</mt:ArchiveNext>
--- expected_todo_error_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_author
author2 | http://narnia.na/author/author2/
--- expected_todo_error_author_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_author_daily
--- expected_todo_error_author_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_author_monthly
--- expected_todo_error_author_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_author_weekly
--- expected_todo_error_author_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_author_yearly
--- expected_todo_error_category
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_category
cat_pencil | http://narnia.na/cat-pencil/
--- expected_category_daily
--- expected_todo_error_category_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_category_monthly
--- expected_todo_error_category_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_category_weekly
--- expected_todo_error_category_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_category_yearly
--- expected_todo_error_category_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_contenttype
cd_same_same_date | http://narnia.na/2018/10/[% cd_same_same_date_unique_id %].html
--- expected_php_todo_contenttype
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26058
--- expected_contenttype_author
author2 | http://narnia.na/author/author2/
--- expected_contenttype_author_daily
--- expected_contenttype_author_monthly
--- expected_contenttype_author_weekly
--- expected_contenttype_author_yearly
--- expected_contenttype_category
cat_peach | http://narnia.na/cat-peach/
--- expected_contenttype_category_daily
--- expected_contenttype_category_monthly
--- expected_contenttype_category_weekly
--- expected_contenttype_category_yearly
--- expected_contenttype_daily
--- expected_contenttype_monthly
--- expected_contenttype_weekly
--- expected_contenttype_yearly
--- expected_todo_error_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_daily
--- expected_todo_error_individual
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_individual
entry_author1_ruler_eraser | http://narnia.na/2018/12/entry-author1-ruler-eraser.html
--- expected_todo_error_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_manthly
--- expected_todo_error_page
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_page
page_author1_coffee | http://narnia.na/folder-green-tea/folder-cola/folder-coffee/page-author1-coffee.html
--- expected_todo_error_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_weekly
--- expected_todo_error_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26123
--- expected_yearly

