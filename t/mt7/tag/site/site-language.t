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


use lib qw(lib t/lib);

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use MT::Test::Tag;

plan tests => 2 * blocks;

use MT;
use MT::Test qw(:db :data);
use MT::Test::Permission;
my $app = MT->instance;

filters {
    blog_id  => [qw( chomp )],
    template => [qw( chomp )],
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

MT::Test::Tag->run_perl_tests;
MT::Test::Tag->run_php_tests;

__END__

=== mt:SiteLanguage - blog
--- blog_id
1
--- template
<mt:SiteLanguage>
--- expected
en_us

=== mt:SiteLanguage with locale="1" - blog
--- blog_id
1
--- template
<mt:SiteLanguage locale="1">
--- expected
en_US

=== mt:SiteLanguage with ietf="1" - blog
--- blog_id
1
--- template
<mt:SiteLanguage ietf="1">
--- expected
en-us

=== mt:SiteLanguage - website
--- blog_id
2
--- template
<mt:SiteLanguage>
--- expected
en_us

=== mt:SiteLanguage with locale="1" - website
--- blog_id
2
--- template
<mt:SiteLanguage locale="1">
--- expected
en_US

=== mt:SiteLanguage with ietf="1" - website
--- blog_id
2
--- template
<mt:SiteLanguage ietf="1">
--- expected
en-us
