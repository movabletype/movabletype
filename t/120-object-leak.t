#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval qq{ use Test::LeakTrace; 1 }
        or plan skip_all => 'require Test::LeakTrace';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        # see the comment below
        DisableObjectCache => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT;
plan tests => 36;

$test_env->prepare_fixture('db_data');

my $mt = MT->new();

# Clear cache
my $request = MT::Request->instance;
$request->{__stash} = {};

# Bugid:107443, Memory Leak: Reblessed objects contain cyclic ref
# this test should run with:
# DisableObjectCache 1 (already included in mysql-test.cfg)
# otherwise the cache will hold the leaked object, and it won't be seen as leak

my $tests = [
	# normal loading
	[qw{ website website 2 }],
	[qw{ blog blog 1 }],
	[qw{ entry entry 1 }],
	[qw{ page page 20 }],
	[qw{ category category 1 }],
	[qw{ folder folder 20 }],
	# reblessed loading
	[qw{ blog website 2 }],
	[qw{ website blog 1 }],
	[qw{ page entry 1 }],
	[qw{ entry page 20 }],
	[qw{ folder category 1 }],
	[qw{ category folder 20 }],
];

foreach my $rec (@$tests) {
	my ($model, $expected, $id) = @$rec;
	no_leaks_ok {
		$mt->model($model)->load($id);
	}
	"$model should not leak";
	my $expected_class = $mt->model($expected);
	my $obj = $mt->model($model)->load($id);
	isnt($obj, undef, "Object $model loaded");
	is(ref($obj), $expected_class, "Object $model of type $expected_class");
}

