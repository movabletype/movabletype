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
use JSON;
use Test::Deep qw(cmp_bag);

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

use MT::FileMgr;
my $fmgr = MT::FileMgr->new('Local');

my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

my $blog = $app->model('blog')->load(1);

# Since MT::WeblogPublisher avoids rewriting files with mtime >= start_time, we should make sure the existing 
# files created by ->prepare_fixture are old enough for publish tests.
sleep 1;

my $start_time = MT::Util::ts2iso( $blog, MT::Util::epoch2ts( $blog, time() ), 1 );
my @cd_ids = (1,2,3);
my @rest_ids;

# Load templates start
my $template_class = $app->model('template');

my $blog_individual_tmpl
    = $template_class->load( { blog_id => 1, type => 'individual' } )
    or die $template_class->errstr;
my $blog_individual_tmpl_id = $blog_individual_tmpl->id;

my $blog_index_tmpl
    = $template_class->load( { blog_id => 1, type => 'index' } )
    or die $template_class->errstr;
my $blog_index_tmpl_id = $blog_index_tmpl->id;

my $blog_archive_tmpl
    = $template_class->load( { blog_id => 1, type => 'archive' } )
    or die $template_class->errstr;
my $blog_archive_tmpl_id = $blog_archive_tmpl->id;

# Load templates end

test_data_api([
    {   path      => '/v1/publish/entries',
        method    => 'GET',
        params    => { ids => join(',', @cd_ids) },
        callbacks => [
            {   name  => 'MT::App::DataAPI::pre_build',
                count => 1,
            },
        ],
        next_phase_url => qr{/publish/entries\?.*ids=\d},
        complete => sub { 
            my ($data, $body, $headers) = @_;
            my $res = decode_json($body);
            @rest_ids = split(',', $res->{restIds});
            cmp_bag(\@rest_ids, \@cd_ids);
            sleep 1;
        },
    },
]);

test_data_api([
    {   path   => '/v1/publish/entries',
        method => 'GET',
        params => {
            startTime => $start_time,
            ids       => join(',', @rest_ids),
        },
        setup => sub {
            my ($data) = @_;

            $data->{rebuild_entry} = 0;

            $data->{mock} = Test::MockModule->new('MT::App');
            $data->{mock}->mock(
                'rebuild_entry',
                sub {
                    $data->{rebuild_entry}++;
                    $data->{mock}->original('rebuild_entry')->(@_);
                }
            );
        },
        callbacks => [
            {   name  => 'build_file_filter',
                count => 10,
            },
        ],
        next_phase_url => qr{/publish/entries\?.*ids=(\D|$)},
        result         => +{
            startTime => $start_time,
            restIds   => '',
            status    => 'Rebuilding',
        },
        complete => sub {
            my ($data) = @_;
            is( $data->{rebuild_entry}, 3, 'MT::App::rebuild_entry is called once' );
            delete $data->{mock};
        },
    },
]);

test_data_api([
    {   path   => '/v1/publish/entries',
        method => 'GET',
        params => {
            startTime => $start_time,
            ids       => '',
            blogIds   => 1,
        },
        setup => sub {
            my ($data) = @_;

            $data->{rebuild_indexes} = 0;

            $data->{mock} = Test::MockModule->new('MT::App');
            $data->{mock}->mock(
                'rebuild_indexes',
                sub {
                    $data->{rebuild_indexes}++;
                    $data->{mock}->original('rebuild_indexes')->(@_);
                }
            );
        },
        callbacks => [
            {   name  => 'build_file_filter',
                count => 6,
            },
        ],
        result => +{
            startTime => $start_time,
            restIds   => '',
            status    => 'Complete',
        },
        complete => sub {
            my ($data) = @_;

            is( $data->{rebuild_indexes},
                1, 'MT::App::rebuild_indexes is called once' );
            delete $data->{mock};
        },
    },
]);

test_data_api([
    {   path => "/v2/sites/1/templates/$blog_individual_tmpl_id/publish",
        method => 'POST',
        setup  => sub {
            my ($data) = @_;

            my $fi = $app->model('fileinfo')
                ->load( { template_id => $blog_individual_tmpl_id } );
            $fmgr->delete( $fi->file_path );

            $data->{template_file_path} = $fi->file_path;
        },
        result   => { status => 'success' },
        complete => sub {
            my ( $data, $body ) = @_;

            my $file_path = $data->{template_file_path};
            ok( $fmgr->exists($file_path), "'$file_path' exists." );
        },
    },
]);

test_data_api([
    {   path   => "/v2/sites/1/templates/$blog_index_tmpl_id/publish",
        method => 'POST',
        setup  => sub {
            my ($data) = @_;

            my $fi = $app->model('fileinfo')
                ->load( { template_id => $blog_index_tmpl_id } );
            $fmgr->delete( $fi->file_path );

            $data->{template_file_path} = $fi->file_path;
        },
        result   => { status => 'success' },
        complete => sub {
            my ( $data, $body ) = @_;

            my $file_path = $data->{template_file_path};
            ok( $fmgr->exists($file_path), "'$file_path' exists." );
        },
    },
]);

test_data_api([
    {   path   => "/v2/sites/1/templates/$blog_archive_tmpl_id/publish",
        method => 'POST',
        setup  => sub {
            my ($data) = @_;

            my $fi = $app->model('fileinfo')
                ->load( { template_id => $blog_archive_tmpl_id } );
            $fmgr->delete( $fi->file_path );

            $data->{template_file_path} = $fi->file_path;
        },
        result   => { status => 'success' },
        complete => sub {
            my ( $data, $body ) = @_;

            my $file_path = $data->{template_file_path};
            ok( $fmgr->exists($file_path), "'$file_path' exists." );
        },
    },
]);

done_testing;
