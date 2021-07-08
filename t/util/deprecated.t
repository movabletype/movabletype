use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib"; # /lib
use Test::More;
use MT::Util::Deprecated;

sub version_numify { MT::Util::Deprecated::version_numify(@_) }
sub version_subtraction { MT::Util::Deprecated::version_subtraction(@_) }

my $expected = version->parse('v1.2.0');

is version_numify('1.2'), $expected;
is version_numify('1.02'), $expected;
is version_numify('1.002'), $expected;
is version_numify('1.002.000'), $expected;
is version_numify('1.2.0'), $expected;
is version_numify('v1.2'), $expected;
is version_numify('v1.002'), $expected;
is version_numify('v1.002.000'), $expected;
ok $expected > version_numify('v1.1.0');
ok $expected > version_numify('v1.1');
ok $expected > version_numify('1.1');
ok $expected > version_numify('1.1.0');
ok $expected > version_numify('1.001.000');
ok $expected > version_numify('1.1.1');
ok $expected < version_numify('1.2.1');
ok $expected < version_numify('v1.2.1');
ok $expected < version_numify('v1.3');
ok $expected < version_numify('1.3');
ok $expected < version_numify('1.3.0');
ok $expected < version_numify('1.10.0');
ok $expected < version_numify('v1.10.0');
is version_subtraction('1.3', '1.2'), 0.001;
is version_subtraction('1.03', '1.02'), 0.001;
is version_subtraction('1.003', '1.002'), 0.001;
is version_subtraction('1.006', '1.002'), 0.004;
is version_subtraction('1.002', '1.006'), -0.004;
is version_subtraction('v1.2.1', 'v1.2.0'), 0.000001;
is version_subtraction('1.10', '1.1'), 0.009;
is version_subtraction('v1.10', 'v1.1'), 0.009;

done_testing();
