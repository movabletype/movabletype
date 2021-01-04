# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Template::Tags::Calendar;

use strict;
use warnings;

use MT;
use MT::Util qw( start_end_month offset_time_list wday_from_ts days_in );

###########################################################################

=head2 Calendar

A container tag representing a calendar month that lists a single
calendar "cell" in the calendar display.

B<Attributes:>

=over 4

=item * month

An optional attribute that specifies the calendar month and year the
tagset is to generate. The value must be in YYYYMM format. The month
attribute also recognizes two special values. Given a value of "last",
the calendar will be generated for the previous month from the current
date. Using a value of "this" will generate a calendar for the
current month.

The default behavior is to generate a monthly calendar based on the
archive in context. When used in the context of an archive type
other then "Category," the calendar will be generated for the month
in which the archive falls.

=item * category

An optional attribute that specifies the name of a category from which
to return entries.

=item * weeks_start_with

weeks_start_with accepts the following values:
Sun | Mon | Tue | Wed | Thu | Fri | Sat

=back

B<Example:>

To produce a calendar for January, 2002 of entries in the category "Foo":

    <mt:Calendar month="200201" category="Foo">
        ...
    </mt:Calendar>

=for tags calendar

=cut

sub _hdlr_calendar {
    my ( $ctx, $args, $cond ) = @_;
    my $blog_id = $ctx->stash('blog_id');
    my ($prefix);
    my @ts = offset_time_list( time, $blog_id );
    my $today = sprintf "%04d%02d", $ts[5] + 1900, $ts[4] + 1;
    my $start_with_offset = 0;
    if ( my $start_with = lc( $args->{weeks_start_with} || '' ) ) {
        $start_with_offset = {
            sun => 0,
            mon => 6,
            tue => 5,
            wed => 4,
            thu => 3,
            fri => 2,
            sat => 1,
        }->{ substr( $start_with, 0, 3 ) };

        if ( !defined($start_with_offset) ) {
            return $ctx->error(
                MT->translate(
                    "Invalid weeks_start_with format: must be Sun|Mon|Tue|Wed|Thu|Fri|Sat"
                )
            );
        }
    }
    if ( $prefix = lc( $args->{month} || '' ) ) {
        if ( $prefix eq 'this' ) {
            my $ts = $ctx->{current_timestamp};
            if ( not $ts and ( my $entry = $ctx->stash('entry') ) ) {
                $ts = $entry->authored_on();
            }
            if ( not $ts ) {
                return $ctx->error(
                    MT->translate(
                        "You used an [_1] tag without a date context set up.",
                        qq(<MTCalendar month="this">)
                    )
                );
            }
            $prefix = substr $ts, 0, 6;
        }
        elsif ( $prefix eq 'last' ) {
            my $year  = substr $today, 0, 4;
            my $month = substr $today, 4, 2;
            if ( $month - 1 == 0 ) {
                $prefix = $year - 1 . "12";
            }
            else {
                $prefix = $year . $month - 1;
            }
        }
        else {
            return $ctx->error(
                MT->translate("Invalid month format: must be YYYYMM") )
                unless length($prefix) eq 6;
        }
    }
    else {
        $prefix = $today;
    }
    my ( $cat_name, $cat );
    if ( defined $args->{category} ) {
        $cat_name = $args->{category};
        $cat
            = MT::Category->load(
            { label => $cat_name, blog_id => $blog_id } )
            or return $ctx->error(
            MT->translate( "No such category '[_1]'", $cat_name ) );
    }
    else {
        $cat_name = '';    ## For looking up cached calendars.
    }
    my $uncompiled     = $ctx->stash('uncompiled') || '';
    my $r              = MT::Request->instance;
    my $calendar_cache = $r->cache('calendar');
    unless ($calendar_cache) {
        $r->cache( 'calendar', $calendar_cache = {} );
    }
    if ( exists $calendar_cache->{ $blog_id . ":" . $prefix . $cat_name }
        && $calendar_cache->{ $blog_id . ":" . $prefix . $cat_name }{'uc'} eq
        $uncompiled )
    {
        return $calendar_cache->{ $blog_id . ":" . $prefix . $cat_name }
            {output};
    }
    $today .= sprintf "%02d", $ts[3];
    my ( $start, $end ) = start_end_month($prefix);
    my ( $y, $m ) = unpack 'A4A2', $prefix;
    my $days_in_month = days_in( $m, $y );
    my $pad_start = ( wday_from_ts( $y, $m, 1 ) + $start_with_offset ) % 7;
    my $pad_end
        = 6 - (
        ( wday_from_ts( $y, $m, $days_in_month ) + $start_with_offset ) % 7 );
    my $iter = MT::Entry->load_iter(
        {   blog_id     => $blog_id,
            authored_on => [ $start, $end ],
            status      => MT::Entry::RELEASE()
        },
        {   range_incl => { authored_on => 1 },
            'sort'     => 'authored_on',
            direction  => 'ascend',
        }
    );
    my @left;
    my $res          = '';
    my $tokens       = $ctx->stash('tokens');
    my $builder      = $ctx->stash('builder');
    my $iter_drained = 0;

    for my $day ( 1 .. $pad_start + $days_in_month + $pad_end ) {
        my $is_padding = $day < $pad_start + 1
            || $day > $pad_start + $days_in_month;
        my ( $this_day, @entries ) = ('');
        local (
            $ctx->{__stash}{entries},  $ctx->{__stash}{calendar_day},
            $ctx->{current_timestamp}, $ctx->{current_timestamp_end}
        );
        local $ctx->{__stash}{calendar_cell} = $day;
        unless ($is_padding) {
            $this_day = $prefix . sprintf( "%02d", $day - $pad_start );
            my $no_loop = 0;
            if (@left) {
                if ( substr( $left[0]->authored_on, 0, 8 ) eq $this_day ) {
                    @entries = @left;
                    @left    = ();
                }
                else {
                    $no_loop = 1;
                }
            }
            unless ( $no_loop || $iter_drained ) {
                while ( my $entry = $iter->() ) {
                    next unless !$cat || $entry->is_in_category($cat);
                    my $e_day = substr $entry->authored_on, 0, 8;
                    push( @left, $entry ), last
                        unless $e_day eq $this_day;
                    push @entries, $entry;
                }
                $iter_drained++ unless @left;
            }
            $ctx->{__stash}{entries}      = \@entries;
            $ctx->{current_timestamp}     = $this_day . '000000';
            $ctx->{current_timestamp_end} = $this_day . '235959';
            $ctx->{__stash}{calendar_day} = $day - $pad_start;
        }
        defined(
            my $out = $builder->build(
                $ctx, $tokens,
                {   %$cond,
                    CalendarWeekHeader  => ( $day - 1 ) % 7 == 0,
                    CalendarWeekFooter  => $day % 7 == 0,
                    CalendarIfEntries   => !$is_padding && scalar @entries,
                    CalendarIfNoEntries => !$is_padding
                        && !( scalar @entries ),
                    CalendarIfToday => ( $today eq $this_day ),
                    CalendarIfBlank => $is_padding,
                }
            )
        ) or return $ctx->error( $builder->errstr );
        $res .= $out;
    }
    $calendar_cache->{ $blog_id . ":" . $prefix . $cat_name }
        = { output => $res, 'uc' => $uncompiled };
    return $res;
}

