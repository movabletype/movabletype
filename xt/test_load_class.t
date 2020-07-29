use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../t/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => ['TEST_ROOT/plugins'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file("plugins/Amazing/config.yaml", <<"YAML");
name: Amazing
key:  amazing
id:   amazing

object_types:
    entry:
        amazing: text
YAML
}

use MT;
use MT::Test qw(:db);

ok('amazing!!');

done_testing;
