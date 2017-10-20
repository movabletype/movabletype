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

use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

my $blog_entry = $app->model('entry')->load( { blog_id => 1 } );
$blog_entry->add_tags('@private');
$blog_entry->save or die $blog_entry->errstr;

my $blog_private_tag = $app->model('tag')->load(
    { is_private => 1 },
    {   join => $app->model('objecttag')->join_on(
            'tag_id',
            {   blog_id           => 1,
                object_datasource => 'entry',
                object_id         => $blog_entry->id
            },
        )
    },
);

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

#        # list_tags - normal tests
#        {   path      => '/v2/tags',
#            method    => 'GET',
#            callbacks => [
#                {   name  => 'data_api_pre_load_filtered_list.tag',
#                    count => 2,
#                },
#            ],
#            complete => sub {
#                my ( $data, $body ) = @_;
#
#                my $got_logs = $app->current_format->{unserialize}->($body);
#                my @expected_logs
#                    = MT->model('tag')->load( undef, { sort => 'name' } );
#
#                my @got_log_names
#                    = map { $_->{name} } @{ $got_logs->{items} };
#                my @expected_log_names = map { $_->name } @expected_logs;
#
#                is_deeply( \@got_log_names, \@expected_log_names );
#            },
#        },
#        {    # Search name.
#            path      => '/v2/tags',
#            method    => 'GET',
#            params    => { search => 'page' },
#            callbacks => [
#                {   name  => 'data_api_pre_load_filtered_list.tag',
#                    count => 2,
#                },
#            ],
#            result => sub {
#                my @tags = $app->model('tag')->load(
#                    { name => { like => '%page%' } },
#                    { sort => 'name', direction => 'ascend' },
#                );
#
#                $app->user($author);
#
#                return +{
#                    totalResults => 3,
#                    items => MT::DataAPI::Resource->from_object( \@tags ),
#                };
#            },
#        },
#        {
#            # Not logged in.
#            path      => '/v2/tags',
#            method    => 'GET',
#            author_id => 0,
#            callbacks => [
#                {   name  => 'data_api_pre_load_filtered_list.tag',
#                    count => 2,
#                },
#            ],
#            complete => sub {
#                my ( $data, $body ) = @_;
#
#                my $got_logs = $app->current_format->{unserialize}->($body);
#                my @expected_logs
#                    = MT->model('tag')->load( { is_private => { not => 1 } },
#                    { sort => 'name' } );
#
#                my @got_log_names
#                    = map { $_->{name} } @{ $got_logs->{items} };
#                my @expected_log_names = map { $_->name } @expected_logs;
#
#                is_deeply( \@got_log_names, \@expected_log_names );
#            },
#        },

        # list_tags_for_site - irregular tests
        {
            # Non-existent site.
            path   => '/v2/sites/10/tags',
            method => 'GET',
            code   => 404,
        },

        # list_tags_for_site - normal tests
        {   path      => '/v2/sites/1/tags',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.tag',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;

                my $got_logs = $app->current_format->{unserialize}->($body);
                my @expected_logs = MT->model('tag')->load(
                    undef,
                    {   sort => 'name',
                        join => MT->model('objecttag')->join_on(
                            'tag_id',
                            { blog_id => 1 },
                            { unique  => 1 },
                        ),
                    }
                );

                my @got_log_names
                    = map { $_->{name} } @{ $got_logs->{items} };
                my @expected_log_names = map { $_->name } @expected_logs;

                is_deeply( \@got_log_names, \@expected_log_names );
            },
        },
        {    # System.
            path      => '/v2/sites/0/tags',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.tag',
                    count => 2,
                },
            ],
            result => sub {
                my @tags = $app->model('tag')->load(
                    undef,
                    {   sort      => 'name',
                        direction => 'ascend',
                        join      => MT->model('objecttag')->join_on(
                            'tag_id',
                            { blog_id => 0 },
                            { unique  => 1 },
                        ),
                    },
                );

                $app->user($author);

                return +{
                    totalResults => 2,
                    items => MT::DataAPI::Resource->from_object( \@tags ),
                };
            },
        },
        {    # Search name.
            path      => '/v2/sites/1/tags',
            method    => 'GET',
            params    => { search => 'flow' },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.tag',
                    count => 2,
                },
            ],
            result => sub {
                my @tags = $app->model('tag')->load(
                    { name => { like => '%flow%' } },
                    {   sort      => 'name',
                        direction => 'ascend',
                        join      => MT->model('objecttag')->join_on(
                            'tag_id',
                            { blog_id => 1 },
                            { unique  => 1 },
                        ),
                    },
                );

                $app->user($author);

                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( \@tags ),
                };
            },
        },

