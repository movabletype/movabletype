package DateTime::TimeZone::OlsonDB;

use strict;

use vars qw( %MONTHS %DAYS $PLUS_ONE_DAY_DUR $MINUS_ONE_DAY_DUR );

use Params::Validate qw( validate SCALAR );

sub DEBUG () { 0 }

my $x = 1;
%MONTHS = map { $_ => $x++ }
          qw( Jan Feb Mar Apr May Jun
	      Jul Aug Sep Oct Nov Dec);

$x = 1;
%DAYS = map { $_ => $x++ }
        qw( Mon Tue Wed Thu Fri Sat Sun );

$PLUS_ONE_DAY_DUR =  DateTime::Duration->new( days => 1 );
$MINUS_ONE_DAY_DUR = DateTime::Duration->new( days => -1 );

sub new
{
    my $class = shift;

    return bless { rules => {},
                   zones => {},
                   links => {},
                 }, $class;
}

sub parse_file
{
    my $self = shift;
    my $file = shift;

    open my $fh, "<$file"
        or die "Cannot read $file: $!";

    while (<$fh>)
    {
        chomp;
        $self->_parse_line($_);
    }
}

sub _parse_line
{
    my $self = shift;
    my $line = shift;

    return if $line =~ /^\s+$/;
    return if $line =~ /^#/;

    # remove any comments at the end of the line
    $line =~ s/\s*#.+$//;

    if ( $self->{in_zone} && $line =~ /^\t/ )
    {
        $self->_parse_zone( $line, $self->{in_zone} );
        return;
    }

    foreach ( qw( Rule Zone Link ) )
    {
        if ( substr( $line, 0, 4 ) eq $_ )
        {
            my $m = '_parse_' . lc $_;
            $self->$m($line);
        }
    }
}

sub _parse_rule
{
    my $self = shift;
    my $rule = shift;

    my @items = split /\s+/, $rule, 10;

    shift @items;
    my $name = shift @items;

    my %rule;
    @rule{ qw( from to type in on at save letter ) } = @items;
    delete $rule{letter} if $rule{letter} eq '-';

    # As of the 2003a data, there are no rules with a type set
    delete $rule{type} if $rule{type} eq '-';

    push @{ $self->{rules}{$name} },
        DateTime::TimeZone::OlsonDB::Rule->new( name => $name, %rule );

    undef $self->{in_zone};
}

sub _parse_zone
{
    my $self = shift;
    my $zone = shift;
    my $name = shift;

    my $expect = $name ? 5 : 6;
    my @items = grep { defined && length } split /\s+/, $zone, $expect;

    my %obs;
    unless ($name)
    {
        shift @items; # remove "Zone"
        $name = shift @items;
    }

    return if $name =~ /[WCME]ET/ && ! $self->{backwards_compat};

    @obs{ qw( gmtoff rules format until ) } = @items;

    if ( $obs{rules} =~ /\d\d?:\d\d/ )
    {
        $obs{offset_from_std} = delete $obs{rules};
    }
    else
    {
        delete $obs{rules} if $obs{rules} eq '-';
    }

    delete $obs{until} unless defined $obs{until};

    push @{ $self->{zones}{$name} }, \%obs;

    $self->{in_zone} = $name;
}

sub _parse_link
{
    my $self = shift;
    my $link = shift;

    my @items = split /\s+/, $link, 3;

    $self->{links}{ $items[2] } = $items[1];

    undef $self->{in_zone};
}

sub links { %{ $_[0]->{links} } }

sub zone_names { keys %{ $_[0]->{zones} } }

sub zone
{
    my $self = shift;
    my $name = shift;

    die "Invalid zone name $name"
        unless exists $self->{zones}{$name};

    return
        DateTime::TimeZone::OlsonDB::Zone->new
            ( name => $name,
              observances => $self->{zones}{$name},
              olson_db => $self,
            );
}

sub expanded_zone
{
    my $self = shift;
    my %p = validate( @_, { name => { type => SCALAR },
                            expand_to_year => { type => SCALAR,
                                                default => (localtime)[5] + 1910 },
                          } );

    my $zone = $self->zone( $p{name} );

    $zone->expand_observances( $self, $p{expand_to_year} );

    return $zone;
}

