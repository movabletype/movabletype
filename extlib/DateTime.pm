package DateTime;

use strict;

use vars qw($VERSION);


BEGIN
{
    $VERSION = '0.21';

    my $loaded = 0;
    unless ( $ENV{PERL_DATETIME_PP} )
    {
	eval
	{
	    if ( $] >= 5.006 )
	    {
		require XSLoader;
		XSLoader::load( 'DateTime', $DateTime::VERSION );
	    }
	    else
	    {
		require DynaLoader;
		@DateTime::ISA = 'DynaLoader';
		DateTime->bootstrap( $DateTime::VERSION );
	    }
	};

	die $@ if $@ && $@ !~ /object version/;

        $loaded = 1 unless $@;
    }

    if ($loaded)
    {
        require DateTimePPExtra
            unless defined &DateTime::_normalize_tai_seconds;
    }
    else
    {
        require DateTimePP;
    }
}

use DateTime::Duration;
use DateTime::Locale;
use DateTime::TimeZone;
use Params::Validate qw( validate validate_pos SCALAR BOOLEAN HASHREF OBJECT );
use Time::Local ();

# for some reason, overloading doesn't work unless fallback is listed
# early.
#
# 3rd parameter ( $_[2] ) means the parameters are 'reversed'.
# see: "Calling conventions for binary operations" in overload docs.
#
use overload ( 'fallback' => 1,
               '<=>' => '_compare_overload',
               'cmp' => '_compare_overload',
               '""'  => 'iso8601',
               '-'   => '_subtract_overload',
               '+'   => '_add_overload',
             );

# Have to load this after overloading is defined, after BEGIN blocks
# or else weird crashes ensue
require DateTime::Infinite;

use constant MAX_NANOSECONDS => 1_000_000_000;  # 1E9 = almost 32 bits

use constant INFINITY     =>       100 ** 100 ** 100 ;
use constant NEG_INFINITY => -1 * (100 ** 100 ** 100);
use constant NAN          => INFINITY - INFINITY;

my( @MonthLengths, @LeapYearMonthLengths );

BEGIN
{
    @MonthLengths =
        ( 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 );

    @LeapYearMonthLengths = @MonthLengths;
    $LeapYearMonthLengths[1]++;
}

{
    # I'd rather use Class::Data::Inheritable for this, but there's no
    # way to add the module-loading behavior to an accessor it
    # creates, despite what its docs say!
    my $DefaultLocale;
    sub DefaultLocale
    {
        my $class = shift;

        if (@_)
        {
            my $lang = shift;

            DateTime::Locale->load($lang);

            $DefaultLocale = $lang;
        }

        return $DefaultLocale;
    }
    # backwards compat
    *DefaultLanguage = \&DefaultLocale;
}
__PACKAGE__->DefaultLocale('en_US');

my $BasicValidate =
    { year   => { type => SCALAR },
      month  => { type => SCALAR, default => 1,
                  callbacks =>
                  { 'is between 1 and 12' =>
                    sub { $_[0] >= 1 && $_[0] <= 12 }
                  },
                },
      day    => { type => SCALAR, default => 1,
                  callbacks =>
                  { 'is a possible valid day of month' =>
                    sub { $_[0] >= 1 && $_[0] <= 31 }
                  },
                },
      hour   => { type => SCALAR, default => 0,
                  callbacks =>
                  { 'is between 0 and 23' =>
                    sub { $_[0] >= 0 && $_[0] <= 23 },
                  },
                },
      minute => { type => SCALAR, default => 0,
                  callbacks =>
                  { 'is between 0 and 59' =>
                    sub { $_[0] >= 0 && $_[0] <= 59 },
                  },
                },
      second => { type => SCALAR, default => 0,
                  callbacks =>
                  { 'is between 0 and 61' =>
                    sub { $_[0] >= 0 && $_[0] <= 61 },
                  },
                },
      nanosecond => { type => SCALAR, default => 0,
                      callbacks =>
                      { 'cannot be negative' =>
                        sub { $_[0] >= 0 },
                      }
                    },
      locale    => { type => SCALAR | OBJECT,
                     default => undef },
      language  => { type => SCALAR | OBJECT,
                     optional => 1 },
    };

my $NewValidate =
    { %$BasicValidate,
      time_zone => { type => SCALAR | OBJECT,
                     default => 'floating' },
    };

sub new
{
    my $class = shift;
    my %p = validate( @_, $NewValidate );

    die "Invalid day of month (day = $p{day} - month = $p{month})\n"
        if $p{day} > $class->_month_length( $p{year}, $p{month} );

    my $self = {};

    $p{locale} = delete $p{language} if exists $p{language};
    $p{locale} = $class->DefaultLocale unless defined $p{locale};

    if ( ref $p{locale} )
    {
        $self->{locale} = $p{locale};
    }
    else
    {
        $self->{locale} = DateTime::Locale->load( $p{locale} );
    }

    $self->{tz} =
        ( ref $p{time_zone} ?
          $p{time_zone} :
          DateTime::TimeZone->new( name => $p{time_zone} )
        );

    $self->{local_rd_days} =
        $class->_ymd2rd( @p{ qw( year month day ) } );

    $self->{local_rd_secs} =
        $class->_time_as_seconds( @p{ qw( hour minute second ) } );

    $self->{rd_nanosecs} = $p{nanosecond};

    bless $self, $class;

    $self->_normalize_nanoseconds( $self->{local_rd_secs}, $self->{rd_nanosecs} );

    # Set this explicitly since it can't be calculated accurately
    # without knowing our time zone offset, and it's possible that the
    # offset can't be calculated without having at least a rough guess
    # of the datetime's year.  This year need not be correct, as long
    # as its equal or greater to the correct number, so we fudge by
    # adding one to the local year given to the constructor.
    $self->{utc_year} = $p{year} + 1;

    $self->_calc_utc_rd;
    $self->_calc_local_rd;

    if ( $p{second} > 59 )
    {
        if ( $self->{tz}->is_floating ||
             # If true, this means that the actual calculated leap
             # second does not occur in the second given to new()
             ( $self->{utc_rd_secs} - 86399
               <
               $p{second} - 59 )
           )
        {
            die "Invalid second value ($p{second})\n";
        }
    }

    return $self;
}

sub _calc_utc_rd
{
    my $self = shift;

    delete $self->{utc_c};

    if ( $self->{tz}->is_utc || $self->{tz}->is_floating )
    {
        $self->{utc_rd_days} = $self->{local_rd_days};
        $self->{utc_rd_secs} = $self->{local_rd_secs};
    }
    else
    {
        $self->{utc_rd_days} = $self->{local_rd_days};
        $self->{utc_rd_secs} =
            $self->{local_rd_secs} - $self->_offset_from_local_time;
    }

    $self->_normalize_seconds;
}

sub _normalize_seconds
{
    my $self = shift;

    return if $self->{utc_rd_secs} >= 0 && $self->{utc_rd_secs} <= 86399;

    if ( $self->{tz}->is_floating )
    {
        $self->_normalize_tai_seconds( $self->{utc_rd_days}, $self->{utc_rd_secs} );
    }
    else
    {
        $self->_normalize_leap_seconds( $self->{utc_rd_days}, $self->{utc_rd_secs} );
    }
}

sub _calc_local_rd
{
    my $self = shift;

    delete $self->{local_c};

    # We must short circuit for UTC times or else we could end up with
    # loops between DateTime.pm and DateTime::TimeZone
    if ( $self->{tz}->is_utc || $self->{tz}->is_floating )
    {
        $self->{local_rd_days} = $self->{utc_rd_days};
        $self->{local_rd_secs} = $self->{utc_rd_secs};
    }
    else
    {
        $self->{local_rd_days} = $self->{utc_rd_days};
        $self->{local_rd_secs} = $self->{utc_rd_secs} + $self->offset;

        # intentionally ignore leap seconds here
        $self->_normalize_tai_seconds( $self->{local_rd_days}, $self->{local_rd_secs} );
    }

    $self->_calc_local_components;
}

sub _calc_local_components
{
    my $self = shift;

    @{ $self->{local_c} }{ qw( year month day day_of_week
                               day_of_year quarter day_of_quarter) } =
        $self->_rd2ymd( $self->{local_rd_days}, 1 );

    @{ $self->{local_c} }{ qw( hour minute second ) } =
        $self->_seconds_as_components( $self->{local_rd_secs}, $self->{utc_rd_secs} );
}

sub _calc_utc_components
{
    my $self = shift;

    $self->_calc_utc_rd unless defined $self->{utc_rd_days};

    @{ $self->{utc_c} }{ qw( year month day ) } =
        $self->_rd2ymd( $self->{utc_rd_days} );

    @{ $self->{utc_c} }{ qw( hour minute second ) } =
        $self->_seconds_as_components( $self->{utc_rd_secs} );
}

sub _utc_ymd
{
    my $self = shift;

    $self->_calc_utc_components unless exists $self->{utc_c}{year};

    return @{ $self->{utc_c} }{ qw( year month day ) };
}

sub _utc_hms
{
    my $self = shift;

    $self->_calc_utc_components unless exists $self->{utc_c}{hour};

    return @{ $self->{utc_c} }{ qw( hour minute second ) };
}

