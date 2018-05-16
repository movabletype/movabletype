#!/usr/bin/perl
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

use MT::Test;
use MT;
use MT::Template::Context;

$test_env->prepare_fixture('db_data');

my $mt = MT->new();
isnt( $mt, undef, "MT loaded" );
my $cclass = $mt->model('category');

# Disable cache driver for clearing $category->children_categories' cache.
$cclass->driver->Disabled(1) if $cclass->driver->can('Disabled');

my %cats_hash = map { ( $_->id, $_ ) } $cclass->load( { blog_id => 1 } );
add_category( 26, 'aaa',       0,  1 );
add_category( 27, 'subsubfoo', 3,  1 );
add_category( 28, 'bbb',       0,  1 );
add_category( 29, 'aaa',       28, 1 );
add_category( 30, 'foo',       29, 1 );
add_category( 31, 'buz buz',   0,  1 );
add_category( 32, 'a(b)',      0,  1 );
add_category( 33, 'a/b',       0,  1 );
add_category( 34, 'a',         0,  1 );
add_category( 35, 'abc123',    0,  1 );
add_category( 36, '#32',       0,  1 );

# foreach my $c (values %cats_hash) {
# 	print STDERR "id: ", $c->id, " parent: ", $c->parent, " name: ", $c->label, "\n";
# }
my $ctx = MT::Template::Context->new();
my @cats;
my $expr;
my $cat_filter;

@cats = ( $cats_hash{1} );
$expr = $ctx->compile_category_filter( undef, \@cats );
is_deeply( [ map $_->id, @cats ], [1], "child categories were not added" );
ok( $expr->( { 1 => 1 } ), "expr contains parent" );
ok( !$expr->( { 3 => 1 } ), "expr does not contain child" );

@cats = ( $cats_hash{1} );
$expr = $ctx->compile_category_filter( undef, \@cats, { children => 1 } );
@cats = sort { $a->id <=> $b->id } @cats;
is_deeply(
    [ map $_->id, @cats ],
    [ 1, 3, 27 ],
    "child categories were added"
);
ok( $expr->( { 1 => 1 } ), "expr contains parent" );
ok( $expr->( { 3 => 1 } ), "expr contains child" );

@cats = @cats_hash{ 2, 3 };
$expr = $ctx->compile_category_filter( undef, \@cats, { children => 1 } );
@cats = sort { $a->id <=> $b->id } @cats;
is_deeply( [ map $_->id, @cats ], [ 2, 3, 27 ], "nothing else was added" );
ok( $expr->( { 2 => 1 } ), "expr contains 2" );
ok( $expr->( { 3 => 1 } ), "expr contains 3" );
ok( !$expr->( { 1 => 1 } ), "expr not contains 1" );

@cats = @cats_hash{ 2, 26 };
$expr = $ctx->compile_category_filter( "bar AND aaa", \@cats,
    { children => 1 } );
@cats = sort { $a->id <=> $b->id } @cats;
is_deeply( [ map $_->id, @cats ], [ 2, 26 ], "nothing else was added" );
ok( !$expr->( { 26 => 1 } ), "expr needs more then 26" );
ok( !$expr->( { 3  => 1 } ), "expr needs more then 3" );
ok( $expr->( { 2 => 1, 26 => 1 } ), "expr true for 2 AND 3" );

@cats = @cats_hash{ 2, 27 };
$expr = $ctx->compile_category_filter( "bar OR subsubfoo",
    \@cats, { children => 1 } );
@cats = sort { $a->id <=> $b->id } @cats;
is_deeply( [ map $_->id, @cats ], [ 2, 27 ], "nothing else was added" );
ok( $expr->( { 2  => 1 } ), "expr true for 2" );
ok( $expr->( { 27 => 1 } ), "expr true for 27" );
ok( $expr->( { 2 => 1, 27 => 1 } ), "expr true for 2 AND 3" );

@cats = values %cats_hash;
$expr = $ctx->compile_category_filter( "bar AND aaa", \@cats );
ok( !$expr->( { 2  => 1 } ), "expr false for 2" );
ok( !$expr->( { 26 => 1 } ), "expr false for 26" );
ok( $expr->( { 26 => 1, 2 => 1 } ), "expr true for 2 AND 26" );
ok( $expr->( { 29 => 1, 2 => 1 } ), "expr true for 2 AND 29" );

@cats = values %cats_hash;
$expr = $ctx->compile_category_filter( "bar AND aaa", \@cats,
    { children => 1 } );
