# GoogleSearch plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id: ja.pm 30952 2006-06-13 09:20:43Z jallen $

package GoogleSearch::L10N::nl;

use strict;
use base 'GoogleSearch::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
    'Google API Key:' => 'Google API-code:',
    'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.' => 'Als u een Google API-functie wenst te gebruiken, hebt u een Google API-code nodig. Plak deze hier.',
    'Adds template tags to allow you to search for content from Google. You will need to configure this plugin using a <a href=\'http://www.google.com/apis/\'>license key.</a>' => 'Voegt sjabloontags toe aan het systeem waarmee u gegevens kunt opzoeken van Google.  U moet deze plugin configureren met een <a href=\'http://www.google.com/apis/\'>licentiesleutel.</a>',
    'You used [_1] without a query.' => 'U gebruikte [_1] zonder een query.',
    'You need a Google API key to use [_1]' => 'U moet een Google API sleutel hebben om [_] te gebruiken',
    'You used a non-existent property from the result structure.' => 'U gebruikte een onbestaande eigenschap uit de resultaatstructuur',
    
);

1;

