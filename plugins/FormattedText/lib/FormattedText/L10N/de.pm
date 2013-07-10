# Movable Type (r) (C) 2006-2013 Six Apart, Ltd. All Rights Reserved.
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
	'Manage boilerplate.' => 'Formatierten Text verwalten', # Translate - New # OK

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => '&#8222;Formatierten Text einfügen&#8220;-Symbol in der TinyMCE-Symbolleiste anzeigen', # Translate - New # OK

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'Konnte formatierten Text nicht laden', # Translate - New # OK

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Select a Boilerplate' => 'Formatierten Text wählen', # Translate - New # OK

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected boilerplates?' => 'Gewählte formatierten Texte wirklich löschen?', # Translate - New # OK
	'My Boilerplate' => 'Meine formatierten Texte', # Translate - New # OK

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'Boilerplates' => 'Formatierte Texte', # Translate - New # OK
	'The boilerplate \'[_1]\' is already in use in this blog.' => 'Der formatierte Text &#8222;[_1]&#8220; wird in diesem Blog bereits verwendet.', # Translate - New # OK

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Edit Boilerplate' => 'Formatierten Text bearbeiten', # Translate - New # OK
	'Create Boilerplate' => 'Formatierten Text anlegen', # Translate - New # OK
	'This boilerplate has been saved.' => 'Formatierter Text gespeichert', # Translate - New # OK
	'Save changes to this boilerplate (s)' => 'Änderungen am formatierten Text speichern (s)', # Translate - New # OK
	q{The boilerplate '[_1]' is already in use in this blog.} => q{Der formatierte Text &#8222;[_1]&#8220; wird in diesem Blog bereits verwendet.}, # Translate - New # OK

## plugins/FormattedText/tmpl/cms/list_formatted_text.tmpl
	'The boilerplate has been deleted from the database.' => 'Formatierter Text aus Datenbank gelöscht', # Translate - New # OK

);

1;
