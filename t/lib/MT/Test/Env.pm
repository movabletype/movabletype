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

our $MT_HOME;

BEGIN {
    my $me = Cwd::realpath(__FILE__);
    $MT_HOME = dirname( dirname( dirname( dirname( dirname($me) ) ) ) );
    $ENV{MT_HOME} = $MT_HOME;
}
use lib "$MT_HOME/lib", "$MT_HOME/extlib";

sub new {
    my ( $class, %extra_config ) = @_;
    my $template = "MT_TEST_" . $$ . "_XXXX";
    my $root = tempdir( $template, CLEANUP => 1, TMPDIR => 1 );
    $root = Cwd::realpath($root);
    $ENV{MT_TEST_ROOT} = $root;

    my $self = bless {
        root   => $root,
        driver => $ENV{MT_TEST_BACKEND} || 'mysql',
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

    my $image_driver = $ENV{MT_TEST_IMAGE_DRIVER} ||
        ( eval { require Image::Magick } ? 'ImageMagick' : 'Imager' );

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
        if ( $opts{mysql_socket} ) {
            delete $info{DBHost};
            $info{DBSocket} = $opts{mysql_socket};
        }
        if ( $opts{user} ) {
            $info{DBUser} = $opts{user};
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

sub prepare_fixture {
    my $self = shift;
    my ( $id, $code );
    my $fixture_dir = "$MT_HOME/t/fixture";
    if ( ref $_[0] eq 'CODE' ) {
        $code = shift;
        $id   = (caller)[1];    # file
        $id =~ s!^($MT_HOME/)?!!;
        $id =~ s!\.t$!!;
        $id =~ s!^(?:(.*?)/)?t/!!;
        if ($1) {
            $fixture_dir = "$MT_HOME/$1/t/fixture";
            mkpath $fixture_dir unless -d $fixture_dir;
        }
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
    my $driver  = lc $self->{driver};
    my $schema  = "$MT_HOME/t/fixture/schema.$driver.sql";
    my $fixture = "$fixture_dir/$id.json";
    if ( !$ENV{MT_TEST_UPDATE_FIXTURE} and !$ENV{MT_TEST_IGNORE_FIXTURE} ) {
        $self->load_schema_and_fixture( $schema, $fixture ) or $code->();
    }
    else {
        $code->();
    }
    if ( $ENV{MT_TEST_UPDATE_FIXTURE} ) {
        $self->save_schema($schema);
        $self->save_fixture($fixture);
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

sub load_schema_and_fixture {
    my ( $self, $schema_file, $fixture_file ) = @_;
    return unless -f $schema_file;
    return unless -f $fixture_file;
    return
        unless
        eval { require SQL::Maker; SQL::Maker->load_plugin('InsertMulti'); 1 };
    my $root = $self->{root};
    my ( $s, $m, $h, $d, $mo, $y ) = gmtime;
    my $now = sprintf( "%04d%02d%02d%02d%02d%02d",
        $y + 1900, $mo + 1, $d, $h, $m, $s );
    my $schema  = _slurp($schema_file)  or return;
    my $fixture = _slurp($fixture_file) or return;
    $fixture =~ s/\b__MT_HOME__\b/$MT_HOME/g;
    $fixture =~ s/\b__TEST_ROOT__\b/$root/g;
    $fixture =~ s/\b__NOW__\b/$now/g;
    require JSON;
    $fixture = eval { JSON::decode_json($fixture) };

    if ( $@ or !%$fixture ) {
        warn "Fixture is empty or broken";
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

    return 1;
}

sub save_schema {
    my ( $self, $file ) = @_;
    eval { require SQL::Translator } or return;

    # skip if updated quite recently
    return if -f $file and (stat($file))[9] - time < 300;

    my $driver = lc $self->{driver};
    my $dbh    = $self->dbh;
    my %translator_args;
    if ( $driver eq 'mysql' ) {
        %translator_args = (
            filters       => [ \&_sql_translator_filter_mysql ],
            producer      => 'MySQL',
            producer_args => { mysql_version => 5 },
        );
    }
    my $translator = SQL::Translator->new(
        add_drop_table => 1,
        parser         => 'DBI',
        parser_args    => { dbh => $dbh },
        %translator_args,
    );
    my $schema = $translator->translate or die $translator->error;

    my $dir = dirname($file);
    mkpath $dir unless -d $dir;
    open my $fh, '>', $file or die $!;
    flock $fh, LOCK_EX;
    print $fh $schema;
    close $fh;
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
            splice @$options, $i, 1 if $key eq 'AUTO_INCREMENT';
            $i++;
        }
        if ( !$saw_charset ) {
            $table->options( { 'CHARACTER SET' => 'utf8' } );
        }

        # Some of the PHP tests assume that float has no explicit size
        for my $field ( $table->get_fields ) {
            if ( lc $field->data_type eq 'float' ) {
                $field->size(0);
            }
        }
    }
}

sub save_fixture {
    my ( $self, $file ) = @_;
    eval { require Time::Piece; require Time::Seconds; 1 } or return;

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

    require JSON;
    my $dir = dirname($file);
    mkpath $dir unless -d $dir;
    open my $fh, '>', $file or die $!;
    flock $fh, LOCK_EX;
    print $fh JSON->new->pretty->canonical->utf8->encode( \%data );
    close $fh;
}

1;
