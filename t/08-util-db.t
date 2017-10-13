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

use utf8;

plan tests => 8;
use MT::Test qw(:db :data);

use MT;
use MT::Util qw(archive_file_for get_entry multi_iter);

my $mt        = MT->new;
my $timestamp = '19770908153005';

{
    my $entry = $mt->model('entry')->load(1);
    is( archive_file_for( $entry, $entry->blog, 'Individual' ),
        '1978/01/a-rainy-day.html', 'archive_file_for()' );
}

{
    my $entry;
    ok( $entry = get_entry( $timestamp, 1, 'Daily' ), 'get_entry()' );
    is( $entry ? $entry->title : '', 'A Rainy Day', 'result of get_entry()' );

    ok( $entry = get_entry( $timestamp, 1, 'Daily', 'previous' ), 'get_entry() with "previous"' );
    is( $entry ? $entry->title : '', 'Verse 5', 'result of get_entry() with "previous"' );

    ok( !get_entry( $timestamp, 1, 'Category' ), 'get_entry() with invalid archive_type' );
}

{
    my $iter1 =
      $mt->model('blog')->load_iter( undef, { sort => 'id', limit => 1 } );
    my $iter2 =
      $mt->model('entry')->load_iter( undef, { sort => 'id', limit => 1 } );
    my $iter3 =
      $mt->model('comment')->load_iter( undef, { sort => 'id', limit => 1 } );
    my $multi = multi_iter( [ $iter1, $iter2, $iter3 ] );
    my @objs = ();
    while ( my $obj = $multi->() ) {
        push( @objs, ref($obj) . '#' . $obj->id );
    }
    is(
        join( ',', @objs ),
        'MT::Blog#1,MT::Entry#1,MT::Comment#1',
        "multi_iter() without picker"
    );
}

{
    my $iter1 =
      $mt->model('blog')->load_iter( undef, { sort => 'id', limit => 1 } );
    my $iter2 =
      $mt->model('entry')->load_iter( undef, { sort => 'id', limit => 1 } );
    my $iter3 =
      $mt->model('comment')->load_iter( undef, { sort => 'id', limit => 1 } );
    my $picker = sub { ref $_[0] eq 'MT::Comment' };
    my $multi = multi_iter( [ $iter1, $iter2, $iter3 ], $picker );
    my @objs = ();
    while ( my $obj = $multi->() ) {
        push( @objs, ref($obj) . '#' . $obj->id );
    }
    is(
        join( ',', @objs ),
        'MT::Comment#1,MT::Blog#1,MT::Entry#1',
        "multi_iter() with picker"
    );
}
