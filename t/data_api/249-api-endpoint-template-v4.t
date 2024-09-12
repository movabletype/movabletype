#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
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
use MT::Test::Fixture::ArchiveType;

$test_env->prepare_fixture('archive_type');

my $objs = MT::Test::Fixture::ArchiveType->load_objs;

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

my $blog_id = $objs->{blog_id} or die;

my @ct_tmpl = MT::Template->load( { blog_id => $blog_id, type => 'ct' } );
my @ct      = map { $_->content_type } @ct_tmpl;

my @ct_archive_tmpl
    = MT::Template->load( { blog_id => $blog_id, type => 'ct_archive' } );

# test.
my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # list_templates
        {   path   => "/v2/sites/$blog_id/templates",
            up_to  => 3,
            method => 'GET',
            result => sub {
                my @tmpl = MT::Template->load(
                    {   blog_id => $blog_id,
                        type    => {
                            not =>
                                [qw/ct ct_archive backup widget widgetset  /]
                        },
                    },
                    {   sort      => 'name',
                        direction => 'ascend',
                    },
                );
                +{  totalResults => scalar @tmpl,
                    items        => MT::DataAPI::Resource->from_object(
                        +[ @tmpl[ 0 .. 9 ] ]
                    ),
                };
            },
        },
        {   path   => "/v4/sites/$blog_id/templates",
            method => 'GET',
            result => sub {
                my @tmpl = MT::Template->load(
                    {   blog_id => $blog_id,
                        type => { not => [qw/ backup widget widgetset  /] },
                    },
                    {   sort      => 'name',
                        direction => 'ascend',
                    },
                );
                +{  totalResults => scalar @tmpl,
                    items        => MT::DataAPI::Resource->from_object(
                        +[ @tmpl[ 0 .. 9 ] ]
                    ),
                };
            },
        },

        # get_template
        {   path   => "/v2/sites/$blog_id/templates/" . $ct_tmpl[0]->id,
            up_to  => 3,
            method => 'GET',
            code   => 400,
            error  => 'Cannot get ct template.',
        },
        {   path => "/v2/sites/$blog_id/templates/" . $ct_archive_tmpl[0]->id,
            up_to  => 3,
            method => 'GET',
            code   => 400,
            error  => 'Cannot get ct_archive template.',
        },
        {   path   => "/v4/sites/$blog_id/templates/" . $ct_tmpl[0]->id,
            method => 'GET',
            result => sub { $ct_tmpl[0] },
        },
        {   path => "/v4/sites/$blog_id/templates/" . $ct_archive_tmpl[0]->id,
            method => 'GET',
            result => sub { $ct_archive_tmpl[0] },
        },

        # create_template
        {    # Wrong api version. (ct)
            path   => "/v2/sites/$blog_id/templates",
            up_to  => 3,
            method => 'POST',
            params => {
                template => {
                    name        => 'create-ct-template',
                    type        => 'ct',
                    contentType => { id => 1 },
                },
            },
            code  => 409,
            error => "Invalid type: ct\n",
        },
        {    # Wrong api version. (ct_archive)
            path   => "/v2/sites/$blog_id/templates",
            up_to  => 3,
            method => 'POST',
            params => {
                template => {
                    name        => 'create-ct-archive-template',
                    type        => 'ct_archive',
                    contentType => { id => 1 },
                },
            },
            code  => 409,
            error => "Invalid type: ct_archive\n",
        },
        {    # No contentType (ct)
            path   => "/v4/sites/$blog_id/templates",
            method => 'POST',
            params => {
                template => {
                    name => 'create-ct-template',
                    type => 'ct',
                },
            },
            code  => 409,
            error => "A parameter \"contentType\" is required.\n",
        },
        {    # No contentType (ct_archive)
            path   => "/v4/sites/$blog_id/templates",
            method => 'POST',
            params => {
                template => {
                    name => 'create-ct-archive-template',
                    type => 'ct_archive',
                },
            },
            code  => 409,
            error => "A parameter \"contentType\" is required.\n",
        },
        {    # ct
            path   => "/v4/sites/$blog_id/templates",
            method => 'POST',
            setup  => sub {
                die
                    if $app->model('template')->exist(
                    {   blog_id => $blog_id,
                        name    => 'create-ct-template',
                    }
                    );
            },
            params => {
                template => {
                    name        => 'create-ct-template',
                    type        => 'ct',
                    contentType => { id => 1 },
                },
            },
            result => sub {
                $app->model('template')->load(
                    {   blog_id => $blog_id,
                        name    => 'create-ct-template',
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
        {    # ct_archive
            path   => "/v4/sites/$blog_id/templates",
            method => 'POST',
            setup  => sub {
                die
                    if $app->model('template')->exist(
                    {   blog_id => $blog_id,
                        name    => 'create-ct-archive-template',
                    }
                    );
            },
            params => {
                template => {
                    name        => 'create-ct-archive-template',
                    type        => 'ct',
                    contentType => { id => 1 },
                },
            },
            result => sub {
                $app->model('template')->load(
                    {   blog_id => $blog_id,
                        name    => 'create-ct-archive-template',
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

        # update_template
        {    # Wrong api version. (ct)
            path   => "/v2/sites/$blog_id/templates/" . $ct_tmpl[0]->id,
            up_to  => 3,
            method => 'PUT',
            params => { template => { name => 'update-ct-template' }, },
            code   => 400,
            error  => 'Cannot update ct template.',
        },
        {    # Wrong api version. (ct_archive)
            path => "/v2/sites/$blog_id/templates/" . $ct_archive_tmpl[0]->id,
            up_to  => 3,
            method => 'PUT',
            params =>
                { template => { name => 'update-ct-archive-template' }, },
            code  => 400,
            error => 'Cannot update ct_archive template.',
        },
        {    # ct
            path   => "/v4/sites/$blog_id/templates/" . $ct_tmpl[0]->id,
            method => 'PUT',
            params => {
                template => {
                    name        => 'update-ct-template',
                    contentType => { id => $ct[1]->id },
                },
            },
            result => sub {
                my $tmpl = $app->model('template')->load( $ct_tmpl[0]->id );
                is $tmpl->name, 'update-ct-template';
                is $tmpl->content_type_id => $ct[0]->id;    # not updated
                $tmpl;
            },
            complete => sub {
                my $count
                    = $app->model('log')->count( { level => 4 } );    # ERROR
                is( $count, 0, 'No error occurs.' );
                $app->model('log')->remove( { level => 4 } );
            },
        },
        {    # ct_archive
            path => "/v4/sites/$blog_id/templates/" . $ct_archive_tmpl[0]->id,
            method => 'PUT',
            params => {
                template => {
                    name        => 'update-ct-archive-template',
                    contentType => { id => $ct[1]->id, },
                },
            },
            result => sub {
                my $tmpl = $app->model('template')
                    ->load( $ct_archive_tmpl[0]->id );
                is $tmpl->name, 'update-ct-archive-template';
                is $tmpl->content_type_id => $ct[0]->id;    # not updated
                $tmpl;
            },
            complete => sub {
                my $count
                    = $app->model('log')->count( { level => 4 } );    # ERROR
                is( $count, 0, 'No error occurs.' );
                $app->model('log')->remove( { level => 4 } );
            },
        },

        # delete_template
        {   path   => "/v2/sites/$blog_id/templates/" . $ct_tmpl[0]->id,
            up_to  => 3,
            method => 'DELETE',
            code   => 403,
            error  => "Cannot delete ct template.",
        },
        {   path   => "/v4/sites/$blog_id/templates/" . $ct_tmpl[0]->id,
            method => 'DELETE',
            setup  => sub {
                die
                    if !$app->model('template')->load( $ct_tmpl[0]->id );
            },
            complete => sub {
                my $tmpl = $app->model('template')->load( $ct_tmpl[0]->id );
                is( $tmpl, undef, 'Deleted template.' );
            },
        },

        # publish_template
        {    # v2 (ct)
            path => "/v2/sites/$blog_id/templates/"
                . $ct_tmpl[1]->id
                . '/publish',
            up_to  => 3,
            method => 'POST',
            code   => 400,
            error  => "Cannot publish ct template.",
        },
        {    # v2 (ct_archive)
            path => "/v2/sites/$blog_id/templates/"
                . $ct_archive_tmpl[1]->id
                . '/publish',
            up_to  => 3,
            method => 'POST',
            code   => 400,
            error  => 'Cannot publish ct_archive template.',
        },
        {    # v4 (ct)
            path => "/v4/sites/$blog_id/templates/"
                . $ct_tmpl[1]->id
                . '/publish',
            method => 'POST',
            setup  => sub {
                my $fi = $app->model('fileinfo')
                    ->load( { template_id => $ct_tmpl[1]->id } ) or return;

                my $file_path = $fi->file_path;
                $fmgr->delete($file_path);
            },
            result => sub {
                return +{ status => 'success' };
            },
            complete => sub {
                my ( $data, $body ) = @_;
                ok my $fi = $app->model('fileinfo')
                    ->load( { template_id => $ct_tmpl[1]->id } ) or return;

                my $file_path = $fi->file_path;
                ok( $fmgr->exists($file_path), "'$file_path' exists." );
            },
        },
        {    # v4 (ct_archive)
            path => "/v4/sites/$blog_id/templates/"
                . $ct_archive_tmpl[1]->id
                . '/publish',
            method => 'POST',
            setup  => sub {
                my $fi = $app->model('fileinfo')
                    ->load( { template_id => $ct_archive_tmpl[1]->id } ) or return;

                my $file_path = $fi->file_path;
                $fmgr->delete($file_path);
            },
            result => sub {
                return +{ status => 'success' };
            },
            complete => sub {
                my ( $data, $body ) = @_;
                ok my $fi = $app->model('fileinfo')
                    ->load( { template_id => $ct_archive_tmpl[1]->id } ) or return;

                my $file_path = $fi->file_path;
                ok( $fmgr->exists($file_path), "'$file_path' exists." );
            },
        },

        # refresh_template
        {    # v2 (ct)
            path => "/v2/sites/$blog_id/templates/"
                . $ct_tmpl[1]->id
                . '/refresh',
            up_to  => 3,
            method => 'POST',
            code   => 400,
            error  => 'Cannot refresh ct template.',
        },
        {    # v2 (ct_archive)
            path => "/v2/sites/$blog_id/templates/"
                . $ct_archive_tmpl[1]->id
                . '/refresh',
            up_to  => 3,
            method => 'POST',
            code   => 400,
            error  => 'Cannot refresh ct_archive template.',
        },
        {    # v4 (ct)
            path => "/v4/sites/$blog_id/templates/"
                . $ct_tmpl[1]->id
                . '/refresh',
            method => 'POST',
            result => sub {
                return +{
                    status   => 'success',
                    messages => [
                              "Skipping template '"
                            . $ct_tmpl[1]->name
                            . "' since it appears to be a custom template."
                    ],
                };
            },
        },
        {    # v4 (ct_archive)
            path => "/v4/sites/$blog_id/templates/"
                . $ct_archive_tmpl[1]->id
                . '/refresh',
            method => 'POST',
            result => sub {
                return +{
                    status   => 'success',
                    messages => [
                              "Skipping template '"
                            . $ct_archive_tmpl[1]->name
                            . "' since it appears to be a custom template."
                    ],
                };
            },
        },

        # clone_template
        {    # v2 (ct)
            path => "/v2/sites/$blog_id/templates/"
                . $ct_tmpl[1]->id
                . '/clone',
            up_to  => 3,
            method => 'POST',
            code   => 400,
            error  => "Cannot clone ct template.",
        },
        {    # v2 (ct_archive)
            path => "/v2/sites/$blog_id/templates/"
                . $ct_archive_tmpl[1]->id
                . '/clone',
            up_to  => 3,
            method => 'POST',
            code   => 400,
            error  => "Cannot clone ct_archive template.",
        },
        {    # v4 (ct)
            path => "/v4/sites/$blog_id/templates/"
                . $ct_tmpl[1]->id
                . '/clone',
            method => 'POST',
            setup  => sub {
                my ($data) = @_;
                $data->{tmpl_count} = $app->model('template')->count(
                    {   blog_id => $blog_id,
                        type    => [
                            qw/ index archive individual page category ct ct_archive /
                        ]
                    }
                );
            },
            result => sub {
                return +{ status => 'success' };
            },
            complete => sub {
                my ( $data, $body ) = @_;
                my $tmpl_count = $app->model('template')->count(
                    {   blog_id => $blog_id,
                        type    => [
                            qw/ index archive individual page category ct ct_archive /
                        ]
                    }
                );
                is( $tmpl_count, $data->{tmpl_count} + 1,
                    'Cloned template.' );
            },
        },
        {    # v4 (ct_archive)
            path => "/v4/sites/$blog_id/templates/"
                . $ct_archive_tmpl[1]->id
                . '/clone',
            method => 'POST',
            setup  => sub {
                my ($data) = @_;
                $data->{tmpl_count} = $app->model('template')->count(
                    {   blog_id => $blog_id,
                        type    => [
                            qw/ index archive individual page category ct ct_archive /
                        ]
                    }
                );
            },
            result => sub {
                return +{ status => 'success' };
            },
            complete => sub {
                my ( $data, $body ) = @_;
                my $tmpl_count = $app->model('template')->count(
                    {   blog_id => $blog_id,
                        type    => [
                            qw/ index archive individual page category ct ct_archive /
                        ]
                    }
                );
                is( $tmpl_count, $data->{tmpl_count} + 1,
                    'Cloned template.' );
            },
        },

        # preview_template_by_id
        {    # v2 (ct)
            path => "/v2/sites/$blog_id/templates/"
                . $ct_tmpl[1]->id
                . '/preview',
            up_to  => 3,
            method => 'POST',
            code   => 400,
            error  => 'Cannot preview ct template.',
        },
        {    # v2 (ct_archive)
            path => "/v2/sites/$blog_id/templates/"
                . $ct_archive_tmpl[1]->id
                . '/preview',
            up_to  => 3,
            method => 'POST',
            code   => 400,
            error  => 'Cannot preview ct_archive template.',
        },
        {    # v4 (ct)
            path => "/v4/sites/$blog_id/templates/"
                . $ct_tmpl[1]->id
                . '/preview',
            method => 'POST',
            code   => 400,
            error  => 'Cannot preview ct template.',
        },
        {    # v4 (ct_archive)
            path => "/v4/sites/$blog_id/templates/"
                . $ct_archive_tmpl[1]->id
                . '/preview',
            method => 'POST',
            code   => 400,
            error  => 'Cannot preview ct_archive template.',
        },
    ];
}
