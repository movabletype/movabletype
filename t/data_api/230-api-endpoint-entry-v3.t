#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::DataAPI;
use MT::Test::Permission;

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $blog    = $app->model('blog')->load;
my $website = $app->model('website')->load;

my $website_category
    = MT::Test::Permission->make_category( blog_id => $website->id, );
my $blog_folder = $app->model('folder')->load( { blog_id => $blog->id, } );

my $website_asset
    = MT::Test::Permission->make_asset( blog_id => $website->id, );

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # create_entry - irregular tests.
        {    # Attach non-existent category.
            path   => '/v3/sites/1/entries',
            method => 'POST',
            params => {
                entry => {
                    title      => 'test-api-attach-categories-to-entry',
                    status     => 'Draft',
                    categories => [ { id => 100 } ],
                },
            },
            code  => 400,
            error => "'categories' parameter is invalid.",
        },
        {    # Attach category of other site.
            path   => '/v3/sites/1/entries',
            method => 'POST',
            params => {
                entry => {
                    title      => 'test-api-attach-categories-to-entry',
                    status     => 'Draft',
                    categories => [ { id => $website_category->id } ],
                },
            },
            code  => 400,
            error => "'categories' parameter is invalid.",
        },
        {    # Attach folder.
            path   => '/v3/sites/1/entries',
            method => 'POST',
            params => {
                entry => {
                    title      => 'test-api-attach-categories-to-entry',
                    status     => 'Draft',
                    categories => [ { id => $blog_folder->id } ],
                },
            },
            code  => 400,
            error => "'categories' parameter is invalid.",
        },
        {    # Attach non-existent asset.
            path   => '/v3/sites/1/entries',
            method => 'POST',
            params => {
                entry => {
                    title  => 'test-api-attach-assets-to-entry',
                    status => 'Draft',
                    assets => [ { id => 100 } ],
                },
            },
            code  => 400,
            error => "'assets' parameter is invalid.",
        },
        {    # Attach asset in other site.
            path   => '/v3/sites/1/entries',
            method => 'POST',
            params => {
                entry => {
                    title  => 'test-api-attach-assets-to-entry',
                    status => 'Draft',
                    assets => [ { id => $website_asset->id } ],
                },
            },
            code  => 400,
            error => "'assets' parameter is invalid.",
        },
        {    # Invalid format.
            path   => '/v3/sites/1/entries',
            method => 'POST',
            params => {
                entry => {
                    format => 'invalid',
                    title  => 'create-entry-with-invalid-format',
                    body   => <<'__BODY__',
1. foo
2. bar
3. baz
__BODY__
                },
            },
            code  => 409,
            error => "Invalid format: invalid\n",
        },

        # create_entry - normal tests.
        {    # Attach category.
            path   => '/v3/sites/1/entries',
            method => 'POST',
            params => {
                entry => {
                    title      => 'test-api-attach-categories-to-entry',
                    status     => 'Draft',
                    categories => [ { id => 2 }, { id => 1 }, { id => 3 } ],
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
                    count => 1,
                },
            ],
            result => sub {
                require MT::Entry;
                MT->model('entry')->load(
                    {   title  => 'test-api-attach-categories-to-entry',
                        status => MT::Entry::HOLD(),
                    }
                );
            },
            complete => sub {
                my ( $data, $body ) = @_;

                require MT::Entry;
                my $entry = MT->model('entry')->load(
                    {   title  => 'test-api-attach-categories-to-entry',
                        status => MT::Entry::HOLD(),
                    }
                );
                is( $entry->revision, 1, 'Has created new revision' );

                my $got = $app->current_format->{unserialize}->($body);
                is( scalar @{ $got->{categories} }, 3,
                    'Attaches 3 category' );
                is( $got->{categories}->[0]->{id},
                    2, 'Primary category ID is 2' );
                is_deeply( [ map { $_->{id} } @{ $got->{categories} } ],
                    [qw/ 2 1 3 /], 'Attached category IDs are "2 1 3"' );
            },
        },
        {    # Attach assets.
            path   => '/v3/sites/1/entries',
            method => 'POST',
            params => {
                entry => {
                    title  => 'test-api-attach-assets-to-entry',
                    status => 'Draft',
                    assets => [ { id => 1 } ],
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
                    count => 1,
                },
            ],
            result => sub {
                require MT::Entry;
                MT->model('entry')->load(
                    {   title  => 'test-api-attach-assets-to-entry',
                        status => MT::Entry::HOLD(),
                    }
                );
            },
            complete => sub {
                my ( $data, $body ) = @_;
                require MT::Entry;
                my $entry = MT->model('entry')->load(
                    {   title  => 'test-api-attach-assets-to-entry',
                        status => MT::Entry::HOLD(),
                    }
                );
                is( $entry->revision, 1, 'Has created new revision' );
                my @assets = MT->model('asset')->load(
                    { class => '*' },
                    {   join => MT->model('objectasset')->join_on(
                            'asset_id',
                            {   object_ds => 'entry',
                                object_id => $entry->id,
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
            path   => '/v3/sites/1/entries',
            method => 'POST',
            params => {
                entry => {
                    format => 'markdown',
                    title  => 'create-entry-with-markdown',
                    body   => <<'__BODY__',
1. foo
2. bar
3. baz
__BODY__
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
                    count => 1,
                },
            ],
            result => sub {
                $app->model('entry')
                    ->load(
                    { blog_id => 1, title => 'create-entry-with-markdown' } );
            },
        },
        {    # Set format 0.
            path   => '/v3/sites/1/entries',
            method => 'POST',
            params => {
                entry => {
                    format => '0',
                    title  => 'create-entry-with-none',
                    body   => <<'__BODY__',
1. foo
2. bar
3. baz
__BODY__
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
                    count => 1,
                },
            ],
            result => sub {
                $app->model('entry')
                    ->load(
                    { blog_id => 1, title => 'create-entry-with-none' } );
            },
        },
        {    # Attach empty category list.
            path   => '/v3/sites/1/entries',
            method => 'POST',
            params => {
                entry => {
                    title      => 'test-api-attach-empty-category-list-to-entry',
                    status     => 'Draft',
                    categories => [],
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
                    count => 1,
                },
            ],
            result => sub {
                require MT::Entry;
                MT->model('entry')->load(
                    {   title  => 'test-api-attach-empty-category-list-to-entry',
                        status => MT::Entry::HOLD(),
                    }
                );
            },
            complete => sub {
                my ( $data, $body ) = @_;

                require MT::Entry;
                my $entry = MT->model('entry')->load(
                    {   title  => 'test-api-attach-empty-category-list-to-entry',
                        status => MT::Entry::HOLD(),
                    }
                );
                is( $entry->revision, 1, 'Has created new revision' );

                my $got = $app->current_format->{unserialize}->($body);
                is( scalar @{ $got->{categories} }, 0,
                    'Attaches no category' );
            },
        },
        {    # Attach empty asset list.
            path   => '/v3/sites/1/entries',
            method => 'POST',
            params => {
                entry => {
                    title  => 'test-api-attach-empty-asset-list-to-entry',
                    status => 'Draft',
                    assets => [],
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
                    count => 1,
                },
            ],
            result => sub {
                require MT::Entry;
                MT->model('entry')->load(
                    {   title  => 'test-api-attach-empty-asset-list-to-entry',
                        status => MT::Entry::HOLD(),
                    }
                );
            },
            complete => sub {
                my ( $data, $body ) = @_;
                require MT::Entry;
                my $entry = MT->model('entry')->load(
                    {   title  => 'test-api-attach-empty-asset-list-to-entry',
                        status => MT::Entry::HOLD(),
                    }
                );
                is( $entry->revision, 1, 'Has created new revision' );
                my @assets = MT->model('asset')->load(
                    { class => '*' },
                    {   join => MT->model('objectasset')->join_on(
                            'asset_id',
                            {   object_ds => 'entry',
                                object_id => $entry->id,
                                asset_id  => 1,
                            },
                        ),
                    }
                );
                is( scalar @assets, 0, 'Attaches no asset' );
            },
        },
        {   # Publish
            path   => '/v3/sites/1/entries',
            method => 'POST',
            params => {
                entry => {
                    title      => 'test-api-attach-categories-to-entry',
                    status     => 'Publish',
                    categories => [ { id => 2 }, { id => 1 }, { id => 3 } ],
                },
                publish => 1,
            },
            callbacks => [
                {   name  => 'MT::App::DataAPI::rebuild',
                    count => 1,
                },
            ],
        },
        {   # No publish
            path   => '/v3/sites/1/entries',
            method => 'POST',
            params => {
                entry => {
                    title      => 'test-api-attach-categories-to-entry',
                    status     => 'Publish',
                    categories => [ { id => 2 }, { id => 1 }, { id => 3 } ],
                },
                publish => 0,
            },
            callbacks => [
                {   name  => 'MT::App::DataAPI::rebuild',
                    count => 0,
                },
            ],
        },

        # update_entry - irregular tests.
        {    # Attach non-existent category
            path   => '/v3/sites/1/entries/2',
            method => 'PUT',
            params => { entry => { categories => [ id => 200 ] } },
            code   => 400,
            error  => "'categories' parameter is invalid.",
        },
        {    # Attach category in other site.
            path   => '/v3/sites/1/entries/2',
            method => 'PUT',
            params => {
                entry => { categories => [ id => $website_category->id ] }
            },
            code  => 400,
            error => "'categories' parameter is invalid.",
        },
        {    # Attach folder.
            path   => '/v3/sites/1/entries/2',
            method => 'PUT',
            params => { entry => { categories => [ id => 20 ] } },
            code   => 400,
            error  => "'categories' parameter is invalid.",
        },

        # update_entry - normal tests.
        {    # Attach categories.
            path   => '/v3/sites/1/entries/2',
            method => 'PUT',
            params => {
                entry => {
                    title      => 'test-api-update-categories',
                    categories => [ { id => 3 }, { id => 2 }, { id => 1 } ]
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('entry')->load(
                    {   id    => 2,
                        title => 'test-api-update-categories',
                    }
                );
            },
            complete => sub {
                my ( $data, $body ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( scalar @{ $got->{categories} },
                    3, 'Entry has 3 category' );
                is( $got->{categories}->[0]->{id},
                    3, 'Primary category ID is 3' );
                is_deeply( [ map { $_->{id} } @{ $got->{categories} } ],
                    [qw/ 3 2 1 /], "Entry's categoy Ids are \"3 2 1\"" );
            },
        },
        {    # Update attached categories.
            path   => '/v3/sites/1/entries/2',
            method => 'PUT',
            params =>
                { entry => { categories => [ { id => 2 }, { id => 3 } ] }, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('entry')->load(
                    {   id    => 2,
                        title => 'test-api-update-categories',
                    }
                );
            },
            complete => sub {
                my ( $data, $body ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( scalar @{ $got->{categories} },
                    2, 'Entry has 2 category' );
                is( $got->{categories}->[0]->{id},
                    2, 'Primary category ID is 2' );
                is_deeply( [ map { $_->{id} } @{ $got->{categories} } ],
                    [qw/ 2 3 /], "Entry's categoy Ids are \"2 3\"" );
            },
        },
        {    # Detatch categories.
            path   => '/v3/sites/1/entries/2',
            method => 'PUT',
            params =>
                { entry => { categories => [] }, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('entry')->load(
                    {   id    => 2,
                        title => 'test-api-update-categories',
                    }
                );
            },
            complete => sub {
                my ( $data, $body ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( scalar @{ $got->{categories} },
                    0, 'Entry has no category' );
            },
        },
        {    # Attach assets.
            path   => '/v3/sites/1/entries/2',
            method => 'PUT',
            params => {
                entry => {
                    title  => 'test-api-update-assets',
                    assets => [ { id => 1 }, { id => 2 } ],
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('entry')->load(
                    {   id    => 2,
                        title => 'test-api-update-assets',
                    }
                );
            },
            complete => sub {
                my ( $data, $body ) = @_;
                my $entry = MT->model('entry')->load(2);
                my @oa    = MT->model('objectasset')->load(
                    {   object_ds => 'entry',
                        object_id => $entry->id,
                    }
                );
                is( scalar @oa, 2, 'Entry has 2 assets' );
            },
        },
        {    # Detach assets.
            path   => '/v3/sites/1/entries/2',
            method => 'PUT',
            params => {
                entry => {
                    title  => 'test-api-update-assets',
                    assets => [],
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('entry')->load(
                    {   id    => 2,
                        title => 'test-api-update-assets',
                    }
                );
            },
            complete => sub {
                my ( $data, $body ) = @_;
                my $entry = MT->model('entry')->load(2);
                my @oa    = MT->model('objectasset')->load(
                    {   object_ds => 'entry',
                        object_id => $entry->id,
                    }
                );
                is( scalar @oa, 0, 'Entry has no asset' );
            },
        },
        {    # Update attached assets.
            path   => '/v3/sites/1/entries/2',
            method => 'PUT',
            params => {
                entry => {
                    title  => 'test-api-update-assets',
                    assets => [ { id => 2 } ],
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('entry')->load(
                    {   id    => 2,
                        title => 'test-api-update-assets',
                    }
                );
            },
            complete => sub {
                my ( $data, $body ) = @_;
                my $entry = MT->model('entry')->load(2);
                my @oa    = MT->model('objectasset')->load(
                    {   object_ds => 'entry',
                        object_id => $entry->id,
                    }
                );
                is( scalar @oa, 1, 'Entry has 1 asset' );
            },
        },
        {    # Update format.
            path   => '/v3/sites/1/entries/2',
            method => 'PUT',
            params => {
                entry => {
                    format => 'markdown',
                    body   => <<'__BODY__',
1. foo
2. bar
3. baz
__BODY__
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
                    count => 1,
                },
            ],
            result   => sub { $app->model('entry')->load(2) },
            complete => sub {
                my ( $data, $body ) = @_;

                my $got      = $app->current_format->{unserialize}->($body);
                my $expected = $app->model('entry')->load(2);

                isnt( $got->{body}, $expected->text );
            },
        },
        {    # Remove attached categories.
            path      => '/v3/sites/1/entries/2',
            method    => 'PUT',
            params    => { entry => { categories => [] }, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
                    count => 1,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( scalar @{ $got->{categories} },
                    0, 'Entry has no category' );
            },
        },
        {   # Publish
            path   => '/v3/sites/1/entries/2',
            method => 'PUT',
            params => {
                entry => {
                    title      => 'test-api-update-categories',
                    categories => [ { id => 3 }, { id => 2 }, { id => 1 } ],
                    status     => 'Publish',
                },
                publish => 1,
            },
            callbacks => [
                {   name  => 'MT::App::DataAPI::rebuild',
                    count => 1,
                },
            ],
        },
        {   # No publish
            path   => '/v3/sites/1/entries/2',
            method => 'PUT',
            params => {
                entry => {
                    title      => 'test-api-update-categories',
                    categories => [ { id => 3 }, { id => 2 }, { id => 1 } ],
                    status     => 'Publish',
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