sub from_epoch
{
    my $class = shift;
    my %p = validate( @_,
                      { epoch => { type => SCALAR },
                        locale     => { type => SCALAR | OBJECT, optional => 1 },
                        language   => { type => SCALAR | OBJECT, optional => 1 },
                        time_zone  => { type => SCALAR | OBJECT, optional => 1 },
                      }
                    );

    my %args;

    # Because epoch may come from Time::HiRes
    my $fraction = $p{epoch} - int( $p{epoch} );
    $args{nanosecond} = int( $fraction * MAX_NANOSECONDS )
        if $fraction;

    # Note, for very large negative values this may give a blatantly
    # wrong answer.
    @args{ qw( second minute hour day month year ) } =
        ( gmtime( int delete $p{epoch} ) )[ 0..5 ];
    $args{year} += 1900;
    $args{month}++;

    my $self = $class->new( %p, %args, time_zone => 'UTC' );

    $self->set_time_zone( $p{time_zone} ) if exists $p{time_zone};

    return $self;
}

# use scalar time in case someone's loaded Time::Piece
sub now { shift->from_epoch( epoch => (scalar time), @_ ) }

sub today { shift->now(@_)->truncate( to => 'day' ) }

sub from_object
{
    my $class = shift;
    my %p = validate( @_,
                      { object => { type => OBJECT,
                                    can => 'utc_rd_values',
                                  },
                        locale     => { type => SCALAR | OBJECT, optional => 1 },
                        language   => { type => SCALAR | OBJECT, optional => 1 },
                      },
                    );

    my $object = delete $p{object};

    my ( $rd_days, $rd_secs, $rd_nanosecs ) = $object->utc_rd_values;

    # A kludge because until all calendars are updated to return all
    # three values, $rd_nanosecs could be undef
    $rd_nanosecs ||= 0;

    my %args;
    @args{ qw( year month day ) } = $class->_rd2ymd($rd_days);
    @args{ qw( hour minute second ) } = $class->_seconds_as_components($rd_secs);
    $args{nanosecond} = $rd_nanosecs;

    my $new = $class->new( %p, %args, time_zone => 'UTC' );

    if ( $object->can('time_zone') )
    {
        $new->set_time_zone( $object->time_zone );
    }
    else
    {
        $new->set_time_zone( 'floating' );
    }

    return $new;
}

my $LastDayOfMonthValidate = { %$NewValidate };
foreach ( keys %$LastDayOfMonthValidate )
{
    my %copy = %{ $LastDayOfMonthValidate->{$_} };

    delete $copy{default};
    $copy{optional} = 1 unless $_ eq 'year' || $_ eq 'month';

    $LastDayOfMonthValidate->{$_} = \%copy;
}

sub last_day_of_month
{
    my $class = shift;
    my %p = validate( @_, $LastDayOfMonthValidate );

    my $day = $class->_month_length( $p{year}, $p{month} );

    return $class->new( %p, day => $day );
}

sub _month_length
{
    return ( $_[0]->_is_leap_year( $_[1] ) ?
             $LeapYearMonthLengths[ $_[2] - 1 ] :
             $MonthLengths[ $_[2] - 1 ]
           );
}

my $FromDayOfYearValidate = { %$NewValidate };
foreach ( keys %$FromDayOfYearValidate )
{
    next if $_ eq 'month' || $_ eq 'day';

    my %copy = %{ $FromDayOfYearValidate->{$_} };

    delete $copy{default};
    $copy{optional} = 1 unless $_ eq 'year' || $_ eq 'month';

    $FromDayOfYearValidate->{$_} = \%copy;
}
$FromDayOfYearValidate->{day_of_year} =
    { type => SCALAR,
      callbacks =>
      { 'is between 1 and 366' =>
        sub { $_[0] >= 1 && $_[0] <= 366 }
      }
    };
sub from_day_of_year
{
    my $class = shift;
    my %p = validate( @_, $FromDayOfYearValidate );

    my $is_leap_year = $class->_is_leap_year( $p{year} );

    die "$p{year} is not a leap year.\n"
        if $p{day_of_year} == 366 && ! $is_leap_year;

    my $month = 1;
    my $day = delete $p{day_of_year};

    while ( $month <= 12 && $day > $class->_month_length( $p{year}, $month ) )
    {
        $day -= $class->_month_length( $p{year}, $month );
        $month++;
    }

    return DateTime->new( %p,
                          month => $month,
                          day   => $day,
                        );
}

sub clone { bless { %{ $_[0] } }, ref $_[0] }

sub year    { $_[0]->{local_c}{year} }

sub ce_year { $_[0]->{local_c}{year} <= 0 ?
              $_[0]->{local_c}{year} - 1 :
              $_[0]->{local_c}{year} }

sub era { $_[0]->ce_year > 0 ? 'CE' : 'BCE' }

sub year_with_era { (abs $_[0]->ce_year) . $_[0]->era }

sub month   { $_[0]->{local_c}{month} }
*mon = \&month;

sub month_0 { $_[0]->{local_c}{month} - 1 };
*mon_0 = \&month_0;

sub month_name { $_[0]->{locale}->month_name( $_[0] ) }

sub month_abbr { $_[0]->{locale}->month_abbreviation( $_[0] ) }

sub day_of_month { $_[0]->{local_c}{day} }
*day  = \&day_of_month;
*mday = \&day_of_month;

sub weekday_of_month { use integer; ( ( $_[0]->day - 1 ) / 7 ) + 1 }

sub quarter {$_[0]->{local_c}{quarter} };

sub day_of_month_0 { $_[0]->{local_c}{day} - 1 }
*day_0  = \&day_of_month_0;
*mday_0 = \&day_of_month_0;

sub day_of_week { $_[0]->{local_c}{day_of_week} }
*wday = \&day_of_week;
*dow  = \&day_of_week;

sub day_of_week_0 { $_[0]->{local_c}{day_of_week} - 1 }
*wday_0 = \&day_of_week_0;
*dow_0  = \&day_of_week_0;

sub day_name { $_[0]->{locale}->day_name( $_[0] ) }

sub day_abbr { $_[0]->{locale}->day_abbreviation( $_[0] ) }

sub day_of_quarter { $_[0]->{local_c}{day_of_quarter} }
*doq = \&day_of_quarter;

sub day_of_quarter_0 { $_[0]->day_of_quarter - 1 }
*doq_0 = \&day_of_quarter_0;

sub day_of_year { $_[0]->{local_c}{day_of_year} }
*doy = \&day_of_year;

sub day_of_year_0 { $_[0]->{local_c}{day_of_year} - 1 }
*doy_0 = \&day_of_year_0;

sub ymd
{
    my ( $self, $sep ) = @_;
    $sep = '-' unless defined $sep;

    return sprintf( "%0.4d%s%0.2d%s%0.2d",
                    $self->year, $sep,
                    $self->{local_c}{month}, $sep,
                    $self->{local_c}{day} );
}
*date = \&ymd;

sub mdy
{
    my ( $self, $sep ) = @_;
    $sep = '-' unless defined $sep;

    return sprintf( "%0.2d%s%0.2d%s%0.4d",
                    $self->{local_c}{month}, $sep,
                    $self->{local_c}{day}, $sep,
                    $self->year );
}

sub dmy
{
    my ( $self, $sep ) = @_;
    $sep = '-' unless defined $sep;

    return sprintf( "%0.2d%s%0.2d%s%0.4d",
                    $self->{local_c}{day}, $sep,
                    $self->{local_c}{month}, $sep,
                    $self->year );
}

sub hour   { $_[0]->{local_c}{hour} }
sub hour_1 { $_[0]->{local_c}{hour} + 1 }

sub hour_12   { my $h = $_[0]->hour % 12; return $h ? $h : 12 }
sub hour_12_0 { $_[0]->hour % 12 }

sub minute { $_[0]->{local_c}{minute} }
*min = \&minute;

sub second { $_[0]->{local_c}{second} }
*sec = \&second;

sub fractional_second { $_[0]->second + $_[0]->nanosecond / MAX_NANOSECONDS }

sub nanosecond { $_[0]->{rd_nanosecs} }

sub millisecond { _round( $_[0]->{rd_nanosecs} / 1000000 ) }

sub microsecond { _round( $_[0]->{rd_nanosecs} / 1000 ) }

sub _round
{
    my $val = shift;
    my $int = int $val;

    return $val - $int >= 0.5 ? $int + 1 : $int;
}

sub leap_seconds
{
    my $self = shift;

    return 0 if $self->{tz}->is_floating;

    return DateTime->_leap_seconds( $self->{utc_rd_days} );
}

sub hms
{
    my ( $self, $sep ) = @_;
    $sep = ':' unless defined $sep;

    return sprintf( "%0.2d%s%0.2d%s%0.2d",
                    $self->{local_c}{hour}, $sep,
                    $self->{local_c}{minute}, $sep,
                    $self->{local_c}{second} );
}
# don't want to override CORE::time()
*DateTime::time = \&hms;

sub iso8601 { join 'T', $_[0]->ymd('-'), $_[0]->hms(':') }
*datetime = \&iso8601;

sub is_leap_year { $_[0]->_is_leap_year( $_[0]->year ) }

