package FormattedText::L10N::fr;

use strict;
use warnings;

use base 'FormattedText::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/FormattedText/config.yaml
	'Manage boilerplate.' => 'Gérer le texte formaté', # Translate - New

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => 'Ajoute le bouton "Insérer du texte formaté" à TinyMCE.', # Translate - New

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'Impossible de charger le texte formaté.', # Translate - New

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Select a Boilerplate' => 'Sélectionnez un texte formaté', # Translate - New

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected boilerplates?' => 'Voulez-vous vraiment supprimer les textes formatés sélectionnés ?', # Translate - New
	'My Boilerplate' => 'Mon texte formaté', # Translate - New

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'Boilerplates' => 'Textes formatés', # Translate - New
	'The boilerplate \'[_1]\' is already in use in this blog.' => 'Le texte formaté \'[_1]\' est déjà utilisé sur ce blog.', # Translate - New

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Edit Boilerplate' => 'Éditer le texte formaté', # Translate - New
	'Create Boilerplate' => 'Créer un texte formaté', # Translate - New
	'This boilerplate has been saved.' => 'Ce texte formaté a été enregistré.', # Translate - New
	'Save changes to this boilerplate (s)' => 'Enregistrer les modifications de ce texte formaté (s)', # Translate - New
	q{The boilerplate '[_1]' is already in use in this blog.} => q{Le texte formaté '[_1]' est déjà utilisé sur ce blog.}, # Translate - New

## plugins/FormattedText/tmpl/cms/list_formatted_text.tmpl
	'The boilerplate has been deleted from the database.' => 'Le texte formaté a été supprimé de la base de données.', # Translate - New

);

1;
