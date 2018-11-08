#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

# $Id: 20-setup.t 2562 2008-06-12 05:12:23Z bchoate $

use MT;
use MT::Test;
use MT::Author;
use MT::Blog;
use MT::Category;
use MT::Comment;
use MT::Entry;
use MT::Permission;
use MT::Template;
use MT::TemplateMap;

use MT::Test;
MT->instance;

$test_env->prepare_fixture('db');

my $BLOG_NAME = 'Fear of a Black Planet';
my $BLOG_DESC = 'Wherein Chuck D expounds on the plight of the black man in '
    . 'a white man\'s world.';
my $BLOG_URL  = 'http://www.black-planet.org/';
my $BLOG_PATH = '/opt/www/content/blog';

my $blog = MT::Blog->new;
isa_ok( $blog, 'MT::Blog' );
$blog->name($BLOG_NAME);
$blog->description($BLOG_DESC);
$blog->site_url($BLOG_URL);
$blog->archive_url( $BLOG_URL . 'bass-ment/' );
$blog->site_path($BLOG_PATH);
$blog->archive_path( $BLOG_PATH . 'bass-ment/' );
$blog->archive_type('Monthly,Daily,Weekly,Individual,Category');
$blog->archive_type_preferred('Monthly');
$blog->days_on_index(7);
$blog->words_in_excerpt(40);
$blog->file_extension('html');
$blog->convert_paras(1);
$blog->convert_paras_comments(1);
$blog->sanitize_spec(0);
$blog->ping_weblogs(0);
$blog->ping_blogs(0);
$blog->server_offset(0);
$blog->allow_comments_default(1);
$blog->language('en');
$blog->sort_order_posts('descend');
$blog->sort_order_comments('ascend');
$blog->status_default(1);
my $test = $blog->save or die $blog->errstr;
ok( $test, "saved $blog" );

my $author = MT::Author->new;
isa_ok( $author, 'MT::Author' );
$author->name('Chuck D');
$author->set_password('bass');
$author->type(1);
$test = $author->save or die $author->errstr;
ok( $test, "saved $author" );

my $perms = MT::Permission->new;
$perms->author_id( $author->id );
$perms->blog_id( $blog->id );
$perms->set_full_permissions;
$test = $perms->save or die $perms->errstr;
ok( $test, "saved $perms" );

my ($entry);
$entry = MT::Entry->new;
isa_ok( $entry, 'MT::Entry' );
$entry->blog_id( $blog->id );
$entry->status(2);
$entry->author_id( $author->id );
$entry->title('Fight the Power');
$entry->allow_comments(1);
$entry->excerpt('Fight the powers that be');
$entry->text('Elvis was a hero to most but he never meant shit to me');
$entry->text_more( 'straight up racist that sucker was simple and plain '
        . 'mother fuck him and john wayne' );
$test = $entry->save or die $entry->errstr;
ok( $test, "saved $entry" );

my $cat = MT::Category->new;
isa_ok( $cat, 'MT::Category' );
$cat->blog_id( $blog->id );
$cat->label('Foo');
$test = $cat->save or die $cat->errstr;
ok( $test, "saved Foo $cat" );

$cat = MT::Category->new;
isa_ok( $cat, 'MT::Category' );
$cat->blog_id( $blog->id );
$cat->label('Bar');
$test = $cat->save or die $cat->errstr;
ok( $test, "saved Bar $cat" );

my @arch_tmpl;
my $tmpl_list = require 'MT/default-templates.pl';
for my $val (@$tmpl_list) {
    my $obj = MT::Template->new;
    foreach ( keys %$val ) {
        $val->{$_} = $val->{$_}->() if ref( $val->{$_} ) eq 'CODE';
        delete $val->{$_} unless $obj->has_column($_);
    }
    $obj->set_values($val);
    $obj->blog_id( $blog->id );
    $test = $obj->save or die $obj->errstr;
    ok( $test, "saved $obj" );
    if (   $val->{type} eq 'archive'
        || $val->{type} eq 'individual'
        || $val->{type} eq 'category' )
    {
        push @arch_tmpl, $obj;
    }
}

for my $tmpl (@arch_tmpl) {
    my (@at);
    if ( $tmpl->type eq 'archive' ) {
        @at = qw( Daily Weekly Monthly );
    }
    elsif ( $tmpl->type eq 'category' ) {
        @at = qw( Category );
    }
    elsif ( $tmpl->type eq 'individual' ) {
        @at = qw( Individual );
    }
    for my $at (@at) {
        my $map = MT::TemplateMap->new;
        $map->archive_type($at);
        $map->is_preferred(1);
        $map->template_id( $tmpl->id );
        $map->blog_id( $tmpl->blog_id );
        $test = $map->save or die $map->errstr;
        ok( $test, "saved $map" );
    }
}

done_testing;
