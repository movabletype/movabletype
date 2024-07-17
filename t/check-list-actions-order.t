#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT;

my $app = MT::Test::init_cms;

my @object_types = sort keys %{ $app->registry('list_actions') };
for my $object_type (@object_types) {
    my $registry = $app->registry('list_actions', $object_type);
    for my $key (sort keys %{$registry}) {
        my $order = $registry->{$key}{order};
        ok $order, sprintf('%s.%s has order value %d', $object_type, $key, $order);
    }
}

done_testing;

