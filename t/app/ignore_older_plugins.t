use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => ['TEST_ROOT/plugins'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

gen_plugin_dir_with_pl(
    'my_plugin1', 'MyPlugin1', '0.1' );
gen_plugin_dir_with_yaml(
    'my_plugin1', 'MyPlugin1', '1.0' );

gen_plugin_dir_with_pl(
    'my_plugin2', 'MyPlugin2', '0.1' );
gen_plugin_file(
    'my_plugin2', 'MyPlugin2', '1.0' );

gen_plugin_dir_with_yaml(
    'my_plugin3', 'MyPlugin3', '2.0' );
gen_plugin_file(
    'my_plugin3', 'MyPlugin3', '1.0' );

$test_env->prepare_fixture('db');

use MT;
ok eval { MT->instance }, "mt instance" or note $@;

my $switch = MT->config->PluginSwitch || {};
my $log = $test_env->slurp_logfile;

note 'MyPlugin1: dirctory/plugin.pl, dirctory/config.yaml';

ok !$switch->{'MyPlugin1-0.1/MyPlugin.pl'}, "older version is listed in PluginSwitch but is 0";
ok $switch->{'MyPlugin1-1.0'},  "newer version is listed in PluginSwitch";
like $log => qr/Conflicted plugin MyPlugin1 0.1 is disabled/, "logged correctly";

note 'MyPlugin2: dirctory/plugin.pl, plugin.pl';

ok !$switch->{'MyPlugin2-0.1/MyPlugin.pl'}, "older version is listed in PluginSwitch but is 0";
ok $switch->{'MyPlugin2-1.0.pl'},  "newer version is listed in PluginSwitch";
like $log => qr/Conflicted plugin MyPlugin2 0.1 is disabled/, "logged correctly";

note 'MyPlugin3: dirctory/config.yaml, plugin.pl';

ok !$switch->{'MyPlugin3-1.0.pl'}, "older version is listed in PluginSwitch but is 0";
ok $switch->{'MyPlugin3-2.0'},  "newer version is listed in PluginSwitch";
like $log => qr/Conflicted plugin MyPlugin3 1.0 is disabled/, "logged correctly";

done_testing;

sub gen_plugin_dir_with_pl {
    my ( $id, $name, $version ) = @_;
    $test_env->save_file("plugins/$name-$version/$name.pl", <<"PLUGIN" );
package $name;
our \$VERSION = '$version';
require MT;
require MT::Plugin;
my \$plugin = MT::Plugin->new({
    id => '$id',
    name => '$name',
    version => \$VERSION,
});
MT->add_plugin(\$plugin);
1;
PLUGIN
}

sub gen_plugin_dir_with_yaml {
    my ( $id, $name, $version ) = @_;
    $test_env->save_file("plugins/$name-$version/config.yaml", <<"YAML" );
id: $id
name: $name
version: $version
YAML
}

sub gen_plugin_file {
    my ( $id, $name, $version ) = @_;
    $test_env->save_file("plugins/$name-$version.pl", <<"PLUGIN" );
package $name;
our \$VERSION = '$version';
require MT;
require MT::Plugin;
my \$plugin = MT::Plugin->new({
    id => '$id',
    name => '$name',
    version => \$VERSION,
});
MT->add_plugin(\$plugin);
1;
PLUGIN
}
