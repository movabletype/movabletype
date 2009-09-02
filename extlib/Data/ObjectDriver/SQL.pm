# $Id: SQL.pm 564 2009-02-05 00:27:19Z athomason $

package Data::ObjectDriver::SQL;
use strict;
use warnings;

use base qw( Class::Accessor::Fast );

__PACKAGE__->mk_accessors(qw(
    select distinct select_map select_map_reverse
    from joins where bind limit offset group order
    having where_values column_mutator index_hint
    comment
));

sub new {
    my $class = shift;
    my $stmt = $class->SUPER::new(@_);
    $stmt->select([]);
    $stmt->distinct(0);
    $stmt->select_map({});
    $stmt->select_map_reverse({});
    $stmt->bind([]);
    $stmt->from([]);
    $stmt->where([]);
    $stmt->where_values({});
    $stmt->having([]);
    $stmt->joins([]);
    $stmt->index_hint({});
    $stmt;
}

sub add_select {
    my $stmt = shift;
    my($term, $col) = @_;
    $col ||= $term;
    push @{ $stmt->select }, $term;
    $stmt->select_map->{$term} = $col;
    $stmt->select_map_reverse->{$col} = $term;
}

sub add_join {
    my $stmt = shift;
    my($table, $joins) = @_;
    push @{ $stmt->joins }, {
        table => $table,
        joins => ref($joins) eq 'ARRAY' ? $joins : [ $joins ],
    };
}

sub add_index_hint {
    my $stmt = shift;
    my($table, $hint) = @_;
    $stmt->index_hint->{$table} = {
        type => $hint->{type} || 'USE',
        list => ref($hint->{list}) eq 'ARRAY' ? $hint->{list} : [ $hint->{list} ],
    };
}

