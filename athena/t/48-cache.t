use strict;

use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use Test::More tests => 9;

use vars qw($T_CFG);
use MT::Test qw(:db :data);


$T_CFG = -r 't/mysql.cfg' ? 't/mysql.cfg' : $ENV{HOME} .'/mysql-test.cfg';
$T_CFG = -r 't/mt.cfg' ? 't/mt.cfg' : $ENV{HOME} .'/mt-test.cfg';

use MT;

require MT::Category;
my $cat_cache = MT::Category->cache(blog_id => 1);
ok($cat_cache);

# make sure order is consistent
@$cat_cache = sort { $a->[1] cmp $b->[1] } @$cat_cache;

# check one of the elements
is($cat_cache->[0][0], '2');
is($cat_cache->[0][1], 'bar');
is($cat_cache->[0][2], '0');

require MT::Tag;
my $tag_cache = MT::Tag->cache(blog_id => 1, class => 'MT::Entry');
ok($tag_cache);

is($tag_cache->{grandpa}, 1);
is($tag_cache->{verse}, MT::Object->driver->can('count_group_by') ? 5 : 1);

my $entry = MT::Entry->load(1);
$entry->tags($entry->get_tags(), 'newtag');
$entry->save;

$tag_cache = MT::Tag->cache(blog_id => 1, class => 'MT::Entry');
is($tag_cache->{newtag}, 1);

my $cat = new MT::Category;
$cat->label("New category");
$cat->blog_id(1);
$cat->save;

my $new_cat_cache_count = (scalar @$cat_cache) + 1;
$cat_cache = MT::Category->cache(blog_id => 1);
is((scalar @$cat_cache), $new_cat_cache_count);

1;
