# $Id$

BEGIN { unshift @INC, 't/' }

use strict;
use Test;
use Test::MockObject;
use MT::XMLRPC;
use MT;
use HTTP::Response;

BEGIN { plan tests => 7 }

use vars qw( $DB_DIR $T_CFG );
require 'test-common.pl';
require 'blog-common.pl';
my $mt = MT->new( Config => $T_CFG ) or die MT->errstr;

my $blog = MT::Blog->load(1);
ok($blog);

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
        skip(1);
    }
exit 0;

my $server = "192.168.1.104";

use Net::Ping;

my $p = Net::Ping->new();
die "Test update server $server is unreachable" unless $p->ping($server);

{
my $res = MT::XMLRPC->ping_update('foo.ping', $blog,
                                  'http://' . $server . '/mt-test-rpc.cgi');
ok($res);

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
ok($res);

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
ok(!$res);
ok(MT::XMLRPC->errstr, "Ping error: Sorry, but your ping failed!\n");
}
sub _set_response {
    my($str) = @_;
    no warnings 'once';
    *HTTP::Response::content = sub { $str };
}
