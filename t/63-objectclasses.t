#!/usr/bin/perl

use strict;
use lib 't/lib', 'extlib', 'lib';
use Test::More tests => 14;

use MT::Test;
my $mt = new MT;

package MT::TestAsset;

our @ISA = qw( MT::Object );

__PACKAGE__->install_properties({
    column_defs => {
        id => 'integer not null auto_increment',
        title => 'string(255)',
    },
    primary_key => 'id',
    class_type => 'file',
});

package MT::TestAsset::Image;

our @ISA = qw( MT::TestAsset );

__PACKAGE__->install_properties({
    class_type => 'image',
});

package MT::TestAsset::Audio;

our @ISA = qw( MT::TestAsset );

__PACKAGE__->install_properties({
    column_defs => {
        duration => 'integer',
    },
    class_type => 'audio',
});

package main;

my $file = new MT::TestAsset;
my $image = new MT::TestAsset::Image;
my $audio = new MT::TestAsset::Audio;

ok($file->has_column('title'), 'file has title column');
ok($image->has_column('title'), 'image has title column');
ok($audio->has_column('title'), 'audio has title column');
ok(!$file->has_column('duration'), 'file doesn\'t have column duration');
ok(!$image->has_column('duration'), 'image doesn\'t have column duration');
ok($audio->has_column('duration'), 'audio has column duration');
ok($file->class_type eq 'file', 'file class_type is file');
ok($image->class_type eq 'image', 'image class_type is image');
ok($audio->class_type eq 'audio', 'audio class_type is audio');
ok(MT::TestAsset->class_type eq 'file', 'generic asset class_type is file');
ok(MT::TestAsset::Image->class_type eq 'image', 'generic image asset class type is image');

# deflate/inflate tests; object should be re-blessed with proper package name
# upon inflation with base class
my $defl = $audio->deflate;
my $audio2 = MT::TestAsset->inflate( $defl );
ok($audio2, "Object re-inflated okay");
ok( ref($audio2) eq ref($audio), "Package name matches");
ok( $audio->title eq $audio2->title, "Title restored okay");
