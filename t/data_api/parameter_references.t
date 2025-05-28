use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

$test_env->prepare_fixture('db');

use MT::Test::App;
my $app = MT::Test::App->new('DataAPI');

$ENV{MT_DATA_API_DEBUG} = 1;

my $max_version = MT::App::DataAPI->DEFAULT_VERSION;
for my $version (1 .. $max_version) {
    $test_env->remove_logfile;
    $app->get_ok({ __path_info => "/v$version" });
    my $log = $test_env->slurp_logfile // '';
    my @warnings = $log =~ /(DataAPI Schema: .+ requires .+ parameter definition)/g;
    ok !@warnings, "no parameter definition warnings for version $version" or note explain \@warnings;
}

done_testing;

