# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package FormattedTextForTinyMCE5::L10N::fr;

use strict;
use warnings;

use base 'FormattedTextForTinyMCE5::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (
## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => 'Insérez le texte formaté', # Translate - New

## mt-static/plugins/FormattedTextForTinyMCE/langs/template.js
	'Boilerplate' => 'Texte formaté', # Translate - New
	'Select Boilerplate' => 'Sélectionnez le texte formaté', # Translate - New

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/langs/plugin.js
	'Fullscreen' => 'Plein écran',
	
## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => 'Ajoute le bouton "Insérer du texte formaté" à TinyMCE.', # Translate - New

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'Impossible de charger le texte formaté.', # Translate - New

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Select a Boilerplate' => 'Sélectionnez un texte formaté', # Translate - New

);

1;
