 # WidgetManager plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
package WidgetManager::L10N::es;

use strict;
use utf8;
use base 'WidgetManager::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/WidgetManager/WidgetManager.pl
	'Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.' => 'Administrador de Widgets versión 1.1; Esta versión de la extensión actualiza los datos de la versiones antiguas del Adminstrador de Widgets que venía con Movable Type al esquema interno de Movable Type. No se han incluído otras características. Puede borrar esta extensión sin problemas después de instalar o actualizar Movable Type.',
	'Moving storage of Widget Manager [_2]...' => 'Trasladando los datos del Administrador de Widgets [_2]...',
);
1;

