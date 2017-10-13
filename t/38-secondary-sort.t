#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}


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
my @model = grep { !ref $_ } values %$object_types;

for my $model (sort @model) {

    my $pk = $model->primary_key_tuple();
    next unless $pk && ref($pk) eq 'ARRAY' && @$pk;

    subtest $model => sub {
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

        # Join
        {
            my $child_classes = $model->properties->{child_classes};
            for my $child_class ( sort keys %$child_classes ) {

                # No sort
                {
                    my $args
                        = {
                        join => $child_class->join_on( 'id', undef, undef, ),
                        };
                    my ( $sql, $bind, $stmt )
                        = $driver->prepare_fetch( $model, undef, $args );
                    my $order_by
                        = 'ORDER BY ' . $model->datasource . '_id ASC';
                    my $qr = qr/$order_by/;
                    like( $sql, $qr,
                        'Join ' . $child_class . ' with no sort.' );
                }

                # With sort
                {
                    my $args = {
                        join => $child_class->join_on(
                            'id', undef, { direction => 'descend', },
                        ),
                    };
                    my ( $sql, $bind, $stmt )
                        = $driver->prepare_fetch( $model, undef, $args );
                    my $col = $model->datasource . '_id';
                    ok( $sql =~ m/ORDER BY [\w ]+, $col ASC/,
                        'Join ' . $child_class . ' with descending sort.' );
                }
            }
        }
    };
}

done_testing();

