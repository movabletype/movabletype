# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package FormattedTextForTinyMCE6::L10N::es;

use strict;
use warnings;

use base 'FormattedTextForTinyMCE6::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (
	
## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => 'Insertar texto con formato', # Translate - New

## mt-static/plugins/FormattedTextForTinyMCE/langs/template.js
	'Boilerplate' => 'Texto con formato', # Translate - New
	'Select Boilerplate' => 'Seleccionar Texto con formato', # Translate - New

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => 'Añadir el botón "Insertar texto con formato" a TinyMCE.', # Translate - New

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'No se pudo cargar el texto con formato.', # Translate - New

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Select a Boilerplate' => 'Seleccionar un text con formato', # Translate - New
);

1;
