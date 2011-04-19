# $Id: BaseObject.pm 418 2007-11-29 18:08:10Z garth $

package Data::ObjectDriver::ResultSet;

## Dependencies

use strict;

use base qw( Class::Accessor::Fast );
use List::Util qw(min);

## Public/_Private Accessors

__PACKAGE__->mk_accessors(qw(
                             class
                             is_finished

                             dod_debug

                             _terms
                             _args
                             _filter_terms
                             _filter_args

                             _cursor
                             _results
                             _results_loaded
                         ));

## Constructors

sub new {
    my $class = shift;
    my ($param) = @_;
    my $self = bless {}, ref $class || $class;

    $self->class($param->{class});

    $self->is_finished(0);
    $self->add_constraint($param->{terms}, $param->{args});

    $self->_cursor(-1);

    return $self;
}

sub iterator {
    my $class = shift;
    my ($objs) = @_;

    my $self = bless {}, ref $class || $class;
    $self->_results($objs);
    $self->_results_loaded(1);
    $self->_cursor(-1);
    $self->is_finished(0);

    return $self;
}

sub clone {
    my $self = shift;

    # note that this is a SHALLOW copy--any values that are references
    # will be shared between the original and the clone
    my $terms = $self->_terms ? { %{$self->_terms} } : {};
    my $args  = $self->_args  ? { %{$self->_args} }  : {};

    my $clone = $self->new({class => $self->class,
                            terms => $terms,
                            args  => $args,
                           });

    # Pull in filtered results if they've been loaded on the original object
    if ($self->_results_loaded) {
        my $res = $self->_load_results;
        $clone->_results([@$res]) if $res;
    }

    return $clone;
}

## Public Instance Methods

sub add_constraint {
    my $self = shift;
    my ($terms, $args) = @_;

    if ($terms) {
        die "First argument to 'add_constraint' must be a hash reference"
          if ref $terms ne 'HASH';

        # Get current terms and any terms we are using as a filter on existing
        # result sets
        my $cur_terms    = $self->_terms || {};
        my $filter_terms = $self->_filter_terms || {};
        foreach my $k (keys %$terms) {
            $self->_results_loaded(0) unless $cur_terms->{$k};
            $cur_terms->{$k} = $terms->{$k};
            $filter_terms->{$k} = 1 if $self->_results_loaded;
        }
        $self->_terms($cur_terms);
        $self->_filter_terms($filter_terms) if $self->_results_loaded;
    }

    if ($args) {
        die "Second argument to 'add_constraint' must be a hash reference"
          if ref $args ne 'HASH';

        my $cur_args    = $self->_args || {};
        my $filter_args = $self->_filter_args || {};
        foreach my $k (keys %$args) {
            my $val = $args->{$k};

            # If we get a limit arg that is bigger than our existing limit (and
            # we *have* an existing limit), then
            # make sure we force a requery.  Same for any filter arguments.
            # Same for offset arg that is  smaller than existing one.
            if ((($k eq 'limit')  and
            ( exists $cur_args->{'limit'} && defined $cur_args->{'limit'} && ($cur_args->{'limit'}||0)  < $val)) or
                (($k eq 'offset') and (($cur_args->{'offset'}||0) > $val)) or
                ($k eq 'filters')) {
                $self->_results_loaded(0);
            }

            $cur_args->{$k} = $val;
            $filter_args->{$k} = 1 if $self->_results_loaded;
        }
        $self->_args($cur_args);
        $self->_filter_args($filter_args) if $self->_results_loaded;
    }

    return 1;
}

