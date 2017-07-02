# Movable Type (r) (C) 2006-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package BlockEditor::App;

use strict;
use warnings;

use BlockEditor;

sub param_edit_content_data {
    my ( $cb, $app, $param, $tmpl ) = @_;

    my $blockeditor_fields       = $app->registry('blockeditor_fields');
    my @blockeditor_fields_array = map {
        my $hash = {};
        $hash->{type}  = $_;
        $hash->{label} = $blockeditor_fields->{$_}{label};
        $hash->{path}  = $blockeditor_fields->{$_}{path};
        $hash->{order} = $blockeditor_fields->{$_}{order};
        $hash;
    } keys %$blockeditor_fields;
    @blockeditor_fields_array = sort { $a->{order} <=> $b->{order} } @blockeditor_fields_array;
    $param->{blockeditor_fields} = \@blockeditor_fields_array;

    my $editor_tmpl = plugin()->load_tmpl('editor.tmpl');
    $param->{blockeditor_tmpl} = $editor_tmpl;
}

sub block_editor_asset {
    my $app = shift;
    my ($param) = @_;

    $app->validate_magic() or return;

    my ( $id, $asset );
    if ( $asset = $param->{asset} ) {
        $id = $asset->id;
    }
    else {
        $id = $param->{asset_id} || scalar $app->param('id');
        $asset = $app->model('asset')->lookup($id);
    }

    my $thumb_html = $asset->as_html( { include => 1 } );

    plugin()->load_tmpl(
        'cms/dialog/asset_insert.tmpl',
        {   asset_id   => $id,
            edit_field => $app->param('edit_field') || '',
            asset_html => $thumb_html,
        },
    );
}

1;
