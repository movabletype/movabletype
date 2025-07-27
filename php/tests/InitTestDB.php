<?php

$cfgs = [
    'mysql' => 'mysql-test.cfg',
    'oracle' => 'oracle-test.cfg',
    'pg' => 'postgresql-test.cfg',
];
$driver = getenv('MT_TEST_BACKEND');
$driver = $driver && $cfgs[$driver] ? $driver : 'mysql';
$MT_CONFIG = $cfgs[$driver];

system("MT_CONFIG=$MT_CONFIG". ' perl -It/lib -Ilib -Iextlib -MMT::Test=:db -E "say \"Initialized test DB.\""');

set_include_path(realpath(__DIR__). '/../');
require_once('mt.php');
$mt = MT::get_instance(1, realpath("t/$MT_CONFIG"));
$mt->init_plugins();

error_reporting(E_ALL & ~E_NOTICE & ~E_WARNING); // set common initial setting just in case

if (version_compare(phpversion(), '8.1', '>=') && version_compare(phpversion(), '8.4', '<')) {
    error_reporting(error_reporting()  & ~E_CORE_WARNING & ~E_COMPILE_WARNING); // from 8.1 to 8.3 need extra levels to except
}

if (getenv('MT_TEST_REPORT_PHPUNIT_WARNINGS')) {
    error_reporting(error_reporting() | E_WARNING | E_CORE_WARNING | E_COMPILE_WARNING);
}
