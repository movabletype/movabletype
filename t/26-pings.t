#!/usr/bin/perl
# $Id$
use strict;
use warnings;

use lib 't/lib';
use lib 't/extlib';
use lib 'lib';

use Test::More;

plan tests => 14;
#plan skip_all => "Needs rewrite to eliminate HTTP server requirement.";
#exit;

use HTTP::Response;
use Net::Ping;

use MT;
use MT::XMLRPC;
use vars qw( $DB_DIR $T_CFG );

use MT::Test;
MT::Test->import( qw(:db :data) );

my $mt = MT->new( Config => $T_CFG ) or die MT->errstr;
isa_ok($mt, 'MT');

my $blog = MT::Blog->load(1);
isa_ok($blog, 'MT::Blog');

_set_response(<<RES);
    <<RES;
<?xml version='1.0'?>
<methodResponse>
<params>
<param>
<value><struct>
<member>
<name>flerror</name>
<value><boolean>0</boolean></value>
</member>
<member>
<name>message</name>
<value><string>Chomp! Thanks for the ping.</string></value>
</member>
</struct></value>
</param>
</params>
</methodResponse>
RES

for (my $i = 1; $i < 7; $i++) {
    SKIP: { skip('what?', 1); }
}

my $server = "192.168.1.104";
my $p = Net::Ping->new();
SKIP: {
    skip("Test update server $server is unreachable", 5)
        unless $p->ping($server);
    ok(1, "ping");

{
my $res = MT::XMLRPC->ping_update('foo.ping', $blog,
                                  'http://' . $server . '/mt-test-rpc.cgi');
ok($res, 'ping_update');

_set_response(<<RES);
    <<RES;
<?xml version='1.0'?>
<methodResponse>
<params>
<param>
<value><struct>
<member>
<name>flerror</name>
<value><boolean>1</boolean></value>
</member>
<member>
<name>message</name>
<value>Sorry, but your ping failed!</value>
</member>
</struct></value>
</param>
</params>
</methodResponse>
RES
}

{
my $res = MT::XMLRPC->ping_update('foo.ping', $blog, 'http://' . $server . '/mt-test-rpc.cgi');
ok(!$res);
ok(MT::XMLRPC->errstr, "Ping error: Sorry, but your ping failed!\n");

_set_response(<<RES);
    <<RES;
<?xml version='1.0'?>
<methodResponse>
<params>
<param>
<value><struct>
<member>
<name>message</name>
<value><string>Chomp! Thanks for the ping.</string></value>
</member>
<member>
<name>flerror</name>
<value><boolean>0</boolean></value>
</member>
</struct></value>
</param>
</params>
</methodResponse>
RES
}

{
my $res = MT::XMLRPC->ping_update('foo.ping', $blog, 
                                  'http://' . $server . '/mt-test-rpc.cgi');
ok($res, 'response');

_set_response(<<RES);
    <<RES;
<?xml version='1.0'?>
<methodResponse>
<params>
<param>
<value><struct>
<member>
<name>message</name>
<value>Sorry, but your ping failed!</value>
</member>
<member>
<name>flerror</name>
<value><boolean>1</boolean></value>
</member>
</struct></value>
</param>
</params>
</methodResponse>
RES
}
{
MT::XMLRPC->error('');
my $res = MT::XMLRPC->ping_update('foo.ping', $blog, 
                                  'http://'. $server. '/mt-test-rpc.cgi');
ok(!$res, 'no response');
is(MT::XMLRPC->errstr, "Ping error: Sorry, but your ping failed!\n", 'errstr');
}
}

sub _set_response {
    my($str) = @_;
    no warnings 'once';
    *HTTP::Response::content = sub { $str };
}
