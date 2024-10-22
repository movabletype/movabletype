package MT::Test::Env;

use strict;
use warnings;
use Carp;
use Carp::Always;
use Test::More;
use File::Spec;
use Cwd ();
use Fcntl qw/:flock/;
use File::Find ();
use File::Path 'mkpath';
use File::Temp 'tempdir';
use File::Basename qw/dirname basename/;
use DBI;
use Digest::MD5 'md5_hex';
use Digest::SHA;
use String::CamelCase qw/decamelize camelize/;
use Mock::MonkeyPatch;
use Sub::Name;
use Time::HiRes qw/time/;
use Module::Find qw/findsubmod/;
use Test::FailWarnings;

our $MT_HOME;

BEGIN {
    my $me = Cwd::realpath(__FILE__);
    $MT_HOME = dirname(dirname(dirname(dirname(dirname($me)))));
    $ENV{MT_HOME} = $MT_HOME;
}
use lib "$MT_HOME/lib", "$MT_HOME/extlib";
use lib grep -d $_, glob("$MT_HOME/addons/*/lib"),  glob("$MT_HOME/addons/*/extlib"), glob("$MT_HOME/addons/*/t/lib");
use lib grep -d $_, glob("$MT_HOME/plugins/*/lib"), glob("$MT_HOME/plugins/*/extlib");

use Term::Encoding qw(term_encoding);

my @extra_modules = do { local @Module::Find::ModuleDirs = grep {m!\bt[\\/]lib\b!} @INC; findsubmod 'MT::Test::Env'; };

my $enc = term_encoding() || 'utf8';

my $builder = Test::More->builder;
unless ($^O eq 'MSWin32') {
    binmode $builder->output,         ":encoding($enc)";
    binmode $builder->failure_output, ":encoding($enc)";
    binmode $builder->todo_output,    ":encoding($enc)";
}

sub new {
    my ($class, %extra_config) = @_;

    $class->load_envfile;

    my $template = "MT_TEST_" . $$ . "_XXXX";
    my $root     = tempdir($template, CLEANUP => 1, TMPDIR => 1);
    $root = Cwd::realpath($root);
    $ENV{MT_TEST_ROOT} = $root;
    $ENV{PERL_JSON_BACKEND} ||= 'JSON::PP';
    $ENV{MT_PROHIBIT_PHP_DYNAMIC_PROPERTY} = 1;

    my $driver = _driver();

    my $self = bless {
        root   => $root,
        driver => $driver,
        config => \%extra_config,
        start  => [Time::HiRes::gettimeofday],
    }, $class;

    for my $module (@extra_modules) {
        eval "require $module";
        my $new_hook = $module->can('_new');
        $new_hook->($self, \%extra_config) if $new_hook;
        my $prepare_hook = $module->can('_prepare_fixture');
        $self->{prepare_hooks}{$module} = $prepare_hook if $prepare_hook;
    }

    $self->write_config(\%extra_config);

    $self->enable_query_log if $ENV{MT_TEST_QUERY_LOG} && $ENV{MT_TEST_QUERY_LOG} > 4;

    {   # No need to update config at the (global) destruction of a test
        no warnings 'redefine';
        require MT::ConfigMgr;
        *MT::ConfigMgr::DESTROY = sub {};
    }

    diag "Driver: $driver" unless $driver =~ /mysql/i;

    $self;
}

sub load_envfile {
    my $class = shift;
    my $envfile = "$MT_HOME/.mt_test_env";
    $class->_load_envfile($envfile) if -f $envfile;
    my $driver = lc _driver();
    my $envfile_for_driver = "$MT_HOME/.mt_test_env_$driver";
    $class->_load_envfile($envfile_for_driver) if -f $envfile_for_driver;
}

