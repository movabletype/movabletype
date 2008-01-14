# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::L10N::es;
use strict;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

## The following is the translation table.

%Lexicon = (

## php/lib/function.mtvar.php
	'You used a [_1] tag without a valid name attribute.' => 'Usó la etiqueta [_1] sin un nombre de atributo válido.', # Translate - New
	'\'[_1]\' is not a valid function for a hash.' => '\'[_1]\' no es una función válida para un hash.', # Translate - New
	'\'[_1]\' is not a valid function for an array.' => '\'[_1]\' no es una función válida para un array.', # Translate - New
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] es ilegal.', # Translate - New

## php/lib/archive_lib.php
	'Page' => 'Página',
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

## php/lib/block.mtsethashvar.php

## php/lib/block.mtif.php

## php/lib/function.mtremotesigninlink.php
	'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'La autentificación en TypeKey no está habilitada en este blog. No se puede usar MTRemoteSignInLink.',

## php/lib/block.mtauthorhaspage.php
	'No author available' => 'Ningún autor disponible', # Translate - New

## php/lib/block.mtauthorhasentry.php

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Introduzca los caracteres que ve en la imagen de arriba.',

## php/lib/function.mtsetvar.php
	'\'[_1]\' is not a hash.' => '\'[_1]\' no es un hash.', # Translate - New
	'Invalid index.' => 'Índice no válido.', # Translate - New
	'\'[_1]\' is not an array.' => '\'[_1]\' no es un array.', # Translate - New
	'\'[_1]\' is not a valid function.' => '\'[_1]\' no es una función válida.', # Translate - New

## php/lib/block.mtassets.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" debe usarse en combinación con el espacio de nombres.',

## php/lib/block.mtsetvarblock.php

## php/lib/block.mtentries.php

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'avatar-[_1]-%wx%h%x',

## php/lib/function.mtauthordisplayname.php

## php/lib/function.mtentryclasslabel.php
	'page' => 'página',
	'entry' => 'entrada',
	'Entry' => 'Entrada',

## default_templates/notify-entry.mtml
	'A new [lc,_3] entitled \'[_1]\' has been published to [_2].' => 'Un nuevo [lc,_3] titulado \'[_1]\' ha sido publicado en [_2].',
	'View entry:' => 'Ver entrada:',
	'View page:' => 'Ver página:', # Translate - New
	'[_1] Title: [_2]' => '[_1] Título: [_2]',
	'Publish Date: [_1]' => 'Fecha de publicación: [_1]',
	'Message from Sender:' => 'Mensaje del expeditor',
	'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'Ha recibido este correo porque seleccionó recibir avisos sobre la publicación de nuevos contenidos en [_1] o porque el autor de la entrada pensó que podría serle de interés. Si no quiere recibir más avisos, por favor, contacte con esta persona:',

## default_templates/main_index.mtml
	'Header' => 'Cabecera',
	'Entry Summary' => 'Resumen de las entradas',
	'Archives' => 'Archivos',

## default_templates/page.mtml
	'Page Detail' => 'Detalle de la página',
	'TrackBacks' => 'TrackBacks',
	'Comments' => 'Comentarios',

## default_templates/entry_summary.mtml
	'Entry Metadata' => 'Entrada de los Metadatos',
	'Tags' => 'Etiquetas',
	'Continue reading <a rel="bookmark" href="[_1]">[_2]</a>.' => 'Continúe leyendo <a rel="bookmark" href="[_1]">[_2]</a>.',

## default_templates/comment_response.mtml
	'Comment Submitted' => 'Comentario enviado',
	'Confirmation...' => 'Confirmación...',
	'Your comment has been submitted!' => '¡El comentario se ha recibido!',
	'Comment Pending' => 'Comentario pendiente',
	'Thank you for commenting.' => 'Gracias por comentar.',
	'Your comment has been received and held for approval by the blog owner.' => 'El comentario que envió fue recibido y está retenido para su aprobación por parte del administrador del weblog.',
	'Comment Submission Error' => 'Error en el envío de comentarios',
	'Your comment submission failed for the following reasons:' => 'El envío de su comentario falló por las siguientes razones:',
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

## default_templates/entry_detail.mtml
	'Categories' => 'Categorías',

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

## default_templates/comment_detail.mtml
	'[_1] [_2] said:' => '[_1] [_2] dijo:',
	'<a href="[_1]" title="Permalink to this comment">[_2]</a>' => '<a href="[_1]" title="Enlace permanente a este comentario">[_2]</a>',

## default_templates/comment_form.mtml
	'Leave a comment' => 'Escribir un comentario',
	'Name' => 'Nombre',
	'Email Address' => 'Dirección de correo electrónico',
	'Remember personal info?' => '¿Recordar datos personales?',
	'(You may use HTML tags for style)' => '(Puede usar etiquetas HTML para el estilo)',
	'Preview' => 'Vista previa',
	'Submit' => 'Enviar',
	'Cancel' => 'Cancelar',

## default_templates/comment_throttle.mtml
	'If this was a mistake, you can unblock the IP address and allow the visitor to add it again by logging in to your Movable Type installation, going to Blog Config - IP Banning, and deleting the IP address [_1] from the list of banned addresses.' => 'Si fue un error, puede desbloquear la dirección IP y permitir al visitante que lo añada de nuevo iniciando una sesión en Movable Type, llendo a Configuración del blog - Bloqueo de IP, y borrando la dirección IP [_1] de la lista de direcciones bloquedas.',
	'A visitor to your blog [_1] has automatically been banned by adding more than the allowed number of comments in the last [_2] seconds.' => 'Se bloqueó automáticamente a una persona que visitó su weblog [_1] debido a que insertó más comentarios de los permitidos en menos de [_2] segundos.',
	'This has been done to prevent a malicious script from overwhelming your weblog with comments. The banned IP address is' => 'Esto se hizo para impedir que nadie o nada desborde malintencionadamente su weblog con comentarios. La dirección bloqueada es',

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

## default_templates/entry_listing.mtml
	'[_1] Archives' => 'Archivos [_1]',
	'Recently in <em>[_1]</em> Category' => 'Novedades en la categoría <em>[_1]</em>',
	'Recently by <em>[_1]</em>' => 'Novedades por <em>[_1]</em>',
	'Main Index' => 'Índice principal',

## default_templates/footer.mtml
	'Sidebar' => 'Barra lateral',
	'_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.org/sitees/"><$MTProductName$></a>',
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Este blog tiene una <a href="[_1]">Licencia Creative Commons</a>.',

## default_templates/tags.mtml

## default_templates/entry_metadata.mtml
	'By [_1] on [_2]' => 'Por [_1] el [_2]',
	'Permalink' => 'Enlace permanente',
	'Comments ([_1])' => 'Comentarios ([_1])',
	'TrackBacks ([_1])' => 'TrackBacks ([_1])',

## default_templates/entry.mtml
	'Entry Detail' => 'Detalle de la entrada',

## default_templates/recover-password.mtml
	'_USAGE_FORGOT_PASSWORD_1' => 'Solicitó la recuperación de su contraseña de Movable Type. Su contraseña se ha modificado en el sistema; ésta es su nueva contraseña:',
	'_USAGE_FORGOT_PASSWORD_2' => 'Debería poder iniciar una sesión en Movable Type con esta nueva contraseña. Después de iniciar la sesión, cambie su contraseña a otra que pueda memorizar y recordar fácilmente.',
	'Mail Footer' => 'Pie del correo',

## default_templates/javascript.mtml
	'Thanks for signing in,' => 'Gracias por registrarse en,',
	'. Now you can comment.' => '. Ahora puede comentar.',
	'sign out' => 'salir',
	'You do not have permission to comment on this blog.' => 'No tiene permisos para comentar en este blog.',
	'Sign in' => 'Registrarse',
	' to comment on this entry.' => ' para comentar en esta entrada.',
	' to comment on this entry,' => ' para comentar en esta entrada,',
	'or ' => 'o ',
	'comment anonymously.' => 'comentar anónimamente',

## default_templates/rss.mtml
	'Copyright [_1]' => 'Copyright [_1]',

## default_templates/archive_index.mtml
	'Monthly Archives' => 'Archivos mensuales',
	'Author Archives' => 'Archivos por autor',
	'Category Monthly Archives' => 'Archivos mensuales por categorías',
	'Author Monthly Archives' => 'Archivos mensuales por autores',

## default_templates/trackbacks.mtml
	'[_1] TrackBacks' => '[_1] TrackBacks',
	'Listed below are links to blogs that reference this entry: <a href="[_1]">[_2]</a>.' => 'Abajo están listados los blogs que hacen referencia a esta entrada: <a href="[_1]">[_2]</a>.',
	'TrackBack URL for this entry: <span id="trackbacks-link">[_1]</span>' => 'URL de TrackBack de esta entrada: <span id="trackbacks-link">[_1]</span>',
	'&raquo; <a href="[_1]">[_2]</a> from [_3]' => '&raquo; <a href="[_1]">[_2]</a> de [_3]',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">Leer más</a>',
	'Tracked on <a href="[_1]">[_2]</a>' => 'Enviado desde <a href="[_1]">[_2]</a>',

## default_templates/categories.mtml

## default_templates/comments.mtml
	'Comment Form' => 'Formulario de comentarios',
	'[_1] Comments' => '[_1] Commentarios',
	'Comment Detail' => 'Detalle del comentario',

## default_templates/search_results.mtml
	'Search Results' => 'Resultado de la búsqueda',
	'Results matching &ldquo;[_1]&rdquo; from [_2]' => 'Resultados correspondientes a &ldquo;[_1]&rdquo; de [_2]',
	'Results tagged &ldquo;[_1]&rdquo; from [_2]' => 'Resultado de etiquetas &ldquo;[_1]&rdquo; de [_2]',
	'Results matching &ldquo;[_1]&rdquo;' => 'Resultados correspondiente a &ldquo;[_1]&rdquo;',
	'Results tagged &ldquo;[_1]&rdquo;' => 'Resultado de etiquetas &ldquo;[_1]&rdquo;',
	'No results found for &ldquo;[_1]&rdquo;.' => 'Ningún resultado encontrado para &ldquo;[_1]&rdquo;.',
	'Instructions' => 'Instrucciones',
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Por defecto, este motor de búsqueda comprueba todas las palabras sin tener en cuenta el orden. Para buscar una frase exacta, encierre la frase entre comillas:',
	'movable type' => 'movable type',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'El motor de búsqueda también soporta los operadores AND, OR y NOT para especificar expresiones lógicas:',
	'personal OR publishing' => 'personal OR publicación',
	'publishing NOT personal' => 'publicación NOT personal',

## default_templates/sidebar_2col.mtml
	'Search' => 'Buscar',
	'Case sensitive' => 'Distinguir mayúsculas y minúsculas',
	'Regex search' => 'Expresión regular',
	'[_1] ([_2])' => '[_1] ([_2])',
	'About this Entry' => 'Sobre esta entrada',
	'About this Archive' => 'Sobre este archivo',
	'About Archives' => 'Sobre los archivos',
	'This page contains links to all the archived content.' => 'Esta página contiene enlaces a todos los contenidos archivados.',
	'This page contains a single entry by [_1] published on <em>[_2]</em>.' => 'Esta página contiene una sola entrada realizada por [_1] y publicada el <em>[_2]</em>.',
	'<a href="[_1]">[_2]</a> was the previous entry in this blog.' => '<a href="[_1]">[_2]</a> es la entrada anterior en este blog.',
	'<a href="[_1]">[_2]</a> is the next entry in this blog.' => '<a href="[_1]">[_2]</a> es la entrada siguiente en este blog.',
	'This page is a archive of entries in the <strong>[_1]</strong> category from <strong>[_2]</strong>.' => 'Esta página es un archivo de las entradas en la categoría <strong>[_1]</strong> de <strong>[_2]</strong>.',
	'<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> es el archivo anterior.',
	'<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> es el siguiente archivo.',
	'This page is a archive of recent entries in the <strong>[_1]</strong> category.' => 'Esta página es un archivo de las entradas recientes en la categoría <strong>[_1]</strong>.',
	'<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> es la categoría anterior.',
	'<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> es la siguiente categoría.',
	'This page is a archive of recent entries written by <strong>[_1]</strong> in <strong>[_2]</strong>.' => 'Esta página es un archivo de las entradas recientes escritas por <strong>[_1]</strong> en <strong>[_2]</strong>.',
	'This page is a archive of recent entries written by <strong>[_1]</strong>.' => 'Esta página es un archivo de las entradas recientes escritas por <strong>[_1]</strong>.',
	'This page is an archive of entries from <strong>[_2]</strong> listed from newest to oldest.' => 'Esta página es un archivo de las entradas de <strong>[_2]</strong>, ordenadas de nuevas a antiguas.',
	'Find recent content on the <a href="[_1]">main index</a>.' => 'Encontrará los contenidos recientes en la <a href="[_1]">página principal</a>.',
	'Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.' => 'Encontrará los contenidos recientes en la <a href="[_1]">página principal</a>. Consulte los <a href="[_2]">archivos</a> para ver todos los contenidos.',
	'Recent Entries' => 'Entradas recientes',
	'Photos' => 'Fotos',
	'Tag Cloud' => 'Nube de etiquetas',
	'[_1] <a href="[_2]">Archives</a>' => '[_1] <a href="[_2]">Archivos</a>',
	'[_1]: Monthly Archives' => '[_1]: Archivos mensuales',
	'Subscribe to feed' => 'Suscribirse a la fuente de sindicación',
	'Subscribe to this blog\'s feed' => 'Suscribirse a este blog (XML)',
	'Search results matching &ldquo;<$MTSearchString$>&rdquo;' => 'Resultados de la búsqueda correspondientes a &ldquo;<$MTSearchString$>&rdquo;',
	'_MTCOM_URL' => '_MTCOM_URL',

## default_templates/sidebar_3col.mtml

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'Página no encontrada',

## default_templates/comment_preview.mtml
	'Comment on [_1]' => 'Comentario en [_1]',
	'Previewing your Comment' => 'Vista previa del comentario',

## default_templates/commenter_confirm.mtml
	'Thank you registering for an account to comment on [_1].' => 'Gracias por registrar una cuenta para comentar en [_1].',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to comment on [_1].' => 'Para su propia seguridad, y para prevenir fraudes, antes de continuar le solicitamos que confirme su cuenta y dirección de correo. Tras confirmarlas, podrá comentar en [_1].',
	'To confirm your account, please click on or cut and paste the following URL into a web browser:' => 'Para confirmar su cuenta, haga clic en (o copie y pegue) la URL en un navegador web:',
	'If you did not make this request, or you don\'t want to register for an account to comment on [_1], then no further action is required.' => 'Si no realizó esta petición, o no quiere registrar una cuenta para comentar en [_1], no se necesitan más acciones.',
	'Thank you very much for your understanding.' => 'Gracias por su comprensión.',
	'Sincerely,' => 'Cordialmente,',

## lib/MT/Asset/Video.pm
	'Video' => 'Vídeo',
	'Videos' => 'Vídeos',
	'video' => 'Vídeo',

## lib/MT/Asset/Audio.pm
	'Audio' => 'Audio',
	'audio' => 'Audio',

## lib/MT/Asset/Image.pm
	'Image' => 'Imagen',
	'Images' => 'Imágenes',
	'Actual Dimensions' => 'Tamaño actual',
	'[_1] x [_2] pixels' => '[_1] x [_2] píxeles',
	'Error cropping image: [_1]' => 'Error recortando imagen: [_1]',
	'Error scaling image: [_1]' => 'Error redimensionando la imagen: [_1]',
	'Error converting image: [_1]' => 'Error convirtiendo la imagen: [_1]',
	'Error creating thumbnail file: [_1]' => 'Error creando el fichero de la miniatura: [_1]',
	'%f-thumb-%wx%h%x' => '%f-thumb-%wx%h%x',
	'Can\'t load image #[_1]' => 'No se pudo cargar la imagen nº[_1]',
	'View image' => 'Ver imagen',
	'Permission denied setting image defaults for blog #[_1]' => 'Se denegó el permiso para cambiar las opciones predefinidos de imágenes del blog nº[_1]',
	'Thumbnail image for [_1]' => 'Imagen Thumbnail para [_1]',
	'Invalid basename \'[_1]\'' => 'Nombre base no válido \'[_1]\'',
	'Error writing to \'[_1]\': [_2]' => 'Error escribiendo en \'[_1]\': [_2]',
	'Popup Page for [_1]' => 'Página Popup para [_1]',

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

## lib/MT/Util/Archive.pm
	'Type must be specified' => 'Debe especificar el tipo',
	'Registry could not be loaded' => 'El registro no pudo cargarse',

## lib/MT/Util/Captcha.pm
	'Movable Type default CAPTCHA provider requires Image::Magick.' => 'El proveedor predefinido de CAPTCHA de Movable Type necesita Image::Magick',
	'You need to configure CaptchaSourceImageBase.' => 'Debe configurar CaptchaSourceImageBase.',
	'Image creation failed.' => 'Falló la creación de la imagen.',
	'Image error: [_1]' => 'Error de imagen: [_1]',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: [_2][_3] de la regla [_4][_5]',
	'[_1]: [_2][_3] from test [_4]' => '[_1]: [_2][_3] de la prueba [_4]',

## lib/MT/Auth/TypeKey.pm
	'Sign in requires a secure signature.' => 'La identificación necesita una firma segura.',
	'The sign-in validation failed.' => 'Falló el registro de validación.',
	'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Este weblog obliga a que los comentaristas den su dirección de correo electrónico. Si lo desea puede iniciar una sesión de nuevo, y dar al servicio de autentificación permisos para pasar la dirección de correo electrónico.',
	'Couldn\'t save the session' => 'No se pudo guardar la sesión',
	'This blog requires commenters to provide an email address' => 'Para hacer comentarios en este blog debe tener una dirección de correo electrónico',
	'Couldn\'t get public key from url provided' => 'No se pudo obtener la clave pública desde la URL indicada',
	'No public key could be found to validate registration.' => 'No se encontró la clave pública para validar el registro.',
	'TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'La firma TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]',
	'The TypeKey signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'La firma TypeKey está caducada ([_1] segundos vieja). Asegúrese de que el reloj de su servidor está en hora',

## lib/MT/Auth/OpenID.pm
	'Invalid request.' => 'Petición no válida.',
	'The address entered does not appear to be an OpenID' => 'La dirección introducida no parecer ser un OpenID', # Translate - New
	'The text entered does not appear to be a web address' => 'El texto introducido no parece ser una dirección web', # Translate - New
	'Unable to connect to [_1]: [_2]' => 'Imposible conectarse a [_1]: [_2]', # Translate - New
	'Could not verify the OpenID provided: [_1]' => 'No se pudo verificar el OpenID provisto: [_1]', # Translate - New

## lib/MT/Auth/MT.pm
	'Passwords do not match.' => 'Las contraseñas no coinciden.',
	'Failed to verify current password.' => 'Fallo al verificar la contraseña actual.',
	'Password hint is required.' => 'Se necesita la pista de contraseña.',

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

## lib/MT/BackupRestore/ManifestFileHandler.pm
	'Uploaded file was not a valid Movable Type backup manifest file.' => 'El fichero transferido no era un fichero no válido de manifiesto de copia de seguridad de Movable Type.',

## lib/MT/BackupRestore/BackupFileHandler.pm
	'Uploaded file was backed up from Movable Type with the newer schema version ([_1]) than the one in this system ([_2]).  It is not safe to restore the file to this version of Movable Type.' => 'Se hizo una copia de segurodad del fichero transferido desde Movable Type con una versión más reciente del esquema ([_1]) que el de este sistema ([_2]). No es seguro restaurar el fichero en esta versión de Movable Type.',
	'[_1] is not a subject to be restored by Movable Type.' => '[_1] no es un elemento para ser restaurado por Movable Type.',
	'[_1] records restored.' => '[_1] registros restaurados.',
	'Restoring [_1] records:' => 'Restaurando [_1] registros:',
	'User with the same name as the name of the currently logged in ([_1]) found.  Skipped the record.' => 'Se encontró un usuario con el mismo nombre que la persona identificada ([_1]). Saltar la identificación.',
	'User with the same name \'[_1]\' found (ID:[_2]).  Restore replaced this user with the data backed up.' => 'Se encontró un usuario con el mismo nombre \'[_1]\' (ID:[_2]). La restauración reemplazó este usuario con los datos de la copia de seguridad.',
	'Tag \'[_1]\' exists in the system.' => 'La etiqueta \'[_1]\' existe en el sistema.',
	'[_1] records restored...' => '[_1] registros restaurados...',

## lib/MT/Template/Context.pm
	'The attribute exclude_blogs cannot take \'all\' for a value.' => 'El atributo exclude_blogs no puede tomar el valor \'all\'.',

## lib/MT/Template/ContextHandlers.pm
	'Remove this widget' => 'Eliminar el widget',
	'[_1]Publish[_2] your site to see these changes take effect.' => '[_1]Publique[_2] el sitio para que los cambios tomen efecto.',
	'Actions' => 'Acciones',
	'Warning' => 'Alerta',
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.org/documentation/appendices/tags/%t.html',
	'No [_1] could be found.' => 'No se encontraron [_1].',
	'Invalid tag [_1] specified.' => 'Especificada etiqueta no válida [_1].',
	'Recursion attempt on [_1]: [_2]' => 'Intento de recursión en [_1]: [_2]',
	'Can\'t find included template [_1] \'[_2]\'' => 'No se encontró la plantilla incluída [_1] \'[_2]\'',
	'Can\'t find blog for id \'[_1]' => 'No se pudo encontrar un blog con el id \'[_1]',
	'Can\'t find included file \'[_1]\'' => 'No se encontró el fichero incluido \'[_1]\'',
	'Error opening included file \'[_1]\': [_2]' => 'Error abriendo el fichero incluido \'[_1]\': [_2]',
	'Recursion attempt on file: [_1]' => 'Intento de recursión en fichero: [_1]',
	'Unspecified archive template' => 'Archivo de plantilla no especificado',
	'Error in file template: [_1]' => 'Error en fichero de plantilla: [_1]',
	'Can\'t load template' => 'No se pudo cargar la plantilla',
	'Can\'t find template \'[_1]\'' => 'No se encontró la plantilla \'[_1]\'',
	'Can\'t find entry \'[_1]\'' => 'No se encontró la entrada \'[_1]\'',
	'[_1] is not a hash.' => '[_1] no es un hash.', # Translate - New
	'You used an \'[_1]\' tag outside of the context of a author; perhaps you mistakenly placed it outside of an \'MTAuthors\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un autor; ¿quizás la situó por error fuera de un contenedor \'MTAuthors\'?',
	'You have an error in your \'[_2]\' attribute: [_1]' => 'Tiene un error en su atributo \'[_2]\': [_1]',
	'You have an error in your \'tag\' attribute: [_1]' => 'Tiene un error en el atributo \'tag\': [_1]',
	'No such user \'[_1]\'' => 'No existe el usario \'[_1]\'',
	'You used an \'[_1]\' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an \'MTEntries\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de una entrada; ¿quizás la puso por error fuera de un contenedor \'MTEntries\'?',
	'You used <$MTEntryFlag$> without a flag.' => 'Usó <$MTEntryFlag$> sin \'flag\'.',
	'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Usó una etiqueta [_1] enlazando los archivos \'[_2]\', pero el tipo de archivo no está publicado.',
	'Could not create atom id for entry [_1]' => 'No se pudo crear un identificador atom en la entrada [_1]',
	'To enable comment registration, you need to add a TypeKey token in your weblog config or user profile.' => 'Para habilitar el registro de comentarios, debe añadir un token de TypeKey a la configuración de su weblog o al perfil de su usario.',
	'The MTCommentFields tag is no longer available; please include the [_1] template module instead.' => 'La etiqueta MTCommentFields no está más disponible; por favor incluya el módulo de platilla [_1] que lo remplaza',
	'You used an [_1] tag without a date context set up.' => 'Usó una etiqueta [_1] sin un contexto de fecha configurado.',
	'You used an \'[_1]\' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an \'MTComments\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un comentario; ¿quizás la puso por error fuera de un contenedor \'MTComments\'?',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] sólo se puede usar con los archivos diarios, semanales o mensuales.',
	'Group iterator failed.' => 'Fallo en iterador de grupo.',
	'You used an [_1] tag outside of the proper context.' => 'Usó una etiqueta [_1] fuera del contexto correcto.',
	'Could not determine entry' => 'No se pudo determinar la entrada',
	'Invalid month format: must be YYYYMM' => 'Formato de mes no válido: debe ser YYYYMM',
	'No such category \'[_1]\'' => 'No existe la categoría \'[_1]\'',
	'[_1] cannot be used without publishing Category archive.' => '[_1] No se puede usar sin publicar archivos por categorías.', # Translate - New
	'<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> debe utilizarse en el contexto de una categoría, o con el atributo \'category\' en la etiqueta.',
	'You failed to specify the label attribute for the [_1] tag.' => 'No especificó el atributo título en la etiqueta [_1].',
	'You used an \'[_1]\' tag outside of the context of a ping; perhaps you mistakenly placed it outside of an \'MTPings\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un ping; ¿quizás la situó por error fuera de un contenedor \'MTPings\'?',
	'[_1] used outside of [_2]' => '[_1] utilizado fuera de [_2]',
	'MT[_1] must be used in a [_2] context' => 'MT[_1] debe utilizarse en el contexto de [_2]',
	'Cannot find package [_1]: [_2]' => 'No se encontró el paquete [_1]: [_2]',
	'Error sorting [_2]: [_1]' => 'Error ordenando [_2]: [_1]',
	'Edit' => 'Editar',
	'You used an \'[_1]\' tag outside of the context of an asset; perhaps you mistakenly placed it outside of an \'MTAssets\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un medio, ¿quizás la situó fuera de un contenedor \'MTAssets\' container?',
	'You used an \'[_1]\' tag outside of the context of an page; perhaps you mistakenly placed it outside of an \'MTPages\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de una página, ¿quizás la situó fuera de un contenedor \'MTPages\'?',
	'You used an [_1] without a author context set up.' => 'Utilizó un [_1] sin establecer un contexto de autor.',
	'Can\'t load user.' => 'No se pudor cargar el usuario.',
	'Division by zero.' => 'División por cero.', # Translate - New

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
	'Permission denied.' => 'Permiso denegado.',
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
	'Invalid request' => 'Petición no válida',
	'No entry_id' => 'Sin entry_id',
	'No such entry \'[_1]\'.' => 'No existe la entrada \'[_1]\'.',
	'You are not allowed to add comments.' => 'No tiene permisos para añadir comentarios.',
	'_THROTTLED_COMMENT' => 'Demasiados comentarios en un corto periodo de tiempo. Por favor, inténtelo dentro de un rato.',
	'Comments are not allowed on this entry.' => 'No se permiten comentarios en esta entrada.',
	'Comment text is required.' => 'El texto del comentario es obligatorio.',
	'An error occurred: [_1]' => 'Ocurrió un error: [_1]',
	'Registration is required.' => 'El registro es obligatorio.',
	'Name and email address are required.' => 'El nombre y la dirección de correo-e son obligatorios.',
	'Invalid email address \'[_1]\'' => 'Dirección de correo-e no válida \'[_1]\'',
	'Invalid URL \'[_1]\'' => 'URL no válida \'[_1]\'',
	'Text entered was wrong.  Try again.' => 'El texto que introdujo es erróneo. Inténtelo de nuevo.',
	'Comment save failed with [_1]' => 'Fallo guardando comentario con [_1]',
	'Comment on "[_1]" by [_2].' => 'Comentario en "[_1]" por [_2].',
	'Commenter save failed with [_1]' => 'Fallo guardando comentarista con [_1]',
	'Publish failed: [_1]' => 'Falló la publicación: [_1]',
	'Failed comment attempt by pending registrant \'[_1]\'' => 'Falló el intento de comentar por el comentarista pendiente \'[_1]\'',
	'Registered User' => 'Usuario registrado',
	'The sign-in attempt was not successful; please try again.' => 'El intento de registro no tuvo éxito; por favor, inténtelo de nuevo.',
	'The sign-in validation was not successful. Please make sure your weblog is properly configured and try again.' => 'La validación del registro no tuvo éxito. Por favor, asegúrese de que su weblog está configurado correctamente e inténtelo de nuevo.',
	'No such entry ID \'[_1]\'' => 'No existe el ID de entrada \'[_1]\'',
	'No entry was specified; perhaps there is a template problem?' => 'No se especificó ninguna entrada; ¿quizás hay un problema con la plantilla?',
	'Somehow, the entry you tried to comment on does not exist' => 'De alguna manera, la entrada en la que intentó comentar no existe',
	'Invalid commenter ID' => 'ID de comentarista no válido',
	'No entry ID provided' => 'ID de entrada no provista',
	'Permission denied' => 'Permiso denegado',
	'All required fields must have valid values.' => 'Todos los campos obligatorios deben tener valores válidos.',
	'Email Address is invalid.' => 'La dirección de correo no es válida.',
	'URL is invalid.' => 'La URL no es válida.',
	'Commenter profile has successfully been updated.' => 'Se actualizó con éxito el perfil del comentarista.',
	'Commenter profile could not be updated: [_1]' => 'No se pudo actualizar el perfil del comentarista: [_1]',

## lib/MT/App/Search.pm
	'You are currently performing a search. Please wait until your search is completed.' => 'En estos momentos está realizando una búsqueda. Por favor, espere hasta que se complete.',
	'Search failed. Invalid pattern given: [_1]' => 'Falló la búsqueda. Patrón no válido: [_1]',
	'Search failed: [_1]' => 'Falló la búsqueda: [_1]',
	'No alternate template is specified for the Template \'[_1]\'' => 'No se especificó una plantilla alternativa para la Plantilla \'[_1]\'',
	'Publishing results failed: [_1]' => 'Fallo al publicar los resultados: [_1]',
	'Search: query for \'[_1]\'' => 'Búsqueda: encontrar \'[_1]\'',
	'Search: new comment search' => 'Búsqueda: nueva búsqueda de comentarios',

## lib/MT/App/Trackback.pm
	'Invalid entry ID \'[_1]\'' => 'ID de entrada no válido \'[_1]\'',
	'You must define a Ping template in order to display pings.' => 'Debe definir una plantilla de ping para poderlos mostrar.',
	'Trackback pings must use HTTP POST' => 'Los pings de Trackback deben usar HTTP POST',
	'Need a TrackBack ID (tb_id).' => 'Necesita un ID de TrackBack (tb_id).',
	'Invalid TrackBack ID \'[_1]\'' => 'ID de TrackBack no válido \'[_1]\'',
	'You are not allowed to send TrackBack pings.' => 'No se le permite enviar pings de TrackBack.',
	'You are pinging trackbacks too quickly. Please try again later.' => 'Está enviando pings de TrackBack demasiado rápido. Por favor, inténtelo más tarde.',
	'Need a Source URL (url).' => 'Necesita una URL fuente (url).',
	'This TrackBack item is disabled.' => 'Este elemento de TrackBack fue deshabilitado.',
	'This TrackBack item is protected by a passphrase.' => 'Este elemento de TrackBack está protegido por una contraseña.',
	'TrackBack on "[_1]" from "[_2]".' => 'TrackBack en "[_1]" de "[_2]".',
	'TrackBack on category \'[_1]\' (ID:[_2]).' => 'TrackBack en la categoría \'[_1]\' (ID:[_2]).',
	'Can\'t create RSS feed \'[_1]\': ' => 'No se pudo crear la fuente RSS \'[_1]\': ',
	'New TrackBack Ping to Entry [_1] ([_2])' => 'Nuevo ping de TrackBack en la entrada [_1] ([_2])',
	'New TrackBack Ping to Category [_1] ([_2])' => 'Nuevo ping de TrackBack en la categoría [_1] ([_2])',

## lib/MT/App/Upgrader.pm
	'Failed to authenticate using given credentials: [_1].' => 'Fallo al autentificar con las credenciales ofrecidas: [_1].',
	'You failed to validate your password.' => 'Falló al validar la contraseña.',
	'You failed to supply a password.' => 'No introdujo una contraseña.',
	'The e-mail address is required.' => 'La dirección de correo electrónico es necesaria.',
	'The path provided below is not writable.' => 'La ruta aquí abajo no está abierta en escritura',
	'Invalid session.' => 'Sesión no válida.',
	'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Sin permisos. Por favor, contacte con su administrador para la actualización de Movable Type.',
	'Movable Type has been upgraded to version [_1].' => 'Movable Type ha sido actualizado a la versión [_1].',

