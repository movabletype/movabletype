package MT::Test::Env;

use strict;
use warnings;
use Test::More;
use File::Spec;
use Cwd ();
use Fcntl qw/:flock/;
use File::Path 'mkpath';
use File::Temp 'tempdir';
use File::Basename 'dirname';
use DBI;
use Digest::MD5 'md5_hex';
use Digest::SHA;

our $MT_HOME;

BEGIN {
    my $me = Cwd::realpath(__FILE__);
    $MT_HOME = dirname( dirname( dirname( dirname( dirname($me) ) ) ) );
    $ENV{MT_HOME} = $MT_HOME;
}
use lib "$MT_HOME/lib", "$MT_HOME/extlib";
use lib glob("$MT_HOME/addons/*/lib"),  glob("$MT_HOME/addons/*/extlib");
use lib glob("$MT_HOME/plugins/*/lib"), glob("$MT_HOME/plugins/*/extlib");

sub new {
    my ( $class, %extra_config ) = @_;
    my $template = "MT_TEST_" . $$ . "_XXXX";
    my $root = tempdir( $template, CLEANUP => 1, TMPDIR => 1 );
    $root = Cwd::realpath($root);
    $ENV{MT_TEST_ROOT} = $root;
    $ENV{PERL_JSON_BACKEND} ||= 'JSON::PP';

    my $self = bless {
        root   => $root,
        driver => $ENV{MT_TEST_BACKEND} || 'mysql',
        config => \%extra_config,
    }, $class;

    $self->write_config( \%extra_config );

    $self;
}

sub config_file {
    my $self = shift;
    File::Spec->catfile( $self->{root}, 'mt-config.cgi' );
}

sub root {
    my $self = shift;
    $self->{root};
}

sub path {
    my ( $self, @parts ) = @_;
    File::Spec->catfile( $self->{root}, @parts );
}

sub write_config {
    my ( $self, $extra ) = @_;

    my %connect_info = $self->connect_info;

    my $image_driver = $ENV{MT_TEST_IMAGE_DRIVER}
        || ( eval { require Image::Magick } ? 'ImageMagick' : 'Imager' );

    require MT;

    # common directives
    my %config = (
        PluginPath => [
            qw(
                MT_HOME/plugins
                MT_HOME/t/plugins
                )
        ],
        TemplatePath       => 'MT_HOME/tmpl',
        SearchTemplatePath => 'MT_HOME/search_templates',
        ThemesDirectory    => [
            qw(
                TEST_ROOT/themes/
                MT_HOME/t/themes/
                MT_HOME/themes/
                )
        ],
        DefaultLanguage     => 'en_US',
        StaticWebPath       => '/mt-static/',
        StaticFilePath      => 'TEST_ROOT/mt-static',
        EmailAddressMain    => 'mt@localhost',
        WeblogTemplatesPath => 'MT_HOME/default_templates',
        ImageDriver         => $image_driver,
        MTVersion           => MT->version_number,
        MTReleaseNumber     => MT->release_number,
    );

    if ($extra) {
        for my $key ( keys %$extra ) {
            my $value = $extra->{$key};
            if ( !defined $value and $config{$key} ) {
                delete $config{$key};
            }
            elsif ( ref $value eq 'ARRAY' ) {
                push @{ $config{$key} }, @$value;
            }
            else {
                $config{$key} = $extra->{$key};
            }
        }
    }

    $config{$_} = $connect_info{$_} for keys %connect_info;

    my $root = $self->{root};
    open my $fh, '>', $self->config_file or plan skip_all => $!;
    for my $key ( sort keys %config ) {
        if ( ref $config{$key} eq 'ARRAY' ) {
            for my $value ( @{ $config{$key} } ) {
                $value =~ s/\bMT_HOME\b/$MT_HOME/;
                $value =~ s/\bTEST_ROOT\b/$root/ and mkpath($value);
                print $fh "$key $value\n";
            }
        }
        else {
            my $value = $config{$key};
            $value =~ s/\bMT_HOME\b/$MT_HOME/;
            $value =~ s/\bTEST_ROOT\b/$root/ and mkpath($value);
            print $fh "$key $value\n";
        }
    }
    close $fh;
}

