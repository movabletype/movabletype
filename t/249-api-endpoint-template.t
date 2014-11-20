#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib extlib t/lib);

use Test::More;
use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

# preparation.
my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

my $mock_author = Test::MockModule->new('MT::Author');
$mock_author->mock( 'is_superuser', sub {0} );
my $mock_app_api = Test::MockModule->new('MT::App::DataAPI');
$mock_app_api->mock( 'authenticate', $author );
my $version;
$mock_app_api->mock( 'current_api_version',
    sub { $version = $_[1] if $_[1]; $version } );

my $tmpl_class = $app->model('template');

my $email_tmpl = $tmpl_class->load( { blog_id => 0, type => 'email' } )
    or die $tmpl_class->errstr;
my $blog_index_tmpl = $tmpl_class->load( { blog_id => 1, type => 'index' } )
    or die $tmpl_class->errstr;
my $blog_tmpl_module = $tmpl_class->load( { blog_id => 1, type => 'custom' } )
    or die $tmpl_class->errstr;
my $website_tmpl_module
    = $tmpl_class->load( { blog_id => 2, type => 'custom' } )
    or die $tmpl_class->errstr;
my $system_tmpl = $tmpl_class->new;
$system_tmpl->set_values(
    {   blog_id    => 0,
        name       => 'system template',
        identifier => 'system_template',
        type       => 'system_template',
    }
);
$system_tmpl->save or die $system_tmpl->errstr;

