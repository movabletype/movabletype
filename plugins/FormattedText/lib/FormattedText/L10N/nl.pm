# Movable Type (r) (C) 2006-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package FormattedText::L10N::nl;

use strict;
use warnings;

use base 'FormattedText::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (
	
## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => 'Standaardtekst invoegen', # Translate - New

## mt-static/plugins/FormattedTextForTinyMCE/langs/template.js
	'Boilerplate' => 'Standaardtekst', # Translate - New
	'Select Boilerplate' => 'Standaardtekst selecteren', # Translate - New	

## plugins/FormattedText/config.yaml
	'Manage boilerplate.' => 'Standaardtekst beheren.', # Translate - New

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => 'De "Standaardtekst invoegen" knop toevoegen aan TinyMCE.', # Translate - New

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'Kan standaardtekst niet laden.', # Translate - New

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Select a Boilerplate' => 'Selecteer een standaardtekst.', # Translate - New

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected boilerplates?' => 'Bent u zeker dat u de geselecteerde standaardtekst wenst te verwijderen?', # Translate - New
	'My Boilerplate' => 'Mijn standaardteksten', # Translate - New

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'Boilerplates' => 'Standaardteksten', # Translate - New
	'The boilerplate \'[_1]\' is already in use in this blog.' => 'De standaardtekst \'[_1]\' bestaat al op deze blog.', # Translate - New

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Edit Boilerplate' => 'Standaardtekst bewerken', # Translate - New
	'Create Boilerplate' => 'Standaardtekst aanmaken', # Translate - New
	'This boilerplate has been saved.' => 'Deze standaardtekst werd opgeslagen.', # Translate - New
	'Save changes to this boilerplate (s)' => 'Wijzigingen aan deze standaardtekst opslaan (s)', # Translate - New
	q{The boilerplate '[_1]' is already in use in this blog.} => q{Standaardtekst '[_1]' wordt al gebruikt op deze blog.}, # Translate - New

## plugins/FormattedText/tmpl/cms/list_formatted_text.tmpl
	'The boilerplate has been deleted from the database.' => 'De standaardtekst werd verwijderd uit de database.', # Translate - New

);

1;
