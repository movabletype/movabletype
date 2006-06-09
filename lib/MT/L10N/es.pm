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

    ## ./mt-inbox.pl

    ## ./mt-check.cgi.pre
    'Movable Type System Check' => 'Movable Type - Comprobación del Sistema',
    'This page provides you with information on your system\'s configuration and determines whether you have all of the components you need to run Movable Type.' => 'Esta página le ofrece información sobre la configuración de su sistema y determina si están instalados todos los componentes necesarios para ejecutar Movable Type.',
    'System Information:' => 'Información del sistema:',
    'Current working directory:' => 'Directorio actual de trabajo:',
    'MT home directory:' => 'Directorio de inicio de MT:',
    'Operating system:' => 'Sistema operativo:',
    'Perl version:' => 'Versión de Perl:',
    'Perl include path:' => 'Ruta de búsqueda de Perl:',
    'Web server:' => 'Servidor web:',
    '(Probably) Running under cgiwrap or suexec' => '(Probablemente) Ejecutándose sobre cgiwrap o suexec',
    'Checking for [_1] Modules:' => 'Comprobando [_1] módulos:',
    'Some of the following modules are required by the various data storage options in Movable Type. In order run the system, your server needs to have either DB_File, or else DBI and at least one of the other modules installed.' => 'Algunos de los siguientes módulos son necesarios para el almacenamiento de datos en Movable Type. Para ejecutar el sistema, su servidor necesita tener o DB_File o algún DBI y al menos uno de los otros módulos instalados.',
    'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'O su servidor no tiene instalado [_1], o la versión que tiene instalada es muy antigua, o [_1] necesita otro módulo que no está instalado.',
    'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => 'Su servidor no tiene [_1] instalado, o [_1] necesita otro módulo que no está instalado.',
    'Please consult the installation instructions for help in installing [_1].' => 'Por favor, consulte las instrucciones de instalación para obtener ayuda de cómo instalar [_1].',
    'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN.' => 'La versión de DBD::mysql que tiene instalada es conocida por ser incompatible con Movable Type. Por favor, instale la versión actual desde CPAN.',
    'Your server has [_1] installed (version [_2]).' => 'Su servidor tiene [_1] instalado (versión [_2]).',
    'Movable Type System Check Successful' => 'Comprobación del sistema correcta.',
    'You\'re ready to go!' => '¡Todo listo para continuar!',
    'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Su servidor dispone de todos los módulos requeridos; no necesita instalar ningún módulo adicional. Puede continuar con las instrucciones de instalación.',

    ## ./search_templates/default.tmpl
    'Search Results' => 'Resultado de la búsqueda',
    'Search this site:' => 'Buscar este sitio:',
    'Search' => 'Buscar',
    'Match case' => 'Distinguir mayúsculas',
    'Regex search' => 'Expresión regular',
    'Search Results from' => 'Buscar resultados de',
    'Posted in' => 'Publicado en',
    'on' => 'el',
    'Searched for' => 'Buscado por',
    'No pages were found containing' => 'No se encontraron páginas que contuvieran',
    'Instructions' => 'Instrucciones',
    'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Por defecto, este motor busca las palabras en cualquier orden. Para buscar una frase exacta, entrecomille la frase:',
    'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'El motor de búsqueda también soporta AND, OR y NOT para especificar expresiones lógicas:',
    'personal OR publishing' => 'personal OR publicación',
    'publishing NOT personal' => 'publicación NOT personal',

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
    'Posted in ' => 'Publicado en ',
    'No results found' => 'No se encontraron resultados',
    'No new comments were found in the specified interval.' => 'No se encontraron nuevos comentarios en el intervalo especificado',

    ## ./default_templates/comment_error_template.tmpl
    'Comment Submission Error' => 'Error en el envío de comentarios',
    'Your comment submission failed for the following reasons:' => 'El envío de su comentario falló por las siguientes razones:',

    ## ./default_templates/dynamic_pages_error_template.tmpl
    'Page Not Found' => 'Página no encontrada',

    ## ./default_templates/trackback_listing_template.tmpl
    ': Discussion on [_1]' => ': Discusión en [_1]',
    'Trackbacks: [_1]' => 'Trackbacks: [_1]', # Translate
    'TrackBack' => 'TrackBack', # Translate
    'TrackBack URL for this entry:' => 'URL del Trackback para esta entrada:',
    'Listed below are links to weblogs that reference' => 'Listados abajo están los enlaces de los weblogs que le referencian',
    'from' => 'desde',
    'Read More' => 'Leer más',
    'Tracked on [_1]' => 'Publicado en [_1]',
    'Search this blog:' => 'Buscar en este blog:',
    'Recent Posts' => 'Entradas recientes',
    'Subscribe to this blog\'s feed' => 'Suscribirse a este blog (XML)',
    'What is this?' => '¿Qué es esto?',
    'Creative Commons License' => 'Licencia Creative Commons',
    'This weblog is licensed under a' => 'Este weblog está licenciado bajo una',

    ## ./default_templates/individual_entry_archive.tmpl
    'Main' => 'Inicio',
    'Posted by [_1] on [_2]' => 'Publicado por [_1] en [_2]',
    'Permalink' => 'Enlace permanente',
    'Tracked on' => 'Seguido el',
    'Comments' => 'Comentarios',
    'Posted by:' => 'Publicado por:',
    'Post a comment' => 'Publicar un comentario',
    '(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(Si no dejó aquí ningún comentario anteriormente, quizás necesite aprobación por parte del dueño del sitio, antes de que el comentario aparezca. Hasta entonces, no se mostrará en la entrada. Gracias por su paciencia).',
    'Name:' => 'Nombre:',
    'Email Address:' => 'Dirección de correo-e:',
    'URL:' => 'URL:', # Translate
    'Remember personal info?' => '¿Recordar datos personales?',
    'Comments:' => 'Comentarios:',
    '(you may use HTML tags for style)' => '(puede usar etiquetas HTML para el estilo)',
    'Preview' => 'Vista previa',
    'Post' => 'Publicar',

    ## ./default_templates/main_index.tmpl
    'Continue reading' => 'Continuar leyendo',
    'Posted by [_1] at [_2]' => 'Publicado por [_1] a las [_2]',
    'TrackBacks' => 'TrackBacks', # Translate
    'Categories' => 'Categorías',
    'Archives' => 'Archivos',

    ## ./default_templates/dynamic_site_bootstrapper.tmpl

    ## ./default_templates/datebased_archive.tmpl
    'Posted by' => 'Publicado por',
    'at' => 'a las',

    ## ./default_templates/uploaded_image_popup_template.tmpl

    ## ./default_templates/category_archive.tmpl

    ## ./default_templates/master_archive_index.tmpl
    ': Archives' => ': Archivos',

    ## ./default_templates/comment_listing_template.tmpl
    'Comment on' => 'Comentado en',

    ## ./default_templates/atom_index.tmpl

    ## ./default_templates/rsd.tmpl

    ## ./default_templates/stylesheet.tmpl

    ## ./default_templates/site_javascript.tmpl
    'Thanks for signing in,' => 'Gracias por registrarse en,',
    '. Now you can comment. ' => '. Ahora puede comentar. ',
    'sign out' => 'salir',
    'You are not signed in. You need to be registered to comment on this site.' => 'No está registrado. Necesita registrarse  para comentar en este sitio.',
    'Sign in' => 'Registrarse',
    'If you have a TypeKey identity, you can' => 'Si tiene una cuenta en TypeKey, puede',
    'sign in' => 'registrarse',
    'to use it here.' => 'para usarla aquí.',

    ## ./default_templates/comment_preview_template.tmpl
    'Previewing your Comment' => 'Vista previa del comentario',
    'Anonymous' => 'Anónimo',
    'Cancel' => 'Cancelar',

    ## ./default_templates/rss_20_index.tmpl

    ## ./default_templates/comment_pending_template.tmpl
    'Comment Pending' => 'Comentario pendiente',
    'Thank you for commenting.' => 'Gracias por comentar.',
    'Your comment has been received and held for approval by the blog owner.' => 'El comentario que envió fue recibido y está retenido para su aprobación por parte del administrador del weblog.',
    'Return to the original entry' => 'Volver a la entrada original',

    ## ./lib/MT/default-templates.pl

    ## ./plugins/nofollow/nofollow.pl

    ## ./plugins/spamlookup/spamlookup_words.pl

    ## ./plugins/spamlookup/spamlookup.pl

    ## ./plugins/spamlookup/spamlookup_urls.pl

    ## ./plugins/spamlookup/tmpl/url_config.tmpl
    'Less' => 'Menos',
    'Decrease' => 'Disminuir',
    'Increase' => 'Aumentar',
    'More' => 'Más',

    ## ./plugins/spamlookup/tmpl/lookup_config.tmpl

    ## ./plugins/spamlookup/tmpl/word_config.tmpl

    ## ./plugins/TemplateRefresh/TemplateRefresh.pl

    ## ./plugins/TemplateRefresh/tmpl/results.tmpl

    ## ./t/test-common.pl

    ## ./t/test.tmpl

    ## ./t/blog-common.pl

    ## ./t/test-templates.pl

    ## ./t/driver-tests.pl

    ## ./t/plugins/testplug.pl

    ## ./tmpl/error.tmpl
    'Missing Configuration File' => 'Fichero de configuración no encontrado',
    'Database Connection Error' => 'Error de conexión a la base de datos',
    'CGI Path Configuration Required' => 'Se necesita la configuración de la ruta de CGI',
    'An error occurred' => 'Ocurrió un error',

    ## ./tmpl/cms/comment_table.tmpl
    'Status' => 'Estado',
    'Comment' => 'Comentario',
    'Commenter' => 'Comentarista',
    'Weblog' => 'Weblog', # Translate
    'Entry' => 'Entrada',
    'Date' => 'Fecha',
    'IP' => 'IP', # Translate
    'Only show published comments' => 'Mostrar solo comentarios publicados',
    'Published' => 'Publicado',
    'Only show pending comments' => 'Mostrar solo comentarios pendientes',
    'Pending' => 'Pendiente',
    'Edit this comment' => 'Editar este comentario',
    'Edit this commenter' => 'Editar este comentarista',
    'Trusted' => 'Confiado',
    'Blocked' => 'Bloqueado',
    'Authenticated' => 'Autentificado',
    'Search for comments by this commenter' => 'Buscar comentarios de este comentarista',
    'Show all comments on this entry' => 'Mostrar todos los comentarios de esta entrada',
    'Search for all comments from this IP address' => 'Buscar todos los comentarios enviados desde esta dirección IP',

    ## ./tmpl/cms/notification_actions.tmpl
    'Delete' => 'Eliminar',
    'notification address' => 'dirección de notificación', # Translate
    'notification addresses' => 'direcciones de notificación', # Translate
    'Delete selected notification addresses (d)' => 'Borrar direcciones de notificación seleccionadas (d)',

    ## ./tmpl/cms/edit_comment.tmpl
    'Edit Comment' => 'Editar comentario',
    'Your changes have been saved.' => 'Sus cambios han sido guardados.',
    'The comment has been approved.' => 'Comentario aprobado.',
    'Previous' => 'Anterior',
    'List &amp; Edit Comments' => 'Listar y editar comentarios',
    'Next' => 'Siguiente',
    'View Entry' => 'Ver entrada',
    'Pending Approval' => 'Autorización pendiente',
    'Junked Comment' => 'Comentario basura',
    'Status:' => 'Estado:',
    'Unpublished' => 'No publicado',
    'Junk' => 'Basura',
    'View all comments with this status' => 'Ver comentarios con este estado',
    'Commenter:' => 'Comentarista:',
    '(Trusted)' => '(Confiado)',
    'Ban&nbsp;Commenter' => 'Bloquear&nbsp;comentarista',
    'Untrust&nbsp;Commenter' => 'No&nbsp;confiar&nbsp;comentarista',
    'Banned' => 'Bloqueado',
    '(Banned)' => '(Bloqueado)',
    'Trust&nbsp;Commenter' => 'Confiar&nbsp;comentarista',
    'Unban&nbsp;Commenter' => 'Desbloquear&nbsp;comentarista',
    'View all comments by this commenter' => 'Ver todos los comentarios de este comentarista',
    'Email:' => 'Correo electrónico:',
    'None given' => 'No se indicó ninguno',
    'Email' => 'Correo electrónico',
    'View all comments with this email address' => 'Ver todos los comentarios de esta dirección de correo-e',
    'Link' => 'Un vínculo',
    'View all comments with this URL' => 'Ver todos los comentarios con esta URL',
    'Entry:' => 'Entrada:',
    'Entry no longer exists' => 'La entrada ya no existe.',
    'No title' => 'Sin título',
    'View all comments on this entry' => 'Ver todos los comentarios de esta entrada',
    'Date:' => 'Fecha:',
    'View all comments posted on this day' => 'Ver todos los comentarios publicados en este día',
    'IP:' => 'IP:', # Translate
    'View all comments from this IP address' => 'Ver todos los comentarios procedentes de esta dirección IP',
    'Save Changes' => 'Guardar cambios',
    'Save this comment (s)' => 'Guardar este comentario (s)',
    'Delete this comment (d)' => 'Borrar este comentario (d)',
    'Ban This IP' => 'Bloquear esta IP',
    'Final Feedback Rating' => 'Puntuación final respuestas',
    'Test' => 'Test', # Translate
    'Score' => 'Puntuación',
    'Results' => 'Resultados',
    'Plugin Actions' => 'Acciones de plugins',

    ## ./tmpl/cms/list_commenters.tmpl
    'Authenticated Commenters' => 'Comentaristas autentificados',
    'The selected commenter(s) has been given trusted status.' => 'Los comentaristas seleccionados tienen ya el estado de confianza.',
    'Trusted status has been removed from the selected commenter(s).' => 'Se eliminó el estado de confianza de los comentaristas seleccionados.',
    'The selected commenter(s) have been blocked from commenting.' => 'Se bloquearon los comentaristas seleccionados.',
    'The selected commenter(s) have been unbanned.' => 'Se desbloquearon los comentaristas seleccionados.',
    'Go to Comment Listing' => 'Ir a lista de comentarios',
    'Quickfilter:' => 'Filtro rápido:',
    'Show unpublished comments.' => 'Mostrar comentarios no publicados.',
    'Reset' => 'Reiniciar',
    'Filter:' => 'Filtrar:',
    'Showing all commenters.' => 'Mostrar todos los comentaristas.',
    'Showing only commenters whose' => 'Mostrar solo los comentaristas cuyo',
    'is' => 'es',
    'Show' => 'Mostrar',
    'all' => 'todos',
    'only' => 'solamente',
    'commenters.' => 'comentaristas.',
    'commenters where' => 'comentaristas donde',
    'status' => 'estado',
    'commenter' => 'comentarista',
    'trusted' => 'confiado',
    'untrusted' => 'no confiado',
    'banned' => 'bloqueado',
    'unauthenticated' => 'no autentificado',
    'authenticated' => 'autentificado',
    'Filter' => 'Filtro',
    'No commenters could be found.' => 'No se encontraron comentaristas.',

    ## ./tmpl/cms/bookmarklets.tmpl
    'QuickPost' => 'QuickPost', # Translate
    'Add QuickPost to Windows right-click menu' => 'Añadir QuickPost al menú contextual de Windows',
    'Configure QuickPost' => 'Configurar QuickPost',
    'Include:' => 'Incluir:',
    'TrackBack Items' => 'Elementos de TrackBack',
    'Category' => 'Categoría',
    'Allow Comments' => 'Permitir comentarios',
    'Allow TrackBacks' => 'Permitir TrackBacks',
    'Text Formatting' => 'Formato del texto',
    'Excerpt' => 'Resumen',
    'Extended Entry' => 'Entrada ampliada',
    'Keywords' => 'Palabras clave',
    'Basename' => 'Nombre base',
    'Create' => 'Crear',

    ## ./tmpl/cms/copyright.tmpl

    ## ./tmpl/cms/import.tmpl
    'Import / Export' => 'Importar / Exportar',
    'System-wide' => 'Toda la instalación',
    'Transfer weblog entries into Movable Type from other blogging tools or export your entries to create a backup or copy.' => 'Transfiera entradas a Movable Type desde otras herramientas o exporte sus entradas para crear una copia de seguridad.',
    'Import Entries' => 'Importar entradas',
    'Export Entries' => 'Exportar entradas',
    'Import entries as me' => 'Importar entradas como si fuera yo',
    'Password (required if creating new authors):' => 'Contraseña (obligatoria para crear nuevos autores):',
    'You will be assigned the author of all imported entries.  If you wish the original authors to keep ownership, you must contact your MT system administrator to perform the import so that new authors can be created if necessary.' => 'Se le registrará como autor de todas las entradas importadas. Si desea respetar la autoría original de las entradas, debe contactar con el administrador de MT para realizar la importación, y así crear los nuevos autores si fuera necesario.',
    'Default category for entries (optional):' => 'Categoría predeterminada para las entradas (opcional):',
    'Select a category' => 'Seleccione una categoría',
    'Default post status for entries (optional):' => 'Estado de publicación predeterminado para las entradas (opcional):',
    'Select a post status' => 'Seleccione un estado de publicación',
    'Start title HTML (optional):' => 'Código HTML de comienzo de título (opcional):',
    'End title HTML (optional):' => 'Código HTML de final de título (opcional):',
    'Export Entries From [_1]' => 'Exportar entradas desde [_1]',
    'Export Entries to Tangent' => 'Exportar entradas a Tangent',

    ## ./tmpl/cms/commenter_actions.tmpl
    'Trust' => 'Confianza',
    'commenters' => 'comentaristas',
    'to act upon' => 'actuar cuando',
    'Trust commenter' => 'Confiar en comentarista',
    'Untrust' => 'No confiar',
    'Untrust commenter' => 'No confiar en comentarista',
    'Ban' => 'Bloquear',
    'Ban commenter' => 'Bloquear comentarista',
    'Unban' => 'Desbloquear',
    'Unban commenter' => 'Desbloquear comentarista',
    'Trust selected commenters' => 'Confiar en comentaristas seleccionados',
    'Ban selected commenters' => 'Bloquear comentaristas seleccionados',

    ## ./tmpl/cms/list_author.tmpl
    'Authors' => 'Autores',
    'You have successfully deleted the authors from the Movable Type system.' => 'Eliminó a los autores correctamente del sistema de Movable Type.',
    'Create New Author' => 'Crear nuevo autor',
    'Username' => 'Nombre de usuario',
    'Name' => 'Nombre',
    'URL' => 'URL', # Translate
    'Created By' => 'Creado por',
    'Entries' => 'Entradas',
    'Last Entry' => 'Última entrada',
    'System' => 'Sistema',

    ## ./tmpl/cms/ping_actions.tmpl
    'pings' => 'pings', # Translate
    'to publish' => 'para publicar', # Translate
    'Publish' => 'Publicar',
    'Publish selected TrackBacks (p)' => 'Publicar TrackBacks seleccionados (p)',
    'Delete selected TrackBacks (d)' => 'Eliminar TrackBacks seleccionados (d)',
    'Junk selected TrackBacks (j)' => 'Marcar como basura los TrackBacks seleccionados (j)',
    'Not Junk' => 'No es basura',
    'Recover selected TrackBacks (j)' => 'Recuperar TrackBacks seleccionados (j)',

    ## ./tmpl/cms/blog-left-nav.tmpl
    'Posting' => 'Publicación',
    'Create New Entry' => 'Crear nueva entrada',
    'New Entry' => 'Nueva entrada',
    'List Entries' => 'Listar entradas',
    'Upload File' => 'Transferir fichero',
    'Community' => 'Comunidad',
    'List Comments' => 'Listar comentarios',
    'List Commenters' => 'Listar comentaristas',
    'Commenters' => 'Comentaristas',
    'List TrackBacks' => 'Listar TrackBacks',
    'Edit Notification List' => 'Editar lista de notificaciones',
    'Notifications' => 'Notificaciones',
    'Configure' => 'Configurar',
    'List &amp; Edit Templates' => 'Listar y editar plantillas',
    'Templates' => 'Plantillas',
    'Edit Categories' => 'Editar categorías',
    'Edit Weblog Configuration' => 'Editar configuración del weblog',
    'Settings' => 'Configuración',
    'Utilities' => 'Herramientas',
    'Search &amp; Replace' => 'Buscar &amp; Reemplazar',
    'View Activity Log' => 'Ver registro de actividades',
    'Activity Log' => 'Registro de actividades',
    'Import &amp; Export Entries' => 'Importar &amp; Exportar entradas',
    'Rebuild Site' => 'Regenerar sitio',
    'View Site' => 'Ver sitio',

    ## ./tmpl/cms/list_blog.tmpl
    'Movable Type News' => 'Noticias de Movable Type',
    'System Shortcuts' => 'Atajos del sistema',
    'Weblogs' => 'Weblogs', # Translate
    'Concise listing of weblogs.' => 'Lista concisa de weblogs.',
    'Create, manage, set permissions.' => 'Crear, administrar, establecer permisos.',
    'Plugins' => 'Plugins', # Translate
    'What\'s installed, access to more.' => 'Qué está instalado, acceder a otros.',
    'Multi-weblog entry listing.' => 'Lista de entradas multi-weblog.',
    'Multi-weblog comment listing.' => 'Lista de comentarios multi-weblog.',
    'Multi-weblog TrackBack listing.' => 'Lista de TrackBacks multi-weblog.',
    'System-wide configuration.' => 'Configuración del sistema.',
    'Find everything. Replace anything.' => 'Encontrar todo. Reemplazar cualquier cosa.',
    'What\'s been happening.' => 'Qué sucede.',
    'Status &amp; Info' => 'Estado &amp; información',
    'Server status and information.' => 'Estado e información del servidor.',
    'Set Up A QuickPost Bookmarklet' => 'Configurar QuickPost',
    'Enable one-click publishing.' => 'Habilitar publicación de un solo clic.',
    'My Weblogs' => 'Mis weblogs',
    'Warning' => 'Alerta',
    'Important:' => 'Importante:',
    'Configure this weblog.' => 'Configurar este weblog.',
    'Create a new entry' => 'Crear una nueva entrada',
    'on this weblog' => 'en este weblog',
    'Show Display Options' => 'Mostrar opciones de visualización',
    'Display Options' => 'Opciones de visualización',
    'Sort By:' => 'Ordenar por:',
    'Weblog Name' => 'Nombre del weblog',
    'Creation Order' => 'Orden de creación',
    'Last Updated' => 'Últimas actualizaciones',
    'Order:' => 'Orden:',
    'Ascending' => 'Ascendente',
    'Descending' => 'Descendente',
    'View:' => 'Ver:',
    'Compact' => 'Compacto',
    'Expanded' => 'Expandido',
    'Save' => 'Guardar',

    ## ./tmpl/cms/reload_opener.tmpl

    ## ./tmpl/cms/edit_template.tmpl
    'Edit Template' => 'Editar plantilla',
    'Your template changes have been saved.' => 'Se guardaron sus cambios en las plantillas.',
    'Rebuild this template' => 'Regenerar esta plantilla',
    'Build Options' => 'Opciones de generación',
    'Enable dynamic building for this template' => 'Permitir la generación dinámica para esta plantilla',
    'Rebuild this template automatically when rebuilding index templates' => 'Reconstruir automáticamente esta plantilla al reconstruir plantillas de índices',
    'Template Name' => 'Nombre de la plantilla',
    'Comment Listing Template' => 'Plantilla de listado de comentarios',
    'Comment Preview Template' => 'Plantilla de previsualización de comentarios',
    'Comment Error Template' => 'Plantilla de errores de comentarios',
    'Comment Pending Template' => 'Plantilla de comentarios pendientes',
    'Commenter Registration Template' => 'Plantilla de registro de comentaristas',
    'TrackBack Listing Template' => 'Plantilla de listas de TrackBack',
    'Uploaded Image Popup Template' => 'Plantilla de ventana emergente de imágenes transferidas',
    'Dynamic Pages Error Template' => 'Plantilla de errores de páginas dinámicas',
    'Output File' => 'Fichero de salida',
    'Link this template to a file' => 'Enlazar esta plantilla a un archivo',
    'Module Body' => 'Cuerpo del módulo',
    'Template Body' => 'Cuerpo de la plantilla',
    'Save this template (s)' => 'Guardar esta plantilla (s)',
    'Save and Rebuild' => 'Guardar y reconstruir',
    'Save and rebuild this template (r)' => 'Guadar y reconstruir esta plantilla (r)',

    ## ./tmpl/cms/junk_results.tmpl
    'Find Junk' => 'Buscar en basura',
    'Approved' => 'Autorizado',
    'Registered Commenter' => 'Comentarista registrado',

    ## ./tmpl/cms/entry_actions.tmpl
    'Save these entries (s)' => 'Guardar estas entradas (s)',
    'Save this entry (s)' => 'Guardar esta entrada (s)',
    'Preview this entry (p)' => 'Vista previa de esta entrada (p)',
    'entry' => 'entrada',
    'entries' => 'entradas', # Translate
    'Delete this entry (d)' => 'Eliminar esta entrada (d)',
    'to rebuild' => 'para reconstruir', # Translate
    'Rebuild' => 'Regenerar',
    'Rebuild selected entries (r)' => 'Regenerar entradas seleccionadas (r)',
    'Delete selected entries (d)' => 'Eliminar entradas seleccionadas (d)',

    ## ./tmpl/cms/edit_blog.tmpl
    'You must set your Local Site Path.' => 'Debe definir la ruta local de su sitio.',
    'You must set your Site URL.' => 'Debe definir la URL de su sitio.',
    'You did not select a timezone.' => 'No seleccionó ninguna zona horaria.',
    'New Weblog Settings' => 'Configuración del nuevo weblog',
    'From this screen you can specify the basic information needed to create a weblog.  Once you click the save button, your weblog will be created and you can continue to customize its settings and templates, or just simply start posting.' => 'Desde esta ventana puede especificar la información básica necesaria para crear un weblog. Una vez haga clic en el botón de guardar, su weblog se creará y podrá continuar para personalizar su configuración y plantilla, o simplemente comenzar a publicar.',
    'Your weblog configuration has been saved.' => 'Las configuración de su weblog ha sido guardada.',
    'Weblog Name:' => 'Nombre del weblog:',
    'Name your weblog. The weblog name can be changed at any time.' => 'Asigne un nombre a su weblog. El nombre del weblog se puede cambiar en cualquier momento.',
    'Site URL:' => 'URL del sitio:',
    'Enter the URL of your public website. Do not include a filename (i.e. exclude index.html).' => 'Introduzca la URL de su sitio web público. No incluya un nombre de archivo (es decir, excluya index.html).',
    'Example:' => 'Ejemplo:',
    'Site root:' => 'Raíz del sitio:',
    'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'Introduzca la ruta donde se encontrará el fichero índice principal. Es preferible indicar una ruta absoluta (que comience por \'/\'), pero también puede utilizar una ruta relativa al directorio de Movable Type.',
    'Timezone:' => 'Zona horaria:',
    'Time zone not selected' => 'No hay ninguna zona horaria seleccionada.',
    'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (Nueva Zelanda, horario de verano)',
    'UTC+12 (International Date Line East)' => 'UTC+12 (Línea internacional de cambio de fecha, Este)',
    'UTC+11' => 'UTC+11', # Translate
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

    ## ./tmpl/cms/author_actions.tmpl
    'author' => 'autor',
    'authors' => 'authres', # Translate
    'Delete selected authors (d)' => 'Eliminar autores seleccionados (d)',

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
    'Title' => 'Título',
    'Entry Body' => 'Cuerpo de la entrada',
    'Comment Text' => 'Comentario',
    'E-mail Address' => 'Correo electrónico',
    'IP Address' => 'Dirección IP',
    'Email Address' => 'Dirección de correo electrónico',
    'Source URL' => 'URL origen',
    'Blog Name' => 'Nombre del blog',
    'Text' => 'Texto',
    'Output Filename' => 'Fichero salida',
    'Linked Filename' => 'Fichero enlazado',
    'Log Message' => 'Mensaje del registro',
    'Date Range:' => 'Rango de fechas:',
    'From:' => 'Desde:',
    'To:' => 'A:',
    'Replaced [_1] records successfully.' => 'Reemplazados con éxito [_1] registros.',
    'No entries were found that match the given criteria.' => 'No se encontraron entradas que coincidieran con el criterio de búsqueda.',
    'No comments were found that match the given criteria.' => 'No se encontraron comentarios que coincidieran con el criterio de búsqueda.',
    'No TrackBacks were found that match the given criteria.' => 'No se encontraron TrackBacks que coincidieran con el criterio de búsqueda.',
    'No commenters were found that match the given criteria.' => 'No se encontraron comentaristas que coincidieran con el criterio de búsqueda.',
    'No templates were found that match the given criteria.' => 'No se encontraron plantillas que coincidieran con el criterio de búsqueda.',
    'No log messages were found that match the given criteria.' => 'No se encontraron mensajes del histórico que coincidieran con el criterio de búsqueda.',
    'Showing first [_1] results.' => 'Primeros [_1] resultados.',
    'Show all matches' => 'Mostrar todos los resultados',
    '[_1] result(s) found.' => '[_1] resultado/s encontrado/s.',

    ## ./tmpl/cms/import_start.tmpl
    'Importing...' => 'Importando...',
    'Importing entries into blog' => 'Importando entradas en el blog',
    'Importing entries as author \'[_1]\'' => 'Importando entradas como autor \'[_1]\'',
    'Creating new authors for each author found in the blog' => 'Creando nuevos autores para cada autor encontrado en el blog',

    ## ./tmpl/cms/log_actions.tmpl
    'Reset Activity Log' => 'Reiniciar registro de actividades',

    ## ./tmpl/cms/log_table.tmpl

    ## ./tmpl/cms/edit_ping.tmpl
    'Edit TrackBack' => 'Editar TrackBack',
    'The TrackBack has been approved.' => 'Se aprobó el TrackBack.',
    'List &amp; Edit TrackBacks' => 'Listar &amp; editar TrackBacks',
    'Junked TrackBack' => 'TrackBack basura',
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
    'Delete this TrackBack (d)' => 'Eliminar este TrackBack (d)',

    ## ./tmpl/cms/cfg_entries.tmpl
    'New Entry Default Settings' => 'Configuración por defecto de nuevas entradas',
    'This screen allows you to control default settings for new entries as well as your publicity and remote interface settings.' => 'Esta pantalla le permite controlar las opciones por defecto de las nuevas entradas, así como la configuración de la publicidad y el interfaz remoto.',
    'General' => 'General', # Translate
    'New Entry Defaults' => 'Valores por defecto de las nuevas entradas',
    'Feedback' => 'Respuestas',
    'Publishing' => 'Publicación',
    'IP Banning' => 'Bloqueo de IPs',
    'Your blog preferences have been saved.' => 'Las preferencias de su weblog han sido guardadas.',
    'Default Settings for New Entries' => 'Configuración por defecto de nuevas entradas',
    'Post Status' => 'Estado de la publicación',
    'Specifies the default Post Status when creating a new entry.' => 'Especifica el estado de publicación predeterminado para las nuevas entradas.',
    'Specifies the default Text Formatting option when creating a new entry.' => 'Especifica el formato de texto predeterminado para las entradas nuevas.',
    'Accept Comments' => 'Aceptar comentarios',
    'Specifies the default Accept Comments setting when creating a new entry.' => 'Indica el valor predefinido para la opción Aceptar comentarios al crear nuevas entradas.',
    'Setting Ignored' => 'Opción ignorada',
    'Note: This option is currently ignored since comments are disabled either weblog or system-wide.' => 'Nota: Esta opción se ignora actualmente, ya que los comentarios están desactivados o en el weblog o en todo el sistema.',
    'Accept TrackBacks:' => 'Aceptar TrackBacks:',
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
    'If you have received a recently updated key (by virtue of your purchase or donation), enter it here.' => 'Si ha recibido una clave de Actualizaciones recientes (en virtud de su compra o donación), introdúzcala aquí.',
    'TrackBack Auto-Discovery' => 'Autodescubrimiento de TrackBacks',
    'Enable External TrackBack Auto-Discovery' => 'Habilitar autodescubrimiento de TrackBacks externos',
    'Note: The above option is currently ignored since outbound pings are disabled system-wide.' => 'Nota: La configuración de arriba se ignora actualmente debido a que los pings salientes están desactivados a nivel del sistema.',
    'Enable Internal TrackBack Auto-Discovery' => 'Habilitar autodescubrimiento de TrackBacks internos',
    'If you turn on auto-discovery, when you write a new post, any external links will be extracted and the appropriate sites automatically sent TrackBacks.' => 'Si activa el autodescubrimiento, al escribir una nueva entrada, se extraerán los enlaces externos y se enviará TrackBacks de forma automática a aquellos que lo aceptan.',
    'Save changes (s)' => 'Guardar cambios (s)',

    ## ./tmpl/cms/header-popup.tmpl
    'Movable Type Publishing Platform' => 'Movable Type Publishing Platform', # Translate

    ## ./tmpl/cms/template_actions.tmpl
    'template' => 'plantilla', # Translate
    'templates' => 'plantillas', # Translate

    ## ./tmpl/cms/list_entry.tmpl
    'Open power-editing mode' => 'Abrir modo de edición avanzado',
    'Your entry has been deleted from the database.' => 'Se eliminó su entrada de la base de datos.',
    'Show unpublished entries.' => 'Mostrar entradas no publicadas.',
    'Showing all entries.' => 'Mostrar todas las entradas.',
    'Showing only entries where' => 'Mostrar solo las entradas donde',
    'entries.' => 'entradas.',
    'entries where' => 'entradas donde',
    'category' => 'categoría',
    'published' => 'publicado',
    'unpublished' => 'no publicado',
    'scheduled' => 'programado',
    'No entries could be found.' => 'No se encontraron entradas.',

    ## ./tmpl/cms/edit_categories.tmpl
    'Your category changes and additions have been made.' => 'Se guardaron los cambios y nuevas categorías.',
    'You have successfully deleted the selected categories.' => 'Se eliminaron correctamente las categorías seleccionadas.',
    'Create new top level category' => 'Crear nueva categoría de nivel superior',
    'Actions' => 'Acciones',
    'Create Category' => 'Crear categoría',
    'Top Level' => 'Nivel superior',
    'Collapse' => 'Contraer',
    'Expand' => 'Ampliar',
    'Create Subcategory' => 'Crear subcategoría',
    'Move Category' => 'Trasladar categoría',
    'Move' => 'Trasladar',
    '[quant,_1,entry,entries]' => '[quant,_1,entrada,entradas]',
    '[quant,_1,TrackBack]' => '[quant,_1,TrackBack]', # Translate
    'Delete selected categories (d)' => 'Eliminar categorías seleccionadas (d)',

    ## ./tmpl/cms/pending_commenter.tmpl

    ## ./tmpl/cms/footer.tmpl

    ## ./tmpl/cms/pinging.tmpl
    'Pinging sites...' => 'Enviando pings a sitios...',

    ## ./tmpl/cms/edit_commenter.tmpl
    'Commenter Details' => 'Detalles del comentarista',
    'The commenter has been trusted.' => 'El comentarista ahora es de confianza.',
    'The commenter has been banned.' => 'Se bloqueó al comentarista.',
    'Junk Comments' => 'Comentarios basura',
    'View all comments with this name' => 'Mostrar todos los comentarios con este nombre',
    'Identity:' => 'Identidad:',
    'Withheld' => 'Retener',
    'View all comments with this URL address' => 'Ver todos los comentarios con esta URL',
    'View all commenters with this status' => 'Mostrar todos los comentaristas con este estado',

    ## ./tmpl/cms/notification_table.tmpl
    'Date Added' => 'Fecha de creación',

    ## ./tmpl/cms/edit_placements.tmpl
    'The secondary categories for this entry have been updated. You will need to SAVE the entry for these changes to be reflected on your public site.' => 'Las categorías secundarias de esta entrada fueron actualizadas. Para que estos cambios se reflejen en su sitio público, deberá GUARDAR la entrada.',
    'Categories in your weblog:' => 'Categorías en su weblog:',
    'Secondary categories:' => 'Categorías secundarias:',
    'Close' => 'Cerrar',

    ## ./tmpl/cms/entry_prefs.tmpl
    'Your entry screen preferences have been saved.' => 'Sus preferencias de pantalla de entrada fueron guardadas.',
    'Field Configuration' => 'Configuración de campos',
    '(Help?)' => '(¿Ayuda?)',
    'Basic' => 'Básica',
    'Advanced' => 'Avanzada',
    'Custom: show the following fields:' => 'Personalizada: mostrar los siguientes campos:',
    'Editable Authored On Date' => 'Fecha de autoría editable',
    'Outbound TrackBack URLs' => 'URLs de TrackBacks salientes',
    'Button Bar Position' => 'Posición de la barra de botones',
    'Top of the page' => 'Parte superior de la página',
    'Bottom of the page' => 'Parte inferior de la página',
    'Top and bottom of the page' => 'Cabecera y pie de la página',

    ## ./tmpl/cms/pager.tmpl
    'Show:' => 'Mostrar:',
    '[quant,_1,row]' => '[quant,_1,fila]',
    'all rows' => 'todas las filas',
    'Another amount...' => 'Otra cantidad...',
    'Actions:' => 'Acciones:',
    'Below' => 'Debajo',
    'Above' => 'Arriba',
    'Both' => 'Ambos',
    'Date Display:' => 'Fecha:',
    'Relative' => 'Relativo',
    'Full' => 'Completo',
    'Newer' => 'Más reciente',
    'Showing:' => 'Mostrando:',
    'of' => 'de',
    'Older' => 'Más antiguo',

    ## ./tmpl/cms/commenter_table.tmpl
    'Identity' => 'Identidad',
    'Most Recent Comment' => 'Comentario más reciente',
    'Only show trusted commenters' => 'Mostrar solo comentaristas confiados',
    'Only show banned commenters' => 'Mostrar solo comentaristas bloqueados',
    'Only show neutral commenters' => 'Mostrar solo comentaristas neutrales',
    'View this commenter\'s profile' => 'Mostrar perfil del comentarista',

    ## ./tmpl/cms/rebuild-stub.tmpl
    'To see the changes reflected on your public site, you should rebuild your site now.' => 'Para ver reflejados los cambios en su sitio público, debe reconstruir ahora su sitio.',
    'Rebuild my site' => 'Regenerar mi sitio',

    ## ./tmpl/cms/cfg_prefs.tmpl
    'General Settings' => 'Configuración general',
    'This screen allows you to control general weblog settings, default weblog display settings, and third-party service settings.' => 'Esta pantalla le permite modificar las configuración general del weblog y de servicios externos.',
    'Weblog Settings' => 'Configuración del weblog',
    'Description:' => 'Descripción:',
    'Enter a description for your weblog.' => 'Teclee la descripción de su weblog.',
    'Default Weblog Display Settings' => 'Preferencias',
    'Entries to Display:' => 'Entradas a mostrar:',
    'Days' => 'Días',
    'Select the number of days\' entries or the exact number of entries you would like displayed on your weblog.' => 'Seleccione el número de días o el número exacto de entradas que desea que mostrar en su weblog.',
    'Entry Order:' => 'Orden de entradas:',
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
    'Suomi' => 'Suomi', # Translate
    'Swedish' => 'Sueco',
    'Select the language in which you would like dates on your blog displayed.' => 'Seleccione el idioma en el que desea que se visualicen las fechas en su weblog.',
    'Limit HTML Tags:' => 'Limitar etiquetas HTML:',
    'Use defaults' => 'Utilizar valores predeterminados',
    '([_1])' => '([_1])', # Translate
    'Use my settings' => 'Utilizar mis preferencias',
    'Specifies the list of HTML tags allowed by default when cleaning an HTML string (a comment, for example).' => 'Especifica la lista etiquetas HTML que se permiten por defecto en la limpieza de una cadena HTML (un comentario, por ejemplo).',
    'Third-Party Services' => 'Servicios externos',
    'Creative Commons License:' => 'Licencia de Creative Commons:',
    'Your weblog is currently licensed under:' => 'En la actualidad, su weblog está sujeto a la licencia:',
    'Change your license' => 'Cambiar su licencia',
    'Remove this license' => 'Eliminar esta licencia',
    'Your weblog does not have an explicit Creative Commons license.' => 'Su weblog no dispone de una licencia  explícita de Creative Commons.',
    'Create a license now' => 'Crear una licencia ahora',
    'Select a Creative Commons license for the posts on your blog (optional).' => 'Seleccione una licencia de Creative Commons para las contribuciones de su weblog (opcional).',
    'Be sure that you understand these licenses before applying them to your own work.' => 'Asegúrese de comprender el contenido de estas licencias antes de que las aplica a sus trabajos.',
    'Read more.' => 'Más información.',
    'Google API Key:' => 'Clave para la API de Google:',
    'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.' => 'Si desea utilizar cualquier funcionalidad de la API de Google, deberá disponer de la clave correspondiente. Cópiela y péguela aquí.',

    ## ./tmpl/cms/rebuild_confirm.tmpl
    'Select the type of rebuild you would like to perform. (Click the Cancel button if you do not want to rebuild any files.)' => 'Seleccione el tipo de reconstrucción  que desea realizar (haga clic en el botón Cancelar si no desea reconstruir ningún fichero).',
    'Rebuild All Files' => 'Regenerar todos los ficheros',
    'Index Template: [_1]' => 'Plantilla índice: [_1]',
    'Rebuild Indexes Only' => 'Regenerar sólo los índices',
    'Rebuild [_1] Archives Only' => 'Regenerar sólo [_1] archivos',
    'Rebuild (r)' => 'Regenerar (r)',

    ## ./tmpl/cms/ping_table.tmpl
    'From' => 'Origen',
    'Target' => 'Destino',
    'Only show published TrackBacks' => 'Mostrar solo TrackBacks publicados',
    'Only show pending TrackBacks' => 'Mostrar solo TrackBacks pendientes',
    'Edit this TrackBack' => 'Editar este TrackBack',
    'Go to the source entry of this TrackBack' => 'Ir a la entrada de origen de este TrackBack',
    'View the [_1] for this TrackBack' => 'Mostrar [_1] de este TrackBack',

    ## ./tmpl/cms/edit_entry.tmpl
    'Add new category...' => 'Crear nueva categoría...',
    'Edit Entry' => 'Editar entrada',
    'Your entry has been saved. You can now make any changes to the entry itself, edit the authored-on date, edit comments, or send a notification.' => 'Su entrada ha sido guardada. Ahora puede realizar cualquier cambio en la propia entrada, editar la fecha de autoría, editar los comentarios o enviar una notificación.',
    'One or more errors occurred when sending update pings or TrackBacks.' => 'Ocurrieron uno o más errores durante el envío de pings o TrackBacks.',
    'Your customization preferences have been saved, and are visible in the form below.' => 'Se guardaron los cambios en las preferencias y pueden verse en el siguiente formulario.',
    'Your changes to the comment have been saved.' => 'Se guardaron sus cambios al comentario.',
    'Your notification has been sent.' => 'Se envió su notificación.',
    'You have successfully deleted the checked comment(s).' => 'Eliminó correctamente los comentarios marcados.',
    'You have successfully deleted the checked TrackBack(s).' => 'Eliminó correctamente los TrackBacks marcados.',
    'List &amp; Edit Entries' => 'Enumerar y editar entradas',
    'Comments ([_1])' => 'Comentarios ([_1])',
    'TrackBacks ([_1])' => 'TrackBacks ([_1])', # Translate
    'Notification' => 'Notificación',
    'Scheduled' => 'Programado',
    'Primary Category' => 'Categoría principal',
    'Assign Multiple Categories' => 'Asignar múltiples categorías',
    'Bold' => 'Negrita',
    'Italic' => 'Cursiva',
    'Underline' => 'Subrayado',
    'Insert Link' => 'Insertar vínculo',
    'Insert Email Link' => 'Insertar enlace correo-e',
    'Quote' => 'Cita',
    'Authored On' => 'Fecha de autoría',
    'Unlock this entry\'s output filename for editing' => 'Desbloquear para la edición el nombre fichero de salida de esta entrada',
    'Warning: If you set the basename manually, it may conflict with another entry.' => 'Atención: Si introduce el nombre base manualmente, podría entrar en conflicto con otra entrada.',
    'Warning: Changing this entry\'s basename may break inbound links.' => 'Atención: Si cambia el nombre base de la entrada, podría romper enlaces entrantes.',
    'Accept TrackBacks' => 'Aceptar TrackBacks',
    'View Previously Sent TrackBacks' => 'Ver TrackBacks enviados anteriormente',
    'Customize the display of this page.' => 'Personalizar la visualización de esta página.',
    'Manage Comments' => 'Administrar comentarios',
    'Click on the author\'s name to edit the comment. To delete a comment, check the box to its right and then click the Delete button.' => 'Para editar el comentario, haga clic en el nombre del autor. Para eliminar un comentario, active la casilla a su derecha y haga clic en el botón Eliminar.',
    'No comments exist for this entry.' => 'No existen comentarios en esta entrada.',
    'Manage TrackBacks' => 'Administrar TrackBacks',
    'Click on the TrackBack title to view the page. To delete a TrackBack, check the box to its right and then click the Delete button.' => 'Haga clic en el título del TrackBack para ver la página. Para borrar un TrackBack, haga clic en la casilla a su derecha y luego haga clic en el botón Eliminar.',
    'No TrackBacks exist for this entry.' => 'No existen TrackBacks en esta entrada.',
    'Send a Notification' => 'Enviar notificación',
    'You can send a notification message to your group of readers. Just enter the email message that you would like to insert below the weblog entry\'s link. You have the option of including the excerpt indicated above or the entry in its entirety.' => 'Puede enviar un mensaje de notificación a su grupo de lectores. Basta con escribir el mensaje de correo electrónico que le gustaría insertar bajo el enlace de la entrada del weblog. Puede elegir entre enviar el resumen indicado arriba o la entrada en su totalidad.',
    'Include excerpt' => 'Incluir resumen',
    'Include entire entry body' => 'Incluir la entrada completa',
    'Note: If you chose to send the weblog entry, all added HTML will be included in the email.' => 'Nota: Si eligió enviar la entrada del weblog, se incluirá todo el HTML agregado en el correo electrónico.',
    'Send' => 'Enviar',

    ## ./tmpl/cms/entry_table.tmpl
    'Author' => 'Autor',
    'Only show unpublished entries' => 'Mostrar solo entradas no publicadas',
    'Only show published entries' => 'Mostrar solo entradas publicadas',
    'Only show future entries' => 'Mostrar solo entradas diferidas',
    'Future' => 'Futuro',
    'None' => 'Ninguno',

    ## ./tmpl/cms/pinged_urls.tmpl
    'Here is a list of the previous TrackBacks that were successfully sent:' => 'Aquí se muestra una lista de los TrackBacks que se enviaron correctamente:',

    ## ./tmpl/cms/view_log.tmpl
    'The Movable Type activity log contains a record of notable actions in the system.' => 'El registro de actividad de Movable Type contiene un registro de las acciones más relevantes del sistema.',
    'All times are displayed in GMT' => 'Todas las fechas se muestran en GMT',
    'All times are displayed in GMT.' => 'Todas las fechas se muestran en GMT.',
    'Export in CSV format.' => 'Exportar en formato CSV.',
    'The activity log has been reset.' => 'Se reinició el registro de actividades.',
    'No log entries could be found.' => 'No se encontraron entradas del histórico.',

    ## ./tmpl/cms/spam_confirm.tmpl
    'These domain names were found in the selected comments. Check the box at right to block comments and trackbacks containing that URL in the future.' => 'Se encontraron estos dominios en los comentarios seleccionados. Marque las casillas de la derecha para bloquear en el futuro los comentarios y trackbacks que contienen esta URL.',
    'Block' => 'Bloquear',

    ## ./tmpl/cms/preview_entry.tmpl
    'Re-Edit this entry' => 'Volver a editar esta entrada',
    'Save this entry' => 'Guardar esta entrada',

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

    ## ./tmpl/cms/blog_actions.tmpl
    'weblog' => 'weblog', # Translate
    'weblogs' => 'weblogs', # Translate
    'Delete selected weblogs (d)' => 'Eliminar weblogs seleccionados (d)',

    ## ./tmpl/cms/edit_permissions.tmpl
    'Author Permissions' => 'Permisos',
    'Your changes to [_1]\'s permissions have been saved.' => 'Se han guardado los permisos de [_1].',
    '[_1] has been successfully added to [_2].' => '[_1] se ha agregado correctamente a [_2].',
    'Permissions' => 'Permisos',
    'General Permissions' => 'Permisos generales',
    'System Administrator' => 'Administrador del sistema',
    'User can create weblogs' => 'El usuario puede crear weblogs',
    'User can view activity log' => 'El usuario puede ver el registro de actividades',
    'Check All' => 'Seleccionar todos',
    'Uncheck All' => 'Deseleccionar todos',
    'Weblog:' => 'Weblog:', # Translate
    'Unheck All' => 'Deselseccionar todos', # Translate
    'Add user to an additional weblog:' => 'Asignar usuario a otro weblog:',
    'Select a weblog' => 'Seleccionar un weblog',
    'Add' => 'Crear',
    'Profile' => 'Perfil',
    'Save permissions for this author (s)' => 'Guardar permisos de este/os autor/es',

    ## ./tmpl/cms/cfg_feedback.tmpl
    'Feedback Settings' => 'Configuración de respuestas',
    'This screen allows you to control the feedback settings for this weblog, including comments and TrackBacks.' => 'Esta pantalla le permite modificar la configuración de las respuestas en su weblog, que incluye los comentarios y TrackBacks.',
    'Your feedback preferences have been saved.' => 'Se guardaron las preferencias de las respuestas.',
    'Rebuild indexes' => 'Regenerar índices',
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
    'Off' => 'Desactivar',
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

    ## ./tmpl/cms/list_notification.tmpl
    'Below is the list of people who wish to be notified when you post to your site. To delete an address, check the Delete box and press the Delete button.' => 'A continuación se muestra la lista de personas que desean recibir una notificación cuando publique en su sitio. Para eliminar una dirección, active la casilla Eliminar y presione el botón Eliminar.',
    'You have [quant,_1,user,users,no users] in your notification list.' => 'Tiene [quant,_1,usuario,usuarios,0 usuarios] en su lista de notificaciones.',
    'You have added [_1] to your notification list.' => 'Ha agregado [_1] a su lista de notificaciones.',
    'You have successfully deleted the selected notifications from your notification list.' => 'Eliminó correctamente las notificaciones seleccionadas de la lista.',
    'Create New Notification' => 'Crear notificación',
    'URL (Optional):' => 'URL (opcional):',
    'Add Recipient' => 'Añadir receptor',
    'No notifications could be found.' => 'No se encontró ninguna notificación.',

    ## ./tmpl/cms/show_upload_html.tmpl
    'Copy and paste this HTML into your entry.' => 'Copiar y pegar el siguiente código HTML en su entrada.',
    'Upload Another' => 'Transferir otra',

    ## ./tmpl/cms/template_table.tmpl
    'Dynamic' => 'Dinámico',
    'Linked' => 'Enlazado',
    'Built w/Indexes' => 'Generar con índices',
    'Yes' => 'Sí',
    'No' => 'No', # Translate

    ## ./tmpl/cms/login.tmpl
    'Your Movable Type session has ended. If you wish to log in again, you can do so below.' => 'Finalizó su sesión en Movable Type. Si desea volver a iniciar una sesión, puede hacerlo debajo.',
    'Your Movable Type session has ended. Please login again to continue this action.' => 'Finalizó su sesión en Movable. Por favor, iníciela de nuevo para continuar esta acción.',
    'Password' => 'Contraseña',
    'Remember me?' => '¿Recordarme?',
    'Log In' => 'Iniciar sesión',
    'Forgot your password?' => 'Olvidó su contraseña?',

    ## ./tmpl/cms/edit_category.tmpl
    'Use this page to edit the attributes of the category [_1]. You can set a description for your category to be used in your public pages, as well as configuring the TrackBack options for this category.' => 'Utilice esta página para editar los atributos de la categoría [_1]. Puede configurar una descripción para su categoría que se utilizará en sus páginas públicas, así como configurar las opciones de TrackBack para esta categoría.',
    'Your category changes have been made.' => 'Los cambios en la categoría se han guardado.',
    'Category Label' => 'Etiqueta de la categoría',
    'Category Description' => 'Descripción de la categoría',
    'TrackBack Settings' => 'Ajustes de TrackBack',
    'Outbound TrackBacks' => 'TrackBacks salientes',
    'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you post an entry in this category. (Separate URLs with a carriage return.)' => 'Introduzca las URLs de los sitios a los que desee notificar al publicar una entrada en esta categoría. (URLs separadas por un retorno de carro).',
    'Inbound TrackBacks' => 'TrackBacks entradas',
    'Accept inbound TrackBacks?' => '¿Aceptar TrackBacks?',
    'View the inbound TrackBacks on this category.' => 'Mostrar los TrackBacks entrantes de esta categoría.',
    'Passphrase Protection (Optional)' => 'Protección mediante contraseña (opcional)',
    'TrackBack URL for this category' => 'URL de TrackBack para esta categoría',
    'This is the URL that others will use to send TrackBacks to your weblog. If you wish for anyone to send TrackBacks to your weblog when they have a post specific to this category, post this URL publicly. If you choose to only allow a select group of individuals to TrackBack, send this URL to them privately.' => 'Esta es la URL que usarán otras personas para enviar TrackBacks a su weblog. Si desea que cualquiera pueda enviar TrackBacks a su weblog cuando publiquen una entrada relacionada con esta categoría, anuncie esta URL. Si desea seleccionar solo un conjunto de individuos, envíeles esta URL de forma privada.',
    'To include a list of incoming TrackBacks in your Main Index Template, check the documentation for template tags related to TrackBacks.' => 'Para incluir una lista de TrackBacks entrantes en su plantilla índice principal, consulte la documentación de las etiquetas de plantillas relacionadas con los TrackBacks.',

    ## ./tmpl/cms/cc_return.tmpl

    ## ./tmpl/cms/bm_posted.tmpl
    'Your new entry has been saved to [_1]' => 'Su nueva entrada se guardó en [_1]',
    ', and it has been posted to your site' => ' e insertado en su sitio.',
    'View your site' => 'Ver su sitio',
    'Edit this entry' => 'Editar esta entrada',

    ## ./tmpl/cms/handshake_return.tmpl

    ## ./tmpl/cms/category_add.tmpl
    'Add A Category' => 'Crear una categoría',
    'To create a new category, enter a title in the field below, select a parent category, and click the Add button.' => 'Para crear una nueva categoría, introduzca un título en el campo siguiente, seleccione una categoría superior y haga clic en el botón Crear.',
    'Category Title:' => 'Título de la categoría:',
    'Parent Category:' => 'Categoría superior:',

    ## ./tmpl/cms/list_banlist.tmpl
    'IP Banning Settings' => 'Bloqueo de IPs',
    'This screen allows you to ban comments and TrackBacks from specific IP addresses.' => 'Esta pantalla le permite bloquear comentarios y TrackBacks desde IPs específicas.',
    'You have banned [quant,_1,address,addresses].' => 'Bloqueó [quant,_1,la dirección,las direcciones].',
    'You have added [_1] to your list of banned IP addresses.' => 'Agregó [_1] a su lista de direcciones IP bloqueadas.',
    'You have successfully deleted the selected IP addresses from the list.' => 'Eliminó correctamente las direcciones IP seleccionadas.',
    'Ban New IP Address' => 'Bloquear nueva IP',
    'IP Address:' => 'Dirección IP:',
    'Ban IP Address' => 'Bloquear dirección IP',
    'Date Banned' => 'Fecha de bloqueo',

    ## ./tmpl/cms/admin.tmpl
    'System Stats' => 'Estadísticas del sistema',
    'Active Authors' => 'Autores activos',
    'Version' => 'Versión',
    'Essential Links' => 'Enlaces esenciales',
    'System Information' => 'Información del sistema',
    'Your Account' => 'Su cuenta',
    'Movable Type Home' => 'Movable Type - Inicio',
    'Plugin Directory' => 'Directorio de plugins',
    'Knowledge Base' => 'Base de conocimiento',
    'Support and Documentation' => 'Soporte y documentación',
    'Professional Network' => 'Professional Network', # Translate
    'System Overview' => 'Resumen del sistema',
    'From this screen, you can view information about and manage many aspects of your system across all weblogs.' => 'Desde esta pantalla, puede consultar la información sobre el sistema y administrar muchos aspectos que afectan a todos los weblogs.',

    ## ./tmpl/cms/list_ping.tmpl
    'Show pending TrackBacks' => 'Mostrar TrackBacks pendientes',
    'The selected TrackBack(s) has been published.' => 'Se publicaron los TrackBacks seleccionados.',
    'The selected TrackBack(s) has been unpublished.' => 'Se marcaron como no publicados los TrackBacks seleccionados.',
    'The selected TrackBack(s) has been junked.' => 'Se marcaron como basura los TrackBacks seleccionados.',
    'The selected TrackBack(s) has been unjunked.' => 'Se desmarcaron como basura los TrackBacks seleccionados.',
    'The selected TrackBack(s) has been deleted from the database.' => 'Se eliminaron de la base de datos los TrackBacks seleccionados.',
    'No TrackBacks appeared to be junk.' => 'No hay TrackBacks que parezcan basura.',
    'Junk TrackBacks' => 'TrackBacks basura',
    'Show unpublished TrackBacks.' => 'Mostrar TrackBacks no publicados.',
    'Showing all TrackBacks.' => 'Mostrar todos los TrackBacks.',
    'Showing only TrackBacks where' => 'Mostrar solo TrackBacks donde',
    'TrackBacks.' => 'TrackBacks.', # Translate
    'TrackBacks where' => 'TrackBacks donde',
    'No TrackBacks could be found.' => 'No se encontraron TrackBacks.',
    'No junk TrackBacks could be found.' => 'No se encontraron TrackBacks basura.',

    ## ./tmpl/cms/header.tmpl
    'Main Menu' => 'Menú principal',
    'Help' => 'Ayuda',
    'Welcome' => 'Bienvenido',
    'Logout' => 'Cerrar sesión',
    'Weblogs:' => 'Weblogs:', # Translate
    'Go' => 'Ir',
    'System-wide listing' => 'Lista del sistema',
    'Search (f)' => 'Buscar (f)',

    ## ./tmpl/cms/list_plugin.tmpl
    'Are you sure you want to reset the settings for this plugin?' => '¿Está seguro de que desea reiniciar la configuración de este plugin?',
    'Disable plugin system?' => '¿Desactivar sistema de plugins?',
    'Disable this plugin?' => '¿Desactivar este plugin?',
    'Enable plugin system?' => '¿Activar sistema de plugins?',
    'Enable this plugin?' => '¿Activar este plugin?',
    'Plugin Settings' => 'Configuración de plugins',
    'This screen allows you to control the weblog-level settings of any configurable plugins you\'ve installed.' => 'Esta ventana le permite controlar la configuración a nivel de weblog de los plugins configurables que haya instalado.',
    'Your plugin settings have been saved.' => 'Se guardó la configuración del plugin.',
    'Your plugin settings have been reset.' => 'Se reinició la configuración del plugin.',
    'Your plugins have been reconfigured.' => 'Se reconfiguraron los plugins.',
    'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => 'Sus plugins se reconfiguraron. Debido a que está ejecutando mod_perl, debería reiniciar su servidor web para que estos cambios tengan efecto.',
    'Registered Plugins' => 'Plugins registrados',
    'To download more plugins, check out the' => 'Para descargar más plugins, compruebe el',
    'Six Apart Plugin Directory' => 'Directorio de Plugins de Six Apart',
    'Disable Plugins' => 'Desactivar plugins',
    'Enable Plugins' => 'Activar plugins',
    'Error' => 'Error', # Translate
    'Failed to Load' => 'Falló al cargar',
    'Disable' => 'Desactivar',
    'Enabled' => 'Activado',
    'Disabled' => 'Desactivado',
    'Enable' => 'Activar',
    'Documentation for [_1]' => 'Documentación sobre [_1]',
    'Documentation' => 'Documentación',
    'Author of [_1]' => 'Autor de [_1]',
    'More about [_1]' => 'Más sobre [_1]',
    'Support' => 'soporte',
    'Plugin Home' => 'Web del plugin',
    'Resources' => 'Recursos',
    'Show Resources' => 'Mostrar recursos',
    'More Settings' => 'Más preferencias',
    'Show Settings' => 'Mostrar preferencias',
    'Settings for [_1]' => 'Configuración de [_1]',
    'Resources Provided by [_1]' => 'Recursos provistos por [_1]',
    'Tags' => 'Etiquetas',
    'Tag Attributes' => 'Atributos de etiquetas',
    'Text Filters' => 'Filtros de texto',
    'Junk Filters' => 'Filtros de basura',
    '[_1] Settings' => 'Preferencias de [_1]',
    'Reset to Defaults' => 'Reiniciar con los valores predefinidos',
    'Plugin error:' => 'Error del plugin:',
    'No plugins with weblog-level configuration settings are installed.' => 'No hay plugins instalados con configuración a nivel del sistema.',

    ## ./tmpl/cms/error.tmpl
    'An error occurred:' => 'Ocurrió un error:',
    'Go Back' => 'Ir atrás',

    ## ./tmpl/cms/list_comment.tmpl
    'The selected comment(s) has been published.' => 'Se publicaron los comentarios seleccionados.',
    'The selected comment(s) has been unpublished.' => 'Se desmarcaron como publicados los comentarios seleccionados.',
    'The selected comment(s) has been junked.' => 'Se marcaron como basura los comentarios seleccionados.',
    'The selected comment(s) has been unjunked.' => 'Se desmarcaron como basura los comentarios seleccionados.',
    'The selected comment(s) has been deleted from the database.' => 'Los comentarios seleccionados fueron eliminados de la base de datos.',
    'No comments appeared to be junk.' => 'No hay comentarios que parezcan basura.',
    'Go to Commenter Listing' => 'Ir a la lista de comentaristas',
    'Showing all comments.' => 'Se muestran todos los comentarios.',
    'Showing only comments where' => 'Se muestran solo los comentarios donde',
    'comments.' => 'comentarios.',
    'comments where' => 'comentarios donde',
    'No comments could be found.' => 'No se encontró ningún comentario.',
    'No junk comments could be found.' => 'No se encontró ningún comentario basura.',

    ## ./tmpl/cms/system_info.tmpl
    'System Status and Information' => 'Estado e información del sistema',

    ## ./tmpl/cms/footer-popup.tmpl

    ## ./tmpl/cms/import_end.tmpl
    'All data imported successfully! Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => '¡Importados con éxito toda la información! Asegúrese de eliminar los ficheros que importó del directorio \'import\', de tal forma que si/cuando inicie en otro momento el proceso de importación, estos ficheros no se vuelvan a importar.',
    'An error occurred during the import process: [_1]. Please check your import file.' => 'Ocurrió un error durante el proceso de importación: [_1]. Por favor, compruebe su fichero de importación.',

    ## ./tmpl/cms/itemset_action_widget.tmpl
    'More actions...' => 'Más acciones...',
    'No actions' => 'Ninguna acción',

    ## ./tmpl/cms/upload_confirm.tmpl
    'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'El fichero llamado \'[_1]\' ya existe. ¿Desea sobreescribirlo?',

    ## ./tmpl/cms/recover.tmpl
    'Your password has been changed, and the new password has been sent to your email address ([_1]).' => 'Se cambió su contraseña y la nueva se le ha enviado a su dirección de correo electrónico ([_1]).',
    'Enter your Movable Type username:' => 'Introduzca su nombre de usuario de Movable Type:',
    'Enter your password hint:' => 'Teclee la pista de su contraseña:',
    'Recover' => 'Recuperar',

    ## ./tmpl/cms/install.tmpl
    'Welcome to Movable Type!' => '¡Bienvenido a Movable Type!',
    'Before you can begin blogging, we need to complete your installation by initializing your database.' => 'Antes de que comience a publicar, debe completar la instalación inicializando la base de datos.',
    'Finish Install' => 'Finalizar instalación',

    ## ./tmpl/cms/rebuilt.tmpl
    'All of your files have been rebuilt.' => 'Se reconstruyeron todos sus ficheros.',
    'Your [_1] has been rebuilt.' => 'Su [_1] ha sido reconstruido.',
    'Your [_1] pages have been rebuilt.' => 'Sus [_1] páginas han sido reconstruidas.',
    'View this page' => 'Ver esta página',
    'Rebuild Again' => 'Regenerar de nuevo',

    ## ./tmpl/cms/upload_complete.tmpl
    'Your file has been uploaded. Size: [quant,_1,byte].' => 'Se transfirió su fichero. Tamaño: [quant,_1,byte].',
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
    'Modules' => 'Módulos',
    'Go to Publishing Settings' => 'Ir a preferencias de publicación',
    'Create new index template' => 'Crear plantilla índice',
    'Create New Index Template' => 'Crear plantilla índice',
    'Create new archive template' => 'Crear plantilla de archivos',
    'Create New Archive Template' => 'Crear plantilla de archivos',
    'Create new template module' => 'Crear módulo de plantilla',
    'Create New Template Module' => 'Crear módulo de plantilla',
    'No index templates could be found.' => 'No se encontró ninguna plantilla índice.',
    'No archive templates could be found.' => 'No se encontró ninguna plantilla de archivos.',
    'Description' => 'Descripción',
    'No template modules could be found.' => 'No se encontró ninguna plantilla de módulos.',

    ## ./tmpl/cms/cfg_system_feedback.tmpl
    'This screen allows you to configure feedback and outbound TrackBack settings for the entire installation.  These settings override any similar settings for individual weblogs.' => 'Esta pantalla le permite configurar las preferencias de las respuestas y TrackBacks salientes de toda la instalación. Estas preferencias tienen prioridad sobre otras similares en los weblogs individuales.',
    'Feedback Master Switch' => 'Preferencias maestras de las respuestas',
    'Disable Comments' => 'Desactivar comentarios',
    'Stop accepting comments on all weblogs' => 'Desactivar los comentarios en todos los weblogs',
    'This will override all individual weblog comment settings.' => 'Esta configuración tiene preferencia sobre la de los weblogs individuales.',
    'Disable TrackBacks' => 'Desactivar TrackBacks',
    'Stop accepting TrackBacks on all weblogs' => 'Desactivar la recepción de TrackBacks en todos los weblogs',
    'This will override all individual weblog TrackBack settings.' => 'Esta configuración tiene preferencia sobre la de los weblogs individuales.',
    'Outbound TrackBack Control' => 'Control de TrackBacks salientes',
    'Allow outbound TrackBacks to:' => 'Permitir TrackBacks salientes a:',
    'Any site' => 'Cualquier sitio',
    'No site' => 'Ningún sitio',
    '(Disable all outbound TrackBacks.)' => '(Desactivar todos los TrackBacks salientes).',
    'Only the weblogs on this installation' => 'Solo los weblogs de esta instalación',
    'Only the sites on the following domains:' => 'Solo los sitios de los siguientes dominios:',
    'This feature allows you to limit outbound TrackBacks and TrackBack auto-discovery for the purposes of keeping your installation private.' => 'Esta función le permite limitar los TrackBacks salientes y el autodescubrimiento de TrackBack para poder mantener la privacidad de la instalación.',

    ## ./tmpl/cms/edit_author.tmpl
    'Your API Password is currently' => 'La contraseña del acceso remoto (API) es',
    'Author Profile' => 'Perfil del autor',
    'Your profile has been updated.' => 'Se actualizó su perfil.',
    'Weblog Associations' => 'Asociaciones',
    'Create Weblogs' => 'Crear weblogs',
    'Username:' => 'Usuario:',
    'The name used by this author to login.' => 'El nombre utilizado por este autor para iniciar su sesión.',
    'Display Name:' => 'Nombre público:',
    'The author\'s published name.' => 'El nombre público del autor.',
    'The author\'s email address.' => 'La dirección de correo electrónico del autor.',
    'Website URL:' => 'URL del sitio:',
    'The URL of this author\'s website. (Optional)' => 'La URL del sitio de este autor. (Opcional)',
    'Language:' => 'Idioma:',
    'The author\'s preferred language.' => 'El idioma preferido del autor.',
    'Current Password:' => 'Contraseña actual:',
    'Enter the existing password to change it.' => 'Teclee la contraseña actual para cambiarla.',
    'New Password:' => 'Nueva contraseña:',
    'Initial Password:' => 'Contraseña inicial:',
    'Select a password for the author.' => 'Seleccione una contraseña para este autor.',
    'Password Confirm:' => 'Confirmar contraseña:',
    'Repeat the password for confirmation.' => 'Repita la contraseña para confirmación.',
    'Password hint:' => 'Pista:',
    'For password recovery.' => 'Para la recuperación de la clave.',
    'API Password:' => 'Contraseña del acceso remoto (API):',
    'Reveal' => 'Mostrar',
    'For use with XML-RPC and Atom-enabled clients.' => 'Para utilizar en los clientes XML-RPC y Atom.',
    'Save this author (s)' => 'Guardar este/os autor/es',

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

    ## ./tmpl/cms/bm_entry.tmpl
    'Select' => 'Seleccionar',
    'You must choose a weblog in which to post the new entry.' => 'Debe elegir el weblog en el que desea publicar la nueva entrada.',
    'Send an outbound TrackBack:' => 'Enviar un TrackBack saliente:',
    'Select an entry to send an outbound TrackBack:' => 'Seleccionar una entrada para enviar un TrackBack saliente:',
    'Select a weblog for this post:' => 'Seleccionar un weblog para esta entrada:',
    'You do not have entry creation permission for any weblogs on this installation. Please contact your system administrator for access.' => 'No tiene permiso de creación de entradas en esta instalación. Por favor, contacte con su administrador de sistemas para el acceso.',

    ## ./tmpl/cms/overview-left-nav.tmpl
    'List Weblogs' => 'Listar weblogs',
    'List Authors' => 'Listar autores',
    'List Plugins' => 'Listar plugins',
    'Aggregate' => 'Listar',
    'Edit System Settings' => 'Editar configuración del sistema',
    'Show Activity Log' => 'Mostrar histórico de actividad',

    ## ./tmpl/cms/comment_actions.tmpl
    'comment' => 'comentario', # Translate
    'comments' => 'comentarios', # Translate
    'Publish selected comments (p)' => 'Publicar comentarios seleccionados (p)',
    'Delete selected comments (d)' => 'Eliminar comentarios seleccionados (d)',
    'Junk selected comments (j)' => 'Marcar como basura comentarios seleccionados (j)',
    'Recover selected comments (j)' => 'Recuperar comentarios seleccionados (j)',

    ## ./tmpl/cms/system_list_blog.tmpl
    'Below you find a list of all weblogs in the system with links to the main weblog page and individual settings pages for each.  You may also create or delete blogs from this screen.' => 'Debajo encontrará una lista de todos los weblogs del sistema, con enlaces a las páginas principales y preferencias de cada weblog. También podrá crear o eliminar blogs desde esta pantalla.',
    'You have successfully deleted the blogs from the Movable Type system.' => 'Eliminó correctamente los weblogs.',
    'Create New Weblog' => 'Crear weblog',
    'No weblogs could be found.' => 'No se encontró ningún weblog.',

    ## ./tmpl/cms/cfg_archives.tmpl
    'Publishing Settings' => 'Configuración de publicación',
    'This screen allows you to control this weblog\'s publishing paths and preferences, as well as archive mapping settings.' => 'Esta pantalla le permite modificar la configuración de las rutas de publicación del weblog y sus preferencias, así como la configuración de los mapeos de archivo.',
    'Go to Templates Listing' => 'Ir a lista de plantillas',
    'Go to Template Listing' => 'Ir a la lista de plantillas',
    'Error: Movable Type was not able to create a directory for publishing your weblog. If you create this directory yourself, assign sufficient permissions that allow Movable Type to create files within it.' => 'Error: Movable Type no puedo crear un directorio para publicar su weblog. Si crea el directorio usted mismo, debe asignar permisos suficientes para que Movable Type pueda crear ficheros dentro de él.',
    'Your weblog\'s archive configuration has been saved.' => 'La configuración de los archivos de su weblogs se ha guardado.',
    'You may need to update your templates to account for your new archive configuration.' => 'Quizás deba actualizar sus plantillas para mostrar las nuevas opciones de archivado.',
    'You have successfully added a new archive-template association.' => 'Agregó correctamente una nueva asociación archivo-plantilla.',
    'You may need to update your \'Master Archive Index\' template to account for your new archive configuration.' => 'Podría tener que actualizar la plantilla \'Archivo índice maestro\' para tener en cuenta la nueva configuración del archivado.',
    'The selected archive-template associations have been deleted.' => 'Las asociaciones seleccionadas archivos-plantillas fueron eliminadas.',
    'Publishing Paths' => 'Rutas de publicación',
    'Enter the URL of your website. Do not include a filename (i.e. exclude index.html).' => 'Teclee la URL de su sitio. No incluya nombres de archivos (p.e. excluya index.html).',
    'Site Root:' => 'Raíz del sitio:',
    'Enter the path where your index files will be published. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'Teclee la ruta donde se publicarán los ficheros índices. Se recomienda especificar la ruta absoluta (comenzando con \'/\'), pero también puede usar una ruta relativa al directorio de Movable Type.',
    'Advanced Archive Publishing:' => 'Publicación avanzada de archivos:',
    'Publish archives to alternate root path' => 'Publicar archivos en una ruta alternativa',
    'Select this option only if you need to publish your archives outside of your Site Root.' => 'Seleccione esta opción solo si necesita publicar sus archivos fuera de la raíz de su sitio.',
    'Archive URL:' => 'URL de archivos:',
    'Enter the URL of the archives section of your website.' => 'Teclee la URL de la sección de archivos de su sitio.',
    'Archive Root:' => 'Raíz de archivos:',
    'Enter the path where your archive files will be published.' => 'Teclee la ruta donde se publicarán los archivos.',
    'Publishing Preferences' => 'Preferencias de publicación',
    'Preferred Archive Type:' => 'Tipo de archivo preferente:',
    'No Archives' => 'Sin archivos',
    'Individual' => 'Individual', # Translate
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
    '_USAGE_ARCHIVE_MAPS' => 'Esta funcionalidad avanzada le permite mapear cualquier plantilla de archivos a múltiples tipos de archivos. Por ejemplo, podría crear dos vistas diferentes para sus archivos mensuales: una en la que las entradas de un mes particular se presentan como una lista y la otra en la que se representan las entradas en el calendario de ese mes.',
    'Create New Archive Mapping' => 'Crear mapeado de archivos',
    'Archive Type:' => 'Tipo de archivado:',
    'INDIVIDUAL_ADV' => 'Individualmente',
    'DAILY_ADV' => 'Diariamente',
    'WEEKLY_ADV' => 'Semanalmente',
    'MONTHLY_ADV' => 'Mensualmente',
    'CATEGORY_ADV' => 'Por categoría',
    'Template:' => 'Plantilla:',
    'Archive Types' => 'Tipos de archivado',
    'Template' => 'Plantilla',
    'Archive File Path' => 'Ruta de los ficheros de archivos',
    'Preferred' => 'Preferente',
    'Custom...' => 'Personalizar...',
    'archive map' => 'mapa de archivos',
    'archive maps' => 'mapas de archivos',

    ## ./tmpl/cms/rebuilding.tmpl
    'Rebuilding [_1]' => 'Regenerando [_1]',
    'Rebuilding [_1] pages [_2]' => 'Regenerando páginas: [_1] [_2]',
    'Rebuilding [_1] dynamic links' => 'Regenerando [_1] enlaces dinámicos',
    'Rebuilding [_1] pages' => 'Regenerando páginas: [_1]',

    ## ./tmpl/cms/upload.tmpl
    'Choose a File' => 'Seleccionar un fichero',
    'To upload a file to your server, click on the browse button to locate the file on your hard drive.' => 'Para transferir un fichero a su servidor, haga clic en el botón Examinar para localizar el archivo en su disco duro.',
    'File:' => 'Fichero:',
    'Choose a Destination' => 'Seleccionar destino',
    'Upload Into:' => 'Transferir a:',
    '(Optional)' => '(opcional)',
    'Local Archive Path' => 'Ruta local de archivado',
    'Local Site Path' => 'Ruta local del sitio',
    'Upload' => 'Transferir',

    ## ./tmpl/cms/upgrade.tmpl
    'Time to Upgrade!' => '¡Hora de actualizar!',
    'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Se ha instalado una nueva versión de Movable Type.  Debemos realizar algunas tareas para actualizar su base de datos.',
    'Begin Upgrade' => 'Comenzar actualización',

    ## ./tmpl/cms/menu.tmpl
    'Five Most Recent Entries' => 'Las cinco entradas más recientes',
    'View all Entries' => 'Ver todas las entradas',
    'Five Most Recent Comments' => 'Los cinco comentarios más recientes',
    'View all Comments' => 'Ver todos los comentarios',
    'Five Most Recent TrackBacks' => 'Los cinco TrackBacks más recientes',
    'View all TrackBacks' => 'Ver todos los TrackBacks',
    'Welcome to [_1].' => 'Bienvenido a [_1].',
    'You can post to and manage your weblog by selecting an option from the menu located to the left of this message.' => 'Puede publicar y administrar su weblog seleccionado una opción en el menú situado a la izquierda de este mensaje.',
    'If you need assistance, try:' => 'Si necesita ayuda, pruebe:',
    'Movable Type User Manual' => 'Manual del usuario de Movable Type',
    'Movable Type Technical Support' => 'Soporte técnico de Movable Type',
    'Movable Type Support Forum' => 'Foro de soporte de Movable Type',
    'This welcome message is configurable.' => 'Este mensaje de bienvenida es configurable.',
    'Change this message.' => 'Cambiar este mensaje.',

    ## ./tmpl/email/new-ping.tmpl
    'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Se recibió un TrackBack [_1], en la entrada nº[_2] ([_3]). Debe aprobarlo para que aparezca en su sitio.',
    'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Se recibió un TrackBack en su blog [_1], en la categoría #[_2], ([_3]). Debe aprobarlo para que aparezca en su sitio.',
    'Approve this TrackBack:' => 'Aprobar este TrackBack:',
    'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Se publicó un nuevo TrackBack en su blog [_1], en la entrada nº[_2] ([_3]).',
    'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'Se publicó un nuevo TrackBack en su blog [_1], en la categoría nº[_2] ([_3]).',
    'View this TrackBack:' => 'Ver este TrackBack:',
    'Edit this TrackBack:' => 'Editar este TrackBack:',
    'Title:' => 'Título:',
    'Excerpt:' => 'Resumen:',

    ## ./tmpl/email/new-comment.tmpl
    'An unapproved comment has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => 'Se recibió un comentario en su blog [_1], en la entrada nº[_2] ([_3]). Debe aprobar este comentario para que aparezca en su sitio.',
    'Approve this comment:' => 'Aprobar este comentario:',
    'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Se publicó un nuevo comentario en su weblog [_1], en la entrada nº [_2] ([_3]).',
    'View this comment:' => 'Ver este comentario:',
    'Edit this comment:' => 'Editar este comentario:',

    ## ./tmpl/email/verify-subscribe.tmpl
    'If the link is not clickable, just copy and paste it into your browser.' => 'Si no puede hacer clic en el enlace, copie y péguelo en su navegador.',

    ## ./extras/examples/plugins/mirror/mirror.pl

    ## ./extras/examples/plugins/mirror/tmpl/mirror.tmpl

    ## Other phrases, with English translations.
    'WEEKLY_ADV' => 'Semanalmente',
    'Unpublish Comment(s)' => 'No publicar comentario/s',
    '_SYSTEM_TEMPLATE_COMMENT_PENDING' => 'Mostrado cuando un comentario está moderado o marcado como basura.',
    'RSS 1.0 Index' => 'Índice RSS 1.0',
    'Manage Categories' => 'Administrar categorías',
    '_USAGE_BOOKMARKLET_4' => 'Después de instalar QuickPost, puede crear una entrada desde cualquier punto de Internet. Cuando esté visualizando una página y desee escribir sobre la misma, haga clic en "QuickPost" para abrir una ventana emergente especial de edición de Movable Type. Desde esa ventana puede seleccionar el weblog en el que desea publicar, luego escribir su entrada y guardarla.',
    '_USAGE_ARCHIVING_2' => 'Si asocia múltiples plantillas a un determinado tipo de archivado (aunque asocie solamente una), puede personalizar la ruta de salida utilizando las plantillas de archivos.',
    'UTC+11' => 'UTC+11', # Translate
    'View Activity Log For This Weblog' => 'Ver registro de actividades de este weblog',
    'DAILY_ADV' => 'Diariamente',
    '_USAGE_PERMISSIONS_3' => 'Existen dos maneras de editar autores y otorgarles o denegarles privilegios de acceso. Para acceder rápidamente, seleccione un usuario en el menú siguiente y seleccione Editar. Alternativamente, puede desplazarse por la lista completa de autores y desde allí seleccionar el nombre que desea editar o eliminar.',
    '_USAGE_NOTIFICATIONS' => 'A continuación se muestra la lista de usuarios que desean recibir una notificación cuando usted realice alguna nueva contribución en su sitio. Para crear un nuevo usuario, introduzca su dirección de correo electrónico en el formulario siguiente. El campo URL es opcional. Para eliminar un usuario, active la casilla Eliminar en la tabla siguiente y presione el botón ELIMINAR.',
    'Manage Notification List' => 'Administrar lista de notificaciones',
    'Individual' => 'Individual', # Translate
    '_USAGE_COMMENTERS_LIST' => 'Ésta es la lista de comentaristas de [_1].',
    'RSS 2.0 Index' => 'Índice RSS 2.0',
    '_USAGE_LIST' => 'Ésta es la lista de entradas de [_1]. Puede editar cualquiera de las entradas haciendo clic en el NOMBRE DE LA ENTRADA. Para FILTRAR entradas, primero seleccione "categoría", "autor" o "estado" en el primer menú desplegable. A continuación, utilice el segundo menú desplegable para concretar aún más las opciones. Utilice el desplegable bajo la tabla de entradas para indicar cuantas entradas desea ver.',
    '_USAGE_BANLIST' => 'Debajo aparece la lista de direcciones IP a las que ha prohibido insertar comentarios o enviar pings de TrackBack a su sitio. Para crear una nueva dirección IP, introduzca la dirección en el formulario siguiente. Para borrar una dirección IP bloqueada, active la casilla Eliminar en la tabla siguiente y presione el botón ELIMINAR.',
    '_ERROR_DATABASE_CONNECTION' => 'Las opciones de configuración de su base de datos o son incorrectas o no están presentes en el fichero de configuración de Movable Type. Por favor, consulte la sección <a href="#">Instalación y configuración</a> del manual de Movable Type para más información',
    'Configure Weblog' => 'Configurar weblog',
    '_USAGE_AUTHORS' => 'Ésta es la lista de todos los usuarios registrados en el sistema de Movable Type. Puede editar los permisos de un autor haciendo clic en su nombre; para eliminar permanentemente varios autores, active las casillas <b>Eliminar</b> correspondientes y presione ELIMINAR. NOTA: Si solamente desea desasignar un autor de un weblog determinado, edite los permisos del autor; el borrado de un autor mediante ELIMINAR lo elimina completamente del sistema.',
    '_USAGE_FEEDBACK_PREFS' => 'Esta pantalla le permite configurar la forma en que sus lectores pueden contribuir en su blog.',
    '_USAGE_COMMENTS_LIST_ALL_WEBLOGS' => 'Ésta es la lista de comentarios de todos los weblogs. Puede editar cualquier comentario haciendo clic en el TEXTO DEL COMENTARIO. Para FILTRAR las entradas, haga clic en uno de los valores de la lista.', # Translate
    '_USAGE_NEW_AUTHOR' => 'Desde esta pantalla puede crear un nuevo autor en el sistema y darle acceso a weblogs individualmente.',
    '_USAGE_FORGOT_PASSWORD_2' => 'Debería poder iniciar una sesión en Movable Type con esta nueva contraseña. Después de iniciar la sesión, cambie su contraseña a otra que pueda memorizar y recordar fácilmente.',
    '_USAGE_COMMENT' => 'Edite el comentario seleccionado. Presione GUARDAR cuando haya terminado. Para que estos cambios entren en vigor, deberá ejecutar el proceso de reconstrucción.',
    '_USAGE_FORGOT_PASSWORD_1' => 'Solicitó la recuperación de su contraseña de Movable Type. Su contraseña se ha modificado en el sistema; ésta es su nueva contraseña:',
    '_USAGE_EXPORT_2' => 'Para exportar sus entradas, haga clic en el enlace que aparece debajo ("Exportar entradas desde [_1]"). Para guardar los datos exportados en un fichero, mantenga presionada la tecla <code>opción</code> del Macintosh (o la tecla <code>Mayús</code> si trabaja con un PC) y haga clic en el enlace. También puede seleccionar todos los datos y luego copiarlos en otro documento. (<a href="#" onclick="openManual(\'importing\', \'export_ie\');return false;">¿Exportando desde Internet Explorer?</a>)',
    '_SYSTEM_TEMPLATE_POPUP_IMAGE' => 'Mostrado cuando un visitante hace click en la ventana emergente de una imagen.',
    '_USAGE_PING_LIST_ALL_WEBLOGS' => 'Ésta es la lista de pings de todos los weblogs.', # Translate
    '_SYSTEM_TEMPLATE_DYNAMIC_ERROR' => 'Mostrado cuando se encuentra un error en una página dinámica. ',
    'Publish Entries' => 'Publicar entradas',
    'Date-Based Archive' => 'Archivo por fechas',
    'Unban Commenter(s)' => 'Desbloquear comentarista/s',
    'Individual Entry Archive' => 'Archivo de entradas individuales',
    'Daily' => 'Diariamente',
    'Unpublish Entries' => 'No publicar entradas',
    '_USAGE_PING_LIST' => 'Ésta es la lista de pings de [_1].',
    '_USAGE_UPLOAD' => 'Puede transferir el fichero anterior a la ruta local del sitio <a href="javascript:alert(\'[_1]\')">(?)</a> o a su ruta local de archivado <a href="javascript:alert(\'[_2]\')">(?)</a>. También puede transferir el fichero a cualquier subdirectorio de esos directorios, especificando la ruta en los cuadros de texto de la derecha (<i>images</i>, por ejemplo). Si el directorio aún no existe, se creará.',
    '_USAGE_LIST_ALL_WEBLOGS' => 'Ésta es la lista de entradas de todos los weblogs. Puede editar cualquiera de las entradas haciendo clic en el NOMBRE DE LA ENTRADA. Para FILTRAR entradas, primero seleccione "categoría", "autor" o "estado" en el primer menú desplegable. A continuación, utilice el segundo menú desplegable para concretar aún más las opciones. Utilice el desplegable bajo la tabla de entradas para indicar cuantas entradas desea ver.', # Translate
    '_USAGE_REBUILD' => '<a href="#" onclick="doRebuild()">REGENERAR</a> para ver esos cambios reflejados en su sitio público.',
    'Blog Administrator' => 'Administrador de blogs',
    'CATEGORY_ADV' => 'Por categoría',
    'Dynamic Site Bootstrapper' => 'Inicializador del sistema dinámico',
    '_USAGE_PLUGINS' => 'Lista de todos los plugins actualmente registrados en Movable Type.',
    'Category Archive' => 'Archivo de categorías',
    '_USAGE_PERMISSIONS_2' => 'Para editar los permisos de otro usuario, selecciónelo en el menú desplegable y presione EDITAR.',
    '_USAGE_EXPORT_1' => 'La exportación de sus entradas fuera de Movable Type le permitirá tener <b>copias de seguridad personales</b> de sus entradas, para guardarlas en lugar seguro. El formato de los datos exportados permite volverlos a importar en el sistema aprovechando el mecanismo de importación (ver más arriba); de este modo, además de exportar sus entradas como copias de seguridad, también podrá utilizarlo para <b>transferir contenidos entre weblogs</b>.',
    'Untrust Commenter(s)' => 'Desconfiar de comentarista/s',
    '_SYSTEM_TEMPLATE_PINGS' => 'Mostrado cuando las ventanas emergentes de TrackBack (obsoletas) están activadas.',
    'Entry Creation' => 'Creación de entradas',
    '_USAGE_PROFILE' => 'Edite aquí su perfil de autor. Si cambia su nombre de usuario o su contraseña, sus credenciales de inicio de sesión se actualizarán automáticamente. En otras palabras, no necesitará volver a iniciar su sesión.',
    'Category' => 'Categoría',
    'Atom Index' => 'Índice Atom',
    '_USAGE_PLACEMENTS' => 'Utilice las herramientas de edición que aparecen a continuación para administrar las categorías secundarias a las que se asigna esta entrada. La lista de la izquierda contiene las categorías a las que esta entrada aún no está asigna como categoría principal o secundaria; la lista de la derecha contiene las categorías secundarias asignadas a esta entrada.',
    '_USAGE_ENTRYPREFS' => 'La configuración de campos determina qué campos aparecerán en las pantallas de entrada nueva y edición. Puede elegir una configuración existente (básica o avanzada) o personalizar las pantallas haciendo clic en Personalizada para elegir los campos que desee que aparezcan.',
    '_USAGE_COMMENTS_LIST' => 'Ésta es la lista de comentarios de [_1]. Puede editar cualquier comentario haciendo clic en el TEXTO DEL COMENTARIO. Para FILTRAR las entradas, haga clic en uno de los valores de la lista.',
    '_THROTTLED_COMMENT_EMAIL' => 'Se bloqueó automáticamente a una persona que visitó su weblog [_1] debido a que insertó más comentarios de los permitidos en menos de [_2] segundos. Esto se hizo para impedir que nadie o nada desborde malintencionadamente  su weblog con comentarios. La dirección bloqueada es la siguiente:

    [_3]

Si esta operación no es correcta, puede desbloquear la dirección IP y permitir al visitante reanudar sus comentarios. Para ello, inicie una sesión en su instalación de Movable Type, vaya a Configuración del weblog - Bloqueo de direcciones IP y elimine la dirección IP [_4] de la lista de direcciones bloqueadas.',
    'Stylesheet' => 'Hoja de estilo',
    'RSD' => 'RSD', # Translate
    'MONTHLY_ADV' => 'Mensualmente',
    'Trust Commenter(s)' => 'Confiar en comentarista/s',
    '_SYSTEM_TEMPLATE_COMMENT_PREVIEW' => 'Mostrado cuando un comentarista revisa la vista previa de su comentario.',
    '_THROTTLED_COMMENT' => 'En un esfuerzo por impedir la inserción de comentarios maliciosos por parte usuarios malévolos, se ha habilitado una función que obliga al comentarista del weblog esperar un tiempo determinado antes de poder realizar un nuevo comentario. Por favor, vuelva a insertar su comentario dentro de unos momentos. Gracias por su comprensión.',
    'Manage Templates' => 'Administrar plantillas',
    '_USAGE_BOOKMARKLET_3' => 'Para instalar el marcador de QuickPost para Movable Type, arrastre el enlace siguiente al menú o barra de herramientas Favoritos de su navegador:',
    '_USAGE_SEARCH' => 'Puede utilizar la herramienta de búsqueda y reemplazo Buscar &amp; Reemplazar para realizar búsquedas en todas sus entradas, o bien para reemplazar cada ocurrencia de una palabra/frase/carácter por otra. IMPORTANTE: Ponga mucha atención al ejecutar un reemplazo, porque es una operación <b>irreversible</b>. Si va a efectuar un reemplazo masivo (es decir, en muchas entradas), es recomendable utilizar primero la función de exportación para hacer una copia de seguridad de sus entradas.',
    '_USAGE_BOOKMARKLET_2' => 'QuickPost para Movable Type permite personalizar el diseño y los campos de la página de QuickPost. Por ejemplo, puede incluir la posibilidad de crear extractos a través de la ventana de QuickPost. De forma predeterminada, una ventana de QuickPost tendrá siempre: un menú desplegable correspondiente al weblog en el que se va a publicar, un menú desplegable para seleccionar el estado de publicación de la nueva entrada (Borrador o Publicar), un cuadro de texto para introducir el título de la entrada y un cuadro de texto para introducir el cuerpo de la entrada.',
    '_USAGE_PERMISSIONS_1' => 'Está editando los permisos de <b>[_1]</b>. Más abajo verá la lista de weblogs a los que tiene acceso como autor con permisos de edición; por cada weblog de la lista, asigne permisos a <b>[_1]</b>, activando las casillas correspondientes de los permisos de acceso que desea otorgar.',
    '_AUTO' => '1',
    '_USAGE_LIST_POWER' => 'Ésta es la lista de entradas de [_1] en el modo de edición por lotes. En el formulario siguiente puede cambiar cualesquier valor de cualesquier entrada mostrada; una vez introducidas las modificaciones deseadas, presione el botón GUARDAR. Los controles estándar "Listar y editar entradas" (filtros, paginación) funcionan del modo acostumbrado.',
    '_ERROR_CONFIG_FILE' => 'El fichero de configuración de Your Movable Type no existe o no se puede leer correctamente. Por favor, consulte la sección <a href="#">Instalación y configuración</a> del manual de Movable Type manual para más información.',
    '_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.org/sitees/">Movable Type <$MTVersion$></a>',
    'Monthly' => 'Mensualmente',
    '_USAGE_ARCHIVING_1' => 'Seleccione la periodicidad y los tipos de archivado que desee realizar en su sitio. Por cada tipo de archivado que elija, tendrá la opción de asignar múltiples plantillas de archivado, que se aplicarán a ese tipo en particular. Por ejemplo, puede crear dos vistas diferentes de sus archivos mensuales: una consistente en una página que contenga cada una de las entradas de un determinado mes y la otra consistente en una vista de calendario de ese mes.',
    'Ban Commenter(s)' => 'Bloquear comentarista/s',
    '_USAGE_VIEW_LOG' => 'Active la casilla <a href="#" onclick="doViewLog()">Registro de actividades</a> correspondiente a ese error.',
    '_USAGE_PERMISSIONS_4' => 'Cada weblog puede tener múltiples autores. Para crear un autor, introduzca la información del usuario en el siguiente formulario. A continuación, seleccione los weblogs en los que tendrá algún tipo de privilegio como autor. Cuando presione GUARDAR y el usuario esté registrado en el sistema, podrá editar sus privilegios de autor.',
    '_USAGE_BOOKMARKLET_1' => 'La configuración de QuickPost para poder realizar contribuciones en Movable Type permite insertar y publicar con un solo clic sin necesidad alguna de utilizar la interfaz principal de Movable Type.',
    '_USAGE_ARCHIVING_3' => 'Seleccione el tipo de archivado al que desea crear una nueva plantilla de archivado. A continuación, seleccione la plantilla a asociar a ese tipo de archivado.',
    'UTC+10' => 'UTC+10', # Translate
    'INDIVIDUAL_ADV' => 'Individualmente',
    '_USAGE_BOOKMARKLET_5' => 'Alternativamente, si está ejecutando Internet Explorer bajo Windows, puede instalar una opción "QuickPost" en el menú contextual de Windows. Haga clic en el enlace siguiente y acepte la petición del navegador de "Abrir" el fichero. A continuación, cierre y vuelva a abrir su navegador para crear el enlace al menú contextual.',
    '_ERROR_CGI_PATH' => 'La opción de configuración CGIPath no es válida o no se encuentra en el fichero de configuración de Movable Type. Por favor, consulte la sección <a href="#">Instalación y configuración</a> del manual de Movable Type manual para más información.',
    '_USAGE_IMPORT' => 'Utilice el mecanismo de importación para importar entradas de otro sistema de weblogs, como Blogger o Greymatter. Este manual proporciona instrucciones exhaustivas para la importación de entradas antiguas mediante este mecanismo; el formulario siguiente permite importar un lote de entradas después de que las haya exportado del otro CMS y haya colocado los ficheros exportados en el lugar correcto para que Movable Type los pueda encontrar. Antes de usar este formulario, consulte el manual para asegurarse de haber comprendido todas las opciones.',
    'Main Index' => 'Índice principal',
    '_USAGE_CATEGORIES' => 'Utilice categorías para agrupar sus entradas y así facilitar las referencias, archivados y weblogs. En el momento de crear o editar entradas, puede asignarles una categoría. Para editar una categoría anterior, haga clic en el título de la categoría. Para crear una subcategoría, haga clic en el botón "Crear" correspondiente. Para trasladar una subcategoría, haga clic en el botón "Trasladar" correspondiente.',
    '_SYSTEM_TEMPLATE_COMMENTS' => 'Mostrado cuando las ventanas emergentes de comentarios (obsoletas) están activadas.',
    'Master Archive Index' => 'Archivo índice maestro',
    'Weekly' => 'Semanalmente',
    'Unpublish TrackBack(s)' => 'No publicar TrackBack/s',
    '_USAGE_EXPORT_3' => 'Haciendo clic en el enlace siguiente exportará todas las entradas actuales del weblog al servidor Tangent. Generalmente, este proceso se realiza una sola vez y de una pasada, después de instalar el plug-in de Tangent para Movable Type, pero teóricamente podría ejecutarse siempre que sea necesario.',
    'Send Notifications' => 'Enviar notificaciones',
    'Edit All Entries' => 'Editar todas las entradas',
    '_USAGE_PREFS' => 'Esta pantalla permite establecer un gran número de ajustes opcionales referentes a weblogs, archivos, comentarios, como también su configuración de publicidad y notificaciones. Al crear uno nuevo weblog, todos estos ajustes están predeterminados con valores razonables.',
    '_SYSTEM_TEMPLATE_COMMENT_ERROR' => 'Mostrado cuando un comentario no puede validarse.',
    'Rebuild Files' => 'Regenerar ficheros',

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
    'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in mt.cfg.' => 'HTML::Entities es necesario para codificar algunos caracteres, pero esta característica se puede desactivar usando la opción NoHTMLEntities en mt.cfg.',
    'LWP::UserAgent is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'LWP::UserAgent is opcional; es necesario si desea usar el sistema de TrackBack, las notificaciones a weblogs.com o a las Últimas actualizaciones de MT.',
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

    ## ./extlib/JSON.pm

    ## ./extlib/DateTimePP.pm

    ## ./extlib/DateTime.pm

    ## ./extlib/DateTimePPExtra.pm

    ## ./extlib/I18N/LangTags.pm

    ## ./extlib/I18N/LangTags/List.pm

    ## ./extlib/Locale/Maketext.pm

    ## ./extlib/XML/XPath.pm

    ## ./extlib/XML/Atom.pm

    ## ./extlib/XML/Atom/Server.pm

    ## ./extlib/XML/Atom/Person.pm

    ## ./extlib/XML/Atom/ErrorHandler.pm

    ## ./extlib/XML/Atom/API.pm

    ## ./extlib/XML/Atom/Thing.pm

    ## ./extlib/XML/Atom/Content.pm

    ## ./extlib/XML/Atom/Util.pm

    ## ./extlib/XML/Atom/Link.pm

    ## ./extlib/XML/Atom/Client.pm

    ## ./extlib/XML/Atom/Entry.pm

    ## ./extlib/XML/Atom/Author.pm

    ## ./extlib/XML/Atom/Feed.pm

    ## ./extlib/XML/XPath/Step.pm

    ## ./extlib/XML/XPath/XMLParser.pm

    ## ./extlib/XML/XPath/Expr.pm

    ## ./extlib/XML/XPath/PerlSAX.pm

    ## ./extlib/XML/XPath/Boolean.pm

    ## ./extlib/XML/XPath/Root.pm

    ## ./extlib/XML/XPath/LocationPath.pm

    ## ./extlib/XML/XPath/Function.pm

    ## ./extlib/XML/XPath/Node.pm

    ## ./extlib/XML/XPath/Variable.pm

    ## ./extlib/XML/XPath/Builder.pm

    ## ./extlib/XML/XPath/Number.pm

    ## ./extlib/XML/XPath/Parser.pm

    ## ./extlib/XML/XPath/Literal.pm

    ## ./extlib/XML/XPath/NodeSet.pm

    ## ./extlib/XML/XPath/Node/Text.pm

    ## ./extlib/XML/XPath/Node/PI.pm

    ## ./extlib/XML/XPath/Node/Element.pm

    ## ./extlib/XML/XPath/Node/Namespace.pm

    ## ./extlib/XML/XPath/Node/Comment.pm

    ## ./extlib/XML/XPath/Node/Attribute.pm

    ## ./extlib/Attribute/Params/Validate.pm

    ## ./extlib/Params/ValidateXS.pm

    ## ./extlib/Params/ValidatePP.pm

    ## ./extlib/Params/Validate.pm

    ## ./extlib/Math/BigInt.pm

    ## ./extlib/Math/BigInt/Scalar.pm

    ## ./extlib/Math/BigInt/Trace.pm

    ## ./extlib/Math/BigInt/Calc.pm

    ## ./extlib/JSON/Converter.pm

    ## ./extlib/JSON/Parser.pm

    ## ./extlib/DateTime/Infinite.pm

    ## ./extlib/DateTime/Duration.pm

    ## ./extlib/DateTime/TimeZoneCatalog.pm

    ## ./extlib/DateTime/LocaleCatalog.pm

    ## ./extlib/DateTime/TimeZone.pm

    ## ./extlib/DateTime/LeapSecond.pm

    ## ./extlib/DateTime/Locale.pm

    ## ./extlib/DateTime/Locale/Base.pm

    ## ./extlib/DateTime/Locale/root.pm

    ## ./extlib/DateTime/Locale/Alias/ISO639_2.pm

    ## ./extlib/DateTime/TimeZone/OffsetOnly.pm

    ## ./extlib/DateTime/TimeZone/Local.pm

    ## ./extlib/DateTime/TimeZone/UTC.pm

    ## ./extlib/DateTime/TimeZone/OlsonDB.pm

    ## ./extlib/DateTime/TimeZone/Floating.pm

    ## ./tools/Html.pm

    ## ./tools/Backup.pm

    ## ./tools/sample.pm

    ## ./tools/cwapi.pm

    ## ./lib/MT/BasicAuthor.pm

    ## ./lib/MT/Object.pm

    ## ./lib/MT/Placement.pm

    ## ./lib/MT/Bootstrap.pm
    'Got an error: [_1]' => 'Ocurrió un error en: [_1]',

    ## ./lib/MT/Category.pm

    ## ./lib/MT/Promise.pm

    ## ./lib/MT/App.pm
    'User \'[_1]\' (user #[_2]) logged in successfully' => 'El usuario \'[_1]\' (usuario nº[_2]) inició una sesión correctamente',
    'Invalid login attempt from user \'[_1]\'' => 'Intento no válido de inicio de sesión del usuario \'[_1]\'',
    'Invalid login.' => 'Acceso no válido.',
    'User \'[_1]\' (user #[_2]) logged out' => 'El usuario \'[_1]\' (usuario nº[_2]) finalizó su sesión',
    'The file you uploaded is too large.' => 'El fichero que transfirió es demasiado grande.',
    'Unknown action [_1]' => 'Acción desconocida [_1]',
    'Loading template \'[_1]\' failed: [_2]' => 'Fallo cargando plantilla \'[_1]\': [_2]',

    ## ./lib/MT/Log.pm

    ## ./lib/MT/Image.pm
    'Can\'t load Image::Magick: [_1]' => 'No se pudo cargar Image::Magick: [_1]',
    'Reading file \'[_1]\' failed: [_2]' => 'Fallo leyendo archivo \'[_1]\': [_2]',
    'Reading image failed: [_1]' => 'Fallo leyendo imagen: [_1]',
    'Scaling to [_1]x[_2] failed: [_3]' => 'El escalado a [_1]x[_2] falló: [_3]',
    'Can\'t load IPC::Run: [_1]' => 'No se pudo cargar IPC::Run: [_1]',
    'You do not have a valid path to the NetPBM tools on your machine.' => 'No posee una ruta válida a las herramientas NetPBMYou en su máquina.',

    ## ./lib/MT/Session.pm

    ## ./lib/MT/FileMgr.pm

    ## ./lib/MT/IPBanList.pm

    ## ./lib/MT/Trackback.pm

    ## ./lib/MT/Notification.pm

    ## ./lib/MT/Blocklist.pm

    ## ./lib/MT/Sanitize.pm

    ## ./lib/MT/AtomServer.pm

    ## ./lib/MT/Upgrade.pm
    'Running [_1]' => 'Ejecutando [_1]',
    'Invalid upgrade function: [_1].' => 'Función de actualización no válida: [_1].',
    'Error loading class: [_1].' => 'Error cargando la clase: [_1].',
    'Creating initial weblog and author records...' => 'Creando registros iniciales de weblogs y autores...',
    'Error saving record: [_1].' => 'Error guardando el registro: [_1].',
    'First Weblog' => 'Primer weblog',
    'Can\'t find default template list; where is \'default-templates.pl\'? Error: [_1]' => 'No puedo encontrar la lista de plantillas predefinidas; ¿dónde está \'default-templates.pl\'? Error: [_1]',
    'Creating new template: \'[_1]\'.' => 'Creando nueva plantilla: \'[_1]\'.',
    'Mapping templates to blog archive types...' => 'Mapeando plantillas con tipos de archivo de blogs...',
    'Upgrading table for [_1]' => 'Actualizando tabla para [_1]',
    'Executing SQL: [_1];' => 'Ejecutando SQL: [_1];',
    'Error during upgrade: [_1]' => 'Error durante la actualización: [_1]',
    'Upgrading database from version [_1].' => 'Actualizando base de datos desde la versión [_1].',
    'Database has been upgraded to version [_1].' => 'Se actualizó la base de datos a la versión [_1].',
    'Setting your permissions to administrator.' => 'Estableciendo permisos de administrador.',
    'Creating configuration record.' => 'Creando registro de configuración.',
    'Creating template maps...' => 'Creando mapas de plantillas...',
    'Mapping template ID [_1] to [_2] ([_3]).' => 'Mapeando ID plantilla [_1] a [_2] ([_3]).',
    'Mapping template ID [_1] to [_2].' => 'Mapeando ID plantilla [_1] a [_2].',

    ## ./lib/MT/PluginData.pm

    ## ./lib/MT/DateTime.pm

    ## ./lib/MT/Plugin.pm

    ## ./lib/MT/Entry.pm
    'Load of blog failed: [_1]' => 'Fallo en la carga del blog: [_1]',
    'Load of blog \'[_1]\' failed: [_2]' => 'La carga del blog \'[_1]\' falló: [_2]',

    ## ./lib/MT/Author.pm

    ## ./lib/MT/Config.pm

    ## ./lib/MT/XMLRPC.pm
    'No WeblogsPingURL defined in mt.cfg' => 'WeblogsPingURL no definido en mt.cfg',
    'No MTPingURL defined in mt.cfg' => 'MTPingURL no definido en mt.cfg',
    'HTTP error: [_1]' => 'Error HTTP: [_1]',
    'Ping error: [_1]' => 'Error de ping: [_1]',

    ## ./lib/MT/TemplateMap.pm

    ## ./lib/MT/Template.pm
    'Parse error in template \'[_1]\': [_2]' => 'Error de interpretación en la plantilla \'[_1]\': [_2]',
    'Build error in template \'[_1]\': [_2]' => 'Error de reconstrucción en la plantilla \'[_1]\': [_2]',
    'You cannot use a [_1] extension for a linked file.' => 'No puede usar una extensión [_1] para un fichero enlazado.',
    'Opening linked file \'[_1]\' failed: [_2]' => 'Fallo abriendo fichero enlazado\'[_1]\': [_2]',

    ## ./lib/MT/ConfigMgr.pm
    'Error opening file \'[_1]\': [_2]' => 'Error abriendo fichero \'[_1]\': [_2]',
    'Config directive [_1] without value at [_2] line [_3]' => 'Directiva de configuración [_1] sin valor en [_2] línea [_3]',
    'No such config variable \'[_1]\'' => 'No existe la variable de configuración \'[_1]\'',

    ## ./lib/MT/ImportExport.pm
    'You need to provide a password if you are going to\n' => 'Debe proveer una clave si va a\n',
    'Need either ImportAs or ParentAuthor' => 'Necesita ImportAs o ParentAuthor',
    'Saving author failed: [_1]' => 'Fallo guardando autor: [_1]',
    'Saving permission failed: [_1]' => 'Fallo guardando permisos: [_1]',
    'Saving category failed: [_1]' => 'Fallo guardando categoría: [_1]',
    'Invalid status value \'[_1]\'' => 'Valor de estado no válido \'[_1]\'',
    'Saving entry failed: [_1]' => 'Fallo guardando entrada: [_1]',
    'Saving placement failed: [_1]' => 'Fallo guardando situación: [_1]',
    'Saving comment failed: [_1]' => 'Fallo guardando comentario: [_1]',
    'Entry has no MT::Trackback object!' => '¡La entrada no tiene objeto MT::Trackback!',
    'Saving ping failed: [_1]' => 'Fallo guardando ping: [_1]',
    'Export failed on entry \'[_1]\': [_2]' => 'Fallo de exportación en la entrada \'[_1]\': [_2]',

    ## ./lib/MT/JunkFilter.pm
    'Action: Junked (score below threshold)' => 'Acción: Basura (puntuación bajo nivel)',
    'Action: Published (default action)' => 'Action: Publicado (acción predefinida)',
    'Junk Filter [_1] died with: [_2]' => 'Filtro basura [_1] murió con: [_2]',
    'Unnamed Junk Filter' => 'Filtro basura sin nombre',
    'Composite score: [_1]' => 'Puntuación compuesta: [_1]',

    ## ./lib/MT/ObjectDriver.pm

    ## ./lib/MT/Mail.pm
    'Unknown MailTransfer method \'[_1]\'' => 'MailTransfer método desconocido \'[_1]\'',
    'Sending mail via SMTP requires that your server ' => 'El envío de correo vía SMTP requiere que su servidor ',
    'Error sending mail: [_1]' => 'Error enviado correo: [_1]',
    'You do not have a valid path to sendmail on your machine. ' => 'No tiene una ruta válida a sendmail en su máquina. ',
    'Exec of sendmail failed: [_1]' => 'Fallo la ejecución de sendmail: [_1]',

    ## ./lib/MT/Blog.pm

    ## ./lib/MT/TBPing.pm

    ## ./lib/MT/Builder.pm

    ## ./lib/MT/ErrorHandler.pm

    ## ./lib/MT/Serialize.pm

    ## ./lib/MT/Permission.pm

    ## ./lib/MT/Request.pm

    ## ./lib/MT/FileInfo.pm

    ## ./lib/MT/XMLRPCServer.pm

    ## ./lib/MT/Callback.pm

    ## ./lib/MT/WeblogPublisher.pm
    'Archive type \'[_1]\' is not a chosen archive type' => 'El tipo de archivos \'[_1]\' no es un tipo de archivos seleccionado',
    'Parameter \'[_1]\' is required' => 'El parámetro \'[_1]\' es necesario',
    'Building category archives, but no category provided.' => 'Regenerando archivos de categorías, pero no se indicó ninguna categoría.',
    'You did not set your Local Archive Path' => 'No indicó su ruta local de archivos',
    'Building category \'[_1]\' failed: [_2]' => 'Fallo reconstruyendo categoría \'[_1]\': [_2]',
    'Building entry \'[_1]\' failed: [_2]' => 'Fallo reconstruyendo entrada \'[_1]\': [_2]',
    'Building date-based archive \'[_1]\' failed: [_2]' => 'Fallo reconstruyendo archivo de fechas \'[_1]\': [_2]',
    'You did not set your Local Site Path' => 'No indicó su ruta local de archivos',
    'Template \'[_1]\' does not have an Output File.' => 'La plantilla \'[_1]\' no tiene un fichero de salida.',

    ## ./lib/MT/Atom.pm

    ## ./lib/MT/Comment.pm
    'Load of entry \'[_1]\' failed: [_2]' => 'Fallo al cargar la entrada \'[_1]\': [_2]',

    ## ./lib/MT/L10N.pm

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

    ## ./lib/MT/BasicSession.pm

    ## ./lib/MT/ObjectDriver/DBI.pm

    ## ./lib/MT/ObjectDriver/DBM.pm
    'Your DataSource directory (\'[_1]\') does not exist.' => 'Su directorio DataSource (\'[_1]\') no existe.',
    'Your DataSource directory (\'[_1]\') is not writable.' => 'No se puede escribir en el directorio DataSource (\'[_1]\').',
    'Tie \'[_1]\' failed: [_2]' => 'La creación del enlace \'[_1]\' falló: [_2]',
    'Failed to generate unique ID: [_1]' => 'Fallo al intentar generar ID único: [_1]',
    'Unlink of \'[_1]\' failed: [_2]' => 'El borrado del enlace \'[_1]\' falló: [_2]',

    ## ./lib/MT/ObjectDriver/DBI/mysql.pm
    'Connection error: [_1]' => 'Error de conexión: [_1]',

    ## ./lib/MT/ObjectDriver/DBI/postgres.pm

    ## ./lib/MT/ObjectDriver/DBI/sqlite.pm
    'Can\'t open \'[_1]\': [_2]' => 'No se pudo abrir \'[_1]\': [_2]',
    'Your database file (\'[_1]\') is not writable.' => 'No se puede escribir en el fichero de su base de datos (\'[_1]\').',
    'Your database directory (\'[_1]\') is not writable.' => 'No se puede escribir en el directorio de su base de datos (\'[_1]\').',

    ## ./lib/MT/FileMgr/FTP.pm

    ## ./lib/MT/FileMgr/DAV.pm

    ## ./lib/MT/FileMgr/Local.pm
    'Opening local file \'[_1]\' failed: [_2]' => 'Fallo abriendo el fichero local \'[_1]\': [_2]',
    'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Fallo renombrando \'[_1]\' a \'[_2]\': [_3]',

    ## ./lib/MT/FileMgr/SFTP.pm

    ## ./lib/MT/Template/Context.pm

    ## ./lib/MT/Template/ContextHandlers.pm
    'Can\'t find included template module \'[_1]\'' => 'No se encontró el módulo de plantilla incluido \'[_1]\'',
    'Can\'t find included file \'[_1]\'' => 'No se encontró el fichero incluido \'[_1]\'',
    'Error opening included file \'[_1]\': [_2]' => 'Error abriendo el fichero incluido \'[_1]\': [_2]',
    'Can\'t find template \'[_1]\'' => 'No se encontró la plantilla \'[_1]\'',
    'Can\'t find entry \'[_1]\'' => 'No se encontró la entrada \'[_1]\'',
    'You used a [_1] tag without any arguments.' => 'Usó una etiqueta [_1] sin ningún parámetro.',
    'No such category \'[_1]\'' => 'No existe la categoría \'[_1]\'',
    'You can\'t use both AND and OR in the same expression ([_1]).' => 'No puede usar AND y OR en la misma expresión ([_1]).',
    'No such author \'[_1]\'' => 'No existe el autor \'[_1]\'',
    'You used an \'[_1]\' tag outside of the context of an entry; ' => 'Usó una etiqueta \'[_1]\' fuera del contexto de una entrada; ',
    'You used <$MTEntryFlag$> without a flag.' => 'Usó <$MTEntryFlag$> sin \'flag\'.',
    'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Usó una etiqueta [_1] enlazando los archivos \'[_2]\', pero el tipo de archivo no está publicado.',
    'To enable comment registration, you ' => 'Para habilitar el registro de comentarios, ',
    '(You may use HTML tags for style)' => '(Puede usar etiquetas HTML para el estilo)',
    'You used an [_1] tag without a date context set up.' => 'Usó una etiqueta [_1] sin un contexto de fecha configurado.',
    'You used an \'[_1]\' tag outside of the context of a comment; ' => 'Usó una etiqueta \'[_1]\' fuera del contexto de un comentario; ',
    'You used an [_1] without a date context set up.' => 'Usó un [_1] sin una fecha de contexto configurada.',
    '[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] sólo se puede usar con los archivos diarios, semanales o mensuales.',
    'You used an [_1] tag outside of the proper context.' => 'Usó una etiqueta [_1] fuera del contexto correcto.',
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly ' => 'Usó una etiqueta [_1] fuera de Diario, Semanal, o Mensual ',
    'Invalid month format: must be YYYYMM' => 'Formato de mes no válido: debe ser YYYYMM',
    '[_1] can be used only if you have enabled Category archives.' => '[_1] sólo se puede usar si tiene habilitadas el archivado de categorías.',
    'You used [_1] without a query.' => 'Usó [_1] sin una consulta.',
    'You need a Google API key to use [_1]' => 'Necesita una clave de Google API para usar [_1]',
    'You used a non-existent property from the result structure.' => 'Usó una propiedad inexistente de la estructura del resultado.',

    ## ./lib/MT/App/NotifyList.pm
    'Please enter a valid email address.' => 'Por favor, teclee una dirección de correo válida.',
    'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Falta parámetro obligatorio: blog_id. Por favor, consulte el manual de usuario para configurar las notificaciones.',
    'Email notifications have not been configured! The weblog owner needs to set the EmailVerificationSecret configuration variable in mt.cfg.' => '¡Las notificaciones por correo-e no están configuradas! El dueño del weblog necesita establecer la opción EmailVerificationSecret en mt.cfg.',
    'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Parámetro de redirección no válido. El dueño del weblog debe especificar una ruta que coincida con el del dominio del weblog.',
    'The email address \'[_1]\' is already in the notification list for this weblog.' => 'La dirección de correo-e \'[_1]\' ya está en la lista de notificaciones de este weblog.',

    ## ./lib/MT/App/Trackback.pm
    'Invalid entry ID \'[_1]\'' => 'ID de entrada no válida \'[_1]\'',
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
    'Rebuild failed: [_1]' => 'Fallo la reconstrucción: [_1]',
    'Can\'t create RSS feed \'[_1]\': ' => 'No se pudo crear la fuente RSS \'[_1]\': ',
    'New TrackBack Ping to Entry [_1] ([_2])' => 'Nuevo ping de TrackBack en la entrada [_1] ([_2])',
    'New TrackBack Ping to Category [_1] ([_2])' => 'Nuevo ping de TrackBack en la categoría [_1] ([_2])',

    ## ./lib/MT/App/Comments.pm
    'IP Banned Due to Excessive Comments' => 'IP bloqueada debido al exceso de comentarios',
    'No such entry \'[_1]\'.' => 'No existe la entrada \'[_1]\'.',
    'You are not allowed to post comments.' => 'No puede publicar comentarios.',
    'Comments are not allowed on this entry.' => 'No se permiten comentarios en esta entrada.',
    'Comment text is required.' => 'El texto del comentario es obligatorio.',
    'Registration is required.' => 'El registro es obligatorio.',
    'Name and email address are required.' => 'El nombre y la dirección de correo-e son obligatorios.',
    'Invalid email address \'[_1]\'' => 'Dirección de correo-e no válida \'[_1]\'',
    'New Comment Posted to \'[_1]\'' => 'Nuevo comentario publicado en \'[_1]\'',
    'No public key could be found to validate registration.' => 'No se encontró la clave pública para validar el registro.',
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

    ## ./lib/MT/App/Search.pm
    'You are currently performing a search. Please wait ' => 'Actualmente está realizando una búsqueda. Por favor, espere ',
    'Search failed: [_1]' => 'Falló la búsqueda: [_1]',
    'Building results failed: [_1]' => 'Fallo generando los resultados: [_1]',
    'Search: query for \'[_1]\'' => 'Búsqueda: encontrar \'[_1]\'', # Translate

    ## ./lib/MT/App/Upgrader.pm
    'Invalid session.' => 'Sesión no válida.',
    'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Sin permisos. Por favor, contacte con su administrador para la actualización de Movable Type.',

    ## ./lib/MT/App/Viewer.pm

    ## ./lib/MT/App/CMS.pm
    'Convert Line Breaks' => 'Convertir saltos de línea',
    'Password Recovery' => 'Recuperación de contraseña',
    'Invalid author name \'[_1]\' in password recovery attempt' => 'Nombre de autor \'[_1]\' no válido durante intento de recuperación de contraseña',
    'Author name or birthplace is incorrect.' => 'El nombre de autor o la fecha de nacimiento es incorrecto.',
    'Author has not set birthplace; cannot recover password' => 'El autor no tiene una fecha de nacimiento; no puede recuperar la clave',
    'Invalid attempt to recover password (used birthplace \'[_1]\')' => 'Intento de recuperación de contraseña no válido (se utilizó lugar de nacimiento \'[_1]\')',
    'Author does not have email address' => 'El autor no tiene una dirección de correo electrónico',
    'Password was reset for author \'[_1]\' (user #[_2])' => 'Se reinició la contraseña para el autor \'[_1]\' (usuario nº[_2])',
    'Error sending mail ([_1]); please fix the problem, then ' => 'Error enviando correo ([_1]); por favor, solucione el problema, y luego  ',
    'You are not authorized to log in to this blog.' => 'No está autorizado para acceder a este blog.',
    'No such blog [_1]' => 'No existe el blog [_1]',
    'Permission denied.' => 'Permiso denegado.',
    'log records' => 'históricos',
    'Application log for blog \'[_1]\' reset by \'[_2]\' (user #[_3])' => '\'[_2]\' (usuario nº[_3]) reinició el registro de la aplicación en el blog \'[_1]\'',
    'Application log reset by \'[_1]\' (user #[_2])' => 'Registro de aplicación reiniciado por \'[_1]\' (usuario nº[_2])',
    'Import/Export' => 'Importar/Exportar',
    'No permissions' => 'No tiene permisos',
    'Permission denied. ' => 'Permiso denegado. ',
    'Load failed: [_1]' => 'Fallo carga: [_1]',
    '(untitled)' => '(sin título)',
    'Create template requires type' => 'Crear plantillas requiere el tipo',
    'New Template' => 'Nueva plantilla',
    'New Weblog' => 'Nuevo weblog',
    'Author requires username' => 'El autor necesita un nombre de usuario',
    'Author requires password' => 'El autor necesita una contraseña',
    'Author requires password hint' => 'El autor necesita una pista para la contraseña',
    'Email Address is required for password recovery' => 'La dirección de correo es necesaria para la recuperación de la contraseña',
    'The value you entered was not a valid email address' => 'El valor que tecleó no es una dirección válida de correo electrónico',
    'The e-mail address you entered is already on the Notification List for this weblog.' => 'La dirección de correo-e que tecleó ya está en la lista de notificaciones de este weblog.',
    'You did not enter an IP address to ban.' => 'No tecleó una dirección IP para bloquear.',
    'The IP you entered is already banned for this weblog.' => 'La IP que tecleó ya está bloqueada en este weblog.',
    'You did not specify a weblog name.' => 'No especificó el nombre del weblog.',
    'Site URL must be an absolute URL.' => 'La URL del sitio debe ser una URL absoluta.',
    'There is already a weblog by that name!' => 'Ya existe un weblog con ese nombre.',
    'The name \'[_1]\' is too long!' => 'El nombre \'[_1]\' es demasiado largo.',
    'No categories with the same name can have the same parent' => 'No pueden existir categorías con el mismo nombre y la misma categoría superior',
    'Can\'t find default template list; where is ' => 'No se encontró la lista de plantillas por defecto; donde está ',
    'Populating blog with default templates failed: [_1]' => 'Fallo guardando el blog con las plantillas por defecto: [_1]',
    'Setting up mappings failed: [_1]' => 'Fallo la configuración de mapeos: [_1]',
    'Weblog \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' creado por \'[_2]\' (usuario nº[_3])',
    'Passwords do not match.' => 'Las contraseñas no coinciden.',
    'Failed to verify current password.' => 'Fallo al verificar la contraseña actual.',
    'Password hint is required.' => 'La pista para la contraseña es obligatoria.',
    'An author by that name already exists.' => 'Ya existe un autor con dicho nombre.',
    'Saving object failed: [_1]' => 'Fallo guardando objeto: [_1]',
    'No Name' => 'Sin nombre',
    'Notification List' => 'Lista de notificaciones',
    'email addresses' => 'dirección de correo-e', # Translate
    'IP addresses' => 'direcciones IP', # Translate
    'Can\'t delete that way' => 'No puede borrar de esa forma',
    'Your login session has expired.' => 'Su sesión expiró.',
    'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => 'No puede eliminar esa categoría porque tiene subcategorías. Mueva o elimine primero las categorías si desea eliminar ésta.',
    'Weblog \'[_1]\' deleted by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' borrado por \'[_2]\' (usuario nº[_3])',
    'Unknown object type [_1]' => 'Tipo de objeto desconocido [_1]',
    'Loading object driver [_1] failed: [_2]' => 'Falló cargando el controlador de objetos [_1]: [_2]',
    'Invalid filename \'[_1]\'' => 'Nombre de fichero no válido \'[_1]\'',
    'Reading \'[_1]\' failed: [_2]' => 'Fallo leyendo \'[_1]\': [_2]',
    'Thumbnail failed: [_1]' => 'Fallo vista previa: [_1]',
    'Error writing to \'[_1]\': [_2]' => 'Error escribiendo en \'[_1]\': [_2]',
    'Invalid basename \'[_1]\'' => 'Nombre base no válido \'[_1]\'',
    'No such commenter [_1].' => 'No existe el comentarista [_1].',
    'Need a status to update entries' => 'Necesita indicar un estado para actualizar las entradas',
    'Need entries to update status' => 'Necesita entradas para actualizar su estado',
    'One of the entries ([_1]) did not actually exist' => 'Una de las entradas ([_1]) no existe actualmente',
    'Some entries failed to save' => 'Algunas entradas fallaron al guardar',
    'You don\'t have permission to approve this TrackBack.' => 'No tiene permisos para aprobar este TrackBack.',
    'You don\'t have permission to approve this comment.' => 'No tiene permiso para aprobar este comentario.',
    'Orphaned comment' => 'Comentario huérfano',
    'Plugin Set: [_1]' => 'Conjunto de plugins: [_1]',
    'No Excerpt' => 'Sin resumen',
    'No Title' => 'Sin título',
    'Orphaned TrackBack' => 'TrackBack huérfano',
    'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Fecha no válida \'[_1]\'; debe tener el formato YYYY-MM-DD HH:MM:SS.',
    'Saving entry \'[_1]\' failed: [_2]' => 'Fallo guardando entrada \'[_1]\': [_2]',
    'Removing placement failed: [_1]' => 'Fallo eliminando lugar: [_1]',
    'No such entry.' => 'No existe la entrada.',
    'Your weblog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Su weblog no tiene configurados la ruta y URL. No puede publicar entradas hasta que las defina.',
    'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Fecha no válida \'[_1]\'; debe ser una fecha real.',
    '\'[_1]\' (user #[_2]) added entry #[_3]' => '\'[_1]\' (usuario nº[_2]) añadió la entrada nº[_3]',
    'The category must be given a name!' => 'Debe darle un nombre a la categoría.',
    'yyyy/mm/entry_basename' => 'aaaa/mm/entrada_nombrebase', # Translate
    'yyyy/mm/entry_basename/' => 'aaaa/mm/entrada_nombrebase/', # Translate
    'yyyy/mm/dd/entry_basename' => 'aaaa/mm/dd/entrada_nombrebase', # Translate
    'yyyy/mm/dd/entry_basename/' => 'aaaa/mm/dd/entrada_nombrebase/', # Translate
    'category/sub_category/entry_basename' => 'categoría/sub_categoría/entrada_nombrebase', # Translate
    'category/sub_category/entry_basename/' => 'categoría/sub_categoría/entrada_nombrebase/', # Translate
    'category/sub-category/entry_basename' => 'categoría/sub-categoría/entrada_nombrebase', # Translate
    'category/sub-category/entry_basename/' => 'categoría/sub-categoría/entrada_nombrebase/', # Translate
    'primary_category/entry_basename' => 'categoría_principal/entrada_nombrebase', # Translate
    'primary_category/entry_basename/' => 'categoría_principal/entrada_nombrebase/', # Translate
    'primary-category/entry_basename' => 'categoría-principal/entrada_nombrebase', # Translate
    'primary-category/entry_basename/' => 'categoría-principal/entrada_nombrebase/', # Translate
    'yyyy/mm/' => 'aaaa/mm/', # Translate
    'yyyy_mm' => 'aaaa_mm', # Translate
    'yyyy/mm/dd/' => 'aaaa/mm/dd/', # Translate
    'yyyy_mm_dd' => 'aaaa_mm_dd', # Translate
    'yyyy/mm/dd-week/' => 'aaaa/mm/dd-week/', # Translate
    'week_yyyy_mm_dd' => 'semana_aaaa_mm_dd', # Translate
    'category/sub_category/' => 'categoría/sub_categoría/', # Translate
    'category/sub-category/' => 'categoría/sub-categoría/', # Translate
    'cat_category' => 'cat_categoría', # Translate
    'Saving blog failed: [_1]' => 'Fallo guardando blog: [_1]',
    'You do not have permission to configure the blog' => 'No tiene permiso para configurar el blog',
    'Saving map failed: [_1]' => 'Fallo guardando mapa: [_1]',
    'Parse error: [_1]' => 'Error de interpretación: [_1]',
    'Build error: [_1]' => 'Error construyendo: [_1]',
    'index template \'' => 'plantilla índice \'',
    'entry \'' => 'entrada \'',
    'Ping \'[_1]\' failed: [_2]' => 'Falló ping \'[_1]\' : [_2]',
    'Edit Permissions' => 'Editar permisos',
    'No entry ID provided' => 'No se provió ID de entrada ',
    'No such entry \'[_1]\'' => 'No existe la entrada \'[_1]\'',
    'No email address for author \'[_1]\'' => 'No hay dirección de correo electrónico asociada al autor \'[_1]\'',
    '[_1] Update: [_2]' => '[_1] Actualiza: [_2]',
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
    'Saving object failed: [_2]' => 'Fallo al guardar objeto: [_2]',
    'Search & Replace' => 'Buscar & Reemplazar',
    'No blog ID' => 'No es ID de blog',
    'You do not have export permissions' => 'No tiene permisos de exportación',
    'You do not have import permissions' => 'No tiene permisos de importación',
    'You do not have permission to create authors' => 'No tiene permisos para crear autores',
    'Can\'t open directory \'[_1]\': [_2]' => 'No se puede abrir el directorio \'[_1]\': [_2]',
    'No readable files could be found in your import directory [_1].' => 'No se encontrón ningún fichero legible en su directorio de importación [_1].',
    'Importing entries from file \'[_1]\'' => 'Importando entradas desde el fichero \'[_1]\'',
    'Can\'t open file \'[_1]\': [_2]' => 'No se pudo abrir el fichero \'[_1]\': [_2]',
    'Creating new author (\'' => 'Creando un nuevo autor (\'',
    'ok\n' => 'ok\n', # Translate
    'failed\n' => 'falló\n',
    'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Invalid date format \'[_1]\'; must be \'MM/DD/AAAA HH:MM:SS AM|PM\' (AM|PM es opcional)', # Translate
    'Preferences' => 'Preferencias',
    'Saving permissions failed: [_1]' => 'Fallo guardando permisos: [_1]',
    'Add a Category' => 'Añadir una categoría',
    'Category name cannot be blank.' => 'El nombre de la categoría no puede estar en blanco.',
    'That action ([_1]) is apparently not implemented!' => '¡La acción ([_1]) aparentemente no está implementada!',

    ## ./lib/MT/Plugin/JunkFilter.pm
    'from rule' => 'desde la regla',
    'from test' => 'desde el test',

    ## ./lib/MT/L10N/es.pm

    ## ./lib/MT/L10N/fr.pm

    ## ./lib/MT/L10N/de.pm

    ## ./lib/MT/L10N/ja.pm

    ## ./lib/MT/L10N/en_us.pm

    ## ./lib/MT/L10N/nl.pm

    ## ./plugins/spamlookup/lib/spamlookup.pm

    ## ./t/Foo.pm

    ## ./t/Bar.pm

    ## ./t/lib/LWP/UserAgent/Local.pm

    ## ./t/lib/Text/WikiFormat.pm

    ## ./mt-static/mt.js
    'You did not select any [_1] to delete.' => 'No seleccionó ningún [_1] para borrar.', # Translate
    'Are you sure you want to delete this [_1]?' => '¿Está seguro de que desea borrar este [_1]?', # Translate
    'Are you sure you want to delete the [_1] selected [_2]?' => '¿Está seguro de que desea borrar el [_1] seleccionado [_2]?', # Translate
    'to delete' => 'para borrar', # Translate
    'You did not select any [_1] [_2].' => 'No seleccionó ningún [_1] [_2].', # Translate
    'You must select an action.' => 'Debe seleccionar una acción.', # Translate
    'to mark as junk' => 'para marcar como basura', # Translate
    'to remove "junk" status' => 'para eliminar el estado "basura"', # Translate
    'Enter email address:' => 'Teclee la dirección de correo-e:', # Translate
    'Enter URL:' => 'Teclee la URL:', # Translate

    ## ./extras/examples/plugins/mirror/lib/Mirror.pm
);

1;
