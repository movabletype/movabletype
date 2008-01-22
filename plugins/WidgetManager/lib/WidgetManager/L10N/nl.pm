# WidgetManager plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
package WidgetManager::L10N::nl;

use strict;
use base 'WidgetManager::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/WidgetManager/lib/WidgetManager/Plugin.pm
	'Can\'t find included template widget \'[_1]\'' => 'Kan geïncludeerd sjabloonwidget \'[_1]\' niet vinden',
	'Cloning Widgets for blog...' => 'Bezig widgets te klonen van blog...',

## plugins/WidgetManager/lib/WidgetManager/CMS.pm
	'Can\'t duplicate the existing \'[_1]\' Widget Manager. Please go back and enter a unique name.' => 'Kan de bestaande \'[_1]\' WidgetManager niet dupliceren. Gelieve terug te gaan en een unieke naam in te geven.',
	'Main Menu' => 'Hoofdmenu',
	'Widget Manager' => 'Widget Manager',
	'New Widget Set' => 'Nieuwe widgetset',

## plugins/WidgetManager/default_widgets/monthly_archive_dropdown.mtml
	'Select a Month...' => 'Selecteer een maand...',

## plugins/WidgetManager/default_widgets/category_archive_list.mtml

## plugins/WidgetManager/default_widgets/calendar.mtml
	'Monthly calendar with links to daily posts' => 'Maandkalender met links naar de berichten van alle dagen',
	'Sun' => 'Zon',
	'Mon' => 'Maa',
	'Tue' => 'Din',
	'Wed' => 'Woe',
	'Thu' => 'Don',
	'Fri' => 'Vri',
	'Sat' => 'Zat',

## plugins/WidgetManager/default_widgets/recent_entries.mtml

## plugins/WidgetManager/default_widgets/current_author_monthly_archive_list.mtml

## plugins/WidgetManager/default_widgets/date_based_author_archives.mtml
	'Author Yearly Archives' => 'Archieven per auteur per jaar',
	'Author Weekly Archives' => 'Archieven per auteur per week',
	'Author Daily Archives' => 'Archieven per auteur per dag',

## plugins/WidgetManager/default_widgets/main_index_meta_widget.mtml
	'This is a custom set of widgets that are conditioned to only appear on the homepage (or "main_index"). More info: [_1]' => 'Dit is een gepersonaliseerde set widgets die enkel op de hoofpagina (of "hoofdindex") verschijnen.  Meer info: [_1]',

## plugins/WidgetManager/default_widgets/syndication.mtml
	'Search results matching &ldquo;<$mt:SearchString$>&rdquo;' => 'Zoekresultaten die overeen komen met &ldquo;<$mt:SearchString$>&rdquo;',

## plugins/WidgetManager/default_widgets/current_category_monthly_archive_list.mtml

## plugins/WidgetManager/default_widgets/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] reageerde op [_3]</a>: [_4]',

## plugins/WidgetManager/default_widgets/technorati_search.mtml
	'Technorati' => 'Technorati',
	'<a href=\'http://www.technorati.com/\'>Technorati</a> search' => 'Zoek op <a href=\'http://www.technorati.com/\'>Technorati</a>',
	'this blog' => 'deze weblog',
	'all blogs' => 'alle blogs',
	'Blogs that link here' => 'Blogs die hierheen linken',

## plugins/WidgetManager/default_widgets/monthly_archive_list.mtml

## plugins/WidgetManager/default_widgets/signin.mtml
	'You are signed in as ' => 'U bent aangemeld als',
	'You do not have permission to sign in to this blog.' => 'U heeft geen toestemming om aan te melden op deze weblog',

## plugins/WidgetManager/default_widgets/pages_list.mtml

## plugins/WidgetManager/default_widgets/archive_meta_widget.mtml
	'This is a custom set of widgets that are conditioned to serve different content based upon what type of archive it is included. More info: [_1]' => 'Dit is een set widgets die andere inhoud tonen gebaseerd op het archieftype waarin ze voorkomen.  Meer info: [_1]',
	'Current Category Monthly Archives' => 'Archieven van de huidige categorie per maand',

