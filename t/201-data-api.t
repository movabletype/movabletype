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


BEGIN {
    use Test::More;
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

use lib qw(lib extlib t/lib);
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

done_testing();
