#!/usr/bin/perl
# $Id: 04-config.t 2562 2008-06-12 05:12:23Z bchoate $
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}


use lib 'lib';
use lib 'extlib';
use lib 't/lib';

use MT::Test;

use Cwd;
use File::Spec;
use File::Temp qw( tempfile );
use Test::More tests => 37;

use MT;
use MT::ConfigMgr;

use vars qw( $BASE );
require './t/test-common.pl';

my ( $cfg_file, $cfg, $mt );

my $db_dir = cwd() . '/t/db/';
( my ($fh), $cfg_file ) = tempfile();
print $fh <<CFG;
Database $db_dir/mt.db
ObjectDriver DBI::SQLite 
AltTemplate foo bar
AltTemplate baz quux
CFG
close $fh;

$cfg = MT->config;
isa_ok( $cfg, 'MT::ConfigMgr' );
ok( $cfg->read_config($cfg_file), "read '$cfg_file'" );

## Test standard get/set
is( $cfg->get('Database'), $db_dir . '/mt.db', "get(DataSource)=$db_dir" );
$cfg->set( 'DataSource', './db2' );
is( $cfg->get('DataSource'), './db2', 'get(DataSource)=./db2' );

## Test autoloaded methods
is( $cfg->DataSource, './db2', 'autoloaded DataSource=./db2' );
$cfg->DataSource('./db');
is( $cfg->DataSource, './db', 'autoloaded DataSource=./db2' );

## Test defaults
is( $cfg->Serializer, 'MT', 'Serializer=MT' );
is( $cfg->TimeOffset, 0,    'TimeOffset=0' );

## Test that multiple settings (AltTemplate) work.
my @paths = $cfg->AltTemplate;
is( $cfg->type('AltTemplate'), 'ARRAY', 'AltTemplate=ARRAY' );
is( @paths,                    2,       'paths=2' );
is( ( $cfg->AltTemplate )[0], 'foo bar',  'foo bar' );
is( ( $cfg->AltTemplate )[1], 'baz quux', 'baz quux' );

## Test bug in early version of ConfigMgr where space was not
## stripped from the ends of values
is( $cfg->ObjectDriver, 'DBI::SQLite', 'ObjectDriver=SQLite' );

is( $cfg->AdminCGIPath, $cfg->CGIPath,
    'By default, AdminCGIPath is CGIPath' );
$cfg->set( 'AdminCGIPath', '/cgi-bin/mt/' );
isnt( $cfg->AdminCGIPath, $cfg->CGIPath,
    'after change, AdminCGIPath is not CGIPath' );
is( $cfg->AdminCGIPath, '/cgi-bin/mt/', 'AdminCGIPath is now set' );

# Read / Write settings
ok( $cfg->is_readonly('ObjectDriver'),
    'The key specified by file is readonly by default' );
ok( !$cfg->is_readonly('UserSessionCookiePath'),
    'The key specified by program or database is not readonly' );
is_deeply(
    $cfg->overwritable_keys('ObjectDriver'),
    [ lc 'ObjectDriver' ],
    'Update overwritable_keys by list'
);
is_deeply(
    $cfg->overwritable_keys( ['ObjectDriver'] ),
    [ lc 'ObjectDriver' ],
    'Update overwritable_keys by reference'
);
ok( !$cfg->is_readonly('ObjectDriver'),
    'Now, the "ObjectDriver" is writable'
);

mkdir $db_dir;

undef $MT::ConfigMgr::cfg;
## Test that config file gets read correctly when passed to
## constructor.
$mt = MT->new( Config => $cfg_file, Directory => "." ) or die MT->errstr;
if ( !$mt ) { print "# MT constructor returned error: ", MT->errstr(); }
isa_ok( $mt,        'MT' );
isa_ok( $mt->{cfg}, 'MT::ConfigMgr' );
is( $mt->{cfg}->Database, $db_dir . '/mt.db', "DataSource=$db_dir" );

foreach my $key (
    qw{ UserSessionCookiePath UserSessionCookieName ProcessMemoryCommand SecretToken }
    )
{
    my $value = $cfg->get($key);
    ok( length($value), "Config $key is not empty" );
    is_deeply( $cfg->get($key), $value,
        "Config $key returns the same value twice" );
    if ( $key eq 'SecretToken' ) {
        like( $value, qr/^[a-zA-Z0-9]{40}$/, 'Secret Token Generated' );
    }
    $cfg->set( $key, 'Avocado' );
    is( $cfg->get($key), 'Avocado', "Config $key is set-able" );
}

unlink $cfg_file or die "Can't unlink '$cfg_file': $!";
