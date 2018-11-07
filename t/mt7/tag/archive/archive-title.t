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

MT::Test::ArchiveType->run_tests;

done_testing;

__END__

=== mt:ArchiveTitle (authored_on, cat_apple)
--- stash
{ cd => 'cd_same_apple_orange', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchiveTitle>
--- expected_todo_author
--- expected_php_todo_author
author1
author2
--- expected_todo_author_daily
--- expected_todo_author_monthly
--- expected_todo_author_weekly
--- expected_todo_author_yearly
--- expected_todo_category
--- expected_todo_category_daily
--- expected_todo_category_monthly
--- expected_todo_category_weekly
--- expected_todo_category_yearly
--- expected_todo_contenttype
cd_same_apple_orange
cd_same_same_date
cd_same_apple_orange_peach
cd_same_peach
--- expected_contenttype_author
author1
--- expected_contenttype_author_daily
author1: October 31, 2018
--- expected_contenttype_author_monthly
author1: October 2018
--- expected_contenttype_author_weekly
author1: October 28, 2018 - November  3, 2018
--- expected_contenttype_author_yearly
author1: 2018
--- expected_contenttype_category
cat_apple
--- expected_contenttype_category_daily
cat_apple: October 31, 2018
--- expected_php_todo_contenttype_category_daily
--- expected_contenttype_category_monthly
cat_apple: October 2018
--- expected_php_todo_contenttype_category_monthly
--- expected_contenttype_category_weekly
cat_apple: October 28, 2018 - November  3, 2018
--- expected_php_todo_contenttype_category_weekly
--- expected_contenttype_category_yearly
cat_apple: 2018
--- expected_php_todo_contenttype_category_yearly
--- expected_contenttype_daily
October 31, 2018
--- expected_contenttype_monthly
October 2018
--- expected_contenttype_weekly
October 28, 2018 - November  3, 2018
--- expected_contenttype_yearly
2018
--- expected_todo_daily
--- expected_todo_error_individual
--- expected_todo_monthly
--- expected_todo_error_page
--- expected_todo_weekly
--- expected_todo_yearly

=== mt:ArchiveTitle (date, cat_orange)
--- stash
{ cd => 'cd_same_apple_orange', dt_field => 'cf_same_date', cat_field => 'cf_same_catset_other_fruit', category => 'cat_orange' }
--- template
<mt:ArchiveTitle>
--- expected_todo_author
--- expected_todo_author_daily
--- expected_todo_author_monthly
--- expected_todo_author_weekly
--- expected_todo_author_yearly
--- expected_todo_category
--- expected_todo_category_daily
--- expected_todo_category_monthly
--- expected_todo_category_weekly
--- expected_todo_category_yearly
--- expected_todo_contenttype
cd_same_same_date
cd_same_apple_orange
cd_same_apple_orange_peach
cd_same_peach
--- expected_contenttype_author
author1
--- expected_contenttype_author_daily
author1: September 26, 2019
--- expected_contenttype_author_monthly
author1: September 2019
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26091
--- expected_todo_contenttype_author_weekly
December 25, -001 - December 31, -001
--- expected_contenttype_author_yearly
author1: 2019
--- expected_contenttype_category
cat_orange
--- expected_contenttype_category_daily
cat_orange: September 26, 2019
--- expected_contenttype_category_monthly
cat_orange: September 2019
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26091
--- expected_todo_contenttype_category_weekly
December 25, -001 - December 31, -001
--- expected_contenttype_category_yearly
cat_orange: 2019
--- expected_contenttype_daily
September 26, 2019
--- expected_contenttype_monthly
September 2019
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26091
--- expected_todo_contenttype_weekly
December 25, -001 - December 31, -001
--- expected_contenttype_yearly
2019
--- expected_todo_daily
--- expected_todo_error_individual
--- expected_todo_monthly
--- expected_todo_error_page
--- expected_todo_weekly
--- expected_todo_yearly

=== mt:ArchiveTitle (datetime, cat_orange)
--- stash
{ cd => 'cd_same_apple_orange_peach', dt_field => 'cf_same_datetime', cat_field => 'cf_same_catset_fruit', category => 'cat_orange' }
--- template
<mt:ArchiveTitle>
--- expected_todo_author
--- expected_todo_author_daily
--- expected_todo_author_monthly
--- expected_todo_author_weekly
--- expected_todo_author_yearly
--- expected_todo_category
--- expected_todo_category_daily
--- expected_todo_category_monthly
--- expected_todo_category_weekly
--- expected_todo_category_yearly
--- expected_todo_contenttype
cd_same_apple_orange
cd_same_same_date
cd_same_apple_orange_peach
cd_same_peach
--- expected_contenttype_author
author1
--- expected_contenttype_author_daily
author1: November  1, 2006
--- expected_contenttype_author_monthly
author1: November 2006
--- expected_contenttype_author_weekly
author1: October 29, 2006 - November  4, 2006
--- expected_contenttype_author_yearly
author1: 2006
--- expected_contenttype_category
cat_orange
--- expected_contenttype_category_daily
cat_orange: November  1, 2006
--- expected_contenttype_category_monthly
cat_orange: November 2006
--- expected_contenttype_category_weekly
cat_orange: October 29, 2006 - November  4, 2006
--- expected_contenttype_category_yearly
cat_orange: 2006
--- expected_contenttype_daily
November  1, 2006
--- expected_contenttype_monthly
November 2006
--- expected_contenttype_weekly
October 29, 2006 - November  4, 2006
--- expected_contenttype_yearly
2006
--- expected_todo_daily
--- expected_todo_error_individual
--- expected_todo_monthly
--- expected_todo_error_page
--- expected_todo_weekly
--- expected_todo_yearly
