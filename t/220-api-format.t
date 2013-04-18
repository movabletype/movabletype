#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib extlib);

use Test::More;

use MT::App::API;
use MT::API::Format;

my $app = MT::App::API->new;

my @suite = (
    {   key       => 'js',
        serialize => [
            {   from => { 'key' => 'value', },
                to   => '{"key":"value"}',
            }
        ],
        unserialize => [
            {   from => '{"key":"value"}',
                to   => { 'key' => 'value', },
            }
        ],
    },
    {   key       => 'json',
        serialize => [
            {   from => { 'key' => 'value', },
                to   => '{"key":"value"}',
            }
        ],
        unserialize => [
            {   from => '{"key":"value"}',
                to   => { 'key' => 'value', },
            }
        ],
    },
);

foreach my $data (@suite) {
    my $format = MT::API::Format->find_format( $data->{key} );
    ok( $format, $data->{key} . ' is defined' );

    for my $k (qw(serialize unserialize)) {
        note($k);
        foreach my $expectation ( @{ $data->{$k} } ) {
            my $result = $format->{$k}->( $expectation->{from} );
            is_deeply( $result, $expectation->{to},
                ref $expectation->{from}
                ? $expectation->{to}
                : $expectation->{from} );
        }
    }
}

done_testing();