## plugins/WidgetManager/default_widgets/date_based_category_archives.mtml
	'Category Yearly Archives' => 'Archieven per categorie per jaar',
	'Category Weekly Archives' => 'Archieven per categorie per week',
	'Category Daily Archives' => 'Archieven per categorie per dag',

## plugins/WidgetManager/default_widgets/widgets.cfg
	'About This Page' => 'Over deze pagina',
	'Current Author Monthly Archives' => 'Archieven per maand van de huidige auteur',
	'Calendar' => 'Kalender',
	'Creative Commons' => 'Creative Commons',
	'Home Page Widgets' => 'Hoofdpaginawidgets',
	'Monthly Archives Dropdown' => 'Uitklapmenu archieven per maand',
	'Page Listing' => 'Overzicht pagina\'s', # Translate - New
	'Powered By' => 'Aangedreven door',
	'Syndication' => 'Syndicatie',
	'Technorati Search' => 'Technorati zoekformulier',
	'Date-Based Author Archives' => 'Datum-gebaseerde auteursactieven',
	'Date-Based Category Archives' => 'Datum-gebaseerde categorie-archieven',

## plugins/WidgetManager/default_widgets/creative_commons.mtml
	'This weblog is licensed under a' => 'Deze weblog valt onder een licentie van het type',
	'Creative Commons License' => 'Creative Commons Licentie',

## plugins/WidgetManager/default_widgets/about_this_page.mtml

## plugins/WidgetManager/default_widgets/author_archive_list.mtml

## plugins/WidgetManager/default_widgets/powered_by.mtml

## plugins/WidgetManager/default_widgets/tag_cloud.mtml

## plugins/WidgetManager/default_widgets/recent_assets.mtml

## plugins/WidgetManager/default_widgets/search.mtml

## plugins/WidgetManager/tmpl/edit.tmpl
	'Edit Widget Set' => 'Widgetset bewerken',
	'Please use a unique name for this widget set.' => 'Gelieve een unieke naam voor deze widgetset te gebruiken',
	'You already have a widget set named \'[_1].\' Please use a unique name for this widget set.' => 'U heeft al een widgetste met de naam \'[_1]\'.  Gelieve een unieke naam te gebruiken voor deze widgetset.',
	'Your changes to the Widget Set have been saved.' => 'Uw wijzigingen aan de widgetset zijn opgeslagen.',
	'Set Name' => 'Naam instellen',
	'Drag and drop the widgets you want into the Installed column.' => 'Klik en sleep de widgets die u wenst in de \'Geïnstalleerde widgets\' kolom.',
	'Installed Widgets' => 'Geïnstalleerde widgets',
	'Available Widgets' => 'Beschikbare widgets',
	'Save changes to this widget set (s)' => 'Wijzignen aan deze widgetset opslaan (s)',

## plugins/WidgetManager/tmpl/list.tmpl
	'Widget Sets' => 'Widgetsets',
	'Widget Set' => 'Widgetset',
	'Delete selected Widget Sets (x)' => 'Geselecteerde widgetsets verwijderen (x)',
	'Helpful Tips' => 'Nuttige tips',
	'To add a widget set to your templates, use the following syntax:' => 'Om een widgetset aan uw sjablonen toe te voegen, gebruikt u volgende syntax:',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Naam van de widgetset&quot;$&gt;</strong>',
	'Edit Widget Templates' => 'Bewerk widgetsjablonen',
	'Your changes to the widget set have been saved.' => 'Uw wijzigingen aan de widgetset werden opgeslagen.',
	'You have successfully deleted the selected widget set(s) from your blog.' => 'U heeft met succes de geselecteerde widgetset(s) van uw weblog verwijderd.',
	'Create Widget Set' => 'Widgetset aanmaken',
	'No Widget Sets could be found.' => 'Er werden geen widgetsets gevonden.',

## plugins/WidgetManager/WidgetManager.pl
	'Maintain your blog\'s widget content using a handy drag and drop interface.' => 'Beheer de widget-inhoud van uw weblog via een handige klik-en-sleep interface.',
	'Widgets' => 'Widgets',
);
1;

