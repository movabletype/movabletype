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

use MT::Test::DataAPI;

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

use MT::FileMgr;
my $fmgr = MT::FileMgr->new('Local');

# preparation.
my $mock_perm   = Test::MockModule->new('MT::Permission');
my $mock_author = Test::MockModule->new('MT::Author');

my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

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
        {    # Not logged in.
            path      => '/v2/sites/2/templates',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/2/templates',
            method => 'POST',
            params => {
                template => {
                    name       => 'create-template',
                    type       => 'index',
                    outputFile => 'create_template.html',
                },
            },
            restrictions => {
                0 => [qw/ edit_templates /],
                2 => [qw/ edit_templates /],
            },
            code  => 403,
            error => 'Do not have permission to create a template.',
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
            complete => sub {
                my $count
                    = $app->model('log')->count( { level => 4 } );    # ERROR
                is( $count, 0, 'No error occurs.' );
                $app->model('log')->remove( { level => 4 } );
            },
        },

        # list_templates - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/5/templates',
            method => 'GET',
            code   => 404,
        },
        {    # Not logged in.
            path      => '/v2/sites/2/templates',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/2/templates',
            method       => 'GET',
            restrictions => { 0 => [qw/ edit_templates /], },
            code         => 403,
            error =>
                'Do not have permission to retrieve the list of templates.',
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

 #        # list_all_templates - irregular tests.
 #        {    # Not logged in.
 #            path      => '/v2/templates',
 #            method    => 'GET',
 #            author_id => 0,
 #            code      => 401,
 #            error     => 'Unauthorized',
 #        },
 #        {    # No permissions.
 #            path         => '/v2/templates',
 #            method       => 'GET',
 #            restrictions => {
 #                0 => [qw/ edit_templates /],
 #                1 => [qw/ edit_templates /],
 #                2 => [qw/ edit_templates /],
 #            },
 #            code => 403,
 #            error =>
 #                'Do not have permission to retrieve the list of templates.',
 #        },
 #
 #        # list_all_templates - normal tests
 #        {   path   => '/v2/templates',
 #            method => 'GET',
 #            result => sub {
 #                my @terms_args = (
 #                    { type => { not => [qw/ backup widget widgetset /] }, },
 #                    {   sort      => 'blog_id',
 #                        direction => 'ascend',
 #                        limit     => 10,
 #                    },
 #                );
 #
 #                my $total_results
 #                    = $app->model('template')->count(@terms_args);
 #                my @tmpl = $app->model('template')->load(@terms_args);
 #
 #                $app->user($author);
 #
 #                return +{
 #                    totalResults => $total_results,
 #                    items => MT::DataAPI::Resource->from_object( \@tmpl ),
 #                };
 #            },
 #        },

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
        {    # Not logged in.
            path      => '/v2/sites/2/templates/' . $website_tmpl_module->id,
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/2/templates/' . $website_tmpl_module->id,
            method => 'GET',
            restrictions => {
                0 => [qw/ edit_templates /],
                2 => [qw/ edit_templates /],
            },
            code => 403,
            error =>
                'Do not have permission to retrieve the requested template.',
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
        {    # Not logged in.
            path      => '/v2/sites/2/templates/' . $website_tmpl_module->id,
            method    => 'PUT',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/2/templates/' . $website_tmpl_module->id,
            method => 'PUT',
            params => { template => { name => 'update-template', }, },
            restrictions => {
                0 => [qw/ edit_templates /],
                2 => [qw/ edit_templates /],
            },
            code  => 403,
            error => 'Do not have permission to update a template.',
        },

        # update_template - normal tests
        {   path   => '/v2/sites/2/templates/' . $website_tmpl_module->id,
            method => 'PUT',
            params => { template => { name => 'update-template', }, },
            result => sub {
                $app->model('template')->load( $website_tmpl_module->id );
            },
            complete => sub {
                my $count
                    = $app->model('log')->count( { level => 4 } );    # ERROR
                is( $count, 0, 'No error occurs.' );
                $app->model('log')->remove( { level => 4 } );
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
        {    # Not logged in.
            path      => '/v2/sites/2/templates/' . $website_tmpl_module->id,
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/2/templates/' . $website_tmpl_module->id,
            method => 'DELETE',
            restrictions => {
                0 => [qw/ edit_templates /],
                2 => [qw/ edit_templates /],
            },
            code  => 403,
            error => 'Do not have permission to delete a template.',
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
        {
            # Not logged in.
            path => '/v2/sites/1/templates/'
                . $blog_index_tmpl->id
                . '/publish',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path => '/v2/sites/1/templates/'
                . $blog_index_tmpl->id
                . '/publish',
            method       => 'POST',
            restrictions => { 1 => [qw/ administer_site rebuild /], },
            code         => 403,
            error        => 'Do not have permission to publish a template.',
        },

        # publish_template - normal tests
        {    # Index template.
            path => '/v2/sites/1/templates/'
                . $blog_index_tmpl->id
                . '/publish',
            method => 'POST',
            setup  => sub {
                my ($data) = @_;

                my $fi = $app->model('fileinfo')
                    ->load( { template_id => $blog_index_tmpl->id } );
                $fmgr->delete( $fi->file_path );

                $data->{template_file_path} = $fi->file_path;
            },
            result => sub {
                return +{ status => 'success' };
            },
            complete => sub {
                my ( $data, $body ) = @_;

                my $file_path = $data->{template_file_path};
                ok( $fmgr->exists($file_path), "'$file_path' exists." );
            },
        },

        # refresh_template - irregular tests
        {   path   => '/v2/sites/1/templates/300/refresh',
            method => 'POST',
            code   => 404,
        },
        {    # Not logged in.
            path => '/v2/sites/1/templates/'
                . $blog_index_tmpl->id
                . '/refresh',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path => '/v2/sites/1/templates/'
                . $blog_index_tmpl->id
                . '/refresh',
            method => 'POST',
        },

        # refresh_template - normal tests
        {   path => '/v2/sites/1/templates/'
                . $blog_index_tmpl->id
                . '/refresh',
            method => 'POST',
            setup  => sub {
                $blog_index_tmpl->text(
                    'This template has not been refreshed!');
                $blog_index_tmpl->save or die $blog_index_tmpl->errstr;
            },
            complete => sub {
                my $refreshed_blog_index_tmpl
                    = $app->model('template')->load( $blog_index_tmpl->id );
                isnt(
                    $refreshed_blog_index_tmpl->text,
                    $blog_index_tmpl->text,
                    'Template has been refreshed.'
                );
            },
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
        {    # Not logged in.
            path      => '/v2/sites/2/refresh_templates',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },

        # No error occurs with no permissions in this endpoint.

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
        {    # Not logged in.
            path => '/v2/sites/1/templates/'
                . $blog_index_tmpl->id
                . '/clone',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path => '/v2/sites/1/templates/'
                . $blog_index_tmpl->id
                . '/clone',
            method       => 'POST',
            restrictions => {
                0 => [qw/ edit_templates administer_site /],
                1 => [qw/ edit_templates administer_site /],
            },
            code  => 403,
            error => 'Do not have permission to clone a template.',
        },

        # clone_template - normal tests
        {   path => '/v2/sites/1/templates/'
                . $blog_index_tmpl->id
                . '/clone',
            method => 'POST',
            setup  => sub {
                my ($data) = @_;
                $data->{tmpl_count} = $app->model('template')->count(
                    {   blog_id => 1,
                        type => [qw/ index archive individual page category /]
                    }
                );
            },
            result => sub {
                return +{ status => 'success' };
            },
            complete => sub {
                my ( $data, $body ) = @_;
                my $tmpl_count = $app->model('template')->count(
                    {   blog_id => 1,
                        type => [qw/ index archive individual page category /]
                    }
                );
                is( $tmpl_count, $data->{tmpl_count} + 1,
                    'Cloned template.' );
            },
        },

        # preview_template_by_id
        {    # Non-existent template.
            path   => '/v2/sites/2/templates/500/preview',
            method => 'POST',
            params => {
                template => {
                    name => 'update-template',
                    type => 'custom',
                },
            },
            code => 404,
        },
        {    # No resource.
            path => sprintf( '/v2/sites/1/templates/%d/preview',
                $blog_index_tmpl->id ),
            method => 'POST',
            code   => 400,
            result => sub {
                return +{
                    error => {
                        code    => 400,
                        message => 'A resource "template" is required.',
                    },
                };
            },
        },
        {    # Not logged in.
            path => '/v2/sites/2/templates/'
                . $website_tmpl_module->id
                . '/preview',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path => '/v2/sites/1/templates/'
                . $blog_index_tmpl->id
                . '/preview',
            method       => 'POST',
            params       => { template => { name => 'preview-template', }, },
            restrictions => {
                0 => [qw/ edit_templates administer_site /],
                1 => [qw/ edit_templates administer_site /],
            },
            code  => 403,
            error => 'Do not have permission to get template preview.',
        },
        {    # normal tests
            path => '/v2/sites/1/templates/'
                . $blog_index_tmpl->id
                . '/preview',
            params => {
                template => {
                    name => 'preview-template',
                    text => 'template_body:<mt:BlogID>'
                },
            },
            method   => 'POST',
            complete => sub {
                my ( $data, $body ) = @_;
                my $obj = MT::Util::from_json($body);
                is( $obj->{status}, 'success',
                    'Preview Template make success' );
            },
        },
        {    # normal tests - raw parameter
            path => '/v2/sites/1/templates/'
                . $blog_index_tmpl->id
                . '/preview',
            params => {
                template => {
                    name => 'preview-template',
                    text => 'template_body:<mt:BlogID>'
                },
                raw => '1',
            },
            method   => 'POST',
            complete => sub {
                my ( $data, $body ) = @_;
                my $obj = MT::Util::from_json($body);
                is( $obj->{status}, 'success',
                    'Preview Template make success' );
            },
        },

        # preview_template
        {    # No resource.
            path   => '/v2/sites/2/templates/preview',
            method => 'POST',
            code   => 400,
            result => sub {
                return +{
                    error => {
                        code    => 400,
                        message => 'A resource "template" is required.',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/2/templates/preview',
            method    => 'POST',
            params    => { template => { name => 'preview-template', }, },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/1/templates/preview',
            method => 'POST',
            params => {
                template => {
                    name => 'preview-template',
                    text => 'template_body:<mt:BlogID>'
                },
            },
            restrictions => {
                0 => [qw/ edit_templates administer_site /],
                1 => [qw/ edit_templates administer_site /],
            },
            code  => 403,
            error => 'Do not have permission to get template preview.',
        },
        {    # normal tests
            path   => '/v2/sites/1/templates/preview',
            params => {
                template => {
                    name => 'preview-template',
                    text => 'template_body:<mt:BlogID>',
                    type => 'index',
                },
            },
            method   => 'POST',
            complete => sub {
                my ( $data, $body ) = @_;
                my $obj = MT::Util::from_json($body);
                is( $obj->{status}, 'success',
                    'Preview Template make success' );
            },
        },
        {    # normal tests - raw parameter
            path   => '/v2/sites/1/templates/preview',
            params => {
                template => {
                    name => 'preview-template',
                    text => 'template_body:<mt:BlogID>',
                    type => 'index',
                },
                raw => '1',
            },
            method   => 'POST',
            complete => sub {
                my ( $data, $body ) = @_;
                my $obj = MT::Util::from_json($body);
                is( $obj->{status}, 'success',
                    'Preview Template make success' );
            },
        },

    ];
}

