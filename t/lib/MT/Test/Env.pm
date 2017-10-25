package MT::Test::Env;

use strict;
use warnings;
use Test::More;
use File::Spec;
use Cwd ();
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

    my $driver = $self->{driver};
    my $method = '_connect_info_' . ( lc $driver );
    my %connect_info;
    if ($self->can($method)) {
        %connect_info = $self->$method;
    }
    else {
        my @keys = qw(
            ObjectDriver Database DBPort DBHost DBSocket
            DBUser DBPassword ODBCDriver
        );
        for my $key (@keys) {
            my $env_key = "MT_TEST_" . (uc $key);
            if ($ENV{$env_key}) {
                $connect_info{$key} = $ENV{$env_key};
            }
        }
    }

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
        if ( $opts{mysql_socket} ) {
            delete $info{DBHost};
            $info{DBSocket} = $opts{mysql_socket};
        }
        if ( $opts{user} ) {
            $info{DBUser} = $opts{user};
        }
    }
    else {
        $dsn
            = "dbi:mysql:$info{DBHost};dbname=$info{Database};user=$info{DBUser}";
        my $dbh = DBI->connect($dsn) or die $DBI::errstr;
        $self->_prepare_mysql_database($dbh);
    }
    return %info;
}

sub _connect_info_sqlite {
    my $self = shift;

    my $database = $self->path("mt.db");

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

1;
