#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../t/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT;
use MT::Upgrade;

MT::Test->init_app;

my $app = MT->instance;
my $cfg = $app->config;
$cfg->SchemaVersion(1);

MT::Upgrade->init;
my $upgrade_func = \%MT::Upgrade::functions;

for my $func_name ( sort keys %{$upgrade_func} ) {
SKIP: {
        unless ( $upgrade_func->{$func_name}{updater}
            && $upgrade_func->{$func_name}{updater}{sql} )
        {
            skip $func_name, 1;
            next;
        }

        my $sql    = $upgrade_func->{$func_name}{updater}{sql};
        my @sqls   = ref $sql eq 'ARRAY' ? @$sql : ($sql);
        my $all_ok = 1;
        for my $s (@sqls) {
            $all_ok *= ( $s =~ /;/ ) ? 0 : 1;
        }

        ok $all_ok, $func_name;
    }
}

done_testing;
