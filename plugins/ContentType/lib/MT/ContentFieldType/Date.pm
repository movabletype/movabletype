package MT::ContentFieldType::Date;
use strict;
use warnings;

use MT::Util ();

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
    return $date;
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

