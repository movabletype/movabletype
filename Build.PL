#!/usr/bin/perl
#
# Movable Type Build program.
# $Id$
#
use strict;
use warnings;
use lib 'lib';
use MT::Module::Build;

$|++;

# Give unto us a blessed build object.
my $build = MT::Module::Build->new(
    module_name => 'MT',
    dist_version  => '3.3',
    dist_abstract => 'Movable Type Web Publishing Platform and Content Management System',
    dist_author   => 'Six Apart <support@movabletype.org>',
    license => 'perl',
    requires => {
        perl => '5.6.1',
    },
    PL_files => {
        'build/mt-build.PL' => [qw(
            lib/MT.pm
            lib/MT/ConfigMgr.pm
            mt-config.cgi-original
            mt-check.cgi ),
        ],
    },
    add_to_cleanup => [qw(
        MANIFEST
        MANIFEST.bak
        build-language-stamp
    )],
);

# Collect the configuration and locale elements to use.
$build->preprocess();

# Ready, set, go.
$build->create_build_script();
