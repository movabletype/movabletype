#!/usr/bin/perl

use strict;
use lib 'extlib', 'lib';

use Data::Dumper;
use Test::More tests => 11;

use MT;
use MT::Object;

my $mt = MT->instance;  # plugins are go!


package MT::Awesome;

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

package MT::Awesome::Image;

our @ISA = qw( MT::Awesome );

__PACKAGE__->install_properties({
    class_type => 'image',
});
__PACKAGE__->install_meta({
    columns => [ 'width', 'height' ]
});

package main;

my $file = new MT::Awesome;
my $image = new MT::Awesome::Image;

ok($file->has_column('meta'), 'having meta auto-adds meta column');
ok($file->meta('mime_type', 'archive/zip'), 'metadata field could be set');
is($file->meta('mime_type'), 'archive/zip', 'new metadata value could be retrieved');
ok($file->{changed_cols}{meta}, 'setting metadata field marked meta column as changed');
is($file->mime_type, 'archive/zip', 'auto-installed metadata field method retrieved new value');
ok(!$file->has_meta('width'), 'metadata field on subclass did not install on superclass');

ok($image->width(300), 'metadata field on subclass could be set with auto-installed method');
is($image->width, 300, 'auto-installed metadata field method retrieved new value for subclass');
ok($image->{changed_cols}{meta}, 'setting metadata field on subclass with auto-installed method marked meta column as changed');
ok($image->has_meta('width'), 'subclass has metadata field that was declared for subclass');
ok($image->has_meta('mime_type'), 'subclass has metadata field that was declared for superclass');

