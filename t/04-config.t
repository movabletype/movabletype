# $Id$

use Test;
use MT;
use MT::ConfigMgr;
use File::Temp qw( tempfile );
use strict;
use Cwd;

BEGIN { plan tests => 16 };

use vars qw( $BASE );
unshift @INC, 't/';
require 'test-common.pl';
use File::Spec;

my($cfg_file, $cfg, $mt);

my $db_dir = cwd() . '/t/db/';
(my($fh), $cfg_file) = tempfile();
print $fh <<CFG;
DataSource $db_dir
ObjectDriver DBM 
AltTemplate foo bar
AltTemplate baz quux
CFG
close $fh;

$cfg = MT::ConfigMgr->instance;
ok($cfg);
ok( $cfg->read_config($cfg_file) );

## Test standard get/set
ok($cfg->get('DataSource'), $db_dir);
$cfg->set('DataSource', './db2');
ok($cfg->get('DataSource'), './db2');

## Test autoloaded methods
ok($cfg->DataSource, './db2');
$cfg->DataSource('./db');
ok($cfg->DataSource, './db');

## Test defaults
ok($cfg->Serializer, 'MT');
ok($cfg->TimeOffset, 0);

## Test that multiple settings (AltTemplate) work.
my @paths = $cfg->AltTemplate;
ok($cfg->type('AltTemplate'), 'ARRAY');
ok(@paths, 2);
ok(($cfg->AltTemplate)[0], 'foo bar');
ok(($cfg->AltTemplate)[1], 'baz quux');

## Test bug in early version of ConfigMgr where space was not
## stripped from the ends of values
ok($cfg->ObjectDriver, 'DBM');

mkdir $db_dir;

undef $MT::ConfigMgr::cfg;
## Test that config file gets read correctly when passed to
## constructor.
$mt = MT->new( Config => $cfg_file, Directory => "." ) or die MT->errstr;
if (!$mt) { print "# MT constructor returned error: ", MT->errstr(); }
ok($mt);
ok($mt->{cfg});
ok($mt->{cfg}->DataSource, $db_dir);

unlink $cfg_file or die "Can't unlink '$cfg_file': $!";
