# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package FormattedText::L10N::es;

use strict;
use warnings;

use base 'FormattedText::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/FormattedText/config.yaml
	'Manage boilerplate.' => 'Administrar texto con formato.',

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => 'Añadir el botón "Insertar texto con formato" a TinyMCE.',

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'No se pudo cargar el texto con formato.',

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Select a Boilerplate' => 'Seleccionar un text con formato',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected boilerplates?' => '¿Está seguro que desea borrar los textos con formato seleccionados?',
	'My Boilerplate' => 'Mis textos con formato',

## plugins/FormattedText/lib/FormattedText/DataAPI/Callback/FormattedText.pm
	'The boilerplate \'[_1]\' is already in use in this site.' => 'Este sitio ya usa el texto con formato \'[_1]\'.', # Translate - New

## plugins/FormattedText/lib/FormattedText/DataAPI/Endpoint/v2/FormattedText.pm

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'Boilerplates' => 'Textos con formato',
	'The boilerplate \'[_1]\' is already in use in this blog.' => 'Este blog ya usa el texto con formato \'[_1]\'.',

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Edit Boilerplate' => 'Editar texto con formato',
	'Create Boilerplate' => 'Crear texto con formato',
	'This boilerplate has been saved.' => 'Se ha guardado este texto con formato.',
	'Save changes to this boilerplate (s)' => 'Guardar los cambios de este texto con formato (s)',
	q{The boilerplate '[_1]' is already in use in this blog.} => q{Este blog ya usa el texto con formato '[_1]'.},

## plugins/FormattedText/tmpl/cms/list_formatted_text.tmpl
	'The boilerplate has been deleted from the database.' => 'Se ha borrado de la base de datos el texto con formato.',

);

1;
