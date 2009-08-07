# Movable Type (r) Open Source (C) 2005-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
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

## php/lib/function.mtwidgetmanager.php
	'Error: widgetset [_1] is empty.' => 'Error: el conjunto de widgets [_1] está vacío',
	'Error compiling widgetset [_1]' => 'Error compilando el conjunto de widgets [_1]',

## php/lib/function.mtvar.php
	'You used a [_1] tag without a valid name attribute.' => 'Usó la etiqueta [_1] sin un nombre de atributo válido.',
	'\'[_1]\' is not a valid function for a hash.' => '\'[_1]\' no es una función válida para un hash.',
	'\'[_1]\' is not a valid function for an array.' => '\'[_1]\' no es una función válida para un array.',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] es ilegal.',

## php/lib/function.mtassettype.php
	'image' => 'Imagen',
	'Image' => 'Imagen',
	'file' => 'fichero',
	'File' => 'Fichero',
	'audio' => 'Audio',
	'Audio' => 'Audio',
	'video' => 'Vídeo',
	'Video' => 'Vídeo',

## php/lib/thumbnail_lib.php
	'GD support has not been available. Please install GD support.' => 'No tiene soporte de GD. Por favor, instale GD.',

## php/lib/function.mtcommentauthor.php
	'Anonymous' => 'Anónimo',

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'avatar-[_1]-%wx%h%x',

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

## php/lib/block.mtif.php

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'La autentificación de TypePad no está habilitada en este blog. No se puede usar MTRemoteSignInLink.',

## php/lib/block.mtauthorhaspage.php
	'No author available' => 'Ningún autor disponible',

## php/lib/block.mtsethashvar.php

## php/lib/block.mtauthorhasentry.php

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtcommentauthorlink.php

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Introduzca los caracteres que ve en la imagen de arriba.',

## php/lib/function.mtsetvar.php
	'\'[_1]\' is not a hash.' => '\'[_1]\' no es un hash.',
	'Invalid index.' => 'Índice no válido.',
	'\'[_1]\' is not an array.' => '\'[_1]\' no es un array.',
	'\'[_1]\' is not a valid function.' => '\'[_1]\' no es una función válida.',

## php/lib/block.mtassets.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" debe usarse en combinación con el espacio de nombres.',

## php/lib/block.mtsetvarblock.php

## php/lib/block.mtentries.php

## php/lib/function.mtauthordisplayname.php

## php/lib/function.mtentryclasslabel.php
	'page' => 'página',
	'entry' => 'entrada',
	'Entry' => 'Entrada',

## php/lib/function.mtcommentreplytolink.php
	'Reply' => 'Responder',

## php/mt.php.pre
	'Page not found - [_1]' => 'Página no encontrada - [_1]',

## default_templates/comments.mtml
	'1 Comment' => '1 comentario',
	'# Comments' => '# comentarios',
	'No Comments' => 'Sin comentarios',
	'Comment Detail' => 'Detalle del comentario',
	'The data is modified by the paginate script' => 'Los datos están modificados por el script de paginación', # Translate - New
	'Older Comments' => 'Más antiguos', # Translate - New
	'Newer Comments' => 'Más recientes', # Translate - New
	'Leave a comment' => 'Escribir un comentario',
	'Name' => 'Nombre',
	'Email Address' => 'Dirección de correo electrónico',
	'URL' => 'URL',
	'Remember personal info?' => '¿Recordar datos personales?',
	'Comments' => 'Comentarios',
	'(You may use HTML tags for style)' => '(Puede usar etiquetas HTML para el estilo)',
	'Preview' => 'Vista previa',
	'Submit' => 'Enviar',

## default_templates/search.mtml
	'Search' => 'Buscar',
	'Case sensitive' => 'Distinguir mayúsculas y minúsculas',
	'Regex search' => 'Expresión regular',
	'Tags' => 'Etiquetas',
	'[_1] ([_2])' => '[_1] ([_2])',

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

## default_templates/category_archive_list.mtml
	'Categories' => 'Categorías',

## default_templates/date_based_author_archives.mtml
	'Author Yearly Archives' => 'Archivos anuales por autor',
	'Author Monthly Archives' => 'Archivos mensuales por autores',
	'Author Weekly Archives' => 'Archivos semanales por autor',
	'Author Daily Archives' => 'Archivos diarios por autor',

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

## default_templates/comment_preview.mtml
	'Previewing your Comment' => 'Vista previa del comentario',
	'[_1] replied to <a href="[_2]">comment from [_3]</a>' => '[_1] respondió al <a href="[_2]">comentario de [_3]</a>',
	'Replying to comment from [_1]' => 'Respondiendo al comentario de [_1]',
	'Cancel' => 'Cancelar',

## default_templates/main_index_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to only appear on the homepage (or "main_index"). More info: [_1]' => 'Este es un conjunto personalizado de widgets creados para aparecer solo en la página de inicio (o "main_index"). Más información: [_1]',
	'Recent Comments' => 'Comentarios recientes',
	'Recent Entries' => 'Entradas recientes',
	'Recent Assets' => 'Multimedia reciente',
	'Tag Cloud' => 'Nube de etiquetas',

## default_templates/entry_summary.mtml
	'By [_1] on [_2]' => 'Por [_1] el [_2]',
	'1 TrackBack' => '1 TrackBack',
	'# TrackBacks' => '# TrackBacks',
	'No TrackBacks' => 'Sin trackbacks',
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

## default_templates/comment_listing_dynamic.mtml

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

## default_templates/banner_footer.mtml
	'_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.org/sitees/"><$MTProductName$></a>',
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Este blog tiene una <a href="[_1]">Licencia Creative Commons</a>.',

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

## default_templates/current_category_monthly_archive_list.mtml
	'[_1]' => '[_1]',

## default_templates/date_based_category_archives.mtml
	'Category Yearly Archives' => 'Archivos anuales por categoría',
	'Category Monthly Archives' => 'Archivos mensuales por categorías',
	'Category Weekly Archives' => 'Archivos semanales por categoría',
	'Category Daily Archives' => 'Archivos diarios por categoría',

## default_templates/recent_comments.mtml
	'<strong>[_1]:</strong> [_2] <a href="[_3]" title="full comment on: [_4]">read more</a>' => '<strong>[_1]:</strong> [_2] <a href="[_3]" title="comentario completo en: [_4]">más</a>',

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'Página no encontrada',

## default_templates/technorati_search.mtml
	'Technorati' => 'Technorati',
	'<a href=\'http://www.technorati.com/\'>Technorati</a> search' => 'Búsqueda en <a href=\'http://www.technorati.com/\'>Technorati</a>',
	'this blog' => 'este blog',
	'all blogs' => 'todos los blogs',
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

## default_templates/creative_commons.mtml

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

## default_templates/author_archive_list.mtml
	'Authors' => 'Autores',

## default_templates/archive_index.mtml
	'Author Archives' => 'Archivos por autor',

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
	'2-column layout - Sidebar' => 'Disposición a 2 columnas - Barra lateral',
	'3-column layout - Primary Sidebar' => 'Disposición a 3 columnas - Barra lateral principal',
	'3-column layout - Secondary Sidebar' => 'Disposición a 3 columnas - Barra lateral secundaria',

## default_templates/openid.mtml
	'[_1] accepted here' => '[_1] aceptado aquí',
	'http://www.sixapart.com/labs/openid/' => 'http://www.sixapart.com/labs/openid/',
	'Learn more about OpenID' => 'Más información sobre OpenID',

## default_templates/powered_by.mtml
	'_MTCOM_URL' => '_MTCOM_URL',

## default_templates/tag_cloud.mtml

## default_templates/commenter_confirm.mtml
	'Thank you registering for an account to comment on [_1].' => 'Gracias por registrar una cuenta para comentar en [_1].',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to comment on [_1].' => 'Para su propia seguridad, y para prevenir fraudes, antes de continuar le solicitamos que confirme su cuenta y dirección de correo. Tras confirmarlas, podrá comentar en [_1].',
	'To confirm your account, please click on or cut and paste the following URL into a web browser:' => 'Para confirmar su cuenta, haga clic en (o copie y pegue) la URL en un navegador web:',
	'If you did not make this request, or you don\'t want to register for an account to comment on [_1], then no further action is required.' => 'Si no realizó esta petición, o no quiere registrar una cuenta para comentar en [_1], no se necesitan más acciones.',
	'Thank you very much for your understanding.' => 'Gracias por su comprensión.',
	'Sincerely,' => 'Cordialmente,',

## default_templates/recent_assets.mtml

## default_templates/monthly_entry_listing.mtml

## lib/MT/IPBanList.pm
	'IP Ban' => 'Bloqueo de IP',
	'IP Bans' => 'Bloqueos de IP',

## lib/MT/BasicAuthor.pm
	'authors' => 'autores',

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

## lib/MT/Import.pm
	'Can\'t rewind' => 'No se pudo reiniciar',
	'Can\'t open \'[_1]\': [_2]' => 'No se pudo abrir \'[_1]\': [_2]',
	'Can\'t open directory \'[_1]\': [_2]' => 'No se puede abrir el directorio \'[_1]\': [_2]',
	'No readable files could be found in your import directory [_1].' => 'No se encontrón ningún fichero legible en su directorio de importación [_1].',
	'Importing entries from file \'[_1]\'' => 'Importando entradas desde el fichero \'[_1]\'',
	'Couldn\'t resolve import format [_1]' => 'No se pudo resolver el formato de importación [_1]',
	'Movable Type' => 'Movable Type',
	'Another system (Movable Type format)' => 'Otro sistema (formato Movable Type)',

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

## lib/MT/AtomServer.pm
	'[_1]: Entries' => '[_1]: Entradas',
	'PreSave failed [_1]' => 'Fallo en \'PreSave\' [_1]',
	'User \'[_1]\' (user #[_2]) added [lc,_4] #[_3]' => 'Usuario \'[_1]\' (usuario #[_2]) añadido [lc,_4] #[_3]',
	'User \'[_1]\' (user #[_2]) edited [lc,_4] #[_3]' => 'Usuario \'[_1]\' (usuario #[_2]) editado [lc,_4] #[_3]',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'El módulo de Perl Image::Size es necesario para obtener las dimensiones de las imágenes transferidas.',

## lib/MT/Bootstrap.pm
	'Got an error: [_1]' => 'Ocurrió un error en: [_1]',

## lib/MT/PluginData.pm
	'Plugin Data' => 'Datos de la extensión',

## lib/MT/Category.pm
	'Category' => 'Categoría',
	'Categories must exist within the same blog' => 'Las categorías deben existir en el mismo blog',
	'Category loop detected' => 'Bucle de categorías detectado',

## lib/MT/Asset.pm
	'Asset' => 'Multimedia',
	'Assets' => 'Multimedia',
	'Could not remove asset file [_1] from filesystem: [_2]' => 'No se pudo eliminar el fichero de medios [_1] del sistema de ficheros: [_2]',
	'Description' => 'Descripción',
	'Location' => 'Lugar',

## lib/MT/Compat/v3.pm
	'uses: [_1], should use: [_2]' => 'usa: [_1], debería usar: [_2]',
	'uses [_1]' => 'usa [_1]',
	'No executable code' => 'No es código ejecutable',
	'Publish-option name must not contain special characters' => 'El nombre de la opción de publicar no debe contener caracteres especiales',

## lib/MT/Permission.pm
	'Permission' => 'permiso',
	'Permissions' => 'Permisos',

## lib/MT/Image.pm
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

## lib/MT/Template/Context.pm
	'The attribute exclude_blogs cannot take \'all\' for a value.' => 'El atributo exclude_blogs no puede tomar el valor \'all\'.',
	'You used an \'[_1]\' tag outside of the context of a author; perhaps you mistakenly placed it outside of an \'MTAuthors\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un autor; ¿quizás la situó por error fuera de un contenedor \'MTAuthors\'?',
	'You used an \'[_1]\' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an \'MTEntries\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de una entrada; ¿quizás la puso por error fuera de un contenedor \'MTEntries\'?',
	'You used an \'[_1]\' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an \'MTComments\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un comentario; ¿quizás la puso por error fuera de un contenedor \'MTComments\'?',
	'You used an \'[_1]\' tag outside of the context of a ping; perhaps you mistakenly placed it outside of an \'MTPings\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un ping; ¿quizás la situó por error fuera de un contenedor \'MTPings\'?',
	'You used an \'[_1]\' tag outside of the context of an asset; perhaps you mistakenly placed it outside of an \'MTAssets\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un medio, ¿quizás la situó fuera de un contenedor \'MTAssets\'?',
	'You used an \'[_1]\' tag outside of the context of a page; perhaps you mistakenly placed it outside of a \'MTPages\' container?' => 'Ha usado una etiqueta \'[_1]\' fuera del contexto de una página; ¿quizás la situó fuera de un contenedor \'MTPages\'?',

## lib/MT/Template/ContextHandlers.pm
	'All About Me' => 'Todo sobre mi',
	'Remove this widget' => 'Eliminar el widget',
	'[_1]Publish[_2] your site to see these changes take effect.' => '[_1]Publique[_2] el sitio para que los cambios tomen efecto.',
	'Actions' => 'Acciones',
	'Warning' => 'Alerta',
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.org/documentation/appendices/tags/%t.html',
	'No [_1] could be found.' => 'No se encontraron [_1].',
	'records' => 'registros',
	'Invalid tag [_1] specified.' => 'Especificada etiqueta no válida [_1].',
	'No template to include specified' => 'No se especificó plantilla a incluir',
	'Recursion attempt on [_1]: [_2]' => 'Intento de recursión en [_1]: [_2]',
	'Can\'t find included template [_1] \'[_2]\'' => 'No se encontró la plantilla incluída [_1] \'[_2]\'',
	'Error making path \'[_1]\': [_2]' => 'Error creando la ruta \'[_1]\': [_2]',
	'Writing to \'[_1]\' failed: [_2]' => 'Fallo escribiendo en \'[_1]\': [_2]',
	'Can\'t find blog for id \'[_1]' => 'No se pudo encontrar un blog con el id \'[_1]',
	'Can\'t find included file \'[_1]\'' => 'No se encontró el fichero incluido \'[_1]\'',
	'Error opening included file \'[_1]\': [_2]' => 'Error abriendo el fichero incluido \'[_1]\': [_2]',
	'Recursion attempt on file: [_1]' => 'Intento de recursión en fichero: [_1]',
	'Unspecified archive template' => 'Archivo de plantilla no especificado',
	'Error in file template: [_1]' => 'Error en fichero de plantilla: [_1]',
	'Can\'t load template' => 'No se pudo cargar la plantilla',
	'Can\'t find template \'[_1]\'' => 'No se encontró la plantilla \'[_1]\'',
	'Can\'t find entry \'[_1]\'' => 'No se encontró la entrada \'[_1]\'',
	'[_1] is not a hash.' => '[_1] no es un hash.',
	'The \'[_2]\' attribute will only accept an integer: [_1]' => 'El atributo \'[_2]\' solo aceptará un entero: [_1]', # Translate - New
	'You have an error in your \'[_2]\' attribute: [_1]' => 'Tiene un error en el atributo \'[_2]\': [_1]',
	'No such user \'[_1]\'' => 'No existe el usario \'[_1]\'',
	'You used <$MTEntryFlag$> without a flag.' => 'Usó <$MTEntryFlag$> sin \'flag\'.',
	'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Usó una etiqueta [_1] enlazando los archivos \'[_2]\', pero el tipo de archivo no está publicado.',
	'Could not create atom id for entry [_1]' => 'No se pudo crear un identificador atom en la entrada [_1]',
	'Can\'t load blog #[_1].' => 'No se pudo cargar el blog nº[_1].',
	'To enable comment registration, you need to add a TypePad token in your weblog config or user profile.' => 'Para activar el registro de comentarios, debe añadir un token de TypePad a la configuración del weblog o al perfil de usuario.',
	'The MTCommentFields tag is no longer available; please include the [_1] template module instead.' => 'La etiqueta MTCommentFields no está más disponible; por favor incluya el módulo de platilla [_1] que lo remplaza',
	'Comment Form' => 'Formulario de comentarios',
	'You used an [_1] tag without a date context set up.' => 'Usó una etiqueta [_1] sin un contexto de fecha configurado.',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] sólo se puede usar con los archivos diarios, semanales o mensuales.',
	'Group iterator failed.' => 'Fallo en iterador de grupo.',
	'You used an [_1] tag outside of the proper context.' => 'Usó una etiqueta [_1] fuera del contexto correcto.',
	'Could not determine entry' => 'No se pudo determinar la entrada',
	'Invalid month format: must be YYYYMM' => 'Formato de mes no válido: debe ser YYYYMM',
	'No such category \'[_1]\'' => 'No existe la categoría \'[_1]\'',
	'[_1] cannot be used without publishing Category archive.' => '[_1] No se puede usar sin publicar archivos por categorías.',
	'<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> debe utilizarse en el contexto de una categoría, o con el atributo \'category\' en la etiqueta.',
	'[_1] used outside of [_2]' => '[_1] utilizado fuera de [_2]',
	'MT[_1] must be used in a [_2] context' => 'MT[_1] debe utilizarse en el contexto de [_2]',
	'Cannot find package [_1]: [_2]' => 'No se encontró el paquete [_1]: [_2]',
	'Error sorting [_2]: [_1]' => 'Error ordenando [_2]: [_1]',
	'You used an [_1] without a author context set up.' => 'Utilizó un [_1] sin establecer un contexto de autor.',
	'Can\'t load user.' => 'No se pudo cargar el usuario.',
	'Division by zero.' => 'División por cero.',
	'name is required.' => 'el nombre es obligatorio.',
	'Specified WidgetSet \'[_1]\' not found.' => 'No se encontró el conjunto de widgets \'[_1]\' que se especificó.',
	'Can\'t find included template widget \'[_1]\'' => 'No se encontró la plantilla de widget \'[_1]\' incluída',

## lib/MT/Session.pm
	'Session' => 'Sección',

## lib/MT/Plugin.pm
	'Publish' => 'Publicar',
	'My Text Format' => 'Mi formato de texto',

## lib/MT/WeblogPublisher.pm
	'Load of blog \'[_1]\' failed: [_2]' => 'La carga del blog \'[_1]\' falló: [_2]',
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
	'TrackBacks' => 'TrackBacks',

## lib/MT/Role.pm
	'Role' => 'Rol',
	'Roles' => 'Roles',

## lib/MT/Notification.pm
	'Contact' => 'Contacto',
	'Contacts' => 'Contactos',

## lib/MT/Entry.pm
	'Entries' => 'Entradas',
	'record does not exist.' => 'registro no existe.',
	'Draft' => 'Borrador',
	'Review' => 'Revisar',
	'Future' => 'Futuro',
	'Spam' => 'Spam',

## lib/MT/Upgrade.pm
	'Comment Posted' => 'Comentario publicado',
	'Your comment has been posted!' => '¡El comentario ha sido publicado!',
	'Comment Pending' => 'Comentario pendiente',
	'Your comment submission failed for the following reasons:' => 'El envío de su comentario falló por las siguientes razones:',
	'[_1]: [_2]' => '[_1]: [_2]',
	'Moving metadata storage for categories...' => 'Migrando los metadatos de las categorías...',
	'Upgrading metadata storage for [_1]' => 'Migrando los metadatos de [_1]',
	'Updating password recover email template...' => 'Actualizando la plantilla del correo de recuperación de contraseña...',
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
	'Can create entries, edit their own, upload files and publish.' => 'Puede crear entradas, editar las propias, subir ficheros y publicar.',
	'Designer' => 'Diseñador',
	'Can edit, manage and publish blog templates.' => 'Puede editar, administrar y publicar otra vez las plantillas del blog',
	'Webmaster' => 'Webmaster',
	'Can manage pages and publish blog templates.' => 'Puede administrar las páginas y publicar otra vez las plantillas del blog',
	'Contributor' => 'Colaborador',
	'Can create entries, edit their own and comment.' => 'Puede crear entradas, editar las propias y comentar.',
	'Moderator' => 'Moderador',
	'Can comment and manage feedback.' => 'Puede comentar y administrar las respuestas.',
	'Commenter' => 'Comentarista',
	'Can comment.' => 'Puede comentar.',
	'Removing Dynamic Site Bootstrapper index template...' => 'Borrando plantilla índice del arranque dinámico...',
	'Creating new template: \'[_1]\'.' => 'Creando nueva plantilla: \'[_1]\'.',
	'Mapping templates to blog archive types...' => 'Mapeando plantillas con tipos de archivo de blogs...',
	'Renaming PHP plugin file names...' => 'Renombrando nombre de ficheros de la extensión de PHP...',
	'Error renaming PHP files. Please check the Activity Log.' => 'Error al renombrar ficheros PHP. Por favor, compruebe el registro de actividad.',
	'Cannot rename in [_1]: [_2].' => 'No se pudo renombrar en [_1]: [_2].',
	'Removing unnecessary indexes...' => 'Eleminando índices innecesarios...',
	'Upgrading table for [_1] records...' => 'Actualización de las tablas para los registros [_1]...',
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
	'Assigning entry comment and TrackBack counts...' => 'Asignando totales de comentarios y trackbacks de las entradas...',
	'Error saving [_1] record # [_3]: [_2]...' => 'Error guardando registro [_1] # [_3]: [_2]...',
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
	'Assigning blog page layout...' => 'Asignando disposición de las páginas...',
	'Assigning author basename...' => 'Asignando nombre base a los autores...',
	'Assigning embedded flag to asset placements...' => 'Asignando marca a los elementos empotrados...',
	'Updating template build types...' => 'Actualizando los tipos de publicación de las plantillas...',
	'Replacing file formats to use CategoryLabel tag...' => 'Reemplazando los formatos de fichero para usar la etiqueta CategoryLabel...',

## lib/MT/Comment.pm
	'Comment' => 'Comentario',
	'Load of entry \'[_1]\' failed: [_2]' => 'Fallo al cargar la entrada \'[_1]\': [_2]',

