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

my %entry_ids = map {( $_->id => 1 )} $mt->model('entry'      )->load({blog_id => $blog->id});
my %cat_ids   = map {( $_->id => 1 )} $mt->model('category'   )->load({blog_id => $blog->id});
my %assoc_ids = map {( $_->id => 1 )} $mt->model('association')->load({blog_id => $blog->id});
my %prem_ids  = map {( $_->id => 1 )} $mt->model('permission' )->load({blog_id => $blog->id});
my %placem_ids= map {( $_->id => 1 )} $mt->model('placement'  )->load({blog_id => $blog->id});
my %comnt_ids = map {( $_->id => 1 )} $mt->model('comment'    )->load({blog_id => $blog->id});
my %objtag_ids= map {( $_->id => 1 )} $mt->model('objecttag'  )->load({blog_id => $blog->id, object_datasource => 'entry'});
my %tmplmap_ids=map {( $_->id => 1 )} $mt->model('templatemap')->load({blog_id => $blog->id});
my %tmpl_ids  = map {( $_->id => 1 )} $mt->model('template'   )->load({blog_id => $blog->id});
my %tbping_ids= map {( $_->id => 1 )} $mt->model('tbping'     )->load({blog_id => $blog->id});

is(scalar(keys %entry_ids), 8, "Got entries");
is(scalar(keys %cat_ids), 3, "Got Categories");
is(scalar(keys %assoc_ids), 4, "Got associations");
is(scalar(keys %prem_ids), 4, "Got permissions");
is(scalar(keys %placem_ids), 5, "Got placements");
is(scalar(keys %comnt_ids), 13, "Got comments");
is(scalar(keys %objtag_ids), 23, "Got object tags");
is(scalar(keys %tmplmap_ids), 6, "Got templatemaps");
is(scalar(keys %tmpl_ids), 53, "Got templates");
is(scalar(keys %tbping_ids), 2, "Got TB_pings");

my $new_blog = $blog->clone({Children => 1});
isnt(undef, $new_blog, "blog was cloned");
is($new_blog->id, 3, "new blog is #3");
my @new_entries = $mt->model('entry')->load({blog_id => $new_blog->id});
my @new_categories = $mt->model('category')->load({blog_id => $new_blog->id});
my @new_associations = $mt->model('association')->load({blog_id => $new_blog->id});
my @new_permissions = $mt->model('permission')->load({blog_id => $new_blog->id});
my @new_placements = $mt->model('placement')->load({blog_id => $new_blog->id});
my @new_comments = $mt->model('comment')->load({blog_id => $new_blog->id});
my @new_objecttags = $mt->model('objecttag')->load({blog_id => $new_blog->id, object_datasource => 'entry'});
my @new_tmplmaps = $mt->model('templatemap')->load({blog_id => $new_blog->id});
my @new_tmpls = $mt->model('template')->load({blog_id => $new_blog->id});
my @new_tbpings = $mt->model('tbping')->load({blog_id => $new_blog->id});

is(scalar(@new_entries), scalar(keys %entry_ids), "Got new entries");
is(scalar(@new_categories), scalar(keys %cat_ids), "Got New Categories");
is(scalar(@new_associations), scalar(keys %assoc_ids), "Got associations");
is(scalar(@new_permissions), scalar(keys %prem_ids), "Got permissions");
is(scalar(@new_placements), scalar(keys %placem_ids), "Got placements");
is(scalar(@new_comments), scalar(keys %comnt_ids), "Got comments");
is(scalar(@new_objecttags), scalar(keys %objtag_ids), "Got object tags");
is(scalar(@new_tmplmaps), scalar(keys %tmplmap_ids), "Got templatemaps");
is(scalar(@new_tmpls), scalar(keys %tmpl_ids), "Got templates");
is(scalar(@new_tbpings), scalar(keys %tbping_ids), "Got TB_pings");

is( scalar( grep {exists $cat_ids{$_->id}}    @new_categories ), 0, "all categories were duplicated");
is( scalar( grep {exists $entry_ids{$_->id}}  @new_entries ), 0, "all entries were duplicated");
is( scalar( grep {exists $assoc_ids{$_->id}}  @new_associations ), 0, "all associations were duplicated");
is( scalar( grep {exists $prem_ids{$_->id}}   @new_permissions ), 0, "all permissions were duplicated");
is( scalar( grep {exists $placem_ids{$_->id}} @new_placements ), 0, "all placements were duplicated");
is( scalar( grep {exists $comnt_ids{$_->id}}  @new_comments ), 0, "all comments were duplicated");
is( scalar( grep {exists $objtag_ids{$_->id}}  @new_objecttags ), 0, "all object tags were duplicated");
is( scalar( grep {exists $tmplmap_ids{$_->id}}  @new_tmplmaps ), 0, "all templatemaps were duplicated");
is( scalar( grep {exists $tmpl_ids{$_->id}}  @new_tmpls ), 0, "all templates were duplicated");
is( scalar( grep {exists $tbping_ids{$_->id}}  @new_tbpings ), 0, "all TB_pings were duplicated");

