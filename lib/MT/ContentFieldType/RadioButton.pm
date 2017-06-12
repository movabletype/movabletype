package MT::ContentFieldType::RadioButton;
use strict;
use warnings;

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $value = $field_data->{value};
    $value = '' unless defined $value;

    my $options_values = $field_data->{options}{values} || [];
    @{$options_values} = map {
        {   l => $_->{label},
            v => $_->{value},
            ( $_->{value} eq $value )
            ? ( checked => 'checked="checked"' )
            : (),
        }
    } @{$options_values};

    my $required = $field_data->{options}{required} ? 'required' : '';

    {   options_values => $options_values,
        required       => $required,
    };
}

1;

