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
        {   path      => '/v1/sites/1/entries',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.entry',
                    count => 2,
                },
            ],
        },
        {   path   => '/v1/sites/1/entries',
            method => 'POST',
            params => {
                entry => {
                    title  => 'test-api-permission-entry',
                    status => 'Draft',
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
                    {   title  => 'test-api-permission-entry',
                        status => MT::Entry::HOLD(),
                    }
                );
            },
            complete => sub {
                my ( $data, $body ) = @_;
                require MT::Entry;
                my $entry = MT->model('entry')->load(
                    {   title  => 'test-api-permission-entry',
                        status => MT::Entry::HOLD(),
                    }
                );
                is( $entry->revision, 1, 'Has created new revision' );
            },
        },
        {   path   => '/v1/sites/1/entries/0',
            method => 'GET',
            code   => 404,
        },
        {   path      => '/v1/sites/1/entries/1',
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.entry',
                    count => 1,
                },
            ],
        },
        {   path   => '/v1/sites/1/entries/1',
            method => 'PUT',
            setup  => sub {
                my ($data) = @_;
                $data->{_revision}
                    = MT->model('entry')->load(1)->revision || 0;
            },
            params => {
                entry => { title => 'update-test-api-permission-entry', },
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
                    {   id    => 1,
                        title => 'update-test-api-permission-entry',
                    }
                );
            },
            complete => sub {
                my ( $data, $body ) = @_;
                is( MT->model('entry')->load(1)->revision
                        - $data->{_revision},
                    1,
                    'Bumped-up revision number'
                );
            },
        },
        {   path     => '/v1/sites/1/entries/1',
            method   => 'PUT',
            params   => { entry => { tags => [qw(a)] }, },
            complete => sub {
                is_deeply( [ MT->model('entry')->load(1)->tags ],
                    [qw(a)], "Entry's tag is updated" );
            },
        },
        {   path     => '/v1/sites/1/entries/1',
            method   => 'PUT',
            params   => { entry => { tags => [qw(a b)] }, },
            complete => sub {
                is_deeply( [ MT->model('entry')->load(1)->tags ],
                    [qw(a b)], "Entry's tag is added" );
            },
        },
        {   path     => '/v1/sites/1/entries/1',
            method   => 'PUT',
            params   => { entry => { tags => [] }, },
            complete => sub {
                is_deeply( [ MT->model('entry')->load(1)->tags ],
                    [], "Entry's tag is removed" );
            },
        },
        {   path      => '/v1/sites/1/entries/1',
            method    => 'DELETE',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_delete.entry',
                    count => 1,
                },
            ],
            complete => sub {
                my $deleted = MT->model('entry')->load(1);
                is( $deleted, undef, 'deleted' );

                my $count = MT->model('log')->count( { level => 4 } ); # ERROR
                is( $count, 0, 'No error occurs.' );
                MT->model('log')->remove( { level => 4 } );
            },
        },
        {   path      => '/v1/sites/2/entries',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.entry',
                    count => 1,
                },
            ],
        },

        # version 2

        # create_entry - irregular tests.
        {    # Attach non-existent category.
            path   => '/v2/sites/1/entries',
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
            path   => '/v2/sites/1/entries',
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
            path   => '/v2/sites/1/entries',
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
            path   => '/v2/sites/1/entries',
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
            path   => '/v2/sites/1/entries',
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
            path   => '/v2/sites/1/entries',
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
            path   => '/v2/sites/1/entries',
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
            path   => '/v2/sites/1/entries',
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
            path   => '/v2/sites/1/entries',
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
            path   => '/v2/sites/1/entries',
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
            path   => '/v2/sites/1/entries',
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
            path   => '/v2/sites/1/entries',
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

        # update_entry - irregular tests.
        {    # Attach non-existent category
            path   => '/v2/sites/1/entries/2',
            method => 'PUT',
            params => { entry => { categories => [ id => 200 ] } },
            code   => 400,
            error  => "'categories' parameter is invalid.",
        },
        {    # Attach category in other site.
            path   => '/v2/sites/1/entries/2',
            method => 'PUT',
            params => {
                entry => { categories => [ id => $website_category->id ] }
            },
            code  => 400,
            error => "'categories' parameter is invalid.",
        },
        {    # Attach folder.
            path   => '/v2/sites/1/entries/2',
            method => 'PUT',
            params => { entry => { categories => [ id => 20 ] } },
            code   => 400,
            error  => "'categories' parameter is invalid.",
        },

        # update_entry - normal tests.
        {    # Attach categories.
            path   => '/v2/sites/1/entries/2',
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
            path   => '/v2/sites/1/entries/2',
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
            path   => '/v2/sites/1/entries/2',
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
            path   => '/v2/sites/1/entries/2',
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
            path   => '/v2/sites/1/entries/2',
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
            path   => '/v2/sites/1/entries/2',
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
            path   => '/v2/sites/1/entries/2',
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
            path      => '/v2/sites/1/entries/2',
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

        # get_entry - normal tests.
        {    # no_format_filter = 1
                # check unpublishedDate is undef
            path      => '/v2/sites/1/entries/2',
            method    => 'GET',
            params    => { no_text_filter => 1, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.entry',
                    count => 1,
                },
            ],
            result   => sub { $app->model('entry')->load(2) },
            complete => sub {
                my ( $data, $body ) = @_;

                my $got      = $app->current_format->{unserialize}->($body);
                my $expected = $app->model('entry')->load(2);

                is( $got->{body}, $expected->text, 'no_text_filter = 1.' );
                is( $got->{unpublishedDate},
                    undef, 'upublishedDate is undef.' );
            },
        },

        # list_entries_for_asset
        {   path      => '/v2/sites/1/assets/2/entries',
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.asset',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.entry',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;
                my $got = $app->current_format->{unserialize}->($body);

                is( $got->{totalResults},     1 );
                is( $got->{items}->[0]->{id}, 2 );
            },
        },

        # list_entries_for_category
        {   path     => '/v2/sites/1/categories/1/entries',
            method   => 'GET',
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);

                my $cat     = MT->model('category')->load(1);
                my @entries = MT->model('entry')->load(
                    { class => 'entry' },
                    {   join => MT->model('placement')->join_on(
                            'entry_id',
                            {   blog_id     => $cat->blog_id,
                                category_id => $cat->id,
                            },
                        ),
                    }
                );

                is( $result->{totalResults},
                    scalar @entries,
                    'Category has ' . scalar @entries . 'entries'
                );

                my @json_ids = sort { $a <=> $b }
                    map { $_->{id} } @{ $result->{items} };
                my @entry_ids = sort { $a <=> $b } map { $_->id } @entries;
                is_deeply( \@json_ids, \@entry_ids, 'Entry IDs are correct' );
            }
        },

