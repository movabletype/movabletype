# Movable Type (r) Open Source (C) 2006-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

# Original Copyright (c) 2004-2006 David Raynes

package MultiBlog::L10N::fr;

use strict;
use utf8;
use base 'MultiBlog::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/MultiBlog/lib/MultiBlog/Tags.pm
	'MTMultiBlog tags cannot be nested.' => 'Les balises MTMultiBlog ne peuvent pas être imbriquées.',
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Valeur de l\'attribut "mode" inconnue : [_1]. Les valeurs valides sont "loop" et "context".',

## plugins/MultiBlog/lib/MultiBlog.pm
	'The include_blogs, exclude_blogs, blog_ids and blog_id attributes cannot be used together.' => 'Les attributs include_blogs, exclude_blogs, blog_ids et blog_id ne peuvent pas être utilisés ensemble.',
	'The value of the blog_id attribute must be a single blog ID.' => 'La valeur de l\'attribut blog_id doit être un ID de blog unique.',
	'The value for the include_blogs/exclude_blogs attributes must be one or more blog IDs, separated by commas.' => 'La valeur des attributs include_blogs/exclude_blogs doit être un ou plusieurs IDs de blogs, séparés par des virgules.',
	'Restoring MultiBlog rebuild trigger for blog #[_1]...' => 'Restauration du compteur de republication MutliBlog pour le blog #[_1]...',

## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
	'Create MultiBlog Trigger' => 'Créer un événement MultiBlog',

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'When' => 'Quand',
	'Weblog' => 'Blog',
	'Trigger' => 'Evénement',
	'Action' => 'Action',
	'Content Privacy' => 'Protection du contenu',
	'Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.' => 'Indiquez si les autres blogs de cette installation peuvent publier du contenu de ce blog. Ce réglage prend le dessus sur la règle d\'agrégation du système par défaut qui se trouve dans la configuration de MultiBlog pour tout le système.',
	'Use system default' => 'Utiliser la règle par défaut du système',
	'Allow' => 'Autoriser',
	'Disallow' => 'Interdire',
	'MTMultiBlog tag default arguments' => 'Arguments par défaut de la balise MTMultiBlog',
	'Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or \'all\' (include_blogs only) are acceptable values.' => 'Autorise l\'utilisation de la balise MTMultiBlog sans les attributs include_blogs/exclude_blogs. Les valeurs correctes sont une liste de BlogIDs séparés par des virgules, ou \'all\' (seulement pour include_blogs).',
	'Include blogs' => 'Inclure les blogs',
	'Exclude blogs' => 'Exclure les blogs',
	'Rebuild Triggers' => 'Événements de republication',
	'Create Rebuild Trigger' => 'Créer un événement de republication ',
	'You have not defined any rebuild triggers.' => 'Vous n\'avez défini aucun événement de republication.',

## plugins/MultiBlog/tmpl/system_config.tmpl
	'Default system aggregation policy' => 'Règle d\'agrégation du système par défaut',
	'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'L\'agrégation inter-blog sera activée par défaut. Les blogs individuels peuvent être configurés via les paramètres MultiBlog du blog en question, pour restreindre l\'accès à leur contenu par les autres blogs.',
	'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'L\'agrégation inter-blog sera désactivée par défaut. Les blogs individuels peuvent être configurés via les paramètres MultiBlog du blog en question, pour autoriser l\'accès à leur contenu par les autres blogs.',

## plugins/MultiBlog/multiblog.pl
	'MultiBlog allows you to publish content from other blogs and define publishing rules and access controls between them.' => 'Multiblog vous permet de publier du contenu d\'autres blogs et de définir des règles de publication et de droit d\'accès entre eux.',
	'MultiBlog' => 'MultiBlog',
	'Create Trigger' => 'Créer un nouvel événement',
	'Search Weblogs' => 'Rechercher les blogs',
	'When this' => 'quand ce',
	'* All blogs in this website' => '* Tous les blogs de ce site web',
	'Select to apply this trigger to all blogs in this website.' => 'Sélectionner pour appliquer cela à tous les blogs de ce site web.',
	'* All websites and blogs in this system' => '* Tous les sites web et blogs de ce systèmes',
	'Select to apply this trigger to all websites and blogs in this system.' => 'Sélectionner pour appliquer cela à tous les sites web et blog de ce système.',
	'saves an entry/page' => 'sauvegarde une note/page',
	'publishes an entry/page' => 'publie une note/page',
	'publishes a comment' => 'publie un commentaire',
	'publishes a TrackBack' => 'publie un trackback',
	'rebuild indexes.' => 'reconstruire les index.',
	'rebuild indexes and send pings.' => 'reconstruire les index et envoyer les pings.',

);

1;

