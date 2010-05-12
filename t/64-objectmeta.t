#!/usr/bin/perl

use strict;
use lib qw( t/lib extlib lib ../lib ../extlib );

use Data::Dumper;
use Test::More tests => 26;

use MT;
use MT::Object;

use vars qw( $DB_DIR $T_CFG );
BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}
use MT::Test qw(:db);

my $mt = MT->instance;  # plugins are go!

require MT::Awesome;
require MT::Awesome::Image;

my $file  = MT::Awesome->new;
my $image = MT::Awesome::Image->new;

#ok($file->has_column('meta'), 'having meta auto-adds meta column');

ok($file->is_meta_column('mime_type'), 'adding mime_type metadata field reports mime_type as a meta column');
ok($file->has_column('mime_type'), 'adding mime_type metadata field reports mime_type as a column');
ok(!defined $file->meta('mime_type'), 'unset metadata field is undefined');

ok($file->meta('mime_type', 'archive/zip'), 'metadata field could be set');
is($file->meta('mime_type'), 'archive/zip', 'new metadata value could be retrieved');
is($file->mime_type, 'archive/zip', 'auto-installed metadata field method retrieved new value');

diag('saving object');
ok($file->save(), 'object with metadata could be saved');
diag('object saved');
ok($file->id, 'object with metadata received id when saved');
is($file->meta('mime_type'), 'archive/zip', 'metadata value is still set after save');

my $file_2 = MT::Awesome->load($file->id)
    or diag('ERROR: ' . MT::Awesome->errstr);
ok($file_2, 'object with metadata could be loaded');
is($file_2->meta('mime_type'), 'archive/zip', 'metadata value is correct on loaded object');

is($file_2->mime_type, 'archive/zip', 'metadata value as retrieved with auto-installed method is correct on loaded object');

#ok($file->{changed_cols}{meta}, 'setting metadata field marked meta column as changed');
ok(!$file->has_meta('width'), 'metadata field on subclass did not install on superclass');

ok(!defined $image->width, 'auto-installed metadata field method returned undef for unset field');
ok($image->width(300), 'metadata field on subclass could be set with auto-installed method');
is($image->width, 300, 'auto-installed metadata field method retrieved new value for subclass');
#ok($image->{changed_cols}{meta}, 'setting metadata field on subclass with auto-installed method marked meta column as changed');
ok($image->has_meta('width'), 'subclass has metadata field that was declared for subclass');
ok($image->has_meta('mime_type'), 'subclass has metadata field that was declared for superclass');
ok($image->mime_type('image/jpeg'), 'subclass object mime type set');
ok($image->save(), 'image object saved');

ok($image->id, 'image object with metadata received id when saved');

my $image_2 = MT::Awesome->load($image->id);
ok($image_2, 'subclass object could be loaded');
is($image_2->mime_type, 'image/jpeg', 'metadata value as retrieved with auto-installed method is correct on loaded image object');

ok(MT::Asset::Image->has_meta('image_width'), 'MT::Asset::Image has an image_width meta column.');
ok(MT::Entry->has_meta, 'MT::Entry has a meta support.');
ok(MT::Page->has_meta, 'MT::Page has a meta support.');

