# $Id$

BEGIN { unshift @INC, 't/' }

use MT;
use Test;
use MT::ObjectDriver;
use MT::ConfigMgr;
use DB_File;
use strict;

## Our two object classes.
use Foo;
use Bar;

BEGIN { plan tests => 106 };

use vars qw( $DB_DIR );
require 'test-common.pl';

if (-d $DB_DIR) {
    system "rm -rf $DB_DIR";
}
mkdir $DB_DIR or die "Can't create dir '$DB_DIR': $!";

my $mgr = MT::ConfigMgr->instance;
$mgr->DataSource($DB_DIR);

my $driver = MT::ObjectDriver->new('DBM');
ok($driver); #1

my(@foo, @bar);
my(@tmp, $tmp);

## Create an object.
$foo[0] = Foo->new;
ok($foo[0]); #2
$foo[0]->column('name', 'foo');
ok($foo[0]->column('name'), 'foo'); #3
$foo[0]->column('text', 'bar');
ok($foo[0]->column('text'), 'bar'); #4
$foo[0]->column('status', 0);
ok($foo[0]->column('status'), 0); #5
$driver->save($foo[0]);

## Check that indexes are updated
for my $col (qw( name status created_on )) {
    my $idx = _tie_index($col); #6 #9 #12
    my $col_value = $foo[0]->column($col);
    ok(my $idx_val = $idx->{ $col_value }); #7 #10 #13
    my %ids = map { $_ => 1 } split /$;/, $idx_val;
    ok(exists $ids{ $foo[0]->column('id') }); #8 #11 #14
}

## Load using ID
$tmp = $driver->load('Foo', $foo[0]->column('id'));
ok($tmp); #15
ok($foo[0]->column('id'), $tmp->column('id')); #16
ok($foo[0]->column('name'), $tmp->column('name')); #17
ok($foo[0]->column('text'), $tmp->column('text')); #18
## Load using single-column index
$tmp = $driver->load('Foo', { name => $foo[0]->column('name'), });
ok($tmp); #19
ok($foo[0]->column('id'), $tmp->column('id')); #20

## Load using multiple-column index
$tmp = $driver->load('Foo',
    { created_on => $foo[0]->column('created_on'),
      name => $foo[0]->column('name'), });
ok($tmp); #21
ok($foo[0]->column('id'), $tmp->column('id')); #22

## Create a new object so we can do range and limit lookups.
## Sleep first so that they get different created_on timestamps.
sleep(2);

$foo[1] = Foo->new;
ok($foo[1]); #23
$foo[1]->column('name', 'baz');
ok($foo[1]->column('name'), 'baz'); #24
$foo[1]->column('text', 'quux');
ok($foo[1]->column('text'), 'quux'); #25
$foo[1]->column('status', 1);
ok($foo[1]->column('status'), 1); #26
$driver->save($foo[1]);

## Check that indexes are updated
for my $col (qw( name status created_on )) {
    my $idx = _tie_index($col); #27 #30 #33
    my $col_value = $foo[1]->column($col);
    ok(my $idx_val = $idx->{ $col_value }); #28 #31 #34
    my %ids = map { $_ => 1 } split /$;/, $idx_val;
    ok(exists $ids{ $foo[1]->column('id') }); #29 #32 #35
}

## Load using ID
$tmp = $driver->load('Foo', $foo[1]->column('id'));
ok($tmp); #36
ok($foo[1]->column('id'), $tmp->column('id')); #37
ok($foo[1]->column('name'), $tmp->column('name')); #38
ok($foo[1]->column('text'), $tmp->column('text')); #39

## Load using single-column index
$tmp = $driver->load('Foo', { name => $foo[1]->column('name'), });
ok($tmp); #40
ok($foo[1]->column('id'), $tmp->column('id')); #41

## Load using non-existent ID (should fail)
$tmp = $driver->load('Foo', 3);
ok(!$tmp); #42

## Load using descending sort (newest)
$tmp = $driver->load('Foo', undef, {
    sort => 'created_on',
    direction => 'descend',
    limit => 1 });
ok($tmp->column('id'), 2); #43

## Load using ascending sort (oldest)
$tmp = $driver->load('Foo', undef, {
    sort => 'created_on',
    direction => 'ascend',
    limit => 1 });
ok($tmp->column('id'), 1); #44

