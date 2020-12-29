# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package BlockEditor::L10N::es;

use strict;
use warnings;

use base 'BlockEditor::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/BlockEditor/config.yaml
	'Block Editor.' => 'Editor de bloques.',
	'Block Editor' => 'Editor de bloques',

## plugins/BlockEditor/lib/BlockEditor/App.pm

## plugins/BlockEditor/lib/BlockEditor/BlockEditorFieldType/Image.pm

## plugins/BlockEditor/tmpl/cms/dialog/asset_modal.tmpl
	'Upload new image' => 'Subir nueva imagen',

## plugins/BlockEditor/tmpl/cms/dialog/include/asset_upload_panel.tmpl

## plugins/BlockEditor/tmpl/cms/dialog/multi_asset_options.tmpl

## plugins/BlockEditor/tmpl/cms/field_html/field_html_multi_line_text.tmpl
	'Sort' => 'Ordenar', # Translate - New
	'No block in this field.' => 'Sin bloqueo en este campo.', # Translate - New
	'Changing to plain text is not possible to return to the block edit.' => 'Si cambia al texto plano no será posible regresar a la edición de bloques.',
	'Changing to block editor is not possible to result return to your current document.' => 'Si cambiar al editor de bloques no será posible regresar al documento actual.',

## plugins/BlockEditor/tmpl/cms/include/async_asset_list.tmpl

## plugins/BlockEditor/tmpl/cms/include/insert_options.tmpl
	'Alt' => 'Alt',
	'Caption' => 'Leyenda',

);

1;
