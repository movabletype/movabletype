use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use Test::Deep qw(cmp_deeply noneof);
use MT::Test::Env;
use MT::Test::Util::Plugin;

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => ['TEST_ROOT/plugins'],
        PluginSwitch => [
            'MyPlugin2/MyPlugin.pl=0',
            'MyPlugin3/MyPluginA.pl=0',
            'MyPlugin5/MyPluginA.pl=0',
            'MyPlugin5/MyPluginB.pl=0',
            'MyPlugin7=0'
        ],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

my $plugin_gen = MT::Test::Util::Plugin->new( $test_env, 'plugins' );

$plugin_gen->gen_dir_with_pl(
    'MyPlugin1', '0.1', 'MyPlugin1', 'MyPlugin.pl' );
$plugin_gen->gen_plugin_module(
    'MyPlugin1', '0.1', 'MyPlugin1');

$plugin_gen->gen_dir_with_pl(
    'MyPlugin2', '0.2', 'MyPlugin2', 'MyPlugin.pl' );
$plugin_gen->gen_plugin_module(
    'MyPlugin2', '0.2', 'MyPlugin2');

# The folder contains two plugin files
$plugin_gen->gen_dir_with_pl(
    'MyPlugin3', '0.1', 'MyPlugin3', 'MyPluginA.pl' );
$plugin_gen->gen_dir_with_pl(
    'MyPlugin4', '0.2', 'MyPlugin3', 'MyPluginB.pl' );
$plugin_gen->gen_plugin_module(
    'MyPlugin4', '0.2', 'MyPlugin3');

# The folder contains two plugin files
$plugin_gen->gen_dir_with_pl(
    'MyPlugin5', '0.1', 'MyPlugin5', 'MyPluginA.pl' );
$plugin_gen->gen_dir_with_pl(
    'MyPlugin6', '0.2', 'MyPlugin5', 'MyPluginB.pl' );
$plugin_gen->gen_plugin_module(
    'MyPlugin6', '0.2', 'MyPlugin5');

$plugin_gen->gen_dir_with_yaml(
    'MyPlugin7', '0.1', 'MyPlugin7' );
$plugin_gen->gen_plugin_module(
    'MyPlugin7', '0.1', 'MyPlugin7');

$plugin_gen->gen_dir_with_yaml(
    'MyPlugin8', '0.2', 'MyPlugin8' );
$plugin_gen->gen_plugin_module(
    'MyPlugin8', '0.2', 'MyPlugin8');

$test_env->prepare_fixture('db');

use MT;
use MT::PSGI;
use MT::Test;
ok eval { MT->instance }, "mt instance" or note $@;

my @disabled_module_paths = map {
    $test_env->path( 'plugins/' . $_ . '/lib' );
} (
    'MyPlugin2',
    # 'MyPlugin3', # <- contains enabled plugin file
    'MyPlugin5',
    'MyPlugin7'
);
cmp_deeply(
    \@disabled_module_paths,
    noneof(@INC),
    "not included disabled modules"
) or note explain \@INC;

done_testing;
