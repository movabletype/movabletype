package MT::ContentFieldType::ContentType;
use strict;
use warnings;

use MT::ContentData;
use MT::ContentField;
use MT::ContentFieldType::Common qw( get_cd_ids_by_left_join );

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $value = $field_data->{value} || [];
    $value = [$value] unless ref $value eq 'ARRAY';

    my %tmp_cd;
    my $iter = MT::ContentData->load_iter( { id => $value } );
    while ( my $cd = $iter->() ) {
        $tmp_cd{ $cd->id } = $cd;
    }
    my @content_data = grep {$_} map { $tmp_cd{$_} } @{$value};
    my @content_data_loop = map {
        {   cd_id      => $_->id,
            cd_blog_id => $_->id,
            cd_title   => $_->title,
        }
    } @content_data;

    my $content_field_id = $field_data->{content_field_id} || 0;
    my $content_field = MT::ContentField->load($content_field_id);
    my $related_content_type
        = $content_field ? $content_field->related_content_type : undef;
    my $content_type_name
        = $related_content_type ? $related_content_type->name : undef;

    my $options = $field_data->{options} || {};

    my $multiple = '';
    if ( $options->{multiple} ) {
        $multiple = $options->{multiple} ? 'data-mt-multiple="1"' : '';
        my $max = $options->{max};
        my $min = $options->{min};
        $multiple .= qq{ data-mt-max-select="${max}"} if $max;
        $multiple .= qq{ data-mt-min-select="${min}"} if $min;
    }

    my $required = $options->{required} ? 'data-mt-required="1"' : '';

    {   content_data_loop => \@content_data_loop,
        content_type_name => $content_type_name,
        multiple          => $multiple,
        required          => $required,
    };
}

sub field_html {
    my ( $app, $field_data ) = @_;
    my $value = $field_data->{value};
    if ( !defined $value ) {
        $value = [];
    }
    elsif ( ref $value ne 'ARRAY' ) {
        $value = [$value];
    }

    my $field_id      = $field_data->{content_field_id};
    my $content_field = MT::ContentField->load($field_id);
    my $ct_id         = $content_field->related_content_type_id;
    my @ct_datas = MT::ContentData->load( { content_type_id => $ct_id } );
    my $html     = '';
    my $num      = 1;

    foreach my $ct_data (@ct_datas) {
        my $ct_data_id = $ct_data->id;
        my $label      = $ct_data->label;
        my $edit_link  = $ct_data->edit_link($app);

        $html .= '<div>';
        $html
            .= "<input type=\"checkbox\" name=\"content-field-$field_id\" id=\"content-field-$field_id-$num\" value=\"$ct_data_id\"";
        $html .=
            ( grep { $_ eq $ct_data_id } @$value )
            ? ' checked="checked"'
            : '';
        $html .= " mt:watch-change=\"1\" mt:raw-name=\"1\" />";
        $html
            .= " <label for=\"content-field-$field_id-$num\">$label</label>";
        $html .= qq{ (<a href="${edit_link}">edit</a>)};
        $html .= '</div>';
        $num++;
    }

    if ( $content_field->options->{required} ) {
        my $error_message
            = $app->translate('Please select one of these options.');
        $html .= <<"__JS__";
<script>
var \$contentTypes = jQuery('input[name=content-field-${field_id}]');

function validateContentTypes () {
  if (\$contentTypes.filter(':checked').length === 0) {
    \$contentTypes.get(\$contentTypes.length - 1).setCustomValidity('${error_message}');
  } else {
    \$contentTypes.get(\$contentTypes.length - 1).setCustomValidity('');
  }
}

\$contentTypes.on('change', validateContentTypes);

validateContentTypes();
</script>
__JS__
    }

    return $html;
}

sub data_getter {
    my ( $app, $field_id ) = @_;
    my @data = $app->param( 'content-field-' . $field_id );
    \@data;
}

sub html {
    my $prop = shift;
    my ( $content_data, $app, $opts ) = @_;

    my $child_cd_ids = $content_data->data->{ $prop->content_field_id } || [];

    my %child_cd = map { $_->id => $_ }
        MT::ContentData->load( { id => $child_cd_ids } );
    my @child_cd = map { $child_cd{$_} } @$child_cd_ids;

    my @cd_links;
    for my $cd (@child_cd) {
        my $label     = $cd->label;
        my $edit_link = $cd->edit_link($app);
        push @cd_links, qq{<a href="${edit_link}">${label}</a>};
    }

    join ', ', @cd_links;
}

sub terms_id {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $option = $args->{option} || '';
    if ( $option eq 'not_equal' ) {
        my $col        = $prop->col;
        my $value      = $args->{value} || 0;
        my $join_terms = { $col => [ \'IS NULL', $value ] };
        my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
        $cd_ids ? { id => { not => $cd_ids } } : ();
    }
    else {
        my $join_terms = $prop->super(@_);
        my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
        { id => $cd_ids };
    }
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
    my $required    = $options->{required};

    my $content_type_name = 'Content Data';
    my $content_field_id = $field_data->{content_field_id} || 0;
    if ( my $content_field = MT::ContentField->load($content_field_id) ) {
        if ( $content_field->related_content_type ) {
            $content_type_name = $content_field->related_content_type->name;
        }
    }

    if ( $multiple && $max && @values > $max ) {
        return $app->tranlsate(
            '[_1] less than or equal to [_2] must be selected in "[_3]" field.',
            $content_type_name, $max, $field_label );
    }
    if ( $multiple && $min && @values < $min ) {
        return $app->translate(
            '[_1] greater than or equal to [_2] must be selected in "[_3]" field.',
            $content_type_name, $min, $field_label );
    }
    if ( !$multiple && @values > 1 ) {
        return $app->translate(
            'Only 1 [_1] can be selected in "[_2]" field.',
            $content_type_name, $field_label );
    }
    if ( $required && !@values ) {
        return $app->translate( '"[_1]" field is required.', $field_label );
    }

    undef;
}

1;

