# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ObjectDriver::SQL;

#--------------------------------------#
# Dependencies

use strict;
use warnings;

use base qw( Data::ObjectDriver::SQL );

#--------------------------------------#
# Class Accessors

my @ACCESSORS
    = qw( transform range range_incl lob_columns date_columns not null not_null like distinct from_stmt binary );
__PACKAGE__->mk_accessors(@ACCESSORS);

#--------------------------------------#
# Class Methods

sub new {
    my $class = shift;
    my %param = @_;

    my %data;
    @data{@ACCESSORS} = delete @param{@ACCESSORS};

    my $stmt = $class->SUPER::new(%param);

    for my $field (@ACCESSORS) {
        next if $field eq 'distinct';
        next if $field eq 'from_stmt';
        $stmt->$field( defined $data{$field} ? { %{ $data{$field} } } : {} );
    }
    $stmt->distinct( $data{distinct} || 0 );
    if ( defined $data{from_stmt} ) {
        $stmt->from_stmt( $data{from_stmt} );
    }

    $stmt;
}

sub ts2db {
    return unless $_[0];
    if ( $_[0] =~ m{ \A \d{4} - }xms ) {
        return $_[0];
    }
    my $ret = sprintf '%04d-%02d-%02d %02d:%02d:%02d', unpack 'A4A2A2A2A2A2',
        $_[0];
    return $ret;
}

sub distinct_stmt {
    my $class = shift;
    my ($stmt) = @_;
    $stmt;
}

# This method will be used in Postgres and MSSQLServer
sub _subselect_distinct {
    my $class = shift;
    my ($stmt) = @_;
    ## If we're doing a SELECT DISTINCT, postgres would have us include
    ## the order field, which means the DISTINCT isn't what we want--so
    ## let's do a subselect.
    my $subselect = $class->new;
    $subselect->from_stmt($stmt);
    $subselect->select( [ @{ $stmt->select } ] );

    #for my $col (@{ $subselect->select }) {
    #    $col = $driver->dbd->fix_subselect_column($col); ## FIXME
    #}
    $subselect->select_map( { %{ $stmt->select_map } } );
    for my $col ( keys %{ $subselect->select_map } ) {
        my $new_col = $col;

        #$new_col = $driver->dbd->fix_subselect_column($new_col); ## FIXME
        $subselect->select_map->{$new_col}
            = delete $subselect->select_map->{$col};
    }
    $subselect->bind( [ @{ $stmt->bind } ] );
    $subselect->distinct(1);

    $stmt->distinct(0);
    $subselect;
}

#--------------------------------------#
# Instance Methods

sub as_sql {
    my $stmt = shift;
    my $sql  = '';

    my $old_sel;
    if ( @{ $stmt->select } ) {
        $old_sel = $stmt->select;

        $sql = 'SELECT ';
        if ( $stmt->distinct ) {
            $sql .= 'DISTINCT ';
        }
        $sql .= join( ', ', @{ $stmt->select } ) . "\n";
        $stmt->select( [] );
    }

    if ( $stmt->from_stmt ) {
        $sql
            .= 'FROM ('
            . $stmt->from_stmt->as_sql(@_)
            . ") t\n";    # t is the subquery alias
    }
    else {
        $sql .= $stmt->SUPER::as_sql(@_);

        ## Check if we generated an unbounded query for mt_session, since we're seeing those in production.
        ## TODO: remove this. Or generalize it into query auditing.
        ## my @from_tbls = @{ $stmt->from };
        ## if (1 == scalar @from_tbls && $from_tbls[0] eq 'mt_session') {
        ##     if (!$stmt->where || !@{ $stmt->where } || $sql !~ m{ where }xmsi) {
        ##         MT->log({
        ##             message => Carp::longmess("Generated unbounded query on mt_session [$sql]"),
        ##             level => MT::Log::DEBUG()
        ##         });
        ##     }
        ## }
    }

    $stmt->select($old_sel) if $old_sel;
    return $sql;
}

