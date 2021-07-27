use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        ThemesDirectory => 'TEST_ROOT/themes',
        PluginPath => [qw(
            MT_HOME/plugins
            MT_HOME/t/plugins
            TEST_ROOT/plugins
        )],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file('themes/ThemeTest/theme.yaml', <<'YAML');
id: ThemeTest
name: Theme Test
required_components:
  core: 1.0b
  ThemeTestPlugin: 2.40
optional_components:
  core: 2.0b
  ThemeTestPlugin: 2.40a2
YAML

    $test_env->save_file('plugins/ThemeTestPlugin/config.yaml', <<'YAML');
id: ThemeTestPlugin
key: ThemeTestPlugin
name: ThemeTestPlugin
version: 2.40b1
author: test
YAML
}

use MT;
use MT::Test;
use MT::Theme;

$test_env->prepare_fixture('db');

MT->instance;

my $theme = MT::Theme->load('ThemeTest');

my ( $errors, $warnings ) = $theme->validate_versions;
ok( !scalar @$errors ) or note explain [map {$_->()} @{$errors || []}];
ok( !scalar @$warnings ) or note explain [map {$_->()} @{$warnings || []}];

done_testing;
