# Movable Type (r) Open Source (C) 2005-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
#
# $Id$

package MT::L10N::es;
use strict;
use utf8;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

## The following is the translation table.

%Lexicon = (

## php/lib/block.mtsethashvar.php
	'You used a [_1] tag without a valid name attribute.' => 'Usó la etiqueta [_1] sin un nombre de atributo válido.',

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '\'[_1]\' no es una función válida para un hash.',
	'\'[_1]\' is not a valid function for an array.' => '\'[_1]\' no es una función válida para un array.',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] es ilegal.',

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'avatar-[_1]-%wx%h%x',

## php/lib/function.mtsetvar.php
	'\'[_1]\' is not a hash.' => '\'[_1]\' no es un hash.',
	'Invalid index.' => 'Índice no válido.',
	'\'[_1]\' is not an array.' => '\'[_1]\' no es un array.',
	'\'[_1]\' is not a valid function.' => '\'[_1]\' no es una función válida.',

## php/lib/function.mtcommentauthorlink.php
	'Anonymous' => 'Anónimo',

## php/lib/block.mtsetvarblock.php

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/block.mtentries.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" debe usarse en combinación con el espacio de nombres.',

## php/lib/function.mtcommentreplytolink.php
	'Reply' => 'Responder',

## php/lib/function.mtentryclasslabel.php
	'page' => 'página',
	'entry' => 'entrada',
	'Page' => 'Página',
	'Entry' => 'Entrada',

## php/lib/function.mtassettype.php
	'image' => 'Imagen',
	'Image' => 'Imagen',
	'file' => 'fichero',
	'File' => 'Fichero',
	'audio' => 'Audio',
	'Audio' => 'Audio',
	'video' => 'Vídeo',
	'Video' => 'Vídeo',

## php/lib/function.mtwidgetmanager.php
	'Error: widgetset [_1] is empty.' => 'Error: el conjunto de widgets [_1] está vacío',
	'Error compiling widgetset [_1]' => 'Error compilando el conjunto de widgets [_1]',

## php/lib/function.mtcommentauthor.php

## php/lib/archive_lib.php
	'Individual' => 'Inidivual',
	'Yearly' => 'Anuales',
	'Monthly' => 'Mensuales',
	'Daily' => 'Diarias',
	'Weekly' => 'Semanales',
	'Author' => 'Por Autor',
	'(Display Name not set)' => '(Nombre no configurado)',
	'Author Yearly' => 'Anuales del autor',
	'Author Monthly' => 'Mensuales del autor',
	'Author Daily' => 'Diarios del autor',
	'Author Weekly' => 'Semanales del autor',
	'Category Yearly' => 'Categorías anuales',
	'Category Monthly' => 'Categorías mensuales',
	'Category Daily' => 'Categorías diarias',
	'Category Weekly' => 'Categorías semanales',

## php/lib/block.mtauthorhaspage.php
	'No author available' => 'Ningún autor disponible',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Introduzca los caracteres que ve en la imagen de arriba.',

## php/lib/block.mtif.php

## php/lib/block.mtauthorhasentry.php

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'La autentificación de TypePad no está habilitada en este blog. No se puede usar MTRemoteSignInLink.',

## php/lib/block.mtassets.php

## php/lib/function.mtauthordisplayname.php

## php/mt.php
	'Page not found - [_1]' => 'Página no encontrada - [_1]',

## mt-check.cgi
	'Movable Type System Check' => 'Comprobación del sistema - Movable Type',
	'The mt-check.cgi script provides you with information on your system\'s configuration and determines whether you have all of the components you need to run Movable Type.' => 'El script mt-check.cgi le ofrece información sobre la configuración del sistema y determina si posee todos los componentes necesarios para ejecutar Movable Type.',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). Please upgrade to at least Perl [_2].' => 'La versión de Perl instalada en su servidor ([_1]) es menor que la versión mínima soportada ([_2]). Por favor, actualícese por lo menos a Perl [_2].',
	'Movable Type configuration file was not found.' => 'No se encontró el fichero de configuración de Movable Type.',
	'System Information' => 'Información del sistema',
	'Movable Type version:' => 'Versión de Movable Type:',
	'Current working directory:' => 'Directorio actual de trabajo:',
	'MT home directory:' => 'Directorio de inicio de MT:',
	'Operating system:' => 'Sistema operativo:',
	'Perl version:' => 'Versión de Perl:',
	'Perl include path:' => 'Ruta de búsqueda de Perl:',
	'Web server:' => 'Servidor web:',
	'(Probably) Running under cgiwrap or suexec' => '(Probablemente) Ejecución bajo cgiwrap o suexec',
	'[_1] [_2] Modules' => 'Módulos [_1] [_2]',
	'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides.' => 'Los siguientes módulos son <strong>opcionales</strong>. Si el servidor no tiene estos módulos instalados, deberá instalarlos para disponer de la funcionalidad que ofrecen.',
	'Some of the following modules are required by the various data storage options in Movable Type. In order run the system, your server needs to have DBI and at least one of the other modules installed.' => 'Algunos de los siguientes módulos son necesarios para las diferentes gestores de bases de datos en Movable Type. Para ejecutar el sistema, el servidor debe tener instalado DBI y al menos uno de los otros módulos.',
	'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'Su sistema o no tiene [_1] instalado, la versión instalada es antigua, o [_1] necesita otro módulo que no está instalado.',
	'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => 'El servidor no tiene [_1] instalado o [_1] necesita otro módulo que no está instalado.',
	'Please consult the installation instructions for help in installing [_1].' => 'Por favor, consulte las instrucciones de instalación si quiere ayuda sobre la instalación de [_1].',
	'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN.' => 'La versión de DBD::mysql que tiene instalada es incompatible con Movable Type. Por favor, instale la versión actual disponible en CPAN.',
	'The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements.' => 'El $mod está instalado correctamente, pero necesita un módulo DBI actualizado. Por favor, consulte la nota de arriba sobre los módulos DBI requeridos.',
	'Your server has [_1] installed (version [_2]).' => 'El servidor tiene [_1] instalado (versión [_2]).',
	'Movable Type System Check Successful' => 'Comprobación del sistema realizada con éxito',
	'You\'re ready to go!' => '¡Ya está preparado!',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'El servidor tiene todos los módulos necesarios instalados; no tiene que realizar ninguna instalación adicional. Continúe con las instrucciones de instalación.',
	'CGI is required for all Movable Type application functionality.' => 'El CGI es requerido para todas las funciones del Sistema Movable Type.',
	'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size es necesario para subir ficheros (determina el tamaño de las imágenes transferidas en muchos formatos diferentes).',
	'File::Spec is required for path manipulation across operating systems.' => 'File::Spec es necesario para la manipulación de la ubición de los archivos en el sistema operativo.',
	'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie es necesario para la autentificación de cookies.',
	'DBI is required to store data in database.' => 'DBI es necesario para guardar información en bases de datos.',
	'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI y DBD::mysql son necesarios si quiere usar la base de datos MySQL.',
	'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI y DBD::Pg son necesarios si quiere usar la base de datos PostgreSQL.',
	'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI y DBD::SQLite son necesarios si quiere usar la base de datos SQLite.',
	'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI y DBD::SQLite2 son necesarios si quiere usar la base de datos SQLite 2.x.',
	'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in the configuration file.' => 'HTML::Entities es necesario para codificar algunos caracteres, pero puede desactivar esta funcionalidad usando la opción NoHTMLEntities en el fichero de configuración.',
	'LWP::UserAgent is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'LWP::UserAgent es opcional; es necesario si desea usar el sistema de TrackBacks, el ping de weblogs.com, o el ping a las actualizaciones recientes de Movable Type.',
	'HTML::Parser is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'HTML::Parser es opcional; Es necesario si desea usar el sistema de TrackBacks, el ping a weblogs.com o el ping a las actualizaciones recientes de MT.',
	'SOAP::Lite is optional; It is needed if you wish to use the MT XML-RPC server implementation.' => 'SOAP::Lite es opcional; es necesario si desea usar la implementación del servidor XML-RCP de Movable Type.',
	'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Temp es opcional; es necesario si desea sobreescribir ficheros existentes al subir ficheros.',
	'Scalar::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'Scalar::Util es opcional. Es necesario si quiere usar la Cola de Publicación.',
	'List::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'Lista: Útiles opcionales; esto es necesario si usted desea utilizar la función cola de publicación',
	'Image::Magick is optional; It is needed if you would like to be able to create thumbnails of uploaded images.' => 'Image::Magick es opcional; es necesario si desea crear miniaturas de las imágenes transferidas.',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Este módulo es necesario si desea poder crear miniaturas de las imágenes subidas.',
	'This module is needed if you would like to be able to use NetPBM as the image driver for MT.' => 'Este módulo es necesario si desea usar NetPBM como controlador de imágenes en MT.',
	'Storable is optional; it is required by certain MT plugins available from third parties.' => 'Storable es opcional; es requerido por algunas extensiones de Movable Type realizadas por terceros.',
	'Crypt::DSA is optional; if it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSA es opcional; si está instalado, se acelerará el registro de identificación de comentarios.',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers such as AOL and Yahoo! which require SSL support.' => 'Este módulo y sus dependencias son necesarios para permitir a los comentaristas que se autentifiquen mediante proveedores de OpenID, como AOL y Yahoo!, lo que requiere soporte de SSL.',
	'MIME::Base64 is required in order to enable comment registration.' => 'MIME::Base64 es necesario para activar el registro de comentarios.',
	'XML::Atom is required in order to use the Atom API.' => 'XML::Atom es necesario para usar el API de Atom.',
	'Cache::Memcached and memcached server/daemon is required in order to use memcached as caching mechanism used by Movable Type.' => 'Cache::Memcached y el servidor/demonio memcached son necesarios para que Movable Type utilice memcached como mecanismo de caché.',
	'Archive::Tar is required in order to archive files in backup/restore operation.' => 'Archive::Tar es necesario para archivar los ficheros en las operaciones de copia de respaldo/restauración.',
	'IO::Compress::Gzip is required in order to compress files in backup/restore operation.' => 'IO::Compress::Gzip es necesario para comprimir los ficheros en las operaciones de copia de respaldo/restauración.',
	'IO::Uncompress::Gunzip is required in order to decompress files in backup/restore operation.' => 'IO::Uncompress::Gunzip es necesario para descomprimir los ficheros en las operaciones de copia de respaldo/restauración.',
	'Archive::Zip is required in order to archive files in backup/restore operation.' => 'Archive::Zip es necesario para archivar los ficheros en las operaciones de copia de respaldo/restauración.',
	'XML::SAX and/or its dependencies is required in order to restore.' => 'XML::SAX y/o sus dependencias son necesarias para las operaciones de copia de respaldo/restauración.',
	'Digest::SHA1 and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including Vox and LiveJournal.' => 'Digest::SHA1 y sus dependencias son necesarios para permitir a los comentaristas que se autentificación mediante los proveedores OpenID, incluyendo Vox y LiveJournal.',
	'Mail::Sendmail is required for sending mail via SMTP Server.' => 'Mail::Sendmail es necesario para enviar correo mediante un servidor SMTP.',
	'This module is used in test attribute of MTIf conditional tag.' => 'Este módulo se utiliza en el atributo test de la etiqueta MTIf.',
	'This module is used by the Markdown text filter.' => 'El filtro de textos Markdown utiliza este módulo.',
	'This module is required in mt-search.cgi if you are running Movable Type on Perl older than Perl 5.8.' => 'mt-search.cgi necesita este módulo si está usando Movable Type con una versión de Perl más antigua de la 5.8.',
	'This module required for action streams.' => 'Este módulo es necesario para los torrentes de acciones.',
	'The [_1] database driver is required to use [_2].' => 'Es necesario el controlador de la base de datos [_1] para usar [_2].',
	'Checking for' => 'Comprobando',
	'Installed' => 'Instalado',
	'Data Storage' => 'Base de datos',
	'Required' => 'Necesario',
	'Optional' => 'Opcional',

## default_templates/recent_assets.mtml
	'Recent Assets' => 'Multimedia reciente',

## default_templates/monthly_archive_dropdown.mtml
	'Archives' => 'Archivos',
	'Select a Month...' => 'Seleccione un mes...',

## default_templates/notify-entry.mtml
	'A new [lc,_3] entitled \'[_1]\' has been published to [_2].' => 'Un nuevo [lc,_3] titulado \'[_1]\' ha sido publicado en [_2].',
	'View entry:' => 'Ver entrada:',
	'View page:' => 'Ver página:',
	'[_1] Title: [_2]' => '[_1] Título: [_2]',
	'Publish Date: [_1]' => 'Fecha de publicación: [_1]',
	'Message from Sender:' => 'Mensaje del expeditor',
	'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'Ha recibido este correo porque seleccionó recibir avisos sobre la publicación de nuevos contenidos en [_1] o porque el autor de la entrada pensó que podría serle de interés. Si no quiere recibir más avisos, por favor, contacte con esta persona:',

## default_templates/tag_cloud.mtml
	'Tag Cloud' => 'Nube de etiquetas',

## default_templates/category_archive_list.mtml
	'Categories' => 'Categorías',
	'[_1] ([_2])' => '[_1] ([_2])',

## default_templates/current_author_monthly_archive_list.mtml
	'[_1]: Monthly Archives' => '[_1]: Archivos mensuales',

## default_templates/main_index.mtml
	'HTML Head' => 'HTML de la cabecera',
	'Banner Header' => 'Logotipo de la cabecera',
	'Entry Summary' => 'Resumen de las entradas',
	'Sidebar' => 'Barra lateral',
	'Banner Footer' => 'Logotipo del pie',

## default_templates/page.mtml
	'Trackbacks' => 'Trackbacks',
	'Comments' => 'Comentarios',

## default_templates/main_index_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to only appear on the homepage (or "main_index"). More info: [_1]' => 'Este es un conjunto personalizado de widgets creados para aparecer solo en la página de inicio (o "main_index"). Más información: [_1]',
	'Recent Comments' => 'Comentarios recientes',
	'Recent Entries' => 'Entradas recientes',

## default_templates/entry_summary.mtml
	'By [_1] on [_2]' => 'Por [_1] el [_2]',
	'1 Comment' => '1 comentario',
	'# Comments' => '# comentarios',
	'No Comments' => 'Sin comentarios',
	'1 TrackBack' => '1 TrackBack',
	'# TrackBacks' => '# TrackBacks',
	'No TrackBacks' => 'Sin trackbacks',
	'Tags' => 'Etiquetas',
	'Continue reading <a href="[_1]" rel="bookmark">[_2]</a>.' => 'Continúe leyendo <a href="[_1]" rel="bookmark">[_2]</a>.',

## default_templates/comment_response.mtml
	'Confirmation...' => 'Confirmación...',
	'Your comment has been submitted!' => '¡El comentario se ha recibido!',
	'Thank you for commenting.' => 'Gracias por comentar.',
	'Your comment has been received and held for approval by the blog owner.' => 'El comentario que envió fue recibido y está retenido para su aprobación por parte del administrador del weblog.',
	'Comment Submission Error' => 'Error en el envío de comentarios',
	'Your comment submission failed for the following reasons: [_1]' => 'El envío del comentario falló por alguna de las siguientes razones: [_1]',
	'Return to the <a href="[_1]">original entry</a>.' => 'Volver a la <a href="[_1]">entrada original</a>.',

## default_templates/commenter_notify.mtml
	'This email is to notify you that a new user has successfully registered on the blog \'[_1]\'. Listed below you will find some useful information about this new user.' => 'Este correo electrónico es una notificaión  para informarle que un nuevo usuario ha sido enregistrado con succeso en el blog \'[_1]\'. Abajo usted encontratá enumeradas algunas informaciones útiles sobre este nuevo usuario.',
	'New User Information:' => 'Informaciones sobre el nuevo usuario:',
	'Username: [_1]' => 'Nombre de usuario: [_1]',
	'Full Name: [_1]' => 'Nombre Completo: [_1]',
	'Email: [_1]' => 'Correo Electrónico: [_1]',
	'To view or edit this user, please click on or cut and paste the following URL into a web browser:' => 'Para ver o editar este usuario, por favor, haga clic en (o copie y pegue) la siguiente URL en un navegador:',

## default_templates/footer-email.mtml
	'Powered by Movable Type [_1]' => 'Powered by Movable Type [_1]',

## default_templates/archive_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to serve different content based upon what type of archive it is included. More info: [_1]' => 'Conjunto personalizado de widgets creado para mostrar contenidos diferentes según el tipo de archivo que incluye. Más información: [_1]',
	'Current Category Monthly Archives' => 'Archivos mensuales de la categoría actual',
	'Category Archives' => 'Archivos por categoría',
	'Monthly Archives' => 'Archivos mensuales',

## default_templates/verify-subscribe.mtml
	'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Gracias por suscribirse a las notificaciones sobre actualizaciones en [_1]. Siga el enlace de abajo para confirmar su suscripción:',
	'If the link is not clickable, just copy and paste it into your browser.' => 'Si no puede hacer clic en el enlace, copie y péguelo en su navegador.',

## default_templates/new-ping.mtml
	'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Se ha recibido un TrackBack en el blog [_1], en la entrada #[_2] ([_3]). Debe aprobarlo para que aparezca en el sitio.',
	'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Se ha recibido un TrackBack en el blog [_1], en la categoría #[_2], ([_3]). Debe aprobar este TrackBack antes de que aparezca en su sitio.',
	'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Se ha recibido un nuevo TrackBack en el blog [_1], en la entrada #[_2] ([_3]).',
	'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'Se ha recibido un nuevo TrackBack en el blog [_1], en la categoría #[_2] ([_3]).',
	'Excerpt' => 'Resumen',
	'URL' => 'URL',
	'Title' => 'Título',
	'Blog' => 'Blog',
	'IP address' => 'Dirección IP',
	'Approve TrackBack' => 'Aprobar TrackBack',
	'View TrackBack' => 'Ver TrackBack',
	'Report TrackBack as spam' => 'Marcar TrackBack como spam',
	'Edit TrackBack' => 'Editar TrackBack',

## default_templates/syndication.mtml
	'Subscribe to feed' => 'Suscribirse a la fuente de sindicación',
	'Subscribe to this blog\'s feed' => 'Suscribirse a este blog (XML)',
	'Subscribe to a feed of all future entries tagged &ldquo;[_1]&ldquo;' => 'Suscribirse a las entradas etiquetadas con &ldquo;[_1]&ldquo;',
	'Subscribe to a feed of all future entries matching &ldquo;[_1]&ldquo;' => 'Subscribirse a las entradas que coinciden con &ldquo;[_1]&ldquo;',
	'Feed of results tagged &ldquo;[_1]&ldquo;' => 'Sindicación de los resultados etiquetados con &ldquo;[_1]&ldquo;',
	'Feed of results matching &ldquo;[_1]&ldquo;' => 'Sindicación de los resultados que coinciden con &ldquo;[_1]&ldquo;',

## default_templates/comment_detail.mtml
	'[_1] replied to <a href="[_2]">comment from [_3]</a>' => '[_1] respondió al <a href="[_2]">comentario de [_3]</a>',

## default_templates/author_archive_list.mtml
	'Authors' => 'Autores',

## default_templates/current_category_monthly_archive_list.mtml
	'[_1]' => '[_1]',

## default_templates/recent_comments.mtml
	'<strong>[_1]:</strong> [_2] <a href="[_3]" title="full comment on: [_4]">read more</a>' => '<strong>[_1]:</strong> [_2] <a href="[_3]" title="comentario completo en: [_4]">más</a>',

## default_templates/technorati_search.mtml
	'Technorati' => 'Technorati',
	'<a href=\'http://www.technorati.com/\'>Technorati</a> search' => 'Búsqueda en <a href=\'http://www.technorati.com/\'>Technorati</a>',
	'this blog' => 'este blog',
	'all blogs' => 'todos los blogs',
	'Search' => 'Buscar',
	'Blogs that link here' => 'Blogs que enlazan aquí',

## default_templates/monthly_archive_list.mtml
	'[_1] <a href="[_2]">Archives</a>' => '<a href="[_2]">Archivos</a> [_1]',

## default_templates/category_entry_listing.mtml
	'[_1] Archives' => 'Archivos [_1]',
	'Recently in <em>[_1]</em> Category' => 'Novedades en la categoría <em>[_1]</em>',
	'Main Index' => 'Inicio',

## default_templates/comment_throttle.mtml
	'If this was a mistake, you can unblock the IP address and allow the visitor to add it again by logging in to your Movable Type installation, going to Blog Config - IP Banning, and deleting the IP address [_1] from the list of banned addresses.' => 'Si fue un error, puede desbloquear la dirección IP y permitir al visitante que lo añada de nuevo iniciando una sesión en Movable Type, llendo a Configuración del blog - Bloqueo de IP, y borrando la dirección IP [_1] de la lista de direcciones bloquedas.',
	'A visitor to your blog [_1] has automatically been banned by adding more than the allowed number of comments in the last [_2] seconds.' => 'Se bloqueó automáticamente a una persona que visitó su weblog [_1] debido a que insertó más comentarios de los permitidos en menos de [_2] segundos.',
	'This has been done to prevent a malicious script from overwhelming your weblog with comments. The banned IP address is' => 'Esto se hizo para impedir que nadie o nada desborde malintencionadamente su weblog con comentarios. La dirección bloqueada es',

## default_templates/signin.mtml
	'Sign In' => 'Registrarse',
	'You are signed in as ' => 'Se identificó como ',
	'sign out' => 'salir',
	'You do not have permission to sign in to this blog.' => 'No tiene permisos para identificarse en este blog.',

## default_templates/new-comment.mtml
	'An unapproved comment has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => 'Se recibió un comentario en su blog [_1], en la entrada nº[_2] ([_3]). Debe aprobar este comentario para que aparezca en su sitio.',
	'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Se publicó un nuevo comentario en su weblog [_1], en la entrada nº [_2] ([_3]).',
	'Commenter name: [_1]' => 'Nombre del comentarista',
	'Commenter email address: [_1]' => 'Correo electrónico del comentarista: [_1]',
	'Commenter URL: [_1]' => 'URL del comentarista: [_1]',
	'Commenter IP address: [_1]' => 'Dirección IP del comentarista: [_1]',
	'Approve comment:' => 'Comentario aceptado:',
	'View comment:' => 'Ver comentario:',
	'Edit comment:' => 'Editar comentario:',
	'Report comment as spam:' => 'Reportar el comentario como spam:',

## default_templates/pages_list.mtml
	'Pages' => 'Páginas',

## default_templates/about_this_page.mtml
	'About this Entry' => 'Sobre esta entrada',
	'About this Archive' => 'Sobre este archivo',
	'About Archives' => 'Sobre los archivos',
	'This page contains links to all the archived content.' => 'Esta página contiene enlaces a todos los contenidos archivados.',
	'This page contains a single entry by [_1] published on <em>[_2]</em>.' => 'Esta página contiene una sola entrada realizada por [_1] y publicada el <em>[_2]</em>.',
	'<a href="[_1]">[_2]</a> was the previous entry in this blog.' => '<a href="[_1]">[_2]</a> es la entrada anterior en este blog.',
	'<a href="[_1]">[_2]</a> is the next entry in this blog.' => '<a href="[_1]">[_2]</a> es la entrada siguiente en este blog.',
	'This page is an archive of entries in the <strong>[_1]</strong> category from <strong>[_2]</strong>.' => 'Esta página es un archivo de las entradas en la categoría <strong>[_1]</strong> de <strong>[_2]</strong>.',
	'<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> es el archivo anterior.',
	'<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> es el siguiente archivo.',
	'This page is an archive of recent entries in the <strong>[_1]</strong> category.' => 'Esta página es un archivo de las últimas entradas en la categoría <strong>[_1]</strong>.',
	'<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> es la categoría anterior.',
	'<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> es la siguiente categoría.',
	'This page is an archive of recent entries written by <strong>[_1]</strong> in <strong>[_2]</strong>.' => 'Esta página es un archivo de las últimas entradas escritas por <strong>[_1]</strong> en <strong>[_2]</strong>.',
	'This page is an archive of recent entries written by <strong>[_1]</strong>.' => 'Esta página es un archivo de las últimas entradas escritas por <strong>[_1]</strong>.',
	'This page is an archive of entries from <strong>[_2]</strong> listed from newest to oldest.' => 'Esta página es un archivo de las entradas de <strong>[_2]</strong>, ordenadas de nuevas a antiguas.',
	'Find recent content on the <a href="[_1]">main index</a>.' => 'Encontrará los contenidos recientes en la <a href="[_1]">página principal</a>.',
	'Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.' => 'Encontrará los contenidos recientes en la <a href="[_1]">página principal</a>. Consulte los <a href="[_2]">archivos</a> para ver todos los contenidos.',

## default_templates/entry.mtml

## default_templates/recover-password.mtml
	'A request has been made to change your password in Movable Type. To complete this process click on the link below to select a new password.' => 'Se ha recibido una petición para cambiar su contraseña de Movable Type. Para completar el proceso y seleccionar una nueva contraseña, haga clic en el enlace.',
	'If you did not request this change, you can safely ignore this email.' => 'Si no solicitó este cambio, ignore este mensaje.',

## default_templates/javascript.mtml
	'moments ago' => 'hace unos momentos',
	'[quant,_1,hour,hours] ago' => 'hace [quant,_1,hora,horas]',
	'[quant,_1,minute,minutes] ago' => 'hace [quant,_1,minute,minutes]',
	'[quant,_1,day,days] ago' => 'hace [quant,_1,día,días]',
	'Edit' => 'Editar',
	'Your session has expired. Please sign in again to comment.' => 'La sesión ha caducado. Por favor, identifíquese de nuevo para comentar.',
	'Signing in...' => 'Iniciando sesión...',
	'You do not have permission to comment on this blog. ([_1]sign out[_2])' => 'No tiene permisos para comentar en este blog ([_1]cerrar sesión[_2])',
	'Thanks for signing in, __NAME__. ([_1]sign out[_2])' => 'Gracias por identificarse, __NAME__. ([_1]salir[_2])',
	'[_1]Sign in[_2] to comment.' => '[_1]Iniciar una sesión[_2].',
	'[_1]Sign in[_2] to comment, or comment anonymously.' => 'Para comentar [_1]inicie una sesión[_2] o hágalo de forma anónima.',
	'Replying to <a href="[_1]" onclick="[_2]">comment from [_3]</a>' => 'Respondiendo al <a href="[_1]" onclick="[_2]">comentario de [_3]</a>',

## default_templates/archive_index.mtml
	'Author Archives' => 'Archivos por autor',
	'Category Monthly Archives' => 'Archivos mensuales por categorías',
	'Author Monthly Archives' => 'Archivos mensuales por autores',

## default_templates/trackbacks.mtml
	'TrackBack URL: [_1]' => 'URL de TrackBack: [_1]',
	'<a href="[_1]">[_2]</a> from [_3] on <a href="[_4]">[_5]</a>' => '<a href="[_1]">[_2]</a> desde [_3] en <a href="[_4]">[_5]</a>',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">Leer más</a>',

## default_templates/calendar.mtml
	'Monthly calendar with links to daily posts' => 'Calendario mensual con enlaces a los archivos diarios',
	'Sunday' => 'Domingo',
	'Sun' => 'Dom',
	'Monday' => 'Lunes',
	'Mon' => 'Lun',
	'Tuesday' => 'Martes',
	'Tue' => 'Mar',
	'Wednesday' => 'Miércoles',
	'Wed' => 'Mié',
	'Thursday' => 'Jueves',
	'Thu' => 'Jue',
	'Friday' => 'Viernes',
	'Fri' => 'Vie',
	'Saturday' => 'Sábado',
	'Sat' => 'Sáb',

## default_templates/recent_entries.mtml

## default_templates/sidebar.mtml
	'2-column layout - Sidebar' => 'Distribución de 2 columnas - Barra lateral',
	'3-column layout - Primary Sidebar' => 'Distribución de 3 columnas - Barra lateral principal',
	'3-column layout - Secondary Sidebar' => 'Distribución de 3 columnas - Barra lateral secundaria',

## default_templates/openid.mtml
	'[_1] accepted here' => '[_1] aceptado aquí',
	'http://www.sixapart.com/labs/openid/' => 'http://www.sixapart.com/labs/openid/',
	'Learn more about OpenID' => 'Más información sobre OpenID',

## default_templates/date_based_author_archives.mtml
	'Author Yearly Archives' => 'Archivos anuales por autor',
	'Author Weekly Archives' => 'Archivos semanales por autor',
	'Author Daily Archives' => 'Archivos diarios por autor',

## default_templates/banner_footer.mtml
	'_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.org/sitees/"><$MTProductName$></a>',
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Este blog tiene una <a href="[_1]">Licencia Creative Commons</a>.',

## default_templates/comments.mtml
	'Older Comments' => 'Comentarios antiguos',
	'Newer Comments' => 'Comentarios nuevos',
	'Comment Detail' => 'Detalle del comentario',
	'The data is modified by the paginate script' => 'Los datos son modificados por el script de paginación',
	'Leave a comment' => 'Escribir un comentario',
	'Name' => 'Nombre',
	'Email Address' => 'Dirección de correo electrónico',
	'Remember personal info?' => '¿Recordar datos personales?',
	'(You may use HTML tags for style)' => '(Puede usar etiquetas HTML para el estilo)',
	'Preview' => 'Vista previa',
	'Submit' => 'Enviar',

## default_templates/search_results.mtml
	'Search Results' => 'Resultado de la búsqueda',
	'Results matching &ldquo;[_1]&rdquo;' => 'Resultados correspondiente a &ldquo;[_1]&rdquo;',
	'Results tagged &ldquo;[_1]&rdquo;' => 'Resultado de etiquetas &ldquo;[_1]&rdquo;',
	'Previous' => 'Anterior',
	'Next' => 'Siguiente',
	'No results found for &ldquo;[_1]&rdquo;.' => 'Ningún resultado encontrado para &ldquo;[_1]&rdquo;.',
	'Instructions' => 'Instrucciones',
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Por defecto, este motor de búsqueda comprueba todas las palabras sin tener en cuenta el orden. Para buscar una frase exacta, encierre la frase entre comillas:',
	'movable type' => 'movable type',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'El motor de búsqueda también soporta los operadores AND, OR y NOT para especificar expresiones lógicas:',
	'personal OR publishing' => 'personal OR publicación',
	'publishing NOT personal' => 'publicación NOT personal',

## default_templates/comment_listing.mtml

## default_templates/date_based_category_archives.mtml
	'Category Yearly Archives' => 'Archivos anuales por categoría',
	'Category Weekly Archives' => 'Archivos semanales por categoría',
	'Category Daily Archives' => 'Archivos diarios por categoría',

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'Página no encontrada',

## default_templates/creative_commons.mtml

## default_templates/powered_by.mtml
	'_MTCOM_URL' => '_MTCOM_URL',

## default_templates/comment_preview.mtml
	'Previewing your Comment' => 'Vista previa del comentario',
	'Replying to comment from [_1]' => 'Respondiendo al comentario de [_1]',
	'Cancel' => 'Cancelar',

## default_templates/monthly_entry_listing.mtml

## default_templates/search.mtml
	'Case sensitive' => 'Distinguir mayúsculas y minúsculas',
	'Regex search' => 'Expresión regular',

## default_templates/commenter_confirm.mtml
	'Thank you registering for an account to comment on [_1].' => 'Gracias por registrar una cuenta para comentar en [_1].',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to comment on [_1].' => 'Para su propia seguridad, y para prevenir fraudes, antes de continuar le solicitamos que confirme su cuenta y dirección de correo. Tras confirmarlas, podrá comentar en [_1].',
	'To confirm your account, please click on or cut and paste the following URL into a web browser:' => 'Para confirmar su cuenta, haga clic en (o copie y pegue) la URL en un navegador web:',
	'If you did not make this request, or you don\'t want to register for an account to comment on [_1], then no further action is required.' => 'Si no realizó esta petición, o no quiere registrar una cuenta para comentar en [_1], no se necesitan más acciones.',
	'Thank you very much for your understanding.' => 'Gracias por su comprensión.',
	'Sincerely,' => 'Cordialmente,',

## lib/MT/Asset/Video.pm
	'Videos' => 'Vídeos',

## lib/MT/Asset/Audio.pm

## lib/MT/Asset/Image.pm
	'Images' => 'Imágenes',
	'Actual Dimensions' => 'Tamaño actual',
	'[_1] x [_2] pixels' => '[_1] x [_2] píxeles',
	'Error cropping image: [_1]' => 'Error recortando imagen: [_1]',
	'Error scaling image: [_1]' => 'Error redimensionando la imagen: [_1]',
	'Error converting image: [_1]' => 'Error convirtiendo la imagen: [_1]',
	'Error creating thumbnail file: [_1]' => 'Error creando el fichero de la miniatura: [_1]',
	'%f-thumb-%wx%h-%i%x' => '%f-miniatura-%wx%h-%i%x',
	'Can\'t load image #[_1]' => 'No se pudo cargar la imagen nº[_1]',
	'View image' => 'Ver imagen',
	'Permission denied setting image defaults for blog #[_1]' => 'Se denegó el permiso para cambiar las opciones predefinidos de imágenes del blog nº[_1]',
	'Thumbnail image for [_1]' => 'Imagen Thumbnail para [_1]',
	'Invalid basename \'[_1]\'' => 'Nombre base no válido \'[_1]\'',
	'Error writing to \'[_1]\': [_2]' => 'Error escribiendo en \'[_1]\': [_2]',
	'Popup Page for [_1]' => 'Página Popup para [_1]',

## lib/MT/Upgrade/v1.pm
	'Creating template maps...' => 'Creando mapas de plantillas...',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'Mapeando ID plantilla [_1] a [_2] ([_3]).',
	'Mapping template ID [_1] to [_2].' => 'Mapeando ID plantilla [_1] a [_2].',
	'Error saving record: [_1].' => 'Error guardando el registro: [_1].',
	'Creating entry category placements...' => 'Creando situaciones de categorías de entradas...',

## lib/MT/Upgrade/v2.pm
	'Updating category placements...' => 'Actualizando situación de categorías...',
	'Assigning comment/moderation settings...' => 'Asignando opciones de comentarios/moderación...',

## lib/MT/Upgrade/Core.pm
	'Creating initial website and user records...' => 'Creando registros iniciales de los sitios web y usuarios...', # Translate - New
	'Error creating role record: [_1].' => 'Error creado el registro de roles: [_1].',
	'First Website' => 'Primer sitio web',
	'Creating new template: \'[_1]\'.' => 'Creando nueva plantilla: \'[_1]\'.',
	'Mapping templates to blog archive types...' => 'Mapeando plantillas con tipos de archivo de blogs...',
	'Assigning custom dynamic template settings...' => 'Asignando opciones de plantillas dinámicas personalizadas...',
	'Assigning user types...' => 'Asignando tipos de usario...',
	'Assigning category parent fields...' => 'Asignando campos de ancentros en las categorías...',
	'Assigning template build dynamic settings...' => 'Asignando opciones de construcción de plantillas dinámicas...',
	'Assigning visible status for comments...' => 'Asignando estado de visibilidad a los comentarios...',
	'Assigning visible status for TrackBacks...' => 'Asignando estado de visiblidad para los TrackBacks...',

## lib/MT/Upgrade/v3.pm
	'Custom ([_1])' => 'Personalizado ([_1])',
	'This role was generated by Movable Type upon upgrade.' => 'Este rol fue generado por Movable Type durante la actualización.',
	'Removing Dynamic Site Bootstrapper index template...' => 'Borrando plantilla índice del arranque dinámico...',
	'Creating configuration record.' => 'Creando registro de configuración.',
	'Setting blog basename limits...' => 'Estableciendo los límites del nombre base del blog...',
	'Setting default blog file extension...' => 'Estableciendo extensión predefinida de fichero de blog...',
	'Updating comment status flags...' => 'Actualizando estados de comentarios...',
	'Updating commenter records...' => 'Actualizando registros de comentaristas...',
	'Assigning blog administration permissions...' => 'Asignando permisos de administración de blogs...',
	'Setting blog allow pings status...' => 'Estableciendo el estado de recepción de pings en los blogs...',
	'Updating blog comment email requirements...' => 'Actualizando los requerimientos del correo de los comentarios...',
	'Assigning entry basenames for old entries...' => 'Asignando nombre base de entradas en entradas antiguas...',
	'Updating user web services passwords...' => 'Actualizando contraseñas de servicios web...',
	'Updating blog old archive link status...' => 'Actualizando el estado de los enlaces de archivado antiguos...',
	'Updating entry week numbers...' => 'Actualizando números de semana de entradas...',
	'Updating user permissions for editing tags...' => 'Actualizando los permisos de los usuarios para la edición de etiquetas...',
	'Setting new entry defaults for blogs...' => 'Configurando los nuevos valores predefinidos de las entradas en los blogs...',
	'Migrating any "tag" categories to new tags...' => 'Migrando cualquier categoría "tag" a nuevas etiquetas...',
	'Assigning basename for categories...' => 'Asignando nombre base a las categorías...',
	'Assigning user status...' => 'Asignando estado de usuarios...',
	'Migrating permissions to roles...' => 'Migrando permisos a roles...',

## lib/MT/Upgrade/v4.pm
	'Comment Posted' => 'Comentario publicado',
	'Your comment has been posted!' => '¡El comentario ha sido publicado!',
	'Comment Pending' => 'Comentario pendiente',
	'Your comment submission failed for the following reasons:' => 'El envío de su comentario falló por las siguientes razones:',
	'[_1]: [_2]' => '[_1]: [_2]',
	'Migrating permission records to new structure...' => 'Migrando registros de permisos a la nueva estructura...',
	'Migrating role records to new structure...' => 'Migrando registros de roles a la nueva estructura...',
	'Migrating system level permissions to new structure...' => 'Migrando permisos a nivel del sistema a la nueva estructura...',
	'Updating system search template records...' => 'Actualizando registros de las plantillas de búsqueda del sistema...',
	'Renaming PHP plugin file names...' => 'Renombrando nombre de ficheros de la extensión de PHP...',
	'Error renaming PHP files. Please check the Activity Log.' => 'Error al renombrar ficheros PHP. Por favor, compruebe el registro de actividad.',
	'Cannot rename in [_1]: [_2].' => 'No se pudo renombrar en [_1]: [_2].',
	'Migrating Nofollow plugin settings...' => 'Migrando ajustes de la extensión Nofollow...',
	'Comment Response' => 'Comentar respuesta',
	'Removing unnecessary indexes...' => 'Eleminando índices innecesarios...',
	'Moving metadata storage for categories...' => 'Migrando los metadatos de las categorías...',
	'Upgrading metadata storage for [_1]' => 'Migrando los metadatos de [_1]',
	'Error loading class: [_1].' => 'Error cargando la clase: [_1].',
	'Assigning entry comment and TrackBack counts...' => 'Asignando totales de comentarios y trackbacks de las entradas...',
	'Updating password recover email template...' => 'Actualizando la plantilla del correo de recuperación de contraseña...',
	'Assigning junk status for comments...' => 'Asignando el estado spam para los comentarios...',
	'Assigning junk status for TrackBacks...' => 'Asignando el estado spam para los TrackBacks...',
	'Populating authored and published dates for entries...' => 'Rellenando fechas de creación y publicación de las entradas...',
	'Updating widget template records...' => 'Actualizando registros de plantillas de widgets...',
	'Classifying category records...' => 'Clasificando registros de categorías...',
	'Classifying entry records...' => 'Clasificando registros de entradas...',
	'Merging comment system templates...' => 'Combinando plantillas de comentarios del sistema...',
	'Populating default file template for templatemaps...' => 'Rellenando plantilla predefinida de ficheros para los templatemaps...',
	'Removing unused template maps...' => 'Borrando mapas de plantillas no usados...',
	'Assigning user authentication type...' => 'Asignando tipo de autentificación de usuarios...',
	'Adding new feature widget to dashboard...' => 'Añadiendo un nuevo widget al panel de control...',
	'Moving OpenID usernames to external_id fields...' => 'Moviendo los nombres de usuarios de OpenID a campos external_id...',
	'Assigning blog template set...' => 'Asignando conjunto de plantillas...',
	'Assigning blog page layout...' => 'Asignando distribución de las páginas...',
	'Assigning author basename...' => 'Asignando nombre base a los autores...',
	'Assigning embedded flag to asset placements...' => 'Asignando marca a los elementos empotrados...',
	'Updating template build types...' => 'Actualizando los tipos de publicación de las plantillas...',
	'Replacing file formats to use CategoryLabel tag...' => 'Reemplazando los formatos de fichero para usar la etiqueta CategoryLabel...',

## lib/MT/Upgrade/v5.pm
	'Populating generic website for current blogs...' => 'Poblando el sitio web genérico con los blogs actuales...',
	'Generic Website' => 'Sitio web genérico',
	'Migrating [_1]([_2]).' => 'Migrando [_1]([_2]).',
	'Granting new role to system administrator...' => 'Concediendo nuevo rol al administrador del sistema...',
	'Updating existing role name...' => 'Actualizando nombre de rol existente...',
	'_WEBMASTER_MT4' => 'Webmaster', # Translate - New
	'Webmaster (MT4)' => 'Webmaster (MT4)',
	'Populating new role for website...' => 'Creando nuevo rol para el sitio web...',
	'Website Administrator' => 'Administrador del sitio web',
	'Can administer the website.' => 'Puede administrar el sitio web',
	'Webmaster' => 'Webmaster',
	'Can manage pages, Upload files and publish blog templates.' => 'Puede gestionar las páginas, subir ficheros y publicar plantillas de blogs.',
	'Designer' => 'Diseñador',
	'Designer (MT4)' => 'Diseñador (MT4)',
	'Populating new role for theme...' => 'Poblando el nuevo rol para los temas...',
	'Can edit, manage and publish blog templates and themes.' => 'Puede editar, gestionar y publicar plantillas y temas de blogs.',
	'Assigning new system privilege for system administrator...' => 'Asignando nuevo sistema de privilegios al administrador del sistema...',
	'Assigning to  [_1]...' => 'Asignando a [_1]...',
	'Migrating mtview.php to MT5 style...' => 'Migrando mtview.php al estilo MT5...',
	'Migrating DefaultSiteURL/DefaultSiteRoot to website...' => 'Migrando DefaultSiteURL/DefaultSiteRoot al sitio web...',
	'New user\'s website' => 'Sitio web del nuevo usuario', # Translate - New
	'Migrating existing [quant,_1,blog,blogs] into websites and its children...' => 'Migrando [quant,_1,blog existente,blogs existentes] a sitios web y sus descendientes...', # Translate - New
	'Error loading role: [_1].' => 'Error cargando rol: [_1].', # Translate - New
	'New WebSite [_1]' => 'Nuevo sitio web [_1]', # Translate - New
	'An error occured during generating a website upon upgrade: [_1]' => 'Ocurrió un error generando un un sitio web durante la actualización: [_1]', # Translate - New
	'Generated a website [_1]' => 'Generado un sitio web [_1]', # Translate - New
	'An error occured during migrating a blog\'s site_url: [_1]' => 'Ocurrió un error durante la migración del site_url de un blog: [_1]', # Translate - New
	'Moved blog [_1] ([_2]) under website [_3]' => 'Se movió el blog [_1] ([_2]) bajo el sitio web [_3]', # Translate - New
	'Merging dashboard settings...' => 'Uniendo las opciones del tablón...',
	'Classifying blogs...' => 'Clasificando blogs...', # Translate - New
	'Rebuilding permissions...' => 'Reconstruyendo permisos...', # Translate - New

## lib/MT/Util/Archive/Tgz.pm
	'Type must be tgz.' => 'El tipo debe ser tgz.',
	'Could not read from filehandle.' => 'No se pudo leer desde el manejador de ficheros',
	'File [_1] is not a tgz file.' => 'El fichero [_1] no es un tgz.',
	'File [_1] exists; could not overwrite.' => 'El fichero [_1] existe: no puede sobreescribirse.',
	'Can\'t extract from the object' => 'No se pudo extraer usando el objeto',
	'Can\'t write to the object' => 'No se pudo escribir en el objeto',
	'Both data and file name must be specified.' => 'Se deben especificar tanto los datos como el nombre del fichero.',

## lib/MT/Util/Archive/Zip.pm
	'Type must be zip' => 'El tipo debe ser zip',
	'File [_1] is not a zip file.' => 'El fichero [_1] no es un fichero zip.',

## lib/MT/Util/YAML/Syck.pm
	'File not found: [_1]' => 'Fichero no encontrado: [_1]',

## lib/MT/Util/YAML/Tiny.pm

## lib/MT/Util/Archive.pm
	'Type must be specified' => 'Debe especificar el tipo',
	'Registry could not be loaded' => 'El registro no pudo cargarse',

## lib/MT/Util/Captcha.pm
	'Movable Type default CAPTCHA provider requires Image::Magick.' => 'El proveedor predefinido de CAPTCHA de Movable Type necesita Image::Magick',
	'You need to configure CaptchaSourceImageBase.' => 'Debe configurar CaptchaSourceImageBase.',
	'Image creation failed.' => 'Falló la creación de la imagen.',
	'Image error: [_1]' => 'Error de imagen: [_1]',

## lib/MT/ArchiveType/Yearly.pm
	'YEARLY_ADV' => 'anuales',
	'yyyy/index.html' => 'aaaa/index.html',

## lib/MT/ArchiveType/Page.pm
	'PAGE_ADV' => 'por página',
	'folder-path/page-basename.html' => 'ruta-carpeta/título-página.html',
	'folder-path/page-basename/index.html' => 'carpeta-path/título-página/index.html',
	'folder_path/page_basename.html' => 'ruta_carpeta/título_pagina.html',
	'folder_path/page_basename/index.html' => 'ruta_carpeta/título_pagina/index.html',

## lib/MT/ArchiveType/Category.pm
	'CATEGORY_ADV' => 'por categoría',
	'category/sub-category/index.html' => 'categoría/sub-categoría/index.html',
	'category/sub_category/index.html' => 'categoría/sub_categoría/index.html',

## lib/MT/ArchiveType/AuthorMonthly.pm
	'AUTHOR-MONTHLY_ADV' => 'por mes y autor',
	'author/author-display-name/yyyy/mm/index.html' => 'autor/nombre-público-autor/aaaa/mm/index.html',
	'author/author_display_name/yyyy/mm/index.html' => 'autor/nombre_público_autor/aaaa/mm/index.html',

## lib/MT/ArchiveType/AuthorWeekly.pm
	'AUTHOR-WEEKLY_ADV' => 'por semana y autor',
	'author/author-display-name/yyyy/mm/day-week/index.html' => 'autor/nombre-público-autor/aaaa/mm/día-semana/index.html',
	'author/author_display_name/yyyy/mm/day-week/index.html' => 'autor/nombre-público-autor/aaaa/mm/día-semana/index.html',

## lib/MT/ArchiveType/AuthorDaily.pm
	'AUTHOR-DAILY_ADV' => 'por día y autor',
	'author/author-display-name/yyyy/mm/dd/index.html' => 'autor/nombre-público-autor/aaaa/mm/dd/index.html',
	'author/author_display_name/yyyy/mm/dd/index.html' => 'autor/nombre-público-autor/aaaa/mm/dd/index.html',

## lib/MT/ArchiveType/Individual.pm
	'INDIVIDUAL_ADV' => 'por entrada',
	'yyyy/mm/entry-basename.html' => 'aaaa/mm/título-entrada.html',
	'yyyy/mm/entry_basename.html' => 'aaaa/mm/título_entrada.html',
	'yyyy/mm/entry-basename/index.html' => 'aaaa/mm/titutlo-entrada/index.html',
	'yyyy/mm/entry_basename/index.html' => 'aaaa/mm/título_entrada/index.html',
	'yyyy/mm/dd/entry-basename.html' => 'aaaa/mm/dd/título-entrada.html',
	'yyyy/mm/dd/entry_basename.html' => 'aaaa/mm/dd/título_entrada.html',
	'yyyy/mm/dd/entry-basename/index.html' => 'aaaa/mm/dd/título-entrada/index.html',
	'yyyy/mm/dd/entry_basename/index.html' => 'aaaa/mm/dd/título_entrada/index.html',
	'category/sub-category/entry-basename.html' => 'categoría/sub-categoría/título-entrada.html',
	'category/sub-category/entry-basename/index.html' => 'categoría/sub-categoría/título-entrada/index.html',
	'category/sub_category/entry_basename.html' => 'categoría/sub_categoría/título_entrada.html',
	'category/sub_category/entry_basename/index.html' => 'categoría/sub_categoría/título_entrada/index.html',

## lib/MT/ArchiveType/CategoryMonthly.pm
	'CATEGORY-MONTHLY_ADV' => 'por mes y categoría',
	'category/sub-category/yyyy/mm/index.html' => 'categoría/sub-categoría/aaaa/mm/index.html',
	'category/sub_category/yyyy/mm/index.html' => 'categoría/sub_categoría/aaaa/mm/index.html',

## lib/MT/ArchiveType/AuthorYearly.pm
	'AUTHOR-YEARLY_ADV' => 'por año y autor',
	'author/author-display-name/yyyy/index.html' => 'autor/nombre-público-autor/aaaa/index.html',
	'author/author_display_name/yyyy/index.html' => 'author/nombre_público_autor/aaaa/index.html',

## lib/MT/ArchiveType/Monthly.pm
	'MONTHLY_ADV' => 'mensuales',
	'yyyy/mm/index.html' => 'aaaa/mm/index.html',

## lib/MT/ArchiveType/CategoryWeekly.pm
	'CATEGORY-WEEKLY_ADV' => 'por semana y categoría',
	'category/sub-category/yyyy/mm/day-week/index.html' => 'categoría/sub-categoría/aaaa/mm/día-semana/index.html',
	'category/sub_category/yyyy/mm/day-week/index.html' => 'categoría/sub_categoría/aaaa/mm/día-semana/index.html',

## lib/MT/ArchiveType/Weekly.pm
	'WEEKLY_ADV' => 'semanales',
	'yyyy/mm/day-week/index.html' => 'aaaa/mm/día-de-la-semana/index.html',

## lib/MT/ArchiveType/CategoryDaily.pm
	'CATEGORY-DAILY_ADV' => 'por día y categoría',
	'category/sub-category/yyyy/mm/dd/index.html' => 'categoría/sub-categoría/aaaa/mm/dd/index.html',
	'category/sub_category/yyyy/mm/dd/index.html' => 'categoría/sub_categoría/aaaa/mm/dd/index.html',

## lib/MT/ArchiveType/Daily.pm
	'DAILY_ADV' => 'diarios',
	'yyyy/mm/dd/index.html' => 'aaaa/mm/dd/index.html',

## lib/MT/ArchiveType/Author.pm
	'AUTHOR_ADV' => 'por autor',
	'author/author-display-name/index.html' => 'autor/nombre-público-autor/index.html',
	'author/author_display_name/index.html' => 'autor/nombre-público-autor/index.html',

## lib/MT/ArchiveType/CategoryYearly.pm
	'CATEGORY-YEARLY_ADV' => 'por año y categoría',
	'category/sub-category/yyyy/index.html' => 'categoría/sub-categoría/aaaa/index.html',
	'category/sub_category/yyyy/index.html' => 'categoría/sub_categoría/aaaa/index.html',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: [_2][_3] de la regla [_4][_5]',
	'[_1]: [_2][_3] from test [_4]' => '[_1]: [_2][_3] de la prueba [_4]',

## lib/MT/Auth/TypeKey.pm
	'Sign in requires a secure signature.' => 'La identificación necesita una firma segura.',
	'The sign-in validation failed.' => 'Falló el registro de validación.',
	'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Este weblog obliga a que los comentaristas den su dirección de correo electrónico. Si lo desea puede iniciar una sesión de nuevo, y dar al servicio de autentificación permisos para pasar la dirección de correo electrónico.',
	'Couldn\'t save the session' => 'No se pudo guardar la sesión',
	'Couldn\'t get public key from url provided' => 'No se pudo obtener la clave pública desde la URL indicada',
	'No public key could be found to validate registration.' => 'No se encontró la clave pública para validar el registro.',
	'TypePad signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'Verificación de firma de TypePad devolvió [_1] en [_2] segundos verificando [_3] con [_4]',
	'The TypePad signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'La firma de TypePad está caduca (de hace [_1] segundos). Asegúrese que el reloj del servidor está en hora',

## lib/MT/Auth/OpenID.pm
	'Could not load Net::OpenID::Consumer.' => 'No se pudo cargar Net::OpenID::Consumer.',
	'The address entered does not appear to be an OpenID' => 'La dirección introducida no parecer ser un OpenID',
	'The text entered does not appear to be a web address' => 'El texto introducido no parece ser una dirección web',
	'Unable to connect to [_1]: [_2]' => 'Imposible conectarse a [_1]: [_2]',
	'Could not verify the OpenID provided: [_1]' => 'No se pudo verificar el OpenID provisto: [_1]',

## lib/MT/Auth/MT.pm
	'Passwords do not match.' => 'Las contraseñas no coinciden.',
	'Failed to verify current password.' => 'Fallo al verificar la contraseña actual.',

## lib/MT/TheSchwartz/Error.pm
	'Job Error' => 'Error en la Tarea',

## lib/MT/TheSchwartz/FuncMap.pm
	'Job Function' => 'Funciones de la Tarea',

## lib/MT/TheSchwartz/Job.pm
	'Job' => 'Tarea',

## lib/MT/TheSchwartz/ExitStatus.pm
	'Job Exit Status' => 'Status Fin de Tarea',

## lib/MT/ObjectDriver/Driver/DBD/SQLite.pm
	'Can\'t open \'[_1]\': [_2]' => 'No se pudo abrir \'[_1]\': [_2]',

## lib/MT/CMS/RptLog.pm
	'Permission denied.' => 'Permiso denegado.',
	'RPT Log' => 'Histórico RPT',
	'System RPT Feed' => 'Sindicación del sistema RPT',

## lib/MT/CMS/Import.pm
	'Can\'t load blog #[_1].' => 'No se pudo cargar el blog nº[_1].',
	'Import/Export' => 'Importar/Exportar',
	'Load of blog \'[_1]\' failed: [_2]' => 'La carga del blog \'[_1]\' falló: [_2]',
	'You do not have import permission' => 'No tiene permisos de importación',
	'You do not have permission to create users' => 'No tiene permisos para crear usarios',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'Si va a crear nuevos usuarios por cada usuario listado en su blog, debe proveer una contraseña.',
	'Importer type [_1] was not found.' => 'No se encontró el tipo de importador [_1].',

## lib/MT/CMS/Folder.pm
	'The folder \'[_1]\' conflicts with another folder. Folders with the same parent must have unique basenames.' => 'La carpeta \'[_1]\' tiene conflicto con otra carpeta. Las carpetas con el mismo padre deben tener nombre base únicos.',
	'Folder \'[_1]\' created by \'[_2]\'' => 'Carpeta \'[_1]\' creada por \'[_2]\'',
	'The name \'[_1]\' is too long!' => 'El nombre \'[_1]\' es demasiado largo.',
	'Folder \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Carpeta \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',

## lib/MT/CMS/Tag.pm
	'Invalid type' => 'Tipo no válido',
	'New name of the tag must be specified.' => 'El nuevo nombre de la etiqueta debe ser especificado',
	'No such tag' => 'No existe dicha etiqueta',
	'Invalid request.' => 'Petición no válida.',
	'Error saving entry: [_1]' => 'Error guardando entrada: [_1]',
	'Error saving file: [_1]' => 'Error guardando fichero: [_1]',
	'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Etiqueta \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
	'Entries' => 'Entradas',

## lib/MT/CMS/Template.pm
	'index' => 'índice',
	'archive' => 'archivo',
	'module' => 'módulo',
	'widget' => 'widget',
	'email' => 'correo electrónico',
	'backup' => 'Copia de seguridad', # Translate - Case
	'system' => 'sistema',
	'Templates' => 'Plantillas',
	'One or more errors were found in this template.' => 'Se encontraron uno o más errores en esta plantilla.',
	'Create template requires type' => 'Crear plantillas requiere el tipo',
	'Archive' => 'Archivo',
	'Entry or Page' => 'Entrada o página',
	'New Template' => 'Nueva plantilla',
	'Index Templates' => 'Plantillas índice',
	'Archive Templates' => 'Plantillas de archivos',
	'Template Modules' => 'Módulos de plantillas',
	'System Templates' => 'Plantillas del sistema',
	'Email Templates' => 'Plantillas de correo',
	'Template Backups' => 'Copias de seguridad de las plantillas',
	'Can\'t locate host template to preview module/widget.' => 'No se localizó la plantilla origen para mostrar el módulo/widget.',
	'Publish error: [_1]' => 'Error de publicación: [_1]',
	'Unable to create preview file in this location: [_1]' => 'Imposible crear vista previa del archivo en este lugar: [_1]',
	'Lorem ipsum' => 'Lorem ipsum',
	'LOREM_IPSUM_TEXT' => 'LOREM_IPSUM_TEXT',
	'LORE_IPSUM_TEXT_MORE' => 'LORE_IPSUM_TEXT_MORE',
	'sample, entry, preview' => 'sample, entry, preview',
	'No permissions' => 'No tiene permisos',
	'Populating blog with default templates failed: [_1]' => 'Falló el guardando del blog con las plantillas por defecto: [_1]',
	'Setting up mappings failed: [_1]' => 'Fallo la configuración de mapeos: [_1]',
	'Saving map failed: [_1]' => 'Fallo guardando mapa: [_1]',
	'You should not be able to enter 0 as the time.' => 'No debería poder introducir 0 en estos momentos.',
	'You must select at least one event checkbox.' => 'Debe seleccionar al menos una casilla de eventos.',
	'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Plantilla \'[_1]\' (ID:[_2]) creada por \'[_3]\'',
	'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Plantilla \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
	'No Name' => 'Sin nombre',
	'Orphaned' => 'Huérfano',
	'Global Templates' => 'Plantillas globales',
	' (Backup from [_1])' => ' (Copia de [_1])',
	'Error creating new template: ' => 'Error creando nueva plantilla: ',
	'Template Referesh' => 'Refrescar plantilla',
	'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Ignorando plantilla \'[_1]\' ya que parecer ser una plantilla personalizada.',
	'Refreshing template <strong>[_3]</strong> with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>' => 'Reactualizar los modelos <strong>[_3]</strong> desde <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">guardar</a>',
	'Saving [_1] failed: [_2]' => 'Falló al guardar [_1]: [_2]',
	'Skipping template \'[_1]\' since it has not been changed.' => 'Ignorando la plantilla \'[_1]\' ya que no ha sido modificada.',
	'Copy of [_1]' => 'Copia de [_1]',
	'Cannot publish a global template.' => 'No se pudo publicar una plantilla global.',
	'Permission denied: [_1]' => 'Permiso denegado: [_1]',
	'Save failed: [_1]' => 'Fallo al guardar: [_1]',
	'Invalid ID [_1]' => 'ID inválido [_1]',
	'Saving object failed: [_1]' => 'Fallo guardando objeto: [_1]',
	'Load failed: [_1]' => 'Fallo carga: [_1]',
	'(no reason given)' => '(ninguna razón ofrecida)',
	'Widget Template' => 'Plantilla de widget',
	'Widget Templates' => 'Plantillas de widget',
	'Removing [_1] failed: [_2]' => 'Falló el borrado de [_1]: [_2]',
	'template' => 'plantilla',
	'Restoring widget set [_1]... ' => 'Restaurando el conjunto de widgets [_1]... ',
	'Done.' => 'Hecho.',
	'Failed.' => 'Fallo.',

## lib/MT/CMS/Category.pm
	'Subfolder' => 'Subcarpeta',
	'Subcategory' => 'Subcategoría',
	'The [_1] must be given a name!' => '¡Debe dar un nombre a [_1]!',
	'Add a [_1]' => 'Añador un [_1]',
	'No label' => 'Sin título',
	'Category name cannot be blank.' => 'El nombre de la categoría no puede estar en blanco.',
	'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'El nombre de la categría \'[_1]\' tiene conflicto con otra categoría. Las categorías de primer nivel y las sub-categorías con el mismo padre deben tener nombres únicos.',
	'The category basename \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => 'El nombre base de la categoría \'[_1]\' tiene conflictos con otra categoría. Las categorías de primer nivel y las sub-categorías con el mismo padre deben tener nombres base únicos.',
	'Category \'[_1]\' created by \'[_2]\'' => 'Categoría \'[_1]\' creada por \'[_2]\'',
	'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Categoría \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',

## lib/MT/CMS/User.pm
	'Users' => 'Usuarios',
	'Create User' => 'Crear usuario',
	'Can\'t load role #[_1].' => 'No se pudo cargar el rol #[_1].',
	'Roles' => 'Roles',
	'Create Role' => 'Crear rol',
	'(user deleted)' => '(usario borrado)',
	'*User deleted*' => '*Usuario borrado*',
	'Permission denied' => 'Permiso denegado',
	'(newly created user)' => '(nuevo usuario creado)',
	'User Associations' => 'Asociaciones de usuario',
	'Role Users & Groups' => 'Roles de usuarios y grupos',
	'Associations' => 'Asociaciones',
	'(Custom)' => '(Personalizado)',
	'The user' => 'El usuario',
	'User' => 'Usuario',
	'Role name cannot be blank.' => 'El nombre del rol no puede estar vacío.',
	'Another role already exists by that name.' => 'Ya existe otro rol con ese nombre.',
	'You cannot define a role without permissions.' => 'No puede definir un rol sin permisos.',
	'General Settings' => 'Configuración general',
	'Invalid ID given for personal blog theme.' => 'ID inválido para un tema de blog personal.',
	'Invalid ID given for personal blog clone location ID.' => 'ID inválido para el ID de localización de clonación de blog personal.',
	'If personal blog is set, the personal blog location are required.' => 'Si el blog personal está establecido, se necesita la localización del blog personal.',
	'Select a entry author' => 'Seleccione un autor de entradas',
	'Select a page author' => 'Seleccione un autor de páginas', # Translate - New
	'Selected author' => 'Autor seleccionado',
	'Type a username to filter the choices below.' => 'Introduzca un nombre de usuario para filtrar las opciones.',
	'Entry author' => 'Autor de entradas',
	'Page author' => 'Autor de páginas', # Translate - New
	'Select a System Administrator' => 'Seleccione un Administrador del Sistema',
	'Selected System Administrator' => 'Administrador del Sistema seleccionado',
	'System Administrator' => 'Administrador del sistema',
	'represents a user who will be created afterwards' => 'representa un usuario que se creará después',
	'Select Website' => 'Seleccion sitio web',
	'Website Name' => 'Nombre del sitio web',
	'Websites Selected' => 'Sitios web seleccionados',
	'Search Websites' => 'Buscar sitios web',
	'Description' => 'Descripción',
	'Select Blogs' => 'Seleccione blogs',
	'Blog Name' => 'Nombre del blog',
	'Blogs Selected' => 'Blogs seleccionado',
	'Search Blogs' => 'Buscar blogs',
	'Select Users' => 'Seleccionar usuarios',
	'Username' => 'Nombre de usuario',
	'Users Selected' => 'Usuarios seleccionados',
	'Search Users' => 'Buscar usuarios',
	'Select Roles' => 'Seleccionar roles',
	'Role Name' => 'Nombre del rol',
	'Roles Selected' => 'Roles seleccionados',
	'' => '', # Translate - New
	'Grant Permissions' => 'Otorgar permisos',
	'You cannot delete your own association.' => 'No puede borrar sus propias asociaciones.',
	'You cannot delete your own user record.' => 'No puede borrar el registro de su propio usario.',
	'You have no permission to delete the user [_1].' => 'No tiene permisos para borrar el usario [_1].',
	'User requires username' => 'El usario necesita un nombre de usuario',
	'[_1] contains an invalid character: [_2]' => '[_1] contiene un caracter no válido: [_2]',
	'User requires display name' => 'El usuario necesita un nombre público',
	'Display Name' => 'Nombre público',
	'A user with the same name already exists.' => 'Ya existe un usuario con el mismo nombre.',
	'User requires password' => 'El usario necesita una contraseña',
	'Email Address is required for password recovery' => 'La dirección de correo es necesaria para la recuperación de la contraseña',
	'Email Address is invalid.' => 'La dirección de correo no es válida.',
	'URL is invalid.' => 'La URL no es válida.',
	'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Usuario \'[_1]\' (ID:[_2]) creado por \'[_3]\'',
	'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Usuario \'[_1]\' (ID:[_2]) borrado por \'[_3]\'',

## lib/MT/CMS/Asset.pm
	'Assets' => 'Multimedia',
	'Files' => 'Ficheros',
	'Extension changed from [_1] to [_2]' => 'La extensión cambió de [_1] a [_2]',
	'Upload File' => 'Transferir fichero',
	'Can\'t load file #[_1].' => 'No se pudo cargar el fichero nº[_1].',
	'File \'[_1]\' uploaded by \'[_2]\'' => 'Fichero \'[_1]\' transferido por \'[_2]\'',
	'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Fichero \'[_1]\' (ID:[_2]) transferido por \'[_3]\'',
	'[_1] of this website' => '[_1] de este sitio web',
	'All Assets' => 'Todos los ficheros multimedia',
	'Untitled' => 'Sin título',
	'Archive Root' => 'Raíz de archivos',
	'Site Root' => 'Raíz del sitio',
	'Please select a file to upload.' => 'Por favor, seleccione el fichero a transferir',
	'Invalid filename \'[_1]\'' => 'Nombre de fichero no válido \'[_1]\'',
	'Please select an audio file to upload.' => 'Por favor, seleccione el fichero de audio a transferir.',
	'Please select an image to upload.' => 'Por favor, seleccione una imagen a transferir.',
	'Please select a video to upload.' => 'Por favor, seleccione un video a transferir. Please select a video to upload.',
	'Movable Type was unable to write on the "Upload Destination". Please make sure that the folder is writable from the web server.' => 'Movable Type no pudo escribir en el "Destino de las transferencias". Por favor, asegúrese de que el servidor web puede escribir en el directorio.',
	'Invalid extra path \'[_1]\'' => 'Ruta extra no válida \'[_1]\'',
	'Can\'t make path \'[_1]\': [_2]' => 'No se puede crear la ruta \'[_1]\': [_2]',
	'Invalid temp file name \'[_1]\'' => 'Nombre de fichero temporal no válido \'[_1]\'',
	'Error opening \'[_1]\': [_2]' => 'Error abriendo \'[_1]\': [_2]',
	'Error deleting \'[_1]\': [_2]' => 'Error borrando \'[_1]\': [_2]',
	'File with name \'[_1]\' already exists. (Install File::Temp if you\'d like to be able to overwrite existing uploaded files.)' => 'Ya existe un fichero con el nombre \'[_1]\'. (Instale File::Temp si desea sobreescribir ficheros transferidos existentes).',
	'Error creating temporary file; please check your TempDir setting in your coniguration file (currently \'[_1]\') this location should be writable.' => 'Error creando un fichero temporal; por favor, compruebe que se puede escribir en la ruta especificada en la opción TempDir en el fichero de configuración (actualmente \'[_1]\').',
	'unassigned' => 'no asignado',
	'File with name \'[_1]\' already exists; Tried to write to tempfile, but open failed: [_2]' => 'Ya existe un fichero con el nombre \'[_1]\'; se intentó escribir en un fichero temporal, pero hubo un error al abrirlo: [_2]',
	'Could not create upload path \'[_1]\': [_2]' => 'No se pudo crear la ruta de transferencias \'[_1]\': [_2]',
	'Error writing upload to \'[_1]\': [_2]' => 'Error escribiendo transferencia a \'[_1]\': [_2]',
	'Uploaded file is not an image.' => 'El fichero transferido no es una imagen.',
	'<' => '<',
	'/' => '/',

## lib/MT/CMS/Log.pm
	'All Feedback' => 'Todas las opiniones',
	'Publishing' => 'Publicación',
	'Activity Log' => 'Actividad',
	'System Activity Feed' => 'Sindicación de la actividad',
	'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'El registro de actividad del blog \'[_1]\' (ID:[_2]) fue reiniciado por  \'[_3]\'',
	'Activity log reset by \'[_1]\'' => 'Registro de actividad reiniciado por \'[_1]\'',

## lib/MT/CMS/Export.pm
	'Please select a blog.' => 'Por favor, seleccione un blog.',
	'You do not have export permissions' => 'No tiene permisos de exportación',

## lib/MT/CMS/Blog.pm
	'Cloning blog \'[_1]\'...' => 'Clonando un blog',
	'Error' => 'Error',
	'Finished! You can <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">return to the blog listing</a>.' => '¡Finalizó! Puede <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">regresar a la lista de blogs</a>.',
	'Close' => 'Cerrar',
	'Plugin Settings' => 'Configuración de extensiones',
	'Settings' => 'Configuración',
	'New Blog' => 'Nuevo blog',
	'[_1] Activity Feed' => 'Sindicación de actividad de [_1]',
	'Go Back' => 'Ir atrás',
	'Can\'t load entry #[_1].' => 'No se pudo cargar la entrada #[_1].',
	'Can\'t load template #[_1].' => 'No se pudo cargar la plantilla #[_1].',
	'index template \'[_1]\'' => 'plantilla índice \'[_1]\'',
	'[_1] \'[_2]\'' => '[_1] \'[_2]\'',
	'Publish Site' => 'Publicar sitio',
	'Invalid blog' => 'Blog no válido',
	'Select Blog' => 'Seleccione blog',
	'Selected Blog' => 'Blog seleccionado',
	'Type a blog name to filter the choices below.' => 'Introduzca un nombre de blog para filtrar las opciones de abajo.',
	'[_1] changed from [_2] to [_3]' => '[_1] cambió de [_2] a [_3]',
	'Saved [_1] Changes' => 'Guardados los cambios de [_1]',
	'Saving permissions failed: [_1]' => 'Fallo guardando permisos: [_1]',
	'[_1] \'[_2]\' (ID:[_3]) created by \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) creado por \'[_4]\'',
	'You did not specify a blog name.' => 'No especificó el nombre del blog.',
	'Site URL must be an absolute URL.' => 'La URL del sitio debe ser una URL absoluta.',
	'Archive URL must be an absolute URL.' => 'La URL de archivo debe ser una URL absoluta.',
	'You did not specify an Archive Root.' => 'No ha especificado un Archivo raíz.',
	'The number of revisions to store must be a positive integer.' => 'El número de revisiones a guardar debe ser un número entero positivo.',
	'Blog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) borrado por \'[_3]\'',
	'Saving blog failed: [_1]' => 'Fallo guardando blog: [_1]',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Error: Movable Type no puede escribir en el directorio de caché de las plantillas. Por favor, compruebe los permisos del directorio llamado <code>[_1]</code> dentro del directorio de su blog.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Error: Movable Type no pudo crear un directorio para cachear las plantillas dinámicas. Debe crear un directorio llamado <code>[_1]</code> dentro del directorio de su blog.',
	'No blog was selected to clone.' => 'Ningún blog ha sido seleccionado para ser clonado.',
	'This action can only be run on a single blog at a time.' => 'Esta acción solo se puede ejecutar en un solo blog a la vez.',
	'Invalid blog_id' => 'blog_id no válido',
	'This action cannot clone website.' => 'Esta acción no puede clonar un sitio web.',
	'Clone of [_1]' => 'Clon de [_1]',
	'Entries must be cloned if comments and trackbacks are cloned' => 'Las entradas tienen que clonarse su se clonan los comentarios y trackbacks',
	'Entries must be cloned if comments are cloned' => 'Las entradas deben clonarse si se clonan los comentarios',
	'Entries must be cloned if trackbacks are cloned' => 'Las entradas deben clonarse si se clonan los trackbacks',
	'Clone Blog' => 'Clonar blog',

## lib/MT/CMS/TrackBack.pm
	'TrackBacks' => 'TrackBacks',
	'Junk TrackBacks' => 'TrackBacks basura',
	'TrackBacks where <strong>[_1]</strong> is &quot;[_2]&quot;.' => 'TrackBacks donde <strong>[_1]</strong> es &quot;[_2]&quot;.',
	'TrackBack Activity Feed' => 'Sindicación de la actividad de TrackBacks',
	'(Unlabeled category)' => '(Categoría sin título)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) desde \'[_2]\' borrado por \'[_3]\' de la categoría \'[_4]\'',
	'(Untitled entry)' => '(Entrada sin título)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) desde \'[_2]\' borrado por \'[_3]\' de la entrada \'[_4]\'',
	'No Excerpt' => 'Sin resumen',
	'No Title' => 'Sin título',
	'Orphaned TrackBack' => 'TrackBack huérfano',
	'category' => 'categoría',

## lib/MT/CMS/Dashboard.pm
	'Error: This blog doesn\'t have a parent website.' => 'Error: Este blog no tiene un sitio web padre.', # Translate - New
	'Design with Themes' => 'Diseñado con temas',
	'Create and apply a theme to change blog templates, categories and other configurations.' => 'Cree y aplique un tema para cambiar las plantillas, categorías y otras configuraciones del blog.',
	'Website Management' => 'Administración del sitio web',
	'Manage multiple blogs for each website. Now, it\'s much easier to create a portal with MultiBlog.' => 'Gestione múltiples blogs en cada sitio web. Ahora, es más fácil crear un portal con MultiBlog.',
	'Revision History' => 'Histórico de revisiones',
	'The revision history for entries and templates protects users from unexpected modification.' => 'El histórico de revisiones de las entradas y las plantillas protege a los usuarios de modificaciones no esperadas.',

## lib/MT/CMS/Common.pm
	'Permisison denied.' => 'Permiso denegado.',
	'The Template Name and Output File fields are required.' => 'Los campos del nombre de la plantilla y el fichero de salida son obligatorios.',
	'Invalid type [_1]' => 'Tipo inválido [_1]',
	'\'[_1]\' edited the template \'[_2]\' in the blog \'[_3]\'' => '\'[_1]\' editó la plantilla \'[_2]\' en el blog \'[_3]\'',
	'\'[_1]\' edited the global template \'[_2]\'' => '\'[_1]\' editó la plantilla global \'[_2]\'',
	'Invalid parameter' => 'Parámetro no válido',
	'Notification List' => 'Lista de notificaciones',
	'IP Banning' => 'Bloqueo de IPs',
	'Removing tag failed: [_1]' => 'Falló el borrado de la etiqueta: [_1]',
	'Loading MT::LDAP failed: [_1].' => 'Falló la carga de MT::LDAP: [_1].',
	'System templates can not be deleted.' => 'Las plantillas del sistema no se pueden borrar.',
	'Can\'t load [_1] #[_1].' => 'No se pudo cargar [_1] #[_1].',
	'Saving snapshot failed: [_1]' => 'Fallo al guardar instantánea: [_1]',

## lib/MT/CMS/BanList.pm
	'You did not enter an IP address to ban.' => 'No tecleó una dirección IP para bloquear.',
	'The IP you entered is already banned for this blog.' => 'La IP que introdujo ya está bloqueada en este blog.',

## lib/MT/CMS/Plugin.pm
	'Plugin Set: [_1]' => 'Conjuntos de extensiones: [_1]',
	'Individual Plugins' => 'Extensiones individuales',

## lib/MT/CMS/AddressBook.pm
	'No permissions.' => 'Sin permisos.',
	'No entry ID provided' => 'ID de entrada no provista',
	'No such entry \'[_1]\'' => 'No existe la entrada \'[_1]\'',
	'No email address for user \'[_1]\'' => 'No hay dirección de correo electrónico asociada al usario \'[_1]\'',
	'No valid recipients found for the entry notification.' => 'No se encontraron destinatarios válidos para la notificación de la entrada.',
	'[_1] Update: [_2]' => '[_1] Actualiza: [_2]',
	'Error sending mail ([_1]); try another MailTransfer setting?' => 'Error enviando correo electrónico ([_1]); ¿quizás probando con otra configuración para MailTransfer?',
	'The value you entered was not a valid email address' => 'El valor que tecleó no es una dirección válida de correo electrónico',
	'The value you entered was not a valid URL' => 'La URL que introdujo no es válida.',
	'The e-mail address you entered is already on the Notification List for this blog.' => 'La dirección de correo que introdujo ya está en la Lista de notificaciones de este blog.',
	'Subscriber \'[_1]\' (ID:[_2]) deleted from address book by \'[_3]\'' => 'Suscriptor \'[_1]\' (ID:[_2]) borrado de la agenda por \'[_3]\'',

## lib/MT/CMS/Tools.pm
	'Password Recovery' => 'Recuperación de contraseña',
	'Email Address is required for password recovery.' => 'La dirección de correo es necesaria para la recuperación de contraseña.',
	'User not found' => 'Usuario no encontrado',
	'Error sending mail ([_1]); please fix the problem, then try again to recover your password.' => 'Error enviando correo ([_1]); por favor, solvente el problema e inténte de nuevo la recuperación de la contraseña.',
	'Password reset token not found' => 'Token para el reinicio de la contraseña no encontrado',
	'Email address not found' => 'Dirección de correo no encontrada',
	'Your request to change your password has expired.' => 'Expiró su solicitud de cambio de contraseña.',
	'Invalid password reset request' => 'Solicitud de reinicio de contraseña no válida',
	'Please confirm your new password' => 'Por favor, confirme su nueva contraseña',
	'Passwords do not match' => 'Las contraseñas no coinciden',
	'That action ([_1]) is apparently not implemented!' => '¡La acción ([_1]) aparentemente no está implementada!',
	'You don\'t have a system email address configured.  Please set this first, save it, then try the test email again.' => 'No tiene configurada una dirección de correo para el sistema. Por favor, configúrela primero, guárdela y luego intente enviar el correo de prueba.',
	'Please enter a valid email address' => 'Por favor, introduzca una dirección de correo válida',
	'Test email from Movable Type' => 'Correo de prueba de Movable Type',
	'This is the test email sent by your installation of Movable Type.' => 'Este es el correo de prueba enviado por su instalación de Movable Type.',
	'Mail was not properly sent' => 'El correo no se envió correctamente',
	'Test e-mail was successfully sent to [_1]' => 'El correo de prueba fue enviado con éxito a [_1]',
	'These setting(s) are overridden by a value in the MT configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.' => 'Esta configuración está sobreescrita por un valor en el fichero de configuración de MT: [_1]. Elimine el valor del fichero de configuración para controlar el valor desde esta página.',
	'Email address is [_1]' => 'La dirección de correo es [_1]',
	'Debug mode is [_1]' => 'El modo de depuración es [_1]',
	'Performance logging is on' => 'El histórico de rendimiento está activado',
	'Performance logging is off' => 'El histórico de rendimiento está desactivado',
	'Performance log path is [_1]' => 'La ruta del histórico de rendimiento es [_1]',
	'Performance log threshold is [_1]' => 'El umbral del histórico de rendimiento es [_1]',
	'System Settings Changes Took Place' => 'Se realizaron los cambios en la configuración del sistema',
	'Invalid password recovery attempt; can\'t recover password in this configuration' => 'Intento de recuperación de contraseña no válido; no se pudo recuperar la clave con esta configuración',
	'Invalid author_id' => 'author_id no válido',
	'Backup' => 'Copia de seguridad',
	'Backup & Restore' => 'Copias de seguridad',
	'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.' => 'Debe poderse escribir en el directorio temporal para que las copias de seguridad funcionen correctamente. Por favor, compruebe la opción de configuración TempDir.',
	'Temporary directory needs to be writable for restore to work correctly.  Please check TempDir configuration directive.' => 'Debe poder escribirse en el directorio temporal para que las copias de seguridad funcionen correctamente. Por favor, compruebe la opción de configuración TempDir.',
	'No website could be found. You must create a website first.' => 'No se encontró ningún sitio web. Primero debe crear un sitio web.',
	'[_1] is not a number.' => '[_1] no es un número.',
	'Copying file [_1] to [_2] failed: [_3]' => 'Fallo copiandi fichero [_1] en [_2]: [_3]',
	'Specified file was not found.' => 'No se encontró el fichero especificado.',
	'[_1] successfully downloaded backup file ([_2])' => '[_1] descargó con éxito el fichero de copia de seguridad ([_2])',
	'Restore' => 'Restaurar',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ',
	'Some of the actual files for assets could not be restored.' => 'No se pudieron restaurar algunos ficheros multimedia.',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Por favor, use xml, tar.gz, zip, o manifest como extensión de ficheros.',
	'Unknown file format' => 'Formato de fichero desconocido',
	'Some objects were not restored because their parent objects were not restored.' => 'Algunos objetos no se restauraron porque sus objetos ascendentes tampoco fueron restaurados.',
	'Detailed information is in the <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>activity log</a>.' => 'La información detallada se encuentra en el <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>registro de actividad</a>.',
	'[_1] has canceled the multiple files restore operation prematurely.' => '[_1] canceló prematuramente la operación de restauración de varios ficheros.',
	'Changing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Modificando la Ruta del Sitio del blog \'[_1]\' (ID:[_2])...',
	'Removing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Borrando la Ruta del Sitio del blog \'[_1]\' (ID:[_2])...',
	'Changing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Modificando la Ruta de Archivos del blog \'[_1]\' (ID:[_2])...',
	'Removing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Borrando la Ruta de Archivos del blog \'[_1]\' (ID:[_2])...',
	'failed' => 'falló',
	'ok' => 'ok',
	'Changing file path for the asset \'[_1]\' (ID:[_2])...' => 'Modificando la ruta para el fichero multimedia \'[_1]\' (ID:[_2])...',
	'Please upload [_1] in this page.' => 'Por favor, transfiera [_1] a esta página.',
	'File was not uploaded.' => 'El fichero no fue transferido.',
	'Restoring a file failed: ' => 'Falló la restauración de un fichero:',
	'Some of the files were not restored correctly.' => 'No se restauraron correctamente algunos de los ficheros.',
	'Successfully restored objects to Movable Type system by user \'[_1]\'' => 'El usuario \'[_1]\' restauró objetos en el sistema Movable Type con éxito.',
	'Can\'t recover password in this configuration' => 'No se pudo recuperar la clave con esta configuración',
	'Invalid user name \'[_1]\' in password recovery attempt' => 'Nombre de usario no válido \'[_1]\' en intento de recuperación de contraseña',
	'User name or password hint is incorrect.' => 'El nombre del usuario o la contraseña es incorrecto.',
	'User has not set pasword hint; cannot recover password' => 'El usuario no ha configurado una pista para la contraseña; no se pudo recuperar',
	'Invalid attempt to recover password (used hint \'[_1]\')' => 'Intento inválido de recuperación de la contraseña (pista usada \'[_1]\')',
	'User \'[_1]\' (user #[_2]) does not have email address' => 'El usuario \'[_1]\' (usuario #[_2]) no tiene dirección de correo',
	'A password reset link has been sent to [_3] for user  \'[_1]\' (user #[_2]).' => 'Se ha envíado el enlace del reinicio de la contraseña para el usuario \'[_1]\' a [_3] (usario #[_2]).',
	'Some objects were not restored because their parent objects were not restored.  Detailed information is in the <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">activity log</a>.' => 'Algunos objetos no se restauraron porque sus objetos padres no se restauraron. Dispone de información detallada en el <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">registro de actividad</a>.',
	'[_1] is not a directory.' => '[_1] no es un directorio.',
	'Error occured during restore process.' => 'Ocurrió un error durante el proceso de restauración.',
	'Some of files could not be restored.' => 'Algunos ficheros no se restauraron.',
	'Uploaded file was not a valid Movable Type backup manifest file.' => 'El fichero transferido no era un fichero no válido de manifiesto de copia de seguridad de Movable Type.',
	'Blog(s) (ID:[_1]) was/were successfully backed up by user \'[_2]\'' => 'Las copias de seguridad de el/los blog(s) (ID:[_1]) se hizo/hicieron correctamente por el usuario  \'[_2]\'',
	'Movable Type system was successfully backed up by user \'[_1]\'' => 'El usuario \'[_1]\' realizó con éxito una copia de seguridad del sistema de Movable Type',
	'Some [_1] were not restored because their parent objects were not restored.' => 'Algunos [_1] no se restauraron porque sus objetos ascendentes no se restauraron.',

## lib/MT/CMS/Entry.pm
	'(untitled)' => '(sin título)',
	'New Entry' => 'Nueva entrada',
	'New Page' => 'Nueva página',
	'None' => 'Ninguno',
	'pages' => 'páginas',
	'Category' => 'Categoría',
	'Asset' => 'Multimedia',
	'Tag' => 'Etiqueta',
	'Entry Status' => 'Estado de la entrada',
	'[_1] Feed' => 'Sindicación de [_1]',
	'Can\'t load template.' => 'No se pudo cargar la plantilla.',
	'New [_1]' => 'Nuevo [_1]',
	'No such [_1].' => 'No existe [_1].',
	'Same Basename has already been used. You should use an unique basename.' => 'Ya se ha utilizado el mismo nombre base. Debe usar un nombre base único.',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Su blog no tiene configurados la URL y la raíz del sitio. No puede publicar entradas hasta que no estén definidos.',
	'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Fecha no válida \'[_1]\'; debe tener el formato YYYY-MM-DD HH:MM:SS.',
	'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Fecha no válida \'[_1]\'; debe ser una fecha real.',
	'[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'',
	'[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_1] \'[_2]\' (ID:[_3]) editado y cambió su estado desde [_4] a [_5] al usuario \'[_6]\'',
	'[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) editado por el usuario \'[_4]\'',
	'Saving placement failed: [_1]' => 'Fallo guardando situación: [_1]',
	'Saving entry \'[_1]\' failed: [_2]' => 'Fallo guardando entrada \'[_1]\': [_2]',
	'Removing placement failed: [_1]' => 'Fallo eliminando lugar: [_1]',
	'Ping \'[_1]\' failed: [_2]' => 'Falló ping \'[_1]\' : [_2]',
	'(user deleted - ID:[_1])' => '(usuario borrado - ID:[_1])',
	'<a href="[_1]">QuickPost to [_2]</a> - Drag this link to your browser\'s toolbar, then click it when you are visiting a site that you want to blog about.' => '<a href="[_1]">QuickPost a [_2]</a> - Arrastre este enlace a la barra de dirección de su navegador y haga clic en él cuando visite un sitio web sobre el que desee escribir en el blog.',
	'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Entrada \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
	'Need a status to update entries' => 'Necesita indicar un estado para actualizar las entradas',
	'Need entries to update status' => 'Necesita entradas para actualizar su estado',
	'One of the entries ([_1]) did not actually exist' => 'Una de las entradas ([_1]) no existe actualmente',
	'[_1] \'[_2]\' (ID:[_3]) status changed from [_4] to [_5]' => '[_1] \'[_2]\' (ID:[_3]) cambió de estado de [_4] a [_5]',

## lib/MT/CMS/Comment.pm
	'Edit Comment' => 'Editar comentario',
	'Orphaned comment' => 'Comentario huérfano',
	'Comments Activity Feed' => 'Sindicación de la actividad de comentarios',
	'Commenters' => 'Comentaristas',
	'Authenticated Commenters' => 'Comentaristas autentificados',
	'No such commenter [_1].' => 'No existe el comentarista [_1].',
	'User \'[_1]\' trusted commenter \'[_2]\'.' => 'Usuario \'[_1]\' confió en el comentarista \'[_2]\'.',
	'User \'[_1]\' banned commenter \'[_2]\'.' => 'Usuario \'[_1]\' bloqueó al comentarista \'[_2]\'.',
	'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'Usuario \'[_1]\' desbloqueó al comentarista \'[_2]\'.',
	'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'Usuario \'[_1]\' desconfió del comentarista \'[_2]\'.',
	'Invalid request' => 'Petición no válida',
	'An error occurred: [_1]' => 'Ocurrió un error: [_1]',
	'Parent comment id was not specified.' => 'ID de comentario padre no se especificó.',
	'Parent comment was not found.' => 'El comentario padre no se encontró.',
	'You can\'t reply to unapproved comment.' => 'No puede responder a un comentario no aprobado.',
	'Publish failed: [_1]' => 'Falló la publicación: [_1]',
	'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Comentario (ID:[_1]) por \'[_2]\' borrado por \'[_3]\' de la entrada \'[_4]\'',
	'You don\'t have permission to approve this trackback.' => 'No tiene permisos para aprobar este trackback.',
	'Comment on missing entry!' => '¡Comentario en entrada inexistente!',
	'You don\'t have permission to approve this comment.' => 'No tiene permiso para aprobar este comentario.',
	'You can\'t reply to unpublished comment.' => 'No puede contestar a comentarios no publicados.',
	'Registered User' => 'Usuario registrado',

## lib/MT/CMS/Theme.pm
	'Themes' => 'Temas',
	'Theme not found' => 'Tema no encontrado',
	'Failed to uninstall theme' => 'Fallo al desinstalar el tema',
	'Failed to uninstall theme: [_1]' => 'Fallo al desinstalar el tema: [_1]',
	'Theme from [_1]' => 'Tema de [_1]',
	'Install into themes directory' => 'Instalar en el directorio de temas', # Translate - New
	'Download [_1] archive' => 'Descargar archivo de [_1]', # Translate - New
	'Failed to save theme export info: [_1]' => 'Fallo al guardar la información de exportación del tema: [_1]',
	'Themes Directory [_1] is not writable.' => 'No se puede escribir en el directorio de los temas [_1].',
	'Error occurred during exporting [_1]: [_2]' => 'Ocurrió un error durante la exportación de [_1]: [_2]',
	'Error occurred during finalizing [_1]: [_2]' => 'Ocurrió un error durante la finalización de [_1]: [_2]',
	'Error occurred while publishing theme: [_1]' => 'Ocurrió un error durante la publicación del tema: [_1]',

## lib/MT/CMS/Website.pm
	'New Website' => 'Nuevo sitio web',
	'Website \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Sitio web \'[_1]\' (ID:[_2]) borrado por \'[_3]\'',
	'Selected Website' => 'Sitio web seleccionado',
	'Type a website name to filter the choices below.' => 'Teclee el nombre de un sitio web para filtrar las opciones de abajo.',
	'Can\'t load website #[_1].' => 'No se pudo cargar el sitio web #[_1].',
	'Blog \'[_1]\' (ID:[_2]) moved from \'[_3]\' to \'[_4]\' by \'[_5]\'' => 'Blog \'[_1]\' (ID:[_2]) trasladado de \'[_3]\' a \'[_4]\' por \'[_5]\'',

## lib/MT/CMS/Search.pm
	'No [_1] were found that match the given criteria.' => 'Ningún [_1] ha sido encontrado que corresponda al criterio dado.',
	'Entry Body' => 'Cuerpo de la entrada',
	'Extended Entry' => 'Entrada extendida',
	'Keywords' => 'Palabras claves',
	'Basename' => 'Nombre base',
	'Comment Text' => 'Comentario',
	'IP Address' => 'Dirección IP',
	'Source URL' => 'URL origen',
	'Page Body' => 'Cuerpo de la página',
	'Extended Page' => 'Página extendida',
	'Template Name' => 'Nombre de la plantilla',
	'Text' => 'Texto',
	'Linked Filename' => 'Fichero enlazado',
	'Output Filename' => 'Fichero salida',
	'Filename' => 'Nombre del fichero',
	'Label' => 'Título',
	'Log Message' => 'Mensaje del registro',
	'Site URL' => 'URL del sitio',
	'Search & Replace' => 'Buscar & Reemplazar',
	'Invalid date(s) specified for date range.' => 'Se especificaron fechas no válidas para el rango.',
	'Error in search expression: [_1]' => 'Error en la expresión de búsqueda: [_1]',
	'Saving object failed: [_2]' => 'Fallo al guardar objeto: [_2]',
	'Blogs' => 'Blogs',
	'Websites' => 'Sitios web',

## lib/MT/Compat/v3.pm
	'uses: [_1], should use: [_2]' => 'usa: [_1], debería usar: [_2]',
	'uses [_1]' => 'usa [_1]',
	'No executable code' => 'No es código ejecutable',
	'Publish-option name must not contain special characters' => 'El nombre de la opción de publicar no debe contener caracteres especiales',

## lib/MT/FileMgr/FTP.pm
	'Creating path \'[_1]\' failed: [_2]' => 'Fallo creando la ruta \'[_1]\': [_2]',
	'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Fallo renombrando \'[_1]\' a \'[_2]\': [_3]',
	'Deleting \'[_1]\' failed: [_2]' => 'Fallo borrando \'[_1]\': [_2]',

## lib/MT/FileMgr/DAV.pm
	'DAV connection failed: [_1]' => 'Falló la conexión DAV: [_1]',
	'DAV open failed: [_1]' => 'Falló la orden \'open\' en el DAV: [_1]',
	'DAV get failed: [_1]' => 'Falló la orden \'get\' en el DAV: [_1]',
	'DAV put failed: [_1]' => 'Falló la orden \'put\' en el DAV: [_1]',

## lib/MT/FileMgr/Local.pm
	'Opening local file \'[_1]\' failed: [_2]' => 'Fallo abriendo el fichero local \'[_1]\': [_2]',

## lib/MT/FileMgr/SFTP.pm
	'SFTP connection failed: [_1]' => 'Fallo en la conexión SFTP: [_1]',
	'SFTP get failed: [_1]' => 'Falló la orden \'get\' en el SFTP: [_1]',
	'SFTP put failed: [_1]' => 'Falló la orden \'put\' en el SFTP: [_1]',

## lib/MT/Theme/TemplateSet.pm
	'A template set containing [_1] templates, [_2] widgets, and [_3] widget sets.' => 'Un conjunto de plantillas que contiene  [_1] plantillas, [_2] widgets y [_3] conjuntos de widgets.',
	'Widget Sets' => 'Conjuntos de widgets',
	'Failed to make templates directory: [_1]' => 'Fallo al crear el directorio de plantillas: [_1]',
	'Failed to publish template file: [_1]' => 'Fallo al publicar el fichero de plantilla: [_1]',
	'exported_template set' => 'exported_template configurado',

## lib/MT/Theme/Element.pm
	'Component \'[_1]\' is not found.' => 'No se encontró el componente \'[_1]\'.',
	'Internal error: the importer is not found.' => 'Error interno: no se encontró el importador.',
	'Compatibility error occured while applying \'[_1]\': [_2].' => 'Ocurrió un error de compatibilidad cuando se aplicaba \'[_1]\': [_2].',
	'Fatal error occured while applying \'[_1]\': [_2].' => 'Ocurrió un error fatal cuando se aplicaba \'[_1]\': [_2].',
	'Importer for \'[_1]\' is too old.' => 'El importador de \'[_1]\' es demasiado antiguo.',
	'Theme element \'[_1]\' is too old for this environment.' => 'El elemento \'[_1]\' del tema es demasiado antiguo para este sistema.',

## lib/MT/Theme/StaticFiles.pm
	'List the name of one directory to be included in your theme on each line.' => 'Lista el nombre de un directorio para incluirlo en el tema en cada línea.',

## lib/MT/Theme/Pref.pm
	'this element cannot apply for non blog object.' => 'este elemento no puede aplicarse a objetos que no sean blogs.',
	'default settings for [_1]' => 'configuración predefinida para [_1]',
	'default settings' => 'configuración predefinida',

## lib/MT/Theme/Category.pm
	'[_1] top level and [_2] sub categories.' => '[_1] primer nivel y [_2] sub-categorías.',
	'[_1] top level and [_2] sub folders.' => '[_1] primer nivel y [_2] sub-carpetas.',

## lib/MT/Theme/Entry.pm
	'[_1] pages' => '[_1] páginas',

## lib/MT/BackupRestore/ManifestFileHandler.pm

## lib/MT/BackupRestore/BackupFileHandler.pm
	'Uploaded file was backed up from Movable Type but the different schema version ([_1]) from the one in this system ([_2]).  It is not safe to restore the file to this version of Movable Type.' => 'El fichero transferido es una copia de seguridad de Movable Type pero con una versión del esquema de datos diferente ([_1]) al de este sistema ([_2]). No es seguro restaurar el fichero en esta versión de Movable Type.',
	'[_1] is not a subject to be restored by Movable Type.' => '[_1] no es un elemento para ser restaurado por Movable Type.',
	'[_1] records restored.' => '[_1] registros restaurados.',
	'Restoring [_1] records:' => 'Restaurando [_1] registros:',
	'User with the same name as the name of the currently logged in ([_1]) found.  Skipped the record.' => 'Se encontró un usuario con el mismo nombre que la persona identificada ([_1]). Saltar la identificación.',
	'User with the same name \'[_1]\' found (ID:[_2]).  Restore replaced this user with the data backed up.' => 'Se encontró un usuario con el mismo nombre \'[_1]\' (ID:[_2]). La restauración reemplazó este usuario con los datos de la copia de seguridad.',
	'Tag \'[_1]\' exists in the system.' => 'La etiqueta \'[_1]\' existe en el sistema.',
	'[_1] records restored...' => '[_1] registros restaurados...',
	'The role \'[_1]\' has been renamed to \'[_2]\' because a role with the same name already exists.' => 'El rol \'[_1]\' se ha renombrado como \'[_2]\' porque ya existía un rol con el mismo nombre.',

## lib/MT/Template/Tags/Calendar.pm
	'You used an [_1] tag without a date context set up.' => 'Usó una etiqueta [_1] sin un contexto de fecha configurado.',
	'Invalid month format: must be YYYYMM' => 'Formato de mes no válido: debe ser YYYYMM',
	'No such category \'[_1]\'' => 'No existe la categoría \'[_1]\'',
	'You used an [_1] tag outside of the proper context.' => 'Usó una etiqueta [_1] fuera del contexto correcto.',

## lib/MT/Template/Tags/Folder.pm

## lib/MT/Template/Tags/Category.pm
	'MT[_1] must be used in a [_2] context' => 'MT[_1] debe utilizarse en el contexto de [_2]',
	'Cannot find package [_1]: [_2]' => 'No se encontró el paquete [_1]: [_2]',
	'Error sorting [_2]: [_1]' => 'Error ordenando [_2]: [_1]',
	'[_1] cannot be used without publishing Category archive.' => '[_1] No se puede usar sin publicar archivos por categorías.',
	'[_1] used outside of [_2]' => '[_1] utilizado fuera de [_2]',

## lib/MT/Template/Tags/Asset.pm
	'No such user \'[_1]\'' => 'No existe el usario \'[_1]\'',
	'You have an error in your \'[_2]\' attribute: [_1]' => 'Tiene un error en el atributo \'[_2]\': [_1]',

## lib/MT/Template/Tags/Archive.pm
	'Group iterator failed.' => 'Fallo en iterador de grupo.',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] sólo se puede usar con los archivos diarios, semanales o mensuales.',
	'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Usó una etiqueta [_1] enlazando los archivos \'[_2]\', pero el tipo de archivo no está publicado.',
	'Could not determine entry' => 'No se pudo determinar la entrada',

## lib/MT/Template/Tags/Commenter.pm

## lib/MT/Template/Tags/Misc.pm
	'name is required.' => 'el nombre es obligatorio.',
	'Specified WidgetSet \'[_1]\' not found.' => 'No se encontró el conjunto de widgets \'[_1]\' que se especificó.',
	'' => '', # Translate - New

## lib/MT/Template/Tags/Ping.pm
	'<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> debe utilizarse en el contexto de una categoría, o con el atributo \'category\' en la etiqueta.',

## lib/MT/Template/Tags/Entry.pm
	'You used <$MTEntryFlag$> without a flag.' => 'Usó <$MTEntryFlag$> sin \'flag\'.',
	'Could not create atom id for entry [_1]' => 'No se pudo crear un identificador atom en la entrada [_1]',

## lib/MT/Template/Tags/Comment.pm
	'The MTCommentFields tag is no longer available; please include the [_1] template module instead.' => 'La etiqueta MTCommentFields no está más disponible; por favor incluya el módulo de platilla [_1] que lo remplaza',
	'Comment Form' => 'Formulario de comentarios',
	'To enable comment registration, you need to add a TypePad token in your weblog config or user profile.' => 'Para activar el registro de comentarios, debe añadir un token de TypePad a la configuración del weblog o al perfil de usuario.',

## lib/MT/Template/Tags/Author.pm
	'The \'[_2]\' attribute will only accept an integer: [_1]' => 'El atributo \'[_2]\' solo aceptará un entero: [_1]',
	'You used an [_1] without a author context set up.' => 'Utilizó un [_1] sin establecer un contexto de autor.',

## lib/MT/Template/Context.pm
	'The attribute exclude_blogs cannot take \'all\' for a value.' => 'El atributo exclude_blogs no puede tomar el valor \'all\'.',
	'You used an \'[_1]\' tag outside of the context of a author; perhaps you mistakenly placed it outside of an \'MTAuthors\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un autor; ¿quizás la situó por error fuera de un contenedor \'MTAuthors\'?',
	'You used an \'[_1]\' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an \'MTEntries\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de una entrada; ¿quizás la puso por error fuera de un contenedor \'MTEntries\'?',
	'You used an \'[_1]\' tag outside of the context of the website; perhaps you mistakenly placed it outside of an \'MTWebsites\' container?' => '¿Ha utilizado una etiqueta \'[_1]\' fuera del contexto de un sitio web; quizás la situó incorrectamente fuera de un contenedor \'MTWebsites\'?',
	'You used an \'[_1]\' tag outside of the context of the blog; perhaps you mistakenly placed it outside of an \'MTBlogs\' container?' => '¿Ha utilizado una etiqueta \'[_1]\' fuera del contexto del blog; quizás la situó incorrectamente fuera de un contenedor \'MTBlogs\'?',
	'You used an \'[_1]\' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an \'MTComments\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un comentario; ¿quizás la puso por error fuera de un contenedor \'MTComments\'?',
	'You used an \'[_1]\' tag outside of the context of a ping; perhaps you mistakenly placed it outside of an \'MTPings\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un ping; ¿quizás la situó por error fuera de un contenedor \'MTPings\'?',
	'You used an \'[_1]\' tag outside of the context of an asset; perhaps you mistakenly placed it outside of an \'MTAssets\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un fichero multimedia, ¿quizás la situó fuera de un contenedor \'MTAssets\'?',
	'You used an \'[_1]\' tag outside of the context of a page; perhaps you mistakenly placed it outside of a \'MTPages\' container?' => 'Ha usado una etiqueta \'[_1]\' fuera del contexto de una página; ¿quizás la situó fuera de un contenedor \'MTPages\'?',

## lib/MT/Template/ContextHandlers.pm
	'Warning' => 'Alerta',
	'All About Me' => 'Todo sobre mi',
	'Remove this widget' => 'Eliminar el widget',
	'[_1]Publish[_2] your site to see these changes take effect.' => '[_1]Publique[_2] el sitio para que los cambios tomen efecto.',
	'Actions' => 'Acciones',
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.org/documentation/appendices/tags/%t.html',
	'Division by zero.' => 'División por cero.',
	'[_1] is not a hash.' => '[_1] no es un hash.',
	'No [_1] could be found.' => 'No se encontraron [_1].',
	'records' => 'registros',
	'No template to include specified' => 'No se especificó plantilla a incluir',
	'Recursion attempt on [_1]: [_2]' => 'Intento de recursión en [_1]: [_2]',
	'Can\'t find included template [_1] \'[_2]\'' => 'No se encontró la plantilla incluída [_1] \'[_2]\'',
	'Error making path \'[_1]\': [_2]' => 'Error creando la ruta \'[_1]\': [_2]',
	'Writing to \'[_1]\' failed: [_2]' => 'Fallo escribiendo en \'[_1]\': [_2]',
	'Can\'t find blog for id \'[_1]' => 'No se pudo encontrar un blog con el id \'[_1]',
	'Can\'t find included file \'[_1]\'' => 'No se encontró el fichero incluido \'[_1]\'',
	'Error opening included file \'[_1]\': [_2]' => 'Error abriendo el fichero incluido \'[_1]\': [_2]',
	'Recursion attempt on file: [_1]' => 'Intento de recursión en fichero: [_1]',
	'Can\'t load user.' => 'No se pudo cargar el usuario.',
	'Can\'t find template \'[_1]\'' => 'No se encontró la plantilla \'[_1]\'',
	'Can\'t find entry \'[_1]\'' => 'No se encontró la entrada \'[_1]\'',
	'Unspecified archive template' => 'Archivo de plantilla no especificado',
	'Error in file template: [_1]' => 'Error en fichero de plantilla: [_1]',
	'Can\'t load template' => 'No se pudo cargar la plantilla',

## lib/MT/App/Search/Legacy.pm
	'You are currently performing a search. Please wait until your search is completed.' => 'En estos momentos está realizando una búsqueda. Por favor, espere hasta que se complete.',
	'Search failed. Invalid pattern given: [_1]' => 'Falló la búsqueda. Patrón no válido: [_1]',
	'Search failed: [_1]' => 'Falló la búsqueda: [_1]',
	'No alternate template is specified for the Template \'[_1]\'' => 'No se especificó una plantilla alternativa para la Plantilla \'[_1]\'',
	'Publishing results failed: [_1]' => 'Fallo al publicar los resultados: [_1]',
	'Search: query for \'[_1]\'' => 'Búsqueda: encontrar \'[_1]\'',
	'Search: new comment search' => 'Búsqueda: nueva búsqueda de comentarios',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearch funciona con MT::App::Search.',

## lib/MT/App/NotifyList.pm
	'Please enter a valid email address.' => 'Por favor, teclee una dirección de correo válida.',
	'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Falta parámetro obligatorio: blog_id. Por favor, consulte el manual de usuario para configurar las notificaciones.',
	'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Parámetro de redirección no válido. El dueño del weblog debe especificar una ruta que coincida con el del dominio del weblog.',
	'The email address \'[_1]\' is already in the notification list for this weblog.' => 'La dirección de correo-e \'[_1]\' ya está en la lista de notificaciones de este weblog.',
	'Please verify your email to subscribe' => 'Por favor, verifique su dirección de correo electrónico para la subscripción',
	'_NOTIFY_REQUIRE_CONFIRMATION' => 'Se envió un correo a [_1]. Para completar su suscripción,
por favor siga el enlace contenido en este correo. Esto verificará
que la dirección provista es correcta y le pertenece.',
	'The address [_1] was not subscribed.' => 'No se suscribió la dirección [_1].',
	'The address [_1] has been unsubscribed.' => 'Se desuscribió la dirección [_1].',

## lib/MT/App/Comments.pm
	'Error assigning commenting rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable commenting role was found.' => 'Error asignando permisos para comentar al usuario \'[_1] (ID: [_2])\' para el weblog \'[_3] (ID: [_4])\'. No se encontró un rol adecuado.',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Intento de identificación de comentarista no válido desde [_1] en el blog [_2](ID: [_3]) que no permite la autentificación nativa de Movable Type.',
	'Invalid login.' => 'Acceso no válido.',
	'Invalid login' => 'Inicio de sesión no válido',
	'Successfully authenticated but signing up is not allowed.  Please contact system administrator.' => 'La identificación se ha producido con suceso pero la conexión ha sido rechazada.  Por favor contacte el administrador del sistema.',
	'You need to sign up first.' => 'Primero identifíquese',
	'Login failed: permission denied for user \'[_1]\'' => 'Falló la identificación: permiso denegado al usuario \'[_1]\'',
	'Login failed: password was wrong for user \'[_1]\'' => 'Falló la identificación: contraseña errónea del usuario \'[_1]\'',
	'Failed login attempt by disabled user \'[_1]\'' => 'Intento fallido de inicio de sesión por un usuario deshabilitado \'[_1]\'',
	'Failed login attempt by unknown user \'[_1]\'' => 'Intento fallido de inicio de sesión por un usuario desconocido \'[_1]\'',
	'Signing up is not allowed.' => 'No está permitida la inscripción.',
	'Movable Type Account Confirmation' => 'Confirmación de cuenta - Movable Type',
	'System Email Address is not configured.' => 'La dirección de correo del sistema no está configurada.',
	'Commenter \'[_1]\' (ID:[_2]) has been successfully registered.' => 'El comentarista \'[_1]\' (ID:[_2]) se inscribió con éxito.',
	'Thanks for the confirmation.  Please sign in to comment.' => 'Gracias por la confirmación. Por favor, identifíquese para comentar.',
	'[_1] registered to the blog \'[_2]\'' => '[_1] registrado en el blog \'[_2]\'',
	'No id' => 'Sin id',
	'No such comment' => 'No existe dicho comentario',
	'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] bloqueada porque excedió el ritmo de comentarios, más de 8 en [_2] segundos.',
	'IP Banned Due to Excessive Comments' => 'IP bloqueada debido al exceso de comentarios',
	'No entry_id' => 'Sin entry_id',
	'No such entry \'[_1]\'.' => 'No existe la entrada \'[_1]\'.',
	'_THROTTLED_COMMENT' => 'Demasiados comentarios en un corto periodo de tiempo. Por favor, inténtelo dentro de un rato.',
	'Comments are not allowed on this entry.' => 'No se permiten comentarios en esta entrada.',
	'Comment text is required.' => 'El texto del comentario es obligatorio.',
	'Registration is required.' => 'El registro es obligatorio.',
	'Name and email address are required.' => 'El nombre y la dirección de correo-e son obligatorios.',
	'Invalid email address \'[_1]\'' => 'Dirección de correo-e no válida \'[_1]\'',
	'Invalid URL \'[_1]\'' => 'URL no válida \'[_1]\'',
	'Text entered was wrong.  Try again.' => 'El texto que introdujo es erróneo. Inténtelo de nuevo.',
	'Comment save failed with [_1]' => 'Fallo guardando comentario con [_1]',
	'Comment on "[_1]" by [_2].' => 'Comentario en "[_1]" por [_2].',
	'Failed comment attempt by pending registrant \'[_1]\'' => 'Falló el intento de comentar por el comentarista pendiente \'[_1]\'',
	'The sign-in attempt was not successful; please try again.' => 'El intento de registro no tuvo éxito; por favor, inténtelo de nuevo.',
	'No entry was specified; perhaps there is a template problem?' => 'No se especificó ninguna entrada; ¿quizás hay un problema con la plantilla?',
	'Somehow, the entry you tried to comment on does not exist' => 'De alguna manera, la entrada en la que intentó comentar no existe',
	'Invalid entry ID provided' => 'ID de entrada provisto no válido',
	'All required fields must have valid values.' => 'Todos los campos obligatorios deben tener valores válidos.',
	'Commenter profile has successfully been updated.' => 'Se actualizó con éxito el perfil del comentarista.',
	'Commenter profile could not be updated: [_1]' => 'No se pudo actualizar el perfil del comentarista: [_1]',

## lib/MT/App/Search.pm
	'Invalid [_1] parameter.' => 'Parámetro [_1] no válido',
	'Invalid type: [_1]' => 'Tipo no válido: [_1]',
	'Search: failed storing results in cache.  [_1] is not available: [_2]' => 'Búsqueda: Fallo al guardar los resultados en la cache. [_1] no está disponible: [_2]',
	'Invalid format: [_1]' => 'Formato no válido: [_1]',
	'Unsupported type: [_1]' => 'Tipo no soportado: [_1]',
	'Invalid query: [_1]' => 'Consulta no válida: [_1]',
	'Invalid archive type' => 'Tipo de archivo no válido',
	'Invalid value: [_1]' => 'Valor no válido: [_1]',
	'No column was specified to search for [_1].' => 'No se especificó ninguna columna para la búsqueda de [_1].',
	'No such template' => 'No existe dicha plantilla',
	'template_id cannot be a global template' => 'template_id no puede ser una plantilla global',
	'Output file cannot be asp or php' => 'El fichero de salida no puede ser asp o php',
	'You must pass a valid archive_type with the template_id' => 'Debe indicar un archive_type válido con el template_id',
	'Template must have identifier entry_listing for non-Index archive types' => 'La plantilla debe tener un identificador entry_listing para los tipos de archivo que no sean índice',
	'Blog file extension cannot be asp or php for these archives' => 'La extensión de ficheros del blog no puede ser asp o php para estos archivos',
	'Template must have identifier main_index for Index archive type' => 'La plantilla debe tener un identificador main_index para el tipo de archivo índice',
	'The search you conducted has timed out.  Please simplify your query and try again.' => 'La búsqueda que realizaba sobrepasó el tiempo. Por favor, simplifique la consulta e inténtelo de nuevo.',

## lib/MT/App/Trackback.pm
	'Invalid entry ID \'[_1]\'' => 'ID de entrada no válido \'[_1]\'',
	'You must define a Ping template in order to display pings.' => 'Debe definir una plantilla de ping para poderlos mostrar.',
	'Trackback pings must use HTTP POST' => 'Los pings de Trackback deben usar HTTP POST',
	'Need a TrackBack ID (tb_id).' => 'Necesita un ID de TrackBack (tb_id).',
	'Invalid TrackBack ID \'[_1]\'' => 'ID de TrackBack no válido \'[_1]\'',
	'You are not allowed to send TrackBack pings.' => 'No se le permite enviar pings de TrackBack.',
	'You are pinging trackbacks too quickly. Please try again later.' => 'Está enviando pings de TrackBack demasiado rápido. Por favor, inténtelo más tarde.',
	'Need a Source URL (url).' => 'Necesita una URL de origen (url).',
	'This TrackBack item is disabled.' => 'Este elemento de TrackBack fue deshabilitado.',
	'This TrackBack item is protected by a passphrase.' => 'Este elemento de TrackBack está protegido por una contraseña.',
	'TrackBack on "[_1]" from "[_2]".' => 'TrackBack en "[_1]" de "[_2]".',
	'TrackBack on category \'[_1]\' (ID:[_2]).' => 'TrackBack en la categoría \'[_1]\' (ID:[_2]).',
	'Can\'t create RSS feed \'[_1]\': ' => 'No se pudo crear la fuente RSS \'[_1]\': ',
	'New TrackBack Ping to Entry [_1] ([_2])' => 'Nuevo ping de TrackBack en la entrada [_1] ([_2])',
	'New TrackBack Ping to Category [_1] ([_2])' => 'Nuevo ping de TrackBack en la categoría [_1] ([_2])',

## lib/MT/App/Upgrader.pm
	'Could not authenticate using the credentials provided: [_1].' => 'No se pudo autentificar con las credenciales provistas: [_1].',
	'Both passwords must match.' => 'Ambas contraseñas deben coincidir.',
	'You must supply a password.' => 'Debe introducir una contraseña.',
	'An e-mail address is required.' => 'Se necesita una dirección de correo.',
	'The \'Publishing Path\' provided below is not writable by the web server.  Change the ownership or permissions on this directory, then click \'Finish Install\' again.' => 'El servidor web no puede escribir en la \'Ruta de publicación\' provista abajo. Modifique el propietario o los permisos de este directorio y haga clic de nuevo en \'Finalizar instalación\'.',
	'Invalid session.' => 'Sesión no válida.',
	'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Sin permisos. Por favor, contacte con su administrador para la actualización de Movable Type.',
	'Movable Type has been upgraded to version [_1].' => 'Movable Type ha sido actualizado a la versión [_1].',

## lib/MT/App/Wizard.pm
	'The [_1] driver is required to use [_2].' => 'Es necesario el controlador [_1] para usar [_2].',
	'An error occurred while attempting to connect to the database.  Check the settings and try again.' => 'Ocurrió un error intentando conectar a la base de datos. Compruebe la configuración e inténtalo de nuevo.',
	'Please select database from the list of database and try again.' => 'Por favor, seleccione la base de datos de la lista de bases de datos e inténtelo de nuevo.',
	'SMTP Server' => 'Servidor SMTP',
	'Sendmail' => 'Sendmail',
	'Test email from Movable Type Configuration Wizard' => 'Mensaje de comprobación del asistente de configuración de Movable Type',
	'This is the test email sent by your new installation of Movable Type.' => 'Este es el mensaje de comprobación enviado por su nueva instalación de Movable Type.',
	'This module is needed to encode special characters, but this feature can be turned off using the NoHTMLEntities option in mt-config.cgi.' => 'Este módulo es necesario para codificar caracteres especiales, pero se puede desactivar esta característica utilizando la opción NoHTMLEntities en mt-config.cgi.',
	'This module is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'Este módulo es necesario si desea usar el sistema de TrackBack, el ping a weblogs.com, o el ping a Actualizaciones Recientes de MT.',
	'This module is needed if you wish to use the MT XML-RPC server implementation.' => 'Este módulo es necesario si desea usar la implementación del servidor XML-RPC de MT.',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Este módulo es necesario si desea poder sobreescribir los ficheros al subirlos.',
	'This module is required by certain MT plugins available from third parties.' => 'Este módulo lo necesitan algunas extensiones de MT de terceras partes.',
	'This module accelerates comment registration sign-ins.' => 'Este módulo acelera el registro de identificación en los comentarios.',
	'This module is needed to enable comment registration.' => 'Este módulo es necesario para habilitar el registro en los comentarios.',
	'This module enables the use of the Atom API.' => 'Este módulo permite el uso del interfaz (API) de Atom.',
	'This module is required in order to archive files in backup/restore operation.' => 'Este módulo es necesario para archivar ficheros en las operaciones de copias de seguridad y restauración.',
	'This module is required in order to compress files in backup/restore operation.' => 'Este módulo es ncesario para comprimir ficheros en operaciones de copias de seguridad y restauración.',
	'This module is required in order to decompress files in backup/restore operation.' => 'Este módulo es neesario para descomprimir ficheros en las operaciones de copia de seguridad y restauración.',
	'This module and its dependencies are required in order to restore from a backup.' => 'Este módulo y sus dependencias son necesarios para restaurar una copia de seguridad.',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including Vox and LiveJournal.' => 'Este módulo y sus dependencias son necesarios para permitir que los comentaristas se autentifiquen a través de proveedores de OpenID, incluyendo Vox y LiveJournal.',
	'This module is required for sending mail via SMTP Server.' => 'Este módulo es necesario para el envío de correo a través de servidores SMTP.',
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Este módulo es necesario para subir archivos (para determinar el tamaño de las imágenes en diferentes formatos).',
	'This module is required for cookie authentication.' => 'Este módulo es necsario para la autentificación con cookies.',

## lib/MT/App/Viewer.pm
	'Loading blog with ID [_1] failed' => 'Fallo al cargar el blog con el ID [_1]',
	'Template publishing failed: [_1]' => 'Fallo al publicar la plantilla: [_1]',
	'Invalid date spec' => 'Formato de fecha no válido',
	'Can\'t load templatemap' => 'No se pudo cargar el mapa de plantillas',
	'Can\'t load template [_1]' => 'No se pudo cargar la plantilla [_1]',
	'Archive publishing failed: [_1]' => 'Fallo al publicar los archivos: [_1]',
	'Invalid entry ID [_1]' => 'Identificador de entrada no válido [_1]',
	'Entry [_1] is not published' => 'La entrada [_1] no está publicada',
	'Invalid category ID \'[_1]\'' => 'Identificador de categoría no válido \'[_1]\'',

## lib/MT/App/CMS.pm
	'_WARNING_PASSWORD_RESET_MULTI' => 'Va a reiniciar la contraseña de los usuarios seleccionados. Se generarán nuevas contraseñas aleatorias y se enviarán directamente a sus respectivas direcciones de correo electrónico.\n\n¿Desea continuar?',
	'_WARNING_DELETE_USER_EUM' => 'Borrar un usuario es una acción irreversible que crea huérfanos en las entradas del usuario. Si desea retirar un usuario o bloquear su acceso al sistema, se recomienda deshabilitar su cuenta. ¿Está seguro de que desea borrar a los usuarios seleccionados\nPodrán re-crearse a sí mismos si el usuario seleccionado existe en el directorio externo.',
	'_WARNING_DELETE_USER' => 'El borrado de un usuario es una acción irreversible que crea huérfanos de las entradas del usuario. Si desea retirar a un usuario o bloquear su acceso al sistema, la forma recomendada es deshabilitar su cuenta. ¿Está seguro de que desea borrar el/los usuario/s seleccionado/s?',
	'_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' => 'Esta acción restablecerá las plantillas en los blogs seleccionados con la configuración de fábrica. ¿Está seguro de que desea reiniciar las plantillas de los blogs seleccionados?',
	'My [_1] of this [_2]' => 'Mi [_1] de este [_2]',
	'Published [_1]' => '[_1] publicadas',
	'Unpublished [_1]' => '[_1] no publicadas',
	'Scheduled [_1]' => '[_1] programadas',
	'My [_1]' => 'Mis [_1]',
	'[_1] with comments in the last 7 days' => '[_1] con comentarios en los últimos 7 días',
	'[_1] posted between [_2] and [_3]' => '[_1] publicado entre [_2] y [_3]',
	'[_1] posted since [_2]' => '[_1] publicado hace [_2]',
	'[_1] posted on or before [_2]' => '[_1] publicando en o antes de [_2]',
	'Non-spam TrackBacks on this website' => 'TrackBacks no spam en este sitio web',
	'Non-spam Comments on this website' => 'Comentarios no spam en este sitio web',
	'Comments on my entries of [_1]' => 'Comentarios en mis entradas de [_1]',
	'All comments by [_1] \'[_2]\'' => 'Todos los comentarios de [_1] \'[_2]\'',
	'Commenter' => 'Comentarista',
	'All comments for [_1] \'[_2]\'' => 'Todos los comentarios de [_1] \'[_2]\'',
	'Comments posted between [_1] and [_2]' => 'Comentarios publicados entre [_1] y [_2]',
	'Comments posted since [_1]' => 'Comentarios publicados desde [_1]',
	'Comments posted on or before [_1]' => 'Commentarios publicados en o antes de [_1]',
	'You are not authorized to log in to this blog.' => 'No está autorizado para acceder a este blog.',
	'No such blog [_1]' => 'No existe el blog [_1]',
	'Edit Template' => 'Editar plantilla',
	'Unknown object type [_1]' => 'Tipo de objeto desconocido [_1]',
	'Error during publishing: [_1]' => 'Error durante la publicación: [_1]',
	'This is You' => 'Este es Usted',
	'Movable Type News' => 'Noticias de Movable Type',
	'Blog Stats' => 'Estadísticas',
	'Websites and Blogs' => 'Sitios web y blogs', # Translate - New
	'Refresh Templates' => 'Refrescar plantillas',
	'Use Publishing Profile' => 'Utilizar perfil de publicación',
	'Unpublish Entries' => 'Despublicar entradas',
	'Add Tags...' => 'Añadir etiquetas...',
	'Tags to add to selected entries' => 'Etiquetas a añadir en las entradas seleccionadas',
	'Remove Tags...' => 'Borrar entradas...',
	'Tags to remove from selected entries' => 'Etiquetas a borrar de las entradas seleccionadas',
	'Batch Edit Entries' => 'Editar entradas en lote',
	'Unpublish Pages' => 'Despublicar páginas',
	'Tags to add to selected pages' => 'Etiquetas a añadir a las páginas seleccionadas',
	'Tags to remove from selected pages' => 'Etiquetas a eliminar de las páginas seleccionadas',
	'Batch Edit Pages' => 'Editar páginas en lote',
	'Tags to add to selected assets' => 'Etiquetas a añadir a los ficheros multimedia seleccionados',
	'Tags to remove from selected assets' => 'Etiquetas a eliminar de los ficheros multimedia seleccionados',
	'Unpublish TrackBack(s)' => 'Despublicar TrackBack/s',
	'Unpublish Comment(s)' => 'Despublicar comentario/s',
	'Trust Commenter(s)' => 'Confiar en comentarista/s',
	'Untrust Commenter(s)' => 'Desconfiar de comentarista/s',
	'Ban Commenter(s)' => 'Bloquear comentarista/s',
	'Unban Commenter(s)' => 'Desbloquear comentarista/s',
	'Recover Password(s)' => 'Recuperar contraseña/s',
	'Delete' => 'Eliminar',
	'Refresh Template(s)' => 'Refrescar plantilla/s',
	'Move blog(s) ' => 'Trasladar blog(s) ',
	'Publish Template(s)' => 'Publicar plantilla/s',
	'Clone Template(s)' => 'Clonar plantilla/s',
	'Non-spam TrackBacks' => 'Trackback No-Spam',
	'Pending TrackBacks' => 'TrackBacks pendientes',
	'Published TrackBacks' => 'Publicar Trackback',
	'TrackBacks on my entries' => 'Trackback en mis entradas',
	'TrackBacks in the last 7 days' => 'TrackBacks en los últimos 7 días',
	'Spam TrackBacks' => 'TrackBacks spam',
	'Non-spam Comments' => 'Comentarios que no son spam',
	'Pending comments' => 'Comentarios pendientes',
	'Published comments' => 'Comentarios publicados',
	'Comments on my entries' => 'Comentarios en mis entradas',
	'Comments in the last 7 days' => 'Comentarios en los últimos 7 días',
	'Spam Comments' => 'Comentarios spam',
	'Tags with entries' => 'Etiquetas con entradas',
	'Tags with pages' => 'Etiquetas con páginas',
	'Tags with assets' => 'Etiquetas con ficheros multimedia',
	'Enabled Users' => 'Usuarios habilitados',
	'Disabled Users' => 'Usuarios deshabilitados',
	'Pending Users' => 'Usuarios pendientes',
	'Design' => 'Diseño',
	'Tools' => 'Herramientas',
	'Manage' => 'Administrar',
	'New' => 'Nuevo',
	'Folders' => 'Carpetas',
	'Widgets' => 'Widgets',
	'General' => 'General',
	'Compose' => 'Componer',
	'Feedback' => 'Respuestas',
	'Registration' => 'Registro',
	'Web Services' => 'Servicios web',
	'Permissions' => 'Permisos',
	'Search &amp; Replace' => 'Buscar &amp; Reemplazar',
	'Plugins' => 'Extensiones',
	'Import Entries' => 'Importar entradas',
	'Export Entries' => 'Exportar entradas',
	'Export Theme' => 'Exportar tema',
	'Address Book' => 'Agenda',
	'Create New' => 'Crear nuevo',
	'Website' => 'Website',

## lib/MT/App/ActivityFeeds.pm
	'Error loading [_1]: [_2]' => 'Error cargando [_1]: [_2]',
	'An error occurred while generating the activity feed: [_1].' => 'Ocurrió un error mientras se generaba la fuente de actividad: [_1].',
	'[_1] Weblog TrackBacks' => 'TrackBacks del weblog [_1]',
	'All Weblog TrackBacks' => 'Todos los TrackBacks del weblog',
	'[_1] Weblog Comments' => 'Comentarios del weblog [_1]',
	'All Weblog Comments' => 'Todos los comentarios del weblog',
	'[_1] Weblog Entries' => 'Entradas del weblog [_1] ',
	'All Weblog Entries' => 'Todas las entradas del weblog',
	'[_1] Weblog Activity' => 'Actividad de weblogs [_1]',
	'All Weblog Activity' => 'Toda la actividad de weblogs',
	'Movable Type System Activity' => 'Actividad del sistema de Movable Type',
	'Movable Type Debug Activity' => 'Actividad de depuración de Movable Type',
	'[_1] Weblog Pages' => 'Páginas del weblog [_1]',
	'All Weblog Pages' => 'Todas las páginas del weblog',

## lib/MT/Worker/Publish.pm
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- conjunto completo ([quant,_1,fichero,ficheros] en [_2] segundos)',

## lib/MT/Worker/Sync.pm
	'Synchrnizing Files Done' => 'Sincronización de ficheros realizada',
	'Done syncing files to [_1] ([_2])' => 'Ficheros sincronizados en [_1] ([_2])',

## lib/MT/Revisable/Local.pm
	'string(255)' => 'cadena(255)',

## lib/MT/Role.pm
	'Role' => 'Rol',
	'Blog Administrator' => 'Administrador del blog',
	'Can administer the blog.' => 'Puede administrar el blog.',
	'Editor' => 'Editor',
	'Can upload files, edit all entries(categories), pages(folders), tags and publish the site.' => 'Puede subir ficheros, editar todas las entradas (categorías), páginas (carpetas), etiquetas y publicar el sitio.',
	'Can create entries, edit their own entries, upload files and publish.' => 'Puede crear entradas, editar sus propias entradas, subir ficheros y publicar.',
	'Can edit, manage, and publish blog templates and themes.' => 'Puede editar, administrar y publicar plantillas y temas de blogs.',
	'Can manage pages, upload files and publish blog templates.' => 'Puede administrar páginas, subir ficheros y publicar plantillas de blogs.',
	'Contributor' => 'Colaborador',
	'Can create entries, edit their own entries, and comment.' => 'Puede crear entradas, editar sus propias entradas y comentar.',
	'Moderator' => 'Moderador',
	'Can comment and manage feedback.' => 'Puede comentar y administrar las respuestas.',
	'Can comment.' => 'Puede comentar.',

## lib/MT/BasicAuthor.pm
	'authors' => 'autores',

## lib/MT/Placement.pm
	'Category Placement' => 'Gestión de Categorías',

## lib/MT/Permission.pm
	'Permission' => 'permiso',

## lib/MT/TaskMgr.pm
	'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'No fue posible asegurar el bloqueo para la ejecución de tareas del sistema. Asegúrese de que se puede escribir en el directorio TempDir ([_1]).',
	'Error during task \'[_1]\': [_2]' => 'Error durante la tarea \'[_1]\': [_2]',
	'Scheduled Tasks Update' => 'Actualización de tareas programadas',
	'The following tasks were run:' => 'Se ejecutaron las siguientes tareas:',

## lib/MT/Page.pm
	'Folder' => 'Carpeta',
	'Load of blog failed: [_1]' => 'Fallo en la carga del blog: [_1]',

## lib/MT/Bootstrap.pm
	'Got an error: [_1]' => 'Ocurrió un error en: [_1]',

## lib/MT/Scorable.pm
	'Object must be saved first.' => 'Primero debe guardarse el objeto.',
	'Already scored for this object.' => 'Ya puntuado en este objeto.',
	'Could not set score to the object \'[_1]\'(ID: [_2])' => 'No pudo darse puntuación al objeto \'[_1]\'(ID: [_2])',

## lib/MT/Category.pm
	'Categories must exist within the same blog' => 'Las categorías deben existir en el mismo blog',
	'Category loop detected' => 'Bucle de categorías detectado',
	'string(100) not null' => 'cadena(100) no vacía',

## lib/MT/Asset.pm
	'Could not remove asset file [_1] from filesystem: [_2]' => 'No se pudo eliminar el fichero multimedia [_1] del sistema de ficheros: [_2]',
	'Location' => 'Lugar',

## lib/MT/Image.pm
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'El módulo de Perl Image::Size es necesario para obtener las dimensiones de las imágenes transferidas.',
	'File size exceeds maximum allowed: [_1] > [_2]' => 'El tamaño del fichero excede el máximo permitido: [_1] > [_2]',
	'Can\'t load Image::Magick: [_1]' => 'No se pudo cargar Image::Magick: [_1]',
	'Reading file \'[_1]\' failed: [_2]' => 'Fallo leyendo archivo \'[_1]\': [_2]',
	'Reading image failed: [_1]' => 'Fallo leyendo imagen: [_1]',
	'Scaling to [_1]x[_2] failed: [_3]' => 'El escalado a [_1]x[_2] falló: [_3]',
	'Cropping a [_1]x[_1] square at [_2],[_3] failed: [_4]' => 'Fallo recortando un cuadrado [_1]x[_1] en [_2],[_3]: [_4]',
	'Converting image to [_1] failed: [_2]' => 'Fallo convirtiendo una imagen a [_1]: [_2]',
	'Can\'t load IPC::Run: [_1]' => 'No se pudo cargar IPC::Run: [_1]',
	'Unsupported image file type: [_1]' => 'Tipo de imagen no soportada: [_1]',
	'Cropping to [_1]x[_1] failed: [_2]' => 'Fallo recortando a [_1]x[_1]: [_2]',
	'Converting to [_1] failed: [_2]' => 'Fallo convirtiendo a [_1]: [_2]',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'No posee una ruta válida a las herramientas NetPBMYou en su máquina.',
	'Can\'t load GD: [_1]' => 'No se puede cargar GD: [_1]',

## lib/MT/XMLRPCServer.pm
	'Invalid timestamp format' => 'Formato de fecha no válido',
	'No web services password assigned.  Please see your user profile to set it.' => 'No se ha establecido la contraseña de servicios web.  Por favor, vaya al perfil de su usario para configurarla.',
	'Requested permalink \'[_1]\' is not available for this page' => 'El enlace permanente solicitado \'[_1]\' no está disponible para esta página',
	'Saving folder failed: [_1]' => 'Fallo al guardar la carpeta: [_1]',
	'No blog_id' => 'Sin blog_id',
	'Invalid blog ID \'[_1]\'' => 'Identificador de blog  \'[_1]\' no válido',
	'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => 'El valor de \'mt_[_1]\' debe ser 0 ó 1 (era \'[_2]\')',
	'PreSave failed [_1]' => 'Fallo en \'PreSave\' [_1]',
	'User \'[_1]\' (user #[_2]) added [lc,_4] #[_3]' => 'Usuario \'[_1]\' (usuario #[_2]) añadido [lc,_4] #[_3]',
	'Not privileged to edit entry' => 'No tiene permisos para editar la entrada',
	'User \'[_1]\' (user #[_2]) edited [lc,_4] #[_3]' => 'Usuario \'[_1]\' (usuario #[_2]) editado [lc,_4] #[_3]',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'Entrada \'[_1]\' ([lc,_5] #[_2]) borrada por \'[_3]\' (usuario #[_4]) para xml-rpc',
	'Not privileged to get entry' => 'No tiene permisos para obtener la entrada',
	'Not privileged to set entry categories' => 'No tiene permisos para establecer categorías en las entradas',
	'Not privileged to upload files' => 'No tiene privilegios para transferir ficheros',
	'No filename provided' => 'No se especificó el nombre del fichero ',
	'Error writing uploaded file: [_1]' => 'Error escribiendo el fichero transferido: [_1]',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Los métodos de las plantillas no están implementados, debido a las diferencias entre Blogger API y Movable Type API.',

## lib/MT/Session.pm
	'Session' => 'Sección',

## lib/MT/WeblogPublisher.pm
	'Archive type \'[_1]\' is not a chosen archive type' => 'El tipo de archivos \'[_1]\' no es un tipo de archivos seleccionado',
	'Parameter \'[_1]\' is required' => 'El parámetro \'[_1]\' es necesario',
	'You did not set your blog publishing path' => 'No configuró la ruta de publicación del blog',
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Ya existe el fichero del mismo archivo. Debe modificar el título o la ruta. ([_1])',
	'An error occurred publishing [_1] \'[_2]\': [_3]' => 'Un error se ha producido durante la publicación',
	'An error occurred publishing date-based archive \'[_1]\': [_2]' => 'Ocurrió un error publicando el archivo de fechas \'[_1]\': [_2]',
	'Renaming tempfile \'[_1]\' failed: [_2]' => 'Fallo renombrando el fichero temporal \'[_1]\': [_2]',
	'Blog, BlogID or Template param must be specified.' => 'Debe especificarse el parámetro Blog, BlogID o Template.',
	'Template \'[_1]\' does not have an Output File.' => 'La plantilla \'[_1]\' no tiene un fichero de salida.',
	'An error occurred while publishing scheduled entries: [_1]' => 'Ocurrió un error durante la publicación de las entradas programadas: [_1]',

## lib/MT/Trackback.pm
	'TrackBack' => 'TrackBack',

## lib/MT/Auth.pm
	'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Configuración incorrecta de AuthenticationModule \'[_1]\': [_2]',
	'Bad AuthenticationModule config' => 'Configuración incorrecta de AuthenticationModule',

## lib/MT/Notification.pm
	'Contact' => 'Contacto',
	'Contacts' => 'Contactos',

## lib/MT/Comment.pm
	'Comment' => 'Comentario',
	'Load of entry \'[_1]\' failed: [_2]' => 'Fallo al cargar la entrada \'[_1]\': [_2]',

## lib/MT/Component.pm
	'Loading template \'[_1]\' failed: [_2]' => 'Fallo cargando plantilla \'[_1]\': [_2]',

## lib/MT/Theme.pm
	'Failed to load theme [_1].' => 'Fallo al cargar tema [_1].',
	'A fatal error occurred while applying element [_1]: [_2].' => 'Error fatal al aplicar el elemento [_1]: [_2].',
	'An error occurred while applying element [_1]: [_2].' => 'Error fatal al aplicar el elemento [_1]: [_2].',
	'Component \'[_1]\' version [_2] or greater is needed to use this theme, but is not installed.' => 'Para usar este tema se necesita el componente \'[_1]\' versión [_2] o mayor, pero no está instalado.',
	'Component \'[_1]\' version [_2] or greater is needed to use this theme, but the installed version is [_3].' => 'Para usar este tema se necesita el componente \'[_1]\' versión [_2] o mayor, pero la versión instalada es [_3].',
	'Element \'[_1]\' cannot be applied because [_2]' => 'El elemento \'[_1]\' no se puede aplicar porque [_2]',
	'There was an error scaling image [_1].' => 'Hubo un error redimensionando la imagen [_1].',
	'There was an error converting image [_1].' => 'Hubo un error convirtiendo la imagen [_1].',
	'There was an error creating thumbnail file [_1].' => 'Hubo un error creando el fichero de la miniatura [_1].',
	'Default Prefs' => 'Preferencias por defecto',
	'Template Set' => 'Conjunto de plantillas',
	'Static Files' => 'Ficheros estáticos',
	'Default Pages' => 'Páginas predefinidas',

## lib/MT/Upgrade.pm
	'Invalid upgrade function: [_1].' => 'Función de actualización no válida: [_1].',
	'Error loading class [_1].' => 'Error cargando clase [_1].',
	'Upgrading table for [_1] records...' => 'Actualización de las tablas para los registros [_1]...',
	'Upgrading database from version [_1].' => 'Actualizando base de datos desde la versión [_1].',
	'Database has been upgraded to version [_1].' => 'Se actualizó la base de datos a la versión [_1].',
	'User \'[_1]\' upgraded database to version [_2]' => 'Usuario \'[_1]\' actualizó la base de datos a la versión [_2]',
	'Plugin \'[_1]\' upgraded successfully to version [_2] (schema version [_3]).' => 'Extensión \'[_1]\' actualizada con éxito a la versión [_2] (versión del esquema [_3]).',
	'User \'[_1]\' upgraded plugin \'[_2]\' to version [_3] (schema version [_4]).' => 'Usuario \'[_1]\' actualizó la extensión \'[_2]\' a la versión [_3] (versión del esquema [_4]).',
	'Plugin \'[_1]\' installed successfully.' => 'La extensión \'[_1]\' se actualizó correctamente.',
	'User \'[_1]\' installed plugin \'[_2]\', version [_3] (schema version [_4]).' => 'Usuario \'[_1]\' instaló la extensión \'[_2]\', versión [_3] (versión del esquema [_4]).',
	'Error saving [_1] record # [_3]: [_2]...' => 'Error guardando registro [_1] # [_3]: [_2]...',

## lib/MT/Core.pm
	'Error creating performance logs directory, [_1]. Please either change the permissions to make it writable or specify an alternate using the PerformanceLoggingPath configuration directive: [_2]' => 'Error al crear el directorio de registros de rendimiento, [_1]. Por favor, cambie los permisos de escritura del directorio o especifique una ruta alternativa utilizando la directiva PerformanceLoggingPath en la configuración: [_2]',
	'Error creating performance logs: PerformanceLoggingPath setting must be a directory path, not a file: [_1]' => 'Error creando los registros de rendimiento: la directiva PerformanceLoggingPath debe ser un directorio, no un fichero: [_1]',
	'Error creating performance logs: PerformanceLoggingPath directory exists but is not writeable: [_1]' => 'Error creando los registros de rendimiento: el directorio PerformanceLoggingPath existe, pero no se puede escribir en él: [_1]',
	'MySQL Database (Recommended)' => 'Base de datos MySQL (recomendada)', # Translate - New
	'PostgreSQL Database' => 'Base de datos PostgreSQL',
	'SQLite Database' => 'Base de datos SQLite',
	'SQLite Database (v2)' => 'Base de datos SQLite (v2)',
	'Convert Line Breaks' => 'Convertir saltos de línea',
	'Rich Text' => 'Texto con formato',
	'Movable Type Default' => 'Predefinido de Movable Type',
	'weblogs.com' => 'weblogs.com',
	'technorati.com' => 'technorati.com',
	'google.com' => 'google.com',
	'Classic Blog' => 'Blog clásico',
	'Publishes content.' => 'Publica los contenidos.',
	'Synchronizes content to other server(s).' => 'Sincroniza el contenido con otros servidores.',
	'Refreshes object summaries.' => 'Refrescar resúmen de los objetos',
	'Adds Summarize workers to queue.' => 'Añade trabajadores de totales a la cola.',
	'zip' => 'zip',
	'tar.gz' => 'tar.gz',
	'Entries List' => 'Lista de entradas',
	'Blog URL' => 'URL del blog',
	'Blog ID' => 'ID del blog',
	'Entry Excerpt' => 'Resumen de la entrada',
	'Entry Link' => 'Enlace de la entrada',
	'Entry Extended Text' => 'Texto extendido de la entrada',
	'Entry Title' => 'Título de la entrada',
	'If Block' => 'Bloque If',
	'If/Else Block' => 'Bloque If/Else',
	'Include Template Module' => 'Módulo de inclusión de plantillas',
	'Include Template File' => 'Fichero de inclusión de plantillas',
	'Get Variable' => 'Obtener variable',
	'Set Variable' => 'Ajustar variable',
	'Set Variable Block' => 'Bloque de ajuste de variable',
	'Widget Set' => 'Conjunto de widgets',
	'Publish Scheduled Entries' => 'Publicar las Notas Planificadas',
	'Add Summary Watcher to queue' => 'Añade un inspector de totales a la cola',
	'Junk Folder Expiration' => 'Caducidad de la carpeta basura',
	'Remove Temporary Files' => 'Borrar ficheros temporales',
	'Purge Stale Session Records' => 'Eliminar registros de sesión caducados',
	'Manage Website' => 'Administrar sitio web',
	'Manage Blog' => 'Administrar blog',
	'Manage Website with Blogs' => 'Administrar sitio web con blogs',
	'Post Comments' => 'Comentarios',
	'Create Entries' => 'Crear entradas',
	'Edit All Entries' => 'Editar todas las entradas',
	'Manage Assets' => 'Administrar multimedia',
	'Manage Categories' => 'Administrar categorías',
	'Change Settings' => 'Modificar configuración',
	'Manage Address Book' => 'Administración del libro de Direcciones',
	'Manage Tags' => 'Administrar etiquetas',
	'Manage Templates' => 'Administrar plantillas',
	'Manage Feedback' => 'Administrar respuestas',
	'Manage Pages' => 'Administrar páginas',
	'Manage Users' => 'Administrar usuarios',
	'Manage Themes' => 'Administrar temas',
	'Publish Entries' => 'Publicar entradas',
	'Save Image Defaults' => 'Guardar opciones de imagen',
	'Send Notifications' => 'Enviar notificaciones',
	'Set Publishing Paths' => 'Configurar rutas de publicación',
	'View Activity Log' => 'Ver registro de actividad',
	'Create Blogs' => 'Crear blogs',
	'Create Websites' => 'Crear sitios web',
	'Manage Plugins' => 'Administrar extensiones',
	'View System Activity Log' => 'Ver registro de actividad del sistema',

## lib/MT/DefaultTemplates.pm
	'Archive Index' => 'Índice de archivos',
	'Stylesheet' => 'Hoja de estilo',
	'JavaScript' => 'JavaScript',
	'Feed - Recent Entries' => 'Sindicación - Entradas recientes',
	'RSD' => 'RSD',
	'Monthly Entry Listing' => 'Lista mensual de entradas',
	'Category Entry Listing' => 'Lista de entradas por categorías',
	'Comment Listing' => 'Lista de comentarios',
	'Improved listing of comments.' => 'Lista de comentarios mejorada.',
	'Displays error, pending or confirmation message for comments.' => 'Muestra mensajes de error o mensajes de pendiente y confirmación en los comentarios.',
	'Comment Preview' => 'Vista previa de comentario',
	'Displays preview of comment.' => 'Muestra una previsualización del comentario.',
	'Dynamic Error' => 'Error dinámico',
	'Displays errors for dynamically published templates.' => 'Muestra errores de las plantillas publicadas dinámicamente.',
	'Popup Image' => 'Imagen emergente',
	'Displays image when user clicks a popup-linked image.' => 'Muestra una imagen cuando el usuario hace clic en una imagen con enlace a una ventana emergente.',
	'Displays results of a search.' => 'Muestra los resultados de una búsqueda.',
	'About This Page' => 'Página Sobre mi',
	'Archive Widgets Group' => 'Grupo de widgets de archivos',
	'Current Author Monthly Archives' => 'Archivos mensuales del autor actual',
	'Calendar' => 'Calendario',
	'Creative Commons' => 'Creative Commons',
	'Home Page Widgets Group' => 'Grupo de widgets de la página de inicio',
	'Monthly Archives Dropdown' => 'Desplegable de archivos mensuales',
	'Page Listing' => 'Lista de páginas',
	'Powered By' => 'Powered By',
	'Syndication' => 'Sindicación',
	'Technorati Search' => 'Búsquedas en Technorati',
	'Date-Based Author Archives' => 'Archivos de autores por fecha',
	'Date-Based Category Archives' => 'Archivos de categorías por fecha',
	'OpenID Accepted' => 'OpenID aceptado',
	'Mail Footer' => 'Pie del correo',
	'Comment throttle' => 'Aluvión de comentarios',
	'Commenter Confirm' => 'Confirmación de comentarista',
	'Commenter Notify' => 'Notificación de comentaristas',
	'New Comment' => 'Nuevo comentario',
	'New Ping' => 'Nuevo ping',
	'Entry Notify' => 'Notificación de entradas',
	'Subscribe Verify' => 'Verificación de suscripciones',

## lib/MT/ObjectTag.pm
	'Tag Placement' => 'Gestión de Etiqueta',
	'Tag Placements' => 'Gestión de las Etiquetas',

## lib/MT/Author.pm
	'The approval could not be committed: [_1]' => 'La aprobación no pudo realizarse: [_1]',

## lib/MT/XMLRPC.pm
	'No WeblogsPingURL defined in the configuration file' => 'WeblogsPingURL no está definido en el fichero de configuración',
	'No MTPingURL defined in the configuration file' => 'MTPingURL no está definido en el fichero de configuración',
	'HTTP error: [_1]' => 'Error HTTP: [_1]',
	'Ping error: [_1]' => 'Error de ping: [_1]',

## lib/MT/ObjectAsset.pm
	'Asset Placement' => 'Posición del elemento multimedia',

## lib/MT/BackupRestore.pm
	'Backing up [_1] records:' => 'Haciendo la copia de seguridad de [_1] registros:',
	'[_1] records backed up...' => '[_1] registros guardados...',
	'[_1] records backed up.' => '[_1] registros guardados..',
	'There were no [_1] records to be backed up.' => 'No habían [_1] registros de los que hacer copia de seguridad.',
	'Can\'t open directory \'[_1]\': [_2]' => 'No se puede abrir el directorio \'[_1]\': [_2]',
	'No manifest file could be found in your import directory [_1].' => 'No se encontró fichero de manifiesto en el directorio de importación [_1].',
	'Can\'t open [_1].' => 'No se pudo abrir [_1].',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'El fichero [_1] no es un fichero válido de manifiesto para copias de seguridad de Movable Type.',
	'Manifest file: [_1]' => 'Fichero de manifiesto: [_1]',
	'Path was not found for the file ([_1]).' => 'No se encontró la ruta del archivo ([_1]).',
	'[_1] is not writable.' => 'No puede escribirse en [_1].',
	'Copying [_1] to [_2]...' => 'Copiando [_1] a [_2]...',
	'Failed: ' => 'Falló: ',
	'Restoring asset associations ... ( [_1] )' => 'Restaurando asociaciones de ficheros multimedia ... ( [_1] )',
	'Restoring asset associations in entry ... ( [_1] )' => 'Restaurando asociaciones de ficheros multimedia en la entrada ... ( [_1] )',
	'Restoring asset associations in page ... ( [_1] )' => 'Restaurando asociaciones de ficheros multimedia en página ... ( [_1] )',
	'Restoring url of the assets ( [_1] )...' => 'Restaurando url de ficheros multimedia ( [_1] )...',
	'Restoring url of the assets in entry ( [_1] )...' => 'Restaurando url de ficheros multimedia en la entrada ( [_1] )...',
	'Restoring url of the assets in page ( [_1] )...' => 'Restaurando url de ficheros multimedia en la página ( [_1] )...',
	'ID for the file was not set.' => 'El ID del fichero no está establecido.',
	'The file ([_1]) was not restored.' => 'No se restauró el fichero ([_1]).',
	'Changing path for the file \'[_1]\' (ID:[_2])...' => 'Cambiando la ruta del fichero \'[_1]\' (ID:[_2])...',

## lib/MT/TemplateMap.pm
	'Archive Mapping' => 'Mapeado de archivos',
	'Archive Mappings' => 'Mapeados de archivos',

## lib/MT/ConfigMgr.pm
	'Alias for [_1] is looping in the configuration.' => 'Alias de [_1] está generando un bucle en la configuración.',
	'Error opening file \'[_1]\': [_2]' => 'Error abriendo el fichero \'[_1]\': [_2]',
	'Config directive [_1] without value at [_2] line [_3]' => 'Directiva de configuración [_1] sin valor en [_2] línea [_3]',
	'No such config variable \'[_1]\'' => 'No existe tal variable de configuración \'[_1]\'',

## lib/MT/Association.pm
	'Association' => 'Asociación',
	'association' => 'Asociación',
	'associations' => 'Asociaciones',

## lib/MT/TBPing.pm

## lib/MT/Builder.pm
	'<[_1]> at line [_2] is unrecognized.' => 'No se reconoció a <[_1]> en la línea [_2].',
	'<[_1]> with no </[_1]> on line #' => '<[_1]> sin </[_1]> en la línea #',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]> sin </[_1]> en la línea [_2].',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]> sin </[_1]> en la línea [_2]',
	'Error in <mt[_1]> tag: [_2]' => 'Error en la etiqueta <mt[_1]>: [_2]',
	'Unknown tag found: [_1]' => 'Se encontró una etiqueta desconocida: [_1]',

## lib/MT/ObjectScore.pm
	'Object Score' => 'Score del Objeto',
	'Object Scores' => 'Scores de los Objetos',

## lib/MT/Website.pm

## lib/MT/Import.pm
	'Can\'t rewind' => 'No se pudo reiniciar',
	'No readable files could be found in your import directory [_1].' => 'No se encontrón ningún fichero legible en su directorio de importación [_1].',
	'Importing entries from file \'[_1]\'' => 'Importando entradas desde el fichero \'[_1]\'',
	'Couldn\'t resolve import format [_1]' => 'No se pudo resolver el formato de importación [_1]',
	'Movable Type' => 'Movable Type',
	'Another system (Movable Type format)' => 'Otro sistema (formato Movable Type)',

## lib/MT/Folder.pm

## lib/MT/Tag.pm
	'Tag must have a valid name' => 'La etiqueta debe tener un nombre válido',
	'This tag is referenced by others.' => 'Esta etiqueta está referenciada por otros.',

## lib/MT/App.pm
	'Invalid request: corrupt character data for character set [_1]' => 'Petición inválida: caracteres corruptos para el conjunto de caracteres [_1]',
	'Error loading website #[_1] for user provisioning. Check your NewUserefaultWebsiteId setting.' => 'Error cargando el sitio web #[_1] para la provisión de usuarios. Compruebe la directiva NewUserefaultWebsiteId.',
	'First Weblog' => 'Primer weblog',
	'Error loading blog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => 'Error de telécargamiento #[_1] que comprende la creación de Usuarios. Por favor, verifique sus parámetros NewUserTemplateBlogId.',
	'Error provisioning blog for new user \'[_1]\' using template blog #[_2].' => 'Se ha producido un error durante la creación del blog del nuevo usuario \'[_1]\' utilizando la plantilla #[_2].',
	'Error creating directory [_1] for blog #[_2].' => 'Error creando el directorio [_1] para el blog #[_2].',
	'Error provisioning blog for new user \'[_1] (ID: [_2])\'.' => 'Se ha producido un error durante la creación del blog del nuevo usuario \'[_1] (ID: [_2])\'.',
	'Blog \'[_1] (ID: [_2])\' for user \'[_3] (ID: [_4])\' has been created.' => 'Blog \'[_1] (ID: [_2])\' para el usuario \'[_3] (ID: [_4])\' ha sido creado.',
	'Error assigning blog administration rights to user \'[_1] (ID: [_2])\' for blog \'[_3] (ID: [_4])\'. No suitable blog administrator role was found.' => 'Error de asignación de los derechos para el usuario \'[_1] (ID: [_2])\' para el blog \'[_3] (ID: [_4])\'. Ningún rol de administrador adecuado ha sido encontrado.',
	'Internal Error: Login user is not initialized.' => 'Error interno: Inicio de sesión de usuarios no inicializada.',
	'The login could not be confirmed because of a database error ([_1])' => 'No se pudo confirmar el acceso debido a un error de la base de datos ([_1])',
	'Our apologies, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Lo sentimos, pero no tiene permisos para acceder a ningún blog o sitio web en esta instalación. Si cree que este mensaje se le muestra por error, por favor, contacte con el administrador de la instalación de Movable Type.',
	'This account has been disabled. Please see your system administrator for access.' => 'Esta cuenta fue deshabilitada. Por favor, póngase en contacto con el administrador del sistema.',
	'Failed login attempt by pending user \'[_1]\'' => 'Intento fallido de inicio de sesión de un usuario pendiente \'[_1]\'',
	'This account has been deleted. Please see your system administrator for access.' => 'Esta cuenta fue eliminada. Por favor, póngase en contacto con el administrador del sistema.',
	'User cannot be created: [_1].' => 'No se pudo crear al usuario: [_1].',
	'User \'[_1]\' has been created.' => 'El usuario \'[_1]\' ha sido creado',
	'User \'[_1]\' (ID:[_2]) logged in successfully' => 'Usuario \'[_1]\' (ID:[_2]) inició una sesión correctamente',
	'Invalid login attempt from user \'[_1]\'' => 'Intento de acceso no válido del usuario \'[_1]\'',
	'User \'[_1]\' (ID:[_2]) logged out' => 'Usuario \'[_1]\' (ID:[_2]) se desconectó',
	'User requires password.' => 'El usuario necesita una contraseña.',
	'User requires display name.' => 'El usuario necesita un pseudónimo.',
	'User requires username.' => 'El usuario necesita un nombre.',
	'Something wrong happened when trying to process signup: [_1]' => 'Algo mal ocurrió durante el proceso de alta: [_1]',
	'New Comment Added to \'[_1]\'' => 'Nuevo comentario añadido en \'[_1]\'',
	'The file you uploaded is too large.' => 'El fichero que transfirió es demasiado grande.',
	'Unknown action [_1]' => 'Acción desconocida [_1]',
	'Warnings and Log Messages' => 'Mensajes de alerta y registro',
	'Removed [_1].' => 'Se eliminó [_1].',

## lib/MT/Log.pm
	'Log message' => 'Mensaje del registro',
	'Log messages' => 'Mensajes del registro',
	'Page # [_1] not found.' => 'Página nº [_1] no encontrada.',
	'Entry # [_1] not found.' => 'Entrada nº [_1] no encontrada.',
	'Comment # [_1] not found.' => 'Comentario nº [_1] no encontrado.',
	'TrackBack # [_1] not found.' => 'TrackBack nº [_1] no encontrado.',

## lib/MT/IPBanList.pm
	'IP Ban' => 'Bloqueo de IP',
	'IP Bans' => 'Bloqueos de IP',

## lib/MT/AtomServer.pm
	'[_1]: Entries' => '[_1]: Entradas',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from atom api' => 'Entrada \'[_1]\' ([lc,_5] #[_2]) borrada por \'[_3]\' (usuario #[_4]) desde atom api',

## lib/MT/PluginData.pm
	'Plugin Data' => 'Datos de la extensión',

## lib/MT/Plugin.pm
	'Publish' => 'Publicar',
	'My Text Format' => 'Mi formato de texto',

## lib/MT/Entry.pm
	'record does not exist.' => 'registro no existe.',
	'Draft' => 'Borrador',
	'Review' => 'Revisar',
	'Future' => 'Futuro',
	'Spam' => 'Spam',
	'Status' => 'Estado',
	'Accept Comments' => 'Aceptar comentarios',
	'Body' => 'Cuerpo',
	'Extended' => 'Extendido',
	'Format' => 'Formato',
	'Accept Trackbacks' => 'Aceptar TrackBacks',
	'Publish Date' => 'Fecha de publicación',

## lib/MT/Config.pm
	'Configuration' => 'Configuración',

## lib/MT/Template.pm
	'Template' => 'plantilla',
	'Error reading file \'[_1]\': [_2]' => 'Error leyendo fichero \'[_1]\': [_2]',
	'Publish error in template \'[_1]\': [_2]' => 'Error de publicación en la plantilla \'[_1]\': [_2]',
	'Template with the same name already exists in this blog.' => 'Ya existe una plantilla con el mismo nombre en este blog.',
	'You cannot use a [_1] extension for a linked file.' => 'No puede usar una extensión [_1] para un fichero enlazado.',
	'Opening linked file \'[_1]\' failed: [_2]' => 'Fallo abriendo fichero enlazado\'[_1]\': [_2]',
	'Index' => 'Índice',
	'Category Archive' => 'Archivo de categorías',
	'Ping Listing' => 'Lista de pings',
	'Comment Error' => 'Error de comentarios',
	'Uploaded Image' => 'Imagen transferida',
	'Module' => 'Módulo',
	'Widget' => 'Widget',
	'Output File' => 'Fichero de salida',
	'Template Text' => 'Texto de la plantilla',
	'Rebuild with Indexes' => 'Reconstruir con índices',
	'Dynamicity' => 'Dinamicidad',
	'Build Type' => 'Tipo de reconstrucción',
	'Interval' => 'Intervalo',

## lib/MT/ImportExport.pm
	'No Blog' => 'Sin Blog',
	'Need either ImportAs or ParentAuthor' => 'Necesita ImportAs o ParentAuthor',
	'Creating new user (\'[_1]\')...' => 'Creando usario (\'[_1]\')...',
	'Saving user failed: [_1]' => 'Fallo guardando usario: [_1]',
	'Assigning permissions for new user...' => 'Asignar permisos al nuevo usario...',
	'Saving permission failed: [_1]' => 'Fallo guardando permisos: [_1]',
	'Creating new category (\'[_1]\')...' => 'Creando nueva categoría (\'[_1]\')...',
	'Saving category failed: [_1]' => 'Fallo guardando categoría: [_1]',
	'Invalid status value \'[_1]\'' => 'Valor de estado no válido \'[_1]\'',
	'Invalid allow pings value \'[_1]\'' => 'Valor no válido de permiso de pings \'[_1]\'',
	'Can\'t find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.' => 'No se encontró una entrada existente con la fecha \'[_1]\'... ignorando comentarios, y pasando a la siguiente entrada.',
	'Importing into existing entry [_1] (\'[_2]\')' => 'Importando en entrada existente [_1] (\'[_2]\')',
	'Saving entry (\'[_1]\')...' => 'Guardando entrada (\'[_1]\')...',
	'ok (ID [_1])' => 'ok (ID [_1])',
	'Saving entry failed: [_1]' => 'Fallo guardando entrada: [_1]',
	'Creating new comment (from \'[_1]\')...' => 'Creando nuevo comentario (de \'[_1]\')...',
	'Saving comment failed: [_1]' => 'Fallo guardando comentario: [_1]',
	'Entry has no MT::Trackback object!' => '¡La entrada no tiene objeto MT::Trackback!',
	'Creating new ping (\'[_1]\')...' => 'Creando nuevo ping (\'[_1]\')...',
	'Saving ping failed: [_1]' => 'Fallo guardando ping: [_1]',
	'Export failed on entry \'[_1]\': [_2]' => 'Fallo de exportación en la entrada \'[_1]\': [_2]',
	'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Formato de fecha \'[_1]\' no válido; debe ser \'MM/DD/AAAA HH:MM:SS AM|PM\' (AM|PM es opcional)',

## lib/MT/Revisable.pm
	'Bad RevisioningDriver config \'[_1]\': [_2]' => 'Configuración de RevisioningDriver errónea \'[_1]\': [_2]',
	'Revision not found: [_1]' => 'Revisión no encontrada: [_1]',
	'There aren\'t the same types of objects, expecting two [_1]' => 'No son el mismo tipo de objetos, se esperaban dos [_1]',
	'Did not get two [_1]' => 'No se obtuvieron dos [_1]',
	'Unknown method [_1]' => 'Método desconocido [_1]',
	'Revision Number' => 'Revisión número',

## lib/MT/JunkFilter.pm
	'Action: Junked (score below threshold)' => 'Acción: Basura (puntuación bajo nivel)',
	'Action: Published (default action)' => 'Acción: Publicado (acción predefinida)',
	'Junk Filter [_1] died with: [_2]' => 'Filtro basura [_1] murió con: [_2]',
	'Unnamed Junk Filter' => 'Filtro basura sin nombre',
	'Composite score: [_1]' => 'Puntuación compuesta: [_1]',

## lib/MT/Util.pm
	'moments from now' => 'dentro de unos momentos',
	'[quant,_1,hour,hours] from now' => 'dentro de [quant,_1,hora,horas]',
	'[quant,_1,minute,minutes] from now' => 'dentro de [quant,_1,minuto,minutos]',
	'[quant,_1,day,days] from now' => 'dentro de [quant,_1,día,días]',
	'less than 1 minute from now' => 'dentro de menos de un minuto',
	'less than 1 minute ago' => 'hace menos de un minuto',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => 'dentro de [quant,_1,hora,horas], [quant,_2,minuto,minutos]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => 'hace [quant,_1,hora,horas], [quant,_2,minuto,minutos]',
	'[quant,_1,day,days], [quant,_2,hour,hours] from now' => 'dentro de [quant,_1,día,días], [quant,_2,hora,horas]',
	'[quant,_1,day,days], [quant,_2,hour,hours] ago' => 'hace [quant,_1,día,días], [quant,_2,hora,horas]',
	'[quant,_1,second,seconds] from now' => 'dentro de [quant,_1,segundo,segundos]',
	'[quant,_1,second,seconds]' => '[quant,_1,segundo,segundos]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => 'dentro de [quant,_1,minuto,minutos], [quant,_2,segundo,segundos]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,minuto,minutos], [quant,_2,segundo,segundos]',
	'[quant,_1,minute,minutes]' => '[quant,_1,minuto,minutos]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,hora,horas], [quant,_2,minuto,minutos]',
	'[quant,_1,hour,hours]' => '[quant,_1,hora,horas]',
	'[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,día,días], [quant,_2,hora,horas]',
	'[quant,_1,day,days]' => '[quant,_1,día,días]',
	'Invalid domain: \'[_1]\'' => 'Dominio no válido: \'[_1]\'',

## lib/MT/Mail.pm
	'Unknown MailTransfer method \'[_1]\'' => 'MailTransfer método desconocido \'[_1]\'',
	'Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]' => 'El envío de mensajes a través de SMTP necesita que su servidor tenga Mail::Sendmail instalado: [_1]',
	'Error sending mail: [_1]' => 'Error enviado correo: [_1]',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'No tiene configurada una ruta válida a sendmail en su máquina. ¿Quizás está intentando usar SMTP?',
	'Exec of sendmail failed: [_1]' => 'Fallo la ejecución de sendmail: [_1]',

## lib/MT/Blog.pm
	'First Blog' => 'Primer blog',
	'No default templates were found.' => 'No se encontraron plantillas predefinidas.',
	'Cloned blog... new id is [_1].' => 'Blog clonado... el nuevo identificador es [_1]',
	'Cloning permissions for blog:' => 'Clonando permisos para el blog:',
	'[_1] records processed...' => 'Procesados [_1] registros...',
	'[_1] records processed.' => 'Procesados [_1] registros.',
	'Cloning associations for blog:' => 'Clonando asociaciones para el blog:',
	'Cloning entries and pages for blog...' => 'Clonando entradas y páginas para el blog...',
	'Cloning categories for blog...' => 'Clonando categorías para el blog...',
	'Cloning entry placements for blog...' => 'Clonando situación de entradas para el blog...',
	'Cloning comments for blog...' => 'Clonando comentarios para el blog...',
	'Cloning entry tags for blog...' => 'Clonando etiquetas de entradas para el blog...',
	'Cloning TrackBacks for blog...' => 'Clonando TrackBacks para el blog...',
	'Cloning TrackBack pings for blog...' => 'Clonando pings de TrackBack para el blog...',
	'Cloning templates for blog...' => 'Clonando plantillas para el blog...',
	'Cloning template maps for blog...' => 'Clonando mapas de plantillas para el blog...',
	'blog' => 'Blog',
	'blogs' => 'blogs',
	'Failed to load theme [_1]: [_2]' => 'Fallo al cargar tema [_1]: [_2]',
	'Failed to apply theme [_1]: [_2]' => 'Fallo al aplicar tema [_1]: [_2]',

## lib/MT.pm
	'Powered by [_1]' => 'Powered by [_1]',
	'Version [_1]' => 'Versión [_1]',
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype/',
	'Hello, world' => 'Hola, mundo',
	'Hello, [_1]' => 'Hola, [_1]',
	'Message: [_1]' => 'Mensaje: [_1]',
	'If present, 3rd argument to add_callback must be an object of type MT::Component or MT::Plugin' => 'Si está presente, el tercer argumento de add_callback debe ser un objeto de tipo MT::Component o MT::Plugin',
	'4th argument to add_callback must be a CODE reference.' => 'El cuarto argumento de add_callback debe ser una referencia de código.',
	'Two plugins are in conflict' => 'Dos extensiones están en conflicto',
	'Invalid priority level [_1] at add_callback' => 'Nivel de prioridad [_1] no válido en add_callback',
	'Unnamed plugin' => 'Extensión sin nombre',
	'[_1] died with: [_2]' => '[_1] murió: [_2]',
	'Bad ObjectDriver config' => 'Configuración de ObjectDriver incorrecta',
	'Bad CGIPath config' => 'Configuración CGIPath incorrecta',
	'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Archivo de configuración no encontrado. ¿Quizás olvidó renombrar mt-config.cgi-original a mt-config.cgi?',
	'Plugin error: [_1] [_2]' => 'Error en la extensión: [_1] [_2]',
	'Loading template \'[_1]\' failed.' => 'Fallo cargando la plantilla \'[_1]\'.',
	'http://www.movabletype.org/documentation/' => 'http://www.movabletype.org/documentation/',
	'OpenID' => 'OpenID',
	'LiveJournal' => 'LiveJournal',
	'Vox' => 'Vox',
	'Google' => 'Google',
	'Yahoo!' => 'Yahoo!',
	'AIM' => 'AIM',
	'WordPress.com' => 'WordPress.com',
	'TypePad' => 'TypePad',
	'Yahoo! JAPAN' => 'Yahoo! JAPAN',
	'livedoor' => 'livedoor',
	'Hatena' => 'Hatena',
	'Movable Type default' => 'Predefinido de Movable Type',

## mt-static/jquery/jquery.mt.js

## mt-static/js/tc/mixer/display.js
	'Title:' => 'Título:', # Translate - New
	'Description:' => 'Descriptión:', # Translate - New
	'Author:' => 'Authr:', # Translate - New
	'Tags:' => 'Etiquetas:',
	'URL:' => 'URL:', # Translate - New

## mt-static/js/dialog.js
	'(None)' => '(Ninguno)',

## mt-static/js/assetdetail.js
	'No Preview Available' => 'Sin vista previa disponible',
	'View uploaded file' => 'Mostrar fichero transferido',

## mt-static/mt.js
	'delete' => 'borrar',
	'remove' => 'borrar',
	'enable' => 'habilitar',
	'disable' => 'deshabilitar',
	'You did not select any [_1] to [_2].' => 'No seleccionó ninguna [_1] sobre la que [_2].',
	'Are you sure you want to [_2] this [_1]?' => '¿Está seguro de que desea [_2] esta [_1]?',
	'Are you sure you want to [_3] the [_1] selected [_2]?' => '¿Está seguro de que desea [_3] el/los [_1] seleccionado/s [_2]?',
	'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => '¿Está seguro de que desea borrar este rol? Al hacerlo, eliminará los permisos actualmente asignados a cualquier usuario o grupo relacionados con este rol.',
	'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => '¿Está seguro de que desea borrar estos [_1] roles? Al hacerlo, eliminará los permisos actualmente asignados a cualquier usuario o grupo relacionados con estos roles.',
	'You did not select any [_1] [_2].' => 'No seleccionó ninguna [_1] [_2].',
	'You can only act upon a minimum of [_1] [_2].' => 'Solo puede actuar sobre un mínimo de [_1] [_2].',
	'You can only act upon a maximum of [_1] [_2].' => 'Solo puede actuar sobre un máximo de [_1] [_2].',
	'You must select an action.' => 'Debe seleccionar una acción.',
	'to mark as spam' => 'para marcar como spam',
	'to remove spam status' => 'para desmarcar como spam',
	'Enter email address:' => 'Teclee la dirección de correo-e:',
	'Enter URL:' => 'Teclee la URL:',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\'?' => 'La etiqueta \'[_2]\' ya existe. ¿Está seguro de que desea integrar \'[_1]\' y \'[_2]\'?',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all weblogs?' => 'La etiqueta \'[_2]\' ya existe. ¿Está seguro de que desea integrar \'[_1]\' y \'[_2]\' en todos los weblogs?',
	'Loading...' => 'Cargando...',
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] of [_3]',
	'[_1] &ndash; [_2]' => '[_1] &ndash; [_2]',

## themes/classic_website/templates/notify-entry.mtml

## themes/classic_website/templates/main_index.mtml

## themes/classic_website/templates/page.mtml

## themes/classic_website/templates/main_index_widgets_group.mtml

## themes/classic_website/templates/entry_summary.mtml

## themes/classic_website/templates/comment_response.mtml

## themes/classic_website/templates/commenter_notify.mtml

## themes/classic_website/templates/footer-email.mtml

## themes/classic_website/templates/verify-subscribe.mtml

## themes/classic_website/templates/new-ping.mtml

## themes/classic_website/templates/comment_detail.mtml

## themes/classic_website/templates/syndication.mtml
	'Subscribe to this website\'s feed' => 'Suscribirse a la sindicación de este sitio web',

## themes/classic_website/templates/recent_comments.mtml

## themes/classic_website/templates/technorati_search.mtml

## themes/classic_website/templates/comment_throttle.mtml

## themes/classic_website/templates/signin.mtml

## themes/classic_website/templates/new-comment.mtml

## themes/classic_website/templates/pages_list.mtml

## themes/classic_website/templates/about_this_page.mtml

## themes/classic_website/templates/entry.mtml

## themes/classic_website/templates/recover-password.mtml

## themes/classic_website/templates/javascript.mtml

## themes/classic_website/templates/trackbacks.mtml

## themes/classic_website/templates/recent_entries.mtml

## themes/classic_website/templates/sidebar.mtml

## themes/classic_website/templates/openid.mtml

## themes/classic_website/templates/banner_footer.mtml

## themes/classic_website/templates/comments.mtml

## themes/classic_website/templates/search_results.mtml

## themes/classic_website/templates/comment_listing.mtml

## themes/classic_website/templates/creative_commons.mtml

## themes/classic_website/templates/dynamic_error.mtml

## themes/classic_website/templates/powered_by.mtml

## themes/classic_website/templates/tag_cloud.mtml

## themes/classic_website/templates/recent_assets.mtml

## themes/classic_website/templates/comment_preview.mtml

## themes/classic_website/templates/search.mtml

## themes/classic_website/templates/blogs.mtml

## themes/classic_website/templates/commenter_confirm.mtml

## themes/classic_website/theme.yaml
	'Create a blog portal that aggregates contents from blogs under the website.' => 'Crear un portal blog que agregue los contenidos de los blogs publicados en este sitio web.',
	'Classic Website' => 'Sitio web clásico',
	'Feed - Recent Entries\'' => 'Sindicación - Entradas recientes',
	'Displays error, pending or confirmation message for comments.\'' => 'Muestra los mensajes de error, de confirmación o pendientes de los comentarios.',
	'2-column layout - Sidebar\'' => 'Distribución de 2 columnas - Barra lateral',
	'3-column layout - Primary Sidebar\'' => 'Distribución de 3 columnas - Barra lateral primaria',
	'3-column layout - Secondary Sidebar\'' => 'Distribución de 3 columnas - Barra lateral secundaria',

## themes/classic_blog/templates/tag_cloud.mtml

## themes/classic_blog/templates/monthly_archive_dropdown.mtml

## themes/classic_blog/templates/notify-entry.mtml

## themes/classic_blog/templates/recent_assets.mtml

## themes/classic_blog/templates/category_archive_list.mtml

## themes/classic_blog/templates/current_author_monthly_archive_list.mtml

## themes/classic_blog/templates/main_index.mtml

## themes/classic_blog/templates/page.mtml

## themes/classic_blog/templates/comment_preview.mtml

## themes/classic_blog/templates/main_index_widgets_group.mtml

## themes/classic_blog/templates/entry_summary.mtml

## themes/classic_blog/templates/comment_response.mtml

## themes/classic_blog/templates/commenter_notify.mtml

## themes/classic_blog/templates/footer-email.mtml

## themes/classic_blog/templates/archive_widgets_group.mtml

## themes/classic_blog/templates/verify-subscribe.mtml

## themes/classic_blog/templates/new-ping.mtml

## themes/classic_blog/templates/syndication.mtml

## themes/classic_blog/templates/comment_detail.mtml

## themes/classic_blog/templates/author_archive_list.mtml

## themes/classic_blog/templates/current_category_monthly_archive_list.mtml

## themes/classic_blog/templates/recent_comments.mtml

## themes/classic_blog/templates/technorati_search.mtml

## themes/classic_blog/templates/monthly_archive_list.mtml

## themes/classic_blog/templates/category_entry_listing.mtml

## themes/classic_blog/templates/comment_throttle.mtml

## themes/classic_blog/templates/signin.mtml

## themes/classic_blog/templates/new-comment.mtml

## themes/classic_blog/templates/pages_list.mtml

## themes/classic_blog/templates/about_this_page.mtml

## themes/classic_blog/templates/entry.mtml

## themes/classic_blog/templates/recover-password.mtml

## themes/classic_blog/templates/javascript.mtml

## themes/classic_blog/templates/archive_index.mtml

## themes/classic_blog/templates/trackbacks.mtml

## themes/classic_blog/templates/calendar.mtml

## themes/classic_blog/templates/recent_entries.mtml

## themes/classic_blog/templates/sidebar.mtml

## themes/classic_blog/templates/openid.mtml

## themes/classic_blog/templates/date_based_author_archives.mtml

## themes/classic_blog/templates/banner_footer.mtml

## themes/classic_blog/templates/comments.mtml

## themes/classic_blog/templates/search_results.mtml

## themes/classic_blog/templates/comment_listing.mtml

## themes/classic_blog/templates/date_based_category_archives.mtml

## themes/classic_blog/templates/dynamic_error.mtml

## themes/classic_blog/templates/creative_commons.mtml

## themes/classic_blog/templates/powered_by.mtml

## themes/classic_blog/templates/monthly_entry_listing.mtml

## themes/classic_blog/templates/search.mtml

## themes/classic_blog/templates/commenter_confirm.mtml

## themes/classic_blog/theme.yaml
	'Typical and authentic blogging design comes with plenty of styles and the selection of 2 column / 3 column layout. Best for all the bloggers.' => 'El diseño de blogs típico y auténtico viene en muchos estilos diferentes y en distribución de 2 y tres columnas. Lo mejor para todos los blogueros.',

## search_templates/default.tmpl
	'SEARCH FEED AUTODISCOVERY LINK PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'EL ENLACE DE AUTODESCUBRIMIENTO DE LA FUENTE DE SINDICACIÓN DE BÚSQUEDAS SOLO SE PUBLICA CUANDO SE HA REALIZADO UNA BÚSQUEDA',
	'Blog Search Results' => 'Resultados de la búsqueda en el blog',
	'Blog search' => 'Buscar en el blog',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM',
	'Search this site' => 'Buscar en este sitio',
	'Match case' => 'Distinguir mayúsculas',
	'SEARCH RESULTS DISPLAY' => 'MOSTRAR RESULTADOS DE LA BÚSQUEDA',
	'Matching entries from [_1]' => 'Entradas coincidentes de [_1]',
	'Entries from [_1] tagged with \'[_2]\'' => 'Entradas de [_1] etiquetadas en \'[_2]\'',
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Publicado <MTIfNonEmpty tag="EntryAuthorDisplayName">por [_1] </MTIfNonEmpty>en [_2]',
	'Showing the first [_1] results.' => 'Mostrando los primeros [_1] resultados.',
	'NO RESULTS FOUND MESSAGE' => 'MENSAJE DE NINGÚN RESULTADO ENCONTRADO',
	'Entries matching \'[_1]\'' => 'Entradas coincidentes con \'[_1]\'',
	'Entries tagged with \'[_1]\'' => 'Entradas etiquetadas en \'[_1]\'',
	'No pages were found containing \'[_1]\'.' => 'No se encontraron páginas que contuvieran \'[_1]\'.',
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes' => 'Por defecto, este motor de búsquedas, trata de encontrar todas las palabras en cualquier orden. Para buscar una frase exacta, acote la frase con comillas dobles',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions' => 'El motor de búsqueda también soporta las palabras claves AND, OR y NOT para especificar expresiones lógicas (booleanas)',
	'END OF ALPHA SEARCH RESULTS DIV' => 'FIN DE LOS RESULTADOS DE BÚSQUEDA - ALPHA DIV',
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'COMIENZO DE LA BARRA LATERAL BETA PARA MOSTRAR LA INFORMACIÓN DE BÚSQUEDA',
	'SET VARIABLES FOR SEARCH vs TAG information' => 'ESPECIFICAR VARIABLES PARA LA BÚSQUEDA vs información de etiqueta',
	'If you use an RSS reader, you can subscribe to a feed of all future entries tagged \'[_1]\'.' => 'Si usa un lector de RSS, puede suscribirse a la fuente de todas las futuras entradas con la etiqueta \'[_1]\'.',
	'If you use an RSS reader, you can subscribe to a feed of all future entries matching \'[_1]\'.' => 'Si usa un lector de RSS, puede suscribirse a la fuente de sindicación de todas las futuras entradas que contengan \'[_1]\'.',
	'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'INFORMACIÓN DE SUSCRIPCIÓN A LA FUENTE DE BÚSQUEDA/ETIQUETA',
	'Feed Subscription' => 'Suscripción de sindicación',
	'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds',
	'What is this?' => '¿Qué es esto?',
	'TAG LISTING FOR TAG SEARCH ONLY' => 'LISTA DE ETIQUETAS PARA LA BÚSQUEDA DE SOLO ETIQUETAS',
	'Other Tags' => 'Otras etiquetas',
	'END OF PAGE BODY' => 'FIN DEL CUERPO DE LA PÁGINA',
	'END OF CONTAINER' => 'FIN DEL CONTENEDOR',

## search_templates/results_feed.tmpl
	'Search Results for [_1]' => 'Resultados de la búsqueda sobre [_1]',

## search_templates/comments.tmpl
	'Search for new comments from:' => 'Buscar nuevos comentarios desde:',
	'the beginning' => 'el principio',
	'one week back' => 'hace una semana',
	'two weeks back' => 'hace dos semanas',
	'one month back' => 'hace un mes',
	'two months back' => 'hace dos meses',
	'three months back' => 'hace tres meses',
	'four months back' => 'hace cuatro meses',
	'five months back' => 'hace cinco meses',
	'six months back' => 'hace seis meses',
	'one year back' => 'hace un año',
	'Find new comments' => 'Encontrar nuevos comentarios',
	'Posted in [_1] on [_2]' => 'Publicado en [_1] el [_2]',
	'No results found' => 'No se encontraron resultados',
	'No new comments were found in the specified interval.' => 'No se encontraron nuevos comentarios en el intervalo especificado',
	'Select the time interval that you\'d like to search in, then click \'Find new comments\'' => 'Seleccione el intervalo temporal en el que desea buscar, y luego haga clic en \'Buscar nuevos comentarios\'',

## search_templates/results_feed_rss2.tmpl

## tmpl/wizard/optional.tmpl
	'Mail Configuration' => 'Configuración del correo electrónico',
	'Your mail configuration is complete.' => 'Se ha completado la configuración del correo.',
	'Check your email to confirm receipt of a test email from Movable Type and then proceed to the next step.' => 'Compruebe su correo para confirmar la recepción del mensaje de prueba de Movable Type y luego continúe con el paso siguiente.',
	'Continue' => 'Continuar',
	'Back' => 'Volver',
	'Show current mail settings' => 'Mostrar configuración actual del correo',
	'Periodically Movable Type will send email to inform users of new comments as well as other other events. For these emails to be sent properly, you must instruct Movable Type how to send email.' => 'Periódicamente, Movable Type enviará un correo para informar a los usuarios sobre los nuevos comentarios y otros eventos. Para que estos correos se envíen correctamente, debe decirle a Movable Type cómo enviarlos.',
	'An error occurred while attempting to send mail: ' => 'Ocurrió un error intentando enviar un mensaje de correo electrónico: ',
	'Send email via:' => 'Enviar correo vía:',
	'Select One...' => 'Seleccione uno...',
	'sendmail Path' => 'Ruta de sendmail',
	'The physical file path for your sendmail binary.' => 'Ruta física del fichero binario de sendmail.',
	'Outbound Mail Server (SMTP)' => 'Servidor de correo saliente (SMTP)',
	'Address of your SMTP Server.' => 'Dirección del servidor SMTP.',
	'Mail address to which test email should be sent' => 'La dirección de correo a la que debe enviarse el correo de prueba',
	'From mail address' => 'Dirección de correo',
	'Send Test Email' => 'Enviar mensaje de comprobación',

## tmpl/wizard/complete.tmpl
	'Configuration File' => 'Archivo de configuración',
	'The [_1] configuration file can\'t be located.' => 'El archivo de configuración [_1] no puede ser localizado',
	'Please use the configuration text below to create a file named \'mt-config.cgi\' in the root directory of [_1] (the same directory in which mt.cgi is found).' => 'Utilice por favor el texto de la configuración abajo para crear un archivo nombrado \'mt-config.cgi\' en la raíz del directorio de [_1] (el mismo directorio en el cual se encuentra mt.cgi).',
	'The wizard was unable to save the [_1] configuration file.' => 'El asistente de instalación no ha podido guardar el [_1] archivo de configuración.',
	'Confirm that your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click \'Retry\'.' => 'Confirme que el servidor web puede escribir en su directorio de inicio [_1] (el directorio que contiene mt.cgi) y luego haga clic en \'Reintentar\'.',
	'Congratulations! You\'ve successfully configured [_1].' => '¡Felicidades! Ha configurado con éxito [_1].',
	'Your configuration settings have been written to the following file:' => 'Sus parámetros de configuración han sido escritos en los siguientes archivos:',
	'To change the settings, click the \'Back\' button below.' => 'Para modificar la configuración, haga clic en el botón \'Regresar\' de abajo.',
	'Show the mt-config.cgi file generated by the wizard' => 'Mostrar el archivo mt-config.cgi generado por el asistente de instalación',
	'The mt-config.cgi file has been created manually.' => 'El fichero mt-config.cgi fue creado manualmente.',
	'Retry' => 'Reintentar',

## tmpl/wizard/cfg_dir.tmpl
	'Temporary Directory Configuration' => 'Configuración del directorio temporal',
	'You should configure you temporary directory settings.' => 'Debe configurar las opciones del directorio temporal.',
	'Your TempDir has been successfully configured. Click \'Continue\' below to continue configuration.' => 'TempDir se ha configurado con éxito. Para continuar con la configuración, haga clic a \'Continuar\' abajo.',
	'[_1] could not be found.' => '[_1] no pudo encontrarse.',
	'TempDir is required.' => 'TempDir es necesario.',
	'TempDir' => 'TempDir',
	'The physical path for temporary directory.' => 'La ruta al directorio temporal.',
	'Test' => 'Test',

## tmpl/wizard/start.tmpl
	'Welcome to Movable Type' => 'Bienvenido a Movable Type',
	'Configuration File Exists' => 'Configuración de archivos existentes',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Movable Type necesita que JavaScript esté disponible en el navegador. Por favor, active JavaScript y recargue esta página para continuar.',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Este asistente le ayudará a configurar las opciones básicas necesarias para ejecutar Movable Type.',
	'Language' => 'Idioma',
	'Default language.' => 'Idioma predefinido.',
	'<strong>Error: \'[_1]\' could not be found.</strong>  Please move your static files to the directory first or correct the setting if it is incorrect.' => '<strong>Error: \'[_1]\' no se pudo encontrar.</strong>  Por favor, mueva los ficheros estáticos al primer directorio o corrija la configuración si no es correcta.',
	'Configure Static Web Path' => 'Configurar ruta del web estático',
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type viene con un directorio nombrado [_1] el cual contiene un número de archivos importantes tales como imágenes, archivos javascript y hojas de estilo en cascadas.',
	'The [_1] directory is in the main Movable Type directory which this wizard script resides, but due to your web server\'s configuration, the [_1] directory is not accessible in this location and must be moved to a web-accessible location (e.g., your web document root directory).' => 'El directorio [_1] está en el directorio principal de Movable Type que recide en el script de instalación, pero depende de la configuración de su web server, el directorio [_1] no es accesible en este lugar y debe ser removido a un lugar de web accesible (e.g., su documento de raíz del directorio web)',
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Este directorio o se ha renombrado o movido a un lugar fuera del directorio de Movable Type.',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => 'Cuando el directorio [_1] esté en un lugar accesible vía web, especifique el lugar debajo.',
	'This URL path can be in the form of [_1] or simply [_2]' => 'La dirección URL puede estar en la forma de [_1] o simplemente [_2]',
	'This path must be in the form of [_1]' => 'Esta ruta debe estar en la forma [_1]',
	'Static web path' => 'Ruta estática del web',
	'Static file path' => 'Ruta estática de los ficheros',
	'Begin' => 'Comenzar',
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => 'Una configuración del archivo (mt-config,cgi) existe, <a href="[_1]>identificarse</a> a Movable Type.',
	'To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page' => 'Para crear una nueva configuración del archivo usando Wizard, borre la configuración actual del archivo y actualice la página',

## tmpl/wizard/packages.tmpl
	'Requirements Check' => 'Comprobación de requerimientos',
	'The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your blog\'s data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the \'Retry\' button.' => 'Los siguientes módulos de Perl son necesarios para la conexión con la base de datos. Movable Type necesita una base de datos para guardar los datos del blog. Por favor, instale los paquetes listados aquí para continuar. Cuando lo haya hecho, haga clic en el botón \'Reintentar\'.',
	'All required Perl modules were found.' => 'Se encontraron todos los módulos de Perl necesarios.',
	'You are ready to proceed with the installation of Movable Type.' => 'Está listo para continuar con la instalación de Movable Type.',
	'Some optional Perl modules could not be found. <a href="javascript:void(0)" onclick="[_1]">Display list of optional modules</a>' => 'No se encontraron algunos módulos opcionales de Perl. <a href="javascript:void(0)" onclick="[_1]">Mostrar lista de módulos opcionales</a>',
	'One or more Perl modules required by Movable Type could not be found.' => 'No se encontraron uno o varios módulos de Perl necesarios.',
	'The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the \'Retry\' button to re-test for these packages.' => 'Los siguientes módulos de Perl son necesarios para que Movable Type se ejecute correctamente. Una vez los haya instalado, haga clic en el botón \'Reintentar\' para realizar la comprobación nuevamente.',
	'Some optional Perl modules could not be found. You may continue without installing these optional Perl modules. They may be installed at any time if they are needed. Click \'Retry\' to test for the modules again.' => 'No se encontraron algunos módulos opcionales de Perl. Puede continuar sin instalarlos. Podrá instalarlos cuando le sean necesarios. Haga clic en \'Reintentar\' para comprobar los módulos otra vez.',
	'Missing Database Modules' => 'Módulos de base de datos no encontrados',
	'Missing Optional Modules' => 'Módulos opcionales no encontrados',
	'Missing Required Modules' => 'Módulos necesarios no encontrados',
	'Minimal version requirement: [_1]' => 'Versión mínima requerida: [_1]',
	'Learn more about installing Perl modules.' => 'Más información sobre la instalación de módulos de Perl.',
	'http://www.movabletype.org/documentation/installation/perl-modules.html' => 'http://www.movabletype.org/documentation/installation/perl-modules.html',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'El servidor tiene instalados todos los módulos necesarios; no necesita realizar ninguna instalación adicional.',

## tmpl/wizard/configure.tmpl
	'Database Configuration' => 'Configuración de la base de datos',
	'Details' => 'Detalles',
	'Your database configuration is complete.' => 'Se ha completado la configuración de la base de datos.',
	'You may proceed to the next step.' => 'Puede continuar con el siguiente paso.',
	'Please enter the parameters necessary for connecting to your database.' => 'Por favor, introduzca los parámetros necesarios para la conexión con la base de datos.',
	'Show Current Settings' => 'Mostrar configuración actual',
	'Database Type' => 'Tipo de base de datos',
	'http://www.movabletype.org/documentation/[_1]' => 'http://www.movabletype.org/documentation/[_1]',
	'Is your preferred database not listed? View the <a href="[_1]" target="_blank">Movable Type System Check</a> see if additional modules are necessary.' => '¿Su base de datos preferida no está en la lista? Consulte la <a href="[_1]" target="_blank">Comprobación del Sistema de Movable Type</a> para ver si se necesitan otros módulos.',
	'Once installed, <a href="javascript:void(0)" onclick="[_1]">click here to refresh this screen</a>.' => 'Una vez instalado, haga <a href="javascript:void(0)" onclick="[_1]">clic aquí para recargar esta pantalla</a>.',
	'Read more: <a href="[_1]" target="_blank">Setting Up Your Database</a>' => 'Más información: <a href="[_1]" target="_blank">Configuración de la base de datos</a>',
	'Database Path' => 'Ruta de la base de datos',
	'The physical file path for your SQLite database. ' => 'La ruta física del fichero de la base de datos SQLite.',
	'A default location of \'./db/mt.db\' will store the database file underneath your Movable Type directory.' => 'La base de datos se guarda por defecto en \'./db/mt.db\' bajo el directorio de Movable Type.',
	'Database Server' => 'Servidor de base de datos',
	'This is usually \'localhost\'.' => 'Generalmente es \'localhost\'.',
	'Database Name' => 'Nombre de la base de datos',
	'The name of your SQL database (this database must already exist).' => 'El nombre de su base de datos SQL (esta base de datos debe existir).',
	'The username to login to your SQL database.' => 'El nombre de usuario para acceder a la base de datos SQL.',
	'Password' => 'Contraseña',
	'The password to login to your SQL database.' => 'La contraseña para acceder a la base de datos SQL.',
	'Show Advanced Configuration Options' => 'Mostrar opciones de configuración avanzadas',
	'Database Port' => 'Puerto de la base de datos',
	'This can usually be left blank.' => 'Generalmente puede dejarse en blanco.',
	'Database Socket' => 'Socket de la base de datos',
	'Publish Charset' => 'Código de caracteres',
	'MS SQL Server driver must use either Shift_JIS or ISO-8859-1.  MS SQL Server driver does not support UTF-8 or any other character set.' => 'El controlador de MS SQL Server debe usar Shift_JIS o ISO-8859-1. El controlador de MS SQL Server no soporta ni UTF-8 ni ningún otro código de caracteres.',
	'Test Connection' => 'Probar la Conexión',
	'You must set your Database Path.' => 'Debe definir la ruta de la base de datos.',
	'You must set your Username.' => 'Debe introducir el nombre del usuario.',
	'You must set your Database Server.' => 'Debe introducir el servidor de base de datos.',

## tmpl/wizard/blog.tmpl
	'Setup Your First Blog' => 'Configure su primer blog',
	'In order to properly publish your blog, you must provide Movable Type with your blog\'s URL and the path on the filesystem where its files should be published.' => 'Para publicar correctamente el blog, debe proveer a Movable Type la URL del blog y la ruta en el sistema donde se publicarán sus ficheros.',
	'My First Blog' => 'Mi primer blog',
	'Publishing Path' => 'Ruta de publicación',
	'Your \'Publishing Path\' is the path on your web server\'s file system where Movable Type will publish all the files for your blog. Your web server must have write access to this directory.' => 'La \'Ruta de publicación\' es la ruta en el sistema de archivos del servidor donde Movable Type publicará todos los ficheros del blog. El servidor web debe poder escribir en este directorio.',

## tmpl/cms/include/list_associations/page_title.tmpl
	'Permissions for [_1]' => 'Permisos de [_1]',
	'Manage Permissions' => 'Administrar permisos', # Translate - New
	'Users for [_1]' => 'Usuarios de [_1]',

## tmpl/cms/include/theme_exporters/templateset.tmpl
	'<span class="count">[_1]</span> templates are included' => 'Se incluyen <span class="count">[_1]</span> plantillas',
	'Archive Path' => 'Ruta de archivos',
	'_external_link_target' => '_blank',
	'View Published Template' => 'Ver plantilla publicada',
	'-' => '-',

## tmpl/cms/include/theme_exporters/static_files.tmpl
	'Files types that will be included in the theme are: [_1].' => 'Los tipos de fichero que se incluyen en el tema son: [_1].',
	'Included Directories' => 'Directorios incluídos',
	'List the directories that contain the static files that you want to be included in your theme.' => 'Lista los directorios que contienen los ficheros estáticos que desea incluir en su tema.',

## tmpl/cms/include/theme_exporters/folder.tmpl
	'Folder Name' => 'Nombre de la carpeta',
	'Path' => 'Ruta',

## tmpl/cms/include/theme_exporters/category.tmpl
	'Category Name' => 'Nombre de la categoría',

## tmpl/cms/include/revision_table.tmpl
	'No revisions could be found.' => 'No se encontraron revisiones.',
	'Date' => 'Fecha',
	'Note' => 'Nota',
	'Saved By' => 'Guardado por',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001-[_1] Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001-[_1] Six Apart. All Rights Reserved.',

## tmpl/cms/include/comment_table.tmpl
	'comment' => 'comentario',
	'comments' => 'comentarios',
	'to publish' => 'para publicar',
	'Publish selected comments (a)' => 'Publicar comentarios seleccionados (a)',
	'Delete selected comments (x)' => 'Borrar comentarios seleccionados (x)',
	'Report selected comments as Spam (j)' => 'Marcar comentarios seleccionados como spam (j)',
	'Report selected comments as Not Spam and Publish (j)' => 'Desmarcar como spam y publicar los comentarios seleccionados (j)',
	'Not Spam' => 'No es spam',
	'Are you sure you want to remove all comments reported as spam?' => '¿Está seguro de que desea borrar todos los comentarios marcados como spam?',
	'Delete all comments reported as Spam' => 'Borrar todos los comentarios marcados como spam',
	'Empty' => 'Vacío',
	'Ban This IP' => 'Bloquear esta IP',
	'Website/Blog' => 'Sitio web/Blog',
	'Entry/Page' => 'Entrada/Página',
	'IP' => 'IP',
	'Only show published comments' => 'Mostrar solo comentarios publicados',
	'Published' => 'Publicado',
	'Only show pending comments' => 'Mostrar solo comentarios pendientes',
	'Pending' => 'Pendiente',
	'Edit this comment' => 'Editar este comentario',
	'([quant,_1,reply,replies])' => '([quant,_1,respuesta,respuestas])',
	'Trusted' => 'De confianza',
	'Blocked' => 'Bloqueado',
	'Authenticated' => 'Autentificado',
	'Edit this [_1] commenter' => 'Editar comentarista [_1]',
	'Search for comments by this commenter' => 'Buscar comentarios de este comentarista',
	'View this entry' => 'Ver esta entrada',
	'View this page' => 'Ver esta página',
	'Search for all comments from this IP address' => 'Buscar todos los comentarios enviados desde esta dirección IP',

## tmpl/cms/include/asset_replace.tmpl
	'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'El fichero llamado \'[_1]\' ya existe. ¿Desea sobreescribirlo?',
	'Yes (s)' => 'Sí (s)',
	'Yes' => 'Sí',
	'No' => 'No',

## tmpl/cms/include/rpt_log_table.tmpl
	'No log records could be found.' => 'No se encontraron registros.',
	'Schwartz Message' => 'Mensaje de Schwartz',

## tmpl/cms/include/member_table.tmpl
	'user' => 'usario',
	'users' => 'usarios',
	'Are you sure you want to remove the selected user from this blog?' => '¿Está seguro de que desea borrar al usuario seleccionado de este blog?',
	'Are you sure you want to remove the [_1] selected users from this blog?' => '¿Está seguro de que desea borrar a los [_1] usuarios seleccionados de este blog?',
	'Remove selected user(s) (r)' => 'Borrar usuarios seleccionados (r)',
	'Remove' => 'Borrar',
	'_USER_ENABLED' => 'Habilitado',
	'Trusted commenter' => 'Comentarista de confianza',
	'Email' => 'Correo electrónico',
	'Link' => 'Un vínculo',
	'Remove this role' => 'Borrar este rol',

## tmpl/cms/include/feed_link.tmpl
	'Activity Feed' => 'Sindicación de la actividad',
	'Disabled' => 'Desactivado',
	'Set Web Services Password' => 'Establecer contraseña de servicios web',

## tmpl/cms/include/comment_detail.tmpl

## tmpl/cms/include/asset_table.tmpl
	'Delete selected assets (x)' => 'Borrar los ficheros multimedia seleccionados (x)',
	'Size' => 'Tamaño',
	'Created By' => 'Creado por',
	'Created On' => 'Creado en',
	'Asset Missing' => 'Fichero multimedia no existe',
	'No thumbnail image' => 'Sin miniatura',
	'[_1] is missing' => '[_1] no existe',
	'System' => 'Sistema',

## tmpl/cms/include/import_start.tmpl
	'Importing...' => 'Importando...',
	'Importing entries into blog' => 'Importando entradas en el blog',
	'Importing entries as user \'[_1]\'' => 'Importando entradas como usario \'[_1]\'',
	'Creating new users for each user found in the blog' => 'Creando nuevos usarios para cada usario encontrado en el blog',

## tmpl/cms/include/log_table.tmpl
	'_LOG_TABLE_BY' => 'Por',
	'Show Datail' => 'Mostrar detalle',
	'IP: [_1]' => 'IP: [_1]',

## tmpl/cms/include/pagination.tmpl

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been backed up successfully!' => '¡La copia de seguridad de los datos se ha realizado con éxito!',
	'Download This File' => 'Descargar este fichero',
	'_BACKUP_TEMPDIR_WARNING' => 'La copia de seguridad se realizó con éxito en el directorio [_1]. Descargue y <strong>borre luego</strong> los ficheros listados abajo desde [_1] <strong>inmediatamente</strong>, porque los ficheros de la copia de seguridad contiene información sensible.',
	'_BACKUP_DOWNLOAD_MESSAGE' => 'La descarga del fichero de la copia de seguridad comenzará automáticamente dentro de unos segundos. Si por alguna razón no lo hace, haga clic <a href="javascript:(void)" onclick="submit_form()">aquí</a> para comenzar la descarga manualmente. Por favor, tenga en cuenta que solo puede descargar el fichero de la copia de seguridad una vez por sesión.',
	'An error occurred during the backup process: [_1]' => 'Ocurrió un error durante la copia de seguridad: [_1]',

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Fecha de creación',
	'Click to edit contact' => 'Clic para editar el contacto',
	'Save changes' => 'Guardar cambios',
	'Save' => 'Guardar',

## tmpl/cms/include/footer.tmpl
	'This is a beta version of Movable Type and is not recommended for production use.' => 'Esta es una versión beta de Movable Type y no se recomienda su uso en producción.',
	'http://www.movabletype.org' => 'http://www.movabletype.org',
	'MovableType.org' => 'MovableType.org',
	'http://plugins.movabletype.org/' => 'http://plugins.movabletype.org/',
	'Documentation' => 'Documentación',
	'http://wiki.movabletype.org/' => 'http://wiki.movabletype.org/',
	'Wiki' => 'Wiki',
	'http://www.movabletype.com/support/' => 'http://www.movabletype.com/support/',
	'Support' => 'Soporte',
	'http://forums.movabletype.org/' => 'http://forums.movabletype.org/',
	'Forums' => 'Foros',
	'http://www.movabletype.org/feedback.html' => 'http://www.movabletype.org/feedback.html',
	'Send Us Feedback' => 'Envíenos su opinión',
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> versión [_2]',
	'with' => 'con',
	'Your Dashboard' => 'Tablón',

## tmpl/cms/include/commenter_table.tmpl
	'Identity' => 'Identidad',
	'Last Commented' => 'Últimos comentados',
	'Only show trusted commenters' => 'Mostrar solo comentaristas de confianza',
	'Only show banned commenters' => 'Mostrar solo comentaristas bloqueados',
	'Banned' => 'Bloqueado',
	'Only show neutral commenters' => 'Mostrar solo comentaristas neutrales',
	'Edit this commenter' => 'Editar este comentarista',
	'View this commenter&rsquo;s profile' => 'Ver el perfil de este comentarista',

## tmpl/cms/include/ping_table.tmpl
	'Publish selected [_1] (p)' => 'Publicar [_1] seleccionados (p)',
	'Delete selected [_1] (x)' => 'Borrar [_1] seleccionados (x)',
	'Report selected [_1] as Spam (j)' => 'Marcar como spam [_1] seleccionados (j)',
	'Report selected [_1] as Not Spam and Publish (j)' => 'Desmarcar como spam y publicar [_1] seleccionados (j)',
	'Are you sure you want to remove all TrackBacks reported as spam?' => '¿Está seguro de que desea borrar todos los TrackBacks marcados como spam?',
	'Deletes all [_1] reported as Spam' => 'Borrar todos los [_1] marcados como spam',
	'From' => 'Origen',
	'Target' => 'Destino',
	'Only show published TrackBacks' => 'Mostrar solo TrackBacks publicados',
	'Only show pending TrackBacks' => 'Mostrar solo TrackBacks pendientes',
	'Edit this TrackBack' => 'Editar este TrackBack',
	'Go to the source entry of this TrackBack' => 'Ir a la entrada de origen de este TrackBack',
	'View the [_1] for this TrackBack' => 'Mostrar [_1] de este TrackBack',

## tmpl/cms/include/login_mt.tmpl

## tmpl/cms/include/entry_table.tmpl
	'Save these [_1] (s)' => 'Guardar este [_1] (s)',
	'Republish selected [_1] (r)' => 'Republicar [1_] seleccionadas [_1] (r)',
	'Last Modified' => 'Última modificación',
	'Created' => 'Creado',
	'View' => 'Ver',
	'Unpublished (Draft)' => 'No publicado (Borrador)',
	'Unpublished (Review)' => 'No publicado (Revisión)',
	'Scheduled' => 'Programado',
	'Only show unpublished entries' => 'Mostrar solo las entradas no publicadas',
	'Only show unpublished pages' => 'Mostrar solo las páginas no publicadas',
	'Only show published entries' => 'Mostrar solo las entradas publicadas',
	'Only show published pages' => 'Mostrar solo las páginas publicadas',
	'Only show entries for review' => 'Mostrar solo las entradas para revisar',
	'Only show pages for review' => 'Mostrar solo las páginas para revisar',
	'Only show scheduled entries' => 'Mostrar solo las entradas programadas',
	'Only show scheduled pages' => 'Mostrar solo las páginas programadas',
	'Only show spam entries' => 'Mostrar solo las entradas basura',
	'Only show spam pages' => 'Mostrar solo las páginas basura',
	'Edit Entry' => 'Editar entrada',
	'Edit Page' => 'Editar página',
	'View entry' => 'Ver entrada',
	'View page' => 'Ver página',
	'No entries could be found.' => 'No se encontraron entradas.',
	'<a href="[_1]">Create an entry</a> now.' => '<a href="[_1]">Crear una entrada</a> ahora.',
	'No page could be found. <a href="[_1]">Create a page</a> now.' => 'No se encontró ninguna página. <a href="[_1]">Cree una ahora</a>.',
	'to republish' => 'para reconstruir',
	'to act upon' => 'actuar cuando',

## tmpl/cms/include/author_table.tmpl
	'_USER_DISABLED' => 'Deshabilitado',

## tmpl/cms/include/calendar.tmpl
	'_LOCALE_WEEK_START' => '0',
	'S|M|T|W|T|F|S' => 'S|M|T|W|T|F|S',
	'January' => 'Enero',
	'Febuary' => 'Febrero',
	'March' => 'Marzo',
	'April' => 'Abril',
	'May' => 'Mayo',
	'June' => 'Junio',
	'July' => 'Julio',
	'August' => 'Agosto',
	'September' => 'Septiembre',
	'October' => 'Octubre',
	'November' => 'Noviembre',
	'December' => 'Diciembre',
	'Jan' => 'Ene.',
	'Feb' => 'Feb.',
	'Mar' => 'Mar.',
	'Apr' => 'Abr.',
	'_SHORT_MAY' => 'May.',
	'Jun' => 'Jun.',
	'Jul' => 'Jul.',
	'Aug' => 'Ago.',
	'Sep' => 'Sep.',
	'Oct' => 'Oct.',
	'Nov' => 'Nov.',
	'Dec' => 'Dic.',
	'OK' => 'Aceptar',
	'[_1:calMonth] [_2:calYear]' => '[_1:calMonth] [_2:calYear]',

## tmpl/cms/include/itemset_action_widget.tmpl
	'More actions...' => 'Más acciones...',
	'Plugin Actions' => 'Acciones de extensiones',
	'Go' => 'Ir',

## tmpl/cms/include/anonymous_comment.tmpl
	'Allow comments from anonymous or unauthenticated users.' => 'Permitir comentarios de usuarios anónimos o no autentificados.',
	'Require E-mail Address for Anonymous Comments' => 'Requerir dirección de correo en los comentarios anónimos',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Si está activo, los visitantes deberán introducir una dirección válida de correo electrónico para comentar.',

## tmpl/cms/include/category_selector.tmpl
	'Add sub category' => 'Añadir sub categoría',
	'Add' => 'Crear',
	'Add sub folder' => 'Añadir sub carpeta',

## tmpl/cms/include/display_options.tmpl
	'Display Options' => 'Opciones de visualización',
	'_DISPLAY_OPTIONS_SHOW' => 'Mostrar',
	'[quant,_1,row,rows]' => '[quant,_1,fila,filas]',
	'Compact' => 'Compacto',
	'Expanded' => 'Expandido',
	'Date Format' => 'Formato de fechas',
	'Relative' => 'Relativo',
	'Full' => 'Completo',
	'Save display options' => 'Guardar opciones de visualización',

## tmpl/cms/include/backup_start.tmpl
	'Backing up Movable Type' => 'Haciendo copia de seguridad de Movable Type',

## tmpl/cms/include/template_table.tmpl
	'Create Archive Template:' => 'Crear plantilla de archivos',
	'Entry Listing' => 'Listado de entradas',
	'Create template module' => 'Crear plantilla de módulo',
	'Create index template' => 'Crear plantilla índice',
	'Publish selected templates (a)' => 'Publicar plantillas seleccionadas (a)',
	'SSI' => 'Inclusiones en servidor (SSI)', # Translate - New
	'Cached' => 'Cacheado',
	'Linked Template' => 'Plantilla enlazada',
	'Manual' => 'Manual',
	'Dynamic' => 'Dinámico',
	'Publish Queue' => 'Cola de publicación',
	'Static' => 'Estático',
	'templates' => 'plantillas',
	'<mt:var name="object_label_plural" escape="js">' => '<mt:var name="object_label_plural" escape="js">',

## tmpl/cms/include/asset_upload.tmpl
	'You must set a valid destination.' => 'Debe indicar un destino válido.',
	'Before you can upload a file, you need to publish your [_1]. [_2]Configure your [_1]\'s publishing paths[_3] and republish your [_1].' => 'Antes de subir un fichero, debe publicar su [_1]. [_2]Configure las rutas de publicación[_3] de su [_1] y republique el [_1].',
	'Your system or [_1] administrator needs to publish the [_1] before you can upload files. Please contact your system or [_1] administrator.' => 'El administrador del sistema o del [_1] debe publicar el [_1] antes de pueda subir ficheros. Por favor, contacte con el administrador del sistema o del [_1].',
	'Close (x)' => 'Cerrar (x)',
	'Asset file(\'[_1]\') has been uploaded.' => 'Se ha transferido un fichero multimedia (\'[_1]\').',
	'Select File to Upload' => 'Seleccione el fichero a subir',
	'_USAGE_UPLOAD' => 'Puede transferir el fichero a un subdirectorio en la ruta seleccionada. Si el subdirectorio no existe, se creará.',
	'Upload Destination' => 'Destino de la transferencia',
	'Choose Folder' => 'Seleccionar carpeta',
	'Upload (s)' => 'Subir (s)',
	'Upload' => 'Subir',
	'Cancel (x)' => 'Cancelar (x)',
	'Back (b)' => 'Volver (b)',

## tmpl/cms/include/listing_panel.tmpl
	'Step [_1] of [_2]' => 'Paso [_1] de [_2]',
	'Reset' => 'Reiniciar',
	'Go to [_1]' => 'Ir a [_1]',
	'Sorry, there were no results for your search. Please try searching again.' => 'Lo siento, no se encontraron resultados para la búsqueda. Por favor, intente buscar de nuevo.',
	'Sorry, there is no data for this object set.' => 'Lo siento, no hay datos para este conjunto de objetos.',
	'OK (s)' => 'Aceptar (s)',
	'Continue (s)' => 'Continuar (s)',

## tmpl/cms/include/header.tmpl
	'Signed in as [_1]' => 'Identificado como [_1]', # Translate - New
	'Help' => 'Ayuda',
	'Sign out' => 'Salir',
	'User Dashboard' => 'Tablón del usuario',
	'System Overview' => 'Resumen del sistema',
	'Select another website...' => 'Seleccione otro sitio web...',
	'(on [_1])' => '(en [_1])', # Translate - New
	'Select another blog...' => 'Seleccionar otro blog...',
	'Create Website' => 'Crear un sitio web',
	'Create Blog (on [_1])' => 'Crear un blog (en [_1])', # Translate - New
	'View Site' => 'Ver sitio',
	'View [_1]' => 'Ver [_1]',
	'Search (q)' => 'Buscar (q)',
	'This website was created during the version-up from the previous version of Movable Type. \'Site Root\' and \'Site URL\' are left blank to retain \'Publishing Paths\' compatibility for blogs those were created at the previous version. You can post and publish on existing blogs, but you cannot publish this website itself because of the blank \'Site Root\' and \'Site URL\'.' => 'Este sitio web se creó durante la actualización desde la versión anterior de Movable Type.  This website was created during the version-up from the previous version of Movable Type. La \'Raíz del sitio\' y la \'URL del sitio\' se han dejado en blanco para tener compatibilidad con las \'Rutas de publicación\' de los blogs que se crearon en la versión anterior. Puede publicar en cualquiera de los blogs existentes, pero no puede publicar en este sitio web debido a que la \'Raíz del sitio\' y la \'URL del sitio\' están en blanco.',
	'from Revision History' => 'del histórico de revisiones',

## tmpl/cms/include/archetype_editor.tmpl
	'Decrease Text Size' => 'Aumentar tamaño de texto',
	'Increase Text Size' => 'Disminuir tamaño de texto',
	'Bold' => 'Negrita',
	'Italic' => 'Cursiva',
	'Underline' => 'Subrayado',
	'Strikethrough' => 'Tachado',
	'Text Color' => 'Color de texto',
	'Email Link' => 'Enlace de correo',
	'Begin Blockquote' => 'Comenzar cita',
	'End Blockquote' => 'Finalizar cita',
	'Bulleted List' => 'Viñeta',
	'Numbered List' => 'Numeración',
	'Left Align Item' => 'Alinear elemento a la izquierda',
	'Center Item' => 'Centrar elemento',
	'Right Align Item' => 'Alinear elemento a la derecha',
	'Left Align Text' => 'Alinear texto a la izquierda',
	'Center Text' => 'Centrar texto',
	'Right Align Text' => 'Alinear texto a la derecha',
	'Insert Image' => 'Insertar imagen',
	'Insert File' => 'Insertar fichero',
	'WYSIWYG Mode' => 'Modo con formato (WYSIWYG)',
	'HTML Mode' => 'Modo HTML',

## tmpl/cms/include/blog_table.tmpl
	'[_1] Name' => 'Nombre de [_1]',

## tmpl/cms/include/users_content_nav.tmpl
	'Profile' => 'Perfil',

## tmpl/cms/include/import_end.tmpl
	'All data imported successfully!' => '¡Importados con éxito todos los datos!',
	'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Asegúrese de borrar los ficheros importados del directorio \'import\', para evitar procesarlos de nuevo al ejecutar en otra ocasión el proceso de importación.',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Ocurrió un error durante el proceso de importación: [_1]. Por favor, compruebe su fichero de importación.',

## tmpl/cms/include/archive_maps.tmpl
	'Type' => 'Tipo',
	'Custom...' => 'Personalizar...',
	'Statically (default)' => 'Estáticamente (por defecto)',
	'Via Publish Queue' => 'Vía cola de publicación',
	'On a schedule' => 'Programado',
	': every ' => ': cada ',
	'minutes' => 'minutos',
	'hours' => 'horas',
	'days' => 'días',
	'Dynamically' => 'Dinámicamente',
	'Manually' => 'Manualmente',
	'Do Not Publish' => 'No publicar',

## tmpl/cms/dialog/recover.tmpl
	'The email address provided is not unique.  Please enter your username.' => 'El correo no es único. Por favor, introduzca el usuario.',
	'An email with a link to reset your password has been sent to your email address ([_1]).' => 'Se ha enviado a su dirección de correo ([_1]) un correo con el enlace para reiniciar la contraseña',
	'Go Back (x)' => 'Volver',
	'Sign in to Movable Type (s)' => 'Identifíquese en Movable Type (s)',
	'Sign in to Movable Type' => 'Identifíquese en Movable Type',
	'Recover (s)' => 'Recuperar (s)',
	'Recover' => 'Recuperar',

## tmpl/cms/dialog/restore_end.tmpl
	'An error occurred during the restore process: [_1] Please check your restore file.' => 'Ocurrió un error durante el proceso de restauración: [_1] Por favor, compruebe el fichero de restauración.',
	'View Activity Log (v)' => 'Mostrar registro de actividad (v)',
	'All data restored successfully!' => '¡Se restauraron todos los datos correctamente!',
	'Close (s)' => 'Cerrado (s)',
	'Next Page' => 'Página siguiente',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => 'La página le redireccionará a una nueva en 3 segundos. [_1]Parar la redirección.[_2]',

## tmpl/cms/dialog/asset_replace.tmpl

## tmpl/cms/dialog/asset_list.tmpl
	'Insert Asset' => 'Añadir un fichero multimedia',
	'Upload New File' => 'Subir nuevo fichero',
	'Upload New Image' => 'Subir nueva imagen',
	'Asset Name' => 'Nombre del fichero multimedia',
	'View Asset' => 'Ver fichero multimedia',
	'Next (s)' => 'Siguiente (s)',
	'Insert (s)' => 'Insertar (s)',
	'Insert' => 'Insertar',
	'No assets could be found.' => 'No se encontraron ficheros multimedia.',

## tmpl/cms/dialog/new_password.tmpl
	'Change Password' => 'Cambiar Contraseña',
	'New Password' => 'Nueva contraseña',
	'Confirm New Password' => 'Confirmar nueva contraseña',
	'Change' => 'cambiar',

## tmpl/cms/dialog/refresh_templates.tmpl
	'Refresh Global Templates' => 'Recargar plantillas globales',
	'Cannot find template set. Please apply [_1]theme[_2] to refresh your templates.' => 'No se pudo encontrar el conjunto de plantillas. Por favor, aplique un [_1]tema[_2] para refrescar las plantillas.', # Translate - New
	'Revert modifications of theme templates' => 'Deshacer modificaciones en las plantillas de los temas',
	'Reset to theme defaults' => 'Reiniciar a los valores predefinidos del tema',
	'Deletes all existing templates and install the selected theme\'s default.' => 'Borra todas las plantillas existentes e instala las predefinidas por el tema seleccionado.',
	'Refresh global templates' => 'Recargar plantillas globales',
	'Reset to factory defaults' => 'Valores de fábrica',
	'Deletes all existing templates and installs factory default template set.' => 'Borra todas las plantillas existentes e instala el conjunto de plantillas predefinido.',
	'Updates current templates while retaining any user-created templates.' => 'Actualiza las plantillas actuales pero mantiene las plantillas creadas por el usuario.',
	'Make backups of existing templates first' => 'Primero, haga copias de seguridad de las plantillas',
	'You have requested to <strong>refresh the current template set</strong>. This action will:' => 'Ha solicitado <strong>refrescar el actual conjunto de plantillas</strong>. Esta acción:',
	'You have requested to <strong>refresh the global templates</strong>. This action will:' => 'Ha solicitado <strong>recargar ñas plantillas globales</strong>. Esta acción:',
	'make backups of your templates that can be accessed through your backup filter' => 'realizará copia de seguridad de las plantillas accesibles a través del filtro de copias de seguridad',
	'potentially install new templates' => 'instalará potencialmente nuevas plantillas',
	'overwrite some existing templates with new template code' => 'reescribirá algunas plantillas existentes con el código de las nuevas plantillas',
	'You have requested to <strong>apply a new template set</strong>. This action will:' => 'Ha solicitado <strong>aplicar un nuevo conjunto de plantillas</strong>. Esta acción:',
	'You have requested to <strong>reset to the default global templates</strong>. This action will:' => 'Ha solicitado <strong>reinicializar a las plantillas globales predefinidas</strong>. Esta acción:',
	'delete all of the templates in your blog' => 'borrará todas las plantillas del blog',
	'install new templates from the selected template set' => 'instalará nuevas plantillas del conjunto seleccionado',
	'delete all of your global templates' => 'borrará todas las plantillas globales',
	'install new templates from the default global templates' => 'instalará nuevas plantillas con las plantillas globales predefinidas',
	'Are you sure you wish to continue?' => '¿Está seguro de que desea continuar?',
	'Confirm' => 'Confirmar',

## tmpl/cms/dialog/comment_reply.tmpl
	'Reply to comment' => 'Responder al comentario',
	'On [_1], [_2] commented on [_3]' => 'En [_1], [_2] comentó en [_3]',
	'Preview of your comment' => 'Vista previa del comentario',
	'Your reply:' => 'Su respuesta:',
	'Submit reply (s)' => 'Enviar respuesta (s)',
	'Preview reply (v)' => 'Vista previa de la respuesta (v)',
	'Re-edit reply (r)' => 'Re-editar respuesta (r)',
	'Re-edit' => 'Re-editar',

## tmpl/cms/dialog/asset_upload.tmpl
	'You need to configure your blog.' => 'Debe configurar el blog.',
	'Your blog has not been published.' => 'Su blog no ha sido publicado.',

## tmpl/cms/dialog/publishing_profile.tmpl
	'Publishing Profile' => 'Perfil de publicación',
	'Choose the profile that best matches the requirements for this blog.' => 'Seleccione el perfil que mejor se adapte a las necesidades de este blog.',
	'Static Publishing' => 'Publicación estática',
	'Immediately publish all templates statically.' => 'Publicar inmediatamente todas las plantillas de forma estática.',
	'Background Publishing' => 'Publicación en segundo plano',
	'All templates published statically via Publish Que.' => 'Todas las plantillas publicadas con la cola de publicación.',
	'High Priority Static Publishing' => 'Publicación estática de alta prioridad',
	'Immediately publish Main Index template, Entry archives, and Page archives statically. Use Publish Queue to publish all other templates statically.' => 'Publicar inmediata y estáticamente la plantilla índice principal y los archivos de entradas y páginas. Utilizar la cola de publicación para publicar el resto de plantillas estáticamente.',
	'Immediately publish Main Index template, Page archives statically. Use Publish Queue to publish all other templates statically.' => 'Publica inmediatamente la plantilla índice principal y los archivos de página estáticamente. Utilice la cola de publicación para publicar estáticamente las otras plantillas.',
	'Dynamic Publishing' => 'Publicación dinámica',
	'Publish all templates dynamically.' => 'Publicar todas las plantillas dinámicamente.',
	'Dynamic Archives Only' => 'Solo archivos dinámicos',
	'Publish all Archive templates dynamically. Immediately publish all other templates statically.' => 'Publicar todos las plantillas de archivos dinámicamente. Publicar de forma inmediata el resto de plantillas estáticamente.',
	'This new publishing profile will update all of your templates.' => 'Este nuevo perfil de publicación actualizará todas las plantillas.',

## tmpl/cms/dialog/restore_upload.tmpl
	'Restore: Multiple Files' => 'Restaurar: Múltiples ficheros',
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => 'La cancelación del proceso creará objetos huérfanos. ¿Está seguro de que desea cancelar la operación de restauración?',
	'Please upload the file [_1]' => 'Por favor, suba el fichero [_1]',

## tmpl/cms/dialog/list_revision.tmpl
	'Select the revision to populate the values of the Edit screen.' => 'Seleccione la revisión para poblar los valores en la plantalla de Edición.',

## tmpl/cms/dialog/entry_notify.tmpl
	'Send a Notification' => 'Enviar una notificación',
	'You must specify at least one recipient.' => 'Debe especificar al menos un destinatario.',
	'Your [_1]\'s name, title, and a link to view it will be sent in the notification. Additionally, you can add a message, include an excerpt and/or send the entire body.' => 'En la notificación se enviará el nombre de su [_1], el título y un enlace para verla. Además, puede añadir un mensaje, incluir el resumen y/o enviar el cuerpo completo.',
	'Recipients' => 'Destinatarios',
	'Enter email addresses on separate lines or separated by commas.' => 'Introduzca las direcciones de correo en líneas separadas o separadas por comas.',
	'All addresses from Address Book' => 'Todas las direcciones de la agenda',
	'Optional Message' => 'Mensaje opcional',
	'Optional Content' => 'Contenido opcional',
	'(Body will be sent without any text formatting applied.)' => '(El cuerpo se enviará sin que se aplique ningún formato de texto).', # Translate - New
	'Send notification (s)' => 'Enviar notificación (s)',
	'Send' => 'Enviar',

## tmpl/cms/dialog/asset_options.tmpl
	'File Options' => 'Opciones de ficheros',
	'Create entry using this uploaded file' => 'Crear entrada utilizando el fichero transferido',
	'Create a new entry using this uploaded file.' => 'Crear una nueva entrada usando el fichero transferido.',
	'Finish (s)' => 'Finalizar (s)',
	'Finish' => 'Finalizar',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Confirm Publishing Configuration' => 'Confirmar configuración de publicación',
	'Site Path' => 'Ruta del sitio',
	'Parent Website' => 'Sitio web padre',
	'Please choose parent website.' => 'Por favor, seleccione el sitio web padre',
	'Use subdomain' => 'Usar subdominio', # Translate - New
	'Archive URL' => 'URL de archivos',
	'You must set a valid Site URL.' => 'Debe establecer una URL de sitio válida.',
	'You must set your Local Site Path.' => 'Debe definir la ruta local de su sitio.',
	'You must set a valid Local Site Path.' => 'Debe establecer una ruta local de sitio válida.',
	'You must select a parent website.' => 'Debe indicar un sitio web padre.',

## tmpl/cms/dialog/move_blogs.tmpl
	'Warning: You need to copy uploaded assets to the new path manually. It is also recommended not to delete files in the old path to avoid broken links.' => 'Aviso: Deberá copiar manualmente los ficheros multimedia subidos a la nueva ruta. También es recomendable que no borre los ficheros en la ruta antigua para evitar romper enlaces.',

## tmpl/cms/dialog/asset_options_image.tmpl
	'Display image in entry/page' => 'Mostrar una imagen en la entrada/página',
	'Alignment' => 'Alineación',
	'Left' => 'Izquierda',
	'Center' => 'Centro',
	'Right' => 'Derecha',
	'Use thumbnail' => 'Usar miniatura',
	'width:' => 'ancho:',
	'pixels' => 'píxeles',
	'Link image to full-size version in a popup window.' => 'Enlazar la versión original de la imagen en un popup.',
	'Remember these settings' => 'Recordar estas opciones',

## tmpl/cms/dialog/theme_element_detail.tmpl
	'Include in Theme: [_1]' => 'Incluir en el tema: [_1]',

## tmpl/cms/dialog/create_association.tmpl
	'No roles exist in this installation. [_1]Create a role</a>' => 'Ningún rol existe en esta instalación. [_1]Crear un rol</a>',
	'No groups exist in this installation. [_1]Create a group</a>' => 'Ningún grupo existe en esta instalación. [_1]Crear un grupo</a>',
	'No users exist in this installation. [_1]Create a user</a>' => 'Ningún usuario existe en esta instalación. [_1]Crear un usuario</a>',
	'No blogs exist in this installation. [_1]Create a blog</a>' => 'Ningún blog existe en esta instalación. [_1]Crear un blog</a>',

## tmpl/cms/dialog/restore_start.tmpl
	'Restoring...' => 'Restaurando...',

## tmpl/cms/dialog/select_theme.tmpl
	'Select Personal blog theme' => 'Seleccione un tema para el blog personal',
	'Apply' => 'Aplicar',

## tmpl/cms/dialog/clone_blog.tmpl
	'Verify Clone Blog Settings' => 'Verificar las opciones de clonación de blog',
	'Blog Details' => 'Detalles del blog',
	'This is set to the same URL as the original blog.' => 'Esto será la misma URL del blog original.',
	'This will overwrite the original blog.' => 'Esto sobreescribirá el blog original.',
	'Exclusions' => 'Exclusiones',
	'Exclude Entries/Pages' => 'Excluir entradas/páginas',
	'Exclude Comments' => 'Excluir comentarios',
	'Exclude Trackbacks' => 'Excluir trackbacks',
	'Exclude Categories/Folders' => 'Excluir categorías/carpetas',
	'Clone' => 'Clonar',
	'Clone Blog Settings' => 'Clonar configuración del blog',
	'Enter the new URL of your public website. Example: http://www.example.com/weblog/' => 'Introduzca la nueva URL del sitio web público. Ejemplo: http://www.ejemplo.com/weblog/',
	'Enter a new path where your main index file will be located. Example: /home/melody/public_html/weblog' => 'Introduzca una nueva ruta donde se situará el fichero índice principal. Ejemplo: /home/melody/public_html/weblog',
	'Mark the settings that you want cloning to skip' => 'Marque las opciones que desee ignorar en la clonación',
	'Entries/Pages' => 'Entradas/páginas',
	'Categories/Folders' => 'Categorías/carpetas',

## tmpl/cms/dialog/asset_insert.tmpl

## tmpl/cms/widget/favorite_blogs.tmpl
	'Your recent websites and blogs' => 'Blogs y sitios webs recientes', # Translate - New
	'[quant,_1,blog,blogs]' => '[quant,_1,blog,blogs]',
	'[quant,_1,page,pages]' => '[quant,_1,página,páginas]',
	'[quant,_1,comment,comments]' => '[quant,_1,comentario,comentarios]',
	'No website could be found. [_1]' => 'No se encontró el sitio web. [_1]',
	'Create a new' => 'Crear una nueva',
	'[quant,_1,entry,entries]' => '[quant,_1,entrada,entradas]',
	'No blog could be found.' => 'No se pudo encontrar ningún blog.',

## tmpl/cms/widget/recent_websites.tmpl

## tmpl/cms/widget/recent_blogs.tmpl
	'No blogs could be found. [_1]' => 'No se encontraron blogs. [_1]',

## tmpl/cms/widget/new_user.tmpl
	'Welcome to Movable Type, the world\'s most powerful blogging, publishing and social media platform:' => 'Bienvenido a Movable Type, la plataforma de blogs, publicación y social media más potente del mundo:',
	'Movable Type Online Manual' => 'Manual en línea de Movable Type',
	'Whether you\'re new to Movable Type or using it for the first time, learn more about what this tool can do for you.' => 'Tanto si es la primera vez que usa Movable Type, como si ya es un usuario con experiencia, aprenda qué es lo que puede hacer esta herramienta por usted.',

## tmpl/cms/widget/blog_stats_recent_entries.tmpl
	'[quant,_1,entry,entries] tagged &ldquo;[_2]&rdquo;' => '[quant,_1,entrada etiquetada,entradas etiquetadas] &ldquo;[_2]&rdquo;',
	'...' => '...',
	'Posted by [_1] [_2] in [_3]' => 'Publicado por [_1] [_2] en [_3]',
	'Posted by [_1] [_2]' => 'Publicado por [_1] [_2]',
	'Tagged: [_1]' => 'Etiquetas: [_1]',
	'View all entries' => 'Mostrar todas las entradas',
	'No entries available.' => 'Sin entradas disponibles.',

## tmpl/cms/widget/mt_news.tmpl
	'News' => 'Noticias',
	'MT News' => 'Noticias MT',
	'Learning MT' => 'Learning MT',
	'Hacking MT' => 'Hacking MT',
	'Pronet' => 'Pronet',
	'No Movable Type news available.' => 'No hay noticias de Movable Type disponibles.',
	'No Learning Movable Type news available.' => 'No hay noticias de Learning Movable Type disponibles.',

## tmpl/cms/widget/custom_message.tmpl
	'This is you' => 'Este es usted',
	'Welcome to [_1].' => 'Bienvenido a [_1].',
	'You can manage your blog by selecting an option from the menu located to the left of this message.' => 'Puede administrar su blog seleccionando una opción del menú situado a la izquierda de este mensaje.',
	'If you need assistance, try:' => 'Si necesita ayuda, consulte:',
	'Movable Type User Manual' => 'Manual del usuario de Movable Type',
	'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.com/movabletype/support',
	'Movable Type Technical Support' => 'Soporte técnico de Movable Type',
	'Movable Type Community Forums' => 'Foros comunitarios de Movable Type',
	'Save Changes (s)' => 'Guardar los cambios (s)',
	'Save Changes' => 'Guardar cambios',
	'Change this message.' => 'Cambiar este mensaje.',
	'Edit this message.' => 'Editar este mensaje.',

## tmpl/cms/widget/mt_shortcuts.tmpl
	'Handy Shortcuts' => 'Enlaces útiles',
	'Import Content' => 'Importar contenido',
	'Blog Preferences' => 'Preferencias del blog',

## tmpl/cms/widget/new_version.tmpl
	'What\'s new in Movable Type [_1]' => 'Novedades en Movable Type [_1]',

## tmpl/cms/widget/this_is_you.tmpl
	'Your <a href="[_1]">last entry</a> was [_2] in <a href="[_3]">[_4]</a>.' => 'La <a href="[_1]">última entrada</a> estaba [_2] en <a href="[_3]">[_4]</a>.',
	'Your last entry was [_1] in <a href="[_2]">[_3]</a>.' => 'Su última entrada fue [_1] en <a href="[_2]">[_3]</a>.',
	'You have <a href="[_1]">[quant,_2,draft,drafts]</a>.' => 'Tiene <a href="[_1]">[quant,_2,borrador,borradores]</a>.',
	'You have [quant,_1,draft,drafts].' => 'Tiene [quant,_1,borrador,borradores].',
	'You\'ve written <a href="[_1][_2]">[quant,_3,entry,entries]</a>, <a href="[_1][_4]">[quant,_5,page,pages]</a> with <a href="[_1][_6]">[quant,_7,comment,comments]</a>.' => 'Ha escrito <a href="[_1][_2]">[quant,_3,entrada,entradas]</a>, <a href="[_1][_4]">[quant,_5,página,páginas]</a> con <a href="[_1][_6]">[quant,_7,comentario,comentarios]</a>.',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, <a href="[_3]">[quant,_4,page,pages]</a> with [quant,_5,comment,comments].' => 'Ha escrito <a href="[_1]">[quant,_2,entrada,entradas]</a>, <a href="[_3]">[quant,_4,página,páginas]</a> con [quant,_5,comentario,comentarios].',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, [quant,_3,page,pages] with <a href="[_4]">[quant,_5,comment,comments]</a>.' => 'Ha escrito <a href="[_1]">[quant,_2,entrada,entradas]</a>, [quant,_3,página,páginas] con <a href="[_4]">[quant,_5,comentarios,comentarios]</a>.',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, [quant,_3,page,pages] with [quant,_4,comment,comments].' => 'Ha escrito <a href="[_1]">[quant,_2,entrada,entradas]</a>, [quant,_3,página,páginas] con [quant,_4,comentario,comentarios].',
	'You\'ve written [quant,_1,entry,entries], <a href="[_2]">[quant,_3,page,pages]</a> with <a href="[_4]">[quant,_5,comment,comments]</a>.' => 'Ha escrito [quant,_1,entrada,entradas], <a href="[_2]">[quant,_3,página,páginas]</a> con <a href="[_4]">[quant,_5,comentario,comentarios]</a>.',
	'You\'ve written [quant,_1,entry,entries], <a href="[_2]">[quant,_3,page,pages]</a> with [quant,_4,comment,comments].' => 'Ha escrito [quant,_1,entrada,entradas], <a href="[_2]">[quant,_3,página,páginas]</a> con [quant,_4,comentario,comentarios].',
	'You\'ve written [quant,_1,entry,entries], [quant,_2,page,pages] with <a href="[_3]">[quant,_4,comment,comments]</a>.' => 'Ha escrito [quant,_1,entrada,entradas], [quant,_2,página,páginas] con <a href="[_3]">[quant,_4,comentario,comentarios]</a>.',
	'You\'ve written [quant,_1,entry,entries], [quant,_2,page,pages] with [quant,_3,comment,comments].' => 'Ha escrito [quant,_1,entrada,entries], [quant,_2,página,páginas] con [quant,_3,comentario,comentarios].',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, <a href="[_3]">[quant,_4,page,pages]</a>.' => 'Ha escrito <a href="[_1]">[quant,_2,entrada,entradas]</a>, <a href="[_3]">[quant,_4,página,páginas]</a>.',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, [quant,_3,page,pages].' => 'Ha escrito <a href="[_1]">[quant,_2,entrada,entradas]</a>, [quant,_3,página,páginas].',
	'You\'ve written [quant,_1,entry,entries], <a href="[_2]">[quant,_3,page,pages]</a>.' => 'Ha escrito [quant,_1,entrada,entradas], <a href="[_2]">[quant,_3,página,páginas]</a>.',
	'You\'ve written [quant,_1,entry,entries], [quant,_2,page,pages].' => 'Ha escrito [quant,_1,entrada,entradas], [quant,_2,página,páginas].',
	'You\'ve written <a href="[_1]">[quant,_2,page,pages]</a> with <a href="[_3]">[quant,_4,comment,comments]</a>.' => 'Ha escrito <a href="[_1]">[quant,_2,página,páginas]</a> con <a href="[_3]">[quant,_4,comentario,comentarios]</a>.',
	'You\'ve written <a href="[_1]">[quant,_2,page,pages]</a> with [quant,_3,comment,comments].' => 'Ha escrito <a href="[_1]">[quant,_2,página,páginas]</a> con [quant,_3,comentario,comentarios].',
	'You\'ve written [quant,_1,page,pages] with <a href="[_2]">[quant,_3,comment,comments]</a>.' => 'Ha escrito [quant,_1,página,páginas] con <a href="[_2]">[quant,_3,comentario,comentarios]</a>.',
	'You\'ve written [quant,_1,page,pages] with [quant,_2,comment,comments].' => 'Ha escrito [quant,_1,página,páginas] con [quant,_2,comentario,comentarios].',
	'Edit your profile' => 'Edite su perfil',

## tmpl/cms/widget/new_install.tmpl
	'Thank you for installing Movable Type' => 'Gracias por instalar Movable Type',
	'You are now ready to:' => 'Ya está listo para:',
	'Create a new page on your website' => 'Cree una página nueva en el sitio web', # Translate - New
	'Create a blog on your website' => 'Cree un blog en el sitio web', # Translate - New
	'Create a blog (many blogs can exist in one website) to start posting.' => 'Crear un blog (pueden existir muchos blogs en un sitio web) para comenzar a publicar.',

## tmpl/cms/widget/blog_stats.tmpl
	'Error retrieving recent entries.' => 'Error obteniendo entradas recientes.',
	'Loading recent entries...' => 'Cargando entradas recientes',
	'Jan.' => 'Ene.',
	'Feb.' => 'Feb.',
	'July.' => 'Jul.',
	'Aug.' => 'Ago.',
	'Sept.' => 'Sep.',
	'Oct.' => 'Oct.',
	'Nov.' => 'Nov.',
	'Dec.' => 'Dic.',
	'[_1] [_2] - [_3] [_4]' => '[_1] [_2] - [_3] [_4]',
	'You have <a href=\'[_3]\'>[quant,_1,comment,comments] from [_2]</a>' => 'Tiene <a href=\'[_3]\'>[quant,_1,comentario,comentarios] de [_2]</a>',
	'You have <a href=\'[_3]\'>[quant,_1,entry,entries] from [_2]</a>' => 'Tiene <a href=\'[_3]\'>[quant,_1,entrada] de [_2]</a>',

## tmpl/cms/widget/blog_stats_entry.tmpl
	'Most Recent Entries' => 'Últimas entradas',
	'No entries have been created in this blog. <a href="[_1]">Create a entry</a>' => 'No se han creado entradas en este blog. <a href="[_1]">Crear una entrada</a>',

## tmpl/cms/widget/blog_stats_tag_cloud.tmpl

## tmpl/cms/widget/blog_stats_comment.tmpl
	'Most Recent Comments' => 'Últimos comentarios',
	'[_1] [_2], [_3] on [_4]' => '[_1] [_2], [_3] en [_4]',
	'View all comments' => 'Mostrar todos los comentarios',
	'No comments available.' => 'No hay comentarios disponibles',

## tmpl/cms/popup/rebuilt.tmpl
	'Success' => 'OK',
	'The files for [_1] have been published.' => 'Los ficheros de [_1] han sido publicados.',
	'Your [_1] has been published.' => 'Su [_1] se ha publicado.',
	'Your [_1] archives have been published.' => 'Se han publicado los archivos [_1].',
	'Your [_1] templates have been published.' => 'Se han publicado las plantillas [_1].',
	'Publish time: [_1].' => 'Tiempo de publicación: [_1].',
	'View your site.' => 'Ver sitio.',
	'View this page.' => 'Ver página.',
	'Publish Again (s)' => 'Publicar otra vez (s)',
	'Publish Again' => 'Publicar otra vez.',

## tmpl/cms/popup/pinged_urls.tmpl
	'Successful Trackbacks' => 'TrackBacks con éxito',
	'Failed Trackbacks' => 'TrackBacks sin éxito',
	'To retry, include these TrackBacks in the Outbound TrackBack URLs list for your entry.' => 'Para reintentarlo, incluya estos TrackBacks en la lista de URLs de TrackBacs salientes de la entrada.',

## tmpl/cms/popup/rebuild_confirm.tmpl
	'Publish [_1]' => 'Publicar [_1]',
	'Publish <em>[_1]</em>' => 'Publicar <em>[_1]</em>',
	'_REBUILD_PUBLISH' => 'Publicar',
	'All Files' => 'Todos los ficheros',
	'Index Template: [_1]' => 'Plantilla índice: [_1]',
	'Only Indexes' => 'Solamente índices',
	'Only [_1] Archives' => 'Solamente archivos [_1]',
	'Publish (s)' => 'Publicar (s)',

## tmpl/cms/edit_role.tmpl
	'Edit Role' => 'Editar rol',
	'Your changes have been saved.' => 'Sus cambios han sido guardados.',
	'List Roles' => 'Listar roles',
	'[quant,_1,User,Users] with this role' => '[quant,_1,User,Users] con este rol',
	'Useful links' => 'Enlaces útiles',
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'Ha cambiado los provilegios de este rol.  Esto va cambiar las posibilidades de maniobra de los usuarios asociados a este rol. Si usted prefiere, puede guardar este rol con otro nombre diferente.',
	'Role Details' => 'Detalles de los roles',
	'Created by' => 'Creado por',
	'Privileges' => 'Privilegios',
	'Administration' => 'Administración',
	'Authoring and Publishing' => 'Creación y publicación',
	'Designing' => 'Diseño',
	'Commenting' => 'Comentar',
	'Duplicate Roles' => 'Duplicar roles',
	'These roles have the same privileges as this role' => 'Estos roles tienen privilegios parecidos a este rol',
	'Save changes to this role (s)' => 'Guardar cambios en el rol (s)',

## tmpl/cms/edit_website.tmpl
	'Your blog configuration has been saved.' => 'Se ha guardado la configuración de su blog.',
	'Website Theme' => 'Tema del sitio web',
	'Select the theme you wish to use for this website.' => 'Seleccione el tema que desea usar en este sitio web.',
	'Name your website. The website name can be changed at any time.' => 'Nombre del sitio web. Puede modificarlo en cualquier momento.',
	'Website URL' => 'URL del sitio',
	'Enter the URL of your website. Exclude the filename (i.e. index.html). Example: http://www.example.com/weblog/' => 'Introduzca la URL del sitio web. Excluya el nombre del fichero (p.e. index.html). Ejemplo: http://www.ejemplo.com/weblog/',
	'Website Root' => 'Raíz del sitio web',
	'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/weblog' => 'Introduzca la ruta donde se situará el fichero índice principal. Se aconseja una ruta absoluta (que comienzan con \'/\'), pero también puede especificar una ruta relativa al directorio de Movable Type. Ejemplo: /home/melody/public_html/weblog',
	'Time Zone' => 'Zona horaria',
	'Select your timezone from the pulldown menu.' => 'Seleccione su zona horaria en el menú desplegable.',
	'Time zone not selected' => 'No hay ninguna zona horaria seleccionada.',
	'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (Nueva Zelanda, horario de verano)',
	'UTC+12 (International Date Line East)' => 'UTC+12 (Línea internacional de cambio de fecha, Este)',
	'UTC+11' => 'UTC+11',
	'UTC+10 (East Australian Time)' => 'UTC+10 (Hora de Australia Oriental)',
	'UTC+9.5 (Central Australian Time)' => 'UTC+9.5 (Hora de Australia Central)',
	'UTC+9 (Japan Time)' => 'UTC+9 (Hora del Japón)',
	'UTC+8 (China Coast Time)' => 'UTC+8 (Hora de la Costa China)',
	'UTC+7 (West Australian Time)' => 'UTC+7 (Hora de Australia Occidental)',
	'UTC+6.5 (North Sumatra)' => 'UTC+6.5 (Sumatra del Norte)',
	'UTC+6 (Russian Federation Zone 5)' => 'UTC+6 (Federación Rusa, zona 5)',
	'UTC+5.5 (Indian)' => 'UTC+5.5 (India)',
	'UTC+5 (Russian Federation Zone 4)' => 'UTC+5 (Federación Rusa, zona 4)',
	'UTC+4 (Russian Federation Zone 3)' => 'UTC+4 (Federación Rusa, zona 3)',
	'UTC+3.5 (Iran)' => 'UTC+3.5 (Irán)',
	'UTC+3 (Baghdad Time/Moscow Time)' => 'UTC+3 (Hora de Bagdad y Moscú)',
	'UTC+2 (Eastern Europe Time)' => 'UTC+2 (Hora de Europa Oriental)',
	'UTC+1 (Central European Time)' => 'UTC+1 (Hora de Europa Central)',
	'UTC+0 (Universal Time Coordinated)' => 'UTC+0 (Hora universal coordinada)',
	'UTC-1 (West Africa Time)' => 'UTC-1 (Hora de África Occidental)',
	'UTC-2 (Azores Time)' => 'UTC-2 (Hora de las Islas Azores)',
	'UTC-3 (Atlantic Time)' => 'UTC-3 (Hora del Atlántico)',
	'UTC-3.5 (Newfoundland)' => 'UTC-3.5 (Terranova)',
	'UTC-4 (Atlantic Time)' => 'UTC-4 (Hora del Atlántico)',
	'UTC-5 (Eastern Time)' => 'UTC-5 (Hora del Este de los Estados Unidos)',
	'UTC-6 (Central Time)' => 'UTC-6 (Hora del Centro de los Estados Unidos)',
	'UTC-7 (Mountain Time)' => 'UTC-7 (Hora de las Montañas Rocosas de los Estados Unidos)',
	'UTC-8 (Pacific Time)' => 'UTC-8 (Hora del Pacífico)',
	'UTC-9 (Alaskan Time)' => 'UTC-9 (Hora de Alaska)',
	'UTC-10 (Aleutians-Hawaii Time)' => 'UTC-10 (Hora de las Islas Aleutianas y Hawai)',
	'UTC-11 (Nome Time)' => 'UTC-11 (Hora de Nome)',
	'Blog language.' => 'Idioma del Blog.',
	'If you choose a different language than the default language defined at the system level, you may need to change module names in certain templates to include different global modules.' => 'Si desea un idioma diferente del idioma predefinido a nivel de sistema, deberá cambiar los nombres de los módulos en ciertas plantillas para incluir otros módulos globales.',
	'Create Website (s)' => 'Crear sitio web (s)',
	'You must set your Blog Name.' => 'Debe configurar el nombre del blog.',
	'You did not select a timezone.' => 'No seleccionó ninguna zona horaria.',

## tmpl/cms/cfg_plugin.tmpl
	'[_1] Plugin Settings' => 'Configuración de la extensión [_1]', # Translate - New
	'Find Plugins' => 'Buscar extensiones',
	'Plugin System' => 'Extensiones del sistema',
	'Enable or disable plugin functionality for the entire Movable Type installation.' => 'Activa o desactiva la funcionalidad de las extensiones para toda la instalación de Movable Type.',
	'Disable plugin functionality' => 'Desactivar las funciones de las extensiones',
	'Disable Plugins' => 'Desactivar extensiones',
	'Enable plugin functionality' => 'Activar las funciones de las extensiones',
	'Enable Plugins' => 'Activar extensiones',
	'Your plugin settings have been saved.' => 'Se guardó la configuración de la extensión.',
	'Your plugin settings have been reset.' => 'Se reinició la configuración de la extensión.',
	'Your plugins have been reconfigured. Since you\'re running mod_perl, you must restart your web server for these changes to take effect.' => 'Las extensiones se han reconfigurado. Dado que está ejecuntando mod_perl debe reiniciar el servidor web para que estos cambios tomen efecto.',
	'Your plugins have been reconfigured.' => 'Se reconfiguraron las extensiones.',
	'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => 'Se reconfiguraron las extensiones. Debido a que está ejecutando mod_perl, deberá reiniciar el servidor web para que estos cambios tengan efecto.',
	'Are you sure you want to reset the settings for this plugin?' => '¿Está seguro de que desea reiniciar la configuración de esta extensión?',
	'Are you sure you want to disable plugins for the entire Movable Type installation?' => '¿Está seguro de que desea desactivar las extensiones en toda la instalación de Movable Type?',
	'Are you sure you want to disable this plugin?' => '¿Está seguro de que desea desactivar esta extensión?',
	'Are you sure you want to enable plugins for the entire Movable Type installation? (This will restore plugin settings that were in place before all plugins were disabled.)' => '¿Está seguro de que desea activar las extensiones para toda la instalación de Movable Type? (Esto restaurará la configuración de las extensiones tal y como estaban cuando se desactivaron).',
	'Are you sure you want to enable this plugin?' => '¿Está seguro de que desea activar esta extensión?',
	'Settings for [_1]' => 'Configuración de [_1]',
	'Failed to Load' => 'Falló al cargar',
	'Disable' => 'Desactivar',
	'Enabled' => 'Activado',
	'Enable' => 'Activar',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be completely functional.' => 'Esta extensión no está actualizada para el soporte de Movable Type [_1]. Por lo tanto, podría no ser completamente funcional.',
	'Plugin error:' => 'Error de la extensión:',
	'Info' => 'Información',
	'Resources' => 'Recursos',
	'Run [_1]' => 'Ejecutar [_1]',
	'Documentation for [_1]' => 'Documentación sobre [_1]',
	'More about [_1]' => 'Más sobre [_1]',
	'Plugin Home' => 'Web de Extensiones',
	'Author of [_1]' => 'Autor de [_1]',
	'Tag Attributes:' => 'Atributos de etiquetas:',
	'Text Filters' => 'Filtros de texto',
	'Junk Filters:' => 'Filtros de basura:',
	'Reset to Defaults' => 'Reiniciar con los valores predefinidos',
	'No plugins with blog-level configuration settings are installed.' => 'No hay extensiones instaladas con configuración a nivel del sistema.',
	'No plugins with configuration settings are installed.' => 'Ningún plugin que haya sido configurado ha sido instalado.',

## tmpl/cms/list_blog.tmpl
	'Manage [_1]' => 'Administrar [_1]', # Translate - New
	'You have successfully deleted the website from the Movable Type system.' => 'Ha borrado con éxito el sitio web del sistema Movable Type.',
	'You have successfully deleted the blog from the website.' => 'Ha borrado con éxito el blog del sitio web.',
	'You have successfully refreshed your templates.' => 'Ha refrescado con éxito las plantillas.',
	'You have successfully moved selected blogs to another website.' => 'Ha trasladado con éxito los blogs seleccionados a otro sitio web.',
	'Warning: You need to copy uploaded assets to new locations manually. You should consider maintaining copies of uploaded assets in their original locations to avoid broken links.' => 'Aviso: Debe copiar manualmente los ficheros multimedia asociados a nueva ruta. Estudie mantener una copia de los ficheros en su lugar original para evitar romper enlaces.',
	'You can not refresh templates: [_1]' => 'No puede refrescar las plantillas: [_1]',
	'The website was not deleted. You need to delete blogs under the website.' => 'El sitio web no se borró. Debe borrar los blogs del sitio web.',
	'Create Blog' => 'Crear blog',

## tmpl/cms/cfg_system_users.tmpl
	'User Settings' => 'Configuración de usuarios', # Translate - New
	'Your settings have been saved.' => 'Configuración guardada.',
	'(No website selected)' => '(Ningún sitio web seleccionado)', # Translate - New
	'Select website' => 'Seleccione un sitio web',
	'(None selected)' => '(Ninguno seleccionado)',
	'User Registration' => 'Registro de usuarios',
	'Allow Registration' => 'Permitir registro',
	'Select a system administrator you wish to notify when commenters successfully registered themselves.' => 'Seleccione un administrar del sistema a quien desee que se le remitan notificaciones cuando los comentaristas se registren.',
	'Allow commenters to register with blogs on this system.' => 'Permitir a los comentaristas registrarse con blogs en el sistema.',
	'Notify the following system administrators when a commenter registers:' => 'Notificar a los siguientes administradores del sistema el registro de comentaristas:',
	'Select system administrators' => 'Seleccione los administradores de sistemas',
	'Clear' => 'Limpiar',
	'Note: System Email Address is not set in System > General Settings. Emails will not be sent.' => 'Nota: La dirección de correo del sistema no está configurada en Sistema > Configuración general. Los mensajes no se enviarán.',
	'New User Defaults' => 'Valores predefinidos para los nuevos usuarios',
	'Personal Blog' => 'Blog Personal',
	'Have the system automatically create a new personal blog when a user is created. The user will be granted the blog administrator role on this blog.' => 'Hace que el sistema cree automáticamente un blog personal al crear un nuevo usuario. El usuario obtendrá el rol de administrador en ese blog.',
	'Automatically create a new blog for each new user.' => 'Crear automáticamente un nuevo blog para cada nuevo usuario.',
	'Personal Blog Location' => 'Ruta del blog personal',
	'Select a website you wish to use as the location of new personal blogs.' => 'Seleccione el sitio web que desea usar como lugar de los nuevos blogs personales.',
	'Change website' => 'Cambiar sitio web',
	'Personal Blog Theme' => 'Tema del blog personal',
	'Select the theme that should be used for new personal blogs.' => 'Seleccione el tema que deberá usarse para los nuevos blogs personales.',
	'(No theme selected)' => '(Ningún tema seleccionado)', # Translate - New
	'Change theme' => 'Cambiar tema',
	'Select theme' => 'Seleccionar tema',
	'Default User Language' => 'Idioma del usuario',
	'Choose the default language to apply to all new users.' => 'Seleccione el idioma predefinido para aplicar en los nuevos usuarios.',
	'Default Time Zone' => 'Zona horaria predefinida',
	'Select your time zone from the pulldown menu.' => 'Seleccione la zona horaria del menú desplegable.',
	'Default Tag Delimiter' => 'Delimitador de etiquetas predefinido',
	'Define the default delimiter for entering tags.' => 'Seleccione el separador predefinido al introducir etiquetas.',
	'Comma' => 'Coma',
	'Space' => 'Espacio',
	'Save changes to these settings (s)' => 'Guardar cambios de estas opciones (s)',

## tmpl/cms/edit_template.tmpl
	'Edit Widget' => 'Editar widget',
	'Create Widget' => 'Crear widget',
	'Create Template' => 'Crear plantilla',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]">Recover auto-saved content</a>' => 'Se auto-guardó [_2] una versión guardada de [_1]. <a href="[_2]">Recuperar contenido auto-guardado</a>',
	'You have successfully recovered your saved [_1].' => 'Recuperó con éxito la versión guardada de [_1].',
	'An error occurred while trying to recover your saved [_1].' => 'Ocurrió un error intentando recuperar la versión guardada de [_1].',
	'Restored revision (Date:[_1]).' => 'Revisión restaurada (Fecha: [_1]).',
	'Your template changes have been saved.' => 'Se guardaron sus cambios en la plantilla.',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => '<a href="[_1]" class="rebuild-link">Publicar</a> esta plantilla.',
	'Revision: <strong>[_1]</strong>' => 'Revisión: <strong>[_1]</strong>',
	'View revisions of this template' => 'Ver revisiones de esta plantilla', # Translate - New
	'View revisions' => 'Ver revisiones',
	'No revision(s) associated with this template' => 'Ninguna revisión asociada a esta plantilla', # Translate - New
	'Useful Links' => 'Enlaces útiles',
	'Module Option Settings' => 'Configuración de opciones del módulo', # Translate - New
	'List [_1] templates' => 'Listar plantillas [_1]',
	'List all templates' => 'Listar todas las plantillas',
	'Included Templates' => 'Plantillas incluídas',
	'create' => 'crear',
	'Template Tag Docs' => 'Documentos sobre las etiquetas',
	'Unrecognized Tags' => 'Etiquetas no reconocidas',
	'Save (s)' => 'Guardar (s)',
	'Save and Publish this template (r)' => 'Guardar y publicar esta plantilla (r)',
	'Save &amp; Publish' => 'Guardar &amp; Publicar',
	'You have unsaved changes to this template that will be lost.' => 'Esta plantilla tiene cambios no guardados que se perderán.',
	'You must set the Template Name.' => 'Debe indicar el nombre de la plantilla.',
	'You must set the template Output File.' => 'Debe indicar el fichero de salida de la plantilla.',
	'Processing request...' => 'Procesando petición...',
	'Error occurred while updating archive maps.' => 'Ocurrió un error durante la actualización de los mapas de archivos.',
	'Archive map has been successfully updated.' => 'Se actualizaron con éxito los mapas de archivos.',
	'Are you sure you want to remove this template map?' => '¿Está seguro que desea borrar este mapa de plantilla?',
	'Module Body' => 'Cuerpo del módulo',
	'Template Body' => 'Cuerpo de la plantilla',
	'Template Options' => 'Opciones de plantillas',
	'Output file: <strong>[_1]</strong>' => 'Fichero de salida: <strong>[_1]</strong>',
	'Enabled Mappings: [_1]' => 'Habilitar mapas: [_1]',
	'Template Type' => 'Tipo de plantilla',
	'Custom Index Template' => 'Plantilla índice personalizada',
	'Link to File' => 'Enlazar a archivo',
	'Learn more about <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publishing settings</a>' => 'Más información sobre las <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">opciones de publicación</a>',
	'Create Archive Mapping' => 'Crear mapeado de archivos',
	'Server Side Include' => 'Server Side Include',
	'Process as <strong>[_1]</strong> include' => 'Procesar como inserción <strong>[_1]</strong>',
	'Include cache path' => 'Ruta de caché de inserciones',
	'Module Caching' => 'Caché de módulos',
	'Disabled (<a href="[_1]">change publishing settings</a>)' => 'Deshabilitado (<a href="[_1]">modificar configuración de la publicación</a>)',
	'No caching' => 'Sin caché',
	'Expire after' => 'Caduca tras',
	'Expire upon creation or modification of:' => 'Caduca tras la creación o modificación de:',
	'Change note' => 'Cambiar nota',
	'Auto-saving...' => 'Auto-guardando...',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Último guardado automático a las [_1]:[_2]:[_3]',

## tmpl/cms/dashboard.tmpl
	'Dashboard' => 'Panel de Control',
	'Hi, [_1]' => 'Hola, [_1]',
	'Select a Widget...' => 'Seleccione un widget...',
	'Your Dashboard has been updated.' => 'Se ha actualizado el Panel de Control.',
	'You have attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'Ha intentado usar una característica para la que no tiene permisos. Si cree que está viendo este mensaje por error, contacte con sus administrador del sistema.',
	'Support directory is not writable.' => 'No se puede escribir en el directorio de soporte.',
	'Detail' => 'Detalles',
	'Movable Type was unable to write to its \'support\' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.' => 'Movable Type no pudo escribir en el directorio \'support\'. Por favor, cree un directorio en este lugar: [_1], y asígnele permisos para permitir que el servidor web pueda acceder y escribir en él.',
	'Image::Magick is not configured.' => 'Image::Magick no está configurado.',
	'Image::Magick is either not present on your server or incorrectly configured. Due to that, you will not be able to use Movable Type\'s userpics feature. If you wish to use that feature, please install Image::Magick or use an alternative image driver.' => 'Image::Magick no está presente en el servidor o no está instalado correctamente. Por esa razón, no podrá usar los avatares de usuarios en Movable Type. Si desea utilizar esta característica, por favor, instale Image::Magick o algún controlador alternativo de imágenes.',

## tmpl/cms/edit_widget.tmpl
	'Edit Widget Set' => 'Editar widgets',
	'Create Widget Set' => 'Crear conjunto de widgets',
	'Your widget set changes have been saved.' => 'Se guardaron los cambios al conjunto de widgets.',
	'Widget Set Name' => 'Nombre del conjunto de widgets',
	'Drag and drop the widgets that belong in this Widget Set into the \'Installed Widgets\' column.' => 'Arrastre y suelte los widgets que pertenecen a este conjunto a la columna \'Widgets instalados\'.',
	'Installed Widgets' => 'Widgets instalados',
	'edit' => 'editar',
	'Available Widgets' => 'Widgets disponibles',
	'Save changes to this widget set (s)' => 'Guardar cambios de este conjunto de widgets (s)',
	'You must set Widget Set Name.' => 'Debe indicar un nombre para el conjunto de widgets.',

## tmpl/cms/list_entry.tmpl
	'Manage Entries' => 'Administrar entradas',
	'Entries Feed' => 'Sindicación de las entradas',
	'Pages Feed' => 'Sindicación de las páginas',
	'The entry has been deleted from the database.' => 'La entrada ha sido borrada de la base de datos.',
	'The page has been deleted from the database.' => 'La página ha sido borrada de la base de datos.',
	'Quickfilters' => 'Filtros rápidos',
	'[_1] (Disabled)' => '[_1] (Desactivado)',
	'Showing only: [_1]' => 'Mostrando solo: [_1]',
	'Remove filter' => 'Borrar filtro',
	'All [_1]' => 'Todos los/las [_1]',
	'change' => 'cambiar',
	'[_1] where [_2] is [_3]' => '[_1] donde [_2] es [_3]',
	'Show only entries where' => 'Mostrar solo las entradas donde',
	'Show only pages where' => 'Mostrar solo las páginas donde',
	'status' => 'estado',
	'tag (exact match)' => 'etiqueta (coincidencia exacta)',
	'tag (fuzzy match)' => 'etiqueta (coincidencia difusa)',
	'asset' => 'fichero multimedia',
	'is' => 'es',
	'published' => 'publicado',
	'unpublished' => 'no publicado',
	'review' => 'Revisar',
	'scheduled' => 'programado',
	'spam' => 'Spam',
	'Select A User:' => 'Seleccionar un usuario:',
	'User Search...' => 'Buscar usuario...',
	'Recent Users...' => 'Usuarios recientes...',
	'Filter' => 'Filtro',

## tmpl/cms/recover_password_result.tmpl
	'Recover Passwords' => 'Recuperar contraseñas',
	'No users were selected to process.' => 'No se seleccionaron usarios a procesar.',
	'Return' => 'Volver',

## tmpl/cms/edit_commenter.tmpl
	'Commenter Details' => 'Detalles del comentarista',
	'The commenter has been trusted.' => 'El comentarista ahora es de confianza.',
	'The commenter has been banned.' => 'Se bloqueó al comentarista.',
	'Comments from [_1]' => 'Comentarios de [_1]',
	'commenter' => 'comentarista',
	'commenters' => 'comentaristas',
	'Trust user (t)' => 'Confiar en usuario (t)',
	'Trust' => 'Confianza',
	'Untrust user (t)' => 'Desconfiar del usuario (t)',
	'Untrust' => 'Desconfiar',
	'Ban user (b)' => 'Bloquear usuario (b)',
	'Ban' => 'Bloquear',
	'Unban user (b)' => 'Desbloquear usuario (b)',
	'Unban' => 'Desbloquear',
	'The Name of the commenter' => 'El nombre del comentarista',
	'View all comments with this name' => 'Mostrar todos los comentarios con este nombre',
	'The Identity of the commenter' => 'La identidad del comentarista',
	'The Email of the commenter' => 'La dirección de correo del comentarista',
	'Withheld' => 'Retener',
	'View all comments with this email address' => 'Ver todos los comentarios de esta dirección de correo-e',
	'The URL of the commenter' => 'La URL del comentarista',
	'View all comments with this URL address' => 'Ver todos los comentarios con esta URL',
	'The trusted status of the commenter' => 'El estado de la confianza en el comentarista',
	'View all commenters' => 'Ver todos los comentaristas',

## tmpl/cms/cfg_registration.tmpl
	'Registration Settings' => 'Configuración de registro',
	'Your blog preferences have been saved.' => 'Las preferencias de su weblog han sido guardadas.',
	'Allow registration for this website.' => 'Permitir el registro en este sitio web.',
	'Registration Not Enabled' => 'Registro no activado',
	'Note: Registration is currently disabled at the system level.' => 'Nota: Actualmente el regisro está desactivado a nivel del sistema.',
	'Allow visitors to register as members of this website using one of the Authentication Methods selected below.' => 'Permitir a los visitantes registrarse como miembros del sitio web usando uno de los métodos de autentificación seleccionados debajo.',
	'Authentication Methods' => 'Métodos de autentificación',
	'Note: You have selected to accept comments from authenticated commenters only but authentication is not enabled. In order to receive authenticated comments, you must enable authentication.' => 'Nota: Seleccionó aceptar comentarios solo de comentaristas autentificados, pero la autentificación no está activada. Para recibir comentarios autentificados, debe activar la autentificación.',
	'Require E-mail Address for Comments via TypePad' => 'Requerir la dirección de correo de los comentarios a través de TypePad',
	'Visitors must allow their TypePad account to share their e-mail address when commenting.' => 'Los visitantes deben permitir a su cuenta de TypePad compartir la dirección de correo al comentar.',
	'One or more Perl modules may be missing to use this authentication method.' => 'Uno o más módulos de Perl podrían no estar instalados y ser necesarios para usar este método de autentificación.',
	'Setup TypePad authentication' => 'Configurar autentificación mediante TypePad',
	'on the Web Services Settings page.' => 'en la página de configuración de los servicios web.',
	'OpenID providers disabled' => 'Proveedores OpenID desactivados',
	'The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.' => 'El módulo de Perl necesario para la autentificación de comentaristas mendiante OpenID (Digest::SHA1) no está instalado.',

## tmpl/cms/theme_export_replace.tmpl
	'Export theme folder already exists \'[_1]\'. You can overwrite a existing theme, or cancel to change the Basename?' => 'La carpeta para la exportación del tema ya existe \'[_1]\'. Puede sobreescribir un tema existente, cancelar o cambiar el nombre de la carpeta.',
	'Overwrite' => 'Sobreescribir',

## tmpl/cms/list_theme.tmpl
	'[_1] Themes' => 'Temas de [_1]', # Translate - New
	'All Themes' => 'Todos los temas', # Translate - New
	'Theme [_1] has been uninstalled.' => 'El tema [_1] se ha desinstalado.',
	'Theme [_1] has been applied.' => 'El tema [_1] se ha aplicado.',
	'Failed' => 'Falló',
	'Current Theme' => 'Tema actual',
	'In Use' => 'En uso',
	'Uninstall' => 'Desinstalar',
	'Author: ' => 'Autor: ',
	'This theme cannot be applied to the website due to [_1] errors' => 'Este tema no puede aplicarse al sitio web debido a [_1] errores',
	'Errors' => 'Errores',
	'Warnings' => 'Avisos',
	'Theme Errors' => 'Errores de tema',
	'Theme Warnings' => 'Avisos de tema',
	'Portions of this theme cannot be applied to the website. [_1] elements will be skipped.' => 'Algunas partes de este tema no se pueden aplicar al sitio web. Se ignorarán [_1] elementos.',
	'Theme Information' => 'Información del tema',
	'No themes are installed.' => 'No hay temas instalados.',
	'Themes for Both Blogs and Websites' => 'Temas para blogs y sitios web',
	'Themes for Blogs' => 'Temas para blogs',
	'Themes for Websites' => 'Temas para sitios web',

## tmpl/cms/cfg_system_general.tmpl
	'A test email was sent.' => 'Se ha enviado un correo de prueba.',
	'System Email' => 'Correo del sistema',
	'This email address is used in the \'From:\' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, and a few other minor events.' => 'Esta dirección de correo se usa en la cabecera \'De:\' en los mensajes enviados por Movable Type. Se pueden enviar correos para la recuperación de contraseñas, el registro de comentaristas, notificaciones de comentarios y trackbacks y otros eventos menores.',
	'Debug Mode' => 'Modo de depuración',
	'Values other than zero provide additional diagnostic information for troubleshooting problems with your Movable Type installation.  More information is available in the <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">Debug Mode documentation</a>.' => 'Valores distintos a cero proveen información adicional de diagnóstico para la resolución de problemas en la instalación de Movable Type. Dispone de más información en la <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">documentación del modo de depuración</a>.',
	'Performance Logging' => 'Histórico de rendimiento',
	'Turn on performance logging, which will report any system event that takes the number of seconds specified below.' => 'Active el histórico de rendimiento para obtener información de cualquier evento del sistema que tome el número de segundos especificados abajo.',
	'Log Path' => 'Ruta de históricos',
	'The filesystem directory where performance logs are written.  The web server must have write permission in this directory.' => 'El directorio del sistema de ficheros donde se escriben los históricos de rendimiento. El servidor web debe poder escribir en este directorio.',
	'Logging Threshold' => 'Umbral de histórico',
	'The time limit for unlogged events in seconds. Any event that takes this amount of time or longer will be reported.' => 'El tiempo límite para los eventos no registrados, en segundos. Se informará de cualquier evento que tome esta cantidad de tiempo o mayor.',
	'Enable this setting to have Movable Type track revisions made by users to entries, pages and templates.' => 'Activar esta configuración para seguir las revisiones realizadas por los usuarios en las entradas, páginas y plantillas.',
	'Track revision history' => 'Seguir histórico de revisiones',
	'System-wide Feedback Controls' => 'Controles de las respuestas a nivel del sistema',
	'Prohibit Comments' => 'Prohibir comentarios',
	'This will override all individual blog settings.' => 'Esto va borrar los parámetros de todos los blogs individuales',
	'Disable comments for all blogs.' => 'Desactivar los comentarios para todos los blogs.',
	'Prohibit TrackBacks' => 'Prohibir TrackBacks',
	'Disable receipt of TrackBacks for all blogs.' => 'Desactivar el recibo de TrackBacks en todos los blogs.',
	'Outbound Notifications' => 'Notificaciones salientes',
	'Prohibit Notification Pings' => 'Prohibir los pings de notificación',
	'Disable sending notification pings when a new entry is created in any blog on the system.' => 'Desactivar el envío de pings de notificación cuando se crean nuevas entradas en cualquier blog del sistema.',
	'Disable notification pings for all blogs.' => 'Desactivar los pings de notificación en todos los blogs.',
	'Send Outbound TrackBacks to' => 'Enviar TrackBacks salientes a',
	'Do not send outbound TrackBacks or use TrackBack auto-discovery if your installation is intended to be private.' => 'No enviar TrackBacks salientes ni usar el autodescubrimiento de TrackBacks si predente que la instalación sea privada.',
	'Any site' => 'Cualquier sitio',
	'(No Outbound TrackBacks)' => '(Ningún Trackback saliente)',
	'Only to blogs within this system' => 'Solo a los blogs en este sistema',
	'Only to websites on the following domains:' => 'Solo a los sitios web en los siguientes dominios:',
	'Send Email To' => 'Enviar correo a',
	'The email address that should receive a test email from Movable Type.' => 'La direción de correo que debe recibir el correo de prueba de Movable Type.',

## tmpl/cms/view_rpt_log.tmpl
	'Schwartz Error Log' => 'Histórico de errores de Schwartz',
	'The activity log has been reset.' => 'Se reinició el registro de actividad.',
	'All times are displayed in GMT[_1].' => 'Todas las horas se muestran en GMT[_1].',
	'All times are displayed in GMT.' => 'Todas las fechas se muestran en GMT.',
	'Are you sure you want to reset the activity log?' => '¿Está seguro de querer reiniciar el registro de actividad?',
	'Showing all Schwartz errors' => 'Mostrando todos los errores de Schwartz',

## tmpl/cms/list_member.tmpl
	'Are you sure you want to remove the user from this role?' => '¿Está seguro de que desea borrar este rol?',
	'Add a user to this blog' => 'Añadir un usuario a este blog',
	'Add a user to this website' => 'Añadir un usuarioa a este sitio web',
	'Show only users where' => 'Mostrar solo los usuarios donde',
	'role' => 'rol',
	'enabled' => 'habilitado',
	'disabled' => 'deshabilitado',
	'pending' => 'Pendiente',

## tmpl/cms/export_theme.tmpl
	'Export [_1] Themes' => 'Exportar temas de [_1]', # Translate - New
	'Theme package have been saved.' => 'El paquete del tema se ha guardado.',
	'The name of your theme.' => 'El nombre del tema.',
	'Use letters, numbers, dash or underscore only (a-z, A-Z, 0-9, \'-\' or \'_\').' => 'Use exclusivamente letras, números, guiones o guiones bajos (a-z, A-Z, 0-9, \'-\' o \'_\').',
	'Version' => 'Versión', # Translate - New
	'A version number for this theme.' => 'Un número de versión de este tema.',
	'A description for this theme.' => 'Una descripción de este tema.',
	'_THEME_AUTHOR' => 'Autor', # Translate - New
	'The author of this theme.' => 'El autor de este tema.',
	'Author link' => 'Enlace del autor',
	'The author\'s website.' => 'El sitio web del autor.',
	'Options' => 'Opciones',
	'Additional assets to be included in the theme.' => 'Medios adicionales a incluir en el tema.',
	'Destination' => 'Destino', # Translate - New
	'Select How to get theme.' => 'Seleccione cómo obtener el tema.',
	'Setting for [_1]' => 'Configuración para [_1]',
	'You must set Theme Name.' => 'Debe indicar el nombre del tema.',
	'Basename may only contain letters, numbers, and the dash or underscore character. The basename must begin with a letter.' => 'El nombre base solo puede contener letras, números, y el guión o guión bajo. El nombre base debe comenzar con una letra.',
	'Cannot install new theme with existing (and protected) theme\'s basename.' => 'No se pudo instalar el nuevo tema con el nombre base existeinte (y protegido) del tema.', # Translate - New
	'You must set Author Name.' => 'Debe indicar el nombre del autor.',
	'Theme version may only contain letters, numbers, and the dash or underscore character.' => 'La versión del tema solo puede contener letras, números y el guión o guión bajo.',

## tmpl/cms/backup.tmpl
	'Backup [_1]' => 'Respaldar [_1]', # Translate - New
	'What to Backup' => 'Qué respaldar',
	'This option will backup Users, Roles, Associations, Blogs, Entries, Categories, Templates and Tags.' => 'Esta opción hará copias de seguridad de los Usuarios, Roles, Asociaciones, Blogs, Entradas, Categorías, Plantillas y Etiquetas.',
	'Everything' => 'Todo',
	'Choose websites...' => 'Seleccione sitios web...',
	'Archive Format' => 'Formato de archivo',
	'The type of archive format to use.' => 'El tipo de formato de archivo a usar.',
	'Don\'t compress' => 'No comprimir',
	'Target File Size' => 'Tamaño del fichero',
	'Approximate file size per backup file.' => 'Tamaño de fichero aproximado para cada fichero de la copia de seguridad.',
	'No size limit' => 'Sin límite de tamaño',
	'Make Backup (b)' => 'Hacer copia (b)',
	'Make Backup' => 'Hacer copia',

## tmpl/cms/edit_entry.tmpl
	'Create Page' => 'Crear página',
	'Add folder' => 'Añadir carpeta',
	'Add folder name' => 'Añadir nombre de carpeta',
	'Add new folder parent' => 'Añadir nueva carpeta raíz',
	'Preview this page (v)' => 'Vista previa de la página (v)',
	'Delete this page (x)' => 'Borrar esta página (x)',
	'View Page' => 'Ver página',
	'Create Entry' => 'Crear nueva entrada',
	'Add category' => 'Añadir categoría',
	'Add category name' => 'Añadir nombre de categoría',
	'Add new category parent' => 'Añadir categoría raíz',
	'Preview this entry (v)' => 'Vista previa de la entrada (v)',
	'Delete this entry (x)' => 'Borrar esta entrada (x)',
	'View Entry' => 'Ver entrada',
	'A saved version of this entry was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Se guardó automáticamente una versión de esta entrada [_2]. <a href="[_1]">Recuperar el contenido guardado</a>',
	'A saved version of this page was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Se guardó automáticamente una versión de esta página [_2]. <a href="[_1]">Recuperar el contenido guardado</a>',
	'This entry has been saved.' => 'Se guardó esta entrada.',
	'This page has been saved.' => 'Se guardó esta página.',
	'One or more errors occurred when sending update pings or TrackBacks.' => 'Ocurrieron uno o más errores durante el envío de pings o TrackBacks.',
	'_USAGE_VIEW_LOG' => 'Compruebe el error en el <a href="[_1]">Registro de actividad</a>.',
	'Your customization preferences have been saved, and are visible in the form below.' => 'Se guardaron los cambios en las preferencias y pueden verse en el siguiente formulario.',
	'Your changes to the comment have been saved.' => 'Se guardaron sus cambios al comentario.',
	'Your notification has been sent.' => 'Se envió su notificación.',
	'You have successfully recovered your saved entry.' => 'Ha recuperado con éxito la entrada guardada.',
	'You have successfully recovered your saved page.' => 'Ha recuperado con éxito la página guardada.',
	'An error occurred while trying to recover your saved entry.' => 'Ocurrió un error durante la recuperación de la entrada guardada.',
	'An error occurred while trying to recover your saved page.' => 'Ocurrió un error durante la recuperación de la página guardada.',
	'You have successfully deleted the checked comment(s).' => 'Eliminó correctamente los comentarios marcados.',
	'You have successfully deleted the checked TrackBack(s).' => 'Eliminó correctamente los TrackBacks marcados.',
	'Restored revision (Date:[_1]).  The current status is: [_2]' => 'Revisión restaurada (Fecha: [_1]).  El estado actual es:  [_2]',
	'Some of tags in the revision could not be loaded because they have been removed.' => 'Algunas de las etiquetas de esta revisión no se pueden cargar debido a que han sido eliminadas.',
	'Some [_1] in the revision could not be loaded because they have been removed.' => 'Algunos [_1] en la revisión no se pudieron cargar porque han sido eliminados.',
	'Change Folder' => 'Cambiar carpeta',
	'Unpublished (Spam)' => 'No publicado (Spam)',
	'View revisions of this [_1]' => 'Ver revisiones de este [_1]', # Translate - New
	'No revision(s) associated with this [_1]' => 'No hay revisiones de este [_1]', # Translate - New
	'[_1] - Created by [_2]' => '[_1] - Creado por [_2]',
	'[_1] - Published by [_2]' => '[_1] - Publicado por [_2]',
	'[_1] - Edited by [_2]' => '[_1] - Editado por [_2]',
	'Save Draft' => 'Guardar borrador',
	'Draft this [_1]' => 'En borrador esta [_1]',
	'Publish this [_1]' => 'Publicar esta [_1]',
	'Update' => 'Actualizar',
	'Update this [_1]' => 'Actualizar esta [_1]',
	'Unpublish' => 'Despublicar',
	'Unpublish this [_1]' => 'Despublicar esta [_1]',
	'Save this [_1]' => 'Guardar [_1]',
	'Publish On' => 'Publicado el',
	'Warning: If you set the basename manually, it may conflict with another entry.' => 'Atención: Si introduce el nombre base manualmente, podría entrar en conflicto con otra entrada.',
	'Warning: Changing this entry\'s basename may break inbound links.' => 'Atención: Si cambia el nombre base de la entrada, podría romper enlaces entrantes.',
	'Unpublished' => 'No publicado',
	'You must configure this blog before you can publish this entry.' => 'Debe configurar el blog antes de poder publicar esta entrada.',
	'You must configure this blog you before can publish this page.' => 'Debe configurar este blog antes de poder publicar esta página.',
	'You must configure this blog before you can publish this page.' => 'Debe configurar el blog antes de poder publicar esta página.',
	'close' => 'cerrar',
	'Accept' => 'Aceptar',
	'<a href="[_2]">[_1]</a>' => '<a href="[_2]">[_1]</a>',
	'View Previously Sent TrackBacks' => 'Ver TrackBacks enviados anteriormente',
	'Outbound TrackBack URLs' => 'URLs de TrackBacks salientes',
	'[_1] Assets' => '[_1] Medios',
	'Remove this asset.' => 'Eliminar este fichero multimedia.',
	'No assets' => 'Ningún fichero multimedia.', # Translate - New
	'You have unsaved changes to this entry that will be lost.' => 'Posee cambios no guardados en esta entrada que se perderán.',
	'You have unsaved changes to this page that will be lost.' => 'Posee cambios no guardados en esta página que se perderán.',
	'Enter the link address:' => 'Introduzca la dirección del enlace:',
	'Enter the text to link to:' => 'Introduzca el texto del enlace:',
	'Your entry screen preferences have been saved.' => 'Se guardaron las nuevas preferencias del editor de entradas.',
	'Are you sure you want to use the Rich Text editor?' => '¿Está seguro de que desea usar el editor con formato?',
	'Make primary' => 'Hacer primario',
	'Fields' => 'Campos',
	'Metadata' => 'Metadatos',
	'Reset display options' => 'Reiniciar opciones de visualización',
	'Reset display options to blog defaults' => 'Reiniciar opciones de visualización con los valores predefinidos del blog',
	'Reset defaults' => 'Reiniciar valores predefinidos',
	'This post was held for review, due to spam filtering.' => 'Esta entrada está retenida para su aprobación, debido al filtro antispam.',
	'This post was classified as spam.' => 'Esta entrada fue clasificada como spam.',
	'Spam Details' => 'Detalles de spam',
	'Score' => 'Puntuación',
	'Results' => 'Resultados',
	'Permalink:' => 'Enlace permanente:',
	'Share' => 'Compartir',
	'Format:' => 'Formato:',
	'(comma-delimited list)' => '(lista separada por comas)',
	'(space-delimited list)' => '(lista separada por espacios)',
	'(delimited by \'[_1]\')' => '(separado por \'[_1]\')',
	'Use <a href="http://blogit.typepad.com/">TypePad Bookmarklet</a> to post to Movable Type from social networks like Facebook.' => 'Utilice el <a href="http://blogit.typepad.com/">marcador de TypePad</a> para publicar a Movable Type desde redes sociales como Facebook.',
	'None selected' => 'Ninguna seleccionada',

## tmpl/cms/view_log.tmpl
	'Show only errors' => 'Mostrar solo los errores',
	'System Activity Log' => 'Registro de Actividad del Sistema',
	'Filtered' => 'Filtrado',
	'Filtered Activity Feed' => 'Sindicación de la actividad del filtrado',
	'Download Filtered Log (CSV)' => 'Descargar registro filtrado (CSV)',
	'Download Log (CSV)' => 'Descargar registro (CSV)',
	'Clear Activity Log' => 'Borrar el registro de actividad',
	'Showing all log records' => 'Mostrando todos los registros',
	'Showing log records where' => 'Mostrando los registros donde',
	'Show log records where' => 'Mostrar registros donde',
	'level' => 'nivel',
	'classification' => 'clasificación',
	'Security' => 'Seguridad',
	'Information' => 'Información',
	'Debug' => 'Depuración',
	'Security or error' => 'Seguridad o error',
	'Security/error/warning' => 'Seguridad/error/alarma',
	'Not debug' => 'No depuración',
	'Debug/error' => 'Depuración/error',

## tmpl/cms/list_author.tmpl
	'You have successfully disabled the selected user(s).' => 'Ha deshabilitado con éxito el/los usuario/s seleccionado/s.',
	'You have successfully enabled the selected user(s).' => 'Ha habilitado con éxito el/los usuario/s seleccionado/s.',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'Ha borrado con éxito el/los usuario/s seleccionado/s del sistema de Movable Type.',
	'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Enterprise.' => 'Este usuario borrado aún existe en el directorio externo. Como tal, aún podrán acceder a Movable Type Enterprise.',
	'You have successfully synchronized users\' information with the external directory.' => 'Sincronizó con éxito la información de los usuarios con el directorio externo.',
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => 'Algunos ([_1]) de los usuarios seleccionados no pudieron rehabilitarse porque ya no se encuentra en el directorio externo.',
	'An error occured during synchronization.  See the <a href=\'[_1]\'>activity log</a> for detailed information.' => 'Ocurrió un error durante la sincronización. Para información más detallada, consulte el <a href=\'[_1]\'>registro de actividad</a>.',
	'User properties' => 'Propiedades del usuario',
	'Enable selected users (e)' => 'Habilitar usuarios seleccionados (e)',
	'_USER_ENABLE' => 'Habilitado',
	'Disable selected users (d)' => 'Deshabilitar usuarios seleccionados (d)',
	'_USER_DISABLE' => 'Deshabilitar',
	'Showing All Users' => 'Mostrar Todos los Usuarios',
	'_NO_SUPERUSER_DISABLE' => 'No puede deshabilitarse porque es un administrador del sistema de Movable Type',

## tmpl/cms/refresh_results.tmpl
	'Template Refresh' => 'Refrescar plantilla',
	'No templates were selected to process.' => 'No se han seleccionado plantillas para procesar.',
	'Return to templates' => 'Volver a las plantillas',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Editar carpeta',
	'Your folder changes have been made.' => 'Se han realizado los cambios en la carpeta.',
	'Manage Folders' => 'Administrar carpetas',
	'Manage pages in this folder' => 'Administrar las páginas de esta carpeta',
	'You must specify a label for the folder.' => 'Debe especificar una etiqueta para la carpeta.',
	'Save changes to this folder (s)' => 'Guardar cambios de esta carpeta (s)',

## tmpl/cms/import_others.tmpl
	'Start title HTML (optional)' => 'HTML de comienzo de título (opcional)',
	'End title HTML (optional)' => 'HTML de final de título (opcional)',
	'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => 'Si el software desde el que va a importar no tiene un campo de título, puede usar esta opción para identificar un título dentro del cuerpo de la entrada.',
	'Default entry status (optional)' => 'Estado predefinido de las entradas (opcional)',
	'If the software you are importing from does not specify an entry status in its export file, you can set this as the status to use when importing entries.' => 'Si el software desde el que va a importar no especifica un estado para la entrada en su fichero de exportación, puede establecer éste como el estado a utilizar al importar las entradas.',
	'Select an entry status' => 'Seleccione un estado para las entradas',

## tmpl/cms/list_notification.tmpl
	'Manage [_1] Address Book' => 'Administrar agenda de direcciones de [_1]', # Translate - New
	'You have added [_1] to your address book.' => 'Ha añadido [_1] a su agenda de direcciones.',
	'You have successfully deleted the selected contacts from your address book.' => 'Ha borrado con éxito los contactos seleccionados de su agenda.',
	'Download Address Book (CSV)' => 'Descargar agenda de direcciones (CSV)',
	'contact' => 'contacto',
	'contacts' => 'contactos',
	'Create Contact' => 'Crear contacto',
	'Add Contact' => 'Añadir contacto',

## tmpl/cms/export.tmpl
	'Export Blog Entries' => 'Exportar entradas del blog', # Translate - New
	'You must select a blog to export.' => 'Debe seleccionar un blog para la exportación.',
	'_USAGE_EXPORT_1' => 'Exporta las entradas, comentarios y TrackBacks de un blog. La exportación no puede considerarse como una copia de seguridad <em>completa</em> del blog.',
	'Blog to Export' => 'Blog a exportar',
	'Select a blog for exporting.' => 'Seleccionar un blog para la exportación.',
	'Change blog' => 'Cambiar blog',
	'Select blog' => 'Seleccione blog',
	'Export Blog (s)' => 'Exportar blog (s)',
	'Export Blog' => 'Exportar blog',

## tmpl/cms/search_replace.tmpl
	'You must select one or more item to replace.' => 'Debe seleccionar uno o más elementos a reemplazar.',
	'Search Again' => 'Buscar de nuevo',
	'Case Sensitive' => 'Distinguir mayúsculas y minúsculas',
	'Regex Match' => 'Expresión regular',
	'Limited Fields' => 'Campos limitados',
	'Date Range' => 'Rango de fechas',
	'Reported as Spam?' => '¿Marcado como spam?',
	'Search Fields:' => 'Buscar campos:',
	'_DATE_FROM' => '_FECHA_DESDE EL',
	'_DATE_TO' => '_FECHA_AL',
	'Submit search (s)' => 'Buscar (s)',
	'Replace' => 'Reemplazar',
	'Replace Checked' => 'Reemplazar selección',
	'Successfully replaced [quant,_1,record,records].' => '[quanta,_1,registro reemplazado,registros reemplazados] con éxito.',
	'Showing first [_1] results.' => 'Primeros [_1] resultados.',
	'Show all matches' => 'Mostrar todos los resultados',
	'[quant,_1,result,results] found' => '[quant,_1,resultado]',

## tmpl/cms/edit_category.tmpl
	'Edit Category' => 'Editar categoría',
	'Your category changes have been made.' => 'Los cambios en la categoría se han guardado.',
	'Manage entries in this category' => 'Administrar las entradas de esta categorías',
	'You must specify a label for the category.' => 'Debe especificar un título para la categoría.',
	'_CATEGORY_BASENAME' => 'Nombre base',
	'This is the basename assigned to your category.' => 'El nombre base asignado a la categoría.',
	'Warning: Changing this category\'s basename may break inbound links.' => 'Cuidado: Cambiar el nombre base de la categoría podría romper los enlaces entrantes.',
	'Inbound TrackBacks' => 'TrackBacks entradas',
	'If enabled, TrackBacks will be accepted for this category from any source.' => 'Si se habilita, en esta categoría se aceptarán los TrackBacks de cualquier fuente.',
	'View TrackBacks' => 'Ver TrackBacks',
	'TrackBack URL for this category' => 'URL de TrackBack para esta categoría',
	'_USAGE_CATEGORY_PING_URL' => 'Esta es la URL que usuarán otros para enviar TrackBacks a su weblog. Si desea que cualquiera envíe TrackBacks a su weblog cuando escriban una entrada sobre esta categoría, haga pública esta URL. Si desea que sólo un grupo selecto de personas le hagan TrackBack, envíeles la URL de forma privada. Para incluir una lista de TrackBacks en la plantilla índice principal, compruebe la documentación de las etiquetas de plantilla relacionadas con los TrackBacks.',
	'Passphrase Protection' => 'Protección por contraseña',
	'Outbound TrackBacks' => 'TrackBacks salientes',
	'Trackback URLs' => 'URLs de Trackback',
	'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you create an entry in this category. (Separate URLs with a carriage return.)' => 'Introduzca las URLs de los webs  a los que quiere enviar un TrackBack cada vez que cree una entrada en esta categoría. (Separe las URLs con un retorno de carro).',
	'Save changes to this category (s)' => 'Guardar cambios de esta categoría (s)',

## tmpl/cms/preview_strip.tmpl
	'Return to the compose screen' => 'Regresar a la ventana de composición',
	'Return to the compose screen (e)' => 'Regresar a la ventana de composición (e)',
	'You are previewing the entry entitled &ldquo;[_1]&rdquo;' => 'Está en la vista previa de la entrada titulada &ldquo;[_1]&rdquo;',
	'You are previewing the page entitled &ldquo;[_1]&rdquo;' => 'Está en la vista previa de la página titulada &ldquo;[_1]&rdquo;',

## tmpl/cms/list_banlist.tmpl
	'IP Banning Settings' => 'Bloqueo de IPs',
	'IP addresses' => 'Direcciones IP',
	'Delete selected IP Address (x)' => 'Borrar la dirección IP seleccionada (x)',
	'You have added [_1] to your list of banned IP addresses.' => 'Agregó [_1] a su lista de direcciones IP bloqueadas.',
	'You have successfully deleted the selected IP addresses from the list.' => 'Eliminó correctamente las direcciones IP seleccionadas.',
	'Ban IP Address' => 'Bloquear la dirección IP',
	'Date Banned' => 'Fecha de bloqueo',

## tmpl/cms/list_ping.tmpl
	'Manage TrackBacks' => 'Administrar TrackBacks',
	'The selected TrackBack(s) has been approved.' => 'Se han aprobado los TrackBacks seleccionados.',
	'All TrackBacks reported as spam have been removed.' => 'Se han elimitado todos los TrackBacks marcadoscomo spam.',
	'The selected TrackBack(s) has been unapproved.' => 'Se han desaprobado los TrackBacks seleccionados.',
	'The selected TrackBack(s) has been reported as spam.' => 'Se han marcado como spam los TrackBacks seleccionados.',
	'The selected TrackBack(s) has been recovered from spam.' => 'Se han recuperado del spam los TrackBacks seleccionados.',
	'The selected TrackBack(s) has been deleted from the database.' => 'Se eliminaron de la base de datos los TrackBacks seleccionados.',
	'No TrackBacks appeared to be spam.' => 'Ningún TrackBacks parece ser spam.',
	'Show only [_1] where' => 'Mostrar solo [_1] donde',
	'approved' => 'autorizado',
	'unapproved' => 'no aprobado',

## tmpl/cms/error.tmpl
	'An error occurred' => 'Ocurrió un error',

## tmpl/cms/cfg_entry.tmpl
	'Compose Settings' => 'Configuración de la composición',
	'Your preferences have been saved.' => 'Se han guardado las preferencias.',
	'Publishing Defaults' => 'Valores predefinidos de publicación',
	'Listing Default' => 'Valor predefinido de las listas',
	'Select the number of days of entries or the exact number of entries you would like displayed on your blog.' => 'Seleccione el número de días de entradas o el número exacto de entradas que desea mostrar en el blog.',
	'Days' => 'Días',
	'Posts' => 'Entradas',
	'Order' => 'Orden',
	'Select whether you want your entries displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Seleccione si quiere mostrar las entradas en orden ascendente (antiguas primero) o descendente (recientes primero).',
	'Ascending' => 'Ascendente',
	'Descending' => 'Descendente',
	'Excerpt Length' => 'Tamaño del resumen',
	'Enter the number of words that should appear in an auto-generated excerpt.' => 'Teclee el número de palabras que desea mostrar en el resumen autogenerado.',
	'Date Language' => 'Idioma de la fecha',
	'Select the language in which you would like dates on your blog displayed.' => 'Seleccione el idioma en el que desea que se visualicen las fechas en su weblog.',
	'Czech' => 'Checo',
	'Danish' => 'Danés',
	'Dutch' => 'Holandés',
	'English' => 'Inglés',
	'Estonian' => 'Estonio',
	'French' => 'Francés',
	'German' => 'Alemán',
	'Icelandic' => 'Islandés',
	'Italian' => 'Italiano',
	'Japanese' => 'Japonés',
	'Norwegian' => 'Noruego',
	'Polish' => 'Polaco',
	'Portuguese' => 'Portugués',
	'Slovak' => 'Eslovaco',
	'Slovenian' => 'Esloveno',
	'Spanish' => 'Español',
	'Suomi' => 'Suomi',
	'Swedish' => 'Sueco',
	'Basename Length' => 'Longitud del nombre base',
	'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => 'Especifique la longitud predefinida de los nombres base autogenerados. El rango para esta opción es de entre 15 y 250.',
	'Compose Defaults' => 'Valores predefinidos de composición',
	'Specifies the default Post Status when creating a new entry.' => 'Especifica el estado predefinido de publicación al crear una nueva entrada.',
	'Text Formatting' => 'Formato del texto',
	'Specifies the default Text Formatting option when creating a new entry.' => 'Especifica el formato de texto predeterminado para las entradas nuevas.',
	'Specifies the default Accept Comments setting when creating a new entry.' => 'Indica el valor predefinido para la opción Aceptar comentarios al crear nuevas entradas.',
	'Setting Ignored' => 'Opción ignorada',
	'Note: This option is currently ignored since comments are disabled either blog or system-wide.' => 'Nota: Actualmente, se ignora esta opción ya que los comentarios están desactivados en el blog o en todo el sistema.',
	'Accept TrackBacks' => 'Aceptar TrackBacks',
	'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Indica el valor predefinido de la opción Aceptar TrackBacks al crear nuevas entradas.',
	'Note: This option is currently ignored since TrackBacks are disabled either blog or system-wide.' => 'Nota: Actualmente, se ignora esta opción ya que los TrackBacks están desactivados en el blog o en todo el sistema.',
	'Entry Fields' => 'Campos de entrada',
	'_USAGE_ENTRYPREFS' => 'Seleccione el conjunto de campos que se mostrarán en el editor de entradas.',
	'Page Fields' => 'Campos de página',
	'Punctuation Replacement' => 'Reemplazo de puntuación',
	'Replace UTF-8 characters frequently used by word processors with their more common web equivalents.' => 'Remplace los carácteres UTF-8 más usados frecuentemente por el porcesador de texto por sus equivalentes más comunes en la web.',
	'No substitution' => 'Sin sustitución',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'Entidades de caracteres (&amp#8221;, &amp#8220;, etc.)',
	'ASCII equivalents (&quot;, \', ..., -, --)' => 'Equivalentes ASCII (&quot;, \', ..., -, --)',
	'Replace Fields' => 'Reemplazar campos',

## tmpl/cms/list_role.tmpl
	'Manage Roles' => 'Administrar roles', # Translate - New
	'You have successfully deleted the role(s).' => 'Ha borrado con éxito el/los rol/es.',
	'roles' => 'roles',
	'_USER_STATUS_CAPTION' => 'estado',
	'Members' => 'Miembros',
	'Role Is Active' => 'Rol activo',
	'Role Not Being Used' => 'Rol en desuso',

## tmpl/cms/cfg_prefs.tmpl
	'Error: Movable Type was not able to create a directory for publishing your blog. If you create this directory yourself, grant write permission to the web server.' => 'Error: Movable Type no pudo crear un directorio para publicar el blog. Si crea el directorio usted mismo, asegúrese de dar permisos de escritura al servidor web.',
	'[_1] Settings' => 'Configuración de [_1]',
	'Name your blog. The name can be changed at any time.' => 'El nombre del blog. Puede cambiarlo en cualquier momento.',
	'Enter a description for your blog.' => 'Introduzca una descripción para su blog.',
	'License' => 'Licencia',
	'Your blog is currently licensed under:' => 'Su blog actualmente tiene la licencia:',
	'Change license' => 'Cambiar licencia',
	'Remove license' => 'Borrar licencia',
	'Your blog does not have an explicit Creative Commons license.' => 'Su blog no tiene una licencia explícica de Creative Commons.',
	'Select a license' => 'Seleccionar una licencia',
	'Publishing Paths' => 'Rutas de publicación',
	'Warning: Changing the site URL can result in breaking all the links in your blog.' => 'Aviso: La modificación de la URL del sitio puede romper los enlaces que referencian al blog.',
	'The URL of your blog. Exclude the filename (i.e. index.html). End with \'/\'. Example: http://www.example.com/blog/' => 'La URL del blog. Excluya el nombre del fichero (p.e. index.html). Finalice con \'/\'. Ejemplo: http://www.ejemplo.com/blog/',
	'The URL of your website. Exclude the filename (i.e. index.html).  End with \'/\'. Example: http://www.example.com/' => 'La URL del sitio web. Excluya el nombre del fichero (p.e. index.html). Finalice con \'/\'. Ejemplo: http://www.ejemplo.com/',
	'Note: Changing your site root requires a complete publish of your site.' => 'Nota: La modificación de la raíz del sitio requiere la publicación completa del sitio.',
	'The path where your index files will be published. Do not end with \'/\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog' => 'La ruta donde se publicarán los ficheros índices. No finalice con \'/\'.  Ejemplo: /home/mt/public_html/blog o C:\www\public_html\blog',
	'The path where your index files will be published. An absolute path (starting with \'/\' for Linux or \'C:\' for Windows) is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/mt/public_html or C:\www\public_html' => 'La ruta donde se publicarán los ficheros índices. Se recomienda una ruta absoluta (en Linux comienzan por \'/\' y en Windows por \'C:\'), pero también puede usar una ruta relativa al directorio de Movable Type. Ejemplo: /home/mt/public_html o C:\www\public_html', # Translate - New
	'Advanced Archive Publishing' => 'Publicación avanzada de archivos',
	'Select this option only if you need to publish your archives outside of your Site Root.' => 'Seleccione esta opción solo si necesita publicar sus archivos fuera de la raíz de su sitio.',
	'Publish archives outside of Site Root' => 'Publicar archivos fuera de la raíz del sitio.',
	'Enter the URL of the archives section of your blog. Example: http://www.example.com/blog/archives/' => 'Introduzca la URL de la sección de archivos del blog. Ejemplo: http://www.ejemplo.com/blog/archives/',
	'Warning: Changing the archive URL can result in breaking all the links in your blog.' => 'Aviso: La modificación de la URL de archivos pueden romper todos los enlaces en el blog.',
	'Enter the path where your archive files will be published. Example: /home/mt/public_html/blog/archives or C:\www\public_html\blog\archives' => 'Introduzca la ruta donde se publicarán los ficheros de los archivos. Ejemplo: /home/mt/public_html/blog/archivos o C:\www\public_html\blog\archivos',
	'Warning: Changing the archive path can result in breaking all the links in your blog.' => 'Aviso: La modificación de la ruta de los archivos puede romper todos los enlaces en su blog.',
	'Asynchronous Job Queue' => 'Cola de trabajos asíncrona',
	'Use Publishing Queue' => 'Usar cola de publicación',
	'Requires the use of a cron job or a scheduled task on your server to publish pages in the background.' => 'Para publicar las páginas en segundo plano necesita usar una tarea del cron o una tarea programada en el servidor.',
	'Use background publishing queue for publishing static pages for this blog' => 'Usar la cola de publicación en segundo plano para la publicación de páginas estáticas en este blog.',
	'Dynamic Publishing Options' => 'Opciones de la publiación dinámica',
	'Enable dynamic cache' => 'Activar caché dinámica',
	'Enable conditional retrieval' => 'Activar recuperación condicional',
	'Archive Options' => 'Opciones de archivos',
	'File Extension' => 'Extensión de ficheros',
	'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'Introduzca la extensión de los archivos. Puede ser \'html\', \'shtml\', \'php\', etc. Nota: No introduzca el punto separador de la extensión (\'.\').',
	'Preferred Archive' => 'Archivo preferido',
	'Used to generate URLs (permalinks) for this blog\'s archived entries. Choose one of the archives type used in this blog\'s archive templates.' => 'Utilizado para generar las URLs (enlaces permanentes) de las entradas archivadas del blog. Seleccione uno de los tipos de archivos utilizandos en las plantillas de archivos del blog.',
	'No archives are active' => 'No hay archivos activos',
	'Module Options' => 'Opciones de módulos',
	'Server Side Includes' => 'Server Side Includes',
	'None (disabled)' => 'Ninguno (deshabilitado)',
	'PHP Includes' => 'Inclusiones PHP',
	'Apache Server-Side Includes' => 'Inclusiones de Apache',
	'Active Server Page Includes' => 'Inclusiones de páginas Active Server',
	'Java Server Page Includes' => 'Inclusiones de páginas Java Server',
	'Allow properly configured template modules to be cached to enhance publishing performance.' => 'Permite que los módulos de plantillas configurados como tal se cacheen para mejorar el rendimiento de la publicación.',
	'Note: Revision History is currently disabled at the system level.' => 'Nota: Actualmente, el histórico de revisiones está desactivado a nivel del sistema.',
	'Revision history' => 'Histórico de revisiones',
	'Enable revision history' => 'Activar histórico de revisiones',
	'Number of revisions per entry/page' => 'Número de revisiones por entrada/página',
	'Number of revisions per page' => 'Número de revisiones por página',
	'Number of revisions per template' => 'Número de revisiones por plantilla',
	'You did not select a time zone.' => 'No seleccionó una zona horaria.',
	'You must set a valid Archive URL.' => 'Debe indicar una URL de archivos válida.',
	'You must set Local Archive Path.' => 'Debe indicar la ruta local de archivos.',
	'You must set a valid Local Archive Path.' => 'Debe indicar una ruta local de archivos válida.',

## tmpl/cms/preview_template_strip.tmpl
	'You are previewing the template named &ldquo;[_1]&rdquo;' => 'Esta es la vista previa de la plantilla &ldquo;[_1]&rdquo;',
	'(Publish time: [_1] seconds)' => '(Tiempo de publicación: [_1] segundos)',
	'Return to the template editor (e)' => 'Regresar al editor de plantillas (e)',
	'Return to the template editor' => 'Regresar al editor de plantillas',

## tmpl/cms/list_comment.tmpl
	'Manage Comments' => 'Administrar comentarios',
	'The selected comment(s) has been approved.' => 'Se ha aprobado los comentarios seleccionados.',
	'All comments reported as spam have been removed.' => 'Se ha borrado los comentarios marcados como spam.',
	'The selected comment(s) has been unapproved.' => 'Se ha desaprobado los comentarios seleccionados.',
	'The selected comment(s) has been reported as spam.' => 'Se ha marcado como spam los comentarios seleccionados.',
	'The selected comment(s) has been recovered from spam.' => 'Se ha recuperado del spam los comentarios seleccionados.',
	'The selected comment(s) has been deleted from the database.' => 'Los comentarios seleccionados fueron eliminados de la base de datos.',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be Banned or Trusted.' => 'Uno o más comentarios de los que seleccionó fueron enviados por un comentarista no autentificado. No se puede bloquear o dar confianza a estos comentaristas.',
	'No comments appeared to be spam.' => 'Ningún comentario parece ser spam.',
	'[_1] on entries created within the last [_2] days' => '[_1] en entradas creadas en los últimos [_2] días',
	'[_1] on entries created more than [_2] days ago' => '[_1] en entradas creadas hace más de [_2] días',

## tmpl/cms/edit_ping.tmpl
	'Edit Trackback' => 'Editar TrackBack',
	'The TrackBack has been approved.' => 'Se aprobó el TrackBack.',
	'Save changes to this TrackBack (s)' => 'Guardar cambios de este TrackBack (s)',
	'Delete this TrackBack (x)' => 'Borrar este TrackBack (x)',
	'Update the status of this TrackBack' => 'Actualizar el estado del TrackBack',
	'Approved' => 'Autorizado',
	'Unapproved' => 'No aprobado',
	'Reported as Spam' => 'Marcado como spam',
	'Junk' => 'Basura',
	'View all TrackBacks with this status' => 'Ver TrackBacks con este estado',
	'Total Feedback Rating: [_1]' => 'Puntuación total de respuestas: [_1]',
	'Source Site' => 'Sitio de origen',
	'Search for other TrackBacks from this site' => 'Buscar otros TrackBacks en este sitio',
	'Source Title' => 'Título de origen',
	'Search for other TrackBacks with this title' => 'Buscar otros TrackBacks con este título',
	'Search for other TrackBacks with this status' => 'Buscar otros TrackBacks con este estado',
	'Target Entry' => 'Entrada destinataria',
	'Entry no longer exists' => 'La entrada ya no existe.',
	'No title' => 'Sin título',
	'View all TrackBacks on this entry' => 'Mostrar todos los TrackBacks de esta entrada',
	'Target Category' => 'Categoría de destinación ',
	'Category no longer exists' => 'Ya no existe la categoría',
	'View all TrackBacks on this category' => 'Mostrar todos los TrackBacks de esta categoría',
	'View all TrackBacks created on this day' => 'Mostrar todos los TrackBacks creados este día',
	'View all TrackBacks from this IP address' => 'Mostrar todos los TrackBacks enviados desde esta dirección IP',
	'TrackBack Text' => 'Texto del TrackBack',
	'Excerpt of the TrackBack entry' => 'Resumen de la entrada del TrackBack',

## tmpl/cms/cfg_web_services.tmpl
	'Web Services Settings' => 'Configuración de los servicios web',
	'Web Services from Six Apart' => 'Servicios web de Six Apart',
	'Your TypePad token is used to access services from Six Apart like TypePad Connect and TypePad AntiSpam.' => 'El token de TypePad se utiliza para acceder a servicios de Six Apart, como TypePad Connect y TypePad AntiSpam.',
	'TypePad is enabled.' => 'TypePad está activado.',
	'TypePad token:' => 'Token de TypePad:',
	'Clear TypePad Token' => 'Borrar token de TypePad',
	'Please click the Save Changes button below to disable authentication.' => 'Por favor, haga clic en el botón Guardar cambios para desactivar la autentificación.',
	'TypePad is not enabled.' => 'TypePad no está activado.',
	'&nbsp;or&nbsp;[_1]obtain a TypePad token[_2] from TypePad.com.' => '&nbsp;u&nbsp;[_1]obtenga un token de TypePad[_2] desde TypePad.com.',
	'Please click the \'Save Changes\' button below to enable TypePad.' => 'Por favor, para activar TypePad haga clic en el botón \'Guardar cambios\' de abajo.',
	'External Notifications' => 'Notificaciones externas',
	'Notify ping services of website updates' => 'Notifique las actualizaciones del sitio web a los servicios de ping',
	'When this website is updated, Movable Type will automatically notify the selected sites.' => 'Cuando se actualice el sitio web, Movable Type notificará automáticamente a los servicios seleccionados.',
	'Note: This option is currently ignored because outbound notification pings are disabled system-wide.' => 'Nota: Actualmente se ignora esta opción debido a que los pings de notificación salientes están desactivados a nivel del sistema.',
	'Others:' => 'Otros:',
	'(Separate URLs with a carriage return.)' => '(Separe las URLs con un retorno de carro.)',
	'Recently Updated Key' => 'Clave actualizada recientemente',
	'If you received a Recently Updated Key with the purchase of a Movable Type license, enter it here.' => 'Si ha recibido una Clave de Actualizaciones Recientes con la compra de una licencia de Movable Type, introdúzcala aquí.',

## tmpl/cms/list_template.tmpl
	'Manage [_1] Templates' => 'Administrar plantillas de [_1]', # Translate - New
	'Show All Templates' => 'Mostrar todas las plantillas',
	'Publishing Settings' => 'Configuración de publicación',
	'You have successfully deleted the checked template(s).' => 'Se eliminaron correctamente las plantillas marcadas.',
	'Your templates have been published.' => 'Se han publicado las plantillas.',
	'Selected template(s) has been copied.' => 'Se han publicado las plantillas seleccionadas.',

## tmpl/cms/list_tag.tmpl
	'Your tag changes and additions have been made.' => 'Se han realizado los cambios y añadidos a las etiquetas especificados.',
	'You have successfully deleted the selected tags.' => 'Se borraron con éxito las etiquetas especificadas.',
	'tag' => 'etiqueta',
	'tags' => 'etiquetas',
	'Specify new name of the tag.' => 'Nuevo nombre especifíco de la etiqueta',
	'Tag Name' => 'Nombre de la etiqueta',
	'Click to edit tag name' => 'Haga clic para editar el nombre de la etiqueta',
	'Rename [_1]' => 'Renombrar [_1]',
	'Rename' => 'Renombrar',
	'Show all [_1] with this tag' => 'Mostrar todas las [_1] con esta etiqueta',
	'[quant,_1,_2,_3]' => '[quant,_1,_2,_3]',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all blogs?' => 'La etiqueta \'[_2]\' ya existe.  ¿Está seguro de querer combinar \'[_1]\' con \'[_2]\' en todos los blogs?',
	'An error occurred while testing for the new tag name.' => 'Ocurrió un error mientras se probaba el nuevo nombre de la etiqueta.',

## tmpl/cms/install.tmpl
	'Create Your Account' => 'Crear Cuenta',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'La versión de Perl instalada en su servidor ([_1]) es menor que la versión mínima soporta ([_2]).',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Aunque Movable Type podría ejecutarse, <strong>esta configuración no está probada ni ni soportada</strong>.  Le recomendamos que actualice Perl a la versión [_1].',
	'Do you want to proceed with the installation anyway?' => '¿Aún así desea proceder con la instalación?',
	'View MT-Check (x)' => 'Ver MT-Check (x)',
	'Please create an administrator account for your system. When you are done, Movable Type will initialize your database.' => 'Por favor, cree una cuenta de administrar para el sistema. Cuando haya finalizado, Movable Type inicializará la base de datos.',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Para proceder, debe autentificarse correctamente en su servidor LDAP.',
	'The name used by this user to login.' => 'El nombre utilizado por este usario para iniciar su sesión.',
	'The name used when published.' => 'El nombre utilizado al publicar.',
	'The user&rsquo;s email address.' => 'La dirección de correo electrónico del usuario',
	'The email address used in the From: header of each email sent from the system.' => 'La dirección de correousada en la cabecera De: de los correos enviados por el sistema.',
	'Use this as system email address' => 'Usar esta dirección de correo para el sistema',
	'The user&rsquo;s preferred language.' => 'El idioma preferido del usuario.',
	'Select a password for your account.' => 'Seleccione una contraseña para su cuenta.',
	'Confirm Password' => 'Confirmar contraseña',
	'Repeat the password for confirmation.' => 'Repita la contraseña para confirmación.',
	'Your LDAP username.' => 'Su usuario en el servidor LDAP.',
	'Enter your LDAP password.' => 'Su contraseña en el servidor LDAP.',
	'The initial account name is required.' => 'Se necesita el nombre de la cuenta inicial.',
	'The display name is required.' => 'El nombre público es obligatorio.',
	'The e-mail address is required.' => 'La dirección de correo electrónico es necesaria.',
	'Password recovery word/phrase is required.' => 'Se necesita la palabra/frase de recuperación de contraseña.',

## tmpl/cms/edit_author.tmpl
	'Edit Profile' => 'Editar Perfil',
	'This profile has been updated.' => 'Este perfil ha sido actualizado.',
	'A new password has been generated and sent to the email address [_1].' => 'Se ha generado y enviado a la dirección de correo electrónico [_1] una nueva contraseña.',
	'Your web services password is currently' => 'Actualmente la contraseña de los servicios web es',
	'_WARNING_PASSWORD_RESET_SINGLE' => 'Va a reiniciar la contraseña de "[_1]". Se enviará una nueva contraseña aleatoria que se enviará directamente a su dirección de correo electrónico ([_2]). ¿Desea continuar?',
	'Error occurred while removing userpic.' => 'Ocurrió un error durante la eliminación del avatar.',
	'Status of user in the system. Disabling a user prevents that person from using the system but preserves their content and history.' => 'Estado del usuario en el sistema. La desactivación de un usuario impide que utilice el sistema pero mantiene sus contenidos e históricos.',
	'_USER_PENDING' => 'Pendiente',
	'The username used to login.' => 'El nombre de usuario utilizado para la identificación en el sistema.',
	'External user ID' => 'ID usuario externo',
	'The name displayed when content from this user is published.' => 'El nombre mostrado cuando se publica contenidos de este usuario.',
	'The email address associated with this user.' => 'La dirección de correo asociada a este usuario.',
	'This User\'s website (e.g. http://www.movabletype.com/).  If the Website URL and Display Name fields are both populated, Movable Type will by default publish entries and comments with bylines linked to this URL.' => 'El sitio web del usuario (p.e. http://www.movabletype.com/).  Si la URL del sitio web y el Nombre público tienen valor, Movable Type publicará por defecto las entradas y comentarios con enlaces a esta URL.',
	'Userpic' => 'Avatar',
	'The image associated with this user.' => 'La imagen asociada al usuario.',
	'Select Userpic' => 'Seleccionar avatar',
	'Remove Userpic' => 'Borrar avatar',
	'Current Password' => 'Contraseña actual',
	'Existing password required to create a new password.' => 'La contraseña actual es necesaria para crear una nueva.',
	'Initial Password' => 'Contraseña inicial',
	'Enter preferred password.' => 'Introduzca la contraseña elegida.',
	'Enter the new password.' => 'Introduzca la nueva contraseña.',
	'Password recovery word/phrase' => 'Palabra/frase para la recuperación de contraseña',
	'This word or phrase is not used in the password recovery.' => 'Esta palabra o frase no se usa en la recuperación de la contraseña.',
	'Preferences' => 'Preferencias',
	'Display language for the Movable Type interface.' => 'Idioma para el interfaz de Movable Type.',
	'Text Format' => 'Formato de texto',
	'Default text formatting filter when creating new entries and new pages.' => 'Filtro predefinido para el formato de texto de las nuevas entradas y páginas.',
	'(Use Website/Blog Default)' => '(Usar sitio web/blog predefinido)', # Translate - New
	'Tag Delimiter' => 'Delimitador de etiquetas',
	'Preferred method of separating tags.' => 'Método preferido de separación de etiquetas.',
	'Web Services Password' => 'Contraseña de servicios web',
	'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'Utilizada por las fuentes de sindicación de actividad y los clientes XML-RPC y Atom.',
	'Reveal' => 'Mostrar',
	'System Permissions' => 'Permisos del sistema',
	'Create personal blog for user' => 'Crear blog personal para el usuario',
	'Create User (s)' => 'Crear usuario (s)',
	'Save changes to this author (s)' => 'Guardar cambios de este autor (s)',
	'_USAGE_PASSWORD_RESET' => 'Puede iniciar la recuperación de la contraseña en nombre de este usuario. Si lo hace, se enviará un correo a <strong>[_1]</strong> con una nueva contraseña aleatoria.',
	'Initiate Password Recovery' => 'Iniciar recuperación de contraseña',

## tmpl/cms/edit_comment.tmpl
	'The comment has been approved.' => 'Se ha aprobado el comentario.',
	'Save changes to this comment (s)' => 'Guardar cambios de este comentario (s)',
	'Delete this comment (x)' => 'Borrar este comentario (x)',
	'View entry comment was left on' => 'Mostrar la entrada donde se realizó el comentario',
	'Reply to this comment' => 'Responder al comentario',
	'Update the status of this comment' => 'Actualizar el estado del comentario',
	'View all comments with this status' => 'Ver comentarios con este estado',
	'The name of the person who posted the comment' => 'El nombre de la persona que publicó el comentario',
	'View this commenter detail' => 'Ver detalles de este comentarista',
	'(Trusted)' => '(De confianza)',
	'Untrust Commenter' => 'Comentarista no fiable',
	'Ban Commenter' => 'Bloquear Comentarista',
	'(Banned)' => '(Bloqueado)',
	'Trust Commenter' => 'Comentados Fiable',
	'Unban Commenter' => 'Desbloquear Comentarista',
	'(Pending)' => '(Pendiente)', # Translate - New
	'View all comments by this commenter' => 'Ver todos los comentarios de este comentarista',
	'Email address of commenter' => 'Dirección de correo del comentarista',
	'Unavailable for OpenID user' => 'No disponible para los usuarios de OpenID',
	'URL of commenter' => 'URL del comentarista',
	'No url in profile' => 'Sin URL en el perfil',
	'View all comments with this URL' => 'Ver todos los comentarios con esta URL',
	'[_1] this comment was made on' => '[_1] este comentario fue hecho en',
	'[_1] no longer exists' => '[_1] no existe más largo',
	'View all comments on this [_1]' => 'Ver todos los comentario en este [_1]',
	'Date this comment was made' => 'Fecha de cuando se hizo el comentario',
	'View all comments created on this day' => 'Ver todos los comentarios creados este día',
	'IP Address of the commenter' => 'Dirección IP del comentarista',
	'View all comments from this IP address' => 'Ver todos los comentarios procedentes de esta dirección IP',
	'Fulltext of the comment entry' => 'Texto completo de la entrada del comentario',
	'Responses to this comment' => 'Respuestas al comentario',

## tmpl/cms/restore_end.tmpl
	'Make sure that you remove the files that you restored from the \'import\' folder, so that if/when you run the restore process again, those files will not be re-restored.' => 'Asegúrese de que elimina los ficheros que ha restaurado de la carpeta \'importar\', por si ejecuta el proceso en otra ocasión que éstos no vuelvan a restaurar.',
	'An error occurred during the restore process: [_1] Please check activity log for more details.' => 'Ocurrió un error durante el proceso de restauración: [_1] Por favor, compruebe el registro de actividad para más detalles.',

## tmpl/cms/list_asset.tmpl
	'You have successfully deleted the asset(s).' => 'Se borraron con éxito los ficheros multimedia seleccionados.',
	'New Asset' => 'Nuevo fichero multimedia',
	'Show only assets where' => 'Mostrar solo los ficheros multimedia donde',
	'type' => 'tipo',

## tmpl/cms/asset_replace.tmpl
	'Upload New Asset' => 'Transferir nuevo fichero multimedia',

## tmpl/cms/import.tmpl
	'Import Blog Entries' => 'Importar entradas del blog', # Translate - New
	'You must select a blog to import.' => 'Debe seleccionar un blog a importar.',
	'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Transfiere las entradas de un weblog en Movable Type desde otras instalaciones de Movable Type o incluso otras herramientas de blogs, o exporta sus entradas para crear una copia de seguridad.',
	'Import data into' => 'Importar datos en',
	'Select a blog to import.' => 'Seleccione un blog para importar.',
	'Importing from' => 'Importar desde',
	'Ownership of imported entries' => 'Autoría de las entradas importadas',
	'Import as me' => 'Importar como yo mismo',
	'Preserve original user' => 'Preservar autor original',
	'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => 'Si selecciona preservar la autoría de las entradas importadas y se debe crear alguno de estos usarios durante en esta instalación, debe establecer una contraseña predefinida para estas nuevas cuentas.',
	'Default password for new users:' => 'Contraseña para los nuevos usuarios:',
	'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'Se le asignarán todas las entradas importadas. Si desea que las entradas mantengan los propietarios originales, debe contacar con su administrador de Movable Type para que él realice la importación y así se puedan crear los nuevos usuarios en caso de ser necesario.',
	'Upload import file (optional)' => 'Subir fichero de importación (opcional)',
	'If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the \'import\' folder of your Movable Type directory.' => 'Si el fichero de importación está situado en su PC, puede subirlo aquí. Si no, Movable Type comprobará automáticamente la carpeta \'folder\' en el directorio de Movable Type.',
	'Import File Encoding' => 'Codificación del fichero de importación',
	'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'Por defecto, Movable Type intentará detectar automáticamente la codificación del fichero a importar. Sin embargo, si experimenta dificultados, puede especificarlo explícitamente.',
	'<mt:var name="display_name" escape="html">' => '<mt:var name="display_name" escape="html">',
	'Default category for entries (optional)' => 'Categoría predefinida de las entradas (opcional)',
	'You can specify a default category for imported entries which have none assigned.' => 'Puede especificar una categoría predefinida para las entradas importadas que no tengan ninguna asignada.',
	'Select a category' => 'Seleccione una categoría',
	'Import Entries (s)' => 'Importar entradas (s)',

## tmpl/cms/list_widget.tmpl
	'Manage [_1] Widgets' => 'Administrar widgets de [_1]', # Translate - New
	'Delete selected Widget Sets (x)' => 'Borrar conjuntos de widgets seleccionados (x)',
	'Helpful Tips' => 'Consejos útiles',
	'To add a widget set to your templates, use the following syntax:' => 'Para añadir un conjunto de widgets a las plantillas, utilice la siguiente sintaxis:',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Nombre del conjunto de widgets&quot;$&gt;</strong>',
	'Your changes to the widget set have been saved.' => 'Se han guardado los cambios al conjunto de widgets.',
	'You have successfully deleted the selected widget set(s) from your blog.' => 'Borró con éxito los conjuntos de widgets seleccionados del blog.',
	'No Widget Sets could be found.' => 'Ningún grupo de widget ha sido encontrado',
	'Create widget template' => 'Crear plantilla de widget',

## tmpl/cms/upgrade_runner.tmpl
	'Initializing database...' => 'Inicializando base la de datos...',
	'Upgrading database...' => 'Actualizando la base de datos...',
	'Error during installation:' => 'Error durante la instalación:',
	'Error during upgrade:' => 'Error durante la actualización:',
	'Return to Movable Type (s)' => 'Volver a Movable Type (s)',
	'Return to Movable Type' => 'Volver a Movable Type',
	'Your database is already current.' => 'Su base de datos está al día.',
	'Installation complete!' => '¡Instalación finalizada!',
	'Upgrade complete!' => '¡Actualización finalizada!',

## tmpl/cms/system_check.tmpl
	'User Counts' => 'Número de usuarios',
	'Number of users registered in this system.' => 'Número de usuarios registrados en el sistema.',
	'Total Users' => 'Usuarios Totales',
	'Active Users' => 'Usuarios Activos',
	'Users who have logged in within the past 90 days are considered <strong>active</strong>.' => 'Se consideran <strong>activos</strong> los usuarios que se hayan identificado en los últimos 90 días.',
	'Memcache Status' => 'Estado de memcache',
	'Memcache is [_1]' => 'Memcache es [_1]', # Translate - New
	'Memcache Server is [_1]' => 'El servidor memcache es [_1]', # Translate - New
	'Server Model' => 'Modelo de servidor',
	'Movable Type could not find the script named \'mt-check.cgi\'. To resolve this issue, ensure that the mt-check.cgi script exists and that the CheckScript configuration parameter (if it is necessary) references it properly.' => 'Movable Type no pudo encontrar el script llamado \'mt-check.cgi\'. Para solucionar este problema, asegúrese de que el script mt-check.cgi existe y que el parámetro de configuración CheckScript (si fuera necesario) lo referencia correctamente.',

## tmpl/cms/restore.tmpl
	'Restore from a Backup' => 'Resturar una copia de seguridad',
	'Perl module XML::SAX and/or some of its dependencies are missing.  Movable Type cannot restore the system without these modules.' => 'No se encuentra el módulo de Perl XML::SAX y/o algunas de sus dependencias. Movable Type no puede restaurar el sistema sin estos módulos.',
	'Backup File' => 'Fichero de respaldo',
	'If your backup file is located on a remote computer, you can upload it here.  Otherwise, Movable Type will automatically look in the \'import\' folder within your Movable Type directory.' => 'If your backup file is located on a remote computer, you can upload it here.  Otherwise, Movable Type will automatically look in the \'import\' folder within your Movable Type directory.',
	'Check this and files backed up from newer versions can be restored to this system.  NOTE: Ignoring Schema Version can damage Movable Type permanently.' => 'Activa esta opción y los ficheros con copias de seguridad de versiones más recientes podrán restaurarse en este sistema. NOTA: Ignorar la versión del esquema puede dañar Movable Type permanentemente.',
	'Ignore schema version conflicts' => 'Igrar conflictos de versión de esquemas',
	'Allow existing global templates to be overwritten by global templates in the backup file.' => 'Permitir la sobreescritura de las plantillas globales existentes por las de la copia de seguridad.',
	'Overwrite global templates.' => 'Sobreescribir las plantillas globales.',
	'Restore (r)' => 'Restaurar (r)',

## tmpl/cms/rebuilding.tmpl
	'Publishing...' => 'Publicando...',
	'Publishing [_1]...' => 'Publicando [_1]...',
	'Publishing [_1] [_2]...' => 'Publicando [_1] [_2]...',
	'Publishing [_1] dynamic links...' => 'Publicando enlaces dinámicos [_1]...',
	'Publishing [_1] archives...' => 'Publicando archivos [_1]...',
	'Publishing [_1] templates...' => 'Publicando plantillas [_1]...',
	'[_1]% Complete' => '[_1]% completado',

## tmpl/cms/edit_asset.tmpl
	'Edit Asset' => 'Editar multimedia',
	'Your asset changes have been made.' => 'Se han guardado los cambios del fichero multimedia.',
	'Stats' => 'Estadísticas',
	'[_1] - Modified by [_2]' => '[_1] - Modificado por [_2]',
	'Appears in...' => 'Aparece en...',
	'Published on [_1]' => 'Publicado en [_1]',
	'Show all entries' => 'Mostrar todas las categorías',
	'Show all pages' => 'Mostrar todas las páginas',
	'This asset has not been used.' => 'Este fichero multimedia no se ha utilizado.',
	'Related Assets' => 'Ficheros multimedia relacionados',
	'You must specify a label for the asset.' => 'Debe especificar una etiqueta para el fichero multimedia.',
	'Embed Asset' => 'Embeber fichero multimedia',
	'View this asset.' => 'Ver este fichero multimedia.',
	'Save changes to this asset (s)' => 'Guardar cambios de este fichero multimedia (s)',

## tmpl/cms/upgrade.tmpl
	'Time to Upgrade!' => '¡Hora de actualizar!',
	'Upgrade Check' => 'Comprobar actualización',
	'Do you want to proceed with the upgrade anyway?' => '¿Desea proceder en cualquier caso con la actualización?',
	'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Se ha instalado una nueva versión de Movable Type.  Debemos realizar algunas tareas para actualizar su base de datos.',
	'The Movable Type Upgrade Guide can be found <a href=\'[_1]\' target=\'_blank\'>here</a>.' => 'La Guía de Actualización de Movable Type se encuentra <a href=\'[_1]\' target=\'_blank\'>aquí</a>.',
	'In addition, the following Movable Type components require upgrading or installation:' => 'Además, los siguientes componentes de Movable Type necesitan actualización o instalación:',
	'The following Movable Type components require upgrading or installation:' => 'Los siguientes componentes de Movable Type necesitan actualización o instalación:',
	'Begin Upgrade' => 'Comenzar actualización',
	'Congratulations, you have successfully upgraded to Movable Type [_1].' => 'Felicidades, actualizó con éxito a Movable Type [_1].',
	'Your Movable Type installation is already up to date.' => 'Su instalación de Movable Type ya está actualizada.',

## tmpl/cms/edit_blog.tmpl
	'Blog Theme' => 'Tema del blog',
	'Select the theme you wish to use for this blog.' => 'Seleccione el tema que desea usar en este blog.',
	'Name your blog. The blog name can be changed at any time.' => 'Nombre del blog. Se puede modificar en cualquier momento.',
	'Create Blog (s)' => 'Crear blog (s)',

## tmpl/cms/pinging.tmpl
	'Trackback' => 'TrackBack',
	'Pinging sites...' => 'Enviando pings a sitios...',

## tmpl/cms/asset_upload.tmpl
	'Upload Asset' => 'Transferir fichero multimedia', # Translate - New

## tmpl/cms/setup_initial_website.tmpl
	'Create Your First Website' => 'Cree su primer sitio web',
	'In order to properly publish your website, you must provide Movable Type with your website\'s URL and the filesystem path where its files should be published.' => 'Para publicar correctamente su sitio web, debe proveer a Movable Type con la URL de su sitio web y la ruta en el sistema donde se publicarán los ficheros.',
	'My First Website' => 'Mi primer sitio web',
	'The \'Publishing Path\' is the directory in your web server\'s filesystem where Movable Type will publish the files for your website. The web server must have write access to this directory.' => 'La \'Ruta de publicación\' es el directorio en el sistema de ficheros del servidor web donde Movable Type publicará los ficheros del sitio. El servidor web debe tener permisos de escritura en este directorio.',
	'Theme' => 'Tema',
	'Select the theme you wish to use for this new website.' => 'Seleccione el tema que desea usar en este sitio web nuevo.',
	'Finish install (s)' => 'Finalizar la instalación (s)',
	'Finish install' => 'Finalizar instalación',
	'Back (x)' => 'Volver (x)',
	'The website name is required.' => 'El nombre del sitio web es obligatorio.',
	'The website URL is required.' => 'La URL del sitio web es obligatoria.',
	'The publishing path is required.' => 'La ruta de publicación es obligatoria.',
	'The timezone is required.' => 'La zona horaria es obligatoria.',

## tmpl/cms/restore_start.tmpl
	'Restoring Movable Type' => 'Restaurando Movable Type',

## tmpl/cms/preview_entry.tmpl
	'Preview [_1]' => 'Pre-ver [_1]',
	'Re-Edit this [_1]' => 'Re-editar [_1]',
	'Re-Edit this [_1] (e)' => 'Re-editar [_1] (e)',
	'Save this [_1] (s)' => 'Guardar este [_1] (s)',
	'Cancel (c)' => 'Cancelar (c)',

## tmpl/cms/cfg_feedback.tmpl
	'Feedback Settings' => 'Configuración de respuestas',
	'Spam Settings' => 'Configuración del spam',
	'Automatic Deletion' => 'Borrado automático',
	'Automatically delete spam feedback after the time period shown below.' => 'Borra automáticamente las respuestas spam transcurrido el periodo de tiempo indicado abajo.',
	'Delete Spam After' => 'Borrar spam después',
	'When an item has been reported as spam for this many days, it is automatically deleted.' => 'Cuando un elemento haya estado marcado como spam durante esta cantidad de días, será borrado automáticamente.',
	'Spam Score Threshold' => 'Puntuación límite de spam',
	'Comments and TrackBacks receive a spam score between -10 (complete spam) and +10 (not spam). Feedback with a score which is lower than the threshold shown above will be reported as spam.' => 'Los comentarios y TrackBacks se puntúan como spam con valores entre -10 (spam total) y +10 (no spam). Las respuestas con una puntuación que sea menor del límite mostrado arriba, se marcarán como spam.',
	'Less Aggressive' => 'Menos agresivo',
	'Decrease' => 'Disminuir',
	'Increase' => 'Aumentar',
	'More Aggressive' => 'Más agresivo',
	'Include \'nofollow\' in URLs' => 'Incluir \'nofollow\' en las URLs',
	'Include the \'nofollow\' attribute in URLs submitted in feedback.' => 'Incluye el atributo \'nofollow\' en las URLs enviadas en las respuestas.',
	'\'nofollow\' exception for trusted commenters' => 'Excepción \'nofollow\' para los comentaristas de confianza.',
	'Do not add the \'nofollow\' attribute when a comment is submitted by a trusted commenter.' => 'No añade el atributo \'nofollow\' cuando la respuesta es enviada por un comentarista de confianza.',
	'Comment Settings' => 'Configuración de comentarios',
	'Note: Commenting is currently disabled at the system level.' => 'Nota: Los comentarios están actualmente desactivados a nivel de sistema.',
	'Comment authentication is not available because at least one of the required Perl modules, MIME::Base64 and LWP::UserAgent, are not installed. Install the missing modules and reload this page to configure comment authentication.' => 'La autentificación de comentarios no está disponible porque al menos uno de los módulos de Perl necesarios, MIME::Base64 o LWP::UserAgent, no están instalados. Instale los módulos necesarios y recargue esta página para configurar la autentificación de comentarios.',
	'Accept comments according to the policies shown below.' => 'Aceptar comentarios de acuerdo a las políticas mostradas abajo.',
	'Setup Registration' => 'Configuración del registro',
	'Commenting Policy' => 'Política de comentarios',
	'Immediately approve comments from' => 'Aceptar inmediatamente los comentarios de',
	'Specify what should happen to comments after submission. Unapproved comments are held for moderation.' => 'Especifique qué ocurrirá con los comentarios después de su envío. Los comentarios no aprobados se retienen a la espera de su moderación.',
	'No one' => 'Nadie',
	'Trusted commenters only' => 'Solo comentaristas de confianza',
	'Any authenticated commenters' => 'Solo comentaristas autentificados',
	'Anyone' => 'Cualquiera',
	'Allow HTML' => 'Permitir HTML',
	'Allow commenters to include a limited set of HTML tags in their comments. Otherwise all HTML will be stripped out.' => 'Permitir a los comentaristas que incluyan un conjunto limitado de etiquetas HTML en los comentarios. Si no, se filtrará todo el HTML.',
	'Limit HTML Tags' => 'Limitar etiquetas HTML',
	'Specify the list of HTML tags to allow when accepting a comment.' => 'Especifique la lista de etiquetas HTML que se permiten en los comentarios.',
	'Use defaults' => 'Utilizar valores predeterminados',
	'([_1])' => '([_1])',
	'Use my settings' => 'Utilizar mis preferencias',
	'E-mail Notification' => 'Notificación por correo-e',
	'Specify when Movable Type should notify you of new comments.' => 'Especifique cuándo Movable Type debe notificar los nuevos comentarios.',
	'On' => 'Activar',
	'Only when attention is required' => 'Solo cuando se requiera atención',
	'Off' => 'Desactivar',
	'Comment Display Options' => 'Opciones de visualización de comentarios',
	'Comment Order' => 'Orden de los comentarios',
	'Select whether you want comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Seleccione si desea mostrar los comentarios en orden ascendente (antiguos primero) o descendente (recientes primero).',
	'Auto-Link URLs' => 'Autoenlazar URLs',
	'Transform URLs in comment text into HTML links.' => 'Transformar las URLs en enlaces HTML.',
	'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Opción que especifica el formato de texto a utilizar para formatear los comentarios de los visitantes.',
	'CAPTCHA Provider' => 'Proveedor de CAPTCHA',
	'none' => 'ninguno',
	'No CAPTCHA provider available' => 'No hay disponible ningún proveedor de CAPTCHA.',
	'No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed and if the CaptchaSourceImageBase configuration directive points to a valid captcha-source directory within the \'mt-static/images\' directory.' => 'No existe ningún proveedor CAPTCHA en este sistema. Por favor, compruebe que Image::Magick esté instalado y que la directiva de configuración CaptchaSourceImageBase apunta a un directorio válido de captcha dentro del directorio \'mt-static/images\'.',
	'Use Comment Confirmation Page' => 'Usar página de confirmación de comentarios',
	'Use comment confirmation page' => 'Usar página de confirmación de comentarios',
	'Each commenter\'s browser will be redirected to a comment confirmation page after their comment is accepted.' => 'Antes de aceptar un comentario, el navegador de cada comentarista se redirigirá a una página de confirmación de comentarios.',
	'Note: TrackBacks are currently disabled at the system level.' => 'Nota: Actualmente, los TrackBacks están desactivados a nivel del sistema.',
	'Accept TrackBacks from any source.' => 'Aceptar TrackBacks de cualquier origen.',
	'TrackBack Policy' => 'Política de TrackBack',
	'Moderation' => 'Moderación',
	'Hold all TrackBacks for approval before they are published.' => 'Retener los TrackBacks para su aprobación antes de publicarlos.',
	'Specify when Movable Type should notify you of new TrackBacks.' => 'Especifique cuándo Movable Type debe notificar los nuevos TrackBacks.',
	'TrackBack Options' => 'Opciones de TrackBack',
	'TrackBack Auto-Discovery' => 'Autodescubrimiento de TrackBacks',
	'When auto-discovery is turned on, any external HTML links in new entries will be extracted and the appropriate sites will automatically be sent a TrackBack ping.' => 'Si el auto-descubrimiento está activado, se extraerán los enlaces HTML de las nuevas entradas y automáticamente se enviarán pings de TrackBack a los sitios correspondientes.',
	'Enable External TrackBack Auto-Discovery' => 'Habilitar autodescubrimiento de TrackBacks externos',
	'Setting Notice' => 'Alerta sobre configuración',
	'Note: This option may be affected since outbound pings are constrained system-wide.' => 'Nota: Esta opción podría verse afectada debido a que los pings salientes están restringidos a nivel del sistema.',
	'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Nota: Actualmente, esta opción es ignorada debido a que los pings salientes están desactivados a nivel del sistema.',
	'Enable Internal TrackBack Auto-Discovery' => 'Habilitar autodescubrimiento de TrackBacks internos',

## tmpl/cms/list_folder.tmpl
	'Your folder changes and additions have been made.' => 'Se han realizado los cambios y añadidos a la carpeta.',
	'You have successfully deleted the selected folder.' => 'Ha borrado con éxito la carpeta seleccionada.',
	'Delete selected folders (x)' => 'Borrar carpetas seleccionadas (x)',
	'Create top level folder' => 'Crear carpeta raíz',
	'Top Level' => 'Raíz',
	'New Parent [_1]' => 'Nueva [_1] raíz',
	'Create Folder' => 'Crear carpeta',
	'Create' => 'Crear',
	'Create Subfolder' => 'Crear subcarpeta',
	'Move Folder' => 'Mover carpeta',
	'Move' => 'Mover',
	'No folders could be found.' => 'No se encontró ninguna carpeta.',

## tmpl/cms/list_association.tmpl
	'permission' => 'permiso',
	'permissions' => 'permisos',
	'Remove selected permissions (x)' => 'Remove selected permissions (x)',
	'Revoke Permission' => 'Revocar permiso',
	'[_1] <em>[_2]</em> is currently disabled.' => '[_1] <em>[_2]</em> está momentáneamente indisponible',
	'Grant Website Permission' => 'Conceder permiso de sitio web',
	'Grant Blog Permission' => 'Conceder permiso de blog',
	'You can not create permissions for disabled users.' => 'No puede crear permisos para los usuarios deshabilitados.',
	'Grant Permission' => 'Otorgar permiso',
	'Assign Website Role to User' => 'Asignar rol de sitio web al usuario',
	'Assign Blog Role to User' => 'Asignar rol de blog al usuario',
	'Grant website permission to a user' => 'Conceder permiso de sitio web al usuario',
	'Grant blog permission to a user' => 'Conceder permiso de blog al usuario',
	'You have successfully revoked the given permission(s).' => 'Otorgó los permisos con éxito.',
	'You have successfully granted the given permission(s).' => 'Revocó los permisos con éxito.',
	'No permissions could be found.' => 'No se encontraron permisos.',

## tmpl/cms/login.tmpl
	'Sign in' => 'Registrarse',
	'Your Movable Type session has ended.' => 'Finalizó su sesión en Movable Type.',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Su sesión de Movable Type finalizó. Si desea identificarse de nuevo, hágalo abajo.',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Su sesión de Movable Type finalizó. Por favor, identifíquese de nuevo para continuar con esta acción.',
	'Sign In (s)' => 'Identifíquese (s)',
	'Forgot your password?' => '¿Olvidó su contraseña?',

## tmpl/cms/list_category.tmpl
	'Your category changes and additions have been made.' => 'Se han realizado los cambios y añadidos.',
	'You have successfully deleted the selected category.' => 'Se han borrado con éxito las categorías seleccionadas.',
	'categories' => 'categorías',
	'Delete selected category (x)' => 'Borrar categoría seleccionada (x)',
	'Create top level category' => 'Crear categoría raíz',
	'Create Category' => 'Crear categoría',
	'Collapse' => 'Contraer',
	'Expand' => 'Ampliar',
	'Create Subcategory' => 'Crear subcategoría',
	'Move Category' => 'Mover categoría',
	'[quant,_1,TrackBack,TrackBacks]' => '[quant,_1,TrackBack,TrackBacks]',
	'No categories could be found.' => 'No se encontró ninguna categoría.',

## tmpl/comment/auth_livedoor.tmpl

## tmpl/comment/signup.tmpl
	'Create an account' => 'Crear una cuenta',
	'The name appears on your comment.' => 'El nombre que aparece en su comentario.',
	'Your email address.' => 'Dirección de correo electrónico.',
	'Your login name.' => 'Nombre de su usuario.',
	'Select a password for yourself.' => 'Seleccione su contraseña.',
	'Password Confirm' => 'Confirmar contraseña',
	'The URL of your website. (Optional)' => 'La URL del sitio web (opcional)',
	'Register' => 'Registrarse',

## tmpl/comment/login.tmpl
	'Sign in to comment' => 'Identifíquese para comentar',
	'Sign in using' => 'Identifíquese usando',
	'Remember me?' => '¿Recordarme?',
	'Not a member? <a href="[_1]">Sign Up</a>!' => '¿No es miembro? ¡<a href="[_1]">Regístrese</a>!',

## tmpl/comment/auth_wordpress.tmpl
	'Your Wordpress.com Username' => 'Su usuario de Wordpress.com',
	'Sign in using your WordPress.com username.' => 'Identifíquese usando su usuario de WordPress.com.',

## tmpl/comment/auth_yahoojapan.tmpl
	'Turn on OpenID for your Yahoo! Japan account now' => 'Active OpenID en su cuenta de Yahoo! Japan ahora',

## tmpl/comment/auth_livejournal.tmpl
	'Your LiveJournal Username' => 'Su usuario de LiveJournal',
	'Learn more about LiveJournal.' => 'Más información sobre LiveJournal.',

## tmpl/comment/signup_thanks.tmpl
	'Thanks for signing up' => 'Gracias por inscribirse',
	'Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].' => 'Antes de poder comentar, debe completar el proceso de registro confirmando su cuenta. Se le ha enviado un correo a [_1].',
	'To complete the registration process you must first confirm your account. An email has been sent to [_1].' => 'Para completar el proceso de registro, primeramente debe confirmar su cuenta. Se le ha enviado un correo a [_1].',
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'Para confirmar y activar su cuenta, por favor, compruebe su correo y haga clic en el correo que le acabamos de enviar.',
	'Return to the original entry.' => 'Volver a la entrada original.',
	'Return to the original page.' => 'Volver a la página original.',

## tmpl/comment/auth_hatena.tmpl
	'Your Hatena ID' => 'Su ID de Hatena',

## tmpl/comment/register.tmpl

## tmpl/comment/auth_typepad.tmpl
	'TypePad is a free, open system providing you a central identity for posting comments on weblogs and logging into other websites. You can register for free.' => 'TypePad es un sistema gratuito y abierto que le provee una identidad centralizada para la publicación de comentarios en weblogs e identificarse en otros sitios web. Puede registrarse gratuitamente.',

## tmpl/comment/auth_aim.tmpl
	'Your AIM or AOL Screen Name' => 'Su usuario de AIM o AOL',
	'Sign in using your AIM or AOL screen name. Your screen name will be displayed publicly.' => 'Identifíquese usando su usuario de AIM o AOL. El nombre del usuario se mostrará públicamente.',

## tmpl/comment/error.tmpl
	'Go Back (s)' => 'Volver',

## tmpl/comment/auth_googleopenid.tmpl
	'Sign in using your Gmail account' => 'Identifíquese usando su cuenta de Gmail',
	'Sign in to Movable Type with your[_1] Account[_2]' => 'Identifíquese en Movable Type con su cuenta [_1] [_2]',

## tmpl/comment/auth_vox.tmpl
	'Your Vox Blog URL' => 'La URL de su blog de Vox',
	'Learn more about Vox.' => 'Más información sobre Vox.',

## tmpl/comment/auth_openid.tmpl
	'OpenID URL' => 'URL de OpenID',
	'Sign in using your OpenID identity.' => 'Identifíquese usando OpenID.',
	'Sign in with one of your existing third party OpenID accounts.' => 'Identifíquese usando una de sus cuentas externas de OpenID.',
	'Learn more about OpenID.' => 'Más información sobre OpenID.',

## tmpl/comment/profile.tmpl
	'Your Profile' => 'Su perfil',
	'Return to the <a href="[_1]">original page</a>.' => 'Volver a la <a href="[_1]">página original</a>.',

## tmpl/comment/auth_yahoo.tmpl
	'Turn on OpenID for your Yahoo! account now' => 'Active ahora OpenID para su cuenta de Yahoo',

## tmpl/include/chromeless_header.tmpl

## tmpl/feeds/feed_entry.tmpl
	'More like this' => 'Más como éstos',
	'From this blog' => 'De este blog',
	'From this author' => 'De este autor',
	'On this day' => 'En este día',

## tmpl/feeds/feed_comment.tmpl
	'On this entry' => 'En esta entrada',
	'By commenter identity' => 'Por identidad del comentarista',
	'By commenter name' => 'Por nombre del comentarista',
	'By commenter email' => 'Por correo electrónico del comentarista',
	'By commenter URL' => 'Por URL del comentarista',

## tmpl/feeds/login.tmpl
	'Movable Type Activity Log' => 'Registro de actividad de Movable Type',
	'This link is invalid. Please resubscribe to your activity feed.' => 'Este enlace no es válido. Por favor, resuscríbase a la fuente de sindicación de actividades.',

## tmpl/feeds/error.tmpl

## tmpl/feeds/feed_page.tmpl

## tmpl/feeds/feed_ping.tmpl
	'Source blog' => 'Blog origen',
	'By source blog' => 'Por blog origen',
	'By source title' => 'Por título origen',
	'By source URL' => 'Por URL origen',

## tmpl/error.tmpl
	'Missing Configuration File' => 'Fichero de configuración no encontrado',
	'_ERROR_CONFIG_FILE' => 'El fichero de configuración de Your Movable Type no existe o no se puede leer correctamente. Por favor, consulte la sección <a href="javascript:void(0)">Instalación y configuración</a> del manual de Movable Type manual para más información.',
	'Database Connection Error' => 'Error de conexión a la base de datos',
	'_ERROR_DATABASE_CONNECTION' => 'Las opciones de configuración de su base de datos o son incorrectas o no están presentes en el fichero de configuración de Movable Type. Por favor, consulte la sección <a href="javascript:void(0)">Instalación y configuración</a> del manual de Movable Type para más información',
	'CGI Path Configuration Required' => 'Se necesita la configuración de la ruta de CGI',
	'_ERROR_CGI_PATH' => 'La opción de configuración CGIPath no es válida o no se encuentra en el fichero de configuración de Movable Type. Por favor, consulte la sección <a href="javascript:void(0)">Instalación y configuración</a> del manual de Movable Type manual para más información.',

## addons/Community.pack/lib/MT/App/Community.pm
	'No login form template defined' => 'No hay ninguna plantilla de formulario definida',
	'Before you can sign in, you must authenticate your email address. <a href="[_1]">Click here</a> to resend the verification email.' => 'Antes de que pueda iniciar una sesión, debe autentificar su dirección de correo. <a href="[_1]">Haga clic aquí</a> para reenviar el correo de verificación.',
	'Your confirmation have expired. Please register again.' => 'Su confirmación ha caducado. Por favor, regístrese de nuevo.',
	'User \'[_1]\' (ID:[_2]) has been successfully registered.' => 'El usuario \'[_1]\' (ID:[_2]) se registró con éxito.',
	'Thanks for the confirmation.  Please sign in.' => 'Gracias por la confirmación. Por favor, inicie la sesión.',
	'[_1] registered to Movable Type.' => '[_1] se registró en Movable Type.',
	'Login required' => 'Requerido inicio de sesión',
	'Title or Content is required.' => 'El título o contenido es obligatorio.',
	'System template entry_response not found in blog: [_1]' => 'La plantilla del sistema entry_response no se encontró en el blog: [_1]',
	'New entry \'[_1]\' added to the blog \'[_2]\'' => 'Añadida una nueva entrada \'[_1]\' al blog \'[_2]\'',
	'Id or Username is required' => 'Se necesita el Id o el nombre del usuario',
	'Unknown user' => 'Usuario desconocido',
	'Recent Entries from [_1]' => 'Entradas recientes de [_1]',
	'Responses to Comments from [_1]' => 'Respuestas a los comentarios de [_1]',
	'Actions from [_1]' => 'Acciones de [_1]',

## addons/Community.pack/lib/MT/Community/Tags.pm
	'You used an \'[_1]\' tag outside of the block of MTIfEntryRecommended; perhaps you mistakenly placed it outside of an \'MTIfEntryRecommended\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del bloque MTIfEntryRecommended; ¿quizás la situó por error fuera de un contenedor \'MTIfEntryRecommended\'?',
	'Click here to recommend' => 'Haga clic aquí para hacer una recomendación',
	'Click here to follow' => 'Clic aquí para seguir a',
	'Click here to leave' => 'Clic aquí para dejar de seguir a',

## addons/Community.pack/lib/MT/Community/CMS.pm
	'Community' => 'Comunidad',
	'Users followed by [_1]' => 'Seguidos por [_1]',
	'Users following [_1]' => 'Seguidores de [_1]',
	'Following' => 'Siguiendo',
	'Followers' => 'Seguidores',

## addons/Community.pack/php/function.mtentryrecommendvotelink.php

## addons/Community.pack/tmpl/widget/blog_stats_registration.mtml
	'Registrations' => 'Registros',
	'Recent Registrations' => 'Registros recientes',
	'default userpic' => 'avatar predefinido',
	'You have [quant,_1,registration,registrations] from [_2]' => 'Tiene un [quant,_1,registro,registros] en [_2]',

## addons/Community.pack/tmpl/widget/most_popular_entries.mtml
	'Most Popular Entries' => 'Entradas más populares',
	'There are no popular entries.' => 'No hay entradas populares.',

## addons/Community.pack/tmpl/widget/recent_submissions.mtml
	'Recent Submissions' => 'Envíos recientes',

## addons/Community.pack/tmpl/widget/recently_scored.mtml
	'Recently Scored' => 'Puntuaciones recientes',
	'There are no recently favorited entries.' => 'No hay recomendaciones recientes de entradas.',

## addons/Community.pack/tmpl/cfg_community_prefs.tmpl
	'Community Settings' => 'Configuración de la comunidad',
	'Anonymous Recommendation' => 'Recomendación anónima',
	'Check to allow anonymous users (users not logged in) to recommend discussion.  IP address is recorded and used to identify each user.' => 'Active esta opción para permitir que los usuarios anónimos (aquellos que no han iniciado una sesión) puedan recomendar debates. Las direcciones IP se registran y se utilizan para identificar a cada usuario.',
	'Allow anonymous user to recommend' => 'Permitir que los usuarios anónimos hagan recomendaciones',
	'Save changes to blog (s)' => 'Guardar los cambios en el blog (s)',

## addons/Community.pack/templates/global/register_form.mtml
	'Sign up' => 'Registrarse',
	'Simple Header' => 'Cabecera simple',
	'Simple Footer' => 'Pie simple',

## addons/Community.pack/templates/global/profile_error.mtml
	'Profile Error' => 'Error del perfil',
	'Header' => 'Cabecera',
	'ERROR MSG HERE' => 'MENSAJE DE ERROR AQUÍ',
	'Status Message' => 'Mensaje de estado',
	'Footer' => 'Pie',

## addons/Community.pack/templates/global/new_password.mtml

## addons/Community.pack/templates/global/new_entry_email.mtml
	'A new entry \'[_1]([_2])\' has been posted on your blog [_3].' => 'Se ha publicado una nueva entrada \'[_1]([_2])\' en su blog [_3].',
	'Author name: [_1]' => 'Nombre del autor: [_1]',
	'Author nickname: [_1]' => 'Pseudónimo del autor: [_1]',
	'Title: [_1]' => 'Título: [_1]',
	'Edit entry:' => 'Editar entrada:',

## addons/Community.pack/templates/global/profile_feed.mtml
	'Posted [_1] to [_2]' => '[_1] publicado en [_2]',
	'Commented on [_1] in [_2]' => 'Comentó en [_1] en [_2]',
	'Voted on [_1] in [_2]' => 'Votó en [_1] en [_2]',
	'[_1] voted on <a href="[_2]">[_3]</a> in [_4]' => '[_1] votó en <a href="[_2]">[_3]</a> en [_4]',

## addons/Community.pack/templates/global/signin.mtml
	'You are signed in as <a href="[_1]">[_2]</a>' => 'Está identificado como <a href="[_1]">[_2]</a>',
	'You are signed in as [_1]' => 'Está identificado como [_1]',
	'Edit profile' => 'Editar Perfil',
	'Not a member? <a href="[_1]">Register</a>' => '¿No es miembro? <a href="[_1]">Registrarse</a>',

## addons/Community.pack/templates/global/profile_edit_form.mtml
	'Go <a href="[_1]">back to the previous page</a> or <a href="[_2]">view your profile</a>.' => '<a href="[_1]">Regresar a la página anterior</a> o <a href="[_2]">vea su perfil</a>.',
	'Form Field' => 'Campo del formulario',

## addons/Community.pack/templates/global/header.mtml
	'Blog Description' => 'Descripción del blog',
	'GlobalJavaScript' => 'GlobalJavaScript',
	'Navigation' => 'Navegación',

## addons/Community.pack/templates/global/profile_view.mtml
	'User Profile' => 'Perfil del usuario',
	'Recent Actions from [_1]' => 'Acciones recientes de [_1]',
	'You are following [_1].' => 'Estás siguiendo a [_1]',
	'Unfollow' => 'Dejar de seguir',
	'Follow' => 'Seguir',
	'You are followed by [_1].' => 'Te sigue [_1]',
	'You are not followed by [_1].' => 'No te sigue [_1]',
	'Website:' => 'Web:',
	'Recent Actions' => 'Acciones recientes',
	'Comment Threads' => 'Hilos de comentarios',
	'Commented on [_1]' => 'Comentó en [_2]',
	'Favorited [_1] on [_2]' => 'Marcó como favorito [_1] en [_2]',
	'No recent actions.' => 'Ninguna acción reciente',
	'[_1] commented on ' => '[_1] comentó en',
	'No responses to comments.' => 'Sin respuestas a comentarios.',
	'Not following anyone' => 'No sigue a nadie',
	'Not being followed' => 'Sin seguidores',

## addons/Community.pack/templates/global/login_form.mtml
	'Not a member?&nbsp;&nbsp;<a href="[_1]">Sign Up</a>!' => '¿No es usuario?&nbsp;&nbsp;¡<a href="[_1]">Inscríbase</a>!',

## addons/Community.pack/templates/global/register_confirmation.mtml
	'Authentication Email Sent' => 'Correo de autentificación enviado.',
	'Profile Created' => 'Perfil creado',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Regresar a la página original.</a>',

## addons/Community.pack/templates/global/footer.mtml

## addons/Community.pack/templates/global/navigation.mtml
	'Home' => 'Inicio',

## addons/Community.pack/templates/global/new_password_reset_form.mtml
	'Reset Password' => 'Reiniciar la contraseña',

## addons/Community.pack/templates/global/login_form_module.mtml
	'Logged in as <a href="[_1]">[_2]</a>' => 'Identificado como <a href="[_1]">[_2]</a>',
	'Logout' => 'Cerrar sesión',
	'Hello [_1]' => 'Hola [_1]',
	'Forgot Password' => 'Recuperar la contraseña',

## addons/Community.pack/templates/global/email_verification_email.mtml
	'Thank you registering for an account to [_1].' => 'Gracias por registrar una cuenta en [_1].',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to sign in to [_1].' => 'Por su propia seguridad y para prevenir fraudes, le solicitamos que confirme su cuenta y dirección de correo antes de continuar. Una vez confirmados, ya podrá iniciar una sesión en [_1].',
	'If you did not make this request, or you don\'t want to register for an account to [_1], then no further action is required.' => 'Si no realizó esta petición, o no quiere registrar una cuenta en [_1], no se requiere ninguna otra acción.',

## addons/Community.pack/templates/global/register_notification_email.mtml

## addons/Community.pack/templates/global/search.mtml

## addons/Community.pack/templates/global/javascript.mtml
	'Vote' => 'Voto',
	'Votes' => 'Votos',

## addons/Community.pack/templates/blog/category_archive_list.mtml

## addons/Community.pack/templates/blog/main_index.mtml
	'Content Navigation' => 'Navegación de contenidos',

## addons/Community.pack/templates/blog/page.mtml
	'Page Detail' => 'Detalle de la página',

## addons/Community.pack/templates/blog/main_index_widgets_group.mtml

## addons/Community.pack/templates/blog/entry_summary.mtml
	'Entry Metadata' => 'Metadatos de la entrada',

## addons/Community.pack/templates/blog/content_nav.mtml
	'Blog Home' => 'Incio - Blog',

## addons/Community.pack/templates/blog/entry_response.mtml
	'Thank you for posting an entry.' => 'Gracias por publicar una entrada.',
	'Entry Pending' => 'Entrada pendiente',
	'Your entry has been received and held for approval by the blog owner.' => 'Su entrada ha sido recibida y está pendiente de aprobación por el propietario del blog.',
	'Entry Posted' => 'Entrada publicada',
	'Your entry has been posted.' => 'La entrada ha sido publicada.',
	'Your entry has been received.' => 'La entrada ha sido recibida.',
	'Return to the <a href="[_1]">blog\'s main index</a>.' => 'Regresar al <a href="[_1]">índice principal del blog</a>.',

## addons/Community.pack/templates/blog/comment_response.mtml

## addons/Community.pack/templates/blog/entry_detail.mtml

## addons/Community.pack/templates/blog/archive_widgets_group.mtml

## addons/Community.pack/templates/blog/entry_form.mtml
	'In order to create an entry on this blog you must first register.' => 'Para crear una entrada en este blog, primero debe registrarse.',
	'You don\'t have permission to post.' => 'No tiene permisos para publicar.',
	'Sign in to create an entry.' => 'Identifíquese para crear una entrada.',
	'Select Category...' => 'Seleccione una categoría...',

## addons/Community.pack/templates/blog/comment_detail.mtml

## addons/Community.pack/templates/blog/entry_create.mtml
	'Entry Form' => 'Formulario de entradas',

## addons/Community.pack/templates/blog/syndication.mtml

## addons/Community.pack/templates/blog/current_category_monthly_archive_list.mtml

## addons/Community.pack/templates/blog/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] comentó en [_3]</a>: [_4]',

## addons/Community.pack/templates/blog/comment_form.mtml

## addons/Community.pack/templates/blog/monthly_archive_list.mtml

## addons/Community.pack/templates/blog/pages_list.mtml

## addons/Community.pack/templates/blog/entry_listing.mtml
	'Recently by <em>[_1]</em>' => 'Novedades por <em>[_1]</em>',

## addons/Community.pack/templates/blog/about_this_page.mtml

## addons/Community.pack/templates/blog/tags.mtml

## addons/Community.pack/templates/blog/entry_metadata.mtml

## addons/Community.pack/templates/blog/entry.mtml
	'Entry Detail' => 'Detalle de la entrada',

## addons/Community.pack/templates/blog/javascript.mtml

## addons/Community.pack/templates/blog/archive_index.mtml

## addons/Community.pack/templates/blog/trackbacks.mtml

## addons/Community.pack/templates/blog/recent_entries.mtml

## addons/Community.pack/templates/blog/sidebar.mtml
	'Activity Widgets' => 'Widgets de actividad',
	'Archive Widgets' => 'Widgets de archivos',

## addons/Community.pack/templates/blog/openid.mtml

## addons/Community.pack/templates/blog/categories.mtml

## addons/Community.pack/templates/blog/comments.mtml
	'The data in #comments-content will be replaced by some calls to paginate script' => 'Los datos en #comments-content se reemplazarán por llamadas al script de paginación',

## addons/Community.pack/templates/blog/search_results.mtml

## addons/Community.pack/templates/blog/comment_listing.mtml

## addons/Community.pack/templates/blog/dynamic_error.mtml

## addons/Community.pack/templates/blog/powered_by.mtml

## addons/Community.pack/templates/blog/tag_cloud.mtml

## addons/Community.pack/templates/blog/recent_assets.mtml

## addons/Community.pack/templates/blog/comment_preview.mtml
	'Comment on [_1]' => 'Comentario en [_1]',

## addons/Community.pack/templates/blog/search.mtml

## addons/Community.pack/templates/forum/main_index.mtml
	'Forum Home' => 'Foro - Inicio',
	'Content Header' => 'Cabecera de contenidos',
	'Popular Entry' => 'Entrada popular',
	'Entry Table' => 'Tabla de entradas',

## addons/Community.pack/templates/forum/page.mtml

## addons/Community.pack/templates/forum/entry_summary.mtml

## addons/Community.pack/templates/forum/content_nav.mtml
	'Start Topic' => 'Comenzar tema',

## addons/Community.pack/templates/forum/entry_response.mtml
	'Thank you for posting a new topic to the forums.' => 'Gracias por publicar un nuevo tema en los foros.',
	'Topic Pending' => 'Tema pendiente',
	'The topic you posted has been received and held for approval by the forum administrators.' => 'El tema que ha publicado se ha recibido y está pendiente de aprobación por parte de los administradores del foro.',
	'Topic Posted' => 'Tema publicado',
	'The topic you posted has been received and published. Thank you for your submission.' => 'El tema que envió se ha recibido y ya está publicado. Gracias por su aportación.',
	'Return to the <a href="[_1]">forum\'s homepage</a>.' => 'Regresar a la página de <a href="[_1]">inicio del foro</a>.',

## addons/Community.pack/templates/forum/comment_response.mtml
	'Reply Submitted' => 'Respuesta enviada',
	'Your reply has been accepted.' => 'Se ha aceptado su respuesta.',
	'Thank you for replying.' => 'Gracias por responder.',
	'Your reply has been received and held for approval by the forum administrator.' => 'Su respuesta ha sido recibida y retenida para su aprobación por el administrador del foro.',
	'Reply Submission Error' => 'Error en el envío de la respuesta',
	'Your reply submission failed for the following reasons: [_1]' => 'El envío de la respuesta falló por alguna de las siguientes razones: [_1]',
	'Return to the <a href="[_1]">original topic</a>.' => 'Regresar al <a href="[_1]">tema original</a>.',

## addons/Community.pack/templates/forum/content_header.mtml

## addons/Community.pack/templates/forum/entry_detail.mtml

## addons/Community.pack/templates/forum/comment_detail.mtml
	'[_1] replied to <a href="[_2]">[_3]</a>' => '[_1] respondió a <a href="[_2]">[_3]</a>',

## addons/Community.pack/templates/forum/entry_create.mtml
	'Start a Topic' => 'Comenzar un tema',

## addons/Community.pack/templates/forum/entry_form.mtml
	'Topic' => 'Tema',
	'Select Forum...' => 'Seleccionar foro...',
	'Forum' => 'Foro',

## addons/Community.pack/templates/forum/syndication.mtml
	'All Forums' => 'Todos los foros',
	'[_1] Forum' => 'Foro [_1]',

## addons/Community.pack/templates/forum/comment_form.mtml
	'Add a Reply' => 'Responder',

## addons/Community.pack/templates/forum/entry_listing.mtml

## addons/Community.pack/templates/forum/entry_metadata.mtml
	'1 Reply' => '1 respuesta',
	'# Replies' => '# respuestas',

## addons/Community.pack/templates/forum/entry.mtml

## addons/Community.pack/templates/forum/javascript.mtml
	'Thanks for signing in,' => 'Gracias por registrarse en,',
	'. Now you can reply to this topic.' => '. Ahora puede contestar en este tema.',
	'You do not have permission to comment on this blog.' => 'No tiene permisos para comentar en este blog.',
	' to reply to this topic.' => ' para responder a este tema.',
	' to reply to this topic,' => ' para responder a este tema,',
	'or ' => 'o ',
	'reply anonymously.' => 'responder anónimamente.',

## addons/Community.pack/templates/forum/entry_table.mtml
	'Recent Topics' => 'Temas recientes',
	'Replies' => 'Respuestas',
	'Last Reply' => 'Última respuesta',
	'Permalink to this Reply' => 'Enlace permanente de esta respuesta',
	'By [_1]' => 'Por [_1]',
	'Closed' => 'Cerrado',
	'Post the first topic in this forum.' => 'Publica el primer tema en este foro.',

## addons/Community.pack/templates/forum/archive_index.mtml

## addons/Community.pack/templates/forum/sidebar.mtml
	'Category Groups' => 'Grupos de categorías',
	'Default Widgets' => 'Widgets predefinidos',

## addons/Community.pack/templates/forum/category_groups.mtml
	'Forum Groups' => 'Grupos de los foros',
	'Last Topic: [_1] by [_2] on [_3]' => 'Último tema: [_1] by [_2] on [_3]',
	'Be the first to <a href="[_1]">post a topic in this forum</a>' => 'Sea el primero en <a href="[_1]">publicar un tema en este foro</a>',

## addons/Community.pack/templates/forum/openid.mtml

## addons/Community.pack/templates/forum/comments.mtml
	'No Replies' => 'Sin respuestas',

## addons/Community.pack/templates/forum/search_results.mtml
	'Topics matching &ldquo;[_1]&rdquo;' => 'Temas que coinciden con &ldquo;[_1]&rdquo;',
	'Topics tagged &ldquo;[_1]&rdquo;' => 'Temas etiquetados con &ldquo;[_1]&rdquo;',
	'Topics' => 'Temas',

## addons/Community.pack/templates/forum/comment_listing.mtml

## addons/Community.pack/templates/forum/dynamic_error.mtml

## addons/Community.pack/templates/forum/entry_popular.mtml
	'Popular topics' => 'Temas populares',

## addons/Community.pack/templates/forum/comment_preview.mtml
	'Reply to [_1]' => 'Responder a [_1]',
	'Previewing your Reply' => 'Vista previa de la respuesta',

## addons/Community.pack/config.yaml
	'Increase reader engagement - deploy features to your website that make it easier for your readers to engage with your content and your company.' => 'Incremente la satisfacción de los lectores - muestre nuevas características en el sitio web para facilitar que los lectores disfruten de sus contenidos y su compañía.',
	'Create best of breed forums - instantly deploy forums that take the best that blogs and forums have to offer.' => 'Cree los mejores foros - cree nuevos foros de forma instantánea, con las mejores características de los blogs y los foros.',
	'Pending Entries' => 'Entradas pendientes',
	'Spam Entries' => 'Entradas spam',
	'Following Users' => 'Usuarios que sigue',
	'Being Followed' => 'Seguidores',
	'Sanitize' => 'Esterilizar',
	'Login Form' => 'Formulario de inicio de sesión',
	'Registration Form' => 'Formulario de registro',
	'Registration Confirmation' => 'Confirmación de registro',
	'Profile View' => 'Ver perfil',
	'Profile Edit Form' => 'Formulario de edición del perfil',
	'Profile Feed' => 'Sindicación del perfil',
	'New Password Form' => 'Formulario de nueva contraseña',
	'New Password Reset Form' => 'Formulario de reinicio de contraseña',
	'Email verification' => 'Verificación del correo',
	'Registration notification' => 'Notificación de registro',
	'New entry notification' => 'Notificación de nueva entrada',
	'Community Themes' => 'Temas de comunidades',
	'Themes that are compatible with the Community themes.' => 'Temas que son compatibles con los temas de comunidades.',
	'Community Blog' => 'Blog de la comunidad',
	'Atom ' => 'Atom ',
	'Entry Response' => 'Respuesta a la entrada',
	'Displays error, pending or confirmation message when submitting an entry.' => 'Muestra un mensaje de error, de pendiente o de confirmación, al enviar una entrada.',
	'Community Forum' => 'Foro de la comunidad',
	'Entry Feed' => 'Sindicación de entradas',
	'Displays error, pending or confirmation message when submitting a entry.' => 'Muestra un mensaje de error, de pendiente o de confirmación al enviar una entrada.',

## addons/Commercial.pack/lib/MT/Commercial/Util.pm
	'Could not install custom field [_1]: field attribute [_2] is required' => 'No se pudo instalar el campo personalizado [_1]: se necesita el atributo [_2]',
	'Could not install custom field [_1] on blog [_2]: the blog already has a field [_1] with a conflicting type' => 'No se pudo instalar el campo personalizado [_1] en el blog [_2]: el blog ya tiene un campo [_1] con un tipo distinto',
	'Blog [_1] using template set [_2]' => 'El blog [_1] está usando el conjunto de plantillas [_2]',
	'About' => 'Sobre mi',
	'_PTS_REPLACE_THIS' => '<p><strong>Reemplace el texto de ejemplo con sus propios datos.</strong></p>',
	'_PTS_SAMPLE_ABOUT' => '<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In nec tellus sed turpis varius sagittis. Nullam pulvinar. Fusce dapibus neque pellentesque nulla. Maecenas condimentum quam. Vestibulum pretium fringilla quam. Nam elementum. Suspendisse odio magna, aliquam vitae, vulputate et, dignissim at, pede. Integer pellentesque orci at nibh. Morbi ante.</p>

<p>Maecenas convallis mattis justo. Ut mauris sapien, consequat a, bibendum vitae, sagittis ac, nisi. Nulla et sapien. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Ut condimentum turpis ut elit. Quisque ultricies sollicitudin justo. Duis vitae magna nec risus pulvinar ultricies.</p>
',
	'_PTS_EDIT_LINK' => '
<!-- borrar este enlace después de la edición -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl + \'?__mode=view&_type=page&id=\' + page_id + \'&blog_id=\' + blog_id; return false">Editar este contenido</a>
</p>
',
	'Could not create page: [_1]' => 'No se pudo crear la página: [_1]',
	'Created page \'[_1]\'' => 'Se creó la página \'[_1]\'',
	'_PTS_CONTACT' => 'Contacto',
	'_PTS_SAMPLE_CONTACT' => '<p>Nos encantará tener noticias suyas. Envíenos un mensaje a correo (arroba) dominio.com</p>',
	'Welcome to our new website!' => '¡Bienvenido a nuestro nuevo sitio!',
	'_PTS_SAMPLE_WELCOME' => '
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In nec tellus sed turpis varius sagittis. Nullam pulvinar. Fusce dapibus neque pellentesque nulla. Maecenas condimentum quam. Aliquam erat volutpat. Ut placerat porta nibh. Donec vitae nulla. Pellentesque nisi leo, pretium a, gravida quis, sollicitudin non, eros. Vestibulum pretium fringilla quam. Nam elementum. Suspendisse odio magna, aliquam vitae, vulputate et, dignissim at, pede. Integer pellentesque orci at nibh. Morbi ante.</p>

<p>Maecenas convallis mattis justo. Ut mauris sapien, consequat a, bibendum vitae, sagittis ac, nisi. Nulla et sapien. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Ut condimentum turpis ut elit. Quisque ultricies sollicitudin justo. Duis vitae magna nec risus pulvinar ultricies. Aliquam sagittis volutpat metus.</p>

<p>Sed enim. Integer hendrerit, arcu ac pretium nonummy, velit turpis faucibus risus, pulvinar egestas enim elit sed ante. Curabitur orci diam, placerat a, faucibus id, condimentum vitae, magna. Etiam enim massa, convallis quis, rutrum vitae, porta quis, turpis.</p>
',
	'New design launched using Movable Type' => 'Nuevo diseño lanzado utilizando Movable Type',
	'_PTS_SAMPLE_NEWDESIGN' => '
<p>Nuestro sitio tiene un nuevo diseño gracias a <a href="http://www.movabletype.com/">Movable Type</a> y el Conjunto de Plantillas Universal. Este conjunto le permite a cualquier persona poner en marcha un nuevo web con Movable Type. Es realmente fácil, y solo con un par de clics. Seleccione un nombre para su nuevo sitio, seleccione el Conjunto de Plantillas Universal y publique. ¡Voilà! El nuevo sitio. ¡Gracias Movable Type!</p>
',
	'Could not create entry: [_1]' => 'No se pudo crear la entrada: [_1]',
	'John Doe' => 'Pobrecito Hablador',
	'Great new site. I can\'t wait to try Movable Type. Congrats!' => 'Gran sitio. ¡Estoy impaciente por probar Movable Type, felicidades!',
	'Created entry and comment \'[_1]\'' => 'Se creó la entrada y el comentario \'[_1]\'',

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Show' => 'Mostrar',
	'Date & Time' => 'Fecha & Hora',
	'Date Only' => 'Fecha solo',
	'Time Only' => 'Hora solo',
	'Please enter all allowable options for this field as a comma delimited list' => 'Por favor, introduzca todas las opciones permitidas a este campo en forma de lista de elementos separados por comas',
	'Custom Fields' => 'Campos personalizados',
	'[_1] Fields' => 'Campos de [_1]',
	'Edit Field' => 'Editar campo',
	'Invalid date \'[_1]\'; dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Fecha no válida \'[_1]\'; las fechas deben estar en el formato YYYY-MM-DD HH:MM:SS.',
	'Invalid date \'[_1]\'; dates should be real dates.' => 'Fecha no válida \'[_1]\'; debe ser una fecha real.',
	'Please enter valid URL for the URL field: [_1]' => 'Por favor, introduzca una URL válida en el campo de la URL: [_1]',
	'Please enter some value for required \'[_1]\' field.' => 'Por favor, introduzca un valor en el campo obligatorio \'[_1]\'.',
	'Please ensure all required fields have been filled in.' => 'Por favor, asegúrese de que todos los campos se han introducido.',
	'The template tag \'[_1]\' is an invalid tag name.' => 'La etiqueta de plantilla \'[_1]\' es un nombre de etiqueta inválido.',
	'The template tag \'[_1]\' is already in use.' => 'La etiqueta de plantilla \'[_1]\' ya está en uso.',
	'The basename \'[_1]\' is already in use.' => 'El nombre base \'[_1]\' ya está en uso.',
	'You must select other type if object is the comment.' => 'Debe seleccionar otro tipo si el objeto es un comentario.',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'Personalice los formularios y campos de las entradas, páginas, carpetas, categorías y usuarios, guardando los datos exactos que necesite.',
	' ' => ' ',
	'Single-Line Text' => 'Texto - Una sola línea',
	'Multi-Line Text' => 'Texto multilínea',
	'Checkbox' => 'Casilla',
	'Date and Time' => 'Fecha y Hora',
	'Drop Down Menu' => 'Menú desplegable',
	'Radio Buttons' => 'Botones radiales',
	'Embed Object' => 'Embeber objeto',
	'Post Type' => 'Tipo de entrada',

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	'Are you sure you have used a \'[_1]\' tag in the correct context? We could not find the [_2]' => '¿Está seguro de que ha utilizado la etiqueta \'[_1]\' en el contexto adecuado? No se encontró el [_2]',
	'You used an \'[_1]\' tag outside of the context of the correct content; ' => 'Ha utilizado una etiqueta \'[_1]\' fuera del contexto del contenido correcto;',

## addons/Commercial.pack/lib/CustomFields/Upgrade.pm
	'Moving metadata storage for pages...' => 'Trasladando los metadatos de las páginas...',

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Restoring custom fields data stored in MT::PluginData...' => 'Restaurando los datos de los campos personalizados guardados en MT::PluginData...',
	'Restoring asset associations found in custom fields ( [_1] ) ...' => 'Restaurando las asociaciones de los ficheros multimedia de los campos personalizados ( [_1] ) ...',
	'Restoring url of the assets associated in custom fields ( [_1] )...' => 'Restaurando url de los ficheros multimedia asociados en los campos personalizados ( [_1] )...',

## addons/Commercial.pack/lib/CustomFields/Theme.pm
	'[_1] custom fields' => '[_1] campos personalizados',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'Field' => 'Campo',

## addons/Commercial.pack/tmpl/export_field.tmpl
	'Field Name' => 'Nombre del campo',
	'Field Type' => 'Tipo de campo',
	'Object' => 'Objeto',

## addons/Commercial.pack/tmpl/edit_field.tmpl
	'Edit Custom Field' => 'Editar campo personalizado',
	'Create Custom Field' => 'Crear campo personalizado',
	'The selected fields(s) has been deleted from the database.' => 'Los campos seleccionados han sido borrados de la base de datos.',
	'You must enter information into the required fields highlighted below before the Custom Field can be created.' => 'Antes de que pueda crear el campo personalizado debe introducir la información en los campos obligatorios resaltados abajo.',
	'Manage Custom Fields' => 'Administrar campos personalizados',
	'Create New Fields' => 'Crear nuevos campos',
	'System Object' => 'Objeto del sistema',
	'Choose the system object where this Custom Field should appear.' => 'Seleccione el objeto del sistema donde aparecerá el campo personalizado.',
	'Select...' => 'Seleccionar...',
	'Required?' => '¿Obligatorio?',
	'Is data entry required in this Custom Field?' => '¿Se necesita la introducción de datos en este campo personalizado?',
	'Must the user enter data into this Custom Field before the object may be saved?' => '¿El usuario debe introducir datos en este campo personalizado antes de que el objeto se guarde?',
	'Default' => 'Predefinido',
	'You must save this Custom Field before setting a default value.' => 'Debe guardar este campo personalizado antes de indicar un valor predefinido.',
	'_CF_BASENAME' => 'Nombre base',
	'The basename must be unique within this installation of Movable Type.' => 'El nombre base debe ser único en esta instalación de Movable Type.',
	'Warning: Changing this field\'s basename may require changes to existing templates.' => 'Atención: Si cambia el nombre base de este campo, quizás se necesiten cambios en las plantillas existentes.',
	'Template Tag' => 'Etiqueta de plantilla',
	'Create a template tag for this Custom Field.' => 'Crear una etiqueta de plantilla para este campo personalizado.',
	'Example Template Code' => 'Código de ejemplo',
	'Show In These [_1]' => 'Mostrar en estos [_1]',
	'Save this field (s)' => 'Guardar este campo (s)',
	'field' => 'campo',
	'fields' => 'campos',
	'Delete this field (x)' => 'Borrar este campo (x)',

## addons/Commercial.pack/tmpl/reorder_fields.tmpl
	'open' => 'abrir',
	'click-down and drag to move this field' => 'haga clic y arrastre el campo para moverlo',
	'click to %toggle% this box' => 'haga clic para %toggle% esta casilla',
	'use the arrow keys to move this box' => 'use las flechas para mover esta caja',
	', or press the enter key to %toggle% it' => ', o presione la tecla enter para %toggle%',

## addons/Commercial.pack/tmpl/list_field.tmpl
	'New [_1] Field' => 'Nuevo campo - [_1]',
	'Delete selected fields (x)' => 'Borrar campos seleccionados (x)',
	'No fields could be found.' => 'No se encontraron campos.',
	'Display on' => 'Mostrar en',
	'System-Wide' => 'Todo el sistema',

## addons/Commercial.pack/tmpl/asset-chooser.tmpl
	'Choose [_1]' => 'Seleccionar [_1]',
	'Remove [_1]' => 'Borrar [_1]',

## addons/Commercial.pack/tmpl/cfg_customfields.tmpl
	'Data have been saved to custom fields.' => 'Se han cuargado los datos en los campos personalizados.',
	'Save changes to blog (s)' => 'Guardar los cambios en el blog (s)',
	'No custom fileds could be found. <a href="[_1]">Create a field</a> now.' => 'No se han encontrado campos personalizados. <a href="[_1]">Cree un campo</a> ahora.',

## addons/Commercial.pack/tmpl/category_fields.tmpl
	'Show These Fields' => 'Mostrar estos campos',

## addons/Commercial.pack/templates/professional/notify-entry.mtml

## addons/Commercial.pack/templates/professional/blog_index.mtml
	'Header' => 'Cabecera',
	'Footer' => 'Pie',

## addons/Commercial.pack/templates/professional/main_index.mtml

## addons/Commercial.pack/templates/professional/page.mtml
	'Page Detail' => 'Detalle de la página',

## addons/Commercial.pack/templates/professional/entry_summary.mtml
	'Entry Metadata' => 'Entrada de los Metadatos',

## addons/Commercial.pack/templates/professional/comment_response.mtml

## addons/Commercial.pack/templates/professional/commenter_notify.mtml

## addons/Commercial.pack/templates/professional/recent_entries_expanded.mtml
	'By [_1] | Comments ([_2])' => 'Por [_1] | Commentarios ([_2]) ',

## addons/Commercial.pack/templates/professional/footer-email.mtml

## addons/Commercial.pack/templates/professional/verify-subscribe.mtml

## addons/Commercial.pack/templates/professional/new-ping.mtml

## addons/Commercial.pack/templates/professional/comment_detail.mtml

## addons/Commercial.pack/templates/professional/comment_form.mtml

## addons/Commercial.pack/templates/professional/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] comentó en [_3]</a>: [_4]',

## addons/Commercial.pack/templates/professional/comment_throttle.mtml

## addons/Commercial.pack/templates/professional/signin.mtml

## addons/Commercial.pack/templates/professional/new-comment.mtml

## addons/Commercial.pack/templates/professional/footer.mtml
	'Powered By (Footer)' => 'Powered By (Pie)',
	'Footer Links' => 'Enlaces del pie',

## addons/Commercial.pack/templates/professional/tags.mtml

## addons/Commercial.pack/templates/professional/navigation.mtml
	'Home' => 'Inicio',

## addons/Commercial.pack/templates/professional/entry_metadata.mtml

## addons/Commercial.pack/templates/professional/javascript.mtml

## addons/Commercial.pack/templates/professional/trackbacks.mtml

## addons/Commercial.pack/templates/professional/sidebar.mtml
	'Main Sidebar' => 'Barra lateral principal',
	'Blog Activity' => 'Actividad del blog',
	'Blog Archives' => 'Archivos del blog',

## addons/Commercial.pack/templates/professional/powered_by_footer.mtml

## addons/Commercial.pack/templates/professional/openid.mtml

## addons/Commercial.pack/templates/professional/categories.mtml

## addons/Commercial.pack/templates/professional/comments.mtml

## addons/Commercial.pack/templates/professional/search_results.mtml

## addons/Commercial.pack/templates/professional/header.mtml
	'Navigation' => 'Navegación',

## addons/Commercial.pack/templates/professional/comment_listing.mtml

## addons/Commercial.pack/templates/professional/dynamic_error.mtml

## addons/Commercial.pack/templates/professional/footer_links.mtml
	'Links' => 'Enlaces',

## addons/Commercial.pack/templates/professional/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/recent_assets.mtml

## addons/Commercial.pack/templates/professional/comment_preview.mtml

## addons/Commercial.pack/templates/professional/search.mtml

## addons/Commercial.pack/templates/professional/blogs.mtml
	'Entries ([_1]) Comments ([_2])' => 'Entradas ([_1]) Comentarios ([_2])',

## addons/Commercial.pack/templates/professional/commenter_confirm.mtml

## addons/Commercial.pack/config.yaml
	'Professional designed, well structured and easily adaptable web site. You can customize default pages, footer and top navigation easily.' => 'Sitio web con diseños profesionales, bien estructurados y fácilmente adaptables. Puede personalizar de forma sencilla las páginas predefinidas, los pies y la navegación.',
	'_PWT_ABOUT_BODY' => '_PWT_ABOUT_BODY',
	'_PWT_CONTACT_BODY' => '_PWT_CONTACT_BODY',
	'_PWT_HOME_BODY' => '_PWT_HOME_BODY',
	'Photo' => 'Foto',
	'Embed' => 'Embeber',
	'Custom Fileds' => 'Campos personalizados',
	'Updating Universal Template Set to Professional Website set...' => 'Actualizar el conjuntto de plantillas Universal al conjunto Sitio Web Profesional...',
	'Professional Website' => 'Web Profesional',
	'Themes that are compatible with the Professional Website template set.    ' => 'Temas compatibles con el conjunto de plantillas Sitio Web Profesional.',
	'Blog Index' => 'Índice del blog',
	'Recent Entries Expanded' => 'Entradas recientes expandidas',

## addons/Enterprise.pack/lib/MT/Enterprise/Upgrade.pm
	'Fixing binary data for Microsoft SQL Server storage...' => 'Reparando datos binarios para Microsoft SQL Server...',

## addons/Enterprise.pack/lib/MT/Enterprise/Wizard.pm
	'PLAIN' => 'PLAIN',
	'CRAM-MD5' => 'CRAM-MD5',
	'Digest-MD5' => 'Digest-MD5',
	'Login' => 'Login',
	'Found' => 'Encontrado',
	'Not Found' => 'No encontrado',

## addons/Enterprise.pack/lib/MT/Enterprise/BulkCreation.pm
	'Format error at line [_1]: [_2]' => 'Error en el formato a la línea [_1]: [_2]',
	'Invalid command: [_1]' => 'Orden inválida',
	'Invalid number of columns for [_1]' => 'Número de columnas para [_1] inválido',
	'Invalid user name: [_1]' => 'Nombre de usuario inválido: [_1]',
	'Invalid display name: [_1]' => 'Nombre mostrado inválido: [_1]',
	'Invalid email address: [_1]' => 'Dirección de correo electrónico inválida: [_1]',
	'Invalid language: [_1]' => 'Idioma inválido: [_1]',
	'Invalid password: [_1]' => 'Contraseña inválida: [_1]',
	'Invalid password recovery phrase: [_1]' => 'Frase de recuperación de contraseña: [_1]',
	'Invalid weblog name: [_1]' => 'Nombre de weblog inválido: [_1]',
	'Invalid weblog description: [_1]' => 'Descripción de weblog inválida: [_1]',
	'Invalid site url: [_1]' => 'URL del sitio inválida: [_1]',
	'Invalid site root: [_1]' => 'Raíz del sitio inválida: [_1]',
	'Invalid timezone: [_1]' => 'Zona horaria inválida: [_1]',
	'Invalid new user name: [_1]' => 'Nuevo nombre de usuario inválido: [_1]',
	'A user with the same name was found.  Register was not processed: [_1]' => 'Un usuario con el mismo nombre ha sido encontrado.  El registro no ha sido procesado: [_1]',
	'Blog for user \'[_1]\' can not be created.' => 'El blog por el usuario [_1] no puede ser creado.',
	'Blog \'[_1]\' for user \'[_2]\' has been created.' => 'El blog [_1] por el usuario [_2] ha sido creado.',
	'Error assigning weblog administration rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable weblog administrator role was found.' => 'Error en la asignación de los derechos de administración al usuario [_1] (ID: [_2]) para el weblog [_3] (ID: [_4]).  Ningún rol de administrador apropiado ha sido encontrado.',
	'Permission granted to user \'[_1]\'' => 'Los derechos han sido atribuidos al usuario [_1]',
	'User \'[_1]\' already exists. Update was not processed: [_2]' => 'El usuario [_1] ya existe.  La actualización no ha sido efectuada: [_2]',
	'User cannot be updated: [_1].' => 'Usuario no puede ser actualizado [_1].',
	'User \'[_1]\' not found.  Update was not processed.' => 'Usuario [_1] no encontrado.  La actualización no ha sido efectuada.',
	'User \'[_1]\' has been updated.' => 'Usuario [_1] ha sido actualizado.',
	'User \'[_1]\' was found, but delete was not processed' => 'Usuario [_1] ha sido encontrado pero la supresión no ha sido efectuada. ',
	'User \'[_1]\' not found.  Delete was not processed.' => 'El usuario [_1] no ha sido encontrada.  La supresión no ha sido efectuada.',
	'User \'[_1]\' has been deleted.' => 'El usuario [_1] ha sido borrado.',

## addons/Enterprise.pack/lib/MT/Enterprise/CMS.pm
	'Add [_1] to a blog' => 'Añadir [_1] al blog',
	'You can not create associations for disabled groups.' => 'No puede crear asociaciones con grupos inhabilitados.',
	'Assign Role to Group' => 'Asignar rol al grupo',
	'Add a group to this blog' => 'Asignar un grupo a este blog',
	'Grant permission to a group' => 'Otorgar permiso a un grupo',
	'Movable Type Enterprise has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.' => 'Movable Type Enterprise acaba de intentar deshabilitar su cuenta durante una sincronización con el directorio externo. Algunas de las opciones de configuración de la administración externa de usuarios deben ser incorrectas. Por favor, corrija la configuración antes de continuar.',
	'Group requires name' => 'El grupo requiere un nombre',
	'Invalid group' => 'Grupo inválido',
	'Add Users to Group [_1]' => 'Añadir usuarios al grupo [_1]',
	'Groups' => 'Grupos',
	'Users & Groups' => 'Usuarios y grupos',
	'User Groups' => 'Grupos de usuarios',
	'Group load failed: [_1]' => 'La carga del grupo ha fallado: [_1]',
	'User load failed: [_1]' => 'La carga del usuario ha fallado: [_1]',
	'User \'[_1]\' (ID:[_2]) removed from group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Usuario [_1] (ID: [_2]) ha sido borrado del grupo [_3] (ID:[_4]) por [_5]',
	'User \'[_1]\' (ID:[_2]) was added to group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Usuario[_1] (ID: [_2]) ha sido añadido del grupo [_3] (ID:[_4]) por [_5]',
	'Group Profile' => 'Perfil de grupo',
	'Author load failed: [_1]' => 'La carga del autor ha fallado: [_1]',
	'Invalid user' => 'Usuario inválido',
	'Assign User [_1] to Groups' => 'Usuario [_1] asignado a los grupos',
	'Select Groups' => 'Seleccionar grupos',
	'Group' => 'Grupo',
	'Groups Selected' => 'Grupos seleccionados',
	'Type a group name to filter the choices below.' => 'Tapea el nombre de un grupo para filtrar las opciones que se encuentran aquí debajo.',
	'Group Name' => 'Nombre del grupo',
	'Search Groups' => 'Buscar grupos',
	'Bulk import cannot be used under external user management.' => 'La importación masiva no puede ser usuada en la administración de usuarios externos.',
	'Bulk management' => 'Administración masiva',
	'No record found in the file.  Make sure the file uses CRLF as the line ending character.' => 'No se encontró ningún registro en el fichero. Asegúrate de que el fichero utiliza CRLF como carácter de fin de línea.',
	'Registered [quant,_1,user,users], updated [quant,_2,user,users], deleted [quant,_3,user,users].' => '[quant,_1,Usuario registro,Usuariosregistrados], [quant,_2,usuario actualizado,usuarios actualizados], [quant,_3,usuario eliminado,usuarios eliminados].',
	'The group' => 'El grupo',
	'User/Group' => 'Usuario/Grupo',
	'A user can\'t change his/her own username in this environment.' => 'Un usuario no puede cambiar su propio nombre en este contexto.',
	'An error occurred when enabling this user.' => 'Ocurrió un error cuando se habilitaba este usuario.',

## addons/Enterprise.pack/lib/MT/Auth/LDAP.pm
	'User [_1]([_2]) not found.' => 'Usuario [_1]([_2]) sin resultado.',
	'User \'[_1]\' cannot be updated.' => 'Usuario [_1] no puede ser modificado.',
	'User \'[_1]\' updated with LDAP login ID.' => 'Usuario [_1] modificado con el ID de login LDAP.',
	'LDAP user [_1] not found.' => 'Usuario LDAP [_1] sin resultado.',
	'User [_1] cannot be updated.' => 'Usuario [_1] no puede ser actualizado.',
	'Failed login attempt by user \'[_1]\' deleted from LDAP.' => 'Login entrado sin suceso por el usuario [_1] borrado de LDAP.',
	'User \'[_1]\' updated with LDAP login name \'[_2]\'.' => 'Usuario [_1] actualizado con el nombre de login LDAP [_2]',
	"Failed login attempt by user \'[_1]\'. A user with that\nusername already exists in the system with a different UUID." => "Intento fallido de inicio de sesión por el usuario \'[_1]\'. Ya existe
en el sistema un usuario con ese nombre y diferente UUID.",
	'User \'[_1]\' account is disabled.' => 'La cuenta del usuario [_1] ha sido desactivada.',
	'LDAP users synchronization interrupted.' => 'La sincronización de los usuarios LDAP ha sido interrumpida.',
	'Loading MT::LDAP failed: [_1]' => 'El cargamiento de MT::LDAP falló: [_1]',
	'External user synchronization failed.' => 'La sincronización de los usuarios externos falló.',
	'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'Un intento de desactivación de todos los administradores del sistema ha sido efectuada.  La sincronización de los usuarios ha sido interrumpida.',
	'The following users\' information were modified:' => 'Las informaciones de los siguientes usuarios han sido actualizadas:',
	'The following users were disabled:' => 'Los siguientes usuarios han sido desactivados:',
	'LDAP users synchronized.' => 'Los usuarios LDAP han sido sincronizados:',
	'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute is set.' => 'La sincronización de los grupos no puede ser realizada sin que LDAPGroupIdAttribute y/o LDAPGroupNameAttribute sean iniciados.',
	'LDAP groups synchronized with existing groups.' => 'Grupos LDAP sincronizados con los grupos existentes.',
	'The following groups\' information were modified:' => 'Las informaciones de los siguientes grupos han sido actualizados.',
	'No LDAP group was found using given filter.' => 'Ningún grupo LDAP ha sido encontrado con el filtro dado.',
	"Filter used to search for groups: [_1]\nSearch base: [_2]" => "Filtro usado para buscar grupos: [_1]
Búsqueda base: [_2]",
	'(none)' => '(ninguno)',
	'The following groups were deleted:' => 'Los siguientes grupos han sido borrados:',
	'Failed to create a new group: [_1]' => 'Falló la creación de un nuevo grupo: [_1]',
	'[_1] directive must be set to synchronize members of LDAP groups to Movable Type Enterprise.' => 'La instrucción [_1] debe ser completada para sincronizar los miembros de los grupos LDAP en MT Enterprise.',
	'Members removed: ' => 'Miembros borrados:',
	'Members added: ' => 'Miembros añadidos:',
	'Memberships of the group \'[_2]\' (#[_3]) has been changed in synchronizing with external directory.' => 'Memberships del grupo [_2] (#[_3]) ha sido cambiado durante la sincroización con el directorio externo.',
	'LDAPUserGroupMemberAttribute must be set to enable synchronize members of groups.' => 'LDAPUserGroupMemberAttribute debe ser completado para permitir la sincronización de los miembros de los grupos.',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/MSSQLServer.pm
	'PublishCharset [_1] is not supported in this version of MS SQL Server Driver.' => 'PublishCharset [_1] no es soportada en esta versión del driver MS SQL Server.',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/UMSSQLServer.pm
	'This version of UMSSQLServer driver requires DBD::ODBC version 1.14.' => 'Esta versión del Driver UMSSQLServer requiere DBD::ODBC versión 1.14.',
	'This version of UMSSQLServer driver requires DBD::ODBC compiled with Unicode support.' => 'Esta versión del Driver UMSSQLServer requiere DBD::ODBC compilado con el soporte Unicode.',

## addons/Enterprise.pack/lib/MT/Group.pm

## addons/Enterprise.pack/lib/MT/LDAP.pm
	'Invalid LDAPAuthURL scheme: [_1].' => 'Scheme LDAPAuthURL inválido: [_1].',
	'Error connecting to LDAP server [_1]: [_2]' => 'Error a la conexión al server LDAP [_1]: [_2]',
	'User not found on LDAP: [_1]' => 'Usuario no encontrado en LDAP: [_1]',
	'Binding to LDAP server failed: [_1]' => 'La asociación con el server LDAP ha fallado: [_1]',
	'More than one user with the same name found on LDAP: [_1]' => 'Más de un usuario con el mismo nombre ha sido encontrado en LDAP: [_1]',

## addons/Enterprise.pack/tmpl/dialog/select_groups.tmpl
	'You need to create some groups.' => 'Necesita crear algunos grupos.',
	'Before you can do this, you need to create some groups. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a group.' => 'Antes de poder hacer esto, usted debe crear algunos grupos. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Haga clic aquí</a> para crear un grupo.',

## addons/Enterprise.pack/tmpl/include/list_associations/page_title.group.tmpl
	'Users &amp; Groups for [_1]' => 'Usuarios &amp; Grupos de [_1]',
	'Group Associations for [_1]' => 'Asociaciones de grupos de [_1]',

## addons/Enterprise.pack/tmpl/include/users_content_nav.tmpl
	'Users &amp; Groups' => 'Usuarios &amp; grupos',

## addons/Enterprise.pack/tmpl/include/group_table.tmpl
	'group' => 'grupo',
	'groups' => 'grupos',
	'Enable selected group (e)' => 'Habilitar grupo seleccionado (e)',
	'Disable selected group (d)' => 'Deshabilitar grupo seleccionado (d)',
	'Remove selected group (d)' => 'Borrar grupo seleccionado (d)',
	'Only show enabled groups' => 'Solo muestra los grupos activados',
	'Only show disabled groups' => 'Solo muestra los grupos desactivados',

## addons/Enterprise.pack/tmpl/list_group.tmpl
	'[_1]: User&rsquo;s Groups' => 'Usuarios de los grupos [_1]',
	'Groups: System Wide' => 'Grupos: Todo el Sistema',
	'You have successfully disabled the selected group(s).' => 'usted ha desactivado el(los) grupo(s) seleccionado(s) con suceso',
	'You have successfully enabled the selected group(s).' => 'Usted ha activado el(los) grupo(s) seleccionad(s) con suceso',
	'You have successfully deleted the groups from the Movable Type system.' => 'Usted ha borrado con suceso los grupos del sistema Movable Type.',
	'You have successfully synchronized groups\' information with the external directory.' => 'Usted ha sincronizado con suceso la información de los grupos con el directorio externo.',
	'The user <em>[_1]</em> is currently disabled.' => 'El usuario <em>[_1]</em> está actualmente desactivado.',
	'You can not add disabled users to groups.' => 'Usted no puede añadir usuarios inactivos a los grupos.',
	'Add [_1] to another group' => 'Añadir [_1] a otro grupo',
	'Create Group' => 'Crear Grupo',
	'You did not select any [_1] to remove.' => 'No ha seleccionado ningún [_1] a borrar.',
	'Are you sure you want to remove this [_1]?' => '¿Está seguro de querer borrar esto [_1]?',
	'Are you sure you want to remove the [_1] selected [_2]?' => '¿Está seguro de querer borrar el [_1] seleccionado [_2]?',
	'to remove' => 'para borrar',

## addons/Enterprise.pack/tmpl/create_author_bulk_end.tmpl
	'All users updated successfully!' => '¡Todos los usuarios han sido actualizados con suceso!',
	'An error occurred during the updating process. Please check your CSV file.' => 'Un error se ha producido durante la actualización.  Por favor verifique su fichero CSV.',

## addons/Enterprise.pack/tmpl/list_group_member.tmpl
	'[_1]: Group Members' => '[_1]: Miembros del grupo',
	'<em>[_1]</em>: Group Members' => '<em>[_1]</em>: Miembros del grupo',
	'You have successfully deleted the users.' => 'Usted ha borrado con suceso los usuarios.',
	'You have successfully added new users to this group.' => 'Usted ha añadido con suceso nuevos usuarios a este grupo.',
	'You have successfully synchronized users\' information with external directory.' => 'Usted ha sincronizado con suceso las informaciones de los usuarios con el directorio externo.',
	'Some ([_1]) of the selected users could not be re-enabled because they were no longer found in LDAP.' => 'Algunos ([_1]) de los usuarios seleccionados no han podido ser reactivados porque no han sido encontrados en LDAP.',
	'You have successfully removed the users from this group.' => 'Usted ha borrado con suceso los usuarios de este grupo.',
	'Group Disabled' => 'Grupo desactivado',
	'You can not add users to a disabled group.' => 'Usted no puede añadir usuarios a un grupo desactivado.',
	'Add user to [_1]' => 'Añadir usuarios a [_1]',
	'member' => 'miembro',
	'Show Enabled Members' => 'Mostrar los miembros activados',
	'Show Disabled Members' => 'Mostrar los miembros desactivados',
	'Show All Members' => 'Mostrar todos los miembros',
	'None.' => 'Ninguno.',
	'(Showing all users.)' => '(Mostrar todos los usuarios.)',
	'Showing only users whose [_1] is [_2].' => 'Mostrar solo los usuarios que el [_1] es [_2].',
	'Show' => 'Mostrar',
	'all' => 'todos',
	'only' => 'solo',
	'users where' => 'usuarios donde',
	'No members in group' => 'Ningún miembro en el grupo',
	'Only show enabled users' => 'Solo mostrar los usuarios activados',
	'Only show disabled users' => 'Solo mostrar los usuarios desactivados',
	'Are you sure you want to remove this [_1] from this group?' => '¿Está seguro de querer borrar este [_1] de este grupo?',
	'Are you sure you want to remove the [_1] selected [_2] from this group?' => '¿Está seguro de querer borrar el [_1] seleccionado [_2] de este grupo?',

## addons/Enterprise.pack/tmpl/author_bulk.tmpl
	'Manage Users in bulk' => 'Administrar los usuarios por lote',
	'_USAGE_AUTHORS_2' => '_USAGE_AUTHORS_2',
	'Upload source file' => 'Suba el fichero fuente',
	'Specify the CSV-formatted source file for upload' => 'Defina el fichero fuente en formato CSV para subirlo',
	'Source File Encoding' => 'Codificación del archivo fuente',
	'Upload (u)' => 'Suba (u)',

## addons/Enterprise.pack/tmpl/cfg_ldap.tmpl
	'Authentication Configuration' => 'Configuración de la autentificación',
	'You must set your Authentication URL.' => 'Configure la URL de identificación.',
	'You must set your Group search base.' => 'Configure la base de búsqueda de Grupos.',
	'You must set your UserID attribute.' => 'Configure su parámetro UserID.',
	'You must set your email attribute.' => 'Configure su parámetro de correo electrónico.',
	'You must set your user fullname attribute.' => 'Configure su parámetro de nombre completo',
	'You must set your user member attribute.' => 'Configure su parámetro de nombre de usuario.',
	'You must set your GroupID attribute.' => 'Configure su parámetro de GroupID.',
	'You must set your group name attribute.' => 'Configure el parámetro de su nombre de grupo.',
	'You must set your group fullname attribute.' => 'Configure el parámetro del nombre completo del grupo.',
	'You must set your group member attribute.' => 'Configure el parámetro de su nombre de grupo.',
	'You can configure your LDAP settings from here if you would like to use LDAP-based authentication.' => 'Ahora puede configurar sus parámetros LDAP desde aquí si desea utilizar una identificaión basada sobre LDAP. ',
	'Your configuration was successful.' => 'Su configuración se ha producido con suceso.',
	'Click \'Continue\' below to configure the External User Management settings.' => 'Haga clic en continuar debajo para configurar la administración de usuario externo.',
	'Click \'Continue\' below to configure your LDAP attribute mappings.' => 'Haga clic en continuar debajo para configurar el mapeado de los atributos LDAP.',
	'Your LDAP configuration is complete.' => 'Su configuración LDAP ha sido completada.',
	'To finish with the configuration wizard, press \'Continue\' below.' => 'Para terminar con la configuración, haga clic en el botón continuar debajo.',
	'An error occurred while attempting to connect to the LDAP server: ' => 'Un error se ha producido durante la conexión LDAP.',
	'Use LDAP' => 'Utilizar LDAP',
	'Authentication URL' => 'URL de Identificación',
	'The URL to access for LDAP authentication.' => 'La URL para acceder a la identificación LDAP',
	'Authentication DN' => 'DN de la Identificación',
	'An optional DN used to bind to the LDAP directory when searching for a user.' => 'Un DN opcional utilizado para asociarse con el directorio LDAP cuando se busca un usuario.',
	'Authentication password' => 'Contraseña de la Identificación',
	'Used for setting the password of the LDAP DN.' => 'Utilizado para iniciar la contraseña del DN del LDAP.',
	'SASL Mechanism' => 'Mecanismo SASL',
	'The name of SASL Mechanism to use for both binding and authentication.' => 'El nombre del mecanismo SASL para la asociación y la identificación.',
	'Test Username' => 'Verificar el nombre de usuario',
	'Test Password' => 'Verificar la contraseña',
	'Enable External User Management' => 'Activar la administración de los usuarios externos',
	'Synchronization Frequency' => 'Frecuencia de sincronización',
	'Frequency of synchronization in minutes. (Default is 60 minutes)' => 'Frecuencia de sincronización en minutos. (Por Defecto son 60 minutos)',
	'15 Minutes' => '15 Minutos',
	'30 Minutes' => '30 Minutos',
	'60 Minutes' => '60 Minutos',
	'90 Minutes' => '90 Minutos',
	'Group search base attribute' => 'Parámetro de la base de búsqueda de los grupos',
	'Group filter attribute' => 'Parámetro de filtro de grupos',
	'Search Results (max 10 entries)' => 'Resultados de la búsqueda (máx. 10 entradas)',
	'CN' => 'CN',
	'No groups were found with these settings.' => 'Ningún grupo ha sido encontrado bajo estos parámetros.',
	'Attribute mapping' => 'Mapeado de los atributos',
	'LDAP Server' => 'LDAP Server',
	'Other' => 'Otro',
	'User ID attribute' => 'Parámetro del Usuario ID',
	'Email Attribute' => 'Parámetro del correo electrónico',
	'User fullname attribute' => 'Parámetro del nombre completo',
	'User member attribute' => 'Parámetro del nombre de usuario',
	'GroupID attribute' => 'Parámetro del Grupo ID',
	'Group name attribute' => 'Parámetro del nombre del grupo',
	'Group fullname attribute' => 'Parámetro del nombre completo del grupo',
	'Group member attribute' => 'Parámetro del nombre de usuario del grupo',
	'Search result (max 10 entries)' => 'Resultado de la búsqueda (máx. 10 entradas)',
	'Group Fullname' => 'Nombre completo del grupo',
	'Group Member' => 'Nombre de usuario del grupo',
	'No groups could be found.' => 'Ningún grupo ha sido encontrado',
	'User Fullname' => 'Nombre completo el usuario',
	'No users could be found.' => 'Ningún usuario ha sido encontrado',
	'Test connection to LDAP' => 'Verificación de la conexión LDAP',
	'Test search' => 'Verificación de la búsqueda',

## addons/Enterprise.pack/tmpl/create_author_bulk_start.tmpl
	'Bulk Author Import' => 'Importación de autores por lote',

## addons/Enterprise.pack/tmpl/edit_group.tmpl
	'Edit Group' => 'Modificar Grupo',
	'Group profile has been updated.' => 'El perfil del grupo ha sido modificado',
	'LDAP Group ID' => 'LDAP del Grupo ID',
	'The LDAP directory ID for this group.' => 'El ID del directorio LDAP para este grupo.',
	'Status of group in the system. Disabling a group removes its members&rsquo; access to the system but preserves their content and history.' => 'El estatus del grupo en el sistema.  El hecho de desactivar un grupo borra el acceso a sus miembros pero guarda su contenido y el histórico de estos.',
	'The name used for identifying this group.' => 'El nombre de usuario para identificar este grupo.',
	'The display name for this group.' => 'El nombre que se muestra para este grupo.',
	'Enter a description for your group.' => 'Instroduzca una descripción para su grupo.',
	'Created on' => 'Creado en',
	'Save changes to this field (s)' => 'Guardar cambios en el campo (s)',

## addons/Enterprise.pack/app-wizard.yaml
	'This module is required in order to use the LDAP Authentication.' => 'Este módulo es requerido para usar la identificación LDAP.',
	'This module is required in order to use SSL/TLS connection with the LDAP Authentication.' => 'Este módulo es necesario para usar la conexión SSL/TLS con la autentificación LDAP.',

## addons/Enterprise.pack/app-cms.yaml
	'Are you sure you want to delete the selected group(s)?' => '¿Está seguro de querer borrar el(los) grupo(s) seleccionados?',
	'Bulk Author Export' => 'Exportación masiva de autores',
	'Synchronize Users' => 'Sincronización de Usuarios',
	'Synchronize Groups' => 'Sincronizar grupos',

## addons/Enterprise.pack/config.yaml
	'Enterprise Pack' => 'Enterprise Pack',
	'Oracle Database' => 'Base de Datos Oracle',
	'Microsoft SQL Server Database' => 'Base de Datos Microsoft SQL Server',
	'Microsoft SQL Server Database (UTF-8 support)' => 'Base de Datos Microsoft SQL Server (UTF-8 support)',
	'External Directory Synchronization' => 'Sincronización del Directorio Externo',
	'Populating author\'s external ID to have lower case user name...' => 'Introduciendo el ID externo del autor para usar minúsculas...',

## plugins/Markdown/SmartyPants.pl
	'Easily translates plain punctuation characters into \'smart\' typographic punctuation.' => 'Traduce fácilmente los carácteres de puntuación clásicos dentro de \'inteligente\' tipografía de puntuación.',

## plugins/Markdown/Markdown.pl
	'A plain-text-to-HTML formatting plugin.' => 'Un plugin de formateo plain-text hacia HTML',
	'Markdown' => 'Markdown',
	'Markdown With SmartyPants' => 'Markdown con SmartyPants',

## plugins/WXRImporter/lib/WXRImporter/Import.pm

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'El fichero no está en el formato WXR.',
	'Creating new tag (\'[_1]\')...' => 'Creando nueva etiqueta (\'[_1]\')...',
	'Saving tag failed: [_1]' => 'Fallo al guardar la etiqueta: [_1]',
	'Duplicate asset (\'[_1]\') found.  Skipping.' => 'Se encontró un duplicado del fichero multimedia (\'[_1]\'). Ignorado.',
	'Saving asset (\'[_1]\')...' => 'Guardando elemento (\'[_1]\')...',
	' and asset will be tagged (\'[_1]\')...' => ' y el elemento será etiquetado (\'[_1]\')...',
	'Duplicate entry (\'[_1]\') found.  Skipping.' => 'Se encontró un duplicado de la entrada (\'[_1]\'). Ignorada.',
	'Saving page (\'[_1]\')...' => 'Guardando página (\'[_1]\')...',

## plugins/WXRImporter/tmpl/options.tmpl
	'Before you import WordPress posts to Movable Type, we recommend that you <a href=\'[_1]\'>configure your blog\'s publishing paths</a> first.' => 'Antes de importar las entradas de WordPress a Movable Type, le recomendamos que primero <a href=\'[_1]\'>configure las rutas de publicación del blog</a>.',
	'Upload path for this WordPress blog' => 'Ruta de transferencia para este blog de WordPress',
	'Replace with' => 'Reemplazar con',
	'Download attachments' => 'Descargar adjuntos',
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'Necesita el uso de una tarea del cron para descargar los adjuntos de un blog de WordPress en segundo plano.',
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'Descargar adjuntos (imágenes y ficheros) de un blog importado de WordPress.',

## plugins/WXRImporter/WXRImporter.pl
	'Import WordPress exported RSS into MT.' => 'Importar WordPress exported RSS hacia MT.',
	'WordPress eXtended RSS (WXR)' => 'RSS Extendido de WordPress (WXR)',
	'Download WP attachments via HTTP.' => 'Descargar adjuntos de WP vía HTTP.',

## plugins/TypePadAntiSpam/lib/MT/TypePadAntiSpam.pm
	'API key is a required parameter.' => 'La clave del API es un parámetro necesario.',

## plugins/TypePadAntiSpam/tmpl/system.tmpl
	'API Key' => 'Clave del API',
	'To enable this plugin, you\'ll need a free TypePad AntiSpam API key. You can <strong>get your free API key at [_1]antispam.typepad.com[_2]</strong>. Once you have your key, return to this page and enter it in the field below.' => 'Para habilitar esta extensión, necesita una clave gratuita del API de TypePad AntiSpam. Puede <strong>obtener su clave, gratis, en [_1]antispam.typepad.com[_2]</strong>. Tras obtenerla, regrese a esta página para introducir la clave en el campo de abajo.',
	'Service Host' => 'Servidor',
	'The default service host for TypePad AntiSpam is api.antispam.typepad.com. You should only change this if you are using a different service that is compatible with the TypePad AntiSpam API.' => 'El servidor predefinido para TypePad AntiSpam es api.antispam.typepad.com. Modifíquelo solo en el caso de utilizar otro servicio compatible con el API de TypePad AntiSpam.',

## plugins/TypePadAntiSpam/tmpl/config.tmpl
	'Junk Score Weight' => 'Peso de la puntuación',
	'Least Weight' => 'Peso mínimo',
	'Most Weight' => 'Peso máximo',
	'Comments and TrackBacks receive a junk score between -10 (definitely spam) and +10 (definitely not spam). This setting allows you to control the weight of the TypePad AntiSpam rating relative to other filters you may have installed to help you filter comments and TrackBacks.' => 'Los comentarios y los TrackBacks reciben una puntuación de basura entre -10 (realmente spam) y +10 (no es spam). Esta opción le permite controlar el peso de la puntuación de TypePad AntiSpam relativo a otros filtros que pudiera tener instalados para ayudarle a filtrar los comentarios y TrackBacks.',

## plugins/TypePadAntiSpam/tmpl/stats_widget.tmpl
	'TypePad AntiSpam' => 'TypePad AntiSpam',
	'Spam Blocked' => 'Spam bloqueado',
	'on this blog' => 'en este blog',
	'on this system' => 'en este sistema',

## plugins/TypePadAntiSpam/TypePadAntiSpam.pl
	'TypePad AntiSpam is a free service from Six Apart that helps protect your blog from comment and TrackBack spam. The TypePad AntiSpam plugin will send every comment or TrackBack submitted to your blog to the service for evaluation, and Movable Type will filter items if TypePad AntiSpam determines it is spam. If you discover that TypePad AntiSpam incorrectly classifies an item, simply change its classification by marking it as "Spam" or "Not Spam" from the Manage Comments screen, and TypePad AntiSpam will learn from your actions. Over time the service will improve based on reports from its users, so take care when marking items as "Spam" or "Not Spam."' => 'TypePad AntiSpam es un servicio gratuito de Six Apart. Le ayuda a proteger su blog del spam en los comentarios y en el TrackBack. La extensión de TypePad AntiSpam enviará al servicio todos los comentarios y TrackBacks que reciba su blog para analizarlos. Movable Type filtrará los elementos que TypePad AntiSpam identifique como spam. Si descubre que TypePad AntiSpam clasifica incorrectamente algún elemento, solo tiene que modificar la clasificación marcando al elemento como "Spam" o "No es spam" en la pantalla de administración de comentarios. TypePad AntiSpam aprenderá de sus decisiones. El servicio mejorará con el tiempo gracias a los informes remitidos por los usuarios, así que tenga cuidado al marcar lso elementos como "Spam" o como "No es spam".',
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] for this blog, and [quant,_2,message,messages] system-wide.' => 'Hasta ahora, TypePad AntiSpam ha bloqueado [quant,_1,mensaje,mensajes] en este blog y [quant,_2,mensaje,mensajes] en todo el sistema.',
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] system-wide.' => 'Hasta ahora, TypePad AntiSpam ha bloqueado [quant,_1,mensaje,mensajes] en todo el sistema.',
	'Failed to verify your TypePad AntiSpam API key: [_1]' => 'Fallo al verificar la clave API de TypePad AntiSpam: [_1]',
	'The TypePad AntiSpam API key provided is invalid.' => 'La clave API de TypePad AntiSpam no es válida.',

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'No se encontró el directorio mt-static. Por favor, configure el \'StaticFilePath\' para continuar.',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'No se pudo crear el directorio [_1] - Compruebe que el servidor web puede escribir en la carpeta \'themes\'.',
	'Successfully applied new theme selection.' => 'Se aplicó con éxito la nueva selección de estilo.',
	'Invalid URL: [_1]' => 'URL no válida: [_1]',
	'(Untitled)' => '(sin título)', # Translate - Case

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a [_1] Style' => 'Seleccionar un estilo de [_1]', # Translate - New
	'3-Columns, Wide, Thin, Thin' => '3 columnas, ancha, delgada, delgada',
	'3-Columns, Thin, Wide, Thin' => '3 columnas, delgada, ancha, delgada',
	'3-Columns, Thin, Thin, Wide' => '3 columnas, delgada, delgada, ancha',
	'2-Columns, Thin, Wide' => '2 columnas, delgada, ancha',
	'2-Columns, Wide, Thin' => '2 columnas, ancha, delgada',
	'2-Columns, Wide, Medium' => '2 columnas, ancha, media',
	'2-Columns, Medium, Wide' => '2 columnas, media, ancha',
	'1-Column, Wide, Bottom' => '1 columna, ancha, abajo',
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

## plugins/StyleCatcher/config.yaml
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks.' => 'StyleCatcher le permite navegar fácilmente por los estilos y aplicarlos en el blog con un par de clics.', # Translate - New
	'MT 4 Style Library' => 'Librería de estilos de MT 4',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Una colección de estilos compatible con las plantillas predefinidas de Movable Type.',
	'Styles' => 'Estilos',

## plugins/spamlookup/lib/spamlookup.pm
	'Failed to resolve IP address for source URL [_1]' => 'Fallo al resolver la dirección IP de origen de la URL [_1]',
	'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Moderación: La IP del dominio no coincide con la IP del ping de la URL [_1]; IP del dominio: [_2]; IP del ping: [_3]',
	'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'IP del dominio no coincide con la IP del ping de la URL [_1]; IP del dominio: [_2]; IP del ping: [_3]',
	'No links are present in feedback' => 'No hay enlaces presentes en la respuesta',
	'Number of links exceed junk limit ([_1])' => 'Número de enlaces superior al límite ([_1])',
	'Number of links exceed moderation limit ([_1])' => 'Número de enlaces superior al límite de moderación ([_1])',
	'Link was previously published (comment id [_1]).' => 'El enlace se publicó anteriormente (id del comentario [_1]).',
	'Link was previously published (TrackBack id [_1]).' => 'El enlace se publicó anteriormente (id del TrackBack [_1]).',
	'E-mail was previously published (comment id [_1]).' => 'El correo se publicó anteriormente (id del comentario [_1]).',
	'Word Filter match on \'[_1]\': \'[_2]\'.' => 'Coincidencia del filtro de palabras en \'[_1]\': \'[_2]\'.',
	'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'Coincidencia del filtro de palabras en \'[_1]\': \'[_2]\'.',
	'domain \'[_1]\' found on service [_2]' => 'dominio \'[_1]\' encontrado en el servicio \'[_2]\'',
	'[_1] found on service [_2]' => '[_1] encontrado en el servicio [_2]',

## plugins/spamlookup/tmpl/url_config.tmpl
	'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Los filtros de enlaces comprueban el número de hiperenlaces en las respuestas entrantes. Las respuestas con demasiados enlaces se moderarán o se puntuarán como basura. Las respuestas que no contengan enlaces o que solo se refieran a URLs publicadas anteriormente recibirán puntuación positiva. (Habilite esta opción solo si está seguro de que su sitio está libre de spam).',
	'Link Limits' => 'Límites de enlaces',
	'Credit feedback rating when no hyperlinks are present' => 'Puntuar positivamente si no hay hiperenlaces',
	'Adjust scoring' => 'Ajustar puntuación',
	'Score weight:' => 'Peso de la puntuación:',
	'Moderate when more than' => 'Moderar cuando se dan más de',
	'link(s) are given' => 'enlaces',
	'Junk when more than' => 'Marcar como basura cuando se dan más de',
	'Link Memory' => 'Memoria de enlaces',
	'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Puntuar positivamente cuando un hiperenlace se ha publicado anteriormente',
	'Only applied when no other links are present in message of feedback.' => 'Solo se aplica si no hay otros enlaces presentes en el mensaje de la respuesta.',
	'Exclude URLs from comments published within last [_1] days.' => 'Excluir URLs de los comentarios publicados en los últimos [_1] días.',
	'Email Memory' => 'Memoria de correos',
	'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Puntuar positivamente si se encuentran comentarios con la dirección de correo publicados anteriormente',
	'Exclude Email addresses from comments published within last [_1] days.' => 'Excluir direcciones de correo de los comentarios publicados en los últimos [_1] días.',

## plugins/spamlookup/tmpl/lookup_config.tmpl
	'Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog\'s Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.' => 'Lookups vigila el origen de las direcciones IP y los hiperenlaces de todas las respuestas entrantes. Si un comentario un TrackBack proviene de una dirección IP o un dominio incluídos en las listas negras, se retendrán para su moderación o se puntuarán como basura y se situarán en la carpeta Basura del blog. Además, se podrán realizar comprobaciones avanzadas sobre la fuente de datos de los TrackBacks.',
	'IP Address Lookups' => 'Verificar una Dirección IP',
	'Moderate feedback from blacklisted IP addresses' => 'Moderar respuestas de direcciones IP que estén en listas negras',
	'Junk feedback from blacklisted IP addresses' => 'Marcar como basura las respuestas de direcciones IP que estén en listas negras',
	'Less' => 'Menos',
	'More' => 'Más',
	'block' => 'bloquear',
	'IP Blacklist Services' => 'Servicios de listas negras de IPs',
	'Domain Name Lookups' => 'Verificar el Nombre de un Dominio',
	'Moderate feedback containing blacklisted domains' => 'Moderar respuestas que contengan dominios que estén en listas negras',
	'Junk feedback containing blacklisted domains' => 'Marcar como spam las respuestas de dominios que estén en listas negras',
	'Domain Blacklist Services' => 'Servicios de listas negras de dominios',
	'Advanced TrackBack Lookups' => 'Comprobaciones avanzadas de TrackBacks',
	'Moderate TrackBacks from suspicious sources' => 'Moderar TrackBacks de origen sospechoso',
	'Junk TrackBacks from suspicious sources' => 'Marcar como basura los TrackBacks de origen sospechoso',
	'Lookup Whitelist' => 'Verificar la lista blanca',
	'To prevent lookups for specific IP addresses or domains, list each on a line by itself.' => 'Para prevenir accesos desde IPs y dominios específicos, indíquelos usando una línea para cada uno.',

## plugins/spamlookup/tmpl/word_config.tmpl
	'Incomming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Se puede monitorizar las respuestas entrantes por palabras claves, dominios y patrones concretos. Las coincidencias serán retenidas para su moderación o se puntuarán como basura. Además, se puede personalizar las puntuaciones de basura de estas coincidencias.',
	'Keywords to Moderate' => 'Palabras claves para moderar',
	'Keywords to Junk' => 'Palabras claves para marcar como basura',

## plugins/spamlookup/spamlookup_words.pl
	'SpamLookup module for moderating and junking feedback using keyword filters.' => 'Módulo SpamLookup para la moderación y marcado como spam de respuestas mediante filtros de palabras claves.',
	'SpamLookup Keyword Filter' => 'Filtro de palabras claves de SpamLookup',

## plugins/spamlookup/spamlookup.pl
	'SpamLookup module for using blacklist lookup services to filter feedback.' => 'Módulo de SpamLookup para utilizar servicios de listas negras en el filtrado de respuestas.',
	'SpamLookup IP Lookup' => 'Comprobación de IPs de SpamLookup',
	'SpamLookup Domain Lookup' => 'Comprobación de dominios de SpamLookup',
	'SpamLookup TrackBack Origin' => 'Origen del TrackBack de SpamLookup',
	'Despam Comments' => 'Desmarcar comentarios como basura',
	'Despam TrackBacks' => 'Desmarcar TrackBacks como spam ',
	'Despam' => 'Desmarcar como spam',

## plugins/spamlookup/spamlookup_urls.pl
	'SpamLookup module for junking and moderating feedback based on link filters.' => 'Módulo de SpamLookup para marcar como spam y moderar las respuestas a través de filtros de enlaces.',
	'SpamLookup Link Filter' => 'Filtro de enlaces de SpamLookup',
	'SpamLookup Link Memory' => 'Memoria de enlaces de SpamLookup',
	'SpamLookup Email Memory' => 'Memoria de correos de SpamLookup',

## plugins/MultiBlog/lib/MultiBlog/Tags.pm
	'MTMultiBlog tags cannot be nested.' => 'Las etiquetas MTMultiBlog no se pueden anidar.',
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Valor del atributo "mode" desconocido: [_1]. Los valores válidos son "loop" y "context".',

## plugins/MultiBlog/lib/MultiBlog.pm
	'The include_blogs, exclude_blogs, blog_ids and blog_id attributes cannot be used together.' => 'Los atributos include_blogs, exclude_blogs, blog_ids y blog_id no se pueden usar juntos.',
	'The attribute exclude_blogs cannot take "all" for a value.' => 'El atributo exclude_blogs no puede tener el valor "all".',
	'The value of the blog_id attribute must be a single blog ID.' => 'El valor del atributo blog_id debe ser el ID de un solo blog.',
	'The value for the include_blogs/exclude_blogs attributes must be one or more blog IDs, separated by commas.' => 'El valor de los atributos include_blogs/exclude_blogs debe ser uno o más IDs de blogs, separados por comas.',
	'Restoring MultiBlog rebuild trigger for blog #[_1]...' => 'Restaurando MultiBlog el inductor de reconstrucción en el blog #[_1]...',

## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
	'Create MultiBlog Trigger' => 'Crear inductor de MultiBlog',

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'When' => 'Cuando',
	'Weblog' => 'Weblog',
	'Trigger' => 'Inductor',
	'Action' => 'Acción',
	'Content Privacy' => 'Privacidad de contenidos',
	'Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.' => 'Especifique si otros blogs de la instalación podrán publicar contenidos de este blog. Esta opción tiene prioridad sobre la política predefinida de agregación del sistema que se encuentra en la configuración a nivel del sistema de MultiBlog.',
	'Use system default' => 'Utilizar valor predefinido del sistema',
	'Allow' => 'Permitir',
	'Disallow' => 'No permitir',
	'MTMultiBlog tag default arguments' => 'Argumentos predefinidos de la etiqueta MTMultiBlog',
	'Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or \'all\' (include_blogs only) are acceptable values.' => 'Perimite el uso de la etiqueta MTMultiBlog sin los atributos include_blogs/exclude_blogs. Se aceptan como valores BlogIDs separados por comas o \'all\' (include_blogs solamente).',
	'Include blogs' => 'Incluir blogs',
	'Exclude blogs' => 'Excluir blogs',
	'Rebuild Triggers' => 'Eventos de republicación',
	'Create Rebuild Trigger' => 'Crear un evento de republicación',
	'You have not defined any rebuild triggers.' => 'No ha definido ningún inductor de reconstrucción.',

## plugins/MultiBlog/tmpl/system_config.tmpl
	'Default system aggregation policy' => 'Política predefinida de agregación del sistema',
	'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'La agregación cruzada de blogs estará permitida por defecto. Los blogs individuales se podrán configurar a través de sus ajustes de MultiBlog para restringir a otros blogs el acceso a sus contenidos.',
	'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'La agregación cruzada de blogs no estará permitida por defecto. Individualmente se podrá configurar a los blogs a través de sus ajustes de MultiBlog para permitir a otros blogs el acceso a sus contenidos.',

## plugins/MultiBlog/multiblog.pl
	'MultiBlog allows you to publish content from other blogs and define publishing rules and access controls between them.' => 'MultiBlog le permite publicar contenidos de otros blogs y definir reglas de publicación y control de accesos entre ellas.',
	'MultiBlog' => 'MultiBlog',
	'Create Trigger' => 'Crear nuevo inductor',
	'Search Weblogs' => 'Buscar en weblogs',
	'When this' => 'Cuando este',
	'* All blogs in this website' => '* Todos los blogs en este sitio web', # Translate - New
	'Select to apply this trigger to all blogs in this website.' => 'Aplica este inductor a todos los blogs del sitio web.', # Translate - New
	'* All websites and blogs in this system' => '* Todos los sitios web y blogs del sistema', # Translate - New
	'Select to apply this trigger to all websites and blogs in this system.' => 'Aplica este inductor a todos los sitios web del sistema.', # Translate - New
	'saves an entry/page' => 'guarda una entrada/página', # Translate - New
	'publishes an entry/page' => 'publica una entrada/página', # Translate - New
	'publishes a comment' => 'publica un comentario',
	'publishes a TrackBack' => 'publica un TrackBack',
	'rebuild indexes.' => 'reconstruye los índices.',
	'rebuild indexes and send pings.' => 'reconstruye los índices y envía pings.',

## plugins/Textile/textile2.pl
	'A humane web text generator.' => 'Un generador de texto web humano',
	'Textile 2' => 'Textile 2',

## plugins/WidgetManager/WidgetManager.pl
	'Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.' => 'Administrador de Widgets versión 1.1; Esta versión de la extensión actualiza los datos de la versiones antiguas del Adminstrador de Widgets que venía con Movable Type al esquema interno de Movable Type. No se han incluído otras características. Puede borrar esta extensión sin problemas después de instalar o actualizar Movable Type.',
	'Moving storage of Widget Manager [_2]...' => 'Trasladando los datos del Administrador de Widgets [_2]...',

## plugins/ActionStreams/blog_tmpl/sidebar.mtml

## plugins/ActionStreams/blog_tmpl/comment_listing.mtml

## plugins/ActionStreams/blog_tmpl/main_index.mtml

## plugins/ActionStreams/blog_tmpl/actions.mtml
	'Recent Actions' => 'Acciones recientes',

## plugins/ActionStreams/blog_tmpl/archive.mtml

## plugins/ActionStreams/blog_tmpl/banner_footer.mtml

## plugins/ActionStreams/blog_tmpl/elsewhere.mtml
	'Find [_1] Elsewhere' => 'Buscar [_1] en otro sitio',

## plugins/ActionStreams/lib/ActionStreams/Upgrade.pm
	'Updating classification of [_1] [_2] actions...' => 'Actualizando la clasificación de [_1] [_2] acciones...',
	'Renaming "[_1]" data of [_2] [_3] actions...' => 'Renombrando los datos de "[_1]" de [_2] [_3] acciones...',

## plugins/ActionStreams/lib/ActionStreams/Worker.pm
	'No such author with ID [_1]' => 'No existe un autor con el ID [_1]',

## plugins/ActionStreams/lib/ActionStreams/Plugin.pm
	'Other Profiles' => 'Otros perfiles',
	'Action Stream' => 'Torrente de acciones',
	'Profiles' => 'perfiles',
	'Actions from the service [_1]' => 'Acciones del servicio [_1]',
	'Actions that are shown' => 'Acciones mostradas',
	'Actions that are hidden' => 'Acciones ocultas',
	'No such event [_1]' => 'No existe el evento [_1]',
	'[_1] Profile' => 'Perfil de [_1]',

## plugins/ActionStreams/lib/ActionStreams/Tags.pm
	'No user [_1]' => 'No existe el usuario [_1]',

## plugins/ActionStreams/lib/ActionStreams/Event.pm
	'[_1] updating [_2] events for [_3]' => '[_1] actualizando [_2] eventos para [_3]',
	'Error updating events for [_1]\'s [_2] stream (type [_3] ident [_4]): [_5]' => 'Error actualizando eventos para el torrente [_2] de [_1] (tipo [_3] ident [_4]): [_5]',
	'Could not load class [_1] for stream [_2] [_3]: [_4]' => 'No se pudo cargar la clase [_1] del torrente [_2] [_3]: [_4]',
	'No URL to fetch for [_1] results' => 'Sin URL para obtener resultados de [_1]',
	'Could not fetch [_1]: [_2]' => 'No se pudo obtener [_1]: [_2]',
	'Aborted fetching [_1]: [_2]' => 'Se abortó durante la obtención de [_1]: [_2]',

## plugins/ActionStreams/tmpl/dialog_edit_profile.tmpl
	'Your user name or ID is required.' => 'El usuario o el ID es obligatorio.',
	'Edit a profile on a social networking or instant messaging service.' => 'Editar un perfil en una red social o servicio de mensajaría instantánea.',
	'Service' => 'Servicio',
	'Enter your account on the selected service.' => 'Introduzca su cuenta en el servicio seleccionado.',
	'For example:' => 'Por ejemplo:',
	'Action Streams' => 'Torrente de acciones',
	'Select the action streams to collect from the selected service.' => 'Seleccione el torrente de acciones para obtenerlos del servicio elegido.',
	'No streams are available for this service.' => 'No hay torrentes disponibles para este servicio.',

## plugins/ActionStreams/tmpl/other_profiles.tmpl
	'The selected profile was added.' => 'Se añadió el perfil seleccionado.',
	'The selected profiles were removed.' => 'Se borraron los perfiles seleccionados.',
	'The selected profiles were scanned for updates.' => 'Se escanearon las actualizaciones de los perfiles seleccionados.',
	'The changes to the profile have been saved.' => 'Se han guardado los cambios al perfil.',
	'Add Profile' => 'Añadir perfil',
	'profile' => 'Perfil',
	'profiles' => 'perfiles',
	'Delete selected profiles (x)' => 'Borrar los perfiles seleccionados (x)',
	'to update' => 'para actualizar',
	'Scan now for new actions' => 'Buscar nuevas acciones',
	'Update Now' => 'Actualizar ahora',
	'No profiles were found.' => 'No se encontraron perfiles.',
	'external_link_target' => 'external_link_target',
	'View Profile' => 'Ver perfil',

## plugins/ActionStreams/tmpl/dialog_add_profile.tmpl
	'Add a profile on a social networking or instant messaging service.' => 'Añadir un perfil de una red social o servicio de mensajería instantánea.',
	'Select a service where you already have an account.' => 'Seleccione un servicio donde ya tenga una cuenta.',
	'Add Profile (s)' => 'Añadir perfil (s)',

## plugins/ActionStreams/tmpl/list_profileevent.tmpl
	'The selected events were deleted.' => 'Se borraron los eventos seleccionados.',
	'The selected events were hidden.' => 'Se ocultaron los eventos seleccionados.',
	'The selected events were shown.' => 'Se mostraron los eventos seleccionados.',
	'All action stream events were hidden.' => 'Se ocultaron todos los torrentes de acciones.',
	'All action stream events were shown.' => 'Se mostraron todos los torrentes de acciones.',
	'event' => 'evento',
	'events' => 'eventos',
	'Hide selected events (h)' => 'Ocultar eventos seleccionados (h)',
	'Hide' => 'Ocultar',
	'Show selected events (h)' => 'Mostrar eventos seleccionados (h)',
	'Show' => 'Mostrar',
	'All stream actions' => 'Todas las acciones',
	'Show only actions where' => 'Mostrar solo acciones donde',
	'service' => 'Servicio',
	'visibility' => 'visibilidad',
	'hidden' => 'Oculto',
	'shown' => 'Mostrado',
	'No events could be found.' => 'No se encontró ningún evento.',
	'Event' => 'Evento',
	'Shown' => 'Mostrado',
	'Hidden' => 'Oculto',
	'View action link' => 'Ver enlace de la acción',

## plugins/ActionStreams/tmpl/widget_recent.mtml
	'Your Recent Actions' => 'Sus acciones recientes',
	'blog this' => 'bloguear esto',
	'No actions could be found.' => 'No se encontró ninguna acción.',

## plugins/ActionStreams/tmpl/blog_config_template.tmpl
	'Rebuild Indexes' => 'Reconstruir índices',
	'If selected, this blog\'s indexes will be rebuilt when new action stream events are discovered.' => 'Si se selecciona, los índices de este blog se reconstruirán al descubrir nuevos eventos de los torrentes de acciones.',
	'Enable rebuilding' => 'Activar reconstrucción',

## plugins/ActionStreams/streams.yaml
	'Currently Playing' => 'Juegos recientes',
	'The games in your collection you\'re currently playing' => 'Juegos de su colección a los que esté jugando actualmente',
	'Comments you have made on the web' => 'Comentarios que ha realizado en el web',
	'Colors' => 'Colores',
	'Colors you saved' => 'Colores que ha guardado',
	'Palettes' => 'Paletas',
	'Palettes you saved' => 'Paletas que ha guardado',
	'Patterns' => 'Patrones',
	'Patterns you saved' => 'Patrones que ha guardado',
	'Favorite Palettes' => 'Paletas favoritas',
	'Palettes you saved as favorites' => 'Paletas que ha guardado como favoritas',
	'Reviews' => 'Reseñas',
	'Your wine reviews' => 'Reseñas de vino que ha realizado',
	'Cellar' => 'Bodega',
	'Wines you own' => 'Vinos que posee',
	'Shopping List' => 'Lista de compras',
	'Wines you want to buy' => 'Vinos que desea comprar',
	'Links' => 'Enlaces',
	'Your public links' => 'Sus enlaces públicos',
	'Dugg' => 'Dugg',
	'Links you dugg' => 'Enlaces que ha enviado a digg',
	'Submissions' => 'Envíos',
	'Links you submitted' => 'Enlaces que ha enviado',
	'Found' => 'Encontrado',
	'Photos you found' => 'Fotos que ha encontrado',
	'Favorites' => 'Favoritos',
	'Photos you marked as favorites' => 'Fotos que ha marcado como favoritas',
	'Photos' => 'Fotos',
	'Photos you posted' => 'Fotos que ha publicado',
	'Likes' => 'Gustos',
	'Things from your friends that you "like"' => 'Cosas de sus amigos que le gustan',
	'Leaderboard scores' => 'Máximas puntuaciones',
	'Your high scores in games with leaderboards' => 'Sus puntuaciones máximas en los juegos con ránking',
	'Blog posts about your search term' => 'Entradas en los blogs con el término buscado',
	'Stories' => 'Noticias',
	'News Stories matching your search' => 'Noticias con el término buscado',
	'To read' => 'Para leer',
	'Books on your "to-read" shelf' => 'Libros para leer',
	'Reading' => 'Leyendo',
	'Books on your "currently-reading" shelf' => 'Libros que actualmente está leyendo',
	'Read' => 'Lecturas',
	'Books on your "read" shelf' => 'Libros pendientes de lectura',
	'Shared' => 'Compartidos',
	'Your shared items' => 'Elementos compartidos',
	'Deliveries' => 'Envíos',
	'Icon sets you were delivered' => 'Conjuntos de iconos que ha enviado',
	'Notices' => 'Notas',
	'Notices you posted' => 'Notas que ha publicado',
	'Intas' => 'Intas',
	'Links you saved' => 'Enlaces que ha guardado',
	'Photos you posted that were approved' => 'Fotos que ha publicado y han sido aprobadas',
	'Recent events' => 'Eventos recientes',
	'Events from your recent events feed' => 'Eventos de su fuente de sindicación de eventos',
	'Apps you use' => 'Aplicaciones que usa',
	'The applications you saved as ones you use' => 'Aplicaciones que ha indicado que usa',
	'Videos you saved as watched' => 'Vídeos que ha guardado como vistos',
	'Jaikus' => 'Jaikus',
	'Jaikus you posted' => 'Jaikus que ha publicado',
	'Games you saved as favorites' => 'Juegos que ha guardado como favoritos',
	'Achievements' => 'Logros',
	'Achievements you won' => 'Éxitos que ha realizado',
	'Tracks' => 'Canciones',
	'Songs you recently listened to (High spam potential!)' => 'Canciones que escuchado recientemente (¡alto potencial de spam!)',
	'Loved Tracks' => 'Canciones favoritas',
	'Songs you marked as "loved"' => 'Canciones que ha seleccionado como favoritas',
	'Journal Entries' => 'Entradas del diario',
	'Your recent journal entries' => 'Las entradas recientes en su diario',
	'Events' => 'Eventos',
	'The events you said you\'ll be attending' => 'Eventos a los que confirmó su asistencia',
	'Your public posts to your journal' => 'Entradas públicas en su diario',
	'Queue' => 'Cola',
	'Movies you added to your rental queue' => 'Películas que ha añadido a la lista de pendientes por alquilar',
	'Recent Movies' => 'Películas rcientes',
	'Recent Rental Activity' => 'Actividad reciente de alquiler',
	'Kudos' => 'Felicitaciones',
	'Kudos you have received' => 'Felicitaciones que ha recibido',
	'Favorite Songs' => 'Canciones favoritas',
	'Songs you marked as favorites' => 'Canciones que ha seleccionado como favoritas',
	'Favorite Artists' => 'Artistas favoritos',
	'Artists you marked as favorites' => 'Artistas que ha marcado como favoritos',
	'Stations' => 'Estaciones',
	'Radio stations you added' => 'Estaciones de radio que ha añadido',
	'List' => 'Lista',
	'Things you put in your list' => 'Elementos que ha añadido a su lista',
	'Notes' => 'Notas',
	'Your public notes' => 'Sus notas públicas',
	'Comments you posted' => 'Comentarios que ha publicado',
	'Articles you submitted' => 'Artículos que ha escrito',
	'Articles you liked (your votes must be public)' => 'Artículos que le han gustado (los votos debe ser públicos)',
	'Dislikes' => 'No recomendable',
	'Articles you disliked (your votes must be public)' => 'Artículos que no lo han gustado (los votos deben ser públicos)',
	'Slideshows you saved as favorites' => 'Presentaciones que ha guardado como favoritas',
	'Slideshows' => 'Presentaciones',
	'Slideshows you posted' => 'Presentaciones que ha publicado',
	'Your achievements for achievement-enabled games' => 'Logros que ha conseguidos en juegos con fases',
	'Stuff' => 'Cosas',
	'Things you posted' => 'Cosas que ha publicado',
	'Tweets' => 'Tweets',
	'Your public tweets' => 'Sus envíos a twitter',
	'Public tweets you saved as favorites' => 'Envíos a twitter que ha marcado como favoritos',
	'Tweets about your search term' => 'Envíos a twitter que coinciden con la búsqueda',
	'Saved' => 'Guardado',
	'Things you saved as favorites' => 'Cosas que ha guardado como favoritos',
	'Events you are watching or attending' => 'Eventos que está presenciando',
	'Videos you posted' => 'Vídeos que ha publicado',
	'Videos you liked' => 'Vídeos que le han gustado',
	'Public assets you saved as favorites' => 'Elementos públicos que ha guardado como favoritos',
	'Your public photos in your Vox library' => 'Sus fotos públicas en la librería de Vox',
	'Your public posts to your Vox' => 'Sus entradas públicas en Vox',
	'The posts available from the website\'s feed' => 'Las entradas disponibles en la sindicación del web',
	'Wists' => 'Wists',
	'Stuff you saved' => 'Cosas que ha guardado',
	'Gamerscore' => 'Puntuaciones',
	'Notes when your gamerscore passes an even number' => 'Anotaciones de cuando su puntuación en los juegos pasan algún número concreto',
	'Places you reviewed' => 'Lugares reseñados',
	'Videos you saved as favorites' => 'Vídeos guardados como favoritos',

## plugins/ActionStreams/services.yaml
	'1up.com' => '1up.com',
	'43Things' => '43Things',
	'Screen name' => 'Usuario',
	'backtype' => 'backtype',
	'Bebo' => 'Bebo',
	'Catster' => 'Catster',
	'COLOURlovers' => 'COLOURlovers',
	'Cork\'\'d\'' => 'Cork\'\'d\'',
	'Delicious' => 'Delicious',
	'Destructoid' => 'Destructoid',
	'Digg' => 'Digg',
	'Dodgeball' => 'Dodgeball',
	'Dogster' => 'Dogster',
	'Dopplr' => 'Dopplr',
	'Facebook' => 'Facebook',
	'User ID' => 'ID de usuario',
	'You can find your Facebook userid within your profile URL.  For example, http://www.facebook.com/profile.php?id=24400320.' => 'Puede encontrar el ID de Facebook en la URL de su perfil. Por ejemplo, http://www.facebook.com/profile.php?id=24400320.',
	'FFFFOUND!' => 'FFFFOUND!',
	'Flickr' => 'Flickr',
	'Enter your Flickr userid which contains "@" in it, e.g. 36381329@N00.  Flickr userid is NOT the username in the URL of your photostream.' => 'Introduzca el identificador de usuario de Flickr, que contiene una "@", p.e. 36381329@N00. El identificador NO es el nombre de usuario en la URL de la galería.',
	'FriendFeed' => 'FriendFeed',
	'Gametap' => 'Gametap',
	'Google Blogs' => 'Google Blogs',
	'Search term' => 'Buscar palabra',
	'Google News' => 'Google News',
	'Search for' => 'Buscar',
	'Goodreads' => 'Goodreads',
	'You can find your Goodreads userid within your profile URL. For example, http://www.goodreads.com/user/show/123456.' => 'Puede encontrar el identificador de usuario de Gooreads en la URL del perfil. Por ejemplo, http://www.goodreads.com/user/show/123456.',
	'Google Reader' => 'Google Reader',
	'Sharing ID' => 'Sharing ID',
	'Hi5' => 'Hi5',
	'IconBuffet' => 'IconBuffet',
	'ICQ' => 'ICQ',
	'UIN' => 'UIN',
	'Identi.ca' => 'Identi.ca',
	'Iminta' => 'Iminta',
	'iStockPhoto' => 'iStockPhoto',
	'You can find your istockphoto userid within your profile URL.  For example, http://www.istockphoto.com/user_view.php?id=1234567.' => 'Puede encontrar el identificador de usuario en la URL del perfil. Por ejemplo, http://www.istockphoto.com/user_view.php?id=1234567.',
	'IUseThis' => 'IUseThis',
	'iwatchthis' => 'iwatchthis',
	'Jabber' => 'Jabber',
	'Jabber ID' => 'ID de Jabber',
	'Jaiku' => 'Jaiku',
	'Kongregate' => 'Kongregate',
	'Last.fm' => 'Last.fm',
	'LinkedIn' => 'LinkedIn',
	'Profile URL' => 'URL del perfil',
	'Ma.gnolia' => 'Ma.gnolia',
	'MOG' => 'MOG',
	'MSN Messenger\'' => 'MSN Messenger\'',
	'Multiply' => 'Multiply',
	'MySpace' => 'MySpace',
	'Netflix' => 'Netflix',
	'Netflix RSS ID' => 'Netflix RSS ID',
	'To find your Netflix RSS ID, click "RSS" at the bottom of any page on the Netflix site, then copy and paste in your "Queue" link.' => 'Para encontrar su ID de RSS de Netflix, haga clic en "RSS" al pie de cualquier página del sitio de Netflix, y copie y pegue el enlace "Queue".',
	'Netvibes' => 'Netvibes',
	'Newsvine' => 'Newsvine',
	'Ning' => 'Ning',
	'Social Network URL' => 'URL de la red social',
	'Ohloh' => 'Ohloh',
	'Orkut' => 'Orkut',
	'You can find your orkut uid within your profile URL. For example, http://www.orkut.com/Main#Profile.aspx?rl=ls&uid=1234567890123456789' => 'Puede encontrar el identificador de usuario de orkut en la URL del perfil. Por ejemplo, http://www.orkut.com/Main#Profile.aspx?rl=ls&uid=1234567890123456789',
	'Pandora' => 'Pandora',
	'Picasa Web Albums' => 'Álbumes de Picasa',
	'p0pulist' => 'p0pulist',
	'You can find your p0pulist user id within your Hot List URL. for example, http://p0pulist.com/list/hot_list/10000' => 'Puede encontrar el identificador de usuario de p0pulist en la URL de la lista de éxitos. Por ejemplo, http://p0pulist.com/list/hot_list/10000',
	'Pownce' => 'Pownce',
	'Reddit' => 'Reddit',
	'Skype' => 'Skype',
	'SlideShare' => 'SlideShare',
	'Smugmug' => 'Smugmug',
	'SonicLiving' => 'SonicLiving',
	'You can find your SonicLiving userid within your share&subscribe URL. For example, http://sonicliving.com/user/12345/feeds' => 'Puede encontrar el identificador de usuario de SonicLiving en la URL de compartir y suscribir. Por ejemplo, http://sonicliving.com/user/12345/feeds',
	'Steam' => 'Steam',
	'StumbleUpon' => 'StumbleUpon',
	'Tabblo' => 'Tabblo',
	'Blank should be replaced by positive sign (+).' => 'El espacio se reemplazará con el signo positivo (+).',
	'Tribe' => 'Tribe',
	'You can find your tribe userid within your profile URL.  For example, http://people.tribe.net/dcdc61ed-696a-40b5-80c1-e9a9809a726a.' => 'Puede encontrar el identificador de usuario de tribe en la URL del perfil. Por ejemplo, http://people.tribe.net/dcdc61ed-696a-40b5-80c1-e9a9809a726a.',
	'Tumblr' => 'Tumblr',
	'Twitter' => 'Twitter',
	'TwitterSearch' => 'TwitterSearch',
	'Uncrate' => 'Uncrate',
	'Upcoming' => 'Upcoming',
	'Viddler' => 'Viddler',
	'Vimeo' => 'Vimeo',
	'Virb' => 'Virb',
	'You can find your VIRB userid within your home URL.  For example, http://www.virb.com/backend/2756504321310091/your_home.' => 'Puede encontrar el identificador de usuario de VIRB en la URL de inicio. Por ejemplo, http://www.virb.com/backend/2756504321310091/your_home.',
	'Vox name' => 'Usuario de Vox',
	'Xbox Live\'' => 'Xbox Live\'',
	'Gamertag' => 'Gamertag',
	'Yahoo! Messenger\'' => 'Yahoo! Messenger\'',
	'Yelp' => 'Yelp',
	'YouTube' => 'YouTube',
	'Zooomr' => 'Zooomr',

## plugins/ActionStreams/config.yaml
	'Manages authors\' accounts and actions on sites elsewhere around the web' => 'Administra la cuenta de los autores y acciones en los sitios externos',
	'Are you sure you want to hide EVERY event in EVERY action stream?' => '¿Está seguro de que desea ocultar TODOS los eventos de TODOS los torrentes de acciones?',
	'Are you sure you want to show EVERY event in EVERY action stream?' => '¿Está seguro de que desea mostrar TODOS los eentos de TODOS los torrentes de acciones?',
	'Deleted events that are still available from the remote service will be added back in the next scan. Only events that are no longer available from your profile will remain deleted. Are you sure you want to delete the selected event(s)?' => 'Los eventos eliminados que aún están disponibles en el servicio remoto se volverán a añadir en la siguiente consulta. Solo los eventos que ya no estén disponibles en el perfil permanecerán eliminados. ¿Está seguro de que desea borrar los eventos seleccionados?',
	'Hide All' => 'Ocultar todo',
	'Show All' => 'Mostrar todo',
	'Poll for new events' => 'Buscar nuevos eventos',
	'Update Events' => 'Actualizar eventos',
	'Main Index (Recent Actions)' => 'Índice principal (acciones recientes)',
	'Action Archive' => 'Archivo de acciones',
	'Feed - Recent Activity' => 'Sindicación - Actividad reciente',
	'Find Authors Elsewhere' => 'Buscar autores en otros sitios',
	'Enabling default action streams for selected profiles...' => 'Activando los torrentes de acciones predefinidos para los perfiles seleccionados...',

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm

## plugins/FacebookCommenters/tmpl/blog_config_template.tmpl
	'Facebook Application Key' => 'Clave de la aplicación de Facebook',
	'The key for the Facebook application associated with your blog.' => 'La clave de la aplicación de Facebook asociada con su blog.',
	'Edit Facebook App' => 'Editar aplicación de Facebook',
	'Create Facebook App' => 'Crear aplicación de Facebook',
	'Facebook Application Secret' => 'Secreto de la aplicación de Facebook',
	'The secret for the Facebook application associated with your blog.' => 'El secreto de la aplicación de Facebook asociada con su blog.',

## plugins/FacebookCommenters/plugin.pl
	'Provides commenter registration through Facebook Connect.' => 'Provee registro de comentaristas a través de Facebook Connect.',
	'Set up Facebook Commenters plugin' => 'Configurar la extesión de comentaristas de Facebook',
	'{*actor*} commented on the blog post <a href="{*post_url*}">{*post_title*}</a>.' => '{*actor*} comentó en la entrada <a href="{*post_url*}">{*post_title*}</a>.',
	'Could not register story template with Facebook: [_1]. Did you enter the correct application secret?' => 'No se pudo registrar la plantilla de historias con Facebook: [_1]. ¿No introdujo el secreto correcto de la aplicación?',
	'Could not register story template with Facebook: [_1]' => 'No pudo registrar la plantilla de historias con Facebook: [_1]',
	'Facebook' => 'Facebook',

## plugins/Motion/lib/Motion/Search.pm
	'This module works with MT::App::Search.' => 'Este módulo funciona con MT::App::Search.',
	'Specify the blog_id of a blog that has Motion template set.' => 'Especifique el blog_id de un blog que tenga el conjunto de plantillas de Motion.',
	'Error loading template: [_1]' => 'Error cargando plantilla: [_1]',

## plugins/Motion/tmpl/edit_linkpost.tmpl

## plugins/Motion/tmpl/edit_videopost.tmpl
	'Embed code' => 'Embeber código',

## plugins/Motion/templates/Motion/widget_user_archives.mtml
	'Recenty entries from [_1]' => 'Entradas recientes de [_1]',

## plugins/Motion/templates/Motion/widget_search.mtml

## plugins/Motion/templates/Motion/banner_header.mtml
	'Home' => 'Inicio',

## plugins/Motion/templates/Motion/search_results.mtml

## plugins/Motion/templates/Motion/widget_popular_entries.mtml
	'Popular Entries' => 'Entradas populares',
	'posted by <a href="[_1]">[_2]</a> on [_3]' => 'publicado por <a href="[_1]">[_2]</a> en [_3]',

## plugins/Motion/templates/Motion/widget_followers.mtml
	'Followers' => 'Seguidores',
	'Not being followed' => 'Sin seguidores',

## plugins/Motion/templates/Motion/entry_response.mtml
	'Single Entry' => 'Entrada sencilla',

## plugins/Motion/templates/Motion/comment_response.mtml
	'<strong>Bummer....</strong> [_1]' => '<strong>Qué mala suerte....</strong> [_1]',

## plugins/Motion/templates/Motion/widget_about_ssite.mtml
	'About' => 'Sobre mi',
	'The Motion Template Set is a great example of the type of site you can build with Movable Type.' => 'El conjunto de plantillas de Motion es un buen ejemplo del tipo de sitio que puede hacer con Movable Type.',

## plugins/Motion/templates/Motion/register.mtml
	'Messaging' => 'Mensajería',
	'Form Field' => 'Campo del formulario',
	'Enter a password for yourself.' => 'Introduzca su contraseña.',
	'The URL of your website.' => 'La URL de su sitio web.',

## plugins/Motion/templates/Motion/comment_detail.mtml

## plugins/Motion/templates/Motion/member_index.mtml

## plugins/Motion/templates/Motion/single_entry.mtml
	'By [_1] <span class="date">on [_2]</span>' => 'Por [_1] <span class="date">el [_2]</span>',
	'Unpublish this post' => 'Despublicar esta entrada',
	'1 <span>Comment</span>' => '1 <span>Comentario</span>',
	'# <span>Comments</span>' => '# <span>Comentarios</span>',
	'0 <span>Comments</span>' => '0 <span>Comentarios</span>',
	'1 <span>TrackBack</span>' => '1 <span>TrackBack</span>',
	'# <span>TrackBacks</span>' => '# <span>TrackBacks</span>',
	'0 <span>TrackBacks</span>' => '0 <span>TrackBacks</span>',
	'Note: This post is being held for approval by the site owner.' => 'Nota: Esta entrada está retenida hasta que el administrador del sitio la apruebe.',
	'Photo' => 'Foto',
	'<a href="[_1]">Most recent comment by <strong>[_2]</strong> on [_3]</a>' => '<a href="[_1]">Últimos comentarios de <strong>[_2]</strong> en [_3]</a>',
	'Posted to [_1]' => 'Publicado en [_1]',
	'[_1] posted [_2] on [_3]' => '[_1] publicó [_2] en [_3]',

## plugins/Motion/templates/Motion/widget_tag_cloud.mtml

## plugins/Motion/templates/Motion/password_reset.mtml
	'Reset Password' => 'Reiniciar la contraseña',

## plugins/Motion/templates/Motion/form_field.mtml
	'(Optional)' => '(Opcional)',

## plugins/Motion/templates/Motion/javascript.mtml
	'Please select a file to post.' => 'Por favor, seleccione un fichero para publicar.',
	'You selected an unsupported file type.' => 'Ha seleccionado un tipo de fichero no soportado.',

## plugins/Motion/templates/Motion/trackbacks.mtml

## plugins/Motion/templates/Motion/archive_index.mtml

## plugins/Motion/templates/Motion/new_password.mtml
	'Choose New Password' => 'Seleccione la nueva contraseña',

## plugins/Motion/templates/Motion/entry_listing_author.mtml
	'Archived Entries from [_1]' => 'Entradas archivadas de [_1]',
	'Recent Entries from [_1]' => 'Entradas recientes de [_1]',

## plugins/Motion/templates/Motion/widget_categories.mtml

## plugins/Motion/templates/Motion/dynamic_error.mtml

## plugins/Motion/templates/Motion/widget_main_column_registration.mtml
	'<a href="javascript:void(0)" onclick="[_1]">Sign In</a>' => '<a href="javascript:void(0)" onclick="[_1]">Identifíquese</a>',
	'Not a member? <a href="[_1]">Register</a>' => '¿No es miembro? <a href="[_1]">Registrarse</a>',
	'(or <a href="javascript:void(0)" onclick="[_1]">Sign In</a>)' => '(o <a href="javascript:void(0)" onclick="[_1]">identifíquese</a>)',
	'No posting privileges.' => 'Sin privilegios de publicación.',

## plugins/Motion/templates/Motion/widget_elsewhere.mtml
	'Are you sure you want to remove the [_1] from your profile?' => '¿Está seguro de que desea eliminar el [_1] del perfil?',
	'Your user name or ID is required.' => 'El usuario o el ID es obligatorio.',
	'Add a Service' => 'Añadir un servicio',
	'Service' => 'Servicio',
	'Select a service...' => 'Seleccionar un servicio...',
	'Your Other Profiles' => 'Sus otros perfiles',
	'Find [_1] Elsewhere' => 'Buscar [_1] en otro sitio',
	'Remove service' => 'Eliminar servicio',

## plugins/Motion/templates/Motion/widget_main_column_posting_form_text.mtml
	'QuickPost' => 'QuickPost',
	'Content' => 'Contenido',
	'more options' => 'más opciones',
	'Post' => 'Publicar',

## plugins/Motion/templates/Motion/comment_preview.mtml

## plugins/Motion/templates/Motion/actions_local.mtml
	'[_1] commented on [_2]' => '[_1] comentó en [_2]',
	'[_1] favorited [_2]' => '[_1] marcó como favorito [_2]',
	'No recent actions.' => 'Ninguna acción reciente',

## plugins/Motion/templates/Motion/main_index.mtml
	'Main Column Content' => 'Contenido de la columna principal',

## plugins/Motion/templates/Motion/page.mtml

## plugins/Motion/templates/Motion/entry_summary.mtml

## plugins/Motion/templates/Motion/widget_recent_comments.mtml
	'<p>[_3]...</p><div class="comment-attribution">[_4]<br /><a href="[_1]">[_2]</a></div>' => '<p>[_3]...</p><div class="comment-attribution">[_4]<br /><a href="[_1]">[_2]</a></div>',

## plugins/Motion/templates/Motion/widget_monthly_archives.mtml

## plugins/Motion/templates/Motion/profile_feed.mtml
	'Posted [_1] to [_2]' => '[_1] publicado en [_2]',
	'Commented on [_1] in [_2]' => 'Comentó en [_1] en [_2]',
	'followed [_1]' => 'sigue a [_1]',

## plugins/Motion/templates/Motion/widget_main_column_posting_form.mtml
	'Text post' => 'Texto',
	'Photo post' => 'Foto',
	'Link post' => 'Enlace',
	'Embed post' => 'Embebido',
	'Audio post' => 'Audio',
	'URL of web page' => 'URL de página web',
	'Select photo file' => 'Selccione una imagen',
	'Only GIF, JPEG and PNG image files are supported.' => 'Solo están soportados los formatos GIF, JPEG y PNG.',
	'Select audio file' => 'Seleccione un fichero de audio',
	'Only MP3 audio files are supported.' => 'Solo está soportado el formato MP3.',
	'Paste embed code' => 'Pegar código embebido',

## plugins/Motion/templates/Motion/entry_listing_category.mtml

## plugins/Motion/templates/Motion/widget_signin.mtml
	'You are signed in as <a href="[_1]">[_2]</a>' => 'Está identificado como <a href="[_1]">[_2]</a>',
	'You are signed in as [_1]' => 'Está identificado como [_1]',
	'Edit profile' => 'Editar Perfil',

## plugins/Motion/templates/Motion/widget_fans.mtml
	'Fans' => 'Fans',

## plugins/Motion/templates/Motion/comment_listing.mtml

## plugins/Motion/templates/Motion/register_confirmation.mtml
	'Authentication Email Sent' => 'Correo de autentificación enviado.',
	'Profile Created' => 'Perfil creado',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Regresar a la página original.</a>',

## plugins/Motion/templates/Motion/entry.mtml

## plugins/Motion/templates/Motion/widget_gallery.mtml
	'Recent Photos' => 'Fotos recientes',

## plugins/Motion/templates/Motion/sidebar.mtml
	'Profile Widgets' => 'Widgets del perfil',
	'Main Index Widgets' => 'Widgets del índice principal',
	'Archive Widgets' => 'Widgets de los archivos',
	'Entry Widgets' => 'Widgets de la entrada',
	'Default Widgets' => 'Widgets predefinidos',

## plugins/Motion/templates/Motion/user_profile_edit.mtml
	'Go <a href="[_1]">back to the previous page</a> or <a href="[_2]">view your profile</a>.' => '<a href="[_1]">Regresar a la página anterior</a> o <a href="[_2]">vea su perfil</a>.',

## plugins/Motion/templates/Motion/widget_recent_entries.mtml
	'posted by [_1] on [_2]' => 'publicada por [_1] en [_2]',

## plugins/Motion/templates/Motion/banner_footer.mtml
	'Footer Widgets' => 'Widgets del pie',

## plugins/Motion/templates/Motion/entry_listing_monthly.mtml

## plugins/Motion/templates/Motion/widget_main_column_actions.mtml
	'Actions (Local)' => 'Acciones (local)',

## plugins/Motion/templates/Motion/comments.mtml
	'what will you say?' => '¿Qué va a decir?',
	'[_1] [_2]in reply to comment from [_3][_4]' => '[_1] [_2]en respuesta al comentario de [_3][_4]',
	'Write a comment...' => 'Escriba un comentario...',

## plugins/Motion/templates/Motion/login_form.mtml
	'Not a member?&nbsp;&nbsp;<a href="[_1]">Sign Up</a>!' => '¿No es usuario?&nbsp;&nbsp;¡<a href="[_1]">Inscríbase</a>!',
	'Forgot?' => '¿Recordar?',

## plugins/Motion/templates/Motion/widget_members.mtml

## plugins/Motion/templates/Motion/user_profile.mtml
	'Recent Actions from [_1]' => 'Acciones recientes de [_1]',
	'Responses to Comments from [_1]' => 'Respuestas a los comentarios de [_1]',
	'You are following [_1].' => 'Estás siguiendo a [_1]',
	'Unfollow' => 'Dejar de seguir',
	'Follow' => 'Seguir',
	'Profile Data' => 'Datos del perfil',
	'More Entries by [_1]' => 'Más entradas de [_1]',
	'Recent Actions' => 'Acciones recientes',
	'_PROFILE_COMMENT_LENGTH' => '10',
	'Comment Threads' => 'Hilos de comentarios',
	'[_1] commented on ' => '[_1] comentó en',
	'No responses to comments.' => 'Sin respuestas a comentarios.',

## plugins/Motion/templates/Motion/actions.mtml
	'[_1] is now following [_2]' => '[_1] ahora sigue a [_2]',
	'[_1] favorited [_2] on [_3]' => '[_1] recomendó [_2] en [_3]',

## plugins/Motion/templates/Motion/motion_js.mtml
	'Add userpic' => 'Añadir avatar',

## plugins/Motion/templates/Motion/widget_powered_by.mtml

## plugins/Motion/templates/Motion/widget_following.mtml
	'Following' => 'Siguiendo',
	'Not following anyone' => 'No sigue a nadie',

## plugins/Motion/config.yaml
	'A Movable Type theme with structured entries and action streams.' => 'Tema de Movable Type con entradas estructuradas y torrentes de acciones.',
	'Adjusting field types for embed custom fields...' => 'Ajustando los tipos de campos para campos personalizados embebidos...',
	'Updating favoriting namespace for Motion...' => 'Actualizando el espacio de nombres de los favoritos para Motion...',
	'Motion Themes' => 'Temas de Motion',
	'Themes for Motion template set' => 'Temas para el conjunto de plantillas Motion',
	'Motion' => 'Motion',
	'Post Type' => 'Tipo de entrada',
	'Embed Object' => 'Embeber objeto',
	'MT JavaScript' => 'MT JavaScript',
	'Motion MT JavaScript' => 'Motion MT JavaScript',
	'Motion JavaScript' => 'Motion JavaScript',
	'Entry Listing: Monthly' => 'Lista de entradas: Mensual',
	'Entry Listing: Category' => 'Lista de entradas: Categorías',
	'|' => '|',
	'Entry Response' => 'Respuesta a la entrada',
	'Profile View' => 'Ver perfil',
	'Profile Edit Form' => 'Formulario de edición del perfil',
	'Profile Error' => 'Error del perfil',
	'Profile Feed' => 'Sindicación del perfil',
	'Login Form' => 'Formulario de inicio de sesión',
	'Register Confirmation' => 'Confirmación de registro',
	'New Password Reset Form' => 'Formulario de reinicio de contraseña',
	'New Password Form' => 'Formulario de nueva contraseña',
	'User Profile' => 'Perfil del usuario',
	'About Pages' => 'Páginas Acerca de',
	'About Site' => 'Sobre el sitio',
	'Gallery' => 'Galería',
	'Main Column Actions' => 'Acciones de la columna principal',
	'Main Column Posting Form (All Media)' => 'Formulario de publicación de la columna principal (Todos los medios)',
	'Main Column Posting Form (Text Only, Like Twitter)' => 'Formulario de publicación de la columna principal (Solo texto, como Twitter)',
	'Main Column Registration' => 'Registro de la columna principal',
	'Elsewhere' => 'En otros sitios',
	'User Archives' => 'Archivos de usuario',
	'Blogroll' => 'Enlaces',
	'Feeds' => 'Sindicación',

## plugins/feeds-app-lite/lib/MT/Feeds/Lite.pm
	'An error occurred processing [_1]. The previous version of the feed was used. A HTTP status of [_2] was returned.' => 'Ocurrió un error procesando [_1]. Se utilizó la versión previa de la fuente. Se devolvió el estado HTTP [_2].',
	'An error occurred processing [_1]. A previous version of the feed was not available.A HTTP status of [_2] was returned.' => 'Ocurrió un error procesando [_1]. La versión anterior de la fuente no estaba disponible. Se devolvió el estado HTTP [_2].',

## plugins/feeds-app-lite/lib/MT/Feeds/Tags.pm
	'\'[_1]\' is a required argument of [_2]' => '\'[_1]\' es un argumento necesario de [_2]',
	'MT[_1] was not used in the proper context.' => 'MT[_1] no se está utilizando en el contexto adecuado.',

## plugins/feeds-app-lite/tmpl/config.tmpl
	'Feeds.App Lite Widget Creator' => 'Creador de widgets de Feeds.App Lite',
	'Configure feed widget settings' => 'Configurar widgets de sindicación',
	'Enter a title for your widget.  This will also be displayed as the title of the feed when used on your published blog.' => 'Teclee un título para su widget. Esto también se mostrará como título de la fuente en el blog.',
	'[_1] Feed Widget' => 'Widget de sindicación [_1]',
	'Select the maximum number of entries to display.' => 'Seleccione el máximo número de entradas a mostrar.',
	'3' => '3',
	'5' => '5',
	'10' => '10',
	'All' => 'Todos',

## plugins/feeds-app-lite/tmpl/msg.tmpl
	'No feeds could be discovered using [_1]' => 'No se descubrieron fuentes usando [_1]',
	'An error occurred processing [_1]. Check <a href="javascript:void(0)" onclick="closeDialog(\'http://www.feedvalidator.org/check.cgi?url=[_2]\')">here</a> for more detail and please try again.' => 'Ocurrió un error procesando [_1]. Compruebe <a href="javascript:void(0)" onclick="closeDialog(\'http://www.feedvalidator.org/check.cgi?url=[_2]\')">aquí</a> los detalles e inténtelo de nuevo.',
	'A widget named <strong>[_1]</strong> has been created.' => 'Se creó un widget titulado <strong>[_1]</strong>.',
	'You may now <a href="javascript:void(0)" onclick="closeDialog(\'[_2]\')">edit &ldquo;[_1]&rdquo;</a> or include the widget in your blog using <a href="javascript:void(0)" onclick="closeDialog(\'[_3]\')">WidgetManager</a> or the following MTInclude tag:' => 'Ahora puede <a href="javascript:void(0)" onclick="closeDialog(\'[_2]\')">editar &ldquo;[_1]&rdquo;</a> o incluir el widget su blog utilizando <a href="javascript:void(0)" onclick="closeDialog(\'[_3]\')">WidgetManager</a> o la siguiente etiqueta MTInclude:',
	'You may now <a href="javascript:void(0)" onclick="closeDialog(\'[_2]\')">edit &ldquo;[_1]&rdquo;</a> or include the widget in your blog using the following MTInclude tag:' => 'Ahora puede <a href="javascript:void(0)" onclick="closeDialog(\'[_2]\')">editar &ldquo;[_1]&rdquo;</a> o incluir el widget en su blog utilizando la siguiente etiqueta MTInclude:',
	'Create Another' => 'Crear otro',

## plugins/feeds-app-lite/tmpl/start.tmpl
	'You must enter a feed or site URL to proceed' => 'Debe introducir una fuente o una URL de un sitio para proceder.',
	'Create a widget from a feed' => 'Crear un widget de una fuente',
	'Feed or Site URL' => 'URL del sitio o fuente',
	'Enter the URL of a feed, or the URL of a site that has a feed.' => 'Introduzca la URL de una fuente de sindicación, o la URL de un sitio que tenga una fuente.',

## plugins/feeds-app-lite/tmpl/select.tmpl
	'Multiple feeds were found' => 'Se encontraron múltiples fuentes',
	'Select the feed you wish to use. <em>Feeds.App Lite supports text-only RSS 1.0, 2.0 and Atom feeds.</em>' => 'Seleccione la fuente que desea usar. <em>Feeds.App Lite soporta las fuentes con solo texto RSS 1.0, 2.0 y Atom.',
	'URI' => 'URI',

## plugins/feeds-app-lite/mt-feeds.pl
	'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type? <a href="http://code.appnel.com/feeds-app" target="_blank">Upgrade to Feeds.App</a>.' => 'Feeds.App Lite le ayuda a republicar fuentes de sindicación en los blogs. ¿Quiere hacer más cosas con la sindicación en Movable Type? <a href="http://code.appnel.com/feeds-app" target="_blank">Actualícese a Feeds.App</a>.',
	'Create a Feed Widget' => 'Crear un widget de fuente',

## plugins/mixiComment/lib/mixiComment/App.pm
	'mixi reported that you failed to login.  Try again.' => 'mixi informó que falló la identificación. Inténtelo de nuevo.',

## plugins/mixiComment/tmpl/config.tmpl
	'A mixi ID has already been registered in this blog.  If you want to change the mixi ID for the blog, <a href="[_1]">click here</a> to sign in using your mixi account.  If you want all of the mixi users to comment to your blog (not only your my mixi users), click the reset button to remove the setting.' => 'Ya se ha registrado un ID de mixi en este blog. Si desea modificar el ID de mixi del blog, <a href="[_1]">haga clic aquí</a> para identificarse en su cuenta de mixi. Si desea que todos los usuarios de mixi puedan comentar en el blog (no solo sus usuarios de my mixi), haga clic en el botón de reiniciar para eliminar la configuración.',
	'If you want to restrict comments only from your my mixi users, <a href="[_1]">click here</a> to sign in using your mixi account.' => 'Si desea restringir los comentarios a sus usuarios de my mixi, <a href="[_1]">haga clic aquí</a> para identificarse en su cuenta de mixi.',

## plugins/mixiComment/mixiComment.pl
	'Allows commenters to sign in to Movable Type using their own mixi username and password via OpenID.' => 'Permite a los comentaristas identificarse en Movable Type usando su propio usuario y contraseña de mixi vía OpenID.',
	'Sign in using your mixi ID' => 'Identifíquese usando su ID de mixi ID',
	'Click the button to sign in using your mixi ID' => 'Click the button to sign in using your mixi ID',
	'mixi' => 'mixi',

);

## New words: 377

1;
