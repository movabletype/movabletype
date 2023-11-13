#!/usr/bin/env perl

# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

use strict;
$ENV{NYTPROF} = 'sigexit=int:start=no';
require Devel::NYTProf;
DB::enable_profile("nytprof-tmp/nytprof.out.". time(). '.'. $$);
require './mt-profilee.psgi';

END {
    DB::finish_profile();
}
