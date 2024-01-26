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

    $test_env->save_file("plugins/MyPlugin/config.yaml", <<'YAML' );
id: MyPlugin
name: MyPlugin
version: 0.01

list_properties:
  entry:
    no_prop_id:
      label: no_prop_id
      html: no_prop_id
      order: 999
      base: something
    unknown_id:
      label: unknown_id
      html: unknown_id
      order: 999
      base: unknown.unknown
    no_column:
      label: no_column
      html: no_column
      order: 999
      auto: 1
      base: entry.title
  content_type:
    fields:
      label: fields
      html: fields
      order: 999
      auto: 1
YAML
}

use MT::Test;
use MT::Test::App;

$test_env->prepare_fixture('db');

my $admin = MT::Author->load(1);

subtest 'entry' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({
        __mode  => 'list',
        _type   => 'entry',
        blog_id => 1,
    });
    my @logs = $test_env->slurp_logfile;
    ok grep(/Object type and Property ID are required/, @logs), "no property id error is logged";
    ok grep(/Cannot find definition of column no_column/, @logs), "no column definition error is logged";
    ok grep(/Cannot initialize list property unknown.unknown/, @logs), "unknown property error is logged";
};

subtest 'content_type' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({
        __mode  => 'list',
        _type   => 'content_type',
        blog_id => 1,
    });
    my @logs = $test_env->slurp_logfile;
    ok grep(/unsupported column type/, @logs), "unsupported column type error is logged";
};

done_testing;
