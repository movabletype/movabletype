#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib t/lib);

use Test::More;

use MT::Test qw(:db);
use MT;

my $mt = MT->instance;
my $cfg = $mt->config;

my $domain = 'example.com';


note('Initial status');
ok($cfg->read_config_db, 'Read all config values from database');
is_deeply([$cfg->OutboundTrackbackDomains], [], 'Inial value is empty');
ok($cfg->set('OutboundTrackbackDomains', $domain, 1), 'Set value for the with db_flag');
is_deeply([$cfg->OutboundTrackbackDomains], [$domain], 'Get saved value');
ok($cfg->save_config, 'Save config to database');

note('Re-read');
ok($cfg->read_config_db, 'Read all config values from database');
is_deeply([$cfg->OutboundTrackbackDomains], [$domain], 'Get saved value');


done_testing();
