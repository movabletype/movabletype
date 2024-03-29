#!/usr/bin/perl

# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    my $module = 'DBD::mysql';
    eval "require $module;";
    plan skip_all => "Database driver '$module' not found."
        if $@;

    eval { require Test::Class }
        or plan skip_all => 'Test::Class is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;

    plan skip_all => 'for MySQL only' unless $test_env->driver eq 'mysql';
}

$test_env->fix_mysql_create_table_sql;

use MT::Test::DDL;

Test::Class->runtests;
