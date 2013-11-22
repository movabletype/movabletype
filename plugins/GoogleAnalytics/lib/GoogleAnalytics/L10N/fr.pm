# This program is distributed under the terms of
# The MIT License (MIT)
#
# Copyright (c) 2013 Six Apart, Ltd.
#
# $Id$

package GoogleAnalytics::L10N::fr;

use strict;
use warnings;

use base 'GoogleAnalytics::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/GoogleAnalytics/config.yaml
	'Site statistics plugin using Google Analytics.' => 'Statistiques du site via Google Analytics.', # Translate - New

## plugins/GoogleAnalytics/lib/GoogleAnalytics/App.pm
	'A Perl module required for using Google Analytics API is missing: [_1].' => 'Un module Perl requis pour utiliser l\'API Google Analytics API est manquant : [_1].', # Translate - New
	'Removing stats cache was failed.' => 'La suppression du cache des statistiques a échoué.', # Translate - New
	'You did not specify a client ID.' => 'Vous n\'avez pas fourni d\'ID client.', # Translate - New
	'You did not specify a code.' => 'Vous n\'avez pas fourni de code.', # Translate - New
	'The name of the profile' => 'Le nom du profil', # Translate - New
	'The web property ID of the profile' => 'L\'ID de propriété web du profil', # Translate - New

## plugins/GoogleAnalytics/lib/GoogleAnalytics/OAuth2.pm
	'An error occurred when getting token: [_1]: [_2]' => 'Une erreur est survenue à la récupération du jeton [_1] : [_2]', # Translate - New
	'An error occurred when refreshing access token: [_1]: [_2]' => 'Une erreur est survenue au rafraîchissement du jeton d\'accès : [_1] : [_2]', # Translate - New
	'An error occurred when getting accounts: [_1]: [_2]' => 'Une erreur est survenue à la récupération des compte : [_1] : [_2]s', # Translate - New
	'An error occurred when getting profiles: [_1]: [_2]' => 'Une erreur est survenue à la récupération des profils : [_1] : [_2]', # Translate - New

## plugins/GoogleAnalytics/lib/GoogleAnalytics/Provider.pm
	'An error occurred when retrieving statistics data: [_1]: [_2]' => 'Une erreur est survenue à la récupération des données statistiques : [_1] : [_2]', # Translate - New

## plugins/GoogleAnalytics/tmpl/api_error.tmpl
	'API error' => 'Erreur API', # Translate - New

## plugins/GoogleAnalytics/tmpl/select_profile.tmpl
	'Select profile' => 'Sélectionner un profil', # Translate - New

## plugins/GoogleAnalytics/tmpl/web_service_config.tmpl
	'Google Analytics' => 'Google Analytics', # Translate - New
	'OAuth2 settings' => 'Paramètres OAuth2', # Translate - New
	'This blog is using the settings of [_1].' => 'Ce blog utilise les paramètres de [_1].', # Translate - New
	'Other Google account' => 'Autre compte Google', # Translate - New
	q{Create an OAuth2 application's Client ID for web applications with this redirect URI via <a href="https://cloud.google.com/console" target="_blank">Google Cloud Console</a> before selecting profile.} => q{Créez un ID d'application cliente OAuth2 pour application web avec cette URL de redirection via <a href="https://cloud.google.com/console" target="_blank">Google Cloud Console</a> avant de sélectionner un profil.}, # Translate - New
	'Redirect URI of the OAuth2 application' => 'URL de redirection de l\'application OAuth2', # Translate - New
	'Client ID of the OAuth2 application' => 'ID Client de l\'application OAuth2', # Translate - New
	'Client secret of the OAuth2 application' => 'Secret Client de l\'application OAuth2', # Translate - New
	'Google Analytics profile' => 'Profil Google Analytics', # Translate - New
	'Select Google Analytics profile' => 'Sélectionnez le profil Google Analytics', # Translate - New
	'(No profile selected)' => '(Aucun profil sélectionné)', # Translate - New
	'Client ID or client secret for Google Analytics was changed, but profile was not updated. Are you sure you want to save these settings?' => 'L\'ID ou le secret client de l\'application OAuth2 a été modifié mais le profil n\'a pas été mis à jour. Êtes-vous sûr de vouloir sauvegarder ces paramètres ?', # Translate - New
	'This [_2] is using the settings of [_1].' => 'Ce [_2] utilise les paramètres de [_1].', # Translate - New


);

1;
