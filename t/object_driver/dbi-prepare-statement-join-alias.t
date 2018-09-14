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

use MT::Test;
use MT;
use MT::Object;

MT::Test->init_app;

$test_env->prepare_fixture('db');

MT->instance();
my $driver = MT::Object->driver();

my $join = MT->model('cf_idx')->join_on(
    undef, undef, {
        alias => 'cf_idx_1',
        condition => {
            content_data_id => \'= cd_id',
        },
        type => 'left',
    }
);
my ($sql, $bind, $stmt) = $driver->prepare_fetch( MT->model('cd'), undef, { join => $join } );
like $sql => qr/FROM\s+mt_cd\s+LEFT JOIN\s+mt_cf_idx cf_idx_1\s+ON\s+cf_idx_1.cf_idx_content_data_id = cd_id/;

done_testing;
