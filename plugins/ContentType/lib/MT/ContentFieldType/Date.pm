package MT::ContentFieldType::Date;
use strict;
use warnings;

use MT;
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
        || '%Y-%m-%d';

    my $blog = $opts->{blog};
    return MT::Util::format_ts( $date_format, $ts, $blog,
          $app->user
        ? $app->user->preferred_language
        : undef );
}

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $value = $field_data->{value} || '';

    my $date = '';
    if ( defined $value && $value ne '' ) {

        # for initial_value.
        if ( $value =~ /\-/ ) {
            $value =~ tr/-//d;
            $value .= '000000';
        }

        $date = MT::Util::format_ts( "%Y-%m-%d", $value, $app->blog,
            $app->user ? $app->user->preferred_language : undef );
    }

    my $required = $field_data->{options}{required} ? 'required' : '';

    {   date     => $date,
        required => $required,
    };
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
    my ( $app, $field_data ) = @_;
    my $id   = $field_data->{id};
    my $date = $app->param( 'date-' . $id );
    $date =~ s/\D//g;
    my $ts;
    if ( defined $date && $date ne '' ) {
        $ts = $date . '000000';
    }
    unless ( !defined $ts || $ts eq '' || MT::Util::is_valid_date($ts) ) {
        return $app->translate( "Invalid date: '[_1]'", $date );
    }
    undef;
}

1;

