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

$test_env->prepare_fixture('content_data/dirty');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

use MT::FileMgr;
my $fmgr = MT::FileMgr->new('Local');

my $blog = $app->model('blog')->load( { name => 'My Site' } );
my $blog_id = $blog->id;

sleep 1;
$test_env->clear_mt_cache;

my $start_time = MT::Util::ts2iso($blog, MT::Util::epoch2ts($blog, time()), 1);
my @cd_ids     = (1, 2, 3);
my @rest_ids;

my $tmpl = $app->model('template')->load( {
    blog_id => $blog_id, name => "tmpl_contenttype_test content data",
} );
my $tmpl_id = $tmpl->id;

test_data_api([
    {   path      => '/v4/publish/contentData',
        method    => 'GET',
        params    => { ids => join(',', @cd_ids) },
        callbacks => [
            {   name  => 'MT::App::DataAPI::pre_build',
                count => 1,
            },
        ],
        next_phase_url => qr{/publish/contentData\?.*ids=\d},
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
    {   path   => '/v4/publish/contentData',
        method => 'GET',
        params => { startTime => $start_time, ids => join(',', @rest_ids) },
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
                count => 28,
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
]);

test_data_api([
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
]);

test_data_api([
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
]);

done_testing;
