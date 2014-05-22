#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use Test::More;

#use MT::Test qw(:db :data);
use MT::Test;

use MT;
use MT::Filter;

my $mt = MT->new();

my @count_specs = (
    {   name       => 'pack with terms items',
        datasource => 'entry',
        items      => [
            {   type => 'pack',
                args => {
                    op    => 'and',
                    items => [
                        map {
                            +{  type => 'title',
                                args => {
                                    string => $_,
                                    option => 'contains',
                                },
                            };
                        } qw(a b)
                    ],
                },
            }
        ],
        options  => { limit => 1, offset => 0 },
        complete => sub {
            my ($spec)    = @_;
            my $profiler  = Data::ObjectDriver->profiler;
            my $query_log = $profiler->query_log;
            shift @$query_log;
            like( $query_log->[0], qr/LIMIT 1$/, 'Has LIMIT statement' );
        },
    },
    {   name       => 'pack with grep items',
        datasource => 'author',
        items      => [
            {   type => 'pack',
                args => {
                    op    => 'and',
                    items => [
                        {   type => 'entry_count',
                            args => {
                                value  => 1,
                                option => 'greater_equal',
                            },
                        }
                    ],
                },
            }
        ],
        options  => { limit => 1, offset => 0 },
        complete => sub {
            my ($spec)    = @_;
            my $profiler  = Data::ObjectDriver->profiler;
            my $query_log = $profiler->query_log;
            shift @$query_log;
            unlike( $query_log->[0], qr/LIMIT 1$/, 'Has no LIMIT statement' );
        },
    },
);

$Data::ObjectDriver::PROFILE = 1;
for my $spec (@count_specs) {
    diag( $spec->{name} );

    my $filter = MT::Filter->new;
    $filter->object_ds( $spec->{datasource} || 'entry' );
    Data::ObjectDriver->profiler->reset;
    $filter->items( $spec->{items} );
    my @objs = $filter->load_objects( %{ $spec->{options} } );
    if ( my $complete = $spec->{complete} ) {
        $complete->($spec);
    }
}

done_testing;
