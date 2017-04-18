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
    my $html = '';
    $html
        .= '<input type="text" name="content-field-'
        . $id
        . '" class="text long" value="';
    my $count = 1;
    foreach my $obj_asset (@obj_assets) {
        $html .= $obj_asset->asset_id;
        $html .= ',' unless $count == @obj_assets;
        $count++;
    }
    $html .= '" />';
    return $html;
}

sub data_getter {
    my ( $app, $id ) = @_;
    my $q          = $app->param;
    my $ct_data_id = $q->param('id');
    my $asset_ids  = $q->param( 'content-field-' . $id );
    my @asset_ids  = split ',', $asset_ids;
    foreach my $asset_id (@asset_ids) {
        my $asset = MT::Asset->load($asset_id);
        next unless $asset;
        my $obj_asset = MT::ObjectAsset->load(
            {   asset_id  => $asset_id,
                object_ds => 'content_data',
                object_id => $ct_data_id
            }
        );
        next if $obj_asset;
        $obj_asset = MT::ObjectAsset->new;
        $obj_asset->blog_id( $app->blog->id );
        $obj_asset->asset_id($asset_id);
        $obj_asset->object_ds('content_data');
        $obj_asset->object_id($ct_data_id);
        $obj_asset->save;
    }
    return $asset_ids;
}

1;

