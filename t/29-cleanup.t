# $Id$

BEGIN { unshift @INC, 't/' }

use Test;
use strict;

BEGIN { plan tests => 1 };

use vars qw( $DB_DIR $T_CFG );
require 'test-common.pl';

system "rm -rf $DB_DIR";
#unlink $T_CFG;
ok(1);
