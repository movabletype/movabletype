# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id:$

package MT::L10N::es;
use strict;
use warnings;
use utf8;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

## The following is the translation table.

%Lexicon = (

## addons/Commercial.pack/config.yaml
	'Are you sure you want to delete the selected CustomFields?' => '¿Está seguro de que desea borrar los campos personalizados seleccionados?',
	'Child Site' => 'Sitio hijo',
	'No Name' => 'Sin nombre',
	'Required' => 'Necesario',
	'Site' => 'Sitio',

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Create Custom Field' => 'Crear campo personalizado',
	'Custom Fields' => 'Campos personalizados',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'Personalice los formularios y campos de las entradas, páginas, carpetas, categorías y usuarios, guardando los datos exactos que necesite.',
	'Movable Type' => 'Movable Type',
	'Permission denied.' => 'Permiso denegado.',
	'Please ensure all required fields have been filled in.' => 'Por favor, asegúrese de que todos los campos se han introducido.',
	'Please enter valid URL for the URL field: [_1]' => 'Por favor, introduzca una URL válida en el campo de la URL: [_1]',
	'Saving permissions failed: [_1]' => 'Fallo guardando permisos: [_1]',
	'View image' => 'Ver imagen',
	'You must select other type if object is the comment.' => 'Debe seleccionar otro tipo si el objeto es un comentario.',
	'blog and the system' => 'blog y el sistema',
	'blog' => 'Blog',
	'type' => 'tipo',
	'website and the system' => 'sitio y el sistema',
	'website' => 'sitio web',
	q{Invalid date '[_1]'; dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Fecha no válida '[_1]'; las fechas deben estar en el formato YYYY-MM-DD HH:MM:SS.},
	q{Please enter some value for required '[_1]' field.} => q{Por favor, introduzca un valor en el campo obligatorio '[_1]'.},
	q{The basename '[_1]' is already in use. It must be unique within this [_2].} => q{El nombre base '[_1]' ya está en uso. Debe ser único en este [_2].},
	q{The template tag '[_1]' is already in use.} => q{La etiqueta de plantilla '[_1]' ya está en uso.},
	q{The template tag '[_1]' is an invalid tag name.} => q{La etiqueta de plantilla '[_1]' es un nombre de etiqueta inválido.},
	q{[_1] '[_2]' (ID:[_3]) added by user '[_4]'} => q{[_1] '[_2]' (ID:[_3]) added by user '[_4]'},
	q{[_1] '[_2]' (ID:[_3]) deleted by '[_4]'} => q{[_1] '[_2]' (ID:[_3]) borrada por '[_4]'},

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Done.' => 'Hecho.',
	'Importing asset associations found in custom fields ( [_1] ) ...' => 'Importando las asociaciones de ficheros multimedia que se encuentran en los campos personalizados ( [_1]) ...',
	'Importing custom fields data stored in MT::PluginData...' => 'Importando los datos de los campos personalizados guardados en MT::PluginData',
	'Importing url of the assets associated in custom fields ( [_1] )...' => 'Importando las URLs de los ficheros multimedia asociados a los campos personalizados ( [_1] )...',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback.pm
	'Please enter valid option for the [_1] field: [_2]' => 'Por favor, introduzca una opción válida para el campo [_1]: [_2]',
	q{Invalid date '[_1]'; dates should be real dates.} => q{Fecha no válida '[_1]'; debe ser una fecha real.},

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback/Field.pm
	'A parameter "[_1]" is required.' => 'Se requiere un parámetro "[_1]".',
	'The systemObject "[_1]" is invalid.' => 'El systemObject "[_1]" no es válido.',
	'The type "[_1]" is invalid.' => 'El tipo "[_1]" no es válido.',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Endpoint/v2/Field.pm
	'Invalid includeShared parameter provided: [_1]' => 'Parámetro de includeShare no válido: [_1]',
	'Removing [_1] failed: [_2]' => 'Falló el borrado de [_1]: [_2]',
	'Saving [_1] failed: [_2]' => 'Falló al guardar [_1]: [_2]',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'Field' => 'Campo',
	'Fields' => 'Campos',
	'System Object' => 'Objeto del sistema',
	'Type' => 'Tipo',
	'_CF_BASENAME' => 'Nombre base',
	'__CF_REQUIRED_VALUE__' => 'Valor',
	q{The '[_1]' of the template tag '[_2]' that is already in use in [_3] is [_4].} => q{El '[_1]' de la etiqueta de plantilla '[_2]' que ya está en uso en [_3] es [_4].},
	q{The template tag '[_1]' is already in use in [_2]} => q{La etiqueta de plantilla '[_1]' ya está en uso en [_2]},
	q{The template tag '[_1]' is already in use in the system level} => q{La etiqueta de plantilla '[_1]' ya está en uso a nivel del sistema.},
	q{The template tag '[_1]' is already in use in this blog} => q{La etiqueta de plantilla '[_1]' ya está uso en este blog},

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	q{Are you sure you have used a '[_1]' tag in the correct context? We could not find the [_2]} => q{¿Está seguro de que ha utilizado la etiqueta '[_1]' en el contexto adecuado? No se encontró el [_2]},
	q{You used an '[_1]' tag outside of the context of the correct content; } => q{Ha utilizado una etiqueta '[_1]' fuera del contexto del contenido correcto;},

## addons/Commercial.pack/lib/CustomFields/Theme.pm
	'Conflict of [_1] "[_2]" with [_3]' => 'Conflicto entre [_1] "[_2]" y [_3]',
	'a field on system wide' => 'un campo en todo el sistema',
	'a field on this blog' => 'un campo en este blog',

## addons/Commercial.pack/lib/CustomFields/Util.pm
	'Cloning fields for blog:' => 'Clonando campos para el blog:',
	'[_1] records processed.' => 'Procesados [_1] registros.',
	'[_1] records processed...' => 'Procesados [_1] registros...',

## addons/Enterprise.pack/lib/MT/Enterprise/Author.pm
	'Loading MT::LDAP failed: [_1].' => 'Falló la carga de MT::LDAP: [_1].',

## addons/Enterprise.pack/lib/MT/Enterprise/BulkCreation.pm
	'A user with the same name was found.  The registration was not processed: [_1]' => 'Se encontró un usuario con el mismo nombre. No se procesó el registro: [_1]',
	'Formatting error at line [_1]: [_2]' => 'Error de formato en la línea [_1]: [_2]',
	'Invalid command: [_1]' => 'Orden inválida',
	'Invalid display name: [_1]' => 'Nombre mostrado inválido: [_1]',
	'Invalid email address: [_1]' => 'Dirección de correo no válida: [_1]',
	'Invalid language: [_1]' => 'Idioma no válido: [_1]',
	'Invalid number of columns for [_1]' => 'Número de columnas para [_1] inválido',
	'Invalid password: [_1]' => 'Contraseña inválida: [_1]',
	'Invalid user name: [_1]' => 'Nombre de usuario inválido: [_1]',
	'User cannot be created: [_1].' => 'No se pudo crear al usuario: [_1].',
	'User cannot be updated: [_1].' => 'Usuario no puede ser actualizado [_1].',
	q{Permission granted to user '[_1]'} => q{Los derechos han sido atribuidos al usuario [_1]},
	q{User '[_1]' already exists. The update was not processed: [_2]} => q{El usuario '[_1]' ya existe. No se ha procesado la actualización: [_2]},
	q{User '[_1]' has been created.} => q{El usuario '[_1]' ha sido creado},
	q{User '[_1]' has been deleted.} => q{El usuario [_1] ha sido borrado.},
	q{User '[_1]' has been updated.} => q{Usuario [_1] ha sido actualizado.},
	q{User '[_1]' not found.  The deletion was not processed.} => q{No se encontró al usuario '[_1]'. El borrado no ha sido procesado.},
	q{User '[_1]' not found.  The update was not processed.} => q{No se encontró al usuario '[_1]'. No se ha procesado la actualización.},
	q{User '[_1]' was found, but the deletion was not processed} => q{Se encontró al usuario '[_1]' pero el borrado no se ha procesado},

## addons/Enterprise.pack/lib/MT/Enterprise/CMS.pm
	'(no reason given)' => '(ninguna razón ofrecida)',
	'A user cannot change his/her own username in this environment.' => 'Un usuario no puede cambiar su propio nombre en este contexto.',
	'An error occurred when enabling this user.' => 'Ocurrió un error cuando se habilitaba este usuario.',
	'Bulk author export cannot be used under external user management.' => 'No se puede usar la exportación en lote de autores bajo la administración externa de usuario.',
	'Bulk import cannot be used under external user management.' => 'La importación masiva no puede ser usuada en la administración de usuarios externos.',
	'Bulk management' => 'Administración masiva',
	'Cannot rewind' => 'No se pudo reiniciar',
	'Load failed: [_1]' => 'Fallo carga: [_1]',
	'No records were found in the file.  Make sure the file uses CRLF as the line-ending characters.' => 'No se encontraron registros en el fichero. Asegúrese de que el fichero usa CRLF como caracteres de final de línea.',
	'Please select a file to upload.' => 'Por favor, seleccione el fichero a transferir',
	'Registered [quant,_1,user,users], updated [quant,_2,user,users], deleted [quant,_3,user,users].' => '[quant,_1,Usuario registro,Usuariosregistrados], [quant,_2,usuario actualizado,usuarios actualizados], [quant,_3,usuario eliminado,usuarios eliminados].',
	'Users & Groups' => 'Usuarios y grupos',
	'Users' => 'Usuarios',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/Group.pm
	'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute being set.' => 'No se puede realizar la sincronización de grupos sin configurar LDAPGroupIdAttribute y/o LDAPGroupNameAttribute.',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/User.pm
	'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'Un intento de desactivación de todos los administradores del sistema ha sido efectuada.  La sincronización de los usuarios ha sido interrumpida.',

## addons/Enterprise.pack/lib/MT/Enterprise/Upgrade.pm
	'Fixing binary data for Microsoft SQL Server storage...' => 'Reparando datos binarios para Microsoft SQL Server...',

## addons/Enterprise.pack/lib/MT/Enterprise/Wizard.pm
	'CRAM-MD5' => 'CRAM-MD5',
	'Digest-MD5' => 'Digest-MD5',
	'Found' => 'Encontrado',
	'Login' => 'Login',
	'Not Found' => 'No encontrado',
	'PLAIN' => 'PLAIN',

## addons/Enterprise.pack/lib/MT/LDAP.pm
	'Binding to LDAP server failed: [_1]' => 'La asociación con el server LDAP ha fallado: [_1]',
	'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'Su sistema o no tiene [_1] instalado, la versión instalada es antigua, o [_1] necesita otro módulo que no está instalado.',
	'Entry not found in LDAP: [_1]' => 'Entrada no encontrada en LDAP: [_1]',
	'Error connecting to LDAP server [_1]: [_2]' => 'Error a la conexión al server LDAP [_1]: [_2]',
	'Invalid LDAPAuthURL scheme: [_1].' => 'Scheme LDAPAuthURL inválido: [_1].',
	'More than one user with the same name found in LDAP: [_1]' => 'Se encontró en LDAP a más de un usuario con el mismo nombre: [_1]',
	'User not found in LDAP: [_1]' => 'No se encontró al usuario en LDAP: [_1]',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/MSSQLServer.pm
	'PublishCharset [_1] is not supported in this version of the MS SQL Server Driver.' => 'En esta versión del controlador de MS SQL Server PublishCharset [_1] no está soportado.',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/UMSSQLServer.pm
	'This version of UMSSQLServer driver requires DBD::ODBC compiled with Unicode support.' => 'Esta versión del Driver UMSSQLServer requiere DBD::ODBC compilado con el soporte Unicode.',
	'This version of UMSSQLServer driver requires DBD::ODBC version 1.14.' => 'Esta versión del Driver UMSSQLServer requiere DBD::ODBC versión 1.14.',

## addons/Sync.pack/lib/MT/FileSynchronizer.pm
	'Cannot load template.' => 'No se pudo cargar la plantilla.',
	'Error sending mail ([_1]); try another MailTransfer setting?' => 'Error al enviar el correol ([_1]); ¿Intente otra configuración de MailTransfer?',
	q{Cannot find author for id '[_1]'} => q{No se pudo encontrar al autor con el id '[_1]'},

## addons/Sync.pack/lib/MT/FileSynchronizer/Rsync.pm
	'Error during rsync: Command (exit code [_1]): [_2]' => 'Error durante rsync: Comando (código de salida [_1]): [_2]',
	'Failed to remove "[_1]": [_2]' => 'Fallo al borrar "[_1]": [_2]',
	'Incomplete file copy to Temp Directory.' => 'Copia de fichero incompleta en el directorio temporal.',
	'Temp Directory [_1] is not writable.' => 'No se puede escribir en el directorio temporal [_1].',

## addons/Sync.pack/lib/MT/SyncFileList.pm
	'Sync file list' => 'Lista de ficheros para sincronizar',

## addons/Sync.pack/lib/MT/SyncLog.pm
	'*User deleted*' => '*Usuario borrado*',
	'Are you sure you want to reset the sync log?' => '¿Está seguro de que desea reiniciar el registro de sincronización?',
	'FTP' => 'FTP',
	'Invalid parameter.' => 'Parámetro no válido.',
	'Rsync' => 'Rsync',
	'Showing only ID: [_1]' => 'Mostrando solo ID: [_1]',
	'Sync Name' => 'Nombre de sincronización',
	'Sync Result' => 'Resultado de sincronización',
	'Sync Type' => 'Tipo de sincronización',
	'Trigger' => 'Inductor',
	'[_1] in [_2]: [_3]' => '[_1] en [_2]: [_3]',

## addons/Sync.pack/lib/MT/SyncSetting.pm
	'Sync settings' => 'Configuración de la sincronización',

## addons/Sync.pack/lib/MT/SyncStatus.pm
	'Sync Status' => '', # Translate - New

## addons/Sync.pack/lib/Sync/App/CMS.pm
	'Create Sync Setting' => 'Crear configuración de sincronización',
	'Deleting sync file list failed "[_1]": [_2]' => 'Falló el borrado de la lista de archivos de sincronización "[_1]": [_2]',
	'Invalid request.' => 'Petición no válida.',
	'Permission denied: [_1]' => 'Permiso denegado: [_1]',
	'Save failed: [_1]' => 'Fallo al guardar: [_1]',
	'Sync Settings' => 'Configuración de la sincronización',
	'The previous synchronization file list has been cleared. [_1] by [_2].' => 'Se eliminó la lista de archivos de sincronizaciones previas. [_1] por [_2].',
	'The sync setting with the same name already exists.' => 'Ya existe una configuración de sincronización con el mismo nombre.',
	'[_1] (copy)' => '', # Translate - New
	q{An error occurred while attempting to connect to the FTP server '[_1]': [_2]} => q{Ocurrió un error al intentar conectar con el servidor FTP '[_1]': [_2]},
	q{An error occurred while attempting to retrieve the current directory from '[_1]': [_2]} => q{}, # Translate - New
	q{An error occurred while attempting to retrieve the list of directories from '[_1]': [_2]} => q{}, # Translate - New
	q{Error saving Sync Setting. No response from FTP server '[_1]'.} => q{}, # Translate - New
	q{Sync setting '[_1]' (ID: [_2]) deleted by [_3].} => q{Configuración de sincrinización '[_1]' (ID: [_2]) borrada por [_3].},
	q{Sync setting '[_1]' (ID: [_2]) edited by [_3].} => q{Configuración de sincronización '[_1]' (ID: [_2]) editada por [_3].},

## addons/Sync.pack/lib/Sync/Upgrade.pm
	'Removing all jobs of contents sync...' => 'Eliminando todas las tareas de sincronización de contenidos...',

## addons/Sync.pack/tmpl/cfg_contents_sync.tmpl
	'Are you sure you want to remove this settings?' => '¿Está seguro de que desea eliminar estas opciones?',
	'Invalid date.' => 'Fecha no válida.',
	'Invalid time.' => 'Fecha no válida.',
	'Sync name is required.' => 'Debe indicar un nombre de sincronización.',
	'Sync name should be shorter than [_1] characters.' => 'El nombre de sincronización debe tener menos de [_1] caracteres.',
	'The sync date must be in the future.' => 'La fecha de sincronización debe ser futura.',
	'You must make one or more destination settings.' => 'Debe indicar una o más opciones de destino.',

## default_templates/about_this_page.mtml
	'<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> es el siguiente archivo.',
	'<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> es la siguiente categoría.',
	'<a href="[_1]">[_2]</a> is the next entry in this blog.' => '<a href="[_1]">[_2]</a> es la entrada siguiente en este blog.',
	'<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> es el archivo anterior.',
	'<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> es la categoría anterior.',
	'<a href="[_1]">[_2]</a> was the previous entry in this blog.' => '<a href="[_1]">[_2]</a> es la entrada anterior en este blog.',
	'About Archives' => 'Sobre los archivos',
	'About this Archive' => 'Sobre este archivo',
	'About this Entry' => 'Sobre esta entrada',
	'Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.' => 'Encontrará los contenidos recientes en la <a href="[_1]">página principal</a>. Consulte los <a href="[_2]">archivos</a> para ver todos los contenidos.',
	'Find recent content on the <a href="[_1]">main index</a>.' => 'Encontrará los contenidos recientes en la <a href="[_1]">página principal</a>.',
	'This page contains a single entry by [_1] published on <em>[_2]</em>.' => 'Esta página contiene una sola entrada realizada por [_1] y publicada el <em>[_2]</em>.',
	'This page contains links to all of the archived content.' => 'Esta página contiene enlaces a todos los contenidos archivados.',
	'This page is an archive of entries from <strong>[_2]</strong> listed from newest to oldest.' => 'Esta página es un archivo de las entradas de <strong>[_2]</strong>, ordenadas de nuevas a antiguas.',
	'This page is an archive of entries in the <strong>[_1]</strong> category from <strong>[_2]</strong>.' => 'Esta página es un archivo de las entradas en la categoría <strong>[_1]</strong> de <strong>[_2]</strong>.',
	'This page is an archive of recent entries in the <strong>[_1]</strong> category.' => 'Esta página es un archivo de las últimas entradas en la categoría <strong>[_1]</strong>.',
	'This page is an archive of recent entries written by <strong>[_1]</strong> in <strong>[_2]</strong>.' => 'Esta página es un archivo de las últimas entradas escritas por <strong>[_1]</strong> en <strong>[_2]</strong>.',
	'This page is an archive of recent entries written by <strong>[_1]</strong>.' => 'Esta página es un archivo de las últimas entradas escritas por <strong>[_1]</strong>.',

## default_templates/archive_index.mtml
	'Archives' => 'Archivos',
	'Author Archives' => 'Archivos por autor',
	'Author Monthly Archives' => 'Archivos mensuales por autores',
	'Banner Footer' => 'Logotipo del pie',
	'Banner Header' => 'Logotipo de la cabecera',
	'Categories' => 'Categorías',
	'Category Monthly Archives' => 'Archivos mensuales por categorías',
	'HTML Head' => 'HTML de la cabecera',
	'Monthly Archives' => 'Archivos mensuales',
	'Sidebar' => 'Barra lateral',

## default_templates/archive_widgets_group.mtml
	'Category Archives' => 'Archivos por categoría',
	'Current Category Monthly Archives' => 'Archivos mensuales de la categoría actual',
	'This is a custom set of widgets that serve different content depending on the type of archive in which it is included. More info: [_1]' => 'Este es un conjunto personalizado de widgets que muestran distinto contenido dependiendo del tipo de archivo en el que esté incluído. Más información: [_1]',

## default_templates/author_archive_list.mtml
	'Authors' => 'Autores',
	'[_1] ([_2])' => '[_1] ([_2])',

## default_templates/banner_footer.mtml
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Este blog tiene una <a href="[_1]">Licencia Creative Commons</a>.',
	'_POWERED_BY' => 'Motor <a href="https://www.movabletype.org/"><$MTProductName$></a>',

## default_templates/calendar.mtml
	'Fri' => 'Vie',
	'Friday' => 'Viernes',
	'Mon' => 'Lun',
	'Monday' => 'Lunes',
	'Monthly calendar with links to daily posts' => 'Calendario mensual con enlaces a los archivos diarios',
	'Sat' => 'Sáb',
	'Saturday' => 'Sábado',
	'Sun' => 'Dom',
	'Sunday' => 'Domingo',
	'Thu' => 'Jue',
	'Thursday' => 'Jueves',
	'Tue' => 'Mar',
	'Tuesday' => 'Martes',
	'Wed' => 'Mié',
	'Wednesday' => 'Miércoles',

## default_templates/category_entry_listing.mtml
	'Entry Summary' => 'Resumen de las entradas',
	'Main Index' => 'Inicio',
	'Recently in <em>[_1]</em> Category' => 'Novedades en la categoría <em>[_1]</em>',
	'[_1] Archives' => 'Archivos [_1]',

## default_templates/current_author_monthly_archive_list.mtml
	'[_1]: Monthly Archives' => '[_1]: Archivos mensuales',

## default_templates/current_category_monthly_archive_list.mtml
	'[_1]' => '[_1]',

## default_templates/date_based_author_archives.mtml
	'Author Daily Archives' => 'Archivos diarios por autor',
	'Author Weekly Archives' => 'Archivos semanales por autor',
	'Author Yearly Archives' => 'Archivos anuales por autor',

## default_templates/date_based_category_archives.mtml
	'Category Daily Archives' => 'Archivos diarios por categoría',
	'Category Weekly Archives' => 'Archivos semanales por categoría',
	'Category Yearly Archives' => 'Archivos anuales por categoría',

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'Página no encontrada',

## default_templates/entry.mtml
	'# Comments' => '# comentarios',
	'# TrackBacks' => '# TrackBacks',
	'1 Comment' => '1 comentario',
	'1 TrackBack' => '1 TrackBack',
	'By [_1] on [_2]' => 'Por [_1] el [_2]',
	'Comments' => 'Comentarios',
	'No Comments' => 'Sin comentarios',
	'No TrackBacks' => 'Sin trackbacks',
	'Tags' => 'Etiquetas',
	'Trackbacks' => 'Trackbacks',

## default_templates/entry_summary.mtml
	'Continue reading <a href="[_1]" rel="bookmark">[_2]</a>.' => 'Continúe leyendo <a href="[_1]" rel="bookmark">[_2]</a>.',

## default_templates/footer-email.mtml
	'Powered by Movable Type [_1]' => 'Powered by Movable Type [_1]',

## default_templates/javascript.mtml
	'Edit' => 'Editar',
	'Replying to <a href="[_1]" onclick="[_2]">comment from [_3]</a>' => 'Respondiendo al <a href="[_1]" onclick="[_2]">comentario de [_3]</a>',
	'Signing in...' => 'Iniciando sesión...',
	'Thanks for signing in, __NAME__. ([_1]sign out[_2])' => 'Gracias por identificarse, __NAME__. ([_1]salir[_2])',
	'The sign-in attempt was not successful; Please try again.' => 'El intento de registro no tuvo éxito; por favor, inténtelo de nuevo.',
	'You do not have permission to comment on this blog. ([_1]sign out[_2])' => 'No tiene permisos para comentar en este blog ([_1]cerrar sesión[_2])',
	'Your session has expired. Please sign in again to comment.' => 'La sesión ha caducado. Por favor, identifíquese de nuevo para comentar.',
	'[_1]Sign in[_2] to comment, or comment anonymously.' => 'Para comentar [_1]inicie una sesión[_2] o hágalo de forma anónima.',
	'[_1]Sign in[_2] to comment.' => '[_1]Iniciar una sesión[_2].',
	'[quant,_1,day,days] ago' => 'hace [quant,_1,día,días]',
	'[quant,_1,hour,hours] ago' => 'hace [quant,_1,hora,horas]',
	'[quant,_1,minute,minutes] ago' => 'hace [quant,_1,minute,minutes]',
	'moments ago' => 'hace unos momentos',

## default_templates/lockout-ip.mtml
	'IP Address: [_1]' => 'Dirección IP: [_1]',
	'Mail Footer' => 'Pie del correo',
	'Recovery: [_1]' => 'Recuperación: [_1]',
	'This email is to notify you that an IP address has been locked out.' => 'Este correo es para notificarle que se ha bloqueado una dirección IP.',

## default_templates/lockout-user.mtml
	'Display Name: [_1]' => 'Nombre: [_1]',
	'Email: [_1]' => 'Correo Electrónico: [_1]',
	'If you want to permit this user to participate again, click the link below.' => 'Si desea permitir que este usuario participe de nuevo, haga clic en el enlace de abajo.',
	'This email is to notify you that a Movable Type user account has been locked out.' => 'Este correo es para notificarle que se ha bloqueado una cuenta de usuario de Movable Type.',
	'Username: [_1]' => 'Nombre de usuario: [_1]',

## default_templates/main_index_widgets_group.mtml
	'Recent Assets' => 'Multimedia reciente',
	'Recent Comments' => 'Comentarios recientes',
	'Recent Entries' => 'Entradas recientes',
	'Tag Cloud' => 'Nube de etiquetas',
	'This is a custom set of widgets that only appear on the homepage (or "main_index"). More info: [_1]' => 'Este conjunto de widgets sólo aparece en la página de inicio (o "main_index"). Más información: [_1]',

## default_templates/monthly_archive_dropdown.mtml
	'Select a Month...' => 'Seleccione un mes...',

## default_templates/monthly_archive_list.mtml
	'[_1] <a href="[_2]">Archives</a>' => '<a href="[_2]">Archivos</a> [_1]',

## default_templates/notify-entry.mtml
	'Message from Sender:' => 'Mensaje del expeditor',
	'Publish Date: [_1]' => 'Fecha de publicación: [_1]',
	'View entry:' => 'Ver entrada:',
	'View page:' => 'Ver página:',
	'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'Ha recibido este correo porque seleccionó recibir avisos sobre la publicación de nuevos contenidos en [_1] o porque el autor de la entrada pensó que podría serle de interés. Si no quiere recibir más avisos, por favor, contacte con esta persona:',
	'[_1] Title: [_2]' => '[_1] Título: [_2]',
	q{A new [lc,_3] entitled '[_1]' has been published to [_2].} => q{Un nuevo [lc,_3] titulado '[_1]' ha sido publicado en [_2].},

## default_templates/openid.mtml
	'Learn more about OpenID' => 'Más información sobre OpenID',
	'[_1] accepted here' => '[_1] aceptado aquí',
	'http://www.sixapart.com/labs/openid/' => 'http://www.sixapart.com/labs/openid/',

## default_templates/pages_list.mtml
	'Pages' => 'Páginas',

## default_templates/powered_by.mtml
	'_MTCOM_URL' => 'https://www.movabletype.com/',

## default_templates/recover-password.mtml
	'A request was made to change your Movable Type password. To complete this process click on the link below to select a new password.' => 'Se ha solicitado el cambio de su contraseña en Movable Type. Para completar el proceso, haga clic en el enlace de abajo y seleccione una nueva contraseña.',
	'If you did not request this change, you can safely ignore this email.' => 'Si no solicitó este cambio, ignore este mensaje.',

## default_templates/search.mtml
	'Search' => 'Buscar',

## default_templates/search_results.mtml
	'By default, this search engine looks for all of the specified words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Por defecto, el motor busca todas las palabras en cualquier orden. Para buscar una frase exacta, enciérrela con comillas:',
	'Instructions' => 'Instrucciones',
	'Next' => 'Siguiente',
	'No results found for &ldquo;[_1]&rdquo;.' => 'Ningún resultado encontrado para &ldquo;[_1]&rdquo;.',
	'Previous' => 'Anterior',
	'Results matching &ldquo;[_1]&rdquo;' => 'Resultados correspondiente a &ldquo;[_1]&rdquo;',
	'Results tagged &ldquo;[_1]&rdquo;' => 'Resultado de etiquetas &ldquo;[_1]&rdquo;',
	'Search Results' => 'Resultado de la búsqueda',
	'The search engine also supports the AND, OR, and NOT boolean operators:' => 'El motor de búsqueda también tiene soporte para los operadores lógicos AND, OR y NOT:',
	'movable type' => 'movable type',
	'personal OR publishing' => 'personal OR publicación',
	'publishing NOT personal' => 'publicación NOT personal',

## default_templates/sidebar.mtml
	'2-column layout - Sidebar' => 'Distribución de 2 columnas - Barra lateral',
	'3-column layout - Primary Sidebar' => 'Distribución de 3 columnas - Barra lateral principal',
	'3-column layout - Secondary Sidebar' => 'Distribución de 3 columnas - Barra lateral secundaria',

## default_templates/signin.mtml
	'Sign In' => 'Registrarse',
	'You are signed in as ' => 'Se identificó como ',
	'You do not have permission to sign in to this blog.' => 'No tiene permisos para identificarse en este blog.',
	'sign out' => 'salir',

## default_templates/syndication.mtml
	'Feed of results matching &ldquo;[_1]&ldquo;' => 'Sindicación de los resultados que coinciden con &ldquo;[_1]&ldquo;',
	'Feed of results tagged &ldquo;[_1]&ldquo;' => 'Sindicación de los resultados etiquetados con &ldquo;[_1]&ldquo;',
	'Subscribe to a feed of all future entries matching &ldquo;[_1]&ldquo;' => 'Subscribirse a las entradas que coinciden con &ldquo;[_1]&ldquo;',
	'Subscribe to a feed of all future entries tagged &ldquo;[_1]&ldquo;' => 'Suscribirse a las entradas etiquetadas con &ldquo;[_1]&ldquo;',
	'Subscribe to feed' => 'Suscribirse a la fuente de sindicación',
	q{Subscribe to this blog's feed} => q{Suscribirse a este blog (XML)},

## lib/MT.pm
	'AIM' => 'AIM',
	'An error occurred: [_1]' => 'Ocurrió un error: [_1]',
	'Bad CGIPath config' => 'Configuración de CGIPath incorrecta',
	'Bad LocalLib config ([_1]): [_2]' => 'Configuración LocalLib incorrecta ([_1]): [_2]',
	'Bad ObjectDriver config' => 'Configuración de ObjectDriver incorrecta',
	'Error while creating email: [_1]' => 'Error durante la creación del correo: [_1]',
	'Fourth argument to add_callback must be a CODE reference.' => 'El cuarto argumento de add_callback debe ser una referencia a un código.',
	'Google' => 'Google',
	'Hatena' => 'Hatena',
	'Hello, [_1]' => 'Hola, [_1]',
	'Hello, world' => 'Hola, mundo',
	'If it is present, the third argument to add_callback must be an object of type MT::Component or MT::Plugin' => 'Si está presente, el tercer argumento de add_callback debe ser un objeto de tipo MT::Component o MT::Plugin',
	'Internal callback' => 'Retrollamada interna',
	'Invalid priority level [_1] at add_callback' => 'Nivel de prioridad [_1] no válido en add_callback',
	'LiveJournal' => 'LiveJournal',
	'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Archivo de configuración no encontrado. ¿Quizás olvidó renombrar mt-config.cgi-original a mt-config.cgi?',
	'Movable Type default' => 'Predefinido de Movable Type',
	'OpenID' => 'OpenID',
	'Plugin error: [_1] [_2]' => 'Error en la extensión: [_1] [_2]',
	'Powered by [_1]' => 'Powered by [_1]',
	'Two plugins are in conflict' => 'Dos extensiones están en conflicto',
	'TypePad' => 'TypePad',
	'Unnamed plugin' => 'Extensión sin nombre',
	'Version [_1]' => 'Versión [_1]',
	'Vox' => 'Vox',
	'WordPress.com' => 'WordPress.com',
	'Yahoo! JAPAN' => 'Yahoo! JAPAN',
	'Yahoo!' => 'Yahoo!',
	'[_1] died with: [_2]' => '[_1] murió: [_2]',
	'https://www.movabletype.com/' => 'https://www.movabletype.com/',
	'https://www.movabletype.org/documentation/' => 'https://www.movabletype.org/documentation/',
	'livedoor' => 'livedoor',
	q{Loading template '[_1]' failed.} => q{Fallo cargando la plantilla '[_1]'.},

## lib/MT/AccessToken.pm
	'AccessToken' => 'Token de acceso',

## lib/MT/App.pm
	'(Display Name not set)' => '(Nombre no configurado)',
	'A user with the same name already exists.' => 'Ya existe un usuario con el mismo nombre.',
	'An error occurred while trying to process signup: [_1]' => 'Ocurrió un error intentando procesar el alta: [_1]',
	'Back' => 'Volver',
	'Cannot load blog #[_1]' => 'No se pudo cargar el blog #[_1]',
	'Cannot load blog #[_1].' => 'No se pudo cargar el blog #[_1].',
	'Cannot load entry #[_1].' => 'No se pudo cargar la entrada #[_1].',
	'Cannot load site #[_1].' => 'No se pudo cargar el sitio #[_1].',
	'Close' => 'Cerrar',
	'Display Name' => 'Nombre',
	'Email Address is invalid.' => 'La dirección de correo no es válida.',
	'Email Address is required for password reset.' => 'La dirección de correo es necesaria para el reinicio de contraseña.',
	'Email Address' => 'Dirección de correo electrónico',
	'Error sending mail: [_1]' => 'Error enviado correo: [_1]',
	'Failed login attempt by anonymous user' => '', # Translate - New
	'Failed to open pid file [_1]: [_2]' => 'Falló la apertura del fichero pid [_1]: [_2]',
	'Failed to send reboot signal: [_1]' => 'Falló el envío de la señal de reinicio: [_1]',
	'Internal Error: Login user is not initialized.' => 'Error interno: Inicio de sesión de usuarios no inicializada.',
	'Invalid login.' => 'Inicio de sesión no válido.',
	'Invalid request' => 'Petición no válida',
	'Our apologies, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Lo sentimos, pero no tiene permisos para acceder a ningún blog o sitio web en esta instalación. Si cree que este mensaje se le muestra por error, por favor, contacte con el administrador de la instalación de Movable Type.',
	'Password should be longer than [_1] characters' => 'La clave debe tener más de [_1] caracteres',
	'Password should contain symbols such as #!$%' => 'La clave debe contener símbolos como #!$%',
	'Password should include letters and numbers' => 'La clave debe incluir letras y números',
	'Password should include lowercase and uppercase letters' => 'La clave debe incluir letras en mayúsculas y minúsculas',
	'Password should not include your Username' => 'La clave no debe incluir el nombre de usuario',
	'Passwords do not match.' => 'Las contraseñas no coinciden.',
	'Problem with this request: corrupt character data for character set [_1]' => 'Problema con esta petición: dato corrupto de carácter para el conjunto de caracteres [_1]',
	'Removed [_1].' => 'Se eliminó [_1].',
	'Sorry, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Lo sentimos, pero no tiene permiso para acceder ninguno de los blogs o sitios web de esta intalación. Si cree que este mensaje se le muestra incorrectamente, por favor, contacte con el administrador de sistemas de Movable Type.',
	'System Email Address is not configured.' => 'La dirección de correo del sistema no está configurada.',
	'Text entered was wrong.  Try again.' => 'El texto que se ha introducido es incorrecto. Inténtelo de nuevo.',
	'The file you uploaded is too large.' => 'El fichero que transfirió es demasiado grande.',
	'The login could not be confirmed because of a database error ([_1])' => 'No se pudo confirmar el inicio de sesión por un error en la base de datos ([_1])',
	'This account has been deleted. Please see your Movable Type system administrator for access.' => 'Esta cuenta ha sido eliminada. Para acceder, por favor, contacte con el administrador de sistemas de Movable Type.',
	'This account has been disabled. Please see your Movable Type system administrator for access.' => 'Esta cuenta ha sido deshabilitada. Por favor, póngase en contacto con el administrador de sistemas de Movable Type.',
	'URL is invalid.' => 'La URL no es válida.',
	'Unknown action [_1]' => 'Acción desconocida [_1]',
	'Unknown error occurred.' => 'Ocurrió un error desconocido.',
	'User requires display name.' => 'El usuario necesita un pseudónimo.',
	'User requires password.' => 'El usuario necesita una contraseña.',
	'User requires username.' => 'El usuario necesita un nombre.',
	'Username' => 'Nombre de usuario',
	'Warnings and Log Messages' => 'Mensajes de alerta y registro',
	'You did not have permission for this action.' => 'No tenía permisos para realizar esta acción.',
	'[_1] contains an invalid character: [_2]' => '[_1] contiene un caracter no válido: [_2]',
	q{Failed login attempt by deleted user '[_1]'} => q{}, # Translate - New
	q{Failed login attempt by disabled user '[_1]'} => q{Inicio de sesión fallido por usuario deshabilitado '[_1]'},
	q{Failed login attempt by locked-out user '[_1]'} => q{}, # Translate - New
	q{Failed login attempt by pending user '[_1]'} => q{Intento fallido de inicio de sesión de un usuario pendiente '[_1]'},
	q{Failed login attempt by unknown user '[_1]'} => q{Inicio de sesión fallido por usuario desconocido '[_1]'},
	q{Failed login attempt by user '[_1]'} => q{}, # Translate - New
	q{Failed to open monitoring file that specified by IISFastCGIMonitoringFilePath directive '[_1]': [_2]} => q{Falló la apertura del fichero de monitorización especificado por la directiva IISFastCGIMonitoringFilePath '[_1]': [_2]},
	q{Invalid login attempt from user '[_1]'} => q{Intento de acceso no válido del usuario '[_1]'},
	q{New Comment Added to '[_1]'} => q{Nuevo comentario añadido en '[_1]'},
	q{User '[_1]' (ID:[_2]) logged in successfully} => q{Usuario '[_1]' (ID:[_2]) inició una sesión correctamente},
	q{User '[_1]' (ID:[_2]) logged out} => q{Usuario '[_1]' (ID:[_2]) se desconectó},

## lib/MT/App/ActivityFeeds.pm
	'All "[_1]" Content Data' => 'Todos los datos de contenido de "[_1]"',
	'All Activity' => 'Toda las actividades',
	'All Entries' => 'Todas las entradas',
	'All Pages' => 'Todas las páginas',
	'An error occurred while generating the activity feed: [_1].' => 'Ocurrió un error mientras se generaba la fuente de actividad: [_1].',
	'Error loading [_1]: [_2]' => 'Error cargando [_1]: [_2]',
	'Movable Type Debug Activity' => 'Actividad de depuración de Movable Type',
	'Movable Type System Activity' => 'Actividad del sistema de Movable Type',
	'No permissions.' => 'Sin permisos.',
	'[_1] "[_2]" Content Data' => 'Datos de contenido de [_1] "[_2]" ',
	'[_1] Activity' => '[_1] actividades',
	'[_1] Entries' => '[_1] entradas',
	'[_1] Pages' => '[_1] páginas',

## lib/MT/App/CMS.pm
	'Activity Log' => 'Actividad',
	'Add Contact' => 'Añadir contacto',
	'Add IP Address' => 'Añadir dirección IP',
	'Add Tags...' => 'Añadir etiquetas...',
	'Add a user to this [_1]' => 'Añadir este usuario a este [_1]',
	'Add user to group' => 'Añadir usuario a grupo',
	'Address Book' => 'Contactos',
	'Are you sure you want to delete the selected group(s)?' => '¿Está seguro de querer borrar el(los) grupo(s) seleccionados?',
	'Are you sure you want to remove the selected member(s) from the group?' => '¿Está seguro de querer borrar los miembros seleccionados del grupo?',
	'Are you sure you want to reset the activity log?' => '¿Está seguro de querer reiniciar el registro de actividad?',
	'Asset' => 'Multimedia',
	'Assets' => 'Multimedia',
	'Associations' => 'Asociaciones',
	'Batch Edit Entries' => 'Editar entradas en lote',
	'Batch Edit Pages' => 'Editar páginas en lote',
	'Blog' => 'Blog',
	'Cannot load blog (ID:[_1])' => 'No se pudo cargar el blog (ID:[_1])',
	'Category Sets' => 'Conjuntos de categorías',
	'Clear Activity Log' => 'Borrar el registro de actividad',
	'Clone Child Site' => 'Clonar sitio hijo',
	'Clone Template(s)' => 'Clonar plantilla/s',
	'Compose' => 'Componer',
	'Content Data' => 'Datos de contenido',
	'Content Types' => 'Tipos de contenido',
	'Create Role' => 'Crear rol',
	'Delete' => 'Eliminar',
	'Design' => 'Diseño',
	'Disable' => 'Desactivar',
	'Documentation' => 'Documentación',
	'Download Address Book (CSV)' => 'Descargar agenda de direcciones (CSV)',
	'Download Log (CSV)' => 'Descargar registro (CSV)',
	'Edit Template' => 'Editar plantilla',
	'Enable' => 'Activar',
	'Entries' => 'Entradas',
	'Entry' => 'Entrada',
	'Error during publishing: [_1]' => 'Error durante la publicación: [_1]',
	'Export Site' => 'Exportar sitio',
	'Export Sites' => 'Exportar sitios',
	'Export Theme' => 'Exportar tema',
	'Export' => 'Exportar',
	'Feedback' => 'Respuestas',
	'Feedbacks' => 'Respuestas',
	'Filters' => 'Filtros',
	'Folders' => 'Carpetas',
	'General' => 'General',
	'Grant Permission' => 'Otorgar permiso',
	'Groups ([_1])' => 'Grupos ([_1])',
	'Groups' => 'Grupos',
	'IP Banning' => 'Bloqueo de IPs',
	'Import Sites' => 'Importar sitios',
	'Import' => 'Importar',
	'Invalid parameter' => 'Parámetro no válido',
	'Manage Members' => 'Administrar miembros',
	'Manage' => 'Administrar',
	'Movable Type News' => 'Noticias de Movable Type',
	'Move child site(s) ' => 'Mover sitio/s hijo/s',
	'New' => 'Nuevo',
	'No such blog [_1]' => 'No existe el blog [_1]',
	'None' => 'Ninguno',
	'Notification Dashboard' => 'Panel de notificaciones',
	'Page' => 'Página',
	'Permissions' => 'Permisos',
	'Plugins' => 'Extensiones',
	'Profile' => 'Perfil',
	'Publish Template(s)' => 'Publicar plantilla/s',
	'Publish' => 'Publicar',
	'Rebuild Trigger' => 'Inductor de reconstrucción',
	'Rebuild' => 'Reconstruir',
	'Recover Password(s)' => 'Recuperar contraseña/s',
	'Refresh Template(s)' => 'Refrescar plantilla/s',
	'Refresh Templates' => 'Refrescar plantillas',
	'Remove Tags...' => 'Borrar entradas...',
	'Remove' => 'Borrar',
	'Revoke Permission' => 'Revocar permiso',
	'Roles' => 'Roles',
	'Search & Replace' => 'Buscar & Reemplazar',
	'Settings' => 'Configuración',
	'Sign out' => 'Salir',
	'Site List for Mobile' => 'Lista del sitio para móviles',
	'Site List' => 'Lista del sitio',
	'Site Stats' => 'Estadísticas del sitio',
	'Sites' => 'Sitios',
	'System Information' => 'Información del sistema',
	'Tags to add to selected assets' => 'Etiquetas a añadir a los ficheros multimedia seleccionados',
	'Tags to add to selected entries' => 'Etiquetas a añadir en las entradas seleccionadas',
	'Tags to add to selected pages' => 'Etiquetas a añadir a las páginas seleccionadas',
	'Tags to remove from selected assets' => 'Etiquetas a eliminar de los ficheros multimedia seleccionados',
	'Tags to remove from selected entries' => 'Etiquetas a borrar de las entradas seleccionadas',
	'Tags to remove from selected pages' => 'Etiquetas a eliminar de las páginas seleccionadas',
	'Themes' => 'Temas',
	'Tools' => 'Herramientas',
	'Unknown object type [_1]' => 'Tipo de objeto desconocido [_1]',
	'Unlock' => 'Desbloquear',
	'Unpublish Entries' => 'Despublicar entradas',
	'Unpublish Pages' => 'Despublicar páginas',
	'Updates' => 'Actualizaciones',
	'Upload' => 'Subir',
	'Use Publishing Profile' => 'Utilizar perfil de publicación',
	'User' => 'Usuario',
	'View Site' => 'Ver sitio',
	'Web Services' => 'Servicios web',
	'Website' => 'Website',
	'_WARNING_DELETE_USER' => 'El borrado de un usuario es una acción irreversible que crea huérfanos de las entradas del usuario. Si desea retirar a un usuario o bloquear su acceso al sistema, la forma recomendada es deshabilitar su cuenta. ¿Está seguro de que desea borrar el/los usuario/s seleccionado/s?',
	'_WARNING_DELETE_USER_EUM' => 'Borrar un usuario es una acción irreversible que crea huérfanos en las entradas del usuario. Si desea retirar un usuario o bloquear su acceso al sistema, se recomienda deshabilitar su cuenta. ¿Está seguro de que desea borrar a los usuarios seleccionados\nPodrán re-crearse a sí mismos si el usuario seleccionado existe en el directorio externo.',
	'_WARNING_PASSWORD_RESET_MULTI' => 'Va a reiniciar la contraseña de los usuarios seleccionados. Se generarán nuevas contraseñas aleatorias y se enviarán directamente a sus respectivas direcciones de correo electrónico.\n\n¿Desea continuar?',
	'_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' => 'Esta acción restablecerá las plantillas en los blogs seleccionados con la configuración de fábrica. ¿Está seguro de que desea reiniciar las plantillas de los blogs seleccionados?',
	'content data' => 'datos de contenido',
	'entry' => 'entrada',
	q{Failed login attempt by user who does not have sign in permission. '[_1]' (ID:[_2])} => q{Intento de inicio de sesión fallido por un usuario que no tiene permisos para ello. '[_1]' (ID:[_2]},
	q{[_1]'s Group} => q{Grupo de [_1]},

## lib/MT/App/CMS/Common.pm
	'Some websites were not deleted. You need to delete blogs under the website first.' => 'No se han eliminado algunos sitios. Primero debe borrar los blogs descendientes del sitio.',

## lib/MT/App/DataAPI.pm
	'[_1] must be a number.' => '[_1] debe ser un número.',
	'[_1] must be an integer and between [_2] and [_3].' => '[_1] debe ser un entero entre [_2] y [_3].',

## lib/MT/App/Search.pm
	'Failed to cache search results.  [_1] is not available: [_2]' => 'Fallo al cachear los resultados de la búsqueda.  [_1] no está disponible: [_2]',
	'Filename extension cannot be asp or php for these archives' => 'La extensión del fichero no puede ser asp o php para estos archivos',
	'Invalid [_1] parameter.' => 'Parámetro [_1] no válido',
	'Invalid archive type' => 'Tipo de archivo no válido',
	'Invalid format: [_1]' => 'Formato no válido: [_1]',
	'Invalid query: [_1]' => 'Consulta no válida: [_1]',
	'Invalid type: [_1]' => 'Tipo no válido: [_1]',
	'Invalid value: [_1]' => 'Valor no válido: [_1]',
	'No column was specified to search for [_1].' => 'No se especificó ninguna columna para la búsqueda de [_1].',
	'No such template' => 'No existe dicha plantilla',
	'Output file cannot be of the type asp or php' => 'El fichero de salida no puede ser de tipo asp o php',
	'Template must be a main_index for Index archive type' => 'La plantilla debe ser main_index para el tipo de archivo Índice',
	'Template must be archive listing for non-Index archive types' => 'La plantilla debe ser una lista de archivos para los tipos de archivo que no son índices',
	'The search you conducted has timed out.  Please simplify your query and try again.' => 'La búsqueda que realizaba sobrepasó el tiempo. Por favor, simplifique la consulta e inténtelo de nuevo.',
	'Unsupported type: [_1]' => 'Tipo no soportado: [_1]',
	'You must pass a valid archive_type with the template_id' => 'Debe indicar un archive_type válido con el template_id',
	'template_id cannot refer to a global template' => 'template_id no puede hacer referencia a una plantilla global',
	q{No alternate template is specified for template '[_1]'} => q{No se especificó una plantilla alternativa para la plantilla},
	q{Opening local file '[_1]' failed: [_2]} => q{Fallo abriendo el fichero local '[_1]': [_2]},
	q{Search: query for '[_1]'} => q{Búsqueda: encontrar '[_1]'},

## lib/MT/App/Search/ContentData.pm
	'Invalid SearchContentTypes "[_1]": [_2]' => 'SearchContentTypes no válido "[_1]": [_2]',
	'Invalid SearchContentTypes: [_1]' => 'SearchContentTypes no válido: [_1]',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearch funciona con MT::App::Search.',

## lib/MT/App/Upgrader.pm
	'Both passwords must match.' => 'Ambas contraseñas deben coincidir.',
	'Could not authenticate using the credentials provided: [_1].' => 'No se pudo autentificar con las credenciales provistas: [_1]',
	'Invalid session.' => 'Sesión no válida.',
	'Movable Type has been upgraded to version [_1].' => 'Movable Type ha sido actualizado a la versión [_1].',
	'No permissions. Please contact your Movable Type administrator for assistance with upgrading Movable Type.' => 'Sin permisos. Por favor, contacte con el administrador de Movable Type para obtener asistencia sobre la actualización.',
	'You must supply a password.' => 'Debe introducir una contraseña.',
	q{Invalid email address '[_1]'} => q{Dirección de correo no válida '[_1]'},
	q{The 'Website Root' provided below is not allowed} => q{No está permitido el 'Sitio web raíz' indicado abajo},
	q{The 'Website Root' provided below is not writable by the web server.  Change the ownership or permissions on this directory, then click 'Finish Install' again.} => q{El servidor web no puede escribir en el 'Sitio web raíz' indicado abajo. Modifique los permisos de su directorio y luego haga clic en 'Finalizar instalación'.},

## lib/MT/App/Wizard.pm
	'An error occurred while trying to connect to the database.  Check the settings and try again.' => 'Ocurrió un error intentando conectar a la base de datos. Compruebe la configuración e inténtelo de nuevo.',
	'CGI is required for all Movable Type application functionality.' => 'El CGI es requerido para todas las funciones del Sistema Movable Type.',
	'Cache::File is required if you would like to be able to allow commenters to be authenticated by Yahoo! Japan via OpenID.' => 'Cache::File es necesario si quiere permitir que los comentaristas se puedan autentificar en Yahoo! Japan via OpenID.',
	'DBI is required to work with most supported databases.' => 'DBI es necesario para trabajar con la mayoría de las bases de datos soportadas.',
	'Digest::SHA is required in order to provide enhanced protection of user passwords.' => 'Digest::SHA es necesario para ofrecer protección avanzada de las contraseñas de usuarios.',
	'File::Spec is required to work with file system path information on all supported operating systems.' => 'File::Spec es necesario para trabajar con las rutas del sistema de ficheros en todos los sistemas operativos.',
	'HTML::Entities is required by CGI.pm' => 'CGI.pm necesita HTML::Entities',
	'HTML::Parser is optional; It is needed if you want to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'HTML::Parser es opcional; Es necesario si desea usar el sistema de TrackBacks, el ping a weblogs.com o el ping a las actualizaciones recientes de MT.',
	'IO::Socket::SSL is required in all of the SSL/TLS connection, such as Google Analytics site statistics or SMTP Auth over SSL/TLS.' => 'IO::Socket::SSL es necesario para todas las conexiones SSL/TLS, como las estadísticas de Google Analytics o la autentificación SMTP mediante SSL/TLS.',
	'LWP::UserAgent is required for creating Movable Type configuration files using the installation wizard.' => 'LWP::UserAgent es necesario para crear ficheros de configuración de Movable Type mediante el asistente de instalación.',
	'List::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'Lista: Útiles opcionales; esto es necesario si usted desea utilizar la función cola de publicación',
	'Net::SMTP is required in order to send mail using an SMTP server.' => 'Net::SMTP es necesario para enviar correo usando un servidor SMTP.',
	'Net::SSLeay is required to use SMTP Auth over an SSL connection, or to use it with a STARTTLS command.' => 'Net::SSLeay es necesario para usar autentificación SMTP con una conexión SSL o con el comando STARTTLS.',
	'Please select a database from the list of available databases and try again.' => 'Por favor, seleccione una base de datos de la lista de base de datos disponibles e inténtelo de nuevo.',
	'SMTP Server' => 'Servidor SMTP',
	'Scalar::Util is required for initializing Movable Type application.' => 'Scalar::Util es necesario para inicializar la aplicación de Movable Type.',
	'Sendmail' => 'Sendmail',
	'Test email from Movable Type Configuration Wizard' => 'Mensaje de comprobación del asistente de configuración de Movable Type',
	'The [_1] database driver is required to use [_2].' => 'Es necesario el controlador de la base de datos [_1] para usar [_2].',
	'The [_1] driver is required to use [_2].' => 'Es necesario el controlador [_1] para usar [_2].',
	'This is the test email sent by your new installation of Movable Type.' => 'Este es el mensaje de comprobación enviado por su nueva instalación de Movable Type.',
	'This module accelerates comment registration sign-ins.' => 'Este módulo acelera el registro de identificación en los comentarios.',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.' => 'Este módulo y sus dependencias son necesarios para que los comentaristas se autentifiquen mediante proveedores OpenID, incluyendo LiveJournal.',
	'This module and its dependencies are required in order to restore from a backup.' => 'Este módulo y sus dependencias son necesarios para restaurar una copia de seguridad.',
	'This module and its dependencies are required in order to support CRAM-MD5, DIGEST-MD5 or LOGIN SASL mechanisms.' => 'Este módulo y sus dependencias son necesarios para dar soporte a los mecanismos CRAM-MD5, DIGEST-MD5 o LOGIN SASL.',
	'This module and its dependencies are required to run Movable Type under psgi.' => 'Este módulo y sus dependencias son necesarios para ejecutar Movable Type bajo psgi.',
	'This module enables the use of the Atom API.' => 'Este módulo permite el uso del interfaz (API) de Atom.',
	'This module is needed if you want to use the MT XML-RPC server implementation.' => 'Este módulo es necesario si desea usar la implementación del servidor XML-RCP de Movable Type.',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Este módulo es necesario si desea poder crear miniaturas de las imágenes subidas.',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Este módulo es necesario si desea poder sobreescribir los ficheros al subirlos.',
	'This module is needed if you would like to be able to use NetPBM as the image driver for MT.' => 'Este módulo es necesario si desea usar NetPBM como controlador de imágenes en MT.',
	'This module is needed to enable comment registration. Also required in order to send mail via an SMTP Server.' => 'Este módulo es necesario para habilitar el registro de comentaristas. También es necesario para enviar correos a través de un servidor SMTP.',
	'This module is required by certain MT plugins available from third parties.' => 'Este módulo lo necesitan algunas extensiones de MT de terceras partes.',
	'This module is required by mt-search.cgi if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'mt-search.cgi necesita este módulo si está usando Movable Type con una versión de Perl más antigua de la 5.8.',
	'This module is required for Google Analytics site statistics and for verification of SSL certificates.' => 'Este módulo es necesario para las estadísticas de Google Analytics y para la verificación de certificados SSL.',
	'This module is required for XML-RPC API.' => 'Este módulo es necesario para XML-RPC API.',
	'This module is required for cookie authentication.' => 'Este módulo es necsario para la autentificación con cookies.',
	'This module is required for executing run-periodic-tasks.' => 'Este módulo es necesario para la ejecución de run-periodic-tasks (tareas programadas).',
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Este módulo es necesario para subir archivos (para determinar el tamaño de las imágenes en diferentes formatos).',
	'This module is required in order to archive files in backup/restore operation.' => 'Este módulo es necesario para archivar ficheros en las operaciones de copias de seguridad y restauración.',
	'This module is required in order to compress files in backup/restore operation.' => 'Este módulo es ncesario para comprimir ficheros en operaciones de copias de seguridad y restauración.',
	'This module is required in order to decompress files in backup/restore operation.' => 'Este módulo es neesario para descomprimir ficheros en las operaciones de copia de seguridad y restauración.',
	'This module is required in order to use memcached as caching mechanism by Movable Type.' => 'Este módulo es necesario para que Movable Type use memcached como mecanismo de caché.',
	'This module is used by the Markdown text filter.' => 'El filtro de textos Markdown utiliza este módulo.',
	'This module is used in a test attribute for the MTIf conditional tag.' => 'La etiqueta condicional MTIf utiliza este módulo en un atributo de comprobación.',
	'XML::LibXML::SAX is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::LibXML::SAX es opcional; Es uno de los módulos necesarios para restaurar una copia de seguridad creada mediante la operación de copia de seguridad/restaurar.',
	'XML::SAX::Expat is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::SAX::Expat es opcional; Es uno de los módulos necesarios para restaurar una copia de seguridad creada mediante la operación de copia de seguridad/restaurar.',
	'XML::SAX::ExpatXS is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::SAX::ExpatXS es opcional; Es uno de los módulos necesarios para restaurar una copia de seguridad creada mediante la operación de copia de seguridad/restaurar.',
	'YAML::Syck is optional; It is a better, fast and lightweight alternative to YAML::Tiny for YAML file handling.' => 'YAML::Syck es opcional; Es una alternativa mejor, más rápida y ligera que YAML::Tiny para el manejo de ficheros YAML.',

## lib/MT/ArchiveType/Author.pm
	'AUTHOR_ADV' => 'Autor',
	'author/author-basename/index.html' => 'autor/autor-nombrebase/index.html',
	'author/author_basename/index.html' => 'autor/autor_nombrebase/index.html',

## lib/MT/ArchiveType/AuthorDaily.pm
	'AUTHOR-DAILY_ADV' => 'Diarios del autor',
	'author/author-basename/yyyy/mm/dd/index.html' => 'autor/autor-nombrebase/aaaa/mm/dd/index.html',
	'author/author_basename/yyyy/mm/dd/index.html' => 'autor/autor_nombrebase/yyyy/mm/dd/index.html',

## lib/MT/ArchiveType/AuthorMonthly.pm
	'AUTHOR-MONTHLY_ADV' => 'Mensuales del autor',
	'author/author-basename/yyyy/mm/index.html' => 'autor/autor-nombrebase/aaaa/mm/index.html',
	'author/author_basename/yyyy/mm/index.html' => 'autor/autor_nombrebase/aaaa/mm/index.html',

## lib/MT/ArchiveType/AuthorWeekly.pm
	'AUTHOR-WEEKLY_ADV' => 'Semanales del autor',
	'author/author-basename/yyyy/mm/day-week/index.html' => 'autor/autor-nombrebase/aaaa/mm/dia-semana/index.html',
	'author/author_basename/yyyy/mm/day-week/index.html' => 'autor/autor_nombrebase/aaa/mm/dia-semana/index.html',

## lib/MT/ArchiveType/AuthorYearly.pm
	'AUTHOR-YEARLY_ADV' => 'Anuales del autor',
	'author/author-basename/yyyy/index.html' => 'autor/autor-nombrebase/aaaa/index.html',
	'author/author_basename/yyyy/index.html' => 'autor/autor_nombrebase/aaaa/index.html',

## lib/MT/ArchiveType/Category.pm
	'CATEGORY_ADV' => 'Categoría',
	'category/sub-category/index.html' => 'categoría/sub-categoría/index.html',
	'category/sub_category/index.html' => 'categoría/sub_categoría/index.html',

## lib/MT/ArchiveType/CategoryDaily.pm
	'CATEGORY-DAILY_ADV' => 'Categorías diarias',
	'category/sub-category/yyyy/mm/dd/index.html' => 'categoría/sub-categoría/aaaa/mm/dd/index.html',
	'category/sub_category/yyyy/mm/dd/index.html' => 'categoría/sub_categoría/aaaa/mm/dd/index.html',

## lib/MT/ArchiveType/CategoryMonthly.pm
	'CATEGORY-MONTHLY_ADV' => 'Categorías mensuales',
	'category/sub-category/yyyy/mm/index.html' => 'categoría/sub-categoría/aaaa/mm/index.html',
	'category/sub_category/yyyy/mm/index.html' => 'categoría/sub_categoría/aaaa/mm/index.html',

## lib/MT/ArchiveType/CategoryWeekly.pm
	'CATEGORY-WEEKLY_ADV' => 'Categorías semanales',
	'category/sub-category/yyyy/mm/day-week/index.html' => 'categoría/sub-categoría/aaaa/mm/día-semana/index.html',
	'category/sub_category/yyyy/mm/day-week/index.html' => 'categoría/sub_categoría/aaaa/mm/día-semana/index.html',

## lib/MT/ArchiveType/CategoryYearly.pm
	'CATEGORY-YEARLY_ADV' => 'Categorías anuales',
	'category/sub-category/yyyy/index.html' => 'categoría/sub-categoría/aaaa/index.html',
	'category/sub_category/yyyy/index.html' => 'categoría/sub_categoría/aaaa/index.html',

## lib/MT/ArchiveType/ContentType.pm
	'CONTENTTYPE_ADV' => 'ContentType',
	'author/author-basename/content-basename.html' => 'autor/nombre-autor/nombre-contenido.html',
	'author/author-basename/content-basename/index.html' => 'autor/nombre-autor/nombre-contenido/index.html',
	'author/author_basename/content_basename.html' => 'autor/nombre_autor/nombre_contenido.html',
	'author/author_basename/content_basename/index.html' => 'autor/nombre_autor/nombre_contenido/index.html',
	'category/sub-category/content-basename.html' => 'categoría/sub-categoria/nombre-contenido.html',
	'category/sub-category/content-basename/index.html' => 'categoría/sub-categoria/nombre-contenido/index.html',
	'category/sub_category/content_basename.html' => 'categoría/sub_categoria/nombre_contenido.html',
	'category/sub_category/content_basename/index.html' => 'categoría/sub_categoria/nombre_contenido/index.html',
	'yyyy/mm/content-basename.html' => 'aaaa/mm/nombre-contentido.html',
	'yyyy/mm/content-basename/index.html' => 'aaaa/mm/nombre-contenido/index.html',
	'yyyy/mm/content_basename.html' => 'aaaa/mm/nombre_contenido.html',
	'yyyy/mm/content_basename/index.html' => 'aaaa/mm/nombre_contenido/index.html',
	'yyyy/mm/dd/content-basename.html' => 'aaaa/mm/dd/nombre-contenido.html',
	'yyyy/mm/dd/content-basename/index.html' => 'aaaa/mm/dd/nombre-contenido/index.html',
	'yyyy/mm/dd/content_basename.html' => 'aaaa/mm/dd/nombre_contenido.html',
	'yyyy/mm/dd/content_basename/index.html' => 'aaa/mm/dd/nombre_contenido/index.html',

## lib/MT/ArchiveType/ContentTypeAuthor.pm
	'CONTENTTYPE-AUTHOR_ADV' => 'ContentType autor',

## lib/MT/ArchiveType/ContentTypeAuthorDaily.pm
	'CONTENTTYPE-AUTHOR-DAILY_ADV' => 'ContentType autor diario',

## lib/MT/ArchiveType/ContentTypeAuthorMonthly.pm
	'CONTENTTYPE-AUTHOR-MONTHLY_ADV' => 'ContentType autor mensual',

## lib/MT/ArchiveType/ContentTypeAuthorWeekly.pm
	'CONTENTTYPE-AUTHOR-WEEKLY_ADV' => 'ContentType autor semanal',

## lib/MT/ArchiveType/ContentTypeAuthorYearly.pm
	'CONTENTTYPE-AUTHOR-YEARLY_ADV' => 'ContenType autor anual',

## lib/MT/ArchiveType/ContentTypeCategory.pm
	'CONTENTTYPE-CATEGORY_ADV' => 'ContentType categoría',

## lib/MT/ArchiveType/ContentTypeCategoryDaily.pm
	'CONTENTTYPE-CATEGORY-DAILY_ADV' => 'ContentType categoría diario',

## lib/MT/ArchiveType/ContentTypeCategoryMonthly.pm
	'CONTENTTYPE-CATEGORY-MONTHLY_ADV' => 'ContentType categoría mensual',

## lib/MT/ArchiveType/ContentTypeCategoryWeekly.pm
	'CONTENTTYPE-CATEGORY-WEEKLY_ADV' => 'ContentType categoría semanal',

## lib/MT/ArchiveType/ContentTypeCategoryYearly.pm
	'CONTENTTYPE-CATEGORY-YEARLY_ADV' => 'ContentType categoría anual',

## lib/MT/ArchiveType/ContentTypeDaily.pm
	'CONTENTTYPE-DAILY_ADV' => 'ContentType diario',
	'DAILY_ADV' => 'Diarias',
	'yyyy/mm/dd/index.html' => 'aaaa/mm/dd/index.html',

## lib/MT/ArchiveType/ContentTypeMonthly.pm
	'CONTENTTYPE-MONTHLY_ADV' => 'ContenType mensual',
	'MONTHLY_ADV' => 'Mensuales',
	'yyyy/mm/index.html' => 'aaaa/mm/index.html',

## lib/MT/ArchiveType/ContentTypeWeekly.pm
	'CONTENTTYPE-WEEKLY_ADV' => 'ContentType semanal',
	'WEEKLY_ADV' => 'Semanales',
	'yyyy/mm/day-week/index.html' => 'aaaa/mm/día-de-la-semana/index.html',

## lib/MT/ArchiveType/ContentTypeYearly.pm
	'CONTENTTYPE-YEARLY_ADV' => 'ContentType anual',
	'YEARLY_ADV' => 'Anuales',
	'yyyy/index.html' => 'aaaa/index.html',

## lib/MT/ArchiveType/Individual.pm
	'INDIVIDUAL_ADV' => 'Inidivual',
	'category/sub-category/entry-basename.html' => 'categoría/sub-categoría/título-entrada.html',
	'category/sub-category/entry-basename/index.html' => 'categoría/sub-categoría/título-entrada/index.html',
	'category/sub_category/entry_basename.html' => 'categoría/sub_categoría/título_entrada.html',
	'category/sub_category/entry_basename/index.html' => 'categoría/sub_categoría/título_entrada/index.html',
	'yyyy/mm/dd/entry-basename.html' => 'aaaa/mm/dd/título-entrada.html',
	'yyyy/mm/dd/entry-basename/index.html' => 'aaaa/mm/dd/título-entrada/index.html',
	'yyyy/mm/dd/entry_basename.html' => 'aaaa/mm/dd/título_entrada.html',
	'yyyy/mm/dd/entry_basename/index.html' => 'aaaa/mm/dd/título_entrada/index.html',
	'yyyy/mm/entry-basename.html' => 'aaaa/mm/título-entrada.html',
	'yyyy/mm/entry-basename/index.html' => 'aaaa/mm/título-entrada/index.html',
	'yyyy/mm/entry_basename.html' => 'aaaa/mm/título_entrada.html',
	'yyyy/mm/entry_basename/index.html' => 'aaaa/mm/título_entrada/index.html',

## lib/MT/ArchiveType/Page.pm
	'PAGE_ADV' => 'Página',
	'folder-path/page-basename.html' => 'ruta-carpeta/título-página.html',
	'folder-path/page-basename/index.html' => 'carpeta-path/título-página/index.html',
	'folder_path/page_basename.html' => 'ruta_carpeta/título_pagina.html',
	'folder_path/page_basename/index.html' => 'ruta_carpeta/título_pagina/index.html',

## lib/MT/Asset.pm
	'Assets of this website' => 'Multimedia de este sitio',
	'Assets with Extant File' => 'Multimedia con ficheros existentes',
	'Assets with Missing File' => 'Multimedia con ficheros perdidos',
	'Audio' => 'Audio',
	'Author Status' => 'Estado autor',
	'Content Data ( id: [_1] ) does not exists.' => 'El campo de datos de contenido ( id: [_1] ) no existe.',
	'Content Field ( id: [_1] ) does not exists.' => 'El campo de contenido ( id: [_1] ) no existe.',
	'Content Field' => 'Campo de contenido',
	'Content type of Content Data ( id: [_1] ) does not exists.' => 'El tipo contenido de datos de contenido ( id: [_1] ) no existe.',
	'Could not create asset cache path: [_1]' => 'No pudo crear la ruta para el fichero multimedia: [_1]',
	'Could not remove asset file [_1] from the filesystem: [_2]' => 'No se pudo eliminar el fichero multimedia [_1] del sistema de ficheros: [_2]',
	'Deleted' => 'Eliminado',
	'Description' => 'Descripción',
	'Disabled' => 'Desactivado',
	'Enabled' => 'Activado',
	'Except Userpic' => 'Avatar Except',
	'File Extension' => 'Extensión de ficheros',
	'File' => 'Fichero',
	'Filename' => 'Nombre del fichero',
	'Image' => 'Imagen',
	'Label' => 'Título',
	'Location' => 'Lugar',
	'Missing File' => 'Fichero perdido',
	'Name' => 'Nombre',
	'No Label' => 'Sin etiqueta',
	'Pixel Height' => 'Altura px',
	'Pixel Width' => 'Anchura px',
	'URL' => 'URL',
	'Video' => 'Vídeo',
	'extant' => 'existente',
	'missing' => 'perdido',
	q{Assets in [_1] field of [_2] '[_4]' (ID:[_3])} => q{Multimedia en el campo [_1] de [_2] '[_4]' (ID:[_3])},

## lib/MT/Asset/Audio.pm
	'audio' => 'Audio',

## lib/MT/Asset/Image.pm
	'%f-thumb-%wx%h-%i%x' => '%f-miniatura-%wx%h-%i%x',
	'Actual Dimensions' => 'Tamaño actual',
	'Cannot load image #[_1]' => 'No se pudo cargar la imagen nº[_1]',
	'Cropping image failed: Invalid parameter.' => 'Falló al recortar la imagen: Parámetro no válido.',
	'Error converting image: [_1]' => 'Error convirtiendo la imagen: [_1]',
	'Error creating thumbnail file: [_1]' => 'Error creando el fichero de la miniatura: [_1]',
	'Error cropping image: [_1]' => 'Error recortando imagen: [_1]',
	'Error scaling image: [_1]' => 'Error redimensionando la imagen: [_1]',
	'Extracting image metadata failed: [_1]' => 'Falló al extraer los metadatos de la imagen: [_1]',
	'Images' => 'Imágenes',
	'Popup page for [_1]' => 'Abrir en página nueva para [_1]',
	'Rotating image failed: Invalid parameter.' => 'Falló al rotar la imagen: Parámetro no válido.',
	'Scaling image failed: Invalid parameter.' => 'Falló al redimensionar la imagen: Parámetro no válido.',
	'Thumbnail image for [_1]' => 'Imagen miniatura para [_1]',
	'Writing image metadata failed: [_1]' => 'Falló al escribir los metadatos de la imagen: [_1]',
	'Writing metadata failed: [_1]' => 'Falló al escribir los metadatos: [_1]',
	'[_1] x [_2] pixels' => '[_1] x [_2] píxeles',
	q{Error writing metadata to '[_1]': [_2]} => q{Error al escribir los metadatos en '[_1]': [_2]},
	q{Error writing to '[_1]': [_2]} => q{Error al escribir en '[_1]': [_2]},
	q{Invalid basename '[_1]'} => q{Nombre base no válido '[_1]'},

## lib/MT/Asset/Video.pm
	'Videos' => 'Vídeos',
	'video' => 'Vídeo',

## lib/MT/Association.pm
	'Association' => 'Asociación',
	'Group' => 'Grupo',
	'Permissions for Groups' => 'Permisos para grupos',
	'Permissions for Users' => 'Permisos para usuarios',
	'Permissions for [_1]' => 'Permisos de [_1]',
	'Permissions of group: [_1]' => 'Permisos del grupo: [_1]',
	'Permissions with role: [_1]' => 'Permisos con rol: [_1]',
	'Role Detail' => 'Detalles del rol',
	'Role Name' => 'Nombre del rol',
	'Role' => 'Rol',
	'Site Name' => 'Nombre del sitio',
	'User is [_1]' => 'El usuario es [_1]',
	'User/Group Name' => 'Nombre del usuario/grupo',
	'User/Group' => 'Usuario/Grupo',
	'association' => 'Asociación',
	'associations' => 'Asociaciones',

## lib/MT/AtomServer.pm
	'Invalid image file format.' => 'Formato de imagen no válido.',
	'Perl module Image::Size is required to determine the width and height of uploaded images.' => 'El módulo de Perl Image::Size es necesario para determinar las dimensiones de las imágenes transferidas.',
	'Removing stats cache failed.' => 'Fallo al eliminar la caché de estadísticas.',
	'[_1]: Entries' => '[_1]: Entradas',
	q{'[_1]' is not allowed to upload by system settings.: [_2]} => q{'[_1]' no tiene permisos para transferir a través de la configuración del sistema: [_2].},
	q{Cannot make path '[_1]': [_2]} => q{No se puede crear la ruta '[_1]': [_2]},
	q{Entry '[_1]' ([lc,_5] #[_2]) deleted by '[_3]' (user #[_4]) from atom api} => q{Entrada '[_1]' ([lc,_5] #[_2]) borrada por '[_3]' (usuario #[_4]) desde atom api},
	q{Invalid blog ID '[_1]'} => q{Identificador de blog  '[_1]' no válido},
	q{PreSave failed [_1]} => q{Fallo en 'PreSave' [_1]},
	q{User '[_1]' (user #[_2]) added [lc,_4] #[_3]} => q{Usuario '[_1]' (usuario #[_2]) añadido [lc,_4] #[_3]},
	q{User '[_1]' (user #[_2]) edited [lc,_4] #[_3]} => q{Usuario '[_1]' (usuario #[_2]) editado [lc,_4] #[_3]},

## lib/MT/Auth.pm
	'Bad AuthenticationModule config' => 'Configuración incorrecta de AuthenticationModule',
	q{Bad AuthenticationModule config '[_1]': [_2]} => q{Configuración incorrecta de AuthenticationModule '[_1]': [_2]},

## lib/MT/Auth/MT.pm
	'Failed to verify the current password.' => 'Falló la verificación de la contraseña actual.',
	'Missing required module' => 'Módulo obligatorio no instalado',
	'Password contains invalid character.' => 'La contraseña contiene un carácter no válido.',

## lib/MT/Author.pm
	'Active' => 'Activo',
	'Commenters' => 'Comentaristas',
	'Content Data Count' => 'Número de datos de contenido',
	'Created by' => 'Creado por',
	'Disabled Users' => 'Usuarios deshabilitados',
	'Enabled Users' => 'Usuarios habilitados',
	'Locked Out' => 'Bloqueado',
	'Locked out Users' => 'Bloquear usuarios',
	'Lockout' => 'Bloquear',
	'MT Native Users' => 'Usuarios nativos de MT',
	'MT Users' => 'Usuarios de MT',
	'Not Locked Out' => 'No bloqueado',
	'Pending Users' => 'Usuarios pendientes',
	'Pending' => 'Pendiente',
	'Privilege' => 'Privilegio',
	'Registered User' => 'Usuario registrado',
	'Status' => 'Estado',
	'The approval could not be committed: [_1]' => 'No se pudo realizar la aprobación: [_1]',
	'User Info' => 'Info usuario',
	'Userpic' => 'Avatar',
	'Website URL' => 'URL del sitio',
	'__ENTRY_COUNT' => 'Entradas',
	'userpic-[_1]-%wx%h%x' => 'avatar-[_1]-%wx%h%x',

## lib/MT/BackupRestore.pm
	'Cannot open [_1].' => 'No se pudo abrir [_1].',
	'Copying [_1] to [_2]...' => 'Copiando [_1] a [_2]...',
	'Exporting [_1] records:' => 'Exportando [_1] registros:',
	'Failed: ' => 'Falló: ',
	'ID for the file was not set.' => 'El ID del fichero no está establecido.',
	'Importing asset associations ... ( [_1] )' => 'Importando las asociaciones de ficheros multimedia ... ( [_1] )',
	'Importing asset associations in entry ... ( [_1] )' => 'Importando las asociaciones de ficheros multimedia en las entradas ... ( [_1] )',
	'Importing asset associations in page ... ( [_1] )' => 'Importando las asociaciones de ficheros multimedia en las páginas ... ( [_1] )',
	'Importing content data ... ( [_1] )' => 'Importando datos de contenidos ... ( [_1] )',
	'Importing url of the assets ( [_1] )...' => 'Importando la URL de los ficheros multimedia ( [_1] )...',
	'Importing url of the assets in entry ( [_1] )...' => 'Importando la URL de los ficheros multimedia en las entradas ( [_1] )...',
	'Importing url of the assets in page ( [_1] )...' => 'Importando la URL de los ficheros multimedia en las páginas ( [_1] )...',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'El fichero [_1] no es un fichero válido de manifiesto para copias de seguridad de Movable Type.',
	'Manifest file: [_1]' => 'Fichero de manifiesto: [_1]',
	'No manifest file could be found in your import directory [_1].' => 'No se encontró fichero de manifiesto en el directorio de importación [_1].',
	'Path was not found for the file, [_1].' => 'No se encontró la ruta del fichero, [_1].',
	'Rebuilding permissions ... ( [_1] )' => 'Reconstruyendo los permisos ... ( [_1] )',
	'The file ([_1]) was not imported.' => 'El fichero ([_1]) no fue importado.',
	'There were no [_1] records to be exported.' => 'There were no [_1] records to be exported.',
	'[_1] is not writable.' => 'No puede escribirse en [_1].',
	'[_1] records exported.' => '[_1] registros exportados.',
	'[_1] records exported...' => '[_1] registros exportados...',
	'failed' => 'falló',
	'ok' => 'ok',
	qq{\nCannot write file. Disk full.} => qq{\nNo se pudo escribir el fichero. Disco lleno.},
	q{Cannot open directory '[_1]': [_2]} => q{No se puede abrir el directorio '[_1]': [_2]},
	q{Changing path for the file '[_1]' (ID:[_2])...} => q{Cambiando la ruta del fichero '[_1]' (ID:[_2])...},
	q{Error making path '[_1]': [_2]} => q{Error creando la ruta '[_1]': [_2]},

## lib/MT/BackupRestore/BackupFileHandler.pm
	'A user with the same name as the current user ([_1]) was found in the exported file.  Skipping this user record.' => 'Se encontró un usuario con el mismo nombre que el usuario actual ([_1]) en el fichero exportado. Ignorando este registro.',
	'Importing [_1] records:' => 'Importando [_1] registros:',
	'Invalid serializer version was specified.' => 'Se especificó una versión no válida del serializador.',
	'The uploaded exported manifest file was created with Movable Type, but the schema version ([_1]) differs from the one used by this system ([_2]).  You should not import this exported file to this version of Movable Type.' => 'El fichero de manifiesto transferido fue creado con Movable Type, pero la versión del esquema ([_1]) difiere del usado en este sistema ([_2]). No debe importar este fichero en esta versión de Movable Type.',
	'The uploaded file was not a valid Movable Type exported manifest file.' => 'El fichero transferido no era un fichero de manifiesto de Movable Type válido.',
	'[_1] is not a subject to be imported by Movable Type.' => '[_1] no se puede importar en Movable Type.',
	'[_1] records imported.' => '[_1] registros importados.',
	'[_1] records imported...' => '[_1] registros importados...',
	q{A user with the same name '[_1]' was found in the exported file (ID:[_2]).  Import replaced this user with the data from the exported file.} => q{Se encontró un usuario con el mismo nombre '[_1]' en el fichero exportado (ID:[_2]). La importación reemplazó a este usuario con los datos del fichero exportado.},
	q{Tag '[_1]' exists in the system.} => q{La etiqueta '[_1]' existe en el sistema.},
	q{The role '[_1]' has been renamed to '[_2]' because a role with the same name already exists.} => q{El rol '[_1]' se ha renombrado como '[_2]' porque ya existía un rol con el mismo nombre.},
	q{The system level settings for plugin '[_1]' already exist.  Skipping this record.} => q{Ya existe una configuración a nivel del sistema para la extensión '[_1]'. Se ignora este registro.},

## lib/MT/BackupRestore/BackupFileScanner.pm
	'Cannot import requested file because a site was not found in either the existing Movable Type system or the exported data. A site must be created first.' => 'No se pudo im',
	'Cannot import requested file because doing so requires the Digest::SHA Perl module. Please contact your Movable Type system administrator.' => 'No se pudo importar el fichero solicitado porque la acción necesita el módulo de Perl Digest::SHA. Por favor, contacte con su administrador de Movable Type.',

## lib/MT/BasicAuthor.pm
	'authors' => 'autores',

## lib/MT/Blog.pm
	'*Site/Child Site deleted*' => '*Sitio/Sitio hijo eliminado*',
	'Child Sites' => 'Sitios hijos',
	'Clone of [_1]' => 'Clon de [_1]',
	'Cloned child site... new id is [_1].' => 'Sitio hijo clonado... el nuevo ID es [_1].',
	'Cloning associations for blog:' => 'Clonando asociaciones para el blog:',
	'Cloning categories for blog...' => 'Clonando categorías para el blog...',
	'Cloning entries and pages for blog...' => 'Clonando entradas y páginas para el blog...',
	'Cloning entry placements for blog...' => 'Clonando situación de entradas para el blog...',
	'Cloning entry tags for blog...' => 'Clonando etiquetas de entradas para el blog...',
	'Cloning permissions for blog:' => 'Clonando permisos para el blog:',
	'Cloning template maps for blog...' => 'Clonando mapas de plantillas para el blog...',
	'Cloning templates for blog...' => 'Clonando plantillas para el blog...',
	'Content Type Count' => 'Cuenta de tipo de contenidos',
	'Content Type' => 'Tipo de contenido',
	'Failed to apply theme [_1]: [_2]' => 'Fallo al aplicar tema [_1]: [_2]',
	'Failed to load theme [_1]: [_2]' => 'Fallo al cargar tema [_1]: [_2]',
	'First Blog' => 'Primer blog',
	'No default templates were found.' => 'No se encontraron plantillas predefinidas.',
	'Parent Site' => 'Sito padre',
	'Theme' => 'Tema',
	'__ASSET_COUNT' => 'Multimedia',
	'__PAGE_COUNT' => 'Páginas',
	q{Invalid archive_type '[_1]' in Archive Mapping '[_2]'} => q{Tipo de archive_type no válido '[_1]' en el mapeado de archivo '[_2]'},
	q{Invalid category_field '[_1]' in Archive Mapping '[_2]'} => q{category_field no válido '[_1]' en el mapeado de archivo '[_2]'},
	q{Invalid datetime_field '[_1]' in Archive Mapping '[_2]'} => q{datetime_field no válido '[_1]' en el mapeado de archivo '[_2]'},
	q{archive_type is needed in Archive Mapping '[_1]'} => q{archive_type es necesario en el mapeado de archivos '[_1]'},
	q{category_field is required in Archive Mapping '[_1]'} => q{category_field es necesario en el mapeado de archivo '[_1]'},

## lib/MT/Bootstrap.pm
	'Got an error: [_1]' => 'Ocurrió un error en: [_1]',

## lib/MT/Builder.pm
	'<[_1]> at line [_2] is unrecognized.' => 'No se reconoció a <[_1]> en la línea [_2].',
	'<[_1]> with no </[_1]> on line #' => '<[_1]> sin </[_1]> en la línea #',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]> sin </[_1]> en la línea [_2]',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]> sin </[_1]> en la línea [_2].',
	'Error in <mt[_1]> tag: [_2]' => 'Error en la etiqueta <mt[_1]>: [_2]',
	'Unknown tag found: [_1]' => 'Se encontró una etiqueta desconocida: [_1]',

## lib/MT/CMS/AddressBook.pm
	'Error sending mail ([_1]): Try another MailTransfer setting?' => 'Error enviado correo electrónico ([_1]). Inténtelo de nuevo probando con otra configuración para MailTransfer.',
	'No entry ID was provided' => 'No se especificó el ID de entrada',
	'No valid recipients were found for the entry notification.' => 'No se encontraron destinatarios válidos para la notificación de la entrada.',
	'Please select a blog.' => 'Por favor, seleccione un blog.',
	'The e-mail address you entered is already on the Notification List for this blog.' => 'La dirección de correo que introdujo ya está en la Lista de notificaciones de este blog.',
	'The text you entered is not a valid URL.' => 'El texto que introdujo no es una URL válida.',
	'The text you entered is not a valid email address.' => 'El texto que introdujo no es una dirección de correo válida.',
	'[_1] Update: [_2]' => '[_1] Actualiza: [_2]',
	q{No such entry '[_1]'} => q{No existe la entrada '[_1]'},
	q{Subscriber '[_1]' (ID:[_2]) deleted from address book by '[_3]'} => q{Suscriptor '[_1]' (ID:[_2]) borrado de la agenda por '[_3]'},

## lib/MT/CMS/Asset.pm
	'(user deleted)' => '(usuario borrado)',
	'<[_1] Root>' => '<[_1] raíz>',
	'<[_1] Root>/[_2]' => '<[_1] raíz/[_2]',
	'Archive' => 'Archivo',
	'Cannot load asset #[_1]' => 'No se pudo cargar el fichero multimedia #[_1]',
	'Cannot load asset #[_1].' => 'No se pudo cargar el fichero multimedia #[_1].',
	'Cannot load file #[_1].' => 'No se pudo cargar el fichero nº[_1].',
	'Cannot overwrite an existing file with a file of a different type. Original: [_1] Uploaded: [_2]' => 'No se puede escribir sobre un fichero que ya existe con otro fichero de diferente tipo. Original: [_1] Transferido: [_2].',
	'Custom...' => 'Personalizar...',
	'Extension changed from [_1] to [_2]' => 'La extensión cambió de [_1] a [_2]',
	'Failed to create thumbnail file because [_1] could not handle this image type.' => 'Falló al crear el fichero de vista previa porque [_1] no pudo gestionar este formato de imagen.',
	'Files' => 'Ficheros',
	'Invalid Request.' => 'Petición no válida.',
	'Movable Type was unable to write to the "Upload Destination". Please make sure that the webserver can write to this folder.' => 'Movable Type no pudo escribir en el "Destino de las transferencias". Por favor, asegúrese de que el servidor puede escribir en ese directorio.',
	'No permissions' => 'No tiene permisos',
	'Please select a video to upload.' => 'Por favor, seleccione un video a transferir. Please select a video to upload.',
	'Please select an audio file to upload.' => 'Por favor, seleccione el fichero de audio a transferir.',
	'Please select an image to upload.' => 'Por favor, seleccione una imagen a transferir.',
	'Saving object failed: [_1]' => 'Fallo guardando objeto: [_1]',
	'Transforming image failed: [_1]' => 'Falló al modificar la imagen: [_1]',
	'Untitled' => 'Sin título',
	'Upload Asset' => 'Transferir fichero multimedia',
	'Uploaded file is not an image.' => 'El fichero transferido no es una imagen.',
	'basename of user' => 'nombre base del usuario',
	'none' => 'ninguno',
	'unassigned' => 'no asignado',
	q{Could not create upload path '[_1]': [_2]} => q{No se pudo crear la ruta de transferencias '[_1]': [_2]},
	q{Error creating a temporary file; The webserver should be able to write to this folder.  Please check the TempDir setting in your configuration file, it is currently '[_1]'. } => q{Error al crear un fichero temporal. El servidor web debe poder escribir en este directorio. Por favor, compruebe la directiva TempDir en el fichero de configuración, actualmente es '[_1]'.},
	q{Error deleting '[_1]': [_2]} => q{Error borrando '[_1]': [_2]},
	q{Error opening '[_1]': [_2]} => q{Error abriendo '[_1]': [_2]},
	q{Error writing upload to '[_1]': [_2]} => q{Error escribiendo transferencia a '[_1]': [_2]},
	q{File '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Fichero '[_1]' (ID:[_2]) transferido por '[_3]'},
	q{File '[_1]' uploaded by '[_2]'} => q{Fichero '[_1]' transferido por '[_2]'},
	q{File with name '[_1]' already exists. (Install the File::Temp Perl module if you would like to be able to overwrite existing uploaded files.)} => q{Ya existe un fichero con el nombre '[_1]'. (Si desea escribir sobre ficheros transferidos anteriormente, instale el módulo de Perl File::Temp).},
	q{File with name '[_1]' already exists. Upload has been cancelled.} => q{El fichero con el nombre '[_1]' ya existe. Transferencia cancelada.},
	q{File with name '[_1]' already exists.} => q{El fichero con el nombre '[_1]' ya existe.},
	q{File with name '[_1]' already exists; Tried to write to a tempfile, but the webserver could not open it: [_2]} => q{Ya existe un fichero con el nombre '[_1]'. Se intentó escribir en un fichero temporal, pero el servidor no pudo abrirlo: [_2]},
	q{Invalid extra path '[_1]'} => q{Ruta extra no válida '[_1]'},
	q{Invalid filename '[_1]'} => q{Nombre de fichero no válido '[_1]'},
	q{Invalid temp file name '[_1]'} => q{Nombre de fichero temporal no válido '[_1]'},

## lib/MT/CMS/Blog.pm
	'(no name)' => '(sin nombre)',
	'Archive URL must be an absolute URL.' => 'La URL de archivo debe ser una URL absoluta.',
	'Blog Root' => 'Raíz del blog',
	'Cannot load content data #[_1].' => 'No se pudieron cargar los datos de contenido #[_1].',
	'Cannot load template #[_1].' => 'No se pudo cargar la plantilla #[_1].',
	'Compose Settings' => 'Configuración de la composición',
	'Create Child Site' => 'Crear sitio hijo',
	'Enter a site name to filter the choices below.' => 'Introduzca el nombre de un sitio para filtrar las opciones de abajo.',
	'Entries must be cloned if comments and trackbacks are cloned' => 'Las entradas tienen que clonarse su se clonan los comentarios y trackbacks',
	'Entries must be cloned if comments are cloned' => 'Las entradas deben clonarse si se clonan los comentarios',
	'Entries must be cloned if trackbacks are cloned' => 'Las entradas deben clonarse si se clonan los trackbacks',
	'Error' => 'Error',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Error: Movable Type no puede escribir en el directorio de caché de las plantillas. Por favor, compruebe los permisos del directorio llamado <code>[_1]</code> dentro del directorio de su blog.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Error: Movable Type no pudo crear un directorio para cachear las plantillas dinámicas. Debe crear un directorio llamado <code>[_1]</code> dentro del directorio de su blog.',
	'Feedback Settings' => 'Configuración de respuestas',
	'Finished!' => '¡Finalizó!',
	'General Settings' => 'Configuración general',
	'Invalid blog_id' => 'blog_id no válido',
	'No blog was selected to clone.' => 'Ningún blog ha sido seleccionado para ser clonado.',
	'Please choose a preferred archive type.' => 'Por favor, seleccione el tipo de archivo preferido.',
	'Plugin Settings' => 'Configuración de extensiones',
	'Publish Site' => 'Publicar sitio',
	'Registration Settings' => 'Configuración de registro',
	'Saved [_1] Changes' => 'Guardados los cambios de [_1]',
	'Saving blog failed: [_1]' => 'Fallo guardando blog: [_1]',
	'Select Child Site' => 'Seleccionar sitio hijo',
	'Selected Child Site' => 'Sitio hijo seleccionado',
	'Site URL must be an absolute URL.' => 'La URL del sitio debe ser una URL absoluta.',
	'The number of revisions to store must be a positive integer.' => 'El número de revisiones a guardar debe ser un número entero positivo.',
	'These setting(s) are overridden by a value in the Movable Type configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.' => 'Un valor en el fichero de configuración de MT tiene prioridad sobre esta configuración: [_1]. Elimine el valor del fichero de configuración para poder co ntrolarlo desde esta página.',
	'This action can only be run on a single blog at a time.' => 'Esta acción solo se puede ejecutar en un solo blog a la vez.',
	'This action cannot clone website.' => 'Esta acción no puede clonar un sitio web.',
	'Website Root' => 'Raíz del sitio web',
	'You did not specify a blog name.' => 'No especificó el nombre del blog.',
	'You did not specify an Archive Root.' => 'No ha especificado un Archivo raíz.',
	'[_1] (ID:[_2])' => '[_1] (ID:[_2])',
	'[_1] changed from [_2] to [_3]' => '[_1] cambió de [_2] a [_3]',
	q{'[_1]' (ID:[_2]) has been copied as '[_3]' (ID:[_4]) by '[_5]' (ID:[_6]).} => q{'[_1]' (ID:[_2]) se ha copiado como '[_3]' (ID:[_4]) por '[_5]' (ID:[_6]).},
	q{Blog '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Blog '[_1]' (ID:[_2]) borrado por '[_3]'},
	q{Cloning child site '[_1]'...} => q{Clonando sitio hijo '[_1]'...},
	q{The '[_1]' provided below is not writable by the web server. Change the directory ownership or permissions and try again.} => q{El servidor web no puede escribir en el '[_1]' indicado abajo. Modifique los permisos de acceso al directorio e inténtelo de nuevo.},
	q{[_1] '[_2]' (ID:[_3]) created by '[_4]'} => q{[_1] '[_2]' (ID:[_3]) creado por '[_4]'},
	q{[_1] '[_2]'} => q{[_1] '[_2]'},
	q{index template '[_1]'} => q{plantilla índice '[_1]'},

## lib/MT/CMS/Category.pm
	'Category Set' => 'Conjunto de categorías',
	'Create Category Set' => 'Crear conjunto de categorías',
	'Create [_1]' => 'Crear [_1]',
	'Edit [_1]' => 'Editar [_1]',
	'Failed to update [_1]: Some of [_2] were changed after you opened this page.' => 'Falló la actualización de [_1]: Se modificaron algunos [_2] después de que abriera la página.',
	'Invalid category_set_id: [_1]' => 'category_set_id no válido: [_1]',
	'Manage [_1]' => 'Administrar [_1]',
	'The [_1] must be given a name!' => '¡Debe dar un nombre a [_1]!',
	'Tried to update [_1]([_2]), but the object was not found.' => 'Se intentó actualizar [_1]([_2]), pero el objeto no se encontró.',
	'Your changes have been made (added [_1], edited [_2] and deleted [_3]). <a href="#" onclick="[_4]" class="mt-rebuild">Publish your site</a> to see these changes take effect.' => 'Se han realizado los cambios ([_1] añadido, [_2] editado y [_3] borrado). <a href="#" onclick="[_4]" class="mt-rebuild">Publique el sitio</a> para que los cambios tomen efecto.',
	'category_set' => 'Conjunto de categorías',
	q{Category '[_1]' (ID:[_2]) deleted by '[_3]'} => q{La categoría '[_1]' (ID:[_2]) fue borrada por '[_3]'},
	q{Category '[_1]' (ID:[_2]) edited by '[_3]'} => q{La categoría '[_1]' (ID:[_2]) fue editada por '[_3]'},
	q{Category '[_1]' created by '[_2]'.} => q{La categoría '[_1]' fue creada por '[_2]'.},
	q{Category Set '[_1]' (ID:[_2]) edited by '[_3]'} => q{Conjunto de categorías '[_1]' (ID:[_2]) fue editada por '[_3]'},
	q{Category Set '[_1]' created by '[_2]'.} => q{Conjunto de categorías '[_1]' fue creada por '[_2]'.},
	q{The category basename '[_1]' conflicts with the basename of another category. Top-level categories and sub-categories with the same parent must have unique basenames.} => q{Hay un conflicto entre el nombre base de la categoría '[_1]' y el de otra categoría. Las categorías de nivel superior y las subcategorías con una misma raíz deben tener nombres diferentes.},
	q{The category name '[_1]' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.} => q{El nombre de la categría '[_1]' tiene conflicto con otra categoría. Las categorías de primer nivel y las sub-categorías con el mismo padre deben tener nombres únicos.},
	q{The category name '[_1]' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.} => q{Hay un conflicto entre el nombre de la categoría '[_1]' y otra categoría. Las categorías de nivel superior y las subcategorías con una misma raíz deben tener nombres diferentes.},
	q{The name '[_1]' is too long!} => q{El nombre '[_1]' es demasiado largo.},
	q{[_1] order has been edited by '[_2]'.} => q{El orden de [_1] fue editado por '[_2]'.},

## lib/MT/CMS/CategorySet.pm
	q{Category Set '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Conjunto de categorías '[_1]' (ID:[_2]) fue borrada por '[_3]'},

## lib/MT/CMS/Common.pm
	'All [_1]' => 'Todos los/las [_1]',
	'An error occurred while counting objects: [_1]' => 'Ocurrió un error durante el recuento de objetos: [_1]',
	'An error occurred while loading objects: [_1]' => 'Ocurrió un error durante la carga de objetos: [_1]',
	'Error occurred during permission check: [_1]' => 'Ocurrió un error al comprobar los permisos: [_1]',
	'Invalid ID [_1]' => 'ID inválido [_1]',
	'Invalid filter terms: [_1]' => 'Términos de filtro no válidos: [_1]',
	'Invalid filter: [_1]' => 'Filtro no válido: [_1]',
	'Invalid type [_1]' => 'Tipo inválido [_1]',
	'New Filter' => 'Nuevo filtro',
	'Removing tag failed: [_1]' => 'Falló el borrado de la etiqueta: [_1]',
	'Saving snapshot failed: [_1]' => 'Fallo al guardar instantánea: [_1]',
	'System templates cannot be deleted.' => 'No se pueden eliminar las plantillas del sistema.',
	'The Template Name and Output File fields are required.' => 'Los campos del nombre de la plantilla y el fichero de salida son obligatorios.',
	'The blog root directory must be within [_1].' => 'El directorio raíz del blog debe estar en [_1]',
	'The selected [_1] has been deleted from the database.' => 'El [_1] seleccionado fue borrado de la base de datos.',
	'The website root directory must be within [_1].' => 'El directorio raíz del sitio web debe estar en [_1]',
	'Unknown list type' => 'Tipo de lista desconocido',
	'Web Services Settings' => 'Configuración de los servicios web',
	'[_1] Feed' => 'Sindicación de [_1]',
	'[_1] broken revisions of [_2](id:[_3]) are removed.' => 'Se han eliminado [_1] revisiones dañadas de [_2] (id: [_3]).',
	'__SELECT_FILTER_VERB' => 'es',
	q{'[_1]' edited the global template '[_2]'} => q{'[_1]' editó la plantilla global '[_2]'},
	q{'[_1]' edited the template '[_2]' in the blog '[_3]'} => q{'[_1]' editó la plantilla '[_2]' en el blog '[_3]'},

## lib/MT/CMS/ContentData.pm
	'(No Label)' => '(Sin etiqueta)',
	'(untitled)' => '(sin título)',
	'Cannot load content field (UniqueID:[_1]).' => 'No se pudo cargar el campo de contenido (UniqueID:[_1]).',
	'Cannot load content_type #[_1]' => 'No se pudo cargar el content_type #[_1]',
	'Create new [_1]' => 'Crear nuevo [_1]',
	'Need a status to update content data' => 'Necesita un estado para actualizar los datos de contenido',
	'Need content data to update status' => 'Se necesitan datos de contenido para actualizar el estado',
	'New [_1]' => 'Nueva [_1]',
	'No Label (ID:[_1])' => 'Sin etiqueta (ID:[_1])',
	'One of the content data ([_1]) did not exist' => 'Uno de los datos de contenido ([_1]) no existe',
	'Publish error: [_1]' => 'Error de publicación: [_1]',
	'The value of [_1] is automatically used as a data label.' => 'El valor de [_1] se utiliza automáticamente como una etiqueta de datos.',
	'Unable to create preview files in this location: [_1]' => 'No fue posible crear los ficheros de previsualización en esta ruta: [_1]',
	'Unpublish Contents' => 'Despublicar contenidos',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Su blog no tiene configurados la URL y la raíz del sitio. No puede publicar entradas hasta que no estén definidos.',
	'[_1] (ID:[_2]) status changed from [_3] to [_4]' => 'El estado de [_1] (ID:[_2]) cambió de [_3] a [_4]',
	q{Invalid date '[_1]'; 'Published on' dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Fecha no válida '[_1]'. Las fechas de publicación debe tener el formato AAAA-MM-DD HH:MM:SS.},
	q{Invalid date '[_1]'; 'Unpublished on' dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Fecha no válida '[_1]'. Las fechas 'No publicado en' deben tener el formato AAAA-MM-DD HH:MM:SS},
	q{Invalid date '[_1]'; 'Unpublished on' dates should be dates in the future.} => q{Fecha no válida '[_1]'. Las fechas 'No publicado en' deben ser fechas futuras.},
	q{Invalid date '[_1]'; 'Unpublished on' dates should be later than the corresponding 'Published on' date.} => q{Fecha no válida '[_1]'. Las fechas 'No publicado en' deben ser posteriores a la fecha 'Publicado en' correspondiente.},
	q{New [_1] '[_4]' (ID:[_2]) added by user '[_3]'} => q{Nuevo [_1] '[_4]' (ID:[_2]) añadido por el usuario '[_3]'},
	q{[_1] '[_4]' (ID:[_2]) deleted by '[_3]'} => q{[_1] '[_4]' (ID:[_2]) borrado por '[_3]'},
	q{[_1] '[_4]' (ID:[_2]) edited by user '[_3]'} => q{[_1] '[_4]' (ID:[_2]) editado por el usuario '[_3]'},
	q{[_1] '[_6]' (ID:[_2]) edited and its status changed from [_3] to [_4] by user '[_5]'} => q{[_1] '[_6]' (ID:[_2]) editado y su estado cambió de [_3] a [_4] por el usuario '[_5]'},

## lib/MT/CMS/ContentType.pm
	'Cannot load content field data (ID: [_1])' => 'No se pudo cargar el contenido del campo (ID: [_1])',
	'Cannot load content type #[_1]' => 'No se pudo cargar el tipo de contenido #[_1]',
	'Content Type Boilerplates' => 'Modelos de tipos de contenido',
	'Create Content Type' => 'Crear tipo de contenido',
	'Create new content type' => 'Create new content type',
	'Manage Content Type Boilerplates' => 'Gestionar modelos de tipos de contenidos',
	'Saving content field failed: [_1]' => 'Fallo guardando el campo de contenido: [_1]',
	'Saving content type failed: [_1]' => 'Fallo guardando el tipo de contenido: [_1]',
	'Some content fields were deleted: ([_1])' => 'Some content fields were deleted: ([_1])',
	'The content type name is required.' => 'Se necesita el nombre de tipo de contenido.',
	'The content type name must be shorter than 255 characters.' => 'El nombre del tipo de contenido debe contener menos de 255 caracteres.',
	'content_type' => 'Tipo de contenido',
	q{A content field '[_1]' ([_2]) was added} => q{El campo d  '[_1]' ([_2]) was added},
	q{A content field options of '[_1]' ([_2]) was changed} => q{A content field options of '[_1]' ([_2]) was changed},
	q{A description for content field of '[_1]' should be shorter than 255 characters.} => q{La descripción del campo de contenido de '[_1]' debe contener menos de 255 caracteres.},
	q{A label for content field of '[_1]' is required.} => q{Se necesita una etiqueta para el campo de contenido '[_1]'.},
	q{A label for content field of '[_1]' should be shorter than 255 characters.} => q{La etiqueta para el campo de contenido de '[_1]' debe contener menos de 255 caracteres.},
	q{Content Type '[_1]' (ID:[_2]) added by user '[_3]'} => q{Tipo de contenido '[_1]' (ID:[_2]) creado por el usuario '[_3]'},
	q{Content Type '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Content Type '[_1]' (ID:[_2]) deleted by '[_3]'},
	q{Content Type '[_1]' (ID:[_2]) edited by user '[_3]'} => q{Content Type '[_1]' (ID:[_2]) edited by user '[_3]'},
	q{Field '[_1]' and '[_2]' must not coexist within the same content type.} => q{}, # Translate - New
	q{Field '[_1]' must be unique in this content type.} => q{}, # Translate - New
	q{Name '[_1]' is already used.} => q{El nombre '[_1]' ya está en uso.},

## lib/MT/CMS/Dashboard.pm
	'An image processing toolkit, often specified by the ImageDriver configuration directive, is not present on your server or is configured incorrectly. A toolkit must be installed to ensure proper operation of the userpics feature. Please install Graphics::Magick, Image::Magick, NetPBM, GD, or Imager, then set the ImageDriver configuration directive accordingly.' => 'No se ha configurado correctamente, o no está disponible en el sistema, ningún paquete de procesamiento de imágenes, generalmente especificado por la directiva de configuración ImageDriver. Se necesita un paquete gráfico para el correcto funcionamiento de la gestión de avatares. Por favor, instale Graphics::Magick, Image::Magick, NetPBM, GD, o Imager, y configure la directiva ImageDriver adecuadamente.',
	'Can verify SSL certificate, but verification is disabled.' => 'Se puede verificar el certificado SSL, pero la comprobación está desactivada.',
	'Cannot verify SSL certificate.' => 'No se pudo verificar el certificado SSL.',
	'Error: This child site does not have a parent site.' => 'Error: This child site does not have a parent site.',
	'ImageDriver is not configured.' => 'ImageDriver no está configurado.',
	'Not configured' => 'Sin configurar',
	'Page Views' => 'Páginas vistas',
	'Please contact your Movable Type system administrator.' => 'Por favor, contacte con el administrador de su Movable Type.',
	'Please install Mozilla::CA module. Writing "SSLVerifyNone 1" in mt-config.cgi can hide this warning, but this is not recommended.' => 'Por favor, instale el módulo Mozilla::CA. Para ocultar este aviso, escriba "SSLVerifyNone 1" en mt-config.cgi, aunque no se recomienda.',
	'System' => 'Sistema',
	'The support directory is not writable.' => 'No se puede escribir en el directorio de soporte.',
	'Unknown Content Type' => 'Unknown Content Type',
	'You should remove "SSLVerifyNone 1" in mt-config.cgi.' => 'Debe eliminar "SSLVerifyNone 1" de mt-config.cgi',
	q{Movable Type was unable to write to its 'support' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.} => q{Movable Type no pudo escribir en el directorio 'support'. Por favor, cree un directorio en este lugar: [_1], y asígnele permisos para permitir que el servidor web pueda acceder y escribir en él.},
	q{The System Email Address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events. Please confirm your <a href="[_1]">settings.</a>} => q{Movable Type utiliza la Dirección de correo del sistema en cabecera 'From:' en los correos enviados por el sistema. Se podrían enviar correos para la recuperación de contraseña, el registro de comentaristas, las notificaciones de comentarios y trackbacks, bloqueos de usuarios e IPs, y en otros eventos menores. Por favor, confirme su <a href="[_1]">configuración</a>.},

## lib/MT/CMS/Entry.pm
	'(user deleted - ID:[_1])' => '(usuario borrado - ID:[_1])',
	'/' => '/',
	'Need a status to update entries' => 'Necesita indicar un estado para actualizar las entradas',
	'Need entries to update status' => 'Necesita entradas para actualizar su estado',
	'New Entry' => 'Nueva entrada',
	'New Page' => 'Nueva página',
	'No such [_1].' => 'No existe [_1].',
	'One of the entries ([_1]) did not exist' => 'Una de las entradas ([_1]) no existe.',
	'Removing placement failed: [_1]' => 'Fallo eliminando lugar: [_1]',
	'Saving placement failed: [_1]' => 'Fallo guardando situación: [_1]',
	'This basename has already been used. You should use an unique basename.' => 'Este nombre base está ya en uso. Debe indicar un nombre base único.',
	'authored on' => 'creando en',
	'modified on' => 'modifcado en',
	q{<a href="[_1]">QuickPost to [_2]</a> - Drag this bookmarklet to your browser's toolbar, then click it when you are visiting a site that you want to blog about.} => q{<a href="[_1]">QuickPost - [_2]</a> - Arrastre este marcador a la barra de su navegador. Haga clic en él cuando visite un sitio web sobre el que quiera bloguear.},
	q{Invalid date '[_1]'; 'Published on' dates should be earlier than the corresponding 'Unpublished on' date '[_2]'.} => q{Fecha no válida: '[_1]'. Las fechas de publicación debe ser anteriores a la fecha de despublicación '[_2]'.},
	q{Invalid date '[_1]'; [_2] dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Fecha no válida '[_1]'. Las fechas de [_2] deben tener el formato YYYY-MM-DD HH:MM:SS.},
	q{Saving entry '[_1]' failed: [_2]} => q{Fallo guardando entrada '[_1]': [_2]},
	q{[_1] '[_2]' (ID:[_3]) edited and its status changed from [_4] to [_5] by user '[_6]'} => q{[_1] '[_2]' (ID:[_3]) editado y cambió su estado desde [_4] a [_5] al usuario '[_6]'},
	q{[_1] '[_2]' (ID:[_3]) edited by user '[_4]'} => q{[_1] '[_2]' (ID:[_3]) editado por el usuario '[_4]'},
	q{[_1] '[_2]' (ID:[_3]) status changed from [_4] to [_5]} => q{[_1] '[_2]' (ID:[_3]) cambió de estado de [_4] a [_5]},

## lib/MT/CMS/Export.pm
	'Export Site Entries' => 'Exportar las entradas del sitio',
	'Please select a site.' => 'Por favor, seleccione un sitio.',
	'You do not have export permissions' => 'No tiene permisos de exportación',
	q{Loading site '[_1]' failed: [_2]} => q{Fallo cargando sitio '[_1]': [_2]},

## lib/MT/CMS/Filter.pm
	'(Legacy) ' => '(Anticuado) ',
	'Failed to delete filter(s): [_1]' => 'Falló al borrar los filtros: [_1]',
	'Failed to save filter:  Label "[_1]" is duplicated.' => 'Falló al guardar el filtro: La etiqueta "[_1]" está duplicada.',
	'Failed to save filter: Label is required.' => 'Falló al guardar el filtro: la etiqueta es obligatoria.',
	'Failed to save filter: [_1]' => 'Falló al guardar el filtro: [_1]',
	'No such filter' => 'No existe dicho filtro',
	'Permission denied' => 'Permiso denegado',
	'Removed [_1] filters successfully.' => 'Se borraron con éxito los [_1] filtros.',
	'[_1] ( created by [_2] )' => '[_1] ( creado por [_2] )',

## lib/MT/CMS/Folder.pm
	q{Folder '[_1]' (ID:[_2]) deleted by '[_3]'} => q{La carpeta '[_1]' (ID:[_2]) fue borrada por '[_3]'},
	q{Folder '[_1]' (ID:[_2]) edited by '[_3]'} => q{La carpeta '[_1]' (ID:[_2]) fue editada por '[_3]'},
	q{Folder '[_1]' created by '[_2]'} => q{La carpeta '[_1]' fue creada por '[_2]'},
	q{The folder '[_1]' conflicts with another folder. Folders with the same parent must have unique basenames.} => q{La carpeta '[_1]' tiene conflicto con otra carpeta. Las carpetas con el mismo padre deben tener nombre base únicos.},

## lib/MT/CMS/Group.pm
	'Add Users to Groups' => 'Añadir usuarios a grupos',
	'Author load failed: [_1]' => 'La carga del autor ha fallado: [_1]',
	'Create Group' => 'Crear grupo',
	'Each group must have a name.' => 'Cada grupo debe tener un nombre.',
	'Group Name' => 'Nombre del grupo',
	'Group load failed: [_1]' => 'La carga del grupo ha fallado: [_1]',
	'Groups Selected' => 'Grupos seleccionados',
	'Search Groups' => 'Buscar grupos',
	'Search Users' => 'Buscar usuarios',
	'Select Groups' => 'Seleccionar grupos',
	'Select Users' => 'Seleccionar usuarios',
	'User load failed: [_1]' => 'La carga del usuario ha fallado: [_1]',
	'Users Selected' => 'Usuarios seleccionados',
	q{User '[_1]' (ID:[_2]) removed from group '[_3]' (ID:[_4]) by '[_5]'} => q{Usuario [_1] (ID: [_2]) ha sido borrado del grupo [_3] (ID:[_4]) por [_5]},
	q{User '[_1]' (ID:[_2]) was added to group '[_3]' (ID:[_4]) by '[_5]'} => q{Usuario[_1] (ID: [_2]) ha sido añadido del grupo [_3] (ID:[_4]) por [_5]},

## lib/MT/CMS/Import.pm
	'Import Site Entries' => 'Importar las entradas de sitio',
	'Importer type [_1] was not found.' => 'No se encontró el tipo de importador [_1].',
	'You do not have import permission' => 'No tiene permisos de importación',
	'You do not have permission to create users' => 'No tiene permisos para crear usuarios',
	'You need to provide a password if you are going to create new users for each user listed in your site.' => 'Debe proporcionar una contraseña si va a crear usuarios nuevos por cada usuario listado en su sitio.',

## lib/MT/CMS/Log.pm
	'All Feedback' => 'Todas las opiniones',
	'Publishing' => 'Publicación',
	'System Activity Feed' => 'Sindicación de la actividad',
	q{Activity log for blog '[_1]' (ID:[_2]) reset by '[_3]'} => q{El registro de actividad del blog '[_1]' (ID:[_2]) fue reiniciado por  '[_3]'},
	q{Activity log reset by '[_1]'} => q{Registro de actividad reiniciado por '[_1]'},

## lib/MT/CMS/Plugin.pm
	'Error saving plugin settings: [_1]' => 'Error guardando la configuración de las extensión: [_1]',
	'Individual Plugins' => 'Extensiones individuales',
	'Plugin Set: [_1]' => 'Conjunto de extensiones: [_1]',
	'Plugin' => 'extensión',
	'Plugins are disabled by [_1]' => '', # Translate - New
	'Plugins are enabled by [_1]' => '', # Translate - New
	q{Plugin '[_1]' is disabled by [_2]} => q{}, # Translate - New
	q{Plugin '[_1]' is enabled by [_2]} => q{}, # Translate - New

## lib/MT/CMS/RebuildTrigger.pm
	'(All child sites in this site)' => '(Todos los sitios hijos en este sitio)',
	'(All sites and child sites in this system)' => '(Todos los sitios y sitios hijos del sistema)',
	'Comment' => 'Comentario',
	'Create Rebuild Trigger' => 'Crear un inductor de republicación',
	'Entry/Page' => 'Entrada/Página',
	'Format Error: Comma-separated-values contains wrong number of fields.' => 'Error de formato: Los valores separados por comas contienen un número incorrecto de campos.',
	'Format Error: Trigger data include illegal characters.' => 'Error de formato: Los datos de activación incluyen caracteres ilegales.',
	'Save' => 'Guardar',
	'Search Content Type' => 'Buscar tipo de contenido',
	'Search Sites and Child Sites' => 'Buscar sitios y sitios hijos',
	'Select Content Type' => 'Seleccionar tipo de contenido',
	'Select Site' => 'Sitio seleccionado',
	'Select to apply this trigger to all child sites in this site.' => 'Seleccione para aplicar este inductor de republicación en todos los sitios hijos del sitio.',
	'Select to apply this trigger to all sites and child sites in this system.' => 'Seleccione aplicar este inductor de republicación a todos los sitios y sitios hijos del sistema.',
	'TrackBack' => 'TrackBack',
	'__UNPUBLISHED' => 'Despublicar',
	'rebuild indexes and send pings.' => 'reconstruye los índices y envía pings.',
	'rebuild indexes.' => 'reconstruye los índices.',

## lib/MT/CMS/Search.pm
	'"[_1]" field is required.' => 'El campo "[_1]" es necesario.',
	'"[_1]" is invalid for "[_2]" field of "[_3]" (ID:[_4]): [_5]' => '"[_1]" no es válido para el campo "[_2]" de "[_3]" (ID:[_4]): [_5]',
	'Basename' => 'Nombre base',
	'Data Label' => 'Etiqueta de datos',
	'Entry Body' => 'Cuerpo de la entrada',
	'Error in search expression: [_1]' => 'Error en la expresión de búsqueda: [_1]',
	'Excerpt' => 'Resumen',
	'Extended Entry' => 'Entrada extendida',
	'Extended Page' => 'Página extendida',
	'IP Address' => 'Dirección IP',
	'Invalid date(s) specified for date range.' => 'Se especificaron fechas no válidas para el rango.',
	'Keywords' => 'Palabras clave',
	'Linked Filename' => 'Fichero enlazado',
	'Log Message' => 'Mensaje del registro',
	'No [_1] were found that match the given criteria.' => 'Ningún [_1] ha sido encontrado que corresponda al criterio dado.',
	'Output Filename' => 'Fichero salida',
	'Page Body' => 'Cuerpo de la página',
	'Site Root' => 'Raíz del sitio',
	'Site URL' => 'URL del sitio',
	'Template Name' => 'Nombre de la plantilla',
	'Templates' => 'Plantillas',
	'Text' => 'Texto',
	'Title' => 'Título',
	'replace_handler of [_1] field is invalid' => 'replace_handler del campo [_1] no es válido',
	'ss_validator of [_1] field is invalid' => 'ss_validator del campo [_1] no es válido',
	q{Searched for: '[_1]' Replaced with: '[_2]'} => q{Se buscó: '[_1]' Se reemplazó con: '[_2]'},
	q{[_1] '[_2]' (ID:[_3]) updated by user '[_4]' using Search & Replace.} => q{[_1] '[_2]' (Id:[_3]) actualizado por el usuario '[_4]' mediante Buscar y reemplazar.},

## lib/MT/CMS/Tag.pm
	'A new name for the tag must be specified.' => 'Debe especificar un nombre nuevo para la etiqueta.',
	'Error saving entry: [_1]' => 'Error guardando entrada: [_1]',
	'Error saving file: [_1]' => 'Error guardando fichero: [_1]',
	'No such tag' => 'No existe dicha etiqueta',
	'Successfully added [_1] tags for [_2] entries.' => 'Se añadió con éxito [_1] etiquetas en [_2] entradas.',
	'The tag was successfully renamed' => 'Se renombró con éxito a la etiqueta.',
	q{Tag '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Etiqueta '[_1]' (ID:[_2]) borrada por '[_3]'},

## lib/MT/CMS/Template.pm
	' (Backup from [_1])' => ' (Copia de [_1])',
	'Archive Templates' => 'Plantillas de archivos',
	'Cannot load templatemap' => 'No se pudo cargar el mapa de plantillas',
	'Cannot locate host template to preview module/widget.' => 'No se localizó la plantilla origen para mostrar el módulo/widget.',
	'Cannot preview without a template map!' => '¡No se puede mostrar la vista previa sin un mapa de plantilla!',
	'Cannot publish a global template.' => 'No se pudo publicar una plantilla global.',
	'Content Type Archive' => 'Archivo de tipo de contenidos',
	'Content Type Templates' => 'Plantillas de tipo de contenidos',
	'Copy of [_1]' => 'Copia de [_1]',
	'Create Template' => 'Crear plantilla',
	'Create Widget Set' => 'Crear conjunto de widgets',
	'Create Widget' => 'Crear widget',
	'Email Templates' => 'Plantillas de correo',
	'Entry or Page' => 'Entrada o página',
	'Error creating new template: ' => 'Error creando nueva plantilla: ',
	'Global Template' => 'Plantilla global',
	'Global Templates' => 'Plantillas globales',
	'Global' => 'Global',
	'Index Templates' => 'Plantillas índice',
	'Invalid Blog' => 'Blog no válido',
	'LOREM_IPSUM_TEXT' => 'LOREM_IPSUM_TEXT',
	'LORE_IPSUM_TEXT_MORE' => 'LORE_IPSUM_TEXT_MORE',
	'Lorem ipsum' => 'Lorem ipsum',
	'One or more errors were found in the included template module ([_1]).' => 'Se encontraron uno o más errrores en el módulo de plantilla incluído ([_1])',
	'One or more errors were found in this template.' => 'Se encontraron uno o más errores en esta plantilla.',
	'Orphaned' => 'Huérfano',
	'Preview' => 'Vista previa',
	'Published Date' => 'Fecha de publicación',
	'Refreshing template <strong>[_3]</strong> after making <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>.' => 'Reactualizar los modelos <strong>[_3]</strong> desde <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">guardar</a>',
	'Saving map failed: [_1]' => 'Fallo guardando mapa: [_1]',
	'Setting up mappings failed: [_1]' => 'Fallo la configuración de mapeos: [_1]',
	'System Templates' => 'Plantillas del sistema',
	'Template Backups' => 'Copias de seguridad de las plantillas',
	'Template Modules' => 'Módulos de plantillas',
	'Template Refresh' => 'Refrescar plantilla',
	'Unable to create preview file in this location: [_1]' => 'Imposible crear vista previa del archivo en este lugar: [_1]',
	'Unknown blog' => 'Blog desconocido',
	'Widget Template' => 'Plantilla de widget',
	'Widget Templates' => 'Plantillas de widget',
	'You must select at least one event checkbox.' => 'Debe seleccionar al menos una casilla de eventos.',
	'You must specify a template type when creating a template' => 'Debe especificar un tipo al crear una plantilla.',
	'You should not be able to enter zero (0) as the time.' => 'No debería introducir cero (0) como hora.',
	'archive' => 'archivo',
	'backup' => 'Copia de seguridad',
	'content type' => 'tipo de contenido',
	'email' => 'correo electrónico',
	'index' => 'índice',
	'module' => 'módulo',
	'sample, entry, preview' => 'sample, entry, preview',
	'system' => 'sistema',
	'template' => 'plantilla',
	'widget' => 'widget',
	q{Skipping template '[_1]' since it appears to be a custom template.} => q{Ignorando plantilla '[_1]' ya que parecer ser una plantilla personalizada.},
	q{Skipping template '[_1]' since it has not been changed.} => q{Ignorando la plantilla '[_1]' ya que no ha sido modificada.},
	q{Template '[_1]' (ID:[_2]) created by '[_3]'} => q{Plantilla '[_1]' (ID:[_2]) creada por '[_3]'},
	q{Template '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Plantilla '[_1]' (ID:[_2]) borrada por '[_3]'},

## lib/MT/CMS/Theme.pm
	'All themes directories are not writable.' => 'No se puede escribir en inguno de los directorios de los temas.',
	'Download [_1] archive' => 'Descargar archivo de [_1]',
	'Error occurred during exporting [_1]: [_2]' => 'Ocurrió un error durante la exportación de [_1]: [_2]',
	'Error occurred during finalizing [_1]: [_2]' => 'Ocurrió un error durante la finalización de [_1]: [_2]',
	'Error occurred while publishing theme: [_1]' => 'Ocurrió un error durante la publicación del tema: [_1]',
	'Export Themes' => 'Exportar temas',
	'Failed to load theme export template for [_1]: [_2]' => 'Falló la carga de la plantilla de exportación de temas para [_1]: [_2]',
	'Failed to save theme export info: [_1]' => 'Fallo al guardar la información de exportación del tema: [_1]',
	'Failed to uninstall theme' => 'Fallo al desinstalar el tema',
	'Failed to uninstall theme: [_1]' => 'Fallo al desinstalar el tema: [_1]',
	'Install into themes directory' => 'Instalar en el directorio de temas',
	'Theme from [_1]' => 'Tema de [_1]',
	'Theme not found' => 'Tema no encontrado',
	'Themes Directory [_1] is not writable.' => 'No se puede escribir en el directorio de los temas [_1].',
	'Themes directory [_1] is not writable.' => 'No se puede escribir en el directorio de los temas [_1].',

## lib/MT/CMS/Tools.pm
	'Any site' => 'Cualquier sitio',
	'Cannot recover password in this configuration' => 'No se pudo recuperar la clave con esta configuración',
	'Changing URL for FileInfo record (ID:[_1])...' => 'Modificando la URL para el registro FileInfo (Id:[_1])...',
	'Changing file path for FileInfo record (ID:[_1])...' => 'Modificando la ruta del fichero para el registro FileInfo (Id:[_1])...',
	'Changing image quality is [_1]' => 'Cambiando la calidad de imagen es [_1]',
	'Copying file [_1] to [_2] failed: [_3]' => 'Fallo copiandi fichero [_1] en [_2]: [_3]',
	'Could not remove exported file [_1] from the filesystem: [_2]' => 'No se pudo eliminar el fichero exportado [_1] del sistema de ficheros: [_2]',
	'Debug mode is [_1]' => 'El modo de depuración es [_1]',
	'Detailed information is in the activity log.' => 'La información detallada se encuentra en el registro de actividad.',
	'E-mail was not properly sent. [_1]' => 'El correo no se envió correctamente. [_1]',
	'Email address is [_1]' => 'La dirección de correo es [_1]',
	'Email address is required for password reset.' => 'La dirección de correo es necesaria para el reinicio de contraseña.',
	'Email address not found' => 'Dirección de correo no encontrada',
	'Error occurred during import process.' => 'Ocurrió un error durante el proceso de importación.',
	'Error occurred while attempting to [_1]: [_2]' => 'Ocurrió un error intentando [_1]: [_2]',
	'Error sending e-mail ([_1]); Please fix the problem, then try again to recover your password.' => 'Error enviado un correo electrónico ([_1]). Por favor, solucione el problema y luego intente recuperar de nuevo la contraseña.',
	'File was not uploaded.' => 'El fichero no fue transferido.',
	'IP address lockout interval' => 'Intervalo de bloqueo de direcciones IP',
	'IP address lockout limit' => 'Límite de bloqueo de direcciones IP',
	'Image quality(JPEG) is [_1]' => 'La calidad de la imagen (JPEG) es [_1]',
	'Image quality(PNG) is [_1]' => 'La calidad de la imagen (PNG) es [_1]',
	'Importing a file failed: ' => 'Falló la importación de un fichero: ',
	'Invalid SitePath.  The SitePath should be valid and absolute, not relative' => 'SitePath no válido. Debe tener un valor absoluto, no relativo.',
	'Invalid author_id' => 'author_id no válido',
	'Invalid email address' => 'Dirección de correo no válida',
	'Invalid password recovery attempt; Cannot recover the password in this configuration' => 'Intento de recuperación de contraseña no válido. No se pudo recuperar la contraseña con esta configuración',
	'Invalid password recovery attempt; cannot recover password in this configuration' => 'Intento de recuperación de contraseña no válido; no se pudo recuperar la clave con esta configuración',
	'Invalid password reset request' => 'Solicitud de reinicio de contraseña no válida',
	'Lockout IP address whitelist' => 'Lista blanca de bloqueo de direcciones IP',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ',
	'Manifest file [_1] was not a valid Movable Type exported manifest file.' => 'El fichero de manifiesto [_1] no era un fichero de manifiesto de exportación válido de Movable Type.',
	'Only to blogs within this system' => 'Solo a los blogs en este sistema',
	'Outbound trackback limit is [_1]' => 'El límite de trackbacks salientes es [_1]',
	'Password Recovery' => 'Recuperación de contraseña',
	'Password reset token not found' => 'Token para el reinicio de la contraseña no encontrado',
	'Passwords do not match' => 'Las contraseñas no coinciden',
	'Performance log path is [_1]' => 'La ruta del histórico de rendimiento es [_1]',
	'Performance log threshold is [_1]' => 'El umbral del histórico de rendimiento es [_1]',
	'Performance logging is off' => 'El histórico de rendimiento está desactivado',
	'Performance logging is on' => 'El histórico de rendimiento está activado',
	'Please confirm your new password' => 'Por favor, confirme su nueva contraseña',
	'Please enter a valid email address.' => 'Por favor, teclee una dirección de correo válida.',
	'Please upload [_1] in this page.' => 'Por favor, transfiera [_1] a esta página.',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Por favor, use xml, tar.gz, zip, o manifest como extensión de ficheros.',
	'Prohibit comments is off' => 'La prohibición de comentarios está desactivada.',
	'Prohibit comments is on' => 'La prohibición de comentarios está activada.',
	'Prohibit notification pings is off' => 'La prohibición de pings está desactivada.',
	'Prohibit notification pings is on' => 'La prohibición de pings está activada.',
	'Prohibit trackbacks is off' => 'La prohibición de trackbacks está desactivada.',
	'Prohibit trackbacks is on' => 'La prohibición de trackbacks está actividada.',
	'Recipients for lockout notification' => 'Destinatarios de las notificaciones de bloqueos',
	'Some [_1] were not imported because their parent objects were not imported.' => 'Algún [_1] no fue importado porque sus objetos padres no fueron importados.',
	'Some objects were not imported because their parent objects were not imported.  Detailed information is in the activity log.' => 'Algunos de los objetos no pudieron importarse porque sus objetos padre no fueron importados. Dispone de información detallada en el registro de actividad.',
	'Some objects were not imported because their parent objects were not imported.' => 'Algunos objetos no pudieron importarse porque sus objetos padre no fueron importados.x ',
	'Some of files could not be imported.' => 'Algunos de los ficheros no pudieron importarse.',
	'Some of the actual files for assets could not be imported.' => 'Algunos de los ficheros multimedia no pudieron importarse.',
	'Some of the exported files could not be removed.' => 'Algunos de los ficheros exportados no se pudieron eliminar.',
	'Some of the files were not imported correctly.' => 'Algunos de estos ficheros no se importaron correctamente.',
	'Specified file was not found.' => 'No se encontró el fichero especificado.',
	'Started importing sites' => '', # Translate - New
	'Started importing sites: [_1]' => '', # Translate - New
	'System Settings Changes Took Place' => 'Se realizaron los cambios en la configuración del sistema',
	'Temporary directory needs to be writable for export to work correctly.  Please check (Export)TempDir configuration directive.' => 'El directorio temporal debe tener permisos de escritura para que la exportación funcione correctamente. Por favor, revise la directiva de configuración (Export)TempDir.',
	'Temporary directory needs to be writable for import to work correctly.  Please check (Export)TempDir configuration directive.' => 'El directorio temporal debe tener permisos de escritura para que la importación funcione correctamente. Por favor, revise la directiva de configuración (Export)TempDir.',
	'Test e-mail was successfully sent to [_1]' => 'El correo de prueba fue enviado con éxito a [_1]',
	'Test email from Movable Type' => 'Correo de prueba de Movable Type',
	'That action ([_1]) is apparently not implemented!' => '¡La acción ([_1]) aparentemente no está implementada!',
	'This is the test email sent by Movable Type.' => 'Este es un mensaje de prueba enviado por Movable Type',
	'Uploaded file was not a valid Movable Type exported manifest file.' => 'El fichero transferido no era un manifiesto de exportación válido de Movable Type.',
	'User lockout interval' => 'Intervalo de bloqueo de usuarios',
	'User lockout limit' => 'Límite de bloqueo de usuarios',
	'User not found' => 'Usuario no encontrado',
	'You do not have a system email address configured.  Please set this first, save it, then try the test email again.' => 'No ha configurado la dirección de correo del sistema. Por favor, configúrela, guárdela y luego intente de nuevo enviar el correo de prueba.',
	'Your request to change your password has expired.' => 'Expiró su solicitud de cambio de contraseña.',
	'[_1] has canceled the multiple files import operation prematurely.' => '[_1] ha cancelado prematuramente la operación de importación de múltiples ficheros.',
	'[_1] is [_2]' => '[_1] es [_2]',
	'[_1] is not a directory.' => '[_1] no es un directorio.',
	'[_1] is not a number.' => '[_1] no es un número.',
	'[_1] successfully downloaded export file ([_2])' => '[_1] descargó con éxito el fichero de exporación ([_2])',
	q{A password reset link has been sent to [_3] for user  '[_1]' (user #[_2]).} => q{Se ha envíado el enlace del reinicio de la contraseña para el usuario '[_1]' a [_3] (usuario #[_2]).},
	q{Changing Archive Path for the site '[_1]' (ID:[_2])...} => q{Cambiando la ruta de archivos del sitio '[_1]' (ID:[_2])...},
	q{Changing Site Path for the site '[_1]' (ID:[_2])...} => q{Cambiando la ruta del sitio '[_1]' (ID:[_2])...},
	q{Changing file path for the asset '[_1]' (ID:[_2])...} => q{Modificando la ruta para el fichero multimedia '[_1]' (ID:[_2])...},
	q{Manifest file '[_1]' is too large. Please use import directory for importing.} => q{El fichero de manifiesto '[_1]' es demasiado grande. Por favor, use el directorio de importación.},
	q{Movable Type system was successfully exported by user '[_1]'} => q{El sistema de Movable Type fue exportado correctamente por el usuario '[_1]'},
	q{Removing Archive Path for the site '[_1]' (ID:[_2])...} => q{Eliminando la ruta de archivos del sitio '[_1]' (ID:[_2])...},
	q{Removing Site Path for the site '[_1]' (ID:[_2])...} => q{Eliminando la ruta del sitio '[_1]' (ID:[_2])...},
	q{Site(s) (ID:[_1]) was/were successfully exported by user '[_2]'} => q{El/los sitio/s (ID:[_1]) fue/ron correctamente exportado/s por el usuario '[_2]'},
	q{Successfully imported objects to Movable Type system by user '[_1]'} => q{Objetos importados correctamente en el sistema de Movable Type por el usuario '[_1]'},
	q{User '[_1]' (user #[_2]) does not have email address} => q{El usuario '[_1]' (usuario #[_2]) no tiene dirección de correo},

## lib/MT/CMS/User.pm
	'(newly created user)' => '(nuevo usuario creado)',
	'Another role already exists by that name.' => 'Ya existe otro rol con ese nombre.',
	'Cannot load role #[_1].' => 'No se pudo cargar el rol #[_1].',
	'Create User' => 'Crear usuario',
	'For improved security, please change your password' => 'Para mayor seguridad, por favor, cambie la contraseña',
	'Grant Permissions' => 'Otorgar permisos',
	'Groups/Users Selected' => 'Grupos/usuarios seleccionados',
	'Invalid ID given for personal blog clone location ID.' => 'ID inválido para el ID de localización de clonación de blog personal.',
	'Invalid ID given for personal blog theme.' => 'ID inválido para un tema de blog personal.',
	'Invalid type' => 'Tipo no válido',
	'Minimum password length must be an integer and greater than zero.' => 'La contraseña debe tener al menos un carácter.',
	'Role name cannot be blank.' => 'El nombre del rol no puede estar vacío.',
	'Roles Selected' => 'Roles seleccionados',
	'Select Groups And Users' => 'Seleccionar grupos y usuarios',
	'Select Roles' => 'Seleccionar roles',
	'Select a System Administrator' => 'Seleccione un Administrador del Sistema',
	'Select a entry author' => 'Seleccione un autor de entradas',
	'Select a page author' => 'Seleccione un autor de páginas',
	'Selected System Administrator' => 'Administrador del Sistema seleccionado',
	'Selected author' => 'Autor seleccionado',
	'Sites Selected' => 'Sitios seleccionados',
	'System Administrator' => 'Administrador del sistema',
	'Type a username to filter the choices below.' => 'Introduzca un nombre de usuario para filtrar las opciones.',
	'User Settings' => 'Configuración de usuarios',
	'User requires display name' => 'El usuario necesita un nombre público',
	'User requires password' => 'El usuario necesita una contraseña',
	'User requires username' => 'El usuario necesita un nombre de usuario',
	'You cannot define a role without permissions.' => 'No puede definir un rol sin permisos.',
	'You cannot delete your own association.' => 'No puede borrar sus propias asociaciones.',
	'You have no permission to delete the user [_1].' => 'No tiene permisos para borrar el usuario [_1].',
	'represents a user who will be created afterwards' => 'representa un usuario que se creará después',
	q{User '[_1]' (ID:[_2]) could not be re-enabled by '[_3]'} => q{No se pudo rehabilitar al usuario '[_1]' (ID:[_2]) por '[_3]'},
	q{User '[_1]' (ID:[_2]) created by '[_3]'} => q{Usuario '[_1]' (ID:[_2]) creado por '[_3]'},
	q{User '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Usuario '[_1]' (ID:[_2]) borrado por '[_3]'},
	q{[_1]'s Associations} => q{Asociaciones de [_1]},

## lib/MT/CMS/Website.pm
	'Cannot load website #[_1].' => 'No se pudo cargar el sitio web #[_1].',
	'Create Site' => 'Crear sitio',
	'Selected Site' => 'Sitio seleccionado',
	'This action cannot move a top-level site.' => 'Esta acción no se puede mover un sitio de primer nivel.',
	'Type a site name to filter the choices below.' => 'Introduzca un nombre de sitio para filtrar las opciones de abajo.',
	'Type a website name to filter the choices below.' => 'Teclee el nombre de un sitio web para filtrar las opciones de abajo.',
	q{Blog '[_1]' (ID:[_2]) moved from '[_3]' to '[_4]' by '[_5]'} => q{Blog '[_1]' (ID:[_2]) trasladado de '[_3]' a '[_4]' por '[_5]'},
	q{Website '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Sitio web '[_1]' (ID:[_2]) borrado por '[_3]'},

## lib/MT/Category.pm
	'Categories must exist within the same blog' => 'Las categorías deben existir en el mismo blog',
	'Category loop detected' => 'Bucle de categorías detectado',
	'Category' => 'Categoría',
	'Parent' => 'Raíz',
	'[quant,_1,entry,entries,No entries]' => '[quant,_1,entraday,entradas,Sin entradas]',
	'[quant,_1,page,pages,No pages]' => '[quant,_1,página,páginas,Sin páginas]',

## lib/MT/CategorySet.pm
	'Category Count' => 'Cuenta de categorías',
	'Category Label' => 'Etiqueta de categorías',
	'Content Type Name' => 'Nombre del tipo de contenido',
	'name "[_1]" is already used.' => 'nombre "[_1]" está ya en uso.',
	'name is required.' => 'el nombre es obligatorio.',

## lib/MT/Comment.pm
	q{Loading blog '[_1]' failed: [_2]} => q{Falló al cargar el blog '[_1]': [_2]},
	q{Loading entry '[_1]' failed: [_2]} => q{Falló al cargar la entrada '[_1]': [_2]},

## lib/MT/Compat/v3.pm
	'No executable code' => 'No es código ejecutable',
	'Publish-option name must not contain special characters' => 'El nombre de la opción de publicar no debe contener caracteres especiales',
	'uses [_1]' => 'usa [_1]',
	'uses: [_1], should use: [_2]' => 'usa: [_1], debería usar: [_2]',

## lib/MT/Component.pm
	q{Loading template '[_1]' failed: [_2]} => q{Fallo cargando plantilla '[_1]': [_2]},

## lib/MT/Config.pm
	'Configuration' => 'Configuración',

## lib/MT/ConfigMgr.pm
	'Alias for [_1] is looping in the configuration.' => 'Alias de [_1] está generando un bucle en la configuración.',
	'Config directive [_1] without value at [_2] line [_3]' => 'Directiva de configuración [_1] sin valor en [_2] línea [_3]',
	q{Error opening file '[_1]': [_2]} => q{Error abriendo el fichero '[_1]': [_2]},
	q{No such config variable '[_1]'} => q{No existe tal variable de configuración '[_1]'},

## lib/MT/ContentData.pm
	'(No label)' => '(Sin etiqueta)',
	'Author' => 'autor',
	'Cannot load content field #[_1]' => 'No se pudo cargar el campo de contenido #[_1]',
	'Contents by [_1]' => 'Contenidos por [_1]',
	'Identifier' => 'Identificador',
	'Invalid content type' => 'Tipo de contenido no válido',
	'Link' => 'Un vínculo',
	'No Content Type could be found.' => 'No se encontró el tipo de contenido',
	'Publish Date' => 'Fecha de publicación',
	'Removing content field indexes failed: [_1]' => 'Fallo borrando índices de campos de contenido: [_1]',
	'Removing object assets failed: [_1]' => 'Fallo borrando los recursos de objeto: [_1]',
	'Removing object categories failed: [_1]' => 'Fallo borrando las categorías de objeto: [_1]',
	'Removing object tags failed: [_1]' => 'Fallo borrando las etiquetas de objeto: [_1]',
	'Saving content field index failed: [_1]' => 'Fallo guardando el índice de campo de contenido: [_1]',
	'Saving object asset failed: [_1]' => 'Fallo guardando los recursos de objeto: [_1]',
	'Saving object category failed: [_1]' => 'Fallo borrando la categoría de objeto: [_1]',
	'Saving object tag failed: [_1]' => 'Fallo guardando la etiqueta de objeto: [_1]',
	'Tags fields' => 'Campos de etiquetas',
	'Unpublish Date' => 'Fecha de despublicación',
	'[_1] ( id:[_2] ) does not exists.' => '[_1] ( id:[_2] ) no existe.',
	'basename is too long.' => '', # Translate - New
	'record does not exist.' => 'registro no existe.',

## lib/MT/ContentField.pm
	'Cannot load content field data_type [_1]' => '', # Translate - New
	'Content Fields' => 'Campos de contenido',

## lib/MT/ContentFieldIndex.pm
	'Content Field Index' => 'Índice de campo de contenido',
	'Content Field Indexes' => 'Índices de campo de contenido',

## lib/MT/ContentFieldType.pm
	'Audio Asset' => 'Fichero de audio',
	'Checkboxes' => 'Casillas',
	'Date and Time' => 'Fecha y Hora',
	'Date' => 'Fecha',
	'Embedded Text' => 'Texto empotrado',
	'Image Asset' => 'Ficher de imagen',
	'Multi Line Text' => 'Texto multilínea',
	'Number' => 'Número',
	'Radio Button' => 'Botón radial',
	'Select Box' => 'Selección',
	'Single Line Text' => 'Texto de una línea',
	'Table' => 'Tabla',
	'Text Display Area' => '', # Translate - New
	'Time' => 'Hora',
	'Video Asset' => 'Fichero de vídeo',
	'__LIST_FIELD_LABEL' => 'Lista',

## lib/MT/ContentFieldType/Asset.pm
	'Show all [_1] assets' => 'Mostrar todos los recursos de [_1]',
	q{A maximum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to 1.} => q{El número máximo de selección de '[_1]' ([_2]) debe ser un entero positivo mayor o igual a 1.},
	q{A maximum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to the minimum selection number.} => q{El número máximo de selección de '[_1]' ([_2]) debe ser un entero positivo mayor o igual al valor mínimo.},
	q{A minimum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to 0.} => q{El número mínimo de selección de '[_1]' ([_2]) debe ser un entero positivo mayor o igual a 0.},
	q{You must select or upload correct assets for field '[_1]' that has asset type '[_2]'.} => q{Debe seleccionar o transferiir los recursos correctos para el campo '[_1]' que tiene el tipo '[_2]'.},

## lib/MT/ContentFieldType/Categories.pm
	'Invalid Category IDs: [_1] in "[_2]" field.' => 'IDs de categoría no válidos: [_1] en el campo de "[_2]".',
	'No category_set setting in content field type.' => 'category_set no está configurado en el tipo de campo de contenido.',
	'The source category set is not found in this site.' => 'No se encontró la fuente del conjunto de categorías en este sitio.',
	'There is no category set that can be selected. Please create a category set if you use the Categories field type.' => 'No se puede seleccionar ningún conjunto de categorías. Por favor, cree un conjunto si desea usar el tipo de campo de categorías.',
	'You must select a source category set.' => 'Debe seleccionar la fuente del conjunto de categorías.',

## lib/MT/ContentFieldType/Checkboxes.pm
	'A label for each value is required.' => 'Se necesita una etiqueta por cada valor.',
	'A value for each label is required.' => 'Se necesita un valor por cada etiqueta.',
	'You must enter at least one label-value pair.' => 'Debe introducir al menos un par etiqueta-valor.',

## lib/MT/ContentFieldType/Common.pm
	'"[_1]" field value must be greater than or equal to [_2]' => 'El vampor del campo "[_1]" debe ser mayor o igual a [_2]',
	'"[_1]" field value must be less than or equal to [_2].' => 'El valor del campo "[_1]" debe ser menor o igual a [_2].',
	'In [_1] column, [_2] [_3]' => 'En la columna [_1], [_2] [_3]',
	'Invalid [_1] in "[_2]" field.' => '[_1] no válido en el campo "[_2]".',
	'Invalid values in "[_1]" field: [_2]' => 'Valores no válidos en el campo "[_1]": [_2]',
	'Only 1 [_1] can be selected in "[_2]" field.' => 'Solo se puede seleccionar 1 [_1] en el campo "[_2]".',
	'[_1] greater than or equal to [_2] must be selected in "[_3]" field.' => 'Debe seleccionar un [_1] mayor o igual [_2] en el campo "[_3]".',
	'[_1] less than or equal to [_2] must be selected in "[_3]" field.' => 'Debe seleccionar un [_1] menor o igual a [_2] en el campo "[_3]".',
	'is not selected' => 'no está seleccionado',
	'is selected' => 'está seleccionado',

## lib/MT/ContentFieldType/ContentType.pm
	'Invalid Content Data Ids: [_1] in "[_2]" field.' => 'IDs de datos de contenido no válidos: [_1] in "[_2]" field.',
	'No Label (ID:[_1]' => 'Sin etiqueta (ID:[_1]',
	'The source Content Type is not found in this site.' => 'La fuente del tipo de contenido no se encontró en este sitio.',
	'There is no content type that can be selected. Please create new content type if you use Content Type field type.' => 'No hay un tipo de contenido que se pueda seleccionar. Por favor, cree un nuevo tipo de contenido si va a usar como tipo de campo.',
	'You must select a source content type.' => 'Debe seleccionar una fuente de tipo de contenido.',

## lib/MT/ContentFieldType/Date.pm
	q{Invalid date '[_1]'; An initial date value must be in the format YYYY-MM-DD.} => q{Fecha no válida '[_1]'; La fecha inicial debe tener el formato AAAA-MM-DD.},

## lib/MT/ContentFieldType/DateTime.pm
	q{Invalid date '[_1]'; An initial date/time value must be in the format YYYY-MM-DD HH:MM:SS.} => q{Fecha no válida '[_1]'; El valor inicial de la fecha/hora debe tener el formato AAAA-MM-DD HH:MM:SS.},

## lib/MT/ContentFieldType/Number.pm
	'"[_1]" field value has invalid precision.' => 'El valor del campo "[_1]" tiene una precisión no válida.',
	'"[_1]" field value must be a number.' => 'El valor del campo "[_1]" debe ser un número.',
	'A maximum value must be an integer and between [_1] and [_2]' => 'El valor máximo debe ser un entero entre [_1] y [_2]',
	'A maximum value must be an integer, or must be set with decimal places to use decimal value.' => 'El valor máximo debe ser un entero, o establezca los decimales para usar un valor decimal.',
	'A minimum value must be an integer and between [_1] and [_2]' => 'El valor mínimo debe ser un entero entre [_1] y [_2]',
	'A minimum value must be an integer, or must be set with decimal places to use decimal value.' => 'El valor mínimo debe ser un entero o debe especificarlo con decimales para usar un valor decimal.',
	'An initial value must be an integer and between [_1] and [_2]' => 'El valor inicial debe ser un entero entre [_1] y [_2]',
	'An initial value must be an integer, or must be set with decimal places to use decimal value.' => 'El valor inicial debe ser un entero, o establezca los decimales para usar un valor decimal.',
	'Number of decimal places must be a positive integer and between 0 and [_1].' => 'El número de decimales debe ser un entero positivo entre 0 y [_1].',
	'Number of decimal places must be a positive integer.' => 'El número de decimales debe ser un entero positivo.',

## lib/MT/ContentFieldType/RadioButton.pm
	'A label of values is required.' => 'Se necesita una etiqueta para los valores.',
	'A value of values is required.' => 'Se necesita un valor para los valores.',

## lib/MT/ContentFieldType/SingleLineText.pm
	'"[_1]" field is too long.' => 'El campo "[_1]" es demasiado largo.',
	'"[_1]" field is too short.' => 'El campo "[_1]" es demasiado corto.',
	q{A maximum length number for '[_1]' ([_2]) must be a positive integer between 1 and [_3].} => q{La longitud máxima para '[_1]' ([_2]) debe ser un entero positivo entre 1 y [_3].},
	q{A minimum length number for '[_1]' ([_2]) must be a positive integer between 0 and [_3].} => q{La longitud mínima para '[_1]' ([_2]) debe ser un entero positivo entre 0 y [_3].},
	q{An initial value for '[_1]' ([_2]) must be shorter than [_3] characters} => q{El valor inicial para '[_1]' ([_2]) debe tener menos de [_3] caracteres.},

## lib/MT/ContentFieldType/Table.pm
	q{Initial number of columns for '[_1]' ([_2]) must be a positive integer.} => q{El número inicial de columnas para '[_1]' ([_2]) debe ser un entero positivo.},
	q{Initial number of rows for '[_1]' ([_2]) must be a positive integer.} => q{El número inicial de filas para '[_1]' ([_2]) debe ser un entero positivo.},

## lib/MT/ContentFieldType/Tags.pm
	'Cannot create tag "[_1]": [_2]' => 'No se pudo crear la etiqueta "[_1]": [_2]',
	'Cannot create tags [_1] in "[_2]" field.' => 'No se pudo crear las etiquetas [_1] en el campo "[_2]".',
	q{An initial value for '[_1]' ([_2]) must be an shorter than 255 characters} => q{El valor inicial de '[_1]' ([_2]) debe tener menos de 255 caracteres.},

## lib/MT/ContentFieldType/Time.pm
	'<mt:var name="[_1]"> [_2] [_3] [_4]' => '<mt:var name="[_1]"> [_2] [_3] [_4]',
	q{Invalid time '[_1]'; An initial time value be in the format HH:MM:SS.} => q{Hora no válida '[_1]'; la hora inicial debe tener el formato HH:MM:SS.},

## lib/MT/ContentFieldType/URL.pm
	'Invalid URL in "[_1]" field.' => 'URL no válida en el campo "[_1]".',
	q{An initial value for '[_1]' ([_2]) must be shorter than 2000 characters} => q{El valor inicial de '[_1]' ([_2]) debe tener menos de 2000 caracteres.},

## lib/MT/ContentPublisher.pm
	'An error occurred while publishing scheduled contents: [_1]' => 'Ocurrió un error durante la publicación programada de contenidos: [_1]',
	'An error occurred while unpublishing past contents: [_1]' => 'Ocurrió un error durante la despublicación de contenidos antiguos: [_1]',
	'Cannot load catetory. (ID: [_1]' => 'No se pudo leer la categoría. (ID: [_1]',
	'Scheduled publishing.' => 'Publicación programada.',
	'You did not set your site publishing path' => 'No configuró la ruta de publicación del blog',
	'[_1] archive type requires [_2] parameter' => 'El tipo de archivo [_1] necesita [_2] parámetro',
	q{An error occurred publishing [_1] '[_2]': [_3]} => q{Un error se ha producido durante la publicación},
	q{An error occurred publishing date-based archive '[_1]': [_2]} => q{Ocurrió un error publicando el archivo de fechas '[_1]': [_2]},
	q{Archive type '[_1]' is not a chosen archive type} => q{El tipo de archivos '[_1]' no es un tipo de archivos seleccionado},
	q{Load of blog '[_1]' failed: [_2]} => q{La carga del blog '[_1]' falló: [_2]},
	q{Load of blog '[_1]' failed} => q{Falló la carga del blog '[_1]'},
	q{Loading of blog '[_1]' failed: [_2]} => q{Falló la carga del blog '[_1]': [_2]},
	q{Parameter '[_1]' is invalid} => q{El parámetro '[_1]' no es válido},
	q{Parameter '[_1]' is required} => q{El parámetro '[_1]' es necesario},
	q{Renaming tempfile '[_1]' failed: [_2]} => q{Fallo renombrando el fichero temporal '[_1]': [_2]},
	q{Writing to '[_1]' failed: [_2]} => q{Fallo escribiendo en '[_1]': [_2]},

## lib/MT/ContentType.pm
	'"[_1]" (Site: "[_2]" ID: [_3])' => '"[_1]" (sitio: "[_2]" ID: [_3])',
	'Content Data # [_1] not found.' => 'Datos de contenido # [_1] no encontrados.',
	'Create Content Data' => 'Crear datos de contenido',
	'Edit All Content Data' => 'Editar todos los datos de contenido',
	'Manage Content Data' => 'Administrar datos de contenido',
	'Publish Content Data' => 'Publicar datos de contenido',
	'Tags with [_1]' => 'Etiquetas con [_1]',

## lib/MT/ContentType/UniqueID.pm
	'Cannot generate unique unique_id' => 'No se pudo generar un unique_id único',

## lib/MT/Core.pm
	'(system)' => '(sistema)',
	'*Website/Blog deleted*' => '*Sitio/blog borrado*',
	'Activity Feed' => 'Sindicación de la actividad',
	'Add Summary Watcher to queue' => 'Añade un inspector de totales a la cola',
	'Address Book is disabled by system configuration.' => 'La agenda está desactivada por la configuración del sistema.',
	'Adds Summarize workers to queue.' => 'Añade trabajadores de totales a la cola.',
	'Blog ID' => 'ID del blog',
	'Blog Name' => 'Nombre del blog',
	'Blog URL' => 'URL del blog',
	'Change Settings' => 'Modificar configuración',
	'Classic Blog' => 'Blog clásico',
	'Contact' => 'Contacto',
	'Convert Line Breaks' => 'Convertir saltos de línea',
	'Create Child Sites' => 'Crear sitios hijos',
	'Create Entries' => 'Crear entradas',
	'Create Sites' => 'Crear sitios',
	'Create Websites' => 'Crear sitios web',
	'Database Name' => 'Nombre de la base de datos',
	'Database Path' => 'Ruta de la base de datos',
	'Database Port' => 'Puerto de la base de datos',
	'Database Server' => 'Servidor de base de datos',
	'Database Socket' => 'Socket de la base de datos',
	'Date Created' => 'Fecha de creación',
	'Date Modified' => 'Fecha de modificación',
	'Days must be a number.' => 'Los días deben ser un número.',
	'Edit All Entries' => 'Editar todas las entradas',
	'Entries List' => 'Lista de entradas',
	'Entry Excerpt' => 'Resumen de la entrada',
	'Entry Extended Text' => 'Texto extendido de la entrada',
	'Entry Link' => 'Enlace de la entrada',
	'Entry Title' => 'Título de la entrada',
	'Error creating performance logs directory, [_1]. Please either change the permissions to make it writable or specify an alternate using the PerformanceLoggingPath configuration directive. [_2]' => 'Error al crear el directorio de los registros de rendimiento, [_1]. Por favor, cambie los permisos para que se pueda escribir en él o especifique un directorio alternativo utilizando la directiva de configuración PerformanceLoggingPath. [_2]',
	'Error creating performance logs: PerformanceLoggingPath directory exists but is not writeable. [_1]' => 'Error al crear los registros de rendimiento: El directorio PerformanceLoggingPath existe pero no se puede escribir en él. [_1]',
	'Error creating performance logs: PerformanceLoggingPath setting must be a directory path, not a file. [_1]' => 'Error al crear los registros de rendimiento: la directiva PerformanceLoggingPath debe ser un directorio, no un fichero. [_1]',
	'Filter' => 'Filtro',
	'Folder' => 'Carpeta',
	'Get Variable' => 'Obtener variable',
	'Group Member' => 'Miembro del grupo',
	'Group Members' => 'Miembros del grupo',
	'ID' => 'ID',
	'IP Banlist is disabled by system configuration.' => 'La lista de bloqueos por IP está desactivada por la configuración del sistema.',
	'IP Banning Settings' => 'Bloqueo de IPs',
	'IP address' => 'Dirección IP',
	'IP addresses' => 'Dirección IP',
	'If Block' => 'Bloque If',
	'If/Else Block' => 'Bloque If/Else',
	'Include Template File' => 'Fichero de inclusión de plantillas',
	'Include Template Module' => 'Módulo de inclusión de plantillas',
	'Junk Folder Expiration' => 'Caducidad de la carpeta basura',
	'Legacy Quick Filter' => 'Filtro rápido antiguo',
	'Log' => 'Histórico',
	'Manage Address Book' => 'Administración del libro de Direcciones',
	'Manage All Content Data' => 'Administrar todos los datos de contenido',
	'Manage Assets' => 'Administrar multimedia',
	'Manage Blog' => 'Administrar blog',
	'Manage Categories' => 'Administrar categorías',
	'Manage Category Set' => 'Administrar conjuntos de categorías',
	'Manage Content Type' => 'Administrar tipos de contenido',
	'Manage Content Types' => 'Administrar tipos de contenido',
	'Manage Feedback' => 'Administrar respuestas',
	'Manage Group Members' => 'Administrar miembros del grupo',
	'Manage Pages' => 'Administrar páginas',
	'Manage Plugins' => 'Administrar extensiones',
	'Manage Sites' => 'Administrar sitios',
	'Manage Tags' => 'Administrar etiquetas',
	'Manage Templates' => 'Administrar plantillas',
	'Manage Themes' => 'Administrar temas',
	'Manage Users & Groups' => 'Administrar usuarios y grupos',
	'Manage Users' => 'Administrar usuarios',
	'Manage Website with Blogs' => 'Administrar sitio web con blogs',
	'Manage Website' => 'Administrar sitio web',
	'Member' => 'Miembro',
	'Members' => 'Miembros',
	'Movable Type Default' => 'Predefinido de Movable Type',
	'My Items' => 'Mis elementos',
	'My [_1]' => 'Mis [_1]',
	'MySQL Database (Recommended)' => 'Base de datos MySQL (recomendada)',
	'No Title' => 'Sin título',
	'No label' => 'Sin título',
	'Password' => 'Contraseña',
	'Permission' => 'permiso',
	'Post Comments' => 'Comentarios',
	'PostgreSQL Database' => 'Base de datos PostgreSQL',
	'Publish Entries' => 'Publicar entradas',
	'Publish Scheduled Contents' => 'Publicar contenidos programados',
	'Publish Scheduled Entries' => 'Publicar las Notas Planificadas',
	'Publishes content.' => 'Publica los contenidos.',
	'Purge Stale DataAPI Session Records' => 'Eliminar registros de sesión DataAPI caducados',
	'Purge Stale Session Records' => 'Eliminar registros de sesión caducados',
	'Purge Unused FileInfo Records' => 'Purgar registros FileInfo no utilizados',
	'Refreshes object summaries.' => 'Refrescar resúmen de los objetos',
	'Remove Compiled Template Files' => 'Borrar ficheros de plantillas compiladas',
	'Remove Temporary Files' => 'Borrar ficheros temporales',
	'Remove expired lockout data' => 'Eliminar datos cacudados de bloqueos',
	'Rich Text' => 'Texto con formato',
	'SQLite Database (v2)' => 'Base de datos SQLite (v2)',
	'SQLite Database' => 'Base de datos SQLite',
	'Send Notifications' => 'Enviar notificaciones',
	'Set Publishing Paths' => 'Configurar rutas de publicación',
	'Set Variable Block' => 'Bloque de ajuste de variable',
	'Set Variable' => 'Ajustar variable',
	'Sign In(CMS)' => 'Iniciar sesión (CMS)',
	'Sign In(Data API)' => 'Iniciar sesión (API datos)',
	'Synchronizes content to other server(s).' => 'Sincroniza el contenido con otros servidores.',
	'Tag' => 'Etiqueta',
	'The physical file path for your SQLite database. ' => 'La ruta física del fichero de la base de datos SQLite.',
	'Unpublish Past Contents' => 'Despublicar contenidos antiguos',
	'Unpublish Past Entries' => 'Despublicar entradas anteriores',
	'Upload File' => 'Transferir fichero',
	'View Activity Log' => 'Ver registro de actividad',
	'View System Activity Log' => 'Ver registro de actividad del sistema',
	'Widget Set' => 'Conjunto de widgets',
	'[_1] [_2] between [_3] and [_4]' => '[_1] [_2] entre [_3] y [_4]',
	'[_1] [_2] future' => '[_1] [_2] futuro',
	'[_1] [_2] or before [_3]' => '[_1] [_2] o antes de [_3]',
	'[_1] [_2] past' => '[_1] [_2] pasado',
	'[_1] [_2] since [_3]' => '[_1] [_2] desde [_3]',
	'[_1] [_2] these [_3] days' => '[_1] [_2] estos [_3] días',
	'[_1] [_3] [_2]' => '[_1] [_3] [_2]',
	'[_1] of this Site' => '[_1] de este sitio',
	'option is required' => 'opción es obligatoria',
	'tar.gz' => 'tar.gz',
	'zip' => 'zip',
	q{This is often 'localhost'.} => q{Generalmente esto es 'localhost'.},

## lib/MT/DataAPI/Callback/Blog.pm
	'Cannot apply website theme to blog: [_1]' => 'No pudo ponerse el diseño al blog: [_1]',
	'Invalid theme_id: [_1]' => 'theme_id no válido: [_1]',
	'The website root directory must be an absolute path: [_1]' => 'El directorio raíz del sitio web debe ser una ruta absoluta: [_1]',

## lib/MT/DataAPI/Callback/Category.pm
	'Parent [_1] (ID:[_2]) not found.' => 'No se encontró el padre de [_1] (Id:[_2]).',
	q{The label '[_1]' is too long.} => q{La etiqueta '[_1]' es demasiado larga.},

## lib/MT/DataAPI/Callback/CategorySet.pm
	'Name "[_1]" is used in the same site.' => 'El nombre "[_1]" ya se usa en el mismo sitio.',

## lib/MT/DataAPI/Callback/ContentData.pm
	'"[_1]" is required.' => '', # Translate - New
	'There is an invalid field data: [_1]' => 'Hay un dato de campo no válio: [_1]',

## lib/MT/DataAPI/Callback/ContentField.pm
	'A parameter "[_1]" is invalid: [_2]' => 'El parámetro "[_1]" no es válido: [_2]',
	'Invalid option key(s): [_1]' => 'Clave/s opcional/es no válidas',
	'Invalid option(s): [_1]' => 'Opción/es no válida/s',
	'options_validation_handler of "[_1]" type is invalid' => 'options_validation_handler del tipo "[_1]" no es válido',

## lib/MT/DataAPI/Callback/Group.pm
	'A parameter "[_1]" is invalid.' => 'Un parámetro "[_1]" no es válido.',

## lib/MT/DataAPI/Callback/Log.pm
	'author_id (ID:[_1]) is invalid.' => 'author_id (Id:[_1]) no válido.',
	'log' => 'Histórico',
	q{Log (ID:[_1]) deleted by '[_2]'} => q{Histórico (Id:[_1]) borrado por '[_2]'},

## lib/MT/DataAPI/Callback/Tag.pm
	'Invalid tag name: [_1]' => 'Nombre de etiqueta no válido: [_1]',

## lib/MT/DataAPI/Callback/TemplateMap.pm
	'Invalid archive type: [_1]' => 'Tipo de archivo no válido: [_1]',

## lib/MT/DataAPI/Callback/User.pm
	'Invalid dateFormat: [_1]' => 'Formato de fecha no válido: [_1]',
	'Invalid textFormat: [_1]' => 'Formato de texto no válido: [_1]',

## lib/MT/DataAPI/Endpoint/Auth.pm
	q{Failed login attempt by user who does not have sign in permission via data api. '[_1]' (ID:[_2])} => q{Un usuario que no tiene permisos de API de datos realizó un intento de inicio de sesión fallido. '[_1]' (ID:[_2])},
	q{User '[_1]' (ID:[_2]) logged in successfully via data api.} => q{El usuario '[_1]' (ID:[_2]) inició una sesión a través del API de datos.},

## lib/MT/DataAPI/Endpoint/Common.pm
	'Invalid dateFrom parameter: [_1]' => 'Parámetro de dateFrom no válido: [_1]',
	'Invalid dateTo parameter: [_1]' => 'Parámetro de dateTo no válido: [_1]',

## lib/MT/DataAPI/Endpoint/v2/Asset.pm
	'Invalid height: [_1]' => 'Alto no válido: [_1]',
	'Invalid scale: [_1]' => 'Escala no válida: [_1]',
	'Invalid width: [_1]' => 'Ancho no válido: [_1]',
	'The asset does not support generating a thumbnail file.' => 'El fichero multimedia no soporta la generación de vista previa.',

## lib/MT/DataAPI/Endpoint/v2/BackupRestore.pm
	'An error occurred during the backup process: [_1]' => 'Ocurrió un error durante la copia de seguridad: [_1]',
	'An error occurred during the restore process: [_1] Please check activity log for more details.' => 'Ocurrió un error durante el proceso de restauración: [_1] Por favor, compruebe el registro de actividad para más detalles.',
	'Invalid backup_archive_format: [_1]' => 'backup_archive_format no válido: [_1]',
	'Invalid backup_what: [_1]' => 'backup_what no válido: [_1]',
	'Invalid limit_size: [_1]' => 'limit_size no válido: [_1]',
	'Temporary directory needs to be writable for backup to work correctly.  Please check (Export)TempDir configuration directive.' => 'Debe poderse escribir en el directorio temporal para que las copias de seguridad funcionen correctamente. Por favor, compruebe la opción de configuración (Export)TempDir.',
	q{Make sure that you remove the files that you restored from the 'import' folder, so that if/when you run the restore process again, those files will not be re-restored.} => q{Asegúrese de que elimina los ficheros que ha restaurado de la carpeta 'importar', por si ejecuta el proceso en otra ocasión que éstos no vuelvan a restaurar.},

## lib/MT/DataAPI/Endpoint/v2/Blog.pm
	'Cannot create a blog under blog (ID:[_1]).' => 'No se pudo crear un blog bajo el blog (Id:[_1]).',
	'Either parameter of "url" or "subdomain" is required.' => 'Se requiere el parámetro "url" o "subdominio".',
	'Site not found' => 'Sitio no encontrado',
	'Website "[_1]" (ID:[_2]) was not deleted. You need to delete the blogs under the website first.' => 'No se borró el sitio web "[_1]" (Id:[_2]). Primero debe eliminar los blogs pertenecientes al sitio web.',

## lib/MT/DataAPI/Endpoint/v2/Category.pm
	'Loading object failed: [_1]' => 'Falló la carga del objeto: [_1]',
	'[_1] not found' => '[_1] no encontrado',

## lib/MT/DataAPI/Endpoint/v2/Entry.pm
	'A resource "[_1]" is required.' => 'El recurso "[_1]" es necesario.',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Ocurrió un error durante el proceso de importación: [_1]. Por favor, compruebe su fichero de importación.',
	'Could not found archive template for [_1].' => 'No se pudo encontrar la plantilla de archivos para [_1].',
	'Invalid convert_breaks: [_1]' => 'convert_breaks no válido: [_1]',
	'Invalid default_cat_id: [_1]' => 'default_cat_id no válido: [_1]',
	'Invalid encoding: [_1]' => 'Codificación no válida: [_1]',
	'Invalid import_type: [_1]' => 'import_type no válido: [_1]',
	'Preview data not found.' => 'Datos de previsualización no encontrados.',
	'You need to provide a parameter "password" if you are going to create new users for each user listed in your blog.' => 'Debe indicar un parámetro "password" si va a crear nuevos usuarios para cada usuario listado en el blog.',
	q{Make sure that you remove the files that you imported from the 'import' folder, so that if/when you run the import process again, those files will not be re-imported.} => q{Asegúrese de borrar los ficheros importados del directorio 'import', para evitar procesarlos de nuevo al ejecutar en otra ocasión el proceso de importación.},

## lib/MT/DataAPI/Endpoint/v2/Group.pm
	'A resource "member" is required.' => 'Se necesita un "miembro" de recursos.',
	'Adding member to group failed: [_1]' => 'Fallo al añadir miembro al grupo: [_1]',
	'Cannot add member to inactive group.' => 'No se puede añadir un miembro a un grupo inactivo.',
	'Creating group failed: ExternalGroupManagement is enabled.' => 'Falló la creación del grupo: ExternalGroupManagement está activado.',
	'Group not found' => 'Grupo no encontrado',
	'Member not found' => 'Miembro no encontrado',
	'Removing member from group failed: [_1]' => 'Fallo al borrar miembro del grupo: [_1]',

## lib/MT/DataAPI/Endpoint/v2/Log.pm
	'Log message' => 'Mensaje del registro',

## lib/MT/DataAPI/Endpoint/v2/Page.pm
	q{'folder' parameter is invalid.} => q{El parámetro 'folder' no es válido.},

## lib/MT/DataAPI/Endpoint/v2/Permission.pm
	'Association not found' => 'Asociación no encontrada.',
	'Granting permission failed: [_1]' => 'Falló la concesión de permisos: [_1]',
	'Revoking permission failed: [_1]' => 'Falló la revocación de permisos: [_1]',
	'Role not found' => 'Rol no encontrado',

## lib/MT/DataAPI/Endpoint/v2/Plugin.pm
	'Plugin not found' => 'Extensión no encontrada',

## lib/MT/DataAPI/Endpoint/v2/Tag.pm
	'Cannot delete private tag associated with objects in system scope.' => 'No se puede eliminar la etiqueta privada asociada a los objetos del sistema.',
	'Cannot delete private tag in system scope.' => 'No se puede eliminar la etiqueta privada en el ámbito del sistema',
	'Tag not found' => 'Etiqueta no encontrada',

## lib/MT/DataAPI/Endpoint/v2/Template.pm
	'A parameter "refresh_type" is invalid: [_1]' => 'Un parámetro "refresh_type" no es válido: [_1]',
	'A resource "template" is required.' => 'Se necesita una "plantilla" de recursos.',
	'Cannot clone [_1] template.' => 'No se pudo clonar la plantilla [_1].',
	'Cannot delete [_1] template.' => 'No se pudo borrar la plantilla [_1].',
	'Cannot get [_1] template.' => '', # Translate - New
	'Cannot preview [_1] template.' => '', # Translate - New
	'Cannot publish [_1] template.' => 'No se pudo borrar la plantilla [_1].',
	'Cannot refresh [_1] template.' => '', # Translate - New
	'Cannot update [_1] template.' => '', # Translate - New
	'Template not found' => 'Plantilla no encontrada',

## lib/MT/DataAPI/Endpoint/v2/TemplateMap.pm
	'Template "[_1]" is not an archive template.' => 'La plantilla "[_1]" no es un fichero de plantillas.',

## lib/MT/DataAPI/Endpoint/v2/Theme.pm
	'Applying theme failed: [_1]' => 'Falló al cambiar el diseño: [_1]',
	'Cannot apply website theme to blog.' => 'No se puede utilizar un diseño de sitios web en un blog.',
	'Cannot uninstall theme because the theme is in use.' => 'No se pudo desinstalar este diseño porque está en uso.',
	'Cannot uninstall this theme.' => 'No se pudo desinstalar este diseño.',
	'Changing site theme failed: [_1]' => 'Falló el cambio de diseño: [_1]',
	'Unknown archiver type: [_1]' => 'Tipo de archivador desconocido: [_1]',
	'theme_id may only contain letters, numbers, and the dash or underscore character. The theme_id must begin with a letter.' => 'theme_id solo puede contener letras, números, guión o subrayado. El theme_id debe comenzar con una letra.',
	'theme_version may only contain letters, numbers, and the dash or underscore character.' => 'theme_version solo puede contener letras, números, guión o subrayado.',
	q{Cannot install new theme with existing (and protected) theme's basename: [_1]} => q{No se pudo instalar el nuevo diseño con el nombre base ya existente (y protegido): [_1]},
	q{Export theme folder already exists '[_1]'. You can overwrite an existing theme with 'overwrite_yes=1' parameter, or change the Basename.} => q{El directorio de exportación ya existe '[_1]'. Puede sobreescribir un diseño existente con el parámetro 'overwrite_yes=1', o modificando el nombre base.},

## lib/MT/DataAPI/Endpoint/v2/User.pm
	'An email with a link to reset your password has been sent to your email address ([_1]).' => 'Se ha enviado a su dirección de correo ([_1]) un correo con el enlace para reiniciar la contraseña',
	'The email address provided is not unique. Please enter your username by "name" parameter.' => 'La dirección de correo indicada no es única. Por favor, introduzca su nombre de usuario con el parámetro "name".',

## lib/MT/DataAPI/Endpoint/v2/Widget.pm
	'Removing Widget failed: [_1]' => 'Falló el borrado del widget: [_1]',
	'Widget not found' => 'Widget no encontrado.',
	'Widgetset not found' => 'Conjunto de widgets no encontrado',

## lib/MT/DataAPI/Endpoint/v2/WidgetSet.pm
	'A resource "widgetset" is required.' => 'Se necesita un recurso "widgetset".',
	'Removing Widgetset failed: [_1]' => 'Fallo al eliminar el conjunto de widgets: [_1]',

## lib/MT/DataAPI/Endpoint/v4/ContentField.pm
	'A parameter "content_fields" is invalid.' => 'El parámetro "content_fields" no es válido.',
	'A parameter "content_fields" is required.' => 'El parámetro "content_fields" es necesario.',

## lib/MT/DataAPI/Resource.pm
	'Cannot parse "[_1]" as an ISO 8601 datetime' => 'No se pudo interpretar "[_1]" como fecha en formato ISO 8601',

## lib/MT/DefaultTemplates.pm
	'About This Page' => 'Página Sobre mi',
	'Archive Index' => 'Índice de archivos',
	'Archive Widgets Group' => 'Grupo de widgets de archivos',
	'Blog Index' => 'Índice del blog',
	'Calendar' => 'Calendario',
	'Category Entry Listing' => 'Lista de entradas por categorías',
	'Comment Form' => 'Formulario de comentarios',
	'Creative Commons' => 'Creative Commons',
	'Current Author Monthly Archives' => 'Archivos mensuales del autor actual',
	'Date-Based Author Archives' => 'Archivos de autores por fecha',
	'Date-Based Category Archives' => 'Archivos de categorías por fecha',
	'Displays errors for dynamically-published templates.' => 'Mostrar errores de las plantillas publicadas dinámicamente.',
	'Displays image when user clicks a popup-linked image.' => 'Muestra una imagen cuando el usuario hace clic en una imagen con enlace a una ventana emergente.',
	'Displays results of a search.' => 'Muestra los resultados de una búsqueda.',
	'Dynamic Error' => 'Error dinámico',
	'Entry Notify' => 'Notificación de entradas',
	'Feed - Recent Entries' => 'Sindicación - Entradas recientes',
	'Home Page Widgets Group' => 'Grupo de widgets de la página de inicio',
	'IP Address Lockout' => 'Bloqueo de direcciones IP',
	'JavaScript' => 'JavaScript',
	'Monthly Archives Dropdown' => 'Desplegable de archivos mensuales',
	'Monthly Entry Listing' => 'Lista mensual de entradas',
	'Navigation' => 'Navegación',
	'OpenID Accepted' => 'OpenID aceptado',
	'Page Listing' => 'Lista de páginas',
	'Popup Image' => 'Imagen emergente',
	'Powered By' => 'Powered By',
	'RSD' => 'RSD',
	'Search Results for Content Data' => 'Resultados de la búsqueda para datos de contenido',
	'Stylesheet' => 'Hoja de estilo',
	'Syndication' => 'Sindicación',
	'User Lockout' => 'Bloqueo de usuarios',

## lib/MT/Entry.pm
	'-' => '-',
	'Accept Comments' => 'Aceptar comentarios',
	'Accept Trackbacks' => 'Aceptar TrackBacks',
	'Author ID' => 'ID Autor',
	'Body' => 'Cuerpo',
	'Draft Entries' => 'Borradores de entradas',
	'Draft' => 'Borrador',
	'Entries by [_1]' => 'Entradas de [_1]',
	'Entries from category: [_1]' => 'Entradas en la categoría: [_1]',
	'Entries in This Site' => 'Entradas en este sitio',
	'Extended' => 'Extendido',
	'Format' => 'Formato',
	'Future' => 'Futuro',
	'Invalid arguments. They all need to be saved MT::Asset objects.' => 'Argumentos no válidos. Todos deben ser objetos MT::Asset guardados.',
	'Invalid arguments. They all need to be saved MT::Category objects.' => 'Argumentos no válidos. Todos deben ser objetos MT::Category guardados.',
	'Junk' => 'Basura',
	'My Entries' => 'Mis entradas',
	'NONE' => 'ninguno',
	'Primary Category' => 'Categoría principal',
	'Published Entries' => 'Entradas publicadas',
	'Published' => 'Publicado',
	'Review' => 'Revisar',
	'Reviewing' => 'En revisión',
	'Scheduled Entries' => 'Entradas programadas',
	'Scheduled' => 'Programado',
	'Spam' => 'Spam',
	'Unpublished (End)' => 'Despublicar (fin)',
	'Unpublished Entries' => 'Entradas no publicadas',
	'View [_1]' => 'Ver [_1]',

## lib/MT/FileMgr/DAV.pm
	'DAV connection failed: [_1]' => 'Falló la conexión DAV: [_1]',
	q{Creating path '[_1]' failed: [_2]} => q{Fallo creando la ruta '[_1]': [_2]},
	q{DAV get failed: [_1]} => q{Falló la orden 'get' en el DAV: [_1]},
	q{DAV open failed: [_1]} => q{Falló la orden 'open' en el DAV: [_1]},
	q{DAV put failed: [_1]} => q{Falló la orden 'put' en el DAV: [_1]},
	q{Deleting '[_1]' failed: [_2]} => q{Fallo borrando '[_1]': [_2]},
	q{Renaming '[_1]' to '[_2]' failed: [_3]} => q{Fallo renombrando '[_1]' a '[_2]': [_3]},

## lib/MT/FileMgr/SFTP.pm
	'SFTP connection failed: [_1]' => 'Fallo en la conexión SFTP: [_1]',
	q{SFTP get failed: [_1]} => q{Falló la orden 'get' en el SFTP: [_1]},
	q{SFTP put failed: [_1]} => q{Falló la orden 'put' en el SFTP: [_1]},

## lib/MT/Filter.pm
	'"editable_terms" and "editable_filters" cannot be specified at the same time.' => 'No pueden utilizarse al mismo tiempo "editable_terms" y "editable_filters".',
	'Invalid filter type [_1]:[_2]' => 'Tipo de filtro no válido [_1]:[_2]',
	'Invalid sort key [_1]:[_2]' => 'Clave de ordenación no válida [_1]:[_2]',

## lib/MT/Group.pm
	'Active Groups' => 'Grupos activos',
	'Disabled Groups' => 'Grupos deshabilitados',
	'Email' => 'Correo electrónico',
	'Groups associated with author: [_1]' => 'Grupos asociados con autor: [_1]',
	'Inactive' => 'Inactivo',
	'Members of group: [_1]' => 'Miembros del grupo: [_1]',
	'My Groups' => 'Mis grupos',
	'__COMMENT_COUNT' => 'Comentarios',
	'__GROUP_MEMBER_COUNT' => 'Miembros',

## lib/MT/IPBanList.pm
	'IP Ban' => 'Bloqueo de IP',
	'IP Bans' => 'Bloqueos de IP',

## lib/MT/Image.pm
	'File size exceeds maximum allowed: [_1] > [_2]' => 'El tamaño del fichero excede el máximo permitido: [_1] > [_2]',
	'Invalid Image Driver [_1]' => 'Controlador de imágenes [_1] no válido',
	'Saving [_1] failed: Invalid image file format.' => 'Falló guardando [_1]: Formato de fichero de imagen no válido.',

## lib/MT/Image/GD.pm
	'Cannot load GD: [_1]' => 'No se puede cargar GD: [_1]',
	'Reading image failed: [_1]' => 'Fallo leyendo imagen: [_1]',
	'Rotate (degrees: [_1]) is not supported' => 'La rotación (grados: [_1]) no está soportada',
	'Unsupported image file type: [_1]' => 'Tipo de imagen no soportada: [_1]',
	q{Reading file '[_1]' failed: [_2]} => q{Fallo leyendo archivo '[_1]': [_2]},

## lib/MT/Image/ImageMagick.pm
	'Cannot load [_1]: [_2]' => '', # Translate - New
	'Converting image to [_1] failed: [_2]' => 'Fallo convirtiendo una imagen a [_1]: [_2]',
	'Cropping a [_1]x[_2] square at [_3],[_4] failed: [_5]' => 'Fallo al recortar un cuadrado [_1]x[_2] en [_3],[_4]: [_5]',
	'Flip horizontal failed: [_1]' => 'Falló el giro horizontal: [_1]',
	'Flip vertical failed: [_1]' => 'Falló el giro vertical: [_1]',
	'Outputting image failed: [_1]' => 'Fallo al crear la imagen: [_1]',
	'Rotate (degrees: [_1]) failed: [_2]' => 'Falló la rotación (grados: [_1]): [_2]',
	'Scaling to [_1]x[_2] failed: [_3]' => 'El escalado a [_1]x[_2] falló: [_3]',

## lib/MT/Image/Imager.pm
	'Cannot load Imager: [_1]' => 'No se pudo cargar Imager: [_1]',

## lib/MT/Image/NetPBM.pm
	'Cannot load IPC::Run: [_1]' => 'No se pudo cargar IPC::Run: [_1]',
	'Cropping to [_1]x[_2] failed: [_3]' => 'Fallo al recortar a [_1]x[_2]: [_3]',
	'Reading alpha channel of image failed: [_1]' => 'Fallo al leer el canal alfa de la imagen: [_1]',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'No posee una ruta válida a las herramientas NetPBMYou en su máquina.',

## lib/MT/Import.pm
	'Another system (Movable Type format)' => 'Otro sistema (formato Movable Type)',
	'Could not resolve import format [_1]' => 'No se pudo identificar el formato de importación [_1]',
	'File not found: [_1]' => 'Fichero no encontrado: [_1]',
	'No readable files could be found in your import directory [_1].' => 'No se encontrón ningún fichero legible en su directorio de importación [_1].',
	q{Cannot open '[_1]': [_2]} => q{No se pudo abrir '[_1]': [_2]},
	q{Importing entries from file '[_1]'} => q{Importando entradas desde el fichero '[_1]'},

## lib/MT/ImportExport.pm
	'Need either ImportAs or ParentAuthor' => 'Necesita ImportAs o ParentAuthor',
	'No Blog' => 'Sin Blog',
	'Saving category failed: [_1]' => 'Fallo guardando categoría: [_1]',
	'Saving entry failed: [_1]' => 'Fallo guardando entrada: [_1]',
	'Saving user failed: [_1]' => 'Fallo guardando usuario: [_1]',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'Si va a crear nuevos usuarios por cada usuario listado en su blog, debe proveer una contraseña.',
	'ok (ID [_1])' => 'ok (ID [_1])',
	q{Cannot find existing entry with timestamp '[_1]'... skipping comments, and moving on to next entry.} => q{No se encontró una entrada existente con la fecha '[_1]'... ignorando comentarios, y pasando a la siguiente entrada.},
	q{Creating new category ('[_1]')...} => q{Creando nueva categoría ('[_1]')...},
	q{Creating new user ('[_1]')...} => q{Creando usuario ('[_1]')...},
	q{Export failed on entry '[_1]': [_2]} => q{Fallo de exportación en la entrada '[_1]': [_2]},
	q{Importing into existing entry [_1] ('[_2]')} => q{Importando en entrada existente [_1] ('[_2]')},
	q{Invalid allow pings value '[_1]'} => q{Valor no válido de permiso de pings '[_1]'},
	q{Invalid date format '[_1]'; must be 'MM/DD/YYYY HH:MM:SS AM|PM' (AM|PM is optional)} => q{Formato de fecha '[_1]' no válido; debe ser 'MM/DD/AAAA HH:MM:SS AM|PM' (AM|PM es opcional)},
	q{Invalid status value '[_1]'} => q{Valor de estado no válido '[_1]'},
	q{Saving entry ('[_1]')...} => q{Guardando entrada ('[_1]')...},

## lib/MT/JunkFilter.pm
	'Action: Junked (score below threshold)' => 'Acción: Basura (puntuación bajo nivel)',
	'Action: Published (default action)' => 'Acción: Publicado (acción predefinida)',
	'Composite score: [_1]' => 'Puntuación compuesta: [_1]',
	'Junk Filter [_1] died with: [_2]' => 'Filtro basura [_1] murió con: [_2]',
	'Unnamed Junk Filter' => 'Filtro basura sin nombre',

## lib/MT/ListProperty.pm
	'Cannot initialize list property [_1].[_2].' => 'No se pudo inicializar la propiedad de listas [_1].[_2].',
	'Failed to initialize auto list property [_1].[_2]: Cannot find definition of column [_3].' => 'Falló al inicializar automáticamente la lista de propiedades [_1]. [_2] No se pudo encontrar la definición de la columna [_3].',
	'Failed to initialize auto list property [_1].[_2]: unsupported column type.' => 'Falló al inicializar automáticamente la lista de propiedades [_1]. [_2]: Tipo de columna no soportada.',
	'[_1] (id:[_2])' => '[_1] (ID:[_2])',

## lib/MT/Lockout.pm
	'IP Address Was Locked Out' => 'Se desbloqueó la dirección IP.',
	'IP address was locked out. IP address: [_1], Username: [_2]' => 'Se desbloqueó la dirección IP. Dirección IP: [_1], Usuario: [_2]',
	'User Was Locked Out' => 'Se desbloqueó al usuario.',
	'User has been unlocked. Username: [_1]' => 'Se desbloqueó al usuario. Usuario: [_1]',
	'User was locked out. IP address: [_1], Username: [_2]' => 'Se desbloqueó al usuario. Dirección IP: [_1], Usuario: [_2]',

## lib/MT/Log.pm
	'By' => 'Por',
	'Class' => 'Clase',
	'Comment # [_1] not found.' => 'Comentario nº [_1] no encontrado.',
	'Debug' => 'Depuración',
	'Debug/error' => 'Depuración/error',
	'Entry # [_1] not found.' => 'Entrada nº [_1] no encontrada.',
	'Information' => 'Información',
	'Level' => 'Nivel',
	'Log messages' => 'Mensajes del registro',
	'Logs on This Site' => 'Históricos de este sitio',
	'Message' => 'Mensaje',
	'Metadata' => 'Metadatos',
	'Not debug' => 'No depuración',
	'Notice' => 'Información importante',
	'Page # [_1] not found.' => 'Página nº [_1] no encontrada.',
	'Security or error' => 'Seguridad o error',
	'Security' => 'Seguridad',
	'Security/error/warning' => 'Seguridad/error/alarma',
	'Show only errors' => 'Mostrar solo los errores',
	'TrackBack # [_1] not found.' => 'TrackBack nº [_1] no encontrado.',
	'TrackBacks' => 'TrackBacks',
	'Warning' => 'Alerta',
	'author' => 'autor',
	'folder' => 'carpeta',
	'page' => 'Página',
	'ping' => 'ping',
	'plugin' => 'extensión',
	'search' => 'buscar',
	'theme' => 'tema',

## lib/MT/Mail.pm
	'Authentication failure: [_1]' => 'Fallo de autentificación: [_1]',
	'Error connecting to SMTP server [_1]:[_2]' => 'Error conectado con el servidor SMTP [_1]:[_2]',
	'Exec of sendmail failed: [_1]' => 'Fallo la ejecución de sendmail: [_1]',
	'Following required module(s) were not found: ([_1])' => 'No se encontraron los siguientes módulos requeridos: ([_1])',
	'Username and password is required for SMTP authentication.' => 'El nombre de usuario y la contraseña son necesarios para la autentificación SMTP.',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'No tiene configurada una ruta válida a sendmail en su máquina. ¿Quizás está intentando usar SMTP?',
	q{Unknown MailTransfer method '[_1]'} => q{MailTransfer método desconocido '[_1]'},

## lib/MT/Notification.pm
	'Cancel' => 'Cancelar',
	'Click to edit contact' => 'Clic para editar el contacto',
	'Contacts' => 'Contactos',
	'Save Changes' => 'Guardar cambios',

## lib/MT/ObjectAsset.pm
	'Asset Placement' => 'Posición del elemento multimedia',

## lib/MT/ObjectCategory.pm
	'Category Placement' => 'Ubicación de las categorías',
	'Category Placements' => 'Ubicaciones de las categorías',

## lib/MT/ObjectScore.pm
	'Object Score' => 'Score del Objeto',
	'Object Scores' => 'Scores de los Objetos',

## lib/MT/ObjectTag.pm
	'Tag Placement' => 'Gestión de Etiqueta',
	'Tag Placements' => 'Gestión de las Etiquetas',

## lib/MT/Page.pm
	'(root)' => '(raíz)',
	'Draft Pages' => 'Borradores de páginas',
	'Loading blog failed: [_1]' => 'Falló al cargar el blog: [_1]',
	'My Pages' => 'Mis páginas',
	'Pages in This Site' => 'Páginas de esta sitio',
	'Pages in folder: [_1]' => 'Páginas en carpeta: [_1]',
	'Published Pages' => 'Páginas publicadas',
	'Scheduled Pages' => 'Páginas programadas',
	'Unpublished Pages' => 'Páginas no publicadas',

## lib/MT/ParamValidator.pm
	'Invalid validation rules: [_1]' => '', # Translate - New
	'Unknown validation rule: [_1]' => '', # Translate - New
	q{'[_1]' has multiple values} => q{}, # Translate - New
	q{'[_1]' is required} => q{}, # Translate - New
	q{'[_1]' requires a valid ID} => q{}, # Translate - New
	q{'[_1]' requires a valid email} => q{}, # Translate - New
	q{'[_1]' requires a valid integer} => q{}, # Translate - New
	q{'[_1]' requires a valid number} => q{}, # Translate - New
	q{'[_1]' requires a valid objtype} => q{}, # Translate - New
	q{'[_1]' requires a valid string} => q{}, # Translate - New
	q{'[_1]' requires a valid text} => q{}, # Translate - New
	q{'[_1]' requires a valid word} => q{}, # Translate - New
	q{'[_1]' requires a valid xdigit value} => q{}, # Translate - New
	q{'[_1]' requires valid (concatenated) IDs} => q{}, # Translate - New
	q{'[_1]' requires valid (concatenated) words} => q{}, # Translate - New

## lib/MT/Plugin.pm
	'My Text Format' => 'Mi formato de texto',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: [_2][_3] de la regla [_4][_5]',
	'[_1]: [_2][_3] from test [_4]' => '[_1]: [_2][_3] de la prueba [_4]',

## lib/MT/PluginData.pm
	'Plugin Data' => 'Datos de la extensión',

## lib/MT/RebuildTrigger.pm
	'Restoring Rebuild Trigger for Content Type #[_1]...' => 'Restaurando el inductor de reconstrucción del tipo de contenido #[_1]',
	'Restoring rebuild trigger for blog #[_1]...' => 'Restaurando el inductor de reconstrucción del blog #[_1]',

## lib/MT/Revisable.pm
	'Did not get two [_1]' => 'No se obtuvieron dos [_1]',
	'Revision Number' => 'Revisión número',
	'Revision not found: [_1]' => 'Revisión no encontrada: [_1]',
	'There are not the same types of objects, expecting two [_1]' => 'No son el mismo tipo de objetos, se esperaban dos [_1]',
	'Unknown method [_1]' => 'Método desconocido [_1]',
	q{Bad RevisioningDriver config '[_1]': [_2]} => q{Configuración de RevisioningDriver errónea '[_1]': [_2]},

## lib/MT/Role.pm
	'Can administer the site.' => 'Puede administrar el sitio.',
	'Can create entries, edit their own entries, and comment.' => 'Puede crear entradas, editar sus propias entradas y comentar.',
	'Can create entries, edit their own entries, upload files and publish.' => 'Puede crear entradas, editar sus propias entradas, subir ficheros y publicar.',
	'Can edit, manage, and publish blog templates and themes.' => 'Puede editar, administrar y publicar plantillas y temas de blogs.',
	'Can manage content types, content data and category sets.' => 'Puede administrar tipos de contenido, datos de contenido y conjuntos de categorías.',
	'Can manage pages, upload files and publish site/child site templates.' => 'Puede administrar páginas, transferir ficheros y publicar plantillas para sitios y sitios hijos.',
	'Can upload files, edit all entries(categories), pages(folders), tags and publish the site.' => 'Puede subir ficheros, editar todas las entradas (categorías), páginas (carpetas), etiquetas y publicar el sitio.',
	'Content Designer' => 'Diseñador de contenidos',
	'Contributor' => 'Colaborador',
	'Designer' => 'Diseñador',
	'Editor' => 'Editor',
	'Site Administrator' => 'Administrador del sitio',
	'Webmaster' => 'Webmaster',
	'__ROLE_ACTIVE' => 'Activo',
	'__ROLE_INACTIVE' => 'Inactivo',
	'__ROLE_STATUS' => 'Estado',

## lib/MT/Scorable.pm
	'Already scored for this object.' => 'Ya puntuado en este objeto.',
	'Object must be saved first.' => 'Primero debe guardarse el objeto.',
	q{Could not set score to the object '[_1]'(ID: [_2])} => q{No pudo darse puntuación al objeto '[_1]'(ID: [_2])},

## lib/MT/Session.pm
	'Session' => 'Sección',

## lib/MT/Tag.pm
	'Not Private' => 'No privado',
	'Private' => 'Privado',
	'Tag must have a valid name' => 'La etiqueta debe tener un nombre válido',
	'Tags with Assets' => 'Etiquetas con ficheros multimedia',
	'Tags with Entries' => 'Etiquetas con entradas',
	'Tags with Pages' => 'Etiquetas con páginas',
	'This tag is referenced by others.' => 'Esta etiqueta está referenciada por otros.',

## lib/MT/TaskMgr.pm
	'Scheduled Tasks Update' => 'Actualización de tareas programadas',
	'The following tasks were run:' => 'Se ejecutaron las siguientes tareas:',
	'Unable to secure a lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'No fue posible asegurar el bloqueo para la ejecución de tareas del sistema. Asegúrese de que se puede escribir en el directorio TempDir ([_1]).',
	q{Error during task '[_1]': [_2]} => q{Error durante la tarea '[_1]': [_2]},

## lib/MT/Template.pm
	'Build Type' => 'Tipo de reconstrucción',
	'Category Archive' => 'Archivo de categorías',
	'Comment Error' => 'Error de comentarios',
	'Comment Listing' => 'Lista de comentarios',
	'Comment Pending' => 'Comentario pendiente',
	'Comment Preview' => 'Vista previa de comentario',
	'Content Type is required.' => 'Se necesita un tipo de contenido.',
	'Dynamicity' => 'Dinamicidad',
	'Index' => 'Índice',
	'Individual' => '', # Translate - New
	'Interval' => 'Intervalo',
	'Module' => 'Módulo',
	'Output File' => 'Fichero de salida',
	'Ping Listing' => 'Lista de pings',
	'Rebuild with Indexes' => 'Reconstruir con índices',
	'Template Text' => 'Texto de la plantilla',
	'Template load error: [_1]' => 'Error al cargar plantilla: [_1]',
	'Template name must be unique within this [_1].' => 'El nombre de la plantilla debe ser único en este [_1].',
	'Template' => 'Plantilla',
	'Uploaded Image' => 'Imagen transferida',
	'Widget' => 'Widget',
	'You cannot use a [_1] extension for a linked file.' => 'No puede usar una extensión [_1] para un fichero enlazado.',
	q{Error reading file '[_1]': [_2]} => q{Error leyendo fichero '[_1]': [_2]},
	q{Opening linked file '[_1]' failed: [_2]} => q{Fallo abriendo fichero enlazado'[_1]': [_2]},
	q{Publish error in template '[_1]': [_2]} => q{Error de publicación en la plantilla '[_1]': [_2]},
	q{Tried to load the template file from outside of the include path '[_1]'} => q{Tried to load the template file from outside of the include path '[_1]'},

## lib/MT/Template/Context.pm
	'No Category Set could be found.' => 'No se pudo encontrar un conjunto de categorías.',
	'No Content Field could be found.' => 'No se pudo encontrar un campo de contenido.',
	'No Content Field could be found: "[_1]"' => '', # Translate - New
	'When the same blog IDs are simultaneously listed in the include_blogs and exclude_blogs attributes, those blogs are excluded.' => 'Si hay identificadores de blogs listados a la vez en los atributos de include_blogs y exclude_blogs, se excluirá a dichos blogs.',
	q{The attribute exclude_blogs cannot take '[_1]' for a value.} => q{El atributo exclude_blogs no puede tener el valor '[_1]'.},
	q{You have an error in your '[_2]' attribute: [_1]} => q{Tiene un error en el atributo '[_2]': [_1]},
	q{You used an '[_1]' tag inside of the context of a blog which has no parent website; Perhaps your blog record is broken?} => q{Ha utilizado una etiqueta '[_1]' en el contexto de un blog que no tiene un sitio web raíz. ¿Quizás el registro del blog está mal?},
	q{You used an '[_1]' tag outside of the context of a author; Perhaps you mistakenly placed it outside of an 'MTAuthors' container tag?} => q{Utilizó una etiqueta '[_1]' fuera del contexto de un autor. ¿Quizás la situó por error fuera de la etiqueta contenedora 'MTAuthors'?},
	q{You used an '[_1]' tag outside of the context of a comment; Perhaps you mistakenly placed it outside of an 'MTComments' container tag?} => q{Utilizó una etiqueta '[_1]' fuera del contexto de un comentario. ¿Quizás la situó por error fuera de la etiqueta contenedor 'MTComments'?},
	q{You used an '[_1]' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an 'MTContents' container tag?} => q{Usó una etiqueta '[_1]' fuera del contexto de un contenido. ¿Quizás la situó fuera de una etiqueta contenedora 'MTContents'?},
	q{You used an '[_1]' tag outside of the context of a page; Perhaps you mistakenly placed it outside of a 'MTPages' container tag?} => q{Utilizó una etiqueta '[_1]' fuera del contexto de una página. ¿Quizás la situó por error fuera de la etiqueta contenedor 'MTPages'?},
	q{You used an '[_1]' tag outside of the context of a ping; Perhaps you mistakenly placed it outside of an 'MTPings' container tag?} => q{Utilizó una etiqueta '[_1]' fuera del contexto de un ping. ¿Quizás la situó por error fuera de la etiqueta contenedor 'MTPings'?},
	q{You used an '[_1]' tag outside of the context of an asset; Perhaps you mistakenly placed it outside of an 'MTAssets' container tag?} => q{Utilizó una etiqueta '[_1]' fuera del contexto de un recurso multimedia. ¿Quizás la situó por error fuera de la etiqueta contenedor 'MTAssets'?},
	q{You used an '[_1]' tag outside of the context of an entry; Perhaps you mistakenly placed it outside of an 'MTEntries' container tag?} => q{Utilizó una etiqueta '[_1]' fuera del contexto de una entrada. ¿Quizás la situó por error fuera de la etiqueta contenedor 'MTEntries'?},
	q{You used an '[_1]' tag outside of the context of the blog; Perhaps you mistakenly placed it outside of an 'MTBlogs' container tag?} => q{Utilizó una etiqueta '[_1]' fuera del contexto de un blog. ¿Quizás la situó por error fuera de la etiqueta contenedor 'MTBlogs'?},
	q{You used an '[_1]' tag outside of the context of the site;} => q{Utilizó una etiqueta '[_1]' fuera del contexto del sitio;},
	q{You used an '[_1]' tag outside of the context of the website; Perhaps you mistakenly placed it outside of an 'MTWebsites' container tag?} => q{Utilizó una etiqueta '[_1]' fuera del contexto de una sitio web. ¿Quizás la situó por error fuera de la etiqueta contenedor 'MTWebsites'?},

## lib/MT/Template/ContextHandlers.pm
	', letters and numbers' => ', letras y números',
	', symbols (such as #!$%)' => ', símbolos (como #!$%)',
	', uppercase and lowercase letters' => ', letras mayúsculas y minúsculas',
	'Actions' => 'Acciones',
	'All About Me' => 'Todo sobre mi',
	'Cannot load template' => 'No se pudo cargar la plantilla',
	'Cannot load user.' => 'No se pudo cargar el usuario.',
	'Choose the display options for this content field in the listing screen.' => 'Seleccione las opciones de visualización para este campo de contenido en la pantalla de listas.',
	'Default' => 'Predefinido',
	'Display Options' => 'Opciones de visualización',
	'Division by zero.' => 'División por cero.',
	'Error in [_1] [_2]: [_3]' => 'Error en [_1] [_2]: [_3]',
	'Error in file template: [_1]' => 'Error en fichero de plantilla: [_1]',
	'File inclusion is disabled by "AllowFileInclude" config directive.' => 'La inclusión de ficheros está deshabilitada por la directiva de configuración "AllowFileInclude".',
	'Force' => 'Forzar',
	'Invalid index.' => 'Índice no válido.',
	'Is this field required?' => '¿Este campo es obligatorio?',
	'No [_1] could be found.' => 'No se encontraron [_1].',
	'No template to include was specified' => 'No se especificó plantilla a incluir',
	'Optional' => 'Opcional',
	'Recursion attempt on [_1]: [_2]' => 'Intento de recursión en [_1]: [_2]',
	'Recursion attempt on file: [_1]' => 'Intento de recursión en fichero: [_1]',
	'The entered message is displayed as a input field hint.' => 'El mensaje introducido se mostrará como una sugerencia del campo de texto.',
	'Unspecified archive template' => 'Archivo de plantilla no especificado',
	'You used a [_1] tag without a valid name attribute.' => 'Usó la etiqueta [_1] sin un nombre de atributo válido.',
	'You used an [_1] tag without a date context set up.' => 'Usó una etiqueta [_1] sin un contexto de fecha configurado.',
	'You used an [_1] tag without a valid [_2] attribute.' => 'Utilizó una etiqueta [_1] sin un atributo [_2] válido.',
	'[_1] [_2]' => '[_1] [_2]',
	'[_1] is not a hash.' => '[_1] no es un hash.',
	'[_1]Publish[_2] your [_3] to see these changes take effect.' => '[_1]Publique[_2] su [_3] para que los cambios tomen efecto.',
	'[_1]Publish[_2] your site to see these changes take effect, even when publishing profile is dynamic publishing.' => '', # Translate - New
	'[_1]Publish[_2] your site to see these changes take effect.' => '[_1]Publique[_2] el sitio para que los cambios tomen efecto.',
	'blog(s)' => 'blog/s',
	'https://www.movabletype.org/documentation/appendices/tags/%t.html' => 'https://www.movabletype.org/documentation/appendices/tags/%t.html',
	'id attribute is required' => 'el atributo id es necesario',
	'minimum length of [_1]' => 'longitud mínima de [_1]',
	'records' => 'registros',
	'website(s)' => 'sitio/s web',
	q{'[_1]' is not a hash.} => q{'[_1]' no es un hash.},
	q{'[_1]' is not a valid function for a hash.} => q{'[_1]' no es una función válida para un hash.},
	q{'[_1]' is not a valid function for an array.} => q{'[_1]' no es una función válida para un array.},
	q{'[_1]' is not a valid function.} => q{'[_1]' no es una función válida.},
	q{'[_1]' is not an array.} => q{'[_1]' no es un array.},
	q{'parent' modifier cannot be used with '[_1]'} => q{el modificador 'parent' no puede usarse con '[_1]'},
	q{Cannot find blog for id '[_1]} => q{No se pudo encontrar un blog con el id '[_1]},
	q{Cannot find entry '[_1]'} => q{No se encontró la entrada '[_1]'},
	q{Cannot find included file '[_1]'} => q{No se encontró el fichero incluido '[_1]'},
	q{Cannot find included template [_1] '[_2]'} => q{No se encontró la plantilla incluída [_1] '[_2]'},
	q{Cannot find template '[_1]'} => q{No se encontró la plantilla '[_1]'},
	q{Error opening included file '[_1]': [_2]} => q{Error abriendo el fichero incluido '[_1]': [_2]},

## lib/MT/Template/Tags/Archive.pm
	'Could not determine content' => 'No se pudo determinar el contenido',
	'Could not determine entry' => 'No se pudo determinar la entrada',
	'Group iterator failed.' => 'Fallo en iterador de grupo.',
	'You used an [_1] tag outside of the proper context.' => 'Usó una etiqueta [_1] fuera del contexto correcto.',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] sólo se puede usar con los archivos diarios, semanales o mensuales.',
	q{You used an [_1] tag for linking into '[_2]' archives, but that archive type is not published.} => q{Usó una etiqueta [_1] enlazando los archivos '[_2]', pero el tipo de archivo no está publicado.},

## lib/MT/Template/Tags/Asset.pm
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" debe usarse en combinación con el espacio de nombres.',
	q{No such user '[_1]'} => q{No existe el usuario '[_1]'},

## lib/MT/Template/Tags/Author.pm
	'You used an [_1] without a author context set up.' => 'Utilizó un [_1] sin establecer un contexto de autor.',
	q{The '[_2]' attribute will only accept an integer: [_1]} => q{El atributo '[_2]' solo aceptará un entero: [_1]},

## lib/MT/Template/Tags/Blog.pm
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Valor del atributo "mode" desconocido: [_1]. Los valores válidos son "loop" y "context".',

## lib/MT/Template/Tags/Calendar.pm
	'Invalid month format: must be YYYYMM' => 'Formato de mes no válido: debe ser YYYYMM',
	'Invalid weeks_start_with format: must be Sun|Mon|Tue|Wed|Thu|Fri|Sat' => 'Formato de weeks_start_with no válido: debe ser Sun|Mon|Tue|Wed|Thu|Fri|Sat',
	q{No such category '[_1]'} => q{No existe la categoría '[_1]'},

## lib/MT/Template/Tags/Category.pm
	'Cannot find package [_1]: [_2]' => 'No se encontró el paquete [_1]: [_2]',
	'Cannot use sort_by and sort_method together in [_1]' => 'No pueden usarse juntos sort_by y sort_method en [_1]',
	'Error sorting [_2]: [_1]' => 'Error ordenando [_2]: [_1]',
	'MT[_1] must be used in a [_2] context' => 'MT[_1] debe utilizarse en el contexto de [_2]',
	'[_1] cannot be used without publishing [_2] archive.' => '[_1] no se puede usar sin publicar un archivo de [_2].',
	'[_1] used outside of [_2]' => '[_1] utilizado fuera de [_2]',

## lib/MT/Template/Tags/ContentType.pm
	'Content Type was not found. Blog ID: [_1]' => 'No se encontró el tipo de contenido. Blog ID: [_1]',
	'Invalid field_value_handler of [_1].' => 'field_value_handler de [_1] no válido.',
	'Invalid tag_handler of [_1].' => 'tag_handler de [_1] no válido.',
	'No Content Field Type could be found.' => 'No se encontró el tipo de campo de contenido.',

## lib/MT/Template/Tags/Entry.pm
	'Could not create atom id for entry [_1]' => 'No se pudo crear un identificador atom en la entrada [_1]',
	q{You used <$MTEntryFlag$> without a flag.} => q{Usó <$MTEntryFlag$> sin 'flag'.},

## lib/MT/Template/Tags/Misc.pm
	q{Specified WidgetSet '[_1]' not found.} => q{No se encontró el conjunto de widgets '[_1]' que se especificó.},

## lib/MT/Template/Tags/Tag.pm
	'content_type modifier cannot be used with type "[_1]".' => 'No se puede usar el modificador content_type modifier con el tipo "[_1]".',

## lib/MT/TemplateMap.pm
	'Archive Mapping' => 'Mapeado de archivos',
	'Archive Mappings' => 'Mapeados de archivos',

## lib/MT/TheSchwartz/Error.pm
	'Job Error' => 'Error en la Tarea',

## lib/MT/TheSchwartz/ExitStatus.pm
	'Job Exit Status' => 'Status Fin de Tarea',

## lib/MT/TheSchwartz/FuncMap.pm
	'Job Function' => 'Funciones de la Tarea',

## lib/MT/TheSchwartz/Job.pm
	'Job' => 'Tarea',

## lib/MT/Theme.pm
	'A fatal error occurred while applying element [_1]: [_2].' => 'Error fatal al aplicar el elemento [_1]: [_2].',
	'An error occurred while applying element [_1]: [_2].' => 'Error fatal al aplicar el elemento [_1]: [_2].',
	'Default Content Data' => 'Datos de contenido prefedinido',
	'Default Pages' => 'Páginas predefinidas',
	'Default Prefs' => 'Preferencias por defecto',
	'Failed to copy file [_1]:[_2]' => 'Falló al copiar el fichero [_1]:[_2]',
	'Failed to load theme [_1].' => 'Fallo al cargar tema [_1].',
	'Static Files' => 'Ficheros estáticos',
	'Template Set' => 'Conjunto de plantillas',
	'There was an error converting image [_1].' => 'Hubo un error convirtiendo la imagen [_1].',
	'There was an error creating thumbnail file [_1].' => 'Hubo un error creando el fichero de la miniatura [_1].',
	'There was an error scaling image [_1].' => 'Hubo un error redimensionando la imagen [_1].',
	q{Component '[_1]' version [_2] or greater is needed to use this theme, but is not installed.} => q{Para usar este tema se necesita el componente '[_1]' versión [_2] o mayor, pero no está instalado.},
	q{Component '[_1]' version [_2] or greater is needed to use this theme, but the installed version is [_3].} => q{Para usar este tema se necesita el componente '[_1]' versión [_2] o mayor, pero la versión instalada es [_3].},
	q{Element '[_1]' cannot be applied because [_2]} => q{El elemento '[_1]' no se puede aplicar porque [_2]},

## lib/MT/Theme/Category.pm
	'Failed to save category_order: [_1]' => 'Fallo al guardar category_order: [_1]',
	'Failed to save folder_order: [_1]' => 'Fallo al guardar folder_order: [_1]',
	'[_1] top level and [_2] sub categories.' => '[_1] primer nivel y [_2] sub-categorías.',
	'[_1] top level and [_2] sub folders.' => '[_1] primer nivel y [_2] sub-carpetas.',

## lib/MT/Theme/CategorySet.pm
	'[_1] category sets.' => '[_1] conjuntos de categorías.',

## lib/MT/Theme/ContentData.pm
	'Failed to find content type: [_1]' => 'Fallo al buscar el tipo de contenido: [_1]',
	'Invalid theme_data_import_handler of [_1].' => 'theme_data_import_handler de [_1] no válido.',
	'[_1] content data.' => '[_1] datos de contenidos.',

## lib/MT/Theme/ContentType.pm
	'Invalid theme_import_handler of [_1].' => 'theme_import_handler de [_1] no válido.',
	'[_1] content types.' => '[_1] tipos de contenido.',
	'some content field in this theme has invalid type.' => 'algún campo de contenidos de este tema tiene un tipo no válido.',
	'some content type in this theme have been installed already.' => 'algún tipo de contenido de este tema ya está instalado.',

## lib/MT/Theme/Element.pm
	'Internal error: the importer is not found.' => 'Error interno: no se encontró el importador.',
	q{An Error occurred while applying '[_1]': [_2].} => q{Ocurrió un error al configurar '[_1]': [_2].},
	q{Compatibility error occurred while applying '[_1]': [_2].} => q{Error de compatibilidad al configurar '[_1]': [_2].},
	q{Component '[_1]' is not found.} => q{No se encontró el componente '[_1]'.},
	q{Fatal error occurred while applying '[_1]': [_2].} => q{Error fatal al configurar '[_1]': [_2].},
	q{Importer for '[_1]' is too old.} => q{El importador de '[_1]' es demasiado antiguo.},
	q{Theme element '[_1]' is too old for this environment.} => q{El elemento '[_1]' del tema es demasiado antiguo para este sistema.},

## lib/MT/Theme/Entry.pm
	'[_1] pages' => '[_1] páginas',

## lib/MT/Theme/Pref.pm
	'Failed to save blog object: [_1]' => 'Falló al guardar el objeto de blog: [_1]',
	'default settings for [_1]' => 'configuración predefinida para [_1]',
	'default settings' => 'configuración predefinida',
	'this element cannot apply for non blog object.' => 'este elemento no puede aplicarse a objetos que no sean blogs.',

## lib/MT/Theme/TemplateSet.pm
	'A template set containing [quant,_1,template,templates], [quant,_2,widget,widgets], and [quant,_3,widget set,widget sets].' => 'Un conjunto de plantillas que contiene [quant,_1,template,templates], [quant,_2,widget,widgets], y [quant,_3,conjunto de widgets,conjuntos de widgets].',
	'Failed to make templates directory: [_1]' => 'Fallo al crear el directorio de plantillas: [_1]',
	'Failed to publish template file: [_1]' => 'Fallo al publicar el fichero de plantilla: [_1]',
	'Widget Sets' => 'Conjuntos de widgets',
	'exported_template set' => 'exported_template configurado',

## lib/MT/Upgrade.pm
	'Database has been upgraded to version [_1].' => 'Se actualizó la base de datos a la versión [_1].',
	'Error loading class [_1].' => 'Error cargando clase [_1].',
	'Error loading class: [_1].' => 'Error cargando la clase: [_1].',
	'Error saving [_1] record # [_3]: [_2]...' => 'Error guardando registro [_1] # [_3]: [_2]...',
	'Invalid upgrade function: [_1].' => 'Función de actualización no válida: [_1].',
	'Upgrading database from version [_1].' => 'Actualizando base de datos desde la versión [_1].',
	'Upgrading table for [_1] records...' => 'Actualizando las tablas para los registros [_1]...',
	q{Plugin '[_1]' installed successfully.} => q{La extensión '[_1]' se actualizó correctamente.},
	q{Plugin '[_1]' upgraded successfully to version [_2] (schema version [_3]).} => q{Extensión '[_1]' actualizada con éxito a la versión [_2] (versión del esquema [_3]).},
	q{User '[_1]' installed plugin '[_2]', version [_3] (schema version [_4]).} => q{Usuario '[_1]' instaló la extensión '[_2]', versión [_3] (versión del esquema [_4]).},
	q{User '[_1]' upgraded database to version [_2]} => q{Usuario '[_1]' actualizó la base de datos a la versión [_2]},
	q{User '[_1]' upgraded plugin '[_2]' to version [_3] (schema version [_4]).} => q{Usuario '[_1]' actualizó la extensión '[_2]' a la versión [_3] (versión del esquema [_4]).},

## lib/MT/Upgrade/Core.pm
	'Assigning category parent fields...' => 'Asignando campos de ancentros en las categorías...',
	'Assigning custom dynamic template settings...' => 'Asignando opciones de plantillas dinámicas personalizadas...',
	'Assigning template build dynamic settings...' => 'Asignando opciones de construcción de plantillas dinámicas...',
	'Assigning user types...' => 'Asignando tipos de usuario...',
	'Assigning visible status for TrackBacks...' => 'Asignando estado de visiblidad para los TrackBacks...',
	'Assigning visible status for comments...' => 'Asignando estado de visibilidad a los comentarios...',
	'Creating initial user records...' => 'Creando registros de usuario iniciales...',
	'Error creating role record: [_1].' => 'Error creado el registro de roles: [_1].',
	'Error saving record: [_1].' => 'Error guardando el registro: [_1].',
	'Expiring cached MT News widget...' => 'Caducando el widget de Noticias de MT en caché...',
	'Mapping templates to blog archive types...' => 'Mapeando plantillas con tipos de archivo de blogs...',
	'Upgrading asset path information...' => 'Actualizando la información de la ruta de los ficheros multimedia...',
	q{Creating new template: '[_1]'.} => q{Creando nueva plantilla: '[_1]'.},

## lib/MT/Upgrade/v1.pm
	'Creating entry category placements...' => 'Creando situaciones de categorías de entradas...',
	'Creating template maps...' => 'Creando mapas de plantillas...',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'Mapeando ID plantilla [_1] a [_2] ([_3]).',
	'Mapping template ID [_1] to [_2].' => 'Mapeando ID plantilla [_1] a [_2].',

## lib/MT/Upgrade/v2.pm
	'Assigning comment/moderation settings...' => 'Asignando opciones de comentarios/moderación...',
	'Updating category placements...' => 'Actualizando situación de categorías...',

## lib/MT/Upgrade/v3.pm
	'Assigning basename for categories...' => 'Asignando nombre base a las categorías...',
	'Assigning blog administration permissions...' => 'Asignando permisos de administración de blogs...',
	'Assigning entry basenames for old entries...' => 'Asignando nombre base de entradas en entradas antiguas...',
	'Assigning user status...' => 'Asignando estado de usuarios...',
	'Creating configuration record.' => 'Creando registro de configuración.',
	'Custom ([_1])' => 'Personalizado ([_1])',
	'Migrating any "tag" categories to new tags...' => 'Migrando cualquier categoría "tag" a nuevas etiquetas...',
	'Migrating permissions to roles...' => 'Migrando permisos a roles...',
	'Removing Dynamic Site Bootstrapper index template...' => 'Borrando plantilla índice del arranque dinámico...',
	'Setting blog allow pings status...' => 'Estableciendo el estado de recepción de pings en los blogs...',
	'Setting blog basename limits...' => 'Estableciendo los límites del nombre base del blog...',
	'Setting default blog file extension...' => 'Estableciendo extensión predefinida de fichero de blog...',
	'Setting new entry defaults for blogs...' => 'Configurando los nuevos valores predefinidos de las entradas en los blogs...',
	'Setting your permissions to administrator.' => 'Cambiando sus permisos a administrador.',
	'This role was generated by Movable Type upon upgrade.' => 'Este rol fue generado por Movable Type durante la actualización.',
	'Updating blog comment email requirements...' => 'Actualizando los requerimientos del correo de los comentarios...',
	'Updating blog old archive link status...' => 'Actualizando el estado de los enlaces de archivado antiguos...',
	'Updating comment status flags...' => 'Actualizando estados de comentarios...',
	'Updating commenter records...' => 'Actualizando registros de comentaristas...',
	'Updating entry week numbers...' => 'Actualizando números de semana de entradas...',
	'Updating user permissions for editing tags...' => 'Actualizando los permisos de los usuarios para la edición de etiquetas...',
	'Updating user web services passwords...' => 'Actualizando contraseñas de servicios web...',

## lib/MT/Upgrade/v4.pm
	'Adding new feature widget to dashboard...' => 'Añadiendo un nuevo widget al panel de control...',
	'Assigning author basename...' => 'Asignando nombre base a los autores...',
	'Assigning blog page layout...' => 'Asignando distribución de las páginas...',
	'Assigning blog template set...' => 'Asignando conjunto de plantillas...',
	'Assigning embedded flag to asset placements...' => 'Asignando marca a los elementos empotrados...',
	'Assigning entry comment and TrackBack counts...' => 'Asignando totales de comentarios y trackbacks de las entradas...',
	'Assigning junk status for TrackBacks...' => 'Asignando el estado spam para los TrackBacks...',
	'Assigning junk status for comments...' => 'Asignando el estado spam para los comentarios...',
	'Assigning user authentication type...' => 'Asignando tipo de autentificación de usuarios...',
	'Cannot rename in [_1]: [_2].' => 'No se pudo renombrar en [_1]: [_2].',
	'Classifying category records...' => 'Clasificando registros de categorías...',
	'Classifying entry records...' => 'Clasificando registros de entradas...',
	'Comment Posted' => 'Comentario publicado',
	'Comment Response' => 'Comentar respuesta',
	'Comment Submission Error' => 'Error en el envío de comentarios',
	'Confirmation...' => 'Confirmación...',
	'Error renaming PHP files. Please check the Activity Log.' => 'Error al renombrar ficheros PHP. Por favor, compruebe el registro de actividad.',
	'Merging comment system templates...' => 'Combinando plantillas de comentarios del sistema...',
	'Migrating Nofollow plugin settings...' => 'Migrando ajustes de la extensión Nofollow...',
	'Migrating permission records to new structure...' => 'Migrando registros de permisos a la nueva estructura...',
	'Migrating role records to new structure...' => 'Migrando registros de roles a la nueva estructura...',
	'Migrating system level permissions to new structure...' => 'Migrando permisos a nivel del sistema a la nueva estructura...',
	'Moving OpenID usernames to external_id fields...' => 'Moviendo los nombres de usuarios de OpenID a campos external_id...',
	'Moving metadata storage for categories...' => 'Migrando los metadatos de las categorías...',
	'Populating authored and published dates for entries...' => 'Rellenando fechas de creación y publicación de las entradas...',
	'Populating default file template for templatemaps...' => 'Rellenando plantilla predefinida de ficheros para los templatemaps...',
	'Removing unnecessary indexes...' => 'Eleminando índices innecesarios...',
	'Removing unused template maps...' => 'Borrando mapas de plantillas no usados...',
	'Renaming PHP plugin file names...' => 'Renombrando nombre de ficheros de la extensión de PHP...',
	'Replacing file formats to use CategoryLabel tag...' => 'Reemplazando los formatos de fichero para usar la etiqueta CategoryLabel...',
	'Return to the <a href="[_1]">original entry</a>.' => 'Volver a la <a href="[_1]">entrada original</a>.',
	'Thank you for commenting.' => 'Gracias por comentar.',
	'Updating password recover email template...' => 'Actualizando la plantilla del correo de recuperación de contraseña...',
	'Updating system search template records...' => 'Actualizando registros de las plantillas de búsqueda del sistema...',
	'Updating template build types...' => 'Actualizando los tipos de publicación de las plantillas...',
	'Updating widget template records...' => 'Actualizando registros de plantillas de widgets...',
	'Upgrading metadata storage for [_1]' => 'Migrando los metadatos de [_1]',
	'Your comment has been posted!' => '¡El comentario ha sido publicado!',
	'Your comment has been received and held for review by a blog administrator.' => 'Se ha recibido el comentario y está pendiente de aprobación por parte del administrador del blog.',
	'Your comment submission failed for the following reasons:' => 'El envío de su comentario falló por las siguientes razones:',
	'[_1]: [_2]' => '[_1]: [_2]',

## lib/MT/Upgrade/v5.pm
	'Adding notification dashboard widget...' => 'Añadiendo el widget para el centro de notificaciones...',
	'An error occurred during generating a website upon upgrade: [_1]' => 'Ocurrió un error al crear un sitio web durante la actualización: [_1]',
	'Assigning ID of author for entries...' => 'Asignando el identificador de autor para las entradas...',
	'Assigning a language to each blog to help choose appropriate display format for dates...' => 'Asignando un idioma a cada blog para ayudarlos a mostrar las fechas en un formato correcto...',
	'Assigning new system privilege for system administrator...' => 'Asignando nuevo sistema de privilegios al administrador del sistema...',
	'Assigning to  [_1]...' => 'Asignando a [_1]...',
	'Can administer the website.' => 'Puede administrar el sitio web',
	'Can edit, manage and publish blog templates and themes.' => 'Puede editar, gestionar y publicar plantillas y temas de blogs.',
	'Can manage pages, Upload files and publish blog templates.' => 'Puede gestionar las páginas, subir ficheros y publicar plantillas de blogs.',
	'Classifying blogs...' => 'Clasificando blogs...',
	'Designer (MT4)' => 'Diseñador (MT4)',
	'Error loading role: [_1].' => 'Error cargando rol: [_1].',
	'Generated a website [_1]' => 'Generado un sitio web [_1]',
	'Generic Website' => 'Sitio web genérico',
	'Granting new role to system administrator...' => 'Concediendo nuevo rol al administrador del sistema...',
	'Migrating DefaultSiteURL/DefaultSiteRoot to website...' => 'Migrando DefaultSiteURL/DefaultSiteRoot al sitio web...',
	'Migrating [_1]([_2]).' => 'Migrando [_1]([_2]).',
	'Migrating existing [quant,_1,blog,blogs] into websites and their children...' => 'Migrando [quant,_1,el blog existente,los blogs existentes] a sitios webs con hijos...',
	'Migrating mtview.php to MT5 style...' => 'Migrando mtview.php al estilo MT5...',
	'Moved blog [_1] ([_2]) under website [_3]' => 'Se movió el blog [_1] ([_2]) bajo el sitio web [_3]',
	'New WebSite [_1]' => 'Nuevo sitio web [_1]',
	'Ordering Categories and Folders of Blogs...' => 'Ordenando las categorías y las carpetas de los blogs...',
	'Ordering Folders of Websites...' => 'Ordenando las carpetas de los sitios...',
	'Populating generic website for current blogs...' => 'Poblando el sitio web genérico con los blogs actuales...',
	'Populating new role for theme...' => 'Poblando el nuevo rol para los temas...',
	'Populating new role for website...' => 'Creando nuevo rol para el sitio web...',
	'Rebuilding permissions...' => 'Reconstruyendo permisos...',
	'Recovering type of author...' => 'Recuperando el tipo de autor...',
	'Removing Technorati update-ping service from [_1] (ID:[_2]).' => 'Borrando el servicio de ping de technorati de [_1] (ID:[_2]).',
	'Removing widget from dashboard...' => 'Borrando widget del Removing widget from dashboard...',
	'Updating existing role name...' => 'Actualizando nombre de rol existente...',
	'Webmaster (MT4)' => 'Webmaster (MT4)',
	'Website Administrator' => 'Administrador del sitio web',
	'_WEBMASTER_MT4' => 'Webmaster',
	q{An error occurred during migrating a blog's site_url: [_1]} => q{Ocurrió un error al migrar el site_url de un blog: [_1]},
	q{New user's website} => q{Sitio web del nuevo usuario},
	q{Setting the 'created by' ID for any user for whom this field is not defined...} => q{Indicando el identificador 'created_by' para los usuarios que no tienen el campo definido...},

## lib/MT/Upgrade/v6.pm
	'Adding "Site stats" dashboard widget...' => 'Añadiendo el widget para el panel "Estadísticas del sitio"...',
	'Adding Website Administrator role...' => 'Añadiendo el rol de administrador de sitio web...',
	'Fixing TheSchwartz::Error table...' => 'Corrigiendo la tabla TheSchwartz:Error...',
	'Migrating current blog to a website...' => 'Migrando el blog actual a un sitio web...',
	'Migrating the record for recently accessed blogs...' => 'Migrando el registro de accesos recientes a blogs...',
	'Rebuilding permission records...' => 'Reconstruyendo los registros de permisos...',
	'Reordering dashboard widgets...' => 'Reordenando los widgets de paneles...',

## lib/MT/Upgrade/v7.pm
	'Adding site list dashboard widget for mobile...' => 'Añadiendo el widget para móviles de la lista del sitio...',
	'Assign a Site Administrator Role for Manage Website with Blogs...' => 'Asignar un rol de administrador de sitio para administrar sitio web con blogs...',
	'Assign a Site Administrator Role for Manage Website...' => 'Asignar un rol de administrador de sitio para administrar sitio web...',
	'Changing the Child Site Administrator role to the Site Administrator role.' => 'Cambiando el rol de administrador de sitio hijo al rol de administrador de sitio.',
	'Child Site Administrator' => 'Administrador de sitio hijo',
	'Cleaning up content field indexes...' => 'Limpiando los índices de los campos de contenido',
	'Cleaning up objectasset records for content data...' => 'Limpiando los registros de objectasset para datos de contenido...',
	'Cleaning up objectcategory records for content data...' => 'Limpiando los registros de objectcategory para datos de contenido...',
	'Cleaning up objecttag records for content data...' => 'Limpiando los registros de objecttag para datos de contenido...',
	'Create a new role for creating a child site...' => 'Crear un nuevo rol para crear un sitio hijo...',
	'Create new role: [_1]...' => 'Creando nuevo rol: [_1]',
	'Error removing record (ID:[_1]): [_2].' => 'Error borrando registro (ID:[_1]): [_2].',
	'Error removing records: [_1]' => 'Error borrando registros: [_1]',
	'Error saving record (ID:[_1]): [_2].' => 'Error guardando registro (ID:[_1]): [_2].',
	'Error saving record: [_1]' => 'Error guardando registro: [_1]',
	'Migrating Max Length option of Single Line Text fields...' => 'Migrando la opción Max Lenght de los campos de una línea...',
	'Migrating MultiBlog settings...' => 'Migrando configuración de MultiBlog...',
	'Migrating create child site permissions...' => 'Migrando permisos de creación de sitios hijos...',
	'Migrating data column of MT::ContentData...' => 'Migrando columna de datos de MT::ContentData...',
	'Migrating fields column of MT::ContentType...' => 'Migrando columna de campos de MT::ContentType...',
	'MultiBlog migration for site(ID:[_1]) is skipped due to the data breakage.' => '', # Translate - New
	'MultiBlog migration is skipped due to the data breakage.' => '', # Translate - New
	'Rebuilding Content Type count of Category Sets...' => 'Reconstruyendo las estadísticas del tipo de contenido de los conjuntos de categorías...',
	'Rebuilding MT::ContentFieldIndex of embedded_text field...' => 'Reconstruyendo MT::ContentFieldIndex del campo embedded_text...',
	'Rebuilding MT::ContentFieldIndex of multi_line_text field...' => 'Reconstruyendo MT::ContentFieldIndex del campo multi_line_text...',
	'Rebuilding MT::ContentFieldIndex of number field...' => 'Reconstruyendo el campo númerico MT::ContentFieldIndex...',
	'Rebuilding MT::ContentFieldIndex of single_line_text field...' => 'Reconstruyendo MT::ContentFieldIndex del campo single_line_text...',
	'Rebuilding MT::ContentFieldIndex of tables field...' => 'Reconstruyendo MT::ContentFieldIndex del campode tablas...',
	'Rebuilding MT::ContentFieldIndex of url field...' => 'Reconstruyendo MT::ContentFieldIndex del campo de URLs...',
	'Rebuilding MT::Permission records (remove edit_categories)...' => 'Reconstruyendo MT::Permission registros (borrado de edit_categories)...',
	'Rebuilding content field permissions...' => 'Reconstruyendo permisos de campos de contenido...',
	'Rebuilding object assets...' => 'Reconstruyendo recursos de objetos...',
	'Rebuilding object categories...' => 'Reconstruyendo categorías de objetos',
	'Rebuilding object tags...' => 'Reconstruyendo etiquetas de objetos...',
	'Remove SQLSetNames...' => '', # Translate - New
	'Reorder DEBUG level' => '', # Translate - New
	'Reorder SECURITY level' => '', # Translate - New
	'Reorder WARNING level' => '', # Translate - New
	'Reset default dashboard widgets...' => 'Reinicio del panel de control predefinido de widgets...',
	'Some MultiBlog migrations for site(ID:[_1]) are skipped due to the data breakage.' => '', # Translate - New
	'Truncating values of value_varchar column...' => 'Acortando los valores de la columna value_varchar...',
	'add administer_site permission for Blog Administrator...' => 'añadir permiso administer_site para el administrador del blog...',
	'change [_1] to [_2]' => 'cambiar [_1] a [_2]',

## lib/MT/Util.pm
	'[quant,_1,day,days] from now' => 'dentro de [quant,_1,día,días]',
	'[quant,_1,day,days]' => '[quant,_1,día,días]',
	'[quant,_1,day,days], [quant,_2,hour,hours] ago' => 'hace [quant,_1,día,días], [quant,_2,hora,horas]',
	'[quant,_1,day,days], [quant,_2,hour,hours] from now' => 'dentro de [quant,_1,día,días], [quant,_2,hora,horas]',
	'[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,día,días], [quant,_2,hora,horas]',
	'[quant,_1,hour,hours] from now' => 'dentro de [quant,_1,hora,horas]',
	'[quant,_1,hour,hours]' => '[quant,_1,hora,horas]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => 'hace [quant,_1,hora,horas], [quant,_2,minuto,minutos]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => 'dentro de [quant,_1,hora,horas], [quant,_2,minuto,minutos]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,hora,horas], [quant,_2,minuto,minutos]',
	'[quant,_1,minute,minutes] from now' => 'dentro de [quant,_1,minuto,minutos]',
	'[quant,_1,minute,minutes]' => '[quant,_1,minuto,minutos]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => 'dentro de [quant,_1,minuto,minutos], [quant,_2,segundo,segundos]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,minuto,minutos], [quant,_2,segundo,segundos]',
	'[quant,_1,second,seconds] from now' => 'dentro de [quant,_1,segundo,segundos]',
	'[quant,_1,second,seconds]' => '[quant,_1,segundo,segundos]',
	'less than 1 minute ago' => 'hace menos de un minuto',
	'less than 1 minute from now' => 'dentro de menos de un minuto',
	'moments from now' => 'dentro de unos momentos',
	q{Invalid domain: '[_1]'} => q{Dominio no válido: '[_1]'},

## lib/MT/Util/Archive.pm
	'Registry could not be loaded' => 'El registro no pudo cargarse',
	'Type must be specified' => 'Debe especificar el tipo',

## lib/MT/Util/Archive/BinTgz.pm
	'Both data and file name must be specified.' => 'Se deben especificar tanto los datos como el nombre del fichero.',
	'Cannot extract from the object' => 'No se pudo extraer usando el objeto',
	'Cannot find external archiver: [_1]' => '', # Translate - New
	'Cannot write to the object' => 'No se pudo escribir en el objeto',
	'Failed to create an archive [_1]: [_2]' => '', # Translate - New
	'File [_1] exists; could not overwrite.' => 'El fichero [_1] existe: no puede sobreescribirse.',
	'Type must be tgz.' => 'El tipo debe ser tgz.',
	'[_1] in the archive contains ..' => '[_1] en el archivo contiene...',
	'[_1] in the archive is an absolute path' => '[_1] en el archivo es una ruta absoluta',
	'[_1] in the archive is not a regular file' => '[_1] en el archivo no es un fichero normal',

## lib/MT/Util/Archive/BinZip.pm
	'Failed to rename an archive [_1]: [_2]' => '', # Translate - New
	'Type must be zip' => 'El tipo debe ser zip',

## lib/MT/Util/Archive/Tgz.pm
	'Could not read from filehandle.' => 'No se pudo leer desde el manejador de ficheros',
	'File [_1] is not a tgz file.' => 'El fichero [_1] no es un tgz.',

## lib/MT/Util/Archive/Zip.pm
	'File [_1] is not a zip file.' => 'El fichero [_1] no es un fichero zip.',

## lib/MT/Util/Captcha.pm
	'Captcha' => 'Captcha',
	'Image creation failed.' => 'Falló la creación de la imagen.',
	'Image error: [_1]' => 'Error de imagen: [_1]',
	'Movable Type default CAPTCHA provider requires Image::Magick.' => 'El proveedor predefinido de CAPTCHA de Movable Type necesita Image::Magick',
	'Type the characters you see in the picture above.' => 'Introduzca los caracteres que ve en la imagen de arriba.',
	'You need to configure CaptchaSourceImageBase.' => 'Debe configurar CaptchaSourceImageBase.',

## lib/MT/Util/Log.pm
	'Cannot load Log module: [_1]' => 'No se pudo cargar el módulo de registros: [_1]',
	'Logger configuration for Log module [_1] seems problematic' => '', # Translate - New
	'Unknown Logger Level: [_1]' => 'Nivel de registros desconocido: [_1]',

## lib/MT/Util/YAML.pm
	'Cannot load YAML module: [_1]' => 'No se pudo cargar el módulo YAML: [_1]',
	'Invalid YAML module' => 'Módulo YAML no válido',

## lib/MT/WeblogPublisher.pm
	'An error occurred while publishing scheduled entries: [_1]' => 'Ocurrió un error durante la publicación de las entradas programadas: [_1]',
	'An error occurred while unpublishing past entries: [_1]' => 'Ocurrió un error durante la despublicación de las entradas antiguas: [_1]',
	'Blog, BlogID or Template param must be specified.' => 'Debe especificarse el parámetro Blog, BlogID o Template.',
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Ya existe el fichero del mismo archivo. Debe modificar el título o la ruta. ([_1])',
	'unpublish' => 'Despublicar',
	q{Template '[_1]' does not have an Output File.} => q{La plantilla '[_1]' no tiene un fichero de salida.},

## lib/MT/Website.pm
	'Child Site Count' => 'Cuenta de sitios hijos',
	'First Website' => 'Primer sitio web',

## lib/MT/Worker/Publish.pm
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- conjunto completo ([quant,_1,fichero,ficheros] en [_2] segundos)',
	'Background Publishing Done' => 'Publicación en segundo plano realizada',
	'Error rebuilding file [_1]:[_2]' => 'Error reconstruyendo el fichero [_1]:[_2]',
	'Published: [_1]' => 'Publicado: [_1]',

## lib/MT/Worker/Sync.pm
	'Done Synchronizing Files' => 'Finalizó la sincronización de ficheros',
	'Done syncing files to [_1] ([_2])' => 'Ficheros sincronizados en [_1] ([_2])',
	qq{Error during rsync of files in [_1]:\n} => qq{Error en la sincronización de ficheros rsync in [_1]:\n},

## lib/MT/XMLRPCServer.pm
	'Error writing uploaded file: [_1]' => 'Error escribiendo el fichero transferido: [_1]',
	'Invalid login' => 'Incio de sesión no válido',
	'Invalid timestamp format' => 'Formato de fecha no válido',
	'No blog_id' => 'Sin blog_id',
	'No entry_id' => 'Sin entry_id',
	'No filename provided' => 'No se especificó el nombre del fichero ',
	'No web services password assigned.  Please see your user profile to set it.' => 'No se ha establecido la contraseña de servicios web.  Por favor, vaya al perfil de su usuario para configurarla.',
	'Not allowed to edit entry' => 'No tiene permiso para editar la entrada',
	'Not allowed to get entry' => 'No tiene permiso para obtener la entrada',
	'Not allowed to set entry categories' => 'No tiene permiso para modificar las categorías de la entrada',
	'Not allowed to upload files' => 'No tiene permiso para transferir ficheros',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'El módulo de Perl Image::Size es necesario para obtener las dimensiones de las imágenes transferidas.',
	'Publishing failed: [_1]' => 'Falló la publicación: [_1]',
	'Saving folder failed: [_1]' => 'Fallo al guardar la carpeta: [_1]',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Los métodos de las plantillas no están implementados, debido a las diferencias entre Blogger API y Movable Type API.',
	q{Entry '[_1]' ([lc,_5] #[_2]) deleted by '[_3]' (user #[_4]) from xml-rpc} => q{Entrada '[_1]' ([lc,_5] #[_2]) borrada por '[_3]' (usuario #[_4]) para xml-rpc},
	q{Invalid entry ID '[_1]'} => q{ID de entrada '[_1]' no válido},
	q{Requested permalink '[_1]' is not available for this page} => q{El enlace permanente solicitado '[_1]' no está disponible para esta página},
	q{Value for 'mt_[_1]' must be either 0 or 1 (was '[_2]')} => q{El valor de 'mt_[_1]' debe ser 0 ó 1 (era '[_2]')},

## mt-check.cgi
	'(Probably) running under cgiwrap or suexec' => '(Probablemente) Ejecución bajo cgiwrap o suexec',
	'Archive::Tar is required in order to manipulate files during backup and restore operations.' => 'Archive::Tar es necesario para manipular ficheros durante las operaciones de copias de seguridad y restauraciones.',
	'Archive::Zip is required in order to manipulate files during backup and restore operations.' => 'Archive::Zip es necesario para manipular ficheros durante las operaciones de copias de seguridad y restauraciones.',
	'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie es necesario para la autentificación de cookies.',
	'Cache::File is required if you would like to be able to allow commenters to authenticate via OpenID using Yahoo! Japan.' => 'Cache::File es necesario si desea que los comentaristas se puedan autentificar vía OpenID utilizando Yahoo! Japón.',
	'Cache::Memcached and a memcached server are required to use in-memory object caching on the servers where Movable Type is deployed.' => 'Cache::Memcached y un servidor memcached son necesarios para utilizar la caché en memoria de objetos en los servidores donde se vaya instalar Movable Type.',
	'Checking for' => 'Comprobando',
	'Crypt::DSA is optional; If it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSA es opcional; si está instalado, se acelerará el registro de identificación de comentarios.',
	'Current working directory:' => 'Directorio actual de trabajo:',
	'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI y DBD::Pg son necesarios si quiere usar la base de datos PostgreSQL.',
	'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI y DBD::SQLite son necesarios si quiere usar la base de datos SQLite.',
	'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI y DBD::SQLite2 son necesarios si quiere usar la base de datos SQLite 2.x.',
	'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI y DBD::mysql son necesarios si quiere usar la base de datos MySQL.',
	'DBI is required to store data in database.' => 'DBI es necesario para guardar información en bases de datos.',
	'Data Storage' => 'Base de datos',
	'Details' => 'Detalles',
	'Digest::SHA1 and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.' => 'Digest::SHA1 y sus dependencias son necesarias para que los comentaristas se autentifiquen mediante proveedores OpenID, incluyendo LiveJournal.',
	'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Temp es opcional; es necesario si desea sobreescribir ficheros existentes al subir ficheros.',
	'IO::Compress::Gzip is required in order to compress files during backup operations.' => 'IO::Compress::Gzip es necesario para comprimir los ficheros durante las operaciones de copias de seguridad.',
	'IO::Uncompress::Gunzip is required in order to decompress files during restore operation.' => 'IO::Uncompress::Gunzip es necesario para descomprimir ficheros durante la operación de restauración.',
	'IPC::Run is optional; It is needed if you would like to use NetPBM as the image processor for Movable Type.' => 'IPC::Run es opcional. Es necesario si va a utilizar NetPBM como procesador de imágenes en Movable Type.',
	'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size es necesario para subir ficheros (determina el tamaño de las imágenes transferidas en muchos formatos diferentes).',
	'Installed' => 'Instalado',
	'MIME::Base64 is required in order to enable comment registration and in order to send mail via an SMTP Server.' => 'MIME::Base64 es necesario para activar el registro de comentarios y poder enviar correos a través de un servidor SMTP.',
	'MT home directory:' => 'Directorio de inicio de MT:',
	'Movable Type System Check Successful' => 'Comprobación del sistema realizada con éxito',
	'Movable Type System Check' => 'Comprobación del sistema - Movable Type',
	'Movable Type version:' => 'Versión de Movable Type:',
	'Net::SMTP is required in order to send mail via an SMTP Server.' => 'Net::SMTP es necesario para enviar correos vía servidores SMTP.',
	'Operating system:' => 'Sistema operativo:',
	'Perl include path:' => 'Ruta de búsqueda de Perl:',
	'Perl version:' => 'Versión de Perl:',
	'Please consult the installation instructions for help in installing [_1].' => 'Por favor, consulte las instrucciones de instalación si quiere ayuda sobre la instalación de [_1].',
	'SOAP::Lite is optional; It is needed if you want to use the MT XML-RPC server implementation.' => 'SOAP::Lite es opcional; es necesario si desea usar la implementación del servidor XML-RCP de Movable Type.',
	'Storable is optional; It is required by certain Movable Type plugins available from third-party developers.' => 'Storable es opcional. Es necesario por algunas extensiones de Movable Type disponibles a través de terceros desarrolladores.',
	'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the most current release available.' => 'La versión de DBD::mysql que ha instalado no es compatible con Movable Type. Por favor, instale la versión más reciente.',
	'The MT-Check report is disabled when Movable Type has a valid configuration file (mt-config.cgi)' => 'El informe de MT-Check se deshabilita cuando Movable Type tiene un fichero válido de configuración (mt-config.cgi)',
	'The [_1] is installed properly, but requires an updated DBI module. Please see the note above regarding the DBI module requirements.' => 'El [_1] está instalado correctamente, pero necesita un módulo DBI reciente. Por favor, lea la nota de arriba sobre los requerimientos del módulo DBI.',
	'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that they provide.' => 'Los siguientes módulos son <strong>opcionales</strong>. Si el servidor no tiene estos módulos instalados, sólo deberá instalarlos si necesita la funcionalidad que proporcionan.',
	'The following modules are required by databases that can be used with Movable Type. Your server must have DBI and at least one of these related modules installed for the application to work properly.' => 'Las bases de datos necesitan los siguientes módulos para su uso con Movable Type. Para que funcione correctamente, el servidor debe tener instalado DBI y al menos uno de estos módulos relacionados. The following modules are required by databases that can be used with Movable Type.',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). Please upgrade to at least Perl [_2].' => 'La versión de Perl instalada en su servidor ([_1]) es menor que la versión mínima soportada ([_2]). Por favor, actualícese por lo menos a Perl [_2].',
	'This module and its dependencies are required in order to operate Movable Type under psgi.' => 'Este módulo y sus dependencias son necesarios para ejecutar Movable Type bajo psgi.',
	'This module is required by mt-search.cgi, if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'mt-search.cgi necesita este módulo si está usando Movable Type con una versión de Perl anterior a Perl 5.8.',
	'This module required for action streams.' => '', # Translate - New
	'Web server:' => 'Servidor web:',
	'XML::Atom is required in order to use the Atom API.' => 'XML::Atom es necesario para usar el API de Atom.',
	'XML::SAX and its dependencies are required to restore a backup created in a backup/restore operation.' => 'XML::SAX y sus dependencias son necesarias para restaurar una copia de seguridad creada en una operación de copia de seguridad/restauración.',
	'You attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'Ha intentado usar una característica para la que no tiene permisos. Si cree que está viendo este mensaje por error, contacte con sus administrador del sistema.',
	'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => 'El servidor no tiene [_1] instalado o [_1] necesita otro módulo que no está instalado.',
	'Your server has [_1] installed (version [_2]).' => 'El servidor tiene [_1] instalado (versión [_2]).',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'El servidor tiene todos los módulos necesarios instalados; no tiene que realizar ninguna instalación adicional. Continúe con las instrucciones de instalación.',
	'[_1] [_2] Modules' => 'Módulos [_1] [_2]',
	'[_1] is optional; It is a better, fast and lightweight alternative to YAML::Tiny for YAML file handling.' => '[_1] es opcional; Es una alternativa más rápida y ligera que YAML::Tiny para el manejo de ficheros YAML.',
	'[_1] is optional; It is one of the image processors that you can use to create thumbnails of uploaded images.' => '[_1] es opcional. Es uno de los procesadores de imágenes que pueden usarse para crear miniaturas de las imágenes transferidas.',
	'[_1] is optional; It is one of the modules required to restore a backup created in a backup/restore operation' => '[_1] es opcional; Este es uno de los módulos necesarios para restaurar una copia de seguridad.',
	'unknown' => 'desconocido',
	q{The mt-check.cgi script provides you with information about your system's configuration and determines whether you have all of the components you need to run Movable Type.} => q{El script mt-check.cgi le ofrece información sobre la configuración del sistema y determina si posee todos los componentes necesarios para ejecutar Movable Type.},
	q{You're ready to go!} => q{¡Ya está preparado!},

## mt-static/addons/Sync.pack/js/cms.js
	'Continue' => 'Continuar',
	'You have unsaved changes to this page that will be lost.' => 'Tiene cambios no guardados en esta página que se perderán.',

## mt-static/jquery/jquery.mt.js
	'Invalid URL' => 'URL no válida',
	'Invalid date format' => 'Formato de fecha no válido',
	'Invalid time format' => 'Formato de hora no válido',
	'Invalid value' => 'Valor no válido',
	'Only 1 option can be selected' => 'Sólo se puede seleccionar una opción',
	'Options greater than or equal to [_1] must be selected' => 'Deben seleccionarse opciones mayores o iguales a [_1] ',
	'Options less than or equal to [_1] must be selected' => 'Deben seleccionarse opciones menores o iguales a [_1].',
	'Please input [_1] characters or more' => 'Por favor introduzca [_1] o más caracteres',
	'Please select one of these options' => 'Por favor seleccione una de estas opciones',
	'This field is required' => 'Este campo es obligatorio',
	'This field must be a number' => 'Este campo debe ser un número',
	'This field must be a signed integer' => 'Este campo debe ser un entero con signo',
	'This field must be a signed number' => 'Este campo debe ser un número con signo',
	'This field must be an integer' => 'Este campo debe ser un número entero',
	'You have an error in your input.' => 'Hay un error en lo que introdujo.',

## mt-static/js/assetdetail.js
	'Dimensions' => 'Tamaño',
	'File Name' => 'Nombre fichero',
	'No Preview Available.' => 'Vista previa no disponible.',

## mt-static/js/contenttype/tag/content-field.tag
	'ContentField' => 'ContentField',
	'Move' => 'Mover',

## mt-static/js/contenttype/tag/content-fields.tag
	'Allow users to change the display and sort of fields by display option' => 'Permitir a los usuarios modificar la visualización y orden de los campos',
	'Data Label Field' => 'Campo de etiqueta de datos',
	'Drag and drop area' => 'Área de arrastrar y soltar',
	'Please add a content field.' => 'Por favor, añada un campo de contenidos.',
	'Show input field to enter data label' => 'Mostrar campo para introducir la etiqueta de datos',
	'Unique ID' => 'ID único',
	'close' => 'cerrar',

## mt-static/js/dialog.js
	'(None)' => '(Ninguno)',

## mt-static/js/listing/list_data.js
	'Unknown Filter' => '', # Translate - New
	'[_1] - Filter [_2]' => '[_1] - Filtro [_2]',

## mt-static/js/listing/listing.js
	'Are you sure you want to [_2] this [_1]?' => '¿Está seguro de que desea [_2] esta [_1]?',
	'Are you sure you want to [_3] the [_1] selected [_2]?' => '¿Está seguro de que desea [_3] el/los [_1] seleccionado/s [_2]?',
	'Label "[_1]" is already in use.' => 'La etiqueta "[_1]" ya está en uso.',
	'One or more fields in the filter item are not filled in properly.' => '', # Translate - New
	'You can only act upon a maximum of [_1] [_2].' => 'Solo puede actuar sobre un máximo de [_1] [_2].',
	'You can only act upon a minimum of [_1] [_2].' => 'Solo puede actuar sobre un mínimo de [_1] [_2].',
	'You did not select any [_1] to [_2].' => 'No seleccionó ninguna [_1] sobre la que [_2].',
	'act upon' => 'actuar sobre',
	q{Are you sure you want to remove filter '[_1]'?} => q{¿Está seguro de que desea borrar el filtro '[_1]'?},

## mt-static/js/listing/tag/display-options-for-mobile.tag
	'[_1] rows' => '[_1] filas',
	'Show' => 'Mostrar',

## mt-static/js/listing/tag/display-options.tag
	'Column' => 'Columna',
	'Reset defaults' => 'Reiniciar valores predefinidos',
	'User Display Option is disabled now.' => 'Se ha deshabilitado la opción de mostrar.',

## mt-static/js/listing/tag/list-actions-for-mobile.tag
	'Plugin Actions' => 'Acciones de extensiones',
	'Select action' => 'Seleccione acción',

## mt-static/js/listing/tag/list-actions-for-pc.tag
	'More actions...' => 'Más acciones...',

## mt-static/js/listing/tag/list-filter.tag
	'Add' => 'Crear',
	'Apply' => 'Aplicar',
	'Built in Filters' => 'Filtros de serie',
	'Create New' => 'Crear nuevo',
	'Filter Label' => 'Filtrar etiqueta',
	'Filter:' => 'Filtro:',
	'My Filters' => 'Mis filtros',
	'Reset Filter' => 'Reiniciar filtro',
	'Save As' => 'Guardar como',
	'Select Filter Item...' => 'Seleccionar elemento de filtro...',
	'Select Filter' => 'Seleccionar filtro',
	'rename' => 'Renombrar',

## mt-static/js/listing/tag/list-table.tag
	'All [_1] items are selected' => 'Todos los [_1] elementos están seleccionados',
	'All' => 'Todos',
	'Loading...' => 'Cargando...',
	'Select All' => 'Seleccionar todos',
	'Select all [_1] items' => 'Seleccionar los [_1] elementos',
	'Select' => 'Seleccionar',
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] of [_3]',

## mt-static/js/mt/util.js
	'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => '¿Está seguro de que desea borrar estos [_1] roles? Al hacerlo, eliminará los permisos actualmente asignados a cualquier usuario o grupo relacionados con estos roles.',
	'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => '¿Está seguro de que desea borrar este rol? Al hacerlo, eliminará los permisos actualmente asignados a cualquier usuario o grupo relacionados con este rol.',
	'You did not select any [_1] [_2].' => 'No seleccionó ninguna [_1] [_2].',
	'You must select an action.' => 'Debe seleccionar una acción.',
	'delete' => 'borrar',

## mt-static/js/tc/mixer/display.js
	'Author:' => 'Authr:',
	'Description:' => 'Descriptión:',
	'Tags:' => 'Etiquetas:',
	'Title:' => 'Título:',
	'URL:' => 'URL:',

## mt-static/js/upload_settings.js
	'You must set a path beginning with %s or %a.' => 'Debe indicar una ruta que comience con %s o %a.',
	'You must set a valid path.' => 'Debe indicar una ruta válida.',

## mt-static/mt.js
	'Enter URL:' => 'Teclee la URL:',
	'Enter email address:' => 'Teclee la dirección de correo-e:',
	'Same name tag already exists.' => 'Esa etiqueta ya existe.',
	'disable' => 'deshabilitar',
	'enable' => 'habilitar',
	'publish' => 'Publicar',
	'remove' => 'borrar',
	'to mark as spam' => 'para marcar como spam',
	'to remove spam status' => 'para desmarcar como spam',
	'unlock' => 'desbloquear',
	q{The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]' across all weblogs?} => q{La etiqueta '[_2]' ya existe. ¿Está seguro de que desea integrar '[_1]' y '[_2]' en todos los weblogs?},
	q{The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]'?} => q{La etiqueta '[_2]' ya existe. ¿Está seguro de que desea integrar '[_1]' y '[_2]'?},

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field.js
	'Edit [_1] block' => 'Editar bloque de [_1]',

## mt-static/plugins/BlockEditor/lib/js/fields/embed.js
	'Embed Code' => 'Insertar código',
	'Please enter the embed code here.' => 'Por favor, introduzca el código aquí.',

## mt-static/plugins/BlockEditor/lib/js/fields/header.js
	'Heading Level' => 'Nivel de cabecera',
	'Heading' => 'Cabecera',
	'Please enter the Header Text here.' => 'Por favor, introduzca el texto de la cabecera aquí.',

## mt-static/plugins/BlockEditor/lib/js/fields/horizon.js
	'Horizontal Rule' => 'Línea horizontal',

## mt-static/plugins/BlockEditor/lib/js/fields/image.js
	'image' => 'Imagen',

## mt-static/plugins/BlockEditor/lib/js/fields/text.js
	'__TEXT_BLOCK__' => 'Texto',

## mt-static/plugins/BlockEditor/lib/js/jquery.blockeditor.js
	'Select a block' => 'Seleccione un bloque',

## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => 'Insertar texto con formato',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/autosave/plugin.js
	'You have unsaved changes are you sure you want to navigate away?' => 'Tiene cambios no guardados. ¿Está seguro de que desea salir de esta página?',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/compat3x/utils/editable_selects.js
	'value' => 'valor',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/insertdatetime/plugin.js
	'%H:%M:%S' => '%H:%M:%S',
	'%Y-%m-%d' => '%Y-%m-%d',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/plugin.js
	'Align Center' => 'Alinear derecha',
	'Align Left' => 'Alinear izquierda',
	'Align Right' => 'Alinear centro',
	'Block Quotation' => 'Cita',
	'Bold (Ctrl+B)' => 'Negrita (Ctrl+B)',
	'Class Name' => 'Nombre de la clase',
	'Emphasis' => 'Énfasis',
	'Horizontal Line' => 'Línea horizontal',
	'Indent' => 'Indentar',
	'Insert Asset Link' => 'Insertar enlace',
	'Insert HTML' => 'Insertar HTML',
	'Insert Image Asset' => 'Insertar imagen',
	'Insert Link' => 'Insertar enlace',
	'Insert/Edit Link' => 'Insertar/Editar enlace',
	'Italic (Ctrl+I)' => 'Itálica (Ctrl+I)',
	'List Item' => 'Elemento lista',
	'Ordered List' => 'Lista ordenada',
	'Outdent' => 'Desindentar',
	'Redo (Ctrl+Y)' => 'Rehacer (Ctrl+Y)',
	'Remove Formatting' => 'Borrar formato',
	'Select Background Color' => 'Color de fondo',
	'Select Text Color' => 'Color de texto',
	'Strikethrough' => 'Tachado',
	'Strong Emphasis' => 'Énfasis negrita',
	'Toggle Fullscreen Mode' => 'Des/Activar modo pantalla completa',
	'Toggle HTML Edit Mode' => 'Des/Activar modo edición HTML',
	'Underline (Ctrl+U)' => 'Subrayado (Ctrl+U)',
	'Undo (Ctrl+Z)' => 'Deshacer (Ctrl+Z)',
	'Unlink' => 'Borrar enlace',
	'Unordered List' => 'Lista no ordenada',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/plugin.js
	'HTML' => 'HTML',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/langs/plugin.js
	'Fullscreen' => 'Pantalla completa',

## mt-static/plugins/TinyMCE5/lib/js/tinymce/plugins/mt/langs/plugin.js
	'Copy column' => '', # Translate - New
	'Cut column' => '', # Translate - New
	'Horizontal align' => '', # Translate - New
	'Paste column after' => '', # Translate - New
	'Paste column before' => '', # Translate - New
	'Vertical align' => '', # Translate - New

## php/lib/block.mtarchives.php
	'ArchiveType not found - [_1]' => 'ArchiveType no encontrado - [_1]',

## php/lib/block.mtassets.php
	'sort_by="score" must be used together with a namespace.' => 'sort_by="score" debe usarse junto al espacio de nombres.',

## php/lib/block.mtauthorhascontent.php
	'No author available' => 'Ningún autor disponible',

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without establishing a date context.' => 'Utilizó una etiqueta [_1] sin indicar un contexto de fecha.',

## php/lib/block.mtcontentfield.php
	'No Content Field could be found: \"[_1]\"' => '', # Translate - New

## php/lib/block.mtif.php
	'You used an [_1] tag without a valid name attribute.' => 'Utilizó una etiqueta [_1] sin un atributo de nombre válido.',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] es ilegal.',

## php/lib/captcha_lib.php
	'Type the characters shown in the picture above.' => 'Teclee los caracteres mostrados en la imagen de arriba.',

## php/lib/function.mtassettype.php
	'file' => 'fichero',

## php/lib/mtdb.base.php
	'When the exclude_blogs and include_blogs attributes are used together, the same blog IDs should not be listed as parameters to both of them.' => 'Cuando se usan juntos los atributos exclude_blogs y include_blogs, no deben indicarse los mismos identificadores de blogs como parámetros de ambos.',

## php/mt.php
	'Page not found - [_1]' => 'Página no encontrada - [_1]',

## plugins/BlockEditor/tmpl/cms/dialog/asset_modal.tmpl
	'[_1] - [_2] of [_3]' => '[_1] - [_2] de [_3]',

## plugins/BlockEditor/tmpl/cms/dialog/include/asset_upload_panel.tmpl
	'Cancelled: [_1]' => 'Cancelado: [_1]',
	'The file you tried to upload is too large: [_1]' => 'El fichero que intentó transferir es muy grande: [_1]',
	'[_1] is not a valid [_2] file.' => '[_1] no es un fichero [_2] válido.',

## plugins/Comments/lib/Comments.pm
	'(Deleted)' => '(Borrado)',
	'Approved' => 'Autorizado',
	'Banned' => 'Bloqueado',
	'Can comment and manage feedback.' => 'Puede comentar y administrar las respuestas.',
	'Can comment.' => 'Puede comentar.',
	'Commenter' => 'Comentarista',
	'Comments on [_1]: [_2]' => 'Comentarios en [_1]: [_2]',
	'Edit this [_1] commenter.' => 'Editar este comentarista [_1].',
	'Moderator' => 'Moderador',
	'Not spam' => 'No es spam',
	'Reply' => 'Responder',
	'Reported as spam' => 'Marcado como spam',
	'Search for other comments from anonymous commenters' => 'Buscar otros comentarios anónimos',
	'Search for other comments from this deleted commenter' => 'Buscar otros comentarios de este comentarista eliminado',
	'Unapproved' => 'No aprobado',
	'__ANONYMOUS_COMMENTER' => 'Anónimo',
	'__COMMENTER_APPROVED' => 'Aprobado',
	q{All comments by [_1] '[_2]'} => q{Todos los comentarios de [_1] '[_2]'},

## plugins/Comments/lib/Comments/App/ActivityFeed.pm
	'All Comments' => 'Todos los comentarios',
	'[_1] Comments' => '[_1] comentarios',

## plugins/Comments/lib/Comments/App/CMS.pm
	'Are you sure you want to remove all comments reported as spam?' => '¿Está de que desea borrar todos los comentarios marcados como spam?',

## plugins/Comments/lib/Comments/Blog.pm
	'Cloning comments for blog...' => 'Clonando comentarios para el blog...',

## plugins/Comments/lib/Comments/Import.pm
	'Saving comment failed: [_1]' => 'Fallo guardando comentario: [_1]',
	q{Creating new comment (from '[_1]')...} => q{Creando nuevo comentario (de '[_1]')...},

## plugins/Comments/lib/Comments/Upgrade.pm
	'Creating initial comment roles...' => 'Creando roles iniciales de comentarios...',

## plugins/Comments/lib/MT/App/Comments.pm
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Regresar a la página original.</a>',
	'All required fields must be populated.' => 'Debe rellenar todos los campos obligatorios.',
	'Comment on "[_1]" by [_2].' => 'Comentario en "[_1]" por [_2].',
	'Comment save failed with [_1]' => 'Fallo guardando comentario con [_1]',
	'Comment text is required.' => 'El texto del comentario es obligatorio.',
	'Commenter profile could not be updated: [_1]' => 'No se pudo actualizar el perfil del comentarista: [_1]',
	'Commenter profile has successfully been updated.' => 'Se actualizó con éxito el perfil del comentarista.',
	'Comments are not allowed on this entry.' => 'No se permiten comentarios en esta entrada.',
	'IP Banned Due to Excessive Comments' => 'IP bloqueada debido al exceso de comentarios',
	'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] bloqueada porque excedió el ritmo de comentarios, más de 8 en [_2] segundos.',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Intento de identificación de comentarista no válido desde [_1] en el blog [_2](ID: [_3]) que no permite la autentificación nativa de Movable Type.',
	'Invalid entry ID provided' => 'ID de entrada provisto no válido',
	'Movable Type Account Confirmation' => 'Confirmación de cuenta - Movable Type',
	'Name and E-mail address are required.' => 'El nombre y la dirección de correo son obligatorios.',
	'No entry was specified; perhaps there is a template problem?' => 'No se especificó ninguna entrada; ¿quizás hay un problema con la plantilla?',
	'No id' => 'Sin id',
	'No such comment' => 'No existe dicho comentario',
	'Registration is required.' => 'El registro es obligatorio.',
	'Signing up is not allowed.' => 'No está permitida la inscripción.',
	'Somehow, the entry you tried to comment on does not exist' => 'De alguna manera, la entrada en la que intentó comentar no existe',
	'Successfully authenticated, but signing up is not allowed.  Please contact your Movable Type system administrator.' => 'Autentificado con éxito, pero el registro no está habilitado. Por favor, contacte con el administrador de sistemas de Movable Type.',
	'Thanks for the confirmation.  Please sign in to comment.' => 'Gracias por la confirmación. Por favor, identifíquese para comentar.',
	'You are trying to redirect to external resources. If you trust the site, please click the link: [_1]' => 'Está intentando redireccionar hacia un recurso externo. Si confía en el sitio, haga clic en el enlace: [_1]',
	'You need to sign up first.' => 'Primero identifíquese',
	'Your confirmation has expired. Please register again.' => 'La confirmación caducó. Por favor, regístrese de nuevo.',
	'_THROTTLED_COMMENT' => 'Demasiados comentarios en un corto periodo de tiempo. Por favor, inténtelo dentro de un rato.',
	q{Commenter '[_1]' (ID:[_2]) has been successfully registered.} => q{El comentarista '[_1]' (ID:[_2]) se inscribió con éxito.},
	q{Error assigning commenting rights to user '[_1] (ID: [_2])' for weblog '[_3] (ID: [_4])'. No suitable commenting role was found.} => q{Error asignando permisos para comentar al usuario '[_1] (ID: [_2])' para el weblog '[_3] (ID: [_4])'. No se encontró un rol adecuado.},
	q{Failed comment attempt by pending registrant '[_1]'} => q{Falló el intento de comentar por el comentarista pendiente '[_1]'},
	q{Invalid URL '[_1]'} => q{URL '[_1]' no válida},
	q{Login failed: password was wrong for user '[_1]'} => q{Falló la identificación: contraseña errónea del usuario '[_1]'},
	q{Login failed: permission denied for user '[_1]'} => q{Falló la identificación: permiso denegado al usuario '[_1]'},
	q{No such entry '[_1]'.} => q{No existe la entrada '[_1]'.},
	q{[_1] registered to the blog '[_2]'} => q{[_1] registrado en el blog '[_2]'},

## plugins/Comments/lib/MT/CMS/Comment.pm
	'Commenter Details' => 'Detalles del comentarista',
	'Edit Comment' => 'Editar comentario',
	'No such commenter [_1].' => 'No existe el comentarista [_1].',
	'Orphaned comment' => 'Comentario huérfano',
	'The entry corresponding to this comment is missing.' => 'No se encuentra la entrada correspondiente a este comentario.',
	'The parent comment id was not specified.' => 'No se especificó el identificador del comentario raíz.',
	'The parent comment was not found.' => 'No se encontró el comentario padre.',
	'You cannot create a comment for an unpublished entry.' => 'No puede crear un comentario en una entrada sin publicar.',
	'You cannot reply to unapproved comment.' => 'No puede responder a un comentario no aprobado.',
	'You cannot reply to unpublished comment.' => 'No puede contestar a comentarios no publicados.',
	'You do not have permission to approve this comment.' => 'No tiene permisos para aprobar este comentario.',
	'You do not have permission to approve this trackback.' => 'No tiene permisos para aprobar este TrackBack.',
	q{Comment (ID:[_1]) by '[_2]' deleted by '[_3]' from entry '[_4]'} => q{Comentario (ID:[_1]) por '[_2]' borrado por '[_3]' de la entrada '[_4]'},
	q{User '[_1]' banned commenter '[_2]'.} => q{Usuario '[_1]' bloqueó al comentarista '[_2]'.},
	q{User '[_1]' trusted commenter '[_2]'.} => q{Usuario '[_1]' confió en el comentarista '[_2]'.},
	q{User '[_1]' unbanned commenter '[_2]'.} => q{Usuario '[_1]' desbloqueó al comentarista '[_2]'.},
	q{User '[_1]' untrusted commenter '[_2]'.} => q{Usuario '[_1]' desconfió del comentarista '[_2]'.},

## plugins/Comments/lib/MT/Template/Tags/Comment.pm
	'Anonymous' => 'Anónimo',
	'The MTCommentFields tag is no longer available.  Please include the [_1] template module instead.' => 'La etiqueta MTCommentFields ya no está disponible. Por favor, en su lugar, incluya el módulo de plantilla [_1].',

## plugins/Comments/lib/MT/Template/Tags/Commenter.pm
	q{This '[_1]' tag has been deprecated. Please use '[_2]' instead.} => q{Esta etiqueta '[_1]' está obsoleta. Por favor, en su lugar use '[_2]'.},

## plugins/Comments/php/function.mtcommenternamethunk.php
	q{The '[_1]' tag has been deprecated. Please use the '[_2]' tag in its place.} => q{La etiqueta '[_1]' está obsoleta. Por favor, utilice en su lugar la etiqueta '[_2]'.},

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm
	'The login could not be confirmed because of no/invalid blog_id' => 'No se pudo confirmar el inicio de sesión debido al blog_id (sin/no válido)',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected boilerplates?' => '¿Está seguro que desea borrar los textos con formato seleccionados?',
	'Boilerplates' => 'Textos con formato',
	'Create Boilerplate' => 'Crear texto con formato',

## plugins/FormattedText/lib/FormattedText/DataAPI/Callback/FormattedText.pm
	q{The boilerplate '[_1]' is already in use in this site.} => q{Este sitio ya usa el texto con formato '[_1]'.},

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'Boilerplate' => 'Texto con formato',
	q{The boilerplate '[_1]' is already in use in this blog.} => q{Este blog ya usa el texto con formato '[_1]'.},

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'No se pudo cargar el texto con formato.',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/App.pm
	'A Perl module required for using Google Analytics API is missing: [_1].' => 'No se encuentra el módulo de Perl necesario para la API de Google Analytics: [_1].',
	'The name of the profile' => 'El nombre del perfil',
	'The web property ID of the profile' => 'El ID del web propietario del perfil',
	'You did not specify a client ID.' => 'No especificó el ID de cliente.',
	'You did not specify a code.' => 'No especificó el código.',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/OAuth2.pm
	'An error occurred when getting accounts: [_1]: [_2]' => 'Ocurrió un error al obtener las cuentas: [_1]: [_2]',
	'An error occurred when getting profiles: [_1]: [_2]' => 'Ocurrió un error al obtener los perfiles: [_1]: [_2]',
	'An error occurred when getting token: [_1]: [_2]' => 'Ocurrió un error al obtener el token: [_1]: [_2]',
	'An error occurred when refreshing access token: [_1]: [_2]' => 'Ocurrió un error al refrescar el token de acceso: [_1]: [_2]',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/Provider.pm
	'An error occurred when retrieving statistics data: [_1]: [_2]' => 'Ocurrió un error al obtener las estadísticas: [_1]: [_2]',

## plugins/OpenID/lib/MT/Auth/GoogleOpenId.pm
	'A Perl module required for Google ID commenter authentication is missing: [_1].' => 'El módulo de Perl necesario para la autenfificación de comentaristas mediante Google ID no está instalado: [_1].',

## plugins/OpenID/lib/MT/Auth/OpenID.pm
	'Could not load Net::OpenID::Consumer.' => 'No se pudo cargar Net::OpenID::Consumer.',
	'Could not save the session' => 'No se pudo guardar la sesión',
	'Could not verify the OpenID provided: [_1]' => 'No se pudo verificar el OpenID indicado: [_1]',
	'The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.' => 'El módulo de Perl necesario para la autentificación de comentaristas mendiante OpenID (Digest::SHA1) no está instalado.',
	'The address entered does not appear to be an OpenID endpoint.' => 'La dirección indicada no parece ser un proveedor de OpenID.',
	'The text entered does not appear to be a valid web address.' => 'El texto introducido no parece ser una dirección web válida.',
	'Unable to connect to [_1]: [_2]' => 'No fue posible conectar con [_1]: [_2]',

## plugins/Textile/textile2.pl
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.org/documentation/appendices/tags/%t.html',

## plugins/Trackback/lib/MT/App/Trackback.pm
	'This TrackBack item is disabled.' => 'Este elemento de TrackBack fue deshabilitado.',
	'This TrackBack item is protected by a passphrase.' => 'Este elemento de TrackBack está protegido por una contraseña.',
	'TrackBack ID (tb_id) is required.' => 'TrackBack ID (tb_id) es necesario.',
	'TrackBack on "[_1]" from "[_2]".' => 'TrackBack en "[_1]" de "[_2]".',
	'Trackback pings must use HTTP POST' => 'Los pings de Trackback deben usar HTTP POST',
	'You are not allowed to send TrackBack pings.' => 'No se le permite enviar pings de TrackBack.',
	'You are sending TrackBack pings too quickly. Please try again later.' => 'Está enviando pings de TrackBack demasiado rápido. Por favo
r, inténtelo más tarde.',
	'You must define a Ping template in order to display pings.' => 'Debe definir una plantilla de ping para poderlos mostrar.',
	'You need to provide a Source URL (url).' => 'Debe indicar una URL fuente (url).',
	q{Cannot create RSS feed '[_1]': } => q{No se pudo crear la fuente RSS '[_1]': },
	q{Invalid TrackBack ID '[_1]'} => q{ID de TrackBack no válido '[_1]'},
	q{New TrackBack ping to '[_1]'} => q{Nuevo ping de TrackBack en '[_1]'},
	q{New TrackBack ping to category '[_1]'} => q{Nuevo ping de TrackBack en la categoría '[_1]'},
	q{TrackBack on category '[_1]' (ID:[_2]).} => q{TrackBack en la categoría '[_1]' (ID:[_2]).},

## plugins/Trackback/lib/MT/CMS/TrackBack.pm
	'(Unlabeled category)' => '(Categoría sin título)',
	'(Untitled entry)' => '(Entrada sin título)',
	'Edit TrackBack' => 'Editar TrackBack',
	'No Excerpt' => 'Sin resumen',
	'Orphaned TrackBack' => 'TrackBack huérfano',
	'category' => 'categoría',
	q{Ping (ID:[_1]) from '[_2]' deleted by '[_3]' from category '[_4]'} => q{Ping (ID:[_1]) desde '[_2]' borrado por '[_3]' de la categoría '[_4]'},
	q{Ping (ID:[_1]) from '[_2]' deleted by '[_3]' from entry '[_4]'} => q{Ping (ID:[_1]) desde '[_2]' borrado por '[_3]' de la entrada '[_4]'},

## plugins/Trackback/lib/MT/Template/Tags/Ping.pm
	q{<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the 'category' attribute to the tag.} => q{<\$MTCategoryTrackbackLink\$> debe utilizarse en el contexto de una categoría, o con el atributo 'category' en la etiqueta.},

## plugins/Trackback/lib/MT/XMLRPC.pm
	'HTTP error: [_1]' => 'Error HTTP: [_1]',
	'No MTPingURL defined in the configuration file' => 'MTPingURL no está definido en el fichero de configuración',
	'No WeblogsPingURL defined in the configuration file' => 'WeblogsPingURL no está definido en el fichero de configuración',
	'Ping error: [_1]' => 'Error de ping: [_1]',

## plugins/Trackback/lib/Trackback.pm
	'<a href="[_1]">Ping from: [_2] - [_3]</a>' => '<a href="[_1]">Ping desde: [_2] - [_3]</a>',
	'Trackbacks on [_1]: [_2]' => 'Trackbacks en [_1]: [_2]',

## plugins/Trackback/lib/Trackback/App/ActivityFeed.pm
	'All TrackBacks' => 'Todos los TrackBacks',
	'[_1] TrackBacks' => '[_1] TrackBacks',

## plugins/Trackback/lib/Trackback/App/CMS.pm
	'Are you sure you want to remove all trackbacks reported as spam?' => '¿Está seguro de que desea borrar todos los trackbacks marcados como spam?',

## plugins/Trackback/lib/Trackback/Blog.pm
	'Cloning TrackBack pings for blog...' => 'Clonando pings de TrackBack para el blog...',
	'Cloning TrackBacks for blog...' => 'Clonando TrackBacks para el blog...',

## plugins/Trackback/lib/Trackback/CMS/Entry.pm
	q{Ping '[_1]' failed: [_2]} => q{Falló ping '[_1]' : [_2]},

## plugins/Trackback/lib/Trackback/CMS/Search.pm
	'Source URL' => 'URL origen',

## plugins/Trackback/lib/Trackback/Import.pm
	'Saving ping failed: [_1]' => 'Fallo guardando ping: [_1]',
	q{Creating new ping ('[_1]')...} => q{Creando nuevo ping ('[_1]')...},

## plugins/WXRImporter/lib/WXRImporter/Import.pm
	'Archive Root' => 'Raíz de archivos',
	'No Site' => 'No hay sitios',

## plugins/WidgetManager/WidgetManager.pl
	'Failed.' => 'Fallo.',
	'Moving storage of Widget Manager [_2]...' => 'Trasladando los datos del Administrador de Widgets [_2]...',

## plugins/spamlookup/lib/spamlookup.pm
	'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'IP del dominio no coincide con la IP del ping de la URL [_1]; IP del dominio: [_2]; IP del ping: [_3]',
	'E-mail was previously published (comment id [_1]).' => 'El correo se publicó anteriormente (id del comentario [_1]).',
	'Failed to resolve IP address for source URL [_1]' => 'Fallo al resolver la dirección IP de origen de la URL [_1]',
	'Link was previously published (TrackBack id [_1]).' => 'El enlace se publicó anteriormente (id del TrackBack [_1]).',
	'Link was previously published (comment id [_1]).' => 'El enlace se publicó anteriormente (id del comentario [_1]).',
	'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Moderación: La IP del dominio no coincide con la IP del ping de la URL [_1]; IP del dominio: [_2]; IP del ping: [_3]',
	'No links are present in feedback' => 'No hay enlaces presentes en la respuesta',
	'Number of links exceed junk limit ([_1])' => 'Número de enlaces superior al límite ([_1])',
	'Number of links exceed moderation limit ([_1])' => 'Número de enlaces superior al límite de moderación ([_1])',
	'[_1] found on service [_2]' => '[_1] encontrado en el servicio [_2]',
	q{Moderating for Word Filter match on '[_1]': '[_2]'.} => q{Coincidencia del filtro de palabras en '[_1]': '[_2]'.},
	q{Word Filter match on '[_1]': '[_2]'.} => q{Coincidencia del filtro de palabras en '[_1]': '[_2]'.},
	q{domain '[_1]' found on service [_2]} => q{dominio '[_1]' encontrado en el servicio '[_2]'},

## search_templates/comments.tmpl
	'Find new comments' => 'Encontrar nuevos comentarios',
	'No new comments were found in the specified interval.' => 'No se encontraron nuevos comentarios en el intervalo especificado',
	'No results found' => 'No se encontraron resultados',
	'Posted in [_1] on [_2]' => 'Publicado en [_1] el [_2]',
	'Search for new comments from:' => 'Buscar nuevos comentarios desde:',
	'five months ago' => 'hace cinco meses',
	'four months ago' => 'hace cuatro meses',
	'one month ago' => 'hace un mes',
	'one week ago' => 'hace una semana',
	'one year ago' => 'hace un año',
	'six months ago' => 'hace seis meses',
	'the beginning' => 'el principio',
	'three months ago' => 'hace tres meses',
	'two months ago' => 'hace dos meses',
	'two weeks ago' => 'hace dos semanas',
	q{Select the time interval that you'd like to search in, then click 'Find new comments'} => q{Seleccione el intervalo temporal en el que desea buscar, y luego haga clic en 'Buscar nuevos comentarios'},

## search_templates/content_data_default.tmpl
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'COMIENZO DE LA BARRA LATERAL BETA PARA MOSTRAR LA INFORMACIÓN DE BÚSQUEDA',
	'END OF ALPHA SEARCH RESULTS DIV' => 'FIN DE LOS RESULTADOS DE BÚSQUEDA - ALPHA DIV',
	'END OF CONTAINER' => 'FIN DEL CONTENEDOR',
	'END OF PAGE BODY' => 'FIN DEL CUERPO DE LA PÁGINA',
	'Feed Subscription' => 'Suscripción de sindicación',
	'Matching content data from [_1]' => 'Buscando coincidencias de datos de contenido de [_1]',
	'NO RESULTS FOUND MESSAGE' => 'MENSAJE DE NINGÚN RESULTADO ENCONTRADO',
	'Posted <MTIfNonEmpty tag="ContentAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Publicado <MTIfNonEmpty tag="ContentAuthorDisplayName">por [_1] </MTIfNonEmpty>en [_2]',
	'SEARCH FEED AUTODISCOVERY LINK IS PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'El enlace de autodescubrimiento a la fuente de búsquedas sólo se publicará cuando se halla ejecutado una búsqueda.',
	'SEARCH RESULTS DISPLAY' => 'MOSTRAR RESULTADOS DE LA BÚSQUEDA',
	'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'INFORMACIÓN DE SUSCRIPCIÓN A LA FUENTE DE BÚSQUEDA/ETIQUETA',
	'SET VARIABLES FOR SEARCH vs TAG information' => 'ESPECIFICAR VARIABLES PARA LA BÚSQUEDA vs información de etiqueta',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM',
	'Search this site' => 'Buscar en este sitio',
	'Showing the first [_1] results.' => 'Mostrando los primeros [_1] resultados.',
	'Site Search Results' => 'Resultados de la búsqueda de sitios',
	'Site search' => 'Búsqueda de sitios',
	'What is this?' => '¿Qué es esto?',
	'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds',
	q{Content Data matching '[_1]'} => q{Datos de contenido que coinciden con '[_1]'},
	q{Content Data tagged with '[_1]'} => q{Datos de contenido etiquetados con '[_1]'},
	q{If you use an RSS reader, you can subscribe to a feed of all future content data matching '[_1]'.} => q{Si usa un lector de RSS, puede suscribirse a una fuente de todo los datos de contenido futuros que coinciden con '[_1]'.},
	q{If you use an RSS reader, you can subscribe to a feed of all future content data tagged '[_1]'.} => q{Si usa un lector de RSS, puede suscribirse a la fuente de todos los datos de contenido futuros etiquetados '[_1]'.},
	q{No pages were found containing '[_1]'.} => q{No se encontraron páginas que contuvieran '[_1]'.},

## search_templates/content_data_results_feed.tmpl
	'Search Results for [_1]' => 'Resultados de la búsqueda sobre [_1]',

## search_templates/default.tmpl
	'Blog Search Results' => 'Resultados de la búsqueda en el blog',
	'Blog search' => 'Buscar en el blog',
	'Match case' => 'Distinguir mayúsculas',
	'Matching entries from [_1]' => 'Entradas coincidentes de [_1]',
	'Other Tags' => 'Otras etiquetas',
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Publicado <MTIfNonEmpty tag="EntryAuthorDisplayName">por [_1] </MTIfNonEmpty>en [_2]',
	'Regex search' => 'Expresión regular',
	'TAG LISTING FOR TAG SEARCH ONLY' => 'LISTA DE ETIQUETAS PARA LA BÚSQUEDA DE SOLO ETIQUETAS',
	q{Entries from [_1] tagged with '[_2]'} => q{Entradas de [_1] etiquetadas en '[_2]'},
	q{Entries matching '[_1]'} => q{Entradas coincidentes con '[_1]'},
	q{Entries tagged with '[_1]'} => q{Entradas etiquetadas en '[_1]'},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries matching '[_1]'.} => q{Si usa un lector de RSS, puede suscribirse a la fuente de sindicación de todas las futuras entradas que contengan '[_1]'.},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries tagged '[_1]'.} => q{Si usa un lector de RSS, puede suscribirse a la fuente de todas las futuras entradas con la etiqueta '[_1]'.},

## themes/classic_blog/templates/comment_detail.mtml
	'[_1] replied to <a href="[_2]">comment from [_3]</a>' => '[_1] respondió al <a href="[_2]">comentario de [_3]</a>',

## themes/classic_blog/templates/comment_listing.mtml
	'Comment Detail' => 'Detalle del comentario',

## themes/classic_blog/templates/comment_preview.mtml
	'(You may use HTML tags for style)' => '(Puede usar etiquetas HTML para el estilo)',
	'Leave a comment' => 'Escribir un comentario',
	'Previewing your Comment' => 'Vista previa del comentario',
	'Replying to comment from [_1]' => 'Respondiendo al comentario de [_1]',
	'Submit' => 'Enviar',

## themes/classic_blog/templates/comment_response.mtml
	'Your comment has been submitted!' => '¡El comentario se ha recibido!',
	'Your comment submission failed for the following reasons: [_1]' => 'El envío del comentario falló por alguna de las siguientes razones: [_1]',

## themes/classic_blog/templates/comments.mtml
	'Remember personal info?' => '¿Recordar datos personales?',
	'The data is modified by the paginate script' => 'Los datos son modificados por el script de paginación',

## themes/classic_blog/templates/recent_comments.mtml
	'<strong>[_1]:</strong> [_2] <a href="[_3]" title="full comment on: [_4]">read more</a>' => '<strong>[_1]:</strong> [_2] <a href="[_3]" title="comentario completo en: [_4]">más</a>',

## themes/classic_blog/templates/trackbacks.mtml
	'<a href="[_1]">[_2]</a> from [_3] on <a href="[_4]">[_5]</a>' => '<a href="[_1]">[_2]</a> desde [_3] en <a href="[_4]">[_5]</a>',
	'TrackBack URL: [_1]' => 'URL de TrackBack: [_1]',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">Leer más</a>',

## themes/classic_blog/theme.yaml
	'A traditional blogging design that comes with plenty of styles and a selection of 2 column / 3 column layouts. Best for use in standard blog publishing applications.' => 'Un diseño de blogs tradicional con múltiples estilos y posibilidad de seleccionar una disposición a 2 o 3 columnas. Recomendado para instalaciones de blogs estándares.',
	'Displays error, pending or confirmation message for comments.' => 'Muestra mensajes de error o mensajes de pendiente y confirmación en los comentarios.',
	'Displays preview of comment.' => 'Muestra una previsualización del comentario.',
	'Displays results of a search for content data.' => 'Muestra resultados de una búsqueda de datos de contenido.',
	'Improved listing of comments.' => 'Lista de comentarios mejorada.',

## themes/classic_website/templates/about_this_page.mtml
	'<a href="[_1]">[_2]</a> is the next entry in this website.' => '<a href="[_1]">[_2]</a> es la siguiente entrada en este sitio.',
	'<a href="[_1]">[_2]</a> was the previous entry in this website.' => '<a href="[_1]">[_2]</a> fue la entrada anterior en este sitio.',

## themes/classic_website/templates/blogs.mtml
	'Blogs' => 'Blogs',

## themes/classic_website/templates/syndication.mtml
	q{Subscribe to this website's feed} => q{Suscribirse a la sindicación de este sitio web},

## themes/classic_website/theme.yaml
	'Classic Website' => 'Sitio web clásico',
	'Create a blog portal that aggregates contents from several blogs in one website.' => 'Crear un portal que agrega contenidos de otros blogs en un sitio web.',

## tmpl/cms/asset_replace.tmpl
	'Upload New Asset' => 'Transferir nuevo fichero multimedia',

## tmpl/cms/backup.tmpl
	'Archive Format' => 'Formato de archivo',
	'Choose sites...' => 'Seleccione sitios...',
	'Everything' => 'Todo',
	'Export (e)' => 'Exportar (e)',
	'No size limit' => 'Sin límite de tamaño',
	'Reset' => 'Reiniciar',
	'Target File Size' => 'Tamaño del fichero',
	'What to Export' => 'Qué exportar',
	q{Don't compress} => q{No comprimir},

## tmpl/cms/cfg_entry.tmpl
	'Accept TrackBacks' => 'Aceptar TrackBacks',
	'Alignment' => 'Alineación',
	'Ascending' => 'Ascendente',
	'Basename Length' => 'Longitud del nombre base',
	'Center' => 'Centro',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'Entidades de caracteres (&amp#8221;, &amp#8220;, etc.)',
	'Compose Defaults' => 'Valores predefinidos de composición',
	'Content CSS will be applied when WYSIWYG editor does support. You can specify CSS file by URL or {{theme_static}} placeholder. Example: {{theme_static}}path/to/cssfile.css' => 'El contenido de la hoja de estilo se aplicará cuando el editor visual lo soporte. Puede especificar un fichero CSS mediante la URL o el marcador {{theme_static}}. Ejemplo: {{theme_static}}ruta/a/fichero.css',
	'Content CSS' => 'Contenido de la hoja de estilo (CSS)',
	'Czech' => 'Checo',
	'Danish' => 'Danés',
	'Date Language' => 'Idioma de la fecha',
	'Days' => 'Días',
	'Descending' => 'Descendente',
	'Display in popup' => '', # Translate - New
	'Display on the same screen' => '', # Translate - New
	'Dutch' => 'Holandés',
	'English' => 'Inglés',
	'Entry Fields' => 'Campos de las entradas',
	'Estonian' => 'Estonio',
	'Excerpt Length' => 'Tamaño del resumen',
	'French' => 'Francés',
	'German' => 'Alemán',
	'Icelandic' => 'Islandés',
	'Image default insertion options' => 'Opciones predefinidas de inserción de imágenes',
	'Italian' => 'Italiano',
	'Japanese' => 'Japonés',
	'Left' => 'Izquierda',
	'Link from image' => '', # Translate - New
	'Link to original image' => '', # Translate - New
	'Listing Default' => 'Listado predefinido',
	'No substitution' => 'Sin sustitución',
	'Norwegian' => 'Noruego',
	'Note: This option is currently ignored since TrackBacks are disabled either child site or system-wide.' => 'Nota: Actualmente esta opción es ignorada porque los TrackBacks están deshabilitados en el sitio hijo o a nivel de todo el sistema.',
	'Note: This option is currently ignored since TrackBacks are disabled either site or system-wide.' => 'Nota: Actualmente esta opción es ignorada porque los TrackBacks están deshabilitados en el sitio o a nivel de todo el sistema.',
	'Note: This option is currently ignored since comments are disabled either child site or system-wide.' => 'Nota: Actualmente esta opción es ignorada porque los comentarios están deshabilitados bien en el sitio hijo o a nivel de todo el sistema.',
	'Note: This option is currently ignored since comments are disabled either site or system-wide.' => 'Nota: Actualmente esta opción es ignorada porque los comentarios están comentarios están deshabilitados bien en el sitio o a nivel de todo el sistema.',
	'Order' => 'Orden',
	'Page Fields' => 'Campos de las páginas',
	'Polish' => 'Polaco',
	'Portuguese' => 'Portugués',
	'Posts' => 'Entradas',
	'Publishing Defaults' => 'Valores predefinidos de publicación',
	'Punctuation Replacement Setting' => 'Configuración de reemplazo de puntuación',
	'Punctuation Replacement' => 'Reemplazo de puntuación',
	'Replace Fields' => 'Reemplazar campos',
	'Replace UTF-8 characters frequently used by word processors with their more common web equivalents.' => 'Reemplace los carácteres UTF-8 más usados por los procesadores de texto por sus equivalentes más comunes en el web.',
	'Right' => 'Derecha',
	'Save changes to these settings (s)' => 'Guardar cambios de estas opciones (s)',
	'Setting Ignored' => 'Opción ignorada',
	'Slovak' => 'Eslovaco',
	'Slovenian' => 'Esloveno',
	'Spanish' => 'Español',
	'Specifies the default Text Formatting option when creating a new entry.' => 'Especifica el formato de texto predeterminado para las entradas nuevas.',
	'Suomi' => 'Suomi',
	'Swedish' => 'Sueco',
	'Text Formatting' => 'Formato del texto',
	'The range for Basename Length is 15 to 250.' => 'El rango para la longitud del nombre base es de 15 a 250.',
	'Unpublished' => 'No publicado',
	'Use thumbnail' => 'Usar miniatura',
	'WYSIWYG Editor Setting' => 'Configuración del editor con estilos',
	'You must set valid default thumbnail width.' => 'Debe indicar un ancho válido por defecto para las miniaturas.',
	'Your preferences have been saved.' => 'Se han guardado las preferencias.',
	'pixels' => 'píxeles',
	'width:' => 'ancho:',
	q{ASCII equivalents (&quot;, ', ..., -, --)} => q{Equivalentes ASCII (&quot;, ', ..., -, --)},

## tmpl/cms/cfg_feedback.tmpl
	'([_1])' => '([_1])',
	'Accept TrackBacks from any source.' => 'Aceptar TrackBacks de cualquier origen.',
	'Accept comments according to the policies shown below.' => 'Aceptar comentarios de acuerdo a las políticas mostradas abajo.',
	'Allow HTML' => 'Permitir HTML',
	'Allow commenters to include a limited set of HTML tags in their comments. Otherwise all HTML will be stripped out.' => 'Permitir a los comentaristas que incluyan un conjunto limitado de etiquetas HTML en los comentarios. Si no, se filtrará todo el HTML.',
	'Any authenticated commenters' => 'Solo comentaristas autentificados',
	'Anyone' => 'Cualquiera',
	'Auto-Link URLs' => 'Autoenlazar URLs',
	'Automatic Deletion' => 'Borrado automático',
	'Automatically delete spam feedback after the time period shown below.' => 'Transcurrido el periodo de tiempo indicado abajo borra automáticamente las respuestas basura.',
	'CAPTCHA Provider' => 'Proveedor de CAPTCHA',
	'Comment Display Settings' => 'Configuración de la visualización de comentarios',
	'Comment Order' => 'Orden de los comentarios',
	'Comment Settings' => 'Configuración de comentarios',
	'Comment authentication is not available because at least one of the required Perl modules, MIME::Base64 and LWP::UserAgent, are not installed. Install the missing modules and reload this page to configure comment authentication.' => 'La autentificación de comentarios no está disponible porque al menos uno de los módulos de Perl necesarios, MIME::Base64 o LWP::UserAgent, no están instalados. Instale los módulos necesarios y recargue esta página para configurar la autentificación de comentarios.',
	'Commenting Policy' => 'Política de comentarios',
	'Delete Spam After' => 'Borrar spam después',
	'E-mail Notification' => 'Notificación por correo-e',
	'Enable External TrackBack Auto-Discovery' => 'Habilitar autodescubrimiento de TrackBacks externos',
	'Enable Internal TrackBack Auto-Discovery' => 'Habilitar autodescubrimiento de TrackBacks internos',
	'Hold all TrackBacks for approval before they are published.' => 'Retener los TrackBacks para su aprobación antes de publicarlos.',
	'Immediately approve comments from' => 'Aceptar inmediatamente los comentarios de',
	'Limit HTML Tags' => 'Limitar etiquetas HTML',
	'Moderation' => 'Moderación',
	'No CAPTCHA provider available' => 'No hay disponible ningún proveedor de CAPTCHA.',
	'No one' => 'Nadie',
	'Note: Commenting is currently disabled at the system level.' => 'Nota: Los comentarios están actualmente desactivados a nivel de sistema.',
	'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Nota: Actualmente, esta opción es ignorada debido a que los pings salientes están desactivados a nivel del sistema.',
	'Note: This option may be affected since outbound pings are constrained system-wide.' => 'Nota: Esta opción podría verse afectada debido a que los pings salientes están restringidos a nivel del sistema.',
	'Note: TrackBacks are currently disabled at the system level.' => 'Nota: Actualmente, los TrackBacks están desactivados a nivel del sistema.',
	'Off' => 'Desactivar',
	'On' => 'Activar',
	'Only when attention is required' => 'Solo cuando se requiera atención',
	'Select whether you want comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Seleccione si desea mostrar los comentarios en orden ascendente (antiguos primero) o descendente (recientes primero).',
	'Setting Notice' => 'Alerta sobre configuración',
	'Setup Registration' => 'Configuración del registro',
	'Spam Score Threshold' => 'Puntuación límite de spam',
	'Spam Settings' => 'Configuración del spam',
	'This value can be between -10 and +10. The bigger this value is, the more possible spam-detection framework determines comment/trackback as a spam.' => 'Este valor puede estar entre -10 y +10. Cuanto mayor sea, mayor será la probabilidad de que el sistema de antispam filtre los comentarios o TrackBacks como spam.',
	'TrackBack Auto-Discovery' => 'Autodescubrimiento de TrackBacks',
	'TrackBack Options' => 'Opciones de TrackBacks',
	'TrackBack Policy' => 'Política de TrackBacks',
	'Trackback Settings' => 'Configuración de Trackbacks',
	'Transform URLs in comment text into HTML links.' => 'Transformar las URLs en enlaces HTML.',
	'Trusted commenters only' => 'Solo comentaristas de confianza',
	'Use Comment Confirmation Page' => 'Usar página de confirmación de comentarios',
	'Use defaults' => 'Utilizar valores predeterminados',
	'Use my settings' => 'Utilizar mis preferencias',
	'days' => 'días',
	q{'nofollow' exception for trusted commenters} => q{Excepción 'nofollow' para los comentaristas de confianza.},
	q{Apply 'nofollow' to URLs} => q{Aplicar 'nofollow' a las URLs},
	q{Do not add the 'nofollow' attribute when a comment is submitted by a trusted commenter.} => q{No añade el atributo 'nofollow' cuando la respuesta es enviada por un comentarista de confianza.},
	q{Each commenter's browser will be redirected to a comment confirmation page after their comment is accepted.} => q{Antes de aceptar un comentario, el navegador de cada comentarista se redirigirá a una página de confirmación de comentarios.},
	q{If enabled, all URLs in comments and TrackBacks will be assigned a 'nofollow' link relation.} => q{Si está activado, se asignará un atributo 'nofollow' a los enlaces de todas las URLs en los comentarios y en los Trackbacks.},
	q{No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed and if the CaptchaSourceImageBase configuration directive points to a valid captcha-source directory within the 'mt-static/images' directory.} => q{No existe ningún proveedor CAPTCHA en este sistema. Por favor, compruebe que Image::Magick esté instalado y que la directiva de configuración CaptchaSourceImageBase apunta a un directorio válido de captcha dentro del directorio 'mt-static/images'.},

## tmpl/cms/cfg_plugin.tmpl
	'Are you sure you want to disable plugins for the entire Movable Type installation?' => '¿Está seguro de que desea desactivar las extensiones en toda la instalación de Movable Type?',
	'Are you sure you want to disable this plugin?' => '¿Está seguro de que desea desactivar esta extensión?',
	'Are you sure you want to enable plugins for the entire Movable Type installation? (This will restore plugin settings that were in place before all plugins were disabled.)' => '¿Está seguro de que desea activar las extensiones para toda la instalación de Movable Type? (Esto restaurará la configuración de las extensiones tal y como estaban cuando se desactivaron).',
	'Are you sure you want to enable this plugin?' => '¿Está seguro de que desea activar esta extensión?',
	'Are you sure you want to reset the settings for this plugin?' => '¿Está seguro de que desea reiniciar la configuración de esta extensión?',
	'Author of [_1]' => 'Autor de [_1]',
	'Disable Plugins' => 'Desactivar extensiones',
	'Disable plugin functionality' => 'Desactivar las funciones de las extensiones',
	'Documentation for [_1]' => 'Documentación sobre [_1]',
	'Enable Plugins' => 'Activar extensiones',
	'Enable or disable plugin functionality for the entire Movable Type installation.' => 'Activa o desactiva la funcionalidad de las extensiones para toda la instalación de Movable Type.',
	'Enable plugin functionality' => 'Activar las funciones de las extensiones',
	'Failed to Load' => 'Falló al cargar',
	'Failed to load' => 'Falló al cargar',
	'Find Plugins' => 'Buscar extensiones',
	'Info' => 'Información',
	'Junk Filters:' => 'Filtros de basura:',
	'More about [_1]' => 'Más sobre [_1]',
	'No plugins with blog-level configuration settings are installed.' => 'No hay extensiones instaladas con configuración a nivel del sistema.',
	'No plugins with configuration settings are installed.' => 'Ningún plugin que haya sido configurado ha sido instalado.',
	'Plugin Home' => 'Web de Extensiones',
	'Plugin System' => 'Extensiones del sistema',
	'Plugin error:' => 'Error de la extensión:',
	'Reset to Defaults' => 'Reiniciar con los valores predefinidos',
	'Resources' => 'Recursos',
	'Run [_1]' => 'Ejecutar [_1]',
	'Tag Attributes:' => 'Atributos de etiquetas:',
	'Text Filters' => 'Filtros de texto',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be completely functional.' => 'Esta extensión no está actualizada para el soporte de Movable Type [_1]. Por lo tanto, podría no ser completamente funcional.',
	'Your plugin settings have been reset.' => 'Se reinició la configuración de la extensión.',
	'Your plugin settings have been saved.' => 'Se guardó la configuración de la extensión.',
	'Your plugins have been reconfigured.' => 'Se reconfiguraron las extensiones.',
	'_PLUGIN_DIRECTORY_URL' => 'https://plugins.movabletype.org/',
	q{Your plugins have been reconfigured. Since you're running mod_perl, you must restart your web server for these changes to take effect.} => q{Las extensiones se han reconfigurado. Dado que está ejecuntando mod_perl debe reiniciar el servidor web para que estos cambios tomen efecto.},
	q{Your plugins have been reconfigured. Since you're running mod_perl, you will need to restart your web server for these changes to take effect.} => q{Se reconfiguraron las extensiones. Debido a que está ejecutando mod_perl, deberá reiniciar el servidor web para que estos cambios tengan efecto.},

## tmpl/cms/cfg_prefs.tmpl
	'Active Server Page Includes' => 'Inclusiones de páginas Active Server',
	'Advanced Archive Publishing' => 'Publicación avanzada de archivos',
	'Allow properly configured template modules to be cached to enhance publishing performance.' => 'Permite que los módulos de plantillas configurados como tal se cacheen para mejorar el rendimiento de la publicación.',
	'Allow to change at upload' => 'Permitir cambiar al transferir',
	'Apache Server-Side Includes' => 'Inclusiones de Apache',
	'Archive Settings' => 'Configuración de archivos',
	'Archive URL' => 'URL de archivos',
	'Cancel upload' => 'Cancelar transferencia',
	'Change license' => 'Cambiar licencia',
	'Choose archive type' => 'Seleccione un tipo de archivo',
	'Dynamic Publishing Options' => 'Opciones de la publiación dinámica',
	'Enable conditional retrieval' => 'Activar recuperación condicional',
	'Enable dynamic cache' => 'Activar caché dinámica',
	'Enable orientation normalization' => 'Activiar la normalización de la orientación',
	'Enable revision history' => 'Activar histórico de revisiones',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your site directory.' => 'Error: Movable Type no puede escribir en el directorio de cachés de plantillas. Por favor, compruebe los permisos del directorio <code>[_1]</code> dentro del directorio de su sitio web.',
	'Error: Movable Type was not able to create a directory for publishing your [_1]. If you create this directory yourself, grant write permission to the web server.' => 'Error: Movable Type no pudo crear un directorio para publicar el [_1]. Otorgue permisos de escritura para el servidor web si va a crear este directorio usted mismo.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your site directory.' => 'Error: Movable Type no pudo crear un directorio para cachear las plantillas dinámicas. Debe crear un directorio llamado <code>[_1]</code> dentro del directorio del sitio web.',
	'If you choose a different language than the default language defined at the system level, you may need to change module names in certain templates to include different global modules.' => 'Si desea un idioma diferente del idioma predefinido a nivel de sistema, deberá cambiar los nombres de los módulos en ciertas plantillas para incluir otros módulos globales.',
	'Java Server Page Includes' => 'Inclusiones de páginas Java Server',
	'Language' => 'Idioma',
	'License' => 'Licencia',
	'Module Caching' => 'Caché de módulos',
	'Module Settings' => 'Configuración de módulos',
	'No archives are active' => 'No hay archivos activos',
	'None (disabled)' => 'Ninguno (deshabilitado)',
	'Normalize orientation' => 'Normalizar orientación',
	'Note: Revision History is currently disabled at the system level.' => 'Nota: Actualmente, el histórico de revisiones está desactivado a nivel del sistema.',
	'Number of revisions per content data' => 'Número de revisiones por datos de contenido',
	'Number of revisions per entry/page' => 'Número de revisiones por entrada/página',
	'Number of revisions per template' => 'Número de revisiones por plantilla',
	'Operation if a file exists' => 'Acción si existe un fichero',
	'Overwrite existing file' => 'Reescribir fichero existente',
	'PHP Includes' => 'Inclusiones PHP',
	'Preferred Archive' => 'Archivo preferido',
	'Publish With No Entries' => 'Publicar sin entradas',
	'Publish archives outside of Site Root' => 'Publicar archivos fuera de la raíz del sitio',
	'Publish category archive without entries' => 'Publicar archivos de categorías sin entradas',
	'Publishing Paths' => 'Rutas de publicación',
	'Remove license' => 'Borrar licencia',
	'Rename filename' => 'Renombrar fichero',
	'Rename non-ascii filename automatically' => 'Renombrar automáticamente nombres de ficheros que no sean ASCII.',
	'Revision History' => 'Histórico de revisiones',
	'Revision history' => 'Histórico de revisiones',
	'Select a license' => 'Seleccionar una licencia',
	'Server Side Includes' => 'Server Side Includes',
	'Site root must be under [_1]' => 'La raíz del sitio debe estar bajo [_1]',
	'The URL of the archives section of your child site. Example: http://www.example.com/blog/archives/' => 'La URL de la sección de archivos del sitio hijo. Ejemplo: http://www.ejemplo.com/blog/archivos/',
	'The URL of the archives section of your site. Example: http://www.example.com/archives/' => 'La URL de la sección de archivos de su sitio. Ejemplo: http://www.ejemplo.com/archivos/',
	'Time Zone' => 'Zona horaria',
	'Time zone not selected' => 'No hay ninguna zona horaria seleccionada.',
	'UTC+0 (Universal Time Coordinated)' => 'UTC+0 (Hora universal coordinada)',
	'UTC+1 (Central European Time)' => 'UTC+1 (Hora de Europa Central)',
	'UTC+10 (East Australian Time)' => 'UTC+10 (Hora de Australia Oriental)',
	'UTC+11' => 'UTC+11',
	'UTC+12 (International Date Line East)' => 'UTC+12 (Línea internacional de cambio de fecha, Este)',
	'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (Nueva Zelanda, horario de verano)',
	'UTC+2 (Eastern Europe Time)' => 'UTC+2 (Hora de Europa Oriental)',
	'UTC+3 (Baghdad Time/Moscow Time)' => 'UTC+3 (Hora de Bagdad y Moscú)',
	'UTC+3.5 (Iran)' => 'UTC+3.5 (Irán)',
	'UTC+4 (Russian Federation Zone 3)' => 'UTC+4 (Federación Rusa, zona 3)',
	'UTC+5 (Russian Federation Zone 4)' => 'UTC+5 (Federación Rusa, zona 4)',
	'UTC+5.5 (Indian)' => 'UTC+5.5 (India)',
	'UTC+6 (Russian Federation Zone 5)' => 'UTC+6 (Federación Rusa, zona 5)',
	'UTC+6.5 (North Sumatra)' => 'UTC+6.5 (Sumatra del Norte)',
	'UTC+7 (West Australian Time)' => 'UTC+7 (Hora de Australia Occidental)',
	'UTC+8 (China Coast Time)' => 'UTC+8 (Hora de la Costa China)',
	'UTC+9 (Japan Time)' => 'UTC+9 (Hora del Japón)',
	'UTC+9.5 (Central Australian Time)' => 'UTC+9.5 (Hora de Australia Central)',
	'UTC-1 (West Africa Time)' => 'UTC-1 (Hora de África Occidental)',
	'UTC-10 (Aleutians-Hawaii Time)' => 'UTC-10 (Hora de las Islas Aleutianas y Hawai)',
	'UTC-11 (Nome Time)' => 'UTC-11 (Hora de Nome)',
	'UTC-2 (Azores Time)' => 'UTC-2 (Hora de las Islas Azores)',
	'UTC-3 (Atlantic Time)' => 'UTC-3 (Hora del Atlántico)',
	'UTC-3.5 (Newfoundland)' => 'UTC-3.5 (Terranova)',
	'UTC-4 (Atlantic Time)' => 'UTC-4 (Hora del Atlántico)',
	'UTC-5 (Eastern Time)' => 'UTC-5 (Hora del Este de los Estados Unidos)',
	'UTC-6 (Central Time)' => 'UTC-6 (Hora del Centro de los Estados Unidos)',
	'UTC-7 (Mountain Time)' => 'UTC-7 (Hora de las Montañas Rocosas de los Estados Unidos)',
	'UTC-8 (Pacific Time)' => 'UTC-8 (Hora del Pacífico)',
	'UTC-9 (Alaskan Time)' => 'UTC-9 (Hora de Alaska)',
	'Upload Destination' => 'Destino de las transferencias',
	'Upload and rename' => 'Transferir y renombrar',
	'Use absolute path' => 'Usar ruta absoluta',
	'Use subdomain' => 'Usar subdominio',
	'Warning: Changing the [_1] URL requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'Warning: Changing the [_1] root requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'Warning: Changing the archive URL requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'Warning: Changing the archive path requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'You did not select a time zone.' => 'No seleccionó una zona horaria.',
	'You must set a valid Archive URL.' => 'Debe indicar una URL de archivos válida.',
	'You must set a valid Local Archive Path.' => 'Debe indicar una ruta local de archivos válida.',
	'You must set a valid Local file Path.' => 'Debe indicar una ruta local de ficheros válida.',
	'You must set a valid URL.' => 'Debe indicar una URL válida.',
	'You must set your Child Site Name.' => 'Debe indicar el nombre del sitio hijo.',
	'You must set your Local Archive Path.' => 'Debe introducir la Ruta Local de Archivos.',
	'You must set your Local file Path.' => 'Debe indicar la ruta local de ficheros.',
	'You must set your Site Name.' => 'Debe indicar el nombre del sitio.',
	'Your child site does not have an explicit Creative Commons license.' => 'Su sitio hijo no tiene explícita una licencia de Creative Commons.',
	'Your child site is currently licensed under:' => 'Actualmente su sitio hijo tiene la licencia:',
	'Your site does not have an explicit Creative Commons license.' => 'Su sitio no tiene explícita una licencia de Creative Commons.',
	'Your site is currently licensed under:' => 'Actualemente su sitio tiene la licencia:',
	'[_1] Settings' => 'Configuración de [_1]',
	q{The URL of your child site. Exclude the filename (i.e. index.html). End with '/'. Example: http://www.example.com/blog/} => q{La URL de su sitio hijo. Excluya el nombre de fichero (p.e. index.html). Finalice con '/'. Ejemplo: http://www.ejemplo.com/blog/},
	q{The URL of your site. Exclude the filename (i.e. index.html).  End with '/'. Example: http://www.example.com/} => q{La URL de su sitio. Excluya el nombre de fichero (p.e. index.html). Finalice con '/'. Ejemplo: http://www.ejemplo.com/},
	q{The path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{La ruta de publicación de los ficheros índice de la sección de archivos. Se recomienda una ruta absoluta (que en Linux comienza con '/' y en Windows con 'C:\'. No terminar con '/' o '\'. Ejemplo: /home/mt/public_html o C:\www\public_html},
	q{The path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{La ruta de publicación de los ficheros índice de la sección de archivos. No terminar con '/' o '\'. Ejemplo: /home/mt/public_html/blog o C:\www\public_html\blog},
	q{The path where your index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{La ruta de publicación de los ficheros índice. Se recomienda una ruta absoluta (que en Linux comienza con '/' y en Windows con 'C:\'). No terminar con '/' o '\'. Ejemplo: /home/mt/public_html o C:\www\public_html},
	q{The path where your index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{La ruta de publicación de los ficheros índice. No terminar con '/' o '\'. Ejemplo: /home/mt/public_html/blog o C:\www\public_html\blog},
	q{Used to generate URLs (permalinks) for this child site's archived entries. Choose one of the archive types used in this child site's archive templates.} => q{Usado para generar URLs (enlaces permanentes) de las entradas archivadas de este sitio hijo. Seleccione uno de los tipos de archivo usado en las plantillas de archivo de este sitio hijo.},
	q{Used to generate URLs (permalinks) for this site's archived entries. Choose one of the archive types used in this site's archive templates.} => q{Usado para generar URLs (enlaces permanentes) de las entradas archivadas de este sitio. Seleccione uno de los tipos de archivo usado en las plantillas de archivo de este sitio.},

## tmpl/cms/cfg_rebuild_trigger.tmpl
	'Action' => 'Acción',
	'Allow' => 'Permitir',
	'Config Rebuild Trigger' => 'Configurar inductor de reconstrucción',
	'Content Privacy' => 'Privacidad de contenidos',
	'Cross-site aggregation will be allowed by default.  Individual sites can be configured through the site-level rebuild trigger settings to restrict access to their content by other sites.' => '', # Translate - New
	'Cross-site aggregation will be disallowed by default.  Individual sites can be configured through the site-level rebuild trigger settings to allow access to their content by other sites.' => '', # Translate - New
	'Data' => 'Datos',
	'Default system aggregation policy' => 'Política predefinida de agregación del sistema',
	'Disallow' => 'No permitir',
	'Exclude sites/child sites' => 'Excluir sitios/sitios hijos',
	'Include sites/child sites' => 'Incluir sitios/sitios hijos',
	'MTMultiBlog tag default arguments' => 'Argumentos predefinidos de la etiqueta MTMultiBlog',
	'Rebuild Trigger settings have been saved.' => 'Se ha guardado la configuración del inductor de reconstrucción.',
	'Rebuild Triggers' => 'Eventos de republicación',
	'Site/Child Site' => 'Sitio/Sitio hijo',
	'Use system default' => 'Utilizar valor predefinido del sistema',
	'When' => 'Cuando',
	'You have not defined any rebuild triggers.' => 'No ha definido ningún inductor de reconstrucción.',
	q{Enables use of the MTSites tag without include_sites/exclude_sites attributes. Comma-separated SiteIDs or 'all' (include_sites only) are acceptable values.} => q{}, # Translate - New

## tmpl/cms/cfg_registration.tmpl
	'(No role selected)' => '(Sin rol seleccionado',
	'Allow visitors to register as members of this site using one of the Authentication Methods selected below.' => 'Permitir que los visitantes se registren como miembros del sitio usando uno de los métodos de autentificación seleccionados debajo.',
	'Authentication Methods' => 'Métodos de autentificación',
	'New Created User' => 'Usuario de nueva creación',
	'Note: Registration is currently disabled at the system level.' => 'Nota: Actualmente el regisro está desactivado a nivel del sistema.',
	'One or more Perl modules may be missing to use this authentication method.' => 'Uno o más módulos de Perl podrían no estar instalados y ser necesarios para usar este método de autentificación.',
	'Please select authentication methods to accept comments.' => 'Por favor, seleccione los métodos de autentificación para aceptar comentarios.',
	'Registration Not Enabled' => 'Registro no activado',
	'Select a role that you want assigned to users that are created in the future.' => 'Seleccione el rol que desea asignar a los usuarios que se creen en el futuro.',
	'Select roles' => 'Seleccionar roles',
	'User Registration' => 'Registro de usuarios',
	'Your site preferences have been saved.' => 'Se ha guardado la configuración del sitio.',

## tmpl/cms/cfg_system_general.tmpl
	'(No Outbound TrackBacks)' => '(Ningún Trackback saliente)',
	'(None selected)' => '(Ninguno seleccionado)',
	'A Movable Type user will be locked out if he or she submits an incorrect password [_1] or more times within [_2] seconds.' => 'Si el usuario envía una clave incorrecta [_1] o más veces en menos de [_2] segundos, se bloqueará al usuario de Movable Type.',
	'A test mail was sent.' => 'Se envió un correo de prueba.',
	'Allow sites to be placed only under this directory' => 'Permite poner a los sitios sólo bajo este directorio',
	'An IP address will be locked out if [_1] or more incorrect login attempts are made within [_2] seconds from the same IP address.' => 'Si se realizzan [_1] o más intentos de inicio de sesión en menos de [_2] segundos desde la misma dirección IP, se bloqueará la dirección IP.',
	'Base Site Path' => 'Ruta base del sitio',
	'Changing image quality' => 'Cambiando la calidad de la imagen',
	'Clear' => 'Limpiar',
	'Debug Mode' => 'Modo de depuración',
	'Disable comments for all sites and child sites.' => 'Deshabilitar los comentarios en todos los sitios y sitios hijos.',
	'Disable notification pings for all sites and child sites.' => 'Deshabilitar los pings de notificación en todos los sitios y sitios hijos.',
	'Disable receipt of TrackBacks for all sites and child sites.' => 'Deshabilitar la recepción de TrackBacks en todos los sitios y sitios hijos.',
	'Do not send outbound TrackBacks or use TrackBack auto-discovery if your installation is intended to be private.' => 'No enviar TrackBacks salientes ni usar el autodescubrimiento de TrackBacks si predente que la instalación sea privada.',
	'Enable image quality changing.' => 'Activar cambio de calidad de imágenes.',
	'IP address lockout policy' => 'Política de bloqueo de direcciones IP.',
	'Image Quality Settings' => 'Configuración de la calidad de las imágenes',
	'Image quality of uploaded JPEG image and its thumbnail. This value can be set an integer value between 0 and 100. Default value is 85.' => 'La calidad de las imágenes JPEG y sus miniaturas. Este valor puede ser un entero entre 0 y 100. El valor por defecto es 85.',
	'Image quality of uploaded PNG image and its thumbnail. This value can be set an integer value between 0 and 9. Default value is 7.' => 'La calidad de las imágenes PNG y sus miniaturas. Este valor puede ser un entero entre 0 y 9. El valor por defecto es 7.',
	'Image quality(JPEG)' => 'Calidad de imagen (JPEG)',
	'Image quality(PNG)' => 'Calidad de imagen (PNG)',
	'Imager does not support ImageQualityPng.' => 'El gestor de imágenes no soporta ImageQualityPng.',
	'Lockout Settings' => 'Configuración de bloqueos',
	'Log Path' => 'Ruta de históricos',
	'Logging Threshold' => 'Umbral de histórico',
	'One or more of your sites or child sites are not following the base site path (value of BaseSitePath) restriction.' => 'Uno o más de los sitios o sitios hijos no cumplen la restricción de la ruta base del sitio (valor de BaseSitePath).',
	'Only to child sites within this system' => 'Sólo a los sitios hijos de este sistema.',
	'Only to sites on the following domains:' => 'Sólo a los sitios en los siguientes dominios:',
	'Outbound Notifications' => 'Notificaciones salientes',
	'Performance Logging' => 'Histórico de rendimiento',
	'Prohibit Comments' => 'Prohibir comentarios',
	'Prohibit Notification Pings' => 'Prohibir los pings de notificación',
	'Prohibit TrackBacks' => 'Prohibir TrackBacks',
	'Send Mail To' => 'Enviar correo a',
	'Send Outbound TrackBacks to' => 'Enviar TrackBacks salientes a',
	'Send Test Mail' => 'Enviar correo de prueba',
	'Send' => 'Enviar',
	'Site Path Limitation' => 'Limitación de la ruta del sitio',
	'System Email Address' => 'Dirección de correo del sistema',
	'System-wide Feedback Controls' => 'Controles de las respuestas a nivel del sistema',
	'The email address that should receive a test email from Movable Type.' => 'La direción de correo que debe recibir el correo de prueba de Movable Type.',
	'The filesystem directory where performance logs are written.  The web server must have write permission in this directory.' => 'El directorio del sistema de ficheros donde se escriben los históricos de rendimiento. El servidor web debe poder escribir en este directorio.',
	'The list of IP addresses. If a remote IP address is included in this list, the failed login will not recorded. You can specify multiple IP addresses separated by commas or line breaks.' => 'La lista de direcciones IP. El inicio de sesión no será registrado si la dirección IP remota está incluída en esta lista. Puede especificar múltiples direcciones IP separadas por comas o saltos de línea.',
	'The time limit for unlogged events in seconds. Any event that takes this amount of time or longer will be reported.' => 'El tiempo límite para los eventos no registrados, en segundos. Se informará de cualquier evento que tome esta cantidad de tiempo o mayor.',
	'Track revision history' => 'Seguir histórico de revisiones',
	'Turn on performance logging' => 'Activar registro de rendimiento',
	'Turn on performance logging, which will report any system event that takes the number of seconds specified by Logging Threshold.' => 'Active el registro de rendimiento, que informará sobre cualquier evento del sistema que tome el número de segundos especificados por la Umbral de registro.',
	'User lockout policy' => 'Política de bloqueo de usuarios',
	'Values other than zero provide additional diagnostic information for troubleshooting problems with your Movable Type installation.  More information is available in the <a href="https://www.movabletype.org/documentation/develooper/plugins/debug-mode.html">Debug Mode documentation</a>.' => 'Los valores diferentes de cero proveen información adicional de diagnóstico para resolver problemas con la instalación de Movable Type. Más información disponible en la <a href="https://www.movabletype.org/documentation/develooper/plugins/debug-mode.html">documentación del módulo de depuración</a>.',
	'You must set a valid absolute Path.' => 'Debe indicar una ruta absoluta válida.',
	'You must set an integer value between 0 and 100.' => 'Debe indicar un valor entero entre 0 y 100.',
	'You must set an integer value between 0 and 9.' => 'Debe indicar un valor entero entre 0 y 9.',
	'Your settings have been saved.' => 'Configuración guardada.',
	q{However, the following IP addresses are 'whitelisted' and will never be locked out:} => q{Sin embargo, las siguientes direcciones IP están en una 'lista blanca' y nunca serán bloqueadas:},
	q{The system administrators whom you wish to notify if a user or an IP address is locked out.  If no administrators are selected, notifications will be sent to the 'System Email' address.} => q{Los administradores del sistema a quienes desee notificar los bloqueos de usuarios y direcciones IP. Si no hay administradores seleccionados, se enviarán las notificaciones a la dirección del 'Correo del sistema'.},
	q{This email address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events.} => q{Esta dirección de correo se utiliza en la cabecera 'From:' de los correos enviados por Movable Type. Se puede enviar correo por recuperación de contraseña, registro de comentaristas, notificación de nuevos comentarios y TrackBacks, bloqueo de usuarios o IPs, y por otros eventos menores.},

## tmpl/cms/cfg_system_users.tmpl
	'Allow Registration' => 'Permitir registro',
	'Allow commenters to register on this system.' => 'Permitir a los comentaristas registrarse en el sistema.',
	'Comma' => 'Coma',
	'Default Tag Delimiter' => 'Delimitador de etiquetas predefinido',
	'Default Time Zone' => 'Zona horaria predefinida',
	'Default User Language' => 'Idioma del usuario',
	'Minimum Length' => 'Longitud mínima',
	'New User Defaults' => 'Valores predefinidos para los nuevos usuarios',
	'Note: System Email Address is not set in System > General Settings. Emails will not be sent.' => 'Nota: La dirección de correo del sistema no está configurada en Sistema > Configuración general. Los mensajes no se enviarán.',
	'Notify the following system administrators when a commenter registers:' => 'Notificar a los siguientes administradores del sistema el registro de comentaristas:',
	'Options' => 'Opciones',
	'Password Validation' => 'Comprobación de clave',
	'Select system administrators' => 'Seleccione los administradores de sistemas',
	'Should contain letters and numbers.' => 'Debe contener letras y números.',
	'Should contain special characters.' => 'Debe contener caracteres especiales.',
	'Should contain uppercase and lowercase letters.' => 'Debe contener letras en mayúsculas y minúsculas.',
	'Space' => 'Espacio',
	'This field must be a positive integer.' => 'Este campo debe ser un positivo entero.',

## tmpl/cms/cfg_web_services.tmpl
	'(Separate URLs with a carriage return.)' => '(Separe las URLs con un retorno de carro.)',
	'Data API Settings' => 'Configuración de Data API',
	'Data API' => 'Data API',
	'Enable Data API in system scope.' => 'Activar Data API en todo el sistema.',
	'Enable Data API in this site.' => 'Activar Data API en este sitio.',
	'External Notifications' => 'Notificaciones externas',
	'Note: This option is currently ignored because outbound notification pings are disabled system-wide.' => 'Nota: Actualmente se ignora esta opción debido a que los pings de notificación salientes están desactivados a nivel del sistema.',
	'Notify ping services of [_1] updates' => 'Notificar a los servicios de ping [_1] actualizaciones',
	'Others:' => 'Otros:',

## tmpl/cms/content_data/select_list.tmpl
	'No Content Type.' => 'Sin tipo de contenido.',
	'Select List Content Type' => 'Seleccionar tipo de contenido lista',

## tmpl/cms/content_field_type_options/asset.tmpl
	'Allow users to select multiple assets?' => '¿Permitir a los usuarios seleccionar múltiples ficheros multimedia?',
	'Allow users to upload a new asset?' => '¿Permitir a los usuarios transferir un nuevo fichero multimedia?',
	'Maximum number of selections' => 'Número máximo de selecciones',
	'Minimum number of selections' => 'Número mínimo de selecciones',

## tmpl/cms/content_field_type_options/asset_audio.tmpl
	'Allow users to upload a new audio asset?' => '¿Permitir a los usuarios transferir un audio nuevo?',

## tmpl/cms/content_field_type_options/asset_image.tmpl
	'Allow users to select multiple image assets?' => '¿Permitir a los usuarios seleccionar múltiples ficheros de imagen?',
	'Allow users to upload a new image asset?' => '¿Permitir a los usuarios transferir una imagen nueva?',

## tmpl/cms/content_field_type_options/asset_video.tmpl
	'Allow users to select multiple video assets?' => '¿Permitir a los usuarios seleccionar múltiples ficheros de vídeo?',
	'Allow users to upload a new video asset?' => '¿Permitir a los usuarios transferir un nuevo fichero de vídeo?',

## tmpl/cms/content_field_type_options/categories.tmpl
	'Allow users to create new categories?' => '¿Permitir a los usuarios crear nuevas categorías?',
	'Allow users to select multiple categories?' => '¿Permitir a los usuarios seleccionar múltiples categorías?',
	'Source Category Set' => 'Conjunto de categorías origen',

## tmpl/cms/content_field_type_options/checkboxes.tmpl
	'Selected' => 'Seleccionado',
	'Value' => 'Valor',
	'Values' => 'Valores',
	'add' => 'Crear',

## tmpl/cms/content_field_type_options/content_type.tmpl
	'Allow users to select multiple values?' => '¿Permitir a los usuarios seleccionar múltiples valores?',
	'Source Content Type' => 'Tipo de contenido origen',
	'There is no content type that can be selected. Please create a content type if you use the Content Type field type.' => 'No hay ningún tipo de contenido que se pueda seleccionar. Por favor, cree un nuevo tipo de contenido si usa el tipo de campo Tipo de contenido.',

## tmpl/cms/content_field_type_options/date.tmpl
	'Initial Value' => 'Valor inicial',

## tmpl/cms/content_field_type_options/date_time.tmpl
	'Initial Value (Date)' => 'Valor inicial (fecha)',
	'Initial Value (Time)' => 'Valor inicial (hora)',

## tmpl/cms/content_field_type_options/multi_line_text.tmpl
	'Input format' => 'Formato de entrada',
	'Use all rich text decoration buttons' => '', # Translate - New

## tmpl/cms/content_field_type_options/number.tmpl
	'Max Value' => 'Valor max',
	'Min Value' => 'Valor min',
	'Number of decimal places' => 'Número de decimales',

## tmpl/cms/content_field_type_options/single_line_text.tmpl
	'Max Length' => 'Longitud max',
	'Min Length' => 'Longitud min',

## tmpl/cms/content_field_type_options/tables.tmpl
	'Allow users to increase/decrease cols?' => '¿Permitir a los usuarios incrementar/disminuir las columnas?',
	'Allow users to increase/decrease rows?' => '¿Permitir a los usuarios incrementar/disminuir las filas?',
	'Initial Cols' => 'Columnas iniciales',
	'Initial Rows' => 'Filas iniciales',

## tmpl/cms/content_field_type_options/tags.tmpl
	'Allow users to create new tags?' => '¿Permitir a los usuarios crear nuevas etiquetas?',
	'Allow users to input multiple values?' => '¿Permitir a los usuarios introducir múltiples valores?',

## tmpl/cms/content_field_type_options/text_label.tmpl
	'This block is only visible in the administration screen for comments.' => '', # Translate - New
	'__TEXT_LABEL_TEXT' => '', # Translate - New

## tmpl/cms/dashboard/dashboard.tmpl
	'Dashboard' => 'Panel de Control',
	'Select a Widget...' => 'Seleccione un widget...',
	'System Overview' => 'Resumen del sistema',
	'Your Dashboard has been updated.' => 'Se ha actualizado el Panel de Control.',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Back (b)' => 'Volver (b)',
	'Confirm Publishing Configuration' => 'Confirmar configuración de publicación',
	'Continue (s)' => 'Continuar (s)',
	'Enter the new URL of the archives section of your child site. Example: http://www.example.com/blog/archives/' => 'Introduzca la nueva URL de la sección de archivos para el sitio hijo. Ejemplo: http://www.ejemplo.com/blog/archivos/',
	'Please choose parent site.' => 'Por favor, seleccione el sitio padre.',
	'Site Path' => 'Ruta del sitio',
	'You must select a parent site.' => 'Debe seleccionar un sitio padre.',
	'You must set a valid Site URL.' => 'Debe establecer una URL de sitio válida.',
	'You must set a valid local site path.' => 'Debe establecer una ruta local de sitio válida.',
	q{Enter the new URL of your public child site. End with '/'. Example: http://www.example.com/blog/} => q{Introduzca la nueva URL para el sitio hijo público. Termine con '/'. Ejemplo: http://www.ejemplo.com/blog/},
	q{Enter the new path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Introduzca la ruta de localización de los ficheros índice de la sección de archivos. Se recomienda una ruta absoluta (que en Linux comienza con '\' y en Windows con 'C:\'). No terminar con '/' o '\'. Ejemplo: /home/mt/public_html/blog/ o C:\www\public_html\blog},
	q{Enter the new path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Introduzca la ruta de localización de los ficheros índice de la sección de archivos. No terminar con '/' o '\'. Ejemplo: /home/mt/public_html/blog/ o C:\www\public_html\blog},
	q{Enter the new path where your main index file will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Introduzca la ruta de localización del fichero índice principal. No terminar con '/' o '\'. Ejemplo: /home/mt/public_html/blog/ o C:\www\public_html\blog},
	q{Enter the new path where your main index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Introduzca la ruta de localización del fichero índice principal. Se recomienda una ruta absoluta (que en Linux comienza con '\' y en Windows con 'C:\'). No terminar con '/' o '\'. Ejemplo: /home/mt/public_html/blog/ o C:\www\public_html\blog},

## tmpl/cms/dialog/asset_edit.tmpl
	'An error occurred.' => 'Ocurrió un error.',
	'Close (x)' => 'Cerrar (x)',
	'Edit Asset' => 'Editar multimedia',
	'Edit Image' => 'Editar imagen',
	'Error creating thumbnail file.' => 'Error creando el fichero de la miniatura.',
	'File Size' => 'Tamaño de la imagen',
	'Metadata cannot be updated because Metadata in this image seems to be broken.' => 'No se pudo actualizar los metadatos por que esta imagen parece estar rota.',
	'Save changes to this asset (s)' => 'Guardar cambios de este fichero multimedia (s)',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to close this dialog?' => 'Los cambios no guardados a este fichero multimedia se perderán. ¿Estará seguro de que desea cerrar este diálogo?',
	'Your changes have been saved.' => 'Sus cambios han sido guardados.',
	'Your edited image has been saved.' => 'La imagen editada ha sido guardada.',

## tmpl/cms/dialog/asset_modal.tmpl
	'Add Assets' => 'Añadir multimedia',
	'Cancel (x)' => 'Cancelar (x)',
	'Choose Asset' => 'Seleccionar multimedia',
	'Insert (s)' => 'Insertar (s)',
	'Insert' => 'Insertar',
	'Library' => 'Biblioteca',
	'Next (s)' => 'Siguiente (s)',

## tmpl/cms/dialog/asset_options.tmpl
	'Create a new entry using this uploaded file.' => 'Crear una nueva entrada usando el fichero transferido.',
	'Create entry using this uploaded file' => 'Crear entrada utilizando el fichero transferido',
	'File Options' => 'Opciones de ficheros',
	'Finish (s)' => 'Finalizar (s)',
	'Finish' => 'Finalizar',

## tmpl/cms/dialog/asset_upload.tmpl
	'You need to configure your blog.' => 'Debe configurar el blog.',
	'Your blog has not been published.' => 'Su blog no ha sido publicado.',

## tmpl/cms/dialog/clone_blog.tmpl
	'Categories/Folders' => 'Categorías/carpetas',
	'Child Site Details' => 'Detalles del sitio hijo',
	'Clone' => 'Clonar',
	'Confirm' => 'Confirmar',
	'Entries/Pages' => 'Entradas/páginas',
	'Exclude Categories/Folders' => 'Excluir categorías/carpetas',
	'Exclude Comments' => 'Excluir comentarios',
	'Exclude Entries/Pages' => 'Excluir entradas/páginas',
	'Exclude Trackbacks' => 'Excluir trackbacks',
	'Exclusions' => 'Exclusiones',
	'This is set to the same URL as the original child site.' => 'Se le establece la misma URL que el sitio hijo original.',
	'This will overwrite the original child site.' => 'Esto sobreescribirá el sitio hijo original.',
	'Warning: Changing the archive URL can result in breaking all links in your child site.' => 'Aviso: El cambio de la URL de los archivos puede romper todos los enlaces del sitio hijo.',
	'Warning: Changing the archive path can result in breaking all links in your child site.' => 'Aviso: El cambio de la ruta de los archivos puede romper todos los enlaces en el sitio hijo.',

## tmpl/cms/dialog/comment_reply.tmpl
	'On [_1], [_2] commented on [_3]' => 'En [_1], [_2] comentó en [_3]',
	'Reply to comment' => 'Responder al comentario',
	'Submit reply (s)' => 'Enviar respuesta (s)',
	'Your reply:' => 'Su respuesta:',

## tmpl/cms/dialog/content_data_modal.tmpl
	'Add [_1]' => 'Añadir [_1]',
	'Choose [_1]' => 'Seleccionar [_1]',
	'Create and Insert' => 'Crear e insertar',

## tmpl/cms/dialog/create_association.tmpl
	'No blogs exist in this installation. [_1]Create a blog</a>' => 'Ningún blog existe en esta instalación. [_1]Crear un blog</a>',
	'No groups exist in this installation. [_1]Create a group</a>' => 'Ningún grupo existe en esta instalación. [_1]Crear un grupo</a>',
	'No roles exist in this installation. [_1]Create a role</a>' => 'Ningún rol existe en esta instalación. [_1]Crear un rol</a>',
	'No sites exist in this installation. [_1]Create a site</a>' => 'Ningún sitio existe en esta instalación. [_1]Crear un sitio</a>',
	'No users exist in this installation. [_1]Create a user</a>' => 'Ningún usuario existe en esta instalación. [_1]Crear un usuario</a>',
	'all' => 'Todos',

## tmpl/cms/dialog/create_trigger.tmpl
	'Event' => 'Evento',
	'IF <span class="badge source-data-badge">Data</span> in <span class="badge source-site-badge">Site</span> is <span class="badge source-trigger-badge">Triggered</span>, <span class="badge destination-action-badge">Action</span> in <span class="badge destination-site-badge">Site</span>' => 'Si <span class="badge source-data-badge">Datos</span> en <span class="badge source-site-badge">Sitio</span> es <span class="badge source-trigger-badge">Inducido</span>, <span class="badge destination-action-badge">Acción</span> en <span class="badge destination-site-badge">Sitio</span>',
	'OK (s)' => 'Aceptar (s)',
	'OK' => 'Aceptar',
	'Object Name' => 'Nombre del objeto',
	'Select Trigger Action' => 'Seleccione acción inductora',
	'Select Trigger Event' => 'Seleccione evento inductor',
	'Select Trigger Object' => 'Seleccioe el objecto inductor',

## tmpl/cms/dialog/edit_image.tmpl
	'Crop' => 'Recortar',
	'Flip horizontal' => 'Reflejar horizontal',
	'Flip vertical' => 'Reflejar vertical',
	'Height' => 'Largo',
	'Keep aspect ratio' => 'Mantener proporción',
	'Redo' => 'Rehacer',
	'Remove All metadata' => 'Borrar metadatos',
	'Remove GPS metadata' => 'Borrar datos GPS',
	'Rotate left' => 'Rotar derecha',
	'Rotate right' => 'Rotar izquierda',
	'Save (s)' => 'Guardar (s)',
	'Undo' => 'Deshacer',
	'Width' => 'Ancho',
	'You have unsaved changes to this image that will be lost. Are you sure you want to close this dialog?' => 'Los cambios no guardados de esta imagen se perderán. ¿Está seguro de que desea cerrar este diálogo?',

## tmpl/cms/dialog/entry_notify.tmpl
	'(Body will be sent without any text formatting applied.)' => '(El cuerpo se enviará sin que se aplique ningún formato de texto).',
	'All addresses from Address Book' => 'Todas las direcciones de la agenda',
	'Enter email addresses on separate lines or separated by commas.' => 'Introduzca las direcciones de correo en líneas separadas o separadas por comas.',
	'Optional Content' => 'Contenido opcional',
	'Optional Message' => 'Mensaje opcional',
	'Recipients' => 'Destinatarios',
	'Send a Notification' => 'Enviar una notificación',
	'Send notification (s)' => 'Enviar notificación (s)',
	'You must specify at least one recipient.' => 'Debe especificar al menos un destinatario.',
	q{Your [_1]'s name, title, and a link to view it will be sent in the notification. Additionally, you can add a message, include an excerpt and/or send the entire body.} => q{En la notificación se enviará el nombre de su [_1], el título y un enlace para verla. Además, puede añadir un mensaje, incluir el resumen y/o enviar el cuerpo completo.},

## tmpl/cms/dialog/list_revision.tmpl
	'Select the revision to populate the values of the Edit screen.' => 'Seleccione la revisión para poblar los valores en la plantalla de Edición.',

## tmpl/cms/dialog/move_blogs.tmpl
	'Warning: You need to copy uploaded assets to the new path manually. It is also recommended not to delete files in the old path to avoid broken links.' => 'Aviso: Deberá copiar manualmente los ficheros multimedia subidos a la nueva ruta. También es recomendable que no borre los ficheros en la ruta antigua para evitar romper enlaces.',

## tmpl/cms/dialog/multi_asset_options.tmpl
	'Display [_1]' => 'Mostrar [_1]',
	'Insert Options' => 'Configuración de inserción',

## tmpl/cms/dialog/new_password.tmpl
	'Change Password' => 'Cambiar Contraseña',
	'Change' => 'cambiar',
	'Confirm New Password' => 'Confirmar nueva contraseña',
	'Enter the new password.' => 'Introduzca la nueva contraseña.',
	'New Password' => 'Nueva contraseña',
	'The password for the user \'[_1]\' has been recovered.' => '', # Translate - New

## tmpl/cms/dialog/publishing_profile.tmpl
	'All templates published statically via Publish Queue.' => 'Todas las plantillas publicadas estáticamente via Cola de publicación',
	'Are you sure you wish to continue?' => '¿Está seguro de que desea continuar?',
	'Background Publishing' => 'Publicación en segundo plano',
	'Choose the profile that best matches the requirements for this [_1].' => 'Seleccione el perfil que mejor se ajuste a los requerimientos para [_1].',
	'Dynamic Archives Only' => 'Solo archivos dinámicos',
	'Dynamic Publishing' => 'Publicación dinámica',
	'Execute' => '', # Translate - New
	'High Priority Static Publishing' => 'Publicación estática de alta prioridad',
	'Immediately publish Main Index and Feed template, Entry archives, Page archives and ContentType archives statically. Use Publish Queue to publish all other templates statically.' => '', # Translate - New
	'Immediately publish all templates statically.' => 'Publicar inmediatamente todas las plantillas de forma estática.',
	'Publish all Archive templates dynamically. Immediately publish all other templates statically.' => 'Publicar todos las plantillas de archivos dinámicamente. Publicar de forma inmediata el resto de plantillas estáticamente.',
	'Publish all templates dynamically.' => 'Publicar todas las plantillas dinámicamente.',
	'Publishing Profile' => 'Perfil de publicación',
	'Static Publishing' => 'Publicación estática',
	'This new publishing profile will update your publishing settings.' => 'Este nuevo perfil de publicación actualizará la configuración de publicación.',
	'child site' => 'Sitio hijo',
	'site' => 'Sitio',

## tmpl/cms/dialog/recover.tmpl
	'Back (x)' => 'Volver (x)',
	'Reset (s)' => 'Reiniciar (s)',
	'Reset Password' => 'Reiniciar la contraseña',
	'Sign in to Movable Type (s)' => 'Identifíquese en Movable Type (s)',
	'Sign in to Movable Type' => 'Identifíquese en Movable Type',
	'The email address provided is not unique.  Please enter your username.' => 'El correo no es único. Por favor, introduzca el usuario.',

## tmpl/cms/dialog/refresh_templates.tmpl
	'Cannot find template set. Please apply [_1]theme[_2] to refresh your templates.' => 'No se pudo encontrar el conjunto de plantillas. Por favor, aplique un [_1]tema[_2] para refrescar las plantillas.',
	'Deletes all existing templates and installs factory default template set.' => 'Borra todas las plantillas existentes e instala el conjunto de plantillas predefinido.',
	'Make backups of existing templates first' => 'Primero, haga copias de seguridad de las plantillas',
	'Refresh Global Templates' => 'Recargar plantillas globales',
	'Refresh global templates' => 'Recargar plantillas globales',
	'Reset to factory defaults' => 'Valores de fábrica',
	'Reset to theme defaults' => 'Reiniciar a los valores predefinidos del tema',
	'Revert modifications of theme templates' => 'Deshacer modificaciones en las plantillas de los temas',
	'Updates current templates while retaining any user-created templates.' => 'Actualiza las plantillas actuales pero mantiene las plantillas creadas por el usuario.',
	'You have requested to <strong>apply a new template set</strong>. This action will:' => 'Ha solicitado <strong>aplicar un nuevo conjunto de plantillas</strong>. Esta acción:',
	'You have requested to <strong>refresh the current template set</strong>. This action will:' => 'Ha solicitado <strong>refrescar el actual conjunto de plantillas</strong>. Esta acción:',
	'You have requested to <strong>refresh the global templates</strong>. This action will:' => 'Ha solicitado <strong>recargar ñas plantillas globales</strong>. Esta acción:',
	'You have requested to <strong>reset to the default global templates</strong>. This action will:' => 'Ha solicitado <strong>reinicializar a las plantillas globales predefinidas</strong>. Esta acción:',
	'delete all of the templates in your blog' => 'borrará todas las plantillas del blog',
	'delete all of your global templates' => 'borrará todas las plantillas globales',
	'install new templates from the default global templates' => 'instalará nuevas plantillas con las plantillas globales predefinidas',
	'install new templates from the selected template set' => 'instalará nuevas plantillas del conjunto seleccionado',
	'make backups of your templates that can be accessed through your backup filter' => 'realizará copia de seguridad de las plantillas accesibles a través del filtro de copias de seguridad',
	'overwrite some existing templates with new template code' => 'reescribirá algunas plantillas existentes con el código de las nuevas plantillas',
	'potentially install new templates' => 'instalará potencialmente nuevas plantillas',
	q{Deletes all existing templates and install the selected theme's default.} => q{Borra todas las plantillas existentes e instala las predefinidas por el tema seleccionado.},

## tmpl/cms/dialog/restore_end.tmpl
	'All data imported successfully!' => '¡Importados con éxito todos los datos!',
	'An error occurred during the import process: [_1] Please check your import file.' => 'Ocurrió un error durante el proceso de importación: [_1] Por favor, revise el fichero de importación.',
	'Close (s)' => 'Cerrado (s)',
	'Next Page' => 'Página siguiente',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => 'La página le redireccionará a una nueva en 3 segundos. [_1]Parar la redirección.[_2]',
	'View Activity Log (v)' => 'Mostrar registro de actividad (v)',

## tmpl/cms/dialog/restore_start.tmpl
	'Importing...' => 'Importando...',

## tmpl/cms/dialog/restore_upload.tmpl
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => 'La cancelación del proceso creará objetos huérfanos. ¿Está seguro de que desea cancelar la operación de restauración?',
	'Please upload the file [_1]' => 'Por favor, suba el fichero [_1]',
	'Restore: Multiple Files' => 'Restaurar: Múltiples ficheros',

## tmpl/cms/dialog/select_association_type.tmpl
	'Grant site permission to group' => 'Otorgar permiso sobre sitio a grupo',
	'Grant site permission to user' => 'Otorgar permiso sobre sitio a usuario',

## tmpl/cms/edit_asset.tmpl
	'Appears in...' => 'Aparece en...',
	'Embed Asset' => 'Embeber fichero multimedia',
	'Prev' => 'Anterior',
	'Related Assets' => 'Ficheros multimedia relacionados',
	'Stats' => 'Estadísticas',
	'This asset has been used by other users.' => 'Este fichero multimedia ha sido utilizado por otros usuarios.',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to edit image?' => 'Los cambios no guardados a este fichero multimedia se perderán. ¿Está seguro de que desea editar la imagen?',
	'You have unsaved changes to this asset that will be lost.' => 'Los cambios no guardados a este fichero multimedia se perderán.',
	'You must specify a name for the asset.' => 'Debe especificar un nombre para el fichero multimedia.',
	'[_1] - Created by [_2]' => '[_1] - Creado por [_2]',
	'[_1] - Modified by [_2]' => '[_1] - Modificado por [_2]',
	'[_1] is missing' => '[_1] no existe',

## tmpl/cms/edit_author.tmpl
	'(Use Site Default)' => '(Usar valor predeterminado del sitio)',
	'A new password has been generated and sent to the email address [_1].' => 'Se ha generado y enviado a la dirección de correo electrónico [_1] una nueva contraseña.',
	'Confirm Password' => 'Confirmar contraseña',
	'Create User (s)' => 'Crear usuario (s)',
	'Current Password' => 'Contraseña actual',
	'Date Format' => 'Formato de fechas',
	'Default date formatting in the Movable Type interface.' => 'El formato predefinido de fechas en Movable Type.',
	'Default text formatting filter when creating new entries and new pages.' => 'Filtro predefinido para el formato de texto de las nuevas entradas y páginas.',
	'Display language for the Movable Type interface.' => 'Idioma para el interfaz de Movable Type.',
	'Edit Profile' => 'Editar Perfil',
	'Enter preferred password.' => 'Introduzca la contraseña elegida.',
	'Error occurred while removing userpic.' => 'Ocurrió un error durante la eliminación del avatar.',
	'External user ID' => 'ID usuario externo',
	'Full' => 'Completo',
	'Initial Password' => 'Contraseña inicial',
	'Initiate Password Recovery' => 'Iniciar recuperación de contraseña',
	'Password recovery word/phrase' => 'Palabra/frase para la recuperación de contraseña',
	'Preferences' => 'Preferencias',
	'Preferred method of separating tags.' => 'Método preferido de separación de etiquetas.',
	'Relative' => 'Relativo',
	'Remove Userpic' => 'Borrar avatar',
	'Reveal' => 'Mostrar',
	'Save changes to this author (s)' => 'Guardar cambios de este autor (s)',
	'Select Userpic' => 'Seleccionar avatar',
	'System Permissions' => 'Permisos del sistema',
	'Tag Delimiter' => 'Delimitador de etiquetas',
	'Text Format' => 'Formato de texto',
	'The name displayed when content from this user is published.' => 'El nombre mostrado cuando se publica contenidos de este usuario.',
	'This profile has been unlocked.' => 'Este perfil ha sido desbloqueado.',
	'This profile has been updated.' => 'Este perfil ha sido actualizado.',
	'This user was classified as disabled.' => 'Este usuario está clasificado como deshabilitado.',
	'This user was classified as pending.' => 'Este usuario está clasificado como pendiente.',
	'This user was locked out.' => 'Este usuario ha sido bloqueado.',
	'User properties' => 'Propiedades del usuario',
	'Web Services Password' => 'Contraseña de servicios web',
	'You must use half-width character for password.' => 'Debe usar caracteres de media-anchura para la contraseña.',
	'Your web services password is currently' => 'Actualmente la contraseña de los servicios web es',
	'_USAGE_PASSWORD_RESET' => 'Puede iniciar la recuperación de la contraseña en nombre de este usuario. Si lo hace, se enviará un correo a <strong>[_1]</strong> con una nueva contraseña aleatoria.',
	'_USER_DISABLED' => 'Deshabilitado',
	'_USER_ENABLED' => 'Habilitado',
	'_USER_PENDING' => 'Pendiente',
	'_USER_STATUS_CAPTION' => 'Estado',
	'_WARNING_PASSWORD_RESET_SINGLE' => 'Va a reiniciar la contraseña de "[_1]". Se enviará una nueva contraseña aleatoria que se enviará directamente a su dirección de correo electrónico ([_2]). ¿Desea continuar?',
	q{If you want to unlock this user click the 'Unlock' link. <a href="[_1]">Unlock</a>} => q{Si desea desbloquear a este usuario, haga clic en el enlace 'Desbloquear'. <a href="[_1]">Desbloquear</a>},
	q{This User's website (e.g. https://www.movabletype.com/).  If the Website URL and Display Name fields are both populated, Movable Type will by default publish entries and comments with bylines linked to this URL.} => q{El sitio web del usuario (p.e. https://www.movabletype.com/).  Si la URL del sitio web y el Nombre público tienen valor, Movable Type publicará por defecto las entradas y comentarios con enlaces a esta URL.},

## tmpl/cms/edit_blog.tmpl
	'Create Child Site (s)' => 'Crear sitio hijo (s)',
	'Enter the URL of your Child Site. Exclude the filename (i.e. index.html). Example: http://www.example.com/blog/' => 'Introduzca la URL del sitio hijo. No incluya el nombre del fichero (p.e. index.html). Ejemplo: http://www.ejemplo.com/blog/',
	'Name your child site. The site name can be changed at any time.' => 'Déle un nombre al sitio hijo. El nombre se puede cambiar en cualquier momento.',
	'Select the theme you wish to use for this child site.' => 'Seleccione el tema que desea usar para este sitio hijo.',
	'Select your timezone from the pulldown menu.' => 'Seleccione su zona horaria en el menú desplegable.',
	'Site Theme' => 'Tema del sitio',
	'You must set your Local Site Path.' => 'Debe definir la ruta local de su sitio.',
	'Your child site configuration has been saved.' => 'Se ha guardado la configuración del sitio hijo.',
	q{The path where your index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{La ruta de localización de los ficheros índice. Se recomienda una ruta absolut (que en Linux comienza con '/' y en Windows con 'C:\'). No terminar con '/' o '\'. Ejemplo: /home/mt/public_html/blog o C:\www\public_html\blog},
	q{The path where your index files will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{La ruta de localización de los ficheros índice. No terminar con '/' o '\'. Ejemplo: /home/mt/public_html/blog o C:\www\public_html\blog},

## tmpl/cms/edit_category.tmpl
	'Allow pings' => 'Permitir pings',
	'Edit Category' => 'Editar categoría',
	'Inbound TrackBacks' => 'TrackBacks entradas',
	'Manage entries in this category' => 'Administrar las entradas de esta categorías',
	'Outbound TrackBacks' => 'TrackBacks salientes',
	'Passphrase Protection' => 'Protección por contraseña',
	'Please enter a valid basename.' => 'Por favor, introduzca un nombre base válido.',
	'Save changes to this category (s)' => 'Guardar cambios de esta categoría (s)',
	'This is the basename assigned to your category.' => 'El nombre base asignado a la categoría.',
	'TrackBack URL for this category' => 'URL de TrackBack para esta categoría',
	'Trackback URLs' => 'URLs de Trackback',
	'Useful links' => 'Enlaces útiles',
	'View TrackBacks' => 'Ver TrackBacks',
	'You must specify a basename for the category.' => 'Debe especificar un nombre base para la categoría.',
	'You must specify a label for the category.' => 'Debe especificar un título para la categoría.',
	'_CATEGORY_BASENAME' => 'Nombre base',
	q{Warning: Changing this category's basename may break inbound links.} => q{Cuidado: Cambiar el nombre base de la categoría podría romper los enlaces entrantes.},

## tmpl/cms/edit_comment.tmpl
	'Ban Commenter' => 'Bloquear Comentarista',
	'Comment Text' => 'Comentario',
	'Commenter Status' => 'Estado comentarista',
	'Delete this comment (x)' => 'Borrar este comentario (x)',
	'Manage Comments' => 'Administrar comentarios',
	'No url in profile' => 'Sin URL en el perfil',
	'Reply to this comment' => 'Responder al comentario',
	'Reported as Spam' => 'Marcado como spam',
	'Responses to this comment' => 'Respuestas al comentario',
	'Results' => 'Resultados',
	'Save changes to this comment (s)' => 'Guardar cambios de este comentario (s)',
	'Score' => 'Puntuación',
	'Test' => 'Test',
	'The comment has been approved.' => 'Se ha aprobado el comentario.',
	'This comment was classified as spam.' => 'Se ha clasificado el comentario como basura.',
	'Total Feedback Rating: [_1]' => 'Puntuación total de respuestas: [_1]',
	'Trust Commenter' => 'Comentados Fiable',
	'Trusted' => 'De confianza',
	'Unavailable for OpenID user' => 'No disponible para los usuarios de OpenID',
	'Unban Commenter' => 'Desbloquear Comentarista',
	'Untrust Commenter' => 'Comentarista no fiable',
	'View [_1] comment was left on' => 'Ver comentario de [_1] que se realizó en',
	'View all comments by this commenter' => 'Ver todos los comentarios de este comentarista',
	'View all comments created on this day' => 'Ver todos los comentarios creados este día',
	'View all comments from this IP Address' => 'Ver todos los comentarios procedentes de esta dirección IP',
	'View all comments on this [_1]' => 'Ver todos los comentario en este [_1]',
	'View all comments with this URL' => 'Ver todos los comentarios con esta URL',
	'View all comments with this email address' => 'Ver todos los comentarios de esta dirección de correo-e',
	'View all comments with this status' => 'Ver comentarios con este estado',
	'View this commenter detail' => 'Ver detalles de este comentarista',
	'[_1] no longer exists' => '[_1] no existe más largo',
	'_external_link_target' => '_blank',
	'comment' => 'comentario',
	'comments' => 'comentarios',

## tmpl/cms/edit_commenter.tmpl
	'Authenticated' => 'Autentificado',
	'Ban user (b)' => 'Bloquear usuario (b)',
	'Ban' => 'Bloquear',
	'Comments from [_1]' => 'Comentarios de [_1]',
	'Identity' => 'Identidad',
	'The commenter has been banned.' => 'Se bloqueó al comentarista.',
	'The commenter has been trusted.' => 'El comentarista ahora es de confianza.',
	'Trust user (t)' => 'Confiar en usuario (t)',
	'Trust' => 'Confianza',
	'Unban user (b)' => 'Desbloquear usuario (b)',
	'Unban' => 'Desbloquear',
	'Untrust user (t)' => 'Desconfiar del usuario (t)',
	'Untrust' => 'Desconfiar',
	'View all comments with this name' => 'Mostrar todos los comentarios con este nombre',
	'View' => 'Ver',
	'Withheld' => 'Retener',
	'commenter' => 'comentarista',
	'commenters' => 'comentaristas',
	'to act upon' => 'actuar cuando',

## tmpl/cms/edit_content_data.tmpl
	'(Max length: [_1])' => '(Longitud max: [_1])',
	'(Max select: [_1])' => '(Selección max: [_1])',
	'(Max tags: [_1])' => '(Etiquetas max: [_1])',
	'(Max: [_1] / Number of decimal places: [_2])' => '(Max: [_1] / Número de decimales: [_2])',
	'(Max: [_1])' => '(Max: [_1])',
	'(Min length: [_1] / Max length: [_2])' => '(Longitud min: [_1] / Longitud max: [_2])',
	'(Min length: [_1])' => '(Longitud min: [_1])',
	'(Min select: [_1] / Max select: [_2])' => '(Selección min: [_1] / selección max: [_2])',
	'(Min select: [_1])' => '(Selección min: [_1])',
	'(Min tags: [_1] / Max tags: [_2])' => '(Etiquetas min: [_1] / Etiquetas max: [_2])',
	'(Min tags: [_1])' => '(Etiquetas min: [_1])',
	'(Min: [_1] / Max: [_2] / Number of decimal places: [_3])' => '(Min: [_1] / Max: [_2] / Número de decimales: [_3])',
	'(Min: [_1] / Max: [_2])' => '(Min: [_1] / Max: [_2])',
	'(Min: [_1] / Number of decimal places: [_2])' => '(Min: [_1] / Número de decimales: [_2])',
	'(Min: [_1])' => '(Min: [_1])',
	'(Number of decimal places: [_1])' => '(Número de decimales: [_1])',
	'<a href="[_1]" >Create another [_2]?</a>' => '<a href="[_1]" >Crear [_2]?</a>',
	'@' => '@',
	'A saved version of this content data was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'Se guardó una versión de estos datos de contenido [_2]. <a href="[_1]" class="alert-link">Recuperar el contenido auto-guardado</a>',
	'An error occurred while trying to recover your saved content data.' => 'Ocurrió un error cuando se intentaba recuperar los datos de contenido guardados.',
	'Auto-saving...' => 'Auto-guardando...',
	'Change note' => 'Cambiar nota',
	'Draft this [_1]' => 'En borrador esta [_1]',
	'Enter a label to identify this data' => 'Introduzca una etiqueta para identificar estos datos',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Último guardado automático a las [_1]:[_2]:[_3]',
	'No revision(s) associated with this [_1]' => 'No hay revisiones de este [_1]',
	'Not specified' => 'No especificado.',
	'One tag only' => 'Sólo una etiqueta',
	'Permalink:' => 'Enlace permanente:',
	'Publish On' => 'Publicado el',
	'Publish this [_1]' => 'Publicar esta [_1]',
	'Published Time' => 'Hora de publicación',
	'Revision: <strong>[_1]</strong>' => 'Revisión: <strong>[_1]</strong>',
	'Save this [_1]' => 'Guardar [_1]',
	'Schedule' => 'Programación',
	'This [_1] has been saved.' => 'Se ha guardado [_1].',
	'Unpublish this [_1]' => 'Despublicar esta [_1]',
	'Unpublished (Draft)' => 'No publicado (Borrador)',
	'Unpublished (Review)' => 'No publicado (Revisión)',
	'Unpublished (Spam)' => 'No publicado (Spam)',
	'Unpublished Date' => 'Fecha de despublicación',
	'Unpublished Time' => 'Hora de despublicación',
	'Update this [_1]' => 'Actualizar esta [_1]',
	'Update' => 'Actualizar',
	'View revisions of this [_1]' => 'Ver revisiones de este [_1]',
	'View revisions' => 'Ver revisiones',
	'Warning: If you set the basename manually, it may conflict with another content data.' => 'Aviso: Si establece el nombre base manualmente, podría haber conflicto con otros datos de contenido.',
	'You have successfully recovered your saved content data.' => 'Ha recuperado con éxito los datos de contenido guardados.',
	'You must configure this site before you can publish this content data.' => '', # Translate - New
	q{Warning: Changing this content data's basename may break inbound links.} => q{Aviso: El cambio del nombre base de estos datos de contenido podría romper los enlaces entrantes.},

## tmpl/cms/edit_content_type.tmpl
	'1 or more label-value pairs are required' => 'Se necesitan uno o más pares etiqueta-valor',
	'Available Content Fields' => 'Campos de contenido disponibles',
	'Contents type settings has been saved.' => 'Se ha guardado la configuración de los tipos de contenido.',
	'Edit Content Type' => 'Editar tipo de contenido',
	'Reason' => 'Razón',
	'Some content fields were not deleted. You need to delete archive mapping for the content field first.' => 'Algunos campos de contenido no fueron borrados. Primero debe borrar los mapeos de archivos de los campos de contenido.',
	'This field must be unique in this content type' => 'Este campo debe ser único en este tipo de contenido',
	'Unavailable Content Fields' => 'Campos de contenido no disponibles',

## tmpl/cms/edit_entry.tmpl
	'(comma-delimited list)' => '(lista separada por comas)',
	'(space-delimited list)' => '(lista separada por espacios)',
	'<a href="[_2]">[_1]</a>' => '<a href="[_2]">[_1]</a>',
	'A saved version of this entry was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'Se auto-guardó una versión de esta entrada [_2]. <a href="[_1]" class="alert-link">Recuperar contenido auto-guardado</a>',
	'A saved version of this page was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'Se auto-guardó una versión de esta página [_2]. <a href="[_1]" class="alert-link">Recuperar contenido auto-guardado</a>',
	'Accept' => 'Aceptar',
	'Add Entry Asset' => 'Añadir multimedia',
	'Add category' => 'Añadir categoría',
	'Add new category parent' => 'Añadir categoría raíz',
	'Add new folder parent' => 'Añadir nueva carpeta raíz',
	'An error occurred while trying to recover your saved entry.' => 'Ocurrió un error durante la recuperación de la entrada guardada.',
	'An error occurred while trying to recover your saved page.' => 'Ocurrió un error durante la recuperación de la página guardada.',
	'Category Name' => 'Nombre de la categoría',
	'Change Folder' => 'Cambiar carpeta',
	'Converting to rich text may result in changes to your current document.' => 'La conversión a texto con formato puede modificar el documento actual.',
	'Create Entry' => 'Crear nueva entrada',
	'Create Page' => 'Crear página',
	'Delete this entry (x)' => 'Borrar esta entrada (x)',
	'Delete this page (x)' => 'Borrar esta página (x)',
	'Draggable' => 'Arrastrable',
	'Edit Entry' => 'Editar entrada',
	'Edit Page' => 'Editar página',
	'Enter the link address:' => 'Introduzca la dirección del enlace:',
	'Enter the text to link to:' => 'Introduzca el texto del enlace:',
	'Format:' => 'Formato:',
	'Make primary' => 'Hacer primario',
	'Manage Entries' => 'Administrar entradas',
	'No assets' => 'Ningún fichero multimedia.',
	'None selected' => 'Ninguna seleccionada',
	'One or more errors occurred when sending update pings or TrackBacks.' => 'Ocurrieron uno o más errores durante el envío de pings o TrackBacks.',
	'Outbound TrackBack URLs' => 'URLs de TrackBacks salientes',
	'Preview this entry (v)' => 'Vista previa de la entrada (v)',
	'Preview this page (v)' => 'Vista previa de la página (v)',
	'Reset display options to blog defaults' => 'Reiniciar opciones de visualización con los valores predefinidos del blog',
	'Restored revision (Date:[_1]).  The current status is: [_2]' => 'Revisión restaurada (Fecha: [_1]).  El estado actual es:  [_2]',
	'Selected Categories' => '', # Translate - New
	'Share' => 'Compartir',
	'Some [_1] in the revision could not be loaded because they have been removed.' => 'Algunos [_1] en la revisión no se pudieron cargar porque han sido eliminados.',
	'Some of tags in the revision could not be loaded because they have been removed.' => 'Algunas de las etiquetas de esta revisión no se pueden cargar debido a que han sido eliminadas.',
	'This entry has been saved.' => 'Se guardó esta entrada.',
	'This page has been saved.' => 'Se guardó esta página.',
	'This post was classified as spam.' => 'Esta entrada fue clasificada como spam.',
	'This post was held for review, due to spam filtering.' => 'Esta entrada está retenida para su aprobación, debido al filtro antispam.',
	'View Entry' => 'Ver entrada',
	'View Page' => 'Ver página',
	'View Previously Sent TrackBacks' => 'Ver TrackBacks enviados anteriormente',
	'Warning: If you set the basename manually, it may conflict with another entry.' => 'Atención: Si introduce el nombre base manualmente, podría entrar en conflicto con otra entrada.',
	'You have successfully deleted the checked TrackBack(s).' => 'Eliminó correctamente los TrackBacks marcados.',
	'You have successfully deleted the checked comment(s).' => 'Eliminó correctamente los comentarios marcados.',
	'You have successfully recovered your saved entry.' => 'Ha recuperado con éxito la entrada guardada.',
	'You have successfully recovered your saved page.' => 'Ha recuperado con éxito la página guardada.',
	'You have unsaved changes to this entry that will be lost.' => 'Posee cambios no guardados en esta entrada que se perderán.',
	'You must configure this site before you can publish this entry.' => '', # Translate - New
	'You must configure this site before you can publish this page.' => '', # Translate - New
	'Your changes to the comment have been saved.' => 'Se guardaron sus cambios al comentario.',
	'Your customization preferences have been saved, and are visible in the form below.' => 'Se guardaron los cambios en las preferencias y pueden verse en el siguiente formulario.',
	'Your notification has been sent.' => 'Se envió su notificación.',
	'[_1] Assets' => 'Multimedia de la [_1]',
	'_USAGE_VIEW_LOG' => 'Compruebe el error en el <a href="[_1]">Registro de actividad</a>.',
	'edit' => 'editar',
	q{(delimited by '[_1]')} => q{(separado por '[_1]')},
	q{Warning: Changing this entry's basename may break inbound links.} => q{Atención: Si cambia el nombre base de la entrada, podría romper enlaces entrantes.},

## tmpl/cms/edit_entry_batch.tmpl
	'Save these [_1] (s)' => 'Guardar este [_1] (s)',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Editar carpeta',
	'Manage Folders' => 'Administrar carpetas',
	'Manage pages in this folder' => 'Administrar las páginas de esta carpeta',
	'Path' => 'Ruta',
	'Save changes to this folder (s)' => 'Guardar cambios de esta carpeta (s)',
	'You must specify a label for the folder.' => 'Debe especificar una etiqueta para la carpeta.',

## tmpl/cms/edit_group.tmpl
	'Created By' => 'Creado por',
	'Created On' => 'Creado en',
	'Edit Group' => 'Editar grupo',
	'LDAP Group ID' => 'LDAP del Grupo ID',
	'Member ([_1])' => 'Miembro ([_1])',
	'Members ([_1])' => 'Miembros ([_1])',
	'Permission ([_1])' => 'Permiso ([_1])',
	'Permissions ([_1])' => 'Permisos ([_1])',
	'Save changes to this field (s)' => 'Guardar cambios en el campo (s)',
	'Status of this group in the system. Disabling a group prohibits its members&rsquo; from accessing the system but preserves their content and history.' => 'El estado del grupo en el sistema. La deshabilitación de grupos prohíbe a sus miembros el acceso al sistema, pero mantiene los contenidos e historia.',
	'The LDAP directory ID for this group.' => 'El ID del directorio LDAP para este grupo.',
	'The description for this group.' => 'La descripción de este grupo.',
	'The display name for this group.' => 'El nombre que se muestra para este grupo.',
	'The name used for identifying this group.' => 'El nombre de usuario para identificar este grupo.',
	'This group profile has been updated.' => 'Se ha actualizado el perfil del grupo.',
	'This group was classified as disabled.' => 'Este grupo estaba clasificado como deshabilitado.',
	'This group was classified as pending.' => 'Este grupo estaba clasificado como pendiente.',

## tmpl/cms/edit_ping.tmpl
	'Category no longer exists' => 'Ya no existe la categoría',
	'Delete this TrackBack (x)' => 'Borrar este TrackBack (x)',
	'Edit Trackback' => 'Editar TrackBack',
	'Entry no longer exists' => 'La entrada ya no existe.',
	'Manage TrackBacks' => 'Administrar TrackBacks',
	'No title' => 'Sin título',
	'Save changes to this TrackBack (s)' => 'Guardar cambios de este TrackBack (s)',
	'Search for other TrackBacks from this site' => 'Buscar otros TrackBacks en este sitio',
	'Search for other TrackBacks with this status' => 'Buscar otros TrackBacks con este estado',
	'Search for other TrackBacks with this title' => 'Buscar otros TrackBacks con este título',
	'Source Site' => 'Sitio de origen',
	'Source Title' => 'Título de origen',
	'Target Category' => 'Categoría de destinación ',
	'Target [_1]' => 'Destino [_1]',
	'The TrackBack has been approved.' => 'Se aprobó el TrackBack.',
	'This trackback was classified as spam.' => 'Se ha clasificado el trackback como basura.',
	'TrackBack Text' => 'Texto del TrackBack',
	'View all TrackBacks created on this day' => 'Mostrar todos los TrackBacks creados este día',
	'View all TrackBacks from this IP address' => 'Mostrar todos los TrackBacks enviados desde esta dirección IP',
	'View all TrackBacks on this category' => 'Mostrar todos los TrackBacks de esta categoría',
	'View all TrackBacks on this entry' => 'Mostrar todos los TrackBacks de esta entrada',
	'View all TrackBacks with this status' => 'Ver TrackBacks con este estado',

## tmpl/cms/edit_role.tmpl
	'Administration' => 'Administración',
	'Association (1)' => 'Asociación (1)',
	'Associations ([_1])' => 'Asociaciones ([_1])',
	'Authoring and Publishing' => 'Creación y publicación',
	'Check All' => '', # Translate - New
	'Commenting' => 'Comentar',
	'Content Field Privileges' => '', # Translate - New
	'Content Type Privileges' => 'Permisos de tipos de contenido',
	'Designing' => 'Diseño',
	'Duplicate Roles' => 'Duplicar roles',
	'Edit Role' => 'Editar rol',
	'Privileges' => 'Privilegios',
	'Role Details' => 'Detalles de los roles',
	'Save changes to this role (s)' => 'Guardar cambios en el rol (s)',
	'Uncheck All' => '', # Translate - New
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'Ha cambiado los provilegios de este rol.  Esto va cambiar las posibilidades de maniobra de los usuarios asociados a este rol. Si usted prefiere, puede guardar este rol con otro nombre diferente.',

## tmpl/cms/edit_template.tmpl
	': every ' => ': cada ',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => '<a href="[_1]" class="rebuild-link">Publicar</a> esta plantilla.',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]" class="alert-link">Recover auto-saved content</a>' => 'Una versión guardada de este [_1] fue auto-guardado [_3]. <a href="[_2]" class="alert-link">Recuperar contenido auto-guardado</a>',
	'An error occurred while trying to recover your saved [_1].' => 'Ocurrió un error intentando recuperar la versión guardada de [_1].',
	'Archive map has been successfully updated.' => 'Se actualizaron con éxito los mapas de archivos.',
	'Are you sure you want to remove this template map?' => '¿Está seguro que desea borrar este mapa de plantilla?',
	'Category Field' => 'Campo de categoría',
	'Code Highlight' => 'Resaltado de código',
	'Content field' => 'Campo de contenido',
	'Copy Unique ID' => 'Copiar ID único',
	'Create Archive Mapping' => 'Crear mapeado de archivos',
	'Create Content Type Archive Template' => 'Crear plantilla de archivos de tipos de contenido',
	'Create Content Type Listing Archive Template' => 'Crear plantilla de archivos de lista de tipos de contenido',
	'Create Entry Archive Template' => 'Crear plantilla de archivos de entradas',
	'Create Entry Listing Archive Template' => 'Crear plantilla de archivos de lista de entradas',
	'Create Index Template' => 'Crear plantilla índice',
	'Create Page Archive Template' => 'Crear plantilla de archivos de páginas',
	'Create Template Module' => 'Crear plantilla de módulo',
	'Create a new Content Type?' => '¿Crear un nuevo tipo de contenido?',
	'Custom Index Template' => 'Plantilla índice personalizada',
	'Date & Time Field' => 'Campo de fecha y hora',
	'Disabled (<a href="[_1]">change publishing settings</a>)' => 'Deshabilitado (<a href="[_1]">modificar configuración de la publicación</a>)',
	'Do Not Publish' => 'No publicar',
	'Dynamically' => 'Dinámicamente',
	'Edit Widget' => 'Editar widget',
	'Error occurred while updating archive maps.' => 'Ocurrió un error durante la actualización de los mapas de archivos.',
	'Expire after' => 'Caduca tras',
	'Expire upon creation or modification of:' => 'Caduca tras la creación o modificación de:',
	'Include cache path' => 'Ruta de caché de inserciones',
	'Included Templates' => 'Plantillas incluídas',
	'Learn more about <a href="https://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publishing settings</a>' => 'Más información sobre las <a href="https://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">opciones de publicación</a>',
	'Learn more about <a href="https://www.movabletype.org/documentation/appendices/archive-file-path-specifiers.html" target="_blank">Archive File Path Specifiers</a>' => 'Más información sobre <a href="https://www.movabletype.org/documentation/appendices/archive-file-path-specifiers.html" target="_blank">indicadores de ruta de archivos</a>',
	'Link to File' => 'Enlazar a archivo',
	'List [_1] templates' => 'Listar plantillas [_1]',
	'List all templates' => 'Listar todas las plantillas',
	'Manually' => 'Manualmente',
	'Module Body' => 'Cuerpo del módulo',
	'Module Option Settings' => 'Configuración de opciones del módulo',
	'New Template' => 'Nueva plantilla',
	'No caching' => 'Sin caché',
	'No revision(s) associated with this template' => 'Ninguna revisión asociada a esta plantilla',
	'On a schedule' => 'Programado',
	'Process as <strong>[_1]</strong> include' => 'Procesar como inserción <strong>[_1]</strong>',
	'Processing request...' => 'Procesando petición...',
	'Restored revision (Date:[_1]).' => 'Revisión restaurada (Fecha: [_1]).',
	'Save &amp; Publish' => 'Guardar &amp; Publicar',
	'Save Changes (s)' => 'Guardar los cambios (s)',
	'Save and Publish this template (r)' => 'Guardar y publicar esta plantilla (r)',
	'Select Content Field' => 'Seleccionar campo de contenido',
	'Server Side Include' => 'Server Side Include',
	'Statically (default)' => 'Estáticamente (por defecto)',
	'Template Body' => 'Cuerpo de la plantilla',
	'Template Type' => 'Tipo de plantilla',
	'Useful Links' => 'Enlaces útiles',
	'Via Publish Queue' => 'Vía cola de publicación',
	'View Published Template' => 'Ver plantilla publicada',
	'View revisions of this template' => 'Ver revisiones de esta plantilla',
	'You have successfully recovered your saved [_1].' => 'Recuperó con éxito la versión guardada de [_1].',
	'You have unsaved changes to this template that will be lost.' => 'Esta plantilla tiene cambios no guardados que se perderán.',
	'You must select the Content Type.' => 'Debe seleccionar el tipo de contenido.',
	'You must set the Template Name.' => 'Debe indicar el nombre de la plantilla.',
	'You must set the template Output File.' => 'Debe indicar el fichero de salida de la plantilla.',
	'Your [_1] has been published.' => 'Su [_1] se ha publicado.',
	'create' => 'crear',
	'hours' => 'horas',
	'minutes' => 'minutos',

## tmpl/cms/edit_website.tmpl
	'Create Site (s)' => 'Crear sitio (s)',
	'Enter the URL of your site. Exclude the filename (i.e. index.html). Example: http://www.example.com/' => 'Introduzca la URL del sitio. Sin incluir el nombre de fichero (p.e. index.html). Ejemplo: http://www.ejemplo.com/',
	'Name your site. The site name can be changed at any time.' => 'Nombre del sitio. Puede cambiarlo en cualquier momento.',
	'Please enter a valid URL.' => 'Por favor, introduzca una URL válida.',
	'Please enter a valid site path.' => 'Por favor, introduzca una ruta de sitio válida.',
	'Select the theme you wish to use for this site.' => 'Seleccione el tema que desee usar para este sitio.',
	'This field is required.' => 'Este campo es obligatorio.',
	'You did not select a timezone.' => 'No seleccionó ninguna zona horaria.',
	'Your site configuration has been saved.' => 'Se ha guardado la configuración del sitio.',
	q{Enter the path where your main index file will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/ or C:\www\public_html} => q{Introduzca la ruta de publicación del fichero índice principal. Se recomienda una ruta principal (que en Linux comienza con '/' y en Windows con 'C:\') pero también puede utilizar una ruta relativa al directorio de Movable Type. Ejemplo :/home/melody/public_html/ o C:\www\public_html},

## tmpl/cms/edit_widget.tmpl
	'Available Widgets' => 'Widgets disponibles',
	'Edit Widget Set' => 'Editar widgets',
	'Installed Widgets' => 'Widgets instalados',
	'Save changes to this widget set (s)' => 'Guardar cambios de este conjunto de widgets (s)',
	'Widget Set Name' => 'Nombre del conjunto de widgets',
	'You must set Widget Set Name.' => 'Debe indicar un nombre para el conjunto de widgets.',
	q{Drag and drop the widgets that belong in this Widget Set into the 'Installed Widgets' column.} => q{Arrastre y suelte los widgets que pertenecen a este conjunto a la columna 'Widgets instalados'.},

## tmpl/cms/error.tmpl
	'An error occurred' => 'Ocurrió un error',

## tmpl/cms/export.tmpl
	'Export [_1] Entries' => 'Exportar [_1] entradas',
	'Export [_1]' => 'Exportar [_1]',
	'[_1] to Export' => '[_1] a exportar',
	'_USAGE_EXPORT_1' => 'Exporta las entradas, comentarios y TrackBacks de un blog. La exportación no puede considerarse como una copia de seguridad <em>completa</em> del blog.',

## tmpl/cms/export_theme.tmpl
	'Author link' => 'Enlace del autor',
	'Basename may only contain letters, numbers, and the dash or underscore character. The basename must begin with a letter.' => 'El nombre base solo puede contener letras, números, y el guión o guión bajo. El nombre base debe comenzar con una letra.',
	'Destination' => 'Destino',
	'Setting for [_1]' => 'Configuración para [_1]',
	'Theme package have been saved.' => 'El paquete del tema se ha guardado.',
	'Theme version may only contain letters, numbers, and the dash or underscore character.' => 'La versión del tema solo puede contener letras, números y el guión o guión bajo.',
	'Version' => 'Versión',
	'You must set Theme Name.' => 'Debe indicar el nombre del tema.',
	'_THEME_AUTHOR' => 'Autor',
	q{Cannot install new theme with existing (and protected) theme's basename.} => q{No se pudo instalar el nuevo tema con el nombre base existeinte (y protegido) del tema.},
	q{Use letters, numbers, dash or underscore only (a-z, A-Z, 0-9, '-' or '_').} => q{Use exclusivamente letras, números, guiones o guiones bajos (a-z, A-Z, 0-9, '-' o '_').},

## tmpl/cms/field_html/field_html_asset.tmpl
	'Assets greater than or equal to [_1] must be selected' => 'Debe seleccionar [_1] o más ficheros multimedia.',
	'Assets less than or equal to [_1] must be selected' => 'Debe seleccionar [_1] o menos ficheros multimedia.',
	'No Asset' => 'Ningún fichero multimedia.',
	'No Assets' => 'Ningún fichero multimedia.',
	'Only 1 asset can be selected' => 'Sólo puede seleccionar un fichero multimedia',

## tmpl/cms/field_html/field_html_categories.tmpl
	'Add sub category' => 'Añadir sub categoría',
	'This field is disabled because valid Category Set is not selected in this field.' => 'Este campo está deshabilitado porque no se ha seleccionado un cojunto de categorías en este campo.',

## tmpl/cms/field_html/field_html_content_type.tmpl
	'No [_1]' => 'Ningún [_1]',
	'No field data.' => 'Campo sin datos.',
	'Only 1 [_1] can be selected' => 'Sólo puede seleccionar un [_1]',
	'This field is disabled because valid Content Type is not selected in this field.' => 'Este campo está deshabilitado porque no se ha seleccionado un tipo de contenido válido en este campo.',
	'[_1] greater than or equal to [_2] must be selected' => 'Debe seleccionar [_2] o más [_1]',
	'[_1] less than or equal to [_2] must be selected' => 'Debe seleccionar [_2] o menos [_1]',

## tmpl/cms/field_html/field_html_select_box.tmpl
	'Not Selected' => 'No seleccionado',

## tmpl/cms/field_html/field_html_table.tmpl
	'All possible cells should be selected so to merge cells into one' => '', # Translate - New
	'Cell is not selected' => '', # Translate - New
	'Only one cell should be selected' => '', # Translate - New
	'Source' => '', # Translate - New
	'align center' => '', # Translate - New
	'align left' => '', # Translate - New
	'align right' => '', # Translate - New
	'change to td' => '', # Translate - New
	'change to th' => '', # Translate - New
	'insert column on the left' => '', # Translate - New
	'insert column on the right' => '', # Translate - New
	'insert row above' => '', # Translate - New
	'insert row below' => '', # Translate - New
	'merge cell' => '', # Translate - New
	'remove column' => '', # Translate - New
	'remove row' => '', # Translate - New
	'split cell' => '', # Translate - New
	q{The top left cell's value of the selected range will only be saved. Are you sure you want to continue?} => q{}, # Translate - New
	q{You can't paste here} => q{}, # Translate - New
	q{You can't split the cell anymore} => q{}, # Translate - New

## tmpl/cms/import.tmpl
	'<mt:var name="display_name" escape="html">' => '<mt:var name="display_name" escape="html">',
	'Apply this formatting if text format is not set on each entry.' => 'Aplicar este formato si el formato del texto de las entradas no está establecido.',
	'Default category for entries (optional)' => 'Categoría predefinida de las entradas (opcional)',
	'Default password for new users:' => 'Contraseña para los nuevos usuarios:',
	'Enter a default password for new users.' => 'Introduzca una contraseña por defecto para los nuevos usuarios.',
	'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => 'Si selecciona preservar la autoría de las entradas importadas y se debe crear alguno de estos usuarios durante en esta instalación, debe establecer una contraseña predefinida para estas nuevas cuentas.',
	'Import Entries (s)' => 'Importar entradas (s)',
	'Import Entries' => 'Importar entradas',
	'Import File Encoding' => 'Codificación del fichero de importación',
	'Import [_1] Entries' => 'Importar [_1] entradas',
	'Import as me' => 'Importar como yo mismo',
	'Importing from' => 'Importar desde',
	'Ownership of imported entries' => 'Autoría de las entradas importadas',
	'Preserve original user' => 'Preservar autor original',
	'Select a category' => 'Seleccione una categoría',
	'Transfer site entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Transfiera entradas del sitio a Movable Type desde otras instalaciones de Movable Type o incluso otras herramientas de blogs o exporte entradas para crear una copia de seguridad.',
	'Upload import file (optional)' => 'Subir fichero de importación (opcional)',
	'You must select a site to import.' => 'Debe seleccionar un sitio para importar.',
	'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'Se le asignarán todas las entradas importadas. Si desea que las entradas mantengan los propietarios originales, debe contacar con su administrador de Movable Type para que él realice la importación y así se puedan crear los nuevos usuarios en caso de ser necesario.',

## tmpl/cms/import_others.tmpl
	'Default entry status (optional)' => 'Estado predefinido de las entradas (opcional)',
	'End title HTML (optional)' => 'HTML de final de título (opcional)',
	'Select an entry status' => 'Seleccione un estado para las entradas',
	'Start title HTML (optional)' => 'HTML de comienzo de título (opcional)',

## tmpl/cms/include/anonymous_comment.tmpl
	'Allow comments from anonymous or unauthenticated users.' => 'Permitir comentarios de usuarios anónimos o no autentificados.',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Si está activo, los visitantes deberán introducir una dirección válida de correo electrónico para comentar.',
	'Require name and E-mail Address for Anonymous Comments' => 'Requerir dirección de correo en los comentarios anónimos',

## tmpl/cms/include/archetype_editor.tmpl
	'Begin Blockquote' => 'Comenzar cita',
	'Bold' => 'Negrita',
	'Bulleted List' => 'Viñeta',
	'Center Item' => 'Centrar elemento',
	'Center Text' => 'Centrar texto',
	'Check Spelling' => 'Ortografía',
	'Decrease Text Size' => 'Aumentar tamaño de texto',
	'Email Link' => 'Enlace de correo',
	'End Blockquote' => 'Finalizar cita',
	'HTML Mode' => 'Modo HTML',
	'Increase Text Size' => 'Disminuir tamaño de texto',
	'Insert File' => 'Insertar fichero',
	'Insert Image' => 'Insertar imagen',
	'Italic' => 'Cursiva',
	'Left Align Item' => 'Alinear elemento a la izquierda',
	'Left Align Text' => 'Alinear texto a la izquierda',
	'Numbered List' => 'Numeración',
	'Right Align Item' => 'Alinear elemento a la derecha',
	'Right Align Text' => 'Alinear texto a la derecha',
	'Text Color' => 'Color de texto',
	'Underline' => 'Subrayado',
	'WYSIWYG Mode' => 'Modo con formato (WYSIWYG)',

## tmpl/cms/include/archive_maps.tmpl
	'Collapse' => 'Plegar',
	'Preferred' => '', # Translate - New

## tmpl/cms/include/asset_replace.tmpl
	'No' => 'No',
	'Yes (s)' => 'Sí (s)',
	'Yes' => 'Sí',
	q{A file named '[_1]' already exists. Do you want to overwrite this file?} => q{El fichero llamado '[_1]' ya existe. ¿Desea sobreescribirlo?},

## tmpl/cms/include/asset_table.tmpl
	'Asset Missing' => 'Fichero multimedia no existe',
	'Delete selected assets (x)' => 'Borrar los ficheros multimedia seleccionados (x)',
	'No thumbnail image' => 'Sin miniatura',
	'Size' => 'Tamaño',

## tmpl/cms/include/asset_upload.tmpl
	'Choose Folder' => 'Seleccionar carpeta',
	'Select File to Upload' => 'Seleccione el fichero a subir',
	'Upload (s)' => 'Subir (s)',
	'Your system or [_1] administrator needs to publish the [_1] before you can upload files. Please contact your system or [_1] administrator.' => 'El administrador del sistema o del [_1] debe publicar el [_1] antes de pueda subir ficheros. Por favor, contacte con el administrador del sistema o del [_1].',
	'[_1] contains a character that is invalid when used in a directory name: [_2]' => '[_1] contiene un caracter no válido para un nombre de directorio: [_2]',
	'_USAGE_UPLOAD' => 'Puede transferir el fichero a un subdirectorio en la ruta seleccionada. Si el subdirectorio no existe, se creará.',
	q{Asset file('[_1]') has been uploaded.} => q{Se ha transferido un fichero multimedia ('[_1]').},
	q{Before you can upload a file, you need to publish your [_1]. [_2]Configure your [_1]'s publishing paths[_3] and republish your [_1].} => q{Antes de subir un fichero, debe publicar su [_1]. [_2]Configure las rutas de publicación[_3] de su [_1] y republique el [_1].},
	q{Cannot write to '[_1]'. Image upload is possible, but thumbnail is not created.} => q{No se pudo escribir en '[_1]'. La transferencia de la imagen es posible, pero no se creará la miniatura.},

## tmpl/cms/include/async_asset_list.tmpl
	'All Types' => 'Todos los tipos',
	'Asset Type: ' => 'Tipo multimedia:',
	'label' => 'Título',

## tmpl/cms/include/async_asset_upload.tmpl
	'Choose file to upload or drag file.' => 'Seleccione los ficheros a subir o arrástrelos.',
	'Choose file to upload.' => 'Seleccione fichero a transferir.',
	'Choose files to upload or drag files.' => 'Seleccione los ficheros para subir o arrástrelos.',
	'Choose files to upload.' => 'Seleccione los ficheros a transferir.',
	'Drag and drop here' => 'Arrastrar y solar aquí',
	'Operation for a file exists' => 'Acción para ficheros existentes',
	'Upload Options' => 'Configuración transferencias',
	'Upload Settings' => 'Transferir configuración',

## tmpl/cms/include/author_table.tmpl
	'Disable selected users (d)' => 'Deshabilitar usuarios seleccionados (d)',
	'Enable selected users (e)' => 'Habilitar usuarios seleccionados (e)',
	'_NO_SUPERUSER_DISABLE' => 'No puede deshabilitarse porque es un administrador del sistema de Movable Type',
	'_USER_DISABLE' => 'Deshabilitar',
	'_USER_ENABLE' => 'Habilitado',
	'user' => 'usuario',
	'users' => 'usuarios',

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been exported successfully!' => '¡Se han exportado todos los datos correctamente!',
	'An error occurred during the export process: [_1]' => 'Ocurrió un error durante el proceso de exportación: [_1]',
	'Download This File' => 'Descargar este fichero',
	'Download: [_1]' => 'Descargar: [_1]',
	'Export Files' => 'Exportar ficheros',
	'_BACKUP_DOWNLOAD_MESSAGE' => 'La descarga del fichero de la copia de seguridad comenzará automáticamente dentro de unos segundos. Si por alguna razón no lo hace, haga clic <a href="javascript:(void)" onclick="submit_form()">aquí</a> para comenzar la descarga manualmente. Por favor, tenga en cuenta que solo puede descargar el fichero de la copia de seguridad una vez por sesión.',
	'_BACKUP_TEMPDIR_WARNING' => 'La copia de seguridad se realizó con éxito en el directorio [_1]. Descargue y <strong>borre luego</strong> los ficheros listados abajo desde [_1] <strong>inmediatamente</strong>, porque los ficheros de la copia de seguridad contiene información sensible.',

## tmpl/cms/include/backup_start.tmpl
	'Exporting Movable Type' => 'Exportando Movable Type',

## tmpl/cms/include/basic_filter_forms.tmpl
	'[_1] [_2] [_3]' => '[_1] [_2] [_3]',
	'[_1] and [_2]' => '[_1] y [_2]',
	'[_1] hours' => '[_1] horas',
	'_FILTER_DATE_DAYS' => '[_1] días',
	'__FILTER_DATE_ORIGIN' => '[_1]',
	'__INTEGER_FILTER_EQUAL' => 'es',
	'__INTEGER_FILTER_NOT_EQUAL' => 'no es',
	'__STRING_FILTER_EQUAL' => 'es',
	'__TIME_FILTER_HOURS' => 'en los últimos',
	'contains' => 'contiene',
	'does not contain' => 'no contiene',
	'ends with' => 'termina con',
	'is after now' => 'es posterior a ahora',
	'is after' => 'es posterior',
	'is before now' => 'es anterior a ahora',
	'is before' => 'es anterior',
	'is between' => 'está entre',
	'is blank' => 'está vacío',
	'is greater than or equal to' => 'es mayor o igual que',
	'is greater than' => 'es mayor que',
	'is less than or equal to' => 'es menor o igual que',
	'is less than' => 'es menor que',
	'is not blank' => 'no está vacío',
	'is within the last' => 'está entre el último',
	'starts with' => 'comienza con',

## tmpl/cms/include/blog_table.tmpl
	'Delete selected [_1] (x)' => 'Borrar [_1] seleccionados (x)',
	'Some sites were not deleted. You need to delete child sites under the site first.' => 'Algunos sitios no se borraron. Primero debe borrar los sitios hijos bajo este sitio.',
	'Some templates were not refreshed.' => 'No se refrescaron algunas plantillas.',
	'[_1] Name' => 'Nombre de [_1]',

## tmpl/cms/include/category_selector.tmpl
	'Add sub folder' => 'Añadir sub carpeta',

## tmpl/cms/include/comment_table.tmpl
	'([quant,_1,reply,replies])' => '([quant,_1,respuesta,respuestas])',
	'Blocked' => 'Bloqueado',
	'Delete selected comments (x)' => 'Borrar comentarios seleccionados (x)',
	'Edit this [_1] commenter' => 'Editar comentarista [_1]',
	'Edit this comment' => 'Editar este comentario',
	'Publish selected comments (a)' => 'Publicar comentarios seleccionados (a)',
	'Search for all comments from this IP address' => 'Buscar todos los comentarios enviados desde esta dirección IP',
	'Search for comments by this commenter' => 'Buscar comentarios de este comentarista',
	'View this entry' => 'Ver esta entrada',
	'View this page' => 'Ver esta página',
	'to republish' => 'para reconstruir',

## tmpl/cms/include/commenter_table.tmpl
	'Edit this commenter' => 'Editar este comentarista',
	'Last Commented' => 'Últimos comentados',
	'View this commenter&rsquo;s profile' => 'Ver el perfil de este comentarista',

## tmpl/cms/include/content_data_table.tmpl
	'Created' => 'Creado',
	'Republish selected [_1] (r)' => 'Republicar [_1] seleccionadas (r)',
	'Unpublish' => 'Despublicar',
	'View Content Data' => 'Ver datos de contenido',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001 Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001 Six Apart. All Rights Reserved.',

## tmpl/cms/include/entry_table.tmpl
	'<a href="[_1]" class="alert-link">Create an entry</a> now.' => '<a href="[_1]" class="alert-link">Crear una entrada</a> ahora.',
	'Last Modified' => 'Última modificación',
	'No entries could be found.' => 'No se encontraron entradas.',
	'No pages could be found. <a href="[_1]" class="alert-link">Create a page</a> now.' => 'No se encontró ninguna página. <a href="[_1]" class="alert-link">Crear una página</a> ahora.',
	'View entry' => 'Ver entrada',
	'View page' => 'Ver página',

## tmpl/cms/include/feed_link.tmpl
	'Set Web Services Password' => 'Establecer contraseña de servicios web',

## tmpl/cms/include/footer.tmpl
	'<a href="[_1]"><mt:var name="mt_product_name"></a> [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> [_2]',
	'BETA' => 'BETA',
	'DEVELOPER PREVIEW' => 'VERSIÓN PREVIA PARA DESARROLLADORES',
	'Forums' => 'Foros',
	'MovableType.org' => 'MovableType.org',
	'Send Us Feedback' => 'Envíenos su opinión',
	'Support' => 'Soporte',
	'This is a alpha version of Movable Type and is not recommended for production use.' => 'Esta es una versión alfa de Movable Type y no se recomienda el uso en producción.',
	'This is a beta version of Movable Type and is not recommended for production use.' => 'Esta es una versión beta de Movable Type y no se recomienda su uso en producción.',
	'https://forums.movabletype.org/' => 'https://forums.movabletype.org/',
	'https://plugins.movabletype.org/' => 'https://plugins.movabletype.org/',
	'https://www.movabletype.org' => 'https://www.movabletype.org',
	'with' => 'con',

## tmpl/cms/include/group_table.tmpl
	'Disable selected group (d)' => 'Deshabilitar grupo seleccionado (d)',
	'Enable selected group (e)' => 'Habilitar grupo seleccionado (e)',
	'Remove selected group (d)' => 'Borrar grupo seleccionado (d)',
	'group' => 'grupo',
	'groups' => 'grupos',

## tmpl/cms/include/header.tmpl
	'Help' => 'Ayuda',
	'Search (q)' => 'Buscar (q)',
	'Search [_1]' => 'Buscar [_1]',
	'Select an action' => 'Seleccione una acción',
	'from Revision History' => 'del histórico de revisiones',
	q{This website was created during the upgrade from a previous version of Movable Type. 'Site Root' and 'Site URL' are left blank to retain 'Publishing Paths' compatibility for blogs that were created in a previous version. You can post and publish on existing blogs, but you cannot publish this website itself because of the blank 'Site Root' and 'Site URL'.} => q{Este sitio web se ha creado al actualizar desde una versión anterior de Movable Type. 'Ruta del sitio' y 'URL del sitio' se han dejado en blanco para mantener la compatabilidad con las 'Rutas de publicación' de los blogs creados en versiones anteriores. Puede publicar en los blogs existentes, pero no puede publicar en este sitio directamente debido a que la 'Ruta del sitio' y la 'URL del sitio' están en blanco.},

## tmpl/cms/include/import_end.tmpl
	'<a href="#" onclick="[_1]" class="mt-build">Publish your site</a> to see these changes take effect.' => '<a href="#" onclick="[_1]" class="mt-build">Publique su sitio</a> para que los cambios tomen efecto.',

## tmpl/cms/include/import_start.tmpl
	'Creating new users for each user found in the [_1]' => 'Creando nuevos usuarios para cada usuario encontrado en el [_1]',
	'Importing entries into [_1]' => 'Importando entradas en el [_1]',
	q{Importing entries as user '[_1]'} => q{Importando entradas como usuario '[_1]'},

## tmpl/cms/include/itemset_action_widget.tmpl
	'Go' => 'Ir',

## tmpl/cms/include/listing_panel.tmpl
	'Go to [_1]' => 'Ir a [_1]',
	'Sorry, there is no data for this object set.' => 'Lo siento, no hay datos para este conjunto de objetos.',
	'Sorry, there were no results for your search. Please try searching again.' => 'Lo siento, no se encontraron resultados para la búsqueda. Por favor, intente buscar de nuevo.',
	'Step [_1] of [_2]' => 'Paso [_1] de [_2]',

## tmpl/cms/include/log_table.tmpl
	'IP: [_1]' => 'IP: [_1]',
	'No log records could be found.' => 'No se encontraron registros.',
	'_LOG_TABLE_BY' => 'Por',

## tmpl/cms/include/login_mt.tmpl
	'Remember me?' => '¿Recordarme?',

## tmpl/cms/include/member_table.tmpl
	'Are you sure you want to remove the [_1] selected users from this [_2]?' => '¿Está seguro de que desea borrar a los [_1] usuarios seleccionados de este [_2]?',
	'Are you sure you want to remove the selected user from this [_1]?' => '¿Está seguro de que desea borrar al usuario seleccionado de este [_1]?',
	'Remove selected user(s) (r)' => 'Borrar usuarios seleccionados (r)',
	'Remove this role' => 'Borrar este rol',

## tmpl/cms/include/mobile_global_menu.tmpl
	'PC View' => 'Vista PC',
	'Select another child site...' => 'Seleccionar otro sitio hijo...',
	'Select another site...' => 'Seleccionar otro sitio...',

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Fecha de creación',
	'Save changes' => 'Guardar cambios',

## tmpl/cms/include/old_footer.tmpl
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> versión [_2]',
	'Wiki' => 'Wiki',
	'Your Dashboard' => 'Su panel de control',
	'https://wiki.movabletype.org/' => 'https://wiki.movabletype.org/',
	q{_LOCALE_CALENDAR_HEADER_} => q{'D', 'L', 'M', 'X', 'J', 'V', 'S', 'D'},

## tmpl/cms/include/pagination.tmpl
	'First' => 'Primero',
	'Last' => 'Último',

## tmpl/cms/include/ping_table.tmpl
	'Edit this TrackBack' => 'Editar este TrackBack',
	'From' => 'Origen',
	'Go to the source entry of this TrackBack' => 'Ir a la entrada de origen de este TrackBack',
	'Moderated' => 'Moderado',
	'Publish selected [_1] (p)' => 'Publicar [_1] seleccionados (p)',
	'Target' => 'Destino',
	'View the [_1] for this TrackBack' => 'Mostrar [_1] de este TrackBack',

## tmpl/cms/include/primary_navigation.tmpl
	'Close Site Menu' => 'Cerrar menú del sitio',
	'Open Panel' => 'Abrir panel',
	'Open Site Menu' => 'Abrir menú del sitio',

## tmpl/cms/include/revision_table.tmpl
	'*Deleted due to data breakage*' => '*Eliminada debido a la rotura de datos*',
	'No revisions could be found.' => 'No se encontraron revisiones.',
	'Note' => 'Nota',
	'Saved By' => 'Guardado por',
	'_REVISION_DATE_' => 'Fecha',

## tmpl/cms/include/rpt_log_table.tmpl
	'Schwartz Message' => 'Mensaje de Schwartz',

## tmpl/cms/include/scope_selector.tmpl
	'(on [_1])' => '(en [_1])',
	'Create Blog (on [_1])' => 'Crear un blog (en [_1])',
	'Create Website' => 'Crear un sitio web',
	'Select another blog...' => 'Seleccionar otro blog...',
	'Select another website...' => 'Seleccione otro sitio web...',
	'User Dashboard' => 'Panel de control del usuario',
	'Websites' => 'Sitios web',

## tmpl/cms/include/status_widget.tmpl
	'[_1] - Edited by [_2]' => '[_1] - Editado por [_2]',
	'[_1] - Published by [_2]' => '[_1] - Publicado por [_2]',

## tmpl/cms/include/template_table.tmpl
	'Archive Path' => 'Ruta de archivos',
	'Cached' => 'Cacheado',
	'Create Archive Template:' => 'Crear plantilla de archivos',
	'Dynamic' => 'Dinámico',
	'Manual' => 'Manual',
	'No content type could be found.' => 'No se encontró ningún tipo de contenido.',
	'Publish Queue' => 'Cola de publicación',
	'Publish selected templates (a)' => 'Publicar plantillas seleccionadas (a)',
	'SSI' => 'Inclusiones en servidor (SSI)',
	'Static' => 'Estático',
	'Uncached' => 'No cacheado',
	'templates' => 'plantillas',
	'to publish' => 'para publicar',

## tmpl/cms/include/theme_exporters/folder.tmpl
	'<mt:if name="is_blog">Blog URL<mt:else>Site URL</mt:if>' => '<mt:if name="is_blog">URL del blog<mt:else>URL del sitio</mt:if>',
	'Folder Name' => 'Nombre de la carpeta',

## tmpl/cms/include/theme_exporters/static_files.tmpl
	'In the specified directories, files of the following types will be included in the theme: [_1]. Other file types will be ignored.' => 'En los directorios especificados, se incluirán en el tema los ficheros de los siguientes tipos: [_1]. Se ignorarán el resto de tipos de ficheros.',
	'List directories (one per line) in the Site Root directory which contain the static files to be included in the theme. Common directories might be: css, images, js, etc.' => 'Indique una lista de directorios (uno por línea) en el directorio Raíz del Sitio que contienen los ficheros estáticos a incluir en el tema. Los directorios más comunes son: css, images, js, etc.',
	'Specify directories' => 'Especificar directorios',

## tmpl/cms/include/theme_exporters/templateset.tmpl
	'<span class="count">[_1]</span> [_2] are included' => '<span class="count">[_1]</span> [_2] están incluídos',
	'modules' => 'módulos',
	'widget sets' => 'Conjuntos de widgets',

## tmpl/cms/install.tmpl
	'Create Your Account' => 'Crear Cuenta',
	'Do you want to proceed with the installation anyway?' => '¿Aún así desea proceder con la instalación?',
	'Finish install (s)' => 'Finalizar la instalación (s)',
	'Finish install' => 'Finalizar instalación',
	'Please create an administrator account for your system. When you are done, Movable Type will initialize your database.' => 'Por favor, cree una cuenta para el administrador del sistema. Cuando haya finalizado, Movable Type inicializará la base de datos.',
	'Select a password for your account.' => 'Seleccione una contraseña para su cuenta.',
	'System Email' => 'Correo del sistema',
	'The display name is required.' => 'El nombre público es obligatorio.',
	'The e-mail address is required.' => 'La dirección de correo electrónico es necesaria.',
	'The initial account name is required.' => 'Se necesita el nombre de la cuenta inicial.',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'La versión de Perl instalada en su servidor ([_1]) es menor que la versión mínima soporta ([_2]).',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Para proceder, debe autentificarse correctamente en su servidor LDAP.',
	'Use this as system email address' => 'Usar esta dirección de correo para el sistema',
	'View MT-Check (x)' => 'Ver MT-Check (x)',
	'Welcome to Movable Type' => 'Bienvenido a Movable Type',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Aunque Movable Type podría ejecutarse, <strong>esta configuración no está probada ni ni soportada</strong>.  Le recomendamos que actualice Perl a la versión [_1].',

## tmpl/cms/layout/dashboard.tmpl
	'Reload' => 'Recargar',
	'reload' => 'recargar',

## tmpl/cms/list_category.tmpl
	'Add child [_1]' => 'Añadir [_1] hijo',
	'Alert' => 'Alerta',
	'Are you sure you want to remove [_1] [_2] with [_3] sub [_4]?' => '¿Está seguro de que desea borrar [_1] [_2] con [_3] sub [_4]?',
	'Are you sure you want to remove [_1] [_2]?' => '¿Está seguro de que desea borrar [_1] [_2]?',
	'Basename is required.' => 'El nombre base es obligatorio.',
	'Change and move' => 'Cambiar y trasladar',
	'Duplicated basename on this level.' => 'Nombre base duplicado en este nivel.',
	'Duplicated label on this level.' => 'Etiqueta duplicada en este nivel.',
	'Invalid Basename.' => 'Nombre base no válido.',
	'Label is required.' => 'La etiqueta es obligatoria.',
	'Label is too long.' => 'La etiqueta es muy larga.',
	'Remove [_1]' => 'Borrar [_1]',
	'Rename' => 'Renombrar',
	'Top Level' => 'Raíz',
	'[_1] label' => 'Etiqueta de [_1]',
	q{[_1] '[_2]' already exists.} => q{[_1] '[_2]' ya existe.},

## tmpl/cms/list_common.tmpl
	'<mt:var name="js_message">' => '<mt:var name="js_message">',
	'Feed' => 'Fuente',

## tmpl/cms/list_entry.tmpl
	'Entries Feed' => 'Sindicación de las entradas',
	'Pages Feed' => 'Sindicación de las páginas',
	'Quickfilters' => 'Filtros rápidos',
	'Recent Users...' => 'Usuarios recientes...',
	'Remove filter' => 'Borrar filtro',
	'Select A User:' => 'Seleccionar un usuario:',
	'Select...' => 'Seleccionar...',
	'Show only entries where' => 'Mostrar solo las entradas donde',
	'Show only pages where' => 'Mostrar solo las páginas donde',
	'Showing only: [_1]' => 'Mostrando solo: [_1]',
	'The entry has been deleted from the database.' => 'La entrada ha sido borrada de la base de datos.',
	'The page has been deleted from the database.' => 'La página ha sido borrada de la base de datos.',
	'User Search...' => 'Buscar usuario...',
	'[_1] (Disabled)' => '[_1] (Desactivado)',
	'[_1] where [_2] is [_3]' => '[_1] donde [_2] es [_3]',
	'asset' => 'fichero multimedia',
	'change' => 'cambiar',
	'is' => 'es',
	'published' => 'publicado',
	'review' => 'Revisar',
	'scheduled' => 'programado',
	'spam' => 'Spam',
	'status' => 'estado',
	'tag (exact match)' => 'etiqueta (coincidencia exacta)',
	'tag (fuzzy match)' => 'etiqueta (coincidencia difusa)',
	'unpublished' => 'no publicado',

## tmpl/cms/list_template.tmpl
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Nombre del conjunto de widgets&quot;$&gt;</strong>',
	'Content Type Listing Archive' => 'Archivo de lista de tipos de contenido',
	'Content type Templates' => 'Plantillas de tipo de contenidos',
	'Create new template (c)' => 'Crear nueva plantilla (c)',
	'Create' => 'crear',
	'Delete selected Widget Sets (x)' => 'Borrar conjuntos de widgets seleccionados (x)',
	'Entry Archive' => 'Archivo de entradas',
	'Entry Listing Archive' => 'Archivo de lista de entradas',
	'Helpful Tips' => 'Consejos útiles',
	'No widget sets could be found.' => 'No se ha encontrado ningún grupo de widgets.',
	'Page Archive' => 'Archivo de páginas',
	'Publishing Settings' => 'Configuración de publicación',
	'Select template type' => 'Seleccionar un tipo de plantilla',
	'Selected template(s) has been copied.' => 'Se han publicado las plantillas seleccionadas.',
	'Show All Templates' => 'Mostrar todas las plantillas',
	'Template Module' => 'Módulo de plantilla',
	'To add a widget set to your templates, use the following syntax:' => 'Para añadir un conjunto de widgets a las plantillas, utilice la siguiente sintaxis:',
	'You have successfully deleted the checked template(s).' => 'Se eliminaron correctamente las plantillas marcadas.',
	'You have successfully refreshed your templates.' => 'Ha refrescado con éxito las plantillas.',
	'Your templates have been published.' => 'Se han publicado las plantillas.',

## tmpl/cms/list_theme.tmpl
	'All Themes' => 'Todos los temas',
	'Author: ' => 'Autor: ',
	'Available Themes' => 'Temas disponibles',
	'Current Theme' => 'Tema actual',
	'Errors' => 'Errores',
	'Failed' => 'Falló',
	'Find Themes' => 'Buscar temas',
	'No themes are installed.' => 'No hay temas instalados.',
	'Portions of this theme cannot be applied to the child site. [_1] elements will be skipped.' => 'Algunas partes de este tema no pueden aplicarse al sitio hijo. Se ignorarán [_1] elementos.',
	'Portions of this theme cannot be applied to the site. [_1] elements will be skipped.' => 'Algunas partes de este tema no pueden aplicarse al sitio. Se ignorarán [_1] elementos.',
	'Reapply' => 'Re-aplicar',
	'Theme Errors' => 'Errores de tema',
	'Theme Information' => 'Información del tema',
	'Theme Warnings' => 'Avisos de tema',
	'Theme [_1] has been applied (<a href="[_2]" class="alert-link">[quant,_3,warning,warnings]</a>).' => 'El tema [_1] se ha aplicado (<a href="[_2]" class="alert-link">[quant,_3,aviso,avisos]</a>).',
	'Theme [_1] has been applied.' => 'El tema [_1] se ha aplicado.',
	'Theme [_1] has been uninstalled.' => 'El tema [_1] se ha desinstalado.',
	'Themes in Use' => 'Temas utilizados',
	'This theme cannot be applied to the child site due to [_1] errors' => 'Este tema no puede aplicarse al sitio hijo debido a [_1] errores',
	'This theme cannot be applied to the site due to [_1] errors' => 'Este tema no puede aplicarse al sitio debido a [_1] errores',
	'Uninstall' => 'Desinstalar',
	'Warnings' => 'Avisos',
	'[quant,_1,warning,warnings]' => '[quant,_1,aviso,avisos]',
	'_THEME_DIRECTORY_URL' => 'https://plugins.movabletype.org/',

## tmpl/cms/listing/asset_list_header.tmpl
	'You have successfully deleted the asset(s).' => 'Se borraron con éxito los ficheros multimedia seleccionados.',
	q{Cannot write to '[_1]'. Thumbnail of items may not be displayed.} => q{No se pudo escribir en '[_1]'. Quizás no se muestren las miniaturas.},

## tmpl/cms/listing/association_list_header.tmpl
	'You have successfully granted the given permission(s).' => 'Revocó los permisos con éxito.',
	'You have successfully revoked the given permission(s).' => 'Otorgó los permisos con éxito.',

## tmpl/cms/listing/author_list_header.tmpl
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => 'Algunos ([_1]) de los usuarios seleccionados no pudieron rehabilitarse porque ya no se encuentra en el directorio externo.',
	'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Advanced.' => 'Este usuario borrado aún existe en el directorio externo. Como tal, aún podrán acceder a Movable Type Advanced.',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'Ha borrado con éxito el/los usuario/s seleccionado/s del sistema de Movable Type.',
	'You have successfully disabled the selected user(s).' => 'Ha deshabilitado con éxito el/los usuario/s seleccionado/s.',
	'You have successfully enabled the selected user(s).' => 'Ha habilitado con éxito el/los usuario/s seleccionado/s.',
	'You have successfully unlocked the selected user(s).' => 'Ha desbloqueado con éxito el/los usuario/s seleccionado/s.',
	q{An error occurred during synchronization.  See the <a href='[_1]' class="alert-link">activity log</a> for detailed information.} => q{Ocurrió un error durante la sincronización. Compruebe el <a href='[_1]' class="alert-link">registro de actividad</a> para más detalles.},
	q{Some ([_1]) of the selected user(s) could not be re-enabled because they had some invalid parameter(s). Please check the <a href='[_2]' class="alert-link">activity log</a> for more details.} => q{Algunos ([_1]) de los usuarios seleccionados no se pudieron re-habilitar porque tenían algunos parámetros no válidos. Por favor, compruebe el <a href='[_2]' class="alert-link">registro de actividad</a> para más detalles.},
	q{You have successfully synchronized users' information with the external directory.} => q{Sincronizó con éxito la información de los usuarios con el directorio externo.},

## tmpl/cms/listing/banlist_list_header.tmpl
	'Invalid IP address.' => 'Dirección IP no válida.',
	'The IP you entered is already banned for this site.' => 'La IP que introdujo ya está bloqueada en este sitio.',
	'You have added [_1] to your list of banned IP addresses.' => 'Agregó [_1] a su lista de direcciones IP bloqueadas.',
	'You have successfully deleted the selected IP addresses from the list.' => 'Eliminó correctamente las direcciones IP seleccionadas.',

## tmpl/cms/listing/blog_list_header.tmpl
	'Warning: You need to copy uploaded assets to new locations manually. You should consider maintaining copies of uploaded assets in their original locations to avoid broken links.' => 'Aviso: Debe copiar manualmente los ficheros multimedia asociados a nueva ruta. Estudie mantener una copia de los ficheros en su lugar original para evitar romper enlaces.',
	'You have successfully deleted the child site from the site. The files still exist in the site path. Please delete files if not needed.' => 'Ha borrado con éxito el sitio hijo del sistema de Movable Type. Los ficheros aún se encuentran en la ruta. Por favor, borre los ficheros si no son necesarios.',
	'You have successfully deleted the site from the Movable Type system. The files still exist in the site path. Please delete files if not needed.' => 'Ha borrado con éxito el sitio del sistema de Movable Type. Los ficheros aún se encuentran en la ruta. Por favor, borre los ficheros si no son necesarios.',
	'You have successfully moved selected child sites to another site.' => 'Ha movido con éxito los sitios hijos seleccionados a otro sitio.',

## tmpl/cms/listing/category_set_list_header.tmpl
	'Some category sets were not deleted. You need to delete categories fields from the category set first.' => 'No se borraron algunos de los conjuntos de categorías. Primero debe borrar los campos de categorías del conjunto de categorías.',

## tmpl/cms/listing/comment_list_header.tmpl
	'All comments reported as spam have been removed.' => 'Se ha borrado los comentarios marcados como spam.',
	'No comments appear to be spam.' => 'Ningún comentario parece que sea basura.',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be banned or trusted.' => 'Uno o más comentarios de los que seleccionó fueron enviados por un comentarista no autentificado. No se puede bloquear o dar confianza a estos comentaristas.',
	'The selected comment(s) has been approved.' => 'Se ha aprobado los comentarios seleccionados.',
	'The selected comment(s) has been deleted from the database.' => 'Los comentarios seleccionados fueron eliminados de la base de datos.',
	'The selected comment(s) has been recovered from spam.' => 'Se ha recuperado del spam los comentarios seleccionados.',
	'The selected comment(s) has been reported as spam.' => 'Se ha marcado como spam los comentarios seleccionados.',
	'The selected comment(s) has been unapproved.' => 'Se ha desaprobado los comentarios seleccionados.',

## tmpl/cms/listing/content_data_list_header.tmpl
	'The content data has been deleted from the database.' => 'Los datos de contenido han sido borrados de la base de datos.',

## tmpl/cms/listing/content_type_list_header.tmpl
	'Some content types were not deleted. You need to delete archive templates or content type fields from the content type first.' => 'No se borraron algunos tipos de contenido. Primero debe borrar las plantillas de archivo o los campos de tipos de contenido del tipo de contenido.',
	'The content type has been deleted from the database.' => 'El tipo de contenido ha sido borrado de la base de datos.',

## tmpl/cms/listing/group_list_header.tmpl
	'You successfully deleted the groups from the Movable Type system.' => 'Borró con éxito los grupos del sistema Movable Type.',
	'You successfully disabled the selected group(s).' => 'Deshabilitó con éxito los grupos seleccionados.',
	'You successfully enabled the selected group(s).' => 'Habilitó con éxito los grupos seleccionados.',
	q{An error occurred during synchronization.  See the <a href='[_1]'>activity log</a> for detailed information.} => q{Ocurrió un error durante la sincronización. Para información más detallada, consulte el <a href='[_1]'>registro de actividad</a>.},
	q{You successfully synchronized the groups' information with the external directory.} => q{Sincronizó con éxito la información de los grupos con el directorio externo.},

## tmpl/cms/listing/group_member_list_header.tmpl
	'Some ([_1]) of the selected users could not be re-enabled because they are no longer found in LDAP.' => 'No se pudo rehabilitar alguno ([_1]) de los usuarios seleccionados porque ya no se encuentran en LDAP.',
	'You successfully added new users to this group.' => 'Añadió nuevos usuarios al grupo con éxito.',
	'You successfully deleted the users.' => 'Borró los usuarios con éxito.',
	'You successfully removed the users from this group.' => 'Ha borrado con éxito a los usuarios del grupo.',
	q{You successfully synchronized users' information with the external directory.} => q{Sincronizó con éxito la información de los usuarios con el directorio externo.},

## tmpl/cms/listing/log_list_header.tmpl
	'All times are displayed in GMT.' => 'Todas las fechas se muestran en GMT.',
	'All times are displayed in GMT[_1].' => 'Todas las horas se muestran en GMT[_1].',

## tmpl/cms/listing/notification_list_header.tmpl
	'You have added new contact to your address book.' => 'Ha añadido un nuevo contacto.',
	'You have successfully deleted the selected contacts from your address book.' => 'Ha borrado con éxito los contactos seleccionados de su agenda.',
	'You have updated your contact in your address book.' => 'Ha actualizado el contacto.',

## tmpl/cms/listing/ping_list_header.tmpl
	'All TrackBacks reported as spam have been removed.' => 'Se han elimitado todos los TrackBacks marcadoscomo spam.',
	'No TrackBacks appeared to be spam.' => 'Ningún TrackBacks parece ser spam.',
	'The selected TrackBack(s) has been approved.' => 'Se han aprobado los TrackBacks seleccionados.',
	'The selected TrackBack(s) has been deleted from the database.' => 'Se eliminaron de la base de datos los TrackBacks seleccionados.',
	'The selected TrackBack(s) has been recovered from spam.' => 'Se han recuperado del spam los TrackBacks seleccionados.',
	'The selected TrackBack(s) has been reported as spam.' => 'Se han marcado como spam los TrackBacks seleccionados.',
	'The selected TrackBack(s) has been unapproved.' => 'Se han desaprobado los TrackBacks seleccionados.',

## tmpl/cms/listing/role_list_header.tmpl
	'You have successfully deleted the role(s).' => 'Ha borrado con éxito el/los rol/es.',

## tmpl/cms/listing/tag_list_header.tmpl
	'Specify new name of the tag.' => 'Nuevo nombre especifíco de la etiqueta',
	'You have successfully deleted the selected tags.' => 'Se borraron con éxito las etiquetas especificadas.',
	'Your tag changes and additions have been made.' => 'Se han realizado los cambios y añadidos a las etiquetas especificados.',
	q{The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]' across all blogs?} => q{La etiqueta '[_2]' ya existe.  ¿Está seguro de querer combinar '[_1]' con '[_2]' en todos los blogs?},

## tmpl/cms/login.tmpl
	'Forgot your password?' => '¿Olvidó su contraseña?',
	'Sign In (s)' => 'Identifíquese (s)',
	'Sign in' => 'Registrarse',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Su sesión de Movable Type finalizó. Si desea identificarse de nuevo, hágalo abajo.',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Su sesión de Movable Type finalizó. Por favor, identifíquese de nuevo para continuar con esta acción.',
	'Your Movable Type session has ended.' => 'Finalizó su sesión en Movable Type.',

## tmpl/cms/not_implemented_yet.tmpl
	'Not implemented yet.' => 'Aún no está implementado.',

## tmpl/cms/pinging.tmpl
	'Pinging sites...' => 'Enviando pings a sitios...',
	'Trackback' => 'TrackBack',

## tmpl/cms/popup/pinged_urls.tmpl
	'Failed Trackbacks' => 'TrackBacks sin éxito',
	'Successful Trackbacks' => 'TrackBacks con éxito',
	'To retry, include these TrackBacks in the Outbound TrackBack URLs list for your entry.' => 'Para reintentarlo, incluya estos TrackBacks en la lista de URLs de TrackBacs salientes de la entrada.',

## tmpl/cms/popup/rebuild_confirm.tmpl
	'All Files' => 'Todos los ficheros',
	'Index Template: [_1]' => 'Plantilla índice: [_1]',
	'Only Indexes' => 'Solamente índices',
	'Only [_1] Archives' => 'Solamente archivos [_1]',
	'Publish (s)' => 'Publicar (s)',
	'Publish <em>[_1]</em>' => 'Publicar <em>[_1]</em>',
	'Publish [_1]' => 'Publicar [_1]',
	'_REBUILD_PUBLISH' => 'Publicar',

## tmpl/cms/popup/rebuilt.tmpl
	'Publish Again (s)' => 'Publicar otra vez (s)',
	'Publish Again' => 'Publicar otra vez.',
	'Publish time: [_1].' => 'Tiempo de publicación: [_1].',
	'Success' => 'OK',
	'The files for [_1] have been published.' => 'Los ficheros de [_1] han sido publicados.',
	'View this page.' => 'Ver página.',
	'View your site.' => 'Ver sitio.',
	'Your [_1] archives have been published.' => 'Se han publicado los archivos [_1].',
	'Your [_1] templates have been published.' => 'Se han publicado las plantillas [_1].',

## tmpl/cms/preview_content_data.tmpl
	'Preview [_1] Content' => 'Vista previa del contenido de [_1]',
	'Re-Edit this [_1] (e)' => 'Re-editar este [_1] (e)',
	'Re-Edit this [_1]' => 'Re-editar este [_1]',
	'Return to the compose screen (e)' => 'Regresar a la ventana de composición (e)',
	'Return to the compose screen' => 'Regresar a la ventana de composición',
	'Save this [_1] (s)' => 'Guardar este [_1] (s)',

## tmpl/cms/preview_content_data_strip.tmpl
	'Publish this [_1] (s)' => 'Publicar este [_1] (s)',
	'You are previewing &ldquo;[_1]&rdquo; content data entitled &ldquo;[_2]&rdquo;' => 'Esta es una vista previa de &ldquo;[_1]&rdquo; datos de contenido designados &ldquo;[_2]&rdquo;',

## tmpl/cms/preview_entry.tmpl
	'Re-Edit this entry (e)' => 'Re-editar entrada (e)',
	'Re-Edit this entry' => 'Re-editar entrada',
	'Re-Edit this page (e)' => 'Re-editar página (e)',
	'Re-Edit this page' => 'Re-editar página',
	'Save this entry (s)' => 'Guardar entrada (s)',
	'Save this entry' => 'Guardar entrada',
	'Save this page (s)' => 'Guardar página (s)',
	'Save this page' => 'Guardar página',

## tmpl/cms/preview_strip.tmpl
	'Publish this entry (s)' => 'Publicar entrada (s)',
	'Publish this entry' => 'Publicar entrada',
	'Publish this page (s)' => 'Publicar página (s)',
	'Publish this page' => 'Publicar página',
	'You are previewing the entry entitled &ldquo;[_1]&rdquo;' => 'Está en la vista previa de la entrada titulada &ldquo;[_1]&rdquo;',
	'You are previewing the page entitled &ldquo;[_1]&rdquo;' => 'Está en la vista previa de la página titulada &ldquo;[_1]&rdquo;',

## tmpl/cms/preview_template_strip.tmpl
	'(Publish time: [_1] seconds)' => '(Tiempo de publicación: [_1] segundos)',
	'Re-Edit this template (e)' => 'Re-editar plantilla (e)',
	'Re-Edit this template' => 'Re-editar plantilla',
	'Save this template (s)' => 'Guardar plantilla (s)',
	'Save this template' => 'Guardar plantilla',
	'There are no categories in this blog.  Limited preview of category archive templates is possible with a virtual category displayed.  Normal, non-preview output cannot be generated by this template unless at least one category is created.' => 'No hay categorías en este blog. La vista previa de plantillas de archivo de categorías es posible mediante una categoría virtual. La salida normal, que no es vista previa, no puede generarse mediante esta plantilla a menos que cree una categoría.',
	'You are previewing the template named &ldquo;[_1]&rdquo;' => 'Esta es la vista previa de la plantilla &ldquo;[_1]&rdquo;',

## tmpl/cms/rebuilding.tmpl
	'Complete [_1]%' => '[_1]% completado',
	'Publishing <em>[_1]</em>...' => 'Publicando <em>[_1]</em>...',
	'Publishing [_1] [_2]...' => 'Publicando [_1] [_2]...',
	'Publishing [_1] archives...' => 'Publicando archivos [_1]...',
	'Publishing [_1] dynamic links...' => 'Publicando enlaces dinámicos [_1]...',
	'Publishing [_1] templates...' => 'Publicando plantillas [_1]...',
	'Publishing [_1]...' => 'Publicando [_1]...',
	'Publishing...' => 'Publicando...',

## tmpl/cms/recover_lockout.tmpl
	'Recovered from lockout' => 'Recuperado del bloqueo.',
	q{User '[_1]' has been unlocked.} => q{El usuario '[_1]' ha sido desbloqueado.},

## tmpl/cms/recover_password_result.tmpl
	'No users were selected to process.' => 'No se seleccionaron usuarios a procesar.',
	'Recover Passwords' => 'Recuperar contraseñas',
	'Return' => 'Volver',

## tmpl/cms/refresh_results.tmpl
	'No templates were selected to process.' => 'No se han seleccionado plantillas para procesar.',
	'Return to templates' => 'Volver a las plantillas',

## tmpl/cms/restore.tmpl
	'Exported File' => 'Fichero exportado',
	'Import (i)' => 'Importar (i)',
	'Import from Exported file' => 'Importar de fichero exportado',
	'Overwrite global templates.' => 'Sobreescribir las plantillas globales.',
	'Perl module XML::SAX and/or some of its dependencies are missing.  Movable Type cannot restore the system without these modules.' => 'No se encuentra el módulo de Perl XML::SAX y/o algunas de sus dependencias. Movable Type no puede restaurar el sistema sin estos módulos.',

## tmpl/cms/restore_end.tmpl
	'An error occurred during the import process: [_1] Please check activity log for more details.' => 'Ocurrió un error durante el proceso de importación: [_1] Por favor, compruebe el registro de actividad para más detalles.',

## tmpl/cms/restore_start.tmpl
	'Importing Movable Type' => 'Importando Movable Type',

## tmpl/cms/search_replace.tmpl
	'(search only)' => '(solo búsqueda)',
	'Case Sensitive' => 'Distinguir mayúsculas y minúsculas',
	'Date Range' => 'Rango de fechas',
	'Date/Time Range' => 'Rango fecha/hora',
	'Limited Fields' => 'Campos limitados',
	'Regex Match' => 'Expresión regular',
	'Replace Checked' => 'Reemplazar selección',
	'Replace With' => 'Reemplazar con',
	'Reported as Spam?' => '¿Marcado como spam?',
	'Search &amp; Replace' => 'Buscar &amp; Reemplazar',
	'Search Again' => 'Buscar de nuevo',
	'Search For' => 'Buscar',
	'Show all matches' => 'Mostrar todos los resultados',
	'Showing first [_1] results.' => 'Primeros [_1] resultados.',
	'Submit search (s)' => 'Buscar (s)',
	'Successfully replaced [quant,_1,record,records].' => '[quant,_1,registro reemplazado,registros reemplazados] con éxito.',
	'You must select one or more items to replace.' => 'Debe seleccionar uno o más elementos a reemplazar.',
	'[quant,_1,result,results] found' => '[quant,_1,resultado]',
	'_DATE_FROM' => 'De',
	'_DATE_TO' => 'A',
	'_TIME_FROM' => 'Desde',
	'_TIME_TO' => 'Hasta',

## tmpl/cms/system_check.tmpl
	'Memcached Server is [_1].' => 'El servidor de memcached es [_1].',
	'Memcached Status' => 'Estado de memcached',
	'Memcached is [_1].' => 'Memcached está [_1]',
	'Server Model' => 'Modelo de servidor',
	'Total Users' => 'Usuarios Totales',
	'available' => 'disponible',
	'configured' => 'configurado',
	'disabled' => 'desactivado',
	'unavailable' => 'no disponible',
	q{Movable Type could not find the script named 'mt-check.cgi'. To resolve this issue, ensure that the mt-check.cgi script exists and that the CheckScript configuration parameter (if it is necessary) references it properly.} => q{Movable Type no pudo encontrar el script llamado 'mt-check.cgi'. Para solucionar este problema, asegúrese de que el script mt-check.cgi existe y que el parámetro de configuración CheckScript (si fuera necesario) lo referencia correctamente.},

## tmpl/cms/theme_export_replace.tmpl
	'Overwrite' => 'Sobreescribir',
	q{Export theme folder already exists '[_1]'. You can overwrite a existing theme, or cancel to change the Basename?} => q{La carpeta para la exportación del tema ya existe '[_1]'. Puede sobreescribir un tema existente, cancelar o cambiar el nombre de la carpeta.},

## tmpl/cms/upgrade.tmpl
	'Begin Upgrade' => 'Comenzar actualización',
	'Congratulations, you have successfully upgraded to Movable Type [_1].' => 'Felicidades, actualizó con éxito a Movable Type [_1].',
	'Do you want to proceed with the upgrade anyway?' => '¿Desea proceder en cualquier caso con la actualización?',
	'In addition, the following Movable Type components require upgrading or installation:' => 'Además, los siguientes componentes de Movable Type necesitan actualización o instalación:',
	'Return to Movable Type' => 'Volver a Movable Type',
	'The following Movable Type components require upgrading or installation:' => 'Los siguientes componentes de Movable Type necesitan actualización o instalación:',
	'Time to Upgrade!' => '¡Hora de actualizar!',
	'Upgrade Check' => 'Comprobar actualización',
	'Your Movable Type installation is already up to date.' => 'Su instalación de Movable Type ya está actualizada.',
	q{A new version of Movable Type has been installed.  We'll need to complete a few tasks to update your database.} => q{Se ha instalado una nueva versión de Movable Type.  Debemos realizar algunas tareas para actualizar su base de datos.},
	q{The Movable Type Upgrade Guide can be found <a href='[_1]' target='_blank'>here</a>.} => q{La Guía de Actualización de Movable Type se encuentra <a href='[_1]' target='_blank'>aquí</a>.},

## tmpl/cms/upgrade_runner.tmpl
	'Error during installation:' => 'Error durante la instalación:',
	'Error during upgrade:' => 'Error durante la actualización:',
	'Initializing database...' => 'Inicializando base la de datos...',
	'Installation complete!' => '¡Instalación finalizada!',
	'Return to Movable Type (s)' => 'Volver a Movable Type (s)',
	'Upgrade complete!' => '¡Actualización finalizada!',
	'Upgrading database...' => 'Actualizando la base de datos...',
	'Your database is already current.' => 'Su base de datos está al día.',

## tmpl/cms/view_log.tmpl
	'Download Filtered Log (CSV)' => 'Descargar registro filtrado (CSV)',
	'Filtered Activity Feed' => 'Sindicación de la actividad del filtrado',
	'Filtered' => 'Filtrado',
	'Show log records where' => 'Mostrar registros donde',
	'Showing all log records' => 'Mostrando todos los registros',
	'Showing log records where' => 'Mostrando los registros donde',
	'System Activity Log' => 'Registro de Actividad del Sistema',
	'The activity log has been reset.' => 'Se reinició el registro de actividad.',
	'classification' => 'clasificación',
	'level' => 'nivel',

## tmpl/cms/view_rpt_log.tmpl
	'Schwartz Error Log' => 'Histórico de errores de Schwartz',
	'Showing all Schwartz errors' => 'Mostrando todos los errores de Schwartz',

## tmpl/cms/widget/mt_news.tmpl
	'News' => 'Noticias',
	'No Movable Type news available.' => 'No hay noticias de Movable Type disponibles.',

## tmpl/cms/widget/notification_dashboard.tmpl
	'Messages from the system' => 'Mensajes del sistema',
	'warning' => 'Alerta',

## tmpl/cms/widget/site_list.tmpl
	'Recent Posts' => 'Entradas recientes',
	'Setting' => 'Configuración',

## tmpl/cms/widget/site_stats.tmpl
	'Statistics Settings' => 'Configuración de estadísticas',

## tmpl/cms/widget/system_information.tmpl
	'Active Users' => 'Usuarios activos',

## tmpl/cms/widget/updates.tmpl
	'Available updates (Ver. [_1]) found. Please see the <a href="[_2]" target="_blank">news</a> for detail.' => 'Actualizaciones disponibles (Ver. [_1]). Por favor, consulte las <a href="[_2]" target="_blank">noticias</a> para más detalles.',
	'Available updates ([_1]) found. Please see the <a href="[_2]" target="_blank">news</a> for detail.' => '', # Translate - New
	'Movable Type is up to date.' => 'Movable Type está actualizado.',
	'Update check failed. Please check server network settings.' => 'Falló la comprobación de actualizaciones. Por favor, compruebe la configuración de red del servidor.',
	'Update check is disabled.' => 'Las comprobaciones de actualizaciones están deshabilitadas.',

## tmpl/comment/error.tmpl
	'Back (s)' => 'Regresar (s)',

## tmpl/comment/login.tmpl
	'Not a member? <a href="[_1]">Sign Up</a>!' => '¿No es miembro? ¡<a href="[_1]">Regístrese</a>!',
	'Sign in to comment' => 'Identifíquese para comentar',
	'Sign in using' => 'Identifíquese usando',

## tmpl/comment/profile.tmpl
	'Return to the <a href="[_1]">original page</a>.' => 'Volver a la <a href="[_1]">página original</a>.',
	'Select a password for yourself.' => 'Seleccione su contraseña.',
	'Your Profile' => 'Su perfil',

## tmpl/comment/signup.tmpl
	'Create an account' => 'Crear una cuenta',
	'Password Confirm' => 'Confirmar contraseña',
	'Register' => 'Registrarse',

## tmpl/comment/signup_thanks.tmpl
	'Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].' => 'Antes de poder comentar, debe completar el proceso de registro confirmando su cuenta. Se le ha enviado un correo a [_1].',
	'Return to the original entry.' => 'Volver a la entrada original.',
	'Return to the original page.' => 'Volver a la página original.',
	'Thanks for signing up' => 'Gracias por inscribirse',
	'To complete the registration process you must first confirm your account. An email has been sent to [_1].' => 'Para completar el proceso de registro, primeramente debe confirmar su cuenta. Se le ha enviado un correo a [_1].',
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'Para confirmar y activar su cuenta, por favor, compruebe su correo y haga clic en el correo que le acabamos de enviar.',

## tmpl/error.tmpl
	'CGI Path Configuration Required' => 'Se necesita la configuración de la ruta de CGI',
	'Database Connection Error' => 'Error de conexión a la base de datos',
	'Missing Configuration File' => 'Fichero de configuración no encontrado',
	'_ERROR_CGI_PATH' => 'La opción de configuración CGIPath no es válida o no se encuentra en el fichero de configuración de Movable Type. Por favor, consulte la sección <a href="javascript:void(0)">Instalación y configuración</a> del manual de Movable Type manual para más información.',
	'_ERROR_CONFIG_FILE' => 'El fichero de configuración de Your Movable Type no existe o no se puede leer correctamente. Por favor, consulte la sección <a href="javascript:void(0)">Instalación y configuración</a> del manual de Movable Type manual para más información.',
	'_ERROR_DATABASE_CONNECTION' => 'Las opciones de configuración de su base de datos o son incorrectas o no están presentes en el fichero de configuración de Movable Type. Por favor, consulte la sección <a href="javascript:void(0)">Instalación y configuración</a> del manual de Movable Type para más información',

## tmpl/feeds/error.tmpl
	'Movable Type Activity Log' => 'Registro de actividad de Movable Type',

## tmpl/feeds/feed_comment.tmpl
	'By commenter URL' => 'Por URL del comentarista',
	'By commenter email' => 'Por correo electrónico del comentarista',
	'By commenter identity' => 'Por identidad del comentarista',
	'By commenter name' => 'Por nombre del comentarista',
	'From this [_1]' => 'De este [_1]',
	'More like this' => 'Más como éstos',
	'On this day' => 'En este día',
	'On this entry' => 'En esta entrada',

## tmpl/feeds/feed_content_data.tmpl
	'From this author' => 'De este autor',

## tmpl/feeds/feed_ping.tmpl
	'By source URL' => 'Por URL origen',
	'By source blog' => 'Por blog origen',
	'By source title' => 'Por título origen',
	'Source [_1]' => '[_1] origen',

## tmpl/feeds/login.tmpl
	'This link is invalid. Please resubscribe to your activity feed.' => 'Este enlace no es válido. Por favor, resuscríbase a la fuente de sindicación de actividades.',

## tmpl/wizard/cfg_dir.tmpl
	'TempDir is required.' => 'TempDir es necesario.',
	'TempDir' => 'TempDir',
	'Temporary Directory Configuration' => 'Configuración del directorio temporal',
	'You should configure your temporary directory settings.' => 'Debería configurar las opciones de directorio temporal.',
	'[_1] could not be found.' => '[_1] no pudo encontrarse.',
	q{Your TempDir has been successfully configured. Click 'Continue' below to continue configuration.} => q{TempDir se ha configurado con éxito. Para continuar con la configuración, haga clic a 'Continuar' abajo.},

## tmpl/wizard/complete.tmpl
	'Configuration File' => 'Archivo de configuración',
	'Retry' => 'Reintentar',
	'Show the mt-config.cgi file generated by the wizard' => 'Mostrar el archivo mt-config.cgi generado por el asistente de instalación',
	'The [_1] configuration file cannot be located.' => 'El archivo de configuración [_1] no puede ser localizado',
	'The mt-config.cgi file has been created manually.' => 'El fichero mt-config.cgi fue creado manualmente.',
	'The wizard was unable to save the [_1] configuration file.' => 'El asistente de instalación no ha podido guardar el [_1] archivo de configuración.',
	q{Confirm that your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click 'Retry'.} => q{Confirme que el servidor web puede escribir en su directorio de inicio [_1] (el directorio que contiene mt.cgi) y luego haga clic en 'Reintentar'.},
	q{Congratulations! You've successfully configured [_1].} => q{¡Felicidades! Ha configurado con éxito [_1].},
	q{Please use the configuration text below to create a file named 'mt-config.cgi' in the root directory of [_1] (the same directory in which mt.cgi is found).} => q{Utilice por favor el texto de la configuración abajo para crear un archivo llamado 'mt-config.cgi' en la raíz del directorio de [_1] (el mismo directorio en el cual se encuentra mt.cgi).},

## tmpl/wizard/configure.tmpl
	'Database Configuration' => 'Configuración de la base de datos',
	'Database Type' => 'Tipo de base de datos',
	'Is your preferred database not listed? View the <a href="[_1]" target="_blank">Movable Type System Check</a> see if additional modules are necessary.' => '¿Su base de datos preferida no está en la lista? Consulte la <a href="[_1]" target="_blank">Comprobación del Sistema de Movable Type</a> para ver si se necesitan otros módulos.',
	'Once installed, <a href="javascript:void(0)" onclick="[_1]">click here to refresh this screen</a>.' => 'Una vez instalado, haga <a href="javascript:void(0)" onclick="[_1]">clic aquí para recargar esta pantalla</a>.',
	'Please enter the parameters necessary for connecting to your database.' => 'Por favor, introduzca los parámetros necesarios para la conexión con la base de datos.',
	'Read more: <a href="[_1]" target="_blank">Setting Up Your Database</a>' => 'Más información: <a href="[_1]" target="_blank">Configuración de la base de datos</a>',
	'Select One...' => 'Seleccione uno...',
	'Show Advanced Configuration Options' => 'Mostrar opciones de configuración avanzadas',
	'Show Current Settings' => 'Mostrar configuración actual',
	'Test Connection' => 'Probar la Conexión',
	'You may proceed to the next step.' => 'Puede continuar con el siguiente paso.',
	'You must set your Database Path.' => 'Debe definir la ruta de la base de datos.',
	'You must set your Database Server.' => 'Debe introducir el servidor de base de datos.',
	'You must set your Username.' => 'Debe introducir el nombre del usuario.',
	'Your database configuration is complete.' => 'Se ha completado la configuración de la base de datos.',
	'https://www.movabletype.org/documentation/[_1]' => 'https://www.movabletype.org/documentation/[_1]',

## tmpl/wizard/optional.tmpl
	'Address of your SMTP Server.' => 'Dirección del servidor SMTP.',
	'An error occurred while attempting to send mail: ' => 'Ocurrió un error intentando enviar un mensaje de correo electrónico: ',
	'Cannot use [_1].' => 'No se puede usar [_1].',
	'Check your email to confirm receipt of a test email from Movable Type and then proceed to the next step.' => 'Compruebe su correo para confirmar la recepción del mensaje de prueba de Movable Type y luego continúe con el paso siguiente.',
	'Do not use SSL' => 'No usar SSL',
	'Mail Configuration' => 'Configuración del correo electrónico',
	'Mail address to which test email should be sent' => 'La dirección de correo a la que debe enviarse el correo de prueba',
	'Outbound Mail Server (SMTP)' => 'Servidor de correo saliente (SMTP)',
	'Password for your SMTP Server.' => 'Contraseña para el servidor SMTP.',
	'Periodically Movable Type will send email for password recovery, to inform authors of new comments, and other events. If not using Sendmail (default on unix servers), an SMTP Server must be specified.' => 'Periódicamente, Movable Type enviará un correo para informar a los usuarios sobre los nuevos comentarios y otros eventos. Para que estos correos se envíen correctamente, debe decirle a Movable Type cómo enviarlos.',
	'Port number for Outbound Mail Server' => 'Número de puerto para el servidor de correo saliente',
	'Port number of your SMTP Server.' => 'Número de puerto para el servidor SMTP.',
	'SMTP Auth Password' => 'Contraseña de autentificación SMTP',
	'SMTP Auth Username' => 'Usuario para autentificación SMTP',
	'SSL Connection' => 'Conexión SSL',
	'Send Test Email' => 'Enviar mensaje de comprobación',
	'Send mail via:' => 'Enviar correo vía:',
	'Sendmail Path' => 'Ruta de sendmail',
	'Show current mail settings' => 'Mostrar configuración actual del correo',
	'Skip' => 'Ignorar',
	'This field must be an integer.' => 'Este campo debe ser un número entero.',
	'Use SMTP Auth' => 'Usar autentificación SMTP',
	'Use SSL' => 'Usar SSL',
	'Use STARTTLS' => 'Usar STARTTLS',
	'Username for your SMTP Server.' => 'Usuario para el servidor SMTP.',
	'You must set a password for the SMTP server.' => 'Debe indicar la contraseña del servidor SMTP.',
	'You must set a username for the SMTP server.' => 'Debe indicar el usuario del servidor SMTP.',
	'You must set the SMTP server address.' => 'Debe indicar la dirección del servidor SMTP.',
	'You must set the SMTP server port number.' => 'Debe indicar el puerto del servidor SMTP.',
	'You must set the Sendmail path.' => 'Debe indicar la ruta a sendmail.',
	'You must set the system email address.' => 'Debe indicar la dirección de correo del sistema.',
	'Your mail configuration is complete.' => 'Se ha completado la configuración del correo.',

## tmpl/wizard/packages.tmpl
	'All required Perl modules were found.' => 'Se encontraron todos los módulos de Perl necesarios.',
	'Learn more about installing Perl modules.' => 'Más información sobre la instalación de módulos de Perl.',
	'Minimal version requirement: [_1]' => 'Versión mínima requerida: [_1]',
	'Missing Database Modules' => 'Módulos de base de datos no encontrados',
	'Missing Optional Modules' => 'Módulos opcionales no encontrados',
	'Missing Required Modules' => 'Módulos necesarios no encontrados',
	'One or more Perl modules required by Movable Type could not be found.' => 'No se encontraron uno o varios módulos de Perl necesarios.',
	'Requirements Check' => 'Comprobación de requerimientos',
	'Some optional Perl modules could not be found. <a href="javascript:void(0)" onclick="[_1]">Display list of optional modules</a>' => 'No se encontraron algunos módulos opcionales de Perl. <a href="javascript:void(0)" onclick="[_1]">Mostrar lista de módulos opcionales</a>',
	'You are ready to proceed with the installation of Movable Type.' => 'Está listo para continuar con la instalación de Movable Type.',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'El servidor tiene instalados todos los módulos necesarios; no necesita realizar ninguna instalación adicional.',
	'https://www.movabletype.org/documentation/installation/perl-modules.html' => 'https://www.movabletype.org/documentation/installation/perl-modules.html',
	q{Some optional Perl modules could not be found. You may continue without installing these optional Perl modules. They may be installed at any time if they are needed. Click 'Retry' to test for the modules again.} => q{No se encontraron algunos módulos opcionales de Perl. Puede continuar sin instalarlos. Podrá instalarlos cuando le sean necesarios. Haga clic en 'Reintentar' para comprobar los módulos otra vez.},
	q{The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the 'Retry' button to re-test for these packages.} => q{Los siguientes módulos de Perl son necesarios para que Movable Type se ejecute correctamente. Una vez los haya instalado, haga clic en el botón 'Reintentar' para realizar la comprobación nuevamente.},
	q{The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your data of sites and child sites.  Please install one of the packages listed here in order to proceed.  When you are ready, click the 'Retry' button.} => q{Los siguientes módulos de Perl son necestarios para establecer una conexión con la base de datos. Movable Type necesita una base de datos para guardar los datos de los sitios y sitios hijos. Por favor, instale los paquetes listados aquí para poder continuar. Luego, pulse en el botón 'Reintentar'.},

## tmpl/wizard/start.tmpl
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => 'Una configuración del archivo (mt-config,cgi) existe, <a href="[_1]">identificarse</a> a Movable Type.',
	'Begin' => 'Comenzar',
	'Configuration File Exists' => 'Configuración de archivos existentes',
	'Configure Static Web Path' => 'Configurar ruta del web estático',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Movable Type necesita que JavaScript esté disponible en el navegador. Por favor, active JavaScript y recargue esta página para continuar.',
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type viene con un directorio llamado [_1] que contiene una serie de ficheros importantes tales como imágenes, ficheros javascript y hojas de estilo.',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => 'Especifique debajo la ruta cuando el directorio [_1] sea accesible vía web.',
	'Static file path' => 'Ruta estática de los ficheros',
	'Static web path' => 'Ruta estática del web',
	'This URL path can be in the form of [_1] or simply [_2]' => 'La dirección URL puede estar en la forma de [_1] o simplemente [_2]',
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Este directorio se ha renombrado o movido a un lugar fuera del directorio de Movable Type.',
	'This path must be in the form of [_1]' => 'Esta ruta debe tener el formato [_1]',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Este asistente le ayudará a configurar las opciones básicas necesarias para ejecutar Movable Type.',
	'To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page' => 'Para crear una nueva configuración del archivo usando Wizard, borre la configuración actual del archivo y actualice la página',
	q{<strong>Error: '[_1]' could not be found.</strong>  Please move your static files to the directory first or correct the setting if it is incorrect.} => q{<strong>Error: '[_1]' no se pudo encontrar.</strong>  Por favor, mueva los ficheros estáticos al primer directorio o corrija la configuración si no es correcta.},
	q{The [_1] directory is in the main Movable Type directory which this wizard script resides, but due to your web server's configuration, the [_1] directory is not accessible in this location and must be moved to a web-accessible location (e.g., your web document root directory).} => q{El directorio [_1] está en el directorio principal de Movable Type que recide en el script de instalación, pero depende de la configuración de su web server, el directorio [_1] no es accesible en este lugar y debe ser removido a un lugar de web accesible (e.g., su documento de raíz del directorio web)},
);

1;
