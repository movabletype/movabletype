# Movable Type (r) (C) 2006-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package BlockEditor::L10N::fr;

use strict;
use warnings;

use base 'BlockEditor::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field.js
	'Edit [_1] block' => 'Éditer le bloc [_1]',

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field_manager.js

## mt-static/plugins/BlockEditor/lib/js/fields/embed.js
	'Embed Code' => 'Code embarqué', # Translate - New
	'Please enter the embed code here.' => 'Entrer le code embarqué ici.', # Translate - New

## mt-static/plugins/BlockEditor/lib/js/fields/header.js
	'Heading' => 'Titre', # Translate - New
	'Heading Level' => 'Niveau de titre', # Translate - New
	'Please enter the Header Text here.' => 'Entrer le texte du titre ici.', # Translate - New

## mt-static/plugins/BlockEditor/lib/js/fields/horizon.js
	'Horizontal Rule' => 'Règle horizontale', # Translate - New

## mt-static/plugins/BlockEditor/lib/js/fields/image.js

## mt-static/plugins/BlockEditor/lib/js/fields/text.js
	'__TEXT_BLOCK__' => 'Bloc de texte', # Translate - New

## mt-static/plugins/BlockEditor/lib/js/jquery.blockeditor.js
	'Select a block' => 'Sélectionner un bloc', # Translate - New

## plugins/BlockEditor/config.yaml
	'Block Editor.' => 'Éditeur de bloc.',
	'Block Editor' => 'Éditeur de bloc',

## plugins/BlockEditor/lib/BlockEditor/App.pm

## plugins/BlockEditor/lib/BlockEditor/BlockEditorFieldType/Image.pm

## plugins/BlockEditor/tmpl/cms/dialog/asset_modal.tmpl

## plugins/BlockEditor/tmpl/cms/dialog/include/asset_upload_panel.tmpl

## plugins/BlockEditor/tmpl/cms/dialog/multi_asset_options.tmpl

## plugins/BlockEditor/tmpl/cms/field_html/field_html_multi_line_text.tmpl
	q{Changing to plain text is not possible to return to the block edit.} => q{Changer pour du texte brut interdit le retour à l'éditeur de bloc.},
	q{Changing to block editor is not possible to result return to your current document.} => q{Changer pour l'éditeur de bloc ne permet pas de revenir facilement au présent document.},

## plugins/BlockEditor/tmpl/cms/include/async_asset_list.tmpl

## plugins/BlockEditor/tmpl/cms/include/insert_options.tmpl
	'Alt' => 'Alt',
	'Caption' => 'Légende',

);

1;
