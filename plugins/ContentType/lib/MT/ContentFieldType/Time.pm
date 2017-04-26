package MT::ContentFieldType::Time;
use strict;
use warnings;

use MT;
use MT::ContentData;
use MT::ContentField;
use MT::ContentFieldIndex;
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
        $time = MT::Util::format_ts( "%H:%M:%S", $value, $app->blog,
            $app->user ? $app->user->preferred_language : undef );
    }
    my $html = '';
    $html .= '<span>';
    $html .= '<span>';
    $html
        .= "<input type=\"text\" name=\"time-$id\" id=\"time-$id\" class=\"text time\" value=\"$time\" placeholder=\"HH:MM:SS\" />";
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

    my $tmpl     = 'filter_form_future_time';
    my $label    = '<mt:var name="label">';
    my $opts     = '<mt:var name="future_blank_time_filter_options">';
    my $contents = '<mt:var name="future_time_filter_contents">';

    return MT->translate( '<mt:var name="[_1]"> [_2] [_3] [_4]',
        $tmpl, $label, $opts, $contents );
}

sub terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $option    = $args->{option};
    my $data_type = $prop->{data_type};

    my $query = generate_query( $prop, @_ );

    my $join = MT::ContentFieldIndex->join_on(
        undef,
        { "value_${data_type}" => $query },
        {   type      => 'left',
            condition => {
                content_data_id  => \'= cd_id',
                content_field_id => $prop->content_field_id,
            },
        },
    );

    my @cd_ids
        = map { $_->id }
        MT::ContentData->load( $db_terms,
        { join => $join, fetchonly => { id => 1 } } );

    { id => @cd_ids ? \@cd_ids : 0 };
}

sub generate_query {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $option   = $args->{option};
    my $boundary = $args->{boundary};
    my $now      = MT::Util::epoch2ts( undef, time );
    my $from     = $args->{from} || '';
    my $to       = $args->{to} || '';
    my $origin   = $args->{origin} || '';
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
            = substr MT::Util::epoch2ts( undef, time - $hours * 60 * 60 ), 8;
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

