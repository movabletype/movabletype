package DateTime::Duration;

use strict;

use Params::Validate qw( validate SCALAR );

use overload ( fallback => 1,
               '+'   => '_add_overload',
               '-'   => '_subtract_overload',
               '*'   => '_multiply_overload',
               '<=>' => '_compare_overload',
               'cmp' => '_compare_overload',
             );

use constant MAX_NANOSECONDS => 1_000_000_000;  # 1E9 = almost 32 bits

my @all_units = qw( months days minutes seconds nanoseconds );

sub new
{
    my $class = shift;
    my %p = validate( @_,
                         { years   => { type => SCALAR, default => 0 },
                           months  => { type => SCALAR, default => 0 },
                           weeks   => { type => SCALAR, default => 0 },
                           days    => { type => SCALAR, default => 0 },
                           hours   => { type => SCALAR, default => 0 },
                           minutes => { type => SCALAR, default => 0 },
                           seconds => { type => SCALAR, default => 0 },
                           nanoseconds => { type => SCALAR, default => 0 },
                           end_of_month => { type => SCALAR, default => undef,
                                             regex => qr/^(?:wrap|limit|preserve)$/ },
                         } );

    my $self = bless {}, $class;

    $self->{months} = ( $p{years} * 12 ) + $p{months};

    $self->{days} = ( $p{weeks} * 7 ) + $p{days};

    $self->{minutes} = ( $p{hours} * 60 ) + $p{minutes};

    $self->{seconds} = $p{seconds};

    if ( $p{nanoseconds} )
    {
        $self->{nanoseconds} = $p{nanoseconds};
        $self->_normalize_nanoseconds;
    }
    else
    {
        # shortcut - if they don't need nanoseconds
        $self->{nanoseconds} = 0;
    }

    $self->{end_of_month} =
        ( defined $p{end_of_month}
          ? $p{end_of_month}
          : $self->{months} < 0
          ? 'preserve'
          : 'wrap'
        );

    return $self;
}

# make the signs of seconds, nanos the same; 0 < abs(nanos) < MAX_NANOS
# NB this requires nanoseconds != 0 (callers check this already)
sub _normalize_nanoseconds
{
    my $self = shift;

    return if
        ( $self->{nanoseconds} == DateTime::INFINITY()
          || $self->{nanoseconds} == DateTime::NEG_INFINITY()
          || $self->{nanoseconds} eq DateTime::NAN()
        );

    my $seconds = $self->{seconds} + $self->{nanoseconds} / MAX_NANOSECONDS;
    $self->{seconds} = int( $seconds );
    $self->{nanoseconds} = $self->{nanoseconds} % MAX_NANOSECONDS;
    $self->{nanoseconds} -= MAX_NANOSECONDS if $seconds < 0;
}

sub clone { bless { %{ $_[0] } }, ref $_[0] }

sub years   { abs( $_[0]->in_units( 'years' ) ) }
sub months  { abs( $_[0]->in_units( 'months', 'years' ) ) }
sub weeks   { abs( $_[0]->in_units( 'weeks' ) ) }
sub days    { abs( $_[0]->in_units( 'days', 'weeks' ) ) }
sub hours   { abs( $_[0]->in_units( 'hours' ) ) }
sub minutes { abs( $_[0]->in_units( 'minutes', 'hours' ) ) }
sub seconds { abs( $_[0]->in_units( 'seconds' ) ) }
sub nanoseconds { abs( $_[0]->in_units( 'nanoseconds', 'seconds' ) ) }

sub is_positive {   $_[0]->_has_positive && ! $_[0]->_has_negative }
sub is_negative { ! $_[0]->_has_positive &&   $_[0]->_has_negative }

sub _has_positive { ( grep { $_ > 0 } @{ $_[0] }{@all_units} ) ? 1 : 0}
sub _has_negative { ( grep { $_ < 0 } @{ $_[0] }{@all_units} ) ? 1 : 0 }

