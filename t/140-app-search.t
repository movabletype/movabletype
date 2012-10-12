#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib';
use MT::Test qw( :app :db :data );
use MT::Test::Permission;
use JSON;
use Test::More;

my $blog  = MT->model('blog')->load(1);
my $entry = MT->model('entry')->load(
    {   blog_id => $blog->id,
        status  => MT::Entry::RELEASE(),
    }
);

my @suite = (
    {   label  => 'Found an entry',
        params => {
            search       => $entry->title,
            IncludeBlogs => $blog->id,
            limit        => 20,
        },
        expected => qr/id="entry-@{[ $entry->id ]}"/,
    },
    {   label  => 'Not found',
        params => {
            search       => 'Search word for no matching',
            IncludeBlogs => $blog->id,
            limit        => 20,
        },
        expected => qr/No results found/,
    },
    {   label  => 'No blog was specified',
        params => {
            search => $entry->title,
            limit  => 20,
        },
        expected => qr/id="entry-@{[ $entry->id ]}"/,
    },
);

for my $data (@suite) {
    # We should run the fresh instance.
    local %MT::mt_inst;

    my $params_str = JSON::to_json( $data->{params} );

    my $app = _run_app(
        'MT::App::Search',
        {   __request_method => 'GET',
            %{ $data->{params} },
        }
    );
    my $out = delete $app->{__test_output};

    note( $data->{label} );
    ok( $out, 'Request: ' . $params_str );
    like( $out, $data->{expected} );
}

done_testing();
