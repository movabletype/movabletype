#!/usr/bin/perl

# Movable Type (r) (C) 2001-2019 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

use strict;
use warnings;
use Getopt::Long;
use LWP::UserAgent;

my $jsfile = undef;

GetOptions( 'file=s' => \$jsfile, );

if ( !$jsfile ) {
    print << 'USAGE';
DESCRIPTION:
  compile JavaScript using the Closure Compiler Service API.
  print compiled code to STDOUT.

SYNOPSIS:
  $ ./compile.pl -f jsfile

OPTIONS:
  -f, --file=jsfile JavaScript file for compile
USAGE
    exit;
}

open my $fh, '<', $jsfile or die "$jsfile: $!";
my $code = do { local $/; <$fh> };
close $fh;

my $ua       = LWP::UserAgent->new;
my $response = $ua->post(
    'http://closure-compiler.appspot.com/compile',
    {   'js_code'           => $code,
        'compilation_level' => 'SIMPLE_OPTIMIZATIONS',
        'output_format'     => 'text',
        'output_info'       => 'compiled_code',
    },
    'Content-Type' => 'application/x-www-form-urlencoded',
);

my $year     = ( localtime(time) )[5] + 1900;
my $compiled = << "HEAD";
/*
 * Movable Type (r) (C) 2001-2019 Six Apart, Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * \$Id\$
 */
HEAD
$compiled .= $response->content;

print $compiled;
