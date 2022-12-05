#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::DataAPI;
use MT::Test::Fixture;
use JSON;

$test_env->prepare_fixture('db');
my $objs = MT::Test::Fixture->prepare(
    {   author => [
            { name => 'John Doe' },
            { name => 'Johnson Doe' },
            { name => 'John Doevil' },
            { name => 'Doe John' },
            { name => 'Jane Doe' },
            { name => "O'Reilly Doe" },
        ],
        category => [
            'apple',     'pineapple',
            'big apple', 'big green apple',
            'orange',    'small orange',
            "jack-o'-lantern"
        ],
        entry => [
            {   author     => 'John Doe',
                title      => 'Foo Bar',
                categories => ['apple']
            },
            {   author     => 'John Doe',
                title      => 'Foo BigBar',
                categories => ['pineapple']
            },
            {   author     => 'John Doe',
                title      => 'FooBar',
                categories => ['big green apple']
            },
            {   author     => 'John Doe',
                title      => 'Bar Foo',
                categories => ['apple']
            },
            {   author     => 'John Doe',
                title      => 'FooFoo Bar',
                categories => [ 'apple', 'pineapple' ]
            },
            {   author     => 'John Doevil',
                title      => 'Big Foo Bar',
                categories => ['big apple']
            },
            {   author     => 'Johnson Doe',
                title      => 'Son, Foo Bar',
                categories => ['big green apple']
            },
            {   author     => 'Jane Doe',
                title      => 'Jane, Foo Bar',
                categories => ['big apple']
            },
            {   author     => 'John Doe',
                title      => 'Quux',
                categories => ['orange']
            },
            {   author     => 'Doe John',
                title      => 'Foo Bar Doe',
                categories => ['small orange']
            },
            {   author     => "O'Reilly Doe",
                title      => 'unknown:Reilly',
                categories => ["jack-o'-lantern"]
            },
        ],
        website => [ { name => 'Site' } ],
    }
);
my $blog_id = $objs->{blog_id};

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

# test.
my $suite = suite();
test_data_api($suite);

# end.
done_testing;

sub expected_titles {
    my @expected_titles = @_;
    return sub {
        my ( $data, $body ) = @_;
        my $json = eval { decode_json($body) };
        ok !$@, 'json is ok';
        my @got_titles = map { $_->{title} } @{ $json->{items} || [] };
        is_deeply( \@got_titles, \@expected_titles, 'expected entry titles' );
    };
}