sub is_zero       { return 0 if grep { $_ != 0 } @{ $_[0] }{@all_units};
                    return 1 }

sub delta_months  { $_[0]->{months} }
sub delta_days    { $_[0]->{days} }
sub delta_minutes { $_[0]->{minutes} }
sub delta_seconds { $_[0]->{seconds} }
sub delta_nanoseconds { $_[0]->{nanoseconds} }

sub deltas
{
    map { $_ => $_[0]->{$_} } @all_units;
}

sub in_units
{
    my $self  = shift;
    my @units = @_;

    my %units = map { $_ => 1 } @units;

    my %ret;

    my ( $months, $days, $minutes, $seconds ) =
        @{ $self }{qw( months days minutes seconds )};

    if ( $units{years} )
    {
        $ret{years} = int( $months / 12 );
        $months -= $ret{years} * 12;
    }

    if ( $units{months} )
    {
        $ret{months} = $months;
    }

    if ( $units{weeks} )
    {
        $ret{weeks} = int( $days / 7 );
        $days -= $ret{weeks} * 7;
    }

    if ( $units{days} )
    {
        $ret{days} = $days;
    }

    if ( $units{hours} )
    {
        $ret{hours} = int( $minutes / 60 );
        $minutes -= $ret{hours} * 60;
    }
    if ( $units{minutes} )
    {
        $ret{minutes} = $minutes
    }

    if ( $units{seconds} )
    {
        $ret{seconds} = $seconds;
        $seconds = 0;
    }

    if ( $units{nanoseconds} )
    {
        $ret{nanoseconds} = $seconds * MAX_NANOSECONDS + $self->{nanoseconds};
    }

    wantarray ? @ret{@units} : $ret{ $units[0] };
}

sub is_wrap_mode     { $_[0]->{end_of_month} eq 'wrap'   ? 1 : 0 }
sub is_limit_mode    { $_[0]->{end_of_month} eq 'limit'  ? 1 : 0 }
sub is_preserve_mode { $_[0]->{end_of_month} eq 'preserve' ? 1 : 0 }

sub inverse
{
    my $self = shift;

    my %new;
    foreach my $u (@all_units)
    {
        $new{$u} = $self->{$u};
        # avoid -0 bug
        $new{$u} *= -1 if $new{$u};
    }

    return (ref $self)->new(%new);
}

sub add_duration
{
    my ( $self, $dur ) = @_;

    foreach my $u (@all_units)
    {
        $self->{$u} += $dur->{$u};
    }

    $self->_normalize_nanoseconds if $self->{nanoseconds};

    return $self;
}

sub add
{
    my $self = shift;

    return $self->add_duration( (ref $self)->new(@_) );
}

sub subtract_duration { return $_[0]->add_duration( $_[1]->inverse ) }

sub subtract
{
    my $self = shift;

    return $self->subtract_duration( (ref $self)->new(@_) )
}

sub multiply
{
    my $self = shift;
    my $multiplier = shift;

    foreach my $u (@all_units)
    {
        $self->{$u} *= $multiplier;
    }

    $self->_normalize_nanoseconds if $self->{nanoseconds};

    return $self;
}

sub compare
{
    my ( $class, $dur1, $dur2, $dt ) = @_;

    $dt ||= DateTime->now;

    return
        DateTime->compare( $dt->clone->add_duration($dur1), $dt->clone->add_duration($dur2) );
}

sub _add_overload
{
    my ( $d1, $d2, $rev ) = @_;

    ($d1, $d2) = ($d2, $d1) if $rev;

    if ( UNIVERSAL::isa( $d2, 'DateTime' ) )
    {
        $d2->add_duration($d1);
        return;
    }

    # will also work if $d1 is a DateTime.pm object
    return $d1->clone->add_duration($d2);
}

sub _subtract_overload
{
    my ( $d1, $d2, $rev ) = @_;

    ($d1, $d2) = ($d2, $d1) if $rev;

    die "Cannot subtract a DateTime object from a DateTime::Duration object"
        if UNIVERSAL::isa( $d2, 'DateTime' );

    return $d1->clone->subtract_duration($d2);
}

