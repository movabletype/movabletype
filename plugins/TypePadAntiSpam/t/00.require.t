#!/usr/bin/perl
use strict;
use warnings;

use Test::More;

use lib qw( extlib lib plugins/TypePadAntiSpam/lib );

use_ok('TypePadAntiSpam');
use_ok('MT::TypePadAntiSpam');

done_testing;
