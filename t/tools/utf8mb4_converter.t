use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use utf8;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->skip_unless_mysql_version_is_greater_than('5.7');
}

plan skip_all => "Already utf8mb4" if $test_env->mysql_db_charset eq 'utf8mb4';

$test_env->prepare_fixture('db_data');

use MT;
use MT::Test;
use IPC::Run3 qw/run3/;

sub run {
    my @opts = @_;

    my $home = $ENV{MT_HOME};

    my @cmd = (
        $^X, '-I', File::Spec->catdir( $test_env->root, 'lib' ),
        '-I',
        File::Spec->catdir( $home, 't/lib' ),
        File::Spec->catfile( $home, 'tools/utf8mb4_converter' ),
    );
    while ( my ( $key, $value ) = splice @opts, 0, 2 ) {
        push @cmd, "--$key", $value;
    }

    note "GOING TO RUN " . ( join " ", @cmd ) . "\n\n";

    run3 \@cmd, \my $stdin, \my $stdout, \my $stderr;
    return wantarray ? ( $stdout, $stderr ) : $stdout;
}

sub _connect_info {
    my %mapping = (
        DBHost    => 'host',
        DBSocket  => 'mysql_socket',
        DBUser    => 'user',
        DBPasword => 'pass',
        DBPort    => 'port',
        Database  => 'db',
    );
    my %info;
    for my $key ( keys %mapping ) {
        my $value = $test_env->config($key);
        $info{ $mapping{$key} } = $value if defined $value;
    }
    %info;
}

subtest 'convert from utf8' => sub {
    my %connect_info = _connect_info();
    my $db           = $connect_info{db};

    my ( $out, $err ) = run( %connect_info, verbose => 1 );
    ok $out =~ /Altered .* 'mt_test'/, "altered database"   or note $out;
    ok $out =~ /Altered 'mt_ts_job'/,  "altered last table" or note $out;
    $err =~ s/\s*WARNING: MYSQL_OPT_RECONNECT is deprecated and will be removed in a future version.\s*//s;
    ok !$err or note $err;

    my $dbh = $test_env->dbh;
    my ($charset) = $dbh->selectrow_array("SELECT \@\@character_set_database");
    is $charset => 'utf8mb4', "new charset is utf8mb4";

    my $tables = $dbh->selectcol_arrayref("SHOW TABLES FROM $db");
    for my $table (@$tables) {
        my ( undef, $create_table ) = $dbh->selectrow_array("SHOW CREATE TABLE $table");
        ok $create_table !~ /longtext/i, "$table has no long text";
        ok $create_table =~ /CHARSET=utf8mb4/i, "$table is utf8mb4" or note $create_table;
    }

    ok my $count = MT::Entry->count, "entries exist";
};

subtest 'ignore utf8mb4' => sub {
    my %connect_info = _connect_info();
    my $db           = $connect_info{db};

    my ( $out, $err ) = run( %connect_info, verbose => 1 );
    ok $err =~ /mt_test.*is already utf8mb4/, "mt_test is already utf8mb4";

    ok my $count = MT::Entry->count, "entries exist";
};

subtest 'force' => sub {
    my %connect_info = _connect_info();
    my $db           = $connect_info{db};

    my ( $out, $err ) = run( %connect_info, verbose => 1, force => 1 );

    ok $out =~ /character set is already utf8mb4, but/, "already utf8mb4, but we will convert";
    ok $out =~ /Altered .* 'mt_test'/, "altered database"   or note $out;
    ok $out =~ /Altered 'mt_ts_job'/,  "altered last table" or note $out;

    ok my $count = MT::Entry->count, "entries exist";
};

done_testing;
