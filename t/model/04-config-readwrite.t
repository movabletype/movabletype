#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT;
use MT::ConfigMgr;

$test_env->prepare_fixture('db');

my $mt  = MT->instance;
my $cfg = MT::ConfigMgr->new;
$cfg->define($mt->registry('config_settings'));

subtest 'invoke read_config_db multiple time' => sub {
    my $domain = 'example.com';
    my $url = 'http://localhost/?q=foo';

    note('Initial status');
    ok($cfg->read_config_db, 'Read all config values from database');
    is_deeply([$cfg->OutboundTrackbackDomains], [], 'Inial value is empty');
    ok($cfg->set('OutboundTrackbackDomains', $domain, 1), 'Set value for the with db_flag');
    is_deeply([$cfg->OutboundTrackbackDomains], [$domain], 'Get saved value');

    is_deeply([$cfg->AuthLoginURL], [], 'Inial value is empty');
    ok($cfg->set('AuthLoginURL', $url, 1), 'Set value for the with db_flag');
    is_deeply([$cfg->AuthLoginURL], [$url], 'Get saved value');

    ok($cfg->save_config, 'Save config to database');

    note('Re-read');
    ok($cfg->read_config_db, 'Read all config values from database');
    is_deeply([$cfg->OutboundTrackbackDomains], [$domain], 'Get saved value');
    is_deeply([$cfg->AuthLoginURL], [$url], 'Get saved value');
};

subtest 'DB/File priority' => sub {
    $cfg->define({Array => {type => 'ARRAY'}, Hash => {type => 'HASH'}});
    $cfg->set('Scalar', 'file');
    $cfg->set('Array', 'file_1');
    $cfg->set('Array', 'file_2');
    $cfg->set('Hash', 'b=');
    $cfg->set('Hash', 'c=file_c');
    $cfg->set('Hash', 'd=file_d');
    my $cfg_raw = $mt->model('config')->load(1);
    $cfg_raw->data(<<EOF);
Scalar db
Array db_1
Array db_2
Array db_3
Hash a=db_a
Hash b=db_b
Hash c=db_c
EOF
    $cfg_raw->save;
    $cfg->read_config_db;
    is($cfg->Scalar, 'file');
    my @array = $cfg->Array;
    is_deeply(\@array, ['file_1', 'file_2']);
    my $hash = $cfg->Hash;
    is ref($hash), 'HASH';
    is scalar(keys %$hash), '4';
    is($hash->{a}, 'db_a');
    is($hash->{b}, '');
    is($hash->{c}, 'file_c');
    is($hash->{d}, 'file_d');

    $cfg->Scalar('reset');
    is($cfg->Scalar, 'reset', 'right value');
    $cfg->Scalar('reset-db', 1);
    is($cfg->Scalar, 'reset', 'right value');

    $cfg->Array('reset');
    is_deeply([$cfg->Array], ['file_1', 'file_2', 'reset'], 'right value');
    $cfg->Array(['reset2']);
    is_deeply([$cfg->Array], ['reset2'], 'right value');
    $cfg->Array('reset3-db', 1);
    is_deeply([$cfg->Array], ['reset2'], 'right value');

    $cfg->Hash('e=reset');
    is($cfg->Hash->{e}, 'reset', 'right value');
    is($cfg->Hash->{a}, 'db_a', 'right value');
    $cfg->Hash({a => 'reset', f => 'reset'});
    is($cfg->Hash->{f}, 'reset', 'right value');
    is($cfg->Hash->{a}, 'reset', 'right value');
    $cfg->Hash({f => 'reset2'});
    is(!exists($cfg->Hash->{a}), '', 'no longer exsits');
    $cfg->Hash({a => 'reset2', f => 'reset3'}, 1);
    is($cfg->Hash->{f}, 'reset2', 'right value');
    is($cfg->Hash->{a}, 'reset2', 'right value');
};

done_testing();
