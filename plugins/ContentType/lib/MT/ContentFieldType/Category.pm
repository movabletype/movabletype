package MT::ContentFieldType::Category;
use strict;
use warnings;

use MT::Category;
use MT::CategoryList;
use MT::ContentField;
use MT::ContentFieldType::Common
    qw( get_cd_ids_by_inner_join get_cd_ids_by_left_join );

sub field_html {
    my ( $app, $field_id, $value ) = @_;
    $value = ''       unless defined $value;
    $value = [$value] unless ref $value eq 'ARRAY';

    my @cats;
    if ( my $field = MT::ContentField->load($field_id) ) {
        if ( my $cat_list
            = MT::CategoryList->load( $field->related_cat_list_id || 0 ) )
        {
            @cats = @{ $cat_list->categories };
        }
    }

    my $html = '';
    my $num  = 1;

    foreach my $cat (@cats) {
        my $cat_id    = $cat->id;
        my $cat_label = $cat->label;
        my $edit_link = _edit_link( $app, $cat );

        $html .= '<div>';
        $html
            .= "<input type=\"checkbox\" name=\"content-field-$field_id\" id=\"content-field-$field_id-$num\" value=\"$cat_id\"";
        $html .=
            ( grep { $_ eq $cat_id } @$value )
            ? ' checked="checked"'
            : '';
        $html .= " mt:watch-change=\"1\" mt:raw-name=\"1\" />";
        $html
            .= " <label for=\"content-field-$field_id-$num\">$cat_label</label>";
        $html .= qq{ (<a href="${edit_link}">edit</a>)};
        $html .= '</div>';

        $num++;
    }

    my $content_field = MT::ContentField->load($field_id);
    my $options       = $content_field->options;

    my $max = $options->{max} || 0;
    my $min = $options->{min} || 0;
    my $multiple = $options->{multiple} ? 'true' : 'false';
    my $required = $options->{required} ? 'true' : 'false';

    my $required_error
        = $app->translate('Please select one of these options.');
    my $not_multiple_error
        = $app->translate('Only 1 category can be selected.');
    my $max_error = $app->translate(
        'Options less than or equal to [_1] must be selected.', $max );
    my $min_error = $app->translate(
        'Options greater than or equal to [_1] must be selected.', $min );

    $html .= <<"__JS__";
<script>
(function () {
  var required = ${required};
  var multiple = ${multiple};
  var max      = ${max};
  var min      = ${min};

  var \$cats = jQuery('input[name=content-field-${field_id}]');

  function validateCategories () {
    var checkedLength = \$cats.filter(':checked').length;
    if (required && checkedLength === 0) {
      \$cats.get(\$cats.length - 1).setCustomValidity('${required_error}');
    } else if (!multiple && checkedLength >= 2) {
      \$cats.get(\$cats.length - 1).setCustomValidity('${not_multiple_error}');
    } else if (multiple && max && checkedLength > max) {
      \$cats.get(\$cats.length - 1).setCustomValidity('${max_error}');
    } else if (multiple && min && checkedLength < min) {
      \$cats.get(\$cats.length - 1).setCustomValidity('${min_error}');
    } else {
      \$cats.get(\$cats.length - 1).setCustomValidity('');
    }
  }

  \$cats.on('change', validateCategories);

  validateCategories();
})();
</script>
__JS__

    return $html;
}

sub data_getter {
    my ( $app, $field_id ) = @_;
    my @cat_ids = $app->param( 'content-field-' . $field_id );

    my %valid_cats
        = map { $_->id => 1 } MT::Category->load( { id => \@cat_ids },
        { fetchonly => { id => 1 } } );

    [ grep { $valid_cats{$_} } @cat_ids ];
}

sub html {
    my $prop = shift;
    my ( $content_data, $app, $opts ) = @_;

    my $cat_ids = $content_data->data->{ $prop->content_field_id } || [];

    my %cats = map { $_->id => $_ } MT::Category->load( { id => $cat_ids } );
    my @cats = map { $cats{$_} } @$cat_ids;

    my @links;
    for my $cat (@cats) {
        my $label = $cat->label;
        my $edit_link = _edit_link( $app, $cat );
        push @links, qq{<a href="${edit_link}">${label}</a>};
    }

    join ', ', @links;
}

sub _edit_link {
    my ( $app, $cat ) = @_;
    $app->uri(
        mode => 'edit',
        args => {
            _type   => 'category',
            blog_id => $cat->blog_id,
            id      => $cat->id,
        },
    );
}

# similar to tag terms.
sub terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $label_terms = $prop->super(@_);

    my $option = $args->{option} || '';
    if ( $option eq 'not_contains' ) {
        my $string = $args->{string};
        my $field  = MT::ContentField->load( $prop->content_field_id );

        my @cat_ids = map { $_->id } MT::Category->load(
            {   label => { like => "%${string}%" },
                category_list_id => $field->related_cat_list_id,
            },
            { fetchonly => { id => 1 } },
        );

        my $join_terms = { value_integer => [ \'IS NULL', @cat_ids ] };
        my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
        $cd_ids ? { id => { not => $cd_ids } } : ();
    }
    elsif ( $option eq 'blank' ) {
        my $join_terms = { value_integer => \'IS NULL' };
        my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
        { id => $cd_ids };
    }
    else {
        my $cat_join
            = MT::Category->join_on( undef,
            [ { id => \'= cf_idx_value_integer' }, $label_terms ] );
        my $join_args = { join => $cat_join };
        my $cd_ids = get_cd_ids_by_inner_join( $prop, undef, $join_args, @_ );
        { id => $cd_ids };
    }
}

1;

