#!/usr/bin/perl

use lib 't/lib', 'lib', 'extlib';
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

use utf8;
use MT;
use MT::Test qw(:db :data);

my $mt          = MT->new;
my $entry_count = $mt->model('entry')->count();
my $page_count  = $mt->model('page')->count();

my $count;

{
    $count = $mt->model('entry')->count( { class => 'entry' } );
    is( $count, $entry_count );

    $count = $mt->model('entry')->count( { class => 'page' } );
    is( $count, $page_count );

    $count = $mt->model('entry')->count( { class => '*' } );
    is( $count, $entry_count + $page_count );

    $count = $mt->model('entry')->count( { id => '1' } );
    is( $count, 1 );
}

{
    $count = $mt->model('entry')->count( { id => \'> 0', class => "*" } );
    is( $count, $entry_count + $page_count );

    $count = $mt->model('entry')->count( { id => \'> 0', class => "entry" } );
    is( $count, $entry_count );

    $count = $mt->model('entry')->count( { id => \'> 0', class => "page" } );
    is( $count, $page_count );

    $count = $mt->model('entry')->count( { id => \'> 0' } );
    is( $count, $entry_count + $page_count );
}

{
    $count
        = $mt->model('entry')->count( { id => { '>' => 0 }, class => "*" } );
    is( $count, $entry_count + $page_count );

    $count = $mt->model('entry')
        ->count( { id => { '>' => 0 }, class => "entry" } );
    is( $count, $entry_count );

    $count = $mt->model('entry')
        ->count( { id => { '>' => 0 }, class => "page" } );
    is( $count, $page_count );

    $count = $mt->model('entry')->count( { id => { '>' => 0 } } );
    is( $count, $entry_count + $page_count );
}

{
    $count = $mt->model('entry')
        ->count( { id => { not => '0' }, class => "*" } );
    is( $count, $entry_count + $page_count );

    $count = $mt->model('entry')
        ->count( { id => { not => '0' }, class => "entry" } );
    is( $count, $entry_count );

    $count
        = $mt->model('entry')
        ->count( { id => { not => '0' }, class => "page" } );
    is( $count, $page_count );

    $count
        = $mt->model('entry')->count( { id => { not => '0' } } );
    is( $count, $entry_count + $page_count );
}

{
    $count = $mt->model('entry')
        ->count( { id => { not => '0' }, class => "*" } );
    is( $count, $entry_count + $page_count );

    $count = $mt->model('entry')
        ->count( { id => { not => '0' }, class => "entry" } );
    is( $count, $entry_count );

    $count
        = $mt->model('entry')
        ->count( { id => { not => '0' }, class => "page" } );
    is( $count, $page_count );

    $count
        = $mt->model('entry')->count( { id => { not => '0' } } );
    is( $count, $entry_count + $page_count );
}

{
    $count = $mt->model('entry')
        ->count( { id => '0', class => "*" }, { not => { id => 1 } } );
    is( $count, $entry_count + $page_count );

    $count = $mt->model('entry')
        ->count( { id => '0', class => "entry" }, { not => { id => 1 } } );
    is( $count, $entry_count );

    $count
        = $mt->model('entry')
        ->count( { id => '0', class => "page" }, { not => { id => 1 } } );
    is( $count, $page_count );

    $count
        = $mt->model('entry')->count( { id => '0' }, { not => { id => 1 } } );
    is( $count, $entry_count + $page_count );
}

done_testing();

1;