sub as_sql {
    my $stmt = shift;
    my $sql = '';
    if (@{ $stmt->select }) {
        $sql .= 'SELECT ';
        $sql .= 'DISTINCT ' if $stmt->distinct;
        $sql .= join(', ',  map {
            my $alias = $stmt->select_map->{$_};
            $alias && /(?:^|\.)\Q$alias\E$/ ? $_ : "$_ $alias";
        } @{ $stmt->select }) . "\n";
    }
    $sql .= 'FROM ';

    ## Add any explicit JOIN statements before the non-joined tables.
    my %joined;
    my @from = @{ $stmt->from || [] };
    if ($stmt->joins && @{ $stmt->joins }) {
        my $initial_table_written = 0;
        for my $j (@{ $stmt->joins }) {
            my($table, $joins) = map { $j->{$_} } qw( table joins );
            $table = $stmt->_add_index_hint($table); ## index hint handling
            $sql .= $table unless $initial_table_written++;
            $joined{$table}++;
            for my $join (@{ $j->{joins} }) {
                $sql .= ' ' .
                        uc($join->{type}) . ' JOIN ' . $join->{table} . ' ON ' .
                        $join->{condition};
            }
        }
        @from = grep { ! $joined{ $_ } } @from;
        $sql .= ', ' if @from;
    }

    if (@from) {
        $sql .= join ', ', map { $stmt->_add_index_hint($_) } @from;
    }

    $sql .= "\n";
    $sql .= $stmt->as_sql_where;

    $sql .= $stmt->as_aggregate('group');
    $sql .= $stmt->as_sql_having;
    $sql .= $stmt->as_aggregate('order');

    $sql .= $stmt->as_limit;
    my $comment = $stmt->comment;
    if ($comment && $comment =~ /([ 0-9a-zA-Z.:;()_#&,]+)/) {
        $sql .= "-- $1" if $1;
    }
    return $sql;
}

sub as_limit {
    my $stmt = shift;
    my $n = $stmt->limit or
        return '';
    die "Non-numerics in limit clause ($n)" if $n =~ /\D/;
    return sprintf "LIMIT %d%s\n", $n,
           ($stmt->offset ? " OFFSET " . int($stmt->offset) : "");
}

sub as_aggregate {
    my $stmt = shift;
    my($set) = @_;

    if (my $attribute = $stmt->$set()) {
        my $elements = (ref($attribute) eq 'ARRAY') ? $attribute : [ $attribute ];
        return uc($set) . ' BY '
            . join(', ', map { $_->{column} . ($_->{desc} ? (' ' . $_->{desc}) : '') } @$elements)
                . "\n";
    }

    return '';
}

sub as_sql_where {
    my $stmt = shift;
    $stmt->where && @{ $stmt->where } ?
        'WHERE ' . join(' AND ', @{ $stmt->where }) . "\n" :
        '';
}

sub as_sql_having {
    my $stmt = shift;
    $stmt->having && @{ $stmt->having } ?
        'HAVING ' . join(' AND ', @{ $stmt->having }) . "\n" :
        '';
}

sub add_where {
    my $stmt = shift;
    ## xxx Need to support old range and transform behaviors.
    my($col, $val) = @_;
    Carp::croak("Invalid/unsafe column name $col") unless $col =~ /^[\w\.]+$/;
    my($term, $bind, $tcol) = $stmt->_mk_term($col, $val);
    push @{ $stmt->{where} }, "($term)";
    push @{ $stmt->{bind} }, @$bind;
    $stmt->where_values->{$tcol} = $val;
}

sub add_complex_where {
    my $stmt = shift;
    my ($terms) = @_;
    my ($where, $bind) = $stmt->_parse_array_terms($terms);
    push @{ $stmt->{where} }, $where;
    push @{ $stmt->{bind} }, @$bind;
}

sub _parse_array_terms {
    my $stmt = shift;
    my ($term_list) = @_;

    my @out;
    my $logic = 'AND';
    my @bind;
    foreach my $t ( @$term_list ) {
        if (! ref $t ) {
            $logic = $1 if uc($t) =~ m/^-?(OR|AND|OR_NOT|AND_NOT)$/;
            $logic =~ s/_/ /;
            next;
        }
        my $out;
        if (ref $t eq 'HASH') {
            # bag of terms to apply $logic with
            my @out;
            foreach my $t2 ( keys %$t ) {
                my ($term, $bind, $col) = $stmt->_mk_term($t2, $t->{$t2});
                $stmt->where_values->{$col} = $t->{$t2};
                push @out, $term;
                push @bind, @$bind;
            }
            $out .= '(' . join(" AND ", @out) . ")";
        }
        elsif (ref $t eq 'ARRAY') {
            # another array of terms to process!
            my ($where, $bind) = $stmt->_parse_array_terms( $t );
            push @bind, @$bind;
            $out = '(' . $where . ')';
        }
        push @out, (@out ? ' ' . $logic . ' ' : '') . $out;
    }
    return (join("", @out), \@bind);
}

sub has_where {
    my $stmt = shift;
    my($col, $val) = @_;

    # TODO: should check if the value is same with $val?
    exists $stmt->where_values->{$col};
}

sub add_having {
    my $stmt = shift;
    my($col, $val) = @_;
#    Carp::croak("Invalid/unsafe column name $col") unless $col =~ /^[\w\.]+$/;

    if (my $orig = $stmt->select_map_reverse->{$col}) {
        $col = $orig;
    }

    my($term, $bind) = $stmt->_mk_term($col, $val);
    push @{ $stmt->{having} }, "($term)";
    push @{ $stmt->{bind} }, @$bind;
}

sub _mk_term {
    my $stmt = shift;
    my($col, $val) = @_;
    my $term = '';
    my (@bind, $m);
    if (ref($val) eq 'ARRAY') {
        if (ref $val->[0] or (($val->[0] || '') eq '-and')) {
            my $logic = 'OR';
            my @values = @$val;
            if ($val->[0] eq '-and') {
                $logic = 'AND';
                shift @values;
            }

            my @terms;
            for my $v (@values) {
                my($term, $bind) = $stmt->_mk_term($col, $v);
                push @terms, "($term)";
                push @bind, @$bind;
            }
            $term = join " $logic ", @terms;
        } else {
            $col = $m->($col) if $m = $stmt->column_mutator;
            $term = "$col IN (".join(',', ('?') x scalar @$val).')';
            @bind = @$val;
        }
    } elsif (ref($val) eq 'HASH') {
        my $c = $val->{column} || $col;
        $c = $m->($c) if $m = $stmt->column_mutator;
        $term = "$c $val->{op} ?";
        push @bind, $val->{value};
    } elsif (ref($val) eq 'SCALAR') {
        $col = $m->($col) if $m = $stmt->column_mutator;
        $term = "$col $$val";
    } else {
        $col = $m->($col) if $m = $stmt->column_mutator;
        $term = "$col = ?";
        push @bind, $val;
    }
    ($term, \@bind, $col);
}

sub _add_index_hint {
    my $stmt = shift;
    my ($tbl_name) = @_;
    my $hint = $stmt->index_hint->{$tbl_name};
    return $tbl_name unless $hint && ref($hint) eq 'HASH';
    if ($hint->{list} && @{ $hint->{list} }) {
        return $tbl_name . ' ' . uc($hint->{type} || 'USE') . ' INDEX (' .
                join (',', @{ $hint->{list} }) .
                ')';
    }
    return $tbl_name;
}

1;

__END__

=head1 NAME

Data::ObjectDriver::SQL - an SQL statement

=head1 SYNOPSIS

    my $sql = Data::ObjectDriver::SQL->new();
    $sql->select([ 'id', 'name', 'bucket_id', 'note_id' ]);
    $sql->from([ 'foo' ]);
    $sql->add_where('name',      'fred');
    $sql->add_where('bucket_id', { op => '!=', value => 47 });
    $sql->add_where('note_id',   \'IS NULL');
    $sql->limit(1);

    my $sth = $dbh->prepare($sql->as_sql);
    $sth->execute(@{ $sql->{bind} });
    my @values = $sth->selectrow_array();

    my $obj = SomeObject->new();
    $obj->set_columns(...);

=head1 DESCRIPTION

I<Data::ObjectDriver::SQL> represents an SQL statement. SQL statements are used
internally to C<Data::ObjectDriver::Driver::DBI> object drivers to convert
database operations (C<search()>, C<update()>, etc) into database operations,
but sometimes you just gotta use SQL.

=head1 ATTRIBUTES

I<Data::ObjectDriver::SQL> sports several data attributes that represent the
parts of the modeled SQL statement.  These attributes all have accessor and
mutator methods. Note that some attributes have more convenient methods of
modification (for example, C<add_where()> for the C<where> attribute).

=head2 C<select> (arrayref)

The database columns to select in a C<SELECT> query.

=head2 C<distinct> (boolean)

Whether the C<SELECT> query should return DISTINCT rows only.

=head2 C<select_map> (hashref)

The map of database column names to object fields in a C<SELECT> query. Use
this mapping to convert members of the C<select> list to column names.

=head2 C<select_map_reverse> (hashref)

The map of object fields to database column names in a C<SELECT> query. Use
this map to reverse the C<select_map> mapping where needed.

=head2 C<from> (arrayref)

The list of tables from which to query results in a C<SELECT> query.

Note if you perform a C<SELECT> query with multiple tables, the rows will be
selected as Cartesian products that you'll need to reduce with C<WHERE>
clauses. Your query might be better served with real joins specified through
the C<joins> attribute of your statement.

=head2 C<joins> (arrayref of hashrefs containing scalars and hashrefs)

The list of C<JOIN> clauses to use in the table list of the statement. Each clause is a hashref containing these members:

=over 4

=item * C<table>

The name of the table in C<from> being joined.

=item * C<joins> (arrayref)

The list of joins to perform on the table named in C<table>. Each member of
C<joins> is a hashref containing:

=over 4

=item * C<type>

The type of join to use. That is, the SQL string to use before the word C<JOIN>
in the join expression; for example, C<INNER> or C<NATURAL RIGHT OUTER>). This
member is optional. When not specified, the default plain C<JOIN> join is
specified.

=item * C<table>

The name of the table to which to join.

=item * C<condition>

The SQL expression across which to perform the join, as a string.

=back

=back

=head2 C<where> (arrayref)

The list of C<WHERE> clauses that apply to the SQL statement. Individual
members of the list are strings of SQL. All members of this attribute must be
true for a record to be included as a result; that is, the list members are
C<AND>ed together to form the full C<WHERE> clause.

=head2 C<where_values> (hashref of variant structures)

The set of data structures used to generate the C<WHERE> clause SQL found in
the C<where> attributes, keyed on the associated column names.

=head2 C<bind> (arrayref)

The list of values to bind to the query when performed. That is, the list of
values to be replaced for the C<?>es in the SQL.

=head2 C<limit> (scalar)

The maximum number of results on which to perform the query.

=head2 C<offset> (scalar)

The number of records to skip before performing the query. Combined with a
C<limit> and application logic to increase the offset in subsequent queries,
you can paginate a set of records with a moving window containing C<limit>
records.

=head2 C<group> (hashref, or an arrayref of hashrefs)

The fields on which to group the results. Grouping fields are hashrefs
containing these members:

=over 4

=item * C<column>

Name of the column on which to group.

=back

Note you can set a single grouping field, or use an arrayref containing multiple
grouping fields.

=head2 C<having> (arrayref)

The list of clauses to specify in the C<HAVING> portion of a C<GROUP ...
HAVING> clause. Individual clauses are simple strings containing the
conditional expression, as in C<where>.

=head2 C<order> (hashref, or an arrayref of hashrefs)

Returns or sets the fields by which to order the results. Ordering fields are hashrefs containing these members:

=over 4

=item * C<column>

Name of the column by which to order.

=item * C<desc>

The SQL keyword to use to specify the ordering. For example, use C<DESC> to
specify a descending order. This member is optional.

=back

Note you can set a single ordering field, or use an arrayref containing
multiple ordering fields.

=head2 C<$sql-E<gt>comment([ $comment ])>

Returns or sets a simple comment to the SQL statement

=head1 USAGE

=head2 C<Data::ObjectDriver::SQL-E<gt>new()>

Creates a new, empty SQL statement.

=head2 C<$sql-E<gt>add_select($column [, $term ])>

Adds the database column C<$column> to the list of fields to return in a
C<SELECT> query. The requested object member will be indicated to be C<$term>
in the statement's C<select_map> and C<select_map_reverse> attributes.

C<$term> is optional, and defaults to the same value as C<$column>.

=head2 C<$sql-E<gt>add_join($table, \@joins)>

Adds the join statement indicated by C<$table> and C<\@joins> to the list of
C<JOIN> table references for the statement. The structure for the set of joins
are as described for the C<joins> attribute member above.

=head2 C<$sql-E<gt>add_index_hint($table, $index)>

Specifies a particular index to use for a particular table.

=head2 C<$sql-E<gt>add_where($column, $value)>

Adds a condition on the value of the database column C<$column> to the
statement's C<WHERE> clause. A record will be tested against the below
conditions according to what type of data structure C<$value> is:

=over 4

=item * a scalar

The value of C<$column> must equal C<$value>.

=item * a reference to a scalar

The value of C<$column> must evaluate true against the SQL given in C<$$value>.
For example, if C<$$value> were C<IS NULL>, C<$column> must be C<NULL> for a
record to pass.

=item * a hashref

The value of C<$column> must compare against the condition represented by
C<$value>, which can contain the members:

=over 4

=item * C<value>

The value with which to compare (required).

=item * C<op>

The SQL operator with which to compare C<value> and the value of C<$column>
(required).

=item * C<column>

The column name for the comparison. If this is present, it overrides the
column name C<$column>, allowing you to build more complex conditions
like C<((foo = 1 AND bar = 2) OR (baz = 3))>.

=back

For example, if C<value> were C<NULL> and C<op> were C<IS>, a record's
C<$column> column would have to be C<NULL> to match.

=item * an arrayref of scalars

The value of C<$column> may equal any of the members of C<@$value>. The
generated SQL performs the comparison with as an C<IN> expression.

=item * an arrayref of (mostly) references

The value of C<$column> must compare against I<any> of the expressions
represented in C<@$value>. Each member of the list can be any of the structures
described here as possible forms of C<$value>.

If the first member of the C<@$value> array is the scalar string C<-and>,
I<all> subsequent members of <@$value> must be met for the record to match.
Note this is not very useful unless contained as one option of a larger C<OR>
alternation.

=back

All individual conditions specified with C<add_where()> must be true for a
record to be a result of the query.

Beware that you can create a circular reference that will recursively generate
an infinite SQL statement (for example, by specifying a arrayref C<$value> that
itself contains C<$value>). As C<add_where()> evaluates your expressions before
storing the conditions in the C<where> attribute as a generated SQL string,
this will occur when calling C<add_where()>, not C<as_sql()>. So don't do that.

=head2 C<$sql-E<gt>add_complex_where(\@list)>

This method accepts an array reference of clauses that are glued together with
logical operators. With it, you can express where clauses that mix logical
operators together to produce more complex queries. For instance:

    [ { foo => 1, bar => 2 }, -or => { baz => 3 } ]

The values given for the columns support all the variants documented for the
C<add_where()> method above. Logical operators used inbetween the hashref
elements can be one of: '-or', '-and', '-or_not', '-and_not'.

=head2 C<$sql-E<gt>has_where($column, [$value])>

Returns whether a where clause for the column C<$column> was added to the
statement with the C<add_where()> method.

The C<$value> argument is currently ignored.

=head2 C<$sql-E<gt>add_having($column, $value)>

Adds an expression to the C<HAVING> portion of the statement's C<GROUP ...
HAVING> clause. The expression compares C<$column> using C<$value>, which can
be any of the structures described above for the C<add_where()> method.

=head2 C<$sql-E<gt>add_index_hint($table, \@hints)>

Addes the index hint into a C<SELECT> query. The structure for the set of
C<\@hints> are arrayref of hashrefs containing these members:

=over 4

=item * C<type> (scalar)

The name of the type. "USE", "IGNORE or "FORCE".

=item * C<list> (arrayref)

The list of name of indexes which to use.

=back

=head2 C<$sql-E<gt>as_sql()>

Returns the SQL fully representing the SQL statement C<$sql>.

=head2 C<$sql-E<gt>as_sql_having()>

Returns the SQL representing the C<HAVING> portion of C<$sql>'s C<GROUP ...
HAVING> clause.

=head2 C<$sql-E<gt>as_sql_where()>

Returns the SQL representing C<$sql>'s C<WHERE> clause.

=head2 C<$sql-E<gt>as_limit()>

Returns the SQL for the C<LIMIT ... OFFSET> clause of the statement.

=head2 C<$sql-E<gt>as_aggregate($set)>

Returns the SQL representing the aggregation clause of type C<$set> for the SQL
statement C<$sql>. Reasonable values of C<$set> are C<ORDER> and C<GROUP>.

=head1 DIAGNOSTICS

=over 4

=item * C<Invalid/unsafe column name I<column>>

The column name you specified to C<add_where()> contained characters that are
not allowed in database column names. Only word characters and periods are
allowed. Perhaps you didn't filter punctuation out of a generated column name
correctly.

=back

=head1 BUGS AND LIMITATIONS

I<Data::ObjectDriver::SQL> does not provide the functionality for turning SQL
statements into instances of object classes.

=head1 SEE ALSO

=head1 LICENSE

I<Data::ObjectDriver> is free software; you may redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR & COPYRIGHT

Except where otherwise noted, I<Data::ObjectDriver> is Copyright 2005-2006
Six Apart, cpan@sixapart.com. All rights reserved.

=cut

