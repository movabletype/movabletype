package MT::ContentFieldType::Checkbox;
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
        {   k => $_->{key},
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

sub ss_validator {
    my ( $app, $field_data ) = @_;
    my $field_id = $field_data->{id};
    my @values   = $app->param("content-field-${field_id}");

    my $options = $field_data->{options} || {};

    my $field_label = $options->{label};
    my $multiple    = $options->{multiple};
    my $max         = $options->{max};
    my $min         = $options->{min};

    if ($multiple) {
        if ( $max && @values > $max ) {
            return $app->translate(
                'Options less than or equal to [_1] must be selected in "[_2]" field.',
                $max, $field_label
            );
        }
        elsif ( $min && @values < $min ) {
            return $app->translate(
                'Options greater than or equal to [_1] must be selected in "[_2]" field.',
                $min, $field_label
            );
        }
    }
    else {
        if ( @values >= 2 ) {
            return $app->translate(
                'Only 1 checkbox can be selected in "[_1]" field.',
                $field_label );
        }
    }

    undef;
}

1;

