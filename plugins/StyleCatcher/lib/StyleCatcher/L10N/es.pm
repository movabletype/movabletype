# Movable Type (r) Open Source (C) 2005-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package StyleCatcher::L10N::es;

use strict;
use base 'StyleCatcher::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'No se encontró el directorio mt-static. Por favor, configure el \'StaticFilePath\' para continuar.',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'No se pudo crear el directorio [_1] - Compruebe que el servidor web puede escribir en la carpeta \'themes\'.',
	'Error downloading image: [_1]' => 'Error descargando imagen: [_1]',
	'Successfully applied new theme selection.' => 'Se aplicó con éxito la nueva selección de estilo.',
	'Invalid URL: [_1]' => 'URL no válida: [_1]',

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a Style' => 'Seleccione un estilo',
	'3-Columns, Wide, Thin, Thin' => '3 columnas, ancha, delgada, delgada',
	'3-Columns, Thin, Wide, Thin' => '3 columnas, delgada, ancha, delgada',
	'2-Columns, Thin, Wide' => '2 columnas, delgada, ancha',
	'2-Columns, Wide, Thin' => '2 columnas, ancha, delgada',
	'2-Columns, Wide, Medium' => '2 columnas, ancha, media', # Translate - New
	'None available' => 'Ninguno disponible',
	'Applying...' => 'Aplicando...',
	'Apply Design' => 'Aplicar diseño',
	'Error applying theme: ' => 'Error aplicando tema:',
	'The selected theme has been applied, but as you have changed the layout, you will need to republish your blog to apply the new layout.' => 'Se ha aplicado el tema seleccionado, pero como la disposición ha cambiado, deberá republicar el blog para que se aplique la disposición.',
	'The selected theme has been applied!' => '¡Se ha aplicado el tema seleccionado!',
	'Error loading themes! -- [_1]' => '¡Error cargando temas! -- [_1]',
	'Stylesheet or Repository URL' => 'URL de la hoja de estilo o repositorio:',
	'Stylesheet or Repository URL:' => 'URL de la hoja de estilo o repositorio:',
	'Download Styles' => 'Descargar estilos',
	'Current theme for your weblog' => 'Estilo actual de su weblog',
	'Current Style' => 'Estilo actual',
	'Locally saved themes' => 'Estilos guardados localmente',
	'Saved Styles' => 'Estilos guardados',
	'Default Styles' => 'Estilos predefinidos',
	'Single themes from the web' => 'Estilos individuales del web',
	'More Styles' => 'Más estilos',
	'Selected Design' => 'Diseño seleccionado',
	'Layout' => 'Disposición',

## plugins/StyleCatcher/stylecatcher.pl
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.' => 'StyleCatcher le permite navegar fácilmente por los estilos y aplicarlos a su blog fácilmente. Para más información sobre los estilos de Movable Type, o para encontrar más repositorios de estilos, visite la página de <a href=\'http://www.sixapart.com/movabletype/styles\'>estilos de Movable Type</a>.',
	'MT 4 Style Library' => 'Librería de estilos de MT 4',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Una colección de estilos compatible con las plantillas predefinidas de Movable Type.',
	'MT 3 Style Library' => 'Librería de estilos de MT 3',
	'A collection of styles compatible with Movable Type 3.3+ default templates.' => 'Una colección de estilos compatible con las plantillas predefinidas de Movable 3.3+.',
	'Styles' => 'Estilos',
);

1;

