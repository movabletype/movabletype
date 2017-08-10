package MT::ContentFieldType::DateTime;
use strict;
use warnings;

use MT::App::CMS;
use MT::ContentFieldType::Common;
use MT::Util ();

sub html {
    MT::ContentFieldType::Common::html_datetime_common( @_,
        MT::App::CMS::LISTING_TIMESTAMP_FORMAT() );
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

    my $required = $field_data->{options}{required} ? 'required' : '';

    {   date     => $date,
        time     => $time,
        required => $required,
    };
}

sub data_load_handler {
    my ( $app, $field_data ) = @_;
    my $id   = $field_data->{id};
    my $date = $app->param( 'date-' . $id );
    my $time = $app->param( 'time-' . $id );
    my $ts   = $date . $time;
    $ts =~ s/\D//g;
    return $ts;
}

1;

