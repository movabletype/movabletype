# Movable Type (r) Open Source (C) 2005-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: ja.pm 81672 2008-05-26 10:30:44Z fyoshimatsu $

package TypePadAntiSpam::L10N::fr;

use strict;
use base 'TypePadAntiSpam::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (## plugins/TypePadAntiSpam/lib/MT/TypePadAntiSpam.pm
	'API key is a required parameter.' => 'La clé API est requise.',

## plugins/TypePadAntiSpam/tmpl/system.tmpl
	'API Key' => 'Clé API',
	'To enable this plugin, you\'ll need a free TypePad AntiSpam API key. You can <strong>get your free API key at [_1]antispam.typepad.com[_2]</strong>. Once you have your key, return to this page and enter it in the field below.' => 'Pour activer ce plugin, vous devez obtenir une clé API gratuite TypePad AntiSpam. Vous pouvez <strong>obtenir votre clé API gratuite sur [_1]antispam.typepad.com[_2]</strong>. Une fois votre clé obtenue, retournez sur cette page et entrez-là dans le champs ci-dessous.',
	'Service Host' => 'Hébergeur de service',
	'The default service host for TypePad AntiSpam is api.antispam.typepad.com. You should only change this if you are using a different service that is compatible with the TypePad AntiSpam API.' => 'L\'hébergeur de service par défaut pour TypePad AntiSpam est api.antispam.typepad.com. Vous ne devriez changer cela uniquement si vous utilisez un autre service compatible avec l\'API TypePad AntiSpam.',

## plugins/TypePadAntiSpam/tmpl/config.tmpl
	'Junk Score Weight' => 'Niveau du filtrage',
	'Least Weight' => 'Moins agressif',
	'Most Weight' => 'Plus agressif',
	'Comments and TrackBacks receive a junk score between -10 (definitely spam) and +10 (definitely not spam). This setting allows you to control the weight of the TypePad AntiSpam rating relative to other filters you may have installed to help you filter comments and TrackBacks.' => 'Les commentaires et trackbakcs reçoivent une note de spam entre - 10 (très forte probabilité d\'être du spam) et +10 (très forte probabilité de n\'être pas du spam). Ces paramètres vous permettent de contrôler la pondération du filtre de TypePad AntiSpam vis-à-vis des autres filtres que vous pouvez avoir installé pour vous aider à filtrer les commentaires et trackbacks.',

## plugins/TypePadAntiSpam/tmpl/stats_widget.tmpl
	'widget_label_width' => 'widget_label_width',
	'widget_totals_width' => 'widget_totals_width',
	'TypePad AntiSpam' => 'TypePad AntiSpam',
	'Spam Blocked' => 'Spam bloqué',
	'on this blog' => 'sur ce blog',
	'on this system' => 'sur ce système',

## plugins/TypePadAntiSpam/TypePadAntiSpam.pl
	'TypePad AntiSpam is a free service from Six Apart that helps protect your blog from comment and TrackBack spam. The TypePad AntiSpam plugin will send every comment or TrackBack submitted to your blog to the service for evaluation, and Movable Type will filter items if TypePad AntiSpam determines it is spam. If you discover that TypePad AntiSpam incorrectly classifies an item, simply change its classification by marking it as "Spam" or "Not Spam" from the Manage Comments screen, and TypePad AntiSpam will learn from your actions. Over time the service will improve based on reports from its users, so take care when marking items as "Spam" or "Not Spam."' => 'TypePad AntiSpam est un service gratuit de Six Apart vous aidant à protéger votre blog des commentaires et trackbacks de spam. Le plugin TypePad AntiSpam enverra chaque commentaire ou trackback reçu sur votre blog au service pour un évaluation et Movable Type filtrera les éléments si TypePad AntiSpam considère ces éléments comme étant du spam. Si vous découvrez un élément que TypePad AntiSpam a mal filtré, changez simplement sa classification en le marquant comme "Spam" ou "Non-spam" dans la page Gérer les commentaires et TypePad AntiSpam apprendra de vos actions. Le service s\'améliorera au fur et à mesure des notifications de ses utilisateurs, usez donc d\'une attention particulière lorsque vous marquez un élément comme étant du "spam" ou "non-spam".',
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] for this blog, and [quant,_2,message,messages] system-wide.' => 'Depuis le début, TypePad AntiSpam a bloqué [quant,_1,message,messages] sur ce blog et [quant,_2,message,messages] sur tout le système.',
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] system-wide.' => 'Depuis le début, TypePad AntiSpam a bloqué [quant,_1,message,messages] sur tout le système.',
	'Failed to verify your TypePad AntiSpam API key: [_1]' => 'Erreur lors de la vérification de votre clé API TypePad AntiSpam : [_1]',
	'The TypePad AntiSpam API key provided is invalid.' => 'La clé API TypePad AntiSpam entrée n\'est pas valide.',

);

1;

