#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

filters {
    archive_type => [qw( chomp )],
    template     => [qw( chomp )],
    expected     => [qw( chomp )],
};

$test_env->prepare_fixture('archive_type_simple');
my $objs    = MT::Test::Fixture::ArchiveType->load_objs;
my $blog_id = $objs->{blog_id};

my @archive_types = sort MT->publisher->archive_types;
my $archive_types = join ',', @archive_types;

foreach my $archive_type (@archive_types) {
    MT::Test::Tag->run_perl_tests(
        $blog_id,
        sub {
            my ( $ctx, $block ) = @_;
            my $site = $ctx->stash('blog');
            $site->archive_type(
                defined $block->archive_type
                ? $block->archive_type
                : $archive_types
            );
        },
        $archive_type
    );
    MT::Test::Tag->run_php_tests(
        $blog_id,
        sub {
            my ($block) = @_;
            my $archive_type
                = defined $block->archive_type
                ? $block->archive_type
                : $archive_types;
            return <<"PHP";
\$site = \$ctx->stash('blog');
\$site->archive_type = "$archive_type";
\$site->save();
PHP
        },
        $archive_type
    );
}

done_testing;

__END__

=== Some ArchiveTitles with type
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26105
https://movabletype.atlassian.net/browse/MTC-26106
https://movabletype.atlassian.net/browse/MTC-26107
https://movabletype.atlassian.net/browse/MTC-26108
--- template
<mt:ArchiveList type="[% archive_type %]" content_type="ct_with_same_catset"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected_author
author1
author2
--- expected_php_todo_author
--- expected_author_daily
author1: December  3, 2018
author1: December  3, 2017
author2: December  3, 2016
author2: December  3, 2015
--- expected_author_monthly
author1: December 2018
author1: December 2017
author2: December 2016
author2: December 2015
--- expected_author_weekly
author1: December  2, 2018 - December  8, 2018
author1: December  3, 2017 - December  9, 2017
author2: November 27, 2016 - December  3, 2016
author2: November 29, 2015 - December  5, 2015
--- expected_author_yearly
author1: 2018
author1: 2017
author2: 2016
author2: 2015
--- expected_category
cat_compass
cat_pencil
cat_ruler
--- expected_category_daily
cat_compass: December  3, 2017
cat_pencil: December  3, 2016
cat_ruler: December  3, 2018
--- expected_category_monthly
cat_compass: December 2017
cat_pencil: December 2016
cat_ruler: December 2018
--- expected_category_weekly
cat_compass: December  3, 2017 - December  9, 2017
cat_pencil: November 27, 2016 - December  3, 2016
cat_ruler: December  2, 2018 - December  8, 2018
--- expected_category_yearly
cat_compass: 2017
cat_pencil: 2016
cat_ruler: 2018
--- expected_todo_contenttype
cd_same_same_date
cd_same_apple_orange
cd_same_apple_orange_peach
cd_same_peach
--- expected_contenttype_author
author1
author2
--- expected_contenttype_author_daily
author1: October 31, 2018
author1: October 31, 2017
author2: October 31, 2016
--- expected_contenttype_author_monthly
author1: October 2018
author1: October 2017
author2: October 2016
--- expected_contenttype_author_weekly
author1: October 28, 2018 - November  3, 2018
author1: October 29, 2017 - November  4, 2017
author2: October 30, 2016 - November  5, 2016
--- expected_contenttype_author_yearly
author1: 2018
author1: 2017
author2: 2016
--- expected_contenttype_category
cat_apple
cat_peach
--- expected_php_todo_contenttype_category
--- expected_todo_contenttype_category_daily
cat_apple: October 31, 2018
cat_apple: October 31, 2017
cat_peach: October 31, 2016
--- expected_todo_contenttype_category_monthly
cat_apple: October 2018
cat_apple: October 2017
cat_peach: October 2016
--- expected_todo_contenttype_category_weekly
cat_apple: October 28, 2018 - November  3, 2018
cat_apple: October 29, 2017 - November  4, 2017
cat_peach: October 30, 2016 - November  5, 2016
--- expected_todo_contenttype_category_yearly
cat_apple: 2018
cat_apple: 2017
cat_peach: 2016
--- expected_contenttype_daily
October 31, 2018
October 31, 2017
October 31, 2016
--- expected_contenttype_monthly
October 2018
October 2017
October 2016
--- expected_contenttype_weekly
October 28, 2018 - November  3, 2018
October 29, 2017 - November  4, 2017
October 30, 2016 - November  5, 2016
--- expected_contenttype_yearly
2018
2017
2016
--- expected_daily
December  3, 2018
December  3, 2017
December  3, 2016
December  3, 2015
--- expected_individual
entry_author1_ruler_eraser
entry_author1_ruler_eraser
entry_author1_compass
entry_author2_pencil_eraser
entry_author2_no_category
--- expected_weekly
December  2, 2018 - December  8, 2018
December  3, 2017 - December  9, 2017
November 27, 2016 - December  3, 2016
November 29, 2015 - December  5, 2015
--- expected_monthly
December 2018
December 2017
December 2016
December 2015
--- expected_page
page_author2_no_folder
page_author2_water
page_author1_coffee
page_author1_coffee
--- expected_yearly
2018
2017
2016
2015

