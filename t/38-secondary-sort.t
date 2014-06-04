#!/usr/bin/perl
use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use Test::More;

use lib qw( lib extlib t/lib );
use MT::Test qw( :app :db );
use MT;
use MT::Object;

MT->instance();
my $driver = MT::Object->driver();

my $object_types = MT->registry('object_types');
my @model        = values %$object_types;

for my $model (@model) {

    my $pk = $model->primary_key_tuple();
    next unless $pk && ref($pk) eq 'ARRAY' && @$pk;

    subtest $model => sub {
        my $pk = $model->primary_key_tuple();
        next unless $pk && ref($pk) eq 'ARRAY' && @$pk;

        my @column_name = map { $model->datasource . '_' . $_ } @$pk;

        # No arguments
        {
            my ( $sql, $bind, $stmt ) = $driver->prepare_fetch($model);
            my $order_by = 'ORDER BY '
                . join( ' ,', map { $_ . " ASC" } @column_name );
            my $qr = qr/$order_by/;
            like( $sql, $qr, 'No arguments.' );
        }

        # Ascending sort
        {
            my $args
                = @$pk == 1
                ? { sort => $pk->[0] }
                : {
                sort => [ map { +{ column => $_, desc => 'ASC' } } @$pk ]
                };
            my ( $sql, $bind, $stmt )
                = $driver->prepare_fetch( $model, undef, $args );
            my $order_by = 'ORDER BY '
                . join( ' ,', map { $_ . ' ASC' } @column_name );
            my $qr = qr/$order_by/;
            like( $sql, $qr, 'Ascending sort.' );
        }

        # Descending sort
        {
            my $args
                = @$pk == 1
                ? { sort => $pk->[0], direction => 'descend' }
                : {
                sort => [ map { +{ column => $_, desc => 'DESC' } } @$pk ]
                };
            my ( $sql, $bind, $stmt )
                = $driver->prepare_fetch( $model, undef, $args );
            my $order_by = 'ORDER BY '
                . join( ', ', map { $_ . ' DESC' } @column_name );
            my $qr = qr/$order_by/;
            like( $sql, $qr, 'Descending sort.' );
        }
    };
}

done_testing();