sub clear_constraint {
    my $self = shift;
    my ($term_names, $arg_names) = @_;

    my $terms = $self->_terms;
    if ($term_names and $terms) {
        die "First argument to 'clear_constraint' must be an array reference"
          if ref $term_names ne 'ARRAY';

        foreach my $n (@$term_names) {
            if (delete $terms->{$n}) {
                $self->_results_loaded(0);
            }
        }
    }

    my $args = $self->_args;
    if ($arg_names and $args) {
        die "Second argument to 'clear_constraint' must be an array reference"
          if ref $arg_names ne 'ARRAY';

        foreach my $n (@$arg_names) {
            # If we get a limit arg that is bigger than our existing limit, then
            # make sure we force a requery.  Same for any filter arguments.
            # Same for offset arg that is  smaller than existing one.
            if (($n eq 'limit')  and (($args->{'limit'}||0)  > 0) or
                ($n eq 'offset') and (($args->{'offset'}||0) > 0) or
                ($n eq 'filters')) {
                $self->_results_loaded(0);
            }
            delete $args->{$n};
        }
    }

    return 1;
}

sub add_term        { shift->add_constraint($_[0])                    }
sub clear_term      { shift->clear_constraint(\@_)                    }
sub get_term        { my $self = shift;
                      $self->_terms && $self->_terms->{$_[0]}         }

sub add_limit       { shift->add_constraint(undef, {limit => $_[0]})  }
sub clear_limit     { shift->clear_constraint(undef, ['limit'])       }
sub get_limit       { my $self = shift;
                      $self->_args && $self->_args->{limit}           }

sub add_offset      { shift->add_constraint(undef, {offset => $_[0]}) }
sub clear_offset    { shift->clear_constraint(undef, ['offset'])      }
sub get_offset      { my $self = shift;
                      $self->_args && $self->_args->{offset}          }

sub add_order       { shift->add_constraint(undef, {sort => $_[0]})   }
sub clear_order     { shift->clear_constraint(undef, ['sort'])        }
sub get_order       { my $self = shift;
                      $self->_args && $self->_args->{sort}           }

sub add_filters     { shift->add_constraint(undef, {filters => $_[0]}) }
sub clear_filters   { shift->clear_constraint(undef, ['filters'])      }
sub get_filters     { my $self = shift;
                      $self->_args && $self->_args->{filters}          }
sub index {
    my $self = shift;

    return $self->_cursor;
}

sub next {
    my $self = shift;

    return if $self->is_finished;

    $self->_cursor($self->_cursor + 1);

    # Load the results and return an object
    my $results = $self->_load_results;

    my $obj = $results->[$self->_cursor];

    if ($obj) {
        return $obj;
    } else {
        $self->is_finished(1);
        return;
    }
}

# look at next() without incrementing the cursor
# like if you just want to see what's coming down the road at you
sub peek_next {
    my $self = shift;

    return if $self->is_finished;

    # Load the results and return an object
    my $results = $self->_load_results;

    my $obj = $results->[$self->_cursor + 1];

    return $obj;
}



sub prev {
    my $self = shift;

    $self->_cursor($self->_cursor - 1);

    # Boundary check
    return if $self->_cursor == -1;

    # Load the results and return an object
    my $results = $self->_load_results;

    my $obj = $results->[$self->_cursor];
    if ($obj) {
        return $obj;
    } else {
        return;
    }
}

sub curr {
    my $self = shift;

    return $self->_load_results->[$self->_cursor];
}

sub slice {
    my $self = shift;
    my ($start, $end) = @_;

    # Do we already have results?
    if ($self->_results) {
        return [ @{ $self->_results }[$start..min($self->count-1, $end)] ];
    }

    my $limit = $end - $start + 1;

    $self->add_offset($start);
    $self->add_limit($limit);

    my $r = $self->_load_results;

    return $r;
}

sub all {
    my $self = shift;

    return unless $self->count;

    my @obj;
    push @obj, $self->first;
    while (my $obj = $self->next) {
        push @obj, $obj;
    }

    $self->rewind;
    return @obj;
}

sub count {
    my $self = shift;

    # Get/load the results if we already have them
    if ($self->_results_loaded or $self->get_limit) {
        my $results = $self->_load_results;
        return scalar @$results;
    } else {
        local $Data::ObjectDriver::DEBUG = 1 if $self->dod_debug;
        return $self->class->count($self->_terms, $self->_args);
    }
}

