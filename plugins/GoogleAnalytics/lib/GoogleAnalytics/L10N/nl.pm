# This program is distributed under the terms of
# The MIT License (MIT)
#
# Copyright (c) 2013 Six Apart, Ltd.
#
# $Id$

package GoogleAnalytics::L10N::nl;

use strict;
use warnings;

use base 'GoogleAnalytics::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/GoogleAnalytics/config.yaml
	'Site statistics plugin using Google Analytics.' => 'Sitestatistieken plugin gebruik makend van Google Analytics', # Translate - New

## plugins/GoogleAnalytics/lib/GoogleAnalytics/App.pm
	'A Perl module required for using Google Analytics API is missing: [_1].' => 'Een Perl module vereist voor het gebruik van de Google Analytics API ontbreekt: [_1]', # Translate - New
	'Removing stats cache was failed.' => 'Verwijderen statistiekencache mislukt.', # Translate - New
	'You did not specify a client ID.' => 'U gaf geen client ID op.', # Translate - New
	'You did not specify a code.' => 'U gaf geen code op.', # Translate - New
	'The name of the profile' => 'Naam van het profiel', # Translate - New
	'The web property ID of the profile' => 'De web property ID van het ID', # Translate - New

## plugins/GoogleAnalytics/lib/GoogleAnalytics/OAuth2.pm
	'An error occurred when getting token: [_1]: [_2]' => 'Er deed zich een fout voor bij het ophalen van het token: [_1]: [_2]', # Translate - New
	'An error occurred when refreshing access token: [_1]: [_2]' => 'Er deed zich een fout voor bij het verversen van het toegangstoken: [_1]: [_2]', # Translate - New
	'An error occurred when getting accounts: [_1]: [_2]' => 'Er deed zich een fout voor bij het ophalen van de accounts: [_1]: [_2]', # Translate - New
	'An error occurred when getting profiles: [_1]: [_2]' => 'Er deed zich een fout voor bij het ophalen van de profielen: [_1]: [_2]', # Translate - New

## plugins/GoogleAnalytics/lib/GoogleAnalytics/Provider.pm
	'An error occurred when retrieving statistics data: [_1]: [_2]' => 'Er deed zich een fout voor bij het ophalen van statistiekgegevens: [_1]: [_2]', # Translate - New

## plugins/GoogleAnalytics/tmpl/api_error.tmpl
	'API error' => 'API fout', # Translate - New

## plugins/GoogleAnalytics/tmpl/select_profile.tmpl
	'Select profile' => 'Selecteer profiel', # Translate - New

## plugins/GoogleAnalytics/tmpl/web_service_config.tmpl
	'Google Analytics' => 'Google Analytics', # Translate - New
	'OAuth2 settings' => 'OAuth2 instellingen', # Translate - New
	'This blog is using the settings of [_1].' => 'Deze blog gebruikt de instellingen van [_1]', # Translate - New
	'Other Google account' => 'Andere Google account', # Translate - New
	q{Create an OAuth2 application's Client ID for web applications with this redirect URI via <a href="https://code.google.com/apis/console" target="_blank">Google APIs Console</a> before selecting profile.} => q{Maak een OAuth2 applicatie Client ID voor webapplicaties aan met deze redirect URI via de <a href="https://code.google.com/apis/console" target="_blank">Google APIs Console</a> voor een profiel te selecteren.}, # Translate - New
	'Redirect URI of the OAuth2 application' => 'Redirect URI van de OAuth2 applicatie', # Translate - New
	'Client ID of the OAuth2 application' => 'Client ID van de OAuth2 applicatie', # Translate - New
	'Client secret of the OAuth2 application' => 'Client secret van de OAuth2 applicatie', # Translate - New
	'Google Analytics profile' => 'Google Analytics profiel', # Translate - New
	'Select Google Analytics profile' => 'Selecteer Google Analytics profiel', # Translate - New
	'(No profile selected)' => '(geen profiel geselecteerd)', # Translate - New
	'Client ID or client secret for Google Analytics was changed, but profile was not updated. Are you sure you want to save these settings?' => 'Client ID of client secret voor Google Analytics werd aangepast, maar profiel werd niet bijgewerkt.  Bent u zeker dat u deze instellingen wenst op te slaan?', # Translate - New


);

1;
