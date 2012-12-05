#!/usr/bin/perl

# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

use strict;
use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/lib"    : 'lib';
use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/extlib" : 'extlib';
use MT::PSGI;
my $app = MT::PSGI->new()->to_app();
