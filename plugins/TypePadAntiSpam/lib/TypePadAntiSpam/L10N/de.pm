# Movable Type (r) Open Source (C) 2005-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: ja.pm 81672 2008-05-26 10:30:44Z fyoshimatsu $

package TypePadAntiSpam::L10N::de;

use strict;
use base 'TypePadAntiSpam::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (

## plugins/TypePadAntiSpam/lib/MT/TypePadAntiSpam.pm
	'API key is a required parameter.' => 'API-Schlüssel erforderlich', # Translate - New # OK

## plugins/TypePadAntiSpam/tmpl/system.tmpl
	'API Key' => 'API-Schlüssel', # Translate - New  # OK
	'To enable this plugin, you\'ll need a free TypePad AntiSpam API key. You can <strong>get your free API key at [_1]antispam.typepad.com[_2]</strong>. Once you have your key, return to this page and enter it in the field below.' => 'Um dieses Plugin zu aktivieren, benötigen Sie einen kostenlosen TypePad AntiSpam API-Schlüssel. <strong>Sie erhalten Ihren kostenlosen API-Schlüssel auf [_1]antispam.typepad.com[_2]</strong>. Geben Sie Ihren Schlüssel in das folgende Feld ein.', # Translate - New # OK
	'Service Host' => 'Dienstadresse', # Translate - New # OK
	'The default service host for TypePad AntiSpam is api.antispam.typepad.com. You should only change this if you are using a different service that is compatible with the TypePad AntiSpam API.' => 'Die Standard-Dienstadresse für TypePad AntiSpam ist api.antispam.typepad.com. Ändern Sie diese Angabe nur dann, wenn Sie einen anderen Dienst verwenden, der mit der TypePad Antispam-API kompatibel ist.', # Translate - New # OK

## plugins/TypePadAntiSpam/tmpl/config.tmpl
	'Junk Score Weight' => 'Spamfilter-Gewichtung', # Translate - New # OK
	'Least Weight' => 'Geringstes Gewicht', # Translate - New # OK
	'Most Weight' => 'Größtes Gewicht', # Translate - New # OK
	'Comments and TrackBacks receive a junk score between -10 (definitely spam) and +10 (definitely not spam). This setting allows you to control the weight of the TypePad AntiSpam rating relative to other filters you may have installed to help you filter comments and TrackBacks.' => 'Kommentare und TrackBacks erhalten eine Spam-Bewertung zwischen -10 (mit Sicherheit Spam) und +10 (mit Sicherheit kein Spam). Hier können Sie einstellen, wieviel Gewicht diese Bewertung im Verhältnis zu anderen Spamfiltern, die Sie möglicherweise ebenfalls installiert haben, erhalten soll.', # Translate - New # OK

## plugins/TypePadAntiSpam/tmpl/stats_widget.tmpl
	'widget_label_width' => 'widget_label_width', # Translate - New # OK
	'widget_totals_width' => 'widget_totals_width', # Translate - New # OK
	'TypePad AntiSpam' => 'TypePad AntiSpam', # Translate - New # OK
	'Spam Blocked' => 'Blockierter Spam', # Translate - New # OK
	'on this blog' => 'in diesem Blog', # Translate - New # OK
	'on this system' => 'in diesem System', # Translate - New # OK

## plugins/TypePadAntiSpam/TypePadAntiSpam.pl
	'TypePad AntiSpam is a free service from Six Apart that helps protect your blog from comment and TrackBack spam. The TypePad AntiSpam plugin will send every comment or TrackBack submitted to your blog to the service for evaluation, and Movable Type will filter items if TypePad AntiSpam determines it is spam. If you discover that TypePad AntiSpam incorrectly classifies an item, simply change its classification by marking it as "Spam" or "Not Spam" from the Manage Comments screen, and TypePad AntiSpam will learn from your actions. Over time the service will improve based on reports from its users, so take care when marking items as "Spam" or "Not Spam."' => 'TypePad AntiSpam schützt Ihr Blog vor Kommentar- und TrackBack-Spam. Mit dem TypePad AntiSpam-Plugin wird jeder eingehende Kommentar und jedes eingehende TrackBack vom TypePad AntiSpam-Service überprüft und, falls es sich um Spam handelt, von Movable Type automatisch herausgefiltert. Kommentare und TrackBacks können auch manuell als Spam oder gültiges Feedback markiert werden. TypePad AntiSpam ist adaptiv und lernt dabei nicht nur aus Ihren Eingaben, sondern aus denen aller Benutzer des Dienstes. TypePad AntiSpam ist ein kostenloser Dienst von Six Apart.', # Translate - New # OK
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] for this blog, and [quant,_2,message,messages] system-wide.' => 'Bisher [quant,_1,Spam-Nachricht,Spam-Nachrichten] in diesem Blog und [quant,_2,Spam-Nachricht,Spam-Nachrichten] systemweit von TypePad AntiSpam blockiert.', # Translate - New # OK
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] system-wide.' => 'Bisher [quant,_1,Spam-Nachricht,Spam-Nachrichten] von TypePad AntiSpam blockiert.', # Translate - New # OK
	'Failed to verify your TypePad AntiSpam API key: [_1]' => 'Verifizierung des TypePad AntiSpam API-Schlüssels fehlgeschlagen: [_1]', # Translate - New # OK
	'The TypePad AntiSpam API key provided is invalid.' => 'Der angegebene TypePad AntiSpam API-Schlüssel ist ungültig.', # Translate - New # OK


);

1;

