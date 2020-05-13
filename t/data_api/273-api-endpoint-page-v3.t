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
use MT::Test::Permission;

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app    = MT::App::DataAPI->new;
my $author = MT->model('author')->load(1);

my $website_page = $app->model('page')->new;
$website_page->set_values(
    {   blog_id   => 2,             # website
        author_id => $author->id,
        status    => 2,             # publish
    }
);
$website_page->save or die $website_page->errstr;

my $blog_page = $app->model('page')->load(20);
$blog_page->status(1);              # draft
$blog_page->save or die $blog_page->errstr;

my $blog_folder = $app->model('folder')->load( { blog_id => 1 } ) or die;
my $blog_page_2 = $app->model('page')->load(21) or die;
$blog_page_2->category_id( $blog_folder->id );
$blog_page_2->save or die $blog_page_2->errstr;

my $website = $app->model('website')->load;
my $website_asset
    = MT::Test::Permission->make_asset( blog_id => $website->id, );

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # create_page - irregular tests
        {    # No resource.
            path   => '/v3/sites/1/pages',
            method => 'POST',
            code   => 400,
            error  => 'A resource "page" is required.',
        },
        {    # Non-existent site.
            path   => '/v3/sites/5/pages',
            method => 'POST',
            params => {
                page => {
                    title => 'create-page-non-existent-site',
                    body  => 'create page on non-existent site.',
                },
            },
            code => 404,
        },
        {    # System.
            path   => '/v3/sites/0/pages',
            method => 'POST',
            params => {
                page => {
                    title => 'create-page-system',
                    body  => 'create page on system.',
                },
            },
            code => 404,
        },
        {    # Invalid folder.
            path   => '/v3/sites/1/pages',
            method => 'POST',
            params => {
                page => {
                    title  => 'create-page-with-folder',
                    text   => 'create page with folder',
                    folder => { id => 100 },
                },
            },
            code   => 400,
            result => {
                error => {
                    code    => 400,
                    message => "'folder' parameter is invalid.",
                },
            },
        },
        {    # Invalid format.
            path   => '/v3/sites/1/pages',
            method => 'POST',
            params => {
                page => {
                    title  => 'create-page-with-format',
                    text   => 'create page with format',
                    format => 'invalid',
                },
            },
            code   => 409,
            result => {
                error => {
                    code    => 409,
                    message => "Invalid format: invalid\n",
                },
            },
        },
        {    # Not logged in.
            path   => '/v3/sites/1/pages',
            method => 'POST',
            params => {
                page => {
                    title => 'create-page',
                    text  => 'create page',
                },
            },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v3/sites/1/pages',
            method => 'POST',
            params => {
                page => {
                    title => 'create-page',
                    text  => 'create page',
                },
            },
            restrictions => { 1 => [qw/ save_page /], },
            code         => 403,
            error => 'Do not have permission to create a page.',
        },
        {    # Attach non-existent asset.
            path   => '/v3/sites/1/pages',
            method => 'POST',
            params => {
                page => {
                    title  => 'test-api-attach-assets-to-page',
                    status => 'Draft',
                    assets => [ { id => 100 } ],
                },
            },
            code  => 400,
            error => "'assets' parameter is invalid.",
        },
        {    # Attach asset in other site.
            path   => '/v3/sites/1/pages',
            method => 'POST',
            params => {
                page => {
                    title  => 'test-api-attach-assets-to-page',
                    status => 'Draft',
                    assets => [ { id => $website_asset->id } ],
                },
            },
            code  => 400,
            error => "'assets' parameter is invalid.",
        },

        # create_page - normal tests
        {   path   => '/v3/sites/1/pages',
            method => 'POST',
            params => {
                page => {
                    title => 'create-page',
                    text  => 'create page',
                },
            },
            result => sub {
                $app->model('page')->load(
                    {   blog_id => 1,
                        class   => 'page',
                        title   => 'create-page',
                    }
                );
            },
        },
        {    # Attach folder.
            path   => '/v3/sites/1/pages',
            method => 'POST',
            params => {
                page => {
                    title  => 'create-page-with-folder',
                    text   => 'create page with folder',
                    folder => { id => 22 },
                },
            },
            result => sub {
                $app->model('page')->load(
                    {   blog_id => 1,
                        class   => 'page',
                        title   => 'create-page-with-folder',
                    }
                );
            },
            complete => sub {
                my $page = $app->model('page')->load(
                    {   blog_id => 1,
                        class   => 'page',
                        title   => 'create-page-with-folder',
                    }
                );
                my $folder = $page->category;
                is( $folder->id, 22, 'Attached folder.' );
            },
        },
        {    # Attach assets.
            path   => '/v3/sites/1/pages',
            method => 'POST',
            params => {
                page => {
                    title  => 'test-api-attach-assets-to-page',
                    status => 'Draft',
                    assets => [ { id => 1 } ],
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.page',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.page',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.page',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.page',
                    count => 1,
                },
            ],
            result => sub {
                require MT::Entry;
                MT->model('page')->load(
                    {   title  => 'test-api-attach-assets-to-page',
                        status => MT::Entry::HOLD(),
                    }
                );
            },
            complete => sub {
                my ( $data, $body ) = @_;
                require MT::Entry;
                my $page = MT->model('page')->load(
                    {   title  => 'test-api-attach-assets-to-page',
                        status => MT::Entry::HOLD(),
                    }
                );
                is( $page->revision, 1, 'Has created new revision' );
                my @assets = MT->model('asset')->load(
                    { class => '*' },
                    {   join => MT->model('objectasset')->join_on(
                            'asset_id',
                            {   object_ds => 'entry',
                                object_id => $page->id,
                                asset_id  => 1,
                            },
                        ),
                    }
                );
                is( scalar @assets, 1, 'Attaches an asset' );
                is( $assets[0]->id, 1, 'Attached asset ID is 1' );
            },
        },
        {    # Set format.
            path   => '/v3/sites/1/pages',
            method => 'POST',
            params => {
                page => {
                    title  => 'create-page-with-format',
                    text   => 'create page with format',
                    format => 'markdown',
                },
            },
            result => sub {
                $app->model('page')->load(
                    {   blog_id => 1,
                        class   => 'page',
                        title   => 'create-page-with-format',
                    }
                );
            },
        },
        {    # Set format 0.
            path   => '/v3/sites/1/pages',
            method => 'POST',
            params => {
                page => {
                    format => '0',
                    title  => 'create-page-with-none',
                    body   => <<'__BODY__',
1. foo
2. bar
3. baz
__BODY__
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.page',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.page',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.page',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.page',
                    count => 1,
                },
            ],
            result => sub {
                $app->model('page')
                    ->load(
                    { blog_id => 1, title => 'create-page-with-none' } );
            },
        },
        {    # Attach empty asset list.
            path   => '/v3/sites/1/pages',
            method => 'POST',
            params => {
                page => {
                    title  => 'test-api-attach-empty-asset-list-to-page',
                    status => 'Draft',
                    assets => [],
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.page',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.page',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.page',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.page',
                    count => 1,
                },
            ],
            result => sub {
                require MT::Entry;
                MT->model('page')->load(
                    {   title  => 'test-api-attach-empty-asset-list-to-page',
                        status => MT::Entry::HOLD(),
                    }
                );
            },
            complete => sub {
                my ( $data, $body ) = @_;
                require MT::Entry;
                my $page = MT->model('page')->load(
                    {   title  => 'test-api-attach-empty-asset-list-to-page',
                        status => MT::Entry::HOLD(),
                    }
                );
                is( $page->revision, 1, 'Has created new revision' );
                my @assets = MT->model('asset')->load(
                    { class => '*' },
                    {   join => MT->model('objectasset')->join_on(
                            'asset_id',
                            {   object_ds => 'entry',
                                object_id => $page->id,
                                asset_id  => 1,
                            },
                        ),
                    }
                );
                is( scalar @assets, 0, 'Attaches no asset' );
            },
        },
        {   path   => '/v3/sites/1/pages',
            method => 'POST',
            params => {
                page => {
                    title => 'create-page',
                    text  => 'create page',
                },
                publish => 1,
            },
            callbacks => [
                {   name  => 'MT::App::DataAPI::rebuild',
                    count => 1,
                },
            ],
        },
        {   path   => '/v3/sites/1/pages',
            method => 'POST',
            params => {
                page => {
                    title => 'create-page',
                    text  => 'create page',
                },
                publish => 0,
            },
            callbacks => [
                {   name  => 'MT::App::DataAPI::rebuild',
                    count => 0,
                },
            ],
        },

        # update_page - irregular tests
        {    # Non-existent page.
            path   => '/v3/sites/1/pages/100',
            method => 'PUT',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Page not found',
                    },
                };
            },
        },
        {    # Non-existent site.
            path   => '/v3/sites/5/pages/23',
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
            path   => '/v3/sites/2/pages/23',
            method => 'PUT',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Page not found',
                    },
                };
            },
        },
        {    # Other site (system).
            path   => '/v3/sites/0/pages/23',
            method => 'PUT',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Page not found',
                    },
                };
            },
        },
        {    # No resource.
            path   => '/v3/sites/1/pages/23',
            method => 'PUT',
            code   => 400,
            error  => 'A resource "page" is required.',
        },
        {    # Invalid format.
            path   => '/v3/sites/1/pages/23',
            method => 'PUT',
            params => { page => { format => 'invalid', }, },
            code   => 409,
            result => {
                error => {
                    code    => 409,
                    message => "Invalid format: invalid\n",
                },
            },
        },
        {    # Not logged in.
            path   => '/v3/sites/1/pages/23',
            method => 'PUT',
            params => {
                page => {
                    title => 'update-page',
                    body  => 'update page',
                },
            },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v3/sites/1/pages/23',
            method => 'PUT',
            params => {
                page => {
                    title => 'update-page',
                    body  => 'update page',
                },
            },
            restrictions => { 1 => [qw/ save_page /], },
            code         => 403,
            error => 'Do not have permission to update a page.',
        },

        # update_page - normal tests
        {   path   => '/v3/sites/1/pages/23',
            method => 'PUT',
            params => {
                page => {
                    title => 'update-page',
                    body  => 'update page',
                },
            },
            result => sub {
                $app->model('page')->load(23);
            },
        },
        {    # Attach folder.
            path   => '/v3/sites/1/pages/23',
            method => 'PUT',
            params => { page => { folder => { id => 21 }, }, },
            setup  => sub {
                die if $app->model('page')->load(23)->category;
            },
            result => sub {
                $app->model('page')->load(23);
            },
            complete => sub {
                my $page = $app->model('page')->load(23);
                is( $page->category->id, 21, 'Attached folder.' );
            },
        },
        {    # Detach folder.
            path   => '/v3/sites/1/pages/23',
            method => 'PUT',
            params => { page => { folder => {}, }, },
            result => sub {
                $app->model('page')->load(23);
            },
            complete => sub {
                my $page = $app->model('page')->load(23);
                is( $page->category, undef, 'Detached folder.' );
            },
        },
        {    # Update format.
            path   => '/v3/sites/1/pages/23',
            method => 'PUT',
            params => { page => { format => '__default__' }, },
            result => sub {
                $app->model('page')->load(23);
            },
            complete => sub {
                my ( $data, $body ) = @_;

                my $got      = $app->current_format->{unserialize}->($body);
                my $expected = $app->model('page')->load(23);

                isnt( $got->{body}, $expected->text );
            },
        },
        {    # Attach assets.
            path   => '/v3/sites/1/pages/23',
            method => 'PUT',
            params => { page => { assets => [ { id => 1 } ] } },
            result => sub {
                $app->model('page')->load(23);
            },
            complete => sub {
                my ( $data, $body ) = @_;
                my $page  = $app->model('page')->load(23);
                my $count = MT->model('objectasset')->count(
                    {   blog_id   => $page->blog->id,
                        object_ds => 'entry',
                        object_id => $page->id,
                    },
                );
                is( $count, 1, 'Attached asset.' );
            },
        },
        {    # Detach assets.
            path   => '/v3/sites/1/pages/23',
            method => 'PUT',
            params => { page => { assets => [] } },
            result => sub {
                $app->model('page')->load(23);
            },
            complete => sub {
                my ( $data, $body ) = @_;
                my $page  = $app->model('page')->load(23);
                my $count = MT->model('objectasset')->count(
                    {   blog_id   => $page->blog->id,
                        object_ds => 'entry',
                        object_id => $page->id,
                    },
                );
                is( $count, 0, 'Detached asset.' );
            },
        },
        {   path   => '/v3/sites/1/pages/23',
            method => 'PUT',
            params => {
                page => {
                    title => 'update-page',
                    body  => 'update page',
                },
                publish => 1,
            },
            callbacks => [
                {   name  => 'MT::App::DataAPI::rebuild',
                    count => 1,
                },
            ],
        },
        {   path   => '/v3/sites/1/pages/23',
            method => 'PUT',
            params => {
                page => {
                    title => 'update-page',
                    body  => 'update page',
                },
                publish => 0,
            },
            callbacks => [
                {   name  => 'MT::App::DataAPI::rebuild',
                    count => 0,
                },
            ],
        },
    ];
}

