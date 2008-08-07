#!/usr/bin/perl
# $Id$
use strict;
use warnings;
use Test::More tests => 1;
use vars qw( $DB_DIR $T_CFG );
use lib 't';
require 'test-common.pl';
system "rm -rf $DB_DIR";
#unlink $T_CFG;
ok(1, 'cleanup');
