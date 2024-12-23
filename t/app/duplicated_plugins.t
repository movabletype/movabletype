use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use Test::Deep qw(cmp_deeply supersetof noneof);
use MT::Test::Env;

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => ['TEST_ROOT/plugins'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
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
        tags => {
            function => {
                HelloWorld => MyPlugin::Tags::_hdlr_hello_world
            },
        },
    },
});
MT->add_plugin(\$plugin);
PLUGIN

        $test_env->save_file("plugins/MyPlugin${version}/lib/MyPlugin/Tags.pm", <<"PERL_MODULE");
package MyPlugin::Tags;
use strict;

sub _hdlr_hello_world {
    my (\$ctx, \$args) = \@_;
    return 'hello world ($version)';
}

1;
PERL_MODULE

        $test_env->save_file("plugins/MyPlugin$version/MyPlugin2.pl", <<"PLUGIN" );
package MyPlugin;
our \$VERSION = '$version';
require MT;
require MT::Plugin;
my \$plugin = MT::Plugin->new({
    id => 'my_plugin2',
    name => 'MyPlugin2',
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
PLUGIN
    }
}

use MT;
use MT::Test;
use MT::PSGI;

ok eval { MT->instance }, "mt instance" or note $@;

my $switch = MT->config->PluginSwitch || {};

ok !$switch->{'MyPlugin0.1/MyPlugin.pl'}, "older version is listed in PluginSwitch but is 0";
ok $switch->{'MyPlugin1.0/MyPlugin.pl'},  "newer version is listed in PluginSwitch";

use_ok 'MyPlugin::Tags'; # MyPlugin::Tags is no error

my $older_module_path = $test_env->path( 'plugins/MyPlugin0.1/lib' );
cmp_deeply(
    \@INC,
    noneof(
        map { $test_env->path($_) } (
            'plugins/MyPlugin0.1/lib',
        ),
    ),
    "not included older module"
) or note explain \@INC;

my $newer_module_path = $test_env->path( 'plugins/MyPlugin1.0/lib' );
cmp_deeply(
    \@INC,
    supersetof( $newer_module_path ),
    "included newer module"
) or note explain \@INC;

is scalar(grep { $_ eq $newer_module_path } @INC), 1, "module included not repeatly";

ok eval { MT::PSGI->new->to_app }, "psgi app without an error" or note $@;

my $log = $test_env->slurp_logfile;
like $log => qr/Conflicted plugin MyPlugin 0.1 is disabled/, "logged correctly";

$test_env->prepare_fixture('db');

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