sub suite {
    return +[

        {    # Simple case
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => 'Foo',
                blog_id => $blog_id,
            },
            complete => expected_titles(
                'Foo Bar Doe',
                'Jane, Foo Bar',
                'Son, Foo Bar',
                'Big Foo Bar',
                'FooFoo Bar',
                'Bar Foo',
                'FooBar',
                'Foo BigBar',
                'Foo Bar',
            ),
        },
        {    # Simple case, with double quotes
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '"Foo"',
                blog_id => $blog_id,
            },
            complete => expected_titles(
                'Foo Bar Doe',
                'Jane, Foo Bar',
                'Son, Foo Bar',
                'Big Foo Bar',
                'FooFoo Bar',
                'Bar Foo',
                'FooBar',
                'Foo BigBar',
                'Foo Bar',
            ),
        },
        {    # Simple case, with parentheses
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '(Foo)',
                blog_id => $blog_id,
            },
            complete => expected_titles(
                'Foo Bar Doe',
                'Jane, Foo Bar',
                'Son, Foo Bar',
                'Big Foo Bar',
                'FooFoo Bar',
                'Bar Foo',
                'FooBar',
                'Foo BigBar',
                'Foo Bar',
            ),
        },
        {    # Simple case, with negation
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '!Foo',
                blog_id => $blog_id,
            },
            complete => expected_titles( 'unknown:Reilly', 'Quux' ),
        },
        {    # Simple case, with negation and quotes
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '!"Foo"',
                blog_id => $blog_id,
            },
            complete => expected_titles( 'unknown:Reilly', 'Quux' ),
        },
        {    # Simple case, with negation and parentheses
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '(!Foo)',
                blog_id => $blog_id,
            },
            complete => expected_titles( 'unknown:Reilly', 'Quux' ),
        },
        {    # Phrase
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '"Foo Bar"',
                blog_id => $blog_id,
            },
            complete => expected_titles(
                'Foo Bar Doe',
                'Jane, Foo Bar',
                'Son, Foo Bar',
                'Big Foo Bar',
                'FooFoo Bar',
                'Foo Bar',
            ),
        },
        {    # Phrase with negation
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '!"Foo Bar"',
                blog_id => $blog_id,
            },
            complete => expected_titles(
                'unknown:Reilly', 'Quux', 'Bar Foo', 'FooBar', 'Foo BigBar'
            ),
        },
        {    # Phrase OR phrase
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '"Foo Bar" OR "Bar Foo"',
                blog_id => $blog_id,
            },
            complete => expected_titles(
                'Foo Bar Doe',
                'Jane, Foo Bar',
                'Son, Foo Bar',
                'Big Foo Bar',
                'FooFoo Bar',
                'Bar Foo',
                'Foo Bar',
            ),
        },
        {    # title (phrase OR phrase)
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => 'title:("Foo Bar" OR "Bar Foo")',
                blog_id => $blog_id,
            },
            complete => expected_titles(
                'Foo Bar Doe',
                'Jane, Foo Bar',
                'Son, Foo Bar',
                'Big Foo Bar',
                'FooFoo Bar',
                'Bar Foo',
                'Foo Bar',
            ),
        },
        {    # title (!phrase AND !phrase)
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => 'title:(!"Foo Bar" AND !"Bar Foo")',
                blog_id => $blog_id,
            },
            complete => expected_titles(
                'unknown:Reilly', 'Quux', 'FooBar', 'Foo BigBar',
            ),
        },
        {    # title (!phrase)
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => 'title:(!"Foo Bar")',
                blog_id => $blog_id,
            },
            complete => expected_titles(
                'unknown:Reilly', 'Quux', 'Bar Foo', 'FooBar', 'Foo BigBar',
            ),
        },
        {    # title -phrase
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '-title:"Foo Bar"',
                blog_id => $blog_id,
            },
            complete => expected_titles(
                'unknown:Reilly', 'Quux', 'Bar Foo', 'FooBar', 'Foo BigBar',
            ),
        },
        {    # unknown field
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => 'unknown:Reilly',
                blog_id => $blog_id,
            },
            complete => expected_titles('unknown:Reilly'),
        },
        {    # unknown (field)
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => 'unknown:(Reilly)',
                blog_id => $blog_id,
            },
            complete => expected_titles(),
        },
        {    # unknown field with negation
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '-unknown:Reilly',
                blog_id => $blog_id,
                limit => 20, # default of 10 is too small to test 10 result out of 11.
            },
            complete => expected_titles(
                'unknown:Reilly',
                'Foo Bar Doe',
                'Quux',
                'Jane, Foo Bar',
                'Son, Foo Bar',
                'Big Foo Bar',
                'FooFoo Bar',
                'Bar Foo',
                'FooBar',
                'Foo BigBar',
                'Foo Bar',
            ),
        },
        {    # unknown field inside phrase with negation
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '-"unknown:Reilly"',
                blog_id => $blog_id,
                limit => 20, # default of 10 is too small to test 10 result out of 11.
            },
            complete => expected_titles(
                'Foo Bar Doe',
                'Quux',
                'Jane, Foo Bar',
                'Son, Foo Bar',
                'Big Foo Bar',
                'FooFoo Bar',
                'Bar Foo',
                'FooBar',
                'Foo BigBar',
                'Foo Bar',
            ),
        },
        {    # Phrase + author
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '"Foo Bar" author:John',
                blog_id => $blog_id,
            },
            complete => expected_titles(
                'Foo Bar Doe',
                'Son, Foo Bar',
                'Big Foo Bar',
                'FooFoo Bar',
                'Foo Bar',
            ),
        },
        {    # Phrase + author with doublequotes
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '"Foo Bar" author:"John"',
                blog_id => $blog_id,
            },
            complete => expected_titles(
                'Foo Bar Doe',
                'Son, Foo Bar',
                'Big Foo Bar',
                'FooFoo Bar',
                'Foo Bar',
            ),
        },
        {    # Phrase + author with negation
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '"Foo Bar" -author:John',
                blog_id => $blog_id,
            },
            complete => expected_titles('Jane, Foo Bar'),
        },
        {    # Phrase + author with (negation)
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '"Foo Bar" author:(-John)',
                blog_id => $blog_id,
            },
            complete => expected_titles('Jane, Foo Bar'),
        },
        {    # Phrase + author with a single quote
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => 'author:"O\'Reilly"',
                blog_id => $blog_id,
            },
            complete => expected_titles( 'unknown:Reilly', ),
        },
        {    # Phrase + author phrase
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '"Foo Bar" author:"John Doe"',
                blog_id => $blog_id,
            },
            complete =>
                expected_titles( 'Big Foo Bar', 'FooFoo Bar', 'Foo Bar' ),
        },
        {    # Phrase + author (phrase OR phrase)
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '"Foo Bar" author:("John Doe" OR "Johnson Doe")',
                blog_id => $blog_id,
            },
            complete => expected_titles(
                'Son, Foo Bar',
                'Big Foo Bar',
                'FooFoo Bar',
                'Foo Bar',
            ),
        },
        {    # Phrase + author (!phrase AND !phrase)
            path   => '/v2/search',
            method => 'GET',
            params => {
                search => '"Foo Bar" author:(!"John Doe" AND !"Johnson Doe")',
                blog_id => $blog_id,
            },
            complete => expected_titles( 'Foo Bar Doe', 'Jane, Foo Bar' ),
        },
        {    # Phrase + category
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '"Foo Bar" category:apple',
                blog_id => $blog_id,
            },
            complete => expected_titles( 'FooFoo Bar', 'Foo Bar', ),
        },
        {    # Phrase + category with doublequotes
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '"Foo Bar" category:"apple"',
                blog_id => $blog_id,
            },
            complete => expected_titles( 'FooFoo Bar', 'Foo Bar', ),
        },
        {    # Phrase + category with negation
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '"Foo Bar" -category:apple',
                blog_id => $blog_id,
            },
            complete => expected_titles(
                'Foo Bar Doe',
                'Jane, Foo Bar',
                'Son, Foo Bar',
                'Big Foo Bar',
                'FooFoo Bar',
            ),
        },
        {    # Phrase + category with (negation)
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '"Foo Bar" category:(-apple)',
                blog_id => $blog_id,
            },
            complete => expected_titles(
                'Foo Bar Doe',
                'Jane, Foo Bar',
                'Son, Foo Bar',
                'Big Foo Bar',
                'FooFoo Bar',
            ),
        },
        {    # Phrase + category with a single quote
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => 'category:"jack-o\'-lantern"',
                blog_id => $blog_id,
            },
            complete => expected_titles( 'unknown:Reilly', ),
        },
        {    # Phrase + category phrase
            path   => '/v2/search',
            method => 'GET',
            params => {
                search  => '"Foo Bar" category:"big apple"',
                blog_id => $blog_id,
            },
            complete => expected_titles( 'Jane, Foo Bar', 'Big Foo Bar' ),
        },
        {    # Phrase + category (phrase OR phrase)
            path   => '/v2/search',
            method => 'GET',
            params => {
                search =>
                    '"Foo Bar" category:("big apple" OR "small orange")',
                blog_id => $blog_id,
            },
            complete => expected_titles(
                'Foo Bar Doe',
                'Jane, Foo Bar',
                'Big Foo Bar',
            ),
        },
        {    # Phrase + category (!phrase AND !phrase)
            path   => '/v2/search',
            method => 'GET',
            params => {
                search =>
                    '"Foo Bar" category:(!"big apple" AND !"small orange")',
                blog_id => $blog_id,
            },
            complete =>
                expected_titles( 'Son, Foo Bar', 'FooFoo Bar', 'Foo Bar', ),
        },
    ];
}
