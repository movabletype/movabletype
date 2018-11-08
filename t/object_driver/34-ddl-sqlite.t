#!/usr/bin/perl

# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
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
    plan skip_all => "Test for 'sqlite' is not actively maintained";

    my $module = 'DBD::SQLite';
    eval "require $module;";
    plan skip_all => "Database driver '$module' not found."
        if $@;
}

our $test_env;
BEGIN {
    local $ENV{MT_TEST_BACKEND} = 'sqlite';
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::DDL;

Test::Class->runtests;
