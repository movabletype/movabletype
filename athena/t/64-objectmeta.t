#!/usr/bin/perl

use strict;
use lib 'extlib', 'lib';
use Data::Dumper;
use Test::More tests => 11;
use MT::Object;

package MT::Asset;

our @ISA = qw( MT::Object );

__PACKAGE__->install_properties({
    column_defs => {
        id => 'integer not null auto_increment',
        title => 'string(255)',
        file => 'string(255)',
    },
    meta => 1,
    class_type => 'foo',
});
__PACKAGE__->install_meta({
    columns => [ 'mime_type' ]
});

package MT::Asset::Image;

our @ISA = qw( MT::Asset );

__PACKAGE__->install_properties({
    class_type => 'image',
});
__PACKAGE__->install_meta({
    columns => [ 'width', 'height' ]
});

package main;

my $file = new MT::Asset;
my $image = new MT::Asset::Image;

ok($file->has_column('meta'));
ok($file->meta('mime_type', 'archive/zip'));
ok($file->meta('mime_type') eq 'archive/zip');
ok($file->{changed_cols}{meta});
ok($file->mime_type eq 'archive/zip');
ok(!$file->has_meta('width'));
ok($image->width(300));
ok($image->width == 300);
ok($image->{changed_cols}{meta});
ok($image->has_meta('width'));
ok($image->has_meta('mime_type'));
