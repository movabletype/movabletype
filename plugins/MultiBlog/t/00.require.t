#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 3;

use lib qw( extlib lib plugins/MultiBlog plugins/MultiBlog/lib );
use MT;

require_ok ( 'multiblog.pl' );
require_ok ( 'MultiBlog' );
require_ok ( 'MultiBlog::Tags' );
