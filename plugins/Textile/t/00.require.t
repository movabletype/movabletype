#!/usr/bin/perl

use strict;
use warnings;

use lib qw( lib extlib plugins/Textile );

use Test::More;

require_ok('textile2.pl');

done_testing;
