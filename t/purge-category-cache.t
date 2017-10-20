#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

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