sub rules_by_name
{
    my $self = shift;
    my $name = shift;

    return unless defined $name;

    die "Invalid rule name $name"
        unless exists $self->{rules}{$name};

    return @{ $self->{rules}{$name} };
}

sub parse_day_spec
{
    my ( $day, $month, $year ) = @_;

    return $day if $day =~ /^\d+$/;

    if ( $day =~ /^last(\w\w\w)$/ )
    {
        my $dow = $DateTime::TimeZone::OlsonDB::DAYS{$1};

        my $last_day = DateTime->last_day_of_month( year  => $year,
                                                    month => $month,
                                                    time_zone => 'floating',
                                                  );

        my $dt =
            DateTime->new( year   => $year,
                           month  => $month,
                           day    => $last_day->day,
                           time_zone => 'floating',
                         );

        while ( $dt->day_of_week != $dow )
        {
            $dt -= $PLUS_ONE_DAY_DUR;
        }

        return $dt->day;
    }
    elsif ( $day =~ /^(\w\w\w)([><])=(\d\d?)$/ )
    {
        my $dow = $DateTime::TimeZone::OlsonDB::DAYS{$1};

        my $dt = DateTime->new( year   => $year,
                                month  => $month,
                                day    => $3,
                                time_zone => 'floating',
                              );

        my $dur = $2 eq '<' ? $MINUS_ONE_DAY_DUR : $PLUS_ONE_DAY_DUR;

        while ( $dt->day_of_week != $dow )
        {
            $dt += $dur;
        }

        return $dt->day;
    }
    else
    {
        die "Invalid on spec for rule: $day\n";
    }
}

sub utc_datetime_for_time_spec
{
    my %p = validate( @_, { spec  => { type => SCALAR },
                            year  => { type => SCALAR },
                            month => { type => SCALAR },
                            day   => { type => SCALAR },
                            offset_from_utc => { type => SCALAR },
                            offset_from_std => { type => SCALAR },
                          },
                    );

    # 'w'all - ignore it, because that's the default
    $p{spec} =~ s/w$//;

    # 'g'reenwich, 'u'tc, or 'z'ulu
    my $is_utc = $p{spec} =~ s/[guz]$//;

    # 's'tandard time - ignore DS offset
    my $is_std = $p{spec} =~ s/s$//;

    my ($hour, $minute, $second) = split /:/, $p{spec};
    $minute = 0 unless defined $minute;
    $second = 0 unless defined $second;

    my $add_day = 0;
    if ( $hour == 24 )
    {
        $hour = 0;
        $add_day = 1;
    }

    my $utc;
    if ($is_utc)
    {
        $utc = DateTime->new( year   => $p{year},
                              month  => $p{month},
                              day    => $p{day},
                              hour   => $hour,
                              minute => $minute,
                              second => $second,
                              time_zone => 'floating',
                            );
    }
    else
    {
        my $local = DateTime->new( year   => $p{year},
                                   month  => $p{month},
                                   day    => $p{day},
                                   hour   => $hour,
                                   minute => $minute,
                                   second => $second,
                                   time_zone => 'floating',
                                 );

        $p{offset_from_std} = 0 if $is_std;

        my $dur =
            DateTime::Duration->new
                ( seconds => $p{offset_from_utc} + $p{offset_from_std} );

        $utc = $local - $dur;
    }

    $utc->add( days => 1 ) if $add_day;

    return $utc;
}


package DateTime::TimeZone::OlsonDB::Zone;

use strict;

use DateTime::TimeZone;

use Params::Validate qw( validate SCALAR ARRAYREF );

sub new
{
    my $class = shift;
    my %p = validate( @_, { name => { type => SCALAR },
                            observances => { type => ARRAYREF },
                            olson_db => 1,
                          }
                    );

    my $self = { name => $p{name},
                 observances => $p{observances},
                 changes => [],
                 infinite_rules => {},
               };

    return bless $self, $class;
}

sub name { $_[0]->{name} }