## Load using descending sort with limit = 2
@tmp = $driver->load('Foo', undef, {
    sort => 'created_on',
    direction => 'descend',
    limit => 2 });
ok(@tmp == 2); #45
ok($tmp[0]->column('id'), 2); #46
ok($tmp[1]->column('id'), 1); #47

## Load using descending sort by created_on, no limit
@tmp = $driver->load('Foo', undef, {
    sort => 'created_on',
    direction => 'descend' });
ok(@tmp == 2); #48
ok($tmp[0]->column('id'), 2); #49
ok($tmp[1]->column('id'), 1); #50

## Load using ascending sort by status, no limit
@tmp = $driver->load('Foo', undef, { sort => 'status', });
ok(@tmp == 2); #51
ok($tmp[0]->column('id'), 1); #52
ok($tmp[1]->column('id'), 2); #53

## Load using 'last' where name = 'foo'
$tmp = $driver->load('Foo', { status => 0 }, {
    sort => 'created_on',
    direction => 'descend',
    limit => 1 });
ok($tmp->column('id'), 1); #54

## Load using range search, one less than foo[1]->created_on and newer
$tmp = $driver->load('Foo',
    { created_on => [ $foo[1]->column('created_on')-1 ] },
    { range => { created_on => 1 } });
ok($tmp); #55
ok($tmp->column('id'), 2); #56

## Range search, all items with created_on less than foo[1]->created_on
$tmp = $driver->load('Foo',
    { created_on => [ 0, $foo[1]->column('created_on')-1 ] },
    { range => { created_on => 1 } });
ok($tmp); #57
ok($tmp->column('id'), 1); #58

## Get count of objects
ok($driver->count('Foo'), 2); #59
ok($driver->count('Foo', { status => 1 }), 1); #60
ok($driver->count('Foo',
    { created_on => [ $foo[1]->column('created_on')-1 ] },
    { range => { created_on => 1 } }), 1); #61

## Change indexed column value, save
my $old_status = $foo[0]->column('status');
$foo[0]->column('status', 1);
$driver->save($foo[0]); #56

## Check that indexes are updated
{
    my $idx = _tie_index('status'); #62
    ok(!exists $idx->{$old_status}); #63
    ok(my $idx_val = $idx->{ $foo[0]->column('status') }); #64
    my %ids = map { $_ => 1 } split /$;/, $idx_val;
    ok(exists $ids{ $foo[0]->column('id') }); #65
}

## Change indexed column value, save
$old_status = $foo[0]->column('status');
$foo[0]->column('status', 2);
$driver->save($foo[0]);

## Check that indexes are updated
{
    my $idx = _tie_index('status'); #66
    ok(my $idx_val = $idx->{$old_status}); #67
    my %ids = map { $_ => 1 } split /$;/, $idx_val;
    ok(!exists $ids{ $foo[0]->column('id') }); #68
    ok($idx_val = $idx->{ $foo[0]->column('status') }); #69
    %ids = map { $_ => 1 } split /$;/, $idx_val;
    ok(exists $ids{ $foo[0]->column('id') }); #70
}

## Override created_on timestamp, make sure it works
my $ts = substr($foo[1]->created_on, 0, -4) . '0000';
$foo[1]->created_on($ts);
$driver->save($foo[1]);
@tmp = $driver->load('Foo', undef, {
    sort => 'created_on',
    direction => 'descend',
    limit => 2 });
ok(@tmp == 2); #71
ok($tmp[0]->column('id'), 1); #72
ok($tmp[1]->column('id'), 2); #73

## Test limit of 2 with direction descend, but without
## a sort option. This should sort by the most recently-added
## records, ie. sorted by ID, basically.
@tmp = $driver->load('Foo', undef, {
    direction => 'descend',
    limit => 2 });
ok(@tmp == 2); #74
ok($tmp[0]->column('id'), 2); #75
ok($tmp[1]->column('id'), 1); #76

## Test loading using offset.
## Should load the second Foo object.
$tmp = $driver->load('Foo', undef, {
    direction => 'descend',
    sort => 'created_on',
    limit => 1,
    offset => 1 });
ok($tmp); #77
ok($tmp->column('id'), 2); #78

## We only have 2 Foo objects, so this should load
## only the second Foo object (because offset is 1).
@tmp = $driver->load('Foo', undef, {
    direction => 'descend',
    sort => 'created_on',
    limit => 2,
    offset => 1 });
