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
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use Test::Base;
use MT::Test::ArchiveType;

use MT;
use MT::Test;
my $app = MT->instance;

$test_env->prepare_fixture('archive_type');

my $blog_id = 2;

my $entry = $app->model('entry')->load(
    {   blog_id => $blog_id,
        title   => 'entry_author1_ruler_eraser',
    }
) or die;
$entry->authored_on( $entry->authored_on + 100 );
$entry->title('entry_author1_ruler_eraser_plus');
$entry->save or die;

filters {
    MT::Test::ArchiveType->filter_spec
};

my @non_ct_archive_maps = grep { $_->archive_type !~ /^ContentType/ }
    MT::Test::ArchiveType->template_maps;
MT::Test::ArchiveType->run_tests(@non_ct_archive_maps);

done_testing;

__END__

=== MTEntries sort_order="ascend"
--- stash
{
  author         => 'author1',
  cat_field      => 'cf_same_catset_fruit',
  category       => 'cat_apple',
  cd             => 'cd_same_apple_orange',
  entry          => 'entry_author1_ruler_eraser',
  entry_category => 'cat_ruler',
  page           => 'page_author1_coffee',
}
--- template
<MTEntries sort_order="ascend"><MTEntryID>: <MTEntryTitle> | <MTEntryDate>
</MTEntries>
--- expected
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
--- expected_author
3: entry_author1_compass | December  3, 2017 12:11 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
--- expected_individual
5: entry_author2_no_category | December  3, 2015 12:11 PM
4: entry_author2_pencil_eraser | December  3, 2016 12:11 PM
3: entry_author1_compass | December  3, 2017 12:11 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
--- expected_page
5: entry_author2_no_category | December  3, 2015 12:11 PM
4: entry_author2_pencil_eraser | December  3, 2016 12:11 PM
3: entry_author1_compass | December  3, 2017 12:11 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM

=== MTEntries sort_order="descend"
--- stash
{
  author         => 'author1',
  cat_field      => 'cf_same_catset_fruit',
  category       => 'cat_apple',
  cd             => 'cd_same_apple_orange',
  entry          => 'entry_author1_ruler_eraser',
  entry_category => 'cat_ruler',
  page           => 'page_author1_coffee',
}
--- template
<MTEntries sort_order="descend"><MTEntryID>: <MTEntryTitle> | <MTEntryDate>
</MTEntries>
--- expected_author
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
3: entry_author1_compass | December  3, 2017 12:11 PM
--- expected
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
--- expected_todo_
--- expected_individual
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
3: entry_author1_compass | December  3, 2017 12:11 PM
4: entry_author2_pencil_eraser | December  3, 2016 12:11 PM
5: entry_author2_no_category | December  3, 2015 12:11 PM
--- expected_page
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
3: entry_author1_compass | December  3, 2017 12:11 PM
4: entry_author2_pencil_eraser | December  3, 2016 12:11 PM
5: entry_author2_no_category | December  3, 2015 12:11 PM

=== MTEntries blog_ids="2" sort_order="ascend"
--- stash
{
  author         => 'author1',
  cat_field      => 'cf_same_catset_fruit',
  category       => 'cat_apple',
  cd             => 'cd_same_apple_orange',
  entry          => 'entry_author1_ruler_eraser',
  entry_category => 'cat_ruler',
  page           => 'page_author1_coffee',
}
--- template
<MTEntries blog_ids="2" sort_order="ascend"><MTEntryID>: <MTEntryTitle> | <MTEntryDate>
</MTEntries>
--- expected
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
--- expected_todo_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26213
--- expected_individual
5: entry_author2_no_category | December  3, 2015 12:11 PM
4: entry_author2_pencil_eraser | December  3, 2016 12:11 PM
3: entry_author1_compass | December  3, 2017 12:11 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
--- expected_page
5: entry_author2_no_category | December  3, 2015 12:11 PM
4: entry_author2_pencil_eraser | December  3, 2016 12:11 PM
3: entry_author1_compass | December  3, 2017 12:11 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM

=== MTEntries include_websites="2" sort_order="ascend"
--- stash
{
  author         => 'author1',
  cat_field      => 'cf_same_catset_fruit',
  category       => 'cat_apple',
  cd             => 'cd_same_apple_orange',
  entry          => 'entry_author1_ruler_eraser',
  entry_category => 'cat_ruler',
  page           => 'page_author1_coffee',
}
--- template
<MTEntries include_websites="2" sort_order="ascend"><MTEntryID>: <MTEntryTitle> | <MTEntryDate>
</MTEntries>
--- expected
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
--- expected_todo_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26213
--- expected_individual
5: entry_author2_no_category | December  3, 2015 12:11 PM
4: entry_author2_pencil_eraser | December  3, 2016 12:11 PM
3: entry_author1_compass | December  3, 2017 12:11 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
--- expected_page
5: entry_author2_no_category | December  3, 2015 12:11 PM
4: entry_author2_pencil_eraser | December  3, 2016 12:11 PM
3: entry_author1_compass | December  3, 2017 12:11 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM

