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
my $mock_author = Test::MockModule->new('MT::Author');

my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

my $system_widget = $app->model('template')->new;
$system_widget->set_values(
    {   blog_id    => 0,
        name       => 'System Widget',
        text       => 'This is a system widget.',
        identifier => 'system_widget',
        type       => 'widget',
    }
);
$system_widget->save or die $system_widget->errstr;

my $widget_class = $app->model('template');
my $blog_widget = $widget_class->load( { blog_id => 1, type => 'widget' } )
    or die $widget_class->errstr;
my $website_widget = $widget_class->load( { blog_id => 2, type => 'widget' } )
    or die $widget_class->errstr;

my $blog_index_tmpl = $widget_class->load( { blog_id => 1, type => 'index' } )
    or die $widget_class->errstr;

my $blog_ws = $widget_class->load( { blog_id => 1, type => 'widgetset' } )
    or die $widget_class->errstr;

# test.
my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # list_widgets - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/5/widgets',
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
            path      => '/v2/sites/1/widgets',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/1/widgets',
            method       => 'GET',
            restrictions => { 1 => [qw/ edit_templates /], },
            code         => 403,
            error =>
                'Do not have permission to retrieve the list of widgets.',
        },

        # list_widgets - normal tests
        {    # Blog.
            path      => '/v2/sites/1/widgets',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.template',
                    count => 2,
                },
            ],
            result => sub {
                my @terms_args = (
                    { blog_id => 1,      type      => 'widget' },
                    { sort    => 'name', direction => 'ascend', limit => 10 },
                );
                my $total_results
                    = $app->model('template')->count(@terms_args);
                my @widgets = $app->model('template')->load(@terms_args);

                $app->user($author);

                return +{
                    totalResults => $total_results,
                    items => MT::DataAPI::Resource->from_object( \@widgets ),
                };
            },
        },
        {    # Website.
            path      => '/v2/sites/2/widgets',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.template',
                    count => 2,
                },
            ],
            result => sub {
                my @terms_args = (
                    { blog_id => 2,      type      => 'widget' },
                    { sort    => 'name', direction => 'ascend', limit => 10 },
                );
                my $total_results
                    = $app->model('template')->count(@terms_args);
                my @widgets = $app->model('template')->load(@terms_args);

                $app->user($author);

                return +{
                    totalResults => $total_results,
                    items => MT::DataAPI::Resource->from_object( \@widgets ),
                };
            },
        },
        {    # System.
            path      => '/v2/sites/0/widgets',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.template',
                    count => 2,
                },
            ],
            result => sub {
                my $widget = $app->model('template')
                    ->load( { blog_id => 0, type => 'widget' } );

                $app->user($author);

                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( [$widget] ),
                };
            },
        },
        {    # Search name.
            path   => '/v2/sites/1/widgets',
            method => 'GET',
            params => {
                search       => 'Archives',
                searchFields => 'name',
            },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.template',
                    count => 2,
                },
            ],
            result => sub {
                my @terms_args = (
                    {   blog_id => 1,
                        type    => 'widget',
                        name    => { like => '%Archives%' }
                    },
                    { sort => 'name', direction => 'ascend', limit => 10 },
                );
                my $total_results
                    = $app->model('template')->count(@terms_args);
                my @widgets = $app->model('template')->load(@terms_args);

                $app->user($author);

                return +{
                    totalResults => $total_results,
                    items => MT::DataAPI::Resource->from_object( \@widgets ),
                };
            },
        },
        {    # Search text.
            path   => '/v2/sites/1/widgets',
            method => 'GET',
            params => {
                search       => 'DOCTYPE',
                searchFields => 'text',
            },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.template',
                    count => 1,
                },
            ],
            result => sub {
                my @terms_args = (
                    {   blog_id => 1,
                        type    => 'widget',
                        text    => { like => '%DOCTYPE%' }
                    },
                    { sort => 'name', direction => 'ascend', limit => 10 },
                );
                my $total_results
                    = $app->model('template')->count(@terms_args);
                my @widgets = $app->model('template')->load(@terms_args);

                $app->user($author);

                return +{
                    totalResults => $total_results,
                    items => MT::DataAPI::Resource->from_object( \@widgets ),
                };
            },
        },
        {    # Can sort by modified_on.
            path   => '/v2/sites/1/widgets',
            method => 'GET',
            params => { sortBy => 'modified_on', },
        },
        {    # Can sort by created_on.
            path   => '/v2/sites/1/widgets',
            method => 'GET',
            params => { sortBy => 'created_on', },
        },
        {    # Can sort by modified_by.
            path   => '/v2/sites/1/widgets',
            method => 'GET',
            params => { sortBy => 'modified_by', },
        },
        {    # Can sort by created_by.
            path   => '/v2/sites/1/widgets',
            method => 'GET',
            params => { sortBy => 'created_by', },
        },

