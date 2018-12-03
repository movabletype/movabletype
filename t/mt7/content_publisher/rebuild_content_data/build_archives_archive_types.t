#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib";    # t/lib
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
my $objs    = MT::Test::Fixture::ArchiveType->load_objs;
my $blog_id = $objs->{blog_id} or die;
my $blog    = $app->model('blog')->load($blog_id) or die;
$blog->archive_path( $test_env->root . '/site/archive' );
$blog->save or die;

my $ct = $app->model('content_type')->load(
    {   blog_id => $blog_id,
        name    => 'ct_with_same_catset',
    }
) or die;
my $cd = $app->model('content_data')->load(
    {   blog_id         => $blog_id,
        content_type_id => $ct->id,
        label           => 'cd_same_apple_orange',
    }
) or die;

my %test_archive_types = map { $_ => 0 }
    grep { $app->publisher->archiver($_)->contenttype_based }
    $app->publisher->archive_types;

MT->add_callback(
    'build_file',
    5, undef,
    sub {
        my ( $cb, %args ) = @_;
        my $at = $args{archive_type};
        if ( exists $test_archive_types{$at} ) {
            $test_archive_types{$at} = 1;
        }
    },
);

$app->rebuild_content_data(
    BlogID        => $blog_id,
    BuildArchives => 1,
    ContentData   => $cd,
) or die;

my $no_tested_count
    = grep { !$test_archive_types{$_} } keys %test_archive_types;
is( $no_tested_count, 0, 'all specified archive types have been tested' );

done_testing;

