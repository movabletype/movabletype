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
use MT::Test::Fixture::Mt7::Tag::Site::Entry;

filters {
    blog_id  => [qw( chomp )],
    template => [qw( chomp )],
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

$test_env->prepare_fixture('mt7/tag/site/entry');

MT::Test::Tag->run_perl_tests;
MT::Test::Tag->run_php_tests;

__END__

=== mt:EntrySiteName - blog
--- blog_id
1
--- template
<mt:Entries limit="1"><mt:EntrySiteName></mt:Entries>
--- expected
None

=== mt:EntrySiteName - website
--- blog_id
2
--- template
<mt:Entries limit="1"><mt:EntrySiteName></mt:Entries>
--- expected
Test site
