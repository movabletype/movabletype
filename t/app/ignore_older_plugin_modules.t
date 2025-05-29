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
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

for my $version ( '0.1', '1.0' ) {
    my $plugin_dir = "MyPlugin1-$version";
    gen_plugin_with_pl_and_module(
        $plugin_dir, 'my_plugin1', 'MyPlugin1', $version );
    gen_plugin_pl_file(
        $plugin_dir, 'my_plugin2', 'MyPlugin2', $version );
}

for my $version ( '1.0', '2.0' ) {
    my $plugin_dir = "MyPlugin3-$version";
    gen_plugin_with_yaml_and_module(
        $plugin_dir, 'my_plugin3', 'MyPlugin3', $version );
}

$test_env->prepare_fixture('db');

use MT;
use MT::PSGI;
use MT::Test;
ok eval { MT->instance }, "mt instance" or note $@;
my $log = $test_env->slurp_logfile;
my $switch = MT->config->PluginSwitch || {};

subtest 'Duplicate plugins contains pl file and module' => sub {
    ok !$switch->{'MyPlugin1-0.1/MyPlugin1.pl'}, "older version is listed in PluginSwitch but is 0";
    ok $switch->{'MyPlugin1-1.0/MyPlugin1.pl'},  "newer version is listed in PluginSwitch";

    require MyPlugin1::Tags;
    my $func_result = MyPlugin1::Tags::_hdlr_hello_world();
    like $func_result => qr/1.0/, "included newer module";

    my $older_module_path = $test_env->path( 'plugins/MyPlugin1-0.1/lib' );
    cmp_deeply(
        \@INC,
        noneof( $older_module_path ),
        "not included older module"
    ) or note explain \@INC;

    # 2 plugins in directory, but @INC should only contain one module path.
    my $newer_module_path = $test_env->path( 'plugins/MyPlugin1-1.0/lib' );
    is scalar(grep { $_ eq $newer_module_path } @INC), 1, "module included not repeatly";

    like $log => qr/Conflicted plugin MyPlugin1 0.1 is disabled/, "logged correctly for MyPlugin1";
    like $log => qr/Conflicted plugin MyPlugin2 0.1 is disabled/, "logged correctly for MyPlugin2";
};

subtest 'Duplicate plugins contains config.yaml and module' => sub {
    ok !$switch->{'MyPlugin3-1.0'}, "older version is listed in PluginSwitch but is 0";
    ok $switch->{'MyPlugin3-2.0'},  "newer version is listed in PluginSwitch";

    require MyPlugin3::Tags;
    my $func_result = MyPlugin3::Tags::_hdlr_hello_world();
    like $func_result => qr/2.0/, "included newer module";

    my $older_module_path = $test_env->path( 'plugins/MyPlugin3-1.0/lib' );
    cmp_deeply(
        \@INC,
        noneof( $older_module_path ),
        "not included older module"
    ) or note explain \@INC;

    like $log => qr/Conflicted plugin MyPlugin3 1.0 is disabled/, "logged correctly for MyPlugin3";
};

ok eval { MT::PSGI->new->to_app }, "psgi app without an error" or note $@;

subtest 'run rpt' => sub {
    note "first rpt";
    run_rpt();    # may or may not have a plugin error

    note "second rpt";
    my $run_rpt_res = run_rpt();
    unlike $run_rpt_res => qr/Conflicted plugin MyPlugin1 0.1 is disabled/, "no plugin error";
    unlike $run_rpt_res => qr/Conflicted plugin MyPlugin2 0.1 is disabled/, "no plugin error";
    unlike $run_rpt_res => qr/Conflicted plugin MyPlugin3 1.0 is disabled/, "no plugin error";
};

done_testing;

sub run_rpt {
    MT::Session->remove( { kind => 'PT' } );
    my $res = `perl -It/lib ./tools/run-periodic-tasks --verbose 2>&1`;
    note $res;
    $res;
}

sub gen_plugin_with_pl_and_module {
    my ( $dir, $id, $name, $version ) = @_;
    $test_env->save_file("plugins/$dir/$name.pl", <<"PLUGIN" );
package $name;
our \$VERSION = '$version';
require MT;
require MT::Plugin;
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

    $test_env->save_file("plugins/$dir/lib/$name/Tags.pm", <<"PERL_MODULE");
package ${name}::Tags;
use strict;

sub _hdlr_hello_world {
    my (\$ctx, \$args) = \@_;
    return 'hello world ($version)';
}

1;
PERL_MODULE
}

sub gen_plugin_pl_file {
    my ( $dir, $id, $name, $version ) = @_;
    $test_env->save_file("plugins/$dir/$name.pl", <<"PLUGIN" );
package $name;
our \$VERSION = '$version';
require MT;
require MT::Plugin;
my \$plugin = MT::Plugin->new({
    id => '$id',
    name => '$name',
    version => \$VERSION,
    registry => {
        tags => {
            function => {
                HelloWorld => sub { return 'hello world ($version)'; }
            },
        },
    },
});
MT->add_plugin(\$plugin);
1;
PLUGIN
}

sub gen_plugin_with_yaml_and_module {
    my ( $dir, $id, $name, $version ) = @_;
    $test_env->save_file("plugins/$dir/config.yaml", <<"YAML" );
id: $id
name: $name
version: $version
tags:
    function:
        HelloWorld: \$${name}::${name}::Tags::_hdlr_hello_world
YAML

    $test_env->save_file("plugins/$dir/lib/$name/Tags.pm", <<"PERL_MODULE");
package ${name}::Tags;
use strict;

sub _hdlr_hello_world {
    my (\$ctx, \$args) = \@_;
    return 'hello world ($version)';
}

1;
PERL_MODULE
}
