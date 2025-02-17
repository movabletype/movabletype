use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => [ 'TEST_ROOT/plugins-1', 'TEST_ROOT/plugins-2' ],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

gen_plugin_file(
    'plugins-1', 'MyPlugin1', '0.1' );
gen_plugin_file(
    'plugins-2', 'MyPlugin1', '1.0' );

gen_plugin_dir_with_pl(
    'plugins-1', 'MyPlugin2', '0.1' );
gen_plugin_dir_with_pl(
    'plugins-2', 'MyPlugin2', '1.0' );

gen_plugin_dir_with_yaml(
    'plugins-1', 'MyPlugin3', '2.0' );
gen_plugin_dir_with_yaml(
    'plugins-2', 'MyPlugin3', '1.0' );

use MT;
ok eval { MT->instance }, "mt instance" or note $@;

my $switch = MT->config->PluginSwitch || {};
my $log = $test_env->slurp_logfile;

note 'MyPlugin1: Conflicts between plugin.pl';

ok $switch->{'MyPlugin1.pl'}, "MyPlugin1 is listed in PluginSwitch";
like $log => qr/plugins-1\/MyPlugin1.pl 0.1 is disabled/, "logged correctly";

note 'MyPlugin2: Conflicts between dirctory/plugin.pl';

ok $switch->{'MyPlugin2/MyPlugin2.pl'}, "MyPlugin2 is listed in PluginSwitch";
like $log => qr/plugins-1\/MyPlugin2\/MyPlugin2.pl 0.1 is disabled/, "logged correctly";

note 'MyPlugin3: Conflicts between dirctory/config.yaml';

ok $switch->{'MyPlugin3'}, "MyPlugin3 is listed in PluginSwitch";
like $log => qr/plugins-2\/MyPlugin3 1.0 is disabled/, "logged correctly";

done_testing;

sub gen_plugin_dir_with_pl {
    my ( $plugin_dir, $name, $version ) = @_;
    my $id = lc $name;
    $test_env->save_file("${plugin_dir}/${name}/${name}.pl", <<"PLUGIN" );
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
    my ( $plugin_dir, $name, $version ) = @_;
    my $id = lc $name;
    $test_env->save_file("${plugin_dir}/${name}/config.yaml", <<"YAML" );
id: $id
name: $name
version: $version
YAML
}

sub gen_plugin_file {
    my ( $plugin_dir, $name, $version ) = @_;
    my $id = lc $name;
    $test_env->save_file("${plugin_dir}/${name}.pl", <<"PLUGIN" );
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
