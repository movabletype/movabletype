#!/usr/bin/perl

use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use MT::Test qw(:db :data);
use MT;
use constant HAS_LEAKTRACE => eval { require Test::LeakTrace };
use Test::More HAS_LEAKTRACE
    ? ( tests => 18 )
    : ( skip_all => 'require Test::LeakTrace' );
use Test::LeakTrace;

my $mt = MT->new();

# Clear cache
my $request = MT::Request->instance;
$request->{__stash} = {};

# Bugid:107443, Memory Leak: Reblessed objects contain cyclic ref
# this test should run with:
# DisableObjectCache 1 (already included in mysql-test.cfg)
# otherwise the cache will hold the leaked object, and it won't be seen as leak

my $tests = [
	['website', 2],
	['blog', 1],
	['entry', 1],
	['page', 20],
	['category', 1],
	['folder', 20],
];

foreach my $rec (@$tests) {
	my ($model, $id) = @$rec;
	no_leaks_ok {
		$mt->model($model)->load($id);
	}
	"$model should not leak";
	my $class = $mt->model($model);
	my $obj = $class->load($id);
	isnt($obj, undef, "Object $model loaded");
	is(ref($obj), $class, "Object $model of type $class");
}

