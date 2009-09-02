use strict;

use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use Test::More tests => 8;

use MT::Test qw(:db :data);
use MT;

require MT::Category;
my $cat_cache = MT::Category->cache(blog_id => 1);
ok($cat_cache, "category cache exists for blog id 1");

# make sure order is consistent
@$cat_cache = sort { $a->[1] cmp $b->[1] } @$cat_cache;

# check one of the elements
is($cat_cache->[0][0], '2', "category id is 2");
is($cat_cache->[0][1], 'bar', "category name is 'bar'");
is($cat_cache->[0][2], '0', "no parent for 'bar' category");

require MT::Tag;
my $tag_cache = MT::Tag->cache(blog_id => 1, class => 'MT::Entry');
ok($tag_cache, "tag cache exists for blog id 1");

is(@$tag_cache, 5, "number of tags in cache is 5"); # relies on test data

my $entry = MT::Entry->load(1);
$entry->tags($entry->get_tags(), 'newtag');
$entry->save;

$tag_cache = MT::Tag->cache(blog_id => 1, class => 'MT::Entry');
ok(grep('newtag', @$tag_cache), "newtag is in cache");

my $cat = new MT::Category;
$cat->label("New category");
$cat->blog_id(1);
$cat->save;

my $new_cat_cache_count = (scalar @$cat_cache) + 1;
$cat_cache = MT::Category->cache(blog_id => 1);
is((scalar @$cat_cache), $new_cat_cache_count, "category cache count incremented");

1;
