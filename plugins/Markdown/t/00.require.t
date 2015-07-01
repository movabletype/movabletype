#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib extlib plugins/Markdown);

use Test::More;
use MT;

$MT::plugin_envelope = 'plugins/Markdown';    # Supress warning.

$MT::plugin_sig = 'Markdown/Markdown.pl';     # Supress warning.
require_ok('Markdown.pl');

$MT::plugin_sig = 'Markdown/SmartyPants.pl';    # Supress warning.
require_ok('SmartyPants.pl');

done_testing;
