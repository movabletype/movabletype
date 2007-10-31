#!/usr/bin/perl

use strict;
use Test::More qw(no_plan);

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}
use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use MT::Test qw(:db);
use MT;
use MT::Blog;
use MT::Author;
use MT::Role;
use MT::Association;
use MT::Group;
use MT::Request;

my $r = MT::Request->instance;

# Users:

my $user_brad = new MT::Author();
$user_brad->name('Brad');
$user_brad->set_password('(none)');
$user_brad->save or die $user_brad->errstr;

my $user_chris = new MT::Author();
$user_chris->name('Chris');
$user_chris->set_password('(none)');
$user_chris->save;

my $user_garth = new MT::Author();
$user_garth->name('Garth');
$user_garth->set_password('(none)');
$user_garth->save;

my $user_gene = new MT::Author();
$user_gene->name('Gene');
$user_gene->set_password('(none)');
$user_gene->save;

my $user_jason = new MT::Author;
$user_jason->set_password('(none)');
$user_jason->name('Jason');
$user_jason->is_superuser(1);
$user_jason->save;

my $user_lilia = new MT::Author();
$user_lilia->name('Lilia');
$user_lilia->set_password('(none)');
$user_lilia->save;

my $user_luke = new MT::Author();
$user_luke->name('Luke');
$user_luke->set_password('(none)');
$user_luke->save;

my $user_mark = new MT::Author();
$user_mark->name('Mark');
$user_mark->set_password('(none)');
$user_mark->save;

my $user_melody = new MT::Author();
$user_melody->name('Melody');
$user_melody->set_password('(none)');
$user_melody->save;

my $user_randy = new MT::Author();
$user_randy->name('Randy');
$user_randy->set_password('(none)');
$user_randy->save;

my $user_walt = new MT::Author;
$user_walt->name('Walt');
$user_walt->set_password('(none)');
$user_walt->save;

# Groups

my $group_designers = new MT::Group;
$group_designers->name('Designers');
$group_designers->save;
$group_designers->add_user($user_lilia);
$group_designers->add_user($user_walt);
$group_designers->add_user($user_luke);

my $group_engineers = new MT::Group;
$group_engineers->name('Engineers');
$group_engineers->save;
$group_engineers->add_user($user_brad);
$group_engineers->add_user($user_gene);
$group_engineers->add_user($user_randy);
$group_engineers->add_user($user_mark);
$group_engineers->add_user($user_garth);

my $group_it = new MT::Group;
$group_it->name('IT');
$group_it->add_user($user_jason);

my $group_managers = new MT::Group;
$group_managers->name('Managers');
$group_managers->save;
$group_managers->add_user($user_brad);
$group_managers->add_user($user_garth);
$group_managers->add_user($user_randy);

my $group_mt = new MT::Group;
$group_mt->name('Movable Type');
$group_mt->save;
$group_mt->add_user($user_brad);
$group_mt->add_user($user_gene);
$group_mt->add_user($user_luke);
$group_mt->add_user($user_chris);

my $group_qa = new MT::Group;
$group_qa->name('QA');
$group_qa->save;
$group_qa->add_user($user_chris);

my $group_typepad = new MT::Group;
$group_typepad->name('TypePad');
$group_typepad->save;
$group_typepad->add_user($user_garth);
$group_typepad->add_user($user_mark);
$group_typepad->add_user($user_walt);

my $group_vox = new MT::Group;
$group_vox->name('Vox');
$group_vox->save;
$group_vox->add_user($user_lilia);
$group_vox->add_user($user_randy);

my $role_design = new MT::Role;
$role_design->name('Custom Designer');
$role_design->set_these_permissions('edit_templates');
$role_design->save;

my $role_admin = new MT::Role;
$role_admin->name('Custom Administrator');
$role_admin->set_these_permissions('administer_blog');
$role_admin->save;

my $role_writer = new MT::Role;
$role_writer->name('Custom Writer');
$role_writer->set_these_permissions('create_post');
$role_writer->save;

# Blogs

my $blog_mt = new MT::Blog;
$blog_mt->name('Movable Type');
$blog_mt->save;

