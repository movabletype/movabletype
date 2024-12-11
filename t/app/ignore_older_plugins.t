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
        tags => {
            function => {
                HelloWorld => MyPlugin::Tags::_hdlr_hello_world
            },
        },
    },
});
MT->add_plugin(\$plugin);
PLUGIN

        $test_env->save_file("plugins/MyPlugin${version}/lib/MyPlugin/Tags.pm", <<"PERL_MODULE" );
package MyPlugin::Tags;
use strict;

sub _hdlr_hello_world {
    my (\$ctx, \$args) = \@_;
    return 'hello world ($version)';
}

1;
PERL_MODULE
    }
}

use MT;
use MT::Test;
use MT::PSGI;
use MT::Test::Tag;

ok eval { MT->instance }, "mt instance" or note $@;

my $switch = MT->config->PluginSwitch || {};

ok !$switch->{'MyPlugin0.1/MyPlugin.pl'}, "older version is listed in PluginSwitch but is 0";
ok $switch->{'MyPlugin1.0/MyPlugin.pl'},  "newer version is listed in PluginSwitch";

use_ok 'MyPlugin::Tags';
ok scalar(grep { $_ =~ /MyPlugin1\.0/ } @INC) == 1, "included new module";
ok scalar(grep { $_ =~ /MyPlugin0\.1/ } @INC) == 0, "no included older module";

ok eval { MT::PSGI->new->to_app }, "psgi app without an error" or note $@;

my $log = $test_env->slurp_logfile;
like $log => qr/Conflicted plugin MyPlugin 0.1 is disabled/, "logged correctly";

my $app = MT->instance;
my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    my $mt = MT->instance;

    {
        my $b = $mt->model('blog')->new;
        $b->set_values({
            id => 1,
        });
        $b->save or die $b->errstr;
    }
});

note "first rpt";
run_rpt();    # may or may not have a plugin error

note "second rpt";
unlike run_rpt() => qr/Conflicted plugin MyPlugin 1 is disabled/, "no plugin error";

MT::Test::Tag->run_perl_tests($blog_id);

done_testing;

sub run_rpt {
    MT::Session->remove( { kind => 'PT' } );
    my $res = `perl -It/lib ./tools/run-periodic-tasks --verbose 2>&1`;
    note $res;
    $res;
}

__END__

=== return from newer module
--- template
<MTHelloWorld>
--- expected
hello world (1.0)
