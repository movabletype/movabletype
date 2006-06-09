# $Id$

BEGIN { unshift @INC, 't/' }

use MT;
use Test;
use Foo;
use Bar;
use strict;

BEGIN { plan tests => 190 };

use vars qw( $T_SCHEMA_PG );
require 'test-common.pl';

my $driver_name = 'postgres';

use MT;
my $mt = new MT;
my $T_CFG = -r "t/$driver_name-test.cfg" ? "t/$driver_name-test.cfg" : $ENV{HOME} ."/$driver_name-test.cfg";
die "Please configure the $driver_name tests by creating $T_CFG with your " .
    " database, username, and password" unless (-r $T_CFG);
my $mgr = MT::ConfigMgr->new();
$mgr->read_config($T_CFG);

MT::Object->set_driver('DBI::postgres')
    or die "Can't connect: ", MT::Object->errstr;

my $driver = $MT::Object::DRIVER;
$driver->{dbh}->do("drop table mt_foo");
$driver->{dbh}->do("drop sequence mt_foo_id");
$driver->{dbh}->do("drop table mt_bar");
$driver->{dbh}->do("drop sequence mt_bar_id");

open FH, $T_SCHEMA_PG or die "Can't open '$T_SCHEMA_PG': $!";
local $/ = ";\n";
while (my $sql = <FH>) {
    $sql =~ s!^\s*!!;
    $sql =~ s!;\s*$!!;
    $driver->{dbh}->do($sql) or die $driver->{dbh}->errstr;
}

#$MT::DebugMode = 0;
require 'driver-tests.pl';
