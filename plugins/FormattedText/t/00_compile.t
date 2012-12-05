#!/usr/bin/perl

use strict;
use warnings;

use lib qw( extlib lib );

BEGIN {
	use File::Basename qw( dirname );
	use File::Spec;
	my $plugin_home = dirname(dirname(File::Spec->rel2abs(__FILE__)));
	push @INC, "$plugin_home/lib", "$plugin_home/extlib";
}

use Test::More;
use MT;

use_ok('FormattedText');
use_ok('FormattedText::FormattedText');
use_ok('FormattedText::App');

done_testing;
