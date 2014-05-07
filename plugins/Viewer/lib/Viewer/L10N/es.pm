# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package Viewer::L10N::es;
use strict;
use utf8;
use base qw( Viewer::L10N );

our %Lexicon = (

## lib/MT/App/Viewer.pm
        'Loading blog with ID [_1] failed' => 'Falló al cargar el blog con el ID [_1]',
        'File not found' => 'Fichero no encontrado',
        'Template publishing failed: [_1]' => 'Falló al publicar la plantilla: [_1]',
        'Unknown archive type: [_1]' => 'Tipo de archivo desconocido: [_1]',
        'Cannot load template [_1]' => 'No se pudo cargar la plantilla [_1]',
        'Archive publishing failed: [_1]' => 'Falló al publicar los archivos: [_1]',
        'Invalid entry ID [_1].' => 'Entrada con ID [_1] no válida.',
        'Entry [_1] was not published.' => 'No se publicó la entrada [_1].',
        'Invalid category ID \'[_1]\'' => 'Identificador de categoría no válido \'[_1]\'',
        'Invalid author ID \'[_1]\'' => 'Autor no válido, ID \'[_1]\'',

);

1;