## lib/MT/Core.pm
	'System Administrator' => 'Administrador del sistema',
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
	'Manage Users' => 'Administrar usuarios',
	'Create Entries' => 'Crear entradas',
	'Publish Entries' => 'Publicar entradas',
	'Send Notifications' => 'Enviar notificaciones',
	'Edit All Entries' => 'Editar todas las entradas',
	'Manage Pages' => 'Administrar páginas',
	'Publish Blog' => 'Publicar el Blog',
	'Upload File' => 'Transferir fichero',
	'Save Image Defaults' => 'Guardar opciones de imagen',
	'Manage Assets' => 'Administrar multimedia',
	'Post Comments' => 'Comentarios',
	'Manage Feedback' => 'Administrar respuestas',
	'Error creating performance logs directory, [_1]. Please either change the permissions to make it writable or specify an alternate using the PerformanceLoggingPath configuration directive: [_2]' => 'Error al crear el directorio de registros de rendimiento, [_1]. Por favor, cambie los permisos de escritura del directorio o especifique una ruta alternativa utilizando la directiva PerformanceLoggingPath en la configuración: [_2]',
	'Error creating performance logs: PerformanceLoggingPath setting must be a directory path, not a file: [_1]' => 'Error creando los registros de rendimiento: la directiva PerformanceLoggingPath debe ser un directorio, no un fichero: [_1]',
	'Error creating performance logs: PerformanceLoggingPath directory exists but is not writeable: [_1]' => 'Error creando los registros de rendimiento: el directorio PerformanceLoggingPath existe, pero no se puede escribir en él: [_1]',
	'MySQL Database' => 'Base de datos MySQL',
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
	'Refreshes object summaries.' => 'Refresca el resumen de los objetos.', # Translate - New
	'Adds Summarize workers to queue.' => 'Añade trabajadores a la cola para los resúmenes.', # Translate - New
	'zip' => 'zip',
	'tar.gz' => 'tar.gz',
	'Entries List' => 'Lista de entradas',
	'Blog URL' => 'URL del blog',
	'Blog ID' => 'ID del blog',
	'Blog Name' => 'Nombre del blog',
	'Entry Body' => 'Cuerpo de la entrada',
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
	'Add Summary Watcher to queue' => 'Añadir un vigilante de resúmenes a la cola', # Translate - New
	'Junk Folder Expiration' => 'Caducidad de la carpeta basura',
	'Remove Temporary Files' => 'Borrar ficheros temporales',
	'Remove Expired User Sessions' => 'Borrar sesiones de usuario caducadas',
	'Remove Expired Search Caches' => 'Borrar cachés de búsquedas caducadas',

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
	'Invalid request' => 'Petición no válida',
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
	'No entry_id' => 'Sin entry_id',
	'No such entry \'[_1]\'.' => 'No existe la entrada \'[_1]\'.',
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
	'Publish failed: [_1]' => 'Falló la publicación: [_1]',
	'Failed comment attempt by pending registrant \'[_1]\'' => 'Falló el intento de comentar por el comentarista pendiente \'[_1]\'',
	'Registered User' => 'Usuario registrado',
	'The sign-in attempt was not successful; please try again.' => 'El intento de registro no tuvo éxito; por favor, inténtelo de nuevo.',
	'Can\'t load entry #[_1].' => 'No se pudo cargar la entrada #[_1].',
	'No entry was specified; perhaps there is a template problem?' => 'No se especificó ninguna entrada; ¿quizás hay un problema con la plantilla?',
	'Somehow, the entry you tried to comment on does not exist' => 'De alguna manera, la entrada en la que intentó comentar no existe',
	'Invalid entry ID provided' => 'ID de entrada provisto no válido',
	'All required fields must have valid values.' => 'Todos los campos obligatorios deben tener valores válidos.',
	'[_1] contains an invalid character: [_2]' => '[_1] contiene un caracter no válido: [_2]',
	'Display Name' => 'Nombre público',
	'Passwords do not match.' => 'Las contraseñas no coinciden.',
	'Email Address is invalid.' => 'La dirección de correo no es válida.',
	'URL is invalid.' => 'La URL no es válida.',
	'Commenter profile has successfully been updated.' => 'Se actualizó con éxito el perfil del comentarista.',
	'Commenter profile could not be updated: [_1]' => 'No se pudo actualizar el perfil del comentarista: [_1]',

## lib/MT/App/Search.pm
	'Invalid [_1] parameter.' => 'Parámetro [_1] no válido',
	'Invalid type: [_1]' => 'Tipo no válido: [_1]',
	'Invalid request.' => 'Petición no válida.',
	'Search: failed storing results in cache.  [_1] is not available: [_2]' => 'Búsqueda: Fallo al guardar los resultados en la cache. [_1] no está disponible: [_2]',
	'Invalid format: [_1]' => 'Formato no válido: [_1]',
	'Unsupported type: [_1]' => 'Tipo no soportado: [_1]',
	'Invalid query: [_1]' => 'Consulta no válida: [_1]',
	'Invalid archive type' => 'Tipo de archivo no válido', # Translate - New
	'Invalid value: [_1]' => 'Valor no válido: [_1]',
	'No column was specified to search for [_1].' => 'No se especificó ninguna columna para la búsqueda de [_1].',
	'Search: query for \'[_1]\'' => 'Búsqueda: encontrar \'[_1]\'',
	'No alternate template is specified for the Template \'[_1]\'' => 'No se especificó una plantilla alternativa para la Plantilla \'[_1]\'',
	'Opening local file \'[_1]\' failed: [_2]' => 'Fallo abriendo el fichero local \'[_1]\': [_2]',
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
	'Failed to authenticate using given credentials: [_1].' => 'Fallo al autentificar con las credenciales ofrecidas: [_1].',
	'You failed to validate your password.' => 'Falló al validar la contraseña.',
	'You failed to supply a password.' => 'No introdujo una contraseña.',
	'The e-mail address is required.' => 'La dirección de correo electrónico es necesaria.',
	'The path provided below is not writable.' => 'No se puede escribir en la ruta provista abajo.',
	'Invalid session.' => 'Sesión no válida.',
	'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Sin permisos. Por favor, contacte con su administrador para la actualización de Movable Type.',
	'Movable Type has been upgraded to version [_1].' => 'Movable Type ha sido actualizado a la versión [_1].',

## lib/MT/App/Search/Legacy.pm
	'You are currently performing a search. Please wait until your search is completed.' => 'En estos momentos está realizando una búsqueda. Por favor, espere hasta que se complete.',
	'Search failed. Invalid pattern given: [_1]' => 'Falló la búsqueda. Patrón no válido: [_1]',
	'Search failed: [_1]' => 'Falló la búsqueda: [_1]',
	'Publishing results failed: [_1]' => 'Fallo al publicar los resultados: [_1]',
	'Search: new comment search' => 'Búsqueda: nueva búsqueda de comentarios',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearch funciona con MT::App::Search.',

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
	'HTML::Parser is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'HTML::Parser es opcional; Es necesario si desea usar el sistema de TrackBacks, el ping a weblogs.com o el ping a las actualizaciones recientes de MT.',
	'This module is needed if you wish to use the MT XML-RPC server implementation.' => 'Este módulo es necesario si desea usar la implementación del servidor XML-RPC de MT.',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Este módulo es necesario si desea poder sobreescribir los ficheros al subirlos.',
	'List::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'Lista: Útiles opcionales; esto es necesario si usted desea utilizar la función cola de publicación',
	'Scalar::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'Scalar::Util es opcional. Es necesario si quiere usar la Cola de Publicación.',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Este módulo es necesario si desea poder crear miniaturas de las imágenes subidas.',
	'This module is needed if you would like to be able to use NetPBM as the image driver for MT.' => 'Este módulo es necesario si desea usar NetPBM como controlador de imágenes en MT.',
	'This module is required by certain MT plugins available from third parties.' => 'Este módulo lo necesitan algunas extensiones de MT de terceras partes.',
	'This module accelerates comment registration sign-ins.' => 'Este módulo acelera el registro de identificación en los comentarios.',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers such as AOL and Yahoo! which require SSL support.' => 'Este módulo y sus dependencias son necesarios para permitir a los comentaristas que se autentifiquen mediante proveedores de OpenID, como AOL y Yahoo!, lo que requiere soporte de SSL.',
	'This module is needed to enable comment registration.' => 'Este módulo es necesario para habilitar el registro en los comentarios.',
	'This module enables the use of the Atom API.' => 'Este módulo permite el uso del interfaz (API) de Atom.',
	'This module is required in order to archive files in backup/restore operation.' => 'Este módulo es necesario para archivar ficheros en las operaciones de copias de seguridad y restauración.',
	'This module is required in order to compress files in backup/restore operation.' => 'Este módulo es ncesario para comprimir ficheros en operaciones de copias de seguridad y restauración.',
	'This module is required in order to decompress files in backup/restore operation.' => 'Este módulo es neesario para descomprimir ficheros en las operaciones de copia de seguridad y restauración.',
	'This module and its dependencies are required in order to restore from a backup.' => 'Este módulo y sus dependencias son necesarios para restaurar una copia de seguridad.',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including Vox and LiveJournal.' => 'Este módulo y sus dependencias son necesarios para permitir que los comentaristas se autentifiquen a través de proveedores de OpenID, incluyendo Vox y LiveJournal.',
	'This module is required for sending mail via SMTP Server.' => 'Este módulo es necesario para el envío de correo a través de servidores SMTP.',
	'This module is used in test attribute of MTIf conditional tag.' => 'Este módulo se utiliza en el atributo test de la etiqueta MTIf.',
	'This module is used by the Markdown text filter.' => 'El filtro de textos Markdown utiliza este módulo.',
	'This module is required in mt-search.cgi if you are running Movable Type on Perl older than Perl 5.8.' => 'mt-search.cgi necesita este módulo si está usando Movable Type con una versión de Perl más antigua de la 5.8.',
	'This module required for action streams.' => 'Este módulo es necesario para los torrentes de acciones.', # Translate - New
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Este módulo es necesario para subir archivos (para determinar el tamaño de las imágenes en diferentes formatos).',
	'This module is required for cookie authentication.' => 'Este módulo es necesario para la autentificación con cookies.',
	'DBI is required to store data in database.' => 'DBI es necesario para guardar información en bases de datos.',
	'CGI is required for all Movable Type application functionality.' => 'El CGI es requerido para todas las funciones del Sistema Movable Type.',
	'File::Spec is required for path manipulation across operating systems.' => 'File::Spec es requerido para la manipulación de la ubición de los archivos en el sistema operativo.',

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
	'Published [_1]' => '[_1] publicadas',
	'Unpublished [_1]' => '[_1] no publicadas',
	'Scheduled [_1]' => '[_1] programadas',
	'My [_1]' => 'Mis [_1]',
	'[_1] with comments in the last 7 days' => '[_1] con comentarios en los últimos 7 días',
	'[_1] posted between [_2] and [_3]' => '[_1] publicado entre [_2] y [_3]',
	'[_1] posted since [_2]' => '[_1] publicado hace [_2]',
	'[_1] posted on or before [_2]' => '[_1] publicando en o antes de [_2]',
	'All comments by [_1] \'[_2]\'' => 'Todos los comentarios de [_1] \'[_2]\'',
	'All comments for [_1] \'[_2]\'' => 'Todos los comentarios de [_1] \'[_2]\'',
	'Comments posted between [_1] and [_2]' => 'Comentarios publicados entre [_1] y [_2]',
	'Comments posted since [_1]' => 'Comentarios publicados desde [_1]',
	'Comments posted on or before [_1]' => 'Commentarios publicados en o antes de [_1]',
	'You are not authorized to log in to this blog.' => 'No está autorizado para acceder a este blog.',
	'No such blog [_1]' => 'No existe el blog [_1]',
	'Edit Template' => 'Editar plantilla',
	'Go Back' => 'Ir atrás',
	'Unknown object type [_1]' => 'Tipo de objeto desconocido [_1]',
	'None' => 'Ninguno',
	'Error during publishing: [_1]' => 'Error durante la publicación: [_1]',
	'This is You' => 'Este es Usted',
	'Handy Shortcuts' => 'Enlaces útiles',
	'Movable Type News' => 'Noticias de Movable Type',
	'Blog Stats' => 'Estadísticas',
	'Refresh Blog Templates' => 'Recargar plantillas de blogs',
	'Refresh Global Templates' => 'Recargar plantillas globales',
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
	'Clone Blog' => 'Clonar blog',
	'Publish Template(s)' => 'Publicar plantilla/s',
	'Clone Template(s)' => 'Clonar plantilla/s',
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
	'Comments in the last 7 days' => 'Comentarios en los últimos 7 días',
	'Tags with entries' => 'Etiquetas con entradas',
	'Tags with pages' => 'Etiquetas con páginas',
	'Tags with assets' => 'Etiquetas con ficheros multimedia',
	'Enabled Users' => 'Usuarios habilitados',
	'Disabled Users' => 'Usuarios deshabilitados',
	'Pending Users' => 'Usuarios pendientes',
	'Commenters' => 'Comentaristas',
	'Create' => 'Crear',
	'Manage' => 'Administrar',
	'Design' => 'Diseño',
	'Preferences' => 'Preferencias',
	'Tools' => 'Herramientas',
	'User' => 'Usuario',
	'Blogs' => 'Blogs',
	'Users' => 'Usuarios',
	'Folders' => 'Carpetas',
	'Address Book' => 'Agenda',
	'Templates' => 'Plantillas',
	'Widgets' => 'Widgets',
	'General' => 'General',
	'Feedback' => 'Respuestas',
	'Publishing' => 'Publicación',
	'Registration' => 'Registro',
	'Web Services' => 'Servicios web',
	'IP Banning' => 'Bloqueo de IPs',
	'Plugins' => 'Extensiones',
	'Activity Log' => 'Actividad',
	'Schwartz Errors' => 'Errores de Schwartz', # Translate - New
	'Import' => 'Importar',
	'Export' => 'Exportar',
	'Backup' => 'Copia de seguridad',
	'Restore' => 'Restaurar',
	'System Information' => 'Información del sistema',
	'System Overview' => 'Resumen del sistema',
	'Global Templates' => 'Plantillas globales',
	'Settings' => 'Configuración',

## lib/MT/App/ActivityFeeds.pm
	'Error loading [_1]: [_2]' => 'Error cargando [_1]: [_2]',
	'An error occurred while generating the activity feed: [_1].' => 'Ocurrió un error mientras se generaba la fuente de actividad: [_1].',
	'No permissions.' => 'Sin permisos.',
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

## lib/MT/Auth.pm
	'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Configuración incorrecta de AuthenticationModule \'[_1]\': [_2]',
	'Bad AuthenticationModule config' => 'Configuración incorrecta de AuthenticationModule',

## lib/MT/ObjectTag.pm
	'Tag Placement' => 'Gestión de Etiqueta',
	'Tag Placements' => 'Gestión de las Etiquetas',

## lib/MT/Author.pm
	'The approval could not be committed: [_1]' => 'La aprobación no pudo realizarse: [_1]',

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

## lib/MT/Scorable.pm
	'Object must be saved first.' => 'Primero debe guardarse el objeto.',
	'Already scored for this object.' => 'Ya puntuado en este objeto.',
	'Could not set score to the object \'[_1]\'(ID: [_2])' => 'No pudo darse puntuación al objeto \'[_1]\'(ID: [_2])',

## lib/MT/XMLRPC.pm
	'No WeblogsPingURL defined in the configuration file' => 'WeblogsPingURL no está definido en el fichero de configuración',
	'No MTPingURL defined in the configuration file' => 'MTPingURL no está definido en el fichero de configuración',
	'HTTP error: [_1]' => 'Error HTTP: [_1]',
	'Ping error: [_1]' => 'Error de ping: [_1]',

## lib/MT/Config.pm
	'Configuration' => 'Configuración',

## lib/MT/ObjectAsset.pm
	'Asset Placement' => 'Posición del elemento multimedia',

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

## lib/MT/FileMgr/SFTP.pm
	'SFTP connection failed: [_1]' => 'Fallo en la conexión SFTP: [_1]',
	'SFTP get failed: [_1]' => 'Falló la orden \'get\' en el SFTP: [_1]',
	'SFTP put failed: [_1]' => 'Falló la orden \'put\' en el SFTP: [_1]',

## lib/MT/Component.pm
	'Loading template \'[_1]\' failed: [_2]' => 'Fallo cargando plantilla \'[_1]\': [_2]',

## lib/MT/BackupRestore.pm
	'Backing up [_1] records:' => 'Haciendo la copia de seguridad de [_1] registros:',
	'[_1] records backed up...' => '[_1] registros guardados...',
	'[_1] records backed up.' => '[_1] registros guardados..',
	'There were no [_1] records to be backed up.' => 'No habían [_1] registros de los que hacer copia de seguridad.',
	'No manifest file could be found in your import directory [_1].' => 'No se encontró fichero de manifiesto en el directorio de importación [_1].',
	'Can\'t open [_1].' => 'No se pudo abrir [_1].',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'El fichero [_1] no es un fichero válido de manifiesto para copias de seguridad de Movable Type.',
	'Manifest file: [_1]' => 'Fichero de manifiesto: [_1]',
	'Path was not found for the file ([_1]).' => 'No se encontró la ruta del archivo ([_1]).',
	'[_1] is not writable.' => 'No puede escribirse en [_1].',
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
	'Associations' => 'Asociaciones',
	'association' => 'Asociación',
	'associations' => 'Asociaciones',

## lib/MT/DefaultTemplates.pm
	'Archive Index' => 'Índice de archivos',
	'Stylesheet' => 'Hoja de estilo',
	'JavaScript' => 'JavaScript',
	'Feed - Recent Entries' => 'Sindicación - Entradas recientes',
	'RSD' => 'RSD',
	'Monthly Entry Listing' => 'Lista mensual de entradas',
	'Category Entry Listing' => 'Lista de entradas por categorías',
	'Comment Listing (Dynamic)' => 'Lista de comentarios (dinámica)', # Translate - New
	'Improved listing of comments.' => 'Lista mejorada de comentarios.', # Translate - New
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
	'Password Recovery' => 'Recuperación de contraseña',
	'Subscribe Verify' => 'Verificación de suscripciones',

## lib/MT/Blog.pm
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
	'blog' => 'Blog',
	'blogs' => 'blogs',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: [_2][_3] de la regla [_4][_5]',
	'[_1]: [_2][_3] from test [_4]' => '[_1]: [_2][_3] de la prueba [_4]',

## lib/MT/XMLRPCServer.pm
	'Invalid timestamp format' => 'Formato de fecha no válido',
	'No web services password assigned.  Please see your user profile to set it.' => 'No se ha establecido la contraseña de servicios web.  Por favor, vaya al perfil de su usario para configurarla.',
	'Requested permalink \'[_1]\' is not available for this page' => 'El enlace permanente solicitado \'[_1]\' no está disponible para esta página',
	'Saving folder failed: [_1]' => 'Fallo al guardar la carpeta: [_1]',
	'Saving placement failed: [_1]' => 'Fallo guardando situación: [_1]',
	'No blog_id' => 'Sin blog_id',
	'Invalid blog ID \'[_1]\'' => 'Identificador de blog  \'[_1]\' no válido',
	'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => 'El valor de \'mt_[_1]\' debe ser 0 ó 1 (era \'[_2]\')',
	'Not privileged to edit entry' => 'No tiene permisos para editar la entrada',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'Entrada \'[_1]\' ([lc,_5] #[_2]) borrada por \'[_3]\' (usuario #[_4]) para xml-rpc',
	'Not privileged to get entry' => 'No tiene permisos para obtener la entrada',
	'Not privileged to set entry categories' => 'No tiene permisos para establecer categorías en las entradas',
	'Not privileged to upload files' => 'No tiene privilegios para transferir ficheros',
	'No filename provided' => 'No se especificó el nombre del fichero ',
	'Invalid filename \'[_1]\'' => 'Nombre de fichero no válido \'[_1]\'',
	'Error writing uploaded file: [_1]' => 'Error escribiendo el fichero transferido: [_1]',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Los métodos de las plantillas no están implementados, debido a las diferencias entre Blogger API y Movable Type API.',

## lib/MT/TBPing.pm

## lib/MT/Template.pm
	'Template' => 'plantilla',
	'File not found: [_1]' => 'Fichero no encontrado: [_1]',
	'Error reading file \'[_1]\': [_2]' => 'Error leyendo fichero \'[_1]\': [_2]',
	'Publish error in template \'[_1]\': [_2]' => 'Error de publicación en la plantilla \'[_1]\': [_2]',
	'Template with the same name already exists in this blog.' => 'Ya existe una plantilla con el mismo nombre en este blog.',
	'You cannot use a [_1] extension for a linked file.' => 'No puede usar una extensión [_1] para un fichero enlazado.',
	'Opening linked file \'[_1]\' failed: [_2]' => 'Fallo abriendo fichero enlazado\'[_1]\': [_2]',
	'Index' => 'Índice',
	'Archive' => 'Archivo',
	'Category Archive' => 'Archivo de categorías',
	'Comment Listing' => 'Lista de comentarios',
	'Ping Listing' => 'Lista de pings',
	'Comment Error' => 'Error de comentarios',
	'Uploaded Image' => 'Imagen transferida',
	'Module' => 'Módulo',
	'Widget' => 'Widget',

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
	'Failed to verify current password.' => 'Fallo al verificar la contraseña actual.',

## lib/MT/ImportExport.pm
	'No Blog' => 'Sin Blog',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'Si va a crear nuevos usuarios por cada usuario listado en su blog, debe proveer una contraseña.',
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

## lib/MT/Builder.pm
	'<[_1]> at line [_2] is unrecognized.' => 'No se reconoció a <[_1]> en la línea [_2].',
	'<[_1]> with no </[_1]> on line #' => '<[_1]> sin </[_1]> en la línea #',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]> sin </[_1]> en la línea [_2].',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]> sin </[_1]> en la línea [_2]',
	'Error in <mt[_1]> tag: [_2]' => 'Error en la etiqueta <mt[_1]>: [_2]',
	'Unknown tag found: [_1]' => 'Se encontró una etiqueta desconocida: [_1]',

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

## lib/MT/TheSchwartz/Error.pm
	'Job Error' => 'Error en la Tarea',

## lib/MT/TheSchwartz/FuncMap.pm
	'Job Function' => 'Funciones de la Tarea',

## lib/MT/TheSchwartz/Job.pm
	'Job' => 'Tarea',

## lib/MT/TheSchwartz/ExitStatus.pm
	'Job Exit Status' => 'Status Fin de Tarea',

## lib/MT/Mail.pm
	'Unknown MailTransfer method \'[_1]\'' => 'MailTransfer método desconocido \'[_1]\'',
	'Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]' => 'El envío de mensajes a través de SMTP necesita que su servidor tenga Mail::Sendmail instalado: [_1]',
	'Error sending mail: [_1]' => 'Error enviado correo: [_1]',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'No tiene configurada una ruta válida a sendmail en su máquina. ¿Quizás está intentando usar SMTP?',
	'Exec of sendmail failed: [_1]' => 'Fallo la ejecución de sendmail: [_1]',

## lib/MT/ObjectScore.pm
	'Object Score' => 'Score del Objeto',
	'Object Scores' => 'Scores de los Objetos',

## lib/MT/ObjectDriver/Driver/DBD/SQLite.pm

## lib/MT/CMS/Search.pm
	'No [_1] were found that match the given criteria.' => 'Ningún [_1] ha sido encontrado que corresponda al criterio dado.',
	'No permissions' => 'No tiene permisos',
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
	'Username' => 'Nombre de usuario',
	'Site URL' => 'URL del sitio',
	'Site Root' => 'Raíz del sitio',
	'Search & Replace' => 'Buscar & Reemplazar',
	'Invalid date(s) specified for date range.' => 'Se especificaron fechas no válidas para el rango.',
	'Error in search expression: [_1]' => 'Error en la expresión de búsqueda: [_1]',
	'Saving object failed: [_2]' => 'Fallo al guardar objeto: [_2]',

## lib/MT/CMS/RptLog.pm
	'RPT Log' => 'Histórico RPT', # Translate - New
	'System RPT Feed' => 'Sindicación del sistema RPT', # Translate - New

## lib/MT/CMS/Import.pm
	'Import/Export' => 'Importar/Exportar',
	'Please select a blog.' => 'Por favor, seleccione un blog.',
	'You do not have import permissions' => 'No tiene permisos de importación',
	'You do not have permission to create users' => 'No tiene permisos para crear usarios',
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
	'Error saving entry: [_1]' => 'Error guardando entrada: [_1]',
	'Error saving file: [_1]' => 'Error guardando fichero: [_1]',
	'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Etiqueta \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',