#        # get_tag - irregular tests
#        {    # Non-existent tag.
#            path   => '/v2/tags/100',
#            method => 'GET',
#            code   => 404,
#        },
#        {    # Private tag and not logged in.
#            path      => '/v2/tags/9',
#            method    => 'GET',
#            author_id => 0,
#            code      => 403,
#            error => 'Do not have permission to retrieve the requested tag.',
#        },
#        {    # Private tag and no permissions.
#            path         => '/v2/tags/9',
#            method       => 'GET',
#            restrictions => { 0 => [qw/ administer /], },
#            code         => 403,
#            error => 'Do not have permission to retrieve the requested tag.',
#        },
#
#        # get_tag - normal tests
#        {   path      => '/v2/tags/1',
#            method    => 'GET',
#            callbacks => [
#                {   name =>
#                        'MT::App::DataAPI::data_api_view_permission_filter.tag',
#                    count => 1,
#                },
#            ],
#            result => sub {
#                return MT->model('tag')->load(1);
#            },
#        },

        # get_tag_for_site - irregular tests
        {    # Existent tag via other site.
            path   => '/v2/sites/2/tags/1',
            method => 'GET',
            code   => 404,
        },
        {    # Existent tag via non-existent site.
            path   => '/v2/sites/10/tags/1',
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent tag via existent site.
            path   => '/v2/sites/1/tags/100',
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent tag via non-existent site.
            path   => '/v2/sites/10/tags/100',
            method => 'GET',
            code   => 404,
        },
        {    # Private tag and not logged in.
            path      => '/v2/sites/0/tags/9',
            method    => 'GET',
            author_id => 0,
            code      => 403,
            error => 'Do not have permission to retrieve the requested tag.',
        },
        {    # Private tag and no permissions (site).
            path         => '/v2/sites/1/tags/' . $blog_private_tag->id,
            method       => 'GET',
            restrictions => { 1 => [qw/ access_to_tag_list edit_tags /], },
            code         => 403,
            error => 'Do not have permission to retrieve the requested tag.',
        },
        {    # Private tag and no permissions (system).
            path         => '/v2/sites/0/tags/9',
            method       => 'GET',
            restrictions => { 0 => [qw/ administer /], },
            code         => 403,
            error => 'Do not have permission to retrieve the requested tag.',
        },

        # get_tag_for_site - normal tests
        {   path      => '/v2/sites/1/tags/1',
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.tag',
                    count => 1,
                },
            ],
            result => sub {
                return MT->model('tag')->load(1);
            },
        },

