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

# Check column length of MT::Object for Oracle Database.

use MT;
MT->instance;
use MT::Test;

MT::Test->init_app;

$test_env->prepare_fixture('db');

my $registry = MT->registry('object_types');

for my $class ( sort values %$registry ) {
    next if ref $class;
    my $datasource = $class->datasource;

    subtest $class => sub {
        subtest 'column_defs' => sub {
            for my $col ( sort keys %{ $class->column_defs } ) {
                ok( length("${datasource}_${col}") <= 30, $col );
            }
        };

        if ( my $indexes = $class->index_defs ) {
            subtest 'indexes' => sub {
                for my $col ( sort keys %$indexes ) {
                    ok( length("mt_${datasource}_${col}") <= 30, $col );
                }
            };
        }
        else {
            note "$class has no indexes.";
        }
    };
}

done_testing;
