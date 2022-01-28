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
        DefaultLanguage      => 'en_US',  ## for now
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

=== ArchiveCount
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
<mt:ArchiveList archive_type="[% archive_type %]"><mt:ArchiveTitle>:<mt:ArchiveCount>
</mt:ArchiveList>
--- expected_author
author1:3
author2:2
--- expected_author_daily
December  3, 2018:2
December  3, 2017:1
--- expected_author_monthly
December 2018:2
December 2017:1
--- expected_author_weekly
December  2, 2018 - December  8, 2018:2
December  3, 2017 - December  9, 2017:1
--- expected_author_yearly
2018:2
2017:1
--- expected_category
cat_compass:1
cat_eraser:3
cat_pencil:1
cat_ruler:2
--- expected_category_daily
December  3, 2018:2
December  3, 2016:1
--- expected_category_monthly
December 2018:2
December 2016:1
--- expected_category_weekly
December  2, 2018 - December  8, 2018:2
November 27, 2016 - December  3, 2016:1
--- expected_category_yearly
2018:2
2016:1
--- expected_daily
December  3, 2018:2
December  3, 2017:1
December  3, 2016:1
December  3, 2015:1
--- expected_individual
entry_author1_ruler_eraser:1
entry_author1_ruler_eraser:1
entry_author1_compass:1
entry_author2_pencil_eraser:1
entry_author2_no_category:1
--- expected_weekly
December  2, 2018 - December  8, 2018:2
December  3, 2017 - December  9, 2017:1
November 27, 2016 - December  3, 2016:1
November 29, 2015 - December  5, 2015:1
--- expected_monthly
December 2018:2
December 2017:1
December 2016:1
December 2015:1
--- expected_page
page_author2_no_folder:1
page_author2_water:1
page_author1_coffee:1
page_author1_coffee:1
--- expected_yearly
2018:2
2017:1
2016:1
2015:1
--- expected_contenttype
cd_same_apple_orange:1
cd_same_same_date:1
cd_same_apple_orange_peach:1
cd_same_peach:1
--- expected_contenttype_author
author1:3
author2:1
--- expected_contenttype_author_daily
October 31, 2018:2
October 31, 2017:1
--- expected_contenttype_author_monthly
October 2018:2
October 2017:1
--- expected_contenttype_author_weekly
October 28, 2018 - November  3, 2018:2
October 29, 2017 - November  4, 2017:1
--- expected_contenttype_author_yearly
2018:2
2017:1
--- expected_contenttype_category
cat_apple:2
cat_orange:2
cat_peach:3
cat_strawberry:0
--- expected_contenttype_category_daily
October 31, 2018:1
October 31, 2017:1
--- expected_contenttype_category_monthly
October 2018:1
October 2017:1
--- expected_contenttype_category_weekly
October 28, 2018 - November  3, 2018:1
October 29, 2017 - November  4, 2017:1
--- expected_contenttype_category_yearly
2018:1
2017:1
--- expected_contenttype_daily
October 31, 2018:2
October 31, 2017:1
October 31, 2016:1
--- expected_contenttype_monthly
October 2018:2
October 2017:1
October 2016:1
--- expected_contenttype_weekly
October 28, 2018 - November  3, 2018:2
October 29, 2017 - November  4, 2017:1
October 30, 2016 - November  5, 2016:1
--- expected_contenttype_yearly
2018:2
2017:1
2016:1
