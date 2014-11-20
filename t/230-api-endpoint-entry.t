#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib extlib t/lib);

use Test::More;
use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

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

        # create_entry
        {   path   => '/v2/sites/1/entries',
            method => 'POST',
            params => {
                entry => {
                    title      => 'test-api-attach-categories-to-entry',
                    status     => 'Draft',
                    categories => [ { id => 1 } ],
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
                my @categories = @{ $entry->categories };
                is( scalar @categories, 1, 'Attaches a category' );
                is( $categories[0]->id, 1, 'Attached category ID is 1' );
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

        # update_entry
        {    # Attach categories.
            path   => '/v2/sites/1/entries/2',
            method => 'PUT',
            params => {
                entry => {
                    title      => 'test-api-update-categories',
                    categories => [ { id => 1 }, { id => 2 }, { id => 3 } ]
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
                my $entry      = MT->model('entry')->load(2);
                my @categories = @{ $entry->categories };
                is( scalar @categories, 3, 'Entry has 3 category' );
            },
        },
        {    # Update categories.
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
                my $entry      = MT->model('entry')->load(2);
                my @categories = @{ $entry->categories };
                is( scalar @categories, 2, 'Entry has 2 category' );
            },
        },
        {   path   => '/v2/sites/1/entries/2',
            method => 'PUT',
            params => { entry => { categories => [ id => 20 ] } },
            code   => 400,
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
        {   path   => '/v2/sites/1/entries/2',
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
        {   path   => '/v2/sites/1/entries/2',
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
        {    # no_format_filter = 1
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
            },
        },

        # list_assets_for_entry
        {   path      => '/v2/sites/1/entries/2/assets',
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);
                is( $result->{totalResults}, 1, 'Entry has 1 asset' );

                my $entry  = MT->model('entry')->load(2);
                my @assets = MT->model('asset')->load(
                    { class => '*' },
                    {   join => MT->model('objectasset')->join_on(
                            'asset_id',
                            {   blog_id   => $entry->blog->id,
                                object_ds => 'entry',
                                object_id => $entry->id,
                            },
                        ),
                    }
                );
                my @json_ids
                    = sort { $a <=> $b }
                    map    { $_->{id} } @{ $result->{items} };
                my @asset_ids = sort { $a <=> $b } map { $_->id } @assets;
                is_deeply( \@json_ids, \@asset_ids, 'Asset IDs are correct' );
            },
        },

        # list_categories_for_entry
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

                my @json_ids
                    = sort { $a <=> $b }
                    map    { $_->{id} } @{ $result->{items} };
                my @entry_ids = sort { $a <=> $b } map { $_->id } @entries;
                is_deeply( \@json_ids, \@entry_ids, 'Entry IDs are correct' );
                }
        },
    ];
}

