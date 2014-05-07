# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package NotifyList::L10N::es;
use strict;
use utf8;
use base qw( NotifyList::L10N::en_us );

our %Lexicon = (

## lib/MT/App/NotifyList.pm
        'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Falta parámetro obligatorio: blog_id. Por favor, consulte el manual de usuario para configurar las notificaciones.',
        'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Parámetro de redirección no válido. El dueño del weblog debe especificar una ruta que coincida con el del dominio del weblog.',
        'The email address \'[_1]\' is already in the notification list for this weblog.' => 'La dirección de correo-e \'[_1]\' ya está en la lista de notificaciones de este weblog.',
        'Please verify your email to subscribe' => 'Por favor, verifique su dirección de correo electrónico para la subscripción',
        '_NOTIFY_REQUIRE_CONFIRMATION' => 'Se envió un correo a [_1]. Para completar su suscripción,
por favor siga el enlace contenido en este correo. Esto verificará
que la dirección provista es correcta y le pertenece.',
        'The address [_1] was not subscribed.' => 'No se suscribió la dirección [_1].',
        'The address [_1] has been unsubscribed.' => 'Se desuscribió la dirección [_1].',

## lib/MT/DefaultTemplates.pm
        'Subscribe Verify' => 'Verificación de suscripciones',

## default_templates/verify-subscribe.mtml
        'Thank you for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Gracias por suscribirse a las notificaciones de novedades de [_1]. Siga el enlace de abajo para confirmar su suscripción:',
        'If the link is not clickable, just copy and paste it into your browser.' => 'Si no puede hacer clic en el enlace, copie y péguelo en su navegador.',

);

1;
