# Movable Type (r) (C) 2006-2018 Six Apart, Ltd. All Rights Reserved.
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

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field.js
	'Edit [_1] block' => '[_1]-Block bearbeiten',

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field_manager.js

## mt-static/plugins/BlockEditor/lib/js/fields/embed.js
	'Embed Code' => 'Code einbetten', # Translate - New # OK
	'Please enter the embed code here.' => 'Bitte geben Sie den einzubettenden Code hier ein.', # Translate - New # OK

## mt-static/plugins/BlockEditor/lib/js/fields/header.js
	'Heading' => 'Überschrift', # Translate - New # OK
	'Heading Level' => 'Ebene der Überschrift', # Translate - New # OK
	'Please enter the Header Text here.' => 'Bitte geben Sie die Überschrift hier ein.', # Translate - New # OK

## mt-static/plugins/BlockEditor/lib/js/fields/horizon.js
	'Horizontal Rule' => 'Horizontale Trennlinie', # Translate - New # OK

## mt-static/plugins/BlockEditor/lib/js/fields/image.js

## mt-static/plugins/BlockEditor/lib/js/fields/text.js
	'__TEXT_BLOCK__' => 'Text', # Translate - New # OK

## mt-static/plugins/BlockEditor/lib/js/jquery.blockeditor.js
	'Select a block' => 'Wählen Sie einen Block', # Translate - New # OK
	
## plugins/BlockEditor/config.yaml
	'Block Editor.' => 'Block-Editor.',
	'Block Editor' => 'Block-Editor',

## plugins/BlockEditor/lib/BlockEditor/App.pm

## plugins/BlockEditor/lib/BlockEditor/BlockEditorFieldType/Image.pm

## plugins/BlockEditor/tmpl/cms/dialog/asset_modal.tmpl

## plugins/BlockEditor/tmpl/cms/dialog/include/asset_upload_panel.tmpl

## plugins/BlockEditor/tmpl/cms/dialog/multi_asset_options.tmpl

## plugins/BlockEditor/tmpl/cms/field_html/field_html_multi_line_text.tmpl
	'Changing to plain text is not possible to return to the block edit.' => 'Nach Wechsel auf unformatierten Text kann nicht zum Block-Editor zurückgekehrt werden.',
	'Changing to block editor is not possible to result return to your current document.' => 'Nach Wechsel zum Block-Editor kann nicht zurückgewechselt werden.',

## plugins/BlockEditor/tmpl/cms/include/async_asset_list.tmpl

## plugins/BlockEditor/tmpl/cms/include/insert_options.tmpl
	'Alt' => 'Alternativtext',
	'Caption' => 'Titel',

);

1;
