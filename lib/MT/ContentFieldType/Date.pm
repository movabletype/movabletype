# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentFieldType::Date;
use strict;
use warnings;

use MT::ContentFieldType::Common;
use MT::Util ();

sub html {
    MT::ContentFieldType::Common::html_datetime_common( @_, '%Y-%m-%d' );
}

sub field_html_params {
    my ( $app, $field_data ) = @_;

    my ( $date, $year, $month, $day );
    if ( $app->param('reedit') ) {
        my $cf_id = $field_data->{content_field_id};
        $date  = $app->param("date-$cf_id");
        $year  = $app->param("date-$cf_id-year");
        $month = $app->param("date-$cf_id-month");
        $day   = $app->param("date-$cf_id-day");
    }
    else {
        my $value = $field_data->{value} || '';

        $date = '';
        if ( defined $value && $value ne '' ) {

            # for initial_value.
            if ( $value =~ /\-/ ) {
                $value =~ tr/-//d;
                $value .= '000000';
            }

            $date = MT::Util::format_ts( "%Y-%m-%d", $value, $app->blog,
                $app->user ? $app->user->preferred_language : undef );
        }

        ( $year, $month, $day ) = split '-', $date;
    }

    my $required = $field_data->{options}{required} ? 'required' : '';

    {   date     => $date,
        year     => $year,
        month    => $month,
        day      => $day,
        required => $required,
    };
}

sub data_load_handler {
    my ( $app, $field_data ) = @_;
    my $id   = $field_data->{id};
    my $date = '';
    if ( $app->param('mobile_view') ) {
        my $year  = $app->param("date-$id-year");
        my $month = $app->param("date-$id-month");
        my $day   = $app->param("date-$id-day");
        if ( $year || $month || $day ) {
            $date = join '-', $year, $month, $day;
        }
    }
    else {
        $date = $app->param( 'date-' . $id );
    }
    $date =~ s/\D//g;
    if ( defined $date && $date ne '' ) {
        return $date . '000000';
    }
    else {
        return undef;
    }
}

sub options_validation_handler {
    my ( $app, $type, $label, $field_label, $options ) = @_;

    my $date = $options->{initial_value} || '1970-01-01';
    my $time = '00:00:00';
    my $ts   = "$date $time";
    return $app->translate(
        "Invalid date \'[_1]\'; An initial date value must be in the format YYYY-MM-DD.",
        $date
    ) if !MT::Util::is_valid_date($ts);

    return;
}

sub options_pre_save_handler {
    my ( $app, $type, $options ) = @_;

    if ( defined $options->{initial_date} and $options->{initial_date} ne '' )
    {
        my $date = delete $options->{initial_date};
        $options->{initial_value} = "$date 00:00:00";
    }
    else {
        $options->{initial_value} = undef;
    }

    return;
}

sub options_pre_load_handler {
    my ( $app, $type, $obj, $options ) = @_;

    if ( $options->{initial_value} ) {
        my ( $date, $time ) = split ' ', $options->{initial_value};
        $options->{initial_date} = $date;
    }
}

sub feed_value_handler {
    my ( $app, $field_data, $value ) = @_;
    return MT::Util::format_ts( '%Y-%m-%d', $value, $app->blog );
}

sub preview_handler {
    my ( $field_data, $value, $content_data ) = @_;
    MT::Util::format_ts( '%Y-%m-%d', $value, MT->app->blog );
}

1;

