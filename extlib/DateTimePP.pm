package DateTime;

use strict;

require DateTimePPExtra;

my @MonthLengths =
    ( 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 );

my @LeapYearMonthLengths = @MonthLengths;
$LeapYearMonthLengths[1]++;

my @EndOfLastMonthDayOfYear;
{
    my $x = 0;
    foreach my $length (@MonthLengths)
    {
        push @EndOfLastMonthDayOfYear, $x;
        $x += $length;
    }
}

my @EndOfLastMonthDayOfLeapYear = @EndOfLastMonthDayOfYear;
$EndOfLastMonthDayOfLeapYear[$_]++ for 2..11;

sub _time_as_seconds
{
    shift;
    my ( $hour, $min, $sec ) = @_;

    $hour ||= 0;
    $min ||= 0;
    $sec ||= 0;

    my $secs = $hour * 3600 + $min * 60 + $sec;
    return $secs;
}

sub _rd2ymd
{
    my $class = shift;

    use integer;
    my $d = shift;
    my $rd = $d;

    my $yadj = 0;
    my ( $c, $y, $m );

    # add 306 days to make relative to Mar 1, 0; also adjust $d to be
    # within a range (1..2**28-1) where our calculations will work
    # with 32bit ints
    if ( $d > 2**28 - 307 )
    {
        # avoid overflow if $d close to maxint
        $yadj = ( $d - 146097 + 306 ) / 146097 + 1;
        $d -= $yadj * 146097 - 306;
    }
    elsif ( ( $d += 306 ) <= 0 )
    {
        $yadj =
          -( -$d / 146097 + 1 );    # avoid ambiguity in C division of negatives
        $d -= $yadj * 146097;
    }

    $c = ( $d * 4 - 1 ) / 146097;   # calc # of centuries $d is after 29 Feb of yr 0
    $d -= $c * 146097 / 4;          # (4 centuries = 146097 days)
    $y = ( $d * 4 - 1 ) / 1461;     # calc number of years into the century,
    $d -= $y * 1461 / 4;            # again March-based (4 yrs =~ 146[01] days)
    $m = ( $d * 12 + 1093 ) / 367;  # get the month (3..14 represent March through
    $d -= ( $m * 367 - 1094 ) / 12; # February of following year)
    $y += $c * 100 + $yadj * 400;   # get the real year, which is off by
    ++$y, $m -= 12 if $m > 12;      # one if month is January or February

    if ( $_[0] )
    {
        my $dow;

        if ( $rd < -6 )
        {
            $dow = ( $rd + 6 ) % 7;
            $dow += $dow ? 8 : 1;
        }
        else
        {
            $dow = ( ( $rd + 6 ) % 7 ) + 1;
        }

        my $doy =
            $class->_end_of_last_month_day_of_year( $y, $m );

        $doy += $d;

        my $quarter;
        {
            no integer;
            $quarter = int( ( 1 / 3.1 ) * $m ) + 1;
        }

        my $qm = ( 3 * $quarter ) - 2;

        my $doq =
            ( $doy -
              $class->_end_of_last_month_day_of_year( $y, $qm )
            );

        return ( $y, $m, $d, $dow, $doy, $quarter, $doq );
    }

    return ( $y, $m, $d );
}

sub _ymd2rd
{
    shift; # ignore class

    use integer;
    my ( $y, $m, $d ) = @_;
    my $adj;

    # make month in range 3..14 (treat Jan & Feb as months 13..14 of
    # prev year)
    if ( $m <= 2 )
    {
        $y -= ( $adj = ( 14 - $m ) / 12 );
        $m += 12 * $adj;
    }
    elsif ( $m > 14 )
    {
        $y += ( $adj = ( $m - 3 ) / 12 );
        $m -= 12 * $adj;
    }

    # make year positive (oh, for a use integer 'sane_div'!)
    if ( $y < 0 )
    {
        $d -= 146097 * ( $adj = ( 399 - $y ) / 400 );
        $y += 400 * $adj;
    }

    # add: day of month, days of previous 0-11 month period that began
    # w/March, days of previous 0-399 year period that began w/March
    # of a 400-multiple year), days of any 400-year periods before
    # that, and 306 days to adjust from Mar 1, year 0-relative to Jan
    # 1, year 1-relative (whew)

    $d += ( $m * 367 - 1094 ) / 12 + $y % 100 * 1461 / 4 +
          ( $y / 100 * 36524 + $y / 400 ) - 306;
}

sub _seconds_as_components
{
    shift;
    my $secs = shift;
    my $utc_secs = shift;

    use integer;

    my $hour = $secs / 3600;
    $secs -= $hour * 3600;

    my $minute = $secs / 60;

    my $second = $secs - ( $minute * 60 );

    if ( $utc_secs && $utc_secs >= 86400 )
    {
        # there is no such thing as +3 or more leap seconds!
        die "Invalid UTC RD seconds value: $utc_secs"
            if $utc_secs > 86401;

        $second += $utc_secs - 86400 + 60;

        $minute  = 59;

        $hour--;
        $hour = 23 if $hour < 0;
    }

    return ( $hour, $minute, $second );
}

sub _end_of_last_month_day_of_year
{
    my $class = shift;

    my ($y, $m) = @_;
    $m--;
    return
        ( $class->_is_leap_year($y) ?
          $EndOfLastMonthDayOfLeapYear[$m] :
          $EndOfLastMonthDayOfYear[$m]
        );
}

sub _is_leap_year
{
    shift;
    my $year = shift;

    if ($year % 400 == 0)
    {
        return 1;
    }
    elsif ($year % 100 == 0)
    {
        return 0;
    }
    elsif ($year % 4 == 0)
    {
        return 1;
    }

    return 0;
}

sub _day_length { DateTime::LeapSecond::day_length($_[1]) }

sub _leap_seconds { DateTime::LeapSecond::leap_seconds($_[1]) }


1;
