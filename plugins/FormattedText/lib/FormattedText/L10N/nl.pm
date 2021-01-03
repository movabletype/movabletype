# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
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
	
## plugins/FormattedText/config.yaml
	'Manage boilerplate.' => 'Standaardtekst beheren.',

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => 'De "Standaardtekst invoegen" knop toevoegen aan TinyMCE.',

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'Kan standaardtekst niet laden.',

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Select a Boilerplate' => 'Selecteer een standaardtekst.',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected boilerplates?' => 'Bent u zeker dat u de geselecteerde standaardtekst wenst te verwijderen?',
	'My Boilerplate' => 'Mijn standaardteksten',

## plugins/FormattedText/lib/FormattedText/DataAPI/Callback/FormattedText.pm
	'The boilerplate \'[_1]\' is already in use in this site.' => 'De standaardtekst \'[_1]\' wordt al gebruikt op deze site.', # Translate - New

## plugins/FormattedText/lib/FormattedText/DataAPI/Endpoint/v2/FormattedText.pm

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'Boilerplates' => 'Standaardteksten',
	'The boilerplate \'[_1]\' is already in use in this blog.' => 'Standaardtekst \'[_1]\' wordt al gebruikt op deze blog.',

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Edit Boilerplate' => 'Standaardtekst bewerken',
	'Create Boilerplate' => 'Standaardtekst aanmaken',
	'This boilerplate has been saved.' => 'Deze standaardtekst werd opgeslagen.',
	'Save changes to this boilerplate (s)' => 'Wijzigingen aan deze standaardtekst opslaan (s)',
	q{The boilerplate '[_1]' is already in use in this blog.} => q{Standaardtekst '[_1]' wordt al gebruikt op deze blog.},

## plugins/FormattedText/tmpl/cms/list_formatted_text.tmpl
	'The boilerplate has been deleted from the database.' => 'De standaardtekst werd verwijderd uit de database.',

);

1;
