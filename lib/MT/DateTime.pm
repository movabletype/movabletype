# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$
# Adapted from DateTime package to avoid requirement of DateTime package.

package MT::DateTime;

use Exporter;
@MT::DateTime::ISA = qw( Exporter );
use vars qw( @EXPORT_OK );
@EXPORT_OK = qw( ymd2rd tz_offset_as_seconds );

sub new {
    my $class = shift;
    my (%param) = @_;
    my $self = \%param;
    bless $self, $class || __PACKAGE__;
}

sub week_year { (shift->week)[0] }
sub week_number { (shift->week)[1] }

sub year { shift->{year} }
sub month { shift->{month} }
sub day { shift->{day} }
sub hour { shift->{hour} }
sub minute { shift->{minute} }
sub second { shift->{second} }
sub time_zone { shift->{time_zone} }

sub day_of_year {
    my $self = shift;
    return $self->{local_c}{day_of_year} if $self->{local_c}{day_of_year};

    my $year = $self->year;
    my $days = 0;

    require MT::Util;
    for (my $i = 1; $i < $self->month; $i++) {
        $days += MT::Util::days_in($i, $year);
    }
    $days += $self->day;
    $self->{local_c}{day_of_year} = $days;
}

sub week {
    my $self = shift;

    unless ( defined $self->{local_c}{week_year} ) {
        my $jan_one_dow_m1 =
            ( ( $self->ymd2rd( $self->year, 1, 1 ) + 6 ) % 7 );

        $self->{local_c}{week_number} =
            int( ( ( $self->day_of_year) + $jan_one_dow_m1 ) / 7 );
        $self->{local_c}{week_number}++ if $jan_one_dow_m1 < 4;

        if ( $self->{local_c}{week_number} == 0 ) {
            $self->{local_c}{week_year} = $self->year - 1;
            $self->{local_c}{week_number} =
                $self->weeks_in_year( $self->{local_c}{week_year} );
        }
        elsif ( $self->{local_c}{week_number} == 53 &&
                $self->weeks_in_year( $self->year ) == 52 )
        {
            $self->{local_c}{week_number} = 1;
            $self->{local_c}{week_year} = $self->year + 1;
        }
        else
        {
            $self->{local_c}{week_year} = $self->year;
        }
    }

    return @{ $self->{local_c} }{ 'week_year', 'week_number' }
}

sub weeks_in_year {
    my $self = shift;
    my $year = shift;
    
    my $jan_one_dow =
        ( ( $self->ymd2rd( $year, 1, 1 ) + 6 ) % 7 ) + 1;
    my $dec_31_dow =
        ( ( $self->ymd2rd( $year, 12, 31 ) + 6 ) % 7 ) + 1;

    return $jan_one_dow == 4 || $dec_31_dow == 4 ? 53 : 52;
}

sub ymd2rd {
    my $self = shift;

    use integer;
    my ( $y, $m, $d );
    if (@_) {
        ( $y, $m, $d ) = @_;
    } elsif (ref $self) {
        ( $y, $m, $d ) = ( $self->{year}, $self->{month}, $self->{day} );
    }

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

sub tz_offset_as_seconds {   
    my $self = shift;
    my $offset = shift; 
    if (ref $self) {
        $offset = $self->{time_zone};
    }

    return undef unless defined $offset;

    return 0 if $offset eq '0';
        
    my ( $sign, $hours, $minutes, $seconds );
    if ( $offset =~ /^([\+\-])?(\d\d?):(\d\d)(?::(\d\d))?$/ )
    {
        ( $sign, $hours, $minutes, $seconds ) = ( $1, $2, $3, $4 );
    }
    elsif ( $offset =~ /^([\+\-])?(\d\d)(\d\d)(\d\d)?$/ )
    {
        ( $sign, $hours, $minutes, $seconds ) = ( $1, $2, $3, $4 );
    }   
    else
    {       
        return undef;
    }
        
    $sign = '+' unless defined $sign;
    return undef unless $hours >= 0 && $hours <= 99;
    return undef unless $minutes >= 0 && $minutes <= 59;
    return undef unless ! defined( $seconds ) || ( $seconds >= 0 && $seconds <= 59 );    
        
    my $total =  $hours * 3600 + $minutes * 60;
    $total += $seconds if $seconds;
    $total *= -1 if $sign eq '-';

    return $total;
}

1;
