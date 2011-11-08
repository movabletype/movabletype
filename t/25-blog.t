#!/usr/bin/perl
# $Id: 62-asset.t 3531 2009-03-12 09:11:52Z fumiakiy $
use strict;
use warnings;

use lib qw( t t/lib ./extlib ./lib);

use Test::More qw(no_plan);
use MT::Test qw(:db :data);
use Data::Dumper;

use MT;
use MT::Blog;
use vars qw( $DB_DIR $T_CFG );

my $mt = MT->new( Config => $T_CFG ) or die MT->errstr;
isa_ok($mt, 'MT', 'Is MT');

my $blog = $mt->model('blog')->load(1);
isnt(undef, $blog, "blog was loaded");

my @entries = $mt->model('entry')->load({blog_id => $blog->id});
my %entry_ids = map {( $_->id => 1 )} @entries;
my @categories = $mt->model('category')->load({blog_id => $blog->id});
my %cat_ids = map {( $_->id => 1 )} @categories;
my @associations = $mt->model('association')->load({blog_id => $blog->id});
my %assoc_ids = map {( $_->id => 1 )} @categories;
my @permissions = $mt->model('permission')->load({blog_id => $blog->id});
my %prem_ids = map {( $_->id => 1 )} @categories;

is(scalar(@entries), 8, "Got entries");
is(scalar(@categories), 3, "Got Categories");
is(scalar(@associations), 4, "Got associations");
is(scalar(@permissions), 4, "Got permissions");

my $new_blog = $blog->clone({Children => 1});
isnt(undef, $new_blog, "blog was cloned");
is($new_blog->id, 3, "new blog is #3");
my @new_entries = $mt->model('entry')->load({blog_id => $new_blog->id});
my @new_categories = $mt->model('category')->load({blog_id => $new_blog->id});
my @new_associations = $mt->model('association')->load({blog_id => $new_blog->id});
my @new_permissions = $mt->model('permission')->load({blog_id => $new_blog->id});

is(scalar(@new_entries), 8, "Got new entries");
is(scalar(@new_categories), 3, "Got New Categories");
is(scalar(@new_associations), 4, "Got associations");
is(scalar(@new_permissions), 4, "Got permissions");
# print STDERR Dumper(\@permissions);
# print STDERR Dumper(\@new_permissions);

is( scalar( grep {exists $cat_ids{$_->id}} @new_categories ), 0, "all categories were duplicated");
is( scalar( grep {exists $entry_ids{$_->id}} @new_entries ), 0, "all entries were duplicated");
is( scalar( grep {exists $assoc_ids{$_->id}} @new_associations ), 0, "all associations were duplicated");
is( scalar( grep {exists $prem_ids{$_->id}} @new_permissions ), 0, "all permissions were duplicated");

