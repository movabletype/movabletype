package MT::ContentFieldType::Category;
use strict;
use warnings;

use MT::Category;
use MT::ObjectCategory;

sub field_html {
    my ( $app, $id, $value ) = @_;
    my @values     = split ',', $value;
    my $q          = $app->param;
    my $ct_data_id = $q->param('id');
    my @cats       = MT::Category->load( { blog_id => $app->blog->id } );
    my @obj_cats   = MT::ObjectCategory->load(
        {   object_ds => 'content_data',
            object_id => $ct_data_id
        }
    );
    my $html = '';
    my $num  = 1;

    foreach my $cat (@cats) {
        my $cat_id    = $cat->id;
        my $cat_label = $cat->label;
        $html .= '<div>';
        $html
            .= "<input type=\"checkbox\" name=\"content-field-$id\" id=\"content-field-$id-$num\" value=\"$cat_id\"";
        $html .=
            ( grep { $_->category_id eq $cat_id } @obj_cats )
            ? ' checked="checked"'
            : '';
        $html .= " />";
        $html .= " <label for=\"content-field-$id-$num\">$cat_label</label>";
        $html .= '</div>';
    }
    return $html;
}

sub data_getter {
    my ( $app, $id ) = @_;
    my $q          = $app->param;
    my $ct_data_id = $q->param('id');
    my @cat_ids    = $q->param( 'content-field-' . $id );
    my @obj_cats   = MT::ObjectCategory->load(
        {   object_ds => 'content_data',
            object_id => $ct_data_id
        }
    );
    foreach my $obj_cat (@obj_cats) {
        $obj_cat->remove
            unless ( grep { $_ eq $obj_cat->category_id } @cat_ids );
    }
    foreach my $cat_id (@cat_ids) {
        my $obj_cat = MT::ObjectCategory->load(
            {   category_id => $cat_id,
                object_ds   => 'content_data',
                object_id   => $ct_data_id
            }
        );
        next if $obj_cat;
        $obj_cat = MT::ObjectCategory->new;
        $obj_cat->blog_id( $app->blog->id );
        $obj_cat->category_id($cat_id);
        $obj_cat->object_ds('content_data');
        $obj_cat->object_id($ct_data_id);
        $obj_cat->save;
    }
    return join ',', @cat_ids;
}

1;

