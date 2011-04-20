# WidgetManager plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
package WidgetManager::L10N::de;

use strict;
use base 'WidgetManager::L10N::en_us';
use vars qw( %Lexicon );

## plugins/WidgetManager/lib/WidgetManager/Plugin.pm
	'Can\'t find included template widget \'[_1]\'' => 'Kann in Vorlage angegebenes Widget \'[_1]\' nicht finden',
	'Cloning Widgets for blog...' => 'Klone Widgets für Blog...',

## plugins/WidgetManager/lib/WidgetManager/CMS.pm
	'Can\'t duplicate the existing \'[_1]\' Widget Manager. Please go back and enter a unique name.' => 'Die Widgetgruppe \'[_1]\' kann nicht dupliziert werden. Bitte wählen Sie einen bisher noch nicht verwendeten Namen.',
	'Main Menu' => 'Hauptmenü',
	'Widget Manager' => 'Widget Manager',
	'New Widget Set' => 'Neue Widgetgruppe',

## plugins/WidgetManager/default_widgets/monthly_archive_dropdown.mtml
	'Select a Month...' => 'Monat auswählen...',

## plugins/WidgetManager/default_widgets/category_archive_list.mtml

## plugins/WidgetManager/default_widgets/calendar.mtml
	'Monthly calendar with links to daily posts' => 'Monatskalender mit Link zu Tagesarchiven',
	'Sun' => 'So',
	'Mon' => 'Mo',
	'Tue' => 'Di',
	'Wed' => 'Mi',
	'Thu' => 'Do',
	'Fri' => 'Fr',
	'Sat' => 'Sa',

## plugins/WidgetManager/default_widgets/recent_entries.mtml

## plugins/WidgetManager/default_widgets/current_author_monthly_archive_list.mtml

## plugins/WidgetManager/default_widgets/date_based_author_archives.mtml
	'Author Yearly Archives' => 'Jährliche Autorenarchive',
	'Author Weekly Archives' => 'Wöchentliche Autorenarchive',
	'Author Daily Archives' => 'Tägliche Autorenarchive',

## plugins/WidgetManager/default_widgets/main_index_meta_widget.mtml
	'This is a custom set of widgets that are conditioned to only appear on the homepage (or "main_index"). More info: [_1]' => 'Dies ist eine spezielle Widgetgrupe, die nur auf der Startseite angezeigt wird.',

## plugins/WidgetManager/default_widgets/syndication.mtml
	'Search results matching &ldquo;<$mt:SearchString$>&rdquo;' => 'Treffer mit &bdquo;<$MTSearchString$>&ldquo;',

## plugins/WidgetManager/default_widgets/current_category_monthly_archive_list.mtml

## plugins/WidgetManager/default_widgets/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] meinte zu [_3]</a>: [_4]',

## plugins/WidgetManager/default_widgets/technorati_search.mtml
	'Technorati' => 'Technorati',
	'<a href=\'http://www.technorati.com/\'>Technorati</a> search' => '<a href=\'http://www.technorati.com/\'>Technorati</a>-Suche',
	'this blog' => 'in diesem Blog',
	'all blogs' => 'in allen Blogs',
	'Blogs that link here' => 'Blogs, die Links auf diese Seite enthalte',

## plugins/WidgetManager/default_widgets/monthly_archive_list.mtml

## plugins/WidgetManager/default_widgets/signin.mtml
	'You are signed in as ' => 'Sie sind angemeldet als',
	'You do not have permission to sign in to this blog.' => 'Sie haben keine Berechtigung zur Anmeldung an diesem Blog.',

## plugins/WidgetManager/default_widgets/pages_list.mtml

## plugins/WidgetManager/default_widgets/archive_meta_widget.mtml
	'This is a custom set of widgets that are conditioned to serve different content based upon what type of archive it is included. More info: [_1]' => 'Dies ist eine spezielle Widgetgruppe, die vom jeweiligen Archivtyp abhängige Inhalte ausgibt.',
	'Current Category Monthly Archives' => 'Monatsarchive der aktuellen Kategorie',

