# Movable Type (r) Open Source (C) 2006-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

# Original Copyright (c) 2004-2006 David Raynes

package MultiBlog::L10N::ja;

use strict;
use utf8;
use base 'MultiBlog::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/MultiBlog/lib/MultiBlog/Tags.pm
	'MTMultiBlog tags cannot be nested.' => 'MTMultiBlog tags mogen niet genest zijn.',
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Onbekende "mode" attribuutwaarde: [_1].  Geldige waarden zijn "loop" en "context".',

## plugins/MultiBlog/lib/MultiBlog.pm
	'The include_blogs, exclude_blogs, blog_ids and blog_id attributes cannot be used together.' => 'De include_blogs, exclude_blogs, blog_ids en blog_id attributen kunnen niet samen gebruikt worden.',
	'The attribute exclude_blogs cannot take "all" for a value.' => 'Het attribuut exclude_blogs kan niet "all" als waarde hebben.',
	'The value of the blog_id attribute must be a single blog ID.' => 'De waarde van het blog_id attribuut moet één Blog ID zijn.',
	'The value for the include_blogs/exclude_blogs attributes must be one or more blog IDs, separated by commas.' => 'De waarde voor de include_blogs/exclude_blogs attributen moet één of meer Blog ID\'s zijn, gescheiden door komma\'s.',
	'Restoring MultiBlog rebuild trigger for blog #[_1]...' => 'MultiBlog trigger voor blog #[_1] aan het terugzetten...',

## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
	'Create MultiBlog Trigger' => 'Multiblogtrigger aanmaken',

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'When' => 'Wanneer',
	'Weblog' => 'Weblog',
	'Trigger' => 'Trigger',
	'Action' => 'Actie',
	'Content Privacy' => 'Privacy inhoud',
	'Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.' => 'Geef aan of andere blogs op deze installatie inhoud van deze blog mogen publiceren.  Deze instelling krijgt voorrang op het standaard aggregatiebeleid op systeemniveau wat u kunt terugvinden in het configuratiescherm voor MultiBlog op systeemniveau.',
	'Use system default' => 'Standaard systeeminstelling gebruiken',
	'Allow' => 'Toestaan',
	'Disallow' => 'Verbieden',
	'MTMultiBlog tag default arguments' => 'MTMultiBlog tag standaard argumenten',
	'Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or \'all\' (include_blogs only) are acceptable values.' => 'Maakt het mogelijk om de MTMultiBlog tag te gebruiken zonder include_blogs/exclude_blogs attributen.  Toegestane waarden zijn BlogID\'s gescheden door komma\'s of \'all\' (enkel bij include_blogs).',
	'Include blogs' => 'Includeer blogs',
	'Exclude blogs' => 'Excludeer blogs',
	'Rebuild Triggers' => 'Rebuild-triggers',
	'Create Rebuild Trigger' => 'Rebuild-trigger aanmaken',
	'You have not defined any rebuild triggers.' => 'U heeft nog geen rebuild-triggers gedefiniëerd',

## plugins/MultiBlog/tmpl/system_config.tmpl
	'Default system aggregation policy' => 'Standaard aggregatiebeleid voor het systeem',
	'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'Cross-blog aggregatie zal standaard toegestaan zijn.  Individuele blgos kunnen via de MultiBlog instellingen op blogniveau worden ingesteld om toegang tot hun inhoud voor andere blogs te beperken.',
	'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'Cross-blog aggregatie zal standaard verboden zijn.  Individuele blgos kunnen via de MultiBlog instellingen op blogniveau worden ingesteld om toegang tot hun inhoud voor andere blogs te verlenen.',

## plugins/MultiBlog/multiblog.pl
	'MultiBlog allows you to publish content from other blogs and define publishing rules and access controls between them.' => 'Met MultiBlog kunt u inhoud van andere blogs publiceren en kunt u onderlinge publicatieregels en toegangsbeheer regelen.',
	'MultiBlog' => 'MultiBlog',
	'Create Trigger' => 'Nieuwe trigger aanmaken',
	'Search Weblogs' => 'Doorzoek weblogs',
	'When this' => 'indien dit',
	'* All blogs in this website' => '* Alle blogs onder deze website', # Translate - New
	'Select to apply this trigger to all blogs in this website.' => 'Kiezen om deze trigger toe te passen op alle blogs op deze website.', # Translate - New
	'* All websites and blogs in this system' => '* Alle websites en blogs in dit systeem', # Translate - New
	'Select to apply this trigger to all websites and blogs in this system.' => '', # Translate - New
	'saves an entry/page' => 'een bericht/pagina opslaat', # Translate - New
	'publishes an entry/page' => 'een bericht/pagina publiceert', # Translate - New
	'publishes a comment' => 'een reactie publiceert',
	'publishes a TrackBack' => 'een TrackBack publiceert',
	'rebuild indexes.' => 'indexen opnieuw opbouwt.',
	'rebuild indexes and send pings.' => 'indexen opnieuw opbouwt en pings verstuurt.',

);

1;

