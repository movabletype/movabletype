# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package NotifyList::L10N::nl;
use strict;
use utf8;
use base qw( NotifyList::L10N::en_us );

our %Lexicon = (

## lib/MT/App/NotifyList.pm
        'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Ontbrekende parameter: blog_id. Gelieve de handleiding te raadplegen om waarschuwingen te configureren.',
        'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Er werd een ongeldige redirect parameter opgegeven. De eigenaar van de weblog moet een pad opgeven dat overeenkomt met het domein van de weblog.',
        'The email address \'[_1]\' is already in the notification list for this weblog.' => 'Het e-mail adres \'[_1]\' zit reeds in de notificatielijst voor deze weblog.',
        'Please verify your email to subscribe' => 'Gelieve uw e-mail adres te verifiëren voor inschrijving',
        '_NOTIFY_REQUIRE_CONFIRMATION' => 'Er is een e-mail verstuurd naar [_1].  Om uw inschrijving te voltooien, \n    gelieve de link te volgen die in die e-mail staat.  Dit om te bevestigen dat\n    het opgegeven e-mail adres correct is en aan u toebehoort.',
        'The address [_1] was not subscribed.' => 'Het adres [_1] werd niet ingeschreven.',
        'The address [_1] has been unsubscribed.' => 'Het adres [_1] werd uitgeschreven.',

## lib/MT/DefaultTemplates.pm
        'Subscribe Verify' => 'Verificatie inschrijving',

## default_templates/verify-subscribe.mtml
        'Thank you for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Bedankt om in te schrijven voor notificaties over updates op [_1].  Gelieve onderstaande link te volgen om uw inschrijving te bevestigen:',
        'If the link is not clickable, just copy and paste it into your browser.' => 'Indien de link niet klikbaar is, kopiëer en plak hem dan gewoon in uw browser.',

);

1;