## lib/MT/App/Wizard.pm
	'The [_1] database driver is required to use [_2].' => 'Es necesario el controlador de la base de datos [_1] para usar [_2].',
	'The [_1] driver is required to use [_2].' => 'Es necesario el controlador [_1] para usar [_2].',
	'An error occurred while attempting to connect to the database.  Check the settings and try again.' => 'Ocurrió un error intentando conectar a la base de datos. Compruebe la configuración e inténtalo de nuevo.',
	'SMTP Server' => 'Servidor SMTP',
	'Sendmail' => 'Sendmail',
	'Test email from Movable Type Configuration Wizard' => 'Mensaje de comprobación del asistente de configuración de Movable Type',
	'This is the test email sent by your new installation of Movable Type.' => 'Este es el mensaje de comprobación enviado por su nueva instalación de Movable Type.',
	'This module is needed to encode special characters, but this feature can be turned off using the NoHTMLEntities option in mt-config.cgi.' => 'Este módulo es necesario para codificar caracteres especiales, pero se puede desactivar esta característica utilizando la opción NoHTMLEntities en mt-config.cgi.',
	'This module is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'Este módulo es necesario si desea usar el sistema de TrackBack, el ping a weblogs.com, o el ping a Actualizaciones Recientes de MT.',
	'This module is needed if you wish to use the MT XML-RPC server implementation.' => 'Este módulo es necesario si desea usar la implementación del servidor XML-RPC de MT.',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Este módulo es necesario si desea poder sobreescribir los ficheros al subirlos.',
	'List::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'Lista: Útiles opcionales; esto es necesario si usted desea utilizar la función cola de publicación',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Este módulo es necesario si desea poder crear miniaturas de las imágenes subidas.',
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
	'This module is used in test attribute of MTIf conditional tag.' => 'Este módulo se utiliza en el atributo test de la etiqueta MTIf.',
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Este módulo es necesario para subir archivos (para determinar el tamaño de las imágenes en diferentes formatos).',
	'This module is required for cookie authentication.' => 'Este módulo es necsario para la autentificación con cookies.',
	'DBI is required to store data in database.' => 'DBI es necesario para guardar información en bases de datos.',
	'CGI is required for all Movable Type application functionality.' => 'El CGI es requerido para todas las funciones del Sistema Movable Type.',
	'File::Spec is required for path manipulation across operating systems.' => 'File::Spec es requerido para la manipulación de la ubición de los archivos en el sistema operativo.',

## lib/MT/App/Viewer.pm
	'Loading blog with ID [_1] failed' => 'Fallo al cargar el blog con el ID [_1]',
	'Template publishing failed: [_1]' => 'Fallo al publicar la plantilla: [_1]',
	'Invalid date spec' => 'Formato de fecha no válido',
	'Can\'t load template [_1]' => 'No se pudo cargar la plantilla [_1]',
	'Archive publishing failed: [_1]' => 'Fallo al publicar los archivos: [_1]',
	'Invalid entry ID [_1]' => 'Identificador de entrada no válido [_1]',
	'Entry [_1] is not published' => 'La entrada [_1] no está publicada',
	'Invalid category ID \'[_1]\'' => 'Identificador de categoría no válido \'[_1]\'',

## lib/MT/App/CMS.pm
	'No [_1] were found that match the given criteria.' => 'Ningún [_1] ha sido encontrado que corresponda al criterio dado.',
	'This action will restore your global templates to factory settings without creating a backup. Click OK to continue or Cancel to abort.' => 'Esta acción restaurará las plantillas globales con la configuración de fábrica sin crear una copia de seguridad. Haga clic en Aceptar para continuar o Cancelar para abortar.',
	'_WARNING_PASSWORD_RESET_MULTI' => 'Va a reiniciar la contraseña de los usuarios seleccionados. Se generarán nuevas contraseñas aleatorias y se enviarán directamente a sus respectivas direcciones de correo electrónico.\n\n¿Desea continuar?',
	'_WARNING_DELETE_USER_EUM' => 'Borrar un usuario es una acción irreversible que crea huérfanos en las entradas del usuario. Si desea retirar un usuario o bloquear su acceso al sistema, se recomienda deshabilitar su cuenta. ¿Está seguro de que desea borrar a los usuarios seleccionados\nPodrán re-crearse a sí mismos si el usuario seleccionado existe en el directorio externo.',
	'_WARNING_DELETE_USER' => 'El borrado de un usuario es una acción irreversible que crea huérfanos de las entradas del usuario. Si desea retirar a un usuario o bloquear su acceso al sistema, la forma recomendada es deshabilitar su cuenta. ¿Está seguro de que desea borrar el/los usuario/s seleccionado/s?',
	'All Assets' => 'Todos los ficheros multimedia',
	'Published [_1]' => 'Publicado [_1]',
	'Unpublished [_1]' => 'Despublicado [_1]',
	'Scheduled [_1]' => 'Programado [_1]',
	'My [_1]' => 'Mi [_1]',
	'[_1] with comments in the last 7 days' => '[_1] con comentarios en los últimos 7 días',
	'[_1] posted between [_2] and [_3]' => '[_1] publicado entre [_2] y [_3]',
	'[_1] posted since [_2]' => '[_1] publicado hace [_2]',
	'[_1] posted on or before [_2]' => '[_1] publicando en o antes de [_2]',
	'All comments by [_1] \'[_2]\'' => 'Todos los comentarios de [_1] \'[_2]\'',
	'Commenter' => 'Comentarista',
	'All comments for [_1] \'[_2]\'' => 'Todos los comentarios de [_1] \'[_2]\'',
	'Comments posted between [_1] and [_2]' => 'Comentarios publicados entre [_1] y [_2]',
	'Comments posted since [_1]' => 'Comentarios publicados desde [_1]',
	'Comments posted on or before [_1]' => 'Commentarios publicados en o antes de [_1]',
	'Invalid blog' => 'Blog no válido',
	'Password Recovery' => 'Recuperación de contraseña',
	'Invalid password recovery attempt; can\'t recover password in this configuration' => 'Intento de recuperación de contraseña no válido; no se pudo recuperar la clave con esta configuración',
	'Invalid author_id' => 'author_id no válido',
	'Can\'t recover password in this configuration' => 'No se pudo recuperar la clave con esta configuración',
	'Invalid user name \'[_1]\' in password recovery attempt' => 'Nombre de usario no válido \'[_1]\' en intento de recuperación de contraseña',
	'User name or password hint is incorrect.' => 'El nombre del usuario o la contraseña es incorrecto.',
	'User has not set pasword hint; cannot recover password' => 'El usuario no ha configurado una pista para la contraseña; no se pudo recuperar',
	'Invalid attempt to recover password (used hint \'[_1]\')' => 'Intento inválido de recuperación de la contraseña (pista usada \'[_1]\')',
	'User does not have email address' => 'El usario sin dirección de correo electrónico',
	'Password was reset for user \'[_1]\' (user #[_2]). Password was sent to the following address: [_3]' => 'Se reinició la contraseña del usario \'[_1]\' (user #[_2]). Se envió la contraseña a las siguientes direcciones: [_3]',
	'Error sending mail ([_1]); please fix the problem, then try again to recover your password.' => 'Error enviando correo ([_1]); por favor, solvente el problema e inténte de nuevo la recuperación de la contraseña.',
	'(newly created user)' => '(nuevo usuario creado)',
	'Untitled' => 'Sin título',
	'Files' => 'Ficheros',
	'Roles' => 'Roles',
	'Users' => 'Usuarios',
	'User Associations' => 'Asociaciones de usuario',
	'Role Users & Groups' => 'Roles de usuarios y grupos',
	'Associations' => 'Asociaciones',
	'(Custom)' => '(Personalizado)',
	'(user deleted)' => '(usario borrado)',
	'The user' => 'El usuario',
	'User' => 'Usuario',
	'Invalid type' => 'Tipo no válido',
	'New name of the tag must be specified.' => 'El nuevo nombre de la etiqueta debe ser especificado',
	'No such tag' => 'No existe dicha etiqueta',
	'None' => 'Ninguno',
	'You are not authorized to log in to this blog.' => 'No está autorizado para acceder a este blog.',
	'No such blog [_1]' => 'No existe el blog [_1]',
	'Shared Template Modules' => 'Módulos compartidos de plantillas', # Translate - New
	'http://www.movabletype.org/documentation/' => 'http://www.movabletype.org/documentation/', # Translate - New
	'Reuse elements of your site design or layout across all the blogs and sites managed within Movable Type.' => 'Reutilice los elementos de diseño o disposición de su sitio entre todos los blogs administrados en Movable Type.', # Translate - New
	'Userpics' => 'Avatares', # Translate - New
	'Allow authors and commenters to upload a photo of themselves to be displayed alongside their comments.' => 'Permite a los autores y comentaristas subir una foto para mostrarla junto a sus comentarios.', # Translate - New
	'Template Sets' => 'Conjuntos de plantillas', # Translate - New
	'Template sets provide an easy way to bundle an entire design and install it into Movable Type.' => 'Los conjuntos de plantillas ofrecen una forma fácil de empaquetar un diseño e instalarlo en Movable Type.', # Translate - New
	'Blogs' => 'Blogs',
	'Blog Activity Feed' => 'Fuente de Actividades del blog',
	'*User deleted*' => '*Usuario borrado*',
	'All Feedback' => 'Todas las opiniones',
	'Publishing' => 'Publicación',
	'Activity Log' => 'Actividad',
	'System Activity Feed' => 'Fuente de actividad del sistema',
	'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'El registro de actividad del blog \'[_1]\' (ID:[_2]) fue reiniciado por  \'[_3]\'',
	'Activity log reset by \'[_1]\'' => 'Registro de actividad reiniciado por \'[_1]\'',
	'Please select a blog.' => 'Por favor, seleccione un blog.',
	'Edit Template' => 'Editar plantilla',
	'Go Back' => 'Ir atrás',
	'Import/Export' => 'Importar/Exportar',
	'Invalid parameter' => 'Parámetro no válido',
	'Permission denied: [_1]' => 'Permiso denegado: [_1]',
	'Load failed: [_1]' => 'Fallo carga: [_1]',
	'(no reason given)' => '(ninguna razón ofrecida)',
	'Entries' => 'Entradas',
	'Pages' => 'Páginas',
	'(untitled)' => '(sin título)',
	'index' => 'índice',
	'archive' => 'archivo',
	'module' => 'módulo',
	'widget' => 'widget',
	'email' => 'correo electrónico',
	'system' => 'sistema',
	'Templates' => 'Plantillas',
	'One or more errors were found in this template.' => 'Se encontraron uno o más errores en esta plantilla.',
	'General Settings' => 'Configuración general',
	'Publishing Settings' => 'Configuración de publicación',
	'Plugin Settings' => 'Configuración de extensiones',
	'Settings' => 'Configuración',
	'Edit Comment' => 'Editar comentario',
	'Authenticated Commenters' => 'Comentaristas autentificados',
	'Commenter Details' => 'Detalles del comentarista',
	'Assets' => 'Multimedia',
	'New Entry' => 'Nueva entrada',
	'New Page' => 'Nueva página',
	'Create template requires type' => 'Crear plantillas requiere el tipo',
	'Archive' => 'Archivo',
	'Entry or Page' => 'Entrada o página',
	'New Template' => 'Nueva plantilla',
	'New Blog' => 'Nuevo blog',
	'pages' => 'páginas',
	'Create User' => 'Crear usuario',
	'User requires username' => 'El usario necesita un nombre de usuario',
	'A user with the same name already exists.' => 'Ya existe un usuario con el mismo nombre.',
	'User requires password' => 'El usario necesita una contraseña',
	'User requires password recovery word/phrase' => 'El usario necesita una palabra/frase de recuperación de contraseña',
	'Email Address is required for password recovery' => 'La dirección de correo es necesaria para la recuperación de la contraseña',
	'Website URL is imperfect' => 'La URL del sitio es imperfecta',
	'The value you entered was not a valid email address' => 'El valor que tecleó no es una dirección válida de correo electrónico',
	'The e-mail address you entered is already on the Notification List for this blog.' => 'La dirección de correo que introdujo ya está en la Lista de notificaciones de este blog.',
	'You did not enter an IP address to ban.' => 'No tecleó una dirección IP para bloquear.',
	'The IP you entered is already banned for this blog.' => 'La IP que introdujo ya está bloqueada en este blog.',
	'You did not specify a blog name.' => 'No especificó el nombre del blog.',
	'Site URL must be an absolute URL.' => 'La URL del sitio debe ser una URL absoluta.',
	'Archive URL must be an absolute URL.' => 'La URL de archivo debe ser una URL absoluta.',
	'You did not specify an Archive Root.' => 'No ha especificado un Archivo raíz.',
	'The name \'[_1]\' is too long!' => 'El nombre \'[_1]\' es demasiado largo.',
	'Folder \'[_1]\' created by \'[_2]\'' => 'Carpeta \'[_1]\' creada por \'[_2]\'',
	'Category \'[_1]\' created by \'[_2]\'' => 'Categoría \'[_1]\' creada por \'[_2]\'',
	'The folder \'[_1]\' conflicts with another folder. Folders with the same parent must have unique basenames.' => 'La carpeta \'[_1]\' tiene conflicto con otra carpeta. Las carpetas con el mismo padre deben tener nombre base únicos.',
	'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'El nombre de la categría \'[_1]\' tiene conflicto con otra categoría. Las categorías de primer nivel y las sub-categorías con el mismo padre deben tener nombres únicos.',
	'The category basename \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => 'El nombre base de la categoría \'[_1]\' tiene conflictos con otra categoría. Las categorías de primer nivel y las sub-categorías con el mismo padre deben tener nombres base únicos.',
	'Saving permissions failed: [_1]' => 'Fallo guardando permisos: [_1]',
	'Blog \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) creado por \'[_3]\'',
	'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Usuario \'[_1]\' (ID:[_2]) creado por \'[_3]\'',
	'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Plantilla \'[_1]\' (ID:[_2]) creada por \'[_3]\'',
	'You cannot delete your own association.' => 'No puede borrar sus propias asociaciones.',
	'You cannot delete your own user record.' => 'No puede borrar el registro de su propio usario.',
	'You have no permission to delete the user [_1].' => 'No tiene permisos para borrar el usario [_1].',
	'Blog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) borrado por \'[_3]\'',
	'Subscriber \'[_1]\' (ID:[_2]) deleted from address book by \'[_3]\'' => 'Suscriptor \'[_1]\' (ID:[_2]) borrado de la agenda por \'[_3]\'',
	'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Usuario \'[_1]\' (ID:[_2]) borrado por \'[_3]\'',
	'Folder \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Carpeta \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
	'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Categoría \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
	'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Comentario (ID:[_1]) por \'[_2]\' borrado por \'[_3]\' de la entrada \'[_4]\'',
	'Page \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Página \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
	'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Entrada \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
	'(Unlabeled category)' => '(Categoría sin título)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) desde \'[_2]\' borrado por \'[_3]\' de la categoría \'[_4]\'',
	'(Untitled entry)' => '(Entrada sin título)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) desde \'[_2]\' borrado por \'[_3]\' de la entrada \'[_4]\'',
	'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Plantilla \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
	'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Etiqueta \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
	'File \'[_1]\' uploaded by \'[_2]\'' => 'Fichero \'[_1]\' transferido por \'[_2]\'',
	'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Fichero \'[_1]\' (ID:[_2]) transferido por \'[_3]\'',
	'Permisison denied.' => 'Permiso denegado.',
	'The Template Name and Output File fields are required.' => 'Los campos del nombre de la plantilla y el fichero de salida son obligatorios.',
	'Invalid type [_1]' => 'Tipo inválido [_1]',
	'Save failed: [_1]' => 'Fallo al guardar: [_1]',
	'Saving object failed: [_1]' => 'Fallo guardando objeto: [_1]',
	'No Name' => 'Sin nombre',
	'Notification List' => 'Lista de notificaciones',
	'IP Banning' => 'Bloqueo de IPs',
	'Removing tag failed: [_1]' => 'Falló el borrado de la etiqueta: [_1]',
	'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => 'No puede eliminar esa categoría porque tiene subcategorías. Mueva o elimine primero las categorías si desea eliminar ésta.',
	'Loading MT::LDAP failed: [_1].' => 'Falló la carga de MT::LDAP: [_1].',
	'Removing [_1] failed: [_2]' => 'Falló el borrado de [_1]: [_2]',
	'System templates can not be deleted.' => 'Las plantillas del sistema no se pueden borrar.',
	'Unknown object type [_1]' => 'Tipo de objeto desconocido [_1]',
	'Can\'t load file #[_1].' => 'No se pudo cargar el fichero nº[_1].',
	'No such commenter [_1].' => 'No existe el comentarista [_1].',
	'User \'[_1]\' trusted commenter \'[_2]\'.' => 'Usuario \'[_1]\' confió en el comentarista \'[_2]\'.',
	'User \'[_1]\' banned commenter \'[_2]\'.' => 'Usuario \'[_1]\' bloqueó al comentarista \'[_2]\'.',
	'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'Usuario \'[_1]\' desbloqueó al comentarista \'[_2]\'.',
	'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'Usuario \'[_1]\' desconfió del comentarista \'[_2]\'.',
	'Need a status to update entries' => 'Necesita indicar un estado para actualizar las entradas',
	'Need entries to update status' => 'Necesita entradas para actualizar su estado',
	'One of the entries ([_1]) did not actually exist' => 'Una de las entradas ([_1]) no existe actualmente',
	'[_1] \'[_2]\' (ID:[_3]) status changed from [_4] to [_5]' => '[_1] \'[_2]\' (ID:[_3]) cambió de estado de [_4] a [_5]',
	'You don\'t have permission to approve this comment.' => 'No tiene permiso para aprobar este comentario.',
	'Comment on missing entry!' => '¡Comentario en entrada inexistente!',
	'Commenters' => 'Comentaristas',
	'Orphaned comment' => 'Comentario huérfano',
	'Comments Activity Feed' => 'Fuente de actividad de comentarios',
	'Orphaned' => 'Huérfano',
	'Global Templates' => 'Plantillas globales',
	'Plugin Set: [_1]' => 'Conjuntos de extensiones: [_1]',
	'Individual Plugins' => 'Extensiones individuales', # Translate - New
	'Junk TrackBacks' => 'TrackBacks basura',
	'TrackBacks where <strong>[_1]</strong> is &quot;[_2]&quot;.' => 'TrackBacks donde <strong>[_1]</strong> es &quot;[_2]&quot;.',
	'TrackBack Activity Feed' => 'Fuente de actividad de TrackBacks',
	'No Excerpt' => 'Sin resumen',
	'No Title' => 'Sin título',
	'Orphaned TrackBack' => 'TrackBack huérfano',
	'category' => 'categoría',
	'Category' => 'Categoría',
	'Asset' => 'Multimedia',
	'Tag' => 'Etiqueta',
	'Entry Status' => 'Estado de la entrada',
	'[_1] Feed' => 'Fuente [_1]',
	'(user deleted - ID:[_1])' => '(usuario borrado - ID:[_1])',
	'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Fecha no válida \'[_1]\'; debe tener el formato YYYY-MM-DD HH:MM:SS.',
	'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Fecha no válida \'[_1]\'; debe ser una fecha real.',
	'Saving [_1] failed: [_2]' => 'Falló al guardar [_1]: [_2]',
	'Saving entry \'[_1]\' failed: [_2]' => 'Fallo guardando entrada \'[_1]\': [_2]',
	'Removing placement failed: [_1]' => 'Fallo eliminando lugar: [_1]',
	'Saving placement failed: [_1]' => 'Fallo guardando situación: [_1]',
	'[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_1] \'[_2]\' (ID:[_3]) editado y cambió su estado desde [_4] a [_5] al usuario \'[_6]\'',
	'[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) editado por el usuario \'[_4]\'',
	'No such [_1].' => 'No existe [_1].',
	'Same Basename has already been used. You should use an unique basename.' => 'Ya se ha utilizado el mismo nombre base. Debe usar un nombre base único.',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Su blog no tiene configurados la URL y la raíz del sitio. No puede publicar entradas hasta que no estén definidos.',
	'[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'',
	'Error during publishing: [_1]' => 'Error durante la publicación: [_1]', # Translate - New
	'Subfolder' => 'Subcarpeta',
	'Subcategory' => 'Subcategoría',
	'Saving category failed: [_1]' => 'Fallo guardando categoría: [_1]',
	'The [_1] must be given a name!' => '¡Debe dar un nombre a [_1]!',
	'Saving blog failed: [_1]' => 'Fallo guardando blog: [_1]',
	'Invalid ID given for personal blog clone source ID.' => 'Se introdujo un ID no válido para el ID de blog fuente de clonación.',
	'If personal blog is set, the default site URL and root are required.' => 'Si se selecciona un blog personal, se necesitará su URL predefinida y raíz.',
	'Feedback Settings' => 'Configuración de respuestas',
	'Publish error: [_1]' => 'Error de publicación: [_1]',
	'Unable to create preview file in this location: [_1]' => 'Imposible crear vista previa del archivo en este lugar: [_1]',
	'New [_1]' => 'Nuevo [_1]',
	'Publish Site' => 'Publicar sitio',
	'index template \'[_1]\'' => 'plantilla índice \'[_1]\'',
	'[_1] \'[_2]\'' => '[_1] \'[_2]\'',
	'No permissions' => 'No tiene permisos',
	'Ping \'[_1]\' failed: [_2]' => 'Falló ping \'[_1]\' : [_2]',
	'Create Role' => 'Crear rol',
	'Role name cannot be blank.' => 'El nombre del rol no puede estar vacío.',
	'Another role already exists by that name.' => 'Ya existe otro rol con ese nombre.',
	'You cannot define a role without permissions.' => 'No puede definir un rol sin permisos.',
	'No permissions.' => 'Sin permisos.',
	'No such entry \'[_1]\'' => 'No existe la entrada \'[_1]\'',
	'No email address for user \'[_1]\'' => 'No hay dirección de correo electrónico asociada al usario \'[_1]\'',
	'No valid recipients found for the entry notification.' => 'No se encontraron destinatarios válidos para la notificación de la entrada.',
	'[_1] Update: [_2]' => '[_1] Actualiza: [_2]',
	'Error sending mail ([_1]); try another MailTransfer setting?' => 'Error enviando correo electrónico ([_1]); ¿quizás probando con otra configuración para MailTransfer?',
	'Archive Root' => 'Raíz de archivos',
	'Site Root' => 'Raíz del sitio',
	'Upload File' => 'Transferir fichero',
	'Can\'t load blog #[_1].' => 'No se pudo cargar el blog nº[_1].',
	'Please select a file to upload.' => 'Por favor, seleccione el fichero a transferir',
	'Invalid filename \'[_1]\'' => 'Nombre de fichero no válido \'[_1]\'',
	'Please select an audio file to upload.' => 'Por favor, seleccione el fichero de audio a transferir.',
	'Please select an image to upload.' => 'Por favor, seleccione una imagen a transferir.',
	'Please select a video to upload.' => 'Por favor, seleccione un video a transferir. Please select a video to upload.',
	'Before you can upload a file, you need to publish your blog.' => 'Antes de transferir ficheros, debe publicar su blog.',
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
	'Search & Replace' => 'Buscar & Reemplazar',
	'Entry Body' => 'Cuerpo de la entrada',
	'Extended Entry' => 'Entrada extendida',
	'Keywords' => 'Palabras claves',
	'Basename' => 'Nombre base',
	'Comment Text' => 'Comentario',
	'IP Address' => 'Dirección IP',
	'Source URL' => 'URL origen',
	'Blog Name' => 'Nombre del blog',
	'Page Body' => 'Cuerpo de la página',
	'Extended Page' => 'Página extendida',
	'Template Name' => 'Nombre de la plantilla',
	'Text' => 'Texto',
	'Linked Filename' => 'Fichero enlazado',
	'Output Filename' => 'Fichero salida',
	'Filename' => 'Nombre del fichero',
	'Description' => 'Descripción',
	'Label' => 'Título',
	'Log Message' => 'Mensaje del registro',
	'Username' => 'Nombre de usuario',
	'Display Name' => 'Nombre público',
	'Site URL' => 'URL del sitio',
	'Invalid date(s) specified for date range.' => 'Se especificaron fechas no válidas para el rango.',
	'Error in search expression: [_1]' => 'Error en la expresión de búsqueda: [_1]',
	'Saving object failed: [_2]' => 'Fallo al guardar objeto: [_2]',
	'Load of blog \'[_1]\' failed: [_2]' => 'La carga del blog \'[_1]\' falló: [_2]',
	'You do not have export permissions' => 'No tiene permisos de exportación',
	'You do not have import permissions' => 'No tiene permisos de importación',
	'You do not have permission to create users' => 'No tiene permisos para crear usarios',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'Si va a crear nuevos usuarios por cada usuario listado en su blog, debe proveer una contraseña.',
	'Importer type [_1] was not found.' => 'No se encontró el tipo de importador [_1].',
	'Saving map failed: [_1]' => 'Fallo guardando mapa: [_1]',
	'Add a [_1]' => 'Añador un [_1]',
	'No label' => 'Sin título',
	'Category name cannot be blank.' => 'El nombre de la categoría no puede estar en blanco.',
	'Populating blog with default templates failed: [_1]' => 'Falló el guardando del blog con las plantillas por defecto: [_1]',
	'Setting up mappings failed: [_1]' => 'Fallo la configuración de mapeos: [_1]',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Error: Movable Type no puede escribir en el directorio de caché de las plantillas. Por favor, compruebe los permisos del directorio llamado <code>[_1]</code> dentro del directorio de su blog.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Error: Movable Type no pudo crear un directorio para cachear las plantillas dinámicas. Debe crear un directorio llamado <code>[_1]</code> dentro del directorio de su blog.',
	'That action ([_1]) is apparently not implemented!' => '¡La acción ([_1]) aparentemente no está implementada!',
	'Error saving entry: [_1]' => 'Error guardando entrada: [_1]',
	'Select Blog' => 'Seleccione blog',
	'Selected Blog' => 'Blog seleccionado',
	'Type a blog name to filter the choices below.' => 'Introduzca un nombre de blog para filtrar las opciones de abajo.',
	'Select a System Administrator' => 'Seleccione un Administrador del Sistema',
	'Selected System Administrator' => 'Administrador del Sistema seleccionado',
	'Type a username to filter the choices below.' => 'Introduzca un nombre de usuario para filtrar las opciones.',
	'System Administrator' => 'Administrador del sistema',
	'Error saving file: [_1]' => 'Error guardando fichero: [_1]',
	'represents a user who will be created afterwards' => 'representa un usuario que se creará después',
	'Select Blogs' => 'Seleccione blogs',
	'Blogs Selected' => 'Blogs seleccionado',
	'Search Blogs' => 'Buscar blogs',
	'Select Users' => 'Seleccionar usuarios',
	'Users Selected' => 'Usuarios seleccionados',
	'Search Users' => 'Buscar usuarios',
	'Select Roles' => 'Seleccionar roles',
	'Role Name' => 'Nombre del rol',
	'Roles Selected' => 'Roles seleccionados',
	'' => '', # Translate - New
	'Grant Permissions' => 'Otorgar permisos',
	'Backup' => 'Copia de seguridad',
	'Backup & Restore' => 'Copias de seguridad',
	'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.' => 'Debe poderse escribir en el directorio temporal para que las copias de seguridad funcionen correctamente. Por favor, compruebe la opción de configuración TempDir.',
	'Temporary directory needs to be writable for restore to work correctly.  Please check TempDir configuration directive.' => 'Debe poder escribirse en el directorio temporal para que las copias de seguridad funcionen correctamente. Por favor, compruebe la opción de configuración TempDir.',
	'Blog(s) (ID:[_1]) was/were successfully backed up by user \'[_2]\'' => 'Las copias de seguridad de el/los blog(s) (ID:[_1]) se hizo/hicieron correctamente por el usuario  \'[_2]\'',
	'Movable Type system was successfully backed up by user \'[_1]\'' => 'El usuario \'[_1]\' realizó con éxito una copia de seguridad del sistema de Movable Type',
	'[_1] is not a number.' => '[_1] no es un número.',
	'Copying file [_1] to [_2] failed: [_3]' => 'Fallo copiandi fichero [_1] en [_2]: [_3]',
	'Specified file was not found.' => 'No se encontró el fichero especificado.',
	'[_1] successfully downloaded backup file ([_2])' => '[_1] descargó con éxito el fichero de copia de seguridad ([_2])',
	'Restore' => 'Restaurar',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Por favor, use xml, tar.gz, zip, o manifest como extensión de ficheros.',
	'Unknown file format' => 'Formato de fichero desconocido',
	'Some [_1] were not restored because their parent objects were not restored.' => 'Algunos [_1] no se restauraron porque sus objetos ascendentes no se restauraron.',
	'Some objects were not restored because their parent objects were not restored.  Detailed information is in the <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">activity log</a>.' => 'Algunos objetos no se restauraron porque sus objetos padres no se restauraron. Dispone de información detallada en el <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">registro de actividad</a>.',
	'Successfully restored objects to Movable Type system by user \'[_1]\'' => 'El usuario \'[_1]\' restauró objetos en el sistema Movable Type con éxito.',
	'[_1] is not a directory.' => '[_1] no es un directorio.',
	'Error occured during restore process.' => 'Ocurrió un error durante el proceso de restauración.',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ',
	'Some of files could not be restored.' => 'Algunos ficheros no se restauraron.',
	'Please upload [_1] in this page.' => 'Por favor, transfiera [_1] a esta página.',
	'File was not uploaded.' => 'El fichero no fue transferido.',
	'Restoring a file failed: ' => 'Falló la restauración de un fichero:',
	'Some objects were not restored because their parent objects were not restored.' => 'Algunos objetos no se restauraron porque sus objetos ascendentes tampoco fueron restaurados.',
	'Some of the files were not restored correctly.' => 'No se restauraron correctamente algunos de los ficheros.',
	'Detailed information is in the <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>activity log</a>.' => 'La información detallada se encuentra en el <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>registro de actividad</a>.',
	'[_1] has canceled the multiple files restore operation prematurely.' => '[_1] canceló prematuramente la operación de restauración de varios ficheros.',
	'Changing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Modificando la Ruta del Sitio del blog \'[_1]\' (ID:[_2])...',
	'Removing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Borrando la Ruta del Sitio del blog \'[_1]\' (ID:[_2])...',
	'Changing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Modificando la Ruta de Archivos del blog \'[_1]\' (ID:[_2])...',
	'Removing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Borrando la Ruta de Archivos del blog \'[_1]\' (ID:[_2])...',
	'failed' => 'falló',
	'ok' => 'ok',
	'Changing file path for the asset \'[_1]\' (ID:[_2])...' => 'Modificando la ruta para el fichero multimedia \'[_1]\' (ID:[_2])...',
	'Some of the actual files for assets could not be restored.' => 'No se pudieron restaurar algunos ficheros multimedia.',
	'Parent comment id was not specified.' => 'ID de comentario padre no se especificó.',
	'Parent comment was not found.' => 'El comentario padre no se encontró.',
	'You can\'t reply to unapproved comment.' => 'No puede responder a un comentario no aprobado.',
	'You can\'t reply to unpublished comment.' => 'No puede contestar a comentarios no publicados.',
	'Error creating new template: ' => 'Error creando nueva plantilla: ',
	'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Ignorando plantilla \'[_1]\' ya que parecer ser una plantilla personalizada.',
	'Refreshing template <strong>[_3]</strong> with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>' => 'Reactualizar los modelos <strong>[_3]</strong> desde <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">guardar</a>',
	'Skipping template \'[_1]\' since it has not been changed.' => 'Ignorando la plantilla \'[_1]\' ya que no ha sido modificada.', # Translate - New
	'entries' => 'entradas',
	'This is You' => 'Este es Usted',
	'Handy Shortcuts' => 'Enlaces útiles',
	'Movable Type News' => 'Noticias de Movable Type',
	'Blog Stats' => 'Estadísticas',
	'Refresh Blog Templates' => 'Recargar plantillas de blogs',
	'Refresh Global Templates' => 'Recargar plantillas globales',
	'Publish Entries' => 'Publicar entradas',
	'Unpublish Entries' => 'Despublicar entradas',
	'Add Tags...' => 'Añadir etiquetas...',
	'Tags to add to selected entries' => 'Etiquetas a añadir en las entradas seleccionadas',
	'Remove Tags...' => 'Borrar entradas...',
	'Tags to remove from selected entries' => 'Etiquetas a borrar de las entradas seleccionadas',
	'Batch Edit Entries' => 'Editar entradas en lote',
	'Publish Pages' => 'Publicar páginas',
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
	'Publish Template(s)' => 'Publicar plantilla/s', # Translate - New
	'Non-spam TrackBacks' => 'Trackback No-Spam',
	'TrackBacks on my entries' => 'Trackback en mis entradas',
	'Published TrackBacks' => 'Publicar Trackback',
	'Unpublished TrackBacks' => 'Trackback No Publicado',
	'TrackBacks marked as Spam' => 'Trackback marcado como spam',
	'All TrackBacks in the last 7 days' => 'Todos los Trackbacks en los últimos 7 días',
	'Non-spam Comments' => 'Comentarios que no son spam',
	'Comments on my entries' => 'Comentarios en mis entradas',
	'Pending comments' => 'Comentarios pendientes',
	'Spam Comments' => 'Comentarios spam',
	'Published comments' => 'Comentarios publicados',
	'My comments' => 'Mis comentarios',
	'Comments in the last 7 days' => 'Comentarios en los últimos 7 días',
	'All comments in the last 24 hours' => 'Todos los comentarios en las últimas 24 horas',
	'Index Templates' => 'Plantillas índice',
	'Archive Templates' => 'Plantillas de archivos',
	'Template Modules' => 'Módulos de plantillas',
	'E-mail Templates' => 'Plantillas de correo',
	'Backup Templates' => 'Hacer copia de seguridad de las plantillas', # Translate - New
	'System Templates' => 'Plantillas del sistema',
	'Tags with entries' => 'Etiquetas con entradas',
	'Tags with pages' => 'Etiquetas con páginas',
	'Tags with assets' => 'Etiquetas con ficheros multimedia',
	'Enabled Users' => 'Usuarios habilitados',
	'Disabled Users' => 'Usuarios deshabilitados',
	'Pending Users' => 'Usuarios pendientes',
	'Authors' => 'autores',
	'Create' => 'Crear',
	'Manage' => 'Administrar',
	'Design' => 'Diseño',
	'Preferences' => 'Preferencias',
	'Tools' => 'Herramientas',
	'Folders' => 'Carpetas',
	'General' => 'General',
	'Feedback' => 'Respuestas',
	'Plugins' => 'Extensiones',
	'Blog Settings' => 'Configuración del blog',
	'Address Book' => 'Agenda',
	'System Information' => 'Información del sistema',
	'Import' => 'Importar',
	'Export' => 'Exportar',
	'System Overview' => 'Resumen del sistema',
	'/' => '/',
	'<' => '<',

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
	'Publishing: [quant,_1,file,files]...' => 'Publicando: [quant,_1,file,files]...', # Translate - New
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- conjunto completo ([quant,_1,fichero,ficheros] en [_2] segundos)', # Translate - New

