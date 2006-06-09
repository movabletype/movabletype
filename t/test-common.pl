# $Id$

use vars qw( $BASE $DB_DIR $T_CFG $T_SCHEMA $T_SCHEMA_PG $T_SCHEMA_SQLITE $SQLITE_DB );

use Cwd;
use File::Spec;
my $pwd = cwd();
my @pieces = split /\//, $pwd;
if (-f 'test-common.pl') {
    pop @pieces;
}
elsif (-f 't/test-common.pl') {
}
$BASE = File::Spec->catdir(@pieces);
$DB_DIR = File::Spec->catdir($BASE, 't', 'db');
mkdir $DB_DIR if (!-d $DB_DIR);
$T_CFG = File::Spec->catdir($BASE, 't', 'mt.cfg');
$T_SCHEMA = File::Spec->catfile($BASE, 't', 't-schema.dump');
$T_SCHEMA_PG = File::Spec->catfile($BASE, 't', 't-schema-postgres.dump');
$T_SCHEMA_SQLITE = File::Spec->catfile($BASE, 't', 't-schema-sqlite.dump');
$SQLITE_DB = File::Spec->catfile($BASE, 't', 'mtdb');

1;