sub first {
    my $self = shift;

    # Clear is finished in case they are comming back from the last element
    $self->is_finished(0);
    $self->_cursor(0);

    my $results = $self->_load_results;

    my $obj = $results->[$self->_cursor];
    if ($obj) {
        return $obj;
    } else {
        return;
    }
}

sub last {
    my $self = shift;
    my $results;

    $results = $self->_load_results;
    $self->_cursor($#$results);

    return $results->[$self->_cursor];
}

sub is_last {
    my $self = shift;
    my $results = $self->_load_results;
    return (scalar @{$results} == $self->_cursor + 1) ? 1 : 0;
}

## Private Instance Methods

sub _filtered_results {
    my $self = shift;
    my $results      = $self->_results;
    my $filter_terms = $self->_filter_terms;
    my $filter_args  = $self->_filter_args;

    # Return right away if we don't have any new filters
    return $results unless $filter_terms or $filter_args;

    my $new_results;

    # Check terms
    if ($filter_terms) {
        while (my $obj = shift @$results) {
            push @$new_results, $obj if $self->_in_terms_filter($obj);
        }
    } else {
        $new_results = $results;
    }

    # Check args
    if ($filter_args) {
        if ($filter_args->{sort}) {
            @$new_results = sort { $self->_dod_sort($a, $b) } @$new_results;
        }

        # See if we've got a new limit and offset
        if ($filter_args->{offset}) {
            my $offset = $self->_args->{offset};
            splice @$new_results, 0, $offset;
        }

        if ($filter_args->{limit}) {
            my $limit = $self->_args->{limit};
            if (scalar @$new_results > $limit) {
                # Truncate the array
                splice @$new_results, $limit, $#$new_results;
            }
        }
    }

    $self->_filter_terms(undef);
    $self->_filter_args(undef);

    $self->_results($new_results);

    return $new_results;
}

sub _dod_sort {
    my $self = shift;
    my ($a, $b) = @_;
    my $sort = $self->_args->{sort};

    foreach my $order_data (@$sort) {
        my $col = $order_data->{column};
        my $dir = $order_data->{direction};
        my $result;

        $result = ($dir eq 'ascend') ? $a->$col cmp $b->$col
                                     : $b->$col cmp $a->$col;

        # Return the sort result unless they are the same
        return $result unless $result == 0;
    }

    return 0;
}

sub _in_terms_filter {
    my $self = shift;
    my ($obj) = @_;

    # Always matches filter if we don't have any filters
    return 1 unless $self->_filter_terms;

    if ($self->_filter_terms) {
        # Look through each filter
        foreach my $key (keys %{$self->_filter_terms}) {
            # If something doesn't match return with undef
            if ($obj->$key ne $self->_terms->{$key}) {
                return;
            }
        }
    }

    return 1;
}

sub _load_results {
    my $self = shift;

    # If results are already loaded, see if they need to be filtered and return
    # them
    if ($self->_results_loaded) {
        my $results = $self->_filtered_results;

        return $self->_results;
    }

    # An iterator only ResultSet doesn't have a class (or any paramaters for
    # that matter) so don't try to search for anything.
    return unless $self->class;

    local $Data::ObjectDriver::DEBUG = 1 if $self->dod_debug;
    my @r = $self->class->search($self->_terms, $self->_args);

    $self->_results(\@r);
    $self->_results_loaded(1);

    return \@r;
}

sub rewind {
    my $self = shift;
    $self->is_finished(0);
    $self->_cursor(-1);
    return $self;
}
1;

__END__

=pod

=head1 NAME

Data::ObjectDriver::ResultSet - Manage a DB query

=head1 SYNOPSIS

    # Get a resultset object for Object::Widget, which inherits from
    # Data::ObjectDriver::BaseObject
    my $result = Object::Widget->result($terms, $args);

    $result->add_term({color => 'blue'});

    $result->add_limit(10);
    $result->add_offset(100);

    while (not $result->is_empty) {
        my $widget = $result->next;

        # Do stuff with $widget
    }

=head1 DESCRIPTION

This object is returned by the 'result' method found in the L<Data::ObjectDriver::BaseObject> class.  This object manages a query and the resulting data.  It
allows additional search terms and arguments to be added and will not submit the
query until a method that returns data is called.  By passing this object around
code in multiple places can alter the query easily until the data is needed.

Once a method returning data is called (L<next>, L<count>, etc) the query is
submitted to the database and the returned data is managed by the ResultSet
object like an iterator.

=head1 METHODS

=head2 $result_set = $class->result($terms, $args)

This method is actually defined in L<Data::ObjectDriver::BaseObject> but it is
the way a new ResultSet object is created.

Arguments:

=over 4

=item I<$terms> - A hashref.  Same format as the first argument to Data::ObjectDriver::DBI::search

=item I<$args> - A hashref.  Same format as the second argument to Data::ObjectDriver::DBI::search

=back

Return value:

This method returns a Data::ObjectDriver::ResultSet object

=head2 $new_result = Data::ObjectDriver::ResultSet->iterator(\@data)

Create a new result set object that takes existing data and operates only as an
iterator, without any of the query managment.

Arguments:

=over 4

=item $data - An array ref of data elements

=back

Return value:

A L<Data::ObjectDriver::ResultSet> object

=head2 add_constraint

Apply a constraint to the result.  The format of the two arguments is the same as for Data::ObjectDriver::DBI::search

Arguments:

=over 4

=item $terms - A hashref of object fields and values constraining them.  Same as first parameter to I<result> method.

=item $args - A hashref of values that affect the returned data, such as limit and sort by.  Same as first parameter to I<result> method.

=back

; Return value
: Returns I<1> if successful and I<0> otherwise

; Notes
: Do we fail if called after we've retrieved the result set?  Ignore it?  Requery?

; Example

  $res->add_constraint({object_id => $id}, {limit => 100})

=head2 add_term

Apply a single search term to the result.  Equivalent to:

  $res->add_constraint($terms)

Arguments:

=over 4

=item $terms - A hashref of object fields and values constraining them

=back

; Return value
: Returns I<1> if successful and I<0> otherwise

; Notes
: Same question as for I<add_constraint>

; Example

  $res->add_term({object_id => $id})

=head2 clear_term

Clear a single search term from the result.

Arguments:

=over 4

=item @terms - An array of term names to clear

=back

; Return value
: Returns I<1> if successful and I<0> otherwise

; Notes
: I<none>

; Example

  $res->clear_term(qw(limit offset))

=head2 add_limit

Apply a limit to the result.  Equivalent to:

  $res->add_constraint({}, {limit => $limit})

Arguments:

=over 4

=item $limit - A scalar numeric value giving the limit of the number of objects returned

=back

; Return value
: Returns I<1> if successful and I<0> otherwise

; Notes
:

; Example

  $res->add_limit(100)

=head2 clear_limit

Clear any limit value in the result.

Arguments:

=over 4

=item I<none>

=back

; Return value
: Returns I<1> if successful and I<0> otherwise

; Notes
: I<None>

; Example

  $res->clear_limit

=head2 add_offset

Add an offset for the results returned.  Result set must also have a limit set at some point.

Arguments:

=over 4

=item $offset - A scalar numeric value giving the offset for the first object returned

=back

; Return value
: Returns I<1> if successful and I<0> otherwise

; Notes
: I<none>

; Example

  $res->add_offset(5_000)

=head2 clear_offset

Clear any offset value in the result.

Arguments:

=over 4

=item I<none>

=back

; Return value
: Returns I<1> if successful and I<0> otherwise

; Notes
:

; Example

  $res->clear_offset

=head2 add_order

Add a sort order for the results returned.

Arguments:

=over 4

=item [0] = $order = I< - A scalar string value giving the sort order for the results, one of I<ascend> or I<descend>>

=back

; Return value
: Returns I<1> if successful and I<0> otherwise

; Notes
: >none''

; Example

  $res->add_order('ascend')

=head2 clear_order

Clear any offset value in the result.

Arguments:

=over 4

=item I<none>

=back

; Return value
: Returns I<1> if successful and I<0> otherwise

; Notes
: I<none>

; Example

  $res->clear_order

=head2 index

Return the current index into the result set.

Arguments:

=over 4

=item I<none>

=back

; Return value
: An integer giving the zero based index of the current element in the result set.

; Notes
: I<none>

; Example

  $idx = $res->index;

=head2 next

Retrieve the next item in the resultset

Arguments:

=over 4

=item I<none>

=back

; Return value
: The next object or undef if past the end of the result set

; Notes
: Calling this method will force a DB query.  All subsequent calls to I<curr> will return this object

; Example

  $obj = $res->next;

=head2 peek_next

Retrieve the next item in the resultset WITHOUT advancing the cursor.

Arguments:

=over 4

=item I<none>

=back

; Return value
: The next object or undef if past the end of the result set

; Notes
: Calling this method will force a DB query.  All subsequent calls to I<curr> will return this object

; Example

  while ($bottle = $res->next){

      if ($bottle->type eq 'Bud Light'
          && $res->peek_next->type eq 'Chimay'){

          $bottle->pass; #don't spoil my palate

      }else{
          $bottle->drink;
      }
  }


=head2 prev

Retrieve the previous item in the result set

Arguments:

=over 4

=item I<none>

=back

; Return value
: The previous object or undef if before the beginning of the result set

; Notes
: All subsequent calls to I<curr> will return this object

; Example

  $obj = $res->prev;

=head2 curr

Retrieve the current item in the result set.  This item is set by calls to I<next> and I<prev>

Arguments:

=over 4

=item I<none>

=back

; Return value
: The current object or undef if past the boundaries of the result set

; Notes
: I<none>

; Example

  $obj = $res->curr

=head2 slice

Return a slice of the result set.  This is logically equivalent to setting a limit and offset and then retrieving all the objects via I<->next>.  If you call I<slice> and then call I<next>, you will get I<undef> and additionally I<is_empty> will be true.

Arguments:

=over 4

=item $from - Scalar integer giving the start of the slice range

=item $to - Scalar integer giving the end of the slice range

=back

; Return value
: An array of objects

; Notes
: Objects are index from 0 just like perl arrays.

; Example

  my @objs = $res->slice(0, 20)

=head2 count

Get the count of the items in the result set.

Arguments:

=over 4

=item I<none>

=back

; Return value
: A scalar count of the number of items in the result set

; Notes
: This will cause a count() query on the database if the result set hasn't been retrieved yet.  If the result set has been retrieved it will just return the number of objects stored in the result set object.

; Example

  $num = $res->count

=head2 is_finished

Returns whether we've arrived at the end of the result set

Arguments:

=over 4

=item I<none>

=back

; Return value
: Returns I<1> if we are finished iterating though the result set and I<0> otherwise

; Notes
: I<none>

; Example

  while (not $res->is_finished) {
      my $obj = $res->next;
      # Stuff ...
  }

=head2 dod_debug

Set this and you'll see $Data::ObjectDriver::DEBUG output when
I go to get the results.

=head2 rewind

Move back to the start of the iterator for this instance of results of a query.

=head2 first

Returns the first object in the result set.

Arguments:

=over 4

=item I<none>

=back

; Return value
: The first object in the result set

; Notes
: Resets the current cursor so that calls to I<curr> return this value.

; Example

  $obj = $res->first

=head2 last

Returns the last object in the result set.

Arguments:

=over 4

=item I<none>

=back

; Return value
: The last object in the result set

; Notes
: Resets the current cursor so that calls to I<curr> return this value.

; Example

  $obj = $res->last

=head2 is_last

Returns 1 if the cursor is on the last row of the result set, 0 if it is not.

Arguments:

=over 4

=item I<none>

=back

; Return value
: Returns I<1> if the cursor is on the last row of the result set, I<0> if it is not.

; Example

  if ( $res->is_last ) {
     ## do some stuff
  }

=cut

