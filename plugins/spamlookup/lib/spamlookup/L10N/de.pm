# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package spamlookup::L10N::de;

use strict;
use warnings;

use base 'spamlookup::L10N::en_us';
use vars qw( %Lexicon );
%Lexicon = (

## plugins/spamlookup/lib/spamlookup.pm
	'Failed to resolve IP address for source URL [_1]' => 'Kann IP-Adresse der Quelladresse [_1] nicht auflösen',
	'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Moderation: Die IP-Adresse der Domain ([_2]) stimmt nicht mit der Ping-IP-Adresse ([_3]) überein. URL: [_1]',
	'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Die IP-Adresse der Domain ([_2]) stimmt nicht mit der Ping-IP-Adresse ([_3]) überein. URL: [_1]',
	'No links are present in feedback' => 'Keine Links enthalten',
	'Number of links exceed junk limit ([_1])' => 'Anzahl der Links übersteigt Spam-Schwellenwert ([_1] Links)',
	'Number of links exceed moderation limit ([_1])' => 'Anzahl der Links übersteigt Moderations-Schwellenwert ([_1] Links)',
	'Link was previously published (comment id [_1]).' => 'Link wurde bereits veröffentlicht (Kommentar [_1])',
	'Link was previously published (TrackBack id [_1]).' => 'Link wurde bereits veröffentlicht (TrackBack [_1])',
	'E-mail was previously published (comment id [_1]).' => 'E-Mail-Adresse wurde bereits veröffentlicht (Kommentar [_1])',
	'Word Filter match on \'[_1]\': \'[_2]\'.' => 'Schlüsselwortfilter angesprochen bei &#8222;[_1]&#8220;: &#8222;[_2]&#8220;.',
	'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'Moderierung: Schlüsselwortfilter angesprochen bei &#8222;[_1]&#8220;: &#8222;[_2]&#8220;.',
	'domain \'[_1]\' found on service [_2]' => 'Domain &#8222;[_1]&#8220;gefunden bei [_2]',
	'[_1] found on service [_2]' => '[_1] gefunden bei [_2]',

## plugins/spamlookup/spamlookup.pl
	'SpamLookup module for using blacklist lookup services to filter feedback.' => 'SpamLookup-Modul zur Nutzung von Sperrlisten zur Feedback-Überprüfung',
	'SpamLookup IP Lookup' => 'SpamLookup für IP-Adressen',
	'SpamLookup Domain Lookup' => 'SpamLookup für Domains',
	'SpamLookup TrackBack Origin' => 'SpamLookup für TrackBack-Herkunft',
	'Despam Comments' => 'Spam aus Kommentaren entfernen',
	'Despam TrackBacks' => 'Spam aus TrackBacks entfernen',
	'Despam' => 'Spam entfernen',

## plugins/spamlookup/spamlookup_urls.pl
	'SpamLookup module for junking and moderating feedback based on link filters.' => 'SpamLookup-Modul zur Überprüfung von Links in Feedback',
	'SpamLookup Link Filter' => 'SpamLookup zur Linkfilterung',
	'SpamLookup Link Memory' => 'SpamLookup zur Betrachtung bereits veröffentlichter Links',
	'SpamLookup Email Memory' => 'SpamLookup zur Betrachtung bereits veröffentlichter E-Mail-Adressen',

## plugins/spamlookup/spamlookup_words.pl
	'SpamLookup module for moderating and junking feedback using keyword filters.' => 'SpamLookup-Modul zur automatischen Einordnung von Feedback nach Schlüsselbegriffen zur Moderation oder als Spam.',
	'SpamLookup Keyword Filter' => 'SpamLookup Schlüsselbegriff-Filter',

## plugins/spamlookup/tmpl/lookup_config.tmpl
	q{Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the site's Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.} => q{Von eingehendem Feedback können die IP-Adressen und enthaltene Hyperlinks überprüft werden. Stammt ein eingehender Kommentar oder TrackBack von einer schwarzgelisteten IP-Adresse oder enthält er Links zu einer dort gelisteten Domain, kann er automatisch zur Moderation zurückgehalten oder in den Spam-Ordner der Site gelegt werden. Für TrackBacks sind zusätzliche Prüfungen möglich.},
	'IP Address Lookups' => 'Prüfen von IP-Adressen',
	'Moderate feedback from blacklisted IP addresses' => 'Feedback von schwarzgelisteten IP-Adressen moderieren',
	'Junk feedback from blacklisted IP addresses' => 'Feedback von schwarzgelisteten IP-Adressen als Spam ansehen',
	'Adjust scoring' => 'Gewichtung anpassen',
	'Score weight:' => 'Gewichtung',
	'block' => 'sperren',
	'IP Blacklist Services' => 'IP-Schwarzlisten',
	'Domain Name Lookups' => 'Prüfen von Domain-Namen',
	'Moderate feedback containing blacklisted domains' => 'Feedback von schwarzgelisteten Domains moderieren',
	'Junk feedback containing blacklisted domains' => 'Feedback von schwarzgelisteten Domains als Spam ansehen',
	'Domain Blacklist Services' => 'Domain-Schwarzlisten',
	'Advanced TrackBack Lookups' => 'Zusätzliche TrackBack-Prüfungen',
	'Moderate TrackBacks from suspicious sources' => 'TrackBacks aus dubiosen Quellen moderieren',
	'Junk TrackBacks from suspicious sources' => 'TrackBacks aus dubiosen Quellen als Spam ansehen',
	'Lookup Whitelist' => 'Weißliste',
	'To prevent lookups for specific IP addresses or domains, list each on a line by itself.' => 'Tragen Sie hier IP-Adressen und Domains ein, die nicht  geprüft werden sollen. Verwenden Sie pro Eintrag eine Zeile. ',

## plugins/spamlookup/tmpl/url_config.tmpl
	'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Die Anzahl der in eingehendem Feedback enthaltenen Hyperlinks kann kontrolliert werden. Feedback mit sehr vielen Links kann automatisch zur Moderation zurückgehalten oder als Spam angesehen werden. Umgekehrt kann Feedback, das gar keine Links enthält oder nur solche, die zuvor bereits freigegeben wurden, automatisch positiv bewertet werden.',
	'Link Limits' => 'Link-Schwellenwert',
	'Credit feedback rating when no hyperlinks are present' => 'Feedback ohne Hyperlinks positiv bewerten',
	'Moderate when more than' => 'Moderieren bei mehr als',
	'link(s) are given' => 'Link(s)',
	'Junk when more than' => 'Als Spam ansehen bei mehr als',
	'Link Memory' => 'Bereits veröffentlichte Links',
	'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Feedback positiv bewerten, wenn die Quelladresse (URL) bereits veröffentlicht wurde.',
	'Only applied when no other links are present in message of feedback.' => 'Nur anwenden, wenn keine anderen Links im Feedbacktext enthalten sind',
	'Exclude URLs from comments published within last [_1] days.' => 'URLs aus Kommentaren, die in den letzten [_1] Tagen veröffentlicht wurden, ausnehmen.',
	'Email Memory' => 'Bereits veröffentlichte E-Mail-Adressen',
	'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Feedback positiv bewerten, wenn bereits zuvor Kommentare von der gleichen E-Mail-Adresse veröffentlicht wurden.',
	'Exclude Email addresses from comments published within last [_1] days.' => 'E-Mail-Adressen aus Kommentaren, die in den letzten [_1] Tagen veröffentlicht wurden, ausnehmen.',

## plugins/spamlookup/tmpl/word_config.tmpl
	'Incoming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Eingehendes Feedback kann auf wählbare Schlüsselbegriffe, Domainnamen und Muster durchsucht werden. Feedback mit Treffern kann automatisch zur Moderation zurückgehalten oder als Spam angesehen werden.',
	'Keywords to Moderate' => 'Bei Auftreten dieser Schlüsselwörter Feedback moderieren',
	'Keywords to Junk' => 'Bei Auftreten dieser Schlüsselwörter Feedback als Spam ansehen',

);

1;
