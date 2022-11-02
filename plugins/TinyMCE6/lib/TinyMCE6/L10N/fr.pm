# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package TinyMCE6::L10N::fr;

use strict;
use warnings;
use utf8;
use base 'TinyMCE6::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/advanced.js
	'Bold (Ctrl+B)' => 'Gras (Ctrl+B)',
	'Italic (Ctrl+I)' => 'Italique (Ctrl+I)',
	'Underline (Ctrl+U)' => 'Souligné (Ctrl+U)',
	'Strikethrough' => 'Rayé',
	'Block Quotation' => 'Bloc de citation',
	'Unordered List' => 'Liste non ordonnée',
	'Ordered List' => 'Liste ordonnée',
	'Horizontal Line' => 'Ligne horizontale',
	'Insert/Edit Link' => 'Insérer/éditer un lien',
	'Unlink' => 'Délier',
	'Undo (Ctrl+Z)' => 'Annuler (Ctrl+Z)',
	'Redo (Ctrl+Y)' => 'Refaire (Ctrl+Y)',
	'Select Text Color' => 'Choisir la couleur du texte',
	'Select Background Color' => 'Choisir la couleur du fond',
	'Remove Formatting' => 'Supprimer le formatage',
	'Align Left' => 'Aligner à gauche',
	'Align Center' => 'Aligner au centre',
	'Align Right' => 'Aligner à droite',
	'Indent' => 'Indenter',
	'Outdent' => 'Désindenter',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/insert_html.js
	'Insert HTML' => 'Insérer du HTML',
	'Source' => 'Source',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/plugin.js
	'Insert Link' => 'Insérer un lien',
	'Insert Image Asset' => 'Insérer une image',
	'Insert Asset Link' => 'Insérer un lien de fichier',
	'Toggle Fullscreen Mode' => 'Bascule plein écran',
	'Toggle HTML Edit Mode' => 'Bascule mode code HTML',
	'Strong Emphasis' => 'Forte emphase',
	'Emphasis' => 'Emphase',
	'List Item' => 'Item de liste',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/langs/plugin.js
	'Fullscreen' => 'Plein écran',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/paste/editor_plugin.js
	'paste.plaintext_mode_sticky' => 'paste.plaintext_mode_sticky',
	'paste.plaintext_mode' => 'paste.plaintext_mode',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/paste/editor_plugin_src.js

## mt-static/plugins/TinyMCE/tiny_mce/themes/advanced/editor_template.js
	'advanced.path' => 'advanced.path',

## mt-static/plugins/TinyMCE/tiny_mce/themes/advanced/editor_template_src.js

## mt-static/plugins/TinyMCE/tiny_mce/themes/advanced/js/charmap.js
	'advanced_dlg.charmap_usage' => 'advanced_dlg.charmap_usage',

## mt-static/plugins/TinyMCE/tiny_mce/utils/editable_selects.js
	'value' => 'valeur',

## plugins/TinyMCE/config.yaml
	'Default WYSIWYG editor.' => 'Éditeur riche par défaut',
	'TinyMCE' => 'TinyMCE',

);

1;
