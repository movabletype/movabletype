package MT::ContentFieldType::ContentType;
use strict;
use warnings;

use MT::ContentData;
use MT::ContentField;
use MT::ContentFieldType::Common qw( get_cd_ids_by_left_join );

sub field_html {
    my ( $app, $field_id, $value ) = @_;
    if ( !defined $value ) {
        $value = [];
    }
    elsif ( ref $value ne 'ARRAY' ) {
        $value = [$value];
    }

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

1;