sub _mk_term {
    my $stmt = shift;
    my ( $col, $val ) = @_;

    $col =~ s/ \A [\w\.]+? \. //x;

    ## Any last-minute property -> field name manipulation
    if ( my $m = $stmt->column_mutator ) {
        $col = $m->($col);
    }

    if ( ref $val eq 'HASH' ) {
        if ( !exists $val->{op} ) {

            # hash-style value, containing hints on operation
            if ( exists $val->{like} ) {
                $val = { op => 'LIKE', value => $val->{like} };
            }
            if ( exists $val->{not_like} ) {
                $val = { op => 'NOT LIKE', value => $val->{not_like} };
            }
            elsif ( exists $val->{not_null} ) {
                $val = \'is not null';
            }
            elsif ( exists $val->{not} ) {
                my $v = $val->{not};
                if ( 'ARRAY' eq ref($v) ) {
                    if ( my $transformed_column = $stmt->transform->{$col} ) {
                        $col = $transformed_column;
                    }
                    my $term
                        = $col
                        . ' NOT IN ('
                        . join( ',', ('?') x scalar @$v ) . ')';
                    return ( $term, $v, $col );
                }
                elsif ( ref $v ) {
                    die "Unsupported value in 'not' column";
                }
                else {
                    $val = {
                        value => $v,
                        op    => '!='
                    };
                }
            }
            elsif ( exists $val->{between} ) {
                my $low  = @{ $val->{between} }[0];
                my $high = @{ $val->{between} }[1];
                if ( $stmt->date_columns->{$col} ) {
                    $low  = ts2db($low);
                    $high = ts2db($high);
                }
                $val = [
                    '-and',
                    { op => '>=', value => $low },
                    { op => '<=', value => $high }
                ];
            }
            elsif ( exists $val->{'>='} ) {
                $val = { op => '>=', value => $val->{'>='} };
            }
            elsif ( exists $val->{'>'} ) {
                $val = { op => '>', value => $val->{'>'} };
            }
            elsif ( exists $val->{'<='} ) {
                $val = { op => '<=', value => $val->{'<='} };
            }
            elsif ( exists $val->{'<'} ) {
                $val = { op => '<', value => $val->{'<'} };
            }
            elsif ( exists $val->{'!='} ) {
                $val = { op => '!=', value => $val->{'!='} };
            }
        }

        ## Translate dates from app to database format.
        if ( ( $stmt->date_columns->{$col} ) && ( ref($val) eq 'HASH' ) ) {
            my $v = $val->{value};
            if ( ref($v) eq 'ARRAY' ) {
                $v->[$_] = ts2db( $v->[$_] ) for @$v;
            }
            else {
                $val->{value} = ts2db($v);
            }
        }
    }
    else {
        ## Rearrange the value into an inclusive range.
        my $range_incl = $stmt->range_incl;
        my $range      = $stmt->range;

        ## We may recurse, so let us empty range inclusions in our scope.
        local $range_incl->{$col} = $range_incl->{$col};
        local $range->{$col}      = $range->{$col};
        if ( $range_incl->{$col} || $range->{$col} ) {
            my ( $lt, $gt )
                = $range_incl->{$col} ? ( '<=', '>=' ) : ( '<', '>' );
            my @vals;

            my ( $first_val, $last_val ) = @$val;
            if ( $stmt->date_columns->{$col} ) {
                $first_val = ts2db($first_val) if defined $first_val;
                $last_val  = ts2db($last_val)  if defined $last_val;
            }

            ## Ignore first value if it's undef (right-bounded range, eg [undef, 20050101000000] )
            if ( defined $first_val ) {
                push @vals, { op => $gt, value => $first_val };
            }
            ## Ignore last value if it's defined (left-bounded range, eg [20050101000000] )
            if ( defined $last_val ) {
                push @vals, { op => $lt, value => $last_val };
            }
            if ( 2 == scalar @vals ) {
                $val = [ '-and', @vals ];
            }
            else {
                ($val) = @vals;
            }

            ## Because the new value is an arrayref, we're about to get
            ## called recursively with each of those hashrefs inside it.
            ## So ignore that we're using an inclusive range within this
            ## call's scope.
            undef(
                $range_incl->{$col} ? $range_incl->{$col} : $range->{$col} );
        }

        ## Translate dates from app to database format.
        if ( $stmt->date_columns->{$col} ) {
            if ( ref($val) eq 'HASH' ) {
                my $v = $val->{value};
                if ( ref($v) eq 'ARRAY' ) {
                    $v->[$_] = ts2db( $v->[$_] ) for @$v;
                }
                else {
                    $val->{value} = ts2db($v);
                }
            }
            elsif ( !ref($val) ) {
                $val = ts2db($val);
            }
        }

        if ( $stmt->not->{$col} ) {
            if ( 'ARRAY' eq ref($val) ) {
                if ( my $transformed_column = $stmt->transform->{$col} ) {
                    $col = $transformed_column;
                }
                my $term
                    = $col
                    . ' NOT IN ('
                    . join( ',', ('?') x scalar @$val ) . ')';
                return ( $term, $val, $col );
            }
            elsif ( ref $val ) {
                die "Unsupported value in 'not' column";
            }
            else {
                $val = {
                    value => $val,
                    op    => '!=',
                };
            }
        }

        if ( $stmt->null->{$col} ) {
            $val = \'is null';
        }

        if ( $stmt->not_null->{$col} ) {
            $val = \'is not null';
        }

        if ( $stmt->like->{$col} ) {
            if ( ref($val) eq 'HASH' ) {
                $val->{op} = 'LIKE';
            }
            elsif ( !ref($val) ) {
                $val = {
                    op    => 'LIKE',
                    value => $val,
                };
            }
        }
    }

    ## Transformation modifies the column name, so it should be last.
    if ( my $transformed_column = $stmt->transform->{$col} ) {
        $col = $transformed_column;
    }

    ## Prevent D::OD from re-mutating, since we've done it here
    local $stmt->{column_mutator} = undef;

    $stmt->SUPER::_mk_term( $col, $val );
}

