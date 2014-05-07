# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package NotifyList::L10N::fr;
use strict;
use utf8;
use base qw( NotifyList::L10N::en_us );

our %Lexicon = (

## lib/MT/App/NotifyList.pm
        'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Il manque un paramètre requis : blog_id. Veuillez consulter le manuel d\'utilisateur pour configurer les notifications.',
        'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Un paramètre de redirection est invalide. Le propriétaire du blog doit spécifier le chemin qui correspond au nom de domaine du blog.',
        'The email address \'[_1]\' is already in the notification list for this weblog.' => 'L\'adresse e-mail \'[_1]\' fait déjà partie de la liste de notification pour ce blog.',
        'Please verify your email to subscribe' => 'Merci de vérifier votre e-mail pour souscrire',
        '_NOTIFY_REQUIRE_CONFIRMATION' => 'Un email a été envoyé à [_1]. Pour valider votre inscription, merci de cliquer sur le lien qui figure dans cet e-mail. Il permettra de vérifier que votre adresse e-mail est valable.',
        'The address [_1] was not subscribed.' => 'L\'adresse [_1] n\'a pas été abonnée.',
        'The address [_1] has been unsubscribed.' => 'L\'adresse [_1] a été supprimée.',

## lib/MT/DefaultTemplates.pm
        'Subscribe Verify' => 'Vérification d\'inscription',

## default_templates/verify-subscribe.mtml
        q{Thank you for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:} => q{Merci d'avoir demandé à suivre les mises à jour de [_1]. Suivez le lien ci-dessous pour confirmer votre inscription :},
        q{If the link is not clickable, just copy and paste it into your browser.} => q{Si le lien n'est pas cliquable, faites simplement un copier-coller dans votre navigateur.},

);

1;
