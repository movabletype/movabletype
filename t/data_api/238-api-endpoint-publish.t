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

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

use MT::FileMgr;
my $fmgr = MT::FileMgr->new('Local');

my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

my $blog = $app->model('blog')->load(1);
my $start_time
    = MT::Util::ts2iso( $blog, MT::Util::epoch2ts( $blog, time() ), 1 );

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

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[
        {   path      => '/v1/publish/entries',
            method    => 'GET',
            params    => { ids => '1', },
            callbacks => [
                {   name  => 'MT::App::DataAPI::pre_build',
                    count => 1,
                },
            ],
            next_phase_url => qr{/publish/entries\?.*ids=1},
        },
        {   path   => '/v1/publish/entries',
            method => 'GET',
            params => {
                startTime => $start_time,
                ids       => '1',
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
                    count => 9,
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

                is( $data->{rebuild_entry},
                    1, 'MT::App::rebuild_entry is called once' );
                delete $data->{mock};
            },
        },
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
    ];
}

