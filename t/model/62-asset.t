#!/usr/bin/perl
# $Id: 62-asset.t 3531 2009-03-12 09:11:52Z fumiakiy $
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    diag 'Force ignoring fixture because of failing test on first day on month';
    $ENV{MT_TEST_IGNORE_FIXTURE} = 1;

    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}
my $test_root = $test_env->root;

use File::Copy;
use File::Temp qw( tempfile );

plan tests => 71;
use MT::Test;

use Image::ExifTool;
use Image::Size;
$Image::Size::NO_CACHE = 1;

use MT;
use MT::Asset;

$test_env->prepare_fixture('db_data');

my $mt = MT->new or die MT->errstr;
isa_ok( $mt, 'MT', 'Is MT' );

{
    ### Cases for MT::Asset::Image
    my $blog = MT::Blog->load( { id => 1 } );

    # object validation
    my $asset = MT::Asset->load( { id => 1 } );
    isa_ok( $asset, 'MT::Asset::Image', 'Is MT::Asset::Image' );

    # method validation
    my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst )
        = gmtime(time + $blog->server_offset * 3600 );
    my $cache_path = sprintf( "%04d/%02d", $year + 1900, $mon + 1 );

    #    is($asset->class, 'Image', 'class');
    is( $asset->class_label, 'Image', 'class_label' );

    {
        note('Resize to 100 x 100 without square option');
        my $file = File::Spec->catfile( $test_root, 'site', 'assets_c', $cache_path, 'test-thumb-100xauto-1.jpg' );
        is( ( $asset->thumbnail_file( Height => 100, Width => 100 ) )[0],
            $file,
            'thumbnail file name'
        );
        my ( $width, $height ) = imgsize($file);
        is( $width,  100, "resized image's width: 100" );
        is( $height, 75,  "resized image's height: 75" );
    }

    {
        note('Resize to 100 x 100 with square option');
        my $file = File::Spec->catfile( $test_root, 'site', 'assets_c', $cache_path, 'test-thumb-100x100-1.jpg' );
        is( ( $asset->thumbnail_file( Height => 100, Square => 1 ) )[0],
            $file,
            'thumbnail file name'
        );
        my ( $width, $height ) = imgsize($file);
        is( $width,  100, "resized image's width: 100" );
        is( $height, 100, "resized image's height: 100" );
    }

    {
        note('Resize to 100 x 100 without square option again');
        my $file = File::Spec->catfile( $test_root, 'site', 'assets_c', $cache_path, 'test-thumb-100xauto-1.jpg' );
        is( ( $asset->thumbnail_file( Height => 100, Width => 100 ) )[0],
            $file,
            'thumbnail file name'
        );
        my ( $width, $height ) = imgsize($file);
        is( $width,  100, "resized image's width: 100" );
        is( $height, 75,  "resized image's height: 75" );
    }

    {
        note('Remove metadata from thumbnail file');

        # Changing t/images/test.jpg affects t/35-tags.t,
        # so preserve this image file here.
        my ( $fh, $temp_file )
            = tempfile( DIR => MT->config->TempDir );
        close($fh);
        copy( $asset->file_path, $temp_file );

        my $exif = $asset->exif;
        $exif->SetNewValue( 'GPSVersionID', '2.2.1.0' );
        $exif->WriteInfo( $asset->file_path );

        ok( $asset->has_metadata, 'add metadata to image' );

        my $file = File::Spec->catfile( $test_root, 'site', 'assets_c', $cache_path, 'test-thumb-100xauto-1.jpg' );
        is( ( $asset->thumbnail_file( Height => 100, Width => 100 ) )[0],
            $file,
            'thumbnail file name'
        );

        my $info = Image::ExifTool->new->ImageInfo($file);
        ok( !exists $info->{GPSVersionID},
            'removed metadata from thumbnail file'
        );

        # Restore t/images/test.jpg.
        copy( $temp_file, $asset->file_path );
    }

    is( $asset->image_width,  640, 'image_width' );
    is( $asset->image_height, 480, 'height' );
    is( $asset->as_html,
        '<a href="http://narnia.na/nana/images/test.jpg">Image photo</a>',
        'as_html' );
    is( $asset->as_html(
            { popup => 1, popup_asset_id => $asset->id, include => 1 }
        ),
        qq(<a href="http://narnia.na/nana/images/test.jpg" onclick="window.open('http://narnia.na/nana/images/test.jpg','popup','width=640,height=481,scrollbars=yes,resizable=no,toolbar=no,directories=no,location=no,menubar=no,status=no,left=0,top=0'); return false">View image</a>),
        'as_html_popup'
    );
    is( $asset->as_html( { include => 1, wrap_text => 1, align => 'right' } ),
        '<img alt="Image photo" src="http://narnia.na/nana/images/test.jpg" width="640" height="480" class="mt-image-right" style="float: right; margin: 0 0 20px 20px;" />',
        'as_html_include'
    );

    #metadata validation
    my $meta = $asset->metadata;
    is( $meta->{Tags}, 'alpha, beta, gamma', 'metadata - Tags' );
    is( $meta->{URL},
        'http://narnia.na/nana/images/test.jpg',
        'metadata - URL'
    );
    is( $meta->{Location},
        "$ENV{MT_HOME}/t/images/test.jpg",
        'metadata - Location'
    );
    is( $meta->{name},      "test.jpg",   'metadata - name' );
    is( $meta->{class},     'image',      'metadata - class' );
    is( $meta->{ext},       'jpg',        'metadata - ext' );
    is( $meta->{mime_type}, 'image/jpeg', 'metadata - mime_type' );
    is( $meta->{duration},  undef,        'metadata - duration' );
    is( $meta->{'Actual Dimensions'},
        '640 x 480 pixels',
        'metadata - Actual Dimensions'
    );

    # copy original image file
    my $orig_file
        = File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test.jpg' );
    my $copy_file = $test_env->path('test_.jpg');
    copy( $orig_file, $copy_file );

    # Object creation
    use Data::Dumper;
    my $img_pkg = MT::Asset->class_handler('image');
    $asset = new $img_pkg;
    isa_ok( $asset, 'MT::Asset::Image', 'New object is MT::Asset::Image' );
    $asset->blog_id(1);
    $asset->url('http://narnia.na/nana/images/test_.jpg');
    $asset->file_path($copy_file);
    $asset->file_name('test_.jpg');
    $asset->file_ext('jpg');
    $asset->image_width(640);
    $asset->image_height(480);
    $asset->mime_type('image/jpeg');
    $asset->label('Image photo');
    $asset->description('This is a test photo.');
    $asset->created_by(1);
    $asset->tags( 'alpha', 'beta', 'gamma' );
    $asset->parent(1);
    $asset->save;

    my $asset_id    = $asset->id;
    my $valid_asset = MT::Asset->load($asset_id);
    is( $valid_asset->class,   'image',       'class' );
    is( $valid_asset->blog_id, 1,             'blog_id' );
    is( $valid_asset->label,   'Image photo', 'label' );
    is( $valid_asset->url, 'http://narnia.na/nana/images/test_.jpg', 'url' );
    is( $valid_asset->description,  'This is a test photo.', 'description' );
    is( $valid_asset->file_path,    $copy_file );
    is( $valid_asset->file_name,    'test_.jpg',             'file_name' );
    is( $valid_asset->file_ext,     'jpg',                   'file_ext' );
    is( $valid_asset->mime_type,    'image/jpeg',            'mime_type' );
    is( $valid_asset->image_width,  640,                     'image_width' );
    is( $valid_asset->image_height, 480,                     'image_height' );
    is( $valid_asset->parent,       1,                       'parent' );

    # Object remove
    ok( $valid_asset->remove, 'remove' );

    $valid_asset = MT::Asset->load($asset_id);
    is( $valid_asset, undef, 'remove success' );
    ok( !-f $copy_file, "file remove" );

    ### Cases for MT::Asset
    # object validation
    my $asset_f = MT::Asset->load(2);
    isa_ok( $asset_f, 'MT::Asset', 'Is MT::Asset' );

    # method validation\
    is( $asset_f->class,       'file',  'class' );
    is( $asset_f->class_label, 'Asset', 'class_label' );
    is( $asset_f->as_html,
        '<a href="http://narnia.na/nana/files/test.tmpl">Template</a>',
        'as_html' );

    #metadata validation
    my $meta_f = $asset_f->metadata;
    is( $meta_f->{Tags}, 'beta', 'metadata - Tags' );
    is( $meta_f->{URL},
        'http://narnia.na/nana/files/test.tmpl',
        'metadata - URL'
    );
    is( $meta_f->{Location},
        "$ENV{MT_HOME}/t/test.tmpl",
        'metadata - Location'
    );
    is( $meta_f->{name},      "test.tmpl",  'metadata - name' );
    is( $meta_f->{class},     'file',       'metadata - class' );
    is( $meta_f->{ext},       'tmpl',       'metadata - ext' );
    is( $meta_f->{mime_type}, 'text/plain', 'metadata - mime_type' );
    is( $meta_f->{duration},  undef,        'metadata - duration' );

    # copy original image file
    my $orig_file_f = File::Spec->catfile( $ENV{MT_HOME}, "t", 'test.tmpl' );
    my $copy_file_f = $test_env->path('test_.tmpl');
    copy( $orig_file, $copy_file );

    # Object creation
    my $img_pkg_f = MT::Asset->class_handler('File');
    $asset_f = new $img_pkg_f;
    isa_ok( $asset_f, 'MT::Asset', 'New object is MT::Asset' );
    $asset_f->blog_id(1);
    $asset_f->url('http://narnia.na/nana/files/test_.tmpl');
    $asset_f->file_path($copy_file_f);
    $asset_f->file_name('test_.tmpl');
    $asset_f->file_ext('tmpl');
    $asset_f->mime_type('text/plain');
    $asset_f->label('Test template');
    $asset_f->description('This is a test template.');
    $asset_f->created_by(1);
    $asset_f->tags('beta');
    $asset_f->parent(1);
    $asset_f->save;

    my $asset_id_f    = $asset_f->id;
    my $valid_asset_f = MT::Asset->load($asset_id_f);
    is( $valid_asset_f->class,   'file',          'class' );
    is( $valid_asset_f->blog_id, 1,               'blog_id' );
    is( $valid_asset_f->label,   'Test template', 'label' );
    is( $valid_asset_f->url, 'http://narnia.na/nana/files/test_.tmpl',
        'url' );
    is( $valid_asset_f->description,
        'This is a test template.',
        'description'
    );
    is( $valid_asset_f->file_path, $copy_file_f );
    is( $valid_asset_f->file_name, 'test_.tmpl', 'file_name' );
    is( $valid_asset_f->file_ext,  'tmpl', 'file_ext' );
    is( $valid_asset_f->mime_type, 'text/plain', 'mime_type' );
    is( $valid_asset_f->parent,    1, 'parent' );

    # Object remove
    ok( $valid_asset_f->remove, 'remove' );

    $valid_asset_f = MT::Asset->load($asset_id_f);
    is( $valid_asset_f, undef, 'remove success' );
    ok( !-f $copy_file_f, "file remove" );
}
