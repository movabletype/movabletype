# Movable Type (r) (C) 2006-2018 Six Apart, Ltd. All Rights Reserved.
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

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field.js
	'Edit [_1] block' => 'Editar bloque de [_1]', # Translate - New

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field_manager.js

## mt-static/plugins/BlockEditor/lib/js/fields/embed.js
	'Embed Code' => 'Insertar código', # Translate - New
	'Please enter the embed code here.' => 'Por favor, introduzca el código aquí.', # Translate - New

## mt-static/plugins/BlockEditor/lib/js/fields/header.js
	'Heading' => 'Cabecera', # Translate - New
	'Heading Level' => 'Nivel de cabecera', # Translate - New
	'Please enter the Header Text here.' => 'Por favor, introduzca el texto de la cabecera aquí.', # Translate - New

## mt-static/plugins/BlockEditor/lib/js/fields/horizon.js
	'Horizontal Rule' => 'Línea horizontal', # Translate - New

## mt-static/plugins/BlockEditor/lib/js/fields/image.js

## mt-static/plugins/BlockEditor/lib/js/fields/text.js
	'__TEXT_BLOCK__' => 'Texto', # Translate - New

## mt-static/plugins/BlockEditor/lib/js/jquery.blockeditor.js
	'Select a block' => 'Seleccione un bloque', # Translate - New
## plugins/BlockEditor/config.yaml
	'Block Editor.' => 'Editor de bloques.', # Translate - New
	'Block Editor' => 'Editor de bloques', # Translate - New

## plugins/BlockEditor/lib/BlockEditor/App.pm

## plugins/BlockEditor/lib/BlockEditor/BlockEditorFieldType/Image.pm

## plugins/BlockEditor/tmpl/cms/dialog/asset_modal.tmpl

## plugins/BlockEditor/tmpl/cms/dialog/include/asset_upload_panel.tmpl

## plugins/BlockEditor/tmpl/cms/dialog/multi_asset_options.tmpl

## plugins/BlockEditor/tmpl/cms/field_html/field_html_multi_line_text.tmpl
	'Changing to plain text is not possible to return to the block edit.' => 'Si cambia al texto plano no será posible regresar a la edición de bloques.', # Translate - New
	'Changing to block editor is not possible to result return to your current document.' => 'Si cambiar al editor de bloques no será posible regresar al documento actual.', # Translate - New

## plugins/BlockEditor/tmpl/cms/include/async_asset_list.tmpl

## plugins/BlockEditor/tmpl/cms/include/insert_options.tmpl
	'Alt' => 'Alt', # Translate - New
	'Caption' => 'Leyenda', # Translate - New

);

1;
