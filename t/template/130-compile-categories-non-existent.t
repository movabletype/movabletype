#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

# Tests for bugid:111894.
# https://movabletype.fogbugz.com/default.asp?111894

use MT::Test;
use MT::Test::Permission;
use MT;
use MT::Template::Context;

$test_env->prepare_fixture('db');

MT->new;

my $ctx = MT::Template::Context->new();

subtest 'bugid 111894' => sub {

    # There is no category.
    subtest 'case A' => sub {
        test('(test');
        test('&test');
    };

    MT::Test::Permission->make_category( blog_id => 1 )
        or die 'Cannot create a category.';

    # There is one category.
    subtest 'case B' => sub {
        test('(test');
    };

    subtest 'case C' => sub {
        test('test)');
        test('test!');
        test('||test');
    };

    subtest 'case D' => sub {
        test('#test');
        test('&test');
    };

};

subtest 'normal test' => sub {
    test('testA AND testB');
    test('(testA OR testB) AND testC');
    test('NOT test');

    test("'testA AND testB'");
    test('"testA AND testB"');
    test('testA (testb)');
    test('foo/bar');
};

done_testing;

sub test {
    ok( $ctx->compile_category_filter( $_[0] ), $_[0] );
}
