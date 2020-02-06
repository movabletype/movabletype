# This program is distributed under the terms of
# The MIT License (MIT)
#
# Copyright (c) 2019 Six Apart Ltd.
#
# $Id$

package GoogleAnalytics::L10N::fr;

use strict;
use warnings;

use base 'GoogleAnalytics::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/GoogleAnalytics/config.yaml
	'Site statistics plugin using Google Analytics.' => 'Statistiques du site via Google Analytics.',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/App.pm
	'A Perl module required for using Google Analytics API is missing: [_1].' => 'Un module Perl requis pour utiliser l\'API Google Analytics API est manquant : [_1].',
	'You did not specify a client ID.' => 'Vous n\'avez pas fourni d\'ID client.',
	'You did not specify a code.' => 'Vous n\'avez pas fourni de code.',
	'The name of the profile' => 'Le nom du profil',
	'The web property ID of the profile' => 'L\'ID de propriété web du profil',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/OAuth2.pm
	'An error occurred when getting token: [_1]: [_2]' => 'Une erreur est survenue à la récupération du jeton [_1] : [_2]',
	'An error occurred when refreshing access token: [_1]: [_2]' => 'Une erreur est survenue au rafraîchissement du jeton d\'accès : [_1] : [_2]',
	'An error occurred when getting accounts: [_1]: [_2]' => 'Une erreur est survenue à la récupération des compte : [_1] : [_2]s',
	'An error occurred when getting profiles: [_1]: [_2]' => 'Une erreur est survenue à la récupération des profils : [_1] : [_2]',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/Provider.pm
	'An error occurred when retrieving statistics data: [_1]: [_2]' => 'Une erreur est survenue à la récupération des données statistiques : [_1] : [_2]',

## plugins/GoogleAnalytics/tmpl/api_error.tmpl
	'API error' => 'Erreur API',

## plugins/GoogleAnalytics/tmpl/select_profile.tmpl
	'Select profile' => 'Sélectionner un profil',

## plugins/GoogleAnalytics/tmpl/web_service_config.tmpl
	'Google Analytics' => 'Google Analytics',
	'OAuth2 settings' => 'Paramètres OAuth2',
	'This [_2] is using the settings of [_1].' => 'Ce [_2] utilise les paramètres de [_1].',
	'Other Google account' => 'Autre compte Google',
	q{Create an OAuth2 application's Client ID for web applications with this redirect URI via <a href="https://cloud.google.com/console" target="_blank">Google Cloud Platform</a> before selecting profile.} => q{Créez un ID client d'application OAuth2 pour application web avec cette URI de redirection via <a href="https://cloud.google.com/console" target="_blank">la plateforme Google Cloud/a> avant de sélectionner un profil.}, # Translate - New
	q{Redirect URI of the OAuth2 application} => q{URL de redirection de l'application OAuth2},
	q{Client ID of the OAuth2 application} => q{ID Client de l'application OAuth2},
	q{Client secret of the OAuth2 application} => q{Secret Client de l'application OAuth2},
	'Google Analytics profile' => 'Profil Google Analytics',
	'Select Google Analytics profile' => 'Sélectionnez le profil Google Analytics',
	'(No profile selected)' => '(Aucun profil sélectionné)',
	q{Client ID or client secret for Google Analytics was changed, but profile was not updated. Are you sure you want to save these settings?} => q{L'ID ou le secret client de l'application OAuth2 a été modifié mais le profil n'a pas été mis à jour. Êtes-vous sûr de vouloir sauvegarder ces paramètres ?},

);

1;
