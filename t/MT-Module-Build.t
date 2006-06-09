#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 4;

my $package = 'MT::Module::Build';
my $config = { FOO => 'BAR', };
my $file = 't/test.conf';

use_ok $package;
ok MT::Module::Build->can( 'ACTION_realclean' ), 'can realclean';
is ref( MT::Module::Build::read_conf( $file ) ), 'HASH', 'read_config()';
ok MT::Module::Build::substitute( $config, $file ), 'substitute()';
