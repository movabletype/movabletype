<?php

system('MT_CONFIG=mysql-test.cfg perl -It/lib -Ilib -Iextlib -MMT::Test=:db -E "say \"Initialized test DB.\""');

set_include_path(realpath(__DIR__). '/../');
require_once('mt.php');
MT::get_instance(1, realpath( "t/mysql-test.cfg" ));
