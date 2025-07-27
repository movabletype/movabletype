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
        RebuildAtDelete      => 1,
        DefaultLanguage      => 'ja',
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

MT::Test::ArchiveType->run_tests;

done_testing;

__END__

=== mt:ArchiveTitle (authored_on, cat_apple)
--- stash
{
    cd => 'cd_same_apple_orange',
    cat_field => 'cf_same_catset_fruit',
    category => 'cat_apple',
    entry => 'entry_author1_ruler_eraser',
    entry_category => 'cat_eraser',
    page => 'page_author1_coffee',
}
--- template
<mt:ArchiveTitle>
--- expected_author
author1
--- expected_author_daily
author1: 2018年12月 3日
--- expected_php_todo_author_daily
author1: 2018年12月 3日
--- expected_author_monthly
author1: 2018年12月
--- expected_php_todo_author_monthly
author1: 2018年12月
--- expected_author_weekly
author1: 2018年12月 2日 - 2018年12月 8日
--- expected_php_todo_author_weekly
author1: 2018年12月 2日 - 2018年12月 8日
--- expected_author_yearly
author1: 2018年
--- expected_category
cat_eraser
--- expected_category_daily
cat_eraser: 2018年12月 3日
--- expected_php_todo_category_daily
cat_eraser: 2018年12月 3日
--- expected_category_monthly
cat_eraser: 2018年12月
--- expected_php_todo_category_monthly
cat_eraser: 2018年12月
--- expected_category_weekly
cat_eraser: 2018年12月 2日 - 2018年12月 8日
--- expected_php_todo_category_weekly
cat_eraser: 2018年12月 2日 - 2018年12月 8日
--- expected_category_yearly
cat_eraser: 2018年
--- expected_contenttype
cd_same_apple_orange
--- expected_contenttype_author
author1
--- expected_contenttype_author_daily
author1: 2018年10月31日
--- expected_php_todo_contenttype_author_daily
author1: 2018年10月31日
--- expected_contenttype_author_monthly
author1: 2018年10月
--- expected_php_todo_contenttype_author_monthly
author1: 2018年10月
--- expected_contenttype_author_weekly
author1: 2018年10月28日 - 2018年11月 3日
--- expected_php_todo_contenttype_author_weekly
author1: 2018年10月28日 - 2018年11月 3日
--- expected_contenttype_author_yearly
author1: 2018年
--- expected_contenttype_category
cat_apple
--- expected_contenttype_category_daily
cat_apple: 2018年10月31日
--- expected_php_todo_contenttype_category_daily
cat_apple: 2018年10月31日
--- expected_contenttype_category_monthly
cat_apple: 2018年10月
--- expected_php_todo_contenttype_category_monthly
cat_apple: 2018年10月
--- expected_contenttype_category_weekly
cat_apple: 2018年10月28日 - 2018年11月 3日
--- expected_php_todo_contenttype_category_weekly
cat_apple: 2018年10月28日 - 2018年11月 3日
--- expected_contenttype_category_yearly
cat_apple: 2018年
--- expected_contenttype_daily
2018年10月31日
--- expected_php_todo_contenttype_daily
2018年10月31日
--- expected_contenttype_monthly
2018年10月
--- expected_php_todo_contenttype_monthly
2018年10月
--- expected_contenttype_weekly
2018年10月28日 - 2018年11月 3日
--- expected_php_todo_contenttype_weekly
2018年10月28日 - 2018年11月 3日
--- expected_contenttype_yearly
2018年
--- expected_daily
2018年12月 3日
--- expected_php_todo_daily
2018年12月 3日
--- expected_individual
entry_author1_ruler_eraser
--- expected_monthly
2018年12月
--- expected_php_todo_monthly
2018年12月
--- expected_page
page_author1_coffee
--- expected_weekly
2018年12月 2日 - 2018年12月 8日
--- expected_php_todo_weekly
2018年12月 2日 - 2018年12月 8日
--- expected_yearly
2018年

