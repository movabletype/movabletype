#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    use Test::More;
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

use lib qw(lib extlib);

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

note('use_resource_cache');
{
    my $app = MT::App::DataAPI->new;
    MT->set_instance($app);

    my $author_class   = MT->model('author');
    my $entry_resource = MT::DataAPI::Resource->resource('entry');

    my @suite = (
        {   label     => 'Entry resource for anonymous user',
            author_id => 0,
            config    => 0,
            model     => 'entry',
            registry  => 0,
            expected  => 1,
        },
        {   label     => 'Entry resource for a MT user',
            author_id => 1,
            config    => 0,
            model     => 'entry',
            registry  => 0,
            expected  => '',
        },
        {   label =>
                'Entry resource for anonymous user when disabled by config',
            author_id => 0,
            config    => 1,
            model     => 'entry',
            registry  => 0,
            expected  => '',
        },
        {   label =>
                'Entry resource for anonymous user when disabled by registry',
            author_id => 0,
            config    => 0,
            model     => 'entry',
            registry  => 1,
            expected  => '',
        },
        {   label     => 'Unknown resource for anonymous user',
            author_id => 0,
            config    => 0,
            model     => 'unknown',
            registry  => 0,
            expected  => '',
        },
    );

    for my $d (@suite) {
        $app->user(
              $d->{author_id}
            ? $author_class->load( $d->{author_id} )
            : $author_class->anonymous
        );
        $app->config->DisableDataAPIResourceCache( $d->{config} );
        local $entry_resource->{disable_cache} = $d->{registry};
        is( !!$app->use_resource_cache( $d->{model} ),
            $d->{expected}, $d->{label} );
    }

    undef $MT::ConfigMgr::cfg;
}

done_testing();
