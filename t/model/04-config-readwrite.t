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

$test_env->prepare_fixture('db');

my $mt  = MT->instance;
my $cfg = $mt->config;

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
    $cfg->define({Array => {type => 'ARRAY'}, ArrayB => {type => 'ARRAY'}, Hash => {type => 'HASH'}});
    $cfg->set('Scalar', 'file');
    $cfg->set('ScalarB', 'file');
    $cfg->set('Array', 'file_1');
    $cfg->set('Array', 'file_2');
    $cfg->set('Array2', 'file_1');
    $cfg->set('Array2', 'file_2');
    $cfg->set('Hash', 'b=');
    $cfg->set('Hash', 'c=file_c');
    $cfg->set('Hash', 'd=file_d');
    my $cfg_raw = $mt->model('config')->load(1);
    $cfg_raw->data(<<EOF);
Scalar db
ScalarB
Array db_1
Array db_2
Array db_3
ArrayB
Hash a=db_a
Hash b=db_b
Hash c=db_c
EOF
    $cfg_raw->save;
    $cfg->read_config_db;
    is($cfg->Scalar, 'file');
    is($cfg->ScalarB, 'file'); # TODO suspicious spec
    my @array = $cfg->Array;
    is_deeply(\@array, ['file_1', 'file_2']);
    my @array_b = $cfg->ArrayB;
    is_deeply(\@array_b, []);
    my $hash = $cfg->Hash;
    is ref($hash), 'HASH';
    is scalar(keys %$hash), '4';
    is($hash->{a}, 'db_a');
    is($hash->{b}, '');
    is($hash->{c}, 'file_c');
    is($hash->{d}, 'file_d');
};

done_testing();
