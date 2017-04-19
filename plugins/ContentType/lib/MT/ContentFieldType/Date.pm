package MT::ContentFieldType::Date;
use strict;
use warnings;

use MT::Util ();

sub html {
    my $prop = shift;
    my ( $obj, $app, $opts ) = @_;
    my $ts = $obj->data->{ $prop->{content_field_id} } or return '';

    # TODO: implement date_format option to content field.
    my $content_field = MT::ContentField->load( $prop->{content_field_id} )
        or return '';
    my $date_format = eval { $content_field->options->{date_format} }
        || '%Y-%m-%d';

    my $blog = $opts->{blog};
    return MT::Util::format_ts( $date_format, $ts, $blog,
          $app->user
        ? $app->user->preferred_language
        : undef );
}

sub field_html {
    my ( $app, $id, $value ) = @_;
    my $date = '';
    if ( defined $value && $value ne '' ) {
        $date = MT::Util::format_ts( "%Y-%m-%d", $value, $app->blog,
            $app->user ? $app->user->preferred_language : undef );
    }
    my $html = '';
    $html .= '<span>';
    $html
        .= "<input type=\"text\" name=\"date-$id\" id=\"date-$id\" class=\"text date text-date\" value=\"$date\" placeholder=\"YYYY:MM:DD\" />";
    $html .= '</span> ';
    return $html;
}

sub data_getter {
    my ( $app, $id ) = @_;
    my $q    = $app->param;
    my $date = $q->param( 'date-' . $id );
    $date =~ s/\D//g;
    if ( defined $date && $date ne '' ) {
        return $date . '000000';
    }
    else {
        return undef;
    }
}

sub ss_validator {
    my ( $app, $id ) = @_;
    my $q    = $app->param;
    my $date = $q->param( 'date-' . $id );
    my $ts;
    if ( defined $date && $date ne '' ) {
        $ts = $date . '000000';
    }
    if ( !defined $ts || $ts eq '' || MT::Util::is_valid_date($ts) ) {
        return $ts;
    }
    else {
        my $err = MT->translate( "Invalid date: '[_1]'", $date );
        return $app->error($err) if $err && $app;
    }
}

1;

