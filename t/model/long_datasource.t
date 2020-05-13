use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => [qw(
            MT_HOME/plugins
            MT_HOME/t/plugins
            TEST_ROOT/plugins
        )]
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    my $config_yaml = 'plugins/TestLongDataSource/config.yaml';
    $test_env->save_file( $config_yaml, <<'YAML' );
id: test
key: test
name: TestLongDatasource
version: 2
author: test

object_types:
    entry:
        source_entry_id: 'integer meta'
        complete: 'integer meta'
    content_data:
        source_cd_id: 'integer meta'
    cd:
        complete: 'integer meta'
YAML
}

$test_env->prepare_fixture('archive_type');

subtest 'entry meta' => sub {
    my $e = MT->model('entry')->load();

    eval {
        $e->source_entry_id(1);
        $e->complete(1);
        $e->save;
    };
    ok !$@, "set meta";
    note $@ if $@;

    for my $method ( qw/ source_entry_id complete / ) {
        my $got = eval { $e->$method };
        ok !$@, "got $method: " . ( $got || 'UNDEF' );
        note $@ if $@;

        my $got_by_meta = eval { $e->meta($method) };
        ok !$@, "got meta('$method'): " . ( $got_by_meta || 'UNDEF' );
        note $@ if $@;
    }
};

subtest 'content_data meta' => sub {
    my $cd = MT->model('content_data')->load();

    eval {
        $cd->source_cd_id(1);
        $cd->complete(1);
        $cd->save;
    };
    ok !$@, "set meta";
    note $@ if $@;

    for my $method ( qw/ source_cd_id complete / ) {
        my $got = eval { $cd->$method };
        ok !$@, "got $method: " . ( $got || 'UNDEF' );
        note $@ if $@;

        my $got_by_meta = eval { $cd->meta($method) };
        ok !$@, "got meta('$method'): " . ( $got_by_meta || 'UNDEF' );
        note $@ if $@;
    }
};

done_testing;