sub field_decorator {
    my $stmt = shift;
    my ($class) = @_;
    return sub {
        my ($term) = @_;
        my $field_prefix = $class->datasource;
        for my $col ( @{ $class->column_names } ) {
            $term =~ s/\b$col\b/${field_prefix}_$col/g;
        }
        return $term;
    };
}

sub as_limit {
    my $stmt = shift;
    my $n    = $stmt->limit;

    # Support offset without limit
    my $o = $stmt->offset || 0;
    $n = 2147483647 if !$n && $o;
    return '' unless $n;
    die "Non-numerics in limit/offset clause ($n, $o)"
        if ( $n =~ /\D/ ) || ( $o =~ /\D/ );
    return sprintf "LIMIT %d%s\n", $n, ( $o ? " OFFSET " . int($o) : "" );
}

sub add_freetext_where {0}

sub as_aggregate {
    my $stmt = shift;
    my ($set) = @_;

    if ( my $attribute = $stmt->$set() ) {
        my $elements
            = ( ref($attribute) eq 'ARRAY' ) ? $attribute : [$attribute];
        foreach (@$elements) {

            # Remove column alias
            if ( $_->{column} =~ /^([\w_\-\.]+\(.+\))+\s+AS\s+.+$/i ) {
                $_->{column} = $1;
            }
        }
        return
            uc($set) . ' BY '
            . join( ', ',
            map { $_->{column} . ( $_->{desc} ? ( ' ' . $_->{desc} ) : '' ) }
                @$elements )
            . "\n";
    }

    return '';
}

1;
__END__

=head1 NAME

MT::ObjectDriver::SQL

=head1 METHODS

TODO

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
