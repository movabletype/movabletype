# This program is distributed under the terms of
# The MIT License (MIT)
#
# Copyright (c) 2019 Six Apart Ltd.
#
# $Id$

package GoogleAnalytics::L10N::nl;

use strict;
use warnings;

use base 'GoogleAnalytics::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/GoogleAnalytics/config.yaml
	'Site statistics plugin using Google Analytics.' => 'Sitestatistieken plugin gebruik makend van Google Analytics',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/App.pm
	'A Perl module required for using Google Analytics API is missing: [_1].' => 'Een Perl module vereist voor het gebruik van de Google Analytics API ontbreekt: [_1]',
	'You did not specify a client ID.' => 'U gaf geen client ID op.',
	'You did not specify a code.' => 'U gaf geen code op.',
	'The name of the profile' => 'Naam van het profiel',
	'The web property ID of the profile' => 'De web property ID van het ID',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/OAuth2.pm
	'An error occurred when getting token: [_1]: [_2]' => 'Er deed zich een fout voor bij het ophalen van het token: [_1]: [_2]',
	'An error occurred when refreshing access token: [_1]: [_2]' => 'Er deed zich een fout voor bij het verversen van het toegangstoken: [_1]: [_2]',
	'An error occurred when getting accounts: [_1]: [_2]' => 'Er deed zich een fout voor bij het ophalen van de accounts: [_1]: [_2]',
	'An error occurred when getting profiles: [_1]: [_2]' => 'Er deed zich een fout voor bij het ophalen van de profielen: [_1]: [_2]',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/Provider.pm
	'An error occurred when retrieving statistics data: [_1]: [_2]' => 'Er deed zich een fout voor bij het ophalen van statistiekgegevens: [_1]: [_2]',

## plugins/GoogleAnalytics/tmpl/api_error.tmpl
	'API error' => 'API fout',

## plugins/GoogleAnalytics/tmpl/select_profile.tmpl
	'Select profile' => 'Selecteer profiel',

## plugins/GoogleAnalytics/tmpl/web_service_config.tmpl
	'Google Analytics' => 'Google Analytics',
	'OAuth2 settings' => 'OAuth2 instellingen',
	'This [_2] is using the settings of [_1].' => 'Deze [_2] gebruikt de instellingen van [_1].',
	'Other Google account' => 'Andere Google account',
	q{Create an OAuth2 application's Client ID for web applications with this redirect URI via <a href="https://cloud.google.com/console" target="_blank">Google Cloud Platform</a> before selecting profile.} => q{Maak een Client ID voor webapplicaties aan van een OAuth2 applicatie met deze redirect URI via <a href="https://cloud.google.com/console" target="_blank">Google Cloud Platform</a> vooraleer een profiel te selecteren. }, # Translate - New
	'Redirect URI of the OAuth2 application' => 'Redirect URI van de OAuth2 applicatie',
	'Client ID of the OAuth2 application' => 'Client ID van de OAuth2 applicatie',
	'Client secret of the OAuth2 application' => 'Client secret van de OAuth2 applicatie',
	'Google Analytics profile' => 'Google Analytics profiel',
	'Select Google Analytics profile' => 'Selecteer Google Analytics profiel',
	'(No profile selected)' => '(geen profiel geselecteerd)',
	'Client ID or client secret for Google Analytics was changed, but profile was not updated. Are you sure you want to save these settings?' => 'Client ID of client secret voor Google Analytics werd aangepast, maar profiel werd niet bijgewerkt.  Bent u zeker dat u deze instellingen wenst op te slaan?'
);

1;
