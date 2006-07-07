package MT::L10N::es;
# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

use strict;
use MT::L10N::en_us;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

sub encoding { 'utf-8' } 

## The following is the translation table.

%Lexicon = (

    ## ./mt-check.cgi.pre
    'Movable Type System Check' => 'Movable Type - Comprobación del Sistema',
    'This page provides you with information on your system\'s configuration and determines whether you have all of the components you need to run Movable Type.' => 'Esta página le ofrece información sobre la configuración de su sistema y determina si están instalados todos los componentes necesarios para ejecutar Movable Type.',
    'System Information' => 'Información del sistema',
    'Current working directory:' => 'Directorio actual de trabajo:',
    'MT home directory:' => 'Directorio de inicio de MT:',
    'Operating system:' => 'Sistema operativo:',
    'Perl version:' => 'Versión de Perl:',
    'Perl include path:' => 'Ruta de búsqueda de Perl:',
    'Web server:' => 'Servidor web:',
    '(Probably) Running under cgiwrap or suexec' => '(Probablemente) Ejecutándose sobre cgiwrap o suexec',
    'Checking for [_1] Modules:' => 'Comprobación de módulos - [_1]:',
    'Some of the following modules are required by the various data storage options in Movable Type. In order run the system, your server needs to have either DB_File, or else DBI and at least one of the other modules installed.' => 'Algunos de los siguientes módulos son necesarios para el almacenamiento de datos en Movable Type. Para ejecutar el sistema, su servidor necesita tener o DB_File o algún DBI y al menos uno de los otros módulos instalados.',
    'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'O su servidor no tiene instalado [_1], o la versión que tiene instalada es muy antigua, o [_1] necesita otro módulo que no está instalado.',
    'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => 'Su servidor no tiene [_1] instalado, o [_1] necesita otro módulo que no está instalado.',
    'Please consult the installation instructions for help in installing [_1].' => 'Por favor, consulte las instrucciones de instalación para obtener ayuda de cómo instalar [_1].',
    'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN.' => 'La versión de DBD::mysql que tiene instalada es conocida por ser incompatible con Movable Type. Por favor, instale la versión actual desde CPAN.',
    'The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements.' => 'El $mod está instalado correctamente, pero necesita un módulo DBI actualizado. Por favor, consulte la nota de arriba sobre los requerimientos del módulo DBI.',
    'Your server has [_1] installed (version [_2]).' => 'Su servidor tiene [_1] instalado (versión [_2]).',
    'Movable Type System Check Successful' => 'Comprobación del sistema correcta.',
    'You\'re ready to go!' => '¡Todo listo para continuar!',
    'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Su servidor dispone de todos los módulos requeridos; no necesita instalar ningún módulo adicional. Puede continuar con las instrucciones de instalación.',

    ## ./extras/examples/plugins/mirror/mirror.pl

    ## ./extras/examples/plugins/mirror/tmpl/mirror.tmpl

    ## ./extras/examples/plugins/l10nsample/l10nsample.pl
    'l10nsample' => 'l10nsample', # Translate - Previous (2)
    'This description can be localized if there is l10n_class set.' => 'Esta descripción se puede traducir si se configura l10n_class.',
    'Fumiaki Yoshimatsu' => 'Fumiaki Yoshimatsu', # Translate - Previous (2)

    ## ./extras/examples/plugins/l10nsample/tmpl/view.tmpl
    'This phrase is processed in template.' => 'Esta frase se procesa en la plantilla.',

    ## ./default_templates/individual_entry_archive.tmpl
    'Main' => 'Inicio',
    'Tags' => 'Etiquetas',
    'Posted by [_1] on [_2]' => 'Publicado por [_1] en [_2]',
    'Permalink' => 'Enlace permanente',
    'TrackBack' => 'TrackBack', # Translate - Previous (1)
    'TrackBack URL for this entry:' => 'URL del Trackback para esta entrada:',
    'Listed below are links to weblogs that reference' => 'Listados abajo están los enlaces de los weblogs que le referencian',
    'from' => 'desde',
    'Read More' => 'Leer más',
    'Tracked on' => 'Seguido el',
    'Comments' => 'Comentarios',
    'Posted by' => 'Publicado por',
    'Anonymous' => 'Anónimo',
    'Posted on' => 'Publicado el',
    'Permalink to this comment' => 'Enlace permanente de este comentario',
    'Post a comment' => 'Publicar un comentario',
    '(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(Si no dejó aquí ningún comentario anteriormente, quizás necesite aprobación por parte del dueño del sitio, antes de que el comentario aparezca. Hasta entonces, no se mostrará en la entrada. Gracias por su paciencia).',
    'Name' => 'Nombre',
    'Email Address' => 'Dirección de correo electrónico',
    'URL' => 'URL', # Translate - Previous (1)
    'Remember personal info?' => '¿Recordar datos personales?',
    '(you may use HTML tags for style)' => '(puede usar etiquetas HTML para el estilo)',
    'Preview' => 'Vista previa',
    'Post' => 'Publicar',
    'Search' => 'Buscar',
    'Search this blog:' => 'Buscar en este blog:',
    'About' => 'Acerca de',
    'The previous post in this blog was <a href=' => 'La anterior entrada en este blog fue <a href=',
    'The next post in this blog is <a href=' => 'La siguiente entrada en este blog es <a href=',
    'Many more can be found on the <a href=' => 'Puede encontrar mucho más en el <a href=',
    'Subscribe to this blog\'s feed' => 'Suscribirse a este blog (XML)',
    'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds', # Translate - Previous (6)
    'What is this?' => '¿Qué es esto?',
    'This weblog is licensed under a' => 'Este weblog está licenciado bajo una',
    'Creative Commons License' => 'Licencia Creative Commons',

    ## ./default_templates/stylesheet.tmpl

    ## ./default_templates/uploaded_image_popup_template.tmpl

    ## ./default_templates/comment_error_template.tmpl
    'Comment Submission Error' => 'Error en el envío de comentarios',
    'Your comment submission failed for the following reasons:' => 'El envío de su comentario falló por las siguientes razones:',
    'Return to the original entry' => 'Volver a la entrada original',

    ## ./default_templates/rsd.tmpl

    ## ./default_templates/dynamic_site_bootstrapper.tmpl

    ## ./default_templates/main_index.tmpl
    'Continue reading' => 'Continuar leyendo',
    'TrackBacks' => 'TrackBacks', # Translate - Previous (1)
    'Recent Posts' => 'Entradas recientes',
    'Categories' => 'Categorías',
    'Archives' => 'Archivos',

    ## ./default_templates/comment_preview_template.tmpl
    'Comment on' => 'Comentado en',
    'Previewing your Comment' => 'Vista previa del comentario',
    'Cancel' => 'Cancelar',

    ## ./default_templates/site_javascript.tmpl
    'Thanks for signing in,' => 'Gracias por registrarse en,',
    '. Now you can comment. ' => '. Ahora puede comentar. ',
    'sign out' => 'salir',
    'You are not signed in. You need to be registered to comment on this site.' => 'No está registrado. Necesita registrarse  para comentar en este sitio.',
    'Sign in' => 'Registrarse',
    'If you have a TypeKey identity, you can' => 'Si tiene una cuenta en TypeKey, puede',
    'sign in' => 'registrarse',
    'to use it here.' => 'para usarla aquí.',

    ## ./default_templates/dynamic_pages_error_template.tmpl
    'Page Not Found' => 'Página no encontrada',

    ## ./default_templates/trackback_listing_template.tmpl
    ': Discussion on [_1]' => ': Discusión en [_1]',
    'Trackbacks: [_1]' => 'Trackbacks: [_1]', # Translate - Previous (2)
    'Tracked on [_1]' => 'Publicado en [_1]',

    ## ./default_templates/search_results_template.tmpl
    'SEARCH FEED AUTODISCOVERY LINK PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'EL ENLACE DE AUTODESCUBRIMIENTO DE LA FUENTE DE SINDICACIÓN DE BÚSQUEDAS SOLO SE PUBLICA CUANDO SE HA REALIZADO UNA BÚSQUEDA',
    'Search Results' => 'Resultado de la búsqueda',
    'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM', # Translate - Previous (7)
    'Search this site' => 'Buscar en este sitio',
    'Match case' => 'Distinguir mayúsculas',
    'Regex search' => 'Expresión regular',
    'SEARCH RESULTS DISPLAY' => 'MOSTRAR RESULTADOS DE LA BÚSQUEDA',
    'Matching entries from [_1]' => 'Entradas coincidentes de [_1]',
    'Entries from [_1] tagged with \'[_2]\'' => 'Entradas de [_1] etiquetadas en \'[_2]\'',
    'Posted <MTIfNonEmpty tag=' => 'Publicado <MTIfNonEmpty tag=',
    'NO RESULTS FOUND MESSAGE' => 'MENSAJE DE NINGÚN RESULTADO ENCONTRADO',
    'Entries matching \'[_1]\'' => 'Entradas coincidentes con \'[_1]\'',
    'Entries tagged with \'[_1]\'' => 'Entradas etiquetadas en \'[_1]\'',
    'No pages were found containing \'[_1]\'.' => 'No se encontraron páginas que contuvieran \'[_1]\'.',
    'Instructions' => 'Instrucciones',
    'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes' => 'Por defecto, este motor de búsquedas, trata de encontrar todas las palabras en cualquier orden. Para buscar una frase exacta, acote la frase con comillas dobles',
    'movable type' => 'movable type', # Translate - Previous (2)
    'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions' => 'El motor de búsqueda también soporta las palabras claves AND, OR y NOT para especificar expresiones lógicas (booleanas)',
    'personal OR publishing' => 'personal OR publicación',
    'publishing NOT personal' => 'publicación NOT personal',
    'END OF ALPHA SEARCH RESULTS DIV' => 'FIN DE LOS RESULTADOS DE BÚSQUEDA - ALPHA DIV',
    'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'COMIENZO DE LA BARRA LATERAL BETA PARA MOSTRAR LA INFORMACIÓN DE BÚSQUEDA',
    'SET VARIABLES FOR SEARCH vs TAG information' => 'ESPECIFICAR VARIABLES PARA LA BÚSQUEDA vs información de etiqueta',
    'Subscribe to feed' => 'Suscribirse a la fuente de sindicación',
    'If you use an RSS reader, you can subscribe to a feed of all future entries tagged \'[_1]\'.' => 'Si usa un lector de RSS, puede suscribirse a la fuente de todas las futuras entradas con la etiqueta \'[_1]\'.',
    'If you use an RSS reader, you can subscribe to a feed of all future entries matching \'[_1]\'.' => 'Si usa un lector de RSS, puede suscribirse a la fuente de sindicación de todas las futuras entradas que contengan \'[_1]\'.',
    'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'INFORMACIÓN DE SUSCRIPCIÓN A LA FUENTE DE BÚSQUEDA/ETIQUETA',
    'Feed Subscription' => 'Suscripción a fuentes',
    'TAG LISTING FOR TAG SEARCH ONLY' => 'LISTA DE ETIQUETAS PARA LA BÚSQUEDA DE SOLO ETIQUETAS',
    'Other Tags' => 'Otras etiquetas',
    'Other tags used on this blog' => 'Otras etiquetas usadas en este blog',
    'END OF PAGE BODY' => 'FIN DEL CUERPO DE LA PÁGINA',
    'END OF CONTAINER' => 'FIN DEL CONTENEDOR',

    ## ./default_templates/datebased_archive.tmpl
    'About [_1]' => 'Acerca de [_1]',
    '<a href=' => '<a href=', # Translate - Previous (3)

    ## ./default_templates/category_archive.tmpl
    'Posted on [_1]' => 'Publicado en [_1]',

    ## ./default_templates/comment_pending_template.tmpl
    'Comment Pending' => 'Comentario pendiente',
    'Thank you for commenting.' => 'Gracias por comentar.',
    'Your comment has been received and held for approval by the blog owner.' => 'El comentario que envió fue recibido y está retenido para su aprobación por parte del administrador del weblog.',

    ## ./default_templates/rss_20_index.tmpl

    ## ./default_templates/master_archive_index.tmpl
    ': Archives' => ': Archivos',

    ## ./default_templates/atom_index.tmpl

    ## ./search_templates/comments.tmpl
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

    ## ./search_templates/results_feed.tmpl
    'Search Results for [_1]' => 'Resultados de la búsqueda sobre [_1]',

    ## ./search_templates/results_feed_rss2.tmpl

    ## ./search_templates/default.tmpl
    'Blog Search Results' => 'Resultados de la búsqueda en el blog',
    'Blog search' => 'Buscar en el blog',

    ## ./plugins/nofollow/nofollow.pl
    'Adds a \'nofollow\' relationship to comment and TrackBack hyperlinks to reduce spam.' => 'Añade una relación \'nofollow\' a los hiperenlaces de comentarios y TrackBacks para reducir el spam.',
    'Restrict:' => 'Restringir:',
    'Don\'t add nofollow to links in comments by authenticated commenters' => 'No añadir nofollow a los enlaces en los comentarios realizados por comentaristas autentificados',

    ## ./plugins/TemplateRefresh/TemplateRefresh.pl
    'Backup and refresh existing templates to Movable Type\'s default templates.' => 'Realizar copia de seguridad y refrescar las plantillas existentes con las plantillas por defecto de Movable Type.',

    ## ./plugins/TemplateRefresh/tmpl/results.tmpl
    'Backup and Refresh Templates' => 'Copiar y refrescar plantillas',
    'No templates were selected to process.' => 'No se han seleccionado plantillas para procesar.',
    'Return' => 'Volver',

    ## ./plugins/feeds-app-lite/mt-feeds.pl
    'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type?' => 'Feeds.App Lite le ayuda a publicar fuentes de sindicación en los blogs. ¿Desea hacer más cosas con fuentes en Movable Type?',
    'Upgrade to Feeds.App' => 'Actualícese a Feeds.App',

    ## ./plugins/feeds-app-lite/tmpl/select.tmpl
    'Feeds.App Lite Widget Creator' => 'Creador de widgets de Feeds.App Lite',
    'Multiple feeds were discovered. Select the feed you wish to use. Feeds.App lite supports text-only RSS 1.0, 2.0 and Atom feeds.' => 'Se descubrieron varias fuentes. Seleccione la que desee usar. Feeds.App Lite soporta los formatos -solo texto- RSS 1.0, 2.0 y Atom.',
    'Type' => 'Tipo',
    'URI' => 'URI', # Translate - Previous (1)
    'Continue' => 'Continuar',

    ## ./plugins/feeds-app-lite/tmpl/msg.tmpl
    'No feeds could be discovered using [_1].' => 'No se descubrieron fuentes usando [_1].',
    'An error occurred processing [_1]. Check <a href=' => 'Ocurrió un error procesando. Compruebe <a href=',
    'It can be included onto your published blog using <a href=' => 'Puede incluirse en su blog usando <a href=',
    'It can be included onto your published blog using this MTInclude tag' => 'Puede incluirse en su blog usando esta etiqueta MTInclude',
    'Go Back' => 'Ir atrás',
    'Create Another' => 'Crear otro',

    ## ./plugins/feeds-app-lite/tmpl/header.tmpl
    'Main Menu' => 'Menú principal',
    'System Overview' => 'Resumen del sistema',
    'Help' => 'Ayuda',
    'Welcome' => 'Bienvenido',
    'Logout' => 'Cerrar sesión',
    'Entries' => 'Entradas',
    'Search (q)' => 'Buscar (q)',

    ## ./plugins/feeds-app-lite/tmpl/start.tmpl
    'Feeds.App Lite creates modules that include feed data. Once you\'ve used it to create those modules, you can then use them in your blog templates.' => 'Feeds.App Lite crea módulos para incluir datos de fuentes de sindicación (\'feeds\'). Una vez sepa crear estos módulos, podrá usarlos en las plantillas de sus blogs.',
    'You must enter an address to proceed' => 'Debe introducir una dirección para proceder',
    'Enter the URL of a feed, or the URL of a site that has a feed.' => 'Introduzca la URL de una fuente de sindicación, o la URL de un sitio que tenga una fuente.',

    ## ./plugins/feeds-app-lite/tmpl/footer.tmpl

    ## ./plugins/feeds-app-lite/tmpl/config.tmpl
    'Feed Configuration' => 'Configuración de fuentes',
    'Feed URL' => 'URL de la fuente',
    'Title' => 'Título',
    'Enter a title for your widget.  This will also be displayed as the title of the feed when used on your published blog.' => 'Teclee un título para su widget. Esto también se mostrará como título de la fuente en el blog.',
    'Display' => 'Mostrar',
    '3' => '3', # Translate - Previous (1)
    '5' => '5', # Translate - Previous (1)
    '10' => '10', # Translate - Previous (1)
    'All' => 'Todos',
    'Select the maximum number of entries to display.' => 'Seleccione el máximo número de entradas a mostrar.',
    'Save' => 'Guardar',

    ## ./plugins/spamlookup/spamlookup_words.pl
    'SpamLookup module for moderating and junking feedback using keyword filters.' => 'Módulo de SpamLookup para moderar y marcar como basura las opiniones usando filtros de palabras clave.',

    ## ./plugins/spamlookup/spamlookup_urls.pl
    'SpamLookup - Link' => 'SpamLookup - Enlace',
    'SpamLookup module for junking and moderating feedback based on link filters.' => 'Módulo de SpamLookup para marcar como basura y moderar las opiniones en base a filtros de enlaces.',

    ## ./plugins/spamlookup/spamlookup.pl
    'SpamLookup module for using blacklist lookup services to filter feedback.' => 'Módulo de SpamLookup para usar servicios de listas negras para filtrar las opiniones.',

    ## ./plugins/spamlookup/tmpl/url_config.tmpl
    'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Los filtros de enlaces monitorizan el número de hiperenlaces que llegan en las opiniones entrantes. Las opiniones con muchos enlaces se bloquean para moderarlos o se marcan como basura. Por el contrario, las opiniones que no tienen enlaces o contienen referencias a URLs publicadas con anterioridad se puntúan de forma positiva. (Habilite sólo esta opción si está completamente seguro de que su sitio está libre previamente de spam)',
    'Link Limits:' => 'Límite de enlaces:',
    'Credit feedback rating when no hyperlinks are present' => 'Puntuación de las opiniones cuando no hay hiperenlaces presentes',
    'Adjust scoring' => 'Ajustar puntuación',
    'Score weight:' => 'Peso de puntuación:',
    'Decrease' => 'Disminuir',
    'Increase' => 'Aumentar',
    'Moderate when more than' => 'Moderar cuando se dan más de',
    'link(s) are given' => 'enlace/s',
    'Junk when more than' => 'Marcar como basura cuando hay más de',
    'Link Memory:' => 'Memoria de enlaces:',
    'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Puntuación de las opiniones cuando el elemento &quot;URL&quot; de la opinión se ha publicado antes',
    'Only applied when no other links are present in message of feedback.' => 'Solo se aplica cuando no hay otros enlaces presentes en el mensaje de la opinión.',
    'Exclude URLs from comments published within last [_1] days.' => 'Excluir las URLs de los comentarios publicados en los últimos[_1] días.',
    'Email Memory:' => 'Memoria de correos electrónicos:',
    'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Puntuación de las opiniones cuando la dirección de &quot;correo electrónico&quot; se encuentra en comentarios publicados con anterioridad',
    'Exclude Email addresses from comments published within last [_1] days.' => 'Excluir las direcciones de correo electrónico de los comentarios publicados en los últimos [_1] días.',

    ## ./plugins/spamlookup/tmpl/lookup_config.tmpl
    'Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog\'s Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.' => 'Las comprobaciones monitorizan las direcciones IP de origen y los hiperenlaces de todas las opiniones entrantes. Si un comentario o TrackBack viene de una dirección IP incluída en una lista negra, se bloqueará para su moderación o se marcará como basura y se trasladará a la carpeta de Basura. De forma adicional, se podrán realizar comprobaciones avanzadas en los datos de TrackBack.',
    'IP Address Lookups:' => 'Comprobaciones de direcciones IP:',
    'Off' => 'Desactivar',
    'Moderate feedback from blacklisted IP addresses' => 'Moderar las opiniones de las direcciones IP incluídas en listas negras',
    'Junk feedback from blacklisted IP addresses' => 'Marcar como basura las opiniones de las direcciones IP incluídas en listas negras',
    'Less' => 'Menos',
    'More' => 'Más',
    'block' => 'bloquear',
    'none' => 'nada',
    'IP Blacklist Services:' => 'Servicios de listas negras de IPs:',
    'Domain Name Lookups:' => 'Comprobaciones de dominios:',
    'Moderate feedback containing blacklisted domains' => 'Moderar las opiniones que contengan dominios incluídos en las listas negras',
    'Junk feedback containing blacklisted domains' => 'Moderar las opiniones que contengan dominios incluídos en las listas negras',
    'Domain Blacklist Services:' => 'Servicios de listas negras de dominios:',
    'Advanced TrackBack Lookups:' => 'Comprobaciones avanzadas de TrackBacks:',
    'Moderate TrackBacks from suspicious sources' => 'Moderar los TrackBacks de origen sospechoso',
    'Junk TrackBacks from suspicious sources' => 'Marcar como basura los TrackBacks de origen sospechoso',
    'To prevent lookups for some IP addresses or domains, list them below. Place each entry on a line by itself.' => 'Para prevenir la comprobación de ciertas direcciones IP o dominios, lístelos abajo. Indique cada uno en líneas separadas.',
    'Lookup Whitelist:' => 'Lista blanca:',

    ## ./plugins/spamlookup/tmpl/word_config.tmpl
    'Incomming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Las opiniones entrantes se pueden monitorizar según palabras clave, dominios, y patrones. Las coincidencias se pueden bloquear para moderarlas o puntuarlas como basura. Adicionalmente, la puntuación de las opiniones basura se pueden personalizar.',
    'Keywords to Moderate:' => 'Palabras clave a moderar:',
    'Keywords to Junk:' => 'Palabras clave para marcar como basura:',

    ## ./plugins/GoogleSearch/GoogleSearch.pl

    ## ./plugins/GoogleSearch/tmpl/config.tmpl
    'Google API Key:' => 'Contraseña para la API de Google:',
    'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.' => 'Si desea utilizar cualquier funcionalidad de la API de Google, deberá disponer de la contraseña correspondiente. Cópiela y péguela aquí.',

    ## ./plugins/StyleCatcher/stylecatcher.pl
    '<p style=' => '<p style=', # Translate - Previous (3)
    'Theme Root URL:' => 'URL del estilo:',
    'Theme Root Path:' => 'Directorio del estilo:',
    'Style Library URL:' => 'URL de la biblioteca de estilos:',

    ## ./plugins/StyleCatcher/tmpl/gmscript.tmpl

    ## ./plugins/StyleCatcher/tmpl/header.tmpl
    'View Site' => 'Ver sitio',

    ## ./plugins/StyleCatcher/tmpl/view.tmpl
    'Please select a weblog to apply this theme.' => 'Por favor, seleccione un weblog al que aplicar este estilo.',
    'Please click on a theme before attempting to apply a new design to your blog.' => 'Por favor, haga clic en un estilo antes de aplicarle un nuevo diseño al blog.',
    'Applying...' => 'Aplicando...',
    'Choose this Design' => 'Seleccionar este diseño',
    'Find Style' => 'Buscar estilo',
    'Loading...' => 'Cargando...',
    'StyleCatcher user script.' => 'script de usuario de StyleCatcher.',
    'Theme or Repository URL:' => 'URL del estilo o repositorio:',
    'Find Styles' => 'Buscar estilos',
    'NOTE:' => 'NOTA:',
    'It will take a moment for themes to populate once you click \'Find Style\'.' => 'Una vez haga clic en \'Buscar estilo\' tomará algunos momentos cargar los estilos.',
    'Current theme for your weblog' => 'Estilo actual de su weblog',
    'Current Theme' => 'Estilo actual',
    'Current themes for your weblogs' => 'Estilos actuales de sus weblogs',
    'Current Themes' => 'Estilos actuales',
    'Locally saved themes' => 'Estilos guardados localmente',
    'Saved Themes' => 'Estilos guardados',
    'Single themes from the web' => 'Estilos individuales del web',
    'More Themes' => 'Más estilos',
    'Templates' => 'Plantillas',
    'Details' => 'Detalles',
    'Show Details' => 'Mostrar detalles',
    'Hide Details' => 'Ocultar detalles',
    'Select a Weblog...' => 'Seleccionar un weblog...',
    'Apply Selected Design' => 'Aplicar estilo seleccionado',
    'You don\'t appear to have any weblogs with a \'styles-site.css\' template that you have rights to edit. Please check your weblog(s) for this template.' => 'No parece tener ningún weblog con una plantilla \'styles-site.css\' en la que tenga permisos para editar. Por favor, compruebe esta plantilla en su/s weblog/s.',

    ## ./plugins/StyleCatcher/tmpl/footer.tmpl

    ## ./plugins/WidgetManager/WidgetManager.pl
    'Maintain your weblog\'s widget content using a handy drag and drop interface.' => 'Mantener el contenido del widget de su weblog utilizando un interfaz de arrastrar y soltar.',

    ## ./plugins/WidgetManager/tmpl/list.tmpl
    'Widget Manager' => 'Administrador de widgets',
    'Your changes to the Widget Manager have been saved.' => 'Se han guardado los cambios del Administrador de widgets.',
    'You have successfully deleted the selected Widget Manager(s) from your weblog.' => 'Se eliminaron con éxito de su weblog el/los administrador/es de widgets seleccionado/s.',
    'To add a Widget Manager to your templates, use the following syntax:' => 'Para añadir un administrador de widgets a sus plantillas, use la siguiente sintaxis:',
    'Widget Managers' => 'Administradores de widgets',
    'Add Widget Manager' => 'Añadir administrador de widgets',
    'Create Widget Manager' => 'Crear administrador de widgets',
    'Delete Selected' => 'Borrar seleccionados',
    'Are you sure you wish to delete the selected Widget Manager(s)?' => '¿Está seguro de que desea borrar el/los administrador/es de widgets seleccionados?',
    'WidgetManager Name' => 'Nombre del Administrador de widgets',
    'Installed Widgets' => 'Widgets instalados',

    ## ./plugins/WidgetManager/tmpl/header.tmpl
    'Movable Type Publishing Platform' => 'Movable Type Publishing Platform', # Translate - Previous (4)
    'Weblogs' => 'Weblogs', # Translate - Previous (1)
    'Go' => 'Ir',

    ## ./plugins/WidgetManager/tmpl/edit.tmpl
    'You already have a widget manager named [_1]. Please use a unique name for this widget manager.' => 'Ya tiene un administrador de widgets llamado [_1]. Por favor, use un nombre único para este administrador de widgets.',
    'Rearrange Items' => 'Reordenar elementos',
    'Widget Manager Name:' => 'Nombre del Administrador de widgets:',
    'Build WidgetManager:' => 'Construir Administrador de widgets:',
    'Available Widgets' => 'Widgets disponibles',
    'Save Changes' => 'Guardar cambios',
    'Save changes (s)' => 'Guardar cambios (s)',

    ## ./plugins/WidgetManager/tmpl/footer.tmpl

    ## ./plugins/WidgetManager/default_widgets/search.tmpl

    ## ./plugins/WidgetManager/default_widgets/recent_posts.tmpl

    ## ./plugins/WidgetManager/default_widgets/technorati_search.tmpl
    'Technorati' => 'Technorati', # Translate - Previous (1)
    'this blog' => 'este blog',
    'all blogs' => 'todos los blogs',
    'Blogs that link here' => 'Blogs que enlazan aquí',

    ## ./plugins/WidgetManager/default_widgets/copyright.tmpl

    ## ./plugins/WidgetManager/default_widgets/creative_commons.tmpl

    ## ./plugins/WidgetManager/default_widgets/recent_comments.tmpl
    'Recent Comments' => 'Comentarios recientes',

    ## ./plugins/WidgetManager/default_widgets/subscribe_to_feed.tmpl

    ## ./plugins/WidgetManager/default_widgets/monthly_archive_dropdown.tmpl
    'Select a Month...' => 'Seleccione un mes...',

    ## ./plugins/WidgetManager/default_widgets/monthly_archive_list.tmpl

    ## ./plugins/WidgetManager/default_widgets/category_archive_list.tmpl

    ## ./plugins/WidgetManager/default_widgets/calendar.tmpl
    'Monthly calendar with links to each day\'s posts' => 'Calendario mensual con los enlaces a las entradas de cada día',
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

    ## ./plugins/WidgetManager/default_widgets/tag_cloud_module.tmpl
    'Tag cloud' => 'Nube de etiquetas',

    ## ./lib/MT/default-templates.pl

    ## ./build/template_hash_signatures.pl

    ## ./build/exportmt.pl

    ## ./build/l10n/diff.pl

    ## ./build/l10n/wrap.pl

    ## ./build/l10n/trans.pl

    ## ./tmpl/error.tmpl
    'Missing Configuration File' => 'Fichero de configuración no encontrado',
    'Database Connection Error' => 'Error de conexión a la base de datos',
    'CGI Path Configuration Required' => 'Se necesita la configuración de la ruta de CGI',
    'An error occurred' => 'Ocurrió un error',

    ## ./tmpl/cms/edit_entry.tmpl
    'You have unsaved changes to your entry that will be lost.' => 'Hay cambios no guardados en la entrada que se van a perder.',
    'Add new category...' => 'Crear nueva categoría...',
    'Publish On' => 'Publicado el',
    'Entry Date' => 'Fecha de la entrada',
    'You must specify at least one recipient.' => 'Debe especificar al menos un destinatario.',
    'Create New Entry' => 'Crear nueva entrada',
    'Edit Entry' => 'Editar entrada',
    'Your entry has been saved. You can now make any changes to the entry itself, edit the authored-on date, or edit comments.' => 'Se ha guardado la entrada. Ahora puede hacer cualquier cambio en la entrada, editar la fecha de creación, o editar los comentarios.',
    'Your changes have been saved.' => 'Sus cambios han sido guardados.',
    'One or more errors occurred when sending update pings or TrackBacks.' => 'Ocurrieron uno o más errores durante el envío de pings o TrackBacks.',
    'Your customization preferences have been saved, and are visible in the form below.' => 'Se guardaron los cambios en las preferencias y pueden verse en el siguiente formulario.',
    'Your changes to the comment have been saved.' => 'Se guardaron sus cambios al comentario.',
    'Your notification has been sent.' => 'Se envió su notificación.',
    'You have successfully deleted the checked comment(s).' => 'Eliminó correctamente los comentarios marcados.',
    'You have successfully deleted the checked TrackBack(s).' => 'Eliminó correctamente los TrackBacks marcados.',
    'Previous' => 'Anterior',
    'List &amp; Edit Entries' => 'Listar y editar entradas',
    'Next' => 'Siguiente',
    '_external_link_target' => '_top',
    'View Entry' => 'Ver entrada',
    'Entry' => 'Entrada',
    'Comments ([_1])' => 'Comentarios ([_1])',
    'TrackBacks ([_1])' => 'TrackBacks ([_1])', # Translate - Previous (2)
    'Notification' => 'Notificación',
    'Status' => 'Estado',
    'Unpublished' => 'No publicado',
    'Published' => 'Publicado',
    'Scheduled' => 'Programado',
    'Category' => 'Categoría',
    'Assign Multiple Categories' => 'Asignar múltiples categorías',
    'Entry Body' => 'Cuerpo de la entrada',
    'Bold' => 'Negrita',
    'Italic' => 'Cursiva',
    'Underline' => 'Subrayado',
    'Insert Link' => 'Insertar vínculo',
    'Insert Email Link' => 'Insertar enlace correo-e',
    'Quote' => 'Cita',
    'Bigger' => 'Más grande',
    'Smaller' => 'Más pequeño',
    'Extended Entry' => 'Entrada extendida',
    'Excerpt' => 'Resumen',
    'Keywords' => 'Palabras clave',
    '(comma-delimited list)' => '(lista separada por comas)',
    '(space-delimited list)' => '(lista separada por espacios)',
    '(delimited by \'[_1]\')' => '(separado por \'[_1]\')',
    'Text Formatting' => 'Formato del texto',
    'Basename' => 'Nombre base',
    'Unlock this entry\'s output filename for editing' => 'Desbloquear para la edición el nombre fichero de salida de esta entrada',
    'Warning' => 'Alerta',
    'Warning: If you set the basename manually, it may conflict with another entry.' => 'Atención: Si introduce el nombre base manualmente, podría entrar en conflicto con otra entrada.',
    'Warning: Changing this entry\'s basename may break inbound links.' => 'Atención: Si cambia el nombre base de la entrada, podría romper enlaces entrantes.',
    'Accept Comments' => 'Aceptar comentarios',
    'Accept TrackBacks' => 'Aceptar TrackBacks',
    'Outbound TrackBack URLs' => 'URLs de TrackBacks salientes',
    'View Previously Sent TrackBacks' => 'Ver TrackBacks enviados anteriormente',
    'Customize the display of this page.' => 'Personalizar la visualización de esta página.',
    'Manage Comments' => 'Administrar comentarios',
    'Click on a [_1] to edit it. To perform any other action, check the checkbox of one or more [_2] and click the appropriate button or select a choice of actions from the dropdown to the right.' => 'Haga clic en un [_1] para editarlo. Para realizar cualquier otra acción, active la casilla de uno o más [_2] y haga clic en el botón apropiado o seleccione una de las acciones del menú desplegable de la derecha.',
    'No comments exist for this entry.' => 'No existen comentarios en esta entrada.',
    'Manage TrackBacks' => 'Administrar TrackBacks',
    'No TrackBacks exist for this entry.' => 'No existen TrackBacks en esta entrada.',
    'Send a Notification' => 'Enviar notificación',
    'You can send an email notification of this entry to people on your notification list or using arbitrary email addresses.' => 'Puede enviar por correo electrónico una notificación de esta entrada a las personas de su lista de notificaciones o direcciones arbitrarias.',
    'Recipients' => 'Destinatarios',
    'Send notification to' => 'Enviar notificación a',
    'Notification list subscribers, and/or' => 'Suscriptores de la lista de notificación, y/o',
    'Other email addresses' => 'Otras direcciones de correo electrónico',
    'Note: Enter email addresses on separate lines or separated by commas.' => 'Nota: Introduzca las direcciones de correo electrónico en líneas separadas o separadas por comas.',
    'Notification content' => 'Notificación de contenidos',
    'Your blog\'s name, this entry\'s title and a link to view it will be sent in the notification.  Additionally, you can add a  message, include an excerpt of the entry and/or send the entire entry.' => 'En la notificación se enviará el nombre de este blog, el título de esta entrada y un enlace para verla. Además, puede añadir un mensaje, incluir un resumen de la entrada y/o enviar la entrada completa.',
    'Message to recipients (optional)' => 'Mensaje a los destinatarios (opcional)',
    'Additional content to include (optional)' => 'Contenido adicional a incluir (opcional)',
    'Entry excerpt' => 'Resumen de la entrada',
    'Entire entry body' => 'Entrada completa',
    'Note: If you choose to send the entire entry, it will be sent as shown on the editing screen, without any text formatting applied.' => 'Nota: Si selecciona enviar la entrada completa, se enviará tal y como aparece en la pantalla de edición, sin ningún formato de texto aplicado.',
    'Send entry notification' => 'Enviar notificación de entrada',
    'Send notification (n)' => 'Enviar notificación (n)',
    'Plugin Actions' => 'Acciones de extensiones',

    ## ./tmpl/cms/entry_prefs.tmpl
    'Entry Editor Display Options' => 'Preferencias del editor de entradas',
    'Your entry screen preferences have been saved.' => 'Se guardaron las nuevas preferencias del editor de entradas.',
    'Editor Fields' => 'Campos del editor',
    'Basic' => 'Básica',
    'Custom' => 'Personalizado',
    'Editable Authored On Date' => 'Fecha de autoría editable',
    'Action Bar' => 'Barra de acciones',
    'Select the location of the entry editor\'s action bar.' => 'Seleccione la posición de la barra de acciones del editor de entradas.',
    'Below' => 'Abajo',
    'Above' => 'Arriba',
    'Both' => 'Ambos',

    ## ./tmpl/cms/preview_entry.tmpl
    'Re-Edit this entry' => 'Volver a editar esta entrada',
    'Save this entry' => 'Guardar esta entrada',

    ## ./tmpl/cms/menu.tmpl
    'Welcome to [_1].' => 'Bienvenido a [_1].',
    'You can post to and manage your weblog by selecting an option from the menu located to the left of this message.' => 'Puede publicar y administrar su weblog seleccionado una opción en el menú situado a la izquierda de este mensaje.',
    'If you need assistance, try:' => 'Si necesita ayuda, consulte:',
    'Movable Type User Manual' => 'Manual del usuario de Movable Type',
    'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.com/movabletype/support', # Translate - Previous (6)
    'Movable Type Technical Support' => 'Soporte técnico de Movable Type',
    'Movable Type Community Forums' => 'Foros comunitarios de Movable Type',
    'Change this message.' => 'Cambiar este mensaje.',
    'Edit this message.' => 'Editar este mensaje.',
    'Here is an overview of [_1].' => 'Aquí hay un resumen de [_1].',
    'List Entries' => 'Listar entradas',
    'Recent Entries' => 'Entradas recientes',
    'List Comments' => 'Listar comentarios',
    'Pending' => 'Pendiente',
    'List TrackBacks' => 'Listar TrackBacks',
    'Recent TrackBacks' => 'TrackBacks recientes',

    ## ./tmpl/cms/list_commenters.tmpl
    'Authenticated Commenters' => 'Comentaristas autentificados',
    'The selected commenter(s) has been given trusted status.' => 'Los comentaristas seleccionados tienen ya el estado de confianza.',
    'Trusted status has been removed from the selected commenter(s).' => 'Se eliminó el estado de confianza de los comentaristas seleccionados.',
    'The selected commenter(s) have been blocked from commenting.' => 'Se bloquearon los comentaristas seleccionados.',
    'The selected commenter(s) have been unbanned.' => 'Se desbloquearon los comentaristas seleccionados.',
    'Reset' => 'Reiniciar',
    'Filter' => 'Filtro',
    'None.' => 'Ninguno.',
    '(Showing all commenters.)' => '(Mostrar todos los comentaristas.)',
    'Showing only commenters whose [_1] is [_2].' => 'Mostrar solo los comentaristas cuyo [_1] sea [_2].',
    'Commenter Feed' => 'Fuente de comentaristas',
    'Show' => 'Mostrar',
    'all' => 'todos',
    'only' => 'solamente',
    'commenters.' => 'comentaristas.',
    'commenters where' => 'comentaristas donde',
    'status' => 'estado',
    'commenter' => 'comentarista',
    'is' => 'es',
    'trusted' => 'confiado',
    'untrusted' => 'no confiado',
    'banned' => 'bloqueado',
    'unauthenticated' => 'no autentificado',
    'authenticated' => 'autentificado',
    '.' => '.', # Translate - Previous (0)
    'No commenters could be found.' => 'No se encontraron comentaristas.',

    ## ./tmpl/cms/list_comment.tmpl
    'System-wide' => 'Toda la instalación',
    'The selected comment(s) has been published.' => 'Se publicaron los comentarios seleccionados.',
    'All junked comments have been removed.' => 'Se han borrado todos los comentarios basura.',
    'The selected comment(s) has been unpublished.' => 'Se despublicaron los comentarios seleccionados.',
    'The selected comment(s) has been junked.' => 'Se marcaron como basura los comentarios seleccionados.',
    'The selected comment(s) has been unjunked.' => 'Se desmarcaron como basura los comentarios seleccionados.',
    'The selected comment(s) has been deleted from the database.' => 'Los comentarios seleccionados fueron eliminados de la base de datos.',
    'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be Banned or Trusted.' => 'Uno o más comentarios de los que seleccionó fueron enviados por un comentarista no autentificado. No se puede bloquear o dar confianza a estos comentaristas.',
    'No comments appeared to be junk.' => 'No hay comentarios que parezcan basura.',
    'Junk Comments' => 'Comentarios basura',
    'Comment Feed' => 'Fuente de comentarios',
    'Comment Feed (Disabled)' => 'Fuente de comentarios (deshabilitado)',
    'Disabled' => 'Desactivado',
    'Set Web Services Password' => 'Establecer contraseña de servicios web',
    'Quickfilter:' => 'Filtro rápido:',
    'Show unpublished comments.' => 'Mostrar comentarios no publicados.',
    '(Showing all comments.)' => '(Mostrar todos los comentarios).',
    'Showing only comments where [_1] is [_2].' => 'Mostrar solo los comentarios donde [_1] es [_2].',
    'comments.' => 'comentarios.',
    'comments where' => 'comentarios donde',
    'published' => 'publicado',
    'unpublished' => 'no publicado',
    'No comments could be found.' => 'No se encontró ningún comentario.',
    'No junk comments could be found.' => 'No se encontró ningún comentario basura.',

    ## ./tmpl/cms/show_upload_html.tmpl
    'Copy and paste this HTML into your entry.' => 'Copiar y pegar el siguiente código HTML en su entrada.',
    'Close' => 'Cerrar',
    'Upload Another' => 'Transferir otra',

    ## ./tmpl/cms/list_plugin.tmpl
    'Are you sure you want to reset the settings for this plugin?' => '¿Está seguro de que desea reiniciar la configuración de esta extensión?',
    'Disable plugin system?' => '¿Desactivar sistema de extensiones?',
    'Disable this plugin?' => '¿Desactivar esta extensión?',
    'Enable plugin system?' => '¿Activar sistema de extensiones?',
    'Enable this plugin?' => '¿Activar esta extensión?',
    'Plugin Settings' => 'Configuración de extensiones',
    'This screen allows you to control the weblog-level settings of any configurable plugins you\'ve installed.' => 'Esta ventana le permite controlar la configuración a nivel de weblog de las extensiones configurables que haya instalado.',
    'Your plugin settings have been saved.' => 'Se guardó la configuración de la extensión.',
    'Your plugin settings have been reset.' => 'Se reinició la configuración de la extensión.',
    'Your plugins have been reconfigured.' => 'Se reconfiguraron las extensiones.',
    'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => 'Sus extensiones se reconfiguraron. Debido a que está ejecutando mod_perl, debería reiniciar su servidor web para que estos cambios tengan efecto.',
    'Settings' => 'Configuración',
    'Plugins' => 'Extensiones',
    'Switch to Detailed Settings' => 'Cambiar a configuración detallada',
    'General' => 'General', # Translate - Previous (1)
    'New Entry Defaults' => 'Valores por defecto de las nuevas entradas',
    'Feedback' => 'Respuestas',
    'Publishing' => 'Publicación',
    'IP Banning' => 'Bloqueo de IPs',
    'Switch to Basic Settings' => 'Cambiar a configuración básica',
    'Registered Plugins' => 'Extensiones registrados',
    'Disable Plugins' => 'Desactivar extensiones',
    'Enable Plugins' => 'Activar extensiones',
    'Error' => 'Error', # Translate - Previous (1)
    'Failed to Load' => 'Falló al cargar',
    'Disable' => 'Desactivar',
    'Enabled' => 'Activado',
    'Enable' => 'Activar',
    'Documentation for [_1]' => 'Documentación sobre [_1]',
    'Documentation' => 'Documentación',
    'Author of [_1]' => 'Autor de [_1]',
    'Author' => 'Autor',
    'More about [_1]' => 'Más sobre [_1]',
    'Support' => 'soporte',
    'Plugin Home' => 'Web de Extensiones',
    'Resources' => 'Recursos',
    'Show Resources' => 'Mostrar recursos',
    'Run' => 'Ejecutar',
    'Run [_1]' => 'Ejecutar [_1]',
    'Show Settings' => 'Mostrar preferencias',
    'Settings for [_1]' => 'Configuración de [_1]',
    'Version' => 'Versión',
    'Resources Provided by [_1]' => 'Recursos provistos por [_1]',
    'Tag Attributes' => 'Atributos de etiquetas',
    'Text Filters' => 'Filtros de texto',
    'Junk Filters' => 'Filtros de basura',
    '[_1] Settings' => 'Preferencias de [_1]',
    'Reset to Defaults' => 'Reiniciar con los valores predefinidos',
    'Plugin error:' => 'Error de la extensión:',
    'No plugins with weblog-level configuration settings are installed.' => 'No hay extensiones instaladas con configuración a nivel del sistema.',

    ## ./tmpl/cms/import.tmpl
    'Import / Export' => 'Importar / Exportar',
    'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Transfiere las entradas de un weblog en Movable Type desde otras instalaciones de Movable Type o incluso otras herramientas de blogs, o exporta sus entradas para crear una copia de seguridad.',
    'Import Entries' => 'Importar entradas',
    'Export Entries' => 'Exportar entradas',
    'Authorship of imported entries:' => 'Autoría de las entradas importadas:',
    'Import as me' => 'Importar como yo mismo',
    'Preserve original author' => 'Preservar autor original',
    'If you choose to preserve the authorship of the imported entries and any of those authors must be created in this installation, you must define a default password for those new accounts.' => 'Si selecciona preservar la autoría de las entradas importadas y se debe crear alguno de estos autores durante en esta instalación, debe establecer una contraseña predefinida para estas nuevas cuentas.',
    'Default password for new authors:' => 'Contraseña predefinida para los nuevos autores:',
    'Upload import file: (optional)' => 'Transferir fichero a importar: (opcional)',
    'You will be assigned the author of all imported entries.  If you wish the original authors to keep ownership, you must contact your MT system administrator to perform the import so that new authors can be created if necessary.' => 'Se le registrará como autor de todas las entradas importadas. Si desea respetar la autoría original de las entradas, debe contactar con el administrador de MT para realizar la importación, y así crear los nuevos autores si fuera necesario.',
    'Import File Encoding (optional):' => 'Codificación del fichero a importar (opcional):',
    'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'Por defecto, Movable Type intentará detectar automáticamente la codificación del fichero a importar. Sin embargo, si experimenta dificultados, puede especificarlo explícitamente.',
    'Default category for entries (optional):' => 'Categoría predeterminada para las entradas (opcional):',
    'Select a category' => 'Seleccione una categoría',
    'You can specify a default category for imported entries which have none assigned.' => 'Puede especificar una categoría predefinida para las entradas importadas que no tengan ninguna asignada.',
    'Importing from another system?' => '¿Importación desde otro sistema?',
    'Start title HTML (optional):' => 'Código HTML de comienzo de título (opcional):',
    'End title HTML (optional):' => 'Código HTML de final de título (opcional):',
    'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => 'Si el software desde el que va a importar no tiene un campo de título, puede usar esta opción para identificar un título dentro del cuerpo de la entrada.',
    'Default post status for entries (optional):' => 'Estado de publicación predeterminado para las entradas (opcional):',
    'Select a post status' => 'Seleccione un estado de publicación',
    'If the software you are importing from does not specify a post status in its export file, you can set this as the status to use when importing entries.' => 'Si el software desde el que va a importar no especifica un estado para la entrada en su fichero de exportación, puede establecer el estado a usar al importar las entradas.',
    'Import Entries (i)' => 'Importar entradas (i)',
    'Export Entries From [_1]' => 'Exportar entradas desde [_1]',
    'Export Entries (e)' => 'Exportar entradas (e)',
    'Export Entries to Tangent' => 'Exportar entradas a Tangent',

    ## ./tmpl/cms/commenter_actions.tmpl
    'Trust' => 'Confianza',
    'commenters' => 'comentaristas',
    'to act upon' => 'actuar cuando',
    'Trust commenter' => 'Confiar en comentarista',
    'Untrust' => 'Desconfiar',
    'Untrust commenter' => 'Desconfiar de comentarista',
    'Ban' => 'Bloquear',
    'Ban commenter' => 'Bloquear comentarista',
    'Unban' => 'Desbloquear',
    'Unban commenter' => 'Desbloquear comentarista',
    'Trust selected commenters' => 'Confiar en comentaristas seleccionados',
    'Ban selected commenters' => 'Bloquear comentaristas seleccionados',

    ## ./tmpl/cms/cfg_prefs.tmpl
    'You must set your Weblog Name.' => 'Debe definir el nombre del weblog.',
    'You did not select a timezone.' => 'No seleccionó ninguna zona horaria.',
    'General Settings' => 'Configuración general',
    'This screen allows you to control general weblog settings, default weblog display settings, and third-party service settings.' => 'Esta pantalla le permite modificar las configuración general del weblog y de servicios externos.',
    'Your blog preferences have been saved.' => 'Las preferencias de su weblog han sido guardadas.',
    'Weblog Settings' => 'Configuración del weblog',
    'Weblog Name' => 'Nombre del weblog',
    'Name your weblog. The weblog name can be changed at any time.' => 'Asigne un nombre a su weblog. El nombre del weblog se puede cambiar en cualquier momento.',
    'Description' => 'Descripción',
    'Enter a description for your weblog.' => 'Teclee la descripción de su weblog.',
    'Timezone:' => 'Zona horaria:',
    'Time zone not selected' => 'No hay ninguna zona horaria seleccionada.',
    'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (Nueva Zelanda, horario de verano)',
    'UTC+12 (International Date Line East)' => 'UTC+12 (Línea internacional de cambio de fecha, Este)',
    'UTC+11' => 'UTC+11', # Translate - Previous (2)
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
    'Select your timezone from the pulldown menu.' => 'Seleccione su zona horaria en el menú desplegable.',
    'Default Weblog Display Settings' => 'Preferencias',
    'Entries to Display:' => 'Entradas a mostrar:',
    'Days' => 'Días',
    'Select the number of days\' entries or the exact number of entries you would like displayed on your weblog.' => 'Seleccione el número de días o el número exacto de entradas que desea que mostrar en su weblog.',
    'Entry Order:' => 'Orden de entradas:',
    'Ascending' => 'Ascendente',
    'Descending' => 'Descendente',
    'Select whether you want your posts displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Seleccione si desea que sus contribuciones se muestren en orden ascendente (la más antigua primero) o descendente (la más reciente primero).',
    'Comment Order:' => 'Orden de comentarios:',
    'Select whether you want visitor comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Seleccione si desea que los comentarios de visitantes se muestren en orden ascendente (el más antiguo arriba) o descendente (el más reciente arriba).',
    'Excerpt Length:' => 'Tamaño del resumen:',
    'Enter the number of words that should appear in an auto-generated excerpt.' => 'Teclee el número de palabras que desea mostrar en el resumen autogenerado.',
    'Date Language:' => 'Idioma de la fecha:',
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
    'Suomi' => 'Suomi', # Translate - Previous (1)
    'Swedish' => 'Sueco',
    'Select the language in which you would like dates on your blog displayed.' => 'Seleccione el idioma en el que desea que se visualicen las fechas en su weblog.',
    'Limit HTML Tags:' => 'Limitar etiquetas HTML:',
    'Use defaults' => 'Utilizar valores predeterminados',
    '([_1])' => '([_1])', # Translate - Previous (2)
    'Use my settings' => 'Utilizar mis preferencias',
    'Specifies the list of HTML tags allowed by default when cleaning an HTML string (a comment, for example).' => 'Especifica la lista etiquetas HTML que se permiten por defecto en la limpieza de una cadena HTML (un comentario, por ejemplo).',
    'License' => 'Licencia',
    'Your weblog is currently licensed under:' => 'En la actualidad, su weblog está sujeto a la licencia:',
    'Change your license' => 'Cambiar su licencia',
    'Remove this license' => 'Eliminar esta licencia',
    'Your weblog does not have an explicit Creative Commons license.' => 'Su weblog no dispone de una licencia  explícita de Creative Commons.',
    'Create a license now' => 'Crear una licencia ahora',
    'Select a Creative Commons license for the posts on your blog (optional).' => 'Seleccione una licencia de Creative Commons para las contribuciones de su weblog (opcional).',
    'Be sure that you understand these licenses before applying them to your own work.' => 'Asegúrese de comprender el contenido de estas licencias antes de que las aplica a sus trabajos.',
    'Read more.' => 'Más información.',

    ## ./tmpl/cms/tag_table.tmpl
    'Date' => 'Fecha',
    'IP Address' => 'Dirección IP',
    'Log Message' => 'Mensaje del registro',

    ## ./tmpl/cms/cfg_entries_edit_page.tmpl
    'Default Entry Editor Display Options' => 'Opciones predefinidas del editor de entradas',

    ## ./tmpl/cms/upload_complete.tmpl
    'Upload File' => 'Transferir fichero',
    'The file named \'[_1]\' has been uploaded. Size: [quant,_2,byte].' => 'El fichero \'[_1]\' ha sido transferido. Tamaño: [quant,_2,byte].',
    'Create a new entry using this uploaded file' => 'Crear una nueva entrada utilizando este fichero transferido',
    'Show me the HTML' => 'Ver código HTML',
    'Image Thumbnail' => 'Miniatura de la imagen',
    'Create a thumbnail for this image' => 'Crear una miniatura de esta imagen',
    'Width:' => 'Anchura:',
    'Pixels' => 'Píxeles',
    'Percent' => 'Porcentaje',
    'Height:' => 'Altura:',
    'Constrain proportions' => 'Delimitar las proporciones',
    'Would you like this file to be a:' => 'Elija si este fichero debe ser:',
    'Popup Image' => 'Una imagen emergente',
    'Embedded Image' => 'Una imagen incrustada',
    'Link' => 'Un vínculo',

    ## ./tmpl/cms/bm_posted.tmpl
    'Your new entry has been saved to [_1]' => 'Su nueva entrada se guardó en [_1]',
    ', and it has been posted to your site' => ' e insertado en su sitio.',
    '. ' => '. ', # Translate - Previous (0)
    'View your site' => 'Ver su sitio',
    'Edit this entry' => 'Editar esta entrada',

    ## ./tmpl/cms/delete_confirm.tmpl
    'Are you sure you want to permanently delete the [quant,_1,author] from the system?' => '¿Realmente desea eliminar del sistema [quant,_1,autor] de forma permanente?',
    'Are you sure you want to delete the [quant,_1,comment]?' => '¿Realmente desea eliminar [quant,_1,comentario]?',
    'Are you sure you want to delete the [quant,_1,TrackBack]?' => '¿Realmente desea eliminar el [quant,_1,TrackBack]?',
    'Are you sure you want to delete the [quant,_1,entry,entries]?' => '¿Realmente desea eliminar [quant,_1,entrada,entradas]?',
    'Are you sure you want to delete the [quant,_1,template]?' => '¿Realmente desea eliminar [quant,_1,plantilla]?',
    'Are you sure you want to delete the [quant,_1,category,categories]? When you delete a category, all entries assigned to that category will be unassigned from that category.' => '¿Realmente desea eliminar [quant,_1,categoría,categorías]? Al eliminar una categoría, todas las entradas asignadas a esa categoría quedarán desasignadas.',
    'Are you sure you want to delete the [quant,_1,template] from the particular archive type(s)?' => '¿Realmente desea eliminar [quant,_1,plantilla] de esos tipos concretos de archivos?',
    'Are you sure you want to delete the [quant,_1,IP address,IP addresses] from your Banned IP List?' => '¿Realmente desea eliminar [quant,_1,dirección IP,direcciones IP] de su lista de bloqueos?',
    'Are you sure you want to delete the [quant,_1,notification address,notification addresses]?' => '¿Realmente desea eliminar [quant,_1,dirección de notificación,direcciones de notificación]?',
    'Are you sure you want to delete the [quant,_1,blocked item,blocked items]?' => '¿Realmente desea borrar [quant,_1,el elemento bloqueado,los elementos bloqueados]?',
    'Are you sure you want to delete the [quant,_1,weblog]? When you delete a weblog, all of the entries, comments, templates, notifications, and author permissions are deleted along with the weblog itself. Make sure that this is what you want, because this action is permanent.' => '¿Realmente desea eliminar [quant,_1,weblog]? Cuando se elimina un weblog, todas sus entradas, comentarios, plantillas, notificaciones y permisos de autor también se eliminan. Asegúrese de que realmente desea hacerlo, porque esta acción es irreversible.',
    'Delete' => 'Eliminar',

    ## ./tmpl/cms/cfg_system_feedback.tmpl
    'This screen allows you to configure feedback and outbound TrackBack settings for the entire installation.  These settings override any similar settings for individual weblogs.' => 'Esta pantalla le permite configurar las preferencias de las respuestas y TrackBacks salientes de toda la instalación. Estas preferencias tienen prioridad sobre otras similares en los weblogs individuales.',
    'Your feedback preferences have been saved.' => 'Se guardaron las preferencias de las respuestas.',
    'Feedback Master Switch' => 'Preferencias maestras de las respuestas',
    'Disable Comments' => 'Desactivar comentarios',
    'Stop accepting comments on all weblogs' => 'Desactivar los comentarios en todos los weblogs',
    'This will override all individual weblog comment settings.' => 'Esta configuración tiene prioridad sobre la de los weblogs individuales.',
    'Disable TrackBacks' => 'Desactivar TrackBacks',
    'Stop accepting TrackBacks on all weblogs' => 'Desactivar la recepción de TrackBacks en todos los weblogs',
    'This will override all individual weblog TrackBack settings.' => 'Esta configuración tiene prioridad sobre la de los weblogs individuales.',
    'Outbound TrackBack Control' => 'Control de TrackBacks salientes',
    'Allow outbound TrackBacks to:' => 'Permitir TrackBacks salientes a:',
    'Any site' => 'Cualquier sitio',
    'No site' => 'Ningún sitio',
    '(Disable all outbound TrackBacks.)' => '(Desactivar todos los TrackBacks salientes).',
    'Only the weblogs on this installation' => 'Solo los weblogs de esta instalación',
    'Only the sites on the following domains:' => 'Solo los sitios de los siguientes dominios:',
    'This feature allows you to limit outbound TrackBacks and TrackBack auto-discovery for the purposes of keeping your installation private.' => 'Esta función le permite limitar los TrackBacks salientes y el autodescubrimiento de TrackBack para poder mantener la privacidad de la instalación.',

    ## ./tmpl/cms/cfg_entries.tmpl
    'New Entry Default Settings' => 'Configuración por defecto de nuevas entradas',
    'This screen allows you to control default settings for new entries as well as your publicity and remote interface settings.' => 'Esta pantalla le permite controlar las opciones por defecto de las nuevas entradas, así como la configuración de la publicidad y el interfaz remoto.',
    'Default Settings for New Entries' => 'Configuración por defecto de nuevas entradas',
    'Post Status' => 'Estado de la publicación',
    'Specifies the default Post Status when creating a new entry.' => 'Especifica el estado de publicación predeterminado para las nuevas entradas.',
    'Specifies the default Text Formatting option when creating a new entry.' => 'Especifica el formato de texto predeterminado para las entradas nuevas.',
    'Specifies the default Accept Comments setting when creating a new entry.' => 'Indica el valor predefinido para la opción Aceptar comentarios al crear nuevas entradas.',
    'Setting Ignored' => 'Opción ignorada',
    'Note: This option is currently ignored since comments are disabled either weblog or system-wide.' => 'Nota: Esta opción se ignora actualmente, ya que los comentarios están desactivados o en el weblog o en todo el sistema.',
    'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Indica el valor predefinido de la opción Aceptar TrackBacks al crear nuevas entradas.',
    'Note: This option is currently ignored since TrackBacks are disabled either weblog or system-wide.' => 'Nota: Esta opción se ignora actualmente, ya que los comentarios están desactivados o en el weblog o en todo el sistema',
    'Basename Length:' => 'Longitud del nombre base:',
    'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => 'Especifique la longitud predefinida de los nombres base autogenerados. El rango para esta opción es de entre 15 y 250.',
    'Publicity/Remote Interfaces' => 'Publicidad/Interfaces remotos',
    'Notify the following sites upon weblog updates:' => 'Notificar a los siguientes sitios al actualizar el weblog:',
    'Others:' => 'Otros:',
    '(Separate URLs with a carriage return.)' => '(Separe las URLs con un retorno de carro.)',
    'When this weblog is updated, Movable Type will automatically notify the selected sites.' => 'Cuando este weblog se actualice, Movable Type notificará automáticamente los sitios seleccionados.',
    'Setting Notice' => 'Alerta sobre configuración',
    'Note: The above option may be affected since outbound pings are constrained system-wide.' => 'Nota: La opción de arriba podría verse afectada debido a que los pings salientes están restringidos a nivel del sistema.',
    'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Nota: Esta opción se ignora actualmente debido a que los pings salientes están desactivados a nivel del sistema.',
    'Recently Updated Key:' => 'Clave de Actualizaciones recientes:',
    'If you have received a recently updated key (by virtue of your purchase), enter it here.' => 'Si recientemente ha recibido una clave actualizada (tras una compra), tecléela aquí.',
    'TrackBack Auto-Discovery' => 'Autodescubrimiento de TrackBacks',
    'Enable External TrackBack Auto-Discovery' => 'Habilitar autodescubrimiento de TrackBacks externos',
    'Note: The above option is currently ignored since outbound pings are disabled system-wide.' => 'Nota: La configuración de arriba se ignora actualmente debido a que los pings salientes están desactivados a nivel del sistema.',
    'Enable Internal TrackBack Auto-Discovery' => 'Habilitar autodescubrimiento de TrackBacks internos',
    'If you turn on auto-discovery, when you write a new post, any external links will be extracted and the appropriate sites automatically sent TrackBacks.' => 'Si activa el autodescubrimiento, al escribir una nueva entrada, se extraerán los enlaces externos y se enviará TrackBacks de forma automática a aquellos que lo aceptan.',

    ## ./tmpl/cms/template_actions.tmpl
    'template' => 'plantilla',
    'templates' => 'plantillas',

    ## ./tmpl/cms/recover.tmpl
    'Your password has been changed, and the new password has been sent to your email address ([_1]).' => 'Se cambió su contraseña y la nueva se le ha enviado a su dirección de correo electrónico ([_1]).',
    'Enter your Movable Type username:' => 'Introduzca su nombre de usuario de Movable Type:',
    'Enter your password recovery word/phrase:' => 'Introduzca la palabra/frase de recuperación de contraseña:',
    'Recover' => 'Recuperar',

    ## ./tmpl/cms/list_entry.tmpl
    'Your entry has been deleted from the database.' => 'Se eliminó su entrada de la base de datos.',
    'Entry Feed' => 'Fuente de entradas',
    'Entry Feed (Disabled)' => 'Fuente de entradas (deshabilitado)',
    'Show unpublished entries.' => 'Mostrar entradas no publicadas.',
    '(Showing all entries.)' => '(Mostrar todas las entradas).',
    'Showing only entries where [_1] is [_2].' => 'Mostrando solo las entradas donde [_1] es [_2].',
    'entries.' => 'entradas.',
    'entries where' => 'entradas donde',
    'author' => 'autor',
    'tag (exact match)' => 'etiqueta (coincidencia exacta)',
    'tag (fuzzy match)' => 'etiqueta (coincidencia difusa)',
    'category' => 'categoría',
    'scheduled' => 'programado',
    'No entries could be found.' => 'No se encontraron entradas.',

    ## ./tmpl/cms/list_template.tmpl
    'Index Templates' => 'Plantillas índice',
    'Index templates produce single pages and can be used to publish Movable Type data or plain files with any type of content. These templates are typically rebuilt automatically upon saving entries, comments and TrackBacks.' => 'Las plantillas índices producen páginas individuales y se utilizan para publicar datos de Movable Type o ficheros planos con cualquier tipo de contenido. Estas plantillas se reconstruyen automáticamente al guardar entradas, comentarios y TrackBacks.',
    'Archive Templates' => 'Plantillas de archivos',
    'Archive templates are used for producing multiple pages of the same archive type.  You can create new ones and map them to archive types on the publishing settings screen for this weblog.' => 'Las plantillas de archivos se utilizan para producir múltiples páginas del mismo tipo de archivo. Puede crear nuevas y relacionarlas con tipos de archivos en la pantalla de preferencias de publicación de este weblog.',
    'System Templates' => 'Plantillas del sistema',
    'System templates specify the layout and style of a small number of dynamic pages which perform specific system functions in Movable Type.' => 'Las plantillas del sistema especifica el diseño y estilo de un pequeño número de páginas dinámicas que realizan funciones específicas del sistema en Movable Type.',
    'Template Modules' => 'Módulos de plantillas',
    'Template modules are mini-templates that produce nothing on their own but instead can be included into other templates.  They are excellent for duplicated content (e.g. header or footer content) and can contain template tags or just static text.' => 'Los módulos de plantillas son mini-plantillas que no generan nada por sí mismas, sino que se incluyen en otras plantillas. Son ideales para contenido duplicado (p.e. cabeceras y pies de páginas) y pueden contener etiquetas de plantillas o solo texto estático.',
    'You have successfully deleted the checked template(s).' => 'Se eliminaron correctamente las plantillas marcadas.',
    'Your settings have been saved.' => 'Configuración guardada.',
    'Indexes' => 'Índices',
    'System' => 'Sistema',
    'Modules' => 'Módulos',
    'Go to Publishing Settings' => 'Ir a preferencias de publicación',
    'Create new index template' => 'Crear plantilla índice',
    'Create New Index Template' => 'Crear plantilla índice',
    'Create new archive template' => 'Crear plantilla de archivos',
    'Create New Archive Template' => 'Crear plantilla de archivos',
    'Create new template module' => 'Crear módulo de plantilla',
    'Create New Template Module' => 'Crear módulo de plantilla',
    'Template Name' => 'Nombre de la plantilla',
    'Output File' => 'Fichero de salida',
    'Dynamic' => 'Dinámico',
    'Linked' => 'Enlazado',
    'Built w/Indexes' => 'Generar con índices',
    'Yes' => 'Sí',
    'No' => 'No', # Translate - Previous (1)
    'View Published Template' => 'Ver plantilla publicada',
    'No index templates could be found.' => 'No se encontró ninguna plantilla índice.',
    'No archive templates could be found.' => 'No se encontró ninguna plantilla de archivos.',
    'No template modules could be found.' => 'No se encontró ninguna plantilla de módulos.',

    ## ./tmpl/cms/list_tags.tmpl
    'Your tag changes and additions have been made.' => 'Se han realizado los cambios y añadidos a las etiquetas especificados.',
    'You have successfully deleted the selected tags.' => 'Se borraron con éxito las etiquetas especificadas.',
    'Tag Name' => 'Nombre de la etiqueta',
    'Click to edit tag name' => 'Haga clic para editar el nombre de la etiqueta',
    'Rename' => 'Renombrar',
    'Show all entries with this tag' => 'Mostrar todas las entradas con esta etiqueta',
    '[quant,_1,entry,entries]' => '[quant,_1,entrada,entradas]',
    'No tags could be found.' => 'No se encontraron etiquetas.',

    ## ./tmpl/cms/error.tmpl
    'An error occurred:' => 'Ocurrió un error:',

    ## ./tmpl/cms/edit_author.tmpl
    'Your Web services password is currently' => 'La contraseña de los servicios web es actualmente',
    'Author Profile' => 'Perfil del autor',
    'Create New Author' => 'Crear nuevo autor',
    'Profile' => 'Perfil',
    'Permissions' => 'Permisos',
    'Your profile has been updated.' => 'Se actualizó su perfil.',
    'Weblog Associations' => 'Weblogs asociados',
    'General Permissions' => 'Permisos generales',
    'System Administrator' => 'Administrador del sistema',
    'Create Weblogs' => 'Crear weblogs',
    'View Activity Log' => 'Ver registro de actividad',
    'Username' => 'Nombre de usuario',
    'The name used by this author to login.' => 'El nombre utilizado por este autor para iniciar su sesión.',
    'Display Name' => 'Nombre público',
    'The author\'s published name.' => 'El nombre público del autor.',
    'The author\'s email address.' => 'La dirección de correo electrónico del autor.',
    'Website URL:' => 'URL del sitio:',
    'The URL of this author\'s website. (Optional)' => 'La URL del sitio de este autor. (Opcional)',
    'Language:' => 'Idioma:',
    'The author\'s preferred language.' => 'El idioma preferido del autor.',
    'Tag Delimiter:' => 'Separador de etiquetas:',
    'Comma' => 'Coma',
    'Space' => 'Espacio',
    'Other...' => 'Otro...',
    'The author\'s preferred delimiter for entering tags.' => 'El separador preferido por el autor al introducir etiquetas.',
    'Password' => 'Contraseña',
    'Current Password:' => 'Contraseña actual:',
    'Enter the existing password to change it.' => 'Teclee la contraseña actual para cambiarla.',
    'New Password:' => 'Nueva contraseña:',
    'Initial Password' => 'Contraseña inicial',
    'Select a password for the author.' => 'Seleccione una contraseña para este autor.',
    'Password Confirm:' => 'Confirmar contraseña:',
    'Repeat the password for confirmation.' => 'Repita la contraseña para confirmación.',
    'Password recovery word/phrase' => 'Palabra/frase para la recuperación de contraseña',
    'This word or phrase will be required to recover your password if you forget it.' => 'Esta palabra o frase será necesaria para recuperar su contraseña en caso de olvido.',
    'Web Services Password:' => 'Contraseña de servicios web:',
    'Reveal' => 'Mostrar',
    'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'Utilizada por las fuentes de sindicación de actividad y los clientes XML-RPC y Atom.',
    'Save this author (s)' => 'Guardar este/os autor/es',

    ## ./tmpl/cms/notification_table.tmpl
    'Date Added' => 'Fecha de creación',

    ## ./tmpl/cms/overview-left-nav.tmpl
    'List Weblogs' => 'Listar weblogs',
    'List Authors' => 'Listar autores',
    'Authors' => 'Autores',
    'List Plugins' => 'Listar extensiones',
    'Aggregate' => 'Listar',
    'List Tags' => 'Listar etiquetas',
    'Configure' => 'Configurar',
    'Edit System Settings' => 'Editar configuración del sistema',
    'Utilities' => 'Herramientas',
    'Search &amp; Replace' => 'Buscar &amp; Reemplazar',
    'Show Activity Log' => 'Mostrar histórico de actividad',
    'Activity Log' => 'Registro de actividad',

    ## ./tmpl/cms/copyright.tmpl

    ## ./tmpl/cms/view_log.tmpl
    'Are you sure you want to reset activity log?' => '¿Está seguro que desea reiniciar el registro de actividad?',
    'The Movable Type activity log contains a record of notable actions in the system.' => 'El registro de actividad de Movable Type contiene un registro de las acciones más relevantes del sistema.',
    'All times are displayed in GMT[_1].' => 'Todas las horas se muestran en GMT[_1].',
    'All times are displayed in GMT.' => 'Todas las fechas se muestran en GMT.',
    'The activity log has been reset.' => 'Se reinició el registro de actividad.',
    'Download CSV' => 'Descargar CSV',
    'Show only errors.' => 'Mostrar solo los errores.',
    '(Showing all log records.)' => '(Mostrando todos los registros de actividad.)',
    'Showing only log records where' => 'Mostrar solo los registros de actividad donde',
    'Filtered CSV' => 'CSV filtrado',
    'Filtered' => 'Filtrado',
    'Activity Feed' => 'Fuente de actividad',
    'log records.' => 'registros de actividad.',
    'log records where' => 'registros de actividad done',
    'level' => 'nivel',
    'classification' => 'clasificación',
    'Security' => 'Seguridad',
    'Information' => 'Información',
    'Debug' => 'Depuración',
    'Security or error' => 'Seguridad o error',
    'Security/error/warning' => 'Seguridad/error/alarma',
    'Not debug' => 'No depuración',
    'Debug/error' => 'Depuración/error',
    'No log records could be found.' => 'No se encontraron registros de actividad.',

    ## ./tmpl/cms/tag_actions.tmpl
    'tag' => 'etiqueta',
    'tags' => 'etiquetas',
    'Delete selected tags (x)' => 'Borrar etiquetas seleccionadas (x)',

    ## ./tmpl/cms/rebuilding.tmpl
    'Rebuild' => 'Reconstruir',
    'Rebuilding [_1]' => 'Reconstruyendo [_1]',
    'Rebuilding [_1] pages [_2]' => 'Reconstruyendo páginas: [_1] [_2]',
    'Rebuilding [_1] dynamic links' => 'Reconstruyendo [_1] enlaces dinámicos',
    'Rebuilding [_1] pages' => 'Reconstruyendo páginas: [_1]',

    ## ./tmpl/cms/upload_confirm.tmpl
    'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'El fichero llamado \'[_1]\' ya existe. ¿Desea sobreescribirlo?',

    ## ./tmpl/cms/handshake_return.tmpl

    ## ./tmpl/cms/junk_results.tmpl
    'Find Junk' => 'Buscar en basura',
    'The following items may be junk. Uncheck the box next to any items are NOT junk and hit JUNK to continue.' => 'Los siguientes elementos podrían ser basura. Desmarque la casilla junto a cualquier elemento que NO sea basura y presione BASURA para continuar.',
    'To return to the comment list without junking any items, click CANCEL.' => 'Para regresar a la lista de comentarios sin marcar como basura ningún elemento, haga clic en CANCELAR.',
    'Commenter' => 'Comentarista',
    'Comment' => 'Comentario',
    'IP' => 'IP', # Translate - Previous (1)
    'Junk' => 'Basura',
    'Approved' => 'Autorizado',
    'Banned' => 'Bloqueado',
    'Registered Commenter' => 'Comentarista registrado',
    'comment' => 'comentario',
    'comments' => 'comentarios',
    'Return to comment list' => 'Regresar a la lista de comentarios',

    ## ./tmpl/cms/import_end.tmpl
    'All data imported successfully!' => '¡Importados con éxito todos los datos!',
    'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Asegúrese de borrar los ficheros importados del directorio \'import\', para evitar procesarlos de nuevo al ejecutar en otra ocasión el proceso de importación.',
    'An error occurred during the import process: [_1]. Please check your import file.' => 'Ocurrió un error durante el proceso de importación: [_1]. Por favor, compruebe su fichero de importación.',

    ## ./tmpl/cms/admin.tmpl
    'System Stats' => 'Estadísticas del sistema',
    'Active Authors' => 'Autores activos',
    'Essential Links' => 'Enlaces esenciales',
    'Movable Type Home' => 'Movable Type - Inicio',
    'Plugin Directory' => 'Directorio de extensiones',
    'Support and Documentation' => 'Soporte y documentación',
    'https://secure.sixapart.com/t/account' => 'https://secure.sixapart.com/t/account', # Translate - Previous (6)
    'Your Account' => 'Su cuenta',
    'https://secure.sixapart.com/t/help?__mode=edit' => 'https://secure.sixapart.com/t/help?__mode=edit', # Translate - Previous (8)
    'Open a Help Ticket' => 'Abrir un ticket de ayuda',
    'Paid License Required' => 'Se necesita una licencia de pago',
    'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype/', # Translate - Previous (5)
    'http://www.sixapart.com/pronet/plugins/' => 'http://www.sixapart.com/pronet/plugins/', # Translate - Previous (6)
    'https://secure.sixapart.com/t/help?__mode=kb' => 'https://secure.sixapart.com/t/help?__mode=kb', # Translate - Previous (8)
    'Knowledge Base' => 'Base de conocimiento',
    'http://www.sixapart.com/pronet/' => 'http://www.sixapart.com/pronet/', # Translate - Previous (5)
    'Professional Network' => 'Professional Network', # Translate - Previous (2)
    'From this screen, you can view information about and manage many aspects of your system across all weblogs.' => 'Desde esta pantalla, puede consultar la información sobre el sistema y administrar muchos aspectos que afectan a todos los weblogs.',
    'Movable Type News' => 'Noticias de Movable Type',

    ## ./tmpl/cms/entry_table.tmpl
    'Weblog' => 'Weblog', # Translate - Previous (1)
    'Only show unpublished entries' => 'Mostrar solo entradas no publicadas',
    'Only show published entries' => 'Mostrar solo entradas publicadas',
    'Only show scheduled entries' => 'Mostrar solo entradas pendientes de publicación',
    'None' => 'Ninguno',

    ## ./tmpl/cms/pinged_urls.tmpl
    'Here is a list of the previous TrackBacks that were successfully sent:' => 'Aquí se muestra una lista de los TrackBacks que se enviaron correctamente:',
    'Here is a list of the previous TrackBacks that failed. To retry these, include them in the Outbound TrackBack URLs list for your entry.:' => 'Aquí se muestra una lista de los TrackBacks que fallaron anteriormente. Para reintentar alguno, inclúyalos en la lista de TrackBack salientes de su entrada.:',

    ## ./tmpl/cms/edit_admin_permissions.tmpl
    'Your changes to [_1]\'s permissions have been saved.' => 'Se han guardado los permisos de [_1].',
    '[_1] has been successfully added to [_2].' => '[_1] se ha agregado correctamente a [_2].',
    'User can create weblogs' => 'El usuario puede crear weblogs',
    'User can view activity log' => 'El usuario puede ver el registro de actividad',
    'Check All' => 'Seleccionar todos',
    'Uncheck All' => 'Deseleccionar todos',
    'Unheck All' => 'Deseleccionar todos',
    'Add user to an additional weblog:' => 'Asignar usuario a otro weblog:',
    'Select a weblog' => 'Seleccionar un weblog',
    'Add' => 'Crear',
    'Save permissions for this author (s)' => 'Guardar permisos de este/os autor/es',

    ## ./tmpl/cms/log_actions.tmpl
    'Reset Activity Log' => 'Reiniciar registro de actividad',

    ## ./tmpl/cms/rebuild_confirm.tmpl
    'Select the type of rebuild you would like to perform. (Click the Cancel button if you do not want to rebuild any files.)' => 'Seleccione el tipo de reconstrucción  que desea realizar (haga clic en el botón Cancelar si no desea reconstruir ningún fichero).',
    'Rebuild All Files' => 'Reconstruir todos los ficheros',
    'Index Template: [_1]' => 'Plantilla índice: [_1]',
    'Rebuild Indexes Only' => 'Reconstruir sólo los índices',
    'Rebuild [_1] Archives Only' => 'Reconstruir sólo [_1] archivos',
    'Rebuild (r)' => 'Reconstruir (r)',

    ## ./tmpl/cms/upgrade.tmpl
    'Time to Upgrade!' => '¡Hora de actualizar!',
    'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'La versión de Perl instalada en su servidor ([_1]) es menor que la versión mínima soporta ([_2]).',
    'Do you want to proceed with the upgrade anyway?' => '¿Desea proceder en cualquier caso con la actualización?',
    'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Se ha instalado una nueva versión de Movable Type.  Debemos realizar algunas tareas para actualizar su base de datos.',
    'In addition, the following Movable Type plugins require upgrading or installation:' => 'Además, las siguientes extensiones de Movable Type necesitan actualización o instalación:',
    'The following Movable Type plugins require upgrading or installation:' => 'Las siguientes extensiones necesitan actualización o instalación:',
    'Version [_1]' => 'Versión [_1]',
    'Begin Upgrade' => 'Comenzar actualización',

    ## ./tmpl/cms/reload_opener.tmpl

    ## ./tmpl/cms/notification_actions.tmpl
    'notification address' => 'dirección de notificación',
    'notification addresses' => 'direcciones de notificación',
    'Delete selected notification addresses (x)' => 'Birrar las direcciones de notificación seleccionadas (x)',

    ## ./tmpl/cms/cc_return.tmpl

    ## ./tmpl/cms/login.tmpl
    'Your Movable Type session has ended. If you wish to log in again, you can do so below.' => 'Finalizó su sesión en Movable Type. Si desea volver a iniciar una sesión, puede hacerlo debajo.',
    'Your Movable Type session has ended. Please login again to continue this action.' => 'Finalizó su sesión en Movable. Por favor, iníciela de nuevo para continuar esta acción.',
    'Remember me?' => '¿Recordarme?',
    'Log In' => 'Iniciar sesión',
    'Forgot your password?' => '¿Olvidó su contraseña?',

    ## ./tmpl/cms/list_ping.tmpl
    'The selected TrackBack(s) has been published.' => 'Se publicaron los TrackBacks seleccionados.',
    'All junked TrackBacks have been removed.' => 'Se han borrado todos los TrackBacks basura.',
    'The selected TrackBack(s) has been unpublished.' => 'Se despublicaron los TrackBacks seleccionados.',
    'The selected TrackBack(s) has been junked.' => 'Se marcaron como basura los TrackBacks seleccionados.',
    'The selected TrackBack(s) has been unjunked.' => 'Se desmarcaron como basura los TrackBacks seleccionados.',
    'The selected TrackBack(s) has been deleted from the database.' => 'Se eliminaron de la base de datos los TrackBacks seleccionados.',
    'No TrackBacks appeared to be junk.' => 'No hay TrackBacks que parezcan basura.',
    'Junk TrackBacks' => 'TrackBacks basura',
    'Trackback Feed' => 'Fuente de Trackbacks',
    'Trackback Feed (Disabled)' => 'Fuente de TrackBacks (deshabilitado)',
    'Show unpublished TrackBacks.' => 'Mostrar TrackBacks no publicados.',
    '(Showing all TrackBacks.)' => '(Mostrando todos los TrackBacks).',
    'Showing only TrackBacks where [_1] is [_2].' => 'Mostrando solo los TrackBacks donde [_1] es [_2].',
    'TrackBacks.' => 'TrackBacks.', # Translate - Previous (1)
    'TrackBacks where' => 'TrackBacks donde',
    'No TrackBacks could be found.' => 'No se encontraron TrackBacks.',
    'No junk TrackBacks could be found.' => 'No se encontraron TrackBacks basura.',

    ## ./tmpl/cms/recover_password_result.tmpl
    'Recover Passwords' => 'Recuperar contraseñas',
    'No authors were selected to process.' => 'No se seleccionaron autores a procesar.',

    ## ./tmpl/cms/feed_link.tmpl
    'Activity Feed (Disabled)' => 'Fuente de actividad (deshabilitado)',

    ## ./tmpl/cms/ping_actions.tmpl
    'to publish' => 'para publicar',
    'Publish' => 'Publicar',
    'Publish selected TrackBacks (p)' => 'Publicar TrackBacks seleccionados (p)',
    'Delete selected TrackBacks (x)' => 'Borrar los TrackBacks seleccionados (x)',
    'Junk selected TrackBacks (j)' => 'Marcar como basura los TrackBacks seleccionados (j)',
    'Not Junk' => 'No es basura',
    'Recover selected TrackBacks (j)' => 'Recuperar TrackBacks seleccionados (j)',
    'Are you sure you want to remove all junk TrackBacks?' => '¿Está seguro de que desea borrar todos los TrackBacks basura?',
    'Empty Junk Folder' => 'Carpeta basura vacía',
    'Deletes all junk TrackBacks' => 'Borra todos los TrackBacks basura',
    'Ban This IP' => 'Bloquear esta IP',

    ## ./tmpl/cms/ping_table.tmpl
    'From' => 'Origen',
    'Target' => 'Destino',
    'Only show published TrackBacks' => 'Mostrar solo TrackBacks publicados',
    'Only show pending TrackBacks' => 'Mostrar solo TrackBacks pendientes',
    'Edit this TrackBack' => 'Editar este TrackBack',
    'Edit TrackBack' => 'Editar TrackBack',
    'Go to the source entry of this TrackBack' => 'Ir a la entrada de origen de este TrackBack',
    'View the [_1] for this TrackBack' => 'Mostrar [_1] de este TrackBack',
    'Search for all comments from this IP address' => 'Buscar todos los comentarios enviados desde esta dirección IP',

    ## ./tmpl/cms/log_table.tmpl
    'IP: [_1]' => 'IP: [_1]', # Translate - Previous (2)

    ## ./tmpl/cms/edit_profile.tmpl
    'Author Permissions' => 'Permisos',
    'A new password has been generated and sent to the email address [_1].' => 'Se ha generado y enviado a la dirección de correo electrónico [_1] una nueva contraseña.',
    'Password Recovery' => 'Recuperación de contraseña',

    ## ./tmpl/cms/edit_commenter.tmpl
    'Commenter Details' => 'Detalles del comentarista',
    'The commenter has been trusted.' => 'El comentarista ahora es de confianza.',
    'The commenter has been banned.' => 'Se bloqueó al comentarista.',
    'View all comments with this name' => 'Mostrar todos los comentarios con este nombre',
    'Identity' => 'Identidad',
    'Email' => 'Correo electrónico',
    'Withheld' => 'Retener',
    'View all comments with this email address' => 'Ver todos los comentarios de esta dirección de correo-e',
    'View all comments with this URL address' => 'Ver todos los comentarios con esta URL',
    'Trusted' => 'Confiado',
    'Blocked' => 'Bloqueado',
    'Authenticated' => 'Autentificado',
    'View all commenters with this status' => 'Mostrar todos los comentaristas con este estado',

    ## ./tmpl/cms/edit_permissions.tmpl

    ## ./tmpl/cms/author_actions.tmpl
    'authors' => 'autores',
    'Delete selected authors (x)' => 'Borrar autores seleccionados (x)',

    ## ./tmpl/cms/install.tmpl
    'Welcome to Movable Type!' => '¡Bienvenido a Movable Type!',
    'Do you want to proceed with the installation anyway?' => '¿Aún así desea proceder con la instalación?',
    'Before you can begin blogging, we need to complete your installation by initializing your database.' => 'Antes de que comience a publicar, debe completar la instalación inicializando la base de datos.',
    'You will need to select a username and password for the administrator account.' => 'Deberá seleccionar un nombre de usuario y una contraseña para la cuenta del administrador.',
    'Select a password for your account.' => 'Seleccione una contraseña para su cuenta.',
    'Password recovery word/phrase:' => 'Palabra/frase de recuperación de contraseña:',
    'Finish Install' => 'Finalizar instalación',

    ## ./tmpl/cms/comment_table.tmpl
    'Only show published comments' => 'Mostrar solo comentarios publicados',
    'Only show pending comments' => 'Mostrar solo comentarios pendientes',
    'Edit this comment' => 'Editar este comentario',
    'Edit Comment' => 'Editar comentario',
    'Edit this commenter' => 'Editar este comentarista',
    'Search for comments by this commenter' => 'Buscar comentarios de este comentarista',
    'View this entry' => 'Mostrar esta entrada',
    'Show all comments on this entry' => 'Mostrar todos los comentarios de esta entrada',

    ## ./tmpl/cms/list_banlist.tmpl
    'IP Banning Settings' => 'Bloqueo de IPs',
    'This screen allows you to ban comments and TrackBacks from specific IP addresses.' => 'Esta pantalla le permite bloquear comentarios y TrackBacks desde IPs específicas.',
    'You have banned [quant,_1,address,addresses].' => 'Bloqueó [quant,_1,la dirección,las direcciones].',
    'You have added [_1] to your list of banned IP addresses.' => 'Agregó [_1] a su lista de direcciones IP bloqueadas.',
    'You have successfully deleted the selected IP addresses from the list.' => 'Eliminó correctamente las direcciones IP seleccionadas.',
    'Ban New IP Address' => 'Bloquear nueva IP',
    'Ban IP Address' => 'Bloquear dirección IP',
    'Date Banned' => 'Fecha de bloqueo',
    'IP address' => 'Dirección IP',
    'IP addresses' => 'Direcciones IP',

    ## ./tmpl/cms/bookmarklets.tmpl
    'QuickPost' => 'QuickPost', # Translate - Previous (1)
    'Add QuickPost to Windows right-click menu' => 'Añadir QuickPost al menú contextual de Windows',
    'Configure QuickPost' => 'Configurar QuickPost',
    'Include:' => 'Incluir:',
    'TrackBack Items' => 'Elementos de TrackBack',
    'Allow Comments' => 'Permitir comentarios',
    'Allow TrackBacks' => 'Permitir TrackBacks',
    'Create' => 'Crear',

    ## ./tmpl/cms/category_add.tmpl
    'Add A Category' => 'Crear una categoría',
    'To create a new category, enter a title in the field below, select a parent category, and click the Add button.' => 'Para crear una nueva categoría, introduzca un título en el campo siguiente, seleccione una categoría superior y haga clic en el botón Crear.',
    'Category Title:' => 'Título de la categoría:',
    'Parent Category:' => 'Categoría superior:',
    'Top Level' => 'Nivel superior',
    'Save category (s)' => 'Guardar categoría (s)',

    ## ./tmpl/cms/import_start.tmpl
    'Importing...' => 'Importando...',
    'Importing entries into blog' => 'Importando entradas en el blog',
    'Importing entries as author \'[_1]\'' => 'Importando entradas como autor \'[_1]\'',
    'Creating new authors for each author found in the blog' => 'Creando nuevos autores para cada autor encontrado en el blog',

    ## ./tmpl/cms/list_notification.tmpl
    'Notifications' => 'Notificaciones',
    'Below is the notification list for this blog. When you manually send notifications on published entries, you can select from this list.' => 'Debajo está la lista de notificación de este blog. Al enviar manualmente notificaciones de entradas publicadas, puede seleccionarlas desde esta lista.',
    'You have [quant,_1,user,users,no users] in your notification list. To delete an address, check the Delete box and press the Delete button.' => 'Tiene [quant,_1,usuario,usuarios,ningún usuario] en su lista de notificaciones. Para borrar una dirección, haga clic en la casilla Borrar y presione el botón Borrar.',
    'You have added [_1] to your notification list.' => 'Ha agregado [_1] a su lista de notificaciones.',
    'You have successfully deleted the selected notifications from your notification list.' => 'Eliminó correctamente las notificaciones seleccionadas de la lista.',
    'Create New Notification' => 'Crear notificación',
    'URL (Optional):' => 'URL (opcional):',
    'Add Recipient' => 'Añadir destinatario',
    'No notifications could be found.' => 'No se encontró ninguna notificación.',

    ## ./tmpl/cms/itemset_action_widget.tmpl
    'More actions...' => 'Más acciones...',
    'No actions' => 'Ninguna acción',

    ## ./tmpl/cms/edit_blog.tmpl
    'You must set your Local Site Path.' => 'Debe definir la ruta local de su sitio.',
    'You must set your Site URL.' => 'Debe definir la URL de su sitio.',
    'Your Site URL is not valid.' => 'La URL de su sitio no es válida.',
    'You can not have spaces in your Site URL.' => 'No puede haber espacios en la URL de su sitio.',
    'You can not have spaces in your Local Site Path.' => 'No puede haber espacios en la ruta local de su sitio.',
    'Your Local Site Path is not valid.' => 'La ruta local de su sitio no es válida.',
    'New Weblog Settings' => 'Configuración del nuevo weblog',
    'From this screen you can specify the basic information needed to create a weblog.  Once you click the save button, your weblog will be created and you can continue to customize its settings and templates, or just simply start posting.' => 'Desde esta ventana puede especificar la información básica necesaria para crear un weblog. Una vez haga clic en el botón de guardar, su weblog se creará y podrá continuar para personalizar su configuración y plantilla, o simplemente comenzar a publicar.',
    'Your weblog configuration has been saved.' => 'Las configuración de su weblog ha sido guardada.',
    'Site URL:' => 'URL del sitio:',
    'Enter the URL of your public website. Do not include a filename (i.e. exclude index.html).' => 'Introduzca la URL pública de su sitio web. No incluya un nombre de archivo (es decir, excluya index.html).',
    'Example:' => 'Ejemplo:',
    'Site Root' => 'Raíz del sitio',
    'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'Introduzca la ruta donde se encontrará el fichero índice principal. Es preferible indicar una ruta absoluta (que comience por \'/\'), pero también puede utilizar una ruta relativa al directorio de Movable Type.',

    ## ./tmpl/cms/blog-left-nav.tmpl
    'Posting' => 'Publicación',
    'New Entry' => 'Nueva entrada',
    'Community' => 'Comunidad',
    'List Commenters' => 'Listar comentaristas',
    'Commenters' => 'Comentaristas',
    'Edit Notification List' => 'Editar lista de notificaciones',
    'List &amp; Edit Templates' => 'Listar y editar plantillas',
    'Edit Categories' => 'Editar categorías',
    'Edit Tags' => 'Editar etiquetas',
    'Edit Weblog Configuration' => 'Editar configuración del weblog',
    'Import &amp; Export Entries' => 'Importar &amp; Exportar entradas',
    'Rebuild Site' => 'Reconstruir sitio',

    ## ./tmpl/cms/spam_confirm.tmpl
    'These domain names were found in the selected comments. Check the box at right to block comments and trackbacks containing that URL in the future.' => 'Se encontraron estos dominios en los comentarios seleccionados. Marque las casillas de la derecha para bloquear en el futuro los comentarios y trackbacks que contienen esta URL.',
    'Block' => 'Bloquear',

    ## ./tmpl/cms/edit_category.tmpl
    'You must specify a label for the category.' => 'Debe especificar un título para la categoría.',
    'Edit Category' => 'Editar categoría',
    'Use this page to edit the attributes of the category [_1]. You can set a description for your category to be used in your public pages, as well as configuring the TrackBack options for this category.' => 'Utilice esta página para editar los atributos de la categoría [_1]. Puede configurar una descripción para su categoría que se utilizará en sus páginas públicas, así como configurar las opciones de TrackBack para esta categoría.',
    'Your category changes have been made.' => 'Los cambios en la categoría se han guardado.',
    'Label' => 'Título',
    'Unlock this category\'s output filename for editing' => 'Desbloquear el fichero de salida de esta categoría para la edición',
    'Warning: Changing this category\'s basename may break inbound links.' => 'Cuidado: Cambiar el nombre base de la categoría podría romper los enlaces entrantes.',
    'Save this category (s)' => 'Guardar esta categoría (s)',
    'Inbound TrackBacks' => 'TrackBacks entradas',
    'If enabled, TrackBacks will be accepted for this category from any source.' => 'Si se habilita, en esta categoría se aceptarán los TrackBacks de cualquier fuente.',
    'TrackBack URL for this category' => 'URL de TrackBack para esta categoría',
    'This is the URL that others will use to send TrackBacks to your weblog. If you wish for anyone to send TrackBacks to your weblog when they have a post specific to this category, post this URL publicly. If you choose to only allow a select group of individuals to TrackBack, send this URL to them privately. To include a list of incoming TrackBacks in your Main Index Template, check the documentation for template tags related to TrackBacks.' => 'Esta es la URL que otros usarán para enviar TrackBacks a su weblog. Si desea que cualquiera pueda enviar TrackBacks a su weblog cuando escriban sobre esta categoría, publique esta URL. Si desea que solo un grupo selecto de personas hagan TrackBack, envíales esta URL privadamente. Para incluir una lista de los TrackBacks entrantes en su plantilla índice principal, compruebe la documentación de las etiquetas de plantillas de TrackBacks.',
    'Passphrase Protection' => 'Protección por contraseña',
    'Optional.' => 'Opcional.',
    'Outbound TrackBacks' => 'TrackBacks salientes',
    'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you post an entry in this category. (Separate URLs with a carriage return.)' => 'Introduzca las URLs de los sitios a los que desee notificar al publicar una entrada en esta categoría. (URLs separadas por un retorno de carro).',

    ## ./tmpl/cms/edit_template.tmpl
    'You have unsaved changes to your template that will be lost.' => 'Realizó cambios en la plantilla que no ha guardado y se perderán.',
    'Edit Template' => 'Editar plantilla',
    'Your template changes have been saved.' => 'Se guardaron sus cambios en las plantillas.',
    'Rebuild this template' => 'Reconstruir esta plantilla',
    'Build Options' => 'Opciones de generación',
    'Enable dynamic building for this template' => 'Permitir la generación dinámica para esta plantilla',
    'Rebuild this template automatically when rebuilding index templates' => 'Reconstruir automáticamente esta plantilla al reconstruir plantillas de índices',
    'Comment Listing Template' => 'Plantilla de listado de comentarios',
    'Comment Preview Template' => 'Plantilla de previsualización de comentarios',
    'Search Results Template' => 'Resultados de búsqueda de plantillas',
    'Comment Error Template' => 'Plantilla de errores de comentarios',
    'Comment Pending Template' => 'Plantilla de comentarios pendientes',
    'Commenter Registration Template' => 'Plantilla de registro de comentaristas',
    'TrackBack Listing Template' => 'Plantilla de listas de TrackBack',
    'Uploaded Image Popup Template' => 'Plantilla de ventana emergente de imágenes transferidas',
    'Dynamic Pages Error Template' => 'Plantilla de errores de páginas dinámicas',
    'Link this template to a file' => 'Enlazar esta plantilla a un archivo',
    'Module Body' => 'Cuerpo del módulo',
    'Template Body' => 'Cuerpo de la plantilla',
    'Insert...' => 'Insertar...',
    'Save this template (s)' => 'Guardar esta plantilla (s)',
    'Save and Rebuild' => 'Guardar y reconstruir',
    'Save and rebuild this template (r)' => 'Guadar y reconstruir esta plantilla (r)',

    ## ./tmpl/cms/pager.tmpl
    'Show Display Options' => 'Mostrar opciones de visualización',
    'Display Options' => 'Opciones de visualización',
    'Show:' => 'Mostrar:',
    '[quant,_1,row]' => '[quant,_1,fila]',
    'all rows' => 'todas las filas',
    'Another amount...' => 'Otra cantidad...',
    'View:' => 'Ver:',
    'Compact' => 'Compacto',
    'Expanded' => 'Expandido',
    'Actions' => 'Acciones',
    'Date Display:' => 'Fecha:',
    'Relative' => 'Relativo',
    'Full' => 'Completo',
    'Open Batch Editor' => 'Edición en lotes',
    'Newer' => 'Más reciente',
    'Showing:' => 'Mostrando:',
    'of' => 'de',
    'Older' => 'Más antiguo',

    ## ./tmpl/cms/rebuilt.tmpl
    'All of your files have been rebuilt.' => 'Se reconstruyeron todos sus ficheros.',
    'Your [_1] has been rebuilt.' => 'Su [_1] ha sido reconstruido.',
    'Your [_1] pages have been rebuilt.' => 'Sus [_1] páginas han sido reconstruidas.',
    'View this page' => 'Ver esta página',
    'Rebuild Again' => 'Reconstruir de nuevo',

    ## ./tmpl/cms/cfg_feedback.tmpl
    'Feedback Settings' => 'Configuración de respuestas',
    'This screen allows you to control the feedback settings for this weblog, including comments and TrackBacks.' => 'Esta pantalla le permite modificar la configuración de las respuestas en su weblog, que incluye los comentarios y TrackBacks.',
    'To see the changes reflected on your public site, you should rebuild your site now.' => 'Para ver reflejados los cambios en su sitio público, debe reconstruir ahora su sitio.',
    'Rebuild my site' => 'Reconstruir sitio',
    'Rebuild indexes' => 'Reconstruir índices',
    'Note: Commenting is currently disabled at the system level.' => 'Nota: Los comentarios están actualmente desactivados a nivel de sistema.',
    'Comment authentication is not available because one of the needed modules, MIME::Base64 or LWP::UserAgent is not installed. Talk to your host about getting this module installed.' => 'La autentificación de comentarios no está disponible porque uno de los módulos necesarios, MIME::Base64 o LWP::UserAgent no está instalado. Consulte con su alojamiento.',
    'Accept comments from' => 'Aceptar comentarios de',
    'Anyone' => 'Cualquiera',
    'Authenticated commenters only' => 'Solo comentaristas autentificados',
    'No one' => 'Nadie',
    'Specify from whom Movable Type shall accept comments on this weblog.' => 'Especifique de quiénes debe aceptar Movable Type comentarios en este weblog.',
    'Authentication Status' => 'Estado de autentificación',
    'Authentication Enabled' => 'Autentificación activada',
    'Authentication is enabled.' => 'La autentificación está activada.',
    'Clear Authentication Token' => 'Borrar token de autentificación',
    'Authentication Token:' => 'Token de autentificación:',
    'Authentication Token Removed' => 'Token de autentificación eliminado',
    'Please click the Save Changes button below to disable authentication.' => 'Por favor, haga clic en el botón Guardar cambios para desactivar la autentificación.',
    'Authentication Not Enabled' => 'Autentificación no activada',
    'Note: You have selected to accept comments from authenticated commenters only but authentication is not enabled. In order to receive authenticated comments, you must enable authentication.' => 'Nota: Seleccionó aceptar comentarios solo de comentaristas autentificados, pero la autentificación no está activada. Para recibir comentarios autentificados, debe activar la autentificación.',
    'Authentication is not enabled.' => 'La autentificación no está activada.',
    'Setup Authentication' => 'Configurar autentificación',
    'Or, manually enter token:' => 'O, teclee manualmente el token:',
    'Authentication Token Inserted' => 'Token de autentificación insertado',
    'Please click the Save Changes button below to enable authentication.' => 'Por favor, haga clic en el botón Guardar cambios para activar la autentificación.',
    'Establish a link between your weblog and an authentication service. You may use TypeKey (a free service, available by default) or another compatible service.' => 'Establece un enlace entre su weblog y el servicio de autentificación. Puede usar TypeKey (un servicio gratuito, disponible por defecto) u otros servicios compatibles.',
    'Require E-mail Address' => 'Requerir dirección de correo-e',
    'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Si está activo, los visitantes deberán introducir una dirección válida de correo electrónico para comentar.',
    'Immediately publish comments from' => 'Publicar inmediatamente los comentarios de',
    'Trusted commenters only' => 'Solo comentaristas confiados',
    'Any authenticated commenters' => 'Solo comentaristas autentificados',
    'Specify what should happen to non-junk comments after submission.' => 'Especifica qué debe ocurrir a los comentarios que no son basura después de su envío.',
    'Unpublished comments are held for moderation.' => 'Los comentarios no publicados se retienen para su moderación.',
    'E-mail Notification' => 'Notificación por correo-e',
    'On' => 'Activar',
    'Only when attention is required' => 'Solo cuando la atención es requerida',
    'Specify when Movable Type should notify you of new comments if at all.' => 'Especifica cuándo Movable Type debe notificarle de nuevos comentarios, cuando haya.',
    'Allow HTML' => 'Permitir HTML',
    'If enabled, users will be able to enter a limited set of HTML in their comments. If not, all HTML will be stripped out.' => 'Si está activado, los usuarios podrán introducir un conjunto limitado de etiquetas HTML en sus comentarios. De lo contrario, se filtra todo el HTML.',
    'Auto-Link URLs' => 'Autoenlazar direcciones URL',
    'If enabled, all non-linked URLs will be transformed into links to that URL.' => 'Si está activado, todas las URLs no enlazadas se transformarán en enlaces a esa URL.',
    'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Opción que especifica el formato de texto a utilizar para formatear los comentarios de los visitantes.',
    'Note: TrackBacks are currently disabled at the system level.' => 'Nota: Actualmente, los TrackBacks están desactivados a nivel del sistema.',
    'If enabled, TrackBacks will be accepted from any source.' => 'Si está activado, se aceptarán TrackBacks desde cualquier sitio.',
    'Moderation' => 'Moderación',
    'Hold all TrackBacks for approval before they\'re published.' => 'Retener todos los TrackBacks para su aprobación.',
    'Specify when Movable Type should notify you of new TrackBacks if at all.' => 'Especifica cuándo Movable Type debe notificarle nuevos TrackBacks, .',
    'Junk Score Threshold' => 'Umbral de basura',
    'Less Aggressive' => 'Menos agresivo',
    'More Aggressive' => 'Más agresivo',
    'Comments and TrackBacks receive a junk score between -10 (complete junk) and +10 (not junk). Feedback with a score which is lower than the threshold shown above will be marked as junk.' => 'Los comentarios y TrackBacks reciben una puntuación entre -10 (completamente basura) y +10 (no es basura). Las respuestas que reciban una puntuación menor del umbral se marcarán como basura.',
    'Auto-Delete Junk' => 'Autoeliminar basura',
    'If enabled, junk feedback will be automatically erased after a number of days.' => 'Si está activado, las respuestas basura serán eliminadas automáticamente después pasados unos días.',
    'Delete Junk After' => 'Eliminar basura después de',
    'days' => 'días',
    'When an item has been marked as junk for this many days, it is automatically deleted.' => 'Cuando un elemento está marcado como basura y pasan el número especificado de días, automáticamente se eliminará.',

    ## ./tmpl/cms/comment_actions.tmpl
    'Publish selected comments (p)' => 'Publicar comentarios seleccionados (p)',
    'Delete selected comments (x)' => 'Borrar comentarios seleccionados (x)',
    'Junk selected comments (j)' => 'Marcar como basura comentarios seleccionados (j)',
    'Recover selected comments (j)' => 'Recuperar comentarios seleccionados (j)',
    'Are you sure you want to remove all junk comments?' => '¿Está seguro de que desea borrar todos los comentarios basura?',
    'Deletes all junk comments' => 'Borra todos los comentarios basura',

    ## ./tmpl/cms/author_table.tmpl

    ## ./tmpl/cms/header.tmpl
    'Go to:' => 'Ir a:',
    'Select a blog' => 'Seleccione un blog',
    'System-wide listing' => 'Lista del sistema',

    ## ./tmpl/cms/edit_comment.tmpl
    'The comment has been approved.' => 'Comentario aprobado.',
    'List &amp; Edit Comments' => 'Listar y editar comentarios',
    'Pending Approval' => 'Autorización pendiente',
    'Junked Comment' => 'Comentario basura',
    'View all comments with this status' => 'Ver comentarios con este estado',
    '(Trusted)' => '(Confiado)',
    'Ban&nbsp;Commenter' => 'Bloquear&nbsp;comentarista',
    'Untrust&nbsp;Commenter' => 'Desconfiar&nbsp;de&nbsp;comentarista',
    '(Banned)' => '(Bloqueado)',
    'Trust&nbsp;Commenter' => 'Confiar&nbsp;comentarista',
    'Unban&nbsp;Commenter' => 'Desbloquear&nbsp;comentarista',
    'View all comments by this commenter' => 'Ver todos los comentarios de este comentarista',
    'None given' => 'No se indicó ninguno',
    'View all comments with this URL' => 'Ver todos los comentarios con esta URL',
    'Entry no longer exists' => 'La entrada ya no existe.',
    'No title' => 'Sin título',
    'View all comments on this entry' => 'Ver todos los comentarios de esta entrada',
    'View all comments posted on this day' => 'Ver todos los comentarios publicados en este día',
    'View all comments from this IP address' => 'Ver todos los comentarios procedentes de esta dirección IP',
    'Save this comment (s)' => 'Guardar este comentario (s)',
    'Delete this comment (x)' => 'Borrar este comentario (x)',
    'Final Feedback Rating' => 'Puntuación final respuestas',
    'Test' => 'Test', # Translate - Previous (1)
    'Score' => 'Puntuación',
    'Results' => 'Resultados',

    ## ./tmpl/cms/list_author.tmpl
    'You have successfully deleted the authors from the Movable Type system.' => 'Eliminó a los autores correctamente del sistema de Movable Type.',
    'Created By' => 'Creado por',
    'Last Entry' => 'Última entrada',

    ## ./tmpl/cms/pending_commenter.tmpl

    ## ./tmpl/cms/header-popup.tmpl

    ## ./tmpl/cms/edit_ping.tmpl
    'The TrackBack has been approved.' => 'Se aprobó el TrackBack.',
    'List &amp; Edit TrackBacks' => 'Listar &amp; editar TrackBacks',
    'Junked TrackBack' => 'TrackBack basura',
    'Status:' => 'Estado:',
    'View all TrackBacks with this status' => 'Ver TrackBacks con este estado',
    'Source Site:' => 'Sitio de origen:',
    'Search for other TrackBacks from this site' => 'Buscar otros TrackBacks en este sitio',
    'Source Title:' => 'Título original:',
    'Search for other TrackBacks with this title' => 'Buscar otros TrackBacks con este título',
    'Search for other TrackBacks with this status' => 'Buscar otros TrackBacks con este estado',
    'Target Entry:' => 'Entrada destinataria:',
    'View all TrackBacks on this entry' => 'Mostrar todos los TrackBacks de esta entrada',
    'Target Category:' => 'Categoría destinataria:',
    'Category no longer exists' => 'Ya no existe la categoría',
    'View all TrackBacks on this category' => 'Mostrar todos los TrackBacks de esta categoría',
    'View all TrackBacks posted on this day' => 'Mostrar todos los TrackBacks publicados este día',
    'View all TrackBacks from this IP address' => 'Mostrar todos los TrackBacks enviados desde esta dirección IP',
    'Save this TrackBack (s)' => 'Guardar este TrackBack (s)',
    'Delete this TrackBack (x)' => 'Borrar este TrackBack (x)',

    ## ./tmpl/cms/pinging.tmpl
    'Pinging sites...' => 'Enviando pings a sitios...',

    ## ./tmpl/cms/upgrade_runner.tmpl
    'Installation complete.' => 'Instalación completada.',
    'Upgrade complete.' => 'Actualización completada.',
    'Initializing database...' => 'Inicializando base la de datos...',
    'Upgrading database...' => 'Actualizando la base de datos...',
    'Starting installation...' => 'Comenzando la instalación...',
    'Starting upgrade...' => 'Comenzando actualización...',
    'Error during installation:' => 'Error durante la instalación:',
    'Error during upgrade:' => 'Error durante la actualización:',
    'Installation complete!' => '¡Instalación finalizada!',
    'Upgrade complete!' => '¡Actualización finalizada!',
    'Login to Movable Type' => 'Iniciar sesión en Movable Type',
    'Return to Movable Type' => 'Regresar a Movable Type',
    'Your database is already current.' => 'Su base de datos está al día.',

    ## ./tmpl/cms/cfg_simple.tmpl
    'This screen allows you to control all settings specific to this weblog.' => 'Esta pantalla le permite controlar toda la configuración específica de este weblog.',
    'Publishing Paths' => 'Rutas de publicación',
    'Enter the URL of your website. Do not include a filename (i.e. exclude index.html).' => 'Teclee la URL de su sitio. No incluya nombres de archivos (p.e. excluya index.html).',
    'Enter the path where your index files will be published. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'Teclee la ruta donde se publicarán los ficheros índices. Se recomienda especificar la ruta absoluta (comenzando con \'/\'), pero también puede usar una ruta relativa al directorio de Movable Type.',
    'You can configure the publishing model for this blog (static vs dynamic) on the ' => 'Puede configurar el modelo de publicación para este blog (estático vs dinámico) en la página de ',
    'Detailed Settings' => 'Configuración detallada',
    ' page.' => '.',
    'Choose to display a number of recent entries or entries from a recent number of days.' => 'Muestre un número de específico de entradas recientes o las entradas recientes desde un cierto número de días.',
    'Specify which types of commenters will be allowed to leave comments on this weblog.' => 'Especifique qué tipo de comentaristas podrán dejar comentarios en este weblog.',
    'If you want to require visitors to sign in before leaving a comment, set up authentication with the free TypeKey service.' => 'Si quiere obligar a los visitantes a registrarse antes de dejar un comentario, configure la autentificación en el servicio gratuito TypeKey.',
    'Specify what should happen to comments after submission. Unpublished comments are held for moderation and junk comments do not appear.' => 'Especifique qué debe ocurrirle a los comentarios después de su envío. Los comentarios no publicados se bloquean para su moderación y los comentarios basura no se publican.',
    'Accept TrackBacks from people who link to your weblog.' => 'Aceptar TrackBacks de personas que enlazan a su weblog.',

    ## ./tmpl/cms/list_blog.tmpl
    'System Shortcuts' => 'Atajos del sistema',
    'Concise listing of weblogs.' => 'Lista concisa de weblogs.',
    'Create, manage, set permissions.' => 'Crear, administrar, establecer permisos.',
    'What\'s installed, access to more.' => 'Qué está instalado, acceder a otros.',
    'Multi-weblog entry listing.' => 'Lista de entradas multi-weblog.',
    'Multi-weblog tag listing.' => 'Lista de etiquetas multi-weblog .',
    'Multi-weblog comment listing.' => 'Lista de comentarios multi-weblog.',
    'Multi-weblog TrackBack listing.' => 'Lista de TrackBacks multi-weblog.',
    'System-wide configuration.' => 'Configuración del sistema.',
    'Find everything. Replace anything.' => 'Encontrar todo. Reemplazar cualquier cosa.',
    'What\'s been happening.' => 'Qué sucede.',
    'Status &amp; Info' => 'Estado &amp; información',
    'Server status and information.' => 'Estado e información del servidor.',
    'Set Up A QuickPost Bookmarklet' => 'Configurar QuickPost',
    'Enable one-click publishing.' => 'Habilitar publicación con un solo clic.',
    'My Weblogs' => 'Mis weblogs',
    'Important:' => 'Importante:',
    'Configure this weblog.' => 'Configurar este weblog.',
    'Create a new entry' => 'Crear una nueva entrada',
    'Create a new entry on this weblog' => 'Crea una nueva entrada en este weblog',
    'Sort By:' => 'Ordenar por:',
    'Creation Order' => 'Orden de creación',
    'Last Updated' => 'Últimas actualizaciones',
    'Order:' => 'Orden:',
    'You currently have no blogs.' => 'Actualmente no tiene blogs.',
    'Please see your system administrator for access.' => 'Por favor, para acceder consulte con su administrador de sistemas.',

    ## ./tmpl/cms/commenter_table.tmpl
    'Most Recent Comment' => 'Comentario más reciente',
    'Only show trusted commenters' => 'Mostrar solo comentaristas confiados',
    'Only show banned commenters' => 'Mostrar solo comentaristas bloqueados',
    'Only show neutral commenters' => 'Mostrar solo comentaristas neutrales',
    'View this commenter\'s profile' => 'Mostrar perfil del comentarista',

    ## ./tmpl/cms/template_table.tmpl

    ## ./tmpl/cms/blog_actions.tmpl
    'weblog' => 'weblog', # Translate - Previous (1)
    'weblogs' => 'weblogs', # Translate - Previous (1)
    'Delete selected weblogs (x)' => 'Borrar weblogs seleccionados (x)',

    ## ./tmpl/cms/system_list_blog.tmpl
    'Are you sure you want to delete this weblog?' => '¿Está seguro de que desea borrar este weblog?',
    'Below you find a list of all weblogs in the system with links to the main weblog page and individual settings pages for each.  You may also create or delete blogs from this screen.' => 'Debajo encontrará una lista de todos los weblogs del sistema, con enlaces a las páginas principales y preferencias de cada weblog. También podrá crear o eliminar blogs desde esta pantalla.',
    'You have successfully deleted the blogs from the Movable Type system.' => 'Eliminó correctamente los weblogs.',
    'Create New Weblog' => 'Crear weblog',
    'No weblogs could be found.' => 'No se encontró ningún weblog.',

    ## ./tmpl/cms/footer-popup.tmpl

    ## ./tmpl/cms/search_replace.tmpl
    'You must select one or more item to replace.' => 'Debe seleccionar uno o más elementos a reemplazar.',
    'Search Again' => 'Buscar de nuevo',
    'Search:' => 'Buscar:',
    'Replace:' => 'Reemplazar:',
    'Replace Checked' => 'Reemplazar selección',
    'Case Sensitive' => 'Distinguir mayúsculas y minúsculas',
    'Regex Match' => 'Expresión regular',
    'Limited Fields' => 'Campos limitados',
    'Date Range' => 'Rango de fechas',
    'Is Junk?' => '¿Es basura?',
    'Search Fields:' => 'Buscar campos:',
    'Comment Text' => 'Comentario',
    'E-mail Address' => 'Correo electrónico',
    'Source URL' => 'URL origen',
    'Blog Name' => 'Nombre del blog',
    'Text' => 'Texto',
    'Output Filename' => 'Fichero salida',
    'Linked Filename' => 'Fichero enlazado',
    'From:' => 'Desde:',
    'To:' => 'A:',
    'Replaced [_1] records successfully.' => 'Reemplazados con éxito [_1] registros.',
    'No entries were found that match the given criteria.' => 'No se encontraron entradas que coincidieran con el criterio de búsqueda.',
    'No comments were found that match the given criteria.' => 'No se encontraron comentarios que coincidieran con el criterio de búsqueda.',
    'No TrackBacks were found that match the given criteria.' => 'No se encontraron TrackBacks que coincidieran con el criterio de búsqueda.',
    'No commenters were found that match the given criteria.' => 'No se encontraron comentaristas que coincidieran con el criterio de búsqueda.',
    'No templates were found that match the given criteria.' => 'No se encontraron plantillas que coincidieran con el criterio de búsqueda.',
    'No log messages were found that match the given criteria.' => 'No se encontraron mensajes del histórico que coincidieran con el criterio de búsqueda.',
    'No authors were found that match the given criteria.' => 'No se encontraron autores que coincidieran con el criterio de búsqueda.',
    'Showing first [_1] results.' => 'Primeros [_1] resultados.',
    'Show all matches' => 'Mostrar todos los resultados',
    '[_1] result(s) found.' => '[_1] resultado/s encontrado/s.',

    ## ./tmpl/cms/system_info.tmpl
    'System Status and Information' => 'Estado e información del sistema',
    'This page will soon contain information about the server environment availability of required perl modules, installed plugins and other information useful for expediting debugging in technical support requests.' => 'Esta página contendrá en breve información sobre la disponibilidad en el servidor de los módulos Perl requeridos, extensiones y otra información útil para las peticiones de soporte técnico.',

    ## ./tmpl/cms/entry_actions.tmpl
    'Save these entries (s)' => 'Guardar estas entradas (s)',
    'Save this entry (s)' => 'Guardar esta entrada (s)',
    'Preview this entry (v)' => 'Vista previa de la entrada (v)',
    'entry' => 'entrada',
    'entries' => 'entradas',
    'Delete this entry (x)' => 'Borrar esta entrada (x)',
    'to rebuild' => 'para reconstruir',
    'Rebuild selected entries (r)' => 'Reconstruir entradas seleccionadas (r)',
    'Delete selected entries (x)' => 'Borrar entradas seleccionadas (x)',

    ## ./tmpl/cms/bm_entry.tmpl
    'Select' => 'Seleccionar',
    'You must choose a weblog in which to post the new entry.' => 'Debe elegir el weblog en el que desea publicar la nueva entrada.',
    'Select a weblog for this post:' => 'Seleccionar un weblog para esta entrada:',
    'Send an outbound TrackBack:' => 'Enviar un TrackBack saliente:',
    'Select an entry to send an outbound TrackBack:' => 'Seleccionar una entrada para enviar un TrackBack saliente:',
    'Accept' => 'Aceptar',
    'You do not have entry creation permission for any weblogs on this installation. Please contact your system administrator for access.' => 'No tiene permiso de creación de entradas en esta instalación. Por favor, contacte con su administrador de sistemas para el acceso.',

    ## ./tmpl/cms/cfg_archives.tmpl
    'Are you sure you want to delete this template map?' => '¿Está seguro de que desea borrar este mapa de plantillas?',
    'You must set a valid Site URL.' => 'Debe establecer una URL de sitio válida.',
    'You must set a valid Local Site Path.' => 'Debe establecer una ruta local de sitio válida.',
    'Publishing Settings' => 'Configuración de publicación',
    'This screen allows you to control this weblog\'s publishing paths and preferences, as well as archive mapping settings.' => 'Esta pantalla le permite modificar la configuración de las rutas de publicación del weblog y sus preferencias, así como la configuración de los mapeos de archivo.',
    'Error: Movable Type was not able to create a directory for publishing your weblog. If you create this directory yourself, assign sufficient permissions that allow Movable Type to create files within it.' => 'Error: Movable Type no puedo crear un directorio para publicar su weblog. Si crea el directorio usted mismo, debe asignar permisos suficientes para que Movable Type pueda crear ficheros dentro de él.',
    'Your weblog\'s archive configuration has been saved.' => 'La configuración de los archivos de su weblogs se ha guardado.',
    'You may need to update your templates to account for your new archive configuration.' => 'Quizás deba actualizar sus plantillas para mostrar las nuevas opciones de archivado.',
    'You have successfully added a new archive-template association.' => 'Agregó correctamente una nueva asociación archivo-plantilla.',
    'You may need to update your \'Master Archive Index\' template to account for your new archive configuration.' => 'Podría tener que actualizar la plantilla \'Archivo índice maestro\' para tener en cuenta la nueva configuración del archivado.',
    'The selected archive-template associations have been deleted.' => 'Las asociaciones seleccionadas archivos-plantillas fueron eliminadas.',
    'Advanced Archive Publishing:' => 'Publicación avanzada de archivos:',
    'Publish archives to alternate root path' => 'Publicar archivos en una ruta alternativa',
    'Select this option only if you need to publish your archives outside of your Site Root.' => 'Seleccione esta opción solo si necesita publicar sus archivos fuera de la raíz de su sitio.',
    'Archive URL:' => 'URL de archivos:',
    'Enter the URL of the archives section of your website.' => 'Teclee la URL de la sección de archivos de su sitio.',
    'Archive Root' => 'Raíz de archivos',
    'Enter the path where your archive files will be published.' => 'Teclee la ruta donde se publicarán los archivos.',
    'Publishing Preferences' => 'Preferencias de publicación',
    'Preferred Archive Type:' => 'Tipo de archivo preferente:',
    'No Archives' => 'Sin archivos',
    'Individual' => 'Individual', # Translate - Previous (1)
    'Daily' => 'Diariamente',
    'Weekly' => 'Semanalmente',
    'Monthly' => 'Mensualmente',
    'When linking to an archived entry&#8212;for a permalink, for example&#8212;you must link to a particular archive type, even if you have chosen multiple archive types.' => 'En el momento de enlazar a una entrada archivada &#8212;por ejemplo, a un enlace permanente&#8212;debe enlazar a un tipo de archivo determinado, incluso si eligió varios tipos.',
    'File Extension for Archive Files:' => 'Extensión de los archivos:',
    'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'Introduzca la extensión de los archivos. Puede ser \'html\', \'shtml\', \'php\', etc. Nota: No introduzca el punto separador de la extensión (\'.\').',
    'Dynamic Publishing:' => 'Publicación dinámica:',
    'Build all templates statically' => 'Generar todas las plantillas estáticamente',
    'Build only Archive Templates dynamically' => 'Generar dinámicamente solo las plantillas de archivos',
    'Set each template\'s Build Options separately' => 'Especificar las opciones de reconstrucción de cada plantilla de forma individual',
    'Archive Mapping' => 'Mapeado de archivos',
    'Create New Archive Mapping' => 'Crear mapeado de archivos',
    'Archive Type:' => 'Tipo de archivado:',
    'INDIVIDUAL_ADV' => 'Individualmente',
    'DAILY_ADV' => 'Diariamente',
    'WEEKLY_ADV' => 'Semanalmente',
    'MONTHLY_ADV' => 'Mensualmente',
    'CATEGORY_ADV' => 'Por categoría',
    'Template' => 'Plantilla',
    'Archive Types' => 'Tipos de archivado',
    'Archive File Path' => 'Ruta de los ficheros de archivos',
    'Preferred' => 'Preferente',
    'Custom...' => 'Personalizar...',
    'archive map' => 'mapa de archivos',
    'archive maps' => 'mapas de archivos',

    ## ./tmpl/cms/upload.tmpl
    'To upload a file to your server, click on the browse button to locate the file on your hard drive.' => 'Para transferir un fichero a su servidor, haga clic en el botón Examinar para localizar el archivo en su disco duro.',
    'File:' => 'Fichero:',
    'Set Upload Path' => 'Establecer directorio de transferencias',
    '(Optional)' => '(opcional)',
    'Path:' => 'Directorio:',
    'Upload' => 'Transferir',

    ## ./tmpl/cms/footer.tmpl

    ## ./tmpl/cms/edit_categories.tmpl
    'Your category changes and additions have been made.' => 'Se guardaron los cambios y nuevas categorías.',
    'You have successfully deleted the selected categories.' => 'Se eliminaron correctamente las categorías seleccionadas.',
    'Create new top level category' => 'Crear nueva categoría de nivel superior',
    'Create Category' => 'Crear categoría',
    'Collapse' => 'Contraer',
    'Expand' => 'Ampliar',
    'Create Subcategory' => 'Crear subcategoría',
    'Move Category' => 'Trasladar categoría',
    'Move' => 'Trasladar',
    '[quant,_1,TrackBack]' => '[quant,_1,TrackBack]', # Translate - Previous (4)
    'categories' => 'categorías',
    'Delete selected categories (x)' => 'Borrar las categorías seleccionadas (x)',

    ## ./tmpl/cms/edit_placements.tmpl
    'The secondary categories for this entry have been updated. You will need to SAVE the entry for these changes to be reflected on your public site.' => 'Las categorías secundarias de esta entrada fueron actualizadas. Para que estos cambios se reflejen en su sitio público, deberá GUARDAR la entrada.',
    'Categories in your weblog:' => 'Categorías en su weblog:',
    'Secondary categories:' => 'Categorías secundarias:',
    'Assign &gt;&gt;' => 'Asignar &gt;&gt;',
    '&lt;&lt; Remove' => '&lt;&lt; Eliminar',

    ## ./tmpl/cms/rebuild-stub.tmpl

    ## ./tmpl/wizard/mt-config.tmpl

    ## ./tmpl/wizard/packages.tmpl
    'Step 1 of 3' => 'Paso 1 de 3',
    'Requirements Check' => 'Comprobación de requerimientos',
    'One of the following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your weblog data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the \'Retry\' button.' => 'Uno de los siguientes módulos de Perl es necesario para realizar una conexión con la base de datos. Movable Type necesita una base de datos para guardar los datos de los weblogs. Por favor, instale uno de los paquetes listados aquí para proceder. Cuando esté listo, haga clic en el botón \'Reintentar\'.',
    'Missing Database Packages' => 'Paquetes de base de datos no instalados',
    'The following optional, feature-enhancing Perl modules could not be found. You may install them now and click \'Retry\' or simply continue without them.  They can be installed at any time if needed.' => 'Los siguientes módulos de Perl no se encontraron. Puede instalarlos ahora y hacer clic en \'Reintentar\' o continuar sin ellos.',
    'Missing Optional Packages' => 'Paquetes opcionales no instalados',
    'The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the \'Retry\' button to re-test for these packages.' => 'Los siguientes módulos de Perl son necesarios para que Movable Type se ejecute correctamente. Una vez cumpla estos requerimientos, haga clic en el botón \'Reintentar\' para comprobar de nuevo estos paquetes.',
    'Missing Required Packages' => 'Paquetes necesarios no instalados',
    'Minimal version requirement:' => 'Versión mínima necesaria:',
    'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'Su servidor tiene todos los módulos necesarios instalados; no necesita realizar ninguna instalación adicional de módulos.',
    'Back' => 'Regresar',
    'Retry' => 'Reintentar',

    ## ./tmpl/wizard/optional.tmpl
    'Step 3 of 3' => 'Paso 3 de 3',
    'Mail Configuration' => 'Configuración del correo',
    'Your mail configuration is complete. To finish with the configuration wizard, press \'Continue\' below.' => 'La configuración de su correo se ha completado. Para finalizar con el asistente de configuración, presione \'Continuar\' debajo.',
    'You can configure you mail settings from here, or you can complete the configuration wizard by clicking \'Continue\'.' => 'Puede configurar todas las opciones del correo desde aquí, o puede completar el asistente de configuración haciendo clic en \'Continuar\'.',
    'An error occurred while attempting to send mail: ' => 'Ocurrió un error intentando enviar un correo: ',
    'MailTransfer' => 'MailTransfer', # Translate - Previous (1)
    'Select One...' => 'Seleccione uno...',
    'SendMailPath' => 'SendMailPath', # Translate - Previous (1)
    'The physical file path for your sendmail.' => 'La ruta física de su sendmail.',
    'SMTP Server' => 'Servidor SMTP',
    'Address of your SMTP Server' => 'Dirección de su servidor SMTP',
    'Mail address for test sending' => 'Dirección de correo para test de envío',
    'Send Test Email' => 'Enviar correo de prueba',

    ## ./tmpl/wizard/complete.tmpl
    'Congratulations! You\'ve successfully configured [_1] [_2].' => '¡Felicidades! Configuró con éxito [_1] [_2].',
    'This is a copy of your configuration settings.' => 'Esta es una copia de sus opciones de configuración.',
    'We were unable to create your configuration file. If you would like to check the directory permissions and retry, click the \'Retry\' button.' => 'No se pudo crear el fichero de configuración. Si desea comprobar los permisos del directorio y reintentarlo, haga clic en el botón \'Reintentar\'.',
    'Install' => 'Instalar',

    ## ./tmpl/wizard/header.tmpl
    'Movable Type' => 'Movable Type', # Translate - Previous (2)
    'Movable Type Configuration Wizard' => 'Asistente de configuración de Movable Type',

    ## ./tmpl/wizard/start.tmpl
    'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Movable Type necesita que JavaScript esté habilitado en su navegador. Por favor, habilítelo y refresque esta página para continuar.',
    'Your Movable Type configuration file already exists. The Wizard cannot continue with this file present.' => 'El fichero de configuración de Movable Type ya existe. El asistente no puede continuar con el fichero presente.',
    'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Este asistente le ayudará a configurar las opciones básicas necesarias para ejecutar Movable Type.',
    'Static Web Path' => 'Ruta al web estático',
    'Due to your server\'s configuration it is not accessible in its current location and must be moved to a web-accessible location (e.g. into your web document root directory).' => 'Debido a la configuración de su servidor no es accesible en la dirección actual y debe moverse a una ruta accesible por el web (por ejemplo, el directorio de documentos raíz de su servidor web).',
    'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Este directorio ha sido renombrado o movido de lugar fuera del directorio de Movable Type.',
    'Please specify the web-accessible URL to this directory below.' => 'Por favor, especifique la URL de acceso web de este directorio.',
    'Static web path URL' => 'URL de acceso web estático',
    'This can be in the form of http://example.com/mt-static/ or simply /mt-static' => 'Puede tener el formato http://ejemplo.com/mt-estatico/ o simplemente /mt-estatico',
    'Begin' => 'Comenzar',

    ## ./tmpl/wizard/configure.tmpl
    'You must set your Database Path.' => 'Debe establecer la ruta de la base de datos.',
    'You must set your Database Name.' => 'Debe establecer el nombre de la base de datos.',
    'You must set your Username.' => 'Debe establecer su nombre de usuario.',
    'You must set your Database Server.' => 'Debe establecer el servidor de base de datos.',
    'Step 2 of 3' => 'Paso 2 de 3',
    'Database Configuration' => 'Configuración de la base de datos',
    'Your database configuration is complete. Click \'Continue\' below to configure your mail settings.' => 'La configuración de la base de datos se ha completado. Haga clic en \'Continuar\' para configurar el correo.',
    'Please enter the parameters necessary for connecting to your database.If your database type is not listed in the dropdown below, you may be missing the Perl module necessary to connect to your database.  If this is the case, please check your installation and click <a href=' => 'Por favor, introduzca los parámetros necesarios para la conexión a la base de datos. Si su base de datos no está listada en el menú desplegable de abajo, es posible que no tenga instalados algunos de los módulos de Perl necesarios para la conexión. En este caso, por favor, compruebe su instalación y haga clic en <a href=',
    'An error occurred while attempting to connect to the database: ' => 'Ocurrió un error intentando la conexión a la base de datos: ',
    'Database' => 'Base de datos',
    'Database Path' => 'Ruta de la base de datos',
    'The physical file path for your BerkeleyDB or SQLite database. ' => 'Ruta al fichero físico de su base de datos BerkeleyDB o SQLite. ',
    'A default location of \'./db\' will store the database file(s) underneath your Movable Type directory.' => 'Los ficheros de la base de datos se guardarán en una ruta predefinida, \'./db\', en el directorio de Movable Type.',
    'Database Name' => 'Nombre de la base de datos',
    'The name of your SQL database (this database must already exist).' => 'El nombre de la base de datos SQL (esta base de datos ya debe existir).',
    'The username to login to your SQL database.' => 'El usuario para acceder a la base de datos SQL.',
    'The password to login to your SQL database.' => 'La contraseña para acceder a la base de datos SQL.',
    'Database Server' => 'Servidor de base de datos',
    'This is usually \'localhost\'.' => 'Usualmente es \'localhost\'.',
    'Database Port' => 'Puerto de la base de datos',
    'This can usually be left blank.' => 'Usualmente se deja en blanco.',
    'Database Socket' => 'Socket de la base de datos',
    'Test Connection' => 'Comprobar conexión',

    ## ./tmpl/wizard/footer.tmpl

    ## ./tmpl/feeds/feed_chrome.tmpl

    ## ./tmpl/feeds/feed_comment.tmpl
    'system' => 'sistema',
    'Blog' => 'Blog', # Translate - Previous (1)
    'Untitled' => 'Sin título',
    'Edit' => 'Editar',
    'Unpublish' => 'Despublicar',
    'More like this' => 'Más como éstos',
    'From this blog' => 'De este blog',
    'On this entry' => 'En esta entrada',
    'By commenter identity' => 'Por identidad del comentarista',
    'By commenter name' => 'Por nombre del comentarista',
    'By commenter email' => 'Por correo electrónico del comentarista',
    'By commenter URL' => 'Por URL del comentarista',
    'On this day' => 'En este día',

    ## ./tmpl/feeds/error.tmpl
    'Movable Type Activity Log' => 'Registro de actividad de Movable Type',
    'Movable Type System Activity' => 'Actividad del sistema de Movable Type',

    ## ./tmpl/feeds/feed_entry.tmpl
    'From this author' => 'De este autor',

    ## ./tmpl/feeds/login.tmpl
    'This link is invalid. Please resubscribe to your activity feed.' => 'Este enlace no es válido. Por favor, resuscríbase a la fuente de sindicación de actividades.',

    ## ./tmpl/feeds/feed_ping.tmpl
    'Source blog' => 'Blog origen',
    'By source blog' => 'Por blog origen',
    'By source title' => 'Por título origen',
    'By source URL' => 'Por URL origen',

    ## ./tmpl/feeds/feed_system.tmpl

    ## ./tmpl/email/recover-password.tmpl

    ## ./tmpl/email/new-comment.tmpl
    'An unapproved comment has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => 'Se recibió un comentario en su blog [_1], en la entrada nº[_2] ([_3]). Debe aprobar este comentario para que aparezca en su sitio.',
    'Approve this comment:' => 'Aprobar este comentario:',
    'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Se publicó un nuevo comentario en su weblog [_1], en la entrada nº [_2] ([_3]).',
    'View this comment:' => 'Ver este comentario:',
    'Comments:' => 'Comentarios:',

    ## ./tmpl/email/notify-entry.tmpl
    '[_1] Update: [_2]' => '[_1] Actualiza: [_2]',

    ## ./tmpl/email/verify-subscribe.tmpl
    'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Gracias por suscribirse a las notificaciones sobre actualizaciones en [_1]. Siga el enlace de abajo para confirmar su suscripción:',
    'If the link is not clickable, just copy and paste it into your browser.' => 'Si no puede hacer clic en el enlace, copie y péguelo en su navegador.',

    ## ./tmpl/email/new-ping.tmpl
    'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Se recibió un TrackBack [_1], en la entrada nº[_2] ([_3]). Debe aprobarlo para que aparezca en su sitio.',
    'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Se recibió un TrackBack en su blog [_1], en la categoría #[_2], ([_3]). Debe aprobarlo para que aparezca en su sitio.',
    'Approve this TrackBack:' => 'Aprobar este TrackBack:',
    'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Se publicó un nuevo TrackBack en su blog [_1], en la entrada nº[_2] ([_3]).',
    'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'Se publicó un nuevo TrackBack en su blog [_1], en la categoría nº[_2] ([_3]).',
    'View this TrackBack:' => 'Ver este TrackBack:',

    ## ./tmpl/email/footer-email.tmpl
    'Powered by Movable Type' => 'Powered by Movable Type', # Translate - Previous (4)

    ## ./t/driver-tests.pl

    ## ./t/blog-common.pl

    ## ./t/test-common.pl

    ## ./t/test.tmpl

    ## ./t/plugins/testplug.pl

    ## Other phrases, with English translations.
    'Bad ObjectDriver config' => 'Configuración de ObjectDriver incorrecta', # Translate - New (3)
    'Two plugins are in conflict' => 'Dos extensiones están en conflicto', # Translate - New (5)
    '_BLOG_CONFIG_MODE_DETAIL' => 'Modo detallado',
    'Updating category placements...' => 'Actualizando situación de categorías...', # Translate - New (3)
    'The previous post in this blog was <a href="[_1]">[_2]</a>.' => 'La entrada anterior en este blog fue <a href="[_1]">[_2]</a>.',
    'RSS 1.0 Index' => 'Índice RSS 1.0',
    '_USAGE_BOOKMARKLET_4' => 'Después de instalar QuickPost, puede crear una entrada desde cualquier punto de Internet. Cuando esté visualizando una página y desee escribir sobre la misma, haga clic en "QuickPost" para abrir una ventana emergente especial de edición de Movable Type. Desde esa ventana puede seleccionar el weblog en el que desea publicar, luego escribir su entrada y guardarla.',
    'Remove Tags...' => 'Borrar entradas...',
    '_BLOG_CONFIG_MODE_BASIC' => 'Modo básico',
    'DAILY_ADV' => 'Diariamente',
    '_USAGE_PERMISSIONS_3' => 'Existen dos maneras de editar autores y otorgarles o denegarles privilegios de acceso. Para acceder rápidamente, seleccione un usuario en el menú siguiente y seleccione Editar. Alternativamente, puede desplazarse por la lista completa de autores y desde allí seleccionar el nombre que desea editar o eliminar.',
    'Tags to remove from selected entries' => 'Etiquetas a borrar de las entradas seleccionadas',
    '_NOTIFY_REQUIRE_CONFIRMATION' => 'Se envió un correo a [_1]. Para completar su suscripción, 
por favor siga el enlace que aparece en este mensaje. Esto verificará que
la dirección provista es correcta y le pertenece.',
    'Manage Notification List' => 'Administrar lista de notificaciones',
    'This page contains an archive of all entries posted to [_1] in the <strong>[_2]</strong> category.  They are listed from oldest to newest.' => 'Esta página contiene un archivo de todas las entradas publicadas en [_1] en la categoría <strong>[_2]</strong>.  Están listadas de más antiguas a más recientes.',
    'Individual' => 'Individual', # Translate - Previous (1)
    'An error occurred while testing for the new tag name.' => 'Ocurrió un error mientras se probaba el nuevo nombre de la etiqueta.', # Translate - New (10)
    'Updating blog old archive link status...' => 'Actualizando el estado de los enlaces de archivado antiguos...', # Translate - New (6)
    '_USAGE_COMMENTS_LIST_ALL_WEBLOGS' => 'Ésta es la lista de comentarios de todos los weblogs. Puede editar cualquier comentario haciendo clic en el TEXTO DEL COMENTARIO. Para FILTRAR las entradas, haga clic en uno de los valores de la lista.',
    '_USAGE_FORGOT_PASSWORD_2' => 'Debería poder iniciar una sesión en Movable Type con esta nueva contraseña. Después de iniciar la sesión, cambie su contraseña a otra que pueda memorizar y recordar fácilmente.',
    'To enable comment registration, you need to add a TypeKey token in your weblog config or author profile.' => 'Para habilitar el registro de comentarios, debe añadir un token de TypeKey a la configuración de su weblog o al perfil de su autor.', # Translate - New (18)
    '_USAGE_COMMENT' => 'Edite el comentario seleccionado. Presione GUARDAR cuando haya terminado. Para que estos cambios entren en vigor, deberá ejecutar el proceso de reconstrucción.',
    '_SEARCH_SIDEBAR' => 'Buscar',
    '_SYSTEM_TEMPLATE_DYNAMIC_ERROR' => 'Mostrado cuando se encuentra un error en una página dinámica. ',
    'An error occurred processing [_1]. Check <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">here</a> for more detail and please try again.' => 'Ocurrió un error procesando [_1]. Consulte <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">aquí</a> para más detalles e información e inténtelo de nuevo.',
    'View image' => 'Ver imagen', # Translate - New (2)
    'Date-Based Archive' => 'Archivo por fechas',
    'Unban Commenter(s)' => 'Desbloquear comentarista/s',
    'Individual Entry Archive' => 'Archivo de entradas individuales',
    'Daily' => 'Diariamente',
    'Setting blog basename limits...' => 'Estableciendo los límites del nombre base del blog...', # Translate - New (4)
    'Assigning visible status for comments...' => 'Asignando estado de visibilidad a los comentarios...', # Translate - New (5)
    'Unpublish Entries' => 'Despublicar entradas',
    'Powered by [_1]' => 'Powered by [_1]', # Translate - New (3)
    'Create a feed widget' => 'Crear un widget de fuentes de sindicación',
    '_USAGE_UPLOAD' => 'Puede transferir el fichero anterior a la ruta local del sitio <a href="javascript:alert(\'[_1]\')">(?)</a> o a su ruta local de archivado <a href="javascript:alert(\'[_2]\')">(?)</a>. También puede transferir el fichero a cualquier subdirectorio de esos directorios, especificando la ruta en el cuadro de texto de la derecha (<i>imagenes</i>, por ejemplo). Si el directorio no existe, se creará.',
    '<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> es el siguiente archivo.',
    'Updating commenter records...' => 'Actualizando registros de comentaristas...', # Translate - New (3)
    'Assigning junk status for comments...' => 'Asignando estado de \'basura\' a los comentarios...', # Translate - New (5)
    'Bad CGIPath config' => 'Configuración CGIPath incorrecta', # Translate - New (3)
    'Refreshing (with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>) template \'[_3]\'.' => 'Refrescando (con <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">copia de seguridad</a>) la plantilla \'[_3]\'.',
    '_USAGE_REBUILD' => '<a href="#" onclick="doRebuild()">RECONSTRUIR</a> para ver esos cambios reflejados en su sitio público.',
    'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Archivo de configuración no encontrado. ¿Quizás olvidó renombrar mt-config.cgi-original a mt-config.cgi?', # Translate - New (13)
    'If present, 3rd argument to add_callback must be an object of type MT::Plugin' => 'Si está presente, el tercer argumento de add_callback debe ser un objeto de tipo MT::Plugin', # Translate - New (15)
    'Blog Administrator' => 'Administrador de blogs',
    'CATEGORY_ADV' => 'Por categoría',
    '_WARNING_PASSWORD_RESET_MULTI' => 'Va a reiniciar la contraseña de los usuarios seleccionados. Se generarán nuevas contraseñas aleatorias que se enviarán directamente a sus direcciones de correo electrónico.  ¿Desea continuar?',
    'You must define a Comment Listing template in order to display dynamic comments.' => 'Debe definir una plantilla de listado de comentarios para mostrar comentarios dinámicos.', # Translate - New (13)
    'Dynamic Site Bootstrapper' => 'Inicializador del sistema dinámico',
    'Assigning entry basenames for old entries...' => 'Asignando nombre base de entradas en entradas antiguas...', # Translate - New (6)
    'Assigning blog administration permissions...' => 'Asignando permisos de administración de blogs...', # Translate - New (4)
    '_USAGE_COMMENTS_LIST_BLOG' => 'Aquí tiene una lista de comentarios de [_1] que puede filtrar, administrar y editar.',
    'Error sending mail ([_1]); please fix the problem, then try again to recover your password.' => 'Error enviando correo ([_1]); por favor, solvente el problema e inténte de nuevo la recuperación de la contraseña.', # Translate - New (15)
    'Error saving entry: [_1]' => 'Error guardando entrada: [_1]', # Translate - New (4)
    'Category Archive' => 'Archivo de categorías',
    'index' => 'index', # Translate - New (1)
    'Updating user permissions for editing tags...' => 'Actualizando los permisos de los usuarios para la edición de etiquetas...', # Translate - New (6)
    'Assigning author types...' => 'Asignando tipos de autor...', # Translate - New (3)
    '_USAGE_EXPORT_1' => 'La exportación de sus entradas fuera de Movable Type le permitirá tener <b>copias de seguridad personales</b> de sus entradas, para guardarlas en lugar seguro. El formato de los datos exportados permite volverlos a importar en el sistema aprovechando el mecanismo de importación (ver más arriba); de este modo, además de exportar sus entradas como copias de seguridad, también podrá utilizarlo para <b>transferir contenidos entre weblogs</b>.',
    '_SYSTEM_TEMPLATE_PINGS' => 'Mostrado cuando las ventanas emergentes de TrackBack (obsoletas) están activadas.',
    'Setting default blog file extension...' => 'Estableciendo extensión predefinida de fichero de blog...', # Translate - New (5)
    '<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> es la categoría anterior.',
    'Entry Creation' => 'Creación de entradas',
    'Assigning visible status for TrackBacks...' => 'Asignando estado de visiblidad para los TrackBacks...', # Translate - New (5)
    'Atom Index' => 'Índice Atom',
    '_USAGE_PLACEMENTS' => 'Utilice las herramientas de edición que aparecen a continuación para administrar las categorías secundarias a las que se asigna esta entrada. La lista de la izquierda contiene las categorías a las que esta entrada aún no está asigna como categoría principal o secundaria; la lista de la derecha contiene las categorías secundarias asignadas a esta entrada.',
    'Adds template tags to allow you to search for content from Google. You will need to configure this plugin using a <a href=\'http://www.google.com/apis/\'>license key.</a>' => 'Añade etiquetas de plantilla para buscar el contenido en Google. Deberá configurar esta extensión utilizando una <a href=\'http://www.google.com/apis/\'>clave de licencia</a>.',
    'Invalid priority level [_1] at add_callback' => 'Nivel de prioridad [_1] no válido en add_callback', # Translate - New (7)
    'Add Tags...' => 'Añadir etiquetas...',
    'This page contains a single entry from the blog posted on <strong>[_1]</strong>.' => 'Esta página contiene una sola entrada del blog publicada en <strong>[_1]</strong>.',
    '_THROTTLED_COMMENT_EMAIL' => 'Se bloqueó automáticamente a una persona que visitó su weblog [_1] debido a que insertó más comentarios de los permitidos en menos de [_2] segundos. Esto se hizo para impedir que nadie o nada desborde malintencionadamente  su weblog con comentarios. La dirección bloqueada es la siguiente:

    [_3]

Si esta operación no es correcta, puede desbloquear la dirección IP y permitir al visitante reanudar sus comentarios. Para ello, inicie una sesión en su instalación de Movable Type, vaya a Configuración del weblog - Bloqueo de direcciones IP y elimine la dirección IP [_4] de la lista de direcciones bloqueadas.',
    'Search Template' => 'Buscar plantilla', # Translate - New (2)
    'MONTHLY_ADV' => 'Mensualmente',
    'Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]' => 'El envío de mensajes a través de SMTP necesita que su servidor tenga Mail::Sendmail instalado: [_1]', # Translate - New (13)
    'It can be included onto your published blog using <a href="[_1]">WidgetManager</a> or this MTInclude tag' => 'Puede incluirse en su blog usando el <a href="[_1]">Administrador de Widgets</a> o esta etiqueta MTInclude',
    'Manage Tags' => 'Administrar etiquetas',
    '_SYSTEM_TEMPLATE_COMMENT_PREVIEW' => 'Mostrado cuando un comentarista revisa la vista previa de su comentario.',
    'Download file' => 'Descargar fichero', # Translate - New (2)
    '_USAGE_BOOKMARKLET_3' => 'Para instalar el marcador de QuickPost para Movable Type, arrastre el enlace siguiente al menú o barra de herramientas Favoritos de su navegador:',
    '_USAGE_PASSWORD_RESET' => 'Debajo puede reiniciar la recuperación de la contraseña en nombre de este usuario. Si lo hace, se generará una nueva contraseña aleatoria que se enviará directamente a su dirección de correo electrónico: [_1].',
    'File with name \'[_1]\' already exists. (Install File::Temp if you\'d like to be able to overwrite existing uploaded files.)' => 'Ya existe un fichero con el nombre \'[_1]\'. (Instale File::Temp si desea sobreescribir ficheros transferidos existentes).', # Translate - New (21)
    'DBI and DBD::SQLite2 are required if you want to use the SQLite2 database backend.' => 'DBI y DBD::SQLite2 son necesarios si desea usar  el gestor de base de datos SQLite2.', # Translate - New (15)
    'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'No tiene configurada una ruta válida a sendmail en su máquina. ¿Quizás está intentando usar SMTP?', # Translate - New (18)
    'Error loading default templates.' => 'Error cargando las plantillas predefinidas.', # Translate - New (4)
    '4th argument to add_callback must be a CODE reference.' => 'El cuarto argumento de add_callback debe ser una referencia de código.', # Translate - New (10)
    '_USAGE_LIST_POWER' => 'Ésta es la lista de entradas de [_1] en el modo de edición por lotes. En el formulario siguiente puede cambiar cualesquier valor de cualesquier entrada mostrada; una vez introducidas las modificaciones deseadas, presione el botón GUARDAR. Los controles estándar "Listar y editar entradas" (filtros, paginación) funcionan del modo acostumbrado.',
    'Or return to the <a href="[_1]">Main Menu</a> or <a href="[_2]">System Overview</a>.' => 'O regrese al <a href="[_1]">Menú principal</a> o al <a href="[_2]">Resumen del sistema</a>.',
    '_ERROR_CONFIG_FILE' => 'El fichero de configuración de Your Movable Type no existe o no se puede leer correctamente. Por favor, consulte la sección <a href="#">Instalación y configuración</a> del manual de Movable Type manual para más información.',
    '_WARNING_PASSWORD_RESET_SINGLE' => 'Va a reiniciar la contraseña de "[_1]". Se enviará una nueva contraseña aleatoria que se enviará directamente a su dirección de correo electrónico. ¿Desea continuar?',
    '_USAGE_PING_LIST_BLOG' => 'Aquí hay una lista de TrackBacks de [_1] que puede filtrar, administrar y editar.',
    'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.' => 'StyleCatcher le permite navegar fácilmente por los estilos y aplicarlos a su blog fácilmente. Para más información sobre los estilos de Movable Type, o para encontrar más repositorios de estilos, visite la página de <a href=\'http://www.sixapart.com/movabletype/styles\'>estilos de Movable Type</a>.',
    'Monthly' => 'Mensualmente',
    'Refreshing template \'[_1]\'.' => 'Refrescando la plantilla \'[_1]\'.',
    'If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the <code>import</code> folder of your Movable Type directory.' => 'Si el fichero a importar está situado en su ordenador, puede transferirlo aquí. En caso contrario, Movable Type buscará automáticamente en el directorio <code>import</code> de su instalación de Movable Type.',
    'Tags to add to selected entries' => 'Etiquetas a añadir en las entradas seleccionadas',
    'Ban Commenter(s)' => 'Bloquear comentarista/s',
    '_USAGE_VIEW_LOG' => 'Active la casilla <a href="#" onclick="doViewLog()">Registro de actividad</a> correspondiente a ese error.',
    'You must define an Individual template in order to display dynamic comments.' => 'Debe definir una plantilla individual para mostrar comentarios dinámicos.', # Translate - New (12)
    '_USAGE_BOOKMARKLET_1' => 'La configuración de QuickPost para poder realizar contribuciones en Movable Type permite insertar y publicar con un solo clic sin necesidad alguna de utilizar la interfaz principal de Movable Type.',
    '_USAGE_ARCHIVING_3' => 'Seleccione el tipo de archivado al que desea crear una nueva plantilla de archivado. A continuación, seleccione la plantilla a asociar a ese tipo de archivado.',
    '_SYSTEM_TEMPLATE_SEARCH_TEMPLATE' => 'Se muestra cuando un editor busca en el weblog',
    'UTC+10' => 'UTC+10', # Translate - Previous (2)
    'INDIVIDUAL_ADV' => 'Individualmente',
    'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Ignorando plantilla \'[_1]\' ya que parecer ser una plantilla personalizada.',
    'The above settings have been written to the file <tt>[_1]</tt>. If any of these settings are incorrect, you may click the \'Back\' button below to reconfigure them.' => 'La configuración de arriba se ha guardado en el fichero <tt>[_1]</tt>. Si cualquiera de estas opciones es incorrecta, puede hacer clic en el botón \'Regresar\' para reconfigurarla.',
    'You used an \'[_1]\' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an \'MTComments\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un comentario; ¿quizás la puso por error fuera de un contenedor \'MTComments\'?', # Translate - New (22)
    '_ERROR_CGI_PATH' => 'La opción de configuración CGIPath no es válida o no se encuentra en el fichero de configuración de Movable Type. Por favor, consulte la sección <a href="#">Instalación y configuración</a> del manual de Movable Type manual para más información.',
    'Assigning template build dynamic settings...' => 'Asignando opciones de construcción de plantillas dinámicas...', # Translate - New (5)
    '_SYSTEM_TEMPLATE_COMMENTS' => 'Mostrado cuando las ventanas emergentes de comentarios (obsoletas) están activadas.',
    '_USAGE_CATEGORIES' => 'Utilice categorías para agrupar sus entradas y así facilitar las referencias, el archivado y la navegación por su weblog. En el momento de crear o editar entradas, puede asignarles una categoría. Para editar una categoría anterior, haga clic en el título de la categoría. Para crear una subcategoría, haga clic en el botón "Crear" correspondiente. Para trasladar una subcategoría, haga clic en el botón "Trasladar" correspondiente.',
    'Updating author web services passwords...' => 'Actualizando contraseñas de servicios web...', # Translate - New (5)
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly context.' => 'Utilizó una etiqueta [_1] fuera de un contexto Diario, Semanal o Mensual.', # Translate - New (13)
    'Master Archive Index' => 'Archivo índice maestro',
    'Weekly' => 'Semanalmente',
    'Unpublish TrackBack(s)' => 'Despublicar TrackBack/s',
    'Many more can be found on the <a href="[_1]">main index page</a> or by looking through <a href="[_2]">the archives</a>.' => 'Puede encontrar más en la <a href="[_1]">página principal</a> o mirando a través de los <a href="[_2]">archivos</a>.',
    '_USAGE_PREFS' => 'Esta pantalla permite establecer un gran número de ajustes opcionales referentes a weblogs, archivos, comentarios, como también su configuración de publicidad y notificaciones. Al crear uno nuevo weblog, todos estos ajustes están predeterminados con valores razonables.',
    'You used an \'[_1]\' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an \'MTEntries\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de una entrada; ¿quizás la puso por error fuera de un contenedor \'MTEntries\'?', # Translate - New (22)
    'WEEKLY_ADV' => 'Semanalmente',
    'Processing templates for weblog \'[_1]\'' => 'Procesando plantillas del weblog \'[_1]\'', # Translate - New (5)
    '_SYSTEM_TEMPLATE_COMMENT_PENDING' => 'Mostrado cuando un comentario está moderado o marcado como basura.',
    'Unpublish Comment(s)' => 'Despublicar comentario/s',
    'The next post in this blog is <a href="[_1]">[_2]</a>.' => 'La siguiente entrada en este blog es <a href="[_1]">[_2]</a>.',
    'If you have a TypeKey identity, you can ' => 'Si tiene una identidad en TypeKey, puede ', # Translate - New (8)
    '_USAGE_ENTRY_LIST_OVERVIEW' => 'Lista de entradas de todos los weblogs que puede filtrar, administrar y editar',
    'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Formato de fecha \'[_1]\' no válido; debe ser \'MM/DD/AAAA HH:MM:SS AM|PM\' (AM|PM es opcional)', # Translate - New (16)
    'Please enter the parameters necessary for connecting to your database.If your database type is not listed in the dropdown below, you may be missing the Perl module necessary to connect to your database.  If this is the case, please check your installation and click <a href="?__mode=configure">here</a> to re-test your installation.' => 'Por favor, introduzca los parámetros necesarios para conectarse a la base de datos. Si el tipo de su base de datos no está listada en el menú desplegable de abajo, es posible que no tenga instalados los módulos de Perl necesarios para la conexión a su base de datos. Si este es el caso, por favor, haga clic <a href="?__mode=configure">aquí</a> para comprobar de nuevo su instalación.',
    'Drag and drop the widgets you want into the <strong>Installed</strong> column.' => 'Arrastre y suelte los widgets que desea en la columna <strong>Instalado</strong>.',
    'Manage Categories' => 'Administrar categorías',
    '_USAGE_ARCHIVING_2' => 'Si asocia múltiples plantillas a un determinado tipo de archivado (aunque asocie solamente una), puede personalizar la ruta de salida utilizando las plantillas de archivos.',
    'UTC+11' => 'UTC+11', # Translate - Previous (2)
    'View Activity Log For This Weblog' => 'Ver registro de actividad de este weblog',
    'Migrating any "tag" categories to new tags...' => 'Migrando cualquier categoría "tag" a nuevas etiquetas...', # Translate - New (7)
    'Refresh Template(s)' => 'Refrescar plantilla/s',
    'Assigning basename for categories...' => 'Asignando nombre base a las categorías...', # Translate - New (4)
    '_USAGE_NOTIFICATIONS' => 'A continuación se muestra la lista de usuarios que desean recibir una notificación cuando usted realice alguna nueva contribución en su sitio. Para crear un nuevo usuario, introduzca su dirección de correo electrónico en el formulario siguiente. El campo URL es opcional. Para eliminar un usuario, active la casilla Eliminar en la tabla siguiente y presione el botón ELIMINAR.',
    'Updating [_1] records...' => 'Actualizando [_1] registros...', # Translate - New (3)
    'File with name \'[_1]\' already exists; Tried to write to tempfile, but open failed: [_2]' => 'Ya existe un fichero con el nombre \'[_1]\'; se intentó escribir en un fichero temporal, pero hubo un error al abrirlo: [_2]', # Translate - New (15)
    '_USAGE_COMMENTERS_LIST' => 'Ésta es la lista de comentaristas de [_1].',
    '_ERROR_DATABASE_CONNECTION' => 'Las opciones de configuración de su base de datos o son incorrectas o no están presentes en el fichero de configuración de Movable Type. Por favor, consulte la sección <a href="#">Instalación y configuración</a> del manual de Movable Type para más información',
    '_USAGE_BANLIST' => 'Debajo aparece la lista de direcciones IP a las que ha prohibido insertar comentarios o enviar pings de TrackBack a su sitio. Para crear una nueva dirección IP, introduzca la dirección en el formulario siguiente. Para borrar una dirección IP bloqueada, active la casilla Eliminar en la tabla siguiente y presione el botón ELIMINAR.',
    'RSS 2.0 Index' => 'Índice RSS 2.0',
    '_USAGE_FEEDBACK_PREFS' => 'Esta pantalla le permite configurar la forma en que sus lectores pueden contribuir en su blog.',
    '_USAGE_AUTHORS' => 'Ésta es la lista de todos los usuarios registrados en el sistema de Movable Type. Puede editar los permisos de un autor haciendo clic en su nombre; para eliminar permanentemente varios autores, active las casillas <b>Eliminar</b> correspondientes y presione ELIMINAR. NOTA: Si solamente desea desasignar un autor de un weblog determinado, edite los permisos del autor; el borrado de un autor mediante ELIMINAR lo elimina completamente del sistema.',
    '_INDEX_INTRO' => '<p>Si está instalando Movable Type, quizás desee consultar las <a href="http://www.sixapart.com/movabletype/docs/mtinstall.html">instrucciones de instalación</a> y ver la <a rel="nofollow" href="mt-check.cgi">comprobación del sistema de Movable Type</a> para asegurarse de que su sistema tiene todo lo necesario.</p>',
    'Configure Weblog' => 'Configurar weblog',
    'Select a Design using StyleCatcher' => 'Seleccione un estilo usando StyleCatcher',
    '<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> es el archivo anterior.',
    '_USAGE_NEW_AUTHOR' => 'Desde esta pantalla puede crear un nuevo autor en el sistema y darle acceso a weblogs individualmente.',
    'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides.' => 'Los siguientes módulos son <strong>opcionales</strong>. Si su servidor no tiene estos módulos instalados, solo tendrá que instalarlos para aprovechar la funcionalidad que provee cada módulo.',
    '_USAGE_FORGOT_PASSWORD_1' => 'Solicitó la recuperación de su contraseña de Movable Type. Su contraseña se ha modificado en el sistema; ésta es su nueva contraseña:',
    '_USAGE_COMMENTS_LIST_OVERVIEW' => 'Aquí tiene una lista de los comentarios de todos los weblogs que puede filtrar, administrar y editar',
    'You need to provide a password if you are going to\ncreate new authors for each author listed in your blog.\n' => 'Debe proveer una contraseña si va a\ncrear nuevos autores para cada uno de los listados en el blog.\n', # Translate - New (22)
    '_SYSTEM_TEMPLATE_POPUP_IMAGE' => 'Mostrado cuando un visitante hace clic en la ventana emergente de una imagen.',
    '_USAGE_EXPORT_2' => 'Para exportar sus entradas, haga clic en el enlace que aparece debajo ("Exportar entradas desde [_1]"). Para guardar los datos exportados en un fichero, mantenga presionada la tecla <code>opción</code> del Macintosh (o la tecla <code>Mayús</code> si trabaja con un PC) y haga clic en el enlace. También puede seleccionar todos los datos y luego copiarlos en otro documento. (<a href="#" onclick="openManual(\'importing\', \'export_ie\');return false;">¿Exportando desde Internet Explorer?</a>)',
    '_USAGE_PING_LIST_ALL_WEBLOGS' => 'Ésta es la lista de pings de todos los weblogs.',
    'Manage my Widgets' => 'Administrar widgets',
    'Updating blog comment email requirements...' => 'Actualizando los requerimientos del correo de los comentarios...', # Translate - New (5)
    'Assigning junk status for TrackBacks...' => 'Asignando estado de \'basura\' a los TrackBacks...', # Translate - New (5)
    'Publish Entries' => 'Publicar entradas',
    'No executable code' => 'No es código ejecutable', # Translate - New (3)
    '_USAGE_PING_LIST_OVERVIEW' => 'Aquí tiene una lista de los TrackBacks de todos los weblogs que puede filtrar, administrar y editar',
    'AUTO DETECT' => 'AUTO DETECTAR',
    '<em><strong>Please Note:</strong> The Movable Type export format is not comprehensive and is not suitable for creating full-fidelity backups. Please see the Movable Type manual for full details.</em>' => '<em><strong>Por favor, tenga en cuenta:</strong> El formato de exportación de Movable Type no es completo, y no se recomienda usarlo para crear copias de seguridad de total fidelidad. Por favor, consulte el manual de Movable Type para más detalles sobre este asunto.</em>',
    'Install <a href=\'http://greasemonkey.mozdev.org/\'>GreaseMonkey</a>' => 'Instalar <a href=\'http://greasemonkey.mozdev.org/\'>GreaseMonkey</a>',
    '_USAGE_PLUGINS' => 'Lista de todas las extensiones actualmente registradas en Movable Type.',
    '_USAGE_PERMISSIONS_2' => 'Para editar los permisos de otro usuario, selecciónelo en el menú desplegable y presione EDITAR.',
    'Insufficient permissions for modifying templates for this weblog.' => 'Permisos insuficientes para modificar las plantillas de este weblog.', # Translate - New (8)
    'Bad ObjectDriver config: [_1] ' => 'Configuración de ObjectDriver incorrecta: [_1] ', # Translate - New (4)
    'Untrust Commenter(s)' => 'Desconfiar de comentarista/s',
    '_USAGE_PROFILE' => 'Edite aquí su perfil de autor. Si cambia su nombre de usuario o su contraseña, sus credenciales de inicio de sesión se actualizarán automáticamente. En otras palabras, no necesitará volver a iniciar su sesión.',
    'Congratulations! A template module Widget named <strong>[_1]</strong> has been created which you can further <a href="[_2]">edit</a> to customize its display.' => '¡Felicidades! Se ha creado un módulo de plantilla de widget de nombre <strong>[_1]</strong>. Puede <a href="[_2]">editarlo</a> para personalizar sus opciones.',
    'Category' => 'Categoría',
    '_USAGE_ENTRYPREFS' => 'La configuración de campos determina qué campos aparecerán en las pantallas de entrada nueva y edición. Puede elegir una configuración existente (básica o avanzada) o personalizar las pantallas haciendo clic en Personalizada para elegir los campos que desee que aparezcan.',
    'To download more plugins, check out the <a href="http://www.sixapart.com/pronet/plugins/">Six Apart Plugin Directory</a>.' => 'Para descargar más extensiones consulte el <a href="http://www.sixapart.com/pronet/plugins/">Directorio de \'plugins\' de Six Apart</a>.',
    'Assigning custom dynamic template settings...' => 'Asignando opciones de plantillas dinámicas personalizadas...', # Translate - New (5)
    'Updating comment status flags...' => 'Actualizando estados de comentarios...', # Translate - New (4)
    'Stylesheet' => 'Hoja de estilo',
    'RSD' => 'RSD', # Translate - Previous (1)
    '_USAGE_ARCHIVE_MAPS' => 'Esta funcionalidad avanzada le permite mapear cualquier plantilla de archivos a múltiples tipos de archivos. Por ejemplo, podría crear dos vistas diferentes para sus archivos mensuales: una en la que las entradas de un mes particular se presentan como una lista y la otra en la que se representan las entradas en el calendario de ese mes.',
    'You used an \'[_1]\' tag outside of the context of a ping; perhaps you mistakenly placed it outside of an \'MTPings\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un ping; ¿quizás la situó por error fuera de un contenedor \'MTPings\'?', # Translate - New (22)
    '_THROTTLED_COMMENT' => 'En un esfuerzo por impedir la inserción de comentarios maliciosos por parte usuarios malévolos, se ha habilitado una función que obliga al comentarista del weblog esperar un tiempo determinado antes de poder realizar un nuevo comentario. Por favor, vuelva a insertar su comentario dentro de unos momentos. Gracias por su comprensión.',
    'Trust Commenter(s)' => 'Confiar en comentarista/s',
    '_USAGE_SEARCH' => 'Puede utilizar la herramienta de búsqueda y reemplazo Buscar &amp; Reemplazar para realizar búsquedas en todas sus entradas, o bien para reemplazar cada ocurrencia de una palabra/frase/carácter por otro. IMPORTANTE: Ponga mucha atención al ejecutar un reemplazo, porque es una operación <b>irreversible</b>. Si va a efectuar un reemplazo masivo (es decir, en muchas entradas), es recomendable utilizar primero la función de exportación para hacer una copia de seguridad de sus entradas.',
    'Manage Templates' => 'Administrar plantillas',
    '_USAGE_PERMISSIONS_1' => 'Está editando los permisos de <b>[_1]</b>. Más abajo verá la lista de weblogs a los que tiene acceso como autor con permisos de edición; por cada weblog de la lista, asigne permisos a <b>[_1]</b>, activando las casillas correspondientes de los permisos de acceso que desea otorgar.',
    '_USAGE_BOOKMARKLET_2' => 'QuickPost para Movable Type permite personalizar el diseño y los campos de la página de QuickPost. Por ejemplo, puede incluir la posibilidad de crear extractos a través de la ventana de QuickPost. De forma predeterminada, una ventana de QuickPost tendrá siempre: un menú desplegable correspondiente al weblog en el que se va a publicar, un menú desplegable para seleccionar el estado de publicación de la nueva entrada (Borrador o Publicar), un cuadro de texto para introducir el título de la entrada y un cuadro de texto para introducir el cuerpo de la entrada.',
    '_external_link_target' => '_top',
    '_AUTO' => '1',
    'Creating entry category placements...' => 'Creando situaciones de categorías de entradas...', # Translate - New (4)
    'Add/Manage Categories' => 'Añadir/Administrar categorías',
    'Setting new entry defaults for weblogs...' => 'Estableciendo valores predefinidos de las entradas en los weblogs...', # Translate - New (6)
    'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Publicado <MTIfNonEmpty tag="EntryAuthorDisplayName">por [_1] </MTIfNonEmpty>en [_2]', # Translate - New (9)
    'Updating entry week numbers...' => 'Actualizando números de semana de entradas...', # Translate - New (4)
    'Recover Password(s)' => 'Recuperar contraseña/s',
    '_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.org/sitees/">Movable Type <$MTVersion$></a>',
    'Assigning comment/moderation settings...' => 'Asignando opciones de comentarios/moderación...', # Translate - New (4)
    'This page contains all entries posted to [_1] in <strong>[_2]</strong>. They are listed from oldest to newest.' => 'Esta página contiene todas las entradas publicadas en [_1] en <strong>[_2]</strong>. Están listadas de más antiguas a más recientes.',
    '_USAGE_ARCHIVING_1' => 'Seleccione la periodicidad y los tipos de archivado que desee realizar en su sitio. Por cada tipo de archivado que elija, tendrá la opción de asignar múltiples plantillas de archivado, que se aplicarán a ese tipo en particular. Por ejemplo, puede crear dos vistas diferentes de sus archivos mensuales: una consistente en una página que contenga cada una de las entradas de un determinado mes y la otra consistente en una vista de calendario de ese mes.',
    '<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> es la siguiente categoría.',
    '_USAGE_PERMISSIONS_4' => 'Cada weblog puede tener múltiples autores. Para crear un autor, introduzca la información del usuario en el siguiente formulario. A continuación, seleccione los weblogs en los que tendrá algún tipo de privilegio como autor. Cuando presione GUARDAR y el usuario esté registrado en el sistema, podrá editar sus privilegios de autor.',
    'Error creating temporary file; please check your TempDir setting in mt.cfg (currently \'[_1]\') this location should be writable.' => 'Error creando fichero temporal; por favor, compruebe que el valor de TempDir en mt.cfg (actualmente \'[_1]\'), se debe tener permisos de escritura en esta ruta.', # Translate - New (19)
    '_USAGE_TAGS' => 'Utilice las etiquetas para agrupar las entradas.',
    '_USAGE_BOOKMARKLET_5' => 'Alternativamente, si está ejecutando Internet Explorer bajo Windows, puede instalar una opción "QuickPost" en el menú contextual de Windows. Haga clic en el enlace siguiente y acepte la petición del navegador de "Abrir" el fichero. A continuación, cierre y vuelva a abrir su navegador para crear el enlace al menú contextual.',
    '_USAGE_IMPORT' => 'Utilice el mecanismo de importación para importar entradas de otro sistema de weblogs, como Blogger o Greymatter. Este manual proporciona instrucciones exhaustivas para la importación de entradas antiguas mediante este mecanismo; el formulario siguiente permite importar un lote de entradas después de que las haya exportado del otro CMS y haya colocado los ficheros exportados en el lugar correcto para que Movable Type los pueda encontrar. Antes de usar este formulario, consulte el manual para asegurarse de haber comprendido todas las opciones.',
    'Main Index' => 'Índice principal',
    'Assigning category parent fields...' => 'Asignando campos de ancentros en las categorías...', # Translate - New (4)
    '_USAGE_ENTRY_LIST_BLOG' => 'Aquí hay una lista de entradas de [_1] que puede filtrar, administrar y editar',
    'Movable Type ships with directory named <strong>mt-static</strong> which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type contiene un directorio llamado <strong>mt-static</strong> que contiene un serie importante de ficheros como imágenes, ficheros javascript y hojas de estilo.', # Translate - New (23)
    '<p>You must define a global theme repository where themes can be stored locally.  If a particular blog has not been configured for it\'s own theme paths, it will use these settings directly. If a blog has it\'s own theme paths, then the theme will be copied to that location when applied to that weblog. The paths defined here must physically exist and be writable by the webserver.</p>' => '<p>Debe definir un repositorio global de estilos donde se puedan guardar localmente. Si un blog no ha sido configurado para guardar los temas en su propia ruta, usará esta configuración. Si un blog tiene su propia ruta para los temas, entonces al aplicar el tema al weblog, ésta se copiará a dicha ruta. Las rutas definidas aquí deben existir físicamente y el servidor web debe poder escribir en ellas.</p>',
    '_USAGE_EXPORT_3' => 'Haciendo clic en el enlace siguiente exportará todas las entradas actuales del weblog al servidor Tangent. Generalmente, este proceso se realiza una sola vez y de una pasada, después de instalar la extensión de Tangent para Movable Type, pero teóricamente podría ejecutarse siempre que sea necesario.',
    'Setting blog allow pings status...' => 'Estableciendo el estado de recepción de pings en los blogs...', # Translate - New (5)
    'Send Notifications' => 'Enviar notificaciones',
    '_SYSTEM_TEMPLATE_COMMENT_ERROR' => 'Mostrado cuando un comentario no puede validarse.',
    'Edit All Entries' => 'Editar todas las entradas',
    'Rebuild Files' => 'Reconstruir ficheros',

    ## Error messages, strings in the app code.

    ## ./mt-check.cgi.pre
    'CGI is required for all Movable Type application functionality.' => 'CGI es necesario para una completa funcionalidad de Movable Type.',
    'HTML::Template is required for all Movable Type application functionality.' => 'HTML::Template es necesario para que Movable Type funcione.',
    'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size es necesario para la transferencia de ficheros (para determinar el tamaño de las imágenes en cualquiera de los diferentes formatos).',
    'File::Spec is required for path manipulation across operating systems.' => 'File::Spec es necesario para la manipulación de rutas entre diferentes sistemas operativos.',
    'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie es necesario para la autentificación con cookies.',
    'DB_File is required if you want to use the Berkeley DB/DB_File backend.' => 'DB_File es necesario si desea usar el motor de Berkeley DB/DB_File.',
    'DBI is required if you want to use any of the SQL database drivers.' => 'DBI es necesario si desea usar cualquiera de los controladores de base de datos SQL.',
    'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI y DBD::mysql son necesarios si desea usar el gestor de base de datos MySQL.',
    'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI y DBD::Pg son necesarios si desea usar el gestor de base de datos de PostgreSQL.',
    'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI y DBD::SQLite son necesarios si desea usar el gestor de base de datos SQLite.',
    'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI y DBD::SQLite2 son necesarios si desea usar el gestor de base de datos SQLite 2.x.',
    'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in mt.cfg.' => 'HTML::Entities es necesario para codificar algunos caracteres, pero esta característica se puede desactivar usando la opción NoHTMLEntities en mt.cfg.',
    'LWP::UserAgent is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'LWP::UserAgent es opcional; es necesario si desea usar el sistema de TrackBack, las notificaciones a weblogs.com o a las Últimas actualizaciones de MT.',
    'SOAP::Lite is optional; It is needed if you wish to use the MT XML-RPC server implementation.' => 'SOAP::Lite es opcional; es necesario si desea usar la implementación del servidor XML-RPC de MT.',
    'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Temp es opcional; es necesario si desea ser capaz de sobreescribir ficheros existentes al transferir imágenes.',
    'Image::Magick is optional; It is needed if you would like to be able to create thumbnails of uploaded images.' => 'Image::Magick es opcional; se necesita si desea crear miniaturas de las imágenes transferidas.',
    'Storable is optional; it is required by certain MT plugins available from third parties.' => 'Storable es opcional; lo requieren varios módulos de Movable Type realizados por otros fabricantes.',
    'Crypt::DSA is optional; if it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSA es opcional; si está instalado, se acelerará el registro de comentarios.',
    'MIME::Base64 is required in order to enable comment registration.' => 'MIME::Base64 es necesario para habilitar el registro de comentarios.',
    'XML::Atom is required in order to use the Atom API.' => 'XML::Atom es necesario para usar el Atom API.',
    'Data Storage' => 'Almacenamiento',
    'Required' => 'Obligatorio',
    'Optional' => 'Opcional',

    ## ./extras/examples/plugins/mirror/lib/Mirror.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample.pm
    'This is localized in perl module' => 'Este es un módulo de perl traducido',

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N/ja.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N/en_us.pm

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Lite.pm
    'An error occurred processing [_1]. ' => 'Ocurrió un error procesando [_1]. ',

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Find.pm

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Lite/CacheMgr.pm

    ## ./plugins/feeds-app-lite/lib/MT/App/FeedsWidget.pm

    ## ./plugins/spamlookup/lib/spamlookup.pm
    'Failed to resolve IP address for source URL [_1]' => 'No se pudo resolver la dirección IP de la URL [_1]',
    'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Moderando: El dominio de la IP no coincide con la IP del ping de la URL [_1]; dominio de la IP: [_2]; IP del ping: [_3]',
    'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'El dominio de la IP no coincide con la IP del ping de la URL [_1]; Dominio de la IP: [_2]; IP del ping: [_3]',
    'No links are present in feedback' => 'No hay enlaces presentes',
    'Number of links exceed junk limit ([_1])' => 'El número de enlaces excedió el límite de la basura ([_1])',
    'Number of links exceed moderation limit ([_1])' => 'El número de enlaces excedió el límite de la moderación ([_1])',
    'Link was previously published (comment id [_1]).' => 'El enlace fue publicado anteriormente (id del comentario [_1]).',
    'Link was previously published (TrackBack id [_1]).' => 'El enlace fue publicado anteriormente (id del TrackBack [_1]).',
    'E-mail was previously published (comment id [_1]).' => 'El correo electrónico fue publicado anteriormente (id del comentario [_1]).',
    'Word Filter match on \'[_1]\': \'[_2]\'.' => 'Filtro de palabras coincidió en \'[_1]\': \'[_2]\'.',
    'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'Moderando por filtros de palabras, coincidió en \'[_1]\': \'[_2]\'.',
    'domain \'[_1]\' found on service [_2]' => 'dominio \'[_1]\' encontrado en servicio [_2]',
    '[_1] found on service [_2]' => '[_1] encontrado en servicio [_2]',

    ## ./plugins/spamlookup/lib/spamlookup/L10N.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/es.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/nl.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/ja.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/de.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/en_us.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/fr.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher.pm
    'StyleCatcher must first be configured system-wide before it can be used.' => 'Debe configurar StyleCatcher para todo el sistema antes de usarlo.',
    'Configure plugin' => 'Configurar extensión',
    'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'No se pudo crear el directorio [_1] - Compruebe que el servidor web puede escribir en la carpeta \'themes\'.',
    'Successfully applied new theme selection.' => 'Se aplicó con éxito la nueva selección de estilo.',

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/es.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/nl.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/ja.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/de.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/en_us.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/fr.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/Plugin.pm
    'Can\'t find included template module \'[_1]\'' => 'No se encontró el módulo de plantilla incluido \'[_1]\'',

    ## ./plugins/WidgetManager/lib/WidgetManager/Util.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/App.pm
    'Loading template \'[_1]\' failed: [_2]' => 'Fallo cargando plantilla \'[_1]\': [_2]',
    'Permission denied.' => 'Permiso denegado.',
    'Can\'t duplicate the existing \'[_1]\' Widget Manager. Please go back and enter a unique name.' => 'No se pudo duplicar el administrador de widgets existente \'[_1]\'. Por favor, regrese e introduzca un nombre único.',
    'Moving [_1] to list of installed modules' => 'Moviendo [_1] para listar los módulos instalados',
    'Error opening file \'[_1]\': [_2]' => 'Error abriendo el fichero \'[_1]\': [_2]',
    'First Widget Manager' => 'Primer Administrador de Widgets',

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/es.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/nl.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/ja.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/de.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/en_us.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/fr.pm

    ## ./mt-static/mt.js
    'You did not select any [_1] to delete.' => 'No seleccionó ningún [_1] para borrar.',
    'Deleting an author is an irrevocable action which creates orphans of the author\'s entries.  If you wish to retire an author or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete this author?' => 'El borrado de un autor es una acción irreversible que crea huérfanos con las entradas del autor. Si desea retirar un autor o eliminar su acceso del sistema, la acción recomendada es borrar todos sus permisos. ¿Está seguro que desea borrar este autor?',
    'Deleting an author is an irrevocable action which creates orphans of the author\'s entries.  If you wish to retire an author or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete the [_1] selected authors?' => 'El borrado de un autor es una acción irreversible que crea huérfanos en las entradas del autor. Si desea retirar un autor o eliminar su acceso del sistema, la acción recomendada es borrar todos sus permisos. ¿Está seguro de que desea borrar los [_1] autores seleccionados?',
    'Are you sure you want to delete this [_1]?' => '¿Está seguro de que desea borrar este [_1]?',
    'Are you sure you want to delete the [_1] selected [_2]?' => '¿Está seguro de que desea borrar el [_1] seleccionado [_2]?',
    'to delete' => 'para borrar',
    'You did not select any [_1] [_2].' => 'No seleccionó ningún [_1] [_2].',
    'You must select an action.' => 'Debe seleccionar una acción.',
    'to mark as junk' => 'para marcar como basura',
    'to remove "junk" status' => 'para eliminar el estado "basura"',
    'Enter email address:' => 'Teclee la dirección de correo-e:',
    'Enter URL:' => 'Teclee la URL:',

    ## ./lib/MT.pm
    'Message: [_1]' => 'Mensaje: [_1]',
    'Unnamed plugin' => 'Extensión sin nombre',
    '[_1] died with: [_2]' => '[_1] murió con: [_2]',
    'Plugin error: [_1] [_2]' => 'Error en extensión: [_1] [_2]',

    ## ./lib/MT/Comment.pm
    'Load of entry \'[_1]\' failed: [_2]' => 'Fallo al cargar la entrada \'[_1]\': [_2]',
    'Load of blog \'[_1]\' failed: [_2]' => 'La carga del blog \'[_1]\' falló: [_2]',

    ## ./lib/MT/Author.pm
    'Can\'t approve/ban non-COMMENTER author' => 'No se puede aprobar/bloquear un autor que no es comentarista',
    'The approval could not be committed: [_1]' => 'La aprobación no pudo realizarse: [_1]',

    ## ./lib/MT/TemplateMap.pm

    ## ./lib/MT/Bootstrap.pm
    'Got an error: [_1]' => 'Ocurrió un error en: [_1]',

    ## ./lib/MT/Callback.pm

    ## ./lib/MT/Serialize.pm

    ## ./lib/MT/Permission.pm

    ## ./lib/MT/WeblogPublisher.pm
    'Archive type \'[_1]\' is not a chosen archive type' => 'El tipo de archivos \'[_1]\' no es un tipo de archivos seleccionado',
    'Parameter \'[_1]\' is required' => 'El parámetro \'[_1]\' es necesario',
    'Building category archives, but no category provided.' => 'Reconstruyendo archivos de categorías, pero no se indicó ninguna categoría.',
    'You did not set your Local Archive Path' => 'No indicó su ruta local de archivos',
    'Building category \'[_1]\' failed: [_2]' => 'Fallo reconstruyendo categoría \'[_1]\': [_2]',
    'Building entry \'[_1]\' failed: [_2]' => 'Fallo reconstruyendo entrada \'[_1]\': [_2]',
    'Building date-based archive \'[_1]\' failed: [_2]' => 'Fallo reconstruyendo archivo de fechas \'[_1]\': [_2]',
    'You did not set your Local Site Path' => 'No indicó su ruta local de archivos',
    'Template \'[_1]\' does not have an Output File.' => 'La plantilla \'[_1]\' no tiene un fichero de salida.',
    'An error occurred while rebuilding to publish scheduled posts: [_1]' => 'Ocurrió un error durante el proceso de reconstrucción para publicar las entradas programadas: [_1]',

    ## ./lib/MT/Session.pm

    ## ./lib/MT/Sanitize.pm

    ## ./lib/MT/TaskMgr.pm
    'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'No fue posible asegurar el bloqueo para la ejecución de tareas del sistema. Asegúrese de que se puede escribir en el directorio TempDir ([_1]).',
    'Error during task \'[_1]\': [_2]' => 'Error durante la tarea \'[_1]\': [_2]',
    'Scheduled Tasks Update' => 'Actualización de tareas programadas',
    'The following tasks were run:' => 'Se ejecutaron las siguientes tareas:',

    ## ./lib/MT/IPBanList.pm

    ## ./lib/MT/FileMgr.pm

    ## ./lib/MT/Category.pm
    'Categories must exist within the same blog' => 'Las categorías deben existir en el mismo blog',
    'Category loop detected' => 'Bucle de categorías detectado',

    ## ./lib/MT/ErrorHandler.pm

    ## ./lib/MT/ObjectDriver.pm

    ## ./lib/MT/Object.pm
    '4th argument to add_callback must be a perl CODE reference' => 'cuarto argumento de add_callback debe ser una referencia a código perl',

    ## ./lib/MT/Upgrade.pm
    'Invalid upgrade function: [_1].' => 'Función de actualización no válida: [_1].',
    'Error loading class: [_1].' => 'Error cargando la clase: [_1].',
    'Creating initial weblog and author records...' => 'Creando registros iniciales de weblogs y autores...',
    'Error saving record: [_1].' => 'Error guardando el registro: [_1].',
    'First Weblog' => 'Primer weblog',
    'Can\'t find default template list; where is \'default-templates.pl\'? Error: [_1]' => 'No puedo encontrar la lista de plantillas predefinidas; ¿dónde está \'default-templates.pl\'? Error: [_1]',
    'Creating new template: \'[_1]\'.' => 'Creando nueva plantilla: \'[_1]\'.',
    'Mapping templates to blog archive types...' => 'Mapeando plantillas con tipos de archivo de blogs...',
    'Upgrading table for [_1]' => 'Actualizando tabla para [_1]',
    'Upgrading database from version [_1].' => 'Actualizando base de datos desde la versión [_1].',
    'Database has been upgraded to version [_1].' => 'Se actualizó la base de datos a la versión [_1].',
    'Plugin \'[_1]\' upgraded successfully.' => 'La extensión \'[_1]\' se actualizó correctamente.',
    'Plugin \'[_1]\' installed successfully.' => 'La extensión \'[_1]\' se actualizó correctamente.',
    'Setting your permissions to administrator.' => 'Estableciendo permisos de administrador.',
    'Creating configuration record.' => 'Creando registro de configuración.',
    'Creating template maps...' => 'Creando mapas de plantillas...',
    'Mapping template ID [_1] to [_2] ([_3]).' => 'Mapeando ID plantilla [_1] a [_2] ([_3]).',
    'Mapping template ID [_1] to [_2].' => 'Mapeando ID plantilla [_1] a [_2].',

    ## ./lib/MT/PluginData.pm

    ## ./lib/MT/Template.pm
    'Parse error in template \'[_1]\': [_2]' => 'Error de interpretación en la plantilla \'[_1]\': [_2]',
    'Build error in template \'[_1]\': [_2]' => 'Error de reconstrucción en la plantilla \'[_1]\': [_2]',
    'You cannot use a [_1] extension for a linked file.' => 'No puede usar una extensión [_1] para un fichero enlazado.',
    'Opening linked file \'[_1]\' failed: [_2]' => 'Fallo abriendo fichero enlazado\'[_1]\': [_2]',

    ## ./lib/MT/L10N.pm

    ## ./lib/MT/Image.pm
    'Can\'t load Image::Magick: [_1]' => 'No se pudo cargar Image::Magick: [_1]',
    'Reading file \'[_1]\' failed: [_2]' => 'Fallo leyendo archivo \'[_1]\': [_2]',
    'Reading image failed: [_1]' => 'Fallo leyendo imagen: [_1]',
    'Scaling to [_1]x[_2] failed: [_3]' => 'El escalado a [_1]x[_2] falló: [_3]',
    'Can\'t load IPC::Run: [_1]' => 'No se pudo cargar IPC::Run: [_1]',
    'You do not have a valid path to the NetPBM tools on your machine.' => 'No posee una ruta válida a las herramientas NetPBMYou en su máquina.',

    ## ./lib/MT/ObjectTag.pm

    ## ./lib/MT/Plugin.pm

    ## ./lib/MT/Task.pm

    ## ./lib/MT/Config.pm

    ## ./lib/MT/FileInfo.pm

    ## ./lib/MT/Blocklist.pm

    ## ./lib/MT/Trackback.pm

    ## ./lib/MT/BasicSession.pm

    ## ./lib/MT/Notification.pm

    ## ./lib/MT/JunkFilter.pm
    'Action: Junked (score below threshold)' => 'Acción: Basura (puntuación bajo nivel)',
    'Action: Published (default action)' => 'Acción: Publicado (acción predefinida)',
    'Junk Filter [_1] died with: [_2]' => 'Filtro basura [_1] murió con: [_2]',
    'Unnamed Junk Filter' => 'Filtro basura sin nombre',
    'Composite score: [_1]' => 'Puntuación compuesta: [_1]',

    ## ./lib/MT/Builder.pm
    '&lt;MT[_1]> with no &lt;/MT[_1]>' => '&lt;MT[_1]> sin &lt;/MT[_1]>',
    'Error in &lt;MT[_1]> tag: [_2]' => 'Error en &lt;MT[_1]> etiqueta: [_2]',

    ## ./lib/MT/Request.pm

    ## ./lib/MT/BasicAuthor.pm

    ## ./lib/MT/Blog.pm

    ## ./lib/MT/DateTime.pm

    ## ./lib/MT/TBPing.pm

    ## ./lib/MT/DefaultTemplates.pm

    ## ./lib/MT/Util.pm
    'Less than 1 minute from now' => 'Dentro de menos de un minuto',
    'Less than 1 minute ago' => 'Hace menos de un minuto',
    '[quant,_1,hour], [quant,_2,minute] from now' => '[quant,_1,hora], [quant,_2,minuto] desde ahora',
    '[quant,_1,hour], [quant,_2,minute] ago' => 'Hace [quant,_1,hora], [quant,_2,minuto]',
    '[quant,_1,hour] from now' => 'Dentro de [quant,_1,hora]',
    '[quant,_1,hour] ago' => 'Hace [quant,_1,hora]',
    '[quant,_1,minute] from now' => 'Dentro de [quant,_1,minuto]',
    '[quant,_1,minute] ago' => 'Hace [quant,_1,minuto]',
    '[quant,_1,day], [quant,_2,hour] from now' => 'Dentro de [quant,_1,día], [quant,_2,hora]',
    '[quant,_1,day], [quant,_2,hour] ago' => 'Hace [quant,_1,día], [quant,_2,hora]',
    '[quant,_1,day] from now' => 'Dentro de [quant,_1,día]',
    '[quant,_1,day] ago' => 'Hace [quant,_1,día]',
    'Invalid Archive Type setting \'[_1]\'' => 'Configuración no válida de tipo de archivos \'[_1]\'',

    ## ./lib/MT/Placement.pm

    ## ./lib/MT/Tag.pm
    'Tag must have a valid name' => 'La etiqueta debe tener un nombre válido',
    'This tag is referenced by others.' => 'Esta etiqueta está referenciada por otros.',

    ## ./lib/MT/Promise.pm

    ## ./lib/MT/XMLRPC.pm
    'No WeblogsPingURL defined in mt.cfg' => 'WeblogsPingURL no definido en mt.cfg',
    'No MTPingURL defined in mt.cfg' => 'MTPingURL no definido en mt.cfg',
    'HTTP error: [_1]' => 'Error HTTP: [_1]',
    'Ping error: [_1]' => 'Error de ping: [_1]',

    ## ./lib/MT/AtomServer.pm
    'PreSave failed [_1]' => 'Fallo en \'PreSave\' [_1]',
    'User \'[_1]\' (user #[_2]) added entry #[_3]' => 'El usuario \'[_1]\' (usuario nº [_2]) añadió la entrada nº[_3]',

    ## ./lib/MT/Entry.pm
    'Load of blog failed: [_1]' => 'Fallo en la carga del blog: [_1]',

    ## ./lib/MT/ImportExport.pm
    'No Stream' => 'Sin flujo',
    'No Blog' => 'Sin Blog',
    'Can\'t rewind' => 'No se pudo reiniciar',
    'Can\'t open \'[_1]\': [_2]' => 'No se pudo abrir \'[_1]\': [_2]',
    'Can\'t open directory \'[_1]\': [_2]' => 'No se puede abrir el directorio \'[_1]\': [_2]',
    'No readable files could be found in your import directory [_1].' => 'No se encontrón ningún fichero legible en su directorio de importación [_1].',
    'Importing entries from file \'[_1]\'' => 'Importando entradas desde el fichero \'[_1]\'',
    'You need to provide a password if you are going to\n' => 'Debe proveer una contraseña si va a\n',
    'Need either ImportAs or ParentAuthor' => 'Necesita ImportAs o ParentAuthor',
    'Creating new author (\'[_1]\')...' => 'Creando autor (\'[_1]\')...',
    'ok\n' => 'ok\n', # Translate - Previous (2)
    'failed\n' => 'falló\n',
    'Saving author failed: [_1]' => 'Fallo guardando autor: [_1]',
    'Assigning permissions for new author...' => 'Asignar permisos al nuevo autor...',
    'Saving permission failed: [_1]' => 'Fallo guardando permisos: [_1]',
    'Creating new category (\'[_1]\')...' => 'Creando nueva categoría (\'[_1]\')...',
    'Saving category failed: [_1]' => 'Fallo guardando categoría: [_1]',
    'Invalid status value \'[_1]\'' => 'Valor de estado no válido \'[_1]\'',
    'Invalid allow pings value \'[_1]\'' => 'Valor no válido de permiso de pings \'[_1]\'',
    'Can\'t find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.\n' => 'No se encontró una entrada existente con la fecha \'[_1]\'... dejando comentarios, y continuando con la siguiente entrada.\n',
    'Importing into existing entry [_1] (\'[_2]\')\n' => 'Importando en la entrada existente [_1] (\'[_2]\')\n',
    'Saving entry (\'[_1]\')...' => 'Guardando entrada (\'[_1]\')...',
    'ok (ID [_1])\n' => 'ok (ID [_1])\n', # Translate - Previous (4)
    'Saving entry failed: [_1]' => 'Fallo guardando entrada: [_1]',
    'Saving placement failed: [_1]' => 'Fallo guardando situación: [_1]',
    'Creating new comment (from \'[_1]\')...' => 'Creando nuevo comentario (de \'[_1]\')...',
    'Saving comment failed: [_1]' => 'Fallo guardando comentario: [_1]',
    'Entry has no MT::Trackback object!' => '¡La entrada no tiene objeto MT::Trackback!',
    'Creating new ping (\'[_1]\')...' => 'Creando nuevo ping (\'[_1]\')...',
    'Saving ping failed: [_1]' => 'Fallo guardando ping: [_1]',
    'Export failed on entry \'[_1]\': [_2]' => 'Fallo de exportación en la entrada \'[_1]\': [_2]',
    'Invalid date format \'[_1]\'; must be ' => 'Formato de fecha no válido \'[_1]\'; debe ser ',

    ## ./lib/MT/Log.pm
    'Entry # [_1] not found.' => 'Entrada nº [_1] no encontrada.',
    'Comment # [_1] not found.' => 'Comentario nº [_1] no encontrado.',
    'TrackBack # [_1] not found.' => 'TrackBack nº [_1] no encontrado.',

    ## ./lib/MT/I18N.pm

    ## ./lib/MT/Atom.pm

    ## ./lib/MT/Mail.pm
    'Unknown MailTransfer method \'[_1]\'' => 'MailTransfer método desconocido \'[_1]\'',
    'Sending mail via SMTP requires that your server ' => 'El envío de correo vía SMTP requiere que su servidor ',
    'Error sending mail: [_1]' => 'Error enviado correo: [_1]',
    'You do not have a valid path to sendmail on your machine. ' => 'No tiene una ruta válida a sendmail en su máquina. ',
    'Exec of sendmail failed: [_1]' => 'Fallo la ejecución de sendmail: [_1]',

    ## ./lib/MT/ConfigMgr.pm
    'Config directive [_1] without value at [_2] line [_3]' => 'La directiva de configuración [_1] no tiene ningún valor en [_2] línea [_3]',
    'No such config variable \'[_1]\'' => 'No existe la variable de configuración \'[_1]\'',

    ## ./lib/MT/XMLRPCServer.pm
    'Invalid timestamp format' => 'Formato de fecha no válido',
    'No web services password assigned.  Please see your author profile to set it.' => 'No se ha establecido la contraseña de servicios web.  Por favor, vaya al perfil de su autor para configurarla.',
    'No blog_id' => 'Sin blog_id',
    'Invalid blog ID \'[_1]\'' => 'Identificador de blog  \'[_1]\' no válido',
    'Invalid login' => 'Inicio de sesión no válido',
    'No posting privileges' => 'Sin permisos de publicación',
    'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => 'El valor de \'mt_[_1]\' debe ser 0 ó 1 (era \'[_2]\')',
    'No entry_id' => 'Sin entry_id',
    'Invalid entry ID \'[_1]\'' => 'ID de entrada no válido \'[_1]\'',
    'Not privileged to edit entry' => 'No tiene permisos para editar la entrada',
    'Not privileged to delete entry' => 'No tiene permisos para borrar la entrada',
    'Entry \'[_1]\' (entry #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'Entrada \'[_1]\' (entrada nº[_2]) borrada por \'[_3]\' (usuario nº[_4]) por XML-RPC',
    'Not privileged to get entry' => 'No tiene permisos para obtener la entrada',
    'Author does not have privileges' => 'El autor no tiene permisos',
    'Not privileged to set entry categories' => 'No tiene permisos para establecer categorías en las entradas',
    'Publish failed: [_1]' => 'Falló la publicación: [_1]',
    'Not privileged to upload files' => 'No tiene privilegios para transferir ficheros',
    'No filename provided' => 'No se especificó el nombre del fichero ',
    'Invalid filename \'[_1]\'' => 'Nombre de fichero no válido \'[_1]\'',
    'Error making path \'[_1]\': [_2]' => 'Error creando la ruta \'[_1]\': [_2]',
    'Error writing uploaded file: [_1]' => 'Error escribiendo el fichero transferido: [_1]',
    'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Los métodos de las plantillas no están implementados, debido a las diferencias entre Blogger API y Movable Type API.',

    ## ./lib/MT/App.pm
    'Error loading [_1]: [_2]' => 'Error cargando [_1]: [_2]',
    'Failed login attempt by unknown user \'[_1]\'' => 'Intento de acceso no válido del usuario desconocido \'[_1]\'',
    'Failed login attempt with incorrect password by user \'[_1]\' (ID: [_2])' => 'Intento de acceso no válido por contraseña incorrecta del usuario \'[_1]\' (ID: [_2])',
    'User \'[_1]\' (ID:[_2]) logged in successfully' => 'Usuario \'[_1]\' (ID:[_2]) inició una sesión correctamente',
    'Invalid login.' => 'Acceso no válido.',
    'User \'[_1]\' (ID:[_2]) logged out' => 'Usuario \'[_1]\' (ID:[_2]) se desconectó',
    'The file you uploaded is too large.' => 'El fichero que transfirió es demasiado grande.',
    'Unknown action [_1]' => 'Acción desconocida [_1]',

    ## ./lib/MT/L10N/es.pm

    ## ./lib/MT/L10N/de-iso-8859-1.pm

    ## ./lib/MT/L10N/nl.pm

    ## ./lib/MT/L10N/nl-iso-8859-1.pm

    ## ./lib/MT/L10N/es-iso-8859-1.pm

    ## ./lib/MT/L10N/ja.pm

    ## ./lib/MT/L10N/fr-iso-8859-1.pm

    ## ./lib/MT/L10N/de.pm

    ## ./lib/MT/L10N/en_us.pm

    ## ./lib/MT/L10N/fr.pm

    ## ./lib/MT/ObjectDriver/DBM.pm
    'Your DataSource directory (\'[_1]\') does not exist.' => 'Su directorio DataSource (\'[_1]\') no existe.',
    'Your DataSource directory (\'[_1]\') is not writable.' => 'No se puede escribir en el directorio DataSource (\'[_1]\').',
    'Tie \'[_1]\' failed: [_2]' => 'La creación del enlace \'[_1]\' falló: [_2]',
    'Failed to generate unique ID: [_1]' => 'Fallo al intentar generar ID único: [_1]',
    'Unlink of \'[_1]\' failed: [_2]' => 'El borrado del enlace \'[_1]\' falló: [_2]',

    ## ./lib/MT/ObjectDriver/DBI.pm
    'Loading data failed with SQL error [_1]' => 'Durante la carga de datos falló con el error SQL [_1]',
    'Count [_1] failed on SQL error [_2]' => 'Falló \'count\' [_1] con el error SQL [_2]',
    'Prepare failed' => 'Falló el \'prepare\'',
    'Execute failed' => 'Falló el \'execute\'',
    'existence test failed on SQL error [_1]' => 'Test de existencia falló con el error SQL [_1]',
    'Insertion test failed on SQL error [_1]' => 'Test de inserción falló con el error SQL [_1]',
    'Update failed on SQL error [_1]' => 'Actualizar falló con el error SQL [_1]',
    'No such object.' => 'No existe dicho objeto.',
    'Remove failed on SQL error [_1]' => 'El borrado falló con el error SQL [_1]',
    'Remove-all failed on SQL error [_1]' => 'Falló el borrar-todos con el error SQL [_1]',

    ## ./lib/MT/ObjectDriver/DBI/sqlite.pm
    'Your database file (\'[_1]\') is not writable.' => 'No se puede escribir en el fichero de su base de datos (\'[_1]\').',
    'Your database directory (\'[_1]\') is not writable.' => 'No se puede escribir en el directorio de su base de datos (\'[_1]\').',
    'Connection error: [_1]' => 'Error de conexión: [_1]',

    ## ./lib/MT/ObjectDriver/DBI/mysql.pm
    'undefined type: [_1]' => 'tipo no definido: [_1]',

    ## ./lib/MT/ObjectDriver/DBI/postgres.pm

    ## ./lib/MT/Template/ContextHandlers.pm
    'Can\'t find included file \'[_1]\'' => 'No se encontró el fichero incluido \'[_1]\'',
    'Error opening included file \'[_1]\': [_2]' => 'Error abriendo el fichero incluido \'[_1]\': [_2]',
    'Unspecified archive template' => 'Archivo de plantilla no especificado',
    'Error in file template: [_1]' => 'Error en fichero de plantilla: [_1]',
    'Can\'t find template \'[_1]\'' => 'No se encontró la plantilla \'[_1]\'',
    'Can\'t find entry \'[_1]\'' => 'No se encontró la entrada \'[_1]\'',
    '[_1] [_2]' => '[_1] [_2]', # Translate - Previous (3)
    'You used a [_1] tag without any arguments.' => 'Usó una etiqueta [_1] sin ningún parámetro.',
    'You have an error in your \'category\' attribute: [_1]' => 'Tiene un error en el atributo \'category\': [_1]',
    'You have an error in your \'tag\' attribute: [_1]' => 'Tiene un error en el atributo \'tag\': [_1]',
    'No such author \'[_1]\'' => 'No existe el autor \'[_1]\'',
    'You used an \'[_1]\' tag outside of the context of an entry; ' => 'Usó una etiqueta \'[_1]\' fuera del contexto de una entrada; ',
    'You used <$MTEntryFlag$> without a flag.' => 'Usó <$MTEntryFlag$> sin \'flag\'.',
    'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Usó una etiqueta [_1] enlazando los archivos \'[_2]\', pero el tipo de archivo no está publicado.',
    'Could not create atom id for entry [_1]' => 'No se pudo crear un identificador atom en la entrada [_1]',
    'To enable comment registration, you ' => 'Para habilitar el registro de comentarios, ',
    '(You may use HTML tags for style)' => '(Puede usar etiquetas HTML para el estilo)',
    'You used an [_1] tag without a date context set up.' => 'Usó una etiqueta [_1] sin un contexto de fecha configurado.',
    'You used an \'[_1]\' tag outside of the context of a comment; ' => 'Usó una etiqueta \'[_1]\' fuera del contexto de un comentario; ',
    'You used an [_1] without a date context set up.' => 'Usó un [_1] sin una fecha de contexto configurada.',
    '[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] sólo se puede usar con los archivos diarios, semanales o mensuales.',
    'Couldn\'t get daily archive list' => 'No se pudo obtener la lista de archivos diarios',
    'Couldn\'t get monthly archive list' => 'No se pudo obtener la lista de archivos mensuales',
    'Couldn\'t get weekly archive list' => 'No se pudo obtener la lista de archivos semanales',
    'Unknown archive type [_1] in <MTArchiveList>' => 'Tipo de archivo [_1] desconocido en <MTArchiveList>',
    'Group iterator failed.' => 'Fallo en iterador de grupo.',
    'You used an [_1] tag outside of the proper context.' => 'Usó una etiqueta [_1] fuera del contexto correcto.',
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly ' => 'Usó una etiqueta [_1] fuera de Diario, Semanal, o Mensual ',
    'Could not determine entry' => 'No se pudo determinar la entrada',
    'Invalid month format: must be YYYYMM' => 'Formato de mes no válido: debe ser YYYYMM',
    'No such category \'[_1]\'' => 'No existe la categoría \'[_1]\'',
    'You used <$MTCategoryDescription$> outside of the proper context.' => 'Utilizó <$MTCategoryDescription$> fuera del contexto apropiado.',
    '[_1] can be used only if you have enabled Category archives.' => '[_1] sólo se puede usar si tiene habilitadas el archivado de categorías.',
    '<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> debe utilizarse en el contexto de una categoría, o con el atributo \'category\' en la etiqueta.',
    'You failed to specify the label attribute for the [_1] tag.' => 'No especificó el atributo título en la etiqueta [_1].',
    'You used an \'[_1]\' tag outside of the context of ' => 'Utilizó la etiqueta \'[_1]\' fuera del contexto de ',
    'MTSubCatsRecurse used outside of MTSubCategories' => 'MTSubCatsRecurse utilizado fuera de MTSubCategories',
    'MT[_1] must be used in a category context' => 'MT[_1] debe usarse en el contexto de categorías',
    'Cannot find package [_1]: [_2]' => 'No se encontró el paquete [_1]: [_2]',
    'Error sorting categories: [_1]' => 'Error ordenando categorías: [_1]',

    ## ./lib/MT/Template/Context.pm

    ## ./lib/MT/Plugin/L10N.pm

    ## ./lib/MT/Plugin/JunkFilter.pm
    'from rule' => 'desde la regla',
    'from test' => 'desde el test',

    ## ./lib/MT/App/Viewer.pm
    'This is an experimental feature; turn off SafeMode (in mt.cfg) in order to use it.' => 'Esta es una característica experimental; desactive SafeMode (en mt.cfg) para usarla.',
    'Not allowed to view blog [_1]' => 'No tiene permisos para ver al blog [_1]',
    'Loading blog with ID [_1] failed' => 'Fallo al cargar el blog con el ID [_1]',
    'Can\'t load \'[_1]\' template.' => 'No se pudo cargar la plantilla \'[_1]\'.',
    'Building template failed: [_1]' => 'Fallo al construir la plantilla: [_1]',
    'Invalid date spec' => 'Formato de fecha no válido',
    'Can\'t load template [_1]' => 'No se pudo cargar la plantilla [_1]',
    'Building archive failed: [_1]' => 'Fallo construyendo el archivo: [_1]',
    'Invalid entry ID [_1]' => 'Identificador de entrada no válido [_1]',
    'Entry [_1] is not published' => 'La entrada [_1] no está publicada',
    'Invalid category ID \'[_1]\'' => 'Identificador de categoría no válido \'[_1]\'',

    ## ./lib/MT/App/NotifyList.pm
    'Please enter a valid email address.' => 'Por favor, teclee una dirección de correo válida.',
    'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Falta parámetro obligatorio: blog_id. Por favor, consulte el manual de usuario para configurar las notificaciones.',
    'Email notifications have not been configured! The weblog owner needs to set the EmailVerificationSecret configuration variable in mt.cfg.' => '¡Las notificaciones por correo-e no están configuradas! El dueño del weblog necesita establecer la opción EmailVerificationSecret en mt.cfg.',
    'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Parámetro de redirección no válido. El dueño del weblog debe especificar una ruta que coincida con el del dominio del weblog.',
    'The email address \'[_1]\' is already in the notification list for this weblog.' => 'La dirección de correo-e \'[_1]\' ya está en la lista de notificaciones de este weblog.',
    'Please verify your email to subscribe' => 'Por favor, verifique su dirección de correo electrónico para la subscripción',
    'The address [_1] was not subscribed.' => 'No se suscribió la dirección [_1].',
    'The address [_1] has been unsubscribed.' => 'Se desuscribió la dirección [_1].',

    ## ./lib/MT/App/Search.pm
    'You are currently performing a search. Please wait ' => 'Actualmente está realizando una búsqueda. Por favor, espere ',
    'Search failed. Invalid pattern given: [_1]' => 'Falló la búsqueda. Patrón no válido: [_1]',
    'Search failed: [_1]' => 'Falló la búsqueda: [_1]',
    'No alternate template is specified for the Template \'[_1]\'' => 'No se especificó una plantilla alternativa para la Plantilla \'[_1]\'',
    'Opening local file \'[_1]\' failed: [_2]' => 'Fallo abriendo el fichero local \'[_1]\': [_2]',
    'Building results failed: [_1]' => 'Fallo generando los resultados: [_1]',
    'Search: query for \'[_1]\'' => 'Búsqueda: encontrar \'[_1]\'',
    'Search: new comment search' => 'Búsqueda: nueva búsqueda de comentarios',

    ## ./lib/MT/App/Upgrader.pm
    'The initial account name is required.' => 'Se necesita el nombre de la cuenta inicial.',
    'You failed to validate your password.' => 'Falló al validar la contraseña.',
    'You failed to supply a password.' => 'No introdujo una contraseña.',
    'The value you entered was not a valid email address' => 'El valor que tecleó no es una dirección válida de correo electrónico',
    'Password recovery word/phrase is required.' => 'Se necesita la palabra/frase de recuperación de contraseña.',
    'User \'[_1]\' upgraded database to version [_2]' => 'Usuario \'[_1]\' actualizó la base de datos a la versión [_2]',
    'Invalid session.' => 'Sesión no válida.',
    'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Sin permisos. Por favor, contacte con su administrador para la actualización de Movable Type.',

    ## ./lib/MT/App/Trackback.pm
    'You must define a Ping template in order to display pings.' => 'Debe definir una plantilla de ping para poderlos mostrar.',
    'Trackback pings must use HTTP POST' => 'Los pings de Trackback deben usar HTTP POST',
    'Need a TrackBack ID (tb_id).' => 'Necesita un ID de TrackBack (tb_id).',
    'Invalid TrackBack ID \'[_1]\'' => 'ID de TrackBack no válido \'[_1]\'',
    'You are not allowed to send TrackBack pings.' => 'No se le permite enviar pings de TrackBack.',
    'You are pinging trackbacks too quickly. Please try again later.' => 'Está enviando pings de TrackBack demasiado rápido. Por favor, inténtelo más tarde.',
    'Need a Source URL (url).' => 'Necesita una URL fuente (url).',
    'Invalid URL \'[_1]\'' => 'URL no válida \'[_1]\'',
    'This TrackBack item is disabled.' => 'Este elemento de TrackBack fue deshabilitado.',
    'This TrackBack item is protected by a passphrase.' => 'Este elemento de TrackBack está protegido por una contraseña.',
    'TrackBack on "[_1]" from "[_2]".' => 'TrackBack en "[_1]" de "[_2]".',
    'TrackBack on category \'[_1]\' (ID:[_2]).' => 'TrackBack en la categoría \'[_1]\' (ID:[_2]).',
    'Rebuild failed: [_1]' => 'Falló la reconstrucción: [_1]',
    'Can\'t create RSS feed \'[_1]\': ' => 'No se pudo crear la fuente RSS \'[_1]\': ',
    'New TrackBack Ping to Entry [_1] ([_2])' => 'Nuevo ping de TrackBack en la entrada [_1] ([_2])',
    'New TrackBack Ping to Category [_1] ([_2])' => 'Nuevo ping de TrackBack en la categoría [_1] ([_2])',

    ## ./lib/MT/App/Comments.pm
    'No id' => 'Sin id',
    'No such comment' => 'No existe dicho comentario',
    'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] bloqueada porque excedió el ritmo de comentarios, más de 8 en [_2] segundos.',
    'IP Banned Due to Excessive Comments' => 'IP bloqueada debido al exceso de comentarios',
    'Invalid request' => 'Petición no válida',
    'No such entry \'[_1]\'.' => 'No existe la entrada \'[_1]\'.',
    'You are not allowed to post comments.' => 'No puede publicar comentarios.',
    'Comments are not allowed on this entry.' => 'No se permiten comentarios en esta entrada.',
    'Comment text is required.' => 'El texto del comentario es obligatorio.',
    'Registration is required.' => 'El registro es obligatorio.',
    'Name and email address are required.' => 'El nombre y la dirección de correo-e son obligatorios.',
    'Invalid email address \'[_1]\'' => 'Dirección de correo-e no válida \'[_1]\'',
    'Comment save failed with [_1]' => 'Fallo guardando comentario con [_1]',
    'Comment on "[_1]" by [_2].' => 'Comentario en "[_1]" por [_2].',
    'Commenter save failed with [_1]' => 'Fallo guardando comentarista con [_1]',
    'New Comment Posted to \'[_1]\'' => 'Nuevo comentario publicado en \'[_1]\'',
    'The login could not be confirmed because of a database error ([_1])' => 'No se pudo confirmar el acceso debido a un error de la base de datos ([_1])',
    'Couldn\'t get public key from url provided' => 'No se pudo obtener la clave pública desde la URL indicada',
    'No public key could be found to validate registration.' => 'No se encontró la clave pública para validar el registro.',
    'TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'La firma TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]',
    'The TypeKey signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'La firma TypeKey está caducada ([_1] segundos vieja). Asegúrese de que el reloj de su servidor está en hora',
    'The sign-in validation failed.' => 'Falló el registro de validación.',
    'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Este weblog obliga a que los comentaristas den su dirección de correo electrónico. Si lo desea puede iniciar una sesión de nuevo, y dar al servicio de autentificación permisos para pasar la dirección de correo electrónico.',
    'Couldn\'t save the session' => 'No se pudo guardar la sesión',
    'This weblog requires commenters to pass an email address' => 'Este weblog necesita que los comentaristas den su dirección de correo electrónico',
    'Sign in requires a secure signature; logout requires the logout=1 parameter' => 'El registro requiere una firma segura; salir requiere el parámetro logout=1',
    'The sign-in attempt was not successful; please try again.' => 'El intento de registro no tuvo éxito; por favor, inténtelo de nuevo.',
    'The sign-in validation was not successful. Please make sure your weblog is properly configured and try again.' => 'La validación del registro no tuvo éxito. Por favor, asegúrese de que su weblog está configurado correctamente e inténtelo de nuevo.',
    'No such entry ID \'[_1]\'' => 'No existe el ID de entrada \'[_1]\'',
    'You must define an Individual template in order to ' => 'Debe definir una plantilla individual para  ',
    'You must define a Comment Listing template in order to ' => 'Debe definir una plantilla de listado de comentarios para ',
    'No entry was specified; perhaps there is a template problem?' => 'No se especificó ninguna entrada; ¿quizás hay un problema con la plantilla?',
    'Somehow, the entry you tried to comment on does not exist' => 'De alguna manera, la entrada en la que intentó comentar no existe',
    'You must define a Comment Pending template.' => 'Debe definir una plantilla de comentarios pendiente.',
    'You must define a Comment Error template.' => 'Debe definir una plantilla de error de comentarios.',
    'You must define a Comment Preview template.' => 'Debe definir una plantilla de vista previa de comentarios.',

    ## ./lib/MT/App/Wizard.pm
    'Sendmail' => 'Sendmail', # Translate - Previous (1)
    'Test email from Movable Type Configuration Wizard' => 'Correo de prueba del asistente de configuración de Movable Type',
    'This is the test email sent by your new installation of Movable Type.' => 'Este es el correo de prueba enviado desde su nueva instalación de Movable Type.',

    ## ./lib/MT/App/ActivityFeeds.pm
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
    'Movable Type Debug Activity' => 'Actividad de depuración de Movable Type',

    ## ./lib/MT/App/CMS.pm
    'No permissions' => 'No tiene permisos',
    'Invalid blog' => 'Blog no válido',
    'Convert Line Breaks' => 'Convertir saltos de línea',
    'Invalid author_id' => 'author_id no válido',
    'Invalid username \'[_1]\' in password recovery attempt' => 'Nombre de usuario no válido \'[_1]\' en intento de recuperación de contraseña',
    'Username or password recovery phrase is incorrect.' => 'El usuario o la frase de recuperación de contraseña es incorrecto.',
    'Password recovery for user \'[_1]\' failed due to lack of recovery phrase specified in profile.' => 'Falló la recuperación de contraseña para el usuario \'[_1]\' debido a que no tiene especificada una frase en su perfil.',
    'No password recovery phrase set in user profile. Please see your system administrator for password recovery.' => 'No hay establecida una frase de recuperación de contraseña en el perfil del usuario. Por favor, contacte con el administrador de sistemas para recuperar su contraseña.',
    'Invalid attempt to recover password (used recovery phrase \'[_1]\')' => 'Intento de recuperación de contraseña no válido (frase utilizada \'[_1]\')',
    'Password recovery for user \'[_1]\' failed due to lack of email specified in profile.' => 'Falló la recuperación de contraseña para el usuario \'[_1]\' debido a que no tiene especificado un correo electrónico en su perfil.',
    'No email specified in user profile.  Please see your system administrator for password recovery.' => 'El correo electrónico no está especificado en el perfil del usuario. Por favor, contacte con el administrador de sistemas para recuperar la contraseña.',
    'Password was reset for user \'[_1]\' (ID:[_2]) and sent to address: [_3]' => 'Se reinició la contraseña del usuario \'[_1]\' (ID:[_2]) y se envió a la dirección: [_3]',
    'Error sending mail ([_1]); please fix the problem, then ' => 'Error enviando correo ([_1]); por favor, solucione el problema, y luego  ',
    'Invalid type' => 'Tipo no válido',
    'No such tag' => 'No existe dicha etiqueta',
    'You are not authorized to log in to this blog.' => 'No está autorizado para acceder a este blog.',
    'No such blog [_1]' => 'No existe el blog [_1]',
    'Weblog Activity Feed' => 'Fuente de actividad del weblog',
    '(author deleted)' => '(autor borrado)',
    'All Feedback' => 'Todas las opiniones',
    'log records' => 'históricos',
    'System Activity Feed' => 'Fuente de actividad del sistema',
    'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'El registro de actividad del blog \'[_1]\' (ID:[_2]) fue reiniciado por  \'[_3]\'',
    'Activity log reset by \'[_1]\'' => 'Registro de actividad reiniciado por \'[_1]\'',
    'Import/Export' => 'Importar/Exportar',
    'Invalid blog id [_1].' => 'Identificador de blog no válido [_1].',
    'Invalid parameter' => 'Parámetro no válido',
    'Load failed: [_1]' => 'Fallo carga: [_1]',
    '(no reason given)' => '(ninguna razón ofrecida)',
    '(untitled)' => '(sin título)',
    'Create template requires type' => 'Crear plantillas requiere el tipo',
    'New Template' => 'Nueva plantilla',
    'New Weblog' => 'Nuevo weblog',
    'Author requires username' => 'El autor necesita un nombre de usuario',
    'Author requires password' => 'El autor necesita una contraseña',
    'Author requires password recovery word/phrase' => 'El autor necesita una palabra/frase de recuperación de contraseña',
    'Email Address is required for password recovery' => 'La dirección de correo es necesaria para la recuperación de la contraseña',
    'The e-mail address you entered is already on the Notification List for this weblog.' => 'La dirección de correo-e que tecleó ya está en la lista de notificaciones de este weblog.',
    'You did not enter an IP address to ban.' => 'No tecleó una dirección IP para bloquear.',
    'The IP you entered is already banned for this weblog.' => 'La IP que tecleó ya está bloqueada en este weblog.',
    'You did not specify a weblog name.' => 'No especificó el nombre del weblog.',
    'Site URL must be an absolute URL.' => 'La URL del sitio debe ser una URL absoluta.',
    'Archive URL must be an absolute URL.' => 'La URL de archivo debe ser una URL absoluta.',
    'The name \'[_1]\' is too long!' => 'El nombre \'[_1]\' es demasiado largo.',
    'Category \'[_1]\' created by \'[_2]\'' => 'Categoría \'[_1]\' creada por \'[_2]\'',
    'The category label \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'El título de la categoría \'[_1]\' coincide con el de otra categoría. Las categorías de nivel superior y las sub-categorías con el mismo padre deben tener nombres únicos.',
    'Saving permissions failed: [_1]' => 'Fallo guardando permisos: [_1]',
    'Can\'t find default template list; where is ' => 'No se encontró la lista de plantillas por defecto; donde está ',
    'Populating blog with default templates failed: [_1]' => 'Fallo guardando el blog con las plantillas por defecto: [_1]',
    'Setting up mappings failed: [_1]' => 'Fallo la configuración de mapeos: [_1]',
    'Weblog \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Weblog \'[_1]\' (ID:[_2]) creado por \'[_3]\'',
    'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Usuario \'[_1]\' (ID:[_2]) creado por \'[_3]\'',
    'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Plantilla \'[_1]\' (ID:[_2]) creada por \'[_3]\'',
    'You cannot delete your own author record.' => 'No puede borrar el registro de su propio autor.',
    'You have no permission to delete the author [_1].' => 'No tiene permisos para borrar el autor [_1].',
    'Weblog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Weblog \'[_1]\' (ID:[_2]) borrado por \'[_3]\'',
    'Subscriber \'[_1]\' (ID:[_2]) deleted from notification list by \'[_3]\'' => 'Suscriptor \'[_1]\' (ID:[_2]) borrado de la lista de notificación por \'[_3]\'',
    'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Usuario \'[_1]\' (ID:[_2]) borrado por \'[_3]\'',
    'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Categoría \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
    'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Comentario (ID:[_1]) por \'[_2]\' borrado por \'[_3]\' de la entrada \'[_4]\'',
    'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Entrada \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
    '(Unlabeled category)' => '(Categoría sin título)',
    'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) desde \'[_2]\' borrado por \'[_3]\' de la categoría \'[_4]\'',
    '(Untitled entry)' => '(Entrada sin título)',
    'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) desde \'[_2]\' borrado por \'[_3]\' de la entrada \'[_4]\'',
    'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Plantilla \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
    'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Etiqueta \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
    'Passwords do not match.' => 'Las contraseñas no coinciden.',
    'Failed to verify current password.' => 'Fallo al verificar la contraseña actual.',
    'An author by that name already exists.' => 'Ya existe un autor con dicho nombre.',
    'Save failed: [_1]' => 'Fallo al guardar: [_1]',
    'Saving object failed: [_1]' => 'Fallo guardando objeto: [_1]',
    'No Name' => 'Sin nombre',
    'Notification List' => 'Lista de notificaciones',
    'email addresses' => 'dirección de correo-e',
    'Can\'t delete that way' => 'No puede borrar de esa forma',
    'Your login session has expired.' => 'Su sesión expiró.',
    'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => 'No puede eliminar esa categoría porque tiene subcategorías. Mueva o elimine primero las categorías si desea eliminar ésta.',
    'System templates can not be deleted.' => 'Las plantillas del sistema no se pueden borrar.',
    'Unknown object type [_1]' => 'Tipo de objeto desconocido [_1]',
    'Loading object driver [_1] failed: [_2]' => 'Falló cargando el controlador de objetos [_1]: [_2]',
    'Reading \'[_1]\' failed: [_2]' => 'Fallo leyendo \'[_1]\': [_2]',
    'Thumbnail failed: [_1]' => 'Fallo vista previa: [_1]',
    'Error writing to \'[_1]\': [_2]' => 'Error escribiendo en \'[_1]\': [_2]',
    'Invalid basename \'[_1]\'' => 'Nombre base no válido \'[_1]\'',
    'No such commenter [_1].' => 'No existe el comentarista [_1].',
    'User \'[_1]\' trusted commenter \'[_2]\'.' => 'Usuario \'[_1]\' confió en el comentarista \'[_2]\'.',
    'User \'[_1]\' banned commenter \'[_2]\'.' => 'Usuario \'[_1]\' bloqueó al comentarista \'[_2]\'.',
    'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'Usuario \'[_1]\' desbloqueó al comentarista \'[_2]\'.',
    'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'Usuario \'[_1]\' desconfió del comentarista \'[_2]\'.',
    'Need a status to update entries' => 'Necesita indicar un estado para actualizar las entradas',
    'Need entries to update status' => 'Necesita entradas para actualizar su estado',
    'One of the entries ([_1]) did not actually exist' => 'Una de las entradas ([_1]) no existe actualmente',
    'Some entries failed to save' => 'Algunas entradas fallaron al guardar',
    'You don\'t have permission to approve this TrackBack.' => 'No tiene permisos para aprobar este TrackBack.',
    'Comment on missing entry!' => '¡Comentario en entrada inexistente!',
    'You don\'t have permission to approve this comment.' => 'No tiene permiso para aprobar este comentario.',
    'Comment Activity Feed' => 'Fuente de actividad de comentarios',
    'Orphaned comment' => 'Comentario huérfano',
    'Plugin Set: [_1]' => 'Conjuntos de extensiones: [_1]',
    'TrackBack Activity Feed' => 'Fuente de actividad de TrackBacks',
    'No Excerpt' => 'Sin resumen',
    'No Title' => 'Sin título',
    'Orphaned TrackBack' => 'TrackBack huérfano',
    'Tag' => 'Etiqueta',
    'Entry Activity Feed' => 'Fuente de actividad de entradas',
    'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Fecha no válida \'[_1]\'; debe tener el formato YYYY-MM-DD HH:MM:SS.',
    'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Fecha no válida \'[_1]\'; debe ser una fecha real.',
    'Saving entry \'[_1]\' failed: [_2]' => 'Fallo guardando entrada \'[_1]\': [_2]',
    'Removing placement failed: [_1]' => 'Fallo eliminando lugar: [_1]',
    'No such entry.' => 'No existe la entrada.',
    'Your weblog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Su weblog no tiene configurados la ruta y URL. No puede publicar entradas hasta que las defina.',
    'Entry \'[_1]\' (ID:[_2]) added by user \'[_3]\'' => 'Entrada \'[_1]\' (ID:[_2]) añadida por el usuario \'[_3]\'',
    'The category must be given a name!' => 'Debe darle un nombre a la categoría.',
    'yyyy/mm/entry_basename' => 'aaaa/mm/entrada_nombrebase',
    'yyyy/mm/entry-basename' => 'yyyy/mm/entrada-nombrebase',
    'yyyy/mm/entry_basename/' => 'aaaa/mm/entrada_nombrebase/',
    'yyyy/mm/entry-basename/' => 'yyyy/mm/entrada-nombrebase/',
    'yyyy/mm/dd/entry_basename' => 'aaaa/mm/dd/entrada_nombrebase',
    'yyyy/mm/dd/entry-basename' => 'yyyy/mm/dd/entrada-nombrebase',
    'yyyy/mm/dd/entry_basename/' => 'aaaa/mm/dd/entrada_nombrebase/',
    'yyyy/mm/dd/entry-basename/' => 'yyyy/mm/dd/entrada-nombrebase/',
    'category/sub_category/entry_basename' => 'categoría/sub_categoría/entrada_nombrebase',
    'category/sub_category/entry_basename/' => 'categoría/sub_categoría/entrada_nombrebase/',
    'category/sub-category/entry_basename' => 'categoría/sub-categoría/entrada_nombrebase',
    'category/sub-category/entry-basename' => 'categoría/sub_categoría/entrada-nombrebase',
    'category/sub-category/entry_basename/' => 'categoría/sub-categoría/entrada_nombrebase/',
    'category/sub-category/entry-basename/' => 'categoría/sub_categoría/entrada-nombrebase/',
    'primary_category/entry_basename' => 'categoría_principal/entrada_nombrebase',
    'primary_category/entry_basename/' => 'categoría_principal/entrada_nombrebase/',
    'primary-category/entry_basename' => 'categoría-principal/entrada_nombrebase',
    'primary-category/entry-basename' => 'categoría-principal/entrada-nombrebase',
    'primary-category/entry_basename/' => 'categoría-principal/entrada_nombrebase/',
    'primary-category/entry-basename/' => 'categoría-principal/entrada_nombrebase/',
    'yyyy/mm/' => 'aaaa/mm/',
    'yyyy_mm' => 'aaaa_mm',
    'yyyy/mm/dd/' => 'aaaa/mm/dd/',
    'yyyy_mm_dd' => 'aaaa_mm_dd',
    'yyyy/mm/dd-week/' => 'aaaa/mm/dd-semana/',
    'week_yyyy_mm_dd' => 'semana_aaaa_mm_dd',
    'category/sub_category/' => 'categoría/sub_categoría/',
    'category/sub-category/' => 'categoría/sub-categoría/',
    'cat_category' => 'cat_categoría',
    'Saving blog failed: [_1]' => 'Fallo guardando blog: [_1]',
    'You do not have permission to configure the blog' => 'No tiene permiso para configurar el blog',
    'Saving map failed: [_1]' => 'Fallo guardando mapa: [_1]',
    'Parse error: [_1]' => 'Error de interpretación: [_1]',
    'Build error: [_1]' => 'Error construyendo: [_1]',
    'Rebuild-option name must not contain special characters' => 'El nombre de la opción de reconstrucción no debe contener caracteres espaciales',
    'index template \'[_1]\'' => 'plantilla índice \'[_1]\'',
    'entry \'[_1]\'' => 'entrada \'[_1]\'',
    'Ping \'[_1]\' failed: [_2]' => 'Falló ping \'[_1]\' : [_2]',
    'You cannot modify your own permissions.' => 'No puede modificar sus propios permisos.',
    'You are not allowed to edit the permissions of this author.' => 'No puede editar los permisos de este autor.',
    'Edit Permissions' => 'Editar permisos',
    'Edit Profile' => 'Editar perfil',
    'No entry ID provided' => 'ID de entrada no provista',
    'No such entry \'[_1]\'' => 'No existe la entrada \'[_1]\'',
    'No email address for author \'[_1]\'' => 'No hay dirección de correo electrónico asociada al autor \'[_1]\'',
    'No valid recipients found for the entry notification.' => 'No se encontraron destinatarios válidos para la notificación de la entrada.',
    'Error sending mail ([_1]); try another MailTransfer setting?' => 'Error enviando correo electrónico ([_1]); ¿quizás probando con otra configuración para MailTransfer?',
    'You did not choose a file to upload.' => 'No ha seleccionado un fichero para subir.',
    'Invalid extra path \'[_1]\'' => 'Ruta extra no válida \'[_1]\'',
    'Can\'t make path \'[_1]\': [_2]' => 'No se puede crear la ruta \'[_1]\': [_2]',
    'Invalid temp file name \'[_1]\'' => 'Nombre de fichero temporal no válido \'[_1]\'',
    'Error opening \'[_1]\': [_2]' => 'Error abriendo \'[_1]\': [_2]',
    'Error deleting \'[_1]\': [_2]' => 'Error borrando \'[_1]\': [_2]',
    'File with name \'[_1]\' already exists. (Install ' => 'Ya existe un fichero con el nombre  \'[_1]\'. (Instalar ',
    'Error creating temporary file; please check your TempDir ' => 'Error creando fichero temporal; por favor, compruebe su TempDir ',
    'unassigned' => 'no asignado',
    'File with name \'[_1]\' already exists; Tried to write ' => 'Ya existe un fichero con el nombre \'[_1]\'; Se intentó escribir ',
    'Error writing upload to \'[_1]\': [_2]' => 'Error escribiendo transferencia a \'[_1]\': [_2]',
    'Perl module Image::Size is required to determine ' => 'Se necesita el módulo de Perl Image::Size para determinar  ',
    'Invalid date(s) specified for date range.' => 'Se especificaron fechas no válidas para el rango.',
    'Error in search expression: [_1]' => 'Error en la expresión de búsqueda: [_1]',
    'Saving object failed: [_2]' => 'Fallo al guardar objeto: [_2]',
    'Search & Replace' => 'Buscar & Reemplazar',
    'No blog ID' => 'No es ID de blog',
    'You do not have export permissions' => 'No tiene permisos de exportación',
    'You do not have import permissions' => 'No tiene permisos de importación',
    'You do not have permission to create authors' => 'No tiene permisos para crear autores',
    'Preferences' => 'Preferencias',
    'Add a Category' => 'Añadir una categoría',
    'No label' => 'Sin título',
    'Category name cannot be blank.' => 'El nombre de la categoría no puede estar en blanco.',
    'That action ([_1]) is apparently not implemented!' => '¡La acción ([_1]) aparentemente no está implementada!',
    'Permission denied' => 'Permiso denegado',

    ## ./lib/MT/FileMgr/FTP.pm
    'Creating path \'[_1]\' failed: [_2]' => 'Fallo creando la ruta \'[_1]\': [_2]',
    'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Fallo renombrando \'[_1]\' a \'[_2]\': [_3]',
    'Deleting \'[_1]\' failed: [_2]' => 'Fallo borrando \'[_1]\': [_2]',

    ## ./lib/MT/FileMgr/SFTP.pm
    'SFTP connection failed: [_1]' => 'Fallo en la conexión SFTP: [_1]',
    'SFTP get failed: [_1]' => 'Falló la orden \'get\' en el SFTP: [_1]',
    'SFTP put failed: [_1]' => 'Falló la orden \'put\' en el SFTP: [_1]',

    ## ./lib/MT/FileMgr/DAV.pm
    'DAV connection failed: [_1]' => 'Falló la conexión DAV: [_1]',
    'DAV open failed: [_1]' => 'Falló la orden \'open\' en el DAV: [_1]',
    'DAV get failed: [_1]' => 'Falló la orden \'get\' en el DAV: [_1]',
    'DAV put failed: [_1]' => 'Falló la orden \'put\' en el DAV: [_1]',

    ## ./lib/MT/FileMgr/Local.pm

    ## ./lib/MT/I18N/default.pm

    ## ./lib/MT/I18N/ja.pm

    ## ./lib/MT/I18N/en_us.pm

    ## ./build/Html.pm

    ## ./build/Build.pm

    ## ./build/sample.pm

    ## ./build/cwapi.pm

    ## ./build/Backup.pm

    ## ./extlib/DateTimePPExtra.pm

    ## ./extlib/DateTimePP.pm

    ## ./extlib/JSON.pm

    ## ./extlib/Jcode.pm

    ## ./extlib/DateTime.pm

    ## ./extlib/CGI.pm

    ## ./extlib/URI.pm

    ## ./extlib/LWP.pm

    ## ./extlib/Module/Load.pm

    ## ./extlib/Module/Load/Conditional.pm

    ## ./extlib/URI/_userpass.pm

    ## ./extlib/URI/_login.pm

    ## ./extlib/URI/QueryParam.pm

    ## ./extlib/URI/http.pm

    ## ./extlib/URI/URL.pm

    ## ./extlib/URI/telnet.pm

    ## ./extlib/URI/_foreign.pm

    ## ./extlib/URI/_segment.pm

    ## ./extlib/URI/rsync.pm

    ## ./extlib/URI/WithBase.pm

    ## ./extlib/URI/_query.pm

    ## ./extlib/URI/pop.pm

    ## ./extlib/URI/urn.pm

    ## ./extlib/URI/Fetch.pm

    ## ./extlib/URI/rtspu.pm

    ## ./extlib/URI/rtsp.pm

    ## ./extlib/URI/file.pm

    ## ./extlib/URI/Heuristic.pm

    ## ./extlib/URI/_server.pm

    ## ./extlib/URI/sip.pm

    ## ./extlib/URI/gopher.pm

    ## ./extlib/URI/_generic.pm

    ## ./extlib/URI/news.pm

    ## ./extlib/URI/ldap.pm

    ## ./extlib/URI/sips.pm

    ## ./extlib/URI/ssh.pm

    ## ./extlib/URI/https.pm

    ## ./extlib/URI/mailto.pm

    ## ./extlib/URI/ftp.pm

    ## ./extlib/URI/snews.pm

    ## ./extlib/URI/rlogin.pm

    ## ./extlib/URI/nntp.pm

    ## ./extlib/URI/Escape.pm

    ## ./extlib/URI/data.pm

    ## ./extlib/URI/Fetch/Response.pm

    ## ./extlib/URI/file/OS2.pm

    ## ./extlib/URI/file/Base.pm

    ## ./extlib/URI/file/Mac.pm

    ## ./extlib/URI/file/QNX.pm

    ## ./extlib/URI/file/FAT.pm

    ## ./extlib/URI/file/Win32.pm

    ## ./extlib/URI/file/Unix.pm

    ## ./extlib/URI/urn/oid.pm

    ## ./extlib/URI/urn/isbn.pm

    ## ./extlib/XML/Simple.pm

    ## ./extlib/XML/XPath.pm

    ## ./extlib/XML/NamespaceSupport.pm

    ## ./extlib/XML/SAX.pm

    ## ./extlib/XML/Elemental.pm

    ## ./extlib/XML/Atom.pm

    ## ./extlib/XML/Parser/Lite.pm

    ## ./extlib/XML/Parser/Style/Elemental.pm

    ## ./extlib/XML/SAX/Exception.pm

    ## ./extlib/XML/SAX/DocumentLocator.pm

    ## ./extlib/XML/SAX/Base.pm

    ## ./extlib/XML/SAX/ParserFactory.pm

    ## ./extlib/XML/SAX/PurePerl.pm

    ## ./extlib/XML/SAX/PurePerl/UnicodeExt.pm

    ## ./extlib/XML/SAX/PurePerl/DebugHandler.pm

    ## ./extlib/XML/SAX/PurePerl/NoUnicodeExt.pm

    ## ./extlib/XML/SAX/PurePerl/Productions.pm

    ## ./extlib/XML/SAX/PurePerl/Exception.pm

    ## ./extlib/XML/SAX/PurePerl/XMLDecl.pm

    ## ./extlib/XML/SAX/PurePerl/DocType.pm

    ## ./extlib/XML/SAX/PurePerl/DTDDecls.pm

    ## ./extlib/XML/SAX/PurePerl/EncodingDetect.pm

    ## ./extlib/XML/SAX/PurePerl/Reader.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/UnicodeExt.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/NoUnicodeExt.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/String.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/Stream.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/URI.pm

    ## ./extlib/XML/Elemental/Element.pm

    ## ./extlib/XML/Elemental/SAXHandler.pm

    ## ./extlib/XML/Elemental/Characters.pm

    ## ./extlib/XML/Elemental/Node.pm

    ## ./extlib/XML/Elemental/Util.pm

    ## ./extlib/XML/Elemental/Document.pm

    ## ./extlib/XML/Atom/Author.pm

    ## ./extlib/XML/Atom/Link.pm

    ## ./extlib/XML/Atom/Client.pm

    ## ./extlib/XML/Atom/ErrorHandler.pm

    ## ./extlib/XML/Atom/Server.pm

    ## ./extlib/XML/Atom/API.pm

    ## ./extlib/XML/Atom/Feed.pm

    ## ./extlib/XML/Atom/Person.pm

    ## ./extlib/XML/Atom/Content.pm

    ## ./extlib/XML/Atom/Util.pm

    ## ./extlib/XML/Atom/Thing.pm

    ## ./extlib/XML/Atom/Entry.pm

    ## ./extlib/XML/XPath/Literal.pm

    ## ./extlib/XML/XPath/Root.pm

    ## ./extlib/XML/XPath/PerlSAX.pm

    ## ./extlib/XML/XPath/Parser.pm

    ## ./extlib/XML/XPath/Step.pm

    ## ./extlib/XML/XPath/Expr.pm

    ## ./extlib/XML/XPath/Function.pm

    ## ./extlib/XML/XPath/Variable.pm

    ## ./extlib/XML/XPath/NodeSet.pm

    ## ./extlib/XML/XPath/Builder.pm

    ## ./extlib/XML/XPath/Node.pm

    ## ./extlib/XML/XPath/LocationPath.pm

    ## ./extlib/XML/XPath/XMLParser.pm

    ## ./extlib/XML/XPath/Boolean.pm

    ## ./extlib/XML/XPath/Number.pm

    ## ./extlib/XML/XPath/Node/Comment.pm

    ## ./extlib/XML/XPath/Node/Attribute.pm

    ## ./extlib/XML/XPath/Node/Element.pm

    ## ./extlib/XML/XPath/Node/PI.pm

    ## ./extlib/XML/XPath/Node/Text.pm

    ## ./extlib/XML/XPath/Node/Namespace.pm

    ## ./extlib/File/Listing.pm

    ## ./extlib/File/Temp.pm

    ## ./extlib/File/Copy/Recursive.pm

    ## ./extlib/MIME/Words.pm

    ## ./extlib/HTTP/Headers.pm

    ## ./extlib/HTTP/Negotiate.pm

    ## ./extlib/HTTP/Daemon.pm

    ## ./extlib/HTTP/Response.pm

    ## ./extlib/HTTP/Request.pm

    ## ./extlib/HTTP/Message.pm

    ## ./extlib/HTTP/Status.pm

    ## ./extlib/HTTP/Date.pm

    ## ./extlib/HTTP/Cookies.pm

    ## ./extlib/HTTP/Headers/ETag.pm

    ## ./extlib/HTTP/Headers/Auth.pm

    ## ./extlib/HTTP/Headers/Util.pm

    ## ./extlib/HTTP/Request/Common.pm

    ## ./extlib/JSON/Parser.pm

    ## ./extlib/JSON/Converter.pm

    ## ./extlib/WWW/RobotRules.pm

    ## ./extlib/WWW/RobotRules/AnyDBM_File.pm

    ## ./extlib/DateTime/LocaleCatalog.pm

    ## ./extlib/DateTime/LeapSecond.pm

    ## ./extlib/DateTime/TimeZone.pm

    ## ./extlib/DateTime/Infinite.pm

    ## ./extlib/DateTime/Locale.pm

    ## ./extlib/DateTime/Duration.pm

    ## ./extlib/DateTime/TimeZoneCatalog.pm

    ## ./extlib/DateTime/Locale/Base.pm

    ## ./extlib/DateTime/Locale/root.pm

    ## ./extlib/DateTime/Locale/Alias/ISO639_2.pm

    ## ./extlib/DateTime/TimeZone/Floating.pm

    ## ./extlib/DateTime/TimeZone/OlsonDB.pm

    ## ./extlib/DateTime/TimeZone/UTC.pm

    ## ./extlib/DateTime/TimeZone/OffsetOnly.pm

    ## ./extlib/DateTime/TimeZone/Local.pm

    ## ./extlib/Apache/SOAP.pm

    ## ./extlib/Apache/XMLRPC/Lite.pm

    ## ./extlib/IPC/Cmd.pm

    ## ./extlib/Attribute/Params/Validate.pm

    ## ./extlib/Locale/Maketext.pm

    ## ./extlib/IO/SessionSet.pm

    ## ./extlib/IO/SessionData.pm

    ## ./extlib/Archive/Extract.pm

    ## ./extlib/Class/ErrorHandler.pm

    ## ./extlib/Class/Accessor.pm

    ## ./extlib/Class/Accessor/Fast.pm

    ## ./extlib/Jcode/Tr.pm

    ## ./extlib/Jcode/H2Z.pm

    ## ./extlib/Jcode/Constants.pm

    ## ./extlib/Jcode/Unicode/Constants.pm

    ## ./extlib/Jcode/Unicode/NoXS.pm

    ## ./extlib/Params/Validate.pm

    ## ./extlib/Params/ValidateXS.pm

    ## ./extlib/Params/Check.pm

    ## ./extlib/Params/ValidatePP.pm

    ## ./extlib/Net/HTTP.pm

    ## ./extlib/Net/HTTPS.pm

    ## ./extlib/Net/HTTP/Methods.pm

    ## ./extlib/Net/HTTP/NB.pm

    ## ./extlib/LWP/Simple.pm

    ## ./extlib/LWP/MemberMixin.pm

    ## ./extlib/LWP/Debug.pm

    ## ./extlib/LWP/RobotUA.pm

    ## ./extlib/LWP/UserAgent.pm

    ## ./extlib/LWP/MediaTypes.pm

    ## ./extlib/LWP/Protocol.pm

    ## ./extlib/LWP/ConnCache.pm

    ## ./extlib/LWP/Protocol/GHTTP.pm

    ## ./extlib/LWP/Protocol/http.pm

    ## ./extlib/LWP/Protocol/nogo.pm

    ## ./extlib/LWP/Protocol/file.pm

    ## ./extlib/LWP/Protocol/gopher.pm

    ## ./extlib/LWP/Protocol/http10.pm

    ## ./extlib/LWP/Protocol/https.pm

    ## ./extlib/LWP/Protocol/mailto.pm

    ## ./extlib/LWP/Protocol/ftp.pm

    ## ./extlib/LWP/Protocol/nntp.pm

    ## ./extlib/LWP/Protocol/https10.pm

    ## ./extlib/LWP/Protocol/data.pm

    ## ./extlib/LWP/Authen/Basic.pm

    ## ./extlib/LWP/Authen/Digest.pm

    ## ./extlib/HTML/Template.pm

    ## ./extlib/HTML/Form.pm

    ## ./extlib/UDDI/Lite.pm

    ## ./extlib/XMLRPC/Lite.pm

    ## ./extlib/XMLRPC/Test.pm

    ## ./extlib/XMLRPC/Transport/TCP.pm

    ## ./extlib/XMLRPC/Transport/HTTP.pm

    ## ./extlib/XMLRPC/Transport/POP3.pm

    ## ./extlib/SOAP/Lite.pm

    ## ./extlib/SOAP/Test.pm

    ## ./extlib/SOAP/Transport/IO.pm

    ## ./extlib/SOAP/Transport/TCP.pm

    ## ./extlib/SOAP/Transport/MAILTO.pm

    ## ./extlib/SOAP/Transport/FTP.pm

    ## ./extlib/SOAP/Transport/LOCAL.pm

    ## ./extlib/SOAP/Transport/MQ.pm

    ## ./extlib/SOAP/Transport/HTTP.pm

    ## ./extlib/SOAP/Transport/JABBER.pm

    ## ./extlib/SOAP/Transport/POP3.pm

    ## ./extlib/Math/BigInt.pm

    ## ./extlib/Math/BigInt/Scalar.pm

    ## ./extlib/Math/BigInt/Trace.pm

    ## ./extlib/Math/BigInt/Calc.pm

    ## ./extlib/I18N/LangTags.pm

    ## ./extlib/I18N/LangTags/List.pm

    ## ./extlib/Image/Size.pm

    ## ./extlib/CGI/Cookie.pm

    ## ./extlib/CGI/Apache.pm

    ## ./extlib/CGI/Fast.pm

    ## ./extlib/CGI/Pretty.pm

    ## ./extlib/CGI/Carp.pm

    ## ./extlib/CGI/Util.pm

    ## ./extlib/CGI/Switch.pm

    ## ./extlib/CGI/Push.pm

    ## ./t/Bar.pm

    ## ./t/Foo.pm

    ## ./t/lib/Text/WikiFormat.pm

    ## ./t/lib/LWP/UserAgent/Local.pm
);


1;

## New words: 545
