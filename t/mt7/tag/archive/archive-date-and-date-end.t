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
<mt:ArchiveList><mt:ArchiveDate>
</mt:ArchiveList>
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26070
--- expected_todo_author
--- expected_todo_error_author
--- expected_author_daily
December  3, 2018 12:00 AM
December  3, 2017 12:00 AM
December  3, 2016 12:00 AM
December  3, 2015 12:00 AM
--- expected_author_monthly
December  1, 2018 12:00 AM
December  1, 2017 12:00 AM
December  1, 2016 12:00 AM
December  1, 2015 12:00 AM
--- expected_author_weekly
December  2, 2018 12:00 AM
December  3, 2017 12:00 AM
November 27, 2016 12:00 AM
November 29, 2015 12:00 AM
--- expected_author_yearly
January  1, 2018 12:00 AM
January  1, 2017 12:00 AM
January  1, 2016 12:00 AM
January  1, 2015 12:00 AM
--- expected_error_category
Error in <mtArchiveDate> tag: You used an MTArchiveDate tag without a date context set up.
--- expected_category_daily
December  3, 2017 12:00 AM
December  3, 2018 12:00 AM
December  3, 2016 12:00 AM
December  3, 2016 12:00 AM
December  3, 2018 12:00 AM
--- expected_category_monthly
December  1, 2017 12:00 AM
December  1, 2018 12:00 AM
December  1, 2016 12:00 AM
December  1, 2016 12:00 AM
December  1, 2018 12:00 AM
--- expected_category_weekly
December  3, 2017 12:00 AM
December  2, 2018 12:00 AM
November 27, 2016 12:00 AM
November 27, 2016 12:00 AM
December  2, 2018 12:00 AM
--- expected_category_yearly
January  1, 2017 12:00 AM
January  1, 2018 12:00 AM
January  1, 2016 12:00 AM
January  1, 2016 12:00 AM
January  1, 2018 12:00 AM
--- expected_contenttype
October 31, 2018 12:00 AM
October 31, 2018 12:00 AM
October 31, 2017 12:00 AM
October 31, 2016 12:00 AM
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26070
--- expected_todo_contenttype_author
--- expected_todo_error_contenttype_author
--- expected_contenttype_author_daily
October 31, 2018 12:00 AM
October 31, 2017 12:00 AM
--- expected_contenttype_author_monthly
October  1, 2018 12:00 AM
October  1, 2017 12:00 AM
--- expected_contenttype_author_weekly
October 28, 2018 12:00 AM
October 29, 2017 12:00 AM
--- expected_contenttype_author_yearly
January  1, 2018 12:00 AM
January  1, 2017 12:00 AM
--- expected_error_contenttype_category
Error in <mtArchiveDate> tag: You used an MTArchiveDate tag without a date context set up.
--- expected_contenttype_category_daily
October 31, 2018 12:00 AM
October 31, 2017 12:00 AM
--- expected_contenttype_category_monthly
October  1, 2018 12:00 AM
October  1, 2017 12:00 AM
--- expected_contenttype_category_weekly
October 28, 2018 12:00 AM
October 29, 2017 12:00 AM
--- expected_contenttype_category_yearly
January  1, 2018 12:00 AM
January  1, 2017 12:00 AM
--- expected_contenttype_daily
October 31, 2018 12:00 AM
October 31, 2017 12:00 AM
October 31, 2016 12:00 AM
--- expected_contenttype_monthly
October  1, 2018 12:00 AM
October  1, 2017 12:00 AM
October  1, 2016 12:00 AM
--- expected_contenttype_weekly
October 28, 2018 12:00 AM
October 29, 2017 12:00 AM
October 30, 2016 12:00 AM
--- expected_contenttype_yearly
January  1, 2018 12:00 AM
January  1, 2017 12:00 AM
January  1, 2016 12:00 AM
--- expected_daily
December  3, 2018 12:00 AM
December  3, 2017 12:00 AM
December  3, 2016 12:00 AM
December  3, 2015 12:00 AM
--- expected_individual
December  3, 2018 12:11 PM
December  3, 2018 12:11 PM
December  3, 2017 12:11 PM
December  3, 2016 12:11 PM
December  3, 2015 12:11 PM
--- expected_monthly
December  1, 2018 12:00 AM
December  1, 2017 12:00 AM
December  1, 2016 12:00 AM
December  1, 2015 12:00 AM
--- expected_page
October 29, 2036 10:11 AM
October 29, 2025 10:11 AM
October 29, 2018 10:11 AM
October 29, 2018 10:11 AM
--- expected_weekly
December  2, 2018 12:00 AM
December  3, 2017 12:00 AM
November 27, 2016 12:00 AM
November 29, 2015 12:00 AM
--- expected_yearly
January  1, 2018 12:00 AM
January  1, 2017 12:00 AM
January  1, 2016 12:00 AM
January  1, 2015 12:00 AM

