# Movable Type (r) (C) 2005-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package StyleCatcher::L10N::fr;

use strict;
use base 'StyleCatcher::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/StyleCatcher/config.yaml
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks.' => 'StyleCatcher vous permet de parcourir facilement les styles et les appliquer ensuite à votre blog en quelques clics.',
	'MT 4 Style Library' => 'Bibliothèque MT4',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Une gamme de styles compatibles avec les gabarits MT4 par défaut',
	'Styles' => 'Habillages',
	'Moving current style to blog_meta for website...' => 'Déplacement du style courant du site web vers blog_meta...', # Translate - New
	'Moving current style to blog_meta for blog...' => 'Déplacement du style courant du blog vers blog_meta...', # Translate - New

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'Le répertoire mt-static n\'a pas pu être trouvé. Veuillez configurer le \'StaticFilePath\' pour continuer.',
	'Permission Denied.' => 'Autorisation refusée.',
	'Successfully applied new theme selection.' => 'Le nouveau thème sélectionné a été appliqué avec succès.',

## plugins/StyleCatcher/lib/StyleCatcher/Library/Default.pm
	'Invalid URL: [_1]' => 'URL invalide : [_1]',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Impossible de créer le dossier [_1] - Vérifiez que votre dossier \'themes\' et en mode webserveur/écriture.',

## plugins/StyleCatcher/lib/StyleCatcher/Library/Local.pm
	'Failed to load StyleCatcher Library: [_1]' => 'Impossible de charger la bibliothèque : [_1]',

## plugins/StyleCatcher/lib/StyleCatcher/Util.pm
	'(Untitled)' => '(Sans titre)',

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a [_1] Style' => 'Sélectionner un style [_1]',
	'3-Columns, Wide, Thin, Thin' => '3-colonnes, large, fin, fin',
	'3-Columns, Thin, Wide, Thin' => '3-colonnes, fin, large, fin',
	'3-Columns, Thin, Thin, Wide' => '3 colonnes (fin, fin, large)',
	'2-Columns, Thin, Wide' => '2-colonnes, fin, large',
	'2-Columns, Wide, Thin' => '2-colonnes, large, fin',
	'2-Columns, Wide, Medium' => '2-Colonnes, Large, Moyen',
	'2-Columns, Medium, Wide' => '2 colonnes (moyen, large)',
	'1-Column, Wide, Bottom' => '1 colonne (large, pied)',
	'None available' => 'Aucun disponible',
	'Applying...' => 'Appliquer...',
	q{Apply Design} => q{Appliquer l'habillage},
	q{Error applying theme: } => q{Erreur en appliquant l'habillage :},
	q{The selected theme has been applied, but as you have changed the layout, you will need to republish your blog to apply the new layout.} => q{L'habillage sélectionné a été appliqué. Vous devez republier votre blog afin d'appliquer la nouvelle mise en page.},
	q{The selected theme has been applied!} => q{L'habillage sélectionné a été appliqué !},
	'Error loading themes! -- [_1]' => 'Erreur lors du chargement des habillages ! -- [_1]',
	'Stylesheet or Repository URL' => 'URL de la feuille de style ou du répertoire',
	'Stylesheet or Repository URL:' => 'URL de la feuille de style ou du répertoire :',
	'Download Styles' => 'Télécharger des habillages',
	'Current theme for your weblog' => 'Thème actuel de votre weblog',
	'Current Style' => 'Habillage actuel',
	'Locally saved themes' => 'Thèmes enregistrés localement',
	'Saved Styles' => 'Habillages enregistrés',
	'Default Styles' => 'Habillages par défaut',
	'Single themes from the web' => 'Thèmes uniques venant du web',
	q{More Styles} => q{Plus d'habillages},
	'Selected Design' => 'Habillage sélectionné',
	'Layout' => 'Mise en page',
);

1;

