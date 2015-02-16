#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib extlib t/lib);

use Test::More;
use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

my $blog = $app->model('blog')->load(1);
my $start_time
    = MT::Util::ts2iso( $blog, MT::Util::epoch2ts( $blog, time() ), 1 );

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
                    count => 8,
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
    ];
}

