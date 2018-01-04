# Movable Type (r) (C) 2005-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package StyleCatcher::L10N::de;

use strict;
use base 'StyleCatcher::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/StyleCatcher/config.yaml
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks.' => 'Mit StyleCatchter können Sie spielend leicht neue Designvorlagen für Ihre Blogs finden und mit wenigen Klicks direkt installieren. ',
	'MT 4 Style Library' => 'MT 4-Designs',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Mit den Standardvorlagen von MT 3.3+  kompatible Designvorlagen',
	'Styles' => 'Designs',
	'Moving current style to blog_meta for website...' => 'Verschiebe aktuelle Designvorlage der Website nach blog_meta...', # Translate - New # OK
	'Moving current style to blog_meta for blog...' => 'Verschiebe aktuelle Designvorlage des Blogs nach blog_meta...', # Translate - New # OK

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'Ihr mt-static-Ordner konnte nicht gefunden werden. Bitte konfigurieren Sie \'StaticFilePath\' um fortzufahren.',
	'Permission Denied.' => 'Zugriff verweigert.',
	'Successfully applied new theme selection.' => 'Neue Themenauswahl erfolgreich angewendet.',

## plugins/StyleCatcher/lib/StyleCatcher/Library/Default.pm
	'Invalid URL: [_1]' => 'Ungültige URL: [_1]',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Konnte den Ordner [_1] nicht anlegen. Stellen Sie sicher, daß der Webserver Schreibrechte auf dem \'themes\'-Ordner hat.',

## plugins/StyleCatcher/lib/StyleCatcher/Library/Local.pm
	'Failed to load StyleCatcher Library: [_1]' => 'Konnte StyleCatcher-Bibliothek nicht laden: [_1]',

## plugins/StyleCatcher/lib/StyleCatcher/Util.pm
	'(Untitled)' => '(ohne Überschrift)',

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a [_1] Style' => '[_1]-Stil wählen',
	'3-Columns, Wide, Thin, Thin' => 'Dreispaltig: breit - schmal - schmal',
	'3-Columns, Thin, Wide, Thin' => 'Dreispaltig: schmal - breit - schmal',
	'3-Columns, Thin, Thin, Wide' => 'Dreispaltig: schmal - schmal - breit',
	'2-Columns, Thin, Wide' => 'Zweispaltig: schmal - breit',
	'2-Columns, Wide, Thin' => 'Zweispaltig: breit - schmal',
	'2-Columns, Wide, Medium' => 'Zweispaltig: breit - mittel',
	'2-Columns, Medium, Wide' => 'Zweispaltig: mittel - breit',
	'1-Column, Wide, Bottom' => 'Einspaltig: breit - Fußzeile',
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


);

1;

