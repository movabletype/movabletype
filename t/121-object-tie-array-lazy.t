#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib qw(lib extlib t/lib);

eval(
    $ENV{SKIP_REINITIALIZE_DATABASE}
    ? "use MT::Test;"
    : "use MT::Test qw(:db :data);"
);
die $@ if $@;

use Test::More;

use MT;
use MT::Object::Tie::Array::Lazy;

my $mt = MT->new();
my $data_array_ref = [ [1], [2], [3] ];

sub new_unresolved_array {
    MT::Object::Tie::Array::Lazy->create( $_[0], { model => 'entry' } );
}

sub new_resolved_array {
    no warnings;
    my $array
        = MT::Object::Tie::Array::Lazy->create( $_[0], { model => 'entry' } );
    for (@$array) {
        $_;
    }
    $array;
}

sub run_resolved_and_unresolved {
    my ( $name, $sub ) = @_;
    subtest "$name - unresolved" => sub {
        $sub->( \&new_unresolved_array );
    };
    subtest "$name - resolved" => sub {
        $sub->( \&new_resolved_array );
    };
}

sub run {
    subtest 'TIEARRAY - valid option' => sub {
        my @array;
        my $array = tie @array, 'MT::Object::Tie::Array::Lazy',
            { model => 'entry' };
        isa_ok( $array, 'MT::Object::Tie::Array::Lazy' );

        done_testing();
    };
    subtest 'TIEARRAY - invalid option' => sub {
        eval {
            my @array;
            my $array = tie @array, 'MT::Object::Tie::Array::Lazy';
        };
        like( $@, qr/^usage:/, 'The "model" parameter is required' );

        done_testing();
    };
    run_resolved_and_unresolved 'FETCHSIZE' => sub {
        my ($initializer) = @_;
        my $array = $initializer->($data_array_ref);
        is( scalar @$array, scalar @$data_array_ref );
        done_testing();
    };
    run_resolved_and_unresolved 'STORESIZE' => sub {
        my ($initializer) = @_;
        my $array = $initializer->($data_array_ref);
        $#{$array} = 1;
        is( scalar @$array, 2 );
        done_testing();
    };
    run_resolved_and_unresolved 'STORE' => sub {
        my ($initializer) = @_;
        my $array = $initializer->($data_array_ref);

        my $id = 4;
        isnt( $id, $data_array_ref->[0][0], 'Valid test data' );
        $array->[0] = [$id];
        my $obj = $array->[0];
        isa_ok( $obj, 'MT::Entry' );
        is( $obj->id, $id, 'Fetched valid object' );

        done_testing();
    };
    subtest 'FETCH' => sub {
        my $array = new_unresolved_array($data_array_ref);
        my $obj   = $array->[0];
        isa_ok( $obj, 'MT::Entry' );
        is( $obj->id, $data_array_ref->[0][0], 'Fetched valid object' );
        done_testing();
    };
    run_resolved_and_unresolved 'CLEAR' => sub {
        my ($initializer) = @_;
        my $array = $initializer->($data_array_ref);
        @$array = ();
        is( scalar @$array, 0 );
        done_testing();
    };
    run_resolved_and_unresolved 'POP' => sub {
        my ($initializer) = @_;
        my $array = $initializer->($data_array_ref);

        my $obj = pop(@$array);
        is( scalar @$array,
            scalar @$data_array_ref - 1,
            'The size of array is decreased'
        );
        isa_ok( $obj, 'MT::Entry' );
        is( $obj->id, $data_array_ref->[-1][0], 'Fetched valid object' );

        done_testing();
    };
    run_resolved_and_unresolved 'PUSH' => sub {
        my ($initializer) = @_;
        my $array = $initializer->($data_array_ref);

        my $id = 4;
        my $size = push( @$array, [$id] );
        is( scalar @$array,
            scalar @$data_array_ref + 1,
            'The size of array is increased'
        );
        is( $size, scalar @$data_array_ref + 1,
            'Returned the size of array' );

        my $obj = $array->[-1];
        isa_ok( $obj, 'MT::Entry' );
        is( $obj->id, $id, 'Fetched valid object' );

        done_testing();
    };
    run_resolved_and_unresolved 'SHIFT' => sub {
        my ($initializer) = @_;
        my $array = $initializer->($data_array_ref);

        my $obj = shift(@$array);
        is( scalar @$array,
            scalar @$data_array_ref - 1,
            'The size of array is decreased'
        );
        isa_ok( $obj, 'MT::Entry' );
        is( $obj->id, $data_array_ref->[0][0], 'Fetched valid object' );

        done_testing();
    };
    run_resolved_and_unresolved 'UNSHIFT' => sub {
        my ($initializer) = @_;
        my $array = $initializer->($data_array_ref);

        my $id = 4;
        my $size = unshift( @$array, [$id] );
        is( scalar @$array,
            scalar @$data_array_ref + 1,
            'The size of array is increased'
        );
        is( $size, scalar @$data_array_ref + 1,
            'Returned the size of array' );

        my $obj = $array->[0];
        isa_ok( $obj, 'MT::Entry' );
        is( $obj->id, $id, 'Fetched valid object' );

        done_testing();
    };
    subtest 'EXISTS' => sub {
        my $array = new_unresolved_array($data_array_ref);
        is( exists $array->[0], !!1, 'For the entry existing' );
        is( exists $array->[ scalar @$data_array_ref ],
            !1, 'For the entry not existing' );

        done_testing();
    };
    run_resolved_and_unresolved 'DELETE' => sub {
        my ($initializer) = @_;
        my $array = $initializer->($data_array_ref);

        my $obj = delete $array->[1];
        is( scalar @$array,
            scalar @$data_array_ref,
            'The size of array is not changed'
        );
        is( $array->[1], undef, 'Got "undef"' );

        isa_ok( $obj, 'MT::Entry' );
        is( $obj->id, $data_array_ref->[1][0], 'Fetched valid object' );

        done_testing();
    };
    run_resolved_and_unresolved 'SPLICE' => sub {
        my ($initializer) = @_;
        my $array = $initializer->($data_array_ref);

        my $id = 4;
        my ($obj) = splice @$array, 1, 1, [$id];

        is( scalar @$array,
            scalar @$data_array_ref,
            'The size of array is not changed'
        );
        isa_ok( $obj, 'MT::Entry' );
        is( $obj->id, $data_array_ref->[1][0], 'Fetched valid object' );

        done_testing();
    };

    done_testing();
}

subtest 'MT::Object::Tie::Array::Lazy' => \&run;

done_testing();
