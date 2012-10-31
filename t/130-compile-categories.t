#!/usr/bin/perl
use strict;
use warnings;

use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use MT::Test qw(:db :data);
use Test::More;
use MT;
use MT::Template::Context;

my $mt = MT->new();
isnt($mt, undef, "MT loaded");
my $cclass = $mt->model('category');

my %cats_hash = map { ( $_->id, $_ ) } $cclass->load({blog_id => 1});
add_category(23, 'aaa', 0, 1);
add_category(24, 'subsubfoo', 3, 1);
add_category(25, 'bbb', 0, 1);
add_category(26, 'aaa', 25, 1);
add_category(27, 'foo', 26, 1);
add_category(28, 'buz buz', 0, 1);
add_category(29, 'a(b)', 0, 1);
add_category(30, 'a/b', 0, 1);
# foreach my $c (values %cats_hash) {
# 	print STDERR "id: ", $c->id, " parent: ", $c->parent, " name: ", $c->label, "\n";
# }
my $ctx = MT::Template::Context->new();
my @cats;
my $expr;
my $cat_filter;

@cats = ( $cats_hash{1} );
$expr = $ctx->compile_category_filter(undef, \@cats);
is_deeply([map $_->id, @cats], [1], "child categories were not added");
ok( $expr->( { 1 => 1 } ), "expr contains parent" );
ok( !$expr->( { 3 => 1 } ), "expr does not contain child" );

@cats = ( $cats_hash{1} );
$expr = $ctx->compile_category_filter(undef, \@cats, { children => 1 });
@cats = sort { $a->id <=> $b->id } @cats;
is_deeply([map $_->id, @cats], [1, 3, 24], "child categories were added");
ok( $expr->( { 1 => 1 } ), "expr contains parent" );
ok( $expr->( { 3 => 1 } ), "expr contains child" );

@cats = @cats_hash{2, 3};
$expr = $ctx->compile_category_filter(undef, \@cats, { children => 1 });
@cats = sort { $a->id <=> $b->id } @cats;
is_deeply([map $_->id, @cats], [2, 3, 24], "nothing else was added");
ok( $expr->( { 2 => 1 } ), "expr contains 2" );
ok( $expr->( { 3 => 1 } ), "expr contains 3" );
ok( !$expr->( { 1 => 1 } ), "expr not contains 1" );

@cats = @cats_hash{2, 23};
$expr = $ctx->compile_category_filter("bar AND aaa", \@cats, { children => 1 });
@cats = sort { $a->id <=> $b->id } @cats;
is_deeply([map $_->id, @cats], [2, 23], "nothing else was added");
ok( !$expr->( { 23 => 1 } ), "expr needs more then 23" );
ok( !$expr->( { 3 => 1 } ), "expr needs more then 3" );
ok( $expr->( { 2 => 1, 23 => 1 } ), "expr true for 2 AND 3" );

@cats = @cats_hash{2, 24};
$expr = $ctx->compile_category_filter("bar OR subsubfoo", \@cats, { children => 1 });
@cats = sort { $a->id <=> $b->id } @cats;
is_deeply([map $_->id, @cats], [2, 24], "nothing else was added");
ok( $expr->( { 2 => 1 } ), "expr true for 2" );
ok( $expr->( { 24 => 1 } ), "expr true for 24" );
ok( $expr->( { 2 => 1, 24 => 1 } ), "expr true for 2 AND 3" );


@cats = values %cats_hash;
$expr = $ctx->compile_category_filter("bar AND aaa", \@cats);
ok( !$expr->( { 2 => 1 } ), "expr false for 2" );
ok( !$expr->( { 23 => 1 } ), "expr false for 23" );
ok( $expr->( { 23 => 1, 2 => 1 } ), "expr true for 2 AND 23" );
ok( $expr->( { 26 => 1, 2 => 1 } ), "expr true for 2 AND 26" );


@cats = values %cats_hash;
$expr = $ctx->compile_category_filter("bar AND aaa", \@cats, { children => 1 });
ok( !$expr->( { 2 => 1 } ), "expr false for 2" );
ok( !$expr->( { 23 => 1 } ), "expr false for 23" );
ok( $expr->( { 23 => 1, 2 => 1 } ), "expr true for 2 AND 23" );
ok( $expr->( { 26 => 1, 2 => 1 } ), "expr true for 2 AND 26" );
ok( $expr->( { 27 => 1, 2 => 1 } ), "expr true for 2 AND 27" );
ok( !$expr->( { 27 => 1, 23 => 1 } ), "expr false for 27 AND 23" );


@cats = values %cats_hash;
$expr = $ctx->compile_category_filter("foo", \@cats, { children => 1 });
foreach (1,3,24,27) {
	ok( $expr->( { $_ => 1 } ), "expr true for $_" );
}
foreach (2,25,26,23) {
	ok( !$expr->( { $_ => 1 } ), "expr false for $_" );
}