sub _multiply_overload
{
    my $self = shift;

    my $new = $self->clone;

    return $new->multiply(@_);
}

sub _compare_overload
{
    die "DateTime::Duration does not overload comparison.  See the documentation on the compare() method for details.";
}


1;

__END__

=head1 NAME

DateTime::Duration - Duration objects for date math

=head1 SYNOPSIS

  use DateTime::Duration;

  $d = DateTime::Duration->new( years   => 3,
                                months  => 5,
                                weeks   => 1,
                                days    => 1,
                                hours   => 6,
                                minutes => 15,
                                seconds => 45, 
                                nanoseconds => 12000 );

  # Convert to different units
  $d->in_units('days', 'hours', 'seconds');

  # Human-readable accessors, always positive
  $d->years;
  $d->months;
  $d->weeks;
  $d->days;
  $d->hours;
  $d->minutes;
  $d->seconds;
  $d->nanoseconds;

  if ( $d->is_positive ) { ... }
  if ( $d->is_zero )     { ... }
  if ( $d->is_negative ) { ... }

  # The important parts for date math
  $d->delta_months
  $d->delta_days
  $d->delta_minutes
  $d->delta_seconds
  $d->delta_nanoseconds

  my %deltas = $d->deltas

  $d->is_wrap_mode
  $d->is_limit_mode
  $d->is_preserve_mode

  # Multiple all deltas by -1
  my $opposite = $d->inverse;

  my $bigger  = $dur1 + $dur2;
  my $smaller = $dur1 - $dur2; # the result could be negative
  my $bigger  = $dur1 * 3;

  my $base_dt = DateTime->new( year => 2000 );
  my @sorted =
      sort { DateTime::Duration->compare( $a, $b, $base_dt ) } @durations;

=head1 DESCRIPTION

This is a simple class for representing duration objects.  These
objects are used whenever you do date math with DateTime.pm.

See the L<How Date Math is Done|DateTime/"How Date Math is Done">
section of the DateTime.pm documentation for more details.  The short
course:  One cannot in general convert between seconds, minutes, days,
and months, so this class will never do so.  Instead, create the
duration with the desired units to begin with, for example by calling
the appropriate subtraction/delta method on a C<DateTime.pm> object.

=head1 METHODS

Like C<DateTime> itself, C<DateTime::Duration> returns the object from
mutator methods in order to make method chaining possible.

C<DateTime::Duration> has the following methods:

=over 4

=item * new( ... )

This method takes the parameters "years", "months", "weeks", "days",
"hours", "minutes", "seconds", "nanoseconds", and "end_of_month".  All
of these except "end_of_month" are numbers.  If any of the numbers are
negative, the entire duration is negative.

Internally, years as just treated as 12 months.  Similarly, weeks are
treated as 7 days, and hours are converted to minutes.  Seconds and
nanoseconds are both treated separately.

The "end_of_month" parameter must be either "wrap", "limit", or
"preserve".  These specify how changes across the end of a month are
handled.

In "wrap" mode, adding months or years that result in days beyond the
end of the new month will roll over into the following month.  For
instance, adding one year to Feb 29 will result in Mar 1.

If you specify "end_of_month" mode as "limit", the end of the month
is never crossed.  Thus, adding one year to Feb 29, 2000 will result
in Feb 28, 2001.  However, adding three more years will result in Feb
28, 2004, not Feb 29.

If you specify "end_of_month" mode as "preserve", the same calculation
is done as for "limit" except that if the original date is at the end
of the month the new date will also be.  For instance, adding one
month to Feb 29, 2000 will result in Mar 31, 2000.

For positive durations, the "end_of_month" parameter defaults to wrap.
For negative durations, the default is "limit".  This should match how
most people "intuitively" expect datetime math to work.

=item * clone

Returns a new object with the same properties as the object on which
this method was called.

