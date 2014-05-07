# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package NotifyList::L10N::de;
use strict;
use utf8;
use base qw( NotifyList::L10N::en_us );

our %Lexicon = (

## lib/MT/App/NotifyList.pm
        'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Erforderliches Parameter blog_id fehlt. Bitte konfigurieren Sie die Benachrichtungsfunktion entsprechend.',
        'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Ungültiges Redirect-Parameter. Es muss ein Pfad angegeben sein, der zur Domain dieses Weblogs gehört.',
        'The email address \'[_1]\' is already in the notification list for this weblog.' => 'An die Adresse &#8222;[_1]&#8220; werden bereits Benachrichtigungen über dieses Weblog verschickt.',
        'Please verify your email to subscribe' => 'Bitte bestätigen Sie Ihre E-Mail-Adresse',
        '_NOTIFY_REQUIRE_CONFIRMATION' => 'Um den Vorgang abzuschließen, klicken Sie bitte auf den Link in der E-Mail, die an [_1] verschickt wurde. Damit stellen Sie sicher, daß die E-Mail-Adresse Ihnen gehört und korrekt eingegeben wurde.',
        'The address [_1] was not subscribed.' => 'Die Adresse [_1] war kein Abonnent.',
        'The address [_1] has been unsubscribed.' => 'Die Adresse [_1] ist kein Abonnent mehr.',

## lib/MT/DefaultTemplates.pm
        'Subscribe Verify' => 'Abonnementbestätigung',

## default_templates/verify-subscribe.mtml
        'Thank you for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Danke, daß Sie Benachrichtigungen zu [_1] erhalten möchten. Zur Bestätigung klicken Sie bitte auf folgenden Link:',
        'If the link is not clickable, just copy and paste it into your browser.' => 'Kann der Link nicht angeklickt werden, kopieren Sie ihn und fügen ihn in der Adresszeile Ihres Browers ein.',

);

1;
