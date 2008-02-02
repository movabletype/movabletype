# Movable Type (r) Open Source (C) 2005-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package StyleCatcher::L10N::de;

use strict;
use base 'StyleCatcher::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'Ihr mt-static-Ordner konnte nicht gefunden werden. Bitte konfigurieren Sie \'StaticFilePath\' um fortzufahren.',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Konnte den Ordner [_1] nicht anlegen. Stellen Sie sicher, daß der Webserver Schreibrechte auf dem \'themes\'-Ordner hat.',
	'Error downloading image: [_1]' => 'Fehler beim Herunterladen einer Bilddatei: [_1]',
	'Successfully applied new theme selection.' => 'Neue Themenauswahl erfolgreich angewendet.',
	'Invalid URL: [_1]' => 'Ungültige URL: [_1]',

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a Style' => 'Design wählen',
	'3-Columns, Wide, Thin, Thin' => 'Dreispaltig: breit - schmal - schmal',
	'3-Columns, Thin, Wide, Thin' => 'Dreispaltig: schmal - breit - schmal',
	'2-Columns, Thin, Wide' => 'Zweispaltig: schmal - breit',
	'2-Columns, Wide, Thin' => 'Zweispaltig: breit - schmal',
	'None available' => 'Keine verfügbar',
	'Applying...' => 'Wende an...',
	'Apply Design' => 'Design übernehmen',
	'Error applying theme: ' => 'Fehler bei der Übernahme des Themas:',
	'The selected theme has been applied, but as you have changed the layout, you will need to republish your blog to apply the new layout.' => 'Das gewählte Thema wurde übernommen. Da das Layout geändert wurde, veröffentlichen Sie das Blog bitte erneut, um die Änderungen wirksam werden zu lassen.',
	'The selected theme has been applied!' => 'Das Thema wurde übernommen!',
	'Error loading themes! -- [_1]' => 'Fehler beim Laden der Themen -- [_1]',
	'Stylesheet or Repository URL' => 'URL des Stylesheets oder der Sammlung',
	'Stylesheet or Repository URL:' => 'URL des Stylesheets oder der Sammlung:',
	'Download Styles' => 'Designs herunterladen',
	'Current theme for your weblog' => 'Aktuelles Theme Ihres Weblogs',
	'Current Style' => 'Derzeitige Design',
	'Locally saved themes' => 'Lokal gespeicherte Themes',
	'Saved Styles' => 'Gespeicherte Designs',
	'Default Styles' => 'Standarddesigns',
	'Single themes from the web' => 'Einzelne Themes aus dem Web',
	'More Styles' => 'Weitere Designs',
	'Selected Design' => 'Gewähltes Design',
	'Layout' => 'Layout',

## plugins/StyleCatcher/stylecatcher.pl
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.' => 'Mit StyleCatchter können Sie spielend leicht neue Designvorlagen für Ihre Blogs finden und mit wenigen Klicks direkt aus dem Internet installieren. Mehr dazu auf der <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type Styles</a>-Seite.',
	'MT 4 Style Library' => 'MT 4-Designs',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Mit den Standardvorlagen von MT 3.3+  kompatible Designvorlagen',
	'MT 3 Style Library' => 'MT 3-Design',
	'A collection of styles compatible with Movable Type 3.3+ default templates.' => 'Mit den Standardvorlagen von MT 3.3+  kompatible Designvorlagen',
	'Styles' => 'Designs',
	'2-Columns, Wide, Medium' => 'Zweispaltig: breit - mittel', # Translate - New # OK
	);

1;

