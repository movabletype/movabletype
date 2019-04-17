use strict;
use warnings;

use Test::More;

use FindBin;
use lib "$FindBin::Bin/../../lib";       # lib
use lib "$FindBin::Bin/../../extlib";    # extlib;
use MT::version;

# MTC-26339

ok( MT::version->parse('7.0') == MT::version->parse('7.0') );

ok( MT::version->parse('7.0.1') > MT::version->parse('7.0') );
ok( MT::version->parse('7.0.1') == MT::version->parse('7.0.1') );

ok( MT::version->parse('7.0.2') > MT::version->parse('7.0') );
ok( MT::version->parse('7.0.2') > MT::version->parse('7.0.1') );
ok( MT::version->parse('7.0.2') == MT::version->parse('7.0.2') );

ok( MT::version->parse('7.1') > MT::version->parse('7.0') );
ok( MT::version->parse('7.1') > MT::version->parse('7.0.1') );
ok( MT::version->parse('7.1') == MT::version->parse('7.1') );

ok( MT::version->parse('7.1.1') > MT::version->parse('7.0') );
ok( MT::version->parse('7.1.1') > MT::version->parse('7.0.1') );
ok( MT::version->parse('7.1.1') > MT::version->parse('7.1') );
ok( MT::version->parse('7.1.1') == MT::version->parse('7.1.1') );

ok( MT::version->parse('7.2') > MT::version->parse('7.0') );
ok( MT::version->parse('7.2') > MT::version->parse('7.0.1') );
ok( MT::version->parse('7.2') > MT::version->parse('7.1') );
ok( MT::version->parse('7.2') > MT::version->parse('7.1.1') );
ok( MT::version->parse('7.2') == MT::version->parse('7.2') );

ok( MT::version->parse('7.2.1') > MT::version->parse('7.0') );
ok( MT::version->parse('7.2.1') > MT::version->parse('7.0.1') );
ok( MT::version->parse('7.2.1') > MT::version->parse('7.1') );
ok( MT::version->parse('7.2.1') > MT::version->parse('7.1.1') );
ok( MT::version->parse('7.2.1') > MT::version->parse('7.2') );
ok( MT::version->parse('7.2.1') == MT::version->parse('7.2.1') );

done_testing;

