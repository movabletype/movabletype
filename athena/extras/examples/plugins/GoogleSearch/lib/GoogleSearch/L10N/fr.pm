# GoogleSearch plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id: ja.pm 30952 2006-06-13 09:20:43Z jallen $

package GoogleSearch::L10N::fr;

use strict;
use base 'GoogleSearch::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
    'Google API Key:' => 'Clé d\'API Google :',
    'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.' => 'Vous devrez vous procurer une clé d\'API Google si vous souhaitez utiliser une des fonctionnalités de l\'API proposée par Google. Le cas échéant, collez cette clé dans cet espace.',
    'Adds template tags to allow you to search for content from Google. You will need to configure this plugin using a <a href=\'http://www.google.com/apis/\'>license key.</a>' => 'Ajoute des tags aux modèles qui vous permettrons de rechercher du contenu sur Google. Vous aurez besoin de configurer ce plugin avec une <a href=\'http://www.google.com/apis/\'>clé de licence</a>.',
    'You used [_1] without a query.' => 'Vous avez utilisé [_1] sans requête.',
    'You need a Google API key to use [_1]' => 'Vous avez besoin d\'une clef d\'API Google pour utiliser [_1]',
    'You used a non-existent property from the result structure.' => 'Vous avez utilisé une propriété non existante de la structure de résultat.',
    
);

1;