## lib/MT/CMS/Template.pm
	'index' => 'índice',
	'archive' => 'archivo',
	'module' => 'módulo',
	'widget' => 'widget',
	'email' => 'correo electrónico',
	'system' => 'sistema',
	'One or more errors were found in this template.' => 'Se encontraron uno o más errores en esta plantilla.',
	'Create template requires type' => 'Crear plantillas requiere el tipo',
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
	'Populating blog with default templates failed: [_1]' => 'Falló el guardando del blog con las plantillas por defecto: [_1]',
	'Setting up mappings failed: [_1]' => 'Fallo la configuración de mapeos: [_1]',
	'Saving map failed: [_1]' => 'Fallo guardando mapa: [_1]',
	'You should not be able to enter 0 as the time.' => 'No debería poder introducir 0 en estos momentos.',
	'You must select at least one event checkbox.' => 'Debe seleccionar al menos una casilla de eventos.',
	'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Plantilla \'[_1]\' (ID:[_2]) creada por \'[_3]\'',
	'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Plantilla \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
	'No Name' => 'Sin nombre',
	'Orphaned' => 'Huérfano',
	' (Backup from [_1])' => ' (Copia de [_1])',
	'Error creating new template: ' => 'Error creando nueva plantilla: ',
	'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Ignorando plantilla \'[_1]\' ya que parecer ser una plantilla personalizada.',
	'Refreshing template <strong>[_3]</strong> with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>' => 'Reactualizar los modelos <strong>[_3]</strong> desde <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">guardar</a>',
	'Skipping template \'[_1]\' since it has not been changed.' => 'Ignorando la plantilla \'[_1]\' ya que no ha sido modificada.',
	'Copy of [_1]' => 'Copia de [_1]',
	'Cannot publish a global template.' => 'No se puede publicar una plantilla global.', # Translate - New
	'Permission denied: [_1]' => 'Permiso denegado: [_1]',
	'Save failed: [_1]' => 'Fallo al guardar: [_1]',
	'Invalid ID [_1]' => 'ID inválido [_1]',
	'Saving object failed: [_1]' => 'Fallo guardando objeto: [_1]',
	'Load failed: [_1]' => 'Fallo carga: [_1]',
	'(no reason given)' => '(ninguna razón ofrecida)',
	'Removing [_1] failed: [_2]' => 'Falló el borrado de [_1]: [_2]',
	'template' => 'plantilla',
	'Restoring widget set [_1]... ' => 'Restaurando el conjunto de widgets [_1]... ',
	'Failed.' => 'Fallo.',

## lib/MT/CMS/Category.pm
	'Subfolder' => 'Subcarpeta',
	'Subcategory' => 'Subcategoría',
	'Saving [_1] failed: [_2]' => 'Falló al guardar [_1]: [_2]',
	'The [_1] must be given a name!' => '¡Debe dar un nombre a [_1]!',
	'Add a [_1]' => 'Añador un [_1]',
	'No label' => 'Sin título',
	'Category name cannot be blank.' => 'El nombre de la categoría no puede estar en blanco.',
	'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'El nombre de la categría \'[_1]\' tiene conflicto con otra categoría. Las categorías de primer nivel y las sub-categorías con el mismo padre deben tener nombres únicos.',
	'The category basename \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => 'El nombre base de la categoría \'[_1]\' tiene conflictos con otra categoría. Las categorías de primer nivel y las sub-categorías con el mismo padre deben tener nombres base únicos.',
	'Category \'[_1]\' created by \'[_2]\'' => 'Categoría \'[_1]\' creada por \'[_2]\'',
	'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Categoría \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',

## lib/MT/CMS/User.pm
	'Create User' => 'Crear usuario',
	'Can\'t load role #[_1].' => 'No se pudo cargar el rol #[_1].',
	'Create Role' => 'Crear rol',
	'(user deleted)' => '(usario borrado)',
	'*User deleted*' => '*Usuario borrado*',
	'(newly created user)' => '(nuevo usuario creado)',
	'User Associations' => 'Asociaciones de usuario',
	'Role Users & Groups' => 'Roles de usuarios y grupos',
	'(Custom)' => '(Personalizado)',
	'The user' => 'El usuario',
	'Role name cannot be blank.' => 'El nombre del rol no puede estar vacío.',
	'Another role already exists by that name.' => 'Ya existe otro rol con ese nombre.',
	'You cannot define a role without permissions.' => 'No puede definir un rol sin permisos.',
	'General Settings' => 'Configuración general',
	'Invalid ID given for personal blog clone source ID.' => 'Se introdujo un ID no válido para el ID de blog fuente de clonación.',
	'If personal blog is set, the default site URL and root are required.' => 'Si se selecciona un blog personal, se necesitará su URL predefinida y raíz.',
	'Select a entry author' => 'Seleccione un autor de entradas',
	'Selected author' => 'Autor seleccionado',
	'Type a username to filter the choices below.' => 'Introduzca un nombre de usuario para filtrar las opciones.',
	'Entry author' => 'Autor de entradas',
	'Select a System Administrator' => 'Seleccione un Administrador del Sistema',
	'Selected System Administrator' => 'Administrador del Sistema seleccionado',
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
	'You cannot delete your own association.' => 'No puede borrar sus propias asociaciones.',
	'You cannot delete your own user record.' => 'No puede borrar el registro de su propio usario.',
	'You have no permission to delete the user [_1].' => 'No tiene permisos para borrar el usario [_1].',
	'User requires username' => 'El usario necesita un nombre de usuario',
	'User requires display name' => 'El usuario necesita un nombre público',
	'A user with the same name already exists.' => 'Ya existe un usuario con el mismo nombre.',
	'User requires password' => 'El usario necesita una contraseña',
	'Email Address is required for password recovery' => 'La dirección de correo es necesaria para la recuperación de la contraseña',
	'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Usuario \'[_1]\' (ID:[_2]) creado por \'[_3]\'',
	'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Usuario \'[_1]\' (ID:[_2]) borrado por \'[_3]\'',

## lib/MT/CMS/Asset.pm
	'Files' => 'Ficheros',
	'Can\'t load file #[_1].' => 'No se pudo cargar el fichero nº[_1].',
	'File \'[_1]\' uploaded by \'[_2]\'' => 'Fichero \'[_1]\' transferido por \'[_2]\'',
	'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Fichero \'[_1]\' (ID:[_2]) transferido por \'[_3]\'',
	'All Assets' => 'Todos los ficheros multimedia',
	'Untitled' => 'Sin título',
	'Archive Root' => 'Raíz de archivos',
	'Please select a file to upload.' => 'Por favor, seleccione el fichero a transferir',
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
	'Uploaded file is not an image.' => 'El fichero transferido no es una imagen.',
	'<' => '<',
	'/' => '/',

## lib/MT/CMS/Log.pm
	'All Feedback' => 'Todas las opiniones',
	'System Activity Feed' => 'Sindicación de la actividad',
	'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'El registro de actividad del blog \'[_1]\' (ID:[_2]) fue reiniciado por  \'[_3]\'',
	'Activity log reset by \'[_1]\'' => 'Registro de actividad reiniciado por \'[_1]\'',

## lib/MT/CMS/Export.pm
	'You do not have export permissions' => 'No tiene permisos de exportación',

## lib/MT/CMS/Blog.pm
	'Publishing Settings' => 'Configuración de publicación',
	'Plugin Settings' => 'Configuración de extensiones',
	'New Blog' => 'Nuevo blog',
	'Blog Activity Feed' => 'Sindicación de Actividades del blog',
	'Can\'t load template #[_1].' => 'No se pudo cargar la plantilla #[_1].',
	'index template \'[_1]\'' => 'plantilla índice \'[_1]\'',
	'[_1] \'[_2]\'' => '[_1] \'[_2]\'',
	'Publish Site' => 'Publicar sitio',
	'Invalid blog' => 'Blog no válido',
	'Select Blog' => 'Seleccione blog',
	'Selected Blog' => 'Blog seleccionado',
	'Type a blog name to filter the choices below.' => 'Introduzca un nombre de blog para filtrar las opciones de abajo.',
	'Saved Blog Changes' => 'Cambios del blog guardados', # Translate - New
	'Saving permissions failed: [_1]' => 'Fallo guardando permisos: [_1]',
	'Blog \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) creado por \'[_3]\'',
	'You did not specify a blog name.' => 'No especificó el nombre del blog.',
	'Site URL must be an absolute URL.' => 'La URL del sitio debe ser una URL absoluta.',
	'Archive URL must be an absolute URL.' => 'La URL de archivo debe ser una URL absoluta.',
	'You did not specify an Archive Root.' => 'No ha especificado un Archivo raíz.',
	'Blog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) borrado por \'[_3]\'',
	'Saving blog failed: [_1]' => 'Fallo guardando blog: [_1]',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Error: Movable Type no puede escribir en el directorio de caché de las plantillas. Por favor, compruebe los permisos del directorio llamado <code>[_1]</code> dentro del directorio de su blog.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Error: Movable Type no pudo crear un directorio para cachear las plantillas dinámicas. Debe crear un directorio llamado <code>[_1]</code> dentro del directorio de su blog.',

## lib/MT/CMS/TrackBack.pm
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
	'Better, Stronger, Faster' => 'Mejor, más potente, más rápido',
	'Movable Type has undergone a significant overhaul in all aspects of performance. Memory utilization has been reduced, publishing times have been increased significantly and search is now 100x faster!' => 'Se ha realizado una importante revisión en todos los aspectos relacionados con el rendimiento de Movable Type. ¡Se ha reducido la utilización de memoria, el tiempo de publicación y ahora la búsqueda es 100 veces más rápida!',
	'Module Caching' => 'Caché de módulos',
	'Template module and widget content can now be cached in the database to dramatically speed up publishing.' => 'Para acelerar la publicación, hora se cachean en la base de datos los módulos de las plantillas y los contenidos de los widgets.',
	'Improved Template and Design Management' => 'Mejora dela gestión de las plantillas y los diseños',
	'The template editing interface has been enhanced to make designers more efficient at updating their site\'s design. The default templates have also been dramatically simplified to make it easier for you to edit and create the site you want.' => 'Se ha mejorado el interfaz de la edición de plantillas para aumentar la productividad de los diseñadores a la hora de actualizar el diseño del sitio. También se han simplificado las plantillas predefinidas para facilitar la edición y creación del sitio.',
	'Threaded Comments' => 'Hilos de comentarios',
	'Allow commenters on your blog to reply to each other increasing user engagement and creating more dynamic conversations.' => 'Permita que los comentaristas de su blog se respondan mutuamente y hagan más dinámicas las conversaciones.',

## lib/MT/CMS/Common.pm
	'Error' => 'Error',
	'Cloning blog \'[_1]\'...' => 'Clonando un blog',
	'Finished! You can <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">return to the blog listing</a> or <a href="javascript:void(0);" onclick="closeDialog(\'[_2]\');">configure the Site root and URL of the new blog</a>.' => '¡Finalizó! Puede <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">regresar a la lista de blogs</a> o <a href="javascript:void(0);" onclick="closeDialog(\'[_2]\');">configurar la Raíz del sitio y URL del nuevo blog</a>.',
	'Close' => 'Cerrar',
	'Permisison denied.' => 'Permiso denegado.',
	'The Template Name and Output File fields are required.' => 'Los campos del nombre de la plantilla y el fichero de salida son obligatorios.',
	'Invalid type [_1]' => 'Tipo inválido [_1]',
	'Invalid parameter' => 'Parámetro no válido',
	'Notification List' => 'Lista de notificaciones',
	'Removing tag failed: [_1]' => 'Falló el borrado de la etiqueta: [_1]',
	'Loading MT::LDAP failed: [_1].' => 'Falló la carga de MT::LDAP: [_1].',
	'System templates can not be deleted.' => 'Las plantillas del sistema no se pueden borrar.',
	'No blog was selected to clone.' => 'Ningún blog ha sido seleccionado para ser clonado.',
	'This action can only be run on a single blog at a time.' => 'Esta acción solo puede realizarse en un solo blog a la vez.', # Translate - New
	'Invalid blog_id' => 'blog_id no válido',
	'The Site URL matches the original blog' => 'La URL del sitio coincide con la original del blog', # Translate - New
	'You need to specify a Site URL' => 'Debe especificar la URL del sitio', # Translate - New
	'The Site Path matches the original blog' => 'La ruta del sitio coincide con la original del blog', # Translate - New
	'You need to specify a Site Path' => 'Debe especificar una ruta para el sitio', # Translate - New
	'Entries must be cloned if trackbacks or comments are cloned' => 'Las entradas deben clonarse si se clonan los trackbacks o los comentarios', # Translate - New
	'Entries must be cloned if comments are cloned' => 'Las entradas deben clonarse si se clonan los comentarios', # Translate - New
	'Entries must be cloned if trackbacks are cloned' => 'Las entradas deben clonarse si se clonan los trackbacks', # Translate - New

## lib/MT/CMS/BanList.pm
	'You did not enter an IP address to ban.' => 'No tecleó una dirección IP para bloquear.',
	'The IP you entered is already banned for this blog.' => 'La IP que introdujo ya está bloqueada en este blog.',

## lib/MT/CMS/Plugin.pm
	'Plugin Set: [_1]' => 'Conjuntos de extensiones: [_1]',
	'Individual Plugins' => 'Extensiones individuales',

## lib/MT/CMS/AddressBook.pm
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
	'You don\'t have a system email address configured.  Please set this first, save it, then try the test email again.' => 'No tiene configurado la dirección de correo del sistema. Por favor, configúrela, guárdela e intente de nuevo enviar el correo de prueba.', # Translate - New
	'Please enter a valid email address' => 'Por favor, introduzca una dirección de correo válida', # Translate - New
	'Test email from Movable Type' => 'Correo de prueba de Movable Type', # Translate - New
	'This is the test email sent by your installation of Movable Type.' => 'Este es el correo de prueba enviado por su instalación de Movable Type.', # Translate - New
	'Mail was not properly sent' => 'El correo no se envió correctamente', # Translate - New
	'Invalid password recovery attempt; can\'t recover password in this configuration' => 'Intento de recuperación de contraseña no válido; no se pudo recuperar la clave con esta configuración',
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
	'Detailed information is in the <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>activity log</a>.' => 'La información detallada se encuentra en el <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>registro de actividad</a>.',
	'[_1] has canceled the multiple files restore operation prematurely.' => '[_1] canceló prematuramente la operación de restauración de varios ficheros.',
	'Changing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Modificando la Ruta del Sitio del blog \'[_1]\' (ID:[_2])...',
	'Removing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Borrando la Ruta del Sitio del blog \'[_1]\' (ID:[_2])...',
	'Changing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Modificando la Ruta de Archivos del blog \'[_1]\' (ID:[_2])...',
	'Removing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Borrando la Ruta de Archivos del blog \'[_1]\' (ID:[_2])...',
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
	'User does not have email address' => 'El usario sin dirección de correo electrónico',
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
	'pages' => 'páginas',
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
	'Saving entry \'[_1]\' failed: [_2]' => 'Fallo guardando entrada \'[_1]\': [_2]',
	'Removing placement failed: [_1]' => 'Fallo eliminando lugar: [_1]',
	'Ping \'[_1]\' failed: [_2]' => 'Falló ping \'[_1]\' : [_2]',
	'(user deleted - ID:[_1])' => '(usuario borrado - ID:[_1])',
	'<a href="[_1]">QuickPost to [_2]</a> - Drag this link to your browser\'s toolbar then click it when you are on a site you want to blog about.' => '<a href="[_1]">QuickPost en [_2]</a> - Arrastre este enlace a la barra de herramientas de su navegador y haga clic en él cuando desee publicar una entrada sobre la página que visita.',
	'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Entrada \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
	'Need a status to update entries' => 'Necesita indicar un estado para actualizar las entradas',
	'Need entries to update status' => 'Necesita entradas para actualizar su estado',
	'One of the entries ([_1]) did not actually exist' => 'Una de las entradas ([_1]) no existe actualmente',
	'[_1] \'[_2]\' (ID:[_3]) status changed from [_4] to [_5]' => '[_1] \'[_2]\' (ID:[_3]) cambió de estado de [_4] a [_5]',

## lib/MT/CMS/Comment.pm
	'Edit Comment' => 'Editar comentario',
	'Orphaned comment' => 'Comentario huérfano',
	'Comments Activity Feed' => 'Sindicación de la actividad de comentarios',
	'Authenticated Commenters' => 'Comentaristas autentificados',
	'No such commenter [_1].' => 'No existe el comentarista [_1].',
	'User \'[_1]\' trusted commenter \'[_2]\'.' => 'Usuario \'[_1]\' confió en el comentarista \'[_2]\'.',
	'User \'[_1]\' banned commenter \'[_2]\'.' => 'Usuario \'[_1]\' bloqueó al comentarista \'[_2]\'.',
	'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'Usuario \'[_1]\' desbloqueó al comentarista \'[_2]\'.',
	'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'Usuario \'[_1]\' desconfió del comentarista \'[_2]\'.',
	'Feedback Settings' => 'Configuración de respuestas',
	'Parent comment id was not specified.' => 'ID de comentario padre no se especificó.',
	'Parent comment was not found.' => 'El comentario padre no se encontró.',
	'You can\'t reply to unapproved comment.' => 'No puede responder a un comentario no aprobado.',
	'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Comentario (ID:[_1]) por \'[_2]\' borrado por \'[_3]\' de la entrada \'[_4]\'',
	'You don\'t have permission to approve this comment.' => 'No tiene permiso para aprobar este comentario.',
	'Comment on missing entry!' => '¡Comentario en entrada inexistente!',
	'You can\'t reply to unpublished comment.' => 'No puede contestar a comentarios no publicados.',

## lib/MT/Folder.pm

## lib/MT/Tag.pm
	'Tag must have a valid name' => 'La etiqueta debe tener un nombre válido',
	'This tag is referenced by others.' => 'Esta etiqueta está referenciada por otros.',

## lib/MT/Worker/Publish.pm
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- conjunto completo ([quant,_1,fichero,ficheros] en [_2] segundos)',

## lib/MT/Worker/Sync.pm
	'Synchrnizing Files Done' => 'Sincronización de ficheros realizada',
	'Done syncing files to [_1] ([_2])' => 'Ficheros sincronizados en [_1] ([_2])',

## lib/MT/App.pm
	'Invalid request: corrupt character data for character set [_1]' => 'Petición inválida: caracteres corruptos para el conjunto de caracteres [_1]',
	'First Weblog' => 'Primer weblog',
	'Error loading blog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => 'Error de telécargamiento #[_1] que comprende la creación de Usuarios. Por favor, verifique sus parámetros NewUserTemplateBlogId.',
	'Error provisioning blog for new user \'[_1]\' using template blog #[_2].' => 'Se ha producido un error durante la creación del blog del nuevo usuario \'[_1]\' utilizando la plantilla #[_2].',
	'Error creating directory [_1] for blog #[_2].' => 'Error creando el directorio [_1] para el blog #[_2].',
	'Error provisioning blog for new user \'[_1] (ID: [_2])\'.' => 'Se ha producido un error durante la creación del blog del nuevo usuario \'[_1] (ID: [_2])\'.',
	'Blog \'[_1] (ID: [_2])\' for user \'[_3] (ID: [_4])\' has been created.' => 'Blog \'[_1] (ID: [_2])\' para el usuario \'[_3] (ID: [_4])\' ha sido creado.',
	'Error assigning blog administration rights to user \'[_1] (ID: [_2])\' for blog \'[_3] (ID: [_4])\'. No suitable blog administrator role was found.' => 'Error de asignación de los derechos para el usuario \'[_1] (ID: [_2])\' para el blog \'[_3] (ID: [_4])\'. Ningún rol de administrador adecuado ha sido encontrado.',
	'The login could not be confirmed because of a database error ([_1])' => 'No se pudo confirmar el acceso debido a un error de la base de datos ([_1])',
	'Our apologies, but you do not have permission to access any blogs within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Lo sentimos, pero no tiene permisos para acceder a ninguno de los blogs en esta instalación. Si cree que este mensaje se le muestra por error, por favor, contacte con su administrador de Movable Type.',
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

## lib/MT.pm.pre
	'Powered by [_1]' => 'Powered by [_1]',
	'Version [_1]' => 'Versión [_1]',
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype/',
	'OpenID URL' => 'URL de OpenID',
	'Sign in using your OpenID identity.' => 'Identifíquese usando OpenID.',
	'OpenID is an open and decentralized single sign-on identity system.' => 'OpenID es un sistema abierto y descentralizado de identificación.',
	'Sign in' => 'Registrarse',
	'Learn more about OpenID.' => 'Más información sobre OpenID.',
	'Your LiveJournal Username' => 'Su usuario de LiveJournal',
	'Learn more about LiveJournal.' => 'Más información sobre LiveJournal.',
	'Your Vox Blog URL' => 'La URL de su blog de Vox',
	'Learn more about Vox.' => 'Más información sobre Vox.',
	'Sign in using your Gmail account' => 'Identifíquese usando su cuenta de Gmail',
	'Sign in to Movable Type with your[_1] Account[_2]' => 'Identifíquese en Movable Type con su cuenta [_1] [_2]',
	'Turn on OpenID for your Yahoo! account now' => 'Active ahora OpenID para su cuenta de Yahoo',
	'Your AIM or AOL Screen Name' => 'Su usuario de AIM o AOL',
	'Sign in using your AIM or AOL screen name. Your screen name will be displayed publicly.' => 'Identifíquese usando su usuario de AIM o AOL. El nombre del usuario se mostrará públicamente.',
	'Your Wordpress.com Username' => 'Su usuario de Wordpress.com',
	'Sign in using your WordPress.com username.' => 'Identifíquese usando su usuario de WordPress.com.',
	'TypePad is a free, open system providing you a central identity for posting comments on weblogs and logging into other websites. You can register for free.' => 'TypePad es un sistema gratuito y abierto que le provee una identidad centralizada para la publicación de comentarios en weblogs e identificarse en otros sitios web. Puede registrarse gratuitamente.',
	'Sign in or register with TypePad.' => 'Identifíquese o regístrese en TypePad.',
	'Turn on OpenID for your Yahoo! Japan account now' => 'Active OpenID en su cuenta de Yahoo! Japan ahora',
	'Your Hatena ID' => 'Su ID de Hatena',
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
	'__PORTAL_URL__' => '__PORTAL_URL__',
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

## mt-static/js/dialog.js
	'(None)' => '(Ninguno)',

## mt-static/js/assetdetail.js
	'No Preview Available' => 'Sin vista previa disponible',
	'View uploaded file' => 'Mostrar fichero transferido',

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
	'Confirm your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click \'Retry\'.' => 'Confirme el servidor web puede escribir en el directorio de inicio de [_1] (el directorio que contiene mt.cgi) y luego haga clic en \'Reintentar\'.',
	'Congratulations! You\'ve successfully configured [_1].' => '¡Felicidades! Ha configurado con éxito [_1].',
	'Your configuration settings have been written to the following file:' => 'Sus parámetros de configuración han sido escritos en los siguientes archivos:',
	'To reconfigure the settings, click the \'Back\' button below.' => 'Para reconfigurar sus parámetros, haga clic en el botón \'Volver\' aquí abajo.',
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
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => 'Una configuración del archivo (mt-config,cgi) existe, <a href="[_1]>identificarse</a> a Movable Type.',
	'To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page' => 'Para crear una nueva configuración del archivo usando Wizard, borre la configuración actual del archivo y actualice la página',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Movable Type necesita que JavaScript esté disponible en el navegador. Por favor, active JavaScript y recargue esta página para continuar.',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Este asistente le ayudará a configurar las opciones básicas necesarias para ejecutar Movable Type.',
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

