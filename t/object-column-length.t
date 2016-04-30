#!/usr/bin/perl
use strict;
use warnings;

# Check column length of MT::Object for Oracle Database.

use Test::More;

use lib qw( lib extlib t/lib );
use MT;
MT->instance;
use MT::Test qw( :app :db );

my $registry = MT->registry('object_types');

for my $class ( values %$registry ) {
    next if ref $class;
    my $datasource = $class->datasource;

    subtest $class => sub {
        subtest 'column_defs' => sub {
            for my $col ( keys %{ $class->column_defs } ) {
                ok( length("${datasource}_${col}") <= 30, $col );
            }
        };

        if ( my $indexes = $class->index_defs ) {
            subtest 'indexes' => sub {
                for my $col ( keys %$indexes ) {
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
