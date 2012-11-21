#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib qw( extlib lib t/lib );


use MT::Test qw( :app :db );
use MT::Test::Permission;
use Test::More;

my $mt = MT->instance;

### Make test data

# Website
my $website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog(
    parent_id => $website->id,
);
my $second_blog = MT::Test::Permission->make_blog(
    parent_id => $website->id,
);

# Author
my $aikawa = MT::Test::Permission->make_author(
    name => 'aikawa',
    nickname => 'Ichiro Aikawa',
);

my $ichikawa = MT::Test::Permission->make_author(
    name => 'ichikawa',
    nickname => 'Jiro Ichikawa',
);

my $ukawa = MT::Test::Permission->make_author(
    name => 'ukawa',
    nickname => 'Saburo Ukawa',
);

my $egawa = MT::Test::Permission->make_author(
    name => 'egawa',
    nickname => 'Shiro Egawa',
);

my $ogawa = MT::Test::Permission->make_author(
    name => 'ogawa',
    nickname => 'Goro Ogawa',
);

my $kagawa = MT::Test::Permission->make_author(
    name => 'kagawa',
    nickname => 'Ichiro Kagawa',
);

my $kikkawa = MT::Test::Permission->make_author(
    name => 'kikkawa',
    nickname => 'Jiro Kikkawa',
);

my $kumekawa = MT::Test::Permission->make_author(
    name => 'kumekawa',
    nickname => 'Saburo Kumekawa',
);

my $kemikawa = MT::Test::Permission->make_author(
    name => 'kemikawa',
    nickname => 'Shiro Kemikawa',
);

my $koishikawa = MT::Test::Permission->make_author(
    name => 'koishikawa',
    nickname => 'Goro Koishikawa',
);

my $sagawa = MT::Test::Permission->make_author(
    name => 'sagawa',
    nickname => 'Ichiro Sagawa',
);

my $shimoda = MT::Test::Permission->make_author(
    name => 'shimoda',
    nickname => 'Jiro Shimoda',
);

my $suda = MT::Test::Permission->make_author(
    name => 'suda',
    nickname => 'Saburo Suda',
);

my $seta = MT::Test::Permission->make_author(
    name => 'seta',
    nickname => 'Shiro Seta',
);

my $admin = MT::Author->load(1);

# Role
my $create_post = MT::Test::Permission->make_role(
   name  => 'Create Post',
   permissions => "'create_post'",
);

my $edit_all_posts = MT::Test::Permission->make_role(
   name  => 'Edit All Posts',
   permissions => "'edit_all_posts'",
);

my $manage_pages = MT::Test::Permission->make_role(
   name  => 'Manage Pages',
   permissions => "'manage_pages'",
);

my $publish_post = MT::Test::Permission->make_role(
   name  => 'Publish Post',
   permissions => "'publish_post'",
);

my $edit_config = MT::Test::Permission->make_role(
   name  => 'Edit Config',
   permissions => "'edit_config'",
);

my $designer = MT::Role->load( { name => MT->translate( 'Designer' ) } );

require MT::Association;
MT::Association->link( $aikawa => $edit_config => $blog );
MT::Association->link( $ichikawa => $create_post => $blog );
MT::Association->link( $ukawa => $edit_all_posts => $blog );
MT::Association->link( $egawa => $manage_pages => $blog );
MT::Association->link( $ogawa => $create_post => $blog );
MT::Association->link( $kagawa => $designer => $blog );
MT::Association->link( $shimoda => $publish_post => $blog );
MT::Association->link( $seta => $publish_post => $blog );

MT::Association->link( $kikkawa => $edit_config => $second_blog );
MT::Association->link( $kumekawa => $create_post => $second_blog );
MT::Association->link( $koishikawa => $edit_all_posts => $second_blog );
MT::Association->link( $kemikawa => $manage_pages => $second_blog );
MT::Association->link( $suda => $publish_post => $second_blog );


my $ichikawa_template = $mt->model('formatted_text')->new;
$ichikawa_template->set_values({
    blog_id    => $blog->id,
    created_by => $ichikawa->id,
});

my $ukawa_template   = $mt->model('formatted_text')->new;
$ukawa_template->set_values({
    blog_id    => $blog->id,
    created_by => $ukawa->id,
});


use FormattedText::App;


note('FormattedText::App::can_edit_formatted_text (for new object)');

ok(FormattedText::App::can_edit_formatted_text($ichikawa->permissions($blog), undef, $ichikawa), 'Permission: Create Post: Can create boilerplate');

ok(FormattedText::App::can_edit_formatted_text($ukawa->permissions($blog), undef, $ukawa), 'Permission: Edit All Posts: Can create boilerplate');

ok(! FormattedText::App::can_edit_formatted_text($egawa->permissions($blog), undef, $aikawa), 'Permission: Manage Pages: Cannot create boilerplate');

ok(! FormattedText::App::can_edit_formatted_text($aikawa->permissions($blog), undef, $aikawa), 'Permission: Edit Config: Cannot create boilerplate');


note('FormattedText::App::can_edit_formatted_text (for existing object)');

ok(FormattedText::App::can_edit_formatted_text($ichikawa->permissions($blog), $ichikawa_template, $ichikawa), 'Permission: Create Post: Can edit boilerplate created by oneself');
ok(! FormattedText::App::can_edit_formatted_text($ichikawa->permissions($blog), $ukawa_template, $ichikawa), 'Permission: Create Post: Cannot edit boilerplate created by others');

ok(FormattedText::App::can_edit_formatted_text($ukawa->permissions($blog), $ukawa_template, $ukawa), 'Permission: Edit All Posts: Can edit boilerplate created by oneself');
ok(FormattedText::App::can_edit_formatted_text($ukawa->permissions($blog), $ichikawa_template, $ukawa), 'Permission: Edit All Posts: Can edit boilerplate created by others');

ok(! FormattedText::App::can_edit_formatted_text($egawa->permissions($blog), $ichikawa_template, $egawa), 'Permission: Manage Pages: Cannot edit boilerplate');

ok(! FormattedText::App::can_edit_formatted_text($aikawa->permissions($blog), $ichikawa_template, $aikawa), 'Permission: Edit Config: Cannot edit boilerplate');


note('FormattedText::App::can_view_formatted_text');

ok(FormattedText::App::can_view_formatted_text($ichikawa->permissions($blog), $ichikawa_template, $ichikawa), 'Permission: Create Post: Can view boilerplate created by oneself');
ok(FormattedText::App::can_view_formatted_text($ichikawa->permissions($blog), $ukawa_template, $ichikawa), 'Permission: Create Post: Cannot view boilerplate created by others');

ok(FormattedText::App::can_view_formatted_text($ukawa->permissions($blog), $ukawa_template, $ukawa), 'Permission: Edit All Posts: Can view boilerplate created by oneself');
ok(FormattedText::App::can_view_formatted_text($ukawa->permissions($blog), $ichikawa_template, $ukawa), 'Permission: Edit All Posts: Can view boilerplate created by others');

ok(! FormattedText::App::can_view_formatted_text($egawa->permissions($blog), $ichikawa_template, $egawa), 'Permission: Manage Pages: Cannot view boilerplate');

ok(! FormattedText::App::can_view_formatted_text($aikawa->permissions($blog), $ichikawa_template, $aikawa), 'Permission: Edit Config: Cannot view boilerplate');


done_testing;
