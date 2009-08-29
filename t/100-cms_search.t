#!/usr/bin/perl

use strict;
use warnings;

use lib 't/lib', 'lib', 'extlib';
use Test::More tests => 40;

BEGIN {
        $ENV{MT_APP} = 'MT::App::CMS';
}

use MT;
use MT::Author;
use MT::Blog;
use MT::Test qw( :app :db :data );

my $blog = MT::Blog->load(1);
my $user = MT::Author->load(2);

my ($app, $out);

# global search for a template
# __mode=search_replace&_type=template&do_search=1&search=hello
$app = _run_app( 
	'MT::App::CMS', 
	{ __test_user => $user, __mode => 'search_replace', do_search => 1, search => 'movable', _type => 'template' } 
);
$out = delete $app->{__test_output};
ok ($out, "Global template search results are present");
ok ($out =~ /Publish selected templates/i, "Publish templates button is present");
ok ($out =~ /Delete selected templates/i, "Delete templates button is present");
ok ($out =~ /Refresh template\(s\)/i, "Refresh templates dropdown is present");
ok ($out =~ /Clone template\(s\)/i, "Clone templates dropdown is present");

# blog search for a template
# __mode=search_replace&_type=template&do_search=1&search=hello&blog_id=1
$app = _run_app( 
	'MT::App::CMS', 
	{ __test_user => $user, __mode => 'search_replace', blog_id => $blog->id, do_search => 1, search => 'index', _type => 'template' } 
);
$out = delete $app->{__test_output};
ok ($out, "Blog template search results are present");
ok ($out =~ /Publish selected templates/i, "Publish templates button is present");
ok ($out =~ /Delete selected templates/i, "Delete templates button is present");
ok ($out =~ /Refresh template\(s\)/i, "Refresh templates dropdown is present");
ok ($out =~ /Clone template\(s\)/i, "Clone templates dropdown is present");

# global search for an entry
# __mode=search_replace&_type=entry&do_search=1&search=hello
$app = _run_app( 
	'MT::App::CMS', 
	{ __test_user => $user, __mode => 'search_replace', do_search => 1, search => 'rain', _type => 'entry' } 
);
$out = delete $app->{__test_output};
ok ($out, "Global entry search results are present");
ok ($out =~ /Republish selected entries/i, "Publish entries button is present");
ok ($out =~ /Delete selected entries/i, "Delete entries button is present");
ok ($out =~ /Add tags/i, "Add tags dropdown is present");
ok ($out =~ /Remove tags/i, "Remove tags dropdown is present");

# blog seaarch for an entry
# __mode=search_replace&_type=entry&do_search=1&search=hello&blog_id=1
$app = _run_app( 
	'MT::App::CMS', 
	{ __test_user => $user, __mode => 'search_replace', blog_id => $blog->id, do_search => 1, search => 'rain', _type => 'entry' } 
);
$out = delete $app->{__test_output};
ok ($out, "Blog entry search results are present");
ok ($out =~ /Republish selected entries/i, "Publish entries button is present");
ok ($out =~ /Delete selected entries/i, "Delete entries button is present");
ok ($out =~ /Unpublish entries/i, "Unpublish entries dropdown is present");
ok ($out =~ /Add tags/i, "Add tags dropdown is present");
ok ($out =~ /Remove tags/i, "Remove tags dropdown is present");
ok ($out =~ /Batch edit entries/i, "Batch edit entries dropdown is present");

# global search for a comment
# __mode=search_replace&_type=comment&do_search=1&search=hello
$app = _run_app( 
	'MT::App::CMS', 
	{ __test_user => $user, __mode => 'search_replace', do_search => 1, search => 'comment', _type => 'comment' } 
);
$out = delete $app->{__test_output};
ok ($out, "Global comment search results are present");
ok ($out =~ /Publish selected comments/i, "Publish comments button is present");
ok ($out =~ /Delete selected comments/i, "Delete comments button is present");
ok ($out =~ /Report selected comments as spam/i, "Spam comments button is present");
ok ($out =~ /Unpublish comment\(s\)/i, "Unpublish comments dropdown is present");
ok ($out =~ /Trust commenter\(s\)/i, "Trust commenter dropdown is present");
ok ($out =~ /Untrust commenter\(s\)/i, "Untrust commenter dropdown is present");
ok ($out =~ /Ban commenter\(s\)/i, "Ban commenter dropdown is present");
ok ($out =~ /Unban commenter\(s\)/i, "Unban commenter dropdown is present");

# blog search for a comment
# __mode=search_replace&_type=comment&do_search=1&search=hello&blog_id=1
$app = _run_app( 
	'MT::App::CMS', 
	{ __test_user => $user, __mode => 'search_replace', blog_id => $blog->id, do_search => 1, search => 'comment', _type => 'comment' } 
);
$out = delete $app->{__test_output};
ok ($out, "Blog comment search results are present");
ok ($out =~ /Publish selected comments/i, "Publish comments button is present");
ok ($out =~ /Delete selected comments/i, "Delete comments button is present");
ok ($out =~ /Report selected comments as spam/i, "Spam comments button is present");
ok ($out =~ /Unpublish comment\(s\)/i, "Unpublish comments dropdown is present");
ok ($out =~ /Trust commenter\(s\)/i, "Trust commenter dropdown is present");
ok ($out =~ /Untrust commenter\(s\)/i, "Untrust commenter dropdown is present");
ok ($out =~ /Ban commenter\(s\)/i, "Ban commenter dropdown is present");
ok ($out =~ /Unban commenter\(s\)/i, "Unban commenter dropdown is present");