#!/usr/bin/perl
# $Id$
use strict;
use warnings;

use Cwd;
use File::Spec;
use File::Temp qw( tempfile );
use Test::More tests => 16;

use MT;
use MT::ConfigMgr;

use vars qw( $BASE );
use lib 't';
require 'test-common.pl';

my($cfg_file, $cfg, $mt);

my $db_dir = cwd() . '/t/db/';
(my($fh), $cfg_file) = tempfile();
print $fh <<CFG;
Database $db_dir/mt.db
ObjectDriver DBI::SQLite 
AltTemplate foo bar
AltTemplate baz quux
CFG
close $fh;

$cfg = MT->config;
isa_ok($cfg, 'MT::ConfigMgr');
ok( $cfg->read_config($cfg_file), "read '$cfg_file'" );

## Test standard get/set
is($cfg->get('Database'), $db_dir . '/mt.db', "get(DataSource)=$db_dir");
$cfg->set('DataSource', './db2');
is($cfg->get('DataSource'), './db2', 'get(DataSource)=./db2');

## Test autoloaded methods
is($cfg->DataSource, './db2', 'autoloaded DataSource=./db2');
$cfg->DataSource('./db');
is($cfg->DataSource, './db', 'autoloaded DataSource=./db2');

## Test defaults
is($cfg->Serializer, 'MT', 'Serializer=MT');
is($cfg->TimeOffset, 0, 'TimeOffset=0');

## Test that multiple settings (AltTemplate) work.
my @paths = $cfg->AltTemplate;
is($cfg->type('AltTemplate'), 'ARRAY', 'AltTemplate=ARRAY');
is(@paths, 2, 'paths=2');
is(($cfg->AltTemplate)[0], 'foo bar', 'foo bar');
is(($cfg->AltTemplate)[1], 'baz quux', 'baz quux');

## Test bug in early version of ConfigMgr where space was not
## stripped from the ends of values
is($cfg->ObjectDriver, 'DBI::SQLite', 'ObjectDriver=SQLite');

mkdir $db_dir;

undef $MT::ConfigMgr::cfg;
## Test that config file gets read correctly when passed to
## constructor.
$mt = MT->new( Config => $cfg_file, Directory => "." ) or die MT->errstr;
if (!$mt) { print "# MT constructor returned error: ", MT->errstr(); }
isa_ok($mt, 'MT');
isa_ok($mt->{cfg}, 'MT::ConfigMgr');
is($mt->{cfg}->Database, $db_dir . '/mt.db', "DataSource=$db_dir");

unlink $cfg_file or die "Can't unlink '$cfg_file': $!";
