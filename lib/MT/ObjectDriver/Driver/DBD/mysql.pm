# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ObjectDriver::Driver::DBD::mysql;

use strict;
use warnings;

use base qw(
    MT::ObjectDriver::Driver::DBD::Legacy
    Data::ObjectDriver::Driver::DBD::mysql
    MT::ErrorHandler
);

sub dsn_from_config {
    my $dbd   = shift;
    my $dsn   = $dbd->SUPER::dsn_from_config(@_);
    my ($cfg) = @_;
    $dsn .= ':database=' . $cfg->Database;
    $dsn .= ';hostname=' . $cfg->DBHost if $cfg->DBHost;
    $dsn .= ';mysql_socket=' . $cfg->DBSocket if $cfg->DBSocket;
    $dsn .= ';port=' . $cfg->DBPort if $cfg->DBPort;
    return $dsn;
}

sub sql_class {
    require MT::ObjectDriver::SQL::mysql;
    return 'MT::ObjectDriver::SQL::mysql';
}

sub ddl_class {
    require MT::ObjectDriver::DDL::mysql;
    return 'MT::ObjectDriver::DDL::mysql';
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

    eval {
        local $@;
        my $sth
            = $dbh->prepare('show variables like "character_set_database"')
            or die "error collecting variables from mysql: " . $dbh->errstr;
        $sth->execute
            or die "error collecting variables from mysql: " . $sth->errstr;
        my $result     = $sth->fetchall_hashref('Variable_name');
        my $charset_db = $result->{character_set_database}{Value};
        if ( defined($charset_db) && ( $charset_db ne 'latin1' ) ) {

            # MySQL 4.1+ and non-latin1(database) == needs SET NAMES call.
            my $c       = lc $cfg->PublishCharset;
            my %Charset = (
                'utf-8'     => $charset_db eq 'utf8mb4' ? 'utf8mb4' : 'utf8',
                'shift_jis' => 'sjis',
                'shift-jis' => 'sjis',
                'euc-jp'    => 'ujis',

                #'iso-8859-1' => 'latin1'
            );
            $c = $Charset{$c} ? $Charset{$c} : $c;
            $dbh->do( "SET NAMES " . $c )
                or return ( $dbh->errstr );
            $dbh->{private_set_names} = $c;
            if ( !defined $set_names ) {

               # SQLSetNames has never been assigned; we had a successful
               # 'SET NAMES' command, so it's safe to SET NAMES in the future.
                $cfg->SQLSetNames(1);
            }
        }
        else {

            # 'set names' command isn't working for this verison of mysql,
            # assign SQLSetNames to 0 to prevent further errors.
            $cfg->SQLSetNames(0);
            return 0;
        }
    };
    1;
}

1;
__END__

=head1 NAME

MT::ObjectDriver::Driver::DBD::mysql

=head1 METHODS

TODO

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