## lib/MT/BasicAuthor.pm
	'authors' => 'autores',

## lib/MT/Placement.pm
	'Category Placement' => 'Gestión de Categorías',

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

## lib/MT/Category.pm
	'Categories must exist within the same blog' => 'Las categorías deben existir en el mismo blog',
	'Category loop detected' => 'Bucle de categorías detectado',

## lib/MT/Asset.pm
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
	'Cropping to [_1]x[_1] failed: [_2]' => 'Fallo recortando a [_1]x[_1]: [_2]',
	'Converting to [_1] failed: [_2]' => 'Fallo convirtiendo a [_1]: [_2]',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'No posee una ruta válida a las herramientas NetPBMYou en su máquina.',

## lib/MT/Session.pm
	'Session' => 'Sección',

## lib/MT/Trackback.pm
	'TrackBack' => 'TrackBack',

## lib/MT/Notification.pm
	'Contact' => 'Contacto',
	'Contacts' => 'Contactos',

## lib/MT/Upgrade.pm
	'Comment Posted' => 'Comentario publicado',
	'Your comment has been posted!' => '¡El comentario ha sido publicado!',
	'[_1]: [_2]' => '[_1]: [_2]',
	'Migrating Nofollow plugin settings...' => 'Migrando ajustes de la extensión Nofollow...',
	'Updating system search template records...' => 'Actualizando registros de las plantillas de búsqueda del sistema...',
	'Custom ([_1])' => 'Personalizado ([_1])',
	'This role was generated by Movable Type upon upgrade.' => 'Este rol fue generado por Movable Type durante la actualización.',
	'Migrating permission records to new structure...' => 'Migrando registros de permisos a la nueva estructura...',
	'Migrating role records to new structure...' => 'Migrando registros de roles a la nueva estructura...',
	'Migrating system level permissions to new structure...' => 'Migrando permisos a nivel del sistema a la nueva estructura...',
	'Invalid upgrade function: [_1].' => 'Función de actualización no válida: [_1].',
	'Error loading class [_1].' => 'Error cargando clase [_1].',
	'Creating initial blog and user records...' => 'Creando registros iniciales de blog y usuario...',
	'Error saving record: [_1].' => 'Error guardando el registro: [_1].',
	'First Blog' => 'Primer blog',
	'I just finished installing Movable Type [_1]!' => '¡Acabo de finalizar la instalación de Movable Type [_1]!',
	'Welcome to my new blog powered by Movable Type. This is the first post on my blog and was created for me automatically when I finished the installation process. But that is ok, because I will soon be creating posts of my own!' => 'Bienvenido a mi nuevo blog de Movable Type. Esta es la primera entrada en mi blog y fue creada automáticamente al finalizar el proceso de instalación. ¡Pronto crearé mis propias entradas!',
	'Movable Type also created a comment for me as well so that I could see what a comment will look like on my blog once people start submitting comments on all the posts I will write.' => 'Movable Type también creó un comentario, para que pueda ver cómo quedarían una vez que los lectores comiencen a enviarme comentarios en las entradas que escriba.',
	'Blog Administrator' => 'Administrador del blog',
	'Can administer the blog.' => 'Puede administrar el blog.',
	'Editor' => 'Editor',
	'Can upload files, edit all entries/categories/tags on a blog and publish the blog.' => 'Puede subir ficheros, editar notas/categorías/etiquetas en un blog determinado y publicar otra vez.',
	'Can create entries, edit their own, upload files and publish.' => 'Puede crear entradas, editar las suyas, subir ficheros y publicar.',
	'Designer' => 'Diseñador',
	'Can edit, manage and publish blog templates.' => 'Puede editar, administrar y publicar otra vez las plantillas del blog',
	'Webmaster' => 'Webmaster',
	'Can manage pages and publish blog templates.' => 'Puede administrar las páginas y publicar otra vez las plantillas del blog',
	'Contributor' => 'Colaborador',
	'Can create entries, edit their own and comment.' => 'Puede crear entradas, editar las suyas y comentar.',
	'Moderator' => 'Moderador',
	'Can comment and manage feedback.' => 'Puede comentar y administrar las respuestas.',
	'Can comment.' => 'Puede comentar.',
	'Removing Dynamic Site Bootstrapper index template...' => 'Borrando plantilla índice del arranque dinámico...',
	'Creating new template: \'[_1]\'.' => 'Creando nueva plantilla: \'[_1]\'.',
	'Mapping templates to blog archive types...' => 'Mapeando plantillas con tipos de archivo de blogs...',
	'Renaming PHP plugin file names...' => 'Renombrando nombre de ficheros de la extensión de PHP...',
	'Error renaming PHP files. Please check the Activity Log.' => 'Error al renombrar ficheros PHP. Por favor, compruebe el registro de actividad.',
	'Cannot rename in [_1]: [_2].' => 'No se pudo renombrar en [_1]: [_2].',
	'Updating widget template records...' => 'Actualizando registros de plantillas de widgets...',
	'Removing unused template maps...' => 'Borrando mapas de plantillas no usados...',
	'Upgrading table for [_1] records...' => 'Actualización de las tablas para [_1] los registros...',
	'Upgrading database from version [_1].' => 'Actualizando base de datos desde la versión [_1].',
	'Database has been upgraded to version [_1].' => 'Se actualizó la base de datos a la versión [_1].',
	'User \'[_1]\' upgraded database to version [_2]' => 'Usuario \'[_1]\' actualizó la base de datos a la versión [_2]',
	'Plugin \'[_1]\' upgraded successfully to version [_2] (schema version [_3]).' => 'Extensión \'[_1]\' actualizada con éxito a la versión [_2] (versión del esquema [_3]).',
	'User \'[_1]\' upgraded plugin \'[_2]\' to version [_3] (schema version [_4]).' => 'Usuario \'[_1]\' actualizó la extensión \'[_2]\' a la versión [_3] (versión del esquema [_4]).',
	'Plugin \'[_1]\' installed successfully.' => 'La extensión \'[_1]\' se actualizó correctamente.',
	'User \'[_1]\' installed plugin \'[_2]\', version [_3] (schema version [_4]).' => 'Usuario \'[_1]\' instaló la extensión \'[_2]\', versión [_3] (versión del esquema [_4]).',
	'Setting your permissions to administrator.' => 'Estableciendo permisos de administrador.',
	'Comment Response' => 'Comentar respuesta',
	'Creating configuration record.' => 'Creando registro de configuración.',
	'Creating template maps...' => 'Creando mapas de plantillas...',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'Mapeando ID plantilla [_1] a [_2] ([_3]).',
	'Mapping template ID [_1] to [_2].' => 'Mapeando ID plantilla [_1] a [_2].',
	'Error loading class: [_1].' => 'Error cargando la clase: [_1].',
	'Error saving [_1] record # [_3]: [_2]... [_4].' => 'Error guardando [_1] registro # [_3]: [_2]... [_4].', # Translate - New
	'Creating entry category placements...' => 'Creando situaciones de categorías de entradas...',
	'Updating category placements...' => 'Actualizando situación de categorías...',
	'Assigning comment/moderation settings...' => 'Asignando opciones de comentarios/moderación...',
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
	'Assigning custom dynamic template settings...' => 'Asignando opciones de plantillas dinámicas personalizadas...',
	'Assigning user types...' => 'Asignando tipos de usario...',
	'Assigning category parent fields...' => 'Asignando campos de ancentros en las categorías...',
	'Assigning template build dynamic settings...' => 'Asignando opciones de construcción de plantillas dinámicas...',
	'Assigning visible status for comments...' => 'Asignando estado de visibilidad a los comentarios...',
	'Assigning junk status for comments...' => 'Asignando el estado spam para los comentarios...',
	'Assigning visible status for TrackBacks...' => 'Asignando estado de visiblidad para los TrackBacks...',
	'Assigning junk status for TrackBacks...' => 'Asignando el estado spam para los TrackBacks...',
	'Assigning basename for categories...' => 'Asignando nombre base a las categorías...',
	'Assigning user status...' => 'Asignando estado de usuarios...',
	'Migrating permissions to roles...' => 'Migrando permisos a roles...',
	'Populating authored and published dates for entries...' => 'Rellenando fechas de creación y publicación de las entradas...',
	'Classifying category records...' => 'Clasificando registros de categorías...',
	'Classifying entry records...' => 'Clasificando registros de entradas...',
	'Merging comment system templates...' => 'Combinando plantillas de comentarios del sistema...',
	'Populating default file template for templatemaps...' => 'Rellenando plantilla predefinida de ficheros para los templatemaps...',
	'Assigning user authentication type...' => 'Asignando tipo de autentificación de usuarios...',
	'Adding new feature widget to dashboard...' => 'Añadiendo un nuevo widget a la pizarra...',
	'Moving OpenID usernames to external_id fields...' => 'Moviendo los nombres de usuarios de OpenID a campos external_id...',
	'Assigning blog template set...' => 'Asignando conjunto de plantillas...', # Translate - New

## lib/MT/Core.pm
	'Create Blogs' => 'Crear blogs',
	'Manage Plugins' => 'Administrar extensiones',
	'Manage Templates' => 'Administrar plantillas',
	'View System Activity Log' => 'Ver registro de actividad del sistema',
	'Configure Blog' => 'Configurar blog',
	'Set Publishing Paths' => 'Configurar rutas de publicación',
	'Manage Categories' => 'Administrar categorías',
	'Manage Tags' => 'Administrar etiquetas',
	'Manage Address Book' => 'Administración del libro de Direcciones',
	'View Activity Log' => 'Ver registro de actividad',
	'Create Entries' => 'Crear entradas',
	'Send Notifications' => 'Enviar notificaciones',
	'Edit All Entries' => 'Editar todas las entradas', # Translate - New
	'Manage Pages' => 'Administrar páginas',
	'Publish Blog' => 'Publicar el Blog',
	'Save Image Defaults' => 'Guardar opciones de imagen',
	'Manage Assets' => 'Administrar multimedia',
	'Post Comments' => 'Comentarios',
	'Manage Feedback' => 'Administrar respuestas',
	'MySQL Database' => 'Base de datos MySQL',
	'PostgreSQL Database' => 'Base de datos PostgreSQL',
	'SQLite Database' => 'Base de datos SQLite',
	'SQLite Database (v2)' => 'Base de datos SQLite (v2)',
	'Convert Line Breaks' => 'Convertir saltos de línea',
	'Rich Text' => 'Texto con formato',
	'Movable Type Default' => 'Predefinido de Movable Type', # Translate - Case
	'weblogs.com' => 'weblogs.com',
	'technorati.com' => 'technorati.com',
	'google.com' => 'google.com',
	'Classic Blog' => 'Blog clásico',
	'Publishes content.' => 'Publica los contenidos.',
	'Synchronizes content to other server(s).' => 'Sincroniza el contenido con otros servidores.',
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
	'Publish Scheduled Entries' => 'Publicar las Notas Planificadas',
	'Junk Folder Expiration' => 'Caducidad de la carpeta basura',
	'Remove Temporary Files' => 'Borrar ficheros temporales',
	'Remove Expired User Sessions' => 'Borrar sesiones de usuario caducadas',

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
	'Error making path \'[_1]\': [_2]' => 'Error creando la ruta \'[_1]\': [_2]',
	'Copying [_1] to [_2]...' => 'Copiando [_1] a [_2]...',
	'Failed: ' => 'Falló: ',
	'Done.' => 'Hecho.',
	'Restoring asset associations ... ( [_1] )' => 'Restaurando asociaciones de ficheros multimedia ... ( [_1] )', # Translate - New
	'Restoring asset associations in entry ... ( [_1] )' => 'Restaurando asociaciones de ficheros multimedia en la entrada ... ( [_1] )', # Translate - New
	'Restoring asset associations in page ... ( [_1] )' => 'Restaurando asociaciones de ficheros multimedia en página ... ( [_1] )', # Translate - New
	'Restoring url of the assets ( [_1] )...' => 'Restaurando url de ficheros multimedia ( [_1] )...', # Translate - New
	'Restoring url of the assets in entry ( [_1] )...' => 'Restaurando url de ficheros multimedia en la entrada ( [_1] )...', # Translate - New
	'Restoring url of the assets in page ( [_1] )...' => 'Restaurando url de ficheros multimedia en la página ( [_1] )...', # Translate - New
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

## lib/MT/Blog.pm
	'No default templates were found.' => 'No se encontraron plantillas predefinidas.',
	'Cloned blog... new id is [_1].' => 'Blog clonado... el nuevo identificador es [_1]',
	'Cloning permissions for blog:' => 'Clonando permisos para el blog:',
	'[_1] records processed...' => 'Procesados [_1] registros...',
	'[_1] records processed.' => 'Procesados [_1] registros.',
	'Cloning associations for blog:' => 'Clonando asociaciones para el blog:',
	'Cloning entries for blog...' => 'Clonando entradas para el blog...',
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

## lib/MT/TBPing.pm

## lib/MT/Builder.pm
	'<[_1]> at line [_2] is unrecognized.' => 'No se reconoció a <[_1]> en la línea [_2].',
	'<[_1]> with no </[_1]> on line #' => '<[_1]> sin </[_1]> en la línea #',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]> sin </[_1]> en la línea [_2].',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]> sin </[_1]> en la línea [_2]',
	'Error in <mt:[_1]> tag: [_2]' => 'Error en la etiqueta <mt:[_1]>: [_2]',
	'Unknown tag found: [_1]' => 'Se encontró una etiqueta desconocida: [_1]', # Translate - New

## lib/MT/ObjectScore.pm
	'Object Score' => 'Score del Objeto',
	'Object Scores' => 'Scores de los Objetos',

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
	'First Weblog' => 'Primer weblog',
	'Error loading blog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => 'Error de telécargamiento #[_1] que comprende la creación de Usuarios. Por favor, verifique sus parámetros NewUserTemplateBlogId.',
	'Error provisioning blog for new user \'[_1]\' using template blog #[_2].' => 'Un error se ha producido en la creación del blog para el nuevo usuario \'[_1]\'utilizando la plantilla del blog #[_2].',
	'Error creating directory [_1] for blog #[_2].' => 'Error creando el directorio [_1] para el blog #[_2].',
	'Error provisioning blog for new user \'[_1] (ID: [_2])\'.' => 'Un error se ha producido en la creación del blog por el nuevo usuario \'[_1] (ID: [_2])\'.',
	'Blog \'[_1] (ID: [_2])\' for user \'[_3] (ID: [_4])\' has been created.' => 'Blog \'[_1] (ID: [_2])\' para el usuario \'[_3] (ID: [_4])\' ha sido creado.',
	'Error assigning blog administration rights to user \'[_1] (ID: [_2])\' for blog \'[_3] (ID: [_4])\'. No suitable blog administrator role was found.' => 'Error de asignación de los derechos para el usuario \'[_1] (ID: [_2])\' para el blog \'[_3] (ID: [_4])\'. Ningún rol de administrador adecuado ha sido encontrado.',
	'The login could not be confirmed because of a database error ([_1])' => 'No se pudo confirmar el acceso debido a un error de la base de datos ([_1])',
	'Our apologies, but you do not have permission to access any blogs within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Lo sentimos, pero no tiene permisos para acceder a ninguno de los blogs en esta instalación. Si cree que este mensaje se le muestra por error, por favor, contacte con su administrador de Movable Type.', # Translate - New
	'This account has been disabled. Please see your system administrator for access.' => 'Esta cuenta fue deshabilitada. Por favor, póngase en contacto con el administrador del sistema.',
	'Failed login attempt by pending user \'[_1]\'' => 'Intento fallido de inicio de sesión de un usuario pendiente \'[_1]\'',
	'This account has been deleted. Please see your system administrator for access.' => 'Esta cuenta fue eliminada. Por favor, póngase en contacto con el administrador del sistema.',
	'User cannot be created: [_1].' => 'No se pudo crear al usuario: [_1].',
	'User \'[_1]\' has been created.' => 'El usuario \'[_1]\' ha sido creado',
	'User \'[_1]\' (ID:[_2]) logged in successfully' => 'Usuario \'[_1]\' (ID:[_2]) inició una sesión correctamente',
	'Invalid login attempt from user \'[_1]\'' => 'Intento de acceso no válido del usuario \'[_1]\'',
	'User \'[_1]\' (ID:[_2]) logged out' => 'Usuario \'[_1]\' (ID:[_2]) se desconectó',
	'User requires password.' => 'El usuario necesita una contraseña.',
	'User requires password recovery word/phrase.' => 'El usuario necesita una palabra/frase para la recuperación de contraseña.',
	'User requires username.' => 'El usuario necesita un nombre.',
	'User requires display name.' => 'El usuario necesita un pseudónimo.',
	'Email Address is required for password recovery.' => 'La dirección de correo es necesaria para la recuperación de contraseña.',
	'Something wrong happened when trying to process signup: [_1]' => 'Algo mal ocurrió durante el proceso de alta: [_1]',
	'New Comment Added to \'[_1]\'' => 'Nuevo comentario añadido en \'[_1]\'',
	'Close' => 'Cerrar',
	'The file you uploaded is too large.' => 'El fichero que transfirió es demasiado grande.',
	'Unknown action [_1]' => 'Acción desconocida [_1]',
	'Warnings and Log Messages' => 'Mensajes de alerta e históricos',
	'Removed [_1].' => 'Se eliminó [_1].',

## lib/MT/Log.pm
	'System' => 'Sistema',
	'Page # [_1] not found.' => 'Página nº [_1] no encontrada.',
	'Entry # [_1] not found.' => 'Entrada nº [_1] no encontrada.',
	'Comment # [_1] not found.' => 'Comentario nº [_1] no encontrado.',
	'TrackBack # [_1] not found.' => 'TrackBack nº [_1] no encontrado.',

## lib/MT/IPBanList.pm
	'IP Ban' => 'IP Prohibido',
	'IP Bans' => 'IP Prohibidos',

## lib/MT/AtomServer.pm
	'PreSave failed [_1]' => 'Fallo en \'PreSave\' [_1]',
	'User \'[_1]\' (user #[_2]) added [lc,_4] #[_3]' => 'Usuario \'[_1]\' (usuario #[_2]) añadido [lc,_4] #[_3]', # Translate - New
	'User \'[_1]\' (user #[_2]) edited [lc,_4] #[_3]' => 'Usuario \'[_1]\' (usuario #[_2]) editado [lc,_4] #[_3]', # Translate - New

## lib/MT/PluginData.pm
	'Plugin Data' => 'Datos del Plugin',

## lib/MT/Plugin.pm
	'Publish' => 'Publicar',
	'My Text Format' => 'Mi formato de texto',

## lib/MT/Role.pm
	'Role' => 'Rol',

## lib/MT/Entry.pm
	'Draft' => 'Borrador',
	'Review' => 'Revisar',
	'Future' => 'Futuro',

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
	'Comment Listing' => 'Lista de comentarios',
	'Ping Listing' => 'Lista de pings',
	'Comment Preview' => 'Vista previa de comentario',
	'Comment Error' => 'Error de comentarios',
	'Dynamic Error' => 'Error dinámico',
	'Uploaded Image' => 'Imagen transferida',
	'Module' => 'Módulo',
	'Widget' => 'Widget',

## lib/MT/ImportExport.pm
	'No Blog' => 'Sin Blog',
	'Need either ImportAs or ParentAuthor' => 'Necesita ImportAs o ParentAuthor',
	'Creating new user (\'[_1]\')...' => 'Creando usario (\'[_1]\')...',
	'Saving user failed: [_1]' => 'Fallo guardando usario: [_1]',
	'Assigning permissions for new user...' => 'Asignar permisos al nuevo usario...',
	'Saving permission failed: [_1]' => 'Fallo guardando permisos: [_1]',
	'Creating new category (\'[_1]\')...' => 'Creando nueva categoría (\'[_1]\')...',
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

## lib/MT/JunkFilter.pm
	'Action: Junked (score below threshold)' => 'Acción: Basura (puntuación bajo nivel)',
	'Action: Published (default action)' => 'Acción: Publicado (acción predefinida)',
	'Junk Filter [_1] died with: [_2]' => 'Filtro basura [_1] murió con: [_2]',
	'Unnamed Junk Filter' => 'Filtro basura sin nombre',
	'Composite score: [_1]' => 'Puntuación compuesta: [_1]',

## lib/MT/Util.pm
	'moments from now' => 'dentro de unos momentos',
	'moments ago' => 'hace unos momentos',
	'[quant,_1,hour,hours] from now' => 'dentro de [quant,_1,hora,horas]',
	'[quant,_1,hour,hours] ago' => 'hace [quant,_1,hora,horas]',
	'[quant,_1,minute,minutes] from now' => 'dentro de [quant,_1,minuto,minutos]',
	'[quant,_1,minute,minutes] ago' => 'hace [quant,_1,minute,minutes]',
	'[quant,_1,day,days] from now' => 'dentro de [quant,_1,día,días]',
	'[quant,_1,day,days] ago' => 'hace [quant,_1,día,días]',
	'less than 1 minute from now' => 'dentro de menos de un minuto',
	'less than 1 minute ago' => 'hace menos de un minuto',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => 'dentro de [quant,_1,hora,horas], [quant,_2,minuto,minutos]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => 'hace [quant,_1,hora,horas], [quant,_2,minuto,minutos]',
	'[quant,_1,day,days], [quant,_2,hour,hours] from now' => 'dentro de [quant,_1,día,días], [quant,_2,hora,horas]',
	'[quant,_1,day,days], [quant,_2,hour,hours] ago' => 'hace [quant,_1,día,días], [quant,_2,hora,horas]',

## lib/MT/Mail.pm
	'Unknown MailTransfer method \'[_1]\'' => 'MailTransfer método desconocido \'[_1]\'',
	'Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]' => 'El envío de mensajes a través de SMTP necesita que su servidor tenga Mail::Sendmail instalado: [_1]',
	'Error sending mail: [_1]' => 'Error enviado correo: [_1]',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'No tiene configurada una ruta válida a sendmail en su máquina. ¿Quizás está intentando usar SMTP?',
	'Exec of sendmail failed: [_1]' => 'Fallo la ejecución de sendmail: [_1]',

## lib/MT/Permission.pm
	'Permission' => 'permiso',
	'Permissions' => 'Permisos',

## lib/MT/Scorable.pm
	'Object must be saved first.' => 'Primero debe guardarse el objeto.',
	'Already scored for this object.' => 'Ya puntuado en este objeto.',
	'Could not set score to the object \'[_1]\'(ID: [_2])' => 'No pudo darse puntuación al objeto \'[_1]\'(ID: [_2])',

## lib/MT/XMLRPCServer.pm
	'Invalid timestamp format' => 'Formato de fecha no válido',
	'No web services password assigned.  Please see your user profile to set it.' => 'No se ha establecido la contraseña de servicios web.  Por favor, vaya al perfil de su usario para configurarla.',
	'Requested permalink \'[_1]\' is not available for this page' => 'El enlace permanente solicitado \'[_1]\' no está disponible para esta página', # Translate - New
	'Saving folder failed: [_1]' => 'Fallo al guardar la carpeta: [_1]', # Translate - New
	'No blog_id' => 'Sin blog_id',
	'Invalid blog ID \'[_1]\'' => 'Identificador de blog  \'[_1]\' no válido',
	'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => 'El valor de \'mt_[_1]\' debe ser 0 ó 1 (era \'[_2]\')',
	'Not privileged to edit entry' => 'No tiene permisos para editar la entrada',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'Entrada \'[_1]\' ([lc,_5] #[_2]) borrada por \'[_3]\' (usuario #[_4]) para xml-rpc', # Translate - New
	'Not privileged to get entry' => 'No tiene permisos para obtener la entrada',
	'Not privileged to set entry categories' => 'No tiene permisos para establecer categorías en las entradas',
	'Not privileged to upload files' => 'No tiene privilegios para transferir ficheros',
	'No filename provided' => 'No se especificó el nombre del fichero ',
	'Error writing uploaded file: [_1]' => 'Error escribiendo el fichero transferido: [_1]',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Los métodos de las plantillas no están implementados, debido a las diferencias entre Blogger API y Movable Type API.',

## lib/MT/WeblogPublisher.pm
	'yyyy/index.html' => 'aaaa/index.html',
	'yyyy/mm/index.html' => 'aaaa/mm/index.html',
	'yyyy/mm/day-week/index.html' => 'aaaa/mm/día-de-la-semana/index.html',
	'yyyy/mm/entry-basename.html' => 'aaaa/mm/título-entrada.html',
	'yyyy/mm/entry_basename.html' => 'aaaa/mm/título_entrada.html',
	'yyyy/mm/entry-basename/index.html' => 'aaaa/mm/titutlo-entrada/index.html',
	'yyyy/mm/entry_basename/index.html' => 'aaaa/mm/título_entrada/index.html',
	'yyyy/mm/dd/entry-basename.html' => 'aaaa/mm/dd/título-entrada.html',
	'yyyy/mm/dd/entry_basename.html' => 'aaaa/mm/dd/título-entrada.html',
	'yyyy/mm/dd/entry-basename/index.html' => 'aaaa/mm/dd/título-entrada/index.html',
	'yyyy/mm/dd/entry_basename/index.html' => 'aaaa/mm/dd/título_entrada/index.html',
	'category/sub-category/entry-basename.html' => 'categoría/sub-categoría/título-entrada.html',
	'category/sub-category/entry-basename/index.html' => 'categoría/sub-categoría/título-entrada/index.html',
	'category/sub_category/entry_basename.html' => 'categoría/sub_categoría/título_entrada.html',
	'category/sub_category/entry_basename/index.html' => 'categoría/sub_categoría/título_entrada/index.html',
	'folder-path/page-basename.html' => 'ruta-carpeta/título-página.html',
	'folder-path/page-basename/index.html' => 'carpeta-path/título-página/index.html',
	'folder_path/page_basename.html' => 'ruta_carpeta/título_pagina.html',
	'folder_path/page_basename/index.html' => 'ruta_carpeta/título_pagina/index.html',
	'folder/sub_folder/index.html' => 'folder/sub_carpeta/index.html',
	'folder/sub-folder/index.html' => 'folder/sub-carpeta/index.html',
	'yyyy/mm/dd/index.html' => 'aaaa/mm/dd/index.html',
	'category/sub-category/index.html' => 'category/sub-categoría/index.html',
	'category/sub_category/index.html' => 'category/sub_categoría/index.html',
	'Archive type \'[_1]\' is not a chosen archive type' => 'El tipo de archivos \'[_1]\' no es un tipo de archivos seleccionado',
	'Parameter \'[_1]\' is required' => 'El parámetro \'[_1]\' es necesario',
	'You did not set your blog publishing path' => 'No configuró la ruta de publicación del blog',
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Ya existe el fichero del mismo archivo. Debe modificar el título o la ruta. ([_1])',
	'An error occurred publishing [_1] \'[_2]\': [_3]' => 'Un error se ha producido durante la publicación',
	'An error occurred publishing date-based archive \'[_1]\': [_2]' => 'Ocurrió un error publicando el archivo de fechas \'[_1]\': [_2]',
	'Writing to \'[_1]\' failed: [_2]' => 'Fallo escribiendo en \'[_1]\': [_2]',
	'Renaming tempfile \'[_1]\' failed: [_2]' => 'Fallo renombrando el fichero temporal \'[_1]\': [_2]',
	'Template \'[_1]\' does not have an Output File.' => 'La plantilla \'[_1]\' no tiene un fichero de salida.',
	'An error occurred while publishing scheduled entries: [_1]' => 'Ocurrió un error durante la publicación de las entradas programadas: [_1]',
	'YEARLY_ADV' => 'Anual',
	'MONTHLY_ADV' => 'Mensual',
	'CATEGORY_ADV' => 'De categorías',
	'PAGE_ADV' => 'De páginas',
	'INDIVIDUAL_ADV' => 'Individual',
	'DAILY_ADV' => 'Diario',
	'WEEKLY_ADV' => 'Semanal',
	'Author (#[_1])' => 'Autor (#[_1])',
	'AUTHOR_ADV' => 'AUTHOR_ADV',
	'AUTHOR-YEARLY_ADV' => 'AUTHOR-YEARLY_ADV',
	'AUTHOR-MONTHLY_ADV' => 'AUTHOR-MONTHLY_ADV',
	'AUTHOR-WEEKLY_ADV' => 'AUTHOR-WEEKLY_ADV',
	'AUTHOR-DAILY_ADV' => 'AUTHOR-DAILY_ADV',
	'CATEGORY-YEARLY_ADV' => 'Categoría',
	'CATEGORY-MONTHLY_ADV' => 'CATEGORY-MONTHLY_ADV',
	'CATEGORY-DAILY_ADV' => 'CATEGORY-DAILY_ADV',
	'CATEGORY-WEEKLY_ADV' => 'CATEGORY-WEEKLY_ADV',
	'author-display-name/index.html' => 'pseudónimo-autor/index.html',
	'author_display_name/index.html' => 'pseudónimo_autor/index.html',
	'author-display-name/yyyy/index.html' => 'pseudónimo-autor/aaaa/index.html',
	'author_display_name/yyyy/index.html' => 'pseudónimo_autor/aaaa/index.html',
	'author-display-name/yyyy/mm/index.html' => 'pseudónimo-autor/aaaa/mm/index.html',
	'author_display_name/yyyy/mm/index.html' => 'pseudónimo_autor/aaaa/mm/index.html',
	'author-display-name/yyyy/mm/day-week/index.html' => 'pseudónimo-autor/aaaa/mm/día-semana/index.html',
	'author_display_name/yyyy/mm/day-week/index.html' => 'pseudónimo_autor/aaaa/mm/día-semana/index.html',
	'author-display-name/yyyy/mm/dd/index.html' => 'pseudónimo-autor/aaaa/mm/dd/index.html',
	'author_display_name/yyyy/mm/dd/index.html' => 'pseudónimo_autor/aaaa/mm/dd/index.html',
	'category/sub-category/yyyy/index.html' => 'categoría/sub-categoría/aaaa/index.html',
	'category/sub_category/yyyy/index.html' => 'categoría/sub_categoría/aaaa/index.html',
	'category/sub-category/yyyy/mm/index.html' => 'categoría/sub-categoría/aaaa/mm/index.html',
	'category/sub_category/yyyy/mm/index.html' => 'categoría/sub_categoría/aaaa/mm/index.html',
	'category/sub-category/yyyy/mm/dd/index.html' => 'categoría/sub-categoría/aaaa/mm/dd/index.html',
	'category/sub_category/yyyy/mm/dd/index.html' => 'categoría/sub_categoría/aaaa/mm/dd/index.html',
	'category/sub-category/yyyy/mm/day-week/index.html' => 'categoría/sub-categoría/aaaa/mm/día-semana/index.html',
	'category/sub_category/yyyy/mm/day-week/index.html' => 'categoría/sub_categoría/aaaa/mm/día-semana/index.html',

## lib/MT/Auth.pm
	'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Configuración incorrecta de AuthenticationModule \'[_1]\': [_2]',
	'Bad AuthenticationModule config' => 'Configuración incorrecta de AuthenticationModule',

## lib/MT/Comment.pm
	'Comment' => 'Comentario',
	'Load of entry \'[_1]\' failed: [_2]' => 'Fallo al cargar la entrada \'[_1]\': [_2]',

## lib/MT/Component.pm
	'Loading template \'[_1]\' failed: [_2]' => 'Fallo cargando plantilla \'[_1]\': [_2]',

## lib/MT/DefaultTemplates.pm
	'Archive Index' => 'Índice de archivos',
	'Stylesheet' => 'Hoja de estilo',
	'JavaScript' => 'JavaScript',
	'RSD' => 'RSD',
	'Atom' => 'Atom',
	'RSS' => 'RSS',
	'Entry Listing' => 'Listada de entradas',
	'Displays error, pending or confirmation message for comments.' => 'Muestra mensajes de error o mensajes de pendiente y confirmación en los comentarios.',
	'Displays preview of comment.' => 'Muestra una previsualización del comentario.',
	'Displays errors for dynamically published templates.' => 'Muestra errores de las plantillas publicadas dinámicamente.',
	'Popup Image' => 'Una imagen emergente',
	'Displays image when user clicks a popup-linked image.' => 'Muestra una imagen cuando el usuario hace clic en una imagen con enlace a una ventana emergente.',
	'Displays results of a search.' => 'Muestra los resultados de una búsqueda.',
	'Footer' => 'Pie',
	'Sidebar - 2 Column Layout' => 'Barra lateral - 2 columnas',
	'Sidebar - 3 Column Layout' => 'Barra lateral - 3 columnas',
	'Comment throttle' => 'Aluvión de comentarios',
	'Commenter Confirm' => 'Confirmación de comentarista',
	'Commenter Notify' => 'Notificación de comentaristas',
	'New Comment' => 'Nuevo comentario',
	'New Ping' => 'Nuevo ping',
	'Entry Notify' => 'Notificación de entradas',
	'Subscribe Verify' => 'Verificación de suscripciones',