ok( !$expr->( { 2  => 1 } ), "expr false for 2" );
ok( !$expr->( { 26 => 1 } ), "expr false for 23" );
ok( $expr->( { 26 => 1, 2 => 1 } ), "expr true for 2 AND 26" );
ok( $expr->( { 29 => 1, 2 => 1 } ), "expr true for 2 AND 29" );
ok( $expr->( { 30 => 1, 2 => 1 } ), "expr true for 2 AND 30" );
ok( !$expr->( { 30 => 1, 26 => 1 } ), "expr false for 30 AND 26" );

@cats = values %cats_hash;
$expr = $ctx->compile_category_filter( "foo", \@cats, { children => 1 } );
foreach ( 1, 3, 27, 30 ) {
    ok( $expr->( { $_ => 1 } ), "expr true for $_" );
}
foreach ( 2, 28, 29, 26 ) {
    ok( !$expr->( { $_ => 1 } ), "expr false for $_" );
}

@cats = values %cats_hash;
$expr = $ctx->compile_category_filter( "bbb/aaa", \@cats, { children => 1 } );
ok( !$expr->( { 1 => 1, 28 => 1 } ), "expr false for 1, 28" );
ok( $expr->( { 29 => 1 } ), "expr true for 29" );
ok( $expr->( { 30 => 1 } ), "expr true for 30" );

@cats = values %cats_hash;
$expr = $ctx->compile_category_filter( "bbb/aaa", \@cats );
ok( !$expr->( { 1 => 1, 28 => 1, 30 => 1 } ), "expr false for 1, 28, 30" );
ok( $expr->( { 29 => 1 } ), "expr true for 29" );

@cats = values %cats_hash;
$expr = $ctx->compile_category_filter( "bbb/aaa OR foo", \@cats );
ok( !$expr->( { 3 => 1, 28 => 1, 26 => 1 } ), "expr false for 3, 28, 26" );
foreach ( 1, 29, 30 ) {
    ok( $expr->( { $_ => 1 } ), "expr true for $_" );
}

@cats = values %cats_hash;
$expr = $ctx->compile_category_filter( "bbb/aaa OR foo",
    \@cats, { children => 1 } );
foreach ( 2, 28 ) {
    ok( !$expr->( { $_ => 1 } ), "expr false for $_" );
}
foreach ( 1, 3, 27, 29, 30 ) {
    ok( $expr->( { $_ => 1 } ), "expr true for $_" );
}

$cat_filter = "NOT (aaa OR bbb)";
@cats = ( @cats_hash{ 2, 26, 28 } );
$expr
    = $ctx->compile_category_filter( $cat_filter, \@cats, { children => 1 } );
@cats = sort { $a->id <=> $b->id } @cats;
ok( $expr->( { 2 => 1 } ), "$cat_filter: expr true for 2" );
ok( !$expr->( { 26 => 1 } ), "$cat_filter: expr false for 26" );
ok( !$expr->( { 28 => 1 } ), "$cat_filter: expr false for 28" );

$cat_filter = "NOT (buz buz OR bbb)";
@cats = ( @cats_hash{ 2, 26, 28, 31 } );
$expr
    = $ctx->compile_category_filter( $cat_filter, \@cats, { children => 1 } );
@cats = sort { $a->id <=> $b->id } @cats;
ok( $expr->( { 2  => 1 } ), "$cat_filter: expr true for 2" );
ok( $expr->( { 26 => 1 } ), "$cat_filter: expr false for 26" );
ok( !$expr->( { 28 => 1 } ), "$cat_filter: expr false for 28" );
ok( !$expr->( { 31 => 1 } ), "$cat_filter: expr false for 31" );

$cat_filter = "buz buz OR bar";
@cats = ( @cats_hash{ 2, 31 } );
$expr
    = $ctx->compile_category_filter( $cat_filter, \@cats, { children => 1 } );
@cats = sort { $a->id <=> $b->id } @cats;
is_deeply(
    [ map $_->id, @cats ],
    [ 2,          31 ],
    "$cat_filter: nothing else was added"
);
ok( $expr->( { 2  => 1 } ), "$cat_filter: expr true for 2" );
ok( $expr->( { 31 => 1 } ), "$cat_filter: expr true for 31" );
ok( $expr->( { 2 => 1, 31 => 1 } ), "$cat_filter: expr true for 2 AND 31" );

$cat_filter = "a(b)";
@cats       = ( $cats_hash{32} );
$expr       = $ctx->compile_category_filter( $cat_filter, \@cats );
is_deeply( [ map $_->id, @cats ],
    [32], "$cat_filter: nothing else was added" );
