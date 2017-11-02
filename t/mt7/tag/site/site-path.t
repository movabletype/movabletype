#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

plan tests => 2 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;

filters {
    blog_id  => [qw( chomp )],
    template => [qw( chomp )],
    expected => [qw( chomp replace_test_root )],
    error    => [qw( chomp )],
};

my $test_root = $test_env->root;
sub replace_test_root {
    s/TEST_ROOT/$test_root/;
}

$test_env->prepare_fixture('db_data');

MT::Test::Tag->run_perl_tests;
MT::Test::Tag->run_php_tests;

__END__

=== mt:SitePath - blog
--- blog_id
1
--- template
<mt:SitePath>
--- expected
TEST_ROOT/site/

=== mt:SitePath - website
--- blog_id
2
--- template
<mt:SitePath>
--- expected
TEST_ROOT/

