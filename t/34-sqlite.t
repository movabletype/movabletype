# $Id$

BEGIN { unshift @INC, 't/' }

use MT;
use Test;
use Foo;
use Bar;
use strict;

BEGIN { plan tests => 190 };

use vars qw( $T_SCHEMA_SQLITE $SQLITE_DB );
require 'test-common.pl';

my $driver_name = 'sqlite';
use MT;
my $T_CFG = -r "t/$driver_name-test.cfg" ? "t/$driver_name-test.cfg" : $ENV{HOME} ."/$driver_name-test.cfg";
die "Please configure the $driver_name tests by creating $T_CFG with your " .
    "database, username, and password" unless (-r $T_CFG);
my $mt = new MT(Config => $T_CFG);

eval {
    require DBD::SQLite;
}; if ($@) {
    die "Skipping tests, SQLite not available";
}
# MT::Object->set_driver('DBI::sqlite')
#     or die "Can't connect: ", MT::Object->errstr;

my $driver = $MT::Object::DRIVER;
$driver->{dbh}->do("drop table mt_foo");
$driver->{dbh}->do("drop table mt_bar");

open FH, $T_SCHEMA_SQLITE or die "Can't open '$T_SCHEMA_SQLITE': $!";
local $/ = ";\n";
while (my $sql = <FH>) {
    $sql =~ s!^\s*!!;
    $sql =~ s!;\s*$!!;
    $driver->{dbh}->do($sql) or die $driver->{dbh}->errstr;
}

require 'driver-tests.pl';
unlink($SQLITE_DB);
