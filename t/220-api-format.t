#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}


use lib qw(lib extlib t/lib);

use Test::More;
use MT::Test;
use MT::App::DataAPI;
use MT::DataAPI::Format;

my $app = MT::App::DataAPI->new;

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
    my $format = MT::DataAPI::Format->find_format( $data->{key} );
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
