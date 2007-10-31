#!/usr/bin/perl
# $Id$
use strict;
use warnings;

use Test::More tests => 9;

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
