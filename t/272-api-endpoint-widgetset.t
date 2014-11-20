#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib extlib t/lib);

use Test::More;
use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

# preparation.
my $author = $app->model('author')->load(1);

my @ws_fields
    = qw( id name updatable widgets blog createdBy createdDate modifiedBy modifiedDate );

my $tmpl_class = $app->model('template');

my $blog_ws = $tmpl_class->load( { blog_id => 1, type => 'widgetset' } )
    or die $tmpl_class->errstr;
my @blog_widgets
    = $tmpl_class->load( { blog_id => 1, type => 'widget' }, { limit => 2 } )
    or die $tmpl_class->errstr;
my @blog_widgets_update
    = $tmpl_class->load( { blog_id => 1, type => 'widget' },
    { limit => 2, offset => 2 } )
    or die $tmpl_class->errstr;

my $blog_index_tmpl = $tmpl_class->load( { blog_id => 1, type => 'index' } )
    or die $tmpl_class->errstr;

# test.
my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # list_widgetsets - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/5/widgetsets',
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },

        # list_widgetsets - normal tests
        {    # Blog.
            path      => '/v2/sites/1/widgetsets',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.template',
                    count => 2,
                },
            ],
            result => sub {
                my @ws = $app->model('template')->load(
                    { blog_id => 1,      type      => 'widgetset' },
                    { sort    => 'name', direction => 'ascend' },
                );

                $app->user($author);
                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};

                return +{
                    totalResults => scalar @ws,
                    items        => MT::DataAPI::Resource->from_object(
                        \@ws, \@ws_fields
                    ),
                };
            },
        },
        {    # Can sort by created_on.
            path   => '/v2/sites/1/widgetsets',
            method => 'GET',
            params => { sortBy => 'created_on' },
        },
        {    # Can sort by modified_on.
            path   => '/v2/sites/1/widgetsets',
            method => 'GET',
            params => { sortBy => 'modified_on' },
        },
        {    # Can sort by created_by.
            path   => '/v2/sites/1/widgetsets',
            method => 'GET',
            params => { sortBy => 'created_by' },
        },
        {    # Can sort by modified_by.
            path   => '/v2/sites/1/widgetsets',
            method => 'GET',
            params => { sortBy => 'modified_by' },
        },

        # list_all_widgetsets - normal tests
        {   path      => '/v2/widgetsets',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.template',
                    count => 2,
                },
            ],
            result => sub {
                my @ws = $app->model('template')->load(
                    { type => 'widgetset' },
                    { sort => 'blog_id', direction => 'ascend' },
                );

                $app->user($author);
                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};

                return +{
                    totalResults => scalar @ws,
                    items        => MT::DataAPI::Resource->from_object(
                        \@ws, \@ws_fields
                    ),
                };
            },
        },

        # get_widgetset - irregular tests
        {    # Non-existent widgetset.
            path   => '/v2/sites/1/widgetsets/500',
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widgetset not found',
                    },
                };
            },
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/widgetsets/' . $blog_ws->id,
            method => 'GET',
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
            path   => '/v2/sites/2/widgetsets/' . $blog_ws->id,
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widgetset not found',
                    },
                };
            },
        },
        {    # Other site (system).
            path   => '/v2/sites/0/widgetsets/' . $blog_ws->id,
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widgetset not found',
                    },
                };
            },
        },
        {    # Not widgetset (index template).
            path   => '/v2/sites/2/widgetsets/' . $blog_index_tmpl->id,
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widgetset not found',
                    },
                };
            },
        },

        # get_widgetset - normal tests
        {   path      => '/v2/sites/1/widgetsets/' . $blog_ws->id,
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.template',
                    count => 1,
                },
            ],
            result => sub {
                my $ws = $app->model('template')->load(
                    {   id      => $blog_ws->id,
                        blog_id => 1,
                        type    => 'widgetset',
                    }
                );

                $app->user($author);
                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};

                return MT::DataAPI::Resource->from_object( $ws, \@ws_fields );
            },
        },

        # create_widgetset - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/5/widgetsets',
            method => 'POST',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # No resource.
            path   => '/v2/sites/1/widgetsets',
            method => 'POST',
            code   => 400,
            result => sub {
                return +{
                    error => {
                        code    => 400,
                        message => 'A resource "widgetset" is required.',
                    },
                    },
                    ;
            },
        },
        {    # No name.
            path   => '/v2/sites/1/widgetsets',
            method => 'POST',
            params => { widgetset => {}, },
            code   => 409,
            result => sub {
                return +{
                    error => {
                        code    => 409,
                        message => "A parameter \"name\" is required.\n",
                    },
                    },
                    ;
            },
        },

        # create_widgetset - normal tests
        {   path   => '/v2/sites/1/widgetsets',
            method => 'POST',
            params => {
                widgetset => {
                    name    => 'create-widgetset',
                    widgets => [ map { +{ id => $_->id } } @blog_widgets ],
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.widgetset',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.widgetset',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.widgetset',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.widgetset',
                    count => 1,
                },
            ],
            result => sub {
                my $ws = $app->model('template')->load(
                    {   blog_id => 1,
                        name    => 'create-widgetset',
                        type    => 'widgetset',
                    }
                );

                $app->user($author);
                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};

                return MT::DataAPI::Resource->from_object( $ws, \@ws_fields );
            },
        },

        # update_widgetset - irregular tests
        {    # Non-existent widgetset.
            path   => '/v2/sites/1/widgetsets/500',
            method => 'PUT',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widgetset not found',
                    },
                };
            },
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/widgetsets/' . $blog_ws->id,
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
            path   => '/v2/sites/2/widgetsets/' . $blog_ws->id,
            method => 'PUT',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widgetset not found',
                    },
                };
            },
        },
        {    # Other site (system).
            path   => '/v2/sites/0/widgetsets/' . $blog_ws->id,
            method => 'PUT',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widgetset not found',
                    },
                };
            },
        },
        {    # Non widgetset.
            path   => '/v2/sites/1/widgetsets/' . $blog_index_tmpl->id,
            method => 'PUT',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widgetset not found',
                    },
                };
            },
        },
        {    # No resource.
            path   => '/v2/sites/1/widgetsets/' . $blog_ws->id,
            method => 'PUT',
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A resource "widgetset" is required.',
                    },
                };
            },
        },

        # update_widgetset - normal tests
        {   path   => '/v2/sites/1/widgetsets/' . $blog_ws->id,
            method => 'PUT',
            params => {
                widgetset => {
                    name => 'update-widgetset',
                    widgets =>
                        [ map { +{ id => $_->id } } @blog_widgets_update ],
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.widgetset',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.widgetset',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.widgetset',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.widgetset',
                    count => 1,
                },
            ],
            result => sub {
                my $ws = $app->model('template')->load(
                    {   id      => $blog_ws->id,
                        blog_id => 1,
                        name    => 'update-widgetset',
                        type    => 'widgetset',
                    }
                );

                $app->user($author);
                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};

                return MT::DataAPI::Resource->from_object( $ws, \@ws_fields );
            },
        },

        # delete_widgetset - irregular tests
        {    # Non-eixstent widgetset.
            path   => '/v2/sites/1/widgetsets/500',
            method => 'DELETE',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widgetset not found',
                    },
                };
            },
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/widgetsets/' . $blog_ws->id,
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
        {    # Other site.
            path   => '/v2/sites/2/widgetsets/' . $blog_ws->id,
            method => 'DELETE',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widgetset not found',
                    },
                };
            },
        },
        {    # Other site (system).
            path   => '/v2/sites/0/widgetsets/' . $blog_ws->id,
            method => 'DELETE',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widgetset not found',
                    },
                };
            },
        },
        {    # Not widgetset (index template).
            path   => '/v2/sites/2/widgetsets/' . $blog_index_tmpl->id,
            method => 'DELETE',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widgetset not found',
                    },
                };
            },
        },

        # delete_widgetset - normal tests
        {   path   => '/v2/sites/1/widgetsets/' . $blog_ws->id,
            method => 'DELETE',
            setup  => sub {
                die if !$app->model('template')->load( $blog_ws->id );
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.template',
                    count => 1,
                },
                {   name => 'MT::App::DataAPI::data_api_post_delete.template',
                    count => 1,
                },
            ],
            complete => sub {
                my $ws = $app->model('template')->load(
                    {   id      => $blog_ws->id,
                        blog_id => 1,
                        type    => 'widgetset',
                    }
                );
                is( $ws, undef, 'Deleted widgetset.' );
            },
        },
    ];
}

