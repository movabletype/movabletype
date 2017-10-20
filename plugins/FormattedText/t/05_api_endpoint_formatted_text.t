#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $ft_blog = $app->model('formatted_text')->new;
$ft_blog->set_values(
    {   blog_id     => 1,
        label       => 'formatted_text_blog',
        text        => 'formatted_text_blog_text',
        description => 'formatted_text_blog_description',
    }
);
$ft_blog->save or die $ft_blog->errstr;

my $ft_website = $app->model('formatted_text')->new;
$ft_website->set_values(
    {   blog_id     => 2,
        label       => 'formatted_text_website',
        text        => 'formatted_text_website_text',
        description => 'formatted_text_website_description',
    }
);
$ft_website->save or die $ft_website->errstr;

# test.
my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # get_formatted_text - irregular tests
        {    # Non-existent formatted text.
            path   => '/v2/sites/1/formattted_texts/100',
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/formattted_texts/' . $ft_blog->id,
            method => 'GET',
            code   => 404,
        },
        {    # Other site.
            path   => '/v2/sites/2/formattted_texts/' . $ft_blog->id,
            method => 'GET',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v2/sites/0/formattted_texts/' . $ft_blog->id,
            method => 'GET',
            code   => 404,
        },
        {    # Not logged in.
            path      => '/v2/sites/1/formatted_texts/' . $ft_blog->id,
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/1/formatted_texts/' . $ft_blog->id,
            method       => 'GET',
            restrictions => {
                1 =>
                    [qw/ edit_all_formatted_texts edit_own_formatted_texts /],
            },
            code => 403,
            error =>
                'Do not have permission to retrieve the requested formatted text.',
        },

        # get_formatted_text - normal tests
        {   path      => '/v2/sites/1/formatted_texts/' . $ft_blog->id,
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.formatted_text',
                    count => 1,
                },
            ],
            results => sub {
                $app->model('formatted_text')->load( $ft_blog->id );
            },
        },

        # create_formatted_text - irregular tests
        {    # No resource.
            path   => '/v2/sites/1/formatted_texts',
            method => 'POST',
            code   => 400,
            error  => 'A resource "formatted_text" is required.',
        },
        {    # No label.
            path   => '/v2/sites/1/formatted_texts',
            method => 'POST',
            params => { formatted_text => {}, },
            code   => 409,
            error  => "A parameter \"label\" is required.\n",
        },
        {    # Duplicated label.
            path   => '/v2/sites/1/formatted_texts',
            method => 'POST',
            params =>
                { formatted_text => { label => 'formatted_text_blog', }, },
            code => 409,
            error =>
                "The boilerplate 'formatted_text_blog' is already in use in this site.\n",
        },
        {    # System.
            path   => '/v2/sites/0/formatted_texts',
            method => 'POST',
            params => {
                formatted_text => {
                    label       => 'create-formatted-text',
                    text        => 'create-formatted-text-text',
                    description => 'create-formatted-text-description',
                },
            },
            code   => 404,
            result => sub {
                {   error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path   => '/v2/sites/1/formatted_texts',
            method => 'POST',
            params => {
                formatted_text => {
                    label       => 'create-formatted-text',
                    text        => 'create-formatted-text-text',
                    description => 'create-formatted-text-description',
                },
            },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/1/formatted_texts',
            method => 'POST',
            params => {
                formatted_text => {
                    label       => 'create-formatted-text',
                    text        => 'create-formatted-text-text',
                    description => 'create-formatted-text-description',
                },
            },
            restrictions => { 1 => [qw/ create_formatted_text /], },
            code         => 403,
            error => 'Do not have permission to create a formatted text.',
        },

        # create_formatted_text - normal tests
        {   path   => '/v2/sites/1/formatted_texts',
            method => 'POST',
            params => {
                formatted_text => {
                    label       => 'create-formatted-text',
                    text        => 'create-formatted-text-text',
                    description => 'create-formatted-text-description',
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.formatted_text',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.formatted_text',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.formatted_text',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.formatted_text',
                    count => 1,
                },
            ],
            result => sub {
                $app->model('formatted_text')->load(
                    {   blog_id => 1,
                        label   => 'create-formatted-text',
                    }
                );
            },
        },

        # list_formatted_texts - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/5/formatted_texts',
            method => 'GET',
            code   => 404,
        },
        {    # Not logged in.
            path      => '/v2/sites/1/formatted_texts',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/1/formatted_texts',
            method       => 'GET',
            restrictions => {
                1 => [qw/ access_to_formatted_text_list /],
                0 => [qw/ access_to_formatted_text_list /],
            },
            code => 403,
            error =>
                'Do not have permission to retrieve the list of formatted texts.',
        },

        # list_formatted_texts - normal tests
        {   path      => '/v2/sites/1/formatted_texts',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.formatted_text',
                    count => 2,
                },
            ],
        },
        {    # System.
            path      => '/v2/sites/0/formatted_texts',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.formatted_text',
                    count => 2,
                },
            ],
        },
        {    # search label in blog scope.
            path      => '/v2/sites/1/formatted_texts',
            method    => 'GET',
            params    => { search => 'blog', },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.formatted_text',
                    count => 2,
                },
            ],
            result => sub {
                my @fts = $app->model('formatted_text')->load(
                    { blog_id => 1 },
                    { sort    => 'created_on', direction => 'descend' },
                );

                my @greped_fts;
                for my $ft (@fts) {
                    if ( grep { $ft->$_() && $ft->$_() =~ m/blog/ }
                        qw/ label text description / )
                    {
                        push @greped_fts, $ft;
                    }
                }

                return +{
                    totalResults => scalar @greped_fts,
                    items =>
                        MT::DataAPI::Resource->from_object( \@greped_fts ),
                };
            },
        },
        {    # search label in system scope.
            path      => '/v2/sites/0/formatted_texts',
            method    => 'GET',
            params    => { search => 'blog', },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.formatted_text',
                    count => 2,
                },
            ],
            result => sub {
                my @fts
                    = $app->model('formatted_text')
                    ->load( undef,
                    { sort => 'created_on', direction => 'descend' },
                    );

                my @greped_fts;
                for my $ft (@fts) {
                    if ( grep { $ft->$_() && $ft->$_() =~ m/blog/ }
                        qw/ label text description / )
                    {
                        push @greped_fts, $ft;
                    }
                }

                return +{
                    totalResults => scalar @greped_fts,
                    items =>
                        MT::DataAPI::Resource->from_object( \@greped_fts ),
                };
            },
        },
        {    # search text in blog scope.
            path      => '/v2/sites/1/formatted_texts',
            method    => 'GET',
            params    => { search => 'blog_text', },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.formatted_text',
                    count => 2,
                },
            ],
            result => sub {
                my @fts = $app->model('formatted_text')->load(
                    { blog_id => 1 },
                    { sort    => 'created_on', direction => 'descend' },
                );

                my @greped_fts;
                for my $ft (@fts) {
                    if ( grep { $ft->$_() && $ft->$_() =~ m/blog_text/ }
                        qw/ label text description / )
                    {
                        push @greped_fts, $ft;
                    }
                }

                return +{
                    totalResults => scalar @greped_fts,
                    items =>
                        MT::DataAPI::Resource->from_object( \@greped_fts ),
                };
            },
        },
        {    # search description in blog scope.
            path      => '/v2/sites/1/formatted_texts',
            method    => 'GET',
            params    => { search => 'blog_description', },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.formatted_text',
                    count => 2,
                },
            ],
            result => sub {
                my @fts = $app->model('formatted_text')->load(
                    { blog_id => 1 },
                    { sort    => 'created_on', direction => 'descend' },
                );

                my @greped_fts;
                for my $ft (@fts) {
                    if (grep { $ft->$_() && $ft->$_() =~ m/blog_description/ }
                        qw/ label text description /
                        )
                    {
                        push @greped_fts, $ft;
                    }
                }

                return +{
                    totalResults => scalar @greped_fts,
                    items =>
                        MT::DataAPI::Resource->from_object( \@greped_fts ),
                };
            },
        },
        {    # Can sort by id.
            path      => '/v2/sites/1/formatted_texts',
            method    => 'GET',
            params    => { sortBy => 'id', sortOrder => 'ascend' },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.formatted_text',
                    count => 2,
                },
            ],
            result => sub {
                my @fts = $app->model('formatted_text')->load(
                    { blog_id => 1 },
                    { sort    => 'id', direction => 'ascend' },
                );
                return +{
                    totalResults => scalar @fts,
                    items => MT::DataAPI::Resource->from_object( \@fts ),
                };
            },
        },
        {    # Can sort by blog_id.
            path   => '/v2/sites/1/formatted_texts',
            method => 'GET',
            params => { sortBy => 'blog_id' },
        },
        {    # Can sort by created_by.
            path   => '/v2/sites/1/formatted_texts',
            method => 'GET',
            params => { sortBy => 'created_by' },
        },
        {    # Can sort by label.
            path   => '/v2/sites/1/formatted_texts',
            method => 'GET',
            params => { sortBy => 'label' },
        },
        {    # Can sort by modified_on.
            path   => '/v2/sites/1/formatted_texts',
            method => 'GET',
            params => { sortBy => 'modified_on' },
        },

        # update_formatted_text - irregular tests
        {    # Non-existent formatted text.
            path   => '/v2/sites/1/formatted_texts/10',
            method => 'PUT',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Formatted_text not found',
                    },
                };
            },
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/formatted_texts/' . $ft_blog->id,
            method => 'PUT',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # Other site.
            path   => '/v2/sites/1/formatted_texts/' . $ft_website->id,
            method => 'PUT',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Formatted_text not found',
                    },
                };
            },
        },
        {    # Other site (system).
            path   => '/v2/sites/0/formatted_texts/' . $ft_blog->id,
            method => 'PUT',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Formatted_text not found',
                    },
                };
            },
        },
        {    # No resource.
            path   => '/v2/sites/1/formatted_texts/' . $ft_blog->id,
            method => 'PUT',
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A resource "formatted_text" is required.',
                    },
                };
            },
        },
        {    # Duplicated.
            path   => '/v2/sites/1/formatted_texts/' . $ft_blog->id,
            method => 'PUT',
            params =>
                { formatted_text => { label => 'create-formatted-text', }, },
            code   => 409,
            result => sub {
                +{  error => {
                        code => 409,
                        message =>
                            "The boilerplate 'create-formatted-text' is already in use in this site.\n",
                    },
                };
            },
        },
        {    # Not logged in.
            path   => '/v2/sites/1/formatted_texts/' . $ft_blog->id,
            method => 'PUT',
            params =>
                { formatted_text => { label => 'update-formatted-text', }, },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/1/formatted_texts/' . $ft_blog->id,
            method => 'PUT',
            params =>
                { formatted_text => { label => 'update-formatted-text', }, },
            restrictions => {
                1 =>
                    [qw/ edit_all_formatted_texts edit_own_formatted_texts /],
            },
            code  => 403,
            error => 'Do not have permission to update a formatted text.',
        },

        # update_formatted_text - normal tests
        {   path   => '/v2/sites/1/formatted_texts/' . $ft_blog->id,
            method => 'PUT',
            params =>
                { formatted_text => { label => 'update-formatted-text', }, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.formatted_text',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.formatted_text',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.formatted_text',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.formatted_text',
                    count => 1,
                },
            ],
            result => sub {
                $app->model('formatted_text')->load(
                    {   id      => $ft_blog->id,
                        blog_id => 1,
                        label   => 'update-formatted-text',
                    }
                );
            },
        },

        # delete_formatted_text - irregular tests
        {    # Non-existent formatted text.
            path   => '/v2/sites/1/formatted_texts/100',
            method => 'DELETE',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/formatted_texts/' . $ft_blog->id,
            method => 'DELETE',
            code   => 404,
        },
        {    # Other site.
            path   => '/v2/sites/2/formatted_texts/' . $ft_blog->id,
            method => 'DELETE',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v2/sites/0/formatted_texts/' . $ft_blog->id,
            method => 'DELETE',
            code   => 404,
        },
        {    # Not logged in.
            path      => '/v2/sites/1/formatted_texts/' . $ft_blog->id,
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/1/formatted_texts/' . $ft_blog->id,
            method       => 'DELETE',
            restrictions => {
                1 =>
                    [qw/ edit_all_formatted_texts edit_own_formatted_texts /],
            },
            code  => 403,
            error => 'Do not have permission to delete a formatted text.',
        },

        # delete_formatted_text - normal tests
        {   path   => '/v2/sites/1/formatted_texts/' . $ft_blog->id,
            method => 'DELETE',
            setup  => sub {
                die if !$app->model('formatted_text')->load( $ft_blog->id );
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.formatted_text',
                    count => 1,
                },
            ],
            complete => sub {
                my $deleted_ft
                    = $app->model('formatted_text')->load( $ft_blog->id );
                is( $deleted_ft, undef, 'Deleted formatted text.' );
            },
        },

    ];
}
