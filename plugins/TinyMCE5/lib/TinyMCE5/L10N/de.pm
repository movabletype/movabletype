# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package TinyMCE5::L10N::de;

use strict;
use warnings;
use utf8;
use base 'TinyMCE5::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/advanced.js
	'Bold (Ctrl+B)' => 'Fett (Strg+B)',
	'Italic (Ctrl+I)' => 'Kursiv (Strg+I)',
	'Underline (Ctrl+U)' => 'Unterstrichen (Strg+U)',
	'Strikethrough' => 'Durchstreichen',
	'Block Quotation' => 'Zitat',
	'Unordered List' => 'Unsortierte Liste',
	'Ordered List' => 'Sortierte Liste',
	'Horizontal Line' => 'Trennlinie',
	'Insert/Edit Link' => 'Link einfügen/bearbeiten',
	'Unlink' => 'Link entfernen',
	'Undo (Ctrl+Z)' => 'Rückgängig (Strg+Z)',
	'Redo (Ctrl+Y)' => 'Wiederholen (Strg+Y)',
	'Select Text Color' => 'Schriftfarbe wählen',
	'Select Background Color' => 'Hintergrundfarbe wählen',
	'Remove Formatting' => 'Formatierung entfernen',
	'Align Left' => 'Linsbündig',
	'Align Center' => 'Zentriert',
	'Align Right' => 'Rechtsbündig',
	'Indent' => 'Einrücken',
	'Outdent' => 'Ausrücken',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/insert_html.js
	'Insert HTML' => 'HTML einfügen',
	'Source' => 'Quelle',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/plugin.js
	'Insert Link' => 'Link einfügen',
	'Insert Image Asset' => 'Bild aus Assets einfügen',
	'Insert Asset Link' => 'Link aus Assets einfügen',
	'Toggle Fullscreen Mode' => 'Vollbildmodus aktivieren/deaktivieren',
	'Toggle HTML Edit Mode' => 'HTML-Editor aktivieren/deaktivieren',
	'Strong Emphasis' => 'Starke Betonung',
	'Emphasis' => 'Betonung',
	'List Item' => 'Listenelement',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/langs/plugin.js
	'Fullscreen' => 'Fullscreen',

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
	'value' => 'Wert',

## plugins/TinyMCE/config.yaml
	'Default WYSIWYG editor.' => 'Als Standard festgelegter grafischer Editor.',
	'TinyMCE' => 'TinyMCE',

);

1;
