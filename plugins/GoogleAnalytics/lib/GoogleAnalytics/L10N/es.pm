# This program is distributed under the terms of
# The MIT License (MIT)
#
# Copyright (c) 2013 Six Apart, Ltd.
#
# $Id$

package GoogleAnalytics::L10N::es;

use strict;
use warnings;

use base 'GoogleAnalytics::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/GoogleAnalytics/config.yaml
	'Site statistics plugin using Google Analytics.' => 'Extensión para estadísticas del sitio mediante Google Analytics.', # Translate - New

## plugins/GoogleAnalytics/lib/GoogleAnalytics/App.pm
	'A Perl module required for using Google Analytics API is missing: [_1].' => 'No se encuentra el módulo de Perl necesario para la API de Google Analytics: [_1].', # Translate - New
	'Removing stats cache was failed.' => 'Falló al eliminar la caché de estadísticas.', # Translate - New
	'You did not specify a client ID.' => 'No especificó el ID de cliente.', # Translate - New
	'You did not specify a code.' => 'No especificó el código.', # Translate - New
	'The name of the profile' => 'El nombre del perfil', # Translate - New
	'The web property ID of the profile' => 'El ID del web propietario del perfil', # Translate - New

## plugins/GoogleAnalytics/lib/GoogleAnalytics/OAuth2.pm
	'An error occurred when getting token: [_1]: [_2]' => 'Ocurrió un error al obtener el token: [_1]: [_2]', # Translate - New
	'An error occurred when refreshing access token: [_1]: [_2]' => 'Ocurrió un error al refrescar el token de acceso: [_1]: [_2]', # Translate - New
	'An error occurred when getting accounts: [_1]: [_2]' => 'Ocurrió un error al obtener las cuentas: [_1]: [_2]', # Translate - New
	'An error occurred when getting profiles: [_1]: [_2]' => 'Ocurrió un error al obtener los perfiles: [_1]: [_2]', # Translate - New

## plugins/GoogleAnalytics/lib/GoogleAnalytics/Provider.pm
	'An error occurred when retrieving statistics data: [_1]: [_2]' => 'Ocurrió un error al obtener las estadísticas: [_1]: [_2]', # Translate - New

## plugins/GoogleAnalytics/tmpl/api_error.tmpl
	'API error' => 'Error del API', # Translate - New

## plugins/GoogleAnalytics/tmpl/select_profile.tmpl
	'Select profile' => 'Seleccionar perfil', # Translate - New

## plugins/GoogleAnalytics/tmpl/web_service_config.tmpl
	'Google Analytics' => 'Google Analytics', # Translate - New
	'OAuth2 settings' => 'Configuración OAuth2', # Translate - New
	'This blog is using the settings of [_1].' => 'Este blog está utilizando la configuración de [_2].', # Translate - New
	'Other Google account' => 'Otra cuenta de Google', # Translate - New
	q{Create an OAuth2 application's Client ID for web applications with this redirect URI via <a href="https://code.google.com/apis/console" target="_blank">Google APIs Console</a> before selecting profile.} => q{Cree un ID de cliente OAuth2 para las aplicaciones web en este enlace a la <a href="https://code.google.com/apis/console" target="_blank">Consola de Google APIs</a> antes de seleccionar el perfil.}, # Translate - New
	'Redirect URI of the OAuth2 application' => 'URI de redirección de la aplicación OAuth2', # Translate - New
	'Client ID of the OAuth2 application' => 'ID de cliente de la aplicación OAuth2', # Translate - New
	'Client secret of the OAuth2 application' => 'Secreto de cliente de la aplicación OAuth2', # Translate - New
	'Google Analytics profile' => 'Perfil de Google Analytics', # Translate - New
	'Select Google Analytics profile' => 'Seleccione perfil de Google Analytics', # Translate - New
	'(No profile selected)' => '(No hay perfil seleccionado)', # Translate - New
	'Client ID or client secret for Google Analytics was changed, but profile was not updated. Are you sure you want to save these settings?' => 'El ID o el secreto de cliente para Google Analytics ha cambiado, pero no se ha actualizado el perfil. ¿Está seguro de querer guardar esta configuración?', # Translate - New
        'This [_2] is using the settings of [_1].' => 'Este [_2] está usando la configuración de [_1].', # Translate - New


);

1;
