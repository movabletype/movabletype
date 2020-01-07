# This program is distributed under the terms of
# The MIT License (MIT)
#
# Copyright (c) 2019 Six Apart Ltd.
#
# $Id$

package GoogleAnalytics::L10N::de;

use strict;
use warnings;

use base 'GoogleAnalytics::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/GoogleAnalytics/config.yaml
	'Site statistics plugin using Google Analytics.' => 'Site-Statistik-Plugin auf Basis von Google Analytics',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/App.pm
	'A Perl module required for using Google Analytics API is missing: [_1].' => 'Ein zur Nutzung der Google-Analytics-API erforderliches Perl-Modul fehlt: [_1].',
	'You did not specify a client ID.' => 'Bitte geben Sie eine Client ID an.',
	'You did not specify a code.' => 'Bitte geben Sie einen Code an.',
	'The name of the profile' => 'Profilname',
	'The web property ID of the profile' => 'Die Web Property ID des Profils',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/OAuth2.pm
	'An error occurred when getting token: [_1]: [_2]' => 'Beim Bezug des Tokens ist ein Fehler aufgetreten: [_1]: [_2]',
	'An error occurred when refreshing access token: [_1]: [_2]' => 'Bei der Aktualisierung des Tokens ist ein Fehler aufgetreten: [_1]: [_2]',
	'An error occurred when getting accounts: [_1]: [_2]' => 'Beim Abrufen der Konten ist ein Fehler aufgetreten: [_1]: [_2]',
	'An error occurred when getting profiles: [_1]: [_2]' => 'Beim Abrufen der Profile ist ein Fehler aufgetreten: [_1]: [_2]',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/Provider.pm
	'An error occurred when retrieving statistics data: [_1]: [_2]' => 'Beim Abrufen der Statistikdaten ist ein Fehler aufgetreten: [_1]: [_2]',

## plugins/GoogleAnalytics/tmpl/api_error.tmpl
	'API error' => 'API-Fehler',

## plugins/GoogleAnalytics/tmpl/select_profile.tmpl
	'Select profile' => 'Profil wählen',

## plugins/GoogleAnalytics/tmpl/web_service_config.tmpl
	'Google Analytics' => 'Google Analytics',
	'OAuth2 settings' => 'OAuth2-Einstellungen',
	'This [_2] is using the settings of [_1].' => 'In diesem [_2] werden die Einstellungen von [_1] verwendet.',
	'Other Google account' => 'Anderes Google-Konto',
	q{Create an OAuth2 application's Client ID for web applications with this redirect URI via <a href="https://cloud.google.com/console" target="_blank">Google Cloud Platform</a> before selecting profile.} => q{Erstellen Sie über die <a href="https://cloud.google.com/console" target="_blank">Google Cloud Platform</a> eine OAuth2-Client-ID mit dieser Redirect-URI, bevor Sie ein Profil wählen.}, # Translate - New # OK
	'Redirect URI of the OAuth2 application' => 'Redirect-URI der OAuth2-Anwendung', # Translate - Improved
	'Client ID of the OAuth2 application' => 'Client-ID der OAuth2-Anwendung', # Translate - Improved
	'Client secret of the OAuth2 application' => 'Client Secret der OAuth2-Anwendung',
	'Google Analytics profile' => 'Google Analytics-Profil',
	'Select Google Analytics profile' => 'Google Analytics-Profil wählen',
	'(No profile selected)' => '(Kein Profil gewählt)',
	'Client ID or client secret for Google Analytics was changed, but profile was not updated. Are you sure you want to save these settings?' => 'Die Client ID oder das Client Secret von Google Analytics wurde geändert, ohne das Profil zu aktualisieren. Einstellungen wirklich speichern?',

);

1;
