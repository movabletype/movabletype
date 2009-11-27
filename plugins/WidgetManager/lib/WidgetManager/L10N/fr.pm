# Plugin Gestionnaires de Widget pour Movable Type
# Auteur: Byrne Reese, Six Apart (http://www.sixapart.com)
# Propos� sous License Artistique
#
package WidgetManager::L10N::fr;

use strict;
use utf8;
use base 'WidgetManager::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/WidgetManager/WidgetManager.pl
	'Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.' => 'Widget Manager version 1.1; Cette version est destinée à la mise à jour des données des versions plus anciennes de Widget Manager, délivré avec Movable Type. Aucune autre fonction n\'est incluse. Vous pouvez supprimer ce plugin après avoir installé/mis à jour Movable Type.',
	'Moving storage of Widget Manager [_2]...' => 'Déplacement de l\'emplacement du gestionnaire de wiget [_2]...',
    );
1;

