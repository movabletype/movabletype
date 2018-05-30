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

use File::Basename;
use File::Copy;
use File::Spec;
use File::Temp qw( tempfile );

use MT::Test;
use MT::Test::Permission;
use MT;
use MT::Image;

if ( !MT::Image->new ) {
    plan skip_all => 'ImageDriver may be invalid.';
}

MT::Test->init_app;

$test_env->prepare_fixture('db');

my @methods = qw/ scale crop_rectangle rotate flip_horizontal flip_vertical /;

my $fmgr_mock = Test::MockModule->new('MT::FileMgr');
$fmgr_mock->mock( 'put_data', sub {1} );
my $image_mock = Test::MockModule->new( ref MT::Image->new );

# Generate temporary JPEG file.
my $jpg_file
    = File::Spec->catfile( $ENV{MT_HOME}, 't', 'images', 'test.jpg' );
my ( $fh, $tempfile )
    = tempfile( DIR => MT->config->TempDir, SUFFIX => '.jpg', );
close $fh;
copy( $jpg_file, $tempfile );
ok( -s $tempfile, 'Copy JPEG file.' );

# Generate temporary asset record.
my $asset = MT::Test::Permission->make_asset(
    blog_id   => 1,
    class     => 'image',
    file_ext  => 'jpg',
    file_name => basename($tempfile),
    file_path => $tempfile,
);
ok( $asset && $asset->id, 'Asset has been created.' );

subtest 'scale' => sub {
    my $counter = 0;
    $image_mock->mock( 'scale',
        sub { $counter++; $image_mock->original('scale')->(@_); } );

    $asset->scale( 30, 30 );
    is( $counter, 1, 'Called scale method.' );
};

subtest 'crop_rectangle' => sub {
    my $counter = 0;
    $image_mock->mock( 'crop_rectangle',
        sub { $counter++; $image_mock->original('crop_rectangle')->(@_); } );

    $asset->crop_rectangle( 0, 0, 25, 25 );
    is( $counter, 1, 'Called crop_rectangle method.' );
};

subtest 'rotate' => sub {
    my $counter = 0;
    $image_mock->mock( 'rotate',
        sub { $counter++; $image_mock->original('rotate')->(@_); } );

    $asset->rotate(180);
    is( $counter, 1, 'Called rotate method.' );
};

subtest 'flip_horizontal' => sub {
    my $counter = 0;
    $image_mock->mock( 'flipHorizontal',
        sub { $counter++; $image_mock->original('flipHorizontal')->(@_); } );

    $asset->flip_horizontal;
    is( $counter, 1, 'Called flipHorizontal method.' );
};

subtest 'flip_vertical' => sub {
    my $counter = 0;
    $image_mock->mock( 'flipVertical',
        sub { $counter++; $image_mock->original('flipVertical')->(@_); } );

    $asset->flip_vertical;
    is( $counter, 1, 'Called flipVertical method.' );
};

subtest 'transform' => sub {
    my %counter;

    my $asset_mock = Test::MockModule->new('MT::Asset::Image');
    for my $m (@methods) {
        $asset_mock->mock( $m,
            sub { $counter{$m}++; $asset_mock->original($m)->(@_); } );
    }

    $asset->transform( { resize => { width => 100, height => 100 } } );
    is( $counter{scale}, 1, 'Called scale method.' );

    %counter = ();
    $asset->transform(
        { crop => { left => 0, top => 0, width => 50, height => 50 } } );
    is( $counter{crop_rectangle}, 1, 'Called crop_rectangle method.' );

    %counter = ();
    $asset->transform( { rotate => 90 } );
    is( $counter{rotate}, 1, 'Called rotate method.' );

    %counter = ();
    $asset->transform( { flip => 'horizontal' } );
    is( $counter{flip_horizontal}, 1, 'Called flip_horizontal method.' );

    %counter = ();
    $asset->transform( { flip => 'vertical' } );
    is( $counter{flip_vertical}, 1, 'Called flip_vertical method.' );

    %counter = ();
    $asset->transform(
        { resize => { width => 100, height => 100 } },
        { crop => { left => 0, top => 0, width => 50, height => 50 } },
        { rotate => 90 },
        { flip   => 'horizontal' },
        { flip   => 'vertical' },
    );

    for my $m (@methods) {
        is( $counter{$m}, 1, "called $m method." );
    }

};

done_testing;
