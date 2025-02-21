use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use MT::Test::Util::Plugin;

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => [
            'TEST_ROOT/plugins',
            'TEST_ROOT/plugins-A', 'TEST_ROOT/plugins-B'
        ],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

my $plugin_gen = MT::Test::Util::Plugin->new( $test_env, 'plugins' );
$plugin_gen->gen_dir_with_pl(
    'MyPlugin1', '0.1', 'MyPlugin1-0.1', 'MyPlugin1.pl' );
$plugin_gen->gen_dir_with_yaml(
    'MyPlugin1', '1.0', 'MyPlugin1-1.0' );

$plugin_gen->gen_dir_with_pl(
    'MyPlugin2', '0.1', 'MyPlugin2-0.1', 'MyPlugin2.pl' );
$plugin_gen->gen_pl(
    'MyPlugin2', '1.0', 'MyPlugin2-1.0.pl' );

$plugin_gen->gen_dir_with_yaml(
    'MyPlugin3', '2.0', 'MyPlugin3-2.0' );
$plugin_gen->gen_pl(
    'MyPlugin3', '1.0', 'MyPlugin3-1.0.pl' );

my $plugin_gen_a = MT::Test::Util::Plugin->new( $test_env, 'plugins-A' );
my $plugin_gen_b = MT::Test::Util::Plugin->new( $test_env, 'plugins-B' );
$plugin_gen_a->gen_pl(
    'MyPlugin4', '0.1', 'MyPlugin4.pl');
$plugin_gen_b->gen_pl(
    'MyPlugin4', '1.0', 'MyPlugin4.pl');

$plugin_gen_a->gen_dir_with_pl(
    'MyPlugin5', '0.1', 'MyPlugin5', 'MyPlugin5.pl' );
$plugin_gen_b->gen_dir_with_pl(
    'MyPlugin5', '1.0', 'MyPlugin5', 'MyPlugin5.pl' );

$plugin_gen_a->gen_dir_with_yaml(
    'MyPlugin6', '2.0', 'MyPlugin6' );
$plugin_gen_b->gen_dir_with_yaml(
    'MyPlugin6', '1.0', 'MyPlugin6' );

$test_env->prepare_fixture('db');

use MT;
ok eval { MT->instance }, "mt instance" or note $@;

my $log = $test_env->slurp_logfile;
my $switch = MT->config->PluginSwitch || {};

subtest 'Conflicts name between plugins' => sub {
    note 'MyPlugin1: directory/plugin.pl, directory/config.yaml';

    ok !$switch->{'MyPlugin1-0.1/MyPlugin.pl'}, "older version is listed in PluginSwitch but is 0";
    ok $switch->{'MyPlugin1-1.0'},  "newer version is listed in PluginSwitch";
    like $log => qr/Conflicted plugin \S+?MyPlugin1-0.1\/MyPlugin1.pl 0.1 is disabled/, "logged correctly";

    note 'MyPlugin2: directory/plugin.pl, plugin.pl';

    ok !$switch->{'MyPlugin2-0.1/MyPlugin.pl'}, "older version is listed in PluginSwitch but is 0";
    ok $switch->{'MyPlugin2-1.0.pl'},  "newer version is listed in PluginSwitch";
    like $log => qr/Conflicted plugin \S+?MyPlugin2-0.1\/MyPlugin2.pl 0.1 is disabled/, "logged correctly";

    note 'MyPlugin3: directory/config.yaml, plugin.pl';

    ok !$switch->{'MyPlugin3-1.0.pl'}, "older version is listed in PluginSwitch but is 0";
    ok $switch->{'MyPlugin3-2.0'},  "newer version is listed in PluginSwitch";
    like $log => qr/Conflicted plugin \S+?MyPlugin3-1.0.pl 1.0 is disabled/, "logged correctly";
};

subtest 'Conflicts signature between plugins' => sub {
    note 'MyPlugin4: between plugin.pl';

    ok $switch->{'MyPlugin4.pl'}, "MyPlugin4 is listed in PluginSwitch";
    like $log => qr/plugins-A\/MyPlugin4.pl 0.1 is disabled/, "logged correctly";

    note 'MyPlugin5: between directory/plugin.pl';

    ok $switch->{'MyPlugin5/MyPlugin5.pl'}, "MyPlugin5 is listed in PluginSwitch";
    like $log => qr/plugins-A\/MyPlugin5\/MyPlugin5.pl 0.1 is disabled/, "logged correctly";

    note 'MyPlugin6: between directory/config.yaml';

    ok $switch->{'MyPlugin6'}, "MyPlugin6 is listed in PluginSwitch";
    like $log => qr/plugins-B\/MyPlugin6 1.0 is disabled/, "logged correctly";
};

done_testing;
