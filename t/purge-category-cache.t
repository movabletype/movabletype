#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib qw(lib extlib t/lib);
use MT::Test qw( :app :db );
use MT::Test::Permission;

# setup
my $blog      = MT::Test::Permission->make_blog;
my $entry     = MT::Test::Permission->make_entry( blog_id => $blog->id, );
my $category  = MT::Test::Permission->make_category( blog_id => $blog->id, );
my $placement = MT::Test::Permission->make_placement(
    blog_id     => $blog->id,
    entry_id    => $entry->id,
    category_id => $category->id,
);

# test
is( $entry->category->id, $category->id, 'Entry has a category.' );

$placement->remove;
is( $entry->category, undef, 'Category cache was purged.' );

done_testing;
