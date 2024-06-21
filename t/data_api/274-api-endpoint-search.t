#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',  ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::DataAPI;

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

# preparation.
my $author = $app->model('author')->load(1);
my $blog   = $app->model('blog')->load(1);
my $entry  = $app->model('entry')->load(
    {   blog_id => $blog->id,
        status  => MT::Entry::RELEASE(),
    }
);

# test.
my $suite = suite();
test_data_api($suite);

# end.
done_testing;

sub suite {
    my @tests = (

        # search - irregular tests
        {   path   => '/v2/search',
            method => 'GET',
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A parameter "search" is required.',
                    },
                };
            },
        },
        {   path   => '/v2/search',
            method => 'GET',
            params => { tagSearch => 1 },
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A parameter "tag" is required.',
                    },
                };
            },
        },

        # search - normal tests

        # Tests from 140-app-search.t.
        {    # Found an entry.
            path   => '/v2/search',
            method => 'GET',
            params => {
                search       => $entry->title,
                IncludeBlogs => $blog->id,
                limit        => 20,
            },
            result => sub {
                my @entries = $app->model('entry')->load(
                    {   blog_id => $blog->id,
                        status  => MT::Entry::RELEASE(),
                        class   => '*'
                    },
                    { sort => [{ column => 'authored_on', desc => 'DESC' }, { column => 'id', desc => 'DESC' }] },
                );

                my $entry_title = $entry->title;
                my @greped_entries;
                for my $e (@entries) {
                    if ( grep { $e->$_ && $e->$_ =~ m/$entry_title/ }
                        qw/ title text text_more keywords / )
                    {
                        push @greped_entries, $e;
                    }
                }

                $app->user($author);

                return +{
                    totalResults => scalar @greped_entries,
                    items        => MT::DataAPI::Resource->from_object(
                        \@greped_entries
                    ),
                };
            },
        },
        {    # Not found.
            path   => '/v2/search',
            method => 'GET',
            params => {
                search       => 'Search word for no matching',
                IncludeBlogs => $blog->id,
                limit        => 20,
            },
            result => sub {
                return +{
                    totalResults => 0,
                    items        => [],
                };
            },
        },
        {    # No blog was specified.
            path   => '/v2/search',
            method => 'GET',
            params => {
                search => $entry->title,
                limit  => 20,
            },
            result => sub {
                my @entries = $app->model('entry')->load(
                    {   blog_id => $blog->id,
                        status  => MT::Entry::RELEASE(),
                        class   => '*'
                    },
                    { sort => [{ column => 'authored_on', desc => 'DESC' }, { column => 'id', desc => 'DESC' }] },
                );

                my $entry_title = $entry->title;
                my @greped_entries;
                for my $e (@entries) {
                    if ( grep { $e->$_ && $e->$_ =~ m/$entry_title/ }
                        qw/ title text text_more keywords / )
                    {
                        push @greped_entries, $e;
                    }
                }

                $app->user($author);

                return +{
                    totalResults => scalar @greped_entries,
                    items        => MT::DataAPI::Resource->from_object(
                        \@greped_entries
                    ),
                };
            },
        },
        {    # Only "IncludeBlogs=all" is specified.
            path   => '/v2/search',
            method => 'GET',
            params => {
                IncludeBlogs => 'all',
                search       => $entry->title,
                limit        => 20,
            },
            result => sub {
                my @entries = $app->model('entry')->load(
                    {   blog_id => $blog->id,
                        status  => MT::Entry::RELEASE(),
                        class   => '*'
                    },
                    { sort => [{ column => 'authored_on', desc => 'DESC' }, { column => 'id', desc => 'DESC' }] },
                );

                my $entry_title = $entry->title;
                my @greped_entries;
                for my $e (@entries) {
                    if ( grep { $e->$_ && $e->$_ =~ m/$entry_title/ }
                        qw/ title text text_more keywords / )
                    {
                        push @greped_entries, $e;
                    }
                }

                $app->user($author);

                return +{
                    totalResults => scalar @greped_entries,
                    items        => MT::DataAPI::Resource->from_object(
                        \@greped_entries
                    ),
                };
            },
        },

        # Original tests for search endpoint.
        {    # limit.
            path   => '/v2/search',
            method => 'GET',
            params => {
                search       => 'a',
                IncludeBlogs => '1,2',
                limit        => 5,
            },
            result => sub {
                my @entries = $app->model('entry')->load(
                    {   blog_id => [ 1, 2 ],
                        status  => MT::Entry::RELEASE(),
                        class   => '*'
                    },
                    { sort => [{ column => 'authored_on', desc => 'DESC' }, { column => 'id', desc => 'DESC' }] },
                );

                my @greped_entries;
                for my $e (@entries) {
                    if ( grep { $e->$_ && $e->$_ =~ m/a/ }
                        qw/ title text text_more keywords / )
                    {
                        push @greped_entries, $e;
                    }
                }

                $app->user($author);

                return +{
                    totalResults => scalar @greped_entries,
                    items        => MT::DataAPI::Resource->from_object(
                        [ @greped_entries[ 0 .. 4 ] ]
                    ),
                };
            },
        },
        {    # offset.
            path   => '/v2/search',
            method => 'GET',
            params => {
                search       => 'a',
                IncludeBlogs => '1,2',
                limit        => 5,
                offset       => 5,
            },
            result => sub {
                my @entries = $app->model('entry')->load(
                    {   blog_id => [ 1, 2 ],
                        status  => MT::Entry::RELEASE(),
                        class   => '*'
                    },
                    { sort => [{ column => 'authored_on', desc => 'DESC' }, { column => 'id', desc => 'DESC' }] },
                );

                my @greped_entries;
                for my $e (@entries) {
                    if ( grep { $e->$_ && $e->$_ =~ m/a/ }
                        qw/ title text text_more keywords / )
                    {
                        push @greped_entries, $e;
                    }
                }

                $app->user($author);

                return +{
                    totalResults => scalar @greped_entries,
                    items        => MT::DataAPI::Resource->from_object([grep { $_ } @greped_entries[5 .. 9]]),
                };
            },
        },
        {    # MTC-25640: phrasal search for a custom field doesn't die
            path   => '/v2/search',
            method => 'GET',
            params => {
                search       => 'a OR field:name:"foo bar"',
                IncludeBlogs => '1,2',
            },
            result => sub {
                my @entries = $app->model('entry')->load(
                    {   blog_id => [ 1, 2 ],
                        status  => MT::Entry::RELEASE(),
                        class   => '*'
                    },
                    { sort => [{ column => 'authored_on', desc => 'DESC' }, { column => 'id', desc => 'DESC' }] },
                );

                my @greped_entries;
                for my $e (@entries) {
                    if ( grep { $e->$_ && $e->$_ =~ m/a/ }
                        qw/ title text text_more keywords / )
                    {
                        push @greped_entries, $e;
                    }
                }

                $app->user($author);

                return +{
                    totalResults => scalar @greped_entries,
                    items        => MT::DataAPI::Resource->from_object(
                        \@greped_entries
                    ),
                };
            },
        },
    );

    my @ok_tests = grep {!$_->{code}} @tests;

    # Respect DataAPIDisableSite
    my @extra_tests;
    for my $ok_test (@ok_tests) {
        my %new_test = %$ok_test;
        delete $new_test{result};
        $new_test{code} = 403;
        push @extra_tests, \%new_test;
    }
    $extra_tests[0]{setup} = sub {
        $app->config->DataAPIDisableSite($blog->id);
        $app->config->save_config;
        $blog->allow_data_api(0);
        $blog->save;
    };
    push @tests, @extra_tests;

    # Respect DataAPIDisableSite (but a superuser ignores it)
    my @extra_tests_for_superuser;
    for my $ok_test (@ok_tests) {
        my %new_test = %$ok_test;
        $new_test{is_superuser} = 1;
        push @extra_tests_for_superuser, \%new_test;
    }
    push @tests, @extra_tests_for_superuser;

    # Make Superuser Respect DataAPIDisableSite
    my @extra_tests_for_respecting_superuser;
    for my $ok_test (@ok_tests) {
        my %new_test = %$ok_test;
        delete $new_test{result};
        $new_test{code} = 403;
        $new_test{is_superuser} = 1;
        push @extra_tests_for_respecting_superuser, \%new_test;
    }
    $extra_tests_for_respecting_superuser[0]{setup} = sub {
        $app->config->MakeSuperuserRespectDataAPIDisableSite(1);
        $app->config->save_config;
    };
    push @tests, @extra_tests_for_respecting_superuser;

    # These tests should be the last.
    push @tests, (
        {    # no blog. (bugid:113059)
            path   => '/v2/search',
            method => 'GET',
            params => { search => 'a', },
            setup  => sub {
                MT->model('blog')->remove_all;
                is( MT->model('blog')->count, 0, 'There is no blog.' );
            },
        },

        # tagSearch=1.
        {   path    => '/v2/search',
            method  => 'GET',
            params  => { tagSearch => 1, tag => 'tag' },
            result => sub { +{ totalResults => 0, items => [] } },
        },
    );

    return \@tests;
}