my $blog_vox = new MT::Blog;
$blog_vox->name('Vox Themes');
$blog_vox->save;

my $blog_qa = new MT::Blog;
$blog_qa->name('QA Central');
$blog_qa->save;

my $blog_db = new MT::Blog;
$blog_db->name('Daily Build');
$blog_db->save;

my $blog_mgt = new MT::Blog;
$blog_mgt->name('Management');
$blog_mgt->save;

my $blog_tp = new MT::Blog;
$blog_tp->name('TypePadding');
$blog_tp->save;

# Associations

MT::Association->link($blog_mt => $group_mt => $role_writer);
MT::Association->link($blog_mt => $user_brad => $role_design);
MT::Association->link($blog_vox => $group_vox => $role_writer);
MT::Association->link($blog_qa => $group_qa => $role_writer);
MT::Association->link($blog_db => $group_engineers => $role_writer);
MT::Association->link($blog_mgt => $group_managers => $role_writer);
MT::Association->link($blog_tp => $group_typepad => $role_writer);

MT::Association->link($blog_mt => $group_designers => $role_design);
MT::Association->link($blog_vox => $group_designers => $role_design);
MT::Association->link($blog_qa => $group_designers => $role_design);
MT::Association->link($blog_db => $group_designers => $role_design);
MT::Association->link($blog_mgt => $group_designers => $role_design);
MT::Association->link($blog_tp => $group_designers => $role_design);

# Test 1 -- All blogs that designers have access to

my @blogs;
if (my $blog_iter = $group_designers->blog_iter()) {
    while (my $blog = $blog_iter->()) {
        push @blogs, $blog;
    }
}
is(@blogs, 6);

# Blogs Walt has access to (all, through design group)

@blogs = ();
if (my $blog_iter = $user_walt->blog_iter()) {
    while (my $blog = $blog_iter->()) {
        push @blogs, $blog;
    }
}
is(@blogs, 6);

# Blogs Brad has access to (MT, Daily Build, Managers)

@blogs = ();
if (my $blog_iter = $user_brad->blog_iter()) {
    while (my $blog = $blog_iter->()) {
        push @blogs, $blog;
    }
}
is(@blogs, 3);

# Blog count for Melody

@blogs = ();
if (my $blog_iter = $user_melody->blog_iter()) {
    while (my $blog = $blog_iter->()) {
        push @blogs, $blog;
    }
}
is(@blogs, 0);

# Can Brad edit templates the Daily Build blog?

ok(!$user_brad->permissions($blog_db)->can_edit_templates);

# Can Walt edit MT templates? Yes

ok($user_walt->permissions($blog_mt)->can_edit_templates);

MT::Association->link($user_walt => $role_writer => $blog_mt);

$r->reset();

# Can Walt write to MT? Yes

ok($user_walt->permissions($blog_mt)->can_create_post);

MT::Association->unlink($user_walt => $role_writer => $blog_mt);

$r->reset();

# Can Walt write to MT? No

ok(!$user_walt->permissions($blog_mt)->can_create_post);

$group_designers->remove_user($user_walt);

$r->reset();

# Can Walt edit MT templates? No

ok(!$user_walt->permissions($blog_mt)->can_edit_templates);

$group_designers->add_user($user_walt);

$r->reset();

# Can Walt edit MT templates? Yes

ok($user_walt->permissions($blog_mt)->can_edit_templates);

# Disable designer group

$group_designers->status(MT::Group::INACTIVE());
$group_designers->save;

$r->reset();

# Can Walt edit MT templates? No

ok(!$user_walt->permissions($blog_mt)->can_edit_templates);
ok(!$user_luke->permissions($blog_vox)->can_edit_templates);
ok(!$user_lilia->permissions($blog_tp)->can_edit_templates);

# Enable designer group

$group_designers->status(MT::Group::ACTIVE());
$group_designers->save;

$r->reset();

# Can Walt edit MT templates? Yes

ok($user_walt->permissions($blog_mt)->can_edit_templates);
ok($user_luke->permissions($blog_vox)->can_edit_templates);
ok($user_lilia->permissions($blog_tp)->can_edit_templates);
