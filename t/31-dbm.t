# $Id$

BEGIN { unshift @INC, 't/' }

use MT;
use Test;
use Foo;
use Bar;
use strict;

BEGIN { plan tests => 190 };

use vars qw( $DB_DIR );
require 'test-common.pl';

if (-d $DB_DIR) {
    system "rm -rf $DB_DIR";
}
mkdir $DB_DIR or die "Can't create dir '$DB_DIR': $!";

my $mgr = MT::ConfigMgr->instance;
$mgr->DataSource($DB_DIR);

MT::Object->set_driver('DBM');

require 'driver-tests.pl';

system "rm -rf $DB_DIR";
