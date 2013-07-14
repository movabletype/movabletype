# Movable Type (r) Open Source (C) 2006-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package FormattedTextForTinyMCE::L10N::es;

use strict;
use warnings;

use base 'FormattedTextForTinyMCE::L10N::en_us';
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
