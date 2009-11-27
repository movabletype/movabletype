# WidgetManager plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
package WidgetManager::L10N::de;

use strict;
use utf8;
use base 'WidgetManager::L10N::en_us';
use vars qw( %Lexicon );
%Lexicon = (
## plugins/WidgetManager/WidgetManager.pl
	'Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.' => 'Widget Manager 1.1 - Diese Version des Plugins dient ausschließlich dazu, Daten älterer Versionen auf das Movable Type Core-Schema zu aktualisieren. Sie können diese Plugin daher nach Installation bzw. Aktualisierung von Movable Type gefahrlos löschen.',
	'Moving storage of Widget Manager [_2]...' => 'Verschiebe Speicherort des Widget Managers [_2]...',

);
1;