ok( $expr->( { 32 => 1 } ), "$cat_filter: expr true for 32" );

$cat_filter = "a/b";
@cats       = ( $cats_hash{33} );
$expr       = $ctx->compile_category_filter( $cat_filter, \@cats );
is_deeply( [ map $_->id, @cats ],
    [33], "$cat_filter: nothing else was added" );
ok( $expr->( { 33 => 1 } ), "$cat_filter: expr true for 33" );

$cat_filter = "a(b) OR a/b";
@cats       = ( @cats_hash{ 32, 33 } );
$expr       = $ctx->compile_category_filter( $cat_filter, \@cats );
@cats       = sort { $a->id <=> $b->id } @cats;
is_deeply(
    [ map $_->id, @cats ],
    [ 32,         33 ],
    "$cat_filter: nothing else was added"
);
ok( $expr->( { 32 => 1 } ), "$cat_filter: expr true for 32" );
ok( $expr->( { 33 => 1 } ), "$cat_filter: expr true for 33" );
ok( $expr->( { 32 => 1, 33 => 1 } ), "$cat_filter: expr true for 32 AND 33" );

my @suite = (

    # Case 107670
    { cats => [], cat_filter => 'Test1', expr_ok => [] },

    # Case 106304
    { cats => [], cat_filter => 'Issues 16/test',   expr_ok => [] },
    { cats => [], cat_filter => '[Issues 16]/test', expr_ok => [] },
    { cats => [], cat_filter => 'Issues/001',       expr_ok => [] },
    { cats => [], cat_filter => 'a16_001',          expr_ok => [] },
    { cats => [], cat_filter => '16_001',           expr_ok => [] },

    # Case 109353
    { cats => [], cat_filter => '1', expr_ok => [] },

    { cats => [ $cats_hash{35} ], cat_filter => 'abc123', expr_ok => [35] },
    { cats => [ $cats_hash{36} ], cat_filter => '#32',    expr_ok => [36] },
    {   cats       => [ values %cats_hash ],
        cat_filter => 'Test1 OR abc123',
        expr_ok    => [35]
    },
    {   cats       => [ values %cats_hash ],
        cat_filter => 'Test1 OR #32',
        expr_ok    => [36]
    },
    {   cats       => [ values %cats_hash ],
        cat_filter => 'Test1 AND abc123',
        expr_ok    => []
    },
    {   cats       => [ values %cats_hash ],
        cat_filter => 'Test1 AND #32',
        expr_ok    => []
    },
    {   cats       => [ values %cats_hash ],
        cat_filter => 'NOT abc123',
        expr_ok    => [ grep { $_ != 35 } keys %cats_hash ]
    },
    {   cats       => [ values %cats_hash ],
        cat_filter => 'NOT #32',
        expr_ok    => [ grep { $_ != 36 } keys %cats_hash ]
    },

    {   cats       => [ values %cats_hash ],
        cat_filter => 'def456 OR 789ghi',
        expr_ok    => []
    },
);

foreach my $test (@suite) {
    $expr
        = $ctx->compile_category_filter( $test->{cat_filter}, $test->{cats} );
    ok( $expr, 'expr is defined' );
    foreach my $cat_id ( sort keys %cats_hash ) {
        if ( grep { $cat_id == $_ } @{ $test->{expr_ok} } ) {
            ok( $expr->( { $cat_id => 1 } ), 'expr true for ' . $cat_id );
        }
        else {
            ok( !$expr->( { $cat_id => 1 } ), 'expr false for ' . $cat_id );
        }
    }
}

done_testing();

sub add_category {
    my ( $id, $label, $parent, $blog_id ) = @_;
    my $new_cat = $cclass->new();
    $new_cat->label($label);
    $new_cat->parent($parent);
    $new_cat->blog_id($blog_id);
    $new_cat->save() or die $new_cat->errstr;
    $cats_hash{ $new_cat->id } = $new_cat;
    is( $new_cat->id, $id, "The new ID is $id" );
}

__END__
Initial categories:
id: 1 parent: 0 name: foo
id: 2 parent: 0 name: bar
id: 3 parent: 1 name: subfoo
----
Built category tree:
foo(1)->subfoo(3)->subsubfoo(24)
bar(2)
aaa(23)
bbb(25)->aaa(26)->foo(27)
buz buz(28)
a(b)(29)
a/b(30)
a(31)
abc(32)
#32(33)
