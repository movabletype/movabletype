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
};

$test_env->prepare_fixture('db_data');

my $website = MT->model('website')->load(2) or MT->model('website')->errstr;
$website->cc_license(undef);
$website->save or die $website->errstr;

MT::Test::Tag->run_perl_tests;
MT::Test::Tag->run_php_tests;

__END__

=== mt:SiteIfCCLicense - true
--- blog_id
1
--- template
<mt:SiteIfCCLicense>1<mt:Else>0</mt:SiteIfCCLicense>
--- expected
1

=== mt:SiteIfCCLicense - false
--- blog_id
2
--- template
<mt:SiteIfCCLicense>1<mt:Else>0</mt:SiteIfCCLicense>
--- expected
0

