# $Id$

use strict;
use MT::ErrorHandler;
use Test;

BEGIN { plan tests => 9 };

my $eh = MT::ErrorHandler->new;
ok($eh);
my $val = $eh->error('foo bar');
ok(!defined $val);
ok($eh->errstr eq "foo bar\n");
my @val = $eh->error('foo');
ok(@val == 0);
ok($eh->errstr eq "foo\n");

$val = MT::ErrorHandler->error('foo bar');
ok(!defined $val);
ok(MT::ErrorHandler->errstr eq "foo bar\n");
@val = MT::ErrorHandler->error('foo');
ok(@val == 0);
ok(MT::ErrorHandler->errstr eq "foo\n");
