# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentFieldType::DateTime;
use strict;
use warnings;

use MT::ContentFieldType::Common;
use MT::Util ();

sub html {
    MT::ContentFieldType::Common::html_datetime_common( @_,
        '%Y-%m-%d %H:%M:%S' );
}

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $value = $field_data->{value} || '';

    # for initial_value.
    $value = '' unless defined $value;
    $value =~ s/[ \-:]//g;

    my $date = '';
    my $time = '';
    if ( defined $value && $value ne '' ) {
        $date = MT::Util::format_ts( "%Y-%m-%d", $value, $app->blog,
            $app->user ? $app->user->preferred_language : undef );
        $time = MT::Util::format_ts( "%H:%M:%S", $value, $app->blog,
            $app->user ? $app->user->preferred_language : undef );
    }

    my ( $year, $month,  $day )    = split '-', $date;
    my ( $hour, $minute, $second ) = split ':', $time;

    my $required = $field_data->{options}{required} ? 'required' : '';

    {   date     => $date,
        time     => $time,
        year     => $year,
        month    => $month,
        day      => $day,
        hour     => $hour,
        minute   => $minute,
        second   => $second,
        required => $required,
    };
}

sub data_load_handler {
    my ( $app, $field_data ) = @_;
    my $id   = $field_data->{id};
    my $date = '';
    my $time = '';
    if ( $app->param('mobile_view') ) {
        my $year  = $app->param("date-$id-year");
        my $month = $app->param("date-$id-month");
        my $day   = $app->param("date-$id-day");
        if ( $year || $month || $day ) {
            $date = join '-', $year, $month, $day;
        }

        my $hour   = $app->param("time-$id-hour");
        my $minute = $app->param("time-$id-minute");
        my $second = $app->param("time-$id-second");
        if ( $hour || $minute || $second ) {
            $time = join ':', $hour, $minute, $second;
        }
    }
    else {
        $date = $app->param( 'date-' . $id );
        $time = $app->param( 'time-' . $id );
    }
    my $ts = $date . $time;
    $ts =~ s/\D//g;
    return $ts;
}

sub options_validation_handler {
    my ( $app, $type, $label, $field_label, $options ) = @_;

    my $date = $options->{initial_date} || '1970-01-01';
    my $time = $options->{initial_time} || '00:00:00';
    my $ts   = "$date $time";

    return $app->translate(
        "Invalid date \'[_1]\'; An initial date/time value must be in the format YYYY-MM-DD HH:MM:SS.",
        $ts,
    ) if !MT::Util::is_valid_date($ts);

    return;
}

sub options_pre_save_handler {
    my ( $app, $type, $obj, $options ) = @_;

    if (   exists $options->{initial_date}
        or exists $options->{initial_time} )
    {
        my $date
            = exists $options->{initial_date}
            ? delete $options->{initial_date}
            : '1970-01-01';
        my $time
            = exists $options->{initial_time}
            ? delete $options->{initial_time}
            : '00:00:00';
        $options->{initial_value} = "$date $time";
    }
    else {
        $options->{initial_value} = undef;
    }

    return;
}

sub options_pre_load_handler {
    my ( $app, $options ) = @_;

    if ( $options->{initial_value} ) {
        my ( $date, $time ) = split ' ', $options->{initial_value};
        $options->{initial_date} = $date;
        $options->{initial_time} = $time;
    }
}

sub feed_value_handler {
    my ( $app, $field_data, $value ) = @_;
    return MT::Util::format_ts( '%Y-%m-%d %H:%M:%S', $value, $app->blog );
}

sub preview_handler {
    my ( $field_data, $value, $content_data ) = @_;
    MT::Util::format_ts( '%Y-%m-%d %H:%M:%S', $value, MT->app->blog );
}

1;

