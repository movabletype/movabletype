# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package FormattedText::L10N::fr;

use strict;
use warnings;

use base 'FormattedText::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/FormattedText/config.yaml
	'Manage boilerplate.' => 'Gérer le texte formaté',

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => 'Ajoute le bouton "Insérer du texte formaté" à TinyMCE.',

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'Impossible de charger le texte formaté.',

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Select a Boilerplate' => 'Sélectionnez un texte formaté',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected boilerplates?' => 'Voulez-vous vraiment supprimer les textes formatés sélectionnés ?',
	'My Boilerplate' => 'Mon texte formaté',

## plugins/FormattedText/lib/FormattedText/DataAPI/Callback/FormattedText.pm
	'The boilerplate \'[_1]\' is already in use in this site.' => 'Le texte formaté \'[_1]\' est déjà utilisé sur ce site.', # Translate - New

## plugins/FormattedText/lib/FormattedText/DataAPI/Endpoint/v2/FormattedText.pm

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'Boilerplates' => 'Textes formatés',
	'The boilerplate \'[_1]\' is already in use in this blog.' => 'Le texte formaté \'[_1]\' est déjà utilisé sur ce blog.',

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Edit Boilerplate' => 'Éditer le texte formaté',
	'Create Boilerplate' => 'Créer un texte formaté',
	'This boilerplate has been saved.' => 'Ce texte formaté a été enregistré.',
	'Save changes to this boilerplate (s)' => 'Enregistrer les modifications de ce texte formaté (s)',
	q{The boilerplate '[_1]' is already in use in this blog.} => q{Le texte formaté '[_1]' est déjà utilisé sur ce blog.},

## plugins/FormattedText/tmpl/cms/list_formatted_text.tmpl
	'The boilerplate has been deleted from the database.' => 'Le texte formaté a été supprimé de la base de données.',

);

1;
