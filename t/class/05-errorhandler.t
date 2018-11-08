#!/usr/bin/perl
# $Id: 05-errorhandler.t 1100 2007-12-12 01:48:53Z hachi $
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

plan tests => 9;

use MT::ErrorHandler;

my $eh = MT::ErrorHandler->new;
isa_ok($eh, 'MT::ErrorHandler');
my $val = $eh->error('foo bar');
ok(!defined $val, 'val undef');
is($eh->errstr, "foo bar\n", 'foo bar');
my @val = $eh->error('foo');
is(@val, 0, 'val size=0');
is($eh->errstr, "foo\n", 'foo');

$val = MT::ErrorHandler->error('foo bar');
ok(!defined $val, 'val undef');
is(MT::ErrorHandler->errstr, "foo bar\n", 'foo bar');
@val = MT::ErrorHandler->error('foo');
is(@val, 0, 'val size=0');
is(MT::ErrorHandler->errstr, "foo\n", 'foo');