=== mt:ArchiveDate (dt_field: date)
--- stash
{ cd => 'cd_same_apple_orange', dt_field => 'cf_same_date', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchiveList><mt:ArchiveDate>
</mt:ArchiveList>
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26070
--- expected_todo_author
--- expected_todo_error_author
--- expected_author_daily
December  3, 2018 12:00 AM
December  3, 2017 12:00 AM
December  3, 2016 12:00 AM
December  3, 2015 12:00 AM
--- expected_author_monthly
December  1, 2018 12:00 AM
December  1, 2017 12:00 AM
December  1, 2016 12:00 AM
December  1, 2015 12:00 AM
--- expected_author_weekly
December  2, 2018 12:00 AM
December  3, 2017 12:00 AM
November 27, 2016 12:00 AM
November 29, 2015 12:00 AM
--- expected_author_yearly
January  1, 2018 12:00 AM
January  1, 2017 12:00 AM
January  1, 2016 12:00 AM
January  1, 2015 12:00 AM
--- expected_error_category
Error in <mtArchiveDate> tag: You used an MTArchiveDate tag without a date context set up.
--- expected_category_daily
December  3, 2017 12:00 AM
December  3, 2018 12:00 AM
December  3, 2016 12:00 AM
December  3, 2016 12:00 AM
December  3, 2018 12:00 AM
--- expected_category_monthly
December  1, 2017 12:00 AM
December  1, 2018 12:00 AM
December  1, 2016 12:00 AM
December  1, 2016 12:00 AM
December  1, 2018 12:00 AM
--- expected_category_weekly
December  3, 2017 12:00 AM
December  2, 2018 12:00 AM
November 27, 2016 12:00 AM
November 27, 2016 12:00 AM
December  2, 2018 12:00 AM
--- expected_category_yearly
January  1, 2017 12:00 AM
January  1, 2018 12:00 AM
January  1, 2016 12:00 AM
January  1, 2016 12:00 AM
January  1, 2018 12:00 AM
--- expected_todo_contenttype
September 26, 2019 12:0 AM
September 26, 2020 12:0 AM
September 26, 2020 12:0 AM
September 26, 2021 12:0 AM
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26070
--- expected_todo_contenttype_author
--- expected_todo_error_contenttype_author
--- expected_contenttype_author_daily
September 26, 2020 12:00 AM
September 26, 2019 12:00 AM
--- expected_contenttype_author_monthly
September  1, 2020 12:00 AM
September  1, 2019 12:00 AM
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26091
--- expected_todo_contenttype_author_weekly
December 25, -001 12:00 AM
--- expected_contenttype_author_yearly
January  1, 2020 12:00 AM
January  1, 2019 12:00 AM
--- expected_error_contenttype_category
Error in <mtArchiveDate> tag: You used an MTArchiveDate tag without a date context set up.
--- expected_contenttype_category_daily
September 26, 2020 12:00 AM
September 26, 2019 12:00 AM
--- expected_contenttype_category_monthly
September  1, 2020 12:00 AM
September  1, 2019 12:00 AM
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26091
--- expected_todo_contenttype_category_weekly
December 25, -001 12:00 AM
--- expected_todo_contenttype_category_monthly
September  1, 2020 12:00 AM
September  1, 2019 12:00 AM
--- expected_contenttype_category_yearly
January  1, 2020 12:00 AM
January  1, 2019 12:00 AM
--- expected_contenttype_daily
September 26, 2021 12:00 AM
September 26, 2020 12:00 AM
September 26, 2019 12:00 AM
--- expected_contenttype_monthly
September  1, 2021 12:00 AM
September  1, 2020 12:00 AM
September  1, 2019 12:00 AM
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26091
--- expected_todo_contenttype_weekly
December 25, -001 12:00 AM
--- expected_contenttype_yearly
January  1, 2021 12:00 AM
January  1, 2020 12:00 AM
January  1, 2019 12:00 AM
--- expected_daily
December  3, 2018 12:00 AM
December  3, 2017 12:00 AM
December  3, 2016 12:00 AM
December  3, 2015 12:00 AM
--- expected_individual
December  3, 2018 12:11 PM
December  3, 2018 12:11 PM
December  3, 2017 12:11 PM
December  3, 2016 12:11 PM
December  3, 2015 12:11 PM
--- expected_monthly
December  1, 2018 12:00 AM
December  1, 2017 12:00 AM
December  1, 2016 12:00 AM
December  1, 2015 12:00 AM
--- expected_page
October 29, 2036 10:11 AM
October 29, 2025 10:11 AM
October 29, 2018 10:11 AM
October 29, 2018 10:11 AM
--- expected_weekly
December  2, 2018 12:00 AM
December  3, 2017 12:00 AM
November 27, 2016 12:00 AM
November 29, 2015 12:00 AM
--- expected_yearly
January  1, 2018 12:00 AM
January  1, 2017 12:00 AM
January  1, 2016 12:00 AM
January  1, 2015 12:00 AM

=== mt:ArchiveDate (dt_field: datetime)
--- stash
{ cd => 'cd_same_apple_orange', dt_field => 'cf_same_datetime', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchiveList><mt:ArchiveDate>
</mt:ArchiveList>
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26070
--- expected_todo_author
--- expected_todo_error_author
--- expected_author_daily
December  3, 2018 12:00 AM
December  3, 2017 12:00 AM
December  3, 2016 12:00 AM
December  3, 2015 12:00 AM
--- expected_author_monthly
December  1, 2018 12:00 AM
December  1, 2017 12:00 AM
December  1, 2016 12:00 AM
December  1, 2015 12:00 AM
--- expected_author_weekly
December  2, 2018 12:00 AM
December  3, 2017 12:00 AM
November 27, 2016 12:00 AM
November 29, 2015 12:00 AM
--- expected_author_yearly
January  1, 2018 12:00 AM
January  1, 2017 12:00 AM
January  1, 2016 12:00 AM
January  1, 2015 12:00 AM
--- expected_error_category
Error in <mtArchiveDate> tag: You used an MTArchiveDate tag without a date context set up.
--- expected_category_daily
December  3, 2017 12:00 AM
December  3, 2018 12:00 AM
December  3, 2016 12:00 AM
December  3, 2016 12:00 AM
December  3, 2018 12:00 AM
--- expected_category_monthly
December  1, 2017 12:00 AM
December  1, 2018 12:00 AM
December  1, 2016 12:00 AM
December  1, 2016 12:00 AM
December  1, 2018 12:00 AM
--- expected_category_weekly
December  3, 2017 12:00 AM
December  2, 2018 12:00 AM
November 27, 2016 12:00 AM
November 27, 2016 12:00 AM
December  2, 2018 12:00 AM
--- expected_category_yearly
January  1, 2017 12:00 AM
January  1, 2018 12:00 AM
January  1, 2016 12:00 AM
January  1, 2016 12:00 AM
January  1, 2018 12:00 AM
--- expected_todo_contenttype
November  1, 2008 12:12 PM
November  1, 2004 12:12 PM
November  1, 2006 12:12 PM
November  1, 2004 12:12 PM
--- FIXME
--- expected_todo_contenttype_author
--- expected_todo_error_contenttype_author
--- expected_contenttype_author
November  1, 2008 12:00 AM
November  1, 2006 12:00 AM
November  1, 2004 12:00 AM
--- expected_contenttype_author_daily
November  1, 2008 12:00 AM
November  1, 2006 12:00 AM
November  1, 2004 12:00 AM
--- expected_contenttype_author_monthly
November  1, 2008 12:00 AM
November  1, 2006 12:00 AM
November  1, 2004 12:00 AM
--- expected_contenttype_author_weekly
October 26, 2008 12:00 AM
October 29, 2006 12:00 AM
October 31, 2004 12:00 AM
--- expected_contenttype_author_yearly
January  1, 2008 12:00 AM
January  1, 2006 12:00 AM
January  1, 2004 12:00 AM
--- expected_error_contenttype_category
Error in <mtArchiveDate> tag: You used an MTArchiveDate tag without a date context set up.
--- expected_contenttype_category_daily
November  1, 2008 12:00 AM
November  1, 2006 12:00 AM
--- expected_contenttype_category_monthly
November  1, 2008 12:00 AM
November  1, 2006 12:00 AM
--- expected_contenttype_category_weekly
October 26, 2008 12:00 AM
October 29, 2006 12:00 AM
--- expected_contenttype_category_yearly
January  1, 2008 12:00 AM
January  1, 2006 12:00 AM
--- expected_contenttype_daily
November  1, 2008 12:00 AM
November  1, 2006 12:00 AM
November  1, 2004 12:00 AM
--- expected_contenttype_monthly
November  1, 2008 12:00 AM
November  1, 2006 12:00 AM
November  1, 2004 12:00 AM
--- expected_contenttype_weekly
October 26, 2008 12:00 AM
October 29, 2006 12:00 AM
October 31, 2004 12:00 AM
--- expected_contenttype_yearly
January  1, 2008 12:00 AM
January  1, 2006 12:00 AM
January  1, 2004 12:00 AM
--- expected_daily
December  3, 2018 12:00 AM
December  3, 2017 12:00 AM
December  3, 2016 12:00 AM
December  3, 2015 12:00 AM
--- expected_individual
December  3, 2018 12:11 PM
December  3, 2018 12:11 PM
December  3, 2017 12:11 PM
December  3, 2016 12:11 PM
December  3, 2015 12:11 PM
--- expected_monthly
December  1, 2018 12:00 AM
December  1, 2017 12:00 AM
December  1, 2016 12:00 AM
December  1, 2015 12:00 AM
--- expected_page
October 29, 2036 10:11 AM
October 29, 2025 10:11 AM
October 29, 2018 10:11 AM
October 29, 2018 10:11 AM
--- expected_weekly
December  2, 2018 12:00 AM
December  3, 2017 12:00 AM
November 27, 2016 12:00 AM
November 29, 2015 12:00 AM
--- expected_yearly
January  1, 2018 12:00 AM
January  1, 2017 12:00 AM
January  1, 2016 12:00 AM
January  1, 2015 12:00 AM

=== mt:ArchiveDateEnd (authored_on)
--- stash
{ cd => 'cd_same_apple_orange', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchiveList><mt:ArchiveDateEnd>
</mt:ArchiveList>
--- expected_error_author
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_author_daily
December  3, 2018 11:59 PM
December  3, 2017 11:59 PM
December  3, 2016 11:59 PM
December  3, 2015 11:59 PM
--- expected_author_monthly
December 31, 2018 11:59 PM
December 31, 2017 11:59 PM
December 31, 2016 11:59 PM
December 31, 2015 11:59 PM
--- expected_author_weekly
December  8, 2018 11:59 PM
December  9, 2017 11:59 PM
December  3, 2016 11:59 PM
December  5, 2015 11:59 PM
--- expected_author_yearly
December 31, 2018 11:59 PM
December 31, 2017 11:59 PM
December 31, 2016 11:59 PM
December 31, 2015 11:59 PM
--- expected_error_category
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_category_daily
December  3, 2017 11:59 PM
December  3, 2018 11:59 PM
December  3, 2016 11:59 PM
December  3, 2016 11:59 PM
December  3, 2018 11:59 PM
--- expected_category_monthly
December 31, 2017 11:59 PM
December 31, 2018 11:59 PM
December 31, 2016 11:59 PM
December 31, 2016 11:59 PM
December 31, 2018 11:59 PM
--- expected_category_weekly
December  9, 2017 11:59 PM
December  8, 2018 11:59 PM
December  3, 2016 11:59 PM
December  3, 2016 11:59 PM
December  8, 2018 11:59 PM
--- expected_category_yearly
December 31, 2017 11:59 PM
December 31, 2018 11:59 PM
December 31, 2016 11:59 PM
December 31, 2016 11:59 PM
December 31, 2018 11:59 PM
--- expected_error_contenttype
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_error_contenttype_author
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_contenttype_author_daily
October 31, 2018 11:59 PM
October 31, 2017 11:59 PM
--- expected_contenttype_author_monthly
October 31, 2018 11:59 PM
October 31, 2017 11:59 PM
--- expected_contenttype_author_weekly
November  3, 2018 11:59 PM
November  4, 2017 11:59 PM
--- expected_contenttype_author_yearly
December 31, 2018 11:59 PM
December 31, 2017 11:59 PM
--- expected_error_contenttype_category
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_contenttype_category_daily
October 31, 2018 11:59 PM
October 31, 2017 11:59 PM
--- expected_contenttype_category_monthly
October 31, 2018 11:59 PM
October 31, 2017 11:59 PM
--- expected_contenttype_category_weekly
November  3, 2018 11:59 PM
November  4, 2017 11:59 PM
--- expected_contenttype_category_yearly
December 31, 2018 11:59 PM
December 31, 2017 11:59 PM
--- expected_contenttype_daily
October 31, 2018 11:59 PM
October 31, 2017 11:59 PM
October 31, 2016 11:59 PM
--- expected_contenttype_monthly
October 31, 2018 11:59 PM
October 31, 2017 11:59 PM
October 31, 2016 11:59 PM
--- expected_contenttype_weekly
November  3, 2018 11:59 PM
November  4, 2017 11:59 PM
November  5, 2016 11:59 PM
--- expected_contenttype_yearly
December 31, 2018 11:59 PM
December 31, 2017 11:59 PM
December 31, 2016 11:59 PM
--- expected_daily
December  3, 2018 11:59 PM
December  3, 2017 11:59 PM
December  3, 2016 11:59 PM
December  3, 2015 11:59 PM
--- expected_error_individual
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_monthly
December 31, 2018 11:59 PM
December 31, 2017 11:59 PM
December 31, 2016 11:59 PM
December 31, 2015 11:59 PM
--- expected_error_page
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_weekly
December  8, 2018 11:59 PM
December  9, 2017 11:59 PM
December  3, 2016 11:59 PM
December  5, 2015 11:59 PM
--- expected_yearly
December 31, 2018 11:59 PM
December 31, 2017 11:59 PM
December 31, 2016 11:59 PM
December 31, 2015 11:59 PM

=== mt:ArchiveDateEnd (dt_field: date)
--- stash
{ cd => 'cd_same_apple_orange', dt_field => 'cf_same_date', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchiveList><mt:ArchiveDateEnd>
</mt:ArchiveList>
--- expected_error_author
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_author_daily
December  3, 2018 11:59 PM
December  3, 2017 11:59 PM
December  3, 2016 11:59 PM
December  3, 2015 11:59 PM
--- expected_author_monthly
December 31, 2018 11:59 PM
December 31, 2017 11:59 PM
December 31, 2016 11:59 PM
December 31, 2015 11:59 PM
--- expected_author_weekly
December  8, 2018 11:59 PM
December  9, 2017 11:59 PM
December  3, 2016 11:59 PM
December  5, 2015 11:59 PM
--- expected_author_yearly
December 31, 2018 11:59 PM
December 31, 2017 11:59 PM
December 31, 2016 11:59 PM
December 31, 2015 11:59 PM
--- expected_error_category
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_category_daily
December  3, 2017 11:59 PM
December  3, 2018 11:59 PM
December  3, 2016 11:59 PM
December  3, 2016 11:59 PM
December  3, 2018 11:59 PM
--- expected_category_monthly
December 31, 2017 11:59 PM
December 31, 2018 11:59 PM
December 31, 2016 11:59 PM
December 31, 2016 11:59 PM
December 31, 2018 11:59 PM
--- expected_category_weekly
December  9, 2017 11:59 PM
December  8, 2018 11:59 PM
December  3, 2016 11:59 PM
December  3, 2016 11:59 PM
December  8, 2018 11:59 PM
--- expected_category_yearly
December 31, 2017 11:59 PM
December 31, 2018 11:59 PM
December 31, 2016 11:59 PM
December 31, 2016 11:59 PM
December 31, 2018 11:59 PM
--- expected_error_contenttype
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_error_contenttype_author
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_contenttype_author_daily
September 26, 2020 11:59 PM
September 26, 2019 11:59 PM
--- expected_contenttype_author_monthly
September 30, 2020 11:59 PM
September 30, 2019 11:59 PM
--- expected_todo_contenttype_author_weekly
December 31, -001 11:59 PM
--- expected_contenttype_author_yearly
December 31, 2020 11:59 PM
December 31, 2019 11:59 PM
--- expected_todo_error_contenttype_category
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_contenttype_category_daily
September 26, 2020 11:59 PM
September 26, 2019 11:59 PM
--- expected_contenttype_category_monthly
September 30, 2020 11:59 PM
September 30, 2019 11:59 PM
--- expected_todo_contenttype_category_weekly
December 31, -001 11:59 PM
--- expected_contenttype_category_yearly
December 31, 2020 11:59 PM
December 31, 2019 11:59 PM
--- expected_contenttype_daily
September 26, 2021 11:59 PM
September 26, 2020 11:59 PM
September 26, 2019 11:59 PM
--- expected_contenttype_monthly
September 30, 2021 11:59 PM
September 30, 2020 11:59 PM
September 30, 2019 11:59 PM
--- expected_todo_contenttype_weekly
December 31, -001 11:59 PM
--- expected_contenttype_yearly
December 31, 2021 11:59 PM
December 31, 2020 11:59 PM
December 31, 2019 11:59 PM
--- expected_daily
December  3, 2018 11:59 PM
December  3, 2017 11:59 PM
December  3, 2016 11:59 PM
December  3, 2015 11:59 PM
--- expected_error_individual
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_monthly
December 31, 2018 11:59 PM
December 31, 2017 11:59 PM
December 31, 2016 11:59 PM
December 31, 2015 11:59 PM
--- expected_error_page
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_weekly
December  8, 2018 11:59 PM
December  9, 2017 11:59 PM
December  3, 2016 11:59 PM
December  5, 2015 11:59 PM
--- expected_yearly
December 31, 2018 11:59 PM
December 31, 2017 11:59 PM
December 31, 2016 11:59 PM
December 31, 2015 11:59 PM

=== mt:ArchiveDateEnd (dt_field: datetime)
--- stash
{ cd => 'cd_same_apple_orange', dt_field => 'cf_same_datetime', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchiveList><mt:ArchiveDateEnd>
</mt:ArchiveList>
--- expected_error_author
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_author_daily
December  3, 2018 11:59 PM
December  3, 2017 11:59 PM
December  3, 2016 11:59 PM
December  3, 2015 11:59 PM
--- expected_author_monthly
December 31, 2018 11:59 PM
December 31, 2017 11:59 PM
December 31, 2016 11:59 PM
December 31, 2015 11:59 PM
--- expected_author_weekly
December  8, 2018 11:59 PM
December  9, 2017 11:59 PM
December  3, 2016 11:59 PM
December  5, 2015 11:59 PM
--- expected_author_yearly
December 31, 2018 11:59 PM
December 31, 2017 11:59 PM
December 31, 2016 11:59 PM
December 31, 2015 11:59 PM
--- expected_error_category
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_category_daily
December  3, 2017 11:59 PM
December  3, 2018 11:59 PM
December  3, 2016 11:59 PM
December  3, 2016 11:59 PM
December  3, 2018 11:59 PM
--- expected_category_monthly
December 31, 2017 11:59 PM
December 31, 2018 11:59 PM
December 31, 2016 11:59 PM
December 31, 2016 11:59 PM
December 31, 2018 11:59 PM
--- expected_category_weekly
December  9, 2017 11:59 PM
December  8, 2018 11:59 PM
December  3, 2016 11:59 PM
December  3, 2016 11:59 PM
December  8, 2018 11:59 PM
--- expected_category_yearly
December 31, 2017 11:59 PM
December 31, 2018 11:59 PM
December 31, 2016 11:59 PM
December 31, 2016 11:59 PM
December 31, 2018 11:59 PM
--- expected_error_contenttype
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_error_contenttype_author
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_contenttype_author_daily
November  1, 2008 11:59 PM
November  1, 2006 11:59 PM
November  1, 2004 11:59 PM
--- expected_contenttype_author_monthly
November 30, 2008 11:59 PM
November 30, 2006 11:59 PM
November 30, 2004 11:59 PM
--- expected_contenttype_author_weekly
November  1, 2008 11:59 PM
November  4, 2006 11:59 PM
November  6, 2004 11:59 PM
--- expected_contenttype_author_yearly
December 31, 2008 11:59 PM
December 31, 2006 11:59 PM
December 31, 2004 11:59 PM
--- expected_error_contenttype_category
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_contenttype_category_daily
November  1, 2008 11:59 PM
November  1, 2006 11:59 PM
--- expected_contenttype_category_daily
November  1, 2008 11:59 PM
November  1, 2006 11:59 PM
--- expected_contenttype_category_monthly
November 30, 2008 11:59 PM
November 30, 2006 11:59 PM
--- expected_contenttype_category_weekly
November  1, 2008 11:59 PM
November  4, 2006 11:59 PM
--- expected_contenttype_category_yearly
December 31, 2008 11:59 PM
December 31, 2006 11:59 PM
--- expected_contenttype_daily
November  1, 2008 11:59 PM
November  1, 2006 11:59 PM
November  1, 2004 11:59 PM
--- expected_contenttype_monthly
November 30, 2008 11:59 PM
November 30, 2006 11:59 PM
November 30, 2004 11:59 PM
--- expected_contenttype_weekly
November  1, 2008 11:59 PM
November  4, 2006 11:59 PM
November  6, 2004 11:59 PM
--- expected_contenttype_yearly
December 31, 2008 11:59 PM
December 31, 2006 11:59 PM
December 31, 2004 11:59 PM
--- expected_daily
December  3, 2018 11:59 PM
December  3, 2017 11:59 PM
December  3, 2016 11:59 PM
December  3, 2015 11:59 PM
--- expected_error_individual
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_monthly
December 31, 2018 11:59 PM
December 31, 2017 11:59 PM
December 31, 2016 11:59 PM
December 31, 2015 11:59 PM
--- expected_error_page
Error in <mtArchiveDateEnd> tag: <$MTArchiveDateEnd$> can be used only with Daily, Weekly, or Monthly archives.
--- expected_weekly
December  8, 2018 11:59 PM
December  9, 2017 11:59 PM
December  3, 2016 11:59 PM
December  5, 2015 11:59 PM
--- expected_yearly
December 31, 2018 11:59 PM
December 31, 2017 11:59 PM
December 31, 2016 11:59 PM
December 31, 2015 11:59 PM
