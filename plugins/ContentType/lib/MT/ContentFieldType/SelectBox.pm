package MT::ContentFieldType::SelectBox;
use strict;
use warnings;

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $value = $field_data->{value};
    $value = '' unless defined $value;

    my %values;
    if ( ref $value eq 'ARRAY' ) {
        %values = map { $_ => 1 } @$value;
    }
    else {
        $values{$value} = 1;
    }

    my $options = $field_data->{options};
    my $options_values = $options->{values} || [];
    @{$options_values} = map {
        {   k => $_->{key},
            v => $_->{value},
            $values{ $_->{value} }
            ? ( selected => 'selected="selected"' )
            : (),
        }
    } @{$options_values};

    my $required = $options->{required} ? 'required' : '';

    my $multiple       = '';
    my $multiple_class = '';
    if ( $options->{multiple} ) {
        my $max = $options->{max};
        my $min = $options->{min};
        $multiple = 'multiple style="min-width: 10em; min-height: 10em"';
        $multiple .= qq{ data-mt-max-select="${max}"} if $max;
        $multiple .= qq{ data-mt-min-select="${min}"} if $min;
        $multiple_class = 'multiple-select';
    }

    {   multiple       => $multiple,
        multiple_class => $multiple_class,
        options_values => $options_values,
        required       => $required,
    };
}

1;

