# GoogleSearch plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id: ja.pm 30952 2006-06-13 09:20:43Z jallen $

package GoogleSearch::L10N::es;

use strict;
use base 'GoogleSearch::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
    'Google API Key:' => 'Contraseña para la API de Google:',
    'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.' => 'Si desea utilizar cualquier funcionalidad de la API de Google, deberá disponer de la contraseña correspondiente. Cópiela y péguela aquí.',
    'Adds template tags to allow you to search for content from Google. You will need to configure this plugin using a <a href=\'http://www.google.com/apis/\'>license key.</a>' => 'Añade etiquetas de plantilla para buscar el contenido en Google. Deberá configurar esta extensión utilizando una <a href=\'http://www.google.com/apis/\'>clave de licencia</a>.',
    'You used [_1] without a query.' => 'Utilizó [_1] sin una consulta',
    'You need a Google API key to use [_1]' => 'Necesita una clave de Google API para usar [_1]',
    'You used a non-existent property from the result structure.' => 'Utilizó una propiedad no existente de la estructura de resultados',
);

1;

