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

my @archive_types = MT->publisher->archive_types;
my $archive_types = join ',', @archive_types;

plan tests => 2 * @archive_types * blocks;

foreach my $archive_type (@archive_types) {
    note "--- $archive_type";
    my $expected_method = 'expected_' . lc($archive_type);
    $expected_method =~ s/-/_/g;
    MT::Test::Tag->vars->{archive_type} = $archive_type;
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
        $expected_method
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
        $expected_method
    );
}

__END__

=== Some ArchiveTitles with type
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26105
https://movabletype.atlassian.net/browse/MTC-26106
https://movabletype.atlassian.net/browse/MTC-26107
https://movabletype.atlassian.net/browse/MTC-26108
--- skip
1
--- template
<mt:ArchiveList type="[% archive_type %]"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected
[% archive_type %]
--- expected_individual
entry_author1_ruler_eraser
entry_author1_ruler_eraser
entry_author1_compass
entry_author2_pencil_eraser
entry_author2_no_category
--- expected_page
page_author2_no_folder
page_author2_water
page_author1_coffee
page_author1_coffee
--- expected_daily
December  3, 2018
December  3, 2017
December  3, 2016
December  3, 2015
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
--- expected_yearly
2018
2017
2016
2015
--- expected_author
author1
author2
--- expected_author_daily
December  3, 2018
December  3, 2017
December  3, 2016
December  3, 2015
--- expected_author_weekly
December  2, 2018 - December  8, 2018
December  3, 2017 - December  9, 2017
November 27, 2016 - December  3, 2016
November 29, 2015 - December  5, 2015
--- expected_author_monthly
December 2018
December 2017
December 2016
December 2015
--- expected_author_yearly
2018
2017
2016
2015
--- expected_category
cat_compass
cat_pencil
cat_ruler
--- expected_category_daily
December  3, 2017
December  3, 2016
December  3, 2018
--- expected_category_weekly
December  3, 2017 - December  9, 2017
November 27, 2016 - December  3, 2016
December  2, 2018 - December  8, 2018
--- expected_category_monthly
December 2017
December 2016
December 2018
--- expected_category_yearly
2017
2016
2018
--- expected_contenttype
cd_same_apple_orange
cd_same_same_date
cd_same_apple_orange_peach
cd_same_peach
cd_other_apple
cd_other_apple_orange_dog_cat
cd_other_all_fruit_rabbit
cd_other_same_date
--- expected_contenttype_daily
November  1, 2008
November  1, 2006
November  1, 2004
--- expected_contenttype_weekly
October 28, 2018 - November  3, 2018
October 29, 2017 - November  4, 2017
October 30, 2016 - November  5, 2016
October 26, 2008 - November  1, 2008
October 29, 2006 - November  4, 2006
October 31, 2004 - November  6, 2004
--- expected_contenttype_monthly
October 2018
October 2017
October 2016
November 2008
November 2006
November 2004
--- expected_contenttype_yearly
2018
2017
2016
2008
2006
2004
--- expected_contenttype_author
author1
author2
--- expected_contenttype_author_daily
October 31, 2018
October 31, 2017
November  1, 2004
October 31, 2016
November  1, 2008
November  1, 2006
--- expected_contenttype_author_weekly
October 28, 2018 - November  3, 2018
October 29, 2017 - November  4, 2017
October 31, 2004 - November  6, 2004
October 30, 2016 - November  5, 2016
October 26, 2008 - November  1, 2008
October 29, 2006 - November  4, 2006
--- expected_contenttype_author_monthly
October 2018
October 2017
November 2004
October 2016
November 2008
November 2006
--- expected_contenttype_author_yearly
2018
2017
2004
2016
2008
2006
--- expected_contenttype_category
cat_apple
cat_peach
--- expected_contenttype_category_daily
November  1, 2008
November  1, 2006
November  1, 2004
November  1, 2008
November  1, 2006
November  1, 2004
--- expected_contenttype_category_weekly
October 26, 2008 - November  1, 2008
October 29, 2006 - November  4, 2006
October 31, 2004 - November  6, 2004
--- expected_contenttype_category_monthly
November 2008
November 2006
November 2004
--- expected_contenttype_category_yearly
2008
2006
2004

