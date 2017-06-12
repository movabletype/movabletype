package MT::ContentFieldType::SingleLineText;
use strict;
use warnings;

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $required = $field_data->{options}{required} ? 'required' : '';
    my $max_length = $field_data->{options}{max_length};
    if ( my $ml = $field_data->{options}{max_length} ) {
        $max_length = qq{maxlength="${ml}"};
    }
    my $min_length_class = '';
    my $min_length_data  = '';
    if ( my $ml = $field_data->{options}{min_length} ) {
        $min_length_class = 'min-length';
        $min_length_data  = qq{data-mt-min-length="${ml}"};
    }

    {   required         => $required,
        max_length       => $max_length,
        min_length_class => $min_length_class,
        min_length_data  => $min_length_data,
    };
}

sub ss_validator {
    my ( $app, $field_data, $data ) = @_;
    $data = '' unless defined $data && $data ne '';

    my $options     = $field_data->{options} || {};
    my $max_length  = $options->{max_length};
    my $min_length  = $options->{min_length};
    my $field_label = $options->{label};

    if ( $max_length && length $data > $max_length ) {
        return $app->translate( '"[_1]" field is too long.', $field_label );
    }
    if ( $min_length && length $data < $min_length ) {
        return $app->translate( '"[_1]" field is too short.', $field_label );
    }

    undef;
}

1;

