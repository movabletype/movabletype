# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package Viewer::L10N::fr;
use strict;
use utf8;
use base qw( Viewer::L10N );

our %Lexicon = (

## lib/MT/App/Viewer.pm
        'Loading blog with ID [_1] failed' => 'Échec lors du chargement du blog ayant pour ID [_1]',
        'File not found' => 'Fichier introuvable',
        'Template publishing failed: [_1]' => 'Échec de la publication du gabarit : [_1]',
        'Unknown archive type: [_1]' => 'Type d\'archive inconnu :[_1]',
        'Cannot load template [_1]' => 'Impossible de charger le gabarit [_1]',
        'Archive publishing failed: [_1]' => 'Échec de la publication de l\'archive : [_1]',
        'Invalid entry ID [_1].' => 'ID de note invalide [_1].',
        'Entry [_1] was not published.' => 'La note [_1] n\'a pas été publiée.',
        'Invalid category ID \'[_1]\'' => 'ID de catégorie invalide : \'[_1]\'',
        'Invalid author ID \'[_1]\'' => 'ID d\'auteur invalide : \'[_1]\'',

);

1;
