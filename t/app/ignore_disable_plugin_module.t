use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use Test::Deep qw(cmp_deeply noneof);
use MT::Test::Env;

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => ['TEST_ROOT/plugins'],
        PluginSwitch => [
            'MyPlugin2/MyPlugin.pl=0',
            'MyPlugin3/MyPluginA.pl=0',
            'MyPlugin5/MyPluginA.pl=0',
            'MyPlugin5/MyPluginB.pl=0',
            'MyPlugin7=0',
            'MyPlugin9-0.1/MyPlugin9.pl=0'
        ],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

gen_plugin_using_module(
    'MyPlugin1', '0.1', 'MyPlugin1', 'MyPlugin.pl' );
gen_plugin_using_module(
    'MyPlugin2', '0.2', 'MyPlugin2', 'MyPlugin.pl' );

# The folder contains two plugin files
gen_plugin_using_module(
    'MyPlugin3', '0.1', 'MyPlugin3', 'MyPluginA.pl' );
gen_dir_with_pl(
    'MyPlugin4', '0.2', 'MyPlugin3', 'MyPluginB.pl' );

# The folder contains two plugin files
gen_plugin_using_module(
    'MyPlugin5', '0.1', 'MyPlugin5', 'MyPluginA.pl' );
gen_dir_with_pl(
    'MyPlugin6', '0.2', 'MyPlugin5', 'MyPluginB.pl' );

gen_dir_with_yaml(
    'MyPlugin7', '0.1', 'MyPlugin7' );
gen_dir_with_yaml(
    'MyPlugin8', '0.2', 'MyPlugin8' );


gen_plugin_using_module(
    'MyPlugin9', '0.1', 'MyPlugin9-0.1', 'MyPlugin9.pl' );
gen_plugin_using_module(
    'MyPlugin9', '0.2', 'MyPlugin9-0.2', 'MyPlugin9.pl' );

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
    'MyPlugin7',
    'MyPlugin9-0.1'
);
cmp_deeply(
    \@disabled_module_paths,
    noneof(@INC),
    "not included disabled modules"
) or note explain \@INC;

# 'use MyPlugin9::Tags;' is already executed
my $func_result = MyPlugin9::Tags::_hdlr_hello_world();
like $func_result => qr/0.2/, "the plugin using module is executable.";

done_testing;

sub gen_dir_with_pl {
    my ( $name, $version, $dir, $pl_file ) = @_;
    my $id = lc $name;
    $test_env->save_file("plugins/${dir}/${pl_file}", <<"PLUGIN");
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

sub gen_dir_with_yaml {
    my ( $name, $version, $dir ) = @_;
    my $id = lc $name;
    $test_env->save_file("plugins/${dir}/config.yaml", <<"YAML");
id: $id
name: $name
version: $version
YAML

    $test_env->save_file("plugins/${dir}/lib/${name}/Tags.pm", <<"PERL_MODULE");
package ${name}::Tags;
use strict;
our \$VERSION = '$version';

1;
PERL_MODULE
}

sub gen_pl {
    my ( $name, $version, $pl_file ) = @_;
    my $id = lc $name;
    $test_env->save_file("plugins/${pl_file}", <<"PLUGIN");
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

sub gen_plugin_using_module {
    my ( $name, $version, $dir, $pl_file ) = @_;
    my $id = lc $name;
    $test_env->save_file("plugins/${dir}/${pl_file}", <<"PLUGIN");
package $name;
our \$VERSION = '$version';
require MT;
require MT::Plugin;
use ${name}::Tags;
my \$plugin = MT::Plugin->new({
    id => '$id',
    name => '$name',
    version => \$VERSION,
    registry => {
        tags => {
            function => {
                HelloWorld => ${name}::Tags::_hdlr_hello_world
            },
        },
    },
});
MT->add_plugin(\$plugin);
1;
PLUGIN

    $test_env->save_file("plugins/${dir}/lib/${name}/Tags.pm", <<"PERL_MODULE");
package ${name}::Tags;
use strict;

sub _hdlr_hello_world {
    my (\$ctx, \$args) = \@_;
    return 'hello world ($version)';
}

1;
PERL_MODULE
}
