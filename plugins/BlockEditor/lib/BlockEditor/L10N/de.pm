# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package BlockEditor::L10N::de;

use strict;
use warnings;

use base 'BlockEditor::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/BlockEditor/config.yaml
	'Block Editor.' => 'Block-Editor.',
	'Block Editor' => 'Block-Editor',

## plugins/BlockEditor/lib/BlockEditor/App.pm

## plugins/BlockEditor/lib/BlockEditor/BlockEditorFieldType/Image.pm

## plugins/BlockEditor/tmpl/cms/dialog/asset_modal.tmpl
	'Upload new image' => 'Neues Bild hochladen',

## plugins/BlockEditor/tmpl/cms/dialog/include/asset_upload_panel.tmpl

## plugins/BlockEditor/tmpl/cms/dialog/multi_asset_options.tmpl

## plugins/BlockEditor/tmpl/cms/field_html/field_html_multi_line_text.tmpl
	'Sort' => 'Sortieren', # Translate - New # OK
	'No block in this field.' => 'Kein Block in diesem Feld.', # Translate - New # OK
	'Changing to plain text is not possible to return to the block edit.' => 'Nach Wechsel auf unformatierten Text kann nicht zum Block-Editor zurückgekehrt werden.',
	'Changing to block editor is not possible to result return to your current document.' => 'Nach Wechsel zum Block-Editor kann nicht zurückgewechselt werden.',

## plugins/BlockEditor/tmpl/cms/include/async_asset_list.tmpl

## plugins/BlockEditor/tmpl/cms/include/insert_options.tmpl
	'Alt' => 'Alternativtext',
	'Caption' => 'Titel',

);

1;
