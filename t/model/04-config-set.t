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

$test_env->prepare_fixture('db');

my $cnf = MT->config;
$cnf->define({Array => {type => 'ARRAY'}, Hash => {type => 'HASH'}});
$cnf->clear_dirty;

subtest 'Read/Write scalar' => sub {
    is $cnf->is_dirty, 0, "Before change config";

    $cnf->set('Scalar', 'file', 1);
    is $cnf->is_dirty, 1, "Scalar config is changed";
    $cnf->save_config;
    is $cnf->is_dirty, 0, "After save config";
    $cnf->set('Scalar', 'file', 1);
    is $cnf->is_dirty, 0, "Set same value";
};

subtest 'Read/Write array' => sub {
    $cnf->save_config;
    is $cnf->is_dirty, 0, "After save config";

    $cnf->set('Array', [ 'file_a' ], 1);
    is $cnf->is_dirty, 1, "Set array reference";
    $cnf->save_config;
    is $cnf->is_dirty, 0, "After save config";

    $cnf->set('Array', 'file_b', 1);
    is $cnf->is_dirty, 1, "Array config is changed";
    $cnf->save_config;
    is $cnf->is_dirty, 0, "After save config";

    $cnf->set('Array', [ 'file_a', 'file_b' ], 1);
    is $cnf->is_dirty, 0, "Set same value with array reference";

    $cnf->set('Array', [ 'file_a', 'file_b', 'file_c' ], 1);
    is $cnf->is_dirty, 1, "Set different value with array reference";
    $cnf->save_config;
    is $cnf->is_dirty, 0, "After save config";
};

subtest 'Read/Write hash' => sub {
    $cnf->save_config;
    is $cnf->is_dirty, 0, "After save config";

    $cnf->set('Hash', { a => 'file_a' }, 1);
    is $cnf->is_dirty, 1, "Set hash reference";
    $cnf->save_config;
    is $cnf->is_dirty, 0, "After save config";

    $cnf->set('Hash', 'b=file_b', 1);
    is $cnf->is_dirty, 1, "Hash config is changed";
    $cnf->save_config;
    is $cnf->is_dirty, 0, "After save config";

    $cnf->set('Hash', { a => 'file_a', b => 'file_b' }, 1);
    is $cnf->is_dirty, 0, "Set same value with hash reference";

    $cnf->set('Hash', { a => 'file_a', b => 'file_b', c => 'file_c' }, 1);
    is $cnf->is_dirty, 1, "Set different value with hash reference";
    $cnf->save_config;
    is $cnf->is_dirty, 0, "After save config";

    $cnf->set('Hash', 'c=file_c', 1);
    is $cnf->is_dirty, 0, "Set same value";
};

done_testing();
