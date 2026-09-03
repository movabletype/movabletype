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

my $blog  = MT->model('blog')->load(1);
my $blog2 = MT->model('blog')->load(2);

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
            note   => "siteId is invalid",
            params => { siteIds => '9999' },
            code   => 400,
        },
        {
            path      => '/v7/publish/all',
            method    => 'POST',
            note      => "Success case: initial request",
            params    => { siteIds => join(',', ($blog->id)), },
            callbacks => [{
                    name  => 'MT::App::DataAPI::pre_build',
                    count => 1,
                },
            ],
            next_phase_url => qr{
                /publish/all\?
                (?=.*siteIds=1)
                (?=.*offset=0)
                (?=.*total=\d+)
                (?=.*startTime=[^&]+)
                (?=.*nextTypeIndex=0)
                (?=.*nextSiteIndex=0)
                .*
            }x,
            code   => 200,
            result => {
                status           => 'Rebuilding',
                startTime        => $start_time,
                restArchiveTypes => 'Individual,Monthly,Weekly,Daily,Category,Page,Author',
                restSiteIds      => '1',
                siteId           => '',
            },
        },
        {
            path   => '/v7/publish/all',
            method => 'POST',
            note   => "Success case: initial request with archiveType",
            params => {
                siteIds      => join(',', ($blog->id)),
                archiveTypes => 'Individual'
            },
            next_phase_url => qr{
                /publish/all\?
                (?=.*siteIds=1)
                (?=.*archiveTypes=Individual)
                (?=.*offset=0)
                (?=.*total=\d+)
                (?=.*startTime=[^&]+)
                (?=.*nextTypeIndex=0)
                (?=.*nextSiteIndex=0)
                .*
            }x,
            code   => 200,
            result => {
                status           => 'Rebuilding',
                startTime        => $start_time,
                restArchiveTypes => 'Individual',
                restSiteIds      => '1',
                siteId           => '',
            },
        },
        {
            path      => '/v7/publish/all',
            method    => 'POST',
            note      => "Success case: initial request with multiple siteIds",
            params    => { siteIds => join(',', ($blog->id, $blog2->id)), },
            callbacks => [{
                    name  => 'MT::App::DataAPI::pre_build',
                    count => 1,
                },
            ],
            next_phase_url => qr{
                /publish/all\?
                (?=.*siteIds=1(?:,|%2C)2)
                (?=.*offset=\d+)
                (?=.*total=\d+)
                (?=.*startTime=[^&]+)
                (?=.*nextTypeIndex=\d+)
                (?=.*nextSiteIndex=\d+)
                .*
            }x,
            code   => 200,
            result => {
                status           => 'Rebuilding',
                startTime        => $start_time,
                restArchiveTypes => 'Individual,Monthly,Weekly,Daily,Category,Page,Author',
                restSiteIds      => '1,2',
                siteId           => '',
            },
        },
        {
            path      => '/v7/publish/all',
            method    => 'POST',
            note      => "Success case: initial request with multiple siteIds including invalid",
            params    => { siteIds => join(',', ($blog->id, $blog2->id, 9999)), },
            callbacks => [{
                    name  => 'MT::App::DataAPI::pre_build',
                    count => 1,
                },
            ],
            next_phase_url => qr{
                /publish/all\?
                (?=.*siteIds=1(?:,|%2C)2)
                (?=.*offset=\d+)
                (?=.*total=\d+)
                (?=.*startTime=[^&]+)
                (?=.*nextTypeIndex=\d+)
                (?=.*nextSiteIndex=\d+)
                .*
            }x,
            code   => 200,
            result => {
                status           => 'Rebuilding',
                startTime        => $start_time,
                restArchiveTypes => 'Individual,Monthly,Weekly,Daily,Category,Page,Author',
                restSiteIds      => '1,2',
                siteId           => '',
            },
        },
        {
            path   => '/v7/publish/all',
            method => 'POST',
            note   => "Success case: initial request with multiple siteIds and archiveTypes",
            params => {
                siteIds      => join(',', ($blog->id, $blog2->id)),
                archiveTypes => 'Individual,Page',
            },
            callbacks => [{
                    name  => 'MT::App::DataAPI::pre_build',
                    count => 1,
                },
            ],
            next_phase_url => qr{
                /publish/all\?
                (?=.*siteIds=1(?:,|%2C)2)
                (?=.*archiveTypes=Individual(?:,|%2C)Page)
                (?=.*offset=0)
                (?=.*total=\d+)
                (?=.*startTime=[^&]+)
                (?=.*nextTypeIndex=0)
                (?=.*nextSiteIndex=0)
                .*
            }x,
            code   => 200,
            result => {
                status           => 'Rebuilding',
                startTime        => $start_time,
                restArchiveTypes => 'Individual,Page',
                restSiteIds      => '1,2',
                siteId           => '',
            },
        },
        {
            path   => '/v7/publish/all',
            method => 'POST',
            note   => "Success case: paging with offset and total",
            params => {
                siteIds       => join(',', ($blog->id)),
                startTime     => $start_time,
                archiveTypes  => 'Individual,Page',
                offset        => 0,
                total         => 4,
                nextSiteIndex => 0,
                nextTypeIndex => 1,
            },
            config         => { EntriesPerRebuild => 1, },
            next_phase_url => qr{
                /publish/all\?
                (?=.*siteIds=1)
                (?=.*archiveTypes=Individual(?:,|%2C)Page)
                (?=.*offset=1)
                (?=.*total=4)
                (?=.*startTime=[^&]+)
                (?=.*nextTypeIndex=1)
                (?=.*nextSiteIndex=0)
                .*
            }x,
            code   => 200,
            result => {
                status           => 'Rebuilding',
                startTime        => $start_time,
                restArchiveTypes => 'Page',
                restSiteIds      => '1',
                siteId           => '1',
            },
        },
        {
            path   => '/v7/publish/all',
            method => 'POST',
            note   => "Success case: transition to rebuilding the next site",
            params => {
                siteIds       => join(',', ($blog->id, $blog2->id)),
                startTime     => $start_time,
                archiveTypes  => 'Individual,Page',
                offset        => 3,
                total         => 4,
                nextSiteIndex => 0,
                nextTypeIndex => 1,
            },
            next_phase_url => qr{
                /publish/all\?
                (?=.*siteIds=1(?:,|%2C)2)
                (?=.*archiveTypes=Individual(?:,|%2C)Page)
                (?=.*offset=0)
                (?=.*total=\d+)
                (?=.*startTime=[^&]+)
                (?=.*nextTypeIndex=0)
                (?=.*nextSiteIndex=1)
                .*
            }x,
            code   => 200,
            result => {
                status           => 'Rebuilding',
                startTime        => $start_time,
                restArchiveTypes => 'Individual,Page',
                restSiteIds      => '2',
                siteId           => '1',
            },
        },
        {
            path   => '/v7/publish/all',
            method => 'POST',
            note   => "Success case: rebuilding the last site",
            params => {
                siteIds       => join(',', ($blog2->id, $blog->id)),
                startTime     => $start_time,
                archiveTypes  => 'Individual,Page',
                offset        => 3,
                total         => 4,
                nextSiteIndex => 1,
                nextTypeIndex => 1,
            },
            next_phase_url => qr{
                /publish/all\?
                (?=.*siteIds=2(?:,|%2C)1)
                (?=.*archiveTypes=Individual(?:,|%2C)Page)
                (?=.*offset=0)
                (?=.*total=0)
                (?=.*startTime=[^&]+)
                (?=.*nextTypeIndex=0)
                (?=.*nextSiteIndex=2)
                .*
            }x,
            code   => 200,
            result => {
                status           => 'Rebuilding',
                startTime        => $start_time,
                restArchiveTypes => '',
                restSiteIds      => '',
                siteId           => '1',
            },
        },
        {
            path   => '/v7/publish/all',
            method => 'POST',
            note   => "Success case: rebuilding all sites completed",
            params => {
                siteIds       => join(',', ($blog->id)),
                startTime     => $start_time,
                archiveTypes  => 'Individual,Page',
                offset        => 0,
                total         => 0,
                nextSiteIndex => 1,
                nextTypeIndex => 0,
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
                restSiteIds      => q(),
                siteId           => '',
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
