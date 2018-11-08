#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
my $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use Plack::Loader;
use Getopt::Long;

use MT;
use MT::Test;

$test_env->prepare_fixture('db_data');

my $port         = 5000;
my @plugin_paths = ();
GetOptions(
    'port=i'        => \$port,
    'plugin-path=s' => \@plugin_paths,
) or exit(1);

my $mt = MT->new;
$mt->_init_plugins_core( {}, 1, \@plugin_paths ) if @plugin_paths;

eval "use MT::PSGI;";
die $@ if $@;

my $app    = MT::PSGI->new()->to_app();
my $loader = Plack::Loader->load(
    'Starman',
    port        => $port,
    max_workers => 1
);
$loader->run($app);
