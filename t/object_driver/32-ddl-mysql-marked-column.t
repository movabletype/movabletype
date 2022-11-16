use strict;
use warnings;
use version;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;

use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;

    plan skip_all => 'for MySQL only' unless $test_env->driver eq 'mysql';
}

use MT::Test;

my $dbh = $test_env->dbh;

skip_unless_mariadb_version_is_greater_than('10.5.1');

sub skip_unless_mariadb_version_is_greater_than {
    my ($version) = @_;

    plan skip_all => "Requires MariaDB $version or later"
        unless check_mariadb_vesion($version);
}

sub check_mariadb_vesion {
    my ($version) = @_;

    return if lc $test_env->driver ne 'mysql';

    my $db_version = $dbh->selectrow_hashref('SELECT VERSION() VERSION')->{VERSION};
    $db_version =~ m/^([0-9]+\.[0-9]+\.[0-9]+)-MariaDB/
        or return;    # not MariaDB

    version->parse("v$1") >= version->parse("v$version");
}

# https://mariadb.com/kb/en/datetime/#internal-format
eval { $dbh->do("SET GLOBAL mysql56_temporal_format=OFF") }
    or plan skip_all => "Requires SUPER privilege for DB connection";
MT::Test->init_db;

my $created_on_column = $dbh->selectrow_hashref(
    'SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = ?',
    undef, 'entry_created_on'
);
is $created_on_column->{COLUMN_TYPE}, 'datetime /* mariadb-5.3 */',
    'Installation succeeded even if the type definition contains old temporal format mark';

done_testing;
