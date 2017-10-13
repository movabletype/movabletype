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


use lib qw(lib extlib t/lib);

use Test::More;
use Test::MockModule;
use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

# preparation.
my $mock_perm   = Test::MockModule->new('MT::Permission');
my $mock_author = Test::MockModule->new('MT::Permission');

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
        {    # Not logged in.
            path      => '/v2/sites/1/widgetsets',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/1/widgetsets',
            method       => 'GET',
            restrictions => { 1 => [qw/ edit_templates /], },
            code         => 403,
            error =>
                'Do not have permission to retrieve the list of widgetsets.',
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

#        # list_all_widgetsets - normal tests
#        {   path      => '/v2/widgetsets',
#            method    => 'GET',
#            callbacks => [
#                {   name  => 'data_api_pre_load_filtered_list.template',
#                    count => 2,
#                },
#            ],
#            result => sub {
#                my @ws = $app->model('template')->load(
#                    { type => 'widgetset' },
#                    { sort => 'blog_id', direction => 'ascend' },
#                );
#
#                $app->user($author);
#
#                return +{
#                    totalResults => scalar @ws,
#                    items        => MT::DataAPI::Resource->from_object(
#                        \@ws, \@ws_fields
#                    ),
#                };
#            },
#        },

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
        {    # Not logged in.
            path      => '/v2/sites/1/widgetsets/' . $blog_ws->id,
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/1/widgetsets/' . $blog_ws->id,
            method       => 'GET',
            restrictions => {
                0 => [qw/ edit_templates /],
                1 => [qw/ edit_templates /],
            },
            code => 403,
            error =>
                'Do not have permission to retrieve the requested widgetset.',
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
        {    # Not logged in.
            path      => '/v2/sites/1/widgetsets',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/1/widgetsets',
            method => 'POST',
            params => {
                widgetset => {
                    name    => 'create-widgetset',
                    widgets => [ map { +{ id => $_->id } } @blog_widgets ],
                },
            },
            restrictions => { 1 => [qw/ edit_templates /], },
            code         => 403,
            error => 'Do not have permission to create a widgetset.',
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
        {    # Not logged in.
            path      => '/v2/sites/1/widgetsets/' . $blog_ws->id,
            method    => 'PUT',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/1/widgetsets/' . $blog_ws->id,
            method => 'PUT',
            params => {
                widgetset => {
                    name => 'update-widgetset',
                    widgets =>
                        [ map { +{ id => $_->id } } @blog_widgets_update ],
                },
            },
            restrictions => { 1 => [qw/ edit_templates /], },
            code         => 403,
            error => 'Do not have permission to update a widgetset.',
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
        {    # Not logged in.
            path      => '/v2/sites/1/widgetsets/' . $blog_ws->id,
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/1/widgetsets/' . $blog_ws->id,
            method       => 'DELETE',
            restrictions => { 1 => [qw/ edit_templates /], },
            code         => 403,
            error        => 'Do not have permission to delete a widgetset.',
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

