package MT::ContentFieldType::DateTime;
use strict;
use warnings;

use MT;
use MT::App::CMS;
use MT::ContentField;
use MT::Util ();

sub html {
    my $prop = shift;
    my ( $obj, $app, $opts ) = @_;
    my $ts = $obj->data->{ $prop->{content_field_id} } or return '';

    # TODO: implement date_format option to content field.
    my $content_field = MT::ContentField->load( $prop->{content_field_id} )
        or return '';
    my $date_format = eval { $content_field->options->{date_format} }
        || MT::App::CMS::LISTING_TIMESTAMP_FORMAT();

    my $blog = $opts->{blog};
    return MT::Util::format_ts( $date_format, $ts, $blog,
          $app->user
        ? $app->user->preferred_language
        : undef );
}

sub generate_query {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $option   = $args->{option};
    my $boundary = $args->{boundary};
    my $query;
    my $blog = MT->app ? MT->app->blog : undef;
    my $now = MT::Util::epoch2ts( $blog, time() );
    my $from   = $args->{from}   || '';
    my $to     = $args->{to}     || '';
    my $origin = $args->{origin} || '';
    $from =~ s/\D//g;
    $to =~ s/\D//g;
    $origin =~ s/\D//g;
    $from .= '000000' if $from;
    $to   .= '235959' if $to;

    if ( 'range' eq $option ) {
        $query = [
            '-and',
            { op => '>=', value => $from },
            { op => '<=', value => $to },
        ];
    }
    elsif ( 'days' eq $option ) {
        my $days = $args->{days};
        my $origin = MT::Util::epoch2ts( $blog, time - $days * 60 * 60 * 24 );
        $query = [
            '-and',
            { op => '>', value => $origin },
            { op => '<', value => $now },
        ];
    }
    elsif ( 'before' eq $option ) {
        if ($boundary) {
            $query = {
                op    => '<=',
                value => $origin . '235959',
            };
        }
        else {
            $query = {
                op    => '<',
                value => $origin . '000000'
            };
        }
    }
    elsif ( 'after' eq $option ) {
        if ($boundary) {
            $query = {
                op    => '>=',
                value => $origin . '000000',
            };
        }
        else {
            $query = {
                op    => '>',
                value => $origin . '235959'
            };
        }
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

    $query;
}

sub terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $option    = $args->{option};
    my $data_type = $prop->{data_type};

    my $query = generate_query( $prop, @_ );

    if ( 'blank' eq $option ) {
        my @indexes = MT::ContentFieldIndex->load(
            {   content_field_id     => $prop->{content_field_id},
                "value_${data_type}" => \'IS NOT NULL'
            },
            { fetchonly => { content_data_id => 1 } },
        );
        my %content_data_ids = map { $_->content_data_id => 1 } @indexes;
        my @content_data_ids = keys %content_data_ids;
        @content_data_ids ? { id => { not => \@content_data_ids } } : undef;
    }
    else {
        $db_args->{joins} ||= [];
        push @{ $db_args->{joins} },
            MT::ContentFieldIndex->join_on(
            undef,
            {   content_data_id      => \'= cd_id',
                content_field_id     => $prop->{content_field_id},
                "value_${data_type}" => $query,
            }
            );
    }
}

sub filter_tmpl {
    my $r = MT->registry( 'list_properties', '__virtual', 'date' );
    $r->{filter_tmpl}->(@_);
}

sub field_html {
    my ( $app, $id, $value ) = @_;

    my $date = '';
    my $time = '';
    if ( defined $value && $value ne '' ) {
        $date = MT::Util::format_ts( "%Y-%m-%d", $value, $app->blog,
            $app->user ? $app->user->preferred_language : undef );
        $time = MT::Util::format_ts( "%H:%M:%S", $value, $app->blog,
            $app->user ? $app->user->preferred_language : undef );
    }

    my $html = '';
    $html .= '<span>';
    $html
        .= "<input type=\"text\" name=\"date-$id\" id=\"date-$id\" class=\"text date text-date\" value=\"$date\" placeholder=\"YYYY:MM:DD\" />";
    $html .= '</span> ';
    $html .= '<span class="separator"> <__trans phrase="@"></span> ';
    $html .= '<span>';
    $html
        .= "<input type=\"text\" name=\"time-$id\" id=\"time-$id\" class=\"text time\" value=\"$time\" placeholder=\"HH:MM:SS\" />";
    $html .= '</span> ';
    return $html;
}

sub data_getter {
    my ( $app, $id ) = @_;
    my $q    = $app->param;
    my $date = $q->param( 'date-' . $id );
    my $time = $q->param( 'time-' . $id );
    my $ts   = $date . $time;
    $ts =~ s/\D//g;
    return $ts;
}

sub ss_validator {
    my ( $app, $id ) = @_;
    my $q    = $app->param;
    my $date = $q->param( 'date-' . $id );
    my $time = $q->param( 'time-' . $id );
    my $ts   = $date . $time;
    if ( !defined $ts || $ts eq '' || MT::Util::is_valid_date($ts) ) {
        return $ts;
    }
    else {
        my $err = MT->translate( "Invalid date and time: '[_1] [_2]'",
            $date, $time );
        return $app->error($err) if $err && $app;
    }
}

1;

