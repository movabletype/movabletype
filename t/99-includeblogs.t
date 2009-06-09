#!/usr/bin/perl

use strict;
use warnings;

use lib 't/lib', 'lib', 'extlib';
use Test::More tests => 9;

BEGIN {
        $ENV{MT_APP} = 'MT::App::Search';
}

use MT;
use MT::Author;
use MT::Association;
use MT::Blog;
use MT::Comment;
use MT::Entry;
use MT::Role;
use MT::Tag;
use MT::Template;
use MT::Template::Context;
use MT::Test qw( :app :db :data );

# Adding another blog since MT::Test only creates one blog
my $blog = MT::Blog->new();
$blog->set_values({
	name         => 'none2',
	site_url     => 'http://narnia.na/nana2/',
	archive_url  => 'http://narnia.na/nana2/archives/',
	site_path    => 't/site2/',
	archive_path => 't/site2/archives/',
	archive_type => 'Individual,Monthly,Weekly,Daily,Category,Page',
	archive_type_preferred   => 'Individual',
	description              => "Narnia None Test Blog 2",
	custom_dynamic_templates => 'custom',
	convert_paras            => 1,
	allow_reg_comments       => 1,
	allow_unreg_comments     => 0,
	allow_pings              => 1,
	sort_order_posts         => 'descend',
	sort_order_comments      => 'ascend',
	remote_auth_token        => 'token',
	convert_paras_comments   => 1,
	google_api_key           => 'r9Vj5K8PsjEu+OMsNZ/EEKjWmbCeQAv1',
	cc_license => 'by-nc-sa http://creativecommons.org/licenses/by-nc-sa/2.0/ http://creativecommons.org/images/public/somerights20.gif',
	server_offset        => '-3.5',
	children_modified_on => '20000101000000',
	language             => 'en_us',
	file_extension       => 'html',
});
$blog->id(2);
$blog->commenter_authenticators('enabled_TypeKey');
$blog->save() or die "Couldn't save blog 2: " . $blog->errstr;

# Create a new author for blog 2 and add author role for him
my $plim = MT::Author->new();
$plim->set_values({
	name       => 'Paolo',
	nickname   => 'Paolo',
	email      => 'plim@example.com',
	auth_type  => 'MT',
	created_on => '19780131075000',
});
$plim->set_password("flute");
$plim->type( MT::Author::AUTHOR() );
$plim->save() or die "Couldn't save author record: " . $plim->errstr;
my $author_role = MT::Role->load({ name => 'Author' });
my $assoc = MT::Association->new();
$assoc = MT::Association->new();
$assoc->author_id( $plim->id );
$assoc->blog_id($blog->id);
$assoc->role_id( $author_role->id );
$assoc->type(1);
$assoc->save();

# Add an entry to blog 2
my $entry = MT::Entry->new();
$entry->set_values({
	blog_id        => 2,
	title          => 'A Rainy Day 2',
	text           => 'On a drizzly day last weekend 2',
	text_more      => 'I took my grandpa for a walk.',
	excerpt        => 'A story of a stroll.',
	keywords       => 'keywords',
	created_on     => '19780131074500',
	authored_on    => '19780131074500',
	modified_on    => '19780131074600',
	authored_on    => '19780131074500',
	author_id      => $plim->id,
	pinged_urls    => 'http://technorati.com/',
	allow_comments => 1,
	allow_pings    => 1,
	status         => MT::Entry::RELEASE(),
});
$entry->tags( 'rain2', 'grandpa2', 'strolling2' );
$entry->save() or die "Couldn't save entry record: " . $entry->errstr;

# Add a comment to the new entry
my $cmt = MT::Comment->new();
$cmt->set_values({
	text => 'This is a boring comment.',
	entry_id   => $entry->id,
	author     => 'v14GrUH 4 cheep',
	visible    => 1,
	email      => 'jake@fatman.com',
	url        => 'http://fatman.com/',
	blog_id    => $blog->id,
	ip         => '127.0.0.1',
	created_on => '20040714182800',
});
$cmt->id(1);
$cmt->save() or die "Couldn't save comment record 1: " . $cmt->errstr;

# test if the objects were successfully created
ok ($entry->id, "New entry was created: " . $entry->title);
ok ($entry->tags, "New tags were created: " . $entry->tags);
ok ($cmt->id, "New comment was created: " . $cmt->text);
ok ($plim->id, "New author was created: " . $plim->name);

## NOW ON TO TESTING THE TAGS
my $tmpl;

# test for <mt:Entries include_blogs="all">
$tmpl = MT::Template->new;
$tmpl->blog_id ('1');
$tmpl->text ('<mt:Entries include_blogs="all"><mt:EntryTitle>, </mt:Entries>');
ok ($tmpl->output, "Got entries correctly: " . $tmpl->output);

# test for <mt:Comments include_blogs="all">
$tmpl = MT::Template->new;
$tmpl->blog_id ('1');
$tmpl->text ('<mt:Comments include_blogs="all"><mt:CommentBody>, </mt:Comments>');
ok ($tmpl->output, "Got comments correctly: " . $tmpl->output);

# test for <mt:Authors include_blogs="all">
$tmpl = MT::Template->new;
$tmpl->blog_id ('1');
$tmpl->text ('<mt:Authors include_blogs="all"><mt:AuthorName>, </mt:Authors>');
ok ($tmpl->output, "Template tag works correctly: " . $tmpl->output);

# test for <mt:Tags include_blogs="all">
$tmpl = MT::Template->new;
$tmpl->blog_id ('1');
$tmpl->text ('<mt:Tags include_blogs="all"><mt:TagName>, </mt:Tags>');
ok ($tmpl->output, "Template tag works correctly: " . $tmpl->output);

# test for IncludeBlogs=all in searches
my $app = _run_app( 'MT::App::Search', { search => "drizzly", IncludeBlogs => "all" } );
my $good_out = delete $app->{__test_output};
ok ($good_out, "Data is present: $good_out");


