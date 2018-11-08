#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test ();
use MT;
use MT::App::CMS;

my $mt = MT::App::CMS->instance;

ok( $mt->component('WXRImporter'), 'Load plugin' );

my %registries = (
    'import formats' => {
        registry => ['import_formats'],
        names    => ['import_wxr'],
    },
    'task workers' => {
        registry => ['task_workers'],
        names    => [ 'wxr_importer', ],
    },
);

for my $k ( keys(%registries) ) {
    my $registry = $mt->registry( @{ $registries{$k}{registry} } );
    for my $name ( @{ $registries{$k}{names} || [] } ) {
        ok( $registry->{$name}, "$k '$name'" );
    }
    for my $name ( keys %{ $registries{$k}{like_any} || {} } ) {
        my $value = $registry->{$name} || undef;
        my $regexp = $registries{$k}{like_any}{$name};
        if ( ref($value) ne 'ARRAY' ) {
            $value = [$value];
        }
        ok( grep( $_ =~ $regexp, @$value ), "$k '$name'" );
    }
}

done_testing;
