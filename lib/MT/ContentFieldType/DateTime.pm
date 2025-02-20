# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
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

    my ( $date, $year, $month,  $day );
    my ( $time, $hour, $minute, $second );
    if ( $app->param('reedit') ) {
        my $cf_id = $field_data->{content_field_id};
        $date   = $app->param("date-$cf_id");
        $year   = $app->param("date-$cf_id-year");
        $month  = $app->param("date-$cf_id-month");
        $day    = $app->param("date-$cf_id-day");
        $time   = $app->param("time-$cf_id");
        $hour   = $app->param("time-$cf_id-hour");
        $minute = $app->param("time-$cf_id-minute");
        $second = $app->param("time-$cf_id-second");
    }
    else {
        my $value = $field_data->{value} || '';

        # for initial_value.
        $value = '' unless defined $value;
        $value =~ s/[ \-:]//g;

        $date = '';
        $time = '';
        if ( defined $value && $value ne '' ) {
            $date = MT::Util::format_ts( "%Y-%m-%d", $value, $app->blog,
                $app->user ? $app->user->preferred_language : undef );
            $time = MT::Util::format_ts( "%H:%M:%S", $value, $app->blog,
                $app->user ? $app->user->preferred_language : undef );
        }

        ( $year, $month,  $day )    = split '-', $date;
        ( $hour, $minute, $second ) = split ':', $time;
    }

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

    if ((   defined $options->{initial_date}
            and $options->{initial_date} ne ''
        )
        or ( defined $options->{initial_time}
            and $options->{initial_time} ne '' )
        )
    {
        my $date
            = ( defined $options->{initial_date}
                and $options->{initial_date} ne '' )
            ? delete $options->{initial_date}
            : '1970-01-01';
        my $time
            = ( defined $options->{initial_time}
                and $options->{initial_time} ne '' )
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

