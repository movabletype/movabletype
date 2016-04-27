# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ObjectDriver::SQL::mysql;

use strict;
use warnings;
use base qw( MT::ObjectDriver::SQL );

sub new {
    my $class = shift;
    my %param = @_;
    my $sql   = $class->SUPER::new(%param);
    if ( my $cols = $sql->binary ) {
        foreach my $col ( keys %$cols ) {
            my $t = $sql->transform->{$col};
            if ( $t && ( $t =~ /\)$/ ) ) {
                $sql->transform->{$col} = 'binary ' . $t;
            }
            elsif ($t) {
                $sql->transform->{$col} = "$t($col)";
            }
            else {
                $sql->transform->{$col} = "binary($col)";
            }
            $sql->transform->{ $col . '__NOBINARY' } = $col;
        }
    }
    return $sql;
}

sub _mk_term {
    my $stmt = shift;
    my ( $col, $val ) = @_;

    if ( my $transform = $stmt->transform ) {
        my ( $table_name, $col_name ) = $col =~ m{ \A mt_(\w+)\.(\w+) }xms;
        if ($table_name) {
            my $key = join( '_', $table_name, $col_name );
            if ( $transform->{ $key . '__NOBINARY' } ) {
                $stmt->add_where( $col . '__NOBINARY', $val );
            }
        }
    }
    return $stmt->SUPER::_mk_term(@_);
}

sub add_freetext_where {
    my $stmt = shift;
    my ( $columns, $search_string ) = @_;
    my $col = 'MATCH(' . join( ', ', @$columns ) . ')';
    my $term = "($col AGAINST(? IN BOOLEAN MODE))";
    push @{ $stmt->{where} }, "($term)";
    push @{ $stmt->{bind} },  $search_string;
    $stmt->where_values->{$col} = $search_string;
}

sub _parse_array_terms {
    my $stmt = shift;
    my ($term_list) = @_;

    foreach my $term (@$term_list) {
        if ( ref $term eq 'HASH' ) {
            foreach my $key ( keys %$term ) {
                if ( ref $term->{$key} eq 'HASH' ) {
                    if ( $term->{$key}->{not_like} ) {
                        my @array = ( $term->{$key}, \'IS NULL' );
                        $term->{$key} = \@array;
                    }
                }
            }
        }
    }

    return $stmt->SUPER::_parse_array_terms($term_list);
}

sub as_sql {
    my $stmt = shift;

    if ( $stmt->distinct && $stmt->order ) {
        my $attribute = $stmt->order;
        my $elements
            = ( ref($attribute) eq 'ARRAY' ) ? $attribute : [$attribute];
        if ( @{ $stmt->select } ) {
            foreach my $element ( @{$elements} ) {
                unless (
                    List::Util::first { $_ eq $element->{column} }
                    @{ $stmt->select }
                    )
                {
                    $stmt->add_select( $element->{column} );
                }
            }
        }
        else {
            foreach my $element ( @{$elements} ) {
                $stmt->add_select( $element->{column} );
            }
        }
    }

    return $stmt->SUPER::as_sql(@_);
}

1;
