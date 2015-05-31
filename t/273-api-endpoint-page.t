#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib extlib t/lib);

use Test::More;
use MT::Test::DataAPI;

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

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # list_pages - irregualr tests
        {    # Non-existent site.
            path   => '/v2/sites/5/pages',
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },    # status is draft and not logged in.
        {   path      => '/v2/sites/1/pages',
            method    => 'GET',
            params    => { status => 'draft' },
            author_id => 0,
            code      => 403,
            error =>
                'Do not have permission to retrieve the requested pages.',
        },

        # list_pages - normal tests
        {     # Blog.
            path      => '/v2/sites/1/pages',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.page',
                    count => 2,
                },
            ],
            result => sub {
                my @pages = $app->model('page')->load( { blog_id => 1 },
                    { sort => 'modified_on', direction => 'descend' } );

                $app->user($author);
                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};

                return +{
                    totalResults => 4,
                    items => MT::DataAPI::Resource->from_object( \@pages ),
                };
            },
        },
        {    # Website.
            path      => '/v2/sites/2/pages',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.page',
                    count => 2,
                },
            ],
            result => sub {
                my @pages = $app->model('page')->load( { blog_id => 2 },
                    { sort => 'modified_on', direction => 'descend' } );

                $app->user($author);
                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};

                return +{
                    totalResults => 2,
                    items => MT::DataAPI::Resource->from_object( \@pages ),
                };
            },
        },

        {    # Not logged in.
            path      => '/v2/sites/0/pages',
            method    => 'GET',
            author_id => 0,
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.page',
                    count => 2,
                },
            ],
            result => sub {
                my @pages = $app->model('page')->load( { status => 2 },
                    { sort => 'modified_on', direction => 'descend' } );

                $app->user( MT::Author->anonymous );
                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};

                return +{
                    totalResults => 5,
                    items => MT::DataAPI::Resource->from_object( \@pages ),
                };
            },
        },
        {    # Search.
            path      => '/v2/sites/1/pages',
            method    => 'GET',
            params    => { search => 'watching', },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.page',
                    count => 2,
                },
            ],
            result => sub {
                my $page = $app->model('page')->load(20);

                $app->user($author);
                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};

                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( [$page] ),
                };
            },
        },
        {    # Filter by status.
            path      => '/v2/sites/1/pages',
            method    => 'GET',
            params    => { status => 'Draft' },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.page',
                    count => 2,
                },
            ],
            result => sub {
                my @pages
                    = $app->model('page')
                    ->load( { blog_id => 1, status => 1 } );

                $app->user($author);
                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};

                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( \@pages ),
                };
            },
        },

        # list_pages_for_folder - normal tests
        {   path      => '/v2/sites/1/folders/' . $blog_folder->id . '/pages',
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.folder',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.page',
                    count => 2,
                },
            ],
            result => sub {
                return +{
                    totalResults => 1,
                    items =>
                        MT::DataAPI::Resource->from_object( [$blog_page_2] ),
                };
            },
        },

        # list_pages_for_asset - normal tests.
        {   path      => '/v2/sites/1/assets/2/pages',
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.asset',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.page',
                    count => 2,
                },
            ],
            result => sub {
                return +{
                    totalResults => 1,
                    items =>
                        MT::DataAPI::Resource->from_object( [$blog_page] ),
                };
            },
        },

