#!/usr/bin/perl

use strict;
use warnings;

use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/lib"    : 'lib';
use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/extlib" : 'extlib';
use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/t/lib"  : 't/lib';

BEGIN {
    $ENV{MT_CONFIG} ||= 'mysql-test.cfg';
}

use Plack::Loader;
use Getopt::Long;

use MT;
eval(
    $ENV{SKIP_REINITIALIZE_DATABASE}
    ? "use MT::Test;"
    : "use MT::Test qw(:db :data);"
);
die $@ if $@;


my $port         = 5000;
my @plugin_paths = ();
GetOptions(
    'port=i'       => \$port,
    'plugin-path=s' => \@plugin_paths,
) or exit(1);


my $mt = MT->new;
$mt->_init_plugins_core( {}, 1, \@plugin_paths ) if @plugin_paths;


eval "use MT::PSGI;";
die $@ if $@;

my $app = MT::PSGI->new()->to_app();
my $loader = Plack::Loader->load(
    'Starman',
    port        => $port,
    max_workers => 1
);
$loader->run($app);
