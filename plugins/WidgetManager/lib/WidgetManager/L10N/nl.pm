# WidgetManager plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
package WidgetManager::L10N::nl;

use strict;
use utf8;
use base 'WidgetManager::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/WidgetManager/WidgetManager.pl
	'Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.' => 'Widget Manager versie 1.1: Deze versie van de plugin dient om data van de oudere versie van Widget Manager die met Movable Type werd meegeleverd over te zetten naar de kern van Movable Type.  Er zitten geen andere opties in.  Deze plugin kan zonder problemen verwijderd worden na de installatie/upgrade van Movable Type.',
	'Moving storage of Widget Manager [_2]...' => 'Opslag voor widget manager [_2] aan het verhuizen...',

);
1;

