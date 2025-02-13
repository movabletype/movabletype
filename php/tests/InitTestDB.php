<?php

$cfgs = [
    'mysql' => 'mysql-test.cfg',
    'oracle' => 'oracle-test.cfg',
    'pg' => 'postgresql-test.cfg',
];
$MT_CONFIG = $cfgs[strtolower(getenv('MT_TEST_BACKEND') ?? 'mysql')];
$MT_CONFIG ??= $cfgs['mysql'];

system("MT_CONFIG=$MT_CONFIG". ' perl -It/lib -Ilib -Iextlib -MMT::Test=:db -E "say \"Initialized test DB.\""');

set_include_path(realpath(__DIR__). '/../');
require_once('mt.php');
$mt = MT::get_instance(1, realpath("t/$MT_CONFIG"));
$mt->init_plugins();
