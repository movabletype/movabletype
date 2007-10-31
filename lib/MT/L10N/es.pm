package MT::L10N::es;
# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
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
    '[_1] [_2] Modules:' => '[_1] módulos [_2]:', # Translate - New (4)
    'Some of the following modules are required by the various data storage options in Movable Type. In order run the system, your server needs to have DBI and at least one of the other modules installed.' => 'Algunos de los siguientes módulos se necesitan para las diferentes opciones de base de datos en Movable Type. Para ejecutar el sistema, su servidor necesita tener instalado DBI y al menos uno de los otros módulos.',
    'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'O su servidor no tiene instalado [_1], o la versión que tiene instalada es muy antigua, o [_1] necesita otro módulo que no está instalado.',
    'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => 'Su servidor no tiene [_1] instalado, o [_1] necesita otro módulo que no está instalado.',
    'Please consult the installation instructions for help in installing [_1].' => 'Por favor, consulte las instrucciones de instalación para obtener ayuda de cómo instalar [_1].',
    'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN.' => 'La versión de DBD::mysql que tiene instalada es conocida por ser incompatible con Movable Type. Por favor, instale la versión actual desde CPAN.',
    'The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements.' => 'El $mod está instalado correctamente, pero necesita un módulo DBI actualizado. Por favor, consulte la nota de arriba sobre los requerimientos del módulo DBI.',
    'Your server has [_1] installed (version [_2]).' => 'Su servidor tiene [_1] instalado (versión [_2]).',
    'Movable Type System Check Successful' => 'Comprobación del sistema correcta.',
    'You\'re ready to go!' => '¡Todo listo para continuar!',
    'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Su servidor dispone de todos los módulos requeridos; no necesita instalar ningún módulo adicional. Puede continuar con las instrucciones de instalación.',

    ## ./addons/Enterprise.pack/tmpl/cfg_ldap.tmpl

    ## ./addons/Enterprise.pack/tmpl/edit_group.tmpl

    ## ./addons/Enterprise.pack/tmpl/list_group.tmpl

    ## ./addons/Enterprise.pack/tmpl/list_group_member.tmpl
    'member' => 'miembros',
    'Remove' => 'Borrar',
    'Remove selected members ()' => 'Borrar los miembros seleccionados ()',

    ## ./addons/Enterprise.pack/tmpl/select_groups.tmpl

    ## ./build/exportmt.pl

    ## ./build/template_hash_signatures.pl

    ## ./build/l10n/diff.pl

    ## ./build/l10n/trans.pl

    ## ./build/l10n/wrap.pl

    ## ./extras/examples/plugins/BackupRestoreSample/BackupRestoreSample.pl
    'This plugin is to test out the backup restore callback.' => 'Esta extensión es para probar la retrollamada de recuperación de la copia de seguridad.', # Translate - New (10)

    ## ./extras/examples/plugins/CommentByGoogleAccount/CommentByGoogleAccount.pl
    'You can allow readers to authenticate themselves via Google Account to comment on posts.' => 'Puede permitir a los lectores autentificarse vía Google Account para comentar en las entradas.', # Translate - New (14)

    ## ./extras/examples/plugins/CommentByGoogleAccount/tmpl/config.tmpl

    ## ./extras/examples/plugins/FiveStarRating/plugins/FiveStarRating/FiveStarRating.pl
    'Allow readers to rate entries, assets, comments and trackbacks.' => 'Permitir a los lectores puntuar entradas, elementos, comentarios y trackbacks.', # Translate - New (9)

    ## ./extras/examples/plugins/l10nsample/l10nsample.pl
    'l10nsample' => 'l10nsample', # Translate - Previous (2)
    'This description can be localized if there is l10n_class set.' => 'Esta descripción se puede traducir si se configura l10n_class.',
    'Fumiaki Yoshimatsu' => 'Fumiaki Yoshimatsu', # Translate - Previous (2)

    ## ./extras/examples/plugins/l10nsample/tmpl/view.tmpl
    'This phrase is processed in template.' => 'Esta frase se procesa en la plantilla.',

    ## ./extras/examples/plugins/mirror/mirror.pl

    ## ./extras/examples/plugins/mirror/tmpl/mirror.tmpl

    ## ./extras/examples/plugins/reCaptcha/plugins/reCaptcha/reCaptcha.pl

    ## ./extras/examples/plugins/SharedSecret/plugins/SharedSecret/SharedSecret.pl

    ## ./extras/examples/plugins/SimpleScorer/SimpleScorer.pl
    'Scores each entry.' => 'Puntúa cada entrada.', # Translate - New (3)

    ## ./extras/examples/plugins/SimpleScorer/tmpl/scored.tmpl

    ## ./lib/MT/default-templates.pl

    ## ./plugins/Cloner/cloner.pl
    'Clones a weblog and all of its contents.' => 'Clonar un weblog y todos sus contenidos.',
    'Cloning Weblog' => 'Clonando weblog',
    'Error' => 'Error', # Translate - Previous (1)
    'Close' => 'Cerrar',

    ## ./plugins/ExtensibleArchives/AuthorArchive.pl
    'TBD' => 'TBD', # Translate - New (1)

    ## ./plugins/ExtensibleArchives/DatebasedCategories.pl

    ## ./plugins/feeds-app-lite/mt-feeds.pl
    'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type?' => 'Feeds.App Lite le ayuda a publicar fuentes de sindicación en los blogs. ¿Desea hacer más cosas con fuentes en Movable Type?',
    'Upgrade to Feeds.App' => 'Actualícese a Feeds.App',

    ## ./plugins/feeds-app-lite/tmpl/config.tmpl
    'Feeds.App Lite Widget Creator' => 'Creador de widgets de Feeds.App Lite',
    'Feed Configuration' => 'Configuración de fuentes',
    '3' => '3', # Translate - Previous (1)
    '5' => '5', # Translate - Previous (1)
    '10' => '10', # Translate - Previous (1)
    'All' => 'Todos',
    'Save' => 'Guardar',

    ## ./plugins/feeds-app-lite/tmpl/footer.tmpl

    ## ./plugins/feeds-app-lite/tmpl/header.tmpl
    'Main Menu' => 'Menú principal',
    'System Overview' => 'Resumen del sistema',
    'Help' => 'Ayuda',
    'Welcome' => 'Bienvenido',
    'Logout' => 'Cerrar sesión',
    'Search' => 'Buscar',
    'Entries' => 'Entradas',
    'Search (q)' => 'Buscar (q)',

    ## ./plugins/feeds-app-lite/tmpl/msg.tmpl
    'No feeds could be discovered using [_1].' => 'No se descubrieron fuentes usando [_1].',
    'An error occurred processing [_1]. Check <a href=' => 'Ocurrió un error procesando. Compruebe <a href=',
    'It can be included onto your published blog using <a href=' => 'Puede incluirse en su blog usando <a href=',
    'It can be included onto your published blog using this MTInclude tag' => 'Puede incluirse en su blog usando esta etiqueta MTInclude',
    'Go Back' => 'Ir atrás',
    'Create Another' => 'Crear otro',

    ## ./plugins/feeds-app-lite/tmpl/select.tmpl
    'Multiple feeds were discovered. Select the feed you wish to use. Feeds.App Lite supports text-only RSS 1.0, 2.0 and Atom feeds.' => 'Se descubrieron varias fuentes de sindicación. Seleccione la que desee usar. Feeds.App Lite soporta fuentes RSS 1.0, 2.0 y Atom (solo texto).',
    'Type' => 'Tipo',
    'URI' => 'URI', # Translate - Previous (1)
    'Continue' => 'Continuar',

    ## ./plugins/feeds-app-lite/tmpl/start.tmpl
    'Feeds.App Lite creates modules that include feed data. Once you\'ve used it to create those modules, you can then use them in your blog templates.' => 'Feeds.App Lite crea módulos para incluir datos de fuentes de sindicación (\'feeds\'). Una vez sepa crear estos módulos, podrá usarlos en las plantillas de sus blogs.',
    'You must enter an address to proceed' => 'Debe introducir una dirección para proceder',
    'Enter the URL of a feed, or the URL of a site that has a feed.' => 'Introduzca la URL de una fuente de sindicación, o la URL de un sitio que tenga una fuente.',

    ## ./plugins/GoogleSearch/GoogleSearch.pl

    ## ./plugins/GoogleSearch/tmpl/config.tmpl

    ## ./plugins/Markdown/Markdown.pl

    ## ./plugins/Markdown/SmartyPants.pl

    ## ./plugins/MultiBlog/multiblog.pl
    'MultiBlog allows you to publish templated or raw content from other blogs and define rebuild dependencies and access controls between them.' => 'MultiBlog le permite publicar contenidos de otros blogs sin procesar o en plantillas, y definir dependencias de reconstrucción y controles de acceso entre ellos.',

    ## ./plugins/MultiBlog/tmpl/blog_config.tmpl
    'When' => 'Cuando',
    'Any Weblog' => 'Cualquier weblog',
    'Weblog' => 'Weblog', # Translate - Previous (1)
    'Trigger' => 'Disparador',
    'Action' => 'Acción',
    'Use system default' => 'Utilizar opciones predefinidas del sistema',
    'Allow' => 'Permitir',
    'Disallow' => 'No permitir',
    'Include blogs' => 'Incluir blogs',
    'Exclude blogs' => 'Excluir blogs',
    'Current Rebuild Triggers:' => 'Actuales disparadores de reconstrucción:',
    'Create New Rebuild Trigger' => 'Crear nuevo disparador de reconstrucción',
    'You have not defined any rebuild triggers.' => 'No tiene definido ningún disparador de reconstrucción.',

    ## ./plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl

    ## ./plugins/MultiBlog/tmpl/system_config.tmpl
    'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'Se permitirá la agregación entre blogs. Los blogs individuales pueden configurarse a través de las opciones MultiBlog a nivel de blog para restringir el acceso a su contenido a otros blogs.',
    'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'La agregación entre blogs puede no permitirse por defecto. Los blogs individuales pueden configurarse a través de las opciones MultiBlog a nivel de blog para permitir el acceso a su contenido a otros blogs.',

    ## ./plugins/spamlookup/spamlookup.pl
    'SpamLookup module for using blacklist lookup services to filter feedback.' => 'Módulo de SpamLookup para usar servicios de listas negras para filtrar las opiniones.',

    ## ./plugins/spamlookup/spamlookup_urls.pl
    'SpamLookup - Link' => 'SpamLookup - Enlace',
    'SpamLookup module for junking and moderating feedback based on link filters.' => 'Módulo de SpamLookup para marcar como basura y moderar las opiniones en base a filtros de enlaces.',

    ## ./plugins/spamlookup/spamlookup_words.pl
    'SpamLookup module for moderating and junking feedback using keyword filters.' => 'Módulo de SpamLookup para moderar y marcar como basura las opiniones usando filtros de palabras clave.',

    ## ./plugins/spamlookup/tmpl/lookup_config.tmpl
    'Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog\'s Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.' => 'Las comprobaciones monitorizan las direcciones IP de origen y los hiperenlaces de todas las opiniones entrantes. Si un comentario o TrackBack viene de una dirección IP incluída en una lista negra, se bloqueará para su moderación o se marcará como basura y se trasladará a la carpeta de Basura. De forma adicional, se podrán realizar comprobaciones avanzadas en los datos de TrackBack.',
    'IP Address Lookups:' => 'Comprobaciones de direcciones IP:',
    'Off' => 'Desactivar',
    'Moderate feedback from blacklisted IP addresses' => 'Moderar las opiniones de las direcciones IP incluídas en listas negras',
    'Junk feedback from blacklisted IP addresses' => 'Marcar como basura las opiniones de las direcciones IP incluídas en listas negras',
    'Adjust scoring' => 'Ajustar puntuación',
    'Score weight:' => 'Peso de puntuación:',
    'Less' => 'Menos',
    'Decrease' => 'Disminuir',
    'Increase' => 'Aumentar',
    'More' => 'Más',
    'block' => 'bloquear',
    'none' => 'nada',
    'Domain Name Lookups:' => 'Comprobaciones de dominios:',
    'Moderate feedback containing blacklisted domains' => 'Moderar las opiniones que contengan dominios incluídos en las listas negras',
    'Junk feedback containing blacklisted domains' => 'Moderar las opiniones que contengan dominios incluídos en las listas negras',
    'Moderate TrackBacks from suspicious sources' => 'Moderar los TrackBacks de origen sospechoso',
    'Junk TrackBacks from suspicious sources' => 'Marcar como basura los TrackBacks de origen sospechoso',
    'To prevent lookups for some IP addresses or domains, list them below. Place each entry on a line by itself.' => 'Para prevenir la comprobación de ciertas direcciones IP o dominios, lístelos abajo. Indique cada uno en líneas separadas.',
    'Lookup Whitelist:' => 'Lista blanca:',

    ## ./plugins/spamlookup/tmpl/url_config.tmpl
    'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Los filtros de enlaces monitorizan el número de hiperenlaces que llegan en las opiniones entrantes. Las opiniones con muchos enlaces se bloquean para moderarlos o se marcan como basura. Por el contrario, las opiniones que no tienen enlaces o contienen referencias a URLs publicadas con anterioridad se puntúan de forma positiva. (Habilite sólo esta opción si está completamente seguro de que su sitio está libre previamente de spam)',
    'Credit feedback rating when no hyperlinks are present' => 'Puntuación de las opiniones cuando no hay hiperenlaces presentes',
    'Moderate when more than' => 'Moderar cuando se dan más de',
    'link(s) are given' => 'enlace/s',
    'Junk when more than' => 'Marcar como basura cuando hay más de',
    'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Puntuación de las opiniones cuando el elemento &quot;URL&quot; de la opinión se ha publicado antes',
    'Only applied when no other links are present in message of feedback.' => 'Solo se aplica cuando no hay otros enlaces presentes en el mensaje de la opinión.',
    'Exclude URLs from comments published within last [_1] days.' => 'Excluir las URLs de los comentarios publicados en los últimos[_1] días.',
    'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Puntuación de las opiniones cuando la dirección de &quot;correo electrónico&quot; se encuentra en comentarios publicados con anterioridad',
    'Exclude Email addresses from comments published within last [_1] days.' => 'Excluir las direcciones de correo electrónico de los comentarios publicados en los últimos [_1] días.',

    ## ./plugins/spamlookup/tmpl/word_config.tmpl
    'Incomming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Las opiniones entrantes se pueden monitorizar según palabras clave, dominios, y patrones. Las coincidencias se pueden bloquear para moderarlas o puntuarlas como basura. Adicionalmente, la puntuación de las opiniones basura se pueden personalizar.',

    ## ./plugins/StyleCatcher/stylecatcher.pl
    '<p style=' => '<p style=', # Translate - Previous (3)
    'Theme Root URL:' => 'URL del estilo:',
    'Theme Root Path:' => 'Directorio del estilo:',
    'Style Library URL:' => 'URL de la biblioteca de estilos:',

    ## ./plugins/StyleCatcher/tmpl/footer.tmpl

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
    'Categories' => 'Categorías',
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

    ## ./plugins/TemplateRefresh/TemplateRefresh.pl
    'Backup and refresh existing templates to Movable Type\'s default templates.' => 'Realizar copia de seguridad y refrescar las plantillas existentes con las plantillas por defecto de Movable Type.',

    ## ./plugins/TemplateRefresh/tmpl/results.tmpl
    'Backup and Refresh Templates' => 'Copiar y refrescar plantillas',
    'No templates were selected to process.' => 'No se han seleccionado plantillas para procesar.',
    'Return' => 'Volver',

    ## ./plugins/Textile/textile2.pl

    ## ./plugins/WidgetManager/WidgetManager.pl
    'Maintain your weblog\'s widget content using a handy drag and drop interface.' => 'Mantener el contenido del widget de su weblog utilizando un interfaz de arrastrar y soltar.',

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

    ## ./plugins/WidgetManager/default_widgets/category_archive_list.tmpl

    ## ./plugins/WidgetManager/default_widgets/copyright.tmpl

    ## ./plugins/WidgetManager/default_widgets/creative_commons.tmpl
    'This weblog is licensed under a' => 'Este weblog está licenciado bajo una',
    'Creative Commons License' => 'Licencia Creative Commons',

    ## ./plugins/WidgetManager/default_widgets/date-based_author_archives.tmpl

    ## ./plugins/WidgetManager/default_widgets/date-based_category_archives.tmpl

    ## ./plugins/WidgetManager/default_widgets/monthly_archive_dropdown.tmpl
    'Archives' => 'Archivos',
    'Select a Month...' => 'Seleccione un mes...',

    ## ./plugins/WidgetManager/default_widgets/monthly_archive_list.tmpl

    ## ./plugins/WidgetManager/default_widgets/pages_list.tmpl

    ## ./plugins/WidgetManager/default_widgets/powered_by.tmpl

    ## ./plugins/WidgetManager/default_widgets/recent_comments.tmpl
    'Recent Comments' => 'Comentarios recientes',

    ## ./plugins/WidgetManager/default_widgets/recent_posts.tmpl
    'Recent Posts' => 'Entradas recientes',

    ## ./plugins/WidgetManager/default_widgets/search.tmpl
    'Search this blog:' => 'Buscar en este blog:',

    ## ./plugins/WidgetManager/default_widgets/signin.tmpl

    ## ./plugins/WidgetManager/default_widgets/subscribe_to_feed.tmpl
    'Subscribe to this blog\'s feed' => 'Suscribirse a este blog (XML)',
    'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds', # Translate - Previous (6)
    'What is this?' => '¿Qué es esto?',

    ## ./plugins/WidgetManager/default_widgets/tag_cloud_module.tmpl
    'Tag cloud' => 'Nube de etiquetas',

    ## ./plugins/WidgetManager/default_widgets/technorati_search.tmpl
    'Technorati' => 'Technorati', # Translate - Previous (1)
    'this blog' => 'este blog',
    'all blogs' => 'todos los blogs',
    'Blogs that link here' => 'Blogs que enlazan aquí',

    ## ./plugins/WidgetManager/tmpl/edit.tmpl
    'Please use a unique name for this widget manager.' => 'Por favor, use un nombre único para este administrador de widgets.', # Translate - New (9)
    'You already have a widget manager named [_1]. Please use a unique name for this widget manager.' => 'Ya tiene un administrador de widgets llamado [_1]. Por favor, use un nombre único para este administrador de widgets.',
    'Your changes to the Widget Manager have been saved.' => 'Se han guardado los cambios del Administrador de widgets.',
    'Installed Widgets' => 'Widgets instalados',
    'Available Widgets' => 'Widgets disponibles',
    'Save Changes' => 'Guardar cambios',
    'Save changes (s)' => 'Guardar cambios (s)',

    ## ./plugins/WidgetManager/tmpl/footer.tmpl

    ## ./plugins/WidgetManager/tmpl/header.tmpl
    'Movable Type Publishing Platform' => 'Movable Type Publishing Platform', # Translate - Previous (4)
    'Go to:' => 'Ir a:',
    'Select a blog' => 'Seleccione un blog',
    'Weblogs' => 'Weblogs', # Translate - Previous (1)
    'System-wide listing' => 'Lista del sistema',

    ## ./plugins/WidgetManager/tmpl/list.tmpl

    ## ./plugins/WXRImporter/WXRImporter.pl
    'Import WordPress exported RSS into MT.' => 'Importar RSS exportado de WordPress a MT.', # Translate - New (6)

    ## ./plugins/WXRImporter/tmpl/options.tmpl
    'Site Root' => 'Raíz del sitio',
    'Archive Root' => 'Raíz de archivos',

    ## ./search_templates/comments.tmpl
    'Search Results' => 'Resultado de la búsqueda',
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
    'Instructions' => 'Instrucciones',
    'Select the time interval that you\'d like to search in, then click \'Find new comments\'' => 'Seleccione el intervalo temporal en el que desea buscar, y luego haga clic en \'Buscar nuevos comentarios\'',

    ## ./search_templates/default.tmpl
    'SEARCH FEED AUTODISCOVERY LINK PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'EL ENLACE DE AUTODESCUBRIMIENTO DE LA FUENTE DE SINDICACIÓN DE BÚSQUEDAS SOLO SE PUBLICA CUANDO SE HA REALIZADO UNA BÚSQUEDA',
    'Blog Search Results' => 'Resultados de la búsqueda en el blog',
    'Blog search' => 'Buscar en el blog',
    'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM', # Translate - Previous (7)
    'Search this site' => 'Buscar en este sitio',
    'Match case' => 'Distinguir mayúsculas',
    'Regex search' => 'Expresión regular',
    'SEARCH RESULTS DISPLAY' => 'MOSTRAR RESULTADOS DE LA BÚSQUEDA',
    'Matching entries from [_1]' => 'Entradas coincidentes de [_1]',
    'Entries from [_1] tagged with \'[_2]\'' => 'Entradas de [_1] etiquetadas en \'[_2]\'',
    'Tags' => 'Etiquetas',
    'Posted <MTIfNonEmpty tag=' => 'Publicado <MTIfNonEmpty tag=',
    'Showing the first [_1] results.' => 'Mostrando los primeros [_1] resultados.',
    'NO RESULTS FOUND MESSAGE' => 'MENSAJE DE NINGÚN RESULTADO ENCONTRADO',
    'Entries matching \'[_1]\'' => 'Entradas coincidentes con \'[_1]\'',
    'Entries tagged with \'[_1]\'' => 'Entradas etiquetadas en \'[_1]\'',
    'No pages were found containing \'[_1]\'.' => 'No se encontraron páginas que contuvieran \'[_1]\'.',
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
    'END OF PAGE BODY' => 'FIN DEL CUERPO DE LA PÁGINA',
    'END OF CONTAINER' => 'FIN DEL CONTENEDOR',

    ## ./search_templates/results_feed.tmpl
    'Search Results for [_1]' => 'Resultados de la búsqueda sobre [_1]',

    ## ./search_templates/results_feed_rss2.tmpl

    ## ./t/blog-common.pl

    ## ./t/driver-tests.pl

    ## ./t/test-common.pl

    ## ./t/test.tmpl

    ## ./t/plugins/testplug.pl

    ## ./tmpl/error.tmpl
    'Missing Configuration File' => 'Fichero de configuración no encontrado',
    'Database Connection Error' => 'Error de conexión a la base de datos',
    'CGI Path Configuration Required' => 'Se necesita la configuración de la ruta de CGI',
    'An error occurred' => 'Ocurrió un error',

    ## ./tmpl/cms/admin.tmpl

    ## ./tmpl/cms/author_bulk.tmpl

    ## ./tmpl/cms/backup.tmpl

    ## ./tmpl/cms/bookmarklets.tmpl

    ## ./tmpl/cms/cc_return.tmpl

    ## ./tmpl/cms/cfg_archives.tmpl

    ## ./tmpl/cms/cfg_comments.tmpl

    ## ./tmpl/cms/cfg_entry.tmpl

    ## ./tmpl/cms/cfg_plugin.tmpl

    ## ./tmpl/cms/cfg_prefs.tmpl

    ## ./tmpl/cms/cfg_spam.tmpl

    ## ./tmpl/cms/cfg_system_feedback.tmpl

    ## ./tmpl/cms/cfg_system_general.tmpl

    ## ./tmpl/cms/cfg_trackbacks.tmpl

    ## ./tmpl/cms/cfg_web_services.tmpl

    ## ./tmpl/cms/create_author_bulk_end.tmpl

    ## ./tmpl/cms/create_author_bulk_start.tmpl

    ## ./tmpl/cms/dashboard.tmpl

    ## ./tmpl/cms/dialog_adjust_sitepath.tmpl

    ## ./tmpl/cms/edit_author.tmpl

    ## ./tmpl/cms/edit_blog.tmpl

    ## ./tmpl/cms/edit_category.tmpl

    ## ./tmpl/cms/edit_comment.tmpl

    ## ./tmpl/cms/edit_commenter.tmpl

    ## ./tmpl/cms/edit_entry.tmpl

    ## ./tmpl/cms/edit_folder.tmpl

    ## ./tmpl/cms/edit_ping.tmpl

    ## ./tmpl/cms/edit_role.tmpl

    ## ./tmpl/cms/edit_template.tmpl

    ## ./tmpl/cms/error.tmpl

    ## ./tmpl/cms/export.tmpl

    ## ./tmpl/cms/handshake_return.tmpl

    ## ./tmpl/cms/import.tmpl

    ## ./tmpl/cms/import_others.tmpl

    ## ./tmpl/cms/install.tmpl

    ## ./tmpl/cms/list_asset.tmpl

    ## ./tmpl/cms/list_association.tmpl
    'Remove selected assocations (x)' => 'Eliminar asociaciones seleccionadas (x)',
    'association' => 'asociación',
    'associations' => 'asociaciones',

    ## ./tmpl/cms/list_author.tmpl

    ## ./tmpl/cms/list_banlist.tmpl

    ## ./tmpl/cms/list_blog.tmpl

    ## ./tmpl/cms/list_category.tmpl

    ## ./tmpl/cms/list_comment.tmpl

    ## ./tmpl/cms/list_commenter.tmpl

    ## ./tmpl/cms/list_entry.tmpl

    ## ./tmpl/cms/list_folder.tmpl

    ## ./tmpl/cms/list_notification.tmpl

    ## ./tmpl/cms/list_ping.tmpl

    ## ./tmpl/cms/list_role.tmpl

    ## ./tmpl/cms/list_tag.tmpl
    'Delete' => 'Eliminar',
    'tag' => 'etiqueta',
    'tags' => 'etiquetas',
    'Delete selected tags (x)' => 'Borrar etiquetas seleccionadas (x)',

    ## ./tmpl/cms/list_template.tmpl
    'template' => 'plantilla',
    'templates' => 'plantillas',

    ## ./tmpl/cms/login.tmpl

    ## ./tmpl/cms/menu.tmpl

    ## ./tmpl/cms/pinging.tmpl

    ## ./tmpl/cms/preview_entry.tmpl

    ## ./tmpl/cms/rebuilding.tmpl

    ## ./tmpl/cms/recover_password_result.tmpl

    ## ./tmpl/cms/reload_opener.tmpl

    ## ./tmpl/cms/restore.tmpl

    ## ./tmpl/cms/restore_end.tmpl

    ## ./tmpl/cms/restore_start.tmpl

    ## ./tmpl/cms/search_replace.tmpl

    ## ./tmpl/cms/system_check.tmpl

    ## ./tmpl/cms/upgrade.tmpl

    ## ./tmpl/cms/upgrade_runner.tmpl

    ## ./tmpl/cms/view_log.tmpl
    'Clear Activity Log' => 'Crear histórico de actividad', # Translate - New (3)

    ## ./tmpl/cms/dialog/asset_image_options.tmpl

    ## ./tmpl/cms/dialog/asset_insert.tmpl

    ## ./tmpl/cms/dialog/footer.tmpl

    ## ./tmpl/cms/dialog/grant_role.tmpl

    ## ./tmpl/cms/dialog/header.tmpl

    ## ./tmpl/cms/dialog/list_assets.tmpl

    ## ./tmpl/cms/dialog/post_comment.tmpl

    ## ./tmpl/cms/dialog/post_comment_end.tmpl

    ## ./tmpl/cms/dialog/restore_end.tmpl

    ## ./tmpl/cms/dialog/restore_start.tmpl

    ## ./tmpl/cms/dialog/restore_upload.tmpl

    ## ./tmpl/cms/dialog/select_users.tmpl

    ## ./tmpl/cms/dialog/select_weblog.tmpl

    ## ./tmpl/cms/dialog/upload.tmpl

    ## ./tmpl/cms/dialog/upload_complete.tmpl

    ## ./tmpl/cms/dialog/upload_confirm.tmpl

    ## ./tmpl/cms/include/actions_bar.tmpl

    ## ./tmpl/cms/include/anonymous_comment.tmpl

    ## ./tmpl/cms/include/archive_maps.tmpl

    ## ./tmpl/cms/include/author_table.tmpl
    'Status' => 'Estado',
    'Username' => 'Nombre de usuario',
    'Name' => 'Nombre',
    'Email' => 'Correo electrónico',
    'URL' => 'URL', # Translate - Previous (1)
    'Only show enabled users' => 'Solo muestra usuarios habilitados',
    'Only show pending users' => 'Solo muestra usuarios pendientes', # Translate - New (4)
    'Only show disabled users' => 'Solo muestra usuarios deshabilitados',
    'Link' => 'Un vínculo',

    ## ./tmpl/cms/include/backup_end.tmpl
    'All of the data has been backed up successfully!' => '¡La copia de seguridad de los datos se ha realizado con éxito!', # Translate - New (9)
    'Filename' => 'Nombre del fichero', # Translate - New (1)
    '_external_link_target' => '_top',
    'Download This File' => 'Descargar este fichero', # Translate - New (3)
    'An error occurred during the backup process: [_1]' => 'Ocurrió un error durante la copia de seguridad: [_1]', # Translate - New (8)

    ## ./tmpl/cms/include/backup_start.tmpl

    ## ./tmpl/cms/include/blog-left-nav.tmpl
    'Creating' => 'Creando', # Translate - New (1)
    'Create New Entry' => 'Crear nueva entrada',
    'New Entry' => 'Nueva entrada',
    'List Entries' => 'Listar entradas',
    'List uploaded files' => 'Lista de ficheros transferidos', # Translate - New (3)
    'Assets' => 'Elementos', # Translate - New (1)
    'Community' => 'Comunidad',
    'List Comments' => 'Listar comentarios',
    'Comments' => 'Comentarios',
    'List Commenters' => 'Listar comentaristas',
    'Commenters' => 'Comentaristas',
    'List TrackBacks' => 'Listar TrackBacks',
    'TrackBacks' => 'TrackBacks', # Translate - Previous (1)
    'Edit Notification List' => 'Editar lista de notificaciones',
    'Notifications' => 'Notificaciones',
    'Configure' => 'Configurar',
    'List Users &amp; Groups' => 'Lisar usuarios &amp; grupos',
    'Users &amp; Groups' => 'Usuarios &amp; grupos',
    'List &amp; Edit Templates' => 'Listar y editar plantillas',
    'Edit Categories' => 'Editar categorías',
    'Edit Tags' => 'Editar etiquetas',
    'Edit Weblog Configuration' => 'Editar configuración del weblog',
    'Settings' => 'Configuración',
    'Utilities' => 'Herramientas',
    'Search &amp; Replace' => 'Buscar &amp; Reemplazar',
    'Backup this weblog' => 'Hacer una copia de seguridad de este weblog', # Translate - New (3)
    'Backup' => 'Copia de seguridad', # Translate - New (1)
    'View Activity Log' => 'Ver registro de actividad',
    'Activity Log' => 'Registro de actividad',
    'Import &amp; Export Entries' => 'Importar &amp; Exportar entradas',
    'Import / Export' => 'Importar / Exportar',
    'Rebuild Site' => 'Reconstruir sitio',

    ## ./tmpl/cms/include/blog_table.tmpl

    ## ./tmpl/cms/include/cfg_content_nav.tmpl

    ## ./tmpl/cms/include/cfg_entries_edit_page.tmpl
    'Default' => 'Predefinido', # Translate - New (1)
    'Custom' => 'Personalizado',
    'Title' => 'Título',
    'Body' => 'Cuerpo', # Translate - New (1)
    'Category' => 'Categoría',
    'Excerpt' => 'Resumen',
    'Keywords' => 'Palabras clave',
    'Publishing' => 'Publicación',
    'Feedback' => 'Respuestas',
    'Below' => 'Abajo',
    'Above' => 'Arriba',
    'Both' => 'Ambos',

    ## ./tmpl/cms/include/cfg_system_content_nav.tmpl

    ## ./tmpl/cms/include/chromeless_footer.tmpl

    ## ./tmpl/cms/include/chromeless_header.tmpl

    ## ./tmpl/cms/include/commenter_table.tmpl

    ## ./tmpl/cms/include/comment_table.tmpl

    ## ./tmpl/cms/include/copyright.tmpl
    'Copyright &copy; 2001-<mt:date format=' => 'Copyright &copy; 2001-<mt:date format=', # Translate - New (7)

    ## ./tmpl/cms/include/display_options.tmpl

    ## ./tmpl/cms/include/entry_table.tmpl

    ## ./tmpl/cms/include/feed_link.tmpl

    ## ./tmpl/cms/include/footer.tmpl

    ## ./tmpl/cms/include/footer_popup.tmpl

    ## ./tmpl/cms/include/header.tmpl

    ## ./tmpl/cms/include/header_popup.tmpl

    ## ./tmpl/cms/include/import_end.tmpl
    'All data imported successfully!' => '¡Importados con éxito todos los datos!',
    'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Asegúrese de borrar los ficheros importados del directorio \'import\', para evitar procesarlos de nuevo al ejecutar en otra ocasión el proceso de importación.',
    'An error occurred during the import process: [_1]. Please check your import file.' => 'Ocurrió un error durante el proceso de importación: [_1]. Por favor, compruebe su fichero de importación.',

    ## ./tmpl/cms/include/import_start.tmpl
    'Importing entries into blog' => 'Importando entradas en el blog',
    'Importing entries as user \'[_1]\'' => 'Importando entradas como usario \'[_1]\'',
    'Creating new users for each user found in the blog' => 'Creando nuevos usarios para cada usario encontrado en el blog',

    ## ./tmpl/cms/include/itemset_action_widget.tmpl

    ## ./tmpl/cms/include/listing_panel.tmpl
    'Step [_1] of [_2]' => 'Paso [_1] de [_2]',
    'View All' => 'Ver todo',
    'Go to [_1]' => 'Ir a [_1]',
    'Sorry, there were no results for your search. Please try searching again.' => 'Lo siento, no se encontraron resultados para la búsqueda. Por favor, intente buscar de nuevo.',
    'Sorry, there is no data for this object set.' => 'Lo siento, no hay datos para este conjunto de objetos.',
    'Cancel' => 'Cancelar',
    'Back' => 'Regresar',
    'Confirm' => 'Confirmar',

    ## ./tmpl/cms/include/login_mt.tmpl
    'Remember me?' => '¿Recordarme?',

    ## ./tmpl/cms/include/log_table.tmpl

    ## ./tmpl/cms/include/notification_table.tmpl

    ## ./tmpl/cms/include/overview-left-nav.tmpl
    'System' => 'Sistema',
    'List Weblogs' => 'Listar weblogs',
    'List Users and Groups' => 'Listar usuarios y grupos',
    'List Associations and Roles' => 'Listar asociaciones y roles',
    'Privileges' => 'Privilegios',
    'List Plugins' => 'Listar extensiones',
    'Plugins' => 'Extensiones',
    'Aggregate' => 'Listar',
    'List Tags' => 'Listar etiquetas',
    'Edit System Settings' => 'Editar configuración del sistema',
    'Show Activity Log' => 'Mostrar histórico de actividad',

    ## ./tmpl/cms/include/pagination.tmpl

    ## ./tmpl/cms/include/ping_table.tmpl

    ## ./tmpl/cms/include/rebuild_stub.tmpl
    'To see the changes reflected on your public site, you should rebuild your site now.' => 'Para ver reflejados los cambios en su sitio público, debe reconstruir ahora su sitio.',
    'Rebuild my site' => 'Reconstruir sitio',

    ## ./tmpl/cms/include/template_table.tmpl

    ## ./tmpl/cms/include/tools_content_nav.tmpl

    ## ./tmpl/cms/include/typekey.tmpl

    ## ./tmpl/cms/include/users_content_nav.tmpl

    ## ./tmpl/cms/popup/bm_entry.tmpl

    ## ./tmpl/cms/popup/bm_posted.tmpl

    ## ./tmpl/cms/popup/category_add.tmpl

    ## ./tmpl/cms/popup/pinged_urls.tmpl

    ## ./tmpl/cms/popup/rebuild_confirm.tmpl

    ## ./tmpl/cms/popup/rebuilt.tmpl

    ## ./tmpl/cms/popup/recover.tmpl

    ## ./tmpl/cms/popup/show_upload_html.tmpl

    ## ./tmpl/comment/error.tmpl

    ## ./tmpl/comment/login.tmpl

    ## ./tmpl/comment/profile.tmpl

    ## ./tmpl/comment/register.tmpl
    'Register' => 'Registrarse', # Translate - New (1)

    ## ./tmpl/comment/signup.tmpl

    ## ./tmpl/comment/signup_thanks.tmpl

    ## ./tmpl/comment/include/footer.tmpl

    ## ./tmpl/comment/include/header.tmpl

    ## ./tmpl/email/commenter_confirm.tmpl
    'Thank you registering for an account to comment on [_1].' => 'Gracias por registrar una cuenta para comentar en [_1].', # Translate - New (10)
    'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to comment on [_1].' => 'Para su propia seguridad, y para prevenir fraudes, antes de continuar le solicitamos que confirme su cuenta y dirección de correo. Tras confirmarlas, podrá comentar en [_1].', # Translate - New (32)
    'To confirm your account, please click on or cut and paste the following URL into a web browser:' => 'Para confirmar su cuenta, haga clic en (o copie y pegue) la URL en un navegador web:', # Translate - New (18)
    'If you did not make this request, or you don\'t want to register for an account to comment on [_1], then no further action is required.' => 'Si no realizó esta petición, o no quiere registrar una cuenta para comentar en [_1], no se necesitan más acciones.', # Translate - New (27)
    'Thank you very much for your understanding.' => 'Gracias por su comprensión.', # Translate - New (7)
    'Sincerely,' => 'Cordialmente,', # Translate - New (1)

    ## ./tmpl/email/commenter_notify.tmpl
    'This email is to notify you that a new user has successfully registered on the blog \'[_1].\' Listed below you will find some useful information about this new user.' => 'Este correo es para avisarle de que un nuevo usuario se ha registrado en el blog \'[_1].\' Encontrará abajo información últil sobre este nuevo usuario.', # Translate - New (29)
    'Username:' => 'Usuario:',
    'Full Name:' => 'Nombre completo:', # Translate - New (2)
    'Email:' => 'Correo:', # Translate - New (1)
    'To view or edit this user, please click on or cut and paste the following URL into a web browser:' => 'Para ver o editar este usuario, por favor, haga clic en (o copie y pegue) la siguiente URL en un navegador:', # Translate - New (20)

    ## ./tmpl/email/footer-email.tmpl
    'Powered by Movable Type' => 'Powered by Movable Type', # Translate - Previous (4)
    'Version [_1]' => 'Versión [_1]',
    'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype/', # Translate - Previous (5)

    ## ./tmpl/email/new-comment.tmpl
    'An unapproved comment has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => 'Se recibió un comentario en su blog [_1], en la entrada nº[_2] ([_3]). Debe aprobar este comentario para que aparezca en su sitio.',
    'Approve this comment:' => 'Aprobar este comentario:',
    'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Se publicó un nuevo comentario en su weblog [_1], en la entrada nº [_2] ([_3]).',
    'View this comment' => 'Ver este comentario', # Translate - New (3)
    'Report this comment as spam' => 'Marcar este comentario como spam', # Translate - New (5)
    'Edit this comment' => 'Editar este comentario',
    'IP Address' => 'Dirección IP',
    'Email Address' => 'Dirección de correo electrónico',
    'Comments:' => 'Comentarios:',

    ## ./tmpl/email/new-ping.tmpl
    'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Se recibió un TrackBack [_1], en la entrada nº[_2] ([_3]). Debe aprobarlo para que aparezca en su sitio.',
    'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Se recibió un TrackBack en su blog [_1], en la categoría #[_2], ([_3]). Debe aprobarlo para que aparezca en su sitio.',
    'Approve this TrackBack' => 'Aprobar este TrackBack', # Translate - New (3)
    'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Se publicó un nuevo TrackBack en su blog [_1], en la entrada nº[_2] ([_3]).',
    'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'Se publicó un nuevo TrackBack en su blog [_1], en la categoría nº[_2] ([_3]).',
    'View this TrackBack' => 'Ver este TrackBack', # Translate - New (3)
    'Report this TrackBack as spam' => 'Marcar este TrackBack como spam', # Translate - New (5)
    'Edit this TrackBack' => 'Editar este TrackBack',

    ## ./tmpl/email/notify-entry.tmpl
    'A new post entitled \'[_1]\' has been published to [_2].' => 'Se ha publicado en [_2]_ una nueva entrada titulada \'[_1]\'.', # Translate - New (10)
    'View post' => 'Ver entrada', # Translate - New (2)
    'Post Title' => 'Título de la entrada', # Translate - New (2)
    'Publish Date' => 'Fecha de publicación', # Translate - New (2)
    'Message from Sender' => 'Mensaje del remitente', # Translate - New (3)
    'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'Ha recibido este correo porque seleccionó recibir avisos sobre la publicación de nuevos contenidos en [_1] o porque el autor de la entrada pensó que podría serle de interés. Si no quiere recibir más avisos, por favor, contacte con esta persona:', # Translate - New (43)

    ## ./tmpl/email/recover-password.tmpl

    ## ./tmpl/email/verify-subscribe.tmpl
    'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Gracias por suscribirse a las notificaciones sobre actualizaciones en [_1]. Siga el enlace de abajo para confirmar su suscripción:',
    'If the link is not clickable, just copy and paste it into your browser.' => 'Si no puede hacer clic en el enlace, copie y péguelo en su navegador.',

    ## ./tmpl/feeds/error.tmpl
    'Movable Type Activity Log' => 'Registro de actividad de Movable Type',
    'Movable Type System Activity' => 'Actividad del sistema de Movable Type',

    ## ./tmpl/feeds/feed_chrome.tmpl

    ## ./tmpl/feeds/feed_comment.tmpl
    'system' => 'sistema',
    'Published' => 'Publicado',
    'Unpublished' => 'No publicado',
    'Blog' => 'Blog', # Translate - Previous (1)
    'Entry' => 'Entrada',
    'Untitled' => 'Sin título',
    'Commenter' => 'Comentarista',
    'Actions' => 'Acciones',
    'Edit' => 'Editar',
    'Unpublish' => 'Despublicar',
    'Publish' => 'Publicar',
    'Junk' => 'Basura',
    'More like this' => 'Más como éstos',
    'From this blog' => 'De este blog',
    'On this entry' => 'En esta entrada',
    'By commenter identity' => 'Por identidad del comentarista',
    'By commenter name' => 'Por nombre del comentarista',
    'By commenter email' => 'Por correo electrónico del comentarista',
    'By commenter URL' => 'Por URL del comentarista',
    'On this day' => 'En este día',

    ## ./tmpl/feeds/feed_entry.tmpl
    'Author' => 'Autor',
    'From this author' => 'De este autor',

    ## ./tmpl/feeds/feed_ping.tmpl
    'Source blog' => 'Blog origen',
    'By source blog' => 'Por blog origen',
    'By source title' => 'Por título origen',
    'By source URL' => 'Por URL origen',

    ## ./tmpl/feeds/feed_system.tmpl

    ## ./tmpl/feeds/login.tmpl
    'This link is invalid. Please resubscribe to your activity feed.' => 'Este enlace no es válido. Por favor, resuscríbase a la fuente de sindicación de actividades.',

    ## ./tmpl/wizard/blog.tmpl

    ## ./tmpl/wizard/cfg_dir.tmpl

    ## ./tmpl/wizard/complete.tmpl

    ## ./tmpl/wizard/configure.tmpl

    ## ./tmpl/wizard/mt-config.tmpl

    ## ./tmpl/wizard/optional.tmpl

    ## ./tmpl/wizard/packages.tmpl

    ## ./tmpl/wizard/start.tmpl

    ## ./tmpl/wizard/include/copyright.tmpl

    ## ./tmpl/wizard/include/footer.tmpl

    ## ./tmpl/wizard/include/header.tmpl

    ## Other phrases, with English translations.
    'Bad ObjectDriver config' => 'Configuración de ObjectDriver incorrecta',
    'Two plugins are in conflict' => 'Dos extensiones están en conflicto',
    'RSS 1.0 Index' => 'Índice RSS 1.0',
    'Comment \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4]) from entry \'[_5]\' (entry #[_6])' => 'Comentario \'[_1]\' (#[_2]) borrado por \'[_3]\' (usuario #[_4]) de la entrada \'[_5]\' (entrada #[_6])',
    'Create Entries' => 'Crear entradas',
    'Remove Tags...' => 'Borrar entradas...',
    '_BLOG_CONFIG_MODE_BASIC' => 'Modo básico',
    'No weblog was selected to clone.' => 'No se ha seleccionado un weblog para clonar.',
    'Username or password recovery phrase is incorrect.' => 'El usuario o la frase de recuperación de la contraseña es incorrecto.',
    'Comment Pending Message' => 'Mensaje de comentario pendiente',
    '_NO_SUPERUSER_DISABLE' => 'No puede deshabilitarse porque es un administrador del sistema de Movable Type',
    'YEARLY_ADV' => 'YEARLY_ADV', # Translate - New (2)
    'Invalid attempt to recover password (used recovery phrase \'[_1]\')' => 'Intento no válido de recuperación de contraseña (frase de recuperación utilizada \'[_1]\')',
    'Updating blog old archive link status...' => 'Actualizando el estado de los enlaces de archivado antiguos...',
    'Movable Type Enterprise has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.' => 'Movable Type Enterprise acaba de intentar deshabilitar su cuenta durante una sincronización con el directorio externo. Algunas de las opciones de configuración de la administración externa de usuarios deben ser incorrectas. Por favor, corrija la configuración antes de continuar.',
    'Showing' => 'Mostrando',
    '_USAGE_COMMENT' => 'Edite el comentario seleccionado. Presione GUARDAR cuando haya terminado. Para que estos cambios entren en vigor, deberá ejecutar el proceso de reconstrucción.',
    'No password recovery phrase set in user profile. Please see your system administrator for password recovery.' => 'No hay establecida ninguna frase de recuperación de contraseña en el perfil del usuario. Por favor, consulte con el administrador del sistema para la recuperación de la contraseña.',
    'Database Path' => 'Ruta de la base de datos',
    'Deleting a user is an irrevocable action which creates orphans of the author\'s entries.  If you wish to retire a user or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete this author?' => 'El borrado de un autor es una acción irreversible que deja huérfanas a las entradas del autor. Si desea retirar un usuario o impedir su acceso al sistema, la forma recomendada es eliminar todos los permisos del autor.  ¿Está seguro de que desea borrarlo?',
    'An error occurred processing [_1]. Check <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">here</a> for more detail and please try again.' => 'Ocurrió un error procesando [_1]. Consulte <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">aquí</a> para más detalles e información e inténtelo de nuevo.',
    'Created template \'[_1]\'.' => 'Creada plantilla \'[_1]\'.',
    'View image' => 'Ver imagen',
    'Date-Based Archive' => 'Archivo por fechas',
    'Enable External User Management' => 'Habilitar Administración externa de usuarios',
    'Assigning visible status for comments...' => 'Asignando estado de visibilidad a los comentarios...',
    'Step 4 of 4' => 'Paso 4 de 4',
    'Designer' => 'Diseñador',
    'Create a feed widget' => 'Crear un widget de fuentes de sindicación',
    'Enter the ID of the weblog you wish to use as the source for new personal weblogs. The new weblog will be identical to the source except for the name, publishing paths and permissions.' => 'Introduzca el ID del weblog que desee utilizar como la fuente de los nuevos weblogs personales. El nuevo weblog será idéntico al original excepto por el nombre, las rutas de publicación y los permisos.',
    'Bad CGIPath config' => 'Configuración CGIPath incorrecta',
    'Weblog Administrator' => 'Administrador del weblog',
    'If present, 3rd argument to add_callback must be an object of type MT::Plugin' => 'Si está presente, el tercer argumento de add_callback debe ser un objeto de tipo MT::Plugin',
    '_USAGE_GROUPS_USER' => 'Debajo se encuentra una lista de los grupos de los que es miembro el usuario. Puede eliminar el usuario del grupo haciendo clic en la casilla junto al grupo y haciendo clic en BORRAR.',
    '_WARNING_PASSWORD_RESET_MULTI' => 'Va a reiniciar la contraseña de los usuarios seleccionados. Se generarán nuevas contraseñas aleatorias que se enviarán directamente a sus direcciones de correo electrónico.  ¿Desea continuar?',
    'You must define a Comment Listing template in order to display dynamic comments.' => 'Debe definir una plantilla de listado de comentarios para mostrar comentarios dinámicos.',
    'Assigning blog administration permissions...' => 'Asignando permisos de administración de blogs...',
    'Invalid LDAPAuthURL scheme: [_1].' => 'Formato de LDAPAuthURL no válido: [_1].',
    'Can edit all entries/categories/tags on a weblog and rebuild.' => 'Puede editar todas las entradas/categorías/etiquetas de un weblog y reconstruirlo.',
    'Category Archive' => 'Archivo de categorías',
    'Monitor' => 'Monitor', # Translate - Previous (1)
    'Updating user permissions for editing tags...' => 'Actualizando los permisos de los usuarios para la edición de etiquetas...',
    '_USAGE_EXPORT_1' => 'La exportación de sus entradas fuera de Movable Type le permitirá tener <b>copias de seguridad personales</b> de sus entradas, para guardarlas en lugar seguro. El formato de los datos exportados permite volverlos a importar en el sistema aprovechando el mecanismo de importación (ver más arriba); de este modo, además de exportar sus entradas como copias de seguridad, también podrá utilizarlo para <b>transferir contenidos entre weblogs</b>.',
    'Setting default blog file extension...' => 'Estableciendo extensión predefinida de fichero de blog...',
    'Migrating permissions to roles...' => 'Migrando permisos a roles...',
    '<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> es la categoría anterior.',
    'Name:' => 'Nombre:',
    'Atom Index' => 'Índice Atom',
    'Weblog \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' creado por \'[_2]\' (usuario #[_3])',
    'Invalid priority level [_1] at add_callback' => 'Nivel de prioridad [_1] no válido en add_callback',
    'Add Tags...' => 'Añadir etiquetas...',
    '_THROTTLED_COMMENT_EMAIL' => 'Se bloqueó automáticamente a una persona que visitó su weblog [_1] debido a que insertó más comentarios de los permitidos en menos de [_2] segundos. Esto se hizo para impedir que nadie o nada desborde malintencionadamente  su weblog con comentarios. La dirección bloqueada es la siguiente:

    [_3]