## lib/MT.pm.pre
	'Powered by [_1]' => 'Powered by [_1]',
	'Version [_1]' => 'Versión [_1]',
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype/',
	'OpenID URL' => 'URL de OpenID',
	'Sign in using your OpenID identity.' => 'Identifíquese usando OpenID.',
	'OpenID is an open and decentralized single sign-on identity system.' => 'OpenID es un sistema abierto y descentralizado de identificación.',
	'Sign In' => 'Registrarse',
	'Learn more about OpenID.' => 'Más información sobre OpenID.',
	'Your LiveJournal Username' => 'Su usuario de LiveJournal',
	'Sign in using your Vox blog URL' => 'Identifíquese usando la URL de su blog de Vox',
	'Learn more about LiveJournal.' => 'Más información sobre LiveJournal.',
	'Your Vox Blog URL' => 'La URL de su blog de Vox',
	'Learn more about Vox.' => 'Más información sobre Vox.',
	'TypeKey is a free, open system providing you a central identity for posting comments on weblogs and logging into other websites. You can register for free.' => 'TypeKey es un sistema abierto y gratuito que provee identificación centralizada para publicar comentarios en weblogs y registrarse en otros webs. Puede darse de alta gratuitamente.',
	'Sign in or register with TypeKey.' => 'Identifíquese o regístrese en TypeKey.',
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
	'__PORTAL_URL__' => '__PORTAL_URL__', # Translate - New
	'OpenID' => 'OpenID',
	'LiveJournal' => 'LiveJournal',
	'Vox' => 'Vox',
	'TypeKey' => 'TypeKey',
	'Movable Type default' => 'Predefinido de Movable Type',

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
	'Feed Subscription' => 'Suscripción a fuentes',
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
	'Back' => 'Volver',
	'Continue' => 'Continuar',
	'Show current mail settings' => 'Mostrar configuración actual del correo',
	'Periodically Movable Type will send email to inform users of new comments as well as other other events. For these emails to be sent properly, you must instruct Movable Type how to send email.' => 'Periódicamente, Movable Type enviará un correo para informar a los usuarios sobre los nuevos comentarios y otros eventos. Para que estos correos se envíen correctamente, debe decirle a Movable Type cómo enviarlos.',
	'An error occurred while attempting to send mail: ' => 'Ocurrió un error intentando enviar un mensaje de correo electrónico: ',
	'Send email via:' => 'Enviar correo vía:',
	'Select One...' => 'Seleccione uno...',
	'sendmail Path' => 'Ruta de sendmail',
	'The physical file path for your sendmail binary.' => 'Ruta física del fichero binario de sendmail.',
	'Outbound Mail Server (SMTP)' => 'Servidor de correo saliente (SMTP)',
	'Address of your SMTP Server.' => 'Dirección del servidor SMTP.',
	'Mail address for test sending' => 'Dirección de correo electrónico para comprobación de envío',
	'Send Test Email' => 'Enviar mensaje de comprobación',

## tmpl/wizard/complete.tmpl
	'Configuration File' => 'Archivo de configuración',
	'The [_1] configuration file can\'t be located.' => 'El archivo de configuración [_1] no puede ser localizado',
	'Please use the configuration text below to create a file named \'mt-config.cgi\' in the root directory of [_1] (the same directory in which mt.cgi is found).' => 'Utilice por favor el texto de la configuración abajo para crear un archivo nombrado \'mt-config.cgi\' en la raíz del directorio de [_1] (el mismo directorio en el cual se encuentra mt.cgi).',
	'The wizard was unable to save the [_1] configuration file.' => 'El asistente de instalación no ha podido guardar el [_1] archivo de configuración.',
	'Confirm your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click \'Retry\'.' => 'Confirme su [_1] directorio de inicio (el directorio que contiene mt.cgi) es posible de escribir su web server y de hacer clic \'Comprobación\'.',
	'Congratulations! You\'ve successfully configured [_1].' => '¡Felicidades! Ha configurado con éxito [_1].',
	'Your configuration settings have been written to the following file:' => 'Sus parámetros de configuración han sido escritos en los siguientes archivos:',
	'To reconfigure the settings, click the \'Back\' button below.' => 'Para reconfigurar sus parámetros, haga clic en el botón \'Volver\' aquí abajo.',
	'Show the mt-config.cgi file generated by the wizard' => 'Mostrar el archivo mt-config.cgi generado por el asistente de instalación',
	'I will create the mt-config.cgi file manually.' => 'Recrearé de nuevo el fichero mt-config.cgi manualmente.',
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
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => 'Una configuración del archivo (mt-config,cgi) existe, <a href="[_1]>identificarse</a> a Movable Type.',
	'To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page' => 'Para crear una nueva configuración del archivo usando Wizard, borre la configuración actual del archivo y actualice la página',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Movable Type necesita que JavaScript esté disponible en el navegador. Por favor, active JavaScript y recargue esta página para continuar.',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Este asistente le ayudará a configurar las opciones básicas necesarias para ejecutar Movable Type.',
	'<strong>Error: \'[_1]\' could not be found.</strong>  Please move your static files to the directory first or correct the setting if it is incorrect.' => '<strong>Error: \'[_1]\' no ha sido encontrado.</strong> Por favor,mueva sus archivos estáticos al primer directorio o corrija la configuración si no es correcta.',
	'Configure Static Web Path' => 'Configurar ruta del web estático',
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type viene con un directorio nombrado [_1] el cual contiene un número de archivos importantes tales como imágenes, archivos javascript y hojas de estilo en cascadas.',
	'The [_1] directory is in the main Movable Type directory which this wizard script resides, but due to your web server\'s configuration, the [_1] directory is not accessible in this location and must be moved to a web-accessible location (e.g., your web document root directory).' => 'El directorio [_1] está en el directorio principal de Movable Type que recide en el script de instalación, pero depende de la configuración de su web server, el directorio [_1] no es accesible en este lugar y debe ser removido a un lugar de web accesible (e.g., su documento de raíz del directorio web)',
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Este directorio o se ha renombrado o movido a un lugar fuera del directorio de Movable Type.',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => 'Cuando el directorio [_1] esté en un lugar accesible vía web, especifique el lugar debajo.',
	'This URL path can be in the form of [_1] or simply [_2]' => 'La dirección URL puede estar en la forma de [_1] o simplemente [_2]',
	'This path can be in the form of [_1] or simply [_2]' => 'Esta ruta puede estar en la forma de [_1] o simplemente [_2]', # Translate - New
	'Static web path' => 'Ruta estática del web',
	'Static file path' => 'Ruta estática de los ficheros', # Translate - New
	'Begin' => 'Comenzar',

## tmpl/wizard/packages.tmpl
	'Requirements Check' => 'Comprobación de requerimientos',
	'The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your blog\'s data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the \'Retry\' button.' => 'Los siguientes módulos de Perl son necesarios para la conexión con la base de datos. Movable Type necesita una base de datos para guardar los datos del blog. Por favor, instale los paquetes listados aquí para continuar. Cuando lo haya hecho, haga clic en el botón \'Reintentar\'.',
	'All required Perl modules were found.' => 'Se encontraron todos los módulos de Perl necesarios.',
	'You are ready to proceed with the installation of Movable Type.' => 'Está listo para continuar con la instalación de Movable Type.',
	'Some optional Perl modules could not be found. <a href="javascript:void(0)" onclick="[_1]">Display list of optional modules</a>' => 'No se encontrarons algunos módulos opcionales de Perl. <a href="javascript:void(0)" onclick="[_1]">Mostrar lista de módulos opcionales</a>',
	'One or more Perl modules required by Movable Type could not be found.' => 'No se encontraron uno o varios módulos de Perl necesarios.',
	'The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the \'Retry\' button to re-test for these packages.' => 'Los siguientes módulos de Perl son necesarios para que Movable Type se ejecute correctamente. Una vez los haya instalado, haga clic en el botón \'Reintentar\' para realizar la comprobación nuevamente.',
	'Some optional Perl modules could not be found. You may continue without installing these optional Perl modules. They may be installed at any time if they are needed. Click \'Retry\' to test for the modules again.' => 'No se encontraron algunos módulos opcionales de Perl. Puede continuar sin instalarlos. Podrá instalarlos cuando le sean necesarios. Haga clic en \'Reintentar\' para comprobar los módulos otra vez.',
	'Missing Database Modules' => 'Módulos de base de datos no encontrados',
	'Missing Optional Modules' => 'Módulos opcionales no encontrados',
	'Missing Required Modules' => 'Módulos necesarios no encontrados',
	'Minimal version requirement: [_1]' => 'Versión mínima requerida: [_1]',
	'Learn more about installing Perl modules.' => 'Más información sobre la instalación de módulos de Perl.',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'El servidor tiene instalados todos los módulos necesarios; no necesita realizar ninguna instalación adicional.',

## tmpl/wizard/configure.tmpl
	'Database Configuration' => 'Configuración de la base de datos',
	'You must set your Database Path.' => 'Debe definir la ruta de la base de datos.',
	'You must set your Database Name.' => 'Debe introducir el nombre de la base de datos.',
	'You must set your Username.' => 'Debe introducir el nombre del usuario.',
	'You must set your Database Server.' => 'Debe introducir el servidor de base de datos.',
	'Your database configuration is complete.' => 'Se ha completado la configuración de la base de datos.',
	'You may proceed to the next step.' => 'Puede continuar con el siguiente paso.',
	'Please enter the parameters necessary for connecting to your database.' => 'Por favor, introduzca los parámetros necesarios para la conexión con la base de datos.',
	'Show Current Settings' => 'Mostrar configuración actual',
	'Database Type' => 'Tipo de base de datos',
	'If your database type is not listed in the menu above, then you need to <a target="help" href="[_1]">install the Perl module necessary to connect to your database</a>.  If this is the case, please check your installation and <a href="javascript:void(0)" onclick="[_2]">re-test your installation</a>.' => 'Si su tipo de base de datos no está listada en el menú de abajo, entonces deberá <a target="help" href="[_1]">instalar los módulos de Perl necesarios para la conexión con la base de datos</a>.  Si este es el caso, por favor, compruebe su instalación y <a href="javascript:void(0)" onclick="[_2]">compruebe de nuevo su instalación</a>.',
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

## tmpl/wizard/blog.tmpl
	'Setup Your First Blog' => 'Configure su primer blog',
	'In order to properly publish your blog, you must provide Movable Type with your blog\'s URL and the path on the filesystem where its files should be published.' => 'Para publicar correctamente el blog, debe proveer a Movable Type la URL del blog y la ruta en el sistema donde se publicarán sus ficheros.',
	'My First Blog' => 'Mi primer blog',
	'Publishing Path' => 'Ruta de publicación',
	'Your \'Publishing Path\' is the path on your web server\'s file system where Movable Type will publish all the files for your blog. Your web server must have write access to this directory.' => 'La \'Ruta de publicación\' es la ruta en el sistema de archivos del servidor donde Movable Type publicará todos los ficheros del blog. El servidor web debe poder escribir en este directorio.',

## tmpl/cms/include/list_associations/page_title.tmpl
	'Permissions for [_1]' => 'Permisos de [_1]',
	'Permissions: System-wide' => 'Permisos: Todo el sistema',
	'Users for [_1]' => 'Usuarios de [_1]',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001-<mt:date format="%Y"> Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001-<mt:date format="%Y"> Six Apart. Todos los derechos reservados.',

## tmpl/cms/include/comment_table.tmpl
	'comment' => 'comentario',
	'comments' => 'comentarios',
	'to publish' => 'para publicar',
	'Publish selected comments (a)' => 'Publicar comentarios seleccionados (a)', # Translate - New
	'Delete selected comments (x)' => 'Borrar comentarios seleccionados (x)', # Translate - New
	'Report selected comments as Spam (j)' => 'Marcar comentarios seleccionados como spam (j)', # Translate - New
	'Spam' => 'Spam',
	'Report selected comments as Not Spam and Publish (j)' => 'Desmarcar como spam y publicar los comentarios seleccionados (j)', # Translate - New
	'Not Spam' => 'No es spam',
	'Are you sure you want to remove all comments reported as spam?' => '¿Está seguro de que desea borrar todos los comentarios marcados como spam?',
	'Delete all comments reported as Spam' => 'Borrar todos los comentarios marcados como spam', # Translate - New
	'Empty' => 'Vacío',
	'Ban This IP' => 'Bloquear esta IP',
	'Status' => 'Estado',
	'Entry/Page' => 'Entrada/Página',
	'Date' => 'Fecha',
	'IP' => 'IP',
	'Only show published comments' => 'Mostrar solo comentarios publicados',
	'Published' => 'Publicado',
	'Only show pending comments' => 'Mostrar solo comentarios pendientes',
	'Pending' => 'Pendiente',
	'Edit this comment' => 'Editar este comentario',
	'([quant,_1,reply,replies])' => '([quant,_1,respuesta,respuestas])',
	'Reply' => 'Responder',
	'Trusted' => 'Confiado',
	'Blocked' => 'Bloqueado',
	'Authenticated' => 'Autentificado',
	'Edit this [_1] commenter' => 'Editar comentarista [_1]',
	'Search for comments by this commenter' => 'Buscar comentarios de este comentarista',
	'Anonymous' => 'Anónimo',
	'View this entry' => 'Ver esta entrada', # Translate - New
	'View this page' => 'Ver esta página', # Translate - New
	'Search for all comments from this IP address' => 'Buscar todos los comentarios enviados desde esta dirección IP',

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
	'Activity Feed' => 'Fuente de actividad',
	'Disabled' => 'Desactivado',
	'Set Web Services Password' => 'Establecer contraseña de servicios web',

## tmpl/cms/include/overview-left-nav.tmpl
	'List Weblogs' => 'Listar weblogs',
	'Weblogs' => 'Weblogs',
	'List Users and Groups' => 'Listar usuarios y grupos',
	'Users &amp; Groups' => 'Usuarios &amp; grupos',
	'List Associations and Roles' => 'Listar asociaciones y roles',
	'Privileges' => 'Privilegios',
	'List Plugins' => 'Listar extensiones',
	'Aggregate' => 'Listar',
	'List Entries' => 'Listar entradas',
	'List uploaded files' => 'Lista de ficheros transferidos',
	'List Tags' => 'Listar etiquetas',
	'List Comments' => 'Listar comentarios',
	'List TrackBacks' => 'Listar TrackBacks',
	'Configure' => 'Configurar',
	'Edit System Settings' => 'Editar configuración del sistema',
	'Utilities' => 'Herramientas',
	'Search &amp; Replace' => 'Buscar &amp; Reemplazar',
	'_SEARCH_SIDEBAR' => 'Buscar',
	'Show Activity Log' => 'Mostrar histórico de actividad',

## tmpl/cms/include/asset_table.tmpl
	'asset' => 'fichero multimedia',
	'assets' => 'ficheros multimedia',
	'Delete selected assets (x)' => 'Borrar los ficheros multimedia seleccionados (x)',
	'Size' => 'Tamaño',
	'Created By' => 'Creado por',
	'Created On' => 'Creado en',
	'View' => 'Ver',
	'Asset Missing' => 'Fichero multimedia no existe', # Translate - New
	'No thumbnail image' => 'Sin miniatura', # Translate - New
	'[_1] is missing' => '[_1] no existe', # Translate - New

## tmpl/cms/include/import_start.tmpl
	'Importing...' => 'Importando...',
	'Importing entries into blog' => 'Importando entradas en el blog',
	'Importing entries as user \'[_1]\'' => 'Importando entradas como usario \'[_1]\'',
	'Creating new users for each user found in the blog' => 'Creando nuevos usarios para cada usario encontrado en el blog',

## tmpl/cms/include/log_table.tmpl
	'No log records could be found.' => 'No se encontraron registros.',
	'_LOG_TABLE_BY' => 'Por',
	'IP: [_1]' => 'IP: [_1]',
	'[_1]' => '[_1]',

## tmpl/cms/include/pagination.tmpl

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been backed up successfully!' => '¡La copia de seguridad de los datos se ha realizado con éxito!',
	'_external_link_target' => '_new',
	'Download This File' => 'Descargar este fichero',
	'_BACKUP_TEMPDIR_WARNING' => 'La copia de seguridad se realizó con éxito en el directorio [_1]. Descargue y <strong>borre luego</strong> los ficheros listados abajo desde [_1] <strong>inmediatamente</strong>, porque los ficheros de la copia de seguridad contiene información sensible.',
	'_BACKUP_DOWNLOAD_MESSAGE' => 'La descarga del fichero de la copia de seguridad comenzará automáticamente dentro de unos segundos. Si por alguna razón no lo hace, haga clic <a href="javascript:(void)" onclick="submit_form()">aquí</a> para comenzar la descarga manualmente. Por favor, tenga en cuenta que solo puede descargar el fichero de la copia de seguridad una vez por sesión.',
	'An error occurred during the backup process: [_1]' => 'Ocurrió un error durante la copia de seguridad: [_1]',

## tmpl/cms/include/cfg_content_nav.tmpl
	'Registration' => 'Registro',
	'Web Services' => 'Servicios web',

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Fecha de creación',
	'Click to edit contact' => 'Clic para editar el contacto',
	'Save changes' => 'Guardar cambios',
	'Save' => 'Guardar',

## tmpl/cms/include/footer.tmpl
	'Hey, this is a Beta version of MT: Don\'t use it in production! And you\'ll want to upgrade to the release version by January 31, 2008. (<a href="[_1]" target="_blank">License details</a>)' => 'Esta es una versión Beta de MT: ¡no la use en producción! Para actualizar, espere a la versión estable que se publicará el 31 de enero de 2008 (<a href="[_1]" target="_blank">Detalles de la licencia</a>)', # Translate - New
	'Dashboard' => 'Pizarra',
	'Compose Entry' => 'Componer entrada',
	'Manage Entries' => 'Administrar entradas',
	'System Settings' => 'Configuración del sistema',
	'Help' => 'Ayuda',
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> versión [_2]', # Translate - New
	'with' => 'con',

## tmpl/cms/include/tools_content_nav.tmpl

## tmpl/cms/include/commenter_table.tmpl
	'Identity' => 'Identidad',
	'Last Commented' => 'Últimos comentados',
	'Only show trusted commenters' => 'Mostrar solo comentaristas confiados',
	'Only show banned commenters' => 'Mostrar solo comentaristas bloqueados',
	'Banned' => 'Bloqueado',
	'Only show neutral commenters' => 'Mostrar solo comentaristas neutrales',
	'Edit this commenter' => 'Editar este comentarista',
	'View this commenter&rsquo;s profile' => 'Ver el perfil de este comentarista',

## tmpl/cms/include/ping_table.tmpl
	'Publish selected [_1] (p)' => 'Publicar [_1] seleccionados (p)',
	'Delete selected [_1] (x)' => 'Borrar [_1] seleccionados (x)', # Translate - New
	'Report selected [_1] as Spam (j)' => 'Marcar como spam [_1] seleccionados (j)', # Translate - New
	'Report selected [_1] as Not Spam and Publish (j)' => 'Desmarcar como spam y publicar [_1] seleccionados (j)', # Translate - New
	'Are you sure you want to remove all TrackBacks reported as spam?' => '¿Está seguro de que desea borrar todos los TrackBacks marcados como spam?',
	'Deletes all [_1] reported as Spam' => 'Borrar todos los [_1] marcados como spam', # Translate - New
	'From' => 'Origen',
	'Target' => 'Destino',
	'Only show published TrackBacks' => 'Mostrar solo TrackBacks publicados',
	'Only show pending TrackBacks' => 'Mostrar solo TrackBacks pendientes',
	'Edit this TrackBack' => 'Editar este TrackBack',
	'Go to the source entry of this TrackBack' => 'Ir a la entrada de origen de este TrackBack',
	'View the [_1] for this TrackBack' => 'Mostrar [_1] de este TrackBack',

## tmpl/cms/include/entry_table.tmpl
	'Save these entries (s)' => 'Grabar estas entradas (s)', # Translate - New
	'Republish selected entries (r)' => 'Republicar entradas seleccionadas (r)', # Translate - New
	'Delete selected entries (x)' => 'Borrar entradas seleccionadas (x)', # Translate - New
	'Save these pages (s)' => 'Grabar estas páginas (s)', # Translate - New
	'Republish selected pages (r)' => 'Republicar páginas seleccionadas (r)', # Translate - New
	'Delete selected pages (x)' => 'Borrar páginas seleccionadas (x)', # Translate - New
	'to republish' => 'para reconstruir',
	'Republish' => 'Reconstruir',
	'Last Modified' => 'Última modificación',
	'Created' => 'Creado',
	'Unpublished (Draft)' => 'No publicado (Borrador)',
	'Unpublished (Review)' => 'No publicado (Revisión)',
	'Scheduled' => 'Programado',
	'Only show unpublished entries' => 'Mostrar solo las entradas no publicadas', # Translate - New
	'Only show unpublished pages' => 'Mostrar solo las páginas no publicadas', # Translate - New
	'Only show published entries' => 'Mostrar solo las entradas publicadas', # Translate - New
	'Only show published pages' => 'Mostrar solo las páginas publicadas', # Translate - New
	'Only show entries for review' => 'Mostrar solo las entradas para revisar', # Translate - New
	'Only show pages for review' => 'Mostrar solo las páginas para revisar', # Translate - New
	'Only show scheduled entries' => 'Mostrar solo las entradas programadas', # Translate - New
	'Only show scheduled pages' => 'Mostrar solo las páginas programadas', # Translate - New
	'Edit Entry' => 'Editar entrada', # Translate - New
	'Edit Page' => 'Editar página', # Translate - New
	'View entry' => 'Ver entrada', # Translate - Case
	'View page' => 'Ver página', # Translate - New

## tmpl/cms/include/login_mt.tmpl

## tmpl/cms/include/author_table.tmpl
	'_USER_DISABLED' => 'Deshabilitado',

## tmpl/cms/include/calendar.tmpl
	'_LOCALE_WEEK_START' => '0', # Translate - New
	'Sunday' => 'Domingo',
	'Monday' => 'Lunes',
	'Tuesday' => 'Martes',
	'Wednesday' => 'Miércoles',
	'Thursday' => 'Jueves',
	'Friday' => 'Viernes',
	'Saturday' => 'Sábado',
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
	'_SHORT_MAY' => '_SHORT_MAY',
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
	'to act upon' => 'actuar cuando',
	'Go' => 'Ir',

## tmpl/cms/include/anonymous_comment.tmpl
	'Anonymous Comments' => 'Comentarios anónimos',
	'Require E-mail Address for Anonymous Comments' => 'Requerir dirección de correo en los comentarios anónimos',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Si está activo, los visitantes deberán introducir una dirección válida de correo electrónico para comentar.',

## tmpl/cms/include/display_options.tmpl
	'Display Options' => 'Opciones de visualización',
	'_DISPLAY_OPTIONS_SHOW' => 'Mostrar',
	'[quant,_1,row,rows]' => '[quant,_1,fila,filas]',
	'Compact' => 'Compacto',
	'Expanded' => 'Expandido',
	'Action Bar' => 'Barra de acciones',
	'Top' => 'Arriba',
	'Both' => 'Ambos',
	'Bottom' => 'Abajo',
	'Date Format' => 'Formato de fechas',
	'Relative' => 'Relativo',
	'Full' => 'Completo',
	'Save display options' => 'Guardar opciones de visualización',
	'Close display options' => 'Cerrar opciones de visualización',

## tmpl/cms/include/backup_start.tmpl
	'Backing up Movable Type' => 'Haciendo copia de seguridad de Movable Type',

## tmpl/cms/include/chromeless_footer.tmpl
	'<a href="[_1]">Movable Type</a> version [_2]' => '<a href="[_1]">Movable Type</a> versión [_2]',

## tmpl/cms/include/template_table.tmpl
	'template' => 'plantilla',
	'templates' => 'plantillas',
	'Output File' => 'Fichero de salida',
	'Type' => 'Tipo',
	'Linked' => 'Enlazado',
	'Linked Template' => 'Plantilla enlazada',
	'Dynamic' => 'Dinámico',
	'Dynamic Template' => 'Plantilla dinámica',
	'Published w/Indexes' => 'Publicando con índices',
	'Published Template w/Indexes' => 'Plantilla publicada con índices',
	'-' => '-',
	'Yes' => 'Sí',
	'No' => 'No',
	'View Published Template' => 'Ver plantilla publicada',

## tmpl/cms/include/asset_upload.tmpl
	'Before you can upload a file, you need to publish your blog. [_1]Configure your blog\'s publishing paths[_2] and rebuild your blog.' => 'Antes de subir un fichero, debe publicar el blog. [_1]Configure las rutas de publicación del blog[_2] y reconstrúyalo.',
	'Your system or blog administrator needs to publish the blog before you can upload files. Please contact your system or blog administrator.' => 'El administrador del sistema o del blog debe publicarlo antes de que pueda subir ficheros. Por favor, contacte con el administrador del sistema o del blog.',
	'Close (x)' => 'Cerrar (x)',
	'Select File to Upload' => 'Seleccione el fichero a subir',
	'_USAGE_UPLOAD' => 'Puede transferir el fichero a un subdirectorio en la ruta seleccionada. Si el subdirectorio no existe, se creará.',
	'Upload Destination' => 'Destino de la transferencia',
	'Choose Folder' => 'Seleccionar carpeta', # Translate - New
	'Upload (s)' => 'Subir (s)',
	'Upload' => 'Subir',
	'Back (b)' => 'Volver (b)',
	'Cancel (x)' => 'Cancelar (x)',
	'Add [lc,_1] name' => 'Añadir nombre de [lc,_1]',

## tmpl/cms/include/listing_panel.tmpl
	'Step [_1] of [_2]' => 'Paso [_1] de [_2]',
	'Reset' => 'Reiniciar',
	'Go to [_1]' => 'Ir a [_1]',
	'Sorry, there were no results for your search. Please try searching again.' => 'Lo siento, no se encontraron resultados para la búsqueda. Por favor, intente buscar de nuevo.',
	'Sorry, there is no data for this object set.' => 'Lo siento, no hay datos para este conjunto de objetos.',
	'Confirm (s)' => 'Confirmar (s)',
	'Confirm' => 'Confirmar',
	'Continue (s)' => 'Continuar (s)',

## tmpl/cms/include/header.tmpl
	'Hi [_1],' => 'Hola [_1],',
	'Logout' => 'Cerrar sesión',
	'Select another blog...' => 'Seleccionar otro blog...',
	'Create a new blog' => 'Crear un nuevo blog',
	'Write Entry' => 'Escribir entrada',
	'Blog Dashboard' => 'Pizarra del blog',
	'View Site' => 'Ver sitio',
	'Search (q)' => 'Buscar (q)',

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
	'Delete selected blogs (x)' => 'Borrar blogs seleccionados (x)',

## tmpl/cms/include/blog-left-nav.tmpl
	'Creating' => 'Creando',
	'Create Entry' => 'Crear nueva entrada',
	'Community' => 'Comunidad',
	'List Commenters' => 'Listar comentaristas',
	'Edit Address Book' => 'Editar agenda',
	'List Users &amp; Groups' => 'Lisar usuarios &amp; grupos',
	'List &amp; Edit Templates' => 'Listar y editar plantillas',
	'Edit Categories' => 'Editar categorías',
	'Edit Tags' => 'Editar etiquetas',
	'Edit Weblog Configuration' => 'Editar configuración del weblog',
	'Backup this weblog' => 'Hacer una copia de seguridad de este weblog',
	'Import &amp; Export Entries' => 'Importar &amp; Exportar entradas',
	'Import / Export' => 'Importar / Exportar',
	'Rebuild Site' => 'Reconstruir sitio',

## tmpl/cms/include/users_content_nav.tmpl
	'Profile' => 'Perfil',
	'Details' => 'Detalles',

## tmpl/cms/include/import_end.tmpl
	'All data imported successfully!' => '¡Importados con éxito todos los datos!',
	'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Asegúrese de borrar los ficheros importados del directorio \'import\', para evitar procesarlos de nuevo al ejecutar en otra ocasión el proceso de importación.',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Ocurrió un error durante el proceso de importación: [_1]. Por favor, compruebe su fichero de importación.',

## tmpl/cms/include/archive_maps.tmpl
	'Path' => 'Ruta',
	'Custom...' => 'Personalizar...',

## tmpl/cms/include/cfg_system_content_nav.tmpl

## tmpl/cms/include/category_selector.tmpl
	'Add sub category' => 'Añadir sub categoría',

## tmpl/cms/dialog/recover.tmpl
	'Your password has been changed, and the new password has been sent to your email address ([_1]).' => 'Se cambió su contraseña y la nueva se le ha enviado a su dirección de correo electrónico ([_1]).',
	'Sign in to Movable Type (s)' => 'Identifíquese en Movable Type (s)',
	'Sign in to Movable Type' => 'Identifíquese en Movable Type',
	'Password recovery word/phrase' => 'Palabra/frase para la recuperación de contraseña',
	'Recover (s)' => 'Recuperar (s)',
	'Recover' => 'Recuperar',
	'Go Back (x)' => 'Volver',

## tmpl/cms/dialog/restore_end.tmpl
	'An error occurred during the restore process: [_1] Please check your restore file.' => 'Ocurrió un error durante el proceso de restauración: [_1] Por favor, compruebe el fichero de restauración.',
	'View Activity Log (v)' => 'Mostrar registro de actividad (v)',
	'All data restored successfully!' => '¡Se restauraron todos los datos correctamente!',
	'Close (s)' => 'Cerrado (s)',
	'Next Page' => 'Página siguiente',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => 'La página le redireccionará a una nueva en 3 segundos. [_1]Parar la redirección.[_2]',

## tmpl/cms/dialog/asset_replace.tmpl
	'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'El fichero llamado \'[_1]\' ya existe. ¿Desea sobreescribirlo?',
	'Yes (s)' => 'Sí (s)',

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

## tmpl/cms/dialog/refresh_templates.tmpl
	'Refresh Templates' => 'Refrescar plantillas', # Translate - New
	'Refresh templates' => 'Refrescar plantillas', # Translate - New
	'Updates current templates while retaining any user-created or user-modified templates.' => 'Actualiza las plantillas actuales conservando las modificadas o creadas por el usuario.', # Translate - New
	'Clean start' => 'Desde cero', # Translate - New
	'Deletes all existing templates and installs factory default template set.' => 'Borra todas las plantillas existentes e instala el conjunto de plantillas predefinido.', # Translate - New
	'Make backups of existing templates first' => 'Primero, haga copias de seguridad de las plantillas', # Translate - New
	'You have requested to refresh your templates. This action will:' => 'Ha solicitado refrescar sus plantillas. Esta acción:', # Translate - New
	'potentially install new templates' => 'instalará potencialmente nuevas plantillas', # Translate - New
	'overwrite some existing templates with new template code' => 'reescribirá algunas plantillas existentes con el código de las nuevas plantillas', # Translate - New
	'backups will be made of your templates and can be accessed through your backup filter' => 'se harán copias de seguridad de sus plantillas y estarán disponibles a través de su filtro de copias', # Translate - New
	'You have requested to start over with a new template set. This action will:' => 'Ha solicitado comenzar desde cero con un nuevo conjunto de plantillas. Esta acción:', # Translate - New
	'delete all of the templates in your blog' => 'borrará todas las plantillas del blog', # Translate - New
	'install new templates from the selected template set' => 'instalará nuevas plantillas del conjunto seleccionado', # Translate - New
	'Are you sure you wish to continue?' => '¿Está seguro de que desea continuar?', # Translate - New

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

## tmpl/cms/dialog/restore_upload.tmpl
	'Restore: Multiple Files' => 'Restaurar: Múltiples ficheros',
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => 'La cancelación del proceso creará objetos huérfanos. ¿Está seguro de que desea cancelar la operación de restauración?',
	'Please upload the file [_1]' => 'Por favor, suba el fichero [_1]',

## tmpl/cms/dialog/entry_notify.tmpl
	'Send a Notification' => 'Enviar una notificación',
	'You must specify at least one recipient.' => 'Debe especificar al menos un destinatario.',
	'Your blog\'s name, this entry\'s title and a link to view it will be sent in the notification.  Additionally, you can add a  message, include an excerpt of the entry and/or send the entire entry.' => 'En la notificación se enviarán el nombre del blog, el título de la entrada y un enlace para verla. Además, podrá añadir un mensaje, incluir un resumen de la entrada y/o enviar la entrada completa.',
	'Recipients' => 'Destinatarios',
	'Enter email addresses on separate lines, or comma separated.' => 'Introduzca las direcciones de correo en líneas separadas, o separándolas con comas.',
	'All addresses from Address Book' => 'Todas las direcciones de la agenda',
	'Optional Message' => 'Mensaje opcional',
	'Optional Content' => 'Contenido opcional',
	'(Entry Body will be sent without any text formatting applied)' => '(El cuerpo de la entrada se enviará sin aplicarse ningún formateado de texto)',
	'Send notification (s)' => 'Enviar notificación (s)',
	'Send' => 'Enviar',

