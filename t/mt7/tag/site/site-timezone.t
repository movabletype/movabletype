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

plan tests => (1 + 2) * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

filters {
    blog_id  => [qw( chomp )],
    template => [qw( chomp )],
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

$test_env->prepare_fixture('db_data');

MT::Test::Tag->run_perl_tests;
MT::Test::Tag->run_php_tests;

__END__

=== mt:SiteTimezone - blog
--- blog_id
1
--- template
<mt:SiteTimezone>
--- expected
-03:30

=== mt:SiteTimezone with no_colon="1" - blog
--- blog_id
1
--- template
<mt:SiteTimezone no_colon="1">
--- expected
-0330

=== mt:SiteTimezone - website
--- blog_id
2
--- template
<mt:SiteTimezone>
--- expected
-03:30

=== mt:SiteTimezone with no_colon="1" - website
--- blog_id
2
--- template
<mt:SiteTimezone no_colon="1">
--- expected
-0330