#        # list_all_widgets - irregular tests.
#        {    # Not logged in.
#            path      => '/v2/widgets',
#            method    => 'GET',
#            author_id => 0,
#            code      => 401,
#            error     => 'Unauthorized',
#        },
#        {    # No permissions.
#            path         => '/v2/widgets',
#            method       => 'GET',
#            restrictions => {
#                0 => [qw/ edit_templates /],
#                1 => [qw/ edit_templates /],
#                2 => [qw/ edit_templates /],
#            },
#            code => 403,
#            error =>
#                'Do not have permission to retrieve the list of widgets.',
#        },
#
#        # list_all_widgets - normal tests
#        {   path      => '/v2/widgets',
#            method    => 'GET',
#            callbacks => [
#                {   name  => 'data_api_pre_load_filtered_list.template',
#                    count => 2,
#                },
#            ],
#            result => sub {
#                my @terms_args = (
#                    { type => 'widget' },
#                    { sort => 'blog_id', direction => 'ascend', limit => 10 },
#                );
#                my $total_results
#                    = $app->model('template')->count(@terms_args);
#                my @widgets = $app->model('template')->load(@terms_args);
#
#                $app->user($author);
#                return +{
#                    totalResults => $total_results,
#                    items => MT::DataAPI::Resource->from_object( \@widgets ),
#                };
#            },
#        },

        # list_widgets_for_widgetset - irregular tests.
        {    # Non-existent site.
            path   => '/v2/sites/10/widgetsets/' . $blog_ws->id . '/widgets',
            method => 'GET',
            code   => 404,
            error  => 'Site not found',
        },
        {    # Other site.
            path   => '/v2/sites/2/widgetsets/' . $blog_ws->id . '/widgets',
            method => 'GET',
            code   => 404,
            error  => 'Widgetset not found',
        },
        {    # Not logged in.
            path   => '/v2/sites/2/widgetsets/' . $blog_ws->id . '/widgets',
            method => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/1/widgetsets/' . $blog_ws->id . '/widgets',
            method => 'GET',
            restrictions => { 1 => [qw/ edit_templates /], },
            code         => 403,
            error =>
                'Do not have permission to retrieve widgets of the request widgetset.',
        },

        # list_widgets_for_widgetset - normal tests.
        {   path   => '/v2/sites/1/widgetsets/' . $blog_ws->id . '/widgets',
            method => 'GET',
            result => sub {
                my @widget_id = split ',', $blog_ws->modulesets;
                my @widget
                    = $app->model('template')->load( { id => \@widget_id } );
                @widget = sort { $a->name cmp $b->name } @widget;

                $app->user($author);
                return +{
                    totalResults => scalar @widget,
                    items => MT::DataAPI::Resource->from_object( \@widget ),
                };
            },
        },

        # get_widget - irregular tests
        {    # Non-existent widget.
            path   => '/v2/sites/1/widgets/500',
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widget not found',
                    },
                };
            },
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/widgets/' . $blog_widget->id,
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
            path   => '/v2/sites/2/widgets/' . $blog_widget->id,
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widget not found',
                    },
                };
            },
        },
        {    # Other site (system).
            path   => '/v2/sites/0/widgets/' . $blog_widget->id,
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widget not found',
                    },
                };
            },
        },
        {    # Not widget.
            path   => '/v2/sites/1/widgets/' . $blog_index_tmpl->id,
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widget not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/1/widgets/' . $blog_widget->id,
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },

        {    # No permissions.
            path         => '/v2/sites/1/widgets/' . $blog_widget->id,
            method       => 'GET',
            restrictions => {
                0 => [qw/ edit_templates /],
                1 => [qw/ edit_templates /],
            },
            code => 403,
            error =>
                'Do not have permission to retrieve the requested widget.',
        },

        # get_widget - normal tests
        {    # Blog.
            path      => '/v2/sites/1/widgets/' . $blog_widget->id,
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.template',
                    count => 1,
                },
            ],
            result => sub {
                $blog_widget;
            },
        },
        {    # Website.
            path      => '/v2/sites/2/widgets/' . $website_widget->id,
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.template',
                    count => 1,
                },
            ],
            result => sub {
                $website_widget;
            },
        },
        {    # System.
            path      => '/v2/sites/0/widgets/' . $system_widget->id,
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.template',
                    count => 1,
                },
            ],
            result => sub {
                $system_widget;
            },
        },

        # create_widget - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/5/widgets',
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
            path   => '/v2/sites/1/widgets',
            method => 'POST',
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A resource "widget" is required.',
                    },
                };
            },
        },
        {    # No name.
            path   => '/v2/sites/1/widgets',
            method => 'POST',
            params => { widget => {}, },
            code   => 409,
            result => sub {
                +{  error => {
                        code    => 409,
                        message => "A parameter \"name\" is required.\n",
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/1/widgets',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/1/widgets',
            method => 'POST',
            params => { widget => { name => 'create-widget', }, },
            restrictions => { 1 => [qw/ edit_templates /], },
            code         => 403,
            error => 'Do not have permission to create a widget.',
        },

        # create_widget - normal tests
        {    # Blog.
            path      => '/v2/sites/1/widgets',
            method    => 'POST',
            params    => { widget => { name => 'create-widget', }, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.widget',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.widget',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.widget',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.widget',
                    count => 1,
                },
            ],
            result => sub {
                $app->model('template')->load(
                    {   name    => 'create-widget',
                        blog_id => 1,
                        type    => 'widget',
                    }
                );
            },
        },
        {    # Website.
            path      => '/v2/sites/2/widgets',
            method    => 'POST',
            params    => { widget => { name => 'create-widget-website', }, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.widget',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.widget',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.widget',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.widget',
                    count => 1,
                },
            ],
            result => sub {
                $app->model('template')->load(
                    {   name    => 'create-widget-website',
                        blog_id => 2,
                        type    => 'widget',
                    }
                );
            },
        },
        {    # System.
            path      => '/v2/sites/0/widgets',
            method    => 'POST',
            params    => { widget => { name => 'create-widget-system', }, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.widget',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.widget',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.widget',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.widget',
                    count => 1,
                },
            ],
            result => sub {
                $app->model('template')->load(
                    {   name    => 'create-widget-system',
                        blog_id => 0,
                        type    => 'widget',
                    }
                );
            },
        },

        # update_widget - irregular tests
        {    # Non-existent widget.
            path   => '/v2/sites/1/widgets/500',
            method => 'PUT',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widget not found',
                    },
                };
            },
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/widgets/' . $blog_widget->id,
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
            path   => '/v2/sites/2/widgets/' . $blog_widget->id,
            method => 'PUT',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widget not found',
                    },
                };
            },
        },
        {    # Other site (system).
            path   => '/v2/sites/0/widgets/' . $blog_widget->id,
            method => 'PUT',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widget not found',
                    },
                };
            },
        },
        {    # Not widget.
            path   => '/v2/sites/1/widgets/' . $blog_index_tmpl->id,
            method => 'PUT',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widget not found',
                    },
                };
            },
        },
        {    # No resource.
            path   => '/v2/sites/1/widgets/' . $blog_widget->id,
            method => 'PUT',
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A resource "widget" is required.',
                    },
                };
            },
        },
        {    # Empty name.
            path   => '/v2/sites/1/widgets/' . $blog_widget->id,
            method => 'PUT',
            params => { widget => { name => '', }, },
            code   => 409,
            result => sub {
                +{  error => {
                        code    => 409,
                        message => "A parameter \"name\" is required.\n",
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/1/widgets/' . $blog_widget->id,
            method    => 'PUT',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/1/widgets/' . $blog_widget->id,
            method       => 'PUT',
            restrictions => { 1 => [qw/ edit_templates /], },
            params       => {
                widget => {
                    name => 'update-widget',
                    type => 'update-type',
                },
            },
            code  => 403,
            error => 'Do not have permission to update a widget.',
        },

        # update_widget - normal tests
        {    # Blog.
            path   => '/v2/sites/1/widgets/' . $blog_widget->id,
            method => 'PUT',
            params => {
                widget => {
                    name => 'update-widget',
                    type => 'update-type',
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.widget',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.widget',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.widget',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.widget',
                    count => 1,
                },
            ],
            result => sub {
                $app->model('template')->load(
                    {   name    => 'update-widget',
                        blog_id => 1,
                        type    => 'widget',
                    }
                );
            },
        },

        # refresh_widget - irregular tests
        {    # Non-existent widget.
            path   => '/v2/sites/1/widgets/500/refresh',
            method => 'POST',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/widgets/' . $blog_widget->id . '/refresh',
            method => 'POST',
            code   => 404,
        },
        {    # Other site.
            path   => '/v2/sites/2/widgets/' . $blog_widget->id . '/refresh',
            method => 'POST',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v2/sites/0/widgets/' . $blog_widget->id . '/refresh',
            method => 'POST',
            code   => 404,
        },
        {    # Not widget (index template).
            path => '/v2/sites/0/widgets/'
                . $blog_index_tmpl->id
                . '/refresh',
            method => 'POST',
            code   => 404,
        },
        {    # Not logged in.
            path   => '/v2/sites/1/widgets/' . $blog_widget->id . '/refresh',
            method => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/1/widgets/' . $blog_widget->id . '/refresh',
            method => 'POST',
            restrictions => {
                1 => [qw/ edit_templates administer_site /],
                0 => [qw/ edit_templates administer_site /],
            },
            code  => 403,
            error => 'Do not have permission to refresh a widget.',
        },

        # refresh_widget - normal tests
        {   path  => '/v2/sites/1/widgets/' . $blog_widget->id . '/refresh',
            setup => sub {
                $blog_widget->text('This widget has not been refreshed!');
                $blog_widget->save or die $blog_widget->errstr;
            },
            method   => 'POST',
            complete => sub {
                my $refreshed_blog_widget
                    = $app->model('template')->load( $blog_widget->id );
                isnt( $refreshed_blog_widget->text,
                    $blog_widget->text, 'Widget has been refreshed.' );
            },
        },

        # clone_widget - irregular tests
        {    # Non-existent widget.
            path   => '/v2/sites/1/widgets/500/clone',
            method => 'POST',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/widgets/' . $blog_widget->id . '/clone',
            method => 'POST',
            code   => 404,
        },
        {    # Other site.
            path   => '/v2/sites/2/widgets/' . $blog_widget->id . '/clone',
            method => 'POST',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v2/sites/0/widgets/' . $blog_widget->id . '/clone',
            method => 'POST',
            code   => 404,
        },
        {    # Not widget (index template).
            path => '/v2/sites/0/widgets/' . $blog_index_tmpl->id . '/clone',
            method => 'POST',
            code   => 404,
        },
        {    # Not logged in.
            path      => '/v2/sites/1/widgets/' . $blog_widget->id . '/clone',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/1/widgets/' . $blog_widget->id . '/clone',
            method => 'POST',
            restrictions => {
                0 => [qw/ edit_templates administer_site /],
                1 => [qw/ edit_templates administer_site /],
            },
            code  => 403,
            error => 'Do not have permission to clone a widget.',
        },

        # clone_widget - normal tests
        {   path  => '/v2/sites/1/widgets/' . $blog_widget->id . '/clone',
            setup => sub {
                my ($data) = @_;
                $data->{widget_count} = $app->model('template')
                    ->count( { blog_id => 1, type => 'widget' } );
            },
            method   => 'POST',
            complete => sub {
                my ( $data, $body ) = @_;
                my $widget_count = $app->model('template')
                    ->count( { blog_id => 1, type => 'widget' } );
                is( $widget_count,
                    $data->{widget_count} + 1,
                    'Cloned template.'
                );
            }
        },

        # delete_widget - irregular tests
        {    # Non-existent widget.
            path   => '/v2/sites/1/widgets/500',
            method => 'DELETE',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widget not found',
                    },
                };
            },
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/widgets/' . $blog_widget->id,
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
            path   => '/v2/sites/2/widgets/' . $blog_widget->id,
            method => 'DELETE',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widget not found',
                    },
                };
            },
        },
        {    # Other site (system).
            path   => '/v2/sites/0/widgets/' . $blog_widget->id,
            method => 'DELETE',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widget not found',
                    },
                };
            },
        },
        {    # Not widget.
            path   => '/v2/sites/1/widgets/' . $blog_index_tmpl->id,
            method => 'DELETE',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Widget not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/1/widgets/' . $blog_index_tmpl->id,
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/1/widgets/' . $blog_widget->id,
            method       => 'DELETE',
            restrictions => { 1 => [qw/ edit_templates /], },
            code         => 403,
            error        => 'Do not have permission to delete a widget.',
        },

        # delete_widget - normal tests
        {    # Blog.
            path   => '/v2/sites/1/widgets/' . $blog_widget->id,
            method => 'DELETE',
            setup  => sub {
                die if !$app->model('template')->load( $blog_widget->id );
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
                my $widget
                    = $app->model('template')->load( $blog_widget->id );
                is( $widget, undef, 'Deleted widget.' );
            },
        },
    ];
}

