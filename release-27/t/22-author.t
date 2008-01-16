#!/usr/bin/perl
# $Id$
use strict;
use warnings;

use lib 't/lib';
use lib 'lib';
use lib 'extlib';

use Test::More tests => 54;

use MT;
use MT::Author;
use vars qw( $DB_DIR $T_CFG );

use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';

use MT::Test qw(:db :data);

my $mt = MT->new( Config => $T_CFG ) or die MT->errstr;
isa_ok($mt, 'MT');

{
my $author = MT::Author->load({ name => 'Chuck D' });
isa_ok($author, 'MT::Author');
ok($author->is_valid_password('bass'), 'bass is valid');
ok(!$author->is_valid_password('wrong'), 'wrong is invalid');

ok($author->can_create_blog, 'can create blog');
ok($author->can_view_log, 'can view log');
ok($author->can_manage_plugins, 'can manage plugins');

# Superuser Chuck D should have permission to do anything, on any blog
my $perm = $author->blog_perm(1);
ok($perm, "$author->blog_perm(1)") || die;
ok($author->can_edit_entry(1), 'can_edit_entry(1)');
ok($author->can_edit_entry(2), 'can_edit_entry(2)');
ok($perm->can_comment, 'can_comment');
ok($perm->can_post, 'can_post');
ok($perm->can_create_post, 'can_create_post');
ok($perm->can_publish_post, 'can_publish_post');
ok($perm->can_upload, 'can_upload');
ok($perm->can_edit_all_posts, 'can_edit_all_posts');
ok($perm->can_manage_pages, 'can_manage_pages');
ok($perm->can_edit_templates, 'can_edit_templates');
ok($perm->can_edit_tags, 'can_edit_tags');
ok($perm->can_edit_config, 'can_edit_config');
ok($perm->can_set_publish_paths, 'can_set_publish_paths');
ok($perm->can_rebuild, 'can_rebuild');
ok($perm->can_send_notifications, 'can_send_notifications');
ok($perm->can_edit_categories, 'can_edit_categories');
ok($perm->can_edit_notifications, 'can_edit_notifications');
ok($perm->can_administer_blog, 'can_administer_blog');
ok($perm->can_edit_assets, 'can_edit_assets');
ok($perm->can_save_image_defaults, 'can_save_image_defaults');
ok($perm->can_manage_feedback, 'can_manage_feedback');
}

{
my $author = MT::Author->load({ name => 'Bob D' });
$author = MT::Author->load($author->id);  # silly ruse to force caching.... 
isa_ok($author, 'MT::Author');

# Non-superuser Bob D should only have selected permissions
my $perm = $author->blog_perm(1);
ok($perm, "$author->blog_perm(1)") || die;
ok( ! $author->can_create_blog, 'can_create_blog' );
ok( ! $author->can_view_log, 'can_view_log' );
ok( ! $author->can_manage_plugins, 'can manage plugins');
ok( ! $author->can_edit_entry(1), 'can_edit_entry(1)' );
ok(   $author->can_edit_entry(2), 'can_edit_entry(2)' );
ok(   $perm->can_post, 'can_post' );
ok(   $perm->can_create_post, 'can_create_post');
ok(   $perm->can_publish_post, 'can_publish_post');
ok( ! $perm->can_upload, 'can_upload' );
ok( ! $perm->can_edit_all_posts, 'can_edit_all_posts' );
ok( ! $perm->can_manage_pages, 'can_manage_pages');
ok(   $perm->can_edit_templates, 'can_edit_templates' );
ok( ! $perm->can_edit_tags, 'can_edit_tags');
ok( ! $perm->can_edit_config, 'can_edit_config' );
ok( ! $perm->can_set_publish_paths, 'can_set_publish_paths');
ok( ! $perm->can_rebuild, 'can_rebuild' );
ok( ! $perm->can_send_notifications, 'can_send_notifications' );
ok( ! $perm->can_edit_categories, 'can_edit_categories' );
ok( ! $perm->can_edit_notifications, 'can_edit_notifications' );
ok( ! $perm->can_administer_blog, 'can_administer_blog' );
ok( ! $perm->can_edit_assets, 'can_edit_assets');
ok( ! $perm->can_save_image_defaults, 'can_save_image_defaults');
ok( ! $perm->can_manage_feedback, 'can_manage_feedback');
}