=== mt:ArchiveTitle (date, cat_orange)
--- stash
{
    cd => 'cd_same_apple_orange',
    dt_field => 'cf_same_date',
    cat_field => 'cf_same_catset_other_fruit',
    category => 'cat_orange',
    entry => 'entry_author1_ruler_eraser',
    entry_category => 'cat_eraser',
    page => 'page_author1_coffee',
}
--- template
<mt:ArchiveTitle>
--- expected_author
author1
--- expected_author_daily
author1: 2018年12月 3日
--- expected_php_todo_author_daily
author1: 2018年12月 3日
--- expected_author_monthly
author1: 2018年12月
--- expected_php_todo_author_monthly
author1: 2018年12月
--- expected_author_weekly
author1: 2018年12月 2日 - 2018年12月 8日
--- expected_php_todo_author_weekly
author1: 2018年12月 2日 - 2018年12月 8日
--- expected_author_yearly
author1: 2018年
--- expected_category
cat_eraser
--- expected_category_daily
cat_eraser: 2018年12月 3日
--- expected_php_todo_category_daily
cat_eraser: 2018年12月 3日
--- expected_category_monthly
cat_eraser: 2018年12月
--- expected_php_todo_category_monthly
cat_eraser: 2018年12月
--- expected_category_weekly
cat_eraser: 2018年12月 2日 - 2018年12月 8日
--- expected_php_todo_category_weekly
cat_eraser: 2018年12月 2日 - 2018年12月 8日
--- expected_category_yearly
cat_eraser: 2018年
--- expected_contenttype
cd_same_apple_orange
--- expected_contenttype_author
author1
--- expected_contenttype_author_daily
author1: 2019年9月26日
--- expected_php_todo_contenttype_author_daily
author1: 2019年9月26日
--- expected_contenttype_author_monthly
author1: 2019年9月
--- expected_php_todo_contenttype_author_monthly
author1: 2019年9月
--- expected_contenttype_author_weekly
author1: 2019年9月22日 - 2019年9月28日
--- expected_php_todo_contenttype_author_weekly
author1: 2019年9月22日 - 2019年9月28日
--- expected_contenttype_author_yearly
author1: 2019年
--- expected_contenttype_category
cat_orange
--- expected_contenttype_category_daily
cat_orange: 2019年9月26日
--- expected_php_todo_contenttype_category_daily
cat_orange: 2019年9月26日
--- expected_contenttype_category_monthly
cat_orange: 2019年9月
--- expected_php_todo_contenttype_category_monthly
cat_orange: 2019年9月
--- expected_contenttype_category_weekly
cat_orange: 2019年9月22日 - 2019年9月28日
--- expected_php_todo_contenttype_category_weekly
cat_orange: 2019年9月22日 - 2019年9月28日
--- expected_contenttype_category_yearly
cat_orange: 2019年
--- expected_contenttype_daily
2019年9月26日
--- expected_php_todo_contenttype_daily
2019年9月26日
--- expected_contenttype_monthly
2019年9月
--- expected_php_todo_contenttype_monthly
2019年9月
--- expected_contenttype_weekly
2019年9月22日 - 2019年9月28日
--- expected_php_todo_contenttype_weekly
2019年9月22日 - 2019年9月28日
--- expected_contenttype_yearly
2019年
--- expected_daily
2018年12月 3日
--- expected_php_todo_daily
2018年12月 3日
--- expected_individual
entry_author1_ruler_eraser
--- expected_monthly
2018年12月
--- expected_php_todo_monthly
2018年12月
--- expected_page
page_author1_coffee
--- expected_weekly
2018年12月 2日 - 2018年12月 8日
--- expected_php_todo_weekly
2018年12月 2日 - 2018年12月 8日
--- expected_yearly
2018年

=== mt:ArchiveTitle (datetime, cat_orange)
--- stash
{
    cd => 'cd_same_apple_orange_peach',
    dt_field => 'cf_same_datetime',
    cat_field => 'cf_same_catset_fruit',
    category => 'cat_orange',
    entry => 'entry_author1_ruler_eraser',
    entry_category => 'cat_eraser',
    page => 'page_author1_coffee',
}
--- template
<mt:ArchiveTitle>
--- expected_author
author1
--- expected_author_daily
author1: 2018年12月 3日
--- expected_php_todo_author_daily
author1: 2018年12月 3日
--- expected_author_monthly
author1: 2018年12月
--- expected_php_todo_author_monthly
author1: 2018年12月
--- expected_author_weekly
author1: 2018年12月 2日 - 2018年12月 8日
--- expected_php_todo_author_weekly
author1: 2018年12月 2日 - 2018年12月 8日
--- expected_author_yearly
author1: 2018年
--- expected_category
cat_eraser
--- expected_category_daily
cat_eraser: 2018年12月 3日
--- expected_php_todo_category_daily
cat_eraser: 2018年12月 3日
--- expected_category_monthly
cat_eraser: 2018年12月
--- expected_php_todo_category_monthly
cat_eraser: 2018年12月
--- expected_category_weekly
cat_eraser: 2018年12月 2日 - 2018年12月 8日
--- expected_php_todo_category_weekly
cat_eraser: 2018年12月 2日 - 2018年12月 8日
--- expected_category_yearly
cat_eraser: 2018年
--- expected_contenttype
cd_same_apple_orange_peach
--- expected_contenttype_author
author1
--- expected_contenttype_author_daily
author1: 2006年11月 1日
--- expected_php_todo_contenttype_author_daily
author1: 2006年11月 1日
--- expected_contenttype_author_monthly
author1: 2006年11月
--- expected_php_todo_contenttype_author_monthly
author1: 2006年11月
--- expected_contenttype_author_weekly
author1: 2006年10月29日 - 2006年11月 4日
--- expected_php_todo_contenttype_author_weekly
author1: 2006年10月29日 - 2006年11月 4日
--- expected_contenttype_author_yearly
author1: 2006年
--- expected_contenttype_category
cat_orange
--- expected_contenttype_category_daily
cat_orange: 2006年11月 1日
--- expected_php_todo_contenttype_category_daily
cat_orange: 2006年11月 1日
--- expected_contenttype_category_monthly
cat_orange: 2006年11月
--- expected_php_todo_contenttype_category_monthly
cat_orange: 2006年11月
--- expected_contenttype_category_weekly
cat_orange: 2006年10月29日 - 2006年11月 4日
--- expected_php_todo_contenttype_category_weekly
cat_orange: 2006年10月29日 - 2006年11月 4日
--- expected_contenttype_category_yearly
cat_orange: 2006年
--- expected_contenttype_daily
2006年11月 1日
--- expected_php_todo_contenttype_daily
2006年11月 1日
--- expected_contenttype_monthly
2006年11月
--- expected_php_todo_contenttype_monthly
2006年11月
--- expected_contenttype_weekly
2006年10月29日 - 2006年11月 4日
--- expected_php_todo_contenttype_weekly
2006年10月29日 - 2006年11月 4日
--- expected_contenttype_yearly
2006年
--- expected_daily
2018年12月 3日
--- expected_php_todo_daily
2018年12月 3日
--- expected_individual
entry_author1_ruler_eraser
--- expected_monthly
2018年12月
--- expected_php_todo_monthly
2018年12月
--- expected_page
page_author1_coffee
--- expected_weekly
2018年12月 2日 - 2018年12月 8日
--- expected_php_todo_weekly
2018年12月 2日 - 2018年12月 8日
--- expected_yearly
2018年
