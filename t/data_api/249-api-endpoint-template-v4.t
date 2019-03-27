#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
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

# test.
my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        {    # Invalid type.
            path   => "/v2/sites/$blog_id/templates",
            method => 'POST',
            params => {
                template => {
                    name => 'create-template',
                    type => 'ct',
                },
            },
            code  => 409,
            error => "Invalid type: ct\n",
        },
        {    # No contentType
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
        {   path   => "/v4/sites/$blog_id/templates",
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
        {   path   => "/v4/sites/$blog_id/templates",
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

        {   path   => "/v2/sites/$blog_id/templates/" . $ct_tmpl[0]->id,
            method => 'PUT',
            params => { template => { name => 'update-ct-template', }, },
            result => sub {
                $app->model('template')->load( $ct_tmpl[0]->id );
            },
            complete => sub {
                my $count
                    = $app->model('log')->count( { level => 4 } );    # ERROR
                is( $count, 0, 'No error occurs.' );
                $app->model('log')->remove( { level => 4 } );
            },
        },
        {   path   => "/v2/sites/$blog_id/templates/" . $ct_tmpl[0]->id,
            method => 'PUT',
            params =>
                { template => { contentType => { id => $ct[1]->id }, }, },
            result => sub {
                my $tmpl = $app->model('template')->load( $ct_tmpl[0]->id );
                isnt $tmpl->content_type_id => $ct[1]->id;    # not updated
                $tmpl;
            },
            complete => sub {
                my $count
                    = $app->model('log')->count( { level => 4 } );    # ERROR
                is( $count, 0, 'No error occurs.' );
                $app->model('log')->remove( { level => 4 } );
            },
        },
        {   path   => "/v4/sites/$blog_id/templates/" . $ct_tmpl[0]->id,
            method => 'PUT',
            params =>
                { template => { contentType => { id => $ct[1]->id, }, }, },
            result => sub {
                my $tmpl = $app->model('template')->load( $ct_tmpl[0]->id );
                is $tmpl->content_type_id => $ct[0]->id;
                $tmpl;
            },
            complete => sub {
                my $count
                    = $app->model('log')->count( { level => 4 } );    # ERROR
                is( $count, 0, 'No error occurs.' );
                $app->model('log')->remove( { level => 4 } );
            },
        },

        {   path   => "/v2/sites/$blog_id/templates/" . $ct_tmpl[0]->id,
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

        {   path => "/v2/sites/$blog_id/templates/"
                . $ct_tmpl[1]->id
                . '/publish',
            method => 'POST',
            code   => 400,
            error  => "Cannot publish ct template.",
        },
        {   path => "/v4/sites/$blog_id/templates/"
                . $ct_tmpl[1]->id
                . '/publish',
            method => 'POST',
            setup  => sub {
                my $fi = $app->model('fileinfo')
                    ->load( { template_id => $ct_tmpl[1]->id } );

                my $file_path = $fi->file_path;
                $fmgr->delete($file_path);
            },
            result => sub {
                return +{ status => 'success' };
            },
            complete => sub {
                my ( $data, $body ) = @_;
                my $fi = $app->model('fileinfo')
                    ->load( { template_id => $ct_tmpl[1]->id } );

                my $file_path = $fi->file_path;
                ok( $fmgr->exists($file_path), "'$file_path' exists." );
            },
        },

        {   path => "/v2/sites/$blog_id/templates/"
                . $ct_tmpl[1]->id
                . '/clone',
            method => 'POST',
            code   => 400,
            error  => "Cannot clone ct template.",
        },
        {   path => "/v4/sites/$blog_id/templates/"
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
    ];
}
