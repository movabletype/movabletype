package MT::ContentFieldType::Checkboxes;
use strict;
use warnings;

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $value = $field_data->{value};
    $value = ''       unless defined $value;
    $value = [$value] unless ref $value eq 'ARRAY';

    my %values;
    if ( ref $value eq 'ARRAY' ) {
        %values = map { $_ => 1 } @{$value};
    }
    else {
        $values{$value} = 1;
    }

    my $options = $field_data->{options};
    my $options_values = $options->{values} || [];
    @{$options_values} = map {
        {   l => $_->{label},
            v => $_->{value},
            $values{ $_->{value} } ? ( checked => 'checked="checked"' ) : (),
        }
    } @{$options_values};

    my $multiple = '';
    if ( $options->{multiple} ) {
        my $max = $options->{max};
        my $min = $options->{min};
        $multiple = 'data-mt-multiple="1"';
        $multiple .= qq{ data-mt-max-select="${max}"} if $max;
        $multiple .= qq{ data-mt-min-select="${min}"} if $min;
    }

    my $required = $options->{required} ? 'data-mt-required="1"' : '';

    {   multiple       => $multiple,
        options_values => $options_values,
        required       => $required,
    };
}

1;

