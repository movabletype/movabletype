#!/usr/bin/perl
# $Id$
use strict;
use warnings;
use File::Copy;

use lib qw( t t/lib ./extlib ./lib);

use Test::More tests => 60;
use MT::Test qw(:db :data);

use MT;
use MT::Asset;
use vars qw( $DB_DIR $T_CFG );

my $mt = MT->new( Config => $T_CFG ) or die MT->errstr;
isa_ok($mt, 'MT', 'Is MT');

{
    ### Cases for MT::Asset::Image
    # object validation
    my $asset = MT::Asset->load({id => 1});
    isa_ok($asset, 'MT::Asset::Image', 'Is MT::Asset::Image');

    # method validation
    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
    my $cache_path = sprintf("%04d/%02d", $year + 1900, $mon + 1);
#    is($asset->class, 'Image', 'class');
    is($asset->class_label, 'Image', 'class_label');
    is(($asset->thumbnail_file({Height => 100, Width => 100}))[0], "t/site/assets_c/$cache_path/test-thumb-640x480-1.jpg", 'thumbnail');
    is($asset->image_width, 640, 'image_width'); 
    is($asset->image_height, 480, 'height');
    is($asset->as_html, '<form mt:asset-id="1" class="mt-enclosure mt-enclosure-image" style="display: inline;"><a href="http://narnia.na/nana/images/test.jpg">View image</a></form>', 'as_html');
    is($asset->as_html({popup => 1, popup_asset_id => $asset->id, include => 1}), qq(<form mt:asset-id="1" class="mt-enclosure mt-enclosure-image" style="display: inline;"><a href="http://narnia.na/nana/images/test.jpg" onclick="window.open('http://narnia.na/nana/images/test.jpg','popup','width=640,height=480,scrollbars=no,resizable=no,toolbar=no,directories=no,location=no,menubar=no,status=no,left=0,top=0'); return false">View image</a></form>), 'as_html_popup');
    is($asset->as_html({include => 1, wrap_text => 1, align => 'right'}), '<form mt:asset-id="1" class="mt-enclosure mt-enclosure-image" style="display: inline;"><img alt="Image photo" src="http://narnia.na/nana/images/test.jpg" width="640" height="480" class="mt-image-right" style="float: right; margin: 0 0 20px 20px;" /></form>', 'as_html_include');

    #metadata validation
    my $meta = $asset->metadata;
    is($meta->{Tags}, 'alpha, beta, gamma', 'metadata - Tags');
    is($meta->{URL}, 'http://narnia.na/nana/images/test.jpg', 'metadata - URL');
    is($meta->{Location}, File::Spec->catfile($ENV{MT_HOME}, "t", 'images', 'test.jpg'), 'metadata - Location');
    is($meta->{name}, "test.jpg", 'metadata - name');
    is($meta->{class}, 'image', 'metadata - class');
    is($meta->{ext}, 'jpg', 'metadata - ext');
    is($meta->{mime_type}, 'image/jpeg', 'metadata - mime_type');
    is($meta->{duration}, undef, 'metadata - duration');
    is($meta->{'Actual Dimensions'}, '640 x 480 pixels', 'metadata - Actual Dimensions');

    # copy original image file
    my $orig_file = File::Spec->catfile($ENV{MT_HOME}, "t", 'images', 'test.jpg');
    my $copy_file = File::Spec->catfile($ENV{MT_HOME}, "t", 'images', 'test_.jpg');
    copy($orig_file, $copy_file);

    # Object creation
    use Data::Dumper;
    my $img_pkg = MT::Asset->class_handler('image');
    $asset = new $img_pkg;
    isa_ok($asset, 'MT::Asset::Image', 'New object is MT::Asset::Image');
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
    $asset->tags('alpha', 'beta', 'gamma');
    $asset->parent(1);
    $asset->save;

    my $asset_id = $asset->id;
    my $valid_asset = MT::Asset->load($asset_id);
    is($valid_asset->class, 'image', 'class');
    is($valid_asset->blog_id, 1, 'blog_id');
    is($valid_asset->label, 'Image photo', 'label');
    is($valid_asset->url, 'http://narnia.na/nana/images/test_.jpg', 'url');
    is($valid_asset->description, 'This is a test photo.', 'description');
    is($valid_asset->file_path, $copy_file);
    is($valid_asset->file_name, 'test_.jpg', 'file_name');
    is($valid_asset->file_ext, 'jpg', 'file_ext');
    is($valid_asset->mime_type, 'image/jpeg', 'mime_type');
    is($valid_asset->image_width, 640, 'image_width');
    is($valid_asset->image_height, 480, 'image_height');
    is($valid_asset->parent, 1, 'parent');
    
    # Object remove
    ok($valid_asset->remove, 'remove');

    $valid_asset = MT::Asset->load($asset_id);
    is($valid_asset, undef, 'remove success');
    ok(!-f $copy_file, "file remove");


    ### Cases for MT::Asset
    # object validation
    my $asset_f = MT::Asset->load(2);
    isa_ok($asset_f, 'MT::Asset', 'Is MT::Asset');

    # method validation\
    is($asset_f->class, 'file', 'class');
    is($asset_f->class_label, 'Asset', 'class_label');
    is($asset_f->as_html, '<form mt:asset-id="2" class="mt-enclosure mt-enclosure-file" style="display: inline;"><a href="http://narnia.na/nana/files/test.tmpl">test.tmpl</a></form>', 'as_html');

    #metadata validation
    my $meta_f = $asset_f->metadata;
    is($meta_f->{Tags}, 'beta', 'metadata - Tags');
    is($meta_f->{URL}, 'http://narnia.na/nana/files/test.tmpl', 'metadata - URL');
    is($meta_f->{Location}, File::Spec->catfile($ENV{MT_HOME}, "t", 'test.tmpl'), 'metadata - Location');
    is($meta_f->{name}, "test.tmpl", 'metadata - name');
    is($meta_f->{class}, 'file', 'metadata - class');
    is($meta_f->{ext}, 'tmpl', 'metadata - ext');
    is($meta_f->{mime_type}, 'text/plain', 'metadata - mime_type');
    is($meta_f->{duration}, undef, 'metadata - duration');

    # copy original image file
    my $orig_file_f = File::Spec->catfile($ENV{MT_HOME}, "t", 'test.tmpl');
    my $copy_file_f = File::Spec->catfile($ENV{MT_HOME}, "t", 'test_.tmpl');
    copy($orig_file, $copy_file);

    # Object creation
    my $img_pkg_f = MT::Asset->class_handler('File');
    $asset_f =  new $img_pkg_f;
    isa_ok($asset_f, 'MT::Asset', 'New object is MT::Asset');
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

    my $asset_id_f = $asset_f->id;
    my $valid_asset_f = MT::Asset->load($asset_id_f);
    is($valid_asset_f->class, 'file', 'class');
    is($valid_asset_f->blog_id, 1, 'blog_id');
    is($valid_asset_f->label, 'Test template', 'label');
    is($valid_asset_f->url, 'http://narnia.na/nana/files/test_.tmpl', 'url');
    is($valid_asset_f->description, 'This is a test template.', 'description');
    is($valid_asset_f->file_path, $copy_file_f);
    is($valid_asset_f->file_name, 'test_.tmpl', 'file_name');
    is($valid_asset_f->file_ext, 'tmpl', 'file_ext');
    is($valid_asset_f->mime_type, 'text/plain', 'mime_type');
    is($valid_asset_f->parent, 1, 'parent');
    
    # Object remove
    ok($valid_asset_f->remove, 'remove');

    $valid_asset_f = MT::Asset->load($asset_id_f);
    is($valid_asset_f, undef, 'remove success');
    ok(!-f $copy_file_f, "file remove");
}
