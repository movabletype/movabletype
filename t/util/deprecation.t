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
        PluginPath => [qw(TEST_ROOT/plugins)],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    MT::Test::Util::Plugin->write(
        'MyPlugin' => {
            'MyPlugin.pl' => {
                name     => 'MyPlugin',
                version  => '1.0',
                registry => {
                    applications => {
                        cms => {
                            methods => {
                                deprecated_method => {
                                    handler => '$MyPlugin::MyPlugin::deprecated_method',
                                },
                            },
                        },
                    },
                },
            },
            'lib/MyPlugin.pm' => {
                code => <<'CODE',
sub deprecated_method {
    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.0');
    return 1;
}
CODE
            },
        },
    );
}

use MT;
use MT::Test::App;

local $ENV{MT_TEST_WARN_DEPRECATION} = 1;

$test_env->prepare_fixture('db');

my $admin = MT::Author->load(1);
my $app   = MT::Test::App->new;
$app->login($admin);
$app->get_ok({
    __mode => 'deprecated_method',
});

my $log = $test_env->slurp_logfile;
like $log => qr/MyPlugin::deprecated_method is deprecated/, "has correct deprecation warning";

done_testing;

