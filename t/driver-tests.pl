my(@foo, @bar);
my($tmp, @tmp);

## Test creating object with new
##     test column access through column, then through AUTOLOAD
$foo[0] = Foo->new;
ok($foo[0]);
$foo[0]->column('name', 'foo');
ok($foo[0]->column('name'), 'foo');
$foo[0]->name('foo');
ok($foo[0]->name, 'foo');
$foo[0]->status(2);
$foo[0]->text('bar');

## Test saving created object
ok( $foo[0]->save );
ok($foo[0]->id, 1);
ok($foo[0]->column('id'), $foo[0]->id);

## Test loading object using ID
$tmp = Foo->load($foo[0]->id);
ok($tmp);
ok($tmp->id, $foo[0]->id);
ok($tmp->name, $foo[0]->name);
ok($tmp->text, $foo[0]->text);
ok($tmp->status, $foo[0]->status);
ok($tmp->created_on, $foo[0]->created_on);
ok(length($tmp->created_on), 14);

## Test loading object using ID in a hash (new in MT 3.0)
$tmp = Foo->load({id => $foo[0]->id});
ok($tmp);
ok($tmp->id, $foo[0]->id);
ok($tmp->name, $foo[0]->name);
ok($tmp->text, $foo[0]->text);
ok($tmp->status, $foo[0]->status);
ok($tmp->created_on, $foo[0]->created_on);
ok(length($tmp->created_on), 14);

## Test loading object using ID in a hash, w/other params
$tmp = Foo->load({id => $foo[0]->id, name => $foo[0]->name});
ok($tmp);
ok($tmp->id, $foo[0]->id);
ok($tmp->name, $foo[0]->name);
ok($tmp->text, $foo[0]->text);
ok($tmp->status, $foo[0]->status);
ok($tmp->created_on, $foo[0]->created_on);
ok(length($tmp->created_on), 14);

## Test loading object using indexes
$tmp = Foo->load({ name => $foo[0]->name });
ok($tmp);
ok($tmp->id, $foo[0]->id);
$foo[1] = Foo->load({ created_on => $foo[0]->created_on });
ok($tmp);
ok($tmp->id, $foo[0]->id);
$tmp = Foo->load({ status => $foo[0]->status });
ok($tmp);
ok($tmp->id, $foo[0]->id);

##     Change column value, save, try to load using old value (fail?),
##     then load again using new value
$foo[0]->status(0);
ok( $foo[0]->save );
$tmp = Foo->load({ status => 2 });
ok(!$tmp);
$tmp = Foo->load({ status => 0 });
ok($tmp);
ok($tmp->id, $foo[0]->id);
ok($tmp->status, 0);

## Create a new object so we can do range and last/first lookups.
## Sleep first so that they get different created_on timestamps.
sleep(3);

## Create new object for iterator testing
$foo[1] = Foo->new;
$foo[1]->name('baz');
$foo[1]->text('quux');
$foo[1]->status(1);
$foo[1]->save;

## TEST LOADING IN VARIOUS WAYS

## Load all objects via iterator
my $iter = Foo->load_iter;
ok(defined $iter);
ok( $tmp = $iter->() );
ok($tmp->id, $foo[0]->id);
ok( $tmp = $iter->() );
ok($tmp->id, $foo[1]->id);
ok( !$iter->() );

## Load all objects with status == 1 via iterator
$iter = Foo->load_iter({ status => 1 });
ok(defined $iter);
ok( $tmp = $iter->() );
ok($tmp->id, $foo[1]->id);
ok( !$iter->() );

## Load using ID
$tmp = Foo->load($foo[1]->id);
ok($tmp);
ok($foo[1]->id, $tmp->id);
ok($foo[1]->name, $tmp->name);
ok($foo[1]->text, $tmp->text);

## Load using single-column index
$tmp = Foo->load({ name => $foo[1]->name, });
ok($tmp);
ok($foo[1]->id, $tmp->id);

## Load using non-existent ID (should fail)
$tmp = Foo->load(3);
ok(!$tmp);

## Load using descending sort (newest)
$tmp = Foo->load(undef, {
    sort => 'created_on',
    direction => 'descend',
    limit => 1 });
ok($tmp->id, 2);

## Load using ascending sort (oldest)
$tmp = Foo->load(undef, {
    sort => 'created_on',
    direction => 'ascend',
    limit => 1 });
ok($tmp->id, 1);

## Load using descending sort with limit = 2
@tmp = Foo->load(undef, {
    sort => 'created_on',
    direction => 'descend',
    limit => 2 });
ok(@tmp == 2);
ok($tmp[0]->id, 2);
ok($tmp[1]->id, 1);

## Load using descending sort by created_on, no limit
@tmp = Foo->load(undef, {
    sort => 'created_on',
    direction => 'descend' });
