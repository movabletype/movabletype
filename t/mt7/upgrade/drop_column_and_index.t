use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

my $PluginDir;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => [qw(
            MT_HOME/plugins
            TEST_ROOT/plugins
        )],
    );
    $PluginDir = "plugins/SchemaMigrationTest";
    $test_env->save_file("$PluginDir/config.yaml", <<'YAML');
name: SchemaMigrationTest
id: SchemaMigrationTest
version: 1.00
schema_version: 1.00
object_types:
    test: SchemaMigrationTest
YAML

    $test_env->save_file("$PluginDir/lib/SchemaMigrationTest.pm", <<'PM');
package # hide from tools
    SchemaMigrationTest;
use strict;
use warnings;
use MT;
use MT::Object;
use base 'MT::Object';
__PACKAGE__->install_properties({
    column_defs => {
        id => 'integer not null auto_increment',
        text => {type => 'string', size => 80},
        memo => {type => 'string', size => 80},
    },
    indexes => {
        text => 1,
        memo => 1,
        multi => { columns => [qw/text memo/] },
    },
    datasource => 'test',
    primary_key => 'id',
});
1;
PM
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Upgrade;
use Class::Unload;

$test_env->prepare_fixture('db');

subtest 'Initial state' => sub {
    my $class = MT->model('test');
    my $ddl   = $class->driver->dbd->ddl_class;

    my $db_defs     = $ddl->column_defs($class);
    my $db_idx_defs = $ddl->index_defs($class);

    my $defs = $class->column_defs;
    ok exists $defs->{memo},    "memo column exists (class)";
    ok exists $db_defs->{memo}, "memo column exists (db)";

    my $idx_defs = $class->index_defs;
    ok exists $idx_defs->{memo},    "memo index exists (class)";
    ok exists $db_idx_defs->{memo}, "memo index exists (db)";

    ok exists $idx_defs->{multi},    "multi index exists (class)";
    ok exists $db_idx_defs->{multi}, "multi index exists (db)";
    # note explain $test_env->dbh->selectall_arrayref('desc mt_test');
    # note explain $test_env->dbh->selectall_arrayref('show index from mt_test');
};

subtest 'Upgrade' => sub {
    $test_env->save_file("$PluginDir/lib/SchemaMigrationTest.pm", <<'PM');
package # hide from tools
    SchemaMigrationTest;
use strict;
use warnings;
use MT;
use base 'MT::Object';
__PACKAGE__->install_properties({
    column_defs => {
        id => 'integer not null auto_increment',
        text => {type => 'string', size => 80},
    },
    indexes => {
        text => 1,
    },
    datasource => 'test',
    primary_key => 'id',
});
1;
PM

    Class::Unload->unload('SchemaMigrationTest');
    require SchemaMigrationTest;

    MT::Test::Upgrade->upgrade(from => 0.01, component => 'schemamigrationtest');

    my $class = MT->model('test');
    my $ddl   = $class->driver->dbd->ddl_class;

    my $db_defs     = $ddl->column_defs($class);
    my $db_idx_defs = $ddl->index_defs($class);

    my $defs = $class->column_defs;
    ok !exists $defs->{memo},    "memo column is gone (class)";
    ok !exists $db_defs->{memo}, "memo column is gone (db)";

    my $idx_defs = $class->index_defs;
    ok !exists $idx_defs->{memo},    "memo index is gone (class)";
    ok !exists $db_idx_defs->{memo}, "memo index is gone (db)";

    ok !exists $idx_defs->{multi},    "multi index is gone (class)";
    ok !exists $db_idx_defs->{multi}, "multi index is gone (db)";
    # note explain $test_env->dbh->selectall_arrayref('desc mt_test');
    # note explain $test_env->dbh->selectall_arrayref('show index from mt_test');
};

done_testing;
