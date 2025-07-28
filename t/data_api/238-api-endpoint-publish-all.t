#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use Test::MockTime qw(set_fixed_time restore_time);
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::DataAPI;

use MT::FileMgr;
my $fmgr = MT::FileMgr->new('Local');

$test_env->prepare_fixture('db_data');

my $blog = MT->model('blog')->load(1);

sleep 1;
$test_env->clear_mt_cache;

set_fixed_time(time);
my $start_time = MT::Util::ts2iso($blog, MT::Util::epoch2ts($blog, time()), 1);

my $suite = suite();
test_data_api($suite);

restore_time();

done_testing;

sub suite {
    return +[{
            path   => '/v7/publish/all',
            method => 'POST',
            note   => "siteId is missing",
            params => {},
            code   => 400,
        },
        {
            path   => '/v7/publish/all',
            method => 'POST',
            note   => "Site not found",
            params => { siteId => 9999 },
            code   => 404,
        },
        {
            path      => '/v7/publish/all',
            method    => 'POST',
            note      => "Success case",
            params    => { siteId => $blog->id, },
            callbacks => [{
                    name  => 'MT::App::DataAPI::pre_build',
                    count => 1,
                },
            ],
            next_phase_url => qr{/publish/all\?.*siteId=1},
            code           => 200,
            result         => {
                status           => 'Rebuilding',
                startTime        => $start_time,
                restArchiveTypes => 'Individual,Monthly,Weekly,Daily,Category,Page,Author',
            },
        },
        {
            path   => '/v7/publish/all',
            method => 'POST',
            note   => "Success case with archiveType",
            params => {
                siteId       => $blog->id,
                archiveTypes => 'Individual'
            },
            next_phase_url => qr{/publish/all\?.*siteId=1},
            code           => 200,
            result         => {
                status           => 'Rebuilding',
                startTime        => $start_time,
                restArchiveTypes => 'Individual',
            },
        },
        {
            path   => '/v7/publish/all',
            method => 'POST',
            note   => "Success case with archiveType, startTime, offset and total",
            params => {
                siteId       => $blog->id,
                startTime    => $start_time,
                archiveTypes => 'Page',
                offset       => 0,
                total        => 4
            },
            config         => { EntriesPerRebuild => 1, },
            next_phase_url => qr{/publish/all\?.*siteId=1},
            code           => 200,
            result         => {
                status           => 'Rebuilding',
                startTime        => $start_time,
                restArchiveTypes => 'Page',
            },
        },
        {
            path   => '/v7/publish/all',
            method => 'POST',
            note   => "Success case with archiveType",
            params => {
                siteId       => $blog->id,
                startTime    => $start_time,
                archiveTypes => 'Page',
                offset       => 3,
                total        => 4
            },
            next_phase_url => qr{/publish/all\?.*siteId=1},
            code           => 200,
            result         => {
                status           => 'Rebuilding',
                startTime        => $start_time,
                restArchiveTypes => '',
            },
        },
        {
            path   => '/v7/publish/all',
            method => 'POST',
            note   => "Success case (complete)",
            params => {
                siteId    => $blog->id,
                startTime => $start_time
            },
            setup => sub {
                my ($data) = @_;
                $data->{rebuild_indexes} = 0;
                $data->{mock}            = Test::MockModule->new('MT::App');
                $data->{mock}->mock(
                    'rebuild_indexes',
                    sub {
                        $data->{rebuild_indexes}++;
                        $data->{mock}->original('rebuild_indexes')->(@_);
                    });
            },
            code   => 200,
            result => {
                status           => 'Complete',
                startTime        => $start_time,
                restArchiveTypes => q(),
            },
            complete => sub {
                my ($data) = @_;
                is(
                    $data->{rebuild_indexes},
                    1, 'MT::App::rebuild_indexes is called once'
                );
                delete $data->{mock};
            },
        },
    ];
}