sub connect_info {
    my $self   = shift;
    my $driver = $self->{driver};
    my $method = '_connect_info_' . ( lc $driver );
    my %connect_info;
    if ( $self->can($method) ) {
        %connect_info = $self->$method;
    }
    else {
        my @keys = qw(
            ObjectDriver Database DBPort DBHost DBSocket
            DBUser DBPassword ODBCDriver
        );
        for my $key (@keys) {
            my $env_key = "MT_TEST_" . ( uc $key );
            if ( $ENV{$env_key} ) {
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
        DBHost       => "localhost",
        DBUser       => "mt",
        Database     => "mt_test",
    );

    if ( my $dsn = $ENV{PERL_TEST_MYSQLPOOL_DSN} ) {
        my $dbh = DBI->connect($dsn) or die $DBI::errstr;
        $self->_prepare_mysql_database($dbh);
        $dsn =~ s/^DBI:mysql://i;
        my %opts = map { split '=', $_ } split ';', $dsn;
        $opts{dbname} = $info{Database};
        if ( $opts{host} ) {
            $info{DBHost} = $opts{host};
        }
        if ( $opts{mysql_socket} ) {
            delete $info{DBHost};
            $info{DBSocket} = $opts{mysql_socket};
        }
        if ( $opts{user} ) {
            $info{DBUser} = $opts{user};
        }
        if ( $opts{port} ) {
            $info{DBPort} = $opts{port};
        }
        $self->{dsn}
            = "dbi:mysql:" . ( join ";", map {"$_=$opts{$_}"} keys %opts );
    }
    else {
        $self->{dsn}
            = "dbi:mysql:host=$info{DBHost};dbname=$info{Database};user=$info{DBUser}";
        my $dbh = DBI->connect( $self->{dsn} ) or die $DBI::errstr;
        $self->_prepare_mysql_database($dbh);
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

sub _prepare_mysql_database {
    my ( $self, $dbh ) = @_;
    local $dbh->{RaiseError} = 1;
    my $sql = <<"END_OF_SQL";
DROP DATABASE IF EXISTS mt_test;
CREATE DATABASE mt_test;
END_OF_SQL
    for my $statement ( split ";\n", $sql ) {
        $dbh->do($statement);
    }
}

# for App::Prove::Plugin::MySQLPool
sub prepare {
    my ( $class, $mysqld ) = @_;
    my $dbh = DBI->connect( $mysqld->dsn );
    $class->_prepare_mysql_database($dbh);
}

sub dbh {
    my $self = shift;
    $self->connect_info unless $self->{dsn};
    DBI->connect(
        $self->{dsn},
        undef, undef,
        {   RaiseError         => 1,
            PrintError         => 0,
            ShowErrorStatement => 1,
        }
    ) or die $DBI::errstr;
}

sub _get_id_from_caller {
    my $self = shift;
    return $self->{fixture_id} if $self->{fixture_id};

    for ( my $i = 0; $i < 3; $i++ ) {
        my $file = ( caller($i) )[1];
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

sub _set_fixture_dirs {
    my $self = shift;
    return $self->{fixture_dirs} if @{ $self->{fixture_dirs} || [] };

    $self->_find_addons_and_plugins();
    my $md5 = md5_hex( join '+', @{ $self->{addons_and_plugins} } );
    my $uid = substr( $md5, 0, 7 );

    my @fixture_dirs = ("$MT_HOME/t/fixture/$uid");

    if ( $self->{extra_plugin_path} ) {
        push @fixture_dirs,
            "$MT_HOME/$self->{extra_plugin_path}/t/fixture/$uid";
    }
    $self->{fixture_dirs} = \@fixture_dirs;
}

sub _schema_file {
    my $self = shift;

    my $driver = lc $self->{driver};
    return "schema.$driver.sql";
}

sub _fixture_file {
    my ( $self, $id ) = @_;
    return "$id.json";
}

sub prepare_fixture {
    my $self = shift;

    my $app = $ENV{MT_APP} || 'MT::App';
    eval "require $app; 1" or die $@;
    MT->set_instance( $app->new );

    my $id = $self->_get_id_from_caller;

    my $code;
    if ( ref $_[0] eq 'CODE' ) {
        $code = shift;
    }
    else {
        $id = shift;
        if ( $id eq 'db' ) {
            $code = sub {
                MT::Test->init_db;
            };
        }
        elsif ( $id eq 'db_data' ) {
            $code = sub {
                MT::Test->init_db;
                MT::Test->init_data;
            };
        }
        else {
            $code = shift;
        }
    }

    if ( !$ENV{MT_TEST_UPDATE_FIXTURE} and !$ENV{MT_TEST_IGNORE_FIXTURE} ) {
        $self->load_schema_and_fixture($id) or $code->();
    }
    else {
        $code->();
    }
    if ( $ENV{MT_TEST_UPDATE_FIXTURE} ) {
        $self->save_schema;
        $self->save_fixture($id);

        if ( $self->{fixture_dirs}[-1] ) {
            open my $fh, '>', "$self->{fixture_dirs}[-1]/README" or die $!;
            print $fh join "\n", @{ $self->{addons_and_plugins} }, "";
            close $fh;
        }
    }

    require MT::Theme;
    my $blog = MT::Blog->load(1);
    if ($blog) {
        MT::Theme->load('classic_blog');
    }
    else {
        MT::Theme->load('classic_website');
    }

    $ENV{MT_TEST_LOADED_FIXTURE} = 1;
}

sub _slurp {
    my $file = shift;
    open my $fh, '<', $file or die "$file: $!";
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
    if ( $self->{config}{PluginPath} ) {
        for my $path ( @{ $self->{config}{PluginPath} } ) {
            push @files, glob "$path/*/config.yaml";
            push @files, glob "$path/*/*.pl";
        }
    }

    my %seen;
    $self->{addons_and_plugins} = [
        sort
        grep { !$seen{$_}++ }
        map { $_ =~ m!/((?:addons|plugins)/[^/]+)/!; $1 } @files
    ];
}

sub _find_file {
    my ( $self, $file ) = @_;
    for my $dir ( @{ $self->{fixture_dirs} } ) {
        return "$dir/$file" if -f "$dir/$file";
    }
    return;
}

sub load_schema_and_fixture {
    my ( $self, $fixture_id ) = @_;
    my $schema_file = $self->_find_file( $self->_schema_file ) or return;
    my $fixture_file = $self->_find_file( $self->_fixture_file($fixture_id) )
        or return;
    return
        unless
        eval { require SQL::Maker; SQL::Maker->load_plugin('InsertMulti'); 1 };
    my $root = $self->{root};
    my ( $s, $m, $h, $d, $mo, $y ) = gmtime;
    my $now = sprintf( "%04d%02d%02d%02d%02d%02d",
        $y + 1900, $mo + 1, $d, $h, $m, $s );
    my @pool = ( 'a' .. 'z', 0 .. 9 );
    my $api_pass = join '', map { $pool[ rand @pool ] } 1 .. 8;
    my $salt     = join '', map { $pool[ rand @pool ] } 1 .. 16;

    # Tentative password; update it later when necessary
    my $author_pass
        = '$6$' . $salt . '$' . Digest::SHA::sha512_base64( $salt . 'pass' );
    my $schema  = _slurp($schema_file)  or return;
    my $fixture = _slurp($fixture_file) or return;
    $fixture =~ s/\b__MT_HOME__\b/$MT_HOME/g;
    $fixture =~ s/\b__TEST_ROOT__\b/$root/g;
    $fixture =~ s/\b__NOW__\b/$now/g;
    $fixture =~ s/\b__API_PASS__\b/$api_pass/g;
    $fixture =~ s/\b__AUTHOR_PASS__\b/$author_pass/g;
    require JSON;
    $fixture = eval { JSON::decode_json($fixture) };

    if ( $@ or !%$fixture ) {
        warn "Fixture is empty or broken";
        return;
    }

    my $fixture_schema_version = $fixture->{schema_version};
    if (  !$fixture_schema_version
        or $fixture_schema_version ne $self->schema_version )
    {
        diag "FIXTURE IS IGNORED: please update fixture";
        return;
    }

    my $dbh = $self->dbh;
    $dbh->begin_work;
    eval {
        for my $sql ( split /;\n/s, $schema ) {
            chomp $sql;
            next unless $sql;
            $dbh->do($sql);
        }
        my $sql_maker = SQL::Maker->new( driver => $self->{driver} );
        for my $table ( keys %$fixture ) {
            next if $table eq 'schema_version';
            my $data = $fixture->{$table};
            my ( $sql, @bind )
                = $sql_maker->insert_multi( $table, @$data{qw/cols rows/} );
            $sql =~ s/\n/ /g;
            $dbh->do( $sql, undef, @bind );
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

sub save_schema {
    my $self = shift;

    my $force;
    if ( !ref $self ) {
        $self = $self->new;
        local $ENV{MT_CONFIG} = $self->config_file;
        require MT::Test;
        MT::Test->init_db;
        $force = 1;
    }

    $self->_set_fixture_dirs;

    #  always save in MT_HOME/t/fixture
    my $file = join "/", $self->{fixture_dirs}[0], $self->_schema_file;

    # skip if updated quite recently
    return if !$force and -f $file and ( stat($file) )[9] - time < 300;

    my $schema = $self->_generate_schema or return;

    my $dir = dirname($file);
    mkpath $dir unless -d $dir;
    open my $fh, '>', $file or die $!;
    flock $fh, LOCK_EX;
    print $fh $schema;
    close $fh;
}

sub _generate_schema {
    my $self = shift;
    eval { require SQL::Translator } or return;

    my $driver = lc $self->{driver};
    my $dbh    = $self->dbh;
    my %translator_args;
    if ( $driver eq 'mysql' ) {
        %translator_args = (
            filters       => [ \&_sql_translator_filter_mysql ],
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
    for my $table ( $schema->get_tables ) {
        my $options = $table->options;
        my $i       = 0;
        my $saw_charset;
        while ( $i < @$options ) {
            my ( $key, $value ) = %{ $options->[$i] };
            if ( $key eq 'CHARACTER SET' ) {
                $options->[$i]{$key} = 'utf8';
                $saw_charset = 1;
            }
            splice @$options, $i, 1 if $key =~ /^(?:AUTO_INCREMENT|ENGINE)$/;
            $i++;
        }
        if ( !$saw_charset ) {
            $table->options( { 'CHARACTER SET' => 'utf8' } );
        }
        $table->options( { 'ENGINE' => 'InnoDB' } );

        # Some of the PHP tests assume that float has no explicit size
        my $order = 0;
        for my $field ( sort { $a->name cmp $b->name } $table->get_fields ) {
            $field->order( $order++ );
            if ( lc $field->data_type eq 'float' ) {
                $field->size(0);
            }
        }

        my @indices = sort { $a->name cmp $b->name } $table->get_indices;
        @{ $table->_indices } = @indices;
    }
}

sub save_fixture {
    my ( $self, $fixture_id ) = @_;
    eval { require Time::Piece; require Time::Seconds; 1 } or return;

    $self->_set_fixture_dirs;

    my $file = $self->_fixture_file($fixture_id);
    if ( -f "$self->{fixture_dirs}[0]/$file" ) {
        $file = "$self->{fixture_dirs}[0]/$file";
    }
    else {
        $file = "$self->{fixture_dirs}[-1]/$file";
        mkpath $self->{fixture_dirs}[-1] unless -d $self->{fixture_dirs}[-1];
    }

    my $driver = lc $self->{driver};
    my $dbh    = $self->dbh;
    my @tables;
    if ( $driver eq 'mysql' ) {
        @tables = map { $_->[0] } $dbh->selectall_array('SHOW TABLES');
    }
    my $root = $self->{root};
    my %data;
    for my $table (@tables) {
        my $rows = $dbh->selectall_arrayref( "SELECT * FROM $table",
            { Slice => +{} } );
        next unless @{ $rows || [] };
        my @keys = sort keys %{ $rows->[0] };
        my @rows_modified;
        for my $row (@$rows) {
            my @data;
            for my $key (@keys) {
                my $value = $row->{$key};
                if ( defined $value ) {
                    if ( $key =~ /(?:created|modified)_on$/ ) {
                        my $t = Time::Piece->strptime( $value,
                            '%Y-%m-%d %H:%M:%S' );
                        my $now = Time::Piece->new;
                        if ( $now - $t < Time::Seconds::ONE_DAY() ) {
                            $value = '__NOW__';
                        }
                    }
                    elsif ( $key eq 'author_api_password' ) {
                        $value = '__API_PASS__';
                    }
                    elsif ( $key eq 'author_password' ) {
                        $value = '__AUTHOR_PASS__';
                    }
                    else {
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

    if ( !%data ) {
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
    print $fh JSON::PP->new->pretty->canonical->utf8->encode( \%data );
    close $fh;
}

sub _cut_created_on {
    my $schema = shift;
    $schema =~ s/^\-\- Created on .+$//m;
    $schema;
}

sub test_schema {
    my $self = shift;

    $self->_get_id_from_caller;
    $self->_set_fixture_dirs;

    my $driver       = lc $self->{driver};
    my $schema_file  = "$self->{fixture_dirs}[0]/schema.$driver.sql";
    my $saved_schema = _slurp($schema_file);

    my $generated_schema = $self->_generate_schema;

    if (_cut_created_on($generated_schema) eq _cut_created_on($saved_schema) )
    {
        pass "schema is up-to-date";
    }
    else {
        fail "schema is out-of-date";
        if ( eval { require Text::Diff } ) {
            diag Text::Diff::diff( \$generated_schema, \$saved_schema,
                { STYLE => 'Unified' } );
        }
    }
}

sub skip_if_addon_exists {
    my ( $self, $name ) = @_;
    my $config = "$MT_HOME/addons/$name/config.yaml";
    plan skip_all => "$config exists" if -f $config;
}

sub skip_if_plugin_exists {
    my ( $self, $name ) = @_;
    my $config = "$MT_HOME/plugins/$name/config.yaml";
    plan skip_all => "$config exists" if -f $config;
}

sub disable_addon {
    my ( $self, $name ) = @_;
    my $config   = "$MT_HOME/addons/$name/config.yaml";
    my $disabled = "$config.disabled";

    # Want a lock?
    if ( -f $config ) {
        rename( $config, $disabled )
            or plan skip_all => "$config cannot be renamed.: $!";
        $self->{disabled_addons}{$name} = 1;
    }
}

sub enable_addon {
    my ( $self, $name ) = @_;
    my $config   = "$MT_HOME/addons/$name/config.yaml";
    my $disabled = "$config.disabled";

    if ( -f $disabled && $self->{disabled_addons}{$name} ) {
        rename( $disabled, $config ) or warn $!;
        delete $self->{disabled_addons}{$name};
    }
}

sub disable_plugin {
    my ( $self, $name ) = @_;
    my $config   = "$MT_HOME/plugins/$name/config.yaml";
    my $disabled = "$config.disabled";

    # Want a lock?
    if ( -f $config ) {
        rename( $config, $disabled )
            or plan skip_all => "$config cannot be renamed.: $!";
        $self->{disabled_plugins}{$name} = 1;
    }
}

sub enable_plugin {
    my ( $self, $name ) = @_;
    my $config   = "$MT_HOME/plugins/$name/config.yaml";
    my $disabled = "$config.disabled";

    if ( -f $disabled && $self->{disabled_plugins}{$name} ) {
        rename( $disabled, $config ) or warn $!;
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
        grep { defined $_->schema_version && $_->schema_version ne '' }
        @MT::Plugins;
}

sub DESTROY {
    my $self = shift;
    if ( my @disabled = keys %{ $self->{disabled_addons} || {} } ) {
        for my $name (@disabled) {
            $self->enable_addon($name);
        }
    }
    if ( my @disabled = keys %{ $self->{disabled_plugins} || {} } ) {
        for my $name (@disabled) {
            $self->enable_plugin($name);
        }
    }
}

1;
