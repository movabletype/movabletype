#!/usr/bin/perl
# $Id$
use strict;
use warnings;
use Test::More tests => 1;
use lib 't/lib';
use LWP::UserAgent::Local;
$ENV{CONFIG} = 't/mt.cfg';
my $ua = LWP::UserAgent::Local->new({ScriptAlias => '/'});
my $req = HTTP::Request->new(GET => 'http://localhost/mt-atom.cgi/weblog/blog_id=1');
my $resp = $ua->request($req);
ok($resp->content(), "resp->content");
