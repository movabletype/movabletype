#!/usr/bin/perl

use strict;
use lib 'extlib', 'lib';
use Test::More tests => 11;
use MT::Object;

package MT::Asset;

our @ISA = qw( MT::Object );

__PACKAGE__->install_properties({
    column_defs => {
        id => 'integer not null auto_increment',
        title => 'string(255)',
    },
    primary_key => 'id',
    class_type => 'file',
});

package MT::Asset::Image;

our @ISA = qw( MT::Asset );

__PACKAGE__->install_properties({
    class_type => 'image',
});

package MT::Asset::Audio;

our @ISA = qw( MT::Asset );

__PACKAGE__->install_properties({
    column_defs => {
        duration => 'integer',
    },
    class_type => 'audio',
});

package main;

my $file = new MT::Asset;
my $image = new MT::Asset::Image;
my $audio = new MT::Asset::Audio;

ok($file->has_column('title'));
ok($image->has_column('title'));
ok($audio->has_column('title'));
ok(!$file->has_column('duration'));
ok(!$image->has_column('duration'));
ok($audio->has_column('duration'));
ok($file->class_type eq 'file');
ok($image->class_type eq 'image');
ok($audio->class_type eq 'audio');
ok(MT::Asset->class_type eq 'file');
ok(MT::Asset::Image->class_type eq 'image');
