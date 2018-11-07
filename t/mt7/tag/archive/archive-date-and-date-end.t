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
my $app = MT->instance;

$test_env->prepare_fixture('archive_type');

filters {
    MT::Test::ArchiveType->filter_spec
};

MT::Test::ArchiveType->run_tests;

done_testing;

__END__

=== mt:ArchiveDate (authored_on)
--- stash
{ cd => 'cd_same_apple_orange', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchiveDate>
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26070
--- expected_error_author
You used an MTArchiveDate tag without a date context set up.
--- expected_todo_error_author_daily
--- expected_todo_error_author_monthly
--- expected_todo_error_author_weekly
--- expected_todo_error_author_yearly
--- expected_error_category
You used an MTArchiveDate tag without a date context set up.
--- expected_todo_error_category_daily
--- expected_todo_error_category_monthly
--- expected_todo_error_category_weekly
--- expected_todo_error_category_yearly
--- expected_error_contenttype
You used an MTArchiveDate tag without a date context set up.
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26070
--- expected_error_contenttype_author
You used an MTArchiveDate tag without a date context set up.
--- expected_contenttype_author_daily
October 31, 2018 12:00 AM
--- expected_contenttype_author_monthly
October  1, 2018 12:00 AM
--- expected_contenttype_author_weekly
October 28, 2018 12:00 AM
--- expected_contenttype_author_yearly
January  1, 2018 12:00 AM
--- expected_error_contenttype_category
You used an MTArchiveDate tag without a date context set up.
--- expected_contenttype_category_daily
October 31, 2018 12:00 AM
--- expected_contenttype_category_monthly
October  1, 2018 12:00 AM
--- expected_contenttype_category_weekly
October 28, 2018 12:00 AM
--- expected_contenttype_category_yearly
January  1, 2018 12:00 AM
--- expected_contenttype_daily
October 31, 2018 12:00 AM
--- expected_contenttype_monthly
October  1, 2018 12:00 AM
--- expected_contenttype_weekly
October 28, 2018 12:00 AM
--- expected_contenttype_yearly
January  1, 2018 12:00 AM
--- expected_todo_error_daily
--- expected_error_individual
You used an MTArchiveDate tag without a date context set up.
--- expected_todo_error_monthly
--- expected_error_page
You used an MTArchiveDate tag without a date context set up.
--- expected_todo_error_weekly
--- expected_todo_error_yearly

=== mt:ArchiveDate (dt_field: date)
--- stash
{ cd => 'cd_same_apple_orange', dt_field => 'cf_same_date', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchiveDate>
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26070
--- expected_error_author
You used an MTArchiveDate tag without a date context set up.
--- expected_todo_error_author_daily
--- expected_todo_error_author_monthly
--- expected_todo_error_author_weekly
--- expected_todo_error_author_yearly
--- expected_error_category
You used an MTArchiveDate tag without a date context set up.
--- expected_todo_error_category_daily
--- expected_todo_error_category_monthly
--- expected_todo_error_category_weekly
--- expected_todo_error_category_yearly
--- expected_error_contenttype
You used an MTArchiveDate tag without a date context set up.
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26070
--- expected_error_contenttype_author
You used an MTArchiveDate tag without a date context set up.
--- expected_contenttype_author_daily
September 26, 2019 12:00 AM
--- expected_contenttype_author_monthly
September  1, 2019 12:00 AM
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26091
--- expected_contenttype_author_weekly
September 22, 2019 12:00 AM
--- expected_contenttype_author_yearly
January  1, 2019 12:00 AM
--- expected_error_contenttype_category
You used an MTArchiveDate tag without a date context set up.
--- expected_contenttype_category_daily
September 26, 2019 12:00 AM
--- expected_contenttype_category_monthly
September  1, 2019 12:00 AM
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26091
--- expected_contenttype_category_weekly
September 22, 2019 12:00 AM
--- expected_todo_contenttype_category_monthly
September  1, 2019 12:00 AM
--- expected_contenttype_category_yearly
January  1, 2019 12:00 AM
--- expected_contenttype_daily
September 26, 2019 12:00 AM
--- expected_contenttype_monthly
September  1, 2019 12:00 AM
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26091
--- expected_contenttype_weekly
September 22, 2019 12:00 AM
--- expected_contenttype_yearly
January  1, 2019 12:00 AM
--- expected_todo_error_daily
--- expected_error_individual
You used an MTArchiveDate tag without a date context set up.
--- expected_todo_error_monthly
--- expected_error_page
You used an MTArchiveDate tag without a date context set up.
--- expected_todo_error_weekly
--- expected_todo_error_yearly

=== mt:ArchiveDate (dt_field: datetime)
--- stash
{ cd => 'cd_same_apple_orange', dt_field => 'cf_same_datetime', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchiveDate>
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26070
--- expected_error_author
You used an MTArchiveDate tag without a date context set up.
--- expected_todo_error_author_daily
--- expected_todo_error_author_monthly
--- expected_todo_error_author_weekly
--- expected_todo_error_author_yearly
--- expected_error_category
You used an MTArchiveDate tag without a date context set up.
--- expected_todo_error_category_daily
--- expected_todo_error_category_monthly
--- expected_todo_error_category_weekly
--- expected_todo_error_category_yearly
--- expected_error_contenttype
You used an MTArchiveDate tag without a date context set up.
--- FIXME
--- expected_error_contenttype_author
You used an MTArchiveDate tag without a date context set up.
--- expected_contenttype_author_daily
November  1, 2008 12:00 AM
--- expected_contenttype_author_monthly
November  1, 2008 12:00 AM
--- expected_contenttype_author_weekly
October 26, 2008 12:00 AM
--- expected_contenttype_author_yearly
January  1, 2008 12:00 AM
--- expected_error_contenttype_category
You used an MTArchiveDate tag without a date context set up.
--- expected_contenttype_category_daily
November  1, 2008 12:00 AM
--- expected_contenttype_category_monthly
November  1, 2008 12:00 AM
--- expected_contenttype_category_weekly
October 26, 2008 12:00 AM
--- expected_contenttype_category_yearly
January  1, 2008 12:00 AM
--- expected_contenttype_daily
November  1, 2008 12:00 AM
--- expected_contenttype_monthly
November  1, 2008 12:00 AM
--- expected_contenttype_weekly
October 26, 2008 12:00 AM
--- expected_contenttype_yearly
January  1, 2008 12:00 AM
--- expected_todo_error_daily
--- expected_error_individual
You used an MTArchiveDate tag without a date context set up.
--- expected_todo_error_monthly
--- expected_error_page
You used an MTArchiveDate tag without a date context set up.
--- expected_todo_error_weekly
--- expected_todo_error_yearly

=== mt:ArchiveDateEnd (authored_on)
--- stash
{ cd => 'cd_same_apple_orange', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchiveDateEnd>
--- expected_error_author
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_todo_error_author_daily
--- expected_todo_error_author_monthly
--- expected_todo_error_author_weekly
--- expected_todo_error_author_yearly
--- expected_error_category
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_todo_error_category_daily
--- expected_todo_error_category_monthly
--- expected_todo_error_category_weekly
--- expected_todo_error_category_yearly
--- expected_error_contenttype
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_error_contenttype_author
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_contenttype_author_daily
October 31, 2018 11:59 PM
--- expected_contenttype_author_monthly
October 31, 2018 11:59 PM
--- expected_contenttype_author_weekly
November  3, 2018 11:59 PM
--- expected_contenttype_author_yearly
December 31, 2018 11:59 PM
--- expected_error_contenttype_category
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_contenttype_category_daily
October 31, 2018 11:59 PM
--- expected_contenttype_category_monthly
October 31, 2018 11:59 PM
--- expected_contenttype_category_weekly
November  3, 2018 11:59 PM
--- expected_contenttype_category_yearly
December 31, 2018 11:59 PM
--- expected_contenttype_daily
October 31, 2018 11:59 PM
--- expected_contenttype_monthly
October 31, 2018 11:59 PM
--- expected_contenttype_weekly
November  3, 2018 11:59 PM
--- expected_contenttype_yearly
December 31, 2018 11:59 PM
--- expected_todo_error_daily
--- expected_error_individual
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_todo_error_monthly
--- expected_error_page
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_todo_error_weekly
--- expected_todo_error_yearly

=== mt:ArchiveDateEnd (dt_field: date)
--- stash
{ cd => 'cd_same_apple_orange', dt_field => 'cf_same_date', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchiveDateEnd>
--- expected_error_author
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_todo_error_author_daily
--- expected_todo_error_author_monthly
--- expected_todo_error_author_weekly
--- expected_todo_error_author_yearly
--- expected_error_category
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_todo_error_category_daily
--- expected_todo_error_category_monthly
--- expected_todo_error_category_weekly
--- expected_todo_error_category_yearly
--- expected_error_contenttype
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_error_contenttype_author
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_contenttype_author_daily
September 26, 2019 11:59 PM
--- expected_contenttype_author_monthly
September 30, 2019 11:59 PM
--- expected_contenttype_author_weekly
September 28, 2019 11:59 PM
--- expected_contenttype_author_yearly
December 31, 2019 11:59 PM
--- expected_error_contenttype_category
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_contenttype_category_daily
September 26, 2019 11:59 PM
--- expected_contenttype_category_monthly
September 30, 2019 11:59 PM
--- expected_contenttype_category_weekly
September 28, 2019 11:59 PM
--- expected_contenttype_category_yearly
December 31, 2019 11:59 PM
--- expected_contenttype_daily
September 26, 2019 11:59 PM
--- expected_contenttype_monthly
September 30, 2019 11:59 PM
--- expected_contenttype_weekly
September 28, 2019 11:59 PM
--- expected_contenttype_yearly
December 31, 2019 11:59 PM
--- expected_todo_error_daily
--- expected_error_individual
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_todo_error_monthly
--- expected_error_page
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_todo_error_weekly
--- expected_todo_error_yearly

=== mt:ArchiveDateEnd (dt_field: datetime)
--- stash
{ cd => 'cd_same_apple_orange', dt_field => 'cf_same_datetime', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchiveDateEnd>
--- expected_error_author
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_todo_error_author_daily
--- expected_todo_error_author_monthly
--- expected_todo_error_author_weekly
--- expected_todo_error_author_yearly
--- expected_error_category
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_todo_error_category_daily
--- expected_todo_error_category_monthly
--- expected_todo_error_category_weekly
--- expected_todo_error_category_yearly
--- expected_error_contenttype
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_error_contenttype_author
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_contenttype_author_daily
November  1, 2008 11:59 PM
--- expected_contenttype_author_monthly
November 30, 2008 11:59 PM
--- expected_contenttype_author_weekly
November  1, 2008 11:59 PM
--- expected_contenttype_author_yearly
December 31, 2008 11:59 PM
--- expected_error_contenttype_category
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_contenttype_category_daily
November  1, 2008 11:59 PM
--- expected_contenttype_category_daily
November  1, 2008 11:59 PM
--- expected_contenttype_category_monthly
November 30, 2008 11:59 PM
--- expected_contenttype_category_weekly
November  1, 2008 11:59 PM
--- expected_contenttype_category_yearly
December 31, 2008 11:59 PM
--- expected_contenttype_daily
November  1, 2008 11:59 PM
--- expected_contenttype_monthly
November 30, 2008 11:59 PM
--- expected_contenttype_weekly
November  1, 2008 11:59 PM
--- expected_contenttype_yearly
December 31, 2008 11:59 PM
--- expected_todo_error_daily
--- expected_error_individual
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_todo_error_monthly
--- expected_error_page
<$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_todo_error_weekly
--- expected_todo_error_yearly