## tmpl/cms/dialog/asset_options.tmpl
	'File Options' => 'Opciones de ficheros',
	'The file named \'[_1]\' has been uploaded. Size: [quant,_2,byte,bytes].' => 'Se transfirió el fichero llamado \'[_1]\'. Tamaño: [quant,_2,byte,bytes].',
	'Create entry using this uploaded file' => 'Crear entrada utilizando el fichero transferido',
	'Create a new entry using this uploaded file.' => 'Crear una nueva entrada usando el fichero transferido.',
	'Finish (s)' => 'Finalizar (s)',
	'Finish' => 'Finalizar',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Confirm Publishing Configuration' => 'Confirmar configuración de publicación',
	'URL is not valid.' => 'La URL no es válida.',
	'You can not have spaces in the URL.' => 'No puede introducir espacios en la URL.',
	'You can not have spaces in the path.' => 'No puede introducir espacios en la ruta.',
	'Path is not valid.' => 'La ruta no es válida.',
	'Archive URL' => 'URL de archivos',

## tmpl/cms/dialog/asset_options_image.tmpl
	'Display image in entry' => 'Mostrar imagen en la entrada',
	'Alignment' => 'Alineación',
	'Left' => 'Izquierda',
	'Center' => 'Centro',
	'Right' => 'Derecha',
	'Use thumbnail' => 'Usar miniatura',
	'width:' => 'ancho:',
	'pixels' => 'píxeles',
	'Link image to full-size version in a popup window.' => 'Enlazar la versión original de la imagen en un popup.',
	'Remember these settings' => 'Recordar estas opciones',

## tmpl/cms/dialog/create_association.tmpl
	'No roles exist in this installation. [_1]Create a role</a>' => 'Ningún rol existe en esta instalación. [_1]Crear un rol</a>',
	'No groups exist in this installation. [_1]Create a group</a>' => 'Ningún grupo existe en esta instalación. [_1]Crear un grupo</a>',
	'No users exist in this installation. [_1]Create a user</a>' => 'Ningún usuario existe en esta instalación. [_1]Crear un usuario</a>',
	'No blogs exist in this installation. [_1]Create a blog</a>' => 'Ningún blog existe en esta instalación. [_1]Crear un blog</a>',

## tmpl/cms/dialog/restore_start.tmpl
	'Restoring...' => 'Restaurando...',

## tmpl/cms/widget/new_user.tmpl
	'Welcome to Movable Type, the world\'s most powerful blogging, publishing and social media platform. To help you get started we have provided you with links to some of the more common tasks new users like to perform:' => 'Bienvenido a Movable Type, la plataforma social de blogs y publicación más potente del mundo. Para ayudarle a comenzar, le ofrecemos algunos enlaces con las tareas más comunes que los nuevos usuarios suelen realizar:',
	'Write your first post' => 'Escribir la primera entrada',
	'What would a blog be without content? Start your Movable Type experience by creating your very first post.' => '¿Qué sería un blog sin contenidos? Empiece su experiencia en Movable Type creando la primera entrada.',
	'Design your blog' => 'Diseñar el blog',
	'Customize the look and feel of your blog quickly by selecting a design from one of our professionally designed themes.' => 'Personalice el diseño y estilo del blog seleccionando uno de nuestros temas de calidad profesional.',
	'Explore what\'s new in Movable Type 4' => 'Explorar las novedades de Movable Type 4',
	'Whether you\'re new to Movable Type or using it for the first time, learn more about what this tool can do for you.' => 'Tanto si es la primera vez que usa Movable Type, como si ya es un usuario con experiencia, aprenda qué es lo que puede hacer esta herramienta por usted.',

## tmpl/cms/widget/blog_stats_recent_entries.tmpl
	'[quant,_1,entry,entries] tagged &ldquo;[_2]&rdquo;' => '[quant,_1,entrada etiquetada,entradas etiquetadas] &ldquo;[_2]&rdquo;',
	'Posted by [_1] [_2] in [_3]' => 'Publicado por [_1] [_2] en [_3]',
	'Posted by [_1] [_2]' => 'Publicado por [_1] [_2]',
	'Tagged: [_1]' => 'Etiquetas: [_1]',
	'View all entries tagged &ldquo;[_1]&rdquo;' => 'Ver todas las entradas etiquetadas con &ldquo;[_1]&rdquo;',
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
	'Trackbacks' => 'Trackbacks',
	'Import Content' => 'Importar contenido',
	'Blog Preferences' => 'Preferencias del blog',

## tmpl/cms/widget/new_version.tmpl
	'What\'s new in Movable Type [_1]' => 'Novedades en Movable Type [_1]',
	'Congratulations, you have successfully installed Movable Type [_1]. Listed below is an overview of the new features found in this release.' => '¡Felicidades, ha instalado con éxito Movable Type [_1]! Debajo encontrará un resumen de las nuevas funciones de esta versión.', # Translate - New

## tmpl/cms/widget/this_is_you.tmpl
	'Your <a href="[_1]">last entry</a> was [_2] in <a href="[_3]">[_4]</a>.' => 'La <a href="[_1]">última entrada</a> estaba [_2] en <a href="[_3]">[_4]</a>.', # Translate - New
	'You have <a href="[_1]">[quant,_2,draft,drafts]</a>.' => 'Tiene <a href="[_1]">[quant,_2,borrador,borradores]</a>.',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a> with <a href="[_3]">[quant,_4,comment,comments]</a>.' => 'Usted ha escrito <a href="[_1]">[quant,_2,entrada,entradas]</a> con <a href="[_3]">[quant,_4,comentario,comentarios]</a>.',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>.' => 'Usted ha escrito <a href="[_1]">[quant,_2,entrada,entradas]</a>.',
	'Edit your profile' => 'Edite su perfil',

## tmpl/cms/widget/new_install.tmpl
	'Thank you for installing Movable Type' => 'Gracias por instalar Movable Type',
	'Congratulations on installing Movable Type, the world\'s most powerful blogging, publishing and social media platform. To help you get started we have provided you with links to some of the more common tasks new users like to perform:' => 'Felicidades por la instalación de Movable Type, la plataforma más potente del mundo de blogs y publicación. Para ayudarle a comenzar, le proveemos algunos enlaces a las tareas más comunes que los nuevos usuarios suelen realizar:',
	'Add more users to your blog' => 'Añadir más usuarios al blog',
	'Start building your network of blogs and your community now. Invite users to join your blog and promote them to authors.' => 'Comience ahora a construir su red de blogs y su comunidad. Invite a otros usuarios a unirse a su blog y hágalos autores.',

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
	'Movable Type was unable to locate your \'mt-static\' directory. Please configure the \'StaticFilePath\' configuration setting in your mt-config.cgi file, and create a writable \'support\' directory underneath your \'mt-static\' directory.' => 'Movable Type no pudo localizar el directorio \'mt-static\'. Por favor, configure la opción \'StaticFilePath\' en el fichero mt-config.cgi y cree un directorio \'support\' en el que se pueda escribir dentro del directorio \'mt-static\'.',
	'Movable Type was unable to write to its \'support\' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.' => 'Movable Type no pudo escribir en el directorio \'support\'. Por favor, cree un directorio en este lugar: [_1], y asígnele permisos para permitir que el servidor web pueda acceder y escribir en él.',
	'[_1] [_2] - [_3] [_4]' => '[_1] [_2] - [_3] [_4]',
	'You have <a href=\'[_3]\'>[quant,_1,comment,comments] from [_2]</a>' => 'Tiene <a href=\'[_3]\'>[quant,_1,comentario,comentarios] de [_2]</a>',
	'You have <a href=\'[_3]\'>[quant,_1,entry,entries] from [_2]</a>' => 'Tiene <a href=\'[_3]\'>[quant,_1,entrada] de [_2]</a>',

## tmpl/cms/widget/blog_stats_entry.tmpl
	'Most Recent Entries' => 'Últimas entradas',
	'...' => '...',
	'View all entries' => 'Mostrar todas las entradas',

## tmpl/cms/widget/blog_stats_tag_cloud.tmpl

## tmpl/cms/widget/blog_stats_comment.tmpl
	'Most Recent Comments' => 'Últimos comentarios',
	'[_1] [_2], [_3] on [_4]' => '[_1] [_2], [_3] en [_4]',
	'View all comments' => 'Mostrar todos los comentarios',
	'No comments available.' => 'No hay comentarios disponibles',

## tmpl/cms/popup/rebuilt.tmpl
	'Success' => 'OK',
	'All of your files have been published.' => 'Se han publicado todos sus ficheros.',
	'Your [_1] has been published.' => 'Su [_1] se ha publicado.',
	'Your [_1] archives have been published.' => 'Se han publicado los archivos [_1].',
	'Your [_1] templates have been published.' => 'Se han publicado las plantillas [_1].',
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
	'Index Template: [_1]' => 'Plantilla Índice: [_1]',
	'Only Indexes' => 'Solamente Índice',
	'Only [_1] Archives' => 'Solamente [_1] Archivos',
	'Publish (s)' => 'Publicar (s)',

## tmpl/cms/edit_role.tmpl
	'Edit Role' => 'Editar rol',
	'Your changes have been saved.' => 'Sus cambios han sido guardados.',
	'List Roles' => 'Listar roles',
	'[quant,_1,User,Users] with this role' => '[quant,_1,User,Users] con este rol',
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'Ha cambiado los provilegios de este rol.  Esto va cambiar las posibilidades de maniobra de los usuarios asociados a este rol. Si usted prefiere, puede guardar este rol con otro nombre diferente.',
	'Role Details' => 'Detalles de los roles',
	'Created by' => 'Creado por',
	'Check All' => 'Seleccionar todos',
	'Uncheck All' => 'Deseleccionar todos',
	'Administration' => 'Administración',
	'Authoring and Publishing' => 'Creación y publicación',
	'Designing' => 'Diseño',
	'Commenting' => 'Comentar',
	'Duplicate Roles' => 'Duplicar roles',
	'These roles have the same privileges as this role' => 'Estos roles tienen privilegios parecidos a este rol',
	'Save changes to this role (s)' => 'Guardar cambios en el rol (s)', # Translate - New

## tmpl/cms/cfg_plugin.tmpl
	'System Plugin Settings' => 'Sistema de configuración de la extensión',
	'Useful links' => 'Enlaces útiles',
	'http://plugins.movabletype.org/' => 'http://plugins.movabletype.org/', # Translate - New
	'Find Plugins' => 'Buscar extensiones',
	'Plugin System' => 'Sistema de extensiones',
	'Manually enable or disable plugin-system functionality. Re-enabling plugin-system functionality, will return all plugins to their original state.' => 'Activar o desactivar manualmente el sistema de extensiones funcionales.  Re-activar el sistema de extensiones funcionales, volver todas las extensiones a su estado original.',
	'Disable plugin functionality' => 'Desactivar las funciones de las extensiones',
	'Disable Plugins' => 'Desactivar extensiones',
	'Enable plugin functionality' => 'Activar las funciones de las extensiones',
	'Enable Plugins' => 'Activar extensiones',
	'Your plugin settings have been saved.' => 'Se guardó la configuración de la extensión.',
	'Your plugin settings have been reset.' => 'Se reinició la configuración de la extensión.',
	'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => 'Sus extensiones se reconfiguraron. Debido a que está ejecutando mod_perl, debería reiniciar su servidor web para que estos cambios tengan efecto.',
	'Your plugins have been reconfigured.' => 'Se reconfiguraron las extensiones.',
	'Are you sure you want to reset the settings for this plugin?' => '¿Está seguro de que desea reiniciar la configuración de esta extensión?',
	'Are you sure you want to disable plugin functionality?' => '¿Está seguro de querer desactivar la funcinalidad de las extensiones?',
	'Disable this plugin?' => '¿Desactivar esta extensión?',
	'Are you sure you want to enable plugin functionality? (This will re-enable any plugins that were not individually disabled.)' => '¿Está seguro de querer artivar la funcionalidad de las extensiones?  (Esto reactivará cada extensión que no haya sido desactivada individualmente.)',
	'Enable this plugin?' => '¿Activar esta extensión?',
	'Failed to Load' => 'Falló al cargar',
	'(Disable)' => '(Desactivado)',
	'Enabled' => 'Activado',
	'(Enable)' => '(Activado)',
	'Settings for [_1]' => 'Configuración de [_1]',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be 100% functional. Furthermore, it will require an upgrade once you have upgraded to the next Movable Type major release (when available).' => 'Esta extensión no se ha actualizado para soportar Movable Type [_1]. Por tanto, podría no ser 100% funcional. Además, necesitará una actualización cuando se actualice a la siguiente versión superior de Movable Type (cuando esté disponible).',
	'Plugin error:' => 'Error de la extensión:',
	'Info' => 'Información',
	'Resources' => 'Recursos',
	'Run [_1]' => 'Ejecutar [_1]',
	'Documentation for [_1]' => 'Documentación sobre [_1]',
	'Documentation' => 'Documentación',
	'More about [_1]' => 'Más sobre [_1]',
	'Plugin Home' => 'Web de Extensiones',
	'Author of [_1]' => 'Autor de [_1]',
	'Tags:' => 'Etiquetas:',
	'Tag Attributes:' => 'Atributos de etiquetas:',
	'Text Filters' => 'Filtros de texto',
	'Junk Filters:' => 'Filtros de basura:',
	'Reset to Defaults' => 'Reiniciar con los valores predefinidos',
	'No plugins with blog-level configuration settings are installed.' => 'No hay extensiones instaladas con configuración a nivel del sistema.',
	'No plugins with configuration settings are installed.' => 'Ningún plugin que haya sido configurado ha sido instalado.',

## tmpl/cms/list_blog.tmpl
	'You have successfully deleted the blogs from the Movable Type system.' => 'Eliminó correctamente los weblogs.',
	'Create Blog' => 'Crear blog',
	'Are you sure you want to delete this blog?' => '¿Está seguro de que desea borrar este blog?',

## tmpl/cms/edit_template.tmpl
	'Create Template' => 'Crear plantilla',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]">Recover auto-saved content</a>' => 'Se auto-guardó [_2] una versión guardada de [_1]. <a href="[_2]">Recuperar contenido auto-guardado</a>',
	'You have successfully recovered your saved [_1].' => 'Recuperó con éxito la versión guardada de [_1].',
	'An error occurred while trying to recover your saved [_1].' => 'Ocurrió un error intentando recuperar la versión guardada de [_1].',
	'Your template changes have been saved.' => 'Se guardaron sus cambios en las plantillas.',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => '<a href="[_1]" class="rebuild-link">Publicar</a> esta plantilla.',
	'Useful Links' => 'Enlaces útiles',
	'List [_1] templates' => 'Listar plantillas [_1]',
	'Template tag reference' => 'Referencia de las etiquetas de plantillas',
	'Includes and Widgets' => 'Inclusiones y Widgets',
	'create' => 'crear',
	'Tag Documentation' => 'Documentación sobre las etiquetas',
	'http://www.movabletype.org/documentation/appendices/tags/' => 'http://www.movabletype.org/documentation/appendices/tags/',
	'Unrecognized Tags' => 'Etiquetas no reconocidas',
	'Save (s)' => 'Guardar (s)',
	'Save and Publish this template (r)' => 'Guardar y publicar esta plantilla (r)',
	'Save &amp; Publish' => 'Guardar &amp; Publicar',
	'You have unsaved changes to this template that will be lost.' => 'Esta plantilla tiene cambios no guardados que se perderán.', # Translate - New
	'You must set the Template Name.' => 'Debe indicar el nombre de la plantilla.',
	'You must set the template Output File.' => 'Debe indicar el fichero de salida de la plantilla.',
	'Please wait...' => 'Por favor, espere...',
	'Error occurred while updating archive maps.' => 'Ocurrió un error durante la actualización de los mapas de archivos.',
	'Archive map has been successfully updated.' => 'Se actualizó con éxito el mapa de archivos.',
	'Are you sure you want to remove this template map?' => '¿Está seguro que desea borrar este mapa de plantilla?',
	'Module Body' => 'Cuerpo del módulo',
	'Template Body' => 'Cuerpo de la plantilla',
	'Syntax Highlight On' => 'Coloreado de sintaxis activado.',
	'Syntax Highlight Off' => 'Coloreado de sintaxis desactivado',
	'Insert...' => 'Insertar...',
	'Template Type' => 'Tipo de plantilla',
	'Custom Index Template' => 'Plantilla índice personalizada',
	'Publish Options' => 'Opciones de publicación',
	'Enable dynamic publishing for this template' => 'Activar la publicación dinámica de esta plantilla',
	'Publish this template automatically when rebuilding index templates' => 'Publicar automáticamente esta plantilla al reconstruir las plantillas índices',
	'Link to File' => 'Enlazar a archivo',
	'Create Archive Mapping' => 'Crear mapeado de archivos',
	'Add' => 'Crear',
	'Auto-saving...' => 'Autoguardado...',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Último autoguardado a las [_1]:[_2]:[_3]',

## tmpl/cms/dashboard.tmpl
	'Select a Widget...' => 'Seleccione un Widget...',
	'Your Dashboard has been updated.' => 'Se ha actualizado la Pizarra.',
	'You have attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'Ha intentado usar una característica para la que no tiene permisos. Si cree que está viendo este mensaje por error, contacte con sus administrador del sistema.',
	'The directory you have configured for uploading avatars is not writable. In order to enable users to upload userpics, please make the following directory writable by your web server: [_1]' => 'No se puede escribir en el directorio configurado para subir los avatares. Para permitir a los usuarios que suban sus avatares, por favor, asegúrese de que el servidor web puede escribir en el siguiente directorio: [_1]',
	'Your dashboard is empty!' => '¡Su pizarra está vacía!',

## tmpl/cms/cfg_trackbacks.tmpl
	'TrackBack Settings' => 'Configuración de TrackBack',
	'Your TrackBack preferences have been saved.' => 'Se han guardado las preferencias de TrackBack.',
	'Note: TrackBacks are currently disabled at the system level.' => 'Nota: Actualmente, los TrackBacks están desactivados a nivel del sistema.',
	'Accept TrackBacks' => 'Aceptar TrackBacks',
	'If enabled, TrackBacks will be accepted from any source.' => 'Si está activado, se aceptarán TrackBacks desde cualquier sitio.',
	'TrackBack Policy' => 'Política de TrackBack',
	'Moderation' => 'Moderación',
	'Hold all TrackBacks for approval before they\'re published.' => 'Retener todos los TrackBacks para su aprobación.',
	'Apply \'nofollow\' to URLs' => 'Aplicar \'nofollow\' a las URLs',
	'This preference affects both comments and TrackBacks.' => 'Esta opción afecta tanto a los comentarios como a los TrackBacks.',
	'If enabled, all URLs in comments and TrackBacks will be assigned a \'nofollow\' link relation.' => 'Si se activa, se asignará una relación \'nofollow\' en los enlaces.',
	'E-mail Notification' => 'Notificación por correo-e',
	'Specify when Movable Type should notify you of new TrackBacks if at all.' => 'Especifica cuándo Movable Type debe notificarle nuevos TrackBacks, .',
	'On' => 'Activar',
	'Only when attention is required' => 'Solo cuando la atención es requerida',
	'Off' => 'Desactivar',
	'TrackBack Options' => 'Opciones de TrackBack',
	'TrackBack Auto-Discovery' => 'Autodescubrimiento de TrackBacks',
	'If you turn on auto-discovery, when you write a new entry, any external links will be extracted and the appropriate sites automatically sent TrackBacks.' => 'Si activa el auto-descrubrimiento, al escribir una nueva entrada, se extraerán los enlaces externos y se enviarán TrackBacks automáticamente a los sitios que lo soporten.',
	'Enable External TrackBack Auto-Discovery' => 'Habilitar autodescubrimiento de TrackBacks externos',
	'Setting Notice' => 'Alerta sobre configuración',
	'Note: The above option may be affected since outbound pings are constrained system-wide.' => 'Nota: La opción de arriba podría verse afectada debido a que los pings salientes están restringidos a nivel del sistema.',
	'Setting Ignored' => 'Opción ignorada',
	'Note: The above option is currently ignored since outbound pings are disabled system-wide.' => 'Nota: La configuración de arriba se ignora actualmente debido a que los pings salientes están desactivados a nivel del sistema.',
	'Enable Internal TrackBack Auto-Discovery' => 'Habilitar autodescubrimiento de TrackBacks internos',
	'Save changes to these settings (s)' => 'Guardar cambios de estas opciones (s)', # Translate - New

## tmpl/cms/list_entry.tmpl
	'Entries Feed' => 'Sindicación de las entradas', # Translate - New
	'Pages Feed' => 'Sindicación de las páginas', # Translate - New
	'The entry has been deleted from the database.' => 'La entrada ha sido borrada de la base de datos.', # Translate - New
	'The page has been deleted from the database.' => 'La página ha sido borrada de la base de datos.', # Translate - New
	'Quickfilters' => 'Filtros rápidos',
	'[_1] (Disabled)' => '[_1] (Desactivado)',
	'Go back' => 'Ir atrás',
	'Showing only: [_1]' => 'Mostrando solo: [_1]',
	'Remove filter' => 'Borrar filtro',
	'All [_1]' => 'Todos los [_1]',
	'change' => 'cambiar',
	'[_1] where [_2] is [_3]' => '[_1] donde [_2] es [_3]',
	'Show only entries where' => 'Mostrar solo las entradas donde', # Translate - New
	'Show only pages where' => 'Mostrar solo las páginas donde', # Translate - New
	'status' => 'estado',
	'tag (exact match)' => 'etiqueta (coincidencia exacta)',
	'tag (fuzzy match)' => 'etiqueta (coincidencia difusa)',
	'is' => 'es',
	'published' => 'publicado',
	'unpublished' => 'no publicado',
	'scheduled' => 'programado',
	'Select An Asset:' => 'Seleccionar un fichero multimedia:', # Translate - New
	'Asset Search...' => 'Buscar fichero multimedia...', # Translate - New
	'Recent Assets...' => 'Ficheros multimedia recientes...', # Translate - New
	'Select A User:' => 'Seleccionar un usuario:',
	'User Search...' => 'Buscar usuario...',
	'Recent Users...' => 'Usuarios recientes...',
	'Filter' => 'Filtro',

## tmpl/cms/edit_commenter.tmpl
	'The commenter has been trusted.' => 'El comentarista ahora es de confianza.',
	'The commenter has been banned.' => 'Se bloqueó al comentarista.',
	'Comments from [_1]' => 'Comentarios de [_1]',
	'commenter' => 'comentarista',
	'commenters' => 'comentaristas',
	'Trust user (t)' => 'Confiar en usuario (t)', # Translate - New
	'Trust' => 'Confianza',
	'Untrust user (t)' => 'Desconfiar del usuario (t)', # Translate - New
	'Untrust' => 'Desconfiar',
	'Ban user (b)' => 'Bloquear usuario (b)', # Translate - New
	'Ban' => 'Bloquear',
	'Unban user (b)' => 'Desbloquear usuario (b)', # Translate - New
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

## tmpl/cms/cfg_system_general.tmpl
	'System: General Settings' => 'Sistema: Configuración general',
	'Your settings have been saved.' => 'Configuración guardada.',
	'(No blog selected)' => '(Ningún blog seleccionado)',
	'Select blog' => 'Seleccione blog',
	'You must set a valid Default Site URL.' => 'Debe introducir una URL predefinida de sitio válida.',
	'You must set a valid Default Site Root.' => 'Debe introducir una ruta raíz predefinida de sitio válida.',
	'System Email' => 'Correo del sistema',
	'The email address used in the From: header of each email sent from the system.  The address is used in password recovery, commenter registration, comment, trackback notification and a few other minor events.' => 'La dirección de correo usada en el cabecera From: (remitente) de los mensajes enviados por el sistema. La dirección se usa en la recuperación de contraseña, en el registro de comentaristas, comentarios, notificaciones de TrackBack y otros eventos menores.',

## tmpl/cms/list_member.tmpl
	'Manage Users' => 'Administrar usuarios',
	'Are you sure you want to remove this role?' => '¿Está seguro de querer borrar este rol?',
	'Add a user to this blog' => 'Añadir un usuario a este blog',
	'Show only users where' => 'Mostrar solo los usuarios donde', # Translate - New
	'role' => 'rol',
	'enabled' => 'habilitado',
	'disabled' => 'deshabilitado',
	'pending' => 'Pendiente',

## tmpl/cms/cfg_comments.tmpl
	'Comment Settings' => 'Configuración de comentarios',
	'Your preferences have been saved.' => 'Se han guardado las preferencias.',
	'Note: Commenting is currently disabled at the system level.' => 'Nota: Los comentarios están actualmente desactivados a nivel de sistema.',
	'Comment authentication is not available because one of the needed modules, MIME::Base64 or LWP::UserAgent is not installed. Talk to your host about getting this module installed.' => 'La autentificación de comentarios no está disponible porque uno de los módulos necesarios, MIME::Base64 o LWP::UserAgent no está instalado. Consulte con su alojamiento.',
	'Accept Comments' => 'Aceptar comentarios',
	'If enabled, comments will be accepted.' => 'Si está activado, se aceptarán los comentarios.',
	'Commenting Policy' => 'Política de comentarios',
	'Immediately approve comments from' => 'Aceptar inmediatamente los comentarios de',
	'Specify what should happen to comments after submission. Unapproved comments are held for moderation.' => 'Especifique qué ocurrirá con los comentarios después de su envío. Los comentarios no aprobados se retienen a la espera de su moderación.',
	'No one' => 'Nadie',
	'Trusted commenters only' => 'Solo comentaristas confiados',
	'Any authenticated commenters' => 'Solo comentaristas autentificados',
	'Anyone' => 'Cualquiera',
	'Allow HTML' => 'Permitir HTML',
	'If enabled, users will be able to enter a limited set of HTML in their comments. If not, all HTML will be stripped out.' => 'Si está activado, los usuarios podrán introducir un conjunto limitado de etiquetas HTML en sus comentarios. De lo contrario, se filtra todo el HTML.',
	'Limit HTML Tags' => 'Limitar etiquetas HTML',
	'Specifies the list of HTML tags allowed by default when cleaning an HTML string (a comment, for example).' => 'Especifica la lista etiquetas HTML que se permiten por defecto en la limpieza de una cadena HTML (un comentario, por ejemplo).',
	'Use defaults' => 'Utilizar valores predeterminados',
	'([_1])' => '([_1])',
	'Use my settings' => 'Utilizar mis preferencias',
	'Disable \'nofollow\' for trusted commenters' => 'Desactivar \'nofollow\' en los comentaristas de confianza.',
	'If enabled, the \'nofollow\' link relation will not be applied to any comments left by trusted commenters.' => 'Si está activado, la relación \'nofollow\' de los enlaces no se aplicará a ningún comentario dejado por comentaristas de confianza.',
	'Specify when Movable Type should notify you of new comments if at all.' => 'Especifica cuándo Movable Type debe notificarle de nuevos comentarios, cuando haya.',
	'Comment Display Options' => 'Opciones de visualización de comentarios',
	'Comment Order' => 'Orden de los comentarios',
	'Select whether you want visitor comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Seleccione si desea que los comentarios de visitantes se muestren en orden ascendente (el más antiguo arriba) o descendente (el más reciente arriba).',
	'Ascending' => 'Ascendente',
	'Descending' => 'Descendente',
	'Auto-Link URLs' => 'Autoenlazar direcciones URL',
	'If enabled, all non-linked URLs will be transformed into links to that URL.' => 'Si está activado, todas las URLs no enlazadas se transformarán en enlaces a esa URL.',
	'Text Formatting' => 'Formato del texto',
	'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Opción que especifica el formato de texto a utilizar para formatear los comentarios de los visitantes.',
	'CAPTCHA Provider' => 'Proveedor de CAPTCHA',
	'none' => 'ninguno',
	'No CAPTCHA provider available' => 'No hay disponible ningún proveedor de CAPTCHA.',
	'No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed, and CaptchaSourceImageBase directive points to captcha-source directory under mt-static/images.' => 'No hay disponible ningún proveedor de CAPTCHA en este sistema. Por favor, compruebe que Image::Magick está instalado, y que la directiva CaptchaSourceImageBase apunta al directorio de origen de captchas bajo mt-static/images.',
	'Use Comment Confirmation Page' => 'Usar página de confirmación de comentarios',
	'Use comment confirmation page' => 'Usar página de confirmación de comentarios',

## tmpl/cms/backup.tmpl
	'What to backup' => 'Qué copiar',
	'This option will backup Users, Roles, Associations, Blogs, Entries, Categories, Templates and Tags.' => 'Esta opción hará copias de seguridad de los Usuarios, Roles, Asociaciones, Blogs, Entradas, Categorías, Plantillas y Etiquetas.',
	'Everything' => 'Todo',
	'Choose blogs...' => 'Eliga un blog...',
	'Archive Format' => 'Formato de archivo',
	'The type of archive format to use.' => 'El tipo de formato de archivo a usar.',
	'Don\'t compress' => 'No comprimir',
	'Target File Size' => 'Tamaño del fichero',
	'Approximate file size per backup file.' => 'Tamaño de fichero aproximado para cada fichero de la copia de seguridad.',
	'Don\'t Divide' => 'No dividir',
	'Make Backup (b)' => 'Hacer copia (b)',
	'Make Backup' => 'Hacer copia',

## tmpl/cms/edit_entry.tmpl
	'Create Page' => 'Crear página', # Translate - New
	'Add folder' => 'Añadir carpeta', # Translate - New
	'Add folder name' => 'Añadir nombre de carpeta', # Translate - New
	'Add new folder parent' => 'Añadir nueva carpeta raíz', # Translate - New
	'Save this page (s)' => 'Guardar esta página (s)', # Translate - New
	'Preview this page (v)' => 'Vista previa de la página (v)', # Translate - New
	'Delete this page (x)' => 'Borrar esta página (x)', # Translate - New
	'Add category' => 'Añadir categoría', # Translate - New
	'Add category name' => 'Añadir nombre de categoría', # Translate - New
	'Add new category parent' => 'Añadir categoría raíz', # Translate - New
	'Save this entry (s)' => 'Guardar esta entrada (s)', # Translate - New
	'Preview this entry (v)' => 'Vista previa de la entrada (v)', # Translate - New
	'Delete this entry (x)' => 'Borrar esta entrada (x)', # Translate - New
	'A saved version of this entry was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Se guardó automáticamente una versión de esta entrada [_2]. <a href="[_1]">Recuperar el contenido guardado</a>', # Translate - New
	'A saved version of this page was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Se guardó automáticamente una versión de esta página [_2]. <a href="[_1]">Recuperar el contenido guardado</a>', # Translate - New
	'This entry has been saved.' => 'Se guardó esta entrada.', # Translate - New
	'This page has been saved.' => 'Se guardó esta página.', # Translate - New
	'One or more errors occurred when sending update pings or TrackBacks.' => 'Ocurrieron uno o más errores durante el envío de pings o TrackBacks.',
	'_USAGE_VIEW_LOG' => 'Compruebe el error en el <a href="[_1]">Registro de actividad</a>.',
	'Your customization preferences have been saved, and are visible in the form below.' => 'Se guardaron los cambios en las preferencias y pueden verse en el siguiente formulario.',
	'Your changes to the comment have been saved.' => 'Se guardaron sus cambios al comentario.',
	'Your notification has been sent.' => 'Se envió su notificación.',
	'You have successfully recovered your saved entry.' => 'Ha recuperado con éxito la entrada guardada.', # Translate - New
	'You have successfully recovered your saved page.' => 'Ha recuperado con éxito la página guardada.', # Translate - New
	'An error occurred while trying to recover your saved entry.' => 'Ocurrió un error durante la recuperación de la entrada guardada.', # Translate - New
	'An error occurred while trying to recover your saved page.' => 'Ocurrió un error durante la recuperación de la página guardada.', # Translate - New
	'You have successfully deleted the checked comment(s).' => 'Eliminó correctamente los comentarios marcados.',
	'You have successfully deleted the checked TrackBack(s).' => 'Eliminó correctamente los TrackBacks marcados.',
	'Stats' => 'Estadísticas', # Translate - New
	'Share' => 'Compartir', # Translate - New
	'<a href="[_2]">[quant,_1,comment,comments]</a>' => '<a href="[_2]">[quant,_1,comentario,comentarios]</a>', # Translate - New
	'<a href="[_2]">[quant,_1,trackback,trackbacks]</a>' => '<a href="[_2]">[quant,_1,trackback,trackbacks]</a>', # Translate - New
	'Unpublished' => 'No publicado',
	'You must configure this blog before you can publish this entry.' => 'Debe configurar el blog antes de poder publicar esta entrada.', # Translate - New
	'You must configure this blog before you can publish this page.' => 'Debe configurar el blog antes de poder publicar esta página.', # Translate - New
	'[_1] - Created by [_2]' => '[_1] - Creado por [_2]', # Translate - New
	'[_1] - Published by [_2]' => '[_1] - Publicado por [_2]', # Translate - New
	'[_1] - Edited by [_2]' => '[_1] - Editado por [_2]', # Translate - New
	'Publish On' => 'Publicado el',
	'Publish Date' => 'Fecha de publicación',
	'Select entry date' => 'Seleccionar fecha de la entrada',
	'Unlock this entry&rsquo;s output filename for editing' => 'Desbloquear el nombre del fichero de salida de la entrada para su edición',
	'Warning: If you set the basename manually, it may conflict with another entry.' => 'Atención: Si introduce el nombre base manualmente, podría entrar en conflicto con otra entrada.',
	'Warning: Changing this entry\'s basename may break inbound links.' => 'Atención: Si cambia el nombre base de la entrada, podría romper enlaces entrantes.',
	'Accept' => 'Aceptar',
	'Outbound TrackBack URLs' => 'URLs de TrackBacks salientes',
	'View Previously Sent TrackBacks' => 'Ver TrackBacks enviados anteriormente',
	'You have unsaved changes to this entry that will be lost.' => 'Posee cambios no guardados en esta entrada que se perderán.', # Translate - New
	'You have unsaved changes to this page that will be lost.' => 'Posee cambios no guardados en esta página que se perderán.', # Translate - New
	'Enter the link address:' => 'Introduzca la dirección del enlace:',
	'Enter the text to link to:' => 'Introduzca el texto del enlace:',
	'Your entry screen preferences have been saved.' => 'Se guardaron las nuevas preferencias del editor de entradas.',
	'Your entry screen preferences have been saved. Please refresh the page to reorder the custom fields.' => 'Se han guardado las preferencias de la pantalla de edición. Por favor, recargue la página para reordenar los campos personalizados.',
	'Are you sure you want to use the Rich Text editor?' => '¿Está seguro de que desea usar el editor con formato?',
	'Make primary' => 'Hacer primario',
	'Add new' => 'Añadir nuevo',
	'Fields' => 'Campos',
	'Body' => 'Cuerpo',
	'Reset display options' => 'Reiniciar opciones de visualización',
	'Reset display options to blog defaults' => 'Reiniciar opciones de visualización con los valores predefinidos del blog',
	'Reset defaults' => 'Reiniciar valores predefinidos',
	'Previous' => 'Anterior',
	'Next' => 'Siguiente',
	'Extended' => 'Extendido',
	'Format:' => 'Formato:',
	'(comma-delimited list)' => '(lista separada por comas)',
	'(space-delimited list)' => '(lista separada por espacios)',
	'(delimited by \'[_1]\')' => '(separado por \'[_1]\')',
	'<a href="[_1]">QuickPost to [_2]</a> - Drag this link to your browser\'s toolbar then click it when you are on a site you want to blog about.' => '<a href="[_1]">QuickPost en [_2]</a> - Arrastre este enlace a la barra de herramientas de su navegador y luego haga clic en él cuando visite una página sobre la que quiera escribir.', # Translate - New
	'None selected' => 'Ninguna seleccionada',

