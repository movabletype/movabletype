use Test;

use strict;
BEGIN { use lib 't/', 'extlib', 'lib' }

use vars qw($T_CFG);

require 'test-common.pl';

$T_CFG = -r 't/mysql.cfg' ? 't/mysql.cfg' : $ENV{HOME} .'/mysql-test.cfg';

require 'blog-common.pl';

use MT;

plan tests => 9;

require MT::Category;
my $cat_cache = MT::Category->cache(blog_id => 1);
ok($cat_cache);

# check one of the elements
ok($cat_cache->[0][0] eq '1');
ok($cat_cache->[0][1] eq 'foo');
ok($cat_cache->[0][2] eq '0');

require MT::Tag;
my $tag_cache = MT::Tag->cache(blog_id => 1, datasource => 'entry');
ok($tag_cache);

ok($tag_cache->{grandpa} == 1);
ok($tag_cache->{verse} == 5);

my $entry = MT::Entry->load(1);
$entry->tags($entry->tag_list(), 'newtag');
$entry->save;

$tag_cache = MT::Tag->cache(blog_id => 1, datasource => 'entry');
ok($tag_cache->{newtag} == 1);

my $cat = new MT::Category;
$cat->label("New category");
$cat->blog_id(1);
$cat->save;

my $new_cat_cache_count = (scalar @$cat_cache) + 1;
$cat_cache = MT::Category->cache(blog_id => 1);
ok((scalar @$cat_cache), $new_cat_cache_count);

1;