#        # list_entries_for_tag
#        {   path      => '/v2/tags/2/entries',
#            method    => 'GET',
#            callbacks => [
#                {   name =>
#                        'MT::App::DataAPI::data_api_view_permission_filter.tag',
#                    count => 1,
#                },
#                {   name  => 'data_api_pre_load_filtered_list.entry',
#                    count => 2,
#                },
#            ],
#            result => sub {
#                my @entry = $app->model('entry')->load(
#                    undef,
#                    {   join => $app->model('objecttag')->join_on(
#                            undef,
#                            {   blog_id           => \'= entry_blog_id',
#                                object_id         => \'= entry_id',
#                                object_datasource => 'entry',
#                                tag_id            => 2,
#                            },
#                        ),
#                        sort      => 'authored_on',
#                        direction => 'descend',
#                    },
#                );
#
#                return +{
#                    totalResults => scalar @entry,
#                    items => MT::DataAPI::Resource->from_object( \@entry ),
#                };
#            },
#        },

        # list_entries_for_site_and_tag
        {   path      => '/v2/sites/1/tags/2/entries',
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.tag',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.entry',
                    count => 2,
                },
            ],
            result => sub {
                my @entry = $app->model('entry')->load(
                    { blog_id => 1 },
                    {   join => $app->model('objecttag')->join_on(
                            undef,
                            {   blog_id           => \'= entry_blog_id',
                                object_id         => \'= entry_id',
                                object_datasource => 'entry',
                                tag_id            => 2,
                            },
                        ),
                        sort      => 'authored_on',
                        direction => 'descend',
                    },
                );

                return +{
                    totalResults => scalar @entry,
                    items => MT::DataAPI::Resource->from_object( \@entry ),
                };
            },
        },

        # preview_entry_by_id
        {    # Non-existent entry
            path   => '/v2/sites/1/entries/500/preview',
            method => 'POST',
            params => {
                entry => {
                    title  => 'foo',
                    text   => 'bar',
                    status => 'Draft',
                },
            },
            code => 404,
        },
        {    # No resource.
            path     => '/v2/sites/1/entries/2/preview',
            method   => 'POST',
            code     => 400,
            resource => sub {
                return +{
                    error => {
                        code    => 400,
                        message => 'A resource "entry" is required.',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/1/entries/2/preview',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # normal tests
            path   => '/v2/sites/1/entries/2/preview',
            params => {
                entry => {
                    title  => 'foo',
                    status => 'Draft',
                    text   => 'bar',
                },
            },
            method   => 'POST',
            complete => sub {
                my ( $data, $body ) = @_;
                my $obj = MT::Util::from_json($body);
                is( $obj->{status}, 'success', 'Preview Entry make success' );
            },
        },
        {    # normal tests - raw parameter
            path   => '/v2/sites/1/entries/2/preview',
            params => {
                entry => {
                    title  => 'foo',
                    text   => 'bar',
                    status => 'Draft',
                },
                raw => '1',
            },
            method   => 'POST',
            complete => sub {
                my ( $data, $body ) = @_;
                my $obj = MT::Util::from_json($body);
                is( $obj->{status}, 'success', 'Preview entry make success' );
            },
        },

        # preview_entry
        {    # No resource.
            path     => '/v2/sites/1/entries/preview',
            method   => 'POST',
            code     => 400,
            resource => sub {
                return +{
                    error => {
                        code    => 400,
                        message => 'A resource "entry" is required.',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/1/entries/preview',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # normal tests
            path   => '/v2/sites/1/entries/preview',
            params => {
                entry => {
                    title  => 'foo',
                    status => 'Draft',
                    text   => 'bar',
                },
            },
            method   => 'POST',
            complete => sub {
                my ( $data, $body ) = @_;
                my $obj = MT::Util::from_json($body);
                is( $obj->{status}, 'success', 'Preview Entry make success' );
            },
        },
        {    # normal tests - raw parameter
            path   => '/v2/sites/1/entries/preview',
            params => {
                entry => {
                    title  => 'foo',
                    text   => 'bar',
                    status => 'Draft',
                },
                raw              => '1',
            },
            method   => 'POST',
            complete => sub {
                my ( $data, $body ) = @_;
                my $obj = MT::Util::from_json($body);
                is( $obj->{status}, 'success', 'Preview entry make success' );
            },
        },
        {    # normal tests - authored_on
            path   => '/v2/sites/1/entries/preview',
            params => {
                entry => {
                    title  => 'foo',
                    status => 'Draft',
                    text   => 'bar',
                },
                authored_on_date => '2015-01-01',
                authored_on_time => '10:00:00',
            },
            method   => 'POST',
            complete => sub {
                my ( $data, $body ) = @_;
                my $obj = MT::Util::from_json($body);
                is( $obj->{status}, 'success', 'Preview entry make success' );
            },
        },
    ];
}