#        # rename_tag - irregular tests
#        {    # Non-existent tag.
#            path   => '/v2/tags/100',
#            method => 'PUT',
#            code   => 404,
#            result => sub {
#                return +{
#                    error => {
#                        code    => 404,
#                        message => 'Tag not found',
#                    },
#                };
#            },
#        },
#        {    # Invalid parameter.
#            path   => '/v2/tags/1',
#            method => 'PUT',
#            code   => 400,
#            result => sub {
#                return +{
#                    error => {
#                        code    => 400,
#                        message => 'A resource "tag" is required.',
#                    },
#                };
#            },
#        },
#        {    # Not logged in.
#            path      => '/v2/tags/1',
#            method    => 'PUT',
#            params    => { tag => { name => 'grandma' }, },
#            author_id => 0,
#            code      => 401,
#            error     => 'Unauthorized',
#        },
#        {    # No permissions.
#            path   => '/v2/tags/1',
#            method => 'PUT',
#            params => { tag => { name => 'grandma' }, },
#            restrictions => { 0 => [qw/ administer /], },
#            code         => 403,
#            error => 'Do not have permission to rename a tag.',
#        },
#
#        # rename_tag - normal tests
#        {   path      => '/v2/tags/1',
#            method    => 'PUT',
#            params    => { tag => { name => 'grandma' }, },
#            callbacks => [
#                {   name =>
#                        'MT::App::DataAPI::data_api_save_permission_filter.tag',
#                    count => 1,
#                },
#                {   name  => 'MT::App::DataAPI::data_api_save_filter.tag',
#                    count => 1,
#                },
#                {   name  => 'MT::App::DataAPI::data_api_pre_save.tag',
#                    count => 1,
#                },
#                {   name  => 'MT::App::DataAPI::data_api_post_save.tag',
#                    count => 1,
#                },
#            ],
#            result   => sub { MT->model('tag')->load(1); },
#            complete => sub {
#                my $tag = MT->model('tag')->load( { name => 'grandpa' } );
#                is( $tag, undef, 'Renamed "grandpa" tag.' );
#            },
#        },

        # rename_tag_for_site - irregular tests
        {    # Non-existent tag.
            path   => '/v2/sites/1/tags/100',
            method => 'PUT',
            code   => 404,
            result => sub {
                return +{
                    error => {
                        code    => 404,
                        message => 'Tag not found',
                    },
                };
            },
        },
        {    # Non-existent site.
            path   => '/v2/sites/10/tags/2',
            method => 'PUT',
            code   => 404,
            result => sub {
                return +{
                    error => {
                        code    => 404,
                        message => 'Site not found',
                    }
                };
            },
        },
        {    # Non-existent tag via non-existent site.
            path   => '/v2/sites/10/tags/100',
            method => 'PUT',
            code   => 404,
            result => sub {
                return +{
                    error => {
                        code    => 404,
                        message => 'Site not found',
                    }
                };
            },
        },
        {    # Invalid paramter.
            path   => '/v2/sites/1/tags/2',
            method => 'PUT',
            code   => 400,
            result => sub {
                return +{
                    error => {
                        code    => 400,
                        message => 'A resource "tag" is required.',
                    }
                };
            },
        },
        {    # Invalid parameter.
            path   => '/v2/sites/1/tags/2',
            method => 'PUT',
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A resource "tag" is required.',
                    }
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/1/tags/2',
            method    => 'PUT',
            params    => { tag => { name => 'snow' }, },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/1/tags/2',
            method => 'PUT',
            params => { tag => { name => 'snow' }, },
            restrictions => { 1 => [qw/ edit_tags rename_tag /], },
            code         => 403,
            error => 'Do not have permission to rename a tag.',
        },

        # rename_tag_for_site - normal tests
        {   path      => '/v2/sites/1/tags/2',
            method    => 'PUT',
            params    => { tag => { name => 'snow' }, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.tag',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.tag',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.tag',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.tag',
                    count => 1,
                },
            ],
            result   => sub { MT->model('tag')->load(2); },
            complete => sub {
                my $tag = MT->model('tag')->load( { name => 'rain' } );
                is( $tag, undef, 'Renamed "rain" tag.' );
            },
        },

#        # delete_tag - irregular tests
#        {    # Non-existent tag.
#            path   => '/v2/tags/100',
#            method => 'DELETE',
#            code   => 404,
#            result => sub {
#                +{  error => {
#                        code    => 404,
#                        message => 'Tag not found',
#                    },
#                };
#            },
#        },
#        {    # Not logged in.
#            path      => '/v2/tags/3',
#            method    => 'DELETE',
#            author_id => 0,
#            code      => 401,
#            error     => 'Unauthorized',
#        },
#        {    # No permissons.
#            path         => '/v2/tags/3',
#            method       => 'DELETE',
#            restrictions => { 0 => [qw/ administer /], },
#            code         => 403,
#            error        => 'Do not have permission to delete a tag.',
#        },
#
#        # delete_tag - normal tests
#        {   path     => '/v2/tags/3',
#            method   => 'DELETE',
#            complete => sub {
#                my $tag = MT->model('tag')->load(3);
#                is( $tag, undef, 'Deleted "strolling" tag.' );
#            },
#        },

        # delete_tag_for_site - irregular tests
        {    # Non-existent tag.
            path   => '/v2/sites/1/tags/100',
            method => 'DELETE',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Tag not found',
                    },
                };
            },
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/tags/4',
            method => 'DELETE',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/1/tags/4',
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions (site).
            path         => '/v2/sites/1/tags/4',
            method       => 'DELETE',
            restrictions => { 1 => [qw/ remove_tag /], },
            code         => 403,
            error        => 'Do not have permission to delete a tag.',
        },
        {    # No permissions (system).
            path         => '/v2/sites/0/tags/9',
            method       => 'DELETE',
            restrictions => { 0 => [qw/ administer /], },
            code         => 403,
            error        => 'Do not have permission to delete a tag.',
        },

        # delete_tag_for_site - normal tests
        {   path     => '/v2/sites/1/tags/4',
            method   => 'DELETE',
            complete => sub {
                my $tag = MT->model('tag')->load(4);
                is( $tag, undef, 'Deleted "anemones" tag.' );
            },
        },
    ];
}

