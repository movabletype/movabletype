 # WidgetManager plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
package WidgetManager::L10N::es;

use strict;
use base 'WidgetManager::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/WidgetManager/lib/WidgetManager/Plugin.pm
	'Can\'t find included template widget \'[_1]\'' => 'No se encontró la plantilla de widget \'[_1]\' incluída',
	'Cloning Widgets for blog...' => 'Clonar los Widgets para un blog...',

## plugins/WidgetManager/lib/WidgetManager/CMS.pm
	'Can\'t duplicate the existing \'[_1]\' Widget Manager. Please go back and enter a unique name.' => 'No se pudo duplicar el administrador de widgets existente \'[_1]\'. Por favor, regrese e introduzca un nombre único.',
	'Main Menu' => 'Menú principal',
	'Widget Manager' => 'Administrador de widgets',
	'New Widget Set' => 'Nuevo conjunto de widgets',

## plugins/WidgetManager/default_widgets/monthly_archive_dropdown.mtml
	'Select a Month...' => 'Seleccione un mes...',

## plugins/WidgetManager/default_widgets/category_archive_list.mtml

## plugins/WidgetManager/default_widgets/calendar.mtml
	'Monthly calendar with links to daily posts' => 'Calendario mensual con enlaces a los archivos diarios',
	'Sun' => 'Dom',
	'Mon' => 'Lun',
	'Tue' => 'Mar',
	'Wed' => 'Mié',
	'Thu' => 'Jue',
	'Fri' => 'Vie',
	'Sat' => 'Sáb',

## plugins/WidgetManager/default_widgets/recent_entries.mtml

## plugins/WidgetManager/default_widgets/current_author_monthly_archive_list.mtml

## plugins/WidgetManager/default_widgets/date_based_author_archives.mtml
	'Author Yearly Archives' => 'Archivos anuales por autor',
	'Author Weekly Archives' => 'Archivos semanales por autor',
	'Author Daily Archives' => 'Archivos diarios por autor',

## plugins/WidgetManager/default_widgets/main_index_meta_widget.mtml
	'This is a custom set of widgets that are conditioned to only appear on the homepage (or "main_index"). More info: [_1]' => 'Este es un conjunto personalizado de widgets creados para aparecer solo en la página de inicio (o "main_index"). Más información: [_1]',
	'Recent Comments' => 'Comentarios recientes',
	'Recent Assets' => 'Multimedia reciente',

## plugins/WidgetManager/default_widgets/syndication.mtml
	'Search results matching &ldquo;<$mt:SearchString$>&rdquo;' => 'Resultados de la búsqueda &ldquo;<$mt:SearchString$>&rdquo;',

## plugins/WidgetManager/default_widgets/current_category_monthly_archive_list.mtml

## plugins/WidgetManager/default_widgets/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] comentó en [_3]</a>: [_4]',

## plugins/WidgetManager/default_widgets/technorati_search.mtml
	'Technorati' => 'Technorati',
	'<a href=\'http://www.technorati.com/\'>Technorati</a> search' => 'Búsqueda en <a href=\'http://www.technorati.com/\'>Technorati</a>',
	'this blog' => 'este blog',
	'all blogs' => 'todos los blogs',
	'Blogs that link here' => 'Blogs que enlazan aquí',

## plugins/WidgetManager/default_widgets/monthly_archive_list.mtml

## plugins/WidgetManager/default_widgets/signin.mtml
	'You are signed in as ' => 'Se identificó como ',
	'You do not have permission to sign in to this blog.' => 'No tiene permisos para identificarse en este blog.',

## plugins/WidgetManager/default_widgets/pages_list.mtml

## plugins/WidgetManager/default_widgets/archive_meta_widget.mtml
	'This is a custom set of widgets that are conditioned to serve different content based upon what type of archive it is included. More info: [_1]' => 'Conjunto personalizado de widgets creado para mostrar contenidos diferentes según el tipo de archivo que incluye. Más información: [_1]',
	'Current Category Monthly Archives' => 'Archivos mensuales de la categoría actual',
	'Category Archives' => 'Archivos por categoría',

