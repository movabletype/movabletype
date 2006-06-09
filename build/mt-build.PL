#!/usr/bin/perl
#
# Build.PL Preprocessing helper script.
# $Id$
#
use strict;
use warnings;
use lib 'lib';
use MT::Module::Build;
my $build = MT::Module::Build->current;
for my $file ( @ARGV ) {
    if( $file =~ /mt_(\w+)\.js$/ ) {
        $build->make_js( $1, $file );
    }
    elsif( $file =~ /(\w+)-iso-8859-1\.pm$/ ) {
        $build->make_latin1( $1, $file );
    }
    else {
        $build->substitute( $build->notes( 'config' ), $file );
    }
}
