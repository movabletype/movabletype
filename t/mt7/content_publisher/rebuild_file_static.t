#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use utf8;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::ArchiveType;
use MT::Test::Fixture::ArchiveType;

use MT;
use MT::Template::Context;
my $app = MT->instance;

$test_env->prepare_fixture('archive_type');
my $objs = MT::Test::Fixture::ArchiveType->load_objs;
my $blog_id = $objs->{blog_id} or die;

MT::Request->instance->reset;
MT::ObjectDriver::Driver::Cache::RAM->clear_cache;

my %built_ct_archive_types = map { $_ => undef }
    grep {/^ContentType/} $app->publisher->archive_types;

MT->add_callback(
    'build_file',
    5, undef,
    sub {
        my ( $cb, %args ) = @_;
        my $at  = $args{archive_type};
        my $ctx = $args{context};

        return unless $at =~ /^ContentType/;

        if ( $at eq 'ContentType' ) {
            ok( $ctx->stash('content'),
                "$at: " . q{$ctx->stash('content') exists} );
        }
        else {
            ok( !$ctx->stash('content'),
                "$at: " . q{$ctx->stash('content') does not exist} );
        }

        $built_ct_archive_types{$at} = 1;
    },
);

$app->rebuild( BlogID => $blog_id ) or die;

my @not_tested_archive_types
    = grep { !$built_ct_archive_types{$_} } keys %built_ct_archive_types;

is( @not_tested_archive_types, 0,
    'test all archive types related to content type' );

done_testing;