## tmpl/wizard/blog.tmpl
	'Setup Your First Blog' => 'Configure su primer blog',
	'In order to properly publish your blog, you must provide Movable Type with your blog\'s URL and the path on the filesystem where its files should be published.' => 'Para publicar correctamente el blog, debe proveer a Movable Type la URL del blog y la ruta en el sistema donde se publicarán sus ficheros.',
	'My First Blog' => 'Mi primer blog',
	'Publishing Path' => 'Ruta de publicación',
	'Your \'Publishing Path\' is the path on your web server\'s file system where Movable Type will publish all the files for your blog. Your web server must have write access to this directory.' => 'La \'Ruta de publicación\' es la ruta en el sistema de archivos del servidor donde Movable Type publicará todos los ficheros del blog. El servidor web debe poder escribir en este directorio.',

## tmpl/cms/edit_role.tmpl
	'Edit Role' => 'Editar rol',
	'Your changes have been saved.' => 'Sus cambios han sido guardados.',
	'List Roles' => 'Listar roles',
	'[quant,_1,User,Users] with this role' => '[quant,_1,User,Users] con este rol',
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'Ha cambiado los provilegios de este rol.  Esto va cambiar las posibilidades de maniobra de los usuarios asociados a este rol. Si usted prefiere, puede guardar este rol con otro nombre diferente.',
	'Role Details' => 'Detalles de los roles',
	'Created by' => 'Creado por',
	'System' => 'Sistema',
	'Privileges' => 'Privilegios',
	'Check All' => 'Seleccionar todos',
	'Uncheck All' => 'Deseleccionar todos',
	'Administration' => 'Administración',
	'Authoring and Publishing' => 'Creación y publicación',
	'Designing' => 'Diseño',
	'Commenting' => 'Comentar',
	'Duplicate Roles' => 'Duplicar roles',
	'These roles have the same privileges as this role' => 'Estos roles tienen privilegios parecidos a este rol',
	'Save changes to this role (s)' => 'Guardar cambios en el rol (s)',
	'Save Changes' => 'Guardar cambios',

## tmpl/cms/list_association.tmpl
	'Members' => 'Miembros',
	'permission' => 'permiso',
	'permissions' => 'permisos',
	'Remove selected permissions (x)' => 'Remove selected permissions (x)',
	'Revoke Permission' => 'Revocar permiso',
	'[_1] <em>[_2]</em> is currently disabled.' => '[_1] <em>[_2]</em> está momentáneamente indisponible',
	'Grant Permission' => 'Otorgar permiso',
	'You can not create permissions for disabled users.' => 'No puede crear permisos para los usuarios deshabilitados.',
	'Assign Role to User' => 'Asignar rol al usuario',
	'Add a user to this blog' => 'Añadir un usuario a este blog',
	'Grant permission to a user' => 'Otorgar permiso a un usuario',
	'You have successfully revoked the given permission(s).' => 'Otorgó los permisos con éxito.',
	'You have successfully granted the given permission(s).' => 'Revocó los permisos con éxito.',
	'No permissions could be found.' => 'No se encontraron permisos.',
	'Created By' => 'Creado por',
	'Created On' => 'Creado en',

## tmpl/cms/cfg_plugin.tmpl
	'System Plugin Settings' => 'Configuración de las extensiones del sistema',
	'Useful links' => 'Enlaces útiles',
	'http://plugins.movabletype.org/' => 'http://plugins.movabletype.org/',
	'Find Plugins' => 'Buscar extensiones',
	'Plugin System' => 'Extensiones del sistema',
	'Manually enable or disable plugin-system functionality. Re-enabling plugin-system functionality, will return all plugins to their original state.' => 'Activa o desactiva manualmente las funcionalidades de las extensiones del sistema. La reactivación de las extensiones del sistema hace que las extensiones vuelvan a su estado original.',
	'Disable plugin functionality' => 'Desactivar las funciones de las extensiones',
	'Disable Plugins' => 'Desactivar extensiones',
	'Enable plugin functionality' => 'Activar las funciones de las extensiones',
	'Enable Plugins' => 'Activar extensiones',
	'Your plugin settings have been saved.' => 'Se guardó la configuración de la extensión.',
	'Your plugin settings have been reset.' => 'Se reinició la configuración de la extensión.',
	'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => 'Se reconfiguraron las extensiones. Debido a que está ejecutando mod_perl, deberá reiniciar el servidor web para que estos cambios tengan efecto.',
	'Your plugins have been reconfigured.' => 'Se reconfiguraron las extensiones.',
	'Are you sure you want to reset the settings for this plugin?' => '¿Está seguro de que desea reiniciar la configuración de esta extensión?',
	'Are you sure you want to disable plugin functionality?' => '¿Está seguro de querer desactivar la funcinalidad de las extensiones?',
	'Disable this plugin?' => '¿Desactivar esta extensión?',
	'Are you sure you want to enable plugin functionality? (This will re-enable any plugins that were not individually disabled.)' => '¿Está seguro de querer artivar la funcionalidad de las extensiones?  (Esto reactivará cada extensión que no haya sido desactivada individualmente.)',
	'Enable this plugin?' => '¿Activar esta extensión?',
	'Failed to Load' => 'Falló al cargar',
	'(Disable)' => '(Desactivado)',
	'Enabled' => 'Activado',
	'Disabled' => 'Desactivado',
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

## tmpl/cms/login.tmpl
	'Your Movable Type session has ended.' => 'Finalizó su sesión en Movable Type.',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Su sesión de Movable Type finalizó. Si desea identificarse de nuevo, hágalo abajo.',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Su sesión de Movable Type finalizó. Por favor, identifíquese de nuevo para continuar con esta acción.',
	'Forgot your password?' => '¿Olvidó su contraseña?',
	'Sign In (s)' => 'Identifíquese (s)',

## tmpl/cms/list_blog.tmpl
	'You have successfully deleted the blogs from the Movable Type system.' => 'Eliminó correctamente los weblogs.',
	'You have successfully refreshed your templates.' => 'Ha refrescado con éxito las plantillas.',
	'You can not refresh templates: [_1]' => 'No puede refrescar las plantillas: [_1]',
	'Create Blog' => 'Crear blog',

## tmpl/cms/edit_asset.tmpl
	'Edit Asset' => 'Editar multimedia',
	'Your asset changes have been made.' => 'Se han guardado los cambios del fichero multimedia.',
	'Stats' => 'Estadísticas',
	'[_1] - Created by [_2]' => '[_1] - Creado por [_2]',
	'[_1] - Modified by [_2]' => '[_1] - Modificado por [_2]',
	'Appears in...' => 'Aparece en...',
	'Published on [_1]' => 'Publicado en [_1]',
	'Show all entries' => 'Mostrar todas las categorías',
	'Show all pages' => 'Mostrar todas las páginas',
	'This asset has not been used.' => 'Este fichero multimedia no se ha utilizado.',
	'Related Assets' => 'Ficheros multimedia relacionados',
	'No thumbnail image' => 'Sin miniatura',
	'You must specify a label for the asset.' => 'Debe especificar una etiqueta para el fichero multimedia.',
	'[_1] is missing' => '[_1] no existe',
	'View Asset' => 'Ver fichero multimedia',
	'Embed Asset' => 'Embeber fichero multimedia',
	'Type' => 'Tipo',
	'Save changes to this asset (s)' => 'Guardar cambios de este fichero multimedia (s)',

## tmpl/cms/edit_template.tmpl
	'Edit Widget' => 'Editar widget',
	'Create Widget' => 'Crear widget',
	'Create Template' => 'Crear plantilla',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]">Recover auto-saved content</a>' => 'Se auto-guardó [_2] una versión guardada de [_1]. <a href="[_2]">Recuperar contenido auto-guardado</a>',
	'You have successfully recovered your saved [_1].' => 'Recuperó con éxito la versión guardada de [_1].',
	'An error occurred while trying to recover your saved [_1].' => 'Ocurrió un error intentando recuperar la versión guardada de [_1].',
	'Your template changes have been saved.' => 'Se guardaron sus cambios en la plantilla.',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => '<a href="[_1]" class="rebuild-link">Publicar</a> esta plantilla.',
	'Your [_1] has been published.' => 'Su [_1] se ha publicado.',
	'Useful Links' => 'Enlaces útiles',
	'List [_1] templates' => 'Listar plantillas [_1]',
	'List all templates' => 'Listar todas las plantillas',
	'_external_link_target' => '_blank',
	'View Published Template' => 'Ver plantilla publicada',
	'Included Templates' => 'Plantillas incluídas',
	'create' => 'crear',
	'Template Tag Docs' => 'Documentos sobre las etiquetas',
	'Unrecognized Tags' => 'Etiquetas no reconocidas',
	'Save (s)' => 'Guardar (s)',
	'Save' => 'Guardar',
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
	'Syntax Highlight On' => 'Coloreado de sintaxis activado.',
	'Syntax Highlight Off' => 'Coloreado de sintaxis desactivado',
	'Insert...' => 'Insertar...',
	'Template Options' => 'Opciones de plantillas',
	'Output file: <strong>[_1]</strong>' => 'Fichero de salida: <strong>[_1]</strong>',
	'Enabled Mappings: [_1]' => 'Habilitar mapas: [_1]',
	'Output File' => 'Fichero de salida',
	'Template Type' => 'Tipo de plantilla',
	'Custom Index Template' => 'Plantilla índice personalizada',
	'Link to File' => 'Enlazar a archivo',
	'Learn more about <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publishing settings</a>' => 'Más información sobre las <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">opciones de publicación</a>',
	'Create Archive Mapping' => 'Crear mapeado de archivos',
	'Add' => 'Crear',
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
	'Server Side Include' => 'Server Side Include',
	'Process as <strong>[_1]</strong> include' => 'Procesar como inserción <strong>[_1]</strong>',
	'Include cache path' => 'Ruta de caché de inserciones',
	'Disabled (<a href="[_1]">change publishing settings</a>)' => 'Deshabilitado (<a href="[_1]">modificar configuración de la publicación</a>)',
	'No caching' => 'Sin caché',
	'Expire after' => 'Caduca tras',
	'Expire upon creation or modification of:' => 'Caduca tras la creación o modificación de:',
	'Auto-saving...' => 'Auto-guardando...',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Último guardado automático a las [_1]:[_2]:[_3]',

## tmpl/cms/list_category.tmpl
	'Your category changes and additions have been made.' => 'Se han realizado los cambios y añadidos.',
	'You have successfully deleted the selected category.' => 'Se han borrado con éxito las categorías seleccionadas.',
	'categories' => 'categorías',
	'Delete selected category (x)' => 'Borrar categoría seleccionada (x)',
	'Create top level category' => 'Crear categoría raíz',
	'New Parent [_1]' => 'Nueva [_1] raíz',
	'Create Category' => 'Crear categoría',
	'Top Level' => 'Raíz',
	'Collapse' => 'Contraer',
	'Expand' => 'Ampliar',
	'Create Subcategory' => 'Crear subcategoría',
	'Move Category' => 'Mover categoría',
	'Move' => 'Mover',
	'[quant,_1,entry,entries]' => '[quant,_1,entrada,entradas]',
	'[quant,_1,TrackBack,TrackBacks]' => '[quant,_1,TrackBack,TrackBacks]',
	'No categories could be found.' => 'No se encontró ninguna categoría.',

## tmpl/cms/dashboard.tmpl
	'Dashboard' => 'Panel de Control',
	'Select a Widget...' => 'Seleccione un widget...',
	'Your Dashboard has been updated.' => 'Se ha actualizado el Panel de Control.',
	'You have attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'Ha intentado usar una característica para la que no tiene permisos. Si cree que está viendo este mensaje por error, contacte con sus administrador del sistema.',
	'The directory you have configured for uploading userpics is not writable. In order to enable users to upload userpics, please make the following directory writable by your web server: [_1]' => 'No se puede escribir en el directorio configurado para la transferencia de avatares. Para permitir que los usuarios suban sus avatares, por favor, modifique los permisos de este directorio para que el servidor web pueda escribir en él: [_1]',
	'Image::Magick is either not present on your server or incorrectly configured. Due to that, you will not be able to use Movable Type\'s userpics feature. If you wish to use that feature, please install Image::Magick or use an alternative image driver.' => 'Image::Magick no está presente en el servidor o no está instalado correctamente. Por esa razón, no podrá usar los avatares de usuarios en Movable Type. Si desea utilizar esta característica, por favor, instale Image::Magick o algún controlador alternativo de imágenes.',
	'Your dashboard is empty!' => '¡Su panel de control está vacío!',

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
	'Only when attention is required' => 'Solo cuando se requiera atención',
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
	'Save changes to these settings (s)' => 'Guardar cambios de estas opciones (s)',

## tmpl/cms/pinging.tmpl
	'Trackback' => 'TrackBack',
	'Pinging sites...' => 'Enviando pings a sitios...',

## tmpl/cms/edit_widget.tmpl
	'Edit Widget Set' => 'Editar widgets',
	'Create Widget Set' => 'Crear conjunto de widgets',
	'Please use a unique name for this widget set.' => 'Por favor, utilice un nombre único para este conjunto de widgets.',
	'Set Name' => 'Nombre del conjunto',
	'Drag and drop the widgets you want into the Installed column.' => 'Arrastre y deje los widgets de su elección en la columna Instalada',
	'Installed Widgets' => 'Widgets instalados',
	'edit' => 'editar',
	'Available Widgets' => 'Widgets disponibles',
	'Save changes to this widget set (s)' => 'Guardar cambios de este conjunto de widgets (s)',

## tmpl/cms/list_entry.tmpl
	'Manage Entries' => 'Administrar entradas',
	'Entries Feed' => 'Sindicación de las entradas',
	'Pages Feed' => 'Sindicación de las páginas',
	'The entry has been deleted from the database.' => 'La entrada ha sido borrada de la base de datos.',
	'The page has been deleted from the database.' => 'La página ha sido borrada de la base de datos.',
	'Quickfilters' => 'Filtros rápidos',
	'[_1] (Disabled)' => '[_1] (Desactivado)',
	'Set Web Services Password' => 'Establecer contraseña de servicios web',
	'Showing only: [_1]' => 'Mostrando solo: [_1]',
	'Remove filter' => 'Borrar filtro',
	'All [_1]' => 'Todos los/las [_1]',
	'change' => 'cambiar',
	'[_1] where [_2] is [_3]' => '[_1] donde [_2] es [_3]',
	'Show only entries where' => 'Mostrar solo las entradas donde',
	'Show only pages where' => 'Mostrar solo las páginas donde',
	'status' => 'estado',
	'user' => 'usario',
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

## tmpl/cms/list_asset.tmpl
	'You have successfully deleted the asset(s).' => 'Se borraron con éxito los ficheros multimedia seleccionados.',
	'Show only assets where' => 'Mostrar solo los ficheros multimedia donde',
	'type' => 'tipo',

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
	'Email' => 'Correo electrónico',
	'The Email of the commenter' => 'La dirección de correo del comentarista',
	'Withheld' => 'Retener',
	'View all comments with this email address' => 'Ver todos los comentarios de esta dirección de correo-e',
	'The URL of the commenter' => 'La URL del comentarista',
	'View all comments with this URL address' => 'Ver todos los comentarios con esta URL',
	'Status' => 'Estado',
	'The trusted status of the commenter' => 'El estado de la confianza en el comentarista',
	'Trusted' => 'De confianza',
	'Banned' => 'Bloqueado',
	'Authenticated' => 'Autentificado',
	'View all commenters' => 'Ver todos los comentaristas',

## tmpl/cms/cfg_system_general.tmpl
	'System: General Settings' => 'Sistema: Configuración general',
	'Test email was sent.' => 'El correo se envió correctamente.', # Translate - New
	'Your settings have been saved.' => 'Configuración guardada.',
	'System Email' => 'Correo del sistema',
	'The email address used in the From: header of each email sent from the system.  The address is used in password recovery, commenter registration, comment, trackback notification and a few other minor events.' => 'La dirección de correo usada en el cabecera From: (remitente) de los mensajes enviados por el sistema. La dirección se usa en la recuperación de contraseña, en el registro de comentaristas, comentarios, notificaciones de TrackBack y otros eventos menores.',
	'Debug Mode' => 'Modo de depuración', # Translate - New
	'You can find an explanation of the various debug modes in the' => 'Puede encontrar una explicación de los diferentes modos de depuración en la', # Translate - New
	'documentation' => 'Documentación', # Translate - Case
	'Performance Logging' => 'Histórico de rendimiento', # Translate - New
	'Turns on or off performance logging.' => 'Activa o desactiva el histórico de rendimiento.', # Translate - New
	'Log Paths' => 'Rutas de los históricos', # Translate - New
	'Paths where logs are placed.' => 'Las rutas donde se sitúan los ficheros de los históricos.', # Translate - New
	'Logging Threshold' => 'Umbral de los históricos', # Translate - New
	'Logging threshold for the App' => 'Umbral de los históricos de la aplicación', # Translate - New
	'Send Email To' => 'Enviar correo a', # Translate - New
	'The email address where you want to send test email to.' => 'Esta es la dirección donde se enviará el correo de prueba.', # Translate - New

## tmpl/cms/view_rpt_log.tmpl
	'Schwartz Error Log' => 'Histórico de errores de Schwartz', # Translate - New
	'The activity log has been reset.' => 'Se reinició el registro de actividad.',
	'All times are displayed in GMT[_1].' => 'Todas las horas se muestran en GMT[_1].',
	'All times are displayed in GMT.' => 'Todas las fechas se muestran en GMT.',
	'Are you sure you want to reset the activity log?' => '¿Está seguro de querer reiniciar el registro de actividad?',
	'Showing all Schwartz errors' => 'Mostrando todos los errores de Schwartz', # Translate - New

## tmpl/cms/cfg_prefs.tmpl
	'Your preferences have been saved.' => 'Se han guardado las preferencias.',
	'You must set your Blog Name.' => 'Debe configurar el nombre del blog.',
	'You did not select a timezone.' => 'No seleccionó ninguna zona horaria.',
	'Blog Settings' => 'Configuración del blog',
	'Name your blog. The blog name can be changed at any time.' => 'Nombre del blog. Se puede modificar en cualquier momento.',
	'Enter a description for your blog.' => 'Introduzca una descripción para su blog.',
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
	'License' => 'Licencia',
	'Your blog is currently licensed under:' => 'Su blog actualmente tiene la licencia:',
	'Change license' => 'Cambiar licencia',
	'Remove license' => 'Borrar licencia',
	'Your blog does not have an explicit Creative Commons license.' => 'Su blog no tiene una licencia explícica de Creative Commons.',
	'Select a license' => 'Seleccionar una licencia',

## tmpl/cms/list_member.tmpl
	'Are you sure you want to remove this role?' => '¿Está seguro de querer borrar este rol?',
	'Show only users where' => 'Mostrar solo los usuarios donde',
	'role' => 'rol',
	'enabled' => 'habilitado',
	'disabled' => 'deshabilitado',
	'pending' => 'Pendiente',

## tmpl/cms/cfg_comments.tmpl
	'Comment Settings' => 'Configuración de comentarios',
	'Note: Commenting is currently disabled at the system level.' => 'Nota: Los comentarios están actualmente desactivados a nivel de sistema.',
	'Comment authentication is not available because one of the needed modules, MIME::Base64 or LWP::UserAgent is not installed. Talk to your host about getting this module installed.' => 'La autentificación de comentarios no está disponible porque uno de los módulos necesarios, MIME::Base64 o LWP::UserAgent no está instalado. Consulte con su alojamiento.',
	'Accept Comments' => 'Aceptar comentarios',
	'If enabled, comments will be accepted.' => 'Si está activado, se aceptarán los comentarios.',
	'Setup Registration' => 'Configuración del registro',
	'Commenting Policy' => 'Política de comentarios',
	'Immediately approve comments from' => 'Aceptar inmediatamente los comentarios de',
	'Specify what should happen to comments after submission. Unapproved comments are held for moderation.' => 'Especifique qué ocurrirá con los comentarios después de su envío. Los comentarios no aprobados se retienen a la espera de su moderación.',
	'No one' => 'Nadie',
	'Trusted commenters only' => 'Solo comentaristas de confianza',
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
	'Auto-Link URLs' => 'Autoenlazar URLs',
	'If enabled, all non-linked URLs will be transformed into links to that URL.' => 'Si está activado, todas las URLs no enlazadas se transformarán en enlaces a esa URL.',
	'Text Formatting' => 'Formato del texto',
	'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Opción que especifica el formato de texto a utilizar para formatear los comentarios de los visitantes.',
	'CAPTCHA Provider' => 'Proveedor de CAPTCHA',
	'none' => 'ninguno',
	'No CAPTCHA provider available' => 'No hay disponible ningún proveedor de CAPTCHA.',
	'No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed, and CaptchaSourceImageBase directive points to captcha-source directory under mt-static/images.' => 'No hay disponible ningún proveedor de CAPTCHA en este sistema. Por favor, compruebe que Image::Magick está instalado, y que la directiva CaptchaSourceImageBase apunta al directorio de origen de captchas en mt-static/images.',
	'Use Comment Confirmation Page' => 'Usar página de confirmación de comentarios',
	'Use comment confirmation page' => 'Usar página de confirmación de comentarios',

## tmpl/cms/backup.tmpl
	'What to backup' => 'Qué copiar',
	'This option will backup Users, Roles, Associations, Blogs, Entries, Categories, Templates and Tags.' => 'Esta opción hará copias de seguridad de los Usuarios, Roles, Asociaciones, Blogs, Entradas, Categorías, Plantillas y Etiquetas.',
	'Everything' => 'Todo',
	'Reset' => 'Reiniciar',
	'Choose blogs...' => 'Eliga un blog...',
	'Archive Format' => 'Formato de archivo',
	'The type of archive format to use.' => 'El tipo de formato de archivo a usar.',
	'Don\'t compress' => 'No comprimir',
	'Target File Size' => 'Tamaño del fichero',
	'Approximate file size per backup file.' => 'Tamaño de fichero aproximado para cada fichero de la copia de seguridad.',
	'Don\'t Divide' => 'No dividir',
	'Make Backup (b)' => 'Hacer copia (b)',
	'Make Backup' => 'Hacer copia',

## tmpl/cms/cfg_system_users.tmpl
	'System: User Settings' => 'Sistema: Configuración de usuarios',
	'(No blog selected)' => '(Ningún blog seleccionado)',
	'Select blog' => 'Seleccione blog',
	'You must set a valid Default Site URL.' => 'Debe introducir una URL predefinida de sitio válida.',
	'You must set a valid Default Site Root.' => 'Debe introducir una ruta raíz predefinida de sitio válida.',
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
	'Personal blog clone source' => 'Blog original a clonar',
	'Select a blog you wish to use as the source for new personal blogs. The new blog will be identical to the source except for the name, publishing paths and permissions.' => 'Seleccionar el blog que usted desee utilizar como fuente para los nuevos blogs personales. El nuevo blog será así idéntificado a la fuente, a excepción del nombre, las rutas de publicación y las permisiones.',
	'Change blog' => 'Cambiar blog',
	'Default Site URL' => 'URL del sitio',
	'Define the default site URL for new blogs. This URL will be appended with a unique identifier for the blog.' => 'Defina por defecto la URL del sitio para los nuevos blogs.  Esta URL ',
	'Default Site Root' => 'Raíz del sitio',
	'Define the default site root for new blogs. This path will be appended with a unique identifier for the blog.' => 'Defina por defecto la ruta de publicación para los nuevos blogs. Esta ruta será completada con un identificador único para el blog',
	'Default User Language' => 'Idioma del usuario',
	'Define the default language to apply to all new users.' => 'Establezca el idioma predefinido a aplicar a los nuevos usuarios.',
	'Default Timezone' => 'Zona horaria predefinida',
	'Default Tag Delimiter' => 'Delimitador de etiquetas predefinido',
	'Define the default delimiter for entering tags.' => 'Seleccione el separador predefinido al introducir etiquetas.',
	'Comma' => 'Coma',
	'Space' => 'Espacio',

