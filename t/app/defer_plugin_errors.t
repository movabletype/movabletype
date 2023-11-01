use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => ['TEST_ROOT/broken_plugins', 'TEST_ROOT/plugins'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file("broken_plugins/Broken/Broken.pl", <<"PLUGIN" );
package Broken;
die "BROKEN!";
1;
PLUGIN

   $test_env->save_file("plugins/MyPlugin/MyPlugin.pl", <<"PLUGIN" );
package MyPlugin;
our \$VERSION = '1.0';
require MT;
require MT::Plugin;
my \$plugin = MT::Plugin->new({
    id => 'my_plugin',
    name => 'MyPlugin',
    version => \$VERSION,
    registry => {
        object_types => {
            entry => {
                my_plugin_meta_column => 'integer',
            },
        },
    },
});
MT->add_plugin(\$plugin);

1;
PLUGIN
}

use MT;

{
    local $SIG{__DIE__} = sub {};
    ok eval { MT->instance }, "mt instance" or note $@;
}

my $entry = MT->model('entry')->new;
ok $entry->can('my_plugin_meta_column'), "entry has a meta column from my plugin";

done_testing;
