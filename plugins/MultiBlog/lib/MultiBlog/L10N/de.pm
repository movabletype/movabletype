# Movable Type (r) Open Source (C) 2006-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

# Original Copyright (c) 2004-2006 David Raynes

package MultiBlog::L10N::de;

use strict;
use utf8;
use base 'MultiBlog::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/MultiBlog/lib/MultiBlog/Tags.pm
	'MTMultiBlog tags cannot be nested.' => 'MTMultiBlog-Tags können nicht veschachtelt werden.',
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Ungültiges "mode"-Attribut [_1]. Gültige Werte sind "loop" und "context".',

## plugins/MultiBlog/lib/MultiBlog.pm
	'The include_blogs, exclude_blogs, blog_ids and blog_id attributes cannot be used together.' => 'Die Attribute include_blogs, exclude_blog, blog_ids und blog_id können nicht gemeinsam verwendet werden.',
	'The value of the blog_id attribute must be a single blog ID.' => 'blog_id erfordert genau eine Blog-ID als Wert.',
	'The value for the include_blogs/exclude_blogs attributes must be one or more blog IDs, separated by commas.' => 'include_blogs und exclude_blogs erfordern mindestens eine Blog-ID als Wert. Mehrere IDs sind per Kommata zu trennen.',
	'Restoring MultiBlog rebuild trigger for blog #[_1]...' => 'Stelle MultiBlog-Trigger für Blog #[_1] wieder her....',

## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
	'Create MultiBlog Trigger' => 'MultiBlog-Auslöser definieren',

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'When' => 'Wenn in',
	'Weblog' => 'Weblog',
	'Trigger' => 'Auslöser',
	'Action' => 'Aktion',
	'Content Privacy' => 'Externer Zugriff auf Inhalte',
	'Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.' => 'Hier können Sie festlegen, ob andere Blogs dieser Movable Type-Installation die Inhalte dieses Blogs verwenden dürfen oder nicht. Diese Einstellung hat Vorrang vor der globalen MultiBlog-Konfiguration.',
	'Use system default' => 'System-Voreinstellung verwenden',
	'Allow' => 'Aggregation zulassen',
	'Disallow' => 'Aggregation nicht zulassen',
	'MTMultiBlog tag default arguments' => 'MultiBlog- Standardargumente',
	'Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or \'all\' (include_blogs only) are acceptable values.' => 'Ermöglicht die Verwendung von MTMultiBlog ohne include_blogs- und exclude_blogs-Attribute. Erlaubte Werte sind \'all\' oder per Kommata getrennte BlogIDs.',
	'Include blogs' => 'Einzuschließende Blogs',
	'Exclude blogs' => 'Auszuschließende Blogs',
	'Rebuild Triggers' => 'Auslöser für Neuaufbau',
	'Create Rebuild Trigger' => 'Auslöser für Neuaufbau definieren',
	'You have not defined any rebuild triggers.' => 'Es sind keine Auslöser definiert.',

## plugins/MultiBlog/tmpl/system_config.tmpl
	'Default system aggregation policy' => 'Systemwite Aggregations- Voreinstellung',
	'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'Verwendung von Bloginhalten in anderen Blogs dieser Installation systemweit erlauben. Auf Blog-Ebene gemachte Einstellungen sind vorranging, so daß diese Voreinstellung für einzelne Blogs außer Kraft gesetzt werden kann.',
	'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'Verwendung von Bloginhalten in anderen Blogs dieser Installation systemweit nicht erlauben. Auf Blog-Ebene gemachte Einstellungen sind vorranging, so daß diese Voreinstellung für einzelne Blogs außer Kraft gesetzt werden kann.',

## plugins/MultiBlog/multiblog.pl
	'MultiBlog allows you to publish content from other blogs and define publishing rules and access controls between them.' => 'Mit MultiBlog können Sie Inhalte anderer Blogs übernehmen und die dazu erforderlichen Veröffentlichungsregeln definieren.',
	'MultiBlog' => 'MultiBlog',
	'Create Trigger' => 'Neuen Auslöser anlegen',
	'Search Weblogs' => 'Weblogs suchen',
	'When this' => 'Wenn',
	'* All blogs in this website' => '* Alle Blogs dieser Website',
	'Select to apply this trigger to all blogs in this website.' => 'Diesen Trigger auf alle Blogs dieser Website anwenden',
	'* All websites and blogs in this system' => '* Alle Websites und Blogs dieser Installation',
	'Select to apply this trigger to all websites and blogs in this system.' => 'Diesen Trigger auf alle Websites und Blogs dieser Installation anwenden',
	'saves an entry/page' => 'ein Eintrag / eine Seite gespeichert wird',
	'publishes an entry/page' => 'ein Eintrag / eine Seite veröffentlicht wird',
	'publishes a comment' => 'ein Kommentar veröffentlicht wird',
	'publishes a TrackBack' => 'ein TrackBack veröffentlicht wird',
	'rebuild indexes.' => 'Indizes neu aufbauen.',
	'rebuild indexes and send pings.' => 'Indizes neu aufbauen und Pings senden.',

);

1;

