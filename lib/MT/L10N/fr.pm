package MT::L10N::fr;
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
    'Movable Type System Check' => 'Vérification Système Movable Type',
    'This page provides you with information on your system\'s configuration and determines whether you have all of the components you need to run Movable Type.' => 'Cette page vous fournit des informations sur la configuration de votre système et vérifie que vous avez installé tous les composants nécessaires à l\'utilisation de Movable Type.',
    'System Information' => 'Informations système',
    'Current working directory:' => 'Répertoire actuellement en activité:',
    'MT home directory:' => 'MT Répertoire racine :',
    'Operating system:' => 'Système  d\'exploitation :',
    'Perl version:' => 'Version Perl :',
    'Perl include path:' => 'Chemin d\'inclusion Perl :',
    'Web server:' => 'Serveur Web :',
    '(Probably) Running under cgiwrap or suexec' => 'Tâche (probablement) lancée sous cgiwrap ou suexec',
    '[_1] [_2] Modules:' => 'Modules [_1] [_2]:', # Translate - New (4)
    'Some of the following modules are required by the various data storage options in Movable Type. In order run the system, your server needs to have DBI and at least one of the other modules installed.' => 'Certain des modules suivants sont requis par les diverses options de stockage de Movable Type. Pour que le système fonctionne, votre serveur requiert DBI ainsi que l\'installation d\'au moins un de ces modules.',
    'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'Soit [_1] n\'est pas installé sur votre serveur, soit la version installée est trop ancienne, ou [_1] nécessite un autre module qui n\'est pas installé.',
    'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => '[_1] n\'est pas installé sur votre serveur, ou [_1] nécessite un autre module qui n\'est pas installé.',
    'Please consult the installation instructions for help in installing [_1].' => 'Merci de consulter les instructions d\'installation de [_1].',
    'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN.' => 'La version DBD::mysql qui est installée n\'est pas compatible avec Movable Type. Merci d\'installer la version actuelle disponible sur CPAN.',
    'The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements.' => 'Le $mod est installé correctement, mais nécessite une mise à jour du module DBI. Merci de consulter les informations ci-dessus concernant les modules DBI.',
    'Your server has [_1] installed (version [_2]).' => '[_1] (version [_2]) est installé sur votre serveur.',
    'Movable Type System Check Successful' => 'Vérification Système Movable Type effectuée avec succès',
    'You\'re ready to go!' => 'Vous pouvez commencer!',
    'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Tous les modules requis sont installés sur votre serveur; vous n\'avez pas besoin d\'installer de modules additionnels. Poursuivez l\'installation.',

    ## ./addons/Enterprise.pack/tmpl/cfg_ldap.tmpl

    ## ./addons/Enterprise.pack/tmpl/edit_group.tmpl

    ## ./addons/Enterprise.pack/tmpl/list_group.tmpl

    ## ./addons/Enterprise.pack/tmpl/list_group_member.tmpl
    'member' => 'membres',
    'Remove' => 'Supprimer',
    'Remove selected members ()' => 'Supprimer les membres sélectionnés ()',

    ## ./addons/Enterprise.pack/tmpl/select_groups.tmpl

    ## ./build/exportmt.pl

    ## ./build/template_hash_signatures.pl

    ## ./build/l10n/diff.pl

    ## ./build/l10n/trans.pl

    ## ./build/l10n/wrap.pl

    ## ./extras/examples/plugins/BackupRestoreSample/BackupRestoreSample.pl
    'This plugin is to test out the backup restore callback.' => 'Ce plugin sert à tester le callback sauvegarde et restauration.', # Translate - New (10)

    ## ./extras/examples/plugins/CommentByGoogleAccount/CommentByGoogleAccount.pl
    'You can allow readers to authenticate themselves via Google Account to comment on posts.' => 'Vous pouvez autoriser les lecteurs à s\'authentifier via Google Account pour commenter sur les notes.', # Translate - New (14)

    ## ./extras/examples/plugins/CommentByGoogleAccount/tmpl/config.tmpl

    ## ./extras/examples/plugins/FiveStarRating/plugins/FiveStarRating/FiveStarRating.pl
    'Allow readers to rate entries, assets, comments and trackbacks.' => 'Autoriser les lecteurs à noter les notes, éléments, commentaires et trackbacks.', # Translate - New (9)

    ## ./extras/examples/plugins/l10nsample/l10nsample.pl
    'l10nsample' => 'l10nsample', # Translate - Previous (2)
    'This description can be localized if there is l10n_class set.' => 'Cette description peut être localisée si un l10n_class est mis en place.',
    'Fumiaki Yoshimatsu' => 'Fumiaki Yoshimatsu', # Translate - Previous (2)

    ## ./extras/examples/plugins/l10nsample/tmpl/view.tmpl
    'This phrase is processed in template.' => 'Cette phrase est appliquée dans le template.',

    ## ./extras/examples/plugins/mirror/mirror.pl

    ## ./extras/examples/plugins/mirror/tmpl/mirror.tmpl

    ## ./extras/examples/plugins/reCaptcha/plugins/reCaptcha/reCaptcha.pl

    ## ./extras/examples/plugins/SharedSecret/plugins/SharedSecret/SharedSecret.pl

    ## ./extras/examples/plugins/SimpleScorer/SimpleScorer.pl
    'Scores each entry.' => 'Noter chaque note.', # Translate - New (3)

    ## ./extras/examples/plugins/SimpleScorer/tmpl/scored.tmpl

    ## ./lib/MT/default-templates.pl

    ## ./plugins/Cloner/cloner.pl
    'Clones a weblog and all of its contents.' => 'Duplique un weblog et tout son contenu',
    'Cloning Weblog' => 'Clonage du weblog',
    'Error' => 'Erreur',
    'Close' => 'Fermer',

    ## ./plugins/ExtensibleArchives/AuthorArchive.pl
    'TBD' => 'TBD', # Translate - New (1)

    ## ./plugins/ExtensibleArchives/DatebasedCategories.pl

    ## ./plugins/feeds-app-lite/mt-feeds.pl
    'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type?' => 'Feeds.App Lite vous permet de republier des flux sur vos blogs. Vous voulez en faire plus avec les flux de Movable Type?',
    'Upgrade to Feeds.App' => 'Mise à jour Feeds.App',

    ## ./plugins/feeds-app-lite/tmpl/config.tmpl
    'Feeds.App Lite Widget Creator' => 'Créateur de widget Feeds.App',
    'Feed Configuration' => 'Configuration du flux',
    '3' => '3', # Translate - Previous (1)
    '5' => '5', # Translate - Previous (1)
    '10' => '10', # Translate - Previous (1)
    'All' => 'Toutes',
    'Save' => 'Enregistrer',

    ## ./plugins/feeds-app-lite/tmpl/footer.tmpl

    ## ./plugins/feeds-app-lite/tmpl/header.tmpl
    'Main Menu' => 'Menu principal',
    'System Overview' => 'Aperçu général du système',
    'Help' => 'Aide',
    'Welcome' => 'Bienvenue',
    'Logout' => 'Déconnexion',
    'Search' => 'Rechercher',
    'Entries' => 'Notes',
    'Search (q)' => 'Recherche (q)',

    ## ./plugins/feeds-app-lite/tmpl/msg.tmpl
    'No feeds could be discovered using [_1].' => 'Aucun flux n\'a été découvert avec [_1].',
    'An error occurred processing [_1]. Check <a href=' => 'Une erreur est survenue sur [_1]. Vérifiez <a href=',
    'It can be included onto your published blog using <a href=' => 'Il peut être intégré sur votre blog en utilisant <a href=',
    'It can be included onto your published blog using this MTInclude tag' => 'Cela peut être intégré à votre blog en utilisant le tag MTInclude',
    'Go Back' => 'Retour',
    'Create Another' => 'En créer un autre',

    ## ./plugins/feeds-app-lite/tmpl/select.tmpl
    'Multiple feeds were discovered. Select the feed you wish to use. Feeds.App Lite supports text-only RSS 1.0, 2.0 and Atom feeds.' => 'Nous avons trouvés plusieurs flux. Sélectionnez le flux que vous voulez utiliser. Feeds.App Lite n\'accepte que les Flux RSS texte 1.0 et 2.0 et les flux Atom.',
    'Type' => 'Type', # Translate - Previous (1)
    'URI' => 'URI', # Translate - Previous (1)
    'Continue' => 'Continuer',

    ## ./plugins/feeds-app-lite/tmpl/start.tmpl
    'Feeds.App Lite creates modules that include feed data. Once you\'ve used it to create those modules, you can then use them in your blog templates.' => 'Feeds.App Lite crée des modules incluant les données des flux.  Une fois que vous l\'avez utilisé pour créer ces modules, vous pouvez les utiliser dans les templates de vos blogs.',
    'You must enter an address to proceed' => 'Vous devez saisir une adresse',
    'Enter the URL of a feed, or the URL of a site that has a feed.' => 'Saisissez l\'adresse d\'un flux ou l\'adresse d\'un site possédant un flux.',

    ## ./plugins/GoogleSearch/GoogleSearch.pl

    ## ./plugins/GoogleSearch/tmpl/config.tmpl

    ## ./plugins/Markdown/Markdown.pl

    ## ./plugins/Markdown/SmartyPants.pl

    ## ./plugins/MultiBlog/multiblog.pl
    'MultiBlog allows you to publish templated or raw content from other blogs and define rebuild dependencies and access controls between them.' => 'Le MultiBog vous permet de publier un modèle ou du contenu à partir d\'autres blogs et de définir les dépendances de reconstruction et les controles d\'accès entre eux.',

    ## ./plugins/MultiBlog/tmpl/blog_config.tmpl
    'When' => 'Quand',
    'Any Weblog' => 'Tous les weblogs',
    'Weblog' => 'Weblog', # Translate - Previous (1)
    'Trigger' => 'Déclencher',
    'Action' => 'Action', # Translate - Previous (1)
    'Use system default' => 'Utiliser les paramètres par défaut',
    'Allow' => 'Autorise',
    'Disallow' => 'Plus Autorisé',
    'Include blogs' => 'Inlure les blogs',
    'Exclude blogs' => 'Exclure les blogs',
    'Current Rebuild Triggers:' => 'Déclencheurs actuels de reconstruction:',
    'Create New Rebuild Trigger' => 'Créer un Nouveau déclencheur de reconstruction',
    'You have not defined any rebuild triggers.' => 'Vous n\'avez défini aucun déclencheur de reconstruction',

    ## ./plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl

    ## ./plugins/MultiBlog/tmpl/system_config.tmpl
    'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'L\'aggrégation entre blogs sera autorisée par défaut. Les blogs individuels peuvent être configurés dans un niveau de paramètrage Blog MultiBlog pour restreindre l\'accès à leur contenu par d\'autres blogs.',
    'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'L\'aggrégation entre blogs ne sera pas autorisée par défaut. Les blogs individuels peuvent être configurés dans un niveau de paramètrage Blog MultiBlog pour autoriser l\'accès à leur contenu par d\'autres blogs.',

    ## ./plugins/spamlookup/spamlookup.pl
    'SpamLookup module for using blacklist lookup services to filter feedback.' => 'Module SpamLookup pour utiliser les services blacklist visant à filtrer les retours lecteurs.',

    ## ./plugins/spamlookup/spamlookup_urls.pl
    'SpamLookup - Link' => 'SpamLookup - Lien',
    'SpamLookup module for junking and moderating feedback based on link filters.' => ' Module SpamLookup pour modérer et nettoyer les feedbacks de vos lecteurs en utilisant des filtres de liens.',

    ## ./plugins/spamlookup/spamlookup_words.pl
    'SpamLookup module for moderating and junking feedback using keyword filters.' => 'Module SpamLookup pour modérer et nettoyer les feedbacks de vos lecteurs en utilisant des filtres de mots clefs.',

    ## ./plugins/spamlookup/tmpl/lookup_config.tmpl
    'Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog\'s Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.' => 'Les Lookups contrôlent les sources des adresses IP et les liens hypertextes de tous les feedbacks de vos lecteurs. Si un commentaire ou un TrackBack provient d\'une adresse IP blacklistée, ou contient un lien ou un domaine blacklisté, il pourra être automatiquement placé dans le dossier des élements indésirables.',
    'IP Address Lookups:' => 'Lookups Adresses IP :',
    'Off' => 'Désactivé',
    'Moderate feedback from blacklisted IP addresses' => 'Modérer les feedbacks des adresses IP blacklistées',
    'Junk feedback from blacklisted IP addresses' => 'Rejeter les feedbacks des adresses IP blacklistées',
    'Adjust scoring' => 'Ajuster la notation',
    'Score weight:' => 'Poids du score :',
    'Less' => 'Moins',
    'Decrease' => 'Baisser',
    'Increase' => 'Augmenter',
    'More' => 'Plus',
    'block' => 'bloquer',
    'none' => 'aucun',
    'Domain Name Lookups:' => 'Lookups Noms de Domaines :',
    'Moderate feedback containing blacklisted domains' => 'Modérer les feedbacks lecteurs contenant des domaines blacklistés',
    'Junk feedback containing blacklisted domains' => 'Rejeter les feedbacks contenant des domaines blacklistés',
    'Moderate TrackBacks from suspicious sources' => 'Modérer les TrackBacks provenant de sources douteuses',
    'Junk TrackBacks from suspicious sources' => 'Rejeter les TrackBacks provenant de sources douteuses',
    'To prevent lookups for some IP addresses or domains, list them below. Place each entry on a line by itself.' => 'Pour ne pas appliquer le LookUps sur certaines IP ou Domaines, les lister ci-dessous. Merci de saisir un élément par ligne.',
    'Lookup Whitelist:' => 'Lookup Whiteliste :',

    ## ./plugins/spamlookup/tmpl/url_config.tmpl
    'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Les Filtres de Liens contrôlent le nombre d\'hyperliens dans les commentaires ou les TrackBacks. S\'ils contiennent beaucoup de liens, ils peuvent être considérés comme indésirables.  Dans le cas contraire, les feedbacks avec peu de liens ou des liens déjà publiés seront acceptés. N\'activez cette fonction que si vous êtes certain que votre site est dénué de tout Spam.',
    'Credit feedback rating when no hyperlinks are present' => 'Accorder un crédit aux feedbacks dépourvus de liens',
    'Moderate when more than' => 'Modérer si plus de',
    'link(s) are given' => 'lien(s) sont soumis',
    'Junk when more than' => 'Rejeter si plus de',
    'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Accorder un crédit à un feedback quand &quot;URL&quot; l\'élément du feedback a été publié auparavant',
    'Only applied when no other links are present in message of feedback.' => 'Appliqué uniquement si aucun autre lien n\'est présent dans le message de feedback.',
    'Exclude URLs from comments published within last [_1] days.' => 'Exclure les URLS des commentaires publiés lors des [_1] derniers jours.',
    'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Accorder un crédit au feedback quand des commentaires préalablement publiés contiennent aussi &quot;Email&quot;',
    'Exclude Email addresses from comments published within last [_1] days.' => 'Exclure les adresses emails des commentaires publiés dans les  [_1] derniers jours.',

    ## ./plugins/spamlookup/tmpl/word_config.tmpl
    'Incomming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Les feedbacks des lecteurs peuvent être contrôlés sur un mot clef spécifique, un nom de domaine, ou leur forme. La combinaison de critères permet de détecter les indésirables. Vous pouvez paramétrer vos pondérations pour définir un indésirable.',

    ## ./plugins/StyleCatcher/stylecatcher.pl
    '<p style=' => '<p style=', # Translate - Previous (3)
    'Theme Root URL:' => 'URL Racine du Thème :',
    'Theme Root Path:' => 'Chemin Racine du Thème :',
    'Style Library URL:' => 'URL de la bibliothèque de styles :',

    ## ./plugins/StyleCatcher/tmpl/footer.tmpl

    ## ./plugins/StyleCatcher/tmpl/gmscript.tmpl

    ## ./plugins/StyleCatcher/tmpl/header.tmpl
    'View Site' => 'Voir le site',

    ## ./plugins/StyleCatcher/tmpl/view.tmpl
    'Please select a weblog to apply this theme.' => 'Merci de sélectionner un weblog auquel appliquer ce thème.',
    'Please click on a theme before attempting to apply a new design to your blog.' => 'Merci de cliquer  sur un thème avant d\'essayer d\'appliquer un nouveau design à votre weblog.',
    'Applying...' => 'Appliquer...',
    'Choose this Design' => 'Choisir ce design',
    'Find Style' => 'Trouver un style',
    'Loading...' => 'Chargement...',
    'StyleCatcher user script.' => 'Script utilisateur StyleCatcher.',
    'Theme or Repository URL:' => 'URL du Thème ou du Répertoire:',
    'Find Styles' => 'Trouver un Style',
    'NOTE:' => 'NOTE :',
    'It will take a moment for themes to populate once you click \'Find Style\'.' => 'La mise à jour des thèmes prendra quelques temps à partir du moment où vous cliquerez sur  \'trouver un style\'.',
    'Categories' => 'Catégories',
    'Current theme for your weblog' => 'Thème actuel de votre weblog',
    'Current Theme' => 'Thème Actuel',
    'Current themes for your weblogs' => 'Thèmes actuels de vos weblogs',
    'Current Themes' => 'Thèmes actuels',
    'Locally saved themes' => 'Thèmes enregistrés localement',
    'Saved Themes' => 'Thèmes enregistrés',
    'Single themes from the web' => 'Thèmes uniques venant du web',
    'More Themes' => 'Plus de thèmes',
    'Templates' => 'Modèles',
    'Details' => 'Détails',
    'Show Details' => 'Afficher les Détails',
    'Hide Details' => 'Masquer les Détails',
    'Select a Weblog...' => 'Sélectionner un weblog...',
    'Apply Selected Design' => 'Appliquer le Design sélectionné',
    'You don\'t appear to have any weblogs with a \'styles-site.css\' template that you have rights to edit. Please check your weblog(s) for this template.' => 'Il semble que sur aucun de vos blogs vous ne bénéficiez des droits d\'édition sur le modèle \'styles-site.css\'. Merci de vérifier la présence de ce modèle sur vos weblog(s).',

    ## ./plugins/TemplateRefresh/TemplateRefresh.pl
    'Backup and refresh existing templates to Movable Type\'s default templates.' => 'Sauvegarder et rafraîchir les modèles existants dans les modèles par défaut de Movable Type.',

    ## ./plugins/TemplateRefresh/tmpl/results.tmpl
    'Backup and Refresh Templates' => 'Sauvegarder et rafraîchir les modèles',
    'No templates were selected to process.' => 'Aucun modèle sélectionné pour cette action.',
    'Return' => 'Retour',

    ## ./plugins/Textile/textile2.pl

    ## ./plugins/WidgetManager/WidgetManager.pl
    'Maintain your weblog\'s widget content using a handy drag and drop interface.' => 'Administrez les widgets de votre weblog en utilisant une interface glisser/déplacer.',

    ## ./plugins/WidgetManager/default_widgets/calendar.tmpl
    'Monthly calendar with links to each day\'s posts' => 'Calendrier mensuel avec des liens vers les notes quotidiennes',
    'Sunday' => 'Dimanche',
    'Sun' => 'Dim',
    'Monday' => 'Lundi',
    'Mon' => 'Lun',
    'Tuesday' => 'Mar',
    'Tue' => 'Mar',
    'Wednesday' => 'Mercredi',
    'Wed' => 'Mer',
    'Thursday' => 'Jeudi',
    'Thu' => 'Jeu',
    'Friday' => 'Vendredi',
    'Fri' => 'Ven',
    'Saturday' => 'Samedi',
    'Sat' => 'Sam',

    ## ./plugins/WidgetManager/default_widgets/category_archive_list.tmpl

    ## ./plugins/WidgetManager/default_widgets/copyright.tmpl

    ## ./plugins/WidgetManager/default_widgets/creative_commons.tmpl
    'This weblog is licensed under a' => 'Ce weblog est sujet à une licence',
    'Creative Commons License' => 'Creative Commons',

    ## ./plugins/WidgetManager/default_widgets/date-based_author_archives.tmpl

    ## ./plugins/WidgetManager/default_widgets/date-based_category_archives.tmpl

    ## ./plugins/WidgetManager/default_widgets/monthly_archive_dropdown.tmpl
    'Archives' => 'Archives', # Translate - Previous (1)
    'Select a Month...' => 'Sélectionnez un Mois...',

    ## ./plugins/WidgetManager/default_widgets/monthly_archive_list.tmpl

    ## ./plugins/WidgetManager/default_widgets/pages_list.tmpl

    ## ./plugins/WidgetManager/default_widgets/powered_by.tmpl

    ## ./plugins/WidgetManager/default_widgets/recent_comments.tmpl
    'Recent Comments' => 'Commentaires récents',

    ## ./plugins/WidgetManager/default_widgets/recent_posts.tmpl
    'Recent Posts' => 'Notes récentes',

    ## ./plugins/WidgetManager/default_widgets/search.tmpl
    'Search this blog:' => 'Chercher dans ce blog :',

    ## ./plugins/WidgetManager/default_widgets/signin.tmpl

    ## ./plugins/WidgetManager/default_widgets/subscribe_to_feed.tmpl
    'Subscribe to this blog\'s feed' => 'S\'abonner au flux de ce blog',
    'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds', # Translate - Previous (6)
    'What is this?' => 'De quoi s\'agit-il?',

    ## ./plugins/WidgetManager/default_widgets/tag_cloud_module.tmpl
    'Tag cloud' => 'Nuage de Tag',

    ## ./plugins/WidgetManager/default_widgets/technorati_search.tmpl
    'Technorati' => 'Technorati', # Translate - Previous (1)
    'this blog' => 'ce blog',
    'all blogs' => 'tous les blogs',
    'Blogs that link here' => 'Blogs pointant ici',

    ## ./plugins/WidgetManager/tmpl/edit.tmpl
    'Please use a unique name for this widget manager.' => 'Merci d\'utiliser un nom unique pour ce gestionnaire de widgets.', # Translate - New (9)
    'You already have a widget manager named [_1]. Please use a unique name for this widget manager.' => 'Vous avez déjà un gestionnaire de Widgets nommé [_1]. Merci d\'utiliser un nom unique pour ce gestionnaire de Widgets.',
    'Your changes to the Widget Manager have been saved.' => 'Vos changements dans votre Gestionnaire de Widgets sont enregistrés.',
    'Installed Widgets' => 'Widgets installés',
    'Available Widgets' => 'Widgets disponibles',
    'Save Changes' => 'Enregistrer les modifications',
    'Save changes (s)' => 'Enregistrer les modifications',

    ## ./plugins/WidgetManager/tmpl/footer.tmpl

    ## ./plugins/WidgetManager/tmpl/header.tmpl
    'Movable Type Publishing Platform' => 'Plateforme de publication Movable Type',
    'Go to:' => 'Aller à :',
    'Select a blog' => 'Sélectionner un blog',
    'Weblogs' => 'Weblogs', # Translate - Previous (1)
    'System-wide listing' => 'Listing sur la totalité du système',

    ## ./plugins/WidgetManager/tmpl/list.tmpl

    ## ./plugins/WXRImporter/WXRImporter.pl
    'Import WordPress exported RSS into MT.' => 'Importer dans MT du RSS exporté de WordPress.', # Translate - New (6)

    ## ./plugins/WXRImporter/tmpl/options.tmpl
    'Site Root' => 'Site Racine',
    'Archive Root' => 'Archive Racine',

    ## ./search_templates/comments.tmpl
    'Search Results' => 'Résultats de recherche',
    'Search for new comments from:' => 'Recherche de nouveaux commentaires depuis :',
    'the beginning' => 'le début',
    'one week back' => 'une semaine',
    'two weeks back' => 'deux semaines',
    'one month back' => 'un mois',
    'two months back' => 'deux mois',
    'three months back' => 'trois mois',
    'four months back' => 'quatre mois',
    'five months back' => 'cinq mois',
    'six months back' => 'six mois',
    'one year back' => 'un an',
    'Find new comments' => 'Trouver les nouveaux commentaires',
    'Posted in [_1] on [_2]' => 'Publié dans [_1] le [_2]',
    'No results found' => 'Aucun résultat n\'a été trouvé',
    'No new comments were found in the specified interval.' => 'Aucun nouveau commentaire n\'a été trouvé dans la période spécifiée.',
    'Instructions' => 'Instructions', # Translate - Previous (1)
    'Select the time interval that you\'d like to search in, then click \'Find new comments\'' => 'Sélectionner l\'intervalle de temps désiré pour la recherche, puis cliquez sur \'Trouver les nouveaux commentaires\'',

    ## ./search_templates/default.tmpl
    'SEARCH FEED AUTODISCOVERY LINK PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'LE LIEN DU FLUX DE LA RECHERCHE AUTOMATISÉE EST PUBLIÉ UNIQUEMENT APRES L\'EXÉCUTION DE LA RECHERCHE.',
    'Blog Search Results' => 'Résultats de la recherche',
    'Blog search' => 'Recherche de Blog',
    'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'LES RECHERCHES SIMPLES ONT LE FORMULAIRE DE RECHERCHES',
    'Search this site' => 'Rechercher sur ce site',
    'Match case' => 'Respecter la casse',
    'Regex search' => 'Expression générique',
    'SEARCH RESULTS DISPLAY' => 'AFFICHAGE DES RESULTATS DE LA RECHERCHE',
    'Matching entries from [_1]' => 'Notes correspondant à [_1]',
    'Entries from [_1] tagged with \'[_2]\'' => 'Notes à partir de [_1] taguées avec \'[_2]\'',
    'Tags' => 'Tags', # Translate - Previous (1)
    'Posted <MTIfNonEmpty tag=' => 'Publiée <MTIfNonEmpty tag=',
    'Showing the first [_1] results.' => 'Afficher les premiers [_1] resultats.',
    'NO RESULTS FOUND MESSAGE' => 'MESSAGE AUCUN RÉSULTAT',
    'Entries matching \'[_1]\'' => 'Notes correspondant à \'[_1]\'',
    'Entries tagged with \'[_1]\'' => 'Notes taguées avec \'[_1]\'',
    'No pages were found containing \'[_1]\'.' => 'Aucune page trouvée contenant \'[_1]\'.',
    'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes' => 'Par défaut, ce moteur de recherche analyse l\'ensemble des mots sans se préocupper de leur ordre. Pour lancer une recherche sur une phrase exacte, insérez-la entre guillemets.',
    'movable type' => 'movable type', # Translate - Previous (2)
    'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions' => 'Le moteur de recherche admet aussi AND, OR et NOT mais pas des mots clefs pour spécifier des expressions particulières',
    'personal OR publishing' => 'personnel OR publication',
    'publishing NOT personal' => 'publication NOT personnel',
    'END OF ALPHA SEARCH RESULTS DIV' => 'FIN DE LA RECHERCHE ALPHA RESULTATS DIV',
    'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'DEBUT DE LA COLONNE BETA POUR AFFICHAGE DES INFOS DE RECHERCHE',
    'SET VARIABLES FOR SEARCH vs TAG information' => 'DEFINIT LES VARIABLES DE RECHERCHE vs informations TAGS',
    'Subscribe to feed' => 'S\'abonner au flux',
    'If you use an RSS reader, you can subscribe to a feed of all future entries tagged \'[_1]\'.' => 'Si vous utilisez un lecteur de flux RSS, vous pouvez souscrire au flux de toutes notes futures dont le tag sera \'[_1]\'.',
    'If you use an RSS reader, you can subscribe to a feed of all future entries matching \'[_1]\'.' => 'Si vous utilisez un lecteur de flux RSS, vous pouvez souscrire au flux des futures notes contenant le mot \'[_1]\'.',
    'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'RECHERCHE/INFORMATION D\'ABONNEMENT AU FLUX',
    'Feed Subscription' => 'Abonnement au flux',
    'TAG LISTING FOR TAG SEARCH ONLY' => 'LISTE DES TAGS UNIQUEMENT POUR LA RECHERCHE DE TAG',
    'Other Tags' => 'Autres Tags',
    'END OF PAGE BODY' => 'FIN DU CORPS DE LA PAGE',
    'END OF CONTAINER' => 'FIN DU CONTENU',

    ## ./search_templates/results_feed.tmpl
    'Search Results for [_1]' => 'Résultats de la recherche sur [_1]',

    ## ./search_templates/results_feed_rss2.tmpl

    ## ./t/blog-common.pl

    ## ./t/driver-tests.pl

    ## ./t/test-common.pl

    ## ./t/test.tmpl

    ## ./t/plugins/testplug.pl

    ## ./tmpl/error.tmpl
    'Missing Configuration File' => 'Fichier de configuration manquant',
    'Database Connection Error' => 'Erreur de connexion à la base de données',
    'CGI Path Configuration Required' => 'Configuration de chemin CGI requise',
    'An error occurred' => 'Une erreur s\'est produite',

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
    'Remove selected assocations (x)' => 'Supprimer les associations sélectionnées(x)',
    'association' => 'association', # Translate - Previous (1)
    'associations' => 'associations', # Translate - Previous (1)

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
    'Delete' => 'Supprimer',
    'tag' => 'tag', # Translate - Previous (1)
    'tags' => 'tags', # Translate - Previous (1)
    'Delete selected tags (x)' => 'Effacer les tags sélectionnés (x)',

    ## ./tmpl/cms/list_template.tmpl
    'template' => 'modèle',
    'templates' => 'modèles',

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
    'Clear Activity Log' => 'Effacer le journal des activités', # Translate - New (3)

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
    'Status' => 'Statut',
    'Username' => 'Nom d\'utilisateur',
    'Name' => 'Nom',
    'Email' => 'Adresse email',
    'URL' => 'URL', # Translate - Previous (1)
    'Only show enabled users' => 'Ne montrer que les utilisateurs activés',
    'Only show pending users' => 'Ne montrer que les utilisateurs en attente', # Translate - New (4)
    'Only show disabled users' => 'Ne montrer que les utilisateurs désactivés',
    'Link' => 'Lien',

    ## ./tmpl/cms/include/backup_end.tmpl
    'All of the data has been backed up successfully!' => 'Toutes les données ont été sauvegardées avec succès!', # Translate - New (9)
    'Filename' => 'Nom de fichier', # Translate - New (1)
    '_external_link_target' => '_haut',
    'Download This File' => 'Télécharger ce fichier', # Translate - New (3)
    'An error occurred during the backup process: [_1]' => 'Une erreur est survenue pendant la sauvegarde: [_1]', # Translate - New (8)

    ## ./tmpl/cms/include/backup_start.tmpl

    ## ./tmpl/cms/include/blog-left-nav.tmpl
    'Creating' => 'Créer', # Translate - New (1)
    'Create New Entry' => 'Créer une nouvelle note',
    'New Entry' => 'Nouvelle note',
    'List Entries' => 'Afficher les notes',
    'List uploaded files' => 'Lister les fichiers envoyés', # Translate - New (3)
    'Assets' => 'Eléments', # Translate - New (1)
    'Community' => 'Communauté',
    'List Comments' => 'Afficher les commentaires',
    'Comments' => 'Commentaires',
    'List Commenters' => 'Lister les auteurs de commentaires',
    'Commenters' => 'Auteurs de Commentaires',
    'List TrackBacks' => 'Lister les TrackBacks',
    'TrackBacks' => 'TrackBacks', # Translate - Previous (1)
    'Edit Notification List' => 'Modifier la liste des avis',
    'Notifications' => 'Notifications', # Translate - Previous (1)
    'Configure' => 'Configurer',
    'List Users &amp; Groups' => 'Liste des utilisateurs &amp; Groupes',
    'Users &amp; Groups' => 'Utilisateurs &amp; Groupes',
    'List &amp; Edit Templates' => 'Lister &amp; Editer les modèles',
    'Edit Categories' => 'Modifier les catégories',
    'Edit Tags' => 'Editer les Tags',
    'Edit Weblog Configuration' => 'Modifier la configuration du weblog',
    'Settings' => 'Paramètres',
    'Utilities' => 'Utilitaires',
    'Search &amp; Replace' => 'Chercher &amp; Remplacer',
    'Backup this weblog' => 'Sauvegarder ce weblog', # Translate - New (3)
    'Backup' => 'Sauvegarde', # Translate - New (1)
    'View Activity Log' => 'Afficher le journal des activités',
    'Activity Log' => 'Journal des activités',
    'Import &amp; Export Entries' => 'Importer &amp; Exporter les Notes',
    'Import / Export' => 'Importer / Exporter',
    'Rebuild Site' => 'Actualiser le site',

    ## ./tmpl/cms/include/blog_table.tmpl

    ## ./tmpl/cms/include/cfg_content_nav.tmpl

    ## ./tmpl/cms/include/cfg_entries_edit_page.tmpl
    'Default' => 'Par défaut', # Translate - New (1)
    'Custom' => 'Perso',
    'Title' => 'Titre',
    'Body' => 'Corps', # Translate - New (1)
    'Category' => 'Catégorie',
    'Excerpt' => 'Extrait',
    'Keywords' => 'Mots-clés',
    'Publishing' => 'Publication',
    'Feedback' => 'Feedback', # Translate - Previous (1)
    'Below' => 'Sous',
    'Above' => 'Dessus',
    'Both' => 'Les deux',

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
    'All data imported successfully!' => 'Toutes les données ont été importées avec succès !',
    'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Assurez vous d\'avoir bien enlevé les fichiers importés du dossier \'import\', pour éviter une ré-importation des mêmes fichiers à l\'avenir .',
    'An error occurred during the import process: [_1]. Please check your import file.' => 'Une erreur s\'est produite pendant le processus: [_1]. Merci de vérifier vos fichiers import.',

    ## ./tmpl/cms/include/import_start.tmpl
    'Importing entries into blog' => 'Importation de notes dans le blog',
    'Importing entries as user \'[_1]\'' => 'Importation des notes en tant qu\'utilisateur \'[_1]\'',
    'Creating new users for each user found in the blog' => 'Création de nouveaux utilisateur correspondant à chaque utilisateur trouvé dans le blog',

    ## ./tmpl/cms/include/itemset_action_widget.tmpl

    ## ./tmpl/cms/include/listing_panel.tmpl
    'Step [_1] of [_2]' => 'Etape  [_1] sur [_2]',
    'View All' => 'Tout afficher',
    'Go to [_1]' => 'Aller à [_1]',
    'Sorry, there were no results for your search. Please try searching again.' => 'Desolé, aucun résultat trouvé pour cette recherche. Merci d\'essayer à nouveau.',
    'Sorry, there is no data for this object set.' => 'Désolé, mais il n\'y a pas de données pour cet ensemble d\'objets.',
    'Cancel' => 'Annuler',
    'Back' => 'Retour',
    'Confirm' => 'Confirmer',

    ## ./tmpl/cms/include/login_mt.tmpl
    'Remember me?' => 'Mémoriser les informations de connexion ?',

    ## ./tmpl/cms/include/log_table.tmpl

    ## ./tmpl/cms/include/notification_table.tmpl

    ## ./tmpl/cms/include/overview-left-nav.tmpl
    'System' => 'Système',
    'List Weblogs' => 'Liste des Weblogs',
    'List Users and Groups' => 'Lister les Utilisateurs et les Groupes',
    'List Associations and Roles' => 'Lister les associations et les roles',
    'Privileges' => 'Privilèges',
    'List Plugins' => 'Liste des Plugins',
    'Plugins' => 'Plugins', # Translate - Previous (1)
    'Aggregate' => 'Multi-Blogs',
    'List Tags' => 'Liste de Tags',
    'Edit System Settings' => 'Editer les Paramètres Système',
    'Show Activity Log' => 'Afficher les logs d\'activité',

    ## ./tmpl/cms/include/pagination.tmpl

    ## ./tmpl/cms/include/ping_table.tmpl

    ## ./tmpl/cms/include/rebuild_stub.tmpl
    'To see the changes reflected on your public site, you should rebuild your site now.' => 'Vous pouvez actualiser votre site de façon à voir les modifications reflétées sur votre site publié',
    'Rebuild my site' => 'Actualiser le site',

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
    'Register' => 'Enregistrement', # Translate - New (1)

    ## ./tmpl/comment/signup.tmpl

    ## ./tmpl/comment/signup_thanks.tmpl

    ## ./tmpl/comment/include/footer.tmpl

    ## ./tmpl/comment/include/header.tmpl

    ## ./tmpl/email/commenter_confirm.tmpl
    'Thank you registering for an account to comment on [_1].' => 'Merci de vous être enregistré pour commenter sur [_1].', # Translate - New (10)
    'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to comment on [_1].' => 'Pour votre propre sécurité et pour éviter les fraudes, nous vous demandons de confirmer votre compte et votre adresse email avant de continuer. Vous pourrez ensuite immédiatement commenter sur [_1].', # Translate - New (32)
    'To confirm your account, please click on or cut and paste the following URL into a web browser:' => 'Pour confirmer votre compte, cliquez ou copiez-collez l\'adresse suivante dans un navigateur web:', # Translate - New (18)
    'If you did not make this request, or you don\'t want to register for an account to comment on [_1], then no further action is required.' => 'Si vous n\'êtes pas à l\'origine de cette demande, ou si vous ne souhaitez pas vous enregistrer pour commenter sur [_1], alors aucune action n\'est nécessaire.', # Translate - New (27)
    'Thank you very much for your understanding.' => 'Merci beaucoup pour votre compréhension.', # Translate - New (7)
    'Sincerely,' => 'Cordialement,', # Translate - New (1)

    ## ./tmpl/email/commenter_notify.tmpl
    'This email is to notify you that a new user has successfully registered on the blog \'[_1].\' Listed below you will find some useful information about this new user.' => 'Cet email vous est envoyé pour vous signaler qu\'un nouvel utilisateur s\'est enregistré avec succès sur le blog \'[_1].\' Ci-dessous vous trouverez des informations utiles sur ce nouvel utilisateur.', # Translate - New (29)
    'Username:' => 'Nom d\'utilisateur:',
    'Full Name:' => 'Nom complet:', # Translate - New (2)
    'Email:' => 'Email:', # Translate - New (1)
    'To view or edit this user, please click on or cut and paste the following URL into a web browser:' => 'Pour voir ou modifier cet utilisateur, merci de cliquer ou copier-coller l\'adresse suivante dans votre navigateur web:', # Translate - New (20)

    ## ./tmpl/email/footer-email.tmpl
    'Powered by Movable Type' => 'Powered by Movable Type', # Translate - Previous (4)
    'Version [_1]' => 'Version [_1]', # Translate - Previous (2)
    'http://www.sixapart.com/movabletype/' => 'http://www.movabletype.fr',

    ## ./tmpl/email/new-comment.tmpl
    'An unapproved comment has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => 'Un commentaire non approuvé a été envoyé sur votre blog [_1], pour la note #[_2] ([_3]). Vous devez l\'approuver pour qu\'il apparaisse sur votre blog.',
    'Approve this comment:' => 'Approuver ce commentaire:',
    'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Un nouveau commentaire a été publié sur votre weblog [_1], au sujet de la note [_2] ([_3]). ',
    'View this comment' => 'Voir ce commentaire', # Translate - New (3)
    'Report this comment as spam' => 'Notifier ce commentaire comme spam', # Translate - New (5)
    'Edit this comment' => 'Editer ce commentaire',
    'IP Address' => 'Adresse IP',
    'Email Address' => 'Adresse e-mail',
    'Comments:' => 'Commentaires :',

    ## ./tmpl/email/new-ping.tmpl
    'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Un Trackback non approuvé a été envoyé pour votre weblog [_1], pour la note #[_2] ([_3]). Vous devez l\'approuver pour qu\'il apparaisse sur votre blog.',
    'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Un Trackback non approuvé a été envoyé pour votre weblog [_1], pour la catégorie #[_2], ([_3]). Vous devez l\'approuver pour qu\'il apparaisse sur votre blog.',
    'Approve this TrackBack' => 'Approuver ce TrackBack', # Translate - New (3)
    'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Un nouveau Trackback a été envoyé sur votre blog [_1], sur la note #[_2] ([_3]).',
    'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'Un nouveau Trackback a été envoyé sur votre blog [_1], sur la catégorie #[_2] ([_3]).',
    'View this TrackBack' => 'Voir ce TrackBack', # Translate - New (3)
    'Report this TrackBack as spam' => 'Notifier ce TrackBack comme spam', # Translate - New (5)
    'Edit this TrackBack' => 'Modifier ce TrackBack',

    ## ./tmpl/email/notify-entry.tmpl
    'A new post entitled \'[_1]\' has been published to [_2].' => 'Une nouvelle note titrée \'[_1]\' a été publiée sur [_2].', # Translate - New (10)
    'View post' => 'Voir la note', # Translate - New (2)
    'Post Title' => 'Titre de la note', # Translate - New (2)
    'Publish Date' => 'Date de publication', # Translate - New (2)
    'Message from Sender' => 'Message de l\'expéditeur', # Translate - New (3)
    'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'Vous recevez cet email car vous avez demandé à recevoir les notifications de nouveau contenu sur [_1], ou l\'auteur de la note a pensé que vous seriez intéressé. Si vous ne souhaitez plus recevoir ces emails, merci de contacter la personne suivante:', # Translate - New (43)

    ## ./tmpl/email/recover-password.tmpl

    ## ./tmpl/email/verify-subscribe.tmpl
    'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Merci d\'avoir pour votre inscription aux mises à jours [_1]. Cliquez sur le lien ci-dessous pour confirmer cette inscription :',
    'If the link is not clickable, just copy and paste it into your browser.' => 'Si le lien n\'est pas cliquable, faites simplement un copier-coller dans votre navigateur.',

    ## ./tmpl/feeds/error.tmpl
    'Movable Type Activity Log' => 'Movable Type Log d\'activité',
    'Movable Type System Activity' => 'Movable Type activité du système',

    ## ./tmpl/feeds/feed_chrome.tmpl

    ## ./tmpl/feeds/feed_comment.tmpl
    'system' => 'système',
    'Published' => 'Publié',
    'Unpublished' => 'Non publié',
    'Blog' => 'Blog', # Translate - Previous (1)
    'Entry' => 'Note',
    'Untitled' => 'Sans nom',
    'Commenter' => 'Auteur de commentaires',
    'Actions' => 'Actions', # Translate - Previous (1)
    'Edit' => 'Editer',
    'Unpublish' => 'Dé-publier',
    'Publish' => 'Publier',
    'Junk' => 'Indésirable',
    'More like this' => 'Plus du même genre',
    'From this blog' => 'De ce blog',
    'On this entry' => 'Sur cette note',
    'By commenter identity' => 'Par identité de l\'auteur de commentaires',
    'By commenter name' => 'Par nom de l\'auteur de commentaires',
    'By commenter email' => 'Par l\'e-mail de l\'auteur de commentaires',
    'By commenter URL' => 'Par URL de l\'auteur de commentaires',
    'On this day' => 'Pendant cette journée',

    ## ./tmpl/feeds/feed_entry.tmpl
    'Author' => 'Auteur',
    'From this author' => 'De cet auteur',

    ## ./tmpl/feeds/feed_ping.tmpl
    'Source blog' => 'Blog source',
    'By source blog' => 'Par le blog source',
    'By source title' => 'Par le titre de la source',
    'By source URL' => 'Par l\'URL de la source',

    ## ./tmpl/feeds/feed_system.tmpl

    ## ./tmpl/feeds/login.tmpl
    'This link is invalid. Please resubscribe to your activity feed.' => 'Ce lien n\'est pas valide. Merci de souscrire à nouveau à votre flux d\'activité.',

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
    'Bad ObjectDriver config' => 'Mauvaise config ObjectDriver',
    'Two plugins are in conflict' => 'Deux plugins sont en conflit',
    'RSS 1.0 Index' => 'Index RSS 1.0',
    'Comment \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4]) from entry \'[_5]\' (entry #[_6])' => 'Commentaire \'[_1]\' (#[_2]) effacé par \'[_3]\' (utilisateur #[_4]) de la note \'[_5]\' (note #[_6])',
    'Create Entries' => 'Création d\'une note',
    'Remove Tags...' => 'Enlever les Tags...',
    '_BLOG_CONFIG_MODE_BASIC' => 'Mode basique',
    'No weblog was selected to clone.' => 'Aucun weblog n\'a été sélectionné pour la duplication',
    'Username or password recovery phrase is incorrect.' => 'La phrase test pour retrouver votre identifiant ou votre mot de passe est incorrecte.',
    'Comment Pending Message' => 'Message de Commentaire en Attente',
    '_NO_SUPERUSER_DISABLE' => 'Puisque vous êtes administrateur du système Movable Type, vous ne pouvez vous désactiver vous-même.',
    'YEARLY_ADV' => 'YEARLY_ADV', # Translate - New (2)
    'Invalid attempt to recover password (used recovery phrase \'[_1]\')' => 'Tentative non valide de récupération du mot de passe (a utilisé la phrase test \'[_1]\')',
    'Updating blog old archive link status...' => 'Modification de l\'ancien statut du lien d\'archive du blog...',
    'Movable Type Enterprise has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.' => 'Movable Type Enterprise vient de tenter de désactiver votre compte pendant la synchronisation avec l\'annuaire externe. Certains des paramètres du sytème de gestion externe des utilisateurs doivent être erronés. Merci de corriger avant de poursuivre.',
    'Showing' => 'Affiche',
    '_USAGE_COMMENT' => 'Modifiez le commentaire sélectionné. Cliquez sur Enregistrer une fois les modifications apportées. Vous devrez actualiser vos fichiers pour voir les modifications reflétées sur votre site.',
    'No password recovery phrase set in user profile. Please see your system administrator for password recovery.' => 'Le profil ne contient pas de phrase test pour la récupération du mot de passe. Merci de contacter l\'administrateur système pour récupérer votre mot de passe.',
    'Database Path' => 'Chemin de la Base de Données',
    'Deleting a user is an irrevocable action which creates orphans of the author\'s entries.  If you wish to retire a user or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete this author?' => 'La suppression d\'un utilisateur est irrévocable et peut créer des notes orphelines (sans utilisateur). Si vous souhaitez retirer l\'accès au système à un utilisateur, il est recommandé de lui retirer les droits plutôt que de le supprimer. Êtes-vous sûr de vouloir supprimer cet utilisateur ?',
    'An error occurred processing [_1]. Check <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">here</a> for more detail and please try again.' => 'Une erreur est survenue pendant le traitement [_1]. Consultez <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">cette page</a> pour plus de détails et réessayez après.',
    'Created template \'[_1]\'.' => 'A créé le template \'[_1]\'.',
    'View image' => 'Voir l\'image',
    'Date-Based Archive' => 'Archivage par date',
    'Enable External User Management' => 'Activer La Gestion Externe des Utilisateurs',
    'Assigning visible status for comments...' => 'Ajout du statut visible pour les commentaires...',
    'Step 4 of 4' => 'Etape 4 sur 4',
    'Designer' => 'Designer', # Translate - Previous (1)
    'Create a feed widget' => 'Créer un nouveau widget de flux',
    'Enter the ID of the weblog you wish to use as the source for new personal weblogs. The new weblog will be identical to the source except for the name, publishing paths and permissions.' => 'Saisissez l\'identifiant du weblog que vous souhaitez utiliser comme source pour créer votre nouveau weblog personnel. Le nouveau weblog sera identique au blog source à l\'exception du nom, du chemin de publication et des autorisations associées.',
    'Bad CGIPath config' => 'Mauvaise config CGIPath',
    'Weblog Administrator' => 'Administrateur du weblog',
    'If present, 3rd argument to add_callback must be an object of type MT::Plugin' => 'Si présent, le 3ème argument de add_callback doit être un object de type MT::Plugin',
    '_USAGE_GROUPS_USER' => 'Ci-dessous une liste des groupes dont l utilisateur est membre. Vous pouvez enlever un utilisateur d un groupe dont il est membre en sélectionnant le groupe adéquat et en cliquant sur supprimer',
    '_WARNING_PASSWORD_RESET_MULTI' => 'Vous êtes sur le point de réinitialiser le mot de passe des utilisateurs sélectionnés. Les nouveaux mots de passe sont générés automatiquement et serront envoyés directement aux utilisateurs par e-mail.\n\nEtes-vous sûr de vouloir continuer ?',
    'You must define a Comment Listing template in order to display dynamic comments.' => 'Vous devez définir un template Comment Listing pour afficher des commentaires dynamiquement.',
    'Assigning blog administration permissions...' => 'Ajout des permissions d\'administration du blog...',
    'Invalid LDAPAuthURL scheme: [_1].' => 'Schéma LDAPAuthURL non valide : [_1].',
    'Can edit all entries/categories/tags on a weblog and rebuild.' => 'Peut éditer toutes les notes/catégorie/tags sur un weblog et republier.',
    'Category Archive' => 'Archivage par catégorie',
    'Monitor' => 'Controler',
    'Updating user permissions for editing tags...' => 'Modification des permissions des utilisateurs pour modifier les balises...',
    '_USAGE_EXPORT_1' => 'L\'exportation de vos notes de Movable Type vous permet de créer une <b>version de sauvegarde</b> du contenu de votre weblog. Le format des notes exportées convient à leur importation dans le système à l\'aide du mécanisme d\'importation (voir ci-dessus), ce qui vous permet, en plus d\'exporter vos notes à des fins de sauvegarde, d\'utiliser cette fonction pour <b>transférer vos notes d\'un weblog à un autre</b>.',
    'Setting default blog file extension...' => 'Ajout de l\'extension de fichier par défaut du blog...',
    'Migrating permissions to roles...' => 'Migre les autorisations vers les roles...',
    '<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> est la catégorie précédente.',
    'Name:' => 'Nom:',
    'Atom Index' => 'Index Atom',
    'Weblog \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' créé par \'[_2]\' (utilisateur #[_3])',
    'Invalid priority level [_1] at add_callback' => 'Niveau de priorité invalide [_1] dans add_callback',
    'Add Tags...' => 'Ajouter des Tags...',
    '_THROTTLED_COMMENT_EMAIL' => 'Un visiteur de votre weblog [_1] a été automatiquement bannit après avoir publié une quantité de commentaires supérieure à la limite établie au cours des [_2] secondes. Cette opération est destinée à empêcher la publication automatisée de commentaires par des scripts. L\'adresse IP bannie est

    [_3]

