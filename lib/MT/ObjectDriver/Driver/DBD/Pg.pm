# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ObjectDriver::Driver::DBD::Pg;

use strict;
use warnings;

use base qw(
    MT::ObjectDriver::Driver::DBD::Legacy
    Data::ObjectDriver::Driver::DBD::Pg
    MT::ErrorHandler
);

sub sql_class {
    require MT::ObjectDriver::SQL::Pg;
    return 'MT::ObjectDriver::SQL::Pg';
}

sub ddl_class {
    require MT::ObjectDriver::DDL::Pg;
    return 'MT::ObjectDriver::DDL::Pg';
}

sub dsn_from_config {
    my $dbd   = shift;
    my $dsn   = $dbd->SUPER::dsn_from_config(@_);
    my ($cfg) = @_;
    $dsn .= ':dbname=' . $cfg->Database;
    $dsn .= ';host=' . $cfg->DBHost if $cfg->DBHost;
    $dsn .= ';port=' . $cfg->DBPort if $cfg->DBPort;
    return $dsn;
}

sub ts2db {
    my $ts = sprintf '%04d-%02d-%02d %02d:%02d:%02d', unpack 'A4A2A2A2A2A2',
        $_[1];
    $ts = undef if $ts eq '0000-00-00 00:00:00';
    return $ts;
}

sub db2ts {
    my $ts = $_[1];
    $ts =~ s/(?:\+|-)\d{2}$//;
    $ts =~ tr/\- ://d;
    return $ts;
}

sub configure {
    my $dbd = shift;
    my ($driver) = @_;
    $driver->pk_generator( \&pk_generator );
    return $dbd;
}

sub pk_generator {
    my $obj = shift;    # not a method
    my $driver
        = UNIVERSAL::isa( $obj, 'MT::Object' )
        ? $obj->driver
        : MT::Object->driver;
    my $seq = $driver->dbd->sequence_name( ref $obj );
    my $dbh = $driver->rw_handle;
    my $sth
        = $dbh->prepare("SELECT NEXTVAL('$seq')")
        or die UNIVERSAL::isa( $obj, 'MT::ErrorHandler' )
        ? $obj->error( $dbh->errstr )
        : $dbh->errstr;
    $sth->execute
        or die UNIVERSAL::isa( $obj, 'MT::ErrorHandler' )
        ? $obj->error( $dbh->errstr )
        : $dbh->errstr;
    $sth->bind_columns( undef, \my ($id) );
    $sth->fetch;
    $sth->finish;

    my $col = $obj->properties->{primary_key};
    ## If it's a complex primary key, use the second half.
    if ( ref $col ) {
        $col = $col->[1];
    }
    $obj->$col($id);
    return $id;
}

sub init_dbh {
    my $dbd = shift;
    my ($dbh) = @_;
    $dbd->SUPER::init_dbh(@_);
    $dbd->_set_names($dbh);
}

sub _set_names {
    my $dbd = shift;
    my ($dbh) = @_;
    return 1 if exists $dbh->{private_set_names};

    my $cfg       = MT->config;
    my $set_names = $cfg->SQLSetNames;
    $dbh->{private_set_names} = 1;
    return 1 if ( defined $set_names ) && !$set_names;

    my $c       = lc $cfg->PublishCharset;
    my %Charset = (
        'utf-8'     => 'UNICODE',
        'shift_jis' => 'SJIS',
        'euc-jp'    => 'EUC_JP',

        #'iso-8859-1' => 'LATIN1'
    );
    $c = $Charset{$c} ? $Charset{$c} : $c;
    eval {
        local $@;
        if ( !$dbh->do( "SET NAMES '" . $c . "'" ) ) {

           # 'set names' command isn't working for this verison of PostgreSQL,
           # assign SQLSetNames to 0 to prevent further errors.
            $cfg->SQLSetNames(0);
            return 0;
        }
        else {
            if ( !defined $set_names ) {

               # SQLSetNames has never been assigned; we had a successful
               # 'SET NAMES' command, so it's safe to SET NAMES in the future.
                $cfg->SQLSetNames(1);
            }
        }
    };
    return 1;
}

sub sequence_name {
    my $dbd = shift;
    my ($class) = @_;

    my $key = $class->properties->{primary_key};
    ## If it's a complex primary key, use the second half.
    if ( ref $key ) {
        $key = $key->[1];
    }

    # mt_tablename_columnname
    return join '_', 'mt',
        $dbd->db_column_name( MT::Object->driver->table_for($class), $key );
}

sub bind_param_attributes {
    my ( $dbd, $data_type ) = @_;
    my $t
        = ref($data_type) eq 'HASH'
        ? $data_type->{type}
        : $data_type;
    if ( $t eq 'blob' ) {
        return { pg_type => DBD::Pg::PG_BYTEA() };
    }
    return;
}

1;
