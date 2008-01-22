# Movable Type (r) Open Source (C) 2005-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package StyleCatcher::L10N::nl;

use strict;
use base 'StyleCatcher::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'Uw mt-static map kon niet worden gevonden.  Gelieve \'StaticFilePath\' te configureren om verder te gaan.',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Kon map [_1] niet aanmaken - Controleer of uw \'themes\' map beschrijfbaar is voor de webserver.',
	'Error downloading image: [_1]' => 'Fout bij downloaden afbeelding: [_1]',
	'Successfully applied new theme selection.' => 'Nieuwe thema-selectie met succes toegepast.',
	'Invalid URL: [_1]' => 'Ongeldige URL: [_1]',

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a Style' => 'Selecteer een stijl',
	'3-Columns, Wide, Thin, Thin' => '3-kolommen, breed, smal, smal',
	'3-Columns, Thin, Wide, Thin' => '3-kolommen, smal, breed, smal',
	'2-Columns, Thin, Wide' => '2-kolommen, smal, breed',
	'2-Columns, Wide, Thin' => '2-kolommen, breed, smal',
	'2-Columns, Wide, Medium' => '2-kolommen, breed, medium', # Translate - New
	'None available' => 'Geen beschikbaar',
	'Applying...' => 'Wordt toegepast...',
	'Apply Design' => 'Design toepassen',
	'Error applying theme: ' => 'Fout bij toepassen thema:',
	'The selected theme has been applied, but as you have changed the layout, you will need to republish your blog to apply the new layout.' => 'Het geselecteerde thema is toegepast, maar omdat u een andere lay-out heeft gekozen, moet u eerst uw weblog opnieuw publiceren om de nieuwe lay-out zichtbaar te maken.',
	'The selected theme has been applied!' => 'Het geselecteerde thema is toegepast',
	'Error loading themes! -- [_1]' => 'Fout bij het laden van thema\'s! -- [_1]',
	'Stylesheet or Repository URL' => 'Stylesheet of bibliotheek URL',
	'Stylesheet or Repository URL:' => 'Stylesheet of bibliotheek URL:',
	'Download Styles' => 'Stijlen downloaden',
	'Current theme for your weblog' => 'Huidig thema van uw weblog',
	'Current Style' => 'Huidige stijl',
	'Locally saved themes' => 'Lokaal opgeslagen thema\'s',
	'Saved Styles' => 'Opgeslagen stijlen',
	'Default Styles' => 'Standaard stijlen',
	'Single themes from the web' => 'Losse thema\'s van het web',
	'More Styles' => 'Meer stijlen',
	'Selected Design' => 'Geselecteerde designs',
	'Layout' => 'Lay-out',

## plugins/StyleCatcher/stylecatcher.pl
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.' => 'Met StyleCatcher kunt u makkelijk een keuze maken tussen stijlen om ze daarna op uw blog toe te passen in een paar klikken.  Om meer te weten over Movable Type stijlen, of om een bron te vinden van nog meer stijlen, bezoek de <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> pagina.',
	'MT 4 Style Library' => 'MT 4 Stijlenbibliotheek',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Een verzameling stijlen compatibel met de standaardsjablonen van Movable Type 4.',
	'MT 3 Style Library' => 'MT 3 Stijlenbibliotheek',
	'A collection of styles compatible with Movable Type 3.3+ default templates.' => 'Een verzameling stijlen compatibel met de standaardsjablonen van Movable Type 3.3+.',
	'Styles' => 'Stijlen',

);

1;

