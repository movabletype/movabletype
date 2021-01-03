# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

# Adapted from DateTime package to avoid requirement of DateTime package.

package MT::DateTime;

use strict;
use warnings;
use Exporter;
@MT::DateTime::ISA = qw( Exporter );
use vars qw( @EXPORT_OK );
@EXPORT_OK = qw( ymd2rd tz_offset_as_seconds );

use MT::Util qw( epoch2ts );

sub new {
    my $class   = shift;
    my (%param) = @_;
    my $self    = \%param;
    bless $self, $class || __PACKAGE__;
}

sub week_year   { ( shift->week )[0] }
sub week_number { ( shift->week )[1] }

sub year      { shift->{year} }
sub month     { shift->{month} }
sub day       { shift->{day} }
sub hour      { shift->{hour} }
sub minute    { shift->{minute} }
sub second    { shift->{second} }
sub time_zone { shift->{time_zone} }

sub day_of_year {
    my $self = shift;
    return $self->{local_c}{day_of_year} if $self->{local_c}{day_of_year};

    my $year = $self->year;
    my $days = 0;

    require MT::Util;
    for ( my $i = 1; $i < $self->month; $i++ ) {
        $days += MT::Util::days_in( $i, $year );
    }
    $days += $self->day;
    $self->{local_c}{day_of_year} = $days;
}

sub week {
    my $self = shift;

    unless ( defined $self->{local_c}{week_year} ) {
        my $jan_one_dow_m1
            = ( ( $self->ymd2rd( $self->year, 1, 1 ) + 6 ) % 7 );

        $self->{local_c}{week_number}
            = int( ( ( $self->day_of_year ) + $jan_one_dow_m1 ) / 7 );
        $self->{local_c}{week_number}++ if $jan_one_dow_m1 < 4;

        if ( $self->{local_c}{week_number} == 0 ) {
            $self->{local_c}{week_year} = $self->year - 1;
            $self->{local_c}{week_number}
                = $self->weeks_in_year( $self->{local_c}{week_year} );
        }
        elsif ($self->{local_c}{week_number} == 53
            && $self->weeks_in_year( $self->year ) == 52 )
        {
            $self->{local_c}{week_number} = 1;
            $self->{local_c}{week_year}   = $self->year + 1;
        }
        else {
            $self->{local_c}{week_year} = $self->year;
        }
    }

    return @{ $self->{local_c} }{ 'week_year', 'week_number' };
}

sub weeks_in_year {
    my $self = shift;
    my $year = shift;

    my $jan_one_dow = ( ( $self->ymd2rd( $year, 1,  1 ) + 6 ) % 7 ) + 1;
    my $dec_31_dow  = ( ( $self->ymd2rd( $year, 12, 31 ) + 6 ) % 7 ) + 1;

    return $jan_one_dow == 4 || $dec_31_dow == 4 ? 53 : 52;
}

sub ymd2rd {
    my $self = shift;

    use integer;
    my ( $y, $m, $d );
    if (@_) {
        ( $y, $m, $d ) = @_;
    }
    elsif ( ref $self ) {
        ( $y, $m, $d ) = ( $self->{year}, $self->{month}, $self->{day} );
    }

    my $adj;

    # make month in range 3..14 (treat Jan & Feb as months 13..14 of
    # prev year)
    if ( $m <= 2 ) {
        $y -= ( $adj = ( 14 - $m ) / 12 );
        $m += 12 * $adj;
    }
    elsif ( $m > 14 ) {
        $y += ( $adj = ( $m - 3 ) / 12 );
        $m -= 12 * $adj;
    }

    # make year positive (oh, for a use integer 'sane_div'!)
    if ( $y < 0 ) {
        $d -= 146097 * ( $adj = ( 399 - $y ) / 400 );
        $y += 400 * $adj;
    }

    # add: day of month, days of previous 0-11 month period that began
    # w/March, days of previous 0-399 year period that began w/March
    # of a 400-multiple year), days of any 400-year periods before
    # that, and 306 days to adjust from Mar 1, year 0-relative to Jan
    # 1, year 1-relative (whew)

    $d
        += ( $m * 367 - 1094 ) / 12
        + $y % 100 * 1461 / 4
        + ( $y / 100 * 36524 + $y / 400 )
        - 306;
}

sub tz_offset_as_seconds {
    my $self   = shift;
    my $offset = shift;
    if ( ref $self ) {
        $offset = $self->{time_zone};
    }

    return undef unless defined $offset;

    return 0 if $offset eq '0';

    my ( $sign, $hours, $minutes, $seconds );
    if ( $offset =~ /^([\+\-])?(\d\d?):(\d\d)(?::(\d\d))?$/ ) {
        ( $sign, $hours, $minutes, $seconds ) = ( $1, $2, $3, $4 );
    }
    elsif ( $offset =~ /^([\+\-])?(\d\d)(\d\d)(\d\d)?$/ ) {
        ( $sign, $hours, $minutes, $seconds ) = ( $1, $2, $3, $4 );
    }
    else {
        return undef;
    }

    $sign = '+' unless defined $sign;
    return undef unless $hours >= 0   && $hours <= 99;
    return undef unless $minutes >= 0 && $minutes <= 59;
    return undef
        unless !defined($seconds) || ( $seconds >= 0 && $seconds <= 59 );

    my $total = $hours * 3600 + $minutes * 60;
    $total += $seconds if $seconds;
    $total *= -1 if $sign eq '-';

    return $total;
}