=== MTEntries exclude_websites="2" sort_order="ascend"
--- stash
{
  author         => 'author1',
  cat_field      => 'cf_same_catset_fruit',
  category       => 'cat_apple',
  cd             => 'cd_same_apple_orange',
  entry          => 'entry_author1_ruler_eraser',
  entry_category => 'cat_ruler',
  page           => 'page_author1_coffee',
}
--- template
<MTEntries exclude_websites="2" sort_order="ascend"><MTEntryID>: <MTEntryTitle> | <MTEntryDate>
</MTEntries>
--- expected

=== MTEntries exclude_websites="1" sort_order="ascend"
--- stash
{
  author         => 'author1',
  cat_field      => 'cf_same_catset_fruit',
  category       => 'cat_apple',
  cd             => 'cd_same_apple_orange',
  entry          => 'entry_author1_ruler_eraser',
  entry_category => 'cat_ruler',
  page           => 'page_author1_coffee',
}
--- template
<MTEntries exclude_websites="1" sort_order="ascend"><MTEntryID>: <MTEntryTitle> | <MTEntryDate>
</MTEntries>
--- expected
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
--- expected_todo_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26213
--- expected_individual
5: entry_author2_no_category | December  3, 2015 12:11 PM
4: entry_author2_pencil_eraser | December  3, 2016 12:11 PM
3: entry_author1_compass | December  3, 2017 12:11 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
--- expected_page
5: entry_author2_no_category | December  3, 2015 12:11 PM
4: entry_author2_pencil_eraser | December  3, 2016 12:11 PM
3: entry_author1_compass | December  3, 2017 12:11 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM

=== MTEntries site_ids="2" sort_order="ascend"
--- stash
{
  author         => 'author1',
  cat_field      => 'cf_same_catset_fruit',
  category       => 'cat_apple',
  cd             => 'cd_same_apple_orange',
  entry          => 'entry_author1_ruler_eraser',
  entry_category => 'cat_ruler',
  page           => 'page_author1_coffee',
}
--- template
<MTEntries site_ids="2" sort_order="ascend"><MTEntryID>: <MTEntryTitle> | <MTEntryDate>
</MTEntries>
--- expected
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
--- expected_todo_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26213
--- expected_individual
5: entry_author2_no_category | December  3, 2015 12:11 PM
4: entry_author2_pencil_eraser | December  3, 2016 12:11 PM
3: entry_author1_compass | December  3, 2017 12:11 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
--- expected_page
5: entry_author2_no_category | December  3, 2015 12:11 PM
4: entry_author2_pencil_eraser | December  3, 2016 12:11 PM
3: entry_author1_compass | December  3, 2017 12:11 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM

=== MTEntries include_sites="2" sort_order="ascend"
--- stash
{
  author         => 'author1',
  cat_field      => 'cf_same_catset_fruit',
  category       => 'cat_apple',
  cd             => 'cd_same_apple_orange',
  entry          => 'entry_author1_ruler_eraser',
  entry_category => 'cat_ruler',
  page           => 'page_author1_coffee',
}
--- template
<MTEntries include_sites="2" sort_order="ascend"><MTEntryID>: <MTEntryTitle> | <MTEntryDate>
</MTEntries>
--- expected
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
--- expected_todo_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26213
--- expected_individual
5: entry_author2_no_category | December  3, 2015 12:11 PM
4: entry_author2_pencil_eraser | December  3, 2016 12:11 PM
3: entry_author1_compass | December  3, 2017 12:11 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
--- expected_page
5: entry_author2_no_category | December  3, 2015 12:11 PM
4: entry_author2_pencil_eraser | December  3, 2016 12:11 PM
3: entry_author1_compass | December  3, 2017 12:11 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM

=== MTEntries exclude_sites="2" sort_order="ascend"
--- stash
{
  author         => 'author1',
  cat_field      => 'cf_same_catset_fruit',
  category       => 'cat_apple',
  cd             => 'cd_same_apple_orange',
  entry          => 'entry_author1_ruler_eraser',
  entry_category => 'cat_ruler',
  page           => 'page_author1_coffee',
}
--- template
<MTEntries exclude_sites="2" sort_order="ascend"><MTEntryID>: <MTEntryTitle> | <MTEntryDate>
</MTEntries>
--- expected

=== MTEntries exclude_sites="1" sort_order="ascend"
--- stash
{
  author         => 'author1',
  cat_field      => 'cf_same_catset_fruit',
  category       => 'cat_apple',
  cd             => 'cd_same_apple_orange',
  entry          => 'entry_author1_ruler_eraser',
  entry_category => 'cat_ruler',
  page           => 'page_author1_coffee',
}
--- template
<MTEntries exclude_sites="1" sort_order="ascend"><MTEntryID>: <MTEntryTitle> | <MTEntryDate>
</MTEntries>
--- expected
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
--- expected_todo_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26213
--- expected_individual
5: entry_author2_no_category | December  3, 2015 12:11 PM
4: entry_author2_pencil_eraser | December  3, 2016 12:11 PM
3: entry_author1_compass | December  3, 2017 12:11 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
--- expected_page
5: entry_author2_no_category | December  3, 2015 12:11 PM
4: entry_author2_pencil_eraser | December  3, 2016 12:11 PM
3: entry_author1_compass | December  3, 2017 12:11 PM
2: entry_author1_ruler_eraser | December  3, 2018 12:11 PM
1: entry_author1_ruler_eraser_plus | December  3, 2018 12:12 PM