## tmpl/cms/edit_entry.tmpl
	'Edit Page' => 'Editar página',
	'Create Page' => 'Crear página',
	'Add folder' => 'Añadir carpeta',
	'Add folder name' => 'Añadir nombre de carpeta',
	'Add new folder parent' => 'Añadir nueva carpeta raíz',
	'Save this page (s)' => 'Guardar esta página (s)',
	'Preview this page (v)' => 'Vista previa de la página (v)',
	'Delete this page (x)' => 'Borrar esta página (x)',
	'View Page' => 'Ver página',
	'Edit Entry' => 'Editar entrada',
	'Create Entry' => 'Crear nueva entrada',
	'Add category' => 'Añadir categoría',
	'Add category name' => 'Añadir nombre de categoría',
	'Add new category parent' => 'Añadir categoría raíz',
	'Save this entry (s)' => 'Guardar esta entrada (s)',
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
	'Change Folder' => 'Cambiar carpeta',
	'Unpublished (Draft)' => 'No publicado (Borrador)',
	'Unpublished (Review)' => 'No publicado (Revisión)',
	'Scheduled' => 'Programado',
	'Published' => 'Publicado',
	'Unpublished (Spam)' => 'No publicado (Spam)',
	'View' => 'Ver',
	'Share' => 'Compartir',
	'<a href="[_2]">[quant,_1,comment,comments]</a>' => '<a href="[_2]">[quant,_1,comentario,comentarios]</a>',
	'<a href="[_2]">[quant,_1,trackback,trackbacks]</a>' => '<a href="[_2]">[quant,_1,trackback,trackbacks]</a>',
	'Unpublished' => 'No publicado',
	'You must configure this blog before you can publish this entry.' => 'Debe configurar el blog antes de poder publicar esta entrada.',
	'You must configure this blog before you can publish this page.' => 'Debe configurar el blog antes de poder publicar esta página.',
	'[_1] - Published by [_2]' => '[_1] - Publicado por [_2]',
	'[_1] - Edited by [_2]' => '[_1] - Editado por [_2]',
	'Publish On' => 'Publicado el',
	'Publish Date' => 'Fecha de publicación',
	'Select entry date' => 'Seleccionar fecha de la entrada',
	'Unlock this entry&rsquo;s output filename for editing' => 'Desbloquear el nombre del fichero de salida de la entrada para su edición',
	'Warning: If you set the basename manually, it may conflict with another entry.' => 'Atención: Si introduce el nombre base manualmente, podría entrar en conflicto con otra entrada.',
	'Warning: Changing this entry\'s basename may break inbound links.' => 'Atención: Si cambia el nombre base de la entrada, podría romper enlaces entrantes.',
	'close' => 'cerrar',
	'Accept' => 'Aceptar',
	'View Previously Sent TrackBacks' => 'Ver TrackBacks enviados anteriormente',
	'Outbound TrackBack URLs' => 'URLs de TrackBacks salientes',
	'The published order of these assets can be changed using template tag modifiers.' => 'Puede modificar el orden de los elementos utilizando los modificadores de las etiquetas de plantillas.', # Translate - New
	'You have unsaved changes to this entry that will be lost.' => 'Posee cambios no guardados en esta entrada que se perderán.',
	'You have unsaved changes to this page that will be lost.' => 'Posee cambios no guardados en esta página que se perderán.',
	'Enter the link address:' => 'Introduzca la dirección del enlace:',
	'Enter the text to link to:' => 'Introduzca el texto del enlace:',
	'Your entry screen preferences have been saved.' => 'Se guardaron las nuevas preferencias del editor de entradas.',
	'Are you sure you want to use the Rich Text editor?' => '¿Está seguro de que desea usar el editor con formato?',
	'Remove' => 'Borrar',
	'Make primary' => 'Hacer primario',
	'Display Options' => 'Opciones de visualización',
	'Fields' => 'Campos',
	'Metadata' => 'Metadatos',
	'Top' => 'Arriba',
	'Both' => 'Ambos',
	'Bottom' => 'Abajo',
	'Reset display options' => 'Reiniciar opciones de visualización',
	'Reset display options to blog defaults' => 'Reiniciar opciones de visualización con los valores predefinidos del blog',
	'Reset defaults' => 'Reiniciar valores predefinidos',
	'Save display options' => 'Guardar opciones de visualización',
	'OK' => 'Aceptar',
	'Close display options' => 'Cerrar opciones de visualización',
	'This post was held for review, due to spam filtering.' => 'Esta entrada está retenida para su aprobación, debido al filtro antispam.',
	'This post was classified as spam.' => 'Esta entrada fue clasificada como spam.',
	'Spam Details' => 'Detalles de spam',
	'Score' => 'Puntuación',
	'Results' => 'Resultados',
	'Body' => 'Cuerpo',
	'Extended' => 'Extendido',
	'Format:' => 'Formato:',
	'(comma-delimited list)' => '(lista separada por comas)',
	'(space-delimited list)' => '(lista separada por espacios)',
	'(delimited by \'[_1]\')' => '(separado por \'[_1]\')',
	'Use <a href="http://blogit.typepad.com/">Blog It</a> to post to Movable Type from social networks like Facebook.' => 'Utilice <a href="http://blogit.typepad.com/">Blog It</a> para publicar en Movable Type desde redes sociales como Facebook.',
	'None selected' => 'Ninguna seleccionada',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001-[_1] Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001-[_1] Six Apart. All Rights Reserved.',

## tmpl/cms/include/users_content_nav.tmpl
	'Profile' => 'Perfil',
	'Details' => 'Detalles',

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
	'Entry/Page' => 'Entrada/Página',
	'Date' => 'Fecha',
	'IP' => 'IP',
	'Only show published comments' => 'Mostrar solo comentarios publicados',
	'Only show pending comments' => 'Mostrar solo comentarios pendientes',
	'Pending' => 'Pendiente',
	'Edit this comment' => 'Editar este comentario',
	'([quant,_1,reply,replies])' => '([quant,_1,respuesta,respuestas])',
	'Blocked' => 'Bloqueado',
	'Edit this [_1] commenter' => 'Editar comentarista [_1]',
	'Search for comments by this commenter' => 'Buscar comentarios de este comentarista',
	'View this entry' => 'Ver esta entrada',
	'View this page' => 'Ver esta página',
	'Search for all comments from this IP address' => 'Buscar todos los comentarios enviados desde esta dirección IP',

## tmpl/cms/include/rpt_log_table.tmpl
	'No log records could be found.' => 'No se encontraron registros.',
	'Schwartz Message' => 'Mensaje de Schwartz', # Translate - New

## tmpl/cms/include/member_table.tmpl
	'users' => 'usarios',
	'Are you sure you want to remove the selected user from this blog?' => '¿Está seguro de que desea borrar al usuario seleccionado de este blog?',
	'Are you sure you want to remove the [_1] selected users from this blog?' => '¿Está seguro de que desea borrar a los [_1] usuarios seleccionados de este blog?',
	'Remove selected user(s) (r)' => 'Borrar usuarios seleccionados (r)',
	'_USER_ENABLED' => 'Habilitado',
	'Trusted commenter' => 'Comentarista de confianza',
	'Link' => 'Un vínculo',
	'Remove this role' => 'Borrar este rol',

## tmpl/cms/include/feed_link.tmpl
	'Activity Feed' => 'Sindicación de la actividad',

## tmpl/cms/include/import_end.tmpl
	'All data imported successfully!' => '¡Importados con éxito todos los datos!',
	'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Asegúrese de borrar los ficheros importados del directorio \'import\', para evitar procesarlos de nuevo al ejecutar en otra ocasión el proceso de importación.',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Ocurrió un error durante el proceso de importación: [_1]. Por favor, compruebe su fichero de importación.',

## tmpl/cms/include/overview-left-nav.tmpl
	'List Weblogs' => 'Listar weblogs',
	'Weblogs' => 'Weblogs',
	'List Users and Groups' => 'Listar usuarios y grupos',
	'Users &amp; Groups' => 'Usuarios &amp; grupos',
	'List Associations and Roles' => 'Listar asociaciones y roles',
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

## tmpl/cms/include/comment_detail.tmpl

## tmpl/cms/include/asset_table.tmpl
	'assets' => 'ficheros multimedia',
	'Delete selected assets (x)' => 'Borrar los ficheros multimedia seleccionados (x)',
	'Size' => 'Tamaño',
	'Asset Missing' => 'Fichero multimedia no existe',

## tmpl/cms/include/import_start.tmpl
	'Importing...' => 'Importando...',
	'Importing entries into blog' => 'Importando entradas en el blog',
	'Importing entries as user \'[_1]\'' => 'Importando entradas como usario \'[_1]\'',
	'Creating new users for each user found in the blog' => 'Creando nuevos usarios para cada usario encontrado en el blog',

## tmpl/cms/include/log_table.tmpl
	'_LOG_TABLE_BY' => 'Por',
	'IP: [_1]' => 'IP: [_1]',

## tmpl/cms/include/pagination.tmpl

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been backed up successfully!' => '¡La copia de seguridad de los datos se ha realizado con éxito!',
	'Download This File' => 'Descargar este fichero',
	'_BACKUP_TEMPDIR_WARNING' => 'La copia de seguridad se realizó con éxito en el directorio [_1]. Descargue y <strong>borre luego</strong> los ficheros listados abajo desde [_1] <strong>inmediatamente</strong>, porque los ficheros de la copia de seguridad contiene información sensible.',
	'_BACKUP_DOWNLOAD_MESSAGE' => 'La descarga del fichero de la copia de seguridad comenzará automáticamente dentro de unos segundos. Si por alguna razón no lo hace, haga clic <a href="javascript:(void)" onclick="submit_form()">aquí</a> para comenzar la descarga manualmente. Por favor, tenga en cuenta que solo puede descargar el fichero de la copia de seguridad una vez por sesión.',
	'An error occurred during the backup process: [_1]' => 'Ocurrió un error durante la copia de seguridad: [_1]',

## tmpl/cms/include/cfg_content_nav.tmpl

## tmpl/cms/include/cfg_system_content_nav.tmpl

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Fecha de creación',
	'Click to edit contact' => 'Clic para editar el contacto',
	'Save changes' => 'Guardar cambios',

## tmpl/cms/include/footer.tmpl
	'This is a beta version of Movable Type and is not recommended for production use.' => 'Esta es una versión beta de Movable Type y no se recomienda su uso en producción.',
	'http://www.movabletype.org' => 'http://www.movabletype.org',
	'MovableType.org' => 'MovableType.org',
	'http://wiki.movabletype.org/' => 'http://wiki.movabletype.org/',
	'Wiki' => 'Wiki',
	'http://www.movabletype.com/support/' => 'http://www.movabletype.com/support/',
	'Support' => 'Soporte',
	'http://www.movabletype.org/feedback.html' => 'http://www.movabletype.org/feedback.html',
	'Send us Feedback' => 'Envíenos su opinión',
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> versión [_2]',
	'with' => 'con',

## tmpl/cms/include/tools_content_nav.tmpl

## tmpl/cms/include/commenter_table.tmpl
	'Last Commented' => 'Últimos comentados',
	'Only show trusted commenters' => 'Mostrar solo comentaristas de confianza',
	'Only show banned commenters' => 'Mostrar solo comentaristas bloqueados',
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

## tmpl/cms/include/entry_table.tmpl
	'Save these entries (s)' => 'Grabar estas entradas (s)',
	'Republish selected entries (r)' => 'Republicar entradas seleccionadas (r)',
	'Delete selected entries (x)' => 'Borrar entradas seleccionadas (x)',
	'Save these pages (s)' => 'Grabar estas páginas (s)',
	'Republish selected pages (r)' => 'Republicar páginas seleccionadas (r)',
	'Delete selected pages (x)' => 'Borrar páginas seleccionadas (x)',
	'to republish' => 'para reconstruir',
	'Last Modified' => 'Última modificación',
	'Created' => 'Creado',
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
	'View entry' => 'Ver entrada',
	'View page' => 'Ver página',
	'No entries could be found. <a href="[_1]">Create an entry</a> now.' => 'No se encontró ninguna entrada. <a href="[_1]">Cree una ahora</a>.',
	'No page could be found. <a href="[_1]">Create a page</a> now.' => 'No se encontró ninguna página. <a href="[_1]">Cree una ahora</a>.',

## tmpl/cms/include/login_mt.tmpl

## tmpl/cms/include/author_table.tmpl
	'_USER_DISABLED' => 'Deshabilitado',

## tmpl/cms/include/calendar.tmpl
	'_LOCALE_WEEK_START' => '_LOCALE_WEEK_START',
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
	'[_1:calMonth] [_2:calYear]' => '[_1:calMonth] [_2:calYear]',

## tmpl/cms/include/blog-left-nav.tmpl
	'Creating' => 'Creando',
	'Community' => 'Comunidad',
	'List Commenters' => 'Listar comentaristas',
	'Edit Address Book' => 'Editar agenda de direcciones',
	'List Users &amp; Groups' => 'Lisar usuarios &amp; grupos',
	'List &amp; Edit Templates' => 'Listar y editar plantillas',
	'Edit Categories' => 'Editar categorías',
	'Edit Tags' => 'Editar etiquetas',
	'Edit Weblog Configuration' => 'Editar configuración del weblog',
	'Backup this weblog' => 'Hacer una copia de seguridad de este weblog',
	'Import &amp; Export Entries' => 'Importar &amp; Exportar entradas',
	'Import / Export' => 'Importar / Exportar',
	'Rebuild Site' => 'Reconstruir sitio',
	'View Site' => 'Ver sitio',

## tmpl/cms/include/itemset_action_widget.tmpl
	'More actions...' => 'Más acciones...',
	'Plugin Actions' => 'Acciones de extensiones',
	'Go' => 'Ir',

## tmpl/cms/include/anonymous_comment.tmpl
	'Anonymous Comments' => 'Comentarios anónimos',
	'Require E-mail Address for Anonymous Comments' => 'Requerir dirección de correo en los comentarios anónimos',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Si está activo, los visitantes deberán introducir una dirección válida de correo electrónico para comentar.',

## tmpl/cms/include/category_selector.tmpl
	'Add sub category' => 'Añadir sub categoría',
	'Add new' => 'Añadir nuevo',

## tmpl/cms/include/list_associations/page_title.tmpl
	'Permissions for [_1]' => 'Permisos de [_1]',
	'Permissions: System-wide' => 'Permisos: Todo el sistema',
	'Users for [_1]' => 'Usuarios de [_1]',

## tmpl/cms/include/display_options.tmpl
	'_DISPLAY_OPTIONS_SHOW' => 'Mostrar',
	'[quant,_1,row,rows]' => '[quant,_1,fila,filas]',
	'Compact' => 'Compacto',
	'Expanded' => 'Expandido',
	'Action Bar' => 'Barra de acciones',
	'Date Format' => 'Formato de fechas',
	'Relative' => 'Relativo',
	'Full' => 'Completo',

## tmpl/cms/include/backup_start.tmpl
	'Backing up Movable Type' => 'Haciendo copia de seguridad de Movable Type',

## tmpl/cms/include/template_table.tmpl
	'Create Archive Template:' => 'Crear plantilla de archivos',
	'Entry Listing' => 'Listado de entradas',
	'Create template module' => 'Crear plantilla de módulo',
	'Create index template' => 'Crear plantilla índice',
	'templates' => 'plantillas',
	'Publish selected templates (a)' => 'Publicar plantillas seleccionadas (a)',
	'Archive Path' => 'Ruta de archivos',
	'Cached' => 'Cacheado',
	'Linked Template' => 'Plantilla enlazada',
	'-' => '-',
	'Manual' => 'Manual',
	'Dynamic' => 'Dinámico',
	'Publish Queue' => 'Cola de publicación',
	'Static' => 'Estático',
	'Yes' => 'Sí',
	'No' => 'No',

## tmpl/cms/include/asset_upload.tmpl
	'Before you can upload a file, you need to publish your blog. [_1]Configure your blog\'s publishing paths[_2] and rebuild your blog.' => 'Antes de subir un fichero, debe publicar el blog. [_1]Configure las rutas de publicación del blog[_2] y reconstrúyalo.',
	'Your system or blog administrator needs to publish the blog before you can upload files. Please contact your system or blog administrator.' => 'El administrador del sistema o del blog debe publicarlo antes de que pueda subir ficheros. Por favor, contacte con el administrador del sistema o del blog.',
	'Close (x)' => 'Cerrar (x)',
	'Select File to Upload' => 'Seleccione el fichero a subir',
	'_USAGE_UPLOAD' => 'Puede transferir el fichero a un subdirectorio en la ruta seleccionada. Si el subdirectorio no existe, se creará.',
	'Upload Destination' => 'Destino de la transferencia',
	'Choose Folder' => 'Seleccionar carpeta',
	'Upload (s)' => 'Subir (s)',
	'Upload' => 'Subir',
	'Back (b)' => 'Volver (b)',
	'Cancel (x)' => 'Cancelar (x)',

## tmpl/cms/include/listing_panel.tmpl
	'Step [_1] of [_2]' => 'Paso [_1] de [_2]',
	'Go to [_1]' => 'Ir a [_1]',
	'Sorry, there were no results for your search. Please try searching again.' => 'Lo siento, no se encontraron resultados para la búsqueda. Por favor, intente buscar de nuevo.',
	'Sorry, there is no data for this object set.' => 'Lo siento, no hay datos para este conjunto de objetos.',
	'Confirm (s)' => 'Confirmar (s)',
	'Confirm' => 'Confirmar',
	'Continue (s)' => 'Continuar (s)',

## tmpl/cms/include/header.tmpl
	'Help' => 'Ayuda',
	'Hi [_1],' => 'Hola [_1],',
	'Logout' => 'Cerrar sesión',
	'Select another blog...' => 'Seleccionar otro blog...',
	'Create a new blog' => 'Crear un nuevo blog',
	'Write Entry' => 'Escribir entrada',
	'Blog Dashboard' => 'Panel de Control del blog',
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

## tmpl/cms/include/archive_maps.tmpl
	'Path' => 'Ruta',
	'Custom...' => 'Personalizar...',

## tmpl/cms/recover_password_result.tmpl
	'Recover Passwords' => 'Recuperar contraseñas',
	'No users were selected to process.' => 'No se seleccionaron usarios a procesar.',
	'Return' => 'Volver',

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

## tmpl/cms/setup_initial_blog.tmpl
	'Create Your First Blog' => 'Cree su primer blog',
	'The blog name is required.' => 'El nombre del blog es obligatorio.',
	'The blog URL is required.' => 'La URL del blog es obligatoria.',
	'The publishing path is required.' => 'La ruta de publicación es obligatoria.',
	'The timezone is required.' => 'La zona horaria es obligatoria.',
	'Template Set' => 'Conjunto de plantillas',
	'Select the templates you wish to use for this new blog.' => 'Seleccione las plantillas que desea usar en este blog.',
	'Finish install (s)' => 'Finalizar la instalación (s)',
	'Finish install' => 'Finalizar instalación',
	'Back (x)' => 'Volver (x)',

## tmpl/cms/import.tmpl
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
	'More options' => 'Más opciones',
	'Import File Encoding' => 'Codificación del fichero de importación',
	'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'Por defecto, Movable Type intentará detectar automáticamente la codificación del fichero a importar. Sin embargo, si experimenta dificultados, puede especificarlo explícitamente.',
	'<mt:var name="display_name" escape="html">' => '<mt:var name="display_name" escape="html">',
	'Default category for entries (optional)' => 'Categoría predefinida de las entradas (opcional)',
	'You can specify a default category for imported entries which have none assigned.' => 'Puede especificar una categoría predefinida para las entradas importadas que no tengan ninguna asignada.',
	'Select a category' => 'Seleccione una categoría',
	'Import Entries (s)' => 'Importar entradas (s)',
	'Import Entries' => 'Importar entradas',

## tmpl/cms/refresh_results.tmpl
	'Template Refresh' => 'Refrescar plantilla',
	'No templates were selected to process.' => 'No se han seleccionado plantillas para procesar.',
	'Return to templates' => 'Volver a las plantillas',

## tmpl/cms/cfg_spam.tmpl
	'Spam Settings' => 'Configuración del spam',
	'Your spam preferences have been saved.' => 'Se han guardado sus preferencias del spam.',
	'Auto-Delete Spam' => 'Autoborrar el spam',
	'If enabled, feedback reported as spam will be automatically erased after a number of days.' => 'Si la activa, las respuestas marcadas como spam se borrarán automáticamente después de un número de días.',
	'Delete Spam After' => 'Borrar spam después',
	'When an item has been reported as spam for this many days, it is automatically deleted.' => 'Cuando un elemento haya estado marcado como spam durante esta cantidad de días, será borrado automáticamente.',
	'Spam Score Threshold' => 'Puntuación límite de spam',
	'Comments and TrackBacks receive a spam score between -10 (complete spam) and +10 (not spam). Feedback with a score which is lower than the threshold shown above will be reported as spam.' => 'Los comentarios y TrackBacks se puntúan como spam con valores entre -10 (spam total) y +10 (no spam). Las respuestas con una puntuación que sea menor del límite mostrado arriba, se marcarán como spam.',
	'Less Aggressive' => 'Menos agresivo',
	'Decrease' => 'Disminuir',
	'Increase' => 'Aumentar',
	'More Aggressive' => 'Más agresivo',

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

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Editar carpeta',
	'Your folder changes have been made.' => 'Se han realizado los cambios en la carpeta.',
	'Manage Folders' => 'Administrar carpetas',
	'Manage pages in this folder' => 'Administrar las páginas de esta carpeta',
	'You must specify a label for the folder.' => 'Debe especificar una etiqueta para la carpeta.',
	'Save changes to this folder (s)' => 'Guardar cambios de esta carpeta (s)',

## tmpl/cms/list_widget.tmpl
	'Widget Sets' => 'Conjuntos de widgets',
	'Delete selected Widget Sets (x)' => 'Borrar conjuntos de widgets seleccionados (x)',
	'Helpful Tips' => 'Consejos útiles',
	'To add a widget set to your templates, use the following syntax:' => 'Para añadir un conjunto de widgets a las plantillas, utilice la siguiente sintaxis:',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Nombre del conjunto de widgets&quot;$&gt;</strong>',
	'Your changes to the widget set have been saved.' => 'Se han guardado los cambios al conjunto de widgets.',
	'You have successfully deleted the selected widget set(s) from your blog.' => 'Borró con éxito los conjuntos de widgets seleccionados del blog.',
	'No Widget Sets could be found.' => 'Ningún grupo de widget ha sido encontrado',
	'Create widget template' => 'Crear plantilla de widget',
	'Widget Template' => 'Plantilla de widget',
	'Widget Templates' => 'Plantillas de widget',
	'widget templates' => 'Plantillas de widget',

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
	'Export Blog (s)' => 'Exportar blog (s)',
	'Export Blog' => 'Exportar blog',

