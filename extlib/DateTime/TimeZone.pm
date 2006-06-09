package DateTime::TimeZone;

use strict;

use vars qw( $VERSION );
$VERSION = '0.2601';

use DateTime::TimeZoneCatalog;
use DateTime::TimeZone::Floating;
use DateTime::TimeZone::Local;
use DateTime::TimeZone::OffsetOnly;
use DateTime::TimeZone::UTC;
use Params::Validate qw( validate validate_pos SCALAR ARRAYREF BOOLEAN );

use constant INFINITY     =>       100 ** 100 ** 100 ;
use constant NEG_INFINITY => -1 * (100 ** 100 ** 100);

# the offsets for each span element
use constant UTC_START   => 0;
use constant UTC_END     => 1;
use constant LOCAL_START => 2;
use constant LOCAL_END   => 3;
use constant OFFSET      => 4;
use constant IS_DST      => 5;
use constant SHORT_NAME  => 6;

sub new
{
    my $class = shift;
    my %p = validate( @_,
                      { name => { type => SCALAR } },
                    );

    if ( exists $DateTime::TimeZone::LINKS{ $p{name} } )
    {
        $p{name} = $DateTime::TimeZone::LINKS{ $p{name} };
    }
    elsif ( exists $DateTime::TimeZone::LINKS{ uc $p{name} } )
    {
        $p{name} = $DateTime::TimeZone::LINKS{ uc $p{name} };
    }

    unless ( $p{name} =~ m,/, )
    {
        if ( $p{name} eq 'floating' )
        {
            return DateTime::TimeZone::Floating->new;
        }

        if ( $p{name} eq 'local' )
        {
            return DateTime::TimeZone::Local::local_time_zone();
        }

        if ( $p{name} eq 'UTC' || $p{name} eq 'Z' )
        {
            return DateTime::TimeZone::UTC->new;
        }

        return DateTime::TimeZone::OffsetOnly->new( offset => $p{name} );
    }

    my $subclass = $p{name};
    $subclass =~ s/-/_/g;
    $subclass =~ s{/}{::}g;
    my $real_class = "DateTime::TimeZone::$subclass";

    unless ( $real_class->can('instance') )
    {
        eval "require $real_class";

        if ($@)
        {
            my $regex = join '.', split /::/, $real_class;
            $regex .= '\\.pm';

            if ( $@ =~ /^Can't locate $regex/i )
            {
                die "The timezone '$p{name}' could not be loaded, or is an invalid name.\n";
            }
            else
            {
                die $@;
            }
        }
    }

    return $real_class->instance( name => $p{name}, is_olson => 1 );
}

sub _init
{
    my $class = shift;
    my %p = validate( @_,
                      { name     => { type => SCALAR },
                        spans    => { type => ARRAYREF },
                        is_olson => { type => BOOLEAN, default => 0 },
                      },
                    );

    my $self = bless { name     => $p{name},
                       spans    => $p{spans},
                       is_olson => $p{is_olson},
                     }, $class;

    foreach my $k ( qw( last_offset last_observance rules max_year ) )
    {
        my $m = "_$k";
        $self->{$k} = $self->$m() if $self->can($m);
    }

    return $self;
}

sub is_olson { $_[0]->{is_olson} }

sub is_dst_for_datetime
{
    my $self = shift;

    my $span = $self->_span_for_datetime( 'utc', $_[0] );

    return $span->[IS_DST];
}

sub offset_for_datetime
{
    my $self = shift;

    my $span = $self->_span_for_datetime( 'utc', $_[0] );

    return $span->[OFFSET];
}

sub offset_for_local_datetime
{
    my $self = shift;

    my $span = $self->_span_for_datetime( 'local', $_[0] );

    return $span->[OFFSET];
}

sub short_name_for_datetime
{
    my $self = shift;

    my $span = $self->_span_for_datetime( 'utc', $_[0] );

    return $span->[SHORT_NAME];
}

sub _span_for_datetime
{
    my $self = shift;
    my $type = shift;
    my $dt   = shift;

    my $method = $type . '_rd_as_seconds';

    my $end = $type eq 'utc' ? UTC_END : LOCAL_END;

    my $span;
    my $seconds = $dt->$method();
    if ( $seconds < $self->max_span->[$end] )
    {
        $span = $self->_spans_binary_search( $type, $seconds );
    }
    else
    {
        my $until_year = $dt->utc_year + 1;
        $span = $self->_generate_spans_until_match( $until_year, $seconds, $type );
    }

    # This means someone gave a local time that doesn't exist
    # (like during a transition into savings time)
    unless ( defined $span )
    {
        my $err = 'Invalid local time for date';
        $err .= ' ' . $dt->iso8601 if $type eq 'utc';
        $err .= " in time zone: " . $self->name;
        $err .= "\n";

        die $err;
    }

    return $span;
}

sub _spans_binary_search
{
    my $self = shift;
    my ( $type, $seconds ) = @_;

    my ( $start, $end ) = _keys_for_type($type);

    my $min = 0;
    my $max = scalar @{ $self->{spans} } + 1;
    my $i = int( $max / 2 );
    # special case for when there are only 2 spans
    $i++ if $max % 2 && $max != 3;

    $i = 0 if @{ $self->{spans} } == 1;

    while (1)
    {
        my $current = $self->{spans}[$i];

        if ( $seconds < $current->[$start] )
        {
            $max = $i;
            my $c = int( ( $i - $min ) / 2 );
            $c ||= 1;

            $i -= $c;

            return if $i < $min;
        }
        elsif ( $seconds >= $current->[$end] )
        {
            $min = $i;
            my $c = int( ( $max - $i ) / 2 );
            $c ||= 1;

            $i += $c;

            return if $i >= $max;
        }
        else
        {
            # Special case for overlapping ranges because of DST and
            # other weirdness (like Alaska's change when bought from
            # Russia by the US).  Always prefer latest span.
            if ( $current->[IS_DST] && $type eq 'local' )
            {
                my $next = $self->{spans}[$i + 1];

                if ( ( ! $next->[IS_DST] )
                     && $next->[$start] <= $seconds
                     && $seconds        <= $next->[$end]
                   )
                {
                    return $next;
                }
            }

            return $current;
        }
    }
}

sub _generate_spans_until_match
{
    my $self = shift;
    my $generate_until_year = shift;
    my $seconds = shift;
    my $type = shift;

    my @changes;
    my @rules = @{ $self->_rules };
    foreach my $year ( $self->{max_year} .. $generate_until_year )
    {
        for ( my $x = 0; $x < @rules; $x++ )
        {
            my $last_offset_from_std;

            if ( @rules == 2 )
            {
                $last_offset_from_std =
                    $x ? $rules[0]->offset_from_std : $rules[1]->offset_from_std;
            }
            elsif ( @rules == 1 )
            {
                $last_offset_from_std = $rules[0]->offset_from_std;
            }
            else
            {
                my $count = scalar @rules;
                die "Cannot generate future changes for zone with $count infinite rules\n";
            }

            my $rule = $rules[$x];

            my $next =
                $rule->utc_start_datetime_for_year
                    ( $year, $self->{last_offset}, $last_offset_from_std );

            # don't bother with changes we've seen already
            next if $next->utc_rd_as_seconds < $self->max_span->[UTC_END];

            push @changes,
                DateTime::TimeZone::OlsonDB::Change->new
                    ( type => 'rule',
                      utc_start_datetime   => $next,
                      local_start_datetime =>
                      $next +
                      DateTime::Duration->new
                          ( seconds => $self->{last_observance}->total_offset +
                                       $rule->offset_from_std ),
                      short_name =>
                      sprintf( $self->{last_observance}->format, $rule->letter ),
                      observance => $self->{last_observance},
                      rule       => $rule,
                    );
        }
    }

    $self->{max_year} = $generate_until_year;

    my @sorted = sort { $a->utc_start_datetime <=> $b->utc_start_datetime } @changes;

    my ( $start, $end ) = _keys_for_type($type);

    my $match;
    for ( my $x = 1; $x < @sorted; $x++ )
    {
        my $last_total_offset =
            $x == 1 ? $self->max_span->[OFFSET] : $sorted[ $x - 2 ]->total_offset;

        my $span =
            DateTime::TimeZone::OlsonDB::Change::two_changes_as_span
                ( @sorted[ $x - 1, $x ], $last_total_offset );

        $span = _span_as_array($span);

        push @{ $self->{spans} }, $span;

        $match = $span
            if $seconds >= $span->[$start] && $seconds < $span->[$end];
    }

    return $match;
}

sub max_span { $_[0]->{spans}[-1] }

sub _keys_for_type
{
    $_[0] eq 'utc' ? ( UTC_START, UTC_END ) : ( LOCAL_START, LOCAL_END );
}

sub _span_as_array
{
    [ @{ $_[0] }{ qw( utc_start utc_end local_start local_end offset is_dst short_name ) } ];
}

sub is_floating { 0 }

sub is_utc { 0 }

sub name      { $_[0]->{name} }
sub category  { (split /\//, $_[0]->{name}, 2)[0] }

sub is_valid_name
{
    my $tz = eval { $_[0]->new( name => $_[1] ) };

    return $tz && UNIVERSAL::isa( $tz, 'DateTime::TimeZone') ? 1 : 0
}

sub STORABLE_freeze
{
    my $self = shift;

    return $self->name;
}

sub STORABLE_thaw
{
    my $self = shift;
    my $cloning = shift;
    my $serialized = shift;

    my $class = ref $self || $self;

    my $obj;
    if ( $class->isa(__PACKAGE__) )
    {
        $obj = __PACKAGE__->new( name => $serialized );
    }
    else
    {
        $obj = $class->new( name => $serialized );
    }

    # This breaks the "singleton-ness" of timezone objects, but
    # there's no way to tell Storable to simply use an existing
    # object.  This shouldn't matter since we copy the underlying
    # structures by reference here, so span generation in one object
    # will be visible in another also in memory.
    %$self = %$obj;
}

#
# Functions
#
sub offset_as_seconds
{
    my $offset = shift;

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

sub offset_as_string
{
    my $offset = shift;

    return undef unless defined $offset;
    return undef unless $offset >= -359999 && $offset <= 359999;

    my $sign = $offset < 0 ? '-' : '+';

    $offset = abs($offset);

    my $hours = int( $offset / 3600 );
    $offset %= 3600;
    my $mins = int( $offset / 60 );
    $offset %= 60;
    my $secs = int( $offset );

    return ( $secs ?
             sprintf( '%s%02d%02d%02d', $sign, $hours, $mins, $secs ) :
             sprintf( '%s%02d%02d', $sign, $hours, $mins )
           );
}


1;

__END__

=head1 NAME

DateTime::TimeZone - Time zone object base class and factory

=head1 SYNOPSIS

  use DateTime;
  use DateTime::TimeZone

  my $tz = DateTime::TimeZone->new( name => 'America/Chicago' );

  my $dt = DateTime->now();
  my $offset = $tz->offset_for_datetime($dt);

=head1 DESCRIPTION

This class is the base class for all time zone objects.  A time zone
is represented internally as a set of observances, each of which
describes the offset from GMT for a given time period.

Note that without the C<DateTime.pm> module, this module does not do
much.  It's primary interface is through a C<DateTime> object, and
most users will not need to directly use C<DateTime::TimeZone>
methods.

=head1 USAGE

This class has the following methods:

=over 4

=item * new( name => $tz_name )

Given a valid time zone name, this method returns a new time zone
blessed into the appropriate subclass.  Subclasses are named for the
given time zone, so that the time zone "America/Chicago" is the
DateTime::TimeZone::America::Chicago class.

If the name given is a "link" name in the Olson database, the object
created may have a different name.  For example, there is a link from
the old "EST5EDT" name to "America/New_York".

There are also several special values that can be given as names.

If the "name" parameter is "floating", then a
C<DateTime::TimeZone::Floating> object is returned.  A floating time
zone does have I<any> offset, and is always the same time.  This is
useful for calendaring applications, which may need to specify that a
given event happens at the same I<local> time, regardless of where it
occurs.  See RFC 2445 for more details.

If the "name" parameter is "UTC", then a C<DateTime::TimeZone::UTC>
object is returned.

If the "name" is an offset string, it is converted to a number, and a
C<DateTime::TimeZone::OffsetOnly> object is returned.

=back

=head3 The "local" time zone

If the "name" parameter is "local", then the module attempts to
determine the local time zone for the system.

First it checks C<$ENV> for keys named "TZ", "SYS$TIMEZONE_RULE",
"SYS$TIMEZONE_NAME", "UCX$TZ", or "TCPIP$TZC" (the last 4 are for
VMS).  If this is defined, and it is not the string "local", then it
is treated as any other valid name (including "floating"), and the
constructor tries to create a time zone based on that name.

Next, it checks for the existence of a symlink at F</etc/localtime>.
It follows this link to the real file and figures out what the file's
name is.  It then tries to turn this name into a valid time zone.  For
example, if this file is linked to F</usr/share/zoneinfo/US/Central>,
it will end up trying "US/Central", which will then be converted to
"America/Chicago" internally.

Some systems just copy the relevant file to F</etc/localtime> instead
of making a symlink.  In this case, we look in F</usr/share/zoneinfo>
for a file that has the same size and content as F</etc/localtime> to
determine the local time zone.

Then it checks for a file called F</etc/timezone> or F</etc/TIMEZONE>.
If one of these exists, it is read and it tries to create a time zone
with the name contained in the file.

Finally, it checks for a file called F</etc/sysconfig/clock>.  If this
file exists, it looks for a line inside the file matching
C</^(?:TIME)ZONE="([^"]+)"/>.  If this line exists, it tries the value as a
time zone name.

If none of these methods work, it gives up and dies.

=head2 Object Methods

C<DateTime::TimeZone> objects provide the following methods:

=over 4

=item * offset_for_datetime( $dt )

Given a C<DateTime> object, this method returns the offset in seconds
for the given datetime.  This takes into account historical time zone
information, as well as Daylight Saving Time.  The offset is
determined by looking at the object's UTC Rata Die days and seconds.

=item * offset_for_local_datetime( $dt )

Given a C<DateTime> object, this method returns the offset in seconds
for the given datetime.  Unlike the previous method, this method uses
the local time's Rata Die days and seconds.  This should only be done
when the corresponding UTC time is not yet known, because local times
can be ambiguous due to Daylight Saving Time rules.

=item * name

Returns the name of the time zone.  If this value is passed to the
C<new()> method, it is guaranteed to create the same object.

=item * short_name_for_datetime( $dt )

Given a C<DateTime> object, this method returns the "short name" for
the current observance and rule this datetime is in.  These are names
like "EST", "GMT", etc.

It is B<strongly> recommended that you do not rely on these names for
anything other than display.  These names are not official, and many
of them are simply the invention of the Olson database maintainers.
Moreover, these names are not unique.  For example, there is an "EST"
at both -0500 and +1000/+1100.

=item * is_floating

Returns a boolean indicating whether or not this object represents a
floating time zone, as defined by RFC 2445.

=item * is_utc

Indicates whether or not this object represents the UTC (GMT) time
zone.

=item * is_olson

Returns true if the time zone is a named time zone from the Olson
database.

=item * category

Returns the part of the time zone name before the first slash.  For
example, the "America/Chicago" time zone would return "America".

=back

=head2 Class Methods

This class provides one class method:

=over 4

=item * is_valid_name ($name)

Given a string, this method returns a boolean value indicating whether
or not the string is a valid time zone name.  If you are using
C<DateTime::TimeZone::Alias>, any aliases you've created will be valid.

=back

=head2 Storable Hooks

This module provides freeze and thaw hooks for C<Storable> so that the
huge data structures for Olson time zones are not actually stored in
the serialized structure.

If you subclass C<DateTime::TimeZone>, you will inherit its hooks,
which may not work for your module, so please test the interaction of
your module with Storable.

=head2 Functions

This class also contains several functions, none of which are
exported.

=over 4

=item * all_names

This returns a pre-sorted list of all the time zone names.  This list
does not include link names.  In scalar context, it returns an array
reference, while in list context it returns an array.

=item * categories

This returns a list of all time zone categories.  In scalar context,
it returns an array reference, while in list context it returns an
array.

=item * links

This returns a hash of all time zone links, where the keys are the
old, deprecated names, and the values are the new names.  In scalar
context, it returns a hash reference, while in list context it returns
a hash.

=item * names_in_category( $category )

Given a valid category, this method returns a list of the names in
that category, without the category portion.  So the list for the
"America" category would include the strings "Chicago",
"Kentucky/Monticello", and "New_York".  In scalar context, it returns
an array reference, while in list context it returns an array.

=item * offset_as_seconds( $offset )

Given an offset as a string, this returns the number of seconds
represented by the offset as a positive or negative number.  Returns
C<undef> if $offset is not in the range C<-99:59:59> to C<+99:59:59>.

The offset is expected to match either
C</^([\+\-])?(\d\d?):(\d\d)(?::(\d\d))?$/> or
C</^([\+\-])?(\d\d)(\d\d)(\d\d)?$/>.  If it doesn't match either of
these, C<undef> will be returned.

This means that if you want to specify hours as a single digit, then
each element of the offset must be separated by a colon (:).

=item * offset_as_string( $offset )

Given an offset as a number, this returns the offset as a string.
Returns C<undef> if $offset is not in the range C<-359999> to C<359999>.

=back

=head1 SUPPORT

Support for this module is provided via the datetime@perl.org email
list.  See http://lists.perl.org/ for more details.

Please submit bugs to the CPAN RT system at
http://rt.cpan.org/NoAuth/ReportBug.html?Queue=datetime%3A%3Atimezone
or via email at bug-datetime-timezone@rt.cpan.org.

=head1 AUTHOR

Dave Rolsky <autarch@urth.org>, inspired by Jesse Vincent's work on
Date::ICal::Timezone, and with help from the datetime@perl.org list.

=head1 COPYRIGHT

Copyright (c) 2003 David Rolsky.  All rights reserved.  This program
is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.

The full text of the license can be found in the LICENSE file included
with this module.

=head1 SEE ALSO

datetime@perl.org mailing list

http://datetime.perl.org/

The tools directory of the DateTime::TimeZone distribution includes
two scripts that may be of interest to some people.  They are
parse_olson and tests_from_zdump.  Please run them with the --help
flag to see what they can be used for.

=cut
