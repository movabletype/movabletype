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
    'The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements.' => 'The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements.', # Translate - New (20)
    'Your server has [_1] installed (version [_2]).' => 'Su servidor tiene [_1] instalado (versión [_2]).',
    'Movable Type System Check Successful' => 'Comprobación del sistema correcta.',
    'You\'re ready to go!' => '¡Todo listo para continuar!',
    'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Su servidor dispone de todos los módulos requeridos; no necesita instalar ningún módulo adicional. Puede continuar con las instrucciones de instalación.',

    ## ./search_templates/default.tmpl
    'Search Results' => 'Resultado de la búsqueda',
    'Subscribe to a feed of these results' => 'Subscribe to a feed of these results', # Translate - New (7)
    'Search this site:' => 'Buscar este sitio:',
    'Search' => 'Buscar',
    'Match case' => 'Distinguir mayúsculas',
    'Regex search' => 'Expresión regular',
    'Search Results from' => 'Buscar resultados de',
    'Posted in [_1] on [_2] by [_3]' => 'Posted in [_1] on [_2] by [_3]', # Translate - New (7)
    'Searched for' => 'Buscado por',
    'No pages were found containing "[_1]".' => 'No pages were found containing "[_1]".', # Translate - New (6)
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
    'Posted in [_1] on [_2]' => 'Posted in [_1] on [_2]', # Translate - New (5)
    'No results found' => 'No se encontraron resultados',
    'No new comments were found in the specified interval.' => 'No se encontraron nuevos comentarios en el intervalo especificado',
    'Select the time interval that you\'d like to search in, then click \'Find new comments\'' => 'Select the time interval that you\'d like to search in, then click \'Find new comments\'', # Translate - New (16)

    ## ./search_templates/results_feed.tmpl
    'Search Results for [_1]' => 'Search Results for [_1]', # Translate - New (4)

    ## ./search_templates/results_feed_rss2.tmpl

    ## ./default_templates/comment_error_template.tmpl
    'Comment Submission Error' => 'Error en el envío de comentarios',
    'Your comment submission failed for the following reasons:' => 'El envío de su comentario falló por las siguientes razones:',
    'Return to the original entry' => 'Volver a la entrada original',

    ## ./default_templates/dynamic_pages_error_template.tmpl
    'Page Not Found' => 'Página no encontrada',

    ## ./default_templates/trackback_listing_template.tmpl
    ': Discussion on [_1]' => ': Discusión en [_1]',
    'Trackbacks: [_1]' => 'Trackbacks: [_1]', # Translate - Previous (2)
    'TrackBack' => 'TrackBack', # Translate - Previous (1)
    'TrackBack URL for this entry:' => 'URL del Trackback para esta entrada:',
    'Listed below are links to weblogs that reference' => 'Listados abajo están los enlaces de los weblogs que le referencian',
    'from' => 'desde',
    'Read More' => 'Leer más',
    'Tracked on [_1]' => 'Publicado en [_1]',

    ## ./default_templates/main_index.tmpl
    'Continue reading' => 'Continuar leyendo',
    'Tags' => 'Etiquetas',
    'Posted by [_1] on [_2]' => 'Publicado por [_1] en [_2]',
    'Permalink' => 'Enlace permanente',
    'Comments' => 'Comentarios',
    'TrackBacks' => 'TrackBacks', # Translate - Previous (1)
    'Search this blog:' => 'Buscar en este blog:',
    'Recent Posts' => 'Entradas recientes',
    'Subscribe to this blog\'s feed' => 'Suscribirse a este blog (XML)',
    'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds', # Translate - New (6)
    'What is this?' => '¿Qué es esto?',
    'Categories' => 'Categorías',
    'Archives' => 'Archivos',
    'Creative Commons License' => 'Licencia Creative Commons',
    'This weblog is licensed under a' => 'Este weblog está licenciado bajo una',

    ## ./default_templates/dynamic_site_bootstrapper.tmpl

    ## ./default_templates/datebased_archive.tmpl
    'Main' => 'Inicio',
    'About [_1]' => 'About [_1]', # Translate - New (2)
    '<a href=' => '<a href=', # Translate - New (3)
    'Many more can be found on the <a href=' => 'Many more can be found on the <a href=', # Translate - New (9)

    ## ./default_templates/uploaded_image_popup_template.tmpl

    ## ./default_templates/category_archive.tmpl
    'Posted on [_1]' => 'Posted on [_1]', # Translate - New (3)
    'About' => 'About', # Translate - New (1)

    ## ./default_templates/master_archive_index.tmpl
    ': Archives' => ': Archivos',

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
    'Comment on' => 'Comentado en',
    'Previewing your Comment' => 'Vista previa del comentario',
    'Posted by:' => 'Publicado por:',
    'Anonymous' => 'Anónimo',
    '(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(Si no dejó aquí ningún comentario anteriormente, quizás necesite aprobación por parte del dueño del sitio, antes de que el comentario aparezca. Hasta entonces, no se mostrará en la entrada. Gracias por su paciencia).',
    'Name:' => 'Nombre:',
    'Email Address:' => 'Dirección de correo-e:',
    'URL:' => 'URL:', # Translate - Previous (1)
    'Comments:' => 'Comentarios:',
    '(you may use HTML tags for style)' => '(puede usar etiquetas HTML para el estilo)',
    'Preview' => 'Vista previa',
    'Post' => 'Publicar',
    'Cancel' => 'Cancelar',
    'Posted on' => 'Posted on', # Translate - New (2)
    'Permalink to this comment' => 'Permalink to this comment', # Translate - New (4)

    ## ./default_templates/rss_20_index.tmpl

    ## ./default_templates/comment_pending_template.tmpl
    'Comment Pending' => 'Comentario pendiente',
    'Thank you for commenting.' => 'Gracias por comentar.',
    'Your comment has been received and held for approval by the blog owner.' => 'El comentario que envió fue recibido y está retenido para su aprobación por parte del administrador del weblog.',

    ## ./default_templates/search_results_template.tmpl
    'SEARCH FEED AUTODISCOVERY LINK PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'SEARCH FEED AUTODISCOVERY LINK PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED', # Translate - New (12)
    'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM', # Translate - New (7)
    'Search this site' => 'Search this site', # Translate - New (3)
    'SEARCH RESULTS DISPLAY' => 'SEARCH RESULTS DISPLAY', # Translate - New (3)
    'Matching entries from [_1]' => 'Matching entries from [_1]', # Translate - New (4)
    'Entries from [_1] tagged with \'[_2]\'' => 'Entries from [_1] tagged with \'[_2]\'', # Translate - New (6)
    'Posted <MTIfNonEmpty tag=' => 'Posted <MTIfNonEmpty tag=', # Translate - New (3)
    'NO RESULTS FOUND MESSAGE' => 'NO RESULTS FOUND MESSAGE', # Translate - New (4)
    'Entries matching \'[_1]\'' => 'Entries matching \'[_1]\'', # Translate - New (3)
    'Entries tagged with \'[_1]\'' => 'Entries tagged with \'[_1]\'', # Translate - New (4)
    'No pages were found containing \'[_1]\'.' => 'No pages were found containing \'[_1]\'.', # Translate - New (6)
    'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes' => 'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes', # Translate - New (23)
    'movable type' => 'movable type', # Translate - New (2)
    'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions' => 'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions', # Translate - New (14)
    'END OF ALPHA SEARCH RESULTS DIV' => 'END OF ALPHA SEARCH RESULTS DIV', # Translate - New (6)
    'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION', # Translate - New (9)
    'SET VARIABLES FOR SEARCH vs TAG information' => 'SET VARIABLES FOR SEARCH vs TAG information', # Translate - New (7)
    'Subscribe to feed' => 'Subscribe to feed', # Translate - New (3)
    'If you use an RSS reader, you can subscribe to a feed of all future entries tagged \'[_1]\'.' => 'If you use an RSS reader, you can subscribe to a feed of all future entries tagged \'[_1]\'.', # Translate - New (18)
    'If you use an RSS reader, you can subscribe to a feed of all future entries matching \'[_1]\'.' => 'If you use an RSS reader, you can subscribe to a feed of all future entries matching \'[_1]\'.', # Translate - New (18)
    'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'SEARCH/TAG FEED SUBSCRIPTION INFORMATION', # Translate - New (5)
    'Feed Subscription' => 'Feed Subscription', # Translate - New (2)
    'TAG LISTING FOR TAG SEARCH ONLY' => 'TAG LISTING FOR TAG SEARCH ONLY', # Translate - New (6)
    'Other Tags' => 'Other Tags', # Translate - New (2)
    'Other tags used on this blog' => 'Other tags used on this blog', # Translate - New (6)
    'END OF PAGE BODY' => 'END OF PAGE BODY', # Translate - New (4)
    'END OF CONTAINER' => 'END OF CONTAINER', # Translate - New (3)

    ## ./default_templates/individual_entry_archive.tmpl
    'Tracked on' => 'Seguido el',
    'Post a comment' => 'Publicar un comentario',
    'Remember personal info?' => '¿Recordar datos personales?',
    'This page contains a single entry from the blog posted on ' => 'This page contains a single entry from the blog posted on ', # Translate - New (11)
    '.' => '.', # Translate - New (0)
    'The previous post in this blog was ' => 'The previous post in this blog was ', # Translate - New (7)
    'The next post in this blog is ' => 'The next post in this blog is ', # Translate - New (7)
    'Many more can be found on the ' => 'Many more can be found on the ', # Translate - New (7)
    'main index page' => 'main index page', # Translate - New (3)
    ' or by looking through ' => ' or by looking through ', # Translate - New (5)
    'the archives' => 'the archives', # Translate - New (2)

    ## ./lib/MT/default-templates.pl

    ## ./extras/examples/plugins/mirror/mirror.pl

    ## ./extras/examples/plugins/mirror/tmpl/mirror.tmpl

    ## ./extras/examples/plugins/l10nsample/l10nsample.pl
    'l10nsample' => 'l10nsample', # Translate - New (2)
    'This description can be localized if there is l10n_class set.' => 'This description can be localized if there is l10n_class set.', # Translate - New (12)
    'Fumiaki Yoshimatsu' => 'Fumiaki Yoshimatsu', # Translate - New (2)

    ## ./extras/examples/plugins/l10nsample/tmpl/view.tmpl
    'This phrase is processed in template.' => 'This phrase is processed in template.', # Translate - New (6)

    ## ./plugins/nofollow/nofollow.pl
    'Adds a \'nofollow\' relationship to comment and TrackBack hyperlinks to reduce spam.' => 'Adds a \'nofollow\' relationship to comment and TrackBack hyperlinks to reduce spam.', # Translate - New (12)
    'Restrict:' => 'Restrict:', # Translate - New (1)
    'Don\'t add nofollow to links in comments by authenticated commenters' => 'Don\'t add nofollow to links in comments by authenticated commenters', # Translate - New (11)

    ## ./plugins/TemplateRefresh/TemplateRefresh.pl
    'Backup and refresh existing templates to Movable Type\'s default templates.' => 'Backup and refresh existing templates to Movable Type\'s default templates.', # Translate - New (11)

    ## ./plugins/TemplateRefresh/tmpl/results.tmpl
    'Backup and Refresh Templates' => 'Backup and Refresh Templates', # Translate - New (4)
    'No templates were selected to process.' => 'No templates were selected to process.', # Translate - New (6)
    'Return' => 'Return', # Translate - New (1)

    ## ./plugins/spamlookup/spamlookup_words.pl
    'SpamLookup module for moderating and junking feedback using keyword filters.' => 'SpamLookup module for moderating and junking feedback using keyword filters.', # Translate - New (10)

    ## ./plugins/spamlookup/spamlookup.pl
    'SpamLookup module for using blacklist lookup services to filter feedback.' => 'SpamLookup module for using blacklist lookup services to filter feedback.', # Translate - New (10)

    ## ./plugins/spamlookup/spamlookup_urls.pl
    'SpamLookup - Link' => 'SpamLookup - Link', # Translate - New (2)
    'SpamLookup module for junking and moderating feedback based on link filters.' => 'SpamLookup module for junking and moderating feedback based on link filters.', # Translate - New (11)

    ## ./plugins/spamlookup/tmpl/url_config.tmpl
    'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)', # Translate - New (54)
    'Link Limits:' => 'Link Limits:', # Translate - New (2)
    'Credit feedback rating when no hyperlinks are present' => 'Credit feedback rating when no hyperlinks are present', # Translate - New (8)
    'Adjust scoring' => 'Adjust scoring', # Translate - New (2)
    'Score weight:' => 'Score weight:', # Translate - New (2)
    'Decrease' => 'Disminuir',
    'Increase' => 'Aumentar',
    'Moderate when more than' => 'Moderate when more than', # Translate - New (4)
    'link(s) are given' => 'link(s) are given', # Translate - New (4)
    'Junk when more than' => 'Junk when more than', # Translate - New (4)
    'Link Memory:' => 'Link Memory:', # Translate - New (2)
    'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Credit feedback rating when &quot;URL&quot; element of feedback has been published before', # Translate - New (14)
    'Only applied when no other links are present in message of feedback.' => 'Only applied when no other links are present in message of feedback.', # Translate - New (12)
    'Exclude URLs from comments published within last [_1] days.' => 'Exclude URLs from comments published within last [_1] days.', # Translate - New (9)
    'Email Memory:' => 'Email Memory:', # Translate - New (2)
    'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address', # Translate - New (16)
    'Exclude Email addresses from comments published within last [_1] days.' => 'Exclude Email addresses from comments published within last [_1] days.', # Translate - New (10)

    ## ./plugins/spamlookup/tmpl/lookup_config.tmpl
    'Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog\'s Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.' => 'Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog\'s Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.', # Translate - New (56)
    'IP Address Lookups:' => 'IP Address Lookups:', # Translate - New (3)
    'Off' => 'Desactivar',
    'Moderate feedback from blacklisted IP addresses' => 'Moderate feedback from blacklisted IP addresses', # Translate - New (6)
    'Junk feedback from blacklisted IP addresses' => 'Junk feedback from blacklisted IP addresses', # Translate - New (6)
    'Less' => 'Menos',
    'More' => 'Más',
    'block' => 'block', # Translate - New (1)
    'none' => 'none', # Translate - New (1)
    'IP Blacklist Services:' => 'IP Blacklist Services:', # Translate - New (3)
    'Domain Name Lookups:' => 'Domain Name Lookups:', # Translate - New (3)
    'Moderate feedback containing blacklisted domains' => 'Moderate feedback containing blacklisted domains', # Translate - New (5)
    'Junk feedback containing blacklisted domains' => 'Junk feedback containing blacklisted domains', # Translate - New (5)
    'Domain Blacklist Services:' => 'Domain Blacklist Services:', # Translate - New (3)
    'Advanced TrackBack Lookups:' => 'Advanced TrackBack Lookups:', # Translate - New (3)
    'Moderate TrackBacks from suspicious sources' => 'Moderate TrackBacks from suspicious sources', # Translate - New (5)
    'Junk TrackBacks from suspicious sources' => 'Junk TrackBacks from suspicious sources', # Translate - New (5)
    'To prevent lookups for some IP addresses or domains, list them below. Place each entry on a line by itself.' => 'To prevent lookups for some IP addresses or domains, list them below. Place each entry on a line by itself.', # Translate - New (20)
    'Lookup Whitelist:' => 'Lookup Whitelist:', # Translate - New (2)

    ## ./plugins/spamlookup/tmpl/word_config.tmpl
    'Incomming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Incomming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.', # Translate - New (31)
    'Keywords to Moderate:' => 'Keywords to Moderate:', # Translate - New (3)
    'Keywords to Junk:' => 'Keywords to Junk:', # Translate - New (3)

    ## ./plugins/feeds-app-lite/mt-feeds.pl

    ## ./plugins/feeds-app-lite/tmpl/weblog_config.tmpl

    ## ./plugins/feeds-app-lite/tmpl/config.tmpl

    ## ./plugins/feeds-app-lite/tmpl/msg.tmpl

    ## ./plugins/feeds-app-lite/tmpl/start.tmpl
    'Feeds.App Lite creates modules that include feed data. Once you\'ve used it to create those modules, you can then use them in your blog templates.' => 'Feeds.App Lite creates modules that include feed data. Once you\'ve used it to create those modules, you can then use them in your blog templates.', # Translate - New (27)
    'Continue' => 'Continue', # Translate - New (1)

    ## ./plugins/feeds-app-lite/tmpl/select.tmpl

    ## ./plugins/StyleCatcher/stylecatcher.pl
    'You must define a global theme repository where themes can be stored locally.  If a particular blog has not been configured for it\'s own theme paths, it will use these settings. If a blog has it\'s own theme paths, then the theme will be copied to that location when applied to that weblog.' => 'You must define a global theme repository where themes can be stored locally.  If a particular blog has not been configured for it\'s own theme paths, it will use these settings. If a blog has it\'s own theme paths, then the theme will be copied to that location when applied to that weblog.', # Translate - New (55)
    'Your theme URL and path can be customized for this weblog.' => 'Your theme URL and path can be customized for this weblog.', # Translate - New (11)
    'The paths defined here must physically exist and be writable by the webserver.' => 'The paths defined here must physically exist and be writable by the webserver.', # Translate - New (13)
    'Theme Root URL:' => 'Theme Root URL:', # Translate - New (3)
    'Theme Root Path:' => 'Theme Root Path:', # Translate - New (3)
    'Style Library URL:' => 'Style Library URL:', # Translate - New (3)

    ## ./plugins/StyleCatcher/tmpl/gmscript.tmpl

    ## ./plugins/StyleCatcher/tmpl/header.tmpl
    'Main Menu' => 'Menú principal',
    'System Overview' => 'Resumen del sistema',
    'Help' => 'Ayuda',
    'Welcome' => 'Bienvenido',
    'Logout' => 'Cerrar sesión',
    'View Site' => 'Ver sitio',

    ## ./plugins/StyleCatcher/tmpl/footer.tmpl

    ## ./plugins/StyleCatcher/tmpl/view.tmpl
    'Please select a weblog to apply this theme.' => 'Please select a weblog to apply this theme.', # Translate - New (8)
    'Please click on a theme before attempting to apply a new design to your blog.' => 'Please click on a theme before attempting to apply a new design to your blog.', # Translate - New (15)
    'Applying...' => 'Applying...', # Translate - New (1)
    'Choose this Design' => 'Choose this Design', # Translate - New (3)
    'Find Style' => 'Find Style', # Translate - New (2)
    'Loading...' => 'Loading...', # Translate - New (1)
    'StyleCatcher user script.' => 'StyleCatcher user script.', # Translate - New (3)
    'Theme or Repository URL:' => 'Theme or Repository URL:', # Translate - New (4)
    'Find Styles' => 'Find Styles', # Translate - New (2)
    'NOTE:' => 'NOTE:', # Translate - New (1)
    'It will take a moment for themes to populate once you click \'Find Style\'.' => 'It will take a moment for themes to populate once you click \'Find Style\'.', # Translate - New (14)
    'Current theme for your weblog' => 'Current theme for your weblog', # Translate - New (5)
    'Current Theme' => 'Current Theme', # Translate - New (2)
    'Current themes for your weblogs' => 'Current themes for your weblogs', # Translate - New (5)
    'Current Themes' => 'Current Themes', # Translate - New (2)
    'Locally saved themes' => 'Locally saved themes', # Translate - New (3)
    'Saved Themes' => 'Saved Themes', # Translate - New (2)
    'Single themes from the web' => 'Single themes from the web', # Translate - New (5)
    'More Themes' => 'More Themes', # Translate - New (2)
    'Templates' => 'Plantillas',
    'Details' => 'Details', # Translate - New (1)
    'Show Details' => 'Show Details', # Translate - New (2)
    'Hide Details' => 'Hide Details', # Translate - New (2)
    'Select a Weblog...' => 'Select a Weblog...', # Translate - New (3)
    'Apply Selected Design' => 'Apply Selected Design', # Translate - New (3)
    'You don\'t appear to have any weblogs with a ' => 'You don\'t appear to have any weblogs with a ', # Translate - New (10)

    ## ./plugins/WidgetManager/WidgetManager.pl
    'Maintain your weblog\'s widget content using a handy drag and drop interface.' => 'Maintain your weblog\'s widget content using a handy drag and drop interface.', # Translate - New (13)

    ## ./plugins/WidgetManager/tmpl/header.tmpl
    'Movable Type Publishing Platform' => 'Movable Type Publishing Platform', # Translate - Previous (4)
    'Weblogs:' => 'Weblogs:', # Translate - Previous (1)
    'Go' => 'Ir',
    'Entries' => 'Entradas',

    ## ./plugins/WidgetManager/tmpl/list.tmpl
    'Widget Manager' => 'Widget Manager', # Translate - New (2)
    'Rearrange Items' => 'Rearrange Items', # Translate - New (2)
    'To add a Widget Manager to your templates, use the following syntax:' => 'To add a Widget Manager to your templates, use the following syntax:', # Translate - New (12)
    'Widget Managers' => 'Widget Managers', # Translate - New (2)
    'Add Widget Manager' => 'Add Widget Manager', # Translate - New (3)
    'Create Widget Manager' => 'Create Widget Manager', # Translate - New (3)
    'Your changes to the Widget Manager have been saved.' => 'Your changes to the Widget Manager have been saved.', # Translate - New (9)
    'You have successfully deleted the selected Widget Manager(s) from your weblog.' => 'You have successfully deleted the selected Widget Manager(s) from your weblog.', # Translate - New (12)
    'Delete Selected' => 'Delete Selected', # Translate - New (2)
    'Are you sure you wish to delete the selected Widget Manager(s)?' => 'Are you sure you wish to delete the selected Widget Manager(s)?', # Translate - New (12)
    'WidgetManager Name' => 'WidgetManager Name', # Translate - New (2)
    'Installed Widgets' => 'Installed Widgets', # Translate - New (2)
    'Edit' => 'Edit', # Translate - New (1)

    ## ./plugins/WidgetManager/tmpl/footer.tmpl

    ## ./plugins/WidgetManager/tmpl/edit.tmpl
    'Widget Manager Name:' => 'Widget Manager Name:', # Translate - New (3)
    'Build WidgetManager:' => 'Build WidgetManager:', # Translate - New (2)
    'Available Widgets' => 'Available Widgets', # Translate - New (2)
    'Save Changes' => 'Guardar cambios',

    ## ./plugins/WidgetManager/default_widgets/search.tmpl

    ## ./plugins/WidgetManager/default_widgets/technorati_search.tmpl
    'Technorati' => 'Technorati', # Translate - New (1)
    'this blog' => 'this blog', # Translate - New (2)
    'all blogs' => 'all blogs', # Translate - New (2)
    'Blogs that link here' => 'Blogs that link here', # Translate - New (4)

    ## ./plugins/WidgetManager/default_widgets/monthly_archive_list.tmpl

    ## ./plugins/WidgetManager/default_widgets/subscribe_to_feed.tmpl

    ## ./plugins/WidgetManager/default_widgets/copyright.tmpl

    ## ./plugins/WidgetManager/default_widgets/recent_posts.tmpl

    ## ./plugins/WidgetManager/default_widgets/calendar.tmpl
    'Monthly calendar with links to each day\'s posts' => 'Monthly calendar with links to each day\'s posts', # Translate - New (9)
    'Sunday' => 'Sunday', # Translate - New (1)
    'Sun' => 'Sun', # Translate - New (1)
    'Monday' => 'Monday', # Translate - New (1)
    'Mon' => 'Mon', # Translate - New (1)
    'Tuesday' => 'Tuesday', # Translate - New (1)
    'Tue' => 'Tue', # Translate - New (1)
    'Wednesday' => 'Wednesday', # Translate - New (1)
    'Wed' => 'Wed', # Translate - New (1)
    'Thursday' => 'Thursday', # Translate - New (1)
    'Thu' => 'Thu', # Translate - New (1)
    'Friday' => 'Friday', # Translate - New (1)
    'Fri' => 'Fri', # Translate - New (1)
    'Saturday' => 'Saturday', # Translate - New (1)
    'Sat' => 'Sat', # Translate - New (1)

    ## ./plugins/WidgetManager/default_widgets/category_archive_list.tmpl

    ## ./plugins/WidgetManager/default_widgets/creative_commons.tmpl

    ## ./plugins/GoogleSearch/GoogleSearch.pl

    ## ./plugins/GoogleSearch/tmpl/config.tmpl
    'Google API Key:' => 'Clave para la API de Google:',
    'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.' => 'Si desea utilizar cualquier funcionalidad de la API de Google, deberá disponer de la clave correspondiente. Cópiela y péguela aquí.',

    ## ./t/test-common.pl

    ## ./t/test.tmpl

    ## ./t/blog-common.pl

    ## ./t/driver-tests.pl

    ## ./t/plugins/testplug.pl

    ## ./tmpl/error.tmpl
    'Missing Configuration File' => 'Fichero de configuración no encontrado',
    'Database Connection Error' => 'Error de conexión a la base de datos',
    'CGI Path Configuration Required' => 'Se necesita la configuración de la ruta de CGI',
    'An error occurred' => 'Ocurrió un error',

    ## ./tmpl/cms/edit_comment.tmpl
    'Edit Comment' => 'Editar comentario',
    'Your changes have been saved.' => 'Sus cambios han sido guardados.',
    'The comment has been approved.' => 'Comentario aprobado.',
    'Previous' => 'Anterior',
    'List &amp; Edit Comments' => 'Listar y editar comentarios',
    'Next' => 'Siguiente',
    '_external_link_target' => '_external_link_target', # Translate - New (4)
    'View Entry' => 'Ver entrada',
    'Pending Approval' => 'Autorización pendiente',
    'Junked Comment' => 'Comentario basura',
    'Status:' => 'Estado:',
    'Published' => 'Publicado',
    'Unpublished' => 'No publicado',
    'Junk' => 'Basura',
    'View all comments with this status' => 'Ver comentarios con este estado',
    'Commenter:' => 'Comentarista:',
    'Trusted' => 'Confiado',
    '(Trusted)' => '(Confiado)',
    'Ban&nbsp;Commenter' => 'Bloquear&nbsp;comentarista',
    'Untrust&nbsp;Commenter' => 'No&nbsp;confiar&nbsp;comentarista',
    'Banned' => 'Bloqueado',
    '(Banned)' => '(Bloqueado)',
    'Trust&nbsp;Commenter' => 'Confiar&nbsp;comentarista',
    'Unban&nbsp;Commenter' => 'Desbloquear&nbsp;comentarista',
    'Pending' => 'Pendiente',
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
    'IP:' => 'IP:', # Translate - Previous (1)
    'View all comments from this IP address' => 'Ver todos los comentarios procedentes de esta dirección IP',
    'Save this comment (s)' => 'Guardar este comentario (s)',
    'comment' => 'comentario',
    'comments' => 'comentarios',
    'Delete' => 'Eliminar',
    'Delete this comment (x)' => 'Delete this comment (x)', # Translate - New (4)
    'Ban This IP' => 'Bloquear esta IP',
    'Final Feedback Rating' => 'Puntuación final respuestas',
    'Test' => 'Test', # Translate - Previous (1)
    'Score' => 'Puntuación',
    'Results' => 'Resultados',
    'Plugin Actions' => 'Acciones de plugins',

    ## ./tmpl/cms/notification_actions.tmpl
    'notification address' => 'dirección de notificación',
    'notification addresses' => 'direcciones de notificación',
    'Delete selected notification addresses (x)' => 'Delete selected notification addresses (x)', # Translate - New (5)

    ## ./tmpl/cms/edit_author.tmpl
    'Your Web services password is currently' => 'Your Web services password is currently', # Translate - New (6)
    'Author Profile' => 'Perfil del autor',
    'Create New Author' => 'Crear nuevo autor',
    'Profile' => 'Perfil',
    'Permissions' => 'Permisos',
    'Your profile has been updated.' => 'Se actualizó su perfil.',
    'Weblog Associations' => 'Asociaciones',
    'General Permissions' => 'Permisos generales',
    'System Administrator' => 'Administrador del sistema',
    'Create Weblogs' => 'Crear weblogs',
    'View Activity Log' => 'Ver registro de actividades',
    'Username (*):' => 'Username (*):', # Translate - New (1)
    'The name used by this author to login.' => 'El nombre utilizado por este autor para iniciar su sesión.',
    'Display Name:' => 'Nombre público:',
    'The author\'s published name.' => 'El nombre público del autor.',
    'Email Address (*):' => 'Email Address (*):', # Translate - New (2)
    'The author\'s email address.' => 'La dirección de correo electrónico del autor.',
    'Website URL:' => 'URL del sitio:',
    'The URL of this author\'s website. (Optional)' => 'La URL del sitio de este autor. (Opcional)',
    'Language:' => 'Idioma:',
    'The author\'s preferred language.' => 'El idioma preferido del autor.',
    'Tag Delimiter:' => 'Tag Delimiter:', # Translate - New (2)
    'Comma' => 'Comma', # Translate - New (1)
    'Space' => 'Space', # Translate - New (1)
    'Other...' => 'Other...', # Translate - New (1)
    'The author\'s preferred delimiter for entering tags.' => 'The author\'s preferred delimiter for entering tags.', # Translate - New (8)
    'Password' => 'Contraseña',
    'Current Password:' => 'Contraseña actual:',
    'Enter the existing password to change it.' => 'Teclee la contraseña actual para cambiarla.',
    'New Password:' => 'Nueva contraseña:',
    'Initial Password (*):' => 'Initial Password (*):', # Translate - New (2)
    'Select a password for the author.' => 'Seleccione una contraseña para este autor.',
    'Password Confirm:' => 'Confirmar contraseña:',
    'Repeat the password for confirmation.' => 'Repita la contraseña para confirmación.',
    'Password recovery word/phrase' => 'Password recovery word/phrase', # Translate - New (4)
    'This word or phrase will be required to recover your password if you forget it.' => 'This word or phrase will be required to recover your password if you forget it.', # Translate - New (15)
    'Web Services Password:' => 'Web Services Password:', # Translate - New (3)
    'Reveal' => 'Mostrar',
    'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'For use by Activity feeds and with XML-RPC and Atom-enabled clients.', # Translate - New (11)
    'Save this author (s)' => 'Guardar este/os autor/es',

    ## ./tmpl/cms/list_commenters.tmpl
    'Authenticated Commenters' => 'Comentaristas autentificados',
    'The selected commenter(s) has been given trusted status.' => 'Los comentaristas seleccionados tienen ya el estado de confianza.',
    'Trusted status has been removed from the selected commenter(s).' => 'Se eliminó el estado de confianza de los comentaristas seleccionados.',
    'The selected commenter(s) have been blocked from commenting.' => 'Se bloquearon los comentaristas seleccionados.',
    'The selected commenter(s) have been unbanned.' => 'Se desbloquearon los comentaristas seleccionados.',
    'Reset' => 'Reiniciar',
    'Filter:' => 'Filtrar:',
    'None.' => 'None.', # Translate - New (1)
    '(Showing all commenters.)' => '(Showing all commenters.)', # Translate - New (4)
    'Showing only commenters whose [_1] is [_2].' => 'Showing only commenters whose [_1] is [_2].', # Translate - New (7)
    'Commenter Feed' => 'Commenter Feed', # Translate - New (2)
    'Commenter Feed (Disabled)' => 'Commenter Feed (Disabled)', # Translate - New (3)
    'Disabled' => 'Desactivado',
    'Set Web Services Password' => 'Set Web Services Password', # Translate - New (4)
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
    'Filter' => 'Filtro',
    'No commenters could be found.' => 'No se encontraron comentaristas.',

    ## ./tmpl/cms/comment_actions.tmpl
    'to publish' => 'para publicar',
    'Publish' => 'Publicar',
    'Publish selected comments (p)' => 'Publicar comentarios seleccionados (p)',
    'Delete selected comments (x)' => 'Delete selected comments (x)', # Translate - New (4)
    'Junk selected comments (j)' => 'Marcar como basura comentarios seleccionados (j)',
    'Not Junk' => 'No es basura',
    'Recover selected comments (j)' => 'Recuperar comentarios seleccionados (j)',
    'Are you sure you want to remove all junk comments?' => 'Are you sure you want to remove all junk comments?', # Translate - New (10)
    'Empty Junk Folder' => 'Empty Junk Folder', # Translate - New (3)
    'Deletes all junk comments' => 'Deletes all junk comments', # Translate - New (4)

    ## ./tmpl/cms/copyright.tmpl

    ## ./tmpl/cms/comment_table.tmpl
    'Status' => 'Estado',
    'Comment' => 'Comentario',
    'Commenter' => 'Comentarista',
    'Weblog' => 'Weblog', # Translate - Previous (1)
    'Entry' => 'Entrada',
    'Date' => 'Fecha',
    'IP' => 'IP', # Translate - Previous (1)
    'Only show published comments' => 'Mostrar solo comentarios publicados',
    'Only show pending comments' => 'Mostrar solo comentarios pendientes',
    'Edit this comment' => 'Editar este comentario',
    'Edit this commenter' => 'Editar este comentarista',
    'Blocked' => 'Bloqueado',
    'Authenticated' => 'Autentificado',
    'Search for comments by this commenter' => 'Buscar comentarios de este comentarista',
    'View this entry' => 'View this entry', # Translate - New (3)
    'Show all comments on this entry' => 'Mostrar todos los comentarios de esta entrada',
    'Search for all comments from this IP address' => 'Buscar todos los comentarios enviados desde esta dirección IP',

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

    ## ./tmpl/cms/list_tags.tmpl
    'System-wide' => 'Toda la instalación',
    'Your tag changes and additions have been made.' => 'Your tag changes and additions have been made.', # Translate - New (8)
    'You have successfully deleted the selected tags.' => 'You have successfully deleted the selected tags.', # Translate - New (7)
    'Tag Name' => 'Tag Name', # Translate - New (2)
    'Click to edit tag name' => 'Click to edit tag name', # Translate - New (5)
    'Rename' => 'Rename', # Translate - New (1)
    'Show all entries with this tag' => 'Show all entries with this tag', # Translate - New (6)
    '[quant,_1,entry,entries]' => '[quant,_1,entrada,entradas]',
    'No tags could be found.' => 'No tags could be found.', # Translate - New (5)

    ## ./tmpl/cms/ping_actions.tmpl
    'Publish selected TrackBacks (p)' => 'Publicar TrackBacks seleccionados (p)',
    'Delete selected TrackBacks (x)' => 'Delete selected TrackBacks (x)', # Translate - New (4)
    'Junk selected TrackBacks (j)' => 'Marcar como basura los TrackBacks seleccionados (j)',
    'Recover selected TrackBacks (j)' => 'Recuperar TrackBacks seleccionados (j)',
    'Are you sure you want to remove all junk TrackBacks?' => 'Are you sure you want to remove all junk TrackBacks?', # Translate - New (10)
    'Deletes all junk TrackBacks' => 'Deletes all junk TrackBacks', # Translate - New (4)

    ## ./tmpl/cms/list_author.tmpl
    'Authors' => 'Autores',
    'You have successfully deleted the authors from the Movable Type system.' => 'Eliminó a los autores correctamente del sistema de Movable Type.',
    'Username' => 'Nombre de usuario',
    'Name' => 'Nombre',
    'URL' => 'URL', # Translate - Previous (1)
    'Created By' => 'Creado por',
    'Last Entry' => 'Última entrada',
    'System' => 'Sistema',

    ## ./tmpl/cms/list_blog.tmpl
    'Movable Type News' => 'Noticias de Movable Type',
    'System Shortcuts' => 'Atajos del sistema',
    'Weblogs' => 'Weblogs', # Translate - Previous (1)
    'Concise listing of weblogs.' => 'Lista concisa de weblogs.',
    'Create, manage, set permissions.' => 'Crear, administrar, establecer permisos.',
    'Plugins' => 'Plugins', # Translate - Previous (1)
    'What\'s installed, access to more.' => 'Qué está instalado, acceder a otros.',
    'Multi-weblog entry listing.' => 'Lista de entradas multi-weblog.',
    'Multi-weblog tag listing.' => 'Multi-weblog tag listing.', # Translate - New (3)
    'Multi-weblog comment listing.' => 'Lista de comentarios multi-weblog.',
    'Multi-weblog TrackBack listing.' => 'Lista de TrackBacks multi-weblog.',
    'Settings' => 'Configuración',
    'System-wide configuration.' => 'Configuración del sistema.',
    'Search &amp; Replace' => 'Buscar &amp; Reemplazar',
    'Find everything. Replace anything.' => 'Encontrar todo. Reemplazar cualquier cosa.',
    'Activity Log' => 'Registro de actividades',
    'What\'s been happening.' => 'Qué sucede.',
    'Status &amp; Info' => 'Estado &amp; información',
    'Server status and information.' => 'Estado e información del servidor.',
    'QuickPost' => 'QuickPost', # Translate - Previous (1)
    'Set Up A QuickPost Bookmarklet' => 'Configurar QuickPost',
    'Enable one-click publishing.' => 'Habilitar publicación de un solo clic.',
    'My Weblogs' => 'Mis weblogs',
    'Warning' => 'Alerta',
    'Important:' => 'Importante:',
    'Configure this weblog.' => 'Configurar este weblog.',
    'Create New Entry' => 'Crear nueva entrada',
    'Create a new entry' => 'Crear una nueva entrada',
    'Create a new entry on this weblog' => 'Create a new entry on this weblog', # Translate - New (7)
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
    'You currently have no blogs.' => 'You currently have no blogs.', # Translate - New (5)
    'Please see your system administrator for access.' => 'Please see your system administrator for access.', # Translate - New (7)

    ## ./tmpl/cms/import.tmpl
    'Import / Export' => 'Importar / Exportar',
    'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.', # Translate - New (26)
    'Import Entries' => 'Importar entradas',
    'Export Entries' => 'Exportar entradas',
    'Authorship of imported entries:' => 'Authorship of imported entries:', # Translate - New (4)
    'Import as me' => 'Import as me', # Translate - New (3)
    'Preserve original author' => 'Preserve original author', # Translate - New (3)
    'If you choose to preserve the authorship of the imported entries and any of those authors must be created in this installation, you must define a default password for those new accounts.' => 'If you choose to preserve the authorship of the imported entries and any of those authors must be created in this installation, you must define a default password for those new accounts.', # Translate - New (32)
    'Default password for new authors:' => 'Default password for new authors:', # Translate - New (5)
    'Upload import file: (optional)' => 'Upload import file: (optional)', # Translate - New (4)
    'You will be assigned the author of all imported entries.  If you wish the original authors to keep ownership, you must contact your MT system administrator to perform the import so that new authors can be created if necessary.' => 'Se le registrará como autor de todas las entradas importadas. Si desea respetar la autoría original de las entradas, debe contactar con el administrador de MT para realizar la importación, y así crear los nuevos autores si fuera necesario.',
    'Import File Encoding (optional):' => 'Import File Encoding (optional):', # Translate - New (4)
    'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.', # Translate - New (26)
    'Default category for entries (optional):' => 'Categoría predeterminada para las entradas (opcional):',
    'Select a category' => 'Seleccione una categoría',
    'You can specify a default category for imported entries which have none assigned.' => 'You can specify a default category for imported entries which have none assigned.', # Translate - New (13)
    'Importing from another system?' => 'Importing from another system?', # Translate - New (4)
    'Start title HTML (optional):' => 'Código HTML de comienzo de título (opcional):',
    'End title HTML (optional):' => 'Código HTML de final de título (opcional):',
    'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => 'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.', # Translate - New (27)
    'Default post status for entries (optional):' => 'Estado de publicación predeterminado para las entradas (opcional):',
    'Select a post status' => 'Seleccione un estado de publicación',
    'If the software you are importing from does not specify a post status in its export file, you can set this as the status to use when importing entries.' => 'If the software you are importing from does not specify a post status in its export file, you can set this as the status to use when importing entries.', # Translate - New (29)
    'Import Entries (i)' => 'Import Entries (i)', # Translate - New (3)
    'Export Entries From [_1]' => 'Exportar entradas desde [_1]',
    'Export Entries (e)' => 'Export Entries (e)', # Translate - New (3)
    'Export Entries to Tangent' => 'Exportar entradas a Tangent',

    ## ./tmpl/cms/edit_template.tmpl
    'You have unsaved changes to your template that will be lost.' => 'You have unsaved changes to your template that will be lost.', # Translate - New (11)
    'Edit Template' => 'Editar plantilla',
    'Your template changes have been saved.' => 'Se guardaron sus cambios en las plantillas.',
    'Rebuild this template' => 'Regenerar esta plantilla',
    'View Published Template' => 'View Published Template', # Translate - New (3)
    'Build Options' => 'Opciones de generación',
    'Enable dynamic building for this template' => 'Permitir la generación dinámica para esta plantilla',
    'Rebuild this template automatically when rebuilding index templates' => 'Reconstruir automáticamente esta plantilla al reconstruir plantillas de índices',
    'Template Name' => 'Nombre de la plantilla',
    'Comment Listing Template' => 'Plantilla de listado de comentarios',
    'Comment Preview Template' => 'Plantilla de previsualización de comentarios',
    'Search Results Template' => 'Search Results Template', # Translate - New (3)
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
    'Insert...' => 'Insert...', # Translate - New (1)
    'Bigger' => 'Bigger', # Translate - New (1)
    'Smaller' => 'Smaller', # Translate - New (1)
    'Save this template (s)' => 'Guardar esta plantilla (s)',
    'Save and Rebuild' => 'Guardar y reconstruir',
    'Save and rebuild this template (r)' => 'Guadar y reconstruir esta plantilla (r)',

    ## ./tmpl/cms/upgrade.tmpl
    'Time to Upgrade!' => '¡Hora de actualizar!',
    'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).', # Translate - New (17)
    'Do you want to proceed with the upgrade anyway?' => 'Do you want to proceed with the upgrade anyway?', # Translate - New (9)
    'Yes' => 'Sí',
    'No' => 'No', # Translate - Previous (1)
    'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Se ha instalado una nueva versión de Movable Type.  Debemos realizar algunas tareas para actualizar su base de datos.',
    'Begin Upgrade' => 'Comenzar actualización',

    ## ./tmpl/cms/entry_actions.tmpl
    'Save these entries (s)' => 'Guardar estas entradas (s)',
    'Save this entry (s)' => 'Guardar esta entrada (s)',
    'Preview this entry (v)' => 'Preview this entry (v)', # Translate - New (4)
    'entry' => 'entrada',
    'entries' => 'entradas',
    'Delete this entry (x)' => 'Delete this entry (x)', # Translate - New (4)
    'to rebuild' => 'para reconstruir',
    'Rebuild' => 'Regenerar',
    'Rebuild selected entries (r)' => 'Regenerar entradas seleccionadas (r)',
    'Delete selected entries (x)' => 'Delete selected entries (x)', # Translate - New (4)

    ## ./tmpl/cms/junk_results.tmpl
    'Find Junk' => 'Buscar en basura',
    'The following items may be junk. Uncheck the box next to any items are NOT junk and hit JUNK to continue.' => 'The following items may be junk. Uncheck the box next to any items are NOT junk and hit JUNK to continue.', # Translate - New (21)
    'To return to the comment list without junking any items, click CANCEL.' => 'To return to the comment list without junking any items, click CANCEL.', # Translate - New (12)
    'Approved' => 'Autorizado',
    'Registered Commenter' => 'Comentarista registrado',
    'Return to comment list' => 'Return to comment list', # Translate - New (4)

    ## ./tmpl/cms/author_actions.tmpl
    'author' => 'autor',
    'authors' => 'authres',
    'Delete selected authors (x)' => 'Delete selected authors (x)', # Translate - New (4)

    ## ./tmpl/cms/bookmarklets.tmpl
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

    ## ./tmpl/cms/tag_table.tmpl
    'IP Address' => 'Dirección IP',
    'Log Message' => 'Mensaje del registro',

    ## ./tmpl/cms/blog-left-nav.tmpl
    'Posting' => 'Publicación',
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
    'Edit Categories' => 'Editar categorías',
    'Edit Tags' => 'Edit Tags', # Translate - New (2)
    'Edit Weblog Configuration' => 'Editar configuración del weblog',
    'Utilities' => 'Herramientas',
    'Import &amp; Export Entries' => 'Importar &amp; Exportar entradas',
    'Rebuild Site' => 'Regenerar sitio',

    ## ./tmpl/cms/import_start.tmpl
    'Importing...' => 'Importando...',
    'Importing entries into blog' => 'Importando entradas en el blog',
    'Importing entries as author \'[_1]\'' => 'Importando entradas como autor \'[_1]\'',
    'Creating new authors for each author found in the blog' => 'Creando nuevos autores para cada autor encontrado en el blog',

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
    'Email Address' => 'Dirección de correo electrónico',
    'Source URL' => 'URL origen',
    'Blog Name' => 'Nombre del blog',
    'Text' => 'Texto',
    'Output Filename' => 'Fichero salida',
    'Linked Filename' => 'Fichero enlazado',
    'Display Name' => 'Display Name', # Translate - New (2)
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
    'No authors were found that match the given criteria.' => 'No authors were found that match the given criteria.', # Translate - New (9)
    'Showing first [_1] results.' => 'Primeros [_1] resultados.',
    'Show all matches' => 'Mostrar todos los resultados',
    '[_1] result(s) found.' => '[_1] resultado/s encontrado/s.',

    ## ./tmpl/cms/log_table.tmpl
    'IP: [_1]' => 'IP: [_1]', # Translate - New (2)

    ## ./tmpl/cms/log_actions.tmpl
    'Reset Activity Log' => 'Reiniciar registro de actividades',

    ## ./tmpl/cms/cfg_entries.tmpl
    'New Entry Default Settings' => 'Configuración por defecto de nuevas entradas',
    'This screen allows you to control default settings for new entries as well as your publicity and remote interface settings.' => 'Esta pantalla le permite controlar las opciones por defecto de las nuevas entradas, así como la configuración de la publicidad y el interfaz remoto.',
    'General' => 'General', # Translate - Previous (1)
    'New Entry Defaults' => 'Valores por defecto de las nuevas entradas',
    'Feedback' => 'Respuestas',
    'Publishing' => 'Publicación',
    'IP Banning' => 'Bloqueo de IPs',
    'Switch to Basic Settings' => 'Switch to Basic Settings', # Translate - New (4)
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
    'If you have received a recently updated key (by virtue of your purchase), enter it here.' => 'If you have received a recently updated key (by virtue of your purchase), enter it here.', # Translate - New (16)
    'TrackBack Auto-Discovery' => 'Autodescubrimiento de TrackBacks',
    'Enable External TrackBack Auto-Discovery' => 'Habilitar autodescubrimiento de TrackBacks externos',
    'Note: The above option is currently ignored since outbound pings are disabled system-wide.' => 'Nota: La configuración de arriba se ignora actualmente debido a que los pings salientes están desactivados a nivel del sistema.',
    'Enable Internal TrackBack Auto-Discovery' => 'Habilitar autodescubrimiento de TrackBacks internos',
    'If you turn on auto-discovery, when you write a new post, any external links will be extracted and the appropriate sites automatically sent TrackBacks.' => 'Si activa el autodescubrimiento, al escribir una nueva entrada, se extraerán los enlaces externos y se enviará TrackBacks de forma automática a aquellos que lo aceptan.',
    'Save changes (s)' => 'Guardar cambios (s)',

    ## ./tmpl/cms/edit_blog.tmpl
    'You must set your Weblog Name.' => 'You must set your Weblog Name.', # Translate - New (6)
    'You must set your Local Site Path.' => 'Debe definir la ruta local de su sitio.',
    'You must set your Site URL.' => 'Debe definir la URL de su sitio.',
    'You did not select a timezone.' => 'No seleccionó ninguna zona horaria.',
    'Your Site URL is not valid.' => 'Your Site URL is not valid.', # Translate - New (6)
    'Your Local Site Path is not valid.' => 'Your Local Site Path is not valid.', # Translate - New (7)
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

    ## ./tmpl/cms/template_actions.tmpl
    'template' => 'plantilla',
    'templates' => 'plantillas',

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
    'Delete this TrackBack (x)' => 'Delete this TrackBack (x)', # Translate - New (4)

    ## ./tmpl/cms/list_entry.tmpl
    'Your entry has been deleted from the database.' => 'Se eliminó su entrada de la base de datos.',
    'Entry Feed' => 'Entry Feed', # Translate - New (2)
    'Entry Feed (Disabled)' => 'Entry Feed (Disabled)', # Translate - New (3)
    'Quickfilter:' => 'Filtro rápido:',
    'Show unpublished entries.' => 'Mostrar entradas no publicadas.',
    '(Showing all entries.)' => '(Showing all entries.)', # Translate - New (4)
    'Showing only entries where [_1] is [_2].' => 'Showing only entries where [_1] is [_2].', # Translate - New (7)
    'entries.' => 'entradas.',
    'entries where' => 'entradas donde',
    'tag (exact match)' => 'tag (exact match)', # Translate - New (3)
    'tag (incl. normalized)' => 'tag (incl. normalized)', # Translate - New (3)
    'category' => 'categoría',
    'published' => 'publicado',
    'unpublished' => 'no publicado',
    'scheduled' => 'programado',
    'No entries could be found.' => 'No se encontraron entradas.',

    ## ./tmpl/cms/header-popup.tmpl

    ## ./tmpl/cms/pending_commenter.tmpl

    ## ./tmpl/cms/edit_profile.tmpl
    'Author Permissions' => 'Permisos',
    'Your changes to [_1]\'s permissions have been saved.' => 'Se han guardado los permisos de [_1].',
    '[_1] has been successfully added to [_2].' => '[_1] se ha agregado correctamente a [_2].',
    'A new password has been generated and sent to the email address [_1].' => 'A new password has been generated and sent to the email address [_1].', # Translate - New (13)
    'Username:' => 'Usuario:',
    'Save permissions for this author (s)' => 'Guardar permisos de este/os autor/es',
    'Password Recovery' => 'Recuperación de contraseña',

    ## ./tmpl/cms/footer.tmpl

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
    '[quant,_1,TrackBack]' => '[quant,_1,TrackBack]', # Translate - Previous (4)
    'categories' => 'categories', # Translate - New (1)
    'Delete selected categories (x)' => 'Delete selected categories (x)', # Translate - New (4)

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

    ## ./tmpl/cms/author_table.tmpl

    ## ./tmpl/cms/entry_prefs.tmpl
    'Entry Editor Display Options' => 'Entry Editor Display Options', # Translate - New (4)
    'Your entry screen preferences have been saved.' => 'Sus preferencias de pantalla de entrada fueron guardadas.',
    'Editor Fields' => 'Editor Fields', # Translate - New (2)
    'Basic' => 'Básica',
    'All' => 'All', # Translate - New (1)
    'Custom' => 'Custom', # Translate - New (1)
    'Editable Authored On Date' => 'Fecha de autoría editable',
    'Accept TrackBacks' => 'Aceptar TrackBacks',
    'Outbound TrackBack URLs' => 'URLs de TrackBacks salientes',
    'Action Bar' => 'Action Bar', # Translate - New (2)
    'Select the location of the entry editor\'s action bar.' => 'Select the location of the entry editor\'s action bar.', # Translate - New (10)
    'Below' => 'Debajo',
    'Above' => 'Arriba',
    'Both' => 'Ambos',

    ## ./tmpl/cms/pinging.tmpl
    'Pinging sites...' => 'Enviando pings a sitios...',

    ## ./tmpl/cms/commenter_table.tmpl
    'Identity' => 'Identidad',
    'Most Recent Comment' => 'Comentario más reciente',
    'Only show trusted commenters' => 'Mostrar solo comentaristas confiados',
    'Only show banned commenters' => 'Mostrar solo comentaristas bloqueados',
    'Only show neutral commenters' => 'Mostrar solo comentaristas neutrales',
    'View this commenter\'s profile' => 'Mostrar perfil del comentarista',

    ## ./tmpl/cms/notification_table.tmpl
    'Date Added' => 'Fecha de creación',

    ## ./tmpl/cms/edit_placements.tmpl
    'The secondary categories for this entry have been updated. You will need to SAVE the entry for these changes to be reflected on your public site.' => 'Las categorías secundarias de esta entrada fueron actualizadas. Para que estos cambios se reflejen en su sitio público, deberá GUARDAR la entrada.',
    'Categories in your weblog:' => 'Categorías en su weblog:',
    'Secondary categories:' => 'Categorías secundarias:',
    'Assign &gt;&gt;' => 'Assign &gt;&gt;', # Translate - New (3)
    '&lt;&lt; Remove' => '&lt;&lt; Remove', # Translate - New (4)
    'Close' => 'Cerrar',

    ## ./tmpl/cms/feed_link.tmpl
    'Activity Feed' => 'Activity Feed', # Translate - New (2)
    'Activity Feed (Disabled)' => 'Activity Feed (Disabled)', # Translate - New (3)

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
    'Suomi' => 'Suomi', # Translate - Previous (1)
    'Swedish' => 'Sueco',
    'Select the language in which you would like dates on your blog displayed.' => 'Seleccione el idioma en el que desea que se visualicen las fechas en su weblog.',
    'Limit HTML Tags:' => 'Limitar etiquetas HTML:',
    'Use defaults' => 'Utilizar valores predeterminados',
    '([_1])' => '([_1])', # Translate - Previous (2)
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

    ## ./tmpl/cms/rebuild_confirm.tmpl
    'Select the type of rebuild you would like to perform. (Click the Cancel button if you do not want to rebuild any files.)' => 'Seleccione el tipo de reconstrucción  que desea realizar (haga clic en el botón Cancelar si no desea reconstruir ningún fichero).',
    'Rebuild All Files' => 'Regenerar todos los ficheros',
    'Index Template: [_1]' => 'Plantilla índice: [_1]',
    'Rebuild Indexes Only' => 'Regenerar sólo los índices',
    'Rebuild [_1] Archives Only' => 'Regenerar sólo [_1] archivos',
    'Rebuild (r)' => 'Regenerar (r)',

    ## ./tmpl/cms/tag_actions.tmpl
    'Delete selected tags (x)' => 'Delete selected tags (x)', # Translate - New (4)

    ## ./tmpl/cms/ping_table.tmpl
    'From' => 'Origen',
    'Target' => 'Destino',
    'Only show published TrackBacks' => 'Mostrar solo TrackBacks publicados',
    'Only show pending TrackBacks' => 'Mostrar solo TrackBacks pendientes',
    'Edit this TrackBack' => 'Editar este TrackBack',
    'Go to the source entry of this TrackBack' => 'Ir a la entrada de origen de este TrackBack',
    'View the [_1] for this TrackBack' => 'Mostrar [_1] de este TrackBack',

    ## ./tmpl/cms/edit_entry.tmpl
    'You have unsaved changes to your entry that will be lost.' => 'You have unsaved changes to your entry that will be lost.', # Translate - New (11)
    'Add new category...' => 'Crear nueva categoría...',
    'Publish On' => 'Publish On', # Translate - New (2)
    'Entry Date' => 'Entry Date', # Translate - New (2)
    'You must specify at least one recipient.' => 'You must specify at least one recipient.', # Translate - New (7)
    'Edit Entry' => 'Editar entrada',
    'Your entry has been saved. You can now make any changes to the entry itself, edit the authored-on date, or edit comments.' => 'Your entry has been saved. You can now make any changes to the entry itself, edit the authored-on date, or edit comments.', # Translate - New (22)
    'One or more errors occurred when sending update pings or TrackBacks.' => 'Ocurrieron uno o más errores durante el envío de pings o TrackBacks.',
    'Your customization preferences have been saved, and are visible in the form below.' => 'Se guardaron los cambios en las preferencias y pueden verse en el siguiente formulario.',
    'Your changes to the comment have been saved.' => 'Se guardaron sus cambios al comentario.',
    'Your notification has been sent.' => 'Se envió su notificación.',
    'You have successfully deleted the checked comment(s).' => 'Eliminó correctamente los comentarios marcados.',
    'You have successfully deleted the checked TrackBack(s).' => 'Eliminó correctamente los TrackBacks marcados.',
    'List &amp; Edit Entries' => 'Enumerar y editar entradas',
    'Comments ([_1])' => 'Comentarios ([_1])',
    'TrackBacks ([_1])' => 'TrackBacks ([_1])', # Translate - Previous (2)
    'Notification' => 'Notificación',
    'Scheduled' => 'Programado',
    'Assign Multiple Categories' => 'Asignar múltiples categorías',
    'Bold' => 'Negrita',
    'Italic' => 'Cursiva',
    'Underline' => 'Subrayado',
    'Insert Link' => 'Insertar vínculo',
    'Insert Email Link' => 'Insertar enlace correo-e',
    'Quote' => 'Cita',
    '(comma-delimited list)' => '(comma-delimited list)', # Translate - New (3)
    '(space-delimited list)' => '(space-delimited list)', # Translate - New (3)
    '(delimited by \'[_1]\')' => '(delimited by \'[_1]\')', # Translate - New (4)
    'Authored On' => 'Fecha de autoría',
    'Unlock this entry\'s output filename for editing' => 'Desbloquear para la edición el nombre fichero de salida de esta entrada',
    'Warning: If you set the basename manually, it may conflict with another entry.' => 'Atención: Si introduce el nombre base manualmente, podría entrar en conflicto con otra entrada.',
    'Warning: Changing this entry\'s basename may break inbound links.' => 'Atención: Si cambia el nombre base de la entrada, podría romper enlaces entrantes.',
    'View Previously Sent TrackBacks' => 'Ver TrackBacks enviados anteriormente',
    'Customize the display of this page.' => 'Personalizar la visualización de esta página.',
    'Manage Comments' => 'Administrar comentarios',
    'Click on a [_1] to edit it. To perform any other action, check the checkbox of one or more [_2] and click the appropriate button or select a choice of actions from the dropdown to the right.' => 'Click on a [_1] to edit it. To perform any other action, check the checkbox of one or more [_2] and click the appropriate button or select a choice of actions from the dropdown to the right.', # Translate - New (37)
    'No comments exist for this entry.' => 'No existen comentarios en esta entrada.',
    'Manage TrackBacks' => 'Administrar TrackBacks',
    'No TrackBacks exist for this entry.' => 'No existen TrackBacks en esta entrada.',
    'Send a Notification' => 'Enviar notificación',
    'You can send an email notification of this entry to people on your notification list or using arbitrary email addresses.' => 'You can send an email notification of this entry to people on your notification list or using arbitrary email addresses.', # Translate - New (20)
    'Recipients' => 'Recipients', # Translate - New (1)
    'Send notification to' => 'Send notification to', # Translate - New (3)
    'Notification list subscribers, and/or' => 'Notification list subscribers, and/or', # Translate - New (5)
    'Other email addresses' => 'Other email addresses', # Translate - New (3)
    'Note: Enter email addresses on separate lines or separated by commas.' => 'Note: Enter email addresses on separate lines or separated by commas.', # Translate - New (11)
    'Notification content' => 'Notification content', # Translate - New (2)
    'Your blog\'s name, this entry\'s title and a link to view it will be sent in the notification.  Additionally, you can add a  message, include an excerpt of the entry and/or send the entire entry.' => 'Your blog\'s name, this entry\'s title and a link to view it will be sent in the notification.  Additionally, you can add a  message, include an excerpt of the entry and/or send the entire entry.', # Translate - New (38)
    'Message to recipients (optional)' => 'Message to recipients (optional)', # Translate - New (4)
    'Additional content to include (optional)' => 'Additional content to include (optional)', # Translate - New (5)
    'Entry excerpt' => 'Entry excerpt', # Translate - New (2)
    'Entire entry body' => 'Entire entry body', # Translate - New (3)
    'Note: If you choose to send the entire entry, it will be sent as shown on the editing screen, without any text formatting applied.' => 'Note: If you choose to send the entire entry, it will be sent as shown on the editing screen, without any text formatting applied.', # Translate - New (24)
    'Send entry notification' => 'Send entry notification', # Translate - New (3)
    'Send notification (n)' => 'Send notification (n)', # Translate - New (3)

    ## ./tmpl/cms/entry_table.tmpl
    'Author' => 'Autor',
    'Only show unpublished entries' => 'Mostrar solo entradas no publicadas',
    'Only show published entries' => 'Mostrar solo entradas publicadas',
    'Only show scheduled entries' => 'Only show scheduled entries', # Translate - New (4)
    'None' => 'Ninguno',

    ## ./tmpl/cms/pinged_urls.tmpl
    'Here is a list of the previous TrackBacks that were successfully sent:' => 'Aquí se muestra una lista de los TrackBacks que se enviaron correctamente:',
    'Here is a list of the previous TrackBacks that failed. To retry these, include them in the Outbound TrackBack URLs list for your entry.:' => 'Here is a list of the previous TrackBacks that failed. To retry these, include them in the Outbound TrackBack URLs list for your entry.:', # Translate - New (24)

    ## ./tmpl/cms/view_log.tmpl
    'Are you sure you want to reset activity log?' => 'Are you sure you want to reset activity log?', # Translate - New (9)
    'The Movable Type activity log contains a record of notable actions in the system.' => 'El registro de actividad de Movable Type contiene un registro de las acciones más relevantes del sistema.',
    'All times are displayed in GMT[_1].' => 'All times are displayed in GMT[_1].', # Translate - New (7)
    'All times are displayed in GMT.' => 'Todas las fechas se muestran en GMT.',
    'The activity log has been reset.' => 'Se reinició el registro de actividades.',
    'Download CSV' => 'Download CSV', # Translate - New (2)
    'Show only errors.' => 'Show only errors.', # Translate - New (3)
    '(Showing all log records.)' => '(Showing all log records.)', # Translate - New (5)
    'Showing only log records where' => 'Showing only log records where', # Translate - New (5)
    'Filtered CSV' => 'Filtered CSV', # Translate - New (2)
    'Filtered' => 'Filtered', # Translate - New (1)
    'log records.' => 'log records.', # Translate - New (2)
    'log records where' => 'log records where', # Translate - New (3)
    'level' => 'level', # Translate - New (1)
    'classification' => 'classification', # Translate - New (1)
    'Security' => 'Security', # Translate - New (1)
    'Error' => 'Error', # Translate - Previous (1)
    'Information' => 'Information', # Translate - New (1)
    'Debug' => 'Debug', # Translate - New (1)
    'Security or error' => 'Security or error', # Translate - New (3)
    'Security/error/warning' => 'Security/error/warning', # Translate - New (3)
    'Not debug' => 'Not debug', # Translate - New (2)
    'Debug/error' => 'Debug/error', # Translate - New (2)
    'No log records could be found.' => 'No log records could be found.', # Translate - New (6)

    ## ./tmpl/cms/spam_confirm.tmpl
    'These domain names were found in the selected comments. Check the box at right to block comments and trackbacks containing that URL in the future.' => 'Se encontraron estos dominios en los comentarios seleccionados. Marque las casillas de la derecha para bloquear en el futuro los comentarios y trackbacks que contienen esta URL.',
    'Block' => 'Bloquear',

    ## ./tmpl/cms/pager.tmpl
    'Show:' => 'Mostrar:',
    '[quant,_1,row]' => '[quant,_1,fila]',
    'all rows' => 'todas las filas',
    'Another amount...' => 'Otra cantidad...',
    'Actions:' => 'Acciones:',
    'Date Display:' => 'Fecha:',
    'Relative' => 'Relativo',
    'Full' => 'Completo',
    'Open Batch Editor' => 'Open Batch Editor', # Translate - New (3)
    'Newer' => 'Más reciente',
    'Showing:' => 'Mostrando:',
    'of' => 'de',
    'Older' => 'Más antiguo',

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

    ## ./tmpl/cms/preview_entry.tmpl
    'Re-Edit this entry' => 'Volver a editar esta entrada',
    'Save this entry' => 'Guardar esta entrada',

    ## ./tmpl/cms/edit_permissions.tmpl
    'User can create weblogs' => 'El usuario puede crear weblogs',
    'User can view activity log' => 'El usuario puede ver el registro de actividades',
    'Check All' => 'Seleccionar todos',
    'Uncheck All' => 'Deseleccionar todos',
    'Weblog:' => 'Weblog:', # Translate - Previous (1)
    'Unheck All' => 'Deselseccionar todos',
    'Add user to an additional weblog:' => 'Asignar usuario a otro weblog:',
    'Select a weblog' => 'Seleccionar un weblog',
    'Add' => 'Crear',

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
    'Below is the notification list for this blog. When you manually send notifications on published entries, you can select from this list.' => 'Below is the notification list for this blog. When you manually send notifications on published entries, you can select from this list.', # Translate - New (22)
    'You have [quant,_1,user,users,no users] in your notification list. To delete an address, check the Delete box and press the Delete button.' => 'You have [quant,_1,user,users,no users] in your notification list. To delete an address, check the Delete box and press the Delete button.', # Translate - New (25)
    'You have added [_1] to your notification list.' => 'Ha agregado [_1] a su lista de notificaciones.',
    'You have successfully deleted the selected notifications from your notification list.' => 'Eliminó correctamente las notificaciones seleccionadas de la lista.',
    'Create New Notification' => 'Crear notificación',
    'URL (Optional):' => 'URL (opcional):',
    'Add Recipient' => 'Añadir receptor',
    'No notifications could be found.' => 'No se encontró ninguna notificación.',

    ## ./tmpl/cms/blog_actions.tmpl
    'weblog' => 'weblog', # Translate - Previous (1)
    'weblogs' => 'weblogs', # Translate - Previous (1)
    'Delete selected weblogs (x)' => 'Delete selected weblogs (x)', # Translate - New (4)

    ## ./tmpl/cms/edit_category.tmpl
    'You must specify a label for the category.' => 'You must specify a label for the category.', # Translate - New (8)
    'Edit Category' => 'Edit Category', # Translate - New (2)
    'Use this page to edit the attributes of the category [_1]. You can set a description for your category to be used in your public pages, as well as configuring the TrackBack options for this category.' => 'Utilice esta página para editar los atributos de la categoría [_1]. Puede configurar una descripción para su categoría que se utilizará en sus páginas públicas, así como configurar las opciones de TrackBack para esta categoría.',
    'Your category changes have been made.' => 'Los cambios en la categoría se han guardado.',
    'Label' => 'Label', # Translate - New (1)
    'Unlock this category\'s output filename for editing' => 'Unlock this category\'s output filename for editing', # Translate - New (8)
    'Warning: Changing this category\'s basename may break inbound links.' => 'Warning: Changing this category\'s basename may break inbound links.', # Translate - New (10)
    'Description' => 'Descripción',
    'Save this category (s)' => 'Save this category (s)', # Translate - New (4)
    'Inbound TrackBacks' => 'TrackBacks entradas',
    'If enabled, TrackBacks will be accepted for this category from any source.' => 'If enabled, TrackBacks will be accepted for this category from any source.', # Translate - New (12)
    'TrackBack URL for this category' => 'URL de TrackBack para esta categoría',
    'This is the URL that others will use to send TrackBacks to your weblog. If you wish for anyone to send TrackBacks to your weblog when they have a post specific to this category, post this URL publicly. If you choose to only allow a select group of individuals to TrackBack, send this URL to them privately. To include a list of incoming TrackBacks in your Main Index Template, check the documentation for template tags related to TrackBacks.' => 'This is the URL that others will use to send TrackBacks to your weblog. If you wish for anyone to send TrackBacks to your weblog when they have a post specific to this category, post this URL publicly. If you choose to only allow a select group of individuals to TrackBack, send this URL to them privately. To include a list of incoming TrackBacks in your Main Index Template, check the documentation for template tags related to TrackBacks.', # Translate - New (78)
    'Passphrase Protection' => 'Passphrase Protection', # Translate - New (2)
    'Optional.' => 'Optional.', # Translate - New (1)
    'Outbound TrackBacks' => 'TrackBacks salientes',
    'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you post an entry in this category. (Separate URLs with a carriage return.)' => 'Introduzca las URLs de los sitios a los que desee notificar al publicar una entrada en esta categoría. (URLs separadas por un retorno de carro).',

    ## ./tmpl/cms/menu.tmpl
    'Welcome to [_1].' => 'Bienvenido a [_1].',
    'You can post to and manage your weblog by selecting an option from the menu located to the left of this message.' => 'Puede publicar y administrar su weblog seleccionado una opción en el menú situado a la izquierda de este mensaje.',
    'If you need assistance, try:' => 'Si necesita ayuda, pruebe:',
    'Movable Type User Manual' => 'Manual del usuario de Movable Type',
    'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.com/movabletype/support', # Translate - New (6)
    'Movable Type Technical Support' => 'Soporte técnico de Movable Type',
    'Movable Type Community Forums' => 'Movable Type Community Forums', # Translate - New (4)
    'Change this message.' => 'Cambiar este mensaje.',
    'Edit this message.' => 'Edit this message.', # Translate - New (3)
    'Here is an overview of [_1].' => 'Here is an overview of [_1].', # Translate - New (6)
    'Recent Entries' => 'Recent Entries', # Translate - New (2)
    'Recent Comments' => 'Recent Comments', # Translate - New (2)
    'Recent TrackBacks' => 'Recent TrackBacks', # Translate - New (2)

    ## ./tmpl/cms/template_table.tmpl
    'Dynamic' => 'Dinámico',
    'Linked' => 'Enlazado',
    'Built w/Indexes' => 'Generar con índices',

    ## ./tmpl/cms/cc_return.tmpl

    ## ./tmpl/cms/login.tmpl
    'Your Movable Type session has ended. If you wish to log in again, you can do so below.' => 'Finalizó su sesión en Movable Type. Si desea volver a iniciar una sesión, puede hacerlo debajo.',
    'Your Movable Type session has ended. Please login again to continue this action.' => 'Finalizó su sesión en Movable. Por favor, iníciela de nuevo para continuar esta acción.',
    'Remember me?' => '¿Recordarme?',
    'Log In' => 'Iniciar sesión',
    'Forgot your password?' => 'Olvidó su contraseña?',

    ## ./tmpl/cms/handshake_return.tmpl

    ## ./tmpl/cms/category_add.tmpl
    'Add A Category' => 'Crear una categoría',
    'To create a new category, enter a title in the field below, select a parent category, and click the Add button.' => 'Para crear una nueva categoría, introduzca un título en el campo siguiente, seleccione una categoría superior y haga clic en el botón Crear.',
    'Category Title:' => 'Título de la categoría:',
    'Parent Category:' => 'Categoría superior:',
    'Save category (s)' => 'Save category (s)', # Translate - New (3)

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
    'IP address' => 'IP address', # Translate - New (2)
    'IP addresses' => 'direcciones IP',

    ## ./tmpl/cms/list_ping.tmpl
    'The selected TrackBack(s) has been published.' => 'Se publicaron los TrackBacks seleccionados.',
    'All junked TrackBacks have been removed.' => 'All junked TrackBacks have been removed.', # Translate - New (6)
    'The selected TrackBack(s) has been unpublished.' => 'Se marcaron como no publicados los TrackBacks seleccionados.',
    'The selected TrackBack(s) has been junked.' => 'Se marcaron como basura los TrackBacks seleccionados.',
    'The selected TrackBack(s) has been unjunked.' => 'Se desmarcaron como basura los TrackBacks seleccionados.',
    'The selected TrackBack(s) has been deleted from the database.' => 'Se eliminaron de la base de datos los TrackBacks seleccionados.',
    'No TrackBacks appeared to be junk.' => 'No hay TrackBacks que parezcan basura.',
    'Junk TrackBacks' => 'TrackBacks basura',
    'Trackback Feed' => 'Trackback Feed', # Translate - New (2)
    'Trackback Feed (Disabled)' => 'Trackback Feed (Disabled)', # Translate - New (3)
    'Show unpublished TrackBacks.' => 'Mostrar TrackBacks no publicados.',
    '(Showing all TrackBacks.)' => '(Showing all TrackBacks.)', # Translate - New (4)
    'Showing only TrackBacks where [_1] is [_2].' => 'Showing only TrackBacks where [_1] is [_2].', # Translate - New (7)
    'TrackBacks.' => 'TrackBacks.', # Translate - Previous (1)
    'TrackBacks where' => 'TrackBacks donde',
    'No TrackBacks could be found.' => 'No se encontraron TrackBacks.',
    'No junk TrackBacks could be found.' => 'No se encontraron TrackBacks basura.',

    ## ./tmpl/cms/header.tmpl
    'Go to:' => 'Go to:', # Translate - New (2)
    'Select a blog' => 'Select a blog', # Translate - New (3)
    'System-wide listing' => 'Lista del sistema',
    'Search (q)' => 'Search (q)', # Translate - New (2)

    ## ./tmpl/cms/admin.tmpl
    'System Stats' => 'Estadísticas del sistema',
    'Active Authors' => 'Autores activos',
    'Version' => 'Versión',
    'Essential Links' => 'Enlaces esenciales',
    'System Information' => 'Información del sistema',
    'Movable Type Home' => 'Movable Type - Inicio',
    'Plugin Directory' => 'Directorio de plugins',
    'Support and Documentation' => 'Soporte y documentación',
    'https://secure.sixapart.com/t/account' => 'https://secure.sixapart.com/t/account', # Translate - New (6)
    'Your Account' => 'Su cuenta',
    'https://secure.sixapart.com/t/help?__mode=edit' => 'https://secure.sixapart.com/t/help?__mode=edit', # Translate - New (8)
    'Open a Help Ticket' => 'Open a Help Ticket', # Translate - New (4)
    'Paid License Required' => 'Paid License Required', # Translate - New (3)
    'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype/', # Translate - New (5)
    'http://www.sixapart.com/pronet/plugins/' => 'http://www.sixapart.com/pronet/plugins/', # Translate - New (6)
    'https://secure.sixapart.com/t/help?__mode=kb' => 'https://secure.sixapart.com/t/help?__mode=kb', # Translate - New (8)
    'Knowledge Base' => 'Base de conocimiento',
    'http://www.sixapart.com/pronet/' => 'http://www.sixapart.com/pronet/', # Translate - New (5)
    'Professional Network' => 'Professional Network', # Translate - Previous (2)
    'From this screen, you can view information about and manage many aspects of your system across all weblogs.' => 'Desde esta pantalla, puede consultar la información sobre el sistema y administrar muchos aspectos que afectan a todos los weblogs.',

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
    'Switch to Detailed Settings' => 'Switch to Detailed Settings', # Translate - New (4)
    'Registered Plugins' => 'Plugins registrados',
    'Disable Plugins' => 'Desactivar plugins',
    'Enable Plugins' => 'Activar plugins',
    'Failed to Load' => 'Falló al cargar',
    'Disable' => 'Desactivar',
    'Enabled' => 'Activado',
    'Enable' => 'Activar',
    'Documentation for [_1]' => 'Documentación sobre [_1]',
    'Documentation' => 'Documentación',
    'Author of [_1]' => 'Autor de [_1]',
    'More about [_1]' => 'Más sobre [_1]',
    'Support' => 'soporte',
    'Plugin Home' => 'Web del plugin',
    'Resources' => 'Recursos',
    'Show Resources' => 'Mostrar recursos',
    'Run' => 'Run', # Translate - New (1)
    'Run [_1]' => 'Run [_1]', # Translate - New (2)
    'Show Settings' => 'Mostrar preferencias',
    'Settings for [_1]' => 'Configuración de [_1]',
    'Resources Provided by [_1]' => 'Recursos provistos por [_1]',
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
    'All junked comments have been removed.' => 'All junked comments have been removed.', # Translate - New (6)
    'The selected comment(s) has been unpublished.' => 'Se desmarcaron como publicados los comentarios seleccionados.',
    'The selected comment(s) has been junked.' => 'Se marcaron como basura los comentarios seleccionados.',
    'The selected comment(s) has been unjunked.' => 'Se desmarcaron como basura los comentarios seleccionados.',
    'The selected comment(s) has been deleted from the database.' => 'Los comentarios seleccionados fueron eliminados de la base de datos.',
    'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be Banned or Trusted.' => 'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be Banned or Trusted.', # Translate - New (19)
    'No comments appeared to be junk.' => 'No hay comentarios que parezcan basura.',
    'Comment Feed' => 'Comment Feed', # Translate - New (2)
    'Comment Feed (Disabled)' => 'Comment Feed (Disabled)', # Translate - New (3)
    'Show unpublished comments.' => 'Mostrar comentarios no publicados.',
    '(Showing all comments.)' => '(Showing all comments.)', # Translate - New (4)
    'Showing only comments where [_1] is [_2].' => 'Showing only comments where [_1] is [_2].', # Translate - New (7)
    'comments.' => 'comentarios.',
    'comments where' => 'comentarios donde',
    'No comments could be found.' => 'No se encontró ningún comentario.',
    'No junk comments could be found.' => 'No se encontró ningún comentario basura.',

    ## ./tmpl/cms/footer-popup.tmpl

    ## ./tmpl/cms/system_info.tmpl
    'System Status and Information' => 'Estado e información del sistema',
    'This page will soon contain information about the server environment availability of required perl modules, installed plugins and other information useful for expediting debugging in technical support requests.' => 'This page will soon contain information about the server environment availability of required perl modules, installed plugins and other information useful for expediting debugging in technical support requests.', # Translate - New (28)

    ## ./tmpl/cms/import_end.tmpl
    'All data imported successfully!' => 'All data imported successfully!', # Translate - New (4)
    'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.', # Translate - New (30)
    'An error occurred during the import process: [_1]. Please check your import file.' => 'Ocurrió un error durante el proceso de importación: [_1]. Por favor, compruebe su fichero de importación.',

    ## ./tmpl/cms/cfg_simple.tmpl
    'This screen allows you to control all settings specific to this weblog.' => 'This screen allows you to control all settings specific to this weblog.', # Translate - New (12)
    'Your settings have been saved.' => 'Configuración guardada.',
    'Publishing Paths' => 'Rutas de publicación',
    'Enter the URL of your website. Do not include a filename (i.e. exclude index.html).' => 'Teclee la URL de su sitio. No incluya nombres de archivos (p.e. excluya index.html).',
    'Site Root:' => 'Raíz del sitio:',
    'Enter the path where your index files will be published. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'Teclee la ruta donde se publicarán los ficheros índices. Se recomienda especificar la ruta absoluta (comenzando con \'/\'), pero también puede usar una ruta relativa al directorio de Movable Type.',
    'You can configure the publishing model for this blog (static vs dynamic) on the <a href=' => 'You can configure the publishing model for this blog (static vs dynamic) on the <a href=', # Translate - New (16)
    'Choose to display a number of recent entries or entries from a recent number of days.' => 'Choose to display a number of recent entries or entries from a recent number of days.', # Translate - New (16)
    'Specify which types of commenters will be allowed to leave comments on this weblog.' => 'Specify which types of commenters will be allowed to leave comments on this weblog.', # Translate - New (14)
    'If you want to require visitors to sign in before leaving a comment, set up authentication with the free TypeKey service.' => 'If you want to require visitors to sign in before leaving a comment, set up authentication with the free TypeKey service.', # Translate - New (21)
    'Specify what should happen to comments after submission. Unpublished comments are held for moderation and junk comments do not appear.' => 'Specify what should happen to comments after submission. Unpublished comments are held for moderation and junk comments do not appear.', # Translate - New (20)
    'Accept TrackBacks from people who link to your weblog.' => 'Accept TrackBacks from people who link to your weblog.', # Translate - New (9)
    'License' => 'License', # Translate - New (1)

    ## ./tmpl/cms/upload_confirm.tmpl
    'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'El fichero llamado \'[_1]\' ya existe. ¿Desea sobreescribirlo?',

    ## ./tmpl/cms/recover.tmpl
    'Your password has been changed, and the new password has been sent to your email address ([_1]).' => 'Se cambió su contraseña y la nueva se le ha enviado a su dirección de correo electrónico ([_1]).',
    'Enter your Movable Type username:' => 'Introduzca su nombre de usuario de Movable Type:',
    'Enter your password hint:' => 'Teclee la pista de su contraseña:',
    'Recover' => 'Recuperar',

    ## ./tmpl/cms/show_upload_html.tmpl
    'Copy and paste this HTML into your entry.' => 'Copiar y pegar el siguiente código HTML en su entrada.',
    'Upload Another' => 'Transferir otra',

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
    'No template modules could be found.' => 'No se encontró ninguna plantilla de módulos.',

    ## ./tmpl/cms/install.tmpl
    'Welcome to Movable Type!' => '¡Bienvenido a Movable Type!',
    'Do you want to proceed with the installation anyway?' => 'Do you want to proceed with the installation anyway?', # Translate - New (9)
    'Before you can begin blogging, we need to complete your installation by initializing your database.' => 'Antes de que comience a publicar, debe completar la instalación inicializando la base de datos.',
    'You will need to select a username and password for the administrator account.' => 'You will need to select a username and password for the administrator account.', # Translate - New (13)
    'Password:' => 'Password:', # Translate - New (1)
    'Select a password for your account.' => 'Select a password for your account.', # Translate - New (6)
    'Finish Install' => 'Finalizar instalación',

    ## ./tmpl/cms/rebuilt.tmpl
    'All of your files have been rebuilt.' => 'Se reconstruyeron todos sus ficheros.',
    'Your [_1] has been rebuilt.' => 'Su [_1] ha sido reconstruido.',
    'Your [_1] pages have been rebuilt.' => 'Sus [_1] páginas han sido reconstruidas.',
    'View your site' => 'Ver su sitio',
    'View this page' => 'Ver esta página',
    'Rebuild Again' => 'Regenerar de nuevo',

    ## ./tmpl/cms/itemset_action_widget.tmpl
    'More actions...' => 'Más acciones...',
    'No actions' => 'Ninguna acción',

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

    ## ./tmpl/cms/reload_opener.tmpl

    ## ./tmpl/cms/bm_posted.tmpl
    'Your new entry has been saved to [_1]' => 'Su nueva entrada se guardó en [_1]',
    ', and it has been posted to your site' => ' e insertado en su sitio.',
    '. ' => '. ', # Translate - New (0)
    'Edit this entry' => 'Editar esta entrada',

    ## ./tmpl/cms/overview-left-nav.tmpl
    'List Weblogs' => 'Listar weblogs',
    'List Authors' => 'Listar autores',
    'List Plugins' => 'Listar plugins',
    'Aggregate' => 'Listar',
    'List Tags' => 'List Tags', # Translate - New (2)
    'Edit System Settings' => 'Editar configuración del sistema',
    'Show Activity Log' => 'Mostrar histórico de actividad',

    ## ./tmpl/cms/upload_complete.tmpl
    'The file named \'[_1]\' has been uploaded. Size: [quant,_2,byte].' => 'The file named \'[_1]\' has been uploaded. Size: [quant,_2,byte].', # Translate - New (11)
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
    'Select a weblog for this post:' => 'Seleccionar un weblog para esta entrada:',
    'Send an outbound TrackBack:' => 'Enviar un TrackBack saliente:',
    'Select an entry to send an outbound TrackBack:' => 'Seleccionar una entrada para enviar un TrackBack saliente:',
    'Accept' => 'Accept', # Translate - New (1)
    'You do not have entry creation permission for any weblogs on this installation. Please contact your system administrator for access.' => 'No tiene permiso de creación de entradas en esta instalación. Por favor, contacte con su administrador de sistemas para el acceso.',

    ## ./tmpl/cms/system_list_blog.tmpl
    'Are you sure you want to delete this weblog?' => 'Are you sure you want to delete this weblog?', # Translate - New (9)
    'Below you find a list of all weblogs in the system with links to the main weblog page and individual settings pages for each.  You may also create or delete blogs from this screen.' => 'Debajo encontrará una lista de todos los weblogs del sistema, con enlaces a las páginas principales y preferencias de cada weblog. También podrá crear o eliminar blogs desde esta pantalla.',
    'You have successfully deleted the blogs from the Movable Type system.' => 'Eliminó correctamente los weblogs.',
    'Create New Weblog' => 'Crear weblog',
    'No weblogs could be found.' => 'No se encontró ningún weblog.',

    ## ./tmpl/cms/cfg_archives.tmpl
    'Are you sure you want to delete this template map?' => 'Are you sure you want to delete this template map?', # Translate - New (10)
    'You must set a valid Site URL.' => 'You must set a valid Site URL.', # Translate - New (7)
    'You must set a valid Local Site Path.' => 'You must set a valid Local Site Path.', # Translate - New (8)
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
    'Archive Root:' => 'Raíz de archivos:',
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
    'To upload a file to your server, click on the browse button to locate the file on your hard drive.' => 'Para transferir un fichero a su servidor, haga clic en el botón Examinar para localizar el archivo en su disco duro.',
    'File:' => 'Fichero:',
    'Set Upload Path' => 'Set Upload Path', # Translate - New (3)
    '(Optional)' => '(opcional)',
    'Path:' => 'Path:', # Translate - New (1)
    'Site Root' => 'Site Root', # Translate - New (2)
    'Archive Root' => 'Archive Root', # Translate - New (2)
    'Upload' => 'Transferir',

    ## ./tmpl/cms/cfg_entries_edit_page.tmpl
    'Default Entry Editor Display Options' => 'Default Entry Editor Display Options', # Translate - New (5)

    ## ./tmpl/cms/recover_password_result.tmpl
    'Recover Passwords' => 'Recover Passwords', # Translate - New (2)
    'No authors were selected to process.' => 'No authors were selected to process.', # Translate - New (6)

    ## ./tmpl/cms/edit_admin_permissions.tmpl

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
    'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:', # Translate - New (17)
    'If the link is not clickable, just copy and paste it into your browser.' => 'Si no puede hacer clic en el enlace, copie y péguelo en su navegador.',

    ## ./tmpl/email/recover-password.tmpl

    ## ./tmpl/email/notify-entry.tmpl
    '[_1] Update: [_2]' => '[_1] Actualiza: [_2]',

    ## ./tmpl/email/footer-email.tmpl
    'Powered by Movable Type' => 'Powered by Movable Type', # Translate - New (4)
    'Version [_1]' => 'Version [_1]', # Translate - New (2)

    ## ./tmpl/feeds/feed_entry.tmpl

    ## ./tmpl/feeds/feed_comment.tmpl

    ## ./tmpl/feeds/feed_system.tmpl

    ## ./tmpl/feeds/login.tmpl
    'Movable Type Activity Log' => 'Movable Type Activity Log', # Translate - New (4)
    'Movable Type System Activity' => 'Movable Type System Activity', # Translate - New (4)
    'This link is invalid. Please resubscribe to your activity feed.' => 'This link is invalid. Please resubscribe to your activity feed.', # Translate - New (10)

    ## ./tmpl/feeds/error.tmpl

    ## ./tmpl/feeds/feed_ping.tmpl

    ## ./tmpl/feeds/feed_chrome.tmpl

    ## ./tmpl/wizard/optional.tmpl
    'Step' => 'Step', # Translate - New (1)
    'Mail Configuration' => 'Mail Configuration', # Translate - New (2)
    'You can configure you mail settings from here, or you can complete the configuration wizard by clicking \'Continue\'.' => 'You can configure you mail settings from here, or you can complete the configuration wizard by clicking \'Continue\'.', # Translate - New (18)
    'An error occurred while attempting to send mail: ' => 'An error occurred while attempting to send mail: ', # Translate - New (8)
    'MailTransfer' => 'MailTransfer', # Translate - New (1)
    'Select One...' => 'Select One...', # Translate - New (2)
    'SendMailPath' => 'SendMailPath', # Translate - New (1)
    'The physical file path for your sendmail.' => 'The physical file path for your sendmail.', # Translate - New (7)
    'SMTP Server' => 'SMTP Server', # Translate - New (2)
    'Address of your SMTP Server' => 'Address of your SMTP Server', # Translate - New (5)
    'Mail address for test sending' => 'Mail address for test sending', # Translate - New (5)
    'Your mail configuration is successfully.' => 'Your mail configuration is successfully.', # Translate - New (5)
    'Back' => 'Back', # Translate - New (1)
    'Send Test Email' => 'Send Test Email', # Translate - New (3)

    ## ./tmpl/wizard/complete.tmpl
    'Congratulations! You\'ve successfully configured [_1] [_2].' => 'Congratulations! You\'ve successfully configured [_1] [_2].', # Translate - New (7)
    'This is a copy of your configuration settings.' => 'This is a copy of your configuration settings.', # Translate - New (8)
    'We were unable to create your configuration file. If you would like to check the directory permissions and retry, click the \'Retry\' button.' => 'We were unable to create your configuration file. If you would like to check the directory permissions and retry, click the \'Retry\' button.', # Translate - New (23)
    'Retry' => 'Retry', # Translate - New (1)
    'Install' => 'Install', # Translate - New (1)

    ## ./tmpl/wizard/header.tmpl
    'Movable Type Configuration Wizard' => 'Movable Type Configuration Wizard', # Translate - New (4)

    ## ./tmpl/wizard/start.tmpl
    'Welcome to the Movable Type Configuration Wizard' => 'Welcome to the Movable Type Configuration Wizard', # Translate - New (7)
    'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.', # Translate - New (19)
    'Your Movable Type configuration file already exists. The Wizard cannot continue with this file present.' => 'Your Movable Type configuration file already exists. The Wizard cannot continue with this file present.', # Translate - New (15)
    'The Movable Type Configuration Wizard will help you set up your Perl installation, your database connection, and your mail settings. Click on \'Begin\' below to get started.' => 'The Movable Type Configuration Wizard will help you set up your Perl installation, your database connection, and your mail settings. Click on \'Begin\' below to get started.', # Translate - New (27)
    'It appears that you need to set your static webpath. This is where static files such as stylesheets and images will reside. Please enter where your static webpath is below.' => 'It appears that you need to set your static webpath. This is where static files such as stylesheets and images will reside. Please enter where your static webpath is below.', # Translate - New (30)
    'Where is your static webpath?' => 'Where is your static webpath?', # Translate - New (5)
    'Begin' => 'Begin', # Translate - New (1)

    ## ./tmpl/wizard/footer.tmpl

    ## ./tmpl/wizard/packages.tmpl
    'Requirements Check' => 'Requirements Check', # Translate - New (2)
    'One of the following Perl packages are required in order to make a database connection.  Movable Type requires a database in order to store your weblog data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the \'Retry\' button.' => 'One of the following Perl packages are required in order to make a database connection.  Movable Type requires a database in order to store your weblog data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the \'Retry\' button.', # Translate - New (47)
    'Missing Database Packages' => 'Missing Database Packages', # Translate - New (3)
    'The following Perl packages are missing from your installation. These packages are not required to install Movable Type.  They will enhance the features available to Movable Type.  If you want to continue without installing these packages, click the \'Continue\' button to configure your database.  Otherwise, click the \'Retry\' button to re-test for these packages.' => 'The following Perl packages are missing from your installation. These packages are not required to install Movable Type.  They will enhance the features available to Movable Type.  If you want to continue without installing these packages, click the \'Continue\' button to configure your database.  Otherwise, click the \'Retry\' button to re-test for these packages.', # Translate - New (54)
    'Missing Optional Packages' => 'Missing Optional Packages', # Translate - New (3)
    'The following Perl packages are required for Movable Type to run properly. Once you have met these requirements, click the \'Retry\' button to re-test for these packages.' => 'The following Perl packages are required for Movable Type to run properly. Once you have met these requirements, click the \'Retry\' button to re-test for these packages.', # Translate - New (27)
    'Missing Required Packages' => 'Missing Required Packages', # Translate - New (3)
    'Minimal version requirement:' => 'Minimal version requirement:', # Translate - New (3)
    'Installation instructions.' => 'Installation instructions.', # Translate - New (2)
    'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'Your server has all of the required modules installed; you do not need to perform any additional module installations.', # Translate - New (19)

    ## ./tmpl/wizard/configure.tmpl
    'Database Configuration' => 'Database Configuration', # Translate - New (2)
    'Your database configuration is complete. Click \'Continue\' below to configure your mail settings.' => 'Your database configuration is complete. Click \'Continue\' below to configure your mail settings.', # Translate - New (13)
    'Please enter the parameters necessary for connecting to your database.If your database type is not listed in the dropdown below, you may be missing the Perl module necessary to connect to your database.  If this is the case, please check your installation and click <a href=' => 'Please enter the parameters necessary for connecting to your database.If your database type is not listed in the dropdown below, you may be missing the Perl module necessary to connect to your database.  If this is the case, please check your installation and click <a href=', # Translate - New (47)
    'An error occurred while attempting to connect to the database: ' => 'An error occurred while attempting to connect to the database: ', # Translate - New (10)
    'Database' => 'Database', # Translate - New (1)
    'Database Path' => 'Database Path', # Translate - New (2)
    'The physical file path for your BerkeleyDB or SQLite database. ' => 'The physical file path for your BerkeleyDB or SQLite database. ', # Translate - New (10)
    'A default location of \'./db\' will store the database file(s) underneath your Movable Type directory.' => 'A default location of \'./db\' will store the database file(s) underneath your Movable Type directory.', # Translate - New (16)
    'Database Name' => 'Database Name', # Translate - New (2)
    'The name of your SQL database (this database must already exist).' => 'The name of your SQL database (this database must already exist).', # Translate - New (11)
    'The username to login to your SQL database.' => 'The username to login to your SQL database.', # Translate - New (8)
    'The password to login to your SQL database.' => 'The password to login to your SQL database.', # Translate - New (8)
    'Database Server' => 'Database Server', # Translate - New (2)
    'This is usually \'localhost\'.' => 'This is usually \'localhost\'.', # Translate - New (4)
    'Database Port' => 'Database Port', # Translate - New (2)
    'This can usually be left blank.' => 'This can usually be left blank.', # Translate - New (6)
    'Database Socket' => 'Database Socket', # Translate - New (2)
    'Test Connection' => 'Test Connection', # Translate - New (2)

    ## ./tmpl/wizard/mt-config.tmpl

    ## ./build/exportmt.pl

    ## ./build/l10n/trans.pl

    ## ./build/l10n/diff.pl

    ## ./build/l10n/wrap.pl

    ## Other phrases, with English translations.
    'WEEKLY_ADV' => 'Semanalmente',
    'Unpublish Comment(s)' => 'No publicar comentario/s',
    '_SYSTEM_TEMPLATE_COMMENT_PENDING' => 'Mostrado cuando un comentario está moderado o marcado como basura.',
    '_USAGE_ENTRY_LIST_OVERVIEW' => '_USAGE_ENTRY_LIST_OVERVIEW', # Translate - New (5)
    '_BLOG_CONFIG_MODE_DETAIL' => '_BLOG_CONFIG_MODE_DETAIL', # Translate - New (5)
    'RSS 1.0 Index' => 'Índice RSS 1.0',
    'Manage Categories' => 'Administrar categorías',
    '_USAGE_BOOKMARKLET_4' => 'Después de instalar QuickPost, puede crear una entrada desde cualquier punto de Internet. Cuando esté visualizando una página y desee escribir sobre la misma, haga clic en "QuickPost" para abrir una ventana emergente especial de edición de Movable Type. Desde esa ventana puede seleccionar el weblog en el que desea publicar, luego escribir su entrada y guardarla.',
    '_USAGE_ARCHIVING_2' => 'Si asocia múltiples plantillas a un determinado tipo de archivado (aunque asocie solamente una), puede personalizar la ruta de salida utilizando las plantillas de archivos.',
    'Remove Tags...' => 'Remove Tags...', # Translate - New (2)
    'UTC+11' => 'UTC+11', # Translate - Previous (2)
    '_BLOG_CONFIG_MODE_BASIC' => '_BLOG_CONFIG_MODE_BASIC', # Translate - New (5)
    'View Activity Log For This Weblog' => 'Ver registro de actividades de este weblog',
    'DAILY_ADV' => 'Diariamente',
    '_USAGE_PERMISSIONS_3' => 'Existen dos maneras de editar autores y otorgarles o denegarles privilegios de acceso. Para acceder rápidamente, seleccione un usuario en el menú siguiente y seleccione Editar. Alternativamente, puede desplazarse por la lista completa de autores y desde allí seleccionar el nombre que desea editar o eliminar.',
    'Tags to remove from selected entries' => 'Tags to remove from selected entries', # Translate - New (6)
    '_NOTIFY_REQUIRE_CONFIRMATION' => '_NOTIFY_REQUIRE_CONFIRMATION', # Translate - New (4)
    '_USAGE_NOTIFICATIONS' => 'A continuación se muestra la lista de usuarios que desean recibir una notificación cuando usted realice alguna nueva contribución en su sitio. Para crear un nuevo usuario, introduzca su dirección de correo electrónico en el formulario siguiente. El campo URL es opcional. Para eliminar un usuario, active la casilla Eliminar en la tabla siguiente y presione el botón ELIMINAR.',
    'Manage Notification List' => 'Administrar lista de notificaciones',
    'Individual' => 'Individual', # Translate - Previous (1)
    '_USAGE_COMMENTERS_LIST' => 'Ésta es la lista de comentaristas de [_1].',
    'RSS 2.0 Index' => 'Índice RSS 2.0',
    '_USAGE_BANLIST' => 'Debajo aparece la lista de direcciones IP a las que ha prohibido insertar comentarios o enviar pings de TrackBack a su sitio. Para crear una nueva dirección IP, introduzca la dirección en el formulario siguiente. Para borrar una dirección IP bloqueada, active la casilla Eliminar en la tabla siguiente y presione el botón ELIMINAR.',
    '_ERROR_DATABASE_CONNECTION' => 'Las opciones de configuración de su base de datos o son incorrectas o no están presentes en el fichero de configuración de Movable Type. Por favor, consulte la sección <a href="#">Instalación y configuración</a> del manual de Movable Type para más información',
    'Select a Design using StyleCatcher' => 'Select a Design using StyleCatcher', # Translate - New (5)
    'Configure Weblog' => 'Configurar weblog',
    '_INDEX_INTRO' => '_INDEX_INTRO', # Translate - New (3)
    '_USAGE_AUTHORS' => 'Ésta es la lista de todos los usuarios registrados en el sistema de Movable Type. Puede editar los permisos de un autor haciendo clic en su nombre; para eliminar permanentemente varios autores, active las casillas <b>Eliminar</b> correspondientes y presione ELIMINAR. NOTA: Si solamente desea desasignar un autor de un weblog determinado, edite los permisos del autor; el borrado de un autor mediante ELIMINAR lo elimina completamente del sistema.',
    '_USAGE_FEEDBACK_PREFS' => 'Esta pantalla le permite configurar la forma en que sus lectores pueden contribuir en su blog.',
    '_USAGE_COMMENTS_LIST_ALL_WEBLOGS' => 'Ésta es la lista de comentarios de todos los weblogs. Puede editar cualquier comentario haciendo clic en el TEXTO DEL COMENTARIO. Para FILTRAR las entradas, haga clic en uno de los valores de la lista.',
    '_USAGE_NEW_AUTHOR' => 'Desde esta pantalla puede crear un nuevo autor en el sistema y darle acceso a weblogs individualmente.',
    '_USAGE_FORGOT_PASSWORD_2' => 'Debería poder iniciar una sesión en Movable Type con esta nueva contraseña. Después de iniciar la sesión, cambie su contraseña a otra que pueda memorizar y recordar fácilmente.',
    '_USAGE_COMMENT' => 'Edite el comentario seleccionado. Presione GUARDAR cuando haya terminado. Para que estos cambios entren en vigor, deberá ejecutar el proceso de reconstrucción.',
    '_USAGE_FORGOT_PASSWORD_1' => 'Solicitó la recuperación de su contraseña de Movable Type. Su contraseña se ha modificado en el sistema; ésta es su nueva contraseña:',
    '_USAGE_COMMENTS_LIST_OVERVIEW' => '_USAGE_COMMENTS_LIST_OVERVIEW', # Translate - New (5)
    '_USAGE_EXPORT_2' => 'Para exportar sus entradas, haga clic en el enlace que aparece debajo ("Exportar entradas desde [_1]"). Para guardar los datos exportados en un fichero, mantenga presionada la tecla <code>opción</code> del Macintosh (o la tecla <code>Mayús</code> si trabaja con un PC) y haga clic en el enlace. También puede seleccionar todos los datos y luego copiarlos en otro documento. (<a href="#" onclick="openManual(\'importing\', \'export_ie\');return false;">¿Exportando desde Internet Explorer?</a>)',
    '_SYSTEM_TEMPLATE_POPUP_IMAGE' => 'Mostrado cuando un visitante hace click en la ventana emergente de una imagen.',
    '_USAGE_PING_LIST_ALL_WEBLOGS' => 'Ésta es la lista de pings de todos los weblogs.',
    '_SEARCH_SIDEBAR' => '_SEARCH_SIDEBAR', # Translate - New (3)
    '_SYSTEM_TEMPLATE_DYNAMIC_ERROR' => 'Mostrado cuando se encuentra un error en una página dinámica. ',
    'Manage my Widgets' => 'Manage my Widgets', # Translate - New (3)
    'Publish Entries' => 'Publicar entradas',
    'Date-Based Archive' => 'Archivo por fechas',
    'Unban Commenter(s)' => 'Desbloquear comentarista/s',
    'Individual Entry Archive' => 'Archivo de entradas individuales',
    'Daily' => 'Diariamente',
    '_USAGE_PING_LIST_OVERVIEW' => '_USAGE_PING_LIST_OVERVIEW', # Translate - New (5)
    'Unpublish Entries' => 'No publicar entradas',
    '_USAGE_UPLOAD' => 'Puede transferir el fichero anterior a la ruta local del sitio <a href="javascript:alert(\'[_1]\')">(?)</a> o a su ruta local de archivado <a href="javascript:alert(\'[_2]\')">(?)</a>. También puede transferir el fichero a cualquier subdirectorio de esos directorios, especificando la ruta en los cuadros de texto de la derecha (<i>images</i>, por ejemplo). Si el directorio aún no existe, se creará.',
    'AUTO DETECT' => 'AUTO DETECT', # Translate - New (2)
    '_USAGE_REBUILD' => '<a href="#" onclick="doRebuild()">REGENERAR</a> para ver esos cambios reflejados en su sitio público.',
    'Blog Administrator' => 'Administrador de blogs',
    'CATEGORY_ADV' => 'Por categoría',
    '_WARNING_PASSWORD_RESET_MULTI' => '_WARNING_PASSWORD_RESET_MULTI', # Translate - New (5)
    'Dynamic Site Bootstrapper' => 'Inicializador del sistema dinámico',
    '_USAGE_PLUGINS' => 'Lista de todos los plugins actualmente registrados en Movable Type.',
    '_USAGE_COMMENTS_LIST_BLOG' => '_USAGE_COMMENTS_LIST_BLOG', # Translate - New (5)
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
    'Add Tags...' => 'Add Tags...', # Translate - New (2)
    '_THROTTLED_COMMENT_EMAIL' => 'Se bloqueó automáticamente a una persona que visitó su weblog [_1] debido a que insertó más comentarios de los permitidos en menos de [_2] segundos. Esto se hizo para impedir que nadie o nada desborde malintencionadamente  su weblog con comentarios. La dirección bloqueada es la siguiente:

    [_3]

Si esta operación no es correcta, puede desbloquear la dirección IP y permitir al visitante reanudar sus comentarios. Para ello, inicie una sesión en su instalación de Movable Type, vaya a Configuración del weblog - Bloqueo de direcciones IP y elimine la dirección IP [_4] de la lista de direcciones bloqueadas.',
    'Stylesheet' => 'Hoja de estilo',
    'RSD' => 'RSD', # Translate - Previous (1)
    'MONTHLY_ADV' => 'Mensualmente',
    '_USAGE_ARCHIVE_MAPS' => 'Esta funcionalidad avanzada le permite mapear cualquier plantilla de archivos a múltiples tipos de archivos. Por ejemplo, podría crear dos vistas diferentes para sus archivos mensuales: una en la que las entradas de un mes particular se presentan como una lista y la otra en la que se representan las entradas en el calendario de ese mes.',
    'Trust Commenter(s)' => 'Confiar en comentarista/s',
    'Manage Tags' => 'Manage Tags', # Translate - New (2)
    '_THROTTLED_COMMENT' => 'En un esfuerzo por impedir la inserción de comentarios maliciosos por parte usuarios malévolos, se ha habilitado una función que obliga al comentarista del weblog esperar un tiempo determinado antes de poder realizar un nuevo comentario. Por favor, vuelva a insertar su comentario dentro de unos momentos. Gracias por su comprensión.',
    '_SYSTEM_TEMPLATE_COMMENT_PREVIEW' => 'Mostrado cuando un comentarista revisa la vista previa de su comentario.',
    'Manage Templates' => 'Administrar plantillas',
    '_USAGE_BOOKMARKLET_3' => 'Para instalar el marcador de QuickPost para Movable Type, arrastre el enlace siguiente al menú o barra de herramientas Favoritos de su navegador:',
    '_USAGE_PASSWORD_RESET' => '_USAGE_PASSWORD_RESET', # Translate - New (4)
    '_USAGE_SEARCH' => 'Puede utilizar la herramienta de búsqueda y reemplazo Buscar &amp; Reemplazar para realizar búsquedas en todas sus entradas, o bien para reemplazar cada ocurrencia de una palabra/frase/carácter por otra. IMPORTANTE: Ponga mucha atención al ejecutar un reemplazo, porque es una operación <b>irreversible</b>. Si va a efectuar un reemplazo masivo (es decir, en muchas entradas), es recomendable utilizar primero la función de exportación para hacer una copia de seguridad de sus entradas.',
    '_AUTO' => '1',
    '_external_link_target' => '_external_link_target', # Translate - New (4)
    '_USAGE_BOOKMARKLET_2' => 'QuickPost para Movable Type permite personalizar el diseño y los campos de la página de QuickPost. Por ejemplo, puede incluir la posibilidad de crear extractos a través de la ventana de QuickPost. De forma predeterminada, una ventana de QuickPost tendrá siempre: un menú desplegable correspondiente al weblog en el que se va a publicar, un menú desplegable para seleccionar el estado de publicación de la nueva entrada (Borrador o Publicar), un cuadro de texto para introducir el título de la entrada y un cuadro de texto para introducir el cuerpo de la entrada.',
    '_USAGE_PERMISSIONS_1' => 'Está editando los permisos de <b>[_1]</b>. Más abajo verá la lista de weblogs a los que tiene acceso como autor con permisos de edición; por cada weblog de la lista, asigne permisos a <b>[_1]</b>, activando las casillas correspondientes de los permisos de acceso que desea otorgar.',
    'Add/Manage Categories' => 'Add/Manage Categories', # Translate - New (3)
    '_USAGE_LIST_POWER' => 'Ésta es la lista de entradas de [_1] en el modo de edición por lotes. En el formulario siguiente puede cambiar cualesquier valor de cualesquier entrada mostrada; una vez introducidas las modificaciones deseadas, presione el botón GUARDAR. Los controles estándar "Listar y editar entradas" (filtros, paginación) funcionan del modo acostumbrado.',
    '_ERROR_CONFIG_FILE' => 'El fichero de configuración de Your Movable Type no existe o no se puede leer correctamente. Por favor, consulte la sección <a href="#">Instalación y configuración</a> del manual de Movable Type manual para más información.',
    '_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.org/sitees/">Movable Type <$MTVersion$></a>',
    '_WARNING_PASSWORD_RESET_SINGLE' => '_WARNING_PASSWORD_RESET_SINGLE', # Translate - New (5)
    '_USAGE_PING_LIST_BLOG' => '_USAGE_PING_LIST_BLOG', # Translate - New (5)
    'Monthly' => 'Mensualmente',
    '_USAGE_ARCHIVING_1' => 'Seleccione la periodicidad y los tipos de archivado que desee realizar en su sitio. Por cada tipo de archivado que elija, tendrá la opción de asignar múltiples plantillas de archivado, que se aplicarán a ese tipo en particular. Por ejemplo, puede crear dos vistas diferentes de sus archivos mensuales: una consistente en una página que contenga cada una de las entradas de un determinado mes y la otra consistente en una vista de calendario de ese mes.',
    'Tags to add to selected entries' => 'Tags to add to selected entries', # Translate - New (6)
    'Ban Commenter(s)' => 'Bloquear comentarista/s',
    '_USAGE_VIEW_LOG' => 'Active la casilla <a href="#" onclick="doViewLog()">Registro de actividades</a> correspondiente a ese error.',
    '_USAGE_PERMISSIONS_4' => 'Cada weblog puede tener múltiples autores. Para crear un autor, introduzca la información del usuario en el siguiente formulario. A continuación, seleccione los weblogs en los que tendrá algún tipo de privilegio como autor. Cuando presione GUARDAR y el usuario esté registrado en el sistema, podrá editar sus privilegios de autor.',
    '_USAGE_BOOKMARKLET_1' => 'La configuración de QuickPost para poder realizar contribuciones en Movable Type permite insertar y publicar con un solo clic sin necesidad alguna de utilizar la interfaz principal de Movable Type.',
    '_USAGE_ARCHIVING_3' => 'Seleccione el tipo de archivado al que desea crear una nueva plantilla de archivado. A continuación, seleccione la plantilla a asociar a ese tipo de archivado.',
    '_SYSTEM_TEMPLATE_SEARCH_TEMPLATE' => '_SYSTEM_TEMPLATE_SEARCH_TEMPLATE', # Translate - New (5)
    'UTC+10' => 'UTC+10', # Translate - Previous (2)
    '_USAGE_TAGS' => '_USAGE_TAGS', # Translate - New (3)
    'INDIVIDUAL_ADV' => 'Individualmente',
    '_USAGE_BOOKMARKLET_5' => 'Alternativamente, si está ejecutando Internet Explorer bajo Windows, puede instalar una opción "QuickPost" en el menú contextual de Windows. Haga clic en el enlace siguiente y acepte la petición del navegador de "Abrir" el fichero. A continuación, cierre y vuelva a abrir su navegador para crear el enlace al menú contextual.',
    '_ERROR_CGI_PATH' => 'La opción de configuración CGIPath no es válida o no se encuentra en el fichero de configuración de Movable Type. Por favor, consulte la sección <a href="#">Instalación y configuración</a> del manual de Movable Type manual para más información.',
    '_USAGE_IMPORT' => 'Utilice el mecanismo de importación para importar entradas de otro sistema de weblogs, como Blogger o Greymatter. Este manual proporciona instrucciones exhaustivas para la importación de entradas antiguas mediante este mecanismo; el formulario siguiente permite importar un lote de entradas después de que las haya exportado del otro CMS y haya colocado los ficheros exportados en el lugar correcto para que Movable Type los pueda encontrar. Antes de usar este formulario, consulte el manual para asegurarse de haber comprendido todas las opciones.',
    'Main Index' => 'Índice principal',
    '_SYSTEM_TEMPLATE_COMMENTS' => 'Mostrado cuando las ventanas emergentes de comentarios (obsoletas) están activadas.',
    '_USAGE_CATEGORIES' => 'Utilice categorías para agrupar sus entradas y así facilitar las referencias, archivados y weblogs. En el momento de crear o editar entradas, puede asignarles una categoría. Para editar una categoría anterior, haga clic en el título de la categoría. Para crear una subcategoría, haga clic en el botón "Crear" correspondiente. Para trasladar una subcategoría, haga clic en el botón "Trasladar" correspondiente.',
    '_USAGE_ENTRY_LIST_BLOG' => '_USAGE_ENTRY_LIST_BLOG', # Translate - New (5)
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
    'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.', # Translate - New (17)
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

    ## ./extlib/DateTime.pm

    ## ./extlib/DateTimePPExtra.pm

    ## ./extlib/CGI.pm

    ## ./extlib/JSON.pm

    ## ./extlib/DateTimePP.pm

    ## ./extlib/URI.pm

    ## ./extlib/LWP.pm

    ## ./extlib/Jcode.pm

    ## ./extlib/File/Temp.pm

    ## ./extlib/File/Listing.pm

    ## ./extlib/HTTP/Message.pm

    ## ./extlib/HTTP/Request.pm

    ## ./extlib/HTTP/Headers.pm

    ## ./extlib/HTTP/Cookies.pm

    ## ./extlib/HTTP/Date.pm

    ## ./extlib/HTTP/Response.pm

    ## ./extlib/HTTP/Negotiate.pm

    ## ./extlib/HTTP/Daemon.pm

    ## ./extlib/HTTP/Status.pm

    ## ./extlib/HTTP/Request/Common.pm

    ## ./extlib/HTTP/Headers/Util.pm

    ## ./extlib/HTTP/Headers/ETag.pm

    ## ./extlib/HTTP/Headers/Auth.pm

    ## ./extlib/Apache/SOAP.pm

    ## ./extlib/Apache/XMLRPC/Lite.pm

    ## ./extlib/Params/ValidateXS.pm

    ## ./extlib/Params/Validate.pm

    ## ./extlib/Params/ValidatePP.pm

    ## ./extlib/UDDI/Lite.pm

    ## ./extlib/Net/HTTP.pm

    ## ./extlib/Net/HTTPS.pm

    ## ./extlib/Net/HTTP/NB.pm

    ## ./extlib/Net/HTTP/Methods.pm

    ## ./extlib/XML/XPath.pm

    ## ./extlib/XML/Atom.pm

    ## ./extlib/XML/Elemental.pm

    ## ./extlib/XML/NamespaceSupport.pm

    ## ./extlib/XML/Simple.pm

    ## ./extlib/XML/SAX.pm

    ## ./extlib/XML/Atom/Person.pm

    ## ./extlib/XML/Atom/Server.pm

    ## ./extlib/XML/Atom/ErrorHandler.pm

    ## ./extlib/XML/Atom/API.pm

    ## ./extlib/XML/Atom/Thing.pm

    ## ./extlib/XML/Atom/Content.pm

    ## ./extlib/XML/Atom/Link.pm

    ## ./extlib/XML/Atom/Util.pm

    ## ./extlib/XML/Atom/Client.pm

    ## ./extlib/XML/Atom/Entry.pm

    ## ./extlib/XML/Atom/Author.pm

    ## ./extlib/XML/Atom/Feed.pm

    ## ./extlib/XML/XPath/Step.pm

    ## ./extlib/XML/XPath/XMLParser.pm

    ## ./extlib/XML/XPath/PerlSAX.pm

    ## ./extlib/XML/XPath/Expr.pm

    ## ./extlib/XML/XPath/Boolean.pm

    ## ./extlib/XML/XPath/Root.pm

    ## ./extlib/XML/XPath/Variable.pm

    ## ./extlib/XML/XPath/Node.pm

    ## ./extlib/XML/XPath/LocationPath.pm

    ## ./extlib/XML/XPath/Function.pm

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

    ## ./extlib/XML/Elemental/Node.pm

    ## ./extlib/XML/Elemental/Element.pm

    ## ./extlib/XML/Elemental/SAXHandler.pm

    ## ./extlib/XML/Elemental/Util.pm

    ## ./extlib/XML/Elemental/Document.pm

    ## ./extlib/XML/Elemental/Characters.pm

    ## ./extlib/XML/SAX/ParserFactory.pm

    ## ./extlib/XML/SAX/Base.pm

    ## ./extlib/XML/SAX/Exception.pm

    ## ./extlib/XML/SAX/PurePerl.pm

    ## ./extlib/XML/SAX/DocumentLocator.pm

    ## ./extlib/XML/SAX/PurePerl/DebugHandler.pm

    ## ./extlib/XML/SAX/PurePerl/NoUnicodeExt.pm

    ## ./extlib/XML/SAX/PurePerl/DTDDecls.pm

    ## ./extlib/XML/SAX/PurePerl/DocType.pm

    ## ./extlib/XML/SAX/PurePerl/UnicodeExt.pm

    ## ./extlib/XML/SAX/PurePerl/XMLDecl.pm

    ## ./extlib/XML/SAX/PurePerl/Productions.pm

    ## ./extlib/XML/SAX/PurePerl/Exception.pm

    ## ./extlib/XML/SAX/PurePerl/EncodingDetect.pm

    ## ./extlib/XML/SAX/PurePerl/Reader.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/NoUnicodeExt.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/String.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/UnicodeExt.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/Stream.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/URI.pm

    ## ./extlib/XML/Parser/Style/Elemental.pm

    ## ./extlib/LWP/MediaTypes.pm

    ## ./extlib/LWP/Debug.pm

    ## ./extlib/LWP/Simple.pm

    ## ./extlib/LWP/RobotUA.pm

    ## ./extlib/LWP/MemberMixin.pm

    ## ./extlib/LWP/UserAgent.pm

    ## ./extlib/LWP/ConnCache.pm

    ## ./extlib/LWP/Protocol.pm

    ## ./extlib/LWP/Protocol/gopher.pm

    ## ./extlib/LWP/Protocol/mailto.pm

    ## ./extlib/LWP/Protocol/GHTTP.pm

    ## ./extlib/LWP/Protocol/data.pm

    ## ./extlib/LWP/Protocol/ftp.pm

    ## ./extlib/LWP/Protocol/file.pm

    ## ./extlib/LWP/Protocol/http.pm

    ## ./extlib/LWP/Protocol/nntp.pm

    ## ./extlib/LWP/Protocol/http10.pm

    ## ./extlib/LWP/Protocol/https.pm

    ## ./extlib/LWP/Protocol/nogo.pm

    ## ./extlib/LWP/Protocol/https10.pm

    ## ./extlib/LWP/Authen/Digest.pm

    ## ./extlib/LWP/Authen/Basic.pm

    ## ./extlib/HTML/Template.pm

    ## ./extlib/HTML/Form.pm

    ## ./extlib/XMLRPC/Lite.pm

    ## ./extlib/XMLRPC/Test.pm

    ## ./extlib/XMLRPC/Transport/TCP.pm

    ## ./extlib/XMLRPC/Transport/HTTP.pm

    ## ./extlib/XMLRPC/Transport/POP3.pm

    ## ./extlib/Class/ErrorHandler.pm

    ## ./extlib/Class/Accessor.pm

    ## ./extlib/Class/Accessor/Fast.pm

    ## ./extlib/JSON/Converter.pm

    ## ./extlib/JSON/Parser.pm

    ## ./extlib/I18N/LangTags.pm

    ## ./extlib/I18N/LangTags/List.pm

    ## ./extlib/Image/Size.pm

    ## ./extlib/WWW/RobotRules.pm

    ## ./extlib/WWW/RobotRules/AnyDBM_File.pm

    ## ./extlib/DateTime/Duration.pm

    ## ./extlib/DateTime/Infinite.pm

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

    ## ./extlib/URI/_query.pm

    ## ./extlib/URI/urn.pm

    ## ./extlib/URI/_server.pm

    ## ./extlib/URI/WithBase.pm

    ## ./extlib/URI/_generic.pm

    ## ./extlib/URI/news.pm

    ## ./extlib/URI/rtspu.pm

    ## ./extlib/URI/sips.pm

    ## ./extlib/URI/nntp.pm

    ## ./extlib/URI/http.pm

    ## ./extlib/URI/mailto.pm

    ## ./extlib/URI/QueryParam.pm

    ## ./extlib/URI/rtsp.pm

    ## ./extlib/URI/ftp.pm

    ## ./extlib/URI/pop.pm

    ## ./extlib/URI/snews.pm

    ## ./extlib/URI/Heuristic.pm

    ## ./extlib/URI/https.pm

    ## ./extlib/URI/URL.pm

    ## ./extlib/URI/_userpass.pm

    ## ./extlib/URI/_login.pm

    ## ./extlib/URI/data.pm

    ## ./extlib/URI/file.pm

    ## ./extlib/URI/ldap.pm

    ## ./extlib/URI/gopher.pm

    ## ./extlib/URI/_foreign.pm

    ## ./extlib/URI/rlogin.pm

    ## ./extlib/URI/sip.pm

    ## ./extlib/URI/telnet.pm

    ## ./extlib/URI/ssh.pm

    ## ./extlib/URI/rsync.pm

    ## ./extlib/URI/Escape.pm

    ## ./extlib/URI/_segment.pm

    ## ./extlib/URI/Fetch.pm

    ## ./extlib/URI/urn/isbn.pm

    ## ./extlib/URI/urn/oid.pm

    ## ./extlib/URI/file/QNX.pm

    ## ./extlib/URI/file/Base.pm

    ## ./extlib/URI/file/FAT.pm

    ## ./extlib/URI/file/Mac.pm

    ## ./extlib/URI/file/Win32.pm

    ## ./extlib/URI/file/OS2.pm

    ## ./extlib/URI/file/Unix.pm

    ## ./extlib/URI/Fetch/Response.pm

    ## ./extlib/Locale/Maketext.pm

    ## ./extlib/SOAP/Lite.pm

    ## ./extlib/SOAP/Test.pm

    ## ./extlib/SOAP/Transport/JABBER.pm

    ## ./extlib/SOAP/Transport/MAILTO.pm

    ## ./extlib/SOAP/Transport/TCP.pm

    ## ./extlib/SOAP/Transport/IO.pm

    ## ./extlib/SOAP/Transport/FTP.pm

    ## ./extlib/SOAP/Transport/LOCAL.pm

    ## ./extlib/SOAP/Transport/MQ.pm

    ## ./extlib/SOAP/Transport/HTTP.pm

    ## ./extlib/SOAP/Transport/POP3.pm

    ## ./extlib/CGI/Carp.pm

    ## ./extlib/CGI/Pretty.pm

    ## ./extlib/CGI/Cookie.pm

    ## ./extlib/CGI/Fast.pm

    ## ./extlib/CGI/Util.pm

    ## ./extlib/CGI/Push.pm

    ## ./extlib/CGI/Apache.pm

    ## ./extlib/CGI/Switch.pm

    ## ./extlib/Attribute/Params/Validate.pm

    ## ./extlib/IO/SessionData.pm

    ## ./extlib/IO/SessionSet.pm

    ## ./extlib/Jcode/Tr.pm

    ## ./extlib/Jcode/Constants.pm

    ## ./extlib/Jcode/H2Z.pm

    ## ./extlib/Jcode/Unicode/NoXS.pm

    ## ./extlib/Jcode/Unicode/Constants.pm

    ## ./extlib/MIME/Words.pm

    ## ./extlib/Math/BigInt.pm

    ## ./extlib/Math/BigInt/Scalar.pm

    ## ./extlib/Math/BigInt/Trace.pm

    ## ./extlib/Math/BigInt/Calc.pm

    ## ./lib/MT.pm
    'Message: [_1]' => 'Message: [_1]', # Translate - New (2)
    'Unnamed plugin' => 'Unnamed plugin', # Translate - New (2)
    '[_1] died with: [_2]' => '[_1] died with: [_2]', # Translate - New (5)
    'Plugin error: [_1] [_2]' => 'Plugin error: [_1] [_2]', # Translate - New (4)

    ## ./lib/MT/BasicAuthor.pm

    ## ./lib/MT/TaskMgr.pm
    'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.', # Translate - New (16)
    'Error during task \'[_1]\': [_2]' => 'Error during task \'[_1]\': [_2]', # Translate - New (5)
    'Task Update' => 'Task Update', # Translate - New (2)
    'The following tasks were run:' => 'The following tasks were run:', # Translate - New (5)

    ## ./lib/MT/Placement.pm

    ## ./lib/MT/Category.pm
    'Categories must exist within the same blog' => 'Categories must exist within the same blog', # Translate - New (7)
    'Category loop detected' => 'Category loop detected', # Translate - New (3)

    ## ./lib/MT/Bootstrap.pm
    'Got an error: [_1]' => 'Ocurrió un error en: [_1]',

    ## ./lib/MT/Image.pm
    'Can\'t load Image::Magick: [_1]' => 'No se pudo cargar Image::Magick: [_1]',
    'Reading file \'[_1]\' failed: [_2]' => 'Fallo leyendo archivo \'[_1]\': [_2]',
    'Reading image failed: [_1]' => 'Fallo leyendo imagen: [_1]',
    'Scaling to [_1]x[_2] failed: [_3]' => 'El escalado a [_1]x[_2] falló: [_3]',
    'Can\'t load IPC::Run: [_1]' => 'No se pudo cargar IPC::Run: [_1]',
    'You do not have a valid path to the NetPBM tools on your machine.' => 'No posee una ruta válida a las herramientas NetPBMYou en su máquina.',

    ## ./lib/MT/Session.pm

    ## ./lib/MT/Trackback.pm

    ## ./lib/MT/FileMgr.pm

    ## ./lib/MT/Sanitize.pm

    ## ./lib/MT/Notification.pm

    ## ./lib/MT/Blocklist.pm

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
    'Setting your permissions to administrator.' => 'Estableciendo permisos de administrador.',
    'Creating configuration record.' => 'Creando registro de configuración.',
    'Creating template maps...' => 'Creando mapas de plantillas...',
    'Mapping template ID [_1] to [_2] ([_3]).' => 'Mapeando ID plantilla [_1] a [_2] ([_3]).',
    'Mapping template ID [_1] to [_2].' => 'Mapeando ID plantilla [_1] a [_2].',

    ## ./lib/MT/DateTime.pm

    ## ./lib/MT/ObjectTag.pm

    ## ./lib/MT/Author.pm
    'Can\'t approve/ban non-COMMENTER author' => 'Can\'t approve/ban non-COMMENTER author', # Translate - New (6)
    'The approval could not be committed: [_1]' => 'The approval could not be committed: [_1]', # Translate - New (7)

    ## ./lib/MT/XMLRPC.pm
    'No WeblogsPingURL defined in mt.cfg' => 'WeblogsPingURL no definido en mt.cfg',
    'No MTPingURL defined in mt.cfg' => 'MTPingURL no definido en mt.cfg',
    'HTTP error: [_1]' => 'Error HTTP: [_1]',
    'Ping error: [_1]' => 'Error de ping: [_1]',

    ## ./lib/MT/TemplateMap.pm

    ## ./lib/MT/I18N.pm

    ## ./lib/MT/TBPing.pm
    'Load of blog \'[_1]\' failed: [_2]' => 'La carga del blog \'[_1]\' falló: [_2]',

    ## ./lib/MT/Blog.pm

    ## ./lib/MT/BasicSession.pm

    ## ./lib/MT/Builder.pm
    '&lt;MT[_1]> with no &lt;/MT[_1]>' => '&lt;MT[_1]> with no &lt;/MT[_1]>', # Translate - New (9)
    'Error in &lt;MT[_1]> tag: [_2]' => 'Error in &lt;MT[_1]> tag: [_2]', # Translate - New (7)

    ## ./lib/MT/Serialize.pm

    ## ./lib/MT/FileInfo.pm

    ## ./lib/MT/Callback.pm

    ## ./lib/MT/Atom.pm

    ## ./lib/MT/Object.pm
    '4th argument to add_callback must be a perl CODE reference' => '4th argument to add_callback must be a perl CODE reference', # Translate - New (11)

    ## ./lib/MT/Tag.pm
    'Tag must have a valid name' => 'Tag must have a valid name', # Translate - New (6)
    'This tag is referenced by others.' => 'This tag is referenced by others.', # Translate - New (6)

    ## ./lib/MT/Promise.pm

    ## ./lib/MT/App.pm
    'Error loading [_1]: [_2]' => 'Error loading [_1]: [_2]', # Translate - New (4)
    'Invalid login attempt from user \'[_1]\'' => 'Intento no válido de inicio de sesión del usuario \'[_1]\'',
    'Invalid login attempt from user \'[_1]\' (ID: [_2])' => 'Invalid login attempt from user \'[_1]\' (ID: [_2])', # Translate - New (8)
    'User \'[_1]\' (user #[_2]) logged in successfully' => 'El usuario \'[_1]\' (usuario nº[_2]) inició una sesión correctamente',
    'Invalid login.' => 'Acceso no válido.',
    'User \'[_1]\' (user #[_2]) logged out' => 'El usuario \'[_1]\' (usuario nº[_2]) finalizó su sesión',
    'The file you uploaded is too large.' => 'El fichero que transfirió es demasiado grande.',
    'Unknown action [_1]' => 'Acción desconocida [_1]',
    'Loading template \'[_1]\' failed: [_2]' => 'Fallo cargando plantilla \'[_1]\': [_2]',

    ## ./lib/MT/Log.pm
    'Entry # [_1] not found.' => 'Entry # [_1] not found.', # Translate - New (4)
    'Comment # [_1] not found.' => 'Comment # [_1] not found.', # Translate - New (4)
    'TrackBack # [_1] not found.' => 'TrackBack # [_1] not found.', # Translate - New (4)

    ## ./lib/MT/IPBanList.pm

    ## ./lib/MT/AtomServer.pm
    'PreSave failed [_1]' => 'PreSave failed [_1]', # Translate - New (3)
    'User \'[_1]\' (user #[_2]) added entry #[_3]' => 'User \'[_1]\' (user #[_2]) added entry #[_3]', # Translate - New (7)

    ## ./lib/MT/PluginData.pm

    ## ./lib/MT/Plugin.pm

    ## ./lib/MT/Entry.pm
    'Load of blog failed: [_1]' => 'Fallo en la carga del blog: [_1]',

    ## ./lib/MT/Task.pm

    ## ./lib/MT/Config.pm

    ## ./lib/MT/L10N.pm

    ## ./lib/MT/Template.pm
    'Parse error in template \'[_1]\': [_2]' => 'Error de interpretación en la plantilla \'[_1]\': [_2]',
    'Build error in template \'[_1]\': [_2]' => 'Error de reconstrucción en la plantilla \'[_1]\': [_2]',
    'You cannot use a [_1] extension for a linked file.' => 'No puede usar una extensión [_1] para un fichero enlazado.',
    'Opening linked file \'[_1]\' failed: [_2]' => 'Fallo abriendo fichero enlazado\'[_1]\': [_2]',

    ## ./lib/MT/ImportExport.pm
    'No Stream' => 'No Stream', # Translate - New (2)
    'No Blog' => 'No Blog', # Translate - New (2)
    'Can\'t rewind' => 'Can\'t rewind', # Translate - New (3)
    'Can\'t open \'[_1]\': [_2]' => 'No se pudo abrir \'[_1]\': [_2]',
    'Can\'t open directory \'[_1]\': [_2]' => 'No se puede abrir el directorio \'[_1]\': [_2]',
    'No readable files could be found in your import directory [_1].' => 'No se encontrón ningún fichero legible en su directorio de importación [_1].',
    'Importing entries from file \'[_1]\'' => 'Importando entradas desde el fichero \'[_1]\'',
    'You need to provide a password if you are going to\n' => 'Debe proveer una clave si va a\n',
    'Need either ImportAs or ParentAuthor' => 'Necesita ImportAs o ParentAuthor',
    'Creating new author (\'[_1]\')...' => 'Creating new author (\'[_1]\')...', # Translate - New (4)
    'ok\n' => 'ok\n', # Translate - Previous (2)
    'failed\n' => 'falló\n',
    'Saving author failed: [_1]' => 'Fallo guardando autor: [_1]',
    'Assigning permissions for new author...' => 'Assigning permissions for new author...', # Translate - New (5)
    'Saving permission failed: [_1]' => 'Fallo guardando permisos: [_1]',
    'Creating new category (\'[_1]\')...' => 'Creating new category (\'[_1]\')...', # Translate - New (4)
    'Saving category failed: [_1]' => 'Fallo guardando categoría: [_1]',
    'Invalid status value \'[_1]\'' => 'Valor de estado no válido \'[_1]\'',
    'Invalid allow pings value \'[_1]\'' => 'Invalid allow pings value \'[_1]\'', # Translate - New (5)
    'Can\'t find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.\n' => 'Can\'t find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.\n', # Translate - New (17)
    'Importing into existing entry [_1] (\'[_2]\')\n' => 'Importing into existing entry [_1] (\'[_2]\')\n', # Translate - New (7)
    'Saving entry (\'[_1]\')...' => 'Saving entry (\'[_1]\')...', # Translate - New (3)
    'ok (ID [_1])\n' => 'ok (ID [_1])\n', # Translate - New (4)
    'Saving entry failed: [_1]' => 'Fallo guardando entrada: [_1]',
    'Saving placement failed: [_1]' => 'Fallo guardando situación: [_1]',
    'Creating new comment (from \'[_1]\')...' => 'Creating new comment (from \'[_1]\')...', # Translate - New (5)
    'Saving comment failed: [_1]' => 'Fallo guardando comentario: [_1]',
    'Entry has no MT::Trackback object!' => '¡La entrada no tiene objeto MT::Trackback!',
    'Creating new ping (\'[_1]\')...' => 'Creating new ping (\'[_1]\')...', # Translate - New (4)
    'Saving ping failed: [_1]' => 'Fallo guardando ping: [_1]',
    'Export failed on entry \'[_1]\': [_2]' => 'Fallo de exportación en la entrada \'[_1]\': [_2]',
    'Invalid date format \'[_1]\'; must be ' => 'Invalid date format \'[_1]\'; must be ', # Translate - New (6)

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

    ## ./lib/MT/ErrorHandler.pm

    ## ./lib/MT/Request.pm

    ## ./lib/MT/Permission.pm

    ## ./lib/MT/XMLRPCServer.pm
    'Invalid timestamp format' => 'Invalid timestamp format', # Translate - New (3)
    'No web services password assigned.  Please see your author profile to set it.' => 'No web services password assigned.  Please see your author profile to set it.', # Translate - New (13)
    'No blog_id' => 'No blog_id', # Translate - New (3)
    'Invalid blog ID \'[_1]\'' => 'Invalid blog ID \'[_1]\'', # Translate - New (4)
    'Invalid login' => 'Invalid login', # Translate - New (2)
    'No posting privileges' => 'No posting privileges', # Translate - New (3)
    'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => 'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')', # Translate - New (11)
    'No entry_id' => 'No entry_id', # Translate - New (3)
    'Invalid entry ID \'[_1]\'' => 'ID de entrada no válida \'[_1]\'',
    'Not privileged to edit entry' => 'Not privileged to edit entry', # Translate - New (5)
    'Not privileged to delete entry' => 'Not privileged to delete entry', # Translate - New (5)
    'Entry \'[_1]\' (entry #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'Entry \'[_1]\' (entry #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc', # Translate - New (11)
    'Not privileged to get entry' => 'Not privileged to get entry', # Translate - New (5)
    'Author does not have privileges' => 'Author does not have privileges', # Translate - New (5)
    'Not privileged to set entry categories' => 'Not privileged to set entry categories', # Translate - New (6)
    'Publish failed: [_1]' => 'Publish failed: [_1]', # Translate - New (3)
    'Not privileged to upload files' => 'Not privileged to upload files', # Translate - New (5)
    'No filename provided' => 'No filename provided', # Translate - New (3)
    'Invalid filename \'[_1]\'' => 'Nombre de fichero no válido \'[_1]\'',
    'Error making path \'[_1]\': [_2]' => 'Error making path \'[_1]\': [_2]', # Translate - New (5)
    'Error writing uploaded file: [_1]' => 'Error writing uploaded file: [_1]', # Translate - New (5)
    'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.', # Translate - New (17)

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
    'An error occurred while rebuilding to publish scheduled posts: [_1]' => 'An error occurred while rebuilding to publish scheduled posts: [_1]', # Translate - New (10)

    ## ./lib/MT/Comment.pm
    'Load of entry \'[_1]\' failed: [_2]' => 'Fallo al cargar la entrada \'[_1]\': [_2]',

    ## ./lib/MT/DefaultTemplates.pm

    ## ./lib/MT/ConfigMgr.pm
    'Error opening file \'[_1]\': [_2]' => 'Error abriendo fichero \'[_1]\': [_2]',
    'Config directive [_1] without value at [_2] line [_3]' => 'Directiva de configuración [_1] sin valor en [_2] línea [_3]',
    'No such config variable \'[_1]\'' => 'No existe la variable de configuración \'[_1]\'',

    ## ./lib/MT/I18N/default.pm

    ## ./lib/MT/I18N/en_us.pm

    ## ./lib/MT/I18N/ja.pm

    ## ./lib/MT/Plugin/L10N.pm

    ## ./lib/MT/Plugin/JunkFilter.pm
    'from rule' => 'desde la regla',
    'from test' => 'desde el test',

    ## ./lib/MT/L10N/es.pm

    ## ./lib/MT/L10N/de.pm

    ## ./lib/MT/L10N/nl.pm

    ## ./lib/MT/L10N/ja.pm

    ## ./lib/MT/L10N/fr.pm

    ## ./lib/MT/L10N/en_us.pm

    ## ./lib/MT/L10N/es-iso-8859-1.pm

    ## ./lib/MT/L10N/fr-iso-8859-1.pm

    ## ./lib/MT/L10N/de-iso-8859-1.pm

    ## ./lib/MT/L10N/nl-iso-8859-1.pm

    ## ./lib/MT/ObjectDriver/DBI.pm
    'Loading data failed with SQL error [_1]' => 'Loading data failed with SQL error [_1]', # Translate - New (7)
    'Count [_1] failed on SQL error [_2]' => 'Count [_1] failed on SQL error [_2]', # Translate - New (7)
    'Prepare failed' => 'Prepare failed', # Translate - New (2)
    'Execute failed' => 'Execute failed', # Translate - New (2)
    'existence test failed on SQL error [_1]' => 'existence test failed on SQL error [_1]', # Translate - New (7)
    'Insertion test failed on SQL error [_1]' => 'Insertion test failed on SQL error [_1]', # Translate - New (7)
    'Update failed on SQL error [_1]' => 'Update failed on SQL error [_1]', # Translate - New (6)
    'No such object.' => 'No such object.', # Translate - New (3)
    'Remove failed on SQL error [_1]' => 'Remove failed on SQL error [_1]', # Translate - New (6)
    'Remove-all failed on SQL error [_1]' => 'Remove-all failed on SQL error [_1]', # Translate - New (6)

    ## ./lib/MT/ObjectDriver/DBM.pm
    'Your DataSource directory (\'[_1]\') does not exist.' => 'Su directorio DataSource (\'[_1]\') no existe.',
    'Your DataSource directory (\'[_1]\') is not writable.' => 'No se puede escribir en el directorio DataSource (\'[_1]\').',
    'Tie \'[_1]\' failed: [_2]' => 'La creación del enlace \'[_1]\' falló: [_2]',
    'Failed to generate unique ID: [_1]' => 'Fallo al intentar generar ID único: [_1]',
    'Unlink of \'[_1]\' failed: [_2]' => 'El borrado del enlace \'[_1]\' falló: [_2]',

    ## ./lib/MT/ObjectDriver/DBI/mysql.pm
    'Connection error: [_1]' => 'Error de conexión: [_1]',
    'undefined type: [_1]' => 'undefined type: [_1]', # Translate - New (3)

    ## ./lib/MT/ObjectDriver/DBI/postgres.pm

    ## ./lib/MT/ObjectDriver/DBI/sqlite.pm
    'Your database file (\'[_1]\') is not writable.' => 'No se puede escribir en el fichero de su base de datos (\'[_1]\').',
    'Your database directory (\'[_1]\') is not writable.' => 'No se puede escribir en el directorio de su base de datos (\'[_1]\').',

    ## ./lib/MT/FileMgr/FTP.pm
    'Creating path \'[_1]\' failed: [_2]' => 'Creating path \'[_1]\' failed: [_2]', # Translate - New (5)
    'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Fallo renombrando \'[_1]\' a \'[_2]\': [_3]',
    'Deleting \'[_1]\' failed: [_2]' => 'Deleting \'[_1]\' failed: [_2]', # Translate - New (4)

    ## ./lib/MT/FileMgr/DAV.pm
    'DAV connection failed: [_1]' => 'DAV connection failed: [_1]', # Translate - New (4)
    'DAV open failed: [_1]' => 'DAV open failed: [_1]', # Translate - New (4)
    'DAV get failed: [_1]' => 'DAV get failed: [_1]', # Translate - New (4)
    'DAV put failed: [_1]' => 'DAV put failed: [_1]', # Translate - New (4)

    ## ./lib/MT/FileMgr/Local.pm
    'Opening local file \'[_1]\' failed: [_2]' => 'Fallo abriendo el fichero local \'[_1]\': [_2]',

    ## ./lib/MT/FileMgr/SFTP.pm
    'SFTP connection failed: [_1]' => 'SFTP connection failed: [_1]', # Translate - New (4)
    'SFTP get failed: [_1]' => 'SFTP get failed: [_1]', # Translate - New (4)
    'SFTP put failed: [_1]' => 'SFTP put failed: [_1]', # Translate - New (4)

    ## ./lib/MT/Template/Context.pm

    ## ./lib/MT/Template/ContextHandlers.pm
    'Can\'t find included template module \'[_1]\'' => 'No se encontró el módulo de plantilla incluido \'[_1]\'',
    'Can\'t find included file \'[_1]\'' => 'No se encontró el fichero incluido \'[_1]\'',
    'Error opening included file \'[_1]\': [_2]' => 'Error abriendo el fichero incluido \'[_1]\': [_2]',
    'Unspecified archive template' => 'Unspecified archive template', # Translate - New (3)
    'Error in file template: [_1]' => 'Error in file template: [_1]', # Translate - New (5)
    'Can\'t find template \'[_1]\'' => 'No se encontró la plantilla \'[_1]\'',
    'Can\'t find entry \'[_1]\'' => 'No se encontró la entrada \'[_1]\'',
    '$short_name [_1]' => '$short_name [_1]', # Translate - New (3)
    'You used a [_1] tag without any arguments.' => 'Usó una etiqueta [_1] sin ningún parámetro.',
    'You have an error in your \'category\' attribute: [_1]' => 'You have an error in your \'category\' attribute: [_1]', # Translate - New (9)
    'You have an error in your \'tag\' attribute: [_1]' => 'You have an error in your \'tag\' attribute: [_1]', # Translate - New (9)
    'No such author \'[_1]\'' => 'No existe el autor \'[_1]\'',
    'You used an \'[_1]\' tag outside of the context of an entry; ' => 'Usó una etiqueta \'[_1]\' fuera del contexto de una entrada; ',
    'You used <$MTEntryFlag$> without a flag.' => 'Usó <$MTEntryFlag$> sin \'flag\'.',
    'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Usó una etiqueta [_1] enlazando los archivos \'[_2]\', pero el tipo de archivo no está publicado.',
    'Could not create atom id for entry [_1]' => 'Could not create atom id for entry [_1]', # Translate - New (8)
    'To enable comment registration, you ' => 'Para habilitar el registro de comentarios, ',
    '(You may use HTML tags for style)' => '(Puede usar etiquetas HTML para el estilo)',
    'You used an [_1] tag without a date context set up.' => 'Usó una etiqueta [_1] sin un contexto de fecha configurado.',
    'You used an \'[_1]\' tag outside of the context of a comment; ' => 'Usó una etiqueta \'[_1]\' fuera del contexto de un comentario; ',
    'You used an [_1] without a date context set up.' => 'Usó un [_1] sin una fecha de contexto configurada.',
    '[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] sólo se puede usar con los archivos diarios, semanales o mensuales.',
    'Couldn\'t get daily archive list' => 'Couldn\'t get daily archive list', # Translate - New (6)
    'Couldn\'t get monthly archive list' => 'Couldn\'t get monthly archive list', # Translate - New (6)
    'Couldn\'t get weekly archive list' => 'Couldn\'t get weekly archive list', # Translate - New (6)
    'Unknown archive type [_1] in <MTArchiveList>' => 'Unknown archive type [_1] in <MTArchiveList>', # Translate - New (6)
    'Group iterator failed.' => 'Group iterator failed.', # Translate - New (3)
    'You used an [_1] tag outside of the proper context.' => 'Usó una etiqueta [_1] fuera del contexto correcto.',
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly ' => 'Usó una etiqueta [_1] fuera de Diario, Semanal, o Mensual ',
    'Could not determine entry' => 'Could not determine entry', # Translate - New (4)
    'Invalid month format: must be YYYYMM' => 'Formato de mes no válido: debe ser YYYYMM',
    'No such category \'[_1]\'' => 'No existe la categoría \'[_1]\'',
    'You used <$MTCategoryDescription$> outside of the proper context.' => 'You used <$MTCategoryDescription$> outside of the proper context.', # Translate - New (8)
    '[_1] can be used only if you have enabled Category archives.' => '[_1] sólo se puede usar si tiene habilitadas el archivado de categorías.',
    '<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.', # Translate - New (19)
    'You failed to specify the label attribute for the [_1] tag.' => 'You failed to specify the label attribute for the [_1] tag.', # Translate - New (11)
    'You used an \'[_1]\' tag outside of the context of ' => 'You used an \'[_1]\' tag outside of the context of ', # Translate - New (10)
    'MTSubCatsRecurse used outside of MTSubCategories' => 'MTSubCatsRecurse used outside of MTSubCategories', # Translate - New (5)
    'MT[_1] must be used in a category context' => 'MT[_1] must be used in a category context', # Translate - New (9)
    'Cannot find package [_1]: [_2]' => 'Cannot find package [_1]: [_2]', # Translate - New (5)
    'Error sorting categories: [_1]' => 'Error sorting categories: [_1]', # Translate - New (4)

    ## ./lib/MT/App/NotifyList.pm
    'Please enter a valid email address.' => 'Por favor, teclee una dirección de correo válida.',
    'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Falta parámetro obligatorio: blog_id. Por favor, consulte el manual de usuario para configurar las notificaciones.',
    'Email notifications have not been configured! The weblog owner needs to set the EmailVerificationSecret configuration variable in mt.cfg.' => '¡Las notificaciones por correo-e no están configuradas! El dueño del weblog necesita establecer la opción EmailVerificationSecret en mt.cfg.',
    'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Parámetro de redirección no válido. El dueño del weblog debe especificar una ruta que coincida con el del dominio del weblog.',
    'The email address \'[_1]\' is already in the notification list for this weblog.' => 'La dirección de correo-e \'[_1]\' ya está en la lista de notificaciones de este weblog.',
    'Please verify your email to subscribe' => 'Please verify your email to subscribe', # Translate - New (6)
    'The address [_1] was not subscribed.' => 'The address [_1] was not subscribed.', # Translate - New (6)
    'The address [_1] has been unsubscribed.' => 'The address [_1] has been unsubscribed.', # Translate - New (6)

    ## ./lib/MT/App/Comments.pm
    'No id' => 'No id', # Translate - New (2)
    'No such comment' => 'No such comment', # Translate - New (3)
    'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.', # Translate - New (12)
    'IP Banned Due to Excessive Comments' => 'IP bloqueada debido al exceso de comentarios',
    'Invalid request' => 'Invalid request', # Translate - New (2)
    'No such entry \'[_1]\'.' => 'No existe la entrada \'[_1]\'.',
    'You are not allowed to post comments.' => 'No puede publicar comentarios.',
    'Comments are not allowed on this entry.' => 'No se permiten comentarios en esta entrada.',
    'Comment text is required.' => 'El texto del comentario es obligatorio.',
    'Registration is required.' => 'El registro es obligatorio.',
    'Name and email address are required.' => 'El nombre y la dirección de correo-e son obligatorios.',
    'Invalid email address \'[_1]\'' => 'Dirección de correo-e no válida \'[_1]\'',
    'Invalid URL \'[_1]\'' => 'URL no válida \'[_1]\'',
    'Comment save failed with [_1]' => 'Comment save failed with [_1]', # Translate - New (5)
    'New comment for entry #[_1] \'[_2]\'.' => 'New comment for entry #[_1] \'[_2]\'.', # Translate - New (6)
    'Commenter save failed with [_1]' => 'Commenter save failed with [_1]', # Translate - New (5)
    'Rebuild failed: [_1]' => 'Fallo la reconstrucción: [_1]',
    'New Comment Posted to \'[_1]\'' => 'Nuevo comentario publicado en \'[_1]\'',
    'The login could not be confirmed because of a database error ([_1])' => 'The login could not be confirmed because of a database error ([_1])', # Translate - New (12)
    'Couldn\'t get public key from url provided' => 'Couldn\'t get public key from url provided', # Translate - New (8)
    'No public key could be found to validate registration.' => 'No se encontró la clave pública para validar el registro.',
    'TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]', # Translate - New (13)
    'The TypeKey signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'The TypeKey signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct', # Translate - New (18)
    'The sign-in validation failed.' => 'The sign-in validation failed.', # Translate - New (4)
    'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.', # Translate - New (32)
    'Couldn\'t save the session' => 'Couldn\'t save the session', # Translate - New (5)
    'This weblog requires commenters to pass an email address' => 'This weblog requires commenters to pass an email address', # Translate - New (9)
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
    'Search failed. Invalid pattern given: [_1]' => 'Search failed. Invalid pattern given: [_1]', # Translate - New (6)
    'Search failed: [_1]' => 'Falló la búsqueda: [_1]',
    'No alternate template is specified for the Template \'[_1]\'' => 'No alternate template is specified for the Template \'[_1]\'', # Translate - New (9)
    'Building results failed: [_1]' => 'Fallo generando los resultados: [_1]',
    'Search: query for \'[_1]\'' => 'Búsqueda: encontrar \'[_1]\'',
    'Search: new comment search' => 'Search: new comment search', # Translate - New (4)

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
    'New TrackBack for entry #[_1] \'[_2]\'.' => 'New TrackBack for entry #[_1] \'[_2]\'.', # Translate - New (6)
    'New TrackBack for category #[_1] \'[_2]\'.' => 'New TrackBack for category #[_1] \'[_2]\'.', # Translate - New (6)
    'Can\'t create RSS feed \'[_1]\': ' => 'No se pudo crear la fuente RSS \'[_1]\': ',
    'New TrackBack Ping to Entry [_1] ([_2])' => 'Nuevo ping de TrackBack en la entrada [_1] ([_2])',
    'New TrackBack Ping to Category [_1] ([_2])' => 'Nuevo ping de TrackBack en la categoría [_1] ([_2])',

    ## ./lib/MT/App/Upgrader.pm
    'The initial account name is required.' => 'The initial account name is required.', # Translate - New (6)
    'You failed to validate your password.' => 'You failed to validate your password.', # Translate - New (6)
    'You failed to supply a password.' => 'You failed to supply a password.', # Translate - New (6)
    'The value you entered was not a valid email address' => 'El valor que tecleó no es una dirección válida de correo electrónico',
    'Password hint is required.' => 'La pista para la contraseña es obligatoria.',
    'User [_1] upgraded database to version [_2]' => 'User [_1] upgraded database to version [_2]', # Translate - New (7)
    'Invalid session.' => 'Sesión no válida.',
    'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Sin permisos. Por favor, contacte con su administrador para la actualización de Movable Type.',

    ## ./lib/MT/App/Viewer.pm
    'This is an experimental feature; turn off SafeMode (in mt.cfg) in order to use it.' => 'This is an experimental feature; turn off SafeMode (in mt.cfg) in order to use it.', # Translate - New (16)
    'Not allowed to view blog [_1]' => 'Not allowed to view blog [_1]', # Translate - New (6)
    'Loading blog with ID [_1] failed' => 'Loading blog with ID [_1] failed', # Translate - New (6)
    'Can\'t load \'[_1]\' template.' => 'Can\'t load \'[_1]\' template.', # Translate - New (5)
    'Building template failed: [_1]' => 'Building template failed: [_1]', # Translate - New (4)
    'Invalid date spec' => 'Invalid date spec', # Translate - New (3)
    'Can\'t load template [_1]' => 'Can\'t load template [_1]', # Translate - New (5)
    'Building archive failed: [_1]' => 'Building archive failed: [_1]', # Translate - New (4)
    'Invalid entry ID [_1]' => 'Invalid entry ID [_1]', # Translate - New (4)
    'Entry [_1] is not published' => 'Entry [_1] is not published', # Translate - New (5)
    'Invalid category ID \'[_1]\'' => 'Invalid category ID \'[_1]\'', # Translate - New (4)

    ## ./lib/MT/App/CMS.pm
    'No permissions' => 'No tiene permisos',
    'Invalid blog' => 'Invalid blog', # Translate - New (2)
    'Convert Line Breaks' => 'Convertir saltos de línea',
    'No birthplace, cannot recover password' => 'No birthplace, cannot recover password', # Translate - New (5)
    'Invalid author_id' => 'Invalid author_id', # Translate - New (3)
    'Invalid author name \'[_1]\' in password recovery attempt' => 'Nombre de autor \'[_1]\' no válido durante intento de recuperación de contraseña',
    'Author name or birthplace is incorrect.' => 'El nombre de autor o la fecha de nacimiento es incorrecto.',
    'Author has not set birthplace; cannot recover password' => 'El autor no tiene una fecha de nacimiento; no puede recuperar la clave',
    'Invalid attempt to recover password (used birthplace \'[_1]\')' => 'Intento de recuperación de contraseña no válido (se utilizó lugar de nacimiento \'[_1]\')',
    'Author does not have email address' => 'El autor no tiene una dirección de correo electrónico',
    'Password was reset for author \'[_1]\' (user #[_2]). Password was sent to the following address: [_3]' => 'Password was reset for author \'[_1]\' (user #[_2]). Password was sent to the following address: [_3]', # Translate - New (16)
    'Error sending mail ([_1]); please fix the problem, then ' => 'Error enviando correo ([_1]); por favor, solucione el problema, y luego  ',
    'Invalid type' => 'Invalid type', # Translate - New (2)
    'tags' => 'tags', # Translate - New (1)
    'No such tag' => 'No such tag', # Translate - New (3)
    'You are not authorized to log in to this blog.' => 'No está autorizado para acceder a este blog.',
    'No such blog [_1]' => 'No existe el blog [_1]',
    'Weblog Activity Feed' => 'Weblog Activity Feed', # Translate - New (3)
    '(author deleted)' => '(author deleted)', # Translate - New (3)
    'Permission denied.' => 'Permiso denegado.',
    'All Feedback' => 'All Feedback', # Translate - New (2)
    'log records' => 'históricos',
    'System Activity Feed' => 'System Activity Feed', # Translate - New (3)
    'Application log for blog \'[_1]\' reset by \'[_2]\' (user #[_3])' => '\'[_2]\' (usuario nº[_3]) reinició el registro de la aplicación en el blog \'[_1]\'',
    'Application log reset by \'[_1]\' (user #[_2])' => 'Registro de aplicación reiniciado por \'[_1]\' (usuario nº[_2])',
    'Import/Export' => 'Importar/Exportar',
    'Invalid blog id [_1].' => 'Invalid blog id [_1].', # Translate - New (4)
    'Invalid parameter' => 'Invalid parameter', # Translate - New (2)
    'Load failed: [_1]' => 'Fallo carga: [_1]',
    '(no reason given)' => '(no reason given)', # Translate - New (4)
    '(untitled)' => '(sin título)',
    'Create template requires type' => 'Crear plantillas requiere el tipo',
    'New Template' => 'Nueva plantilla',
    'New Weblog' => 'Nuevo weblog',
    'Author requires username' => 'El autor necesita un nombre de usuario',
    'Author requires password' => 'El autor necesita una contraseña',
    'Author requires password hint' => 'El autor necesita una pista para la contraseña',
    'Email Address is required for password recovery' => 'La dirección de correo es necesaria para la recuperación de la contraseña',
    'The e-mail address you entered is already on the Notification List for this weblog.' => 'La dirección de correo-e que tecleó ya está en la lista de notificaciones de este weblog.',
    'You did not enter an IP address to ban.' => 'No tecleó una dirección IP para bloquear.',
    'The IP you entered is already banned for this weblog.' => 'La IP que tecleó ya está bloqueada en este weblog.',
    'You did not specify a weblog name.' => 'No especificó el nombre del weblog.',
    'Site URL must be an absolute URL.' => 'La URL del sitio debe ser una URL absoluta.',
    'Archive URL must be an absolute URL.' => 'Archive URL must be an absolute URL.', # Translate - New (7)
    'The name \'[_1]\' is too long!' => 'El nombre \'[_1]\' es demasiado largo.',
    'Category \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Category \'[_1]\' created by \'[_2]\' (user #[_3])', # Translate - New (7)
    'The category label \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'The category label \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.', # Translate - New (20)
    'Saving permissions failed: [_1]' => 'Fallo guardando permisos: [_1]',
    'Can\'t find default template list; where is ' => 'No se encontró la lista de plantillas por defecto; donde está ',
    'Populating blog with default templates failed: [_1]' => 'Fallo guardando el blog con las plantillas por defecto: [_1]',
    'Setting up mappings failed: [_1]' => 'Fallo la configuración de mapeos: [_1]',
    'Weblog \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' creado por \'[_2]\' (usuario nº[_3])',
    'Author \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Author \'[_1]\' created by \'[_2]\' (user #[_3])', # Translate - New (7)
    'Template \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Template \'[_1]\' created by \'[_2]\' (user #[_3])', # Translate - New (7)
    'You cannot delete your own author record.' => 'You cannot delete your own author record.', # Translate - New (7)
    'You have no permission to delete the author [_1].' => 'You have no permission to delete the author [_1].', # Translate - New (9)
    'Weblog \'[_1]\' deleted by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' borrado por \'[_2]\' (usuario nº[_3])',
    'Notification \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => 'Notification \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])', # Translate - New (8)
    'Author \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => 'Author \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])', # Translate - New (8)
    'Category \'[_1]\' (category #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Category \'[_1]\' (category #[_2]) deleted by \'[_3]\' (user #[_4])', # Translate - New (9)
    'Comment \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4]) from entry \'[_5]\' (entry #[_6])' => 'Comment \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4]) from entry \'[_5]\' (entry #[_6])', # Translate - New (13)
    'Entry \'[_1]\' (entry #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Entry \'[_1]\' (entry #[_2]) deleted by \'[_3]\' (user #[_4])', # Translate - New (9)
    'Ping \'[_1]\' (ping #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Ping \'[_1]\' (ping #[_2]) deleted by \'[_3]\' (user #[_4])', # Translate - New (9)
    'Template \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => 'Template \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])', # Translate - New (8)
    'Tags \'[_1]\' (tags #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Tags \'[_1]\' (tags #[_2]) deleted by \'[_3]\' (user #[_4])', # Translate - New (9)
    'Passwords do not match.' => 'Las contraseñas no coinciden.',
    'Failed to verify current password.' => 'Fallo al verificar la contraseña actual.',
    'An author by that name already exists.' => 'Ya existe un autor con dicho nombre.',
    'Save failed: [_1]' => 'Save failed: [_1]', # Translate - New (3)
    'Saving object failed: [_1]' => 'Fallo guardando objeto: [_1]',
    'No Name' => 'Sin nombre',
    'Notification List' => 'Lista de notificaciones',
    'email addresses' => 'dirección de correo-e',
    'Can\'t delete that way' => 'No puede borrar de esa forma',
    'Your login session has expired.' => 'Su sesión expiró.',
    'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => 'No puede eliminar esa categoría porque tiene subcategorías. Mueva o elimine primero las categorías si desea eliminar ésta.',
    'Unknown object type [_1]' => 'Tipo de objeto desconocido [_1]',
    'Loading object driver [_1] failed: [_2]' => 'Falló cargando el controlador de objetos [_1]: [_2]',
    'Reading \'[_1]\' failed: [_2]' => 'Fallo leyendo \'[_1]\': [_2]',
    'Thumbnail failed: [_1]' => 'Fallo vista previa: [_1]',
    'Error writing to \'[_1]\': [_2]' => 'Error escribiendo en \'[_1]\': [_2]',
    'Invalid basename \'[_1]\'' => 'Nombre base no válido \'[_1]\'',
    'No such commenter [_1].' => 'No existe el comentarista [_1].',
    'User \'[_1]\' (#[_2]) trusted commenter \'[_3]\' (#[_4]).' => 'User \'[_1]\' (#[_2]) trusted commenter \'[_3]\' (#[_4]).', # Translate - New (7)
    'User \'[_1]\' (#[_2]) banned commenter \'[_3]\' (#[_4]).' => 'User \'[_1]\' (#[_2]) banned commenter \'[_3]\' (#[_4]).', # Translate - New (7)
    'User \'[_1]\' (#[_2]) unbanned commenter \'[_3]\' (#[_4]).' => 'User \'[_1]\' (#[_2]) unbanned commenter \'[_3]\' (#[_4]).', # Translate - New (7)
    'User \'[_1]\' (#[_2]) untrusted commenter \'[_3]\' (#[_4]).' => 'User \'[_1]\' (#[_2]) untrusted commenter \'[_3]\' (#[_4]).', # Translate - New (7)
    'Need a status to update entries' => 'Necesita indicar un estado para actualizar las entradas',
    'Need entries to update status' => 'Necesita entradas para actualizar su estado',
    'One of the entries ([_1]) did not actually exist' => 'Una de las entradas ([_1]) no existe actualmente',
    'Some entries failed to save' => 'Algunas entradas fallaron al guardar',
    'You don\'t have permission to approve this TrackBack.' => 'No tiene permisos para aprobar este TrackBack.',
    'Comment on missing entry!' => 'Comment on missing entry!', # Translate - New (4)
    'You don\'t have permission to approve this comment.' => 'No tiene permiso para aprobar este comentario.',
    'Comment Activity Feed' => 'Comment Activity Feed', # Translate - New (3)
    'Orphaned comment' => 'Comentario huérfano',
    'Plugin Set: [_1]' => 'Conjunto de plugins: [_1]',
    'TrackBack Activity Feed' => 'TrackBack Activity Feed', # Translate - New (3)
    'No Excerpt' => 'Sin resumen',
    'No Title' => 'Sin título',
    'Orphaned TrackBack' => 'TrackBack huérfano',
    'Tag' => 'Tag', # Translate - New (1)
    'Entry Activity Feed' => 'Entry Activity Feed', # Translate - New (3)
    'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Fecha no válida \'[_1]\'; debe tener el formato YYYY-MM-DD HH:MM:SS.',
    'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Fecha no válida \'[_1]\'; debe ser una fecha real.',
    'Saving entry \'[_1]\' failed: [_2]' => 'Fallo guardando entrada \'[_1]\': [_2]',
    'Removing placement failed: [_1]' => 'Fallo eliminando lugar: [_1]',
    'No such entry.' => 'No existe la entrada.',
    'Your weblog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Su weblog no tiene configurados la ruta y URL. No puede publicar entradas hasta que las defina.',
    'The category must be given a name!' => 'Debe darle un nombre a la categoría.',
    'yyyy/mm/entry_basename' => 'aaaa/mm/entrada_nombrebase',
    'yyyy/mm/entry-basename' => 'yyyy/mm/entry-basename', # Translate - New (3)
    'yyyy/mm/entry_basename/' => 'aaaa/mm/entrada_nombrebase/',
    'yyyy/mm/entry-basename/' => 'yyyy/mm/entry-basename/', # Translate - New (3)
    'yyyy/mm/dd/entry_basename' => 'aaaa/mm/dd/entrada_nombrebase',
    'yyyy/mm/dd/entry-basename' => 'yyyy/mm/dd/entry-basename', # Translate - New (4)
    'yyyy/mm/dd/entry_basename/' => 'aaaa/mm/dd/entrada_nombrebase/',
    'yyyy/mm/dd/entry-basename/' => 'yyyy/mm/dd/entry-basename/', # Translate - New (4)
    'category/sub_category/entry_basename' => 'categoría/sub_categoría/entrada_nombrebase',
    'category/sub_category/entry_basename/' => 'categoría/sub_categoría/entrada_nombrebase/',
    'category/sub-category/entry_basename' => 'categoría/sub-categoría/entrada_nombrebase',
    'category/sub-category/entry-basename' => 'category/sub-category/entry-basename', # Translate - New (3)
    'category/sub-category/entry_basename/' => 'categoría/sub-categoría/entrada_nombrebase/',
    'category/sub-category/entry-basename/' => 'category/sub-category/entry-basename/', # Translate - New (3)
    'primary_category/entry_basename' => 'categoría_principal/entrada_nombrebase',
    'primary_category/entry_basename/' => 'categoría_principal/entrada_nombrebase/',
    'primary-category/entry_basename' => 'categoría-principal/entrada_nombrebase',
    'primary-category/entry-basename' => 'primary-category/entry-basename', # Translate - New (2)
    'primary-category/entry_basename/' => 'categoría-principal/entrada_nombrebase/',
    'primary-category/entry-basename/' => 'primary-category/entry-basename/', # Translate - New (2)
    'yyyy/mm/' => 'aaaa/mm/',
    'yyyy_mm' => 'aaaa_mm',
    'yyyy/mm/dd/' => 'aaaa/mm/dd/',
    'yyyy_mm_dd' => 'aaaa_mm_dd',
    'yyyy/mm/dd-week/' => 'aaaa/mm/dd-week/',
    'week_yyyy_mm_dd' => 'semana_aaaa_mm_dd',
    'category/sub_category/' => 'categoría/sub_categoría/',
    'category/sub-category/' => 'categoría/sub-categoría/',
    'cat_category' => 'cat_categoría',
    'Saving blog failed: [_1]' => 'Fallo guardando blog: [_1]',
    'You do not have permission to configure the blog' => 'No tiene permiso para configurar el blog',
    'Saving map failed: [_1]' => 'Fallo guardando mapa: [_1]',
    'Parse error: [_1]' => 'Error de interpretación: [_1]',
    'Build error: [_1]' => 'Error construyendo: [_1]',
    'Rebuild-option name must not contain special characters' => 'Rebuild-option name must not contain special characters', # Translate - New (7)
    'index template \'[_1]\'' => 'index template \'[_1]\'', # Translate - New (3)
    'entry \'[_1]\'' => 'entry \'[_1]\'', # Translate - New (2)
    'Ping \'[_1]\' failed: [_2]' => 'Falló ping \'[_1]\' : [_2]',
    'You cannot modify your own permissions.' => 'You cannot modify your own permissions.', # Translate - New (6)
    'You are not allowed to edit the permissions of this author.' => 'You are not allowed to edit the permissions of this author.', # Translate - New (11)
    'Edit Permissions' => 'Editar permisos',
    'Edit Profile' => 'Edit Profile', # Translate - New (2)
    'No entry ID provided' => 'No se provió ID de entrada ',
    'No such entry \'[_1]\'' => 'No existe la entrada \'[_1]\'',
    'No email address for author \'[_1]\'' => 'No hay dirección de correo electrónico asociada al autor \'[_1]\'',
    'No valid recipients found for the entry notification.' => 'No valid recipients found for the entry notification.', # Translate - New (8)
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
    'Invalid date(s) specified for date range.' => 'Invalid date(s) specified for date range.', # Translate - New (7)
    'Error in search expression: [_1]' => 'Error in search expression: [_1]', # Translate - New (5)
    'Saving object failed: [_2]' => 'Fallo al guardar objeto: [_2]',
    'Search & Replace' => 'Buscar & Reemplazar',
    'No blog ID' => 'No es ID de blog',
    'You do not have export permissions' => 'No tiene permisos de exportación',
    'You do not have import permissions' => 'No tiene permisos de importación',
    'You do not have permission to create authors' => 'No tiene permisos para crear autores',
    'Preferences' => 'Preferencias',
    'Add a Category' => 'Añadir una categoría',
    'No label' => 'No label', # Translate - New (2)
    'Category name cannot be blank.' => 'El nombre de la categoría no puede estar en blanco.',
    'That action ([_1]) is apparently not implemented!' => '¡La acción ([_1]) aparentemente no está implementada!',
    'Permission denied' => 'Permission denied', # Translate - New (2)

    ## ./lib/MT/App/ActivityFeeds.pm
    'An error occurred while generating the activity feed: [_1].' => 'An error occurred while generating the activity feed: [_1].', # Translate - New (9)
    'No permissions.' => 'No permissions.', # Translate - New (2)
    '[_1] Weblog TrackBacks' => '[_1] Weblog TrackBacks', # Translate - New (4)
    'All Weblog TrackBacks' => 'All Weblog TrackBacks', # Translate - New (3)
    '[_1] Weblog Comments' => '[_1] Weblog Comments', # Translate - New (4)
    'All Weblog Comments' => 'All Weblog Comments', # Translate - New (3)
    '[_1] Weblog Entries' => '[_1] Weblog Entries', # Translate - New (4)
    'All Weblog Entries' => 'All Weblog Entries', # Translate - New (3)
    '[_1] Weblog Activity' => '[_1] Weblog Activity', # Translate - New (4)
    'All Weblog Activity' => 'All Weblog Activity', # Translate - New (3)
    'Movable Type Debug Activity' => 'Movable Type Debug Activity', # Translate - New (4)

    ## ./lib/MT/App/Wizard.pm
    'Sendmail' => 'Sendmail', # Translate - New (1)
    'Test mail from Configuration Wizard' => 'Test mail from Configuration Wizard', # Translate - New (5)
    'test test test. change me please' => 'test test test. change me please', # Translate - New (6)

    ## ./lib/MT/Module/Build.pm

    ## ./extras/examples/plugins/mirror/lib/Mirror.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample.pm
    'This is localized in perl module' => 'This is localized in perl module', # Translate - New (6)

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N/en_us.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N/ja.pm

    ## ./plugins/spamlookup/lib/spamlookup.pm
    'Failed to resolve IP address for source URL [_1]' => 'Failed to resolve IP address for source URL [_1]', # Translate - New (9)
    'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]', # Translate - New (18)
    'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]', # Translate - New (17)
    'No links are present in feedback' => 'No links are present in feedback', # Translate - New (6)
    'Number of links exceed junk limit ([_1])' => 'Number of links exceed junk limit ([_1])', # Translate - New (7)
    'Number of links exceed moderation limit ([_1])' => 'Number of links exceed moderation limit ([_1])', # Translate - New (7)
    'Link was previously published (comment id [_1]).' => 'Link was previously published (comment id [_1]).', # Translate - New (7)
    'Link was previously published (TrackBack id [_1]).' => 'Link was previously published (TrackBack id [_1]).', # Translate - New (7)
    'E-mail was previously published (comment id [_1]).' => 'E-mail was previously published (comment id [_1]).', # Translate - New (7)
    'Word Filter match on \'[_1]\': \'[_2]\'.' => 'Word Filter match on \'[_1]\': \'[_2]\'.', # Translate - New (6)
    'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.', # Translate - New (8)
    'domain \'[_1]\' found on service [_2]' => 'domain \'[_1]\' found on service [_2]', # Translate - New (6)
    '[_1] found on service [_2]' => '[_1] found on service [_2]', # Translate - New (6)

    ## ./plugins/spamlookup/lib/spamlookup/L10N.pm

    ## ./plugins/feeds-app-lite/lib/MT/App/FeedsWidget.pm

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Lite.pm
    'An error occurred processing [_1]. ' => 'An error occurred processing [_1]. ', # Translate - New (5)

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Find.pm

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Lite/CacheMgr.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher.pm
    'Before using StyleCatcher, you must specify the Theme Root URL and Path for the installation in the system-level plugin settings for StyleCatcher.' => 'Before using StyleCatcher, you must specify the Theme Root URL and Path for the installation in the system-level plugin settings for StyleCatcher.', # Translate - New (22)
    'Configure plugin' => 'Configure plugin', # Translate - New (2)
    'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.', # Translate - New (12)
    'Successfully applied new theme selection.' => 'Successfully applied new theme selection.', # Translate - New (5)

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/en_us.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/ja.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/Util.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/Plugin.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/App.pm
    'Moving $mid to list of installed modules' => 'Moving $mid to list of installed modules', # Translate - New (7)
    'WidgetManager' => 'WidgetManager', # Translate - New (1)
    'First Widget Manager' => 'First Widget Manager', # Translate - New (3)

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/en_us.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/ja.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/en_us.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/ja.pm

    ## ./t/Foo.pm

    ## ./t/Bar.pm

    ## ./t/lib/LWP/UserAgent/Local.pm

    ## ./t/lib/Text/WikiFormat.pm

    ## ./mt-static/mt.js
    'You did not select any [_1] to delete.' => 'No seleccionó ningún [_1] para borrar.',
    'to delete' => 'para borrar',
    'You did not select any [_1] [_2].' => 'No seleccionó ningún [_1] [_2].',
    'You must select an action.' => 'Debe seleccionar una acción.',
    'to mark as junk' => 'para marcar como basura',
    'to remove "junk" status' => 'para eliminar el estado "basura"',
    'Enter email address:' => 'Teclee la dirección de correo-e:',
    'Enter URL:' => 'Teclee la URL:',

    ## ./build/Html.pm

    ## ./build/Backup.pm

    ## ./build/sample.pm

    ## ./build/cwapi.pm
);


1;

## New words: 4645