sub expand_observances
{
    my $self = shift;
    my $odb = shift;
    my $max_year = shift;

    my $prev_until;
    for ( my $x = 0; $x < @{ $self->{observances} }; $x++ )
    {
        my %p = %{ $self->{observances}[$x] };
        my $rules_name = delete $p{rules};

        my $last_offset_from_std =
            $self->last_change ? $self->last_change->offset_from_std : 0;
        my $last_offset_from_utc =
            $self->last_change ? $self->last_change->offset_from_utc : 0;

        my $obs =
            DateTime::TimeZone::OlsonDB::Observance->new
                ( %p,
                  utc_start_datetime => $prev_until,
                  rules => [ $odb->rules_by_name($rules_name) ],
                  last_offset_from_utc => $last_offset_from_utc,
                  last_offset_from_std => $last_offset_from_std,
                );

        my $rule = $obs->first_rule;
        my $letter = $rule ? $rule->letter : '';

        my $change =
            DateTime::TimeZone::OlsonDB::Change->new
                ( type => 'observance',
                  utc_start_datetime   => $obs->utc_start_datetime,
                  local_start_datetime => $obs->local_start_datetime,
                  short_name => sprintf( $obs->format, $letter ),
                  observance => $obs,
                  $rule ? ( rule => $rule ) : (),
                );

        if (DateTime::TimeZone::OlsonDB::DEBUG)
        {
            warn "Adding observance change ...\n";

            $change->_debug_output;
        }

        $self->add_change($change);

        if ( $obs->rules )
        {
            $obs->expand_from_rules( $self, $max_year );
        }

        $prev_until =
            $obs->until( $self->last_change ? $self->last_change->offset_from_std : 0 );

        # last observance
        if ( $x == $#{ $self->{observances} } )
        {
            foreach my $rule ( $obs->rules )
            {
                if ( $rule->is_infinite )
                {
                    $self->add_infinite_rule($rule);
                }
            }
        }
    }
}

sub add_change
{
    my $self = shift;
    my $change = shift;

    if ( defined $change->utc_start_datetime )
    {
        if ( @{ $self->{changes} }
             && $self->{changes}[-1]->utc_start_datetime
             && $self->{changes}[-1]->utc_start_datetime == $change->utc_start_datetime
           )
        {
            die "Cannot add two different changes that have the same UTC start datetime!\n";
        }

        my $last_change = $self->last_change;

        if ( $last_change->short_name eq $change->short_name
             && $last_change->total_offset == $change->total_offset
             && $last_change->is_dst == $change->is_dst
             && $last_change->observance eq $change->observance
           )
        {
            my $last_rule = $last_change->rule || '';
            my $new_rule = $change->rule || '';

            if ( $last_rule eq $new_rule )
            {
                warn "Skipping identical change\n" if DateTime::TimeZone::OlsonDB::DEBUG;

                return;
            }
        }

        push @{ $self->{changes} }, $change;
    }
    else
    {
        if ( $self->{earliest} )
        {
            die "There can only be one earliest time zone change!";
        }
        else
        {
            $self->{earliest} = $change;
        }
    }
}

sub add_infinite_rule
{
    $_[0]->{infinite_rules}{ $_[1] } = $_[1];
}

sub last_change { return unless @{ $_[0]->{changes} } || $_[0]->{earliest};
                  return ( @{ $_[0]->{changes} } ?
                           $_[0]->{changes}[-1] :
                           $_[0]->{earliest} ); }

sub sorted_changes { ( ( defined $_[0]->{earliest} ? $_[0]->{earliest} : () ),
                       sort { $a->utc_start_datetime <=> $b->utc_start_datetime }
                       @{ $_[0]->{changes} } ) }

sub infinite_rules { values %{ $_[0]->{infinite_rules} } }


package DateTime::TimeZone::OlsonDB::Observance;

use strict;

use DateTime;

use Params::Validate qw( validate SCALAR ARRAYREF UNDEF OBJECT );

sub new
{
    my $class = shift;
    my %p = validate( @_, { gmtoff => { type => SCALAR },
                            rules  => { type => ARRAYREF },
                            format => { type => SCALAR },
                            until  => { type => SCALAR, default => '' },
                            utc_start_datetime => { type => OBJECT | UNDEF },
                            offset_from_std => { type => SCALAR, default => 0 },
                            last_offset_from_utc => { type => SCALAR, default => 0 },
                            last_offset_from_std => { type => SCALAR, default => 0 },
                          }
                    );

    my $offset_from_utc = DateTime::TimeZone::offset_as_seconds( $p{gmtoff} );
    my $offset_from_std = DateTime::TimeZone::offset_as_seconds( $p{offset_from_std} );

    my $last_offset_from_utc = delete $p{last_offset_from_utc};
    my $last_offset_from_std = delete $p{last_offset_from_std};

    my $self = bless { %p,
                       offset_from_utc => $offset_from_utc,
                       offset_from_std => $offset_from_std,
                       until => [ split /\s+/, $p{until} ],
                     }, $class;

    my $local_start_datetime;
    if ( $p{utc_start_datetime} )
    {
        $self->{first_rule} =
            $self->_first_rule( $last_offset_from_utc, $last_offset_from_std );

        $offset_from_std += $self->{first_rule}->offset_from_std if $self->{first_rule};

        $local_start_datetime = $p{utc_start_datetime}->clone;

        $local_start_datetime +=
            DateTime::Duration->new( seconds => $offset_from_utc + $offset_from_std );

        $self->{local_start_datetime} = $local_start_datetime;
    }

    return $self;
}

sub offset_from_utc { $_[0]->{offset_from_utc} }
sub offset_from_std { $_[0]->{offset_from_std} }
sub total_offset { $_[0]->offset_from_utc + $_[0]->offset_from_std }

sub rules { @{ $_[0]->{rules} } }
sub first_rule { $_[0]->{first_rule} }

sub format { $_[0]->{format} }

sub utc_start_datetime   { $_[0]->{utc_start_datetime} }
sub local_start_datetime { $_[0]->{local_start_datetime} }

sub expand_from_rules
{
    my $self = shift;
    my $zone = shift;
    # real max is year + 1 so we include max year
    my $max_year = (shift) + 1;

    my $min_year;

    if ( $self->utc_start_datetime )
    {
        $min_year = $self->utc_start_datetime->year;
    }
    else
    {
        # There is at least one time zone that has an infinite
        # observance, but that observance has rules that only start at
        # a certain point - Pacific/Chatham

        # In this case we just find the earliest rule and start there

        $min_year = ( sort { $a <=> $b } map { $_->min_year } $self->rules )[0];
    }

    my $until = $self->until( $zone->last_change->offset_from_std );
    if ($until)
    {
        $max_year = $until->year;
    }
    else
    {
        # Some zones, like Asia/Tehran, have a predefined fixed set of
        # rules that go well into the future (2037 for Asia/Tehran)
        my $max_rule_year = 0;
        foreach my $rule ( $self->rules )
        {
            $max_rule_year = $rule->max_year
                if $rule->max_year && $rule->max_year > $max_rule_year;
        }

        $max_year = $max_rule_year if $max_rule_year > $max_year;
    }

    foreach my $year ( $min_year .. $max_year )
    {
        my @rules = $self->_sorted_rules_for_year($year);

        foreach my $rule (@rules)
        {
            my $dt =
                $rule->utc_start_datetime_for_year
                    ( $year, $self->offset_from_utc, $zone->last_change->offset_from_std );

            next if $self->utc_start_datetime && $dt <= $self->utc_start_datetime;

            my $until = $self->until( $zone->last_change->offset_from_std );

            next if $until && $dt >= $until;

            my $change =
                DateTime::TimeZone::OlsonDB::Change->new
                    ( type => 'rule',
                      utc_start_datetime   => $dt,
                      local_start_datetime =>
                      $dt +
                      DateTime::Duration->new
                          ( seconds => $self->total_offset + $rule->offset_from_std ),
                      short_name => sprintf( $self->{format}, $rule->letter ),
                      observance => $self,
                      rule       => $rule,
                    );

            if (DateTime::TimeZone::OlsonDB::DEBUG)
            {
                warn "Adding rule change ...\n";

                $change->_debug_output;
            }

            $zone->add_change($change);
        }
    }
}

sub _sorted_rules_for_year
{
    my $self = shift;
    my $year = shift;

    return
        ( map { $_->[0] }
          sort { $a->[1] <=> $b->[1] }
          map { my $dt = $_->utc_start_datetime_for_year( $year, $self->offset_from_utc, 0 );
                [ $_, $dt ] }
          grep { $_->min_year <= $year && ( ( ! $_->max_year ) || $_->max_year >= $year ) }
          $self->rules
        );
}

sub until
{
    my $self = shift;
    my $offset_from_std = shift || $self->offset_from_std;

    return unless defined $self->until_year;

    my $utc =
        DateTime::TimeZone::OlsonDB::utc_datetime_for_time_spec
                ( spec  => $self->until_time_spec,
                  year  => $self->until_year,
                  month => $self->until_month,
                  day   => $self->until_day,
                  offset_from_utc => $self->offset_from_utc,
                  offset_from_std => $offset_from_std,
                );

    return $utc;
}

sub until_year { $_[0]->{until}[0] }

sub until_month
{
    ( defined $_[0]->{until}[1] ?
      $DateTime::TimeZone::OlsonDB::MONTHS{ $_[0]->{until}[1] } :
      1
    );
}

sub until_day
{
    ( defined $_[0]->{until}[2]
      ? DateTime::TimeZone::OlsonDB::parse_day_spec
            ( $_[0]->{until}[2], $_[0]->until_month, $_[0]->until_year )
      : 1
    );
}

sub until_time_spec
{
    defined $_[0]->{until}[3] ? $_[0]->{until}[3] : '00:00:00';
}

sub _first_rule
{
    my $self = shift;
    my $last_offset_from_utc = shift;
    my $last_offset_from_std = shift;

    return unless $self->utc_start_datetime;
    return unless $self->rules;

    my $date = $self->utc_start_datetime;

    my @rules = $self->rules;

    my %possible_rules;

    my $year = $date->year;
    foreach my $rule (@rules)
    {
        # We need to look at what the year _would_ be if we added the
        # rule's offset to the UTC date.  Otherwise we can end up with
        # a UTC date in year X, and a rule that starts in _local_ year
        # X + 1, where that rule really does apply to that UTC date.
        my $temp_year =
            $date->clone->add
                ( seconds => $self->offset_from_utc + $rule->offset_from_std )->year;

        # Save the highest value
        $year = $temp_year if $temp_year > $year;

        next if $rule->min_year > $temp_year;

        $possible_rules{$rule} = $rule;
    }

    return unless keys %possible_rules;

    my $earliest_year = $year - 1;
    foreach my $rule (@rules)
    {
        $earliest_year = $rule->min_year
            if $rule->min_year < $earliest_year;
    }

    # figure out what date each rule would start on _if_ that rule
    # were applied to this current observance.  this could be a rule
    # that started much earlier, but is only now active because of an
    # observance switch.  An obnoxious example of this is
    # America/Phoenix in 1944, which applies the US rule in April,
    # thus (re-)instating the "war time" rule from 1942.  Can you say
    # ridiculous crack-smoking stupidity?
    my @rule_dates;
    foreach my $y ( $earliest_year .. $year )
    {
      RULE:
        foreach my $rule ( values %possible_rules )
        {
            # skip rules that can't have applied the year before the
            # observance started.
            if ( $rule->min_year > $y )
            {
                warn "Skipping rule beginning in ", $rule->min_year, ".  Year is $y.\n"
                    if DateTime::TimeZone::OlsonDB::DEBUG;

                next RULE;
            }

            if ( $rule->max_year && $rule->max_year < $y )
            {
                warn "Skipping rule ending in ", $rule->max_year, ".     Year is $y.\n"
                    if DateTime::TimeZone::OlsonDB::DEBUG;

                next RULE;
            }

            my $rule_start =
                $rule->utc_start_datetime_for_year
                    ( $y, $last_offset_from_utc, $last_offset_from_std );

            push @rule_dates, [ $rule_start, $rule ];
        }
    }

    return unless @rule_dates;

    @rule_dates = sort { $a->[0] <=> $b->[0] } @rule_dates;

    warn "Looking for first rule ...\n" if DateTime::TimeZone::OlsonDB::DEBUG;
    warn " Observance starts: ", $date->datetime, "\n\n"
        if DateTime::TimeZone::OlsonDB::DEBUG;

    # ... look through the rules to see if any are still in
    # effect at the beginning of the observance
    for ( my $x = 0; $x < @rule_dates; $x++ )
    {
        my ( $dt, $rule ) = @{ $rule_dates[$x] };
        my ( $next_dt, $next_rule ) =
            $x < @rule_dates - 1 ? @{ $rule_dates[ $x + 1 ] } : undef;

        next if $next_dt && $next_dt < $date;

        warn " This rule starts:  ", $dt->datetime, "\n"
            if DateTime::TimeZone::OlsonDB::DEBUG;

        warn " Next rule starts:  ", $next_dt->datetime, "\n"
            if $next_dt && DateTime::TimeZone::OlsonDB::DEBUG;

        warn " No next rule\n\n"
            if ! $next_dt && DateTime::TimeZone::OlsonDB::DEBUG;

        if ( $dt <= $date )
        {
            if ($next_dt)
            {
                return $rule if $date < $next_dt;
                return $next_rule if $date == $next_dt;
            }
            else
            {
                return $rule;
            }
        }
    }

    return;
}


package DateTime::TimeZone::OlsonDB::Rule;

use strict;

use DateTime;
use DateTime::Duration;

use Params::Validate qw( validate SCALAR );

sub new
{
    my $class = shift;
    my %p = validate( @_, { name => { type => SCALAR },
                            from => { type => SCALAR },
                            to   => { type => SCALAR },
                            type => { type => SCALAR, default => undef },
                            in   => { type => SCALAR },
                            on   => { type => SCALAR },
                            at   => { type => SCALAR },
                            save => { type => SCALAR },
                            letter => { type => SCALAR, default => '' },
                          },
                    );

    my $save = $p{save};

    if ($save)
    {
        $p{offset_from_std} = DateTime::TimeZone::offset_as_seconds($save);
    }
    else
    {
        $p{offset_from_std} = 0;
    }

    return bless \%p, $class;
}

sub name { $_[0]->{name} }
sub offset_from_std { $_[0]->{offset_from_std} }
sub letter { $_[0]->{letter} }
sub min_year { $_[0]->{from} }

sub max_year { $_[0]->{to} eq 'only' ? $_[0]->min_year :
               $_[0]->{to} eq 'max' ? undef : $_[0]->{to} }

sub is_infinite { $_[0]->{to} eq 'max' ? 1 : 0 }

sub month { $DateTime::TimeZone::OlsonDB::MONTHS{ $_[0]->{in} } }
sub on { $_[0]->{on} }
sub at { $_[0]->{at} }

sub utc_start_datetime_for_year
{
    my $self   = shift;
    my $year   = shift;
    my $offset_from_utc = shift;
    # should be the offset of the _previous_ rule
    my $offset_from_std = shift;

    my $day =
        DateTime::TimeZone::OlsonDB::parse_day_spec( $self->on, $self->month, $year );

    my $utc =
        DateTime::TimeZone::OlsonDB::utc_datetime_for_time_spec
                ( spec  => $self->at,
                  year  => $year,
                  month => $self->month,
                  day   => $day,
                  offset_from_utc => $offset_from_utc,
                  offset_from_std => $offset_from_std,
                );

    return $utc;
}


package DateTime::TimeZone::OlsonDB::Change;

use strict;

use Params::Validate qw( validate SCALAR UNDEF OBJECT );

sub new
{
    my $class = shift;
    my %p = validate( @_, { utc_start_datetime   => { type => UNDEF | OBJECT },
                            local_start_datetime => { type => UNDEF | OBJECT },
                            short_name => { type => SCALAR },
                            observance => { type => OBJECT },
                            rule       => { type => OBJECT, default => undef },
                            type       => { type => SCALAR,
                                            regex => qr/^(?:observance|rule)$/ },
                          }
                    );

    # These are almost always mutually exclusive, except when adding
    # an observance change and the last rule has no offset, but the
    # new observance has an anonymous rule.  In that case, prefer the
    # offset from std defined in the observance to that in the
    # previous rule (what a mess!).
    if ( $p{type} eq 'observance' )
    {
        $p{offset_from_std} = $p{rule}->offset_from_std if defined $p{rule};
        $p{offset_from_std} = $p{observance}->offset_from_std
            if $p{observance}->offset_from_std;
        $p{offset_from_std} ||= 0;
    }
    else
    {
        $p{offset_from_std} = $p{observance}->offset_from_std;
        $p{offset_from_std} = $p{rule}->offset_from_std if defined $p{rule};
    }

    $p{offset_from_utc} = $p{observance}->offset_from_utc;

    $p{is_dst} = 0;
    $p{is_dst} = 1 if $p{rule} && $p{rule}->offset_from_std;
    $p{is_dst} = 1 if $p{observance}->offset_from_std;

    return bless \%p, $class;
}

sub utc_start_datetime   { $_[0]->{utc_start_datetime} }
sub local_start_datetime { $_[0]->{local_start_datetime} }
sub short_name { $_[0]->{short_name} }
sub is_dst     { $_[0]->{is_dst} }
sub observance { $_[0]->{observance} }
sub rule       { $_[0]->{rule} }
sub offset_from_utc { $_[0]->{offset_from_utc} }
sub offset_from_std { $_[0]->{offset_from_std} }
sub total_offset { $_[0]->offset_from_utc + $_[0]->offset_from_std }

sub two_changes_as_span
{
    my ( $c1, $c2, $last_total_offset ) = @_;

    my ( $utc_start, $local_start );

    if ( defined $c1->utc_start_datetime )
    {
        $utc_start = $c1->utc_start_datetime->utc_rd_as_seconds;
        $local_start = $c1->local_start_datetime->utc_rd_as_seconds;
    }
    else
    {
        $utc_start = $local_start = '-inf';
    }

    my $utc_end = $c2->utc_start_datetime->utc_rd_as_seconds;
    my $local_end = $utc_end + $c1->total_offset;

    return { utc_start   => $utc_start,
             utc_end     => $utc_end,
             local_start => $local_start,
             local_end   => $local_end,
             short_name  => $c1->short_name,
             offset      => $c1->total_offset,
             is_dst      => $c1->is_dst,
           };
}

sub _debug_output
{
    my $self = shift;

    my $obs = $self->observance;

    if ( $self->utc_start_datetime )
    {
        warn " UTC:        ", $self->utc_start_datetime->datetime, "\n";
        warn " Local:      ", $self->local_start_datetime->datetime, "\n";
    }
    else
    {
        warn " First change (starts at -inf)\n";
    }

    warn " Short name: ", $self->short_name, "\n";
    warn " UTC offset: ", $obs->offset_from_utc, "\n";

    if ( $obs->offset_from_std || $self->rule )
    {
        if ( $obs->offset_from_std )
        {
            warn " Std offset: ", $obs->offset_from_std, "\n";
        }

        if ( $self->rule )
        {
            warn " Std offset: ", $self->rule->offset_from_std, ' - ',
                 $self->rule->name, " rule\n";
        }
    }
    else
    {
        warn " Std offset: 0 - no rule\n";
    }

    warn "\n";
}

1;

__END__

=head1 NAME

DateTime::TimeZone::OlsonDB - An object to represent an Olson time zone database

=head1 SYNOPSIS

  none yet

=head1 DESCRIPTION

This module parses the Olson database time zone definition files and
creates various objects representing time zone data.

Each time zone is broken down into several parts.  The first piece is
an observance, which is an offset from UTC and an abbreviation.  A
single zone may contain many observances, reflecting historical
changes in that time zone over time.  An observance may also refer to
a set of rules.

Rules are named, and may apply to many different zones.  For example,
the "US" rules apply to most of the time zones in the US,
unsurprisingly.  Rules are made of an offset from standard time and a
definition of when that offset changes.  Changes can be a one time
thing, or they can recur at regular times through a span of years.

Each rule may have an associated letter, which is used to generate an
abbreviated name for the time zone, along with the offset's
abbreviation.  For example, if the offset's abbreviation is "C%sT",
and the a rule specifies the letter "S", then the abbreviation when
that rule is in effect is "CST".

=head1 USAGE

Not yet documented.  This stuff is a mess.

=cut
