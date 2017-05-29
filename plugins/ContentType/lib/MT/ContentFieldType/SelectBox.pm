package MT::ContentFieldType::SelectBox;
use strict;
use warnings;

use MT;
use MT::ContentField;
use MT::ContentFieldType::Common qw( get_cd_ids_by_inner_join );

sub terms {
    my $prop = shift;
    my ( $args, $base_terms, $base_args, $opts ) = @_;

    my $val       = $args->{value};
    my $data_type = $prop->{data_type};

    my $join_terms = { "value_${data_type}" => $val };
    my $cd_ids = get_cd_ids_by_inner_join( $prop, $join_terms, undef, @_ );

    if ( $args->{option} && $args->{option} eq 'is_not_selected' ) {
        $cd_ids ? { id => { not => $cd_ids } } : ();
    }
    else {
        { id => $cd_ids };
    }
}

sub filter_tmpl {
    return <<'__TMPL__';
<mt:setvarblock name="select_options">
<select class="<mt:var name="type">-option">
  <option value="is_selected"><__trans phrase="is selected" escape="js"></option>
  <option value="is_not_selected"><__trans phrase="is not selected" escape="js"></option>
</select>
</mt:setvarblock>
<__trans phrase="In [_1] column, [_2] [_3]"
         params="<mt:var name="label" escape="js">%%
                 <select class="<mt:var name="type">-value">
                 <mt:loop name="single_select_options">
                   <option value="<mt:var name="value">"><mt:var name="label" encode_html="1" encode_js="1" encode_html="1" ></option>
                 </mt:loop>
                 </select>%%<mt:var name="select_options">">
__TMPL__
}

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

sub single_select_options {
    my $prop = shift;
    my $app = shift || MT->app;

    my $content_field_id = $prop->{content_field_id};
    my $content_field    = MT::ContentField->load($content_field_id);
    my $values           = $content_field->options->{values} || [];

    [ map { +{ label => $_->{key}, value => $_->{value} } } @{$values} ];
}

sub data_getter {
    my ( $app, $field_data ) = @_;
    my @options = $app->param( 'content-field-' . $field_data->{id} );
    if ( $field_data->{options}{multiple} ) {
        \@options;
    }
    else {
        @options ? $options[0] : undef;
    }
}

sub html {
    my $prop = shift;
    my ( $content_data, $app, $opts ) = @_;

    my $content_field = MT::ContentField->load( $prop->content_field_id );
    my %label_hash = map { $_->{value} => $_->{key} }
        @{ $content_field->options->{values} };

    my $values = $content_data->data->{ $prop->content_field_id } || [];
    $values = [$values] unless ref $values eq 'ARRAY';
    my @labels = map { $label_hash{$_} } @{$values};

    join ', ', @labels;
}

sub ss_validator {
    my ( $app, $field_data ) = @_;
    my $field_id = $field_data->{id};

    my $options = $field_data->{options} || {};

    my $field_label = $options->{label};
    my $multiple    = $options->{multiple};
    my $max         = $options->{max};
    my $min         = $options->{min};

    if ( $multiple && ( $max || $min ) ) {
        my @options = $app->param("content-field-${field_id}");
        if ( $max && @options > $max ) {
            return $app->translate(
                'Options less than or equal to [_1] must be selected in "[_2]" field.',
                $max, $field_label,
            );
        }
        if ( $min && @options < $min ) {
            return $app->translate(
                'Options greater than or equal to [_1] must be selected in "[_2]" field.',
                $min, $field_label,
            );
        }
    }

    undef;
}

1;