ok(@tmp == 2);
ok($tmp[0]->id, 2);
ok($tmp[1]->id, 1);

## Load using ascending sort by status, no limit
@tmp = Foo->load(undef, { sort => 'status', });
ok(@tmp == 2);
ok($tmp[0]->id, 1);
ok($tmp[1]->id, 2);

## Load using 'last' where status == 0
$tmp = Foo->load({ status => 0 }, {
    sort => 'created_on',
    direction => 'descend',
    limit => 1 });
ok($tmp->id, 1);

## Load using range search, one less than foo[1]->created_on and newer
$tmp = Foo->load(
    { created_on => [ $foo[1]->column('created_on')-1 ] },
    { range => { created_on => 1 } });
ok($tmp);
ok($tmp->id, 2);

## Load using EXCLUSIVE range search, up through the momment $foo[1] created
$tmp = Foo->load(
    { created_on => [ $foo[1]->column('created_on')-1, 
                      $foo[1]->column('created_on') ] },
    { range => { created_on => 1 } });
ok(!$tmp);

$tmp = Foo->load(
    { created_on => [ $foo[1]->column('created_on'), 
                      $foo[1]->column('created_on')+1 ] },
    { range => { created_on => 1 } });
ok(!$tmp);

## Load using INCLUSIVE range search, up through the momment $foo[1] created
$tmp = Foo->load(
    { created_on => [ $foo[1]->column('created_on')-1, 
                      $foo[1]->column('created_on') ] },
    { range_incl => { created_on => 1 } });
ok($tmp);
ok($tmp->id, 2);

$tmp = Foo->load(
    { created_on => [ $foo[1]->column('created_on'), 
                      $foo[1]->column('created_on')+1 ] },
    { range_incl => { created_on => 1 } });
ok($tmp);
ok($tmp->id, 2);

## Check that range searches return nothing when nothing is in the range.
$tmp = Foo->load( { created_on => [ undef, '19690101000000' ] },
		  { range => { created_on => 1 } });
ok(!$tmp);

## Range search, all items with created_on less than foo[1]->created_on
$tmp = Foo->load(
    { created_on => [ undef, $foo[1]->column('created_on')-1 ] },
    { range => { created_on => 1 } });
ok($tmp);
ok($tmp->id, 1);

## Range search, all items with created_on >= to foo[1]->created_on
$tmp = Foo->load(
    { created_on => [ $foo[1]->column('created_on')-1 ] },
    { range_incl => { created_on => 1 } });
ok($tmp);
ok($tmp->id, 2);

## Get count of objects
ok(Foo->count, 2);
ok(Foo->count({ status => 0 }), 1);
ok(Foo->count(
    { created_on => [ $foo[1]->column('created_on')-1 ] },
    { range => { created_on => 1 } }), 1);

## Update status for later tests.
$foo[0]->status(2);
$foo[0]->save;

## Test start_val loads.
## Given the first Foo object, should load the "next" one
## (the one with a larger created_on time)
$tmp = Foo->load(undef, {
    limit => 1,
    sort => 'created_on',
    direction => 'ascend',
    start_val => $foo[0]->created_on });
ok($tmp);
ok($tmp->id, $foo[1]->id);

## Given the first Foo object, try to load the "previous" one
## (the one with a smaller created_on time). This should fail.
$tmp = Foo->load(undef, {
    limit => 1,
    sort => 'created_on',
    direction => 'descend',
    start_val => $foo[0]->created_on });
ok(!$tmp);

## Given the second Foo object, try to load the "previous" one
## (the one with a smaller created_on time). This should work.
$tmp = Foo->load(undef, {
    limit => 1,
    sort => 'created_on',
    direction => 'descend',
    start_val => $foo[1]->created_on });
ok($tmp);
ok($tmp->id, $foo[0]->id);

## Given the second Foo object, try to load the "next" one
## (the one with a larger created_on time). This should work.
$tmp = Foo->load(undef, {
    limit => 1,
    sort => 'created_on',
    direction => 'ascend',
    start_val => $foo[1]->created_on });
ok(!$tmp);

## Now, given the second Foo object's created_on - 1, try to
## load the "previous" one. This should work.
$tmp = Foo->load(undef, {
    limit => 1,
    sort => 'created_on',
    direction => 'descend',
    start_val => $foo[1]->created_on-1 });
ok($tmp);
ok($tmp->id, $foo[0]->id);

## Now, given the second Foo object's created_on - 1, try to
## load the "next" one. This should work.
$tmp = Foo->load(undef, {
    limit => 1,
    sort => 'created_on',
    direction => 'ascend',
    start_val => $foo[1]->created_on-1 });
ok($tmp);
ok($tmp->id, $foo[1]->id);

