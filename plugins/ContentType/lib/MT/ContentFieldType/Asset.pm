package MT::ContentFieldType::Asset;
use strict;
use warnings;

use MT::Asset;
use MT::ObjectAsset;

sub field_html {
    my ( $app, $id, $value ) = @_;
    my $q          = $app->param;
    my $ct_data_id = $q->param('id');
    my @obj_assets = MT::ObjectAsset->load(
        {   object_ds => 'content_data',
            object_id => $ct_data_id
        }
    );
    my $html
        .= '<input type="text" name="content-field-'
        . $id
        . '" class="text long" value="';
    $html .= join ',', @$value;
    $html .= '" />';
    return $html;
}

sub data_getter {
    my ( $app, $id ) = @_;
    my $asset_ids = $app->param( 'content-field-' . $id );
    my @asset_ids = split ',', $asset_ids;

    my @assets = MT::Asset->load( { id => \@asset_ids },
        { no_class => 1, fetchonly => { id => 1 } } );
    my %assets = map { $_->id => 1 } @assets;

    [ grep { $assets{$_} } @asset_ids ];
}

1;

