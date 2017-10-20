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

# preparation.
my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

# test.
my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # list_roles - invalid tests.
        {    # Not logged in.
            path      => '/v2/roles',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/roles',
            method       => 'GET',
            restrictions => { 0 => [qw/ access_to_role_list /], },
            code         => 403,
            error => 'Do not have permission to retrieve the list of roles.',
        },

        # list_roles - normal tests
        {   path      => '/v2/roles',
            method    => 'GET',
            setup     => sub { $app->user($author) },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.role',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = $app->current_format->{unserialize}->($body);
                my @roles
                    = MT->model('role')->load( undef, { sort => 'name' } );

                is( $result->{totalResults},
                    scalar @roles,
                    'totalResults is "' . $result->{totalResults} . '"'
                );

                my @result_ids   = map { $_->{id} } @{ $result->{items} };
                my @expected_ids = map { $_->id } @roles;
                is_deeply( \@result_ids, \@expected_ids,
                    'IDs of items are "' . "@result_ids" . '"' );
            },
        },
        {    # Search name.
            path      => '/v2/roles',
            method    => 'GET',
            params    => { search => 'Designer', },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.role',
                    count => 2,
                },
            ],
            result => sub {
                my @roles = $app->model('role')->load(
                    { name => { like => '%Designer%' } },
                    { sort => 'name', direction => 'ascend' },
                );

                $app->user($author);

                return +{
                    totalResults => 2,
                    items => MT::DataAPI::Resource->from_object( \@roles ),
                };
            },
        },
        {    # Search description.
            path      => '/v2/roles',
            method    => 'GET',
            params    => { search => 'administer', },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.role',
                    count => 2,
                },
            ],
            result => sub {
                my @roles = $app->model('role')->load(
                    { description => { like => '%administer%' } },
                    { sort => 'name', direction => 'ascend' },
                );

                $app->user($author);

                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( \@roles ),
                };
            },
        },
        {    # Can sort by created_by.
            path   => '/v2/roles',
            method => 'GET',
            params => { sortBy => 'created_by' },
        },
        {    # Can sort by modified_by.
            path   => '/v2/roles',
            method => 'GET',
            params => { sortBy => 'modified_by' },
        },
        {    # Can sort by created_on.
            path   => '/v2/roles',
            method => 'GET',
            params => { sortBy => 'created_on' },
        },
        {    # Can sort by modified_on.
            path   => '/v2/roles',
            method => 'GET',
            params => { sortBy => 'modified_on' },
        },

        # create_role - irregular tests
        {    # No resource.
            path   => '/v2/roles',
            method => 'POST',
            code   => 400,
            error  => 'A resource "role" is required.',
        },
        {    # No name.
            path   => '/v2/roles',
            method => 'POST',
            params => { role => {} },
            code   => 409,
            error  => "A parameter \"name\" is required.\n",
        },
        {    # Same name role exists.
            path   => '/v2/roles',
            method => 'POST',
            params => { role => { name => 'Moderator' } },
            code   => 409,
            error  => "Another role already exists by that name.\n",
        },
        {    # No permission in the request parameters.
            path   => '/v2/roles',
            method => 'POST',
            params =>
                { role => { name => 'create_role_without_permissions', }, },
            code  => 409,
            error => "You cannot define a role without permissions.\n",
        },
        {    # Not logged in.
            path   => '/v2/roles',
            method => 'POST',
            params => {
                role =>
                    { name => 'create_role', permissions => ['create_post'] }
            },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions to do this method.
            path   => '/v2/roles',
            method => 'POST',
            params => {
                role =>
                    { name => 'create_role', permissions => ['create_post'] }
            },
            restrictions => { 0 => [qw/ save_role /], },
            code         => 403,
            error => 'Do not have permission to create a role.',
        },

        # create_role - normal tests
        {   path   => '/v2/roles',
            method => 'POST',
            params => {
                role =>
                    { name => 'create_role', permissions => ['create_post'] }
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.role',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.role',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.role',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.role',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('role')->load( { name => 'create_role' } );
            },
        },

        # get_role - irregular tests
        {    # Non-existent role.
            path   => '/v2/roles/20',
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Role not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/roles/10',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/roles/10',
            method       => 'GET',
            restrictions => { 0 => [qw/ edit_role /], },
            code         => 403,
            error => 'Do not have permission to retrieve the requested role.',
        },

        # get_role - normal tests
        {   path   => '/v2/roles/10',
            method => 'GET',
            result => sub { MT->model('role')->load(10) },
        },

        # update_role - irregular tests
        {
            # non-existent role.
            path   => '/v2/roles/20',
            method => 'PUT',
            params => {
                role => {
                    name        => 'update_non_existent_role',
                    permissions => ['edit_templates']
                }
            },
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Role not found',
                    },
                };
            },
        },
        {
            # No resource.
            path   => '/v2/roles/10',
            method => 'PUT',
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A resource "role" is required.',
                    },
                };
            },
        },
        {    # Not logged in.
            path   => '/v2/roles/10',
            method => 'PUT',
            params => {
                role => {
                    name        => 'update_role',
                    permissions => ['edit_templates']
                }
            },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/roles/10',
            method => 'PUT',
            params => {
                role => {
                    name        => 'update_role',
                    permissions => ['edit_templates']
                }
            },
            restrictions => { 0 => [qw/ save_role /], },
            code         => 403,
            error => 'Do not have permission to update a role.',
        },

        # update_role - normal tests
        {   path   => '/v2/roles/10',
            method => 'PUT',
            params => {
                role => {
                    name        => 'update_role',
                    permissions => ['edit_templates']
                }
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.role',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.role',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.role',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.role',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('role')
                    ->load( { id => 10, name => 'update_role' } );
            },
        },

        # delete_role - irregular tests
        {
            # non-existent role.
            path   => '/v2/roles/20',
            method => 'DELETE',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Role not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/roles/10',
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/roles/10',
            method       => 'DELETE',
            restrictions => { 0 => [qw/ delete_role /], },
            code         => 403,
            error        => 'Do not have permission to delete a role.',
        },

        # delete_role - normal tests
        {   path      => '/v2/roles/10',
            method    => 'DELETE',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.role',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_delete.role',
                    count => 1,
                },
            ],
            complete => sub {
                my $deleted = MT->model('role')->load(10);
                is( $deleted, undef, 'deleted' );
            },
        },
    ];
}
