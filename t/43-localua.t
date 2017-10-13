#!/usr/bin/perl
# $Id: 43-localua.t 3531 2009-03-12 09:11:52Z fumiakiy $
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use Test::More tests => 1;
use lib 't/lib';
use LWP::UserAgent::Local;
$ENV{CONFIG} = 't/mt.cfg';
my $ua = LWP::UserAgent::Local->new({ScriptAlias => '/'});
my $req = HTTP::Request->new(GET => 'http://localhost/mt-atom.cgi/weblog/blog_id=1');
my $resp = $ua->request($req);
ok($resp->content(), "resp->content");
