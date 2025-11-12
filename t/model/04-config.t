#!/usr/bin/perl
# $Id: 04-config.t 2562 2008-06-12 05:12:23Z bchoate $
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;

use Cwd;
use File::Spec;
use File::Temp qw( tempfile );

use MT;
use MT::ConfigMgr;

my $db_dir = $test_env->path('db');
my ($fh, $cfg_file) = tempfile(DIR => $test_env->root);
print $fh <<CFG;
Database $db_dir/mt.db
ObjectDriver DBI::SQLite 
SearchAltTemplate foo bar
SearchAltTemplate baz quux
AltTemplatePath alt-foo
AltTemplatePath alt-bar
EmptyString ''
CFG
close $fh;

my $mt        = MT->instance;
my $mt_config = $mt->config;
$mt_config->clear_dirty;
ok !$mt_config->is_dirty, "not dirty";

my $cfg = MT::ConfigMgr->new;
isa_ok($cfg, 'MT::ConfigMgr');
isnt $cfg => $mt_config, "new config is different from the config stored in the MT instance";
$cfg->define($mt->registry('config_settings'));
ok($cfg->read_config($cfg_file), "read '$cfg_file'");

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
is($cfg->TimeOffset, 0,    'TimeOffset=0');

## Test that multiple settings (SearchAltTemplate) work.
my @paths = $cfg->SearchAltTemplate;
is($cfg->type('SearchAltTemplate'), 'ARRAY',    'SearchAltTemplate=ARRAY');
is(@paths,                    2,          'paths=2');
is(($cfg->SearchAltTemplate)[0],    'foo bar',  'foo bar');
is(($cfg->SearchAltTemplate)[1],    'baz quux', 'baz quux');

## Test bug in early version of ConfigMgr where space was not
## stripped from the ends of values
is($cfg->ObjectDriver, 'DBI::SQLite', 'ObjectDriver=SQLite');

is(
    $cfg->AdminCGIPath, $cfg->CGIPath,
    'By default, AdminCGIPath is CGIPath'
);
$cfg->set('AdminCGIPath', '/cgi-bin/mt/');
isnt(
    $cfg->AdminCGIPath, $cfg->CGIPath,
    'after change, AdminCGIPath is not CGIPath'
);
is($cfg->AdminCGIPath, '/cgi-bin/mt/', 'AdminCGIPath is now set');

# Read / Write settings
ok(
    $cfg->is_readonly('ObjectDriver'),
    'The key specified by file is readonly by default'
);
ok(
    !$cfg->is_readonly('UserSessionCookiePath'),
    'The key specified by program or database is not readonly'
);
is_deeply(
    $cfg->overwritable_keys('ObjectDriver'),
    [lc 'ObjectDriver'],
    'Update overwritable_keys by list'
);
is_deeply(
    $cfg->overwritable_keys(['ObjectDriver']),
    [lc 'ObjectDriver'],
    'Update overwritable_keys by reference'
);
ok(
    !$cfg->is_readonly('ObjectDriver'),
    'Now, the "ObjectDriver" is writable'
);

$cfg->clear_dirty;

mkdir $db_dir;

local $MT::ConfigMgr::cfg;
## Test that config file gets read correctly when passed to
## constructor.
my $new_mt  = MT->construct(Config => $cfg_file, Directory => ".") or die MT->errstr;
my $new_cfg = $new_mt->{cfg};
isa_ok($new_mt,  'MT');
isa_ok($new_cfg, 'MT::ConfigMgr');
is($new_cfg->Database, $db_dir . '/mt.db', "DataSource=$db_dir");
isnt $new_cfg => $cfg,       "new config is different from the previous config";
isnt $new_cfg => $mt_config, "new config is also different from the config stored in the first MT instance";

foreach my $key (qw{ UserSessionCookiePath UserSessionCookieName ProcessMemoryCommand SecretToken }) {
    my $value = $new_cfg->get($key);
    ok(length($value), "Config $key is not empty");
    is_deeply(
        $new_cfg->get($key), $value,
        "Config $key returns the same value twice"
    );
    if ($key eq 'SecretToken') {
        like($value, qr/^[a-zA-Z0-9_-]{40}$/, 'Secret Token Generated');
    }
    $new_cfg->set($key, 'Avocado');
    is($new_cfg->get($key), 'Avocado', "Config $key is set-able");
}

## Test init_config path conversion
$new_mt->init_config;
my @altpaths = $new_cfg->AltTemplatePath;
is($new_cfg->type('AltTemplatePath'), 'ARRAY', 'AltTemplatePath=ARRAY');
is(@altpaths,                         2,       'paths=2');
ok(File::Spec->file_name_is_absolute($altpaths[0]), 'alt-foo becomes absolute');
ok(File::Spec->file_name_is_absolute($altpaths[1]), 'alt-bar becomes absolute');

## Test FTPSOptions default (MTC-26629)
is_deeply(
    $new_cfg->FTPSOptions,
    { ReuseSession => 1 },
    'FTPSOptions ReuseSession=>1'
);

## Test empty string conversion
is $new_cfg->get('EmptyString') => '', "got an empty string";

$new_cfg->set('AdminThemeId', '', 1);   # set AdminThemeId to an empty string

my $data = $new_cfg->stringify_config;
like $data => qr/AdminThemeId ''/, "empty string is correctly stringified";

$new_cfg->clear_dirty;

unlink $cfg_file or die "Can't unlink '$cfg_file': $!";

done_testing;
