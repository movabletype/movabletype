# $Id: Pg.pm 550 2008-12-22 22:26:14Z ykerherve $

package Data::ObjectDriver::Driver::DBD::Pg;
use strict;
use warnings;

use base qw( Data::ObjectDriver::Driver::DBD );

# No postgresql doesn't allow MySQL's REPLACE INTO syntax 
sub can_replace { 0 }


sub init_dbh {
    my $dbd = shift;
    my($dbh) = @_;
    $dbh->do("set timezone to 'UTC'");
    $dbh;
}

sub bind_param_attributes {
    my ($dbd, $data_type) = @_;
    if ($data_type && $data_type eq 'blob') {
        return { pg_type => DBD::Pg::PG_BYTEA() };
    }
    return;
}

sub sequence_name {
    my $dbd = shift;
    my($class, $driver) = @_;

    my $datasource = $class ->datasource;
    my $prefix     = $driver->prefix;
    $datasource    = join('', $prefix, $datasource) if $prefix;
    join '_', $datasource,
        $dbd->db_column_name($class->datasource, $class->properties->{primary_key}),
        'seq';
}

sub fetch_id {
    my $dbd = shift;
    my($class, $dbh, $sth, $driver) = @_;
    $dbh->last_insert_id(undef, undef, undef, undef,
        { sequence => $dbd->sequence_name($class, $driver) });
}

sub bulk_insert {
    my $dbd = shift;
    my $dbh = shift;
    my $table = shift;

    my $cols = shift;
    my $rows_ref = shift;

    my $sql = "COPY $table (" . join(',', @{$cols}) . ') from stdin';

    $dbh->do($sql);
    foreach my $row (@{$rows_ref}) {
        my $line = join("\t", map {$_ || '\N'} @{$row});
        $dbh->pg_putline($line);
    }
    return $dbh->pg_endcopy();
}

1;
