# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package FormattedText::L10N::de;

use strict;
use warnings;

use base 'FormattedText::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/FormattedText/config.yaml
	'Manage boilerplate.' => 'Textbausteine verwalten', # Translate - Improved

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => '&#8222;Textbaustein einfügen&#8220;-Symbol in der TinyMCE-Symbolleiste anzeigen', # Translate - Improved

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'Konnte Textbaustein nicht laden', # Translate - Improved

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Select a Boilerplate' => 'Textbaustein wählen', # Translate - Improved

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected boilerplates?' => 'Gewählten Textbaustein wirklich löschen?', # Translate - Improved
	'My Boilerplate' => 'Meine Textbausteine', # Translate - Improved

## plugins/FormattedText/lib/FormattedText/DataAPI/Callback/FormattedText.pm
	'The boilerplate \'[_1]\' is already in use in this site.' => 'Der Textbaustein \'[_1]\' wird in dieser Site bereits verwendet.', # Translate - New # OK

## plugins/FormattedText/lib/FormattedText/DataAPI/Endpoint/v2/FormattedText.pm

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'Boilerplates' => 'Textbausteine', # Translate - Improved
	'The boilerplate \'[_1]\' is already in use in this blog.' => 'Der Textbaustein &#8222;[_1]&#8220; wird in diesem Blog bereits verwendet.', # Translate - Improved

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Edit Boilerplate' => 'Textbaustein bearbeiten', # Translate - Improved
	'Create Boilerplate' => 'Textbaustein anlegen', # Translate - Improved
	'This boilerplate has been saved.' => 'Textbaustein gespeichert', # Translate - Improved
	'Save changes to this boilerplate (s)' => 'Änderungen des Textbausteins speichern (s)', # Translate - Improved
	q{The boilerplate '[_1]' is already in use in this blog.} => q{Der Textbaustein  &#8222;[_1]&#8220; wird in diesem Blog bereits verwendet.}, # Translate - Improved

## plugins/FormattedText/tmpl/cms/list_formatted_text.tmpl
	'The boilerplate has been deleted from the database.' => 'Textbaustein aus Datenbank gelöscht', # Translate - Improved

);

1;
