# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ObjectDriver::Driver::DBD::SQLite;

use strict;
use warnings;

use Fcntl;
use File::Basename;
use DBI qw(:sql_types);
use DBD::SQLite 1.20;

use base qw(
    MT::ObjectDriver::Driver::DBD::Legacy
    Data::ObjectDriver::Driver::DBD::SQLite
    MT::ErrorHandler
);

sub sql_class {
    require MT::ObjectDriver::SQL::SQLite;
    return 'MT::ObjectDriver::SQL::SQLite';
}

sub ddl_class {
    require MT::ObjectDriver::DDL::SQLite;
    return 'MT::ObjectDriver::DDL::SQLite';
}

sub ts2db {
    sprintf '%04d-%02d-%02d %02d:%02d:%02d', unpack 'A4A2A2A2A2A2', $_[1];
}

sub db2ts {
    my $ts = $_[1];
    $ts =~ s/(?:\+|-)\d{2}$//;
    $ts =~ tr/\- ://d;
    $ts;
}

sub dsn_from_config {
    my $dbd = shift;
    my ($cfg) = @_;

    my $db_file = $cfg->Database;
    require File::Spec;
    if ( !File::Spec->file_name_is_absolute($db_file) ) {
        $db_file = File::Spec->catfile( MT->instance->config_dir, $db_file );
        $cfg->Database($db_file);
    }
    ## This is ugly but necessary. SQLite only creates files with 0644
    ## permissions, so we can't use umask settings to modify those. So
    ## instead, we have to create the file if it doesn't exist in order
    ## to give it the proper permissions.
    unless ( -e $db_file ) {
        my $umask = oct $cfg->DBUmask;
        my $old   = umask($umask);
        local *JUNK;
        sysopen JUNK, $db_file, O_RDWR | O_CREAT, 0666
            or return undef;

#or return $driver->error(MT->translate("Cannot open '[_1]': [_2]", $db_file, $!));
        close JUNK;
        umask($old);
    }
    unless ( -w $db_file ) {
        return undef;

        #return $driver->error(MT->translate(
        #    "Your database file ('[_1]') is not writable.", $db_file));
    }
    my $dir = dirname($db_file);
    unless ( -w $dir ) {
        return undef;

        #return $driver->error(MT->translate(
        #    "Your database directory ('[_1]') is not writable.", $dir));
    }
    'dbi:SQLite:dbname=' . $cfg->Database;
}

sub init_dbh {
    my $dbd = shift;
    my ($dbh) = @_;
    $dbd->SUPER::init_dbh($dbh);
    $dbh->{sqlite_handle_binary_nulls} = 1;
    return $dbh;
}

sub configure {
    my $dbd = shift;
    my ($driver) = @_;
    no warnings 'redefine';
    *MT::ObjectDriver::Driver::DBI::count = \&count;
    $dbd;
}

sub count {
    my $driver = shift;
    my ( $class, $terms, $args ) = @_;

    my @joins = ( $args->{join}, @{ $args->{joins} || [] } );
    my $select = 'COUNT(*)';
    for my $join (@joins) {
        if ( $join && $join->[3]->{unique} ) {
            my $col;
            if ( $join->[3]{unique} =~ m/\D/ ) {
                $col = $args->{join}[3]{unique};
            }
            else {
                $col = $class->properties->{primary_key};
            }
            my $dbcol
                = $driver->dbd->db_column_name( $class->datasource, $col );
            ## the line below is the only difference from the DBI::count method.
            $args->{count_distinct} = { $col => 1 };
        }
    }

    my $result = $driver->_select_aggregate(
        select   => $select,
        class    => $class,
        terms    => $terms,
        args     => $args,
        override => {
            order  => '',
            limit  => undef,
            offset => undef,
        },
    );
    delete $args->{count_distinct};
    $result;
}

1;
__END__

=head1 NAME

MT::ObjectDriver::Driver::DBD::SQLite

=head1 METHODS

TODO

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
