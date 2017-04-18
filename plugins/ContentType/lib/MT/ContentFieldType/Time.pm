package MT::ContentFieldType::Time;
use strict;
use warnings;

use MT::Util ();

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

1;

