#!/usr/bin/perl

# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: test-common.pl 3531 2009-03-12 09:11:52Z fumiakiy $

use strict;
use warnings;

use Cwd;
use File::Spec;

use vars qw(
    $BASE $DB_DIR $T_CFG
    $T_SCHEMA $T_SCHEMA_PG $T_SCHEMA_ORACLE
    $T_SCHEMA_SQLITE $T_SCHEMA_MSSQLSERVER $SQLITE_DB
);

my $pwd = cwd();
my @pieces = split /\//, $pwd;

if (-f 'test-common.pl') {
    pop @pieces;
}
elsif (-f 't/test-common.pl') {
    # XXX ?
}

$BASE = File::Spec->catdir(@pieces);
$DB_DIR = File::Spec->catdir($BASE, 't', 'db');
mkdir $DB_DIR unless -d $DB_DIR;
$T_CFG = File::Spec->catdir($BASE, 't', 'mt.cfg');
$T_SCHEMA = File::Spec->catfile($BASE, 't', 't-schema.dump');
$T_SCHEMA_PG = File::Spec->catfile($BASE, 't', 't-schema-postgres.dump');
$T_SCHEMA_ORACLE = File::Spec->catfile($BASE, 't', 't-schema-oracle.dump');
$T_SCHEMA_SQLITE = File::Spec->catfile($BASE, 't', 't-schema-sqlite.dump');
$T_SCHEMA_MSSQLSERVER = File::Spec->catfile($BASE, 't', 't-schema-mssqlserver.dump');
$SQLITE_DB = File::Spec->catfile($BASE, 't', 'mtdb');
$ENV{MT_CONFIG} = $T_CFG;

1;
