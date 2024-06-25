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
    my $plugin_dir = File::Spec->catdir($test_env->root, "plugins");
    for my $version ('0.1', '1.0') {
        $test_env->save_file("plugins/MyPlugin$version/MyPlugin.pl", <<"PLUGIN" );
package MyPlugin;
our \$VERSION = '$version';
require MT;
require MT::Plugin;
my \$plugin = MT::Plugin->new({
    id => 'my_plugin',
    name => 'MyPlugin',
    version => \$VERSION,
    registry => {
        applications => {
            my_plugin => {
                handler => sub { return },
                script  => sub { return "my_plugin.cgi" },
                cgi_path => sub {
                    my \$path = MT->config->CGIPath;
                    \$path =~ s!/\$!!;
                    \$path =~ s!^https?://[^/]*!!;
                    \$path .= '/plugins/MyPlugin';
                    return \$path;
                },
            },
        },
    },
});
MT->add_plugin(\$plugin);
PLUGIN
    }
}

use MT;
use MT::Test;
use MT::PSGI;

$test_env->prepare_fixture('db');

ok eval { MT->instance }, "mt instance" or note $@;

my $switch = MT->config->PluginSwitch || {};

ok !exists $switch->{'MyPlugin0.1/MyPlugin.pl'}, "older version is not listed in PluginSwitch";
ok $switch->{'MyPlugin1.0/MyPlugin.pl'},         "newer version is listed in PluginSwitch";

ok eval { MT::PSGI->new->to_app }, "psgi app without an error" or note $@;

my $log = $test_env->slurp_logfile;
like $log => qr/Conflicted plugin MyPlugin 0.1 is disabled/, "logged correctly";

note "first rpt";
run_rpt();    # may or may not have a plugin error

note "second rpt";
unlike run_rpt() => qr/Conflicted plugin MyPlugin 0.1 is disabled/, "no plugin error";

done_testing;

sub run_rpt {
    MT::Session->remove( { kind => 'PT' } );
    my $res = `perl -It/lib ./tools/run-periodic-tasks --verbose 2>&1`;
    note $res;
    $res;
}
