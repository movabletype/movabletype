# Movable Type (r) (C) 2006-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

# Original Copyright (c) 2004-2006 David Raynes

package MultiBlog::L10N::fr;

use strict;
use warnings;
use utf8;
use base 'MultiBlog::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/MultiBlog/multiblog.pl
	q{MultiBlog allows you to publish content from other blogs and define publishing rules and access controls between them.} => q{Multiblog vous permet de publier du contenu d'autres blogs et de définir des règles de publication et de droit d'accès entre eux.},
	'MultiBlog' => 'MultiBlog',
	'Create Trigger' => 'Créer un nouveau déclencheur',
	'Search Weblogs' => 'Rechercher les blogs',
	'When this' => 'Quand',
	'(All blogs in this website)' => '(Tous les blogs de ce site web)',
	'Select to apply this trigger to all blogs in this website.' => 'Sélectionner pour appliquer ce déclencheur à tous les blogs de ce site web.',
	'(All websites and blogs in this system)' => '(Tous les sites web et blogs de ce système)',
	'Select to apply this trigger to all websites and blogs in this system.' => 'Sélectionner pour appliquer ce déclencheur à tous les sites web et blog de ce système.',
	'saves an entry/page' => 'une note/page est sauvegardée',
	'publishes an entry/page' => 'une note/page est publiée',
	'unpublishes an entry/page' => 'une note/page est dépubliée', # Translate - New
	'publishes a comment' => 'un commentaire est publié',
	'publishes a TrackBack' => 'un Trackback est publié',
	'rebuild indexes.' => 'reconstruire les index.',
	'rebuild indexes and send pings.' => 'reconstruire les index et envoyer les pings.',
	'Updating the MultiBlog trigger cache...' => 'Mise à jour du cache des déclencheurs MultiBlog...',

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'When' => 'Quand',
	'Trigger' => 'Événement',
	'Action' => 'Action',
	'Content Privacy' => 'Protection du contenu',
	q{Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.} => q{Indiquez si les autres blogs de cette installation peuvent publier du contenu de ce blog. Ce réglage prend le dessus sur la règle d'agrégation du système par défaut qui se trouve dans la configuration de MultiBlog pour tout le système.},
	'Use system default' => 'Utiliser la règle par défaut du système',
	'Allow' => 'Autoriser',
	'Disallow' => 'Interdire',
	'MTMultiBlog tag default arguments' => 'Arguments par défaut de la balise MTMultiBlog',
	q{Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or 'all' (include_blogs only) are acceptable values.} => q{Autorise l'utilisation de la balise MTMultiBlog sans les attributs include_blogs/exclude_blogs. Les valeurs correctes sont une liste de BlogIDs séparés par des virgules, ou 'all' (seulement pour include_blogs).},
	'Include blogs' => 'Inclure les blogs',
	'Exclude blogs' => 'Exclure les blogs',
	'Rebuild Triggers' => 'Événements de republication',
	'Create Rebuild Trigger' => 'Créer un événement de republication ',
	q{You have not defined any rebuild triggers.} => q{Vous n'avez défini aucun événement de republication.},

## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
	'Create MultiBlog Trigger' => 'Créer un événement MultiBlog',

## plugins/MultiBlog/tmpl/system_config.tmpl
	q{Default system aggregation policy} => q{Règle d'agrégation du système par défaut},
	q{Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.} => q{L'agrégation inter-blogs sera activée par défaut. Les blogs individuels peuvent être configurés via les paramètres MultiBlog du blog en question, pour restreindre l'accès à leur contenu par les autres blogs.},
	q{Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.} => q{L'agrégation inter-blogs sera désactivée par défaut. Les blogs individuels peuvent être configurés via les paramètres MultiBlog du blog en question, pour autoriser l'accès à leur contenu par les autres blogs.},

);

1;