sub _load_envfile {
    my ($class, $envfile) = @_;
    if (-f $envfile) {
        open my $fh, '<', $envfile or die $!;
        while (<$fh>) {
            chomp;
            next if /^(?:#|\s*$)/;
            s/(?:^\s*|\s*$)//g;
            my ($key, $value) = split /\s*=\s*/, $_, 2;
            $ENV{ uc $key } = $value;
        }
    }
}

sub config_file {
    my $self = shift;
    File::Spec->catfile($self->{root}, 'mt-config.cgi');
}

sub driver {
    my $self = shift;
    ref $self ? $self->{driver} : _driver();
}

sub _driver { $ENV{MT_TEST_BACKEND} || 'mysql' }

sub mt_home { $MT_HOME }

sub root {
    my $self = shift;
    $self->{root};
}

sub path {
    my ($self, @parts) = @_;
    File::Spec->catfile($self->{root}, @parts);
}

sub write_config {
    my ($self, $extra) = @_;

    my %connect_info = $self->connect_info;

    my $image_driver = $ENV{MT_TEST_IMAGE_DRIVER}
        || (eval { require Image::Magick } ? 'ImageMagick' : 'Imager');

    my $default_language = $ENV{MT_TEST_LANG} || 'en_US';

    require MT;

    # common directives
    my %config = (
        PluginPath => [qw(
            MT_HOME/plugins
            MT_HOME/t/plugins
        )],
        TemplatePath       => 'MT_HOME/tmpl',
        SearchTemplatePath => 'MT_HOME/search_templates',
        ThemesDirectory    => [qw(
            TEST_ROOT/themes/
            MT_HOME/t/themes/
            MT_HOME/themes/
        )],
        TempDir                => File::Spec->tmpdir,
        DefaultLanguage        => $default_language,
        StaticWebPath          => '/mt-static/',
        StaticFilePath         => 'TEST_ROOT/mt-static',
        EmailAddressMain       => 'mt@localhost.localdomain',
        WeblogTemplatesPath    => 'MT_HOME/default_templates',
        ImageDriver            => $image_driver,
        MTVersion              => MT->version_number,
        MTReleaseNumber        => MT->release_number,
        LoggerModule           => 'Test',
        LoggerPath             => 'TEST_ROOT/log',
        LoggerFileName         => 'TEST_ROOT/.test.log',
        LoggerLevel            => 'DEBUG',
        MailTransfer           => 'debug',
        MailTransferEncoding   => '8bit',
        DBIRaiseError          => 1,
        ShowIpInformation      => 1,
        EnableAddressBook      => 1,
        CaptchaSourceImageBase => 'MT_HOME/mt-static/images/captcha-source/',
        NewsboxURL             => 'disable',
        HideVersion            => 0,
        DebugMode              => $ENV{MT_TEST_DEBUG_MODE} || 0,
        BuilderModule          => $ENV{MT_TEST_BUILDER} || 'MT::Builder',
        DisableObjectCache     => $ENV{MT_TEST_DISABLE_OBJECT_CACHE} || 0,
        $ENV{MT_TEST_ADMIN_THEME_ID} ? (AdminThemeId => $ENV{MT_TEST_ADMIN_THEME_ID}) : (),
    );

    if ($extra) {
        for my $key (keys %$extra) {
            my $value = $extra->{$key};
            if (!defined $value and $config{$key}) {
                delete $config{$key};
            } elsif (ref $value eq 'ARRAY') {
                push @{ $config{$key} }, @$value;
            } elsif (ref $value eq 'HASH') {
                for my $k (sort keys %$value) {
                    push @{ $config{$key} }, "$k=$value->{$k}";
                }
            } else {
                $config{$key} = $extra->{$key};
            }
        }
    }
    # disable process check
    $config{ProcessMemoryCommand} = 0 unless $config{PerformanceLogging};

    if ($^O eq 'MSWin32' && $config{SendMailPath}) {
        plan skip_all => 'Sendmail is not supported on Win32';
    }

    $config{$_} = $connect_info{$_} for keys %connect_info;

    $self->{_config} = \%config;

    $self->_write_config;
}

sub config {
    my $self = shift;
    if (@_ == 1) {
        my $key = shift;
        return $self->{_config}{$key};
    }
    $self->{_config};
}

sub _write_config {
    my $self = shift;

    my $config = $self->{_config};
    my $root   = $self->{root};
    open my $fh, '>', $self->config_file or plan skip_all => $!;
    for my $key (sort keys %$config) {
        if (ref $config->{$key} eq 'ARRAY') {
            for my $value (@{ $config->{$key} }) {
                $value =~ s/\bMT_HOME\b/$MT_HOME/;
                $value =~ s/\bTEST_ROOT\b/$root/ and do {
                    mkpath($value) unless basename($value) =~ /\./;
                };
                print $fh "$key $value\n";
            }
        } else {
            my $value = $config->{$key};
            $value =~ s/\bMT_HOME\b/$MT_HOME/;
            $value =~ s/\bTEST_ROOT\b/$root/ and do {
                mkpath($value) unless basename($value) =~ /\./;
            };
            print $fh "$key $value\n";
        }
    }
    close $fh;
}

sub update_config {
    my ($self, %extra_config) = @_;
    for my $key (keys %extra_config) {
        $self->{_config}{$key} = $extra_config{$key};
        MT->config($key, $extra_config{$key});
        MT->config($key, $extra_config{$key}, 1);
    }
    MT->config->save_config;
    $self->_write_config;
}

sub save_file {
    my ($self, $path, $body) = @_;

    my $file = $self->path($path);
    my $dir  = dirname($file);
    mkpath $dir unless -d $dir;

    open my $fh, '>', $file or die "$file: $!";
    binmode $fh;
    print $fh $body;
    $file;
}

sub image_drivers {
    my $self = shift;
    map { my $tmp = basename($_); $tmp =~ s/\.pm$//; $tmp } glob "$MT_HOME/lib/MT/Image/*.pm";
}

sub suppress_deprecated_warnings {
    my $self = shift;
    if (!@_ or $_[0]) {
        my $sub = $self->{deprecation_handler} //= sub {};
        if (@_ && ref $_[0] eq 'CODE') {
            $sub = $_[0];
            $self->{deprecation_handler} = $sub;
        }
        require MT::Util::Deprecated;
        $self->{mocked_deprecation_handler} = Mock::MonkeyPatch->patch(
            'MT::Util::Deprecated::warning' => subname 'mocked_deprecation_handler' => $sub,
        );
    } elsif (@_ && !$_[0]) {
        delete $self->{mocked_deprecation_handler};
    }
}

sub cluck_errors {
    my $self = shift;
    if (!@_ or $_[0]) {
        my $sub = $self->{error_handler} //= sub {
            if ($_[1]) {
                note "If this error is expected, set \$test_env->cluck_errors to 0 hide: $_[1]";
                Carp::cluck $_[1];
            }
            Mock::MonkeyPatch::ORIGINAL(@_);
        };
        if (@_ && ref $_[0] eq 'CODE') {
            $sub = $_[0];
            $self->{error_handler} = $sub;
        }
        $self->{mocked_error_handler} = Mock::MonkeyPatch->patch(
            'MT::ErrorHandler::error' => subname 'mocked_error_handler' => $sub,
        );
    } elsif (@_ && !$_[0]) {
        delete $self->{mocked_error_handler};
    }
}

sub reset_cluck_errors {
    my $self = shift;
    return unless $self->{mocked_error_handler};
    delete $self->{mocked_error_handler}{original};
    require Class::Unload;
    Class::Unload->unload('MT::ErrorHandler');
    require MT::ErrorHandler;
    $self->{mocked_error_handler} = Mock::MonkeyPatch->patch(
        'MT::ErrorHandler::error' => subname 'mocked_error_handler' => $self->{error_handler},
    );
}

sub connect_info {
    my $self   = shift;
    my $driver = $self->{driver};
    my $method = '_connect_info_' . (lc $driver);
    my %connect_info;
    if ($self->can($method)) {
        %connect_info = $self->$method;
    } else {
        my @keys = qw(
            ObjectDriver Database DBPort DBHost DBSocket
            DBUser DBPassword ODBCDriver ODBCEncrypt
        );
        for my $key (@keys) {
            my $env_key = "MT_TEST_" . (uc $key);
            if ($ENV{$env_key}) {
                $connect_info{$key} = $ENV{$env_key};
            }
        }
        # TODO: $self->{dsn} = "dbi:$driver:...";
    }
    %connect_info;
}

sub _connect_info_mysql {
    my $self = shift;

    my %info = (
        ObjectDriver => "DBI::mysql",
        DBHost       => "127.0.0.1",
        DBUser       => "mt",
        Database     => "mt_test",
    );

    if (my $go_dsn = $ENV{GO_PROVE_MYSQLD}) {
        my ($sock) = $go_dsn =~ /unix\((.*?)\)/;
        $ENV{MT_TEST_DSN} = "dbi:mysql:mysql_socket=$sock;user=root";
    }
    if (my $dsn = $ENV{MT_TEST_DSN} || $ENV{PERL_TEST_MYSQLPOOL_DSN}) {
        my $dbh = DBI->connect($dsn) or die $DBI::errstr;
        $self->_prepare_mysql_database($dbh);
        $dsn =~ s/^DBI:mysql://i;
        my %opts = map { split '=', $_ } split ';', $dsn;
        $opts{dbname} = $info{Database};
        if ($opts{host}) {
            $info{DBHost} = $opts{host};
        }
        if ($opts{mysql_socket}) {
            delete $info{DBHost};
            $info{DBSocket} = $opts{mysql_socket};
        }
        if ($opts{user}) {
            $info{DBUser} = $opts{user};
        } elsif ($ENV{MT_TEST_MYSQLPOOL_DSN}) {
            $info{DBUser} = 'root';
        }
        if ($opts{port}) {
            $info{DBPort} = $opts{port};
        }
        if ($opts{password}) {
            $info{DBPassword} = $opts{password};
        }
        $self->{dsn} = "dbi:mysql:" . (join ";", map { "$_=$opts{$_}" } keys %opts);

        if ($ENV{TEST_VERBOSE}) {
            $self->show_mysql_db_variables;
        }
    } else {
        $self->{dsn} = "dbi:mysql:host=$info{DBHost};dbname=$info{Database};user=$info{DBUser}";
        my $dbh = do { local $SIG{__WARN__}; DBI->connect($self->{dsn}, undef, undef, { PrintError => 0 }) };
        if (!$dbh) {
            if ($DBI::errstr =~ /Connections using insecure transport are prohibited/) {
                $dbh = DBI->connect($self->{dsn}, undef, undef, {
                    mysql_ssl                    => 1,
                    mysql_ssl_verify_server_cert => 0,
                }) or die $DBI::errstr;
                $info{DBIConnectOptions} = {
                    mysql_ssl                    => 1,
                    mysql_ssl_verify_server_cert => 0,
                };
            } elsif ($DBI::errstr =~ /Unknown database/) {
                (my $dsn = $self->{dsn}) =~ s/dbname=$info{Database};//;
                $dbh = DBI->connect($dsn) or die $DBI::errstr;
            } else {
                die $DBI::errstr;
            }
        }
        $self->_prepare_mysql_database($dbh);
    }
    return %info;
}

sub _connect_info_pg {
    my $self = shift;

    my %info = (
        ObjectDriver => "DBI::Pg",
        DBHost       => "127.0.0.1",
        DBUser       => "mt",
        Database     => "mt_test",
    );

    require DBD::Pg;
    $info{DBIConnectOptions} = "pg_enable_utf8=0" if version->parse(DBD::Pg->VERSION) >= 3;

    if ($ENV{MT_TEST_USE_TEST_PG} && eval { require Test::PostgreSQL }) {
        my $pg = $self->{pg} = Test::PostgreSQL->new;
        my $dsn = $ENV{MT_TEST_DSN} = $pg->dsn;
        my $dbh = DBI->connect($dsn) or die $DBI::errstr;
        $self->_prepare_pg_database($dbh);
        $dsn =~ s/^DBI:Pg://i;
        my %opts = map { split '=', $_ } split ';', $dsn;
        $opts{dbname} = $info{Database};
        if ($opts{host}) {
            $info{DBHost} = $opts{host};
        }
        if ($opts{user}) {
            $info{DBUser} = $opts{user};
        }
        if ($opts{port}) {
            $info{DBPort} = $opts{port};
        }
        if ($opts{password}) {
            $info{DBPassword} = $opts{password};
        }
        $self->{dsn} = "dbi:Pg:" . (join ";", map { "$_=$opts{$_}" } keys %opts);
    } else {
        $self->{dsn} = "dbi:Pg:host=$info{DBHost};dbname=$info{Database};user=$info{DBUser}";
        my $dbh = DBI->connect($self->{dsn});
        if (!$dbh) {
            die $DBI::errstr unless $DBI::errstr =~ /Unknown database/;
            (my $dsn = $self->{dsn}) =~ s/dbname=$info{Database};//;
            $dbh = DBI->connect($dsn) or die $DBI::errstr;
        }
        $self->_prepare_pg_database($dbh);
    }
    return %info;
}

sub _connect_info_sqlite {
    my $self = shift;

    my $database = $self->path("mt.db");
    $self->{dsn} = "dbi:SQLite:$database";

    return (
        ObjectDriver => "DBI::sqlite",
        Database     => $database,
    );
}

sub _connect_info_oracle {
    my $self = shift;

    my %connect_info = (
        ObjectDriver => 'DBI::Oracle',
        DBPort       => 1521,
        DBUser       => 'system',
    );
    my @keys = qw(ObjectDriver Database DBPort DBHost DBSocket DBUser DBPassword);
    for my $key (@keys) {
        my $env_key = "MT_TEST_" . (uc $key);
        if ($ENV{$env_key}) {
            $connect_info{$key} = $ENV{$env_key};
        }
    }
    note "DRIVER: Oracle";

    # for better compatibility
    $ENV{NLS_LANG}  = $ENV{MT_TEST_NLS_LANG}  || 'AMERICAN_AMERICA.AL32UTF8';
    $ENV{NLS_NCHAR} = $ENV{MT_TEST_NLS_NCHAR} || 'AL32UTF8';
    $ENV{NLS_COMP}  = $ENV{MT_TEST_NLS_COMP}  || 'LINGUISTIC';
    $ENV{NLS_SORT}  = $ENV{MT_TEST_NLS_SORT}  || 'AMERICAN_AMERICA';

    my $dsn = sprintf('dbi:Oracle:host=%s;sid=%s;port=%s',
        $connect_info{DBHost}, $connect_info{Database}, $connect_info{DBPort});
    my $dbh = DBI->connect($dsn, $connect_info{DBUser}, $connect_info{DBPassword});
    $self->_oracle_increase_open_cursors($dbh);

    %connect_info;
}

sub skip_unless_mysql_supports_utf8mb4 {
    my $self       = shift;
    my $db_charset = $self->mysql_db_charset // '';
    if ($db_charset ne 'utf8mb4') {
        plan skip_all => "Requires utf8mb4 database: $db_charset";
    }
    my $client_charset = $self->mysql_client_charset;
    if ($client_charset ne 'utf8mb4') {
        plan skip_all => "Requires utf8mb4 client: $client_charset";
    }
}

sub show_mysql_db_variables {
    my $self = shift;
    return unless $self->driver eq 'mysql';

    my $dbh = $self->dbh;
    for my $name ('character_set%', 'collation%', 'innodb_file_format') {
        my $rows = $dbh->selectall_arrayref("SHOW VARIABLES LIKE '$name'");
        Test::More::note join ': ', @$_ for @$rows;
    }
}

sub _oracle_increase_open_cursors {
    my ($self, $dbh) = @_;
    return unless $self->driver eq 'oracle';
    $dbh->do('ALTER SYSTEM SET OPEN_CURSORS = 1000 SCOPE=BOTH') or die $dbh->errstr;
}

sub mysql_session_variable {
    my ($self, $name) = @_;
    return unless $self->driver eq 'mysql';

    my $dbh = MT::Object->driver->rw_handle;
    my $sql = "SHOW SESSION VARIABLES LIKE '$name'";
    my $res = $dbh->selectall_arrayref($sql, { Slice => +{} });
    return $res->[0]{Value} // '';
}

sub mysql_db_charset {
    my $self = shift;
    $self->mysql_session_variable('character_set_database');
}

sub mysql_client_charset {
    my $self = shift;
    $self->mysql_session_variable('character_set_client');
}

sub mysql_charset {
    my $self = shift;
    return '' unless $self->driver eq 'mysql';
    return $ENV{MT_TEST_MYSQL_CHARSET} || 'utf8';
}

sub mysql_collation {
    my $self = shift;
    return '' unless $self->driver eq 'mysql';

    ## -5.7:     utf8mb4_general_ci (sushi-beer)
    ## 8.0-:     utf8mb4_9000_ai_ci (haha-papa/byoin-biyoin)
    ## stricter: utf8mb4_9000_as_cs
    ## stricter: utf8mb4_bin
    my $collation = $ENV{MT_TEST_MYSQL_COLLATION} || 'utf8_general_ci';
    if ($self->mysql_charset eq 'utf8mb4' and $collation =~ /^utf8_/) {
        $collation =~ s/^utf8_/utf8mb4_/;
    }
    return $collation;
}

sub _prepare_mysql_database {
    my ($self, $dbh) = @_;
    local $dbh->{RaiseError}         = 1;
    local $dbh->{ShowErrorStatement} = 1;
    my $character_set = $self->mysql_charset;
    my $collation     = $self->mysql_collation;
    my $sql           = <<"END_OF_SQL";
DROP DATABASE IF EXISTS mt_test;
CREATE DATABASE mt_test CHARACTER SET $character_set COLLATE $collation;
END_OF_SQL

    my ($major_version, $minor_version, $is_maria, $maria_major, $maria_minor) = _mysql_version();
    if ($ENV{MT_TEST_MYSQLPOOL_DSN} && $is_maria && $maria_major == 10 && $maria_minor > 3) {
        $sql .= <<"END_OF_SQL";
ALTER USER root\@localhost IDENTIFIED VIA mysql_native_password USING PASSWORD('');
END_OF_SQL
    }

    for my $statement (split ";\n", $sql) {
        $dbh->do($statement);
    }
}

sub _prepare_pg_database {
    my ($self, $dbh) = @_;
    local $dbh->{RaiseError}         = 1;
    local $dbh->{PrintWarn}          = 0;
    local $dbh->{ShowErrorStatement} = 1;
    my $sql           = <<"END_OF_SQL";
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
END_OF_SQL
    for my $statement (split ";\n", $sql) {
        $dbh->do($statement);
    }
}

# for App::Prove::Plugin::MySQLPool
sub prepare {
    my ($class, $mysqld) = @_;
    my $dsn = $ENV{MT_TEST_MYSQLPOOL_DSN} = $mysqld->dsn;
    my $dbh = DBI->connect($dsn);
    $class->_prepare_mysql_database($dbh);
}

sub _mysql_version {
    my $mysqld = _mysqld() or return;

    my $verbose_help = `$mysqld --verbose --help 2>/dev/null`;

    my ($version, $major_version, $minor_version) = $verbose_help =~ /\A.*Ver (([0-9]+)\.([0-9]+)\.[0-9]+)/;

    my $is_maria = $verbose_help =~ /\A.*MariaDB/;

    # Convert MariaDB version into MySQL version for simplicity
    # See https://mariadb.com/kb/en/mariadb-vs-mysql-compatibility/ for details
    my ($maria_major_version, $maria_minor_version);
    if ($is_maria) {
        $maria_major_version = $major_version;
        $maria_minor_version = $minor_version;
        if ($major_version == 10) {
            if ($minor_version < 2) {
                $major_version = 5;
                $minor_version = 6;
            } elsif ($minor_version < 5) {
                $major_version = 5;
                $minor_version = 7;
            }
        } elsif ($major_version == 5) {    ## just in case
            if ($minor_version < 5) {
                $minor_version = 1;
            }
        }
    }
    return ($major_version, $minor_version, $is_maria, $maria_major_version, $maria_minor_version);
}

sub skip_unless_mysql_version_is_greater_than {
    my ($self, $version) = @_;

    plan skip_all => "requires MySQL $version" unless $self->_check_mysql_version($version);
}

sub _check_mysql_version {
    my ($self, $version) = @_;

    return if lc $self->driver ne 'mysql';

    $version =~ s/^([0-9]+\.[0-9]+).*/$1/;

    my ($major_version, $minor_version) = _mysql_version();
    return unless $major_version;
    return ($version <= "$major_version.$minor_version") ? 1 : 0;
}

sub my_cnf {
    my $class = shift;

    my %cnf = (
        'skip-networking' => '',
        'sql_mode'        => 'TRADITIONAL,NO_AUTO_VALUE_ON_ZERO,ONLY_FULL_GROUP_BY',
    );

    my ($major_version, $minor_version, $is_maria, $maria_major, $maria_minor) = _mysql_version();
    return \%cnf unless $major_version;

    # MySQL 8.0+
    if ((!$is_maria && $major_version >= 8) or ($is_maria && $maria_major == 10 && $maria_minor > 3)) {
        $cnf{default_authentication_plugin} = 'mysql_native_password';
    }

    my $charset = $class->mysql_charset;
    if ($charset eq 'utf8mb4') {
        if ($major_version < 7 and $minor_version < 7) {
            $cnf{innodb_file_format}    = 'Barracuda';
            $cnf{innodb_file_per_table} = 1;
            $cnf{innodb_large_prefix}   = 1;
        }
        $cnf{character_set_server} = $charset;
        $cnf{collation_server}     = $class->mysql_collation;
    }
    \%cnf;
}

sub _which {
    my $exec = shift;
    my $path = `which $exec 2>/dev/null` or return;
    chomp $path;
    $path;
}

sub _mysqld {
    my $mysqld = _which('mysqld');
    return $mysqld if $mysqld;

    my $mysql = _which('mysql') or return;

    for my $dir (qw/ bin libexec sbin /) {
        ($mysqld = $mysql) =~ s!/[^/]+/mysql$!/$dir/mysqld! or next;
        return $mysqld if -f $mysqld && -x _;
    }
    return;
}

sub dbh {
    my $self = shift;
    $self->connect_info unless $self->{dsn};
    my $options = $self->{_config}{DBIConnectOptions} || {};
    DBI->connect(
        $self->{dsn},
        undef, undef,
        {
            RaiseError         => 1,
            PrintError         => 0,
            ShowErrorStatement => 1,
            %$options,
        },
    ) or die $DBI::errstr;
}

sub _get_id_from_caller {
    my $self = shift;
    return $self->{fixture_id} if $self->{fixture_id};

    for (my $i = 0; $i < 3; $i++) {
        my $file = (caller($i))[1];
        next unless $file =~ s!\.t$!!;
        my $id = $file;
        $id =~ s!^($MT_HOME/)?!!;
        $id =~ s!^(?:(.*?)/)?t/!!;

        $self->{fixture_id}        = $id;
        $self->{extra_plugin_path} = $1;

        return $id;
    }
    die "get_id_from_caller can't detect .t file";
}

sub fixture_uid { shift->{fixture_uid} }

sub _set_fixture_dirs {
    my $self = shift;
    return $self->{fixture_dirs} if @{ $self->{fixture_dirs} || [] };

    $self->_find_addons_and_plugins();
    my $md5 = md5_hex(join '+', @{ $self->{addons_and_plugins} });
    my $uid = $self->{fixture_uid} = substr($md5, 0, 7);

    my @fixture_dirs = ("$MT_HOME/t/fixture/$uid");

    if ($self->{extra_plugin_path}) {
        push @fixture_dirs, "$MT_HOME/$self->{extra_plugin_path}/t/fixture/$uid";
    }
    $self->{fixture_dirs} = \@fixture_dirs;
}

sub _schema_file {
    my $self = shift;

    my $driver = lc $self->{driver};
    return "schema.$driver.sql";
}

sub _fixture_file {
    my ($self, $id) = @_;
    return "$id.json";
}

sub _fixture_readme {
    my $self = shift;
    "$self->{fixture_dirs}[-1]/README";
}

sub _fixture_home_readme {
    my $self = shift;
    "$self->{fixture_dirs}[0]/README";
}

sub fix_mysql_create_table_sql {
    my $class = shift;
    return unless $class->mysql_charset eq 'utf8mb4';

    require MT::ObjectDriver::DDL::mysql;
    no warnings 'redefine';
    *MT::ObjectDriver::DDL::mysql::create_table_sql = \&_create_table_sql_for_old_mysql;
}

sub _create_table_sql_for_old_mysql {
    my $sql = MT::ObjectDriver::DDL::create_table_sql(@_);
    $sql .= " ENGINE=InnoDB";
    $sql .= " DEFAULT CHARACTER SET=" . ($ENV{MT_TEST_MYSQL_CHARSET}    || 'utf8mb4');
    $sql .= " ROW_FORMAT=" .            ($ENV{MT_TEST_MYSQL_ROW_FORMAT} || 'DYNAMIC');
    $sql;
}

sub detect_basename_collision {
    my ($self, $id) = @_;
    my $path1 = join('/', map { decamelize($_) } split(/\//, $id));
    $path1 = "$MT_HOME/t/$path1.t";
    my $path2 = join('/', map { camelize($_) } split(/\//, $id));
    $path2 = "$MT_HOME/t/lib/MT/Test/Fixture/$path2.pm";
    if (-f $path1 && -f $path2) {
        die qq{Fixture id "$id" is already in use.};
    }
}

sub prepare_fixture {
    my $self = shift;

    $self->suppress_deprecated_warnings unless $ENV{MT_TEST_WARN_DEPRECATION};

    if (grep { $ENV{"MT_TEST_$_"} } qw/ LANG /) {
        $ENV{MT_TEST_IGNORE_FIXTURE} = 1;
        note "Fixture is ignored because of an environmental variable";
    }

    require MT::Test;
    my $app = $ENV{MT_APP} || 'MT::App';
    eval "require $app; 1" or die $@;
    MT->set_instance($app->new);

    my $id = $self->_get_id_from_caller;
    $self->_set_fixture_dirs;

    my $code;
    if (ref $_[0] eq 'CODE') {
        $self->detect_basename_collision($id);
        $code = shift;
    } else {
        $id = shift;
        $self->detect_basename_collision($id);
        if ($id eq 'db') {
            $code = sub {
                MT::Test->init_db;
            };
        } elsif ($id eq 'db_data') {
            $code = sub {
                MT::Test->init_db;
                MT::Test->init_data;
            };
        } else {
            $code = sub {
                my @path          = map { camelize($_) } split('/', $id);
                my $fixture_class = 'MT::Test::Fixture::' . (join '::', @path);
                eval "require $fixture_class; 1" or croak "Fixture class error: $id:" . $@;
                $fixture_class->prepare_fixture;
            };
        }
    }

    $self->fix_mysql_create_table_sql;

    my $do_save;
    if ($ENV{MT_TEST_IGNORE_FIXTURE}) {
        $code->();
    } elsif ($ENV{MT_TEST_UPDATE_FIXTURE}) {
        $code->();
        $do_save = 1;
    } elsif ($ENV{MT_TEST_AUTOUPDATE_FIXTURE}) {
        if (!$self->load_schema_and_fixture($id)) {
            $code->();
            $do_save = 1;
        }
    } else {
        $self->load_schema_and_fixture($id) or $code->();
    }

    $self->update_sequences;

    if ($do_save) {
        $self->save_schema;
        $self->save_fixture($id);

        if ($self->{fixture_dirs}[-1]) {
            mkpath $self->{fixture_dirs}[-1] unless -d $self->{fixture_dirs}[-1];
            open my $fh, '>', $self->_fixture_readme or die $!;
            print $fh "SchemaVersion ", MT->schema_version, "\n";
            print $fh join "\n", @{ $self->{addons_and_plugins} }, "";
            close $fh;
        }
    }

    require MT::Theme;
    my $blog = MT::Blog->load(1);
    if ($blog) {
        MT::Theme->load('classic_blog');
    } else {
        MT::Theme->load('classic_website');
    }

    $ENV{MT_TEST_LOADED_FIXTURE} = 1;

    $self->cluck_errors if $ENV{MT_TEST_CLUCK_ERRORS};

    $self->enable_query_log if $ENV{MT_TEST_QUERY_LOG};

    for my $hook (values %{$self->{prepare_hooks} || {}}) {
        $hook->($self);
    }

    # make sure to reflect PluginSwitch, which may have been modified while upgrading
    if (my $switch_config = $self->{_config}{PluginSwitch}) {
        my $switch = MT->config->PluginSwitch;
        if (ref $switch_config eq 'ARRAY') {
            for my $config (@{ $switch_config }) {
                my ($key, $value) = split '=', $config;
                $switch->{$key} = $value;
            }
        } elsif (ref $switch_config eq 'HASH') {
            %$switch = (%$switch, %$switch_config);
        }
        MT->config->PluginSwitch($switch, 1);
        MT->config->save_config;
    }

    MT->config->clear_dirty;
}

sub slurp {
    my ($self, $file, $binmode) = @_;
    open my $fh, '<', $file or die "$file: $!";
    binmode $fh, $binmode if $binmode;
    local $/;
    <$fh>;
}

sub _find_addons_and_plugins {
    my $self = shift;
    return $self->{addons_and_plugins} if $self->{addons_and_plugins};

    my @files;
    push @files, glob "$MT_HOME/addons/*/config.yaml";
    push @files, glob "$MT_HOME/plugins/*/config.yaml";
    push @files, glob "$MT_HOME/plugins/*/*.pl";

    # respect explicit PluginPath
    if ($self->{config}{PluginPath}) {
        for my $path (@{ $self->{config}{PluginPath} }) {
            push @files, glob "$path/*/config.yaml";
            push @files, glob "$path/*/*.pl";
        }
    }

    my %seen;
    $self->{addons_and_plugins} = [
        sort
        grep { !$seen{$_}++ }
        map  { $_ =~ m!/((?:addons|plugins)/[^/]+)/!; $1 } @files
    ];
}

sub _find_file {
    my ($self, $file) = @_;
    for my $dir (@{ $self->{fixture_dirs} }) {
        return "$dir/$file" if -f "$dir/$file";
    }
    return;
}

sub load_schema_and_fixture {
    my ($self, $fixture_id) = @_;
    my $schema_file  = $self->_find_file($self->_schema_file) or return;
    my $fixture_file = $self->_find_file($self->_fixture_file($fixture_id))
        or return;
    return
        unless eval { require SQL::Maker; SQL::Maker->load_plugin('InsertMulti'); 1 };
    my $root = $self->{root};
    my ($s, $m, $h, $d, $mo, $y) = gmtime;
    my $now      = sprintf("%04d%02d%02d%02d%02d%02d", $y + 1900, $mo + 1, $d, $h, $m, $s);
    my @pool     = ('a' .. 'z', 0 .. 9);
    my $api_pass = join '', map { $pool[rand @pool] } 1 .. 8;
    my $salt     = join '', map { $pool[rand @pool] } 1 .. 16;

    # Tentative password; update it later when necessary
    my $author_pass = '$6$' . $salt . '$' . Digest::SHA::sha512_base64($salt . 'pass');
    my $schema      = $self->slurp($schema_file)  or return;
    my $fixture     = $self->slurp($fixture_file) or return;
    $fixture =~ s/\b__MT_HOME__\b/$MT_HOME/g;
    $fixture =~ s/\b__TEST_ROOT__\b/$root/g;
    $fixture =~ s/\b__NOW__\b/$now/g;
    $fixture =~ s/\b__API_PASS__\b/$api_pass/g;
    $fixture =~ s/\b__AUTHOR_PASS__\b/$author_pass/g;
    require JSON;
    $fixture = eval { JSON::decode_json($fixture) };

    if ($@ or !%$fixture) {
        warn "Fixture is empty or broken";
        return;
    }

    my $fixture_schema_version = $fixture->{schema_version};
    if (  !$fixture_schema_version
        or $fixture_schema_version ne $self->schema_version)
    {
        my $fixture_uid = $self->fixture_uid;
        diag "FIXTURE ($fixture_file) IS IGNORED: please update fixture" unless $self->{config}{PluginSwitch};
        if ($fixture_schema_version && eval { require Text::Diff }) {
            $fixture_schema_version .= "\n";
            my $self_schema_version = $self->schema_version . "\n";
            diag Text::Diff::diff(
                \$fixture_schema_version, \$self_schema_version,
                { STYLE => 'Unified' });
        }
        return;
    }

    my $dbh = $self->dbh;
    if ($self->mysql_charset eq 'utf8mb4') {
        my $sql    = "SHOW VARIABLES LIKE 'innodb_large_prefix'";
        my $prefix = $dbh->selectrow_hashref($sql);
        if (!$prefix or uc $prefix->{Value} ne 'ON') {
            plan skip_all => "Use MySQLPool or set 'innodb_large_prefix'";
        }
    }
    $dbh->begin_work;
    eval {
        for my $sql (split /;\n/s, $schema) {
            chomp $sql;
            next unless $sql;
            if ($self->mysql_charset eq 'utf8mb4') {
                $sql =~ s/(DEFAULT CHARACTER SET utf8)/${1}mb4 ROW_FORMAT=DYNAMIC/;
            }
            $dbh->do($sql);
        }
        my $sql_maker = SQL::Maker->new(driver => $self->{driver});
        for my $table (keys %$fixture) {
            next if $table eq 'schema_version';
            my $data = $fixture->{$table};
            my ($sql, @bind) = $sql_maker->insert_multi($table, @$data{qw/cols rows/});
            for my $bind_value (@bind) {
                if ($bind_value && $bind_value =~ /^BIN:SERG/) {
                    $bind_value =~ s/(.)/sprintf('0x%02x', ord($1))/ge;
                }
            }
            $sql =~ s/\n/ /g;
            $dbh->do($sql, undef, @bind);
        }
    };
    if ($@) {
        warn $@;
        $dbh->rollback;
        return;
    }
    $dbh->commit;

    # for init_db
    require MT::Test;
    MT::Test->_load_classes;

    MT->instance->init_config_from_db;

    return 1;
}

sub update_sequences {
    my $self = shift;

    return unless lc($self->driver) =~ /^(oracle|pg)/;

    my @classes;
    my $types = MT->registry('object_types');
    for my $key (keys %$types) {
        next if $key =~ /\./;
        my $class = $types->{$key};
        $class = $class->[0] if ref $class eq 'ARRAY';
        push @classes, $class;
        if ( $key eq 'entry' or $key eq 'user' ) {
            push @classes, "$class\::Summary";
        }
        if ( my $model = MT->model($key) ) {
            if ( $model->meta_pkg ) {
                my $meta_class = MT->model("$key:meta");
                push @classes, $meta_class if $meta_class;
            }
        }
    }
    for my $class (@classes) {
        my $col = $class->properties->{primary_key} or next;
        $col = $col->[1] if ref $col;
        my $def = $class->column_def($col);
        my $ddl = $class->driver->dbd->ddl_class;
        next unless $def->{auto} && ($def->{type} eq 'integer' or $ddl->type2db($def) =~ /^number/);
        my $dbh = $class->driver->dbh;
        my $field_prefix = $class->datasource;
        my $table_name   = $class->table_name;
        my ($max) = $dbh->selectrow_array("SELECT MAX(${field_prefix}_${col}) FROM $table_name");
        my $seq = $class->driver->dbd->sequence_name($class);
        my $start = ($max || 0) + 1;
        $dbh->do("DROP SEQUENCE $seq");
        $dbh->do("CREATE SEQUENCE $seq START WITH $start");
    }
}

sub save_schema {
    my $self = shift;

    my $force;
    my $guard;
    if (!ref $self) {
        $self = $self->new;
        require Test::mysqld;
        my $mysqld = Test::mysqld->new(my_cnf => $self->my_cnf)
            or die $Test::mysqld::errstr;
        local $ENV{PERL_TEST_MYSQLPOOL_DSN} = $mysqld->dsn;
        $self->prepare($mysqld);
        local $ENV{MT_CONFIG} = $self->config_file;
        $self->write_config;
        $self->fix_mysql_create_table_sql;
        require MT::Test;
        MT::Test->init_db;
        $force = 1;
        $guard = $mysqld;
    }

    $self->_set_fixture_dirs;

    my $saved_schema_version = '';
    if (-f $self->_fixture_home_readme) {
        open my $fh, '<', $self->_fixture_home_readme or die $!;
        while(<$fh>) {
            chomp;
            if (/SchemaVersion ([0-9.]+)/) {
                $saved_schema_version = $1;
                last;
            }
        }
    }
    if ($saved_schema_version ne MT->schema_version) {
        print STDERR "Schema version has changed from $saved_schema_version to " . MT->schema_version . "\n";
        $force = 1;
    }

    #  always save in MT_HOME/t/fixture
    my $file = join "/", $self->{fixture_dirs}[0], $self->_schema_file;

    # skip if updated quite recently
    return if !$force and -f $file and (stat($file))[9] - time < 300;

    my $schema = $self->_generate_schema or return;

    my $dir = dirname($file);
    mkpath $dir unless -d $dir;
    open my $fh, '>', $file or die $!;
    flock $fh, LOCK_EX;
    print $fh $schema;
    close $fh;

    print "Saved test schema: $file\n" if $force;
}

sub _generate_schema {
    my $self = shift;
    eval { require SQL::Translator } or return;

    my $driver = lc $self->{driver};
    my $dbh    = $self->dbh;
    my %translator_args;
    if ($driver eq 'mysql') {
        %translator_args = (
            filters       => [\&_sql_translator_filter_mysql],
            producer      => 'MySQL',
            producer_args => { mysql_version => 5.000003 },
        );
    }
    my $translator = SQL::Translator->new(
        add_drop_table => 1,
        parser         => 'DBI',
        parser_args    => { dbh => $dbh },
        %translator_args,
    );
    $translator->translate or die $translator->error;
}

sub _sql_translator_filter_mysql {
    my $schema = shift;
    for my $table ($schema->get_tables) {
        my $options = $table->options;
        my $i       = 0;
        my $saw_charset;
        my $saw_engine;
        while ($i < @$options) {
            my ($key, $value) = %{ $options->[$i] };
            if ($key eq 'CHARACTER SET') {
                unless ($options->[$i]{$key} =~ /utf8/) {
                    $options->[$i]{$key} = 'utf8';
                }
                $saw_charset = 1;
            }
            if ($key eq 'ENGINE') {
                $options->[$i]{$key} = 'InnoDB';
                $saw_engine = 1;
            }
            splice @$options, $i, 1 if $key eq 'AUTO_INCREMENT';
            $i++;
        }
        if (!$saw_charset) {
            $table->options({ 'CHARACTER SET' => 'utf8' });
        }
        if (!$saw_engine) {
            $table->options({ 'ENGINE' => 'InnoDB' });
        }

        # Some of the PHP tests assume that float has no explicit size
        my $order = 0;
        for my $field (sort { $a->name cmp $b->name } $table->get_fields) {
            $field->order($order++);
            if (lc $field->data_type =~ /float|double/) {
                $field->size(0);
            }
        }

        my @indices = sort { $a->name cmp $b->name } $table->get_indices;
        @{ $table->_indices } = @indices;
    }
}

sub save_fixture {
    my ($self, $fixture_id) = @_;
    eval { require Time::Piece; require Time::Seconds; 1 } or return;

    $self->_set_fixture_dirs;

    my $file = $self->_fixture_file($fixture_id);
    if (-f "$self->{fixture_dirs}[0]/$file") {
        $file = "$self->{fixture_dirs}[0]/$file";
    } else {
        $file = "$self->{fixture_dirs}[-1]/$file";
        mkpath $self->{fixture_dirs}[-1] unless -d $self->{fixture_dirs}[-1];
    }

    my $driver = lc $self->{driver};
    my $dbh    = $self->dbh;
    my @tables;
    if ($driver eq 'mysql') {
        @tables = map { $_->[0] } @{ $dbh->selectall_arrayref('SHOW TABLES') };
    }
    my $root = $self->{root};
    my %data;
    for my $table (@tables) {
        my $order_by = '';
        if ($driver eq 'mysql') {
            my $indices = $dbh->selectall_arrayref("SHOW INDEX IN $table", { Slice => +{} });
            if (@$indices) {
                $order_by = ' ORDER BY ' . $indices->[0]{Column_name};
            }
        }
        my $rows = $dbh->selectall_arrayref("SELECT * FROM $table$order_by", { Slice => +{} });
        next unless @{ $rows || [] };
        my @keys = sort keys %{ $rows->[0] };
        my @rows_modified;
        for my $row (@$rows) {
            my @data;
            for my $key (@keys) {
                my $value = $row->{$key};
                if (defined $value) {
                    if ($key =~ /(?:created|modified)_on$/) {
                        my $t   = Time::Piece->strptime($value, '%Y-%m-%d %H:%M:%S');
                        my $now = Time::Piece->new;
                        if ($now - $t < Time::Seconds::ONE_DAY()) {
                            $value = '__NOW__';
                        }
                    } elsif ($key eq 'author_api_password') {
                        $value = '__API_PASS__';
                    } elsif ($key eq 'author_password') {
                        $value = '__AUTHOR_PASS__';
                    } elsif ($key =~ /^(?:role|permission)_permissions$/) {
                        $value = join ',', sort split ',', $value;
                    } else {
                        $value =~ s/^$root/__TEST_ROOT__/;
                        $value =~ s/^$MT_HOME/__MT_HOME__/;
                    }
                }
                push @data, $value;
            }
            push @rows_modified, \@data;
        }
        $data{$table} = {
            cols => \@keys,
            rows => \@rows_modified,
        };
    }

    if (!%data) {
        Carp::cluck "Fixture is empty";
        unlink $file if -f $file;
        return;
    }

    $data{schema_version} = $self->schema_version;

    require JSON::PP;
    my $dir = dirname($file);
    mkpath $dir unless -d $dir;
    open my $fh, '>', $file or die $!;
    flock $fh, LOCK_EX;
    print $fh JSON::PP->new->pretty->canonical->utf8->encode(\%data);
    close $fh;
}

sub _tweak_schema {
    my $schema = shift;
    $schema =~ s/^\-\- Created on .+$//m;
    $schema =~ s/NULL DEFAULT NULL/NULL/g;    ## mariadb 10.2.1+
    $schema =~ s/\s+COLLATE utf8_\w+_ci//g;   ## for now; better to specify collation explicitly
    $schema;
}

sub test_schema {
    my $self = shift;

    if (grep { $ENV{"MT_TEST_$_"} } qw/ LANG MYSQL_CHARSET MYSQL_COLLATION /) {
        plan skip_all => "Fixture is ignored because of an environmental variable";
    }

    $self->_get_id_from_caller;
    $self->_set_fixture_dirs;

    my $driver      = lc $self->{driver};
    my $schema_file = "$self->{fixture_dirs}[0]/schema.$driver.sql";
    plan skip_all => 'schema is not found' unless -f $schema_file;

    my $saved_schema = $self->slurp($schema_file);

    my $generated_schema = $self->_generate_schema;

    if (_tweak_schema($generated_schema) eq _tweak_schema($saved_schema)) {
        pass "schema is up-to-date";
    } else {
        fail "schema is out-of-date";
        if (eval { require Text::Diff }) {
            diag Text::Diff::diff(\$generated_schema, \$saved_schema, { STYLE => 'Unified' });
        }
    }
}

sub dump_table {
    my ($self, $table, $extra, $bind) = @_;
    my $dbh = $self->dbh;
    my $sql = "SELECT * FROM $table";
    $sql .= " $extra" if $extra;
    my $rows = $dbh->selectall_arrayref($sql, { Slice => +{} }, @{ $bind || [] });
    note explain($rows);
}

sub skip_if_addon_exists {
    my ($self, $name) = @_;
    my $config = "$MT_HOME/addons/$name/config.yaml";
    plan skip_all => "$config exists" if -f $config;
}

sub skip_if_plugin_exists {
    my ($self, $name) = @_;
    my $config = "$MT_HOME/plugins/$name/config.yaml";
    plan skip_all => "$config exists" if -f $config;
}

sub skip_unless_addon_exists {
    my ($self, $name) = @_;
    my $config = "$MT_HOME/addons/$name/config.yaml";
    plan skip_all => "$config does not exist" unless -f $config;
}

sub skip_unless_plugin_exists {
    my ($self, $name) = @_;
    my $config = "$MT_HOME/plugins/$name/config.yaml";
    plan skip_all => "$config does not exist" unless -f $config;
}

sub plugin_exists {
    my ($self, $name) = @_;
    my $config = "$MT_HOME/plugins/$name/config.yaml";
    -f $config ? 1 : 0;
}

sub addon_exists {
    my ($self, $name) = @_;
    my $config = "$MT_HOME/addons/$name/config.yaml";
    -f $config ? 1 : 0;
}

sub disable_addon {
    my ($self, $name) = @_;
    my $config   = "$MT_HOME/addons/$name/config.yaml";
    my $disabled = "$config.disabled";

    # Want a lock?
    if (-f $config) {
        rename($config, $disabled)
            or plan skip_all => "$config cannot be renamed.: $!";
        $self->{disabled_addons}{$name} = 1;
    }
}

sub enable_addon {
    my ($self, $name) = @_;
    my $config   = "$MT_HOME/addons/$name/config.yaml";
    my $disabled = "$config.disabled";

    if (-f $disabled && $self->{disabled_addons}{$name}) {
        rename($disabled, $config) or warn $!;
        delete $self->{disabled_addons}{$name};
    }
}

sub disable_plugin {
    my ($self, $name) = @_;
    my $config   = "$MT_HOME/plugins/$name/config.yaml";
    my $disabled = "$config.disabled";

    # Want a lock?
    if (-f $config) {
        rename($config, $disabled)
            or plan skip_all => "$config cannot be renamed.: $!";
        $self->{disabled_plugins}{$name} = 1;
    }
}

sub enable_plugin {
    my ($self, $name) = @_;
    my $config   = "$MT_HOME/plugins/$name/config.yaml";
    my $disabled = "$config.disabled";

    if (-f $disabled && $self->{disabled_plugins}{$name}) {
        rename($disabled, $config) or warn $!;
        delete $self->{disabled_plugins}{$name};
    }
}

sub schema_version {
    my $self     = shift;
    my %versions = (
        core => MT->schema_version,
        $self->plugin_schema_version,
    );
    return join "; ", map { $_ . " " . $versions{$_} } sort keys %versions;
}

sub plugin_schema_version {
    my $self = shift;
    return map { $_->id => $_->schema_version }
        grep { defined $_->schema_version && $_->schema_version ne '' } @MT::Plugins;
}

sub utime_r {
    my ($self, $root, $utime) = @_;
    $utime ||= int(time - 86400);    # 1 day old
    File::Find::find({
            wanted => sub {
                return unless -f $File::Find::name;
                utime $utime, $utime, $File::Find::name or warn $!;
            },
            no_chdir => 1,
        },
        $root || $self->root
    );
}

sub clear_mt_cache {
    MT::Request->instance->reset;
    require MT::ObjectDriver::Driver::Cache::RAM;
    MT::ObjectDriver::Driver::Cache::RAM->clear_cache;
}

sub ls {
    my ($self, $root, $callback) = @_;
    if (ref $root eq ref sub { }) {
        $callback = $root;
        $root     = undef;
    }
    $callback ||= sub {
        my $file = shift;
        note $file if -f $file;
    };
    $root ||= $self->root;
    return unless -d $root;
    File::Find::find({
            wanted => sub {
                $callback->($File::Find::name);
            },
            preprocess => sub { sort @_ },
            no_chdir   => 1,
        },
        $root
    );
}

sub files {
    my ($self, $root, $callback) = @_;
    my @files;
    $self->ls(
        $root,
        sub {
            my $file = shift;
            return unless -f $file;
            return if $callback && !$callback->($file);
            push @files, $file;
        },
    );
    return @files;
}

sub remove_logfile {
    my $self = shift;
    require MT::Util::Log;
    my $logfile = MT::Util::Log->_get_logfile_path;
    return unless -f $logfile;
    unlink $logfile;
}

sub slurp_logfile {
    my $self = shift;
    require MT::Util::Log;
    my $logfile = MT::Util::Log->_get_logfile_path;
    return unless -f $logfile;
    open my $fh, '<', $logfile or die $!;
    local $/;
    <$fh>;
}

sub enable_query_log {
    my $self = shift;
    require DBIx::QueryLog;
    return if DBIx::QueryLog->is_enabled;
    $DBIx::QueryLog::SKIP_PKG_MAP{$_} = 1 for qw(
        MT::Object
        MT::ObjectDriver::Driver::DBI
        Data::ObjectDriver::Driver::DBI
        Data::ObjectDriver::Driver::BaseCache
        Data::ObjectDriver::BaseObject
    );
    DBIx::QueryLog->compact(1);
    if (my $color = $ENV{MT_TEST_QUERY_LOG_COLOR}) {
        require Term::ANSIColor;
        $DBIx::QueryLog::OUTPUT = sub {
            my %param = @_;
            (my $sql = $param{sql}) =~ s/[[:cntrl:]]/ /gs;
            $sql = Term::ANSIColor::colored([$color], $sql);
            diag sprintf "[%s] %s at %s line %s", $param{time}, $sql, $param{file}, $param{line};
        };
    } else {
        $DBIx::QueryLog::OUTPUT = sub {
            my %param = @_;
            (my $sql = $param{sql}) =~ s/[[:cntrl:]]/ /gs;
            diag sprintf "[%s] %s at %s line %s", $param{time}, $sql, $param{file}, $param{line};
        };
    }
    DBIx::QueryLog->enable;
}

sub disable_query_log {
    my $self = shift;
    DBIx::QueryLog->disable;
}

sub DESTROY {
    my $self = shift;
    if (my @disabled = keys %{ $self->{disabled_addons} || {} }) {
        for my $name (@disabled) {
            $self->enable_addon($name);
        }
    }
    if (my @disabled = keys %{ $self->{disabled_plugins} || {} }) {
        for my $name (@disabled) {
            $self->enable_plugin($name);
        }
    }
    if ($ENV{MT_TEST_PERFORMANCE}) {
        undef $Test::MockTime::fixed;
        open my $fh, '>>', 'mt_test_performance.log';
        printf $fh "%f\t%s\n", Time::HiRes::tv_interval($self->{start}), $0;
    }
}

1;
