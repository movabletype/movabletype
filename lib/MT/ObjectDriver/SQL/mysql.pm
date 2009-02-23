# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::ObjectDriver::SQL::mysql;

use strict;
use warnings;
use base qw( MT::ObjectDriver::SQL );

sub new {
    my $class = shift;
    my %param = @_;
    my $sql = $class->SUPER::new(%param);
    if (my $cols = $sql->binary) {
        foreach my $col (keys %$cols) {
            my $t = $sql->transform->{$col};
            if ($t && ($t=~ /\)$/)) {
                $sql->transform->{$col} = 'binary ' . $t;
            } elsif ($t) {
                $sql->transform->{$col} = "$t($col)";
            } else {
                $sql->transform->{$col} = "binary($col)";
            }
            $sql->transform->{$col . '__NOBINARY'} = $col;
        }
    }
    return $sql;
}

sub _mk_term {
    my $stmt = shift;
    my ($col, $val) = @_;

    if ( my $transform = $stmt->transform ) {
        my ($table_name, $col_name) = $col =~ m{ \A mt_(\w+)\.(\w+) }xms;
        if ( $table_name ) {
            my $key = join( '_', $table_name, $col_name );
            if ( $transform->{$key . '__NOBINARY'} ) {
                $stmt->add_where($col . '__NOBINARY', $val);
            }
        }
    }
    return $stmt->SUPER::_mk_term(@_);
}

sub add_freetext_where {
    my $stmt = shift;
    my ( $columns, $search_string ) = @_;
    my $col = 'MATCH(' . join(', ', @$columns) . ')';
    my $term = "($col AGAINST(? IN BOOLEAN MODE))";
    push @{ $stmt->{where} }, "($term)";
    push @{ $stmt->{bind} }, $search_string;
    $stmt->where_values->{$col} = $search_string;
}

1;
