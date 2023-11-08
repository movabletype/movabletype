#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test ();
use MT;
use MT::App::DataAPI;

MT::App::DataAPI->current_api_version(1);
my @suite = (
    {   api_version => 1,
        endpoint    => 'list_endpoints',
        url         => '/endpoints',
    },
    {   api_version => 1,
        endpoint    => 'list_endpoints',
        params      => { includeComponents => 'Test', },
        url         => '/endpoints?includeComponents=Test',
    },
    {   api_version => 1,
        endpoint =>
            MT::App::DataAPI->find_endpoint_by_id( 1, 'list_endpoints' ),
        url => '/endpoints',
    },
);


note('endpoint_url');
for my $d (@suite) {
    MT::App::DataAPI->current_api_version( $d->{api_version} );
    my @args = ( $d->{endpoint} );
    if ( exists $d->{params} ) {
        push @args, $d->{params};
    }
    my $url = MT::App::DataAPI->endpoint_url(@args);
    is( $url, $d->{url}, $d->{url} );
}

require MT::Test::DataAPI;
$test_env->prepare_fixture('db_data');
MT::Test::DataAPI::test_data_api({
    path => '/v1/endpoints',
    method => 'GET',
    code => 200,
    complete => sub {
        my ($data, $body, $headers) = @_;
        my $result = MT::Util::from_json($body);

        my $version = $ENV{MT_TEST_FORCE_DATAAPI_VERSION} || '1';

        # OpeAPI Object fields
        for my $field (qw/items totalResults/) {
            ok(grep { $_ eq $field } keys(%$result));
        }

        for my $field (qw/id component format route verb version/) {
            ok(grep { $_ eq $field } keys(%{$result->{items}[0]}));
        }

        for my $field (qw/id name/) {
            ok(grep { $_ eq $field } keys(%{$result->{items}[0]->{component}}));
        }
    }
});

done_testing();
