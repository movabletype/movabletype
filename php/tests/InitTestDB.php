<?php

$backend = strtolower(getenv('MT_TEST_BACKEND'));
$MT_CONFIG = ($backend === 'oracle') ? 'oracle-test.cfg' : (($backend === 'pg') ? 'postgresql-test.cfg' : 'mysql-test.cfg');

system("MT_CONFIG=$MT_CONFIG". ' perl -It/lib -Ilib -Iextlib -MMT::Test=:db -E "say \"Initialized test DB.\""');

set_include_path(realpath(__DIR__). '/../');
require_once('mt.php');
$mt = MT::get_instance(1, realpath("t/$MT_CONFIG"));
$mt->init_plugins();
