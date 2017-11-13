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
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

$test_env->prepare_fixture(sub {
    MT::Test->init_db;
    MT::Test->init_data;

    my $website = MT::Test::Permission->make_website;
    $website->id(10);
    $website->save or die $website->errstr;
});

MT::Test::Tag->run_perl_tests;
MT::Test::Tag->run_php_tests;

__END__

=== mt:SiteHasChildSite - blog
--- blog_id
1
--- template
<mt:SiteHasChildSite><mt:SiteID></mt:SiteHasChildSite>
--- expected


=== mt:SiteHasChildSite - website with blog
--- blog_id
2
--- template
<mt:SiteHasChildSite><mt:SiteID></mt:SiteHasChildSite>
--- expected
2

=== mt:SiteHasChildSite - website without blog
--- blog_id
10
--- template
<mt:SiteHasChildSite><mt:SiteID></mt:SiteHasChildSite>
--- expected


