#!/usr/bin/perl
use strict;
use warnings;
use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use Test::More;
use MT::Test;
use JSON qw(jsonToObj);
use MT::Tag;

my $file = '<t/49-tagsplit.dat';
open TEST, $file or die "Can't open $file: $!";
local $/ = undef;
my $test_data = <TEST>;
close TEST;
my $tests = jsonToObj($test_data);
plan tests => scalar(keys %$tests) * 2;

foreach my $delim (',', ' ') {
    foreach my $test (sort keys %$tests) {
        my @tags = MT::Tag->split($delim, $test);
        my %tags = map { $_ => 1 } @tags;
        is(scalar keys %tags, $tests->{$test}{$delim},
            "$test ($delim): $tests->{$test}{$delim} tags");
    }
}
