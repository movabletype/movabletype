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
        PluginPath => ['TEST_ROOT/broken_plugins', 'TEST_ROOT/plugins'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    MT::Test::Util::Plugin->write(
        plugin_root => 'broken_plugins',
        Broken => {
            'Broken.pl' => {
                code => 'die "BROKEN!";',
            }
        },
    );

    MT::Test::Util::Plugin->write(
        plugin_root => 'plugins',
        MyPlugin => {
            'MyPlugin.pl' => {
                version => '1.0',
                registry => {
                    object_types => {
                        entry => {
                            my_plugin_meta_column => 'integer',
                        },
                    },
                },
            }
        },
    );
}

use MT;

{
    local $SIG{__DIE__} = sub {};
    ok eval { MT->instance }, "mt instance" or note $@;
}

$test_env->prepare_fixture('db');

my $entry = MT->model('entry')->new;
ok $entry->can('my_plugin_meta_column'), "entry has a meta column from my plugin";

my $config = MT->config->stringify_config;

unlike $config => qr!PluginSwitch Broken/Broken.pl=1!, "Broken plugin is not listed in PluginSwitch";

note "first rpt";
run_rpt();    # may or may not have a plugin error

note "second rpt";
unlike run_rpt() => qr/Plugin error/, "no plugin error";

done_testing;

sub run_rpt {
    MT::Session->remove( { kind => 'PT' } );
    my $res = `perl -It/lib ./tools/run-periodic-tasks --verbose 2>&1`;
    note $res;
    $res;
}
