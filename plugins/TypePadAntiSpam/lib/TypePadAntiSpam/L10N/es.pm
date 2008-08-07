# Movable Type (r) Open Source (C) 2005-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: ja.pm 81672 2008-05-26 10:30:44Z fyoshimatsu $

package TypePadAntiSpam::L10N::es;

use strict;
use base 'TypePadAntiSpam::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (

## plugins/TypePadAntiSpam/lib/MT/TypePadAntiSpam.pm
	'API key is a required parameter.' => 'La clave del API es un parámetro necesario.', # Translate - New

## plugins/TypePadAntiSpam/tmpl/system.tmpl
	'API Key' => 'Clave del API', # Translate - New
	'To enable this plugin, you\'ll need a free TypePad AntiSpam API key. You can <strong>get your free API key at [_1]antispam.typepad.com[_2]</strong>. Once you have your key, return to this page and enter it in the field below.' => 'Para habilitar esta extensión, necesita una clave gratuita del API de TypePad AntiSpam. Puede <strong>obtener su clave, gratis, en [_1]antispam.typepad.com[_2]</strong>. Tras obtenerla, regrese a esta página para introducir la clave en el campo de abajo.', # Translate - New
	'Service Host' => 'Servidor', # Translate - New
	'The default service host for TypePad AntiSpam is api.antispam.typepad.com. You should only change this if you are using a different service that is compatible with the TypePad AntiSpam API.' => 'El servidor predefinido para TypePad AntiSpam es api.antispam.typepad.com. Modifíquelo solo en el caso de utilizar otro servicio compatible con el API de TypePad AntiSpam.', # Translate - New

## plugins/TypePadAntiSpam/tmpl/config.tmpl
	'Junk Score Weight' => 'Peso de la puntuación', # Translate - New
	'Least Weight' => 'Peso mínimo', # Translate - New
	'Most Weight' => 'Peso máximo', # Translate - New
	'Comments and TrackBacks receive a junk score between -10 (definitely spam) and +10 (definitely not spam). This setting allows you to control the weight of the TypePad AntiSpam rating relative to other filters you may have installed to help you filter comments and TrackBacks.' => 'Los comentarios y los TrackBacks reciben una puntuación de basura entre -10 (realmente spam) y +10 (no es spam). Esta opción le permite controlar el peso de la puntuación de TypePad AntiSpam relativo a otros filtros que pudiera tener instalados para ayudarle a filtrar los comentarios y TrackBacks.', # Translate - New

## plugins/TypePadAntiSpam/tmpl/stats_widget.tmpl
	'widget_label_width' => 'widget_label_width', # Translate - New
	'widget_totals_width' => 'widget_totals_width', # Translate - New
	'TypePad AntiSpam' => 'TypePad AntiSpam', # Translate - New
	'Spam Blocked' => 'Spam bloqueado', # Translate - New
	'on this blog' => 'en este blog', # Translate - New
	'on this system' => 'en este sistema', # Translate - New

## plugins/TypePadAntiSpam/TypePadAntiSpam.pl
	'TypePad AntiSpam is a free service from Six Apart that helps protect your blog from comment and TrackBack spam. The TypePad AntiSpam plugin will send every comment or TrackBack submitted to your blog to the service for evaluation, and Movable Type will filter items if TypePad AntiSpam determines it is spam. If you discover that TypePad AntiSpam incorrectly classifies an item, simply change its classification by marking it as "Spam" or "Not Spam" from the Manage Comments screen, and TypePad AntiSpam will learn from your actions. Over time the service will improve based on reports from its users, so take care when marking items as "Spam" or "Not Spam."' => 'TypePad AntiSpam es un servicio gratuito de Six Apart. Le ayuda a proteger su blog del spam en los comentarios y en el TrackBack. La extensión de TypePad AntiSpam enviará al servicio todos los comentarios y TrackBacks que reciba su blog para analizarlos. Movable Type filtrará los elementos que TypePad AntiSpam identifique como spam. Si descubre que TypePad AntiSpam clasifica incorrectamente algún elemento, solo tiene que modificar la clasificación marcando al elemento como "Spam" o "No es spam" en la pantalla de administración de comentarios. TypePad AntiSpam aprenderá de sus decisiones. El servicio mejorará con el tiempo gracias a los informes remitidos por los usuarios, así que tenga cuidado al marcar lso elementos como "Spam" o como "No es spam".', # Translate - New
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] for this blog, and [quant,_2,message,messages] system-wide.' => 'Hasta ahora, TypePad AntiSpam ha bloqueado [quant,_1,mensaje,mensajes] en este blog y [quant,_2,mensaje,mensajes] en todo el sistema.', # Translate - New
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] system-wide.' => 'Hasta ahora, TypePad AntiSpam ha bloqueado [quant,_1,mensaje,mensajes] en todo el sistema.', # Translate - New
	'Failed to verify your TypePad AntiSpam API key: [_1]' => 'Fallo al verificar la clave API de TypePad AntiSpam: [_1]', # Translate - New
	'The TypePad AntiSpam API key provided is invalid.' => 'La clave API de TypePad AntiSpam no es válida.', # Translate - New


);

1;

