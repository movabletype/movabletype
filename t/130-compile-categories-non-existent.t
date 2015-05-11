#!/usr/bin/env perl
use strict;
use warnings;

# Tests for bugid:111894.
# https://movabletype.fogbugz.com/default.asp?111894

use Test::More;

use lib qw( lib extlib t/lib );
use MT::Test qw( :db );
use MT::Test::Permission;
use MT;
use MT::Template::Context;

MT->new;

my $ctx = MT::Template::Context->new();

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

done_testing;

sub test {
    ok( $ctx->compile_category_filter( $_[0] ), $_[0] );
}
