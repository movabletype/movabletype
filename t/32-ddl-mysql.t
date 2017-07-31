#!/usr/bin/perl

# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

use strict;
use warnings;
use lib 't/lib';
use Test::More;

BEGIN {
    $ENV{MT_CONFIG} = "mysql-test.cfg";
    plan skip_all => "Configuration file $ENV{MT_CONFIG} not found"
        if !-r "t/$ENV{MT_CONFIG}";

    my $module = 'DBD::mysql';
    eval "require $module;";
    plan skip_all => "Database driver '$module' not found."
        if $@;
}

use MT::Test::DDL;

Test::Class->runtests;
