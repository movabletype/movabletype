#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib plugins/Markdown);

use Test::More;

require_ok('Markdown.pl');
require_ok('SmartyPants.pl');

done_testing;
