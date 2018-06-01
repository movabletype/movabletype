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
$author->api_password('seecret');
$author->can_sign_in_data_api(0);
$author->save or die $author->errstr;

use MT::DataAPI::Endpoint::Auth;

my $suite = suite();
test_data_api($suite);

done_testing;

use Data::Dumper;

sub suite {
    return +[
        {   path   => '/v1/authentication',
            method => 'POST',
            params => {
                clientId => 'test',
                username => $author->name,
                password => 'bass',
            },
            code  => 401,
            error => 'Invalid login',
        },
        {   path   => '/v2/authentication',
            method => 'POST',
            params => {
                clientId => 'test',
                username => $author->name,
                password => 'bass',
            },
            code  => 401,
            error => 'Invalid login',
        },
        {   path      => '/v3/authentication',
            method    => 'POST',
            params    => {
                clientId => 'test',
                username => $author->name,
                password => 'seecret',
            },
            code  => 401,
            error => 'Invalid login',
        },
        {   path      => '/v4/authentication',
            method    => 'POST',
            params    => {
                clientId => 'test',
                username => $author->name,
                password => 'seecret',
            },
            code  => 401,
            error => 'Invalid login',
        },
    ];
}