## tmpl/cms/view_log.tmpl
	'The activity log has been reset.' => 'Se reinició el registro de actividad.',
	'All times are displayed in GMT[_1].' => 'Todas las horas se muestran en GMT[_1].',
	'All times are displayed in GMT.' => 'Todas las fechas se muestran en GMT.',
	'Show only errors' => 'Mostrar solo los errores',
	'System Activity Log' => 'Registro de Actividad del Sistema',
	'Filtered' => 'Filtrado',
	'Filtered Activity Feed' => 'Fuente de actividad filtrada',
	'Download Filtered Log (CSV)' => 'Descargar registro filtrado (CSV)',
	'Download Log (CSV)' => 'Descargar registro (CSV)',
	'Clear Activity Log' => 'Crear histórico de actividad',
	'Are you sure you want to reset the activity log?' => '¿Está seguro de querer reiniciar el registro de actividad?',
	'Showing all log records' => 'Mostrando todos los registros',
	'Showing log records where' => 'Mostrando los registros donde',
	'Show log records where' => 'Mostrar registros donde',
	'level' => 'nivel',
	'classification' => 'clasificación',
	'Security' => 'Seguridad',
	'Error' => 'Error',
	'Information' => 'Información',
	'Debug' => 'Depuración',
	'Security or error' => 'Seguridad o error',
	'Security/error/warning' => 'Seguridad/error/alarma',
	'Not debug' => 'No depuración',
	'Debug/error' => 'Depuración/error',

## tmpl/cms/setup_initial_blog.tmpl
	'Create Your First Blog' => 'Cree su primer blog',
	'The blog name is required.' => 'El nombre del blog es obligatorio.',
	'The blog URL is required.' => 'La URL del blog es obligatoria.',
	'The publishing path is required.' => 'La ruta de publicación es obligatoria.',
	'The timezone is required.' => 'La zona horaria es obligatoria.',
	'Template Set' => 'Conjunto de plantillas',
	'Select the templates you wish to use for this new blog.' => 'Seleccione las plantillas que desea usar en este blog.',
	'Timezone' => 'Zona horaria',
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
	'Finish install (s)' => 'Finalizar la instalación (s)',
	'Finish install' => 'Finalizar instalación',
	'Back (x)' => 'Volver (x)',

## tmpl/cms/refresh_results.tmpl
	'Template Refresh' => 'Refrescar plantilla', # Translate - New
	'No templates were selected to process.' => 'No se han seleccionado plantillas para procesar.',
	'Return to templates' => 'Volver a las plantillas',

## tmpl/cms/cfg_spam.tmpl
	'Spam Settings' => 'Configuración del spam',
	'Your spam preferences have been saved.' => 'Se han guardado sus preferencias del spam.',
	'Auto-Delete Spam' => 'Autoborrar el spam',
	'If enabled, feedback reported as spam will be automatically erased after a number of days.' => 'Si la activa, las respuestas marcadas como spam se borrarán automáticamente después de un número de días.',
	'Delete Spam After' => 'Borrar spam después',
	'When an item has been reported as spam for this many days, it is automatically deleted.' => 'Cuando un elemento haya estado marcado como spam durante esta cantidad de días, será borrado automáticamente.',
	'days' => 'días',
	'Spam Score Threshold' => 'Puntuación límite de spam',
	'Comments and TrackBacks receive a spam score between -10 (complete spam) and +10 (not spam). Feedback with a score which is lower than the threshold shown above will be reported as spam.' => 'Los comentarios y TrackBacks se puntúan como spam con valores entre -10 (spam total) y +10 (no spam). Las respuestas con una puntuación que sea menor del límite mostrado arriba, se marcarán como spam.',
	'Less Aggressive' => 'Menos agresivo',
	'Decrease' => 'Disminuir',
	'Increase' => 'Aumentar',
	'More Aggressive' => 'Más agresivo',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Editar carpeta',
	'Your folder changes have been made.' => 'Se han realizado los cambios en la carpeta.',
	'You must specify a label for the folder.' => 'Debe especificar una etiqueta para la carpeta.',
	'Save changes to this folder (s)' => 'Guardar cambios de esta carpeta (s)', # Translate - New

## tmpl/cms/list_notification.tmpl
	'You have added [_1] to your address book.' => 'Ha añadido [_1] a su agenda de direcciones.',
	'You have successfully deleted the selected contacts from your address book.' => 'Ha borrado con éxito los contactos seleccionados de su agenda.',
	'Download Address Book (CSV)' => 'Descargar agenda de direcciones (CSV)',
	'contact' => 'contacto',
	'contacts' => 'contactos',
	'Create Contact' => 'Crear contacto',
	'Website URL' => 'URL del sitio',
	'Add Contact' => 'Añadir contacto',

## tmpl/cms/export.tmpl
	'You must select a blog to export.' => 'Debe seleccionar un blog para la exportación.',
	'_USAGE_EXPORT_1' => 'Exporta las entradas, comentarios y TrackBacks de un blog. La exportación no puede considerarse como una copia de seguridad <em>completa</em> del blog.',
	'Blog to Export' => 'Blog a exportar',
	'Select a blog for exporting.' => 'Seleccionar un blog para la exportación.',
	'Change blog' => 'Cambiar blog',
	'Export Blog (s)' => 'Exportar blog (s)',
	'Export Blog' => 'Exportar blog',

## tmpl/cms/edit_category.tmpl
	'Edit Category' => 'Editar categoría',
	'Your category changes have been made.' => 'Los cambios en la categoría se han guardado.',
	'You must specify a label for the category.' => 'Debe especificar un título para la categoría.',
	'_CATEGORY_BASENAME' => 'Nombre base',
	'This is the basename assigned to your category.' => 'El nombre base asignado a la categoría.',
	'Unlock this category&rsquo;s output filename for editing' => 'Desbloquear el nombre del fichero de saluda de la categoría para su edición',
	'Warning: Changing this category\'s basename may break inbound links.' => 'Cuidado: Cambiar el nombre base de la categoría podría romper los enlaces entrantes.',
	'Inbound TrackBacks' => 'TrackBacks entradas',
	'Accept Trackbacks' => 'Aceptar TrackBacks',
	'If enabled, TrackBacks will be accepted for this category from any source.' => 'Si se habilita, en esta categoría se aceptarán los TrackBacks de cualquier fuente.',
	'View TrackBacks' => 'Ver TrackBacks',
	'TrackBack URL for this category' => 'URL de TrackBack para esta categoría',
	'_USAGE_CATEGORY_PING_URL' => 'Esta es la URL que usuarán otros para enviar TrackBacks a su weblog. Si desea que cualquiera envíe TrackBacks a su weblog cuando escriban una entrada sobre esta categoría, haga pública esta URL. Si desea que sólo un grupo selecto de personas le hagan TrackBack, envíeles la URL de forma privada. Para incluir una lista de TrackBacks en la plantilla índice principal, compruebe la documentación de las etiquetas de plantilla relacionadas con los TrackBacks.',
	'Passphrase Protection' => 'Protección por contraseña',
	'Optional' => 'Opcional',
	'Outbound TrackBacks' => 'TrackBacks salientes',
	'Trackback URLs' => 'URLs de Trackback',
	'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you create an entry in this category. (Separate URLs with a carriage return.)' => 'Introduzca las URLs de los webs  a los que quiere enviar un TrackBack cada vez que cree una entrada en esta categoría. (Separe las URLs con un retorno de carro).',
	'Save changes to this category (s)' => 'Guardar cambios de esta categoría (s)', # Translate - New

## tmpl/cms/list_banlist.tmpl
	'IP Banning Settings' => 'Bloqueo de IPs',
	'IP addresses' => 'Direcciones IP',
	'Delete selected IP Address (x)' => 'Borrar la dirección IP seleccionada (x)',
	'You have added [_1] to your list of banned IP addresses.' => 'Agregó [_1] a su lista de direcciones IP bloqueadas.',
	'You have successfully deleted the selected IP addresses from the list.' => 'Eliminó correctamente las direcciones IP seleccionadas.',
	'Ban IP Address' => 'Bloquear la dirección IP',
	'Date Banned' => 'Fecha de bloqueo',

## tmpl/cms/list_ping.tmpl
	'Manage Trackbacks' => 'Administrar TrackBacks',
	'The selected TrackBack(s) has been approved.' => 'Se han aprobado los TrackBacks seleccionados.',
	'All TrackBacks reported as spam have been removed.' => 'Se han elimitado todos los TrackBacks marcadoscomo spam.',
	'The selected TrackBack(s) has been unapproved.' => 'Se han desaprobado los TrackBacks seleccionados.',
	'The selected TrackBack(s) has been reported as spam.' => 'Se han marcado como spam los TrackBacks seleccionados.',
	'The selected TrackBack(s) has been recovered from spam.' => 'Se han recuperado del spam los TrackBacks seleccionados.',
	'The selected TrackBack(s) has been deleted from the database.' => 'Se eliminaron de la base de datos los TrackBacks seleccionados.',
	'No TrackBacks appeared to be spam.' => 'Ningún TrackBacks parece ser spam.',
	'Show only [_1] where' => 'Mostrar solo [_1] donde', # Translate - New
	'approved' => 'autorizado',
	'unapproved' => 'no aprobado',

## tmpl/cms/error.tmpl
	'An error occurred' => 'Ocurrió un error',

## tmpl/cms/list_role.tmpl
	'Roles: System-wide' => 'Roles: Todo el sistema',
	'You have successfully deleted the role(s).' => 'Ha borrado con éxito el/los rol/es.',
	'roles' => 'roles',
	'_USER_STATUS_CAPTION' => 'estado',
	'Members' => 'Miembros',
	'Role Is Active' => 'Rol activo',
	'Role Not Being Used' => 'Rol en desuso',

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
	'[_1] where [_2] [_3]' => '[_1] donde [_2] [_3]',

## tmpl/cms/cfg_web_services.tmpl
	'Web Services Settings' => 'Configuración de los servicios web',
	'Your blog preferences have been saved.' => 'Las preferencias de su weblog han sido guardadas.',
	'Six Apart Services' => 'Servicios de Six Apart',
	'Your TypeKey token is used to access Six Apart services like its free Authentication service.' => 'El token de TypeKey utilizado para acceder a servicios de Six Apart como su servicio gratuito de autentificación.',
	'TypeKey is enabled.' => 'TypeKey está activado.',
	'TypeKey token:' => 'Token de TypeKey',
	'Clear TypeKey Token' => 'Borrar token de TypeKey',
	'Please click the Save Changes button below to disable authentication.' => 'Por favor, haga clic en el botón Guardar cambios para desactivar la autentificación.',
	'TypeKey is not enabled.' => 'TypeKey no está activado.',
	'or' => 'o',
	'Obtain TypeKey token' => 'Obtener token de TypeKey',
	'Please click the Save Changes button below to enable TypeKey.' => 'Por favor, haga clic en el botón Guardar cambios para activar TypeKey.',
	'External Notifications' => 'Notificaciones externas',
	'Notify of blog updates' => 'Notificación de actualizaciones',
	'When this blog is updated, Movable Type will automatically notify the selected sites.' => 'Cuando se actualice el blog, Movable Type notificará automáticamente a los sitios seleccionados.',
	'Note: This option is currently ignored since outbound notification pings are disabled system-wide.' => 'Nota: Actualmente, esta opción se ignora ya que los pings de notificación están desactivadas en todo el sistema.',
	'Others:' => 'Otros:',
	'(Separate URLs with a carriage return.)' => '(Separe las URLs con un retorno de carro.)',
	'Recently Updated Key' => 'Clave actualizada recientemente',
	'If you have received a recently updated key (by virtue of your purchase), enter it here.' => 'Si recientemente ha recibido una clave actualizada (tras una compra), tecléela aquí.',

## tmpl/cms/list_template.tmpl
	'Blog Templates' => 'Plantillas del blog',
	'Blog Publishing Settings' => 'Configuración de la publicación del blog',
	'All Templates' => 'Todas las plantillas', # Translate - New
	'You have successfully deleted the checked template(s).' => 'Se eliminaron correctamente las plantillas marcadas.',
	'You have successfully refreshed your templates.' => 'Ha refrescado con éxito las plantillas.', # Translate - New
	'Your templates have been published.' => 'Se han publicado las plantillas.', # Translate - New
	'Create Archive Template:' => 'Crear plantilla de archivos',
	'Create [_1] template' => 'Crear nuevo módulo de [_1]',

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
	'[quant,_1,_2,_3]' => '[quant,_1,_2,_3]', # Translate - New
	'[quant,_1,entry,entries]' => '[quant,_1,entrada,entradas]',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all blogs?' => 'La etiqueta \'[_2]\' ya existe.  ¿Está seguro de querer combinar \'[_1]\' con \'[_2]\' en todos los blogs?',
	'An error occurred while testing for the new tag name.' => 'Ocurrió un error mientras se probaba el nuevo nombre de la etiqueta.',

## tmpl/cms/install.tmpl
	'Create Your Account' => 'Crear Cuenta',
	'The initial account name is required.' => 'Se necesita el nombre de la cuenta inicial.',
	'Password recovery word/phrase is required.' => 'Se necesita la palabra/frase de recuperación de contraseña.',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'La versión de Perl instalada en su servidor ([_1]) es menor que la versión mínima soporta ([_2]).',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Aunque Movable Type podría ejecutarse, <strong>esta configuración no está probada ni ni soportada</strong>.  Le recomendamos que actualice Perl a la versión [_1].',
	'Do you want to proceed with the installation anyway?' => '¿Aún así desea proceder con la instalación?',
	'View MT-Check (x)' => 'Ver MT-Check (x)',
	'Before you can begin blogging, you must create an administrator account for your system. When you are done, Movable Type will then initialize your database.' => 'Antes de poder comenzar a publicar, debe crear una cuenta de administrador para el sistema. Cuando lo haya hecho, Movable Type inicializará la base de datos.',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Para proceder, debe autentificarse correctamente en su servidor LDAP.',
	'The name used by this user to login.' => 'El nombre utilizado por este usario para iniciar su sesión.',
	'The name used when published.' => 'El nombre utilizado al publicar.',
	'The user&rsquo;s email address.' => 'La dirección de correo electrónico del usuario',
	'Language' => 'Idioma',
	'The user&rsquo;s preferred language.' => 'El idioma preferido del usuario.',
	'Select a password for your account.' => 'Seleccione una contraseña para su cuenta.',
	'Password Confirm' => 'Confirmar contraseña',
	'Repeat the password for confirmation.' => 'Repita la contraseña para confirmación.',
	'This word or phrase will be required to recover your password if you forget it.' => 'Esta palabra o frase será necesaria para recuperar su contraseña en caso de olvido.',
	'Your LDAP username.' => 'Su usuario en el servidor LDAP.',
	'Enter your LDAP password.' => 'Su contraseña en el servidor LDAP.',

## tmpl/cms/cfg_system_feedback.tmpl
	'System: Feedback Settings' => 'Sistema: Configuración de respuestas',
	'Your feedback preferences have been saved.' => 'Se guardaron las preferencias de las respuestas.',
	'Feedback: Master Switch' => 'Respuestas: Control maestro',
	'This will override all individual blog settings.' => 'Esto va borrar los parámetros de todos los blogs individuales',
	'Disable comments for all blogs' => 'Deshabilitar los comentarios en todos los blogs',
	'Disable TrackBacks for all blogs' => 'Deshabilitar los TrackBacks en todos los blogs',
	'Outbound Notifications' => 'Notificaciones salientes',
	'Notification pings' => 'Pings de notificación',
	'This feature allows you to disable sending notification pings when a new entry is created.' => 'Esta acaracterística le permite deshabilitar el envío de pings que notifican la creación de nuevas entradas.',
	'Disable notification pings for all blogs' => 'Deshabilitar los pings de notificación en todos los blogs',
	'Limit outbound TrackBacks and TrackBack auto-discovery for the purposes of keeping your installation private.' => 'Limitar los TrackBacks salientes y el autodescubrimiento de TrackBacks con el propósito de mantener la privacidad de la instalación.',
	'Allow to any site' => 'Autorizar todos los sitios',
	'(No outbound TrackBacks)' => '(Ningún Trackback saliente)',
	'Only allow to blogs on this installation' => 'Autorizar solamente en los blogs de esta instalación',
	'Only allow the sites on the following domains:' => 'Autorizar solamente los sitios en los siguientos dominios',

## tmpl/cms/edit_author.tmpl
	'Edit Profile' => 'Editar Perfil',
	'This profile has been updated.' => 'Este perfil ha sido actualizado.',
	'A new password has been generated and sent to the email address [_1].' => 'Se ha generado y enviado a la dirección de correo electrónico [_1] una nueva contraseña.',
	'Your Web services password is currently' => 'La contraseña de los servicios web es actualmente',
	'_WARNING_PASSWORD_RESET_SINGLE' => 'Va a reiniciar la contraseña de "[_1]". Se enviará una nueva contraseña aleatoria que se enviará directamente a su dirección de correo electrónico ([_2]). ¿Desea continuar?',
	'Error occurred while removing userpic.' => 'Ocurrió un error durante la eliminación del avatar.', # Translate - New
	'Status of user in the system. Disabling a user removes their access to the system but preserves their content and history.' => 'Estado del usuario en el sistema. Al deshabilitar el usuario, se impide su acceso al sistema pero se preservan sus contenidos e históricos.',
	'_USER_PENDING' => 'Pendiente',
	'The username used to login.' => 'El nombre de usuario utilizado para la identificación en el sistema.',
	'External user ID' => 'Usuario externo ID',
	'The email address associated with this user.' => 'La dirección de correo asociada a este usuario.',
	'The URL of the site associated with this user. eg. http://www.movabletype.com/' => 'La URL del sitio asociada al usuario. p.e. http://www.movabletype.com/',
	'Userpic' => 'Avatar',
	'The image associated with this user.' => 'La imagen asociada al usuario.',
	'Select Userpic' => 'Seleccionar avatar',
	'Remove Userpic' => 'Borrar avatar',
	'Change Password' => 'Cambiar Contraseña',
	'Current Password' => 'Contraseña actual',
	'Existing password required to create a new password.' => 'La contraseña actual es necesaria para crear una nueva.',
	'Initial Password' => 'Contraseña inicial',
	'Enter preferred password.' => 'Introduzca la contraseña elegida.',
	'New Password' => 'Nueva contraseña',
	'Enter the new password.' => 'Introduzca la nueva contraseña.',
	'Confirm Password' => 'Confirmar contraseña',
	'This word or phrase will be required to recover a forgotten password.' => 'Esta palabra o frase será necesaria para recuperar una contraseña olvidada.',
	'Preferred language of this user.' => 'Idioma preferido por este usuario.',
	'Text Format' => 'Formato de texto',
	'Preferred text format option.' => 'Opción de formato de texto preferido.',
	'(Use Blog Default)' => '(Usar valores predefinidos del blog)',
	'Tag Delimiter' => 'Delimitador de etiquetas',
	'Preferred method of separating tags.' => 'Método preferido de separación de etiquetas.',
	'Comma' => 'Coma',
	'Space' => 'Espacio',
	'Web Services Password' => 'Contraseña de servicios web',
	'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'Utilizada por las fuentes de sindicación de actividad y los clientes XML-RPC y Atom.',
	'Reveal' => 'Mostrar',
	'System Permissions' => 'Permisos del sistema',
	'Options' => 'Opciones',
	'Create personal blog for user' => 'Crear blog personal para el usuario',
	'Create User (s)' => 'Crear usuario (s)', # Translate - New
	'Save changes to this author (s)' => 'Guardar cambios de este autor (s)', # Translate - New
	'_USAGE_PASSWORD_RESET' => 'Puede iniciar la recuperación de la contraseña en nombre de este usuario. Si lo hace, se enviará un correo a <strong>[_1]</strong> con una nueva contraseña aleatoria.',
	'Initiate Password Recovery' => 'Iniciar recuperación de contraseña',

## tmpl/cms/edit_comment.tmpl
	'The comment has been approved.' => 'Se ha aprobado el comentario.',
	'Save changes to this comment (s)' => 'Guardar cambios de este comentario (s)', # Translate - New
	'Delete this comment (x)' => 'Borrar este comentario (x)', # Translate - New
	'Previous Comment' => 'Comentario anterior',
	'Next Comment' => 'Comentario siguiente',
	'View entry comment was left on' => 'Mostrar la entrada donde se realizó el comentario',
	'Reply to this comment' => 'Responder al comentario',
	'Update the status of this comment' => 'Actualizar el estado del comentario',
	'Approved' => 'Autorizado',
	'Unapproved' => 'No aprobado',
	'Reported as Spam' => 'Marcado como spam',
	'View all comments with this status' => 'Ver comentarios con este estado',
	'Spam Details' => 'Detalles de spam',
	'Total Feedback Rating: [_1]' => 'Puntuación total de respuestas: [_1]',
	'Score' => 'Puntuación',
	'Results' => 'Resultados',
	'The name of the person who posted the comment' => 'El nombre de la persona que publicó el comentario',
	'(Trusted)' => '(Confiado)',
	'Ban Commenter' => 'Bloquear Comentarista',
	'Untrust Commenter' => 'Comentarista no fiable',
	'(Banned)' => '(Bloqueado)',
	'Trust Commenter' => 'Comentados Fiable',
	'Unban Commenter' => 'Desbloquear Comentarista',
	'View all comments by this commenter' => 'Ver todos los comentarios de este comentarista',
	'Email address of commenter' => 'Dirección de correo del comentarista',
	'None given' => 'No se indicó ninguno',
	'URL of commenter' => 'URL del comentarista',
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
	'Show only assets where' => 'Mostrar solo los ficheros multimedia donde', # Translate - New
	'type' => 'tipo',

## tmpl/cms/import.tmpl
	'You must select a blog to import.' => 'Debe seleccionar un blog a importar.',
	'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Transfiere las entradas de un weblog en Movable Type desde otras instalaciones de Movable Type o incluso otras herramientas de blogs, o exporta sus entradas para crear una copia de seguridad.',
	'Blog to Import' => 'Blog a importar',
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
	'More options' => 'Más opciones',
	'Import File Encoding' => 'Codificación del fichero de importación',
	'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'Por defecto, Movable Type intentará detectar automáticamente la codificación del fichero a importar. Sin embargo, si experimenta dificultados, puede especificarlo explícitamente.',
	'<mt:var name="display_name">' => '<mt:var name="display_name">',
	'Default category for entries (optional)' => 'Categoría predefinida de las entradas (opcional)',
	'You can specify a default category for imported entries which have none assigned.' => 'Puede especificar una categoría predefinida para las entradas importadas que no tengan ninguna asignada.',
	'Select a category' => 'Seleccione una categoría',
	'Import Entries (s)' => 'Importar entradas (s)',
	'Import Entries' => 'Importar entradas',

## tmpl/cms/upgrade_runner.tmpl
	'Initializing database...' => 'Inicializando base la de datos...',
	'Upgrading database...' => 'Actualizando la base de datos...',
	'Installation complete!' => '¡Instalación finalizada!',
	'Upgrade complete!' => '¡Actualización finalizada!',
	'Starting installation...' => 'Comenzando la instalación...',
	'Starting upgrade...' => 'Comenzando actualización...',
	'Error during installation:' => 'Error durante la instalación:',
	'Error during upgrade:' => 'Error durante la actualización:',
	'Return to Movable Type (s)' => 'Volver a Movable Type (s)',
	'Return to Movable Type' => 'Volver a Movable Type',
	'Your database is already current.' => 'Su base de datos está al día.',

## tmpl/cms/system_check.tmpl
	'User Counts' => 'Número de usuarios',
	'Number of users in this system.' => 'Número de usuarios en el sistema.',
	'Total Users' => 'Usuarios Totales',
	'Active Users' => 'Usuarios Activos',
	'Users who have logged in within 90 days are considered <strong>active</strong> in Movable Type license agreement.' => 'Los usuarios que se hayan identificado a lo largo de los últimos 90 días son considerados como activos según la licence Movable Type.',
	'Movable Type could not find the script named \'mt-check.cgi\'. To resolve this issue, please ensure that the mt-check.cgi script exists and/or the CheckScript configuration parameter references it properly.' => 'Movable Type no ha podido encontrar el script nombrado \'mt-check.cgi\'. Para resolver este problema, asegurese de que el script mt-check.cgi script existe y/o que la configuración de los parámetros de MTCheckScript este correctamente referenciado.',

## tmpl/cms/restore.tmpl
	'Restore from a Backup' => 'Resturar una copia de seguridad',
	'Perl module XML::SAX and/or its dependencies are missing - Movable Type can not restore the system without it.' => 'El módulo de Perl XML::SAX y/o sus dependencias no se encuentran - Movable Type no puede restaurar el sistema sin él.',
	'Backup file' => 'Hacer copia de seguridad del fichero',
	'If your backup file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the \'import\' folder of your Movable Type directory.' => 'Si su fichero de copia de seguridad está situado en su PC, puede subirlo desde aquí. Si no, Movable Type comprobará automáticamente la carpeta \'import\' en el directorio de Movable Type.',
	'Check this and files backed up from newer versions can be restored to this system.  NOTE: Ignoring Schema Version can damage Movable Type permanently.' => 'Activa esta opción y los ficheros con copias de seguridad de versiones más recientes podrán restaurarse en este sistema. NOTA: Ignorar la versión del esquema puede dañar Movable Type permanentemente.',
	'Ignore schema version conflicts' => 'Igrar conflictos de versión de esquemas',
	'Check this and existing global templates will be overwritten from the backup file.' => 'Si activa esto, se sobreescribirán ',
	'Overwrite global templates.' => 'Sobreescribir las plantillas globales.',
	'Restore (r)' => 'Restaurar (r)',

## tmpl/cms/cfg_archives.tmpl
	'Error: Movable Type was not able to create a directory for publishing your blog. If you create this directory yourself, assign sufficient permissions that allow Movable Type to create files within it.' => 'Error: Movable Type no pudo crear un directorio para publicar el blog. Si desea crear el directorio usted mismo, asigne suficientes permisos para que Movable Type pueda crear ficheros en él.',
	'Your blog\'s archive configuration has been saved.' => 'Se guardó la configuración de archivos de su blog.',
	'You have successfully added a new archive-template association.' => 'Agregó correctamente una nueva asociación archivo-plantilla.',
	'You may need to update your \'Master Archive Index\' template to account for your new archive configuration.' => 'Podría tener que actualizar la plantilla \'Archivo índice maestro\' para tener en cuenta la nueva configuración del archivado.',
	'The selected archive-template associations have been deleted.' => 'Las asociaciones seleccionadas archivos-plantillas fueron eliminadas.',
	'You must set your Local Site Path.' => 'Debe definir la ruta local de su sitio.',
	'You must set a valid Site URL.' => 'Debe establecer una URL de sitio válida.',
	'You must set a valid Local Site Path.' => 'Debe establecer una ruta local de sitio válida.',
	'Publishing Paths' => 'Rutas de publicación',
	'The URL of your website. Do not include a filename (i.e. exclude index.html). Example: http://www.example.com/blog/' => 'La URL de su web. No incluya ningún nombre de fichero (p.e. index.html). Ejemplo: http://www.ejemplo.com/blog/',
	'Unlock this blog&rsquo;s site URL for editing' => 'Desbloquear la URL del sitio del blog para su edición',
	'Warning: Changing the site URL can result in breaking all the links in your blog.' => 'Aviso: La modificación de la URL del sitio puede romper los enlaces que referencian al blog.',
	'The path where your index files will be published. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/blog' => 'La ruta donde se publicarán los ficheros índice. Se aconseja una ruta absoluta (las que comienzan con \'/\'), pero también puede usar rutas relativas al directorio de Movable Type. Ejemplo: /home/melody/public_html/blog',
	'Unlock this blog&rsquo;s site path for editing' => 'Desbloquear la ruta del sitio del blog para su edición',
	'Note: Changing your site root requires a complete publish of your site.' => 'Nota: La modificación de la raíz del sitio requiere la publicación completa del sitio.',
	'Advanced Archive Publishing' => 'Publicación avanzada de archivos',
	'Select this option only if you need to publish your archives outside of your Site Root.' => 'Seleccione esta opción solo si necesita publicar sus archivos fuera de la raíz de su sitio.',
	'Publish archives outside of Site Root' => 'Publicar archivos fuera de la raíz del sitio.',
	'Enter the URL of the archives section of your website. Example: http://archives.example.com/' => 'Introduzca la URL de la sección de archivos de su web. Ejemplo: http://archivos.ejemplo.com/',
	'Unlock this blog&rsquo;s archive url for editing' => 'Desbloquear la URL de archivos de este blog para su edición',
	'Warning: Changing the archive URL can result in breaking all the links in your blog.' => 'Aviso: La modificación de la URL de archivos pueden romper todos los enlaces en el blog.',
	'Enter the path where your archive files will be published. Example: /home/melody/public_html/archives' => 'Introduzca la ruta donde se publicarán los ficheros de los archivos. Ejemplo: /home/melody/public_html/archivos',
	'Warning: Changing the archive path can result in breaking all the links in your blog.' => 'Aviso: La modificación de la ruta de los archivos puede romper todos los enlaces en su blog.',
	'Publishing Options' => 'Opciones de publicación',
	'Preferred Archive Type' => 'Tipo de archivo preferido',
	'Used for creating links to an archived entry (permalink). Select from the archive types used in this blogs archive templates.' => 'Utilizado para crear enlaces hacia una nota archivada (enlacepermanente).  Seleccione dentro de los archivos utilizados de las plantillas del blog.',
	'No archives are active' => 'No hay archivos activos',
	'Publishing Method' => 'Método de publicación',
	'Publish all templates statically' => 'Publicar todas las plantillas estáticamente',
	'Publish only Archive Templates dynamically' => 'Publicar dinámicamente solo las plantillas de los archivos',
	'Set each template\'s Publish Options separately' => 'Indicar separadamente las opciones de publicación de las plantillas',
	'Publish all templates dynamically' => 'Publicar todas las plantillas dinámicamente',
	'Use Publishing Queue' => 'Usar cola de publicación',
	'Requires the use of a cron job to publish pages in the background.' => 'Requiere el uso de una tarea del cron para publicar las páginas en segundo plano.',
	'Use background publishing queue for publishing static pages for this blog' => 'Usar la cola de publicación en segundo plano para la publicación de páginas estáticas en este blog.',
	'Enable Dynamic Cache' => 'Activar caché dinámica',
	'Turn on caching.' => 'Desactivar caché.',
	'Enable caching' => 'Activar caché',
	'Enable Conditional Retrieval' => 'Activar recuperación condicional',
	'Turn on conditional retrieval of cached content.' => 'Activar recuperación condicional de los contenidos cacheados.',
	'Enable conditional retrieval' => 'Activar recuperación condicional',
	'File Extension for Archive Files' => 'Extensión de fichero para los ficheros de los archivos',
	'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'Introduzca la extensión de los archivos. Puede ser \'html\', \'shtml\', \'php\', etc. Nota: No introduzca el punto separador de la extensión (\'.\').',

## tmpl/cms/rebuilding.tmpl
	'Publishing...' => 'Publicando...',
	'Publishing [_1]...' => 'Publicando [_1]...',
	'Publishing [_1] [_2]...' => 'Publicado [_1] [_2]...',
	'Publishing [_1] dynamic links...' => 'Publicado [_1] enlace dinámico...',
	'Publishing [_1] archives...' => 'Publicado [_1] archivos...',
	'Publishing [_1] templates...' => 'Publicado [_1] plantillas...',

