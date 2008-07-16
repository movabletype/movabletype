# WXRImporter plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
package WXRImporter::L10N::fr;

use strict;
use base 'WXRImporter::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/WXRImporter/lib/WXRImporter/Import.pm

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'Le fichier n\'est pas dans le format WXR.',
	'Creating new tag (\'[_1]\')...' => 'Création d\'un nouveau tag (\'[_1]\')...', # Translate - New
	'Saving tag failed: [_1]' => 'L\'enregistrement du tag a échoué : [_1]', # Translate - New
	'Duplicate asset (\'[_1]\') found.  Skipping.' => 'L\'élément  (\'[_1]\') a été trouvé en double. Abandon.',
	'Saving asset (\'[_1]\')...' => 'Enregistrement de l\'élément (\'[_1]\')...',
	' and asset will be tagged (\'[_1]\')...' => ' et l\'élément sera taggué (\'[_1]\')...',
	'Duplicate entry (\'[_1]\') found.  Skipping.' => 'La note  (\'[_1]\') a été trouvée en double. Abandon.',
	'Saving page (\'[_1]\')...' => 'Enregistrement de la page (\'[_1]\')...',

## plugins/WXRImporter/tmpl/options.tmpl
	'Before you import WordPress posts to Movable Type, we recommend that you <a href=\'[_1]\'>configure your blog\'s publishing paths</a> first.' => 'Avant d\'importer des notes Wordpress dans Movable Type, nous vous recommandons d\'abord de <a href=\'[_1]\'>configurer les chemins de publication de votre blog</a>.',
	'Upload path for this WordPress blog' => 'Chemin d\'envoi pour ce blog WordPress',
	'Replace with' => 'Remplacer par',
	'Download attachments' => 'Télécharger les fichiers attachés',
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'L\'utilisation d\'un cron job est requis pour télécharger en arrière plan les fichiers attachés à un blog WordPress.',
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'Télécharger les fichiers attachés d\'un blog WordPress (images et autres documents).',

## plugins/WXRImporter/WXRImporter.pl
	'Import WordPress exported RSS into MT.' => 'Importer depuis WordPress exported RSS vers MT',
	'WordPress eXtended RSS (WXR)' => 'WordPress eXtended RSS (WXR)',
	'Download WP attachments via HTTP.' => 'Télécharger tous les fichiers attachés à un blog WordPress par HTTP',
);

1;

