#!/usr/bin/env perl
use strict;
use warnings;

# Tests for bugid:113085.
# https://movabletype.fogbugz.com/default.asp?113085

use Test::More;

use lib qw( lib extlib t/lib );
use MT::Test qw( :db );
use MT::Test::Permission;
use MT;
use MT::Template::Context;

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
    ok( $ctx->compile_tag_filter( $_[0], [] ), $_[0] );
}
