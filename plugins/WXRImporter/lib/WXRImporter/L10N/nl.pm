# WXRImporter plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
package WXRImporter::L10N::nl;

use strict;
use base 'WXRImporter::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/WXRImporter/lib/WXRImporter/Import.pm

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'Bestand is niet in WXR formaat.',
	'Creating new tag (\'[_1]\')...' => 'Nieuwe tag aan het aanmaken (\'[_1]\')...', # Translate - New
	'Saving tag failed: [_1]' => 'Tag opslaan mislukt: [_1]', # Translate - New
	'Duplicate asset (\'[_1]\') found.  Skipping.' => 'Dubbel mediabestand (\'[_1]\') gevonden.  Wordt overgeslagen.',
	'Saving asset (\'[_1]\')...' => 'Bezig met opslaan mediabestand (\'[_1]\')...',
	' and asset will be tagged (\'[_1]\')...' => ' en mediabestand zal getagd worden als (\'[_1]\')...',
	'Duplicate entry (\'[_1]\') found.  Skipping.' => 'Dubbel bericht (\'[_1]\') gevonden.  Wordt overgeslagen.',
	'Saving page (\'[_1]\')...' => 'Pagina aan het opslaan (\'[_1]\')...',

## plugins/WXRImporter/tmpl/options.tmpl
	'Before you import WordPress posts to Movable Type, we recommend that you <a href=\'[_1]\'>configure your blog\'s publishing paths</a> first.' => '\n	Voor u WordPress berichten importeert in Movable Type, raden we aan om eerst <a href=\'[_1]\'>de publicatiepaden van uw weblog in te stellen</a>.',
	'Upload path for this WordPress blog' => 'Uploadpad voor deze WordPress blog',
	'Replace with' => 'Vervangen door',
	'Download attachments' => 'Attachments downloaden',
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'Vereist het gebruik van een cronjob om attachments van een WordPress blog te downloaden op de achtergrond.',
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'Attachments (afbeeldingen en bestanden) downloaden van de geïmporteerde WordPress blog.',

## plugins/WXRImporter/WXRImporter.pl
	'Import WordPress exported RSS into MT.' => 'Importeer RSS geëxporteerd uit WordPress in MT.',
	'WordPress eXtended RSS (WXR)' => 'WordPress eXtended RSS (WXR)',
	'Download WP attachments via HTTP.' => 'WP attachments downloaden via HTTP.',
);

1;

