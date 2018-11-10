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
{ cd => 'cd_same_apple_orange', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchivePrevious><mt:ArchiveTitle> | <mt:ArchiveLink>
</mt:ArchivePrevious>
--- expected_todo_author
--- expected_php_todo_author
--- expected_todo_author_daily
--- expected_todo_author_monthly
--- expected_todo_author_weekly
--- expected_todo_author_yearly
--- expected_todo_category
--- expected_todo_category_daily
--- expected_todo_category_monthly
--- expected_todo_category_weekly
--- expected_todo_category_yearly
--- expected_contenttype
cd_same_apple_orange_peach | http://narnia.na/2017/10/[% cd_same_apple_orange_peach_unique_id %].html
--- expected_php_todo_contenttype
--- expected_contenttype_author
--- expected_php_todo_contenttype_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_author_daily
author1: October 31, 2017 | http://narnia.na/author/author1/2017/10/31/
--- expected_php_todo_contenttype_author_daily
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
--- expected_contenttype_category_monthly
cat_apple: October 2017 | http://narnia.na/cat-apple/2017/10/
--- expected_php_todo_contenttype_category_monthly
--- expected_contenttype_category_weekly
cat_apple: October 29, 2017 - November  4, 2017 | http://narnia.na/cat-apple/2017/10/29-week/
--- expected_php_todo_contenttype_category_weekly
--- expected_contenttype_category_yearly
cat_apple: 2017 | http://narnia.na/cat-apple/2017/
--- expected_php_todo_contenttype_category_yearly
--- expected_contenttype_daily
October 31, 2017 | http://narnia.na/2017/10/31/
--- expected_contenttype_monthly
October 2017 | http://narnia.na/2017/10/
--- expected_contenttype_weekly
October 29, 2017 - November  4, 2017 | http://narnia.na/2017/10/29-week/
--- expected_contenttype_yearly
2017 | http://narnia.na/2017/
--- expected_error_daily
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_daily
You used an <mtarchiveprevious> without a date context set up.
, 0000 |
--- expected_error_individual
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_individual
You used an <mtarchiveprevious> without a date context set up.
0000 |
--- expected_error_monthly
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_monthly
You used an <mtarchiveprevious> without a date context set up.
0000 |
--- expected_error_error_page
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_page
--- expected_error_weekly
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_weekly
You used an <mtarchiveprevious> without a date context set up.
December 31, 0000 -   6, 0000 |
--- expected_error_yearly
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_yearly
You used an <mtarchiveprevious> without a date context set up.
0101 |




=== mt:ArchivePrevious (date, cat_apple)
--- stash
{ cd => 'cd_same_apple_orange', dt_field => 'cf_same_date', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchivePrevious><mt:ArchiveTitle> | <mt:ArchiveLink>
</mt:ArchivePrevious>
--- expected_todo_author
--- expected_php_todo_author
--- expected_todo_author_daily
--- expected_todo_author_monthly
--- expected_todo_author_weekly
--- expected_todo_author_yearly
--- expected_todo_category
--- expected_todo_category_daily
--- expected_todo_category_monthly
--- expected_todo_category_weekly
--- expected_todo_category_yearly
--- expected_contenttype
cd_same_apple_orange_peach | http://narnia.na/2017/10/[% cd_same_apple_orange_peach_unique_id %].html
--- expected_php_todo_contenttype
--- expected_contenttype_author
--- expected_php_todo_contenttype_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_author_daily
--- expected_php_todo_contenttype_author_daily
--- expected_contenttype_author_monthly
--- expected_php_todo_contenttype_author_monthly
--- expected_contenttype_author_weekly
--- expected_php_todo_contenttype_author_weekly
--- expected_contenttype_author_yearly
--- expected_php_todo_contenttype_author_yearly
--- expected_contenttype_category
--- expected_contenttype_category_daily
--- expected_php_todo_contenttype_category_daily
--- expected_contenttype_category_monthly
--- expected_php_todo_contenttype_category_monthly
--- expected_contenttype_category_weekly
--- expected_contenttype_category_yearly
--- expected_contenttype_daily
--- expected_php_todo_contenttype_daily
--- expected_contenttype_monthly
--- expected_php_todo_contenttype_monthly
--- expected_contenttype_weekly
--- expected_php_todo_contenttype_weekly
--- expected_contenttype_yearly
--- expected_php_todo_contenttype_yearly
--- expected_error_daily
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_daily
You used an <mtarchiveprevious> without a date context set up.
, 0000 |
--- expected_error_individual
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_individual
You used an <mtarchiveprevious> without a date context set up.
0000 |
--- expected_error_monthly
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_monthly
You used an <mtarchiveprevious> without a date context set up.
0000 |
--- expected_error_error_page
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_page
--- expected_error_weekly
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_weekly
You used an <mtarchiveprevious> without a date context set up.
December 31, 0000 -   6, 0000 |
--- expected_error_yearly
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_yearly
You used an <mtarchiveprevious> without a date context set up.
0101 |


=== mt:ArchivePrevious (datetime, cat_apple)
--- stash
{ cd => 'cd_same_apple_orange', dt_field => 'cf_same_datetime', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:ArchivePrevious><mt:ArchiveTitle> | <mt:ArchiveLink>
</mt:ArchivePrevious>
--- expected_author
--- expected_php_todo_author
--- expected_todo_author_daily
--- expected_todo_author_monthly
--- expected_todo_author_weekly
--- expected_todo_author_yearly
--- expected_todo_category
--- expected_todo_category_daily
--- expected_todo_category_monthly
--- expected_todo_category_weekly
--- expected_todo_category_yearly
--- expected_contenttype
cd_same_apple_orange_peach | http://narnia.na/2017/10/[% cd_same_apple_orange_peach_unique_id %].html
--- expected_php_todo_contenttype
--- expected_contenttype_author
--- expected_php_todo_contenttype_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_author_daily
author1: November  1, 2006 | http://narnia.na/author/author1/2006/11/01/
--- expected_php_todo_contenttype_author_daily
--- expected_contenttype_author_monthly
author1: November 2006 | http://narnia.na/author/author1/2006/11/
--- expected_php_todo_contenttype_author_monthly
--- expected_contenttype_author_weekly
author1: October 29, 2006 - November  4, 2006 | http://narnia.na/author/author1/2006/10/29-week/
--- expected_php_todo_contenttype_author_weekly
--- expected_contenttype_author_yearly
author1: 2006 | http://narnia.na/author/author1/2006/
--- expected_php_todo_contenttype_author_yearly
--- expected_contenttype_category
--- expected_contenttype_category_daily
cat_apple: November  1, 2006 | http://narnia.na/cat-apple/2006/11/01/
--- expected_php_todo_contenttype_category_daily
--- expected_contenttype_category_monthly
cat_apple: November 2006 | http://narnia.na/cat-apple/2006/11/
--- expected_php_todo_contenttype_category_monthly
--- expected_contenttype_category_weekly
cat_apple: October 29, 2006 - November  4, 2006 | http://narnia.na/cat-apple/2006/10/29-week/
--- expected_php_todo_contenttype_category_weekly
--- expected_contenttype_category_yearly
cat_apple: 2006 | http://narnia.na/cat-apple/2006/
--- expected_php_todo_contenttype_category_yearly
--- expected_contenttype_daily
November  1, 2006 | http://narnia.na/2006/11/01/
--- expected_contenttype_monthly
November 2006 | http://narnia.na/2006/11/
--- expected_contenttype_weekly
October 29, 2006 - November  4, 2006 | http://narnia.na/2006/10/29-week/
--- expected_contenttype_yearly
2006 | http://narnia.na/2006/
--- expected_error_daily
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_daily
You used an <mtarchiveprevious> without a date context set up.
, 0000 |
--- expected_error_individual
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_individual
You used an <mtarchiveprevious> without a date context set up.
0000 |
--- expected_error_monthly
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_monthly
You used an <mtarchiveprevious> without a date context set up.
0000 |
--- expected_error_error_page
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_page
--- expected_error_weekly
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_weekly
You used an <mtarchiveprevious> without a date context set up.
December 31, 0000 -   6, 0000 |
--- expected_error_yearly
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_yearly
You used an <mtarchiveprevious> without a date context set up.
0101 |


=== mt:ArchivePrevious with content_type
--- stash
{ cd => 'cd_same_apple_orange', cat_field => 'cf_same_catset_fruit', category => 'cat_apple'}
--- template
<mt:ArchivePrevious content_type="[% cd_same_apple_orange_unique_id %]"><mt:ArchiveTitle> | <mt:ArchiveLink>
</mt:ArchivePrevious>
--- expected_error
No Content Type could be found.
--- expected_todo_author_daily
--- expected_todo_author_monthly
--- expected_todo_author_weekly
--- expected_todo_author_yearly
--- expected_todo_category
--- expected_todo_category_daily
--- expected_todo_category_monthly
--- expected_todo_category_weekly
--- expected_todo_category_yearly
--- expected_contenttype
cd_same_apple_orange_peach | http://narnia.na/2017/10/[% cd_same_apple_orange_peach_unique_id %].html
--- expected_php_todo_contenttype
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
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26117
--- expected_contenttype_category_daily
cat_apple: October 31, 2017 | http://narnia.na/cat-apple/2017/10/31/
--- expected_php_todo_contenttype_category_daily
--- expected_contenttype_category_monthly
cat_apple: October 2017 | http://narnia.na/cat-apple/2017/10/
--- expected_php_todo_contenttype_category_monthly
--- expected_contenttype_category_weekly
cat_apple: October 29, 2017 - November  4, 2017 | http://narnia.na/cat-apple/2017/10/29-week/
--- expected_php_todo_contenttype_category_weekly
--- expected_contenttype_category_yearly
cat_apple: 2017 | http://narnia.na/cat-apple/2017/
--- expected_php_todo_contenttype_category_yearly
--- expected_contenttype_daily
October 31, 2017 | http://narnia.na/2017/10/31/
--- expected_contenttype_monthly
October 2017 | http://narnia.na/2017/10/
--- expected_contenttype_weekly
October 29, 2017 - November  4, 2017 | http://narnia.na/2017/10/29-week/
--- expected_contenttype_yearly
2017 | http://narnia.na/2017/
--- expected_error_daily
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_daily
You used an <mtarchiveprevious> without a date context set up.
, 0000 |
--- expected_error_individual
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_individual
You used an <mtarchiveprevious> without a date context set up.
0000 |
--- expected_error_monthly
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_monthly
You used an <mtarchiveprevious> without a date context set up.
0000 |
--- expected_error_error_page
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_page
--- expected_error_weekly
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_weekly
You used an <mtarchiveprevious> without a date context set up.
December 31, 0000 -   6, 0000 |
--- expected_error_yearly
You used an MTarchiveprevious tag without a date context set up.
--- expected_php_todo_yearly
You used an <mtarchiveprevious> without a date context set up.
0101 |
