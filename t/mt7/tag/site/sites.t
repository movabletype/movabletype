#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib";    # t/lib
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
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

$test_env->prepare_fixture('db_data');

MT::Test::Tag->run_perl_tests;
MT::Test::Tag->run_php_tests;

__END__

=== mt:Sites - blog
--- blog_id
1
--- template
<mt:Sites><mt:SiteID>
</mt:Sites>
--- expected
2

=== mt:Sites - website
--- blog_id
2
--- template
<mt:Sites><mt:SiteID>
</mt:Sites>
--- expected
2

=== mt:Sites - blog in website
--- blog_id
2
--- template
<mt:Sites><mt:ChildSites><mt:SiteID></mt:ChildSites>
</mt:Sites>
--- expected
1

