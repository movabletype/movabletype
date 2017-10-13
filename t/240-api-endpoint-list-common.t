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


use lib qw(lib extlib t/lib);

use Test::More;
use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $suite = suite();
test_data_api($suite);

done_testing;

sub result {
    my ( $terms, $args ) = @_;
    my $entry_class = $app->model('entry');
    +{  totalResults => $entry_class->count( $terms, $args ),
        items        => [
            map { +{ id => $_->id, title => $_->title, } }
                $entry_class->load( $terms, $args )
        ],
    };
}

sub suite {
    return +[
        {   path   => '/v1/sites/1/entries',
            method => 'GET',
            params => {
                limit  => 1,
                fields => 'id,title',
            },
            result => result(
                { class => 'entry', blog_id => 1 },
                {   limit => 1,
                    sort  => [
                        { column => 'authored_on', desc => 'DESC' },
                        { column => "id",          desc => 'DESC' },
                    ]
                }
            ),
        },
        {   path   => '/v1/sites/1/entries',
            method => 'GET',
            params => {
                limit  => 1,
                sortBy => 'title',
                fields => 'id,title',
            },
            result => result(
                { class => 'entry', blog_id => 1 },
                {   limit => 1,
                    sort  => [ { column => 'title', desc => 'DESC' }, ]
                }
            ),
        },
        {   path   => '/v1/sites/1/entries',
            method => 'GET',
            params => {
                limit     => 1,
                sortBy    => 'title',
                sortOrder => 'ascend',
                fields    => 'id,title',
            },
            result => result(
                { class => 'entry', blog_id => 1 },
                {   limit => 1,
                    sort  => [ { column => 'title', desc => 'ASC' }, ]
                }
            ),
        },
        {   path   => '/v1/sites/1/entries',
            method => 'GET',
            params => {
                limit  => 1,
                search => 'Rainy',
                fields => 'id,title',
            },
            result => result(
                {   class   => 'entry',
                    blog_id => 1,
                    title   => { like => '%Rainy%' },
                },
                {   limit => 1,
                    sort  => [
                        { column => 'authored_on', desc => 'DESC' },
                        { column => "id",          desc => 'DESC' },
                    ]
                }
            ),
        },
        map( {  +{  path   => '/v1/sites/1/entries',
                    method => 'GET',
                    params => {
                        limit  => 1,
                        status => $_->[0],
                        fields => 'id,title',
                    },
                    result => result(
                        {   class   => 'entry',
                            blog_id => 1,
                            status  => $_->[1],
                        },
                        {   limit => 1,
                            sort  => [
                                { column => 'authored_on', desc => 'DESC' },
                                { column => "id",          desc => 'DESC' },
                            ]
                        }
                    ),
                }
            } ( [ Publish => MT::Entry::RELEASE(), ],
                [ Draft   => MT::Entry::HOLD(), ],
                [ Review  => MT::Entry::REVIEW(), ],
                [ Future  => MT::Entry::FUTURE(), ],
                [ Spam    => MT::Entry::JUNK(), ],
                ) ),
        {   path   => '/v1/sites/1/entries',
            method => 'GET',
            params => {
                limit      => 1,
                excludeIds => '3,2',
                fields     => 'id,title',
            },
            result => result(
                {   class   => 'entry',
                    blog_id => 1,
                    id      => { not => [ 3, 2 ] },
                },
                {   limit => 1,
                    sort  => [
                        { column => 'authored_on', desc => 'DESC' },
                        { column => "id",          desc => 'DESC' },
                    ]
                }
            ),
        },
        {   path   => '/v1/sites/1/entries',
            method => 'GET',
            params => {
                limit      => 1,
                includeIds => '3,2',
                fields     => 'id,title',
            },
            result => result(
                {   class   => 'entry',
                    blog_id => 1,
                    id      => [ 3, 2 ],
                },
                {   limit => 1,
                    sort  => [
                        { column => 'authored_on', desc => 'DESC' },
                        { column => "id",          desc => 'DESC' },
                    ]
                }
            ),
        },
    ];
}

