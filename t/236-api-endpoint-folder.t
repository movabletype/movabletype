#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib extlib t/lib);

use Test::More;
use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # list_folders - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/5/folders',
            method => 'GET',
            code   => 404,
        },

        # list_folders - normal tests
        {    # Site.
            path      => '/v2/sites/1/folders',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.folder',
                    count => 2,
                },
            ],
        },
        {    # System.
            path      => '/v2/sites/0/folders',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.folder',
                    count => 2,
                },
            ],
        },

        # get_folder - irregular tests
        {    # Non-existent folder.
            path   => '/v2/sites/1/folders/100',
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/folders/22',
            method => 'GET',
            code   => 404,
        },
        {    # Other site.
            path   => '/v2/sites/2/folders/22',
            method => 'GET',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v2/sites/0/folders/22',
            method => 'GET',
            code   => 404,
        },
        {    # Not folder (category).
            path   => '/v2/sites/1/folders/3',
            method => 'GET',
            code   => 404,
        },

        # get_folder - normal tests
        {   path      => '/v2/sites/1/folders/22',
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.folder',
                    count => 1,
                },
            ],
            result => sub {
                $app->model('folder')->load(22);
            },
        },

        # create_folder - irregular tests
        {    # No resource.
            path   => '/v2/sites/1/folders',
            method => 'POST',
            code   => 400,
            error  => 'A resource "folder" is required.',
        },
        {    # No label.
            path   => '/v2/sites/1/folders',
            method => 'POST',
            params => { folder => {}, },
            code   => 409,
            error  => "A parameter \"label\" is required.\n",
        },
        {    # Label is exceeding 100 characters.
            path   => '/v2/sites/1/folders',
            method => 'POST',
            params => { folder => { label => ( '1234567890' x 11 ), }, },
            code   => 409,
            error  => "The label '"
                . ( '1234567890' x 11 )
                . "' is too long.\n",
        },
        {    # Not logged in.
            path      => '/v2/sites/1/folders',
            method    => 'POST',
            params    => { folder => { label => 'create-folder', }, },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permisions.
            path   => '/v2/sites/1/folders',
            method => 'POST',
            params => { folder => { label => 'create-folder', }, },
            restrictions => { 1 => [qw/ save_folder /], },
            code         => 403,
            error => 'Do not have permission to create a folder.',
        },

        # create_folder - normal tests
        {   path      => '/v2/sites/1/folders',
            method    => 'POST',
            params    => { folder => { label => 'create-folder', }, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.folder',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.folder',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.folder',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.folder',
                    count => 1,
                },
            ],
            result => sub {
                $app->model('folder')->load(
                    {   blog_id => 1,
                        label   => 'create-folder',
                    }
                );
            },
        },

        # update_folder - irregular tests
        {    # Non-existent folder.
            path   => '/v2/sites/1/folders/500',
            method => 'PUT',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/folders/22',
            method => 'PUT',
            code   => 404,
        },
        {    # Other site.
            path   => '/v2/sites/2/folders/22',
            method => 'PUT',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v2/sites/0/folders/22',
            method => 'PUT',
            code   => 404,
        },
        {    # Not folder (category).
            path   => '/v2/sites/1/folders/3',
            method => 'PUT',
            code   => 404,
        },
        {    # No resource.
            path   => '/v2/sites/1/folders/22',
            method => 'PUT',
            code   => 400,
            return => 'A resource "folder" is required.',
        },
        {    # Not logged in.
            path      => '/v2/sites/1/folders/22',
            method    => 'PUT',
            params    => { folder => { label => 'update-folder', }, },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/1/folders/22',
            method => 'PUT',
            params => { folder => { label => 'update-folder', }, },
            restrictions => { 1 => [qw/ save_folder /], },
            code         => 403,
            error => 'Do not have permission to update a folder.',
        },

        # update_folder - normal tests
        {   path   => '/v2/sites/1/folders/22',
            method => 'PUT',
            params => { folder => { label => 'update-folder', }, },
            result => sub {
                $app->model('folder')->load(
                    {   id      => 22,
                        blog_id => 1,
                        label   => 'update-folder',
                        class   => 'folder',
                    }
                );
            },
        },

        # permutate_folders - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/5/folders/permutate',
            method => 'POST',
            code   => 404,
        },
        {    # System.
            path   => '/v2/sites/0/folders/permutate',
            method => 'POST',
            code   => 404,
        },
        {    # No folders parameter.
            path   => '/v2/sites/1/folders/permutate',
            method => 'POST',
            code   => 400,
            result => sub {
                return +{
                    error => {
                        code    => 400,
                        message => 'A parameter "folders" is required.',
                    },
                };
            },
        },
        {    # Insufficient folders.
            path   => '/v2/sites/1/folders/permutate',
            method => 'POST',
            params =>
                { folders => [ map { +{ id => $_ } } qw/ 23 22 21 / ], },
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A parameter "folders" is invalid.',
                    },
                };
            },
        },
        {    # Not logged in.
            path   => '/v2/sites/1/folders/permutate',
            method => 'POST',
            params =>
                { folders => [ map { +{ id => $_ } } qw/ 23 22 21 20 / ], },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/1/folders/permutate',
            method => 'POST',
            params =>
                { folders => [ map { +{ id => $_ } } qw/ 23 22 21 20 / ], },
            restrictions => { 1 => [qw/ save_folder /], },
            code         => 403,
            error => 'Do not have permission to permutate folders.',
        },

        # permutate_folder - normal tests
        {   path   => '/v2/sites/1/folders/permutate',
            method => 'POST',
            params =>
                { folders => [ map { +{ id => $_ } } qw/ 23 22 21 20 / ], },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_post_bulk_save.folder',
                    count => 1,
                },
            ],
            result => sub {
                my $site = $app->model('blog')->load(1);
                my @folder_order = split ',', $site->folder_order;

                $app->user($author);
                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};

                return MT::DataAPI::Resource->from_object(
                    [ map { $app->model('folder')->load($_) } @folder_order ]
                );
            },
        },

        # delete_folder - irregular tests
        {    # Non-existent folder.
            path   => '/v2/sites/1/folders/100',
            method => 'DELETE',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/folders/22',
            method => 'DELETE',
            code   => 404,
        },
        {    # Other site.
            path   => '/v2/sites/2/folders/22',
            method => 'DELETE',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v2/sites/0/folders/22',
            method => 'DELETE',
            code   => 404,
        },
        {    # Not folder (category).
            path   => '/v2/sites/1/folders/3',
            method => 'DELETE',
            code   => 404,
        },
        {    # Not logged in.
            path      => '/v2/sites/1/folders/22',
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/1/folders/22',
            method       => 'DELETE',
            restrictions => { 1 => [qw/ delete_folder /], },
            code         => 403,
            error        => 'Do not have permission to delete a folder.',
        },

        # delete_folder - normal tests
        {   path      => '/v2/sites/1/folders/22',
            method    => 'DELETE',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.folder',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_delete.folder',
                    count => 1,
                },
            ],
            setup => sub {
                die if !$app->model('folder')->load(22);
            },
            complete => sub {
                my $folder = $app->model('folder')->load(22);
                is( $folder, undef, 'Deleted folder.' );
            },
        },

        # list_parent_folders - normal tests
        {   setup => sub {
                my $folder = $app->model('folder')->load(23);
                $folder->parent(21);
                $folder->save or die $folder->errstr;
            },
            path   => '/v2/sites/1/folders/23/parents',
            method => 'GET',
        },

        # list_sibling_folders - normal tests
        {   setup => sub {
                my $folder = $app->model('folder')->load(20);
                $folder->parent(21);
                $folder->save or die $folder->errstr;
            },
            path   => '/v2/sites/1/folders/23/siblings',
            method => 'GET',
        },

        # list_child_folders - normal tests
        {   path   => '/v2/sites/1/folders/21/children',
            method => 'GET',
        },
    ];
}

