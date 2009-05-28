#!/usr/bin/perl

use strict;
use warnings;

use lib 't/lib', 'lib', 'extlib';
use Test::More tests => 1;

BEGIN {
        $ENV{MT_APP} = 'MT::App::CMS';
}

use MT;
use MT::Test qw( :app :db :data );

my $app = MT::App::CMS->instance();

my $static_path = $app->static_file_path;
ok ($static_path, "Static path exists: $static_path");