@cats = values %cats_hash;
$expr = $ctx->compile_category_filter("bbb/aaa", \@cats, { children => 1 });
ok( !$expr->( { 1 => 1, 25 => 1 } ), "expr false for 1, 25" );
ok( $expr->( { 26 => 1 } ), "expr true for 26" );
ok( $expr->( { 27 => 1 } ), "expr true for 27" );

@cats = values %cats_hash;
$expr = $ctx->compile_category_filter("bbb/aaa", \@cats);
ok( !$expr->( { 1 => 1, 25 => 1, 27 => 1 } ), "expr false for 1, 25, 27" );
ok( $expr->( { 26 => 1 } ), "expr true for 26" );

@cats = values %cats_hash;
$expr = $ctx->compile_category_filter("bbb/aaa OR foo", \@cats);
ok( !$expr->( { 3 => 1, 25 => 1, 23 => 1 } ), "expr false for 3, 25, 23" );
foreach (1, 26, 27) {
	ok( $expr->( { $_ => 1 } ), "expr true for $_" );
}

@cats = values %cats_hash;
$expr = $ctx->compile_category_filter("bbb/aaa OR foo", \@cats, { children => 1 });
foreach (2,25) {
	ok( !$expr->( { $_ => 1 } ), "expr false for $_" );
}
foreach (1, 3, 24, 26, 27) {
	ok( $expr->( { $_ => 1 } ), "expr true for $_" );
}

$cat_filter = "NOT (aaa OR bbb)";
@cats = ( @cats_hash{2, 23, 25} );
$expr = $ctx->compile_category_filter($cat_filter, \@cats, { children => 1 });
@cats = sort { $a->id <=> $b->id } @cats;
ok( $expr->( { 2 => 1 } ), "$cat_filter: expr true for 2" );
ok( !$expr->( { 23 => 1 } ), "$cat_filter: expr false for 23" );
ok( !$expr->( { 25 => 1 } ), "$cat_filter: expr false for 25" );


$cat_filter = "NOT (buz buz OR bbb)";
@cats = ( @cats_hash{2, 23, 25, 28} );
$expr = $ctx->compile_category_filter($cat_filter, \@cats, { children => 1 });
@cats = sort { $a->id <=> $b->id } @cats;
ok( $expr->( { 2 => 1 } ), "$cat_filter: expr true for 2" );
ok( $expr->( { 23 => 1 } ), "$cat_filter: expr false for 23" );
ok( !$expr->( { 25 => 1 } ), "$cat_filter: expr false for 25" );
ok( !$expr->( { 28 => 1 } ), "$cat_filter: expr false for 28" );


$cat_filter = "buz buz OR bar";
@cats = ( @cats_hash{2, 28} );
$expr = $ctx->compile_category_filter($cat_filter, \@cats, { children => 1 });
@cats = sort { $a->id <=> $b->id } @cats;
is_deeply([map $_->id, @cats], [2, 28], "$cat_filter: nothing else was added");
ok( $expr->( { 2 => 1 } ), "$cat_filter: expr true for 2" );
ok( $expr->( { 28 => 1 } ), "$cat_filter: expr true for 28" );
ok( $expr->( { 2 => 1, 28 => 1 } ), "$cat_filter: expr true for 2 AND 28" );


$cat_filter = "a(b)";
@cats = ( @cats_hash{29} );
$expr = $ctx->compile_category_filter($cat_filter, \@cats);
is_deeply([map $_->id, @cats], [29], "$cat_filter: nothing else was added");
ok( $expr->( { 29 => 1 } ), "$cat_filter: expr true for 29" );


$cat_filter = "a/b";
@cats = ( @cats_hash{30} );
$expr = $ctx->compile_category_filter($cat_filter, \@cats);
is_deeply([map $_->id, @cats], [30], "$cat_filter: nothing else was added");
ok( $expr->( { 30 => 1 } ), "$cat_filter: expr true for 30" );


$cat_filter = "a(b) OR a/b";
@cats = ( @cats_hash{29, 30} );
$expr = $ctx->compile_category_filter($cat_filter, \@cats);
@cats = sort { $a->id <=> $b->id } @cats;
is_deeply([map $_->id, @cats], [29, 30], "$cat_filter: nothing else was added");
ok( $expr->( { 29 => 1 } ), "$cat_filter: expr true for 29" );
ok( $expr->( { 30 => 1 } ), "$cat_filter: expr true for 30" );
ok( $expr->( { 29 => 1, 30 => 1 } ), "$cat_filter: expr true for 29 AND 30" );


done_testing();

sub add_category {
	my ($id, $label, $parent, $blog_id) = @_;
	my $new_cat = $cclass->new();
	$new_cat->label($label);
	$new_cat->parent($parent);
	$new_cat->blog_id($blog_id);
	$new_cat->save() or die $new_cat->errstr;
	$cats_hash{$new_cat->id} = $new_cat;
	is($new_cat->id, $id, "The new ID is $id");	
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
