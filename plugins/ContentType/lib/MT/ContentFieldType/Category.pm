package MT::ContentFieldType::Category;
use strict;
use warnings;

use MT::Category;
use MT::ObjectCategory;

sub field_html {
    my ( $app, $field_id, $value ) = @_;
    $value = [$value] unless ref $value eq 'ARRAY';

    my @cats;
    if ( my $field = MT->model('content_field')->load($field_id) ) {
        if ( my $cat_list
            = MT->model('category_list')
            ->load( $field->related_cat_list_id || 0 ) )
        {
            @cats = @{ $cat_list->categories };
        }
    }

    my $html = '';
    my $num  = 1;

    foreach my $cat (@cats) {
        my $cat_id    = $cat->id;
        my $cat_label = $cat->label;
        $html .= '<div>';
        $html
            .= "<input type=\"checkbox\" name=\"content-field-$field_id\" id=\"content-field-$field_id-$num\" value=\"$cat_id\"";
        $html .=
            ( grep { $_ eq $cat_id } @$value )
            ? ' checked="checked"'
            : '';
        $html .= " />";
        $html
            .= " <label for=\"content-field-$field_id-$num\">$cat_label</label>";
        $html .= '</div>';

        $num++;
    }
    return $html;
}

sub data_getter {
    my ( $app, $field_id ) = @_;
    my @cat_ids = $app->param( 'content-field-' . $field_id );

    my @valid_cats = MT->model('category')
        ->load( { id => \@cat_ids }, { fetchonly => { id => 1 } } );
    my %valid_cats = map { $_->id => 1 } @valid_cats;

    [ grep { $valid_cats{$_} } @cat_ids ];
}

1;

