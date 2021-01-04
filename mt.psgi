#!/usr/bin/env perl

# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

use strict;
use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/lib"    : 'lib';
use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/extlib" : 'extlib';
use MT::PSGI;
my $app = MT::PSGI->new()->to_app();