=== Some ArchiveTitles with archive_type
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26105
https://movabletype.atlassian.net/browse/MTC-26106
https://movabletype.atlassian.net/browse/MTC-26107
https://movabletype.atlassian.net/browse/MTC-26108
--- template
<mt:ArchiveList archive_type="[% archive_type %]" content_type="ct_with_same_catset"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected_author
author1
author2
--- expected_php_todo_author
--- expected_author_daily
author1: December  3, 2018
author1: December  3, 2017
author2: December  3, 2016
author2: December  3, 2015
--- expected_author_monthly
author1: December 2018
author1: December 2017
author2: December 2016
author2: December 2015
--- expected_author_weekly
author1: December  2, 2018 - December  8, 2018
author1: December  3, 2017 - December  9, 2017
author2: November 27, 2016 - December  3, 2016
author2: November 29, 2015 - December  5, 2015
--- expected_author_yearly
author1: 2018
author1: 2017
author2: 2016
author2: 2015
--- expected_category
cat_compass
cat_pencil
cat_ruler
--- expected_category_daily
cat_compass: December  3, 2017
cat_pencil: December  3, 2016
cat_ruler: December  3, 2018
--- expected_category_monthly
cat_compass: December 2017
cat_pencil: December 2016
cat_ruler: December 2018
--- expected_category_weekly
cat_compass: December  3, 2017 - December  9, 2017
cat_pencil: November 27, 2016 - December  3, 2016
cat_ruler: December  2, 2018 - December  8, 2018
--- expected_category_yearly
cat_compass: 2017
cat_pencil: 2016
cat_ruler: 2018
--- expected_todo_contenttype
cd_same_same_date
cd_same_apple_orange
cd_same_apple_orange_peach
cd_same_peach
--- expected_contenttype_author
author1
author2
--- expected_contenttype_author_daily
author1: October 31, 2018
author1: October 31, 2017
author2: October 31, 2016
--- expected_contenttype_author_monthly
author1: October 2018
author1: October 2017
author2: October 2016
--- expected_contenttype_author_weekly
author1: October 28, 2018 - November  3, 2018
author1: October 29, 2017 - November  4, 2017
author2: October 30, 2016 - November  5, 2016
--- expected_contenttype_author_yearly
author1: 2018
author1: 2017
author2: 2016
--- expected_contenttype_category
cat_apple
cat_peach
--- expected_php_todo_contenttype_category
--- expected_todo_contenttype_category_daily
cat_apple: October 31, 2018
cat_apple: October 31, 2017
cat_peach: October 31, 2016
--- expected_todo_contenttype_category_monthly
cat_apple: October 2018
cat_apple: October 2017
cat_peach: October 2016
--- expected_todo_contenttype_category_weekly
cat_apple: October 28, 2018 - November  3, 2018
cat_apple: October 29, 2017 - November  4, 2017
cat_peach: October 30, 2016 - November  5, 2016
--- expected_todo_contenttype_category_yearly
cat_apple: 2018
cat_apple: 2017
cat_peach: 2016
--- expected_contenttype_daily
October 31, 2018
October 31, 2017
October 31, 2016
--- expected_contenttype_monthly
October 2018
October 2017
October 2016
--- expected_contenttype_weekly
October 28, 2018 - November  3, 2018
October 29, 2017 - November  4, 2017
October 30, 2016 - November  5, 2016
--- expected_contenttype_yearly
2018
2017
2016
--- expected_daily
December  3, 2018
December  3, 2017
December  3, 2016
December  3, 2015
--- expected_individual
entry_author1_ruler_eraser
entry_author1_ruler_eraser
entry_author1_compass
entry_author2_pencil_eraser
entry_author2_no_category
--- expected_weekly
December  2, 2018 - December  8, 2018
December  3, 2017 - December  9, 2017
November 27, 2016 - December  3, 2016
November 29, 2015 - December  5, 2015
--- expected_monthly
December 2018
December 2017
December 2016
December 2015
--- expected_page
page_author2_no_folder
page_author2_water
page_author1_coffee
page_author1_coffee
--- expected_yearly
2018
2017
2016
2015