=item * in_units( ... )

Returns the length of the duration in the units (any of those that can
be passed to L<new>) given as arguments.  All lengths are integral,
but may be negative.  Smaller units are computed from what remains
after taking away the larger units given, so for example:

  my $dur = DateTime::Duration->new( years => 1, months => 15 );

  $dur->in_units( 'years' );            # 2
  $dur->in_units( 'months' );           # 27
  $dur->in_units( 'years', 'months' );  # (2, 3)

Note that the numbers returned by this method may not match the values
given to the constructor.

In list context, in_units returns the lengths in the order of the units
given.  In scalar context, it returns the length in the first unit (but
still computes in terms of all given units).

If you need more flexibility in presenting information about
durations, please take a look a C<DateTime::Format::Duration>.

=item * years, months, weeks, days, hours, minutes, seconds, nanoseconds

These methods return numbers indicating how many of the given unit the
object represents, after having taken away larger units.  These
numbers are always positive.  So days is equivalent to C<abs(
in_units( 'days', 'weeks' ) )>.

=item * delta_months, delta_days, delta_minutes, delta_seconds, delta_nanoseconds

These methods provide the same information as those above, but in a
way suitable for doing date math.  The numbers returned may be
positive or negative.  So delta_days is equivalent to
C<in_units('days')>.

=item * deltas

Returns a hash with the keys "months", "days", "minutes", "seconds",
and "nanoseconds", containing all the delta information for the
object.

=item * is_positive, is_zero, is_negative

Indicates whether or not the duration is positive, zero, or negative.

If the duration contains both positive and negative units, then it
will return false for B<all> of these methods.

=item * is_wrap_mode, is_limit_mode, is_preserve_mode

Indicates what mode is used for end of month wrapping.

=item * inverse

Returns a new object with the same deltas as the current object, but
multiple by -1.  The end of month mode for the new object will be the
default end of month mode, which depends on whether the new duration
is positive or negative.

=item * add_duration( $duration_object ), subtract_duration( $duration_object )

Adds or subtracts one duration from another.

=item * add( ... ), subtract( ... )

Syntactic sugar for addition and subtraction.  The parameters given to
these methods are used to create a new object, which is then passed to
C<add_duration()> or C<subtract_duration()>, as appropriate.

=item * multiply( $number )

Multiplies each unit in the by the specified number.

=item * DateTime::Duration->compare( $duration1, $duration2, $base_datetime )

This is a class method that can be used to compare or sort durations.
Comparison is done by adding each duration to the specified
C<DateTime.pm> object and comparing the resulting datetimes.  This is
necessary because without a base, many durations are not comparable.
For example, 1 month may otr may not be longer than 29 days, depending
on what datetime it is added to.

If no base datetime is given, then the result of C<< DateTime->now >>
is used instead.  Using this default will give non-repeatable results
if used to compare two duration objects containing different units.
It will also give non-repeatable results if the durations contain
multiple types of units, such as months and days.

However, if you know that both objects only contain the same units,
and just a single I<type>, then the results of the comparison will be
repeatable.

=back

=head2 Overloading

This class overload addition, subtraction, and mutiplication.

Comparison is B<not> overloaded.  If you attempt to compare durations
using C<< <=> >> or C<cmp>, then an exception will be thrown!  Use the
C<compare()> class method instead.

=head1 SUPPORT

Support for this module is provided via the datetime@perl.org email
list.  See http://lists.perl.org/ for more details.

=head1 AUTHOR

Dave Rolsky <autarch@urth.org>

However, please see the CREDITS file for more details on who I really
stole all the code from.

=head1 COPYRIGHT

Copyright (c) 2003 David Rolsky.  All rights reserved.  This program
is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.

Portions of the code in this distribution are derived from other
works.  Please see the CREDITS file for more details.

The full text of the license can be found in the LICENSE file included
with this module.

=head1 SEE ALSO

datetime@perl.org mailing list

http://datetime.perl.org/

=cut

