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
use MT::Test::Fixture;

$test_env->prepare_fixture('content_data/dirty');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

use MT::FileMgr;
my $fmgr = MT::FileMgr->new('Local');

my $blog = $app->model('blog')->load( { name => 'My Site' } );
my $blog_id = $blog->id;

sleep 1;
$test_env->clear_mt_cache;

my $start_time
    = MT::Util::ts2iso( $blog, MT::Util::epoch2ts( $blog, time() ), 1 );

my $tmpl = $app->model('template')->load( {
    blog_id => $blog_id, name => "tmpl_contenttype_test content data",
} );
my $tmpl_id = $tmpl->id;

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[
        {   path      => '/v4/publish/contentData',
            method    => 'GET',
            params    => { ids => '1', },
            callbacks => [
                {   name  => 'MT::App::DataAPI::pre_build',
                    count => 1,
                },
            ],
            next_phase_url => qr{/publish/contentData\?.*ids=1},
            complete => sub { sleep 1 },
        },
        {   path   => '/v4/publish/contentData',
            method => 'GET',
            params => {
                startTime => $start_time,
                ids       => '1',
            },
            setup => sub {
                my ($data) = @_;

                $data->{rebuild_these_content_data} = 0;

                $data->{mock} = Test::MockModule->new('MT::App::CMS');
                $data->{mock}->mock(
                    'rebuild_these_content_data',
                    sub {
                        $data->{rebuild_these_content_data}++;
                        $data->{mock}->original('rebuild_these_content_data')->(@_);
                    }
                );
            },
            callbacks => [
                {   name  => 'build_file_filter',
                    count => 15,
                },
            ],
            next_phase_url => qr{/publish/contentData\?.*ids=(\D|$)},
            result         => +{
                startTime => $start_time,
                restIds   => '',
                status    => 'Rebuilding',
            },
            complete => sub {
                my ($data) = @_;

                is( $data->{rebuild_these_content_data},
                    1, 'MT::App::CMS::rebuild_these_content_data is called once' );
                delete $data->{mock};
                sleep 1;
            },
        },
        {   path   => '/v4/publish/contentData',
            method => 'GET',
            params => {
                startTime => $start_time,
                ids       => '',
                blogIds   => $blog_id,
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
                sleep 1;
            },
        },
        {   path => "/v4/sites/$blog_id/templates/$tmpl_id/publish",
            method => 'POST',
            setup  => sub {
                my ($data) = @_;

                my $fi = $app->model('fileinfo')
                    ->load( { template_id => $tmpl_id } );
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

