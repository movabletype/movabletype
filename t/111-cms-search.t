#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib';
use MT::Test qw( :app :db :data);
use Test::More;

my $admin   = MT::Author->load(1);
my %entries = ();
for my $e ( MT::Entry->load ) {
    $entries{ $e->id } = $e;
}

subtest 'search_replace' => sub {
    my @suite = (
        {   params => {
                is_limited => 0,
                blog_id    => 1,
                do_search  => 1,
                search     => $entries{1}->title,
            },
            founds     => [1],
            not_founds => [2],
        },
        {   params => {
                _type      => 'entry',
                is_limited => 0,
                blog_id    => 1,
                do_search  => 1,
                search     => $entries{1}->title,
            },
            founds     => [1],
            not_founds => [2],
        },
    );

    foreach my $data (@suite) {
        my $params = $data->{params};
        my $query
            = join( '&', map { $_ . '=' . $params->{$_} } keys %$params );
        subtest $query => sub {
            my $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $admin,
                    __request_method => 'POST',
                    __mode           => 'search_replace',
                    %$params,
                }
            );
            my $out = delete $app->{__test_output};

            for my $id ( @{ $data->{founds} } ) {
                like( $out, qr/name="id" value="$id"/, "Entry#$id is found" );
            }
            for my $id ( @{ $data->{not_founds} } ) {
                unlike(
                    $out,
                    qr/name="id" value="$id"/,
                    "Entry#$id is not found"
                );
            }

            done_testing();
        };
    }

    done_testing();
};

done_testing();
