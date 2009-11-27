#!/usr/bin/perl
# $Id: 21-app-callbacks.t 3531 2009-03-12 09:11:52Z fumiakiy $
use strict;
use warnings;

use Test::More tests => 3;
use CGI;

use lib qw( t/lib t );
use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
BEGIN { require 'test-common.pl'; print "after test-config\n"; }

use MT::Test qw( :cms :db :data );

use MT::Plugin;
use MT::Entry;

### Test app callbacks

my @result_cats = ();

my $cms = MT::App::CMS->new();

my $plugin = MT::Plugin->new({name => "21-app-callbacks.t"});

my $entry2 = MT::Entry->load({}, { limit => 1 });

my $app_post_save_called;
MT->add_callback('AppPostEntrySave', 1, $plugin, 
                 sub { 
                       $app_post_save_called = 1;
                       my @plcmts = MT::Placement->load({entry_id => $_[2]->id});
                       for my $plcmt (@plcmts) {
                           push @result_cats, $plcmt->category_id;
                       }
                   } );

MT::unplug();
my $q = CGI->new();
$q->param(id => $entry2->id);
$q->param(blog_id => $entry2->blog_id);
$q->param(category_ids => 17);
$q->param(author_id => 1);
$q->param(status => 1);
# $q->param(username => 'Chuck D');
# $q->param(password => 'bass');
$q->param(text => "Buddha blessed and boo-ya blasted; 
these are the words that she manifested.");
$cms->{query} = $q;
$cms->{perms} = MT::Permission->new();
$cms->{perms}->can_post(1);
$cms->{author} = MT::Author->new();
$cms->{author}->name("Mel E. Mel");
$cms->{author}->id(1);

# fake out the magic; we're not testing that right now
no warnings qw(once redefine);
*MT::App::CMS::validate_magic = sub { 1; };
use warnings qw(once redefine);

my $handler = $cms->handler_to_coderef( $cms->handlers_for_mode('save_entry') );
my $ret = $handler->($cms);
ok(!defined $ret && $cms->{redirect}, 'entry save was successful');
diag('Error: ' . $cms->errstr) if !defined $ret && !$cms->{redirect};

ok($app_post_save_called, 'AppPostEntrySave callback was called');
is($result_cats[0], 17, 'result_cats = 17');

