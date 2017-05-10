package MT::ContentFieldType::Time;
use strict;
use warnings;

use MT;
use MT::ContentField;
use MT::ContentFieldType::Common qw( get_cd_ids_by_left_join );
use MT::Util ();

sub html {
    my $prop = shift;
    my ( $obj, $app, $opts ) = @_;
    my $ts = $obj->data->{ $prop->{content_field_id} } or return '';

    # TODO: implement date_format option to content field.
    my $content_field = MT::ContentField->load( $prop->{content_field_id} )
        or return '';
    my $date_format = eval { $content_field->options->{date_format} }
        || '%I:%M:%S%p';

    my $blog = $opts->{blog};
    return MT::Util::format_ts( $date_format, $ts, $blog,
          $app->user
        ? $app->user->preferred_language
        : undef );
}

sub field_html {
    my ( $app, $id, $value ) = @_;
    my $time = '';
    if ( defined $value && $value ne '' ) {

        # for initial_value.
        if ( $value =~ /:/ ) {
            $value =~ tr/://d;
            $value = '19700101' . $value;
        }

        $time = MT::Util::format_ts( "%H:%M:%S", $value, $app->blog,
            $app->user ? $app->user->preferred_language : undef );
    }
    my $html = '';
    $html .= '<span>';
    $html .= '<span>';
    $html
        .= "<input type=\"text\" name=\"time-$id\" id=\"time-$id\" class=\"text time\" value=\"$time\" placeholder=\"HH:mm:ss\" mt:watch-change=\"1\" mt:raw-name=\"1\" />";
    $html .= '</span> ';
    return $html;
}

sub data_getter {
    my ( $app, $id ) = @_;
    my $q    = $app->param;
    my $time = $q->param( 'time-' . $id );
    $time =~ s/\D//g;
    if ( defined $time && $time ne '' ) {
        return '19700101' . $time;
    }
    else {
        return undef;
    }
}

sub ss_validator {
    my ( $app, $id ) = @_;
    my $q    = $app->param;
    my $time = $q->param( 'time-' . $id );
    my $ts;
    if ( defined $time && $time ne '' ) {
        $ts = '19700101 ' . $time;
    }
    if ( !defined $ts || $ts eq '' || MT::Util::is_valid_date($ts) ) {
        return $ts;
    }
    else {
        my $err = MT->translate( "Invalid time: '[_1]'", $time );
        return $app->error($err) if $err && $app;
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

    $query;
}

1;

