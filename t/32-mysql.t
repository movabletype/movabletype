# $Id$

BEGIN { unshift @INC, 't/' }

use MT;
use Test;
use Foo;
use Bar;
use strict;

BEGIN { plan tests => 190 };

use vars qw( $T_SCHEMA );
require 'test-common.pl';

my $mt = new MT;
my $T_CFG = -r 't/mysql.cfg' ? 't/mysql.cfg' : $ENV{HOME} .'/mysql-test.cfg';
die "Please configure the mysql tests by creating $T_CFG with your database, " . 
    "username, and password" unless (-r $T_CFG);
my $mgr = MT::ConfigMgr->new();
$mgr->read_config($T_CFG);

MT::Object->set_driver('DBI::mysql') or die MT::ObjectDriver->errstr;

my $driver = $MT::Object::DRIVER;
$driver->{dbh}->do("drop table mt_foo if exists mt_foo");
$driver->{dbh}->do("drop table mt_bar if exists mt_bar");

open FH, $T_SCHEMA or die "Can't open '$T_SCHEMA: $!";
local $/ = ";\n";
while (my $sql = <FH>) {
    $sql =~ s!^\s*!!;
    $sql =~ s!;\s*$!!;
    $driver->{dbh}->do($sql) or die $driver->{dbh}->errstr;
}

require 'driver-tests.pl';

$driver->{dbh}->do("drop table mt_foo if exists mt_foo");
$driver->{dbh}->do("drop table mt_bar if exists mt_bar");
