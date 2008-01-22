# Movable Type (r) Open Source (C) 2005-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package StyleCatcher::L10N::fr;

use strict;
use base 'StyleCatcher::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'Le répertoire mt-static n\'a pas pu être trouvé. Veuillez configurer le \'StaticFilePath\' pour continuer.',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Impossible de créer le dossier [_1] - Vérifiez que votre dossier \'themes\' et en mode webserveur/écriture.',
	'Error downloading image: [_1]' => 'Erreur en téléchargeant l\'image : [_1]',
	'Successfully applied new theme selection.' => 'Sélection de nouveau Thème appliquée avec succès.',
	'Invalid URL: [_1]' => 'URL inaccessible : [_1]',

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a Style' => 'Habillages',
	'3-Columns, Wide, Thin, Thin' => '3-colonnes, large, fin, fin',
	'3-Columns, Thin, Wide, Thin' => '3-colonnes, fin, large, fin',
	'2-Columns, Thin, Wide' => '2-colonnes, fin, large',
	'2-Columns, Wide, Thin' => '2-colonnes, large, fin',
	'None available' => 'Aucun disponible',
	'Applying...' => 'Appliquer...',
	'Apply Design' => 'Appliquer l\'habillage',
	'Error applying theme: ' => 'Erreur en appliquant l\'habillage:',
	'The selected theme has been applied, but as you have changed the layout, you will need to republish your blog to apply the new layout.' => 'L\'habillage sélectionné a été appliqué. Vous devez republier votre blog afin d\'appliquer la nouvelle mise en page.',
	'The selected theme has been applied!' => 'L\'habillage sélectionné a été appliqué!',
	'Error loading themes! -- [_1]' => 'Erreur lors du chargement des habillages ! -- [_1]',
	'Stylesheet or Repository URL' => 'URL de la feuille de style ou du répertoire',
	'Stylesheet or Repository URL:' => 'URL de la feuille de style ou du répertoire:',
	'Download Styles' => 'Télécharger des habillages',
	'Current theme for your weblog' => 'Thème actuel de votre weblog',
	'Current Style' => 'Habillage actuel',
	'Locally saved themes' => 'Thèmes enregistrés localement',
	'Saved Styles' => 'Habillages enregistrés',
	'Default Styles' => 'Habillages par défaut',
	'Single themes from the web' => 'Thèmes uniques venant du web',
	'More Styles' => 'Plus d\'habillages',
	'Selected Design' => 'Habillage sélectionné',
	'Layout' => 'Mise en page',

## plugins/StyleCatcher/stylecatcher.pl
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.' => 'StyleCatcher vous permet de naviguer facilement à travers des styles et de les appliquer à votre blog en quelques clics seulement. Pour en savoir plus à propos des styles Movable Type, ou pour avoir de nouvelles sources de styles, visitez la page <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a>.',
	'MT 4 Style Library' => 'Bibliothèque MT4',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Une gamme de styles compatibles avec les gabarits MT4 par défaut',
	'MT 3 Style Library' => 'Bibliothèque MT3',
	'A collection of styles compatible with Movable Type 3.3+ default templates.' => 'Une gamme de styles compatibles avec les gabarits MT3.3+ par défaut',
	'Styles' => 'Habillages',
	'2-Columns, Wide, Medium' => '2-Colonnes, Large, Moyen', # Translate - New
	);

1;

