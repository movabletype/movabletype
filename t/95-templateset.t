#!/usr/bin/perl

use strict;
use warnings;

use lib 't/lib', 'lib', 'extlib';
use Test::More tests => 7;

BEGIN {
        $ENV{MT_APP} = 'MT::App::CMS';
}

use MT;
use MT::CMS::Entry;
use MT::Blog;
use MT::Test qw( :app :db :data );

my $app = MT::App::CMS->instance();

# get the current list of template sets from registry
my $sets = $app->registry("template_sets");
ok ($sets, "Template sets exist");
ok (exists $sets->{"motion"}, "Motion template set exists");
ok (exists $sets->{"streams"}, "Streams template set exists");
ok (exists $sets->{"professional_website"}, "Professional website template set exists");
ok (exists $sets->{"mt_community_blog"}, "Community blog template set exists");
ok (exists $sets->{"mt_blog"}, "Blog template set exists");
ok (exists $sets->{"mt_community_forum"}, "Community forum template set exists");
