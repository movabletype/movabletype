#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib);

use Test::More;
use MT;

my $mt = MT->instance;

ok( $mt->component('Textile/textile2.pl'), 'Load plugin' );

my %registries = (
    'function tag' => {
        registry => [ 'tags',           'function' ],
        names    => [ 'TextileOptions', 'TextileHeadOffset' ],
    },
    'block tag' => {
        registry => [ 'tags', 'block' ],
        names    => ['Textile'],
    },
    text_filter => {
        registry => ['text_filters'],
        names    => ['textile_2'],
    },
);

for my $k ( keys(%registries) ) {
    my $registry = $mt->registry( @{ $registries{$k}{registry} } );
    for my $name ( @{ $registries{$k}{names} } ) {
        ok( $registry->{$name}, "$k '$name'" );
    }
}

done_testing;