Si esta operación no es correcta, puede desbloquear la dirección IP y permitir al visitante reanudar sus comentarios. Para ello, inicie una sesión en su instalación de Movable Type, vaya a Configuración del weblog - Bloqueo de direcciones IP y elimine la dirección IP [_4] de la lista de direcciones bloqueadas.',
    'Permission denied for non-superuser' => 'Permiso denegado a los no superusuarios',
    'Ping \'[_1]\' (ping #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Ping \'[_1]\' (ping #[_2]) borrado por \'[_3]\' (usuario #[_4])',
    'Category \'[_1]\' (category #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Categoría \'[_1]\' (categoría #[_2]) borrada por \'[_3]\' (user #[_4])',
    'MONTHLY_ADV' => 'Mensualmente',
    '_USER_ENABLED' => 'Usuario habilitado',
    'Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]' => 'El envío de mensajes a través de SMTP necesita que su servidor tenga Mail::Sendmail instalado: [_1]',
    'Manage Tags' => 'Administrar etiquetas',
    'Taxonomist' => 'Taxonomista',
    '_USAGE_BOOKMARKLET_3' => 'Para instalar el marcador de QuickPost para Movable Type, arrastre el enlace siguiente al menú o barra de herramientas Favoritos de su navegador:',
    'Are you sure you want to delete the selected group(s)?' => '¿Está seguro de que desea borrar los usuarios seleccionados?',
    'Assigning user status...' => 'Asignando estado de usuarios...',
    'User \'[_1]\' (#[_2]) untrusted commenter \'[_3]\' (#[_4]).' => 'Usuario \'[_1]\' (#[_2]) desconfió del usuario \'[_3]\' (#[_4]).',
    'Create New User Association' => 'Crear una nueva asociación de usuarios',
    'File with name \'[_1]\' already exists. (Install File::Temp if you\'d like to be able to overwrite existing uploaded files.)' => 'Ya existe un fichero con el nombre \'[_1]\'. (Instale File::Temp si desea sobreescribir ficheros transferidos existentes).',
    'Category \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Categoría \'[_1]\' creada por \'[_2]\' (usuario #[_3])',
    'DBI and DBD::SQLite2 are required if you want to use the SQLite2 database backend.' => 'DBI y DBD::SQLite2 son necesarios si desea usar  el gestor de base de datos SQLite2.',
    'Are you sure you want to delete the [_1] selected [_2]?' => '¿Está seguro de que desea borrar el/los [_1] seleccionado/s [_2]?',
    '_USAGE_GROUPS_LDAP' => 'Este es el mensaje para los grupos bajo LDAP',
    'New TrackBack for entry #[_1] \'[_2]\'.' => 'Nuevo TrackBack en la entrada #[_1] \'[_2]\'.',
    'An error occured during synchronization: [_1]' => 'Ocurrió un error durante la sincronización: [_1]',
    '4th argument to add_callback must be a CODE reference.' => 'El cuarto argumento de add_callback debe ser una referencia de código.',
    'Or return to the <a href="[_1]">Main Menu</a> or <a href="[_2]">System Overview</a>.' => 'O regrese al <a href="[_1]">Menú principal</a> o al <a href="[_2]">Resumen del sistema</a>.',
    'Can create entries and edit their own.' => 'Puede crear entradas y editarlas.',
    'Monthly' => 'Mensualmente',
    'Editor' => 'Editor', # Translate - Previous (1)
    'Refreshing template \'[_1]\'.' => 'Refrescando la plantilla \'[_1]\'.',
    'Ban Commenter(s)' => 'Bloquear comentarista/s',
    'Created <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Creado <MTIfNonEmpty tag="EntryAuthorDisplayName">por [_1] </MTIfNonEmpty>el [_2]', # Translate - New (9)
    'Installation instructions.' => 'Instrucciones de instalación.',
    'Secretary' => 'Secretario',
    '_USAGE_ARCHIVING_3' => 'Seleccione el tipo de archivado al que desea crear una nueva plantilla de archivado. A continuación, seleccione la plantilla a asociar a ese tipo de archivado.',
    'Hello, world' => 'Hola, mundo',
    'You need to create some users.' => 'Debe crear nuevos usuarios.',
    'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Ignorando plantilla \'[_1]\' ya que parecer ser una plantilla personalizada.',
    'The above settings have been written to the file <tt>[_1]</tt>. If any of these settings are incorrect, you may click the \'Back\' button below to reconfigure them.' => 'La configuración de arriba se ha guardado en el fichero <tt>[_1]</tt>. Si cualquiera de estas opciones es incorrecta, puede hacer clic en el botón \'Regresar\' para reconfigurarla.',
    '_USER_DISABLE' => 'Deshabilitar',
    'You used an \'[_1]\' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an \'MTComments\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un comentario; ¿quizás la puso por error fuera de un contenedor \'MTComments\'?',
    '_ERROR_CGI_PATH' => 'La opción de configuración CGIPath no es válida o no se encuentra en el fichero de configuración de Movable Type. Por favor, consulte la sección <a href="#">Instalación y configuración</a> del manual de Movable Type manual para más información.',
    'Insufficient permissions to modify templates for weblog \'[_1]\'' => 'Permisos insuficientes para modificar las plantillas del weblog \'[_1]\'',
    'Assigning template build dynamic settings...' => 'Asignando opciones de construcción de plantillas dinámicas...',
    '_USAGE_CATEGORIES' => 'Utilice categorías para agrupar sus entradas y así facilitar las referencias, el archivado y la navegación por su weblog. En el momento de crear o editar entradas, puede asignarles una categoría. Para editar una categoría anterior, haga clic en el título de la categoría. Para crear una subcategoría, haga clic en el botón "Crear" correspondiente. Para trasladar una subcategoría, haga clic en el botón "Trasladar" correspondiente.',
    '_USAGE_AUTHORS_2' => 'Puede registrar, editar o borrar usarios usando un fichero con formato CSV.',
    'User \'[_1]\' (#[_2]) trusted commenter \'[_3]\' (#[_4]).' => 'Usuario \'[_1]\' (#[_2]) confió en el comentarista \'[_3]\' (#[_4]).',
    'Tags \'[_1]\' (tags #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Etiquetas \'[_1]\' (etiquetas #[_2]) borradas por \'[_3]\' (usuario #[_4])',
    'URL:' => 'URL:', # Translate - Previous (1)
    'Template \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Plantilla \'[_1]\' creada por \'[_2]\' (usuario #[_3])',
    'Weekly' => 'Semanalmente',
    'New TrackBack for category #[_1] \'[_2]\'.' => 'Nuevo TrackBack en la categoría #[_1] \'[_2]\'.',
    'No pages were found containing "[_1]".' => 'No se encontraron páginas conteniendo "[_1]".',
    '. Now you can comment.' => '. Ahora puede comentar.',
    'Unpublish TrackBack(s)' => 'Despublicar TrackBack/s',
    'You need to provide a password if you are going to\ncreate new users for each user listed in your blog.\n' => 'Debe proveer una contraseña si va a\ncrear nuevos usarios para cada uno de los listados en el blog.\n',
    'Weblog \'[_1]\' deleted by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' borrado por \'[_2]\' (usuario #[_3])',
    'The physical file path for your BerkeleyDB or SQLite database. ' => 'La ruta física del fichero de la base de datos BerkeleyDB o SQLite. ',
    'Many more can be found on the <a href="[_1]">main index page</a> or by looking through <a href="[_2]">the archives</a>.' => 'Puede encontrar más en la <a href="[_1]">página principal</a> o mirando a través de los <a href="[_2]">archivos</a>.',
    '_USAGE_PREFS' => 'Esta pantalla permite establecer un gran número de ajustes opcionales referentes a weblogs, archivos, comentarios, como también su configuración de publicidad y notificaciones. Al crear uno nuevo weblog, todos estos ajustes están predeterminados con valores razonables.',
    'This page contains an archive of all entries published to [_1] in the <strong>[_2]</strong> category.  They are listed from oldest to newest.' => 'Esta página contiene un archivo de todas las entradas publicadas en [_1] en la categoría <strong>[_2]</strong>. Están ordenados de antiguos a nuevos.', # Translate - New (24)
    'WEEKLY_ADV' => 'Semanalmente',
    'Other...' => 'Otro...',
    'If you have a TypeKey identity, you can ' => 'Si tiene una identidad en TypeKey, puede ',
    'Can create entries, edit their own and upload files.' => 'Puede crear entradas, editarlas y transferir ficheros.',
    'Please enter the parameters necessary for connecting to your database.If your database type is not listed in the dropdown below, you may be missing the Perl module necessary to connect to your database.  If this is the case, please check your installation and click <a href="?__mode=configure">here</a> to re-test your installation.' => 'Por favor, introduzca los parámetros necesarios para conectarse a la base de datos. Si el tipo de su base de datos no está listada en el menú desplegable de abajo, es posible que no tenga instalados los módulos de Perl necesarios para la conexión a su base de datos. Si este es el caso, por favor, haga clic <a href="?__mode=configure">aquí</a> para comprobar de nuevo su instalación.',
    '_USAGE_ARCHIVING_2' => 'Si asocia múltiples plantillas a un determinado tipo de archivado (aunque asocie solamente una), puede personalizar la ruta de salida utilizando las plantillas de archivos.',
    'User \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Usuario \'[_1]\' creado por \'[_2]\' (usuario #[_3])',
    'Refresh Template(s)' => 'Refrescar plantilla/s',
    'Password was reset for user \'[_1]\' (ID:[_2]) and sent to address: [_3]' => 'La contraseña del usuario \'[_1]\' (ID:[_2]) fue reiniciada y enviada a la dirección: [_3]',
    'Assigning basename for categories...' => 'Asignando nombre base a las categorías...',
    '_USAGE_NOTIFICATIONS' => 'A continuación se muestra la lista de usuarios que desean recibir una notificación cuando usted realice alguna nueva contribución en su sitio. Para crear un nuevo usuario, introduzca su dirección de correo electrónico en el formulario siguiente. El campo URL es opcional. Para eliminar un usuario, active la casilla Eliminar en la tabla siguiente y presione el botón ELIMINAR.',
    'Future' => 'Futuro',
    'Editor (can upload)' => 'Editor (puede transferir archivos)',
    '_ERROR_DATABASE_CONNECTION' => 'Las opciones de configuración de su base de datos o son incorrectas o no están presentes en el fichero de configuración de Movable Type. Por favor, consulte la sección <a href="#">Instalación y configuración</a> del manual de Movable Type para más información',
    '_USAGE_BANLIST' => 'Debajo aparece la lista de direcciones IP a las que ha prohibido insertar comentarios o enviar pings de TrackBack a su sitio. Para crear una nueva dirección IP, introduzca la dirección en el formulario siguiente. Para borrar una dirección IP bloqueada, active la casilla Eliminar en la tabla siguiente y presione el botón ELIMINAR.',
    'RSS 2.0 Index' => 'Índice RSS 2.0',
    'Select a Design using StyleCatcher' => 'Seleccione un estilo usando StyleCatcher',
    'New comment for entry #[_1] \'[_2]\'.' => 'Nuevo comentario en la entrada #[_1] \'[_2]\'.',
    '_USER_DISABLED' => 'Usuario deshabilitado',
    '<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> es el archivo anterior.',
    '_USAGE_NEW_AUTHOR' => 'Desde esta pantalla puede crear un nuevo usario en el sistema y darle acceso a weblogs individualmente.',
    'Manage my Widgets' => 'Administrar widgets',
    'Weblog Associations' => 'Asociaciones del weblog',
    'Updating blog comment email requirements...' => 'Actualizando los requerimientos del correo de los comentarios...',
    'Publish Entries' => 'Publicar entradas',
    'The following groups were deleted' => 'Los siguientes grupos fueron borrados',
    'Finished! You can <a href=\"javascript:void(0);\" onclick="closeDialog(\'[_1]\');\">return to the weblogs listing</a> or <a href=\"javascript:void(0);\" onclick="closeDialog(\'[_2]\');\">configure the Site root and URL of the new weblog</a>.' => '¡Finalizó! Puede <a href=\"javascript:void(0);\" onclick="closeDialog(\'[_1]\');\">regresar a la lista de weblogs</a> o <a href=\"javascript:void(0);\" onclick="closeDialog(\'[_2]\');\">configurar la raíz del sitio y la URL del nuevo weblog</a>.',
    'You cannot disable yourself' => 'No puede auto-deshabilitarse',
    '_USER_STATUS_CAPTION' => 'estado',
    'You are not allowed to edit the permissions of this user.' => 'No puede editar los permisos de este usuario.',
    '<em><strong>Please Note:</strong> The Movable Type export format is not comprehensive and is not suitable for creating full-fidelity backups. Please see the Movable Type manual for full details.</em>' => '<em><strong>Por favor, tenga en cuenta:</strong> El formato de exportación de Movable Type no es completo, y no se recomienda usarlo para crear copias de seguridad de total fidelidad. Por favor, consulte el manual de Movable Type para más detalles sobre este asunto.</em>',
    '<$MTCategoryTrackbackLink$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<$MTCategoryTrackbackLink$> debe utilizarse en el contexto de una categoría, o con el atributo \'category\' en la etiqueta.',
    '_USAGE_PLUGINS' => 'Lista de todas las extensiones actualmente registradas en Movable Type.',
    'Tagger' => 'Etiquetador',
    'Publisher' => 'Editor',
    'Manager' => 'Administrador',
    '_GENL_USAGE_PROFILE' => 'Edite el perfil del usuario aquí. Si cambia el nombre o la contraseña, se actualizarán automáticamente las credenciales del usuario. En otras palabras, no será necesario que reinicie la sesión.',
    '(None)' => '(Ninguno)',
    'Frequency of synchronization in minutes. (Default is 60 minutes)' => 'Frecuencia de sincronización en minutos. (Valor predefinido 60 minutos)',
    '_USAGE_PERMISSIONS_2' => 'Para editar los permisos de otro usuario, selecciónelo en el menú desplegable y presione EDITAR.',
    'Insufficient permissions for modifying templates for this weblog.' => 'Permisos insuficientes para modificar las plantillas de este weblog.',
    'Bad ObjectDriver config: [_1] ' => 'Configuración de ObjectDriver incorrecta: [_1] ',
    'No email specified in user profile.  Please see your system administrator for password recovery.' => 'Sin correo electrónico en el perfil de usuario. Por favor, consulte que el administrador del sistema para recuperar la contraseña.',
    'Untrust Commenter(s)' => 'Desconfiar de comentarista/s',
    'Hello, [_1]' => 'Hola, [_1]',
    'Can edit, manage and rebuild weblog templates.' => 'Puede editar, administrar y reconstruir las plantillas del weblog.',
    'To download more plugins, check out the <a href="http://www.sixapart.com/pronet/plugins/">Six Apart Plugin Directory</a>.' => 'Para descargar más extensiones consulte el <a href="http://www.sixapart.com/pronet/plugins/">Directorio de \'plugins\' de Six Apart</a>.',
    'Assigning custom dynamic template settings...' => 'Asignando opciones de plantillas dinámicas personalizadas...',
    'Updating comment status flags...' => 'Actualizando estados de comentarios...',
    'Updating user web services passwords...' => 'Actualizando contraseñas de servicios web...',
    'Stylesheet' => 'Hoja de estilo',
    'You used an \'[_1]\' tag outside of the context of a ping; perhaps you mistakenly placed it outside of an \'MTPings\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un ping; ¿quizás la situó por error fuera de un contenedor \'MTPings\'?',
    '_THROTTLED_COMMENT' => 'En un esfuerzo por impedir la inserción de comentarios maliciosos por parte usuarios malévolos, se ha habilitado una función que obliga al comentarista del weblog esperar un tiempo determinado antes de poder realizar un nuevo comentario. Por favor, vuelva a insertar su comentario dentro de unos momentos. Gracias por su comprensión.',
    'Are you sure you want to delete the selected user(s)?' => '¿Está seguro de que desea borrar los usuarios seleccionados?',
    '_USAGE_SEARCH' => 'Puede utilizar la herramienta de búsqueda y reemplazo Buscar &amp; Reemplazar para realizar búsquedas en todas sus entradas, o bien para reemplazar cada ocurrencia de una palabra/frase/carácter por otro. IMPORTANTE: Ponga mucha atención al ejecutar un reemplazo, porque es una operación <b>irreversible</b>. Si va a efectuar un reemplazo masivo (es decir, en muchas entradas), es recomendable utilizar primero la función de exportación para hacer una copia de seguridad de sus entradas.',
    'Your profile has been updated.' => 'El perfil ha sido actualizado.',
    'Refreshing (with <a href=\"?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]\">backup</a>) template \'[_3]\'.' => 'Refrescando (con <a href=\"?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]\">copia de seguridad</a>) la plantilla \'[_3]\'.',
    'Can\'t enable/disable that way' => 'No se puede habilitar/deshabilitar de esa forma',
    '_external_link_target' => '_top',
    '_AUTO' => '1',
    'Password recovery for user \'[_1]\' failed due to lack of recovery phrase specified in profile.' => 'La recuperación de la contraseña \'[_1]\' falló debido a la falta de la frase de recuperación en el perfil.',
    'Setting new entry defaults for weblogs...' => 'Estableciendo valores predefinidos de las entradas en los weblogs...',
    'Writer (can upload)' => 'Escritor (puede transferir archivos)',
    'Updating entry week numbers...' => 'Actualizando números de semana de entradas...',
    'The previous entry in this blog was <a href="[_1]">[_2]</a>.' => 'La entrada anterior en este blog era  <a href="[_1]">[_2]</a>.', # Translate - New (12)
    '_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.org/sitees/"><$MTProductName$></a>',
    'Assigning comment/moderation settings...' => 'Asignando opciones de comentarios/moderación...',
    'You can not add users to a disabled group.' => 'No puede añadir usuarios a un grupo deshabilitado.',
    'Communications Manager' => 'Administrador de comunicaciones',
    'Clone Weblog' => 'Clonar weblog',
    '_USAGE_ARCHIVING_1' => 'Seleccione la periodicidad y los tipos de archivado que desee realizar en su sitio. Por cada tipo de archivado que elija, tendrá la opción de asignar múltiples plantillas de archivado, que se aplicarán a ese tipo en particular. Por ejemplo, puede crear dos vistas diferentes de sus archivos mensuales: una consistente en una página que contenga cada una de las entradas de un determinado mes y la otra consistente en una vista de calendario de ese mes.',
    'Application log for blog \'[_1]\' reset by \'[_2]\' (user #[_3])' => 'Registro del blog \'[_1]\' reiniciado por \'[_2]\' (usuario #[_3])',
    'Finished! You can <a href=\'[_1]\'>return to the weblogs listing</a> or <a href=\'[_2]\'>view the new weblog</a>.' => '¡Finalizado! Puede <a href=\'[_1]\'>regresar al listado de weblogs</a> o <a href=\'[_2]\'>ver el nuevo weblog</a>.',
    'Permission denied' => 'Permiso denegado',
    '_USAGE_AUTHORS_1' => 'Esta es una lista de todos los usuarios del sistema de Movable Type. Puede edutar los permisos de un usario haciendo clic en el nombre. Puede borrar los usarios de forma permanente activando la casilla junto al nombre y presionando BORRAR. NOTA: si solo desea borrar un usario de un blog en particular, edite los permisos del usario; borrar un usario es una acción irreversible que lo borra del sistema por completo. Puede crear, editar y borrar usarios usando un fichero con formato CSV.',
    'Error creating temporary file; please check your TempDir setting in mt.cfg (currently \'[_1]\') this location should be writable.' => 'Error creando fichero temporal; por favor, compruebe que el valor de TempDir en mt.cfg (actualmente \'[_1]\'), se debe tener permisos de escritura en esta ruta.',
    'View This Weblog\'s Activity Log' => 'Ver registro de actividad de este weblog',
    '_USAGE_IMPORT' => 'Utilice el mecanismo de importación para importar entradas de otro sistema de weblogs, como Blogger o Greymatter. Este manual proporciona instrucciones exhaustivas para la importación de entradas antiguas mediante este mecanismo; el formulario siguiente permite importar un lote de entradas después de que las haya exportado del otro CMS y haya colocado los ficheros exportados en el lugar correcto para que Movable Type los pueda encontrar. Antes de usar este formulario, consulte el manual para asegurarse de haber comprendido todas las opciones.',
    'IP Address:' => 'Dirección IP:',
    'Main Index' => 'Índice principal',
    'No new status given' => 'No se le ha dado un nuevo estado',
    'Invalid login attempt from user \'[_1]\' (ID: [_2])' => 'Intento de acceso no válido del usuario \'[_1]\' (ID: [_2])',
    '<p>You must define a global theme repository where themes can be stored locally.  If a particular blog has not been configured for it\'s own theme paths, it will use these settings directly. If a blog has it\'s own theme paths, then the theme will be copied to that location when applied to that weblog. The paths defined here must physically exist and be writable by the webserver.</p>' => '<p>Debe definir un repositorio global de estilos donde se puedan guardar localmente. Si un blog no ha sido configurado para guardar los temas en su propia ruta, usará esta configuración. Si un blog tiene su propia ruta para los temas, entonces al aplicar el tema al weblog, ésta se copiará a dicha ruta. Las rutas definidas aquí deben existir físicamente y el servidor web debe poder escribir en ellas.</p>',
    'You did not select any [_1] to delete.' => 'No seleccionó ningún [_1] para borrar.',
    '_USAGE_EXPORT_3' => 'Haciendo clic en el enlace siguiente exportará todas las entradas actuales del weblog al servidor Tangent. Generalmente, este proceso se realiza una sola vez y de una pasada, después de instalar la extensión de Tangent para Movable Type, pero teóricamente podría ejecutarse siempre que sea necesario.',
    'Application log reset by \'[_1]\' (user #[_2])' => 'Registro de la aplicación reiniciado por \'[_1]\' (usuario #[_2])',
    'Assigning spam status for TrackBacks...' => 'Marcando spam en los TrackBacks...', # Translate - New (5)
    'A default location of \'./db\' will store the database file(s) underneath your Movable Type directory.' => 'Los ficheros de la base de datos se guardarán en la ruta predefinida \'./db\' bajo el directorio de Movable Type.',
    'Delete selected users (x)' => 'Borrar usuarios seleccionados (x)',
    'User \'[_1]\' (user #[_2]) logged out' => 'Usuario \'[_1]\' (usuario #[_2]) cerró la sesión',
    'Edit Role' => 'Editar rol',
    '_BLOG_CONFIG_MODE_DETAIL' => 'Modo detallado',
    'Some ([_1]) of the selected user(s) could not be updated.' => 'Algunos ([_1]) de los usuarios seleccionados no pueden actualizarse.',
    'Updating category placements...' => 'Actualizando situación de categorías...',
    '_USAGE_BOOKMARKLET_4' => 'Después de instalar QuickPost, puede crear una entrada desde cualquier punto de Internet. Cuando esté visualizando una página y desee escribir sobre la misma, haga clic en "QuickPost" para abrir una ventana emergente especial de edición de Movable Type. Desde esa ventana puede seleccionar el weblog en el que desea publicar, luego escribir su entrada y guardarla.',
    'Notification \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => 'Notificación \'[_1]\' (#[_2]) borrada por \'[_3]\' (usuario #[_4])',
    'DAILY_ADV' => 'Diariamente',
    'Communicator' => 'Comunicador',
    '_USAGE_PERMISSIONS_3' => 'Existen dos maneras de editar usarios y otorgarles o denegarles privilegios de acceso. Para acceder rápidamente, seleccione un usuario en el menú siguiente y seleccione Editar. Alternativamente, puede desplazarse por la lista completa de usarios y desde allí seleccionar el nombre que desea editar o eliminar.',
    'Found' => 'Encontrado',
    '_NOTIFY_REQUIRE_CONFIRMATION' => 'Se envió un correo a [_1]. Para completar su suscripción, 
