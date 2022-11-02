# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentFieldType::Time;
use strict;
use warnings;

use MT;
use MT::ContentFieldType::Common qw( get_cd_ids_by_left_join );
use MT::Util ();

sub html {
    MT::ContentFieldType::Common::html_datetime_common( @_, '%H:%M:%S' );
}

sub field_html_params {
    my ( $app, $field_data ) = @_;

    my ( $time, $hour, $minute, $second );
    if ( $app->param('reedit') ) {
        my $cf_id = $field_data->{content_field_id};
        $time   = $app->param("time-$cf_id");
        $hour   = $app->param("time-$cf_id-hour");
        $minute = $app->param("time-$cf_id-minute");
        $second = $app->param("time-$cf_id-second");
    }
    else {
        my $value = $field_data->{value} || '';

        $time = '';
        if ( defined $value && $value ne '' ) {

            # for initial_value.
            if ( $value =~ /:/ ) {
                $value =~ tr/://d;
                $value = '19700101' . $value;
            }

            $time = MT::Util::format_ts( "%H:%M:%S", $value, $app->blog,
                $app->user ? $app->user->preferred_language : undef );
        }

        ( $hour, $minute, $second ) = split ':', $time;
    }

    my $required = $field_data->{options}{required} ? 'required' : '';

    {   time     => $time,
        hour     => $hour,
        minute   => $minute,
        second   => $second,
        required => $required,
    };
}

sub data_load_handler {
    my ( $app, $field_data ) = @_;
    my $id   = $field_data->{id};
    my $time = '';
    if ( $app->param('mobile_view') ) {
        my $hour   = $app->param("time-$id-hour");
        my $minute = $app->param("time-$id-minute");
        my $second = $app->param("time-$id-second");
        if ( $hour || $minute || $second ) {
            $time = join '-', $hour, $minute, $second;
        }
    }
    else {
        $time = $app->param( 'time-' . $id );
    }
    $time =~ s/\D//g;
    if ( defined $time && $time ne '' ) {
        return '19700101' . $time;
    }
    else {
        return undef;
    }
}

sub filter_tmpl {
    my $prop = shift;

    my $tmpl     = 'filter_form_time';
    my $label    = '<mt:var name="label">';
    my $opts     = '<mt:var name="blank_time_filter_options">';
    my $contents = '<mt:var name="time_filter_contents">';

    return MT->translate( '<mt:var name="[_1]"> [_2] [_3] [_4]',
        $tmpl, $label, $opts, $contents );
}

sub terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $data_type = $prop->{data_type};
    my $query = _generate_query( $prop, @_ );

    my $cd_ids
        = get_cd_ids_by_left_join( $prop, { "value_${data_type}" => $query },
        undef, @_ );
    { id => $cd_ids };
}

sub _generate_query {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $option   = $args->{option};
    my $boundary = $args->{boundary};
    my $blog     = MT->app ? MT->app->blog : undef;
    my $now      = substr MT::Util::epoch2ts( $blog, time ), 8;
    $now = "19700101${now}";
    my $from   = $args->{from}   || '';
    my $to     = $args->{to}     || '';
    my $origin = $args->{origin} || '';
    $from =~ s/\D//g;
    $to =~ s/\D//g;
    $origin =~ s/\D//g;
    $from   = '19700101' . $from   if $from;
    $to     = '19700101' . $to     if $to;
    $origin = '19700101' . $origin if $origin;

    my $query;
    if ( 'range' eq $option ) {
        $query = [
            '-and',
            { op => '>=', value => $from },
            { op => '<=', value => $to },
        ];
    }
    elsif ( 'hours' eq $option ) {
        my $hours = $args->{hours};
        my $origin_time
            = substr MT::Util::epoch2ts( $blog, time - $hours * 60 * 60 ), 8;
        $query = [
            '-and',
            { op => '>', value => "19700101${origin_time}" },
            { op => '<', value => $now },
        ];
    }
    elsif ( 'before' eq $option ) {
        my $op = $boundary ? '<=' : '<';
        $query = {
            op    => $op,
            value => $origin,
        };
    }
    elsif ( 'after' eq $option ) {
        my $op = $boundary ? '>=' : '>';
        $query = {
            op    => $op,
            value => $origin,
        };
    }
    elsif ( 'future' eq $option ) {
        $query = {
            op    => '>',
            value => $now
        };
    }
    elsif ( 'past' eq $option ) {
        $query = {
            op    => '<',
            value => $now
        };
    }
    elsif ( 'blank' eq $option ) {
        $query = \'IS NULL';
    }
    elsif ( 'not_blank' eq $option ) {
        $query = \'IS NOT NULL';
    }

    $query;
}

sub options_validation_handler {
    my ( $app, $type, $label, $field_label, $options ) = @_;

    my $date = '1970-01-01';
    my $time = $options->{initial_value} || '00:00:00';
    my $ts   = "$date $time";
    return $app->translate(
        "Invalid time \'[_1]\'; An initial time value be in the format HH:MM:SS.",
        $time
    ) if !MT::Util::is_valid_date($ts);

    return;
}

sub options_pre_save_handler {
    my ( $app, $type, $options ) = @_;

    if ( defined $options->{initial_time} and $options->{initial_time} ne '' )
    {
        my $time = delete $options->{initial_time};
        $options->{initial_value} = "1970-01-01 $time";
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
        $options->{initial_time} = $time;
    }
}

sub feed_value_handler {
    my ( $app, $field_data, $value ) = @_;
    return MT::Util::format_ts( '%H:%M:%S', $value, $app->blog );
}

sub preview_handler {
    my ( $field_data, $value, $content_data ) = @_;
    MT::Util::format_ts( '%H:%M:%S', $value, MT->app->blog );
}

1;