# test.
my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # create_template - irregular tests
        {    # No resource.
            path   => '/v2/sites/2/templates',
            method => 'POST',
            code   => 400,
            error  => 'A resource "template" is required.',
        },
        {    # No name.
            path   => '/v2/sites/2/templates',
            method => 'POST',
            params => { template => {}, },
            code   => 409,
            error  => "A parameter \"name\" is required.\n",
        },
        {    # No type.
            path   => '/v2/sites/2/templates',
            method => 'POST',
            params => { template => { name => 'create-template', }, },
            code   => 409,
            error  => "A parameter \"type\" is required.\n",
        },
        {    # Invalid type.
            path   => '/v2/sites/2/templates',
            method => 'POST',
            params => {
                template => {
                    name => 'create-template',
                    type => 'invalid-type',
                },
            },
            code  => 409,
            error => "Invalid type: invalid-type\n",
        },
        {    # Invalid type (system).
            path   => '/v2/sites/0/templates',
            method => 'POST',
            params => {
                template => {
                    name => 'create-template',
                    type => 'index',
                },
            },
            code  => 409,
            error => "Invalid type: index\n",
        },
        {    # No outputFile.
            path   => '/v2/sites/2/templates',
            method => 'POST',
            params => {
                template => {
                    name => 'create-template',
                    type => 'index',
                },
            },
            code  => 409,
            error => "A parameter \"outputFile\" is required.\n",
        },

        # create_template - normal tests
        {   path   => '/v2/sites/2/templates',
            method => 'POST',
            setup  => sub {
                die
                    if $app->model('template')->exist(
                    {   blog_id => 2,
                        name    => 'create-template',
                    }
                    );
            },
            params => {
                template => {
                    name       => 'create-template',
                    type       => 'index',
                    outputFile => 'create_template.html',
                },
            },
            result => sub {
                $app->model('template')->load(
                    {   blog_id => 2,
                        name    => 'create-template',
                        outfile => 'create_template.html',
                    }
                );
            },
        },

        # list_templates - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/5/templates',
            method => 'GET',
            code   => 404,
        },

        # list_templates - normal tests
        {   path   => '/v2/sites/2/templates',
            method => 'GET',
            result => sub {
                my @terms_args = (
                    {   blog_id => 2,
                        type    => { not => [qw( backup widget widgetset )] },
                    },
                    {   sort      => 'name',
                        direction => 'ascend',
                        limit     => 10,
                    },
                );

                my $total_results
                    = $app->model('template')->count(@terms_args);
                my @tmpl = $app->model('template')->load(@terms_args);

                $app->user($author);

                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};

                return +{
                    totalResults => $total_results,
                    items => MT::DataAPI::Resource->from_object( \@tmpl ),
                };
            },
        },
        {    # Search name.
            path   => '/v2/sites/2/templates',
            method => 'GET',
            params => {
                searchFields => 'name',
                search       => 'create-template',
            },
            result => sub {
                my @tmpl = $app->model('template')->load(
                    {   blog_id => 2,
                        name    => { like => '%create-template%' },
                    },
                    {   sort      => 'name',
                        direction => 'ascend',
                    },
                );

                $app->user($author);

                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};

                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( \@tmpl ),
                };
            },
        },
        {    # Search identifier.
            path   => '/v2/sites/2/templates',
            method => 'GET',
            params => {
                searchFields => 'templateType',
                search       => 'banner_footer',
            },
            result => sub {
                my @tmpl = $app->model('template')->load(
                    {   blog_id    => 2,
                        identifier => { like => '%banner_footer%' },
                    },
                    {   sort      => 'name',
                        direction => 'ascend',
                    },
                );

                $app->user($author);

                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};

                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( \@tmpl ),
                };
            },
        },
        {    # Search text.
            path   => '/v2/sites/2/templates',
            method => 'GET',
            params => {
                searchFields => 'text',
                search       => 'DOCTYPE',
            },
            result => sub {
                my @terms_args = (
                    {   blog_id => 2,
                        text    => { like => '%DOCTYPE%' },
                    },
                    {   sort      => 'name',
                        direction => 'ascend',
                        limit     => 10,
                    },
                );

                my $total_count = $app->model('template')->count(@terms_args);
                my @tmpl        = $app->model('template')->load(@terms_args);

                $app->user($author);

                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};

                return +{
                    totalResults => $total_count,
                    items => MT::DataAPI::Resource->from_object( \@tmpl ),
                };
            },
        },
        {    # Filter by type.
            path   => '/v2/sites/2/templates',
            method => 'GET',
            params => { type => 'index', },
            result => sub {
                my @tmpl = $app->model('template')->load(
                    {   blog_id => 2,
                        type    => 'index',
                    },
                    {   sort      => 'name',
                        direction => 'ascend',
                    },
                );

                $app->user($author);

                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};

                return +{
                    totalResults => scalar @tmpl,
                    items => MT::DataAPI::Resource->from_object( \@tmpl ),
                };
            },
        },
        {    # Sort by id.
            path   => '/v2/sites/2/templates',
            method => 'GET',
            params => { sortBy => 'id', },
        },
        {    # Sort by created_on.
            path   => '/v2/sites/2/templates',
            method => 'GET',
            params => { sortBy => 'created_on', },
        },
        {    # Sort by modified_on.
            path   => '/v2/sites/2/templates',
            method => 'GET',
            params => { sortBy => 'modified_on', },
        },
        {    # Sort by created_by.
            path   => '/v2/sites/2/templates',
            method => 'GET',
            params => { sortBy => 'created_by', },
        },
        {    # Sort by modified_by.
            path   => '/v2/sites/2/templates',
            method => 'GET',
            params => { sortBy => 'modified_by', },
        },
        {    # Sort by type.
            path   => '/v2/sites/2/templates',
            method => 'GET',
            params => { sortBy => 'type', },
        },

        # list_all_templates - normal tests
        {   path   => '/v2/templates',
            method => 'GET',
            result => sub {
                my @terms_args = (
                    { type => { not => [qw/ backup widget widgetset /] }, },
                    {   sort      => 'blog_id',
                        direction => 'ascend',
                        limit     => 10,
                    },
                );

                my $total_results
                    = $app->model('template')->count(@terms_args);
                my @tmpl = $app->model('template')->load(@terms_args);

                $app->user($author);

                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};

                return +{
                    totalResults => $total_results,
                    items => MT::DataAPI::Resource->from_object( \@tmpl ),
                };
            },
        },

        # get_template - irregular tests
        {    # Non-existent template.
            path   => '/v2/sites/2/templates/300',
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/templates/' . $website_tmpl_module->id,
            method => 'GET',
            code   => 404,
        },
        {    # Other site.
            path   => '/v2/sites/1/templates/' . $website_tmpl_module->id,
            method => 'GET',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v2/sites/0/templates/' . $website_tmpl_module->id,
            method => 'GET',
            code   => 404,
        },

        # get_template - normal tests
        {   path   => '/v2/sites/2/templates/' . $website_tmpl_module->id,
            method => 'GET',
            result => sub {
                $website_tmpl_module;
            },
        },

        # update_template - irregular tests
        {    # Non-existent template.
            path   => '/v2/sites/2/templates/500',
            method => 'PUT',
            params => {
                template => {
                    name => 'update-template',
                    type => 'custom',
                },
            },
            code => 404,
        },

        # update_template - normal tests
        {   path   => '/v2/sites/2/templates/' . $website_tmpl_module->id,
            method => 'PUT',
            params => { template => { name => 'update-template', }, },
            result => sub {
                $app->model('template')->load( $website_tmpl_module->id );
            },
        },

        # delete_template - irregular tests
        {    # Non-existent template.
            path   => '/v2/sites/2/templates/300',
            method => 'DELETE',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/templates/' . $website_tmpl_module->id,
            method => 'DELETE',
            code   => 404,
        },
        {    # Other site.
            path   => '/v2/sites/1/templates/' . $website_tmpl_module->id,
            method => 'DELETE',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v2/sites/0/templates/' . $website_tmpl_module->id,
            method => 'DELETE',
            code   => 404,
        },
        {    # Email template.
            path   => '/v2/sites/0/templates/' . $email_tmpl->id,
            method => 'DELETE',
            code   => 403,
        },
        {    # System template.
            path   => '/v2/sites/0/templates/' . $system_tmpl->id,
            method => 'DELETE',
            code   => 403,
        },

        # delete_template - normal tests
        {   path   => '/v2/sites/2/templates/' . $website_tmpl_module->id,
            method => 'DELETE',
            setup  => sub {
                die
                    if !$app->model('template')
                    ->load( $website_tmpl_module->id );
            },
            complete => sub {
                my $tmpl
                    = $app->model('template')
                    ->load( $website_tmpl_module->id );
                is( $tmpl, undef, 'Deleted template.' );
            },
        },

        # publish_template - irregular tests
        {    # Template module.
            path => '/v2/sites/1/templates/'
                . $blog_tmpl_module->id
                . '/publish',
            method => 'POST',
            code   => 400,
        },

        # publish_template - normal tests
        {    # Index template.
            path => '/v2/sites/1/templates/'
                . $blog_index_tmpl->id
                . '/publish',
            method => 'POST',
            result => sub {
                return +{ status => 'success' };
            },
        },

        # refresh_template - irregular tests
        {   path   => '/v2/sites/1/templates/300/refresh',
            method => 'POST',
            code   => 404,
        },

        # refresh_template - normal tests
        {   path => '/v2/sites/1/templates/'
                . $blog_index_tmpl->id
                . '/refresh',
            method => 'POST',
        },

        # refresh_templates_for_site - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/5/refresh_templates',
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
        {    # Invalid parameter.
            path   => '/v2/sites/2/refresh_templates',
            method => 'POST',
            params => { refresh_type => 'dummy', },
            code   => 400,
            result => sub {
                +{  error => {
                        code => 400,
                        message =>
                            'A parameter "refresh_type" is invalid: dummy',
                    },
                };
            },
        },

        # refresh_templates_for_site - normal tests
        {    # Website.
            path   => '/v2/sites/2/refresh_templates',
            method => 'POST',
            result => sub {
                +{ status => 'success' };
            },
        },
        {    # Blog.
            path   => '/v2/sites/1/refresh_templates',
            method => 'POST',
            result => sub {
                +{ status => 'success' };
            },
        },
        {    # System.
            path   => '/v2/sites/0/refresh_templates',
            method => 'POST',
            result => sub {
                +{ status => 'success' };
            },
        },

        {    # Back up.
            path   => '/v2/sites/2/refresh_templates',
            method => 'POST',
            params => { backup => 1, },
            result => sub {
                +{ status => 'success' };
            },
        },
        {    # Refresh.
            path   => '/v2/sites/2/refresh_templates',
            method => 'POST',
            params => { refresh_type => 'refresh', },
            result => sub {
                +{ status => 'success' };
            },
        },
        {    # Reset.
            path   => '/v2/sites/2/refresh_templates',
            method => 'POST',
            params => { refresh_type => 'clean', },
            result => sub {
                +{ status => 'success' };
            },
        },

        # clone_template - irregular tests
        {    # Email template.
            path   => '/v2/sites/0/templates/' . $email_tmpl->id . '/clone',
            method => 'POST',
            code   => 400,
        },
        {    # System template.
            path   => '/v2/sites/0/templates/' . $system_tmpl->id . '/clone',
            method => 'POST',
            code   => 400,
        },

        # clone_template - normal tests
        {   path => '/v2/sites/1/templates/'
                . $blog_index_tmpl->id
                . '/clone',
            method => 'POST',
            result => sub {
                return +{ status => 'success' };
            },
        },

    ];
}