## tmpl/cms/upgrade.tmpl
	'Time to Upgrade!' => '¡Hora de actualizar!',
	'Upgrade Check' => 'Comprobar actualización',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'La versión de Perl instalada en su servidor ([_1]) es menor que la versión mínima soporta ([_2]).',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Aunque Movable Type podría ejecutarse, <strong>esta configuración no está probada ni ni soportada</strong>.  Le recomendamos que actualice Perl a la versión [_1].',
	'Do you want to proceed with the upgrade anyway?' => '¿Desea proceder en cualquier caso con la actualización?',
	'Yes (s)' => 'Sí (s)',
	'View MT-Check (x)' => 'Ver MT-Check (x)',
	'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Se ha instalado una nueva versión de Movable Type.  Debemos realizar algunas tareas para actualizar su base de datos.',
	'Information about this upgrade can be found <a href=\'[_1]\' target=\'_blank\'>here</a>.' => 'Informaciones sobre esta actualización pueden ser encontradas <a href=\'[_1]\' target=\'_blank\'>aquí</a>.',
	'In addition, the following Movable Type components require upgrading or installation:' => 'Además, los siguientes componentes de Movable Type necesitan actualización o instalación:',
	'The following Movable Type components require upgrading or installation:' => 'Los siguientes componentes de Movable Type necesitan actualización o instalación:',
	'Begin Upgrade' => 'Comenzar actualización',
	'Congratulations, you have successfully upgraded to Movable Type [_1].' => 'Felicidades, actualizó con éxito a Movable Type [_1].',
	'Return to Movable Type' => 'Volver a Movable Type',
	'Your Movable Type installation is already up to date.' => 'Su instalación de Movable Type ya está actualizada.',

## tmpl/cms/edit_category.tmpl
	'Edit Category' => 'Editar categoría',
	'Your category changes have been made.' => 'Los cambios en la categoría se han guardado.',
	'Manage entries in this category' => 'Administrar las entradas de esta categorías',
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
	'Save changes to this category (s)' => 'Guardar cambios de esta categoría (s)',

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
	'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'El fichero llamado \'[_1]\' ya existe. ¿Desea sobreescribirlo?',

## tmpl/cms/dialog/asset_list.tmpl
	'Insert Asset' => 'Añadir un fichero multimedia',
	'Upload New File' => 'Subir nuevo fichero',
	'Upload New Image' => 'Subir nueva imagen',
	'Asset Name' => 'Nombre del fichero multimedia',
	'Next (s)' => 'Siguiente (s)',
	'Insert (s)' => 'Insertar (s)',
	'Insert' => 'Insertar',
	'No assets could be found.' => 'No se encontraron ficheros multimedia.',

## tmpl/cms/dialog/new_password.tmpl
	'Choose New Password' => 'Seleccione la nueva contraseña',
	'Confirm Password' => 'Confirmar contraseña',
	'Change Password' => 'Cambiar Contraseña',

## tmpl/cms/dialog/refresh_templates.tmpl
	'Refresh Template Set' => 'Refrescar el conjunto de plantillas',
	'Refresh [_1] template set' => 'Refrescar el conjunto de plantillas [_1]',
	'Refresh global templates' => 'Recargar plantillas globales',
	'Updates current templates while retaining any user-created templates.' => 'Actualiza las plantillas actuales pero mantiene las plantillas creadas por el usuario.',
	'Apply a new template set' => 'Aplicar un nuevo conjunto',
	'Deletes all existing templates and install the selected template set.' => 'Borra todas las plantillas existentes e instala el conjunto seleccionado.',
	'Reset to factory defaults' => 'Valores de fábrica',
	'Deletes all existing templates and installs factory default template set.' => 'Borra todas las plantillas existentes e instala el conjunto de plantillas predefinido.',
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
	'Dynamic Publishing' => 'Publicación dinámica',
	'Publish all templates dynamically.' => 'Publicar todas las plantillas dinámicamente.',
	'Dynamic Archives Only' => 'Solo archivos dinámicos',
	'Publish all Archive templates dynamically. Immediately publish all other templates statically.' => 'Publicar todos las plantillas de archivos dinámicamente. Publicar de forma inmediata el resto de plantillas estáticamente.',
	'This new publishing profile will update all of your templates.' => 'Este nuevo perfil de publicación actualizará todas las plantillas.',

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
	'Site Path' => 'Ruta del sitio',
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

## tmpl/cms/dialog/clone_blog.tmpl
	'Verify Blog Settings' => 'Verificar configuración del blog', # Translate - New
	'Overwrite' => 'Sobreescribir', # Translate - New
	'Overwrite Original Paths' => 'Sobreescribir rutas originales', # Translate - New
	'Preserve Original Paths' => 'Preservar rutas originales', # Translate - New
	'Exclusions' => 'Exclusiones', # Translate - New
	'Exclude Entries/Pages' => 'Excluir entradas/páginas', # Translate - New
	'Exclude Comments' => 'Excluir comentarios', # Translate - New
	'Exclude Trackbacks' => 'Excluir Trackbacks', # Translate - New
	'Exclude Categories' => 'Excluir categorías', # Translate - New
	'Clone' => 'Clonar', # Translate - New
	'Blog Details' => 'Detalles del blog',
	'Enter the new URL of your public website. Example: http://www.example.com/weblog/' => 'Introduzca la nueva URL de su sitio web público. Ejemplo: http://www.ejemplo.com/weblog/', # Translate - New
	'Enter a new path where your main index file will be located. Example: /home/melody/public_html/weblog' => 'Introduzca la nueva ruta donde se situará el fichero índice. Ejemplo: /home/melody/public_html/weblog', # Translate - New
	'If this is set to the same path as the original blog, it will overwrite it.' => 'Si coincide con la ruta original del weblog, se sobreescribirá.', # Translate - New
	'Clone Settings' => 'Configuración de la clonación', # Translate - New
	'If this option is set, any matching path settings will overwrite the original blog.' => 'Si esta opción está configurada, cualquier ruta que coincida sobreescribirá el blog original.', # Translate - New
	'Mark the settings that you want cloning to skip' => 'Marque las opciones que desee excluir de la clonación', # Translate - New
	'Entries/Pages' => 'Entradas/páginas', # Translate - New

## tmpl/cms/list_author.tmpl
	'Users: System-wide' => 'Usuarios: Todo el sistema',
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
	'Your database is already current.' => 'Su base de datos está al día.',

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

## tmpl/cms/list_banlist.tmpl
	'IP Banning Settings' => 'Bloqueo de IPs',
	'IP addresses' => 'Direcciones IP',
	'Delete selected IP Address (x)' => 'Borrar la dirección IP seleccionada (x)',
	'You have added [_1] to your list of banned IP addresses.' => 'Agregó [_1] a su lista de direcciones IP bloqueadas.',
	'You have successfully deleted the selected IP addresses from the list.' => 'Eliminó correctamente las direcciones IP seleccionadas.',
	'Ban IP Address' => 'Bloquear la dirección IP',
	'Date Banned' => 'Fecha de bloqueo',

## tmpl/cms/cfg_registration.tmpl
	'Registration Settings' => 'Configuración de registro',
	'Your blog preferences have been saved.' => 'Las preferencias de su weblog han sido guardadas.',
	'Allow registration for Movable Type.' => 'Permitir el registro en Movable Type.',
	'Registration Not Enabled' => 'Registro no activado',
	'Note: Registration is currently disabled at the system level.' => 'Nota: Actualmente el regisro está desactivado a nivel del sistema.',
	'Authentication Methods' => 'Métodos de autentificación',
	'Note: You have selected to accept comments from authenticated commenters only but authentication is not enabled. In order to receive authenticated comments, you must enable authentication.' => 'Nota: Seleccionó aceptar comentarios solo de comentaristas autentificados, pero la autentificación no está activada. Para recibir comentarios autentificados, debe activar la autentificación.',
	'Native' => 'Nativo',
	'Require E-mail Address for Comments via TypePad' => 'Requerir la dirección de correo de los comentarios a través de TypePad',
	'If enabled, visitors must allow their TypePad account to share e-mail address when commenting.' => 'Si se activa, los visitantes deberán permitir que TypePad comparta la dirección de correo electrónico al comentar.',
	'One or more Perl modules may be missing to use this authentication method.' => 'Uno o más módulos de Perl podrían necesitar este método de autentificación.', # Translate - New
	'Setup TypePad' => 'Configurar TypePad',
	'OpenID providers disabled' => 'Proveedores OpenID desactivados',
	'Required module (Digest::SHA1) for OpenID commenter authentication is missing.' => 'No se encuentra el módulo necesario (Digest::SHA1) para la autentificación de comentaristas con OpenID.',

## tmpl/cms/list_ping.tmpl
	'Manage Trackbacks' => 'Administrar TrackBacks',
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

## tmpl/cms/import_others.tmpl
	'Start title HTML (optional)' => 'HTML de comienzo de título (opcional)',
	'End title HTML (optional)' => 'HTML de final de título (opcional)',
	'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => 'Si el software desde el que va a importar no tiene un campo de título, puede usar esta opción para identificar un título dentro del cuerpo de la entrada.',
	'Default entry status (optional)' => 'Estado predefinido de las entradas (opcional)',
	'If the software you are importing from does not specify an entry status in its export file, you can set this as the status to use when importing entries.' => 'Si el software desde el que va a importar no especifica un estado para la entrada en su fichero de exportación, puede establecer éste como el estado a utilizar al importar las entradas.',
	'Select an entry status' => 'Seleccione un estado para las entradas',

## tmpl/cms/error.tmpl
	'An error occurred' => 'Ocurrió un error',

## tmpl/cms/edit_author.tmpl
	'Edit Profile' => 'Editar Perfil',
	'This profile has been updated.' => 'Este perfil ha sido actualizado.',
	'A new password has been generated and sent to the email address [_1].' => 'Se ha generado y enviado a la dirección de correo electrónico [_1] una nueva contraseña.',
	'Your Web services password is currently' => 'La contraseña de los servicios web es actualmente',
	'_WARNING_PASSWORD_RESET_SINGLE' => 'Va a reiniciar la contraseña de "[_1]". Se enviará una nueva contraseña aleatoria que se enviará directamente a su dirección de correo electrónico ([_2]). ¿Desea continuar?',
	'Error occurred while removing userpic.' => 'Ocurrió un error durante la eliminación del avatar.',
	'_USER_STATUS_CAPTION' => 'estado',
	'Status of user in the system. Disabling a user removes their access to the system but preserves their content and history.' => 'Estado del usuario en el sistema. Al deshabilitar el usuario, se impide su acceso al sistema pero se preservan sus contenidos e históricos.',
	'_USER_PENDING' => 'Pendiente',
	'The username used to login.' => 'El nombre de usuario utilizado para la identificación en el sistema.',
	'External user ID' => 'Usuario externo ID',
	'The name used when published.' => 'El nombre utilizado al publicar.',
	'The email address associated with this user.' => 'La dirección de correo asociada a este usuario.',
	'The URL of the site associated with this user. eg. http://www.movabletype.com/' => 'La URL del sitio asociada al usuario. p.e. http://www.movabletype.com/',
	'Userpic' => 'Avatar',
	'The image associated with this user.' => 'La imagen asociada al usuario.',
	'Select Userpic' => 'Seleccionar avatar',
	'Remove Userpic' => 'Borrar avatar',
	'Current Password' => 'Contraseña actual',
	'Existing password required to create a new password.' => 'La contraseña actual es necesaria para crear una nueva.',
	'Initial Password' => 'Contraseña inicial',
	'Enter preferred password.' => 'Introduzca la contraseña elegida.',
	'New Password' => 'Nueva contraseña',
	'Enter the new password.' => 'Introduzca la nueva contraseña.',
	'Repeat the password for confirmation.' => 'Repita la contraseña para confirmación.',
	'Password recovery word/phrase' => 'Palabra/frase para la recuperación de contraseña',
	'This word or phrase is not used in the password recovery.' => 'Esta palabra o frase no se usa en la recuperación de la contraseña.',
	'Language' => 'Idioma',
	'Preferred language of this user.' => 'Idioma preferido por este usuario.',
	'Text Format' => 'Formato de texto',
	'Preferred text format option.' => 'Opción de formato de texto preferido.',
	'(Use Blog Default)' => '(Usar valores predefinidos del blog)',
	'Tag Delimiter' => 'Delimitador de etiquetas',
	'Preferred method of separating tags.' => 'Método preferido de separación de etiquetas.',
	'Web Services Password' => 'Contraseña de servicios web',
	'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'Utilizada por las fuentes de sindicación de actividad y los clientes XML-RPC y Atom.',
	'Reveal' => 'Mostrar',
	'System Permissions' => 'Permisos del sistema',
	'Options' => 'Opciones',
	'Create personal blog for user' => 'Crear blog personal para el usuario',
	'Create User (s)' => 'Crear usuario (s)',
	'Save changes to this author (s)' => 'Guardar cambios de este autor (s)',
	'_USAGE_PASSWORD_RESET' => 'Puede iniciar la recuperación de la contraseña en nombre de este usuario. Si lo hace, se enviará un correo a <strong>[_1]</strong> con una nueva contraseña aleatoria.',
	'Initiate Password Recovery' => 'Iniciar recuperación de contraseña',

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
	'Save this entry' => 'Guardar esta entrada',
	'Re-Edit this entry' => 'Reeditar esta entrada',
	'Re-Edit this entry (e)' => 'Reeditar esta entrada (e)',
	'Save this page' => 'Guardar esta página',
	'Re-Edit this page' => 'Reeditar esta página',
	'Re-Edit this page (e)' => 'Reeditar esta página (e)',
	'You are previewing the entry titled &ldquo;[_1]&rdquo;' => 'Está previsualizando la entrada titulada &ldquo;[_1]&rdquo;',
	'You are previewing the page titled &ldquo;[_1]&rdquo;' => 'Está previsualizando la página titulada &ldquo;[_1]&rdquo;',

## tmpl/cms/list_role.tmpl
	'Roles: System-wide' => 'Roles: Todo el sistema',
	'You have successfully deleted the role(s).' => 'Ha borrado con éxito el/los rol/es.',
	'roles' => 'roles',
	'Role Is Active' => 'Rol activo',
	'Role Not Being Used' => 'Rol en desuso',

## tmpl/cms/preview_template_strip.tmpl
	'You are previewing the template named &ldquo;[_1]&rdquo;' => 'Esta es la vista previa de la plantilla &ldquo;[_1]&rdquo;',
	'(Publish time: [_1] seconds)' => '(Tiempo de publicación: [_1] segundos)',
	'Save this template (s)' => 'Guardar esta plantilla (s)',
	'Save this template' => 'Guardar esta plantilla',
	'Re-Edit this template (e)' => 'Reeditar esta plantilla (e)',
	'Re-Edit this template' => 'Reeditar esta plantilla',

## tmpl/cms/preview_entry.tmpl
	'Preview [_1]' => 'Pre-ver [_1]',
	'Re-Edit this [_1]' => 'Re-editar [_1]',
	'Re-Edit this [_1] (e)' => 'Re-editar [_1] (e)',
	'Save this [_1]' => 'Guardar [_1]',
	'Save this [_1] (s)' => 'Guardar este [_1] (s)',
	'Cancel (c)' => 'Cancelar (c)',

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

## tmpl/cms/cfg_web_services.tmpl
	'Web Services Settings' => 'Configuración de los servicios web',
	'Six Apart Services' => 'Servicios de Six Apart',
	'Your TypePad token is used to access Six Apart services like its free Authentication service.' => 'El token de TypePad se utiliza para acceder a los servicios de Six Apart, como el servicio gratuito de autentificación.',
	'TypePad is enabled.' => 'TypePad está activado.',
	'TypePad token:' => 'Token de TypePad:',
	'Clear TypePad Token' => 'Borrar token de TypePad',
	'Please click the Save Changes button below to disable authentication.' => 'Por favor, haga clic en el botón Guardar cambios para desactivar la autentificación.',
	'TypePad is not enabled.' => 'TypePad no está activado.',
	'or' => 'o',
	'Obtain TypePad token' => 'Obtener token de TypePad',
	'Please click the Save Changes button below to enable TypePad.' => 'Por favor, haga clic en Guardar cambios para activar TypePad.',
	'External Notifications' => 'Notificaciones externas',
	'Notify of blog updates' => 'Notificación de actualizaciones',
	'When this blog is updated, Movable Type will automatically notify the selected sites.' => 'Cuando se actualice el blog, Movable Type notificará automáticamente a los sitios seleccionados.',
	'Note: This option is currently ignored since outbound notification pings are disabled system-wide.' => 'Nota: Actualmente, esta opción se ignora ya que los pings de notificación están desactivadas en todo el sistema.',
	'Others:' => 'Otros:',
	'(Separate URLs with a carriage return.)' => '(Separe las URLs con un retorno de carro.)',
	'Recently Updated Key' => 'Clave actualizada recientemente',
	'If you have received a recently updated key (by virtue of your purchase), enter it here.' => 'Si recientemente ha recibido una clave actualizada (tras una compra), tecléela aquí.',

## tmpl/cms/edit_blog.tmpl
	'Your blog configuration has been saved.' => 'Se ha guardado la configuración de su blog.',
	'You must set your Local Site Path.' => 'Debe definir la ruta local de su sitio.',
	'You must set your Site URL.' => 'Debe definir la URL de su sitio.',
	'Your Site URL is not valid.' => 'La URL de su sitio no es válida.',
	'You can not have spaces in your Site URL.' => 'No puede haber espacios en la URL de su sitio.',
	'You can not have spaces in your Local Site Path.' => 'No puede haber espacios en la ruta local de su sitio.',
	'Your Local Site Path is not valid.' => 'La ruta local de su sitio no es válida.',
	'Enter the URL of your public website. Do not include a filename (i.e. exclude index.html). Example: http://www.example.com/weblog/' => 'Introduzca la URL de su web público. No incluya ningún nombre de fichero (p.e. index.html). Ejemplo: http://www.ejemplo.com/weblog/',
	'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/weblog' => 'Introduzca la ruta donde se situará el fichero índice principal. Se aconseja una ruta absoluta (que comienzan con \'/\'), pero también puede especificar una ruta relativa al directorio de Movable Type. Ejemplo: /home/melody/public_html/weblog',
	'Blog language.' => 'Idioma del Blog.',
	'Create Blog (s)' => 'Crear blog (s)',

## tmpl/cms/list_template.tmpl
	'Blog Templates' => 'Plantillas del blog',
	'Show All Templates' => 'Mostrar todas las plantillas',
	'Blog Publishing Settings' => 'Configuración de la publicación del blog',
	'You have successfully deleted the checked template(s).' => 'Se eliminaron correctamente las plantillas marcadas.',
	'Your templates have been published.' => 'Se han publicado las plantillas.',
	'Selected template(s) has been copied.' => 'Se han publicado las plantillas seleccionadas.',

## tmpl/cms/edit_ping.tmpl
	'Edit Trackback' => 'Editar TrackBack',
	'The TrackBack has been approved.' => 'Se aprobó el TrackBack.',
	'List &amp; Edit TrackBacks' => 'Listar &amp; editar TrackBacks',
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
	'The initial account name is required.' => 'Se necesita el nombre de la cuenta inicial.',
	'The display name is required.' => 'El nombre público es obligatorio.',
	'Password recovery word/phrase is required.' => 'Se necesita la palabra/frase de recuperación de contraseña.',
	'Do you want to proceed with the installation anyway?' => '¿Aún así desea proceder con la instalación?',
	'Before you can begin blogging, you must create an administrator account for your system. When you are done, Movable Type will then initialize your database.' => 'Antes de poder comenzar a publicar, debe crear una cuenta de administrador para el sistema. Cuando lo haya hecho, Movable Type inicializará la base de datos.',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Para proceder, debe autentificarse correctamente en su servidor LDAP.',
	'The name used by this user to login.' => 'El nombre utilizado por este usario para iniciar su sesión.',
	'The user&rsquo;s email address.' => 'La dirección de correo electrónico del usuario',
	'The email address used in the From: header of each email sent from the system.' => 'La dirección de correousada en la cabecera De: de los correos enviados por el sistema.',
	'Use this as system email address' => 'Usar esta dirección de correo para el sistema',
	'The user&rsquo;s preferred language.' => 'El idioma preferido del usuario.',
	'Select a password for your account.' => 'Seleccione una contraseña para su cuenta.',
	'Password Confirm' => 'Confirmar contraseña',
	'Your LDAP username.' => 'Su usuario en el servidor LDAP.',
	'Enter your LDAP password.' => 'Su contraseña en el servidor LDAP.',

## tmpl/cms/edit_comment.tmpl
	'The comment has been approved.' => 'Se ha aprobado el comentario.',
	'Save changes to this comment (s)' => 'Guardar cambios de este comentario (s)',
	'Delete this comment (x)' => 'Borrar este comentario (x)',
	'Previous Comment' => 'Comentario anterior',
	'Next Comment' => 'Comentario siguiente',
	'View entry comment was left on' => 'Mostrar la entrada donde se realizó el comentario',
	'Reply to this comment' => 'Responder al comentario',
	'Update the status of this comment' => 'Actualizar el estado del comentario',
	'View all comments with this status' => 'Ver comentarios con este estado',
	'The name of the person who posted the comment' => 'El nombre de la persona que publicó el comentario',
	'(Trusted)' => '(De confianza)',
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
	'...' => '...',
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
	'Change this message.' => 'Cambiar este mensaje.',
	'Edit this message.' => 'Editar este mensaje.',

## tmpl/cms/widget/mt_shortcuts.tmpl
	'Import Content' => 'Importar contenido',
	'Blog Preferences' => 'Preferencias del blog',

## tmpl/cms/widget/new_version.tmpl
	'What\'s new in Movable Type [_1]' => 'Novedades en Movable Type [_1]',
	'Congratulations, you have successfully installed Movable Type [_1]. Listed below is an overview of the new features found in this release.' => '¡Felicidades, ha instalado con éxito Movable Type [_1]! Debajo encontrará un resumen de las nuevas funciones de esta versión.',

## tmpl/cms/widget/this_is_you.tmpl
	'Your <a href="[_1]">last entry</a> was [_2] in <a href="[_3]">[_4]</a>.' => 'La <a href="[_1]">última entrada</a> estaba [_2] en <a href="[_3]">[_4]</a>.',
	'Your last entry was [_1] in <a href="[_2]">[_3]</a>.' => 'Su última entrada fue [_1] en <a href="[_2]">[_3]</a>.',
	'You have <a href="[_1]">[quant,_2,draft,drafts]</a>.' => 'Tiene <a href="[_1]">[quant,_2,borrador,borradores]</a>.',
	'You have [quant,_1,draft,drafts].' => 'Tiene [quant,_1,borrador,borradores].',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a> with <a href="[_3]">[quant,_4,comment,comments]</a>.' => 'Usted ha escrito <a href="[_1]">[quant,_2,entrada,entradas]</a> con <a href="[_3]">[quant,_4,comentario,comentarios]</a>.',
	'You\'ve written [quant,_1,entry,entries] with <a href="[_2]">[quant,_3,comment,comments]</a>.' => 'Ha escrito [quant,_1,entrada,entradas] con <a href="[_2]">[quant,_3,comentario,comentarios]</a>.',
	'You\'ve written [quant,_1,entry,entries] with [quant,_2,comment,comments].' => 'Ha escrito [quant,_1,entrada,entradas] con [quant,_2,comentario,comentarios].',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>.' => 'Usted ha escrito <a href="[_1]">[quant,_2,entrada,entradas]</a>.',
	'You\'ve written [quant,_1,entry,entries].' => 'Ha escrito [quant,_1,entrada,entradas].',
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
	'View all entries' => 'Mostrar todas las entradas',