por favor siga el enlace que aparece en este mensaje. Esto verificará que
la dirección provista es correcta y le pertenece.',
    'Tags to remove from selected entries' => 'Etiquetas a borrar de las entradas seleccionadas',
    'Manage Notification List' => 'Administrar lista de notificaciones',
    'Individual' => 'Individual', # Translate - Previous (1)
    'Last Entry' => 'Última entrada',
    'An error occurred while testing for the new tag name.' => 'Ocurrió un error mientras se probaba el nuevo nombre de la etiqueta.',
    'Before you can do this, you need to create some groups. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a group.' => 'Antes de hacerlo, debe crear algunos grupos. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Haga clic aquí</a> para crear un grupo.',
    'Your changes to [_1]\'s profile has been updated.' => 'Se han guardado los cambios al perfil de [_1].',
    '_USAGE_FORGOT_PASSWORD_2' => 'Debería poder iniciar una sesión en Movable Type con esta nueva contraseña. Después de iniciar la sesión, cambie su contraseña a otra que pueda memorizar y recordar fácilmente.',
    'Authored On' => 'Creado el',
    '_SEARCH_SIDEBAR' => 'Buscar',
    'Unban Commenter(s)' => 'Desbloquear comentarista/s',
    'Individual Entry Archive' => 'Archivo de entradas individuales',
    'Daily' => 'Diariamente',
    'This page contains all entries published to [_1] in <strong>[_2]</strong>. They are listed from oldest to newest.' => 'Esta página contiene todas las entradas publicadas en [_1] en <strong>[_2]</strong>. Están ordenadas de antiguas a nuevas.', # Translate - New (19)
    'Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or \'all\' (include_blogs only) are acceptable values.' => 'Habilita el uso de la etiqueta MTMultiBlog sin incluir los atributos include_blogs/exclude_blogs. Valores aceptables son BlogIDs separados por comas o \'all\' (solo en include_blogs).',
    'Unpublish Entries' => 'Despublicar entradas',
    'Setting blog basename limits...' => 'Estableciendo los límites del nombre base del blog...',
    'Powered by [_1]' => 'Powered by [_1]', # Translate - Previous (3)
    'Commenter Feed (Disabled)' => 'Fuente de sindicación de comentarios (deshabilitado)',
    'Personal weblog clone source ID' => 'ID del weblog origen de clonaciones',
    '_USAGE_UPLOAD' => 'Puede transferir el fichero anterior a la ruta local del sitio <a href="javascript:alert(\'[_1]\')">(?)</a> o a su ruta local de archivado <a href="javascript:alert(\'[_2]\')">(?)</a>. También puede transferir el fichero a cualquier subdirectorio de esos directorios, especificando la ruta en el cuadro de texto de la derecha (<i>imagenes</i>, por ejemplo). Si el directorio no existe, se creará.',
    '<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> es el siguiente archivo.',
    'Updating commenter records...' => 'Actualizando registros de comentaristas...',
    'Now you can comment.' => 'Ahora puede comentar.',
    'Deleting a user is an irrevocable action which creates orphans of the author\'s entries.  If you wish to retire a user or remove their access to the system, removing all of their permissions is th e recommended course of action.  Are you sure you want to delete the [_1] selected users?' => 'El borrado de un autor es una acción irreversible que deja huérfanas a las entradas del autor. Si desea retirar un usuario o impedir su acceso al sistema, la forma recomendada es eliminar todos los permisos del autor.  ¿Está seguro de que desea borrar los [_1] usuarios seleccionados?',
    '_USAGE_REBUILD' => '<a href="#" onclick="doRebuild()">RECONSTRUIR</a> para ver esos cambios reflejados en su sitio público.',
    'Refreshing (with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>) template \'[_3]\'.' => 'Refrescando (con <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">copia de seguridad</a>) la plantilla \'[_3]\'.',
    'Invalid blog_id' => 'blog_id no válido',
    'CATEGORY_ADV' => 'Por categoría',
    'Blog Administrator' => 'Administrador de blogs',
    'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Archivo de configuración no encontrado. ¿Quizás olvidó renombrar mt-config.cgi-original a mt-config.cgi?',
    'Dynamic Site Bootstrapper' => 'Inicializador del sistema dinámico',
    'You need to create some roles.' => 'Debe crear algunos roles.',
    'Assigning entry basenames for old entries...' => 'Asignando nombre base de entradas en entradas antiguas...',
    'Invalid author' => 'Autor no válido',
    'Error sending mail ([_1]); please fix the problem, then try again to recover your password.' => 'Error enviando correo ([_1]); por favor, solvente el problema e inténte de nuevo la recuperación de la contraseña.',
    'Error saving entry: [_1]' => 'Error guardando entrada: [_1]',
    'index' => 'índice',
    'Invalid login attempt from user [_1]: [_2]' => 'Intento de acceso no válido del usuario [_1]: [_2]',
    'User \'[_1]\' (#[_2]) unbanned commenter \'[_3]\' (#[_4]).' => 'Usuario \'[_1]\' (#[_2]) desbloqueó al comentarista \'[_3]\' (#[_4]).',
    'Assigning visible status for TrackBacks...' => 'Asignando estado de visiblidad para los TrackBacks...',
    '_USAGE_PLACEMENTS' => 'Utilice las herramientas de edición que aparecen a continuación para administrar las categorías secundarias a las que se asigna esta entrada. La lista de la izquierda contiene las categorías a las que esta entrada aún no está asigna como categoría principal o secundaria; la lista de la derecha contiene las categorías secundarias asignadas a esta entrada.',
    '_USAGE_ASSOCIATIONS' => 'Desde esta pantalla puede ver y crear asociaciones.',
    'Adds template tags to allow you to search for content from Google. You will need to configure this plugin using a <a href=\'http://www.google.com/apis/\'>license key.</a>' => 'Añade etiquetas de plantilla para buscar el contenido en Google. Deberá configurar esta extensión utilizando una <a href=\'http://www.google.com/apis/\'>clave de licencia</a>.',
    'Wrong object type' => 'Tipo de objeto erróneo',
    'Search Template' => 'Buscar plantilla',
    'It can be included onto your published blog using <a href="[_1]">WidgetManager</a> or this MTInclude tag' => 'Puede incluirse en su blog usando el <a href="[_1]">Administrador de Widgets</a> o esta etiqueta MTInclude',
    '_USAGE_PASSWORD_RESET' => 'Debajo puede reiniciar la recuperación de la contraseña en nombre de este usuario. Si lo hace, se generará una nueva contraseña aleatoria que se enviará directamente a su dirección de correo electrónico: [_1].',
    'Download file' => 'Descargar fichero',
    'Error connecting to LDAP server [_1]: [_2]' => 'Error conectando al servidor LDAP [_1]: [_2]',
    'Edit Profile' => 'Editar perfil',
    'Error loading default templates.' => 'Error cargando las plantillas predefinidas.',
    'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'No tiene configurada una ruta válida a sendmail en su máquina. ¿Quizás está intentando usar SMTP?',
    'You are currently performing a search. Please wait until your search is completed.' => 'En estos momentos está realizando una búsqueda. Por favor, espere hasta que se complete.',
    'An errror occurred when enabling this user.' => 'Ocurrió un error cuando se habilitaba este usuario.',
    '_USAGE_LIST_POWER' => 'Ésta es la lista de entradas de [_1] en el modo de edición por lotes. En el formulario siguiente puede cambiar cualesquier valor de cualesquier entrada mostrada; una vez introducidas las modificaciones deseadas, presione el botón GUARDAR. Los controles estándar "Listar y editar entradas" (filtros, paginación) funcionan del modo acostumbrado.',
    'Below is a list of the members in the <b>[_1]</b> group. Click on a user\'s username to see the details for that user.' => 'Debajo se encuentra una lista de los miembros del grupo <b>[_1]</b>. Haga clic en el nombre del usuario para ver sus datos.',
    '_ERROR_CONFIG_FILE' => 'El fichero de configuración de Your Movable Type no existe o no se puede leer correctamente. Por favor, consulte la sección <a href="#">Instalación y configuración</a> del manual de Movable Type manual para más información.',
    'This action can only be run for a single weblog at a time.' => 'Esta acción solo puede realizarse en un weblog a la vez.',
    '_WARNING_PASSWORD_RESET_SINGLE' => 'Va a reiniciar la contraseña de "[_1]". Se enviará una nueva contraseña aleatoria que se enviará directamente a su dirección de correo electrónico. ¿Desea continuar?',
    '_USAGE_PING_LIST_BLOG' => 'Aquí hay una lista de TrackBacks de [_1] que puede filtrar, administrar y editar.',
    'You must set your Database Path.' => 'Debe definir la ruta de la base de datos.',
    'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.' => 'StyleCatcher le permite navegar fácilmente por los estilos y aplicarlos a su blog fácilmente. Para más información sobre los estilos de Movable Type, o para encontrar más repositorios de estilos, visite la página de <a href=\'http://www.sixapart.com/movabletype/styles\'>estilos de Movable Type</a>.',
    'The LDAP directory ID for this group.' => 'El ID de este grupo en el directorio LDAP.',
    '_USAGE_GROUPS' => 'Este es el mensaje para grupos',
    '_LOG_TABLE_BY' => '_LOG_TABLE_BY', # Translate - New (4)
    'If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the <code>import</code> folder of your Movable Type directory.' => 'Si el fichero a importar está situado en su ordenador, puede transferirlo aquí. En caso contrario, Movable Type buscará automáticamente en el directorio <code>import</code> de su instalación de Movable Type.',
    'If you want to change the SitePath and SiteURL, <a href=\'[_1]\'>click here</a>.' => 'Si desea cambiar SitePath o  SiteURL, <a href=\'[_1]\'>haga clic aquí</a>.',
    'Password recovery for user \'[_1]\' failed due to lack of email specified in profile.' => 'La recuperación de la contraseña del usuario \'[_1]\' falló debido a la falta de la dirección de correo electrónico en el perfil.',
    'Tags to add to selected entries' => 'Etiquetas a añadir en las entradas seleccionadas',
    'Entry "[_1]" added by user "[_2]"' => 'Entrada "[_1]" añadida por el usuario "[_2]"',
    '_USAGE_VIEW_LOG' => 'Active la casilla <a href="#" onclick="doViewLog()">Registro de actividad</a> correspondiente a ese error.',
    'You are not allowed to edit the profile of this user.' => 'No puede editar el perfil de este usuario.',
    '_BACKUP_DOWNLOAD_MESSAGE' => '_BACKUP_DOWNLOAD_MESSAGE', # Translate - New (4)
    '_USAGE_BOOKMARKLET_1' => 'La configuración de QuickPost para poder realizar contribuciones en Movable Type permite insertar y publicar con un solo clic sin necesidad alguna de utilizar la interfaz principal de Movable Type.',
    'You must define an Individual template in order to display dynamic comments.' => 'Debe definir una plantilla individual para mostrar comentarios dinámicos.',
    'UTC+10' => 'UTC+10', # Translate - Previous (2)
    'INDIVIDUAL_ADV' => 'Individualmente',
    'Can upload files, edit all entries/categories/tags on a weblog, rebuild and send notifications.' => 'Puede transferir ficheros, editar todas las entradas/categorías/etiquetas de un weblog, reconstruir y enviar notificaciones.',
    'Entry \'[_1]\' (entry #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Entrada \'[_1]\' (entrada #[_2]) borrada por \'[_3]\' (usuario #[_4])',
    'all rows' => 'todas las filas',
    '_USAGE_GROUP_PROFILE' => 'Esta ventana le permite editar el perfil del grupo.',
    'User \'[_1]\' (user #[_2]) logged in successfully' => 'Usuario \'[_1]\' (usuario #[_2]) accedió con éxito',
    'Error during upgrade: [_1]' => 'Error durante la actualización: [_1]',
    'Master Archive Index' => 'Archivo índice maestro',
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly context.' => 'Utilizó una etiqueta [_1] fuera de un contexto Diario, Semanal o Mensual.',
    'Step 2 of 4' => 'Paso 2 de 4',
    'Deleting a user is an irrevocable action which creates orphans of the user\'s entries.  If you wish to retire a user or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete this user?' => 'El borrado de un usario es una acción irreversible que crea huérfanos con las entradas del usario. Si desea retirar un usario o eliminar su acceso del sistema, la acción recomendada es borrar todos sus permisos. ¿Está seguro que desea borrar este usario?',
    'Another amount...' => 'Otra cantidad...',
    'Movable type' => 'Movable Type',
    'You can not create associations for disabled groups.' => 'No puede crear asociaciones con grupos deshabilitados.',
    'Grant a new role to [_1]' => 'Asignar un nuevo rol a [_1]',
    '_WARNING_DELETE_USER' => 'El borrado de un usuario es una acción irreversible que crea huérfanos de las entradas del usuario. Si desea retirar a un usuario o bloquear su acceso al sistema, la forma recomendada es deshabilitar su cuenta. ¿Está seguro de que desea borrar el/los usuario/s seleccionado/s?',
    'You used an \'[_1]\' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an \'MTEntries\' container?' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de una entrada; ¿quizás la puso por error fuera de un contenedor \'MTEntries\'?',
    'We were unable to create your configuration file. If you would like to check the directory permissions and retry, click the \'Retry\' button.' => 'No fue posible crear el fichero de configuración. Si lo desea, compruebe los permisos del directorio y luego haga clic al botón \'Reintentar\'.',
    'Create New Group Association' => 'Crear una nueva asociación de grupos',
    'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Aunque Movable Type podría ejecutarse, <strong>esta configuración no está probada ni ni soportada</strong>.  Le recomendamos que actualice Perl a la versión [_1].',
    'Unpublish Comment(s)' => 'Despublicar comentario/s',
    'Processing templates for weblog \'[_1]\'' => 'Procesando plantillas del weblog \'[_1]\'',
    '_USAGE_ENTRY_LIST_OVERVIEW' => 'Lista de entradas de todos los weblogs que puede filtrar, administrar y editar',
    'Synchronization Frequency' => 'Frecuencia de sincronización',
    'Can upload files, edit all entries/categories/tags on a weblog and rebuild.' => 'Puede transferir ficheros, editar todas las entradas/categorías/etiquetas de un weblog y reconstruirlo.',
    'No new user status given' => 'No new user status given', # Translate - Previous (5)
    'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Formato de fecha \'[_1]\' no válido; debe ser \'MM/DD/AAAA HH:MM:SS AM|PM\' (AM|PM es opcional)',
    'Drag and drop the widgets you want into the <strong>Installed</strong> column.' => 'Arrastre y suelte los widgets que desea en la columna <strong>Instalado</strong>.',
    'Manage Categories' => 'Administrar categorías',
    'Assigning user types...' => 'Asignando tipos de usario...',
    'Writer' => 'Escritor',
    'Before you can do this, you need to create some roles. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a role.' => 'Antes de hacerlo, debe crear algunos roles. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Haga clic aquí</a> para crear un rol.',
    'UTC+11' => 'UTC+11', # Translate - Previous (2)
    'Migrating any "tag" categories to new tags...' => 'Migrando cualquier categoría "tag" a nuevas etiquetas...',
    'Before you can do this, you need to create some users. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a user.' => 'Antes de hacerlo, debe crear algunos usuarios. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Haga clic aquí</a> para crear un usuario.',
    'Perl module Image::Size is required to determine width and height of uploaded images.' => 'El módulo de Perl Image::Size es necesario para obtener las dimensiones de las imágenes transferidas.',
    '_BACKUP_TEMPDIR_WARNING' => '_BACKUP_TEMPDIR_WARNING', # Translate - New (4)
    'Edit Permissions' => 'Editar permisos',
    '_USAGE_COMMENTERS_LIST' => 'Ésta es la lista de comentaristas de [_1].',
    'File with name \'[_1]\' already exists; Tried to write to tempfile, but open failed: [_2]' => 'Ya existe un fichero con el nombre \'[_1]\'; se intentó escribir en un fichero temporal, pero hubo un error al abrirlo: [_2]',
    'Updating [_1] records...' => 'Actualizando [_1] registros...',
    'Configure Weblog' => 'Configurar weblog',
    '_INDEX_INTRO' => '<p>Si está instalando Movable Type, quizás desee consultar las <a href="http://www.sixapart.com/movabletype/docs/mtinstall.html">instrucciones de instalación</a> y ver la <a rel="nofollow" href="mt-check.cgi">comprobación del sistema de Movable Type</a> para asegurarse de que su sistema tiene todo lo necesario.</p>',
    '_USAGE_AUTHORS' => 'Ésta es la lista de todos los usuarios registrados en el sistema de Movable Type. Puede editar los permisos de un usario haciendo clic en su nombre; para eliminar permanentemente varios usarios, active las casillas <b>Eliminar</b> correspondientes y presione ELIMINAR. NOTA: Si solamente desea desasignar un usario de un weblog determinado, edite los permisos del usario; el borrado de un usario mediante ELIMINAR lo elimina completamente del sistema.',
    '_USAGE_FEEDBACK_PREFS' => 'Esta pantalla le permite configurar la forma en que sus lectores pueden contribuir en su blog.',
    '_USAGE_FORGOT_PASSWORD_1' => 'Solicitó la recuperación de su contraseña de Movable Type. Su contraseña se ha modificado en el sistema; ésta es su nueva contraseña:',
    'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides.' => 'Los siguientes módulos son <strong>opcionales</strong>. Si su servidor no tiene estos módulos instalados, solo tendrá que instalarlos para aprovechar la funcionalidad que provee cada módulo.',
    'No groups were found with these settings.' => 'No se encontraron grupos con estas opciones.',
    '_USAGE_EXPORT_2' => 'Para exportar sus entradas, haga clic en el enlace que aparece debajo ("Exportar entradas desde [_1]"). Para guardar los datos exportados en un fichero, mantenga presionada la tecla <code>opción</code> del Macintosh (o la tecla <code>Mayús</code> si trabaja con un PC) y haga clic en el enlace. También puede seleccionar todos los datos y luego copiarlos en otro documento. (<a href="#" onclick="openManual(\'importing\', \'export_ie\');return false;">¿Exportando desde Internet Explorer?</a>)',
    '_USAGE_PING_LIST_ALL_WEBLOGS' => 'Ésta es la lista de pings de todos los weblogs.',
    'Cloning categories for weblog.' => 'Clonando categorías del weblog.',
    'Yearly' => 'Anualmente', # Translate - New (1)
    'Failed login attempt with incorrect password by user \'[_1]\' (ID: [_2])' => 'Intento de acceso con una contraseña no válida por el usuario  \'[_1]\' (ID: [_2])',
    'No executable code' => 'No es código ejecutable',
    '_USAGE_PING_LIST_OVERVIEW' => 'Aquí tiene una lista de los TrackBacks de todos los weblogs que puede filtrar, administrar y editar',
    'AUTO DETECT' => 'AUTO DETECTAR',
    'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Por defecto, este motor de búsqueda comprueba todas las palabras sin tener en cuenta el orden. Para buscar una frase exacta, encierre la frase entre comillas:',
    '_USAGE_GROUPS_USER_LDAP' => 'Debajo se encuentra una lista de todos los grupos en el sistema de Movable Type. Puede habilitar o deshabilitar un grupo haciendo clic en la casilla junto a su nombre, y luego presionando el botón de Habilitar o Deshabilitar.',
    'You need to create some groups.' => 'Debe crear algunos grupos.',
    'You need to create some weblogs.' => 'Debe crear algunos weblogs.',
    'No birthplace, cannot recover password' => 'Sin lugar de nacimiento, no puede recuperar la contraseña',
    'Install <a href=\'http://greasemonkey.mozdev.org/\'>GreaseMonkey</a>' => 'Instalar <a href=\'http://greasemonkey.mozdev.org/\'>GreaseMonkey</a>',
    'The next entry in this blog is <a href="[_1]">[_2]</a>.' => 'La entrada siguiente en este blog es <a href="[_1]">[_2]</a>.', # Translate - New (12)
    '_WARNING_DELETE_USER_EUM' => 'Borrar un usuario es una acción irreversible que crea huérfanos en las entradas del usuario. Si desea retirar un usuario o bloquear su acceso al sistema, se recomienda deshabilitar su cuenta. ¿Está seguro de que desea borrar a los usuarios seleccionados\nPodrán re-crearse a sí mismos si el usuario seleccionado existe en el directorio externo.',
    '_USER_ENABLE' => 'Habilitado',
    'Can administer the weblog.' => 'Puede administrar el weblog.',
    '_USAGE_PROFILE' => 'Edite aquí su perfil de usario. Si cambia su nombre de usuario o su contraseña, sus credenciales de inicio de sesión se actualizarán automáticamente. En otras palabras, no necesitará volver a iniciar su sesión.',
    'Category' => 'Categoría',
    'Congratulations! A template module Widget named <strong>[_1]</strong> has been created which you can further <a href="[_2]">edit</a> to customize its display.' => '¡Felicidades! Se ha creado un módulo de plantilla de widget de nombre <strong>[_1]</strong>. Puede <a href="[_2]">editarlo</a> para personalizar sus opciones.',
    '_USAGE_AUTHORS_LDAP' => 'Lista de todos los usuarios en el sistema de Movable Type. Puede editar los permisos del usuario haciendo clic en el nombre. Puede deshabilitar usuarios activando las casillas junto a su nombre y presionando el botón Deshabilitar. De esta forma, el usuario no podrá acceder a Movable Type.',
    'An error occured during synchronization.  See the <a href=\'[_1]\'>activity log</a> for detailed information.' => 'Ocurrió un error durante la sincronización. Para información más detallada, consulte el <a href=\'[_1]\'>registro de actividad</a>.',
    '_USAGE_ENTRYPREFS' => 'La configuración de campos determina qué campos aparecerán en las pantallas de entrada nueva y edición. Puede elegir una configuración existente (básica o avanzada) o personalizar las pantallas haciendo clic en Personalizada para elegir los campos que desee que aparezcan.',
    '_USAGE_NEW_GROUP' => 'Desde esta pantalla puede crear un nuevo grupo en el sistema.',
    'You can not add disabled users to groups.' => 'No puede añadir usuarios deshabilitados a grupos.',
    'Are you sure you want to delete the selected user(s)?\nThey will be able to re-create themselves if selected user(s) still exist in LDAP.' => '¿Está seguro de que desea borrar los usuarios seleccionados?\nPodrán recrearse a sí mismos si los usuarios seleccionados continúan existiendo en el directorio LDAP.',
    'RSD' => 'RSD', # Translate - Previous (1)
    'Template \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => 'Plantilla \'[_1]\' (#[_2]) borrada por \'[_3]\' (usuario #[_4])',
    'User \'[_1]\' (#[_2]) banned commenter \'[_3]\' (#[_4]).' => 'El usuario \'[_1]\' (#[_2]) bloqueó al comentarista \'[_3]\' (#[_4]).',
    '_USAGE_ROLES' => 'Debajo está una lista de todos los roles disponibles para sus weblogs.',
    'Invalid username \'[_1]\' in password recovery attempt' => 'Usuario no válido \'[_1]\' en intento de recuperación de la contraseña',
    'Not Found' => 'No encontrado',
    'Error creating new template: ' => 'Error creando nueva plantilla: ',
    'You cannot modify your own permissions.' => 'No puede modificar sus propios permisos.',
    '_USAGE_ARCHIVE_MAPS' => 'Esta funcionalidad avanzada le permite mapear cualquier plantilla de archivos a múltiples tipos de archivos. Por ejemplo, podría crear dos vistas diferentes para sus archivos mensuales: una en la que las entradas de un mes particular se presentan como una lista y la otra en la que se representan las entradas en el calendario de ese mes.',
    'Trust Commenter(s)' => 'Confiar en comentarista/s',
    'Manage Templates' => 'Administrar plantillas',
    '_USAGE_BOOKMARKLET_2' => 'QuickPost para Movable Type permite personalizar el diseño y los campos de la página de QuickPost. Por ejemplo, puede incluir la posibilidad de crear extractos a través de la ventana de QuickPost. De forma predeterminada, una ventana de QuickPost tendrá siempre: un menú desplegable correspondiente al weblog en el que se va a publicar, un menú desplegable para seleccionar el estado de publicación de la nueva entrada (Borrador o Publicar), un cuadro de texto para introducir el título de la entrada y un cuadro de texto para introducir el cuerpo de la entrada.',
    '_USAGE_CATEGORY_PING_URL' => 'Esta es la URL que usuarán otros para enviar TrackBacks a su weblog. Si desea que cualquiera envíe TrackBacks a su weblog cuando escriban una entrada sobre esta categoría, haga pública esta URL. Si desea que sólo un grupo selecto de personas le hagan TrackBack, envíeles la URL de forma privada. Para incluir una lista de TrackBacks en la plantilla índice principal, compruebe la documentación de las etiquetas de plantilla relacionadas con los TrackBacks.',
    '_USAGE_PERMISSIONS_1' => 'Está editando los permisos de <b>[_1]</b>. Más abajo verá la lista de weblogs a los que tiene acceso como usario con permisos de edición; por cada weblog de la lista, asigne permisos a <b>[_1]</b>, activando las casillas correspondientes de los permisos de acceso que desea otorgar.',
    'List Users' => 'Listar usuarios',
    'Add/Manage Categories' => 'Añadir/Administrar categorías',
    'Creating entry category placements...' => 'Creando situaciones de categorías de entradas...',
    'To enable comment registration, you need to add a TypeKey token in your weblog config or user profile.' => 'Para habilitar el registro de comentarios, debe añadir un token de TypeKey a la configuración de su weblog o al perfil de su usario.',
    'Advanced' => 'Avanzado',
    'Are you sure you want to delete this [_1]?' => '¿Está seguro de que desea borrar este [_1]?',
    'Third-Party Services' => 'Servicios externos',
    'PAGE_ADV' => 'PAGE_ADV', # Translate - New (2)
    'Recover Password(s)' => 'Recuperar contraseña/s',
    'You can not create associations for disabled users.' => 'No puede crear asociaciones con usuarios deshabilitados.',
    '<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> es la siguiente categoría.',
    'User \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => 'Usuario \'[_1]\' (#[_2]) borrado por \'[_3]\' (usuario #[_4])',
    '_USAGE_PERMISSIONS_4' => 'Cada weblog puede tener múltiples usarios. Para crear un usario, introduzca la información del usuario en el siguiente formulario. A continuación, seleccione los weblogs en los que tendrá algún tipo de privilegio como usario. Cuando presione GUARDAR y el usuario esté registrado en el sistema, podrá editar sus privilegios de usario.',
    'Assigning spam status for comments...' => 'Marcando spam en los comentarios...', # Translate - New (5)
    '_USAGE_TAGS' => 'Utilice las etiquetas para agrupar las entradas.',
    'TrackBack for category #[_1] \'[_2]\'.' => 'TrackBack en la categoría #[_1] \'[_2]\'.',
    'Before you can do this, you need to create some weblogs. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a weblog.' => 'Antes de hacerlo, debe crear algunos weblogs. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Haga clic aquí</a> para crear un weblog.',
    '_USAGE_BOOKMARKLET_5' => 'Alternativamente, si está ejecutando Internet Explorer bajo Windows, puede instalar una opción "QuickPost" en el menú contextual de Windows. Haga clic en el enlace siguiente y acepte la petición del navegador de "Abrir" el fichero. A continuación, cierre y vuelva a abrir su navegador para crear el enlace al menú contextual.',
    'The last system administrator cannot be deleted under ExternalUserManagement.' => 'El último administrador de sistemas no puede borrarse en ExternalUserManagement.',
    '_USER_PENDING' => '_USER_PENDING', # Translate - New (3)
    'Assigning category parent fields...' => 'Asignando campos de ancentros en las categorías...',
    'A user by that name already exists.' => 'Ya existe un usario con dicho nombre.',
    '_USAGE_ENTRY_LIST_BLOG' => 'Aquí hay una lista de entradas de [_1] que puede filtrar, administrar y editar',
    'Movable Type ships with directory named <strong>mt-static</strong> which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type contiene un directorio llamado <strong>mt-static</strong> que contiene un serie importante de ficheros como imágenes, ficheros javascript y hojas de estilo.',
    'Search Results (max 10 entries)' => 'Resultados de la búsqueda (máx 10 entradas)',
    'Send Notifications' => 'Enviar notificaciones',
    'This page contains a single entry from the blog created on <strong>[_1]</strong>.' => 'Esta página contiene una sola entrada del blog creado en <strong>[_1]</strong>.', # Translate - New (14)
    'Setting blog allow pings status...' => 'Estableciendo el estado de recepción de pings en los blogs...',
    'Step 1 of 4' => 'Paso 1 de 4',
    'Edit All Entries' => 'Editar todas las entradas',
    'The settings below have been written to the file <tt>[_1]</tt>. If any of these settings are incorrect, you may click the \'Back\' button below to reconfigure them.' => 'Estas opciones de abajo se escribieron en el fichero <tt>[_1]</tt>. Si cualquiera fuera incorrecta, puede hacer clic en el botón \'Regresar\' para reconfigurarlas.',
    'Error assigning weblog administration rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable weblog administrator role was found.' => 'Error asignando derechos de administración de weblog al usuario \'[_1] (ID: [_2])\' para el weblog \'[_3] (ID: [_4])\'. No se encontrón un rol de administrador de weblog apropiado.',
    'Rebuild Files' => 'Reconstruir ficheros',
    '_USAGE_ROLE_PROFILE' => 'Desde esta pantalla puede definir un rol y sus permisos',

    ## Error messages, strings in the app code.

    ## ./mt-check.cgi.pre
    'CGI is required for all Movable Type application functionality.' => 'CGI es necesario para una completa funcionalidad de Movable Type.',
    'HTML::Template is required for all Movable Type application functionality.' => 'HTML::Template es necesario para que Movable Type funcione.',
    'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size es necesario para la transferencia de ficheros (para determinar el tamaño de las imágenes en cualquiera de los diferentes formatos).',
    'File::Spec is required for path manipulation across operating systems.' => 'File::Spec es necesario para la manipulación de rutas entre diferentes sistemas operativos.',
    'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie es necesario para la autentificación con cookies.',
    'DBI is required if you want to use any of the SQL database drivers.' => 'DBI es necesario si desea usar cualquiera de los controladores de base de datos SQL.',
    'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI y DBD::mysql son necesarios si desea usar el gestor de base de datos de MySQL.',
    'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI y DBD::Pg son necesarios si desea usar el gestor de base de datos de PostgreSQL.',
    'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI y DBD::SQLite son necesarios si desea usar el gestor de base de datos SQLite.', # Translate - New (15)
    'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI y DBD::SQLite2 son necesarios si quiere usar el gestor de base de datos SQLite 2.x.', # Translate - New (17)
    'DBI and DBD::Oracle are required if you want to use the Oracle database backend.' => 'DBI y DBD::Oracle son necesarios si desea usar el gestor de base de datos de Oracle.',
    'DBI and DBD::ODBC are required if you want to use the Microsoft SQL Server database backend.' => 'DBI y DBD::ODBC son necesarios si desea utilizar el gestor de base de datos Microsoft SQL Server.',
    'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in mt.cfg.' => 'HTML::Entities es necesario para codificar algunos caracteres, pero esta característica se puede desactivar usando la opción NoHTMLEntities en mt.cfg.',
    'LWP::UserAgent is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'LWP::UserAgent es opcional; es necesario si desea usar el sistema de TrackBack, las notificaciones a weblogs.com o a las Últimas actualizaciones de MT.',
    'SOAP::Lite is optional; It is needed if you wish to use the MT XML-RPC server implementation.' => 'SOAP::Lite es opcional; es necesario si desea usar la implementación del servidor XML-RPC de MT.',
    'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Temp es opcional; es necesario si desea ser capaz de sobreescribir ficheros existentes al transferir imágenes.',
    'Image::Magick is optional; It is needed if you would like to be able to create thumbnails of uploaded images.' => 'Image::Magick es opcional; se necesita si desea crear miniaturas de las imágenes transferidas.',
    'Storable is optional; it is required by certain MT plugins available from third parties.' => 'Storable es opcional; lo requieren varios módulos de Movable Type realizados por otros fabricantes.',
    'Crypt::DSA is optional; if it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSA es opcional; si está instalado, se acelerará el registro de comentarios.',
    'MIME::Base64 is required in order to enable comment registration.' => 'MIME::Base64 es necesario para habilitar el registro de comentarios.',
    'XML::Atom is required in order to use the Atom API.' => 'XML::Atom es necesario para usar el Atom API.',
    'Net::LDAP is required in order to use the LDAP Authentication.' => 'Net::LDAP es necesario para usar la autentificación LDAP.',
    'IO::Socket::SSL is required in order to use SSL/TLS connection with the LDAP Authentication.' => 'IO::Socket::SSL es necesario para utilizar la conexión SSL/TLS con la autentificación LDAP',
    'Cache::Memcached and memcached server/daemon is required in order to use memcached as caching mechanism used by Movable Type.' => 'Cache::Memcached y el servidor/demonio memcached son necesarios si desea usar memcached como mecanismo de caché en Movable Type.', # Translate - New (20)
    'Archive::Tar is required in order to archive files in backup/restore operation.' => 'Archive::Tar es necesario si desea archivar ficheros en las copias de seguridad.', # Translate - New (13)
    'IO::Compress::Gzip is required in order to compress files in backup/restore operation.' => 'IO::Compress::Gzip es necesario para comprimir los ficheros en las copias de seguridad.', # Translate - New (14)
    'IO::Uncompress::Gunzip is required in order to decompress files in backup/restore operation.' => 'IO::Uncompress::Gunzip es necesario para descomprimir los ficheros en las copias de seguridad.', # Translate - New (14)
    'Archive::Zip is required in order to archive files in backup/restore operation.' => 'Archive::Zip es necesario para archivar ficheros en las copias de seguridad.', # Translate - New (13)
    'XML::SAX and/or its dependencies is required in order to restore.' => 'XML::SAX y/o sus dependencias es necesaria para las restauraciones.', # Translate - New (12)
    'Checking for' => 'Comprobando', # Translate - New (2)
    'Installed' => 'Instalado', # Translate - New (1)
    'Data Storage' => 'Almacenamiento',
    'Required' => 'Obligatorio',
    'Optional' => 'Opcional',

    ## ./addons/Enterprise.pack/lib/MT/Group.pm

    ## ./addons/Enterprise.pack/lib/MT/LDAP.pm
    'Invalid LDAPAuthURL scheme: [_1].' => 'Formato de LDAPAuthURL no válido: [_1].',
    'Error connecting to LDAP server [_1]: [_2]' => 'Error conectando al servidor LDAP [_1]: [_2]',
    'User not found on LDAP: [_1]' => 'Usuario no encontrado en LDAP: [_1]',
    'Binding to LDAP server failed: [_1]' => 'Fallo conectando al servidor LDAP: [_1]',
    'More than one user with the same name found on LDAP: [_1]' => 'Se encontró más de un usuario con el mismo nombre en LDAP: [_1]',

    ## ./addons/Enterprise.pack/lib/MT/Auth/LDAP.pm
    'User [_1]([_2]) not found.' => 'No se encontró al usuario [_1]([_2]).',
    'User \'[_1]\' cannot be updated.' => 'El usuario \'[_1]\' ha sido actualizado',
    'User \'[_1]\' updated with LDAP login ID.' => 'El usuario \'[_1]\' actualizado con el identificador de acceso LDAP',
    'LDAP user [_1] not found.' => 'Usuario de LDAP [_1] no encontrado.',
    'User [_1] cannot be updated.' => 'El usuario [_1] no se pudo actualizar.',
    'User cannot be updated: [_1].' => 'No se pudo actualizar al usuario: [_1].',
    'Failed login attempt by user \'[_1]\' deleted from LDAP.' => 'Falló el intento de inicio de sesión del usuario \'[_1]\' borrado de LDAP.',
    'User \'[_1]\' updated with LDAP login name \'[_2]\'.' => 'Se actualizó al usuario \'[_1]\' en el servidor LDAP con el nombre \'[_2]\'.',
    'User cannot be created: [_1].' => 'No se pudo crear al usuario: [_1].',
    'Failed login attempt by user \'[_1]\'. A user with that\nusername already exists in the system with a different UUID.' => 'Falló el intento de inicio de sesión del usuario \'[_1]\'. Ya existe\nun usuario con dicho nombre en el sistema, con un UUID diferente.',
    'User \'[_1]\' account is disabled.' => 'La cuenta del usuario \'[_1]\' está deshabilitada.',
    'LDAP users synchronization interrupted.' => 'Interrumpida la sincronización de usuarios LDAP .',
    'Loading MT::LDAP failed: [_1]' => 'Fallo cargando MT::LDAP: [_1]',
    'External user synchronization failed.' => 'Falló la sincronización externa de usuarios',
    'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'Hubo un intento de deshabilitar todos los administradores del sistema. La sincronización de usuarios fue interrumpida.',
    'The following users\' information were modified:' => 'Se modificaron los siguientes datos de usuarios:',
    'The following users were disabled:' => 'Se deshabilitaron los siguientes usuarios:',
    'LDAP users synchronized.' => 'Usuarios LDAP sincronizados.',
    'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute is set.' => 'No se puede realizar la sincronización de grupos sin que LDAPGroupIdAttribute y/o LDAPGroupNameAttribute estén configurados.',
    'LDAP groups synchronized with existing groups.' => 'Se sincronizaron los grupos LDAP con los existentes.',
    'The following groups\' information were modified:' => 'Los siguientes grupos fueron modificados:',
    'No LDAP group was found using given filter.' => 'No se encontrón ningún grupo LDAP utilizando el filtro provisto.',
    'Filter used to search for groups: [_1]\nSearch base: [_2]' => 'Filtro utilizado para la búsqueda de grupos: [_1]\nBúsqueda base: [_2]',
    '(none)' => '(ninguno)',
    'The following groups were deleted:' => 'Los siguientes grupos fueron borrados:',
    'Failed to create a new group: [_1]' => 'Fallo al crear un nuevo grupo: [_1]',
    '[_1] directive must be set to synchronize members of LDAP groups to Movable Type Enterprise.' => 'La directiva [_1] debe estar configurada para sincronizar los miembros de los grupos LDAP con Movable Type Enterprise.',
    'Members removed: ' => 'Miembros eliminados: ',
    'Members added: ' => 'Miembros añadidos: ',
    'Memberships of the group \'[_2]\' (#[_3]) has been changed in synchronizing with external directory.' => 'Se han cambiado los miembros del grupo \'[_2]\' (#[_3]) durante la sincronización con directorio externo.',
    'LDAPUserGroupMemberAttribute must be set to enable synchronize members of groups.' => 'LDAPUserGroupMemberAttribute debe estar configurado para habilitar la sincronización de los miembros de los grupos.',

    ## ./addons/Enterprise.pack/lib/MT/Enterprise/CMS.pm
    'Group requires name' => 'El grupo necesita un nombre',
    'Permission denied.' => 'Permiso denegado.',
    'Invalid group' => 'Grupo no válido',
    'Add Users to Group [_1]' => 'Añadir usuarios al grupo [_1]',
    'Select Users' => 'Seleccionar usuarios',
    'Users Selected' => 'Usuarios seleccionados',
    'Type a username to filter the choices below.' => 'Introduzca un nombre de usuario para filtrar las opciones.',
    '(user deleted)' => '(usario borrado)',
    'Groups' => 'Grupos',
    'Users & Groups' => 'Usuarios y grupos',
    'User Groups' => 'Grupos de usuarios',
    'Group load failed: [_1]' => 'Fallo en la carga de grupos: [_1]',
    'User load failed: [_1]' => 'Fallo en la carga de usuarios: [_1]',
    'User \'[_1]\' (ID:[_2]) removed from group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'El usuario \'[_1]\' (ID:[_2]) fue eliminado del grupo \'[_3]\' (ID:[_4]) por \'[_5]\'',
    'User \'[_1]\' (ID:[_2]) was added to group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'El usuario \'[_1]\' (ID:[_2]) fue añadido al grupo \'[_3]\' (ID:[_4]) por \'[_5]\'',
    'Group Profile' => 'Perfil de grupo',
    'Author load failed: [_1]' => 'Fallo la carga de autores: [_1]',
    'Invalid user' => 'Usuario no válido',
    'Assign User [_1] to Groups' => 'Asignar usuario [_1] a grupos',
    'Select Groups' => 'Seleccionar grupos',
    'Group' => 'Grupo',
    'Description' => 'Descripción',
    'Groups Selected' => 'Grupos seleccionados',
    'Type a group name to filter the choices below.' => 'Introduzca un nombre de grupo para filtrar las opciones.',
    'Bulk import cannot be used under external user management.' => 'La importación en lotes no puede usarse bajo la administración de un usuario externo.',
    'Users' => 'Usarios',
    'Bulk management' => 'Administración en lotes',
    'You did not choose a file to upload.' => 'No ha seleccionado un fichero para subir.',

    ## ./addons/Enterprise.pack/lib/MT/Enterprise/Wizard.pm
    'PLAIN' => 'PLANO',
    'CRAM-MD5' => 'CRAM-MD5', # Translate - Previous (1)
    'Digest-MD5' => 'Digest-MD5', # Translate - Previous (1)
    'Login' => 'Acceso',
    'Found' => 'Encontrado',
    'Not Found' => 'No encontrado',

    ## ./addons/Enterprise.pack/lib/MT/ObjectDriver/DDL/MSSQLServer.pm

    ## ./addons/Enterprise.pack/lib/MT/ObjectDriver/DDL/Oracle.pm

    ## ./addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/MSSQLServer.pm
    'PublishCharset [_1] is not supported in this version of MS SQL Server Driver.' => 'PublishCharset [_1] no está soportado en esta versión del controlador de MS SQL Server.',

    ## ./addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/Oracle.pm

    ## ./addons/Enterprise.pack/lib/MT/ObjectDriver/SQL/MSSQLServer.pm

    ## ./addons/Enterprise.pack/lib/MT/ObjectDriver/SQL/Oracle.pm

    ## ./build/Backup.pm

    ## ./build/Build.pm

    ## ./build/cwapi.pm

    ## ./build/exportmt.pl

    ## ./build/Html.pm

    ## ./build/sample.pm

    ## ./build/template_hash_signatures.pl

    ## ./build/l10n/diff.pl

    ## ./build/l10n/trans.pl

    ## ./build/l10n/wrap.pl

    ## ./extlib/CGI.pm

    ## ./extlib/Jcode.pm

    ## ./extlib/JSON.pm

    ## ./extlib/LWP.pm

    ## ./extlib/URI.pm

    ## ./extlib/Apache/SOAP.pm

    ## ./extlib/Apache/XMLRPC/Lite.pm

    ## ./extlib/Archive/Extract.pm

    ## ./extlib/Attribute/Params/Validate.pm

    ## ./extlib/Cache/IOString.pm

    ## ./extlib/Cache/Memory.pm

    ## ./extlib/Cache/Memory/Entry.pm

    ## ./extlib/Cache/Memory/HeapElem.pm

    ## ./extlib/CGI/Apache.pm

    ## ./extlib/CGI/Carp.pm

    ## ./extlib/CGI/Cookie.pm

    ## ./extlib/CGI/Fast.pm

    ## ./extlib/CGI/Pretty.pm

    ## ./extlib/CGI/Push.pm

    ## ./extlib/CGI/Switch.pm

    ## ./extlib/CGI/Util.pm

    ## ./extlib/Class/Accessor.pm

    ## ./extlib/Class/ErrorHandler.pm

    ## ./extlib/Class/Trigger.pm

    ## ./extlib/Class/Accessor/Fast.pm

    ## ./extlib/Class/Data/Inheritable.pm

    ## ./extlib/Crypt/DH.pm

    ## ./extlib/Data/ObjectDriver.pm

    ## ./extlib/Data/ObjectDriver/BaseObject.pm

    ## ./extlib/Data/ObjectDriver/BaseView.pm

    ## ./extlib/Data/ObjectDriver/Errors.pm

    ## ./extlib/Data/ObjectDriver/Profiler.pm

    ## ./extlib/Data/ObjectDriver/SQL.pm

    ## ./extlib/Data/ObjectDriver/Driver/BaseCache.pm

    ## ./extlib/Data/ObjectDriver/Driver/DBD.pm

    ## ./extlib/Data/ObjectDriver/Driver/DBI.pm

    ## ./extlib/Data/ObjectDriver/Driver/MultiPartition.pm

    ## ./extlib/Data/ObjectDriver/Driver/Multiplexer.pm

    ## ./extlib/Data/ObjectDriver/Driver/Partition.pm

    ## ./extlib/Data/ObjectDriver/Driver/SimplePartition.pm

    ## ./extlib/Data/ObjectDriver/Driver/Cache/Apache.pm

    ## ./extlib/Data/ObjectDriver/Driver/Cache/Cache.pm

    ## ./extlib/Data/ObjectDriver/Driver/Cache/Memcached.pm

    ## ./extlib/Data/ObjectDriver/Driver/Cache/RAM.pm

    ## ./extlib/Data/ObjectDriver/Driver/DBD/mysql.pm

    ## ./extlib/Data/ObjectDriver/Driver/DBD/Pg.pm

    ## ./extlib/Data/ObjectDriver/Driver/DBD/SQLite.pm

    ## ./extlib/File/Listing.pm

    ## ./extlib/File/Temp.pm

    ## ./extlib/File/Copy/Recursive.pm

    ## ./extlib/Heap/Fibonacci.pm

    ## ./extlib/HTML/Form.pm

    ## ./extlib/HTML/Template.pm

    ## ./extlib/HTTP/Cookies.pm

    ## ./extlib/HTTP/Daemon.pm

    ## ./extlib/HTTP/Date.pm

    ## ./extlib/HTTP/Headers.pm

    ## ./extlib/HTTP/Message.pm

    ## ./extlib/HTTP/Negotiate.pm

    ## ./extlib/HTTP/Request.pm

    ## ./extlib/HTTP/Response.pm

    ## ./extlib/HTTP/Status.pm

    ## ./extlib/HTTP/Headers/Auth.pm

    ## ./extlib/HTTP/Headers/ETag.pm

    ## ./extlib/HTTP/Headers/Util.pm

    ## ./extlib/HTTP/Request/Common.pm

    ## ./extlib/I18N/LangTags.pm

    ## ./extlib/I18N/LangTags/List.pm

    ## ./extlib/Image/Size.pm

    ## ./extlib/IO/Scalar.pm

    ## ./extlib/IO/SessionData.pm

    ## ./extlib/IO/SessionSet.pm

    ## ./extlib/IO/WrapTie.pm

    ## ./extlib/IPC/Cmd.pm

    ## ./extlib/Jcode/Constants.pm

    ## ./extlib/Jcode/H2Z.pm

    ## ./extlib/Jcode/Tr.pm

    ## ./extlib/Jcode/Unicode.pm

    ## ./extlib/Jcode/Unicode/Constants.pm

    ## ./extlib/Jcode/Unicode/NoXS.pm

    ## ./extlib/JSON/Converter.pm

    ## ./extlib/JSON/Parser.pm

    ## ./extlib/Locale/Maketext.pm

    ## ./extlib/LWP/ConnCache.pm

    ## ./extlib/LWP/Debug.pm

    ## ./extlib/LWP/MediaTypes.pm

    ## ./extlib/LWP/MemberMixin.pm

    ## ./extlib/LWP/Protocol.pm

    ## ./extlib/LWP/RobotUA.pm

    ## ./extlib/LWP/Simple.pm

    ## ./extlib/LWP/UserAgent.pm

    ## ./extlib/LWP/Authen/Basic.pm

    ## ./extlib/LWP/Authen/Digest.pm

    ## ./extlib/LWP/Protocol/data.pm

    ## ./extlib/LWP/Protocol/file.pm

    ## ./extlib/LWP/Protocol/ftp.pm

    ## ./extlib/LWP/Protocol/GHTTP.pm

    ## ./extlib/LWP/Protocol/gopher.pm

    ## ./extlib/LWP/Protocol/http.pm

    ## ./extlib/LWP/Protocol/http10.pm

    ## ./extlib/LWP/Protocol/https.pm

    ## ./extlib/LWP/Protocol/https10.pm

    ## ./extlib/LWP/Protocol/mailto.pm

    ## ./extlib/LWP/Protocol/nntp.pm

    ## ./extlib/LWP/Protocol/nogo.pm

    ## ./extlib/Math/BigInt.pm

    ## ./extlib/Math/BigInt/Calc.pm

    ## ./extlib/Math/BigInt/Scalar.pm

    ## ./extlib/Math/BigInt/Trace.pm

    ## ./extlib/MIME/Charset.pm

    ## ./extlib/MIME/EncWords.pm

    ## ./extlib/MIME/Charset/_Compat.pm

    ## ./extlib/Module/Load.pm

    ## ./extlib/Module/Load/Conditional.pm

    ## ./extlib/Net/HTTP.pm

    ## ./extlib/Net/HTTPS.pm

    ## ./extlib/Net/HTTP/Methods.pm

    ## ./extlib/Net/HTTP/NB.pm

    ## ./extlib/Net/OpenID/Association.pm

    ## ./extlib/Net/OpenID/ClaimedIdentity.pm

    ## ./extlib/Net/OpenID/Consumer.pm

    ## ./extlib/Net/OpenID/VerifiedIdentity.pm

    ## ./extlib/Params/Check.pm

    ## ./extlib/Params/Validate.pm

    ## ./extlib/Params/ValidatePP.pm

    ## ./extlib/Params/ValidateXS.pm

    ## ./extlib/SOAP/Lite.pm

    ## ./extlib/SOAP/Test.pm

    ## ./extlib/SOAP/Transport/FTP.pm

    ## ./extlib/SOAP/Transport/HTTP.pm

    ## ./extlib/SOAP/Transport/IO.pm

    ## ./extlib/SOAP/Transport/JABBER.pm

    ## ./extlib/SOAP/Transport/LOCAL.pm

    ## ./extlib/SOAP/Transport/MAILTO.pm

    ## ./extlib/SOAP/Transport/MQ.pm

    ## ./extlib/SOAP/Transport/POP3.pm

    ## ./extlib/SOAP/Transport/TCP.pm

    ## ./extlib/UDDI/Lite.pm

    ## ./extlib/UNIVERSAL/require.pm

    ## ./extlib/URI/data.pm

    ## ./extlib/URI/Escape.pm

    ## ./extlib/URI/Fetch.pm

    ## ./extlib/URI/file.pm

    ## ./extlib/URI/ftp.pm

    ## ./extlib/URI/gopher.pm

    ## ./extlib/URI/Heuristic.pm

    ## ./extlib/URI/http.pm

    ## ./extlib/URI/https.pm

    ## ./extlib/URI/ldap.pm

    ## ./extlib/URI/mailto.pm

    ## ./extlib/URI/news.pm

    ## ./extlib/URI/nntp.pm

    ## ./extlib/URI/pop.pm

    ## ./extlib/URI/QueryParam.pm

    ## ./extlib/URI/rlogin.pm

    ## ./extlib/URI/rsync.pm

    ## ./extlib/URI/rtsp.pm

    ## ./extlib/URI/rtspu.pm

    ## ./extlib/URI/sip.pm

    ## ./extlib/URI/sips.pm

    ## ./extlib/URI/snews.pm

    ## ./extlib/URI/ssh.pm

    ## ./extlib/URI/telnet.pm

    ## ./extlib/URI/URL.pm

    ## ./extlib/URI/urn.pm

    ## ./extlib/URI/WithBase.pm

    ## ./extlib/URI/_foreign.pm

    ## ./extlib/URI/_generic.pm

    ## ./extlib/URI/_login.pm

    ## ./extlib/URI/_query.pm

    ## ./extlib/URI/_segment.pm

    ## ./extlib/URI/_server.pm

    ## ./extlib/URI/_userpass.pm

    ## ./extlib/URI/Fetch/Response.pm

    ## ./extlib/URI/file/Base.pm

    ## ./extlib/URI/file/FAT.pm

    ## ./extlib/URI/file/Mac.pm

    ## ./extlib/URI/file/OS2.pm

    ## ./extlib/URI/file/QNX.pm

    ## ./extlib/URI/file/Unix.pm

    ## ./extlib/URI/file/Win32.pm

    ## ./extlib/URI/urn/isbn.pm

    ## ./extlib/URI/urn/oid.pm

    ## ./extlib/WWW/RobotRules.pm

    ## ./extlib/WWW/RobotRules/AnyDBM_File.pm

    ## ./extlib/XML/Atom.pm

    ## ./extlib/XML/Elemental.pm

    ## ./extlib/XML/NamespaceSupport.pm

    ## ./extlib/XML/SAX.pm

    ## ./extlib/XML/Simple.pm

    ## ./extlib/XML/XPath.pm

    ## ./extlib/XML/Atom/API.pm

    ## ./extlib/XML/Atom/Author.pm

    ## ./extlib/XML/Atom/Base.pm

    ## ./extlib/XML/Atom/Category.pm

    ## ./extlib/XML/Atom/Client.pm

    ## ./extlib/XML/Atom/Content.pm

    ## ./extlib/XML/Atom/Entry.pm

    ## ./extlib/XML/Atom/ErrorHandler.pm

    ## ./extlib/XML/Atom/Feed.pm

    ## ./extlib/XML/Atom/Link.pm

    ## ./extlib/XML/Atom/Person.pm

    ## ./extlib/XML/Atom/Server.pm

    ## ./extlib/XML/Atom/Thing.pm

    ## ./extlib/XML/Atom/Util.pm

    ## ./extlib/XML/Elemental/Characters.pm

    ## ./extlib/XML/Elemental/Document.pm

    ## ./extlib/XML/Elemental/Element.pm

    ## ./extlib/XML/Elemental/Node.pm

    ## ./extlib/XML/Elemental/SAXHandler.pm

    ## ./extlib/XML/Elemental/Util.pm

    ## ./extlib/XML/Parser/Lite.pm

    ## ./extlib/XML/Parser/Style/Elemental.pm

    ## ./extlib/XML/SAX/Base.pm

    ## ./extlib/XML/SAX/DocumentLocator.pm

    ## ./extlib/XML/SAX/Exception.pm

    ## ./extlib/XML/SAX/ParserFactory.pm

    ## ./extlib/XML/SAX/PurePerl.pm

    ## ./extlib/XML/SAX/PurePerl/DebugHandler.pm

    ## ./extlib/XML/SAX/PurePerl/DocType.pm

    ## ./extlib/XML/SAX/PurePerl/DTDDecls.pm

    ## ./extlib/XML/SAX/PurePerl/EncodingDetect.pm

    ## ./extlib/XML/SAX/PurePerl/Exception.pm

    ## ./extlib/XML/SAX/PurePerl/NoUnicodeExt.pm

    ## ./extlib/XML/SAX/PurePerl/Productions.pm

    ## ./extlib/XML/SAX/PurePerl/Reader.pm

    ## ./extlib/XML/SAX/PurePerl/UnicodeExt.pm

    ## ./extlib/XML/SAX/PurePerl/XMLDecl.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/NoUnicodeExt.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/Stream.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/String.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/UnicodeExt.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/URI.pm

    ## ./extlib/XML/XPath/Boolean.pm

    ## ./extlib/XML/XPath/Builder.pm

    ## ./extlib/XML/XPath/Expr.pm

    ## ./extlib/XML/XPath/Function.pm

    ## ./extlib/XML/XPath/Literal.pm

    ## ./extlib/XML/XPath/LocationPath.pm

    ## ./extlib/XML/XPath/Node.pm

    ## ./extlib/XML/XPath/NodeSet.pm

    ## ./extlib/XML/XPath/Number.pm

    ## ./extlib/XML/XPath/Parser.pm

    ## ./extlib/XML/XPath/PerlSAX.pm

    ## ./extlib/XML/XPath/Root.pm

    ## ./extlib/XML/XPath/Step.pm

    ## ./extlib/XML/XPath/Variable.pm

    ## ./extlib/XML/XPath/XMLParser.pm

    ## ./extlib/XML/XPath/Node/Attribute.pm

    ## ./extlib/XML/XPath/Node/Comment.pm

    ## ./extlib/XML/XPath/Node/Element.pm

    ## ./extlib/XML/XPath/Node/Namespace.pm

    ## ./extlib/XML/XPath/Node/PI.pm

    ## ./extlib/XML/XPath/Node/Text.pm

    ## ./extlib/XMLRPC/Lite.pm

    ## ./extlib/XMLRPC/Test.pm

    ## ./extlib/XMLRPC/Transport/HTTP.pm

    ## ./extlib/XMLRPC/Transport/POP3.pm

    ## ./extlib/XMLRPC/Transport/TCP.pm

    ## ./extlib/YAML/Tiny.pm

    ## ./extras/examples/plugins/BackupRestoreSample/BackupRestoreSample.pl

    ## ./extras/examples/plugins/BackupRestoreSample/lib/BackupRestoreSample/Object.pm

    ## ./extras/examples/plugins/CommentByGoogleAccount/CommentByGoogleAccount.pl
    'Commenter\'s nickname to be used:' => 'Pseudónimo de comentarista a usar:', # Translate - New (6)

    ## ./extras/examples/plugins/CommentByGoogleAccount/lib/CommentByGoogleAccount.pm
    'Couldn\'t save the session' => 'No se pudo guardar la sesión',

    ## ./extras/examples/plugins/FiveStarRating/plugins/FiveStarRating/FiveStarRating.pl
    'You used an [_1] tag outside of the proper context.' => 'Usó una etiqueta [_1] fuera del contexto correcto.',

    ## ./extras/examples/plugins/FiveStarRating/plugins/FiveStarRating/lib/FiveStarRating.pm

    ## ./extras/examples/plugins/l10nsample/l10nsample.pl

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample.pm
    'This is localized in perl module' => 'Este es un módulo de perl traducido',

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N/en_us.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N/ja.pm

    ## ./extras/examples/plugins/mirror/mirror.pl

    ## ./extras/examples/plugins/mirror/lib/Mirror.pm

    ## ./extras/examples/plugins/reCaptcha/plugins/reCaptcha/reCaptcha.pl

    ## ./extras/examples/plugins/reCaptcha/plugins/reCaptcha/lib/reCaptcha.pm

    ## ./extras/examples/plugins/SharedSecret/plugins/SharedSecret/SharedSecret.pl

    ## ./extras/examples/plugins/SharedSecret/plugins/SharedSecret/lib/SharedSecret.pm
    'DO YOU KNOW?  What is MT team\'s favorite brand of chocolate snack?' => '¿LO SABÍAS? ¿Cuál es la chocolatina favorita del equipo de Movable Type?', # Translate - New (13)

    ## ./extras/examples/plugins/SimpleScorer/SimpleScorer.pl

    ## ./extras/examples/plugins/SimpleScorer/lib/SimpleScorer.pm
    'Error during scoring.' => 'Error durante la puntuación.', # Translate - New (3)

    ## ./lib/MT/App.pm
    'First Weblog' => 'Primer weblog',
    'Error loading weblog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => 'Error cargando el weblog #[_1] durante la creación del usuario. Compruebe la opción de configuración NewUserTemplateBlogId.',
    'Error provisioning weblog for new user \'[_1]\' using template blog #[_2].' => 'Error creando el weblog del nuevo usuario \'[_1]\' utilizando la plantilla del blog #[_2]',
    'Error creating directory [_1] for blog #[_2].' => 'Error creando el directorio [_1] para el blog #[_2].',
    'Error provisioning weblog for new user \'[_1] (ID: [_2])\'.' => 'Error provisionando al weblog con el nuevo usuario \'[_1] (ID: [_2])\'.',
    'Blog \'[_1] (ID: [_2])\' for user \'[_3] (ID: [_4])\' has been created.' => 'Blog \'[_1] (ID: [_2])\' para el usuario \'[_3] (ID: [_4])\' ha sido creado.',
    'Error assigning weblog administration rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable weblog administrator role was found.' => 'Error asignando derechos de administración de weblog al usuario \'[_1] (ID: [_2])\' para el weblog \'[_3] (ID: [_4])\'. No se encontrón un rol de administrador de weblog apropiado.',
    'The login could not be confirmed because of a database error ([_1])' => 'No se pudo confirmar el acceso debido a un error de la base de datos ([_1])',
    'Failed login attempt by unknown user \'[_1]\'' => 'Intento fallido de inicio de sesión por un usuario desconocido \'[_1]\'',
    'Invalid login.' => 'Acceso no válido.',
    'Failed login attempt by disabled user \'[_1]\'' => 'Intento fallido de inicio de sesión por un usuario deshabilitado \'[_1]\'',
    'This account has been disabled. Please see your system administrator for access.' => 'Esta cuenta fue deshabilitada. Por favor, póngase en contacto con el administrador del sistema.',
    'This account has been deleted. Please see your system administrator for access.' => 'Esta cuenta fue eliminada. Por favor, póngase en contacto con el administrador del sistema.',
    'User \'[_1]\' has been created.' => 'El usuario \'[_1]\' ha sido creado',
    'User \'[_1]\' (ID:[_2]) logged in successfully' => 'Usuario \'[_1]\' (ID:[_2]) inició una sesión correctamente',
    'Invalid login attempt from user \'[_1]\'' => 'Intento de acceso no válido del usuario \'[_1]\'',
    'User \'[_1]\' (ID:[_2]) logged out' => 'Usuario \'[_1]\' (ID:[_2]) se desconectó',
    'The file you uploaded is too large.' => 'El fichero que transfirió es demasiado grande.',
    'Unknown action [_1]' => 'Acción desconocida [_1]',
    'Warnings and Log Messages' => 'Mensajes de alerta e históricos',
    'Loading template \'[_1]\' failed: [_2]' => 'Fallo cargando plantilla \'[_1]\': [_2]',
    'http://www.movabletype.com/' => 'http://www.movabletype.com/', # Translate - New (4)

    ## ./lib/MT/Asset.pm
    'File' => 'Fichero', # Translate - New (1)
    'Files' => 'Ficheros', # Translate - New (1)
    'Location' => 'Lugar', # Translate - New (1)

    ## ./lib/MT/Association.pm

    ## ./lib/MT/Atom.pm

    ## ./lib/MT/AtomServer.pm
    'PreSave failed [_1]' => 'Fallo en \'PreSave\' [_1]',
    'User \'[_1]\' (user #[_2]) added entry #[_3]' => 'El usuario \'[_1]\' (usuario nº [_2]) añadió la entrada nº[_3]',
    'User \'[_1]\' (user #[_2]) edited entry #[_3]' => 'El usuario \'[_1]\' (usuario nº [_2]) editó la entrada nº[_3]', # Translate - New (7)

    ## ./lib/MT/Auth.pm
    'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Configuración incorrecta de AuthenticationModule \'[_1]\': [_2]',
    'Bad AuthenticationModule config' => 'Configuración incorrecta de AuthenticationModule', # Translate - New (3)

    ## ./lib/MT/Author.pm
    'The approval could not be committed: [_1]' => 'La aprobación no pudo realizarse: [_1]',

    ## ./lib/MT/BackupRestore.pm
    'Backing up [_1] records:' => 'Haciendo la copia de seguridad de [_1] registros:', # Translate - New (4)
    '[_1] records backed up...' => '[_1] registros guardados...', # Translate - New (5)
    '[_1] records backed up.' => '[_1] registros guardados..', # Translate - New (5)
    'There were no [_1] records to be backed up.' => 'No habían [_1] registros de los que hacer copia de seguridad.', # Translate - New (9)
    'Can\'t open directory \'[_1]\': [_2]' => 'No se puede abrir el directorio \'[_1]\': [_2]',
    'No manifest file could be found in your import directory [_1].' => 'No se encontró fichero de manifiesto en el directorio de importación [_1].', # Translate - New (11)
    'Can\'t open [_1].' => 'No se pudo abrir [_1].', # Translate - New (4)
    'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'El fichero [_1] no es un fichero válido de manifiesto para copias de seguridad de Movable Type.', # Translate - New (12)
    'Manifest file: [_1]\n' => 'Fichero de manifiesto: [_1]\n', # Translate - New (4)
    'Path was not found for the asset ([_1]).' => 'La ruta no se encontró para el elemento ([_1]).', # Translate - New (8)
    '[_1] is not writable.' => 'No puede escribirse en [_1].',
    'Error making path \'[_1]\': [_2]' => 'Error creando la ruta \'[_1]\': [_2]',
    'Copying [_1] to [_2]...' => 'Copiando [_1] a [_2]...', # Translate - New (4)
    'Failed: ' => 'Falló: ', # Translate - New (1)
    'Done.' => 'Hecho.', # Translate - New (1)
    'ID for the asset was not set.' => 'No se estableció el ID para el elemento.', # Translate - New (7)
    'The asset ([_1]) was not restored.' => 'El elemento ([_1]) no se restauró.', # Translate - New (6)
    'Changing file path for the asset \'[_1]\' (ID:[_2])...' => 'Modificando la ruta para el elemento \'[_1]\' (ID:[_2])...', # Translate - New (9)
    'failed\n' => 'falló\n',
    'ok\n' => 'ok\n', # Translate - Previous (2)

    ## ./lib/MT/BasicAuthor.pm

    ## ./lib/MT/BasicSession.pm

    ## ./lib/MT/Blocklist.pm

    ## ./lib/MT/Blog.pm
    'No default templates were found.' => 'No se encontraron plantillas predefinidas.', # Translate - New (5)
    'Cloned blog... new id is [_1].' => 'Blog clonado... el nuevo identificador es [_1]',
    'Cloning permissions for blog:' => 'Clonando permisos para el blog:', # Translate - New (4)
    '[_1] records processed...' => 'Procesados [_1] registros...',
    '[_1] records processed.' => 'Procesados [_1] registros.',
    'Cloning associations for blog:' => 'Clonando asociaciones para el blog:', # Translate - New (4)
    'Cloning entries for blog...' => 'Clonando entradas para el blog...', # Translate - New (4)
    'Cloning categories for blog...' => 'Clonando categorías para el blog...', # Translate - New (4)
    'Cloning entry placements for blog...' => 'Clonando situación de entradas para el blog...', # Translate - New (5)
    'Cloning comments for blog...' => 'Clonando comentarios para el blog...', # Translate - New (4)
    'Cloning entry tags for blog...' => 'Clonando etiquetas de entradas para el blog...', # Translate - New (5)
    'Cloning TrackBacks for blog...' => 'Clonando TrackBacks para el blog...', # Translate - New (4)
    'Cloning TrackBack pings for blog...' => 'Clonando pings de TrackBack para el blog...', # Translate - New (5)
    'Cloning templates for blog...' => 'Clonando plantillas para el blog...', # Translate - New (4)
    'Cloning template maps for blog...' => 'Clonando mapas de plantillas para el blog...', # Translate - New (5)

    ## ./lib/MT/Bootstrap.pm
    'Got an error: [_1]' => 'Ocurrió un error en: [_1]',

    ## ./lib/MT/Builder.pm
    '<MT[_1]> with no </MT[_1]>' => '<MT[_1]> sin </MT[_1]>', # Translate - New (7)
    'Error in <mt:[_1]> tag: [_2]' => 'Error en la etiqueta <mt:[_1]>: [_2]', # Translate - New (6)
    'No handler exists for tag [_1]' => 'No existe función para la etiqueta [_1]', # Translate - New (6)

    ## ./lib/MT/BulkCreation.pm
    'Format error at line [_1]: [_2]' => 'Error de formato en la línea [_1]: [_2]',
    'Invalid command: [_1]' => 'Orden no válida: [_1]',
    'Invalid number of columns for [_1]' => 'Número incorrecto de columnas para [_1]',
    'Invalid user name: [_1]' => 'Nombre de usuario no válido: [_1]',
    'Invalid display name: [_1]' => 'Nombre público no válido: [_1]',
    'Invalid email address: [_1]' => 'Dirección de correo electrónico no válida: [_1]',
    'Invalid language: [_1]' => 'Idioma no válido: [_1]',
    'Invalid password: [_1]' => 'Contraseña no válida: [_1]',
    'Invalid password recovery phrase: [_1]' => 'Frase de recuperación de contraseña no válida: [_1]',
    'Invalid weblog name: [_1]' => 'Nombre de weblog no válido: [_1]',
    'Invalid weblog description: [_1]' => 'Descripción de weblog no válida: [_1]',
    'Invalid site url: [_1]' => 'URL del sitio no válida: [_1]',
    'Invalid site root: [_1]' => 'Ruta raíz del sitio no válida: [_1]',
    'Invalid timezone: [_1]' => 'Invalid timezone: [_1]', # Translate - Previous (3)
    'Invalid new user name: [_1]' => 'Nuevo nombre de usuario no válido: [_1]',
    'A user with the same name was found.  Register was not processed: [_1]' => 'Se encontró un usuario con el mismo nombre. Registro no procesado: [_1]',
    'Blog for user \'[_1]\' can not be created.' => ' No se pudo crear el blog del usuario \'[_1]\'.',
    'Blog \'[_1]\' for user \'[_2]\' has been created.' => 'Se creó el blog \'[_1]\' para el usuario \'[_2]\'.',
    'Permission granted to user \'[_1]\'' => 'Permiso dado al usuario \'[_1]\'',
    'User \'[_1]\' already exists. Update was not processed: [_2]' => 'Usuario \'[_1]\' ya existe. No se procesó la actualización: [_2]',
    'User \'[_1]\' not found.  Update was not processed.' => 'Usuario \'[_1]\' no encontrado. No se procesó la actualización.',
    'User \'[_1]\' has been updated.' => 'Se actualizó al usuario \'[_1]\'.',
    'User \'[_1]\' was found, but delete was not processed' => 'Usuario \'[_1]\' encontrado, pero no se procesó el borrado',
    'User \'[_1]\' not found.  Delete was not processed.' => 'Usuario \'[_1]\' no encontrado. El borrado no se procesó.',
    'User \'[_1]\' has been deleted.' => 'Se borró al usuario \'[_1]\'.',

    ## ./lib/MT/Callback.pm

    ## ./lib/MT/Category.pm
    'Categories must exist within the same blog' => 'Las categorías deben existir en el mismo blog',
    'Category loop detected' => 'Bucle de categorías detectado',

    ## ./lib/MT/Comment.pm
    'Comment' => 'Comentario',
    'Load of entry \'[_1]\' failed: [_2]' => 'Fallo al cargar la entrada \'[_1]\': [_2]',
    'Load of blog \'[_1]\' failed: [_2]' => 'La carga del blog \'[_1]\' falló: [_2]',

    ## ./lib/MT/Component.pm
    'Rebuild' => 'Reconstruir',

    ## ./lib/MT/Config.pm

    ## ./lib/MT/ConfigMgr.pm
    'Alias for [_1] is looping in the configuration.' => 'Alias de [_1] está generando un bucle en la configuración.',
    'Error opening file \'[_1]\': [_2]' => 'Error abriendo el fichero \'[_1]\': [_2]',
    'Config directive [_1] without value at [_2] line [_3]' => 'Directiva de configuración [_1] sin valor en [_2] línea [_3]',
    'No such config variable \'[_1]\'' => 'No existe tal variable de configuración \'[_1]\'',

    ## ./lib/MT/Core.pm

    ## ./lib/MT/DateTime.pm

    ## ./lib/MT/default-templates.pl

    ## ./lib/MT/DefaultTemplates.pm

    ## ./lib/MT/Entry.pm
    'Load of blog failed: [_1]' => 'Fallo en la carga del blog: [_1]',

    ## ./lib/MT/ErrorHandler.pm

    ## ./lib/MT/FileInfo.pm

    ## ./lib/MT/FileMgr.pm

    ## ./lib/MT/Folder.pm
    'Folder' => 'Carpeta', # Translate - New (1)
    'Folders' => 'Carpetas', # Translate - New (1)

    ## ./lib/MT/I18N.pm

    ## ./lib/MT/Image.pm
    'Can\'t load Image::Magick: [_1]' => 'No se pudo cargar Image::Magick: [_1]',
    'Reading file \'[_1]\' failed: [_2]' => 'Fallo leyendo archivo \'[_1]\': [_2]',
    'Reading image failed: [_1]' => 'Fallo leyendo imagen: [_1]',
    'Scaling to [_1]x[_2] failed: [_3]' => 'El escalado a [_1]x[_2] falló: [_3]',
    'Can\'t load IPC::Run: [_1]' => 'No se pudo cargar IPC::Run: [_1]',
    'You do not have a valid path to the NetPBM tools on your machine.' => 'No posee una ruta válida a las herramientas NetPBMYou en su máquina.',

    ## ./lib/MT/Import.pm
    'Can\'t rewind' => 'No se pudo reiniciar',
    'Can\'t open \'[_1]\': [_2]' => 'No se pudo abrir \'[_1]\': [_2]',
    'No readable files could be found in your import directory [_1].' => 'No se encontrón ningún fichero legible en su directorio de importación [_1].',
    'Importing entries from file \'[_1]\'' => 'Importando entradas desde el fichero \'[_1]\'',
    'Couldn\'t resolve import format [_1]' => 'No se pudo resolver el formato de importación [_1]', # Translate - New (6)

    ## ./lib/MT/ImportExport.pm
    'No Blog' => 'Sin Blog',
    'You need to provide a password if you are going to\n' => 'Debe proveer una contraseña si va a\n',
    'Need either ImportAs or ParentAuthor' => 'Necesita ImportAs o ParentAuthor',
    'Creating new user (\'[_1]\')...' => 'Creando usario (\'[_1]\')...',
    'Saving user failed: [_1]' => 'Fallo guardando usario: [_1]',
    'Assigning permissions for new user...' => 'Asignar permisos al nuevo usario...',
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

    ## ./lib/MT/IPBanList.pm

    ## ./lib/MT/JunkFilter.pm
    'Action: Junked (score below threshold)' => 'Acción: Basura (puntuación bajo nivel)',
    'Action: Published (default action)' => 'Acción: Publicado (acción predefinida)',
    'Junk Filter [_1] died with: [_2]' => 'Filtro basura [_1] murió con: [_2]',
    'Unnamed Junk Filter' => 'Filtro basura sin nombre',
    'Composite score: [_1]' => 'Puntuación compuesta: [_1]',

    ## ./lib/MT/L10N.pm

    ## ./lib/MT/Log.pm
    'Pages' => 'Páginas', # Translate - New (1)
    'Page # [_1] not found.' => 'Página nº [_1] no encontrada.', # Translate - New (4)
    'Entry # [_1] not found.' => 'Entrada nº [_1] no encontrada.',
    'Comment # [_1] not found.' => 'Comentario nº [_1] no encontrado.',
    'TrackBack # [_1] not found.' => 'TrackBack nº [_1] no encontrado.',

    ## ./lib/MT/Mail.pm
    'Unknown MailTransfer method \'[_1]\'' => 'MailTransfer método desconocido \'[_1]\'',
    'Sending mail via SMTP requires that your server ' => 'El envío de correo vía SMTP requiere que su servidor ',
    'Error sending mail: [_1]' => 'Error enviado correo: [_1]',
    'You do not have a valid path to sendmail on your machine. ' => 'No tiene una ruta válida a sendmail en su máquina. ',
    'Exec of sendmail failed: [_1]' => 'Fallo la ejecución de sendmail: [_1]',

    ## ./lib/MT/Memcached.pm

    ## ./lib/MT/Notification.pm

    ## ./lib/MT/Object.pm

    ## ./lib/MT/ObjectAsset.pm

    ## ./lib/MT/ObjectDriverFactory.pm

    ## ./lib/MT/ObjectScore.pm

    ## ./lib/MT/ObjectTag.pm

    ## ./lib/MT/Page.pm
    'Page' => 'Página', # Translate - New (1)

    ## ./lib/MT/Permission.pm

    ## ./lib/MT/Placement.pm

    ## ./lib/MT/Plugin.pm

    ## ./lib/MT/PluginData.pm

    ## ./lib/MT/Promise.pm

    ## ./lib/MT/Request.pm

    ## ./lib/MT/Role.pm

    ## ./lib/MT/Sanitize.pm

    ## ./lib/MT/Scorable.pm
    'Already scored for this object.' => 'Ya puntuado en este objeto.', # Translate - New (5)

    ## ./lib/MT/Serialize.pm

    ## ./lib/MT/Session.pm

    ## ./lib/MT/Tag.pm
    'Tag must have a valid name' => 'La etiqueta debe tener un nombre válido',
    'This tag is referenced by others.' => 'Esta etiqueta está referenciada por otros.',

    ## ./lib/MT/Task.pm

    ## ./lib/MT/TaskMgr.pm
    'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'No fue posible asegurar el bloqueo para la ejecución de tareas del sistema. Asegúrese de que se puede escribir en el directorio TempDir ([_1]).',
    'Error during task \'[_1]\': [_2]' => 'Error durante la tarea \'[_1]\': [_2]',
    'Scheduled Tasks Update' => 'Actualización de tareas programadas',
    'The following tasks were run:' => 'Se ejecutaron las siguientes tareas:',

    ## ./lib/MT/TBPing.pm

    ## ./lib/MT/Template.pm
    'File not found: [_1]' => 'Fichero no encontrado:', # Translate - New (4)
    'Parse error in template \'[_1]\': [_2]' => 'Error de interpretación en la plantilla \'[_1]\': [_2]',
    'Build error in template \'[_1]\': [_2]' => 'Error de reconstrucción en la plantilla \'[_1]\': [_2]',
    'Template with the same name already exists in this blog.' => 'Ya existe una plantilla con el mismo nombre en este blog.', # Translate - New (10)
    'You cannot use a [_1] extension for a linked file.' => 'No puede usar una extensión [_1] para un fichero enlazado.',
    'Opening linked file \'[_1]\' failed: [_2]' => 'Fallo abriendo fichero enlazado\'[_1]\': [_2]',

    ## ./lib/MT/TemplateMap.pm

    ## ./lib/MT/Trackback.pm

    ## ./lib/MT/Upgrade.pm
    'Custom ([_1])' => 'Personalizado ([_1])',
    'This role was generated by Movable Type upon upgrade.' => 'Este rol fue generado por Movable Type durante la actualización.',
    'First Blog' => 'Primer blog', # Translate - New (2)
    'User \'[_1]\' upgraded database to version [_2]' => 'Usuario \'[_1]\' actualizó la base de datos a la versión [_2]',
    'User \'[_1]\' upgraded plugin \'[_2]\' to version [_3] (schema version [_4]).' => 'Usuario \'[_1]\' actualizó la extensión \'[_2]\' a la versión [_3] (versión del esquema [_4]).', # Translate - New (11)
    'User \'[_1]\' installed plugin \'[_2]\', version [_3] (schema version [_4]).' => 'Usuario \'[_1]\' instaló la extensión \'[_2]\', versión [_3] (versión del esquema [_4]).', # Translate - New (10)

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

    ## ./lib/MT/WeblogPublisher.pm
    'yyyy/index.html' => 'aaaa/index.html', # Translate - New (3)
    'yyyy/mm/index.html' => 'aaaa/mm/index.html', # Translate - New (4)
    'yyyy/mm/day-week/index.html' => 'aaaa/mm/día-de-la-semana/index.html', # Translate - New (5)
    'yyyy/mm/entry_basename.html' => 'aaaa/mm/título_entrada.html', # Translate - New (5)
    'yyyy/mm/entry-basename.html' => 'aaaa/mm/título-entrada.html', # Translate - New (4)
    'yyyy/mm/entry_basename/index.html' => 'aaaa/mm/título_entrada/index.html', # Translate - New (6)
    'yyyy/mm/entry-basename/index.html' => 'aaaa/mm/titutlo-entrada/index.html', # Translate - New (5)
    'yyyy/mm/dd/entry_basename.html' => 'aaaa/mm/dd/título-entrada.html', # Translate - New (6)
    'yyyy/mm/dd/entry-basename.html' => 'aaaa/mm/dd/título-entrada.html', # Translate - New (5)
    'yyyy/mm/dd/entry_basename/index.html' => 'aaaa/mm/dd/título_entrada/index.html', # Translate - New (7)
    'yyyy/mm/dd/entry-basename/index.html' => 'aaaa/mm/dd/título-entrada/index.html', # Translate - New (6)
    'category/sub_category/entry_basename.html' => 'categoría/sub_categoría/título_entrada.html', # Translate - New (6)
    'category/sub_category/entry_basename/index.html' => 'categoría/sub_categoría/título_entrada/index.html', # Translate - New (7)
    'category/sub-category/entry-basename.html' => 'categoría/sub-categoría/título-entrada.html', # Translate - New (4)
    'category/sub-category/entry-basename/index.html' => 'categoría/sub-categoría/título-entrada/index.html', # Translate - New (5)
    'folder_path/page_basename.html' => 'ruta_carpeta/título_pagina.html', # Translate - New (5)
    'folder_path/page_basename/index.html' => 'ruta_carpeta/título_pagina/index.html', # Translate - New (6)
    'folder-path/page-basename.html' => 'ruta-carpeta/título-página.html', # Translate - New (3)
    'folder-path/page-basename/index.html' => 'carpeta-path/título-página/index.html', # Translate - New (4)
    'folder/sub_folder/index.html' => 'folder/sub_carpeta/index.html', # Translate - New (5)
    'folder/sub-folder/index.html' => 'folder/sub-carpeta/index.html', # Translate - New (4)
    'yyyy/mm/dd/index.html' => 'aaaa/mm/dd/index.html', # Translate - New (5)
    'category/sub_category/index.html' => 'category/sub_categoría/index.html', # Translate - New (5)
    'category/sub-category/index.html' => 'category/sub-categoría/index.html', # Translate - New (4)
    'Archive type \'[_1]\' is not a chosen archive type' => 'El tipo de archivos \'[_1]\' no es un tipo de archivos seleccionado',
    'Parameter \'[_1]\' is required' => 'El parámetro \'[_1]\' es necesario',
    'You did not set your weblog Archive Path' => 'No configuró la Ruta de Archivado de su weblog', # Translate - New (8)
    'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Ya existe el fichero del mismo archivo. Debe modificar el título o la ruta. ([_1])', # Translate - New (15)
    'Building category \'[_1]\' failed: [_2]' => 'Fallo reconstruyendo categoría \'[_1]\': [_2]',
    'Building entry \'[_1]\' failed: [_2]' => 'Fallo reconstruyendo entrada \'[_1]\': [_2]',
    'Building date-based archive \'[_1]\' failed: [_2]' => 'Fallo reconstruyendo archivo de fechas \'[_1]\': [_2]',
    'Writing to \'[_1]\' failed: [_2]' => 'Fallo escribiendo en \'[_1]\': [_2]',
    'Renaming tempfile \'[_1]\' failed: [_2]' => 'Fallo renombrando el fichero temporal \'[_1]\': [_2]',
    'You did not set your weblog Site Root' => 'No configuró la Raíz del sitio de su weblog', # Translate - New (8)
    'Template \'[_1]\' does not have an Output File.' => 'La plantilla \'[_1]\' no tiene un fichero de salida.',
    'An error occurred while rebuilding to publish scheduled entries: [_1]' => 'Ocurrió un error durante la reconstrucción para publicar las entradas programadas: [_1]', # Translate - New (10)
    'YEARLY_ADV' => 'YEARLY_ADV', # Translate - New (2)
    'MONTHLY_ADV' => 'Mensualmente',
    'CATEGORY_ADV' => 'Por categoría',
    'PAGE_ADV' => 'PAGE_ADV', # Translate - New (2)
    'INDIVIDUAL_ADV' => 'Individualmente',
    'DAILY_ADV' => 'Diariamente',
    'WEEKLY_ADV' => 'Semanalmente',

    ## ./lib/MT/XMLRPC.pm
    'No WeblogsPingURL defined in mt.cfg' => 'WeblogsPingURL no definido en mt.cfg',
    'No MTPingURL defined in mt.cfg' => 'MTPingURL no definido en mt.cfg',
    'HTTP error: [_1]' => 'Error HTTP: [_1]',
    'Ping error: [_1]' => 'Error de ping: [_1]',

    ## ./lib/MT/XMLRPCServer.pm
    'Invalid timestamp format' => 'Formato de fecha no válido',
    'No web services password assigned.  Please see your user profile to set it.' => 'No se ha establecido la contraseña de servicios web.  Por favor, vaya al perfil de su usario para configurarla.',
    'No blog_id' => 'Sin blog_id',
    'Invalid blog ID \'[_1]\'' => 'Identificador de blog  \'[_1]\' no válido',
    'Invalid login' => 'Inicio de sesión no válido',
    'No publishing privileges' => 'Sin privilegios de publicación', # Translate - New (3)
    'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => 'El valor de \'mt_[_1]\' debe ser 0 ó 1 (era \'[_2]\')',
    'No entry_id' => 'Sin entry_id',
    'Invalid entry ID \'[_1]\'' => 'ID de entrada no válido \'[_1]\'',
    'Not privileged to edit entry' => 'No tiene permisos para editar la entrada',
    'Not privileged to delete entry' => 'No tiene permisos para borrar la entrada',
    'Entry \'[_1]\' (entry #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'Entrada \'[_1]\' (entrada nº[_2]) borrada por \'[_3]\' (usuario nº[_4]) por XML-RPC',
    'Not privileged to get entry' => 'No tiene permisos para obtener la entrada',
    'User does not have privileges' => 'El usario no tiene permisos',
    'Not privileged to set entry categories' => 'No tiene permisos para establecer categorías en las entradas',
    'Publish failed: [_1]' => 'Falló la publicación: [_1]',
    'Not privileged to upload files' => 'No tiene privilegios para transferir ficheros',
    'No filename provided' => 'No se especificó el nombre del fichero ',
    'Invalid filename \'[_1]\'' => 'Nombre de fichero no válido \'[_1]\'',
    'Error writing uploaded file: [_1]' => 'Error escribiendo el fichero transferido: [_1]',
    'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Los métodos de las plantillas no están implementados, debido a las diferencias entre Blogger API y Movable Type API.',

    ## ./lib/MT/App/ActivityFeeds.pm
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
    'Movable Type Debug Activity' => 'Actividad de depuración de Movable Type',

    ## ./lib/MT/App/CMS.pm
    'Invalid request' => 'Petición no válida',
    'Invalid request.' => 'Petición no válida.',
    'All comments by [_1] \'[_2]\'' => 'Todos los comentarios de [_1] \'[_2]\'', # Translate - New (5)
    'All comments for [_1] \'[_2]\'' => 'Todos los comentarios de [_1] \'[_2]\'', # Translate - New (5)
    'Invalid blog' => 'Blog no válido',
    'Convert Line Breaks' => 'Convertir saltos de línea',
    'Password Recovery' => 'Recuperación de contraseña',
    'Invalid password recovery attempt; can\'t recover password in this configuration' => 'Intento de recuperación de contraseña no válido; no se pudo recuperar la clave con esta configuración',
    'Invalid author_id' => 'author_id no válido',
    'Can\'t recover password in this configuration' => 'No se pudo recuperar la clave con esta configuración',
    'Invalid user name \'[_1]\' in password recovery attempt' => 'Nombre de usario no válido \'[_1]\' en intento de recuperación de contraseña',
    'User name or birthplace is incorrect.' => 'Nombre del usario o lugar de nacimiento no válido.',
    'User has not set birthplace; cannot recover password' => 'El usario no tiene establecida una lugar de nacimiento; no se pudo recuperar la contarseña',
    'Invalid attempt to recover password (used birthplace \'[_1]\')' => 'Intento no válido de recuperación de contraseña (lugar de nacimiento usado \'[_1]\')',
    'User does not have email address' => 'El usario sin dirección de correo electrónico',
    'Password was reset for user \'[_1]\' (user #[_2]). Password was sent to the following address: [_3]' => 'Se reinició la contraseña del usario \'[_1]\' (user #[_2]). Se envió la contraseña a las siguientes direcciones: [_3]',
    'Error sending mail ([_1]); please fix the problem, then ' => 'Error enviando correo ([_1]); por favor, solucione el problema, y luego  ',
    '(newly created user)' => '(nuevo usuario creado)', # Translate - New (4)
    'Search Files' => 'Buscar ficheros', # Translate - New (2)
    'Invalid group id' => 'Identificador de grupo no válido',
    'Group Roles' => 'Roles de grupo',
    'Invalid user id' => 'Identificador de usuario no válido',
    'User Roles' => 'Roles de usuario',
    'Roles' => 'Roles', # Translate - Previous (1)
    'Group Associations' => 'Asociaciones de grupo',
    'User Associations' => 'Asociaciones de usuario',
    'Role Users & Groups' => 'Roles de usuarios y grupos',
    'Associations' => 'Asociaciones',
    '(Custom)' => '(Personalizado)',
    'Invalid type' => 'Tipo no válido',
    'No such tag' => 'No existe dicha etiqueta',
    'None' => 'Ninguno',
    'You are not authorized to log in to this blog.' => 'No está autorizado para acceder a este blog.',
    'No such blog [_1]' => 'No existe el blog [_1]',
    'Blogs' => 'Blogs', # Translate - New (1)
    'Blog Activity Feed' => 'Fuente de Actividades del blog', # Translate - New (3)
    'Group Members' => 'Miembros del grupo',
    'QuickPost' => 'QuickPost', # Translate - Previous (1)
    'All Feedback' => 'Todas las opiniones',
    'System Activity Feed' => 'Fuente de actividad del sistema',
    'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'El registro de actividad del blog \'[_1]\' (ID:[_2]) fue reiniciado por  \'[_3]\'',
    'Activity log reset by \'[_1]\'' => 'Registro de actividad reiniciado por \'[_1]\'',
    'No blog ID' => 'No es ID de blog',
    'You do not have import permissions' => 'No tiene permisos de importación',
    'Import/Export' => 'Importar/Exportar',
    'Invalid parameter' => 'Parámetro no válido',
    'Permission denied: [_1]' => 'Permiso denegado: [_1]',
    'Load failed: [_1]' => 'Fallo carga: [_1]',
    '(no reason given)' => '(ninguna razón ofrecida)',
    '(untitled)' => '(sin título)',
    'General Settings' => 'Configuración general',
    'Publishing Settings' => 'Configuración de publicación',
    'Plugin Settings' => 'Configuración de extensiones',
    'Edit TrackBack' => 'Editar TrackBack',
    'Edit Comment' => 'Editar comentario',
    'Authenticated Commenters' => 'Comentaristas autentificados',
    'Commenter Details' => 'Detalles del comentarista',
    'New Page' => 'Nueva página', # Translate - New (2)
    'Create template requires type' => 'Crear plantillas requiere el tipo',
    'Date based Archive' => 'Archivo basado en fechas', # Translate - New (3)
    'Individual Entry Archive' => 'Archivo de entradas individuales',
    'Category Archive' => 'Archivo de categorías',
    'Page Archive' => 'Archivo de páginas', # Translate - New (2)
    'New Template' => 'Nueva plantilla',
    'New Blog' => 'Nuevo blog', # Translate - New (2)
    'Create New User' => 'Crear nuevo usario',
    'User requires username' => 'El usario necesita un nombre de usuario',
    'A user with the same name already exists.' => 'Ya existe un usuario con el mismo nombre.',
    'User requires password' => 'El usario necesita una contraseña',
    'User requires password recovery word/phrase' => 'El usario necesita una palabra/frase de recuperación de contraseña',
    'Email Address is required for password recovery' => 'La dirección de correo es necesaria para la recuperación de la contraseña',
    'The value you entered was not a valid email address' => 'El valor que tecleó no es una dirección válida de correo electrónico',
    'The e-mail address you entered is already on the Notification List for this blog.' => 'La dirección de correo que introdujo ya está en la Lista de notificaciones de este blog.', # Translate - New (14)
    'You did not enter an IP address to ban.' => 'No tecleó una dirección IP para bloquear.',
    'The IP you entered is already banned for this blog.' => 'La IP que introdujo ya está bloqueada en este blog.', # Translate - New (10)
    'You did not specify a blog name.' => 'No especificó el nombre del blog.', # Translate - New (7)
    'Site URL must be an absolute URL.' => 'La URL del sitio debe ser una URL absoluta.',
    'Archive URL must be an absolute URL.' => 'La URL de archivo debe ser una URL absoluta.',
    'The name \'[_1]\' is too long!' => 'El nombre \'[_1]\' es demasiado largo.',
    'A user can\'t change his/her own username in this environment.' => 'Un usuario no puede cambiar su propio nombre en este contexto.',
    'An errror occurred when enabling this user.' => 'Ocurrió un error cuando se habilitaba este usuario.',
    'Folder \'[_1]\' created by \'[_2]\'' => 'Carpeta \'[_1]\' creada por \'[_2]\'', # Translate - New (5)
    'Category \'[_1]\' created by \'[_2]\'' => 'Categoría \'[_1]\' creada por \'[_2]\'',
    'The folder \'[_1]\' conflicts with another folder. Folders with the same parent must have unique basenames.' => 'La carpeta \'[_1]\' tiene conflicto con otra carpeta. Las carpetas con el mismo padre deben tener nombre base únicos.', # Translate - New (16)
    'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'El nombre de la categría \'[_1]\' tiene conflicto con otra categoría. Las categorías de primer nivel y las sub-categorías con el mismo padre deben tener nombres únicos.', # Translate - New (20)
    'The category basename \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => 'El nombre base de la categoría \'[_1]\' tiene conflictos con otra categoría. Las categorías de primer nivel y las sub-categorías con el mismo padre deben tener nombres base únicos.', # Translate - New (20)
    'Saving permissions failed: [_1]' => 'Fallo guardando permisos: [_1]',
    'Blog \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) creado por \'[_3]\'', # Translate - New (7)
    'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Usuario \'[_1]\' (ID:[_2]) creado por \'[_3]\'',
    'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Plantilla \'[_1]\' (ID:[_2]) creada por \'[_3]\'',
    'You cannot delete your own association.' => 'No puede borrar sus propias asociaciones.',
    'You cannot delete your own user record.' => 'No puede borrar el registro de su propio usario.',
    'You have no permission to delete the user [_1].' => 'No tiene permisos para borrar el usario [_1].',
    'Blog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) borrado por \'[_3]\'', # Translate - New (7)
    'Subscriber \'[_1]\' (ID:[_2]) deleted from notification list by \'[_3]\'' => 'Suscriptor \'[_1]\' (ID:[_2]) borrado de la lista de notificación por \'[_3]\'',
    'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Usuario \'[_1]\' (ID:[_2]) borrado por \'[_3]\'',
    'Folder \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Carpeta \'[_1]\' (ID:[_2]) borrada por \'[_3]\'', # Translate - New (7)
    'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Categoría \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
    'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Comentario (ID:[_1]) por \'[_2]\' borrado por \'[_3]\' de la entrada \'[_4]\'',
    'Page \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Página \'[_1]\' (ID:[_2]) borrada por \'[_3]\'', # Translate - New (7)
    'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Entrada \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
    '(Unlabeled category)' => '(Categoría sin título)',
    'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) desde \'[_2]\' borrado por \'[_3]\' de la categoría \'[_4]\'',
    '(Untitled entry)' => '(Entrada sin título)',
    'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) desde \'[_2]\' borrado por \'[_3]\' de la entrada \'[_4]\'',
    'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Plantilla \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
    'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Etiqueta \'[_1]\' (ID:[_2]) borrada por \'[_3]\'',
    'File \'[_1]\' uploaded by \'[_2]\'' => 'Fichero \'[_1]\' transferido por \'[_2]\'', # Translate - New (5)
    'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Fichero \'[_1]\' (ID:[_2]) transferido por \'[_3]\'', # Translate - New (7)
    'Permisison denied.' => 'Permiso denegado.',
    'The Template Name and Output File fields are required.' => 'Los campos del nombre de la plantilla y el fichero de salida son obligatorios.', # Translate - New (9)
    'Invalid type [_1]' => 'Tipo inválido [_1]', # Translate - New (3)
    'Save failed: [_1]' => 'Fallo al guardar: [_1]',
    'Saving object failed: [_1]' => 'Fallo guardando objeto: [_1]',
    'No Name' => 'Sin nombre',
    'Notification List' => 'Lista de notificaciones',
    'IP Banning' => 'Bloqueo de IPs',
    'Can\'t delete that way' => 'No puede borrar de esa forma',
    'Removing tag failed: [_1]' => 'Falló el borrado de la etiqueta: [_1]', # Translate - New (4)
    'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => 'No puede eliminar esa categoría porque tiene subcategorías. Mueva o elimine primero las categorías si desea eliminar ésta.',
    'Loading MT::LDAP failed: [_1].' => 'Falló la carga de MT::LDAP: [_1].',
    'Removing [_1] failed: [_2]' => 'Falló el borrado de [_1]: [_2]', # Translate - New (4)
    'System templates can not be deleted.' => 'Las plantillas del sistema no se pueden borrar.',
    'Unknown object type [_1]' => 'Tipo de objeto desconocido [_1]',
    'Can\'t load file #[_1].' => 'No se pudo cargar el fichero nº[_1].', # Translate - New (5)
    'No such commenter [_1].' => 'No existe el comentarista [_1].',
    'User \'[_1]\' trusted commenter \'[_2]\'.' => 'Usuario \'[_1]\' confió en el comentarista \'[_2]\'.',
    'User \'[_1]\' banned commenter \'[_2]\'.' => 'Usuario \'[_1]\' bloqueó al comentarista \'[_2]\'.',
    'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'Usuario \'[_1]\' desbloqueó al comentarista \'[_2]\'.',
    'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'Usuario \'[_1]\' desconfió del comentarista \'[_2]\'.',
    'Need a status to update entries' => 'Necesita indicar un estado para actualizar las entradas',
    'Need entries to update status' => 'Necesita entradas para actualizar su estado',
    'One of the entries ([_1]) did not actually exist' => 'Una de las entradas ([_1]) no existe actualmente',
    'Entry \'[_1]\' (ID:[_2]) status changed from [_3] to [_4]' => 'Entrada \'[_1]\' (ID:[_2]) cambió el estado de [_3] a [_4]', # Translate - New (10)
    'You don\'t have permission to approve this comment.' => 'No tiene permiso para aprobar este comentario.',
    'Comment on missing entry!' => '¡Comentario en entrada inexistente!',
    'Orphaned comment' => 'Comentario huérfano',
    'Orphaned' => 'Huérfano',
    'Plugin Set: [_1]' => 'Conjuntos de extensiones: [_1]',
    '<strong>[_1]</strong> is &quot;[_2]&quot;' => '<strong>[_1]</strong> es &quot;[_2]&quot;', # Translate - New (8)
    'TrackBack' => 'TrackBack', # Translate - Previous (1)
    'TrackBack Activity Feed' => 'Fuente de actividad de TrackBacks',
    'No Excerpt' => 'Sin resumen',
    'No Title' => 'Sin título',
    'Orphaned TrackBack' => 'TrackBack huérfano',
    'entry' => 'entrada',
    'category' => 'categoría',
    'Tag' => 'Etiqueta',
    'User' => 'Usario',
    'Entry Status' => 'Estado de la entrada', # Translate - New (2)
    '[_1] Feed' => 'Fuente [_1]', # Translate - New (3)
    '(user deleted - ID:[_1])' => '(usuario borrado - ID:[_1])', # Translate - New (5)
    'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Fecha no válida \'[_1]\'; debe tener el formato YYYY-MM-DD HH:MM:SS.',
    'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Fecha no válida \'[_1]\'; debe ser una fecha real.',
    'Saving entry \'[_1]\' failed: [_2]' => 'Fallo guardando entrada \'[_1]\': [_2]',
    'Removing placement failed: [_1]' => 'Fallo eliminando lugar: [_1]',
    'Entry \'[_1]\' (ID:[_2]) edited and its status changed from [_3] to [_4] by user \'[_5]\'' => 'Entrada \'[_1]\' (ID:[_2]) editada y cambiada de estado de [_3] a [_4] por el usuario \'[_5]\'', # Translate - New (16)
    'Entry \'[_1]\' (ID:[_2]) edited by user \'[_3]\'' => 'Entrada \'[_1]\' (ID:[_2]) editada por el usuario \'[_3]\'', # Translate - New (8)
    'No such [_1].' => 'No existe [_1].', # Translate - New (3)
    'Same Basename has already been used. You should use an unique basename.' => 'Ya se ha utilizado el mismo nombre base. Debe usar un nombre base único.', # Translate - New (12)
    'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Su blog no tiene configurados la URL y la raíz del sitio. No puede publicar entradas hasta que no estén definidos.', # Translate - New (20)
    'Saving [_1] failed: [_2]' => 'Falló al guardar [_1]: [_2]', # Translate - New (4)
    '[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'', # Translate - New (9)
    '[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_1] \'[_2]\' (ID:[_3]) editado y cambió su estado desde [_4] a [_5] al usuario \'[_6]\'', # Translate - New (17)
    '[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) editado por el usuario \'[_4]\'', # Translate - New (9)
    'The category label \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'El título de la categoría \'[_1]\' coincide con el de otra categoría. Las categorías de nivel superior y las sub-categorías con el mismo padre deben tener nombres únicos.',
    'The [_1] must be given a name!' => '¡Debe dar un nombre a [_1]!', # Translate - New (7)
    'Saving blog failed: [_1]' => 'Fallo guardando blog: [_1]',
    'Invalid ID given for personal blog clone source ID.' => 'Se introdujo un ID no válido para el ID de blog fuente de clonación.', # Translate - New (9)
    'If personal blog is set, the default site URL and root are required.' => 'Si se selecciona un blog personal, se necesitará su URL predefinida y raíz.', # Translate - New (13)
    'Feedback Settings' => 'Configuración de respuestas',
    'Parse error: [_1]' => 'Error de interpretación: [_1]',
    'Build error: [_1]' => 'Error construyendo: [_1]',
    'New [_1]' => 'Nuevo [_1]', # Translate - New (2)
    'index template \'[_1]\'' => 'plantilla índice \'[_1]\'',
    '[_1] \'[_2]\'' => '[_1] \'[_2]\'', # Translate - New (3)
    'No permissions' => 'No tiene permisos',
    'Ping \'[_1]\' failed: [_2]' => 'Falló ping \'[_1]\' : [_2]',
    'Create New Role' => 'Crear nuevo rol',
    'Role name cannot be blank.' => 'El nombre del rol no puede estar vacío.',
    'Another role already exists by that name.' => 'Ya existe otro rol con ese nombre.',
    'You cannot define a role without permissions.' => 'No puede definir un rol sin permisos.',
    'No entry ID provided' => 'ID de entrada no provista',
    'No such entry \'[_1]\'' => 'No existe la entrada \'[_1]\'',
    'No email address for user \'[_1]\'' => 'No hay dirección de correo electrónico asociada al usario \'[_1]\'',
    'No valid recipients found for the entry notification.' => 'No se encontraron destinatarios válidos para la notificación de la entrada.',
    '[_1] Update: [_2]' => '[_1] Actualiza: [_2]',
    'Error sending mail ([_1]); try another MailTransfer setting?' => 'Error enviando correo electrónico ([_1]); ¿quizás probando con otra configuración para MailTransfer?',
    'Upload File' => 'Transferir fichero',
    'Can\'t load blog #[_1].' => 'No se pudo cargar el blog nº[_1].', # Translate - New (5)
    'Before you can upload a file, you need to publish your blog.' => 'Antes de transferir ficheros, debe publicar su blog.', # Translate - New (12)
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
    'Search & Replace' => 'Buscar & Reemplazar',
    'Logs' => 'Históricos', # Translate - New (1)
    'Invalid date(s) specified for date range.' => 'Se especificaron fechas no válidas para el rango.',
    'Error in search expression: [_1]' => 'Error en la expresión de búsqueda: [_1]',
    'Saving object failed: [_2]' => 'Fallo al guardar objeto: [_2]',
    'You do not have export permissions' => 'No tiene permisos de exportación',
    'You do not have permission to create users' => 'No tiene permisos para crear usarios',
    'Importer type [_1] was not found.' => 'No se encontró el tipo de importador [_1].', # Translate - New (6)
    'Saving map failed: [_1]' => 'Fallo guardando mapa: [_1]',
    'Add a [_1]' => 'Añador un [_1]', # Translate - New (3)
    'No label' => 'Sin título',
    'Category name cannot be blank.' => 'El nombre de la categoría no puede estar en blanco.',
    'Populating blog with default templates failed: [_1]' => 'Fallo guardando el blog con las plantillas por defecto: [_1]',
    'Setting up mappings failed: [_1]' => 'Fallo la configuración de mapeos: [_1]',
    'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Error: Movable Type no puede escribir en el directorio de caché de las plantillas. Por favor, compruebe los permisos del directorio llamado <code>[_1]</code> dentro del directorio de su blog.', # Translate - New (25)
    'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Error: Movable Type no pudo crear un directorio para cachear las plantillas dinámicas. Debe crear un directorio llamado <code>[_1]</code> dentro del directorio de su blog.', # Translate - New (28)
    'That action ([_1]) is apparently not implemented!' => '¡La acción ([_1]) aparentemente no está implementada!',
    'That action ([_1]) is apparently not implemented?' => '¿La acción ([_1]) aparentemente no está implementada?', # Translate - New (7)
    'Error saving entry: [_1]' => 'Error guardando entrada: [_1]',
    'Select Blog' => 'Seleccione blog', # Translate - New (2)
    'Selected Blog' => 'Blog seleccionado', # Translate - New (2)
    'Type a blog name to filter the choices below.' => 'Introduzca un nombre de blog para filtrar las opciones de abajo.', # Translate - New (9)
    'Blog Name' => 'Nombre del blog',
    'Select a System Administrator' => 'Seleccione un Administrador del Sistema', # Translate - New (4)
    'Selected System Administrator' => 'Administrador del Sistema seleccionado', # Translate - New (3)
    'Type a user name to filter the choices below.' => 'Introduzca un nombre de usuario para filtrar las opciones de abajo.', # Translate - New (9)
    'System Administrator' => 'Administrador del sistema',
    'Error saving file: [_1]' => 'Error guardando fichero: [_1]', # Translate - New (4)
    'represents a user who will be created afterwards' => 'representa un usuario que se creará después', # Translate - New (8)
    'Select Blogs' => 'Seleccione blogs', # Translate - New (2)
    'Blogs Selected' => 'Blogs seleccionado', # Translate - New (2)
    'Group Name' => 'Nombre del grupo',
    'Select Roles' => 'Seleccionar roles',
    'Role Name' => 'Nombre del rol',
    'Roles Selected' => 'Roles seleccionados',
    'Create an Association' => 'Crear una asociación',
    'Backup & Restore' => 'Copias de seguridad', # Translate - New (2)
    'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.' => 'Debe poderse escribir en el directorio temporal para que las copias de seguridad funcionen correctamente. Por favor, compruebe la opción de configuración TempDir.', # Translate - New (16)
    'Temporary directory needs to be writable for restore to work correctly.  Please check TempDir configuration directive.' => 'Debe poder escribirse en el directorio temporal para que las copias de seguridad funcionen correctamente. Por favor, compruebe la opción de configuración TempDir.', # Translate - New (16)
    'Blog(s) (ID:[_1]) was/were successfully backed up by user \'[_2]\'' => 'Las copias de seguridad de el/los blog(s) (ID:[_1]) se hizo/hicieron correctamente por el usuario  \'[_2]\'', # Translate - New (12)
    'Movable Type system was successfully backed up by user \'[_1]\'' => 'El usuario \'[_1]\' realizó con éxito una copia de seguridad del sistema de Movable Type', # Translate - New (10)
    'You must select what you want to backup.' => 'Debe seleccionar de qué desea hacer una copia de seguridad.', # Translate - New (8)
    '[_1] is not a number.' => '[_1] no es un número.', # Translate - New (6)
    'Choose blogs to backup.' => 'Seleccione de qué blogs desea hacer la copia de seguridad.', # Translate - New (4)
    'Archive::Tar is required to archive in tar.gz format.' => 'Archive::Tar es necesario para archivar en el formato tar.gz.', # Translate - New (10)
    'IO::Compress::Gzip is required to archive in tar.gz format.' => 'IO::Compress::Gzip es necesario para archivar en el formato tar.gz.', # Translate - New (11)
    'Archive::Zip is required to archive in zip format.' => 'Archive::Zip es necesario para archivar en formato zip.', # Translate - New (9)
    'Specified file was not found.' => 'No se encontró el fichero especificado.', # Translate - New (5)
    '[_1] successfully downloaded backup file ([_2])' => '[_1] descargó con éxito el fichero de copia de seguridad ([_2])', # Translate - New (7)
    'Restore' => 'Restaurar', # Translate - New (1)
    'Required modules (Archive::Tar and/or IO::Uncompress::Gunzip) are missing.' => 'No se encuentran los módulos necesarios (Archive::Tar y/o IO::Uncompress::Gunzip).', # Translate - New (11)
    'Uploaded file was invalid: [_1]' => 'El fichero transferido es inválido: [_1]', # Translate - New (5)
    'Required module (Archive::Zip) is missing.' => 'No se encuentra el módulo requerido (Archive::Zip).', # Translate - New (6)
    'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Por favor, use xml, tar.gz, zip, o manifest como extensión de ficheros.', # Translate - New (12)
    'Some [_1] were not restored because their parent objects were not restored.' => 'Algunos [_1] no se restauraron porque sus objetos ascendentes no se restauraron.', # Translate - New (12)
    'Successfully restored objects to Movable Type system by user \'[_1]\'' => 'El usuario \'[_1]\' restauró objetos en el sistema Movable Type con éxito.', # Translate - New (10)
    '[_1] is not a directory.' => '[_1] no es un directorio.', # Translate - New (6)
    'Error occured during restore process.' => 'Ocurrió un error durante el proceso de restauración.', # Translate - New (5)
    'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ', # Translate - New (3)
    'Some of files could not be restored.' => 'Algunos ficheros no se restauraron.', # Translate - New (7)
    'Uploaded file was not a valid Movable Type backup manifest file.' => 'El fichero transferido no era un fichero no válido de manifiesto de copia de seguridad de Movable Type.', # Translate - New (11)
    'Please upload [_1] in this page.' => 'Por favor, transfiera [_1] a esta página.', # Translate - New (6)
    'File was not uploaded.' => 'El fichero no fue transferido.', # Translate - New (4)
    'Restoring a file failed: ' => 'Falló la restauración de un fichero:', # Translate - New (4)
    'Some objects were not restored because their parent objects were not restored.' => 'Algunos objetos no se restauraron porque sus objetos ascendentes tampoco fueron restaurados.', # Translate - New (12)
    'Some of the files were not restored correctly.' => 'No se restauraron correctamente algunos de los ficheros.', # Translate - New (8)
    '[_1] has canceled the multiple files restore operation prematurely.' => '[_1] canceló prematuramente la operación de restauración de varios ficheros.', # Translate - New (10)
    'Changing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Modificando la Ruta del Sitio del blog \'[_1]\' (ID:[_2])...', # Translate - New (9)
    'Removing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Borrando la Ruta del Sitio del blog \'[_1]\' (ID:[_2])...', # Translate - New (9)
    '\nChanging Archive Path for the blog \'[_1]\' (ID:[_2])...' => '\nModificando la Ruta de Archivado del blog \'[_1]\' (ID:[_2])...', # Translate - New (10)
    '\nRemoving Archive Path for the blog \'[_1]\' (ID:[_2])...' => '\nBorrando la Ruta de Archivado del blog \'[_1]\' (ID:[_2])...', # Translate - New (10)
    'Some of the actual files for assets could not be restored.' => 'No se pudieron restaurar algunos ficheros de elementos.', # Translate - New (11)
    'Parent comment id was not specified.' => 'ID de comentario padre no se especificó.', # Translate - New (6)
    'Parent comment was not found.' => 'El comentario padre no se encontró.', # Translate - New (5)
    'You can\'t reply to unapproved comment.' => 'No puede responder a un comentario no aprobado.', # Translate - New (7)
    'entries' => 'entradas',

    ## ./lib/MT/App/Comments.pm
    'Error assigning commenting rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable commenting role was found.' => 'Error asignando permisos para comentar al usuario \'[_1] (ID: [_2])\' para el weblog \'[_3] (ID: [_4])\'. No se encontró un rol adecuado.', # Translate - New (20)
    'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Intento de identificación de comentarista no válido desde [_1] en el blog [_2](ID: [_3]) que no permite la autentificación nativa de Movable Type.', # Translate - New (19)
    'Login failed: permission denied for user \'[_1]\'' => 'Falló la identificación: permiso denegado al usuario \'[_1]\'', # Translate - New (7)
    'Login failed: password was wrong for user \'[_1]\'' => 'Falló la identificación: contraseña errónea del usuario \'[_1]\'', # Translate - New (8)
    'Signing up is not allowed.' => 'No está permitida la inscripción.', # Translate - New (5)
    'Passwords do not match.' => 'Las contraseñas no coinciden.',
    'User requires username.' => 'El usuario necesita un nombre.', # Translate - New (3)
    'User requires display name.' => 'El usuario necesita un pseudónimo.', # Translate - New (4)
    'User requires password.' => 'El usuario necesita una contraseña.', # Translate - New (3)
    'User requires password recovery word/phrase.' => 'El usuario necesita una palabra/frase para la recuperación de contraseña.', # Translate - New (6)
    'Email Address is invalid.' => 'La dirección de correo no es válida.', # Translate - New (4)
    'Email Address is required for password recovery.' => 'La dirección de correo es necesaria para la recuperación de contraseña.', # Translate - New (7)
    'URL is invalid.' => 'La URL no es válida.', # Translate - New (3)
    'Text entered was wrong.  Try again.' => 'El texto que introdujo es erróneo. Inténtelo de nuevo.', # Translate - New (6)
    'Something wrong happened when trying to process signup: [_1]' => 'Algo mal ocurrió durante el proceso de alta: [_1]', # Translate - New (9)
    'Movable Type Account Confirmation' => 'Confirmación de cuenta - Movable Type', # Translate - New (4)
    'System Email Address is not configured.' => 'La dirección de correo del sistema no está configurada.', # Translate - New (6)
    'Commenter \'[_1]\' (ID:[_2]) has been successfully registered.' => 'El comentarista \'[_1]\' (ID:[_2]) se inscribió con éxito.', # Translate - New (8)
    'Thanks for the confirmation.  Please sign in to comment.' => 'Gracias por la confirmación. Por favor, identifíquese para comentar.', # Translate - New (9)
    '[_1] registered to the blog \'[_2]\'' => '[_1] se registró en el blog \'[_2]\'', # Translate - New (7)
    'No id' => 'Sin id',
    'No such comment' => 'No existe dicho comentario',
    'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] bloqueada porque excedió el ritmo de comentarios, más de 8 en [_2] segundos.',
    'IP Banned Due to Excessive Comments' => 'IP bloqueada debido al exceso de comentarios',
    'No such entry \'[_1]\'.' => 'No existe la entrada \'[_1]\'.',
    'You are not allowed to add comments.' => 'No tiene permisos para añadir comentarios.', # Translate - New (7)
    'Comments are not allowed on this entry.' => 'No se permiten comentarios en esta entrada.',
    'Comment text is required.' => 'El texto del comentario es obligatorio.',
    'An error occurred: [_1]' => 'Ocurrió un error: [_1]',
    'Registration is required.' => 'El registro es obligatorio.',
    'Name and email address are required.' => 'El nombre y la dirección de correo-e son obligatorios.',
    'Invalid email address \'[_1]\'' => 'Dirección de correo-e no válida \'[_1]\'',
    'Invalid URL \'[_1]\'' => 'URL no válida \'[_1]\'',
    'Comment save failed with [_1]' => 'Fallo guardando comentario con [_1]',
    'Comment on "[_1]" by [_2].' => 'Comentario en "[_1]" por [_2].',
    'Commenter save failed with [_1]' => 'Fallo guardando comentarista con [_1]',
    'Rebuild failed: [_1]' => 'Falló la reconstrucción: [_1]',
    'You must define a Comment Pending template.' => 'Debe definir una plantilla de comentarios pendiente.',
    'Failed comment attempt by pending registrant \'[_1]\'' => 'Falló el intento de comentar por el comentarista pendiente \'[_1]\'', # Translate - New (7)
    'Registered User' => 'Usuario registrado', # Translate - New (2)
    'New Comment Added to \'[_1]\'' => 'Nuevo comentario añadido en \'[_1]\'', # Translate - New (5)
    'The sign-in attempt was not successful; please try again.' => 'El intento de registro no tuvo éxito; por favor, inténtelo de nuevo.',
    'The sign-in validation was not successful. Please make sure your weblog is properly configured and try again.' => 'La validación del registro no tuvo éxito. Por favor, asegúrese de que su weblog está configurado correctamente e inténtelo de nuevo.',
    'No such entry ID \'[_1]\'' => 'No existe el ID de entrada \'[_1]\'',
    'You must define an Individual template in order to ' => 'Debe definir una plantilla individual para  ',
    'You must define a Comment Listing template in order to ' => 'Debe definir una plantilla de listado de comentarios para ',
    'No entry was specified; perhaps there is a template problem?' => 'No se especificó ninguna entrada; ¿quizás hay un problema con la plantilla?',
    'Somehow, the entry you tried to comment on does not exist' => 'De alguna manera, la entrada en la que intentó comentar no existe',
    'You must define a Comment Error template.' => 'Debe definir una plantilla de error de comentarios.',
    'You must define a Comment Preview template.' => 'Debe definir una plantilla de vista previa de comentarios.',
    'Invalid commenter ID' => 'ID de comentarista no válido', # Translate - New (3)
    'Permission denied' => 'Permiso denegado',
    'All required fields must have valid values.' => 'Todos los campos obligatorios deben tener valores válidos.', # Translate - New (7)
    'Commenter profile has successfully been updated.' => 'Se actualizó con éxito el perfil del comentarista.', # Translate - New (6)
    'Commenter profile could not be updated: [_1]' => 'No se pudo actualizar el perfil del comentarista: [_1]', # Translate - New (7)
    'You can\'t reply to unpublished comment.' => 'No puede contestar a comentarios no publicados.', # Translate - New (7)
    'Your session has been ended.  Cancel the dialog and login again.' => 'Ha finalizado su sesión. Cancele el diálogo e identifíquese nuevamente.', # Translate - New (11)
    'Comment Detail' => 'Detalle del comentario', # Translate - New (2)

    ## ./lib/MT/App/NotifyList.pm
    'Please enter a valid email address.' => 'Por favor, teclee una dirección de correo válida.',
    'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Falta parámetro obligatorio: blog_id. Por favor, consulte el manual de usuario para configurar las notificaciones.',
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

    ## ./lib/MT/App/Trackback.pm
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

    ## ./lib/MT/App/Upgrader.pm
    'The initial account name is required.' => 'Se necesita el nombre de la cuenta inicial.',
    'Failed to authenticate using given credentials: [_1].' => 'Fallo al autentificar con las credenciales ofrecidas: [_1].',
    'You failed to validate your password.' => 'Falló al validar la contraseña.',
    'You failed to supply a password.' => 'No introdujo una contraseña.',
    'The e-mail address is required.' => 'La dirección de correo electrónico es necesaria.',
    'Password recovery word/phrase is required.' => 'Se necesita la palabra/frase de recuperación de contraseña.',
    'Invalid session.' => 'Sesión no válida.',
    'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Sin permisos. Por favor, contacte con su administrador para la actualización de Movable Type.',

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

    ## ./lib/MT/App/Wizard.pm
    'The [_1] database driver is required to use [_2].' => 'Es necesario el controlador de la base de datos [_1] para usar [_2].', # Translate - New (9)
    'The [_1] driver is required to use [_2].' => 'Es necesario el controlador [_1] para usar [_2].', # Translate - New (8)
    'An error occurred while attempting to connect to the database.  Check the settings and try again.' => 'Ocurrió un error intentando conectar a la base de datos. Compruebe la configuración e inténtalo de nuevo.', # Translate - New (16)
    'SMTP Server' => 'Servidor SMTP',
    'Sendmail' => 'Sendmail', # Translate - Previous (1)
    'Test email from Movable Type Configuration Wizard' => 'Mensaje de comprobación del asistente de configuración de Movable Type',
    'This is the test email sent by your new installation of Movable Type.' => 'Este es el mensaje de comprobación enviado por su nueva instalación de Movable Type.',

    ## ./lib/MT/Asset/Image.pm
    'Image' => 'Imagen', # Translate - New (1)
    'Images' => 'Imágenes', # Translate - New (1)
    'Actual Dimensions' => 'Tamaño actual', # Translate - New (2)
    '[_1] wide, [_2] high' => '[_1] ancho, [_2] alto', # Translate - New (5)
    'Error scaling image: [_1]' => 'Error redimensionando la imagen: [_1]', # Translate - New (4)
    'Error creating thumbnail file: [_1]' => 'Error creando el fichero de la miniatura: [_1]', # Translate - New (5)
    'Can\'t load image #[_1]' => 'No se pudo cargar la imagen nº[_1]', # Translate - New (5)
    'View image' => 'Ver imagen',
    'Permission denied setting image defaults for blog #[_1]' => 'Se denegó el permiso para cambiar las opciones predefinidos de imágenes del blog nº[_1]', # Translate - New (8)
    'Thumbnail failed: [_1]' => 'Fallo vista previa: [_1]',
    'Invalid basename \'[_1]\'' => 'Nombre base no válido \'[_1]\'',
    'Error writing to \'[_1]\': [_2]' => 'Error escribiendo en \'[_1]\': [_2]',

    ## ./lib/MT/Auth/BasicAuth.pm

    ## ./lib/MT/Auth/LiveJournal.pm

    ## ./lib/MT/Auth/MT.pm
    'Failed to verify current password.' => 'Fallo al verificar la contraseña actual.',
    'Password hint is required.' => 'Se necesita la pista de contraseña.',

    ## ./lib/MT/Auth/OpenID.pm
    'Could not discover claimed identity: [_1]' => 'No se pudo comprobar la identidad: [_1]', # Translate - New (6)

    ## ./lib/MT/Auth/TypeKey.pm
    'Sign in requires a secure signature.' => 'La identificación necesita una firma segura.', # Translate - New (6)
    'The sign-in validation failed.' => 'Falló el registro de validación.',
    'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Este weblog obliga a que los comentaristas den su dirección de correo electrónico. Si lo desea puede iniciar una sesión de nuevo, y dar al servicio de autentificación permisos para pasar la dirección de correo electrónico.',
    'This weblog requires commenters to pass an email address' => 'Este weblog necesita que los comentaristas den su dirección de correo electrónico',
    'Couldn\'t get public key from url provided' => 'No se pudo obtener la clave pública desde la URL indicada',
    'No public key could be found to validate registration.' => 'No se encontró la clave pública para validar el registro.',
    'TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'La firma TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]',
    'The TypeKey signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'La firma TypeKey está caducada ([_1] segundos vieja). Asegúrese de que el reloj de su servidor está en hora',

    ## ./lib/MT/Auth/Vox.pm

    ## ./lib/MT/BackupRestore/BackupFileHandler.pm
    'Uploaded file was backed up from Movable Type with the newer schema version ([_1]) than the one in this system ([_2]).  It is not safe to restore the file to this version of Movable Type.' => 'Se hizo una copia de segurodad del fichero transferido desde Movable Type con una versión más reciente del esquema ([_1]) que el de este sistema ([_2]). No es seguro restaurar el fichero en esta versión de Movable Type.', # Translate - New (35)
    '[_1] is not a subject to be restored by Movable Type.' => '[_1] no es un elemento para ser restaurado por Movable Type.', # Translate - New (12)
    '[_1] records restored.' => '[_1] registros restaurados.', # Translate - New (4)
    'Restoring [_1] records:' => 'Restaurando [_1] registros:', # Translate - New (3)
    'User with the same name \'[_1]\' found (ID:[_2]).  Restore replaced this user with the data backed up.' => 'Se encontró un usuario con el mismo nombre \'[_1]\' (ID:[_2]). La restauración reemplazó este usuario con los datos de la copia de seguridad.', # Translate - New (18)
    'Tag \'[_1]\' exists in the system.\n' => 'La etiqueta \'[_1]\' existe en el sistema.\n', # Translate - New (7)
    'Trackback for entry (ID: [_1]) already exists in the system.\n' => 'Ya existe en el sistema el Trackback para la entrada (ID: [_1]).\n', # Translate - New (11)
    'Trackback for category (ID: [_1]) already exists in the system.\n' => 'Ya existe en el sistema el Trackback para la categoría (ID: [_1]).\n', # Translate - New (11)
    '[_1] records restored...' => '[_1] registros restaurados...', # Translate - New (4)

    ## ./lib/MT/BackupRestore/ManifestFileHandler.pm

    ## ./lib/MT/Compat/v3.pm
    'uses: [_1], should use: [_2]' => 'usa: [_1], debería usar: [_2]', # Translate - New (5)
    'uses [_1]' => 'usa [_1]', # Translate - New (2)
    'No executable code' => 'No es código ejecutable',
    'Rebuild-option name must not contain special characters' => 'El nombre de la opción de reconstrucción no debe contener caracteres espaciales',

    ## ./lib/MT/FileMgr/DAV.pm
    'DAV connection failed: [_1]' => 'Falló la conexión DAV: [_1]',
    'DAV open failed: [_1]' => 'Falló la orden \'open\' en el DAV: [_1]',
    'DAV get failed: [_1]' => 'Falló la orden \'get\' en el DAV: [_1]',
    'DAV put failed: [_1]' => 'Falló la orden \'put\' en el DAV: [_1]',
    'Deleting \'[_1]\' failed: [_2]' => 'Fallo borrando \'[_1]\': [_2]',
    'Creating path \'[_1]\' failed: [_2]' => 'Fallo creando la ruta \'[_1]\': [_2]',
    'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Fallo renombrando \'[_1]\' a \'[_2]\': [_3]',

    ## ./lib/MT/FileMgr/FTP.pm

    ## ./lib/MT/FileMgr/Local.pm

    ## ./lib/MT/FileMgr/SFTP.pm
    'SFTP connection failed: [_1]' => 'Fallo en la conexión SFTP: [_1]',
    'SFTP get failed: [_1]' => 'Falló la orden \'get\' en el SFTP: [_1]',
    'SFTP put failed: [_1]' => 'Falló la orden \'put\' en el SFTP: [_1]',

    ## ./lib/MT/I18N/default.pm

    ## ./lib/MT/I18N/en_us.pm

    ## ./lib/MT/I18N/ja.pm

    ## ./lib/MT/L10N/de.pm

    ## ./lib/MT/L10N/en_us.pm

    ## ./lib/MT/L10N/es.pm

    ## ./lib/MT/L10N/fr.pm

    ## ./lib/MT/L10N/ja.pm

    ## ./lib/MT/L10N/nl.pm

    ## ./lib/MT/ObjectDriver/DDL.pm

    ## ./lib/MT/ObjectDriver/SQL.pm

    ## ./lib/MT/ObjectDriver/DDL/mysql.pm

    ## ./lib/MT/ObjectDriver/DDL/Pg.pm

    ## ./lib/MT/ObjectDriver/DDL/SQLite.pm

    ## ./lib/MT/ObjectDriver/Driver/DBI.pm

    ## ./lib/MT/ObjectDriver/Driver/DBD/Legacy.pm

    ## ./lib/MT/ObjectDriver/Driver/DBD/mysql.pm

    ## ./lib/MT/ObjectDriver/Driver/DBD/Pg.pm

    ## ./lib/MT/ObjectDriver/Driver/DBD/SQLite.pm

    ## ./lib/MT/ObjectDriver/SQL/mysql.pm

    ## ./lib/MT/ObjectDriver/SQL/Pg.pm

    ## ./lib/MT/ObjectDriver/SQL/SQLite.pm

    ## ./lib/MT/Plugin/JunkFilter.pm
    'from rule' => 'desde la regla',
    'from test' => 'desde el test',

    ## ./lib/MT/Plugin/L10N.pm

    ## ./lib/MT/Template/Context.pm
    'The attribute exclude_blogs cannot take \'all\' for a value.' => 'El atributo exclude_blogs no puede tomar el valor \'all\'.',

    ## ./lib/MT/Template/ContextHandlers.pm
    'Recursion attempt on [_1]: [_2]' => 'Intento de recursión en [_1]: [_2]', # Translate - New (5)
    'Can\'t find included template [_1] \'[_2]\'' => 'No se encontró la plantilla incluída [_1] \'[_2]\'', # Translate - New (7)
    'Can\'t find blog for id \'[_1]' => 'No se pudo encontrar un blog con el id \'[_1]',
    'Can\'t find included file \'[_1]\'' => 'No se encontró el fichero incluido \'[_1]\'',
    'Error opening included file \'[_1]\': [_2]' => 'Error abriendo el fichero incluido \'[_1]\': [_2]',
    'Recursion attempt on file: [_1]' => 'Intento de recursión en fichero: [_1]', # Translate - New (5)
    'Unspecified archive template' => 'Archivo de plantilla no especificado',
    'Error in file template: [_1]' => 'Error en fichero de plantilla: [_1]',
    'Can\'t load template' => 'No se pudo cargar la plantilla', # Translate - New (4)
    'Can\'t find template \'[_1]\'' => 'No se encontró la plantilla \'[_1]\'',
    'Can\'t find entry \'[_1]\'' => 'No se encontró la entrada \'[_1]\'',
    '[_1] [_2]' => '[_1] [_2]', # Translate - Previous (3)
    'You used a [_1] tag without any arguments.' => 'Usó una etiqueta [_1] sin ningún parámetro.',
    'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" debe usarse en combinación con el espacio de nombres.', # Translate - New (10)
    'You have an error in your \'[_2]\' attribute: [_1]' => 'Tiene un error en su atributo \'[_2]\': [_1]', # Translate - New (9)
    'You have an error in your \'tag\' attribute: [_1]' => 'Tiene un error en el atributo \'tag\': [_1]',
    'No such user \'[_1]\'' => 'No existe el usario \'[_1]\'',
    'You used an \'[_1]\' tag outside of the context of an entry; ' => 'Usó una etiqueta \'[_1]\' fuera del contexto de una entrada; ',
    'You used <$MTEntryFlag$> without a flag.' => 'Usó <$MTEntryFlag$> sin \'flag\'.',
    'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Usó una etiqueta [_1] enlazando los archivos \'[_2]\', pero el tipo de archivo no está publicado.',
    'Could not create atom id for entry [_1]' => 'No se pudo crear un identificador atom en la entrada [_1]',
    'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'La autentificación en TypeKey no está habilitada en este blog. No se puede usar MTRemoteSignInLink.', # Translate - New (13)
    'To enable comment registration, you need to add a TypeKey token in your weblog config or user profile.' => 'Para habilitar el registro de comentarios, debe añadir un token de TypeKey a la configuración de su weblog o al perfil de su usario.',
    '(You may use HTML tags for style)' => '(Puede usar etiquetas HTML para el estilo)',
    'You used an [_1] tag without a date context set up.' => 'Usó una etiqueta [_1] sin un contexto de fecha configurado.',
    'You used an \'[_1]\' tag outside of the context of a comment; ' => 'Usó una etiqueta \'[_1]\' fuera del contexto de un comentario; ',
    'You used an [_1] without a date context set up.' => 'Usó un [_1] sin una fecha de contexto configurada.',
    '[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] sólo se puede usar con los archivos diarios, semanales o mensuales.',
    'Group iterator failed.' => 'Fallo en iterador de grupo.',
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly ' => 'Usó una etiqueta [_1] fuera de Diario, Semanal, o Mensual ',
    'Could not determine entry' => 'No se pudo determinar la entrada',
    'Invalid month format: must be YYYYMM' => 'Formato de mes no válido: debe ser YYYYMM',
    'No such category \'[_1]\'' => 'No existe la categoría \'[_1]\'',
    '<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> debe utilizarse en el contexto de una categoría, o con el atributo \'category\' en la etiqueta.',
    'You failed to specify the label attribute for the [_1] tag.' => 'No especificó el atributo título en la etiqueta [_1].',
    'You used an \'[_1]\' tag outside of the context of ' => 'Utilizó la etiqueta \'[_1]\' fuera del contexto de ',
    'MTSubCatsRecurse used outside of MTSubCategories' => 'MTSubCatsRecurse utilizado fuera de MTSubCategories',
    'MTSubFolderRecurse used outside of MTSubFolders' => 'MTSubFolderRecurse utilizado fuera de MTSubFolders', # Translate - New (5)
    'MT[_1] must be used in a [_2] context' => 'MT[_1] debe utilizarse en el contexto de [_2]', # Translate - New (9)
    'Cannot find package [_1]: [_2]' => 'No se encontró el paquete [_1]: [_2]',
    'Error sorting [_2]: [_1]' => 'Error ordenando [_2]: [_1]', # Translate - New (4)
    'You used an \'[_1]\' tag outside of the context of an asset; ' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de un elemento:', # Translate - New (12)
    'You used an \'[_1]\' tag outside of the context of an page; ' => 'Utilizó una etiqueta \'[_1]\' fuera del contexto de una página: ', # Translate - New (12)
    'You used an [_1] without a author context set up.' => 'Utilizó un [_1] sin establecer un contexto de autor.', # Translate - New (10)
    'Can\'t load blog.' => 'No se pudo cargar el blog.', # Translate - New (4)
    'Can\'t load user.' => 'No se pudor cargar el usuario.', # Translate - New (4)

    ## ./lib/MT/Util/Captcha.pm
    'Captcha' => 'Captcha', # Translate - New (1)
    'Type the characters you see in the picture above.' => 'Introduzca los caracteres que ve en la imagen de arriba.', # Translate - New (9)
    'You need to configure CaptchaSourceImagebase.' => 'Debe configurar CaptchaSourceImagebase.', # Translate - New (5)
    'Image creation failed.' => 'Falló la creación de la imagen.', # Translate - New (3)
    'Image error: [_1]' => 'Error de imagen: [_1]', # Translate - New (3)

    ## ./mt-static/mt.js
    'to delete' => 'para borrar',
    'to remove' => 'para borrar',
    'to enable' => 'para habilitar',
    'to disable' => 'para deshabilitar',
    'delete' => 'borrar',
    'remove' => 'borrar',
    'You did not select any [_1] to [_2].' => 'No seleccionó ningún [_1] para [_2].',
    'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => '¿Está seguro de que desea borrar este rol? Al hacerlo, eliminará los permisos actualmente asignados a cualquier usuario o grupo relacionados con este rol.',
    'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => '¿Está seguro de que desea borrar estos [_1] roles? Al hacerlo, eliminará los permisos actualmente asignados a cualquier usuario o grupo relacionados con estos roles.',
    'Are you sure you want to [_2] this [_1]?' => '¿Está seguro de que desea [_2] este [_1]?',
    'Are you sure you want to [_3] the [_1] selected [_2]?' => '¿Está seguro de que desea [_3] el/los [_1] seleccionado/s [_2]?',
    'to ' => 'a ',
    'You did not select any [_1] to remove.' => 'No seleccionó ningún [_1] para borrar.',
    'Are you sure you want to remove this [_1] from this group?' => '¿Está seguro de que desea borrar [_1] de este grupo?',
    'Are you sure you want to remove the [_1] selected [_2] from this group?' => '¿Está seguro de que desea borrar el/los [_1] seleccionado/s [_2] de este grupo?',
    'Are you sure you want to remove this [_1]?' => '¿Está seguro de que desea borrar este [_1]?',
    'Are you sure you want to remove the [_1] selected [_2]?' => '¿Está seguro de que desea borrar el/los [_1] seleccionado/s [_2]?',
    'enable' => 'habilitar',
    'disable' => 'deshabilitar',
    'You did not select any [_1] [_2].' => 'No seleccionó ningún [_1] [_2].',
    'You can only act upon a minimum of [_1] [_2].' => 'Solo puede actuar sobre un mínimo de [_1] [_2].',
    'You can only act upon a maximum of [_1] [_2].' => 'Solo puede actuar sobre un máximo de [_1] [_2].',
    'You must select an action.' => 'Debe seleccionar una acción.',
    'to mark as junk' => 'para marcar como basura',
    'to remove "junk" status' => 'para eliminar el estado "basura"',
    'Enter email address:' => 'Teclee la dirección de correo-e:',
    'Enter URL:' => 'Teclee la URL:',
    'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\'?' => 'La etiqueta \'[_2]\' ya existe. ¿Está seguro de que desea integrar \'[_1]\' y \'[_2]\'?',
    'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all weblogs?' => 'La etiqueta \'[_2]\' ya existe. ¿Está seguro de que desea integrar \'[_1]\' y \'[_2]\' en todos los weblogs?',
    'Showing: [_1] &ndash; [_2] of [_3]' => 'Mostrando: [_1] &ndash; [_2] de [_3]',
    'Showing: [_1] &ndash; [_2]' => 'Mostrando: [_1] &ndash; [_2]',

    ## ./plugins/Cloner/cloner.pl
    'No weblog was selected to clone.' => 'No se ha seleccionado un weblog para clonar.',
    'This action can only be run for a single weblog at a time.' => 'Esta acción solo puede realizarse en un weblog a la vez.',
    'Invalid blog_id' => 'blog_id no válido',

    ## ./plugins/ExtensibleArchives/AuthorArchive.pl
    'Author #[_1]' => 'Autor nº[_1]', # Translate - New (2)
    'AUTHOR_ADV' => 'AUTHOR_ADV', # Translate - New (2)
    'Author #[_1]: ' => 'Autor nº[_1]: ', # Translate - New (2)
    'AUTHOR-YEARLY_ADV' => 'AUTHOR-YEARLY_ADV', # Translate - New (2)
    'AUTHOR-MONTHLY_ADV' => 'AUTHOR-MONTHLY_ADV', # Translate - New (2)
    'AUTHOR-WEEKLY_ADV' => 'AUTHOR-WEEKLY_ADV', # Translate - New (2)
    'AUTHOR-DAILY_ADV' => 'AUTHOR-DAILY_ADV', # Translate - New (2)

    ## ./plugins/ExtensibleArchives/DatebasedCategories.pl
    'CATEGORY-YEARLY_ADV' => 'CATEGORY-YEARLY_ADV', # Translate - New (2)
    'CATEGORY-MONTHLY_ADV' => 'CATEGORY-MONTHLY_ADV', # Translate - New (2)
    'CATEGORY-DAILY_ADV' => 'CATEGORY-DAILY_ADV', # Translate - New (2)
    'CATEGORY-WEEKLY_ADV' => 'CATEGORY-WEEKLY_ADV', # Translate - New (2)

    ## ./plugins/ExtensibleArchives/lib/AuthorArchive/L10N.pm

    ## ./plugins/ExtensibleArchives/lib/AuthorArchive/L10N/en_us.pm

    ## ./plugins/ExtensibleArchives/lib/AuthorArchive/L10N/ja.pm

    ## ./plugins/ExtensibleArchives/lib/DatebasedCategoriesArchive/L10N.pm

    ## ./plugins/ExtensibleArchives/lib/DatebasedCategoriesArchive/L10N/en_us.pm

    ## ./plugins/ExtensibleArchives/lib/DatebasedCategoriesArchive/L10N/ja.pm

    ## ./plugins/feeds-app-lite/mt-feeds.pl
    '\'[_1]\' is a required argument of [_2]' => '\'[_1]\' es un argumento necesario de [_2]',
    'MT[_1] was not used in the proper context.' => 'MT[_1] no se está utilizando en el contexto adecuado.',

    ## ./plugins/feeds-app-lite/lib/MT/App/FeedsWidget.pm

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Find.pm

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Lite.pm
    'An error occurred processing [_1]. ' => 'Ocurrió un error procesando [_1]. ',

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Lite/CacheMgr.pm

    ## ./plugins/GoogleSearch/GoogleSearch.pl
    'You used [_1] without a query.' => 'Utilizó [_1] sin una consulta.',
    'You need a Google API key to use [_1]' => 'Necesita una clave de Google API para utilizar [_1]',
    'You used a non-existent property from the result structure.' => 'Utilizó una propiedad inexistente de la estructura de resultados.',

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/de.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/en_us.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/es.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/fr.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/ja.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/nl.pm

    ## ./plugins/Markdown/Markdown.pl

    ## ./plugins/Markdown/SmartyPants.pl

    ## ./plugins/MultiBlog/multiblog.pl
    '* All Weblogs' => '* Todos los weblogs',
    'Select to apply this trigger to all weblogs' => 'Selecciónelo para aplicar este disparador a todos los weblogs',
    'MultiBlog' => 'MultiBlog', # Translate - Previous (1)
    'Create New Trigger' => 'Crear nuevo disparador',
    'Weblog Name' => 'Nombre del weblog',
    'Search Weblogs' => 'Buscar Weblogs',
    'When this' => 'Cuando',
    'saves an entry' => 'guarda una entrada',
    'publishes an entry' => 'publica una entrada',
    'publishes a comment' => 'publica un comentario',
    'publishes a ping' => 'publica un ping',
    'rebuild indexes.' => 'construye índices.',
    'rebuild indexes and send pings.' => 'reconstruye índices y envía pings.',

    ## ./plugins/MultiBlog/lib/MultiBlog.pm
    'The include_blogs, exclude_blogs, blog_ids and blog_id attributes cannot be used together.' => 'Los atributos include_blogs, exclude_blogs, blog_ids y blog_id no se pueden usar juntos.',
    'The attribute exclude_blogs cannot take "all" for a value.' => 'El atributo exclude_blogs no puede tomar el valor  "all".',
    'The value of the blog_id attribute must be a single blog ID.' => 'El valor del atributo blog_id debe ser un solo ID de blog.',
    'The value for the include_blogs/exclude_blogs attributes must be one or more blog IDs, separated by commas.' => 'El valor de los atributos include_blogs/exclude_blogs debe ser uno o más IDs de blogs, separados por comas.',

    ## ./plugins/MultiBlog/lib/MultiBlog/L10N.pm

    ## ./plugins/MultiBlog/lib/MultiBlog/Tags.pm

    ## ./plugins/MultiBlog/lib/MultiBlog/L10N/en_us.pm

    ## ./plugins/MultiBlog/lib/MultiBlog/L10N/ja.pm

    ## ./plugins/MultiBlog/lib/MultiBlog/Tags/LocalBlog.pm

    ## ./plugins/MultiBlog/lib/MultiBlog/Tags/MultiBlog.pm
    'MTMultiBlog tags cannot be nested.' => 'Las etiquetas MTMultiBlog no pueden anidarse.',
    'Unknown "mode" attribute value: [_1]. ' => 'Valor desconocido de atributo "mode": [_1]. ',

    ## ./plugins/spamlookup/spamlookup.pl

    ## ./plugins/spamlookup/spamlookup_urls.pl

    ## ./plugins/spamlookup/spamlookup_words.pl

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

    ## ./plugins/StyleCatcher/stylecatcher.pl
    'Unable to create the theme root directory. Error: [_1]' => 'No se pudo crear el directorio raíz de temas. Error: [_1]',
    'Unable to write base-weblog.css to themeroot. File Manager gave the error: [_1]. Are you sure your theme root directory is web-server writable?' => 'No se pudo escribir base-weblog.css en el directorio raíz de temas. El Administrador de Ficheros dio el error: [_1]. ¿Está seguro de que el servidor web tiene permisos para escribir en el directorio raíz de temas?',

    ## ./plugins/StyleCatcher/lib/StyleCatcher.pm
    'StyleCatcher must first be configured system-wide before it can be used.' => 'Debe configurar StyleCatcher para todo el sistema antes de usarlo.',
    'Configure plugin' => 'Configurar extensión',
    'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'No se pudo crear el directorio [_1] - Compruebe que el servidor web puede escribir en la carpeta \'themes\'.',
    'Successfully applied new theme selection.' => 'Se aplicó con éxito la nueva selección de estilo.',

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/de.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/en_us.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/es.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/fr.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/ja.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/nl.pm

    ## ./plugins/TemplateRefresh/TemplateRefresh.pl
    'Error loading default templates.' => 'Error cargando las plantillas predefinidas.',
    'Insufficient permissions to modify templates for weblog \'[_1]\'' => 'Permisos insuficientes para modificar las plantillas del weblog \'[_1]\'',
    'Processing templates for weblog \'[_1]\'' => 'Procesando plantillas del weblog \'[_1]\'',
    'Refreshing template \'[_1]\'.' => 'Refrescando la plantilla \'[_1]\'.',
    'Error creating new template: ' => 'Error creando nueva plantilla: ',
    'Created template \'[_1]\'.' => 'Creada plantilla \'[_1]\'.',
    'Insufficient permissions for modifying templates for this weblog.' => 'Permisos insuficientes para modificar las plantillas de este weblog.',
    'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Ignorando plantilla \'[_1]\' ya que parecer ser una plantilla personalizada.',

    ## ./plugins/Textile/textile2.pl

    ## ./plugins/Textile/lib/Text/Textile.pm

    ## ./plugins/WidgetManager/WidgetManager.pl
    'Failed to find WidgetManager::Plugin::[_1]' => 'Fallo al buscar WidgetManager::Plugin::[_1]',

    ## ./plugins/WidgetManager/lib/WidgetManager/CMS.pm
    'Can\'t duplicate the existing \'[_1]\' Widget Manager. Please go back and enter a unique name.' => 'No se pudo duplicar el administrador de widgets existente \'[_1]\'. Por favor, regrese e introduzca un nombre único.',
    'Widget Manager' => 'Administrador de widgets',
    'Moving [_1] to list of installed modules' => 'Moviendo [_1] para listar los módulos instalados',
    'First Widget Manager' => 'Primer Administrador de Widgets',

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/Plugin.pm
    'No WidgetManager modules exist for blog \'[_1]\'.' => 'No existen módulos WidgetManager en el blog \'[_1]\'.', # Translate - New (7)
    'WidgetManager \'[_1]\' has no installed widgets.' => 'WidgetManager \'[_1]\' no tiene widgets instalados.', # Translate - New (6)
    'Can\'t find included template module \'[_1]\'' => 'No se encontró el módulo de plantilla incluido \'[_1]\'',

    ## ./plugins/WidgetManager/lib/WidgetManager/Util.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/de.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/en_us.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/es.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/fr.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/ja.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/nl.pm

    ## ./plugins/WXRImporter/WXRImporter.pl

    ## ./plugins/WXRImporter/lib/WXRImporter/Import.pm

    ## ./plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
    'File is not in WXR format.' => 'El fichero no está en el formato WX', # Translate - New (6)
    'Saving asset (\'[_1]\')...' => 'Guardando elemento (\'[_1]\')...', # Translate - New (3)
    ' and asset will be tagged (\'[_1]\')...' => ' y el elemento será etiquetado (\'[_1]\')...', # Translate - New (7)
    'Saving page (\'[_1]\')...' => 'Guardando página (\'[_1]\')...', # Translate - New (3)

    ## ./t/blog-common.pl

    ## ./t/driver-tests.pl

    ## ./t/test-common.pl

    ## ./t/lib/Bar.pm

    ## ./t/lib/Foo.pm

    ## ./t/lib/LWP/UserAgent/Local.pm

    ## ./t/lib/MT/Test.pm

    ## ./t/lib/Text/WikiFormat.pm

    ## ./t/plugins/testplug.pl
);


1;

## New words: 2368
