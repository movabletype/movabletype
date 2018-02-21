# Movable Type (r) (C) 2006-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

# Original Copyright (c) 2004-2006 David Raynes

package MultiBlog::L10N::nl;

use strict;
use utf8;
use base 'MultiBlog::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/MultiBlog/multiblog.pl
	'MultiBlog allows you to publish content from other blogs and define publishing rules and access controls between them.' => 'Met MultiBlog kunt u inhoud van andere blogs publiceren en kunt u onderlinge publicatieregels en toegangsbeheer regelen.',
	'MultiBlog' => 'MultiBlog',
	'Create Trigger' => 'Nieuwe trigger aanmaken',
	'Search Weblogs' => 'Doorzoek weblogs',
	'When this' => 'indien dit',
	'(All blogs in this website)' => '(Alle blogs onder deze website)',
	'Select to apply this trigger to all blogs in this website.' => 'Kiezen om deze trigger toe te passen op alle blogs op deze website.',
	'(All websites and blogs in this system)' => '(Alle websites en blogs in dit systeem)',
	'Select to apply this trigger to all websites and blogs in this system.' => 'Selecteer dit om deze trigger toe te passen op alle websites en blogs in dit systeem',
	'saves an entry/page' => 'een bericht/pagina opslaat',
	'publishes an entry/page' => 'een bericht/pagina publiceert',
	'unpublishes an entry/page' => 'een bericht/pagina ontpubliceert', # Translate - New
	'publishes a comment' => 'een reactie publiceert',
	'publishes a TrackBack' => 'een TrackBack publiceert',
	'rebuild indexes.' => 'indexen opnieuw opbouwt.',
	'rebuild indexes and send pings.' => 'indexen opnieuw opbouwt en pings verstuurt.',
	'Updating the MultiBlog trigger cache...' => 'Bezig de trigger cache van MultiBlog bij te werken',

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'When' => 'Wanneer',
	'Trigger' => 'Trigger',
	'Action' => 'Actie',
	'Content Privacy' => 'Privacy inhoud',
	'Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.' => 'Geef aan of andere blogs op deze installatie inhoud van deze blog mogen publiceren.  Deze instelling krijgt voorrang op het standaard aggregatiebeleid op systeemniveau wat u kunt terugvinden in het configuratiescherm voor MultiBlog op systeemniveau.',
	'Use system default' => 'Standaard systeeminstelling gebruiken',
	'Allow' => 'Toestaan',
	'Disallow' => 'Verbieden',
	'MTMultiBlog tag default arguments' => 'MTMultiBlog tag standaard argumenten',
	q{Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or 'all' (include_blogs only) are acceptable values.} => q{Maakt het mogelijk om de MTMultiBlog tag te gebruiken zonder include_blogs/exclude_blogs attributen.  Toegestane waarden zijn BlogID's gescheden door komma's of 'all' (enkel bij include_blogs).},
	'Include blogs' => 'Includeer blogs',
	'Exclude blogs' => 'Excludeer blogs',
	'Rebuild Triggers' => 'Rebuild-triggers',
	'Create Rebuild Trigger' => 'Rebuild-trigger aanmaken',
	'You have not defined any rebuild triggers.' => 'U heeft nog geen rebuild-triggers gedefiniëerd',

## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
	'Create MultiBlog Trigger' => 'Multiblogtrigger aanmaken',

## plugins/MultiBlog/tmpl/system_config.tmpl
	'Default system aggregation policy' => 'Standaard aggregatiebeleid voor het systeem',
	'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'Cross-blog aggregatie zal standaard toegestaan zijn.  Individuele blgos kunnen via de MultiBlog instellingen op blogniveau worden ingesteld om toegang tot hun inhoud voor andere blogs te beperken.',
	'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'Cross-blog aggregatie zal standaard verboden zijn.  Individuele blgos kunnen via de MultiBlog instellingen op blogniveau worden ingesteld om toegang tot hun inhoud voor andere blogs te verlenen.',

);

1;

