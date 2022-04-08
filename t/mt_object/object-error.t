#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use utf8;
use MT;
use MT::Test;
use Foo;

my $mt = MT->new;

subtest 'An error occurred while saving changes' => sub {
    my $foo = Foo->new;
    ok !$foo->save; # mt_foo does not exists
    ok $foo->errstr;
    unlike $foo->errstr, qr/at\s*.*\s*line/, 'Should not contain file path';
    unlike $foo->errstr, qr/@{[Foo->datasource]}/, 'Should not contain raw database information';
};

done_testing();
