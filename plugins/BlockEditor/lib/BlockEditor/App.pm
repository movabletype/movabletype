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
    @blockeditor_fields_array
        = sort { $a->{order} <=> $b->{order} } @blockeditor_fields_array;
    $param->{blockeditor_fields} = \@blockeditor_fields_array;

    my $editor_tmpl = plugin()->load_tmpl('editor.tmpl');
    $param->{blockeditor_tmpl} = $editor_tmpl;
}

sub block_editor_asset {
    my $app    = shift;
    my (%args) = @_;
    my $assets = $args{assets};

    $app->validate_magic() or return;

    if ( !$assets ) {
        my $ids = $app->param('id');
        return $app->errtrans('Invalid request.') unless $ids;

        my @ids = split ',', $ids;
        return $app->errtrans('Invalid request.') unless @ids;
        my @assets = $app->model('asset')->load( { id => \@ids } );

        # Sort by @ids order.
        my %assets = map { $_->id => $_ } @assets;
        @assets = map { $assets{$_} } @ids;

        $assets = \@assets;
    }

    my $params->{assets} = $assets;
    $params->{edit_field} = $app->param('edit_field') || '';

    plugin()->load_tmpl( 'cms/dialog/asset_insert.tmpl', $params );
}

1;
