# $Id$

BEGIN { unshift @INC, 't/' }

use Test;
use MT::Author;
use MT;
use strict;

BEGIN { plan tests => 33 };

use vars qw( $DB_DIR $T_CFG );
system("rm t/db/* 2>/dev/null");
require 'test-common.pl';
require 'blog-common.pl';

my $mt = MT->new( Config => $T_CFG ) or die MT->errstr;

{
my $author = MT::Author->load({ name => 'Chuck D' });
ok($author);
ok($author->is_valid_password('bass'));
ok(!$author->is_valid_password('wrong'));

ok($author->can_create_blog);
ok($author->can_view_log);

# Superuser Chuck D should have permission to do anything, on any blog
my $perm = $author->blog_perm(1);
ok($author->can_edit_entry(1));
ok($author->can_edit_entry(2));
ok($perm->can_post);
ok($perm->can_upload);
ok($perm->can_edit_all_posts);
ok($perm->can_edit_templates);
ok($perm->can_edit_config);
ok($perm->can_rebuild);
ok($perm->can_send_notifications);
ok($perm->can_edit_categories);
ok($perm->can_edit_notifications);
ok($perm->can_administer_blog);
}

{
my $author = MT::Author->load({ name => 'Bob D' });
$author = MT::Author->load($author->id);  # silly ruse to force caching.... 
ok($author);

# Non-superuser Bob D should only have selected permissions
my $perm = $author->blog_perm(1);
ok($perm) || die;
ok( ! $author->can_create_blog );
ok( ! $author->can_view_log );
ok( ! $author->can_edit_entry(1) );
ok(   $author->can_edit_entry(2) );
ok(   $perm->can_post );
ok( ! $perm->can_upload );
ok( ! $perm->can_edit_all_posts );
ok(   $perm->can_edit_templates );
ok( ! $perm->can_edit_config );
ok( ! $perm->can_rebuild );
ok( ! $perm->can_send_notifications );
ok( ! $perm->can_edit_categories );
ok( ! $perm->can_edit_notifications );
ok( ! $perm->can_administer_blog );
}