ok(@tmp == 1); #79
ok($tmp[0]->column('id'), 2); #80

## Should load the first Foo object (ascend).
$tmp = $driver->load('Foo', undef, {
    direction => 'ascend',
    sort => 'created_on',
    limit => 1,
    offset => 1 });
ok($tmp); #81
ok($tmp->column('id'), 1); #82

## Now test join loads.
## First we need to create a couple of Bar objects.
$bar[0] = Bar->new;
$bar[0]->column('foo_id', $foo[1]->id);
$bar[0]->column('name', 'bar0');
ok($driver->save($bar[0])); #83
sleep(2);

$bar[1] = Bar->new;
$bar[1]->column('foo_id', $foo[1]->id);
$bar[1]->column('name', 'bar1');
ok($driver->save($bar[1])); #84
sleep(2);

$bar[2] = Bar->new;
$bar[2]->column('foo_id', $foo[0]->id);
$bar[2]->column('name', 'bar2');
ok($driver->save($bar[2])); #85
sleep(2);

## Now load all Foo objects in order of most recently
## created Bar object. Make sure they are unique.
@tmp = $driver->load('Foo', undef,
    { join => [ 'Bar', 'foo_id',
                undef,
                { sort => 'created_on',
                  direction => 'descend',
                  unique => 1 } ] });
ok(@tmp == 2); #86
ok($tmp[0]->column('id'), $foo[0]->column('id')); #87
ok($tmp[1]->column('id'), $foo[1]->column('id')); #88

## Load all Foo objects in order of most recently
## created Bar object. No uniqueness requirement.
@tmp = $driver->load('Foo', undef,
    { join => [ 'Bar', 'foo_id',
                undef,
                { sort => 'created_on',
                  direction => 'descend', } ] });
ok(@tmp == 3); #89
ok($tmp[0]->column('id'), $foo[0]->column('id')); #90
ok($tmp[1]->column('id'), $foo[1]->column('id')); #91
ok($tmp[2]->column('id'), $foo[1]->column('id')); #92

## Load last 1 Foo object in order of most recently
## created Bar object.
@tmp = $driver->load('Foo', undef,
    { join => [ 'Bar', 'foo_id',
                undef,
                { sort => 'created_on',
                  direction => 'descend',
                  unique => 1,
                  limit => 1, } ] });
ok(@tmp == 1); #93
ok($tmp[0]->column('id'), $foo[0]->column('id')); #94

## Load all Foo objects where Bar.name = 'bar0'
@tmp = $driver->load('Foo', undef,
    { join => [ 'Bar', 'foo_id',
                { name => 'bar0' },
                { sort => 'created_on',
                  direction => 'descend',
                  unique => 1, } ] });
ok(@tmp == 1); #95
ok($tmp[0]->column('id'), $foo[1]->column('id')); #96


## Now remove a record.
ok( $driver->remove($foo[0]) ); #97

{
    my $db_file = MT::ObjectDriver::DBM::_db_data($driver, $foo[0]);
    ok(-e $db_file); #98
    tie my %db, 'DB_File', $db_file, O_RDWR, 0666, $DB_BTREE
        or die "Tie '$db_file' failed: $!";
    ok(!exists $db{ $foo[0]->column('id') }); #99
}

## Check that indexes are updated
for my $col (qw( name status created_on )) {
    my $idx = _tie_index($col); #100 #102 #104
    ok(!exists $idx->{ $foo[0]->column($col) }); #101 #103 #105
}

## Test generate_id
my $id_file = File::Spec->catfile($driver->cfg->DataSource, "ids.db");
tie my %db, 'DB_File', $id_file
    or die "Can't tie '$id_file': $!";
my $last_id = $db{'Foo'};
untie %db;
my $id = $driver->generate_id('Foo');
ok($id, $last_id+1); #106


system "rm -rf $DB_DIR";


sub _tie_index {
    my($col) = @_;
    my $idx_file = File::Spec->catfile( $driver->cfg->DataSource,
        Foo->datasource . '.' . $col . '.idx');
    ok(-e $idx_file);
    tie my %idx, 'DB_File', $idx_file, O_RDWR, 0666, $DB_BTREE
        or die "Tie to '$idx_file' failed: $!";
    \%idx;
}
