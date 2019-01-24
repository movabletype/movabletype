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

# Almost everything is broken...
# https://movabletype.atlassian.net/browse/MTC-26158
$ENV{MARK_ALL_PHP_TESTS_TODO} = 1;

MT::Test::ArchiveType->run_tests;

done_testing;

__END__

=== mt:ArchiveCount(authored_on, cat_apple)
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
<mt:ArchiveTitle> | <mt:ArchiveCount>
--- expected_author
author1 | 3
--- expected_author_daily
author1: December  3, 2018 | 2
--- expected_author_monthly
author1: December 2018 | 2
--- expected_author_weekly
author1: December  2, 2018 - December  8, 2018 | 2
--- expected_author_yearly
author1: 2018 | 2
--- expected_category
cat_eraser | 3
--- expected_category_daily
cat_eraser: December  3, 2018 | 2
--- expected_category_monthly
cat_eraser: December 2018 | 2
--- expected_category_weekly
cat_eraser: December  2, 2018 - December  8, 2018 | 2
--- expected_category_yearly
cat_eraser: 2018 | 2
--- expected_contenttype
cd_same_apple_orange | 1
--- expected_contenttype_author
author1 | 3
--- expected_contenttype_author_daily
author1: October 31, 2018 | 2
--- expected_contenttype_author_monthly
author1: October 2018 | 2
--- expected_contenttype_author_weekly
author1: October 28, 2018 - November  3, 2018 | 2
--- expected_contenttype_author_yearly
author1: 2018 | 2
--- expected_contenttype_category
cat_apple | 2
--- expected_contenttype_category_daily
cat_apple: October 31, 2018 | 1
--- expected_contenttype_category_monthly
cat_apple: October 2018 | 1
--- expected_contenttype_category_weekly
cat_apple: October 28, 2018 - November  3, 2018 | 1
--- expected_contenttype_category_yearly
cat_apple: 2018 | 1
--- expected_contenttype_daily
October 31, 2018 | 2
--- expected_contenttype_monthly
October 2018 | 2
--- expected_contenttype_weekly
October 28, 2018 - November  3, 2018 | 2
--- expected_contenttype_yearly
2018 | 2
--- expected_daily
December  3, 2018 | 2
--- expected_individual
entry_author1_ruler_eraser | 1
--- expected_monthly
December 2018 | 2
--- expected_page
page_author1_coffee | 1
--- expected_weekly
December  2, 2018 - December  8, 2018 | 2
--- expected_yearly
2018 | 2

=== mt:ArchiveCount (date, cat_orange)
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
<mt:ArchiveTitle> | <mt:ArchiveCount>
--- expected_author
author1 | 3
--- expected_author_daily
author1: December  3, 2018 | 2
--- expected_author_monthly
author1: December 2018 | 2
--- expected_author_weekly
author1: December  2, 2018 - December  8, 2018 | 2
--- expected_author_yearly
author1: 2018 | 2
--- expected_category
cat_eraser | 3
--- expected_category_daily
cat_eraser: December  3, 2018 | 2
--- expected_category_monthly
cat_eraser: December 2018 | 2
--- expected_category_weekly
cat_eraser: December  2, 2018 - December  8, 2018 | 2
--- expected_category_yearly
cat_eraser: 2018 | 2
--- expected_contenttype
cd_same_apple_orange | 1
--- expected_contenttype_author
author1 | 3
--- expected_contenttype_author_daily
author1: September 26, 2019 | 1
--- expected_contenttype_author_monthly
author1: September 2019 | 1
--- expected_contenttype_author_weekly
author1: September 22, 2019 - September 28, 2019 | 1
--- expected_contenttype_author_yearly
author1: 2019 | 1
--- expected_contenttype_category
cat_orange | 1
--- expected_contenttype_category_daily
cat_orange: September 26, 2019 | 1
--- expected_contenttype_category_monthly
cat_orange: September 2019 | 1
--- expected_contenttype_category_weekly
cat_orange: September 22, 2019 - September 28, 2019 | 1
--- expected_contenttype_category_yearly
cat_orange: 2019 | 1
--- expected_contenttype_daily
September 26, 2019 | 1
--- expected_contenttype_monthly
September 2019 | 1
--- expected_contenttype_weekly
September 22, 2019 - September 28, 2019 | 1
--- expected_contenttype_yearly
2019 | 1
--- expected_daily
December  3, 2018 | 2
--- expected_individual
entry_author1_ruler_eraser | 1
--- expected_monthly
December 2018 | 2
--- expected_page
page_author1_coffee | 1
--- expected_weekly
December  2, 2018 - December  8, 2018 | 2
--- expected_yearly
2018 | 2

=== mt:ArchiveCount (datetime, cat_orange)
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
<mt:ArchiveTitle> | <mt:ArchiveCount>
--- expected_author
author1 | 3
--- expected_author_daily
author1: December  3, 2018 | 2
--- expected_author_monthly
author1: December 2018 | 2
--- expected_author_weekly
author1: December  2, 2018 - December  8, 2018 | 2
--- expected_author_yearly
author1: 2018 | 2
--- expected_category
cat_eraser | 3
--- expected_category_daily
cat_eraser: December  3, 2018 | 2
--- expected_category_monthly
cat_eraser: December 2018 | 2
--- expected_category_weekly
cat_eraser: December  2, 2018 - December  8, 2018 | 2
--- expected_category_yearly
cat_eraser: 2018 | 2
--- expected_contenttype
cd_same_apple_orange_peach | 1
--- expected_contenttype_author
author1 | 3
--- expected_contenttype_author_daily
author1: November  1, 2006 | 1
--- expected_contenttype_author_monthly
author1: November 2006 | 1
--- expected_contenttype_author_weekly
author1: October 29, 2006 - November  4, 2006 | 1
--- expected_contenttype_author_yearly
author1: 2006 | 1
--- expected_contenttype_category
cat_orange | 1
--- expected_contenttype_category_daily
cat_orange: November  1, 2006 | 1
--- expected_contenttype_category_monthly
cat_orange: November 2006 | 1
--- expected_contenttype_category_weekly
cat_orange: October 29, 2006 - November  4, 2006 | 1
--- expected_contenttype_category_yearly
cat_orange: 2006 | 1
--- expected_contenttype_daily
November  1, 2006 | 1
--- expected_contenttype_monthly
November 2006 | 1
--- expected_contenttype_weekly
October 29, 2006 - November  4, 2006 | 1
--- expected_contenttype_yearly
2006 | 1
--- expected_daily
December  3, 2018 | 2
--- expected_individual
entry_author1_ruler_eraser | 1
--- expected_monthly
December 2018 | 2
--- expected_page
page_author1_coffee | 1
--- expected_weekly
December  2, 2018 - December  8, 2018 | 2
--- expected_yearly
2018 | 2
