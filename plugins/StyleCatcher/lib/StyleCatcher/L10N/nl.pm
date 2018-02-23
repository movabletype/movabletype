# Movable Type (r) (C) 2005-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package StyleCatcher::L10N::nl;

use strict;
use base 'StyleCatcher::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/StyleCatcher/config.yaml
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks.' => 'StyleCatcher geeft u de optie om makkelijk stijlen te bekijken en daarna toe te passen op uw blog in een paar klikken. ',
	'MT 4 Style Library' => 'MT 4 Stijlenbibliotheek',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Een verzameling stijlen compatibel met de standaardsjablonen van Movable Type 4.',
	'Styles' => 'Stijlen',
	'Moving current style to blog_meta for website...' => 'Bezig huidige stijl te verhuizen naar blog_meta voor website...', # Translate - New
	'Moving current style to blog_meta for blog...' => 'Bezig huidige stijl te verhuizen naar blog_meta voor blog...', # Translate - New

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'Uw mt-static map kon niet worden gevonden.  Gelieve \'StaticFilePath\' te configureren om verder te gaan.',
	'Permission Denied.' => 'Toestemming geweigerd.',
	'Successfully applied new theme selection.' => 'Nieuwe thema-selectie met succes toegepast.',

## plugins/StyleCatcher/lib/StyleCatcher/Library/Default.pm
	'Invalid URL: [_1]' => 'Ongeldige URL: [_1]',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Kon map [_1] niet aanmaken - Controleer of uw \'themes\' map beschrijfbaar is voor de webserver.',

## plugins/StyleCatcher/lib/StyleCatcher/Library/Local.pm
	'Failed to load StyleCatcher Library: [_1]' => 'Laden van de StyleCatcher bibliotheem mislukt: [_1]',

## plugins/StyleCatcher/lib/StyleCatcher/Util.pm
	'(Untitled)' => '(geen titel)',

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a [_1] Style' => 'Selecteer een [_1] stijl',
	'3-Columns, Wide, Thin, Thin' => '3-kolommen, breed, smal, smal',
	'3-Columns, Thin, Wide, Thin' => '3-kolommen, smal, breed, smal',
	'3-Columns, Thin, Thin, Wide' => '3-kolommen, smal, smal, breed',
	'2-Columns, Thin, Wide' => '2-kolommen, smal, breed',
	'2-Columns, Wide, Thin' => '2-kolommen, breed, smal',
	'2-Columns, Wide, Medium' => '2-kolommen, breed, medium',
	'2-Columns, Medium, Wide' => '2-kolommen, medium, breed',
	'1-Column, Wide, Bottom' => '1 kolom, breed, onderschrift',
	'None available' => 'Geen beschikbaar',
	'Applying...' => 'Wordt toegepast...',
	'Apply Design' => 'Design toepassen',
	'Error applying theme: ' => 'Fout bij toepassen thema:',
	'The selected theme has been applied, but as you have changed the layout, you will need to republish your blog to apply the new layout.' => 'Het geselecteerde thema is toegepast, maar omdat u een andere lay-out heeft gekozen, moet u eerst uw weblog opnieuw publiceren om de nieuwe lay-out zichtbaar te maken.',
	'The selected theme has been applied!' => 'Het geselecteerde thema is toegepast',
	q{Error loading themes! -- [_1]} => q{Fout bij het laden van thema's! -- [_1]},
	'Stylesheet or Repository URL' => 'Stylesheet of bibliotheek URL',
	'Stylesheet or Repository URL:' => 'Stylesheet of bibliotheek URL:',
	'Download Styles' => 'Stijlen downloaden',
	'Current theme for your weblog' => 'Huidig thema van uw weblog',
	'Current Style' => 'Huidige stijl',
	q{Locally saved themes} => q{Lokaal opgeslagen thema's},
	'Saved Styles' => 'Opgeslagen stijlen',
	'Default Styles' => 'Standaard stijlen',
	q{Single themes from the web} => q{Losse thema's van het web},
	'More Styles' => 'Meer stijlen',
	'Selected Design' => 'Geselecteerde designs',
	'Layout' => 'Lay-out',
);

1;