## plugins/WidgetManager/default_widgets/date_based_category_archives.mtml
	'Category Yearly Archives' => 'Jährliche Kategoriearchive',
	'Category Weekly Archives' => 'Wöchentliche Kategoriearchive',
	'Category Daily Archives' => 'Tägliche Kategoriearchive',

## plugins/WidgetManager/default_widgets/widgets.cfg
	'About This Page' => 'Über diese Seite',
	'Current Author Monthly Archives' => 'Monatsarchive des aktuellen Autors',
	'Calendar' => 'Kalendar',
	'Creative Commons' => 'Creative Commons',
	'Home Page Widgets' => 'Startseiten-Widgets',
	'Monthly Archives Dropdown' => 'Monatsarchive (Dropdown)',
	'Page Listing' => 'Seitenübersicht', # Translate - New # OK
	'Powered By' => 'Powered by',
	'Syndication' => 'Syndizierung',
	'Technorati Search' => 'Technorati-Suche',
	'Date-Based Author Archives' => 'Datumsbasierte Autorenarchive',
	'Date-Based Category Archives' => 'Datumsbasierte Kategoriearchive',

## plugins/WidgetManager/default_widgets/creative_commons.mtml
	'This weblog is licensed under a' => 'Dieses Weblog steht unter einer',
	'Creative Commons License' => 'Creative Commons-Lizenz',

## plugins/WidgetManager/default_widgets/about_this_page.mtml

## plugins/WidgetManager/default_widgets/author_archive_list.mtml

## plugins/WidgetManager/default_widgets/powered_by.mtml

## plugins/WidgetManager/default_widgets/tag_cloud.mtml

## plugins/WidgetManager/default_widgets/recent_assets.mtml

## plugins/WidgetManager/default_widgets/search.mtml

## plugins/WidgetManager/tmpl/edit.tmpl
	'Edit Widget Set' => 'Widgetgruppe bearbeiten',
	'Please use a unique name for this widget set.' => 'Bitte verwenden Sie für die Widgetgruppe einen eindeutigen Namen.',
	'You already have a widget set named \'[_1].\' Please use a unique name for this widget set.' => 'Eine Widgetgruppe namens \'[_1]\' ist bereits vorhanden. Bitte wählen Sie einen Namen, der noch nicht verwendet wurde.',
	'Your changes to the Widget Set have been saved.' => 'Änderungen gespeichert.',
	'Set Name' => 'Gruppenname',
	'Drag and drop the widgets you want into the Installed column.' => 'Ziehen Sie die Widgets, die angezeigt werden sollen, in die Spalte \'Installierte Widgets\'. Soll ein Widget nicht mehr angezeigt werden, schieben Sie es zurück in die Spalte \'Verfügbare Widgets\'.',
	'Installed Widgets' => 'Installierte Widgets',
	'Available Widgets' => 'Verfügbare Widgets',
	'Save changes to this widget set (s)' => 'Widgetänderungen speichern (s)',

## plugins/WidgetManager/tmpl/list.tmpl
	'Widget Sets' => 'Widgetgruppen',
	'Widget Set' => 'Widgetgruppe',
	'Delete selected Widget Sets (x)' => 'Gewählte Widget-Gruppen löschen',
	'Helpful Tips' => 'Nützliche Hinweise',
	'To add a widget set to your templates, use the following syntax:' => 'Um eine Widgetgruppe in eine Vorlage einzubinden, verwenden Sie folgenden Code:',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Name der Widgetgruppe&quot;$&gt;</strong>',
	'Edit Widget Templates' => 'Widgetvorlagen bearbeiten',
	'Your changes to the widget set have been saved.' => 'Änderungen gespeichert.',
	'You have successfully deleted the selected widget set(s) from your blog.' => 'Widget-Gruppe(n) erfolgreich gelöscht.',
	'Create Widget Set' => 'Widgetgruppe anlegen',
	'No Widget Sets could be found.' => 'Keine Widgetgruppen gefunden.',

## plugins/WidgetManager/WidgetManager.pl
	'Maintain your blog\'s widget content using a handy drag and drop interface.' => 'Widgets einfach mit der Maus zusammenstellen',
	'Widgets' => 'Widgets',

);
1;

