#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib extlib t/lib);

use Test::More;
use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[
        map {
            +(  {   path   => "/v$_/sites/1/unknown-endpoint",
                    params => { suppressResponseCodes => 1, },
                    method => 'GET',
                    result => +{
                        "error" => {
                            "message" => "Unknown endpoint",
                            "code"    => 404
                        }
                    },
                },
                {   path   => "/v$_/sites/999999",
                    params => { suppressResponseCodes => 1, },
                    method => 'GET',
                    result => +{
                        "error" =>
                            { "message" => "Site not found", "code" => 404 }
                    },
                },
                {   path   => "/v$_/sites/1/unknown-endpoint",
                    params => {
                        suppressResponseCodes => 1,
                        'X-MT-Requested-Via'  => 'IFRAME',
                    },
                    method => 'POST',
                    result => +{
                        "error" => {
                            "message" => "Unknown endpoint",
                            "code"    => 404
                        }
                    },
                },
                {   path   => "/version",
                    method => 'GET',
                    result => +{
			endpointVersion => 'v' . $app->DEFAULT_VERSION(),
			apiVersion      => $app->API_VERSION(),
		    }
                },
                )
        } qw/ 1 2 3 /,
    ];
}

