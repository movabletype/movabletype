# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package spamlookup::L10N::fr;

use strict;
use warnings;

use base 'spamlookup::L10N::en_us';
use vars qw( %Lexicon );
%Lexicon = (

## plugins/spamlookup/lib/spamlookup.pm
	'Failed to resolve IP address for source URL [_1]' => 'Échec de la vérification de l\'adresse IP pour l\'URL source [_1]',
	'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Modération : l\'IP du domaine ne correspond pas à l\'IP de ping pour l\'URL de la source [_1], IP du domaine : [_2], IP du ping : [_3]',
	'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'L\'IP du domaine ne correspond pas à l\'IP du ping pour l\'URL source [_1], l\'IP du domaine : [_2], IP du ping : [_3]',
	'No links are present in feedback' => 'Aucun lien n\'est présent dans le message',
	'Number of links exceed junk limit ([_1])' => 'Le nombre de liens a dépassé la limite de marquage comme spam ([_1])',
	'Number of links exceed moderation limit ([_1])' => 'Le nombre de liens a dépassé la limite de modération ([_1])',
	'Link was previously published (comment id [_1]).' => 'Le lien a été publié précédemment (ID de commentaire [_1]).',
	'Link was previously published (TrackBack id [_1]).' => 'Le lien a été publié précédemment (ID de trackback [_1]).',
	'E-mail was previously published (comment id [_1]).' => 'L\'e-mail a été publié précédemment (ID de commentaire [_1]).',
	'Word Filter match on \'[_1]\': \'[_2]\'.' => 'Le filtre de mot correspond sur \'[_1]\' : \'[_2]\'.',
	'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'Modération pour filtre de mot sur \'[_1]\' : \'[_2]\'.',
	'domain \'[_1]\' found on service [_2]' => 'domaine \'[_1]\' trouvé sur le service [_2]',
	'[_1] found on service [_2]' => '[_1] trouvé sur le service [_2]',

## plugins/spamlookup/spamlookup.pl
	'SpamLookup module for using blacklist lookup services to filter feedback.' => 'Module SpamLookup pour utiliser les services de vérification de liste noire pour filtrer les commentaires.',
	'SpamLookup IP Lookup' => 'SpamLookup vérification des IP',
	'SpamLookup Domain Lookup' => 'SpamLookup vérification des domaines',
	'SpamLookup TrackBack Origin' => 'SpamLookup origine des TrackBacks',
	'Despam Comments' => 'Commentaires non-spam',
	'Despam TrackBacks' => 'TrackBacks non-spam',
	'Despam' => 'Non-spam',

## plugins/spamlookup/spamlookup_urls.pl
	'SpamLookup module for junking and moderating feedback based on link filters.' => 'Module SpamLookup pour marquer comme spam et modérer les messages basé sur les filtres de liens.',
	'SpamLookup Link Filter' => 'SpamLookup filtre de lien',
	'SpamLookup Link Memory' => 'SpamLookup mémorisation des liens',
	'SpamLookup Email Memory' => 'SpamLookup mémorisation des emails',

## plugins/spamlookup/spamlookup_words.pl
	'SpamLookup module for moderating and junking feedback using keyword filters.' => 'Module SpamLookup pour modérer et marquer comme spam les messages en utilisant des filtres de mots-clés.',
	'SpamLookup Keyword Filter' => 'SpamLookup filtre de mots-clés',

## plugins/spamlookup/tmpl/lookup_config.tmpl
	q{Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the site's Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.} => q{Lookups surveille les adresses IP sources et les liens de tout feedback entrant. Si un commentaire ou un TrackBack provient d'une adresse ou d'un domaine en liste noire, il est retenu pour modération ou déclaré comme spam et placé dans le dossier spam du site. En outre, des vérifications avancées peuvent être faites sur les données TrackBack sources.},
	'IP Address Lookups' => 'Vérifier une adresse IP',
	'Moderate feedback from blacklisted IP addresses' => 'Modérer les commentaires/TrackBacks des adresses IP en liste noire',
	'Junk feedback from blacklisted IP addresses' => 'Marquer comme spam les commentaires/TrackBacks des adresses IP en liste noire',
	'Adjust scoring' => 'Ajuster la notation',
	'Score weight:' => 'Poids de la notation :',
	'block' => 'bloquer',
	q{IP Blacklist Services} => q{Services de liste noire d'IP},
	'Domain Name Lookups' => 'Vérifier un nom de domaine',
	'Moderate feedback containing blacklisted domains' => 'Modérer le contenu des messages contenant des domaines en liste noire',
	'Junk feedback containing blacklisted domains' => 'Marquer comme spam les messages contenant des domaines en liste noire',
	'Domain Blacklist Services' => 'Services de liste noire de domaines',
	'Advanced TrackBack Lookups' => 'Vérifications avancées des TrackBacks',
	'Moderate TrackBacks from suspicious sources' => 'Modérer les TrackBacks de sources suspectes',
	'Junk TrackBacks from suspicious sources' => 'Marquer comme spam les TrackBacks de sources suspectes',
	'Lookup Whitelist' => 'Vérifier la liste blanche',
	'To prevent lookups for specific IP addresses or domains, list each on a line by itself.' => 'Pour ne pas effectuer de vérifications pour des noms de domaines ou addresses IP spécifiques, listez-les ligne par ligne.',

## plugins/spamlookup/tmpl/url_config.tmpl
	q{Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)} => q{Les filtres de liens surveillent le nombre de liens hypertextes dans les messages entrants. Les messages avec beaucoup de liens peuvent être retenus pour modération ou marqués comme spam. Inversement, les messages qui ne contiennent pas de liens ou lient seulement vers des URLs publiées précédemment peuvent être notés positivement. (N'activez cette option que si vous êtes sûr que votre site est déjà dépourvu de spam.)},
	'Link Limits' => 'Limite de liens',
	q{Credit feedback rating when no hyperlinks are present} => q{Créditer la notation du message quand aucun lien hypertexte n'est présent},
	'Moderate when more than' => 'Modérer quand plus de',
	'link(s) are given' => 'liens sont présents',
	'Junk when more than' => 'Marquer comme spam quand plus de',
	'Link Memory' => 'Mémorisation des liens',
	q{Credit feedback rating when &quot;URL&quot; element of feedback has been published before} => q{Créditer la notation du message quand l'élément &quot;URL&quot; du message a été publié précédemment},
	q{Only applied when no other links are present in message of feedback.} => q{Appliquer seulement quand aucun autre lien n'est présent quand le texte du message.},
	'Exclude URLs from comments published within last [_1] days.' => 'Exclure les URLs des commentaires publiés dans les [_1] derniers jours.',
	'Email Memory' => 'Mémorisation des e-mails',
	q{Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address} => q{Créditer la notation du message lorsque des commentaires publiés précédemment contenaient l'adresse &quot;e-mail&quot;},
	'Exclude Email addresses from comments published within last [_1] days.' => 'Exclure les adresses e-mail des commentaires publiés dans les [_1] derniers jours.',

## plugins/spamlookup/tmpl/word_config.tmpl
	'Incoming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Les messages entrant peuvent être analysés pour détecter des mots-clés spécifiques, des noms de domaines et des modèles. Les messages correspondants peuvent être retenus pour modération ou marqués comme spam. De plus, les notes de spam pour ces messages peuvent être personnalisées.',
	'Keywords to Moderate' => 'Mots-clés à modérer',
	'Keywords to Junk' => 'Mots-clés à marquer comme spam',

);

1;
