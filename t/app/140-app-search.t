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

use MT::Test;
use MT::Test::Permission;
use MT::Util 'encode_html';
use JSON;

MT::Test->init_app;

$test_env->prepare_fixture('db_data');

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
    {   label  => 'Only "IncludeBlogs=all" is specified',
        params => {
            IncludeBlogs => 'all',
            search       => $entry->title,
            limit        => 20,
        },
        expected => qr/id="entry-@{[ $entry->id ]}"/,
    },
    {   label  => 'No error occurs without search string (MTC-26732)',
        params => {
            IncludeBlogs => $blog->id,
            limit        => 20,
        },
        expected   => qr|<h1[^>]*>Instructions</h1>|,
        unexpected => _create_qr_for_undefined_error(),
    },
    {   label  => 'No error occurs with empty search string (MTC-26732)',
        params => {
            search       => '',
            IncludeBlogs => $blog->id,
            limit        => 20,
        },
        expected   => qr|<h1[^>]*>Instructions</h1>|,
        unexpected => _create_qr_for_undefined_error(),
    },
);

for my $data (@suite) {

    # We should run the fresh instance.
    local %MT::mt_inst;

    my $params_str = JSON::to_json( $data->{params}, { canonical => 1 } );

    my $app = _run_app(
        'MT::App::Search',
        {   __request_method => 'GET',
            %{ $data->{params} },
        }
    );
    my $out = delete $app->{__test_output};

    note( $data->{label} );
    ok( $out, 'Request: ' . $params_str );
    if ( $data->{expected} ) {
        like( $out, $data->{expected} );
    }
    if ( $data->{unexpected} ) {
        unlike( $out, $data->{unexpected} );
    }

    unless ( $data->{expected} || $data->{unexpected} ) {
        die 'no test';
    }
}

{
    note 'No error occurs when there is no blog (bugid:113059)';

    MT->model('blog')->remove_all;
    %MT::mt_inst = ();

    my %params = ( search => 'a' );
    my $app    = _run_app(
        'MT::App::Search',
        {   __request_method => 'GET',
            %params,
        }
    );
    my $out = delete $app->{__test_output};

    ok( $out, 'Request ' . JSON::to_json( \%params, { canonical => 1 } ) );
    unlike(
        $out,
        qr/Cannot load blog/,
        'The error that blog cannot be loaded does not occur'
    );
}

done_testing();

sub _create_qr_for_undefined_error {
    my $err = quotemeta(
        encode_html('Can\'t call method "end" on an undefined value') );
    qr/$err/;
}