#        # list_pages_for_tag - normal tests.
#        {   path      => '/v2/tags/15/pages',
#            method    => 'GET',
#            callbacks => [
#                {   name =>
#                        'MT::App::DataAPI::data_api_view_permission_filter.tag',
#                    count => 1,
#                },
#                {   name  => 'data_api_pre_load_filtered_list.page',
#                    count => 2,
#                },
#            ],
#            result => sub {
#                my @page = $app->model('page')->load(
#                    undef,
#                    {   join => $app->model('objecttag')->join_on(
#                            undef,
#                            {   blog_id           => \'= entry_blog_id',
#                                object_id         => \'= entry_id',
#                                object_datasource => 'entry',
#                                tag_id            => 15,
#                            },
#                        ),
#                        sort      => 'modified_on',
#                        direction => 'descend',
#                    },
#                );
#
#                return +{
#                    totalResults => scalar @page,
#                    items => MT::DataAPI::Resource->from_object( \@page ),
#                };
#            },
#        },

        # list_pagss_for_site_and_tag - normal tests.
        {   path      => '/v2/sites/1/tags/15/pages',
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.tag',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.page',
                    count => 2,
                },
            ],
            result => sub {
                my @page = $app->model('page')->load(
                    { blog_id => 1 },
                    {   join => $app->model('objecttag')->join_on(
                            undef,
                            {   blog_id           => \'= entry_blog_id',
                                object_id         => \'= entry_id',
                                object_datasource => 'entry',
                                tag_id            => 15,
                            },
                        ),
                        sort      => 'modified_on',
                        direction => 'descend',
                    },
                );

                return +{
                    totalResults => scalar @page,
                    items => MT::DataAPI::Resource->from_object( \@page ),
                };
            },
        },

        # get_page - irregular tests
        {    # Non-existent page.
            path   => '/v2/sites/1/pages/500',
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/pages/23',
            method => 'GET',
            code   => 404,
        },
        {    # Other site.
            path   => '/v2/sites/2/pages/23',
            method => 'GET',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v2/sites/0/pages/23',
            method => 'GET',
            code   => 404,
        },
        {    # Not page (entry).
            path   => '/v2/sites/1/pages/2',
            method => 'GET',
            code   => 404,
        },
        {    # Not published and not logged in.
            path      => '/v2/sites/1/pages/20',
            method    => 'GET',
            author_id => 0,
            code      => 403,
        },
        {    # Unpublished page and no permissions.
            path         => '/v2/sites/1/pages/20',
            method       => 'GET',
            restrictions => { 1 => [qw/ open_page_edit_screen /], },
            code         => 403,
            error => 'Do not have permission to retrieve the requested page.',
        },

        # get_page - normal tests
        {   path      => '/v2/sites/1/pages/23',
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.page',
                    count => 1,
                },
            ],
            result => sub {
                $app->model('page')->load(
                    {   id    => 23,
                        class => 'page',
                    }
                );
            },
        },
        {    # no_text_filter = 0
            path   => '/v2/sites/1/pages/23',
            method => 'GET',
            setup  => sub {
                my $page = $app->model('page')->load(23);
                $page->convert_breaks('markdown');
                my $body = <<'__BODY__';
1. foo
2. bar
3. baz
__BODY__
                $page->text($body);
                $page->save or die $page->errstr;
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.page',
                    count => 1,
                },
            ],
            result => sub {
                $app->model('page')->load(
                    {   id    => 23,
                        class => 'page',
                    }
                );
            },
            complete => sub {
                my ( $data, $body ) = @_;

                my $got      = $app->current_format->{unserialize}->($body);
                my $expected = $app->model('page')->load(23);

                isnt( $got->{body}, $expected->text );
            },
        },
        {    # no_text_filter = 1
            path      => '/v2/sites/1/pages/23',
            method    => 'GET',
            params    => { no_text_filter => 1 },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.page',
                    count => 1,
                },
            ],
            result => sub {
                $app->model('page')->load(
                    {   id    => 23,
                        class => 'page',
                    }
                );
            },
            complete => sub {
                my ( $data, $body ) = @_;

                my $got      = $app->current_format->{unserialize}->($body);
                my $expected = $app->model('page')->load(23);

                is( $got->{body}, $expected->text );
            },
        },

        # create_page - irregular tests
        {    # No resource.
            path   => '/v2/sites/1/pages',
            method => 'POST',
            code   => 400,
            error  => 'A resource "page" is required.',
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/pages',
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
            path   => '/v2/sites/0/pages',
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
            path   => '/v2/sites/1/pages',
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
            path   => '/v2/sites/1/pages',
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
            path   => '/v2/sites/1/pages',
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
            path   => '/v2/sites/1/pages',
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

        # create_page - normal tests
        {   path   => '/v2/sites/1/pages',
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
            path   => '/v2/sites/1/pages',
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
        {    # Set format.
            path   => '/v2/sites/1/pages',
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
            path   => '/v2/sites/1/pages',
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

        # update_page - irregular tests
        {    # Non-existent page.
            path   => '/v2/sites/1/pages/100',
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
            path   => '/v2/sites/5/pages/23',
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
            path   => '/v2/sites/2/pages/23',
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
            path   => '/v2/sites/0/pages/23',
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
            path   => '/v2/sites/1/pages/23',
            method => 'PUT',
            code   => 400,
            error  => 'A resource "page" is required.',
        },
        {    # Invalid format.
            path   => '/v2/sites/1/pages/23',
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
            path   => '/v2/sites/1/pages/23',
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
            path   => '/v2/sites/1/pages/23',
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
        {   path   => '/v2/sites/1/pages/23',
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
            path   => '/v2/sites/1/pages/23',
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
            path   => '/v2/sites/1/pages/23',
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
            path   => '/v2/sites/1/pages/23',
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

        # delete_page - irregular tests
        {    # Non-existent page.
            path   => '/v2/sites/1/pages/500',
            method => 'DELETE',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/pages/23',
            method => 'DELETE',
            code   => 404,
        },
        {    # Other site.
            path   => '/v2/sites/2/pages/23',
            method => 'DELETE',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v2/sites/0/pages/23',
            method => 'DELETE',
            code   => 404,
        },
        {    # Not page (entry).
            path   => '/v2/sites/1/pages/2',
            method => 'DELETE',
            code   => 404,
        },
        {    # Not logged in.
            path      => '/v2/sites/1/pages/23',
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/1/pages/23',
            method       => 'DELETE',
            restrictions => { 1 => [qw/ delete_page /], },
            code         => 403,
            error        => 'Do not have permission to delete a page.',
        },

        # delete_page - normal tests
        {   path   => '/v2/sites/1/pages/23',
            method => 'DELETE',
            setup  => sub {
                die if !$app->model('page')->load(23);
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.page',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_delete.page',
                    count => 1,
                },
            ],
            complete => sub {
                my $page = $app->model('page')->load(23);
                is( $page, undef, 'Deleted page.' );
            },
        },
    ];
}

