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

use utf8;

use MT::Test qw(:db :data);

use MT;
use MT::Filter;

my $mt = MT->new();

my $filter = MT::Filter->new;
ok( $filter,                     'Create a filter' );
ok( $filter->object_ds('entry'), 'Assign object_ds' );

my @count_specs = (
    {   name    => 'All',
        options => {
            terms => {},
            args  => {},
        },
        results => [ 8, 8 ],
    },
    {   name    => 'Released',
        options => {
            terms => { status => MT::Entry::RELEASE(), },
            args  => {},
        },
        results => [ 6, 6 ],
    },
    {   name    => 'Released and commented',
        options => {
            terms => { status => MT::Entry::RELEASE(), },
            args  => {
                'join' => MT::Comment->join_on(
                    'entry_id', undef, { unique => 1 }
                ),
            },
        },
        results => [ 5, 5 ],
    },
    {   name    => 'Only entries (that author_id is 2) is editable',
        options => {
            terms          => { status => MT::Entry::RELEASE(), },
            args           => {},
            editable_terms => {
                status    => MT::Entry::RELEASE(),
                author_id => 2,
            },
        },
        results => [ 6, 5 ],
    },
    {   name =>
            'Only entries (that author_id is 2) is editable and editable_args is copied from args',
        options => {
            terms => { status => MT::Entry::RELEASE(), },
            args  => {
                'join' => MT::Comment->join_on(
                    'entry_id',
                    { junk_status => MT::Comment::JUNK },
                    { unique      => 1 }
                ),
            },
            editable_terms => {
                status    => MT::Entry::RELEASE(),
                author_id => 2,
            },
        },
        results => [ 1, 1 ],
    },
    {   name =>
            'Only entries (that author_id is 2) is editable and editable_args is copied from args',
        options => {
            terms          => { status => MT::Entry::RELEASE(), },
            args           => {},
            editable_terms => {
                status    => MT::Entry::RELEASE(),
                author_id => 2,
            },
            editable_args => {
                'join' => MT::Comment->join_on(
                    'entry_id', undef, { unique => 1 }
                ),
            },
        },
        results => [ 6, 4 ],
    },
    {   name =>
            'Only released entries are editable. (filterd by editable_filters)',
        options => {
            terms            => {},
            args             => {},
            editable_filters => [
                sub {
                    my ( $objs, $options ) = @_;
                    grep( $_->status == MT::Entry::RELEASE(), @$objs );
                },
            ],
        },
        results => [ 8, 6 ],
    },
    {   name    => 'Both editable_terms and editable_filters are specified.',
        options => {
            terms            => { status => MT::Entry::RELEASE(), },
            args             => {},
            editable_terms   => {},
            editable_filters => [ sub    { 1; }, ],
        },
        error =>
            '"editable_terms" and "editable_filters" cannot be specified at the same time.'
    },
);

for my $spec (@count_specs) {
    my $count_result = $filter->count_objects( %{ $spec->{options} } );
    if ($count_result) {
        is_deeply( $count_result, $spec->{results}, $spec->{name} );
    }
    else {
        my $errstr = $filter->errstr;
        chomp($errstr);
        is( $errstr, $spec->{error}, $spec->{name} );
    }
}

done_testing;
