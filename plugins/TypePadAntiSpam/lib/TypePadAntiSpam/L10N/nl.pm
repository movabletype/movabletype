# Movable Type (r) Open Source (C) 2005-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: ja.pm 81672 2008-05-26 10:30:44Z fyoshimatsu $

package TypePadAntiSpam::L10N::nl;

use strict;
use base 'TypePadAntiSpam::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (

## plugins/TypePadAntiSpam/lib/MT/TypePadAntiSpam.pm
	'API key is a required parameter.' => 'API sleutel is een vereiste parameter', # Translate - New

## plugins/TypePadAntiSpam/tmpl/system.tmpl
	'API Key' => 'API sleutel', # Translate - New
	'To enable this plugin, you\'ll need a free TypePad AntiSpam API key. You can <strong>get your free API key at [_1]antispam.typepad.com[_2]</strong>. Once you have your key, return to this page and enter it in the field below.' => 'Om deze plugin te kunnen inschakelen heeft u een gratis TypePad AntiSpam API sleutel nodig.  U kunt uw <strong>gratis API sleutel afhalen op [_1]antispam.typepad.com[_2]</strong>.  Zodra u uw sleutel heeft, moet u terugkeren naar deze pagina en hem hieronder invullen.', # Translate - New
	'Service Host' => 'Service host', # Translate - New
	'The default service host for TypePad AntiSpam is api.antispam.typepad.com. You should only change this if you are using a different service that is compatible with the TypePad AntiSpam API.' => 'De standaard host voor TypePad AntiSpam is api.antispam.com.  U moet dit alleen veranderen als u een andere service gebruikt die compatibel is met de TypePad AntiSpam API.', # Translate - New

## plugins/TypePadAntiSpam/tmpl/config.tmpl
	'Junk Score Weight' => 'Spamscoregewicht', # Translate - New
	'Least Weight' => 'Laagste gewicht', # Translate - New
	'Most Weight' => 'Hoogste gewicht', # Translate - New
	'Comments and TrackBacks receive a junk score between -10 (definitely spam) and +10 (definitely not spam). This setting allows you to control the weight of the TypePad AntiSpam rating relative to other filters you may have installed to help you filter comments and TrackBacks.' => 'Reacties en TrackBacks krijgen een spamscore tussen -10 (zeker spam) en +10 (zeker geen spam).  Deze instelling geeft u de mogelijkheid het gewicht van het oordeel van TypePad AntiSpam in te stellen relatief tot de andere filters die u misschien geïnstalleerd heeft om reacties en TrackBacks te filteren.', # Translate - New

## plugins/TypePadAntiSpam/tmpl/stats_widget.tmpl
	'widget_label_width' => 'widget_label_width', # Translate - New
	'widget_totals_width' => 'widget_totals_width', # Translate - New
	'TypePad AntiSpam' => 'TypePad AntiSpam', # Translate - New
	'Spam Blocked' => 'Spams gestopt', # Translate - New
	'on this blog' => 'op deze blog', # Translate - New
	'on this system' => 'op dit systeem', # Translate - New

## plugins/TypePadAntiSpam/TypePadAntiSpam.pl
	'TypePad AntiSpam is a free service from Six Apart that helps protect your blog from comment and TrackBack spam. The TypePad AntiSpam plugin will send every comment or TrackBack submitted to your blog to the service for evaluation, and Movable Type will filter items if TypePad AntiSpam determines it is spam. If you discover that TypePad AntiSpam incorrectly classifies an item, simply change its classification by marking it as "Spam" or "Not Spam" from the Manage Comments screen, and TypePad AntiSpam will learn from your actions. Over time the service will improve based on reports from its users, so take care when marking items as "Spam" or "Not Spam."' => 'TypePad AntiSpam is een gratis service van Six Apart die helpt uw blog te beschermen tegen spam in uw reacties en TrackBacks.  De TypePad AntiSpam plugin verstuurt elke reactie of TrackBack die ontvangen wordt op uw blog door naar de service waar ze dan beoordeeld worden.  Movable Type zal items filteren als TypePad AntiSpam bepaalt dat ze spam zijn.  Als u merkt dat TypePad AntiSpam items niet correct classificeert dan kunt u de classificatie eenvoudigweg aanpassen door ze als "Spam" of "Geen Spam" te markeren vanop het scherm voor reactiebeheer.  TypePad AntiSpam zal dan leren uit uw acties.  Na verloop van tijd wordt de service dus altijd maar beter, gebaseerd op rapporten van gebruikers, dus let op voor u iets als "Spam" of "Geen Spam" markeert!', # Translate - New
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] for this blog, and [quant,_2,message,messages] system-wide.' => 'Tot nu toe heeft TypePad AntiSpam [quant,_1,bericht,berichten] geblokkeerd voor deze weblog, en [quant,_2,bericht,berichten] over het hele systeem.', # Translate - New
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] system-wide.' => 'Tot nu toe heeft TypePad AntiSpam [quant,_1,bericht,berichten] geblokkeerd over het hele systeem.', # Translate - New
	'Failed to verify your TypePad AntiSpam API key: [_1]' => 'Verificatie van uw TypePad AntiSpam API sleutel mislukt:', # Translate - New
	'The TypePad AntiSpam API key provided is invalid.' => 'De TypePad AntiSpam API sleutel die u opgaf was ongeldig.', # Translate - New


);

1;