sub _param2ts {
    my ( $param, $blog ) = @_;

    my ( $type, $value );
    if ( 'HASH' eq ref($param) ) {
        $type  = $param->{type};
        $value = $param->{value};
    }
    else {
        $type  = 'ts';
        $value = $param;
    }
    if ( 'CODE' eq ref($value) ) {
        $value = $value->();
    }

    my $ts;
    if ( 'epoch' eq $type ) {
        $ts = epoch2ts( $blog, $value );
    }
    elsif ( 'datetime' eq $type ) {
        $ts = sprintf "%04d%02d%02d%02d%02d%02d",
            $value->year,
            $value->month,
            $value->day,
            $value->hour,
            $value->minute,
            $value->second;
    }
    else {
        $ts = $value;
    }
    $ts;
}

sub compare {
    my $self  = shift;
    my %param = @_;

    # a => $ts | CODE | { value => CODE|$v, type => ts|epoch|datetime }
    # b => $ts | CODE | { value => CODE|$v, type => ts|epoch|datetime }
    # blog => ref|N|undef
    # comparer => CODE|undef

    my $blog = $param{blog};
    if ( defined($blog) && !ref($blog) ) {
        $blog = MT->model('blog')->load($blog);
        $blog = undef unless ref($blog);
    }

    if ( !exists( $param{a} ) && ref($self) ) {
        $param{a} = { value => $self, type => 'datetime' };
    }
    my $ts_a = _param2ts( $param{a}, $blog );

    if ( !exists( $param{b} ) && ref($self) ) {
        $param{b} = { value => $self, type => 'datetime' };
    }
    my $ts_b = _param2ts( $param{b}, $blog );

    my $comparer = $param{code};
    if ( 'CODE' eq ref($comparer) ) {
        return $comparer->( $ts_a, $ts_b );
    }
    else {
        return $ts_a - $ts_b;
    }
}

1;
__END__

=head1 NAME

MT::DateTime - A utility package for handling date/time values for Movable
Type.

=head1 METHODS

=head2 MT::DateTime->new(%attr)

Constructs a new C<MT::DateTime> object using the values in C<%attr>.
C<%attr> may contain:

=over 4

=item * year

A 4-digit year.

=item * month

Month number, where January is 0.

=item * day

Day number, from 1 to 31.

=item * hour

Hour in 24 hour notation (0-23).

=item * minute

Minutes (0-59).

=item * second

Seconds (0-59).

=item * time_zone

Timezone, in '+HH:MM', '-HH:MM', '+HH', or '-HH' notation.

=back

=head2 compare( a => $a, b => $b, blog => $blog )

Compares two timestamp strings and returns negative valye, 0, or
positive value depending on whether the "a" argument is less than,
equal to, or greater than the "b" argument.

You can specify scalar value to "a" and "b".  They are treated as
timestamp values (e.g. 20080405123456).  You can also specify either
epoch string (e.g the string returned from time method), or C<MT::DateTime>
object.  In those cases, you must specify both value and type in a hash,
for example:

    MT::DateTime->compare( blog => $blog,
        a => '20041231123456', b => { value => time(), type => 'epoch' } );

=head2 $datetime->week_year()

Returns the year for the start of the week for the object.

=head2 $datetime->week_number()

Returns the week number calculated for the object.

=head2 $datetime->year()

Returns the year component of the object.

=head2 $datetime->month()

Returns the month component of the object.

=head2 $datetime->day()

Returns the day component of the object.

=head2 $datetime->hour()

Returns the hours component of the object.

=head2 $datetime->minute()

Returns the minutes component of the object.

=head2 $datetime->second()

Returns the seconds component of the object.

=head2 $datetime->time_zone()

Returns the time zone component of the object.

=head2 $datetime->day_of_year()

Returns the day number of the year of the object.

=head2 $datetime->week()

Returns a list containing the year of the week (C<week_year>) and
the week number (C<week_number>).

=head2 MT::DateTime->weeks_in_year($year)

Returns the number of weeks that are in the specified C<$year>. Returns
either 52 or 53, depending on the year.

=head2 $datetime->ymd2rd( [ $year, $month, $day ])

Converts the given C<$year>, C<$month>, C<$day> (or, if unspecified,
uses the year, month, day elements from C<$datetime>) into a 'Rata Die'
days value.

=head2 $datetime->tz_offset_as_seconds( [$offset] )

Converts the given C<$offset> (or, if absent, uses the time_zone
component of C<$datetime>) into an expression of seconds. I.e.,
an C<$offset> of '-1:30' would yield -5400.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
