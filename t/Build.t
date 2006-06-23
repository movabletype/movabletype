#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 4;

use lib 'build';
my $package = 'Build';
my $config = { FOO => 'BAR', };
my $file = 't/test.conf';

use_ok $package;
ok Build->can( 'ACTION_realclean' ), 'can realclean';
is ref( Build::read_conf( $file ) ), 'HASH', 'read_config()';
ok Build::substitute( $config, $file ), 'substitute()';
