#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

plan tests => 24;

BEGIN {
        $ENV{MT_APP} = 'MT::App::CMS';
}

use MT;
use MT::Author;
use MT::Blog;
use MT::Test;

MT::Test->init_app;

$test_env->prepare_fixture('db_data');

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
ok ($out !~ /Publish selected templates/i, "Publish templates button isn't present for global template search");
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
	{ __test_user => $user, __mode => 'search_replace', blog_id => 0, do_search => 1, search => 'rain', _type => 'entry' } 
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
	{ __test_user => $user, __mode => 'search_replace', blog_id => 0, do_search => 1, search => 'comment', _type => 'comment' } 
);
$out = delete $app->{__test_output};
ok ($out, "Global comment search results are present");

# blog search for a comment
# __mode=search_replace&_type=comment&do_search=1&search=hello&blog_id=1
$app = _run_app( 
	'MT::App::CMS', 
	{ __test_user => $user, __mode => 'search_replace', blog_id => $blog->id, do_search => 1, search => 'comment', _type => 'comment' } 
);
$out = delete $app->{__test_output};
ok ($out, "Blog comment search results are present");
