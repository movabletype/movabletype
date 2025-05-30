#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::DataAPI;

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app    = MT::App::DataAPI->new;
my $author = MT->model('author')->load(2);
$author->set_password('bass');
$author->can_sign_in_data_api(0);
$author->save or die $author->errstr;

use MT::DataAPI::Endpoint::v1::Auth;

my $suite = suite();
test_data_api($suite);

done_testing;

use Data::Dumper;

sub suite {
    return +[
        {   path   => '/v1/',
            method => 'GET',
            code  => 200,
            complete => sub {
                my ($data, $body, $headers) = @_;
                my $result = MT::Util::from_json($body);

                my $version = $ENV{MT_TEST_FORCE_DATAAPI_VERSION} || '1';

                # OpeAPI Object fields
                for my $field (qw/openapi info externalDocs servers tags components paths/) {
                    ok(grep { $_ eq $field } keys(%$result));
                }
                is($result->{openapi}, '3.0.0', 'OpenAPI Specification version');
                is($result->{info}{title}, 'Movable Type Data API');
                is($result->{info}{version}, $app->version_id);
                is($result->{servers}->[0]->{url}, $app->base . $app->uri . '/v' . $version);

                # Components
                my $schemas = $app->schemas($version);
                for my $resource ((keys(%$schemas), 'ErrorContent')) {
                    ok(defined $result->{components}{schemas}{$resource});
                }
            },
        },
    ];
}
