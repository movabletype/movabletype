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

use utf8;

use MT::Test;

use MT;
use MT::Filter;

$test_env->prepare_fixture('db_data');

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
            is( scalar @$query_log, 2, '2 query logs' );
            like( $query_log->[-1], qr/LIMIT 1$/, 'Has LIMIT statement' );
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

no warnings 'once';
$Data::ObjectDriver::PROFILE = 1;
for my $spec (@count_specs) {
    note( $spec->{name} );

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