## Override created_on timestamp, make sure it works
my $ts = substr($foo[1]->created_on, 0, -4) . '0000';
$foo[1]->created_on($ts);
$foo[1]->save;
@tmp = Foo->load(undef, {
    sort => 'created_on',
    direction => 'descend',
    limit => 2 });
ok(@tmp == 2);
ok($tmp[0]->id, 1);
ok($tmp[1]->id, 2);

## Test limit of 2 with direction descend, but without
## a sort option. This should sort by the most recently-added
## records, ie. sorted by ID, basically.
@tmp = Foo->load(undef, {
    direction => 'descend',
    limit => 2 });
ok(@tmp == 2);
ok($tmp[0]->id, $foo[1]->id);
ok($tmp[1]->id, $foo[0]->id);

## Test loading using offset.
## Should load the second Foo object.
$tmp = Foo->load(undef, {
    direction => 'descend',
    sort => 'created_on',
    limit => 1,
    offset => 1 });
ok($tmp);
ok($tmp->id, $foo[1]->id);

## We only have 2 Foo objects, so this should load
## only the second Foo object (because offset is 1).
@tmp = Foo->load(undef, {
    direction => 'descend',
    sort => 'created_on',
    limit => 2,
    offset => 1 });
ok(@tmp == 1);
ok($tmp[0]->id, $foo[1]->id);

## Should load the first Foo object (ascend with offset of 1).
$tmp = Foo->load(undef, {
    direction => 'ascend',
    sort => 'created_on',
    limit => 1,
    offset => 1 });
ok($tmp);
ok($tmp->id, 1);

## Now test join loads.
## First we need to create a couple of Bar objects.
$bar[0] = Bar->new;
$bar[0]->foo_id($foo[1]->id);
$bar[0]->name('bar0');
$bar[0]->status(0);
ok($bar[0]->save);
sleep(2);

$bar[1] = Bar->new;
$bar[1]->foo_id($foo[1]->id);
$bar[1]->name('bar1');
$bar[1]->status(1);
ok($bar[1]->save);
sleep(2);

$bar[2] = Bar->new;
$bar[2]->foo_id($foo[0]->id);
$bar[2]->name('bar2');
$bar[2]->status(0);
ok($bar[2]->save);
sleep(2);

## Get a count of all Foo objects in order of most recently
## created Bar object. No uniqueness requirement. This tests
## the on_load_complete temporary table stuff with count.

ok(Foo->count(undef,
    { join => [ 'Bar', 'foo_id',
                undef,
                { sort => 'created_on',
                  direction => 'descend', } ] }), 3);

## Now load all Foo objects in order of most recently
## created Bar object. Make sure they are unique.
@tmp = Foo->load(undef,
    { join => [ 'Bar', 'foo_id',
                undef,
                { sort => 'created_on',
                  direction => 'descend',
                  unique => 1 } ] });
ok(@tmp == 2);
ok($tmp[0]->id, $foo[0]->id);
ok($tmp[1]->id, $foo[1]->id);

## Load all Foo objects in order of most recently
## created Bar object. No uniqueness requirement.
@tmp = Foo->load(undef,
    { join => [ 'Bar', 'foo_id',
                undef,
                { sort => 'created_on',
                  direction => 'descend', } ] });
ok(@tmp == 3);
ok($tmp[0]->id, $foo[0]->id);
ok($tmp[1]->id, $foo[1]->id);
ok($tmp[2]->id, $foo[1]->id);

## Load last 1 Foo object in order of most recently
## created Bar object.
@tmp = Foo->load(undef,
    { join => [ 'Bar', 'foo_id',
                undef,
                { sort => 'created_on',
                  direction => 'descend',
                  unique => 1,
                  limit => 1, } ] });
ok(@tmp == 1);
ok($tmp[0]->id, $foo[0]->id);

## Load all Foo objects where Bar.name = 'bar0'
@tmp = Foo->load(undef,
    { join => [ 'Bar', 'foo_id',
                { name => 'bar0' },
                { sort => 'created_on',
                  direction => 'descend',
                  unique => 1, } ] });
ok(@tmp == 1);
ok($tmp[0]->id, $foo[1]->id);

## foo[1] is older than foo[0] because we overrode the timestamp,
## so this should load foo[0]
@tmp = Foo->load(undef,
    { sort => 'created_on', direction => 'descend', limit => 1,
    join => [ 'Bar', 'foo_id', { status => 0 }, { unique => 1 } ] });
ok(@tmp == 1);
ok($tmp[0]->id, $foo[0]->id);

## This is the same join as the last one, but without the limit--so
## we should get both Foo objects this time, in descending order.
@tmp = Foo->load(undef,
    { sort => 'created_on', direction => 'descend',
      join => [ 'Bar', 'foo_id', { status => 0 }, { unique => 1 } ] });
