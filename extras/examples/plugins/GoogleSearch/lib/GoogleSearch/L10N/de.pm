# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

# GoogleSearch plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic and GPLv2 License

package GoogleSearch::L10N::de;

use strict;
use base 'GoogleSearch::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
    'Google API Key:' => 'Google API-Key:',
    'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.' => 'Um eine der API-Funktionen von Google nutzen zu können, benötigen Sie einen API-Schlüssel von Google. Fügen Sie diesen hier ein.',
    'Adds template tags to allow you to search for content from Google. You will need to configure this plugin using a <a href=\'http://www.google.com/apis/\'>license key.</a>' => 'Stellt für Google-basierte Blogsuchen erforderliche Tags zur Verfügung. Kostenloser <a href=\'http://www.google.com/apis/\'>API-Schlüssel</a> erforderlich.',      
    'You used [_1] without a query.' => '[_1] ohne Suchbegriff verwendet.',
    'You need a Google API key to use [_1]' => 'Google API-Schlüssel für [_1] erforderlich.',
    'You used a non-existent property from the result structure.' => 'Nicht vorhandene Eigenschaft der Ergebnisstruktur verwendet.',  
);

1;