## tmpl/cms/widget/blog_stats_tag_cloud.tmpl

## tmpl/cms/widget/blog_stats_comment.tmpl
	'Most Recent Comments' => 'Últimos comentarios',
	'[_1] [_2], [_3] on [_4]' => '[_1] [_2], [_3] en [_4]',
	'View all comments' => 'Mostrar todos los comentarios',
	'No comments available.' => 'No hay comentarios disponibles',

## tmpl/cms/restore_end.tmpl
	'Make sure that you remove the files that you restored from the \'import\' folder, so that if/when you run the restore process again, those files will not be re-restored.' => 'Asegúrese de que elimina los ficheros que ha restaurado de la carpeta \'importar\', por si ejecuta el proceso en otra ocasión que éstos no vuelvan a restaurar.',
	'An error occurred during the restore process: [_1] Please check activity log for more details.' => 'Ocurrió un error durante el proceso de restauración: [_1] Por favor, compruebe el registro de actividad para más detalles.',

## tmpl/cms/system_check.tmpl
	'User Counts' => 'Número de usuarios',
	'Number of users in this system.' => 'Número de usuarios en el sistema.',
	'Total Users' => 'Usuarios Totales',
	'Active Users' => 'Usuarios Activos',
	'Users who have logged in within 90 days are considered <strong>active</strong> in Movable Type license agreement.' => 'Los usuarios que se hayan identificado a lo largo de los últimos 90 días son considerados como activos según la licence Movable Type.',
	'Memcache Status' => 'Estado de memcache',
	'Server Model' => 'Modelo de servidor',
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

## tmpl/cms/list_folder.tmpl
	'Your folder changes and additions have been made.' => 'Se han realizado los cambios y añadidos a la carpeta.',
	'You have successfully deleted the selected folder.' => 'Ha borrado con éxito la carpeta seleccionada.',
	'Delete selected folders (x)' => 'Borrar carpetas seleccionadas (x)',
	'Create top level folder' => 'Crear carpeta raíz',
	'Create Folder' => 'Crear carpeta',
	'Create Subfolder' => 'Crear subcarpeta',
	'Move Folder' => 'Mover carpeta',
	'[quant,_1,page,pages]' => '[quant,_1,página,páginas]',
	'No folders could be found.' => 'No se encontró ninguna carpeta.',

## tmpl/cms/cfg_archives.tmpl
	'Error: Movable Type was not able to create a directory for publishing your blog. If you create this directory yourself, assign sufficient permissions that allow Movable Type to create files within it.' => 'Error: Movable Type no pudo crear un directorio para publicar el blog. Si desea crear el directorio usted mismo, asigne suficientes permisos para que Movable Type pueda crear ficheros en él.',
	'Your blog\'s archive configuration has been saved.' => 'Se guardó la configuración de archivos de su blog.',
	'You have successfully added a new archive-template association.' => 'Agregó correctamente una nueva asociación archivo-plantilla.',
	'You may need to update your \'Master Archive Index\' template to account for your new archive configuration.' => 'Podría tener que actualizar la plantilla \'Archivo índice maestro\' para tener en cuenta la nueva configuración del archivado.',
	'The selected archive-template associations have been deleted.' => 'Las asociaciones seleccionadas archivos-plantillas fueron eliminadas.',
	'Warning: one or more of your templates is set to publish dynamically using PHP, however your server side include method may not be compatible with dynamic publishing.' => 'Atención: una o más de las plantillas están configuradas para publicarse usando PHP, sin embargo, el método de inclusión podría no ser compatible con la publicación dinámica.',
	'You must set a valid Site URL.' => 'Debe establecer una URL de sitio válida.',
	'You must set a valid Local Site Path.' => 'Debe establecer una ruta local de sitio válida.',
	'You must set Local Archive Path.' => 'Debe indicar la ruta local de archivos.',
	'You must set a valid Archive URL.' => 'Debe indicar una URL de archivos válida.',
	'You must set a valid Local Archive Path.' => 'Debe indicar una ruta local de archivos válida.',
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
	'Asynchronous Job Queue' => 'Cola de trabajos asíncrona',
	'Use Publishing Queue' => 'Usar cola de publicación',
	'Requires the use of a cron job to publish pages in the background.' => 'Requiere el uso de una tarea del cron para publicar las páginas en segundo plano.',
	'Use background publishing queue for publishing static pages for this blog' => 'Usar la cola de publicación en segundo plano para la publicación de páginas estáticas en este blog.',
	'Dynamic Publishing Options' => 'Opciones de la publiación dinámica',
	'Enable dynamic cache' => 'Activar caché dinámica',
	'Enable conditional retrieval' => 'Activar recuperación condicional',
	'Archive Options' => 'Opciones de archivos',
	'File Extension' => 'Extensión de ficheros',
	'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'Introduzca la extensión de los archivos. Puede ser \'html\', \'shtml\', \'php\', etc. Nota: No introduzca el punto separador de la extensión (\'.\').',
	'Preferred Archive' => 'Archivo preferido',
	'Used for creating links to an archived entry (permalink). Select from the archive types used in this blogs archive templates.' => 'Utilizado para crear enlaces hacia una nota archivada (enlacepermanente).  Seleccione dentro de los archivos utilizados de las plantillas del blog.',
	'No archives are active' => 'No hay archivos activos',
	'Module Options' => 'Opciones de módulos',
	'Enable template module caching' => 'Activar la caché de plantillas de módulos',
	'Server Side Includes' => 'Server Side Includes',
	'None (disabled)' => 'Ninguno (deshabilitado)',
	'PHP Includes' => 'Inclusiones PHP',
	'Apache Server-Side Includes' => 'Inclusiones de Apache',
	'Active Server Page Includes' => 'Inclusiones de páginas Active Server',
	'Java Server Page Includes' => 'Inclusiones de páginas Java Server',

## tmpl/cms/rebuilding.tmpl
	'Publishing...' => 'Publicando...',
	'Publishing [_1]...' => 'Publicando [_1]...',
	'Publishing [_1] [_2]...' => 'Publicando [_1] [_2]...',
	'Publishing [_1] dynamic links...' => 'Publicando enlaces dinámicos [_1]...',
	'Publishing [_1] archives...' => 'Publicando archivos [_1]...',
	'Publishing [_1] templates...' => 'Publicando plantillas [_1]...',

## tmpl/cms/restore_start.tmpl
	'Restoring Movable Type' => 'Restaurando Movable Type',

## tmpl/comment/register.tmpl
	'Create an account' => 'Crear una cuenta',
	'Your email address.' => 'Dirección de correo electrónico.',
	'Your login name.' => 'Nombre de su usuario.',
	'The name appears on your comment.' => 'El nombre que aparece en su comentario.',
	'Select a password for yourself.' => 'Seleccione su contraseña.',
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
	'Return to the <a href="[_1]">original page</a>.' => 'Volver a la <a href="[_1]">página original</a>.',

## tmpl/include/chromeless_footer.tmpl
	'<a href="[_1]">Movable Type</a> version [_2]' => '<a href="[_1]">Movable Type</a> versión [_2]',

## tmpl/error.tmpl
	'Missing Configuration File' => 'Fichero de configuración no encontrado',
	'_ERROR_CONFIG_FILE' => 'El fichero de configuración de Your Movable Type no existe o no se puede leer correctamente. Por favor, consulte la sección <a href="javascript:void(0)">Instalación y configuración</a> del manual de Movable Type manual para más información.',
	'Database Connection Error' => 'Error de conexión a la base de datos',
	'_ERROR_DATABASE_CONNECTION' => 'Las opciones de configuración de su base de datos o son incorrectas o no están presentes en el fichero de configuración de Movable Type. Por favor, consulte la sección <a href="javascript:void(0)">Instalación y configuración</a> del manual de Movable Type para más información',
	'CGI Path Configuration Required' => 'Se necesita la configuración de la ruta de CGI',
	'_ERROR_CGI_PATH' => 'La opción de configuración CGIPath no es válida o no se encuentra en el fichero de configuración de Movable Type. Por favor, consulte la sección <a href="javascript:void(0)">Instalación y configuración</a> del manual de Movable Type manual para más información.',

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

## addons/Community.pack/config.yaml
	'Community Settings' => 'Configuración de la comunidad',
	'Pending Entries' => 'Entradas pendientes',
	'Spam Entries' => 'Entradas spam',
	'Following Users' => 'Usuarios que sigue',
	'Being Followed' => 'Seguidores',
	'Sanitize' => 'Esterilizar',
	'Recently Scored' => 'Puntuaciones recientes',
	'Recent Submissions' => 'Envíos recientes',
	'Most Popular Entries' => 'Entradas más populares',
	'Registrations' => 'Registros',
	'Login Form' => 'Formulario de inicio de sesión',
	'Password Reset Form' => 'Formulario de reinicio de contraseña',
	'Registration Form' => 'Formulario de registro',
	'Registration Confirmation' => 'Confirmación de registro',
	'Profile Error' => 'Error del perfil',
	'Profile View' => 'Ver perfil',
	'Profile Edit Form' => 'Formulario de edición del perfil',
	'Profile Feed' => 'Sindicación del perfil',
	'New Password Form' => 'Formulario de nueva contraseña',
	'New Password Reset Form' => 'Formulario de reinicio de contraseña',
	'Form Field' => 'Campo del formulario',
	'Status Message' => 'Mensaje de estado',
	'Simple Header' => 'Cabecera simple',
	'Simple Footer' => 'Pie simple',
	'Navigation' => 'Navegación',
	'Header' => 'Cabecera',
	'Footer' => 'Pie',
	'GlobalJavaScript' => 'GlobalJavaScript',
	'Email verification' => 'Verificación del correo',
	'Registration notification' => 'Notificación de registro',
	'New entry notification' => 'Notificación de nueva entrada',
	'Community Blog' => 'Blog de la comunidad',
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
	'Community Forum' => 'Foro de la comunidad',
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
	'Users followed by [_1]' => 'Seguidos por [_1]',
	'Users following [_1]' => 'Seguidores de [_1]',
	'Following' => 'Siguiendo',
	'Followers' => 'Seguidores',
	'Welcome to the Movable Type Community Solution' => 'Bienvenido a la Community Solution de Movable Type',
	'The Community Solution gives you to the tools to build a successful community with active, engaged conversations. Some key features to explore:' => 'Community Solution le ofrece las herramientas necesarias para construir una comunidad activa y con apasionantes conversaciones. Algunas de las funcionalidades más importantes a explorar son:',
	'Friends and Followers' => 'Amigos y seguidores',
	'Allow registered members to maintain a list of friends across your community' => 'Permitir a los usuarios registrados mantener una lista de amigos de tu comunidad',

## addons/Community.pack/php/function.mtentryrecommendvotelink.php

## addons/Community.pack/tmpl/widget/blog_stats_registration.mtml
	'Recent Registrations' => 'Registros recientes',
	'default userpic' => 'avatar predefinido',
	'You have [quant,_1,registration,registrations] from [_2]' => 'Tiene un [quant,_1,registro,registros] en [_2]',

## addons/Community.pack/tmpl/widget/most_popular_entries.mtml
	'There are no popular entries.' => 'No hay entradas populares.',

## addons/Community.pack/tmpl/widget/recent_submissions.mtml

## addons/Community.pack/tmpl/widget/recently_scored.mtml
	'There are no recently favorited entries.' => 'No hay recomendaciones recientes de entradas.',

## addons/Community.pack/tmpl/cfg_community_prefs.tmpl
	'Anonymous Recommendation' => 'Recomendación anónima',
	'Check to allow anonymous users (users not logged in) to recommend discussion.  IP address is recorded and used to identify each user.' => 'Active esta opción para permitir que los usuarios anónimos (aquellos que no han iniciado una sesión) puedan recomendar debates. Las direcciones IP se registran y se utilizan para identificar a cada usuario.',
	'Allow anonymous user to recommend' => 'Permitir que los usuarios anónimos hagan recomendaciones',
	'Save changes to blog (s)' => 'Guardar los cambios en el blog (s)',

## addons/Community.pack/templates/global/register_form.mtml
	'Sign up' => 'Registrarse',

## addons/Community.pack/templates/global/simple_footer.mtml

## addons/Community.pack/templates/global/profile_error.mtml
	'ERROR MSG HERE' => 'MENSAJE DE ERROR AQUÍ',

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

## addons/Community.pack/templates/global/password_reset_form.mtml
	'Reset Password' => 'Reiniciar la contraseña',
	'Your password has been changed, and the new password has been sent to your email address ([_1]).' => 'Se cambió su contraseña y la nueva se le ha enviado a su dirección de correo electrónico ([_1]).',
	'Back to the original page' => 'Regresar a la página original',

## addons/Community.pack/templates/global/signin.mtml
	'You are signed in as <a href="[_1]">[_2]</a>' => 'Está identificado como <a href="[_1]">[_2]</a>',
	'You are signed in as [_1]' => 'Está identificado como [_1]',
	'Edit profile' => 'Editar Perfil',
	'Sign out' => 'Salir',
	'Not a member? <a href="[_1]">Register</a>' => '¿No es miembro? <a href="[_1]">Registrarse</a>',

## addons/Community.pack/templates/global/profile_edit_form.mtml
	'Go <a href="[_1]">back to the previous page</a> or <a href="[_2]">view your profile</a>.' => '<a href="[_1]">Regresar a la página anterior</a> o <a href="[_2]">vea su perfil</a>.',
	'Upload New Userpic' => 'Transferir nuevo avatar',

## addons/Community.pack/templates/global/header.mtml
	'Blog Description' => 'Descripción del blog',

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

## addons/Community.pack/templates/global/register_confirmation.mtml
	'Authentication Email Sent' => 'Correo de autentificación enviado.',
	'Profile Created' => 'Perfil creado',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Regresar a la página original.</a>',

## addons/Community.pack/templates/global/footer.mtml

## addons/Community.pack/templates/global/navigation.mtml
	'Home' => 'Inicio',

## addons/Community.pack/templates/global/new_password_reset_form.mtml

## addons/Community.pack/templates/global/login_form_module.mtml
	'Logged in as <a href="[_1]">[_2]</a>' => 'Identificado como <a href="[_1]">[_2]</a>',
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

## addons/Community.pack/templates/blog/page.mtml

## addons/Community.pack/templates/blog/main_index_widgets_group.mtml

## addons/Community.pack/templates/blog/entry_summary.mtml

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

## addons/Community.pack/templates/blog/javascript.mtml

## addons/Community.pack/templates/blog/archive_index.mtml

## addons/Community.pack/templates/blog/trackbacks.mtml

## addons/Community.pack/templates/blog/recent_entries.mtml

## addons/Community.pack/templates/blog/sidebar.mtml

## addons/Community.pack/templates/blog/openid.mtml

## addons/Community.pack/templates/blog/categories.mtml

## addons/Community.pack/templates/blog/comments.mtml
	'The data in #comments-content will be replaced by some calls to paginate script' => 'Los datos en #comments-content se reemplazarán por llamadas al script de paginación', # Translate - New

## addons/Community.pack/templates/blog/dynamic_error.mtml

## addons/Community.pack/templates/blog/comment_listing_dynamic.mtml

## addons/Community.pack/templates/blog/powered_by.mtml

## addons/Community.pack/templates/blog/tag_cloud.mtml

## addons/Community.pack/templates/blog/recent_assets.mtml

## addons/Community.pack/templates/blog/comment_preview.mtml
	'Comment on [_1]' => 'Comentario en [_1]',

## addons/Community.pack/templates/blog/search.mtml

## addons/Community.pack/templates/forum/main_index.mtml
	'Forum Home' => 'Foro - Inicio',

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

## addons/Community.pack/templates/forum/dynamic_error.mtml

## addons/Community.pack/templates/forum/entry_popular.mtml
	'Popular topics' => 'Temas populares',

## addons/Community.pack/templates/forum/comment_preview.mtml
	'Reply to [_1]' => 'Responder a [_1]',
	'Previewing your Reply' => 'Vista previa de la respuesta',

## addons/Commercial.pack/config.yaml
	'Photo' => 'Foto',
	'Embed' => 'Embeber',
	'Custom Fields' => 'Campos personalizados',
	'Updating Universal Template Set to Professional Website set...' => 'Actualizar el conjuntto de plantillas Universal al conjunto Sitio Web Profesional...',
	'Professional Website' => 'Web Profesional',
	'Themes that are compatible with the Professional Website template set.' => 'Temas compatibles con el conjunto de plantillas Web Profesional.',
	'Blog Index' => 'Índice del blog',
	'Blog Entry Listing' => 'Lista de entradas',
	'Header' => 'Cabecera',
	'Footer' => 'Pie',
	'Navigation' => 'Navegación',
	'Entry Detail' => 'Detalle de la entrada',
	'Entry Metadata' => 'Entrada de los Metadatos',
	'Page Detail' => 'Detalle de la página',
	'Powered By (Footer)' => 'Powered By (Pie)',
	'Recent Entries Expanded' => 'Entradas recientes expandidas',
	'Footer Links' => 'Enlaces del pie',
	'Blog Activity' => 'Actividad del blog',
	'Blog Archives' => 'Archivos del blog',
	'Main Sidebar' => 'Barra lateral principal',

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

## addons/Commercial.pack/lib/CustomFields/Upgrade.pm
	'Moving metadata storage for pages...' => 'Trasladando los metadatos de las páginas...',

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Restoring custom fields data stored in MT::PluginData...' => 'Restaurando los datos de los campos personalizados guardados en MT::PluginData...',
	'Restoring asset associations found in custom fields ( [_1] ) ...' => 'Restaurando las asociaciones de los ficheros multimedia de los campos personalizados ( [_1] ) ...',
	'Restoring url of the assets associated in custom fields ( [_1] )...' => 'Restaurando url de los ficheros multimedia asociados en los campos personalizados ( [_1] )...',

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	'Are you sure you have used a \'[_1]\' tag in the correct context? We could not find the [_2]' => '¿Está seguro de que ha utilizado la etiqueta \'[_1]\' en el contexto adecuado? No se encontró el [_2]',
	'You used an \'[_1]\' tag outside of the context of the correct content; ' => 'Ha utilizado una etiqueta \'[_1]\' fuera del contexto del contenido correcto;',

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
	'The basename is used for entering custom field data through a 3rd party client. It must be unique.' => 'El nombre base se utiliza para introducir datos de campos personalizados a través de un cliente de otro fabricante. Debe ser único.',
	'Unlock this for editing' => 'Desbloquear para la edición',
	'Warning: Changing this field\'s basename may require changes to existing templates.' => 'Atención: Si cambia el nombre base de este campo, quizás se necesiten cambios en las plantillas existentes.',
	'Template Tag' => 'Etiqueta de plantilla',
	'Create a custom template tag for this field.' => 'Crea una etiqueta de plantilla personalizada para este campo.',
	'Example Template Code' => 'Código de ejemplo',
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
	'System-Wide' => 'Todo el sistema',

## addons/Commercial.pack/tmpl/asset-chooser.tmpl
	'Choose [_1]' => 'Seleccionar [_1]',
	'Remove [_1]' => 'Borrar [_1]',

## addons/Commercial.pack/templates/professional/notify-entry.mtml

## addons/Commercial.pack/templates/professional/category_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog_index.mtml

## addons/Commercial.pack/templates/professional/main_index.mtml

## addons/Commercial.pack/templates/professional/page.mtml

## addons/Commercial.pack/templates/professional/entry_summary.mtml

## addons/Commercial.pack/templates/professional/comment_response.mtml

## addons/Commercial.pack/templates/professional/commenter_notify.mtml

## addons/Commercial.pack/templates/professional/recent_entries_expanded.mtml
	'By [_1] | Comments ([_2])' => 'Por [_1] | Commentarios ([_2]) ',

## addons/Commercial.pack/templates/professional/footer-email.mtml

## addons/Commercial.pack/templates/professional/entry_detail.mtml

## addons/Commercial.pack/templates/professional/verify-subscribe.mtml

## addons/Commercial.pack/templates/professional/new-ping.mtml

## addons/Commercial.pack/templates/professional/comment_detail.mtml

## addons/Commercial.pack/templates/professional/comment_form.mtml

## addons/Commercial.pack/templates/professional/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] comentó en [_3]</a>: [_4]',

## addons/Commercial.pack/templates/professional/monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/comment_throttle.mtml

## addons/Commercial.pack/templates/professional/signin.mtml

## addons/Commercial.pack/templates/professional/new-comment.mtml

## addons/Commercial.pack/templates/professional/entry_listing.mtml
	'Recently by <em>[_1]</em>' => 'Novedades por <em>[_1]</em>',

## addons/Commercial.pack/templates/professional/footer.mtml

## addons/Commercial.pack/templates/professional/tags.mtml

## addons/Commercial.pack/templates/professional/navigation.mtml
	'Home' => 'Inicio',

## addons/Commercial.pack/templates/professional/entry_metadata.mtml

## addons/Commercial.pack/templates/professional/entry.mtml

## addons/Commercial.pack/templates/professional/javascript.mtml

## addons/Commercial.pack/templates/professional/archive_index.mtml

## addons/Commercial.pack/templates/professional/trackbacks.mtml

## addons/Commercial.pack/templates/professional/sidebar.mtml

## addons/Commercial.pack/templates/professional/powered_by_footer.mtml

## addons/Commercial.pack/templates/professional/openid.mtml

## addons/Commercial.pack/templates/professional/categories.mtml

## addons/Commercial.pack/templates/professional/comments.mtml

## addons/Commercial.pack/templates/professional/search_results.mtml

## addons/Commercial.pack/templates/professional/header.mtml

## addons/Commercial.pack/templates/professional/dynamic_error.mtml

## addons/Commercial.pack/templates/professional/footer_links.mtml
	'Links' => 'Enlaces',

## addons/Commercial.pack/templates/professional/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/recent_assets.mtml

## addons/Commercial.pack/templates/professional/comment_preview.mtml

## addons/Commercial.pack/templates/professional/search.mtml

## addons/Commercial.pack/templates/professional/commenter_confirm.mtml

## addons/Enterprise.pack/app-wizard.yaml
	'This module is required in order to use the LDAP Authentication.' => 'Este módulo es requerido para usar la identificación LDAP.',
	'This module is required in order to use SSL/TLS connection with the LDAP Authentication.' => 'Este módulo es necesario para usar la conexión SSL/TLS con la autentificación LDAP.',

## addons/Enterprise.pack/app-cms.yaml
	'Are you sure you want to delete the selected group(s)?' => '¿Está seguro de querer borrar el(los) grupo(s) seleccionados?',
	'Group' => 'Grupo',
	'Groups' => 'Grupos',
	'Bulk Author Export' => 'Exportación masiva de autores',
	'Bulk Author Import' => 'Importación de autores por lote',
	'Synchronize Users' => 'Sincronización de Usuarios',
	'Synchronize Groups' => 'Sincronizar grupos',