## tmpl/cms/edit_asset.tmpl
	'Edit Asset' => 'Editar multimedia', # Translate - New
	'Your asset changes have been made.' => 'Se han guardado los cambios del fichero multimedia.', # Translate - New
	'[_1] - Modified by [_2]' => '[_1] - Modificado por [_2]', # Translate - New
	'Appears in...' => 'Aparece en...', # Translate - New
	'Published on [_1]' => 'Publicado en [_1]', # Translate - New
	'Show all entries' => 'Mostrar todas las categorías', # Translate - New
	'Show all pages' => 'Mostrar todas las páginas', # Translate - New
	'This asset has not been used.' => 'Este fichero multimedia no se ha utilizado.', # Translate - New
	'Related Assets' => 'Ficheros multimedia relacionados', # Translate - New
	'You must specify a label for the asset.' => 'Debe especificar una etiqueta para el fichero multimedia.', # Translate - New
	'Embed Asset' => 'Embeber fichero multimedia', # Translate - New
	'Save changes to this asset (s)' => 'Guardar cambios de este fichero multimedia (s)', # Translate - New

## tmpl/cms/upgrade.tmpl
	'Time to Upgrade!' => '¡Hora de actualizar!',
	'Upgrade Check' => 'Comprobar actualización',
	'Do you want to proceed with the upgrade anyway?' => '¿Desea proceder en cualquier caso con la actualización?',
	'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Se ha instalado una nueva versión de Movable Type.  Debemos realizar algunas tareas para actualizar su base de datos.',
	'Information about this upgrade can be found <a href=\'[_1]\' target=\'_blank\'>here</a>.' => 'Informaciones sobre esta actualización pueden ser encontradas <a href=\'[_1]\' target=\'_blank\'>aquí</a>.',
	'In addition, the following Movable Type components require upgrading or installation:' => 'Además, los siguientes componentes de Movable Type necesitan actualización o instalación:',
	'The following Movable Type components require upgrading or installation:' => 'Los siguientes componentes de Movable Type necesitan actualización o instalación:',
	'Begin Upgrade' => 'Comenzar actualización',
	'Congratulations, you have successfully upgraded to Movable Type [_1].' => 'Felicidades, actualizó con éxito a Movable Type [_1].',
	'Your Movable Type installation is already up to date.' => 'Su instalación de Movable Type ya está actualizada.',

## tmpl/cms/edit_blog.tmpl
	'Your blog configuration has been saved.' => 'Se ha guardado la configuración de su blog.',
	'You must set your Blog Name.' => 'Debe configurar el nombre del blog.',
	'You did not select a timezone.' => 'No seleccionó ninguna zona horaria.',
	'You must set your Site URL.' => 'Debe definir la URL de su sitio.',
	'Your Site URL is not valid.' => 'La URL de su sitio no es válida.',
	'You can not have spaces in your Site URL.' => 'No puede haber espacios en la URL de su sitio.',
	'You can not have spaces in your Local Site Path.' => 'No puede haber espacios en la ruta local de su sitio.',
	'Your Local Site Path is not valid.' => 'La ruta local de su sitio no es válida.',
	'Blog Details' => 'Detalles del blog', # Translate - New
	'Name your blog. The blog name can be changed at any time.' => 'Nombre del blog. Se puede modificar en cualquier momento.',
	'Enter the URL of your public website. Do not include a filename (i.e. exclude index.html). Example: http://www.example.com/weblog/' => 'Introduzca la URL de su web público. No incluya ningún nombre de fichero (p.e. index.html). Ejemplo: http://www.ejemplo.com/weblog/',
	'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/weblog' => 'Introduzca la ruta donde se situará el fichero índice principal. Se aconseja una ruta absoluta (que comienzan con \'/\'), pero también puede especificar una ruta relativa al directorio de Movable Type. Ejemplo: /home/melody/public_html/weblog',
	'Create Blog (s)' => 'Crear blog (s)', # Translate - New

## tmpl/cms/pinging.tmpl
	'Trackback' => 'TrackBack',
	'Pinging sites...' => 'Enviando pings a sitios...',

## tmpl/cms/cfg_prefs.tmpl
	'Enter a description for your blog.' => 'Introduzca una descripción para su blog.',
	'License' => 'Licencia',
	'Your blog is currently licensed under:' => 'Su blog actualmente tiene la licencia:',
	'Change license' => 'Cambiar licencia',
	'Remove license' => 'Borrar licencia',
	'Your blog does not have an explicit Creative Commons license.' => 'Su blog no tiene una licencia explícica de Creative Commons.',
	'Select a license' => 'Seleccionar una licencia',

## tmpl/cms/restore_start.tmpl
	'Restoring Movable Type' => 'Restaurando Movable Type',

## tmpl/cms/preview_entry.tmpl
	'Preview [_1]' => 'Pre-ver [_1]',
	'Re-Edit this [_1]' => 'Editar [_1]',
	'Re-Edit this [_1] (e)' => 'Reeditar [_1] (e)',
	'Save this [_1]' => 'Guardar [_1]',
	'Save this [_1] (s)' => 'Guardar este [_1] (s)', # Translate - New
	'Cancel (c)' => 'Cancelar (c)',

## tmpl/cms/list_folder.tmpl
	'Manage Folders' => 'Administrar carpetas', # Translate - New
	'Your folder changes and additions have been made.' => 'Se han realizado los cambios y añadidos a la carpeta.', # Translate - New
	'You have successfully deleted the selected folder.' => 'Ha borrado con éxito la carpeta seleccionada.', # Translate - New
	'Delete selected folders (x)' => 'Borrar carpetas seleccionadas (x)', # Translate - New
	'Create top level folder' => 'Crear carpeta raíz', # Translate - New
	'New Parent [_1]' => 'Nueva [_1] raíz',
	'Create Folder' => 'Crear carpeta', # Translate - New
	'Top Level' => 'Raíz',
	'Create Subfolder' => 'Crear subcarpeta', # Translate - New
	'Move Folder' => 'Mover carpeta', # Translate - New
	'Move' => 'Mover',
	'[quant,_1,page,pages]' => '[quant,_1,página,páginas]',

## tmpl/cms/list_association.tmpl
	'permission' => 'permiso',
	'permissions' => 'permisos',
	'Remove selected permissions (x)' => 'Remove selected permissions (x)', # Translate - New
	'Revoke Permission' => 'Revocar permiso',
	'[_1] <em>[_2]</em> is currently disabled.' => '[_1] <em>[_2]</em> está momentáneamente indisponible',
	'Grant Permission' => 'Otorgar permiso',
	'You can not create permissions for disabled users.' => 'No puede crear permisos para los usuarios deshabilitados.', # Translate - New
	'Assign Role to User' => 'Asignar rol al usuario',
	'Grant permission to a user' => 'Otorgar permiso a un usuario',
	'You have successfully revoked the given permission(s).' => 'Otorgó los permisos con éxito.',
	'You have successfully granted the given permission(s).' => 'Revocó los permisos con éxito.',
	'No permissions could be found.' => 'No se encontraron permisos.', # Translate - New

## tmpl/cms/login.tmpl
	'Your Movable Type session has ended.' => 'Finalizó su sesión en Movable Type.',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Su sesión de Movable Type finalizó. Si desea identificarse de nuevo, hágalo abajo.',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Su sesión de Movable Type finalizó. Por favor, identifíquese de nuevo para continuar con esta acción.',
	'Forgot your password?' => '¿Olvidó su contraseña?',
	'Sign In (s)' => 'Identifíquese (s)',

## tmpl/cms/list_category.tmpl
	'Your category changes and additions have been made.' => 'Se han realizado los cambios y añadidos.', # Translate - New
	'You have successfully deleted the selected category.' => 'Se han borrado con éxito las categorías seleccionadas.', # Translate - New
	'categories' => 'categorías',
	'Delete selected category (x)' => 'Borrar categoría seleccionada (x)', # Translate - New
	'Create top level category' => 'Crear categoría raíz', # Translate - New
	'Create Category' => 'Crear categoría', # Translate - New
	'Collapse' => 'Contraer',
	'Expand' => 'Ampliar',
	'Move Category' => 'Mover categoría', # Translate - New
	'[quant,_1,TrackBack,TrackBacks]' => '[quant,_1,TrackBack,TrackBacks]',

## tmpl/cms/cfg_entry.tmpl
	'Entry Settings' => 'Configuración de las entradas',
	'Display Settings' => 'Opciones de visualización',
	'Entry Listing Default' => 'Lista de entradas',
	'Select the number of days of entries or the exact number of entries you would like displayed on your blog.' => 'Seleccione el número de días de entradas o el número exacto de entradas que desea mostrar en el blog.',
	'Days' => 'Días',
	'Entry Order' => 'Orden de las entradas',
	'Select whether you want your entries displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Seleccione si quiere mostrar las entradas en orden ascendente (antiguas primero) o descendente (recientes primero).',
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
	'New Entry Defaults' => 'Valores por defecto de las nuevas entradas',
	'Specifies the default Entry Status when creating a new entry.' => 'Especifica el estado predefinido de las nuevas entradas.',
	'Specifies the default Text Formatting option when creating a new entry.' => 'Especifica el formato de texto predeterminado para las entradas nuevas.',
	'Specifies the default Accept Comments setting when creating a new entry.' => 'Indica el valor predefinido para la opción Aceptar comentarios al crear nuevas entradas.',
	'Note: This option is currently ignored since comments are disabled either blog or system-wide.' => 'Nota: Actualmente, se ignora esta opción ya que los comentarios están desactivados en el blog o en todo el sistema.',
	'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Indica el valor predefinido de la opción Aceptar TrackBacks al crear nuevas entradas.',
	'Note: This option is currently ignored since TrackBacks are disabled either blog or system-wide.' => 'Nota: Actualmente, se ignora esta opción ya que los TrackBacks están desactivados en el blog o en todo el sistema.',
	'Replace Word Chars' => 'Reemplazar caracteres de palabras',
	'Smart Replace' => 'Reemplazo inteligente',
	'Replace UTF-8 characters frequently used by word processors with their more common web equivalents.' => 'Remplace los carácteres UTF-8 más usados frecuentemente por el porcesador de texto por sus equivalentes más comunes en la web.',
	'No substitution' => 'Sin sustitución',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'Entidades de caracteres (&amp#8221;, &amp#8220;, etc.)',
	'ASCII equivalents (&quot;, \', ..., -, --)' => 'Equivalentes ASCII (&quot;, \', ..., -, --)',
	'Replace Fields' => 'Reemplazar campos',
	'Extended entry' => 'Entrada extendida',
	'Default Editor Fields' => 'Campos de edición predefinidos',
	'Editor Fields' => 'Campos del editor',
	'_USAGE_ENTRYPREFS' => 'Seleccione el conjunto de campos que se mostrarán en el editor de entradas.',
	'Action Bars' => 'Botón de Acción',
	'Select the location of the entry editor&rsquo;s action bar.' => 'Seleccione la posición de la barra de acciones del editor de entradas.',

## tmpl/cms/cfg_system_users.tmpl
	'System: User Settings' => 'Sistema: Configuración de usuarios',
	'(None selected)' => '(Ninguno seleccionado)',
	'User Registration' => 'Registro de usuarios',
	'Allow Registration' => 'Permitir registro',
	'Select a system administrator you wish to notify when commenters successfully registered themselves.' => 'Seleccione un administrar del sistema a quien desee que se le remitan notificaciones cuando los comentaristas se registren.',
	'Allow commenters to register to Movable Type' => 'Permitir que los comentaristas se registren en Movable Type',
	'Notify the following administrators upon registration:' => 'Notificar registro a los siguientes administradores:',
	'Select Administrators' => 'Seleccionar administradores',
	'Clear' => 'Limpiar',
	'Note: System Email Address is not set. Emails will not be sent.' => 'Nota: La dirección de correo del sistema no está configurada. Los mensajes no podrán enviarse.',
	'New User Defaults' => 'Valores predefinidos para los nuevos usuarios',
	'Personal blog' => 'Blog Personal',
	'Check to have the system automatically create a new personal blog when a user is created in the system. The user will be granted a blog administrator role on the blog.' => 'Verifique si tiene el sistema automático de creación de un nuevo blog personal cuando un usuario se crea en el sistema.  El usuario sera promovido al rol de administrador en el blog.',
	'Automatically create a new blog for each new user' => 'Crear automáticamente un nuevo blog por cada nuevo usuario',
	'Personal blog clone source' => 'Fuente del blog personal a clonar',
	'Select a blog you wish to use as the source for new personal blogs. The new blog will be identical to the source except for the name, publishing paths and permissions.' => 'Seleccionar el blog que usted desee utilizar como fuente para los nuevos blogs personales. El nuevo blog será así idéntificado a la fuente, a excepción del nombre, las rutas de publicación y las permisiones.',
	'Default Site URL' => 'URL del sitio',
	'Define the default site URL for new blogs. This URL will be appended with a unique identifier for the blog.' => 'Defina por defecto la URL del sitio para los nuevos blogs.  Esta URL ',
	'Default Site Root' => 'Raíz del sitio',
	'Define the default site root for new blogs. This path will be appended with a unique identifier for the blog.' => 'Defina por defecto la ruta de publicación para los nuevos blogs. Esta ruta será completada con un identificador único para el blog',
	'Default User Language' => 'Idioma del usuario',
	'Define the default language to apply to all new users.' => 'Establezca el idioma predefinido a aplicar a los nuevos usuarios.',
	'Default Timezone' => 'Zona horaria predefinida',
	'Default Tag Delimiter' => 'Delimitador de etiquetas predefinido',
	'Define the default delimiter for entering tags.' => 'Seleccione el separador predefinido al introducir etiquetas.',

## tmpl/cms/recover_password_result.tmpl
	'Recover Passwords' => 'Recuperar contraseñas',
	'No users were selected to process.' => 'No se seleccionaron usarios a procesar.',
	'Return' => 'Volver',

## tmpl/cms/cfg_registration.tmpl
	'Registration Settings' => 'Configuración de registro',
	'Allow registration for Movable Type.' => 'Permitir el registro en Movable Type.',
	'Registration Not Enabled' => 'Registro no activado',
	'Note: Registration is currently disabled at the system level.' => 'Nota: Actualmente el regisro está desactivado a nivel del sistema.',
	'Authentication Methods' => 'Métodos de autentificación',
	'Note: You have selected to accept comments from authenticated commenters only but authentication is not enabled. In order to receive authenticated comments, you must enable authentication.' => 'Nota: Seleccionó aceptar comentarios solo de comentaristas autentificados, pero la autentificación no está activada. Para recibir comentarios autentificados, debe activar la autentificación.',
	'Native' => 'Nativo',
	'Require E-mail Address for Comments via TypeKey' => 'Requerir dirección de correo en los comentarios vía TypeKey',
	'If enabled, visitors must allow their TypeKey account to share e-mail address when commenting.' => 'Si está activado, los visitantes deberán permitir en su cuenta de TypeKey que comparta la dirección de correo al comentar.',
	'Setup TypeKey' => 'Configuración de TypeKey',
	'OpenID providers disabled' => 'Proveedores OpenID desactivados',
	'Required module (Digest::SHA1) for OpenID commenter authentication is missing.' => 'No se encuentra el módulo necesario (Digest::SHA1) para la autentificación de comentaristas con OpenID.',

## tmpl/cms/list_author.tmpl
	'Users: System-wide' => 'Usuarios: Todo el sistema',
	'_USAGE_AUTHORS_LDAP' => 'Lista de todos los usuarios en el sistema de Movable Type. Puede editar los permisos del usuario haciendo clic en el nombre. Puede deshabilitar usuarios activando las casillas junto a su nombre y presionando el botón Deshabilitar. De esta forma, el usuario no podrá acceder a Movable Type.',
	'You have successfully disabled the selected user(s).' => 'Ha deshabilitado con éxito el/los usuario/s seleccionado/s.',
	'You have successfully enabled the selected user(s).' => 'Ha habilitado con éxito el/los usuario/s seleccionado/s.',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'Ha borrado con éxito el/los usuario/s seleccionado/s del sistema de Movable Type.',
	'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Enterprise.' => 'Este usuario borrado aún existe en el directorio externo. Como tal, aún podrán acceder a Movable Type Enterprise.',
	'You have successfully synchronized users\' information with the external directory.' => 'Sincronizó con éxito la información de los usuarios con el directorio externo.',
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => 'Algunos ([_1]) de los usuarios seleccionados no pudieron rehabilitarse porque ya no se encuentra en el directorio externo.',
	'An error occured during synchronization.  See the <a href=\'[_1]\'>activity log</a> for detailed information.' => 'Ocurrió un error durante la sincronización. Para información más detallada, consulte el <a href=\'[_1]\'>registro de actividad</a>.',
	'Enable selected users (e)' => 'Habilitar usuarios seleccionados (e)',
	'_USER_ENABLE' => 'Habilitado',
	'_NO_SUPERUSER_DISABLE' => 'No puede deshabilitarse porque es un administrador del sistema de Movable Type',
	'Disable selected users (d)' => 'Deshabilitar usuarios seleccionados (d)',
	'_USER_DISABLE' => 'Deshabilitar',
	'Showing All Users' => 'Mostrar Todos los Usuarios',

## tmpl/cms/import_others.tmpl
	'Start title HTML (optional)' => 'HTML de comienzo de título (opcional)',
	'End title HTML (optional)' => 'HTML de final de título (opcional)',
	'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => 'Si el software desde el que va a importar no tiene un campo de título, puede usar esta opción para identificar un título dentro del cuerpo de la entrada.',
	'Default entry status (optional)' => 'Estado predefinido de las entradas (opcional)',
	'If the software you are importing from does not specify an entry status in its export file, you can set this as the status to use when importing entries.' => 'Si el software desde el que va a importar no especifica un estado para la entrada en su fichero de exportación, puede establecer éste como el estado a utilizar al importar las entradas.',
	'Select an entry status' => 'Seleccione un estado para las entradas',

## tmpl/cms/search_replace.tmpl
	'You must select one or more item to replace.' => 'Debe seleccionar uno o más elementos a reemplazar.',
	'Search Again' => 'Buscar de nuevo',
	'Submit search (s)' => 'Buscar (s)',
	'Replace' => 'Reemplazar',
	'Replace Checked' => 'Reemplazar selección',
	'Case Sensitive' => 'Distinguir mayúsculas y minúsculas',
	'Regex Match' => 'Expresión regular',
	'Limited Fields' => 'Campos limitados',
	'Date Range' => 'Rango de fechas',
	'Reported as Spam?' => '¿Marcado como spam?',
	'Search Fields:' => 'Buscar campos:',
	'_DATE_FROM' => '_FECHA_DESDE EL',
	'_DATE_TO' => '_FECHA_AL',
	'Successfully replaced [quant,_1,record,records].' => '[quanta,_1,registro reemplazado,registros reemplazados] con éxito.',
	'Showing first [_1] results.' => 'Primeros [_1] resultados.',
	'Show all matches' => 'Mostrar todos los resultados',
	'[quant,_1,result,results] found' => '[quant,_1,resultado]',

## tmpl/cms/preview_strip.tmpl
	'Save this entry' => 'Guardar esta entrada', # Translate - New
	'Save this page' => 'Guardar esta página', # Translate - New
	'You are previewing the entry titled &ldquo;[_1]&rdquo;' => 'Está previsualizando la entrada titulada &ldquo;[_1]&rdquo;', # Translate - New
	'You are previewing the page titled &ldquo;[_1]&rdquo;' => 'Está previsualizando la página titulada &ldquo;[_1]&rdquo;', # Translate - New

## tmpl/cms/edit_ping.tmpl
	'Edit Trackback' => 'Editar TrackBack', # Translate - Case
	'The TrackBack has been approved.' => 'Se aprobó el TrackBack.',
	'List &amp; Edit TrackBacks' => 'Listar &amp; editar TrackBacks',
	'View Entry' => 'Ver entrada',
	'Save changes to this TrackBack (s)' => 'Guardar cambios de este TrackBack (s)', # Translate - New
	'Delete this TrackBack (x)' => 'Borrar este TrackBack (x)', # Translate - New
	'Update the status of this TrackBack' => 'Actualizar el estado del TrackBack',
	'Junk' => 'Basura',
	'View all TrackBacks with this status' => 'Ver TrackBacks con este estado',
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

## tmpl/comment/register.tmpl
	'Create an account' => 'Crear una cuenta',
	'Your email address.' => 'Dirección de correo electrónico.',
	'Your login name.' => 'Nombre de su usuario.',
	'The name appears on your comment.' => 'El nombre que aparece en su comentario.',
	'Select a password for yourself.' => 'Seleccione su contraseña.',
	'This word or phrase will be required to recover the password if you forget it.' => 'Se solicitará esta palabra o frase para recuperar la contraseña si la olvida.',
	'The URL of your website. (Optional)' => 'La URL del sitio web (opcional)',
	'Register' => 'Registrarse',

## tmpl/comment/signup.tmpl

## tmpl/comment/login.tmpl
	'Sign in to comment' => 'Identifíquese para comentar',
	'Sign in using' => 'Identifíquese usando',
	'Remember me?' => '¿Recordarme?',
	'Not a member?&nbsp;&nbsp;<a href="[_1]">Sign Up</a>!' => '¿No es usuario?&nbsp;&nbsp;¡<a href="[_1]">Inscríbase</a>!',

## tmpl/comment/error.tmpl
	'Go Back (s)' => 'Volver',

## tmpl/comment/signup_thanks.tmpl
	'Thanks for signing up' => 'Gracias por inscribirse',
	'Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].' => 'Antes de poder comentar, debe completar el proceso de registro confirmando su cuenta. Se le ha enviado un correo a [_1].',
	'To complete the registration process you must first confirm your account. An email has been sent to [_1].' => 'Para completar el proceso de registro, primeramente debe confirmar su cuenta. Se le ha enviado un correo a [_1].',
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'Para confirmar y activar su cuenta, por favor, compruebe su correo y haga clic en el correo que le acabamos de enviar.',
	'Return to the original entry.' => 'Volver a la entrada original.',
	'Return to the original page.' => 'Volver a la página original.',

## tmpl/comment/profile.tmpl
	'Your Profile' => 'Su perfil',
	'Password recovery' => 'Recuperar contraseña',
	'Return to the <a href="[_1]">original page</a>.' => 'Volver a la <a href="[_1]">página original</a>.',

## tmpl/feeds/feed_entry.tmpl
	'Unpublish' => 'Despublicar',
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
	'Login required' => 'Requerido inicio de sesión',
	'System template entry_response not found in blog: [_1]' => 'La plantilla del sistema entry_response no se encontró en el blog: [_1]',
	'Posting a new entry failed.' => 'Fallo publicando una nueva entrada.',
	'New entry \'[_1]\' added to the blog \'[_2]\'' => 'Añadida una nueva entrada \'[_1]\' al blog \'[_2]\'',
	'Id or Username is required' => 'Se necesita el Id o el nombre del usuario',
	'Unknown user' => 'Usuario desconocido',
	'Cannot edit profile.' => 'No se pudo editar el perfil.',
	'Recent Entries from [_1]' => 'Entradas recientes de [_1]',
	'Responses to Comments from [_1]' => 'Respuestas a los comentarios de [_1]',

## addons/Community.pack/lib/MT/Community/Tags.pm
	'You used an \'[_1]\' tag outside of the block of MTIfEntryRecommended; perhaps you mistakenly placed it outside of an \'MTIfEntryRecommended\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del bloque MTIfEntryRecommended; ¿quizás la situó por error fuera de un contenedor \'MTIfEntryRecommended\'?',
	'Click here to recommend' => 'Haga clic aquí para hacer una recomendación',

## addons/Community.pack/lib/MT/Community/CMS.pm
	'Welcome to the Movable Type Community Solution' => 'Bienvenido a la Community Solution de Movable Type',
	'The Community Solution gives you to the tools to build a successful community with active, engaged conversations. Some key features to explore:' => 'Community Solution le ofrece las herramientas necesarias para construir una comunidad activa y con apasionantes conversaciones. Algunas de las funcionalidades más importantes a explorar son:',
	'Member Profiles' => 'Perfiles de miembros',
	'Allow registered members of your community to create and customize profiles, including user pictures' => 'Permite que los usuarios registrados de la comunidad creen y personalicen sus perfiles, incluyendo avatares.',
	'Favoriting, Recommendations and User Voting' => 'Favoritos, recomendaciones y votaciones',
	'Your community can vote for its favorite content, making it easy for your readers and authors to see what\'s most popular' => 'La comunidad puede votar por los contenidos favoritos, facilitando que sus lectores y autores vean lo más popular',
	'User-Contributed Content' => 'Contribuciones de los usuarios',
	'Registered users can submit content to your site, and administrators have full control over what gets published' => 'Los usuarios registrados pueden enviar contenidos al sitio, ¡pero los administradores tendrán control total sobre lo que se publica!',
	'Forums and Community Blogs' => 'Foros y blogs comunitarios',
	'Add forums and group blogs to your site with just a few clicks' => 'Puede añadir foros y blogs para grupos al sitio con solo un par de clics',
	'Completely Customizable Design' => 'Diseño completamente personalizable',
	'Every element of your site experience is customizable, including login screens, registration forms, profile editing, and even email messages' => 'Todos los elementos del sitio pueden personalizarse, incluyendo pantallas de inicio de sesión, formularios de registro, edición de perfiles e incluso los mensajes de correo',

## addons/Community.pack/php/function.mtentryrecommendvotelink.php

## addons/Community.pack/tmpl/widget/blog_stats_registration.mtml
	'Registrations' => 'Registros',
	'Recent Registrations' => 'Registros recientes',
	'default userpic' => 'avatar predefinido',
	'You have [quant,_1,registration,registrations] from [_2]' => 'Tiene [quant,_1,registro,registros] de [_2]', # Translate - New

## addons/Community.pack/tmpl/widget/most_popular_entries.mtml
	'Most Popular Entries' => 'Entradas más populares',
	'There are no popular entries.' => 'No hay entradas populares.',

## addons/Community.pack/tmpl/widget/recent_submissions.mtml
	'Recent Submissions' => 'Envíos recientes',

## addons/Community.pack/tmpl/widget/recent_favorites.mtml
	'Recent Favorites' => 'Favoritos recientes',
	'There are no recently favorited entries.' => 'No hay recomendaciones recientes de entradas.',

## addons/Community.pack/tmpl/cfg_community_prefs.tmpl
	'Community Settings' => 'Configuración de la comunidad',
	'Anonymous Recommendation' => 'Recomendación anónima',
	'Check to allow anonymous users (users not logged in) to recommend discussion.  IP address is recorded and used to identify each user.' => 'Active esta opción para permitir que los usuarios anónimos (aquellos que no han iniciado una sesión) puedan recomendar debates. Las direcciones IP se registran y se utilizan para identificar a cada usuario.',
	'Allow anonymous user to recommend' => 'Permitir que los usuarios anónimos hagan recomendaciones',
	'Save changes to blog (s)' => 'Guardar cambios del blog (s)', # Translate - New

## addons/Community.pack/templates/global/register_form.mtml
	'Sign up' => 'Registrarse',
	'Simple Header' => 'Cabecera simple',

## addons/Community.pack/templates/global/simple_footer.mtml

## addons/Community.pack/templates/global/profile_error.mtml
	'Profile Error' => 'Error del perfil',
	'Status Message' => 'Mensaje de estado',

## addons/Community.pack/templates/global/profile_feed_rss.mtml

## addons/Community.pack/templates/global/userpic.mtml

## addons/Community.pack/templates/global/new_entry_email.mtml
	'A new entry \'[_1]([_2])\' has been posted on your blog [_3].' => 'Se ha publicado una nueva entrada \'[_1]([_2])\' en su blog [_3].',
	'Author name: [_1]' => 'Nombre del autor: [_1]',
	'Author nickname: [_1]' => 'Pseudónimo del autor: [_1]',
	'Title: [_1]' => 'Título: [_1]',
	'Edit entry:' => 'Editar entrada:',

## addons/Community.pack/templates/global/password_reset_form.mtml
	'Reset Password' => 'Reiniciar la contraseña',
	'Back to the original page' => 'Regresar a la página original',
	'Simple Footer' => 'Pie simple',

## addons/Community.pack/templates/global/profile_edit_form.mtml
	'Go <a href="[_1]">back to the previous page</a> or <a href="[_2]">view your profile</a>.' => '<a href="[_1]">Regresar a la página anterior</a> o <a href="[_2]">vea su perfil</a>.',
	'Form Field' => 'Campo del formulario',
	'User Name' => 'Usuario',
	'Upload New Userpic' => 'Transferir nuevo avatar',

## addons/Community.pack/templates/global/header.mtml
	'Blog Description' => 'Descripción del blog',
	'GlobalJavaScript' => 'GlobalJavaScript',
	'Navigation' => 'Navegación',
	'User Navigation' => 'Navegación del usuario',

## addons/Community.pack/templates/global/profile_view.mtml
	'User Profile' => 'Perfil del usuario',
	'Website:' => 'Web:',
	'Recent Comments' => 'Comentarios recientes',
	'Responses to Comments' => 'Respuestas a comentarios',
	'Favorites' => 'Favoritos',
	'No recent entries.' => 'Sin entradas recientes.',
	'Recents Comments from [_1]' => 'Comentarios recientes de [_1]',
	'(posted to [_1])' => '(publicado en [_1])',
	'No recent comments.' => 'Sin comentarios recientes.',
	'No responses to comments.' => 'Sin respuestas a comentarios.',
	'Favorites of [_1]' => 'Favoritos de [_1]',
	'[_1] has not added any favorites yet.' => '[_1] no tiene aún favoritos.',

## addons/Community.pack/templates/global/login_form.mtml

## addons/Community.pack/templates/global/register_confirmation.mtml
	'Authentication Email Sent' => 'Correo de autentificación enviado.',
	'Profile Created' => 'Perfil creado',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Regresar a la página original.</a>',

## addons/Community.pack/templates/global/user_navigation.mtml
	'Logged in as <a href="[_1]">[_2]</a>' => 'Identificado como <a href="[_1]">[_2]</a>',
	'Sign out' => 'Salir',
	'Not a member? <a href="[_1]">Register</a>' => '¿No es miembro? <a href="[_1]">Registrarse</a>',

## addons/Community.pack/templates/global/footer.mtml

## addons/Community.pack/templates/global/navigation.mtml
	'Home' => 'Inicio',

## addons/Community.pack/templates/global/login_form_module.mtml
	'Hello [_1]' => 'Hola [_1]',
	'Forgot Password' => 'Recuperar la contraseña',

## addons/Community.pack/templates/global/email_verification_email.mtml
	'Thank you registering for an account to [_1].' => 'Gracias por registrar una cuenta en [_1].',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to sign in to [_1].' => 'Por su propia seguridad y para prevenir fraudes, le solicitamos que confirme su cuenta y dirección de correo antes de continuar. Una vez confirmados, ya podrá iniciar una sesión en [_1].',
	'If you did not make this request, or you don\'t want to register for an account to [_1], then no further action is required.' => 'Si no realizó esta petición, o no quiere registrar una cuenta en [_1], no se requiere ninguna otra acción.',

## addons/Community.pack/templates/global/register_notification_email.mtml

## addons/Community.pack/templates/global/search.mtml

## addons/Community.pack/templates/blog/rss.mtml

## addons/Community.pack/templates/blog/archive_index.mtml
	'Content Navigation' => 'Navegación de contenidos',

## addons/Community.pack/templates/blog/trackbacks.mtml

## addons/Community.pack/templates/blog/main_index.mtml

## addons/Community.pack/templates/blog/page.mtml

## addons/Community.pack/templates/blog/content_nav.mtml
	'Blog Home' => 'Incio - Blog',

## addons/Community.pack/templates/blog/entry_summary.mtml
	'A favorite' => 'Un favorito',
	'Favorite' => 'Favorito',

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

## addons/Community.pack/templates/blog/entry_form.mtml
	'You don\'t have permission to post.' => 'No tiene permisos para publicar.',
	'<a href="[_1]">Sign in</a> to create an entry.' => '<a href="[_1]">Inicie una sesión</a> para crear una entrada.',
	'Select Category...' => 'Seleccione una categoría...',

## addons/Community.pack/templates/blog/entry_create.mtml
	'Entry Form' => 'Formulario de entradas',

## addons/Community.pack/templates/blog/comment_detail.mtml

## addons/Community.pack/templates/blog/comments.mtml

## addons/Community.pack/templates/blog/comment_form.mtml

## addons/Community.pack/templates/blog/categories.mtml

## addons/Community.pack/templates/blog/search_results.mtml

## addons/Community.pack/templates/blog/sidebar_2col.mtml
	'Subscribe icon' => 'Icono de suscripción',
	'Subscribe' => 'Suscripción',

## addons/Community.pack/templates/blog/sidebar_3col.mtml

## addons/Community.pack/templates/blog/entry_listing.mtml

## addons/Community.pack/templates/blog/dynamic_error.mtml

## addons/Community.pack/templates/blog/tags.mtml

## addons/Community.pack/templates/blog/entry_metadata.mtml

## addons/Community.pack/templates/blog/entry.mtml

## addons/Community.pack/templates/blog/comment_preview.mtml

