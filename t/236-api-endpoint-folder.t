#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::DataAPI;
use MT::Test::Permission;

$test_env->prepare_fixture('db_data');

my $category_set = MT::Test::Permission->make_category_set( blog_id => 1 );
my $category_set_category = MT::Test::Permission->make_category(
    blog_id         => $category_set->blog_id,
    category_set_id => $category_set->id,
);

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
        {    # category of category set.
            path   => '/v2/sites/1/folders/' . $category_set_category->id,
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
            complete => sub {
                my ( $data, $body ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( $got->{path},
                    'http://narnia.na/nana/download/nightly',
                    'path is "http://narnia.na/nana/download/nightly"'
                );
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
            error        => 'Do not have permission to create a folder.',
        },

        # create_folder - normal tests
        {   path   => '/v2/sites/1/folders',
            method => 'POST',
            params => {
                folder => {
                    label           => 'create-folder',
                    category_set_id => $category_set->id,
                },
            },
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
                    {   blog_id         => 1,
                        label           => 'create-folder',
                        category_set_id => 0,
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
            error        => 'Do not have permission to update a folder.',
        },
        {    # category of category set.
            path   => '/v2/sites/1/folders/' . $category_set_category->id,
            method => 'PUT',
            params => {
                folder => { label => 'update-folder-with-category-set-id', },
            },
            code => 404,
        },

        # update_folder - normal tests
        {   path   => '/v2/sites/1/folders/22',
            method => 'PUT',
            params => {
                folder => {
                    label           => 'update-folder',
                    category_set_id => $category_set->id
                },
            },
            result => sub {
                $app->model('folder')->load(
                    {   id              => 22,
                        blog_id         => 1,
                        label           => 'update-folder',
                        class           => 'folder',
                        category_set_id => 0,
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
            params => sub {
                my @folders = $app->model('folder')->load( { blog_id => 1 },
                    { sort => 'id', direction => 'descend' } );
                my @folder_ids = map { { id => $_->id } } @folders;
                pop @folder_ids;
                { folders => \@folder_ids };
            },
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
            params => sub {
                my @folders = $app->model('folder')->load( { blog_id => 1 },
                    { sort => 'id', direction => 'descend' } );
                my @folder_ids = map { { id => $_->id } } @folders;
                { folders => \@folder_ids };
            },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/1/folders/permutate',
            method => 'POST',
            params => sub {
                my @folders = $app->model('folder')->load( { blog_id => 1 },
                    { sort => 'id', direction => 'descend' } );
                my @folder_ids = map { { id => $_->id } } @folders;
                { folders => \@folder_ids };
            },
            restrictions => { 1 => [qw/ save_folder /], },
            code         => 403,
            error        => 'Do not have permission to permutate folders.',
        },
        {    # category of category set.
            path   => '/v2/sites/1/folders/permutate',
            method => 'POST',
            params => sub {
                my @cats
                    = $app->model('category')
                    ->load(
                    { blog_id => 1,    category_set_id => $category_set->id },
                    { sort    => 'id', direction       => 'descend' } );
                my @cat_ids = map { { id => $_->id } } @cats;
                { folders => \@cat_ids };
            },
            code => 400,
        },

        # permutate_folder - normal tests
        {   path   => '/v2/sites/1/folders/permutate',
            method => 'POST',
            params => sub {
                my @folders = $app->model('folder')->load( { blog_id => 1 },
                    { sort => 'id', direction => 'descend' } );
                my @folder_ids = map { { id => $_->id } } @folders;
                { folders => \@folder_ids };
            },
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
        {    # category of category set.
            path   => '/v2/sites/1/folders/' . $category_set_category->id,
            method => 'DELETE',
            code   => 404,
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
                my $parent_folder
                    = MT::Test::Permission->make_folder( blog_id => 1 );
                $parent_folder->id(30);
                $parent_folder->save or die $parent_folder->errstr;

                my $child_folder = MT::Test::Permission->make_folder(
                    blog_id => 1,
                    parent  => $parent_folder->id,
                );
                $child_folder->id(31);
                $child_folder->save or die $child_folder->errstr;
            },
            path     => '/v2/sites/1/folders/31/parents',
            method   => 'GET',
            complete => sub {
                my ( $data, $body, $headers ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( $got->{totalResults}, 1,  'totalResults 1' );
                is( $got->{items}[0]{id}, 30, 'id 30' );
            },
        },

        # list_sibling_folders - normal tests
        {   setup => sub {
                my $sibling_folder = MT::Test::Permission->make_folder(
                    blog_id => 1,
                    parent  => 30,
                );
                $sibling_folder->id(32);
                $sibling_folder->save or die $sibling_folder->errstr;
            },
            path     => '/v2/sites/1/folders/31/siblings',
            method   => 'GET',
            complete => sub {
                my ( $data, $body, $headers ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( $got->{totalResults}, 1,  'totalResults 1' );
                is( $got->{items}[0]{id}, 32, 'id 32' );
            },
        },

        # list_child_folders - normal tests
        {   path     => '/v2/sites/1/folders/30/children',
            method   => 'GET',
            complete => sub {
                my ( $data, $body, $headers ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( $got->{totalResults}, 2, 'totalResults 2' );
                my @got_ids
                    = sort ( $got->{items}[0]{id}, $got->{items}[1]{id} );
                my @expected_ids = ( 31, 32 );
                is_deeply( \@got_ids, \@expected_ids, 'id 31, 32' );
            },
        },
    ];
}