sub week
{
    my $self = shift;

    unless ( defined $self->{local_c}{week_year} )
    {
        # This algorithm was taken from Date::Calc's DateCalc.c file
        my $jan_one_dow_m1 =
            ( ( $self->_ymd2rd( $self->year, 1, 1 ) + 6 ) % 7 );

        $self->{local_c}{week_number} =
            int( ( ( $self->day_of_year - 1 ) + $jan_one_dow_m1 ) / 7 );
        $self->{local_c}{week_number}++ if $jan_one_dow_m1 < 4;

        if ( $self->{local_c}{week_number} == 0 )
        {
            $self->{local_c}{week_year} = $self->year - 1;
            $self->{local_c}{week_number} =
                $self->_weeks_in_year( $self->{local_c}{week_year} );
        }
        elsif ( $self->{local_c}{week_number} == 53 &&
                $self->_weeks_in_year( $self->year ) == 52 )
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

# Also from DateCalc.c
sub _weeks_in_year
{
    my $self = shift;
    my $year = shift;

    my $jan_one_dow =
        ( ( $self->_ymd2rd( $year, 1, 1 ) + 6 ) % 7 ) + 1;
    my $dec_31_dow =
        ( ( $self->_ymd2rd( $year, 12, 31 ) + 6 ) % 7 ) + 1;

    return $jan_one_dow == 4 || $dec_31_dow == 4 ? 53 : 52;
}

sub week_year   { ($_[0]->week)[0] }
sub week_number { ($_[0]->week)[1] }

# ISO says that the first week of a year is the first week containing
# a Thursday.  Extending that says that the first week of the month is
# the first week containing a Thursday.  ICU agrees.
#
# Algorithm supplied by Rick Measham, who doesn't understand how it
# works.  Neither do I.  Please feel free to explain this to me!
sub week_of_month
{
    my $self = shift;

    # Faster than cloning just to get the dow
    my $first_wday_of_month = ( 8 - ( $self->day - $self->dow ) % 7 ) % 7;
    $first_wday_of_month = 7 unless $first_wday_of_month;

    my $wom = int( ( $self->day + $first_wday_of_month - 2 ) / 7 );
    return ( $first_wday_of_month <= 4 ) ? $wom + 1 : $wom;
}

sub time_zone { $_[0]->{tz} }

sub offset { $_[0]->{tz}->offset_for_datetime( $_[0] ) }
sub _offset_from_local_time { $_[0]->{tz}->offset_for_local_datetime( $_[0] ) }

sub is_dst { $_[0]->{tz}->is_dst_for_datetime( $_[0] ) }

sub time_zone_long_name  { $_[0]->{tz}->name }
sub time_zone_short_name { $_[0]->{tz}->short_name_for_datetime( $_[0] ) }

sub locale { $_[0]->{locale} }
*language = \&locale;

sub utc_rd_values { @{ $_[0] }{ 'utc_rd_days', 'utc_rd_secs', 'rd_nanosecs' } }

# NOTE: no nanoseconds, no leap seconds
sub utc_rd_as_seconds   { ( $_[0]->{utc_rd_days} * 86400 ) + $_[0]->{utc_rd_secs} }

# NOTE: no nanoseconds, no leap seconds
sub local_rd_as_seconds { ( $_[0]->{local_rd_days} * 86400 ) + $_[0]->{local_rd_secs} }

# RD 1 is JD 1,721,424.5 - a simple offset
sub jd
{
    my $self = shift;

    my $jd = $self->{utc_rd_days} + 1_721_424.5;

    my $day_length = $self->_day_length( $self->{utc_rd_days} );

    return ( $jd +
             ( $self->{utc_rd_secs} / $day_length )  +
             ( $self->{rd_nanosecs} / $day_length / MAX_NANOSECONDS )
           );
}

sub mjd { $_[0]->jd - 2_400_000.5 }

my %formats =
    ( 'a' => sub { $_[0]->day_abbr },
      'A' => sub { $_[0]->day_name },
      'b' => sub { $_[0]->month_abbr },
      'B' => sub { $_[0]->month_name },
      'c' => sub { $_[0]->strftime( $_[0]->{locale}->default_datetime_format ) },
      'C' => sub { int( $_[0]->year / 100 ) },
      'd' => sub { sprintf( '%02d', $_[0]->day_of_month ) },
      'D' => sub { $_[0]->strftime( '%m/%d/%y' ) },
      'e' => sub { sprintf( '%2d', $_[0]->day_of_month ) },
      'F' => sub { $_[0]->ymd('-') },
      'g' => sub { substr( $_[0]->week_year, -2 ) },
      'G' => sub { $_[0]->week_year },
      'H' => sub { sprintf( '%02d', $_[0]->hour ) },
      'I' => sub { sprintf( '%02d', $_[0]->hour_12 ) },
      'j' => sub { $_[0]->day_of_year },
      'k' => sub { sprintf( '%2d', $_[0]->hour ) },
      'l' => sub { sprintf( '%2d', $_[0]->hour_12 ) },
      'm' => sub { sprintf( '%02d', $_[0]->month ) },
      'M' => sub { sprintf( '%02d', $_[0]->minute ) },
      'n' => sub { "\n" }, # should this be OS-sensitive?
      'N' => \&_format_nanosecs,
      'p' => sub { $_[0]->{locale}->am_pm( $_[0] ) },
      'P' => sub { lc $_[0]->{locale}->am_pm( $_[0] ) },
      'r' => sub { $_[0]->strftime( '%I:%M:%S %p' ) },
      'R' => sub { $_[0]->strftime( '%H:%M' ) },
      's' => sub { $_[0]->epoch },
      'S' => sub { sprintf( '%02d', $_[0]->second ) },
      't' => sub { "\t" },
      'T' => sub { $_[0]->strftime( '%H:%M:%S' ) },
      'u' => sub { $_[0]->day_of_week },
      # algorithm from Date::Format::wkyr
      'U' => sub { my $dow = $_[0]->day_of_week;
                   $dow = 0 if $dow == 7; # convert to 0-6, Sun-Sat
                   my $doy = $_[0]->day_of_year - 1;
                   return int( ( $doy - $dow + 13 ) / 7 - 1 )
                 },
      'V' => sub { sprintf( '%02d', $_[0]->week_number ) },
      'w' => sub { my $dow = $_[0]->day_of_week;
                   return $dow % 7;
                 },
      'W' => sub { my $dow = $_[0]->day_of_week;
                   my $doy = $_[0]->day_of_year - 1;
                   return int( ( $doy - $dow + 13 ) / 7 - 1 )
                 },
      'x' => sub { $_[0]->strftime( $_[0]->{locale}->default_date_format ) },
      'X' => sub { $_[0]->strftime( $_[0]->{locale}->default_time_format ) },
      'y' => sub { sprintf( '%02d', substr( $_[0]->year, -2 ) ) },
      'Y' => sub { return $_[0]->year },
      'z' => sub { DateTime::TimeZone::offset_as_string( $_[0]->offset ) },
      'Z' => sub { $_[0]->{tz}->short_name_for_datetime( $_[0] ) },
      '%' => sub { '%' },
    );

$formats{h} = $formats{b};

sub strftime
{
    my $self = shift;
    # make a copy or caller's scalars get munged
    my @formats = @_;

    my @r;
    foreach my $f (@formats)
    {
        $f =~ s/
                %{(\w+)}
               /
                $self->can($1) ? $self->$1() : "\%{$1}"
               /sgex;

        # regex from Date::Format - thanks Graham!
       $f =~ s/
                %([%a-zA-Z])
               /
                $formats{$1} ? $formats{$1}->($self) : "\%$1"
               /sgex;

        # %3N
        $f =~ s/
                %(\d+)N
               /
                $formats{N}->($self, $1)
               /sgex;

        return $f unless wantarray;

        push @r, $f;
    }

    return @r;
}

sub _format_nanosecs
{
    my $self = shift;
    my $precision = shift;

    my $ret = sprintf( "%09d", $self->{rd_nanosecs} );
    return $ret unless $precision;   # default = 9 digits

    # rd_nanosecs might contain a fractional separator
    my ( $int, $frac ) = split /[.,]/, $self->{rd_nanosecs};
    $ret .= $frac if $frac;

    return substr( $ret, 0, $precision );
}

sub epoch
{
    my $self = shift;

    return $self->{utc_c}{epoch}
        if exists $self->{utc_c}{epoch};

    my ( $year, $month, $day ) = $self->_utc_ymd;
    my @hms = $self->_utc_hms;

    $self->{utc_c}{epoch} =
        eval { Time::Local::timegm_nocheck( ( reverse @hms ),
                                            $day,
                                            $month - 1,
                                            $year,
                                          ) };

    return $self->{utc_c}{epoch};
}

sub hires_epoch
{
    my $self = shift;

    my $epoch = $self->epoch;

    return undef unless defined $epoch;

    my $nano = $self->{rd_nanosecs} / MAX_NANOSECONDS;

    return $epoch + $nano;
}

sub is_finite { 1 }
sub is_infinite { 0 }

# added for benefit of DateTime::TimeZone
sub utc_year { $_[0]->{utc_year} }

# returns a result that is relative to the first datetime
sub subtract_datetime
{
    my $self = shift;
    my $dt = shift;

    # We only want a negative duration if $dt > $self.
    my ( $bigger, $smaller, $negative ) =
        ( $self >= $dt ?
          ( $self, $dt, 0 ) :
          ( $dt, $self, 1 )
        );

    my $is_floating = $self->time_zone->is_floating &&
                      $dt->time_zone->is_floating;

    my $minute_length = 60;

    unless ($is_floating)
    {
        my ( $utc_rd_days, $utc_rd_secs ) = $smaller->utc_rd_values;

        if ( $utc_rd_secs >= 86340 && ! $is_floating )
        {
            # If the smaller of the two datetimes occurs in the last
            # UTC minute of the UTC day, then that minute may not be
            # 60 seconds long.  If we need to subtract a minute from
            # the larger datetime's minutes count in order to adjust
            # the seconds difference to be positive, we need to know
            # how long that minute was.  If one of the datetimes is
            # floating, we just assume a minute is 60 seconds.

            $minute_length = $self->_day_length($utc_rd_days) - 86340;
        }
    }

    my ( $months, $days, $minutes, $seconds, $nanoseconds ) =
        $self->_adjust_for_positive_difference
            ( $bigger->year * 12 + $bigger->month, $smaller->year * 12 + $smaller->month,

              $bigger->day, $smaller->day,

              $bigger->hour * 60 + $bigger->minute, $smaller->hour * 60 + $smaller->minute,

	      $bigger->second, $smaller->second,

	      $bigger->nanosecond, $smaller->nanosecond,

	      $minute_length,

	      $self->_month_length( $smaller->year, $smaller->month ),
            );

    if ($negative)
    {
        for ( $months, $days, $minutes, $seconds, $nanoseconds )
        {
	    # Some versions of Perl can end up with -0 if we do "0 * -1"!!
            $_ *= -1 if $_;
        }
    }

    return
        DateTime::Duration->new
            ( months      => $months,
	      days        => $days,
	      minutes     => $minutes,
              seconds     => $seconds,
              nanoseconds => $nanoseconds,
            );
}

sub _adjust_for_positive_difference
{
    my ( $self,
	 $month1, $month2,
	 $day1, $day2,
	 $min1, $min2,
	 $sec1, $sec2,
	 $nano1, $nano2,
	 $minute_length,
	 $month_length,
       ) = @_;

    if ( $nano1 < $nano2 )
    {
        $sec1--;
        $nano1 += MAX_NANOSECONDS;
    }

    if ( $sec1 < $sec2 )
    {
        $min1--;
        $sec1 += $minute_length;
    }

    # A day always has 24 * 60 minutes, though the minutes may vary in
    # length.
    if ( $min1 < $min2 )
    {
	$day1--;
	$min1 += 24 * 60;
    }

    if ( $day1 < $day2 )
    {
	$month1--;
	$day1 += $month_length;
    }

    return ( $month1 - $month2,
	     $day1 - $day2,
	     $min1 - $min2,
             $sec1 - $sec2,
             $nano1 - $nano2,
           );
}

sub subtract_datetime_absolute
{
    my $self = shift;
    my $dt = shift;

    my $utc_rd_secs1 = $self->utc_rd_as_seconds;
    $utc_rd_secs1 += DateTime->_leap_seconds( $self->{utc_rd_days} )
	if ! $self->time_zone->is_floating;

    my $utc_rd_secs2 = $dt->utc_rd_as_seconds;
    $utc_rd_secs2 += DateTime->_leap_seconds( $dt->{utc_rd_days} )
	if ! $dt->time_zone->is_floating;

    my $seconds = $utc_rd_secs1 - $utc_rd_secs2;
    my $nanoseconds = $self->nanosecond - $dt->nanosecond;

    if ( $nanoseconds < 0 )
    {
	$seconds--;
	$nanoseconds += MAX_NANOSECONDS;
    }

    return
        DateTime::Duration->new
            ( seconds     => $seconds,
              nanoseconds => $nanoseconds,
            );
}

sub delta_md
{
    my $self = shift;
    my $dt = shift;

    my $dur = $self->subtract_datetime($dt);

    return DateTime::Duration->new( months => $dur->delta_months,
                                    days   => $dur->delta_days );
}

sub delta_days { DateTime::Duration->new( days => int( $_[0]->jd - $_[1]->jd ) ) }

sub delta_ms
{
    my $self = shift;
    my $dt = shift;

    my $days = abs( int( $self->jd - $dt->jd ) );

    my $dur = $self->subtract_datetime($dt);

    my %p;
    $p{hours}   = $dur->hours + ( $days * 24 );
    $p{minutes} = $dur->minutes;
    $p{seconds} = $dur->seconds;

    if ( $self < $dt )
    {
        for ( qw( hours minutes seconds ) )
        {
            $p{$_} *= -1 if $p{$_};
        }
    }

    return DateTime::Duration->new(%p);
}

sub _add_overload
{
    my ( $dt, $dur, $reversed ) = @_;

    if ($reversed)
    {
        ( $dur, $dt ) = ( $dt, $dur );
    }

    # how to handle non duration objects?

    my $new = $dt->clone;
    $new->add_duration($dur);
    return $new;
}

sub _subtract_overload
{
    my ( $date1, $date2, $reversed ) = @_;

    if ($reversed)
    {
        ( $date2, $date1 ) = ( $date1, $date2 );
    }

    if ( UNIVERSAL::isa( $date2, 'DateTime::Duration' ) )
    {
        my $new = $date1->clone;
        $new->add_duration( $date2->inverse );
        return $new;
    }
    else
    {
        return $date1->subtract_datetime($date2);
    }
    # handle other cases?
}

sub add { return shift->add_duration( DateTime::Duration->new(@_) ) }

sub subtract { return shift->subtract_duration( DateTime::Duration->new(@_) ) }

sub subtract_duration { return $_[0]->add_duration( $_[1]->inverse ) }

sub add_duration
{
    my $self = shift;
    my ($dur) = validate_pos( @_, { isa => 'DateTime::Duration' } );

    # simple optimization
    return $self if $dur->is_zero;

    my %deltas = $dur->deltas;

    # This bit isn't quite right since DateTime::Infinite::Future -
    # infinite duration should NaN
    foreach my $val ( values %deltas )
    {
        my $inf;
        if ( $val == INFINITY )
        {
            $inf = DateTime::Infinite::Future->new;
        }
        elsif ( $val == NEG_INFINITY )
        {
            $inf = DateTime::Infinite::Past->new;
        }

        if ($inf)
        {
            %$self = %$inf;
            bless $self, ref $inf;

            return $self;
        }
    }

    return $self if $self->is_infinite;

    $self->{local_rd_days} += $deltas{days} if $deltas{days};

    if ( $deltas{months} )
    {
        # For preserve mode, if it is the last day of the month, make
        # it the 0th day of the following month (which then will
        # normalize back to the last day of the new month).
        my ($y, $m, $d) = ( $dur->is_preserve_mode ?
                            $self->_rd2ymd( $self->{local_rd_days} + 1 ) :
                            $self->_rd2ymd( $self->{local_rd_days} )
                          );

        $d -= 1 if $dur->is_preserve_mode;

        if ( ! $dur->is_wrap_mode && $d > 28 )
        {
            # find the rd for the last day of our target month
            $self->{local_rd_days} = $self->_ymd2rd( $y, $m + $deltas{months} + 1, 0 );

            # what day of the month is it? (discard year and month)
            my $last_day = ($self->_rd2ymd( $self->{local_rd_days} ))[2];

            # if our original day was less than the last day,
            # use that instead
            $self->{local_rd_days} -= $last_day - $d if $last_day > $d;
        }
        else
        {
            $self->{local_rd_days} = $self->_ymd2rd( $y, $m + $deltas{months}, $d );
        }
    }

    if ( $deltas{days} || $deltas{months} )
    {
        # We fudge the year so that the calculations being done have
        # something to work with.
        $self->{utc_year} += int( $deltas{months} / 12 ) + 1;

        $self->_calc_utc_rd;
        $self->_calc_local_rd;
    }

    if ( $deltas{minutes} )
    {
        $self->{utc_rd_secs} += $deltas{minutes} * 60;

        # This intentionally ignores leap seconds
        $self->_normalize_tai_seconds( $self->{utc_rd_days}, $self->{utc_rd_secs} );
    }

    # We add seconds to the UTC time because if someone adds 24 hours,
    # we want this to be _different_ from adding 1 day when crossing
    # DST boundaries.
    if ( $deltas{seconds} || $deltas{nanoseconds})
    {
        $self->{utc_rd_secs} += $deltas{seconds};

        if ( $deltas{nanoseconds} )
        {
            $self->{rd_nanosecs} += $deltas{nanoseconds};
            $self->_normalize_nanoseconds( $self->{utc_rd_secs}, $self->{rd_nanosecs} );
        }

        # must always normalize seconds, because a nanosecond change
        # might cause a day change
        $self->_normalize_seconds;
    }

    if ( $deltas{minutes} || $deltas{seconds} || $deltas{nanoseconds})
    {
        delete $self->{utc_c};
        $self->_calc_local_rd;
    }

    return $self;
}

sub _compare_overload
{
    # note: $_[1]->compare( $_[0] ) is an error when $_[1] is not a
    # DateTime (such as the INFINITY value)
    return $_[2] ? - $_[0]->compare( $_[1] ) : $_[0]->compare( $_[1] );
}

sub compare
{
    shift->_compare( @_, 0 );
}

sub compare_ignore_floating
{
    shift->_compare( @_, 1 );
}

sub _compare
{
    my ( $class, $dt1, $dt2, $consistent ) = ref $_[0] ? ( undef, @_ ) : @_;

    return undef unless defined $dt2;

    if ( ! ref $dt2 && ( $dt2 == INFINITY || $dt2 == NEG_INFINITY ) )
    {
        return $dt1->{utc_rd_days} <=> $dt2;
    }

    die "Cannot compare a datetime to a regular scalar"
        unless ( UNIVERSAL::can( $dt1, 'utc_rd_values' ) &&
                 UNIVERSAL::can( $dt2, 'utc_rd_values' ) );

    if ( ! $consistent &&
         UNIVERSAL::can( $dt1, 'time_zone' ) &&
         UNIVERSAL::can( $dt2, 'time_zone' )
       )
    {
        my $is_floating1 = $dt1->time_zone->is_floating;
        my $is_floating2 = $dt2->time_zone->is_floating;

        if ( $is_floating1 && ! $is_floating2 )
        {
            $dt1 = $dt1->clone->set_time_zone( $dt2->time_zone );
        }
        elsif ( $is_floating2 && ! $is_floating1 )
        {
            $dt2 = $dt2->clone->set_time_zone( $dt1->time_zone );
        }
    }

    my @dt1_components = $dt1->utc_rd_values;
    my @dt2_components = $dt2->utc_rd_values;

    foreach my $i ( 0..2 )
    {
        return $dt1_components[$i] <=> $dt2_components[$i]
            if $dt1_components[$i] != $dt2_components[$i]
    }

    return 0;
}

sub _normalize_nanoseconds
{
    use integer;

    # seconds, nanoseconds
    if ( $_[2] < 0 )
    {
        my $overflow = 1 + $_[2] / MAX_NANOSECONDS;
        $_[2] += $overflow * MAX_NANOSECONDS;
        $_[1] -= $overflow;
    }
    elsif ( $_[2] >= MAX_NANOSECONDS )
    {
        my $overflow = $_[2] / MAX_NANOSECONDS;
        $_[2] -= $overflow * MAX_NANOSECONDS;
        $_[1] += $overflow;
    }
}

# Many of the same parameters as new() but all of them are optional,
# and there are no defaults.
my $SetValidate =
    { map { my %copy = %{ $BasicValidate->{$_} };
            delete $copy{default};
            $copy{optional} = 1;
            $_ => \%copy }
      keys %$BasicValidate };

sub set
{
    my $self = shift;
    my %p = validate( @_, $SetValidate );

    my %old_p =
        ( map { $_ => $self->$_() }
          qw( year month day hour minute second nanosecond locale time_zone )
        );

    my $new_dt = (ref $self)->new( %old_p, %p );

    %$self = %$new_dt;

    return $self;
}

sub truncate
{
    my $self = shift;
    my %p = validate( @_,
                      { to =>
                        { regex => qr/^(?:year|month|week|day|hour|minute|second)$/ },
                      },
                    );

    my %new = ( locale    => $self->{locale},
                time_zone => $self->{tz},
              );

    if ( $p{to} eq 'week' )
    {
        my $day_diff = $self->day_of_week - 1;

        if ($day_diff)
        {
            $self->add( days => -1 * $day_diff );
        }

        return $self->truncate( to => 'day' );
    }
    else
    {
	foreach my $f ( qw( year month day hour minute second ) )
	{
	    $new{$f} = $self->$f();

	    last if $p{to} eq $f;
	}
    }

    my $new_dt = (ref $self)->new(%new);

    %$self = %$new_dt;

    return $self;
}

sub set_time_zone
{
    my ( $self, $tz ) = @_;

    # This is a bit of a hack but it works because time zone objects
    # are singletons, and if it doesn't work all we lose is a little
    # bit of speed.
    return if $self->{tz} eq $tz;

    my $was_floating = $self->{tz}->is_floating;

    $self->{tz} = ref $tz ? $tz : DateTime::TimeZone->new( name => $tz );

    # if it either was or now is floating (but not both)
    if ( $self->{tz}->is_floating xor $was_floating )
    {
        $self->_calc_utc_rd;
    }
    elsif ( ! $was_floating )
    {
        $self->_calc_local_rd;
    }

    return $self;
}

sub STORABLE_freeze
{
    my $self = shift;
    my $cloning = shift;

    my $serialized = '';
    foreach my $key ( qw( utc_rd_days
                          utc_rd_secs
                          rd_nanosecs ) )
    {
        $serialized .= "$key:$self->{$key}|";
    }

    # not used yet, but may be handy in the future.
    $serialized .= "version:$VERSION";

    return $serialized, $self->{locale}, $self->{tz};
}

sub STORABLE_thaw
{
    my $self = shift;
    my $cloning = shift;
    my $serialized = shift;

    my %serialized = map { split /:/ } split /\|/, $serialized;

    my ( $locale, $tz );

    # more recent code version
    if (@_)
    {
        ( $locale, $tz ) = @_;
    }
    else
    {
        $tz = DateTime::TimeZone->new( name => delete $serialized{tz} );

        $locale =
            DateTime::Locale->load( exists $serialized{language}
                                    ? delete $serialized{language}
                                    : delete $serialized{locale}
                                  );
    }

    delete $serialized{version};

    %$self = %serialized;
    $self->{tz} = $tz;
    $self->{locale} = $locale;

    $self->_calc_local_rd;

    return $self;
}


1;

__END__

=head1 NAME

DateTime - A date and time object

=head1 SYNOPSIS

  use DateTime;

  $dt = DateTime->new( year   => 1964,
                       month  => 10,
                       day    => 16,
                       hour   => 16,
                       minute => 12,
                       second => 47,
                       nanosecond => 500000000,
                       time_zone => 'Asia/Taipei',
                     );

  $dt = DateTime->from_epoch( epoch => $epoch );
  $dt = DateTime->now; # same as ( epoch => time() )

  $year   = $dt->year;
  $month  = $dt->month;          # 1-12 - also mon

  $day    = $dt->day;            # 1-31 - also day_of_month, mday

  $dow    = $dt->day_of_week;    # 1-7 (Monday is 1) - also dow, wday

  $hour   = $dt->hour;           # 0-23
  $minute = $dt->minute;         # 0-59 - also min

  $second = $dt->second;         # 0-61 (leap seconds!) - also sec

  $doy    = $dt->day_of_year;    # 1-366 (leap years) - also doy

  $doq    = $dt->day_of_quarter; # 1.. - also doq

  $qtr    = $dt->quarter;        # 1-4

  # all of the start-at-1 methods above have correponding start-at-0
  # methods, such as $dt->day_of_month_0, $dt->month_0 and so on

  $ymd    = $dt->ymd;           # 2002-12-06
  $ymd    = $dt->ymd('/');      # 2002/12/06 - also date

  $mdy    = $dt->mdy;           # 12-06-2002
  $mdy    = $dt->mdy('/');      # 12/06/2002

  $dmy    = $dt->dmy;           # 06-12-2002
  $dmy    = $dt->dmy('/');      # 06/12/2002

  $hms    = $dt->hms;           # 14:02:29
  $hms    = $dt->hms('!');      # 14!02!29 - also time

  $is_leap  = $dt->is_leap_year;

  # these are localizable, see Locales section
  $month_name  = $dt->month_name; # January, February, ...
  $month_abbr  = $dt->month_abbr; # Jan, Feb, ...
  $day_name    = $dt->day_name;   # Monday, Tuesday, ...
  $day_abbr    = $dt->day_abbr;   # Mon, Tue, ...

  $epoch_time  = $dt->epoch;
  # may return undef if the datetime is outside the range that is
  # representable by your OS's epoch system.

  $dt2 = $dt + $duration_object;

  $dt3 = $dt - $duration_object;

  $duration_object = $dt - $dt2;

  $dt->set( year => 1882 );

  $dt->set_time_zone( 'America/Chicago' );

=head1 DESCRIPTION

DateTime is a class for the representation of date/time combinations,
and is part of the Perl DateTime project.  For details on this project
please see L<http://datetime.perl.org/>.  The DateTime site has a FAQ
which may help answer many "how do I do X?" questions.  The FAQ is at
L<http://datetime.perl.org/faq.html>.

It represents the Gregorian calendar, extended backwards in time
before its creation (in 1582).  This is sometimes known as the
"proleptic Gregorian calendar".  In this calendar, the first day of
the calendar (the epoch), is the first day of year 1, which
corresponds to the date which was (incorrectly) believed to be the
birth of Jesus Christ.

The calendar represented does have a year 0, and in that way differs
from how dates are often written using "BCE/CE" or "BC/AD".

For infinite datetimes, please see the
L<DateTime::Infinite|DateTime::Infinite> module.

=head1 USAGE

=head2 0-based Versus 1-based Numbers

The DateTime.pm module follows a simple consistent logic for
determining whether or not a given number is 0-based or 1-based.

Month, day of month, day of week, and day of year are 1-based.  Any
method that is 1-based also has an equivalent 0-based method ending in
"_0".  So for example, this class provides both C<day_of_week()> and
C<day_of_week_0()> methods.

The C<day_of_week_0()> method still treats Monday as the first day of
the week.

All I<time>-related numbers such as hour, minute, and second are
0-based.

Years are neither, as they can be both positive or negative, unlike
any other datetime component.  There I<is> a year 0.

There is no C<quarter_0()> method.

=head2 Error Handling

Some errors may cause this module to die with an error string.  This
can only happen when calling constructor methods, methods that change
the object, such as C<set()>, or methods that take parameters.
Methods that retrieve information about the object, such as C<year()>
or C<epoch()>, will never die.

=head2 Locales

Some methods are localizable.  This is done by setting the locale
when constructing a DateTime object.  There is also a
C<DefaultLocale()> class method which may be used to set the default
locale for all DateTime objects created.  If this is not set, then
"English" is used.

Some locales may return data as Unicode.  When using Perl 5.6.0 or
greater, this will be a native Perl Unicode string.  When using older
Perls, this will be a sequence of bytes representing the Unicode
character.

=head2 Floating DateTimes

The default time zone for all DateTime objects is the "floating" time
zone.  This concept comes from the iCal standard.  A floating datetime
is one which is not anchored to any particular time zone.  In
addition, floating datetimes do not include leap seconds, since we
cannot use them without knowing the datetime's time zone.

The results of date math and comparison between a floating datetime
and one with a real time zone are not really valid, because one
includes leap seconds and the other does not.  Similarly, the results
of datetime math between two floating datetimes and two datetimes with
time zones are not really comparable.

If you are planning to use any objects with a real time zone, it is
strongly recommended that you B<do not> mix these with floating
datetimes.

=head2 Methods

=head3 Constructors

All constructors can die when invalid parameters are given.

=over 4

=item * new( ... )

This class method accepts parameters for each date and time component:
"year", "month", "day", "hour", "minute", "second", "nanosecond".
It also accepts "locale" and "time_zone" parameters.

  my $dt = DateTime->new( year   => 1066,
                          month  => 10,
                          day    => 25,
                          hour   => 7,
                          minute => 15,
                          second => 47,
                          nanosecond => 500000000,
                          time_zone  => 'America/Chicago',
                        );

DateTime validates the "month", "day", "hour", "minute", and "second",
and "nanosecond" parameters.  The valid values for these parameters are:

=over 8

=item * month

1-12

=item * day

1-31, and it must be within the valid range of days for the specified
month

=item * hour

0-23

=item * minute

0-59

=item * second

0-61 (to allow for leap seconds).  Values of 60 or 61 are only allowed
when they match actual leap seconds.

=item * nanosecond

>= 0

=back

=back

Invalid parameter types (like an array reference) will cause the
constructor to die.

DateTime does not check if second values greater than 59 are valid
based on current leap seconds, and invalid values simply cause an
overflow.

All of the parameters are optional except for "year".  The "month" and
"day" parameters both default to 1, while the "hour", "minute", and
"second", and "nanosecond" parameters all default to 0.

The locale parameter should be a string matching one of the valid
locales, or a C<DateTime::Locale> object.  See the
L<DateTime::Locale|DateTime::Locale> documentation for details.

The time_zone parameter can be either a scalar or a
C<DateTime::TimeZone> object.  A string will simply be passed to the
C<< DateTime::TimeZone->new >> method as its "name" parameter.  This
string may be an Olson DB time zone name ("America/Chicago"), an
offset string ("+0630"), or the words "floating" or "local".  See the
C<DateTime::TimeZone> documentation for more details.

The default time zone is "floating".

=head4 Ambiguous Local Times

Because of Daylight Saving Time, it is possible to specify a local
time that is ambiguous.  For example, in the US in 2003, the
transition from to saving to standard time occurs on October 26, at
02:00:00 local time.  The local clock changes from 01:59:59 (saving
time) to 01:00:00 (standard time).  This means that the hour from
01:00:00 through 01:59:59 actually occurs twice, though the UTC time
continues to move forward.

If you specify an ambiguous time, then the latest UTC time is always
used, in effect always choosing saving time.  In this case, you can
simply subtract an hour to the object in order to move to standard time,
for example:

  # This object represent 01:30:00 standard time
  my $dt = DateTime->new( year   => 2003,
                          month  => 10,
                          day    => 26,
                          hour   => 1,
                          minute => 30,
                          second => 0,
                          time_zone => 'America/Chicago',
                        );

  print $dt->hms;  # prints 01:30:00

  # Now the object represent 01:30:00 saving time
  $dt->subtract( hours => 1 );

  print $dt->hms;  # still prints 01:30:00

Alternately, you could create the object with the UTC time zone, and
then call the C<set_time_zone()> method to change the time zone.  This
would allow you to unambiguously specify the datetime.

=head4 Invalid Local Times

Another problem introduced by Daylight Saving Time is that certain
local times just do not exist.  For example, in the US in 2003, the
transition from standard to saving time occurred on April 6, at the
change to 2:00:00 local time.  The local clock changes from 01:59:59
(standard time) to 03:00:00 (saving time).  This means that there is
no 02:00:00 through 02:59:59 on April 6!

Attempting to create an invalid time currently causes a fatal error.
This may change in future version of this module.

=over 4

=item * from_epoch( epoch => $epoch, ... )

This class method can be used to construct a new DateTime object from
an epoch time instead of components.  Just as with the C<new()>
method, it accepts "time_zone" and "locale" parameters.

If the epoch value is not an integer, the part after the decimal will
be converted to nanoseconds.  This is done in order to be compatible
with C<Time::HiRes>.  If the floating portion extends past 9 decimal
places, it will be truncated to nine, so that 1.1234567891 will become
1 second and 123,456,789 nanoseconds.

=item * now( ... )

This class method is equivalent to calling C<from_epoch()> with the
value returned from Perl's C<time()> function.  Just as with the
C<new()> method, it accepts "time_zone" and "locale" parameters.

=item * today( ... )

This class method is equivalent to:

  DateTime->now->truncate( to => 'day' );

=item * from_object( object => $object, ... )

This class method can be used to construct a new DateTime object from
any object that implements the C<utc_rd_values()> method.  All
C<DateTime::Calendar> modules must implement this method in order to
provide cross-calendar compatibility.  This method accepts a
"locale" parameter

If the object passed to this method has a C<time_zone()> method, that
is used to set the time zone of the newly created C<DateTime.pm>
object.  Otherwise UTC is used.

=item * last_day_of_month( ... )

This constructor takes the same arguments as can be given to the
C<new()> method, except for "day".  Additionally, both "year" and
"month" are required.

=item * from_day_of_year( ... )

This constructor takes the same arguments as can be given to the
C<new()> method, except that it does not accept a "month" or "day"
argument.  Instead, it requires both "year" and "day_of_year".  The
day of year must be between 1 and 366, and 366 is only allowed for
leap years.

=item * clone

This object method returns a replica of the given object.

=back

=head3 "Get" Methods

This class has many methods for retrieving information about an
object.

=over 4

=item * year

Returns the year.

=item * ce_year

Returns the year according to the BCE/CE numbering system.  The year
before year 1 in this system is year -1, aka "1 BCE".

=item * era

Returns a string, either "BCE" or "CE", according to the year.

=item * year_with_era

Returns a string containing the year immediately followed by its era.
The year is the absolute value of C<ce_year()>, so that year 1 is
"1CE" and year 0 is "1BCE".

=item * month

Returns the month of the year, from 1..12.

=item * month_name

Returns the name of the current month.  See the
L<Locales|/Locales> section for more details.

=item * month_abbr

Returns the abbreviated name of the current month.  See the
L<Locales|/Locales> section for more details.

=item * day_of_month, day, mday

Returns the day of the month, from 1..31.

=item * day_of_week, wday, dow

Returns the day of the week as a number, from 1..7, with 1 being
Monday and 7 being Sunday.

=item * day_name

Returns the name of the current day of the week.  See the
L<Locales|/Locales> section for more details.

=item * day_abbr

Returns the abbreviated name of the current day of the week.  See the
L<Locales|/Locales> section for more details.

=item * day_of_year, doy

Returns the day of the year.

=item * quarter

Returns the quarter of the year, from 1..4.

=item * day_of_quarter, doq

Returns the day of the quarter.

=item * weekday_of_month

Returns a number from 1..5 indicating which week day of the month this
is.  For example, June 9, 2003 is the second Monday of the month, and
so this method returns 2 for that day.

=item * ymd( $optional_separator ), date

=item * mdy( $optional_separator )

=item * dmy( $optional_separator )

Each method returns the year, month, and day, in the order indicated
by the method name.  Years are zero-padded to four digits.  Months and
days are 0-padded to two digits.

By default, the values are separated by a dash (-), but this can be
overridden by passing a value to the method.

=item * hour

Returns the hour of the day, from 0..23.

=item * hour_1

Returns the hour of the day, from 1..24.

=item * hour_12

Returns the hour of the day, from 1..12.

=item * hour_12_0

Returns the hour of the day, from 0..11.

=item * minute, min

Returns the minute of the hour, from 0..59.

=item * second, sec

Returns the second, from 0..61.  The values 60 and 61 are used for
leap seconds.

=item * fractional_second

Returns the second, as a real number from 0.0 until 61.999999999

The values 60 and 61 are used for leap seconds.

=item * millisecond

Returns the fractional part of the second as milliseconds (1E-3 seconds).

Half a second is 500 milliseconds.

=item * microsecond

Returns the fractional part of the second as microseconds (1E-6
seconds).  This value will be rounded to an integer.

Half a second is 500_000 microseconds.  This value will be rounded to
an integer.

=item * nanosecond

Returns the fractional part of the second as nanoseconds (1E-9 seconds).

Half a second is 500_000_000 nanoseconds.

=item * hms( $optional_separator ), time

Returns the hour, minute, and second, all zero-padded to two digits.
If no separator is specified, a colon (:) is used by default.

=item * datetime, iso8601

This method is equivalent to:

  $dt->ymd('-') . 'T' . $dt->hms(':')

=item * is_leap_year

This method returns a true or false indicating whether or not the
datetime object is in a leap year.

=item * week

 ($week_year, $week_number) = $dt->week;

Returns information about the calendar week which contains this
datetime object. The values returned by this method are also available
separately through the week_year and week_number methods.

The first week of the year is defined by ISO as the one which contains
the fourth day of January, which is equivalent to saying that it's the
first week to overlap the new year by at least four days.

Typically the week year will be the same as the year that the object
is in, but dates at the very begining of a calendar year often end up
in the last week of the prior year, and similarly, the final few days
of the year may be placed in the first week of the next year.

=item * week_year

Returns the year of the week.

=item * week_number

Returns the week of the year, from 1..53.

=item * week_of_month

The week of the month, from 0..5.  The first week of the month is the
first week that contains a Thursday.  This is based on the ICU
definition of week of month, and correlates to the ISO8601 week of
year definition.  A day in the week I<before> the week with the first
Thursday will be week 0.

=item * jd, mjd

These return the Julian Day and Modified Julian Day, respectively.
The value returned is a floating point number.  The fractional portion
of the number represents the time portion of the datetime.

=item * time_zone

This returns the C<DateTime::TimeZone> object for the datetime object.

=item * offset

This returns the offset, in seconds, of the datetime object according
to the time zone.

=item * is_dst

Returns a boolean indicating whether or not the datetime object is
currently in Daylight Saving Time or not.

=item * time_zone_long_name

This is a shortcut for C<< $dt->time_zone->name >>.  It's provided so
that one can use "%{time_zone_long_name}" inside as a strftime format
specifier.

=item * time_zone_short_name

This method returns the time zone abbreviation for the current time
zone, such as "PST" or "GMT".  These names are B<not> definitive, and
should not be used in any application intended for general use by
users around the world.

=item * strftime( $format, ... )

This method implements functionality similar to the C<strftime()>
method in C.  However, if given multiple format strings, then it will
return multiple scalars, one for each format string.

See the L<strftime Specifiers|/strftime Specifiers> section for a list
of all possible format specifiers.

If you give a format specifier that doesn't exist, then it is simply
treated as text.

=item * epoch

Return the UTC epoch value for the datetime object.  Internally, this
is implemented using C<Time::Local>, which uses the Unix epoch even on
machines with a different epoch (such as MacOS).  Datetimes before the
start of the epoch will be returned as a negative number.

This return value from this method is always an integer.

Since the epoch does not account for leap seconds, the epoch time for
1971-12-31T23:59:60 (UTC) is exactly the same as that for
1972-01-01T00:00:00.

Epoch times cannot represent many dates on most platforms, and this
method may simply return undef in some cases.

Using your system's epoch time may be error-prone, since epoch times
have such a limited range on 32-bit machines.  Additionally, the fact
that different operating systems have different epoch beginnings is
another source of possible bugs.

=item * hires_epoch

Returns the epoch as a floating point number.  The floating point
portion of the value represents the nanosecond value of the object.
This method is provided for compatibility with the C<Time::HiRes>
module.

=item * is_finite, is_infinite

These methods allow you to distinguish normal datetime objects from
infinite ones.  Infinite datetime objects are documented in
L<DateTime::Infinite|DateTime::Infinite>.

=item * utc_rd_values

Returns the current UTC Rata Die days, seconds, and nanoseconds as a
three element list.  This exists primarily to allow other calendar
modules to create objects based on the values provided by this object.

=item * leap_seconds

Returns the number of leap seconds that have happened up to the
datetime represented by the object.  For floating datetimes, this
always returns 0.

=item * utc_rd_as_seconds

Returns the current UTC Rata Die days and seconds purely as seconds.
This number ignores any fractional seconds stored in the object,
as well as leap seconds.

=item * local_rd_as_seconds - deprecated

Returns the current local Rata Die days and seconds purely as seconds.
This number ignores any fractional seconds stored in the object,
as well as leap seconds.

=item * locale

Returns the current locale object.

=back

=head3 "Set" Methods

The remaining methods provided by C<DateTime.pm>, except where otherwise
specified, return the object itself, thus making method chaining
possible. For example:

  my $dt = DateTime->now->set_time_zone( 'Australia/Sydney' );

  my $first = DateTime
                ->last_day_of_month( year => 2003, month => 3 )
                ->add( days => 1 )
                ->subtract( seconds => 1 );

=over 4

=item * set( .. )

This method can be used to change the local components of a date time,
or its locale.  This method accepts any parameter allowed by the
C<new()> method except for "time_zone".  Time zones may be set using
the C<set_time_zone()> method.

This method performs parameters validation just as is done in the
C<new()> method.

=item * truncate( to => ... )

This method allows you to reset some of the local time components in
the object to their "zero" values.  The "to" parameter is used to
specify which values to truncate, and it may be one of "year",
"month", "week", "day", "hour", "minute", or "second".  For example,
if "month" is specified, then the local day becomes 1, and the hour,
minute, and second all become 0.

If "week" is given, then the datetime is set to the beginning of the
week in which it occurs, and the time components are all set to 0.

=item * set_time_zone( $tz )

This method accepts either a time zone object or a string that can be
passed as the "name" parameter to C<< DateTime::TimeZone->new() >>.
If the new time zone's offset is different from the old time zone,
then the I<local> time is adjusted accordingly.

For example:

  my $dt = DateTime->new( year => 2000, month => 5, day => 10,
                          hour => 15, minute => 15,
                          time_zone => 'America/Los_Angeles', );

  print $dt->hour; # prints 15

  $dt->set_time_zone( 'America/Chicago' );

  print $dt->hour; # prints 17

If the old time zone was a floating time zone, then no adjustments to
the local time are made, except to account for leap seconds.  If the
new time zone is floating, then the I<UTC> time is adjusted in order
to leave the local time untouched.

Fans of Tsai Ming-Liang's films will be happy to know that this does
work:

  my $dt = DateTime::TimeZone->now( time_zone => 'Asia/Taipei' );

  $dt->set_time_zone( 'Europe/Paris' );

Yes, now we can know "ni3 na4 bian1 ji3dian2?"

=item * add_duration( $duration_object )

This method adds a C<DateTime::Duration> to the current datetime.  See
the L<DateTime::Duration|DateTime::Duration> docs for more details.

=item * add( DateTime::Duration->new parameters )

This method is syntactic sugar around the C<add_duration()> method.  It
simply creates a new C<DateTime::Duration> object using the parameters
given, and then calls the C<add_duration()> method.

=item * subtract_duration( $duration_object )

When given a C<DateTime::Duration> object, this method simply calls
C<invert()> on that object and passes that new duration to the
C<add_duration> method.

=item * subtract( DateTime::Duration->new parameters )

Like C<add()>, this is syntactic sugar for the C<subtract_duration()>
method.

=item * subtract_datetime( $datetime )

This method returns a new C<DateTime::Duration> object representing
the difference between the two dates.  The duration is B<relative> to
the object from which C<$datetime> is subtracted.  For example:

    2003-03-15 00:00:00.00000000
 -  2003-02-15 00:00:00.00000000

 -------------------------------

 = 1 month

Note that this duration is not an absolute measure of the amount of
time between the two datetimes, because the length of a month varies
by month, as well as the presence of leap seconds.

The returned duration may have deltas for months, days, minutes,
seconds, and nanoseconds.

=item * subtract_datetime_absolute( $datetime )

This method returns a new C<DateTime::Duration> object representing
the difference between the two dates.  The duration object will only
have deltas for seconds and nanoseconds.  This is the only way to
accurately measure the absolute amount of time between two datetimes,
since units larger than a second do not represent a fixed number of
seconds.

=item * delta_md( $datetime )

=item * delta_days( $datetime )

=item * delta_ms( $datetime )

Each of these methods returns a new C<DateTime::Duration> object
representing some portion of the difference between two datetimes.
The C<delta_md()> method returns a duration which contains only the
month and day portions of the duration is represented.  The
C<delta_days()> method returns a duration which contains only days,
and the C<delta_ms()> method returns a duration which contains only
minutes and seconds.

The C<delta_md> and C<delta_days> methods truncate the duration so
that any fractional portion of a day is ignored.  The C<delta_ms>
method converts any day and months differences to minutes.

Unlike the subtraction methods, B<these methods always return a
positive (or zero) duration>.

=back

=head3 Class Methods

=over 4

=item * DefaultLocale( $locale )

This can be used to specify the default locale to be used when
creating DateTime objects.  If unset, then "en_US" is used.

=item * compare

=item * compare_ignore_floating

  $cmp = DateTime->compare( $dt1, $dt2 );

  $cmp = DateTime->compare_ignore_floating( $dt1, $dt2 );

Compare two DateTime objects.  The semantics are compatible with
Perl's C<sort()> function; it returns -1 if $a < $b, 0 if $a == $b, 1
if $a > $b.

If one of the two DateTime objects has a floating time zone, it will
first be converted to the time zone of the other object.  This is what
you want most of the time, but it can lead to inconsistent results
when you compare a number of DateTime objects, some of which are
floating, and some of which are in other time zones.

If you want to have consistent results (because you want to sort a
number of objects, for example), you can use the
C<compare_ignore_floating()> method:

  @dates = sort { DateTime->compare_ignore_floating($a, $b) } @dates;

In this case, objects with a floating time zone will be sorted as if
they were UTC times.

Since DateTime objects overload comparison operators, this:

  @dates = sort @dates;

is equivalent to this:

  @dates = sort { DateTime->compare($a, $b) } @dates;

DateTime objects can be compared to any other calendar class that
implements the C<utc_rd_values()> method.

=back

=head2 How Date Math is Done

It's important to have some understanding of how date math is
implemented in order to effectively use this module and
C<DateTime::Duration>.

The parts of a duration can be broken down into four parts.  These are
months, days, minutes, and seconds.  Adding one month to a date is
different than adding 4 weeks or 28, 29, 30, or 31 days.  Similarly,
due to DST and leap seconds, adding a day can be different than adding
86,400 seconds, and adding a minute is not exactly the same as 60
seconds.

C<DateTime.pm> always adds (or subtracts) days, then months, minutes,
and then seconds.  If there are any boundary overflows, these are
normalized at each step.

This means that adding one month and one day to February 28, 2003 will
produce the date April 1, 2003, not March 29, 2003.

  my $dt = DateTime->new( year => 2003, month => 2, day => 28 );

  $dt->add( months => 1, days => 1 );

  # 2003-04-01 - the result

On the other hand, if we add months first, and then separately add
days, we end up with March 29, 2003:

  $dt->add( months => 1 )->add( days => 1 );

  # 2003-03-29

=head3 Leap Seconds and Date Math

The presence of leap seconds can cause some strange anomalies in date
math.  For example, the following is a legal datetime:

  my $dt = DateTime->new( year => 1971, month => 12, day => 31,
                          hour => 23, minute => 59, second => 60,
                          time_zone => 'UTC' );

If we do the following:

 $dt->add( months => 1 );

Then the datetime is now "1972-02-01 00:00:00", because there is no
23:59:60 on 1972-01-31.

Leap seconds also force us to distinguish between minutes and seconds
during date math.  Given the following datetime:

  my $dt = DateTime->new( year => 1971, month => 12, day => 31,
                          hour => 23, minute => 59, second => 30,
                          time_zone => 'UTC' );

we will get different results when adding 1 minute than we get if we
add 60 seconds.  This is because in this case, the last minute of the
day, beginning at 23:59:00, actually contains 61 seconds.

Here are the results we get:

  # 1971-12-31 23:59:30 - our starting datetime

  $dt->clone->add( minutes => 1 );
  # 1972-01-01 00:00:30 - one minute later

  $dt->clone->add( seconds => 60 );
  # 1972-01-01 00:00:29 - 60 seconds later

=head3 Local vs. UTC and 24 hours vs. 1 day

When doing date math, you are changing the I<local> datetime.  This is
generally the same as changing the UTC datetime, except when a change
crosses a daylight saving boundary.  The net effect of this is that a
single day may have more or less than 24.

Specifically, if you do this:

  my $dt = DateTime->new( year => 2003, month => 4, day => 5,
                          hour => 2,
                          time_zone => 'America/Chicago',
                        );
  $dt->add( days => 1 );

then you will produce an I<invalid> local time, and therefore an
exception will be thrown.

However, this works:

  my $dt = DateTime->new( year => 2003, month => 4, day => 5,
                          hour => 2,
                          time_zone => 'America/Chicago',
                        );
  $dt->add( hours => 24 );

and produces a datetime with the local time of "03:00".

Another way of thinking of this is that when doing date math, each of
the seconds, minutes, days, and months components is added separately
to the local time.

So when we add 1 day to "2003-02-22 12:00:00" we are incrementing day
component, 22, by one in order to produce 23.  If we add 24 hours,
however, we're adding "24 * 60" minutes to the time component, and
then normalizing the result (because there is no "36:00:00").

If all this makes your head hurt, there is a simple alternative.  Just
convert your datetime object to the "UTC" time zone before doing date
math on it, and switch it back to the local time zone afterwards.
This avoids the possibility of having date math throw an exception,
and makes sure that 1 day equals 24 hours.  Of course, this may not
always be desirable, so caveat user!

=head3 The Results of Date Math

Because date math is done on each unit separately, the results of date
math may not always be what you expect.

Internally, a duration is made up internally of several different
units, months, days, minutes, seconds, and nanoseconds.

Of those, the only ones that convert or normalize to other units are
seconds <=> nanoseconds.  For all the others, there is no fixed
conversion between the two units, because of things like leap seconds,
DST changes, etc.

Here's an example, based on a question from Mark Fowler to the
datetime@perl.org list.

If you want to know how many seconds a duration really represents, you
have to add it to a datetime to find out, so you could do:

 my $now = DateTime->now( time_zone => 'UTC' );
 my $later = $now->clone->add_duration($duration);

 my $seconds_dur = $later->subtract_datetime_absolute($now);

This returns a duration which only contains seconds and nanoseconds.
There are other subtract/delta methods in DateTime.pm to generate
different types of durations.  These methods are
C<subtract_datetime()>, C<subtract_datetime_absolute()>,
C<delta_md()>, L<delta_days()>, and C<delta_ms()>.

=head2 Overloading

This module explicitly overloads the addition (+), subtraction (-),
string and numeric comparison operators.  This means that the
following all do sensible things:

  my $new_dt = $dt + $duration_obj;

  my $new_dt = $dt - $duration_obj;

  my $duration_obj = $dt - $new_dt;

  foreach my $dt ( sort @dts ) { ... }

Additionally, the fallback parameter is set to true, so other
derivable operators (+=, -=, etc.) will work properly.  Do not expect
increment (++) or decrement (--) to do anything useful.

The module also overloads stringification to use the C<iso8601()>
method.

=head2 strftime Specifiers

The following specifiers are allowed in the format string given to the
C<strftime()> method:

=over 4

=item * %a

The abbreviated weekday name.

=item * %A

The full weekday name.

=item * %b

The abbreviated month name.

=item * %B

The full month name.

=item * %c

The default datetime format for the object's locale.

=item * %C

The century number (year/100) as a 2-digit integer.

=item * %d

The day of the month as a decimal number (range 01 to 31).

=item * %D

Equivalent to %m/%d/%y.  This is not a good standard format if you
have want both Americans and Europeans to understand the date!

=item * %e

Like %d, the day of the month as a decimal number, but a leading zero
is replaced by a space.

=item * %F

Equivalent to %Y-%m-%d (the ISO 8601 date format)

=item * %G

The ISO 8601 year with century as a decimal number.  The 4-digit year
corresponding to the ISO week number (see %V).  This has the same
format and value as %y, except that if the ISO week number belongs to
the previous or next year, that year is used instead. (TZ)

=item * %g

Like %G, but without century, i.e., with a 2-digit year (00-99).

=item * %h

Equivalent to %b.

=item * %H

The hour as a decimal number using a 24-hour clock (range 00 to 23).

=item * %I

The hour as a decimal number using a 12-hour clock (range 01 to 12).

=item * %j

The day of the year as a decimal number (range 001 to 366).

=item * %k

The hour (24-hour clock) as a decimal number (range 0 to 23); single
digits are preceded by a blank. (See also %H.)

=item * %l

The hour (12-hour clock) as a decimal number (range 1 to 12); single
digits are preceded by a blank. (See also %I.)

=item * %m

The month as a decimal number (range 01 to 12).

=item * %M

The minute as a decimal number (range 00 to 59).

=item * %n

A newline character.

=item * %N

The fractional seconds digits. Default is 9 digits (nanoseconds).

  %3N   milliseconds (3 digits)
  %6N   microseconds (6 digits)
  %9N   nanoseconds  (9 digits)

=item * %p

Either `AM' or `PM' according to the given time value, or the
corresponding strings for the current locale.  Noon is treated as `pm'
and midnight as `am'.

=item * %P

Like %p but in lowercase: `am' or `pm' or a corresponding string for
the current locale.

=item * %r

The time in a.m.  or p.m. notation.  In the POSIX locale this is
equivalent to `%I:%M:%S %p'.

=item * %R

The time in 24-hour notation (%H:%M). (SU) For a version including the
seconds, see %T below.

=item * %s

The number of seconds since the epoch.

=item * %S

The second as a decimal number (range 00 to 61).

=item * %t

A tab character.

=item * %T

The time in 24-hour notation (%H:%M:%S).

=item * %u

The day of the week as a decimal, range 1 to 7, Monday being 1.  See
also %w.

=item * %U

The week number of the current year as a decimal number, range 00 to
53, starting with the first Sunday as the first day of week 01. See
also %V and %W.

=item * %V

The ISO 8601:1988 week number of the current year as a decimal number,
range 01 to 53, where week 1 is the first week that has at least 4
days in the current year, and with Monday as the first day of the
week. See also %U and %W.

=item * %w

The day of the week as a decimal, range 0 to 6, Sunday being 0.  See
also %u.

=item * %W

The week number of the current year as a decimal number, range 00 to
53, starting with the first Monday as the first day of week 01.

=item * %x

The default date format for the object's locale.

=item * %X

The default time format for the object's locale.

=item * %y

The year as a decimal number without a century (range 00 to 99).

=item * %Y

The year as a decimal number including the century.

=item * %z

The time-zone as hour offset from UTC.  Required to emit
RFC822-conformant dates (using "%a, %d %b %Y %H:%M:%S %z").

=item * %Z

The time zone or name or abbreviation.

=item * %%

A literal `%' character.

=item * %{method}

Any method name may be specified using the format C<%{method}> name
where "method" is a valid C<DateTime.pm> object method.

=back

=head1 DateTime.pm and Storable

As of version 0.13, DateTime implements Storable hooks in order to
reduce the size of a serialized DateTime object.

=head1 SUPPORT

Support for this module is provided via the datetime@perl.org email
list.  See http://lists.perl.org/ for more details.

Please submit bugs to the CPAN RT system at
http://rt.cpan.org/NoAuth/ReportBug.html?Queue=datetime or via email
at bug-datetime@rt.cpan.org.

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
