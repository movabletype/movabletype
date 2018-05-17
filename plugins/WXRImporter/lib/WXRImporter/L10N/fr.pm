# WXRImporter plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
package WXRImporter::L10N::fr;

use strict;
use warnings;
use base 'WXRImporter::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/WXRImporter/config.yaml
	'Import WordPress exported RSS into MT.' => 'Importer depuis un export RSS WordPress vers MT',
	'"WordPress eXtended RSS (WXR)"' => '"WordPress eXtended RSS (WXR)"',
	'"Download WP attachments via HTTP."' => '"Télécharger les pièces jointes WP via HTTP."',

## plugins/WXRImporter/lib/WXRImporter/Import.pm
	'No Site' => 'Aucun site',
	'Archive Root' => 'Racine de l\'archive',

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'Le fichier n\'est pas dans le format WXR.',
	'Creating new tag (\'[_1]\')...' => 'Création d\'un nouveau tag (\'[_1]\')...',
	'Saving tag failed: [_1]' => 'L\'enregistrement du tag a échoué : [_1]',
	'Duplicate asset (\'[_1]\') found.  Skipping.' => 'L\'élément  (\'[_1]\') a été trouvé en double. Ignoré.',
	'Saving asset (\'[_1]\')...' => 'Enregistrement de l\'élément (\'[_1]\')...',
	' and asset will be tagged (\'[_1]\')...' => ' et l\'élément sera taggué (\'[_1]\')...',
	'Duplicate entry (\'[_1]\') found.  Skipping.' => 'La note  (\'[_1]\') a été trouvée en double. Ignorée.',
	'Saving page (\'[_1]\')...' => 'Enregistrement de la page (\'[_1]\')...',
	'Creating new comment (from \'[_1]\')...' => 'Création d\'un nouveau commentaire (de \'[_1]\')...',
	'Saving comment failed: [_1]' => 'Échec de la sauvegarde du commentaire : [_1]',
	'Entry has no MT::Trackback object!' => 'La note n\'a pas d\'objet MT::Trackback !',
	'Creating new ping (\'[_1]\')...' => 'Création d\'un nouveau ping (\'[_1]\')...',
	'Saving ping failed: [_1]' => 'Échec de la sauvegarde du ping : [_1]',
	'Assigning permissions for new user...' => 'Mise en place des autorisations pour le nouvel utilisateur...',
	'Saving permission failed: [_1]' => 'Échec de la sauvegarde des droits des utilisateurs : [_1]',

## plugins/WXRImporter/tmpl/options.tmpl
	q{Before you import WordPress posts to Movable Type, we recommend that you <a href='[_1]'>configure your site's publishing paths</a> first.} => q{Avant d'importer des notes WordPress dans Movable Type, nous vous recommandons de <a href='[_1]'>configurer les chemins de publication du site</a> au préalable.},
	q{Upload path for this WordPress blog} => q{Chemin d'envoi pour ce blog WordPress},
	'Replace with' => 'Remplacer par',
	'Download attachments' => 'Télécharger les fichiers attachés',
	q{Requires the use of a cron job to download attachments from WordPress powered blog in the background.} => q{L'utilisation d'un cron job est requis pour télécharger en arrière plan les fichiers attachés à un blog WordPress.},
	q{Download attachments (images and files) from the imported WordPress powered blog.} => q{Télécharger les fichiers attachés d'un blog WordPress (images et autres documents).},

);

1;