=== Some ArchiveTitles with archive_type
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26105
https://movabletype.atlassian.net/browse/MTC-26106
https://movabletype.atlassian.net/browse/MTC-26107
https://movabletype.atlassian.net/browse/MTC-26108
--- skip
1
--- template
<mt:ArchiveList archive_type="[% archive_type %]"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected
[% archive_type %]
--- expected_individual
entry_author1_ruler_eraser
entry_author1_ruler_eraser
entry_author1_compass
entry_author2_pencil_eraser
entry_author2_no_category
--- expected_page
page_author2_no_folder
page_author2_water
page_author1_coffee
page_author1_coffee
--- expected_daily
December  3, 2018
December  3, 2017
December  3, 2016
December  3, 2015
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
--- expected_yearly
2018
2017
2016
2015
--- expected_author
author1
author2
--- expected_author_daily
December  3, 2018
December  3, 2017
December  3, 2016
December  3, 2015
--- expected_author_weekly
December  2, 2018 - December  8, 2018
December  3, 2017 - December  9, 2017
November 27, 2016 - December  3, 2016
November 29, 2015 - December  5, 2015
--- expected_author_monthly
December 2018
December 2017
December 2016
December 2015
--- expected_author_yearly
2018
2017
2016
2015
--- expected_category
cat_compass
cat_pencil
cat_ruler
--- expected_category_daily
December  3, 2017
December  3, 2016
December  3, 2018
--- expected_category_weekly
December  3, 2017 - December  9, 2017
November 27, 2016 - December  3, 2016
December  2, 2018 - December  8, 2018
--- expected_category_monthly
December 2017
December 2016
December 2018
--- expected_category_yearly
2017
2016
2018
--- expected_contenttype
cd_same_apple_orange
cd_same_same_date
cd_same_apple_orange_peach
cd_same_peach
cd_other_apple
cd_other_apple_orange_dog_cat
cd_other_all_fruit_rabbit
cd_other_same_date
--- expected_contenttype_daily
November  1, 2008
November  1, 2006
November  1, 2004
--- expected_contenttype_weekly
October 28, 2018 - November  3, 2018
October 29, 2017 - November  4, 2017
October 30, 2016 - November  5, 2016
October 26, 2008 - November  1, 2008
October 29, 2006 - November  4, 2006
October 31, 2004 - November  6, 2004
--- expected_contenttype_monthly
October 2018
October 2017
October 2016
November 2008
November 2006
November 2004
--- expected_contenttype_yearly
2018
2017
2016
2008
2006
2004
--- expected_contenttype_author
author1
author2
--- expected_contenttype_author_daily
October 31, 2018
October 31, 2017
November  1, 2004
October 31, 2016
November  1, 2008
November  1, 2006
--- expected_contenttype_author_weekly
October 28, 2018 - November  3, 2018
October 29, 2017 - November  4, 2017
October 31, 2004 - November  6, 2004
October 30, 2016 - November  5, 2016
October 26, 2008 - November  1, 2008
October 29, 2006 - November  4, 2006
--- expected_contenttype_author_monthly
October 2018
October 2017
November 2004
October 2016
November 2008
November 2006
--- expected_contenttype_author_yearly
2018
2017
2004
2016
2008
2006
--- expected_contenttype_category
cat_apple
cat_peach
--- expected_contenttype_category_daily
November  1, 2008
November  1, 2006
November  1, 2004
November  1, 2008
November  1, 2006
November  1, 2004
--- expected_contenttype_category_weekly
October 26, 2008 - November  1, 2008
October 29, 2006 - November  4, 2006
October 31, 2004 - November  6, 2004
--- expected_contenttype_category_monthly
November 2008
November 2006
November 2004
--- expected_contenttype_category_yearly
2008
2006
2004

