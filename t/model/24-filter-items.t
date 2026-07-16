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

$test_env->prepare_fixture('db');
my $admin = MT::Author->load(1);
my $blog  = MT::Blog->load(1);

sub create_entry {
    my ($title) = @_;
    my $e = MT::Entry->new;
    $e->set_values({
        blog_id     => $blog->id,
        author_id   => $admin->id,
        status      => MT::Entry::RELEASE(),
        title       => $title,
        text        => "This is entry with title '$title'.",
        authored_on => '20160606000000',
        modified_on => '20160606000000',
        created_on  => '20160606000000',
    });
    $e->save or die $e->errstr;
}
create_entry('a');
create_entry('b');

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
            like( $query_log->[-1], qr/(?:TOP\(1\)|LIMIT 1|ROWNUM as line.+\(line <= 1\)$)/, 'Has LIMIT statement' );
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
            unlike( $query_log->[0], qr/(?:TOP\(1\)|LIMIT 1|ROWNUM as line.+\(line <= 1\)$)/, 'Has no LIMIT statement' );
        },
    },

    # grep for __virtual.object_count
    {
        name       => '__virtual.object_count : grep : equal to 1',
        datasource => 'author',
        items      => [{
            type => 'entry_count',
            args => {
                value  => 1,
                option => 'equal',
            },
        }],
        complete => sub {
            my (undef, $objs) = @_;
            is @$objs, 0;
        },
    },
    {
        name       => '__virtual.object_count : grep : equal to 2',
        datasource => 'author',
        items      => [{
            type => 'entry_count',
            args => {
                value  => 2,
                option => 'equal',
            },
        }],
        complete => sub {
            my (undef, $objs) = @_;
            is @$objs, 1;
        },
    },
    {
        name       => '__virtual.object_count : grep : not equal to 1',
        datasource => 'author',
        items      => [{
            type => 'entry_count',
            args => {
                value  => 1,
                option => 'not_equal',
            },
        }],
        complete => sub {
            my (undef, $objs) = @_;
            is @$objs, 1;
        },
    },
    {
        name       => '__virtual.object_count : grep : not equal to 2',
        datasource => 'author',
        items      => [{
            type => 'entry_count',
            args => {
                value  => 2,
                option => 'not_equal',
            },
        }],
        complete => sub {
            my (undef, $objs) = @_;
            is @$objs, 0;
        },
    },
    {
        name       => '__virtual.object_count : grep : greater than 1',
        datasource => 'author',
        items      => [{
            type => 'entry_count',
            args => {
                value  => 1,
                option => 'greater_than',
            },
        }],
        complete => sub {
            my (undef, $objs) = @_;
            is @$objs, 1;
        },
    },
    {
        name       => '__virtual.object_count : grep : greater than 2',
        datasource => 'author',
        items      => [{
            type => 'entry_count',
            args => {
                value  => 2,
                option => 'greater_than',
            },
        }],
        complete => sub {
            my (undef, $objs) = @_;
            is @$objs, 0;
        },
    },
    {
        name       => '__virtual.object_count : grep : greater equal to 2',
        datasource => 'author',
        items      => [{
            type => 'entry_count',
            args => {
                value  => 2,
                option => 'greater_equal',
            },
        }],
        complete => sub {
            my (undef, $objs) = @_;
            is @$objs, 1;
        },
    },
    {
        name       => '__virtual.object_count : grep : greater equal to 3',
        datasource => 'author',
        items      => [{
            type => 'entry_count',
            args => {
                value  => 3,
                option => 'greater_equal',
            },
        }],
        complete => sub {
            my (undef, $objs) = @_;
            is @$objs, 0;
        },
    },
    {
        name       => '__virtual.object_count : grep : less than 3',
        datasource => 'author',
        items      => [{
            type => 'entry_count',
            args => {
                value  => 3,
                option => 'less_than',
            },
        }],
        complete => sub {
            my (undef, $objs) = @_;
            is @$objs, 1;
        },
    },
    {
        name       => '__virtual.object_count : grep : less than 2',
        datasource => 'author',
        items      => [{
            type => 'entry_count',
            args => {
                value  => 2,
                option => 'less_than',
            },
        }],
        complete => sub {
            my (undef, $objs) = @_;
            is @$objs, 0;
        },
    },
    {
        name       => '__virtual.object_count : grep : less equal to 2',
        datasource => 'author',
        items      => [{
            type => 'entry_count',
            args => {
                value  => 2,
                option => 'less_equal',
            },
        }],
        complete => sub {
            my (undef, $objs) = @_;
            is @$objs, 1;
        },
    },
    {
        name       => '__virtual.object_count : grep : less equal to 1',
        datasource => 'author',
        items      => [{
            type => 'entry_count',
            args => {
                value  => 1,
                option => 'less_equal',
            },
        }],
        complete => sub {
            my (undef, $objs) = @_;
            is @$objs, 0;
        },
    },
    {
        name       => '__virtual.object_count : grep : invalid option',
        datasource => 'author',
        items      => [{
            type => 'entry_count',
            args => {
                value  => 1,
                option => 'invalid_option',
            },
        }],
        complete => sub {
            my (undef, $objs) = @_;
            is @$objs, 1; # option is invalid, so all objects are returned
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
    my $objs = $filter->load_objects( %{ $spec->{options} } );
    if ( my $complete = $spec->{complete} ) {
        $complete->($spec, $objs);
    }
}

done_testing;