ok(@tmp == 2);
ok($tmp[0]->id, $foo[0]->id);
ok($tmp[1]->id, $foo[1]->id);

## Filter join results by providing a value for 'status'; only Foo[0]
## has a 'status' == 2, so only that record should be returned.
@tmp = Foo->load({ status => 2 },
    { sort => 'created_on', direction => 'descend',
      join => [ 'Bar', 'foo_id', { status => 0 }, { unique => 1 } ] });
ok(@tmp == 1);
ok($tmp[0]->id, $foo[0]->id);


## TEST EXISTS METHOD
ok($foo[0]->exists);
$tmp = Foo->new;
ok(!$tmp->exists);
$tmp->id(5);
ok(!$tmp->exists);

## Change foo[1]->status so that its value is unique (for index)
$foo[1]->status(5);
ok( $foo[1]->save );
ok( Foo->load({ status => 5 }) );

## Test remove
ok( $foo[1]->remove );
ok(! Foo->load(2) );
ok(! Foo->load({ status => 5 }) );
ok(! Foo->load({ name => $foo[1]->name }) );
ok(! Foo->load({ created_on => $foo[1]->created_on }) );

## Test methods:
##     * properties
my $props1 = Foo->properties;
ok($props1->{audit}, 1);
ok(scalar keys %{ $props1->{indexes} }, 3);
ok($props1->{primary_key}, 'id');
ok(scalar @{ $props1->{columns} }, 5);
my $props2 = $foo[0]->properties;
ok($props1, $props2);           ## Same address, because same hashref

##     * column_names
my $cols = $foo[0]->column_names;
ok(ref($cols), 'ARRAY');
my %cols = map { $_ => 1 } @$cols;
for (qw(id name status text data created_on created_by modified_on modified_by)) {
    ok($cols{$_});
}

##     * column_values
my $vals = $foo[0]->column_values;
ok(ref($vals), 'HASH');
ok($vals->{id}, $foo[0]->id);
ok($vals->{name}, $foo[0]->name);
ok($vals->{status}, $foo[0]->status);
ok($vals->{text}, $foo[0]->text);
ok($vals->{created_on}, $foo[0]->created_on);
ok($vals->{created_by}, $foo[0]->created_by);
ok($vals->{modified_on}, $foo[0]->modified_on);
ok($vals->{modified_by}, $foo[0]->modified_by);

##     * set_values
$vals = {
    id => 5,
    name => 'baz',
    status => 7,
    text => 'quux',
    created_on => 13209,
    created_by => 'bar',
    modified_on => 39023,
    modified_by => 'foo',
};
$foo[0]->set_values($vals);
for my $col (keys %$vals) {
    ok($vals->{$col}, $foo[0]->column($col));
}

##     * binary data

my $binmonster = new Foo;

$vals = {
    funky => "yes",
    monkey => "no",
};

require MT::Serialize;
$srlzr = new MT::Serialize("MT");
$binmonster->data($srlzr->serialize(\$vals));
$binmonster->id(81);
ok($binmonster->save())
    || print STDERR "Failed binary data test. " . $binmonster->errstr();
my $chk = Foo->load(81);
if ($chk) {
    my $chk_data = $chk->data;
    my $chk_vals = $srlzr->unserialize($chk_data);
    foreach (keys %$vals) {
        ok($$chk_vals->{$_}, $vals->{$_});
    }
} else {
    foreach (keys %$vals) {
        ok(0);
    }
}

##     * datasource
ok($foo[0]->datasource, $foo[0]->properties->{datasource});

##     * clone
my $clone = $foo[0]->clone;
for my $col (@$cols) {
    ok($clone->column($col), $foo[0]->column($col));
}

Foo->set_by_key({name => "this"});
$obj = Foo->load({name => "this"});
ok($obj);

Foo->set_by_key({name => "this"}, {status => 42});
$obj = Foo->load({name => "this"});
ok($obj && $obj->status, 42);

Foo->set_by_key({name => "this"}, {status => 47});
$obj = Foo->load({name => "this"});
ok($obj && $obj->status, 47);

Foo->set_by_key({name => "this", status => 47}, {text => "spiffy"});
$obj = Foo->load({name => "this", status => 47});
ok($obj && $obj->text, "spiffy");

Foo->set_by_key({name => "that"}, {text => "Once"});
$obj = Foo->load({name => "that"});
ok($obj && $obj->text, "Once");

## Load use direct set of values for non-PK column
@tmp = Foo->load({ name => [qw(foo this)] });
@tmp = sort {$a->name cmp $b->name} @tmp;
ok(scalar @tmp, 2);
skip(!$tmp[0], $tmp[0] && ($tmp[0]->name eq 'foo'));
skip(!$tmp[1], $tmp[1] && ($tmp[1]->name eq 'this'));

1;