###########################################################################

=head2 CalendarIfBlank

A conditional tag that will display its contents if the current calendar
cell is for a day in another month.

B<Example:>

    <mt:CalendarIfBlank>&nbsp;</mt:CalendarIfBlank>

=for tags calendar

=cut

###########################################################################

=head2 CalendarIfEntries

A conditional tag that will display its contents if there are any
entries for this day in the blog.

B<Example:>

    <mt:CalendarIfEntries>
        <mt:Entries limit="1">
        <a href="<$mt:ArchiveLink type="Daily"$>">
            <$mt:CalendarDay$>
        </a>
        </mt:Entries>
    </mt:CalendarIfEntries>

=for tags calendar, entries

=cut

###########################################################################

=head2 CalendarIfNoEntries

A conditional tag that will display its contents if there are not entries
for this day in the blog. This tag predates the introduction of L<Else>,
a tag that could be used with L<CalendarIfEntries> to replace
C<CalendarIfNoEntries>.

=for tags calendar, entries

=cut

###########################################################################

=head2 CalendarIfToday

A conditional tag that will display its contents if the current cell
is for the current day.

=for tags calendar

=cut

###########################################################################

=head2 CalendarWeekHeader

A conditional tag that will display its contents before a calendar
week is started.

B<Example:>

    <mt:CalendarWeekHeader><tr></mt:CalendarWeekHeader>

=for tags calendar

=cut

###########################################################################

=head2 CalendarWeekFooter

A conditional tag that will display its contents before a calendar
week is ended.

B<Example:>

    <mt:CalendarWeekFooter></tr></mt:CalendarWeekFooter>

=for tags calendar

=cut

###########################################################################

=head2 CalendarDay

The numeric day of the month for the cell of the calendar being published.
This tag may only be used inside a L<Calendar> tag.

B<Example:>

    <$mt:CalendarDay$>

=for tags calendar

=cut

sub _hdlr_calendar_day {
    my ($ctx) = @_;
    my $day = $ctx->stash('calendar_day')
        or return $ctx->error(
        MT->translate(
            "You used an [_1] tag outside of the proper context.",
            '<$MTCalendarDay$>'
        )
        );
    return $day;
}

###########################################################################

=head2 CalendarCellNumber

The number of the "cell" in the calendar, beginning with 1. The count
begins with the first cell regardless of whether a day of the month
falls on it. This tag may only be used inside a L<Calendar> tag.

B<Example:>

    <$mt:CalendarCellNumber$>

=for tags calendar

=cut

sub _hdlr_calendar_cell_num {
    my ($ctx) = @_;
    my $num = $ctx->stash('calendar_cell')
        or return $ctx->error(
        MT->translate(
            "You used an [_1] tag outside of the proper context.",
            '<$MTCalendarCellNumber$>'
        )
        );
    return $num;
}

###########################################################################

=head2 CalendarDate

The timestamp of the current day of the month. Date format tags may be
applied with the format attribute along with the language attribute.

B<Example:>

    <$mt:CalendarDate$>

=for tags calendar, date

=cut

1;