## addons/Enterprise.pack/config.yaml
	'Enterprise Pack' => 'Enterprise Pack',
	'Oracle Database' => 'Base de Datos Oracle',
	'Microsoft SQL Server Database' => 'Base de Datos Microsoft SQL Server',
	'Microsoft SQL Server Database (UTF-8 support)' => 'Base de Datos Microsoft SQL Server (UTF-8 support)',
	'External Directory Synchronization' => 'Sincronización del Directorio Externo',
	'Populating author\'s external ID to have lower case user name...' => 'Introduciendo el ID externo del autor para usar minúsculas...',

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

## addons/Enterprise.pack/tmpl/include/list_associations/page_title.group.tmpl
	'Users &amp; Groups for [_1]' => 'Usuarios &amp; Grupos de [_1]',
	'Group Associations for [_1]' => 'Asociaciones de grupos de [_1]',

## addons/Enterprise.pack/tmpl/include/users_content_nav.tmpl

## addons/Enterprise.pack/tmpl/include/group_table.tmpl
	'group' => 'grupo',
	'groups' => 'grupos',
	'Enable selected group (e)' => 'Habilitar grupo seleccionado (e)',
	'Disable selected group (d)' => 'Deshabilitar grupo seleccionado (d)',
	'Remove selected group (d)' => 'Borrar grupo seleccionado (d)',
	'Only show enabled groups' => 'Solo muestra los grupos activados',
	'Only show disabled groups' => 'Solo muestra los grupos desactivados',

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

## plugins/WXRImporter/WXRImporter.pl
	'Import WordPress exported RSS into MT.' => 'Importar WordPress exported RSS hacia MT.',
	'WordPress eXtended RSS (WXR)' => 'RSS Extendido de WordPress (WXR)',
	'Download WP attachments via HTTP.' => 'Descargar adjuntos de WP vía HTTP.',

## plugins/WXRImporter/tmpl/options.tmpl
	'Before you import WordPress posts to Movable Type, we recommend that you <a href=\'[_1]\'>configure your blog\'s publishing paths</a> first.' => 'Antes de importar las entradas de WordPress a Movable Type, le recomendamos que primero <a href=\'[_1]\'>configure las rutas de publicación del blog</a>.',
	'Upload path for this WordPress blog' => 'Ruta de transferencia para este blog de WordPress',
	'Replace with' => 'Reemplazar con',
	'Download attachments' => 'Descargar adjuntos',
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'Necesita el uso de una tarea del cron para descargar los adjuntos de un blog de WordPress en segundo plano.',
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'Descargar adjuntos (imágenes y ficheros) de un blog importado de WordPress.',

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
	'widget_label_width' => 'widget_label_width',
	'widget_totals_width' => 'widget_totals_width',
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

## plugins/StyleCatcher/config.yaml
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.' => 'StyleCatcher le permite navegar fácilmente por los estilos y aplicarlos a su blog fácilmente. Para más información sobre los estilos de Movable Type, o para encontrar más repositorios de estilos, visite la página de <a href=\'http://www.sixapart.com/movabletype/styles\'>estilos de Movable Type</a>.',
	'MT 4 Style Library' => 'Librería de estilos de MT 4',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Una colección de estilos compatible con las plantillas predefinidas de Movable Type.',
	'Styles' => 'Estilos',

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'No se encontró el directorio mt-static. Por favor, configure el \'StaticFilePath\' para continuar.',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'No se pudo crear el directorio [_1] - Compruebe que el servidor web puede escribir en la carpeta \'themes\'.',
	'Successfully applied new theme selection.' => 'Se aplicó con éxito la nueva selección de estilo.',
	'Invalid URL: [_1]' => 'URL no válida: [_1]',

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a Style' => 'Seleccione un estilo',
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

## plugins/spamlookup/spamlookup_urls.pl
	'SpamLookup - Link' => 'SpamLookup - Enlace',
	'SpamLookup module for junking and moderating feedback based on link filters.' => 'Módulo de SpamLookup para marcar como spam y moderar las respuestas a través de filtros de enlaces.',
	'SpamLookup Link Filter' => 'Filtro de enlaces de SpamLookup',
	'SpamLookup Link Memory' => 'Memoria de enlaces de SpamLookup',
	'SpamLookup Email Memory' => 'Memoria de correos de SpamLookup',

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

## plugins/MultiBlog/lib/MultiBlog.pm
	'The include_blogs, exclude_blogs, blog_ids and blog_id attributes cannot be used together.' => 'Los atributos include_blogs, exclude_blogs, blog_ids y blog_id no se pueden usar juntos.',
	'The attribute exclude_blogs cannot take "all" for a value.' => 'El atributo exclude_blogs no puede tener el valor "all".',
	'The value of the blog_id attribute must be a single blog ID.' => 'El valor del atributo blog_id debe ser el ID de un solo blog.',
	'The value for the include_blogs/exclude_blogs attributes must be one or more blog IDs, separated by commas.' => 'El valor de los atributos include_blogs/exclude_blogs debe ser uno o más IDs de blogs, separados por comas.',

## plugins/MultiBlog/lib/MultiBlog/Tags.pm
	'MTMultiBlog tags cannot be nested.' => 'Las etiquetas MTMultiBlog no se pueden anidar.',
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Valor del atributo "mode" desconocido: [_1]. Los valores válidos son "loop" y "context".',

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

## plugins/Textile/textile2.pl
	'A humane web text generator.' => 'Un generador de texto web humano',
	'Textile 2' => 'Textile 2',

## plugins/WidgetManager/WidgetManager.pl
	'Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.' => 'Administrador de Widgets versión 1.1; Esta versión de la extensión actualiza los datos de la versiones antiguas del Adminstrador de Widgets que venía con Movable Type al esquema interno de Movable Type. No se han incluído otras características. Puede borrar esta extensión sin problemas después de instalar o actualizar Movable Type.',
	'Moving storage of Widget Manager [_1]...' => 'Migrando Administrador de Widgets [_1]...',

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

## plugins/CommunityActionStreams/config.yaml
	'Action streams for community events: add entry, add comment, add favorite, follow user.' => 'Torrentes de acciones para eventos de la comunidad: añadir entrada, añadir comentario, añadir favorito, seguir usuario.',

## plugins/Motion/config.yaml
	'A Movable Type theme with structured entries and action streams.' => 'Tema de Movable Type con entradas estructuradas y torrentes de acciones.',
	'Adjusting field types for embed custom fields...' => 'Ajustando los tipos de campos para campos personalizados embebidos...',
	'Updating favoriting namespace for Motion...' => 'Actualizando el espacio de nombres de los favoritos para Motion...',
	'Motion Themes' => 'Temas de Motion',
	'Themes for Motion template set' => 'Temas para el conjunto de plantillas Motion',
	'Motion' => 'Motion',
	'Post Type' => 'Tipo de entrada',
	'Photo' => 'Foto',
	'Embed Object' => 'Embeber objeto',
	'MT JavaScript' => 'MT JavaScript',
	'Motion MT JavaScript' => 'Motion MT JavaScript',
	'Motion JavaScript' => 'Motion JavaScript',
	'Entry Listing: Monthly' => 'Lista de entradas: Mensual',
	'Entry Listing: Category' => 'Lista de entradas: Categorías',
	'Entry Listing: Author' => 'Lista de entradas: Autor',
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
	'Actions (Local)' => 'Acciones (local)',
	'Single Entry' => 'Entrada sencilla',
	'Messaging' => 'Mensajería',
	'Form Field' => 'Campo del formulario',
	'About Pages' => 'Páginas Acerca de',
	'About Site' => 'Sobre el sitio',
	'Gallery' => 'Galería',
	'Main Column Actions' => 'Acciones de la columna principal',
	'Main Column Posting Form (All Media)' => 'Formulario de publicación de la columna principal (Todos los medios)',
	'Main Column Posting Form (Text Only, Like Twitter)' => 'Formulario de publicación de la columna principal (Solo texto, como Twitter)',
	'Main Column Registration' => 'Registro de la columna principal',
	'Fans' => 'Fans',
	'Popular Entries' => 'Entradas populares',
	'Elsewhere' => 'En otros sitios',
	'Following' => 'Siguiendo',
	'Followers' => 'Seguidores',
	'User Archives' => 'Archivos de usuario',
	'Blogroll' => 'Enlaces',
	'Feeds' => 'Sindicación',
	'Main Column Content' => 'Contenido de la columna principal',
	'Main Index Widgets' => 'Widgets del índice principal',
	'Archive Widgets' => 'Widgets de los archivos',
	'Entry Widgets' => 'Widgets de la entrada',
	'Footer Widgets' => 'Widgets del pie',
	'Default Widgets' => 'Widgets predefinidos',
	'Profile Widgets' => 'Widgets del perfil',

## plugins/Motion/lib/Motion/Search.pm
	'This module works with MT::App::Search.' => 'Este módulo funciona con MT::App::Search.',
	'Specify the blog_id of a blog that has Motion template set.' => 'Especifique el blog_id de un blog que tenga el conjunto de plantillas de Motion.',
	'Error loading template: [_1]' => 'Error cargando plantilla: [_1]',

## plugins/Motion/tmpl/edit_linkpost.tmpl

## plugins/Motion/tmpl/edit_videopost.tmpl
	'Embed code' => 'Embeber código',

## plugins/Motion/templates/Motion/widget_search.mtml

## plugins/Motion/templates/Motion/banner_header.mtml
	'Home' => 'Inicio',

## plugins/Motion/templates/Motion/widget_recent_comments.mtml
	'<p>[_3]...</p><div class="comment-attribution">[_4]<br /><a href="[_1]">[_2]</a></div>' => '<p>[_3]...</p><div class="comment-attribution">[_4]<br /><a href="[_1]">[_2]</a></div>',

## plugins/Motion/templates/Motion/widget_popular_entries.mtml
	'posted by <a href="[_1]">[_2]</a> on [_3]' => 'publicado por <a href="[_1]">[_2]</a> en [_3]',

## plugins/Motion/templates/Motion/widget_followers.mtml
	'Not being followed' => 'Sin seguidores',

## plugins/Motion/templates/Motion/entry_response.mtml

## plugins/Motion/templates/Motion/comment_response.mtml
	'<strong>Bummer....</strong> [_1]' => '<strong>Qué mala suerte....</strong> [_1]',

## plugins/Motion/templates/Motion/widget_about_ssite.mtml
	'About' => 'Sobre mi',
	'The Motion Template Set is a great example of the type of site you can build with Movable Type.' => 'El conjunto de plantillas de Motion es un buen ejemplo del tipo de sitio que puede hacer con Movable Type.',

## plugins/Motion/templates/Motion/comment_detail.mtml

## plugins/Motion/templates/Motion/register.mtml
	'Enter a password for yourself.' => 'Introduzca su contraseña.',
	'The URL of your website.' => 'La URL de su sitio web.',

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

## plugins/Motion/templates/Motion/entry_listing_author.mtml
	'Archived Entries from [_1]' => 'Entradas archivadas de [_1]',
	'Recent Entries from [_1]' => 'Entradas recientes de [_1]',

## plugins/Motion/templates/Motion/widget_categories.mtml

## plugins/Motion/templates/Motion/dynamic_error.mtml

## plugins/Motion/templates/Motion/widget_elsewhere.mtml
	'Are you sure you want to remove the [_1] from your profile?' => '¿Está seguro de que desea eliminar el [_1] del perfil?',
	'Your user name or ID is required.' => 'El usuario o el ID es obligatorio.',
	'Add a Service' => 'Añadir un servicio',
	'Service' => 'Servicio',
	'Select a service...' => 'Seleccionar un servicio...',
	'Your Other Profiles' => 'Sus otros perfiles',
	'Find [_1] Elsewhere' => 'Buscar [_1] en otro sitio',
	'Remove service' => 'Eliminar servicio',

## plugins/Motion/templates/Motion/widget_main_column_registration.mtml
	'<a href="javascript:void(0)" onclick="[_1]">Sign In</a>' => '<a href="javascript:void(0)" onclick="[_1]">Identifíquese</a>',
	'Not a member? <a href="[_1]">Register</a>' => '¿No es miembro? <a href="[_1]">Registrarse</a>',
	'(or <a href="javascript:void(0)" onclick="[_1]">Sign In</a>)' => '(o <a href="javascript:void(0)" onclick="[_1]">identifíquese</a>)',
	'No posting privileges.' => 'Sin privilegios de publicación.',

## plugins/Motion/templates/Motion/widget_following.mtml
	'Not following anyone' => 'No sigue a nadie',

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

## plugins/Motion/templates/Motion/page.mtml

## plugins/Motion/templates/Motion/entry_summary.mtml

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

## plugins/Motion/templates/Motion/widget_monthly_archives.mtml

## plugins/Motion/templates/Motion/profile_feed.mtml
	'Posted [_1] to [_2]' => '[_1] publicado en [_2]',
	'Commented on [_1] in [_2]' => 'Comentó en [_1] en [_2]',
	'followed [_1]' => 'sigue a [_1]',

## plugins/Motion/templates/Motion/widget_user_archives.mtml
	'Recenty entries from [_1]' => 'Entradas recientes de [_1]',

## plugins/Motion/templates/Motion/entry_listing_category.mtml

## plugins/Motion/templates/Motion/widget_signin.mtml
	'You are signed in as <a href="[_1]">[_2]</a>' => 'Está identificado como <a href="[_1]">[_2]</a>',
	'You are signed in as [_1]' => 'Está identificado como [_1]',
	'Edit profile' => 'Editar Perfil',
	'Sign out' => 'Salir',

## plugins/Motion/templates/Motion/widget_fans.mtml

## plugins/Motion/templates/Motion/entry_listing_monthly.mtml

## plugins/Motion/templates/Motion/register_confirmation.mtml
	'Authentication Email Sent' => 'Correo de autentificación enviado.',
	'Profile Created' => 'Perfil creado',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Regresar a la página original.</a>',

## plugins/Motion/templates/Motion/entry.mtml

## plugins/Motion/templates/Motion/widget_gallery.mtml
	'Recent Photos' => 'Fotos recientes',

## plugins/Motion/templates/Motion/sidebar.mtml

## plugins/Motion/templates/Motion/widget_recent_entries.mtml
	'posted by [_1] on [_2]' => 'publicada por [_1] en [_2]',

## plugins/Motion/templates/Motion/banner_footer.mtml

## plugins/Motion/templates/Motion/widget_main_column_actions.mtml

## plugins/Motion/templates/Motion/comments.mtml
	'what will you say?' => '¿Qué va a decir?',
	'[_1] [_2]in reply to comment from [_3][_4]' => '[_1] [_2]en respuesta al comentario de [_3][_4]',
	'Write a comment...' => 'Escriba un comentario...',

## plugins/Motion/templates/Motion/search_results.mtml

## plugins/Motion/templates/Motion/login_form.mtml
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

## plugins/Motion/templates/Motion/user_profile_edit.mtml
	'Go <a href="[_1]">back to the previous page</a> or <a href="[_2]">view your profile</a>.' => '<a href="[_1]">Regresar a la página anterior</a> o <a href="[_2]">vea su perfil</a>.',
	'Change' => 'cambiar',

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm

## plugins/FacebookCommenters/plugin.pl
	'Provides commenter registration through Facebook Connect.' => 'Provee registro de comentaristas a través de Facebook Connect.',
	'Set up Facebook Commenters plugin' => 'Configurar la extesión de comentaristas de Facebook',
	'{*actor*} commented on the blog post <a href="{*post_url*}">{*post_title*}</a>.' => '{*actor*} comentó en la entrada <a href="{*post_url*}">{*post_title*}</a>.',
	'Could not register story template with Facebook: [_1]. Did you enter the correct application secret?' => 'No se pudo registrar la plantilla de historias con Facebook: [_1]. ¿No introdujo el secreto correcto de la aplicación?',
	'Could not register story template with Facebook: [_1]' => 'No pudo registrar la plantilla de historias con Facebook: [_1]',
	'Facebook' => 'Facebook',

## plugins/FacebookCommenters/tmpl/blog_config_template.tmpl
	'Facebook Application Key' => 'Clave de la aplicación de Facebook',
	'The key for the Facebook application associated with your blog.' => 'La clave de la aplicación de Facebook asociada con su blog.',
	'Edit Facebook App' => 'Editar aplicación de Facebook',
	'Create Facebook App' => 'Crear aplicación de Facebook',
	'Facebook Application Secret' => 'Secreto de la aplicación de Facebook',
	'The secret for the Facebook application associated with your blog.' => 'El secreto de la aplicación de Facebook asociada con su blog.',

## plugins/mixiComment/mixiComment.pl
	'Allows commenters to sign in to Movable Type 4 using their own mixi username and password via OpenID.' => 'Permite a los comentaristas identificarse en Movable Type 4 usando su propio usuario y contraseña de mixi vía OpenID.',
	'Sign in using your mixi ID' => 'Identifíquese usando su ID de mixi ID',
	'Click the button to sign in using your mixi ID' => 'Click the button to sign in using your mixi ID',
	'mixi' => 'mixi',

## plugins/mixiComment/lib/mixiComment/App.pm
	'mixi reported that you failed to login.  Try again.' => 'mixi informó que falló la identificación. Inténtelo de nuevo.',

## plugins/mixiComment/tmpl/config.tmpl
	'A mixi ID has already been registered in this blog.  If you want to change the mixi ID for the blog, <a href="[_1]">click here</a> to sign in using your mixi account.  If you want all of the mixi users to comment to your blog (not only your my mixi users), click the reset button to remove the setting.' => 'Ya se ha registrado un ID de mixi en este blog. Si desea modificar el ID de mixi del blog, <a href="[_1]">haga clic aquí</a> para identificarse en su cuenta de mixi. Si desea que todos los usuarios de mixi puedan comentar en el blog (no solo sus usuarios de my mixi), haga clic en el botón de reiniciar para eliminar la configuración.',
	'If you want to restrict comments only from your my mixi users, <a href="[_1]">click here</a> to sign in using your mixi account.' => 'Si desea restringir los comentarios a sus usuarios de my mixi, <a href="[_1]">haga clic aquí</a> para identificarse en su cuenta de mixi.',

## plugins/ActionStreams/blog_tmpl/sidebar.mtml

## plugins/ActionStreams/blog_tmpl/main_index.mtml

## plugins/ActionStreams/blog_tmpl/actions.mtml
	'Recent Actions' => 'Acciones recientes',

## plugins/ActionStreams/blog_tmpl/archive.mtml

## plugins/ActionStreams/blog_tmpl/banner_footer.mtml

## plugins/ActionStreams/blog_tmpl/elsewhere.mtml
	'Find [_1] Elsewhere' => 'Buscar [_1] en otro sitio',

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
	'Posts' => 'Entradas',
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
	'Website' => 'Website',
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
	'Action Stream' => 'Torrente de acciones',
	'Main Index (Recent Actions)' => 'Índice principal (acciones recientes)',
	'Action Archive' => 'Archivo de acciones',
	'Feed - Recent Activity' => 'Sindicación - Actividad reciente',
	'Find Authors Elsewhere' => 'Buscar autores en otros sitios',
	'Enabling default action streams for selected profiles...' => 'Activando los torrentes de acciones predefinidos para los perfiles seleccionados...',

## plugins/ActionStreams/lib/ActionStreams/Upgrade.pm
	'Updating classification of [_1] [_2] actions...' => 'Actualizando la clasificación de [_1] [_2] acciones...',
	'Renaming "[_1]" data of [_2] [_3] actions...' => 'Renombrando los datos de "[_1]" de [_2] [_3] acciones...',

## plugins/ActionStreams/lib/ActionStreams/Worker.pm
	'No such author with ID [_1]' => 'No existe un autor con el ID [_1]',

## plugins/ActionStreams/lib/ActionStreams/Plugin.pm
	'Other Profiles' => 'Otros perfiles',
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

## plugins/ActionStreams/tmpl/blog_config_template.tmpl
	'Rebuild Indexes' => 'Reconstruir índices',
	'If selected, this blog\'s indexes will be rebuilt when new action stream events are discovered.' => 'Si se selecciona, los índices de este blog se reconstruirán al descubrir nuevos eventos de los torrentes de acciones.',
	'Enable rebuilding' => 'Activar reconstrucción',
	
	'Extension changed from [_1] to [_2]' => 'La extensión cambió de [_1] a [_2]', # Translate - New
       '[_1] changed from [_2] to [_3]' => '[_1] cambió de [_2] a [_3]', # Translate - New
       '\'[_1]\' edited the template \'[_2]\' in the blog \'[_3]\'' => '\'[_1]\' editó la plantilla \'[_2]\' en el blog \'[_3]\'', # Translate - New
       '\'[_1]\' edited the global template \'[_2]\'' => '\'[_1]\' editó la plantilla global \'[_2]\'', # Translate - New
       'Entries must be cloned if comments and trackbacks are cloned' => 'Las entradas deben clonarse si se clonan los comentarios y trackbacks', # Translate - New
       'Test e-mail was successfully sent to [_1]' => 'El correo de prueba se envió correctamente a [_1]', # Translate - New
       'These setting(s) are overridden by a value in the MT configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.' => 'Estas opciones están redefinidas por un valor en el fichero de configuración de MT: [_1]. Para controlar el valor en esta página, elimine el valor del fichero de configuración.', # Translate - New
       'Email address is [_1]' => 'La dirección de correo es [_1]', # Translate - New
       'Debug mode is [_1]' => 'El modo de depuración es [_1]', # Translate - New
       'Performance logging is on' => 'El histórico de rendimiento está activado', # Translate - New
       'Performance logging is off' => 'El histórico de rendimiento está desactivado', # Translate - New
       'Performance log path is [_1]' => 'La ruta de los históricos de rendimiento es [_1]', # Translate - New
       'Performance log threshold is [_1]' => 'El umbral del histórico de rendimiento es [_1]', # Translate - New
       'System Settings Changes Took Place' => 'Se realizaron cambios en la configuración del sistema', # Translate - New
       'You can find an explanation of the various debug modes in the <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">documentation</a>' => 'Puede encontrar una explicación de los diferentes modos de depuración en la <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">documentación</a>', # Translate - New
       'The published order of these assets can be changed using [_1]template tag modifiers[_2].' => 'Se puede modificar el orden publicado de estos elementos utilizando los [_1]modificadores de etiquetas de plantilla[_2]', # Translate - New
       'This is set to the same URL as the original blog.' => 'La URL coincide con la original del blog.', # Translate - New
       'This will overwrite the original blog.' => 'Esto sobreescribirá el blog original.', # Translate - New
       'No such template' => 'Esa plantilla no existe', # Translate - New
        'template_id cannot be a global template' => 'template_id no puede ser una plantilla global', # Translate - New
        'Output file cannot be asp or php' => 'El fichero de salida no puede ser asp o php', # Translate - New
        'You must pass a valid archive_type with the template_id' => 'Debe pasar un tipo de archivo (archive_type) válido con el template_id', # Translate - New
        'Template must have identifier entry_listing for non-Index archive types' => 'La plantilla debe tener un identificador entry_listing para los tipos de archivos que no sean índices', # Translate - New
        'Blog file extension cannot be asp or php for these archives' => 'El fichero del blog no puede ser asp o php para estos archivos', # Translate - New
        'Template must have identifier main_index for Index archive type' => 'La plantilla debe tener un identificador main_index para el tipo de archivos índices', # Translate - New
        'Add New' => 'Añadir nuevo', # Translate - Case
        'No asset(s) associated with this [_1]' => 'No existe/n elemento/s asociados a [_1]', # Translate - New
);

## New words: 379

1;