=== Empty with type
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26109
--- skip_php
1
--- archive_type

--- template
<mt:ArchiveList type="[% archive_type %]"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected
[% archive_type %]
--- expected_individual
--- expected_page
--- expected_daily
--- expected_weekly
--- expected_monthly
--- expected_yearly
--- expected_author
--- expected_author_daily
--- expected_author_weekly
--- expected_author_monthly
--- expected_author_yearly
--- expected_category
--- expected_category_daily
--- expected_category_weekly
--- expected_category_monthly
--- expected_category_yearly
--- expected_contenttype
--- expected_contenttype_daily
--- expected_contenttype_weekly
--- expected_contenttype_monthly
--- expected_contenttype_yearly
--- expected_contenttype_author
--- expected_contenttype_author_daily
--- expected_contenttype_author_weekly
--- expected_contenttype_author_monthly
--- expected_contenttype_author_yearly
--- expected_contenttype_category
--- expected_contenttype_category_daily
--- expected_contenttype_category_weekly
--- expected_contenttype_category_monthly
--- expected_contenttype_category_yearly

=== Empty with archive_type
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26109
--- skip_php
1
--- archive_type

--- template
<mt:ArchiveList archive_type="[% archive_type %]"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected
[% archive_type %]
--- expected_individual
--- expected_page
--- expected_daily
--- expected_weekly
--- expected_monthly
--- expected_yearly
--- expected_author
--- expected_author_daily
--- expected_author_weekly
--- expected_author_monthly
--- expected_author_yearly
--- expected_category
--- expected_category_daily
--- expected_category_weekly
--- expected_category_monthly
--- expected_category_yearly
--- expected_contenttype
--- expected_contenttype_daily
--- expected_contenttype_weekly
--- expected_contenttype_monthly
--- expected_contenttype_yearly
--- expected_contenttype_author
--- expected_contenttype_author_daily
--- expected_contenttype_author_weekly
--- expected_contenttype_author_monthly
--- expected_contenttype_author_yearly
--- expected_contenttype_category
--- expected_contenttype_category_daily
--- expected_contenttype_category_weekly
--- expected_contenttype_category_monthly
--- expected_contenttype_category_yearly

=== None with type
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26109
--- skip_php
1
--- archive_type
None
--- template
<mt:ArchiveList type="[% archive_type %]"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected
[% archive_type %]
--- expected_individual
--- expected_page
--- expected_daily
--- expected_weekly
--- expected_monthly
--- expected_yearly
--- expected_author
--- expected_author_daily
--- expected_author_weekly
--- expected_author_monthly
--- expected_author_yearly
--- expected_category
--- expected_category_daily
--- expected_category_weekly
--- expected_category_monthly
--- expected_category_yearly
--- expected_contenttype
--- expected_contenttype_daily
--- expected_contenttype_weekly
--- expected_contenttype_monthly
--- expected_contenttype_yearly
--- expected_contenttype_author
--- expected_contenttype_author_daily
--- expected_contenttype_author_weekly
--- expected_contenttype_author_monthly
--- expected_contenttype_author_yearly
--- expected_contenttype_category
--- expected_contenttype_category_daily
--- expected_contenttype_category_weekly
--- expected_contenttype_category_monthly
--- expected_contenttype_category_yearly

