#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

BEGIN {
    system('phantomjs >/dev/null 2>&1');
    if ( $? && $? != 256 ) {
        plan skip_all => "phantomjs is not installed";
    }
}

use File::Spec;
use File::Basename;

my $testdir   = dirname(__FILE__);
my $basedir   = dirname($testdir);
my $basename  = basename( __FILE__, '.t' );
my $test_html = File::Spec->catfile( $basedir, 'mt-static', 'test', 'unit',
    $basename . '.html' );

open( my $out, '-|', 'phantomjs',
    File::Spec->catfile( $testdir, 'run-qunit.js' ), $test_html );

print(
    map( {  s/.*\Q$test_html\E:\d* //;
                $_
        } <$out> )
);
