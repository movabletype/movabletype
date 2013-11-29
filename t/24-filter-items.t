#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use Test::More;

eval(
    $ENV{SKIP_REINITIALIZE_DATABASE}
    ? "use MT::Test qw(); 1;"
    : "use MT::Test qw(:db :data); 1;"
) or die $@;

use MT;
use MT::Filter;

my $mt = MT->new();

sub setupFilter {
    my ( $id, $items ) = @_;

    my $filter = MT->model('filter')->load($id) || MT->model('filter')->new;
    $filter->set_values( { id => $id, author_id => 1, blog_id => 1 } );
    $filter->items($items);
    $filter->save or die;
}

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
    $spec->{setup}->($spec) if $spec->{setup};

    my $filter = MT::Filter->new;
    $filter->object_ds( $spec->{datasource} || 'entry' );
    Data::ObjectDriver->profiler->reset;
    $filter->items( $spec->{items} );
    my $objs = $filter->load_objects( %{ $spec->{options} } );
    if ( my $complete = $spec->{complete} ) {
        $complete->($spec, $objs);
    }
}

done_testing;