=== Empty with type
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26109
--- archive_type
--- template
<mt:ArchiveList type="[% archive_type %]" content_type="ct_with_same_catset"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected
--- expected_php_todo

=== Empty with archive_type
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26109
--- archive_type
--- template
<mt:ArchiveList archive_type="[% archive_type %]" content_type="ct_with_same_catset"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected
--- expected_php_todo

=== None with type
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26109
--- archive_type
None
--- template
<mt:ArchiveList type="[% archive_type %]"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected
--- expected_php_todo

=== sort_order="ascend"
--- template
<mt:ArchiveList type="[% archive_type %]" sort_order="ascend" content_type="ct_with_same_catset"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected_author
author1
author2
--- expected_author_daily
author1: December  3, 2017
author1: December  3, 2018
author2: December  3, 2015
author2: December  3, 2016
--- expected_author_monthly
author1: December 2017
author1: December 2018
author2: December 2015
author2: December 2016
--- expected_author_weekly
author1: December  3, 2017 - December  9, 2017
author1: December  2, 2018 - December  8, 2018
author2: November 29, 2015 - December  5, 2015
author2: November 27, 2016 - December  3, 2016
--- expected_author_yearly
author1: 2017
author1: 2018
author2: 2015
author2: 2016
--- expected_category
cat_compass
cat_pencil
cat_ruler
--- expected_category_daily
cat_compass: December  3, 2017
cat_pencil: December  3, 2016
cat_ruler: December  3, 2018
--- expected_category_monthly
cat_compass: December 2017
cat_pencil: December 2016
cat_ruler: December 2018
--- expected_category_weekly
cat_compass: December  3, 2017 - December  9, 2017
cat_pencil: November 27, 2016 - December  3, 2016
cat_ruler: December  2, 2018 - December  8, 2018
--- expected_category_yearly
cat_compass: 2017
cat_pencil: 2016
cat_ruler: 2018
--- expected_todo_contenttype
cd_same_apple_orange
cd_same_apple_orange_peach
cd_same_peach
cd_same_same_date
--- expected_contenttype_author
author1
author2
--- expected_contenttype_author_daily
author1: October 31, 2017
author1: October 31, 2018
author2: October 31, 2016
--- expected_contenttype_author_monthly
author1: October 2017
author1: October 2018
author2: October 2016
--- expected_contenttype_author_weekly
author1: October 29, 2017 - November  4, 2017
author1: October 28, 2018 - November  3, 2018
author2: October 30, 2016 - November  5, 2016
--- expected_contenttype_author_yearly
author1: 2017
author1: 2018
author2: 2016
--- expected_contenttype_category
cat_apple
cat_peach
--- expected_php_todo_contenttype_category
--- expected_todo_contenttype_category_daily
cat_apple: October 31, 2017
cat_apple: October 31, 2018
cat_peach: October 31, 2016
--- expected_todo_contenttype_category_monthly
cat_apple: October 2017
cat_apple: October 2018
cat_peach: October 2016
--- expected_todo_contenttype_category_weekly
cat_apple: October 29, 2017 - November  4, 2017
cat_apple: October 28, 2018 - November  3, 2018
cat_peach: October 30, 2016 - November  5, 2016
--- expected_todo_contenttype_category_yearly
cat_apple: 2017
cat_apple: 2018
cat_peach: 2016
--- expected_contenttype_daily
October 31, 2016
October 31, 2017
October 31, 2018
--- expected_contenttype_monthly
October 2016
October 2017
October 2018
--- expected_contenttype_weekly
October 30, 2016 - November  5, 2016
October 29, 2017 - November  4, 2017
October 28, 2018 - November  3, 2018
--- expected_contenttype_yearly
2016
2017
2018
--- expected_daily
December  3, 2015
December  3, 2016
December  3, 2017
December  3, 2018
--- expected_individual
entry_author2_no_category
entry_author2_pencil_eraser
entry_author1_compass
entry_author1_ruler_eraser
entry_author1_ruler_eraser
--- expected_monthly
December 2015
December 2016
December 2017
December 2018
--- expected_page
page_author1_coffee
page_author1_coffee
page_author2_water
page_author2_no_folder
--- expected_weekly
November 29, 2015 - December  5, 2015
November 27, 2016 - December  3, 2016
December  3, 2017 - December  9, 2017
December  2, 2018 - December  8, 2018
--- expected_yearly
2015
2016
2017
2018
