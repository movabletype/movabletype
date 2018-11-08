# Movable Type (r) (C) 2006-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package BlockEditor::L10N::nl;

use strict;
use warnings;

use base 'BlockEditor::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field.js
	'Edit [_1] block' => '[_1] blok bewerken',

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field_manager.js

## mt-static/plugins/BlockEditor/lib/js/fields/embed.js
	'Embed Code' => 'Insluitcode', # Translate - New
	'Please enter the embed code here.' => 'Gelieve de insluitcode hier in te geven.', # Translate - New

## mt-static/plugins/BlockEditor/lib/js/fields/header.js
	'Heading' => 'Hoofding', # Translate - New
	'Heading Level' => 'Hoofdingsniveau', # Translate - New
	'Please enter the Header Text here.' => 'Vul hier de tekst voor de hoofding in.', # Translate - New

## mt-static/plugins/BlockEditor/lib/js/fields/horizon.js
	'Horizontal Rule' => 'Horizontale lijn', # Translate - New

## mt-static/plugins/BlockEditor/lib/js/fields/image.js

## mt-static/plugins/BlockEditor/lib/js/fields/text.js
	'__TEXT_BLOCK__' => 'Tekst', # Translate - New

## mt-static/plugins/BlockEditor/lib/js/jquery.blockeditor.js
	'Select a block' => 'Selecteer een blok', # Translate - New

## mt-static/plugins/BlockEditor/lib/js/modal_window.js

## plugins/BlockEditor/config.yaml
	'Block Editor.' => 'Blok editor.',
	'Block Editor' => 'Blok editor',

## plugins/BlockEditor/lib/BlockEditor/App.pm

## plugins/BlockEditor/lib/BlockEditor/BlockEditorFieldType/Image.pm

## plugins/BlockEditor/tmpl/cms/dialog/asset_modal.tmpl

## plugins/BlockEditor/tmpl/cms/dialog/include/asset_upload_panel.tmpl

## plugins/BlockEditor/tmpl/cms/dialog/multi_asset_options.tmpl

## plugins/BlockEditor/tmpl/cms/field_html/field_html_multi_line_text.tmpl
	'Changing to plain text is not possible to return to the block edit.' => 'Na veranderen naar gewone tekst is het niet mogelijk de inhoud terug te brengen naar blok edit modus.',
	'Changing to block editor is not possible to result return to your current document.' => 'Na veranderen naar de blok editor is niet mogelijk om resultaat terug te brengen naar uw huidige document.',

## plugins/BlockEditor/tmpl/cms/include/async_asset_list.tmpl

## plugins/BlockEditor/tmpl/cms/include/insert_options.tmpl
	'Alt' => 'Alt',
	'Caption' => 'Onderschrift',

);

1;