=== None with archive_type
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26109
--- skip_php
1
--- archive_type
None
--- template
<mt:ArchiveList archive_type="[% archive_type %]"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected
[% archive_type %]
--- expected_individual
--- expected_page
--- expected_daily
--- expected_weekly
--- expected_monthly
--- expected_yearly
--- expected_author
--- expected_author_daily
--- expected_author_weekly
--- expected_author_monthly
--- expected_author_yearly
--- expected_category
--- expected_category_daily
--- expected_category_weekly
--- expected_category_monthly
--- expected_category_yearly
--- expected_contenttype
--- expected_contenttype_daily
--- expected_contenttype_weekly
--- expected_contenttype_monthly
--- expected_contenttype_yearly
--- expected_contenttype_author
--- expected_contenttype_author_daily
--- expected_contenttype_author_weekly
--- expected_contenttype_author_monthly
--- expected_contenttype_author_yearly
--- expected_contenttype_category
--- expected_contenttype_category_daily
--- expected_contenttype_category_weekly
--- expected_contenttype_category_monthly
--- expected_contenttype_category_yearly

=== sort_order="ascend"
--- template
<mt:ArchiveList type="[% archive_type %]" sort_order="ascend"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected_todo_individual
entry_author1_compass
entry_author1_ruler_eraser
entry_author1_ruler_eraser
entry_author2_no_category
entry_author2_pencil_eraser
--- expected_todo_page
page_author1_coffee
page_author1_coffee
page_author2_no_folder
page_author2_water
--- expected_daily
December  3, 2015
December  3, 2016
December  3, 2017
December  3, 2018
--- expected_weekly
November 29, 2015 - December  5, 2015
November 27, 2016 - December  3, 2016
December  3, 2017 - December  9, 2017
December  2, 2018 - December  8, 2018
--- expected_monthly
December 2015
December 2016
December 2017
December 2018
--- expected_yearly
2015
2016
2017
2018
--- expected_author
author1
author2
--- expected_author_daily
December  3, 2015
December  3, 2016
December  3, 2017
December  3, 2018
--- expected_author_monthly
December 2015
December 2016
December 2017
December 2018
--- expected_author_weekly
November 29, 2015 - December  5, 2015
November 27, 2016 - December  3, 2016
December  3, 2017 - December  9, 2017
December  2, 2018 - December  8, 2018
--- expected_author_yearly
2015
2016
2017
2018
--- expected_category
cat_compass
cat_pencil
cat_ruler
--- expected_category_daily
December  3, 2017
December  3, 2018
December  3, 2016
December  3, 2016
December  3, 2018
--- expected_category_monthly
December 2017
December 2018
December 2016
December 2016
December 2018
--- expected_category_weekly
December  3, 2017 - December  9, 2017
December  2, 2018 - December  8, 2018
November 27, 2016 - December  3, 2016
November 27, 2016 - December  3, 2016
December  2, 2018 - December  8, 2018
--- expected_category_yearly
2017
2018
2016
2016
2018
--- expected_contenttype
cd_same_apple_orange
cd_same_apple_orange_peach
cd_same_peach
cd_same_same_date
--- expected_contenttype_daily
October 31, 2016
October 31, 2017
October 31, 2018
--- expected_contenttype_weekly
October 30, 2016 - November  5, 2016
October 29, 2017 - November  4, 2017
October 28, 2018 - November  3, 2018
--- expected_contenttype_monthly
October 2016
October 2017
October 2018
--- expected_contenttype_yearly
2016
2017
2018
--- expected_contenttype_author
author1
author2
--- expected_contenttype_author_daily
October 31, 2017
October 31, 2018
--- expected_contenttype_author_monthly
October 2017
October 2018
--- expected_contenttype_author_weekly
October 28, 2018 - November  3, 2018
October 29, 2017 - November  4, 2017
--- expected_contenttype_author_yearly
2017
2018
--- expected_contenttype_category
cat_apple
cat_orange
cat_peach
cat_strawberry
--- expected_contenttype_category_daily
October 31, 2017
October 31, 2018
--- expected_contenttype_category_monthly
October 2017
October 2018
--- expected_contenttype_category_weekly
October 29, 2017 - November  4, 2017
October 28, 2018 - November  3, 2018
--- expected_contenttype_category_yearly
2017
2018
