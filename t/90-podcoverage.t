#!/usr/bin/perl
# $Id: 90-podcoverage.t 1460 2008-03-04 23:07:53Z mpaschal $

use strict;
use warnings;

use Test::More;
use lib qw( lib ../lib );
eval "use Test::Pod::Coverage";
plan skip_all => "Test::Pod::Coverage required for testing pod coverage" if $@;

all_pod_coverage_ok();
