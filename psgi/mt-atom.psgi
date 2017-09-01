#!/usr/bin/perl

# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

use strict;
use FindBin;
use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/lib"    : "$FindBin::Bin/../lib";
use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/extlib" : "$FindBin::Bin/../extlib";
use MT::PSGI;
my $app = MT::PSGI->new(application => 'atom')->to_app();