S\'il s\'agit d\'une erreur, vous pouvez annuler le bannissement de l\'adresse IP dans Movable Type, sous Configuration du weblog > Bannissement d\'adresses IP, et en supprimant l\'adresse IP [_4] de la liste des addresses bannies.',
    'Permission denied for non-superuser' => 'Autorisation refusée pour les non super-utilisateurs',
    'Ping \'[_1]\' (ping #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Ping \'[_1]\' (ping #[_2]) effacé par \'[_3]\' (utilisateur #[_4])',
    'Category \'[_1]\' (category #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Catégorie \'[_1]\' (catégorie #[_2]) effacée par \'[_3]\' (utilisateur #[_4])',
    'MONTHLY_ADV' => 'par mois',
    '_USER_ENABLED' => 'Utilisateur activé',
    'Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]' => 'Pour envoyer des mails via SMTP votre serveur doit avoir Mail::Sendmail installé: [_1]',
    'Manage Tags' => 'Gérer les Tags',
    'Taxonomist' => 'Taxonomist', # Translate - Previous (1)
    '_USAGE_BOOKMARKLET_3' => 'Pour installer le signet QuickPost de Movable Type: déposez le lien suivant dans le menu ou la barre d\'outils des liens favoris de votre navigateur.',
    'Are you sure you want to delete the selected group(s)?' => 'Etes-vous sûr de vouloir supprimer le(s) groupe(s) sélectionné(s)? ',
    'Assigning user status...' => 'Attribue le statut utilisateur...',
    'User \'[_1]\' (#[_2]) untrusted commenter \'[_3]\' (#[_4]).' => 'Utilisateur \'[_1]\' (#[_2]) a considéré non fiable le commentateur \'[_3]\' (#[_4]).',
    'Create New User Association' => 'Créer Association Nouvel Utilisateur',
    'File with name \'[_1]\' already exists. (Install File::Temp if you\'d like to be able to overwrite existing uploaded files.)' => 'Le fichier dont le nom est \'[_1]\' existe déjà. (Installez File::Temp si vous souhaitez pouvoir écraser les fichiers déjà chargés.)',
    'Category \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Catégorie \'[_1]\' créée par \'[_2]\' (utilisateur #[_3])',
    'DBI and DBD::SQLite2 are required if you want to use the SQLite2 database backend.' => 'DBI et DBD::SQLite2 sont nécessaires si vous souhaitez utiliser SQLite2 comme base de données.',
    'Are you sure you want to delete the [_1] selected [_2]?' => 'Etes-vous sûr de vouloir supprimer les [_1] [_2] sélectionné(e)s?',
    '_USAGE_GROUPS_LDAP' => 'Ceci est un message pour les groupes sous LDAP.',
    'New TrackBack for entry #[_1] \'[_2]\'.' => 'Nouveau TrackBack pour la note #[_1] \'[_2]\'.',
    'An error occured during synchronization: [_1]' => 'Une erreur s\'est produite pendant la synchronisation: [_1]',
    '4th argument to add_callback must be a CODE reference.' => '4ème argument de add_callback doit être une référence de CODE.',
    'Or return to the <a href="[_1]">Main Menu</a> or <a href="[_2]">System Overview</a>.' => 'Ou retournez au <a href="[_1]">Menu Principal</a> ou à l\'<a href="[_2]">Aperçu du général du Système</a>.',
    'Can create entries and edit their own.' => 'Peuvent créer et éditer leurs propres notes.',
    'Monthly' => 'Mensuelles',
    'Editor' => 'Editeur',
    'Refreshing template \'[_1]\'.' => 'Actualisation du modèle \'[_1]\'.',
    'Ban Commenter(s)' => 'Bannir cet auteur de commentaires',
    'Created <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Créé <MTIfNonEmpty tag="EntryAuthorDisplayName">par [_1] </MTIfNonEmpty>on [_2]', # Translate - New (9)
    'Installation instructions.' => 'Instruction d\'Installation.',
    'Secretary' => 'Secretaire',
    '_USAGE_ARCHIVING_3' => 'Sélectionnez le type d\'archive auquel vous souhaitez ajouter un modèle. Sélectionnez le modèle que vous souhaitez associer à ce type d\'archive.',
    'Hello, world' => 'Bonjour,',
    'You need to create some users.' => 'Vous devez créer des utilisateurs.',
    'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Saut du modèle \'[_1]\' car c\'est un modèle personnalisé.',
    'The above settings have been written to the file <tt>[_1]</tt>. If any of these settings are incorrect, you may click the \'Back\' button below to reconfigure them.' => 'Les paramètres ci-dessus ont été enregistrés dans le fichier <tt>[_1]</tt>. Si un de ces paramètres est incorrect, veuillez cliquer sur le bouton \'Retour\' ci-dessous pour modifier la configuration.',
    '_USER_DISABLE' => 'Désactiver',
    'You used an \'[_1]\' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an \'MTComments\' container?' => 'Vous avez utilisé une balise \'[_1]\' en dehors du contexte d\'un commentaire; peut-être l\'avez vous mis par erreur en dehors du conteneur \'MTComments\' ?',
    '_ERROR_CGI_PATH' => 'Votre configuration de chemin CGI est invalide ou absente de vos fichiers de configuration Movable Type. Merci de consulter la base de connaissance',
    'Insufficient permissions to modify templates for weblog \'[_1]\'' => 'Niveau d\'autorisation insuffisant pour modifier le template du weblog \'[_1]\'',
    'Assigning template build dynamic settings...' => 'Ajout des réglages de construction dynamique du template...',
    '_USAGE_CATEGORIES' => 'Les catégories permettent de regrouper vos notes pour en faciliter la gestion, la mise en archives et l\'affichage dans votre weblog. Vous pouvez affecter une catégorie à chaque note que vous créez ou modifiez. Pour modifier une catégorie existante, cliquez sur son titre. Pour créer une sous-catégorie, cliquez sur le bouton Créer correspondant. Pour déplacer une catégorie, cliquez sur le bouton Déplacer correspondant.',
    '_USAGE_AUTHORS_2' => 'Vous pouvez créer, éditer ou supprimer des utilisateurs en utilisant un fichier commande au format CSV.',
    'User \'[_1]\' (#[_2]) trusted commenter \'[_3]\' (#[_4]).' => 'Utilisateur \'[_1]\' (#[_2]) a considéré comme fiable le commentateur \'[_3]\' (#[_4]).',
    'Tags \'[_1]\' (tags #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Tags \'[_1]\' (tags #[_2]) effacé par \'[_3]\' (utilisateur #[_4])',
    'URL:' => 'URL:', # Translate - Previous (1)
    'Template \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Template \'[_1]\' créé par \'[_2]\' (utilisateur #[_3])',
    'Weekly' => 'Hebdomadaire',
    'New TrackBack for category #[_1] \'[_2]\'.' => 'Nouveau TrackBack pour la catégorie #[_1] \'[_2]\'.',
    'No pages were found containing "[_1]".' => 'Aucune page trouvée contenant "[_1]".',
    '. Now you can comment.' => '. Maintenant vous pouvez commenter.',
    'Unpublish TrackBack(s)' => 'TrackBack(s) non publié(s)',
    'You need to provide a password if you are going to\ncreate new users for each user listed in your blog.\n' => 'Vous devez fournir un mot de passe si vous allez\ncréer de nouveaux utilisateurs pour chaque utilisateur listé dans votre blog.\n',
    'Weblog \'[_1]\' deleted by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' effacé par \'[_2]\' (utilisateur #[_3])',
    'The physical file path for your BerkeleyDB or SQLite database. ' => 'Le chemin d\'accès fichier pour votre base de données BerkeleyDB ou SQLite. ',
    'Many more can be found on the <a href="[_1]">main index page</a> or by looking through <a href="[_2]">the archives</a>.' => 'Beaucoup d\'autres notes peuvent être trouvés sur la page <a href="[_1]">d\'accueil principale</a> ou en cherchant dans <a href="[_2]">les archives</a>.',
    '_USAGE_PREFS' => 'Cet écran vous permet de définir un grand nombre des paramètres de votre weblog, de vos archives, des commentaires et de communication de notifications. Ces paramètres ont tous des valeurs par défaut raisonnables lors de la création d\'un nouveau weblog.',
    'This page contains an archive of all entries published to [_1] in the <strong>[_2]</strong> category.  They are listed from oldest to newest.' => 'Cette page contient une archive de toutes les notes publiées sur [_1] dans la catégorie <strong>[_2]</strong>. Elles sont listées de la plus ancienne à la plus récente.', # Translate - New (24)
    'WEEKLY_ADV' => 'hebdomadaire',
    'Other...' => 'Autre...',
    'If you have a TypeKey identity, you can ' => 'Si vous avez une identité TypeKey, vous pouvez ',
    'Can create entries, edit their own and upload files.' => 'Peuvent créer et éditer des notes et uploader des fichiers.',
    'Please enter the parameters necessary for connecting to your database.If your database type is not listed in the dropdown below, you may be missing the Perl module necessary to connect to your database.  If this is the case, please check your installation and click <a href="?__mode=configure">here</a> to re-test your installation.' => 'Merci de saisir les paramètres nécessaires pour se connecter à votre base de données. Si votre base de données n\'est pas listée dans le menu déroulant ci-dessous, il manque sûrement le module Perl nécéssaire à la connexion avec votre base de données. Si c\'est le cas, merci de vérifier votre configuration et cliquez ensuite <a href="?__mode=configure">ici</a> pour effectuer à nouveau un test de votre installation.',
    '_USAGE_ARCHIVING_2' => 'Lorsque vous associez plusieurs modèles à un type d\'archive particulier -- ou même lorsque vous n\'en associez qu\'un seul -- vous pouvez personnaliser le chemin des fichiers d\'archive à l\'aide des modèles correspondants.',
    'User \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Utilisateur \'[_1]\' créé par \'[_2]\' (utilisateur #[_3])',
    'Refresh Template(s)' => 'Actualiser le(s) Modèles(s)',
    'Password was reset for user \'[_1]\' (ID:[_2]) and sent to address: [_3]' => 'Le mot de passe a été réinitié pour l\'utilisateur \'[_1]\' (ID:[_2]) et envoyé à l\'adresse: [_3]',
    'Assigning basename for categories...' => 'Ajout de racines aux catégories...',
    '_USAGE_NOTIFICATIONS' => 'Les personnes suivantes souhaitent être averties de la publication d\'une nouvelle note sur votre site. Vous pouvez ajouter un utilisateur en indiquant son adresse e-mail dans le formulaire suivant. L\'adresse URL est facultative. Pour supprimer un utilisateur, cochez la case Supprimer dans le tableau ci-dessous, puis cliquez sur le bouton Supprimer.',
    'Future' => 'Futur',
    'Editor (can upload)' => 'Editeur (peut télécharger)',
    '_ERROR_DATABASE_CONNECTION' => 'Les paramètres de votre base de données sont soit invalides, absents ou ne peuvent pas être lus correctement. Consultez la base de connaissances pour plus d\'informations.',
    '_USAGE_BANLIST' => 'Cette liste est la liste des adresses IP qui ne sont pas autorisées à publier de commentaires ou envoyer des pings TrackBack à votre site. Vous pouvez ajouter une nouvelle adresse IP dans le formulaire suivant. Pour supprimer une adresse de la liste des adresses IP bannies, cochez la case Supprimer dans le tableau ci-dessous, puis cliquez sur le bouton Supprimer.',
    'RSS 2.0 Index' => 'Index RSS 2.0',
    'Select a Design using StyleCatcher' => 'Sélectionner un modèle via StyleCatcher',
    'New comment for entry #[_1] \'[_2]\'.' => 'Nouveau commentaire sur la note #[_1] \'[_2]\'.',
    '_USER_DISABLED' => 'Utilisateur désactivé',
    '<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> est l\'archive précédente.',
    '_USAGE_NEW_AUTHOR' => ' A partir de cette page vous pouvez créer de nouveaux utilisateurs dans le système et définir leurs accès dans un ou plusieurs weblogs.',
    'Manage my Widgets' => 'Gérer mes Widgets',
    'Weblog Associations' => 'Associations du weblog',
    'Updating blog comment email requirements...' => 'Mise à jour des prérequis des emails pour les commentaires du blog...',
    'Publish Entries' => 'Publier les notes',
    'The following groups were deleted' => 'Les groupes suivants ont été effacés',
    'Finished! You can <a href=\"javascript:void(0);\" onclick="closeDialog(\'[_1]\');\">return to the weblogs listing</a> or <a href=\"javascript:void(0);\" onclick="closeDialog(\'[_2]\');\">configure the Site root and URL of the new weblog</a>.' => 'Terminé! Vous pouvez <a href=\"javascript:void(0);\" en cliquant sur ="closeDialog(\'[_1]\');\">retourner à la liste de vos weblogs/a> ou <a href=\"javascript:void(0);\" onclick="closeDialog(\'[_2]\');\">configurer le site racine et l\'URL d\'un nouveau weblog</a>.',
    'You cannot disable yourself' => 'Vous ne pouvez vous désactiver vous même',
    '_USER_STATUS_CAPTION' => 'Statut',
    'You are not allowed to edit the permissions of this user.' => 'Vous n\'êtes pas autorisé à modifier les autorisations de cet utilisateur.',
    '<em><strong>Please Note:</strong> The Movable Type export format is not comprehensive and is not suitable for creating full-fidelity backups. Please see the Movable Type manual for full details.</em>' => '<em><strong>Note :</strong> Le format d\'export de Movable Type n\'est pas destiné à réaliser des sauvegardes intégrales. Merci de consulter la documentation de Movable Type pour plus d\'informations.</em>',
    '<$MTCategoryTrackbackLink$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<$MTCategoryTrackbackLink$> doit être utilisé dans le contexte d\'une catégorie ou avec l\'attribut  \'categorie\' au tag.',
    '_USAGE_PLUGINS' => 'Voici la liste de tous les plugins actuellement enregistrés avec Movable type.',
    'Tagger' => 'Tagueur',
    'Publisher' => 'Publié par',
    'Manager' => 'Manager', # Translate - Previous (1)
    '_GENL_USAGE_PROFILE' => 'Modifiez le profil utilisateur ici. Si vous modifier l\'identifiant ou le mot de passe utilisateur, la mise à jour sera effective immédiatement. En d\'autres termes, l\'utilisateur n\'aura pas besoin de se réidentifier.',
    '(None)' => '(Aucun)',
    'Frequency of synchronization in minutes. (Default is 60 minutes)' => 'Fréquence de synchronisation en minutes. (60 minutes par défaut)',
    '_USAGE_PERMISSIONS_2' => 'Vous pouvez modifier les permissions affectées à un utilisateur en sélectionnant ce dernier dans le menu déroulant, puis en cliquant sur Modifier.',
    'Insufficient permissions for modifying templates for this weblog.' => 'Permissions insuffisantes pour modifier les templates de ce weblog.',
    'Bad ObjectDriver config: [_1] ' => 'Mauvaise config ObjectDriver : [_1] ',
    'No email specified in user profile.  Please see your system administrator for password recovery.' => 'Le profil ne contient pas d\'adresse email. Merci de contacter votre administrateur système pour récupérer votre mot de passe.',
    'Untrust Commenter(s)' => 'Retirer le statut fiable à cet auteur de commentaires',
    'Hello, [_1]' => 'Bonjour, [_1]',
    'Can edit, manage and rebuild weblog templates.' => 'Peuvent éditer, gérer et republier les templates du weblog.',
    'To download more plugins, check out the <a href="http://www.sixapart.com/pronet/plugins/">Six Apart Plugin Directory</a>.' => 'Pour télécharger plus de plugins, visitez la page <a href="http://www.sixapart.com/pronet/plugins/">Six Apart Plugin Directory</a>.',
    'Assigning custom dynamic template settings...' => 'Ajout des réglages spécifiques de template dynamique...',
    'Updating comment status flags...' => 'Modification des statuts des commentaires...',
    'Updating user web services passwords...' => 'Mise à jour des mots de passe des services web de l\'utilisateur...',
    'Stylesheet' => 'Feuille de style',
    'You used an \'[_1]\' tag outside of the context of a ping; perhaps you mistakenly placed it outside of an \'MTPings\' container?' => 'Vous avez utilisé une balise \'[_1]\' en dehors d\'un contexte de ping; peut-être l\'avez-vous placé en dehors du conteneur \'MTPings\' ?',
    '_THROTTLED_COMMENT' => 'Dans le but de réduire les possibilités d\'abus, j\'ai activé une fonction obligeant les auteurs de commentaires à attendre quelques instants avant de publier un autre commentaire. Veuillez attendre quelques instants avant de publier un autre commentaire. Merci.',
    'Are you sure you want to delete the selected user(s)?' => 'Etes-vous sûr de vouloir effacer les utilisateurs sélectionnés?',
    '_USAGE_SEARCH' => 'Vous pouvez utiliser l\'outil de recherche et de remplacement pour effectuer des recherches dans vos notes ou pour remplacer chaque occurrence d\'un mot, d\'une phrase ou d\'un caractère par un autre. Important: faites preuve de prudence, car <b>il n\'existe pas de fonction d\'annulation</b>. Nous vous recommandons même d\'exporter vos notes Movable Type avant, par précaution.',
    'Your profile has been updated.' => 'Votre profil a été mis à jour.',
    'Refreshing (with <a href=\"?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]\">backup</a>) template \'[_3]\'.' => 'Rafraîchit (avec <a href=\"?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]\">backup</a>) template \'[_3]\'.',
    'Can\'t enable/disable that way' => 'Vous ne pouvez pas activer ou désactiver de cette manière',
    '_external_link_target' => '_haut',
    '_AUTO' => '1',
    'Password recovery for user \'[_1]\' failed due to lack of recovery phrase specified in profile.' => 'La récupération du mot de passe pour l\'utilisateur \'[_1]\' a échoué du fait de l\'absence de phrase test de récupération de mot de passe dans le profile.',
    'Setting new entry defaults for weblogs...' => 'Mise en place des nouvelles valeurs par défaut des notes des weblogs...',
    'Writer (can upload)' => 'Auteur (Peut télécharger)',
    'Updating entry week numbers...' => 'Mise à jour des numéros des semaines de la note...',
    'The previous entry in this blog was <a href="[_1]">[_2]</a>.' => 'La note précédente dans ce blog était <a href="[_1]">[_2]</a>.', # Translate - New (12)
    '_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.org/sitefr/"><$MTProductName$></a>',
    'Assigning comment/moderation settings...' => 'Mise en place des réglages commentaire/modération ...',
    'You can not add users to a disabled group.' => 'Vous ne pouvez ajouter des utilisateurs à des groupes désactivés.',
    'Communications Manager' => 'Gestionnaire des communications',
    'Clone Weblog' => 'Cloner le weblog',
    '_USAGE_ARCHIVING_1' => 'Sélectionnez les fréquences/types de mise en archives du contenu de votre site. Vous pouvez, pour chaque type de mise en archives que vous choisissez, affecter plusieurs modèles devant être appliqués. Par exemple, vous pouvez créer deux affichages différents de vos archives mensuelles: un contenant les notes d\'un mois particulier et l\'autre présentant les notes dans un calendrier.',
    'Application log for blog \'[_1]\' reset by \'[_2]\' (user #[_3])' => 'Log d\'application pour le blog \'[_1]\' réinitié par \'[_2]\' (utilisateur #[_3])',
    'Finished! You can <a href=\'[_1]\'>return to the weblogs listing</a> or <a href=\'[_2]\'>view the new weblog</a>.' => 'Terminé! Vous pouvez <a href=\'[_1]\'>retourner à la liste des weblogs </a> ou bien <a href=\'[_2]\'>voir le nouveau weblog</a>.',
    'Permission denied' => 'Autorisation refusée',
    '_USAGE_AUTHORS_1' => 'Ceci est la liste de tous utilisateurs dans cette installation Movable Type. Vous pouvez modifier les droits d\'un utilisateur en cliquant sur son nom. Vous pouvez effacer un utilisateur de façon permanente en cochant la case adéquate puis en sélectionnant Supprimer dans le menu déroulant. NOTE: si vous souhaitez simplement retirer un utilisateur sur un blog en particulier, modifiez les droits de l\'utilisateur, sachez qu\'en supprimant un utilisateur il disparaîtra de tout le système. Vous pouvez créer, éditer ou supprimer les informations d\'un utilisateur en utilisant un fichier de commande au format CSV.',
    'Error creating temporary file; please check your TempDir setting in mt.cfg (currently \'[_1]\') this location should be writable.' => 'Erreur lors de la création d\'un fichier temporaire; merci de vérifier le TempDir dans mt.cfg (actuellement \'[_1]\') ce répertoire doit avoir les droits en écriture.',
    'View This Weblog\'s Activity Log' => 'Voir le journal d\'activité pour ce weblog',
    '_USAGE_IMPORT' => 'Vous pouvez utiliser le mécanisme d\'importation de notes pour importer vos notes d\'un autre système de gestion de weblog (Blogger ou Greymatter, par exemple). Ce mode d\'emploi contient des instructions complètes pour l\'importation de vos notes; le formulaire suivant vous permet d\'importer tout un lot de notes déjC  exportées d\'un autre système, et d\'enregistrer les fichiers de façon à pouvoir les utiliser dans Movable Type. Consultez le mode d\'emploi avant d\'utiliser ce formulaire de façon à sélectionner les options adéquates.',
    'IP Address:' => 'Adresse IP :',
    'Main Index' => 'Index principal',
    'No new status given' => 'Aucun nouveau statut attribué',
    'Invalid login attempt from user \'[_1]\' (ID: [_2])' => 'Tentative d\'identification invalide par l\'utilisateur \'[_1]\' (ID: [_2])',
    '<p>You must define a global theme repository where themes can be stored locally.  If a particular blog has not been configured for it\'s own theme paths, it will use these settings directly. If a blog has it\'s own theme paths, then the theme will be copied to that location when applied to that weblog. The paths defined here must physically exist and be writable by the webserver.</p>' => '<p>Vous devez définir un répertoire global où les thèmes seront stockés localement. Si un blog particulier n\'a pas été configuré avec ces propres chemins d\'accès au thèmes, il utilisera ce répertoire global par défaut. Si par contre un blog a ses propres chemins d\'accès au thèmes, le thème appliqué sera alors copié dans ce répertoire. Les chemins définis doivent exister sur le serveur et doivent être modifiés par le serveur (droits en écriture).</p>',
    'You did not select any [_1] to delete.' => 'Vous n\'avez sélectionné aucun [_1] à effacer.',
    '_USAGE_EXPORT_3' => 'Le lien suivant entraîne l\'exportation de toutes les notes de votre weblog vers le serveur Tangent. Il s\'agit généralement d\'une opération ponctuelle, réalisée à la suite de l\'installation du module Tangent pour Movable Type.',
    'Application log reset by \'[_1]\' (user #[_2])' => 'Log d\'application réinitié par \'[_1]\' (utilisateur #[_2])',
    'Assigning spam status for TrackBacks...' => 'Ajout du statut de spam pour les TrackBacks...', # Translate - New (5)
    'A default location of \'./db\' will store the database file(s) underneath your Movable Type directory.' => 'La localisation par défaut \'./db\' stockera les fichiers de la base de données sous votre répertoire Movable Type.',
    'Delete selected users (x)' => 'Effacer les utilisateurs sélectionnés (x)',
    'User \'[_1]\' (user #[_2]) logged out' => 'Utilisateur \'[_1]\' (utilisateur #[_2]) s\'est déconnecté',
    'Edit Role' => 'Modifier Role',
    '_BLOG_CONFIG_MODE_DETAIL' => 'Mode détaillé',
    'Some ([_1]) of the selected user(s) could not be updated.' => 'Certain(e)s ([_1]) des utilisateurs sélectionnés n\'ont pu être mis à jour.',
    'Updating category placements...' => 'Modification des placements de catégories...',
    '_USAGE_BOOKMARKLET_4' => 'QuickPost vous permet de publier vos notes à partir de n\'importe quel point du web. Vous pouvez, en cours de consultation d\'une page que vous souhaitez mentionner, cliquez sur QuickPost pour ouvrir une fenêtre popup contenant des options Movable Type spéciales. Cette fenêtre vous permet de sélectionner le weblog dans lequel vous souhaitez publier la note, puis de la créer et de la publier.',
    'Notification \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => 'Notification \'[_1]\' (#[_2]) effacé par \'[_3]\' (utilisateur #[_4])',
    'DAILY_ADV' => 'de façon quotidienne',
    'Communicator' => 'Communicateur',
    '_USAGE_PERMISSIONS_3' => 'Il existe deux façons d\'accorder ou de révoquer les privilèges d\'accès affectés aux utilisateurs. La première est de sélectionner un utilisateur parmi ceux du menu ci-dessous et de cliquer sur Modifier. La seconde est de consulter la liste de tous les utilisateurs, puis de sélectionner l\'utilisateur que vous souhaitez modifier ou supprimer.',
    'Found' => 'Trouvé',
    '_NOTIFY_REQUIRE_CONFIRMATION' => 'Un email a été envoyé à [_1]. Pour valider votre inscription, merci de cliquer sur le lien qui figure dans cet email. Il permettra de vérifier que votre adresse email est valable.',
    'Tags to remove from selected entries' => 'Tags à enlever des notes sélectionnées',
    'Manage Notification List' => 'Gérer la liste de notification',
    'Individual' => 'Individuelles',
    'Last Entry' => 'Dernière Note',
    'An error occurred while testing for the new tag name.' => 'Une erreur est survenue en testant la nouvelle balise.',
    'Before you can do this, you need to create some groups. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a group.' => 'Avant de faire ceci, vous devez créer des groupes.. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Cliquez ici</a> pour créer un groupe.',
    'Your changes to [_1]\'s profile has been updated.' => 'Les changements que vous avez apportés au profil de [_1] ont été mis à jour.',
    '_USAGE_FORGOT_PASSWORD_2' => 'Ce nouveau mot de passe devrait vous permettre d\'ouvrir une session Movable Type. Vous pourrez changer ce mot de passe une fois la session ouverte.',
    'Authored On' => 'Publication initiale le',
    '_SEARCH_SIDEBAR' => 'Rechercher',
    'Unban Commenter(s)' => 'Réautoriser cet auteur de commentaires',
    'Individual Entry Archive' => 'Archivage par note',
    'Daily' => 'Quotidien',
    'This page contains all entries published to [_1] in <strong>[_2]</strong>. They are listed from oldest to newest.' => 'Cette page contient toutes les notes publiées sur [_1] dans <strong>[_2]</strong>. Elles sont listées de la plus ancienne à la plus récente.', # Translate - New (19)
    'Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or \'all\' (include_blogs only) are acceptable values.' => 'Active l\'utilisation du  tag MTMultiBlog tag sans les attributs inclure_blogs/exclure_blogs. Les BlogIDs séparés par une virgule ou  \'all\' (inclure_blogs seulement) sont des valeurs acceptées.',
    'Unpublish Entries' => 'Annuler publication',
    'Setting blog basename limits...' => 'Setting blog basename limits...', # Translate - Previous (4)
    'Powered by [_1]' => 'Powered by [_1]', # Translate - Previous (3)
    'Commenter Feed (Disabled)' => 'Flux Commentateur (Désactivé)',
    'Personal weblog clone source ID' => 'ID du weblog source pour la duplication',
    '_USAGE_UPLOAD' => 'Vous pouvez télécharger le fichier ci-dessus dans le chemin local de votre site <a href="javascript:alert(\'[_1]\')">(?)</a> ou dans le chemin des archives de votre site <a href="javascript:alert(\'[_2]\')">(?)</a>. Vous pouvez également télécharger le fichier dans un répertoire compris dans les répertoires mentionnés ci-dessus, en spécifiant le chemin dans les champs de droite (<i>images</i>, par exemple). Les répertoires qui n\'existent pas encore seront créés.',
    '<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> est l\'archive suivante.',
    'Updating commenter records...' => 'Modification des données du commentateur...',
    'Now you can comment.' => 'Maintenant vous pouvez commenter.',
    'Deleting a user is an irrevocable action which creates orphans of the author\'s entries.  If you wish to retire a user or remove their access to the system, removing all of their permissions is th e recommended course of action.  Are you sure you want to delete the [_1] selected users?' => 'Effacer un auteur est une action définitive et génère des notes orphelines dans le système. Si vous voulez supprimer un utilisateur, nous vous recommandons de procéder en lui enlevant tous ses accès au système. Etes-vous certain de vouloir supprimer définitivement les utilisateurs sélectionnés[_1]?',
    '_USAGE_REBUILD' => 'Vous devrez cliquer sur <a href="#" onclick="doRebuild()">Actualiser</a> pour voir les modifications reflétées sur votre site publiî',
    'Refreshing (with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>) template \'[_3]\'.' => 'Actualisation (depuis une <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">sauvegarde</a>) du modèle \'[_3]\'.',
    'Invalid blog_id' => 'Identifiant du blog non valide',
    'CATEGORY_ADV' => 'par catégorie',
    'Blog Administrator' => 'Administrateur Blog',
    'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Fichier de configuration manquant. Avez-vous oublié de déplacer mt-config.cgi-original vers mt-config.cgi?',
    'Dynamic Site Bootstrapper' => 'Initialisateur de site dynamique',
    'You need to create some roles.' => 'Vous devez créer des rôles.',
    'Assigning entry basenames for old entries...' => 'Ajout des racines des notes pour les anciennes notes...',
    'Invalid author' => 'Auteur non valide',
    'Error sending mail ([_1]); please fix the problem, then try again to recover your password.' => 'Erreur d\'envoi du mail ([_1]); merci de corriger le problème, puis essayez à nouveau de récupérer votre mot de passe.',
    'Error saving entry: [_1]' => 'Erreur d\'enregistrement de la note: [_1]',
    'index' => 'index', # Translate - Previous (1)
    'Invalid login attempt from user [_1]: [_2]' => 'Tentative d\'identification non valide de l\'utilisateur [_1]: [_2]',
    'User \'[_1]\' (#[_2]) unbanned commenter \'[_3]\' (#[_4]).' => 'Utilisateur \'[_1]\' (#[_2]) a retirer le statut non fiable au commentateur \'[_3]\' (#[_4]).',
    'Assigning visible status for TrackBacks...' => 'Ajout du statut visible des TrackBacks...',
    '_USAGE_PLACEMENTS' => 'Les outils d\'édition permettent de gérer les catégories secondaires auxquelles cette note est associée. La liste de gauche contient les catégories auxquelles cette note n\'est pas encore associée en tant que catégorie principale ou catégorie secondaire ; la liste de droite contient les catégories secondaires auxquelles cette note est associée.',
    '_USAGE_ASSOCIATIONS' => 'Cette page affiche les associations existantes et vous pouvez en créer de nouvelles.',
    'Adds template tags to allow you to search for content from Google. You will need to configure this plugin using a <a href=\'http://www.google.com/apis/\'>license key.</a>' => 'Ajoute des tags aux modèles qui vous permettrons de rechercher du contenu sur Google. Vous aurez besoin de configurer ce plugin avec une <a href=\'http://www.google.com/apis/\'>clé de licence</a>.',
    'Wrong object type' => 'Erreur dans le type d\'objet',
    'Search Template' => 'Template de Recherche',
    'It can be included onto your published blog using <a href="[_1]">WidgetManager</a> or this MTInclude tag' => 'Cela peut être intégré dans votre blog en utilisant le <a href="[_1]">Gestionnaire de Widgets</a> ou grâce au tag MTInclude',
    '_USAGE_PASSWORD_RESET' => 'Ci-dessous, vous pouvez réinitialiser le mot de passe pour cet utilisateur. Si vous faites cela un mot de passe généré aléatoirement sera créé et envoyé par e-mail à : [_1].',
    'Download file' => 'Télécharger le fichier',
    'Error connecting to LDAP server [_1]: [_2]' => 'Erreur de connection au serveur LDAP [_1]: [_2]',
    'Edit Profile' => 'Editer le profil',
    'Error loading default templates.' => 'Erreur pendant le chargement des templates par défaut.',
    'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'Vous n\'avez pas un chemin valide vers sendmail sur votre machine. Vous devriez essayer SMTP?',
    'You are currently performing a search. Please wait until your search is completed.' => 'Vous êtes en train d\'effectuer une recherche. Merci d\'attendre que la recherche soit finie.',
    'An errror occurred when enabling this user.' => 'Une erreur s\'est produite pendant l\'activation de cet utilisateur.',
    '_USAGE_LIST_POWER' => 'Cette liste est la liste des notes de [_1] en mode d\'édition par lots. Le formulaire ci-dessous vous permet de changer les valeurs des notes affichées ; cliquez sur le bouton Enregistrer une fois les modifications souhaitées effectuées. Les fonctions de la liste possibles avec les Notes existantes fonctionnent en mode de traitement par lots comme en mode standard.',
    'Below is a list of the members in the <b>[_1]</b> group. Click on a user\'s username to see the details for that user.' => 'Ci-dessous une liste des membres du groupe <b>[_1]</b>. Cliquez sur le nom d\'utilisateur pour consulter les détails d\'un utilisateur donné.',
    '_ERROR_CONFIG_FILE' => 'Votre fichier configuration Movable type est absent ou ne peut pas être lu correctement. Merci de consulter la base de connaissances',
    'This action can only be run for a single weblog at a time.' => 'Cette action peut être effectuée uniquement blog par blog.',
    '_WARNING_PASSWORD_RESET_SINGLE' => '_WARNING_PASSWORD_RESET_SINGLE', # Translate - Previous (5)
    '_USAGE_PING_LIST_BLOG' => 'Voici la liste des Trackbacks pour [_1]  que vous pouvez filtrer, gérer et éditer.',
    'You must set your Database Path.' => 'Vous devez définir le Chemin de Base de Données.',
    'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.' => 'StyleCatcher vous permet de naviguer facilement à travers des styles et de les appliquer à votre blog en quelques clics seulement. Pour en savoir plus à propos des styles Movable Type, ou pour avoir de nouvelles sources de styles, visitez la page <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a>.',
    'The LDAP directory ID for this group.' => 'L\'ID de ce groupe dans l\'annuaire LDAP.',
    '_USAGE_GROUPS' => 'Ceci est le message pour les groupes.',
    '_LOG_TABLE_BY' => '_LOG_TABLE_BY', # Translate - New (4)
    'If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the <code>import</code> folder of your Movable Type directory.' => 'Si le fichier à importer est sur votre ordinateur, vous pouvez le télécharger ici. Sinon, Movable Type va automatiquement rechercher ce fichier dans le dossier <code>import</code> du dossier principal de Movable Type.',
    'If you want to change the SitePath and SiteURL, <a href=\'[_1]\'>click here</a>.' => 'Si vous voulez changer le Chemin du site et l\'URL du site, <a href=\'[_1]\'>cliquez ici</a>.',
    'Password recovery for user \'[_1]\' failed due to lack of email specified in profile.' => 'La récupération du mot de passe de l\'utilisateur\'[_1]\' a échoué à cause de l\'absence d\'adresse email dans le profil.',
    'Tags to add to selected entries' => 'Tags à ajouter aux notes séléctionnées',
    'Entry "[_1]" added by user "[_2]"' => 'Note "[_1]" ajoutée par l\'utilisateur "[_2]"',
    '_USAGE_VIEW_LOG' => 'L\'erreur est enregistrée dans le <a href="[_1]">journal des activité</a>.',
    'You are not allowed to edit the profile of this user.' => 'Vous n\'êtes pas autorisé à éditer le profil de cet utilisateur.',
    '_BACKUP_DOWNLOAD_MESSAGE' => '_BACKUP_DOWNLOAD_MESSAGE', # Translate - New (4)
    '_USAGE_BOOKMARKLET_1' => 'La configuration de la fonction QuickPost vous permet de publier vos notes en un seul clic sans même utiliser l\'interface principale de Movable Type.',
    'You must define an Individual template in order to display dynamic comments.' => 'Vous devez définir un template Individual pour pouvoir afficher du contenu dynamique.',
    'UTC+10' => 'UTC+10', # Translate - Previous (2)
    'INDIVIDUAL_ADV' => 'par note',
    'Can upload files, edit all entries/categories/tags on a weblog, rebuild and send notifications.' => 'Peuvent uploader des fichiers, éditer toutes les notes/catégories/tags d\'un weblog, republier le weblog et envoyer des notifications.',
    'Entry \'[_1]\' (entry #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Note \'[_1]\' (note #[_2]) effacée par \'[_3]\' (utilisateur #[_4])',
    'all rows' => 'toutes les lignes',
    '_USAGE_GROUP_PROFILE' => 'Cet écran vous permet de modifier le profil du groupe.',
    'User \'[_1]\' (user #[_2]) logged in successfully' => 'Utilisateur \'[_1]\' (utilisateur #[_2]) s\'est identifié avec succès',
    'Error during upgrade: [_1]' => 'Erreur pendant l\'upgrade: [_1]',
    'Master Archive Index' => 'Index principal des archives',
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly context.' => 'Vous avez utilisé une balise [_1] en dehors d\'un contexte Daily, Weekly, ou Monthly.',
    'Step 2 of 4' => 'Etape 2 sur 4',
    'Deleting a user is an irrevocable action which creates orphans of the user\'s entries.  If you wish to retire a user or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete this user?' => 'Effacer un utilisateur est une action définitive qui crée des liens orphelins sur les notes du dit utilisateur.  Si vous voulez empêcher un utilisateur d\'accéder au système, il est préférable de lui retirer toutes ses autorisations. Etes-vous sûr de vouloir effacer cet utilisateur?',
    'Another amount...' => 'Un autre montant...',
    'Movable type' => 'Movable Type',
    'You can not create associations for disabled groups.' => 'Vous ne pouvez pas créer d\'association pour des groupes désactivés.',
    'Grant a new role to [_1]' => 'Attribuer un nouveau rôle à [_1]',
    '_WARNING_DELETE_USER' => 'Supprimer un utilisateur est une action définitive qui va créer des notes orphelines. Si vous souhaitez retirer un utilisateur ou supprimer un accès utilisateur désactiver son compte est recommandé. Etes-vous sur de vouloir supprimer cet utilisateur?',
    'You used an \'[_1]\' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an \'MTEntries\' container?' => 'Vous avez utilisé une balise \'[_1]\' en dehors du contexte d\'une note; peut-être l\'avez vous mise en dehors du conteneur \'MTEntries\' ?',
    'We were unable to create your configuration file. If you would like to check the directory permissions and retry, click the \'Retry\' button.' => 'Nou n\'avons pas réussi à créer votre fichier de configuration. Merci de vérifier le répertoire des autorisations puis de faire une nouvelle tentative en cliquant sur le bouton \'Réessayer\'.',
    'Create New Group Association' => 'Créer une Association Nouveau Groupe',
    'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Même si Movable Type semble fonctionner normalement, cela se déroule <strong>dans uns environnement non testé et non supporté</strong>.  Nous recommandons fortement que vous installiez un version de Perl supérieure ou égale à [_1].',
    'Unpublish Comment(s)' => 'Annuler publication commentaire(s)',
    'Processing templates for weblog \'[_1]\'' => 'Traitement des templates pour le weblog \'[_1]\'',
    '_USAGE_ENTRY_LIST_OVERVIEW' => 'Voici la liste des notes de tous les weblogs que vous pouvez filtrer, gérer et éditer.',
    'Synchronization Frequency' => 'Fréquence de Synchronisation',
    'Can upload files, edit all entries/categories/tags on a weblog and rebuild.' => 'Peuvent uploader des fichiers, éditer toutes les notes/catégories/tags d\'un weblog et le republier.',
    'No new user status given' => 'Aucun statut Nouvel Utilisateur attribué',
    'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Format de date invalide \'[_1]\'; doit être \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM est optionnel)',
    'Drag and drop the widgets you want into the <strong>Installed</strong> column.' => 'Glissez-déposez les widgets de votre choix dans la colonne <strong>Widgets installés</strong>.',
    'Manage Categories' => 'Gérer les Catégories',
    'Assigning user types...' => 'Ajout des types d\'utilisateurs...',
    'Writer' => 'Auteur',
    'Before you can do this, you need to create some roles. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a role.' => 'Avant de faire ceci, vous devez créer des rôles. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Cliquez ici</a> pour créer un rôle.',
    'UTC+11' => 'UTC+11', # Translate - Previous (2)
    'Migrating any "tag" categories to new tags...' => 'Migration des catégories de "tag" vers de nouveaux tags...',
    'Before you can do this, you need to create some users. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a user.' => 'Avant de faire ceci, vous devez créer des utilisateurs. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Cliquez ici</a> pour créer un utilisateur.',
    'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Le module Perl Image::Size est requis pour déterminer la largeur et la hauteur des images uploadées.',
    '_BACKUP_TEMPDIR_WARNING' => '_BACKUP_TEMPDIR_WARNING', # Translate - New (4)
    'Edit Permissions' => 'Editer les Autorisations',
    '_USAGE_COMMENTERS_LIST' => 'Cette liste est la liste des auteurs de commentaires pour [_1].',
    'File with name \'[_1]\' already exists; Tried to write to tempfile, but open failed: [_2]' => 'Le fichier avec le nom \'[_1]\' existe déjà; Tentative d\'écriture dans un fichier temporaire, mais l\'ouverture a échoué : [_2]',
    'Updating [_1] records...' => 'Mise à jour des données [_1] ...',
    'Configure Weblog' => 'Configurer le Weblog',
    '_INDEX_INTRO' => '<p>Si vous ninstallez Movable Type, il vous sera certainement utile de consulter <a href="http://www.sixapart.com/movabletype/docs/mtinstall.html">la documentation d\'installation</a> et <a rel="nofollow" href="mt-check.cgi">le système de vérification de Movable Type</a> pour vérifier que votre système est conforme.</p>',
    '_USAGE_AUTHORS' => 'Cette liste est la liste de tous les utilisateurs du système Movable Type. Vous pouvez changer les droits accordés à un utilisateur en cliquant sur son nom et supprimer un utilisateur en cochant la case adéquate, puis en cliquant sur <b>Supprimer</b>. Remarque : si vous ne souhaitez supprimer un utilisateur que d\'un weblog spécifique, il vous suffit de changer les droits qui lui sont accordés ; la suppression d\'un utilisateur affecte tout le système.',
    '_USAGE_FEEDBACK_PREFS' => 'Cette page vous permet de configurer les manières dont un lecteur peut contribuer sur votre weblog',
    '_USAGE_FORGOT_PASSWORD_1' => 'Vous avez demandé à récupérer votre mot de passe Movable Type. Votre mot de passe a été changé au niveau du système ; le nouveau mot de passe est le suivant:',
    'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides.' => 'Les modules suivants sont <strong>optionnels</strong>. Si votre serveur ne possède pas ces modules, vous devez le(s) installer uniquement si vous souhaitez bénéficier des fonctionnalités offertes par le module.',
    'No groups were found with these settings.' => 'Aucun groupe correspondant à ces paramètres n\'a été trouvé.',
    '_USAGE_EXPORT_2' => 'Pour exporter vos notes: cliquez sur le lien ci-dessous (Exporter les notes de [_1]). Pour enregistrer les données exportées dans un fichier, vous pouvez enfoncer la touche <code>option</code> (Macintosh) ou <code>Maj</code> (Windows) et la maintenir enfoncée tout en cliquant sur le lien. Vous pouvez également sélectionner toutes les données et les copier dans un autre document. <a href="#" onclick="openManual(\'importing\', \'export_ie\');return false;">Vous exportez des données depuis Internet Explorer ?</a>',
    '_USAGE_PING_LIST_ALL_WEBLOGS' => 'Voici une liste de Ping de Trackback de tous les weblogs que vous pouvez filtrer, gérer et éditer.',
    'Cloning categories for weblog.' => 'Duplication des catégories pour le weblog.',
    'Yearly' => 'Annuel', # Translate - New (1)
    'Failed login attempt with incorrect password by user \'[_1]\' (ID: [_2])' => 'La tentative d\'identification par l\'utilisateur\'[_1]\' (ID: [_2]) a échoué à cause d\'un mot de passe invalide',
    'No executable code' => 'Pas de code exécutable',
    '_USAGE_PING_LIST_OVERVIEW' => 'Voici la liste des Trackbacks de tous vos weblogs que vous pouvez filtrer, gérer et éditer',
    'AUTO DETECT' => 'DETECTION AUTOMATIQUE',
    'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Par défaut, ce moteur va rechercher tous les mots, quelque soit leur ordre. Pour lancer une recherch sur une phrase exacte, insérer la phrase entre des apostrophes : ',
    '_USAGE_GROUPS_USER_LDAP' => 'Ci-dessous la liste des groupe dont l utilisateur est membre',
    'You need to create some groups.' => 'Vous devez créer des groupes.',
    'You need to create some weblogs.' => 'Vous devez créer des weblogs.',
    'No birthplace, cannot recover password' => 'Pas de lieu de naissance. Ne peut retrouver le mot de passe',
    'Install <a href=\'http://greasemonkey.mozdev.org/\'>GreaseMonkey</a>' => 'Installer <a href=\'http://greasemonkey.mozdev.org/\'>GreaseMonkey</a>',
    'The next entry in this blog is <a href="[_1]">[_2]</a>.' => 'L\'entrée suivante dans ce blog est <a href="[_1]">[_2]</a>.', # Translate - New (12)
    '_WARNING_DELETE_USER_EUM' => 'Supprimer une utilisateur est une action définitive qui va créer des notes oprhelines. Si vous voulez retirer un utilisateur ou lui supprimer ses accès nous vous recommandons de désactiver son compte. Etes-vous sur de vouloir supprimer cet utilisateur? Attention il pourra se re-créer un accès s\'il existe encore dans le répertoire externe',
    '_USER_ENABLE' => 'Activer',
    'Can administer the weblog.' => 'Peut administrer le weblog.',
    '_USAGE_PROFILE' => 'Cet espace permet de changer votre profil d\'utilisateur. Les modifications apportées à votre nom d\'utilisateur et à votre mot de passe sont automatiquement mises à jour. En d\'autres termes, vous devrez ouvrir une nouvelle session.',
    'Category' => 'Catégorie',
    'Congratulations! A template module Widget named <strong>[_1]</strong> has been created which you can further <a href="[_2]">edit</a> to customize its display.' => 'Félicitations ! Un modèle de Widget nommé <strong>[_1]</strong> a bien été créé, vous pouvez le <a href="[_2]">modifier</a> ultérieurement pour personnaliser son affichage.',
    '_USAGE_AUTHORS_LDAP' => 'Voici la liste de tous les utilisateurs de Movable Type dans le système. Vous pouvez modifier les autorisations accordées à un utilisateur en cliquant sur son nom. Vous pouvez désactiver un utilisateur en cochant la case à coté de son nom, puis en cliquant sur DESACTIVER. Ceci fait, l\'utilisateur ne pourra plus s\'identifier sur Movable Type.',
    'An error occured during synchronization.  See the <a href=\'[_1]\'>activity log</a> for detailed information.' => 'Une erreur s\'est produite durant la synchronisation.  Consultez les <a href=\'[_1]\'>logs d\'activité</a> pour plus d\'information.',
    '_USAGE_ENTRYPREFS' => 'La configuration des champs détermine les champs de saisie qui apparaîtront dans les écrans de création et de modification des notes. Vous pouvez sélectionner une configuration existante (basique ou avancée), ou personnaliser vos écrans en activant le bouton Personnalisée, puis en sélectionnant les champs que vous souhaitez voir apparaître.',
    '_USAGE_NEW_GROUP' => 'Depuis cet écran vous pouvez créer un nouveau groupe dans le système.',
    'You can not add disabled users to groups.' => 'Vous ne pouvez ajouter des utilisateurs désactivés dans des groupes.',
    'Are you sure you want to delete the selected user(s)?\nThey will be able to re-create themselves if selected user(s) still exist in LDAP.' => 'Etes-vous sûr de vouloir effacer le(s) utilisateur(s) sélectionné(s)? Ils seront capables de se créer de nouveau un compte s\'ils existent toujours dans le LDAP.',
    'RSD' => 'RSD', # Translate - Previous (1)
    'Template \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => 'Template \'[_1]\' (#[_2]) effacé par \'[_3]\' (utilisateur #[_4])',
    'User \'[_1]\' (#[_2]) banned commenter \'[_3]\' (#[_4]).' => 'Utilisateur \'[_1]\' (#[_2]) a classé non fiable le commentateur \'[_3]\' (#[_4]).',
    '_USAGE_ROLES' => 'Ci-dessous la liste de tous les rôles dont vous bénéficiez pour vos weblogs.',
    'Invalid username \'[_1]\' in password recovery attempt' => 'Nom d\'utilisateur non valide \'[_1]\' lors de la tentative de récupération du mot de passe',
    'Not Found' => 'Pas trouvé',
    'Error creating new template: ' => 'Erreur pendant la création du nouveau template: ',
    'You cannot modify your own permissions.' => 'Vous ne pouvez modifier vos propres autorisations.',
    '_USAGE_ARCHIVE_MAPS' => 'Cette fonctionnalité avancée vous permet de faire correspondre un modèle d\'archives à plusieurs types d\'archives. Par exemple, vous pouvez decider de créer deux vues différentes pour vos archives mensuelles : une pour les notes d\'un mois donné, présentées en liste, une autre affichant les notes sur un calendrier mensuel.',
    'Trust Commenter(s)' => 'Donner statut fiable à cet auteur de commentaires',
    'Manage Templates' => 'Gérer les Modèles',
    '_USAGE_BOOKMARKLET_2' => 'La structure de la fonction QuickPost de Movable Type vous permet de personnaliser la mise en page et les champs de votre page QuickPost. Par exemple, vous pouvez ajouter une option d\'ajout d\'extraits par l\'intermédiaire de la fenêtre QuickPost. Une fenêtre QuickPost comprend, par défaut, les éléments suivants: un menu déroulant permettant de sélectionner le weblog dans lequel publier la note ; un menu déroulant permettant de sélectionner l\'état de publication (brouillon ou publié) de la nouvelle note ; un champ de saisie du titre de la note ; et un champ de saisie du corps de la note.',
    '_USAGE_CATEGORY_PING_URL' => 'C est l URL utilisée par les autres pour envoyer des Trackbacks à votre weblog. Si vous voulez que n importe qui puisse envoyer un Trackback à votre site spécifique à cette catégorie, publiez cette URL. Si vous préférez que cela soit réservé à certaines personnes, il faut leur envoyer cette URL de manière privée. Pour inclure la liste des Trackbacks entrant dans l index principal de votre design merci de consulter la documentation.',
    '_USAGE_PERMISSIONS_1' => 'Vous à êtes en train de modifier les droits de <b>[_1]</b>. Vous trouverez ci-dessous la liste des weblogs pour lesquels vous pouvez contrôler les utilisateurs ; pour chaque weblog de la liste, vous pouvez affecter des droits à <b>[_1]</b> en cochant les cases correspondant aux options souhaitées.',
    'List Users' => 'Lister les  Utilisateurs',
    'Add/Manage Categories' => 'Ajouter/Gérer des Categories',
    'Creating entry category placements...' => 'Création des placements des catégories des notes...',
    'To enable comment registration, you need to add a TypeKey token in your weblog config or user profile.' => 'Pour activer l\'authentification des commentaires, vous devez ajouter une clé TypeKey dans la config de votre weblog ou dans le profil de l\'utilisateur.',
    'Advanced' => 'Avancé',
    'Are you sure you want to delete this [_1]?' => 'Etes-vous sûr de vouloir effacer cet(te) [_1]?',
    'Third-Party Services' => 'Services Tiers',
    'PAGE_ADV' => 'PAGE_ADV', # Translate - New (2)
    'Recover Password(s)' => 'Récupérer le(s) mot(s) de passe',
    'You can not create associations for disabled users.' => 'Vous ne pouvez créer des associations pour des utilisateurs désactivés.',
    '<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> est la prochaine catégorie.',
    'User \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => 'Utilisateur \'[_1]\' (#[_2]) effacé par \'[_3]\' (utilisateur #[_4])',
    '_USAGE_PERMISSIONS_4' => 'Chaque weblog peut être utilisé par plusieurs utilisateurs. Pour ajouter un utilisateur, vous entrerez les informations correspondantes dans les formulaires ci-dessous. Sélectionnez ensuite les weblogs dans lesquels l\'utilisateur pourra travailler. Vous pourrez modifier les droits accordés à l\'utilisateur une fois ce dernier enregistré dans le système.',
    'Assigning spam status for comments...' => 'Ajout du statut de spam pour les commentaires...', # Translate - New (5)
    '_USAGE_TAGS' => 'Utilisez les tags pour grouper vos notes sous un même mot clef ce qui vous permettra de les retrouver plus facilement.',
    'TrackBack for category #[_1] \'[_2]\'.' => 'TrackBack pour la catégorie #[_1] \'[_2]\'.',
    'Before you can do this, you need to create some weblogs. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a weblog.' => 'Avant de faire ceci, vous devez créer des weblogs. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Cliquez ici</a> pour créer un weblog.',
    '_USAGE_BOOKMARKLET_5' => 'Vous pouvez également, si vous utilisez Internet Explorer sous Windows, installer une option QuickPost dans le menu contextuel (clic droit) de Windows. Cliquez sur le lien ci-dessous et acceptez le message affiché pour ouvrir le fichier. Fermez et redémarrez votre navigateur pour ajouter le menu au système.',
    'The last system administrator cannot be deleted under ExternalUserManagement.' => 'Le dernier administrateur système ne peut être effacer via le système de gestion externe des Utilisateurs.',
    '_USER_PENDING' => '_USER_PENDING', # Translate - New (3)
    'Assigning category parent fields...' => 'Ajout des champs parents de la catégorie...',
    'A user by that name already exists.' => 'Un utilisateur ayant ce nom existe déjà.',
    '_USAGE_ENTRY_LIST_BLOG' => 'Voici la liste des notes pour [_1] que vous pouver filtrer, gérer et éditer.',
    'Movable Type ships with directory named <strong>mt-static</strong> which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type est livré avec un répertoire appelé <strong>mt-static</strong> qui contient un certain nombre de fichiers importants comme les images, fichiers javascript et feuilles de style.',
    'Search Results (max 10 entries)' => 'Résultats de recherche (10 notes max.)',
    'Send Notifications' => 'Envoyer des notifications',
    'This page contains a single entry from the blog created on <strong>[_1]</strong>.' => 'Cette page contient une seule note du blog créée le <strong>[_1]</strong>.', # Translate - New (14)
    'Setting blog allow pings status...' => 'Mise en place du statut d\'autorisation des pings...',
    'Step 1 of 4' => 'Etape 1 sur 4',
    'Edit All Entries' => 'Modifier toutes les notes',
    'The settings below have been written to the file <tt>[_1]</tt>. If any of these settings are incorrect, you may click the \'Back\' button below to reconfigure them.' => 'Les paramètres ci-dessous ont été écrits dans le fichier <tt>[_1]</tt>. Si certains de ces paramètres sont incorrects, vous pouvez cliquer sur le bouton \'Retour\' ci-dessous pour les reconfigurer.',
    'Error assigning weblog administration rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable weblog administrator role was found.' => 'Erreur dans l\'attribution des droits d\'administration à l\'utilisateur \'[_1] (ID: [_2])\' pour le weblog \'[_3] (ID: [_4])\'. Aucun rôle d\'administrateur de weblog approprié n\'a été trouvé.',
    'Rebuild Files' => 'Reconstruire les fichiers',
    '_USAGE_ROLE_PROFILE' => 'Sur cet écran vous pouvez créer un rôle et les permissions associées.',

    ## Error messages, strings in the app code.

    ## ./mt-check.cgi.pre
    'CGI is required for all Movable Type application functionality.' => 'CGI est requis pour toutes les fonctionnalités de l\'application Movable Type.',
    'HTML::Template is required for all Movable Type application functionality.' => 'HTML::Template est requis pour toutes les fonctionnalités de l\'application Movable Type.',
    'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size est requis pour les uploads de fichiers (pour déterminer la taille des images uploadées dans plusieurs formats différents).',
    'File::Spec is required for path manipulation across operating systems.' => 'File::Spec est requis pour la manipulation du chemin (path) à travers les systèmes d\'exploitation.',
    'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie est requis pour l\'authentication du cookie.',
    'DBI is required if you want to use any of the SQL database drivers.' => 'DBI est nécessaire pour utiliser les drivers SQL de la base de données.',
    'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI et DBD::mysql sont requis si vous souhaitez utiliser la base de données MySQL.',
    'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI et DBD::Pg sont requis si vous souhaitez utiliser la base de données PostgreSQL.',
    'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI et DBD::SQLite sont requis si vous souhaitez utiliser la base de données SQLite.', # Translate - New (15)
    'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI et DBD::SQLite2 sont requis si vous souhaitez utiliser la base de données SQLite 2.x.', # Translate - New (17)
    'DBI and DBD::Oracle are required if you want to use the Oracle database backend.' => 'DBI et DBD::Oracle sont requis si vous souhaitez utiliser de la base de données Oracle.',
    'DBI and DBD::ODBC are required if you want to use the Microsoft SQL Server database backend.' => 'DBI et DBD::ODBC sont nécessaires si vous voulez utilise la base de données Microsoft SQL Server.',
    'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in mt.cfg.' => 'HTML::Entities est requis pour encoder certains caractères, mais cette fonction peut être coupée si vous utilisez l\'option NoHTMLEntities dans mt.cfg.',
    'LWP::UserAgent is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'LWP::UserAgent est optionel; Cette fonction est nécessaire si vous souhaitez utiliser le système de TrackBack, le ping sur weblogs.com, ou le ping des derniers sites MT mis à jour.',
    'SOAP::Lite is optional; It is needed if you wish to use the MT XML-RPC server implementation.' => 'SOAP::Lite n\'est pas obligatoire; il est requis si vous souhaitez utiliser l\'implémentation du serveur MT XML-RPC.',
    'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Temp n\'est pas obligatoire; il est requis si vous souhaitez pouvoir écraser des fichiers déjà existants quand vous uploadez.',
    'Image::Magick is optional; It is needed if you would like to be able to create thumbnails of uploaded images.' => 'Image::Magick n\'est pas obligatoire; il est requis si vous souhaitez pouvoir créer des thumbnails des images uploadées.',
    'Storable is optional; it is required by certain MT plugins available from third parties.' => 'Storable n\'est pas obligatoire; il est requis par certains plugins de MT disponibles à partir de la troisième partie.',
    'Crypt::DSA is optional; if it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSA n\'est pas obligatoire; s\'il est installé, l\'autentification lors des commentaires sera plus rapide.',
    'MIME::Base64 is required in order to enable comment registration.' => 'MIME::Base64 est nécessaire afin de permettre l\'enregistrement des commentaires.',
    'XML::Atom is required in order to use the Atom API.' => 'XML::Atom est nécessaire pour utiliser l\'API Atom.',
    'Net::LDAP is required in order to use the LDAP Authentication.' => 'Net::LDAP est requis pour utiliser l\'Authentication LDAP.',
    'IO::Socket::SSL is required in order to use SSL/TLS connection with the LDAP Authentication.' => 'IO::Socket::SSL est nécessaire pour utiliser les connections SSL/TLS avec l\'Authentication LDAP',
    'Cache::Memcached and memcached server/daemon is required in order to use memcached as caching mechanism used by Movable Type.' => 'Cache::Memcached et le serveur/démon memcached sont requis pour utiliser memcached comme système de cache de Movable Type.', # Translate - New (20)
    'Archive::Tar is required in order to archive files in backup/restore operation.' => 'Archive::Tar est requis pour archiver les fichiers lors de l\'opération de sauvegarde/restauration.', # Translate - New (13)
    'IO::Compress::Gzip is required in order to compress files in backup/restore operation.' => 'IO::Compress::Gzip est requis pour compresser les fichiers lors de l\'opération de sauvegarde/restauration.', # Translate - New (14)
    'IO::Uncompress::Gunzip is required in order to decompress files in backup/restore operation.' => 'IO::Uncompress::Gunzip est requis pour décompresser les fichiers lors de l\'opération de sauvegarde/restauration.', # Translate - New (14)
    'Archive::Zip is required in order to archive files in backup/restore operation.' => 'Archive::Zip est requis pour archiver les fichiers lors de l\'opération de sauvegarde/restauration.', # Translate - New (13)
    'XML::SAX and/or its dependencies is required in order to restore.' => 'XML::SAX et/ou ses dépendences sont requises pour restaurer.', # Translate - New (12)
    'Checking for' => 'Vérification de', # Translate - New (2)
    'Installed' => 'Installé', # Translate - New (1)
    'Data Storage' => 'Stockage des données',
    'Required' => 'Requis',
    'Optional' => 'Optionnels',

    ## ./addons/Enterprise.pack/lib/MT/Group.pm

    ## ./addons/Enterprise.pack/lib/MT/LDAP.pm
    'Invalid LDAPAuthURL scheme: [_1].' => 'Schéma LDAPAuthURL non valide : [_1].',
    'Error connecting to LDAP server [_1]: [_2]' => 'Erreur de connection au serveur LDAP [_1]: [_2]',
    'User not found on LDAP: [_1]' => 'Utilisateur non trouvé sur le LDAP: [_1]',
    'Binding to LDAP server failed: [_1]' => 'La liaison avec le serveur LDAP échoué: [_1]',
    'More than one user with the same name found on LDAP: [_1]' => 'Plus d\'une seul utilisateur portant ce même nom a été trouvé notre LDAP: [_1]',

    ## ./addons/Enterprise.pack/lib/MT/Auth/LDAP.pm
    'User [_1]([_2]) not found.' => 'Utilisateur [_1]([_2]) non trouvé.',
    'User \'[_1]\' cannot be updated.' => 'L\'utilisateur \'[_1]\' ne peut pas être mis à jour',
    'User \'[_1]\' updated with LDAP login ID.' => 'L\'utilisateur \'[_1]\' a été mis à jour avec son identifiant LDAP',
    'LDAP user [_1] not found.' => 'L\'utilisateur LDAP [_1] n\'a pas été trouvé.',
    'User [_1] cannot be updated.' => 'L\'utilisateur [_1] ne peut pas être mis à jour ',
    'User cannot be updated: [_1].' => 'L\'utilisateur ne peut être mis à jour: [_1].',
    'Failed login attempt by user \'[_1]\' deleted from LDAP.' => 'Echec de tentative d\'identification par un utilisateur  \'[_1]\' effacé du  LDAP',
    'User \'[_1]\' updated with LDAP login name \'[_2]\'.' => 'L\'utilisateur \'[_1]\' a été mis à jour avec son login LDAP',
    'User cannot be created: [_1].' => 'L\'utilisateur n\'a pu être créé: [_1].',
    'Failed login attempt by user \'[_1]\'. A user with that\nusername already exists in the system with a different UUID.' => 'Echec de tentative d\'identification par un utilisateur  \'[_1]\'. Un utilisateur avec ce nom d\'utilisateur existe déjà dans le système mais avec un  UUID différent.',
    'User \'[_1]\' account is disabled.' => 'Le compte de l\'utilisateur \'[_1]\' est désactivé',
    'LDAP users synchronization interrupted.' => 'Interruption de la synchronisation utilisateurs LDAP .',
    'Loading MT::LDAP failed: [_1]' => 'Le chargement MT::LDAP a échoué: [_1]',
    'External user synchronization failed.' => 'Echec de la synchronisation externe de l\'utilisateur',
    'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'Une tentative de désactivation de tous les administrateurs a été détectée.La synchronisation des utilisateurs a été interrompue',
    'The following users\' information were modified:' => 'Les informations des utilisateurs suivants ont été modifées:',
    'The following users were disabled:' => 'Les utilisateurs suivants ont été désactivés ',
    'LDAP users synchronized.' => 'Utilisateurs LDAP synchronisés.',
    'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute is set.' => 'La synchronisation des groupes ne peut pas être faite sans l\'activation de LDAPGroupIdAttribute et/ou LDAPGroupNameAttribute.',
    'LDAP groups synchronized with existing groups.' => 'Groupes LDAP synchronisés avec des groupes existants.',
    'The following groups\' information were modified:' => 'Les informations des groupes suivants ont été modifiées:',
    'No LDAP group was found using given filter.' => 'Aucun groupe LDAP n\'a été trouvé avec les critères de recherche donnés.',
    'Filter used to search for groups: [_1]\nSearch base: [_2]' => 'Filtres utilisés pour trouver des groupes: [_1]\nSearch base: [_2]',
    '(none)' => '(aucun)',
    'The following groups were deleted:' => 'Les groupes suivants ont été effacés:',
    'Failed to create a new group: [_1]' => 'Echec dans la création d\'un nouveau groupe: [_1]',
    '[_1] directive must be set to synchronize members of LDAP groups to Movable Type Enterprise.' => 'La directive [_1] doit être active pour synchroniser les membres d\'un group LDAP sur Movable Type Enterprise.',
    'Members removed: ' => 'Membres supprimés: ',
    'Members added: ' => 'Membres ajoutés: ',
    'Memberships of the group \'[_2]\' (#[_3]) has been changed in synchronizing with external directory.' => 'L\'adhésion au groupe \'[_2]\' (#[_3]) a été modifiée lors de la synchronisation avec un répertoire extérieur.',
    'LDAPUserGroupMemberAttribute must be set to enable synchronize members of groups.' => 'LDAPUserGroupMemberAttribute doit être installé pour permettre la synchronisation des membres du groupe.',

    ## ./addons/Enterprise.pack/lib/MT/Enterprise/CMS.pm
    'Group requires name' => 'Le Groupe requiert un nom',
    'Permission denied.' => 'Permission refusée.',
    'Invalid group' => 'Groupe invalide',
    'Add Users to Group [_1]' => 'Ajouter un utilisateur au Groupe[_1]',
    'Select Users' => 'Utilisateurs sélectionnés',
    'Users Selected' => 'Utilisateurs sélectionnés',
    'Type a username to filter the choices below.' => 'Tapez un nom d\'utilisateur pour affiner les choix ci-dessous.',
    '(user deleted)' => '(utilisateur effacé)',
    'Groups' => 'Groupes',
    'Users & Groups' => 'Utilisateurs et Groupes',
    'User Groups' => 'Groupes d\'utilisateurs',
    'Group load failed: [_1]' => 'Echec du chargement du Groupe: [_1]',
    'User load failed: [_1]' => 'Echec du chargement de l\'utilisateur: [_1]',
    'User \'[_1]\' (ID:[_2]) removed from group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) enlevé du groupe \'[_3]\' (ID:[_4]) par \'[_5]\'',
    'User \'[_1]\' (ID:[_2]) was added to group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) a été ajouté au groupe \'[_3]\' (ID:[_4]) par \'[_5]\'',
    'Group Profile' => 'Profil du Groupe',
    'Author load failed: [_1]' => 'Echec du chargement de l\'auteur: [_1]',
    'Invalid user' => 'Utilisateur invalide',
    'Assign User [_1] to Groups' => 'Associer l\'utilisateur [_1] aux groupes',
    'Select Groups' => 'Selectionner les Groupes',
    'Group' => 'Groupe',
    'Description' => 'Description', # Translate - Previous (1)
    'Groups Selected' => 'Groupes sélectionnés',
    'Type a group name to filter the choices below.' => 'Tapez le nom d\'un groupe pour affiner les choix ci-dessous.',
    'Bulk import cannot be used under external user management.' => 'Un import collectif ne peut pas être utilisé par un utilisateur externe.',
    'Users' => 'Utilisateurs',
    'Bulk management' => 'Gestion collective',
    'You did not choose a file to upload.' => 'Vous n\'avez pas sélectionné de fichier à envoyer.',

    ## ./addons/Enterprise.pack/lib/MT/Enterprise/Wizard.pm
    'PLAIN' => 'PLEIN',
    'CRAM-MD5' => 'CRAM-MD5', # Translate - Previous (1)
    'Digest-MD5' => 'Digest-MD5', # Translate - Previous (1)
    'Login' => 'Identification',
    'Found' => 'Trouvé',
    'Not Found' => 'Pas trouvé',

    ## ./addons/Enterprise.pack/lib/MT/ObjectDriver/DDL/MSSQLServer.pm

    ## ./addons/Enterprise.pack/lib/MT/ObjectDriver/DDL/Oracle.pm

    ## ./addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/MSSQLServer.pm
    'PublishCharset [_1] is not supported in this version of MS SQL Server Driver.' => 'PublishCharset [_1] n\'est pas supporté sur cette version de MS SQL Server Driver.',

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
    'Commenter\'s nickname to be used:' => 'Surnom du commentateur à utiliser:', # Translate - New (6)

    ## ./extras/examples/plugins/CommentByGoogleAccount/lib/CommentByGoogleAccount.pm
    'Couldn\'t save the session' => 'Impossible de sauvegarder la session',

    ## ./extras/examples/plugins/FiveStarRating/plugins/FiveStarRating/FiveStarRating.pl
    'You used an [_1] tag outside of the proper context.' => 'Vous utilisez un tag [_1] en dehors de son contexte propre.',

    ## ./extras/examples/plugins/FiveStarRating/plugins/FiveStarRating/lib/FiveStarRating.pm

    ## ./extras/examples/plugins/l10nsample/l10nsample.pl

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample.pm
    'This is localized in perl module' => 'Ceci est localisé dans le module perl',

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N/en_us.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N/ja.pm

    ## ./extras/examples/plugins/mirror/mirror.pl

    ## ./extras/examples/plugins/mirror/lib/Mirror.pm

    ## ./extras/examples/plugins/reCaptcha/plugins/reCaptcha/reCaptcha.pl

    ## ./extras/examples/plugins/reCaptcha/plugins/reCaptcha/lib/reCaptcha.pm

    ## ./extras/examples/plugins/SharedSecret/plugins/SharedSecret/SharedSecret.pl

    ## ./extras/examples/plugins/SharedSecret/plugins/SharedSecret/lib/SharedSecret.pm
    'DO YOU KNOW?  What is MT team\'s favorite brand of chocolate snack?' => 'LE SAVEZ-VOUS?  Quelle est la marque préférée de chocolat de l\'équipe MT?', # Translate - New (13)

    ## ./extras/examples/plugins/SimpleScorer/SimpleScorer.pl

    ## ./extras/examples/plugins/SimpleScorer/lib/SimpleScorer.pm
    'Error during scoring.' => 'Erreur pendant le calcul.', # Translate - New (3)

    ## ./lib/MT/App.pm
    'First Weblog' => 'Premier Weblog',
    'Error loading weblog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => 'Erreur au chargement du weblog  #[_1] pour le nouvel utilisateur. Merci de vérifier vos paramètrages NewUserTemplateBlogId.',
    'Error provisioning weblog for new user \'[_1]\' using template blog #[_2].' => 'Erreur dans la mise en place du weblog pour le nouvel utilisateur \'[_1]\' en utilisant l\'modèle #[_2].',
    'Error creating directory [_1] for blog #[_2].' => 'Erreur lors de la création de la liste [_1] pour le blog #[_2].',
    'Error provisioning weblog for new user \'[_1] (ID: [_2])\'.' => 'Erreur dans la mise en place du weblog pour l\'utilisateur \'[_1] (ID: [_2])\'.',
    'Blog \'[_1] (ID: [_2])\' for user \'[_3] (ID: [_4])\' has been created.' => 'Le Blog \'[_1] (ID: [_2])\' pour l\'utilisateur \'[_3] (ID: [_4])\' a été créé.',
    'Error assigning weblog administration rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable weblog administrator role was found.' => 'Erreur dans l\'attribution des droits d\'administration à l\'utilisateur \'[_1] (ID: [_2])\' pour le weblog \'[_3] (ID: [_4])\'. Aucun rôle d\'administrateur de weblog approprié n\'a été trouvé.',
    'The login could not be confirmed because of a database error ([_1])' => 'Le login ne peut pas être confirmé en raison d\'une erreur de base de données ([_1])',
    'Failed login attempt by unknown user \'[_1]\'' => 'Echec de tentative d\'identification par utilisateur inconnu\'[_1]\'',
    'Invalid login.' => 'Identifiant invalide.',
    'Failed login attempt by disabled user \'[_1]\'' => 'Echec de tentative  d\'identification par utilisateur désactivé \'[_1]\' ',
    'This account has been disabled. Please see your system administrator for access.' => 'Ce compte a été désactivé. Merci de vérifier les accès auprès votre administrateur système.',
    'This account has been deleted. Please see your system administrator for access.' => 'Ce compte a été effacé. Merci de contacter votre administrateur système.',
    'User \'[_1]\' has been created.' => 'L\'utilisateur \'[_1]\' a été crée ',
    'User \'[_1]\' (ID:[_2]) logged in successfully' => 'L\'utilisateur \'[_1]\' (ID:[_2]) s\'est identifié correctement',
    'Invalid login attempt from user \'[_1]\'' => 'Tentative d\'authentification invalide de l\'utilisateur \'[_1]\'',
    'User \'[_1]\' (ID:[_2]) logged out' => 'L\'utilisateur \'[_1]\' (ID:[_2]) s\'est déconnecté',
    'The file you uploaded is too large.' => 'Le fichier téléchargé est trop lourd.',
    'Unknown action [_1]' => 'Action inconnue [_1]',
    'Warnings and Log Messages' => 'Mises en gardes et Messages de Log',
    'Loading template \'[_1]\' failed: [_2]' => 'Echec lors du chargement du modèle \'[_1]\': [_2]',
    'http://www.movabletype.com/' => 'http://www.movabletype.com/', # Translate - New (4)

    ## ./lib/MT/Asset.pm
    'File' => 'Fichier', # Translate - New (1)
    'Files' => 'Fichiers', # Translate - New (1)
    'Location' => 'Adresse', # Translate - New (1)

    ## ./lib/MT/Association.pm

    ## ./lib/MT/Atom.pm

    ## ./lib/MT/AtomServer.pm
    'PreSave failed [_1]' => 'Echec PreEnregistrement [_1]',
    'User \'[_1]\' (user #[_2]) added entry #[_3]' => 'Utilisateur \'[_1]\' (utilisateur #[_2]) a ajouté note #[_3]',
    'User \'[_1]\' (user #[_2]) edited entry #[_3]' => 'Utilisateur \'[_1]\' (utilisateur #[_2]) a ajouté note #[_3]', # Translate - New (7)

    ## ./lib/MT/Auth.pm
    'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Mauvaise configuration du module d\'Authentification \'[_1]\': [_2]',
    'Bad AuthenticationModule config' => 'Mauvaise configuration de AuthenticationModule', # Translate - New (3)

    ## ./lib/MT/Author.pm
    'The approval could not be committed: [_1]' => 'L\'aprobation ne peut être réalisée : [_1]',

    ## ./lib/MT/BackupRestore.pm
    'Backing up [_1] records:' => 'Sauvegarde de [_1] enregistrements:', # Translate - New (4)
    '[_1] records backed up...' => '[_1] enregistrements sauvegardés...', # Translate - New (5)
    '[_1] records backed up.' => '[_1] enregistrements sauvegardés.', # Translate - New (5)
    'There were no [_1] records to be backed up.' => 'Il n\'y a pas d\'enregistrement [_1] à sauvegarder.', # Translate - New (9)
    'Can\'t open directory \'[_1]\': [_2]' => 'Impossible d\'ouvrir le dossier \'[_1]\' : [_2]',
    'No manifest file could be found in your import directory [_1].' => 'Aucun fichier Manifest n\'a été trouvé dans votre répertoire d\'import [_1].', # Translate - New (11)
    'Can\'t open [_1].' => 'Impossible d\'ouvrir [_1].', # Translate - New (4)
    'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'Le fichier Manifest [_1] n\'est pas un fichier Manifest de sauvegarde Movable Type.', # Translate - New (12)
    'Manifest file: [_1]\n' => 'Fichier Manifest: [_1]\n', # Translate - New (4)
    'Path was not found for the asset ([_1]).' => 'Le chemin n\'a pas été trouvé pour l\'élément ([_1]).', # Translate - New (8)
    '[_1] is not writable.' => '[_1] non éditable.',
    'Error making path \'[_1]\': [_2]' => 'Erreur dans le chemin \'[_1]\' : [_2]',
    'Copying [_1] to [_2]...' => 'Copie de [_1] vers [_2]...', # Translate - New (4)
    'Failed: ' => 'Echec: ', # Translate - New (1)
    'Done.' => 'Fini.', # Translate - New (1)
    'ID for the asset was not set.' => 'ID de l\'élément n\'a pas été fixé.', # Translate - New (7)
    'The asset ([_1]) was not restored.' => 'L\'élément ([_1]) n\'a pas été restoré.', # Translate - New (6)
    'Changing file path for the asset \'[_1]\' (ID:[_2])...' => 'Changement de chemin de fichier pour l\'élément \'[_1]\' (ID:[_2])...', # Translate - New (9)
    'failed\n' => 'échoué\n',
    'ok\n' => 'ok\n', # Translate - Previous (2)

    ## ./lib/MT/BasicAuthor.pm

    ## ./lib/MT/BasicSession.pm

    ## ./lib/MT/Blocklist.pm

    ## ./lib/MT/Blog.pm
    'No default templates were found.' => 'Aucun modèle par défaut trouvé.', # Translate - New (5)
    'Cloned blog... new id is [_1].' => 'Le nouvel identifiant du blog cloné est [_1]',
    'Cloning permissions for blog:' => 'Clonage des permissions du blog:', # Translate - New (4)
    '[_1] records processed...' => '[_1] enregistrements effectués...',
    '[_1] records processed.' => '[_1] enregistrements effectués.',
    'Cloning associations for blog:' => 'Clonage des associations du blog:', # Translate - New (4)
    'Cloning entries for blog...' => 'Clonage des notes du blog...', # Translate - New (4)
    'Cloning categories for blog...' => 'Clonage des catégories du blog...', # Translate - New (4)
    'Cloning entry placements for blog...' => 'Clonage des placements de notes du blog...', # Translate - New (5)
    'Cloning comments for blog...' => 'Clonage des commentaires de blog...', # Translate - New (4)
    'Cloning entry tags for blog...' => 'Clonage des tags de notes du blog...', # Translate - New (5)
    'Cloning TrackBacks for blog...' => 'Clonage des TrackBacks du blog...', # Translate - New (4)
    'Cloning TrackBack pings for blog...' => 'Clonage des pings de TrackBack du blog...', # Translate - New (5)
    'Cloning templates for blog...' => 'Clonage des modèles du blog...', # Translate - New (4)
    'Cloning template maps for blog...' => 'Clonage des mappages de modèle du blog...', # Translate - New (5)

    ## ./lib/MT/Bootstrap.pm
    'Got an error: [_1]' => 'Erreur de type : [_1]',

    ## ./lib/MT/Builder.pm
    '<MT[_1]> with no </MT[_1]>' => '<MT[_1]> sans </MT[_1]>', # Translate - New (7)
    'Error in <mt:[_1]> tag: [_2]' => 'Erreur dans balise <mt:[_1]> : [_2]', # Translate - New (6)
    'No handler exists for tag [_1]' => 'Pas de handler existant pour balise [_1]', # Translate - New (6)

    ## ./lib/MT/BulkCreation.pm
    'Format error at line [_1]: [_2]' => 'Erreur de format à la ligne [_1]: [_2]',
    'Invalid command: [_1]' => 'Commande invalide: [_1]',
    'Invalid number of columns for [_1]' => 'Nombre de colonnes invalide pour [_1]',
    'Invalid user name: [_1]' => 'Nom utilisateur invalide: [_1]',
    'Invalid display name: [_1]' => 'Nom affiché invalide: [_1]',
    'Invalid email address: [_1]' => 'Adresse email invalide: [_1]',
    'Invalid language: [_1]' => 'Langue invalide: [_1]',
    'Invalid password: [_1]' => 'Mot de passe invalide: [_1]',
    'Invalid password recovery phrase: [_1]' => 'Phrase the récupération de mot de passe invalide: [_1]',
    'Invalid weblog name: [_1]' => 'Nom de weblog invalide: [_1]',
    'Invalid weblog description: [_1]' => 'Description de weblog invalide: [_1]',
    'Invalid site url: [_1]' => 'URL du site invalide: [_1]',
    'Invalid site root: [_1]' => 'Racine du site invalide: [_1]',
    'Invalid timezone: [_1]' => 'Zone horaire invalide: [_1]',
    'Invalid new user name: [_1]' => 'Nouveau nom d\'utilisateur invalide: [_1]',
    'A user with the same name was found.  Register was not processed: [_1]' => 'Un utilisateur avec le même nom a été trouvé.  L\'enregistrement n\'a pas eu lieu: [_1]',
    'Blog for user \'[_1]\' can not be created.' => 'Le blog pour l\'utilisateur \'[_1]\' ne peut être créé.',
    'Blog \'[_1]\' for user \'[_2]\' has been created.' => 'Le blog \'[_1]\' pour l\'utilisateur \'[_2]\' a été créé.',
    'Permission granted to user \'[_1]\'' => 'Autorisation accordée à l\'utilisateur \'[_1]\'',
    'User \'[_1]\' already exists. Update was not processed: [_2]' => 'L\'utilisateur \'[_1]\' existe déjà. La mise à jour n\'a pas été effectuée: [_2]',
    'User \'[_1]\' not found.  Update was not processed.' => 'L\'utilisateur \'[_1]\' n\'a pas été trouvé.  La mise à jour n\'a pas été effectuée.',
    'User \'[_1]\' has been updated.' => 'L\'utilisateur \'[_1]\' a été mis à jour.',
    'User \'[_1]\' was found, but delete was not processed' => 'L\'utilisateur \'[_1]\' a été trouvé, mais l\'effacement n\'a pas eu lieu',
    'User \'[_1]\' not found.  Delete was not processed.' => 'L\'utilisateur \'[_1]\' n\'a pas été trouvé.  L\'effacement n\'a pas été effectuée.',
    'User \'[_1]\' has been deleted.' => 'L\'utilisateur \'[_1]\' a été effacé.',

    ## ./lib/MT/Callback.pm

    ## ./lib/MT/Category.pm
    'Categories must exist within the same blog' => 'Les catégories doivent exister au sein du même blog ',
    'Category loop detected' => 'Loop de catégorie détecté',

    ## ./lib/MT/Comment.pm
    'Comment' => 'Commentaire',
    'Load of entry \'[_1]\' failed: [_2]' => 'Le chargement de la note \'[_1]\' a échoué : [_2]',
    'Load of blog \'[_1]\' failed: [_2]' => 'Le chargement du blog \'[_1]\' a échoué : [_2]',

    ## ./lib/MT/Component.pm
    'Rebuild' => 'Actualiser',

    ## ./lib/MT/Config.pm

    ## ./lib/MT/ConfigMgr.pm
    'Alias for [_1] is looping in the configuration.' => 'L alias pour [_1] fait une boucle dans la configuration ',
    'Error opening file \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture du fichier \'[_1]\': [_2]',
    'Config directive [_1] without value at [_2] line [_3]' => 'Directive de Config  [_1] sans valeur sur [_2] ligne [_3]',
    'No such config variable \'[_1]\'' => 'Pas de variable de Config de ce type \'[_1]\'',

    ## ./lib/MT/Core.pm

    ## ./lib/MT/DateTime.pm

    ## ./lib/MT/default-templates.pl

    ## ./lib/MT/DefaultTemplates.pm

    ## ./lib/MT/Entry.pm
    'Load of blog failed: [_1]' => 'Echec lors du chargement du blog : [_1]',

    ## ./lib/MT/ErrorHandler.pm

    ## ./lib/MT/FileInfo.pm

    ## ./lib/MT/FileMgr.pm

    ## ./lib/MT/Folder.pm
    'Folder' => 'Répertoire', # Translate - New (1)
    'Folders' => 'Répertoires', # Translate - New (1)

    ## ./lib/MT/I18N.pm

    ## ./lib/MT/Image.pm
    'Can\'t load Image::Magick: [_1]' => 'Impossible de charger Image::Magick : [_1]',
    'Reading file \'[_1]\' failed: [_2]' => 'La lecture du fichier \'[_1]\' a échoué : [_2]',
    'Reading image failed: [_1]' => 'Echec lors de la lecture de l\'image : [_1]',
    'Scaling to [_1]x[_2] failed: [_3]' => 'La mise à l\'échelle vers [_1]x[_2] a échoué : [_3]',
    'Can\'t load IPC::Run: [_1]' => 'Impossible de charger IPC::Run : [_1]',
    'You do not have a valid path to the NetPBM tools on your machine.' => 'Votre chemin d\'accès vers les outils NetPBM n\'est pas valide sur votre machine.',

    ## ./lib/MT/Import.pm
    'Can\'t rewind' => 'Impossible de revenir en arrière',
    'Can\'t open \'[_1]\': [_2]' => 'Impossible d\'ouvrir \'[_1]\' : [_2]',
    'No readable files could be found in your import directory [_1].' => 'Aucun fichier lisible n\'a été trouvé dans le répertoire d\'importation [_1].',
    'Importing entries from file \'[_1]\'' => 'Importation des notes du fichier \'[_1]\'',
    'Couldn\'t resolve import format [_1]' => 'Impossible de détecter le format d\'import [_1]', # Translate - New (6)

    ## ./lib/MT/ImportExport.pm
    'No Blog' => 'Pas de Blog',
    'You need to provide a password if you are going to\n' => 'Vous devez saisir un mot de passe si vous allez sur \n',
    'Need either ImportAs or ParentAuthor' => 'ImportAs ou ParentAuthor sont nécessaires',
    'Creating new user (\'[_1]\')...' => 'Creation d\'un nouvel utilisateur (\'[_1]\')...',
    'Saving user failed: [_1]' => 'Echec lors de la sauvegarde de l\'Utilisateur : [_1]',
    'Assigning permissions for new user...' => 'Mise en place des autorisations pour le nouvel utilisateur...',
    'Saving permission failed: [_1]' => 'Echec lors de la sauvegarde des Droits des Utilisateurs : [_1]',
    'Creating new category (\'[_1]\')...' => 'Creation d\'une nouvelle catégorie (\'[_1]\')...',
    'Saving category failed: [_1]' => 'Echec lors de la sauvegarde des Catégories : [_1]',
    'Invalid status value \'[_1]\'' => 'Valeur d\'état invalide \'[_1]\'',
    'Invalid allow pings value \'[_1]\'' => 'Valeur Ping invalide\'[_1]\'',
    'Can\'t find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.\n' => 'Impossible de trouver une note existante avec la date \'[_1]\'... saut des commentaires et passage à la note suivante.\n',
    'Importing into existing entry [_1] (\'[_2]\')\n' => 'Importation dans la note [_1] (\'[_2]\')\n',
    'Saving entry (\'[_1]\')...' => 'Enregistrement de la note (\'[_1]\')...',
    'ok (ID [_1])\n' => 'ok (ID [_1])\n', # Translate - Previous (4)
    'Saving entry failed: [_1]' => 'Echec lors de la sauvegarde de la Note: [_1]',
    'Saving placement failed: [_1]' => 'Echec lors de la sauvegarde du Placement : [_1]',
    'Creating new comment (from \'[_1]\')...' => 'Création d\'un nouveau commentaire (de \'[_1]\')...',
    'Saving comment failed: [_1]' => 'Echec lors de la sauvegarde du Commentaire : [_1]',
    'Entry has no MT::Trackback object!' => 'La note n\'a pas d\'objet MT::Trackback !',
    'Creating new ping (\'[_1]\')...' => 'Création d\'un nouveau ping (\'[_1]\')...',
    'Saving ping failed: [_1]' => 'Echec lors de la sauvegarde du ping : [_1]',
    'Export failed on entry \'[_1]\': [_2]' => 'Echec lors de l\'export sur la Note \'[_1]\' : [_2]',
    'Invalid date format \'[_1]\'; must be ' => 'Format de date invalide \'[_1]\'; doit être ',

    ## ./lib/MT/IPBanList.pm

    ## ./lib/MT/JunkFilter.pm
    'Action: Junked (score below threshold)' => 'Action : Indésirable (score ci-dessous)',
    'Action: Published (default action)' => 'Action : Publié (action par défaut)',
    'Junk Filter [_1] died with: [_2]' => 'Filtre indésirable [_1] mort avec : [_2]',
    'Unnamed Junk Filter' => 'Filtre indésirable sans nom',
    'Composite score: [_1]' => 'Score composite : [_1]',

    ## ./lib/MT/L10N.pm

    ## ./lib/MT/Log.pm
    'Pages' => 'Pages', # Translate - New (1)
    'Page # [_1] not found.' => 'Page # [_1] non trouvée.', # Translate - New (4)
    'Entry # [_1] not found.' => 'Note # [_1] non trouvée.',
    'Comment # [_1] not found.' => 'Commentaire # [_1] non trouvé.',
    'TrackBack # [_1] not found.' => 'TrackBack # [_1] non trouvé.',

    ## ./lib/MT/Mail.pm
    'Unknown MailTransfer method \'[_1]\'' => 'Méthode de transfert de mail inconnu \'[_1]\'',
    'Sending mail via SMTP requires that your server ' => 'L\'envoi de mail via SMTP nécessite que votre serveur ',
    'Error sending mail: [_1]' => 'Erreur lors de l\'envoi du mail : [_1]',
    'You do not have a valid path to sendmail on your machine. ' => 'Le chemin d\'accès vers sendmail n\'est pas valide sur votre machine. ',
    'Exec of sendmail failed: [_1]' => 'Echec lors de l\'exécution de sendmail : [_1]',

    ## ./lib/MT/Memcached.pm

    ## ./lib/MT/Notification.pm

    ## ./lib/MT/Object.pm

    ## ./lib/MT/ObjectAsset.pm

    ## ./lib/MT/ObjectDriverFactory.pm

    ## ./lib/MT/ObjectScore.pm

    ## ./lib/MT/ObjectTag.pm

    ## ./lib/MT/Page.pm
    'Page' => 'Page', # Translate - New (1)

    ## ./lib/MT/Permission.pm

    ## ./lib/MT/Placement.pm

    ## ./lib/MT/Plugin.pm

    ## ./lib/MT/PluginData.pm

    ## ./lib/MT/Promise.pm

    ## ./lib/MT/Request.pm

    ## ./lib/MT/Role.pm

    ## ./lib/MT/Sanitize.pm

    ## ./lib/MT/Scorable.pm
    'Already scored for this object.' => 'Cet objet a déjà été noté', # Translate - New (5)

    ## ./lib/MT/Serialize.pm

    ## ./lib/MT/Session.pm

    ## ./lib/MT/Tag.pm
    'Tag must have a valid name' => 'Le tag doit avoir un nom valide',
    'This tag is referenced by others.' => 'Ce Tag est référencé par d autres.',

    ## ./lib/MT/Task.pm

    ## ./lib/MT/TaskMgr.pm
    'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'Impossible d\'assurer le vérrouillage pour l\'éxécution de tâches système. Vérifiez que la zone TempDir ([_1]) est en mode écriture.',
    'Error during task \'[_1]\': [_2]' => 'Erreur pendant la tâche \'[_1]\' : [_2]',
    'Scheduled Tasks Update' => 'Mise à jour des tâches planifiées',
    'The following tasks were run:' => 'Les tâches suivantes ont été exécutées :',

    ## ./lib/MT/TBPing.pm

    ## ./lib/MT/Template.pm
    'File not found: [_1]' => 'Fichier non trouvé: [_1]', # Translate - New (4)
    'Parse error in template \'[_1]\': [_2]' => 'Erreur de parsing dans le modèle \'[_1]\' : [_2]',
    'Build error in template \'[_1]\': [_2]' => 'Erreur de compilation dans le modèle \'[_1]\' : [_2]',
    'Template with the same name already exists in this blog.' => 'Un modèle avec le même nom exite déjà dans ce blog.', # Translate - New (10)
    'You cannot use a [_1] extension for a linked file.' => 'Vous ne pouvez pas utiliser l\'extension [_1] pour un fichier joint.',
    'Opening linked file \'[_1]\' failed: [_2]' => 'L\'ouverture du fichier lié \'[_1]\' a échoué : [_2] ',

    ## ./lib/MT/TemplateMap.pm

    ## ./lib/MT/Trackback.pm

    ## ./lib/MT/Upgrade.pm
    'Custom ([_1])' => '([_1]) personnalisé ',
    'This role was generated by Movable Type upon upgrade.' => 'Ce rôle a été généré par Movable Type lors d\'une mise à jour.',
    'First Blog' => 'Premier Blog', # Translate - New (2)
    'User \'[_1]\' upgraded database to version [_2]' => 'L\'utilisateur \'[_1]\' a mis à jour la base de données avec la version [_2]',
    'User \'[_1]\' upgraded plugin \'[_2]\' to version [_3] (schema version [_4]).' => 'Utilisateur \'[_1]\' a mis à jour le plugin \'[_2]\' vers la version [_3] (schéma version [_4]).', # Translate - New (11)
    'User \'[_1]\' installed plugin \'[_2]\', version [_3] (schema version [_4]).' => 'Utilisateur \'[_1]\' a installé le plugin \'[_2]\', version [_3] (schéma version [_4]).', # Translate - New (10)

    ## ./lib/MT/Util.pm
    'Less than 1 minute from now' => 'Moins d\'une minute à partir de maintenant',
    'Less than 1 minute ago' => 'Il y a moins d\'une minute',
    '[quant,_1,hour], [quant,_2,minute] from now' => '[quant,_1,heure], [quant,_2,minute] à compter de maintenant',
    '[quant,_1,hour], [quant,_2,minute] ago' => 'Il y a [quant,_1,heure], [quant,_2,minute]',
    '[quant,_1,hour] from now' => '[quant,_1,heure] à compter de maintenant',
    '[quant,_1,hour] ago' => 'Il y a [quant,_1,heure]',
    '[quant,_1,minute] from now' => '[quant,_1,minute] à compter de maintenant',
    '[quant,_1,minute] ago' => 'Il y a [quant,_1,minute]',
    '[quant,_1,day], [quant,_2,hour] from now' => '[quant,_1,jour], [quant,_2,heure] à compter de maintenant',
    '[quant,_1,day], [quant,_2,hour] ago' => 'Il y a [quant,_1,jour], [quant,_2,heure]',
    '[quant,_1,day] from now' => '[quant,_1,jour] à compter de maintenant',
    '[quant,_1,day] ago' => 'Il y a [quant,_1,jour]',

    ## ./lib/MT/WeblogPublisher.pm
    'yyyy/index.html' => 'aaaa/index.html', # Translate - New (3)
    'yyyy/mm/index.html' => 'aaaa/mm/index.html', # Translate - New (4)
    'yyyy/mm/day-week/index.html' => 'aaaa/mm/jour-semaine/index.html', # Translate - New (5)
    'yyyy/mm/entry_basename.html' => 'aaaa/mm/nomdebase_note.html', # Translate - New (5)
    'yyyy/mm/entry-basename.html' => 'aaaa/mm/nomdebase-note.html', # Translate - New (4)
    'yyyy/mm/entry_basename/index.html' => 'aaaa/mm/nomdebase_note/index.html', # Translate - New (6)
    'yyyy/mm/entry-basename/index.html' => 'aaaa/mm/nomdebase-note/index.html', # Translate - New (5)
    'yyyy/mm/dd/entry_basename.html' => 'aaaa/mm/jj/nomdebase_note.html', # Translate - New (6)
    'yyyy/mm/dd/entry-basename.html' => 'aaaa/mm/jj/nomdebase-note.html', # Translate - New (5)
    'yyyy/mm/dd/entry_basename/index.html' => 'aaaa/mm/jj/nomdebase_note/index.html', # Translate - New (7)
    'yyyy/mm/dd/entry-basename/index.html' => 'aaaa/mm/jj/nomdebase-note/index.html', # Translate - New (6)
    'category/sub_category/entry_basename.html' => 'categorie/sous_categorie/nomdebase_note.html', # Translate - New (6)
    'category/sub_category/entry_basename/index.html' => 'categorie/sous_categorie/nomdebase_note/index.html', # Translate - New (7)
    'category/sub-category/entry-basename.html' => 'categorie/sous-categorie/nomdebase-note.html', # Translate - New (4)
    'category/sub-category/entry-basename/index.html' => 'categorie/sous-categorie/nomdebase-note/index.html', # Translate - New (5)
    'folder_path/page_basename.html' => 'chemin_repertoire/nomdebase_page.html', # Translate - New (5)
    'folder_path/page_basename/index.html' => 'chemin_repertoire/nomdebase_page/index.html', # Translate - New (6)
    'folder-path/page-basename.html' => 'chemin-repertoire/nomdebase-page.html', # Translate - New (3)
    'folder-path/page-basename/index.html' => 'chemin-repertoire/nomdebase-page/index.html', # Translate - New (4)
    'folder/sub_folder/index.html' => 'repertoire/sous_repertoire/index.html', # Translate - New (5)
    'folder/sub-folder/index.html' => 'repertoire/sous-repertoire/index.html', # Translate - New (4)
    'yyyy/mm/dd/index.html' => 'aaaa/mm/jj/index.html', # Translate - New (5)
    'category/sub_category/index.html' => 'categorie/sous_categorie/index.html', # Translate - New (5)
    'category/sub-category/index.html' => 'categorie/sous-categorie/index.html', # Translate - New (4)
    'Archive type \'[_1]\' is not a chosen archive type' => 'Le Type d\'archive\'[_1]\' n\'est pas un type d\'archive sélectionné',
    'Parameter \'[_1]\' is required' => 'Le Paramètre \'[_1]\' est requis',
    'You did not set your weblog Archive Path' => 'Vous n\'avez pas configuré le Chemin d\'Archive de votre weblog', # Translate - New (8)
    'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Le même fichier d\'archive existe déjà. Vous devez changer le nom de base ou le chemin de l\'archive ([_1])', # Translate - New (15)
    'Building category \'[_1]\' failed: [_2]' => 'La construction de la catégorie\'[_1]\' a échoué : [_2]',
    'Building entry \'[_1]\' failed: [_2]' => 'La construction de la note \'[_1]\' a échoué : [_2]',
    'Building date-based archive \'[_1]\' failed: [_2]' => 'La construction des archives de la base de données \'[_1]\' a échoué : [_2]',
    'Writing to \'[_1]\' failed: [_2]' => 'Ecriture sur\'[_1]\' a échoué: [_2]',
    'Renaming tempfile \'[_1]\' failed: [_2]' => 'Le renommage de tempfile \'[_1]\' a échoué: [_2]',
    'You did not set your weblog Site Root' => 'Vous n\'avez pas configuré la Racine de Site de votre weblog', # Translate - New (8)
    'Template \'[_1]\' does not have an Output File.' => 'Le modèle \'[_1]\' n\'a pas de fichier de sortie.',
    'An error occurred while rebuilding to publish scheduled entries: [_1]' => 'Une erreur s\'est produite en republiant les notes programmées: [_1]', # Translate - New (10)
    'YEARLY_ADV' => 'YEARLY_ADV', # Translate - New (2)
    'MONTHLY_ADV' => 'par mois',
    'CATEGORY_ADV' => 'par catégorie',
    'PAGE_ADV' => 'PAGE_ADV', # Translate - New (2)
    'INDIVIDUAL_ADV' => 'par note',
    'DAILY_ADV' => 'de façon quotidienne',
    'WEEKLY_ADV' => 'hebdomadaire',

    ## ./lib/MT/XMLRPC.pm
    'No WeblogsPingURL defined in mt.cfg' => 'Le WeblogsPingURL n\'est pas défini dans le fichier mt.cfg',
    'No MTPingURL defined in mt.cfg' => 'Le MTPingURL  n\'est pas défini dans le fichier mt.cfg',
    'HTTP error: [_1]' => 'Erreur HTTP: [_1]',
    'Ping error: [_1]' => 'Erreur Ping: [_1]',

    ## ./lib/MT/XMLRPCServer.pm
    'Invalid timestamp format' => 'Format de date invalide',
    'No web services password assigned.  Please see your user profile to set it.' => 'Aucun mot de passe associé au service web. Merci de vérifier votre profil Utilisateur pour le définir.',
    'No blog_id' => 'Pas de blog_id',
    'Invalid blog ID \'[_1]\'' => 'ID du blog invalide \'[_1]\'',
    'Invalid login' => 'Login invalide',
    'No publishing privileges' => 'Pas de privilèges de publication', # Translate - New (3)
    'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => 'Valeur pour \'mt_[_1]\' doit être 1 ou 0 (était \'[_2]\')',
    'No entry_id' => 'Pas de note_id',
    'Invalid entry ID \'[_1]\'' => 'ID de Note invalide \'[_1]\'',
    'Not privileged to edit entry' => 'Pas détenteur de droit pour modifier les notes',
    'Not privileged to delete entry' => 'Pas détenteur de droit pour effacer des notes',
    'Entry \'[_1]\' (entry #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'Note \'[_1]\' (la note #[_2])effacée par \'[_3]\' (utilisateur #[_4]) de xml-rpc',
    'Not privileged to get entry' => 'Pas détenteur de droit pour avoir une Note',
    'User does not have privileges' => 'L\'utilisateur n\'est pas détenteur de droits',
    'Not privileged to set entry categories' => 'Pas détenteur de droit pour choisir la catégorie d\'une Note',
    'Publish failed: [_1]' => 'Echec de la publication : [_1]',
    'Not privileged to upload files' => 'Pas détenteur de droit pour télécharger des fichiers',
    'No filename provided' => 'Aucun nom de fichier',
    'Invalid filename \'[_1]\'' => 'Nom de fichier invalide \'[_1]\'',
    'Error writing uploaded file: [_1]' => 'Erreur écriture fichier téléchargé : [_1]',
    'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Les méthodes de modèle ne sont pas implémentée en raison d\'une différence entre l\'API Blogger et l\'API Movable Type.',

    ## ./lib/MT/App/ActivityFeeds.pm
    'Error loading [_1]: [_2]' => 'Erreur au chargement [_1] : [_2]',
    'An error occurred while generating the activity feed: [_1].' => 'Une erreur est survenue lors de la génération du flux d\'activité : [_1].',
    'No permissions.' => 'Pas de permissions.',
    '[_1] Weblog TrackBacks' => 'TrackBacks du weblog [_1] ',
    'All Weblog TrackBacks' => 'Tous les TrackBacks du weblog',
    '[_1] Weblog Comments' => 'Commentaires du weblog[_1] ',
    'All Weblog Comments' => 'Tous les commentaires du weblog',
    '[_1] Weblog Entries' => 'Notes du weblog[_1] ',
    'All Weblog Entries' => 'Toutes les notes du weblog ',
    '[_1] Weblog Activity' => 'Activité du weblog [_1] ',
    'All Weblog Activity' => 'Toutes l activité du weblog',
    'Movable Type Debug Activity' => 'Activité Debug Movable Type',

    ## ./lib/MT/App/CMS.pm
    'Invalid request' => 'Demande incorrecte',
    'Invalid request.' => 'Demande invalide.',
    'All comments by [_1] \'[_2]\'' => 'Tous les commentaires par [_1] \'[_2]\'', # Translate - New (5)
    'All comments for [_1] \'[_2]\'' => 'Tous les commentaires pour [_1] \'[_2]\'', # Translate - New (5)
    'Invalid blog' => 'Blog incorrect',
    'Convert Line Breaks' => 'Conversion retours ligne',
    'Password Recovery' => 'Récupération de mot de passe',
    'Invalid password recovery attempt; can\'t recover password in this configuration' => 'Tentative de récupération de mot de passe invalide; impossible de récupérer le mot de passe dans cette configuration',
    'Invalid author_id' => 'auteur_id incorrect',
    'Can\'t recover password in this configuration' => 'impossible de récupérer le mot de passe dans cette configuration',
    'Invalid user name \'[_1]\' in password recovery attempt' => 'Nom d\'utilisateur invalide \'[_1]\' lors de la tentative de récupération du mot de passe',
    'User name or birthplace is incorrect.' => 'Le nom ou la date de naissance de l\'utilisateur sont incorrects',
    'User has not set birthplace; cannot recover password' => 'L\'utilisateur n\'a pas indiqué son lieu de naissance; il ne peut récupérer son mot de passe',
    'Invalid attempt to recover password (used birthplace \'[_1]\')' => 'Tentative invalide pour récupérer son mot de passe (lieu de naissance utilisé \'[_1]\')',
    'User does not have email address' => 'L\'utilisateur n\'a pas d\'adresse email',
    'Password was reset for user \'[_1]\' (user #[_2]). Password was sent to the following address: [_3]' => 'Le mot de passe a été rétabli pour l\'utilisateur \'[_1]\' (utilisateur #[_2]). Le mot de passe a été envoyé à l\'adresse suivante: [_3]',
    'Error sending mail ([_1]); please fix the problem, then ' => 'Erreur lors de l\'envoi de l\'e-mail ([_1]); veuillez résoudre le problème puis ',
    '(newly created user)' => '(utilisateur nouvellement créé)', # Translate - New (4)
    'Search Files' => 'Rechercher Fichiers', # Translate - New (2)
    'Invalid group id' => 'Identifiant de Groupe Invalide',
    'Group Roles' => 'Rôles du Groupe',
    'Invalid user id' => 'Identifiant Utilisateur Invalide',
    'User Roles' => 'Rôles de l\'utilisateur',
    'Roles' => 'Roles', # Translate - Previous (1)
    'Group Associations' => 'Associations de Groupe',
    'User Associations' => 'Associations d\'utilisateur',
    'Role Users & Groups' => 'Role Utilisateurs et Groupes',
    'Associations' => 'Associations', # Translate - Previous (1)
    '(Custom)' => '(Personnalisé)',
    'Invalid type' => 'Type incorrect',
    'No such tag' => 'Pas de Tag de ce type',
    'None' => 'Aucune',
    'You are not authorized to log in to this blog.' => 'Vous n\'êtes pas autorisé à vous connecter sur ce weblog.',
    'No such blog [_1]' => 'Aucun weblog ne porte le nom [_1]',
    'Blogs' => 'Blogs', # Translate - New (1)
    'Blog Activity Feed' => 'Flux Activité du Blog', # Translate - New (3)
    'Group Members' => 'Membres du groupe',
    'QuickPost' => 'QuickPost', # Translate - Previous (1)
    'All Feedback' => 'Tous les retours lecteurs',
    'System Activity Feed' => 'Flux d\'activité du système',
    'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'Journal d\'activité pour le blog \'[_1]\' (ID:[_2]) réinitialisé par \'[_3]\'',
    'Activity log reset by \'[_1]\'' => 'Journal d\'activité réinitialisé par \'[_1]\'',
    'No blog ID' => 'Aucun blog ID',
    'You do not have import permissions' => 'Vous n\'avez pas les droits d\'importation',
    'Import/Export' => 'Importer / Exporter',
    'Invalid parameter' => 'Paramètre Invalide',
    'Permission denied: [_1]' => 'Autorisation refusée: [_1]',
    'Load failed: [_1]' => 'Echec de chargement : [_1]',
    '(no reason given)' => '(sans raison donnée)',
    '(untitled)' => '(sans titre)',
    'General Settings' => 'Paramètres généraux',
    'Publishing Settings' => 'Paramètres de publication',
    'Plugin Settings' => 'Paramètres des plugins',
    'Edit TrackBack' => 'Editer les  TrackBacks',
    'Edit Comment' => 'Modifier les commentaires',
    'Authenticated Commenters' => 'Auteurs de commentaires authentifiés',
    'Commenter Details' => 'Détails sur l\'auteur de commentaires',
    'New Page' => 'Nouvelle Page', # Translate - New (2)
    'Create template requires type' => 'La création d\'modèles nécessite un type',
    'Date based Archive' => 'Archivage par date', # Translate - New (3)
    'Individual Entry Archive' => 'Archivage par note',
    'Category Archive' => 'Archivage par catégorie',
    'Page Archive' => 'Archive de Page', # Translate - New (2)
    'New Template' => 'Nouveau modèle',
    'New Blog' => 'Nouveau Blog', # Translate - New (2)
    'Create New User' => 'Créer un nouvel utilisateur',
    'User requires username' => 'Un nom d\'utilisateur est nécessaire pour l\'utilisateur',
    'A user with the same name already exists.' => 'Un utilisateur possédant ce nom existe déjà.',
    'User requires password' => 'L\'utilisateur a besoin d\'un mot de passe',
    'User requires password recovery word/phrase' => 'L\'utilisateur demande la phrase de récupération de mot de passe',
    'Email Address is required for password recovery' => 'L\'adresse email est nécessaire pour récupérer le mot de passe',
    'The value you entered was not a valid email address' => 'Vous devez saisir une adresse e-mail valide',
    'The e-mail address you entered is already on the Notification List for this blog.' => 'L\'adresse email saisie est déjà sur la liste de notification de ce blog.', # Translate - New (14)
    'You did not enter an IP address to ban.' => 'Vous devez saisir une adresse IP à bannir.',
    'The IP you entered is already banned for this blog.' => 'L\'adresse IP saisie est déjà bannie pour ce blog.', # Translate - New (10)
    'You did not specify a blog name.' => 'Vous n\'avez pas spécifié un nom de blog.', # Translate - New (7)
    'Site URL must be an absolute URL.' => 'L\'URL du site doit être une URL absolue.',
    'Archive URL must be an absolute URL.' => 'Les URL d\'archive doivent être des URL absolues.',
    'The name \'[_1]\' is too long!' => 'Le nom \'[_1]\' est trop long.',
    'A user can\'t change his/her own username in this environment.' => 'Un utilisateur ne peut pas changer son nom d\'utilisateur dans cet environnement',
    'An errror occurred when enabling this user.' => 'Une erreur s\'est produite pendant l\'activation de cet utilisateur.',
    'Folder \'[_1]\' created by \'[_2]\'' => 'Répertoire \'[_1]\' créé par \'[_2]\'', # Translate - New (5)
    'Category \'[_1]\' created by \'[_2]\'' => 'Catégorie \'[_1]\' créée par \'[_2]\'',
    'The folder \'[_1]\' conflicts with another folder. Folders with the same parent must have unique basenames.' => 'Le répertoire \'[_1]\' est en conflit avec un autre répertoire. Les répertoires qui ont le même répertoire parent doivent avoir un nom de base unique.', # Translate - New (16)
    'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Le nom de catégorie \'[_1]\' est en conflit avec une autre catégorie. Les catégories racines et les sous-catégories qui ont le même parent doivent avoir des noms uniques.', # Translate - New (20)
    'The category basename \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => 'Le nom de base de la catégorie \'[_1]\' est en conflit avec une autre catégorie. Les catégories racines et les sous-catégories qui ont le même parent doivent avoir des noms de base uniques.', # Translate - New (20)
    'Saving permissions failed: [_1]' => 'Echec lors de la sauvegarde des Autorisations : [_1]',
    'Blog \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) créé par \'[_3]\'', # Translate - New (7)
    'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) créé par \'[_3]\'',
    'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Modèle \'[_1]\' (ID:[_2]) créé par \'[_3]\'',
    'You cannot delete your own association.' => 'Vous ne pouvez pas supprimer votre propre association.',
    'You cannot delete your own user record.' => 'Vous ne pouvez pas effacer vos propres données Utilisateur.',
    'You have no permission to delete the user [_1].' => 'Vous n\'avez pas l\'autorisation d\'effacer l\'utilisateur [_1].',
    'Blog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) effacé par \'[_3]\'', # Translate - New (7)
    'Subscriber \'[_1]\' (ID:[_2]) deleted from notification list by \'[_3]\'' => 'Abonné \'[_1]\' (ID:[_2]) supprimé de la liste de notifications par \'[_3]\'',
    'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
    'Folder \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Répertoire \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'', # Translate - New (7)
    'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Catégorie \'[_1]\' (ID:[_2]) supprimée par \'[_3]\'',
    'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Commentaire (ID:[_1]) de \'[_2]\' supprimé par \'[_3]\' de la note \'[_4]\'',
    'Page \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Page \'[_1]\' (ID:[_2]) supprimée par \'[_3]\'', # Translate - New (7)
    'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Note \'[_1]\' (ID:[_2]) supprimée par \'[_3]\'',
    '(Unlabeled category)' => '(Catégorie sans description)',
    'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) de \'[_2]\' supprimé par \'[_3]\' de la catégorie \'[_4]\'',
    '(Untitled entry)' => '(Note sans titre)',
    'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) de \'[_2]\' supprimé par \'[_3]\' de la note \'[_4]\'',
    'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Modèle \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
    'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Tag \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
    'File \'[_1]\' uploaded by \'[_2]\'' => 'Fichier \'[_1]\' envoyé par \'[_2]\'', # Translate - New (5)
    'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Fichier \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'', # Translate - New (7)
    'Permisison denied.' => 'Permission refusée.',
    'The Template Name and Output File fields are required.' => 'Le nom du modèle et les champs du fichier de sortie sont obligatoires.', # Translate - New (9)
    'Invalid type [_1]' => 'Type invalide [_1]', # Translate - New (3)
    'Save failed: [_1]' => 'Echec sauvegarde: [_1]',
    'Saving object failed: [_1]' => 'Echec lors de la sauvegarde de l\'objet : [_1]',
    'No Name' => 'Pas de Nom',
    'Notification List' => 'Liste de notifications',
    'IP Banning' => 'Bannissement d\'adresses IP',
    'Can\'t delete that way' => 'Impossible de supprimer comme cela',
    'Removing tag failed: [_1]' => 'Suppression du tag échouée: [_1]', # Translate - New (4)
    'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => 'Vous ne pouvez pas effacer cette catégorie car elle contient des sous-catégories. Déplacez ou supprimez d\'abord les sous-catégories pour pouvoir effacer cette catégorie.',
    'Loading MT::LDAP failed: [_1].' => 'Echec de Chargement MT::LDAP[_1]',
    'Removing [_1] failed: [_2]' => 'Suppression [_1] échouée: [_2]', # Translate - New (4)
    'System templates can not be deleted.' => 'Les modèles créés par le Système ne peuvent pas être supprimés.',
    'Unknown object type [_1]' => 'Objet de type [_1] inconnu',
    'Can\'t load file #[_1].' => 'Impossible de charger le fichier #[_1].', # Translate - New (5)
    'No such commenter [_1].' => 'Pas de d\'auteur de commentaires [_1].',
    'User \'[_1]\' trusted commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\' a accordé le statut Fiable à l\'auteur de commentaire \'[_2]\'.',
    'User \'[_1]\' banned commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\'  a banni l\'auteur de commentaire \'[_2]\'.',
    'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\'  a retiré le statu Banni à l\'auteur de commentaire \'[_2]\'.',
    'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\'  a retiré le statut Fiable à l\'auteur de commentaire \'[_2]\'.',
    'Need a status to update entries' => 'Statut nécessaire pour mettre à jour les notes',
    'Need entries to update status' => 'Notes nécessaires pour mettre à jour le statut',
    'One of the entries ([_1]) did not actually exist' => 'Une des notes ([_1]) n\'existait pas',
    'Entry \'[_1]\' (ID:[_2]) status changed from [_3] to [_4]' => 'Statut de la note \'[_1]\' (ID:[_2]) changé de [_3] en [_4]', # Translate - New (10)
    'You don\'t have permission to approve this comment.' => 'Vous n\'avez pas la permission d\'approuver ce commentaire.',
    'Comment on missing entry!' => 'Commentaire su une note maquante !',
    'Orphaned comment' => 'Commentaire orphelin',
    'Orphaned' => 'Orphelin',
    'Plugin Set: [_1]' => 'Eventail de Plugin : [_1]',
    '<strong>[_1]</strong> is &quot;[_2]&quot;' => '<strong>[_1]</strong> est &quot;[_2]&quot;', # Translate - New (8)
    'TrackBack' => 'TrackBack', # Translate - Previous (1)
    'TrackBack Activity Feed' => 'Flux d\'activité des TrackBacks ',
    'No Excerpt' => 'Pas d\'extrait',
    'No Title' => 'Pas de Titre',
    'Orphaned TrackBack' => 'TrackBack orphelin',
    'entry' => 'note',
    'category' => 'catégorie',
    'Tag' => 'Tag', # Translate - Previous (1)
    'User' => 'Utilisateur',
    'Entry Status' => 'Statut Note', # Translate - New (2)
    '[_1] Feed' => 'Flux [_1]', # Translate - New (3)
    '(user deleted - ID:[_1])' => '(utilisateur supprimé - ID:[_1])', # Translate - New (5)
    'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Date invalide \'[_1]\'; les dates doivent être au format AAAA-MM-JJ HH:MM:SS.',
    'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Date invalide \'[_1]\'; les dates de publication doivent être réelles.',
    'Saving entry \'[_1]\' failed: [_2]' => 'Echec \'[_1]\' lors de la sauvegarde de la Note : [_2]',
    'Removing placement failed: [_1]' => 'Echec lors de la suppression de l\'emplacement : [_1]',
    'Entry \'[_1]\' (ID:[_2]) edited and its status changed from [_3] to [_4] by user \'[_5]\'' => 'Note \'[_1]\' (ID:[_2]) modifiée et son statut changé de [_3] en [_4] par utilisateur \'[_5]\'', # Translate - New (16)
    'Entry \'[_1]\' (ID:[_2]) edited by user \'[_3]\'' => 'Note \'[_1]\' (ID:[_2]) modifiée par utilisateur \'[_3]\'', # Translate - New (8)
    'No such [_1].' => 'Pas de [_1].', # Translate - New (3)
    'Same Basename has already been used. You should use an unique basename.' => 'Ce nom de base est déjà utilisé. Vous devez choisir un nom de base unique.', # Translate - New (12)
    'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Votre blog n\'a pas été configuré avec un chemin de site et une URL. Vous ne pouvez pas publier de notes tant qu\'ils ne sont pas définis.', # Translate - New (20)
    'Saving [_1] failed: [_2]' => 'Enregistrement de [_1] a échoué: [_2]', # Translate - New (4)
    '[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) ajouté par utilisateur \'[_4]\'', # Translate - New (9)
    '[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_1] \'[_2]\' (ID:[_3]) modifié et son statut changé de [_4] en [_5] par utilisateur \'[_6]\'', # Translate - New (17)
    '[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) modifié par utilisateur \'[_4]\'', # Translate - New (9)
    'The category label \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Le nom de catégorie \'[_1]\' est en conflit avec une autre catégorie. Les catégories et les sous-catégories doivent avoir un nom unique.',
    'The [_1] must be given a name!' => 'Le [_1] doit avoir un nom!', # Translate - New (7)
    'Saving blog failed: [_1]' => 'Echec lors de la sauvegarde du blog : [_1]',
    'Invalid ID given for personal blog clone source ID.' => 'ID invalide fourni pour l\'ID de la source du clone du blog personnel.', # Translate - New (9)
    'If personal blog is set, the default site URL and root are required.' => 'Si le blog personnel est activé, l\'URL du site par défaut et sa racine sont obligatoires.', # Translate - New (13)
    'Feedback Settings' => 'Paramétrages des Feedbacks',
    'Parse error: [_1]' => 'Erreur de parsing : [_1]',
    'Build error: [_1]' => 'Erreur de construction : [_1]',
    'New [_1]' => 'Nouveau [_1]', # Translate - New (2)
    'index template \'[_1]\'' => 'modèle d\'index \'[_1]\'',
    '[_1] \'[_2]\'' => '[_1] \'[_2]\'', # Translate - New (3)
    'No permissions' => 'Aucun Droit',
    'Ping \'[_1]\' failed: [_2]' => 'Le Ping \'[_1]\' n\'a pas fonctionné : [_2]',
    'Create New Role' => 'Créer un Nouveau rôle',
    'Role name cannot be blank.' => 'Le role de peu pas être laissé vierge.',
    'Another role already exists by that name.' => 'Un autre role existe dejà avec ce nom.',
    'You cannot define a role without permissions.' => 'Vous ne pouvez pas définir un role sans autorisation.',
    'No entry ID provided' => 'Aucune ID de Note fournie',
    'No such entry \'[_1]\'' => 'Aucune Note du type \'[_1]\'',
    'No email address for user \'[_1]\'' => 'L\'utilisateur \'[_1]\' ne possède pas d\'adresse e-mail',
    'No valid recipients found for the entry notification.' => 'Aucun destinataire valide n\'a été trouvé pour la notification de cette note.',
    '[_1] Update: [_2]' => '[_1] Mise à jour : [_2]',
    'Error sending mail ([_1]); try another MailTransfer setting?' => 'Erreur lors de l\'envoi de l\'e-mail ([_1]); essayer un autre paramètre de MailTransfer ?',
    'Upload File' => 'Télécharger un fichier',
    'Can\'t load blog #[_1].' => 'Impossible de charger le blog #[_1].', # Translate - New (5)
    'Before you can upload a file, you need to publish your blog.' => 'Avant de pouvoir envoyer un fichier, vous devez publier votre blog.', # Translate - New (12)
    'Invalid extra path \'[_1]\'' => 'Chemin supplémentaire invalide \'[_1]\'',
    'Can\'t make path \'[_1]\': [_2]' => 'Impossible de créer le chemin \'[_1]\' : [_2]',
    'Invalid temp file name \'[_1]\'' => 'Nom de fichier temporaire invalide \'[_1]\'',
    'Error opening \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture de \'[_1]\' : [_2]',
    'Error deleting \'[_1]\': [_2]' => 'Erreur lors de la suppression de \'[_1]\' : [_2]',
    'File with name \'[_1]\' already exists. (Install ' => 'Le fichier portant le nom \'[_1]\' existe déjà. (Installez ',
    'Error creating temporary file; please check your TempDir ' => 'Erreur lors de la création du fichier temporaire; veuillez vérifier votre répertoire temporaire (Temp) ',
    'unassigned' => 'non assigné',
    'File with name \'[_1]\' already exists; Tried to write ' => 'Le fichier portant le nom \'[_1]\' existe déjà; Essayez d\'écrire ',
    'Error writing upload to \'[_1]\': [_2]' => 'Erreur d\'écriture lors de l\'envoi de \'[_1]\' : [_2]',
    'Perl module Image::Size is required to determine ' => 'le Module Perl Image::Size est requis pour déterminer ',
    'Search & Replace' => 'Rechercher et Remplacer',
    'Logs' => 'Journaux', # Translate - New (1)
    'Invalid date(s) specified for date range.' => 'Date(s) incorrecte(s) pour la sélection de calendrier.',
    'Error in search expression: [_1]' => 'Erreur dans la recherche de l expression : [_1]',
    'Saving object failed: [_2]' => 'La sauvegarde des objets a échoué : [_2]',
    'You do not have export permissions' => 'Vous n\'avez pas les droits d\'exportation',
    'You do not have permission to create users' => 'Vous n\'avez pas la permission de créer des utilisateurs',
    'Importer type [_1] was not found.' => 'Type d\'importeur [_1] non trouvé.', # Translate - New (6)
    'Saving map failed: [_1]' => 'Echec lors du rattachement: [_1]',
    'Add a [_1]' => 'Ajouter un [_1]', # Translate - New (3)
    'No label' => 'Pas d étiquette',
    'Category name cannot be blank.' => 'Vous devez nommer votre catégorie.',
    'Populating blog with default templates failed: [_1]' => 'L\'activation sur le blog des modèles par défaut a échoué : [_1]',
    'Setting up mappings failed: [_1]' => 'La mise en oeuvre des mappings a échoué : [_1]',
    'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Erreur: Movable Type ne peut pas écrire dans le répertoire de cache de modèles. Merci de vérifier les permissions du répertoire <code>[_1]</code> situé dans le répertoire du blog.', # Translate - New (25)
    'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Erreur: Movable Type n\'a pas pu créer un répertoire pour cacher vos modèles dynamiques. Vous devez créer un répertoire nommé <code>[_1]</code> dans le répertoire de votre blog.', # Translate - New (28)
    'That action ([_1]) is apparently not implemented!' => 'Cette action ([_1]) n\'est visiblement pas implémentée!',
    'That action ([_1]) is apparently not implemented?' => 'Cette action ([_1]) n\'est visiblement pas implémentée?', # Translate - New (7)
    'Error saving entry: [_1]' => 'Erreur d\'enregistrement de la note: [_1]',
    'Select Blog' => 'Sélectionner Blog', # Translate - New (2)
    'Selected Blog' => 'Blog sélectionné', # Translate - New (2)
    'Type a blog name to filter the choices below.' => 'Saisir un nom de blog pour filtrer les résultats ci-dessous.', # Translate - New (9)
    'Blog Name' => 'Nom du Blog',
    'Select a System Administrator' => 'Sélectionner un Administrateur Système', # Translate - New (4)
    'Selected System Administrator' => 'Administrateur Système sélectionné', # Translate - New (3)
    'Type a user name to filter the choices below.' => 'Saisir un nom d\'utilisateur pour filtrer les résultats ci-dessous.', # Translate - New (9)
    'System Administrator' => 'Administrateur Système',
    'Error saving file: [_1]' => 'Erreur en sauvegardant le fichier: [_1]', # Translate - New (4)
    'represents a user who will be created afterwards' => 'représente un utilisateur qui sera créé ensuite', # Translate - New (8)
    'Select Blogs' => 'Sélectionner des Blogs', # Translate - New (2)
    'Blogs Selected' => 'Blogs Selectionnés', # Translate - New (2)
    'Group Name' => 'Nom du Groupe',
    'Select Roles' => 'Selectionnez des Roles',
    'Role Name' => 'Nom du rôle',
    'Roles Selected' => 'Roles Selectionnés',
    'Create an Association' => 'Créer une Association',
    'Backup & Restore' => 'Sauvegarder & Restorer', # Translate - New (2)
    'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.' => 'Le répertoire temporaire doit être autorisé en écriture pour que la sauvegarde puisse fonctionner. Merci de vérifier la directive de configuration TempDir.', # Translate - New (16)
    'Temporary directory needs to be writable for restore to work correctly.  Please check TempDir configuration directive.' => 'Le répertoire temporaire doit être autorisé en écriture pour que la restauration puisse fonctionner. Merci de vérifier la directive de configuration TempDir.', # Translate - New (16)
    'Blog(s) (ID:[_1]) was/were successfully backed up by user \'[_2]\'' => 'Blog(s) (ID:[_1]) a/ont été sauvegardé(s) avec succès par l\'utilisateur \'[_2]\'', # Translate - New (12)
    'Movable Type system was successfully backed up by user \'[_1]\'' => 'Movable Type a été sauvegardé avec succès par l\'utilisateur \'[_1]\'', # Translate - New (10)
    'You must select what you want to backup.' => 'Vous devez sélectionner ce que vous souhaitez sauvegarder.', # Translate - New (8)
    '[_1] is not a number.' => '[_1] n\'est pas un nombre.', # Translate - New (6)
    'Choose blogs to backup.' => 'Choisissez les blogs à sauvegarder.', # Translate - New (4)
    'Archive::Tar is required to archive in tar.gz format.' => 'Archive::Tar est obligatoire pour sauvegarder dans le format tar.gz .', # Translate - New (10)
    'IO::Compress::Gzip is required to archive in tar.gz format.' => 'IO::Compress::Gzip est obligatoire pour sauvegarder dans le format tar.gz .', # Translate - New (11)
    'Archive::Zip is required to archive in zip format.' => 'Archive::Zip est obligatoire pour sauvegarder dans le format zip.', # Translate - New (9)
    'Specified file was not found.' => 'Le fichier spécifié n\'a pas été trouvé.', # Translate - New (5)
    '[_1] successfully downloaded backup file ([_2])' => '[_1] a téléchargé avec succès le fichier de sauvegarde ([_2])', # Translate - New (7)
    'Restore' => 'Restaurer', # Translate - New (1)
    'Required modules (Archive::Tar and/or IO::Uncompress::Gunzip) are missing.' => 'Modules obligatoires (Archive::Tar et/ou IO::Uncompress::Gunzip) introuvables.', # Translate - New (11)
    'Uploaded file was invalid: [_1]' => 'Le fichier envoyé est invalide: [_1]', # Translate - New (5)
    'Required module (Archive::Zip) is missing.' => 'Module obligatoire (Archive::Zip) introuvable.', # Translate - New (6)
    'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Merci d\'utiliser xml, tar.gz, zip, ou manifest comme extension de fichier.', # Translate - New (12)
    'Some [_1] were not restored because their parent objects were not restored.' => 'Certains [_1] n\'ont pas été restaurés car leurs objets parents n\'ont pas été restaurés.', # Translate - New (12)
    'Successfully restored objects to Movable Type system by user \'[_1]\'' => 'Restauration avec succès des objets dans Movable Type par utilisateur \'[_1]\'', # Translate - New (10)
    '[_1] is not a directory.' => '[_1] n\'est pas un répertoire.', # Translate - New (6)
    'Error occured during restore process.' => 'Une erreur s\'est produite pendant la procédure de restauration.', # Translate - New (5)
    'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ', # Translate - New (3)
    'Some of files could not be restored.' => 'Certains fichiers n\'ont pu être restaurés.', # Translate - New (7)
    'Uploaded file was not a valid Movable Type backup manifest file.' => 'Le fichier envoyé n\'était pas un fichier de sauvegarde Manifest Movable Type valide.', # Translate - New (11)
    'Please upload [_1] in this page.' => 'Merci d\'envoyer [_1] dans cette page.', # Translate - New (6)
    'File was not uploaded.' => 'Le fichier n\'a pas été envoyé.', # Translate - New (4)
    'Restoring a file failed: ' => 'La restauration d\'un fichier a échoué: ', # Translate - New (4)
    'Some objects were not restored because their parent objects were not restored.' => 'Certains objets n\'ont pas été restaurés car leurs objets parents n\'ont pas été restaurés.', # Translate - New (12)
    'Some of the files were not restored correctly.' => 'Certains fichiers n\'ont pas été restaurés correctement.', # Translate - New (8)
    '[_1] has canceled the multiple files restore operation prematurely.' => '[_1] a annulé prématurément l\'opération de restauration de plusieurs fichiers.', # Translate - New (10)
    'Changing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Changement du Chemin du Site pour le blog \'[_1]\' (ID:[_2])...', # Translate - New (9)
    'Removing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Suppression du Chemin du Site pour le blog \'[_1]\' (ID:[_2])...', # Translate - New (9)
    '\nChanging Archive Path for the blog \'[_1]\' (ID:[_2])...' => '\nChangement du Chemin d\'Archive pour le blog \'[_1]\' (ID:[_2])...', # Translate - New (10)
    '\nRemoving Archive Path for the blog \'[_1]\' (ID:[_2])...' => '\nSuppression du Chemin d\'Archive pour le blog \'[_1]\' (ID:[_2])...', # Translate - New (10)
    'Some of the actual files for assets could not be restored.' => 'Certains des fichiers des éléments n\'ont pu être restaurés.', # Translate - New (11)
    'Parent comment id was not specified.' => 'id du commentaire parent non spécifié.', # Translate - New (6)
    'Parent comment was not found.' => 'Commentaire parent non trouvé.', # Translate - New (5)
    'You can\'t reply to unapproved comment.' => 'Vous ne pouvez répondre à un commentaire non approuvé.', # Translate - New (7)
    'entries' => 'notes',

    ## ./lib/MT/App/Comments.pm
    'Error assigning commenting rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable commenting role was found.' => 'Erreur en assignant les droits de commenter à l\'utilisateur \'[_1] (ID: [_2])\' pour le weblog \'[_3] (ID: [_4])\'. Aucun rôle de commentaire adéquat n\'a été trouvé.', # Translate - New (20)
    'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Tentative d\'identification échouée pour le commentateur [_1] sur le blog [_2](ID: [_3]) qui n\'autorise pas l\'authentification native de Movable Type.', # Translate - New (19)
    'Login failed: permission denied for user \'[_1]\'' => 'Identification échouée: permission interdite pour l\'utilisateur \'[_1]\'', # Translate - New (7)
    'Login failed: password was wrong for user \'[_1]\'' => 'Identification échouée: mot de passe incorrect pour l\'utilisateur \'[_1]\'', # Translate - New (8)
    'Signing up is not allowed.' => 'Enregistrement non autorisé.', # Translate - New (5)
    'Passwords do not match.' => 'Les mots de passe ne sont pas conformes.',
    'User requires username.' => 'L\'utilisateur doit avoir un nom.', # Translate - New (3)
    'User requires display name.' => 'L\'utilisateur doit avoir un nom public.', # Translate - New (4)
    'User requires password.' => 'L\'utilisateur doit avoir un mot de passe.', # Translate - New (3)
    'User requires password recovery word/phrase.' => 'L\'utilisateur doit avoir un mot/une phrase pour récupérer le mot de passe.', # Translate - New (6)
    'Email Address is invalid.' => 'Adresse Email invalide.', # Translate - New (4)
    'Email Address is required for password recovery.' => 'Adresse Email obligatoire pour récupérer le mot de passe.', # Translate - New (7)
    'URL is invalid.' => 'URL invalide.', # Translate - New (3)
    'Text entered was wrong.  Try again.' => 'Le texte saisi est erroné.  Essayez à nouveau', # Translate - New (6)
    'Something wrong happened when trying to process signup: [_1]' => 'Un problème s\'est produit en essayant de soumettre l\'inscription: [_1]', # Translate - New (9)
    'Movable Type Account Confirmation' => 'Confirmation de compte Movable Type', # Translate - New (4)
    'System Email Address is not configured.' => 'Adresse Email du Système non configurée.', # Translate - New (6)
    'Commenter \'[_1]\' (ID:[_2]) has been successfully registered.' => 'Commentateur \'[_1]\' (ID:[_2]) a été enregistré avec succès.', # Translate - New (8)
    'Thanks for the confirmation.  Please sign in to comment.' => 'Merci pour la confirmation. Merci de vous identifier pour commenter.', # Translate - New (9)
    '[_1] registered to the blog \'[_2]\'' => '[_1] s\'est enregistré pour le blog \'[_2]\'', # Translate - New (7)
    'No id' => 'pas d\'id',
    'No such comment' => 'Pas de commentaire de la sorte',
    'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'l\'IP [_1] a été bannie car elle emet plus de 8 commentaires en  [_2] seconds.',
    'IP Banned Due to Excessive Comments' => 'IP bannie pour cause de commentaires excessifs',
    'No such entry \'[_1]\'.' => 'Aucune Note \'[_1]\'.',
    'You are not allowed to add comments.' => 'Vous n\'êtes pas autorisé à poster des commentaires.', # Translate - New (7)
    'Comments are not allowed on this entry.' => 'Les commentaires ne sont pas autorisés sur cette Note.',
    'Comment text is required.' => 'Le texte de commentaire est requis.',
    'An error occurred: [_1]' => 'Une erreur s\'est produite: [_1]',
    'Registration is required.' => 'L\'inscription est requise.',
    'Name and email address are required.' => 'Le nom et l\'e-mail sont requis.',
    'Invalid email address \'[_1]\'' => 'Adresse e-mail invalide \'[_1]\'',
    'Invalid URL \'[_1]\'' => 'URL invalide \'[_1]\'',
    'Comment save failed with [_1]' => 'La sauvegarde du commentaire a échoué [_1]',
    'Comment on "[_1]" by [_2].' => 'Commentaire sur "[_1]" par [_2].',
    'Commenter save failed with [_1]' => 'L\'enregistrement de l\'auteur de commentaires a échoué [_1]',
    'Rebuild failed: [_1]' => 'Echec lors de la recontruction: [_1]',
    'You must define a Comment Pending template.' => 'Vous devez définir un modèle pour les commentaires en attente de validation.',
    'Failed comment attempt by pending registrant \'[_1]\'' => 'Tentative de commentaire échouée par utilisateur  \'[_1]\' en cours d\'inscription', # Translate - New (7)
    'Registered User' => 'Utilisateur enregistré', # Translate - New (2)
    'New Comment Added to \'[_1]\'' => 'Nouveau commentaire ajouté à \'[_1]\'', # Translate - New (5)
    'The sign-in attempt was not successful; please try again.' => 'La tentative d\'enregistrement a échoué; veuillez essayer de nouveau.',
    'The sign-in validation was not successful. Please make sure your weblog is properly configured and try again.' => 'La procédure d\'enrgistrement a échoué. Veuillez vérifier que votre weblog est configuré correctement et essayez de nouveau.',
    'No such entry ID \'[_1]\'' => 'Aucune ID pour la Note \'[_1]\'',
    'You must define an Individual template in order to ' => 'Vous devez définir un modèle individuel pour ',
    'You must define a Comment Listing template in order to ' => 'Vous devez définir un modèle de liste de commentaires pour ',
    'No entry was specified; perhaps there is a template problem?' => 'Aucune Note n\'a été spécifiée; peut-être y a-t-il un problème de modèle?',
    'Somehow, the entry you tried to comment on does not exist' => 'Il semble que la Note que vous souhaitez commenter n\'existe pas',
    'You must define a Comment Error template.' => 'Vous devez définir un modèle d\'erreur de commentaire.',
    'You must define a Comment Preview template.' => 'Vous devez définir un modèle de prévisualisation de commentaire.',
    'Invalid commenter ID' => 'ID de commentaire invalide', # Translate - New (3)
    'Permission denied' => 'Autorisation refusée',
    'All required fields must have valid values.' => 'Tous les champs obligatoires doivent avoir des valeurs valides.', # Translate - New (7)
    'Commenter profile has successfully been updated.' => 'Le profil du commentateur a été modifié avec succès.', # Translate - New (6)
    'Commenter profile could not be updated: [_1]' => 'Le profil du commentateur n\'a pu être modifié: [_1]', # Translate - New (7)
    'You can\'t reply to unpublished comment.' => 'Vous ne pouvez pas répondre à un commentaire non publié.', # Translate - New (7)
    'Your session has been ended.  Cancel the dialog and login again.' => 'Votre session a expiré. Annulez le dialogue et identifiez-vous à nouveau.', # Translate - New (11)
    'Comment Detail' => 'Détail du Commentaire', # Translate - New (2)

    ## ./lib/MT/App/NotifyList.pm
    'Please enter a valid email address.' => 'Veuillez entrer une adresse e-mail valide.',
    'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Il manque un paramètre requis : blog_id. Veuillez consulter le manuel d\'utilisateur pour configurer les notifications.',
    'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Vous avez fourni un paramètre de redirection non valide. Le propriétaire du weblog doit spécifier le chemin qui correspond au nom de domaine du weblog.',
    'The email address \'[_1]\' is already in the notification list for this weblog.' => 'L\'adresse e-mail \'[_1]\' fait déjà parti de la liste de notification pour ce weblog.',
    'Please verify your email to subscribe' => 'Merci de vérifier votre email pour souscrire',
    'The address [_1] was not subscribed.' => 'L\'adresse [_1] n\'a pas été souscrite.',
    'The address [_1] has been unsubscribed.' => 'L\'adresse [_1] a été supprimée.',

    ## ./lib/MT/App/Search.pm
    'You are currently performing a search. Please wait ' => 'Une recherche est actuellement en cours. Merci de patienter ',
    'Search failed. Invalid pattern given: [_1]' => 'Echec de la recherche. Comportement non valide : [_1]',
    'Search failed: [_1]' => 'Echec lors de la recherche : [_1]',
    'No alternate template is specified for the Template \'[_1]\'' => 'Pas d\'modèle alternatif spécifié pour l\'modèle \'[_1]\'',
    'Opening local file \'[_1]\' failed: [_2]' => 'L\'ouverture du fichier local \'[_1]\' a échoué: [_2]',
    'Building results failed: [_1]' => 'Echec lors de la construction des résultats: [_1]',
    'Search: query for \'[_1]\'' => 'Recherche : requête pour \'[_1]\'',
    'Search: new comment search' => 'Recherche : recherche de nouveaux commentaires',

    ## ./lib/MT/App/Trackback.pm
    'You must define a Ping template in order to display pings.' => 'Vous devez définir un modèle d\'affichage Ping pour les afficher.',
    'Trackback pings must use HTTP POST' => 'Les Pings Trackback doivent utiliser HTTP POST',
    'Need a TrackBack ID (tb_id).' => 'Un TrackBack ID est requis (tb_id).',
    'Invalid TrackBack ID \'[_1]\'' => 'TrackBack ID invalide \'[_1]\'',
    'You are not allowed to send TrackBack pings.' => 'You n\'êtes pas autorisé à envoyer des TrackBack pings.',
    'You are pinging trackbacks too quickly. Please try again later.' => 'Vous pinguez les trackbacks trop rapidement. Merci d\'essayer plus tard.',
    'Need a Source URL (url).' => 'Une source URL est requise (url).',
    'This TrackBack item is disabled.' => 'Cet élément TrackBack est désactivé.',
    'This TrackBack item is protected by a passphrase.' => 'Cet élément de TrackBack est protégé par un mot de passe.',
    'TrackBack on "[_1]" from "[_2]".' => 'TrackBack sur "[_1]" provenant de "[_2]".',
    'TrackBack on category \'[_1]\' (ID:[_2]).' => 'TrackBack sur la catégorie \'[_1]\' (ID:[_2]).',
    'Can\'t create RSS feed \'[_1]\': ' => 'Impossible de créer le flux RSS \'[_1]\': ',
    'New TrackBack Ping to Entry [_1] ([_2])' => 'Nouveau TrackBack Ping pour la Note [_1] ([_2])',
    'New TrackBack Ping to Category [_1] ([_2])' => 'Nouveau TrackBack Ping pour la Catégorie [_1] ([_2])',

    ## ./lib/MT/App/Upgrader.pm
    'The initial account name is required.' => 'Le nom initial du compte est nécessaire.',
    'Failed to authenticate using given credentials: [_1].' => 'A échoué à s\'authentifier en utilisant les informations communiquées [_1].',
    'You failed to validate your password.' => 'Echec de la validation du mot de passe.',
    'You failed to supply a password.' => 'Vous n\'avez pas donné de mot de passe.',
    'The e-mail address is required.' => 'L\'adresse email est requise.',
    'Password recovery word/phrase is required.' => 'La phrase de récupération de mot de passe est requise.',
    'Invalid session.' => 'Session invalide.',
    'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Pas d\'autorisation. Contactez votre administrateur système Movable Type pour changer votre statut.',

    ## ./lib/MT/App/Viewer.pm
    'This is an experimental feature; turn off SafeMode (in mt.cfg) in order to use it.' => 'C\'est une fonctionnalité encore à l\'essai; Désactivez le  SafeMode (dans mt.cfg) pour pouvoir l\'utiliser.',
    'Not allowed to view blog [_1]' => 'Non autorisé à voir ce blog [_1]',
    'Loading blog with ID [_1] failed' => 'Echec du chargement du blog avec ID [_1] ',
    'Can\'t load \'[_1]\' template.' => 'Impossible de charger l\'modèle \'[_1]\' .',
    'Building template failed: [_1]' => 'Echec de la construction de l\'modèle: [_1]',
    'Invalid date spec' => 'Spec de date incorrects',
    'Can\'t load template [_1]' => 'Impossible de charge l\'modèle [_1]',
    'Building archive failed: [_1]' => 'Echec de la construction des archives: [_1]',
    'Invalid entry ID [_1]' => ' ID [_1] de la note incorrect',
    'Entry [_1] is not published' => 'La note [_1] n\'est pas publiée',
    'Invalid category ID \'[_1]\'' => 'ID catégorie incorrect \'[_1]\'',

    ## ./lib/MT/App/Wizard.pm
    'The [_1] database driver is required to use [_2].' => 'Le driver de base de données [_1] est obligatoire pour utiliser [_2].', # Translate - New (9)
    'The [_1] driver is required to use [_2].' => 'Le driver [_1] est obligatoire pour utiliser [_2].', # Translate - New (8)
    'An error occurred while attempting to connect to the database.  Check the settings and try again.' => 'Une erreur s\'est produite en essayant de se connecter à la base de données. Vérifiez les paramètres et essayez à nouveau.', # Translate - New (16)
    'SMTP Server' => 'Serveur SMTP',
    'Sendmail' => 'Sendmail', # Translate - Previous (1)
    'Test email from Movable Type Configuration Wizard' => 'Test email à partir de l\'Assistant de Configuration de Movable Type',
    'This is the test email sent by your new installation of Movable Type.' => 'Ceci est un email de test envoyé par votre nouvelle installation Movable Type.',

    ## ./lib/MT/Asset/Image.pm
    'Image' => 'Image', # Translate - New (1)
    'Images' => 'Images', # Translate - New (1)
    'Actual Dimensions' => 'Dimensions réelles', # Translate - New (2)
    '[_1] wide, [_2] high' => '[_1] de large, [_2] de haut', # Translate - New (5)
    'Error scaling image: [_1]' => 'Erreur de redimentionnement de l\'image: [_1]', # Translate - New (4)
    'Error creating thumbnail file: [_1]' => 'Erreur lors de la création de la vignette: [_1]', # Translate - New (5)
    'Can\'t load image #[_1]' => 'Impossible de charger l\'image #[_1]', # Translate - New (5)
    'View image' => 'Voir l\'image',
    'Permission denied setting image defaults for blog #[_1]' => 'Permission interdite de configurer les réglages par défaut des images pour le blog #[_1]', # Translate - New (8)
    'Thumbnail failed: [_1]' => 'Echec de a vignette: [_1]',
    'Invalid basename \'[_1]\'' => 'Nom de base invalide \'[_1]\'',
    'Error writing to \'[_1]\': [_2]' => 'Erreur \'[_1]\' lors de l\'écriture de : [_2]',

    ## ./lib/MT/Auth/BasicAuth.pm

    ## ./lib/MT/Auth/LiveJournal.pm

    ## ./lib/MT/Auth/MT.pm
    'Failed to verify current password.' => 'Erreur lors de la vérification du mot de passe.',
    'Password hint is required.' => 'L\'indice de mot de passe est requis.',

    ## ./lib/MT/Auth/OpenID.pm
    'Could not discover claimed identity: [_1]' => 'Impossible de découvrir l\'identité déclarée: [_1]', # Translate - New (6)

    ## ./lib/MT/Auth/TypeKey.pm
    'Sign in requires a secure signature.' => 'L\'identification nécessite une signature sécurisée.', # Translate - New (6)
    'The sign-in validation failed.' => 'La validation de l\'enregistrement a échoué.',
    'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Les auteurs de commentaires de ce weblog doivent donner une adresse email. Si vous souhaitez le faire il faut vous enregistrer à nouveau et donner l\'autorisation au système d\'identification de récupérer votre adresse email',
    'This weblog requires commenters to pass an email address' => 'Les auteurs de commentaires de ce weblog doivent donner une adresse email',
    'Couldn\'t get public key from url provided' => 'Impossible d\'avoir une clef publique',
    'No public key could be found to validate registration.' => 'Aucune clé publique n\'a été trouvée pour valider l\'inscription.',
    'TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'La vérification de la signature Typekey retournée [_1] dans [_2] secondes en vérifiant [_3] avec [_4]',
    'The TypeKey signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'La signature Typekey est périmée depuis ([_1] secondes). Vérifier que votre serveur a une heure correcte',

    ## ./lib/MT/Auth/Vox.pm

    ## ./lib/MT/BackupRestore/BackupFileHandler.pm
    'Uploaded file was backed up from Movable Type with the newer schema version ([_1]) than the one in this system ([_2]).  It is not safe to restore the file to this version of Movable Type.' => 'Le fichier envoyé a été sauvegardé à partir de Movable Type avec une version plus récente du schéma ([_1]) que celle de ce système ([_2]).  Il n\'est pas recommandé de restaurer ce fichier dans cette version de Movable Type.', # Translate - New (35)
    '[_1] is not a subject to be restored by Movable Type.' => '[_1] n\'est pas un sujet qui peut être restauré par Movable Type.', # Translate - New (12)
    '[_1] records restored.' => '[_1] enregistrements restorés.', # Translate - New (4)
    'Restoring [_1] records:' => 'Restauration de [_1] enregistrements:', # Translate - New (3)
    'User with the same name \'[_1]\' found (ID:[_2]).  Restore replaced this user with the data backed up.' => 'Utilisateur avec le même nom \'[_1]\' trouvé (ID:[_2]). La restauration a remplacé cet utilisateur avec les données sauvegardées.', # Translate - New (18)
    'Tag \'[_1]\' exists in the system.\n' => 'Tag \'[_1]\' existe déjà dans le système.\n', # Translate - New (7)
    'Trackback for entry (ID: [_1]) already exists in the system.\n' => 'Trackback pour la note (ID: [_1]) existe déjà dans le système.\n', # Translate - New (11)
    'Trackback for category (ID: [_1]) already exists in the system.\n' => 'Trackback pour la categorie (ID: [_1]) existe déjà dans le système.\n', # Translate - New (11)
    '[_1] records restored...' => '[_1] enregistrements restorés...', # Translate - New (4)

    ## ./lib/MT/BackupRestore/ManifestFileHandler.pm

    ## ./lib/MT/Compat/v3.pm
    'uses: [_1], should use: [_2]' => 'utilise: [_1], devrait utiliser: [_2]', # Translate - New (5)
    'uses [_1]' => 'utilise [_1]', # Translate - New (2)
    'No executable code' => 'Pas de code exécutable',
    'Rebuild-option name must not contain special characters' => 'L option de reconstruction de nom ne doit pas contenir de caractères spéciaux',

    ## ./lib/MT/FileMgr/DAV.pm
    'DAV connection failed: [_1]' => 'La connection DAV a échoué : [_1]',
    'DAV open failed: [_1]' => 'Ouverture DAV a échouée : [_1]',
    'DAV get failed: [_1]' => 'Obtention DAV a échouée : [_1]',
    'DAV put failed: [_1]' => 'Mettre DAV a échouée : [_1]',
    'Deleting \'[_1]\' failed: [_2]' => 'Effacement \'[_1]\' echec : [_2]',
    'Creating path \'[_1]\' failed: [_2]' => 'Création chemin \'[_1]\' a échouée : [_2]',
    'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Renommer \'[_1]\' vers \'[_2]\' a échoué : [_3]',

    ## ./lib/MT/FileMgr/FTP.pm

    ## ./lib/MT/FileMgr/Local.pm

    ## ./lib/MT/FileMgr/SFTP.pm
    'SFTP connection failed: [_1]' => 'La connection SFTP a échoué : [_1]',
    'SFTP get failed: [_1]' => 'Obtention SFTP a échoué : [_1]',
    'SFTP put failed: [_1]' => 'Mettre SFTP a échoué : [_1]',

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
    'from rule' => 'de la règle',
    'from test' => 'du test',

    ## ./lib/MT/Plugin/L10N.pm

    ## ./lib/MT/Template/Context.pm
    'The attribute exclude_blogs cannot take \'all\' for a value.' => 'L\'attribut exclude_blogs ne peut pas prendre \'all\' comme valeur.',

    ## ./lib/MT/Template/ContextHandlers.pm
    'Recursion attempt on [_1]: [_2]' => 'Tentative de récursion sur [_1]: [_2]', # Translate - New (5)
    'Can\'t find included template [_1] \'[_2]\'' => 'Impossible de trouver le modèle inclus [_1] \'[_2]\'', # Translate - New (7)
    'Can\'t find blog for id \'[_1]' => 'Impossible de trouver un blog pour le ID\'[_1]',
    'Can\'t find included file \'[_1]\'' => 'Impossible de trouver le fichier inclus \'[_1]\'',
    'Error opening included file \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture du fichier inclus \'[_1]\' : [_2]',
    'Recursion attempt on file: [_1]' => 'Tentative de récursion sur le fichier: [_1]', # Translate - New (5)
    'Unspecified archive template' => 'Modèle d\'archive non spécifié',
    'Error in file template: [_1]' => 'Erreur dans fichier modèle : [_1]',
    'Can\'t load template' => 'Impossible de charger le modèle', # Translate - New (4)
    'Can\'t find template \'[_1]\'' => 'Impossible de trouver le modèle \'[_1]\'',
    'Can\'t find entry \'[_1]\'' => 'Impossible de trouver la note \'[_1]\'',
    '[_1] [_2]' => '[_1] [_2]', # Translate - Previous (3)
    'You used a [_1] tag without any arguments.' => 'Vous utilisez un [_1] tag sans aucun argument.',
    'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" doit être utilisé en combinaison avec le namespace.', # Translate - New (10)
    'You have an error in your \'[_2]\' attribute: [_1]' => 'Vous avez une erreur dans votre attribut \'[_2]\' : [_1]', # Translate - New (9)
    'You have an error in your \'tag\' attribute: [_1]' => 'Vous avez une erreur dans votre attribut \'tag\': [_1]',
    'No such user \'[_1]\'' => 'L\'utilisateur \'[_1]\' n\'existe pas',
    'You used an \'[_1]\' tag outside of the context of an entry; ' => 'Vous utilisez un tag \'[_1]\' en dehors du contexte d\'une note; ',
    'You used <$MTEntryFlag$> without a flag.' => 'Vous utilisez <$MTEntryFlag$> sans drapeau.',
    'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Vous avez utilisé un [_1] tag pour créer un lien vers \'[_2]\' archives, mais le type d\'archive n\'est pas publié.',
    'Could not create atom id for entry [_1]' => 'Impossible de créer un ID Atom pour cette note [_1]',
    'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'Authentification TypeKey non activée dans ce blog.  MTRemoteSignInLink ne peut être utilisé.', # Translate - New (13)
    'To enable comment registration, you need to add a TypeKey token in your weblog config or user profile.' => 'Pour activer l\'authentification des commentaires, vous devez ajouter une clé TypeKey dans la config de votre weblog ou dans le profil de l\'utilisateur.',
    '(You may use HTML tags for style)' => '(Vous dpouvez utiliser des tags HTML pour le style)',
    'You used an [_1] tag without a date context set up.' => 'Vous utilisez un tag [_1] sans avoir configuré la date.',
    'You used an \'[_1]\' tag outside of the context of a comment; ' => 'Vous utilisez un tag \'[_1]\' en dehors du contexte d\'un commentaire; ',
    'You used an [_1] without a date context set up.' => 'Vous utilisez un [_1] sans avoir configurer la date.',
    '[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] est valide uniquement avec des archives quotidiennes, hebdomadaires ou mensuelles.',
    'Group iterator failed.' => 'L\'itérateur de groupe a échoué',
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly ' => 'Vous utilisez un tag [_1] en dehors d\'une utilisation quotidienne, hebdomadaire ou mensuelle ',
    'Could not determine entry' => 'La note ne peut pas être déterminée',
    'Invalid month format: must be YYYYMM' => 'Le format du mois est invalide : Il doit être de la forme AAAAMM',
    'No such category \'[_1]\'' => 'La catégorie \'[_1]\' n\'existe pas',
    '<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> doit être utilisé dans le contexte d\'une catégorie, ou avec l\'attribut \'Catégorie\' dans le tag.',
    'You failed to specify the label attribute for the [_1] tag.' => 'Vous n\'avez pas spécifié l\'étiquette du tag [_1].',
    'You used an \'[_1]\' tag outside of the context of ' => 'Vous avez utilisé le tag \'[_1]\' en dehors du contexte de ',
    'MTSubCatsRecurse used outside of MTSubCategories' => 'MTSubCatsRecurse est utilisé en dehors d\'une balise MTSubCategories',
    'MTSubFolderRecurse used outside of MTSubFolders' => 'MTSubFolderRecurse utilisé en dehors de MTSubFolders', # Translate - New (5)
    'MT[_1] must be used in a [_2] context' => 'MT[_1] doit être utilisé dans le contexte [_2]', # Translate - New (9)
    'Cannot find package [_1]: [_2]' => 'Impossible de trouver le package [_1]: [_2]',
    'Error sorting [_2]: [_1]' => 'Erreur en classant [_2]: [_1]', # Translate - New (4)
    'You used an \'[_1]\' tag outside of the context of an asset; ' => 'Vous avez utilisé une balise \'[_1]\' en dehors du contexte d\'un élément; ', # Translate - New (12)
    'You used an \'[_1]\' tag outside of the context of an page; ' => 'Vous avez utilisé une balise \'[_1]\' en dehors du contexte d\'une page; ', # Translate - New (12)
    'You used an [_1] without a author context set up.' => 'Vous avez utilisé un [_1] sans avoir configuré de contexte d\'auteur.', # Translate - New (10)
    'Can\'t load blog.' => 'Impossible de charger le blog.', # Translate - New (4)
    'Can\'t load user.' => 'Impossible de charger l\'utilisateur.', # Translate - New (4)

    ## ./lib/MT/Util/Captcha.pm
    'Captcha' => 'Captcha', # Translate - New (1)
    'Type the characters you see in the picture above.' => 'Saisissez les caractères que vous voyez dans l\'image ci-dessus.', # Translate - New (9)
    'You need to configure CaptchaSourceImagebase.' => 'Vous devez configurer CaptchaSourceImagebase.', # Translate - New (5)
    'Image creation failed.' => 'Création de l\'image échouée.', # Translate - New (3)
    'Image error: [_1]' => 'Erreur image : [_1]', # Translate - New (3)

    ## ./mt-static/mt.js
    'to delete' => 'effacer',
    'to remove' => 'retirer',
    'to enable' => 'activer',
    'to disable' => 'désactiver',
    'delete' => 'effacer',
    'remove' => 'retirer',
    'You did not select any [_1] to [_2].' => 'Vous n\'avez pas sélectionné de [_1] à [_2].',
    'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => 'Etes-vous certain de vouloir supprimer ce role. En faisant cela vous allez supprimer les autorisations de tous les utilisateurs et groupes associés à ce role.',
    'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => 'Etes vous certain de vouloir supprimer les roles [_1]?Avec cette actions vous allez supprimer les permissions associées à tous les utilisateurs et groupes liés à ce role.',
    'Are you sure you want to [_2] this [_1]?' => 'Etes-vous certain de vouloir [_2] : [_1]?',
    'Are you sure you want to [_3] the [_1] selected [_2]?' => 'Etes-vous sur de vouloir[_3] le [_1] selectionné [_2]?',
    'to ' => 'à ',
    'You did not select any [_1] to remove.' => 'Vous n\'avez sélectionné aucun [_1] à enlever.',
    'Are you sure you want to remove this [_1] from this group?' => 'Etes-vous certain de vouloir supprimer [_1] du groupe?',
    'Are you sure you want to remove the [_1] selected [_2] from this group?' => 'Etes-vous certain de vouloir supprimer [_1] [_2] de ce groupe?',
    'Are you sure you want to remove this [_1]?' => 'Etes-vous certain de vouloir supprimer cet/cette [_1]?',
    'Are you sure you want to remove the [_1] selected [_2]?' => 'Etes-vous certain de vouloir supprimer [_1] [_2]?',
    'enable' => 'activer',
    'disable' => 'desactiver',
    'You did not select any [_1] [_2].' => 'Vous n\'avez pas sélectionné de [_1] [_2].',
    'You can only act upon a minimum of [_1] [_2].' => 'Vous ne pouvez agir que sur un minimum de [_1] [_2].',
    'You can only act upon a maximum of [_1] [_2].' => 'Vous ne pouvez agir que sur un maximum de [_1] [_2].',
    'You must select an action.' => 'Vous devez sélectionner une action.',
    'to mark as junk' => 'pour marquer indésirable',
    'to remove "junk" status' => 'pour retirer le statut "indésirable"',
    'Enter email address:' => 'Saisissez l\'adresse email :',
    'Enter URL:' => 'Saisissez l\'URL :',
    'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\'?' => 'Le tag \'[_2]\' existe déjà. Etes-vous sûr de vouloir combiner \'[_1]\' avec \'[_2]\'?',
    'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all weblogs?' => 'Le tag \'[_2]\' existe déjà. Etes-vous sûr de vouloir combiner \'[_1]\' avec \'[_2]\'\' sur tous les weblogs?',
    'Showing: [_1] &ndash; [_2] of [_3]' => 'Afficher: [_1] &ndash; [_2] sur [_3]',
    'Showing: [_1] &ndash; [_2]' => 'Afficher: [_1] &ndash; [_2]',

    ## ./plugins/Cloner/cloner.pl
    'No weblog was selected to clone.' => 'Aucun weblog n\'a été sélectionné pour la duplication',
    'This action can only be run for a single weblog at a time.' => 'Cette action peut être effectuée uniquement blog par blog.',
    'Invalid blog_id' => 'Identifiant du blog non valide',

    ## ./plugins/ExtensibleArchives/AuthorArchive.pl
    'Author #[_1]' => 'Auteur #[_1]', # Translate - New (2)
    'AUTHOR_ADV' => 'AUTHOR_ADV', # Translate - New (2)
    'Author #[_1]: ' => 'Auteur #[_1]: ', # Translate - New (2)
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
    '\'[_1]\' is a required argument of [_2]' => '\'[_1]\' est un argument nécessaire de [_2]',
    'MT[_1] was not used in the proper context.' => 'Le [_1] MT n\'a pas été utilisé dans le bon contexte.',

    ## ./plugins/feeds-app-lite/lib/MT/App/FeedsWidget.pm

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Find.pm

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Lite.pm
    'An error occurred processing [_1]. ' => 'Une erreur s\'est produite lors de [_1]. ',

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Lite/CacheMgr.pm

    ## ./plugins/GoogleSearch/GoogleSearch.pl
    'You used [_1] without a query.' => 'Vous avez utilisé [_1] sans requête.',
    'You need a Google API key to use [_1]' => 'Vous avez besoin d\'une clef API Google API key pour utiliser[_1]',
    'You used a non-existent property from the result structure.' => 'Vous avez utilisé une propriété non existante dans le structure de réponse.',

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
    '* All Weblogs' => '* Tous les Weblogs',
    'Select to apply this trigger to all weblogs' => 'Sélectionner l\'application que ce déclencheur sur tous les weblogs',
    'MultiBlog' => 'MultiBlog', # Translate - Previous (1)
    'Create New Trigger' => 'Créer un nouveau déclencheur',
    'Weblog Name' => 'Nom du Weblog',
    'Search Weblogs' => 'Rechercher des Weblogs',
    'When this' => 'Quand cela',
    'saves an entry' => 'enregistre une note',
    'publishes an entry' => 'publie une note',
    'publishes a comment' => 'publie un commentaire',
    'publishes a ping' => 'publie un ping',
    'rebuild indexes.' => 'reconstruit les index.',
    'rebuild indexes and send pings.' => 'reconstruit les index et envoie des pings.',

    ## ./plugins/MultiBlog/lib/MultiBlog.pm
    'The include_blogs, exclude_blogs, blog_ids and blog_id attributes cannot be used together.' => 'Les attributs include_blogs, exclude_blogs, blog_ids and blog_id ne peuvent être utilisés ensemble.',
    'The attribute exclude_blogs cannot take "all" for a value.' => 'L\'attribut exclude_blogs ne peut prendre la valeur "tous".',
    'The value of the blog_id attribute must be a single blog ID.' => 'La valeur pour l\'attribut blog_id doit être une ID de blog unique.',
    'The value for the include_blogs/exclude_blogs attributes must be one or more blog IDs, separated by commas.' => 'La valeur pour les attributs include_blogs/exclude_blogs doit être une ou plusieurs ID de blogs, séparées par des virgules.',

    ## ./plugins/MultiBlog/lib/MultiBlog/L10N.pm

    ## ./plugins/MultiBlog/lib/MultiBlog/Tags.pm

    ## ./plugins/MultiBlog/lib/MultiBlog/L10N/en_us.pm

    ## ./plugins/MultiBlog/lib/MultiBlog/L10N/ja.pm

    ## ./plugins/MultiBlog/lib/MultiBlog/Tags/LocalBlog.pm

    ## ./plugins/MultiBlog/lib/MultiBlog/Tags/MultiBlog.pm
    'MTMultiBlog tags cannot be nested.' => 'Le tag  MTMultiBlog ne peut pas être intégré .',
    'Unknown "mode" attribute value: [_1]. ' => ' "mode"  inconnu  valeur attribut: [_1]. ',

    ## ./plugins/spamlookup/spamlookup.pl

    ## ./plugins/spamlookup/spamlookup_urls.pl

    ## ./plugins/spamlookup/spamlookup_words.pl

    ## ./plugins/spamlookup/lib/spamlookup.pm
    'Failed to resolve IP address for source URL [_1]' => 'Impossible de trouver l adresse IP de l URL source [_1]',
    'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Modération: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]',
    'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Le domaine IP ne correspond pas avec le ping IP pour l\'URL source [_1]; domain IP: [_2]; ping IP: [_3]',
    'No links are present in feedback' => 'Pas de lien dans ce retour lecteur',
    'Number of links exceed junk limit ([_1])' => 'Le nombre de liens dépasse la limite des indésirables ([_1])',
    'Number of links exceed moderation limit ([_1])' => 'Le nombre de liens dépasse la limite de modération([_1])',
    'Link was previously published (comment id [_1]).' => 'Le lien a par le passé été publié (Id commentaire [_1]).',
    'Link was previously published (TrackBack id [_1]).' => 'Le lien a par le passé été publié (TrackBack id [_1]).',
    'E-mail was previously published (comment id [_1]).' => 'L E-mail a par le passé été publié (commentaire id [_1]).',
    'Word Filter match on \'[_1]\': \'[_2]\'.' => 'Le filtre de mot s accorde \'[_1]\' : \'[_2]\'.',
    'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'La modération pour le filtre de mot s\'accorde \'[_1]\' : \'[_2]\'.',
    'domain \'[_1]\' found on service [_2]' => 'Le domaine \'[_1]\' a été touvé sur le service [_2]',
    '[_1] found on service [_2]' => '[_1] trouvé sur le service [_2]',

    ## ./plugins/spamlookup/lib/spamlookup/L10N.pm

    ## ./plugins/StyleCatcher/stylecatcher.pl
    'Unable to create the theme root directory. Error: [_1]' => 'Impossibilité de créer le thème racine du répertoire. Erreurr: [_1]',
    'Unable to write base-weblog.css to themeroot. File Manager gave the error: [_1]. Are you sure your theme root directory is web-server writable?' => 'Impossibilité d\écrire sur la racine du thème Base-weblog.css. Le gestionnaire de fichier renvoi l\'erreur: [_1]. Etes-vous sur que votre répertoire racine de thème sur le web-serveur est en accès écriture?',

    ## ./plugins/StyleCatcher/lib/StyleCatcher.pm
    'StyleCatcher must first be configured system-wide before it can be used.' => 'StyleCatcher doit être configuré avant de pouvoir être utilisé.',
    'Configure plugin' => 'Configurer le plugin',
    'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Impossible de créer le dossier [_1] - Vérifiez que votre dossier \'themes\' et en mode webserveur/écriture.',
    'Successfully applied new theme selection.' => 'Sélection de nouveau Thème appliquée avec succès.',

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/de.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/en_us.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/es.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/fr.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/ja.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/nl.pm

    ## ./plugins/TemplateRefresh/TemplateRefresh.pl
    'Error loading default templates.' => 'Erreur pendant le chargement des templates par défaut.',
    'Insufficient permissions to modify templates for weblog \'[_1]\'' => 'Niveau d\'autorisation insuffisant pour modifier le template du weblog \'[_1]\'',
    'Processing templates for weblog \'[_1]\'' => 'Traitement des templates pour le weblog \'[_1]\'',
    'Refreshing template \'[_1]\'.' => 'Actualisation du modèle \'[_1]\'.',
    'Error creating new template: ' => 'Erreur pendant la création du nouveau template: ',
    'Created template \'[_1]\'.' => 'A créé le template \'[_1]\'.',
    'Insufficient permissions for modifying templates for this weblog.' => 'Permissions insuffisantes pour modifier les templates de ce weblog.',
    'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Saut du modèle \'[_1]\' car c\'est un modèle personnalisé.',

    ## ./plugins/Textile/textile2.pl

    ## ./plugins/Textile/lib/Text/Textile.pm

    ## ./plugins/WidgetManager/WidgetManager.pl
    'Failed to find WidgetManager::Plugin::[_1]' => 'Impossible de trouver le  WidgetManager::Plugin::[_1]',

    ## ./plugins/WidgetManager/lib/WidgetManager/CMS.pm
    'Can\'t duplicate the existing \'[_1]\' Widget Manager. Please go back and enter a unique name.' => 'Impossible de dupliquer le gestionnaire de Widgets \'[_1]\' existant. Merci de revenir à la page précédente et de saisir un nom unique.',
    'Widget Manager' => 'Gestionnaire de Widget',
    'Moving [_1] to list of installed modules' => 'Déplacement de [_1] dans la liste des modules installés',
    'First Widget Manager' => 'Premier gestionnaire de widget',

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/Plugin.pm
    'No WidgetManager modules exist for blog \'[_1]\'.' => 'Aucun module WidgetManager n\'existe pour le blog \'[_1]\'.', # Translate - New (7)
    'WidgetManager \'[_1]\' has no installed widgets.' => 'WidgetManager \'[_1]\' n\'a pas de widgets installés.', # Translate - New (6)
    'Can\'t find included template module \'[_1]\'' => 'Impossible de trouver le module de modèle inclus \'[_1]\'',

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
    'File is not in WXR format.' => 'Le fichier n\'est pas dans le format WXR.', # Translate - New (6)
    'Saving asset (\'[_1]\')...' => 'Enregistrement de l\'élément (\'[_1]\')...', # Translate - New (3)
    ' and asset will be tagged (\'[_1]\')...' => ' et l\'élément sera tagué (\'[_1]\')...', # Translate - New (7)
    'Saving page (\'[_1]\')...' => 'Enregistrement de la page (\'[_1]\')...', # Translate - New (3)

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