## plugins/WidgetManager/default_widgets/date_based_category_archives.mtml
	'Category Yearly Archives' => 'Archivos anuales por categoría',
	'Category Weekly Archives' => 'Archivos semanales por categoría',
	'Category Daily Archives' => 'Archivos diarios por categoría',

## plugins/WidgetManager/default_widgets/widgets.cfg
	'About This Page' => 'Página Sobre mi',
	'Current Author Monthly Archives' => 'Archivos mensuales del autor actual',
	'Calendar' => 'Calendario',
	'Creative Commons' => 'Creative Commons',
	'Home Page Widgets' => 'Widgets de la página de inicio',
	'Monthly Archives Dropdown' => 'Desplegable de archivos mensuales',
	'Page Listing' => 'Lista de páginas',
	'Powered By' => 'Powered By',
	'Syndication' => 'Sindicación',
	'Technorati Search' => 'Búsquedas en Technorati',
	'Date-Based Author Archives' => 'Archivos de autores por fecha',
	'Date-Based Category Archives' => 'Archivos de categorías por fecha',

## plugins/WidgetManager/default_widgets/creative_commons.mtml
	'This weblog is licensed under a' => 'Este weblog está licenciado bajo una',
	'Creative Commons License' => 'Licencia Creative Commons',

## plugins/WidgetManager/default_widgets/about_this_page.mtml

## plugins/WidgetManager/default_widgets/author_archive_list.mtml

## plugins/WidgetManager/default_widgets/powered_by.mtml

## plugins/WidgetManager/default_widgets/tag_cloud.mtml

## plugins/WidgetManager/default_widgets/recent_assets.mtml

## plugins/WidgetManager/default_widgets/search.mtml

## plugins/WidgetManager/tmpl/edit.tmpl
	'Edit Widget Set' => 'Editar widgets',
	'Please use a unique name for this widget set.' => 'Por favor, utilice un nombre único para este conjunto de widgets.',
	'You already have a widget set named \'[_1].\' Please use a unique name for this widget set.' => 'Ya tiene un conjunto de widgets llamado \'[_1].\'',
	'Your changes to the Widget Set have been saved.' => 'Se han guardado los cambios al conjunto de widgets.',
	'Set Name' => 'Nombre del conjunto',
	'Drag and drop the widgets you want into the Installed column.' => 'Arrastre y deje los widgets de su elección en la columna Instalada',
	'Installed Widgets' => 'Widgets instalados',
	'Available Widgets' => 'Widgets disponibles',
	'Save changes to this widget set (s)' => 'Guardar cambios de este conjunto de widgets (s)',

## plugins/WidgetManager/tmpl/list.tmpl
	'Widget Sets' => 'Conjuntos de widgets',
	'Widget Set' => 'Conjunto de widgets',
	'Delete selected Widget Sets (x)' => 'Borrar conjuntos de widgets seleccionados (x)',
	'Helpful Tips' => 'Consejos útiles',
	'To add a widget set to your templates, use the following syntax:' => 'Para añadir un conjunto de widgets a las plantillas, utilice la siguiente sintaxis:',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Nombre del conjunto de widgets&quot;$&gt;</strong>',
	'Edit Widget Templates' => 'Editar plantillas con widgets',
	'Your changes to the widget set have been saved.' => 'Se han guardado los cambios al conjunto de widgets.',
	'You have successfully deleted the selected widget set(s) from your blog.' => 'Borró con éxito los conjuntos de widgets seleccionados del blog.',
	'Create Widget Set' => 'Crear conjunto de widgets',
	'No Widget Sets could be found.' => 'Ningún grupo de widget ha sido encontrado',

## plugins/WidgetManager/WidgetManager.pl
	'Maintain your blog\'s widget content using a handy drag and drop interface.' => 'Mantenga el contenido widget de su blog usando la interfaz práctica arrastrar y dejar.',
	'Widgets' => 'Widgets',
);
1;