## addons/Community.pack/templates/blog/javascript.mtml

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
	'Your reply has been accepted' => 'Su respuesta ha sido aceptada',
	'Thank you for your reply. It has been accepted and should appear momentarily.' => 'Gracias por su respuesta. Ha sido aceptada y aparecerá en breve.',
	'Reply Pending' => 'Respuesta pendiente',
	'Your reply has been received' => 'Se ha recibido su respuesta',
	'Thank you for your reply. However, your reply is currently being held for approval by the forum\'s administrator.' => 'Gracias por su respuesta. Actualmente está pendiente de aprobación por parte del administrador del foro.',
	'Reply Submission Error' => 'Error en el envío de la respuesta',
	'Your reply submission failed for the following reasons:' => 'El envío de la respuesta falló por alguna de las siguientes razones:',
	'Return to the <a href="[_1]">original topic</a>.' => 'Regresar al <a href="[_1]">tema original</a>.',

## addons/Community.pack/templates/forum/content_header.mtml

## addons/Community.pack/templates/forum/entry_detail.mtml

## addons/Community.pack/templates/forum/entry_form.mtml
	'<a href="[_1]">Sign in</a> to create a topic.' => '<a href="[_1]">Inicie una sesión</a> para crear un tema.',
	'Topic' => 'Tema',
	'Select Forum...' => 'Seleccionar foro...',
	'Forum' => 'Foro',

## addons/Community.pack/templates/forum/comment_detail.mtml

## addons/Community.pack/templates/forum/entry_create.mtml
	'Start a Topic' => 'Comenzar un tema',

## addons/Community.pack/templates/forum/comment_form.mtml

## addons/Community.pack/templates/forum/entry_listing.mtml

## addons/Community.pack/templates/forum/entry_metadata.mtml
	'Replies ([_1])' => 'Respuestas ([_1])',

## addons/Community.pack/templates/forum/entry.mtml

## addons/Community.pack/templates/forum/javascript.mtml
	'. Now you can reply to this topic.' => '. Ahora puede contestar en este tema.',
	' to comment on this topic.' => ' para comentar en este tema.',
	' to comment on this topic,' => ' para comentar en este tema.',

## addons/Community.pack/templates/forum/rss.mtml

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
	'All Forums' => 'Todos los foros',
	'[_1] Forum' => '[_1] Foro', # Translate - New

## addons/Community.pack/templates/forum/category_groups.mtml
	'Forum Groups' => 'Grupos de los foros',
	'Last Topic: [_1] by [_2] on [_3]' => 'Último tema: [_1] by [_2] on [_3]',

## addons/Community.pack/templates/forum/comments.mtml
	'[_1] Replies' => '[_1] respuestas',
	'_NUM_FAVORITES' => 'Marcar como favorito',
	'Favorite This' => 'Marcar como favorito',

## addons/Community.pack/templates/forum/search_results.mtml

## addons/Community.pack/templates/forum/dynamic_error.mtml

## addons/Community.pack/templates/forum/entry_popular.mtml
	'Popular topics' => 'Temas populares',
	'No Reply' => 'Sin respuestas',

## addons/Community.pack/templates/forum/comment_preview.mtml
	'Reply on [_1]' => 'Responder a [_1]',
	'Previewing your Reply' => 'Vista previa de la respuesta',

## addons/Community.pack/config.yaml
	'Login Form' => 'Formulario de inicio de sesión',
	'Password Reset Form' => 'Formulario de reinicio de contraseña',
	'Registration Form' => 'Formulario de registro',
	'Registration Confirmation' => 'Confirmación de registro',
	'Profile View' => 'Ver perfil',
	'Profile Edit Form' => 'Formulario de edición del perfil',
	'Profile Feed (Atom)' => 'Sindicación de perfiles (Atom)',
	'Profile Feed (RSS)' => 'Sindicación de perfiles (RSS)',
	'Email verification' => 'Verificación del correo',
	'Registration notification' => 'Notificación de registro',
	'New entry notification' => 'Notificación de nueva entrada',
	'Community Blog' => 'Blog de la comunidad',
	'Entry Response' => 'Respuesta a la entrada',
	'Displays error, pending or confirmation message when submitting an entry.' => 'Muestra un mensaje de error, de pendiente o de confirmación, al enviar una entrada.',
	'Community Forum' => 'Foro de la comunidad',
	'Entry Feed (Atom)' => 'Sindicación de las entradas (Atom)',
	'Entry Feed (RSS)' => 'Sindicación de las entradas (RSS)',
	'Displays error, pending or confirmation message when submitting a entry.' => 'Muestra un mensaje de error, de pendiente o de confirmación al enviar una entrada.',

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
	'Please enter some value for required \'[_1]\' field.' => 'Por favor, introduzca un valor en el campo obligatorio \'[_1]\'.',
	'Please ensure all required fields have been filled in.' => 'Por favor, asegúrese de que todos los campos se han introducido.',
	'The template tag \'[_1]\' is an invalid tag name.' => 'La etiqueta de plantilla \'[_1]\' es un nombre de etiqueta inválido.', # Translate - New
	'The template tag \'[_1]\' is already in use.' => 'La etiqueta de plantilla \'[_1]\' ya está en uso.',
	'The basename \'[_1]\' is already in use.' => 'El nombre base \'[_1]\' ya está en uso.',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'Personalice los formularios y campos de las entradas, páginas, carpetas, categorías y usuarios, guardando los datos exactos que necesite.', # Translate - New
	' ' => ' ',
	'Single-Line Text' => 'Texto - Una sola línea',
	'Multi-Line Textfield' => 'Texto - Varias líneas',
	'Checkbox' => 'Casilla',
	'Date and Time' => 'Fecha y Hora',
	'Drop Down Menu' => 'Menú desplegable',
	'Radio Buttons' => 'Botones radiales',

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	'Are you sure you have used a \'[_1]\' tag in the correct context? We could not find the [_2]' => '¿Está seguro de que ha utilizado la etiqueta \'[_1]\' en el contexto adecuado? No se encontró el [_2]',
	'You used an \'[_1]\' tag outside of the context of the correct content; ' => 'Ha utilizado una etiqueta \'[_1]\' fuera del contexto del contenido correcto;',

## addons/Commercial.pack/lib/CustomFields/Upgrade.pm
	'Moving metadata storage for pages...' => 'Trasladando los metadatos de las páginas...', # Translate - New

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Restoring custom fields data stored in MT::PluginData...' => 'Restaurando los datos de los campos personalizados guardados en MT::PluginData...', # Translate - New
	'Restoring asset associations found in custom fields ( [_1] ) ...' => 'Restaurando las asociaciones de los ficheros multimedia de los campos personalizados ( [_1] ) ...', # Translate - New
	'Restoring url of the assets associated in custom fields ( [_1] )...' => 'Restaurando url de los ficheros multimedia asociados en los campos personalizados ( [_1] )...', # Translate - New

## addons/Commercial.pack/lib/CustomFields/Util.pm
	'Failed to find [_1]::[_2]' => 'Falló al buscar [_1]::[_2]',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'Field' => 'Campo',

## addons/Commercial.pack/tmpl/date-picker.tmpl
	'Select date' => 'Seleccionar fecha',

## addons/Commercial.pack/tmpl/edit_field.tmpl
	'New Field' => 'Nuevo campo',
	'The selected fields(s) has been deleted from the database.' => 'Los campos seleccionados han sido borrados de la base de datos.',
	'Please ensure all required fields (highlighted) have been filled in.' => 'Por favor, asegúrese de que todos los campos obligatorios (resaltados) han sido introducidos.',
	'System Object' => 'Objeto del sistema',
	'Select the system object this field is for' => 'Seleccione el objeto del sistema para el cual es el campo',
	'Select...' => 'Seleccionar...',
	'Required?' => '¿Obligatorio?',
	'Should a value be chosen or entered into this field?' => '¿Debería seleccionarse o introducirse un valor en este campo?',
	'Default' => 'Predefinido',
	'You will need to first save this field in order to set a default value' => 'Primero deberá guardar este campo para configurarle su valor predefinido.',
	'_CF_BASENAME' => 'Nombre base',
	'The basename is used for entering custom field data through a 3rd party client. It must be unique.' => 'El nombre base se utiliza para introducir datos de campos personalizados a través de un cliente de otro fabricante. Debe ser único.', # Translate - New
	'Unlock this for editing' => 'Desbloquear para la edición',
	'Warning: Changing this field\'s basename may cause serious data loss.' => 'Cuidado: El cambio del nombre base del campo podría causar la pérdida de datos.',
	'Template Tag' => 'Etiqueta de plantilla',
	'Create a custom template tag for this field.' => 'Crea una etiqueta de plantilla personalizada para este campo.',
	'Example Template Code' => 'Código de ejemplo',
	'Save this field (s)' => 'Guardar este campo (s)', # Translate - New
	'field' => 'campo',
	'fields' => 'campos',
	'Delete this field (x)' => 'Borrar este campo (x)', # Translate - New

## addons/Commercial.pack/tmpl/reorder_fields.tmpl
	'Your field order has been saved. Please refresh this page to see the new order.' => 'Se ha guardado el orden de las entradas. Por favor, recargue la página para ver el nuevo ordenamiento.',
	'Reorder Fields' => 'Reordenar campos',
	'Save field order' => 'Guardar orden de los campos',
	'Close field order widget' => 'Cerrar widget de orden de los campos',
	'open' => 'abrir', # Translate - New
	'close' => 'cerrar', # Translate - Case
	'click-down and drag to move this field' => 'haga clic y arrastre el campo para moverlo', # Translate - New
	'click to %toggle% this box' => 'haga clic para %toggle% esta casilla', # Translate - New
	'use the arrow keys to move this box' => 'use las flechas para mover esta caja', # Translate - New
	', or press the enter key to %toggle% it' => ', o presione la tecla enter para %toggle%', # Translate - New

## addons/Commercial.pack/tmpl/list_field.tmpl
	'New [_1] Field' => 'Nuevo campo - [_1]',
	'Delete selected fields (x)' => 'Borrar campos seleccionados (x)',
	'No fields could be found.' => 'No se encontraron campos.',
	'System-Wide' => 'Todo el sistema',

## addons/Commercial.pack/tmpl/asset-chooser.tmpl
	'Choose [_1]' => 'Seleccionar [_1]',
	'Remove [_1]' => 'Borrar [_1]',

## addons/Commercial.pack/config.yaml

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
	'Users & Groups' => 'Usuarios y grupos',
	'Group Members' => 'Miembros del grupo',
	'Groups' => 'Grupos',
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

## addons/Enterprise.pack/tmpl/include/group_table.tmpl
	'group' => 'grupo',
	'groups' => 'grupos',
	'Enable selected group (e)' => 'Habilitar grupo seleccionado (e)', # Translate - New
	'Disable selected group (d)' => 'Deshabilitar grupo seleccionado (d)', # Translate - New
	'Remove selected group (d)' => 'Borrar grupo seleccionado (d)', # Translate - New
	'Only show enabled groups' => 'Solo muestra los grupos activados',
	'Only show disabled groups' => 'Solo muestra los grupos desactivados',

## addons/Enterprise.pack/tmpl/list_group.tmpl
	'[_1]: User&rsquo;s Groups' => 'Usuarios de los grupos [_1]',
	'Groups: System Wide' => 'Grupos: Todo el Sistema',
	'The user <em>[_1]</em> is currently disabled.' => 'El usuario <em>[_1]</em> está actualmente desactivado.',
	'Synchronize groups now' => 'Sincronizar los grupos ahora',
	'You have successfully disabled the selected group(s).' => 'usted ha desactivado el(los) grupo(s) seleccionado(s) con suceso',
	'You have successfully enabled the selected group(s).' => 'Usted ha activado el(los) grupo(s) seleccionad(s) con suceso',
	'You have successfully deleted the groups from the Movable Type system.' => 'Usted ha borrado con suceso los grupos del sistema Movable Type.',
	'You have successfully synchronized groups\' information with the external directory.' => 'Usted ha sincronizado con suceso la información de los grupos con el directorio externo.',
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
	'Group Disabled' => 'Grupo desactivado',
	'You have successfully deleted the users.' => 'Usted ha borrado con suceso los usuarios.',
	'You have successfully added new users to this group.' => 'Usted ha añadido con suceso nuevos usuarios a este grupo.',
	'You have successfully synchronized users\' information with external directory.' => 'Usted ha sincronizado con suceso las informaciones de los usuarios con el directorio externo.',
	'Some ([_1]) of the selected users could not be re-enabled because they were no longer found in LDAP.' => 'Algunos ([_1]) de los usuarios seleccionados no han podido ser reactivados porque no han sido encontrados en LDAP.',
	'You have successfully removed the users from this group.' => 'Usted ha borrado con suceso los usuarios de este grupo.',
	'member' => 'miembro',
	'Show Enabled Members' => 'Mostrar los miembros activados',
	'Show Disabled Members' => 'Mostrar los miembros desactivados',
	'Show All Members' => 'Mostrar todos los miembros',
	'You can not add users to a disabled group.' => 'Usted no puede añadir usuarios a un grupo desactivado.',
	'Add user to [_1]' => 'Añadir usuarios a [_1]',
	'None.' => 'Ninguno.',
	'(Showing all users.)' => '(Mostrar todos los usuarios.)',
	'Showing only users whose [_1] is [_2].' => 'Mostrar solo los usuarios que el [_1] es [_2].',
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
	'Updating...' => 'Actualizando...',

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
	'Save changes to this field (s)' => 'Guardar cambios del campo (s)', # Translate - New

## addons/Enterprise.pack/app-wizard.yaml
	'This module is required in order to use the LDAP Authentication.' => 'Este módulo es requerido para usar la identificación LDAP.',
	'This module is required in order to use SSL/TLS connection with the LDAP Authentication.' => 'Este módulo es necesario para usar la conexión SSL/TLS con la autentificación LDAP.',

## addons/Enterprise.pack/app-cms.yaml
	'Are you sure you want to delete the selected group(s)?' => '¿Está seguro de querer borrar el(los) grupo(s) seleccionados?',
	'Bulk Author Export' => 'Exportación masiva de autores',
	'Synchronize Users' => 'Sincronización de Usuarios',

## addons/Enterprise.pack/config.yaml
	'Enterprise Pack' => 'Enterprise Pack',
	'Oracle Database' => 'Base de Datos Oracle',
	'Microsoft SQL Server Database' => 'Base de Datos Microsoft SQL Server',
	'Microsoft SQL Server Database (UTF-8 support)' => 'Base de Datos Microsoft SQL Server (UTF-8 support)',
	'External Directory Synchronization' => 'Sincronización del Directorio Externo',
	'Populating author\'s external ID to have lower case user name...' => 'Introduciendo el ID externo del autor para usar minúsculas...',

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
	'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type?' => 'Feeds.App Lite le ayuda a publicar fuentes de sindicación en los blogs. ¿Desea hacer más cosas con fuentes en Movable Type?',
	'Upgrade to Feeds.App' => 'Actualícese a Feeds.App',
	'Create a Feed Widget' => 'Crear un widget de fuente',

## plugins/Cloner/cloner.pl
	'Clones a blog and all of its contents.' => 'Clona un blog y todos sus contenidos.', # Translate - New
	'Cloning blog \'[_1]\'...' => 'Clonando un blog',
	'Finished! You can <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">return to the blog listing</a> or <a href="javascript:void(0);" onclick="closeDialog(\'[_2]\');">configure the Site root and URL of the new blog</a>.' => '¡Finalizó! Puede <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">regresar a la lista de blogs</a> o <a href="javascript:void(0);" onclick="closeDialog(\'[_2]\');">configurar la Raíz del sitio y URL del nuevo blog</a>.',
	'No blog was selected to clone.' => 'Ningún blog ha sido seleccionado para ser clonado.',
	'This action can only be run for a single blog at a time.' => 'Esta acción solo puede ser ejecutada para un blog a la vez.',
	'Invalid blog_id' => 'blog_id no válido',
	'Clone Blog' => 'Clonar blog',

## plugins/Markdown/SmartyPants.pl
	'Easily translates plain punctuation characters into \'smart\' typographic punctuation.' => 'Traduce fácilmente los carácteres de puntuación clásicos dentro de \'inteligente\' tipografía de puntuación.',
	'Markdown With SmartyPants' => 'Markdown con SmartyPants',

## plugins/Markdown/Markdown.pl
	'A plain-text-to-HTML formatting plugin.' => 'Un plugin de formateo plain-text hacia HTML',
	'Markdown' => 'Markdown',

## plugins/WXRImporter/lib/WXRImporter/Import.pm

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'El fichero no está en el formato WXR.',
	'Duplicate asset (\'[_1]\') found.  Skipping.' => 'Se encontró un duplicado del fichero multimedia (\'[_1]\'). Ignorado.', # Translate - New
	'Saving asset (\'[_1]\')...' => 'Guardando elemento (\'[_1]\')...',
	' and asset will be tagged (\'[_1]\')...' => ' y el elemento será etiquetado (\'[_1]\')...',
	'Duplicate entry (\'[_1]\') found.  Skipping.' => 'Se encontró un duplicado de la entrada (\'[_1]\'). Ignorada.', # Translate - New
	'Saving page (\'[_1]\')...' => 'Guardando página (\'[_1]\')...',

## plugins/WXRImporter/tmpl/options.tmpl
	'Before you import WordPress posts to Movable Type, we recommend that you <a href=\'[_1]\'>configure your blog\'s publishing paths</a> first.' => 'Antes de importar las entradas de WordPress a Movable Type, le recomendamos que primero <a href=\'[_1]\'>configure las rutas de publicación del blog</a>.',
	'Upload path for this WordPress blog' => 'Ruta de transferencia para este blog de WordPress',
	'Replace with' => 'Reemplazar con',
	'Download attachments' => 'Descargar adjuntos', # Translate - New
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'Necesita el uso de una tarea del cron para descargar los adjuntos de un blog de WordPress en segundo plano.', # Translate - New
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'Descargar adjuntos (imágenes y ficheros) de un blog importado de WordPress.', # Translate - New

## plugins/WXRImporter/WXRImporter.pl
	'Import WordPress exported RSS into MT.' => 'Importar WordPress exported RSS hacia MT.',
	'WordPress eXtended RSS (WXR)' => 'RSS Extendido de WordPress (WXR)',
	'Download WP attachments via HTTP.' => 'Descargar adjuntos de WP vía HTTP.', # Translate - New

## plugins/TypePadAntiSpam/lib/TypePad/AntiSpam.pm
	'TypePad says ham' => 'TypePad dice ham', # Translate - New
	'TypePad says spam' => 'TypePad dice spam', # Translate - New

## plugins/TypePadAntiSpam/tmpl/system.tmpl
	'For many people, the TypePad Anti-Spam service will greatly reduce or even completely eliminate the comment and trackback spam you get on your sites. If one does happen to get through, simply mark it as "Junk" and TypePad will learn from its mistakes. Be careful not to junk any comments that are not spam. Note that this plugin requires a valid API key to operate.' => 'Para muchas personas, el servicio de TypePad de anti-spam reducirá considera o completamente los comentarios y trackbacks basura en los blogs. Si alguno pasa, solo tiene que marcarlo como "Basura" y TypePad aprenderá de sus fallos. Tenga cuidado no marcar comentarios que no sean spam. Tenga en cuenta que esta extensión necesita una clave válida de API para funcionar.', # Translate - New
	'API Key' => 'Clave de API', # Translate - New
	'Server' => 'Servidor', # Translate - New

## plugins/TypePadAntiSpam/tmpl/config.tmpl
	'Junk Score Weight' => 'Peso de la puntuación de basura', # Translate - New
	'Comments and TrackBacks receive a junk score between -10 (complete junk) and +10 (not junk). This setting allows you to control the weight of the TypePad Anti-Spam rating relative to other installed junk handlers.' => 'Los comentarios y los trackbacks reciben una puntuación de basura entre -10 (basura total) y +10 (no es basura). Esta opción le permite controlar el peso de la puntuación del anti-spam de TypePad en relación a los otros métodos instalados.', # Translate - New
	'Least Weight' => 'Peso menor', # Translate - New
	'Most Weight' => 'Peso mayor', # Translate - New

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'No se encontró el directorio mt-static. Por favor, configure el \'StaticFilePath\' para continuar.', # Translate - New
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'No se pudo crear el directorio [_1] - Compruebe que el servidor web puede escribir en la carpeta \'themes\'.',
	'Error downloading image: [_1]' => 'Error descargando imagen: [_1]',
	'Successfully applied new theme selection.' => 'Se aplicó con éxito la nueva selección de estilo.',
	'Invalid URL: [_1]' => 'URL no válida: [_1]',

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a Style' => 'Seleccione un estilo',
	'3-Columns, Wide, Thin, Thin' => '3 columnas, ancha, delgada, delgada',
	'3-Columns, Thin, Wide, Thin' => '3 columnas, delgada, ancha, delgada',
	'2-Columns, Thin, Wide' => '2 columnas, delgada, ancha',
	'2-Columns, Wide, Thin' => '3 columnas, ancha, delgada',
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
	'To prevent lookups for some IP addresses or domains, list them below. Place each entry on a line by itself.' => 'Para prevenir la comprobación de algunas direcciones IP o dominios, lístelos abajo. Por favor, introduzca cada entrada en una línea diferente.',

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
	'SpamLookup - Link' => 'SpamLookup - Enlace',
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

## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
	'Create MultiBlog Trigger' => 'Crear inductor de MultiBlog',

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'When' => 'Cuando',
	'Any Weblog' => 'Cualquier weblog',
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
	'Weblog Name' => 'Nombre del weblog',
	'Search Weblogs' => 'Buscar en weblogs',
	'When this' => 'Cuando este',
	'* All Weblogs' => '* Todos los weblogs',
	'Select to apply this trigger to all weblogs' => 'Selecciónelo para aplicar este inductor a todos los weblogs',
	'saves an entry' => 'guarda una entrada',
	'publishes an entry' => 'publica una entrada',
	'publishes a comment' => 'publica un comentario',
	'publishes a TrackBack' => 'publica un TrackBack',
	'rebuild indexes.' => 'reconstruye los índices.',
	'rebuild indexes and send pings.' => 'reconstruye los índices y envía pings.',

## plugins/Textile/textile2.pl
	'A humane web text generator.' => 'Un generador de texto web humano',
	'Textile 2' => 'Textile 2',

## plugins/WidgetManager/lib/WidgetManager/Plugin.pm
	'Can\'t find included template widget \'[_1]\'' => 'No se encontró la plantilla de widget \'[_1]\' incluída',
	'Cloning Widgets for blog...' => 'Clonar los Widgets para un blog...',

## plugins/WidgetManager/lib/WidgetManager/CMS.pm
	'Can\'t duplicate the existing \'[_1]\' Widget Manager. Please go back and enter a unique name.' => 'No se pudo duplicar el administrador de widgets existente \'[_1]\'. Por favor, regrese e introduzca un nombre único.',
	'Main Menu' => 'Menú principal',
	'Widget Manager' => 'Administrador de widgets',
	'New Widget Set' => 'Nuevo conjunto de widgets',
	'First Widget Manager' => 'Primer Administrador de Widgets',
	'2-column layout - Sidebar' => 'Disposición a 2 columnas - Barra lateral', # Translate - New
	'3-column layout - Primary Sidebar' => 'Disposición a 3 columnas - Barra lateral principal', # Translate - New
	'3-column layout - Secondary Sidebar' => 'Disposición a 3 columnas - Barra lateral secundaria', # Translate - New

## plugins/WidgetManager/default_widgets/monthly_archive_dropdown.mtml
	'Select a Month...' => 'Seleccione un mes...',

## plugins/WidgetManager/default_widgets/category_archive_list.mtml

## plugins/WidgetManager/default_widgets/calendar.mtml
	'Monthly calendar with links to daily posts' => 'Calendario mensual con enlaces a los archivos diarios', # Translate - New
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
	'Author Yearly Archives' => 'Archivos anuales por autor', # Translate - New
	'Author Weekly Archives' => 'Archivos semanales por autor', # Translate - New
	'Author Daily Archives' => 'Archivos diarios por autor', # Translate - New

## plugins/WidgetManager/default_widgets/main_index_meta_widget.mtml
	'This is a custom set of widgets that are conditioned to only appear on the homepage (or "main_index"). More info: [_1]' => 'Este es un conjunto personalizado de widgets creados para aparecer solo en la página de inicio (o "main_index"). Más información: [_1]', # Translate - New

## plugins/WidgetManager/default_widgets/syndication.mtml
	'Search results matching &ldquo;<$mt:SearchString$>&rdquo;' => 'Resultados de la búsqueda &ldquo;<$mt:SearchString$>&rdquo;', # Translate - New

## plugins/WidgetManager/default_widgets/current_category_monthly_archive_list.mtml

## plugins/WidgetManager/default_widgets/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] comentó en [_3]</a>: [_4]', # Translate - New

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
	'This is a custom set of widgets that are conditioned to serve different content based upon what type of archive it is included. More info: [_1]' => 'Conjunto personalizado de widgets creado para mostrar contenidos diferentes según el tipo de archivo que incluye. Más información: [_1]', # Translate - New

## plugins/WidgetManager/default_widgets/date_based_category_archives.mtml
	'Category Yearly Archives' => 'Archivos anuales por categoría', # Translate - New
	'Category Weekly Archives' => 'Archivos semanales por categoría', # Translate - New
	'Category Daily Archives' => 'Archivos diarios por categoría', # Translate - New

## plugins/WidgetManager/default_widgets/widgets.cfg
	'About This Page' => 'Página Sobre mi', # Translate - New
	'Current Author Monthly Archives' => 'Archivos mensuales del autor actual', # Translate - New
	'Calendar' => 'Calendario',
	'Category Archives' => 'Archivos por categoría', # Translate - New
	'Current Category Monthly Archives' => 'Archivos mensuales de la categoría actual', # Translate - New
	'Creative Commons' => 'Creative Commons',
	'Home Page Widgets' => 'Widgets de la página de inicio', # Translate - New
	'Monthly Archives Dropdown' => 'Desplegable de archivos mensuales', # Translate - New
	'Recent Assets' => 'Multimedia reciente', # Translate - New
	'Powered By' => 'Powered By', # Translate - Case
	'Syndication' => 'Sindicación', # Translate - New
	'Technorati Search' => 'Búsquedas en Technorati',
	'Date-Based Author Archives' => 'Archivos de autores por fecha', # Translate - Case
	'Date-Based Category Archives' => 'Archivos de categorías por fecha', # Translate - Case

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
	'Edit Widget Set' => 'Editar conjunto de widgets',
	'Please use a unique name for this widget set.' => 'Por favor, utilice un nombre único para este conjunto de widgets.',
	'You already have a widget set named \'[_1].\' Please use a unique name for this widget set.' => 'Ya tiene un conjunto de widgets llamado \'[_1].\'',
	'Your changes to the Widget Set have been saved.' => 'Se han guardado los cambios al conjunto de widgets.',
	'Set Name' => 'Nombre del conjunto',
	'Drag and drop the widgets you want into the Installed column.' => 'Arrastre y deje los widgets de su elección en la columna Instalada',
	'Installed Widgets' => 'Widgets instalados',
	'edit' => 'Editar',
	'Available Widgets' => 'Widgets disponibles',
	'Save changes to this widget set (s)' => 'Guardar cambios de este conjunto de widgets (s)', # Translate - New

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

#############################################

	'Main Index' => 'Inicio',
	'[_1] Comments' => '[_1] comentarios',
	'[_1] <a href="[_2]">Archives</a>' => '<a href="[_2]">Archivos</a> [_1]',
	'Need a Source URL (url).' => 'Necesita una URL de origen (url).',
	'Published [_1]' => '[_1] publicadas',
	'Unpublished [_1]' => '[_1] no publicadas',
	'Scheduled [_1]' => '[_1] programadas',
	'My [_1]' => 'Mis [_1]',
	'Blog Activity Feed' => 'Sindicación de Actividades del blog',
	'System Activity Feed' => 'Sindicación de la actividad',
	'Comments Activity Feed' => 'Sindicación de la actividad de comentarios',
	'TrackBack Activity Feed' => 'Sindicación de la actividad de TrackBacks',
	'[_1] Feed' => 'Sindicación de [_1]',
	'Authors' => 'Autores',
	'Adding new feature widget to dashboard...' => 'Añadiendo un nuevo widget al panel de control...',
	'Warnings and Log Messages' => 'Mensajes de alerta y registro',
	'IP Ban' => 'Bloqueo de IP',
	'IP Bans' => 'Bloqueos de IP',
	'Plugin Data' => 'Datos de la extensión',
	'yyyy/mm/dd/entry_basename.html' => 'aaaa/mm/dd/título_entrada.html',
	'YEARLY_ADV' => 'anuales',
	'MONTHLY_ADV' => 'mensuales',
	'CATEGORY_ADV' => 'por categoría',
	'PAGE_ADV' => 'por página',
	'INDIVIDUAL_ADV' => 'por entrada',
	'DAILY_ADV' => 'diarios',
	'WEEKLY_ADV' => 'semanales',
	'AUTHOR_ADV' => 'por mes y autor',
	'AUTHOR-YEARLY_ADV' => 'por año y autor',
	'AUTHOR-MONTHLY_ADV' => 'por mes y autor',
	'AUTHOR-WEEKLY_ADV' => 'por semana y autor',
	'AUTHOR-DAILY_ADV' => 'por día y autor',
	'CATEGORY-YEARLY_ADV' => 'por año y categoría',
	'CATEGORY-MONTHLY_ADV' => 'por mes y categoría',
	'CATEGORY-DAILY_ADV' => 'por día y categoría',
	'CATEGORY-WEEKLY_ADV' => 'por semana y categoría',
	'Entry Listing' => 'Listado de entradas',
	'Feed Subscription' => 'Suscripción de sindicación',
	'Trusted' => 'De confianza',
	'Activity Feed' => 'Sindicación de la actividad',
	'Dashboard' => 'Panel de Control',
	'Only show trusted commenters' => 'Mostrar solo comentaristas de confianza',
	'Blog Dashboard' => 'Panel de Control del blog',
	'Edit Address Book' => 'Editar agenda de direcciones',
	'Index Template: [_1]' => 'Plantilla índice: [_1]',
	'Only Indexes' => 'Solamente índices',
	'Only [_1] Archives' => 'Solamente archivos [_1]',
	'System Plugin Settings' => 'Configuración de las extensiones del sistema',
	'Plugin System' => 'Extensiones del sistema',
	'Manually enable or disable plugin-system functionality. Re-enabling plugin-system functionality, will return all plugins to their original state.' => 'Activa o desactiva manualmente las funcionalidades de las extensiones del sistema. La reactivación de las extensiones del sistema hace que las extensiones vuelvan a su estado original.',
	'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => 'Se reconfiguraron las extensiones. Debido a que está ejecutando mod_perl, deberá reiniciar el servidor web para que estos cambios tengan efecto.',
	'Archive map has been successfully updated.' => 'Se actualizaron con éxito los mapas de archivos.',
	'Auto-saving...' => 'Auto-guardando...',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Último guardado automático a las [_1]:[_2]:[_3]',
	'Select a Widget...' => 'Seleccione un widget...',
	'Your Dashboard has been updated.' => 'Se ha actualizado el Panel de Control.',
	'Your dashboard is empty!' => '¡Su panel de control está vacío!',
	'Only when attention is required' => 'Solo cuando se requiera atención',
	'All [_1]' => 'Todos los/las [_1]',
	'Trusted commenters only' => 'Solo comentaristas de confianza',
	'Auto-Link URLs' => 'Autoenlazar URLs',
	'No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed, and CaptchaSourceImageBase directive points to captcha-source directory under mt-static/images.' => 'No hay disponible ningún proveedor de CAPTCHA en este sistema. Por favor, compruebe que Image::Magick está instalado, y que la directiva CaptchaSourceImageBase apunta al directorio de origen de captchas en mt-static/images.',
	'Filtered Activity Feed' => 'Sindicación de la actividad del filtrado',
	'(Trusted)' => '(De confianza)',
	'Publishing [_1] [_2]...' => 'Publicando [_1] [_2]...',
	'Publishing [_1] dynamic links...' => 'Publicando [_1] enlace dinámico...',
	'Publishing [_1] archives...' => 'Publicando archivos [_1]...',
	'Publishing [_1] templates...' => 'Publicando plantillas [_1]...',
	'Re-Edit this [_1]' => 'Re-editar [_1]',
	'Re-Edit this [_1] (e)' => 'Re-editar [_1] (e)',
	'Personal blog clone source' => 'Blog original a clonar',
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
	'Create a widget from a feed' => 'Crear un widget de una fuente de sindicación',
	'Feed or Site URL' => 'URL del sitio o fuente',
	'Enter the URL of a feed, or the URL of a site that has a feed.' => 'Introduzca la URL de una fuente de sindicación, o la URL de un sitio que tenga una fuente.',

## plugins/feeds-app-lite/tmpl/select.tmpl
	'Multiple feeds were found' => 'Se encontraron múltiples fuentes',
	'Select the feed you wish to use. <em>Feeds.App Lite supports text-only RSS 1.0, 2.0 and Atom feeds.</em>' => 'Seleccione la fuente que desea usar. <em>Feeds.App Lite soporta las fuentes con solo texto RSS 1.0, 2.0 y Atom.',
	'URI' => 'URI',

## plugins/feeds-app-lite/mt-feeds.pl
	'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type?' => 'Feeds.App Lite le ayuda a publicar fuentes de sindicación en los blogs. ¿Desea hacer más cosas con fuentes en Movable Type?',
	'Upgrade to Feeds.App' => 'Actualícese a Feeds.App',
	'Create a Feed Widget' => 'Crear un widget de fuente',

	'2-Columns, Wide, Thin' => '2 columnas, ancha, delgada',
	'Edit Widget Set' => 'Editar widgets',
	'edit' => 'editar',

);

## New words: 1684

1;
