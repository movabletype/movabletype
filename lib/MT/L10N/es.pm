# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id:$

package MT::L10N::es;
use strict;
use utf8;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

## The following is the translation table.

%Lexicon = (

## php/lib/archive_lib.php
	'Individual' => 'Inidivual',
	'Page' => 'Página',
	'Yearly' => 'Anuales',
	'Monthly' => 'Mensuales',
	'Daily' => 'Diarias',
	'Weekly' => 'Semanales',
	'Author' => 'Autor',
	'(Display Name not set)' => '(Nombre no configurado)',
	'Author Yearly' => 'Anuales del autor',
	'Author Monthly' => 'Mensuales del autor',
	'Author Daily' => 'Diarios del autor',
	'Author Weekly' => 'Semanales del autor',
	'Category Yearly' => 'Categorías anuales',
	'Category Monthly' => 'Categorías mensuales',
	'Category Daily' => 'Categorías diarias',
	'Category Weekly' => 'Categorías semanales',
	'Category' => 'Categoría',

## php/lib/block.mtassets.php
	'sort_by="score" must be used together with a namespace.' => 'sort_by="score" debe usarse junto al espacio de nombres.',

## php/lib/block.mtauthorhasentry.php
	'No author available' => 'Ningún autor disponible',

## php/lib/block.mtauthorhaspage.php

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without establishing a date context.' => 'Utilizó una etiqueta [_1] sin indicar un contexto de fecha.',

## php/lib/block.mtentries.php

## php/lib/block.mtif.php
	'You used an [_1] tag without a valid name attribute.' => 'Utilizó una etiqueta [_1] sin un atributo de nombre válido.',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] es ilegal.',

## php/lib/block.mtsethashvar.php

## php/lib/block.mtsetvarblock.php
	'You used a [_1] tag without a valid name attribute.' => 'Usó la etiqueta [_1] sin un nombre de atributo válido.',
	'\'[_1]\' is not a hash.' => '\'[_1]\' no es un hash.',
	'Invalid index.' => 'Índice no válido.',
	'\'[_1]\' is not an array.' => '\'[_1]\' no es un array.',
	'\'[_1]\' is not a valid function.' => '\'[_1]\' no es una función válida.',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters shown in the picture above.' => 'Teclee los caracteres mostrados en la imagen de arriba.',

## php/lib/function.mtassettype.php
	'image' => 'Imagen',
	'Image' => 'Imagen',
	'file' => 'fichero',
	'File' => 'Fichero',
	'audio' => 'Audio',
	'Audio' => 'Audio',
	'video' => 'Vídeo',
	'Video' => 'Vídeo',

## php/lib/function.mtauthordisplayname.php

## php/lib/function.mtcommentauthorlink.php
	'Anonymous' => 'Anónimo',

## php/lib/function.mtcommentauthor.php

## php/lib/function.mtcommenternamethunk.php
	'The \'[_1]\' tag has been deprecated. Please use the \'[_2]\' tag in its place.' => 'La etiqueta \'[_1]\' está obsoleta. Por favor, utilice en su lugar la etiqueta \'[_2]\'.',

## php/lib/function.mtcommentreplytolink.php
	'Reply' => 'Responder',

## php/lib/function.mtentryclasslabel.php
	'Entry' => 'Entrada',

## php/lib/function.mtinclude.php
	'\'parent\' modifier cannot be used with \'[_1]\'' => 'el modificador \'parent\' no puede usarse con \'[_1]\'',

## php/lib/function.mtpasswordvalidation.php
	'Password should be longer than [_1] characters' => 'La clave debe tener más de [_1] caracteres',
	'Password should not include your Username' => 'La clave no debe incluir el nombre de usuario',
	'Password should include letters and numbers' => 'La clave debe incluir letras y números',
	'Password should include lowercase and uppercase letters' => 'La clave debe incluir letras en mayúsculas y minúsculas',
	'Password should contain symbols such as #!$%' => 'La clave debe contener símbolos como #!$%',
	'You used an [_1] tag without a valid [_2] attribute.' => 'Utilizó una etiqueta [_1] sin un atributo [_2] válido.',

## php/lib/function.mtpasswordvalidationrule.php
	'minimum length of [_1]' => 'longitud mínima de [_1]',
	', uppercase and lowercase letters' => ', letras mayúsculas y minúsculas',
	', letters and numbers' => ', letras y números',
	', symbols (such as #!$%)' => ', símbolos (como #!$%)',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled for this blog.  MTRemoteSignInLink cannot be used.' => 'La autentificación de TypePad no está activada para este blog. No se puede utilizar MTRemoteSignInLink.',

## php/lib/function.mtsetvar.php

## php/lib/function.mttagsearchlink.php
	'Invalid [_1] parameter.' => 'Parámetro [_1] no válido',

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '\'[_1]\' no es una función válida para un hash.',
	'\'[_1]\' is not a valid function for an array.' => '\'[_1]\' no es una función válida para un array.',

## php/lib/mtdb.base.php
	'When the exclude_blogs and include_blogs attributes are used together, the same blog IDs should not be listed as parameters to both of them.' => 'Cuando se usan juntos los atributos exclude_blogs y include_blogs, no deben indicarse los mismos identificadores de blogs como parámetros de ambos.',

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'avatar-[_1]-%wx%h%x',

## php/mt.php
	'Page not found - [_1]' => 'Página no encontrada - [_1]',

## mt-check.cgi
	'Movable Type System Check' => 'Comprobación del sistema - Movable Type',
	'You attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'Ha intentado usar una característica para la que no tiene permisos. Si cree que está viendo este mensaje por error, contacte con sus administrador del sistema.',
	'The MT-Check report is disabled when Movable Type has a valid configuration file (mt-config.cgi)' => 'El informe de MT-Check se deshabilita cuando Movable Type tiene un fichero válido de configuración (mt-config.cgi)',
	q{The mt-check.cgi script provides you with information about your system's configuration and determines whether you have all of the components you need to run Movable Type.} => q{El script mt-check.cgi le ofrece información sobre la configuración del sistema y determina si posee todos los componentes necesarios para ejecutar Movable Type.},
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). Please upgrade to at least Perl [_2].' => 'La versión de Perl instalada en su servidor ([_1]) es menor que la versión mínima soportada ([_2]). Por favor, actualícese por lo menos a Perl [_2].',
	'System Information' => 'Información del sistema',
	'Movable Type version:' => 'Versión de Movable Type:',
	'Current working directory:' => 'Directorio actual de trabajo:',
	'MT home directory:' => 'Directorio de inicio de MT:',
	'Operating system:' => 'Sistema operativo:',
	'Perl version:' => 'Versión de Perl:',
	'Perl include path:' => 'Ruta de búsqueda de Perl:',
	'Web server:' => 'Servidor web:',
	'(Probably) running under cgiwrap or suexec' => '(Probablemente) Ejecución bajo cgiwrap o suexec',
	'[_1] [_2] Modules' => 'Módulos [_1] [_2]',
	'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that they provide.' => 'Los siguientes módulos son <strong>opcionales</strong>. Si el servidor no tiene estos módulos instalados, sólo deberá instalarlos si necesita la funcionalidad que proporcionan.',
	'The following modules are required by databases that can be used with Movable Type. Your server must have DBI and at least one of these related modules installed for the application to work properly.' => 'Las bases de datos necesitan los siguientes módulos para su uso con Movable Type. Para que funcione correctamente, el servidor debe tener instalado DBI y al menos uno de estos módulos relacionados. The following modules are required by databases that can be used with Movable Type.',
	'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'Su sistema o no tiene [_1] instalado, la versión instalada es antigua, o [_1] necesita otro módulo que no está instalado.',
	'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => 'El servidor no tiene [_1] instalado o [_1] necesita otro módulo que no está instalado.',
	'Please consult the installation instructions for help in installing [_1].' => 'Por favor, consulte las instrucciones de instalación si quiere ayuda sobre la instalación de [_1].',
	'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the most current release available.' => 'La versión de DBD::mysql que ha instalado no es compatible con Movable Type. Por favor, instale la versión más reciente.',
	'The $mod is installed properly, but requires an updated DBI module. Please see the note above regarding the DBI module requirements.' => 'El $mod está instalado correctamente, pero necesita un módulo DBI reciente. Por favor, lea la nota de arriba sobre los requerimientos del módulo DBI.',
	'Your server has [_1] installed (version [_2]).' => 'El servidor tiene [_1] instalado (versión [_2]).',
	'Movable Type System Check Successful' => 'Comprobación del sistema realizada con éxito',
	q{You're ready to go!} => q{¡Ya está preparado!},
	'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'El servidor tiene todos los módulos necesarios instalados; no tiene que realizar ninguna instalación adicional. Continúe con las instrucciones de instalación.',
	'CGI is required for all Movable Type application functionality.' => 'El CGI es requerido para todas las funciones del Sistema Movable Type.',
	'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size es necesario para subir ficheros (determina el tamaño de las imágenes transferidas en muchos formatos diferentes).',
	'File::Spec is required to work with file system path information on all supported operating systems.' => 'File::Spec es necesario para trabajar con las rutas del sistema de ficheros en todos los sistemas operativos.',
	'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie es necesario para la autentificación de cookies.',
	'LWP::UserAgent is required for creating Movable Type configuration files using the installation wizard.' => 'LWP::UserAgent es necesario para crear ficheros de configuración de Movable Type mediante el asistente de instalación.',
	'Scalar::Util is required for initializing Movable Type application.' => 'Scalar::Util es necesario para inicializar la aplicación de Movable Type.',
	'DBI is required to work with most supported databases.' => 'DBI es necesario para trabajar con la mayoría de las bases de datos soportadas.',
	'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI y DBD::mysql son necesarios si quiere usar la base de datos MySQL.',
	'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI y DBD::Pg son necesarios si quiere usar la base de datos PostgreSQL.',
	'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI y DBD::SQLite son necesarios si quiere usar la base de datos SQLite.',
	'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI y DBD::SQLite2 son necesarios si quiere usar la base de datos SQLite 2.x.',
	'Digest::SHA is required in order to provide enhanced protection of user passwords.' => 'Digest::SHA es necesario para ofrecer protección avanzada de las contraseñas de usuarios.',
	'This module and its dependencies are required in order to operate Movable Type under psgi.' => 'Este módulo y sus dependencias son necesarios para ejecutar Movable Type bajo psgi.',
	'This module and its dependencies are required to run Movable Type under psgi.' => 'Este módulo y sus dependencias son necesarios para ejecutar Movable Type bajo psgi.',
	'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in the configuration file.' => 'HTML::Entities es necesario para codificar algunos caracteres, pero puede desactivar esta funcionalidad usando la opción NoHTMLEntities en el fichero de configuración.',
	'HTML::Parser is optional; It is needed if you want to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'HTML::Parser es opcional; Es necesario si desea usar el sistema de TrackBacks, el ping a weblogs.com o el ping a las actualizaciones recientes de MT.',
	'SOAP::Lite is optional; It is needed if you want to use the MT XML-RPC server implementation.' => 'SOAP::Lite es opcional; es necesario si desea usar la implementación del servidor XML-RCP de Movable Type.',
	'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Temp es opcional; es necesario si desea sobreescribir ficheros existentes al subir ficheros.',
	'List::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'Lista: Útiles opcionales; esto es necesario si usted desea utilizar la función cola de publicación',
	'[_1] is optional; It is one of the image processors that you can use to create thumbnails of uploaded images.' => '[_1] es opcional. Es uno de los procesadores de imágenes que pueden usarse para crear miniaturas de las imágenes transferidas.',
	'IPC::Run is optional; It is needed if you would like to use NetPBM as the image processor for Movable Type.' => 'IPC::Run es opcional. Es necesario si va a utilizar NetPBM como procesador de imágenes en Movable Type.',
	'Storable is optional; It is required by certain Movable Type plugins available from third-party developers.' => 'Storable es opcional. Es necesario por algunas extensiones de Movable Type disponibles a través de terceros desarrolladores.',
	'Crypt::DSA is optional; If it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSA es opcional; si está instalado, se acelerará el registro de identificación de comentarios.',
	'This module and its dependencies are required to permit commenters to authenticate via OpenID providers such as AOL and Yahoo! that require SSL support. Also this module is required for Google Analytics site statistics.' => 'Este módulo y sus dependencias son necesarios para permitir a los comentaristas que se autentifiquen mediante proveedores de OpenID, como AOL y Yahoo!, que requieren soporte de SSL. Además, este módulo es necesario para las estadísticas de Google Analytics.',
	'Cache::File is required if you would like to be able to allow commenters to authenticate via OpenID using Yahoo! Japan.' => 'Cache::File es necesario si desea que los comentaristas se puedan autentificar vía OpenID utilizando Yahoo! Japón.',
	'MIME::Base64 is required in order to enable comment registration and in order to send mail via an SMTP Server.' => 'MIME::Base64 es necesario para activar el registro de comentarios y poder enviar correos a través de un servidor SMTP.',
	'XML::Atom is required in order to use the Atom API.' => 'XML::Atom es necesario para usar el API de Atom.',
	'Cache::Memcached and a memcached server are required to use in-memory object caching on the servers where Movable Type is deployed.' => 'Cache::Memcached y un servidor memcached son necesarios para utilizar la caché en memoria de objetos en los servidores donde se vaya instalar Movable Type.',
	'Archive::Tar is required in order to manipulate files during backup and restore operations.' => 'Archive::Tar es necesario para manipular ficheros durante las operaciones de copias de seguridad y restauraciones.',
	'IO::Compress::Gzip is required in order to compress files during backup operations.' => 'IO::Compress::Gzip es necesario para comprimir los ficheros durante las operaciones de copias de seguridad.',
	'IO::Uncompress::Gunzip is required in order to decompress files during restore operation.' => 'IO::Uncompress::Gunzip es necesario para descomprimir ficheros durante la operación de restauración.',
	'Archive::Zip is required in order to manipulate files during backup and restore operations.' => 'Archive::Zip es necesario para manipular ficheros durante las operaciones de copias de seguridad y restauraciones.',
	'XML::SAX and its dependencies are required to restore a backup created in a backup/restore operation.' => 'XML::SAX y sus dependencias son necesarias para restaurar una copia de seguridad creada en una operación de copia de seguridad/restauración.',
	'Digest::SHA1 and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.' => 'Digest::SHA1 y sus dependencias son necesarias para que los comentaristas se autentifiquen mediante proveedores OpenID, incluyendo LiveJournal.',
	'Net::SMTP is required in order to send mail via an SMTP Server.' => 'Net::SMTP es necesario para enviar correos vía servidores SMTP.',
	'This module and its dependencies are required in order to support CRAM-MD5, DIGEST-MD5 or LOGIN SASL mechanisms.' => 'Este módulo y sus dependencias son necesarios para dar soporte a los mecanismos CRAM-MD5, DIGEST-MD5 o LOGIN SASL.',
	'IO::Socket::SSL is required in all of the SSL/TLS connection, such as Google Analytics site statistics or SMTP Auth over SSL/TLS.' => 'IO::Socket::SSL es necesario para todas las conexiones SSL/TLS, como las estadísticas de Google Analytics o la autentificación SMTP mediante SSL/TLS.', # Translate - New
	'Net::SSLeay is required to use SMTP Auth over an SSL connection, or to use it with a STARTTLS command.' => 'Net::SSLeay es necesario para usar autentificación SMTP con una conexión SSL o con el comando STARTTLS.',
	'This module is used in a test attribute for the MTIf conditional tag.' => 'La etiqueta condicional MTIf utiliza este módulo en un atributo de comprobación.',
	'This module is used by the Markdown text filter.' => 'El filtro de textos Markdown utiliza este módulo.',
	'This module is required by mt-search.cgi, if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'mt-search.cgi necesita este módulo si está usando Movable Type con una versión de Perl anterior a Perl 5.8.',
	'This module required for action streams.' => 'Este módulo es necesario para los torrentes de acciones.',
	'[_1] is optional; It is one of the modules required to restore a backup created in a backup/restore operation' => '[_1] es opcional; Este es uno de los módulos necesarios para restaurar una copia de seguridad.',
	'This module is required for Google Analytics site statistics and for verification of SSL certificates.' => 'Este módulo es necesario para las estadísticas de Google Analytics y para la verificación de certificados SSL.',
	'This module is required for executing run-periodic-tasks.' => 'Este módulo es necesario para la ejecución de run-periodic-tasks (tareas programadas).',
	'[_1] is optional; It is a better, fast and lightweight alternative to YAML::Tiny for YAML file handling.' => '[_1] es opcional; Es una alternativa más rápida y ligera que YAML::Tiny para el manejo de ficheros YAML.',
	'The [_1] database driver is required to use [_2].' => 'Es necesario el controlador de la base de datos [_1] para usar [_2].',
	'DBI is required to store data in database.' => 'DBI es necesario para guardar información en bases de datos.',
	'Checking for' => 'Comprobando',
	'Installed' => 'Instalado',
	'Data Storage' => 'Base de datos',
	'Required' => 'Necesario',
	'Optional' => 'Opcional',
	'Details' => 'Detalles',
	'unknown' => 'desconocido',

## default_templates/about_this_page.mtml
	'About this Entry' => 'Sobre esta entrada',
	'About this Archive' => 'Sobre este archivo',
	'About Archives' => 'Sobre los archivos',
	'This page contains links to all of the archived content.' => 'Esta página contiene enlaces a todos los contenidos archivados.',
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

## default_templates/archive_index.mtml
	'HTML Head' => 'HTML de la cabecera',
	'Archives' => 'Archivos',
	'Banner Header' => 'Logotipo de la cabecera',
	'Monthly Archives' => 'Archivos mensuales',
	'Categories' => 'Categorías',
	'Author Archives' => 'Archivos por autor',
	'Category Monthly Archives' => 'Archivos mensuales por categorías',
	'Author Monthly Archives' => 'Archivos mensuales por autores',
	'Sidebar' => 'Barra lateral',
	'Banner Footer' => 'Logotipo del pie',

## default_templates/archive_widgets_group.mtml
	'This is a custom set of widgets that serve different content depending on the type of archive in which it is included. More info: [_1]' => 'Este es un conjunto personalizado de widgets que muestran distinto contenido dependiendo del tipo de archivo en el que esté incluído. Más información: [_1]',
	'Current Category Monthly Archives' => 'Archivos mensuales de la categoría actual',
	'Category Archives' => 'Archivos por categoría',

## default_templates/author_archive_list.mtml
	'Authors' => 'Autores',
	'[_1] ([_2])' => '[_1] ([_2])',

## default_templates/banner_footer.mtml
	'_POWERED_BY' => 'Motor <a href="http://www.movabletype.org/"><$MTProductName$></a>',
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Este blog tiene una <a href="[_1]">Licencia Creative Commons</a>.',

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

## default_templates/category_archive_list.mtml

## default_templates/category_entry_listing.mtml
	'[_1] Archives' => 'Archivos [_1]',
	'Recently in <em>[_1]</em> Category' => 'Novedades en la categoría <em>[_1]</em>',
	'Entry Summary' => 'Resumen de las entradas',
	'Main Index' => 'Inicio',

## default_templates/comment_detail.mtml
	'[_1] replied to <a href="[_2]">comment from [_3]</a>' => '[_1] respondió al <a href="[_2]">comentario de [_3]</a>',

## default_templates/commenter_confirm.mtml
	'Thank you for registering an account to comment on [_1].' => 'Gracias por registrar una cuenta para comentar en [_1].',
	'For your security and to prevent fraud, we ask you to confirm your account and email address before continuing. Once your account is confirmed, you will immediately be allowed to comment on [_1].' => 'Por su seguridad, y para prevenir fraudes, solicitamos que confirme su cuenta y dirección de correo antes de continuar. Tras confirmar su cuenta, podrá comentar de inmediato en [_1].',
	'To confirm your account, please click on the following URL, or cut and paste this URL into a web browser:' => 'Para confirmar su cuenta, por favor, haga clic en la siguiente URL, o copie y pegue la URL en un navegador:',
	q{If you did not make this request, or you don't want to register for an account to comment on [_1], then no further action is required.} => q{Si no realizó esta petición, o no quiere registrar una cuenta para comentar en [_1], no se necesitan más acciones.},
	'Sincerely,' => 'Cordialmente,',
	'Mail Footer' => 'Pie del correo',

## default_templates/commenter_notify.mtml
	q{This email is to notify you that a new user has successfully registered on the blog '[_1]'. Here is some information about this new user.} => q{Este correo es para notificarle que se ha registrado un nuevo usuario en el blog '[_1]'. Aquí se detallan algunos datos sobre él.},
	'New User Information:' => 'Informaciones sobre el nuevo usuario:',
	'Username: [_1]' => 'Nombre de usuario: [_1]',
	'Full Name: [_1]' => 'Nombre Completo: [_1]',
	'Email: [_1]' => 'Correo Electrónico: [_1]',
	'To view or edit this user, please click on or cut and paste the following URL into a web browser:' => 'Para ver o editar este usuario, por favor, haga clic en (o copie y pegue) la siguiente URL en un navegador:',

## default_templates/comment_listing.mtml
	'Comment Detail' => 'Detalle del comentario',

## default_templates/comment_preview.mtml
	'Previewing your Comment' => 'Vista previa del comentario',
	'Leave a comment' => 'Escribir un comentario',
	'Name' => 'Nombre',
	'Email Address' => 'Dirección de correo electrónico',
	'URL' => 'URL',
	'Replying to comment from [_1]' => 'Respondiendo al comentario de [_1]',
	'Comments' => 'Comentarios',
	'(You may use HTML tags for style)' => '(Puede usar etiquetas HTML para el estilo)',
	'Preview' => 'Vista previa',
	'Submit' => 'Enviar',
	'Cancel' => 'Cancelar',

## default_templates/comment_response.mtml
	'Confirmation...' => 'Confirmación...',
	'Your comment has been submitted!' => '¡El comentario se ha recibido!',
	'Thank you for commenting.' => 'Gracias por comentar.',
	'Your comment has been received and held for review by a blog administrator.' => 'Se ha recibido el comentario y está pendiente de aprobación por parte del administrador del blog.',
	'Comment Submission Error' => 'Error en el envío de comentarios',
	'Your comment submission failed for the following reasons: [_1]' => 'El envío del comentario falló por alguna de las siguientes razones: [_1]',
	'Back' => 'Volver',
	'Return to the <a href="[_1]">original entry</a>.' => 'Volver a la <a href="[_1]">entrada original</a>.',

## default_templates/comments.mtml
	'1 Comment' => '1 comentario',
	'# Comments' => '# comentarios',
	'No Comments' => 'Sin comentarios',
	'Previous' => 'Anterior',
	'Next' => 'Siguiente',
	'The data is modified by the paginate script' => 'Los datos son modificados por el script de paginación',
	'Remember personal info?' => '¿Recordar datos personales?',

## default_templates/comment_throttle.mtml
	'If this was an error, you can unblock the IP address and allow the visitor to add it again by logging in to your Movable Type installation, choosing Blog Config - IP Banning, and deleting the IP address [_1] from the list of banned addresses.' => 'Si fue un error, puede desbloquear la dirección IP y permitir al visitante que lo añada de nuevo iniciando una sesión en Movable Type, seleccionando Bloqueo de IPs y eleminando la dirección IP [_1] de la lista de direcciones bloqueadas.',
	'A visitor to your blog [_1] has automatically been banned by adding more than the allowed number of comments in the last [_2] seconds.' => 'Se bloqueó automáticamente a una persona que visitó su weblog [_1] debido a que insertó más comentarios de los permitidos en menos de [_2] segundos.',
	q{This was done to prevent a malicious script from overwhelming your weblog with comments. The banned IP address is} => q{Se hizo para prevenir que un 'script' malicioso llene el blog con comentarios. La IP bloqueada es},

## default_templates/creative_commons.mtml

## default_templates/current_author_monthly_archive_list.mtml
	'[_1]: Monthly Archives' => '[_1]: Archivos mensuales',

## default_templates/current_category_monthly_archive_list.mtml
	'[_1]' => '[_1]',

## default_templates/date_based_author_archives.mtml
	'Author Yearly Archives' => 'Archivos anuales por autor',
	'Author Weekly Archives' => 'Archivos semanales por autor',
	'Author Daily Archives' => 'Archivos diarios por autor',

## default_templates/date_based_category_archives.mtml
	'Category Yearly Archives' => 'Archivos anuales por categoría',
	'Category Weekly Archives' => 'Archivos semanales por categoría',
	'Category Daily Archives' => 'Archivos diarios por categoría',

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'Página no encontrada',

## default_templates/entry.mtml
	'By [_1] on [_2]' => 'Por [_1] el [_2]',
	'1 TrackBack' => '1 TrackBack',
	'# TrackBacks' => '# TrackBacks',
	'No TrackBacks' => 'Sin trackbacks',
	'Tags' => 'Etiquetas',
	'Trackbacks' => 'Trackbacks',

## default_templates/entry_summary.mtml
	'Continue reading <a href="[_1]" rel="bookmark">[_2]</a>.' => 'Continúe leyendo <a href="[_1]" rel="bookmark">[_2]</a>.',

## default_templates/footer-email.mtml
	'Powered by Movable Type [_1]' => 'Powered by Movable Type [_1]',

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
	'The sign-in attempt was not successful; Please try again.' => 'El intento de registro no tuvo éxito; por favor, inténtelo de nuevo.',

## default_templates/lockout-ip.mtml
	'This email is to notify you that an IP address has been locked out.' => 'Este correo es para notificarle que se ha bloqueado una dirección IP.',
	'IP Address: [_1]' => 'Dirección IP: [_1]',
	'Recovery: [_1]' => 'Recuperación: [_1]',

## default_templates/lockout-user.mtml
	'This email is to notify you that a Movable Type user account has been locked out.' => 'Este correo es para notificarle que se ha bloqueado una cuenta de usuario de Movable Type.',
	'Display Name: [_1]' => 'Nombre: [_1]',
	'If you want to permit this user to participate again, click the link below.' => 'Si desea permitir que este usuario participe de nuevo, haga clic en el enlace de abajo.',

## default_templates/main_index.mtml

## default_templates/main_index_widgets_group.mtml
	'This is a custom set of widgets that only appear on the homepage (or "main_index"). More info: [_1]' => 'Este conjunto de widgets sólo aparece en la página de inicio (o "main_index"). Más información: [_1]',
	'Recent Comments' => 'Comentarios recientes',
	'Recent Entries' => 'Entradas recientes',
	'Recent Assets' => 'Multimedia reciente',
	'Tag Cloud' => 'Nube de etiquetas',

## default_templates/monthly_archive_dropdown.mtml
	'Select a Month...' => 'Seleccione un mes...',

## default_templates/monthly_archive_list.mtml
	'[_1] <a href="[_2]">Archives</a>' => '<a href="[_2]">Archivos</a> [_1]',

## default_templates/monthly_entry_listing.mtml

## default_templates/new-comment.mtml
	q{An unapproved comment has been posted on your site '[_1]', on entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.} => q{Se ha publicado un comentario no aprobado en el sitio '[_1]', en la entrada #[_2] ([_3]). Para que aparezca en el sitio primero debe aprobarlo.},
	q{An unapproved comment has been posted on your site '[_1]', on page #[_2] ([_3]). You need to approve this comment before it will appear on your site.} => q{Se ha publicado un comentario no aprobado en el sitio '[_1]', en la página #[_2] ([_3]). Para que aparezca en el sitio primero debe aprobarlo.},
	q{A new comment has been posted on your site '[_1]', on entry #[_2] ([_3]).} => q{Se ha publicado un nuevo comentario en el sitio '[_1]', en la entrada #[_2] ([_3]).},
	q{A new comment has been posted on your site '[_1]', on page #[_2] ([_3]).} => q{Se ha publicado un nuevo comentario en el sitio '[_1]', en la página #[_2] ([_3]).},
	'Commenter name: [_1]' => 'Nombre del comentarista',
	'Commenter email address: [_1]' => 'Correo electrónico del comentarista: [_1]',
	'Commenter URL: [_1]' => 'URL del comentarista: [_1]',
	'Commenter IP address: [_1]' => 'Dirección IP del comentarista: [_1]',
	'Approve comment:' => 'Comentario aceptado:',
	'View comment:' => 'Ver comentario:',
	'Edit comment:' => 'Editar comentario:',
	'Report the comment as spam:' => 'Marcar el comentario como spam:',

## default_templates/new-ping.mtml
	q{An unapproved TrackBack has been posted on your site '[_1]', on entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Se ha publicado un TrackBack no aprobado en el sitio '[_1]', en la entrada #[_2] ([_3]). Para que aparezca en el sitio primero debe aprobarlo.},
	q{An unapproved TrackBack has been posted on your site '[_1]', on page #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Se ha publicado un TrackBack no aprobado en el sitio '[_1]', en la página #[_2] ([_3]). Para que aparezca en el sitio primero debe aprobarlo.},
	q{An unapproved TrackBack has been posted on your site '[_1]', on category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Se ha publicado un TrackBack no aprobado en el sitio '[_1]', en la categoría #[_2] ([_3]). Para que aparezca en el sitio primero debe aprobarlo.},
	q{A new TrackBack has been posted on your site '[_1]', on entry #[_2] ([_3]).} => q{Se ha publicado un nuevo TrackBack en el sitio '[_1]', en la entrada #[_2] ([_3]).},
	q{A new TrackBack has been posted on your site '[_1]', on page #[_2] ([_3]).} => q{Se ha publicado un nuevo TrackBack en el sitio '[_1]', en la página #[_2] ([_3]).},
	q{A new TrackBack has been posted on your site '[_1]', on category #[_2] ([_3]).} => q{Se ha publicado un nuevo TrackBack en el sitio '[_1]', en la categoría #[_2] ([_3]).},
	'Excerpt' => 'Resumen',
	'Title' => 'Título',
	'Blog' => 'Blog',
	'IP address' => 'Dirección IP',
	'Approve TrackBack' => 'Aprobar TrackBack',
	'View TrackBack' => 'Ver TrackBack',
	'Report TrackBack as spam' => 'Marcar TrackBack como spam',
	'Edit TrackBack' => 'Editar TrackBack',

## default_templates/notify-entry.mtml
	q{A new [lc,_3] entitled '[_1]' has been published to [_2].} => q{Un nuevo [lc,_3] titulado '[_1]' ha sido publicado en [_2].},
	'View entry:' => 'Ver entrada:',
	'View page:' => 'Ver página:',
	'[_1] Title: [_2]' => '[_1] Título: [_2]',
	'Publish Date: [_1]' => 'Fecha de publicación: [_1]',
	'Message from Sender:' => 'Mensaje del expeditor',
	'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'Ha recibido este correo porque seleccionó recibir avisos sobre la publicación de nuevos contenidos en [_1] o porque el autor de la entrada pensó que podría serle de interés. Si no quiere recibir más avisos, por favor, contacte con esta persona:',

## default_templates/openid.mtml
	'[_1] accepted here' => '[_1] aceptado aquí',
	'http://www.sixapart.com/labs/openid/' => 'http://www.sixapart.com/labs/openid/',
	'Learn more about OpenID' => 'Más información sobre OpenID',

## default_templates/page.mtml

## default_templates/pages_list.mtml
	'Pages' => 'Páginas',

## default_templates/powered_by.mtml
	'_MTCOM_URL' => 'http://www.movabletype.com/',

## default_templates/recent_assets.mtml

## default_templates/recent_comments.mtml
	'<strong>[_1]:</strong> [_2] <a href="[_3]" title="full comment on: [_4]">read more</a>' => '<strong>[_1]:</strong> [_2] <a href="[_3]" title="comentario completo en: [_4]">más</a>',

## default_templates/recent_entries.mtml

## default_templates/recover-password.mtml
	'A request was made to change your Movable Type password. To complete this process click on the link below to select a new password.' => 'Se ha solicitado el cambio de su contraseña en Movable Type. Para completar el proceso, haga clic en el enlace de abajo y seleccione una nueva contraseña.',
	'If you did not request this change, you can safely ignore this email.' => 'Si no solicitó este cambio, ignore este mensaje.',

## default_templates/search.mtml
	'Search' => 'Buscar',
	'Case sensitive' => 'Distinguir mayúsculas y minúsculas',
	'Regex search' => 'Expresión regular',

## default_templates/search_results.mtml
	'Search Results' => 'Resultado de la búsqueda',
	'Results matching &ldquo;[_1]&rdquo;' => 'Resultados correspondiente a &ldquo;[_1]&rdquo;',
	'Results tagged &ldquo;[_1]&rdquo;' => 'Resultado de etiquetas &ldquo;[_1]&rdquo;',
	'No results found for &ldquo;[_1]&rdquo;.' => 'Ningún resultado encontrado para &ldquo;[_1]&rdquo;.',
	'Instructions' => 'Instrucciones',
	'By default, this search engine looks for all of the specified words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Por defecto, el motor busca todas las palabras en cualquier orden. Para buscar una frase exacta, enciérrela con comillas:',
	'movable type' => 'movable type',
	'The search engine also supports the AND, OR, and NOT boolean operators:' => 'El motor de búsqueda también tiene soporte para los operadores lógicos AND, OR y NOT:',
	'personal OR publishing' => 'personal OR publicación',
	'publishing NOT personal' => 'publicación NOT personal',

## default_templates/sidebar.mtml
	'2-column layout - Sidebar' => 'Distribución de 2 columnas - Barra lateral',
	'3-column layout - Primary Sidebar' => 'Distribución de 3 columnas - Barra lateral principal',
	'3-column layout - Secondary Sidebar' => 'Distribución de 3 columnas - Barra lateral secundaria',

## default_templates/signin.mtml
	'Sign In' => 'Registrarse',
	'You are signed in as ' => 'Se identificó como ',
	'sign out' => 'salir',
	'You do not have permission to sign in to this blog.' => 'No tiene permisos para identificarse en este blog.',

## default_templates/syndication.mtml
	'Subscribe to feed' => 'Suscribirse a la fuente de sindicación',
	q{Subscribe to this blog's feed} => q{Suscribirse a este blog (XML)},
	'Subscribe to a feed of all future entries tagged &ldquo;[_1]&ldquo;' => 'Suscribirse a las entradas etiquetadas con &ldquo;[_1]&ldquo;',
	'Subscribe to a feed of all future entries matching &ldquo;[_1]&ldquo;' => 'Subscribirse a las entradas que coinciden con &ldquo;[_1]&ldquo;',
	'Feed of results tagged &ldquo;[_1]&ldquo;' => 'Sindicación de los resultados etiquetados con &ldquo;[_1]&ldquo;',
	'Feed of results matching &ldquo;[_1]&ldquo;' => 'Sindicación de los resultados que coinciden con &ldquo;[_1]&ldquo;',

## default_templates/tag_cloud.mtml

## default_templates/technorati_search.mtml
	'Technorati' => 'Technorati',
	q{<a href='http://www.technorati.com/'>Technorati</a> search} => q{Búsqueda en <a href='http://www.technorati.com/'>Technorati</a>},
	'this blog' => 'este blog',
	'all blogs' => 'todos los blogs',
	'Blogs that link here' => 'Blogs que enlazan aquí',

## default_templates/trackbacks.mtml
	'TrackBack URL: [_1]' => 'URL de TrackBack: [_1]',
	'<a href="[_1]">[_2]</a> from [_3] on <a href="[_4]">[_5]</a>' => '<a href="[_1]">[_2]</a> desde [_3] en <a href="[_4]">[_5]</a>',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">Leer más</a>',

## lib/MT/AccessToken.pm
	'AccessToken' => 'Token de acceso',

## lib/MT/App/ActivityFeeds.pm
	'Error loading [_1]: [_2]' => 'Error cargando [_1]: [_2]',
	'An error occurred while generating the activity feed: [_1].' => 'Ocurrió un error mientras se generaba la fuente de actividad: [_1].',
	'Invalid request.' => 'Petición no válida.',
	'No permissions.' => 'Sin permisos.',
	'[_1] TrackBacks' => '[_1] TrackBacks',
	'All TrackBacks' => 'Todos los TrackBacks',
	'[_1] Comments' => '[_1] comentarios',
	'All Comments' => 'Todos los comentarios',
	'[_1] Entries' => '[_1] entradas',
	'All Entries' => 'Todas las entradas',
	'[_1] Activity' => '[_1] actividades',
	'All Activity' => 'Toda las actividades',
	'Movable Type System Activity' => 'Actividad del sistema de Movable Type',
	'Movable Type Debug Activity' => 'Actividad de depuración de Movable Type',
	'[_1] Pages' => '[_1] páginas',
	'All Pages' => 'Todas las páginas',

## lib/MT/App/CMS/Common.pm
	'Some websites were not deleted. You need to delete blogs under the website first.' => 'No se han eliminado algunos sitios. Primero debe borrar los blogs descendientes del sitio.',

## lib/MT/App/CMS.pm
	'Invalid request' => 'Petición no válida',
	'Are you sure you want to remove all trackbacks reported as spam?' => '¿Está seguro de que desea borrar todos los trackbacks marcados como spam?',
	'Are you sure you want to remove all comments reported as spam?' => '¿Está de que desea borrar todos los comentarios marcados como spam?',
	'Add a user to this [_1]' => 'Añadir este usuario a este [_1]',
	'Are you sure you want to reset the activity log?' => '¿Está seguro de querer reiniciar el registro de actividad?',
	'_WARNING_PASSWORD_RESET_MULTI' => 'Va a reiniciar la contraseña de los usuarios seleccionados. Se generarán nuevas contraseñas aleatorias y se enviarán directamente a sus respectivas direcciones de correo electrónico.\n\n¿Desea continuar?',
	'_WARNING_DELETE_USER_EUM' => 'Borrar un usuario es una acción irreversible que crea huérfanos en las entradas del usuario. Si desea retirar un usuario o bloquear su acceso al sistema, se recomienda deshabilitar su cuenta. ¿Está seguro de que desea borrar a los usuarios seleccionados\nPodrán re-crearse a sí mismos si el usuario seleccionado existe en el directorio externo.',
	'_WARNING_DELETE_USER' => 'El borrado de un usuario es una acción irreversible que crea huérfanos de las entradas del usuario. Si desea retirar a un usuario o bloquear su acceso al sistema, la forma recomendada es deshabilitar su cuenta. ¿Está seguro de que desea borrar el/los usuario/s seleccionado/s?',
	'_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' => 'Esta acción restablecerá las plantillas en los blogs seleccionados con la configuración de fábrica. ¿Está seguro de que desea reiniciar las plantillas de los blogs seleccionados?',
	'You are not authorized to log in to this blog.' => 'No está autorizado para acceder a este blog.',
	'No such blog [_1]' => 'No existe el blog [_1]',
	'Invalid parameter' => 'Parámetro no válido',
	'Edit Template' => 'Editar plantilla',
	'Unknown object type [_1]' => 'Tipo de objeto desconocido [_1]',
	'entry' => 'entrada',
	'None' => 'Ninguno',
	'Error during publishing: [_1]' => 'Error durante la publicación: [_1]',
	'The support directory is not writable.' => 'No se puede escribir en el directorio de soporte.',
	'Movable Type was unable to write to its \'support\' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.' => 'Movable Type no pudo escribir en el directorio \'support\'. Por favor, cree un directorio en este lugar: [_1], y asígnele permisos para permitir que el servidor web pueda acceder y escribir en él.',
	'Please contact your Movable Type system administrator.' => 'Por favor, contacte con el administrador de su Movable Type.',
	'ImageDriver is not configured.' => 'ImageDriver no está configurado.',
	'An image processing toolkit, often specified by the ImageDriver configuration directive, is not present on your server or is configured incorrectly. A toolkit must be installed to ensure proper operation of the userpics feature. Please install Image::Magick, NetPBM, GD, or Imager, then set the ImageDriver configuration directive accordingly.' => 'No se ha configurado correctamente, o no está disponible en el sistema, ningún paquete de procesamiento de imágenes, generalmente especificado por la directiva de configuración ImageDriver. Se necesita un paquete gráfico para el correcto funcionamiento de la gestión de avatares. Por favor, instale Image::Magick, NetPBM, GD, o Imager, y configure la directiva ImageDriver adecuadamente.',
	'System Email Address is not configured.' => 'La dirección de correo del sistema no está configurada.',
	'The System Email Address is used in the \'From:\' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events. Please confirm your <a href="[_1]">settings.</a>' => 'Movable Type utiliza la Dirección de correo del sistema en cabecera \'From:\' en los correos enviados por el sistema. Se podrían enviar correos para la recuperación de contraseña, el registro de comentaristas, las notificaciones de comentarios y trackbacks, bloqueos de usuarios e IPs, y en otros eventos menores. Por favor, confirme su <a href="[_1]">configuración</a>.',
	'Cannot verify SSL certificate.' => 'No se pudo verificar el certificado SSL.',
	'Please install Mozilla::CA module. Writing "SSLVerifyNone 1" in mt-config.cgi can hide this warning, but this is not recommended.' => 'Por favor, instale el módulo Mozilla::CA. Para ocultar este aviso, escriba "SSLVerifyNone 1" en mt-config.cgi, aunque no se recomienda.',
	'Can verify SSL certificate, but verification is disabled.' => 'Se puede verificar el certificado SSL, pero la comprobación está desactivada.',
	'You should remove "SSLVerifyNone 1" in mt-config.cgi.' => 'Debe eliminar "SSLVerifyNone 1" de mt-config.cgi',
	'Personal Stats' => 'Estadísticas personales',
	'Movable Type News' => 'Noticias de Movable Type',
	'Websites' => 'Sitios web',
	'Blogs' => 'Blogs',
	'Websites and Blogs' => 'Sitios web y blogs',
	'Notification Dashboard' => 'Panel de notificaciones',
	'Site Stats' => 'Estadísticas del sitio',
	'Blog Stats' => 'Estadísticas del blog',
	'Entries' => 'Entradas',
	'Refresh Templates' => 'Refrescar plantillas',
	'Use Publishing Profile' => 'Utilizar perfil de publicación',
	'Delete all Spam trackbacks' => 'Borrar todos los TrackBacks basura',
	'Delete all Spam comments' => 'Borrar todos los comentarios basura',
	'Create Role' => 'Crear rol',
	'Grant Permission' => 'Otorgar permiso',
	'Clear Activity Log' => 'Borrar el registro de actividad',
	'Download Log (CSV)' => 'Descargar registro (CSV)',
	'Add IP Address' => 'Añadir dirección IP',
	'Add Contact' => 'Añadir contacto',
	'Download Address Book (CSV)' => 'Descargar agenda de direcciones (CSV)',
	'Unpublish Entries' => 'Despublicar entradas',
	'Add Tags...' => 'Añadir etiquetas...',
	'Tags to add to selected entries' => 'Etiquetas a añadir en las entradas seleccionadas',
	'Remove Tags...' => 'Borrar entradas...',
	'Tags to remove from selected entries' => 'Etiquetas a borrar de las entradas seleccionadas',
	'Batch Edit Entries' => 'Editar entradas en lote',
	'Publish' => 'Publicar',
	'Delete' => 'Eliminar',
	'Unpublish Pages' => 'Despublicar páginas',
	'Tags to add to selected pages' => 'Etiquetas a añadir a las páginas seleccionadas',
	'Tags to remove from selected pages' => 'Etiquetas a eliminar de las páginas seleccionadas',
	'Batch Edit Pages' => 'Editar páginas en lote',
	'Tags to add to selected assets' => 'Etiquetas a añadir a los ficheros multimedia seleccionados',
	'Tags to remove from selected assets' => 'Etiquetas a eliminar de los ficheros multimedia seleccionados',
	'Mark as Spam' => 'Marcar como basura',
	'Remove Spam status' => 'Desmarcar como basura',
	'Unpublish TrackBack(s)' => 'Despublicar TrackBack/s',
	'Unpublish Comment(s)' => 'Despublicar comentario/s',
	'Trust Commenter(s)' => 'Confiar en comentarista/s',
	'Untrust Commenter(s)' => 'Desconfiar de comentarista/s',
	'Ban Commenter(s)' => 'Bloquear comentarista/s',
	'Unban Commenter(s)' => 'Desbloquear comentarista/s',
	'Recover Password(s)' => 'Recuperar contraseña/s',
	'Enable' => 'Activar',
	'Disable' => 'Desactivar',
	'Unlock' => 'Desbloquear',
	'Remove' => 'Borrar',
	'Refresh Template(s)' => 'Refrescar plantilla/s',
	'Move blog(s) ' => 'Trasladar blog(s) ',
	'Clone Blog' => 'Clonar blog',
	'Publish Template(s)' => 'Publicar plantilla/s',
	'Clone Template(s)' => 'Clonar plantilla/s',
	'Revoke Permission' => 'Revocar permiso',
	'Assets' => 'Multimedia',
	'Commenters' => 'Comentaristas',
	'Design' => 'Diseño',
	'Listing Filters' => 'Filtros de lista',
	'Settings' => 'Configuración',
	'Tools' => 'Herramientas',
	'Manage' => 'Administrar',
	'New' => 'Nuevo',
	'Folders' => 'Carpetas',
	'TrackBacks' => 'TrackBacks',
	'Templates' => 'Plantillas',
	'Widgets' => 'Widgets',
	'Themes' => 'Temas',
	'General' => 'General',
	'Compose' => 'Componer',
	'Feedback' => 'Respuestas',
	'Registration' => 'Registro',
	'Web Services' => 'Servicios web',
	'IP Banning' => 'Bloqueo de IPs',
	'User' => 'Usuario',
	'Roles' => 'Roles',
	'Permissions' => 'Permisos',
	'Search &amp; Replace' => 'Buscar &amp; Reemplazar',
	'Plugins' => 'Extensiones',
	'Import Entries' => 'Importar entradas',
	'Export Entries' => 'Exportar entradas',
	'Export Theme' => 'Exportar tema',
	'Backup' => 'Copia de seguridad',
	'Restore' => 'Restaurar',
	'Address Book' => 'Agenda',
	'Activity Log' => 'Actividad',
	'Asset' => 'Multimedia',
	'Website' => 'Website',
	'Profile' => 'Perfil',

## lib/MT/App/Comments.pm
	'Error assigning commenting rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable commenting role was found.' => 'Error asignando permisos para comentar al usuario \'[_1] (ID: [_2])\' para el weblog \'[_3] (ID: [_4])\'. No se encontró un rol adecuado.',
	'Cannot load blog #[_1].' => 'No se pudo cargar el blog #[_1].',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Intento de identificación de comentarista no válido desde [_1] en el blog [_2](ID: [_3]) que no permite la autentificación nativa de Movable Type.',
	'Invalid login.' => 'Acceso no válido.',
	'Invalid login' => 'Inicio de sesión no válido',
	'Successfully authenticated, but signing up is not allowed.  Please contact your Movable Type system administrator.' => 'Autentificado con éxito, pero el registro no está habilitado. Por favor, contacte con el administrador de sistemas de Movable Type.',
	'You need to sign up first.' => 'Primero identifíquese',
	'The login could not be confirmed because of a database error ([_1])' => 'No se pudo confirmar el acceso debido a un error de la base de datos ([_1])',
	'Permission denied.' => 'Permiso denegado.',
	'Login failed: permission denied for user \'[_1]\'' => 'Falló la identificación: permiso denegado al usuario \'[_1]\'',
	'Login failed: password was wrong for user \'[_1]\'' => 'Falló la identificación: contraseña errónea del usuario \'[_1]\'',
	'Failed login attempt by disabled user \'[_1]\'' => 'Intento fallido de inicio de sesión por un usuario deshabilitado \'[_1]\'',
	'Failed login attempt by unknown user \'[_1]\'' => 'Intento fallido de inicio de sesión por un usuario desconocido \'[_1]\'',
	'Signing up is not allowed.' => 'No está permitida la inscripción.',
	'Movable Type Account Confirmation' => 'Confirmación de cuenta - Movable Type',
	'Your confirmation has expired. Please register again.' => 'La confirmación caducó. Por favor, regístrese de nuevo.',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Regresar a la página original.</a>',
	'Your confirmation have expired. Please register again.' => 'Su confirmación ha caducado. Por favor, regístrese de nuevo.',
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
	'An error occurred: [_1]' => 'Ocurrió un error: [_1]',
	'Registration is required.' => 'El registro es obligatorio.',
	'Name and E-mail address are required.' => 'El nombre y la dirección de correo son obligatorios.',
	'Invalid email address \'[_1]\'' => 'Dirección de correo-e no válida \'[_1]\'',
	'Invalid URL \'[_1]\'' => 'URL no válida \'[_1]\'',
	'Text entered was wrong.  Try again.' => 'El texto que introdujo es erróneo. Inténtelo de nuevo.',
	'Comment save failed with [_1]' => 'Fallo guardando comentario con [_1]',
	'Comment on "[_1]" by [_2].' => 'Comentario en "[_1]" por [_2].',
	'Publishing failed: [_1]' => 'Falló al publicar: [_1]',
	'Cannot load template' => 'No se pudo cargar la plantilla',
	'Failed comment attempt by pending registrant \'[_1]\'' => 'Falló el intento de comentar por el comentarista pendiente \'[_1]\'',
	'Registered User' => 'Usuario registrado',
	'Cannot load entry #[_1].' => 'No se pudo cargar la entrada #[_1].',
	'You are trying to redirect to external resources. If you trust the site, please click the link: [_1]' => 'Está intentando redireccionar hacia un recurso externo. Si confía en el sitio, haga clic en el enlace: [_1]',
	'No entry was specified; perhaps there is a template problem?' => 'No se especificó ninguna entrada; ¿quizás hay un problema con la plantilla?',
	'Somehow, the entry you tried to comment on does not exist' => 'De alguna manera, la entrada en la que intentó comentar no existe',
	'Invalid entry ID provided' => 'ID de entrada provisto no válido',
	'For improved security, please change your password' => 'Para mejorar la seguridad, por favor cambie su contraseña',
	'All required fields must be populated.' => 'Debe rellenar todos los campos obligatorios.',
	'[_1] contains an invalid character: [_2]' => '[_1] contiene un caracter no válido: [_2]',
	'Display Name' => 'Nombre público',
	'Passwords do not match.' => 'Las contraseñas no coinciden.',
	'Failed to verify the current password.' => 'Falló la verificación de la contraseña actual.',
	'Email Address is invalid.' => 'La dirección de correo no es válida.',
	'URL is invalid.' => 'La URL no es válida.',
	'Commenter profile has successfully been updated.' => 'Se actualizó con éxito el perfil del comentarista.',
	'Commenter profile could not be updated: [_1]' => 'No se pudo actualizar el perfil del comentarista: [_1]',

## lib/MT/App.pm
	'Problem with this request: corrupt character data for character set [_1]' => 'Problema con esta petición: dato corrupto de carácter para el conjunto de caracteres [_1]',
	'Error loading website #[_1] for user provisioning. Check your NewUserefaultWebsiteId setting.' => 'Error cargando el sitio web #[_1] para la provisión de usuarios. Compruebe la directiva NewUserefaultWebsiteId.',
	'First Weblog' => 'Primer weblog',
	'Error loading blog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => 'Error de telécargamiento #[_1] que comprende la creación de Usuarios. Por favor, verifique sus parámetros NewUserTemplateBlogId.',
	'Error provisioning blog for new user \'[_1]\' using template blog #[_2].' => 'Se ha producido un error durante la creación del blog del nuevo usuario \'[_1]\' utilizando la plantilla #[_2].',
	'Error provisioning blog for new user \'[_1]\' (ID: [_2]).' => 'Se ha producido un error durante la creación del blog del nuevo usuario \'[_1]\' (ID: [_2]).',
	'Blog \'[_1]\' (ID: [_2]) for user \'[_3]\' (ID: [_4]) has been created.' => 'Blog \'[_1]\' (ID: [_2]) para el usuario \'[_3]\' (ID: [_4]) ha sido creado.',
	'Error assigning blog administration rights to user \'[_1]\' (ID: [_2]) for blog \'[_3]\' (ID: [_4]). No suitable blog administrator role was found.' => 'Error de asignación de los derechos para el usuario \'[_1]\' (ID: [_2]) para el blog \'[_3]\' (ID: [_4]). Ningún rol de administrador adecuado ha sido encontrado.',
	'Internal Error: Login user is not initialized.' => 'Error interno: Inicio de sesión de usuarios no inicializada.',
	'Sorry, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Lo sentimos, pero no tiene permiso para acceder ninguno de los blogs o sitios web de esta intalación. Si cree que este mensaje se le muestra incorrectamente, por favor, contacte con el administrador de sistemas de Movable Type.',
	'This account has been disabled. Please see your Movable Type system administrator for access.' => 'Esta cuenta ha sido deshabilitada. Por favor, póngase en contacto con el administrador de sistemas de Movable Type.',
	'Failed login attempt by pending user \'[_1]\'' => 'Intento fallido de inicio de sesión de un usuario pendiente \'[_1]\'',
	'This account has been deleted. Please see your Movable Type system administrator for access.' => 'Esta cuenta ha sido eliminada. Para acceder, por favor, contacte con el administrador de sistemas de Movable Type.',
	'User cannot be created: [_1].' => 'No se pudo crear al usuario: [_1].',
	'User \'[_1]\' has been created.' => 'El usuario \'[_1]\' ha sido creado',
	'Our apologies, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Lo sentimos, pero no tiene permisos para acceder a ningún blog o sitio web en esta instalación. Si cree que este mensaje se le muestra por error, por favor, contacte con el administrador de la instalación de Movable Type.',
	'User \'[_1]\' (ID:[_2]) logged in successfully' => 'Usuario \'[_1]\' (ID:[_2]) inició una sesión correctamente',
	'Invalid login attempt from user \'[_1]\'' => 'Intento de acceso no válido del usuario \'[_1]\'',
	'User \'[_1]\' (ID:[_2]) logged out' => 'Usuario \'[_1]\' (ID:[_2]) se desconectó',
	'User requires password.' => 'El usuario necesita una contraseña.',
	'User requires display name.' => 'El usuario necesita un pseudónimo.',
	'Email Address is required for password reset.' => 'La dirección de correo es necesaria para el reinicio de contraseña.',
	'User requires username.' => 'El usuario necesita un nombre.',
	'Username' => 'Nombre de usuario',
	'A user with the same name already exists.' => 'Ya existe un usuario con el mismo nombre.',
	'An error occurred while trying to process signup: [_1]' => 'Ocurrió un error intentando procesar el alta: [_1]',
	'New Comment Added to \'[_1]\'' => 'Nuevo comentario añadido en \'[_1]\'',
	'Close' => 'Cerrar',
	'Failed to open monitoring file that specified by IISFastCGIMonitoringFilePath directive \'[_1]\': [_2]' => 'Falló la apertura del fichero de monitorización especificado por la directiva IISFastCGIMonitoringFilePath \'[_1]\': [_2]',
	'Failed to open pid file [_1]: [_2]' => 'Falló la apertura del fichero pid [_1]: [_2]',
	'Failed to send reboot signal: [_1]' => 'Falló el envío de la señal de reinicio: [_1]',
	'The file you uploaded is too large.' => 'El fichero que transfirió es demasiado grande.',
	'Unknown action [_1]' => 'Acción desconocida [_1]',
	'Warnings and Log Messages' => 'Mensajes de alerta y registro',
	'Removed [_1].' => 'Se eliminó [_1].',
	'You did not have permission for this action.' => 'No tenía permisos para realizar esta acción.',

## lib/MT/App/Search/Legacy.pm
	'A search is in progress. Please wait until it is completed and try again.' => 'Hay una búsqueda en ejecución. Por favor, espere hasta que haya finalizado e inténtelo de nuevo.',
	'Search failed. Invalid pattern given: [_1]' => 'Falló la búsqueda. Patrón no válido: [_1]',
	'Search failed: [_1]' => 'Falló la búsqueda: [_1]',
	'No alternate template is specified for template \'[_1]\'' => 'No se especificó una plantilla alternativa para la plantilla',
	'File not found: [_1]' => 'Fichero no encontrado: [_1]',
	'Opening local file \'[_1]\' failed: [_2]' => 'Fallo abriendo el fichero local \'[_1]\': [_2]',
	'Publishing results failed: [_1]' => 'Fallo la publicación de resultados: [_1]',
	'Search: query for \'[_1]\'' => 'Búsqueda: encontrar \'[_1]\'',
	'Search: new comment search' => 'Búsqueda: nueva búsqueda de comentarios',

## lib/MT/App/Search.pm
	'Invalid type: [_1]' => 'Tipo no válido: [_1]',
	'Failed to cache search results.  [_1] is not available: [_2]' => 'Fallo al cachear los resultados de la búsqueda.  [_1] no está disponible: [_2]',
	'Invalid format: [_1]' => 'Formato no válido: [_1]',
	'Unsupported type: [_1]' => 'Tipo no soportado: [_1]',
	'Invalid query: [_1]' => 'Consulta no válida: [_1]',
	'Invalid archive type' => 'Tipo de archivo no válido',
	'Invalid value: [_1]' => 'Valor no válido: [_1]',
	'No column was specified to search for [_1].' => 'No se especificó ninguna columna para la búsqueda de [_1].',
	'No such template' => 'No existe dicha plantilla',
	'template_id cannot refer to a global template' => 'template_id no puede hacer referencia a una plantilla global',
	'Output file cannot be of the type asp or php' => 'El fichero de salida no puede ser de tipo asp o php',
	'You must pass a valid archive_type with the template_id' => 'Debe indicar un archive_type válido con el template_id',
	'Template must be an entry_listing for non-Index archive types' => 'La plantilla debe ser un entry_listing para los tipos de archivo que no son índices',
	'Filename extension cannot be asp or php for these archives' => 'La extensión del fichero no puede ser asp o php para estos archivos',
	'Template must be a main_index for Index archive type' => 'La plantilla debe ser main_index para el tipo de archivo Índice',
	'The search you conducted has timed out.  Please simplify your query and try again.' => 'La búsqueda que realizaba sobrepasó el tiempo. Por favor, simplifique la consulta e inténtelo de nuevo.',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearch funciona con MT::App::Search.',

## lib/MT/App/Trackback.pm
	'Invalid entry ID \'[_1]\'' => 'ID de entrada no válido \'[_1]\'',
	'You must define a Ping template in order to display pings.' => 'Debe definir una plantilla de ping para poderlos mostrar.',
	'Trackback pings must use HTTP POST' => 'Los pings de Trackback deben usar HTTP POST',
	'TrackBack ID (tb_id) is required.' => 'TrackBack ID (tb_id) es necesario.',
	'Invalid TrackBack ID \'[_1]\'' => 'ID de TrackBack no válido \'[_1]\'',
	'You are not allowed to send TrackBack pings.' => 'No se le permite enviar pings de TrackBack.',
	'You are sending TrackBack pings too quickly. Please try again later.' => 'Está enviando pings de TrackBack demasiado rápido. Por favor, inténtelo más tarde.',
	'You need to provide a Source URL (url).' => 'Debe indicar una URL fuente (url).',
	'This TrackBack item is disabled.' => 'Este elemento de TrackBack fue deshabilitado.',
	'This TrackBack item is protected by a passphrase.' => 'Este elemento de TrackBack está protegido por una contraseña.',
	'TrackBack on "[_1]" from "[_2]".' => 'TrackBack en "[_1]" de "[_2]".',
	'TrackBack on category \'[_1]\' (ID:[_2]).' => 'TrackBack en la categoría \'[_1]\' (ID:[_2]).',
	'Cannot create RSS feed \'[_1]\': ' => 'No se pudo crear la fuente RSS \'[_1]\': ',
	'New TrackBack ping to \'[_1]\'' => 'Nuevo ping de TrackBack en \'[_1]\'',
	'New TrackBack ping to category \'[_1]\'' => 'Nuevo ping de TrackBack en la categoría \'[_1]\'',

## lib/MT/App/Upgrader.pm
	'Could not authenticate using the credentials provided: [_1].' => 'No se pudo autentificar con las credenciales provistas: [_1]',
	'Both passwords must match.' => 'Ambas contraseñas deben coincidir.',
	'You must supply a password.' => 'Debe introducir una contraseña.',
	'The \'Website Root\' provided below is not allowed' => 'No está permitido el \'Sitio web raíz\' indicado abajo',
	'The \'Website Root\' provided below is not writable by the web server.  Change the ownership or permissions on this directory, then click \'Finish Install\' again.' => 'El servidor web no puede escribir en el \'Sitio web raíz\' indicado abajo. Modifique los permisos de su directorio y luego haga clic en \'Finalizar instalación\'.',
	'Invalid session.' => 'Sesión no válida.',
	'Invalid parameter.' => 'Parámetro no válido.',
	'No permissions. Please contact your Movable Type administrator for assistance with upgrading Movable Type.' => 'Sin permisos. Por favor, contacte con el administrador de Movable Type para obtener asistencia sobre la actualización.',
	'Movable Type has been upgraded to version [_1].' => 'Movable Type ha sido actualizado a la versión [_1].',

## lib/MT/App/Wizard.pm
	'The [_1] driver is required to use [_2].' => 'Es necesario el controlador [_1] para usar [_2].',
	'An error occurred while trying to connect to the database.  Check the settings and try again.' => 'Ocurrió un error intentando conectar a la base de datos. Compruebe la configuración e inténtelo de nuevo.',
	'Please select a database from the list of available databases and try again.' => 'Por favor, seleccione una base de datos de la lista de base de datos disponibles e inténtelo de nuevo.',
	'SMTP Server' => 'Servidor SMTP',
	'Sendmail' => 'Sendmail',
	'Test email from Movable Type Configuration Wizard' => 'Mensaje de comprobación del asistente de configuración de Movable Type',
	'This is the test email sent by your new installation of Movable Type.' => 'Este es el mensaje de comprobación enviado por su nueva instalación de Movable Type.',
	'Net::SMTP is required in order to send mail using an SMTP server.' => 'Net::SMTP es necesario para enviar correo usando un servidor SMTP.',
	'This module is needed to encode special characters, but this feature can be turned off using the NoHTMLEntities option in mt-config.cgi.' => 'Este módulo es necesario para codificar caracteres especiales, pero se puede desactivar esta característica utilizando la opción NoHTMLEntities en mt-config.cgi.',
	'This module is needed if you want to use the MT XML-RPC server implementation.' => 'Este módulo es necesario si desea usar la implementación del servidor XML-RCP de Movable Type.',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Este módulo es necesario si desea poder sobreescribir los ficheros al subirlos.',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Este módulo es necesario si desea poder crear miniaturas de las imágenes subidas.',
	'This module is needed if you would like to be able to use NetPBM as the image driver for MT.' => 'Este módulo es necesario si desea usar NetPBM como controlador de imágenes en MT.',
	'This module is required by certain MT plugins available from third parties.' => 'Este módulo lo necesitan algunas extensiones de MT de terceras partes.',
	'This module accelerates comment registration sign-ins.' => 'Este módulo acelera el registro de identificación en los comentarios.',
	'Cache::File is required if you would like to be able to allow commenters to be authenticated by Yahoo! Japan as OpenID.' => 'Cache::File es necesario si desea que los comentaristas puedan autentificarse por Yahoo! Japan mediante OpenID.',
	'This module is needed to enable comment registration. Also, required in order to send mail via an SMTP Server.' => 'Este módulo es necesario para activar el registro de comentarios. También es necesario para enviar correo vía servidores SMTP.',
	'This module enables the use of the Atom API.' => 'Este módulo permite el uso del interfaz (API) de Atom.',
	'This module is required in order to use memcached as caching mechanism used by Movable Type.' => 'Este módulo es necesario utilizar memcached como mecanismo de caché.',
	'This module is required in order to archive files in backup/restore operation.' => 'Este módulo es necesario para archivar ficheros en las operaciones de copias de seguridad y restauración.',
	'This module is required in order to compress files in backup/restore operation.' => 'Este módulo es ncesario para comprimir ficheros en operaciones de copias de seguridad y restauración.',
	'This module is required in order to decompress files in backup/restore operation.' => 'Este módulo es neesario para descomprimir ficheros en las operaciones de copia de seguridad y restauración.',
	'This module and its dependencies are required in order to restore from a backup.' => 'Este módulo y sus dependencias son necesarios para restaurar una copia de seguridad.',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.' => 'Este módulo y sus dependencias son necesarios para que los comentaristas se autentifiquen mediante proveedores OpenID, incluyendo LiveJournal.',
	'This module is required by mt-search.cgi if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'mt-search.cgi necesita este módulo si está usando Movable Type con una versión de Perl más antigua de la 5.8.',
	'XML::SAX::ExpatXS is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::SAX::ExpatXS es opcional; Es uno de los módulos necesarios para restaurar una copia de seguridad creada mediante la operación de copia de seguridad/restaurar.',
	'XML::SAX::Expat is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::SAX::Expat es opcional; Es uno de los módulos necesarios para restaurar una copia de seguridad creada mediante la operación de copia de seguridad/restaurar.',
	'XML::LibXML::SAX is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::LibXML::SAX es opcional; Es uno de los módulos necesarios para restaurar una copia de seguridad creada mediante la operación de copia de seguridad/restaurar.',
	'YAML::Syck is optional; It is a better, fast and lightweight alternative to YAML::Tiny for YAML file handling.' => 'YAML::Syck es opcional; Es una alternativa mejor, más rápida y ligera que YAML::Tiny para el manejo de ficheros YAML.',
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Este módulo es necesario para subir archivos (para determinar el tamaño de las imágenes en diferentes formatos).',
	'This module is required for cookie authentication.' => 'Este módulo es necsario para la autentificación con cookies.',

## lib/MT/ArchiveType/AuthorDaily.pm
	'AUTHOR-DAILY_ADV' => 'por día y autor',
	'author/author-basename/yyyy/mm/dd/index.html' => 'autor/autor-nombrebase/aaaa/mm/dd/index.html',
	'author/author_basename/yyyy/mm/dd/index.html' => 'autor/autor_nombrebase/yyyy/mm/dd/index.html',

## lib/MT/ArchiveType/AuthorMonthly.pm
	'AUTHOR-MONTHLY_ADV' => 'por mes y autor',
	'author/author-basename/yyyy/mm/index.html' => 'autor/autor-nombrebase/aaaa/mm/index.html',
	'author/author_basename/yyyy/mm/index.html' => 'autor/autor_nombrebase/aaaa/mm/index.html',

## lib/MT/ArchiveType/Author.pm
	'AUTHOR_ADV' => 'por autor',
	'author/author-basename/index.html' => 'autor/autor-nombrebase/index.html',
	'author/author_basename/index.html' => 'autor/autor_nombrebase/index.html',

## lib/MT/ArchiveType/AuthorWeekly.pm
	'AUTHOR-WEEKLY_ADV' => 'por semana y autor',
	'author/author-basename/yyyy/mm/day-week/index.html' => 'autor/autor-nombrebase/aaaa/mm/dia-semana/index.html',
	'author/author_basename/yyyy/mm/day-week/index.html' => 'autor/autor_nombrebase/aaa/mm/dia-semana/index.html',

## lib/MT/ArchiveType/AuthorYearly.pm
	'AUTHOR-YEARLY_ADV' => 'por año y autor',
	'author/author-basename/yyyy/index.html' => 'autor/autor-nombrebase/aaaa/index.html',
	'author/author_basename/yyyy/index.html' => 'autor/autor_nombrebase/aaaa/index.html',

## lib/MT/ArchiveType/CategoryDaily.pm
	'CATEGORY-DAILY_ADV' => 'por día y categoría',
	'category/sub-category/yyyy/mm/dd/index.html' => 'categoría/sub-categoría/aaaa/mm/dd/index.html',
	'category/sub_category/yyyy/mm/dd/index.html' => 'categoría/sub_categoría/aaaa/mm/dd/index.html',

## lib/MT/ArchiveType/CategoryMonthly.pm
	'CATEGORY-MONTHLY_ADV' => 'por mes y categoría',
	'category/sub-category/yyyy/mm/index.html' => 'categoría/sub-categoría/aaaa/mm/index.html',
	'category/sub_category/yyyy/mm/index.html' => 'categoría/sub_categoría/aaaa/mm/index.html',

## lib/MT/ArchiveType/Category.pm
	'CATEGORY_ADV' => 'por categoría',
	'category/sub-category/index.html' => 'categoría/sub-categoría/index.html',
	'category/sub_category/index.html' => 'categoría/sub_categoría/index.html',

## lib/MT/ArchiveType/CategoryWeekly.pm
	'CATEGORY-WEEKLY_ADV' => 'por semana y categoría',
	'category/sub-category/yyyy/mm/day-week/index.html' => 'categoría/sub-categoría/aaaa/mm/día-semana/index.html',
	'category/sub_category/yyyy/mm/day-week/index.html' => 'categoría/sub_categoría/aaaa/mm/día-semana/index.html',

## lib/MT/ArchiveType/CategoryYearly.pm
	'CATEGORY-YEARLY_ADV' => 'por año y categoría',
	'category/sub-category/yyyy/index.html' => 'categoría/sub-categoría/aaaa/index.html',
	'category/sub_category/yyyy/index.html' => 'categoría/sub_categoría/aaaa/index.html',

## lib/MT/ArchiveType/Daily.pm
	'DAILY_ADV' => 'diarios',
	'yyyy/mm/dd/index.html' => 'aaaa/mm/dd/index.html',

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

## lib/MT/ArchiveType/Monthly.pm
	'MONTHLY_ADV' => 'mensuales',
	'yyyy/mm/index.html' => 'aaaa/mm/index.html',

## lib/MT/ArchiveType/Page.pm
	'PAGE_ADV' => 'por página',
	'folder-path/page-basename.html' => 'ruta-carpeta/título-página.html',
	'folder-path/page-basename/index.html' => 'carpeta-path/título-página/index.html',
	'folder_path/page_basename.html' => 'ruta_carpeta/título_pagina.html',
	'folder_path/page_basename/index.html' => 'ruta_carpeta/título_pagina/index.html',

## lib/MT/ArchiveType/Weekly.pm
	'WEEKLY_ADV' => 'semanales',
	'yyyy/mm/day-week/index.html' => 'aaaa/mm/día-de-la-semana/index.html',

## lib/MT/ArchiveType/Yearly.pm
	'YEARLY_ADV' => 'anuales',
	'yyyy/index.html' => 'aaaa/index.html',

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
	'Cannot load image #[_1]' => 'No se pudo cargar la imagen nº[_1]',
	'View image' => 'Ver imagen',
	'Permission denied setting image defaults for blog #[_1]' => 'Se denegó el permiso para cambiar las opciones predefinidos de imágenes del blog nº[_1]',
	'Thumbnail image for [_1]' => 'Imagen miniatura para [_1]',
	'Saving [_1] failed: [_2]' => 'Falló al guardar [_1]: [_2]',
	'Invalid basename \'[_1]\'' => 'Nombre base no válido \'[_1]\'',
	'Error writing to \'[_1]\': [_2]' => 'Error al escribir en \'[_1]\': [_2]',
	'Popup page for [_1]' => 'Abrir en página nueva para [_1]',
	'Scaling image failed: Invalid parameter.' => 'Falló al redimensionar la imagen: Parámetro no válido.',
	'Cropping image failed: Invalid parameter.' => 'Falló al recortar la imagen: Parámetro no válido.',
	'Rotating image failed: Invalid parameter.' => 'Falló al rotar la imagen: Parámetro no válido.',
	'Writing metadata failed: [_1]' => 'Falló al escribir los metadatos: [_1]',
	'Error writing metadata to \'[_1]\': [_2]' => 'Error al escribir los metadatos en \'[_1]\': [_2]',
	'Extracting image metadata failed: [_1]' => 'Falló al extraer los metadatos de la imagen: [_1]',
	'Writing image metadata failed: [_1]' => 'Falló al escribir los metadatos de la imagen: [_1]',

## lib/MT/Asset.pm
	'Deleted' => 'Eliminado',
	'Enabled' => 'Activado',
	'Disabled' => 'Desactivado',
	'missing' => 'perdido',
	'extant' => 'existente',
	'Assets with Missing File' => 'Multimedia con ficheros perdidos',
	'Assets with Extant File' => 'Multimedia con ficheros existentes',
	'Could not remove asset file [_1] from the filesystem: [_2]' => 'No se pudo eliminar el fichero multimedia [_1] del sistema de ficheros: [_2]',
	'Description' => 'Descripción',
	'Location' => 'Lugar',
	'Could not create asset cache path: [_1]' => 'No pudo crear la ruta para el fichero multimedia: [_1]',
	'string(255)' => 'cadena(255)',
	'Label' => 'Título',
	'Type' => 'Tipo',
	'Filename' => 'Nombre del fichero',
	'File Extension' => 'Extensión de ficheros',
	'Pixel width' => 'Anchura px',
	'Pixel height' => 'Altura px',
	'Except Userpic' => 'Avatar Except',
	'Author Status' => 'Estado autor',
	'Missing File' => 'Fichero perdido',
	'Assets of this website' => 'Multimedia de este sitio',

## lib/MT/Asset/Video.pm
	'Videos' => 'Vídeos',

## lib/MT/Association.pm
	'Association' => 'Asociación',
	'Associations' => 'Asociaciones',
	'Permissions with role: [_1]' => 'Permisos con rol: [_1]',
	'Permissions for [_1]' => 'Permisos de [_1]',
	'association' => 'Asociación',
	'associations' => 'Asociaciones',
	'User Name' => 'Nombre',
	'Role' => 'Rol',
	'Role Name' => 'Nombre del rol',
	'Role Detail' => 'Detalles del rol',
	'Website/Blog Name' => 'Website/Blog Name',
	'__WEBSITE_BLOG_NAME' => 'Nombre del sitio/blog',

## lib/MT/AtomServer.pm
	'[_1]: Entries' => '[_1]: Entradas',
	'Invalid blog ID \'[_1]\'' => 'Identificador de blog  \'[_1]\' no válido',
	'PreSave failed [_1]' => 'Fallo en \'PreSave\' [_1]',
	'Removing stats cache failed.' => 'Fallo al eliminar la caché de estadísticas.',
	'User \'[_1]\' (user #[_2]) added [lc,_4] #[_3]' => 'Usuario \'[_1]\' (usuario #[_2]) añadido [lc,_4] #[_3]',
	'User \'[_1]\' (user #[_2]) edited [lc,_4] #[_3]' => 'Usuario \'[_1]\' (usuario #[_2]) editado [lc,_4] #[_3]',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from atom api' => 'Entrada \'[_1]\' ([lc,_5] #[_2]) borrada por \'[_3]\' (usuario #[_4]) desde atom api',
	'\'[_1]\' is not allowed to upload by system settings.: [_2]' => '\'[_1]\' no tiene permisos para transferir a través de la configuración del sistema: [_2].',
	'Invalid image file format.' => 'Formato de imagen no válido.',
	'Cannot make path \'[_1]\': [_2]' => 'No se puede crear la ruta \'[_1]\': [_2]',
	'Perl module Image::Size is required to determine the width and height of uploaded images.' => 'El módulo de Perl Image::Size es necesario para determinar las dimensiones de las imágenes transferidas.',

## lib/MT/Auth/MT.pm
	'Missing required module' => 'Módulo obligatorio no instalado',

## lib/MT/Auth/OpenID.pm
	'Could not save the session' => 'No se pudo guardar la sesión',
	'Could not load Net::OpenID::Consumer.' => 'No se pudo cargar Net::OpenID::Consumer.',
	'The address entered does not appear to be an OpenID endpoint.' => 'La dirección indicada no parece ser un proveedor de OpenID.',
	'The text entered does not appear to be a valid web address.' => 'El texto introducido no parece ser una dirección web válida.',
	'Unable to connect to [_1]: [_2]' => 'No fue posible conectar con [_1]: [_2]',
	'Could not verify the OpenID provided: [_1]' => 'No se pudo verificar el OpenID indicado: [_1]',

## lib/MT/Author.pm
	'Users' => 'Usuarios',
	'Active' => 'Activo',
	'Pending' => 'Pendiente',
	'Not Locked Out' => 'No bloqueado',
	'Locked Out' => 'Bloqueado',
	'__COMMENTER_APPROVED' => 'Aprobado',
	'Banned' => 'Bloqueado',
	'MT Users' => 'Usuarios de MT',
	'The approval could not be committed: [_1]' => 'No se pudo realizar la aprobación: [_1]',
	'Userpic' => 'Avatar',
	'User Info' => 'Info usuario',
	'__ENTRY_COUNT' => 'Entradas',
	'__COMMENT_COUNT' => 'Comentarios',
	'Created by' => 'Creado por',
	'Status' => 'Estado',
	'Website URL' => 'URL del sitio',
	'Privilege' => 'Privilegio',
	'Lockout' => 'Bloquear',
	'Enabled Users' => 'Usuarios habilitados',
	'Disabled Users' => 'Usuarios deshabilitados',
	'Pending Users' => 'Usuarios pendientes',
	'Locked out Users' => 'Bloquear usuarios',
	'Enabled Commenters' => 'Comentaristas habilitados',
	'Disabled Commenters' => 'Comentaristas deshabilitados',
	'Pending Commenters' => 'Comentaristas pendientes',
	'MT Native Users' => 'Usuarios nativos de MT',
	'Externally Authenticated Commenters' => 'Comentaristas autentificados externamente',

## lib/MT/Auth.pm
	'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Configuración incorrecta de AuthenticationModule \'[_1]\': [_2]',
	'Bad AuthenticationModule config' => 'Configuración incorrecta de AuthenticationModule',

## lib/MT/Auth/TypeKey.pm
	'Sign in requires a secure signature.' => 'La identificación necesita una firma segura.',
	'The sign-in validation failed.' => 'Falló el registro de validación.',
	'This weblog requires commenters to pass an email address. If you would like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'En este blog es necesario que los comentaristas indiquen una dirección de correo. Si es lo que desea, puede iniciar una sesión de nuevo e indicarle al servicio de autentificación su dirección.',
	'Could not get public key from the URL provided.' => 'No se pudo obtener una clave pública de la URL indicada.',
	'No public key could be found to validate registration.' => 'No se encontró la clave pública para validar el registro.',
	'TypePad signature verification returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'La verificación de firmas de TypePad retornó [_1] en [_2] segundos verificando [_3] con [_4]',
	'VALID' => 'VALIDA',
	'INVALID' => 'INVALIDO',
	'The TypePad signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct.' => 'La firma de TypePad ha caducado ([_1] segundos vieja). Asegúrese de que el reloj del servidor está en hora.',

## lib/MT/BackupRestore/BackupFileHandler.pm
	'The uploaded file was not a valid Movable Type backup manifest file.' => 'El fichero transferido no es un fichero con un manifiesto válido de copias de seguridad de Movable Type.',
	'The uploaded backup manifest file was created with Movable Type, but the schema version ([_1]) differs from the one used by this system ([_2]).  You should not restore this backup to this version of Movable Type.' => 'El fichero transferido con el manifiesto de copia de seguridad fue creado con Movable Type, pero la versión ([_1]) difiera de la usada en este sistema ([_2]). No debería restaurar esta copia de seguridad en esta versión de Movable Type.',
	'[_1] is not a subject to be restored by Movable Type.' => '[_1] no es un elemento para ser restaurado por Movable Type.',
	'[_1] records restored.' => '[_1] registros restaurados.',
	'Restoring [_1] records:' => 'Restaurando [_1] registros:',
	'A user with the same name as the current user ([_1]) was found in the backup.  Skipping this user record.' => 'En la copia de seguridad se encontró un suuario con el mismo nombre que el usuario actual ([_1]). Este registro de usuario se ignorará.',
	'A user with the same name \'[_1]\' was found in the backup (ID:[_2]).  Restore replaced this user with the data from the backup.' => 'En la copia de seguridad se encontró un usuario con el mismo nombre \'[_2]\' (ID:[_2]). La restauración reemplazó a este usuario con los datos de la copia de seguridad.',
	'Invalid serializer version was specified.' => 'Se especificó una versión no válida del serializador.',
	'Tag \'[_1]\' exists in the system.' => 'La etiqueta \'[_1]\' existe en el sistema.',
	'[_1] records restored...' => '[_1] registros restaurados...',
	'The role \'[_1]\' has been renamed to \'[_2]\' because a role with the same name already exists.' => 'El rol \'[_1]\' se ha renombrado como \'[_2]\' porque ya existía un rol con el mismo nombre.',
	'The system level settings for plugin \'[_1]\' already exist.  Skipping this record.' => 'Ya existe una configuración a nivel del sistema para la extensión \'[_1]\'. Se ignora este registro.',

## lib/MT/BackupRestore/BackupFileScanner.pm
	'Cannot restore requested file because doing so requires the Digest::SHA Perl module. Please contact your Movable Type system administrator.' => 'No se pudo restaurar este fichero porque se necesita el módulo de Perl Digest::SHA. Por favor, contacto con el administrador de sistemas de Movable Type.',
	'Cannot restore requested file because a website was not found in either the existing Movable Type system or the backup data. A website must be created first.' => 'No se pudo restaurar el fichero solicitado porque no se encontró un sitio web ni en el sistema existente de Movable Type ni en las copias de seguridad.',

## lib/MT/BackupRestore/ManifestFileHandler.pm

## lib/MT/BackupRestore.pm
	"\nCannot write file. Disk full." => "
No se pudo escribir el fichero. Disco lleno.",
	'Backing up [_1] records:' => 'Haciendo la copia de seguridad de [_1] registros:',
	'[_1] records backed up...' => '[_1] registros guardados...',
	'[_1] records backed up.' => '[_1] registros guardados..',
	'There were no [_1] records to be backed up.' => 'No habían [_1] registros de los que hacer copia de seguridad.',
	'Cannot open directory \'[_1]\': [_2]' => 'No se puede abrir el directorio \'[_1]\': [_2]',
	'No manifest file could be found in your import directory [_1].' => 'No se encontró fichero de manifiesto en el directorio de importación [_1].',
	'Cannot open [_1].' => 'No se pudo abrir [_1].',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'El fichero [_1] no es un fichero válido de manifiesto para copias de seguridad de Movable Type.',
	'Manifest file: [_1]' => 'Fichero de manifiesto: [_1]',
	'Path was not found for the file, [_1].' => 'No se encontró la ruta del fichero, [_1].',
	'[_1] is not writable.' => 'No puede escribirse en [_1].',
	'Error making path \'[_1]\': [_2]' => 'Error creando la ruta \'[_1]\': [_2]',
	'Copying [_1] to [_2]...' => 'Copiando [_1] a [_2]...',
	'Failed: ' => 'Falló: ',
	'Done.' => 'Hecho.',
	'Restoring asset associations ... ( [_1] )' => 'Restaurando asociaciones de ficheros multimedia ... ( [_1] )',
	'Restoring asset associations in entry ... ( [_1] )' => 'Restaurando asociaciones de ficheros multimedia en la entrada ... ( [_1] )',
	'Restoring asset associations in page ... ( [_1] )' => 'Restaurando asociaciones de ficheros multimedia en página ... ( [_1] )',
	'Restoring url of the assets ( [_1] )...' => 'Restaurando url de ficheros multimedia ( [_1] )...',
	'Restoring url of the assets in entry ( [_1] )...' => 'Restaurando url de ficheros multimedia en la entrada ( [_1] )...',
	'Restoring url of the assets in page ( [_1] )...' => 'Restaurando url de ficheros multimedia en la página ( [_1] )...',
	'ID for the file was not set.' => 'El ID del fichero no está establecido.',
	'The file ([_1]) was not restored.' => 'No se restauró el fichero ([_1]).',
	'Changing path for the file \'[_1]\' (ID:[_2])...' => 'Cambiando la ruta del fichero \'[_1]\' (ID:[_2])...',
	'failed' => 'falló',
	'ok' => 'ok',

## lib/MT/BasicAuthor.pm
	'authors' => 'autores',

## lib/MT/Blog.pm
	'*Website/Blog deleted*' => '*Sitio/blog borrado*',
	'First Blog' => 'Primer blog',
	'No default templates were found.' => 'No se encontraron plantillas predefinidas.',
	'Clone of [_1]' => 'Clon de [_1]',
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
	'Failed to load theme [_1]: [_2]' => 'Fallo al cargar tema [_1]: [_2]',
	'Failed to apply theme [_1]: [_2]' => 'Fallo al aplicar tema [_1]: [_2]',
	'__PAGE_COUNT' => 'Páginas',
	'__ASSET_COUNT' => 'Multimedia',
	'Members' => 'Miembros',
	'Theme' => 'Tema',

## lib/MT/Bootstrap.pm
	'Got an error: [_1]' => 'Ocurrió un error en: [_1]',

## lib/MT/Builder.pm
	'<[_1]> at line [_2] is unrecognized.' => 'No se reconoció a <[_1]> en la línea [_2].',
	'<[_1]> with no </[_1]> on line #' => '<[_1]> sin </[_1]> en la línea #',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]> sin </[_1]> en la línea [_2].',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]> sin </[_1]> en la línea [_2]',
	'Error in <mt[_1]> tag: [_2]' => 'Error en la etiqueta <mt[_1]>: [_2]',
	'Unknown tag found: [_1]' => 'Se encontró una etiqueta desconocida: [_1]',

## lib/MT/Category.pm
	'[quant,_1,entry,entries,No entries]' => '[quant,_1,entraday,entradas,Sin entradas]',
	'[quant,_1,page,pages,No pages]' => '[quant,_1,página,páginas,Sin páginas]',
	'Categories must exist within the same blog' => 'Las categorías deben existir en el mismo blog',
	'Category loop detected' => 'Bucle de categorías detectado',
	'string(100) not null' => 'cadena(100) no vacía',
	'Basename' => 'Nombre base',
	'Parent' => 'Raíz',

## lib/MT/CMS/AddressBook.pm
	'No entry ID was provided' => 'No se especificó el ID de entrada',
	'No such entry \'[_1]\'' => 'No existe la entrada \'[_1]\'',
	'No valid recipients were found for the entry notification.' => 'No se encontraron destinatarios válidos para la notificación de la entrada.',
	'[_1] Update: [_2]' => '[_1] Actualiza: [_2]',
	'Error sending mail ([_1]): Try another MailTransfer setting?' => 'Error enviado correo electrónico ([_1]). Inténtelo de nuevo probando con otra configuración para MailTransfer.',
	'Please select a blog.' => 'Por favor, seleccione un blog.',
	'The text you entered is not a valid email address.' => 'El texto que introdujo no es una dirección de correo válida.',
	'The text you entered is not a valid URL.' => 'El texto que introdujo no es una URL válida.',
	'The e-mail address you entered is already on the Notification List for this blog.' => 'La dirección de correo que introdujo ya está en la Lista de notificaciones de este blog.',
	'Subscriber \'[_1]\' (ID:[_2]) deleted from address book by \'[_3]\'' => 'Suscriptor \'[_1]\' (ID:[_2]) borrado de la agenda por \'[_3]\'',

## lib/MT/CMS/Asset.pm
	'(user deleted)' => '(usuario borrado)',
	'Files' => 'Ficheros',
	'Extension changed from [_1] to [_2]' => 'La extensión cambió de [_1] a [_2]',
	'Failed to create thumbnail file because [_1] could not handle this image type.' => 'Falló al crear el fichero de vista previa porque [_1] no pudo gestionar este formato de imagen.',
	'Upload File' => 'Transferir fichero',
	'Invalid Request.' => 'Petición no válida.',
	'File with name \'[_1]\' already exists. Upload has been cancelled.' => 'El fichero con el nombre \'[_1]\' ya existe. Transferencia cancelada.',
	'Cannot load file #[_1].' => 'No se pudo cargar el fichero nº[_1].',
	'No permissions' => 'No tiene permisos',
	'File \'[_1]\' uploaded by \'[_2]\'' => 'Fichero \'[_1]\' transferido por \'[_2]\'',
	'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Fichero \'[_1]\' (ID:[_2]) transferido por \'[_3]\'',
	'Untitled' => 'Sin título',
	'Archive Root' => 'Raíz de archivos',
	'Site Root' => 'Raíz del sitio',
	'basename of user' => 'nombre base del usuario',
	'<[_1] Root>' => '<[_1] raíz>',
	'<[_1] Root>/[_2]' => '<[_1] raíz/[_2]',
	'Archive' => 'Archivo',
	'Custom...' => 'Personalizar...',
	'Please select a file to upload.' => 'Por favor, seleccione el fichero a transferir',
	'Invalid filename \'[_1]\'' => 'Nombre de fichero no válido \'[_1]\'',
	'Please select an audio file to upload.' => 'Por favor, seleccione el fichero de audio a transferir.',
	'Please select an image to upload.' => 'Por favor, seleccione una imagen a transferir.',
	'Please select a video to upload.' => 'Por favor, seleccione un video a transferir. Please select a video to upload.',
	'Movable Type was unable to write to the "Upload Destination". Please make sure that the webserver can write to this folder.' => 'Movable Type no pudo escribir en el "Destino de las transferencias". Por favor, asegúrese de que el servidor puede escribir en ese directorio.',
	'Invalid extra path \'[_1]\'' => 'Ruta extra no válida \'[_1]\'',
	'Invalid temp file name \'[_1]\'' => 'Nombre de fichero temporal no válido \'[_1]\'',
	'Error opening \'[_1]\': [_2]' => 'Error abriendo \'[_1]\': [_2]',
	'Error deleting \'[_1]\': [_2]' => 'Error borrando \'[_1]\': [_2]',
	'File with name \'[_1]\' already exists. (Install the File::Temp Perl module if you would like to be able to overwrite existing uploaded files.)' => 'Ya existe un fichero con el nombre \'[_1]\'. (Si desea escribir sobre ficheros transferidos anteriormente, instale el módulo de Perl File::Temp).',
	'Error creating a temporary file; The webserver should be able to write to this folder.  Please check the TempDir setting in your configuration file, it is currently \'[_1]\'. ' => 'Error al crear un fichero temporal. El servidor web debe poder escribir en este directorio. Por favor, compruebe la directiva TempDir en el fichero de configuración, actualmente es \'[_1]\'.',
	'unassigned' => 'no asignado',
	'File with name \'[_1]\' already exists; Tried to write to a tempfile, but the webserver could not open it: [_2]' => 'Ya existe un fichero con el nombre \'[_1]\'. Se intentó escribir en un fichero temporal, pero el servidor no pudo abrirlo: [_2]',
	'Could not create upload path \'[_1]\': [_2]' => 'No se pudo crear la ruta de transferencias \'[_1]\': [_2]',
	'Error writing upload to \'[_1]\': [_2]' => 'Error escribiendo transferencia a \'[_1]\': [_2]',
	'Uploaded file is not an image.' => 'El fichero transferido no es una imagen.',
	'Cannot overwrite an existing file with a file of a different type. Original: [_1] Uploaded: [_2]' => 'No se puede escribir sobre un fichero que ya existe con otro fichero de diferente tipo. Original: [_1] Transferido: [_2].',
	'File with name \'[_1]\' already exists.' => 'El fichero con el nombre \'[_1]\' ya existe.',
	'Cannot load asset #[_1].' => 'No se pudo cargar el fichero multimedia #[_1].',
	'Save failed: [_1]' => 'Fallo al guardar: [_1]',
	'Saving object failed: [_1]' => 'Fallo guardando objeto: [_1]',
	'Transforming image failed: [_1]' => 'Falló al modificar la imagen: [_1]',
	'Cannot load asset #[_1]' => 'No se pudo cargar el fichero multimedia #[_1]',
	'<' => '<',
	'/' => '/',

## lib/MT/CMS/BanList.pm
	'You did not enter an IP address to ban.' => 'No tecleó una dirección IP para bloquear.',
	'The IP you entered is already banned for this blog.' => 'La IP que introdujo ya está bloqueada en este blog.',

## lib/MT/CMS/Blog.pm
	q{Cloning blog '[_1]'...} => q{Clonando un blog},
	'Error' => 'Error',
	'Finished!' => '¡Finalizó!',
	'General Settings' => 'Configuración general',
	'These setting(s) are overridden by a value in the Movable Type configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.' => 'Un valor en el fichero de configuración de MT tiene prioridad sobre esta configuración: [_1]. Elimine el valor del fichero de configuración para poder co ntrolarlo desde esta página.',
	'Plugin Settings' => 'Configuración de extensiones',
	'New Blog' => 'Nuevo blog',
	'Cannot load template #[_1].' => 'No se pudo cargar la plantilla #[_1].',
	'index template \'[_1]\'' => 'plantilla índice \'[_1]\'',
	'[_1] \'[_2]\'' => '[_1] \'[_2]\'',
	'Publish Site' => 'Publicar sitio',
	'Invalid blog' => 'Blog no válido',
	'Select Blog' => 'Seleccione blog',
	'Selected Blog' => 'Blog seleccionado',
	'Type a blog name to filter the choices below.' => 'Introduzca un nombre de blog para filtrar las opciones de abajo.',
	'Blog Name' => 'Nombre del blog',
	'The \'[_1]\' provided below is not writable by the web server. Change the directory ownership or permissions and try again.' => 'El servidor web no puede escribir en el \'[_1]\' indicado abajo. Modifique los permisos de acceso al directorio e inténtelo de nuevo.',
	'Blog Root' => 'Raíz del blog',
	'Website Root' => 'Raíz del sitio web',
	'Saving permissions failed: [_1]' => 'Fallo guardando permisos: [_1]',
	'[_1] changed from [_2] to [_3]' => '[_1] cambió de [_2] a [_3]',
	'Saved [_1] Changes' => 'Guardados los cambios de [_1]',
	'[_1] \'[_2]\' (ID:[_3]) created by \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) creado por \'[_4]\'',
	'You did not specify a blog name.' => 'No especificó el nombre del blog.',
	'Site URL must be an absolute URL.' => 'La URL del sitio debe ser una URL absoluta.',
	'Archive URL must be an absolute URL.' => 'La URL de archivo debe ser una URL absoluta.',
	'You did not specify an Archive Root.' => 'No ha especificado un Archivo raíz.',
	'The number of revisions to store must be a positive integer.' => 'El número de revisiones a guardar debe ser un número entero positivo.',
	'Please choose a preferred archive type.' => 'Por favor, seleccione el tipo de archivo preferido.',
	'Blog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) borrado por \'[_3]\'',
	'Saving blog failed: [_1]' => 'Fallo guardando blog: [_1]',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Error: Movable Type no puede escribir en el directorio de caché de las plantillas. Por favor, compruebe los permisos del directorio llamado <code>[_1]</code> dentro del directorio de su blog.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Error: Movable Type no pudo crear un directorio para cachear las plantillas dinámicas. Debe crear un directorio llamado <code>[_1]</code> dentro del directorio de su blog.',
	'No blog was selected to clone.' => 'Ningún blog ha sido seleccionado para ser clonado.',
	'This action can only be run on a single blog at a time.' => 'Esta acción solo se puede ejecutar en un solo blog a la vez.',
	'Invalid blog_id' => 'blog_id no válido',
	'This action cannot clone website.' => 'Esta acción no puede clonar un sitio web.',
	'Entries must be cloned if comments and trackbacks are cloned' => 'Las entradas tienen que clonarse su se clonan los comentarios y trackbacks',
	'Entries must be cloned if comments are cloned' => 'Las entradas deben clonarse si se clonan los comentarios',
	'Entries must be cloned if trackbacks are cloned' => 'Las entradas deben clonarse si se clonan los trackbacks',
	'\'[_1]\' (ID:[_2]) has been copied as \'[_3]\' (ID:[_4]) by \'[_5]\' (ID:[_6]).' => '\'[_1]\' (ID:[_2]) se ha copiado como \'[_3]\' (ID:[_4]) por \'[_5]\' (ID:[_6]).', # Translate - New

## lib/MT/CMS/Category.pm
	'The [_1] must be given a name!' => '¡Debe dar un nombre a [_1]!',
	'Failed to update [_1]: Some of [_2] were changed after you opened this page.' => 'Falló la actualización de [_1]: Se modificaron algunos [_2] después de que abriera la página.',
	'Tried to update [_1]([_2]), but the object was not found.' => 'Se intentó actualizar [_1]([_2]), pero el objeto no se encontró.',
	'[_1] order has been edited by \'[_2]\'.' => 'El orden de [_1] fue editado por \'[_2]\'.', # Translate - New
	'Your changes have been made (added [_1], edited [_2] and deleted [_3]). <a href="#" onclick="[_4]" class="mt-rebuild">Publish your site</a> to see these changes take effect.' => 'Se han realizado los cambios ([_1] añadido, [_2] editado y [_3] borrado). <a href="#" onclick="[_4]" class="mt-rebuild">Publique el sitio</a> para que los cambios tomen efecto.',
	'Add a [_1]' => 'Añador un [_1]',
	'No label' => 'Sin título',
	'The category name cannot be blank.' => 'El nombre de la categoría debe tener algún valor.',
	'Permission denied: [_1]' => 'Permiso denegado: [_1]',
	'The category name \'[_1]\' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Hay un conflicto entre el nombre de la categoría \'[_1]\' y otra categoría. Las categorías de nivel superior y las subcategorías con una misma raíz deben tener nombres diferentes.',
	'The category basename \'[_1]\' conflicts with the basename of another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => 'Hay un conflicto entre el nombre base de la categoría \'[_1]\' y el de otra categoría. Las categorías de nivel superior y las subcategorías con una misma raíz deben tener nombres diferentes.',
	'The name \'[_1]\' is too long!' => 'El nombre \'[_1]\' es demasiado largo.',
	'Category \'[_1]\' created by \'[_2]\'.' => 'La categoría \'[_1]\' fue creada por \'[_2]\'.', # Translate - New
	'Category \'[_1]\' (ID:[_2]) edited by \'[_3]\'' => 'La categoría \'[_1]\' (ID:[_2]) fue editada por \'[_3]\'', # Translate - New
	'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'La categoría \'[_1]\' (ID:[_2]) fue borrada por \'[_3]\'',
	'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'El nombre de la categría \'[_1]\' tiene conflicto con otra categoría. Las categorías de primer nivel y las sub-categorías con el mismo padre deben tener nombres únicos.',

## lib/MT/CMS/Comment.pm
	'Edit Comment' => 'Editar comentario',
	'(untitled)' => '(sin título)',
	'No such commenter [_1].' => 'No existe el comentarista [_1].',
	'User \'[_1]\' trusted commenter \'[_2]\'.' => 'Usuario \'[_1]\' confió en el comentarista \'[_2]\'.',
	'User \'[_1]\' banned commenter \'[_2]\'.' => 'Usuario \'[_1]\' bloqueó al comentarista \'[_2]\'.',
	'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'Usuario \'[_1]\' desbloqueó al comentarista \'[_2]\'.',
	'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'Usuario \'[_1]\' desconfió del comentarista \'[_2]\'.',
	'The parent comment id was not specified.' => 'No se especificó el identificador del comentario raíz.',
	'The parent comment was not found.' => 'No se encontró el comentario padre.',
	'You cannot reply to unapproved comment.' => 'No puede responder a un comentario no aprobado.',
	'You cannot create a comment for an unpublished entry.' => 'No puede crear un comentario en una entrada sin publicar.',
	'You cannot reply to unpublished comment.' => 'No puede contestar a comentarios no publicados.',
	'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Comentario (ID:[_1]) por \'[_2]\' borrado por \'[_3]\' de la entrada \'[_4]\'',
	'You do not have permission to approve this trackback.' => 'No tiene permiso para aprobar este trackback.',
	'The entry corresponding to this comment is missing.' => 'No se encuentra la entrada correspondiente a este comentario.',
	'You do not have permission to approve this comment.' => 'No tiene permisos para aprobar este comentario.',
	'Orphaned comment' => 'Comentario huérfano',

## lib/MT/CMS/Common.pm
	'Invalid type [_1]' => 'Tipo inválido [_1]',
	'The Template Name and Output File fields are required.' => 'Los campos del nombre de la plantilla y el fichero de salida son obligatorios.',
	'Invalid ID [_1]' => 'ID inválido [_1]',
	'The blog root directory must be within [_1].' => 'El directorio raíz del blog debe estar en [_1]',
	'The website root directory must be within [_1].' => 'El directorio raíz del sitio web debe estar en [_1]',
	'\'[_1]\' edited the template \'[_2]\' in the blog \'[_3]\'' => '\'[_1]\' editó la plantilla \'[_2]\' en el blog \'[_3]\'',
	'\'[_1]\' edited the global template \'[_2]\'' => '\'[_1]\' editó la plantilla global \'[_2]\'',
	'Load failed: [_1]' => 'Fallo carga: [_1]',
	'(no reason given)' => '(ninguna razón ofrecida)',
	'Error occurred during permission check: [_1]' => 'Ocurrió un error al comprobar los permisos: [_1]',
	'Invalid filter: [_1]' => 'Filtro no válido: [_1]',
	'New Filter' => 'Nuevo filtro',
	'__SELECT_FILTER_VERB' => 'es',
	'All [_1]' => 'Todos los/las [_1]',
	'[_1] Feed' => 'Sindicación de [_1]',
	'Unknown list type' => 'Tipo de lista desconocido',
	'Invalid filter terms: [_1]' => 'Términos de filtro no válidos: [_1]',
	'An error occurred while counting objects: [_1]' => 'Ocurrió un error durante el recuento de objetos: [_1]',
	'An error occurred while loading objects: [_1]' => 'Ocurrió un error durante la carga de objetos: [_1]',
	'Removing tag failed: [_1]' => 'Falló el borrado de la etiqueta: [_1]',
	'Removing [_1] failed: [_2]' => 'Falló el borrado de [_1]: [_2]',
	'System templates cannot be deleted.' => 'No se pueden eliminar las plantillas del sistema.',
	'The selected [_1] has been deleted from the database.' => 'El [_1] seleccionado fue borrado de la base de datos.',
	'Saving snapshot failed: [_1]' => 'Fallo al guardar instantánea: [_1]',

## lib/MT/CMS/Dashboard.pm
	'Error: This blog does not have a parent website.' => 'Error: Este blog no tiene un sitio web padre.',
	'Not configured' => 'Sin configurar',
	'Page Views' => 'Páginas vistas',

## lib/MT/CMS/Entry.pm
	'*User deleted*' => '*Usuario borrado*',
	'New Entry' => 'Nueva entrada',
	'New Page' => 'Nueva página',
	'Tag' => 'Etiqueta',
	'Entry Status' => 'Estado de la entrada',
	'Cannot load template.' => 'No se pudo cargar la plantilla.',
	'Publish error: [_1]' => 'Error de publicación: [_1]',
	'Unable to create preview files in this location: [_1]' => 'No fue posible crear los ficheros de previsualización en esta ruta: [_1]',
	'New [_1]' => 'Nueva [_1]',
	'No such [_1].' => 'No existe [_1].',
	'This basename has already been used. You should use an unique basename.' => 'Este nombre base está ya en uso. Debe indicar un nombre base único.',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Su blog no tiene configurados la URL y la raíz del sitio. No puede publicar entradas hasta que no estén definidos.',
	'Invalid date \'[_1]\'; \'Published on\' dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Fecha no válida \'[_1]\'. Las fechas de publicación debe tener el formato AAAA-MM-DD HH:MM:SS.',
	'Invalid date \'[_1]\'; \'Published on\' dates should be real dates.' => 'Fecha no válida \'[_1]\'. Las fechas de publicación debe ser fechas reales.',
	'Invalid date \'[_1]\'; \'Unpublished on\' dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Fecha no válida \'[_1]\'. Las fechas \'No publicado en\' deben tener el formato AAAA-MM-DD HH:MM:SS',
	'Invalid date \'[_1]\'; \'Unpublished on\' dates should be real dates.' => 'Fecha no válida \'[_1]\'. Las fechas \'No publicado en\' deben ser fechas reales.',
	'Invalid date \'[_1]\'; \'Unpublished on\' dates should be dates in the future.' => 'Fecha no válida \'[_1]\'. Las fechas \'No publicado en\' deben ser fechas futuras.',
	'Invalid date \'[_1]\'; \'Unpublished on\' dates should be later than the corresponding \'Published on\' date.' => 'Fecha no válida \'[_1]\'. Las fechas \'No publicado en\' deben ser posteriores a la fecha \'Publicado en\' correspondiente.',
	'Saving placement failed: [_1]' => 'Fallo guardando situación: [_1]',
	'Invalid date \'[_1]\'; [_2] dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Fecha no válida \'[_1]\'. Las fechas de [_2] deben tener el formato YYYY-MM-DD HH:MM:SS.',
	'Invalid date \'[_1]\'; [_2] dates should be real dates.' => 'Invalid date \'[_1]\'; [_2] dates should be real dates.',
	'Invalid date \'[_1]\'; \'Published on\' dates should be earlier than the corresponding \'Unpublished on\' date \'[_2]\'.' => 'Fecha no válida: \'[_1]\'. Las fechas de publicación debe ser anteriores a la fecha de despublicación \'[_2]\'.',
	'authored on' => 'creando en',
	'modified on' => 'modifcado en',
	'Saving entry \'[_1]\' failed: [_2]' => 'Fallo guardando entrada \'[_1]\': [_2]',
	'Removing placement failed: [_1]' => 'Fallo eliminando lugar: [_1]',
	'[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_1] \'[_2]\' (ID:[_3]) editado y cambió su estado desde [_4] a [_5] al usuario \'[_6]\'',
	'[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) editado por el usuario \'[_4]\'',
	'Ping \'[_1]\' failed: [_2]' => 'Falló ping \'[_1]\' : [_2]',
	'(user deleted - ID:[_1])' => '(usuario borrado - ID:[_1])',
	'<a href="[_1]">QuickPost to [_2]</a> - Drag this bookmarklet to your browser\'s toolbar, then click it when you are visiting a site that you want to blog about.' => '<a href="[_1]">QuickPost - [_2]</a> - Arrastre este marcador a la barra de su navegador. Haga clic en él cuando visite un sitio web sobre el que quiera bloguear.',
	'[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'',
	'[_1] \'[_2]\' (ID:[_3]) deleted by \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) borrada por \'[_4]\'',
	'Need a status to update entries' => 'Necesita indicar un estado para actualizar las entradas',
	'Need entries to update status' => 'Necesita entradas para actualizar su estado',
	'One of the entries ([_1]) did not exist' => 'Una de las entradas ([_1]) no existe.',
	'[_1] \'[_2]\' (ID:[_3]) status changed from [_4] to [_5]' => '[_1] \'[_2]\' (ID:[_3]) cambió de estado de [_4] a [_5]',

## lib/MT/CMS/Export.pm
	'Loading blog \'[_1]\' failed: [_2]' => 'Falló al cargar el blog \'[_1]\': [_2]',
	'You do not have export permissions' => 'No tiene permisos de exportación',

## lib/MT/CMS/Filter.pm
	'Failed to save filter: Label is required.' => 'Falló al guardar el filtro: la etiqueta es obligatoria.',
	'Failed to save filter:  Label "[_1]" is duplicated.' => 'Falló al guardar el filtro: La etiqueta "[_1]" está duplicada.',
	'No such filter' => 'No existe dicho filtro',
	'Permission denied' => 'Permiso denegado',
	'Failed to save filter: [_1]' => 'Falló al guardar el filtro: [_1]',
	'Failed to delete filter(s): [_1]' => 'Falló al borrar los filtros: [_1]',
	'Removed [_1] filters successfully.' => 'Se borraron con éxito los [_1] filtros.',
	'[_1] ( created by [_2] )' => '[_1] ( creado por [_2] )',
	'(Legacy) ' => '(Anticuado) ',

## lib/MT/CMS/Folder.pm
	'The folder \'[_1]\' conflicts with another folder. Folders with the same parent must have unique basenames.' => 'La carpeta \'[_1]\' tiene conflicto con otra carpeta. Las carpetas con el mismo padre deben tener nombre base únicos.',
	'Folder \'[_1]\' created by \'[_2]\'' => 'La carpeta \'[_1]\' fue creada por \'[_2]\'',
	'Folder \'[_1]\' (ID:[_2]) edited by \'[_3]\'' => 'La carpeta \'[_1]\' (ID:[_2]) fue editada por \'[_3]\'', # Translate - New
	'Folder \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'La carpeta \'[_1]\' (ID:[_2]) fue borrada por \'[_3]\'',

## lib/MT/CMS/Import.pm
	'Import/Export' => 'Importar/Exportar',
	'You do not have import permission' => 'No tiene permisos de importación',
	'You do not have permission to create users' => 'No tiene permisos para crear usuarios',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'Si va a crear nuevos usuarios por cada usuario listado en su blog, debe proveer una contraseña.',
	'Importer type [_1] was not found.' => 'No se encontró el tipo de importador [_1].',

## lib/MT/CMS/Log.pm
	'All Feedback' => 'Todas las opiniones',
	'Publishing' => 'Publicación',
	'System Activity Feed' => 'Sindicación de la actividad',
	'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'El registro de actividad del blog \'[_1]\' (ID:[_2]) fue reiniciado por  \'[_3]\'',
	'Activity log reset by \'[_1]\'' => 'Registro de actividad reiniciado por \'[_1]\'',

## lib/MT/CMS/Plugin.pm
	'Error saving plugin settings: [_1]' => 'Error guardando la configuración de las extensión: [_1]',
	'Plugin Set: [_1]' => 'Conjunto de extensiones: [_1]',
	'Individual Plugins' => 'Extensiones individuales',

## lib/MT/CMS/Search.pm
	'No [_1] were found that match the given criteria.' => 'Ningún [_1] ha sido encontrado que corresponda al criterio dado.',
	'Entry Body' => 'Cuerpo de la entrada',
	'Extended Entry' => 'Entrada extendida',
	'Keywords' => 'Palabras clave',
	'Comment Text' => 'Comentario',
	'IP Address' => 'Dirección IP',
	'Source URL' => 'URL origen',
	'Page Body' => 'Cuerpo de la página',
	'Extended Page' => 'Página extendida',
	'Template Name' => 'Nombre de la plantilla',
	'Text' => 'Texto',
	'Linked Filename' => 'Fichero enlazado',
	'Output Filename' => 'Fichero salida',
	'Log Message' => 'Mensaje del registro',
	'Site URL' => 'URL del sitio',
	'Search & Replace' => 'Buscar & Reemplazar',
	'Invalid date(s) specified for date range.' => 'Se especificaron fechas no válidas para el rango.',
	'Error in search expression: [_1]' => 'Error en la expresión de búsqueda: [_1]',
	'Searched for: \'[_1]\' Replaced with: \'[_2]\'' => 'Se buscó: \'[_1]\' Se reemplazó con: \'[_2]\'',
	'[_1] \'[_2]\' (ID:[_3]) updated by user \'[_4]\' using Search & Replace.' => '[_1] \'[_2]\' (Id:[_3]) actualizado por el usuario \'[_4]\' mediante Buscar y reemplazar.',

## lib/MT/CMS/Tag.pm
	'A new name for the tag must be specified.' => 'Debe especificar un nombre nuevo para la etiqueta.',
	'No such tag' => 'No existe dicha etiqueta',
	'The tag was successfully renamed' => 'Se renombró con éxito a la etiqueta.',
	'Error saving entry: [_1]' => 'Error guardando entrada: [_1]',
	'Successfully added [_1] tags for [_2] entries.' => 'Se añadió con éxito [_1] etiquetas en [_2] entradas.',
	'Error saving file: [_1]' => 'Error guardando fichero: [_1]',
	'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Etiqueta \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',

## lib/MT/CMS/Template.pm
	'index' => 'índice',
	'archive' => 'archivo',
	'module' => 'módulo',
	'widget' => 'widget',
	'email' => 'correo electrónico',
	'backup' => 'Copia de seguridad',
	'system' => 'sistema',
	'One or more errors were found in this template.' => 'Se encontraron uno o más errores en esta plantilla.',
	'Unknown blog' => 'Blog desconocido',
	'One or more errors were found in the included template module ([_1]).' => 'Se encontraron uno o más errrores en el módulo de plantilla incluído ([_1])',
	'Global Template' => 'Plantilla global',
	'Invalid Blog' => 'Blog no válido',
	'Global' => 'Global',
	'You must specify a template type when creating a template' => 'Debe especificar un tipo al crear una plantilla.',
	'Entry or Page' => 'Entrada o página',
	'New Template' => 'Nueva plantilla',
	'No Name' => 'Sin nombre',
	'Index Templates' => 'Plantillas índice',
	'Archive Templates' => 'Plantillas de archivos',
	'Template Modules' => 'Módulos de plantillas',
	'System Templates' => 'Plantillas del sistema',
	'Email Templates' => 'Plantillas de correo',
	'Template Backups' => 'Copias de seguridad de las plantillas',
	'Cannot locate host template to preview module/widget.' => 'No se localizó la plantilla origen para mostrar el módulo/widget.',
	'Cannot preview without a template map!' => '¡No se puede mostrar la vista previa sin un mapa de plantilla!',
	'Unable to create preview file in this location: [_1]' => 'Imposible crear vista previa del archivo en este lugar: [_1]',
	'Lorem ipsum' => 'Lorem ipsum',
	'LOREM_IPSUM_TEXT' => 'LOREM_IPSUM_TEXT',
	'LORE_IPSUM_TEXT_MORE' => 'LORE_IPSUM_TEXT_MORE',
	'sample, entry, preview' => 'sample, entry, preview',
	'Populating blog with default templates failed: [_1]' => 'Falló el guardando del blog con las plantillas por defecto: [_1]',
	'Setting up mappings failed: [_1]' => 'Fallo la configuración de mapeos: [_1]',
	'Cannot load templatemap' => 'No se pudo cargar el mapa de plantillas',
	'Saving map failed: [_1]' => 'Fallo guardando mapa: [_1]',
	'You should not be able to enter zero (0) as the time.' => 'No debería introducir cero (0) como hora.',
	'You must select at least one event checkbox.' => 'Debe seleccionar al menos una casilla de eventos.',
	'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Plantilla \'[_1]\' (ID:[_2]) creada por \'[_3]\'',
	'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Plantilla \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
	'Orphaned' => 'Huérfano',
	'Global Templates' => 'Plantillas globales',
	' (Backup from [_1])' => ' (Copia de [_1])',
	'Error creating new template: ' => 'Error creando nueva plantilla: ',
	'Template Referesh' => 'Refrescar plantilla',
	'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Ignorando plantilla \'[_1]\' ya que parecer ser una plantilla personalizada.',
	'Refreshing template <strong>[_3]</strong> after making <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>.' => 'Reactualizar los modelos <strong>[_3]</strong> desde <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">guardar</a>',
	'Skipping template \'[_1]\' since it has not been changed.' => 'Ignorando la plantilla \'[_1]\' ya que no ha sido modificada.',
	'Copy of [_1]' => 'Copia de [_1]',
	'Cannot publish a global template.' => 'No se pudo publicar una plantilla global.',
	'Widget Template' => 'Plantilla de widget',
	'Widget Templates' => 'Plantillas de widget',
	'template' => 'plantilla',

## lib/MT/CMS/Theme.pm
	'Theme not found' => 'Tema no encontrado',
	'Failed to uninstall theme' => 'Fallo al desinstalar el tema',
	'Failed to uninstall theme: [_1]' => 'Fallo al desinstalar el tema: [_1]',
	'Theme from [_1]' => 'Tema de [_1]',
	'Install into themes directory' => 'Instalar en el directorio de temas',
	'Download [_1] archive' => 'Descargar archivo de [_1]',
	'Failed to load theme export template for [_1]: [_2]' => 'Falló la carga de la plantilla de exportación de temas para [_1]: [_2]',
	'Failed to save theme export info: [_1]' => 'Fallo al guardar la información de exportación del tema: [_1]',
	'Themes directory [_1] is not writable.' => 'No se puede escribir en el directorio de los temas [_1].',
	'All themes directories are not writable.' => 'No se puede escribir en inguno de los directorios de los temas.',
	'Error occurred during exporting [_1]: [_2]' => 'Ocurrió un error durante la exportación de [_1]: [_2]',
	'Error occurred during finalizing [_1]: [_2]' => 'Ocurrió un error durante la finalización de [_1]: [_2]',
	'Error occurred while publishing theme: [_1]' => 'Ocurrió un error durante la publicación del tema: [_1]',
	'Themes Directory [_1] is not writable.' => 'No se puede escribir en el directorio de los temas [_1].',

## lib/MT/CMS/Tools.pm
	'Password Recovery' => 'Recuperación de contraseña',
	'Email address is required for password reset.' => 'La dirección de correo es necesaria para el reinicio de contraseña.',
	'Invalid email address' => 'Dirección de correo no válida',
	'Error sending e-mail ([_1]); Please fix the problem, then try again to recover your password.' => 'Error enviado un correo electrónico ([_1]). Por favor, solucione el problema y luego intente recuperar de nuevo la contraseña.',
	'Password reset token not found' => 'Token para el reinicio de la contraseña no encontrado',
	'Email address not found' => 'Dirección de correo no encontrada',
	'User not found' => 'Usuario no encontrado',
	'Your request to change your password has expired.' => 'Expiró su solicitud de cambio de contraseña.',
	'Invalid password reset request' => 'Solicitud de reinicio de contraseña no válida',
	'Please confirm your new password' => 'Por favor, confirme su nueva contraseña',
	'Passwords do not match' => 'Las contraseñas no coinciden',
	'That action ([_1]) is apparently not implemented!' => '¡La acción ([_1]) aparentemente no está implementada!',
	'Error occurred while attempting to [_1]: [_2]' => 'Ocurrió un error intentando [_1]: [_2]',
	'Please enter a valid email address.' => 'Por favor, teclee una dirección de correo válida.',
	'You do not have a system email address configured.  Please set this first, save it, then try the test email again.' => 'No ha configurado la dirección de correo del sistema. Por favor, configúrela, guárdela y luego intente de nuevo enviar el correo de prueba.',
	'Test email from Movable Type' => 'Correo de prueba de Movable Type',
	'This is the test email sent by Movable Type.' => 'Este es un mensaje de prueba enviado por Movable Type',
	'Test e-mail was successfully sent to [_1]' => 'El correo de prueba fue enviado con éxito a [_1]',
	'E-mail was not properly sent. [_1]' => 'El correo no se envió correctamente. [_1]',
	'Email address is [_1]' => 'La dirección de correo es [_1]',
	'Debug mode is [_1]' => 'El modo de depuración es [_1]',
	'Performance logging is on' => 'El histórico de rendimiento está activado',
	'Performance logging is off' => 'El histórico de rendimiento está desactivado',
	'Performance log path is [_1]' => 'La ruta del histórico de rendimiento es [_1]',
	'Performance log threshold is [_1]' => 'El umbral del histórico de rendimiento es [_1]',
	'Invalid SitePath.  The SitePath should be valid and absolute, not relative' => 'SitePath no válido. Debe tener un valor absoluto, no relativo.',
	'Prohibit comments is on' => 'La prohibición de comentarios está activada.',
	'Prohibit comments is off' => 'La prohibición de comentarios está desactivada.',
	'Prohibit trackbacks is on' => 'La prohibición de trackbacks está actividada.',
	'Prohibit trackbacks is off' => 'La prohibición de trackbacks está desactivada.',
	'Prohibit notification pings is on' => 'La prohibición de pings está activada.',
	'Prohibit notification pings is off' => 'La prohibición de pings está desactivada.',
	'Outbound trackback limit is [_1]' => 'El límite de trackbacks salientes es [_1]',
	'Any site' => 'Cualquier sitio',
	'Only to blogs within this system' => 'Solo a los blogs en este sistema',
	'[_1] is [_2]' => '[_1] es [_2]',
	'none' => 'ninguno',
	'Changing image quality is [_1]' => 'Cambiando la calidad de imagen es [_1]', # Translate - New
	'Image quality(JPEG) is [_1]' => 'La calidad de la imagen (JPEG) es [_1]',
	'Image quality(PNG) is [_1]' => 'La calidad de la imagen (PNG) es [_1]',
	'System Settings Changes Took Place' => 'Se realizaron los cambios en la configuración del sistema',
	'Invalid password recovery attempt; Cannot recover the password in this configuration' => 'Intento de recuperación de contraseña no válido. No se pudo recuperar la contraseña con esta configuración',
	'Invalid author_id' => 'author_id no válido',
	'Backup & Restore' => 'Copias de seguridad',
	'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.' => 'Debe poderse escribir en el directorio temporal para que las copias de seguridad funcionen correctamente. Por favor, compruebe la opción de configuración TempDir.',
	'Temporary directory needs to be writable for restore to work correctly.  Please check TempDir configuration directive.' => 'Debe poder escribirse en el directorio temporal para que las copias de seguridad funcionen correctamente. Por favor, compruebe la opción de configuración TempDir.',
	'[_1] is not a number.' => '[_1] no es un número.',
	'Copying file [_1] to [_2] failed: [_3]' => 'Fallo copiandi fichero [_1] en [_2]: [_3]',
	'Specified file was not found.' => 'No se encontró el fichero especificado.',
	'[_1] successfully downloaded backup file ([_2])' => '[_1] descargó con éxito el fichero de copia de seguridad ([_2])',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ',
	'Some of the actual files for assets could not be restored.' => 'No se pudieron restaurar algunos ficheros multimedia.',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Por favor, use xml, tar.gz, zip, o manifest como extensión de ficheros.',
	'Unknown file format' => 'Formato de fichero desconocido',
	'Some objects were not restored because their parent objects were not restored.' => 'Algunos objetos no se restauraron porque sus objetos ascendentes tampoco fueron restaurados.',
	'Detailed information is in the activity log.' => 'La información detallada se encuentra en el registro de actividad.',
	'[_1] has canceled the multiple files restore operation prematurely.' => '[_1] canceló prematuramente la operación de restauración de varios ficheros.',
	'Changing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Modificando la Ruta del Sitio del blog \'[_1]\' (ID:[_2])...',
	'Removing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Borrando la Ruta del Sitio del blog \'[_1]\' (ID:[_2])...',
	'Changing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Modificando la Ruta de Archivos del blog \'[_1]\' (ID:[_2])...',
	'Removing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Borrando la Ruta de Archivos del blog \'[_1]\' (ID:[_2])...',
	'Changing file path for FileInfo record (ID:[_1])...' => 'Modificando la ruta del fichero para el registro FileInfo (Id:[_1])...',
	'Changing URL for FileInfo record (ID:[_1])...' => 'Modificando la URL para el registro FileInfo (Id:[_1])...',
	'Changing file path for the asset \'[_1]\' (ID:[_2])...' => 'Modificando la ruta para el fichero multimedia \'[_1]\' (ID:[_2])...',
	'Could not remove backup file [_1] from the filesystem: [_2]' => 'No se pudo eliminar el fichero de copia de seguridad [_1] del sistema: [_2]',
	'Some of the backup files could not be removed.' => 'No se pudieron eliminar algunos ficheros de copia de seguridad.',
	'Please upload [_1] in this page.' => 'Por favor, transfiera [_1] a esta página.',
	'File was not uploaded.' => 'El fichero no fue transferido.',
	'Restoring a file failed: ' => 'Falló la restauración de un fichero:',
	'Some of the files were not restored correctly.' => 'No se restauraron correctamente algunos de los ficheros.',
	'Successfully restored objects to Movable Type system by user \'[_1]\'' => 'El usuario \'[_1]\' restauró objetos en el sistema Movable Type con éxito.',
	'Invalid password recovery attempt; cannot recover password in this configuration' => 'Intento de recuperación de contraseña no válido; no se pudo recuperar la clave con esta configuración',
	'Cannot recover password in this configuration' => 'No se pudo recuperar la clave con esta configuración',
	'Invalid user name \'[_1]\' in password recovery attempt' => 'Nombre de usuario no válido \'[_1]\' en intento de recuperación de contraseña',
	'User name or password hint is incorrect.' => 'El nombre del usuario o la contraseña es incorrecto.',
	'User has not set pasword hint; Cannot recover password' => 'El usuario no ha configurado una pista para la contraseña; no se pudo recuperar',
	'Invalid attempt to recover password (used hint \'[_1]\')' => 'Intento inválido de recuperación de la contraseña (pista usada \'[_1]\')',
	'User \'[_1]\' (user #[_2]) does not have email address' => 'El usuario \'[_1]\' (usuario #[_2]) no tiene dirección de correo',
	'A password reset link has been sent to [_3] for user  \'[_1]\' (user #[_2]).' => 'Se ha envíado el enlace del reinicio de la contraseña para el usuario \'[_1]\' a [_3] (usuario #[_2]).',
	'Some objects were not restored because their parent objects were not restored.  Detailed information is in the activity log.' => 'Algunos objetos no se restauraron porque sus objetos padres no se restauraron. Dispone de información detallada en el registro de actividad.',
	'[_1] is not a directory.' => '[_1] no es un directorio.',
	'Error occurred during restore process.' => 'Ocurrió un error durante el proceso de restauración.',
	'Some of files could not be restored.' => 'Algunos ficheros no se restauraron.',
	'Uploaded file was not a valid Movable Type backup manifest file.' => 'El fichero transferido no era un fichero no válido de manifiesto de copia de seguridad de Movable Type.',
	'Manifest file \'[_1]\' is too large. Please use import direcotry for restore.' => 'El fichero de manifesto \'[_1]\' es demasiado grande. Por favor, utilice el directorio de importación para la restauración.',
	'Blog(s) (ID:[_1]) was/were successfully backed up by user \'[_2]\'' => 'Las copias de seguridad de el/los blog(s) (ID:[_1]) se hizo/hicieron correctamente por el usuario  \'[_2]\'',
	'Movable Type system was successfully backed up by user \'[_1]\'' => 'El usuario \'[_1]\' realizó con éxito una copia de seguridad del sistema de Movable Type',
	'Some [_1] were not restored because their parent objects were not restored.' => 'Algunos [_1] no se restauraron porque sus objetos ascendentes no se restauraron.',
	'Recipients for lockout notification' => 'Destinatarios de las notificaciones de bloqueos',
	'User lockout limit' => 'Límite de bloqueo de usuarios',
	'User lockout interval' => 'Intervalo de bloqueo de usuarios',
	'IP address lockout limit' => 'Límite de bloqueo de direcciones IP',
	'IP address lockout interval' => 'Intervalo de bloqueo de direcciones IP',
	'Lockout IP address whitelist' => 'Lista blanca de bloqueo de direcciones IP',

## lib/MT/CMS/TrackBack.pm
	'(Unlabeled category)' => '(Categoría sin título)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) desde \'[_2]\' borrado por \'[_3]\' de la categoría \'[_4]\'',
	'(Untitled entry)' => '(Entrada sin título)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) desde \'[_2]\' borrado por \'[_3]\' de la entrada \'[_4]\'',
	'No Excerpt' => 'Sin resumen',
	'No Title' => 'Sin título',
	'Orphaned TrackBack' => 'TrackBack huérfano',
	'category' => 'categoría',

## lib/MT/CMS/User.pm
	'Create User' => 'Crear usuario',
	'Cannot load role #[_1].' => 'No se pudo cargar el rol #[_1].',
	'Role name cannot be blank.' => 'El nombre del rol no puede estar vacío.',
	'Another role already exists by that name.' => 'Ya existe otro rol con ese nombre.',
	'You cannot define a role without permissions.' => 'No puede definir un rol sin permisos.',
	'Invalid type' => 'Tipo no válido',
	'User \'[_1]\' (ID:[_2]) could not be re-enabled by \'[_3]\'' => 'No se pudo rehabilitar al usuario \'[_1]\' (ID:[_2]) por \'[_3]\'',
	'Invalid ID given for personal blog theme.' => 'ID inválido para un tema de blog personal.',
	'Invalid ID given for personal blog clone location ID.' => 'ID inválido para el ID de localización de clonación de blog personal.',
	'Minimum password length must be an integer and greater than zero.' => 'La contraseña debe tener al menos un carácter.',
	'If personal blog is set, the personal blog location are required.' => 'Si el blog personal está establecido, se necesita la localización del blog personal.',
	'Select a entry author' => 'Seleccione un autor de entradas',
	'Select a page author' => 'Seleccione un autor de páginas',
	'Selected author' => 'Autor seleccionado',
	'Type a username to filter the choices below.' => 'Introduzca un nombre de usuario para filtrar las opciones.',
	'Select a System Administrator' => 'Seleccione un Administrador del Sistema',
	'Selected System Administrator' => 'Administrador del Sistema seleccionado',
	'System Administrator' => 'Administrador del sistema',
	'(newly created user)' => '(nuevo usuario creado)',
	'Select Website' => 'Seleccion sitio web',
	'Website Name' => 'Nombre del sitio web',
	'Websites Selected' => 'Sitios web seleccionados',
	'Select Blogs' => 'Seleccione blogs',
	'Blogs Selected' => 'Blogs seleccionado',
	'Select Users' => 'Seleccionar usuarios',
	'Users Selected' => 'Usuarios seleccionados',
	'Select Roles' => 'Seleccionar roles',
	'Roles Selected' => 'Roles seleccionados',
	'Grant Permissions' => 'Otorgar permisos',
	'You cannot delete your own association.' => 'No puede borrar sus propias asociaciones.',
	'[_1]\'s Associations' => 'Asociaciones de [_1]',
	'You cannot delete your own user record.' => 'No puede borrar el registro de su propio usuario.',
	'You have no permission to delete the user [_1].' => 'No tiene permisos para borrar el usuario [_1].',
	'User requires username' => 'El usuario necesita un nombre de usuario',
	'User requires display name' => 'El usuario necesita un nombre público',
	'User requires password' => 'El usuario necesita una contraseña',
	'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Usuario \'[_1]\' (ID:[_2]) creado por \'[_3]\'',
	'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Usuario \'[_1]\' (ID:[_2]) borrado por \'[_3]\'',
	'represents a user who will be created afterwards' => 'representa un usuario que se creará después',

## lib/MT/CMS/Website.pm
	'New Website' => 'Nuevo sitio web',
	'Website \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Sitio web \'[_1]\' (ID:[_2]) borrado por \'[_3]\'',
	'Selected Website' => 'Sitio web seleccionado',
	'Type a website name to filter the choices below.' => 'Teclee el nombre de un sitio web para filtrar las opciones de abajo.',
	'Cannot load website #[_1].' => 'No se pudo cargar el sitio web #[_1].',
	'Blog \'[_1]\' (ID:[_2]) moved from \'[_3]\' to \'[_4]\' by \'[_5]\'' => 'Blog \'[_1]\' (ID:[_2]) trasladado de \'[_3]\' a \'[_4]\' por \'[_5]\'',

## lib/MT/Comment.pm
	'Comment' => 'Comentario',
	'Search for other comments from anonymous commenters' => 'Buscar otros comentarios anónimos',
	'__ANONYMOUS_COMMENTER' => 'Anónimo',
	'Search for other comments from this deleted commenter' => 'Buscar otros comentarios de este comentarista eliminado',
	'(Deleted)' => '(Borrado)',
	'Edit this [_1] commenter.' => 'Editar este comentarista [_1].',
	'Comments on [_1]: [_2]' => 'Comentarios en [_1]: [_2]',
	'Approved' => 'Autorizado',
	'Unapproved' => 'No aprobado',
	'Not spam' => 'No es spam',
	'Reported as spam' => 'Marcado como spam',
	'All comments by [_1] \'[_2]\'' => 'Todos los comentarios de [_1] \'[_2]\'',
	'Commenter' => 'Comentarista',
	'Loading entry \'[_1]\' failed: [_2]' => 'Falló al cargar la entrada \'[_1]\': [_2]',
	'Entry/Page' => 'Entrada/Página',
	'Comments on My Entries/Pages' => 'Comentarios en mis entradas/páginas',
	'Commenter Status' => 'Estado comentarista',
	'Comments in This Website' => 'Comentarios en este sitio',
	'Non-spam comments' => 'Comentarios que no son spam',
	'Non-spam comments on this website' => 'Comentarios no spam en este sitio web',
	'Pending comments' => 'Comentarios pendientes',
	'Published comments' => 'Comentarios publicados',
	'Comments on my entries/pages' => 'Comentarios en mis entradas/páginas',
	'Comments in the last 7 days' => 'Comentarios en los últimos 7 días',
	'Spam comments' => 'Comentarios spam',

## lib/MT/Compat/v3.pm
	'uses: [_1], should use: [_2]' => 'usa: [_1], debería usar: [_2]',
	'uses [_1]' => 'usa [_1]',
	'No executable code' => 'No es código ejecutable',
	'Publish-option name must not contain special characters' => 'El nombre de la opción de publicar no debe contener caracteres especiales',

## lib/MT/Component.pm
	'Loading template \'[_1]\' failed: [_2]' => 'Fallo cargando plantilla \'[_1]\': [_2]',

## lib/MT/ConfigMgr.pm
	'Alias for [_1] is looping in the configuration.' => 'Alias de [_1] está generando un bucle en la configuración.',
	'Error opening file \'[_1]\': [_2]' => 'Error abriendo el fichero \'[_1]\': [_2]',
	'Config directive [_1] without value at [_2] line [_3]' => 'Directiva de configuración [_1] sin valor en [_2] línea [_3]',
	'No such config variable \'[_1]\'' => 'No existe tal variable de configuración \'[_1]\'',

## lib/MT/Config.pm
	'Configuration' => 'Configuración',

## lib/MT/Core.pm
	'This is often \'localhost\'.' => 'Generalmente esto es \'localhost\'.',
	'The physical file path for your SQLite database. ' => 'La ruta física del fichero de la base de datos SQLite.',
	'[_1] in [_2]: [_3]' => '[_1] en [_2]: [_3]',
	'option is required' => 'opción es obligatoria',
	'Days must be a number.' => 'Los días deben ser un número.',
	'Invalid date.' => 'Fecha no válida.',
	'[_1] [_2] between [_3] and [_4]' => '[_1] [_2] entre [_3] y [_4]',
	'[_1] [_2] since [_3]' => '[_1] [_2] desde [_3]',
	'[_1] [_2] or before [_3]' => '[_1] [_2] o antes de [_3]',
	'[_1] [_2] these [_3] days' => '[_1] [_2] estos [_3] días',
	'[_1] [_2] future' => '[_1] [_2] futuro',
	'[_1] [_2] past' => '[_1] [_2] pasado',
	'<mt:var name="[_1]"> [_2] [_3] [_4]' => '<mt:var name="[_1]"> [_2] [_3] [_4]',
	'[_1] [_3] [_2]' => '[_1] [_3] [_2]',
	'No Label' => 'Sin etiqueta',
	'(system)' => '(sistema)',
	'My [_1]' => 'Mis [_1]',
	'[_1] of this Website' => '[_1] de este sitio web',
	'IP Banlist is disabled by system configuration.' => 'La lista de bloqueos por IP está desactivada por la configuración del sistema.',
	'Address Book is disabled by system configuration.' => 'La agenda está desactivada por la configuración del sistema.',
	'Error creating performance logs directory, [_1]. Please either change the permissions to make it writable or specify an alternate using the PerformanceLoggingPath configuration directive. [_2]' => 'Error al crear el directorio de los registros de rendimiento, [_1]. Por favor, cambie los permisos para que se pueda escribir en él o especifique un directorio alternativo utilizando la directiva de configuración PerformanceLoggingPath. [_2]',
	'Error creating performance logs: PerformanceLoggingPath setting must be a directory path, not a file. [_1]' => 'Error al crear los registros de rendimiento: la directiva PerformanceLoggingPath debe ser un directorio, no un fichero. [_1]',
	'Error creating performance logs: PerformanceLoggingPath directory exists but is not writeable. [_1]' => 'Error al crear los registros de rendimiento: El directorio PerformanceLoggingPath existe pero no se puede escribir en él. [_1]',
	'MySQL Database (Recommended)' => 'Base de datos MySQL (recomendada)',
	'PostgreSQL Database' => 'Base de datos PostgreSQL',
	'SQLite Database' => 'Base de datos SQLite',
	'SQLite Database (v2)' => 'Base de datos SQLite (v2)',
	'Database Server' => 'Servidor de base de datos',
	'Database Name' => 'Nombre de la base de datos',
	'Password' => 'Contraseña',
	'Database Path' => 'Ruta de la base de datos',
	'Database Port' => 'Puerto de la base de datos',
	'Database Socket' => 'Socket de la base de datos',
	'ID' => 'ID',
	'Date Created' => 'Fecha de creación',
	'Date Modified' => 'Fecha de modificación',
	'Author Name' => 'Nombre autor',
	'Legacy Quick Filter' => 'Filtro rápido antiguo',
	'My Items' => 'Mis elementos',
	'Log' => 'Histórico',
	'Activity Feed' => 'Sindicación de la actividad',
	'Folder' => 'Carpeta',
	'Trackback' => 'TrackBack',
	'Manage Commenters' => 'Administrar comentaristas',
	'Member' => 'Miembro',
	'Permission' => 'permiso',
	'IP addresses' => 'Dirección IP',
	'IP Banning Settings' => 'Bloqueo de IPs',
	'Contact' => 'Contacto',
	'Manage Address Book' => 'Administración del libro de Direcciones',
	'Filter' => 'Filtro',
	'Convert Line Breaks' => 'Convertir saltos de línea',
	'Rich Text' => 'Texto con formato',
	'Movable Type Default' => 'Predefinido de Movable Type',
	'weblogs.com' => 'weblogs.com',
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
	'Unpublish Past Entries' => 'Despublicar entradas anteriores',
	'Add Summary Watcher to queue' => 'Añade un inspector de totales a la cola',
	'Junk Folder Expiration' => 'Caducidad de la carpeta basura',
	'Remove Temporary Files' => 'Borrar ficheros temporales',
	'Purge Stale Session Records' => 'Eliminar registros de sesión caducados',
	'Purge Stale DataAPI Session Records' => 'Eliminar registros de sesión DataAPI caducados',
	'Remove expired lockout data' => 'Eliminar datos cacudados de bloqueos',
	'Purge Unused FileInfo Records' => 'Purgar registros FileInfo no utilizados',
	'Remove Compiled Template Files' => 'Borrar ficheros de plantillas compiladas', # Translate - New
	'Manage Website' => 'Administrar sitio web',
	'Manage Blog' => 'Administrar blog',
	'Manage Website with Blogs' => 'Administrar sitio web con blogs',
	'Post Comments' => 'Comentarios',
	'Create Entries' => 'Crear entradas',
	'Edit All Entries' => 'Editar todas las entradas',
	'Manage Assets' => 'Administrar multimedia',
	'Manage Categories' => 'Administrar categorías',
	'Change Settings' => 'Modificar configuración',
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

## lib/MT/DataAPI/Callback/Blog.pm
	'A parameter "[_1]" is required.' => 'Se requiere un parámetro "[_1]".',
	'The website root directory must be an absolute path: [_1]' => 'El directorio raíz del sitio web debe ser una ruta absoluta: [_1]',
	'Invalid theme_id: [_1]' => 'theme_id no válido: [_1]',
	'Cannot apply website theme to blog: [_1]' => 'No pudo ponerse el diseño al blog: [_1]',

## lib/MT/DataAPI/Callback/Category.pm
	'The label \'[_1]\' is too long.' => 'La etiqueta \'[_1]\' es demasiado larga.',
	'Parent [_1] (ID:[_2]) not found.' => 'No se encontró el padre de [_1] (Id:[_2]).',

## lib/MT/DataAPI/Callback/Entry.pm

## lib/MT/DataAPI/Callback/Log.pm
	'A paramter "[_1]" is required.' => 'Se requiere un parámetro "[_1]".',
	'author_id (ID:[_1]) is invalid.' => 'author_id (Id:[_1]) no válido.',
	'Log (ID:[_1]) deleted by \'[_2]\'' => 'Histórico (Id:[_1]) borrado por \'[_2]\'',

## lib/MT/DataAPI/Callback/Role.pm

## lib/MT/DataAPI/Callback/Tag.pm
	'Invalid tag name: [_1]' => 'Nombre de etiqueta no válido: [_1]',

## lib/MT/DataAPI/Callback/TemplateMap.pm
	'Invalid archive type: [_1]' => 'Tipo de archivo no válido: [_1]',

## lib/MT/DataAPI/Callback/Template.pm

## lib/MT/DataAPI/Callback/User.pm
	'Invalid language: [_1]' => 'Idioma no válido: [_1]',
	'Invalid dateFormat: [_1]' => 'Formato de fecha no válido: [_1]',
	'Invalid textFormat: [_1]' => 'Formato de texto no válido: [_1]',

## lib/MT/DataAPI/Callback/Widget.pm

## lib/MT/DataAPI/Callback/WidgetSet.pm

## lib/MT/DataAPI/Endpoint/Auth.pm

## lib/MT/DataAPI/Endpoint/Comment.pm

## lib/MT/DataAPI/Endpoint/Common.pm
	'Invalid dateFrom parameter: [_1]' => 'Parámetro de dateFrom no válido: [_1]',
	'Invalid dateTo parameter: [_1]' => 'Parámetro de dateTo no válido: [_1]',

## lib/MT/DataAPI/Endpoint/Entry.pm

## lib/MT/DataAPI/Endpoint/v2/Asset.pm
	'The asset does not support generating a thumbnail file.' => 'El fichero multimedia no soporta la generación de vista previa.',
	'Invalid width: [_1]' => 'Ancho no válido: [_1]',
	'Invalid height: [_1]' => 'Alto no válido: [_1]',
	'Invalid scale: [_1]' => 'Escala no válida: [_1]',

## lib/MT/DataAPI/Endpoint/v2/BackupRestore.pm
	'An error occurred during the backup process: [_1]' => 'Ocurrió un error durante la copia de seguridad: [_1]',
	'Invalid backup_what: [_1]' => 'backup_what no válido: [_1]',
	'Invalid backup_archive_format: [_1]' => 'backup_archive_format no válido: [_1]',
	'Invalid limit_size: [_1]' => 'limit_size no válido: [_1]',
	'An error occurred during the restore process: [_1] Please check activity log for more details.' => 'Ocurrió un error durante el proceso de restauración: [_1] Por favor, compruebe el registro de actividad para más detalles.',
	'Make sure that you remove the files that you restored from the \'import\' folder, so that if/when you run the restore process again, those files will not be re-restored.' => 'Asegúrese de que elimina los ficheros que ha restaurado de la carpeta \'importar\', por si ejecuta el proceso en otra ocasión que éstos no vuelvan a restaurar.',

## lib/MT/DataAPI/Endpoint/v2/Blog.pm
	'Cannot create a blog under blog (ID:[_1]).' => 'No se pudo crear un blog bajo el blog (Id:[_1]).',
	'Either parameter of "url" or "subdomain" is required.' => 'Se requiere el parámetro "url" o "subdominio".',
	'Site not found' => 'Sitio no encontrado',
	'Website "[_1]" (ID:[_2]) was not deleted. You need to delete the blogs under the website first.' => 'No se borró el sitio web "[_1]" (Id:[_2]). Primero debe eliminar los blogs pertenecientes al sitio web.',

## lib/MT/DataAPI/Endpoint/v2/Category.pm

## lib/MT/DataAPI/Endpoint/v2/Entry.pm
	'You need to provide a parameter "password" if you are going to create new users for each user listed in your blog.' => 'Debe indicar un parámetro "password" si va a crear nuevos usuarios para cada usuario listado en el blog.',
	'Invalid import_type: [_1]' => 'import_type no válido: [_1]',
	'Invalid encoding: [_1]' => 'Codificación no válida: [_1]',
	'Invalid convert_breaks: [_1]' => 'convert_breaks no válido: [_1]',
	'Invalid default_cat_id: [_1]' => 'default_cat_id no válido: [_1]',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Ocurrió un error durante el proceso de importación: [_1]. Por favor, compruebe su fichero de importación.',
	'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Asegúrese de borrar los ficheros importados del directorio \'import\', para evitar procesarlos de nuevo al ejecutar en otra ocasión el proceso de importación.',
	'A resource "[_1_]" is required.' => 'Se necesita un recurso "[_1_]"',
	'Could not found archive template for [_1].' => 'No se pudo encontrar la plantilla de archivos para [_1].',
	'Preview data not found.' => 'Datos de previsualización no encontrados.',

## lib/MT/DataAPI/Endpoint/v2/Folder.pm

## lib/MT/DataAPI/Endpoint/v2/Log.pm
	'Log message' => 'Mensaje del registro',

## lib/MT/DataAPI/Endpoint/v2/Page.pm
	'\'folder\' parameter is invalid.' => 'El parámetro \'folder\' no es válido.',

## lib/MT/DataAPI/Endpoint/v2/Permission.pm
	'Granting permission failed: [_1]' => 'Falló la concesión de permisos: [_1]',
	'Role not found' => 'Rol no encontrado',
	'Revoking permission failed: [_1]' => 'Falló la revocación de permisos: [_1]',

## lib/MT/DataAPI/Endpoint/v2/Plugin.pm
	'Plugin not found' => 'Extensión no encontrada',

## lib/MT/DataAPI/Endpoint/v2/Role.pm

## lib/MT/DataAPI/Endpoint/v2/Search.pm

## lib/MT/DataAPI/Endpoint/v2/Tag.pm
	'Cannot delete private tag associated with objects in system scope.' => 'No se puede eliminar la etiqueta privada asociada a los objetos del sistema.',
	'Cannot delete private tag in system scope.' => 'No se puede eliminar la etiqueta privada en el ámbito del sistema',
	'Tag not found' => 'Etiqueta no encontrada',

## lib/MT/DataAPI/Endpoint/v2/TemplateMap.pm
	'Template "[_1]" is not an archive template.' => 'La plantilla "[_1]" no es un fichero de plantillas.',

## lib/MT/DataAPI/Endpoint/v2/Template.pm
	'Template not found' => 'Plantilla no encontrada',
	'Cannot delete [_1] template.' => 'No se pudo borrar la plantilla [_1].',
	'Cannot publish [_1] template.' => 'No se pudo borrar la plantilla [_1].',
	'A parameter "refresh_type" is invalid: [_1]' => 'Un parámetro "refresh_type" no es válido: [_1]',
	'Cannot clone [_1] template.' => 'No se pudo clonar la plantilla [_1].',
	'A resource "template" is required.' => 'Se necesita una "plantilla" de recursos.',

## lib/MT/DataAPI/Endpoint/v2/Theme.pm
	'Cannot apply website theme to blog.' => 'No se puede utilizar un diseño de sitios web en un blog.',
	'Changing site theme failed: [_1]' => 'Falló el cambio de diseño: [_1]',
	'Applying theme failed: [_1]' => 'Falló al cambiar el diseño: [_1]',
	'Cannot uninstall this theme.' => 'No se pudo desinstalar este diseño.',
	'Cannot uninstall theme because the theme is in use.' => 'No se pudo desinstalar este diseño porque está en uso.',
	'theme_id may only contain letters, numbers, and the dash or underscore character. The theme_id must begin with a letter.' => 'theme_id solo puede contener letras, números, guión o subrayado. El theme_id debe comenzar con una letra.',
	'theme_version may only contain letters, numbers, and the dash or underscore character.' => 'theme_version solo puede contener letras, números, guión o subrayado.',
	'Cannot install new theme with existing (and protected) theme\'s basename: [_1]' => 'No se pudo instalar el nuevo diseño con el nombre base ya existente (y protegido): [_1]',
	'Export theme folder already exists \'[_1]\'. You can overwrite an existing theme with \'overwrite_yes=1\' parameter, or change the Basename.' => 'El directorio de exportación ya existe \'[_1]\'. Puede sobreescribir un diseño existente con el parámetro \'overwrite_yes=1\', o modificando el nombre base.',
	'Unknown archiver type : $arctype' => 'Tipo de archivador desconocido : $arctype',

## lib/MT/DataAPI/Endpoint/v2/User.pm
	'The email address provided is not unique. Please enter your username by "name" parameter.' => 'La dirección de correo indicada no es única. Por favor, introduzca su nombre de usuario con el parámetro "name".',
	'An email with a link to reset your password has been sent to your email address ([_1]).' => 'Se ha enviado a su dirección de correo ([_1]) un correo con el enlace para reiniciar la contraseña',

## lib/MT/DataAPI/Endpoint/v2/Widget.pm
	'Widget not found' => 'Widget no encontrado.',
	'Removing Widget failed: [_1]' => 'Falló el borrado del widget: [_1]',
	'Widgetset not found' => 'Conjunto de widgets no encontrado',

## lib/MT/DataAPI/Endpoint/v2/WidgetSet.pm
	'A resource "widgetset" is required.' => 'Se necesita un recurso "widgetset".',
	'Removing Widgetset failed: [_1]' => 'Fallo al eliminar el conjunto de widgets: [_1]',

## lib/MT/DataAPI/Endpoint/v3/Asset.pm

## lib/MT/DataAPI/Endpoint/v3/Auth.pm

## lib/MT/DataAPI/Resource.pm
	'Cannot parse "[_1]" as an ISO 8601 datetime' => 'No se pudo interpretar "[_1]" como fecha en formato ISO 8601',

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
	'Comment Response' => 'Comentar respuesta',
	'Displays error, pending or confirmation message for comments.' => 'Muestra mensajes de error o mensajes de pendiente y confirmación en los comentarios.',
	'Comment Preview' => 'Vista previa de comentario',
	'Displays preview of comment.' => 'Muestra una previsualización del comentario.',
	'Dynamic Error' => 'Error dinámico',
	'Displays errors for dynamically-published templates.' => 'Mostrar errores de las plantillas publicadas dinámicamente.',
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
	'Comment throttle' => 'Aluvión de comentarios',
	'Commenter Confirm' => 'Confirmación de comentarista',
	'Commenter Notify' => 'Notificación de comentaristas',
	'New Comment' => 'Nuevo comentario',
	'New Ping' => 'Nuevo ping',
	'Entry Notify' => 'Notificación de entradas',
	'User Lockout' => 'Bloqueo de usuarios',
	'IP Address Lockout' => 'Bloqueo de direcciones IP',

## lib/MT/Entry.pm
	'View [_1]' => 'Ver [_1]',
	'[_1] ( id:[_2] ) does not exists.' => '[_1] ( id:[_2] ) no existe.',
	'Entries from category: [_1]' => 'Entradas en la categoría: [_1]',
	'NONE' => 'ninguno',
	'Draft' => 'Borrador',
	'Published' => 'Publicado',
	'Reviewing' => 'En revisión',
	'Scheduled' => 'Programado',
	'Junk' => 'Basura',
	'Unpublished (End)' => 'Despublicar (fin)',
	'Entries by [_1]' => 'Entradas de [_1]',
	'record does not exist.' => 'registro no existe.',
	'Invalid arguments. They all need to be saved MT::Category objects.' => 'Argumentos no válidos. Todos deben ser objetos MT::Category guardados.',
	'Invalid arguments. They all need to be saved MT::Asset objects.' => 'Argumentos no válidos. Todos deben ser objetos MT::Asset guardados.',
	'Review' => 'Revisar',
	'Future' => 'Futuro',
	'Spam' => 'Spam',
	'Accept Comments' => 'Aceptar comentarios',
	'Body' => 'Cuerpo',
	'Extended' => 'Extendido',
	'Format' => 'Formato',
	'Accept Trackbacks' => 'Aceptar TrackBacks',
	'Publish Date' => 'Fecha de publicación',
	'Unpublish Date' => 'Fecha de despublicación',
	'Link' => 'Un vínculo',
	'Primary Category' => 'Categoría principal',
	'-' => '-',
	'__PING_COUNT' => 'Trackbacks',
	'Date Commented' => 'Fecha comentario',
	'Author ID' => 'ID Autor',
	'My Entries' => 'Mis entradas',
	'Entries in This Website' => 'Entradas en este sitio',
	'Published Entries' => 'Entradas publicadas',
	'Draft Entries' => 'Borradores de entradas',
	'Unpublished Entries' => 'Entradas no publicadas',
	'Scheduled Entries' => 'Entradas programadas',
	'Entries with Comments Within the Last 7 Days' => 'Entradas con comentarios en los últimos 7 días',

## lib/MT/FileMgr/DAV.pm
	'DAV connection failed: [_1]' => 'Falló la conexión DAV: [_1]',
	'DAV open failed: [_1]' => 'Falló la orden \'open\' en el DAV: [_1]',
	'DAV get failed: [_1]' => 'Falló la orden \'get\' en el DAV: [_1]',
	'DAV put failed: [_1]' => 'Falló la orden \'put\' en el DAV: [_1]',
	'Deleting \'[_1]\' failed: [_2]' => 'Fallo borrando \'[_1]\': [_2]',
	'Creating path \'[_1]\' failed: [_2]' => 'Fallo creando la ruta \'[_1]\': [_2]',
	'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Fallo renombrando \'[_1]\' a \'[_2]\': [_3]',

## lib/MT/FileMgr/FTP.pm

## lib/MT/FileMgr/Local.pm

## lib/MT/FileMgr/SFTP.pm
	'SFTP connection failed: [_1]' => 'Fallo en la conexión SFTP: [_1]',
	'SFTP get failed: [_1]' => 'Falló la orden \'get\' en el SFTP: [_1]',
	'SFTP put failed: [_1]' => 'Falló la orden \'put\' en el SFTP: [_1]',

## lib/MT/Filter.pm
	'Filters' => 'Filtros',
	'Invalid filter type [_1]:[_2]' => 'Tipo de filtro no válido [_1]:[_2]',
	'Invalid sort key [_1]:[_2]' => 'Clave de ordenación no válida [_1]:[_2]',
	'"editable_terms" and "editable_filters" cannot be specified at the same time.' => 'No pueden utilizarse al mismo tiempo "editable_terms" y "editable_filters".',
	'System Object' => 'Objeto del sistema',

## lib/MT/Folder.pm

## lib/MT/Image/GD.pm
	'Cannot load GD: [_1]' => 'No se puede cargar GD: [_1]',
	'Unsupported image file type: [_1]' => 'Tipo de imagen no soportada: [_1]',
	'Reading file \'[_1]\' failed: [_2]' => 'Fallo leyendo archivo \'[_1]\': [_2]',
	'Reading image failed: [_1]' => 'Fallo leyendo imagen: [_1]',
	'Rotate (degrees: [_1]) is not supported' => 'La rotación (grados: [_1]) no está soportada',

## lib/MT/Image/ImageMagick.pm
	'Cannot load Image::Magick: [_1]' => 'No se pudo cargar Image::Magick: [_1]',
	'Scaling to [_1]x[_2] failed: [_3]' => 'El escalado a [_1]x[_2] falló: [_3]',
	'Cropping a [_1]x[_2] square at [_3],[_4] failed: [_5]' => 'Fallo al recortar un cuadrado [_1]x[_2] en [_3],[_4]: [_5]',
	'Flip horizontal failed: [_1]' => 'Falló el giro horizontal: [_1]',
	'Flip vertical failed: [_1]' => 'Falló el giro vertical: [_1]',
	'Rotate (degrees: [_1]) failed: [_2]' => 'Falló la rotación (grados: [_1]): [_2]',
	'Converting image to [_1] failed: [_2]' => 'Fallo convirtiendo una imagen a [_1]: [_2]',
	'Outputting image failed: [_1]' => 'Fallo al crear la imagen: [_1]',

## lib/MT/Image/Imager.pm
	'Cannot load Imager: [_1]' => 'No se pudo cargar Imager: [_1]',

## lib/MT/Image/NetPBM.pm
	'Cannot load IPC::Run: [_1]' => 'No se pudo cargar IPC::Run: [_1]',
	'Reading alpha channel of image failed: [_1]' => 'Fallo al leer el canal alfa de la imagen: [_1]',
	'Cropping to [_1]x[_2] failed: [_3]' => 'Fallo al recortar a [_1]x[_2]: [_3]',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'No posee una ruta válida a las herramientas NetPBMYou en su máquina.',

## lib/MT/Image.pm
	'Invalid Image Driver [_1]' => 'Controlador de imágenes [_1] no válido',
	'Saving [_1] failed: Invalid image file format.' => 'Falló guardando [_1]: Formato de fichero de imagen no válido.',
	'File size exceeds maximum allowed: [_1] > [_2]' => 'El tamaño del fichero excede el máximo permitido: [_1] > [_2]',

## lib/MT/ImportExport.pm
	'No Blog' => 'Sin Blog',
	'Need either ImportAs or ParentAuthor' => 'Necesita ImportAs o ParentAuthor',
	'Creating new user (\'[_1]\')...' => 'Creando usuario (\'[_1]\')...',
	'Saving user failed: [_1]' => 'Fallo guardando usuario: [_1]',
	'Creating new category (\'[_1]\')...' => 'Creando nueva categoría (\'[_1]\')...',
	'Saving category failed: [_1]' => 'Fallo guardando categoría: [_1]',
	'Invalid status value \'[_1]\'' => 'Valor de estado no válido \'[_1]\'',
	'Invalid allow pings value \'[_1]\'' => 'Valor no válido de permiso de pings \'[_1]\'',
	'Cannot find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.' => 'No se encontró una entrada existente con la fecha \'[_1]\'... ignorando comentarios, y pasando a la siguiente entrada.',
	'Importing into existing entry [_1] (\'[_2]\')' => 'Importando en entrada existente [_1] (\'[_2]\')',
	'Saving entry (\'[_1]\')...' => 'Guardando entrada (\'[_1]\')...',
	'ok (ID [_1])' => 'ok (ID [_1])',
	'Saving entry failed: [_1]' => 'Fallo guardando entrada: [_1]',
	'Creating new comment (from \'[_1]\')...' => 'Creando nuevo comentario (de \'[_1]\')...',
	'Saving comment failed: [_1]' => 'Fallo guardando comentario: [_1]',
	'Creating new ping (\'[_1]\')...' => 'Creando nuevo ping (\'[_1]\')...',
	'Saving ping failed: [_1]' => 'Fallo guardando ping: [_1]',
	'Export failed on entry \'[_1]\': [_2]' => 'Fallo de exportación en la entrada \'[_1]\': [_2]',
	'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Formato de fecha \'[_1]\' no válido; debe ser \'MM/DD/AAAA HH:MM:SS AM|PM\' (AM|PM es opcional)',

## lib/MT/Import.pm
	'Cannot rewind' => 'No se pudo reiniciar',
	'Cannot open \'[_1]\': [_2]' => 'No se pudo abrir \'[_1]\': [_2]',
	'No readable files could be found in your import directory [_1].' => 'No se encontrón ningún fichero legible en su directorio de importación [_1].',
	'Importing entries from file \'[_1]\'' => 'Importando entradas desde el fichero \'[_1]\'',
	'Could not resolve import format [_1]' => 'No se pudo identificar el formato de importación [_1]',
	'Movable Type' => 'Movable Type',
	'Another system (Movable Type format)' => 'Otro sistema (formato Movable Type)',

## lib/MT/IPBanList.pm
	'IP Ban' => 'Bloqueo de IP',
	'IP Bans' => 'Bloqueos de IP',

## lib/MT/JunkFilter.pm
	'Action: Junked (score below threshold)' => 'Acción: Basura (puntuación bajo nivel)',
	'Action: Published (default action)' => 'Acción: Publicado (acción predefinida)',
	'Junk Filter [_1] died with: [_2]' => 'Filtro basura [_1] murió con: [_2]',
	'Unnamed Junk Filter' => 'Filtro basura sin nombre',
	'Composite score: [_1]' => 'Puntuación compuesta: [_1]',

## lib/MT/ListProperty.pm
	'Cannot initialize list property [_1].[_2].' => 'No se pudo inicializar la propiedad de listas [_1].[_2].',
	'Failed to initialize auto list property [_1].[_2]: Cannot find definition of column [_3].' => 'Falló al inicializar automáticamente la lista de propiedades [_1]. [_2] No se pudo encontrar la definición de la columna [_3].',
	'Failed to initialize auto list property [_1].[_2]: unsupported column type.' => 'Falló al inicializar automáticamente la lista de propiedades [_1]. [_2]: Tipo de columna no soportada.',

## lib/MT/Lockout.pm
	'Cannot find author for id \'[_1]\'' => 'No se pudo encontrar al autor con el id \'[_1]\'',
	'User was locked out. IP address: [_1], Username: [_2]' => 'Se desbloqueó al usuario. Dirección IP: [_1], Usuario: [_2]',
	'User Was Locked Out' => 'Se desbloqueó al usuario.',
	'Error sending mail: [_1]' => 'Error enviado correo: [_1]',
	'IP address was locked out. IP address: [_1], Username: [_2]' => 'Se desbloqueó la dirección IP. Dirección IP: [_1], Usuario: [_2]',
	'IP Address Was Locked Out' => 'Se desbloqueó la dirección IP.',
	'User has been unlocked. Username: [_1]' => 'Se desbloqueó al usuario. Usuario: [_1]',

## lib/MT/Log.pm
	'Log messages' => 'Mensajes del registro',
	'Security' => 'Seguridad',
	'Warning' => 'Alerta',
	'Information' => 'Información',
	'Debug' => 'Depuración',
	'Security or error' => 'Seguridad o error',
	'Security/error/warning' => 'Seguridad/error/alarma',
	'Not debug' => 'No depuración',
	'Debug/error' => 'Depuración/error',
	'Showing only ID: [_1]' => 'Mostrando solo ID: [_1]',
	'Page # [_1] not found.' => 'Página nº [_1] no encontrada.',
	'Entry # [_1] not found.' => 'Entrada nº [_1] no encontrada.',
	'Comment # [_1] not found.' => 'Comentario nº [_1] no encontrado.',
	'TrackBack # [_1] not found.' => 'TrackBack nº [_1] no encontrado.',
	'blog' => 'Blog',
	'website' => 'sitio web',
	'search' => 'buscar',
	'author' => 'autor',
	'ping' => 'ping',
	'theme' => 'tema',
	'folder' => 'carpeta',
	'plugin' => 'extensión',
	'page' => 'Página',
	'Message' => 'Mensaje',
	'By' => 'Por',
	'Class' => 'Clase',
	'Level' => 'Nivel',
	'Metadata' => 'Metadatos',
	'Logs on This Website' => 'Históricos de este sitio',
	'Show only errors' => 'Mostrar solo los errores',

## lib/MT/Mail.pm
	'Unknown MailTransfer method \'[_1]\'' => 'MailTransfer método desconocido \'[_1]\'',
	'Username and password is required for SMTP authentication.' => 'El nombre de usuario y la contraseña son necesarios para la autentificación SMTP.',
	'Error connecting to SMTP server [_1]:[_2]' => 'Error conectado con el servidor SMTP [_1]:[_2]',
	'Authentication failure: [_1]' => 'Fallo de autentificación: [_1]',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'No tiene configurada una ruta válida a sendmail en su máquina. ¿Quizás está intentando usar SMTP?',
	'Exec of sendmail failed: [_1]' => 'Fallo la ejecución de sendmail: [_1]',
	'Following required module(s) were not found: ([_1])' => 'No se encontraron los siguientes módulos requeridos: ([_1])',

## lib/MT/Notification.pm
	'Contacts' => 'Contactos',
	'Click to edit contact' => 'Clic para editar el contacto',
	'Save Changes' => 'Guardar cambios',
	'Save' => 'Guardar',

## lib/MT/ObjectAsset.pm
	'Asset Placement' => 'Posición del elemento multimedia',

## lib/MT/ObjectDriver/Driver/DBD/SQLite.pm

## lib/MT/ObjectScore.pm
	'Object Score' => 'Score del Objeto',
	'Object Scores' => 'Scores de los Objetos',

## lib/MT/ObjectTag.pm
	'Tag Placement' => 'Gestión de Etiqueta',
	'Tag Placements' => 'Gestión de las Etiquetas',

## lib/MT/Page.pm
	'Pages in folder: [_1]' => 'Páginas en carpeta: [_1]',
	'Loading blog failed: [_1]' => 'Falló al cargar el blog: [_1]',
	'(root)' => '(raíz)',
	'My Pages' => 'Mis páginas',
	'Pages in This Website' => 'Páginas de esta sitio',
	'Published Pages' => 'Páginas publicadas',
	'Draft Pages' => 'Borradores de páginas',
	'Unpublished Pages' => 'Páginas no publicadas',
	'Scheduled Pages' => 'Páginas programadas',
	'Pages with comments in the last 7 days' => 'Páginas con comentarios en los últimos 7 días',

## lib/MT/Permission.pm

## lib/MT/Placement.pm
	'Category Placement' => 'Gestión de Categorías',

## lib/MT/PluginData.pm
	'Plugin Data' => 'Datos de la extensión',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: [_2][_3] de la regla [_4][_5]',
	'[_1]: [_2][_3] from test [_4]' => '[_1]: [_2][_3] de la prueba [_4]',

## lib/MT/Plugin.pm
	'My Text Format' => 'Mi formato de texto',

## lib/MT.pm
	'Powered by [_1]' => 'Powered by [_1]',
	'Version [_1]' => 'Versión [_1]',
	'http://www.movabletype.com/' => 'http://www.movabletype.com/',
	'Hello, world' => 'Hola, mundo',
	'Hello, [_1]' => 'Hola, [_1]',
	'Message: [_1]' => 'Mensaje: [_1]',
	'If it is present, the third argument to add_callback must be an object of type MT::Component or MT::Plugin' => 'Si está presente, el tercer argumento de add_callback debe ser un objeto de tipo MT::Component o MT::Plugin',
	'Fourth argument to add_callback must be a CODE reference.' => 'El cuarto argumento de add_callback debe ser una referencia a un código.',
	'Two plugins are in conflict' => 'Dos extensiones están en conflicto',
	'Invalid priority level [_1] at add_callback' => 'Nivel de prioridad [_1] no válido en add_callback',
	'Internal callback' => 'Retrollamada interna',
	'Unnamed plugin' => 'Extensión sin nombre',
	'[_1] died with: [_2]' => '[_1] murió: [_2]',
	'Bad LocalLib config ([_1]): [_2]' => 'Configuración LocalLib incorrecta ([_1]): [_2]',
	'Bad ObjectDriver config' => 'Configuración de ObjectDriver incorrecta',
	'Bad CGIPath config' => 'Configuración de CGIPath incorrecta',
	'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Archivo de configuración no encontrado. ¿Quizás olvidó renombrar mt-config.cgi-original a mt-config.cgi?',
	'Plugin error: [_1] [_2]' => 'Error en la extensión: [_1] [_2]',
	'Loading of blog \'[_1]\' failed: [_2]' => 'Falló la carga del blog \'[_1]\': [_2]',
	'Loading template \'[_1]\' failed.' => 'Fallo cargando la plantilla \'[_1]\'.',
	'Error while creating email: [_1]' => 'Error durante la creación del correo: [_1]',
	'The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.' => 'El módulo de Perl necesario para la autentificación de comentaristas mendiante OpenID (Digest::SHA1) no está instalado.',
	'A Perl module required for Google ID commenter authentication is missing: [_1].' => 'El módulo de Perl necesario para la autenfificación de comentaristas mediante Google ID no está instalado: [_1].',
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

## lib/MT/Revisable/Local.pm

## lib/MT/Revisable.pm
	'Bad RevisioningDriver config \'[_1]\': [_2]' => 'Configuración de RevisioningDriver errónea \'[_1]\': [_2]',
	'Revision not found: [_1]' => 'Revisión no encontrada: [_1]',
	'There are not the same types of objects, expecting two [_1]' => 'No son el mismo tipo de objetos, se esperaban dos [_1]',
	'Did not get two [_1]' => 'No se obtuvieron dos [_1]',
	'Unknown method [_1]' => 'Método desconocido [_1]',
	'Revision Number' => 'Revisión número',

## lib/MT/Role.pm
	'__ROLE_ACTIVE' => 'Activo',
	'__ROLE_INACTIVE' => 'Inactivo',
	'Website Administrator' => 'Administrador del sitio web',
	'Can administer the website.' => 'Puede administrar el sitio web',
	'Blog Administrator' => 'Administrador del blog',
	'Can administer the blog.' => 'Puede administrar el blog.',
	'Editor' => 'Editor',
	'Can upload files, edit all entries(categories), pages(folders), tags and publish the site.' => 'Puede subir ficheros, editar todas las entradas (categorías), páginas (carpetas), etiquetas y publicar el sitio.',
	'Can create entries, edit their own entries, upload files and publish.' => 'Puede crear entradas, editar sus propias entradas, subir ficheros y publicar.',
	'Designer' => 'Diseñador',
	'Can edit, manage, and publish blog templates and themes.' => 'Puede editar, administrar y publicar plantillas y temas de blogs.',
	'Webmaster' => 'Webmaster',
	'Can manage pages, upload files and publish blog templates.' => 'Puede administrar páginas, subir ficheros y publicar plantillas de blogs.',
	'Contributor' => 'Colaborador',
	'Can create entries, edit their own entries, and comment.' => 'Puede crear entradas, editar sus propias entradas y comentar.',
	'Moderator' => 'Moderador',
	'Can comment and manage feedback.' => 'Puede comentar y administrar las respuestas.',
	'Can comment.' => 'Puede comentar.',
	'__ROLE_STATUS' => 'Estado',

## lib/MT/Scorable.pm
	'Object must be saved first.' => 'Primero debe guardarse el objeto.',
	'Already scored for this object.' => 'Ya puntuado en este objeto.',
	'Could not set score to the object \'[_1]\'(ID: [_2])' => 'No pudo darse puntuación al objeto \'[_1]\'(ID: [_2])',

## lib/MT/Session.pm
	'Session' => 'Sección',

## lib/MT/Tag.pm
	'Private' => 'Privado',
	'Not Private' => 'No privado',
	'Tag must have a valid name' => 'La etiqueta debe tener un nombre válido',
	'This tag is referenced by others.' => 'Esta etiqueta está referenciada por otros.',
	'Tags with Entries' => 'Etiquetas con entradas',
	'Tags with Pages' => 'Etiquetas con páginas',
	'Tags with Assets' => 'Etiquetas con ficheros multimedia',

## lib/MT/TaskMgr.pm
	'Unable to secure a lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'No fue posible asegurar el bloqueo para la ejecución de tareas del sistema. Asegúrese de que se puede escribir en el directorio TempDir ([_1]).',
	'Error during task \'[_1]\': [_2]' => 'Error durante la tarea \'[_1]\': [_2]',
	'Scheduled Tasks Update' => 'Actualización de tareas programadas',
	'The following tasks were run:' => 'Se ejecutaron las siguientes tareas:',

## lib/MT/TBPing.pm
	'TrackBack' => 'TrackBack',
	'<a href="[_1]">Ping from: [_2] - [_3]</a>' => '<a href="[_1]">Ping desde: [_2] - [_3]</a>',
	'Trackbacks on [_1]: [_2]' => 'Trackbacks en [_1]: [_2]',
	'Trackback Text' => 'Texto del TrackBack',
	'Target' => 'Destino',
	'From' => 'Origen',
	'Source Site' => 'Sitio de origen',
	'Source Title' => 'Título de origen',
	'Trackbacks on My Entries/Pages' => 'TrackBacks en mis entradas/páginas',
	'Non-spam trackbacks' => 'Trackbacks que no son spam',
	'Non-spam trackbacks on this website' => 'TrackBacks no spam en este sitio web',
	'Pending trackbacks' => 'TrackBacks pendientes',
	'Published trackbacks' => 'Trackback publicados',
	'Trackbacks on my entries/pages' => 'TrackBacks en mis entradas/páginas',
	'Trackbacks in the last 7 days' => 'TrackBacks en los últimos 7 días',
	'Spam trackbacks' => 'TrackBacks spam',

## lib/MT/Template/ContextHandlers.pm
	'All About Me' => 'Todo sobre mi',
	'Remove this widget' => 'Eliminar el widget',
	'[_1]Publish[_2] your [_3] to see these changes take effect.' => '[_1]Publique[_2] su [_3] para que los cambios tomen efecto.',
	'[_1]Publish[_2] your site to see these changes take effect.' => '[_1]Publique[_2] el sitio para que los cambios tomen efecto.',
	'Actions' => 'Acciones',
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.org/documentation/appendices/tags/%t.html',
	'You used an [_1] tag without a date context set up.' => 'Usó una etiqueta [_1] sin un contexto de fecha configurado.',
	'Division by zero.' => 'División por cero.',
	'[_1] is not a hash.' => '[_1] no es un hash.',
	'blog(s)' => 'blog/s',
	'website(s)' => 'sitio/s web',
	'No [_1] could be found.' => 'No se encontraron [_1].',
	'records' => 'registros',
	'No template to include was specified' => 'No se especificó plantilla a incluir',
	'Recursion attempt on [_1]: [_2]' => 'Intento de recursión en [_1]: [_2]',
	'Cannot find included template [_1] \'[_2]\'' => 'No se encontró la plantilla incluída [_1] \'[_2]\'',
	'Error in [_1] [_2]: [_3]' => 'Error en [_1] [_2]: [_3]',
	'Writing to \'[_1]\' failed: [_2]' => 'Fallo escribiendo en \'[_1]\': [_2]',
	'File inclusion is disabled by "AllowFileInclude" config directive.' => 'La inclusión de ficheros está deshabilitada por la directiva de configuración "AllowFileInclude".',
	'Cannot find blog for id \'[_1]' => 'No se pudo encontrar un blog con el id \'[_1]',
	'Cannot find included file \'[_1]\'' => 'No se encontró el fichero incluido \'[_1]\'',
	'Error opening included file \'[_1]\': [_2]' => 'Error abriendo el fichero incluido \'[_1]\': [_2]',
	'Recursion attempt on file: [_1]' => 'Intento de recursión en fichero: [_1]',
	'Cannot load user.' => 'No se pudo cargar el usuario.',
	'Cannot find template \'[_1]\'' => 'No se encontró la plantilla \'[_1]\'',
	'Cannot find entry \'[_1]\'' => 'No se encontró la entrada \'[_1]\'',
	'Unspecified archive template' => 'Archivo de plantilla no especificado',
	'Error in file template: [_1]' => 'Error en fichero de plantilla: [_1]',

## lib/MT/Template/Context.pm
	'The attribute exclude_blogs cannot take \'[_1]\' for a value.' => 'El atributo exclude_blogs no puede tener el valor \'[_1]\'.',
	'When the same blog IDs are simultaneously listed in the include_blogs and exclude_blogs attributes, those blogs are excluded.' => 'Si hay identificadores de blogs listados a la vez en los atributos de include_blogs y exclude_blogs, se excluirá a dichos blogs.',
	'You used an \'[_1]\' tag outside of the context of a author; Perhaps you mistakenly placed it outside of an \'MTAuthors\' container tag?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un autor. ¿Quizás la situó por error fuera de la etiqueta contenedora \'MTAuthors\'?',
	'You used an \'[_1]\' tag outside of the context of an entry; Perhaps you mistakenly placed it outside of an \'MTEntries\' container tag?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de una entrada. ¿Quizás la situó por error fuera de la etiqueta contenedor \'MTEntries\'?',
	'You used an \'[_1]\' tag outside of the context of the website; Perhaps you mistakenly placed it outside of an \'MTWebsites\' container tag?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de una sitio web. ¿Quizás la situó por error fuera de la etiqueta contenedor \'MTWebsites\'?',
	'You used an \'[_1]\' tag inside of the context of a blog which has no parent website; Perhaps your blog record is broken?' => 'Ha utilizado una etiqueta \'[_1]\' en el contexto de un blog que no tiene un sitio web raíz. ¿Quizás el registro del blog está mal?',
	'You used an \'[_1]\' tag outside of the context of the blog; Perhaps you mistakenly placed it outside of an \'MTBlogs\' container tag?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un blog. ¿Quizás la situó por error fuera de la etiqueta contenedor \'MTBlogs\'?',
	'You used an \'[_1]\' tag outside of the context of a comment; Perhaps you mistakenly placed it outside of an \'MTComments\' container tag?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un comentario. ¿Quizás la situó por error fuera de la etiqueta contenedor \'MTComments\'?',
	'You used an \'[_1]\' tag outside of the context of a ping; Perhaps you mistakenly placed it outside of an \'MTPings\' container tag?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un ping. ¿Quizás la situó por error fuera de la etiqueta contenedor \'MTPings\'?',
	'You used an \'[_1]\' tag outside of the context of an asset; Perhaps you mistakenly placed it outside of an \'MTAssets\' container tag?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un recurso multimedia. ¿Quizás la situó por error fuera de la etiqueta contenedor \'MTAssets\'?',
	'You used an \'[_1]\' tag outside of the context of a page; Perhaps you mistakenly placed it outside of a \'MTPages\' container tag?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de una página. ¿Quizás la situó por error fuera de la etiqueta contenedor \'MTPages\'?',

## lib/MT/TemplateMap.pm
	'Archive Mapping' => 'Mapeado de archivos',
	'Archive Mappings' => 'Mapeados de archivos',

## lib/MT/Template.pm
	'Template' => 'Plantilla',
	'Template load error: [_1]' => 'Error al cargar plantilla: [_1]',
	'Tried to load the template file from outside of the include path \'[_1]\'' => 'Tried to load the template file from outside of the include path \'[_1]\'',
	'Error reading file \'[_1]\': [_2]' => 'Error leyendo fichero \'[_1]\': [_2]',
	'Publish error in template \'[_1]\': [_2]' => 'Error de publicación en la plantilla \'[_1]\': [_2]',
	'Load of blog \'[_1]\' failed: [_2]' => 'La carga del blog \'[_1]\' falló: [_2]',
	'Template name must be unique within this [_1].' => 'El nombre de la plantilla debe ser único en este [_1].',
	'You cannot use a [_1] extension for a linked file.' => 'No puede usar una extensión [_1] para un fichero enlazado.',
	'Opening linked file \'[_1]\' failed: [_2]' => 'Fallo abriendo fichero enlazado\'[_1]\': [_2]',
	'Index' => 'Índice',
	'Category Archive' => 'Archivo de categorías',
	'Ping Listing' => 'Lista de pings',
	'Comment Error' => 'Error de comentarios',
	'Comment Pending' => 'Comentario pendiente',
	'Uploaded Image' => 'Imagen transferida',
	'Module' => 'Módulo',
	'Widget' => 'Widget',
	'Output File' => 'Fichero de salida',
	'Template Text' => 'Texto de la plantilla',
	'Rebuild with Indexes' => 'Reconstruir con índices',
	'Dynamicity' => 'Dinamicidad',
	'Build Type' => 'Tipo de reconstrucción',
	'Interval' => 'Intervalo',

## lib/MT/Template/Tags/Archive.pm
	'Group iterator failed.' => 'Fallo en iterador de grupo.',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] sólo se puede usar con los archivos diarios, semanales o mensuales.',
	'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Usó una etiqueta [_1] enlazando los archivos \'[_2]\', pero el tipo de archivo no está publicado.',
	'You used an [_1] tag outside of the proper context.' => 'Usó una etiqueta [_1] fuera del contexto correcto.',
	'Could not determine entry' => 'No se pudo determinar la entrada',

## lib/MT/Template/Tags/Asset.pm
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" debe usarse en combinación con el espacio de nombres.',
	'No such user \'[_1]\'' => 'No existe el usuario \'[_1]\'',
	'You have an error in your \'[_2]\' attribute: [_1]' => 'Tiene un error en el atributo \'[_2]\': [_1]',
	'[_1] must be a number.' => '[_1] debe ser un número.',

## lib/MT/Template/Tags/Author.pm
	'The \'[_2]\' attribute will only accept an integer: [_1]' => 'El atributo \'[_2]\' solo aceptará un entero: [_1]',
	'You used an [_1] without a author context set up.' => 'Utilizó un [_1] sin establecer un contexto de autor.',

## lib/MT/Template/Tags/Calendar.pm
	'Invalid weeks_start_with format: must be Sun|Mon|Tue|Wed|Thu|Fri|Sat' => 'Formato de weeks_start_with no válido: debe ser Sun|Mon|Tue|Wed|Thu|Fri|Sat',
	'Invalid month format: must be YYYYMM' => 'Formato de mes no válido: debe ser YYYYMM',
	'No such category \'[_1]\'' => 'No existe la categoría \'[_1]\'',

## lib/MT/Template/Tags/Category.pm
	'MT[_1] must be used in a [_2] context' => 'MT[_1] debe utilizarse en el contexto de [_2]',
	'Cannot find package [_1]: [_2]' => 'No se encontró el paquete [_1]: [_2]',
	'Error sorting [_2]: [_1]' => 'Error ordenando [_2]: [_1]',
	'Cannot use sort_by and sort_method together in [_1]' => 'No pueden usarse juntos sort_by y sort_method en [_1]',
	'[_1] cannot be used without publishing Category archive.' => '[_1] No se puede usar sin publicar archivos por categorías.',
	'[_1] used outside of [_2]' => '[_1] utilizado fuera de [_2]',

## lib/MT/Template/Tags/Commenter.pm
	'This \'[_1]\' tag has been deprecated. Please use \'[_2]\' instead.' => 'Esta etiqueta \'[_1]\' está obsoleta. Por favor, en su lugar use \'[_2]\'.',

## lib/MT/Template/Tags/Comment.pm
	'The MTCommentFields tag is no longer available.  Please include the [_1] template module instead.' => 'La etiqueta MTCommentFields ya no está disponible. Por favor, en su lugar, incluya el módulo de plantilla [_1].',
	'Comment Form' => 'Formulario de comentarios',
	'TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can not be used.' => 'La autentificación de TypePad no está habilitada en este blog. No se puede usar MTRemoteSignInLink.',
	'To enable comment registration, you need to add a TypePad token in your weblog config or user profile.' => 'Para activar el registro de comentarios, debe añadir un token de TypePad a la configuración del weblog o al perfil de usuario.',

## lib/MT/Template/Tags/Entry.pm
	'You used <$MTEntryFlag$> without a flag.' => 'Usó <$MTEntryFlag$> sin \'flag\'.',
	'Could not create atom id for entry [_1]' => 'No se pudo crear un identificador atom en la entrada [_1]',

## lib/MT/Template/Tags/Misc.pm
	'name is required.' => 'el nombre es obligatorio.',
	'Specified WidgetSet \'[_1]\' not found.' => 'No se encontró el conjunto de widgets \'[_1]\' que se especificó.',

## lib/MT/Template/Tags/Ping.pm
	'<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> debe utilizarse en el contexto de una categoría, o con el atributo \'category\' en la etiqueta.',

## lib/MT/Template/Tags/Tag.pm

## lib/MT/Theme/Category.pm
	'[_1] top level and [_2] sub categories.' => '[_1] primer nivel y [_2] sub-categorías.',
	'[_1] top level and [_2] sub folders.' => '[_1] primer nivel y [_2] sub-carpetas.',

## lib/MT/Theme/Element.pm
	'Component \'[_1]\' is not found.' => 'No se encontró el componente \'[_1]\'.',
	'Internal error: the importer is not found.' => 'Error interno: no se encontró el importador.',
	'Compatibility error occurred while applying \'[_1]\': [_2].' => 'Error de compatibilidad al configurar \'[_1]\': [_2].',
	'An Error occurred while applying \'[_1]\': [_2].' => 'Ocurrió un error al configurar \'[_1]\': [_2].',
	'Fatal error occurred while applying \'[_1]\': [_2].' => 'Error fatal al configurar \'[_1]\': [_2].',
	'Importer for \'[_1]\' is too old.' => 'El importador de \'[_1]\' es demasiado antiguo.',
	'Theme element \'[_1]\' is too old for this environment.' => 'El elemento \'[_1]\' del tema es demasiado antiguo para este sistema.',

## lib/MT/Theme/Entry.pm
	'[_1] pages' => '[_1] páginas',

## lib/MT/Theme.pm
	'Failed to load theme [_1].' => 'Fallo al cargar tema [_1].',
	'A fatal error occurred while applying element [_1]: [_2].' => 'Error fatal al aplicar el elemento [_1]: [_2].',
	'An error occurred while applying element [_1]: [_2].' => 'Error fatal al aplicar el elemento [_1]: [_2].',
	'Failed to copy file [_1]:[_2]' => 'Falló al copiar el fichero [_1]:[_2]',
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

## lib/MT/Theme/Pref.pm
	'this element cannot apply for non blog object.' => 'este elemento no puede aplicarse a objetos que no sean blogs.',
	'Failed to save blog object: [_1]' => 'Falló al guardar el objeto de blog: [_1]',
	'default settings for [_1]' => 'configuración predefinida para [_1]',
	'default settings' => 'configuración predefinida',

## lib/MT/Theme/TemplateSet.pm
	'A template set containing [quant,_1,template,templates], [quant,_2,widget,widgets], and [quant,_3,widget set,widget sets].' => 'Un conjunto de plantillas que contiene [quant,_1,template,templates], [quant,_2,widget,widgets], y [quant,_3,conjunto de widgets,conjuntos de widgets].',
	'Widget Sets' => 'Conjuntos de widgets',
	'Failed to make templates directory: [_1]' => 'Fallo al crear el directorio de plantillas: [_1]',
	'Failed to publish template file: [_1]' => 'Fallo al publicar el fichero de plantilla: [_1]',
	'exported_template set' => 'exported_template configurado',

## lib/MT/TheSchwartz/Error.pm
	'Job Error' => 'Error en la Tarea',

## lib/MT/TheSchwartz/ExitStatus.pm
	'Job Exit Status' => 'Status Fin de Tarea',

## lib/MT/TheSchwartz/FuncMap.pm
	'Job Function' => 'Funciones de la Tarea',

## lib/MT/TheSchwartz/Job.pm
	'Job' => 'Tarea',

## lib/MT/Trackback.pm

## lib/MT/Upgrade/Core.pm
	'Upgrading asset path information...' => 'Actualizando la información de la ruta de los ficheros multimedia...',
	'Creating initial website and user records...' => 'Creando registros iniciales de los sitios web y usuarios...',
	'Error saving record: [_1].' => 'Error guardando el registro: [_1].',
	'Error creating role record: [_1].' => 'Error creado el registro de roles: [_1].',
	'First Website' => 'Primer sitio web',
	'Creating new template: \'[_1]\'.' => 'Creando nueva plantilla: \'[_1]\'.',
	'Mapping templates to blog archive types...' => 'Mapeando plantillas con tipos de archivo de blogs...',
	'Expiring cached MT News widget...' => 'Caducando el widget de Noticias de MT en caché...',
	'Error loading class: [_1].' => 'Error cargando la clase: [_1].',
	'Assigning custom dynamic template settings...' => 'Asignando opciones de plantillas dinámicas personalizadas...',
	'Assigning user types...' => 'Asignando tipos de usuario...',
	'Assigning category parent fields...' => 'Asignando campos de ancentros en las categorías...',
	'Assigning template build dynamic settings...' => 'Asignando opciones de construcción de plantillas dinámicas...',
	'Assigning visible status for comments...' => 'Asignando estado de visibilidad a los comentarios...',
	'Assigning visible status for TrackBacks...' => 'Asignando estado de visiblidad para los TrackBacks...',

## lib/MT/Upgrade.pm
	'Invalid upgrade function: [_1].' => 'Función de actualización no válida: [_1].',
	'Error loading class [_1].' => 'Error cargando clase [_1].',
	'Upgrading table for [_1] records...' => 'Actualizando las tablas para los registros [_1]...',
	'Upgrading database from version [_1].' => 'Actualizando base de datos desde la versión [_1].',
	'Database has been upgraded to version [_1].' => 'Se actualizó la base de datos a la versión [_1].',
	'User \'[_1]\' upgraded database to version [_2]' => 'Usuario \'[_1]\' actualizó la base de datos a la versión [_2]',
	'Plugin \'[_1]\' upgraded successfully to version [_2] (schema version [_3]).' => 'Extensión \'[_1]\' actualizada con éxito a la versión [_2] (versión del esquema [_3]).',
	'User \'[_1]\' upgraded plugin \'[_2]\' to version [_3] (schema version [_4]).' => 'Usuario \'[_1]\' actualizó la extensión \'[_2]\' a la versión [_3] (versión del esquema [_4]).',
	'Plugin \'[_1]\' installed successfully.' => 'La extensión \'[_1]\' se actualizó correctamente.',
	'User \'[_1]\' installed plugin \'[_2]\', version [_3] (schema version [_4]).' => 'Usuario \'[_1]\' instaló la extensión \'[_2]\', versión [_3] (versión del esquema [_4]).',
	'Assigning entry comment and TrackBack counts...' => 'Asignando totales de comentarios y trackbacks de las entradas...',
	'Error saving [_1] record # [_3]: [_2]...' => 'Error guardando registro [_1] # [_3]: [_2]...',

## lib/MT/Upgrade/v1.pm
	'Creating template maps...' => 'Creando mapas de plantillas...',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'Mapeando ID plantilla [_1] a [_2] ([_3]).',
	'Mapping template ID [_1] to [_2].' => 'Mapeando ID plantilla [_1] a [_2].',
	'Creating entry category placements...' => 'Creando situaciones de categorías de entradas...',

## lib/MT/Upgrade/v2.pm
	'Updating category placements...' => 'Actualizando situación de categorías...',
	'Assigning comment/moderation settings...' => 'Asignando opciones de comentarios/moderación...',

## lib/MT/Upgrade/v3.pm
	'Custom ([_1])' => 'Personalizado ([_1])',
	'This role was generated by Movable Type upon upgrade.' => 'Este rol fue generado por Movable Type durante la actualización.',
	'Removing Dynamic Site Bootstrapper index template...' => 'Borrando plantilla índice del arranque dinámico...',
	'Creating configuration record.' => 'Creando registro de configuración.',
	'Setting your permissions to administrator.' => 'Cambiando sus permisos a administrador.',
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
	'Removing unnecessary indexes...' => 'Eleminando índices innecesarios...',
	'Moving metadata storage for categories...' => 'Migrando los metadatos de las categorías...',
	'Upgrading metadata storage for [_1]' => 'Migrando los metadatos de [_1]',
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
	'_WEBMASTER_MT4' => 'Webmaster',
	'Webmaster (MT4)' => 'Webmaster (MT4)',
	'Populating new role for website...' => 'Creando nuevo rol para el sitio web...',
	'Can manage pages, Upload files and publish blog templates.' => 'Puede gestionar las páginas, subir ficheros y publicar plantillas de blogs.',
	'Designer (MT4)' => 'Diseñador (MT4)',
	'Populating new role for theme...' => 'Poblando el nuevo rol para los temas...',
	'Can edit, manage and publish blog templates and themes.' => 'Puede editar, gestionar y publicar plantillas y temas de blogs.',
	'Assigning new system privilege for system administrator...' => 'Asignando nuevo sistema de privilegios al administrador del sistema...',
	'Assigning to  [_1]...' => 'Asignando a [_1]...',
	'Migrating mtview.php to MT5 style...' => 'Migrando mtview.php al estilo MT5...',
	'Migrating DefaultSiteURL/DefaultSiteRoot to website...' => 'Migrando DefaultSiteURL/DefaultSiteRoot al sitio web...',
	'New user\'s website' => 'Sitio web del nuevo usuario',
	'Migrating existing [quant,_1,blog,blogs] into websites and their children...' => 'Migrando [quant,_1,el blog existente,los blogs existentes] a sitios webs con hijos...',
	'Error loading role: [_1].' => 'Error cargando rol: [_1].',
	'New WebSite [_1]' => 'Nuevo sitio web [_1]',
	'An error occurred during generating a website upon upgrade: [_1]' => 'Ocurrió un error al crear un sitio web durante la actualización: [_1]',
	'Generated a website [_1]' => 'Generado un sitio web [_1]',
	'An error occurred during migrating a blog\'s site_url: [_1]' => 'Ocurrió un error al migrar el site_url de un blog: [_1]',
	'Moved blog [_1] ([_2]) under website [_3]' => 'Se movió el blog [_1] ([_2]) bajo el sitio web [_3]',
	'Removing technorati update-ping service from [_1] (ID:[_2]).' => 'Borrando el servicio de ping de technorati de [_1] (ID:[_2]).',
	'Recovering type of author...' => 'Recuperando el tipo de autor...',
	'Merging dashboard settings...' => 'Uniendo las opciones del tablón...',
	'Classifying blogs...' => 'Clasificando blogs...',
	'Rebuilding permissions...' => 'Reconstruyendo permisos...',
	'Assigning ID of author for entries...' => 'Asignando el identificador de autor para las entradas...',
	'Removing widget from dashboard...' => 'Borrando widget del Removing widget from dashboard...',
	'Ordering Categories and Folders of Blogs...' => 'Ordenando las categorías y las carpetas de los blogs...',
	'Ordering Folders of Websites...' => 'Ordenando las carpetas de los sitios...',
	'Setting the \'created by\' ID for any user for whom this field is not defined...' => 'Indicando el identificador \'created_by\' para los usuarios que no tienen el campo definido...',
	'Assigning a language to each blog to help choose appropriate display format for dates...' => 'Asignando un idioma a cada blog para ayudarlos a mostrar las fechas en un formato correcto...',
	'Adding notification dashboard widget...' => 'Añadiendo el widget para el centro de notificaciones...',

## lib/MT/Upgrade/v6.pm
	'Fixing TheSchwartz::Error table...' => 'Corrigiendo la tabla TheSchwartz:Error...',
	'Migrating current blog to a website...' => 'Migrando el blog actual a un sitio web...',
	'Migrating the record for recently accessed blogs...' => 'Migrando el registro de accesos recientes a blogs...',
	'Adding Website Administrator role...' => 'Añadiendo el rol de administrador de sitio web...',
	'Migrating "This is you" dashboard widget...' => 'Migrando el widget para el panel "Este es usted"...',
	'Adding "Site stats" dashboard widget...' => 'Añadiendo el widget para el panel "Estadísticas del sitio"...',
	'Reordering dashboard widgets...' => 'Reordenando los widgets de paneles...',

## lib/MT/Util/Archive.pm
	'Type must be specified' => 'Debe especificar el tipo',
	'Registry could not be loaded' => 'El registro no pudo cargarse',

## lib/MT/Util/Archive/Tgz.pm
	'Type must be tgz.' => 'El tipo debe ser tgz.',
	'Could not read from filehandle.' => 'No se pudo leer desde el manejador de ficheros',
	'File [_1] is not a tgz file.' => 'El fichero [_1] no es un tgz.',
	'File [_1] exists; could not overwrite.' => 'El fichero [_1] existe: no puede sobreescribirse.',
	'Cannot extract from the object' => 'No se pudo extraer usando el objeto',
	'Cannot write to the object' => 'No se pudo escribir en el objeto',
	'Both data and file name must be specified.' => 'Se deben especificar tanto los datos como el nombre del fichero.',

## lib/MT/Util/Archive/Zip.pm
	'Type must be zip' => 'El tipo debe ser zip',
	'File [_1] is not a zip file.' => 'El fichero [_1] no es un fichero zip.',

## lib/MT/Util/Captcha.pm
	'Movable Type default CAPTCHA provider requires Image::Magick.' => 'El proveedor predefinido de CAPTCHA de Movable Type necesita Image::Magick',
	'You need to configure CaptchaSourceImageBase.' => 'Debe configurar CaptchaSourceImageBase.',
	'Type the characters you see in the picture above.' => 'Introduzca los caracteres que ve en la imagen de arriba.',
	'Image creation failed.' => 'Falló la creación de la imagen.',
	'Image error: [_1]' => 'Error de imagen: [_1]',

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

## lib/MT/Util/YAML/Syck.pm

## lib/MT/Util/YAML/Tiny.pm

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
	'Scheduled publishing.' => 'Publicación programada.',
	'An error occurred while publishing scheduled entries: [_1]' => 'Ocurrió un error durante la publicación de las entradas programadas: [_1]',
	'An error occurred while unpublishing past entries: [_1]' => 'Ocurrió un error durante la despublicación de las entradas antiguas: [_1]',

## lib/MT/Website.pm
	'__BLOG_COUNT' => 'Blogs',

## lib/MT/Worker/Publish.pm
	'Background Publishing Done' => 'Publicación en segundo plano realizada',
	'Published: [_1]' => 'Publicado: [_1]',
	'Error rebuilding file [_1]:[_2]' => 'Error reconstruyendo el fichero [_1]:[_2]',
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- conjunto completo ([quant,_1,fichero,ficheros] en [_2] segundos)',

## lib/MT/Worker/Sync.pm
	"Error during rsync of files in [_1]:\n" => "Error en la sincronización de ficheros rsync in [_1]:
",
	'Done Synchornizing Files' => 'Sincronización de ficheros realizada',
	'Done syncing files to [_1] ([_2])' => 'Ficheros sincronizados en [_1] ([_2])',

## lib/MT/XMLRPC.pm
	'No WeblogsPingURL defined in the configuration file' => 'WeblogsPingURL no está definido en el fichero de configuración',
	'No MTPingURL defined in the configuration file' => 'MTPingURL no está definido en el fichero de configuración',
	'HTTP error: [_1]' => 'Error HTTP: [_1]',
	'Ping error: [_1]' => 'Error de ping: [_1]',

## lib/MT/XMLRPCServer.pm
	'Invalid timestamp format' => 'Formato de fecha no válido',
	'No web services password assigned.  Please see your user profile to set it.' => 'No se ha establecido la contraseña de servicios web.  Por favor, vaya al perfil de su usuario para configurarla.',
	'Requested permalink \'[_1]\' is not available for this page' => 'El enlace permanente solicitado \'[_1]\' no está disponible para esta página',
	'Saving folder failed: [_1]' => 'Fallo al guardar la carpeta: [_1]',
	'No blog_id' => 'Sin blog_id',
	'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => 'El valor de \'mt_[_1]\' debe ser 0 ó 1 (era \'[_2]\')',
	'Not allowed to edit entry' => 'No tiene permiso para editar la entrada',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'Entrada \'[_1]\' ([lc,_5] #[_2]) borrada por \'[_3]\' (usuario #[_4]) para xml-rpc',
	'Not allowed to get entry' => 'No tiene permiso para obtener la entrada',
	'Not allowed to set entry categories' => 'No tiene permiso para modificar las categorías de la entrada',
	'Not allowed to upload files' => 'No tiene permiso para transferir ficheros',
	'No filename provided' => 'No se especificó el nombre del fichero ',
	'Error writing uploaded file: [_1]' => 'Error escribiendo el fichero transferido: [_1]',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'El módulo de Perl Image::Size es necesario para obtener las dimensiones de las imágenes transferidas.',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Los métodos de las plantillas no están implementados, debido a las diferencias entre Blogger API y Movable Type API.',

## mt-static/addons/Sync.pack/js/cms.js
	'Continue' => 'Continuar',
	'You have unsaved changes to this page that will be lost.' => 'Tiene cambios no guardados en esta página que se perderán.',

## mt-static/chart-api/deps/raphael-min.js
	'+e.x+' => '+e.x+',

## mt-static/chart-api/mtchart.js

## mt-static/chart-api/mtchart.min.js

## mt-static/jquery/jquery.mt.js
	'Invalid value' => 'Valor no válido',
	'You have an error in your input.' => 'Hay un error en lo que introdujo.',
	'Invalid date format' => 'Formato de fecha no válido',
	'Invalid URL' => 'URL no válida',
	'This field is required' => 'Este campo es obligatorio',
	'This field must be an integer' => 'Este campo debe ser un número entero',
	'This field must be a number' => 'Este campo debe ser un número',

## mt-static/jquery/jquery.mt.min.js

## mt-static/js/assetdetail.js
	'No Preview Available.' => 'Vista previa no disponible.',
	'Dimensions' => 'Tamaño',
	'File Name' => 'Nombre fichero',

## mt-static/js/dialog.js
	'(None)' => '(Ninguno)',

## mt-static/js/image_editor/fabric.js
	' +
                          toFixed(center.x, NUM_FRACTION_DIGITS) +
                           +
                          toFixed(center.y, NUM_FRACTION_DIGITS) +
                        ' => ' +
                          toFixed(center.x, NUM_FRACTION_DIGITS) +
                           +
                          toFixed(center.y, NUM_FRACTION_DIGITS) +
                        ',
	', (-this.width / 2), , (-this.height/2), ' => ', (-this.width / 2), , (-this.height/2), ',
	' + (-this.width/2) +  + (-this.height/2) + ' => ' + (-this.width/2) +  + (-this.height/2) + ',
	', toFixed(offsets.textLeft, 2), , toFixed(offsets.textTop, 2), ' => ', toFixed(offsets.textLeft, 2), , toFixed(offsets.textTop, 2), ',
	',
        -this.width / 2, ,
        -this.height + heightOfLine, ' => ',
        -this.width / 2, ,
        -this.height + heightOfLine, ',

## mt-static/js/image_editor/fabric.min.js
	'+e(n.x,r)++e(n.y,r)+' => '+e(n.x,r)++e(n.y,r)+', # Translate - New
	',i(r.textLeft,2)," ",i(r.textTop,2),' => ',i(r.textLeft,2)," ",i(r.textTop,2),', # Translate - New

## mt-static/js/tc/mixer/display.js
	'Title:' => 'Título:',
	'Description:' => 'Descriptión:',
	'Author:' => 'Authr:',
	'Tags:' => 'Etiquetas:',
	'URL:' => 'URL:',

## mt-static/js/upload_settings.js
	'You must set a valid path.' => 'Debe indicar una ruta válida.',
	'You must set a path begining with %s or %a.' => 'Debe indicar una ruta que comience con %s o %a.', # Translate - New

## mt-static/mt.js
	'delete' => 'borrar',
	'remove' => 'borrar',
	'enable' => 'habilitar',
	'disable' => 'deshabilitar',
	'publish' => 'Publicar',
	'unlock' => 'desbloquear',
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
	'First' => 'Primero',
	'Prev' => 'Anterior',
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] of [_3]',
	'[_1] &ndash; [_2]' => '[_1] &ndash; [_2]',
	'Last' => 'Último',

## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => 'Insertar texto con formato',

## mt-static/plugins/FormattedTextForTinyMCE/langs/template.js
	'Boilerplate' => 'Texto con formato',
	'Select Boilerplate' => 'Seleccionar Texto con formato',

## mt-static/plugins/Loupe/js/vendor.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/langs/plugin.js
	'Fullscreen' => 'Pantalla completa',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/advanced.js
	'Bold (Ctrl+B)' => 'Negrita (Ctrl+B)',
	'Italic (Ctrl+I)' => 'Itálica (Ctrl+I)',
	'Underline (Ctrl+U)' => 'Subrayado (Ctrl+U)',
	'Strikethrough' => 'Tachado',
	'Block Quotation' => 'Cita',
	'Unordered List' => 'Lista no ordenada',
	'Ordered List' => 'Lista ordenada',
	'Horizontal Line' => 'Línea horizontal',
	'Insert/Edit Link' => 'Insertar/Editar enlace',
	'Unlink' => 'Borrar enlace',
	'Undo (Ctrl+Z)' => 'Deshacer (Ctrl+Z)',
	'Redo (Ctrl+Y)' => 'Rehacer (Ctrl+Y)',
	'Select Text Color' => 'Color de texto',
	'Select Background Color' => 'Color de fondo',
	'Remove Formatting' => 'Borrar formato',
	'Align Left' => 'Alinear izquierda',
	'Align Center' => 'Alinear derecha',
	'Align Right' => 'Alinear centro',
	'Indent' => 'Indentar',
	'Outdent' => 'Desindentar',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/core.js
	'Class Name' => 'Nombre de la clase',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/insert_html.js
	'Insert HTML' => 'Insertar HTML',
	'Source' => 'Fuente',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/plugin.js
	'Insert Link' => 'Insertar enlace',
	'Insert Image Asset' => 'Insertar imagen',
	'Insert Asset Link' => 'Insertar enlace',
	'Toggle Fullscreen Mode' => 'Des/Activar modo pantalla completa',
	'Toggle HTML Edit Mode' => 'Des/Activar modo edición HTML',
	'Strong Emphasis' => 'Énfasis negrita',
	'Emphasis' => 'Énfasis',
	'List Item' => 'Elemento lista',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/paste/editor_plugin.js
	'paste.plaintext_mode_sticky' => 'paste.plaintext_mode_sticky',
	'paste.plaintext_mode' => 'paste.plaintext_mode',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/paste/editor_plugin_src.js

## mt-static/plugins/TinyMCE/tiny_mce/themes/advanced/editor_template.js
	'advanced.path' => 'advanced.path',

## mt-static/plugins/TinyMCE/tiny_mce/themes/advanced/editor_template_src.js

## mt-static/plugins/TinyMCE/tiny_mce/themes/advanced/js/charmap.js
	'advanced_dlg.charmap_usage' => 'advanced_dlg.charmap_usage',

## mt-static/plugins/TinyMCE/tiny_mce/utils/editable_selects.js
	'value' => 'valor',

## themes/classic_blog/templates/about_this_page.mtml

## themes/classic_blog/templates/archive_index.mtml

## themes/classic_blog/templates/archive_widgets_group.mtml

## themes/classic_blog/templates/author_archive_list.mtml

## themes/classic_blog/templates/banner_footer.mtml

## themes/classic_blog/templates/calendar.mtml

## themes/classic_blog/templates/category_archive_list.mtml

## themes/classic_blog/templates/category_entry_listing.mtml

## themes/classic_blog/templates/comment_detail.mtml

## themes/classic_blog/templates/comment_listing.mtml

## themes/classic_blog/templates/comment_preview.mtml

## themes/classic_blog/templates/comment_response.mtml

## themes/classic_blog/templates/comments.mtml

## themes/classic_blog/templates/creative_commons.mtml

## themes/classic_blog/templates/current_author_monthly_archive_list.mtml

## themes/classic_blog/templates/current_category_monthly_archive_list.mtml

## themes/classic_blog/templates/date_based_author_archives.mtml

## themes/classic_blog/templates/date_based_category_archives.mtml

## themes/classic_blog/templates/dynamic_error.mtml

## themes/classic_blog/templates/entry.mtml

## themes/classic_blog/templates/entry_summary.mtml

## themes/classic_blog/templates/javascript.mtml

## themes/classic_blog/templates/main_index.mtml

## themes/classic_blog/templates/main_index_widgets_group.mtml

## themes/classic_blog/templates/monthly_archive_dropdown.mtml

## themes/classic_blog/templates/monthly_archive_list.mtml

## themes/classic_blog/templates/monthly_entry_listing.mtml

## themes/classic_blog/templates/openid.mtml

## themes/classic_blog/templates/page.mtml

## themes/classic_blog/templates/pages_list.mtml

## themes/classic_blog/templates/powered_by.mtml

## themes/classic_blog/templates/recent_assets.mtml

## themes/classic_blog/templates/recent_comments.mtml

## themes/classic_blog/templates/recent_entries.mtml

## themes/classic_blog/templates/search.mtml

## themes/classic_blog/templates/search_results.mtml

## themes/classic_blog/templates/sidebar.mtml

## themes/classic_blog/templates/signin.mtml

## themes/classic_blog/templates/syndication.mtml

## themes/classic_blog/templates/tag_cloud.mtml

## themes/classic_blog/templates/technorati_search.mtml

## themes/classic_blog/templates/trackbacks.mtml

## themes/classic_blog/theme.yaml
	'A traditional blogging design that comes with plenty of styles and a selection of 2 column / 3 column layouts. Best for use in standard blog publishing applications.' => 'Un diseño de blogs tradicional con múltiples estilos y posibilidad de seleccionar una disposición a 2 o 3 columnas. Recomendado para instalaciones de blogs estándares.',

## themes/classic_website/templates/about_this_page.mtml
	'<a href="[_1]">[_2]</a> was the previous entry in this website.' => '<a href="[_1]">[_2]</a> fue la entrada anterior en este sitio.',
	'<a href="[_1]">[_2]</a> is the next entry in this website.' => '<a href="[_1]">[_2]</a> es la siguiente entrada en este sitio.',

## themes/classic_website/templates/archive_index.mtml

## themes/classic_website/templates/archive_widgets_group.mtml

## themes/classic_website/templates/author_archive_list.mtml

## themes/classic_website/templates/banner_footer.mtml

## themes/classic_website/templates/blogs.mtml

## themes/classic_website/templates/calendar.mtml

## themes/classic_website/templates/category_archive_list.mtml

## themes/classic_website/templates/category_entry_listing.mtml

## themes/classic_website/templates/comment_detail.mtml

## themes/classic_website/templates/comment_listing.mtml

## themes/classic_website/templates/comment_preview.mtml

## themes/classic_website/templates/comment_response.mtml

## themes/classic_website/templates/comments.mtml

## themes/classic_website/templates/creative_commons.mtml

## themes/classic_website/templates/current_author_monthly_archive_list.mtml

## themes/classic_website/templates/current_category_monthly_archive_list.mtml

## themes/classic_website/templates/date_based_author_archives.mtml

## themes/classic_website/templates/date_based_category_archives.mtml

## themes/classic_website/templates/dynamic_error.mtml

## themes/classic_website/templates/entry.mtml

## themes/classic_website/templates/entry_summary.mtml

## themes/classic_website/templates/javascript.mtml

## themes/classic_website/templates/main_index.mtml

## themes/classic_website/templates/main_index_widgets_group.mtml

## themes/classic_website/templates/monthly_archive_dropdown.mtml

## themes/classic_website/templates/monthly_archive_list.mtml

## themes/classic_website/templates/monthly_entry_listing.mtml

## themes/classic_website/templates/openid.mtml

## themes/classic_website/templates/page.mtml

## themes/classic_website/templates/pages_list.mtml

## themes/classic_website/templates/powered_by.mtml

## themes/classic_website/templates/recent_assets.mtml

## themes/classic_website/templates/recent_comments.mtml

## themes/classic_website/templates/recent_entries.mtml

## themes/classic_website/templates/search.mtml

## themes/classic_website/templates/search_results.mtml

## themes/classic_website/templates/sidebar.mtml

## themes/classic_website/templates/signin.mtml

## themes/classic_website/templates/syndication.mtml
	q{Subscribe to this website's feed} => q{Suscribirse a la sindicación de este sitio web},

## themes/classic_website/templates/tag_cloud.mtml

## themes/classic_website/templates/technorati_search.mtml

## themes/classic_website/templates/trackbacks.mtml

## themes/classic_website/theme.yaml
	'Create a blog portal that aggregates contents from several blogs in one website.' => 'Crear un portal que agrega contenidos de otros blogs en un sitio web.',
	'Classic Website' => 'Sitio web clásico',

## themes/eiger/templates/banner_footer.mtml
	'Navigation' => 'Navegación',
	'This blog is licensed under a <a rel="license" href="[_1]">Creative Commons License</a>.' => 'Este blog tiene una <a rel="license" href="[_1]">Licencia Creative Commons</a>.',

## themes/eiger/templates/category_archive_list.mtml

## themes/eiger/templates/category_entry_listing.mtml
	'Home' => 'Inicio',
	'Pagination' => 'Paginación',
	'Related Contents (Blog)' => 'Contenidos relacionados (Blog)',

## themes/eiger/templates/comment_detail.mtml

## themes/eiger/templates/comment_form.mtml
	'Post a Comment' => 'Publicar un comentario',
	'Reply to comment' => 'Responder al comentario',

## themes/eiger/templates/comment_preview.mtml

## themes/eiger/templates/comment_response.mtml
	'Your comment has been received and held for approval by the blog owner.' => 'Su comentario ha sido recibido y está pendiente de aprobación por parte del administrador del blog.',

## themes/eiger/templates/comments.mtml

## themes/eiger/templates/dynamic_error.mtml
	'Related Contents (Index)' => 'Contenidos relacionados (Índice)',

## themes/eiger/templates/entries_list.mtml
	'Read more' => 'Leer más',

## themes/eiger/templates/entry.mtml
	'Posted on' => 'Publicado en',
	'Previous entry' => 'Entrada anterior',
	'Next entry' => 'Entrada posterior',
	'Zenback' => 'Zenback',

## themes/eiger/templates/entry_summary.mtml

## themes/eiger/templates/index_page.mtml
	'Main Image' => 'Imagen principal',

## themes/eiger/templates/javascript.mtml
	'The sign-in attempt was not successful; please try again.' => 'El intento de registro no tuvo éxito; por favor, inténtelo de nuevo.',

## themes/eiger/templates/javascript_theme.mtml
	'Menu' => 'Menú',

## themes/eiger/templates/main_index.mtml

## themes/eiger/templates/navigation.mtml
	'About' => 'Acerca de',

## themes/eiger/templates/page.mtml

## themes/eiger/templates/pages_list.mtml

## themes/eiger/templates/pagination.mtml
	'Older entries' => 'Entradas anteriores',
	'Newer entries' => 'Entradas posteriores',

## themes/eiger/templates/recent_entries.mtml

## themes/eiger/templates/sample_widget_01.mtml
	'Sample Widget' => 'Widget de ejemplo',
	'This is sample widget' => 'Este es un widget de ejemplo',

## themes/eiger/templates/sample_widget_02.mtml
	'Advertisement' => 'Publicidad',

## themes/eiger/templates/sample_widget_03.mtml
	'Banner' => 'Cabecera',

## themes/eiger/templates/sample_widget_04.mtml
	'Links' => 'Enlaces',
	'Link Text' => 'Texto del enlace',

## themes/eiger/templates/search.mtml

## themes/eiger/templates/search_results.mtml
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Por defecto, este motor de búsqueda comprueba todas las palabras sin tener en cuenta el orden. Para buscar una frase exacta, encierre la frase entre comillas:',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'El motor de búsqueda también soporta los operadores AND, OR y NOT para especificar expresiones lógicas:',

## themes/eiger/templates/styles.mtml
	'for Comments, Trackbacks' => 'para comentarios, Trackbacks',
	'Sample Style' => 'Estilo de ejemplo',
	'Category Label' => 'Etiqueta de categorías',

## themes/eiger/templates/syndication.mtml

## themes/eiger/templates/trackbacks.mtml
	'<a href="[_1]">[_2]</a> - [_3]</a>' => '<a href="[_1]">[_2]</a> - [_3]</a>',

## themes/eiger/templates/yearly_archive_dropdown.mtml
	'Select a Year...' => 'Seleccione un año...',

## themes/eiger/templates/yearly_archive_list.mtml

## themes/eiger/templates/yearly_entry_listing.mtml

## themes/eiger/templates/zenback.mtml
	'Please paste the Zenback script code here' => 'Por favor, pegue aquí el código de Zenback',

## themes/eiger/theme.yaml
	'_THEME_DESCRIPTION' => '"Eiger" es un tema personalizable y adaptativo, diseñado para sitios web corporativos. Además de soporte multidispositivo, a través de Media Query (CSS), las funciones de Movable Type facilitan la personalización de los contenidos navegables y de los elementos gráficos, como logotipos, cabeceras y carteles.',
	'_ABOUT_PAGE_TITLE' => 'Página "Acerca de"',
	'_ABOUT_PAGE_BODY' => '
                 <p>Esta es una página "Acerca de" de ejemplo. (Habitualmente, una página "Acerca de" ofrece información destacable sobre una persona o una organización).</p>
                 <p>Si se utiliza la etiqueta <code>@ABOUT_PAGE</code> en una página web, se añadirá la página "Acerca de" a la lista de navegación tanto en la cabecera como en el pie.</p>',
	'_SAMPLE_PAGE_TITLE' => 'Página de ejemplo',
	'_SAMPLE_PAGE_BODY' => '
                 <p>Esta es una página "Acerca de" de ejemplo. (Habitualmente, una página "Acerca de" ofrece información destacable sobre una persona o una organización).</p>
                 <p>Si se utiliza la etiqueta <code>@ABOUT_PAGE</code> en una página web, se añadirá la página "Acerca de" a la lista de navegación tanto en la cabecera como en el pie.</p>',
	'Eiger' => 'Eiger',
	'Blog Index' => 'Índice del blog',
	'Index Page' => 'Página índice',
	'Stylesheet for IE (8 or lower)' => 'Hoja de estilo para IE (8 o menor)',
	'JavaScript - Theme' => 'JavaScript - Tema',
	'Yearly Entry Listing' => 'Lista anual de entradas',
	'Displays errors for dynamically published templates.' => 'Mostrar errores de las plantillas publicadas dinámicamente.',
	'Yearly Archives Dropdown' => 'Archivos anuales - Desplegable',
	'Yearly Archives' => 'Archivos anuales',
	'Sample Widget 01' => 'Widget de ejemplo 01',
	'Sample Widget 02' => 'Widget de ejemplo 02',
	'Sample Widget 03' => 'Widget de ejemplo 03',
	'Sample Widget 04' => 'Widget de ejemplo 04',

## themes/pico/templates/about_this_page.mtml

## themes/pico/templates/archive_index.mtml
	'Related Content' => 'Contenido relacionado',

## themes/pico/templates/archive_widgets_group.mtml

## themes/pico/templates/author_archive_list.mtml

## themes/pico/templates/banner_footer.mtml

## themes/pico/templates/calendar.mtml

## themes/pico/templates/category_archive_list.mtml

## themes/pico/templates/category_entry_listing.mtml

## themes/pico/templates/comment_detail.mtml

## themes/pico/templates/comment_listing.mtml

## themes/pico/templates/comment_preview.mtml
	'Preview Comment' => 'Prever comentario',

## themes/pico/templates/comment_response.mtml

## themes/pico/templates/comments.mtml

## themes/pico/templates/creative_commons.mtml

## themes/pico/templates/current_author_monthly_archive_list.mtml

## themes/pico/templates/current_category_monthly_archive_list.mtml

## themes/pico/templates/date_based_author_archives.mtml

## themes/pico/templates/date_based_category_archives.mtml

## themes/pico/templates/dynamic_error.mtml

## themes/pico/templates/entry.mtml

## themes/pico/templates/entry_summary.mtml

## themes/pico/templates/javascript.mtml

## themes/pico/templates/main_index.mtml

## themes/pico/templates/main_index_widgets_group.mtml

## themes/pico/templates/monthly_archive_dropdown.mtml

## themes/pico/templates/monthly_archive_list.mtml

## themes/pico/templates/monthly_entry_listing.mtml

## themes/pico/templates/navigation.mtml
	'Subscribe' => 'Suscribirse',

## themes/pico/templates/openid.mtml

## themes/pico/templates/page.mtml

## themes/pico/templates/pages_list.mtml

## themes/pico/templates/recent_assets.mtml

## themes/pico/templates/recent_comments.mtml

## themes/pico/templates/recent_entries.mtml

## themes/pico/templates/search.mtml

## themes/pico/templates/search_results.mtml

## themes/pico/templates/signin.mtml

## themes/pico/templates/syndication.mtml

## themes/pico/templates/tag_cloud.mtml

## themes/pico/templates/technorati_search.mtml

## themes/pico/templates/trackbacks.mtml

## themes/pico/theme.yaml
	q{Pico is a microblogging theme, designed for keeping things simple to handle frequent updates. To put the focus on content we've moved the sidebars below the list of posts.} => q{Pico es un tema para microblogs, diseñado con la simplicidad en mente, para mostrar actualizaciones frecuentes. Hemos movido las barras laterales debajo de la lista de entradas para destacar el contenido.},
	'Pico' => 'Pico',
	'Pico Styles' => 'Estilos Pico',
	'A collection of styles compatible with Pico themes.' => 'Colección de estilos compatible con los temas Pico.',

## themes/rainier/templates/banner_footer.mtml

## themes/rainier/templates/category_archive_list.mtml

## themes/rainier/templates/category_entry_listing.mtml
	'Related Contents' => 'Contenidos relacionados',

## themes/rainier/templates/comment_detail.mtml

## themes/rainier/templates/comment_form.mtml

## themes/rainier/templates/comment_preview.mtml

## themes/rainier/templates/comment_response.mtml

## themes/rainier/templates/comments.mtml

## themes/rainier/templates/dynamic_error.mtml

## themes/rainier/templates/entry.mtml
	'Posted on [_1]' => 'Publicado en [_1]',
	'by [_1]' => 'Por [_1]',
	'in [_1]' => 'en [_1]',

## themes/rainier/templates/entry_summary.mtml
	'Continue reading' => 'Continuar lectura',

## themes/rainier/templates/javascript.mtml

## themes/rainier/templates/javascript_theme.mtml

## themes/rainier/templates/main_index.mtml

## themes/rainier/templates/monthly_archive_dropdown.mtml

## themes/rainier/templates/monthly_archive_list.mtml

## themes/rainier/templates/monthly_entry_listing.mtml

## themes/rainier/templates/navigation.mtml

## themes/rainier/templates/page.mtml
	'Last update' => 'Última actualización',

## themes/rainier/templates/pages_list.mtml

## themes/rainier/templates/pagination.mtml

## themes/rainier/templates/recent_comments.mtml
	'__VIEW_COMMENT' => '[_1] en <a href="[_2]" title="comentario completo en: [_3]">[_3]</a>',

## themes/rainier/templates/recent_entries.mtml

## themes/rainier/templates/search.mtml

## themes/rainier/templates/search_results.mtml

## themes/rainier/templates/syndication.mtml

## themes/rainier/templates/tag_cloud.mtml

## themes/rainier/templates/trackbacks.mtml

## themes/rainier/templates/zenback.mtml
	'Please paste Zenback script code here.' => 'Por favor, pegue el código de Zenback aquí.',

## themes/rainier/theme.yaml
	'__DESCRIPTION' => '"Rainier" es un tema para blogs personalizable, basado en el Diseño Web Sensible. Además de ofrecer soporte para múltiples dispositivos, a través de Media Query (CSS), se pueden personalizar los contenidos de navegación, e imágenes, como logos y cabeceras, de forma muy simple.',
	'About Page' => 'Página "Acerca de"',
	'_ABOUT_PAGE_BODY' => '
                 <p>Esta es una página "Acerca de" de ejemplo. (Habitualmente, una página "Acerca de" ofrece información destacable sobre una persona o una organización).</p>
                 <p>Si se utiliza la etiqueta <code>@ABOUT_PAGE</code> en una página web, se añadirá la página "Acerca de" a la lista de navegación tanto en la cabecera como en el pie.</p>',
	'Example page' => 'Página de ejemplo',
	'_SAMPLE_PAGE_BODY' => '
                 <p>Esta es una página "Acerca de" de ejemplo. (Habitualmente, una página "Acerca de" ofrece información destacable sobre una persona o una organización).</p>
                 <p>Si se utiliza la etiqueta <code>@ABOUT_PAGE</code> en una página web, se añadirá la página "Acerca de" a la lista de navegación tanto en la cabecera como en el pie.</p>',
	'Rainier' => 'Rainier',
	'Styles for Rainier' => 'Estilos para Rainier',
	'A collection of styles compatible with Rainier themes.' => 'Una colección de estilos compatible con los temas Rainier.',

## search_templates/comments.tmpl
	'Search for new comments from:' => 'Buscar nuevos comentarios desde:',
	'the beginning' => 'el principio',
	'one week ago' => 'hace una semana',
	'two weeks ago' => 'hace dos semanas',
	'one month ago' => 'hace un mes',
	'two months ago' => 'hace dos meses',
	'three months ago' => 'hace tres meses',
	'four months ago' => 'hace cuatro meses',
	'five months ago' => 'hace cinco meses',
	'six months ago' => 'hace seis meses',
	'one year ago' => 'hace un año',
	'Find new comments' => 'Encontrar nuevos comentarios',
	'Posted in [_1] on [_2]' => 'Publicado en [_1] el [_2]',
	'No results found' => 'No se encontraron resultados',
	'No new comments were found in the specified interval.' => 'No se encontraron nuevos comentarios en el intervalo especificado',
	q{Select the time interval that you'd like to search in, then click 'Find new comments'} => q{Seleccione el intervalo temporal en el que desea buscar, y luego haga clic en 'Buscar nuevos comentarios'},

## search_templates/default.tmpl
	'SEARCH FEED AUTODISCOVERY LINK IS PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'El enlace de autodescubrimiento a la fuente de búsquedas sólo se publicará cuando se halla ejecutado una búsqueda.',
	'Blog Search Results' => 'Resultados de la búsqueda en el blog',
	'Blog search' => 'Buscar en el blog',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM',
	'Search this site' => 'Buscar en este sitio',
	'Match case' => 'Distinguir mayúsculas',
	'SEARCH RESULTS DISPLAY' => 'MOSTRAR RESULTADOS DE LA BÚSQUEDA',
	'Matching entries from [_1]' => 'Entradas coincidentes de [_1]',
	q{Entries from [_1] tagged with '[_2]'} => q{Entradas de [_1] etiquetadas en '[_2]'},
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Publicado <MTIfNonEmpty tag="EntryAuthorDisplayName">por [_1] </MTIfNonEmpty>en [_2]',
	'Showing the first [_1] results.' => 'Mostrando los primeros [_1] resultados.',
	'NO RESULTS FOUND MESSAGE' => 'MENSAJE DE NINGÚN RESULTADO ENCONTRADO',
	q{Entries matching '[_1]'} => q{Entradas coincidentes con '[_1]'},
	q{Entries tagged with '[_1]'} => q{Entradas etiquetadas en '[_1]'},
	q{No pages were found containing '[_1]'.} => q{No se encontraron páginas que contuvieran '[_1]'.},
	'END OF ALPHA SEARCH RESULTS DIV' => 'FIN DE LOS RESULTADOS DE BÚSQUEDA - ALPHA DIV',
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'COMIENZO DE LA BARRA LATERAL BETA PARA MOSTRAR LA INFORMACIÓN DE BÚSQUEDA',
	'SET VARIABLES FOR SEARCH vs TAG information' => 'ESPECIFICAR VARIABLES PARA LA BÚSQUEDA vs información de etiqueta',
	q{If you use an RSS reader, you can subscribe to a feed of all future entries tagged '[_1]'.} => q{Si usa un lector de RSS, puede suscribirse a la fuente de todas las futuras entradas con la etiqueta '[_1]'.},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries matching '[_1]'.} => q{Si usa un lector de RSS, puede suscribirse a la fuente de sindicación de todas las futuras entradas que contengan '[_1]'.},
	'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'INFORMACIÓN DE SUSCRIPCIÓN A LA FUENTE DE BÚSQUEDA/ETIQUETA',
	'Feed Subscription' => 'Suscripción de sindicación',
	'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds',
	'What is this?' => '¿Qué es esto?',
	'TAG LISTING FOR TAG SEARCH ONLY' => 'LISTA DE ETIQUETAS PARA LA BÚSQUEDA DE SOLO ETIQUETAS',
	'Other Tags' => 'Otras etiquetas',
	'END OF PAGE BODY' => 'FIN DEL CUERPO DE LA PÁGINA',
	'END OF CONTAINER' => 'FIN DEL CONTENEDOR',

## search_templates/results_feed_rss2.tmpl
	'Search Results for [_1]' => 'Resultados de la búsqueda sobre [_1]',

## search_templates/results_feed.tmpl

## tmpl/cms/asset_replace.tmpl
	'Upload New Asset' => 'Transferir nuevo fichero multimedia',

## tmpl/cms/asset_upload.tmpl
	'Upload Asset' => 'Transferir fichero multimedia',

## tmpl/cms/backup.tmpl
	'Backup [_1]' => 'Respaldar [_1]',
	'What to Backup' => 'Qué respaldar',
	'This option will backup Users, Roles, Associations, Blogs, Entries, Categories, Templates and Tags.' => 'Esta opción hará copias de seguridad de los Usuarios, Roles, Asociaciones, Blogs, Entradas, Categorías, Plantillas y Etiquetas.',
	'Everything' => 'Todo',
	'Reset' => 'Reiniciar',
	'Choose websites...' => 'Seleccione sitios web...',
	'Archive Format' => 'Formato de archivo',
	'The type of archive format to use.' => 'El tipo de formato de archivo a usar.',
	q{Don't compress} => q{No comprimir},
	'Target File Size' => 'Tamaño del fichero',
	'Approximate file size per backup file.' => 'Tamaño de fichero aproximado para cada fichero de la copia de seguridad.',
	'No size limit' => 'Sin límite de tamaño',
	'Make Backup (b)' => 'Hacer copia (b)',
	'Make Backup' => 'Hacer copia',

## tmpl/cms/cfg_entry.tmpl
	'Compose Settings' => 'Configuración de la composición',
	'Your preferences have been saved.' => 'Se han guardado las preferencias.',
	'Publishing Defaults' => 'Valores predefinidos de publicación',
	'Listing Default' => 'Listado predefinido',
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
	'Specifies the default Post Status when creating a new entry.' => 'Especifica el estado predefinido al crear nuevas entradas.',
	'Unpublished' => 'No publicado',
	'Text Formatting' => 'Formato del texto',
	'Specifies the default Text Formatting option when creating a new entry.' => 'Especifica el formato de texto predeterminado para las entradas nuevas.',
	'Specifies the default Accept Comments setting when creating a new entry.' => 'Indica el valor predefinido para la opción Aceptar comentarios al crear nuevas entradas.',
	'Setting Ignored' => 'Opción ignorada',
	'Note: This option is currently ignored since comments are disabled either blog or system-wide.' => 'Nota: Actualmente, se ignora esta opción ya que los comentarios están desactivados en el blog o en todo el sistema.',
	'Note: This option is currently ignored since comments are disabled either website or system-wide.' => 'Nota: Actualmente, se ignora esta opción ya que los comentarios están desactivados en el sitio web o en todo el sistema.',
	'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Indica el valor predefinido de la opción Aceptar TrackBacks al crear nuevas entradas.',
	'Accept TrackBacks' => 'Aceptar TrackBacks',
	'Note: This option is currently ignored since TrackBacks are disabled either blog or system-wide.' => 'Nota: Actualmente, se ignora esta opción ya que los TrackBacks están desactivados en el blog o en todo el sistema.',
	'Note: This option is currently ignored since TrackBacks are disabled either website or system-wide.' => 'Nota: Actualmente, se ignora esta opción ya que los TrackBacks están desactivados en el sitio web o en todo el sistema.',
	'Entry Fields' => 'Campos de las entradas',
	'_USAGE_ENTRYPREFS' => 'Seleccione el conjunto de campos que se mostrarán en el editor de entradas.',
	'Page Fields' => 'Campos de las páginas',
	'WYSIWYG Editor Setting' => 'Configuración del editor con estilos',
	'Content CSS' => 'Contenido de la hoja de estilo (CSS)',
	'Content CSS will be applied when WYSIWYG editor does support. You can specify CSS file by URL or {{theme_static}} placeholder. Example: {{theme_static}}path/to/cssfile.css' => 'El contenido de la hoja de estilo se aplicará cuando el editor visual lo soporte. Puede especificar un fichero CSS mediante la URL o el marcador {{theme_static}}. Ejemplo: {{theme_static}}ruta/a/fichero.css',
	'Punctuation Replacement Setting' => 'Configuración de reemplazo de puntuación',
	'Replace UTF-8 characters frequently used by word processors with their more common web equivalents.' => 'Reemplace los carácteres UTF-8 más usados por los procesadores de texto por sus equivalentes más comunes en el web.',
	'Punctuation Replacement' => 'Reemplazo de puntuación',
	'No substitution' => 'Sin sustitución',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'Entidades de caracteres (&amp#8221;, &amp#8220;, etc.)',
	q{ASCII equivalents (&quot;, ', ..., -, --)} => q{Equivalentes ASCII (&quot;, ', ..., -, --)},
	'Replace Fields' => 'Reemplazar campos',
	'Image default insertion options' => 'Opciones predefinidas de inserción de imágenes',
	'Use thumbnail' => 'Usar miniatura',
	'width:' => 'ancho:',
	'pixels' => 'píxeles',
	'Alignment' => 'Alineación',
	'Left' => 'Izquierda',
	'Center' => 'Centro',
	'Right' => 'Derecha',
	'Link to popup window' => 'Enlazar a ventana emergente',
	'Link image to full-size version in a popup window.' => 'Enlazar la versión original de la imagen en un popup.',
	'Save changes to these settings (s)' => 'Guardar cambios de estas opciones (s)',
	'The range for Basename Length is 15 to 250.' => 'El rango para la longitud del nombre base es de 15 a 250.',
	'You must set valid default thumbnail width.' => 'Debe indicar un ancho válido por defecto para las miniaturas.',

## tmpl/cms/cfg_feedback.tmpl
	'Feedback Settings' => 'Configuración de respuestas',
	'Spam Settings' => 'Configuración del spam',
	'Automatic Deletion' => 'Borrado automático',
	'Automatically delete spam feedback after the time period shown below.' => 'Transcurrido el periodo de tiempo indicado abajo borra automáticamente las respuestas basura.',
	'Delete Spam After' => 'Borrar spam después',
	'When an item has been reported as spam for this many days, it is automatically deleted.' => 'Cuando un elemento haya estado marcado como spam durante esta cantidad de días, será borrado automáticamente.',
	'days' => 'días',
	'Spam Score Threshold' => 'Puntuación límite de spam',
	'Comments and TrackBacks receive a spam score between -10 (complete spam) and +10 (not spam). Feedback with a score which is lower than the threshold shown above will be reported as spam.' => 'Los comentarios y TrackBacks se puntúan como spam con valores entre -10 (spam total) y +10 (no spam). Las respuestas con una puntuación que sea menor del límite mostrado arriba, se marcarán como spam.',
	'Less Aggressive' => 'Menos agresivo',
	'Decrease' => 'Disminuir',
	'Increase' => 'Aumentar',
	'More Aggressive' => 'Más agresivo',
	q{Apply 'nofollow' to URLs} => q{Aplicar 'nofollow' a las URLs},
	q{If enabled, all URLs in comments and TrackBacks will be assigned a 'nofollow' link relation.} => q{Si está activado, se asignará un atributo 'nofollow' a los enlaces de todas las URLs en los comentarios y en los Trackbacks.},
	q{'nofollow' exception for trusted commenters} => q{Excepción 'nofollow' para los comentaristas de confianza.},
	q{Do not add the 'nofollow' attribute when a comment is submitted by a trusted commenter.} => q{No añade el atributo 'nofollow' cuando la respuesta es enviada por un comentarista de confianza.},
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
	'Comment Display Settings' => 'Configuración de la visualización de comentarios',
	'Comment Order' => 'Orden de los comentarios',
	'Select whether you want comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Seleccione si desea mostrar los comentarios en orden ascendente (antiguos primero) o descendente (recientes primero).',
	'Auto-Link URLs' => 'Autoenlazar URLs',
	'Transform URLs in comment text into HTML links.' => 'Transformar las URLs en enlaces HTML.',
	'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Opción que especifica el formato de texto a utilizar para formatear los comentarios de los visitantes.',
	'CAPTCHA Provider' => 'Proveedor de CAPTCHA',
	'No CAPTCHA provider available' => 'No hay disponible ningún proveedor de CAPTCHA.',
	q{No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed and if the CaptchaSourceImageBase configuration directive points to a valid captcha-source directory within the 'mt-static/images' directory.} => q{No existe ningún proveedor CAPTCHA en este sistema. Por favor, compruebe que Image::Magick esté instalado y que la directiva de configuración CaptchaSourceImageBase apunta a un directorio válido de captcha dentro del directorio 'mt-static/images'.},
	'Use Comment Confirmation Page' => 'Usar página de confirmación de comentarios',
	'Use comment confirmation page' => 'Usar página de confirmación de comentarios',
	q{Each commenter's browser will be redirected to a comment confirmation page after their comment is accepted.} => q{Antes de aceptar un comentario, el navegador de cada comentarista se redirigirá a una página de confirmación de comentarios.},
	'Trackback Settings' => 'Configuración de Trackbacks',
	'Note: TrackBacks are currently disabled at the system level.' => 'Nota: Actualmente, los TrackBacks están desactivados a nivel del sistema.',
	'Accept TrackBacks from any source.' => 'Aceptar TrackBacks de cualquier origen.',
	'TrackBack Policy' => 'Política de TrackBacks',
	'Moderation' => 'Moderación',
	'Hold all TrackBacks for approval before they are published.' => 'Retener los TrackBacks para su aprobación antes de publicarlos.',
	'Specify when Movable Type should notify you of new TrackBacks.' => 'Especifique cuándo Movable Type debe notificar los nuevos TrackBacks.',
	'TrackBack Options' => 'Opciones de TrackBacks',
	'TrackBack Auto-Discovery' => 'Autodescubrimiento de TrackBacks',
	'When auto-discovery is turned on, any external HTML links in new entries will be extracted and the appropriate sites will automatically be sent a TrackBack ping.' => 'Si el auto-descubrimiento está activado, se extraerán los enlaces HTML de las nuevas entradas y automáticamente se enviarán pings de TrackBack a los sitios correspondientes.',
	'Enable External TrackBack Auto-Discovery' => 'Habilitar autodescubrimiento de TrackBacks externos',
	'Setting Notice' => 'Alerta sobre configuración',
	'Note: This option may be affected since outbound pings are constrained system-wide.' => 'Nota: Esta opción podría verse afectada debido a que los pings salientes están restringidos a nivel del sistema.',
	'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Nota: Actualmente, esta opción es ignorada debido a que los pings salientes están desactivados a nivel del sistema.',
	'Enable Internal TrackBack Auto-Discovery' => 'Habilitar autodescubrimiento de TrackBacks internos',

## tmpl/cms/cfg_plugin.tmpl
	'[_1] Plugin Settings' => 'Configuración de la extensión [_1]',
	'Plugin System' => 'Extensiones del sistema',
	'Enable or disable plugin functionality for the entire Movable Type installation.' => 'Activa o desactiva la funcionalidad de las extensiones para toda la instalación de Movable Type.',
	'Disable plugin functionality' => 'Desactivar las funciones de las extensiones',
	'Disable Plugins' => 'Desactivar extensiones',
	'Enable plugin functionality' => 'Activar las funciones de las extensiones',
	'Enable Plugins' => 'Activar extensiones',
	'_PLUGIN_DIRECTORY_URL' => 'http://plugins.movabletype.org/',
	'Find Plugins' => 'Buscar extensiones',
	'Your plugin settings have been saved.' => 'Se guardó la configuración de la extensión.',
	'Your plugin settings have been reset.' => 'Se reinició la configuración de la extensión.',
	q{Your plugins have been reconfigured. Since you're running mod_perl, you must restart your web server for these changes to take effect.} => q{Las extensiones se han reconfigurado. Dado que está ejecuntando mod_perl debe reiniciar el servidor web para que estos cambios tomen efecto.},
	'Your plugins have been reconfigured.' => 'Se reconfiguraron las extensiones.',
	q{Your plugins have been reconfigured. Since you're running mod_perl, you will need to restart your web server for these changes to take effect.} => q{Se reconfiguraron las extensiones. Debido a que está ejecutando mod_perl, deberá reiniciar el servidor web para que estos cambios tengan efecto.},
	'Are you sure you want to reset the settings for this plugin?' => '¿Está seguro de que desea reiniciar la configuración de esta extensión?',
	'Are you sure you want to disable plugins for the entire Movable Type installation?' => '¿Está seguro de que desea desactivar las extensiones en toda la instalación de Movable Type?',
	'Are you sure you want to disable this plugin?' => '¿Está seguro de que desea desactivar esta extensión?',
	'Are you sure you want to enable plugins for the entire Movable Type installation? (This will restore plugin settings that were in place before all plugins were disabled.)' => '¿Está seguro de que desea activar las extensiones para toda la instalación de Movable Type? (Esto restaurará la configuración de las extensiones tal y como estaban cuando se desactivaron).',
	'Are you sure you want to enable this plugin?' => '¿Está seguro de que desea activar esta extensión?',
	'Settings for [_1]' => 'Configuración de [_1]',
	'Failed to Load' => 'Falló al cargar',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be completely functional.' => 'Esta extensión no está actualizada para el soporte de Movable Type [_1]. Por lo tanto, podría no ser completamente funcional.',
	'Plugin error:' => 'Error de la extensión:',
	'Info' => 'Información',
	'Resources' => 'Recursos',
	'Run [_1]' => 'Ejecutar [_1]',
	'Documentation for [_1]' => 'Documentación sobre [_1]',
	'Documentation' => 'Documentación',
	'More about [_1]' => 'Más sobre [_1]',
	'Plugin Home' => 'Web de Extensiones',
	'Author of [_1]' => 'Autor de [_1]',
	'Tag Attributes:' => 'Atributos de etiquetas:',
	'Text Filters' => 'Filtros de texto',
	'Junk Filters:' => 'Filtros de basura:',
	'Reset to Defaults' => 'Reiniciar con los valores predefinidos',
	'No plugins with blog-level configuration settings are installed.' => 'No hay extensiones instaladas con configuración a nivel del sistema.',
	'No plugins with configuration settings are installed.' => 'Ningún plugin que haya sido configurado ha sido instalado.',

## tmpl/cms/cfg_prefs.tmpl
	'Error: Movable Type was not able to create a directory for publishing your [_1]. If you create this directory yourself, grant write permission to the web server.' => 'Error: Movable Type no pudo crear un directorio para publicar el [_1]. Otorgue permisos de escritura para el servidor web si va a crear este directorio usted mismo.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your site directory.' => 'Error: Movable Type no pudo crear un directorio para cachear las plantillas dinámicas. Debe crear un directorio llamado <code>[_1]</code> dentro del directorio del sitio web.',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your site directory.' => 'Error: Movable Type no puede escribir en el directorio de cachés de plantillas. Por favor, compruebe los permisos del directorio <code>[_1]</code> dentro del directorio de su sitio web.',
	'[_1] Settings' => 'Configuración de [_1]',
	'Name your blog. The name can be changed at any time.' => 'El nombre del blog. Puede cambiarlo en cualquier momento.',
	'Enter a description for your blog.' => 'Introduzca una descripción para su blog.',
	'Time Zone' => 'Zona horaria',
	'Select your time zone from the pulldown menu.' => 'Seleccione la zona horaria del menú desplegable.',
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
	'Language' => 'Idioma',
	'If you choose a different language than the default language defined at the system level, you may need to change module names in certain templates to include different global modules.' => 'Si desea un idioma diferente del idioma predefinido a nivel de sistema, deberá cambiar los nombres de los módulos en ciertas plantillas para incluir otros módulos globales.',
	'License' => 'Licencia',
	'Your blog is currently licensed under:' => 'Su blog actualmente tiene la licencia:',
	'Your website is currently licensed under:' => 'Su sitio web actualmente tiene la licencia:',
	'Change license' => 'Cambiar licencia',
	'Remove license' => 'Borrar licencia',
	'Your blog does not have an explicit Creative Commons license.' => 'Su blog no tiene una licencia explícica de Creative Commons.',
	'Your website does not have an explicit Creative Commons license.' => 'Su sitio web no tiene una licencia explícita de Creative Commons.',
	'Select a license' => 'Seleccionar una licencia',
	'Publishing Paths' => 'Rutas de publicación',
	'[_1] URL' => 'URL de [_1]',
	'Use subdomain' => 'Usar subdominio',
	'Warning: Changing the [_1] URL can result in breaking all the links in your [_1].' => 'Aviso: La modificación de la URL de [_1] puede borrar todos los enlaces al [_1].',
	q{The URL of your blog. Exclude the filename (i.e. index.html). End with '/'. Example: http://www.example.com/blog/} => q{La URL del blog. Excluya el nombre del fichero (p.e. index.html). Finalice con '/'. Ejemplo: http://www.ejemplo.com/blog/},
	q{The URL of your website. Exclude the filename (i.e. index.html).  End with '/'. Example: http://www.example.com/} => q{La URL del sitio web. Excluya el nombre del fichero (p.e. index.html). Finalice con '/'. Ejemplo: http://www.ejemplo.com/},
	'[_1] Root' => 'Raíz de [_1]',
	'Use absolute path' => 'Usar ruta absoluta',
	'Warning: Changing the [_1] root requires a complete publish of your [_1].' => 'Aviso: La modificación de la raíz del [_1] requiere una publicación completa del [_1].',
	q{The path where your index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{La ruta de publicación de los ficheros índice. No terminar con '/' o '\'. Ejemplo: /home/mt/public_html/blog o C:\www\public_html\blog},
	q{The path where your index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{La ruta de publicación de los ficheros índice. Se recomienda una ruta absoluta (que en Linux comienza con '/' y en Windows con 'C:\'). No terminar con '/' o '\'. Ejemplo: /home/mt/public_html o C:\www\public_html},
	'Advanced Archive Publishing' => 'Publicación avanzada de archivos',
	'Select this option only if you need to publish your archives outside of your Blog Root.' => 'Seleccione esta opción solo si necesita publicar sus archivos fuera de la raíz de su sitio.',
	'Publish archives outside of [_1] Root' => 'Publicar archivos fuera de la raíz del [_1]',
	'Archive URL' => 'URL de archivos',
	'Warning: Changing the archive URL can result in breaking all links in your [_1].' => 'Aviso: La modificación de la URL de los archivos puede romper los enlaces a su [_1].',
	'The URL of the archives section of your blog. Example: http://www.example.com/blog/archives/' => 'La URL de la sección de archivos de tu blog. Ejemplo: http://www.ejemplo.com/blog/archivos/',
	'The URL of the archives section of your website. Example: http://www.example.com/archives/' => 'La URL de la sección de archivos de su sitio web. Ejemplo: http://www.ejemplo.com/archivos/',
	'Warning: Changing the archive path can result in breaking all links in your [_1].' => 'Aviso: La modificación de la URL de los archivos puede romper los enlaces a su [_1].',
	q{The path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{La ruta de publicación de los ficheros índice de la sección de archivos. No terminar con '/' o '\'. Ejemplo: /home/mt/public_html/blog o C:\www\public_html\blog},
	q{The path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{La ruta de publicación de los ficheros índice de la sección de archivos. Se recomienda una ruta absoluta (que en Linux comienza con '/' y en Windows con 'C:\'. No terminar con '/' o '\'. Ejemplo: /home/mt/public_html o C:\www\public_html},
	'Dynamic Publishing Options' => 'Opciones de la publiación dinámica',
	'Enable dynamic cache' => 'Activar caché dinámica',
	'Enable conditional retrieval' => 'Activar recuperación condicional',
	'Archive Settings' => 'Configuración de archivos',
	q{Enter the archive file extension. This can take the form of 'html', 'shtml', 'php', etc. Note: Do not enter the leading period ('.').} => q{Introduzca la extensión de los archivos. Puede ser 'html', 'shtml', 'php', etc. Nota: No introduzca el punto separador de la extensión ('.').},
	'Preferred Archive' => 'Archivo preferido',
	'Choose archive type' => 'Seleccione un tipo de archivo',
	'No archives are active' => 'No hay archivos activos',
	q{Used to generate URLs (permalinks) for this blog's archived entries. Choose one of the archive types used in this blog's archive templates.} => q{Utilizado para generar las URLs (enlaces permanentes) de las entradas archivadas del blog. Seleccione uno de los tipos de archivos utilizandos en las plantillas de archivos del blog.},
	q{Used to generate URLs (permalinks) for this website's archived entries. Choose one of the archive types used in this website's archive templates.} => q{Utilizado para generar las URLs (enlaces permanentes) de las entradas archivadas del sitio. Seleccione uno de los tipos de archivos utilizandos en las plantillas de archivos del sitio.},
	'Publish With No Entries' => 'Publicar sin entradas',
	'Publish category archive without entries' => 'Publicar archivos de categorías sin entradas',
	'Module Settings' => 'Configuración de módulos',
	'Server Side Includes' => 'Server Side Includes',
	'None (disabled)' => 'Ninguno (deshabilitado)',
	'PHP Includes' => 'Inclusiones PHP',
	'Apache Server-Side Includes' => 'Inclusiones de Apache',
	'Active Server Page Includes' => 'Inclusiones de páginas Active Server',
	'Java Server Page Includes' => 'Inclusiones de páginas Java Server',
	'Module Caching' => 'Caché de módulos',
	'Allow properly configured template modules to be cached to enhance publishing performance.' => 'Permite que los módulos de plantillas configurados como tal se cacheen para mejorar el rendimiento de la publicación.',
	'Revision History' => 'Histórico de revisiones',
	'Note: Revision History is currently disabled at the system level.' => 'Nota: Actualmente, el histórico de revisiones está desactivado a nivel del sistema.',
	'Revision history' => 'Histórico de revisiones',
	'Enable revision history' => 'Activar histórico de revisiones',
	'Number of revisions per entry/page' => 'Número de revisiones por entrada/página',
	'Number of revisions per template' => 'Número de revisiones por plantilla',
	'Upload' => 'Subir',
	'Upload Destination' => 'Destino de las transferencias',
	'Allow to change at upload' => 'Permitir cambiar al transferir',
	'Rename filename' => 'Renombrar fichero',
	'Rename non-ascii filename automatically' => 'Renombrar automáticamente nombres de ficheros que no sean ASCII.',
	'Operation if a file exists' => 'Acción si existe un fichero',
	'Upload and rename' => 'Transferir y renombrar',
	'Overwrite existing file' => 'Reescribir fichero existente',
	'Cancel upload' => 'Cancelar transferencia',
	'Normalize orientation' => 'Normalizar orientación',
	'Enable orientation normalization' => 'Activiar la normalización de la orientación',
	'You must set your Blog Name.' => 'Debe configurar el nombre del blog.',
	'You did not select a time zone.' => 'No seleccionó una zona horaria.',
	'You must set a valid URL.' => 'Debe indicar una URL válida.',
	'You must set your Local file Path.' => 'Debe indicar la ruta local de ficheros.',
	'You must set a valid Local file Path.' => 'Debe indicar una ruta local de ficheros válida.',
	'Website root must be under [_1]' => 'La raíz del sitio web debe estar bajo [_1]',
	'Blog root must be under [_1]' => 'La raíz del blog debe estar bajo [_1]',
	'You must set a valid Archive URL.' => 'Debe indicar una URL de archivos válida.',
	'You must set your Local Archive Path.' => 'Debe introducir la Ruta Local de Archivos.',
	'You must set a valid Local Archive Path.' => 'Debe indicar una ruta local de archivos válida.',

## tmpl/cms/cfg_registration.tmpl
	'Registration Settings' => 'Configuración de registro',
	'Your blog preferences have been saved.' => 'Las preferencias de su weblog han sido guardadas.',
	'Your website preferences have been saved.' => 'Las preferencias de su sitio web han sido guardadas.',
	'User Registration' => 'Registro de usuarios',
	'Allow registration for this website.' => 'Permitir el registro en este sitio web.',
	'Registration Not Enabled' => 'Registro no activado',
	'Note: Registration is currently disabled at the system level.' => 'Nota: Actualmente el regisro está desactivado a nivel del sistema.',
	'Allow visitors to register as members of this website using one of the Authentication Methods selected below.' => 'Permitir a los visitantes registrarse como miembros del sitio web usando uno de los métodos de autentificación seleccionados debajo.',
	'New Created User' => 'Usuario de nueva creación',
	'Select a role that you want assigned to users that are created in the future.' => 'Seleccione el rol que desea asignar a los usuarios que se creen en el futuro.',
	'(No role selected)' => '(Sin rol seleccionado',
	'Select roles' => 'Seleccionar roles',
	'Authentication Methods' => 'Métodos de autentificación',
	'Please select authentication methods to accept comments.' => 'Por favor, seleccione los métodos de autentificación para aceptar comentarios.',
	'One or more Perl modules may be missing to use this authentication method.' => 'Uno o más módulos de Perl podrían no estar instalados y ser necesarios para usar este método de autentificación.',

## tmpl/cms/cfg_system_general.tmpl
	'Your settings have been saved.' => 'Configuración guardada.',
	'Imager does not support ImageQualityPng.' => 'El gestor de imágenes no soporta ImageQualityPng.',
	'A test mail was sent.' => 'Se envió un correo de prueba.',
	'One or more of your websites or blogs are not following the base site path (value of BaseSitePath) restriction.' => 'Uno o más de sus sitios web o blogs no siguen la restricción de la ruta base (valor de BaseSitePath).',
	'(None selected)' => '(Ninguno seleccionado)',
	'System Email Address' => 'Dirección de correo del sistema',
	'Send Test Mail' => 'Enviar correo de prueba',
	q{This email address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events.} => q{Esta dirección de correo se utiliza en la cabecera 'From:' de los correos enviados por Movable Type. Se puede enviar correo por recuperación de contraseña, registro de comentaristas, notificación de nuevos comentarios y TrackBacks, bloqueo de usuarios o IPs, y por otros eventos menores.},
	'Debug Mode' => 'Modo de depuración',
	'Values other than zero provide additional diagnostic information for troubleshooting problems with your Movable Type installation.  More information is available in the <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">Debug Mode documentation</a>.' => 'Valores distintos a cero proveen información adicional de diagnóstico para la resolución de problemas en la instalación de Movable Type. Dispone de más información en la <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">documentación del modo de depuración</a>.',
	'Performance Logging' => 'Histórico de rendimiento',
	'Turn on performance logging, which will report any system event that takes the number of seconds specified by Logging Threshold.' => 'Active el registro de rendimiento, que informará sobre cualquier evento del sistema que tome el número de segundos especificados por la Umbral de registro.',
	'Turn on performance logging' => 'Activar registro de rendimiento',
	'Log Path' => 'Ruta de históricos',
	'The filesystem directory where performance logs are written.  The web server must have write permission in this directory.' => 'El directorio del sistema de ficheros donde se escriben los históricos de rendimiento. El servidor web debe poder escribir en este directorio.',
	'Logging Threshold' => 'Umbral de histórico',
	'The time limit for unlogged events in seconds. Any event that takes this amount of time or longer will be reported.' => 'El tiempo límite para los eventos no registrados, en segundos. Se informará de cualquier evento que tome esta cantidad de tiempo o mayor.',
	'Enable this setting to have Movable Type track revisions made by users to entries, pages and templates.' => 'Activar esta configuración para seguir las revisiones realizadas por los usuarios en las entradas, páginas y plantillas.',
	'Track revision history' => 'Seguir histórico de revisiones',
	'Site Path Limitation' => 'Limitación de la ruta del sitio',
	'Base Site Path' => 'Ruta base del sitio',
	'Allow sites to be placed only under this directory' => 'Permite poner a los sitios sólo bajo este directorio',
	'System-wide Feedback Controls' => 'Controles de las respuestas a nivel del sistema',
	'Prohibit Comments' => 'Prohibir comentarios',
	'This will override all individual blog settings.' => 'Esto va borrar los parámetros de todos los blogs individuales',
	'Disable comments for all websites and blogs.' => 'Desactivar los comentarios para todos los sitios y blogs.',
	'Prohibit TrackBacks' => 'Prohibir TrackBacks',
	'Disable receipt of TrackBacks for all websites and blogs.' => 'Desactivar los TrackBacks entrantes en todos los sitios webs y blogs.',
	'Outbound Notifications' => 'Notificaciones salientes',
	'Prohibit Notification Pings' => 'Prohibir los pings de notificación',
	'Disable sending notification pings when a new entry is created in any blog on the system.' => 'Desactivar el envío de pings de notificación cuando se crean nuevas entradas en cualquier blog del sistema.',
	'Disable notification pings for all websites and blogs.' => 'Desactivar los pings de notificación en todos los sitios web y blogs.',
	'Send Outbound TrackBacks to' => 'Enviar TrackBacks salientes a',
	'Do not send outbound TrackBacks or use TrackBack auto-discovery if your installation is intended to be private.' => 'No enviar TrackBacks salientes ni usar el autodescubrimiento de TrackBacks si predente que la instalación sea privada.',
	'(No Outbound TrackBacks)' => '(Ningún Trackback saliente)',
	'Only to websites on the following domains:' => 'Solo a los sitios web en los siguientes dominios:',
	'Lockout Settings' => 'Configuración de bloqueos',
	q{The system administrators whom you wish to notify if a user or an IP address is locked out.  If no administrators are selected, notifications will be sent to the 'System Email' address.} => q{Los administradores del sistema a quienes desee notificar los bloqueos de usuarios y direcciones IP. Si no hay administradores seleccionados, se enviarán las notificaciones a la dirección del 'Correo del sistema'.},
	'Clear' => 'Limpiar',
	'Select' => 'Seleccionar',
	'User lockout policy' => 'Política de bloqueo de usuarios',
	'A Movable Type user will be locked out if he or she submits an incorrect password [_1] or more times within [_2] seconds.' => 'Si el usuario envía una clave incorrecta [_1] o más veces en menos de [_2] segundos, se bloqueará al usuario de Movable Type.',
	'IP address lockout policy' => 'Política de bloqueo de direcciones IP.',
	'An IP address will be locked out if [_1] or more incorrect login attempts are made within [_2] seconds from the same IP address.' => 'Si se realizzan [_1] o más intentos de inicio de sesión en menos de [_2] segundos desde la misma dirección IP, se bloqueará la dirección IP.',
	q{However, the following IP addresses are 'whitelisted' and will never be locked out:} => q{Sin embargo, las siguientes direcciones IP están en una 'lista blanca' y nunca serán bloqueadas:},
	'The list of IP addresses. If a remote IP address is included in this list, the failed login will not recorded. You can specify multiple IP addresses separated by commas or line breaks.' => 'La lista de direcciones IP. El inicio de sesión no será registrado si la dirección IP remota está incluída en esta lista. Puede especificar múltiples direcciones IP separadas por comas o saltos de línea.',
	'Image Quality Settings' => 'Configuración de la calidad de las imágenes',
	'Changing image quality' => 'Cambiando la calidad de la imagen', # Translate - New
	'Enable image quality changing.' => 'Activar cambio de calidad de imágenes.', # Translate - New
	'Image quality(JPEG)' => 'Calidad de imagen (JPEG)',
	'Image quality of uploaded JPEG image and its thumbnail. This value can be set an integer value between 0 and 100. Default value is 75.' => 'La calidad de las imágenes JPEG y sus miniaturas. Este valor puede ser un entero entre 0 y 100. El valor por defecto es 75.',
	'Image quality(PNG)' => 'Calidad de imagen (PNG)',
	'Image quality of uploaded PNG image and its thumbnail. This value can be set an integer value between 0 and 9. Default value is 7.' => 'La calidad de las imágenes PNG y sus miniaturas. Este valor puede ser un entero entre 0 y 9. El valor por defecto es 7.',
	'Send Mail To' => 'Enviar correo a',
	'The email address that should receive a test email from Movable Type.' => 'La direción de correo que debe recibir el correo de prueba de Movable Type.',
	'Send' => 'Enviar',
	'You must set a valid absolute Path.' => 'Debe indicar una ruta absoluta válida.',
	'You must set an integer value between 0 and 100.' => 'Debe indicar un valor entero entre 0 y 100.',
	'You must set an integer value between 0 and 9.' => 'Debe indicar un valor entero entre 0 y 9.',

## tmpl/cms/cfg_system_users.tmpl
	'User Settings' => 'Configuración de usuarios',
	'(No website selected)' => '(Ningún sitio web seleccionado)',
	'Select website' => 'Seleccione un sitio web',
	'Allow Registration' => 'Permitir registro',
	'Select a system administrator you wish to notify when commenters successfully registered themselves.' => 'Seleccione un administrar del sistema a quien desee que se le remitan notificaciones cuando los comentaristas se registren.',
	'Allow commenters to register on this system.' => 'Permitir a los comentaristas registrarse en el sistema.',
	'Notify the following system administrators when a commenter registers:' => 'Notificar a los siguientes administradores del sistema el registro de comentaristas:',
	'Select system administrators' => 'Seleccione los administradores de sistemas',
	'Note: System Email Address is not set in System > General Settings. Emails will not be sent.' => 'Nota: La dirección de correo del sistema no está configurada en Sistema > Configuración general. Los mensajes no se enviarán.',
	'Password Validation' => 'Comprobación de clave',
	'Options' => 'Opciones',
	'Should contain uppercase and lowercase letters.' => 'Debe contener letras en mayúsculas y minúsculas.',
	'Should contain letters and numbers.' => 'Debe contener letras y números.',
	'Should contain special characters.' => 'Debe contener caracteres especiales.',
	'Minimun Length' => 'Longitud mínima',
	'This field must be a positive integer.' => 'Este campo debe ser un positivo entero.',
	'New User Defaults' => 'Valores predefinidos para los nuevos usuarios',
	'Personal Blog' => 'Blog Personal',
	'Have the system automatically create a new personal blog when a user is created. The user will be granted the blog administrator role on this blog.' => 'Hace que el sistema cree automáticamente un blog personal al crear un nuevo usuario. El usuario obtendrá el rol de administrador en ese blog.',
	'Automatically create a new blog for each new user.' => 'Crear automáticamente un nuevo blog para cada nuevo usuario.',
	'Personal Blog Location' => 'Ruta del blog personal',
	'Select a website you wish to use as the location of new personal blogs.' => 'Seleccione el sitio web que desea usar como lugar de los nuevos blogs personales.',
	'Change website' => 'Cambiar sitio web',
	'Personal Blog Theme' => 'Tema del blog personal',
	'Select the theme that should be used for new personal blogs.' => 'Seleccione el tema que deberá usarse para los nuevos blogs personales.',
	'(No theme selected)' => '(Ningún tema seleccionado)',
	'Change theme' => 'Cambiar tema',
	'Select theme' => 'Seleccionar tema',
	'Default User Language' => 'Idioma del usuario',
	'Choose the default language to apply to all new users.' => 'Seleccione el idioma predefinido para aplicar en los nuevos usuarios.',
	'Default Time Zone' => 'Zona horaria predefinida',
	'Default Tag Delimiter' => 'Delimitador de etiquetas predefinido',
	'Define the default delimiter for entering tags.' => 'Seleccione el separador predefinido al introducir etiquetas.',
	'Comma' => 'Coma',
	'Space' => 'Espacio',

## tmpl/cms/cfg_web_services.tmpl
	'Web Services Settings' => 'Configuración de los servicios web',
	'Data API Settings' => 'Configuración de Data API',
	'Data API' => 'Data API',
	'Enable Data API in this site.' => 'Activar Data API en este sitio.',
	'Enable Data API in system scope.' => 'Activar Data API en todo el sistema.',
	'External Notifications' => 'Notificaciones externas',
	'Notify ping services of website updates' => 'Notifique las actualizaciones del sitio web a los servicios de ping',
	'When this website is updated, Movable Type will automatically notify the selected sites.' => 'Cuando se actualice el sitio web, Movable Type notificará automáticamente a los servicios seleccionados.',
	'Note: This option is currently ignored because outbound notification pings are disabled system-wide.' => 'Nota: Actualmente se ignora esta opción debido a que los pings de notificación salientes están desactivados a nivel del sistema.',
	'Others:' => 'Otros:',
	'(Separate URLs with a carriage return.)' => '(Separe las URLs con un retorno de carro.)',

## tmpl/cms/dashboard.tmpl
	'Dashboard' => 'Panel de Control',
	'System Overview' => 'Resumen del sistema',
	'Select a Widget...' => 'Seleccione un widget...',
	'Add' => 'Crear',
	'Your Dashboard has been updated.' => 'Se ha actualizado el Panel de Control.',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Confirm Publishing Configuration' => 'Confirmar configuración de publicación',
	'Site Path' => 'Ruta del sitio',
	'Parent Website' => 'Sitio web padre',
	'Please choose parent website.' => 'Por favor, seleccione el sitio web padre',
	q{Enter the new URL of your public blog. End with '/'. Example: http://www.example.com/blog/} => q{Introduzca la URL para el blog público. Terminar con '/'. Ejemplo: http://www.ejemplo.com/blog/},
	q{Enter the new path where your main index file will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Introduzca la ruta de localización del fichero índice principal. No terminar con '/' o '\'. Ejemplo: /home/mt/public_html/blog/ o C:\www\public_html\blog},
	q{Enter the new path where your main index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Introduzca la ruta de localización del fichero índice principal. Se recomienda una ruta absoluta (que en Linux comienza con '\' y en Windows con 'C:\'). No terminar con '/' o '\'. Ejemplo: /home/mt/public_html/blog/ o C:\www\public_html\blog},
	'Enter the new URL of the archives section of your blog. Example: http://www.example.com/blog/archives/' => 'Introduzca la nueva URL de la sección de archivos del blog. Ejemplo: http://www.ejemplo.com/blog/archivos/',
	q{Enter the new path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Introduzca la ruta de localización de los ficheros índice de la sección de archivos. No terminar con '/' o '\'. Ejemplo: /home/mt/public_html/blog/ o C:\www\public_html\blog},
	q{Enter the new path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Introduzca la ruta de localización de los ficheros índice de la sección de archivos. Se recomienda una ruta absoluta (que en Linux comienza con '\' y en Windows con 'C:\'). No terminar con '/' o '\'. Ejemplo: /home/mt/public_html/blog/ o C:\www\public_html\blog},
	'Continue (s)' => 'Continuar (s)',
	'Back (b)' => 'Volver (b)',
	'You must set a valid Site URL.' => 'Debe establecer una URL de sitio válida.',
	'You must set a valid local site path.' => 'Debe establecer una ruta local de sitio válida.',
	'You must select a parent website.' => 'Debe indicar un sitio web padre.',

## tmpl/cms/dialog/asset_edit.tmpl
	'Your edited image has been saved.' => 'La imagen editada ha sido guardada.',
	'Metadata cannot be updated because Metadata in this image seems to be broken.' => 'No se pudo actualizar los metadatos por que esta imagen parece estar rota.',
	'Error creating thumbnail file.' => 'Error creando el fichero de la miniatura.',
	'File Size' => 'Tamaño de la imagen',
	'Edit Image' => 'Editar imagen',
	'Save changes to this asset (s)' => 'Guardar cambios de este fichero multimedia (s)',
	'Close (x)' => 'Cerrar (x)',
	'Your changes have been saved.' => 'Sus cambios han sido guardados.',
	'An error occurred.' => 'Ocurrió un error.',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to edit image?' => 'Los cambios no guardados a este fichero multimedia se perderán. ¿Está seguro de que desea editar la imagen?',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to close this dialog?' => 'Los cambios no guardados a este fichero multimedia se perderán. ¿Estará seguro de que desea cerrar este diálogo?',

## tmpl/cms/dialog/asset_insert.tmpl

## tmpl/cms/dialog/asset_modal.tmpl
	'Library' => 'Biblioteca',
	'Next (s)' => 'Siguiente (s)',
	'Insert (s)' => 'Insertar (s)',
	'Insert' => 'Insertar',
	'Cancel (x)' => 'Cancelar (x)',

## tmpl/cms/dialog/asset_options.tmpl
	'File Options' => 'Opciones de ficheros',
	'Create entry using this uploaded file' => 'Crear entrada utilizando el fichero transferido',
	'Create a new entry using this uploaded file.' => 'Crear una nueva entrada usando el fichero transferido.',
	'Finish (s)' => 'Finalizar (s)',
	'Finish' => 'Finalizar',

## tmpl/cms/dialog/asset_replace.tmpl

## tmpl/cms/dialog/asset_upload.tmpl
	'You need to configure your blog.' => 'Debe configurar el blog.',
	'Your blog has not been published.' => 'Su blog no ha sido publicado.',

## tmpl/cms/dialog/clone_blog.tmpl
	'Blog Details' => 'Detalles del blog',
	'This is set to the same URL as the original blog.' => 'Esto será la misma URL del blog original.',
	'This will overwrite the original blog.' => 'Esto sobreescribirá el blog original.',
	'Exclusions' => 'Exclusiones',
	'Exclude Entries/Pages' => 'Excluir entradas/páginas',
	'Exclude Comments' => 'Excluir comentarios',
	'Exclude Trackbacks' => 'Excluir trackbacks',
	'Exclude Categories/Folders' => 'Excluir categorías/carpetas',
	'Clone' => 'Clonar',
	'Publish archives outside of Blog Root' => 'Publicar archivos fuera de la raíz del sitio.',
	'Warning: Changing the archive URL can result in breaking all links in your blog.' => 'Aviso: La modificación de la URL de archivos pueden romper todos los enlaces en el blog.',
	'Warning: Changing the archive path can result in breaking all links in your blog.' => 'Aviso: La modificación de la ruta de los archivos puede romper todos los enlaces en su blog.',
	'Mark the settings that you want cloning to skip' => 'Marque las opciones que desee ignorar en la clonación',
	'Entries/Pages' => 'Entradas/páginas',
	'Categories/Folders' => 'Categorías/carpetas',
	'Confirm' => 'Confirmar',

## tmpl/cms/dialog/comment_reply.tmpl
	'On [_1], [_2] commented on [_3]' => 'En [_1], [_2] comentó en [_3]',
	'Your reply:' => 'Su respuesta:',
	'Submit reply (s)' => 'Enviar respuesta (s)',

## tmpl/cms/dialog/create_association.tmpl
	'No roles exist in this installation. [_1]Create a role</a>' => 'Ningún rol existe en esta instalación. [_1]Crear un rol</a>',
	'No groups exist in this installation. [_1]Create a group</a>' => 'Ningún grupo existe en esta instalación. [_1]Crear un grupo</a>',
	'No users exist in this installation. [_1]Create a user</a>' => 'Ningún usuario existe en esta instalación. [_1]Crear un usuario</a>',
	'No blogs exist in this installation. [_1]Create a blog</a>' => 'Ningún blog existe en esta instalación. [_1]Crear un blog</a>',

## tmpl/cms/dialog/edit_image.tmpl
	'W:' => 'An:',
	'H:' => 'Al:',
	'Apply' => 'Aplicar',
	'Keep aspect ratio' => 'Mantener proporción',
	'Remove All metadata' => 'Borrar metadatos',
	'Remove GPS metadata' => 'Borrar datos GPS',
	'Rotate right' => 'Rotar izquierda',
	'Rotate left' => 'Rotar derecha',
	'Flip horizontal' => 'Reflejar horizontal',
	'Flip vertical' => 'Reflejar vertical',
	'Crop' => 'Recortar',
	'Undo' => 'Deshacer',
	'Redo' => 'Rehacer',
	'Save (s)' => 'Guardar (s)',
	'You have unsaved changes to this image that will be lost. Are you sure you want to close this dialog?' => 'Los cambios no guardados de esta imagen se perderán. ¿Está seguro de que desea cerrar este diálogo?',

## tmpl/cms/dialog/entry_notify.tmpl
	'Send a Notification' => 'Enviar una notificación',
	'You must specify at least one recipient.' => 'Debe especificar al menos un destinatario.',
	q{Your [_1]'s name, title, and a link to view it will be sent in the notification. Additionally, you can add a message, include an excerpt and/or send the entire body.} => q{En la notificación se enviará el nombre de su [_1], el título y un enlace para verla. Además, puede añadir un mensaje, incluir el resumen y/o enviar el cuerpo completo.},
	'Recipients' => 'Destinatarios',
	'Enter email addresses on separate lines or separated by commas.' => 'Introduzca las direcciones de correo en líneas separadas o separadas por comas.',
	'All addresses from Address Book' => 'Todas las direcciones de la agenda',
	'Optional Message' => 'Mensaje opcional',
	'Optional Content' => 'Contenido opcional',
	'(Body will be sent without any text formatting applied.)' => '(El cuerpo se enviará sin que se aplique ningún formato de texto).',
	'Send notification (s)' => 'Enviar notificación (s)',

## tmpl/cms/dialog/list_revision.tmpl
	'Select the revision to populate the values of the Edit screen.' => 'Seleccione la revisión para poblar los valores en la plantalla de Edición.',

## tmpl/cms/dialog/move_blogs.tmpl
	'Warning: You need to copy uploaded assets to the new path manually. It is also recommended not to delete files in the old path to avoid broken links.' => 'Aviso: Deberá copiar manualmente los ficheros multimedia subidos a la nueva ruta. También es recomendable que no borre los ficheros en la ruta antigua para evitar romper enlaces.',

## tmpl/cms/dialog/multi_asset_options.tmpl
	'Insert Options' => 'Configuración de inserción',
	'Display [_1] in entry/page' => 'Mostrar [_1] en la entrada/página',

## tmpl/cms/dialog/new_password.tmpl
	'Change Password' => 'Cambiar Contraseña',
	'Enter the new password.' => 'Introduzca la nueva contraseña.',
	'New Password' => 'Nueva contraseña',
	'Confirm New Password' => 'Confirmar nueva contraseña',
	'Change' => 'cambiar',

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
	'This new publishing profile will update your publishing settings.' => 'Este nuevo perfil de publicación actualizará la configuración de publicación.',
	'Are you sure you wish to continue?' => '¿Está seguro de que desea continuar?',

## tmpl/cms/dialog/recover.tmpl
	'Reset Password' => 'Reiniciar la contraseña',
	'The email address provided is not unique.  Please enter your username.' => 'El correo no es único. Por favor, introduzca el usuario.',
	'Back (x)' => 'Volver (x)',
	'Sign in to Movable Type (s)' => 'Identifíquese en Movable Type (s)',
	'Sign in to Movable Type' => 'Identifíquese en Movable Type',
	'Reset (s)' => 'Reiniciar (s)',

## tmpl/cms/dialog/refresh_templates.tmpl
	'Refresh Global Templates' => 'Recargar plantillas globales',
	'Cannot find template set. Please apply [_1]theme[_2] to refresh your templates.' => 'No se pudo encontrar el conjunto de plantillas. Por favor, aplique un [_1]tema[_2] para refrescar las plantillas.',
	'Revert modifications of theme templates' => 'Deshacer modificaciones en las plantillas de los temas',
	'Reset to theme defaults' => 'Reiniciar a los valores predefinidos del tema',
	q{Deletes all existing templates and install the selected theme's default.} => q{Borra todas las plantillas existentes e instala las predefinidas por el tema seleccionado.},
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

## tmpl/cms/dialog/restore_end.tmpl
	'An error occurred during the restore process: [_1] Please check your restore file.' => 'Ocurrió un error durante el proceso de restauración: [_1] Por favor, compruebe el fichero de restauración.',
	'View Activity Log (v)' => 'Mostrar registro de actividad (v)',
	'All data restored successfully!' => '¡Se restauraron todos los datos correctamente!',
	'Close (s)' => 'Cerrado (s)',
	'Next Page' => 'Página siguiente',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => 'La página le redireccionará a una nueva en 3 segundos. [_1]Parar la redirección.[_2]',

## tmpl/cms/dialog/restore_start.tmpl
	'Restoring...' => 'Restaurando...',

## tmpl/cms/dialog/restore_upload.tmpl
	'Restore: Multiple Files' => 'Restaurar: Múltiples ficheros',
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => 'La cancelación del proceso creará objetos huérfanos. ¿Está seguro de que desea cancelar la operación de restauración?',
	'Please upload the file [_1]' => 'Por favor, suba el fichero [_1]',

## tmpl/cms/dialog/select_association_type.tmpl
	'Grant website permission to user' => 'Conceder permiso de sitio web al usuario',
	'Grant blog permission to user' => 'Conceder permiso de blog al usuario',
	'Grant website permission to group' => 'Conceder permiso de grupo al usuario',
	'Grant blog permission to group' => 'Conceder permiso de blog al grupo',

## tmpl/cms/dialog/select_theme.tmpl
	'Select Personal blog theme' => 'Seleccione un tema para el blog personal',

## tmpl/cms/dialog/theme_element_detail.tmpl

## tmpl/cms/edit_asset.tmpl
	'Edit Asset' => 'Editar multimedia',
	'Stats' => 'Estadísticas',
	'[_1] - Created by [_2]' => '[_1] - Creado por [_2]',
	'[_1] - Modified by [_2]' => '[_1] - Modificado por [_2]',
	'Appears in...' => 'Aparece en...',
	'This asset has been used by other users.' => 'Este fichero multimedia ha sido utilizado por otros usuarios.',
	'Related Assets' => 'Ficheros multimedia relacionados',
	'[_1] is missing' => '[_1] no existe',
	'Embed Asset' => 'Embeber fichero multimedia',
	'You must specify a name for the asset.' => 'Debe especificar un nombre para el fichero multimedia.',
	'You have unsaved changes to this asset that will be lost.' => 'Los cambios no guardados a este fichero multimedia se perderán.',

## tmpl/cms/edit_author.tmpl
	'Edit Profile' => 'Editar Perfil',
	'This profile has been updated.' => 'Este perfil ha sido actualizado.',
	'A new password has been generated and sent to the email address [_1].' => 'Se ha generado y enviado a la dirección de correo electrónico [_1] una nueva contraseña.',
	'This profile has been unlocked.' => 'Este perfil ha sido desbloqueado.',
	'This user was classified as pending.' => 'Este usuario está clasificado como pendiente.',
	'This user was classified as disabled.' => 'Este usuario está clasificado como deshabilitado.',
	'This user was locked out.' => 'Este usuario ha sido bloqueado.',
	q{If you want to unlock this user click the 'Unlock' link. <a href="[_1]">Unlock</a>} => q{Si desea desbloquear a este usuario, haga clic en el enlace 'Desbloquear'. <a href="[_1]">Desbloquear</a>},
	'User properties' => 'Propiedades del usuario',
	'Your web services password is currently' => 'Actualmente la contraseña de los servicios web es',
	'_WARNING_PASSWORD_RESET_SINGLE' => 'Va a reiniciar la contraseña de "[_1]". Se enviará una nueva contraseña aleatoria que se enviará directamente a su dirección de correo electrónico ([_2]). ¿Desea continuar?',
	'Error occurred while removing userpic.' => 'Ocurrió un error durante la eliminación del avatar.',
	'_USER_STATUS_CAPTION' => 'Estado',
	'Status of user in the system. Disabling a user prevents that person from using the system but preserves their content and history.' => 'Estado del usuario en el sistema. La desactivación de un usuario impide que utilice el sistema pero mantiene sus contenidos e históricos.',
	'_USER_ENABLED' => 'Habilitado',
	'_USER_PENDING' => 'Pendiente',
	'_USER_DISABLED' => 'Deshabilitado',
	'The username used to login.' => 'El nombre de usuario utilizado para la identificación en el sistema.',
	'External user ID' => 'ID usuario externo',
	'The name displayed when content from this user is published.' => 'El nombre mostrado cuando se publica contenidos de este usuario.',
	'The email address associated with this user.' => 'La dirección de correo asociada a este usuario.',
	q{This User's website (e.g. http://www.movabletype.com/).  If the Website URL and Display Name fields are both populated, Movable Type will by default publish entries and comments with bylines linked to this URL.} => q{El sitio web del usuario (p.e. http://www.movabletype.com/).  Si la URL del sitio web y el Nombre público tienen valor, Movable Type publicará por defecto las entradas y comentarios con enlaces a esta URL.},
	'The image associated with this user.' => 'La imagen asociada al usuario.',
	'Select Userpic' => 'Seleccionar avatar',
	'Remove Userpic' => 'Borrar avatar',
	'Current Password' => 'Contraseña actual',
	'Existing password required to create a new password.' => 'La contraseña actual es necesaria para crear una nueva.',
	'Initial Password' => 'Contraseña inicial',
	'Enter preferred password.' => 'Introduzca la contraseña elegida.',
	'Confirm Password' => 'Confirmar contraseña',
	'Repeat the password for confirmation.' => 'Repita la contraseña para confirmación.',
	'Password recovery word/phrase' => 'Palabra/frase para la recuperación de contraseña',
	'This word or phrase is not used in the password recovery.' => 'Esta palabra o frase no se usa en la recuperación de la contraseña.',
	'Preferences' => 'Preferencias',
	'Display language for the Movable Type interface.' => 'Idioma para el interfaz de Movable Type.',
	'Text Format' => 'Formato de texto',
	'Default text formatting filter when creating new entries and new pages.' => 'Filtro predefinido para el formato de texto de las nuevas entradas y páginas.',
	'(Use Website/Blog Default)' => '(Usar sitio web/blog predefinido)',
	'Date Format' => 'Formato de fechas',
	'Default date formatting in the Movable Type interface.' => 'El formato predefinido de fechas en Movable Type.',
	'Relative' => 'Relativo',
	'Full' => 'Completo',
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

## tmpl/cms/edit_blog.tmpl
	'Create Blog' => 'Crear blog',
	'Your blog configuration has been saved.' => 'Se ha guardado la configuración de su blog.',
	'Blog Theme' => 'Tema del blog',
	'Select the theme you wish to use for this blog.' => 'Seleccione el tema que desea usar en este blog.',
	'Name your blog. The blog name can be changed at any time.' => 'Nombre del blog. Se puede modificar en cualquier momento.',
	'Enter the URL of your Blog. Exclude the filename (i.e. index.html). Example: http://www.example.com/blog/' => 'Introduzca la URL del blog. No incluya el nombre del fichero (p.e. index.html) Ejemplo: http://www.ejemplo.com/blog/',
	q{The path where your index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{La ruta de localización de los ficheros índice. Se recomienda una ruta absolut (que en Linux comienza con '/' y en Windows con 'C:\'). No terminar con '/' o '\'. Ejemplo: /home/mt/public_html/blog o C:\www\public_html\blog},
	q{The path where your index files will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{La ruta de localización de los ficheros índice. No terminar con '/' o '\'. Ejemplo: /home/mt/public_html/blog o C:\www\public_html\blog},
	'Select your timezone from the pulldown menu.' => 'Seleccione su zona horaria en el menú desplegable.',
	'Create Blog (s)' => 'Crear blog (s)',
	'You must set your Local Site Path.' => 'Debe definir la ruta local de su sitio.',

## tmpl/cms/edit_category.tmpl
	'Edit Category' => 'Editar categoría',
	'Useful links' => 'Enlaces útiles',
	'Manage entries in this category' => 'Administrar las entradas de esta categorías',
	'You must specify a label for the category.' => 'Debe especificar un título para la categoría.',
	'You must specify a basename for the category.' => 'Debe especificar un nombre base para la categoría.',
	'Please enter a valid basename.' => 'Por favor, introduzca un nombre base válido.',
	'_CATEGORY_BASENAME' => 'Nombre base',
	'This is the basename assigned to your category.' => 'El nombre base asignado a la categoría.',
	q{Warning: Changing this category's basename may break inbound links.} => q{Cuidado: Cambiar el nombre base de la categoría podría romper los enlaces entrantes.},
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

## tmpl/cms/edit_commenter.tmpl
	'Commenter Details' => 'Detalles del comentarista',
	'The commenter has been trusted.' => 'El comentarista ahora es de confianza.',
	'The commenter has been banned.' => 'Se bloqueó al comentarista.',
	'Comments from [_1]' => 'Comentarios de [_1]',
	'commenter' => 'comentarista',
	'commenters' => 'comentaristas',
	'to act upon' => 'actuar cuando',
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
	'Identity' => 'Identidad',
	'The Identity of the commenter' => 'La identidad del comentarista',
	'View' => 'Ver',
	'The Email Address of the commenter' => 'La dirección de correo del comentarista',
	'Withheld' => 'Retener',
	'View all comments with this email address' => 'Ver todos los comentarios de esta dirección de correo-e',
	'The Website URL of the commenter' => 'URL del sitio del comentarista',
	'The trusted status of the commenter' => 'El estado de la confianza en el comentarista',
	'Trusted' => 'De confianza',
	'Authenticated' => 'Autentificado',

## tmpl/cms/edit_comment.tmpl
	'The comment has been approved.' => 'Se ha aprobado el comentario.',
	'This comment was classified as spam.' => 'Se ha clasificado el comentario como basura.',
	'Total Feedback Rating: [_1]' => 'Puntuación total de respuestas: [_1]',
	'Test' => 'Test',
	'Score' => 'Puntuación',
	'Results' => 'Resultados',
	'Save changes to this comment (s)' => 'Guardar cambios de este comentario (s)',
	'comment' => 'comentario',
	'comments' => 'comentarios',
	'Delete this comment (x)' => 'Borrar este comentario (x)',
	'Manage Comments' => 'Administrar comentarios',
	'_external_link_target' => '_blank',
	'View [_1] comment was left on' => 'Ver comentario de [_1] que se realizó en',
	'Reply to this comment' => 'Responder al comentario',
	'Update the status of this comment' => 'Actualizar el estado del comentario',
	'Reported as Spam' => 'Marcado como spam',
	'View all comments with this status' => 'Ver comentarios con este estado',
	'The name of the person who posted the comment' => 'El nombre de la persona que publicó el comentario',
	'View all comments by this commenter' => 'Ver todos los comentarios de este comentarista',
	'View this commenter detail' => 'Ver detalles de este comentarista',
	'(Trusted)' => '(De confianza)',
	'Untrust Commenter' => 'Comentarista no fiable',
	'Ban Commenter' => 'Bloquear Comentarista',
	'(Banned)' => '(Bloqueado)',
	'Trust Commenter' => 'Comentados Fiable',
	'Unban Commenter' => 'Desbloquear Comentarista',
	'(Pending)' => '(Pendiente)',
	'Email address of commenter' => 'Dirección de correo del comentarista',
	'Unavailable for OpenID user' => 'No disponible para los usuarios de OpenID',
	'Email' => 'Correo electrónico',
	'URL of commenter' => 'URL del comentarista',
	'No url in profile' => 'Sin URL en el perfil',
	'View all comments with this URL' => 'Ver todos los comentarios con esta URL',
	'[_1] this comment was made on' => '[_1] este comentario fue hecho en',
	'[_1] no longer exists' => '[_1] no existe más largo',
	'View all comments on this [_1]' => 'Ver todos los comentario en este [_1]',
	'Date' => 'Fecha',
	'Date this comment was made' => 'Fecha de cuando se hizo el comentario',
	'View all comments created on this day' => 'Ver todos los comentarios creados este día',
	'IP Address of the commenter' => 'Dirección IP del comentarista',
	'View all comments from this IP Address' => 'Ver todos los comentarios procedentes de esta dirección IP',
	'Fulltext of the comment entry' => 'Texto completo de la entrada del comentario',
	'Responses to this comment' => 'Respuestas al comentario',

## tmpl/cms/edit_entry_batch.tmpl
	'Save these [_1] (s)' => 'Guardar este [_1] (s)',
	'Published Date' => 'Fecha de publicación',
	'Unpublished (Draft)' => 'No publicado (Borrador)',
	'Unpublished (Review)' => 'No publicado (Revisión)',

## tmpl/cms/edit_entry.tmpl
	'Edit Page' => 'Editar página',
	'Create Page' => 'Crear página',
	'Add new folder parent' => 'Añadir nueva carpeta raíz',
	'Preview this page (v)' => 'Vista previa de la página (v)',
	'Delete this page (x)' => 'Borrar esta página (x)',
	'View Page' => 'Ver página',
	'Edit Entry' => 'Editar entrada',
	'Create Entry' => 'Crear nueva entrada',
	'Category Name' => 'Nombre de la categoría',
	'Add new category parent' => 'Añadir categoría raíz',
	'Manage Entries' => 'Administrar entradas',
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
	'This post was held for review, due to spam filtering.' => 'Esta entrada está retenida para su aprobación, debido al filtro antispam.',
	'This post was classified as spam.' => 'Esta entrada fue clasificada como spam.',
	'Add folder' => 'Añadir carpeta',
	'Change Folder' => 'Cambiar carpeta',
	'Unpublished (Spam)' => 'No publicado (Spam)',
	'Revision: <strong>[_1]</strong>' => 'Revisión: <strong>[_1]</strong>',
	'View revisions of this [_1]' => 'Ver revisiones de este [_1]',
	'View revisions' => 'Ver revisiones',
	'No revision(s) associated with this [_1]' => 'No hay revisiones de este [_1]',
	'[_1] - Published by [_2]' => '[_1] - Publicado por [_2]',
	'[_1] - Edited by [_2]' => '[_1] - Editado por [_2]',
	'Publish this [_1]' => 'Publicar esta [_1]',
	'Draft this [_1]' => 'En borrador esta [_1]',
	'Schedule' => 'Programación',
	'Update' => 'Actualizar',
	'Update this [_1]' => 'Actualizar esta [_1]',
	'Unpublish this [_1]' => 'Despublicar esta [_1]',
	'Save this [_1]' => 'Guardar [_1]',
	'You must configure this blog before you can publish this entry.' => 'Debe configurar el blog antes de poder publicar esta entrada.',
	'You must configure this blog before you can publish this page.' => 'Debe configurar el blog antes de poder publicar esta página.',
	'Publish On' => 'Publicado el',
	'@' => '@',
	'Warning: If you set the basename manually, it may conflict with another entry.' => 'Atención: Si introduce el nombre base manualmente, podría entrar en conflicto con otra entrada.',
	q{Warning: Changing this entry's basename may break inbound links.} => q{Atención: Si cambia el nombre base de la entrada, podría romper enlaces entrantes.},
	'Change note' => 'Cambiar nota',
	'Add category' => 'Añadir categoría',
	'edit' => 'editar',
	'close' => 'cerrar',
	'Accept' => 'Aceptar',
	'<a href="[_2]">[_1]</a>' => '<a href="[_2]">[_1]</a>',
	'View Previously Sent TrackBacks' => 'Ver TrackBacks enviados anteriormente',
	'Outbound TrackBack URLs' => 'URLs de TrackBacks salientes',
	'[_1] Assets' => 'Multimedia de la [_1]',
	'Remove this asset.' => 'Eliminar este fichero multimedia.',
	'No assets' => 'Ningún fichero multimedia.',
	'You have unsaved changes to this entry that will be lost.' => 'Posee cambios no guardados en esta entrada que se perderán.',
	'Enter the link address:' => 'Introduzca la dirección del enlace:',
	'Enter the text to link to:' => 'Introduzca el texto del enlace:',
	'Converting to rich text may result in changes to your current document.' => 'La conversión a texto con formato puede modificar el documento actual.',
	'Make primary' => 'Hacer primario',
	'Fields' => 'Campos',
	'Reset display options to blog defaults' => 'Reiniciar opciones de visualización con los valores predefinidos del blog',
	'Reset defaults' => 'Reiniciar valores predefinidos',
	'Permalink:' => 'Enlace permanente:',
	'Share' => 'Compartir',
	'Format:' => 'Formato:',
	'(comma-delimited list)' => '(lista separada por comas)',
	'(space-delimited list)' => '(lista separada por espacios)',
	q{(delimited by '[_1]')} => q{(separado por '[_1]')},
	'Not specified' => 'No especificado.',
	'None selected' => 'Ninguna seleccionada',
	'Auto-saving...' => 'Auto-guardando...',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Último guardado automático a las [_1]:[_2]:[_3]',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Editar carpeta',
	'Manage Folders' => 'Administrar carpetas',
	'Manage pages in this folder' => 'Administrar las páginas de esta carpeta',
	'You must specify a label for the folder.' => 'Debe especificar una etiqueta para la carpeta.',
	'Path' => 'Ruta',
	'Save changes to this folder (s)' => 'Guardar cambios de esta carpeta (s)',

## tmpl/cms/edit_ping.tmpl
	'Edit Trackback' => 'Editar TrackBack',
	'The TrackBack has been approved.' => 'Se aprobó el TrackBack.',
	'This trackback was classified as spam.' => 'Se ha clasificado el trackback como basura.',
	'Save changes to this TrackBack (s)' => 'Guardar cambios de este TrackBack (s)',
	'Delete this TrackBack (x)' => 'Borrar este TrackBack (x)',
	'Manage TrackBacks' => 'Administrar TrackBacks',
	'Update the status of this TrackBack' => 'Actualizar el estado del TrackBack',
	'View all TrackBacks with this status' => 'Ver TrackBacks con este estado',
	'Search for other TrackBacks from this site' => 'Buscar otros TrackBacks en este sitio',
	'Search for other TrackBacks with this title' => 'Buscar otros TrackBacks con este título',
	'Search for other TrackBacks with this status' => 'Buscar otros TrackBacks con este estado',
	'Target [_1]' => 'Destino [_1]',
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

## tmpl/cms/edit_role.tmpl
	'Edit Role' => 'Editar rol',
	'Association (1)' => 'Asociación (1)',
	'Associations ([_1])' => 'Asociaciones ([_1])',
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'Ha cambiado los provilegios de este rol.  Esto va cambiar las posibilidades de maniobra de los usuarios asociados a este rol. Si usted prefiere, puede guardar este rol con otro nombre diferente.',
	'Role Details' => 'Detalles de los roles',
	'System' => 'Sistema',
	'Privileges' => 'Privilegios',
	'Administration' => 'Administración',
	'Authoring and Publishing' => 'Creación y publicación',
	'Designing' => 'Diseño',
	'Commenting' => 'Comentar',
	'Duplicate Roles' => 'Duplicar roles',
	'These roles have the same privileges as this role' => 'Estos roles tienen privilegios parecidos a este rol',
	'Save changes to this role (s)' => 'Guardar cambios en el rol (s)',

## tmpl/cms/edit_template.tmpl
	'Edit Widget' => 'Editar widget',
	'Create Widget' => 'Crear widget',
	'Create Template' => 'Crear plantilla',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]">Recover auto-saved content</a>' => 'Se auto-guardó [_2] una versión guardada de [_1]. <a href="[_2]">Recuperar contenido auto-guardado</a>',
	'You have successfully recovered your saved [_1].' => 'Recuperó con éxito la versión guardada de [_1].',
	'An error occurred while trying to recover your saved [_1].' => 'Ocurrió un error intentando recuperar la versión guardada de [_1].',
	'Restored revision (Date:[_1]).' => 'Revisión restaurada (Fecha: [_1]).',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => '<a href="[_1]" class="rebuild-link">Publicar</a> esta plantilla.',
	'Your [_1] has been published.' => 'Su [_1] se ha publicado.',
	'View revisions of this template' => 'Ver revisiones de esta plantilla',
	'No revision(s) associated with this template' => 'Ninguna revisión asociada a esta plantilla',
	'Useful Links' => 'Enlaces útiles',
	'List [_1] templates' => 'Listar plantillas [_1]',
	'Module Option Settings' => 'Configuración de opciones del módulo',
	'List all templates' => 'Listar todas las plantillas',
	'View Published Template' => 'Ver plantilla publicada',
	'Included Templates' => 'Plantillas incluídas',
	'create' => 'crear',
	'Template Tag Docs' => 'Documentos sobre las etiquetas',
	'Unrecognized Tags' => 'Etiquetas no reconocidas',
	'Save Changes (s)' => 'Guardar los cambios (s)',
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
	'Syntax highlighting On' => 'Coloreado de sintaxis activado',
	'Syntax highlighting Off' => 'Coloreado de sintaxis desactivado',
	'Template Options' => 'Opciones de plantillas',
	'Output file: <strong>[_1]</strong>' => 'Fichero de salida: <strong>[_1]</strong>',
	'Enabled Mappings: [_1]' => 'Habilitar mapas: [_1]',
	'Template Type' => 'Tipo de plantilla',
	'Custom Index Template' => 'Plantilla índice personalizada',
	'Link to File' => 'Enlazar a archivo',
	'Learn more about <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publishing settings</a>' => 'Más información sobre las <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">opciones de publicación</a>',
	'Create Archive Mapping' => 'Crear mapeado de archivos',
	'Statically (default)' => 'Estáticamente (por defecto)',
	'Via Publish Queue' => 'Vía cola de publicación',
	'On a schedule' => 'Programado',
	': every ' => ': cada ',
	'minutes' => 'minutos',
	'hours' => 'horas',
	'Dynamically' => 'Dinámicamente',
	'Manually' => 'Manualmente',
	'Do Not Publish' => 'No publicar',
	'Server Side Include' => 'Server Side Include',
	'Process as <strong>[_1]</strong> include' => 'Procesar como inserción <strong>[_1]</strong>',
	'Include cache path' => 'Ruta de caché de inserciones',
	'Disabled (<a href="[_1]">change publishing settings</a>)' => 'Deshabilitado (<a href="[_1]">modificar configuración de la publicación</a>)',
	'No caching' => 'Sin caché',
	'Expire after' => 'Caduca tras',
	'Expire upon creation or modification of:' => 'Caduca tras la creación o modificación de:',

## tmpl/cms/edit_website.tmpl
	'Create Website' => 'Crear un sitio web',
	'Website Theme' => 'Tema del sitio web',
	'Select the theme you wish to use for this website.' => 'Seleccione el tema que desea usar en este sitio web.',
	'Name your website. The website name can be changed at any time.' => 'Nombre del sitio web. Puede modificarlo en cualquier momento.',
	'Enter the URL of your website. Exclude the filename (i.e. index.html). Example: http://www.example.com/' => 'Introduzca la URL del sitio web. Excluya el nombre del fichero (i.e. index.html). Ejemplo: http://www.ejemplo.com/',
	q{Enter the path where your main index file will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/ or C:\www\public_html} => q{Introduzca la ruta de publicación del fichero índice principal. Se recomienda una ruta principal (que en Linux comienza con '/' y en Windows con 'C:\') pero también puede utilizar una ruta relativa al directorio de Movable Type. Ejemplo :/home/melody/public_html/ o C:\www\public_html},
	'Create Website (s)' => 'Crear sitio web (s)',
	'This field is required.' => 'Este campo es obligatorio.',
	'Please enter a valid URL.' => 'Por favor, introduzca una URL válida.',
	'Please enter a valid site path.' => 'Por favor, introduzca una ruta de sitio válida.',
	'You did not select a timezone.' => 'No seleccionó ninguna zona horaria.',

## tmpl/cms/edit_widget.tmpl
	'Edit Widget Set' => 'Editar widgets',
	'Create Widget Set' => 'Crear conjunto de widgets',
	'Widget Set Name' => 'Nombre del conjunto de widgets',
	'Save changes to this widget set (s)' => 'Guardar cambios de este conjunto de widgets (s)',
	q{Drag and drop the widgets that belong in this Widget Set into the 'Installed Widgets' column.} => q{Arrastre y suelte los widgets que pertenecen a este conjunto a la columna 'Widgets instalados'.},
	'Available Widgets' => 'Widgets disponibles',
	'Installed Widgets' => 'Widgets instalados',
	'You must set Widget Set Name.' => 'Debe indicar un nombre para el conjunto de widgets.',

## tmpl/cms/error.tmpl
	'An error occurred' => 'Ocurrió un error',

## tmpl/cms/export_theme.tmpl
	'Export [_1] Themes' => 'Exportar temas de [_1]',
	'Theme package have been saved.' => 'El paquete del tema se ha guardado.',
	'The name of your theme.' => 'El nombre del tema.',
	q{Use letters, numbers, dash or underscore only (a-z, A-Z, 0-9, '-' or '_').} => q{Use exclusivamente letras, números, guiones o guiones bajos (a-z, A-Z, 0-9, '-' o '_').},
	'Version' => 'Versión',
	'A version number for this theme.' => 'Un número de versión de este tema.',
	'A description for this theme.' => 'Una descripción de este tema.',
	'_THEME_AUTHOR' => 'Autor',
	'The author of this theme.' => 'El autor de este tema.',
	'Author link' => 'Enlace del autor',
	q{The author's website.} => q{El sitio web del autor.},
	'Additional assets to be included in the theme.' => 'Medios adicionales a incluir en el tema.',
	'Destination' => 'Destino',
	'Select How to get theme.' => 'Seleccione cómo obtener el tema.',
	'Setting for [_1]' => 'Configuración para [_1]',
	'Basename may only contain letters, numbers, and the dash or underscore character. The basename must begin with a letter.' => 'El nombre base solo puede contener letras, números, y el guión o guión bajo. El nombre base debe comenzar con una letra.',
	q{Cannot install new theme with existing (and protected) theme's basename.} => q{No se pudo instalar el nuevo tema con el nombre base existeinte (y protegido) del tema.},
	'You must set Theme Name.' => 'Debe indicar el nombre del tema.',
	'Theme version may only contain letters, numbers, and the dash or underscore character.' => 'La versión del tema solo puede contener letras, números y el guión o guión bajo.',

## tmpl/cms/export.tmpl
	'Export [_1] Entries' => 'Exportar [_1] entradas',
	'[_1] to Export' => '[_1] a exportar',
	'_USAGE_EXPORT_1' => 'Exporta las entradas, comentarios y TrackBacks de un blog. La exportación no puede considerarse como una copia de seguridad <em>completa</em> del blog.',
	'Export [_1]' => 'Exportar [_1]',

## tmpl/cms/import_others.tmpl
	'Start title HTML (optional)' => 'HTML de comienzo de título (opcional)',
	'End title HTML (optional)' => 'HTML de final de título (opcional)',
	'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => 'Si el software desde el que va a importar no tiene un campo de título, puede usar esta opción para identificar un título dentro del cuerpo de la entrada.',
	'Default entry status (optional)' => 'Estado predefinido de las entradas (opcional)',
	'If the software you are importing from does not specify an entry status in its export file, you can set this as the status to use when importing entries.' => 'Si el software desde el que va a importar no especifica un estado para la entrada en su fichero de exportación, puede establecer éste como el estado a utilizar al importar las entradas.',
	'Select an entry status' => 'Seleccione un estado para las entradas',

## tmpl/cms/import.tmpl
	'Import [_1] Entries' => 'Importar [_1] entradas',
	'You must select a blog to import.' => 'Debe seleccionar un blog a importar.',
	'Enter a default password for new users.' => 'Introduzca una contraseña por defecto para los nuevos usuarios.',
	'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Transfiere las entradas desde otras instalaciones de Movable Type o incluso desde otras herramientas, o exporta sus entradas para crear una copia de seguridad.',
	'Import data into' => 'Importar datos en',
	'Select a blog to import.' => 'Seleccione un blog para importar.',
	'Select blog' => 'Seleccione blog',
	'Importing from' => 'Importar desde',
	'Ownership of imported entries' => 'Autoría de las entradas importadas',
	'Import as me' => 'Importar como yo mismo',
	'Preserve original user' => 'Preservar autor original',
	'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => 'Si selecciona preservar la autoría de las entradas importadas y se debe crear alguno de estos usuarios durante en esta instalación, debe establecer una contraseña predefinida para estas nuevas cuentas.',
	'Default password for new users:' => 'Contraseña para los nuevos usuarios:',
	'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'Se le asignarán todas las entradas importadas. Si desea que las entradas mantengan los propietarios originales, debe contacar con su administrador de Movable Type para que él realice la importación y así se puedan crear los nuevos usuarios en caso de ser necesario.',
	'Upload import file (optional)' => 'Subir fichero de importación (opcional)',
	q{If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the 'import' folder of your Movable Type directory.} => q{Si el fichero de importación está situado en su PC, puede subirlo aquí. Si no, Movable Type comprobará automáticamente la carpeta 'folder' en el directorio de Movable Type.},
	'Apply this formatting if text format is not set on each entry.' => 'Aplicar este formato si el formato del texto de las entradas no está establecido.',
	'Import File Encoding' => 'Codificación del fichero de importación',
	'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'Por defecto, Movable Type intentará detectar automáticamente la codificación del fichero a importar. Sin embargo, si experimenta dificultados, puede especificarlo explícitamente.',
	'<mt:var name="display_name" escape="html">' => '<mt:var name="display_name" escape="html">',
	'Default category for entries (optional)' => 'Categoría predefinida de las entradas (opcional)',
	'You can specify a default category for imported entries which have none assigned.' => 'Puede especificar una categoría predefinida para las entradas importadas que no tengan ninguna asignada.',
	'Select a category' => 'Seleccione una categoría',
	'Import Entries (s)' => 'Importar entradas (s)',

## tmpl/cms/include/anonymous_comment.tmpl
	'Allow comments from anonymous or unauthenticated users.' => 'Permitir comentarios de usuarios anónimos o no autentificados.',
	'Require name and E-mail Address for Anonymous Comments' => 'Requerir dirección de correo en los comentarios anónimos',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Si está activo, los visitantes deberán introducir una dirección válida de correo electrónico para comentar.',

## tmpl/cms/include/archetype_editor.tmpl
	'Decrease Text Size' => 'Aumentar tamaño de texto',
	'Increase Text Size' => 'Disminuir tamaño de texto',
	'Bold' => 'Negrita',
	'Italic' => 'Cursiva',
	'Underline' => 'Subrayado',
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
	'Insert File' => 'Insertar fichero',
	'Check Spelling' => 'Ortografía',
	'WYSIWYG Mode' => 'Modo con formato (WYSIWYG)',
	'HTML Mode' => 'Modo HTML',
	'Insert Image' => 'Insertar imagen',

## tmpl/cms/include/archive_maps.tmpl

## tmpl/cms/include/asset_replace.tmpl
	q{A file named '[_1]' already exists. Do you want to overwrite this file?} => q{El fichero llamado '[_1]' ya existe. ¿Desea sobreescribirlo?},
	'Yes (s)' => 'Sí (s)',
	'Yes' => 'Sí',
	'No' => 'No',

## tmpl/cms/include/asset_table.tmpl
	'Delete selected assets (x)' => 'Borrar los ficheros multimedia seleccionados (x)',
	'Website/Blog' => 'Sitio web/Blog',
	'Created By' => 'Creado por',
	'Created On' => 'Creado en',
	'Asset Missing' => 'Fichero multimedia no existe',
	'No thumbnail image' => 'Sin miniatura',
	'Size' => 'Tamaño',

## tmpl/cms/include/asset_upload.tmpl
	q{Before you can upload a file, you need to publish your [_1]. [_2]Configure your [_1]'s publishing paths[_3] and republish your [_1].} => q{Antes de subir un fichero, debe publicar su [_1]. [_2]Configure las rutas de publicación[_3] de su [_1] y republique el [_1].},
	'Your system or [_1] administrator needs to publish the [_1] before you can upload files. Please contact your system or [_1] administrator.' => 'El administrador del sistema o del [_1] debe publicar el [_1] antes de pueda subir ficheros. Por favor, contacte con el administrador del sistema o del [_1].',
	q{Cannot write to '[_1]'. Image upload is possible, but thumbnail is not created.} => q{No se pudo escribir en '[_1]'. La transferencia de la imagen es posible, pero no se creará la miniatura.},
	q{Asset file('[_1]') has been uploaded.} => q{Se ha transferido un fichero multimedia ('[_1]').},
	'Select File to Upload' => 'Seleccione el fichero a subir',
	'_USAGE_UPLOAD' => 'Puede transferir el fichero a un subdirectorio en la ruta seleccionada. Si el subdirectorio no existe, se creará.',
	'Choose Folder' => 'Seleccionar carpeta',
	'Upload (s)' => 'Subir (s)',
	'[_1] contains a character that is invalid when used in a directory name: [_2]' => '[_1] contiene un caracter no válido para un nombre de directorio: [_2]',

## tmpl/cms/include/async_asset_list.tmpl
	'Asset Type: ' => 'Tipo multimedia:',
	'All Types' => 'Todos los tipos',
	'label' => 'Título',
	'[_1] - [_2] of [_3]' => '[_1] - [_2] de [_3]',

## tmpl/cms/include/async_asset_upload.tmpl
	'Upload new image' => 'Subir nueva imagen', # Translate - Case
	'Upload new asset' => 'Transferir nuevo fichero multimedia', # Translate - Case
	'Choose files to upload or drag files.' => 'Seleccione los ficheros para subir o arrástrelos.', # Translate - New
	'Choose file to upload or drag file.' => 'Seleccione los ficheros a subir o arrástrelos.', # Translate - New
	'Upload Options' => 'Configuración transferencias',
	'Operation for a file exists' => 'Acción para ficheros existentes',
	'Drag and drop here' => 'Arrastrar y solar aquí', # Translate - New
	'Cancelled: [_1]' => 'Cancelado: [_1]',
	'The file you tried to upload is too large: [_1]' => 'El fichero que intentó transferir es muy grande: [_1]',
	'[_1] is not a valid [_2] file.' => '[_1] no es un fichero [_2] válido.',

## tmpl/cms/include/author_table.tmpl
	'Enable selected users (e)' => 'Habilitar usuarios seleccionados (e)',
	'_USER_ENABLE' => 'Habilitado',
	'Disable selected users (d)' => 'Deshabilitar usuarios seleccionados (d)',
	'_USER_DISABLE' => 'Deshabilitar',
	'user' => 'usuario',
	'users' => 'usuarios',
	'_NO_SUPERUSER_DISABLE' => 'No puede deshabilitarse porque es un administrador del sistema de Movable Type',

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been backed up successfully!' => '¡La copia de seguridad de los datos se ha realizado con éxito!',
	'_BACKUP_TEMPDIR_WARNING' => 'La copia de seguridad se realizó con éxito en el directorio [_1]. Descargue y <strong>borre luego</strong> los ficheros listados abajo desde [_1] <strong>inmediatamente</strong>, porque los ficheros de la copia de seguridad contiene información sensible.',
	'Backup Files' => 'Copia de seguridad',
	'Download This File' => 'Descargar este fichero',
	'Download: [_1]' => 'Descargar: [_1]',
	'_BACKUP_DOWNLOAD_MESSAGE' => 'La descarga del fichero de la copia de seguridad comenzará automáticamente dentro de unos segundos. Si por alguna razón no lo hace, haga clic <a href="javascript:(void)" onclick="submit_form()">aquí</a> para comenzar la descarga manualmente. Por favor, tenga en cuenta que solo puede descargar el fichero de la copia de seguridad una vez por sesión.',

## tmpl/cms/include/backup_start.tmpl
	'Backing up Movable Type' => 'Haciendo copia de seguridad de Movable Type',

## tmpl/cms/include/basic_filter_forms.tmpl
	'contains' => 'contiene',
	'does not contain' => 'no contiene',
	'__STRING_FILTER_EQUAL' => 'es',
	'starts with' => 'comienza con',
	'ends with' => 'termina con',
	'[_1] [_2] [_3]' => '[_1] [_2] [_3]',
	'__INTEGER_FILTER_EQUAL' => 'es',
	'__INTEGER_FILTER_NOT_EQUAL' => 'no es',
	'is greater than' => 'es mayor que',
	'is greater than or equal to' => 'es mayor o igual que',
	'is less than' => 'es menor que',
	'is less than or equal to' => 'es menor o igual que',
	'is between' => 'está entre',
	'is within the last' => 'está entre el último',
	'is before' => 'es anterior',
	'is after' => 'es posterior',
	'is after now' => 'es posterior a ahora',
	'is before now' => 'es anterior a ahora',
	'__FILTER_DATE_ORIGIN' => '[_1]',
	'[_1] and [_2]' => '[_1] y [_2]',
	'_FILTER_DATE_DAYS' => '[_1] días',

## tmpl/cms/include/blog_table.tmpl
	'Some templates were not refreshed.' => 'No se refrescaron algunas plantillas.',
	'Delete selected [_1] (x)' => 'Borrar [_1] seleccionados (x)',
	'[_1] Name' => 'Nombre de [_1]',

## tmpl/cms/include/category_selector.tmpl
	'Add sub category' => 'Añadir sub categoría',
	'Add sub folder' => 'Añadir sub carpeta',

## tmpl/cms/include/comment_detail.tmpl

## tmpl/cms/include/commenter_table.tmpl
	'Last Commented' => 'Últimos comentados',
	'Edit this commenter' => 'Editar este comentarista',
	'View this commenter&rsquo;s profile' => 'Ver el perfil de este comentarista',

## tmpl/cms/include/comment_table.tmpl
	'Publish selected comments (a)' => 'Publicar comentarios seleccionados (a)',
	'Delete selected comments (x)' => 'Borrar comentarios seleccionados (x)',
	'Edit this comment' => 'Editar este comentario',
	'([quant,_1,reply,replies])' => '([quant,_1,respuesta,respuestas])',
	'Blocked' => 'Bloqueado',
	'Edit this [_1] commenter' => 'Editar comentarista [_1]',
	'Search for comments by this commenter' => 'Buscar comentarios de este comentarista',
	'View this entry' => 'Ver esta entrada',
	'View this page' => 'Ver esta página',
	'Search for all comments from this IP address' => 'Buscar todos los comentarios enviados desde esta dirección IP',
	'to republish' => 'para reconstruir',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001 Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001 Six Apart. All Rights Reserved.',

## tmpl/cms/include/debug_hover.tmpl
	'Hide Toolbar' => 'Ocultar barra',
	'Hide &raquo;' => 'Ocultar &raquo;',

## tmpl/cms/include/debug_toolbar/cache.tmpl
	'Key' => 'Clave',
	'Value' => 'Valor',

## tmpl/cms/include/debug_toolbar/headers.tmpl

## tmpl/cms/include/debug_toolbar/requestvars.tmpl
	'Cookies' => 'Cookies',
	'Variable' => 'Variable',
	'No COOKIE data' => 'Sin datos de COOKIES',
	'Input Parameters' => 'Parámetros de entrada',
	'No Input Parameters' => 'Sin parámetros de entrada',

## tmpl/cms/include/debug_toolbar/sql.tmpl

## tmpl/cms/include/display_options.tmpl
	'Display Options' => 'Opciones de visualización',
	'_DISPLAY_OPTIONS_SHOW' => 'Mostrar',
	'[quant,_1,row,rows]' => '[quant,_1,fila,filas]',
	'Compact' => 'Compacto',
	'Expanded' => 'Expandido',
	'Save display options' => 'Guardar opciones de visualización',

## tmpl/cms/include/entry_table.tmpl
	'Republish selected [_1] (r)' => 'Republicar [_1] seleccionadas (r)',
	'Last Modified' => 'Última modificación',
	'Created' => 'Creado',
	'View entry' => 'Ver entrada',
	'View page' => 'Ver página',
	'No entries could be found.' => 'No se encontraron entradas.',
	'<a href="[_1]">Create an entry</a> now.' => '<a href="[_1]">Crear una entrada</a> ahora.',
	'No pages could be found. <a href="[_1]">Create a page</a> now.' => 'No se encontró ninguna página. <a href="[_1]">Cree una ahora</a>.',

## tmpl/cms/include/feed_link.tmpl
	'Set Web Services Password' => 'Establecer contraseña de servicios web',

## tmpl/cms/include/footer.tmpl
	'This is a beta version of Movable Type and is not recommended for production use.' => 'Esta es una versión beta de Movable Type y no se recomienda su uso en producción.',
	'http://www.movabletype.org' => 'http://www.movabletype.org',
	'MovableType.org' => 'MovableType.org',
	'http://plugins.movabletype.org/' => 'http://plugins.movabletype.org/',
	'http://wiki.movabletype.org/' => 'http://wiki.movabletype.org/',
	'Wiki' => 'Wiki',
	'Support' => 'Soporte',
	'http://forums.movabletype.org/' => 'http://forums.movabletype.org/',
	'Forums' => 'Foros',
	'Send Us Feedback' => 'Envíenos su opinión',
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> versión [_2]',
	'with' => 'con',
	q{_LOCALE_CALENDAR_HEADER_} => q{'D', 'L', 'M', 'X', 'J', 'V', 'S', 'D'},
	'Your Dashboard' => 'Su panel de control',

## tmpl/cms/include/header.tmpl
	'Help' => 'Ayuda',
	'Sign out' => 'Salir',
	'View Site' => 'Ver sitio',
	'Search (q)' => 'Buscar (q)',
	'Search [_1]' => 'Buscar [_1]',
	'Create New' => 'Crear nuevo',
	'Select an action' => 'Seleccione una acción',
	'You have <strong>[quant,_1,message,messages]</strong> from the system.' => 'Tiene <strong>[quant,_1,mensaje,mensajes]</strong> del sistema.',
	q{This website was created during the upgrade from a previous version of Movable Type. 'Site Root' and 'Site URL' are left blank to retain 'Publishing Paths' compatibility for blogs that were created in a previous version. You can post and publish on existing blogs, but you cannot publish this website itself because of the blank 'Site Root' and 'Site URL'.} => q{Este sitio web se ha creado al actualizar desde una versión anterior de Movable Type. 'Ruta del sitio' y 'URL del sitio' se han dejado en blanco para mantener la compatabilidad con las 'Rutas de publicación' de los blogs creados en versiones anteriores. Puede publicar en los blogs existentes, pero no puede publicar en este sitio directamente debido a que la 'Ruta del sitio' y la 'URL del sitio' están en blanco.},
	'from Revision History' => 'del histórico de revisiones',

## tmpl/cms/include/import_end.tmpl
	'All data imported successfully!' => '¡Importados con éxito todos los datos!',
	'<a href="#" onclick="[_1]" class="mt-build">Publish your site</a> to see these changes take effect.' => '<a href="#" onclick="[_1]" class="mt-build">Publique su sitio</a> para que los cambios tomen efecto.',
	q{Make sure that you remove the files that you imported from the 'import' folder, so that if/when you run the import process again, those files will not be re-imported.} => q{Asegúrese de borrar los ficheros importados del directorio 'import', para evitar procesarlos de nuevo al ejecutar en otra ocasión el proceso de importación.},

## tmpl/cms/include/import_start.tmpl
	'Importing...' => 'Importando...',
	'Importing entries into [_1]' => 'Importando entradas en el [_1]',
	q{Importing entries as user '[_1]'} => q{Importando entradas como usuario '[_1]'},
	'Creating new users for each user found in the [_1]' => 'Creando nuevos usuarios para cada usuario encontrado en el [_1]',

## tmpl/cms/include/insert_options_image.tmpl

## tmpl/cms/include/itemset_action_widget.tmpl
	'More actions...' => 'Más acciones...',
	'Plugin Actions' => 'Acciones de extensiones',
	'Go' => 'Ir',

## tmpl/cms/include/list_associations/page_title.tmpl
	'Manage Permissions' => 'Administrar permisos',
	'Users for [_1]' => 'Usuarios de [_1]',

## tmpl/cms/include/listing_panel.tmpl
	'Step [_1] of [_2]' => 'Paso [_1] de [_2]',
	'Go to [_1]' => 'Ir a [_1]',
	'Sorry, there were no results for your search. Please try searching again.' => 'Lo siento, no se encontraron resultados para la búsqueda. Por favor, intente buscar de nuevo.',
	'Sorry, there is no data for this object set.' => 'Lo siento, no hay datos para este conjunto de objetos.',
	'OK (s)' => 'Aceptar (s)',
	'OK' => 'Aceptar',

## tmpl/cms/include/login_mt.tmpl
	'Remember me?' => '¿Recordarme?',

## tmpl/cms/include/log_table.tmpl
	'No log records could be found.' => 'No se encontraron registros.',
	'_LOG_TABLE_BY' => 'Por',
	'IP: [_1]' => 'IP: [_1]',

## tmpl/cms/include/member_table.tmpl
	'Are you sure you want to remove the selected user from this [_1]?' => '¿Está seguro de que desea borrar al usuario seleccionado de este [_1]?',
	'Are you sure you want to remove the [_1] selected users from this [_2]?' => '¿Está seguro de que desea borrar a los [_1] usuarios seleccionados de este [_2]?',
	'Remove selected user(s) (r)' => 'Borrar usuarios seleccionados (r)',
	'Trusted commenter' => 'Comentarista de confianza',
	'Remove this role' => 'Borrar este rol',

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Fecha de creación',
	'Save changes' => 'Guardar cambios',

## tmpl/cms/include/pagination.tmpl

## tmpl/cms/include/ping_table.tmpl
	'Publish selected [_1] (p)' => 'Publicar [_1] seleccionados (p)',
	'Edit this TrackBack' => 'Editar este TrackBack',
	'Go to the source entry of this TrackBack' => 'Ir a la entrada de origen de este TrackBack',
	'View the [_1] for this TrackBack' => 'Mostrar [_1] de este TrackBack',

## tmpl/cms/include/revision_table.tmpl
	'No revisions could be found.' => 'No se encontraron revisiones.',
	'_REVISION_DATE_' => 'Fecha',
	'Note' => 'Nota',
	'Saved By' => 'Guardado por',

## tmpl/cms/include/rpt_log_table.tmpl
	'Schwartz Message' => 'Mensaje de Schwartz',

## tmpl/cms/include/scope_selector.tmpl
	'User Dashboard' => 'Panel de control del usuario',
	'Select another website...' => 'Seleccione otro sitio web...',
	'(on [_1])' => '(en [_1])',
	'Select another blog...' => 'Seleccionar otro blog...',
	'Create Blog (on [_1])' => 'Crear un blog (en [_1])',

## tmpl/cms/include/template_table.tmpl
	'Create Archive Template:' => 'Crear plantilla de archivos',
	'Entry Listing' => 'Listado de entradas',
	'Create template module' => 'Crear plantilla de módulo',
	'Create index template' => 'Crear plantilla índice',
	'Publish selected templates (a)' => 'Publicar plantillas seleccionadas (a)',
	'Archive Path' => 'Ruta de archivos',
	'SSI' => 'Inclusiones en servidor (SSI)',
	'Cached' => 'Cacheado',
	'Linked Template' => 'Plantilla enlazada',
	'Manual' => 'Manual',
	'Dynamic' => 'Dinámico',
	'Publish Queue' => 'Cola de publicación',
	'Static' => 'Estático',
	'templates' => 'plantillas',
	'to publish' => 'para publicar',

## tmpl/cms/include/theme_exporters/category.tmpl

## tmpl/cms/include/theme_exporters/folder.tmpl
	'Folder Name' => 'Nombre de la carpeta',
	'<mt:if name="is_blog">Blog URL<mt:else>Site URL</mt:if>' => '<mt:if name="is_blog">URL del blog<mt:else>URL del sitio</mt:if>',

## tmpl/cms/include/theme_exporters/static_files.tmpl
	'In the specified directories, files of the following types will be included in the theme: [_1]. Other file types will be ignored.' => 'En los directorios especificados, se incluirán en el tema los ficheros de los siguientes tipos: [_1]. Se ignorarán el resto de tipos de ficheros.',
	'Specify directories' => 'Especificar directorios',
	'List directories (one per line) in the Site Root directory which contain the static files to be included in the theme. Common directories might be: css, images, js, etc.' => 'Indique una lista de directorios (uno por línea) en el directorio Raíz del Sitio que contienen los ficheros estáticos a incluir en el tema. Los directorios más comunes son: css, images, js, etc.',

## tmpl/cms/include/theme_exporters/templateset.tmpl
	'widget sets' => 'Conjuntos de widgets',
	'modules' => 'módulos',
	'<span class="count">[_1]</span> [_2] are included' => '<span class="count">[_1]</span> [_2] están incluídos',

## tmpl/cms/install.tmpl
	'Welcome to Movable Type' => 'Bienvenido a Movable Type',
	'Create Your Account' => 'Crear Cuenta',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'La versión de Perl instalada en su servidor ([_1]) es menor que la versión mínima soporta ([_2]).',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Aunque Movable Type podría ejecutarse, <strong>esta configuración no está probada ni ni soportada</strong>.  Le recomendamos que actualice Perl a la versión [_1].',
	'Do you want to proceed with the installation anyway?' => '¿Aún así desea proceder con la instalación?',
	'View MT-Check (x)' => 'Ver MT-Check (x)',
	'Please create an administrator account for your system. When you are done, Movable Type will initialize your database.' => 'Por favor, cree una cuenta para el administrador del sistema. Cuando haya finalizado, Movable Type inicializará la base de datos.',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Para proceder, debe autentificarse correctamente en su servidor LDAP.',
	'The name used by this user to login.' => 'El nombre utilizado por este usuario para iniciar su sesión.',
	'The name used when published.' => 'El nombre utilizado al publicar.',
	'The user&rsquo;s email address.' => 'La dirección de correo electrónico del usuario',
	'System Email' => 'Correo del sistema',
	'Use this as system email address' => 'Usar esta dirección de correo para el sistema',
	'The user&rsquo;s preferred language.' => 'El idioma preferido del usuario.',
	'Select a password for your account.' => 'Seleccione una contraseña para su cuenta.',
	'Your LDAP username.' => 'Su usuario en el servidor LDAP.',
	'Enter your LDAP password.' => 'Su contraseña en el servidor LDAP.',
	'The initial account name is required.' => 'Se necesita el nombre de la cuenta inicial.',
	'The display name is required.' => 'El nombre público es obligatorio.',
	'The e-mail address is required.' => 'La dirección de correo electrónico es necesaria.',

## tmpl/cms/list_category.tmpl
	'Manage [_1]' => 'Administrar [_1]',
	'Top Level' => 'Raíz',
	'[_1] label' => 'Etiqueta de [_1]',
	'Change and move' => 'Cambiar y trasladar',
	'Rename' => 'Renombrar',
	'Label is required.' => 'La etiqueta es obligatoria.',
	'Label is too long.' => 'La etiqueta es muy larga.',
	'Duplicated label on this level.' => 'Etiqueta duplicada en este nivel.',
	'Basename is required.' => 'El nombre base es obligatorio.',
	'Invalid Basename.' => 'Nombre base no válido.',
	'Duplicated basename on this level.' => 'Nombre base duplicado en este nivel.',
	'Add child [_1]' => 'Añadir [_1] hijo',
	'Remove [_1]' => 'Borrar [_1]',
	'[_1] \'[_2]\' already exists.' => '[_1] \'[_2]\' ya existe.',
	'Are you sure you want to remove [_1] [_2]?' => '¿Está seguro de que desea borrar [_1] [_2]?',
	'Are you sure you want to remove [_1] [_2] with [_3] sub [_4]?' => '¿Está seguro de que desea borrar [_1] [_2] con [_3] sub [_4]?',
	'Alert' => 'Alerta',

## tmpl/cms/list_common.tmpl
	'25 rows' => '25 filas',
	'50 rows' => '50 filas',
	'100 rows' => '100 filas',
	'200 rows' => '200 rows',
	'Column' => 'Columna',
	'<mt:var name="js_message">' => '<mt:var name="js_message">',
	'Filter:' => 'Filtro:',
	'Select Filter...' => 'Seleccionar filtro...',
	'Remove Filter' => 'Borrar filtro',
	'Select Filter Item...' => 'Seleccionar elemento de filtro...',
	'Save As' => 'Guardar como',
	'Filter Label' => 'Filtrar etiqueta',
	'My Filters' => 'Mis filtros',
	'Built in Filters' => 'Filtros de serie',
	'Remove item' => 'Borrar elemento',
	'Unknown Filter' => 'Filtro desconocido',
	'act upon' => 'actuar sobre',
	'Are you sure you want to remove the filter \'[_1]\'?' => '¿Está seguro de que desea borrar el filtro \'[_1]\'?',
	'Label "[_1]" is already in use.' => 'La etiqueta "[_1]" ya está en uso.',
	'Communication Error (HTTP status code: [_1]. Message: [_2])' => 'Error de comunicación (código de estado HTTP: [_1]. Mensaje: [_2])',
	'Select all [_1] items' => 'Seleccionar los [_1] elementos',
	'All [_1] items are selected' => 'Todos los [_1] elementos están seleccionados',
	'[_1] Filter Items have errors' => '[_1] elementos de filtro tienen errores',
	'[_1] - Filter [_2]' => '[_1] - Filtro [_2]',
	'Save Filter' => 'Guardar filtro',
	'Save As Filter' => 'Guardar como filtro',
	'Select Filter' => 'Seleccionar filtro',

## tmpl/cms/list_entry.tmpl
	'Entries Feed' => 'Sindicación de las entradas',
	'Pages Feed' => 'Sindicación de las páginas',
	'The entry has been deleted from the database.' => 'La entrada ha sido borrada de la base de datos.',
	'The page has been deleted from the database.' => 'La página ha sido borrada de la base de datos.',
	'Quickfilters' => 'Filtros rápidos',
	'[_1] (Disabled)' => '[_1] (Desactivado)',
	'Showing only: [_1]' => 'Mostrando solo: [_1]',
	'Remove filter' => 'Borrar filtro',
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
	'Select...' => 'Seleccionar...',

## tmpl/cms/listing/asset_list_header.tmpl
	'You have successfully deleted the asset(s).' => 'Se borraron con éxito los ficheros multimedia seleccionados.',
	q{Cannot write to '[_1]'. Thumbnail of items may not be displayed.} => q{No se pudo escribir en '[_1]'. Quizás no se muestren las miniaturas.},

## tmpl/cms/listing/association_list_header.tmpl
	'You have successfully revoked the given permission(s).' => 'Otorgó los permisos con éxito.',
	'You have successfully granted the given permission(s).' => 'Revocó los permisos con éxito.',

## tmpl/cms/listing/author_list_header.tmpl
	'You have successfully disabled the selected user(s).' => 'Ha deshabilitado con éxito el/los usuario/s seleccionado/s.',
	'You have successfully enabled the selected user(s).' => 'Ha habilitado con éxito el/los usuario/s seleccionado/s.',
	'You have successfully unlocked the selected user(s).' => 'Ha desbloqueado con éxito el/los usuario/s seleccionado/s.',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'Ha borrado con éxito el/los usuario/s seleccionado/s del sistema de Movable Type.',
	'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Advanced.' => 'Este usuario borrado aún existe en el directorio externo. Como tal, aún podrán acceder a Movable Type Advanced.',
	q{You have successfully synchronized users' information with the external directory.} => q{Sincronizó con éxito la información de los usuarios con el directorio externo.},
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => 'Algunos ([_1]) de los usuarios seleccionados no pudieron rehabilitarse porque ya no se encuentra en el directorio externo.',
	q{Some ([_1]) of the selected user(s) could not be re-enabled because they had some invalid parameter(s). Please check the <a href='[_2]'>activity log</a> for more details.} => q{Algunos ([_1] de los usuarios seleccionados no se pudieron rehabilitar debido a algún parámetro no válido. Por favor, compruebe el <a href='[_2]'>historial de actividad</a> para más detalles.},
	q{An error occurred during synchronization.  See the <a href='[_1]'>activity log</a> for detailed information.} => q{Ocurrió un error durante la sincronización. Para información más detallada, consulte el <a href='[_1]'>registro de actividad</a>.},

## tmpl/cms/listing/banlist_list_header.tmpl
	'You have added [_1] to your list of banned IP addresses.' => 'Agregó [_1] a su lista de direcciones IP bloqueadas.',
	'You have successfully deleted the selected IP addresses from the list.' => 'Eliminó correctamente las direcciones IP seleccionadas.',
	'Invalid IP address.' => 'Dirección IP no válida.',

## tmpl/cms/listing/blog_list_header.tmpl
	'You have successfully deleted the website from the Movable Type system. The files still exist in the site path. Please delete files if not needed.' => 'Ha eliminado con éxito el sitio web del sistema de Movable Type. Los ficheros aún están en el directorio del sitio. Borre este ficheros si no los necesita.',
	'You have successfully deleted the blog from the website. The files still exist in the site path. Please delete files if not needed.' => 'Ha eliminado con éxito el blog del sitio web. Los ficheros aún se encuentran en el directorio. Elimine los ficheros si no los necesita.',
	'You have successfully refreshed your templates.' => 'Ha refrescado con éxito las plantillas.',
	'You have successfully moved selected blogs to another website.' => 'Ha trasladado con éxito los blogs seleccionados a otro sitio web.',
	'Warning: You need to copy uploaded assets to new locations manually. You should consider maintaining copies of uploaded assets in their original locations to avoid broken links.' => 'Aviso: Debe copiar manualmente los ficheros multimedia asociados a nueva ruta. Estudie mantener una copia de los ficheros en su lugar original para evitar romper enlaces.',

## tmpl/cms/listing/comment_list_header.tmpl
	'The selected comment(s) has been approved.' => 'Se ha aprobado los comentarios seleccionados.',
	'All comments reported as spam have been removed.' => 'Se ha borrado los comentarios marcados como spam.',
	'The selected comment(s) has been unapproved.' => 'Se ha desaprobado los comentarios seleccionados.',
	'The selected comment(s) has been reported as spam.' => 'Se ha marcado como spam los comentarios seleccionados.',
	'The selected comment(s) has been recovered from spam.' => 'Se ha recuperado del spam los comentarios seleccionados.',
	'The selected comment(s) has been deleted from the database.' => 'Los comentarios seleccionados fueron eliminados de la base de datos.',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be banned or trusted.' => 'Uno o más comentarios de los que seleccionó fueron enviados por un comentarista no autentificado. No se puede bloquear o dar confianza a estos comentaristas.',
	'No comments appear to be spam.' => 'Ningún comentario parece que sea basura.',

## tmpl/cms/listing/entry_list_header.tmpl

## tmpl/cms/listing/filter_list_header.tmpl

## tmpl/cms/listing/log_list_header.tmpl
	'All times are displayed in GMT[_1].' => 'Todas las horas se muestran en GMT[_1].',
	'All times are displayed in GMT.' => 'Todas las fechas se muestran en GMT.',

## tmpl/cms/listing/member_list_header.tmpl

## tmpl/cms/listing/notification_list_header.tmpl
	'You have added [_1] to your address book.' => 'Ha añadido [_1] a su agenda de direcciones.',
	'You have successfully deleted the selected contacts from your address book.' => 'Ha borrado con éxito los contactos seleccionados de su agenda.',

## tmpl/cms/listing/ping_list_header.tmpl
	'The selected TrackBack(s) has been approved.' => 'Se han aprobado los TrackBacks seleccionados.',
	'All TrackBacks reported as spam have been removed.' => 'Se han elimitado todos los TrackBacks marcadoscomo spam.',
	'The selected TrackBack(s) has been unapproved.' => 'Se han desaprobado los TrackBacks seleccionados.',
	'The selected TrackBack(s) has been reported as spam.' => 'Se han marcado como spam los TrackBacks seleccionados.',
	'The selected TrackBack(s) has been recovered from spam.' => 'Se han recuperado del spam los TrackBacks seleccionados.',
	'The selected TrackBack(s) has been deleted from the database.' => 'Se eliminaron de la base de datos los TrackBacks seleccionados.',
	'No TrackBacks appeared to be spam.' => 'Ningún TrackBacks parece ser spam.',

## tmpl/cms/listing/role_list_header.tmpl
	'You have successfully deleted the role(s).' => 'Ha borrado con éxito el/los rol/es.',

## tmpl/cms/listing/tag_list_header.tmpl
	'Your tag changes and additions have been made.' => 'Se han realizado los cambios y añadidos a las etiquetas especificados.',
	'You have successfully deleted the selected tags.' => 'Se borraron con éxito las etiquetas especificadas.',
	'Specify new name of the tag.' => 'Nuevo nombre especifíco de la etiqueta',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all blogs?' => 'La etiqueta \'[_2]\' ya existe.  ¿Está seguro de querer combinar \'[_1]\' con \'[_2]\' en todos los blogs?',

## tmpl/cms/list_template.tmpl
	'Manage [_1] Templates' => 'Administrar plantillas de [_1]',
	'Manage Global Templates' => 'Administrar plantillas globales',
	'Show All Templates' => 'Mostrar todas las plantillas',
	'Publishing Settings' => 'Configuración de publicación',
	'You have successfully deleted the checked template(s).' => 'Se eliminaron correctamente las plantillas marcadas.',
	'Your templates have been published.' => 'Se han publicado las plantillas.',
	'Selected template(s) has been copied.' => 'Se han publicado las plantillas seleccionadas.',

## tmpl/cms/list_theme.tmpl
	'[_1] Themes' => 'Temas de [_1]',
	'All Themes' => 'Todos los temas',
	'_THEME_DIRECTORY_URL' => 'http://plugins.movabletype.org/',
	'Find Themes' => 'Buscar temas',
	'Theme [_1] has been uninstalled.' => 'El tema [_1] se ha desinstalado.',
	'Theme [_1] has been applied (<a href="[_2]">[quant,_3,warning,warnings]</a>).' => 'Se ha aplicado el tema [_1] (<a href="[_2]">[quant,_3,aviso, avisos]</a>).',
	'Theme [_1] has been applied.' => 'El tema [_1] se ha aplicado.',
	'Failed' => 'Falló',
	'[quant,_1,warning,warnings]' => '[quant,_1,aviso,avisos]',
	'Reapply' => 'Re-aplicar',
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
	'Current Theme' => 'Tema actual',
	'Themes in Use' => 'Temas utilizados',
	'Available Themes' => 'Temas disponibles',

## tmpl/cms/list_widget.tmpl
	'Manage [_1] Widgets' => 'Administrar widgets de [_1]',
	'Manage Global Widgets' => 'Administrar widgets globales',
	'Delete selected Widget Sets (x)' => 'Borrar conjuntos de widgets seleccionados (x)',
	'Helpful Tips' => 'Consejos útiles',
	'To add a widget set to your templates, use the following syntax:' => 'Para añadir un conjunto de widgets a las plantillas, utilice la siguiente sintaxis:',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Nombre del conjunto de widgets&quot;$&gt;</strong>',
	'Your changes to the widget set have been saved.' => 'Se han guardado los cambios al conjunto de widgets.',
	'You have successfully deleted the selected widget set(s) from your blog.' => 'Borró con éxito los conjuntos de widgets seleccionados del blog.',
	'No widget sets could be found.' => 'No se ha encontrado ningún grupo de widgets.',
	'Create widget template' => 'Crear plantilla de widget',

## tmpl/cms/login.tmpl
	'Sign in' => 'Registrarse',
	'Your Movable Type session has ended.' => 'Finalizó su sesión en Movable Type.',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Su sesión de Movable Type finalizó. Si desea identificarse de nuevo, hágalo abajo.',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Su sesión de Movable Type finalizó. Por favor, identifíquese de nuevo para continuar con esta acción.',
	'Sign In (s)' => 'Identifíquese (s)',
	'Forgot your password?' => '¿Olvidó su contraseña?',

## tmpl/cms/pinging.tmpl
	'Pinging sites...' => 'Enviando pings a sitios...',

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

## tmpl/cms/popup/rebuilt.tmpl
	'Success' => 'OK',
	'The files for [_1] have been published.' => 'Los ficheros de [_1] han sido publicados.',
	'Your [_1] archives have been published.' => 'Se han publicado los archivos [_1].',
	'Your [_1] templates have been published.' => 'Se han publicado las plantillas [_1].',
	'Publish time: [_1].' => 'Tiempo de publicación: [_1].',
	'View your site.' => 'Ver sitio.',
	'View this page.' => 'Ver página.',
	'Publish Again (s)' => 'Publicar otra vez (s)',
	'Publish Again' => 'Publicar otra vez.',

## tmpl/cms/preview_entry.tmpl
	'Preview [_1] Content' => 'Vista previa del contenido de [_1]',
	'Return to the compose screen' => 'Regresar a la ventana de composición',
	'Return to the compose screen (e)' => 'Regresar a la ventana de composición (e)',
	'Save this entry' => 'Guardar entrada',
	'Save this entry (s)' => 'Guardar entrada (s)',
	'Re-Edit this entry' => 'Re-editar entrada',
	'Re-Edit this entry (e)' => 'Re-editar entrada (e)',
	'Save this page' => 'Guardar página',
	'Save this page (s)' => 'Guardar página (s)',
	'Re-Edit this page' => 'Re-editar página',
	'Re-Edit this page (e)' => 'Re-editar página (e)',

## tmpl/cms/preview_strip.tmpl
	'Publish this entry' => 'Publicar entrada',
	'Publish this entry (s)' => 'Publicar entrada (s)',
	'Publish this page' => 'Publicar página',
	'Publish this page (s)' => 'Publicar página (s)',
	'You are previewing the entry entitled &ldquo;[_1]&rdquo;' => 'Está en la vista previa de la entrada titulada &ldquo;[_1]&rdquo;',
	'You are previewing the page entitled &ldquo;[_1]&rdquo;' => 'Está en la vista previa de la página titulada &ldquo;[_1]&rdquo;',

## tmpl/cms/preview_template_strip.tmpl
	'You are previewing the template named &ldquo;[_1]&rdquo;' => 'Esta es la vista previa de la plantilla &ldquo;[_1]&rdquo;',
	'(Publish time: [_1] seconds)' => '(Tiempo de publicación: [_1] segundos)',
	'Save this template (s)' => 'Guardar plantilla (s)',
	'Save this template' => 'Guardar plantilla',
	'Re-Edit this template (e)' => 'Re-editar plantilla (e)',
	'Re-Edit this template' => 'Re-editar plantilla',
	'There are no categories in this blog.  Limited preview of category archive templates is possible with a virtual category displayed.  Normal, non-preview output cannot be generated by this template unless at least one category is created.' => 'No hay categorías en este blog. La vista previa de plantillas de archivo de categorías es posible mediante una categoría virtual. La salida normal, que no es vista previa, no puede generarse mediante esta plantilla a menos que cree una categoría.',

## tmpl/cms/rebuilding.tmpl
	'Publishing...' => 'Publicando...',
	'Publishing [_1]...' => 'Publicando [_1]...',
	'Publishing <em>[_1]</em>...' => 'Publicando <em>[_1]</em>...',
	'Publishing [_1] [_2]...' => 'Publicando [_1] [_2]...',
	'Publishing [_1] dynamic links...' => 'Publicando enlaces dinámicos [_1]...',
	'Publishing [_1] archives...' => 'Publicando archivos [_1]...',
	'Publishing [_1] templates...' => 'Publicando plantillas [_1]...',
	'Complete [_1]%' => '[_1]% completado',

## tmpl/cms/recover_lockout.tmpl
	'Recovered from lockout' => 'Recuperado del bloqueo.',
	q{User '[_1]' has been unlocked.} => q{El usuario '[_1]' ha sido desbloqueado.},

## tmpl/cms/recover_password_result.tmpl
	'Recover Passwords' => 'Recuperar contraseñas',
	'No users were selected to process.' => 'No se seleccionaron usuarios a procesar.',
	'Return' => 'Volver',

## tmpl/cms/refresh_results.tmpl
	'Template Refresh' => 'Refrescar plantilla',
	'No templates were selected to process.' => 'No se han seleccionado plantillas para procesar.',
	'Return to templates' => 'Volver a las plantillas',

## tmpl/cms/restore_end.tmpl
	q{Make sure that you remove the files that you restored from the 'import' folder, so that if/when you run the restore process again, those files will not be re-restored.} => q{Asegúrese de que elimina los ficheros que ha restaurado de la carpeta 'importar', por si ejecuta el proceso en otra ocasión que éstos no vuelvan a restaurar.},

## tmpl/cms/restore_start.tmpl
	'Restoring Movable Type' => 'Restaurando Movable Type',

## tmpl/cms/restore.tmpl
	'Restore from a Backup' => 'Resturar una copia de seguridad',
	'Perl module XML::SAX and/or some of its dependencies are missing.  Movable Type cannot restore the system without these modules.' => 'No se encuentra el módulo de Perl XML::SAX y/o algunas de sus dependencias. Movable Type no puede restaurar el sistema sin estos módulos.',
	'Backup File' => 'Fichero de respaldo',
	q{If your backup file is located on a remote computer, you can upload it here.  Otherwise, Movable Type will automatically look in the 'import' folder within your Movable Type directory.} => q{If your backup file is located on a remote computer, you can upload it here.  Otherwise, Movable Type will automatically look in the 'import' folder within your Movable Type directory.},
	'Check this and files backed up from newer versions can be restored to this system.  NOTE: Ignoring Schema Version can damage Movable Type permanently.' => 'Activa esta opción y los ficheros con copias de seguridad de versiones más recientes podrán restaurarse en este sistema. NOTA: Ignorar la versión del esquema puede dañar Movable Type permanentemente.',
	'Ignore schema version conflicts' => 'Igrar conflictos de versión de esquemas',
	'Allow existing global templates to be overwritten by global templates in the backup file.' => 'Permitir la sobreescritura de las plantillas globales existentes por las de la copia de seguridad.',
	'Overwrite global templates.' => 'Sobreescribir las plantillas globales.',
	'Restore (r)' => 'Restaurar (r)',

## tmpl/cms/search_replace.tmpl
	'You must select one or more item to replace.' => 'Debe seleccionar uno o más elementos a reemplazar.',
	'Search Again' => 'Buscar de nuevo',
	'Case Sensitive' => 'Distinguir mayúsculas y minúsculas',
	'Regex Match' => 'Expresión regular',
	'Limited Fields' => 'Campos limitados',
	'Date Range' => 'Rango de fechas',
	'Reported as Spam?' => '¿Marcado como spam?',
	'_DATE_FROM' => 'De',
	'_DATE_TO' => 'A',
	'Submit search (s)' => 'Buscar (s)',
	'Search For' => 'Buscar',
	'Replace With' => 'Reemplazar con',
	'Replace Checked' => 'Reemplazar selección',
	'Successfully replaced [quant,_1,record,records].' => '[quant,_1,registro reemplazado,registros reemplazados] con éxito.',
	'Showing first [_1] results.' => 'Primeros [_1] resultados.',
	'Show all matches' => 'Mostrar todos los resultados',
	'[quant,_1,result,results] found' => '[quant,_1,resultado]',

## tmpl/cms/setup_initial_website.tmpl
	'Create Your First Website' => 'Cree su primer sitio web',
	q{In order to properly publish your website, you must provide Movable Type with your website's URL and the filesystem path where its files should be published.} => q{Para poder publicar correctamente su sitio web debe indicar a Movable Type la URL de su sitio web y la ruta en el sistema donde se publicarán los ficheros.},
	'Support directory does not exists or not writable by the web server. Change the ownership or permissions on this directory' => 'El directorio de soporte no existe o el servidor web no puede escribir en él. Compruebe los permisos del directorio.',
	'My First Website' => 'Mi primer sitio web',
	q{The 'Website Root' is the directory in your web server's filesystem where Movable Type will publish the files for your website. The web server must have write access to this directory.} => q{La 'Ruta del sitio' es el directorio del servidor donde Movable Type publicará los ficheros del sitio web. El servidor web debe tener permisos de escritura en este directorio.},
	'Select the theme you wish to use for this new website.' => 'Seleccione el tema que desea usar en este sitio web nuevo.',
	'Finish install (s)' => 'Finalizar la instalación (s)',
	'Finish install' => 'Finalizar instalación',
	'The website name is required.' => 'El nombre del sitio web es obligatorio.',
	'The website URL is required.' => 'La URL del sitio web es obligatoria.',
	'Your website URL is not valid.' => 'La URL del sitio web no es válida.',
	'The publishing path is required.' => 'La ruta de publicación es obligatoria.',
	'The timezone is required.' => 'La zona horaria es obligatoria.',

## tmpl/cms/system_check.tmpl
	'Total Users' => 'Usuarios Totales',
	'Memcache Status' => 'Estado de memcache',
	'configured' => 'configurado',
	'disabled' => 'desactivado',
	'Memcache is [_1].' => 'Memcache es [_1].',
	'available' => 'disponible',
	'unavailable' => 'no disponible',
	'Memcache Server is [_1].' => 'El servidor de memcache es [_1].',
	'Server Model' => 'Modelo de servidor',
	q{Movable Type could not find the script named 'mt-check.cgi'. To resolve this issue, ensure that the mt-check.cgi script exists and that the CheckScript configuration parameter (if it is necessary) references it properly.} => q{Movable Type no pudo encontrar el script llamado 'mt-check.cgi'. Para solucionar este problema, asegúrese de que el script mt-check.cgi existe y que el parámetro de configuración CheckScript (si fuera necesario) lo referencia correctamente.},

## tmpl/cms/theme_export_replace.tmpl
	q{Export theme folder already exists '[_1]'. You can overwrite a existing theme, or cancel to change the Basename?} => q{La carpeta para la exportación del tema ya existe '[_1]'. Puede sobreescribir un tema existente, cancelar o cambiar el nombre de la carpeta.},
	'Overwrite' => 'Sobreescribir',

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

## tmpl/cms/upgrade.tmpl
	'Time to Upgrade!' => '¡Hora de actualizar!',
	'Upgrade Check' => 'Comprobar actualización',
	'Do you want to proceed with the upgrade anyway?' => '¿Desea proceder en cualquier caso con la actualización?',
	q{A new version of Movable Type has been installed.  We'll need to complete a few tasks to update your database.} => q{Se ha instalado una nueva versión de Movable Type.  Debemos realizar algunas tareas para actualizar su base de datos.},
	q{The Movable Type Upgrade Guide can be found <a href='[_1]' target='_blank'>here</a>.} => q{La Guía de Actualización de Movable Type se encuentra <a href='[_1]' target='_blank'>aquí</a>.},
	'In addition, the following Movable Type components require upgrading or installation:' => 'Además, los siguientes componentes de Movable Type necesitan actualización o instalación:',
	'The following Movable Type components require upgrading or installation:' => 'Los siguientes componentes de Movable Type necesitan actualización o instalación:',
	'Begin Upgrade' => 'Comenzar actualización',
	'Congratulations, you have successfully upgraded to Movable Type [_1].' => 'Felicidades, actualizó con éxito a Movable Type [_1].',
	'Your Movable Type installation is already up to date.' => 'Su instalación de Movable Type ya está actualizada.',

## tmpl/cms/view_log.tmpl
	'The activity log has been reset.' => 'Se reinició el registro de actividad.',
	'System Activity Log' => 'Registro de Actividad del Sistema',
	'Filtered' => 'Filtrado',
	'Filtered Activity Feed' => 'Sindicación de la actividad del filtrado',
	'Download Filtered Log (CSV)' => 'Descargar registro filtrado (CSV)',
	'Showing all log records' => 'Mostrando todos los registros',
	'Showing log records where' => 'Mostrando los registros donde',
	'Show log records where' => 'Mostrar registros donde',
	'level' => 'nivel',
	'classification' => 'clasificación',

## tmpl/cms/view_rpt_log.tmpl
	'Schwartz Error Log' => 'Histórico de errores de Schwartz',
	'Showing all Schwartz errors' => 'Mostrando todos los errores de Schwartz',

## tmpl/cms/widget/blog_stats_comment.tmpl
	'Most Recent Comments' => 'Últimos comentarios',
	'[_1] [_2], [_3] on [_4]' => '[_1] [_2], [_3] en [_4]',
	'View all comments' => 'Mostrar todos los comentarios',
	'No comments available.' => 'No hay comentarios disponibles',

## tmpl/cms/widget/blog_stats_entry.tmpl
	'Most Recent Entries' => 'Últimas entradas',
	'Posted by [_1] [_2] in [_3]' => 'Publicado por [_1] [_2] en [_3]',
	'Posted by [_1] [_2]' => 'Publicado por [_1] [_2]',
	'Tagged: [_1]' => 'Etiquetas: [_1]',
	'View all entries' => 'Mostrar todas las entradas',
	'No entries have been created in this blog. <a href="[_1]">Create a entry</a>' => 'No se han creado entradas en este blog. <a href="[_1]">Crear una entrada</a>',

## tmpl/cms/widget/blog_stats_recent_entries.tmpl
	'[quant,_1,entry,entries] tagged &ldquo;[_2]&rdquo;' => '[quant,_1,entrada etiquetada,entradas etiquetadas] &ldquo;[_2]&rdquo;',
	'No entries available.' => 'Sin entradas disponibles.',

## tmpl/cms/widget/blog_stats_tag_cloud.tmpl

## tmpl/cms/widget/blog_stats.tmpl
	'Error retrieving recent entries.' => 'Error obteniendo entradas recientes.',
	'Loading recent entries...' => 'Cargando entradas recientes',
	'Jan.' => 'Ene.',
	'Feb.' => 'Feb.',
	'March' => 'Marzo',
	'April' => 'Abril',
	'May' => 'Mayo',
	'June' => 'Junio',
	'July.' => 'Jul.',
	'Aug.' => 'Ago.',
	'Sept.' => 'Sep.',
	'Oct.' => 'Oct.',
	'Nov.' => 'Nov.',
	'Dec.' => 'Dic.',
	'[_1] [_2] - [_3] [_4]' => '[_1] [_2] - [_3] [_4]',
	'You have <a href=\'[_3]\'>[quant,_1,comment,comments] from [_2]</a>' => 'Tiene <a href=\'[_3]\'>[quant,_1,comentario,comentarios] de [_2]</a>',
	'You have <a href=\'[_3]\'>[quant,_1,entry,entries] from [_2]</a>' => 'Tiene <a href=\'[_3]\'>[quant,_1,entrada] de [_2]</a>',

## tmpl/cms/widget/custom_message.tmpl
	'This is you' => 'Este es usted',
	'Welcome to [_1].' => 'Bienvenido a [_1].',
	'You can manage your blog by selecting an option from the menu located to the left of this message.' => 'Puede administrar su blog seleccionando una opción del menú situado a la izquierda de este mensaje.',
	'If you need assistance, try:' => 'Si necesita ayuda, consulte:',
	'Movable Type User Manual' => 'Manual del usuario de Movable Type',
	'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.com/movabletype/support',
	'Movable Type Technical Support' => 'Soporte técnico de Movable Type',
	'Movable Type Community Forums' => 'Foros comunitarios de Movable Type',
	'Change this message.' => 'Cambiar este mensaje.',
	'Edit this message.' => 'Editar este mensaje.',

## tmpl/cms/widget/favorite_blogs.tmpl
	'Your recent websites and blogs' => 'Blogs y sitios webs recientes',
	'No website could be found. [_1]' => 'No se encontró el sitio web. [_1]',
	'Create a new' => 'Crear una nueva',
	'No blogs could be found.' => 'No se pudo encontrar ningún blog.',

## tmpl/cms/widget/mt_news.tmpl
	'News' => 'Noticias',
	'No Movable Type news available.' => 'No hay noticias de Movable Type disponibles.',

## tmpl/cms/widget/mt_shortcuts.tmpl
	'Handy Shortcuts' => 'Enlaces útiles',
	'Import Content' => 'Importar contenido',
	'Blog Preferences' => 'Preferencias del blog',

## tmpl/cms/widget/notification_dashboard.tmpl
	'Messages from the system' => 'Mensajes del sistema',

## tmpl/cms/widget/personal_stats.tmpl
	'Your <a href="[_1]">last entry</a> was [_2] in <a href="[_3]">[_4]</a>.' => 'La <a href="[_1]">última entrada</a> estaba [_2] en <a href="[_3]">[_4]</a>.',
	'Your last entry was [_1] in <a href="[_2]">[_3]</a>.' => 'Su última entrada fue [_1] en <a href="[_2]">[_3]</a>.',
	'<a href="[_1]">[quant,_2,entry,entries]</a>' => '<a href="[_1]">[quant,_2,entrada,entradas]</a>',
	'[quant,_1,entry,entries]' => '[quant,_1,entrada,entradas]',
	'<a href="[_1]">[quant,_2,page,pages]</a>' => '<a href="[_1]">[quant,_2,página,páginas]</a>',
	'[quant,_1,page,pages]' => '[quant,_1,página,páginas]',
	'<a href="[_1]">[quant,_2,comment,comments]</a>' => '<a href="[_1]">[quant,_2,comentario,comentarios]</a>',
	'[quant,_1,comment,comments]' => '[quant,_1,comentario,comentarios]',
	'<a href="[_1]">[quant,_2,draft,drafts]</a>' => '<a href="[_1]">[quant,_2,borrador,borradores]</a>',
	'[quant,_1,draft,drafts]' => '[quant,_1,borrador,borradores]',

## tmpl/cms/widget/recent_blogs.tmpl
	'No blogs could be found. [_1]' => 'No se encontraron blogs. [_1]',

## tmpl/cms/widget/recent_websites.tmpl
	'[quant,_1,blog,blogs]' => '[quant,_1,blog,blogs]',

## tmpl/cms/widget/site_stats.tmpl
	'Stats for [_1]' => 'Estadísticas de [_1]',
	'Statistics Settings' => 'Configuración de estadísticas',

## tmpl/comment/auth_aim.tmpl
	'Your AIM or AOL Screen Name' => 'Su usuario de AIM o AOL',
	'Sign in using your AIM or AOL screen name. Your screen name will be displayed publicly.' => 'Identifíquese usando su usuario de AIM o AOL. El nombre del usuario se mostrará públicamente.',

## tmpl/comment/auth_googleopenid.tmpl
	'Sign in using your Gmail account' => 'Identifíquese usando su cuenta de Gmail',
	'Sign in to Movable Type with your[_1] Account[_2]' => 'Identifíquese en Movable Type con su cuenta [_1] [_2]',

## tmpl/comment/auth_hatena.tmpl
	'Your Hatena ID' => 'Su ID de Hatena',

## tmpl/comment/auth_livedoor.tmpl

## tmpl/comment/auth_livejournal.tmpl
	'Your LiveJournal Username' => 'Su usuario de LiveJournal',
	'Learn more about LiveJournal.' => 'Más información sobre LiveJournal.',

## tmpl/comment/auth_openid.tmpl
	'OpenID URL' => 'URL de OpenID',
	'Sign in with one of your existing third party OpenID accounts.' => 'Identifíquese usando una de sus cuentas externas de OpenID.',
	'http://www.openid.net/' => 'http://www.openid.net/',
	'Learn more about OpenID.' => 'Más información sobre OpenID.',

## tmpl/comment/auth_typepad.tmpl
	'TypePad is a free, open system providing you a central identity for posting comments on weblogs and logging into other websites. You can register for free.' => 'TypePad es un sistema gratuito y abierto que le provee una identidad centralizada para la publicación de comentarios en weblogs e identificarse en otros sitios web. Puede registrarse gratuitamente.',
	'Sign in or register with TypePad.' => 'Identifíquese o regístrese en TypePad.',

## tmpl/comment/auth_vox.tmpl
	'Your Vox Blog URL' => 'La URL de su blog de Vox',
	'Learn more about Vox.' => 'Más información sobre Vox.',

## tmpl/comment/auth_wordpress.tmpl
	'Your Wordpress.com Username' => 'Su usuario de Wordpress.com',
	'Sign in using your WordPress.com username.' => 'Identifíquese usando su usuario de WordPress.com.',

## tmpl/comment/auth_yahoojapan.tmpl
	'Turn on OpenID for your Yahoo! Japan account now' => 'Active OpenID en su cuenta de Yahoo! Japan ahora',

## tmpl/comment/auth_yahoo.tmpl
	'Turn on OpenID for your Yahoo! account now' => 'Active ahora OpenID para su cuenta de Yahoo',

## tmpl/comment/error.tmpl
	'Back (s)' => 'Regresar (s)',

## tmpl/comment/login.tmpl
	'Sign in to comment' => 'Identifíquese para comentar',
	'Sign in using' => 'Identifíquese usando',
	'Not a member? <a href="[_1]">Sign Up</a>!' => '¿No es miembro? ¡<a href="[_1]">Regístrese</a>!',

## tmpl/comment/profile.tmpl
	'Your Profile' => 'Su perfil',
	'Your login name.' => 'Nombre de su usuario.',
	'The name appears on your comment.' => 'El nombre que aparece en su comentario.',
	'Your email address.' => 'Dirección de correo electrónico.',
	'Select a password for yourself.' => 'Seleccione su contraseña.',
	'The URL of your website. (Optional)' => 'La URL del sitio web (opcional)',
	'Return to the <a href="[_1]">original page</a>.' => 'Volver a la <a href="[_1]">página original</a>.',

## tmpl/comment/register.tmpl
	'Create an account' => 'Crear una cuenta',
	'Register' => 'Registrarse',

## tmpl/comment/signup_thanks.tmpl
	'Thanks for signing up' => 'Gracias por inscribirse',
	'Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].' => 'Antes de poder comentar, debe completar el proceso de registro confirmando su cuenta. Se le ha enviado un correo a [_1].',
	'To complete the registration process you must first confirm your account. An email has been sent to [_1].' => 'Para completar el proceso de registro, primeramente debe confirmar su cuenta. Se le ha enviado un correo a [_1].',
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'Para confirmar y activar su cuenta, por favor, compruebe su correo y haga clic en el correo que le acabamos de enviar.',
	'Return to the original entry.' => 'Volver a la entrada original.',
	'Return to the original page.' => 'Volver a la página original.',

## tmpl/comment/signup.tmpl
	'Password Confirm' => 'Confirmar contraseña',

## tmpl/data_api/include/login_mt.tmpl

## tmpl/data_api/login.tmpl

## tmpl/error.tmpl
	'Missing Configuration File' => 'Fichero de configuración no encontrado',
	'_ERROR_CONFIG_FILE' => 'El fichero de configuración de Your Movable Type no existe o no se puede leer correctamente. Por favor, consulte la sección <a href="javascript:void(0)">Instalación y configuración</a> del manual de Movable Type manual para más información.',
	'Database Connection Error' => 'Error de conexión a la base de datos',
	'_ERROR_DATABASE_CONNECTION' => 'Las opciones de configuración de su base de datos o son incorrectas o no están presentes en el fichero de configuración de Movable Type. Por favor, consulte la sección <a href="javascript:void(0)">Instalación y configuración</a> del manual de Movable Type para más información',
	'CGI Path Configuration Required' => 'Se necesita la configuración de la ruta de CGI',
	'_ERROR_CGI_PATH' => 'La opción de configuración CGIPath no es válida o no se encuentra en el fichero de configuración de Movable Type. Por favor, consulte la sección <a href="javascript:void(0)">Instalación y configuración</a> del manual de Movable Type manual para más información.',

## tmpl/feeds/error.tmpl
	'Movable Type Activity Log' => 'Registro de actividad de Movable Type',

## tmpl/feeds/feed_comment.tmpl
	'Unpublish' => 'Despublicar',
	'More like this' => 'Más como éstos',
	'From this blog' => 'De este blog',
	'On this entry' => 'En esta entrada',
	'By commenter identity' => 'Por identidad del comentarista',
	'By commenter name' => 'Por nombre del comentarista',
	'By commenter email' => 'Por correo electrónico del comentarista',
	'By commenter URL' => 'Por URL del comentarista',
	'On this day' => 'En este día',

## tmpl/feeds/feed_entry.tmpl
	'From this author' => 'De este autor',

## tmpl/feeds/feed_page.tmpl

## tmpl/feeds/feed_ping.tmpl
	'Source blog' => 'Blog origen',
	'By source blog' => 'Por blog origen',
	'By source title' => 'Por título origen',
	'By source URL' => 'Por URL origen',

## tmpl/feeds/login.tmpl
	'This link is invalid. Please resubscribe to your activity feed.' => 'Este enlace no es válido. Por favor, resuscríbase a la fuente de sindicación de actividades.',

## tmpl/wizard/blog.tmpl
	'Setup Your First Blog' => 'Configure su primer blog',
	q{In order to properly publish your blog, you must provide Movable Type with your blog's URL and the path on the filesystem where its files should be published.} => q{Para publicar correctamente el blog, debe proveer a Movable Type la URL del blog y la ruta en el sistema donde se publicarán sus ficheros.},
	'My First Blog' => 'Mi primer blog',
	'Publishing Path' => 'Ruta de publicación',
	q{Your 'Publishing Path' is the path on your web server's file system where Movable Type will publish all the files for your blog. Your web server must have write access to this directory.} => q{La 'Ruta de publicación' es la ruta en el sistema de archivos del servidor donde Movable Type publicará todos los ficheros del blog. El servidor web debe poder escribir en este directorio.},

## tmpl/wizard/cfg_dir.tmpl
	'Temporary Directory Configuration' => 'Configuración del directorio temporal',
	'You should configure you temporary directory settings.' => 'Debe configurar las opciones del directorio temporal.',
	q{Your TempDir has been successfully configured. Click 'Continue' below to continue configuration.} => q{TempDir se ha configurado con éxito. Para continuar con la configuración, haga clic a 'Continuar' abajo.},
	'[_1] could not be found.' => '[_1] no pudo encontrarse.',
	'TempDir is required.' => 'TempDir es necesario.',
	'TempDir' => 'TempDir',
	'The physical path for temporary directory.' => 'La ruta al directorio temporal.',

## tmpl/wizard/complete.tmpl
	'Configuration File' => 'Archivo de configuración',
	'The [_1] configuration file cannot be located.' => 'El archivo de configuración [_1] no puede ser localizado',
	q{Please use the configuration text below to create a file named 'mt-config.cgi' in the root directory of [_1] (the same directory in which mt.cgi is found).} => q{Utilice por favor el texto de la configuración abajo para crear un archivo llamado 'mt-config.cgi' en la raíz del directorio de [_1] (el mismo directorio en el cual se encuentra mt.cgi).},
	'The wizard was unable to save the [_1] configuration file.' => 'El asistente de instalación no ha podido guardar el [_1] archivo de configuración.',
	q{Confirm that your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click 'Retry'.} => q{Confirme que el servidor web puede escribir en su directorio de inicio [_1] (el directorio que contiene mt.cgi) y luego haga clic en 'Reintentar'.},
	q{Congratulations! You've successfully configured [_1].} => q{¡Felicidades! Ha configurado con éxito [_1].},
	'Show the mt-config.cgi file generated by the wizard' => 'Mostrar el archivo mt-config.cgi generado por el asistente de instalación',
	'The mt-config.cgi file has been created manually.' => 'El fichero mt-config.cgi fue creado manualmente.',
	'Retry' => 'Reintentar',

## tmpl/wizard/configure.tmpl
	'Database Configuration' => 'Configuración de la base de datos',
	'Your database configuration is complete.' => 'Se ha completado la configuración de la base de datos.',
	'You may proceed to the next step.' => 'Puede continuar con el siguiente paso.',
	'Show Current Settings' => 'Mostrar configuración actual',
	'Please enter the parameters necessary for connecting to your database.' => 'Por favor, introduzca los parámetros necesarios para la conexión con la base de datos.',
	'Database Type' => 'Tipo de base de datos',
	'Select One...' => 'Seleccione uno...',
	'http://www.movabletype.org/documentation/[_1]' => 'http://www.movabletype.org/documentation/[_1]',
	'Is your preferred database not listed? View the <a href="[_1]" target="_blank">Movable Type System Check</a> see if additional modules are necessary.' => '¿Su base de datos preferida no está en la lista? Consulte la <a href="[_1]" target="_blank">Comprobación del Sistema de Movable Type</a> para ver si se necesitan otros módulos.',
	'Once installed, <a href="javascript:void(0)" onclick="[_1]">click here to refresh this screen</a>.' => 'Una vez instalado, haga <a href="javascript:void(0)" onclick="[_1]">clic aquí para recargar esta pantalla</a>.',
	'Read more: <a href="[_1]" target="_blank">Setting Up Your Database</a>' => 'Más información: <a href="[_1]" target="_blank">Configuración de la base de datos</a>',
	'Show Advanced Configuration Options' => 'Mostrar opciones de configuración avanzadas',
	'Test Connection' => 'Probar la Conexión',
	'You must set your Database Path.' => 'Debe definir la ruta de la base de datos.',
	'You must set your Username.' => 'Debe introducir el nombre del usuario.',
	'You must set your Database Server.' => 'Debe introducir el servidor de base de datos.',

## tmpl/wizard/optional.tmpl
	'Mail Configuration' => 'Configuración del correo electrónico',
	'Your mail configuration is complete.' => 'Se ha completado la configuración del correo.',
	'Check your email to confirm receipt of a test email from Movable Type and then proceed to the next step.' => 'Compruebe su correo para confirmar la recepción del mensaje de prueba de Movable Type y luego continúe con el paso siguiente.',
	'Show current mail settings' => 'Mostrar configuración actual del correo',
	'Periodically Movable Type will send email for password recovery, to inform authors of new comments, and other events. If not using Sendmail (default on unix servers), an SMTP Server must be specified.' => 'Periódicamente, Movable Type enviará un correo para informar a los usuarios sobre los nuevos comentarios y otros eventos. Para que estos correos se envíen correctamente, debe decirle a Movable Type cómo enviarlos.',
	'An error occurred while attempting to send mail: ' => 'Ocurrió un error intentando enviar un mensaje de correo electrónico: ',
	'Send mail via:' => 'Enviar correo vía:',
	'Sendmail Path' => 'Ruta de sendmail',
	'The physical file path for your Sendmail binary.' => 'Ruta física del fichero binario de sendmail.',
	'Outbound Mail Server (SMTP)' => 'Servidor de correo saliente (SMTP)',
	'Address of your SMTP Server.' => 'Dirección del servidor SMTP.',
	'Port number for Outbound Mail Server' => 'Número de puerto para el servidor de correo saliente',
	'Port number of your SMTP Server.' => 'Número de puerto para el servidor SMTP.',
	'Use SMTP Auth' => 'Usar autentificación SMTP',
	'SMTP Auth Username' => 'Usuario para autentificación SMTP',
	'Username for your SMTP Server.' => 'Usuario para el servidor SMTP.',
	'SMTP Auth Password' => 'Contraseña de autentificación SMTP',
	'Password for your SMTP Server.' => 'Contraseña para el servidor SMTP.',
	'SSL Connection' => 'Conexión SSL',
	'Cannot use [_1].' => 'No se puede usar [_1].',
	'Do not use SSL' => 'No usar SSL',
	'Use SSL' => 'Usar SSL',
	'Use STARTTLS' => 'Usar STARTTLS',
	'Send Test Email' => 'Enviar mensaje de comprobación',
	'Mail address to which test email should be sent' => 'La dirección de correo a la que debe enviarse el correo de prueba',
	'Skip' => 'Ignorar',
	'You must set the SMTP server port number.' => 'Debe indicar el puerto del servidor SMTP.',
	'This field must be an integer.' => 'Este campo debe ser un número entero.',
	'You must set the system email address.' => 'Debe indicar la dirección de correo del sistema.',
	'You must set the Sendmail path.' => 'Debe indicar la ruta a sendmail.',
	'You must set the SMTP server address.' => 'Debe indicar la dirección del servidor SMTP.',
	'You must set a username for the SMTP server.' => 'Debe indicar el usuario del servidor SMTP.',
	'You must set a password for the SMTP server.' => 'Debe indicar la contraseña del servidor SMTP.',

## tmpl/wizard/packages.tmpl
	'Requirements Check' => 'Comprobación de requerimientos',
	q{The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your blog's data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the 'Retry' button.} => q{Los siguientes módulos de Perl son necesarios para la conexión con la base de datos. Movable Type necesita una base de datos para guardar los datos del blog. Por favor, instale los paquetes listados aquí para continuar. Cuando lo haya hecho, haga clic en el botón 'Reintentar'.},
	'All required Perl modules were found.' => 'Se encontraron todos los módulos de Perl necesarios.',
	'You are ready to proceed with the installation of Movable Type.' => 'Está listo para continuar con la instalación de Movable Type.',
	'Some optional Perl modules could not be found. <a href="javascript:void(0)" onclick="[_1]">Display list of optional modules</a>' => 'No se encontraron algunos módulos opcionales de Perl. <a href="javascript:void(0)" onclick="[_1]">Mostrar lista de módulos opcionales</a>',
	'One or more Perl modules required by Movable Type could not be found.' => 'No se encontraron uno o varios módulos de Perl necesarios.',
	q{The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the 'Retry' button to re-test for these packages.} => q{Los siguientes módulos de Perl son necesarios para que Movable Type se ejecute correctamente. Una vez los haya instalado, haga clic en el botón 'Reintentar' para realizar la comprobación nuevamente.},
	q{Some optional Perl modules could not be found. You may continue without installing these optional Perl modules. They may be installed at any time if they are needed. Click 'Retry' to test for the modules again.} => q{No se encontraron algunos módulos opcionales de Perl. Puede continuar sin instalarlos. Podrá instalarlos cuando le sean necesarios. Haga clic en 'Reintentar' para comprobar los módulos otra vez.},
	'Missing Database Modules' => 'Módulos de base de datos no encontrados',
	'Missing Optional Modules' => 'Módulos opcionales no encontrados',
	'Missing Required Modules' => 'Módulos necesarios no encontrados',
	'Minimal version requirement: [_1]' => 'Versión mínima requerida: [_1]',
	'http://www.movabletype.org/documentation/installation/perl-modules.html' => 'http://www.movabletype.org/documentation/installation/perl-modules.html',
	'Learn more about installing Perl modules.' => 'Más información sobre la instalación de módulos de Perl.',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'El servidor tiene instalados todos los módulos necesarios; no necesita realizar ninguna instalación adicional.',

## tmpl/wizard/start.tmpl
	'Configuration File Exists' => 'Configuración de archivos existentes',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Movable Type necesita que JavaScript esté disponible en el navegador. Por favor, active JavaScript y recargue esta página para continuar.',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Este asistente le ayudará a configurar las opciones básicas necesarias para ejecutar Movable Type.',
	'Default language.' => 'Idioma predefinido.',
	'Configure Static Web Path' => 'Configurar ruta del web estático',
	q{<strong>Error: '[_1]' could not be found.</strong>  Please move your static files to the directory first or correct the setting if it is incorrect.} => q{<strong>Error: '[_1]' no se pudo encontrar.</strong>  Por favor, mueva los ficheros estáticos al primer directorio o corrija la configuración si no es correcta.},
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type viene con un directorio llamado [_1] que contiene una serie de ficheros importantes tales como imágenes, ficheros javascript y hojas de estilo.',
	q{The [_1] directory is in the main Movable Type directory which this wizard script resides, but due to your web server's configuration, the [_1] directory is not accessible in this location and must be moved to a web-accessible location (e.g., your web document root directory).} => q{El directorio [_1] está en el directorio principal de Movable Type que recide en el script de instalación, pero depende de la configuración de su web server, el directorio [_1] no es accesible en este lugar y debe ser removido a un lugar de web accesible (e.g., su documento de raíz del directorio web)},
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Este directorio se ha renombrado o movido a un lugar fuera del directorio de Movable Type.',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => 'Especifique debajo la ruta cuando el directorio [_1] sea accesible vía web.',
	'This URL path can be in the form of [_1] or simply [_2]' => 'La dirección URL puede estar en la forma de [_1] o simplemente [_2]',
	'This path must be in the form of [_1]' => 'Esta ruta debe tener el formato [_1]',
	'Static web path' => 'Ruta estática del web',
	'Static file path' => 'Ruta estática de los ficheros',
	'Begin' => 'Comenzar',
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => 'Una configuración del archivo (mt-config,cgi) existe, <a href="[_1]">identificarse</a> a Movable Type.',
	'To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page' => 'Para crear una nueva configuración del archivo usando Wizard, borre la configuración actual del archivo y actualice la página',

## addons/Commercial.pack/config.yaml
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype/',
	'Professional designed, well structured and easily adaptable web site. You can customize default pages, footer and top navigation easily.' => 'Sitio web con diseños profesionales, bien estructurados y fácilmente adaptables. Puede personalizar de forma sencilla las páginas predefinidas, los pies y la navegación.',
	q{_PWT_ABOUT_BODY} => q{
<p><strong>Vuelva a colocar el texto de ejemplo con su propia información.</strong></p>
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In nec tellus sed turpis varius sagittis. Nullam pulvinar. Fusce dapibus neque pellentesque nulla. Maecenas condimentum quam. Vestibulum pretium fringilla quam. Nam elementum. Suspendisse odio magna, aliquam vitae, vulputate et, dignissim at, pede. Integer pellentesque orci at nibh. Morbi ante.</p>

<p>Maecenas convallis mattis justo. Ut mauris sapien, consequat a, bibendum vitae, sagittis ac, nisi. Nulla et sapien. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Ut condimentum turpis ut elit. Quisque ultricies sollicitudin justo. Duis vitae magna nec risus pulvinar ultricies.</p>
<!-- remove this link after editing -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl + '?__mode=view&_type=page&id=' + page_id + '&blog_id=' + blog_id; return false">Editar este contenido</a>
</p>
	 },
	q{_PWT_CONTACT_BODY} => q{
<p><strong>Vuelva a colocar el texto de ejemplo con su propia información.</strong></p>

<p>Nos encantaría saber de usted. Enviar correo electrónico a email (at) domainname.com</p>

<!-- remove this link after editing -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl + '?__mode=view&_type=page&id=' + page_id + '&blog_id=' + blog_id; return false">Editar este contenido</a>
</p>
	 },
	'Welcome to our new website!' => '¡Bienvenido a nuestro nuevo sitio!',
	q{_PWT_HOME_BODY} => q{
<p><strong>Vuelva a colocar el texto de ejemplo con su propia información.</strong></p>
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In nec tellus sed turpis varius sagittis. Nullam pulvinar. Fusce dapibus neque pellentesque nulla. Maecenas condimentum quam. Aliquam erat volutpat. Ut placerat porta nibh. Donec vitae nulla. Pellentesque nisi leo, pretium a, gravida quis, sollicitudin non, eros. Vestibulum pretium fringilla quam. Nam elementum. Suspendisse odio magna, aliquam vitae, vulputate et, dignissim at, pede. Integer pellentesque orci at nibh. Morbi ante.</p>

<p>Maecenas convallis mattis justo. Ut mauris sapien, consequat a, bibendum vitae, sagittis ac, nisi. Nulla et sapien. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Ut condimentum turpis ut elit. Quisque ultricies sollicitudin justo. Duis vitae magna nec risus pulvinar ultricies. Aliquam sagittis volutpat metus.</p>

<p>Sed enim. Integer hendrerit, arcu ac pretium nonummy, velit turpis faucibus risus, pulvinar egestas enim elit sed ante. Curabitur orci diam, placerat a, faucibus id, condimentum vitae, magna. Etiam enim massa, convallis quis, rutrum vitae, porta quis, turpis.</p>
<!-- remove this link after editing -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl + '?__mode=view&_type=page&id=' + page_id + '&blog_id=' + blog_id; return false">Editar este contenido</a>
</p>
	 },
	'Create a blog as a part of structured website. This works best with Professional Website theme.' => 'Crear un blog como parte de la estructura de un sitio web. Funciona mejor con el tema Sitio Web Profesional.',
	'Unknown Type' => 'Tipo de desconocido',
	'Unknown Object' => 'Objeto de desconocido',
	'Not Required' => 'No obligatorio',
	'Are you sure you want to delete the selected CustomFields?' => '¿Está seguro de que desea borrar los campos personalizados seleccionados?',
	'Photo' => 'Foto',
	'Embed' => 'Embeber',
	'Custom Fields' => 'Campos personalizados',
	'Field' => 'Campo',
	'Template tag' => 'Etiqueta de plantilla',
	'Updating Universal Template Set to Professional Website set...' => 'Actualizar el conjuntto de plantillas Universal al conjunto Sitio Web Profesional...',
	'Migrating CustomFields type...' => 'Migrando tipo de Campos Personalizados...',
	'Converting CustomField type...' => 'Convirtiendo el tipo de Campos Personalizados...',
	'Professional Styles' => 'Estilos Profesionales',
	'A collection of styles compatible with Professional themes.' => 'Colección de estilos compatible con los temas Profesionales.',
	'Professional Website' => 'Web Profesional',
	'Header' => 'Cabecera',
	'Footer' => 'Pie',
	'Entry Detail' => 'Detalle de la entrada',
	'Entry Metadata' => 'Metadatos de la entrada',
	'Page Detail' => 'Detalle de la página',
	'Footer Links' => 'Enlaces del pie',
	'Powered By (Footer)' => 'Powered By (Pie)',
	'Recent Entries Expanded' => 'Entradas recientes expandidas',
	'Main Sidebar' => 'Barra lateral principal',
	'Blog Activity' => 'Actividad del blog',
	'Professional Blog' => 'Blog Profesional',
	'Blog Archives' => 'Archivos del blog',

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Show' => 'Mostrar',
	'Date & Time' => 'Fecha & Hora',
	'Date Only' => 'Fecha solo',
	'Time Only' => 'Hora solo',
	'Please enter all allowable options for this field as a comma delimited list' => 'Por favor, introduzca todas las opciones permitidas a este campo en forma de lista de elementos separados por comas',
	'Exclude Custom Fields' => 'Excluir campos personalizados',
	'[_1] Fields' => 'Campos de [_1]',
	'Edit Field' => 'Editar campo',
	'Invalid date \'[_1]\'; dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Fecha no válida \'[_1]\'; las fechas deben estar en el formato YYYY-MM-DD HH:MM:SS.',
	'Invalid date \'[_1]\'; dates should be real dates.' => 'Fecha no válida \'[_1]\'; debe ser una fecha real.',
	'Please enter valid URL for the URL field: [_1]' => 'Por favor, introduzca una URL válida en el campo de la URL: [_1]',
	'Please enter some value for required \'[_1]\' field.' => 'Por favor, introduzca un valor en el campo obligatorio \'[_1]\'.',
	'Please ensure all required fields have been filled in.' => 'Por favor, asegúrese de que todos los campos se han introducido.',
	'The template tag \'[_1]\' is an invalid tag name.' => 'La etiqueta de plantilla \'[_1]\' es un nombre de etiqueta inválido.',
	'The template tag \'[_1]\' is already in use.' => 'La etiqueta de plantilla \'[_1]\' ya está en uso.',
	'blog and the system' => 'blog y el sistema',
	'website and the system' => 'sitio y el sistema',
	'The basename \'[_1]\' is already in use. It must be unique within this [_2].' => 'El nombre base \'[_1]\' ya está en uso. Debe ser único en este [_2].',
	'You must select other type if object is the comment.' => 'Debe seleccionar otro tipo si el objeto es un comentario.',
	'type' => 'tipo',
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

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Restoring custom fields data stored in MT::PluginData...' => 'Restaurando los datos de los campos personalizados guardados en MT::PluginData...',
	'Restoring asset associations found in custom fields ( [_1] ) ...' => 'Restaurando las asociaciones de los ficheros multimedia de los campos personalizados ( [_1] ) ...',
	'Restoring url of the assets associated in custom fields ( [_1] )...' => 'Restaurando url de los ficheros multimedia asociados en los campos personalizados ( [_1] )...',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback/Field.pm
	'The type "[_1]" is invalid.' => 'El tipo "[_1]" no es válido.',
	'The systemObject "[_1]" is invalid.' => 'El systemObject "[_1]" no es válido.',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback.pm
	'Please enter valid option for the [_1] field: [_2]' => 'Por favor, introduzca una opción válida para el campo [_1]: [_2]', # Translate - New

## addons/Commercial.pack/lib/CustomFields/DataAPI/Endpoint/v2/Field.pm
	'Invalid includeShared parameter provided: [_1]' => 'Parámetro de includeShare no válido: [_1]',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'The template tag \'[_1]\' is already in use in the system level' => 'La etiqueta de plantilla \'[_1]\' ya está en uso a nivel del sistema.',
	'The template tag \'[_1]\' is already in use in [_2]' => 'La etiqueta de plantilla \'[_1]\' ya está en uso en [_2]',
	'The template tag \'[_1]\' is already in use in this blog' => 'La etiqueta de plantilla \'[_1]\' ya está uso en este blog',
	'The \'[_1]\' of the template tag \'[_2]\' that is already in use in [_3] is [_4].' => 'El \'[_1]\' de la etiqueta de plantilla \'[_2]\' que ya está en uso en [_3] es [_4].',
	'_CF_BASENAME' => 'Nombre base',
	'__CF_REQUIRED_VALUE__' => 'Valor',

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	'Are you sure you have used a \'[_1]\' tag in the correct context? We could not find the [_2]' => '¿Está seguro de que ha utilizado la etiqueta \'[_1]\' en el contexto adecuado? No se encontró el [_2]',
	'You used an \'[_1]\' tag outside of the context of the correct content; ' => 'Ha utilizado una etiqueta \'[_1]\' fuera del contexto del contenido correcto;',

## addons/Commercial.pack/lib/CustomFields/Theme.pm
	'[_1] custom fields' => '[_1] campos personalizados',
	'a field on this blog' => 'un campo en este blog',
	'a field on system wide' => 'un campo en todo el sistema',
	'Conflict of [_1] "[_2]" with [_3]' => 'Conflicto entre [_1] "[_2]" y [_3]',
	'Template Tag' => 'Etiqueta de plantilla',

## addons/Commercial.pack/lib/CustomFields/Upgrade.pm
	'Moving metadata storage for pages...' => 'Trasladando los metadatos de las páginas...',
	'Removing CustomFields display-order from plugin data...' => 'Borrando el orden de visualización de los campos personalizados en los datos de las extensiones...',
	'Removing unlinked CustomFields...' => 'Borrando campos personalizados no enlazados...',

## addons/Commercial.pack/lib/CustomFields/Util.pm
	'Cloning fields for blog:' => 'Clonando campos para el blog:',

## addons/Commercial.pack/templates/professional/blog/about_this_page.mtml

## addons/Commercial.pack/templates/professional/blog/archive_index.mtml

## addons/Commercial.pack/templates/professional/blog/archive_widgets_group.mtml

## addons/Commercial.pack/templates/professional/blog/author_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/calendar.mtml

## addons/Commercial.pack/templates/professional/blog/categories.mtml

## addons/Commercial.pack/templates/professional/blog/category_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/comment_detail.mtml

## addons/Commercial.pack/templates/professional/blog/comment_form.mtml

## addons/Commercial.pack/templates/professional/blog/comment_listing.mtml

## addons/Commercial.pack/templates/professional/blog/comment_preview.mtml

## addons/Commercial.pack/templates/professional/blog/comment_response.mtml

## addons/Commercial.pack/templates/professional/blog/comments.mtml

## addons/Commercial.pack/templates/professional/blog/creative_commons.mtml

## addons/Commercial.pack/templates/professional/blog/current_author_monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/current_category_monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/date_based_author_archives.mtml

## addons/Commercial.pack/templates/professional/blog/date_based_category_archives.mtml

## addons/Commercial.pack/templates/professional/blog/dynamic_error.mtml

## addons/Commercial.pack/templates/professional/blog/entry_detail.mtml

## addons/Commercial.pack/templates/professional/blog/entry_listing.mtml
	'Recently by <em>[_1]</em>' => 'Novedades por <em>[_1]</em>',

## addons/Commercial.pack/templates/professional/blog/entry_metadata.mtml

## addons/Commercial.pack/templates/professional/blog/entry.mtml

## addons/Commercial.pack/templates/professional/blog/entry_summary.mtml

## addons/Commercial.pack/templates/professional/blog/footer_links.mtml

## addons/Commercial.pack/templates/professional/blog/footer.mtml

## addons/Commercial.pack/templates/professional/blog/header.mtml

## addons/Commercial.pack/templates/professional/blog/javascript.mtml

## addons/Commercial.pack/templates/professional/blog/main_index.mtml

## addons/Commercial.pack/templates/professional/blog/main_index_widgets_group.mtml

## addons/Commercial.pack/templates/professional/blog/monthly_archive_dropdown.mtml

## addons/Commercial.pack/templates/professional/blog/monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/navigation.mtml

## addons/Commercial.pack/templates/professional/blog/openid.mtml

## addons/Commercial.pack/templates/professional/blog/page.mtml

## addons/Commercial.pack/templates/professional/blog/pages_list.mtml

## addons/Commercial.pack/templates/professional/blog/powered_by_footer.mtml

## addons/Commercial.pack/templates/professional/blog/recent_assets.mtml

## addons/Commercial.pack/templates/professional/blog/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] comentó en [_3]</a>: [_4]',

## addons/Commercial.pack/templates/professional/blog/recent_entries.mtml

## addons/Commercial.pack/templates/professional/blog/search.mtml

## addons/Commercial.pack/templates/professional/blog/search_results.mtml

## addons/Commercial.pack/templates/professional/blog/sidebar.mtml

## addons/Commercial.pack/templates/professional/blog/signin.mtml

## addons/Commercial.pack/templates/professional/blog/syndication.mtml

## addons/Commercial.pack/templates/professional/blog/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/blog/tags.mtml

## addons/Commercial.pack/templates/professional/blog/trackbacks.mtml

## addons/Commercial.pack/templates/professional/website/archive_index.mtml

## addons/Commercial.pack/templates/professional/website/blog_index.mtml

## addons/Commercial.pack/templates/professional/website/blogs.mtml
	'Entries ([_1]) Comments ([_2])' => 'Entradas ([_1]) Comentarios ([_2])',

## addons/Commercial.pack/templates/professional/website/categories.mtml

## addons/Commercial.pack/templates/professional/website/comment_detail.mtml

## addons/Commercial.pack/templates/professional/website/comment_form.mtml

## addons/Commercial.pack/templates/professional/website/comment_listing.mtml

## addons/Commercial.pack/templates/professional/website/comment_preview.mtml

## addons/Commercial.pack/templates/professional/website/comment_response.mtml

## addons/Commercial.pack/templates/professional/website/comments.mtml

## addons/Commercial.pack/templates/professional/website/dynamic_error.mtml

## addons/Commercial.pack/templates/professional/website/entry_detail.mtml

## addons/Commercial.pack/templates/professional/website/entry_listing.mtml

## addons/Commercial.pack/templates/professional/website/entry_metadata.mtml

## addons/Commercial.pack/templates/professional/website/entry.mtml

## addons/Commercial.pack/templates/professional/website/entry_summary.mtml

## addons/Commercial.pack/templates/professional/website/footer_links.mtml

## addons/Commercial.pack/templates/professional/website/footer.mtml

## addons/Commercial.pack/templates/professional/website/header.mtml

## addons/Commercial.pack/templates/professional/website/javascript.mtml

## addons/Commercial.pack/templates/professional/website/main_index.mtml

## addons/Commercial.pack/templates/professional/website/navigation.mtml

## addons/Commercial.pack/templates/professional/website/openid.mtml

## addons/Commercial.pack/templates/professional/website/page.mtml

## addons/Commercial.pack/templates/professional/website/pages_list.mtml

## addons/Commercial.pack/templates/professional/website/powered_by_footer.mtml

## addons/Commercial.pack/templates/professional/website/recent_entries_expanded.mtml
	'on [_1]' => 'en [_1]',
	'By [_1] | Comments ([_2])' => 'Por [_1] | Comentarios ([_2]) ',

## addons/Commercial.pack/templates/professional/website/search.mtml

## addons/Commercial.pack/templates/professional/website/search_results.mtml

## addons/Commercial.pack/templates/professional/website/sidebar.mtml

## addons/Commercial.pack/templates/professional/website/signin.mtml

## addons/Commercial.pack/templates/professional/website/syndication.mtml

## addons/Commercial.pack/templates/professional/website/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/website/tags.mtml

## addons/Commercial.pack/templates/professional/website/trackbacks.mtml

## addons/Commercial.pack/tmpl/asset-chooser.tmpl
	'Choose [_1]' => 'Seleccionar [_1]',

## addons/Commercial.pack/tmpl/category_fields.tmpl
	'Show These Fields' => 'Mostrar estos campos',

## addons/Commercial.pack/tmpl/cfg_customfields.tmpl
	'Data have been saved to custom fields.' => 'Se han cuargado los datos en los campos personalizados.',
	'Save changes to blog (s)' => 'Guardar los cambios en el blog (s)',
	'No custom fileds could be found. <a href="[_1]">Create a field</a> now.' => 'No se han encontrado campos personalizados. <a href="[_1]">Cree un campo</a> ahora.',

## addons/Commercial.pack/tmpl/edit_field.tmpl
	'Edit Custom Field' => 'Editar campo personalizado',
	'Create Custom Field' => 'Crear campo personalizado',
	'The selected field(s) has been deleted from the database.' => 'Los campos seleccionados han sido borrados de la base de datos.',
	'You must enter information into the required fields highlighted below before the custom field can be created.' => 'Antes de que pueda crear el campo personalizado debe introducir la información en los campos obligatorios resaltados abajo.',
	'You must save this custom field before setting a default value.' => 'Debe guardar este campo personalizado antes de indicar un valor predefinido.',
	'Choose the system object where this custom field should appear.' => 'Seleccione el objeto del sistema donde aparecerá el campo personalizado.',
	'Required?' => '¿Obligatorio?',
	'Is data entry required in this custom field?' => '¿Se necesita la introducción de datos en este campo personalizado?',
	'Must the user enter data into this custom field before the object may be saved?' => '¿El usuario debe introducir datos en este campo personalizado antes de que el objeto se guarde?',
	'Default' => 'Predefinido',
	'The basename must be unique within this [_1].' => 'El nombre base debe ser único en este [_1].',
	q{Warning: Changing this field's basename may require changes to existing templates.} => q{Atención: Si cambia el nombre base de este campo, quizás se necesiten cambios en las plantillas existentes.},
	'Example Template Code' => 'Código de ejemplo',
	'Show In These [_1]' => 'Mostrar en estos [_1]',
	'Save this field (s)' => 'Guardar este campo (s)',
	'field' => 'campo',
	'fields' => 'campos',
	'Delete this field (x)' => 'Borrar este campo (x)',

## addons/Commercial.pack/tmpl/export_field.tmpl
	'Object' => 'Objeto',

## addons/Commercial.pack/tmpl/listing/field_list_header.tmpl

## addons/Commercial.pack/tmpl/reorder_fields.tmpl
	'open' => 'abrir',
	'click-down and drag to move this field' => 'haga clic y arrastre el campo para moverlo',
	'click to %toggle% this box' => 'haga clic para %toggle% esta casilla',
	'use the arrow keys to move this box' => 'use las flechas para mover esta caja',
	', or press the enter key to %toggle% it' => ', o presione la tecla enter para %toggle%',

## addons/Community.pack/config.yaml
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype/',
	'Increase reader engagement - deploy features to your website that make it easier for your readers to engage with your content and your company.' => 'Incremente la satisfacción de los lectores - muestre nuevas características en el sitio web para facilitar que los lectores disfruten de sus contenidos y su compañía.',
	'Create forums where users can post topics and responses to topics.' => 'Cree foros donde los usuarios pueden publicar temas y respuestas a esos temas.',
	'Users followed by [_1]' => 'Seguidos por [_1]',
	'Users following [_1]' => 'Seguidores de [_1]',
	'Community' => 'Comunidad',
	'Sanitize' => 'Esterilizar',
	'Followed by' => 'Seguido por',
	'Followers' => 'Seguidores',
	'Following' => 'Siguiendo',
	'Pending Entries' => 'Entradas pendientes',
	'Spam Entries' => 'Entradas spam',
	'Recently Scored' => 'Puntuaciones recientes',
	'Recent Submissions' => 'Envíos recientes',
	'Most Popular Entries' => 'Entradas más populares',
	'Registrations' => 'Registros',
	'Login Form' => 'Formulario de inicio de sesión',
	'Registration Form' => 'Formulario de registro',
	'Registration Confirmation' => 'Confirmación de registro',
	'Profile View' => 'Ver perfil',
	'Profile Edit Form' => 'Formulario de edición del perfil',
	'Profile Feed' => 'Sindicación del perfil',
	'New Password Form' => 'Formulario de nueva contraseña',
	'New Password Reset Form' => 'Formulario de reinicio de contraseña',
	'Form Field' => 'Campo del formulario',
	'Status Message' => 'Mensaje de estado',
	'Simple Header' => 'Cabecera simple',
	'Simple Footer' => 'Pie simple',
	'Header' => 'Cabecera',
	'Footer' => 'Pie',
	'GlobalJavaScript' => 'GlobalJavaScript',
	'Email verification' => 'Verificación del correo',
	'Registration notification' => 'Notificación de registro',
	'New entry notification' => 'Notificación de nueva entrada',
	'Community Styles' => 'Estilos Comunitarios',
	'A collection of styles compatible with Community themes.' => 'Colección de estilos compatible con los temas Comunitarios.',
	'Community Blog' => 'Blog Comunitario',
	'Atom ' => 'Atom ',
	'Entry Response' => 'Respuesta a la entrada',
	'Displays error, pending or confirmation message when submitting an entry.' => 'Muestra un mensaje de error, de pendiente o de confirmación, al enviar una entrada.',
	'Entry Detail' => 'Detalle de la entrada',
	'Entry Metadata' => 'Metadatos de la entrada',
	'Page Detail' => 'Detalle de la página',
	'Entry Form' => 'Formulario de entradas',
	'Content Navigation' => 'Navegación de contenidos',
	'Activity Widgets' => 'Widgets de actividad',
	'Archive Widgets' => 'Widgets de archivos',
	'Community Forum' => 'Foro comunitario',
	'Entry Feed' => 'Sindicación de entradas',
	'Displays error, pending or confirmation message when submitting a entry.' => 'Muestra un mensaje de error, de pendiente o de confirmación al enviar una entrada.',
	'Popular Entry' => 'Entrada popular',
	'Entry Table' => 'Tabla de entradas',
	'Content Header' => 'Cabecera de contenidos',
	'Category Groups' => 'Grupos de categorías',
	'Default Widgets' => 'Widgets predefinidos',

## addons/Community.pack/lib/MT/App/Community.pm
	'No login form template defined' => 'No hay ninguna plantilla de formulario definida',
	'Before you can sign in, you must authenticate your email address. <a href="[_1]">Click here</a> to resend the verification email.' => 'Antes de que pueda iniciar una sesión, debe autentificar su dirección de correo. <a href="[_1]">Haga clic aquí</a> para reenviar el correo de verificación.',
	'You are trying to redirect to external resources: [_1]' => 'Está intentando redireccionar a recursos externos: [_1]',
	'Successfully authenticated but signing up is not allowed.  Please contact system administrator.' => 'La identificación se ha producido con suceso pero la conexión ha sido rechazada.  Por favor contacte el administrador del sistema.',
	'(No email address)' => '(Sin dirección de correo)',
	'User \'[_1]\' (ID:[_2]) has been successfully registered.' => 'El usuario \'[_1]\' (ID:[_2]) se registró con éxito.',
	'Thanks for the confirmation.  Please sign in.' => 'Gracias por la confirmación. Por favor, inicie la sesión.',
	'[_1] registered to Movable Type.' => '[_1] se registró en Movable Type.',
	'Login required' => 'Requerido inicio de sesión',
	'Title or Content is required.' => 'El título o contenido es obligatorio.',
	'Publish failed: [_1]' => 'Falló la publicación: [_1]',
	'System template entry_response not found in blog: [_1]' => 'La plantilla del sistema entry_response no se encontró en el blog: [_1]',
	'New entry \'[_1]\' added to the blog \'[_2]\'' => 'Añadida una nueva entrada \'[_1]\' al blog \'[_2]\'',
	'Unknown user' => 'Usuario desconocido',
	'All required fields must have valid values.' => 'Todos los campos obligatorios deben tener valores válidos.',
	'Recent Entries from [_1]' => 'Entradas recientes de [_1]',
	'Responses to Comments from [_1]' => 'Respuestas a los comentarios de [_1]',
	'Actions from [_1]' => 'Acciones de [_1]',

## addons/Community.pack/lib/MT/Community/CMS.pm
	'Movable Type was unable to write on the "Upload Destination". Please make sure that the folder is writable from the web server.' => 'Movable Type no pudo escribir en el "Destino de las transferencias". Por favor, asegúrese de que el servidor web puede escribir en el directorio.',

## addons/Community.pack/lib/MT/Community/Tags.pm
	'You used an \'[_1]\' tag outside of the block of MTIfEntryRecommended; perhaps you mistakenly placed it outside of an \'MTIfEntryRecommended\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del bloque MTIfEntryRecommended; ¿quizás la situó por error fuera de un contenedor \'MTIfEntryRecommended\'?',
	'Click here to recommend' => 'Haga clic aquí para hacer una recomendación',
	'Click here to follow' => 'Clic aquí para seguir a',
	'Click here to leave' => 'Clic aquí para dejar de seguir a',

## addons/Community.pack/lib/MT/Community/Upgrade.pm
	'Removing Profile Error global system template...' => 'Eliminando la plantilla global del sistema de error de perfil.',

## addons/Community.pack/php/function.mtentryrecommendvotelink.php

## addons/Community.pack/templates/blog/about_this_page.mtml
	'This page contains a single entry by <a href="[_1]">[_2]</a> published on <em>[_3]</em>.' => 'Esta página contiene una sola entrada realizada por <a href="[_1]">[_2]</a> y publicada el <em>[_3]</em>.',

## addons/Community.pack/templates/blog/archive_index.mtml

## addons/Community.pack/templates/blog/archive_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to serve different content based upon what type of archive it is included. More info: [_1]' => 'Conjunto personalizado de widgets creado para mostrar contenidos diferentes según el tipo de archivo que incluye. Más información: [_1]',

## addons/Community.pack/templates/blog/categories.mtml

## addons/Community.pack/templates/blog/category_archive_list.mtml

## addons/Community.pack/templates/blog/comment_detail.mtml

## addons/Community.pack/templates/blog/comment_form.mtml

## addons/Community.pack/templates/blog/comment_listing.mtml

## addons/Community.pack/templates/blog/comment_preview.mtml
	'Comment on [_1]' => 'Comentario en [_1]',

## addons/Community.pack/templates/blog/comment_response.mtml

## addons/Community.pack/templates/blog/comments.mtml
	'The data in #comments-content will be replaced by some calls to paginate script' => 'Los datos en #comments-content se reemplazarán por llamadas al script de paginación',

## addons/Community.pack/templates/blog/content_nav.mtml
	'Blog Home' => 'Incio - Blog',

## addons/Community.pack/templates/blog/current_category_monthly_archive_list.mtml

## addons/Community.pack/templates/blog/dynamic_error.mtml

## addons/Community.pack/templates/blog/entry_create.mtml

## addons/Community.pack/templates/blog/entry_detail.mtml

## addons/Community.pack/templates/blog/entry_form.mtml
	'In order to create an entry on this blog you must first register.' => 'Para crear una entrada en este blog, primero debe registrarse.',
	q{You don't have permission to post.} => q{No tiene permisos para publicar.},
	'Sign in to create an entry.' => 'Identifíquese para crear una entrada.',
	'Select Category...' => 'Seleccione una categoría...',

## addons/Community.pack/templates/blog/entry_listing.mtml
	'Recently by <em>[_1]</em>' => 'Novedades por <em>[_1]</em>',

## addons/Community.pack/templates/blog/entry_metadata.mtml
	'Vote' => 'Voto',
	'Votes' => 'Votos',

## addons/Community.pack/templates/blog/entry.mtml

## addons/Community.pack/templates/blog/entry_response.mtml
	'Thank you for posting an entry.' => 'Gracias por publicar una entrada.',
	'Entry Pending' => 'Entrada pendiente',
	'Your entry has been received and held for approval by the blog owner.' => 'Su entrada ha sido recibida y está pendiente de aprobación por el propietario del blog.',
	'Entry Posted' => 'Entrada publicada',
	'Your entry has been posted.' => 'La entrada ha sido publicada.',
	'Your entry has been received.' => 'La entrada ha sido recibida.',
	q{Return to the <a href="[_1]">blog's main index</a>.} => q{Regresar al <a href="[_1]">índice principal del blog</a>.},

## addons/Community.pack/templates/blog/entry_summary.mtml

## addons/Community.pack/templates/blog/javascript.mtml

## addons/Community.pack/templates/blog/main_index.mtml

## addons/Community.pack/templates/blog/main_index_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to only appear on the homepage (or "main_index"). More info: [_1]' => 'Este es un conjunto personalizado de widgets creados para aparecer solo en la página de inicio (o "main_index"). Más información: [_1]',

## addons/Community.pack/templates/blog/monthly_archive_list.mtml

## addons/Community.pack/templates/blog/openid.mtml

## addons/Community.pack/templates/blog/page.mtml

## addons/Community.pack/templates/blog/pages_list.mtml

## addons/Community.pack/templates/blog/powered_by.mtml

## addons/Community.pack/templates/blog/recent_assets.mtml

## addons/Community.pack/templates/blog/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] comentó en [_3]</a>: [_4]',

## addons/Community.pack/templates/blog/recent_entries.mtml

## addons/Community.pack/templates/blog/search.mtml

## addons/Community.pack/templates/blog/search_results.mtml

## addons/Community.pack/templates/blog/sidebar.mtml

## addons/Community.pack/templates/blog/syndication.mtml

## addons/Community.pack/templates/blog/tag_cloud.mtml

## addons/Community.pack/templates/blog/tags.mtml

## addons/Community.pack/templates/blog/trackbacks.mtml

## addons/Community.pack/templates/forum/archive_index.mtml

## addons/Community.pack/templates/forum/category_groups.mtml
	'Forum Groups' => 'Grupos de los foros',
	'Last Topic: [_1] by [_2] on [_3]' => 'Último tema: [_1] by [_2] on [_3]',
	'Be the first to <a href="[_1]">post a topic in this forum</a>' => 'Sea el primero en <a href="[_1]">publicar un tema en este foro</a>',

## addons/Community.pack/templates/forum/comment_detail.mtml
	'[_1] replied to <a href="[_2]">[_3]</a>' => '[_1] respondió a <a href="[_2]">[_3]</a>',

## addons/Community.pack/templates/forum/comment_form.mtml
	'Add a Reply' => 'Responder',

## addons/Community.pack/templates/forum/comment_listing.mtml

## addons/Community.pack/templates/forum/comment_preview.mtml
	'Reply to [_1]' => 'Responder a [_1]',
	'Previewing your Reply' => 'Vista previa de la respuesta',

## addons/Community.pack/templates/forum/comment_response.mtml
	'Reply Submitted' => 'Respuesta enviada',
	'Your reply has been accepted.' => 'Se ha aceptado su respuesta.',
	'Thank you for replying.' => 'Gracias por responder.',
	'Your reply has been received and held for approval by the forum administrator.' => 'Su respuesta ha sido recibida y retenida para su aprobación por el administrador del foro.',
	'Reply Submission Error' => 'Error en el envío de la respuesta',
	'Your reply submission failed for the following reasons: [_1]' => 'El envío de la respuesta falló por alguna de las siguientes razones: [_1]',
	'Return to the <a href="[_1]">original topic</a>.' => 'Regresar al <a href="[_1]">tema original</a>.',

## addons/Community.pack/templates/forum/comments.mtml
	'1 Reply' => '1 respuesta',
	'# Replies' => '# respuestas',
	'No Replies' => 'Sin respuestas',

## addons/Community.pack/templates/forum/content_header.mtml
	'Start Topic' => 'Comenzar tema',

## addons/Community.pack/templates/forum/content_nav.mtml

## addons/Community.pack/templates/forum/dynamic_error.mtml

## addons/Community.pack/templates/forum/entry_create.mtml
	'Start a Topic' => 'Comenzar un tema',

## addons/Community.pack/templates/forum/entry_detail.mtml

## addons/Community.pack/templates/forum/entry_form.mtml
	'Topic' => 'Tema',
	'Select Forum...' => 'Seleccionar foro...',
	'Forum' => 'Foro',

## addons/Community.pack/templates/forum/entry_listing.mtml

## addons/Community.pack/templates/forum/entry_metadata.mtml

## addons/Community.pack/templates/forum/entry.mtml

## addons/Community.pack/templates/forum/entry_popular.mtml
	'Popular topics' => 'Temas populares',
	'Last Reply' => 'Última respuesta',
	'Permalink to this Reply' => 'Enlace permanente de esta respuesta',
	'By [_1]' => 'Por [_1]',

## addons/Community.pack/templates/forum/entry_response.mtml
	'Thank you for posting a new topic to the forums.' => 'Gracias por publicar un nuevo tema en los foros.',
	'Topic Pending' => 'Tema pendiente',
	'The topic you posted has been received and held for approval by the forum administrators.' => 'El tema que ha publicado se ha recibido y está pendiente de aprobación por parte de los administradores del foro.',
	'Topic Posted' => 'Tema publicado',
	'The topic you posted has been received and published. Thank you for your submission.' => 'El tema que envió se ha recibido y ya está publicado. Gracias por su aportación.',
	q{Return to the <a href="[_1]">forum's homepage</a>.} => q{Regresar a la página de <a href="[_1]">inicio del foro</a>.},

## addons/Community.pack/templates/forum/entry_summary.mtml

## addons/Community.pack/templates/forum/entry_table.mtml
	'Recent Topics' => 'Temas recientes',
	'Replies' => 'Respuestas',
	'Closed' => 'Cerrado',
	'Post the first topic in this forum.' => 'Publica el primer tema en este foro.',

## addons/Community.pack/templates/forum/javascript.mtml
	'Thanks for signing in,' => 'Gracias por registrarse en,',
	'. Now you can reply to this topic.' => '. Ahora puede contestar en este tema.',
	'You do not have permission to comment on this blog.' => 'No tiene permisos para comentar en este blog.',
	' to reply to this topic.' => ' para responder a este tema.',
	' to reply to this topic,' => ' para responder a este tema,',
	'or ' => 'o ',
	'reply anonymously.' => 'responder anónimamente.',

## addons/Community.pack/templates/forum/main_index.mtml
	'Forum Home' => 'Foro - Inicio',

## addons/Community.pack/templates/forum/openid.mtml

## addons/Community.pack/templates/forum/page.mtml

## addons/Community.pack/templates/forum/search_results.mtml
	'Topics matching &ldquo;[_1]&rdquo;' => 'Temas que coinciden con &ldquo;[_1]&rdquo;',
	'Topics tagged &ldquo;[_1]&rdquo;' => 'Temas etiquetados con &ldquo;[_1]&rdquo;',
	'Topics' => 'Temas',

## addons/Community.pack/templates/forum/sidebar.mtml

## addons/Community.pack/templates/forum/syndication.mtml
	'All Forums' => 'Todos los foros',
	'[_1] Forum' => 'Foro [_1]',

## addons/Community.pack/templates/global/email_verification_email.mtml
	'Thank you for registering an account to [_1].' => 'Gracias por registrar una cuenta en [_1].',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to sign in to [_1].' => 'Por su propia seguridad y para prevenir fraudes, le solicitamos que confirme su cuenta y dirección de correo antes de continuar. Una vez confirmados, ya podrá iniciar una sesión en [_1].',
	'To confirm your account, please click on or cut and paste the following URL into a web browser:' => 'Para confirmar su cuenta, haga clic en (o copie y pegue) la URL en un navegador web:',
	q{If you did not make this request, or you don't want to register for an account to [_1], then no further action is required.} => q{Si no realizó esta petición, o no quiere registrar una cuenta en [_1], no se requiere ninguna otra acción.},
	'Thank you very much for your understanding.' => 'Gracias por su comprensión.',

## addons/Community.pack/templates/global/footer.mtml

## addons/Community.pack/templates/global/header.mtml
	'Blog Description' => 'Descripción del blog',

## addons/Community.pack/templates/global/javascript.mtml

## addons/Community.pack/templates/global/login_form_module.mtml
	'Logged in as <a href="[_1]">[_2]</a>' => 'Identificado como <a href="[_1]">[_2]</a>',
	'Logout' => 'Cerrar sesión',
	'Hello [_1]' => 'Hola [_1]',
	'Forgot Password' => 'Recuperar la contraseña',
	'Sign up' => 'Registro',

## addons/Community.pack/templates/global/login_form.mtml
	'Not a member?&nbsp;&nbsp;<a href="[_1]">Sign Up</a>!' => '¿No es usuario?&nbsp;&nbsp;¡<a href="[_1]">Inscríbase</a>!',

## addons/Community.pack/templates/global/navigation.mtml

## addons/Community.pack/templates/global/new_entry_email.mtml
	q{A new entry '[_1]([_2])' has been posted on your blog [_3].} => q{Se ha publicado una nueva entrada '[_1]([_2])' en su blog [_3].},
	'Author name: [_1]' => 'Nombre del autor: [_1]',
	'Author nickname: [_1]' => 'Pseudónimo del autor: [_1]',
	'Title: [_1]' => 'Título: [_1]',
	'Edit entry:' => 'Editar entrada:',

## addons/Community.pack/templates/global/new_password.mtml

## addons/Community.pack/templates/global/new_password_reset_form.mtml
	'Go Back (x)' => 'Volver',

## addons/Community.pack/templates/global/profile_edit_form.mtml
	'Go <a href="[_1]">back to the previous page</a> or <a href="[_2]">view your profile</a>.' => '<a href="[_1]">Regresar a la página anterior</a> o <a href="[_2]">vea su perfil</a>.',

## addons/Community.pack/templates/global/profile_feed.mtml
	'Posted [_1] to [_2]' => '[_1] publicado en [_2]',
	'Commented on [_1] in [_2]' => 'Comentó en [_1] en [_2]',
	'Voted on [_1] in [_2]' => 'Votó en [_1] en [_2]',
	'[_1] voted on <a href="[_2]">[_3]</a> in [_4]' => '[_1] votó en <a href="[_2]">[_3]</a> en [_4]',

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

## addons/Community.pack/templates/global/register_confirmation.mtml
	'Authentication Email Sent' => 'Correo de autentificación enviado.',
	'Profile Created' => 'Perfil creado',

## addons/Community.pack/templates/global/register_form.mtml

## addons/Community.pack/templates/global/register_notification_email.mtml
	q{This email is to notify you that a new user has successfully registered on the blog '[_1]'. Listed below you will find some useful information about this new user.} => q{Este correo electrónico es una notificaión  para informarle que un nuevo usuario ha sido enregistrado con succeso en el blog '[_1]'. Abajo usted encontratá enumeradas algunas informaciones útiles sobre este nuevo usuario.},

## addons/Community.pack/templates/global/search.mtml

## addons/Community.pack/templates/global/signin.mtml
	'You are signed in as <a href="[_1]">[_2]</a>' => 'Está identificado como <a href="[_1]">[_2]</a>',
	'You are signed in as [_1]' => 'Está identificado como [_1]',
	'Edit profile' => 'Editar Perfil',
	'Not a member? <a href="[_1]">Register</a>' => '¿No es miembro? <a href="[_1]">Registrarse</a>',

## addons/Community.pack/tmpl/cfg_community_prefs.tmpl
	'Community Settings' => 'Configuración de la comunidad',
	'Anonymous Recommendation' => 'Recomendación anónima',
	'Check to allow anonymous users (users not logged in) to recommend discussion.  IP address is recorded and used to identify each user.' => 'Active esta opción para permitir que los usuarios anónimos (aquellos que no han iniciado una sesión) puedan recomendar debates. Las direcciones IP se registran y se utilizan para identificar a cada usuario.',
	'Allow anonymous user to recommend' => 'Permitir que los usuarios anónimos hagan recomendaciones',
	'Junk Filter' => 'Filtro basura',
	'If enabled, all moderated entries will be filtered by Junk Filter.' => 'Si se activa, todas las entradas moderadas se filtrarán por el Filtro de basura.',
	'Save changes to blog (s)' => 'Guardar los cambios en el blog (s)',

## addons/Community.pack/tmpl/widget/blog_stats_registration.mtml
	'Recent Registrations' => 'Registros recientes',
	'default userpic' => 'avatar predefinido',
	'You have [quant,_1,registration,registrations] from [_2]' => 'Tiene un [quant,_1,registro,registros] en [_2]',

## addons/Community.pack/tmpl/widget/most_popular_entries.mtml
	'There are no popular entries.' => 'No hay entradas populares.',

## addons/Community.pack/tmpl/widget/recently_scored.mtml
	'There are no recently favorited entries.' => 'No hay recomendaciones recientes de entradas.',

## addons/Community.pack/tmpl/widget/recent_submissions.mtml

## addons/Enterprise.pack/app-cms.yaml
	'Groups ([_1])' => 'Grupos ([_1])',
	'Are you sure you want to delete the selected group(s)?' => '¿Está seguro de querer borrar el(los) grupo(s) seleccionados?',
	'Are you sure you want to remove the selected member(s) from the group?' => '¿Está seguro de querer borrar los miembros seleccionados del grupo?',
	'[_1]\'s Group' => 'Grupo de [_1]',
	'Groups' => 'Grupos',
	'Manage Member' => 'Administrar miembros',
	'Bulk Author Export' => 'Exportación masiva de autores',
	'Bulk Author Import' => 'Importación de autores por lote',
	'Synchronize Users' => 'Sincronización de Usuarios',
	'Synchronize Groups' => 'Sincronizar grupos',
	'Add user to group' => 'Añadir usuario a grupo',

## addons/Enterprise.pack/app-wizard.yaml
	'This module is required in order to use the LDAP Authentication.' => 'Este módulo es requerido para usar la identificación LDAP.',

## addons/Enterprise.pack/config.yaml
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype/',
	'Permissions of group: [_1]' => 'Permisos del grupo: [_1]',
	'Group' => 'Grupo',
	'Groups associated with author: [_1]' => 'Grupos asociados con autor: [_1]',
	'Inactive' => 'Inactivo',
	'Members of group: [_1]' => 'Miembros del grupo: [_1]',
	'Advanced Pack' => 'Advanced Pack',
	'User/Group' => 'Usuario/Grupo',
	'User/Group Name' => 'Nombre del usuario/grupo',
	'__GROUP_MEMBER_COUNT' => 'Miembros',
	'My Groups' => 'Mis grupos',
	'Group Name' => 'Nombre del grupo',
	'Manage Group Members' => 'Administrar miembros del grupo',
	'Group Members' => 'Miembros del grupo',
	'Group Member' => 'Miembro del grupo',
	'Permissions for Users' => 'Permisos para usuarios',
	'Permissions for Groups' => 'Permisos para grupos',
	'Active Groups' => 'Grupos activos',
	'Disabled Groups' => 'Grupos deshabilitados',
	'Oracle Database (Recommended)' => 'Base de datos Oracle (recomendada)',
	'Microsoft SQL Server Database' => 'Base de Datos Microsoft SQL Server',
	'Microsoft SQL Server Database UTF-8 support (Recommended)' => 'Base de datos Microsoft SQL Server con soporte UTF-8 (recomendada)',
	'Publish Charset' => 'Código de caracteres',
	'ODBC Driver' => 'Controlador ODBC',
	'External Directory Synchronization' => 'Sincronización del Directorio Externo',
	'Populating author\'s external ID to have lower case user name...' => 'Introduciendo el ID externo del autor para usar minúsculas...',

## addons/Enterprise.pack/lib/MT/Auth/LDAP.pm
	'Cannot connect to LDAP server.' => 'No se pudo conectar al servidor LDAP.',
	'User [_1]([_2]) not found.' => 'Usuario [_1]([_2]) sin resultado.',
	'User \'[_1]\' cannot be updated.' => 'Usuario [_1] no puede ser modificado.',
	'User \'[_1]\' updated with LDAP login ID.' => 'Usuario [_1] modificado con el ID de login LDAP.',
	'LDAP user [_1] not found.' => 'Usuario LDAP [_1] sin resultado.',
	'User [_1] cannot be updated.' => 'Usuario [_1] no puede ser actualizado.',
	'User cannot be updated: [_1].' => 'Usuario no puede ser actualizado [_1].',
	'Failed login attempt by user \'[_1]\' who was deleted from LDAP.' => 'Falló el intento de inicio de sesión del usuario \'[_1]\' que fue borrado de LDAP.',
	'User \'[_1]\' updated with LDAP login name \'[_2]\'.' => 'Usuario [_1] actualizado con el nombre de login LDAP [_2]',
	'Failed login attempt by user \'[_1]\'. A user with that username already exists in the system with a different UUID.' => 'Falló el intento de inicio de sesión del usuario \'[_1]\'. Existe un usuario con ese nombre en el sistema con un UUID diferente.',
	'User \'[_1]\' account is disabled.' => 'La cuenta del usuario [_1] ha sido desactivada.',
	'LDAP users synchronization interrupted.' => 'La sincronización de los usuarios LDAP ha sido interrumpida.',
	'Loading MT::LDAP::Multi failed: [_1]' => 'Fallo al cargar MT::LDAP::Multi: [_1]',
	'External user synchronization failed.' => 'La sincronización de los usuarios externos falló.',
	'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'Un intento de desactivación de todos los administradores del sistema ha sido efectuada.  La sincronización de los usuarios ha sido interrumpida.',
	'Information about the following users was modified:' => 'Se ha modificado la información de los siguiente usuarios:',
	'The following users were disabled:' => 'Los siguientes usuarios han sido desactivados:',
	'LDAP users synchronized.' => 'Los usuarios LDAP han sido sincronizados:',
	'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute being set.' => 'No se puede realizar la sincronización de grupos sin configurar LDAPGroupIdAttribute y/o LDAPGroupNameAttribute.',
	'Primary group members cannot be synchronized with Active Directory.' => 'Los miembros principales de los grupos no pueden sincronizarse con Active Directory.',
	'Cannot synchronize LDAP groups members.' => 'No se puede sincronizar los miembros de los grupos de LDAP.',
	'User filter was not built: [_1]' => 'No se pudo construir el filtro de usuario: [_1]',
	'LDAP groups synchronized with existing groups.' => 'Grupos LDAP sincronizados con los grupos existentes.',
	'Information about the following groups was modified:' => 'Se ha modificado la información de los siguientes grupos:',
	'No LDAP group was found using the filter provided.' => 'No se han encontrado grupos LDAP usando el filtro indicado.',
	'The filter used to search for groups was: \'[_1]\'. Search base was: \'[_2]\'' => 'El filtro utilizado para la búsqueda de grupos era: \'[_1]\'. La búsqueda base eras: \'[_2]\'',
	'(none)' => '(ninguno)',
	'The following groups were deleted:' => 'Los siguientes grupos han sido borrados:',
	'Failed to create a new group: [_1]' => 'Falló la creación de un nuevo grupo: [_1]',
	'[_1] directive must be set to synchronize members of LDAP groups to Movable Type Advanced.' => 'La instrucción [_1] debe ser completada para sincronizar los miembros de los grupos LDAP en MT Advanced.',
	'Cannot get group \'[_1]\' (#[_2]) entry and its all member attributes from external directory.' => 'No se puede obtener la entrada del grupo \'[_1]\' (#[_2]) y los atributos de todos los miembros desde un directorio externo.',
	'Cannot get member entries of group \'[_1]\' (#[_2]) from external directory.' => 'No se puede obtener las entradas de los miembros del grupo \'[_1]\' (#[_2]) desde un directorio externo. ',
	'Members removed: ' => 'Miembros borrados:',
	'Members added: ' => 'Miembros añadidos:',
	'Memberships in the group \'[_2]\' (#[_3]) were changed as a result of synchronizing with the external directory.' => 'Se modificó la pertenencia en el grupo \'[_2]\' (#[_3]) por la sincronización con el directorio externo.',
	'LDAPUserGroupMemberAttribute must be set to enable synchronizing of members of groups.' => 'Debe configurar LDAPUserGroupMemberAttribute para permitir la sincronización de los miembros de los grupos.',

## addons/Enterprise.pack/lib/MT/Enterprise/Author.pm
	'Loading MT::LDAP failed: [_1].' => 'Falló la carga de MT::LDAP: [_1].',

## addons/Enterprise.pack/lib/MT/Enterprise/BulkCreation.pm
	'Formatting error at line [_1]: [_2]' => 'Error de formato en la línea [_1]: [_2]',
	'Invalid command: [_1]' => 'Orden inválida',
	'Invalid number of columns for [_1]' => 'Número de columnas para [_1] inválido',
	'Invalid user name: [_1]' => 'Nombre de usuario inválido: [_1]',
	'Invalid display name: [_1]' => 'Nombre mostrado inválido: [_1]',
	'Invalid email address: [_1]' => 'Dirección de correo electrónico inválida: [_1]',
	'Invalid password: [_1]' => 'Contraseña inválida: [_1]',
	'\'Personal Blog Location\' setting is required to create new user blogs.' => 'Se debe configurar \'Localización del blog personal\' para crear nuevos blogs de usuario.',
	'Invalid weblog name: [_1]' => 'Nombre de weblog no válido: [_1]',
	'Invalid blog URL: [_1]' => 'URL del blog no válidaL: [_1]',
	'Invalid site root: [_1]' => 'Raíz del sitio inválida: [_1]',
	'Invalid timezone: [_1]' => 'Zona horaria inválida: [_1]',
	'Invalid theme ID: [_1]' => 'ID de tema no válido: [_1]',
	'A theme \'[_1]\' was not found.' => 'No se encontró un tema \'[_1]\'.',
	'A user with the same name was found.  The registration was not processed: [_1]' => 'Se encontró un usuario con el mismo nombre. No se procesó el registro: [_1]',
	'Blog for user \'[_1]\' can not be created.' => 'El blog por el usuario [_1] no puede ser creado.',
	'Blog \'[_1]\' for user \'[_2]\' has been created.' => 'El blog [_1] por el usuario [_2] ha sido creado.',
	'Error assigning weblog administration rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable weblog administrator role was found.' => 'Error en la asignación de los derechos de administración al usuario [_1] (ID: [_2]) para el weblog [_3] (ID: [_4]).  Ningún rol de administrador apropiado ha sido encontrado.',
	'Permission granted to user \'[_1]\'' => 'Los derechos han sido atribuidos al usuario [_1]',
	'User \'[_1]\' already exists. The update was not processed: [_2]' => 'El usuario \'[_1]\' ya existe. No se ha procesado la actualización: [_2]',
	'User \'[_1]\' not found.  The update was not processed.' => 'No se encontró al usuario \'[_1]\'. No se ha procesado la actualización.',
	'User \'[_1]\' has been updated.' => 'Usuario [_1] ha sido actualizado.',
	'User \'[_1]\' was found, but the deletion was not processed' => 'Se encontró al usuario \'[_1]\' pero el borrado no se ha procesado',
	'User \'[_1]\' not found.  The deletion was not processed.' => 'No se encontró al usuario \'[_1]\'. El borrado no ha sido procesado.',
	'User \'[_1]\' has been deleted.' => 'El usuario [_1] ha sido borrado.',

## addons/Enterprise.pack/lib/MT/Enterprise/CMS.pm
	'Movable Type Advanced has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.' => 'Movable Type Advanced acaba de intentar deshabilitar su cuenta durante una sincronización con el directorio externo. Algunas de las opciones de configuración de la administración externa de usuarios deben ser incorrectas. Por favor, corrija la configuración antes de continuar.',
	'Each group must have a name.' => 'Cada grupo debe tener un nombre.',
	'Search Users' => 'Buscar usuarios',
	'Select Groups' => 'Seleccionar grupos',
	'Groups Selected' => 'Grupos seleccionados',
	'Search Groups' => 'Buscar grupos',
	'Add Users to Groups' => 'Añadir usuarios a grupos',
	'Invalid group' => 'Grupo inválido',
	'Add Users to Group [_1]' => 'Añadir usuarios al grupo [_1]',
	'User \'[_1]\' (ID:[_2]) removed from group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Usuario [_1] (ID: [_2]) ha sido borrado del grupo [_3] (ID:[_4]) por [_5]',
	'Group load failed: [_1]' => 'La carga del grupo ha fallado: [_1]',
	'User load failed: [_1]' => 'La carga del usuario ha fallado: [_1]',
	'User \'[_1]\' (ID:[_2]) was added to group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Usuario[_1] (ID: [_2]) ha sido añadido del grupo [_3] (ID:[_4]) por [_5]',
	'Users & Groups' => 'Usuarios y grupos',
	'Group Profile' => 'Perfil de grupo',
	'Author load failed: [_1]' => 'La carga del autor ha fallado: [_1]',
	'Invalid user' => 'Usuario inválido',
	'Assign User [_1] to Groups' => 'Usuario [_1] asignado a los grupos',
	'Type a group name to filter the choices below.' => 'Tapea el nombre de un grupo para filtrar las opciones que se encuentran aquí debajo.',
	'Bulk import cannot be used under external user management.' => 'La importación masiva no puede ser usuada en la administración de usuarios externos.',
	'Bulk management' => 'Administración masiva',
	'No records were found in the file.  Make sure the file uses CRLF as the line-ending characters.' => 'No se encontraron registros en el fichero. Asegúrese de que el fichero usa CRLF como caracteres de final de línea.',
	'Registered [quant,_1,user,users], updated [quant,_2,user,users], deleted [quant,_3,user,users].' => '[quant,_1,Usuario registro,Usuariosregistrados], [quant,_2,usuario actualizado,usuarios actualizados], [quant,_3,usuario eliminado,usuarios eliminados].',
	'Bulk author export cannot be used under external user management.' => 'No se puede usar la exportación en lote de autores bajo la administración externa de usuario.',
	'A user cannot change his/her own username in this environment.' => 'Un usuario no puede cambiar su propio nombre en este contexto.',
	'An error occurred when enabling this user.' => 'Ocurrió un error cuando se habilitaba este usuario.',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Callback/Group.pm
	'A parameter "[_1]" is invalid.' => 'Un parámetro "[_1]" no es válido.',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/Group.pm
	'Creating group failed: ExternalGroupManagement is enabled.' => 'Falló la creación del grupo: ExternalGroupManagement está activado.',
	'Cannot add member to inactive group.' => 'No se puede añadir un miembro a un grupo inactivo.',
	'Adding member to group failed: [_1]' => 'Fallo al añadir miembro al grupo: [_1]',
	'Removing member from group failed: [_1]' => 'Fallo al borrar miembro del grupo: [_1]',
	'Group not found' => 'Grupo no encontrado',
	'Member not found' => 'Miembro no encontrado',
	'A resource "member" is required.' => 'Se necesita un "miembro" de recursos.',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/Permission.pm
	'Association not found' => 'Asociación no encontrada.',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/User.pm

## addons/Enterprise.pack/lib/MT/Enterprise/Upgrade.pm
	'Fixing binary data for Microsoft SQL Server storage...' => 'Reparando datos binarios para Microsoft SQL Server...',

## addons/Enterprise.pack/lib/MT/Enterprise/Wizard.pm
	'PLAIN' => 'PLAIN',
	'CRAM-MD5' => 'CRAM-MD5',
	'Digest-MD5' => 'Digest-MD5',
	'Login' => 'Login',
	'Found' => 'Encontrado',
	'Not Found' => 'No encontrado',

## addons/Enterprise.pack/lib/MT/Group.pm

## addons/Enterprise.pack/lib/MT/LDAP.pm
	'Invalid LDAPAuthURL scheme: [_1].' => 'Scheme LDAPAuthURL inválido: [_1].',
	'Error connecting to LDAP server [_1]: [_2]' => 'Error a la conexión al server LDAP [_1]: [_2]',
	'Entry not found in LDAP: [_1]' => 'Entrada no encontrada en LDAP: [_1]',
	'Binding to LDAP server failed: [_1]' => 'La asociación con el server LDAP ha fallado: [_1]',
	'User not found in LDAP: [_1]' => 'No se encontró al usuario en LDAP: [_1]',
	'More than one user with the same name found in LDAP: [_1]' => 'Se encontró en LDAP a más de un usuario con el mismo nombre: [_1]',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/MSSQLServer.pm
	'PublishCharset [_1] is not supported in this version of the MS SQL Server Driver.' => 'En esta versión del controlador de MS SQL Server PublishCharset [_1] no está soportado.',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/UMSSQLServer.pm
	'This version of UMSSQLServer driver requires DBD::ODBC version 1.14.' => 'Esta versión del Driver UMSSQLServer requiere DBD::ODBC versión 1.14.',
	'This version of UMSSQLServer driver requires DBD::ODBC compiled with Unicode support.' => 'Esta versión del Driver UMSSQLServer requiere DBD::ODBC compilado con el soporte Unicode.',

## addons/Enterprise.pack/tmpl/author_bulk.tmpl
	'Manage Users in bulk' => 'Administrar los usuarios por lote',
	'_USAGE_AUTHORS_2' => 'Puede crear editar y borrar usuarios en lote transfiriendo un fichero con formato CSV con las órdenes y datos relevantes.',
	q{New user blog would be created on '[_1]'.} => q{Se creará al nuevo blog de usuario en '[_1]'.},
	'[_1] Edit</a>' => 'Editar [_1]</a>',
	q{You must set 'Personal Blog Location' to create a new blog for each new user.} => q{Para crear un nuevo blog para cada usuario debe indicar la 'Localización del blog personal'.},
	'[_1] Setting</a>' => 'Configuración de [_1]</a>',
	'Upload source file' => 'Suba el fichero fuente',
	'Specify the CSV-formatted source file for upload' => 'Defina el fichero fuente en formato CSV para subirlo',
	'Source File Encoding' => 'Codificación del archivo fuente',
	'Movable Type will automatically try to detect the character encoding of your import file.  However, if you experience difficulties, you can set the character encoding explicitly.' => 'Movable Type intentará detectar automáticamente la codificación del fichero de exportación. Puede indicarlo explícitamente si observa problemas.',
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
	'An error occurred while attempting to connect to the LDAP server: ' => 'Un error se ha producido durante la conexión LDAP.',
	'You can configure your LDAP settings from here if you would like to use LDAP-based authentication.' => 'Ahora puede configurar sus parámetros LDAP desde aquí si desea utilizar una identificaión basada sobre LDAP. ',
	'Your configuration was successful.' => 'Su configuración se ha producido con suceso.',
	q{Click 'Continue' below to configure the External User Management settings.} => q{Haga clic en continuar debajo para configurar la administración de usuario externo.},
	q{Click 'Continue' below to configure your LDAP attribute mappings.} => q{Haga clic en continuar debajo para configurar el mapeado de los atributos LDAP.},
	'Your LDAP configuration is complete.' => 'Su configuración LDAP ha sido completada.',
	q{To finish with the configuration wizard, press 'Continue' below.} => q{Para terminar con la configuración, haga clic en el botón continuar debajo.},
	'Cannot locate Net::LDAP. Net::LDAP module is required to use LDAP authentication.' => 'No se encontró Net::LDAP. El módulo Net::LDAP es necesario para utilizar la autentificación LDAP.',
	'Use LDAP' => 'Utilizar LDAP',
	'Authentication URL' => 'URL de Identificación',
	'The URL to access for LDAP authentication.' => 'La URL para acceder a la identificación LDAP',
	'Authentication DN' => 'DN de la Identificación',
	'An optional DN used to bind to the LDAP directory when searching for a user.' => 'Un DN opcional utilizado para asociarse con el directorio LDAP cuando se busca un usuario.',
	'Authentication password' => 'Contraseña de la Identificación',
	'Used for setting the password of the LDAP DN.' => 'Utilizado para iniciar la contraseña del DN del LDAP.',
	'SASL Mechanism' => 'Mecanismo SASL',
	'The name of the SASL Mechanism used for both binding and authentication.' => 'El nombre del mecanismo SASL utilizado para la conexión y autentificación.',
	'Test Username' => 'Verificar el nombre de usuario',
	'Test Password' => 'Verificar la contraseña',
	'Enable External User Management' => 'Activar la administración de los usuarios externos',
	'Synchronization Frequency' => 'Frecuencia de sincronización',
	'The frequency of synchronization in minutes. (Default is 60 minutes)' => 'La frecuencia de sincronización en minutos (Por defecto son 60 minutos)',
	'15 Minutes' => '15 Minutos',
	'30 Minutes' => '30 Minutos',
	'60 Minutes' => '60 Minutos',
	'90 Minutes' => '90 Minutos',
	'Group Search Base Attribute' => 'Atributo de la base de búsqueda de grupos',
	'Group Filter Attribute' => 'Atributo de filtro de grupos',
	'Search Results (max 10 entries)' => 'Resultados de la búsqueda (máx. 10 entradas)',
	'CN' => 'CN',
	'No groups were found with these settings.' => 'Ningún grupo ha sido encontrado bajo estos parámetros.',
	'Attribute mapping' => 'Mapeado de los atributos',
	'LDAP Server' => 'LDAP Server',
	'Other' => 'Otro',
	'User ID Attribute' => 'Atributo del ID de usuario',
	'Email Attribute' => 'Atributo del correo electrónico',
	'User Fullname Attribute' => 'Atributo del nombre completo',
	'User Member Attribute' => 'Atributo del nombre de usuario',
	'GroupID Attribute' => 'Atributo del ID de Grupo',
	'Group Name Attribute' => 'Atributo del nombre del grupo',
	'Group Fullname Attribute' => 'Atributo del nombre completo del grupo',
	'Group Member Attribute' => 'Atributo del nombre de usuario del grupo',
	'Search Result (max 10 entries)' => 'Resultado de la búsqueda (máx. 10 entradas)',
	'Group Fullname' => 'Nombre completo del grupo',
	'(and [_1] more members)' => '(y [_1] miembros más)',
	'No groups could be found.' => 'Ningún grupo ha sido encontrado',
	'User Fullname' => 'Nombre completo el usuario',
	'(and [_1] more groups)' => '(y [_1] grupos más)',
	'No users could be found.' => 'Ningún usuario ha sido encontrado',
	'Test connection to LDAP' => 'Verificación de la conexión LDAP',
	'Test search' => 'Verificación de la búsqueda',

## addons/Enterprise.pack/tmpl/create_author_bulk_end.tmpl
	'All users were updated successfully.' => 'Se actualizaron con éxito todos los usuarios.',
	'An error occurred during the update process. Please check your CSV file.' => 'Ocurrió un error durante el proceso de actualización. Por favor, compruebe el fichero CSV.',

## addons/Enterprise.pack/tmpl/create_author_bulk_start.tmpl

## addons/Enterprise.pack/tmpl/dialog/dialog_select_group_user.tmpl

## addons/Enterprise.pack/tmpl/dialog/select_groups.tmpl
	'You need to create some groups.' => 'Necesita crear algunos grupos.',
	q{Before you can do this, you need to create some groups. <a href="javascript:void(0);" onclick="closeDialog('[_1]');">Click here</a> to create a group.} => q{Antes de poder hacer esto, usted debe crear algunos grupos. <a href="javascript:void(0);" onclick="closeDialog('[_1]');">Haga clic aquí</a> para crear un grupo.},

## addons/Enterprise.pack/tmpl/edit_group.tmpl
	'Edit Group' => 'Editar grupo',
	'Create Group' => 'Crear grupo',
	'This group profile has been updated.' => 'Se ha actualizado el perfil del grupo.',
	'This group was classified as pending.' => 'Este grupo estaba clasificado como pendiente.',
	'This group was classified as disabled.' => 'Este grupo estaba clasificado como deshabilitado.',
	'Member ([_1])' => 'Miembro ([_1])',
	'Members ([_1])' => 'Miembros ([_1])',
	'Permission ([_1])' => 'Permiso ([_1])',
	'Permissions ([_1])' => 'Permisos ([_1])',
	'LDAP Group ID' => 'LDAP del Grupo ID',
	'The LDAP directory ID for this group.' => 'El ID del directorio LDAP para este grupo.',
	'Status of this group in the system. Disabling a group prohibits its members&rsquo; from accessing the system but preserves their content and history.' => 'El estado del grupo en el sistema. La deshabilitación de grupos prohíbe a sus miembros el acceso al sistema, pero mantiene los contenidos e historia.',
	'The name used for identifying this group.' => 'El nombre de usuario para identificar este grupo.',
	'The display name for this group.' => 'El nombre que se muestra para este grupo.',
	'The description for this group.' => 'La descripción de este grupo.',
	'Save changes to this field (s)' => 'Guardar cambios en el campo (s)',

## addons/Enterprise.pack/tmpl/include/group_table.tmpl
	'Enable selected group (e)' => 'Habilitar grupo seleccionado (e)',
	'Disable selected group (d)' => 'Deshabilitar grupo seleccionado (d)',
	'group' => 'grupo',
	'groups' => 'grupos',
	'Remove selected group (d)' => 'Borrar grupo seleccionado (d)',

## addons/Enterprise.pack/tmpl/include/list_associations/page_title.group.tmpl
	'Users &amp; Groups for [_1]' => 'Usuarios &amp; Grupos de [_1]',

## addons/Enterprise.pack/tmpl/listing/group_list_header.tmpl
	'You successfully disabled the selected group(s).' => 'Deshabilitó con éxito los grupos seleccionados.',
	'You successfully enabled the selected group(s).' => 'Habilitó con éxito los grupos seleccionados.',
	'You successfully deleted the groups from the Movable Type system.' => 'Borró con éxito los grupos del sistema Movable Type.',
	q{You successfully synchronized the groups' information with the external directory.} => q{Sincronizó con éxito la información de los grupos con el directorio externo.},

## addons/Enterprise.pack/tmpl/listing/group_member_list_header.tmpl
	'You successfully deleted the users.' => 'Borró los usuarios con éxito.',
	'You successfully added new users to this group.' => 'Añadió nuevos usuarios al grupo con éxito.',
	q{You successfully synchronized users' information with the external directory.} => q{Sincronizó con éxito la información de los usuarios con el directorio externo.},
	'Some ([_1]) of the selected users could not be re-enabled because they are no longer found in LDAP.' => 'No se pudo rehabilitar alguno ([_1]) de los usuarios seleccionados porque ya no se encuentran en LDAP.',
	'You successfully removed the users from this group.' => 'Ha borrado con éxito a los usuarios del grupo.',

## addons/Sync.pack/config.yaml
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype/',
	'Migrated sync setting' => 'Configuración de sincronización migrada',
	'Sync' => 'Sincronización',
	'Sync Name' => 'Nombre de sincronización',
	'Sync Datetime' => 'Fecha de sincronización',
	'Manage Sync Settings' => 'Administrar sincronización',
	'Sync Setting' => 'Configuración de la sincronización',
	'Sync Settings' => 'Configuración de la sincronización',
	'Create new sync setting' => 'Crear nueva configuración de sincronización',
	'Contents Sync' => 'Sincronización de contenidos',
	'Remove sync PID files' => 'Borrar los ficheros de sincronización PID', # Translate - New
	'Updating MT::SyncSetting table...' => 'Actualizando la tabla MT::SyncSetting...',
	'Migrating settings of contents sync on website...' => 'Migrando la configuración de la sincronización de contenidos en el sitio web...',
	'Migrating settings of contents sync on blog...' => 'Migrando la configuración de la sincronización de contenidos en el blog...',
	'Re-creating job of contents sync...' => 'Re-creando tarea de sincronización de contenidos...',

## addons/Sync.pack/lib/MT/FileSynchronizer/FTPBase.pm
	'Cannot access to remote directory \'[_1]\'' => 'No se pudo acceder al directorio remoto \'[_1]\'',
	'Deleting file \'[_1]\' failed.' => 'Fallo al borrar el fichero \'[_1]\'.',
	'Deleting path \'[_1]\' failed.' => 'Fallo al borrar la ruta \'[_1]\'.',
	'Directory or file by which end of name is dot(.) or blank exists. Cannot synchronize these files.: "[_1]"' => 'Exste un directorio o fichero cuyo nombre termina con un punto (.) o un espacio. No se pueden sincronizar estos ficheros: "[_1]"', # Translate - New
	'Unable to write temporary file ([_1]): [_2]' => 'No se pudo escribir un fichero temporal ([_1]): [_2]',
	'Unable to get size of temporary file ([_1]): [_2]' => 'No se pudo obtener el tamaño del fichero temporal ([_1]): [_2]', # Translate - New
	'FTP reconnection was failed. ([_1])' => 'La reconexión al FTP falló. ([_1])', # Translate - New
	'FTP connection lost.' => 'Se perdió la conexión FTP.', # Translate - New
	'FTP connection timeout.' => 'Caducó la conexión FTP.', # Translate - New
	'Unable to write remote files. Please check activity log for more details.: [_1]' => 'No se pudieron escribir ficheros remotos. Compruebe el histórico de actividad para más detalles: [_1]',
	'Unable to write remote files ([_1]): [_2]' => 'No se pudieron escribir ficheros remotos ([_1]): [_2]',

## addons/Sync.pack/lib/MT/FileSynchronizer.pm
	'Failed to remove sync list. (ID:\'[_1]\')' => 'Fallo al eliminar lista de sincronización. (ID:\'[_1]\')',
	'Failed to update sync list. (ID:\'[_1]\')' => 'Fallo al actualizar lista de sincronización. (ID:\'[_1]\')',
	'Failed to create sync list.' => 'Fallo al crear lista de sincronización.',
	'Failed to save sync list. (ID:\'[_1]\')' => 'Fallo al guardar la lista de sincronización. (ID:\'[_1]\')',
	'Error switching directory.' => 'Error cambiando de directorio.',
	'Synchronization with an external server has been successfully finished.' => 'Finalizó con éxito la sincronización con el servidor externo.',
	'Failed to sync with an external server.' => 'Falló la sincronización con un servidor externo.',

## addons/Sync.pack/lib/MT/FileSynchronizer/Rsync.pm
	'Temp Directory [_1] is not writable.' => 'No se puede escribir en el directorio temporal [_1].',
	'Error during rsync: Command (exit code [_1]): [_2]' => 'Error durante rsync: Comando (código de salida [_1]): [_2]',

## addons/Sync.pack/lib/MT/SyncFileList.pm
	'Sync file list' => 'Lista de ficheros para sincronizar',

## addons/Sync.pack/lib/MT/SyncSetting.pm
	'Sync settings' => 'Configuración de la sincronización',

## addons/Sync.pack/lib/MT/Worker/ContentsSync.pm
	'Sync setting # [_1] not found.' => 'Configuración de sincronización # [_1] no encontrado.',
	'This sync setting is being processed already.' => 'La configuración de la sincronización ya se está procesando.',
	'Unknown error occurred.' => 'Ocurrió un error desconocido.',
	'This email is to notify you that synchronization with an external server has been successfully finished.' => 'Le notificamos que finalizó correctamente la sincronización con el servidor externo.',
	'Saving sync settings failed: [_1]' => 'Fallo al guardar la configuración de sincronización',
	'Failed to remove temporary directory: [_1]' => 'Fallo al eliminar directorio temporal: [_1]',
	'Failed to remove pid file.' => 'Fallo al borrar fichero pid.',
	'This email is to notify you that failed to sync with an external server.' => 'Le notificamos que no finalizó correctamente la sincronización con un servidor externo.',

## addons/Sync.pack/lib/Sync/App/CMS.pm
	'Copied [_1]' => 'Copiado [_1]',
	'The sync setting with the same name already exists.' => 'Ya existe una configuración de sincronización con el mismo nombre.',
	'Reached the upper limit of the parallel execution.' => 'Llegó al límite máximo de la ejecución en paralelo.', # Translate - New
	'Process ID can\'t be acquired.' => 'No se puede adquirir el ID del proceso.', # Translate - New
	'An error occurred while attempting to connect to the FTP server \'[_1]\': [_2]' => 'Ocurrió un error al intentar conectar con el servidor FTP \'[_1]\': [_2]',
	'An error occurred while attempting to retrieve the current directory from \'[_1]\'' => 'Ocurrió un error al intentar copiar el directorio actual desde \'[_1]\'',
	'An error occurred while attempting to retrieve the list of directories from \'[_1]\'' => 'Ocurrió un error al intentar copiar la lista de directorios de \'[_1]\'',

## addons/Sync.pack/lib/Sync/Upgrade.pm
	'Removing all jobs of contents sync...' => 'Eliminando todas las tareas de sincronización de contenidos...',

## addons/Sync.pack/tmpl/cfg_contents_sync.tmpl
	'Contents Sync Settings' => 'Configuración de la sincronización de contenidos',
	'Contents sync settings has been saved.' => 'Se ha guardado la configuración de contenidos.',
	'The sync settings has been copied but not saved yet.' => 'La configuración de la sincronización se ha copiado pero aún no se ha guardado.',
	'One or more templates are set to the Dynamic Publishing. Dynamic Publishing may not work properly on the destination server.' => 'Se han indicado una o más plantillas para la publicación dinámica. La publicación dinámica podría no funcionar correctamente en el servidor de destino.',
	'Run synchronization now' => 'Ejecutar ahora la sincronización',
	'Copy this sync setting' => 'Copiar esta configuración de sincronización',
	'Sync Date' => 'Fecha de sincronización',
	'Recipient for Notification' => 'Destinatario de las notificaciones',
	'Receive only error notification' => 'Recibir sólo notificación de errores',
	'Destinations' => 'Destino',
	'Add destination' => 'Añadir destino',
	'Sync Type' => 'Tipo de sincronización',
	'Sync type not selected' => 'Tipo de sincronización no seleccionada',
	'FTP' => 'FTP',
	'Rsync' => 'Rsync',
	'FTP Server' => 'FTP Server',
	'Port' => 'Puerto',
	'SSL' => 'SSL',
	'Enable SSL' => 'Activar SSL',
	'Net::FTPSSL is not available.' => 'Net::FTPSSL no está disponible.',
	'Start Directory' => 'Directorio de inicio',
	'Rsync Destination' => 'Destino de Rsync',
	'Sync Type *' => 'Tipo de sincronización *',
	'Please select a sync type.' => 'Por favor, seleccione un tipo de sincronización.',
	'Are you sure you want to run synchronization?' => '¿Está seguro de que desea realizar la sincronización?',
	'Sync all files' => 'Sincronizar todos los ficheros',
	'Sync name is required.' => 'Debe indicar un nombre de sincronización.',
	'Sync name should be shorter than [_1] characters.' => 'El nombre de sincronización debe tener menos de [_1] caracteres.',
	'The sync date must be in the future.' => 'La fecha de sincronización debe ser futura.',
	'Invalid time.' => 'Fecha no válida.',
	'You must make one or more destination settings.' => 'Debe indicar una o más opciones de destino.',
	'Are you sure you want to remove this settings?' => '¿Está seguro de que desea eliminar estas opciones?',

## addons/Sync.pack/tmpl/dialog/contents_sync_now.tmpl
	'Sync Now!' => '¡Sincronizar ahora!',
	'Preparing...' => 'Preparando...',
	'Synchronizing...' => 'Sincronizando...',
	'Finish!' => '¡Finalizó!',
	'The synchronization was interrupted. Unable to resume.' => 'Se interrumpió la sincronización. No es posible continuar.',

## plugins/FacebookCommenters/config.yaml
	'Provides commenter registration through Facebook Connect.' => 'Provee registro de comentaristas a través de Facebook Connect.',
	'Facebook' => 'Facebook',

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm
	'Set up Facebook Commenters plugin' => 'Configurar la extesión de comentaristas de Facebook',
	'Authentication failure: [_1], reason:[_2]' => 'Fallo de autentificación: [_1], razón: [_2]',
	'Failed to created commenter.' => 'Falló al crear comentarista.',
	'Failed to create a session.' => 'Falló al crear una sesión.',
	'Facebook Commenters needs either Crypt::SSLeay or IO::Socket::SSL installed to communicate with Facebook.' => 'Los comentaristas de Facebook necesitan que Crypt::SSLeay o IO::Socket::SSL estén instalados para la comunicación con Facebook.',
	'Please enter your Facebook App key and secret.' => 'Por favor, introduzca el identificador y código secreto de app de Facebook.',
	'Could not verify this app with Facebook: [_1]' => 'No se pudo verificar esta aplicación en Facebook: [_1]',

## plugins/FacebookCommenters/tmpl/blog_config_template.tmpl
	'Facebook App ID' => 'Clave de la aplicación de Facebook',
	'The key for the Facebook application associated with your blog.' => 'La clave de la aplicación de Facebook asociada con su blog.',
	'Edit Facebook App' => 'Editar aplicación de Facebook',
	'Create Facebook App' => 'Crear aplicación de Facebook',
	'Facebook Application Secret' => 'Secreto de la aplicación de Facebook',
	'The secret for the Facebook application associated with your blog.' => 'El secreto de la aplicación de Facebook asociada con su blog.',

## plugins/feeds-app-lite/lib/MT/Feeds/Lite.pm
	'An error occurred processing [_1]. The previous version of the feed was used. A HTTP status of [_2] was returned.' => 'Ocurrió un error procesando [_1]. Se utilizó la versión previa de la fuente. Se devolvió el estado HTTP [_2].',
	'An error occurred processing [_1]. A previous version of the feed was not available.A HTTP status of [_2] was returned.' => 'Ocurrió un error procesando [_1]. La versión anterior de la fuente no estaba disponible. Se devolvió el estado HTTP [_2].',

## plugins/feeds-app-lite/lib/MT/Feeds/Tags.pm
	'\'[_1]\' is a required argument of [_2]' => '\'[_1]\' es un argumento necesario de [_2]',
	'MT[_1] was not used in the proper context.' => 'MT[_1] no se está utilizando en el contexto adecuado.',

## plugins/feeds-app-lite/mt-feeds.pl
	'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type? <a href="http://code.appnel.com/feeds-app" target="_blank">Upgrade to Feeds.App</a>.' => 'Feeds.App Lite le ayuda a republicar fuentes de sindicación en los blogs. ¿Quiere hacer más cosas con la sindicación en Movable Type? <a href="http://code.appnel.com/feeds-app" target="_blank">Actualícese a Feeds.App</a>.',
	'Create a Feed Widget' => 'Crear un widget de fuente',

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
	q{An error occurred processing [_1]. Check <a href="javascript:void(0)" onclick="closeDialog('http://www.feedvalidator.org/check.cgi?url=[_2]')">here</a> for more detail and please try again.} => q{Ocurrió un error procesando [_1]. Compruebe <a href="javascript:void(0)" onclick="closeDialog('http://www.feedvalidator.org/check.cgi?url=[_2]')">aquí</a> los detalles e inténtelo de nuevo.},
	'A widget named <strong>[_1]</strong> has been created.' => 'Se creó un widget titulado <strong>[_1]</strong>.',
	q{You may now <a href="javascript:void(0)" onclick="closeDialog('[_2]')">edit &ldquo;[_1]&rdquo;</a> or include the widget in your blog using <a href="javascript:void(0)" onclick="closeDialog('[_3]')">WidgetManager</a> or the following MTInclude tag:} => q{Ahora puede <a href="javascript:void(0)" onclick="closeDialog('[_2]')">editar &ldquo;[_1]&rdquo;</a> o incluir el widget su blog utilizando <a href="javascript:void(0)" onclick="closeDialog('[_3]')">WidgetManager</a> o la siguiente etiqueta MTInclude:},
	q{You may now <a href="javascript:void(0)" onclick="closeDialog('[_2]')">edit &ldquo;[_1]&rdquo;</a> or include the widget in your blog using the following MTInclude tag:} => q{Ahora puede <a href="javascript:void(0)" onclick="closeDialog('[_2]')">editar &ldquo;[_1]&rdquo;</a> o incluir el widget en su blog utilizando la siguiente etiqueta MTInclude:},
	'Create Another' => 'Crear otro',

## plugins/feeds-app-lite/tmpl/select.tmpl
	'Multiple feeds were found' => 'Se encontraron múltiples fuentes',
	'Select the feed you wish to use. <em>Feeds.App Lite supports text-only RSS 1.0, 2.0 and Atom feeds.</em>' => 'Seleccione la fuente que desea usar. <em>Feeds.App Lite soporta las fuentes con solo texto RSS 1.0, 2.0 y Atom.',
	'URI' => 'URI',

## plugins/feeds-app-lite/tmpl/start.tmpl
	'You must enter a feed or site URL to proceed' => 'Debe introducir una fuente o una URL de un sitio para proceder.',
	'Create a widget from a feed' => 'Crear un widget de una fuente',
	'Feed or Site URL' => 'URL del sitio o fuente',
	'Enter the URL of a feed, or the URL of a site that has a feed.' => 'Introduzca la URL de una fuente de sindicación, o la URL de un sitio que tenga una fuente.',

## plugins/FormattedText/config.yaml
	'Manage boilerplate.' => 'Administrar texto con formato.',

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => 'Añadir el botón "Insertar texto con formato" a TinyMCE.',

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'No se pudo cargar el texto con formato.',

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Select a Boilerplate' => 'Seleccionar un text con formato',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected boilerplates?' => '¿Está seguro que desea borrar los textos con formato seleccionados?',
	'My Boilerplate' => 'Mis textos con formato',

## plugins/FormattedText/lib/FormattedText/DataAPI/Callback/FormattedText.pm
	'The boilerplate \'[_1]\' is already in use in this site.' => 'Este sitio ya usa el texto con formato \'[_1]\'.',

## plugins/FormattedText/lib/FormattedText/DataAPI/Endpoint/v2/FormattedText.pm

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'Boilerplates' => 'Textos con formato',
	'The boilerplate \'[_1]\' is already in use in this blog.' => 'Este blog ya usa el texto con formato \'[_1]\'.',

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Edit Boilerplate' => 'Editar texto con formato',
	'Create Boilerplate' => 'Crear texto con formato',
	'This boilerplate has been saved.' => 'Se ha guardado este texto con formato.',
	'Save changes to this boilerplate (s)' => 'Guardar los cambios de este texto con formato (s)',
	q{The boilerplate '[_1]' is already in use in this blog.} => q{Este blog ya usa el texto con formato '[_1]'.},

## plugins/FormattedText/tmpl/cms/list_formatted_text.tmpl
	'The boilerplate has been deleted from the database.' => 'Se ha borrado de la base de datos el texto con formato.',

## plugins/GoogleAnalytics/config.yaml
	'Site statistics plugin using Google Analytics.' => 'Extensión para estadísticas del sitio mediante Google Analytics.',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/App.pm
	'A Perl module required for using Google Analytics API is missing: [_1].' => 'No se encuentra el módulo de Perl necesario para la API de Google Analytics: [_1].',
	'You did not specify a client ID.' => 'No especificó el ID de cliente.',
	'You did not specify a code.' => 'No especificó el código.',
	'The name of the profile' => 'El nombre del perfil',
	'The web property ID of the profile' => 'El ID del web propietario del perfil',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/OAuth2.pm
	'An error occurred when getting token: [_1]: [_2]' => 'Ocurrió un error al obtener el token: [_1]: [_2]',
	'An error occurred when refreshing access token: [_1]: [_2]' => 'Ocurrió un error al refrescar el token de acceso: [_1]: [_2]',
	'An error occurred when getting accounts: [_1]: [_2]' => 'Ocurrió un error al obtener las cuentas: [_1]: [_2]',
	'An error occurred when getting profiles: [_1]: [_2]' => 'Ocurrió un error al obtener los perfiles: [_1]: [_2]',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/Provider.pm
	'An error occurred when retrieving statistics data: [_1]: [_2]' => 'Ocurrió un error al obtener las estadísticas: [_1]: [_2]',

## plugins/GoogleAnalytics/tmpl/api_error.tmpl
	'API error' => 'Error del API',

## plugins/GoogleAnalytics/tmpl/select_profile.tmpl
	'Select profile' => 'Seleccionar perfil',

## plugins/GoogleAnalytics/tmpl/web_service_config.tmpl
	'Google Analytics' => 'Google Analytics',
	'OAuth2 settings' => 'Configuración OAuth2',
	'This [_2] is using the settings of [_1].' => 'Este [_2] está usando la configuración de [_1].',
	'Other Google account' => 'Otra cuenta de Google',
	q{Create an OAuth2 application's Client ID for web applications with this redirect URI via <a href="https://cloud.google.com/console" target="_blank">Google Cloud Platform</a> before selecting profile.} => q{Antes de seleccionar el perfil, cree un ID de cliente para la autentificación OAuth2 de aplicaciones web, usando esta URI de redirección vía <a href="https://cloud.google.com/console" target="_blank">Google Cloud Platform</a>.}, # Translate - New
	'Redirect URI of the OAuth2 application' => 'URI de redirección de la aplicación OAuth2',
	'Client ID of the OAuth2 application' => 'ID de cliente de la aplicación OAuth2',
	'Client secret of the OAuth2 application' => 'Secreto de cliente de la aplicación OAuth2',
	'Google Analytics profile' => 'Perfil de Google Analytics',
	'Select Google Analytics profile' => 'Seleccione perfil de Google Analytics',
	'(No profile selected)' => '(No hay perfil seleccionado)',
	'Client ID or client secret for Google Analytics was changed, but profile was not updated. Are you sure you want to save these settings?' => 'El ID o el secreto de cliente para Google Analytics ha cambiado, pero no se ha actualizado el perfil. ¿Está seguro de querer guardar esta configuración?',

## plugins/Loupe/lib/Loupe/App.pm
	'Loupe settings has been successfully. You can send invitation email to users via <a href="[_1]">Loupe Plugin Settings</a>.' => 'La configuración de Loupe se ha guardado con éxito. Puede enviar una invitación por correo a los usuarios a través de la <a href="[_1]">Configuración de la extensión Loupe</a>.',
	'Error saving Loupe settings: [_1]' => 'Error guardando la configuración de Loupe',
	'Send invitation email' => 'Enviar correo de invitación',
	'Could not send a invitation mail because Loupe is not enabled.' => 'No se pudo enviar un correo de invitación porque Loupe no está habilitado.',
	'Welcome to Loupe' => 'Bienvenido a Loupe',

## plugins/Loupe/lib/Loupe/Mail.pm
	'Loupe invitation mail has been sent to [_3] for user \'[_1]\' (user #[_2]).' => 'El correo de invitación a Loupe fue enviado a [_3] para el usuario \'[_1]\' (usuario #[_2]).',

## plugins/Loupe/lib/Loupe.pm
	'Loupe\'s HTML file name must not be blank.' => 'El nombre del fichero HTML de Loupe no puede estar en blanco.',
	'The URL should not include any directory name: [_1]' => 'La URL no debería incluir ningún nombre de directorio: [_1]',
	'Could not create Loupe directory: [_1]' => 'No se pudo crear el directorio para Loupe: [_1]',
	'Loupe HTML file has been created: [_1]' => 'Se ha creado el fichero HTML para Loupe: [_1]',
	'Could not create Loupe HTML file: [_1]' => 'No se pudo crear el fichero HTML para Loupe: [_1]',
	'Loupe HTML file has been deleted: [_1]' => 'El fichero HTML para Loupe ha sido borrado: [_1]',
	'Could not delete Loupe HTML file: [_1]' => 'No se pudo borrar el fichero HTML para Loupe: [_1]',

## plugins/Loupe/lib/Loupe/Upgrade.pm
	'Adding Loupe dashboard widget...' => 'Añadiendo panel de control para Loupe...',

## plugins/Loupe/Loupe.pl
	'Loupe is a mobile-friendly alternative console for Movable Type to let users approve pending entries and comments, upload photos, and view website and blog statistics.' => 'Loupe es una consola de Movable Type pensada para móbiles, que permite a los usuarios aprobar entradas pendientes, subir imágenes y comprobar las estadísticas.',

## plugins/Loupe/tmpl/dialog/welcome_mail_result.tmpl
	'Send Loupe welcome email' => 'Enviar correo de bienvenida a Loupe',

## plugins/Loupe/tmpl/system_config.tmpl
	'Enable Loupe' => 'Activar Loupe',
	q{The URL of Loupe's HTML file.} => q{La URL del fichero HTML de Loupe.},

## plugins/Loupe/tmpl/welcome_mail_html.tmpl
	'Your MT blog status at a glance' => 'El estado de su blog de MT de un vistazo',
	'Dear [_1], ' => 'Estimado/a [_1]',
	'With Loupe, you can check the status of your blog without having to sign in to your Movable Type account.' => 'Con Loupe, puede comprobar el estado del blog sin iniciar una sesión en Movable Type.',
	'View Access Analysis' => 'Ver estadísticas de acceso',
	'Approve Entries' => 'Aprobar entradas',
	'Reply to Comments' => 'Responder a comentarios',
	'Loupe is best used with a smartphone (iPhone or Android 4.0 or higher)' => 'Loupe está optimizado para móviles inteligentes (iPhone o Android 4.0 o mayor)',
	'Try Loupe' => 'Probar Loupe',
	'Perfect for Mini-tasking' => 'Perfecto para mini-tareas',
	'_LOUPE_BRIEF' => '"¿Cuáles de mis entradas son populares en este momento?" "¿Tengo entradas pendientes de aprobación?" "Debo responder a este comentario cuanto antes..." Puede realizar todas estas minitareas desde un móvil inteligente. Hemos diseñado Loupe para que echar un ojo a sus blogs sea lo más simple posible.',
	'Use Loupe to help manage your Movable Type blogs no matter where you are!' => '¡Utilice Loupe para administrar Movable Type allá donde se encuentre!',
	'Social Media' => 'Medios sociales',
	'https://twitter.com/movabletype' => 'https://twitter.com/movabletype',
	'Contact Us' => 'Contacto',
	'http://www.movabletype.org/' => 'http://www.movabletype.org/',
	'http://plugins.movabletype.org' => 'http://plugins.movabletype.org/',

## plugins/Loupe/tmpl/welcome_mail_plain.tmpl
	'Loupe is ready for use!' => '¡Loupe está listo para su uso!',

## plugins/Loupe/tmpl/widget/welcome_to_loupe.tmpl
	'Loupe is a mobile-friendly alternative console for Movable Type to let users approve pending entries and comments, upload photos, and view website and blog statistics. <a href="http://www.movabletype.org/documentation/loupe/" target="_blank">See more details.</a>' => 'Loupe es una consola alternativa para Movable Type especialmente diseñada para dispositivos móviles, que permite aprobar entradas y comentarios pendientes, subir fotografías, y consultar las estadísticas de los blogs y los sitios web. Consulta <a href="http://www.movabletype.org/documentation/loupe/" target="_blank">más información</a>.',
	'Loupe can be used without complex configuration, you can get started immediately.' => 'Loupe no necesita una configuración compleja, puede comenzar a usarlo de inmediato.',
	'Configure Loupe' => 'Configurar Loupe',

## plugins/Markdown/Markdown.pl
	'A plain-text-to-HTML formatting plugin.' => 'Un plugin de formateo plain-text hacia HTML',
	'Markdown' => 'Markdown',
	'Markdown With SmartyPants' => 'Markdown con SmartyPants',

## plugins/Markdown/SmartyPants.pl
	q{Easily translates plain punctuation characters into 'smart' typographic punctuation.} => q{Traduce fácilmente los carácteres de puntuación clásicos dentro de 'inteligente' tipografía de puntuación.},

## plugins/mixiComment/lib/mixiComment/App.pm
	'mixi reported that you failed to login.  Try again.' => 'mixi informó que falló la identificación. Inténtelo de nuevo.',

## plugins/mixiComment/mixiComment.pl
	'Allows commenters to sign in to Movable Type using their own mixi username and password via OpenID.' => 'Permite a los comentaristas identificarse en Movable Type usando su propio usuario y contraseña de mixi vía OpenID.',
	'mixi' => 'mixi',

## plugins/mixiComment/tmpl/config.tmpl
	'A mixi ID has already been registered in this blog.  If you want to change the mixi ID for the blog, <a href="[_1]">click here</a> to sign in using your mixi account.  If you want all of the mixi users to comment to your blog (not only your my mixi users), click the reset button to remove the setting.' => 'Ya se ha registrado un ID de mixi en este blog. Si desea modificar el ID de mixi del blog, <a href="[_1]">haga clic aquí</a> para identificarse en su cuenta de mixi. Si desea que todos los usuarios de mixi puedan comentar en el blog (no solo sus usuarios de my mixi), haga clic en el botón de reiniciar para eliminar la configuración.',
	'If you want to restrict comments only from your my mixi users, <a href="[_1]">click here</a> to sign in using your mixi account.' => 'Si desea restringir los comentarios a sus usuarios de my mixi, <a href="[_1]">haga clic aquí</a> para identificarse en su cuenta de mixi.',

## plugins/MultiBlog/lib/MultiBlog.pm
	'Restoring MultiBlog rebuild trigger for blog #[_1]...' => 'Restaurando MultiBlog el inductor de reconstrucción en el blog #[_1]...',

## plugins/MultiBlog/lib/MultiBlog/Tags.pm
	'MTMultiBlog tags cannot be nested.' => 'Las etiquetas MTMultiBlog no se pueden anidar.',
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Valor del atributo "mode" desconocido: [_1]. Los valores válidos son "loop" y "context".',

## plugins/MultiBlog/multiblog.pl
	'MultiBlog allows you to publish content from other blogs and define publishing rules and access controls between them.' => 'MultiBlog le permite publicar contenidos de otros blogs y definir reglas de publicación y control de accesos entre ellas.',
	'MultiBlog' => 'MultiBlog',
	'Create Trigger' => 'Crear nuevo inductor',
	'Search Weblogs' => 'Buscar en weblogs',
	'When this' => 'Cuando este',
	'(All blogs in this website)' => '(Todos los blogs en este sitio web)',
	'Select to apply this trigger to all blogs in this website.' => 'Aplica este inductor a todos los blogs del sitio web.',
	'(All websites and blogs in this system)' => '(Todos los sitios web y blogs del sistema)',
	'Select to apply this trigger to all websites and blogs in this system.' => 'Aplica este inductor a todos los sitios web del sistema.',
	'saves an entry/page' => 'guarda una entrada/página',
	'publishes an entry/page' => 'publica una entrada/página',
	'unpublishes an entry/page' => 'despublica una entrada/página',
	'publishes a comment' => 'publica un comentario',
	'publishes a TrackBack' => 'publica un TrackBack',
	'rebuild indexes.' => 'reconstruye los índices.',
	'rebuild indexes and send pings.' => 'reconstruye los índices y envía pings.',
	'Updating the MultiBlog trigger cache...' => 'Actualizando la caché de inductores de MultiBlog...',

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'When' => 'Cuando',
	'Trigger' => 'Inductor',
	'Action' => 'Acción',
	'Content Privacy' => 'Privacidad de contenidos',
	'Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.' => 'Especifique si otros blogs de la instalación podrán publicar contenidos de este blog. Esta opción tiene prioridad sobre la política predefinida de agregación del sistema que se encuentra en la configuración a nivel del sistema de MultiBlog.',
	'Use system default' => 'Utilizar valor predefinido del sistema',
	'Allow' => 'Permitir',
	'Disallow' => 'No permitir',
	'MTMultiBlog tag default arguments' => 'Argumentos predefinidos de la etiqueta MTMultiBlog',
	q{Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or 'all' (include_blogs only) are acceptable values.} => q{Perimite el uso de la etiqueta MTMultiBlog sin los atributos include_blogs/exclude_blogs. Se aceptan como valores BlogIDs separados por comas o 'all' (include_blogs solamente).},
	'Include blogs' => 'Incluir blogs',
	'Exclude blogs' => 'Excluir blogs',
	'Rebuild Triggers' => 'Eventos de republicación',
	'Create Rebuild Trigger' => 'Crear un evento de republicación',
	'You have not defined any rebuild triggers.' => 'No ha definido ningún inductor de reconstrucción.',

## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
	'Create MultiBlog Trigger' => 'Crear inductor de MultiBlog',

## plugins/MultiBlog/tmpl/system_config.tmpl
	'Default system aggregation policy' => 'Política predefinida de agregación del sistema',
	'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'La agregación cruzada de blogs estará permitida por defecto. Los blogs individuales se podrán configurar a través de sus ajustes de MultiBlog para restringir a otros blogs el acceso a sus contenidos.',
	'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'La agregación cruzada de blogs no estará permitida por defecto. Individualmente se podrá configurar a los blogs a través de sus ajustes de MultiBlog para permitir a otros blogs el acceso a sus contenidos.',

## plugins/SmartphoneOption/config.yaml
	'Provides an iPhone, iPad and Android touch-friendly UI for Movable Type. Once enabled, navigate to your MT installation from your mobile to use this interface.' => 'Provee a Movable Type un interfaz táctil especialmente adaptado a iPhone, iPad y Android.',
	'iPhone' => 'iPhone',
	'iPad' => 'iPad',
	'Android' => 'Android',
	'Desktop' => 'Escritorio',

## plugins/SmartphoneOption/lib/Smartphone/CMS/Entry.pm
	'Re-Edit' => 'Re-editar',
	'Re-Edit (e)' => 'Re-editar (e)',
	'Rich Text(HTML mode)' => 'Texto con formato (modo HTML)',

## plugins/SmartphoneOption/lib/Smartphone/CMS/Listing.pm
	'All' => 'Todos',
	'Filters which you created from PC.' => 'Filtros creados en el PC.',

## plugins/SmartphoneOption/lib/Smartphone/CMS.pm
	'This function is not supported by [_1].' => 'Esta función no está soportada por [_1]',
	'This function is not supported by your browser.' => 'Esta función no está soportada por su navegador.',
	'Mobile Dashboard' => 'Panel de Control - Móvil',
	'Rich text editor is not supported by your browser. Continue with  HTML editor ?' => 'El editor de texto con formato no está soportado por el navegador. ¿Continuar con el editor HTML?',
	'Syntax highlight is not supported by your browser. Disable to continue ?' => 'El coloreado de sintaxis no está soportado por el navegador. ¿Desactivar para continuar? ',
	'[_1] View' => 'Vista [_1]',

## plugins/SmartphoneOption/lib/Smartphone/CMS/Search.pm

## plugins/SmartphoneOption/smartphone.yaml
	'to [_1]' => 'a [_1]',
	'Smartphone Main' => 'Móvil Principal',
	'Smartphone Sub' => 'Móvil Secundario',

## plugins/SmartphoneOption/tmpl/cms/dialog/select_formatted_text.tmpl
	'No boilerplate could be found.' => 'No se pudo encontrar ningún texto plantilla.',

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

## plugins/spamlookup/spamlookup_words.pl
	'SpamLookup module for moderating and junking feedback using keyword filters.' => 'Módulo SpamLookup para la moderación y marcado como spam de respuestas mediante filtros de palabras claves.',
	'SpamLookup Keyword Filter' => 'Filtro de palabras claves de SpamLookup',

## plugins/spamlookup/tmpl/lookup_config.tmpl
	q{Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog's Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.} => q{Lookups vigila el origen de las direcciones IP y los hiperenlaces de todas las respuestas entrantes. Si un comentario un TrackBack proviene de una dirección IP o un dominio incluídos en las listas negras, se retendrán para su moderación o se puntuarán como basura y se situarán en la carpeta Basura del blog. Además, se podrán realizar comprobaciones avanzadas sobre la fuente de datos de los TrackBacks.},
	'IP Address Lookups' => 'Verificar una Dirección IP',
	'Moderate feedback from blacklisted IP addresses' => 'Moderar respuestas de direcciones IP que estén en listas negras',
	'Junk feedback from blacklisted IP addresses' => 'Marcar como basura las respuestas de direcciones IP que estén en listas negras',
	'Adjust scoring' => 'Ajustar puntuación',
	'Score weight:' => 'Peso de la puntuación:',
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

## plugins/spamlookup/tmpl/url_config.tmpl
	'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Los filtros de enlaces comprueban el número de hiperenlaces en las respuestas entrantes. Las respuestas con demasiados enlaces se moderarán o se puntuarán como basura. Las respuestas que no contengan enlaces o que solo se refieran a URLs publicadas anteriormente recibirán puntuación positiva. (Habilite esta opción solo si está seguro de que su sitio está libre de spam).',
	'Link Limits' => 'Límites de enlaces',
	'Credit feedback rating when no hyperlinks are present' => 'Puntuar positivamente si no hay hiperenlaces',
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

## plugins/spamlookup/tmpl/word_config.tmpl
	'Incoming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Se puede monitorizar las respuestas entrantes por palabras claves, dominios y patrones concretos. Las coincidencias serán retenidas para su moderación o se puntuarán como basura. Además, se puede personalizar las puntuaciones de basura de estas coincidencias.',
	'Keywords to Moderate' => 'Palabras clave para moderar',
	'Keywords to Junk' => 'Palabras clave para marcar como basura',

## plugins/StyleCatcher/config.yaml
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks.' => 'StyleCatcher le permite navegar fácilmente por los estilos y aplicarlos en el blog con un par de clics.',
	'MT 4 Style Library' => 'Librería de estilos de MT 4',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Una colección de estilos compatible con las plantillas predefinidas de Movable Type.',
	'Styles' => 'Estilos',
	'Moving current style to blog_meta for website...' => 'Migrando el estilo actual a blog_meta para el sitio web...',
	'Moving current style to blog_meta for blog...' => 'Migrando el estilo actual a blog_meta para el blog...',

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'No se encontró el directorio mt-static. Por favor, configure el \'StaticFilePath\' para continuar.',
	'Permission Denied.' => 'Permiso denegado.',
	'Successfully applied new theme selection.' => 'Se aplicó con éxito la nueva selección de estilo.',

## plugins/StyleCatcher/lib/StyleCatcher/Library/Default.pm
	'Invalid URL: [_1]' => 'URL no válida: [_1]',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'No se pudo crear el directorio [_1] - Compruebe que el servidor web puede escribir en la carpeta \'themes\'.',

## plugins/StyleCatcher/lib/StyleCatcher/Library/Local.pm
	'Failed to load StyleCatcher Library: [_1]' => 'Fallí al cargar la librería de StyleCatcher: [_1]',

## plugins/StyleCatcher/lib/StyleCatcher/Util.pm
	'(Untitled)' => '(sin título)',

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a [_1] Style' => 'Seleccionar un estilo de [_1]',
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

## plugins/Textile/textile2.pl
	'A humane web text generator.' => 'Un generador de texto web humano',
	'Textile 2' => 'Textile 2',

## plugins/TinyMCE/config.yaml
	'Default WYSIWYG editor.' => 'Editor con formato predefinido',
	'TinyMCE' => 'TinyMCE',

## plugins/WidgetManager/WidgetManager.pl
	'Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.' => 'Administrador de Widgets versión 1.1; Esta versión de la extensión actualiza los datos de la versiones antiguas del Adminstrador de Widgets que venía con Movable Type al esquema interno de Movable Type. No se han incluído otras características. Puede borrar esta extensión sin problemas después de instalar o actualizar Movable Type.',
	'Moving storage of Widget Manager [_2]...' => 'Trasladando los datos del Administrador de Widgets [_2]...',
	'Failed.' => 'Fallo.',

## plugins/WXRImporter/config.yaml
	'Import WordPress exported RSS into MT.' => 'Importar WordPress exported RSS hacia MT.',
	'"WordPress eXtended RSS (WXR)"' => '"WordPress eXtended RSS (WXR)"',
	'"Download WP attachments via HTTP."' => '"Descargar los adjuntos de WP vía HTTP."',

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
	'Entry has no MT::Trackback object!' => '¡La entrada no tiene objeto MT::Trackback!',
	'Assigning permissions for new user...' => 'Asignar permisos al nuevo usuario...',
	'Saving permission failed: [_1]' => 'Fallo guardando permisos: [_1]',

## plugins/WXRImporter/tmpl/options.tmpl
	q{Before you import WordPress posts to Movable Type, we recommend that you <a href='[_1]'>configure your blog's publishing paths</a> first.} => q{Antes de importar las entradas de WordPress a Movable Type, le recomendamos que primero <a href='[_1]'>configure las rutas de publicación del blog</a>.},
	'Upload path for this WordPress blog' => 'Ruta de transferencia para este blog de WordPress',
	'Replace with' => 'Reemplazar con',
	'Download attachments' => 'Descargar adjuntos',
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'Necesita el uso de una tarea del cron para descargar los adjuntos de un blog de WordPress en segundo plano.',
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'Descargar adjuntos (imágenes y ficheros) de un blog importado de WordPress.',

);

## New words: 194

1;
