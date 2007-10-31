# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::L10N::fr;

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
    'Checking for [_1] Modules:' => 'Vérification des Modules [_1] :',
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

    ## ./extras/examples/plugins/mirror/mirror.pl

    ## ./extras/examples/plugins/mirror/tmpl/mirror.tmpl

    ## ./extras/examples/plugins/l10nsample/l10nsample.pl
    'l10nsample' => 'l10nsample', # Translate - Previous (2)
    'This description can be localized if there is l10n_class set.' => 'Cette description peut être localisée si un l10n_class est mis en place.',
    'Fumiaki Yoshimatsu' => 'Fumiaki Yoshimatsu', # Translate - Previous (2)

    ## ./extras/examples/plugins/l10nsample/tmpl/view.tmpl
    'This phrase is processed in template.' => 'Cette phrase est appliquée dans le template.',

    ## ./default_templates/individual_entry_archive.tmpl
    'Main' => 'Principal',
    'Tags' => 'Tags', # Translate - Previous (1)
    'Posted by [_1] on [_2]' => 'Postée par [_1] dans [_2]',
    'Posted on [_1]' => 'Publiée le [_1]',
    'Permalink' => 'Lien permanent',
    'TrackBack' => 'TrackBack', # Translate - Previous (1)
    'TrackBack URL for this entry:' => 'URL de TrackBack de cette note:',
    'Listed below are links to weblogs that reference' => 'Ci-dessous la liste des liens des weblogs qui référencent',
    'from' => 'de',
    'Read More' => 'Lire la suite',
    'Tracked on' => 'Trackbacké le',
    'Comments' => 'Commentaires',
    'Anonymous' => 'Anonyme',
    'Posted by' => 'Publié par',
    'Posted on' => 'Publié le',
    'Permalink to this comment' => 'Permalien de ce commentaire',
    'Post a comment' => 'Poster un commentaire',
    '(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(Si vous n\'avez pas encore écrit de commentaire ici, il se peut que vous vous deviez être approuvé par le propriétaire du site avant que votre commentaire n\'apparaisse. En attendant, il n\'apparaîtra pas sur le site. Merci de patienter).',
    'Name' => 'Nom',
    'Email Address' => 'Adresse e-mail',
    'URL' => 'URL', # Translate - Previous (1)
    'Remember personal info?' => 'Mémoriser mes infos personnelles?',
    '(you may use HTML tags for style)' => '(vous pouvez utiliser des tags HTML pour modifier le style)',
    'Preview' => 'Aperçu',
    'Post' => 'Publier',
    'Search' => 'Rechercher',
    'Search this blog:' => 'Chercher dans ce blog :',
    'About' => 'A propos',
    'The previous post in this blog was <a href=' => 'La précédente note de ce blog était <a href=',
    'The next post in this blog is <a href=' => 'La note suivante de ce blog est <a href=',
    'Many more can be found on the <a href=' => 'En découvrir plus sur <a href=',
    'Subscribe to this blog\'s feed' => 'S\'abonner au flux de ce blog',
    'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds', # Translate - Previous (6)
    'What is this?' => 'De quoi s\'agit-il?',
    'This weblog is licensed under a' => 'Ce weblog est sujet à une licence',
    'Creative Commons License' => 'Creative Commons',

    ## ./default_templates/stylesheet.tmpl

    ## ./default_templates/uploaded_image_popup_template.tmpl

    ## ./default_templates/comment_error_template.tmpl
    'Comment Submission Error' => 'Erreur d\'envoi de commentaire',
    'Your comment submission failed for the following reasons:' => 'Votre envoi de commentaire a échoué pour les raisons suivantes :',
    'Return to the original entry' => 'Retourner à la note originale',

    ## ./default_templates/rsd.tmpl

    ## ./default_templates/dynamic_site_bootstrapper.tmpl

    ## ./default_templates/main_index.tmpl
    'Continue reading' => 'Lire la suite',
    'TrackBacks' => 'TrackBacks', # Translate - Previous (1)
    'Recent Posts' => 'Notes récentes',
    'Categories' => 'Catégories',
    'Archives' => 'Archives', # Translate - Previous (1)

    ## ./default_templates/comment_preview_template.tmpl
    'Comment on' => 'Commentaire sur',
    'Previewing your Comment' => 'Aperçu',
    'Cancel' => 'Annuler',

    ## ./default_templates/site_javascript.tmpl
    'Thanks for signing in,' => 'Merci de vous être enregistré,',
    '. Now you can comment. ' => '. Maintenant vous pouvez commenter. ',
    'sign out' => 'déconnexion',
    'You are not signed in. You need to be registered to comment on this site.' => 'Vous n\'êtes pas enregistré.  Vous devez être enregistré pour pouvoir commenter sur ce site.',
    'Sign in' => 'Inscription',
    'If you have a TypeKey identity, you can' => 'Si vous avez un identifiant TypeKey, vous pouvez',
    'sign in' => 'vous inscrire',
    'to use it here.' => 'pour l\'utiliser ici.',

    ## ./default_templates/dynamic_pages_error_template.tmpl
    'Page Not Found' => 'Page Non Trouvée',

    ## ./default_templates/trackback_listing_template.tmpl
    ': Discussion on [_1]' => ' : Discussion à propos de [_1]',
    'Trackbacks: [_1]' => 'TrackBacks : [_1]',
    'Tracked on [_1]' => 'Tracké sur [_1]',

    ## ./default_templates/search_results_template.tmpl
    'SEARCH FEED AUTODISCOVERY LINK PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'LE LIEN DU FLUX DE LA RECHERCHE AUTOMATISÉE EST PUBLIÉ UNIQUEMENT APRES L\'EXÉCUTION DE LA RECHERCHE.',
    'Search Results' => 'Résultats de recherche',
    'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'LES RECHERCHES SIMPLES ONT LE FORMULAIRE DE RECHERCHES',
    'Search this site' => 'Rechercher sur ce site',
    'Match case' => 'Respecter la casse',
    'Regex search' => 'Expression générique',
    'SEARCH RESULTS DISPLAY' => 'AFFICHAGE DES RESULTATS DE LA RECHERCHE',
    'Matching entries from [_1]' => 'Notes correspondant à [_1]',
    'Entries from [_1] tagged with \'[_2]\'' => 'Notes à partir de [_1] taguées avec \'[_2]\'',
    'Posted <MTIfNonEmpty tag=' => 'Publiée <MTIfNonEmpty tag=',
    'Showing the first [_1] results.' => 'Afficher les premiers [_1] resultats.',
    'NO RESULTS FOUND MESSAGE' => 'MESSAGE AUCUN RÉSULTAT',
    'Entries matching \'[_1]\'' => 'Notes correspondant à \'[_1]\'',
    'Entries tagged with \'[_1]\'' => 'Notes taguées avec \'[_1]\'',
    'No pages were found containing \'[_1]\'.' => 'Aucune page trouvée contenant \'[_1]\'.',
    'Instructions' => 'Instructions', # Translate - Previous (1)
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
    'Other tags used on this blog' => 'Autres tags utilisés sur ce blog',
    'END OF PAGE BODY' => 'FIN DU CORPS DE LA PAGE',
    'END OF CONTAINER' => 'FIN DU CONTENU',

    ## ./default_templates/datebased_archive.tmpl
    'About [_1]' => 'A propos de [_1]',
    '<a href=' => '<a href=', # Translate - Previous (3)

    ## ./default_templates/category_archive.tmpl

    ## ./default_templates/comment_pending_template.tmpl
    'Comment Pending' => 'Commentaires en attente',
    'Thank you for commenting.' => 'Merci de votre commentaire.',
    'Your comment has been received and held for approval by the blog owner.' => 'Votre commentaire a été reçu et est en attente de validation par le propriétaire de ce blog.',

    ## ./default_templates/rss_20_index.tmpl

    ## ./default_templates/master_archive_index.tmpl
    ': Archives' => ' : Archives',

    ## ./default_templates/atom_index.tmpl

    ## ./search_templates/comments.tmpl
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
    'Select the time interval that you\'d like to search in, then click \'Find new comments\'' => 'Sélectionner l\'intervalle de temps désiré pour la recherche, puis cliquez sur \'Trouver les nouveaux commentaires\'',

    ## ./search_templates/results_feed.tmpl
    'Search Results for [_1]' => 'Résultats de la recherche sur [_1]',

    ## ./search_templates/results_feed_rss2.tmpl

    ## ./search_templates/default.tmpl
    'Blog Search Results' => 'Résultats de la recherche',
    'Blog search' => 'Recherche de Blog',

    ## ./plugins/nofollow/nofollow.pl
    'Adds a \'nofollow\' relationship to comment and TrackBack hyperlinks to reduce spam.' => 'Ajoutez un \'nofollow\' aux commentaires et aux trackbacks pour réduire le Spam.',
    'Restrict:' => 'Restreindre :',
    'Don\'t add nofollow to links in comments by trusted commenters' => 'Ne pas ajouter de Nofollow dans liens des commentaires émanants de commentateurs fiables',

    ## ./plugins/TemplateRefresh/TemplateRefresh.pl
    'Backup and refresh existing templates to Movable Type\'s default templates.' => 'Sauvegarder et rafraîchir les modèles existants dans les modèles par défaut de Movable Type.',

    ## ./plugins/TemplateRefresh/tmpl/results.tmpl
    'Backup and Refresh Templates' => 'Sauvegarder et rafraîchir les modèles',
    'No templates were selected to process.' => 'Aucun modèle sélectionné pour cette action.',
    'Return' => 'Retour',

    ## ./plugins/MultiBlog/multiblog.pl
    'MultiBlog allows you to publish templated or raw content from other blogs and define rebuild dependencies and access controls between them.' => 'Le MultiBog vous permet de publier un modèle ou du contenu à partir d\'autres blogs et de définir les dépendances de reconstruction et les controles d\'accès entre eux.',

    ## ./plugins/MultiBlog/tmpl/system_config.tmpl
    'Default system aggregation policy:' => 'Défaut du système de règle d\'aggrégation:',
    'Allow' => 'Autorise',
    'Disallow' => 'Plus Autorisé',
    'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'L\'aggrégation entre blogs sera autorisée par défaut. Les blogs individuels peuvent être configurés dans un niveau de paramètrage Blog MultiBlog pour restreindre l\'accès à leur contenu par d\'autres blogs.',
    'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'L\'aggrégation entre blogs ne sera pas autorisée par défaut. Les blogs individuels peuvent être configurés dans un niveau de paramètrage Blog MultiBlog pour autoriser l\'accès à leur contenu par d\'autres blogs.',

    ## ./plugins/MultiBlog/tmpl/blog_config.tmpl
    'When' => 'Quand',
    'Any Weblog' => 'Tous les weblogs', # Translate - New (2)
    'Remove' => 'Supprimer',
    'Weblog' => 'Weblog', # Translate - Previous (1)
    'Trigger' => 'Déclencher',
    'Action' => 'Action', # Translate - Previous (1)
    'Content Privacy:' => 'Contenu privé:',
    'Use system default' => 'Utiliser les paramètres par défaut',
    'Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.' => 'Indique si les autres weblogs de l\'installation peuvent publier du contenu provenant de ce weblog. Ce paramètrage prend le dessus sur les paramètres par défaut concernant l\'aggrégation qui se trouvent dans la configuration MultiBlog au niveau système.', # Translate - New (29)
    'MTMultiBlog tag default arguments:' => 'Argument par défaut du  tag MTMultiBlog :',
    'Include blogs' => 'Inlure les blogs',
    'Exclude blogs' => 'Exclure les blogs',
    'Current Rebuild Triggers:' => 'Déclencheurs actuels de reconstruction:',
    'Create New Rebuild Trigger' => 'Créer un Nouveau déclencheur de reconstruction',
    'You have not defined any rebuild triggers.' => 'Vous n\'avez défini aucun déclencheur de reconstruction',

    ## ./plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
    'When this' => 'Quand cela',

    ## ./plugins/feeds-app-lite/mt-feeds.pl
    'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type?' => 'Feeds.App Lite vous permet de republier des flux sur vos blogs. Vous voulez en faire plus avec les flux de Movable Type?',
    'Upgrade to Feeds.App' => 'Mise à jour Feeds.App',

    ## ./plugins/feeds-app-lite/tmpl/select.tmpl
    'Feeds.App Lite Widget Creator' => 'Créateur de widget Feeds.App',
    'Multiple feeds were discovered. Select the feed you wish to use. Feeds.App Lite supports text-only RSS 1.0, 2.0 and Atom feeds.' => 'Nous avons trouvés plusieurs flux. Sélectionnez le flux que vous voulez utiliser. Feeds.App Lite n\'accepte que les Flux RSS texte 1.0 et 2.0 et les flux Atom.',
    'Type' => 'Type', # Translate - Previous (1)
    'URI' => 'URI', # Translate - Previous (1)
    'Continue' => 'Continuer',

    ## ./plugins/feeds-app-lite/tmpl/msg.tmpl
    'No feeds could be discovered using [_1].' => 'Aucun flux n\'a été découvert avec [_1].',
    'An error occurred processing [_1]. Check <a href=' => 'Une erreur est survenue sur [_1]. Vérifiez <a href=',
    'It can be included onto your published blog using <a href=' => 'Il peut être intégré sur votre blog en utilisant <a href=',
    'It can be included onto your published blog using this MTInclude tag' => 'Cela peut être intégré à votre blog en utilisant le tag MTInclude',
    'Go Back' => 'Retour',
    'Create Another' => 'En créer un autre',

    ## ./plugins/feeds-app-lite/tmpl/header.tmpl
    'Main Menu' => 'Menu principal',
    'System Overview' => 'Aperçu général du système',
    'Help' => 'Aide',
    'Welcome' => 'Bienvenue',
    'Logout' => 'Déconnexion',
    'Entries' => 'Notes',
    'Search (q)' => 'Recherche (q)',

    ## ./plugins/feeds-app-lite/tmpl/start.tmpl
    'Feeds.App Lite creates modules that include feed data. Once you\'ve used it to create those modules, you can then use them in your blog templates.' => 'Feeds.App Lite crée des modules incluant les données des flux.  Une fois que vous l\'avez utilisé pour créer ces modules, vous pouvez les utiliser dans les templates de vos blogs.',
    'You must enter an address to proceed' => 'Vous devez saisir une adresse',
    'Enter the URL of a feed, or the URL of a site that has a feed.' => 'Saisissez l\'adresse d\'un flux ou l\'adresse d\'un site possédant un flux.',

    ## ./plugins/feeds-app-lite/tmpl/footer.tmpl

    ## ./plugins/feeds-app-lite/tmpl/config.tmpl
    'Feed Configuration' => 'Configuration du flux',
    'Feed URL' => 'URL du flux',
    'Title' => 'Titre',
    'Enter a title for your widget.  This will also be displayed as the title of the feed when used on your published blog.' => 'Saisissez un titre pour votre widget. Il sera aussi utilisé comme titre pour le flux qui sera utilisé sur votre blog.',
    'Display' => 'Afficher',
    '3' => '3', # Translate - Previous (1)
    '5' => '5', # Translate - Previous (1)
    '10' => '10', # Translate - Previous (1)
    'All' => 'Toutes',
    'Select the maximum number of entries to display.' => 'Sélectionnez le nombre maximum de notes que vous voulez afficher.',
    'Save' => 'Enregistrer',

    ## ./plugins/spamlookup/spamlookup_words.pl
    'SpamLookup module for moderating and junking feedback using keyword filters.' => 'Module SpamLookup pour modérer et nettoyer les feedbacks de vos lecteurs en utilisant des filtres de mots clefs.',

    ## ./plugins/spamlookup/spamlookup_urls.pl
    'SpamLookup - Link' => 'SpamLookup - Lien',
    'SpamLookup module for junking and moderating feedback based on link filters.' => ' Module SpamLookup pour modérer et nettoyer les feedbacks de vos lecteurs en utilisant des filtres de liens.',

    ## ./plugins/spamlookup/spamlookup.pl
    'SpamLookup module for using blacklist lookup services to filter feedback.' => 'Module SpamLookup pour utiliser les services blacklist visant à filtrer les retours lecteurs.',

    ## ./plugins/spamlookup/tmpl/url_config.tmpl
    'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Les Filtres de Liens contrôlent le nombre d\'hyperliens dans les commentaires ou les TrackBacks. S\'ils contiennent beaucoup de liens, ils peuvent être considérés comme indésirables.  Dans le cas contraire, les feedbacks avec peu de liens ou des liens déjà publiés seront acceptés. N\'activez cette fonction que si vous êtes certain que votre site est dénué de tout Spam.',
    'Link Limits:' => 'Limites de lien :',
    'Credit feedback rating when no hyperlinks are present' => 'Accorder un crédit aux feedbacks dépourvus de liens',
    'Adjust scoring' => 'Ajuster la notation',
    'Score weight:' => 'Poids du score :',
    'Decrease' => 'Baisser',
    'Increase' => 'Augmenter',
    'Moderate when more than' => 'Modérer si plus de',
    'link(s) are given' => 'lien(s) sont soumis',
    'Junk when more than' => 'Rejeter si plus de',
    'Link Memory:' => 'Mémoire de Lien :',
    'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Accorder un crédit à un feedback quand &quot;URL&quot; l\'élément du feedback a été publié auparavant',
    'Only applied when no other links are present in message of feedback.' => 'Appliqué uniquement si aucun autre lien n\'est présent dans le message de feedback.',
    'Exclude URLs from comments published within last [_1] days.' => 'Exclure les URLS des commentaires publiés lors des [_1] derniers jours.',
    'Email Memory:' => 'Mémoire Email :',
    'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Accorder un crédit au feedback quand des commentaires préalablement publiés contiennent aussi &quot;Email&quot;',
    'Exclude Email addresses from comments published within last [_1] days.' => 'Exclure les adresses emails des commentaires publiés dans les  [_1] derniers jours.',

    ## ./plugins/spamlookup/tmpl/lookup_config.tmpl
    'Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog\'s Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.' => 'Les Lookups contrôlent les sources des adresses IP et les liens hypertextes de tous les feedbacks de vos lecteurs. Si un commentaire ou un TrackBack provient d\'une adresse IP blacklistée, ou contient un lien ou un domaine blacklisté, il pourra être automatiquement placé dans le dossier des élements indésirables.',
    'IP Address Lookups:' => 'Lookups Adresses IP :',
    'Off' => 'Désactivé',
    'Moderate feedback from blacklisted IP addresses' => 'Modérer les feedbacks des adresses IP blacklistées',
    'Junk feedback from blacklisted IP addresses' => 'Rejeter les feedbacks des adresses IP blacklistées',
    'Less' => 'Moins',
    'More' => 'Plus',
    'block' => 'bloquer',
    'none' => 'aucun',
    'IP Blacklist Services:' => 'Services de Blackliste d\'IP :',
    'Domain Name Lookups:' => 'Lookups Noms de Domaines :',
    'Moderate feedback containing blacklisted domains' => 'Modérer les feedbacks lecteurs contenant des domaines blacklistés',
    'Junk feedback containing blacklisted domains' => 'Rejeter les feedbacks contenant des domaines blacklistés',
    'Domain Blacklist Services:' => ' Services de Blackliste des Domaines :',
    'Advanced TrackBack Lookups:' => 'Lookups Avancé des Trackbacks :',
    'Moderate TrackBacks from suspicious sources' => 'Modérer les TrackBacks provenant de sources douteuses',
    'Junk TrackBacks from suspicious sources' => 'Rejeter les TrackBacks provenant de sources douteuses',
    'To prevent lookups for some IP addresses or domains, list them below. Place each entry on a line by itself.' => 'Pour ne pas appliquer le LookUps sur certaines IP ou Domaines, les lister ci-dessous. Merci de saisir un élément par ligne.',
    'Lookup Whitelist:' => 'Lookup Whiteliste :',

    ## ./plugins/spamlookup/tmpl/word_config.tmpl
    'Incomming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Les feedbacks des lecteurs peuvent être contrôlés sur un mot clef spécifique, un nom de domaine, ou leur forme. La combinaison de critères permet de détecter les indésirables. Vous pouvez paramétrer vos pondérations pour définir un indésirable.',
    'Keywords to Moderate:' => 'Mots clefs à modérer :',
    'Keywords to Junk:' => 'Mots clefs à rejeter :',

    ## ./plugins/GoogleSearch/GoogleSearch.pl

    ## ./plugins/GoogleSearch/tmpl/config.tmpl
    'Google API Key:' => 'Clé d\'API Google :',
    'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.' => 'Vous devrez vous procurer une clé d\'API Google si vous souhaitez utiliser une des fonctionnalités de l\'API proposée par Google. Le cas échéant, collez cette clé dans cet espace.',

    ## ./plugins/Cloner/cloner.pl
    'Clones a weblog and all of its contents.' => 'Duplique un weblog et tout son contenu',
    'Cloning Weblog' => 'Clonage du weblog',
    'Error' => 'Erreur',
    'Close' => 'Fermer',

    ## ./plugins/StyleCatcher/stylecatcher.pl
    '<p style=' => '<p style=', # Translate - Previous (3)
    'Theme Root URL:' => 'URL Racine du Thème :',
    'Theme Root Path:' => 'Chemin Racine du Thème :',
    'Style Library URL:' => 'URL de la bibliothèque de styles :',

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

    ## ./plugins/StyleCatcher/tmpl/footer.tmpl

    ## ./plugins/WidgetManager/WidgetManager.pl
    'Maintain your weblog\'s widget content using a handy drag and drop interface.' => 'Administrez les widgets de votre weblog en utilisant une interface glisser/déplacer.',

    ## ./plugins/WidgetManager/tmpl/list.tmpl
    'Widget Manager' => 'Gestionnaire de Widget',
    'Your changes to the Widget Manager have been saved.' => 'Vos changements dans votre Gestionnaire de Widgets sont enregistrés.',
    'You have successfully deleted the selected Widget Manager(s) from your weblog.' => 'Vous avez correctement supprimé de votre weblog le(s) Gestionnaire(s) de Widgets sélectionné(s).',
    'To add a Widget Manager to your templates, use the following syntax:' => 'Pour ajouter un Gestionnaire de Widget à vos modèles, utilisez la syntaxe suivante:',
    'Widget Managers' => 'Gestionnaires de Widget',
    'Add Widget Manager' => 'Ajouter un Gestionnaire de Widgets',
    'Create Widget Manager' => 'Créer un Gestionnaire de Widgets',
    'Delete' => 'Supprimer',
    'Delete selected Widget Managers (x)' => 'Efface les gestionnaires de Widget sélectionnés (x)',
    'WidgetManager Name' => 'Nom du Gestionnaire de Widget',
    'Installed Widgets' => 'Widgets installés',

    ## ./plugins/WidgetManager/tmpl/header.tmpl
    'Movable Type Publishing Platform' => 'Plateforme de publication Movable Type',
    'Go to:' => 'Aller à :',
    'Select a blog' => 'Sélectionner un blog',
    'Weblogs' => 'Weblogs', # Translate - Previous (1)
    'System-wide listing' => 'Listing sur la totalité du système',

    ## ./plugins/WidgetManager/tmpl/edit.tmpl
    'You already have a widget manager named [_1]. Please use a unique name for this widget manager.' => 'Vous avez déjà un gestionnaire de Widgets nommé [_1]. Merci d\'utiliser un nom unique pour ce gestionnaire de Widgets.',
    'Rearrange Items' => 'Réorganiser les éléments',
    'Widget Manager Name:' => 'Nom du Gestionnaire de Widgets :',
    'Build WidgetManager:' => 'Construire le Gestionnaire de Widgets :',
    'Available Widgets' => 'Widgets disponibles',
    'Save Changes' => 'Enregistrer les modifications',
    'Save changes (s)' => 'Enregistrer les modifications',

    ## ./plugins/WidgetManager/tmpl/footer.tmpl

    ## ./plugins/WidgetManager/default_widgets/search.tmpl

    ## ./plugins/WidgetManager/default_widgets/recent_posts.tmpl

    ## ./plugins/WidgetManager/default_widgets/technorati_search.tmpl
    'Technorati' => 'Technorati', # Translate - Previous (1)
    'this blog' => 'ce blog',
    'all blogs' => 'tous les blogs',
    'Blogs that link here' => 'Blogs pointant ici',

    ## ./plugins/WidgetManager/default_widgets/copyright.tmpl

    ## ./plugins/WidgetManager/default_widgets/creative_commons.tmpl

    ## ./plugins/WidgetManager/default_widgets/recent_comments.tmpl
    'Recent Comments' => 'Commentaires récents',

    ## ./plugins/WidgetManager/default_widgets/subscribe_to_feed.tmpl

    ## ./plugins/WidgetManager/default_widgets/monthly_archive_dropdown.tmpl
    'Select a Month...' => 'Sélectionnez un Mois...',

    ## ./plugins/WidgetManager/default_widgets/monthly_archive_list.tmpl

    ## ./plugins/WidgetManager/default_widgets/powered_by.tmpl

    ## ./plugins/WidgetManager/default_widgets/category_archive_list.tmpl

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

    ## ./plugins/WidgetManager/default_widgets/tag_cloud_module.tmpl
    'Tag cloud' => 'Nuage de Tag',

    ## ./lib/MT/default-templates.pl

    ## ./build/template_hash_signatures.pl

    ## ./build/exportmt.pl

    ## ./build/l10n/diff.pl

    ## ./build/l10n/wrap.pl

    ## ./build/l10n/diff_EMEA.pl

    ## ./build/l10n/trans.pl

    ## ./tmpl/error.tmpl
    'Missing Configuration File' => 'Fichier de configuration manquant',
    'Database Connection Error' => 'Erreur de connexion à la base de données',
    'CGI Path Configuration Required' => 'Configuration de chemin CGI requise',
    'An error occurred' => 'Une erreur s\'est produite',

    ## ./tmpl/cms/edit_entry.tmpl
    'You have unsaved changes to your entry that will be lost.' => 'Votre Note contient des changements non enregistrés qui seront perdus.',
    'Add new category...' => 'Ajouter une catégorie...',
    'Publish On' => 'Publié le',
    'Entry Date' => 'Date de la note',
    'You must specify at least one recipient.' => 'Vos devez définir au moins un destinataire.',
    'Create New Entry' => 'Créer  une nouvelle note',
    'Edit Entry' => 'Modifier une note',
    'Your entry has been saved. You can now make any changes to the entry itself, edit the authored-on date, or edit comments.' => 'Votre note a été enregistrée. Vous pouvez maintenant faire les changements de votre choix dans la note, changer la date de publication, ou en modifier les commentaires.',
    'Your changes have been saved.' => 'Les modifications ont été enregistrées.',
    'One or more errors occurred when sending update pings or TrackBacks.' => 'Erreur lors de l\'envoi des pings ou des TrackBacks.',
    'Your customization preferences have been saved, and are visible in the form below.' => 'Vos préférences ont été enregistrées et sont affichées dans le formulaire ci-dessous.',
    'Your changes to the comment have been saved.' => 'Les modifications apportées aux commentaires ont été enregistrées.',
    'Your notification has been sent.' => 'Votre notification a été envoyé.',
    'You have successfully deleted the checked comment(s).' => 'Les commentaires sélectionnés ont été supprimés.',
    'You have successfully deleted the checked TrackBack(s).' => 'Le(s) TrackBack(s) sélectionné(s) ont été correctement supprimé(s).',
    'Previous' => 'Précédent',
    'List &amp; Edit Entries' => 'Lister &amp; Editer les  Notes',
    'Next' => 'Suivant',
    '_external_link_target' => '_haut',
    'View Entry' => 'Afficher la note',
    'Entry' => 'Note',
    'Comments ([_1])' => 'Commentaires ([_1])',
    'TrackBacks ([_1])' => 'TrackBacks ([_1])', # Translate - Previous (2)
    'Notification' => 'Notification', # Translate - Previous (1)
    'Status' => 'Statut',
    'Unpublished' => 'Non publié',
    'Published' => 'Publié',
    'Scheduled' => 'Programmé',
    'Category' => 'Catégorie',
    'Assign Multiple Categories' => 'Affecter plusieurs catégories',
    'Entry Body' => 'Corps de la note',
    'Bold' => 'Gras',
    'Italic' => 'Italique',
    'Underline' => 'Souligné',
    'Insert Link' => 'Insérer un lien',
    'Insert Email Link' => 'Insérer le lien vers l\'e-mail',
    'Quote' => 'Citation',
    'Bigger' => 'Plus grand',
    'Smaller' => 'Plus petit',
    'Extended Entry' => 'Suite de la note',
    'Excerpt' => 'Extrait',
    'Keywords' => 'Mots-clés',
    '(comma-delimited list)' => '(liste délimitée par virgule)',
    '(space-delimited list)' => '(liste délimitée par espace)',
    '(delimited by \'[_1]\')' => '(delimité par \'[_1]\')',
    'Text Formatting' => 'Mise en forme du texte',
    'Basename' => 'Nom de base',
    'Unlock this entry\'s output filename for editing' => 'Dévérouiller le nom du fichier de  cette note pour l\'éditer',
    'Warning' => 'Attention',
    'Warning: If you set the basename manually, it may conflict with another entry.' => 'ATTENTION : Editer le nom de base manuellement peut créer des conflits avec d\'autres notes.',
    'Warning: Changing this entry\'s basename may break inbound links.' => 'ATTENTION : Changer le nom de base de cette note peut casser des liens entrants.',
    'Accept Comments' => 'Accepter commentaires',
    'Accept TrackBacks' => 'Accepter TrackBacks',
    'Outbound TrackBack URLs' => 'URLs TrackBacks sortants',
    'View Previously Sent TrackBacks' => 'Afficher les TrackBacks envoyés précédemment',
    'Customize the display of this page.' => 'Personnaliser l\'affichage de cette page.',
    'Manage Comments' => 'Gérer les commentaires',
    'Click on a comment to edit it. To perform any other action, check the checkbox of one or more comments and click the appropriate button or select a choice of actions from the dropdown to the right.' => 'Cliquez sur un commentaire pour l\'éditer. Pour accomplir toute autre action, sélectionnez les cases à cocher d\'un ou plusieurs commentaires puis cliquez sur le bouton approprié ou bien sélectionnez un choix d\'action dans le menu déroulant à droite.', # Translate - New (37)
    'No comments exist for this entry.' => 'Pas de commentaire sur cette note.',
    'Manage TrackBacks' => 'Gérer les TrackBacks',
    'Click on a Trackback to edit it. To perform any other action, check the checkbox of one or more Trackbacks and click the appropriate button or select a choice of actions from the dropdown to the right.' => 'Cliquez sur le Trackback pour l\'éditer. Pour accomplir toute autre action, sélectionnez les cases à cocher d\'un ou plusieurs TrackBack puis cliquez sur le bouton approprié ou bien sélectionnez un choix d\'action dans le menu déroulant à droite.', # Translate - New (37)
    'No TrackBacks exist for this entry.' => 'Aucun TrackBack n\'est associé à cette note.',
    'Send a Notification' => 'Envoyer un avis',
    'You can send an email notification of this entry to people on your notification list or using arbitrary email addresses.' => 'Vous pouvez envoyer une notification par email sur cette note à des personnes inscrites sur votre liste de notification ou bien utiliser les adresses emails de votre choix.',
    'Recipients' => 'Destinataires',
    'Send notification to' => 'Envoyer une notification à',
    'Notification list subscribers, and/or' => 'Abonnés à la liste de notication, et/ou',
    'Other email addresses' => 'Autres adresses email',
    'Note: Enter email addresses on separate lines or separated by commas.' => 'Note: Entrez des adresses emails sur des lignes séparées ou séparées par des virgules.',
    'Notification content' => 'Contenu de la notification',
    'Your blog\'s name, this entry\'s title and a link to view it will be sent in the notification.  Additionally, you can add a  message, include an excerpt of the entry and/or send the entire entry.' => 'Le nom de votre blog, le titre de la note et un lien vers son contenu seront envoyés dans la notification. Vous pouvez en plus ajouter un message incluant un extrait de la note et/ou la note entière',
    'Message to recipients (optional)' => 'Message aux destinataires (en option)',
    'Additional content to include (optional)' => 'Contenu additionnel à inclure (en option)',
    'Entry excerpt' => 'Extrait de la note',
    'Entire entry body' => 'Corps de la Note complet',
    'Note: If you choose to send the entire entry, it will be sent as shown on the editing screen, without any text formatting applied.' => 'Note : Si vous choisissez d\'envoyer la note en entier, elle sera envoyée comme vous la voyez dans votre interface d\'édition, sans mise en page particulière.',
    'Send entry notification' => 'Envoyer une notification de note',
    'Send notification (n)' => 'Envoyer une notification (n)',
    'Plugin Actions' => 'Actions du plugin',

    ## ./tmpl/cms/entry_prefs.tmpl
    'Entry Editor Display Options' => 'Options d\'affichage de l\'éditeur de Notes',
    'Your entry screen preferences have been saved.' => 'Vos préférences d\'édition ont été enregistrées.',
    'Editor Fields' => 'Champs d\'édition',
    'Defaults' => 'Par défaut',
    'Basic' => 'Basique',
    'Custom' => 'Perso',
    'Editable Authored On Date' => 'Date de création modifiable',
    'Action Bar' => 'Barre d\'action',
    'Select the location of the entry editor\'s action bar.' => 'Choisissez l\'emplacement de la barre d\'action d\'édition de Notes.',
    'Below' => 'Sous',
    'Above' => 'Dessus',
    'Both' => 'Les deux',

    ## ./tmpl/cms/footer-dialog.tmpl

    ## ./tmpl/cms/preview_entry.tmpl
    'Re-Edit this entry' => 'Modifier cette note',
    'Save this entry' => 'Enregistrer cette note',

    ## ./tmpl/cms/menu.tmpl
    'Welcome to [_1].' => 'Bienvenue sur [_1].',
    'You can post to and manage your weblog by selecting an option from the menu located to the left of this message.' => 'Vous pouvez publier sur votre weblog ou bien le gérer en sélectionnant une option du menu situé à gauche de ce message.',
    'If you need assistance, try:' => 'Si vous avez besoin d\'aide, vous pouvez consulter :',
    'Movable Type User Manual' => 'Mode d\'emploi de Movable Type',
    'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.com/movabletype/support', # Translate - Previous (6)
    'Movable Type Technical Support' => 'Support Technique Movable Type',
    'Movable Type Community Forums' => 'Forums de la communauté Movable Type ',
    'Change this message.' => 'Changer ce message.',
    'Edit this message.' => 'Modifier ce message.',
    'Here is an overview of [_1].' => 'Voici un aperçu de [_1].',
    'List Entries' => 'Afficher les notes',
    'Recent Entries' => 'Notes récentes',
    'List Comments' => 'Afficher les commentaires',
    'Pending' => 'En attente',
    'List TrackBacks' => 'Lister les TrackBacks',
    'Recent TrackBacks' => 'TrackBacks récents',

    ## ./tmpl/cms/list_commenters.tmpl
    'Authenticated Commenters' => 'Auteurs de commentaires authentifiés',
    'The selected commenter(s) has been given trusted status.' => 'Le statut fiable a été accordé au(x) auteur(s) de commentaires sélectionné(s).',
    'Trusted status has been removed from the selected commenter(s).' => 'Le(s) auteur(s) de commentaires sélectionné(s) ne bénéficie plus du statut fiable.',
    'The selected commenter(s) have been blocked from commenting.' => 'Le(s) auteurs(s) de commentaires sélectionné(s) ne sont plus autorisés à commenter.',
    'The selected commenter(s) have been unbanned.' => 'Le(s) auteurs(s) de commentaires sélectionné(s) n\'est plus banni.',
    'Reset' => 'Mettre à jour',
    'Filter' => 'Filtre',
    'None.' => 'Aucun',
    '(Showing all commenters.)' => '(Afficher tous les auteurs de commentaires).',
    'Showing only commenters whose [_1] is [_2].' => 'Ne montrer que les auteurs de commentaires dont [_1] est [_2].',
    'Commenter Feed' => 'Flux auteur de commentaire',
    'Show' => 'Afficher',
    'all' => 'tous/toutes',
    'only' => 'uniquement',
    'commenters.' => 'les auteurs de commentaires.',
    'commenters where' => 'les auteurs de commentaires dont',
    'status' => 'le statut',
    'commenter' => 'l\'auteur de commentaires',
    'is' => 'est',
    'trusted' => 'fiable',
    'untrusted' => 'non fiable',
    'banned' => 'banni',
    'unauthenticated' => 'non authentifié',
    'authenticated' => 'authentifié',
    '.' => '.', # Translate - Previous (0)
    'No commenters could be found.' => 'Aucun auteur de commentaires trouvé.',

    ## ./tmpl/cms/list_comment.tmpl
    'System-wide' => 'Dans tout le système',
    'The selected comment(s) has been published.' => 'Le(s) commentaire(s) sélectionné(s) ont été publié(s) correctement.',
    'All junked comments have been removed.' => 'Tous les commentaires indésirables on été supprimés.',
    'The selected comment(s) has been unpublished.' => 'Le (s) commentaire(s) sélectionné(s) n\'ont pas été publié(s).',
    'The selected comment(s) has been junked.' => 'Le(s) commentaire(s) sélectionné(s) sont marqué(s) indésirable(s).',
    'The selected comment(s) has been unjunked.' => 'Le(s) commentaire(s) sélectionné(s) ne sont plus marqué(s) indésirable(s).',
    'The selected comment(s) has been deleted from the database.' => 'Les commentaires sélectionnés ont été supprimés de la base de données.',
    'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be Banned or Trusted.' => 'Un ou plusieurs commentaires sélectionnés ont été écrits par un auteur de commentaires non authentifié. Ces auteurs de commentaires ne peuvent pas être bannis ou validés.',
    'No comments appeared to be junk.' => 'Aucun commentaire marqué indésirable.',
    'Junk Comments' => 'Commentaires indésirables',
    'Comment Feed' => 'Flux des commentaires',
    'Comment Feed (Disabled)' => 'Flux des commentaires (inactif)',
    'Disabled' => 'Désactivé',
    'Set Web Services Password' => 'Définir un mot de passe pour les services Web',
    'Quickfilter:' => 'Filtre Rapide :',
    'Show unpublished comments.' => 'Afficher les commentaires non publiés.',
    '(Showing all comments.)' => '(Affichage de tous les commentaires).',
    'Showing only comments where [_1] is [_2].' => 'Affichage de tous les commentaires où [_1] est [_2].',
    'comments.' => 'les commentaires.',
    'comments where' => 'commentaires dont',
    'published' => 'publié',
    'unpublished' => 'non publié',
    'No comments could be found.' => 'Aucun commentaire n\'a été trouvé.',
    'No junk comments could be found.' => 'Aucun commentaire indésirable n\'a été trouvé.',

    ## ./tmpl/cms/show_upload_html.tmpl
    'Copy and paste this HTML into your entry.' => 'Copiez/collez ce code HTML dans votre note.',
    'Upload Another' => 'Télécharger un autre fichier',

    ## ./tmpl/cms/list_plugin.tmpl
    'Are you sure you want to reset the settings for this plugin?' => 'Etes-vous sur de vouloir réinitialiser les paramètres pour ce plugin ?',
    'Disable plugin system?' => 'Désactiver le système de plugin ?',
    'Disable this plugin?' => 'Désactiver ce plugin ?',
    'Enable plugin system?' => 'Activer le système de plugin ?',
    'Enable this plugin?' => 'Activer ce plugin ?',
    'Plugin Settings' => 'Paramètres des plugins',
    'This screen allows you to control the weblog-level settings of any configurable plugins you\'ve installed.' => 'Cet écran vous permet de contrôler le niveau du weblog en matière de plugin installés.',
    'Your plugin settings have been saved.' => 'Les paramètres de votre plugin ont été enregistrés.',
    'Your plugin settings have been reset.' => 'Les paramètres de votre plugin on été réinitialisés.',
    'Your plugins have been reconfigured.' => 'Votre plugin a été reconfiguré.',
    'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => 'Vos plugins ont été reconfigurés. Si vous êtes sous mod_perl vous devez redémarrer votre serveur web pour la prise en compte de ces changements.',
    'Settings' => 'Paramètres',
    'Plugins' => 'Plugins', # Translate - Previous (1)
    'Switch to Detailed Settings' => 'Afficher les paramètres avancés',
    'General' => 'Général',
    'New Entry Defaults' => 'Nouvelle note par défaut',
    'Feedback' => 'Feedback', # Translate - Previous (1)
    'Publishing' => 'Publication',
    'IP Banning' => 'Bannissement d\'adresses IP',
    'Switch to Basic Settings' => 'Afficher les paramètres de base',
    'Registered Plugins' => 'Plugins enregistrés',
    'Disable Plugins' => 'Désactiver les plugins',
    'Enable Plugins' => 'Activer les plugins',
    'Failed to Load' => 'Erreur de chargement',
    'Disable' => 'Désactiver',
    'Enabled' => 'Activé',
    'Enable' => 'Activer',
    'Documentation for [_1]' => 'Documentation pour [_1]',
    'Documentation' => 'Documentation', # Translate - Previous (1)
    'Author of [_1]' => 'Auteur de [_1]',
    'Author' => 'Auteur',
    'More about [_1]' => 'En savoir plus sur [_1]',
    'Support' => 'Support', # Translate - Previous (1)
    'Plugin Home' => 'Accueil Plugin',
    'Resources' => 'Ressources',
    'Show Resources' => 'Afficher les ressources',
    'Run' => 'Lancer',
    'Run [_1]' => 'Lancer [_1]',
    'Show Settings' => 'Afficher les paramétrages',
    'Settings for [_1]' => 'Paramètres pour [_1]',
    'Version' => 'Version', # Translate - Previous (1)
    'Resources Provided by [_1]' => 'Ressources fournies par [_1]',
    'Tag Attributes' => 'Attributs de tag',
    'Text Filters' => 'Filtres de texte',
    'Junk Filters' => 'Filtres d\'indésirables',
    '[_1] Settings' => '[_1] Paramètres',
    'Reset to Defaults' => 'Rénitialiser pour remettre les paramètres par défaut',
    'Plugin error:' => 'Erreur plugin :',
    'No plugins with weblog-level configuration settings are installed.' => 'Aucun plugin avec une configuration au niveau du weblog n\'est installé.',

    ## ./tmpl/cms/import.tmpl
    'Import / Export' => 'Importer / Exporter',
    'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Transférer les notes Movable Type vers une autre installation Movable Type ou à partir d\'un autre outil de blogging pour faire une sauvegarde ou une copie.',
    'Import Entries' => 'Importer des notes',
    'Export Entries' => 'Exporter des notes',
    'Ownership of imported entries:' => 'Propriété des notes importées :',
    'Import as me' => 'Importer en me considérant comme auteur',
    'Preserve original user' => 'Préserve l\'utilisateur initial',
    'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => 'Si vous choisissez de garder l\'auteur original de chaque note importée, ils doivent être créés dans votre installation et vous devez définir un mot de passe par défaut pour ces nouveaux comptes.',
    'Default password for new users:' => 'Mot de passe par défaut pour un nouvel utilisateur:',
    'Upload import file: (optional)' => 'Charger les fichiers importés : (optionnel)',
    'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'Vous serez désigné comme auteur/utilisateur pour toutes les notes importées. Si vous voulez que l\'auteur initial en conserve la propriété, vous devez contacter votre administrateur MT pour qu\'il fasse l\'importation et le cas échéant qu\'il crée un nouvel utilisateur.',
    'Import File Encoding (optional):' => 'Importer l\'encodage de fichier (optionnel) :',
    'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'Par défaut, Movable Type va essayer de détecter automatiquement l\'encodage des caractères de vos fichiers importés.  Cependant, si vous rencontrez des difficultés, vous pouvez le paramétrer de manière explicite',
    'Default category for entries (optional):' => 'Catégorie par défaut des notes (facultatif) :',
    'Select a category' => 'Sélectionnez une catégorie',
    'You can specify a default category for imported entries which have none assigned.' => 'Vous pouvez spécifier une catégorie par défaut pour les notes importées qui n\'ont pas été assignées.',
    'Importing from another system?' => 'Importer à partir d\'un autre système ?',
    'Start title HTML (optional):' => 'Code HTML précédant le titre (facultatif) :',
    'End title HTML (optional):' => 'Code HTML suivant le titre (facultatif) :',
    'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => 'Si le logiciel à partir duquel vous importez n\'a pas de champ Titre, vous pouvez utiliser ce paramètre pour identifier un titre dans le corps de votre note.',
    'Default post status for entries (optional):' => 'Etat de publication par défaut des notes (facultatif) :',
    'Select a post status' => 'État de publication ?',
    'If the software you are importing from does not specify a post status in its export file, you can set this as the status to use when importing entries.' => 'Si le logiciel à partir duquel vous importez ne spécifie pas le statut de la note dans ses fichiers export, vous pouvez paramétrer ce statut pour l\'utiliser dans les notes importées.',
    'Import Entries (i)' => 'Importer les notes (i)',
    'Export Entries From [_1]' => 'Exporter les notes de [_1]',
    'Export Entries (e)' => 'Exporter les notes (e)',
    'Export Entries to Tangent' => 'Exporter les notes vers Tangent',

    ## ./tmpl/cms/commenter_actions.tmpl
    'Trust' => 'Fiable',
    'commenters' => 'auteurs de commentaire',
    'to act upon' => 'pour agir sur',
    'Trust commenter' => 'Auteur de commentaires Fiable',
    'Untrust' => 'Non Fiable',
    'Untrust commenter' => 'Auteur de commentaires Non Fiable',
    'Ban' => 'Bannir',
    'Ban commenter' => 'Auteur de commentaires Banni',
    'Unban' => 'Non banni',
    'Unban commenter' => 'Auteur de commentaires réactivé',
    'Trust selected commenters' => 'Attribuer le statut Fiable au(x) auteur(s) de commentaires sélectionné(s)',
    'Ban selected commenters' => 'Bannir le(s) auteur(s) de commentaires sélectionné(s)',

    ## ./tmpl/cms/cfg_prefs.tmpl
    'You must set your Weblog Name.' => 'Vous devez définir le nom de votre weblog.',
    'You did not select a timezone.' => 'Vous n\'avez pas sélectionné de fuseau horaire.',
    'General Settings' => 'Paramètres généraux',
    'This screen allows you to control general weblog settings, default weblog display settings, and third-party service settings.' => 'Cet écran vous permet de contrôler les paramètres généraux du weblog, les paramètres par défaut d\'affichage et les services de tiers.',
    'Your blog preferences have been saved.' => 'Les préférences de votre weblog ont été enregistrées.',
    'Weblog Settings' => 'Paramètres du weblog',
    'Weblog Name' => 'Nom du Weblog',
    'Name your weblog. The weblog name can be changed at any time.' => 'Indiquez le nom de votre weblog. Ce nom peut être modifié par la suite, si vous le souhaitez.',
    'Description' => 'Description', # Translate - Previous (1)
    'Enter a description for your weblog.' => 'Entrer une description pour votre weblog.',
    'Timezone:' => 'Fuseau horaire :',
    'Time zone not selected' => 'Vous n\'avez pas sélectionné de fuseau horaire',
    'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (Nouvelle-Zélande)',
    'UTC+12 (International Date Line East)' => 'UTC+12 (ligne internationale de changement de date)',
    'UTC+11' => 'UTC+11', # Translate - Previous (2)
    'UTC+10 (East Australian Time)' => 'UTC+10 (Australie Est)',
    'UTC+9.5 (Central Australian Time)' => 'UTC+9,5 (Australie Centre)',
    'UTC+9 (Japan Time)' => 'UTC+9 (Japon)',
    'UTC+8 (China Coast Time)' => 'UTC+8 (Chine littorale)',
    'UTC+7 (West Australian Time)' => 'UTC+7 (Australie Ouest)',
    'UTC+6.5 (North Sumatra)' => 'UTC+6,5 (Sumatra Nord)',
    'UTC+6 (Russian Federation Zone 5)' => 'UTC+6 (Fédération russe, zone 5)',
    'UTC+5.5 (Indian)' => 'UTC+5.5 (Inde)',
    'UTC+5 (Russian Federation Zone 4)' => 'UTC+5 (Fédération russe, zone 4)',
    'UTC+4 (Russian Federation Zone 3)' => 'UTC+4 (Fédération russe, zone 3)',
    'UTC+3.5 (Iran)' => 'UTC+3,5 (Iran)',
    'UTC+3 (Baghdad Time/Moscow Time)' => 'UTC+3 (Bagdad/Moscou)',
    'UTC+2 (Eastern Europe Time)' => 'UTC+2 (Europe de l\'Est)',
    'UTC+1 (Central European Time)' => 'UTC+1 (Europe centrale)',
    'UTC+0 (Universal Time Coordinated)' => 'UTC+0 (Temps universel coordoné)',
    'UTC-1 (West Africa Time)' => 'UTC-1 (Afrique de l\'Ouest)',
    'UTC-2 (Azores Time)' => 'UTC-2 (Açores)',
    'UTC-3 (Atlantic Time)' => 'UTC-3 (Atlantique)',
    'UTC-3.5 (Newfoundland)' => 'UTC-3,5 (Terre-Neuve)',
    'UTC-4 (Atlantic Time)' => 'UTC-4 (Atlantique)',
    'UTC-5 (Eastern Time)' => 'UTC-5 (Etats-Unis, heure de l\'Est)',
    'UTC-6 (Central Time)' => 'UTC-6 (Etats-Unis, heure centrale)',
    'UTC-7 (Mountain Time)' => 'UTC-7 (Etats-Unis, heure des rocheuses)',
    'UTC-8 (Pacific Time)' => 'UTC-8 (Etats-Unis, heure du Pacifique)',
    'UTC-9 (Alaskan Time)' => 'UTC-9 (Alaska)',
    'UTC-10 (Aleutians-Hawaii Time)' => 'UTC-10 (Hawaii)',
    'UTC-11 (Nome Time)' => 'UTC-11 (Nome)',
    'Select your timezone from the pulldown menu.' => 'Veuillez sélectionner votre fuseau horaire dans la liste.',
    'Default Weblog Display Settings' => 'Paramètres par défaut d\'affichage du weblog',
    'Entries to Display:' => 'Notes à afficher :',
    'Days' => 'Jours',
    'Select the number of days\' entries or the exact number of entries you would like displayed on your weblog.' => 'Sélectionnez le nombre exact de jours (notes des X derniers jours ) ou  le nombre de notes que vous souhaitez voir affichées sur votre weblogs.',
    'Entry Order:' => 'Ordre des notes :',
    'Ascending' => 'Croissant',
    'Descending' => 'Décroissant',
    'Select whether you want your posts displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Sélectionnez l\'ordre d\'affichage des notes, croissant (les plus anciennes en premier) ou décroissant (les plus récentes en premier).',
    'Comment Order:' => 'Ordre des commentaires :',
    'Select whether you want visitor comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Sélectionnez l\'ordre d\'affichage des commentaires publiés par les visiteurs : croissant (les plus anciens en premier) ou décroissant (les plus récents en premier).',
    'Excerpt Length:' => 'Longueur des extraits :',
    'Enter the number of words that should appear in an auto-generated excerpt.' => 'Entrez le nombre de mot à afficher pour les extraits de notes.',
    'Date Language:' => 'Langue de la date :',
    'Czech' => 'Tchèque',
    'Danish' => 'Danois',
    'Dutch' => 'Néerlandais',
    'English' => 'Anglais',
    'Estonian' => 'Estonien',
    'French' => 'Français',
    'German' => 'Allemand',
    'Icelandic' => 'Islandais',
    'Italian' => 'Italien',
    'Japanese' => 'Japonais',
    'Norwegian' => 'Norvégien',
    'Polish' => 'Polonais',
    'Portuguese' => 'Portugais',
    'Slovak' => 'Slovaque',
    'Slovenian' => 'Slovène',
    'Spanish' => 'Espagnol',
    'Suomi' => 'Finlandais',
    'Swedish' => 'Suédois',
    'Select the language in which you would like dates on your blog displayed.' => 'Sélectionnez la langue dans laquelle vous souhaitez afficher les dates sur votre weblog.',
    'Limit HTML Tags:' => 'Limiter les tags HTML :',
    'Use defaults' => 'Utiliser les valeurs par défaut',
    '([_1])' => '([_1])', # Translate - Previous (2)
    'Use my settings' => 'Utiliser mes paramétrages',
    'Specifies the list of HTML tags allowed by default when cleaning an HTML string (a comment, for example).' => 'Spécifie la liste des balises HTML autorisées par défaut lors du nettoyage d\'une chaîne HTML (un commentaire, par exemple).',
    'License' => 'Licence',
    'Your weblog is currently licensed under:' => 'Votre weblog est actuellement régi par :',
    'Change your license' => 'Changer la licence',
    'Remove this license' => 'Supprimer cette licence',
    'Your weblog does not have an explicit Creative Commons license.' => 'Votre weblog ne fait pas l\'objet d\'une licence B+ Creative Commons B explicite.',
    'Create a license now' => 'Créer une licence',
    'Select a Creative Commons license for the posts on your blog (optional).' => 'Choisissez une licence B+ Creative Commons B pour les notes de votre weblog (facultatif).',
    'Be sure that you understand these licenses before applying them to your own work.' => 'Nous vous recommandons de vous informer de la portée des clauses de cette licence avant de l\'appliquer à vos propres travaux.',
    'Read more.' => 'En savoir plus.',

    ## ./tmpl/cms/tag_table.tmpl
    'Date' => 'Date', # Translate - Previous (1)
    'IP Address' => 'Adresse IP',
    'Log Message' => 'Message du journal',

    ## ./tmpl/cms/cfg_entries_edit_page.tmpl
    'Default Entry Editor Display Options' => 'Options d\'affichage par défaut de l\'éditeur de Note',

    ## ./tmpl/cms/upload_complete.tmpl
    'Upload File' => 'Télécharger un fichier',
    'The file named \'[_1]\' has been uploaded. Size: [quant,_2,byte].' => 'Le fichier nommé \'[_1]\' a été chargé. Taille: [quant,_2,byte].',
    'Create a new entry using this uploaded file' => 'Créer une note à l\'aide de ce fichier téléchargé.',
    'Show me the HTML' => 'Afficher le code HTML',
    'Image Thumbnail' => 'Vignette',
    'Create a thumbnail for this image' => 'Créer une vignette pour cette image',
    'Width:' => 'Largeur:',
    'Pixels' => 'Pixels', # Translate - Previous (1)
    'Percent' => 'Pourcentage',
    'Height:' => 'Hauteur :',
    'Constrain proportions' => 'Contraindre les proportions',
    'Would you like this file to be a:' => 'Ce fichier doit être :',
    'Popup Image' => 'Image dans une fenêtre popup',
    'Embedded Image' => 'Image intégrée à la note',
    'Link' => 'Lien',

    ## ./tmpl/cms/bm_posted.tmpl
    'Your new entry has been saved to [_1]' => 'Votre nouvelle note a été enregistrée dans [_1]',
    ', and it has been posted to your site' => 'et a été publiée sur votre site',
    '. ' => '. ', # Translate - Previous (0)
    'View your site' => 'Voir votre site',
    'Edit this entry' => 'Modifier cette note',

    ## ./tmpl/cms/listing_panel.tmpl
    'Step [_1] of [_2]' => 'Etape  [_1] sur [_2]',
    'View All' => 'Tout afficher',
    'Go to [_1]' => 'Aller à [_1]',
    'Sorry, there were no results for your search. Please try searching again.' => 'Desolé, aucun résultat trouvé pour cette recherche. Merci d\'essayer à nouveau.',
    'Sorry, there is no data for this object set.' => 'Désolé, mais il n\'y a pas de données pour cet ensemble d\'objets.',
    'Back' => 'Retour',
    'Confirm' => 'Confirmer',

    ## ./tmpl/cms/delete_confirm.tmpl
    'Are you sure you want to permanently delete the [quant,_1,user] from the system?' => 'Etes-vous sûr de vouloir supprimer définitivement [quant,_1,user] du système?',
    'Are you sure you want to delete the [quant,_1,comment]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,commentaire] ?',
    'Are you sure you want to delete the [quant,_1,TrackBack]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,TrackBack] ?',
    'Are you sure you want to delete the [quant,_1,entry,entries]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,note,notes] ?',
    'Are you sure you want to delete the [quant,_1,template]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,modèle] ?',
    'Are you sure you want to delete the [quant,_1,category,categories]? When you delete a category, all entries assigned to that category will be unassigned from that category.' => 'Souhaitez-vous vraiment supprimer [quant,_1,catégorie,catégories] ? L\'association entre une note et une catégorie est perdue lorsque vous supprimez une catégorie.',
    'Are you sure you want to delete the [quant,_1,template] from the particular archive type(s)?' => 'Souhaitez-vous vraiment supprimer [quant,_1,modèle] de ce(s) type(s) d\'archive ?',
    'Are you sure you want to delete the [quant,_1,IP address,IP addresses] from your Banned IP List?' => 'Souhaitez-vous vraiment supprimer [quant,_1,adresse IP,adresses IP] de la liste des adresses IP bannies ?',
    'Are you sure you want to delete the [quant,_1,notification address,notification addresses]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,adresse pour avis,adresses pour avis] ?',
    'Are you sure you want to delete the [quant,_1,blocked item,blocked items]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,élément bloqué,éléments bloqués] ?',
    'Are you sure you want to delete the [quant,_1,weblog]? When you delete a weblog, all of the entries, comments, templates, notifications, and user permissions are deleted along with the weblog itself. Make sure that this is what you want, because this action is permanent.' => 'Souhaitez-vous vraiment supprimer [quant,_1,weblog] ? Lorsque vous supprimez un weblog, les notes, les commentaires, les modèles, les avis, et les permissions affectées aux utilisateurs sont également supprimé(e)s. Notez également que le résultat de cette action est définitif.',

    ## ./tmpl/cms/list_group.tmpl
    'Groups' => 'Groupes',
    'User Disabled' => 'Utilisateur désactivé',
    'Synchronize groups now' => 'Synchroniser les groupes maintenant',
    'You have successfully disabled the selected group(s).' => 'Vous avez désactivé avec succès les groupes sélectionnés.',
    'You have successfully enabled the selected group(s).' => 'Vous avez activé avec succès les groupes sélectionnés.',
    'You have successfully deleted the groups from the Movable Type system.' => 'Vous avez effacé avec succès les groupes de votre système Movable Type.',
    'You have successfully synchronized groups\' information with the external directory.' => 'Vous avez correctement synchronisé les groupe  avec le repertoire externe.',
    'Profile' => 'Profil',
    'Associations' => 'Associations', # Translate - Previous (1)
    'Add user to another group' => 'Ajouter un utilisateur à un autre groupe',
    'You can not add disabled users to groups.' => 'Vous ne pouvez pas ajouter un utilisateur désactivé à des groupes.', # Translate - New (8)
    'Add [_1] to another group' => 'Ajouter [_1] à un autre groupe',
    'Users' => 'Utilisateurs',
    'Create New Group' => 'Créer un nouveau groupe',

    ## ./tmpl/cms/dialog_select_groups.tmpl

    ## ./tmpl/cms/cfg_system_feedback.tmpl
    'Feedback Settings' => 'Paramétrages des Feedbacks',
    'This screen allows you to configure feedback and outbound TrackBack settings for the entire installation.  These settings override any similar settings for individual weblogs.' => 'Cet écran vous permet de configurer les paramètres des feedbacks et des TrackBacks sortants pour l\'ensemble de l\'installation. Ces paramètres priment sur les paramétrages que vous auriez pu faire sur un weblog donné.',
    'Your feedback preferences have been saved.' => 'Vos préférences feedback sont enregistrées.',
    'Feedback Master Switch' => 'Contrôle principal des Feedbacks',
    'Disable Comments' => 'Désactiver les commentaires',
    'Stop accepting comments on all weblogs' => 'Ne plus accepter les commentaires sur TOUS les weblogs',
    'This will override all individual weblog comment settings.' => 'Cette action prime sur tout paramétrage des commentaires mis en place au niveau de chaque weblog.',
    'Disable TrackBacks' => 'Désactiver les TrackBacks',
    'Stop accepting TrackBacks on all weblogs' => 'Ne plus accepter les TrackBacks sur TOUS les weblogs',
    'This will override all individual weblog TrackBack settings.' => 'Cette action prime sur tout paramétrage des TrackBacks mis en place au niveau de chaque weblog.',
    'Outbound TrackBack Control' => 'Contrôle des TrackBacks sortants',
    'Allow outbound TrackBacks to:' => 'Autoriser les TrackBacks sortant sur :',
    'Any site' => 'N\'importe quel site',
    'No site' => 'Aucun site',
    '(Disable all outbound TrackBacks.)' => '(Désactiver tous les TrackBacks sortants.)',
    'Only the weblogs on this installation' => 'Uniquement les weblogs sur cette installation',
    'Only the sites on the following domains:' => 'Uniquement les sites sur les domaines suivants :',
    'This feature allows you to limit outbound TrackBacks and TrackBack auto-discovery for the purposes of keeping your installation private.' => 'Cette fonctionnalité vous permet de limiter les TrackBacks sortants et la découverte automatique des TrackBacks pour conserver la confidentialité de votre installation.',

    ## ./tmpl/cms/cfg_entries.tmpl
    'New Entry Default Settings' => 'Paramètres par défaut des nouvelle notes',
    'This screen allows you to control default settings for new entries as well as your publicity and remote interface settings.' => 'Cet écran vous permet de contrôler les paramètres par défaut des nouvelles notes ainsi que la promotion et l\'interface de paramétrage à distance.',
    'Default Settings for New Entries' => 'Paramètres par défaut des nouvelles notes',
    'Post Status' => 'Etat de publication',
    'Specifies the default Post Status when creating a new entry.' => 'Spécifie l\'état de publication par défaut des nouvelles notes.',
    'Specifies the default Text Formatting option when creating a new entry.' => 'Spécifie l\'option par défaut de mise en forme du texte des nouvelles notes.',
    'Specifies the default Accept Comments setting when creating a new entry.' => 'Spécifie l\'option par défaut des commentaires acceptés lors de la création d\'une nouvelle note.',
    'Setting Ignored' => 'Paramétrage ignoré',
    'Note: This option is currently ignored since comments are disabled either weblog or system-wide.' => 'Note: Cette option est ignorée tant que les commentaires sont désactivés sur une note ou dans l\'ensemble du système.',
    'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Spécifie l\'option par défaut des TrackBacks acceptés lors de la création d\'une nouvelle note.',
    'Note: This option is currently ignored since TrackBacks are disabled either weblog or system-wide.' => 'Note: Cette option est ignorée tant que les TrackBacks sont désactivés sur une note ou sur l\'ensemble du système.',
    'Basename Length:' => 'Longueur du nom de base :',
    'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => 'Spécifier la longueur par défaut du nom de base. peut être comprise entre 15 et 250.',
    'Publicity/Remote Interfaces' => 'Publicité/Interfaces distantes',
    'Notify the following sites upon weblog updates:' => 'Notifier les sites suivants lors des mises à jour du weblog :',
    'Others:' => 'Autres :',
    '(Separate URLs with a carriage return.)' => '(Séparer les URLs avec un retour chariot.)',
    'When this weblog is updated, Movable Type will automatically notify the selected sites.' => 'Lors des mises à jour de ce weblog Movable Type notifiera automatiquement les sites sélectionnés.',
    'Setting Notice' => 'Paramétrage des informations',
    'Note: The above option may be affected since outbound pings are constrained system-wide.' => 'Attention : L\'option ci-dessous peut être affectée si les pings sortant sont limités dans le système.',
    'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Attention : Cette option est ignorée car les pings sortants sont désactivés globalement.',
    'Recently Updated Key:' => 'Clé mise à jour récemment :',
    'If you have received a recently updated key (by virtue of your purchase), enter it here.' => 'Si vous avez reçu une mise à jour de la clef, la saisir ici.',
    'TrackBack Auto-Discovery' => 'Découverte automatique des TrackBacks',
    'Enable External TrackBack Auto-Discovery' => 'Activer Auto-découverte Trackback Externe',
    'Note: The above option is currently ignored since outbound pings are disabled system-wide.' => 'Attention: l\'option ci-dessus est ignorée si les pings sortants sont désactivés dans le système',
    'Enable Internal TrackBack Auto-Discovery' => 'Activer Auto-découverte Trackback Interne',
    'If you turn on auto-discovery, when you write a new post, any external links will be extracted and the appropriate sites automatically sent TrackBacks.' => 'Si vous activez la découverte automatique, quand vous écrirez une nouvelle note, les liens externes seront extraits et les sites concernés recevront automatiquement un TrackBack.',

    ## ./tmpl/cms/template_actions.tmpl
    'template' => 'modèle',
    'templates' => 'modèles',

    ## ./tmpl/cms/recover.tmpl
    'Your password has been changed, and the new password has been sent to your email address ([_1]).' => 'Votre mot de passe a été modifié et a été envoyé à votre adresse e-mail([_1]).',
    'Enter your Movable Type username:' => 'Indiquez votre nom d\'utilisateur Movable Type :',
    'Enter your password recovery word/phrase:' => 'Enter your password recovery word/phrase :',
    'Recover' => 'Récupérer',

    ## ./tmpl/cms/list_entry.tmpl
    'Your entry has been deleted from the database.' => 'Votre note a été supprimée de la base de données.',
    'Entry Feed' => 'Flux de la note',
    'Entry Feed (Disabled)' => 'Flux de la note (Désactivé)',
    'Show unpublished entries.' => 'Afficher les notes non publiées.',
    '(Showing all entries.)' => '(Affichage de toutes les notes).',
    'Showing only entries where [_1] is [_2].' => 'En affichant les notes où [_1] est [_2].',
    'entries.' => 'les notes.',
    'entries where' => 'notes dont',
    'user' => 'utilisateur',
    'tag (exact match)' => 'le tag (exact)',
    'tag (fuzzy match)' => 'le tag (fuzzy match)',
    'category' => 'catégorie',
    'scheduled' => 'programmé',
    'Select A User:' => 'Sélectionner un utilisateur',
    'User Search...' => 'Recherche utilisateur...',
    'Recent Users...' => 'Utilisateurs récents...',
    'No entries could be found.' => 'Aucune note n\'a pu être trouvée.',

    ## ./tmpl/cms/list_template.tmpl
    'Index Templates' => 'Modèles d\'index',
    'Index templates produce single pages and can be used to publish Movable Type data or plain files with any type of content. These templates are typically rebuilt automatically upon saving entries, comments and TrackBacks.' => 'Les modèles d\'Index génèrent des pages uniques et peuvent être utilisés pour publier des données Movable Type ou des fichiers quel que soit leur contenu. Ces modèles sont généralement reconstruits automatiquement en sauvegardant les notes, commentaires ou TrackBacks.',
    'Archive Templates' => 'Modèles d\'archives',
    'Archive templates are used for producing multiple pages of the same archive type.  You can create new ones and map them to archive types on the publishing settings screen for this weblog.' => 'Les modèles d\'archives sont utilisés pour produire des pages multiples d\'un même type d\'archives. Vous pouvez en créer de nouveaux et les relier aux types  d\'archives sur l\'écran des paramètres de publication de ce weblog.',
    'System Templates' => 'Modèles Système',
    'System templates specify the layout and style of a small number of dynamic pages which perform specific system functions in Movable Type.' => 'Les modèles Systèmes spécifient la mise en page d\'un petit nombre de pages dynamiques qui réalisent des fonctions système spécifiques à Movable Type.',
    'Template Modules' => 'Modules de modèles',
    'Template modules are mini-templates that produce nothing on their own but instead can be included into other templates.  They are excellent for duplicated content (e.g. header or footer content) and can contain template tags or just static text.' => 'Les modules de modèles sont des mini-modèles qui ne produisent rien en soi mais peuvent être inclus dans d\'autres modèles. Ils sont très utiles pour dupliquer un contenu (par exemple le contenu des entêtes et pieds de page) et peuvent inclure des tags de modèles ou simplement du texte.',
    'You have successfully deleted the checked template(s).' => 'Les modèles sélectionnés ont été supprimés.',
    'Your settings have been saved.' => 'Vos paramètres ont été enregistrés.',
    'Indexes' => 'Index',
    'System' => 'Système',
    'Modules' => 'Modules', # Translate - Previous (1)
    'Go to Publishing Settings' => 'Aller aux paramètres de publication',
    'Create new index template' => 'Créer un nouveau modèle d\'index',
    'Create New Index Template' => 'Créer un nouveau Modèle d\'Index',
    'Create new archive template' => 'Créer un modèle d\'archive',
    'Create New Archive Template' => 'Créer un nouveau Modèle d\'Archives',
    'Create new template module' => 'Créer un module de modèle',
    'Create New Template Module' => 'Créer un nouveau Module de Modèle',
    'Template Name' => 'Nom du modèle',
    'Output File' => 'Fichier de sortie',
    'Dynamic' => 'Dynamique',
    'Linked' => 'Lié',
    'Built w/Indexes' => 'Actualisé avec les indexs',
    'Yes' => 'Oui',
    'No' => 'Non',
    'View Published Template' => 'Voir les modèles publiés',
    'No index templates could be found.' => 'Aucun Modèle d\'Index n\'a été trouvé.',
    'No archive templates could be found.' => 'Aucun Modèle d\'Archives n\'a été trouvé.',
    'No template modules could be found.' => 'Aucun Module de Modèle n\'a été trouvé.',

    ## ./tmpl/cms/list_tags.tmpl
    'Your tag changes and additions have been made.' => 'Votre changement de tag et les compléments ont été faits.',
    'You have successfully deleted the selected tags.' => 'Vous avez effacé correctement les tags sélectionnés.',
    'Tag Name' => 'Nom du Tag',
    'Click to edit tag name' => 'Cliquez pour modifier le nom du tag',
    'Rename' => 'Changer le nom',
    'Show all entries with this tag' => 'Afficher toutes les notes pour ce tag',
    '[quant,_1,entry,entries]' => '[quant,_1,note,notes]',
    'No tags could be found.' => 'Aucun tag n\'a été trouvé.',

    ## ./tmpl/cms/error.tmpl
    'An error occurred:' => 'Une erreur s\'est produite :',

    ## ./tmpl/cms/edit_author.tmpl
    'Your Web services password is currently' => 'Votre mot de passe est actuellement',
    'User Profile' => 'Profil de l\'utilisateur',
    'Create New User' => 'Créer un nouvel utilisateur',
    'This profile has been updated.' => 'Ce profil a été mis à jour.',
    'Movable Type Enterprise has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.' => 'Movable Type Enterprise vient de tenter de désactiver votre compte pendant la synchronisation avec l\'annuaire externe. Il est probable que les paramètres du système de gestion externe des utilisateurs soient incorrectes. Merci de corriger avant de poursuivre.', # Translate - New (32)
    'Personal Weblog' => 'Weblog personnel',
    'Create personal weblog for user' => 'Créer un weblog personnel pour l\'utilisateur',
    'System Permissions' => 'Autorisations système',
    'System Administrator' => 'Administrateur Système',
    'Create Weblogs' => 'Créer des Weblogs',
    'View Activity Log' => 'Afficher le journal des activités',
    'Username' => 'Nom d\'utilisateur',
    'Your login name.' => 'Votre nom d\'utilisateur.',
    'The name used by this user to login.' => 'Le nom utilisé par cet Utilisateur pour s\'enregistrer.',
    'Display Name' => 'Afficher le nom',
    'Your published name.' => 'Votre nom publié.',
    'The user\'s published name.' => 'Nom publié de l\'utilisateur.',
    'Your email address.' => 'Votre adresse email.',
    'The user\'s email address.' => 'Adresse email de l\'utilisateur.',
    'Website URL' => 'URL du site',
    'The URL of your website. (Optional)' => 'URL de votre site internet (en option)',
    'The URL of this user\'s website. (Optional)' => 'L\'adresse du site internet de l\'utilisateur (en option)',
    'Language' => 'Langue',
    'Your preferred language.' => 'Langue de préférence.',
    'The user\'s preferred language.' => 'Langue de préférence de l\'utilisateur.',
    'Tag Delimiter:' => 'Séparateur de Tag :',
    'Comma' => 'Virgule',
    'Space' => 'Espace',
    'Your preferred delimiter for entering tags.' => 'Votre séparateur préféré pour séparer les tags entre eux.',
    'The user\'s preferred delimiter for entering tags.' => 'Séparateur de tags préféré par l\'utilisateur.',
    'Password' => 'Mot de passe',
    'Current Password:' => 'Mot de passe actuel :',
    'Enter the existing password to change it.' => 'Entrez le mot de passe actuel pour le changer.',
    'New Password:' => 'Nouveau Mot de Passe :',
    'Initial Password' => 'Mot de passe initial',
    'Select a password for yourself.' => 'Sélectionnez un mot de passe pour vous.',
    'Select a password for the user.' => 'Sélectionnez un mot de passe pour l\'utilisateur.',
    'Password Confirm:' => 'Confirmation du Mot de Passe:',
    'Repeat the password for confirmation.' => 'Répetez la confirmation de Mot de passe.',
    'Password recovery word/phrase' => 'Mot/Expression pour retrouver un mot de passe',
    'This word or phrase will be required to recover the password if you forget it.' => 'Ce mot ou cette expression vous seront demandés pour retrouver le mot de passe si vous l\'oubliez.',
    'This word or phrase will be required to recover the password if the user forgets it.' => 'Ce mot ou cette expression vous seront demandés pour retrouver le mot de passe d\'un utilisateur qui l\'aurait oublié.',
    'Web Services Password:' => 'Mot de passe Service Web :',
    'Reveal' => 'Révéler',
    'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'Pour utilisation par les flux d\'activité et avec les clients XML-RPC ou ATOM.',
    'Their external user ID is [_1].' => 'Leur ID utilisateur externe est [_1].',
    'Display Name:' => 'Nom affiché:',
    'Email Address:' => 'Adresse Email:',
    'Save this user (s)' => 'Sauvegarder cet utilisateur (s)',

    ## ./tmpl/cms/author_bulk.tmpl
    'Create/Edit/Delete Users in bulk' => 'Créer/Editer/Supprimer des utilisateurs par groupe',
    'Upload source file' => 'Télécharger le fichier source',
    'Specify the CSV-formatted source file for upload.' => 'Indiquer le fichier source au format CSV à télécharger.',
    'Source File Encoding (optional):' => 'Encodage du fichier source (optionel):',
    'Upload' => 'Télécharger',
    'Upload (u)' => 'Télécharger (u)',

    ## ./tmpl/cms/notification_table.tmpl
    'Date Added' => 'Ajouté(e) le',

    ## ./tmpl/cms/overview-left-nav.tmpl
    'List Weblogs' => 'Liste des Weblogs',
    'List Users and Groups' => 'Lister les Utilisateurs et les Groupes',
    'Users &amp; Groups' => 'Utilisateurs &amp; Groupes',
    'List Associations and Roles' => 'Lister les associations et les roles',
    'Privileges' => 'Privilèges',
    'List Plugins' => 'Liste des Plugins',
    'Aggregate' => 'Multi-Blogs',
    'List Tags' => 'Liste de Tags',
    'Configure' => 'Configurer',
    'Edit System Settings' => 'Editer les Paramètres Système',
    'Utilities' => 'Utilitaires',
    'Search &amp; Replace' => 'Chercher &amp; Remplacer',
    'Show Activity Log' => 'Afficher les logs d\'activité',
    'Activity Log' => 'Journal des activités',

    ## ./tmpl/cms/copyright.tmpl

    ## ./tmpl/cms/view_log.tmpl
    'Are you sure you want to reset activity log?' => 'Etes-vous certain de vouloir effacer votre journal (log) d\'activité ?',
    'The Movable Type activity log contains a record of notable actions in the system.' => 'Le Journal des Activités de Movable Type contient un enregistrement des actions principales dans le système.',
    'All times are displayed in GMT[_1].' => 'Toutes les heures sont affichées en GMT[_1].',
    'All times are displayed in GMT.' => 'Toutes les heures sont affichées en GMT.',
    'The activity log has been reset.' => 'Le journal des activités a été réinitialisé.',
    'Download CSV' => 'Télécharger CSV',
    'Show only errors.' => 'N\'afficher que les erreurs.',
    '(Showing all log records.)' => '(Affichage de tous les enregistrements log.)',
    'Showing only log records where' => 'Uniquement les logs dont',
    'Filtered CSV' => 'CSV filtrés',
    'Filtered' => 'Filtrés',
    'Activity Feed' => 'Flux d\'activité',
    'log records.' => 'les logs.',
    'log records where' => 'les logs dont',
    'level' => 'le statut',
    'classification' => 'classification', # Translate - Previous (1)
    'Security' => 'Sécurité',
    'Information' => 'Information', # Translate - Previous (1)
    'Debug' => 'Debug', # Translate - Previous (1)
    'Security or error' => 'Sécurité ou erreur',
    'Security/error/warning' => 'Sécurité/erreur/mise en garde',
    'Not debug' => 'Pas débugué',
    'Debug/error' => 'Debug/erreur',
    'No log records could be found.' => 'Aucun enregistrement log n\'a été trouvé.',

    ## ./tmpl/cms/group_member_actions.tmpl
    'member' => 'membres',
    'Remove selected members ()' => 'Supprimer les membres sélectionnés ()',

    ## ./tmpl/cms/tag_actions.tmpl
    'tag' => 'tag', # Translate - Previous (1)
    'tags' => 'tags', # Translate - Previous (1)
    'Delete selected tags (x)' => 'Effacer les tags sélectionnés (x)',

    ## ./tmpl/cms/rebuilding.tmpl
    'Rebuild' => 'Actualiser',
    'Rebuilding [_1]' => 'Actualisation de [_1]',
    'Rebuilding [_1] pages [_2]' => 'Actualisation des pages [_1] [_2]',
    'Rebuilding [_1] dynamic links' => 'Recontruction [_1] des liens dynamiques',
    'Rebuilding [_1] pages' => 'Actualisation des pages [_1]',

    ## ./tmpl/cms/upload_confirm.tmpl
    'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'Le fichier \'[_1]\' existe déjà Souhaitez-vous le remplacer ?',

    ## ./tmpl/cms/handshake_return.tmpl

    ## ./tmpl/cms/junk_results.tmpl
    'Find Junk' => 'Trouver indésirable(s)',
    'The following items may be junk. Uncheck the box next to any items are NOT junk and hit JUNK to continue.' => 'Les élements suivants sont peut-être indésirables. Décochez les cases des élements qui ne sont pas indésirables et cliquez sur le bouton pour continuer.',
    'To return to the comment list without junking any items, click CANCEL.' => 'Pour retourner à la liste des commentaires sans sélectionner d\'élement indésirables clliquez sur annuler.',
    'Commenter' => 'Auteur de commentaires',
    'Comment' => 'Commentaire',
    'IP' => 'IP', # Translate - Previous (1)
    'Junk' => 'Indésirable',
    'Approved' => 'Approuvé',
    'Banned' => 'Banni',
    'Registered Commenter' => 'Auteur de commentaires inscrit',
    'comment' => 'commentaire',
    'comments' => 'commentaires',
    'Return to comment list' => 'Retourner à la liste des commentaires',

    ## ./tmpl/cms/import_end.tmpl
    'All data imported successfully!' => 'Toutes les données ont été importées avec succès !',
    'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Assurez vous d\'avoir bien enlevé les fichiers importés du dossier \'import\', pour éviter une ré-importation des mêmes fichiers à l\'avenir .',
    'An error occurred during the import process: [_1]. Please check your import file.' => 'Une erreur s\'est produite pendant le processus: [_1]. Merci de vérifier vos fichiers import.',

    ## ./tmpl/cms/role_actions.tmpl
    'Delete selected roles (x)' => 'Effacer les roles séelctionnés (x)',
    'role' => 'rôle',
    'roles' => 'rôles',

    ## ./tmpl/cms/admin.tmpl
    'System Stats' => 'Statistiques système',
    'Active Users' => 'Utilisateurs Actifs',
    'Essential Links' => 'Liens essentiels',
    'Movable Type Home' => 'Accueil Movable Type',
    'Plugin Directory' => 'Annuaire des Plugins',
    'Support and Documentation' => 'Support et Documentation',
    'https://secure.sixapart.com/t/account' => 'https://secure.sixapart.com/t/account?portal=fr',
    'Your Account' => 'Votre compte',
    'https://secure.sixapart.com/t/help?__mode=edit' => 'https://secure.sixapart.com/t/help?__mode=edit&portal=fr',
    'Open a Help Ticket' => 'Ouvrir un Ticket d\'Aide',
    'Paid License Required' => 'Réservé aux licences payantes',
    'http://www.sixapart.com/movabletype/' => 'http://www.movabletype.fr',
    'http://www.sixapart.com/pronet/plugins/' => 'http://www.sixapart.com/pronet/plugins/', # Translate - Previous (6)
    'http://www.sixapart.com/movabletype/kb/' => 'http://www.sixapart.com/movabletype/kb/',
    'Knowledge Base' => 'Base de connaissance',
    'http://www.sixapart.com/pronet/' => 'http://www.sixapart.com/pronet/', # Translate - Previous (5)
    'Professional Network' => 'Réseau Professionnel',
    'From this screen, you can view information about and manage many aspects of your system across all weblogs.' => 'Cette page diffuse les informations générales concernant vos weblogs et le système dans son ensemble.',
    'Movable Type News' => 'Infos Movable Type',

    ## ./tmpl/cms/entry_table.tmpl
    'User' => 'Utilisateur',
    'Only show unpublished entries' => 'N\'afficher que les notes non publiées',
    'Only show published entries' => 'Afficher uniquement les notes publiées',
    'Only show scheduled entries' => 'N\'afficher que les notes programmées dans le futur',
    'None' => 'Aucune',

    ## ./tmpl/cms/header-dialog.tmpl

    ## ./tmpl/cms/pinged_urls.tmpl
    'Here is a list of the previous TrackBacks that were successfully sent:' => 'Voici la liste des TrackBacks envoyés avec succès :',
    'Here is a list of the previous TrackBacks that failed. To retry these, include them in the Outbound TrackBack URLs list for your entry.:' => 'Voici la liste des Trackbacks précédents qui ont échoué. Pour essayer à nouveau, il faut les inclure dans la liste des URLs de TrackBacks sortants de votre note :',

    ## ./tmpl/cms/dialog_grant_role.tmpl
    'You need to create some roles.' => 'Vous devez créer des roles.', # Translate - New (6)
    'Before you can do this, you need to create some roles. <a href=' => 'Avant de pouvoir faire cela, vous devez créer des roles. <a href=',
    'You need to create some groups.' => 'Vous devez créer des groupes.', # Translate - New (6)
    'Before you can do this, you need to create some groups. <a href=' => 'Avant de pouvoir faire cela, vous devez créer des groupes. <a href=',
    'You need to create some users.' => 'Vous devez créer des utilisateurs.', # Translate - New (6)
    'Before you can do this, you need to create some users. <a href=' => 'Avant de pouvoir faire cela, vous devez créer des utilisateurs. <a href=',
    'You need to create some weblogs.' => 'Vous devez créer des weblogs.', # Translate - New (6)
    'Before you can do this, you need to create some weblogs. <a href=' => 'Avant de pouvoir faire cela, vous devez créer des weblogs. <a href=',

    ## ./tmpl/cms/edit_admin_permissions.tmpl
    'Permissions' => 'Autorisations',
    'Your changes to [_1]\'s permissions have been saved.' => 'Vos modifications des autorisations accordés à  [_1] a été enregistré.',
    '[_1] has been successfully added to [_2].' => '[_1] a été ajouté(e) avec succès à [_2].',
    'General Permissions' => 'Autorisations générales',
    'User can create weblogs' => 'L\'utilisateur peut créer un weblog',
    'User can view activity log' => 'L\'utilisateur peut afficher le journal des activités',
    'Check All' => 'Sélectionner tout',
    'Uncheck All' => 'Désélectionner tout',
    'Unheck All' => 'Tout décocher',
    'Add user to an additional weblog:' => 'Ajouter l\'utilisateur à un weblog supplémentaire :',
    'Select a weblog' => 'Sélectionnez un weblog',
    'Add' => 'Ajouter',
    'Save permissions for this user (s)' => 'Enregistrer les autorisations accordées à cet utilisateur',

    ## ./tmpl/cms/edit_group.tmpl
    'Group Profile' => 'Profil du Groupe',
    'Group Disabled' => 'Groupe Désactivé',
    'Group profile has been updated.' => 'Profil du Groupe mis à jour.',
    'Members' => 'Membres',
    'LDAP Group ID' => 'ID LDAP du groupe', # Translate - New (3)
    'The LDAP directory ID for this group.' => 'L\'ID de ce groupe dans l\'annuaire LDAP.', # Translate - New (7)
    'The name used for identifying this group.' => 'Le nom utilisé pour identifier ce groupe.',
    'The display name for this group.' => 'Le nom affiché pour ce groupe.',
    'Status of group in the system. Disabling a group removes its members\' access to the system but preserves their content and history.' => 'Statut du groupe dans le système.En désactivant un groupe vous enlevez à ses membres l\'accès au système mais vous préservez le contenu et l\'historique',
    'Enter a description for your group.' => 'Saisissez une description pour ce groupe.',
    'Created by' => 'Creé par',
    'Created on' => 'Crée le',
    'Save this group (s)' => 'Sauvegarder ce groupe (s)',

    ## ./tmpl/cms/log_actions.tmpl
    'Reset Activity Log' => 'Réinitialiser le journal des activités',

    ## ./tmpl/cms/group_table.tmpl
    'Only show enabled groups' => 'Ne montrer que les groupes activés',
    'Only show disabled groups' => 'Ne montrer que les groupes désactivés',

    ## ./tmpl/cms/rebuild_confirm.tmpl
    'Select the type of rebuild you would like to perform. Note: This will not rebuild any templates you have chosen to not automatically rebuild with index templates.' => 'Selectionnez le type de reconstruction que vous voulez effectuer. Attention: Ceci ne reconstruira pas les modèles que vous avez choisi de ne pas reconstruire automatiquement avec les index d\'modèle',
    '(Click the Cancel button if you do not want to rebuild any files.)' => '(Cliquez sur le bouton Annuler si vous ne voulez pas reconstruire de fichiers.)',
    'Rebuild All Files' => 'Actualiser tous les fichiers',
    'Index Template: [_1]' => 'Modèle d\'index: [_1]',
    'Rebuild Indexes Only' => 'Actualiser les index uniquement',
    'Rebuild [_1] Archives Only' => 'Actualiser les archives [_1] uniquement',
    'Rebuild (r)' => 'Reconstruire (r)',

    ## ./tmpl/cms/upgrade.tmpl
    'Time to Upgrade!' => 'Il est temps de mettre à jour !',
    'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'La version Perl installée sur votre serveur ([_1]) es antérieure à la version minimale nécessaire ([_2]).',
    'Do you want to proceed with the upgrade anyway?' => 'Voulez-vous quand même continuer la mise a jour ?',
    'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Une nouvelle version de Movable Type a été installée. Nous avons besoin de faire quelques manipulations complémentaires pour mettre à jour votre base de données.',
    'In addition, the following Movable Type plugins require upgrading or installation:' => 'De plus, les plugins Movable Type suivants nécéssitent une mise à jour ou une installation :',
    'The following Movable Type plugins require upgrading or installation:' => 'Les plugins Movable Type suivants nécéssitent une mise à jour ou une installation :',
    'Version [_1]' => 'Version [_1]', # Translate - Previous (2)
    'Begin Upgrade' => 'Commencer la Mise à Jour',
    'Upgrade Check' => 'Vérification des mises à jour',
    'Your Movable Type installation is already up to date.' => 'Votre installation Movable Type est déjà à jour.',
    'Return to Movable Type' => 'Retourner à Movable Type',

    ## ./tmpl/cms/reload_opener.tmpl

    ## ./tmpl/cms/dialog_grant_role_rows.tmpl

    ## ./tmpl/cms/blog_table.tmpl

    ## ./tmpl/cms/notification_actions.tmpl
    'notification address' => 'adresse de notification',
    'notification addresses' => 'adresses de notification',
    'Delete selected notification addresses (x)' => 'Effacer les adresses de notification sélectionnées (x)',

    ## ./tmpl/cms/dialog_select_weblog.tmpl

    ## ./tmpl/cms/list_association.tmpl
    'You have successfully removed the association(s).' => 'Vous avez enlevé les associations avec succès.',
    'You have successfully created the association(s).' => 'Vous avez crée avec succès les association(s).',
    'Add user to a weblog' => 'Ajouter un utilisateur à un weblog',
    'You can not create associations for disabled users.' => 'Vous ne pouvez créer des associations pour les utilisateurs désactivés.', # Translate - New (8)
    'Add [_1] to a weblog' => 'Ajouter [_1] à un weblog',
    'Add group to a weblog' => 'Ajouter un groupe à un weblog',
    'You can not create associations for disabled groups.' => 'Vous ne pouvez créer des associations pour les groupes désactivés.', # Translate - New (8)
    'Users/Groups' => 'Utilisateurs/Groupes',
    'Assign role to a new group' => 'Attribuer un rôle à un nouveau Groupe',
    'Assign Role to Group' => 'Attribuer un rôle au groupe',
    'Assign role to a new user' => 'Attribuer une rôle à un nouvel utilisateur',
    'Assign Role to User' => 'Attribuer un rôle à l\'utilisateur',
    'Roles' => 'Roles', # Translate - Previous (1)
    'Add a group to this weblog' => 'Ajouter un groupe à un weblog',
    'Add a user to this weblog' => 'Ajouter un utilisateur à ce weblog',
    'Create a Group Association' => 'Créer une Association Groupe',
    'Create a User Association' => 'Créer une Association Utilisateur',
    'User/Group' => 'Utilisateur/Groupe',
    'Role' => 'Rôle',
    'In Weblog' => 'Dans le Weblog',
    'Created By' => 'Créé par',
    'Created On' => 'Crée le',
    'No associations could be found.' => 'Aucune association n\'a été trouvée.',

    ## ./tmpl/cms/cc_return.tmpl

    ## ./tmpl/cms/login.tmpl
    'Your Movable Type session has ended. If you wish to log in again, you can do so below.' => 'Votre session Movable Type a été fermée. Pour ouvrir une nouvelle session voir ci-dessous.',
    'Your Movable Type session has ended. Please login again to continue this action.' => 'Votre session Movable Type a expiré. Merci de vous enregistrer à nouveau pour poursuivre.',
    'Your Movable Type session has ended.' => 'Votre session Movable Type a été fermée.',
    'Remember me?' => 'Mémoriser les informations de connexion ?',
    'Log In' => 'Connexion',
    'Forgot your password?' => 'Vous avez oublié votre mot de passe ?',

    ## ./tmpl/cms/list_ping.tmpl
    'The selected TrackBack(s) has been published.' => 'Le(s) TrackBack(s) sélectionné(s) ont été publié(s).',
    'All junked TrackBacks have been removed.' => 'Tous les Trackbcks indésirables on été enlevés.',
    'The selected TrackBack(s) has been unpublished.' => 'Le(s) TrackBack(s) sélectionné(s) ont été enlevé(s) de la publication.',
    'The selected TrackBack(s) has been junked.' => 'Le(s) TrackBack(s) sélectionné(s) sont marqués indésirable(s).',
    'The selected TrackBack(s) has been unjunked.' => 'Le(s) TrackBack(s) sélectionné(s) ne sont plus marqué(s) indésirable(s).',
    'The selected TrackBack(s) has been deleted from the database.' => 'Le(s) TrackBack(s) sélectionné(s) ont été supprimé(s) de la base de données.',
    'No TrackBacks appeared to be junk.' => 'Aucun TrackBack n\'est marqué indésirable.',
    'Junk TrackBacks' => 'TrackBacks indésirables',
    'Trackback Feed' => 'Flux Trackback',
    'Trackback Feed (Disabled)' => 'Flux Trackback (inactif)',
    'Show unpublished TrackBacks.' => 'Afficher les TrackBacks non publiés.',
    '(Showing all TrackBacks.)' => '(Affiche tous les TrackBacks.)',
    'Showing only TrackBacks where [_1] is [_2].' => 'Affichage uniquement des TrackBacks où [_1] est [_2].',
    'TrackBacks.' => 'les TrackBacks.',
    'TrackBacks where' => 'les TrackBacks dont',
    'No TrackBacks could be found.' => 'Aucun TrackBack n\'a été trouvé.',
    'No junk TrackBacks could be found.' => 'Aucun TrackBack indésirable n\'a été trouvé.',

    ## ./tmpl/cms/recover_password_result.tmpl
    'Recover Passwords' => 'Retrouver les mots de passe',
    'No users were selected to process.' => 'Aucun utilisateur sélectionné pour l\'opération.',

    ## ./tmpl/cms/feed_link.tmpl
    'Activity Feed (Disabled)' => 'Flux d\'activité (Désactivé)',

    ## ./tmpl/cms/ping_actions.tmpl
    'to publish' => 'pour publier',
    'Publish' => 'Publier',
    'Publish selected TrackBacks (p)' => 'Publier les TrackBacks sélectionnés (p)',
    'Delete selected TrackBacks (x)' => 'Effacer les TrackBacks sélectionnés (x)',
    'Junk selected TrackBacks (j)' => 'Jeter les TrackBacks sélectionnés (j)',
    'Not Junk' => 'Non Indésirable',
    'Recover selected TrackBacks (j)' => 'Retrouver les TrackBacks sélectionnés (j)',
    'Are you sure you want to remove all junk TrackBacks?' => 'Etes-vous certain de vouloir supprimer tous les TrackBacks indésirables ?',
    'Empty Junk Folder' => 'Vider le Dossier Indésirables',
    'Deletes all junk TrackBacks' => 'Effacer tous les TrackBacks indésirables',
    'Ban This IP' => 'Bannir cette adresse IP',

    ## ./tmpl/cms/ping_table.tmpl
    'From' => 'De',
    'Target' => 'Cible',
    'Only show published TrackBacks' => 'Afficher uniquement les TrackBacks publiés',
    'Only show pending TrackBacks' => 'Afficher uniquement les TrackBacks en attente',
    'Edit this TrackBack' => 'Editer ce TrackBack',
    'Edit TrackBack' => 'Editer les  TrackBacks',
    'Go to the source entry of this TrackBack' => 'Aller à la note à l\'orgine de ce TrackBack',
    'View the [_1] for this TrackBack' => 'Voir [_1] pour ce TrackBack',
    'Search for all comments from this IP address' => 'Rechercher tous les commentaires associés à cette adresse IP',

    ## ./tmpl/cms/dialog_select_users.tmpl

    ## ./tmpl/cms/log_table.tmpl
    'IP: [_1]' => 'IP : [_1]',

    ## ./tmpl/cms/edit_profile.tmpl
    'Your changes to [_1]\'s profile have been saved.' => 'Vos changement sur le profil de [_1] ont été enregistrés.',
    'A new password has been generated and sent to the email address [_1].' => 'Un nouveau mot de passe a été créé et envoyé à l\'adresse [_1].',
    'Status of user in the system. Disabling a user removes their access to the system but preserves their content and history.' => 'Statut de l\'utilisateur dans le système. En désactivant un utilisateur, vous supprimez son accès au système mais ne détruisez pas ses contenus et son historique ',
    'Save profile for this user (s)' => 'Enregistrer le profil pour cet utilisateur',
    'Password Recovery' => 'Récupération de mot de passe',

    ## ./tmpl/cms/edit_commenter.tmpl
    'Commenter Details' => 'Détails sur l\'auteur de commentaires',
    'The commenter has been trusted.' => 'L\'auteur de commentaires est fiable.',
    'The commenter has been banned.' => 'L\'auteur de commentaires a été banni.',
    'View all comments with this name' => 'Afficher tous les commentaires associés à ce nom',
    'Identity' => 'Identité',
    'Email' => 'Adresse email',
    'Withheld' => 'Retenu',
    'View all comments with this email address' => 'Afficher tous les commentaires associés à cette adresse email',
    'View all comments with this URL address' => 'Afficher tous les commentaires associés à cette URL',
    'Trusted' => 'Fiable',
    'Blocked' => 'Bloqué',
    'Authenticated' => 'Authentifié',
    'View all commenters with this status' => 'Afficher tous les auteurs de commentaires ayant ce statut',

    ## ./tmpl/cms/edit_permissions.tmpl
    'User Permissions' => 'Autorisations des Utilisateurs',

    ## ./tmpl/cms/create_author_bulk_end.tmpl
    'All users updated successfully!' => 'Tous les utilisateurs ont été mis à jour avec succès!',
    'An error occurred during the updating process. Please check your CSV file.' => 'Une erreur s\'est produite pendant la mise à jour.  Merci de vérifier votre fichier CSV.',

    ## ./tmpl/cms/author_actions.tmpl
    'users' => 'utilisateurs',
    'Enable selected users (e)' => 'Activer les utilisateurs sélectionnés (e)',
    'Disable selected users (d)' => 'Désactiver les utilisateurs sélectionnés (d)',

    ## ./tmpl/cms/list_role.tmpl
    'You have successfully deleted the role(s).' => 'Vous avez supprimé avec succès le(s) rôle(s).',
    'Grant a new role' => 'Attribuer un nouveau rôle',
    'Grant another role to [_1]' => 'Attribuer un autre rôle à [_1]',
    'Create New Role' => 'Créer un Nouveau rôle',
    'Via Group' => 'Via le Groupe',
    'Role Is Active' => 'Le role est actif',
    'Role Not Being Used' => 'Le role n\'est pas utilisé',
    'No roles could be found.' => 'Aucun role trouvé.',

    ## ./tmpl/cms/install.tmpl
    'Welcome to Movable Type Enterprise!' => 'Bienvenue sur Movable Type Entreprise!',
    'Do you want to proceed with the installation anyway?' => 'Voulez-vous tout de même poursuivre l\'installation ?',
    'Before you can begin blogging, we need to complete your installation by initializing your database.' => 'Avant de commencer à pouvoir bloguer vous devez terminer votre installation en initialisant votre base de données.',
    'You will need to select a username and password for the administrator account.' => 'Vous devrez choisir un nom d\'utilisateur et un mot de passe pour l\'administrateur du compte.',
    'To proceed, you must authenticate properly with your LDAP server.' => 'Pour poursuivre, vous devez vous anthentifier correctement auprès de votre serveur LDAP.',
    'Select a password for your account.' => 'Selectionnez un Mot de Passe pour votre compte.',
    'Password recovery word/phrase:' => 'Phrase pour la récupération du mot de passe :',
    'This word or phrase will be required to recover your password if you forget it.' => 'Ce mot ou cette expression vous seront nécessaires pour retrouver votre mot de passe. Ne les oubliez pas.',
    'Username:' => 'Nom d\'utilisateur:',
    'Your LDAP username.' => 'Votre nom d\'utilisateur LDAP.',
    'Password:' => 'Mot de passe:',
    'Enter your LDAP password.' => 'Saisissez votre mot de passe LDAP.',
    'Finish Install' => 'Finir l\'installation',

    ## ./tmpl/cms/comment_table.tmpl
    'Only show published comments' => 'N\'afficher que les commentaires publiés',
    'Only show pending comments' => 'N\'afficher que les commentaires en attente',
    'Edit this comment' => 'Editer ce commentaire',
    'Edit Comment' => 'Modifier les commentaires',
    'Edit this commenter' => 'Editer cet auteur de commentaires',
    'Search for comments by this commenter' => 'Chercher les commentaires de cet auteur de commentaires',
    'View this entry' => 'Voir cette note',
    'Show all comments on this entry' => 'Afficher tous les commentaires de cette note',

    ## ./tmpl/cms/list_banlist.tmpl
    'IP Banning Settings' => 'Paramétrages des IP bannies',
    'This screen allows you to ban comments and TrackBacks from specific IP addresses.' => 'Cet écran vous permet de bannir commentaires et TrackBacks provenant d\'une adresse IP donnée.',
    'You have banned [quant,_1,address,addresses].' => 'Vous avez banni [quant,_1,address,addresses].',
    'You have added [_1] to your list of banned IP addresses.' => 'L\'adresse [_1] a été ajoutée à la liste des adresses IP bannies.',
    'You have successfully deleted the selected IP addresses from the list.' => 'L\'adresse IP sélectionnée a été supprimée de la liste.',
    'Ban New IP Address' => 'Bannir une nouvelle adresse IP',
    'Ban IP Address' => 'Bannir l\'adresse IP',
    'Date Banned' => 'Bannie le :',
    'IP address' => 'IP addresse',
    'IP addresses' => 'adresses IP',

    ## ./tmpl/cms/bookmarklets.tmpl
    'QuickPost' => 'QuickPost', # Translate - Previous (1)
    'Add QuickPost to Windows right-click menu' => 'Ajouter QuickPost au menu contextuel de Windows (clic droit)',
    'Configure QuickPost' => 'Configurer QuickPost',
    'Include:' => 'Inclure :',
    'TrackBack Items' => 'Eléments de TrackBack',
    'Allow Comments' => 'Autoriser les commentaires',
    'Allow TrackBacks' => 'Autoriser les TrackBacks',
    'Create' => 'Créer',

    ## ./tmpl/cms/category_add.tmpl
    'Add A Category' => 'Ajouter une catégorie',
    'To create a new category, enter a title in the field below, select a parent category, and click the Add button.' => 'Pour créer une catégorie, indiquez un titre dans le champ ci-dessous, sélectionnez une catégorie parente, puis cliquez sur Ajouter.',
    'Category Title:' => 'Titre de la catégorie :',
    'Parent Category:' => 'Catégorie parente :',
    'Top Level' => 'Niveau racine',
    'Save category (s)' => 'Enregistrer la catégorie (s)',

    ## ./tmpl/cms/import_start.tmpl
    'Importing...' => 'Importation...',
    'Importing entries into blog' => 'Importation de notes dans le blog',
    'Importing entries as user \'[_1]\'' => 'Importation des notes en tant qu\'utilisateur \'[_1]\'',
    'Creating new users for each user found in the blog' => 'Création de nouveaux utilisateur correspondant à chaque utilisateur trouvé dans le blog',

    ## ./tmpl/cms/list_notification.tmpl
    'Notifications' => 'Notifications', # Translate - Previous (1)
    'Below is the notification list for this blog. When you manually send notifications on published entries, you can select from this list.' => 'Ci-dessous la liste des notifications pour ce blog. Quand vous envoyez manuellement des notifications sur des notes publiées, vous pouvez les sélectionner à partir de cette liste.',
    'You have [quant,_1,user,users,no users] in your notification list. To delete an address, check the Delete box and press the Delete button.' => 'Vous avez [quant,_1,utilisateur,utilisateurs,pas d\'utilisateur] dans votre liste de notification. Pour effacer une addresse, séléctionnez-la et cliquez sur le bouton Effacer.',
    'You have added [_1] to your notification list.' => 'Vous avez ajouté [_1] à votre liste de notifications.',
    'You have successfully deleted the selected notifications from your notification list.' => 'Les avis sélectionnés ont été supprimés de la liste de notifications.',
    'Create New Notification' => 'Créer une nouvelle notification',
    'URL (Optional):' => 'URL (facultatif) :',
    'Add Recipient' => 'Ajouter',
    'No notifications could be found.' => 'Aucune notification n\'a été trouvée.',

    ## ./tmpl/cms/itemset_action_widget.tmpl
    'More actions...' => 'Plus d\'actions...',
    'Go' => 'OK',
    'No actions' => 'Aucune action',

    ## ./tmpl/cms/edit_blog.tmpl
    'You must set your Local Site Path.' => 'Vous devez configurer le chemin local de votre site.',
    'You must set your Site URL.' => 'Vous devez configurer l\'URL de votre site.',
    'Your Site URL is not valid.' => 'L\'adresse URL de votre site n\'est pas valide.',
    'You can not have spaces in your Site URL.' => 'Vous ne pouvez pas avoir d\'espaces dans l\'adresse URL de votre site.',
    'You can not have spaces in your Local Site Path.' => 'Vous ne pouvez pas avoir d\'espaces dans le chemin local de votre site.',
    'Your Local Site Path is not valid.' => 'Le chemin local de votre site n\'est pas valide.',
    'New Weblog Settings' => 'Nouveaux paramètres du weblog',
    'From this screen you can specify the basic information needed to create a weblog.  Once you click the save button, your weblog will be created and you can continue to customize its settings and templates, or just simply start posting.' => 'A partir de cet écran vous pouvez spécifier les informations de base nécessaires pour créer un weblog. En cliquant sur le bouton Sauvegarder, votre weblog sera créé et vous pourrez poursuivre la personnalisation de ses paramètres et modèles, ou simplement commencer à publier.',
    'Your weblog configuration has been saved.' => 'La configuration de votre weblog a été enregistrée.',
    'Site URL' => 'URL du site',
    'Enter the URL of your public website. Do not include a filename (i.e. exclude index.html).' => 'Indiquez l\'URL de votre site web publiî N\'incluez pas de nom de fichier (excluez index.html).',
    'Example:' => 'Exemple :',
    'Site Root' => 'Site Racine',
    'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'Indiquez le chemin d\'accès à votre fichier d\'index principal. Un chemin absolu (qui débute par \'/\' est préférable, mais il est également possible d\'utiliser un chemin relatif au répertoire de Movable Type.',

    ## ./tmpl/cms/blog-left-nav.tmpl
    'Posting' => 'Poster',
    'New Entry' => 'Nouvelle note',
    'Community' => 'Communauté',
    'List Commenters' => 'Lister les auteurs de commentaires',
    'Commenters' => 'Auteurs de Commentaires',
    'Edit Notification List' => 'Modifier la liste des avis',
    'List Users &amp; Groups' => 'Liste des utilisateurs &amp; Groupes',
    'List &amp; Edit Templates' => 'Lister &amp; Editer les modèles',
    'Edit Categories' => 'Modifier les catégories',
    'Edit Tags' => 'Editer les Tags',
    'Edit Weblog Configuration' => 'Modifier la configuration du weblog',
    'Import &amp; Export Entries' => 'Importer &amp; Exporter les Notes',
    'Rebuild Site' => 'Actualiser le site',

    ## ./tmpl/cms/spam_confirm.tmpl
    'These domain names were found in the selected comments. Check the box at right to block comments and trackbacks containing that URL in the future.' => 'Ces noms de domaines ont été trouvés dans les commentaires. Cocher la boîte à droite pour bloquer ces url dans les commentaires et les trackbacks qui les contiendront à l\'avenir.',
    'Block' => 'Bloquer',

    ## ./tmpl/cms/edit_category.tmpl
    'You must specify a label for the category.' => 'Vous devez spécifier un titre pour cette catégorie.',
    'Edit Category' => 'Editer les catégories',
    'Use this page to edit the attributes of the category [_1]. You can set a description for your category to be used in your public pages, as well as configuring the TrackBack options for this category.' => 'Cette page permet de modifier les attributs de la catégorie [_1]. Vous pouvez indiquer une description, qui sera affichée sur votre site public, et configurer les options TrackBack pour cette catégorie.',
    'Your category changes have been made.' => 'Les modifications apportées ont été enregistrées.',
    'Label' => 'Etiquette',
    'Unlock this category\'s output filename for editing' => 'Dévérouiller le fichier de cette catégorie pour l\'éditer',
    'Warning: Changing this category\'s basename may break inbound links.' => 'Attention: changer le nom de la catégorie risque de casser des liens entrants.',
    'Save this category (s)' => 'Sauvegarder cette catégorie',
    'Inbound TrackBacks' => 'TrackBacks entrants',
    'If enabled, TrackBacks will be accepted for this category from any source.' => 'Si activé, les TrackBacks seront acceptés pour cette catégorie quelle que soit la source.',
    'TrackBack URL for this category' => 'URL TrackBack pour cette catégorie',
    'Passphrase Protection' => 'Protection Passphrase',
    'Optional.' => 'Facultatif.',
    'Outbound TrackBacks' => 'TrackBacks sortants',
    'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you post an entry in this category. (Separate URLs with a carriage return.)' => 'Saisissez l\'URL(s) du ou des site(s) web à qui vous souhaitez envoyer un TrackBack chaque fois que vous publiez un note dans cette catégorie. (Faire un passage à la ligne entre chaque URL.)',

    ## ./tmpl/cms/edit_template.tmpl
    'You have unsaved changes to your template that will be lost.' => 'Vous avez des changements non enregistrés qui vont être perdus.',
    'Edit Template' => 'Modifier un modèle',
    'Your template changes have been saved.' => 'Les modifications apportées ont été enregistrées.',
    'Rebuild this template' => 'Actualiser ce modèle',
    'Build Options' => 'Options de compilation',
    'Enable dynamic building for this template' => 'Activer la compilation dynamique pour ce modèle',
    'Rebuild this template automatically when rebuilding index templates' => 'Actualiser ce modèle en même temps que les modèles d\'index',
    'Comment Listing Template' => 'Modèle de liste des commentaires',
    'Comment Preview Template' => 'Modèle d\'aperçu des commentaires',
    'Search Results Template' => 'Modèle des résultats d\'une recherche',
    'Comment Error Template' => 'Modèle d\'avertissement d\'erreur liée aux commentaires',
    'Comment Pending Template' => 'Modèle d\'avertissement de commentaires en attente',
    'Commenter Registration Template' => 'Modèle d\'inscription des auteurs de commentaires',
    'TrackBack Listing Template' => 'Modèle de liste TrackBack',
    'Uploaded Image Popup Template' => 'Modèle de fenêtre de téléchargement d\'images',
    'Dynamic Pages Error Template' => 'Modèle d\'erreur de page dynamique',
    'Link this template to a file' => 'Lier ce modèle à un fichier',
    'Module Body' => 'Corps du module',
    'Template Body' => 'Corps du modèle',
    'Insert...' => 'Insertion...',
    'Save this template (s)' => 'Sauvegarder ce modèle (s)',
    'Save and Rebuild' => 'Sauvegarder et Reconstruire',
    'Save and rebuild this template (r)' => 'Sauvegarder et reconstruire ce modèle (r)',

    ## ./tmpl/cms/pager.tmpl
    'Show Display Options' => 'Options d\'affichage',
    'Display Options' => 'Options d\'affichage',
    'Show:' => 'Afficher :',
    '[quant,_1,row]' => '[quant,_1,ligne]',
    'View:' => 'Vue:',
    'Compact' => 'Compacte',
    'Expanded' => 'Etendue',
    'Actions' => 'Actions', # Translate - Previous (1)
    'Date Display:' => 'Affichage de la date :',
    'Relative' => 'Relative', # Translate - Previous (1)
    'Full' => 'Entière',
    'Open Batch Editor' => 'Ouvrir l\'Editeur par lots',
    'Newer' => 'Le plus récent',
    'Showing:' => 'Affiche :',
    'of' => 'de',
    'Older' => 'Le plus ancien',

    ## ./tmpl/cms/rebuilt.tmpl
    'All of your files have been rebuilt.' => 'Tous vos fichiers ont été actualisés.',
    'Your [_1] has been rebuilt.' => 'Votre [_1] a été actualisé(e).',
    'Your [_1] pages have been rebuilt.' => 'Vos pages [_1] ont été actualisées.',
    'View this page' => 'Afficher cette page',
    'Rebuild Again' => 'Actualiser une nouvelle fois',

    ## ./tmpl/cms/cfg_feedback.tmpl
    'This screen allows you to control the feedback settings for this weblog, including comments and TrackBacks.' => 'Cet écran vous permet de contrôler le paramétrage des feedbacks incluant commentaires et TrackBacks.',
    'To see the changes reflected on your public site, you should rebuild your site now.' => 'Vous pouvez actualiser votre site de façon à voir les modifications reflétées sur votre site publié',
    'Rebuild my site' => 'Actualiser le site',
    'Rebuild indexes' => 'Reconstruire les index',
    'Note: Commenting is currently disabled at the system level.' => 'Note : Les commentaires sont actuellement désactivés au niveau système.',
    'Comment authentication is not available because one of the needed modules, MIME::Base64 or LWP::UserAgent is not installed. Talk to your host about getting this module installed.' => 'L\'authetification de commentaire n\'est pas active car le module MIME::Base64 or LWP::UserAgent est absent. Contactez votre hébergeur pour l\'installation de ce module.',
    'Accept comments from' => 'Accepter les commentaires de',
    'Anyone' => 'Tous',
    'Authenticated commenters only' => 'Auteurs de commentaires authentifiés uniquement',
    'No one' => 'Personne',
    'Specify from whom Movable Type shall accept comments on this weblog.' => 'Specifier de qui Movable Type doit accepter les commentaires sur ce weblog.',
    'Authentication Status' => 'Statut d\'authentification',
    'Authentication Enabled' => 'Authentification Activée',
    'Authentication is enabled.' => 'Authentification activée.',
    'Clear Authentication Token' => 'Effacer le jeton d\'authentification',
    'Authentication Token:' => 'Jeton d\'Authentification:',
    'Authentication Token Removed' => 'Jeton d\'authentification supprimé',
    'Please click the Save Changes button below to disable authentication.' => 'Cliquez sur le bouton Enregistrer ci-dessous pour DESACTIVER l\'authentification.',
    'Authentication Not Enabled' => 'Authentication NON Activée',
    'Note: You have selected to accept comments from authenticated commenters only but authentication is not enabled. In order to receive authenticated comments, you must enable authentication.' => 'Attention: vous avez sélectionné d\'accepter uniquement les commentaires de les auteurs de commentaires identifiés MAIS l\'authentification n\'est pas activée. Vous devez l\'activer pour recevoir les commentaire à autoriser.',
    'Authentication is not enabled.' => 'Authentification non activée.',
    'Setup Authentication' => 'Mise en place de l\'Authentification',
    'Or, manually enter token:' => 'Ou, entrez manuellement le jeton :',
    'Authentication Token Inserted' => 'Jeton d\'authentification inseré',
    'Please click the Save Changes button below to enable authentication.' => 'Cliquez sur le bouton Enregistrer ci-dessous pour activer l\'authentification.',
    'Establish a link between your weblog and an authentication service. You may use TypeKey (a free service, available by default) or another compatible service.' => 'Etablir un lien entre votre weblog et un système d\'authentification. Vous pouvez utiliser TypeKey (service gratuit disponible par défaut) ou un autre service compatible.',
    'Require E-mail Address' => 'Adresse email requise',
    'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Si activé, le visiteur doit donner une adresse email valide pour commenter.',
    'Immediately publish comments from' => 'Publier immédiatement les commentaires de(s)',
    'Trusted commenters only' => 'Auteurs de commentaires fiables uniquement',
    'Any authenticated commenters' => 'Tout auteur de commentaire authentifié',
    'Specify what should happen to non-junk comments after submission.' => 'Spécifier ce qui doit ce passer pour les commentaires désirés après leur enregistrement.',
    'Unpublished comments are held for moderation.' => 'Les commentaires non publiés sont retenus pour modération.',
    'E-mail Notification' => 'Notification par email',
    'On' => 'Activé',
    'Only when attention is required' => 'Uniquement quand l\'attention est requise',
    'Specify when Movable Type should notify you of new comments if at all.' => 'Spécifier quand Movable Type doit vous notifier les nouveaux commentaires.',
    'Allow HTML' => 'Autoriser le HTML',
    'If enabled, users will be able to enter a limited set of HTML in their comments. If not, all HTML will be stripped out.' => 'Si activé, l\'auteur de commentaires pourra entrer du HTML de façon limitée dans son commentaire. Sinon, le html ne sera pas pris en compte.',
    'Auto-Link URLs' => 'Liaison automatique des URL',
    'If enabled, all non-linked URLs will be transformed into links to that URL.' => 'Si activé, toutes les urls non liées seront transformées en url actives.',
    'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Spécifie les options de mise en forme du texte des commentaires publiés par les visiteurs.',
    'Note: TrackBacks are currently disabled at the system level.' => 'Note: Les TrackBacks sont actuellement désactivés au niveau système.',
    'If enabled, TrackBacks will be accepted from any source.' => 'Si activé, les TrackBacks seront acceptés quelle que soit la source.',
    'Moderation' => 'Modération',
    'Hold all TrackBacks for approval before they\'re published.' => 'Retenir les TrackBacks pour approbation avant publication.',
    'Specify when Movable Type should notify you of new TrackBacks if at all.' => 'Spécifier quand Movable Type doit vous notifier les nouveaux Trackbacks.',
    'Junk Score Threshold' => 'Sensibilité détection éléments indésirables',
    'Less Aggressive' => 'Moins agressif',
    'More Aggressive' => 'Plus Agressif',
    'Comments and TrackBacks receive a junk score between -10 (complete junk) and +10 (not junk). Feedback with a score which is lower than the threshold shown above will be marked as junk.' => 'Commentaires et TrackBacks reçoivent un niveau d\'indésirabilité entre  -10 (complètement indésirable) and +10 (désirable). Les Feedbacks listés avec un score inférieur au niveau indiqué ci-dessus seront considérés indésirables.',
    'Auto-Delete Junk' => 'Auto-effacement des indésirables',
    'If enabled, junk feedback will be automatically erased after a number of days.' => 'Si activé les feedbacks indésirables seront automatiquement supprimés après un certain nombre de jours.',
    'Delete Junk After' => 'Effacer les indésirables après',
    'days' => 'jours',
    'When an item has been marked as junk for this many days, it is automatically deleted.' => 'Lorsqu\'un élément est marqué indésirable, il sera automatiquement effacé après le nombre de jours indiqué.',

    ## ./tmpl/cms/comment_actions.tmpl
    'Publish selected comments (p)' => 'Publier les commentaires sélectionnés (p)',
    'Delete selected comments (x)' => 'Effacer les commentaires sélectionnés (x)',
    'Junk selected comments (j)' => 'Rejeter les commentaires sélectionnés (j)',
    'Recover selected comments (j)' => 'Récupérer les commentaires sélectionnés (j)',
    'Are you sure you want to remove all junk comments?' => 'Etes-vous certain de vouloir supprimer tous les commentaires indésirables ?',
    'Deletes all junk comments' => 'Efface tous les commentaires indésirables',

    ## ./tmpl/cms/author_table.tmpl
    'Only show enabled users' => 'Ne montrer que les utilisateurs activés',
    'Only show disabled users' => 'Ne montrer que les utilisateurs désactivés',

    ## ./tmpl/cms/header.tmpl

    ## ./tmpl/cms/edit_comment.tmpl
    'The comment has been approved.' => 'Le commentaire a été approuvé.',
    'List &amp; Edit Comments' => 'Lister &amp; Editer les commentaires',
    'Pending Approval' => 'En attente d\'approbation',
    'Junked Comment' => 'Commentaire indésirable',
    'View all comments with this status' => 'Voir tous les commentaires avec ce statut',
    '(Trusted)' => '(Fiable)',
    'Ban&nbsp;Commenter' => 'Bannir&nbsp;l\'auteur de commentaires',
    'Untrust&nbsp;Commenter' => 'Auteur de commentaires non fiable',
    '(Banned)' => '(Banni)',
    'Trust&nbsp;Commenter' => 'Faire&nbsp;confiance&nbsp;au&nbsp;Auteurs de commentaires',
    'Unban&nbsp;Commenter' => 'Auteur de commentaires autorisé à nouveau',
    'View all comments by this commenter' => 'Afficher tous les commentaires de cet auteur de commentaires',
    'None given' => 'Non fourni',
    'View all comments with this URL' => 'Afficher tous les commentaires associés à cette URL',
    'Entry no longer exists' => 'Cette note n\'existe plus',
    'No title' => 'Sans titre',
    'View all comments on this entry' => 'Afficher tous les commentaires associés à cette note',
    'View all comments posted on this day' => 'Afficher tous les commentaires postés ce même jour',
    'View all comments from this IP address' => 'Afficher tous les commentaires associés à cette adresse IP',
    'Save this comment (s)' => 'Sauvegarder ce commentaire (s)',
    'Delete this comment (x)' => 'Effacer ce commentaire (x)',
    'Final Feedback Rating' => 'Notation finale des Feedbacks',
    'Test' => 'Test', # Translate - Previous (1)
    'Score' => 'Score', # Translate - Previous (1)
    'Results' => 'Résultats',

    ## ./tmpl/cms/group_actions.tmpl
    'group' => 'groupe',
    'groups' => 'groupes',
    'Enable selected groups ()' => 'Activer les groupes sélectionnés ()',
    'Disable selected groups ()' => 'Désactiver les groupes sélectionnés ()',
    'Remove selected groups' => 'Enlever les groupes sélectionnés',
    'Delete selected groups' => 'Effacer les groupes sélectionnés',

    ## ./tmpl/cms/list_author.tmpl
    'Synchronize users now' => 'Synchroniser les utilisateurs maintenant',
    'Bulk manage users' => 'Gérer collectivement les utilisateurs',
    'You have successfully disabled the selected user(s).' => 'Vous avez désactivé avec succès les utilisateurs sélectionnés.',
    'You have successfully enabled the selected user(s).' => 'Vous avez activé avec succès les utilisateurs sélectionnés.',
    'You have successfully deleted the user(s) from the Movable Type system.' => 'Vous avez supprimé avec succès les utilisateurs dans le système.',
    'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Enterprise.' => 'Les utilisateurs effacés existent encore dans le répertoire externe.En conséquence ils pourront encore s\'identifier dans Movable Type Entreprise',
    'You have successfully synchronized users\' information with the external directory.' => 'Vous avez synchronisé avec succès les informations des utilisateurs avec le répertoire externe.',
    'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => 'Certains des utilisateurs sélectionnés ([_1])ne peuvent pas être ré-activés car ils ne sont pas dans le répertoire externe.',
    'Download a CSV file of this data.' => 'Télécharger un fichier CSV contenant ces données.',
    '(Showing all users.)' => '(Affiche tous les utilisateurs.)',
    'Showing only users whose [_1] is [_2].' => 'Affiche uniqumement les utilisateurs dont [_1] est [_2].',
    'users.' => 'utilisateurs.',
    'users where' => 'utilisateurs pour lesquels',
    'enabled' => 'activé',
    'disabled' => 'désactivé',

    ## ./tmpl/cms/association_actions.tmpl
    'Remove selected assocations (x)' => 'Supprimer les associations sélectionnées(x)',
    'association' => 'association', # Translate - Previous (1)
    'associations' => 'associations', # Translate - Previous (1)

    ## ./tmpl/cms/list_group_members.tmpl
    'Group Members' => 'Membres du groupe',
    'You have successfully deleted the users from the Movable Type system.' => 'Les utilisateurs ont été effacés du système Movable Type.',
    'You have successfully added new users to this group.' => 'Vous avez ajouté avec succès des nouveaux utilisateurs dans le groupe.',
    'You have successfully synchronized users\' information with external directory.' => 'Vous avez correctement synchronisé les informations utilisateurs avec le répertoire externe.',
    'Some ([_1]) of the selected users could not be re-enabled because they were no longer found in LDAP.' => 'Certains ([_1]) des utilisateurs sélectionnés ne peuvent pas être réactivés car ils ne sont plus présents dans le LDAP.',
    'You have successfully removed the users from this group.' => 'Vous avez supprimé avec succès les utilisateurs de ce groupe.',
    'Add member' => 'Ajouter un membre',
    'You can not add users to a disabled group.' => 'Vous ne pouvez ajouter des utilisateurs à des groupes désactivés.', # Translate - New (9)
    'Add another user to [_1]' => 'Ajouter un autre utilisateur sur [_1]',
    'No members could be found.' => 'Aucun membre n\'a pu être trouvé.',

    ## ./tmpl/cms/pending_commenter.tmpl

    ## ./tmpl/cms/header-popup.tmpl

    ## ./tmpl/cms/edit_ping.tmpl
    'The TrackBack has been approved.' => 'Le TrackBack a été approuvé.',
    'List &amp; Edit TrackBacks' => 'Lister &amp; Editer les TrackBacks',
    'Junked TrackBack' => 'TrackBacks indésirables',
    'View all TrackBacks with this status' => 'Voir tous les Trackbacks avec ce statut',
    'Source Site:' => 'Site Source :',
    'Search for other TrackBacks from this site' => 'Rechercher d\'autres Trackbacks de ce site',
    'Source Title:' => 'Titre Source :',
    'Search for other TrackBacks with this title' => 'Rechercher d\'autres Trackbacks avec ce titre',
    'Search for other TrackBacks with this status' => 'Rechercher d\'autres Trackbacks avec ce statut',
    'Target Entry:' => 'Note cible :',
    'View all TrackBacks on this entry' => 'Voir tous les TrackBacks pour cette note',
    'Target Category:' => 'Catégorie cible :',
    'Category no longer exists' => 'La catégorie n\'existe plus',
    'View all TrackBacks on this category' => 'Afficher tous les TrackBacks des cette catégorie',
    'View all TrackBacks posted on this day' => 'Afficher tous les TrackBacks postés ce jour',
    'View all TrackBacks from this IP address' => 'Afficher tous les TrackBacks avec cette adresse IP',
    'Save this TrackBack (s)' => 'Sauvegarder ce Trackback (s)',
    'Delete this TrackBack (x)' => 'Effacer ce TrackBack (x)',

    ## ./tmpl/cms/pinging.tmpl
    'Pinging sites...' => 'Envoi de ping(s)...',

    ## ./tmpl/cms/upgrade_runner.tmpl
    'Installation complete.' => 'Installation terminée.',
    'Upgrade complete.' => 'Mise à jour terminée.',
    'Initializing database...' => 'Initialisation de la base de données...',
    'Upgrading database...' => 'Mise à jour de la base de données...',
    'Starting installation...' => 'Début de l\'installation...',
    'Starting upgrade...' => 'Début de la mise à jour...',
    'Error during installation:' => 'Erreur lors de l\'installation :',
    'Error during upgrade:' => 'Erreur lors de la mise à jour :',
    'Installation complete!' => 'Installation terminée !',
    'Upgrade complete!' => 'Mise à jour terminée !',
    'Login to Movable Type' => 'S\'enregistrer dans Movable Type',
    'Your database is already current.' => 'Votre base de données est déjà actualisée.',

    ## ./tmpl/cms/cfg_simple.tmpl
    'This screen allows you to control all settings specific to this weblog.' => 'Cette page vous permet de contrôler tous les paramètres spécifiques de ce weblog.',
    'Publishing Paths' => 'Chemins de publication',
    'Enter the URL of your website. Do not include a filename (i.e. exclude index.html).' => 'Entrez l\'url de votre site. Ne pas inclure le nom de fichier (ne pas mettre par exemple : index.html).',
    'Enter the path where your index files will be published. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'Entrez le chemin où votre fichier index sera publié. Un chemin absolu (commençant par \'/\') est recommandé, mais vous pouvez aussi utiliser un chemin relatif vers le répertoire Movable Type.',
    'You can configure the publishing model for this blog (static vs dynamic) on the ' => 'Vous pouvez choisir le mode de publication de ce blog (statique ou dynamique) sur la ',
    'Detailed Settings' => 'Paramètres détaillés',
    ' page.' => ' page.', # Translate - Previous (2)
    'Choose to display a number of recent entries or entries from a recent number of days.' => 'Choisissez le nombre de notes récentes ou les notes d\'un nombre de jours donné.',
    'Specify which types of commenters will be allowed to leave comments on this weblog.' => 'Définissez le type d\'auteur de commentaires qui sera autorisé à commenter sur votre blog.',
    'If you want to require visitors to sign in before leaving a comment, set up authentication with the free TypeKey service.' => 'Si vous voulez que les visiteurs s\'enregistrent avant de laisser un commentaire, mettez en place l\'authentification avec le service gratuit TypeKey.',
    'Specify what should happen to comments after submission. Unpublished comments are held for moderation and junk comments do not appear.' => 'Définissez le traitement d\'un commentaire avant publication. Les commentaires non publiés, sont en attente pour modération et les commentaires indésirables n\'apparaissent pas',
    'Accept TrackBacks from people who link to your weblog.' => 'Accepter les Trackbacks des personnes qui font des liens vers votre weblog.',

    ## ./tmpl/cms/list_blog.tmpl
    'System Shortcuts' => 'Raccourcis système',
    'Concise listing of weblogs.' => 'Liste résumée des weblogs.',
    'Manage, set permissions.' => 'Gérer, attribuer les permissions.',
    'Create, manage, set permissions.' => 'Créer, gérer et accorder les autorisations.',
    'Create and manage roles and associations.' => 'Créer et gérer les rôles et les associations.',
    'Multi-weblog entry listing.' => 'Liste des notes de tous les weblogs.',
    'Multi-weblog tag listing.' => 'Liste des tags de tous les weblogs.',
    'Multi-weblog comment listing.' => 'Liste des commentaires de tous les weblogs.',
    'Multi-weblog TrackBack listing.' => 'Liste des TrackBacks de tous les weblogs.',
    'System-wide configuration.' => 'Configuration générale du système.',
    'What\'s installed, access to more.' => 'Eléments installés, Nouvelles Installations.',
    'Find everything. Replace anything.' => 'Rechercher et/ou remplacer un élément.',
    'What\'s been happening.' => 'Historique des actions.',
    'Status &amp; Info' => 'Statut &amp; Info',
    'Server status and information.' => 'Information et statut serveur.',
    'Set Up A QuickPost Bookmarklet' => 'Installer le Bookmarklet QuickPost',
    'Enable one-click publishing.' => 'Activer la publication en un clic.',
    'My Weblogs' => 'Mes Weblogs',
    'Important:' => 'Important :',
    'Configure this weblog.' => 'Configurer ce weblog.',
    'Create a new entry' => 'Créer une note',
    'Create a new entry on this weblog' => 'Créer une nouvelle note sur ce Blog',
    'Sort By:' => 'Trié par :',
    'Creation Order' => 'Ordre de création',
    'Last Updated' => 'Dernière Mise à jour',
    'Order:' => 'Ordre :',
    'You currently have no blogs.' => 'Pour l\'instant vous n\'avez pas de blog.',
    'Please see your system administrator for access.' => 'Merci de consulter l\'administrateur système pour obtenir un accès.',

    ## ./tmpl/cms/edit_role.tmpl
    'You have changed the permissions for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'Vous avez changé les autorisations pour ce role. Ceci va modifier les possibilités des utilisateurs associés à ce rôle. Si vous le souhaitez vous pouvez sauvegarder ce role avec un nom différent. Dans le cas contraire, soignez vigilant aux modifications pour les utilisateurs.',
    'Role Details' => 'Détails du rôle',
    'Role Name' => 'Nom du rôle',
    'Roles with the same permissions' => 'Roles avec les mêmes autorisations',
    'Save this role' => 'Sauvegarder ce rôle',

    ## ./tmpl/cms/commenter_table.tmpl
    'Most Recent Comment' => 'Commentaire le plus récent',
    'Only show trusted commenters' => 'Afficher uniquement les auteurs de commentaires fiable',
    'Only show banned commenters' => 'Afficher uniquement les auteurs de commentaires bannis',
    'Only show neutral commenters' => 'Afficher uniquement les auteurs de commentaires neutres',
    'View this commenter\'s profile' => 'Afficher le profil de cet auteur de commentaires',

    ## ./tmpl/cms/template_table.tmpl

    ## ./tmpl/cms/blog_actions.tmpl
    'weblog' => 'weblog', # Translate - Previous (1)
    'weblogs' => 'weblogs', # Translate - Previous (1)
    'Delete selected weblogs (x)' => 'Effacer les weblogs sélectionnés (x)',

    ## ./tmpl/cms/system_list_blog.tmpl
    'Are you sure you want to delete this weblog?' => 'Etes-vous certain de vouloir effacer ce weblog?',
    'Below you find a list of all weblogs in the system with links to the main weblog page and individual settings pages for each.  You may also create or delete blogs from this screen.' => 'Ci-dessous la liste des weblogs du système avec un lien vers leur page principale et leur page de paramètres individuels. Vous avez la possibilité de créer ou supprimer un weblog à partir de cette page.',
    'You have successfully deleted the blogs from the Movable Type system.' => 'Le blog a été correctement supprimé du système Movable Type.',
    'Create New Weblog' => 'Créer un nouveau Weblog',
    'No weblogs could be found.' => 'Aucun weblog n\'a été trouvé.',

    ## ./tmpl/cms/footer-popup.tmpl

    ## ./tmpl/cms/create_author_bulk_start.tmpl
    'Updating...' => 'Mise à jour...',
    'Updating users by reading the uploaded CSV file' => 'Mise à jour des utilisateurs via lecture du fichier CSV',

    ## ./tmpl/cms/search_replace.tmpl
    'You must select one or more item to replace.' => 'Vous devez sélectionner un ou plusieurs objets à remplacer.',
    'Search Again' => 'Chercher encore',
    'Search:' => 'Chercher:',
    'Replace:' => 'Remplacer:',
    'Replace Checked' => 'Remplacer les objets selectionnés',
    'Case Sensitive' => 'Restreint à',
    'Regex Match' => 'Expression Régulière',
    'Limited Fields' => 'Champs limités',
    'Date Range' => 'Période (date)',
    'Is Junk?' => 'Indésirable ?',
    'Search Fields:' => 'Rechercher les champs :',
    'Comment Text' => 'Texte du commentaire',
    'E-mail Address' => 'Adresse email',
    'Source URL' => 'URL Source',
    'Blog Name' => 'Nom du Blog',
    'Text' => 'Texte',
    'Output Filename' => 'Nom du fichier de sortie',
    'Linked Filename' => 'Lien du fichier lié',
    'Group Name' => 'Nom du Groupe',
    'From:' => 'De :',
    'To:' => 'A :',
    'Replaced [_1] records successfully.' => '[_1] enregistrements remplacés avec succès.',
    'No entries were found that match the given criteria.' => 'Aucune note ne correspond à votre recherche.',
    'No comments were found that match the given criteria.' => 'Aucun commentaire ne correspond à votre recherche.',
    'No TrackBacks were found that match the given criteria.' => 'Aucun TrackBack ne correspond à votre recherche.',
    'No commenters were found that match the given criteria.' => 'Aucun auteur de commentaires ne correspond à votre recherche.',
    'No templates were found that match the given criteria.' => 'Aucun modèle ne correspond à votre recherche.',
    'No log messages were found that match the given criteria.' => 'Aucun message de log ne correspond à votre recherche.',
    'No users were found that match the given criteria.' => 'Aucun utilisateur ne correspond à votre recherche.',
    'No groups were found that match the given criteria.' => 'Aucun groupe trouvé ne correspond à votre recherche.',
    'No weblogs were found that match the given criteria.' => 'Aucun weblog n\'a été trouvé qui corresponde aux critères donnés',
    'Showing first [_1] results.' => 'Afficher d\'abord [_1] résultats.',
    'Show all matches' => 'Afficher tous les résultats',
    '[_1] result(s) found.' => '[_1] resultat(s) trouvé(s).',

    ## ./tmpl/cms/system_info.tmpl
    'System Status and Information' => 'Statut du système et information',
    'This page will soon contain information about the server environment availability of required perl modules, installed plugins and other information useful for expediting debugging in technical support requests.' => 'Cette page va regrouper les informations au sujet de la disponibilité de l\'environnement serveur des modules perl, des plugins installés et d\'autres informations utiles pour le debug dans les demandes de support technique.',

    ## ./tmpl/cms/entry_actions.tmpl
    'Save these entries (s)' => 'Sauvegarder ces notes (s)',
    'Save this entry (s)' => 'Sauvegarder cette note (s)',
    'Preview this entry (v)' => 'Aperçu de cette note (v)',
    'entry' => 'note',
    'entries' => 'notes',
    'Delete this entry (x)' => 'Effacer cette note (x)',
    'to rebuild' => 'pour reconstruire',
    'Rebuild selected entries (r)' => 'Reconstruire les notes sélectionnées (r)',
    'Delete selected entries (x)' => 'Effacer les notes sélectionnées (x)',

    ## ./tmpl/cms/cfg_system_general.tmpl
    'None selected.' => 'Aucun sélectionné.',
    'You must set a valid Default Site URL.' => 'Vous devez définir une URL par défaut valide pour le site.',
    'You must set a valid Default Site Root.' => 'Vous devez définir une URL par défaut valide pour la Racine du Site.',
    'This screen allows you to set system-wide new user defaults.' => 'Cette écran vous permet de mettre en place les paramètres par défaut dans tout le système pour les nouveaux utilisateurs.',
    'New User Defaults' => 'Paramètres par défaut pour les nouveaux utilisateurs',
    'Personal weblog' => 'Weblog personnel',
    'Automatically create a new weblog for each new user' => 'Créer automatiquement un nouveau weblog pour chaque nouvel utilisateur',
    'Check to have the system automatically create a new personal weblog when a user is created in the system. The user will be granted a blog administrator role on the weblog.' => 'A cocher pour que le système crée automatiquement un nouveau weblog à chaque nouvel utilisateur. L\'utilisateur aura un accès administrateur sur son blog.',
    'Personal weblog clone source' => 'Source Clone Weblog personnel',
    'Select...' => 'Selection...',
    'Clear' => 'Clair',
    'Select a weblog you wish to use as the source for new personal weblogs. The new weblog will be identical to the source except for the name, publishing paths and permissions.' => 'Sélectionnez un weblog que vous voulez utiliser comme source pour les nouveaux weblogs personnels. Le nouveau weblog sera identique à la source excepté pour le nom, les chemins de publication et les autorisations.',
    'Default Site URL' => 'URL par défaut du site',
    'Define the default site URL for new weblogs. This URL will be appended with a unique identifier for the weblog.' => 'Définir l\'URL par défaut du site pour un nouveau weblog. Cette URL sera associée à un identifiant unique pour le weblog',
    'Default Site Root' => 'Racine du site par défaut',
    'Define the default site root for new weblogs. This path will be appended with a unique identifier for the weblog.' => 'Définir la racine du site par défaut pour un nouveau weblog. Ce chemin sera associé à un identifiant unique pour le weblog',
    'Default User Language' => 'Langue par défaut',
    'Define the default language to apply to all new users.' => 'Définir la langue par défaut à appliquer à chaque nouvel utilisateur',
    'Default Timezone:' => 'Zone horaire par défaut:',
    'Default Tag Delimiter:' => 'Délimiteur de tag par défaut:',
    'Define the default delimiter for entering tags.' => 'Définir un délimiteur par défaut pour la saisie des tags.',

    ## ./tmpl/cms/bm_entry.tmpl
    'Select' => 'Sélectionner',
    'You must choose a weblog in which to post the new entry.' => 'Vous devez sélectionner le weblog dans lequel publier cette note.',
    'Select a weblog for this post:' => 'Sélectionnez un weblog pour cette note :',
    'Send an outbound TrackBack:' => 'Envoyer un TrackBack :',
    'Select an entry to send an outbound TrackBack:' => 'Choisissez une note pour envoyer un TrackBack :',
    'Accept' => 'Accepter',
    'You do not have entry creation permission for any weblogs on this installation. Please contact your system administrator for access.' => 'Vous n\'avez pas accès à la création de weblog dans cette installation. Merci de contacter votre Administrateur Système pour avoir un accès.',

    ## ./tmpl/cms/cfg_archives.tmpl
    'Are you sure you want to delete this template map?' => 'Etes-vous sur de vouloir supprimer cette carte d\'modèle ?',
    'You must set a valid Site URL.' => 'Vous devez spécifier une URL valide.',
    'You must set a valid Local Site Path.' => 'Vous devez spécifier un chemin local d\'accès valide.',
    'Publishing Settings' => 'Paramètres de publication',
    'This screen allows you to control this weblog\'s publishing paths and preferences, as well as archive mapping settings.' => 'Cet écran vous permet de contrôler les chemins de publication, les préférences et les paramètres d\'archives de ce weblog.',
    'Error: Movable Type was not able to create a directory for publishing your weblog. If you create this directory yourself, assign sufficient permissions that allow Movable Type to create files within it.' => 'Erreur : Movable Type n\'a pas pu créer le dossier pour publier ce weblog.  Si vous créez ce dossier vous même, assigner suffisamment d\'autorisations à Movable Type pour y créer des fichiers.',
    'Your weblog\'s archive configuration has been saved.' => 'La configuration des archives de votre weblog a été enregistrée.',
    'You may need to update your templates to account for your new archive configuration.' => 'Vous devrez peut-être mettre à jour votre modèle pour pour obtenir votre nouvelle configuration d\'archives.',
    'You have successfully added a new archive-template association.' => 'L\'association modèle/archive a réussi.',
    'You may need to update your \'Master Archive Index\' template to account for your new archive configuration.' => 'Vous aurez peut-être besoin de mettre à jour votre modèle \'Index principal des archives\' pour activer la nouvelle configuration de vos archives.',
    'The selected archive-template associations have been deleted.' => 'Les associations modèle/archive sélectionnées ont été supprimées.',
    'Advanced Archive Publishing:' => 'Publication Avancée des Archives :',
    'Publish archives to alternate root path' => 'Publier les archives sur un chemin racine alternatif',
    'Select this option only if you need to publish your archives outside of your Site Root.' => 'Sélectionnez cette option si vous avez besoin de publier vos archives en dehors de la racine du Site.',
    'Archive URL:' => 'URL des archives :',
    'Enter the URL of the archives section of your website.' => 'Entrer l\'URL de la section Archives de votre site.',
    'Archive Root' => 'Archive Racine',
    'Enter the path where your archive files will be published.' => 'Entrer le chemin de l\'endroit où seront publiées vos archives.',
    'Publishing Preferences' => 'Préférences de Publication',
    'Preferred Archive Type:' => 'Type d\'archive préféré :',
    'No Archives' => 'Pas d\'archive',
    'Individual' => 'Individuelles',
    'Daily' => 'Quotidien',
    'Weekly' => 'Hebdomadaire',
    'Monthly' => 'Mensuelles',
    'When linking to an archived entry&#8212;for a permalink, for example&#8212;you must link to a particular archive type, even if you have chosen multiple archive types.' => 'Lorsque vous établissez un hyperlien vers une note archivée, comme pour un permalien, vous devez créer le lien vers un type d\'archive spécifique, même si vous avez choisi plusieurs types d\'archive.',
    'File Extension for Archive Files:' => 'Extension de fichier pour les archives:',
    'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'Entrez l\'extension du fichier d\'archive. Elle peut être au choix \'html\', \'shtml\', \'php\', etc. NB: Ne pas indiquer la période (\'.\').',
    'Dynamic Publishing:' => 'Publication Dynamique :',
    'Build all templates statically' => 'Construire chaque modèle de manière statique',
    'Build only Archive Templates dynamically' => 'Construire uniquement les Modèles d\'Archive dynamiquement',
    'Set each template\'s Build Options separately' => 'Mettre en place les Options de Construction des modèles individuellement',
    'Archive Mapping' => 'Table de correspondance des archives',
    'Create New Archive Mapping' => 'Créer une nouvelle table de correspondance des archives',
    'Archive Type:' => 'Type d\'archive :',
    'INDIVIDUAL_ADV' => 'par note',
    'DAILY_ADV' => 'de façon quotidienne',
    'WEEKLY_ADV' => 'hebdomadaire',
    'MONTHLY_ADV' => 'par mois',
    'CATEGORY_ADV' => 'par catégorie',
    'Template' => 'Modèle',
    'Archive Types' => 'Types d\'archive',
    'Archive File Path' => 'Chemin vers les Fichiers Archive',
    'Preferred' => 'Préféré',
    'Custom...' => 'Personnalisé...',
    'archive map' => 'Association d\'archive',
    'archive maps' => 'Associations d\'archive',

    ## ./tmpl/cms/upload.tmpl
    'To upload a file to your server, click on the browse button to locate the file on your hard drive.' => 'Cliquez sur le bouton Parcourir pour sélectionner un fichier de votre disque dur à télécharger vers le serveur.',
    'File:' => 'Fichier:',
    'Set Upload Path' => 'Définir le chemin de téléchargement',
    '(Optional)' => '(facultatif)',
    'Path:' => 'Chemin :',

    ## ./tmpl/cms/footer.tmpl

    ## ./tmpl/cms/edit_categories.tmpl
    'Your category changes and additions have been made.' => 'Les modifications apportées aux catégories ont été enregistrées.',
    'You have successfully deleted the selected categories.' => 'Les catégories sélectionnées ont été supprimées.',
    'Create new top level category' => 'Créer une nouvelle catégorie principale',
    'Create Category' => 'Créer une catégorie',
    'Collapse' => 'Réduire',
    'Expand' => 'Développer',
    'Create Subcategory' => 'Créer une sous-catégorie',
    'Move Category' => 'Déplacer la catégorie',
    'Move' => 'Déplacer',
    '[quant,_1,TrackBack]' => '[quant,_1,TrackBack]', # Translate - Previous (4)
    'categories' => 'catégories',
    'Delete selected categories (x)' => 'Effacer les catégories sélectionnées (x)',

    ## ./tmpl/cms/edit_placements.tmpl
    'The secondary categories for this entry have been updated. You will need to SAVE the entry for these changes to be reflected on your public site.' => 'Les catégories secondaires de cette note ont été mises à jour. Vous devez enregistrer la note pour voir les modifications reflétées sur votre site public',
    'Categories in your weblog:' => 'Catégories de votre weblog :',
    'Secondary categories:' => 'Catégories secondaires :',
    'Assign &gt;&gt;' => 'Assigner &gt;&gt;',
    '&lt;&lt; Remove' => '&lt;&lt; Supprimer',

    ## ./tmpl/cms/rebuild-stub.tmpl

    ## ./tmpl/wizard/mt-config.tmpl

    ## ./tmpl/wizard/packages.tmpl
    'Requirements Check' => 'Vérifications des éléments nécessaires',
    'One of the following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your weblog data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the \'Retry\' button.' => 'L\'un des modules PERL suivants est nécessaire pour créer la connexion à la base de données. Movable type nécessite une base de données pour stocker les données des weblogs. Merci d\'en installer une parmi cette liste pour pouvoir continuer. Dès que cette opération est réalisée, cliquez sur le bouton  \'Recommencer\'',
    'Missing Database Packages' => 'Eléments de base de données manquants',
    'The following optional, feature-enhancing Perl modules could not be found. You may install them now and click \'Retry\' or simply continue without them.  They can be installed at any time if needed.' => 'Les Modules Perl  permettants d\'ajouter des fonctionnalités optionnelles n\'ont pas été trouvés. Vous pouvez en faire l\'installation maintenant et cliquer sur le bouton \'Recommencer\' ou simplement continuer sans cela. Ils peuvent être installés à n\'importe quel moment si nécessaire.',
    'Missing Optional Packages' => 'Eléments optionnels manquants',
    'The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the \'Retry\' button to re-test for these packages.' => 'Les modules PERL suivants sont nécessaires au bon fonctionnement de Movable Type. Dès que vous disposez de ces éléments, cliquez sur le bouton \'Recommencer\' pour vérifier ces élements..',
    'Missing Required Packages' => 'Eléments indispensables manquants',
    'Minimal version requirement:' => 'Version minimale requise:',
    'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'Votre serveur possède tous les modules nécessaires; vous n\'avez pas à procéder à des installations complémentaires de modules',
    'Retry' => 'Recommencer',

    ## ./tmpl/wizard/optional.tmpl
    'Mail Configuration' => 'Configuration Mail',
    'Your mail configuration is complete. Click \'Continue\' below to configure your authentication settings.' => 'Votre configuration email est terminée. Cliquez sur \'Continuer\' ci-dessous pour configurer vos paramètres d\'authentification ',
    'You can configure you mail settings from here, or you can configure your authentication settings by clicking \'Continue\'.' => 'Vous pouvez configurer vos paramètres d\'email à ce niveau, ou configurer vos paramètres d\'authentification en cliquant sur \'Continuer \'.',
    'You can configure your mail settings from here, or you can configure your authentication settings by clicking \'Continue\'.' => 'Vous pouvez configurer vos paramètres d\'email à ce niveau, ou configurer vos paramètres d\'authentification en cliquant sur \'Continuer \'.',
    'An error occurred while attempting to send mail: ' => 'Une erreur s\'est produite en essayant d\'envoyer un email: ',
    'MailTransfer' => 'Transfert email',
    'Select One...' => 'Sélectionner un...',
    'SendMailPath' => 'Chemin envoi email',
    'The physical file path for your sendmail.' => 'Chemin d\'accès à votre fichier d\'envoi email.',
    'SMTP Server' => 'Serveur SMTP',
    'Address of your SMTP Server' => 'Adresse de votre serveur SMTP',
    'Mail address for test sending' => 'Adresse email pour envoi d\'un test',
    'Send Test Email' => 'envoi d\'un email de test',

    ## ./tmpl/wizard/complete.tmpl
    'We were unable to create your configuration file.' => 'Vous n\'avez pas pu créer votre fichier de configuration.',
    'If you would like to check the directory permissions and retry, click the \'Retry\' button.' => 'Si vous souhaitez vérifier les droits du répertoire et essayer à nouveau, cliquez sur le bouton \'Réessayer\'',
    'Congratulations! You\'ve successfully configured [_1] [_2].' => 'Bravo! vous avez configuré avec succès [_1] [_2].',
    'This is a copy of your configuration settings.' => 'Voici une copie de vos paramètres de configuration.',
    'Install' => 'Installer',

    ## ./tmpl/wizard/header.tmpl
    'Movable Type Enterprise' => 'Movable Type Enterprise', # Translate - Previous (3)
    'Movable Type Enterprise Configuration Wizard' => 'Assistant de Configuration Movable Type Enterprise',

    ## ./tmpl/wizard/start.tmpl
    'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Pour utiliser Movable Type, vous devez activer les JavaScript sur votre navigateur. Merci de les activer et de relancer le navigateur pour commencer.',
    'Your Movable Type configuration file already exists. The Wizard cannot continue with this file present.' => 'Votre fichier de configuration Movable Type existe déjà. L\'Assistant de Configuration ne peut continuer avec ce fichier installé',
    'This wizard will help you configure the basic settings needed to run Movable Type.' => 'L\'Assistant de Configuration vous permettra de mettre en place les paramètres de base pour assurer le fonctionnement de Movable Type.',
    'Static Web Path' => 'Chemin Web statique',
    'Due to your server\'s configuration it is not accessible in its current location and must be moved to a web-accessible location (e.g. into your web document root directory).' => 'En raison de la configuration de votre serveur il n\'est pas accessible à cet endroit, vous devez donc le déplacer sur une zone accessible via le web ( par exemple dans les documents web de votre répertoire racine)',
    'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Ce répertoire a été renommé ou déplacé en dehors du répertoire Movable Type.',
    'Please specify the web-accessible URL to this directory below.' => 'Merci de spécifier l\'URL d\'accès web au répertoire ci-dessous.',
    'Static web path URL' => 'URL du chemin d\'accès statique',
    'This can be in the form of http://example.com/mt-static/ or simply /mt-static' => 'Ceci peut être de la forme http://example.com/mt-static/ ou simplement /mt-static',
    'Begin' => 'Commencer',

    ## ./tmpl/wizard/cfg_dir.tmpl
    'Temporary Directory Configuration' => 'Configuration du répertoire temporaire',
    'You should configure you temporary directory settings.' => 'Vous devriez configurer les paramètres de votre répertoire temporaire.',
    'Your TempDir configuration is success. Click \'Continue\' below to configure your mail settings.' => 'La configuration de votre TempDir est réussie. Cliquez sur \'Continuer\' ci-dessous pour  configurer vos paramètres Email.',
    'Your TempDir has been successfully configured. Click \'Continue\' below to configure your mail settings.' => 'Votre TempDir a été correctement configuré. Cliquez ci-dessous sur \'Continuer\' pour configurer vos paramètres emails.',
    '[_1] could not be found.' => '[_1] introuvable.',
    '[_1] is not writable.' => '[_1] non éditable.',
    'TempDir is required.' => 'TempDir est requis.',
    'TempDir' => 'TempDir', # Translate - Previous (1)
    'The physical path for temporary directory.' => 'Chemin physique pour le répertoire temporaire.',

    ## ./tmpl/wizard/configure.tmpl
    'You must set your Database Name.' => 'Vous devez définir un Nom de Base de données.',
    'You must set your Username.' => 'Vous devez définir votre nom d\'utilisateur.',
    'You must set your Database Server.' => 'Vous devez définir votre serveur de Base de données.',
    'Database Configuration' => 'Configuration de la Base de Données',
    'Your database configuration is complete. Click \'Continue\' below to configure your temporary directory settings.' => 'La configuration de votre base de données est terminée. Cliquez sur \'Continuer\' ci-dessous pour configurer les paramètres de votre répertoire temporaire.',
    'Please enter the parameters necessary for connecting to your database.If your database type is not listed in the dropdown below, you may be missing the Perl module necessary to connect to your database.  If this is the case, please check your installation and click <a href=' => 'Merci de saisir les paramètres de connexion à votre base de données. Si votre base de données n\'est pas listée dans la liste déroulante ci-dessous, c\'est qu\'il vous manque peut-être le module PERL de connexion à la base de données.  Si c\'est le cas, merci de vérifier votre installation et cliquez sur <a href=',
    'An error occurred while attempting to connect to the database: ' => 'Une erreur s\'est produite lors de la tentative de connexion à la base de données: ',
    'Database' => 'Base de données',
    'Database Name' => 'Nom de la Base de données',
    'The name of your SQL database (this database must already exist).' => 'Le nom de votre Base de données SQL (cette base de données doit être déjà présente).',
    'The username to login to your SQL database.' => 'Le nom d\'utilisateur pour accèder à la Base de données SQL.',
    'The password to login to your SQL database.' => 'Le mot de passe pour accèder à la Base de données SQL.',
    'Database Server' => 'Serveur de Base de données',
    'This is usually \'localhost\'.' => 'C\'est habituellement \'localhost\'.',
    'Database Port' => 'Port de la Base de données',
    'This can usually be left blank.' => 'Peut être laissé vierge.',
    'Database Socket' => 'Socket de la Base de données',
    'Publish Charset' => 'Publier le  Charset',
    'MS SQL Server driver must use either Shift_JIS or ISO-8859-1.  MS SQL Server driver does not support UTF-8 or any other character set.' => 'Le driver  Serveur MS SQL doit utiliser Shift_JIS ou ISO-8859-1.  Le driver serveur MS SQL ne supporte pas UTF-8 ou tout autre jeu de caractères.',
    'Test Connection' => 'Test de Connexion',

    ## ./tmpl/wizard/cfg_ldap.tmpl
    'You must set your Authentication URL.' => 'Vous devez paramétrer votre URL d\'Authentication.',
    'You must set your Group search base.' => 'Vous devez paramétrer votre base de recherche de Groupe.',
    'You must set your UserID attribute.' => 'Vous devez paramétrer l\'attribut de votre UserID.',
    'You must set your email attribute.' => 'Vous devez paramétrer l\'attribut de votre email.',
    'You must set your user fullname attribute.' => 'Vous devez paramétrer l\'attribut de votre nom complet.',
    'You must set your user member attribute.' => 'Vous devez paramétrer l\'attribut membre.',
    'You must set your GroupID attribute.' => 'Vous devez paramétrer l\'attribut GroupeID.',
    'You must set your group name attribute.' => 'Vous devez paramétrer l\'attribut du nom de groupe.',
    'You must set your group fullname attribute.' => 'You must set your group fullname attribute.', # Translate - Previous (7)
    'You must set your group member attribute.' => 'Vous devez paramétrer l\'attribut de membre de groupe.',
    'Authentication Configuration' => 'Configuration d\'authentification',
    'You can configure your LDAP settings from here if you would like to use LDAP-based authentication.' => 'Vous pouvez configurer ici les paramètres de votre LDAP si vous voulez utiliser l\'identification via le LDAP.', 
    'Your configuration was successful. Click \'Continue\' below to configure the External User Management settings.' => 'Votre configuration est réussie. Cliquez sur  \'Continuer\' si dessous pour les paramètres ExternalUserManagement.', 
    'Your configuration was successful. Click \'Continue\' below to configure your LDAP attribute mappings.' => 'Votre configuration est réussie. Cliquez sur \'Continuer\' pour définir les paramètres de mapping.',     'Your LDAP configuration is complete. To finish with the configuration wizard, press \'Continue\' below.' => 'Votre configuration LDAP est terminée. pour quitter l\'aide à la configuration cliquez sur  \'Continuer\' ci-dessous.',
    'An error occurred while attempting to connect to the LDAP server: ' => 'Une erreur s\'est produite lors de la tentative de connection à votre serveur LDAP: ',
    'Authentication mode' => 'Mode Authentication',
    'Use LDAP' => 'Utiliser LDAP',
    'Connection setting' => 'Paramètres de Connection',
    'Authentication URL' => 'URL Authentification',
    'The URL to access for LDAP authentication.' => 'URL pour accéder à l\'authentification LDAP.',
    'Authentication DN' => 'Authentication DN', # Translate - Previous (2)
    'An optional DN used to bind to the LDAP directory when searching for a user.' => 'An optional DN used to bind to the LDAP directory when searching for a user.', # Translate - Previous (15)
    'Authentication password' => 'Authentication Mot de Passe',
    'Used for setting the password of the LDAP DN.' => 'Utilisé pour le paramétrage du mot de passe du LDAP DN.',
    'SASL Mechanism' => 'SASL Mechanisme',
    'The name of SASL Mechanism to use for both binding and authentication.' => 'Le nom du Mechanisme SASL a utiliser à la fois pour authentifier ou attacher.',
    'Test connection' => 'Test de connection',
    'Enable External User Management' => 'Activer La Gestion Externe des Utilisateurs', # Translate - New (4)
    'Synchronization Frequency' => 'Fréquence de Synchronisation', # Translate - New (2)
    'Frequency of synchronization in minutes. (Default is 60 minutes)' => 'Fréquence de synchronisation en minutes. (60 minutes par défaut)', # Translate - New (9)
    'Group search base attribute' => 'Attribut de recherche de Groupe dans la Base',
    'Group filter attribute' => 'Attribut filtre Groupe',
    'Search Results (max 10 entries)' => 'Résultats de la recherche (10 notes max.)', # Translate - New (5)
    'CN' => 'CN', # Translate - Previous (1)
    'No groups were found with these settings.' => 'Aucun groupe correspondant à ces paramètres n\'a été trouvé.', # Translate - New (7)
    'Attribute mapping' => 'Attribut de mapping',
    'LDAP Server' => 'Serveur LDAP',
    'Other' => 'Autre',
    'UserID attribute' => 'Attribut UserID',
    'Email attribute' => 'Attribut Email',
    'User fullname attribute' => 'Attribut nom complet utilisateur',
    'User member attribute' => 'Attribut Utilisateur membre',
    'GroupID attribute' => 'Attribut GroupID',
    'Group name attribute' => 'Attribut Nom du Groupe',
    'Group fullname attribute' => 'Attribut Nom complet du groupe',
    'Group member attribute' => 'Attribut Membre Groupe',
    'Search result (max 10 entries)' => 'Résultat de recherche (max 10 notes)',
    'ID' => 'ID', # Translate - Previous (1)
    'Group Fullname' => 'Nom complet du Groupe',
    'Group Member' => 'Membre du Groupe',
    'No groups could be found.' => 'Aucun groupe trouvé.', 
    'User Fullname' => 'Nom complet utilisateur',
    'No users could be found.' => 'Aucun utilisateur trouvé.', 
    'Test connection to LDAP' => 'Test de connection au LDAP',
    'Test search' => 'Test recherche',

    ## ./tmpl/wizard/footer.tmpl

    ## ./tmpl/feeds/feed_chrome.tmpl

    ## ./tmpl/feeds/feed_comment.tmpl
    'system' => 'système',
    'Blog' => 'Blog', # Translate - Previous (1)
    'Untitled' => 'Sans nom',
    'Edit' => 'Editer',
    'Unpublish' => 'Dé-publier',
    'More like this' => 'Plus du même genre',
    'From this blog' => 'De ce blog',
    'On this entry' => 'Sur cette note',
    'By commenter identity' => 'Par identité de l\'auteur de commentaires',
    'By commenter name' => 'Par nom de l\'auteur de commentaires',
    'By commenter email' => 'Par l\'e-mail de l\'auteur de commentaires',
    'By commenter URL' => 'Par URL de l\'auteur de commentaires',
    'On this day' => 'Pendant cette journée',

    ## ./tmpl/feeds/error.tmpl
    'Movable Type Activity Log' => 'Movable Type Log d\'activité',
    'Movable Type System Activity' => 'Movable Type activité du système',

    ## ./tmpl/feeds/feed_entry.tmpl
    'From this author' => 'De cet auteur',

    ## ./tmpl/feeds/login.tmpl
    'This link is invalid. Please resubscribe to your activity feed.' => 'Ce lien n\'est pas valide. Merci de souscrire à nouveau à votre flux d\'activité.',

    ## ./tmpl/feeds/feed_ping.tmpl
    'Source blog' => 'Blog source',
    'By source blog' => 'Par le blog source',
    'By source title' => 'Par le titre de la source',
    'By source URL' => 'Par l\'URL de la source',

    ## ./tmpl/feeds/feed_system.tmpl

    ## ./tmpl/email/recover-password.tmpl

    ## ./tmpl/email/new-comment.tmpl
    'An unapproved comment has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => 'Un commentaire non approuvé a été envoyé sur votre blog [_1], pour la note #[_2] ([_3]). Vous devez l\'approuver pour qu\'il apparaisse sur votre blog.',
    'Approve this comment:' => 'Approuver ce commentaire:',
    'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Un nouveau commentaire a été publié sur votre weblog [_1], au sujet de la note [_2] ([_3]). ',
    'View this comment:' => 'Afficher ce commentaire :',
    'Comments:' => 'Commentaires :',

    ## ./tmpl/email/notify-entry.tmpl
    '[_1] Update: [_2]' => '[_1] Mise à jour : [_2]',
    '(This entry is unpublished.)' => '(Cette note n\'est pas publiée.)',

    ## ./tmpl/email/verify-subscribe.tmpl
    'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Merci d\'avoir pour votre inscription aux mises à jours [_1]. Cliquez sur le lien ci-dessous pour confirmer cette inscription :',
    'If the link is not clickable, just copy and paste it into your browser.' => 'Si le lien n\'est pas cliquable, faites simplement un copier-coller dans votre navigateur.',

    ## ./tmpl/email/new-ping.tmpl
    'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Un Trackback non approuvé a été envoyé pour votre weblog [_1], pour la note #[_2] ([_3]). Vous devez l\'approuver pour qu\'il apparaisse sur votre blog.',
    'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Un Trackback non approuvé a été envoyé pour votre weblog [_1], pour la catégorie #[_2], ([_3]). Vous devez l\'approuver pour qu\'il apparaisse sur votre blog.',
    'Approve this TrackBack:' => 'Approuver ce TrackBack :',
    'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Un nouveau Trackback a été envoyé sur votre blog [_1], sur la note #[_2] ([_3]).',
    'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'Un nouveau Trackback a été envoyé sur votre blog [_1], sur la catégorie #[_2] ([_3]).',
    'View this TrackBack:' => 'Voir ce TrackBack :',

    ## ./tmpl/email/footer-email.tmpl
    'Powered by Movable Type' => 'Powered by Movable Type', # Translate - Previous (4)

    ## ./t/driver-tests.pl

    ## ./t/blog-common.pl

    ## ./t/test-common.pl

    ## ./t/test.tmpl

    ## ./t/plugins/testplug.pl

    ## Other phrases, with English translations.
    'Bad ObjectDriver config' => 'Mauvaise config ObjectDriver',
    'Invalid auhtor' => 'Auteur non valide', # Translate - New (2)
    'Invalid author' => 'Auteur non valide',
    'Two plugins are in conflict' => 'Deux plugins sont en conflit',
    'The previous post in this blog was <a href="[_1]">[_2]</a>.' => 'La précédente note de ce blog était <a href="[_1]">[_2]</a>.',
    'RSS 1.0 Index' => 'Index RSS 1.0',
    'Comment \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4]) from entry \'[_5]\' (entry #[_6])' => 'Commentaire \'[_1]\' (#[_2]) effacé par \'[_3]\' (utilisateur #[_4]) de la note \'[_5]\' (note #[_6])', # Translate - New (13)
    'Create Entries' => 'Création d\'une note',
    'Remove Tags...' => 'Enlever les Tags...',
    '_BLOG_CONFIG_MODE_BASIC' => 'Mode basique',
    'No weblog was selected to clone.' => 'Aucun weblog n\'a été sélectionné pour la duplication', # Translate - New (6)
    'Username or password recovery phrase is incorrect.' => 'La phrase test pour retrouver votre identifiant ou votre mot de passe est incorrecte.', # Translate - New (7)
    'This page contains an archive of all entries posted to [_1] in the <strong>[_2]</strong> category.  They are listed from oldest to newest.' => 'Cette page contient les archives de toutes les notes postées sur [_1] dans la catégorie <strong>[_2]</strong>. Elles sont classées de la plus ancienne à la plus récente.',
    'Comment Pending Message' => 'Message de Commentaire en Attente', # Translate - New (3)
    '_NO_SUPERUSER_DISABLE' => 'Puisque vous êtes administrateur du système Movable Type, vous ne pouvez vous désactiver vous-même.', # Translate - New (4)
    'Finished! You can <a href="javascript:void(0);" onclick=\"closeDialog(\'[_1]\');">return to the weblogs listing</a> or <a href="javascript:void(0);" onclick="closeDialog(\'[_2]\');">configure the SitePath and SiteURL of the new weblog</a>.' => 'Terminé! Vous pouvez <a href="javascript:void(0);" onclick=\"closeDialog(\'[_1]\');">retourner à la liste des weblogs</a> or <a href="javascript:void(0);" onclick="closeDialog(\'[_2]\');">pour confugurer le  CheminSite et l\'URL du site pour un nouveau weblog</a>.',
    'Invalid attempt to recover password (used recovery phrase \'[_1]\')' => 'Tentative non valide de récupération du mot de passe (a utilisé la phrase test \'[_1]\')', # Translate - New (9)
    'Updating blog old archive link status...' => 'Modification de l\'ancien statut du lien d\'archive du blog...',
    '_USAGE_COMMENTS_LIST_ALL_WEBLOGS' => 'Voici la liste des commentaires de tous les weblogs que vous pouvez filtrer, gérer et éditer.',
    'Movable Type Enterprise has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.' => 'Movable Type Enterprise vient de tenter de désactiver votre compte pendant la synchronisation avec l\'annuaire externe. Certains des paramètres du sytème de gestion externe des utilisateurs doivent être erronés. Merci de corriger avant de poursuivre.', # Translate - New (32)
    'Showing' => 'Affiche', # Translate - New (1)
    '_USAGE_COMMENT' => 'Modifiez le commentaire sélectionné. Cliquez sur Enregistrer une fois les modifications apportées. Vous devrez actualiser vos fichiers pour voir les modifications reflétées sur votre site.',
    'No password recovery phrase set in user profile. Please see your system administrator for password recovery.' => 'Le profil ne contient pas de phrase test pour la récupération du mot de passe. Merci de contacter l\'administrateur système pour récupérer votre mot de passe.', # Translate - New (16)
    'Database Path' => 'Chemin de la Base de Données', # Translate - New (2)
    'Deleting a user is an irrevocable action which creates orphans of the author\'s entries.  If you wish to retire a user or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete this author?' => 'La suppression d\'un utilisateur est irrévocable et peut créer des notes orphelines (sans utilisateur). Si vous souhaitez retirer l\'accès au système à un utilisateur, il est recommandé de lui retirer les droits plutôt que de le supprimer. Êtes-vous sûr de vouloir supprimer cet utilisateur ?',
    'An error occurred processing [_1]. Check <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">here</a> for more detail and please try again.' => 'Une erreur est survenue pendant le traitement [_1]. Consultez <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">cette page</a> pour plus de détails et réessayez après.',
    'Created template \'[_1]\'.' => 'A créé le template \'[_1]\'.', # Translate - New (3)
    'View image' => 'Voir l\'image',
    'Date-Based Archive' => 'Archivage par date',
    'Enable External User Management' => 'Activer La Gestion Externe des Utilisateurs', # Translate - New (4)
    'Assigning visible status for comments...' => 'Ajout du statut visible pour les commentaires...',
    'Step 4 of 4' => 'Etape 4 sur 4', # Translate - New (4)
    'Designer' => 'Designer', # Translate - Previous (1)
    'Create a feed widget' => 'Créer un nouveau widget de flux',
    'Enter the ID of the weblog you wish to use as the source for new personal weblogs. The new weblog will be identical to the source except for the name, publishing paths and permissions.' => 'Saisissez l\'identifiant du weblog que vous souhaitez utiliser comme source pour créer votre nouveau weblog personnel. Le nouveau weblog sera identique au blog source à l\'exception du nom, du chemin de publication et des autorisations associées.', # Translate - New (34)
    'Bad CGIPath config' => 'Mauvaise config CGIPath',
    'Weblog Administrator' => 'Administrateur du weblog',
    'If present, 3rd argument to add_callback must be an object of type MT::Plugin' => 'Si présent, le 3ème argument de add_callback doit être un object de type MT::Plugin',
    '_USAGE_GROUPS_USER' => 'Ci-dessous une liste des groupes dont l utilisateur est membre. Vous pouvez enlever un utilisateur d un groupe dont il est membre en sélectionnant le groupe adéquat et en cliquant sur supprimer',
    '_WARNING_PASSWORD_RESET_MULTI' => 'Vous êtes sur le point de réinitialiser le mot de passe des utilisateurs sélectionnés. Les nouveaux mots de passe sont générés automatiquement et serront envoyés directement aux utilisateurs par e-mail.\n\nEtes-vous sûr de vouloir continuer ?',
    'You must define a Comment Listing template in order to display dynamic comments.' => 'Vous devez définir un template Comment Listing pour afficher des commentaires dynamiquement.',
    'Assigning blog administration permissions...' => 'Ajout des permissions d\'administration du blog...',
    'Invalid LDAPAuthURL scheme: [_1].' => 'Schéma LDAPAuthURL non valide: [_1].', # Translate - New (4)
    'Can edit all entries/categories/tags on a weblog and rebuild.' => 'Peut éditer toutes les notes/catégorie/tags sur un weblog et republier.', # Translate - New (11)
    'Category Archive' => 'Archivage par catégorie',
    'Monitor' => 'Controler',
    'Updating user permissions for editing tags...' => 'Modification des permissions des utilisateurs pour modifier les balises...',
    '_USAGE_EXPORT_1' => 'L\'exportation de vos notes de Movable Type vous permet de créer une <b>version de sauvegarde</b> du contenu de votre weblog. Le format des notes exportées convient à leur importation dans le système à l\'aide du mécanisme d\'importation (voir ci-dessus), ce qui vous permet, en plus d\'exporter vos notes à des fins de sauvegarde, d\'utiliser cette fonction pour <b>transférer vos notes d\'un weblog à un autre</b>.',
    'Setting default blog file extension...' => 'Ajout de l\'extension de fichier par défaut du blog...',
    'Migrating permissions to roles...' => 'Migre les autorisations vers les roles...', # Translate - New (4)
    '<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> est la catégorie précédente.',
    'Name:' => 'Nom:', # Translate - New (1)
    'Atom Index' => 'Index Atom',
    'Weblog \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' créé par \'[_2]\' (utilisateur #[_3])', # Translate - New (7)
    'Invalid priority level [_1] at add_callback' => 'Niveau de priorité invalide [_1] dans add_callback',
    'Add Tags...' => 'Ajouter des Tags...',
    '_THROTTLED_COMMENT_EMAIL' => 'Un visiteur de votre weblog [_1] a été automatiquement bannit après avoir publié une quantité de commentaires supérieure à la limite établie au cours des [_2] secondes. Cette opération est destinée à empêcher la publication automatisée de commentaires par des scripts. L\'adresse IP bannie est

    [_3]

S\'il s\'agit d\'une erreur, vous pouvez annuler le bannissement de l\'adresse IP dans Movable Type, sous Configuration du weblog > Bannissement d\'adresses IP, et en supprimant l\'adresse IP [_4] de la liste des addresses bannies.',
    'Permission denied for non-superuser' => 'Autorisation refusée pour les non super-utilisateurs',
    'Ping \'[_1]\' (ping #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Ping \'[_1]\' (ping #[_2]) effacé par \'[_3]\' (utilisateur #[_4])', # Translate - New (9)
    'Category \'[_1]\' (category #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Catégorie \'[_1]\' (catégorie #[_2]) effacée par \'[_3]\' (utilisateur #[_4])', # Translate - New (9)
    'MONTHLY_ADV' => 'par mois',
    '_USER_ENABLED' => 'Utilisateur activé',
    'Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]' => 'Pour envoyer des mails via SMTP votre serveur doit avoir Mail::Sendmail installé: [_1]',
    'Manage Tags' => 'Gérer les Tags',
    'Taxonomist' => 'Taxonomist', # Translate - Previous (1)
    '_USAGE_BOOKMARKLET_3' => 'Pour installer le signet QuickPost de Movable Type: déposez le lien suivant dans le menu ou la barre d\'outils des liens favoris de votre navigateur.',
    'Are you sure you want to delete the selected group(s)?' => 'Etes-vous sûr de vouloir supprimer le(s) groupe(s) sélectionné(s)? ', # Translate - New (11)
    'Assigning user status...' => 'Attribue le statut utilisateur...', # Translate - New (3)
    'User \'[_1]\' (#[_2]) untrusted commenter \'[_3]\' (#[_4]).' => 'Utilisateur \'[_1]\' (#[_2]) a considéré non fiable le commentateur \'[_3]\' (#[_4]).', # Translate - New (7)
    'Create New User Association' => 'Créer Association Nouvel Utilisateur', # Translate - New (4)
    'File with name \'[_1]\' already exists. (Install File::Temp if you\'d like to be able to overwrite existing uploaded files.)' => 'Le fichier dont le nom est \'[_1]\' existe déjà. (Installez File::Temp si vous souhaitez pouvoir écraser les fichiers déjà chargés.)',
    'Category \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Catégorie \'[_1]\' créée par \'[_2]\' (utilisateur #[_3])', # Translate - New (7)
    'DBI and DBD::SQLite2 are required if you want to use the SQLite2 database backend.' => 'DBI et DBD::SQLite2 sont nécessaires si vous souhaitez utiliser SQLite2 comme base de données.',
    'Are you sure you want to delete the [_1] selected [_2]?' => 'Etes-vous sûr de vouloir supprimer les [_1] [_2] sélectionné(e)s?', # Translate - New (11)
    '_USAGE_GROUPS_LDAP' => 'Ceci est un message pour les groupes sous LDAP.',
    'New TrackBack for entry #[_1] \'[_2]\'.' => 'Nouveau TrackBack pour la note #[_1] \'[_2]\'.', # Translate - New (6)
    'An error occured during synchronization: [_1]' => 'Une erreur s\'est produite pendant la synchronisation: [_1]', # Translate - New (6)
    '4th argument to add_callback must be a CODE reference.' => '4ème argument de add_callback doit être une référence de CODE.',
    'Or return to the <a href="[_1]">Main Menu</a> or <a href="[_2]">System Overview</a>.' => 'Ou retournez au <a href="[_1]">Menu Principal</a> ou à l\'<a href="[_2]">Aperçu du général du Système</a>.',
    'Can create entries and edit their own.' => 'Peuvent créer et éditer leurs propres notes.', # Translate - New (7)
    'Monthly' => 'Mensuelles',
    'Editor' => 'Editeur',
    'Refreshing template \'[_1]\'.' => 'Actualisation du modèle \'[_1]\'.',
    'Ban Commenter(s)' => 'Bannir cet auteur de commentaires',
    'Installation instructions.' => 'Instruction d\'Installation.', # Translate - New (2)
    'Secretary' => 'Secretaire',
    '_USAGE_ARCHIVING_3' => 'Sélectionnez le type d\'archive auquel vous souhaitez ajouter un modèle. Sélectionnez le modèle que vous souhaitez associer à ce type d\'archive.',
    'Hello, world' => 'Bonjour,', # Translate - New (2)
    'You need to create some users.' => 'Vous devez créer des utilisateurs.', # Translate - New (6)
    'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Saut du modèle \'[_1]\' car c\'est un modèle personnalisé.',
    'The above settings have been written to the file <tt>[_1]</tt>. If any of these settings are incorrect, you may click the \'Back\' button below to reconfigure them.' => 'Les paramètres ci-dessus ont été enregistrés dans le fichier <tt>[_1]</tt>. Si un de ces paramètres est incorrect, veuillez cliquer sur le bouton \'Retour\' ci-dessous pour modifier la configuration.',
    '_USER_DISABLE' => 'Désactiver',
    'You used an \'[_1]\' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an \'MTComments\' container?' => 'Vous avez utilisé une balise \'[_1]\' en dehors du contexte d\'un commentaire; peut-être l\'avez vous mis par erreur en dehors du conteneur \'MTComments\' ?',
    '_ERROR_CGI_PATH' => 'Votre configuration de chemin CGI est invalide ou absente de vos fichiers de configuration Movable Type. Merci de consulter la base de connaissance',
    'Insufficient permissions to modify templates for weblog \'[_1]\'' => 'Niveau d\'autorisation insuffisant pour modifier le template du weblog \'[_1]\'', # Translate - New (8)
    'Assigning template build dynamic settings...' => 'Ajout des réglages de construction dynamique du template...',
    '_USAGE_AUTHORS_2' => 'Vous pouvez créer, éditer ou supprimer des utilisateurs en utilisant un fichier commande au format CSV.',
    '_USAGE_CATEGORIES' => 'Les catégories permettent de regrouper vos notes pour en faciliter la gestion, la mise en archives et l\'affichage dans votre weblog. Vous pouvez affecter une catégorie à chaque note que vous créez ou modifiez. Pour modifier une catégorie existante, cliquez sur son titre. Pour créer une sous-catégorie, cliquez sur le bouton Créer correspondant. Pour déplacer une catégorie, cliquez sur le bouton Déplacer correspondant.',
    'User \'[_1]\' (#[_2]) trusted commenter \'[_3]\' (#[_4]).' => 'Utilisateur \'[_1]\' (#[_2]) a considéré comme fiable le commentateur \'[_3]\' (#[_4]).', # Translate - New (7)
    'Tags \'[_1]\' (tags #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Tags \'[_1]\' (tags #[_2]) effacé par \'[_3]\' (utilisateur #[_4])', # Translate - New (9)
    'URL:' => 'URL:', # Translate - New (1)
    'Template \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Template \'[_1]\' créé par \'[_2]\' (utilisateur #[_3])', # Translate - New (7)
    'Weekly' => 'Hebdomadaire',
    'New TrackBack for category #[_1] \'[_2]\'.' => 'Nouveau TrackBack pour la catégorie #[_1] \'[_2]\'.', # Translate - New (6)
    'No pages were found containing "[_1]".' => 'Aucune page trouvée contenant "[_1]".', # Translate - New (6)
    '. Now you can comment.' => '. Maintenant vous pouvez commenter.', # Translate - New (5)
    'Unpublish TrackBack(s)' => 'TrackBack(s) non publié(s)',
    'You need to provide a password if you are going to\ncreate new users for each user listed in your blog.\n' => 'Vous devez fournir un mot de passe si vous allez\ncréer de nouveaux utilisateurs pour chaque utilisateur listé dans votre blog.\n',
    'Weblog \'[_1]\' deleted by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' effacé par \'[_2]\' (utilisateur #[_3])', # Translate - New (7)
    'The physical file path for your BerkeleyDB or SQLite database. ' => 'Le chemin d\'accès fichier pour votre base de données BerkeleyDB ou SQLite. ', # Translate - New (10)
    'Many more can be found on the <a href="[_1]">main index page</a> or by looking through <a href="[_2]">the archives</a>.' => 'Beaucoup d\'autres notes peuvent être trouvés sur la page <a href="[_1]">d\'accueil principale</a> ou en cherchant dans <a href="[_2]">les archives</a>.',
    '_USAGE_PREFS' => 'Cet écran vous permet de définir un grand nombre des paramètres de votre weblog, de vos archives, des commentaires et de communication de notifications. Ces paramètres ont tous des valeurs par défaut raisonnables lors de la création d\'un nouveau weblog.',
    'WEEKLY_ADV' => 'hebdomadaire',
    'Other...' => 'Autre...', # Translate - New (1)
    'If you have a TypeKey identity, you can ' => 'Si vous avez une identité TypeKey, vous pouvez ',
    'Can create entries, edit their own and upload files.' => 'Peuvent créer et éditer des notes et uploader des fichiers.', # Translate - New (9)
    'Please enter the parameters necessary for connecting to your database.If your database type is not listed in the dropdown below, you may be missing the Perl module necessary to connect to your database.  If this is the case, please check your installation and click <a href="?__mode=configure">here</a> to re-test your installation.' => 'Merci de saisir les paramètres nécessaires pour se connecter à votre base de données. Si votre base de données n\'est pas listée dans le menu déroulant ci-dessous, il manque sûrement le module Perl nécéssaire à la connexion avec votre base de données. Si c\'est le cas, merci de vérifier votre configuration et cliquez ensuite <a href="?__mode=configure">ici</a> pour effectuer à nouveau un test de votre installation.',
    '_USAGE_ARCHIVING_2' => 'Lorsque vous associez plusieurs modèles à un type d\'archive particulier -- ou même lorsque vous n\'en associez qu\'un seul -- vous pouvez personnaliser le chemin des fichiers d\'archive à l\'aide des modèles correspondants.',
    'User \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Utilisateur \'[_1]\' créé par \'[_2]\' (utilisateur #[_3])', # Translate - New (7)
    'Refresh Template(s)' => 'Actualiser le(s) Modèles(s)',
    'Password was reset for user \'[_1]\' (ID:[_2]) and sent to address: [_3]' => 'Le mot de passe a été réinitié pour l\'utilisateur \'[_1]\' (ID:[_2]) et envoyé à l\'adresse: [_3]', # Translate - New (13)
    'Assigning basename for categories...' => 'Ajout de racines aux catégories...',
    '_USAGE_NOTIFICATIONS' => 'Les personnes suivantes souhaitent être averties de la publication d\'une nouvelle note sur votre site. Vous pouvez ajouter un utilisateur en indiquant son adresse e-mail dans le formulaire suivant. L\'adresse URL est facultative. Pour supprimer un utilisateur, cochez la case Supprimer dans le tableau ci-dessous, puis cliquez sur le bouton Supprimer.',
    'Future' => 'Futur', # Translate - New (1)
    'Editor (can upload)' => 'Editeur (peut télécharger)',
    '_ERROR_DATABASE_CONNECTION' => 'Les paramètres de votre base de données sont soit invalides, absents ou ne peuvent pas être lus correctement. Consultez la base de connaissances pour plus d\'informations.',
    '_USAGE_BANLIST' => 'Cette liste est la liste des adresses IP qui ne sont pas autorisées à publier de commentaires ou envoyer des pings TrackBack à votre site. Vous pouvez ajouter une nouvelle adresse IP dans le formulaire suivant. Pour supprimer une adresse de la liste des adresses IP bannies, cochez la case Supprimer dans le tableau ci-dessous, puis cliquez sur le bouton Supprimer.',
    'RSS 2.0 Index' => 'Index RSS 2.0',
    'Select a Design using StyleCatcher' => 'Sélectionner un modèle via StyleCatcher',
    'New comment for entry #[_1] \'[_2]\'.' => 'Nouveau commentaire sur la note #[_1] \'[_2]\'.', # Translate - New (6)
    '_USER_DISABLED' => 'Utilisateur désactivé',
    '<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> est l\'archive précédente.',
    '_USAGE_NEW_AUTHOR' => ' A partir de cette page vous pouvez créer de nouveaux utilisateurs dans le système et définir leurs accès dans un ou plusieurs weblogs.',
    '_USAGE_COMMENTS_LIST_OVERVIEW' => 'Voici la liste des commentaires de tous vos weblogs, que vous pouvez filtrer, gérer et éditer',
    'Manage my Widgets' => 'Gérer mes Widgets',
    'Weblog Associations' => 'Associations du weblog', # Translate - New (2)
    'Updating blog comment email requirements...' => 'Mise à jour des prérequis des emails pour les commentaires du blog...',
    'Publish Entries' => 'Publier les notes',
    'The following groups were deleted' => 'Les groupes suivants ont été effacés', # Translate - New (5)
    'You cannot disable yourself' => 'Vous ne pouvez vous désactiver vous même', # Translate - New (4)
    '_USER_STATUS_CAPTION' => 'Statut',
    'You are not allowed to edit the permissions of this user.' => 'Vous n\'êtes pas autorisé à modifier les autorisations de cet utilisateur.', # Translate - New (11)
    '<em><strong>Please Note:</strong> The Movable Type export format is not comprehensive and is not suitable for creating full-fidelity backups. Please see the Movable Type manual for full details.</em>' => '<em><strong>Note :</strong> Le format d\'export de Movable Type n\'est pas destiné à réaliser des sauvegardes intégrales. Merci de consulter la documentation de Movable Type pour plus d\'informations.</em>',
    '<$MTCategoryTrackbackLink$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<$MTCategoryTrackbackLink$> doit être utilisé dans le contexte d\'une catégorie ou avec l\'attribut  \'categorie\' au tag.', # Translate - New (19)
    '_USAGE_PLUGINS' => 'Voici la liste de tous les plugins actuellement enregistrés avec Movable type.',
    'Tagger' => 'Tagueur', # Translate - Previous (1)
    'Publisher' => 'Publié par',
    'Manager' => 'Manager', # Translate - Previous (1)
    '_GENL_USAGE_PROFILE' => 'Modifiez le profil utilisateur ici. Si vous modifier l\'identifiant ou le mot de passe utilisateur, la mise à jour sera effective immédiatement. En d\'autres termes, l\'utilisateur n\'aura pas besoin de se réidentifier.',
    '(None)' => '(Aucun)', # Translate - New (2)
    'Frequency of synchronization in minutes. (Default is 60 minutes)' => 'Fréquence de synchronisation en minutes. (60 minutes par défaut)', # Translate - New (9)
    '_USAGE_PERMISSIONS_2' => 'Vous pouvez modifier les permissions affectées à un utilisateur en sélectionnant ce dernier dans le menu déroulant, puis en cliquant sur Modifier.',
    'Insufficient permissions for modifying templates for this weblog.' => 'Permissions insuffisantes pour modifier les templates de ce weblog.',
    'Bad ObjectDriver config: [_1] ' => 'Mauvaise config ObjectDriver : [_1] ',
    'No email specified in user profile.  Please see your system administrator for password recovery.' => 'Le profil ne contient pas d\'adresse email. Merci de contacter votre administrateur système pour récupérer votre mot de passe.', # Translate - New (14)
    'Untrust Commenter(s)' => 'Retirer le statut fiable à cet auteur de commentaires',
    'Hello, [_1]' => 'Bonjour, [_1]', # Translate - New (2)
    'Can edit, manage and rebuild weblog templates.' => 'Peuvent éditer, gérer et republier les templates du weblog.', # Translate - New (7)
    'To download more plugins, check out the <a href="http://www.sixapart.com/pronet/plugins/">Six Apart Plugin Directory</a>.' => 'Pour télécharger plus de plugins, visitez la page <a href="http://www.sixapart.com/pronet/plugins/">Six Apart Plugin Directory</a>.',
    'Assigning custom dynamic template settings...' => 'Ajout des réglages spécifiques de template dynamique...',
    'Updating comment status flags...' => 'Modification des statuts des commentaires...',
    'Updating user web services passwords...' => 'Mise à jour des mots de passe des services web de l\'utilisateur...',
    'Stylesheet' => 'Feuille de style',
    'You used an \'[_1]\' tag outside of the context of a ping; perhaps you mistakenly placed it outside of an \'MTPings\' container?' => 'Vous avez utilisé une balise \'[_1]\' en dehors d\'un contexte de ping; peut-être l\'avez-vous placé en dehors du conteneur \'MTPings\' ?',
    '_THROTTLED_COMMENT' => 'Dans le but de réduire les possibilités d\'abus, j\'ai activé une fonction obligeant les auteurs de commentaires à attendre quelques instants avant de publier un autre commentaire. Veuillez attendre quelques instants avant de publier un autre commentaire. Merci.',
    'Are you sure you want to delete the selected user(s)?' => 'Etes-vous sûr de vouloir effacer les utilisateurs sélectionnés?', # Translate - New (11)
    '_USAGE_SEARCH' => 'Vous pouvez utiliser l\'outil de recherche et de remplacement pour effectuer des recherches dans vos notes ou pour remplacer chaque occurrence d\'un mot, d\'une phrase ou d\'un caractère par un autre. Important: faites preuve de prudence, car <b>il n\'existe pas de fonction d\'annulation</b>. Nous vous recommandons même d\'exporter vos notes Movable Type avant, par précaution.',
    'Your profile has been updated.' => 'Votre profil a été mis à jour.', # Translate - New (5)
    'Refreshing (with <a href=\"?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]\">backup</a>) template \'[_3]\'.' => 'Rafraîchit (avec <a href=\"?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]\">backup</a>) template \'[_3]\'.', # Translate - New (20)
    'Can\'t enable/disable that way' => 'Vous ne pouvez pas activer ou désactiver de cette manière',
    '_external_link_target' => '_haut',
    '_AUTO' => '1',
    'Password recovery for user \'[_1]\' failed due to lack of recovery phrase specified in profile.' => 'La récupération du mot de passe pour l\'utilisateur \'[_1]\' a échoué du fait de l\'absence de phrase test de récupération de mot de passe dans le profile.', # Translate - New (15)
    'Setting new entry defaults for weblogs...' => 'Mise en place des nouvelles valeurs par défaut des notes des weblogs...',
    'Writer (can upload)' => 'Auteur (Peut télécharger)',
    'Updating entry week numbers...' => 'Mise à jour des numéros des semaines de la note...',
    '_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.org/sitefr/"><$MTProductName$></a>',
    'Assigning comment/moderation settings...' => 'Mise en place des réglages commentaire/modération ...',
    'You can not add users to a disabled group.' => 'Vous ne pouvez ajouter des utilisateurs à des groupes désactivés.', # Translate - New (9)
    'Communications Manager' => 'Gestionnaire des communications',
    'Clone Weblog' => 'Cloner le weblog',
    '_USAGE_ARCHIVING_1' => 'Sélectionnez les fréquences/types de mise en archives du contenu de votre site. Vous pouvez, pour chaque type de mise en archives que vous choisissez, affecter plusieurs modèles devant être appliqués. Par exemple, vous pouvez créer deux affichages différents de vos archives mensuelles: un contenant les notes d\'un mois particulier et l\'autre présentant les notes dans un calendrier.',
    'Application log for blog \'[_1]\' reset by \'[_2]\' (user #[_3])' => 'Log d\'application pour le blog \'[_1]\' réinitié par \'[_2]\' (utilisateur #[_3])', # Translate - New (10)
    'Finished! You can <a href=\'[_1]\'>return to the weblogs listing</a> or <a href=\'[_2]\'>view the new weblog</a>.' => 'Terminé! Vous pouvez <a href=\'[_1]\'>retourner à la liste des weblogs </a> ou bien <a href=\'[_2]\'>voir le nouveau weblog</a>.', # Translate - New (21)
    'Permission denied' => 'Autorisation refusée',
    '_USAGE_AUTHORS_1' => 'Ceci est la liste de tous utilisateurs dans cette installation Movable Type. Vous pouvez modifier les droits d\'un utilisateur en cliquant sur son nom. Vous pouvez effacer un utilisateur de façon permanente en cochant la case adéquate puis en sélectionnant Supprimer dans le menu déroulant. NOTE: si vous souhaitez simplement retirer un utilisateur sur un blog en particulier, modifiez les droits de l\'utilisateur, sachez qu\'en supprimant un utilisateur il disparaîtra de tout le système. Vous pouvez créer, éditer ou supprimer les informations d\'un utilisateur en utilisant un fichier de commande au format CSV.',
    'Error creating temporary file; please check your TempDir setting in mt.cfg (currently \'[_1]\') this location should be writable.' => 'Erreur lors de la création d\'un fichier temporaire; merci de vérifier le TempDir dans mt.cfg (actuellement \'[_1]\') ce répertoire doit avoir les droits en écriture.',
    'View This Weblog\'s Activity Log' => 'Voir le journal d\'activité pour ce weblog',
    '_USAGE_IMPORT' => 'Vous pouvez utiliser le mécanisme d\'importation de notes pour importer vos notes d\'un autre système de gestion de weblog (Blogger ou Greymatter, par exemple). Ce mode d\'emploi contient des instructions complètes pour l\'importation de vos notes; le formulaire suivant vous permet d\'importer tout un lot de notes déjC  exportées d\'un autre système, et d\'enregistrer les fichiers de façon à pouvoir les utiliser dans Movable Type. Consultez le mode d\'emploi avant d\'utiliser ce formulaire de façon à sélectionner les options adéquates.',
    'IP Address:' => 'Adresse IP :', # Translate - New (2)
    'Main Index' => 'Index principal',
    'No new status given' => 'Aucun nouveau statut attribué',
    'Invalid login attempt from user \'[_1]\' (ID: [_2])' => 'Tentative d\'identification invalide par l\'utilisateur \'[_1]\' (ID: [_2])', # Translate - New (8)
    '<p>You must define a global theme repository where themes can be stored locally.  If a particular blog has not been configured for it\'s own theme paths, it will use these settings directly. If a blog has it\'s own theme paths, then the theme will be copied to that location when applied to that weblog. The paths defined here must physically exist and be writable by the webserver.</p>' => '<p>Vous devez définir un répertoire global où les thèmes seront stockés localement. Si un blog particulier n\'a pas été configuré avec ces propres chemins d\'accès au thèmes, il utilisera ce répertoire global par défaut. Si par contre un blog a ses propres chemins d\'accès au thèmes, le thème appliqué sera alors copié dans ce répertoire. Les chemins définis doivent exister sur le serveur et doivent être modifiés par le serveur (droits en écriture).</p>',
    'You did not select any [_1] to delete.' => 'Vous n\'avez sélectionné aucun [_1] à effacer.', # Translate - New (8)
    '_USAGE_EXPORT_3' => 'Le lien suivant entraîne l\'exportation de toutes les notes de votre weblog vers le serveur Tangent. Il s\'agit généralement d\'une opération ponctuelle, réalisée à la suite de l\'installation du module Tangent pour Movable Type.',
    'Application log reset by \'[_1]\' (user #[_2])' => 'Log d\'application réinitié par \'[_1]\' (utilisateur #[_2])', # Translate - New (7)
    'A default location of \'./db\' will store the database file(s) underneath your Movable Type directory.' => 'La localisation par défaut \'./db\' stockera les fichiers de la base de données sous votre répertoire Movable Type.', # Translate - New (16)
    'Delete selected users (x)' => 'Effacer les utilisateurs sélectionnés (x)', # Translate - New (4)
    'User \'[_1]\' (user #[_2]) logged out' => 'Utilisateur \'[_1]\' (utilisateur #[_2]) s\'est déconnecté', # Translate - New (6)
    'Edit Role' => 'Modifier Role', # Translate - New (2)
    '_BLOG_CONFIG_MODE_DETAIL' => 'Mode détaillé',
    'Some ([_1]) of the selected user(s) could not be updated.' => 'Certain(e)s ([_1]) des utilisateurs sélectionnés n\'ont pu être mis à jour.', # Translate - New (11)
    'Updating category placements...' => 'Modification des placements de catégories...',
    '_USAGE_BOOKMARKLET_4' => 'QuickPost vous permet de publier vos notes à partir de n\'importe quel point du web. Vous pouvez, en cours de consultation d\'une page que vous souhaitez mentionner, cliquez sur QuickPost pour ouvrir une fenêtre popup contenant des options Movable Type spéciales. Cette fenêtre vous permet de sélectionner le weblog dans lequel vous souhaitez publier la note, puis de la créer et de la publier.',
    'Notification \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => 'Notification \'[_1]\' (#[_2]) effacé par \'[_3]\' (utilisateur #[_4])', # Translate - New (8)
    'DAILY_ADV' => 'de façon quotidienne',
    'Communicator' => 'Communicateur',
    '_USAGE_PERMISSIONS_3' => 'Il existe deux façons d\'accorder ou de révoquer les privilèges d\'accès affectés aux utilisateurs. La première est de sélectionner un utilisateur parmi ceux du menu ci-dessous et de cliquer sur Modifier. La seconde est de consulter la liste de tous les utilisateurs, puis de sélectionner l\'utilisateur que vous souhaitez modifier ou supprimer.',
    'Found' => 'Trouvé(e)', # Translate - New (1)
    '_NOTIFY_REQUIRE_CONFIRMATION' => 'Un email a été envoyé à [_1]. Pour valider votre inscription, merci de cliquer sur le lien qui figure dans cet email. Il permettra de vérifier que votre adresse email est valable.',
    'Tags to remove from selected entries' => 'Tags à enlever des notes sélectionnées',
    'Manage Notification List' => 'Gérer la liste de notification',
    'Individual' => 'Individuelles',
    'Last Entry' => 'Dernière Note', # Translate - New (2)
    'An error occurred while testing for the new tag name.' => 'Une erreur est survenue en testant la nouvelle balise.',
    'Before you can do this, you need to create some groups. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a group.' => 'Avant de faire ceci, vous devez créer des groupes.. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Cliquez ici</a> pour créer un groupe.', # Translate - New (25)
    'Your changes to [_1]\'s profile has been updated.' => 'Les changements que vous avez apportés au profil de [_1] ont été mis à jour.', # Translate - New (9)
    '_USAGE_FORGOT_PASSWORD_2' => 'Ce nouveau mot de passe devrait vous permettre d\'ouvrir une session Movable Type. Vous pourrez changer ce mot de passe une fois la session ouverte.',
    'Authored On' => 'Publication initiale le', # Translate - New (2)
    '_SEARCH_SIDEBAR' => 'Rechercher',
    'Unban Commenter(s)' => 'Réautoriser cet auteur de commentaires',
    'Individual Entry Archive' => 'Archivage par note',
    'Daily' => 'Quotidien',
    'Unpublish Entries' => 'Annuler publication',
    'Setting blog basename limits...' => 'Setting blog basename limits...', # Translate - Previous (4)
    'Powered by [_1]' => 'Powered by [_1]', # Translate - Previous (3)
    'Commenter Feed (Disabled)' => 'Flux Commentateur (Désactivé)', # Translate - New (3)
    'Personal weblog clone source ID' => 'ID du weblog source pour la duplication', # Translate - New (5)
    '_USAGE_UPLOAD' => 'Vous pouvez télécharger le fichier ci-dessus dans le chemin local de votre site <a href="javascript:alert(\'[_1]\')">(?)</a> ou dans le chemin des archives de votre site <a href="javascript:alert(\'[_2]\')">(?)</a>. Vous pouvez également télécharger le fichier dans un répertoire compris dans les répertoires mentionnés ci-dessus, en spécifiant le chemin dans les champs de droite (<i>images</i>, par exemple). Les répertoires qui n\'existent pas encore seront créés.',
    '<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> est l\'archive suivante.',
    'Updating commenter records...' => 'Modification des données du commentateur...',
    'Now you can comment.' => 'Maintenant vous pouvez commenter.', # Translate - New (4)
    'Assigning junk status for comments...' => 'Ajout du statut spam pour les commentaires...',
    'Deleting a user is an irrevocable action which creates orphans of the author\'s entries.  If you wish to retire a user or remove their access to the system, removing all of their permissions is th e recommended course of action.  Are you sure you want to delete the [_1] selected users?' => 'Effacer un auteur est une action définitive et génère des notes orphelines dans le système. Si vous voulez supprimer un utilisateur, nous vous recommandons de procéder en lui enlevant tous ses accès au système. Etes-vous certain de vouloir supprimer définitivement les utilisateurs sélectionnés[_1]?',
    '_USAGE_REBUILD' => 'Vous devrez cliquer sur <a href="#" onclick="doRebuild()">Actualiser</a> pour voir les modifications reflétées sur votre site publiî',
    'Refreshing (with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>) template \'[_3]\'.' => 'Actualisation (depuis une <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">sauvegarde</a>) du modèle \'[_3]\'.',
    'Invalid blog_id' => 'Identifiant du blog non valide', # Translate - New (3)
    'CATEGORY_ADV' => 'par catégorie',
    'Blog Administrator' => 'Administrateur Blog',
    'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Fichier de configuration manquant. Avez-vous oublié de déplacer mt-config.cgi-original vers mt-config.cgi?',
    'Dynamic Site Bootstrapper' => 'Initialisateur de site dynamique',
    'You need to create some roles.' => 'Vous devez créer des rôles.', # Translate - New (6)
    'Assigning entry basenames for old entries...' => 'Ajout des racines des notes pour les anciennes notes...',
    '_USAGE_COMMENTS_LIST_BLOG' => 'Voici la liste des Commentaires pour [_1] que vous pouvez filtrer, gérer et éditer.',
    'Error sending mail ([_1]); please fix the problem, then try again to recover your password.' => 'Erreur d\'envoi du mail ([_1]); merci de corriger le problème, puis essayez à nouveau de récupérer votre mot de passe.',
    'Error saving entry: [_1]' => 'Erreur d\'enregistrement de la note: [_1]',
    'index' => 'index', # Translate - Previous (1)
    'Invalid login attempt from user [_1]: [_2]' => 'Tentative d\'identification non valide de l\'utilisateur [_1]: [_2]', # Translate - New (7)
    'User \'[_1]\' (#[_2]) unbanned commenter \'[_3]\' (#[_4]).' => 'Utilisateur \'[_1]\' (#[_2]) a retirer le statut non fiable au commentateur \'[_3]\' (#[_4]).', # Translate - New (7)
    'Assigning visible status for TrackBacks...' => 'Ajout du statut visible des TrackBacks...',
    '_USAGE_PLACEMENTS' => 'Les outils d\'édition permettent de gérer les catégories secondaires auxquelles cette note est associée. La liste de gauche contient les catégories auxquelles cette note n\'est pas encore associée en tant que catégorie principale ou catégorie secondaire ; la liste de droite contient les catégories secondaires auxquelles cette note est associée.',
    '_USAGE_ASSOCIATIONS' => 'Cette page affiche les associations existantes et vous pouvez en créer de nouvelles.',
    'Adds template tags to allow you to search for content from Google. You will need to configure this plugin using a <a href=\'http://www.google.com/apis/\'>license key.</a>' => 'Ajoute des tags aux modèles qui vous permettrons de rechercher du contenu sur Google. Vous aurez besoin de configurer ce plugin avec une <a href=\'http://www.google.com/apis/\'>clé de licence</a>.',
    'This page contains a single entry from the blog posted on <strong>[_1]</strong>.' => 'Cette page contient une note postée sur on <strong>[_1]</strong>.',
    'Wrong object type' => 'Erreur dans le type d\'objet',
    'Search Template' => 'Template de Recherche',
    'It can be included onto your published blog using <a href="[_1]">WidgetManager</a> or this MTInclude tag' => 'Cela peut être intégré dans votre blog en utilisant le <a href="[_1]">Gestionnaire de Widgets</a> ou grâce au tag MTInclude',
    '_USAGE_PASSWORD_RESET' => 'Ci-dessous, vous pouvez réinitialiser le mot de passe pour cet utilisateur. Si vous faites cela un mot de passe généré aléatoirement sera créé et envoyé par e-mail à : [_1].',
    'Download file' => 'Télécharger le fichier',
    'Error connecting to LDAP server [_1]: [_2]' => 'Erreur de connection au serveur LDAP [_1]: [_2]', # Translate - New (7)
    'Edit Profile' => 'Editer le profil', # Translate - New (2)
    'Error loading default templates.' => 'Erreur pendant le chargement des templates par défaut.',
    'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'Vous n\'avez pas un chemin valide vers sendmail sur votre machine. Vous devriez essayer SMTP?',
    'You are currently performing a search. Please wait until your search is completed.' => 'Vous êtes en train d\'effectuer une recherche. Merci d\'attendre que la recherche soit finie.',
    'An errror occurred when enabling this user.' => 'Une erreur s\'est produite lors de l\'activation de cet utilisateur.', # Translate - New (7)
    '_USAGE_LIST_POWER' => 'Cette liste est la liste des notes de [_1] en mode d\'édition par lots. Le formulaire ci-dessous vous permet de changer les valeurs des notes affichées ; cliquez sur le bouton Enregistrer une fois les modifications souhaitées effectuées. Les fonctions de la liste possibles avec les Notes existantes fonctionnent en mode de traitement par lots comme en mode standard.',
    'Below is a list of the members in the <b>[_1]</b> group. Click on a user\'s username to see the details for that user.' => 'Ci-dessous une liste des membres du groupe <b>[_1]</b>. Cliquez sur le nom d\'utilisateur pour consulter les détails d\'un utilisateur donné.', # Translate - New (26)
    '_ERROR_CONFIG_FILE' => 'Votre fichier configuration Movable type est absent ou ne peut pas être lu correctement. Merci de consulter la base de connaissances',
    'This action can only be run for a single weblog at a time.' => 'Cette action peut être effectuée uniquement blog par blog.', # Translate - New (13)
    '_WARNING_PASSWORD_RESET_SINGLE' => '_WARNING_PASSWORD_RESET_SINGLE', # Translate - Previous (5)
    '_USAGE_PING_LIST_BLOG' => 'Voici la liste des Trackbacks pour [_1]  que vous pouvez filtrer, gérer et éditer.',
    'You must set your Database Path.' => 'Vous devez définir le Chemin de Base de Données.', # Translate - New (6)
    'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.' => 'StyleCatcher vous permet de naviguer facilement à travers des styles et de les appliquer à votre blog en quelques clics seulement. Pour en savoir plus à propos des styles Movable Type, ou pour avoir de nouvelles sources de styles, visitez la page <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a>.',
    'The LDAP directory ID for this group.' => 'L\'ID de ce groupe dans l\'annuaire LDAP.', # Translate - New (7)
    '_USAGE_GROUPS' => 'Ceci est le message pour les groupes.',
    'If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the <code>import</code> folder of your Movable Type directory.' => 'Si le fichier à importer est sur votre ordinateur, vous pouvez le télécharger ici. Sinon, Movable Type va automatiquement rechercher ce fichier dans le dossier <code>import</code> du dossier principal de Movable Type.',
    'If you want to change the SitePath and SiteURL, <a href=\'[_1]\'>click here</a>.' => 'Si vous voulez changer le Chemin du site et l\'URL du site, <a href=\'[_1]\'>cliquez ici</a>.', # Translate - New (15)
    'Password recovery for user \'[_1]\' failed due to lack of email specified in profile.' => 'La récupération du mot de passe de l\'utilisateur\'[_1]\' a échoué à cause de l\'absence d\'adresse email dans le profil.', # Translate - New (14)
    'Tags to add to selected entries' => 'Tags à ajouter aux notes séléctionnées',
    'Entry "[_1]" added by user "[_2]"' => 'Note "[_1]" ajoutée par l\'utilisateur "[_2]"', # Translate - New (6)
    '_USAGE_VIEW_LOG' => 'L\'erreur est enregistrée dans le <a href="[_1]">journal des activité</a>.',
    'You are not allowed to edit the profile of this user.' => 'Vous n\'êtes pas autorisé à éditer le profil de cet utilisateur.', # Translate - New (11)
    '_USAGE_BOOKMARKLET_1' => 'La configuration de la fonction QuickPost vous permet de publier vos notes en un seul clic sans même utiliser l\'interface principale de Movable Type.',
    'You must define an Individual template in order to display dynamic comments.' => 'Vous devez définir un template Individual pour pouvoir afficher du contenu dynamique.',
    'UTC+10' => 'UTC+10', # Translate - Previous (2)
    'INDIVIDUAL_ADV' => 'par note',
    'Can upload files, edit all entries/categories/tags on a weblog, rebuild and send notifications.' => 'Peuvent uploader des fichiers, éditer toutes les notes/catégories/tags d\'un weblog, republier le weblog et envoyer des notifications.', # Translate - New (15)
    'Entry \'[_1]\' (entry #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Note \'[_1]\' (note #[_2]) effacée par \'[_3]\' (utilisateur #[_4])', # Translate - New (9)
    'all rows' => 'toutes les lignes', # Translate - New (2)
    '_USAGE_GROUP_PROFILE' => 'Cet écran vous permet de modifier le profil du groupe.',
    'User \'[_1]\' (user #[_2]) logged in successfully' => 'Utilisateur \'[_1]\' (utilisateur #[_2]) s\'est identifié avec succès', # Translate - New (7)
    'Error during upgrade: [_1]' => 'Erreur pendant l\'upgrade: [_1]', # Translate - New (4)
    'Master Archive Index' => 'Index principal des archives',
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly context.' => 'Vous avez utilisé une balise [_1] en dehors d\'un contexte Daily, Weekly, ou Monthly.',
    'Step 2 of 4' => 'Etape 2 sur 4', # Translate - New (4)
    'Deleting a user is an irrevocable action which creates orphans of the user\'s entries.  If you wish to retire a user or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete this user?' => 'Effacer un utilisateur est une action définitive qui crée des liens orphelins sur les notes du dit utilisateur.  Si vous voulez empêcher un utilisateur d\'accéder au système, il est préférable de lui retirer toutes ses autorisations. Etes-vous sûr de vouloir effacer cet utilisateur?', # Translate - New (49)
    'Before you can do this, you need to create some roles. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Click here</a> to create a role.' => 'Avant de faire ceci, vous devez d\'abord créer des rôles. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Cliquez ici</a> pour créer un rôle.', # Translate - New (25)
    'Another amount...' => 'Un autre montant...', # Translate - New (2)
    'Movable type' => 'Movable Type', # Translate - New (2)
    'You can not create associations for disabled groups.' => 'Vous ne pouvez pas créer d\'association pour des groupes désactivés.', # Translate - New (8)
    'Grant a new role to [_1]' => 'Attribuer un nouveau rôle à [_1]', # Translate - New (6)
    '_WARNING_DELETE_USER' => 'Supprimer un utilisateur est une action définitive qui va créer des notes orphelines. Si vous souhaitez retirer un utilisateur ou supprimer un accès utilisateur désactiver son compte est recommandé. Etes-vous sur de vouloir supprimer cet utilisateur?',
    'You used an \'[_1]\' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an \'MTEntries\' container?' => 'Vous avez utilisé une balise \'[_1]\' en dehors du contexte d\'une note; peut-être l\'avez vous mise en dehors du conteneur \'MTEntries\' ?',
    'We were unable to create your configuration file. If you would like to check the directory permissions and retry, click the \'Retry\' button.' => 'Nou n\'avons pas réussi à créer votre fichier de configuration. Merci de vérifier le répertoire des autorisations puis de faire une nouvelle tentative en cliquant sur le bouton \'Réessayer\'.', # Translate - New (23)
    'Before you can do this, you need to create some users. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Click here</a> to create a role.' => 'Avant de faire ceci, vous devez créer des utilisateurs. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Cliquez ici</a> pour créer un rôle.', # Translate - New (25)
    'Create New Group Association' => 'Créer une Association Nouveau Groupe', # Translate - New (4)
    'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Même si Movable Type semble fonctionner normalement, cela se déroule <strong>dans uns environnement non testé et non supporté</strong>.  Nous recommandons fortement que vous installiez un version de Perl supérieure ou égale à [_1].', # Translate - New (23)
    'Unpublish Comment(s)' => 'Annuler publication commentaire(s)',
    'The next post in this blog is <a href="[_1]">[_2]</a>.' => 'La note suivante de ce blog est <a href="[_1]">[_2]</a>.',
    'Processing templates for weblog \'[_1]\'' => 'Traitement des templates pour le weblog \'[_1]\'',
    '_USAGE_ENTRY_LIST_OVERVIEW' => 'Voici la liste des notes de tous les weblogs que vous pouvez filtrer, gérer et éditer.',
    'Synchronization Frequency' => 'Fréquence de Synchronisation', # Translate - New (2)
    'Can upload files, edit all entries/categories/tags on a weblog and rebuild.' => 'Peuvent uploader des fichiers, éditer toutes les notes/catégories/tags d\'un weblog et le republier.', # Translate - New (13)
    'No new user status given' => 'Aucun statut Nouvel Utilisateur attribué', # Translate - New (5)
    'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Format de date invalide \'[_1]\'; doit être \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM est optionnel)',
    'Drag and drop the widgets you want into the <strong>Installed</strong> column.' => 'Glissez-déposez les widgets de votre choix dans la colonne <strong>Widgets installés</strong>.',
    'Manage Categories' => 'Gérer les Catégories',
    'Assigning user types...' => 'Ajout des types d\'utilisateurs...',
    'Writer' => 'Auteur',
    'Before you can do this, you need to create some roles. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a role.' => 'Avant de faire ceci, vous devez créer des rôles. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Cliquez ici</a> pour créer un rôle.', # Translate - New (25)
    'UTC+11' => 'UTC+11', # Translate - Previous (2)
    'Migrating any "tag" categories to new tags...' => 'Migration des catégories de "tag" vers de nouveaux tags...',
    'Before you can do this, you need to create some users. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a user.' => 'Avant de faire ceci, vous devez créer des utilisateurs. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Cliquez ici</a> pour créer un utilisateur.', # Translate - New (25)
    'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Le module Perl Image::Size est requis pour déterminer la largeur et la hauteur des images uploadées.', # Translate - New (14)
    'Edit Permissions' => 'Editer les Autorisations', # Translate - New (2)
    '_USAGE_COMMENTERS_LIST' => 'Cette liste est la liste des auteurs de commentaires pour [_1].',
    'File with name \'[_1]\' already exists; Tried to write to tempfile, but open failed: [_2]' => 'Le fichier avec le nom \'[_1]\' existe déjà; Tentative d\'écriture dans un fichier temporaire, mais l\'ouverture a échoué : [_2]',
    'Updating [_1] records...' => 'Mise à jour des données [_1] ...',
    'Configure Weblog' => 'Configurer le Weblog',
    '_INDEX_INTRO' => '<p>Si vous ninstallez Movable Type, il vous sera certainement utile de consulter <a href="http://www.sixapart.com/movabletype/docs/mtinstall.html">la documentation d\'installation</a> et <a rel="nofollow" href="mt-check.cgi">le système de vérification de Movable Type</a> pour vérifier que votre système est conforme.</p>',
    '_USAGE_AUTHORS' => 'Cette liste est la liste de tous les utilisateurs du système Movable Type. Vous pouvez changer les droits accordés à un utilisateur en cliquant sur son nom et supprimer un utilisateur en cochant la case adéquate, puis en cliquant sur <b>Supprimer</b>. Remarque : si vous ne souhaitez supprimer un utilisateur que d\'un weblog spécifique, il vous suffit de changer les droits qui lui sont accordés ; la suppression d\'un utilisateur affecte tout le système.',
    '_USAGE_FEEDBACK_PREFS' => 'Cette page vous permet de configurer les manières dont un lecteur peut contribuer sur votre weblog',
    '_USAGE_FORGOT_PASSWORD_1' => 'Vous avez demandé à récupérer votre mot de passe Movable Type. Votre mot de passe a été changé au niveau du système ; le nouveau mot de passe est le suivant:',
    'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides.' => 'Les modules suivants sont <strong>optionnels</strong>. Si votre serveur ne possède pas ces modules, vous devez le(s) installer uniquement si vous souhaitez bénéficier des fonctionnalités offertes par le module.',
    'No groups were found with these settings.' => 'Aucun groupe correspondant à ces paramètres n\'a été trouvé.', # Translate - New (7)
    '_USAGE_EXPORT_2' => 'Pour exporter vos notes: cliquez sur le lien ci-dessous (Exporter les notes de [_1]). Pour enregistrer les données exportées dans un fichier, vous pouvez enfoncer la touche <code>option</code> (Macintosh) ou <code>Maj</code> (Windows) et la maintenir enfoncée tout en cliquant sur le lien. Vous pouvez également sélectionner toutes les données et les copier dans un autre document. <a href="#" onclick="openManual(\'importing\', \'export_ie\');return false;">Vous exportez des données depuis Internet Explorer ?</a>',
    '_USAGE_PING_LIST_ALL_WEBLOGS' => 'Voici une liste de Ping de Trackback de tous les weblogs que vous pouvez filtrer, gérer et éditer.',
    'Cloning categories for weblog.' => 'Duplication des catégories pour le weblog.', # Translate - New (4)
    'Assigning junk status for TrackBacks...' => 'Ajout du statut spam pour les TrackBacks...',
    'Failed login attempt with incorrect password by user \'[_1]\' (ID: [_2])' => 'La tentative d\'identification par l\'utilisateur\'[_1]\' (ID: [_2]) a échoué à cause d\'un mot de passe invalide', # Translate - New (11)
    'No executable code' => 'Pas de code exécutable',
    '_USAGE_PING_LIST_OVERVIEW' => 'Voici la liste des Trackbacks de tous vos weblogs que vous pouvez filtrer, gérer et éditer',
    'AUTO DETECT' => 'DETECTION AUTOMATIQUE',
    'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Par défaut, ce moteur va rechercher tous les mots, quelque soit leur ordre. Pour lancer une recherch sur une phrase exacte, insérer la phrase entre des apostrophes : ', # Translate - New (23)
    '_USAGE_GROUPS_USER_LDAP' => 'Ci-dessous la liste des groupe dont l utilisateur est membre',
    'You need to create some groups.' => 'Vous devez créer des groupes.', # Translate - New (6)
    'You need to create some weblogs.' => 'Vous devez créer des weblogs.', # Translate - New (6)
    'No birthplace, cannot recover password' => 'Pas de lieu de naissance. Ne peut retrouver le mot de passe', # Translate - New (5)
    'Install <a href=\'http://greasemonkey.mozdev.org/\'>GreaseMonkey</a>' => 'Installer <a href=\'http://greasemonkey.mozdev.org/\'>GreaseMonkey</a>',
    'Finished! You can <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">return to the weblogs listing</a> or <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_2]\');\">configure the Site root and URL of the new weblog</a>.' => 'Terminé! Vous pouvez <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">retourner à la liste des weblogs</a> ou bien <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_2]\');\">configurer la racine du Site et l\'URL du nouveau weblog</a>.', # Translate - New (35)
    '_WARNING_DELETE_USER_EUM' => 'Supprimer une utilisateur est une action définitive qui va créer des notes oprhelines. Si vous voulez retirer un utilisateur ou lui supprimer ses accès nous vous recommandons de désactiver son compte. Etes-vous sur de vouloir supprimer cet utilisateur? Attention il pourra se re-créer un accès s\'il existe encore dans le répertoire externe',
    '_USER_ENABLE' => 'Activer',
    'Can administer the weblog.' => 'Peut administrer le weblog.', # Translate - New (4)
    '_USAGE_PROFILE' => 'Cet espace permet de changer votre profil d\'utilisateur. Les modifications apportées à votre nom d\'utilisateur et à votre mot de passe sont automatiquement mises à jour. En d\'autres termes, vous devrez ouvrir une nouvelle session.',
    'Category' => 'Catégorie',
    'Congratulations! A template module Widget named <strong>[_1]</strong> has been created which you can further <a href="[_2]">edit</a> to customize its display.' => 'Félicitations ! Un modèle de Widget nommé <strong>[_1]</strong> a bien été créé, vous pouvez le <a href="[_2]">modifier</a> ultérieurement pour personnaliser son affichage.',
    '_USAGE_AUTHORS_LDAP' => 'Voici la liste de tous les utilisateurs de Movable Type dans le système. Vous pouvez modifier les autorisations accordées à un utilisateur en cliquant sur son nom. Vous pouvez désactiver un utilisateur en cochant la case à coté de son nom, puis en cliquant sur DESACTIVER. Ceci fait, l\'utilisateur ne pourra plus s\'identifier sur Movable Type.',
    'An error occured during synchronization.  See the <a href=\'[_1]\'>activity log</a> for detailed information.' => 'Une erreur s\'est produite durant la synchronisation.  Consultez les <a href=\'[_1]\'>logs d\'activité</a> pour plus d\'information.', # Translate - New (16)
    '_USAGE_ENTRYPREFS' => 'La configuration des champs détermine les champs de saisie qui apparaîtront dans les écrans de création et de modification des notes. Vous pouvez sélectionner une configuration existante (basique ou avancée), ou personnaliser vos écrans en activant le bouton Personnalisée, puis en sélectionnant les champs que vous souhaitez voir apparaître.',
    '_USAGE_NEW_GROUP' => 'Depuis cet écran vous pouvez créer un nouveau groupe dans le système.',
    'You can not add disabled users to groups.' => 'Vous ne pouvez ajouter des utilisateurs désactivés dans des groupes.', # Translate - New (8)
    'Are you sure you want to delete the selected user(s)?\nThey will be able to re-create themselves if selected user(s) still exist in LDAP.' => 'Etes-vous sûr de vouloir effacer le(s) utilisateur(s) sélectionné(s)? Ils seront capables de se créer de nouveau un compte s\'ils existent toujours dans le LDAP.', # Translate - New (26)
    'RSD' => 'RSD', # Translate - Previous (1)
    'Template \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => 'Template \'[_1]\' (#[_2]) effacé par \'[_3]\' (utilisateur #[_4])', # Translate - New (8)
    'User \'[_1]\' (#[_2]) banned commenter \'[_3]\' (#[_4]).' => 'Utilisateur \'[_1]\' (#[_2]) a classé non fiable le commentateur \'[_3]\' (#[_4]).', # Translate - New (7)
    '_USAGE_ROLES' => 'Ci-dessous la liste de tous les rôles dont vous bénéficiez pour vos weblogs.',
    'Invalid username \'[_1]\' in password recovery attempt' => 'Nom d\'utilisateur non valide \'[_1]\' lors de la tentative de récupération du mot de passe', # Translate - New (7)
    'Not Found' => 'Pas trouvé', # Translate - New (2)
    'Error creating new template: ' => 'Erreur pendant la création du nouveau template: ', # Translate - New (4)
    'You cannot modify your own permissions.' => 'Vous ne pouvez modifier vos propres autorisations.', # Translate - New (6)
    '_USAGE_ARCHIVE_MAPS' => 'Cette fonctionnalité avancée vous permet de faire correspondre un modèle d\'archives à plusieurs types d\'archives. Par exemple, vous pouvez decider de créer deux vues différentes pour vos archives mensuelles : une pour les notes d\'un mois donné, présentées en liste, une autre affichant les notes sur un calendrier mensuel.',
    'Trust Commenter(s)' => 'Donner statut fiable à cet auteur de commentaires',
    'Manage Templates' => 'Gérer les Modèles',
    'Before you can do this, you need to create some groups. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Click here</a> to create a role.' => 'Avant de faire ceci, vous devez créer des groupes. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Cliquez ici</a> pour créer un groupe.', # Translate - New (25)
    '_USAGE_BOOKMARKLET_2' => 'La structure de la fonction QuickPost de Movable Type vous permet de personnaliser la mise en page et les champs de votre page QuickPost. Par exemple, vous pouvez ajouter une option d\'ajout d\'extraits par l\'intermédiaire de la fenêtre QuickPost. Une fenêtre QuickPost comprend, par défaut, les éléments suivants: un menu déroulant permettant de sélectionner le weblog dans lequel publier la note ; un menu déroulant permettant de sélectionner l\'état de publication (brouillon ou publié) de la nouvelle note ; un champ de saisie du titre de la note ; et un champ de saisie du corps de la note.',
    '_USAGE_CATEGORY_PING_URL' => 'C est l URL utilisée par les autres pour envoyer des Trackbacks à votre weblog. Si vous voulez que n importe qui puisse envoyer un Trackback à votre site spécifique à cette catégorie, publiez cette URL. Si vous préférez que cela soit réservé à certaines personnes, il faut leur envoyer cette URL de manière privée. Pour inclure la liste des Trackbacks entrant dans l index principal de votre design merci de consulter la documentation.',
    '_USAGE_PERMISSIONS_1' => 'Vous à êtes en train de modifier les droits de <b>[_1]</b>. Vous trouverez ci-dessous la liste des weblogs pour lesquels vous pouvez contrôler les utilisateurs ; pour chaque weblog de la liste, vous pouvez affecter des droits à <b>[_1]</b> en cochant les cases correspondant aux options souhaitées.',
    'List Users' => 'Lister les  Utilisateurs', # Translate - New (2)
    'Add/Manage Categories' => 'Ajouter/Gérer des Categories',
    'Creating entry category placements...' => 'Création des placements des catégories des notes...',
    'To enable comment registration, you need to add a TypeKey token in your weblog config or user profile.' => 'Pour activer l\'authentification des commentaires, vous devez ajouter une clé TypeKey dans la config de votre weblog ou dans le profil de l\'utilisateur.',
    'Advanced' => 'Avancé', # Translate - New (1)
    'Are you sure you want to delete this [_1]?' => 'Etes-vous sûr de vouloir effacer cet(te) [_1]?', # Translate - New (9)
    'Third-Party Services' => 'Services Tiers', # Translate - New (2)
    'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Posté <MTIfNonEmpty tag="EntryAuthorDisplayName">par [_1] </MTIfNonEmpty>le [_2]',
    'Recover Password(s)' => 'Récupérer le(s) mot(s) de passe',
    'This page contains all entries posted to [_1] in <strong>[_2]</strong>. They are listed from oldest to newest.' => 'Cette page contient les notes postées en [_1] dans <strong>[_2]</strong>. Elles sont classées de la plus ancienne à la plus récente.',
    'You can not create associations for disabled users.' => 'Vous ne pouvez créer des associations pour des utilisateurs désactivés.', # Translate - New (8)
    '<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> est la prochaine catégorie.',
    'User \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => 'Utilisateur \'[_1]\' (#[_2]) effacé par \'[_3]\' (utilisateur #[_4])', # Translate - New (8)
    '_USAGE_PERMISSIONS_4' => 'Chaque weblog peut être utilisé par plusieurs utilisateurs. Pour ajouter un utilisateur, vous entrerez les informations correspondantes dans les formulaires ci-dessous. Sélectionnez ensuite les weblogs dans lesquels l\'utilisateur pourra travailler. Vous pourrez modifier les droits accordés à l\'utilisateur une fois ce dernier enregistré dans le système.',
    '_USAGE_TAGS' => 'Utilisez les tags pour grouper vos notes sous un même mot clef ce qui vous permettra de les retrouver plus facilement.',
    'TrackBack for category #[_1] \'[_2]\'.' => 'TrackBack pour la catégorie #[_1] \'[_2]\'.', # Translate - New (5)
    'Before you can do this, you need to create some weblogs. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a weblog.' => 'Avant de faire ceci, vous devez créer des weblogs. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Cliquez ici</a> pour créer un weblog.', # Translate - New (25)
    '_USAGE_BOOKMARKLET_5' => 'Vous pouvez également, si vous utilisez Internet Explorer sous Windows, installer une option QuickPost dans le menu contextuel (clic droit) de Windows. Cliquez sur le lien ci-dessous et acceptez le message affiché pour ouvrir le fichier. Fermez et redémarrez votre navigateur pour ajouter le menu au système.',
    'The last system administrator cannot be deleted under ExternalUserManagement.' => 'Le dernier administrateur système ne peut être effacer via le système de gestion externe des Utilisateurs.', # Translate - New (9)
    'Assigning category parent fields...' => 'Ajout des champs parents de la catégorie...',
    'Before you can do this, you need to create some weblogs. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Click here</a> to create a role.' => 'Avant de faire ceci, vous devez créer des weblogs. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Cliquez ici</a> pour créer un blog.', # Translate - New (25)
    'A user by that name already exists.' => 'Un utilisateur ayant ce nom existe déjà.',
    '_USAGE_ENTRY_LIST_BLOG' => 'Voici la liste des notes pour [_1] que vous pouver filtrer, gérer et éditer.',
    'Movable Type ships with directory named <strong>mt-static</strong> which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type est livré avec un répertoire appelé <strong>mt-static</strong> qui contient un certain nombre de fichiers importants comme les images, fichiers javascript et feuilles de style.',
    'Search Results (max 10 entries)' => 'Résultats de recherche (10 notes max.)', # Translate - New (5)
    'Send Notifications' => 'Envoyer des notifications',
    'Setting blog allow pings status...' => 'Mise en place du statut d\'autorisation des pings...',
    'Step 1 of 4' => 'Etape 1 sur 4', # Translate - New (4)
    'Edit All Entries' => 'Modifier toutes les notes',
    'The settings below have been written to the file <tt>[_1]</tt>. If any of these settings are incorrect, you may click the \'Back\' button below to reconfigure them.' => 'Les paramètres ci-dessous ont été écrits dans le fichier <tt>[_1]</tt>. Si certains de ces paramètres sont incorrects, vous pouvez cliquer sur le bouton \'Retour\' ci-dessous pour les reconfigurer.', # Translate - New (29)
    'Error assigning weblog administration rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable weblog administrator role was found.' => 'Erreur dans l\'attribution des droits d\'administration à l\'utilisateur \'[_1] (ID: [_2])\' pour le weblog \'[_3] (ID: [_4])\'. Aucun rôle d\'administrateur de weblog approprié n\'a été trouvé.', # Translate - New (22)
    'Rebuild Files' => 'Reconstruire les fichiers',
    '_USAGE_ROLE_PROFILE' => 'Sur cet écran vous pouvez créer un rôle et les permissions associées.',

    ## Error messages, strings in the app code.

    ## ./nl.pm

    ## ./mt-check.cgi.pre
    'CGI is required for all Movable Type application functionality.' => 'CGI est requis pour toutes les fonctionnalités de l\'application Movable Type.',
    'HTML::Template is required for all Movable Type application functionality.' => 'HTML::Template est requis pour toutes les fonctionnalités de l\'application Movable Type.',
    'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size est requis pour les uploads de fichiers (pour déterminer la taille des images uploadées dans plusieurs formats différents).',
    'File::Spec is required for path manipulation across operating systems.' => 'File::Spec est requis pour la manipulation du chemin (path) à travers les systèmes d\'exploitation.',
    'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie est requis pour l\'authentication du cookie.',
    'DBI is required if you want to use any of the SQL database drivers.' => 'DBI est nécessaire pour utiliser les drivers SQL de la base de données.',
    'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI et DBD::mysql sont requis si vous souhaitez utiliser la base de données MySQL.',
    'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI et DBD::Pg sont requis si vous souhaitez utiliser la base de données PostgreSQL.',
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
    'Data Storage' => 'Stockage des données',
    'Required' => 'Requis',
    'Optional' => 'Optionnels',

    ## ./extras/examples/plugins/mirror/lib/Mirror.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample.pm
    'This is localized in perl module' => 'Ceci est localisé dans le module perl',

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N/ja.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N/en_us.pm

    ## ./plugins/MultiBlog/lib/MultiBlog.pm
    'The include_blogs, exclude_blogs, blog_ids and blog_id attributes cannot be used together.' => 'Les attributs include_blogs, exclude_blogs, blog_ids and blog_id ne peuvent être utilisés ensemble.', # Translate - New (15)
    'The attribute exclude_blogs cannot take "all" for a value.' => 'L\'attribut exclude_blogs ne peut prendre la valeur "tous".', # Translate - New (10)
    'The value of the blog_id attribute must be a single blog ID.' => 'La valeur pour l\'attribut blog_id doit être une ID de blog unique.', # Translate - New (13)
    'The value for the include_blogs/exclude_blogs attributes must be one or more blog IDs, separated by commas.' => 'La valeur pour les attributs include_blogs/exclude_blogs doit être une ou plusieurs ID de blogs, séparées par des virgules.', # Translate - New (19)

    ## ./plugins/MultiBlog/lib/MultiBlog/Tags.pm

    ## ./plugins/MultiBlog/lib/MultiBlog/Tags/LocalBlog.pm

    ## ./plugins/MultiBlog/lib/MultiBlog/Tags/MultiBlog.pm
    'MTMultiBlog tags cannot be nested.' => 'Le tag  MTMultiBlog ne peut pas être intégré .',
    'Unknown "mode" attribute value: [_1]. ' => ' "mode"  inconnu  valeur attribut: [_1]. ',

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Lite.pm
    'An error occurred processing [_1]. ' => 'Une erreur s\'est produite lors de [_1]. ',

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Find.pm

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Lite/CacheMgr.pm

    ## ./plugins/feeds-app-lite/lib/MT/App/FeedsWidget.pm

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

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/es.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/nl.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/ja.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/de.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/en_us.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/fr.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher.pm
    'StyleCatcher must first be configured system-wide before it can be used.' => 'StyleCatcher doit être configuré avant de pouvoir être utilisé.',
    'Configure plugin' => 'Configurer le plugin',
    'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Impossible de créer le dossier [_1] - Vérifiez que votre dossier \'themes\' et en mode webserveur/écriture.',
    'Successfully applied new theme selection.' => 'Sélection de nouveau Thème appliquée avec succès.',

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/es.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/nl.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/ja.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/de.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/en_us.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/fr.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/Plugin.pm
    'Can\'t find included template module \'[_1]\'' => 'Impossible de trouver le module de modèle inclus \'[_1]\'',

    ## ./plugins/WidgetManager/lib/WidgetManager/Util.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/App.pm
    'Loading template \'[_1]\' failed: [_2]' => 'Echec lors du chargement du modèle \'[_1]\': [_2]',
    'Permission denied.' => 'Permission refusée.',
    'Can\'t duplicate the existing \'[_1]\' Widget Manager. Please go back and enter a unique name.' => 'Impossible de dupliquer le gestionnaire de Widgets \'[_1]\' existant. Merci de revenir à la page précédente et de saisir un nom unique.',
    'Moving [_1] to list of installed modules' => 'Déplacement de [_1] dans la liste des modules installés',
    'Error opening file \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture du fichier \'[_1]\': [_2]',
    'First Widget Manager' => 'Premier gestionnaire de widget',

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/es.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/nl.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/ja.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/de.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/en_us.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/fr.pm

    ## ./mt-static/mt.js
    'to delete' => 'effacer', # Translate - New (2)
    'to remove' => 'retirer',
    'to enable' => 'activer', # Translate - New (2)
    'to disable' => 'désactiver', # Translate - New (2)
    'delete' => 'effacer', # Translate - New (1)
    'remove' => 'retirer', # Translate - New (1)
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
    'Showing: [_1] &ndash; [_2] of [_3]' => 'Afficher: [_1] &ndash; [_2] sur [_3]',
    'Showing: [_1] &ndash; [_2]' => 'Afficher: [_1] &ndash; [_2]',
    'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\'?' => 'Le tag \'[_2]\' existe déjà. Etes-vous sûr de vouloir combiner \'[_1]\' avec \'[_2]\'?',
    'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all weblogs?' => 'Le tag \'[_2]\' existe déjà. Etes-vous sûr de vouloir combiner \'[_1]\' avec \'[_2]\'\' sur tous les weblogs?',

    ## ./lib/MT.pm
    'Message: [_1]' => 'Message: [_1]', # Translate - Previous (2)
    'If present, 3rd argument to add_callback must be an object of type MT::Plugin' => 'Si présent, le 3ème argument de add_callback doit être un object de type MT::Plugin',
    '4th argument to add_callback must be a CODE reference.' => '4ème argument de add_callback doit être une référence de CODE.',
    'Two plugins are in conflict' => 'Deux plugins sont en conflit',
    'Invalid priority level [_1] at add_callback' => 'Niveau de priorité invalide [_1] dans add_callback',
    'Unnamed plugin' => 'Plugin sans nom',
    '[_1] died with: [_2]' => '[_1] mort avec: [_2]',
    'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Fichier de configuration manquant. Avez-vous oublié de déplacer mt-config.cgi-original vers mt-config.cgi?',
    'Bad ObjectDriver config' => 'Mauvaise config ObjectDriver',
    'Bad ObjectDriver config: [_1] ' => 'Mauvaise config ObjectDriver : [_1] ',
    'Bad CGIPath config' => 'Mauvaise config CGIPath',
    'Plugin error: [_1] [_2]' => 'Erreur de Plugin: [_1] [_2]',
    'Load of blog \'[_1]\' failed: [_2]' => 'Le chargement du blog \'[_1]\' a échoué : [_2]',
    'No executable code' => 'Pas de code exécutable',
    'First Weblog' => 'Premier Weblog',
    'Error loading weblog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => 'Erreur au chargement du weblog  #[_1] pour le nouvel utilisateur. Merci de vérifier vos paramètrages NewUserTemplateBlogId.',
    'Error provisioning weblog for new user \'[_1]\' using template blog #[_2].' => 'Erreur dans la mise en place du weblog pour le nouvel utilisateur \'[_1]\' en utilisant l\'modèle #[_2].',
    'Error creating directory [_1] for blog #[_2].' => 'Erreur lors de la création de la liste [_1] pour le blog #[_2].',
    'Error provisioning weblog for new user \'[_1] (ID: [_2])\'.' => 'Erreur dans la mise en place du weblog pour l\'utilisateur \'[_1] (ID: [_2])\'.',
    'Blog \'[_1] (ID: [_2])\' for user \'[_3] (ID: [_4])\' has been created.' => 'Le Blog \'[_1] (ID: [_2])\' pour l\'utilisateur \'[_3] (ID: [_4])\' a été créé.',
    'An error occurred: [_1]' => 'Une erreur s\'est produite: [_1]',

    ## ./lib/MT/Comment.pm
    'Load of entry \'[_1]\' failed: [_2]' => 'Le chargement de la note \'[_1]\' a échoué : [_2]',

    ## ./lib/MT/Author.pm
    'Can\'t approve/ban non-COMMENTER user' => 'Impossible d\'approuver ou de bannir un utilisateur non commentateur',
    'The approval could not be committed: [_1]' => 'L\'aprobation ne peut être réalisée : [_1]',

    ## ./lib/MT/Group.pm

    ## ./lib/MT/TemplateMap.pm

    ## ./lib/MT/Bootstrap.pm
    'Got an error: [_1]' => 'Erreur de type : [_1]',

    ## ./lib/MT/Callback.pm

    ## ./lib/MT/Serialize.pm

    ## ./lib/MT/Permission.pm

    ## ./lib/MT/Auth.pm
    'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Mauvaise configuration du module d\'Authentification \'[_1]\': [_2]',

    ## ./lib/MT/WeblogPublisher.pm
    'Archive type \'[_1]\' is not a chosen archive type' => 'Le Type d\'archive\'[_1]\' n\'est pas un type d\'archive sélectionné',
    'Error making path \'[_1]\': [_2]' => 'Erreur dans le chemin \'[_1]\' : [_2]',
    'Parameter \'[_1]\' is required' => 'Le Paramètre \'[_1]\' est requis',
    'Building category archives, but no category provided.' => 'Construction des archives de catégorie, mais aucune catégorie n\'a été fournie.',
    'You did not set your Local Archive Path' => 'Vous n\'avez pas spécifié votre chemin local des Archives',
    'Building category \'[_1]\' failed: [_2]' => 'La construction de la catégorie\'[_1]\' a échoué : [_2]',
    'Building entry \'[_1]\' failed: [_2]' => 'La construction de la note \'[_1]\' a échoué : [_2]',
    'Building date-based archive \'[_1]\' failed: [_2]' => 'La construction des archives de la base de données \'[_1]\' a échoué : [_2]',
    'Writing to \'[_1]\' failed: [_2]' => 'Ecriture sur\'[_1]\' a échoué: [_2]',
    'Renaming tempfile \'[_1]\' failed: [_2]' => 'Le renommage de tempfile \'[_1]\' a échoué: [_2]',
    'You did not set your Local Site Path' => 'Vous n\'avez pas spécifié votre chemin local du Site',
    'Template \'[_1]\' does not have an Output File.' => 'Le modèle \'[_1]\' n\'a pas de fichier de sortie.',
    'An error occurred while rebuilding to publish scheduled posts: [_1]' => 'Un erreur est intervenue pendant la reconstruction pour publier les notes futures : [_1]',

    ## ./lib/MT/Session.pm

    ## ./lib/MT/Sanitize.pm

    ## ./lib/MT/TaskMgr.pm
    'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'Impossible d\'assurer le vérrouillage pour l\'éxécution de tâches système. Vérifiez que la zone TempDir ([_1]) est en mode écriture.',
    'Error during task \'[_1]\': [_2]' => 'Erreur pendant la tâche \'[_1]\' : [_2]',
    'Scheduled Tasks Update' => 'Mise à jour des tâches planifiées',
    'The following tasks were run:' => 'Les tâches suivantes ont été exécutées :',

    ## ./lib/MT/IPBanList.pm

    ## ./lib/MT/FileMgr.pm

    ## ./lib/MT/Category.pm
    'Categories must exist within the same blog' => 'Les catégories doivent exister au sein du même blog ',
    'Category loop detected' => 'Loop de catégorie détecté',

    ## ./lib/MT/ErrorHandler.pm

    ## ./lib/MT/ObjectDriver.pm

    ## ./lib/MT/Object.pm
    '4th argument to add_callback must be a perl CODE reference' => 'Le 4ème argument de add_callback doit être une référence CODE perl',

    ## ./lib/MT/Upgrade.pm
    'Custom ([_1])' => '([_1]) personnalisé ',
    'This role was generated by Movable Type upon upgrade.' => 'Ce rôle a été généré par Movable Type lors d\'une mise à jour.',
    'Invalid upgrade function: [_1].' => 'Fonction de mise à jour invalide : [_1].',
    'Error loading class: [_1].' => 'Erreur de chargement de classe : [_1].',
    'Creating initial weblog and user records...' => 'Création du weblog initial et des informations utilisateur...',
    'Error saving record: [_1].' => 'Erreur de l\'enregistrement des informations : [_1].',
    'Can\'t find default template list; where is \'default-templates.pl\'? Error: [_1]' => 'Impossible de trouver la liste de modèles par défaut; où se trouve \'default-templates.pl\'? Erreur : [_1]',
    'Creating new template: \'[_1]\'.' => 'Creation d\'un nouveau modèle: \'[_1]\'.',
    'Mapping templates to blog archive types...' => 'Mapping des modèles vers les archives des blogs...',
    'Upgrading table for [_1]' => 'Mise à jour des tables pour [_1]',
    'Upgrading database from version [_1].' => 'Mise à jour de la Base de données de la version [_1].',
    'Database has been upgraded to version [_1].' => 'La base de données a été mise à jour version [_1].',
    'Plugin \'[_1]\' upgraded successfully.' => 'Le Plugin \'[_1]\' a correctement été mis à jour.',
    'Plugin \'[_1]\' installed successfully.' => 'Le Plugin \'[_1]\' a été installé correctement.',
    'Setting your permissions to administrator.' => 'Paramétrage des permissions pour administrateur.',
    'Creating configuration record.' => 'Création des infos de configuration.',
    'Creating template maps...' => 'Création des liens de modèles...',
    'Mapping template ID [_1] to [_2] ([_3]).' => 'Lien du modèle [_1] vers [_2] ([_3]).',
    'Mapping template ID [_1] to [_2].' => 'Lien du modèle [_1] vers [_2].',

    ## ./lib/MT/PluginData.pm

    ## ./lib/MT/Template.pm
    'Parse error in template \'[_1]\': [_2]' => 'Erreur de parsing dans le modèle \'[_1]\' : [_2]',
    'Build error in template \'[_1]\': [_2]' => 'Erreur de compilation dans le modèle \'[_1]\' : [_2]',
    'You cannot use a [_1] extension for a linked file.' => 'Vous ne pouvez pas utiliser l\'extension [_1] pour un fichier joint.',
    'Opening linked file \'[_1]\' failed: [_2]' => 'L\'ouverture du fichier lié \'[_1]\' a échoué : [_2] ',

    ## ./lib/MT/L10N.pm

    ## ./lib/MT/Image.pm
    'Can\'t load Image::Magick: [_1]' => 'Impossible de charger Image::Magick : [_1]',
    'Reading file \'[_1]\' failed: [_2]' => 'La lecture du fichier \'[_1]\' a échoué : [_2]',
    'Reading image failed: [_1]' => 'Echec lors de la lecture de l\'image : [_1]',
    'Scaling to [_1]x[_2] failed: [_3]' => 'La mise à l\'échelle vers [_1]x[_2] a échoué : [_3]',
    'Can\'t load IPC::Run: [_1]' => 'Impossible de charger IPC::Run : [_1]',
    'You do not have a valid path to the NetPBM tools on your machine.' => 'Votre chemin d\'accès vers les outils NetPBM n\'est pas valide sur votre machine.',

    ## ./lib/MT/ObjectTag.pm

    ## ./lib/MT/Plugin.pm

    ## ./lib/MT/Role.pm

    ## ./lib/MT/Task.pm

    ## ./lib/MT/Config.pm

    ## ./lib/MT/FileInfo.pm

    ## ./lib/MT/Blocklist.pm

    ## ./lib/MT/Trackback.pm

    ## ./lib/MT/BasicSession.pm

    ## ./lib/MT/Notification.pm

    ## ./lib/MT/JunkFilter.pm
    'Action: Junked (score below threshold)' => 'Action : Indésirable (score ci-dessous)',
    'Action: Published (default action)' => 'Action : Publié (action par défaut)',
    'Junk Filter [_1] died with: [_2]' => 'Filtre indésirable [_1] mort avec : [_2]',
    'Unnamed Junk Filter' => 'Filtre indésirable sans nom',
    'Composite score: [_1]' => 'Score composite : [_1]',

    ## ./lib/MT/Builder.pm
    '&lt;MT[_1]> with no &lt;/MT[_1]>' => '&lt;MT[_1]> sans &lt;/MT[_1]>',
    'Error in &lt;MT[_1]> tag: [_2]' => 'Erreur dans &lt;MT[_1]> tag : [_2]',

    ## ./lib/MT/Request.pm

    ## ./lib/MT/BasicAuthor.pm

    ## ./lib/MT/Blog.pm
    'Can\'t find default template list; where is \'default-templates.pl\'?' => 'Impossible de trouver la liste de template par défaut; où se trouve \'default-templates.pl\'?',
    'Cloned blog... new id is [_1].' => 'Le nouvel identifiant du blog cloné est [_1]',
    'Cloning permissions for weblog:' => 'Cloner les autorisations pour le weblog:',
    '[_1] records processed...' => '[_1] enregistrements effectués...',
    '[_1] records processed.' => '[_1] enregistrements effectués.',
    'Cloning associations for weblog:' => 'Clonage des assocations pour les weblogs:',
    'Cloning entries for weblog...' => 'Clonage des notes pour le weblog...',
    'Cloning categories for weblog...' => 'Cloner les catégories pour le weblog...',
    'Cloning entry placements for weblog...' => 'Clonage de la localisation des notes pour le weblog...',
    'Cloning comments for weblog...' => 'Clonage des commentaires pour le weblog...',
    'Cloning entry tags for weblog...' => 'Clonage des tags des notes pour le weblog...',
    'Cloning TrackBacks for weblog...' => 'Clonage des TrackBacks pour le weblog ...',
    'Cloning TrackBack pings for weblog...' => 'Clonage des pings de TrackBack pour le weblog...',
    'Cloning templates for weblog...' => 'Clonage des modèles pour le weblog...',
    'Cloning template maps for weblog...' => 'Clonage des mappages d\'modèle pour le weblog...',

    ## ./lib/MT/DateTime.pm

    ## ./lib/MT/LDAP.pm
    'Invalid LDAPAuthURL scheme: [_1].' => 'Schéma LDAPAuthURL non valide : [_1].', # Translate - New (4)
    'Error connecting to LDAP server [_1]: [_2]' => 'Erreur de connection au serveur LDAP [_1]: [_2]', # Translate - New (7)
    'User not found on LDAP: [_1]' => 'Utilisateur non trouvé sur le LDAP: [_1]',
    'Binding to LDAP server failed: [_1]' => 'La liaison avec le serveur LDAP échoué: [_1]',
    'More than one user with the same name found on LDAP: [_1]' => 'Plus d\'une seul utilisateur portant ce même nom a été trouvé notre LDAP: [_1]',

    ## ./lib/MT/TBPing.pm

    ## ./lib/MT/DefaultTemplates.pm

    ## ./lib/MT/Association.pm

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
    'Invalid Archive Type setting \'[_1]\'' => 'Paramètre du type d\'archive invalide \'[_1]\'',

    ## ./lib/MT/Placement.pm

    ## ./lib/MT/Tag.pm
    'Tag must have a valid name' => 'Le tag doit avoir un nom valide',
    'This tag is referenced by others.' => 'Ce Tag est référencé par d autres.',

    ## ./lib/MT/Promise.pm

    ## ./lib/MT/XMLRPC.pm
    'No WeblogsPingURL defined in mt.cfg' => 'Le WeblogsPingURL n\'est pas défini dans le fichier mt.cfg',
    'No MTPingURL defined in mt.cfg' => 'Le MTPingURL  n\'est pas défini dans le fichier mt.cfg',
    'HTTP error: [_1]' => 'Erreur HTTP: [_1]',
    'Ping error: [_1]' => 'Erreur Ping: [_1]',

    ## ./lib/MT/AtomServer.pm
    'PreSave failed [_1]' => 'Echec PreEnregistrement [_1]',
    'User \'[_1]\' (user #[_2]) added entry #[_3]' => 'Utilisateur \'[_1]\' (utilisateur #[_2]) a ajoutée Note #[_3]',

    ## ./lib/MT/Entry.pm
    'Load of blog failed: [_1]' => 'Echec lors du chargement du blog : [_1]',

    ## ./lib/MT/ImportExport.pm
    'No Stream' => 'Pas de Stream',
    'No Blog' => 'Pas de Blog',
    'Can\'t rewind' => 'Impossible de revenir en arrière',
    'Can\'t open \'[_1]\': [_2]' => 'Impossible d\'ouvrir \'[_1]\' : [_2]',
    'Can\'t open directory \'[_1]\': [_2]' => 'Impossible d\'ouvrir le dossier \'[_1]\' : [_2]',
    'No readable files could be found in your import directory [_1].' => 'Aucun fichier lisible n\'a été trouvé dans le répertoire d\'importation [_1].',
    'Importing entries from file \'[_1]\'' => 'Importation des notes du fichier \'[_1]\'',
    'You need to provide a password if you are going to\n' => 'Vous devez saisir un mot de passe si vous allez sur \n',
    'Need either ImportAs or ParentAuthor' => 'ImportAs ou ParentAuthor sont nécessaires',
    'Creating new user (\'[_1]\')...' => 'Creation d\'un nouvel utilisateur (\'[_1]\')...',
    'ok\n' => 'ok\n', # Translate - Previous (2)
    'failed\n' => 'échoué\n',
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

    ## ./lib/MT/Log.pm
    'Entry # [_1] not found.' => 'Note # [_1] non trouvée.',
    'Comment # [_1] not found.' => 'Commentaire # [_1] non trouvé.',
    'TrackBack # [_1] not found.' => 'TrackBack # [_1] non trouvé.',

    ## ./lib/MT/I18N.pm

    ## ./lib/MT/Atom.pm

    ## ./lib/MT/Mail.pm
    'Unknown MailTransfer method \'[_1]\'' => 'Méthode de transfert de mail inconnu \'[_1]\'',
    'Sending mail via SMTP requires that your server ' => 'L\'envoi de mail via SMTP nécessite que votre serveur ',
    'Error sending mail: [_1]' => 'Erreur lors de l\'envoi du mail : [_1]',
    'You do not have a valid path to sendmail on your machine. ' => 'Le chemin d\'accès vers sendmail n\'est pas valide sur votre machine. ',
    'Exec of sendmail failed: [_1]' => 'Echec lors de l\'exécution de sendmail : [_1]',

    ## ./lib/MT/ConfigMgr.pm
    'Alias for [_1] is looping in the configuration.' => 'L alias pour [_1] fait une boucle dans la configuration ',
    'Config directive [_1] without value at [_2] line [_3]' => 'Directive de Config  [_1] sans valeur sur [_2] ligne [_3]',
    'No such config variable \'[_1]\'' => 'Pas de variable de Config de ce type \'[_1]\'',

    ## ./lib/MT/XMLRPCServer.pm
    'Invalid timestamp format' => 'Format de date invalide',
    'No web services password assigned.  Please see your user profile to set it.' => 'Aucun mot de passe associé au service web. Merci de vérifier votre profil Utilisateur pour le définir.',
    'Failed login attempt by disabled user \'[_1]\'' => 'Echec de tentative  d\'identification par utilisateur désactivé \'[_1]\' ',
    'No blog_id' => 'Pas de blog_id',
    'Invalid blog ID \'[_1]\'' => 'ID du blog invalide \'[_1]\'',
    'Invalid login' => 'Login invalide',
    'No posting privileges' => 'Pas détenteur de droits de publication',
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
    'User cannot be created: [_1].' => 'L\'utilisateur n\'a pu être créé: [_1].',
    'User \'[_1]\' has been created.' => 'L\'utilisateur \'[_1]\' a été crée ',
    'Blog for user \'[_1]\' can not be created.' => 'Le blog pour l\'utilisateur \'[_1]\' ne peut être créé.',
    'Blog \'[_1]\' for user \'[_2]\' has been created.' => 'Le blog \'[_1]\' pour l\'utilisateur \'[_2]\' a été créé.',
    'Permission cannot be granted to user \'[_1]\'.' => 'L\'autorisation ne peut être accordé à l\'utilisateur \'[_1]\'.',
    'Permission granted to user \'[_1]\'' => 'Autorisation accordée à l\'utilisateur \'[_1]\'',
    'User \'[_1]\' already exists. Update was not processed: [_2]' => 'L\'utilisateur \'[_1]\' existe déjà. La mise à jour n\'a pas été effectuée: [_2]',
    'User cannot be updated: [_1].' => 'L\'utilisateur ne peut être mis à jour: [_1].',
    'User \'[_1]\' not found.  Update was not processed.' => 'L\'utilisateur \'[_1]\' n\'a pas été trouvé.  La mise à jour n\'a pas été effectuée.',
    'User \'[_1]\' has been updated.' => 'L\'utilisateur \'[_1]\' a été mis à jour.',
    'User \'[_1]\' was found, but delete was not processed' => 'L\'utilisateur \'[_1]\' a été trouvé, mais l\'effacement n\'a pas eu lieu',
    'User \'[_1]\' not found.  Delete was not processed.' => 'L\'utilisateur \'[_1]\' n\'a pas été trouvé.  L\'effacement n\'a pas été effectuée.',
    'User \'[_1]\' has been deleted.' => 'L\'utilisateur \'[_1]\' a été effacé.',

    ## ./lib/MT/App.pm
    'Invalid login.' => 'Identifiant invalide.',
    'This account has been disabled. Please see your system administrator for access.' => 'Ce compte a été désactivé. Merci de vérifier les accès auprès votre administrateur système.',
    'This account has been deleted. Please see your system administrator for access.' => 'Ce compte a été effacé. Merci de contacter votre administrateur système.',
    'User \'[_1]\' (ID:[_2]) logged in successfully' => 'L\'utilisateur \'[_1]\' (ID:[_2]) s\'est identifié correctement',
    'Invalid login attempt from user \'[_1]\'' => 'Tentative d\'authentification invalide de l\'utilisateur \'[_1]\'',
    'User \'[_1]\' (ID:[_2]) logged out' => 'L\'utilisateur \'[_1]\' (ID:[_2]) s\'est déconnecté',
    'The file you uploaded is too large.' => 'Le fichier téléchargé est trop lourd.',
    'Unknown action [_1]' => 'Action inconnue [_1]',
    'Warnings and Log Messages' => 'Mises en gardes et Messages de Log',

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

    ## ./lib/MT/Auth/MT.pm
    'Passwords do not match.' => 'Les mots de passe ne sont pas conformes.',
    'Failed to verify current password.' => 'Erreur lors de la vérification du mot de passe.',
    'Password hint is required.' => 'L\'indice de mot de passe est requis.',
    'Failed login attempt by unknown user \'[_1]\'' => 'Echec de tentative d\'identification par utilisateur inconnu\'[_1]\'',

    ## ./lib/MT/Auth/LDAP.pm
    'User [_1]([_2]) not found.' => 'Utilisateur [_1]([_2]) non trouvé.',
    'User \'[_1]\' cannot be updated.' => 'L\'utilisateur \'[_1]\' ne peut pas être mis à jour',
    'User \'[_1]\' updated with LDAP login ID.' => 'L\'utilisateur \'[_1]\' a été mis à jour avec son identifiant LDAP',
    'LDAP user [_1] not found.' => 'L\'utilisateur LDAP [_1] n\'a pas été trouvé.',
    'User [_1] cannot be updated.' => 'L\'utilisateur [_1] ne peut pas être mis à jour ',
    'Failed login attempt by user \'[_1]\' deleted from LDAP.' => 'Echec de tentative d\'identification par un utilisateur  \'[_1]\' effacé du  LDAP',
    'Failed login attempt by disabled user \'[_1]\'.' => 'Echec de tentative d\'identification un utilisateur désactivé \'[_1]\'.',
    'User \'[_1]\' account is disabled.' => 'Le compte de l\'utilisateur \'[_1]\' est désactivé',
    'User \'[_1]\' updated with LDAP login name \'[_2]\'.' => 'L\'utilisateur \'[_1]\' a été mis à jour avec son login LDAP',
    'User cannot be created by automatic: [_1].' => 'L\'utilisateur ne peut pas être créé en automatique: [_1]',
    'Failed login attempt by user \'[_1]\'. A user with that\nusername already exists in the system with a different UUID.' => 'Echec de tentative d\'identification par un utilisateur  \'[_1]\'. Un utilisateur avec ce nom d\'utilisateur existe déjà dans le système mais avec un  UUID différent.',
    'LDAP users synchronization interrupted.' => 'Interruption de la synchronisation utilisateurs LDAP .',
    'Loading MT::LDAP failed: [_1]' => 'Le chargement MT::LDAP a échoué: [_1]',
    'External user synchronization failed.' => 'Echec de la synchronisation externe de l\'utilisateur',
    'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'Une tentative de désactivation de tous les administrateurs a été détectée.La synchronisation des utilisateurs a été interrompue',
    'The following users\' information were modified:' => 'Les informations des utilisateurs suivants ont été modifées:',
    'The following users were disabled:' => 'Les utilisateurs suivants ont été désactivés ',
    'LDAP users synchronized.' => 'Utilisateurs LDAP synchronisés.',
    'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute is set.' => 'La synchronisation des groupes ne peut pas être faite sans l\'activation de LDAPGroupIdAttribute et/ou LDAPGroupNameAttribute.',
    'No LDAP group was found using given filter.' => 'Aucun groupe LDAP n\'a été trouvé avec les critères de recherche donnés.',
    'Filter used to search for groups: [_1]\nSearch base: [_2]' => 'Filtres utilisés pour trouver des groupes: [_1]\nSearch base: [_2]',
    '(none)' => '(aucun)',
    'The following groups\' information were modified:' => 'Les informations des groupes suivants ont été modifiées:',
    'The following groups were deleted:' => 'Les groupes suivants ont été effacés:', # Translate - New (5)
    'LDAP groups synchronized with existing groups.' => 'Groupes LDAP synchronisés avec des groupes existants.',
    'Failed to create a new group: [_1]' => 'Echec dans la création d\'un nouveau groupe: [_1]',
    '[_1] directive must be set to synchronize members of LDAP groups to Movable Type Enterprise.' => 'La directive [_1] doit être active pour synchroniser les membres d\'un group LDAP sur Movable Type Enterprise.',
    'Members removed: ' => 'Membres supprimés: ',
    'Members added: ' => 'Membres ajoutés: ',
    'Memberships of the group \'[_2]\' (#[_3]) has been changed in synchronizing with external directory.' => 'L\'adhésion au groupe \'[_2]\' (#[_3]) a été modifiée lors de la synchronisation avec un répertoire extérieur.',
    'LDAPUserGroupMemberAttribute must be set to enable synchronize members of groups.' => 'LDAPUserGroupMemberAttribute doit être installé pour permettre la synchronisation des membres du groupe.',

    ## ./lib/MT/ObjectDriver/DBM.pm
    'Your DataSource directory (\'[_1]\') does not exist.' => 'Votre dossier de données (\'[_1]\') n\'existe pas.',
    'Your DataSource directory (\'[_1]\') is not writable.' => 'Votre dossier de données (\'[_1]\') est protégé en écriture.',
    'Tie \'[_1]\' failed: [_2]' => 'La création du lien \'[_1]\' a échoué : [_2]',
    'Failed to generate unique ID: [_1]' => 'Echec lors de la génération de l\'ID unique : [_1]',
    'Unlink of \'[_1]\' failed: [_2]' => 'La suppression du lien \'[_1]\' a échoué: [_2]',

    ## ./lib/MT/ObjectDriver/DBI.pm
    'Loading data failed with SQL error [_1]' => 'Echec du Chargement des données SQL erreur [_1]',
    'Count [_1] failed on SQL error [_2]' => 'Echec Comptage [_1] sur erreur SQL [_2]',
    'Prepare failed' => 'La préparation a échoué',
    'Execute failed' => 'L\'Exécution a échoué',
    'existence test failed on SQL error [_1]' => 'test d\'existence a échoué par une erreur SQL [_1]',
    'Insertion test failed on SQL error [_1]' => 'Test d\'insertion a échoué par une erreur SQL [_1]',
    'Update failed on SQL error [_1]' => 'Echec de la mise à jour. Erreur SQL [_1]',
    'No such object.' => 'Objet inconnu.',
    'Remove failed on SQL error [_1]' => 'Echec du retrait.  Erreur SQL [_1]',
    'Remove-all failed on SQL error [_1]' => 'Echec du retrait généralisé. Erreur SQL [_1] ',

    ## ./lib/MT/ObjectDriver/DBI/sqlite.pm
    'Your database file (\'[_1]\') is not writable.' => 'Votre fichier base de données (\'[_1]\') est interdit en écriture.',
    'Your database directory (\'[_1]\') is not writable.' => 'Le répertoire de votre Base de données (\'[_1]\') est interdit en écriture.',
    'Connection error: [_1]' => 'Erreur de connexion : [_1]',

    ## ./lib/MT/ObjectDriver/DBI/mysql.pm
    'undefined type: [_1]' => 'Type indéfini : [_1]',

    ## ./lib/MT/ObjectDriver/DBI/postgres.pm

    ## ./lib/MT/ObjectDriver/DBI/oracle.pm

    ## ./lib/MT/ObjectDriver/DBI/mssqlserver.pm
    'PublishCharset [_1] is not supported in this version of MS SQL Server Driver.' => 'PublishCharset [_1] n\'est pas supporté sur cette version de MS SQL Server Driver.',
    'WRITETEXT failed for insert: [_1]\n[_2]' => 'WRITETEXT a échoué pour insérer: [_1]\n[_2]',
    'WRITETEXT failed for update: [_1]\n[_2]' => 'WRITETEXT a échoué pour mettre à jour: [_1]\n[_2]',

    ## ./lib/MT/Template/ContextHandlers.pm
    'Can\'t find blog for id \'[_1]' => 'Impossible de trouver un blog pour le ID\'[_1]',
    'Can\'t find included file \'[_1]\'' => 'Impossible de trouver le fichier inclus \'[_1]\'',
    'Error opening included file \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture du fichier inclus \'[_1]\' : [_2]',
    'Unspecified archive template' => 'Modèle d\'archive non spécifié',
    'Error in file template: [_1]' => 'Erreur dans fichier modèle : [_1]',
    'Can\'t find template \'[_1]\'' => 'Impossible de trouver le modèle \'[_1]\'',
    'Can\'t find entry \'[_1]\'' => 'Impossible de trouver la note \'[_1]\'',
    'Movable Type' => 'Movable Type', # Translate - Previous (2)
    '[_1] [_2]' => '[_1] [_2]', # Translate - Previous (3)
    'You used a [_1] tag without any arguments.' => 'Vous utilisez un [_1] tag sans aucun argument.',
    'You have an error in your \'category\' attribute: [_1]' => 'Vous avez une erreur dans votre attribut \'catégorie\' : [_1]',
    'You have an error in your \'tag\' attribute: [_1]' => 'Vous avez une erreur dans votre attribut \'tag\': [_1]',
    'No such user \'[_1]\'' => 'L\'utilisateur \'[_1]\' n\'existe pas',
    'You used an \'[_1]\' tag outside of the context of an entry; ' => 'Vous utilisez un tag \'[_1]\' en dehors du contexte d\'une note; ',
    'You used <$MTEntryFlag$> without a flag.' => 'Vous utilisez <$MTEntryFlag$> sans drapeau.',
    'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Vous avez utilisé un [_1] tag pour créer un lien vers \'[_2]\' archives, mais le type d\'archive n\'est pas publié.',
    'Could not create atom id for entry [_1]' => 'Impossible de créer un ID Atom pour cette note [_1]',
    'To enable comment registration, you ' => 'Pour demander l\'enregistrement avant de pouvoir commenter, vous ',
    '(You may use HTML tags for style)' => '(Vous dpouvez utiliser des tags HTML pour le style)',
    'You used an [_1] tag without a date context set up.' => 'Vous utilisez un tag [_1] sans avoir configuré la date.',
    'You used an \'[_1]\' tag outside of the context of a comment; ' => 'Vous utilisez un tag \'[_1]\' en dehors du contexte d\'un commentaire; ',
    'You used an [_1] without a date context set up.' => 'Vous utilisez un [_1] sans avoir configurer la date.',
    '[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] est valide uniquement avec des archives quotidiennes, hebdomadaires ou mensuelles.',
    'Couldn\'t get daily archive list' => 'Impossible de récupérer la liste des archives journalières',
    'Couldn\'t get monthly archive list' => 'Impossible de récupérer la liste des archives mensuelles',
    'Couldn\'t get weekly archive list' => 'Impossible de récupérer la liste des archives hebdomadaire',
    'Unknown archive type [_1] in <MTArchiveList>' => 'Type d\'archive inconnu [_1] in <MTArchiveList>',
    'Group iterator failed.' => 'L\'itérateur de groupe a échoué',
    'You used an [_1] tag outside of the proper context.' => 'Vous utilisez un tag [_1] en dehors de son contexte propre.',
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly ' => 'Vous utilisez un tag [_1] en dehors d\'une utilisation quotidienne, hebdomadaire ou mensuelle ',
    'Could not determine entry' => 'La note ne peut pas être déterminée',
    'Invalid month format: must be YYYYMM' => 'Le format du mois est invalide : Il doit être de la forme AAAAMM',
    'No such category \'[_1]\'' => 'La catégorie \'[_1]\' n\'existe pas',
    'You used <$MTCategoryDescription$> outside of the proper context.' => 'Vous avez utilisé <$MTCategoryDescription$> en dehors de son contexte.',
    '[_1] can be used only if you have enabled Category archives.' => '[_1] peut être utilisé seulement si vous avez activé l\'archivage par Catégories.',
    '<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> doit être utilisé dans le contexte d\'une catégorie, ou avec l\'attribut \'Catégorie\' dans le tag.',
    'You failed to specify the label attribute for the [_1] tag.' => 'Vous n\'avez pas spécifié l\'étiquette du tag [_1].',
    'You used an \'[_1]\' tag outside of the context of ' => 'Vous avez utilisé le tag \'[_1]\' en dehors du contexte de ',
    'MTSubCatsRecurse used outside of MTSubCategories' => 'MTSubCatsRecurse est utilisé en dehors d\'une balise MTSubCategories',
    'MT[_1] must be used in a category context' => 'MT[_1] doit être utilisé dans le contexte d\'une catégorie',
    'Cannot find package [_1]: [_2]' => 'Impossible de trouver le package [_1]: [_2]',
    'Error sorting categories: [_1]' => 'Erreur en triant les catégories: [_1]',

    ## ./lib/MT/Template/Context.pm
    'The attribute exclude_blogs cannot take \'all\' for a value.' => 'L\'attribut exclude_blogs ne peut pas prendre \'all\' comme valeur.',

    ## ./lib/MT/Plugin/L10N.pm

    ## ./lib/MT/Plugin/JunkFilter.pm
    'from rule' => 'de la règle',
    'from test' => 'du test',

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

    ## ./lib/MT/App/Upgrader.pm
    'The initial account name is required.' => 'Le nom initial du compte est nécessaire.',
    'Failed to authenticate using given credentials: [_1].' => 'A échoué à s\'authentifier en utilisant les informations communiquées [_1].',
    'You failed to validate your password.' => 'Echec de la validation du mot de passe.',
    'You failed to supply a password.' => 'Vous n\'avez pas donné de mot de passe.',
    'The e-mail address is required.' => 'L\'adresse email est requise.',
    'Password recovery word/phrase is required.' => 'La phrase de récupération de mot de passe est requise.',
    'User \'[_1]\' upgraded database to version [_2]' => 'L\'utilisateur \'[_1]\' a mis à jour la base de données avec la version [_2]',
    'Invalid session.' => 'Session invalide.',
    'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Pas d\'autorisation. Contactez votre administrateur système Movable Type pour changer votre statut.',

    ## ./lib/MT/App/Trackback.pm
    'You must define a Ping template in order to display pings.' => 'Vous devez définir un modèle d\'affichage Ping pour les afficher.',
    'Trackback pings must use HTTP POST' => 'Les Pings Trackback doivent utiliser HTTP POST',
    'Need a TrackBack ID (tb_id).' => 'Un TrackBack ID est requis (tb_id).',
    'Invalid TrackBack ID \'[_1]\'' => 'TrackBack ID invalide \'[_1]\'',
    'You are not allowed to send TrackBack pings.' => 'You n\'êtes pas autorisé à envoyer des TrackBack pings.',
    'You are pinging trackbacks too quickly. Please try again later.' => 'Vous pinguez les trackbacks trop rapidement. Merci d\'essayer plus tard.',
    'Need a Source URL (url).' => 'Une source URL est requise (url).',
    'Invalid URL \'[_1]\'' => 'URL invalide \'[_1]\'',
    'This TrackBack item is disabled.' => 'Cet élément TrackBack est désactivé.',
    'This TrackBack item is protected by a passphrase.' => 'Cet élément de TrackBack est protégé par un mot de passe.',
    'TrackBack on "[_1]" from "[_2]".' => 'TrackBack sur "[_1]" provenant de "[_2]".',
    'TrackBack on category \'[_1]\' (ID:[_2]).' => 'TrackBack sur la catégorie \'[_1]\' (ID:[_2]).',
    'Rebuild failed: [_1]' => 'Echec lors de la recontruction: [_1]',
    'Can\'t create RSS feed \'[_1]\': ' => 'Impossible de créer le flux RSS \'[_1]\': ',
    'New TrackBack Ping to Entry [_1] ([_2])' => 'Nouveau TrackBack Ping pour la Note [_1] ([_2])',
    'New TrackBack Ping to Category [_1] ([_2])' => 'Nouveau TrackBack Ping pour la Catégorie [_1] ([_2])',

    ## ./lib/MT/App/Comments.pm
    'No id' => 'pas d\'id',
    'No such comment' => 'Pas de commentaire de la sorte',
    'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'l\'IP [_1] a été bannie car elle emet plus de 8 commentaires en  [_2] seconds.',
    'IP Banned Due to Excessive Comments' => 'IP bannie pour cause de commentaires excessifs',
    'Invalid request' => 'Demande incorrecte',
    'No such entry \'[_1]\'.' => 'Aucune Note \'[_1]\'.',
    'You are not allowed to post comments.' => 'Vous n\'êtes pas autorisé à poster des commentaires.',
    'Comments are not allowed on this entry.' => 'Les commentaires ne sont pas autorisés sur cette Note.',
    'Comment text is required.' => 'Le texte de commentaire est requis.',
    'Registration is required.' => 'L\'inscription est requise.',
    'Name and email address are required.' => 'Le nom et l\'e-mail sont requis.',
    'Invalid email address \'[_1]\'' => 'Adresse e-mail invalide \'[_1]\'',
    'Comment save failed with [_1]' => 'La sauvegarde du commentaire a échoué [_1]',
    'Comment on "[_1]" by [_2].' => 'Commentaire sur "[_1]" par [_2].',
    'Commenter save failed with [_1]' => 'L\'enregistrement de l\'auteur de commentaires a échoué [_1]',
    'New Comment Posted to \'[_1]\'' => 'Nouveau commentaire posté sur \'[_1]\'',
    'The login could not be confirmed because of a database error ([_1])' => 'Le login ne peut pas être confirmé en raison d\'une erreur de base de données ([_1])',
    'Couldn\'t get public key from url provided' => 'Impossible d\'avoir une clef publique',
    'No public key could be found to validate registration.' => 'Aucune clé publique n\'a été trouvée pour valider l\'inscription.',
    'TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'La vérification de la signature Typekey retournée [_1] dans [_2] secondes en vérifiant [_3] avec [_4]',
    'The TypeKey signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'La signature Typekey est périmée depuis ([_1] secondes). Vérifier que votre serveur a une heure correcte',
    'The sign-in validation failed.' => 'Cette validation pour enregistrement a échoué.',
    'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Les auteurs de commentaires de ce weblog doivent donner une adresse email. Si vous souhaitez le faire il faut vous enregistrer à nouveau et donner l\'autorisation au système d\'identification de récupérer votre adresse email',
    'Couldn\'t save the session' => 'Impossible de sauvegarder la session',
    'This weblog requires commenters to pass an email address' => 'Les auteurs de commentaires de ce weblog doivent donner une adresse email',
    'Sign in requires a secure signature; logout requires the logout=1 parameter' => 'La procédure d\'enregistrement nécessite une signature sécurisée; la procédure de déconnexion nécessite le paramètre logout=1',
    'The sign-in attempt was not successful; please try again.' => 'La tentative d\'enregistrement a échoué; veuillez essayer de nouveau.',
    'The sign-in validation was not successful. Please make sure your weblog is properly configured and try again.' => 'La procédure d\'enrgistrement a échoué. Veuillez vérifier que votre weblog est configuré correctement et essayez de nouveau.',
    'No such entry ID \'[_1]\'' => 'Aucune ID pour la Note \'[_1]\'',
    'You must define an Individual template in order to ' => 'Vous devez définir un modèle individuel pour ',
    'You must define a Comment Listing template in order to ' => 'Vous devez définir un modèle de liste de commentaires pour ',
    'No entry was specified; perhaps there is a template problem?' => 'Aucune Note n\'a été spécifiée; peut-être y a-t-il un problème de modèle?',
    'Somehow, the entry you tried to comment on does not exist' => 'Il semble que la Note que vous souhaitez commenter n\'existe pas',
    'You must define a Comment Pending template.' => 'Vous devez définir un modèle pour les commentaires en attente de validation.',
    'You must define a Comment Error template.' => 'Vous devez définir un modèle d\'erreur de commentaire.',
    'You must define a Comment Preview template.' => 'Vous devez définir un modèle de prévisualisation de commentaire.',

    ## ./lib/MT/App/Wizard.pm
    'Sendmail' => 'Sendmail', # Translate - Previous (1)
    'Test email from Movable Type Configuration Wizard' => 'Test email à partir de l\'Assistant de Configuration de Movable Type',
    'This is the test email sent by your new installation of Movable Type.' => 'Ceci est un email de test envoyé par votre nouvelle installation Movable Type.',
    'PLAIN' => 'PLEIN',
    'CRAM-MD5' => 'CRAM-MD5', # Translate - Previous (1)
    'Digest-MD5' => 'Digest-MD5', # Translate - Previous (1)
    'Login' => 'Identification',
    'Found' => 'Trouvé', # Translate - New (1)
    'Not Found' => 'Pas trouvé', # Translate - New (2)

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
    'Invalid blog' => 'Blog incorrect',
    'Convert Line Breaks' => 'Conversion retours ligne',
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
    'Invalid group id' => 'Identifiant de Groupe Invalide',
    'Users & Groups' => 'Utilisateurs et Groupes',
    'Group Roles' => 'Rôles du Groupe',
    'Invalid user id' => 'Identifiant Utilisateur Invalide',
    'User Roles' => 'Rôles de l\'utilisateur',
    'Group Associations' => 'Associations de Groupe',
    'User Associations' => 'Associations d\'utilisateur',
    'Role Users & Groups' => 'Role Utilisateurs et Groupes',
    '(Custom)' => '(Personnalisé)',
    '(user deleted)' => '(utilisateur effacé)',
    'Invalid type' => 'Type incorrect',
    'No such tag' => 'Pas de Tag de ce type',
    'You are not authorized to log in to this blog.' => 'Vous n\'êtes pas autorisé à vous connecter sur ce weblog.',
    'View all weblogs...' => 'Afficher tous les weblogs...',
    'No such blog [_1]' => 'Aucun weblog ne porte le nom [_1]',
    'Weblog Activity Feed' => 'Flux d\'activité du weblog',
    'User Groups' => 'Groupes d\'utilisateurs',
    'Your login session has expired.' => 'Votre session a expiré.',
    'Group load failed: [_1]' => 'Echec du chargement du Groupe: [_1]',
    'User load failed: [_1]' => 'Echec du chargement de l\'utilisateur: [_1]',
    'User \'[_1]\' (ID:[_2]) removed from group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) enlevé du groupe \'[_3]\' (ID:[_4]) par \'[_5]\'',
    'User \'[_1]\' (ID:[_2]) was added to group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) a été ajouté au groupe \'[_3]\' (ID:[_4]) par \'[_5]\'',
    'Author load failed: [_1]' => 'Echec du chargement de l\'auteur: [_1]',
    'All Feedback' => 'Tous les retours lecteurs',
    'log records' => 'entrées du journal',
    'System Activity Feed' => 'Flux d\'activité du système',
    'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'Journal d\'activité pour le blog \'[_1]\' (ID:[_2]) réinitialisé par \'[_3]\'',
    'Activity log reset by \'[_1]\'' => 'Journal d\'activité réinitialisé par \'[_1]\'',
    'Import/Export' => 'Importer / Exporter',
    'Invalid blog id [_1].' => 'ID du blog invalide [_1].',
    'Invalid parameter' => 'Paramètre Invalide',
    'Load failed: [_1]' => 'Echec de chargement : [_1]',
    '(no reason given)' => '(sans raison donnée)',
    '(untitled)' => '(sans titre)',
    'Create template requires type' => 'La création d\'modèles nécessite un type',
    'New Template' => 'Nouveau modèle',
    'New Weblog' => 'Nouveau weblog',
    'User requires username' => 'Un nom d\'utilisateur est nécessaire pour l\'utilisateur',
    'A user with the same name already exists.' => 'Un utilisateur possédant ce nom existe déjà.', # Translate - New (8)
    'User requires password' => 'L\'utilisateur a besoin d\'un mot de passe',
    'User requires password recovery word/phrase' => 'L\'utilisateur demande la phrase de récupération de mot de passe',
    'Email Address is required for password recovery' => 'L\'adresse email est nécessaire pour récupérer le mot de passe',
    'Group requires name' => 'Le Groupe requiert un nom',
    'The value you entered was not a valid email address' => 'Vous devez saisir une adresse e-mail valide',
    'The e-mail address you entered is already on the Notification List for this weblog.' => 'L\'adresse e-mail que vous avez entrée fait déjà parti de la liste de notification de ce weblog.',
    'You did not enter an IP address to ban.' => 'Vous devez saisir une adresse IP à bannir.',
    'The IP you entered is already banned for this weblog.' => 'L\'adresse IP que vous avez entrée a été bannie de ce weblog.',
    'You did not specify a weblog name.' => 'Vous devez  spécifier un nom de weblog.',
    'Site URL must be an absolute URL.' => 'L\'URL du site doit être une URL absolue.',
    'Archive URL must be an absolute URL.' => 'Les URL d\'archive doivent être des URL absolues.',
    'The name \'[_1]\' is too long!' => 'Le nom \'[_1]\' est trop long.',
    'A user can\'t change his/her own username in this environment.' => 'Un utilisateur ne peut pas changer son nom d\'utilisateur dans cet environnement',
    'An errror occurred when enabling this user.' => 'Une erreur s\'est produite pendant l\'activation de cet utilisateur.', # Translate - New (7)
    'Category \'[_1]\' created by \'[_2]\'' => 'Catégorie \'[_1]\' créée par \'[_2]\'',
    'The category label \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Le nom de catégorie \'[_1]\' est en conflit avec une autre catégorie. Les catégories et les sous-catégories doivent avoir un nom unique.',
    'Saving permissions failed: [_1]' => 'Echec lors de la sauvegarde des Autorisations : [_1]',
    'Can\'t find default template list; where is ' => 'Impossible de trouver la liste des modèles par défaut; où est ',
    'Populating blog with default templates failed: [_1]' => 'L\'activation sur le blog des modèles par défaut a échoué : [_1]',
    'Setting up mappings failed: [_1]' => 'La mise en oeuvre des mappings a échoué : [_1]',
    'Weblog \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Weblog \'[_1]\' (ID:[_2]) créé par \'[_3]\'',
    'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) créé par \'[_3]\'',
    'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Modèle \'[_1]\' (ID:[_2]) créé par \'[_3]\'',
    'You cannot delete your own association.' => 'Vous ne pouvez pas supprimer votre propre association.',
    'You cannot delete your own user record.' => 'Vous ne pouvez pas effacer vos propres données Utilisateur.',
    'You have no permission to delete the user [_1].' => 'Vous n\'avez pas l\'autorisation d\'effacer l\'utilisateur [_1].',
    'Weblog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Weblog \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
    'Subscriber \'[_1]\' (ID:[_2]) deleted from notification list by \'[_3]\'' => 'Abonné \'[_1]\' (ID:[_2]) supprimé de la liste de notifications par \'[_3]\'',
    'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
    'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Catégorie \'[_1]\' (ID:[_2]) supprimée par \'[_3]\'',
    'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Commentaire (ID:[_1]) de \'[_2]\' supprimé par \'[_3]\' de la note \'[_4]\'',
    'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Note \'[_1]\' (ID:[_2]) supprimée par \'[_3]\'',
    '(Unlabeled category)' => '(Catégorie sans description)',
    'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) de \'[_2]\' supprimé par \'[_3]\' de la catégorie \'[_4]\'',
    '(Untitled entry)' => '(Note sans titre)',
    'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) de \'[_2]\' supprimé par \'[_3]\' de la note \'[_4]\'',
    'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Modèle \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
    'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Tag \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
    'Permisison denied.' => 'Permission refusée.',
    'Save failed: [_1]' => 'Echec sauvegarde: [_1]',
    'Saving object failed: [_1]' => 'Echec lors de la sauvegarde de l\'objet : [_1]',
    'No Name' => 'Pas de Nom',
    'Notification List' => 'Liste de notifications',
    'email addresses' => 'adresses email',
    'Can\'t delete that way' => 'Impossible de supprimer comme cela',
    'Permission denied: [_1]' => 'Autorisation refusée: [_1]',
    'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => 'Vous ne pouvez pas effacer cette catégorie car elle contient des sous-catégories. Déplacez ou supprimez d\'abord les sous-catégories pour pouvoir effacer cette catégorie.',
    'Loading MT::LDAP failed: [_1].' => 'Echec de Chargement MT::LDAP[_1]',
    'System templates can not be deleted.' => 'Les modèles créés par le Système ne peuvent pas être supprimés.',
    'Invalid request.' => 'Demande invalide.',
    'Unknown object type [_1]' => 'Objet de type [_1] inconnu',
    'Loading object driver [_1] failed: [_2]' => 'Echec lors du chargement du driver [_1] : [_2]',
    'Reading \'[_1]\' failed: [_2]' => 'Echec \'[_1]\' lors de la lecture de : [_2]',
    'Thumbnail failed: [_1]' => 'Echec de a vignette: [_1]',
    'Error writing to \'[_1]\': [_2]' => 'Erreur \'[_1]\' lors de l\'écriture de : [_2]',
    'Invalid basename \'[_1]\'' => 'Nom de base invalide \'[_1]\'',
    'No such commenter [_1].' => 'Pas de d\'auteur de commentaires [_1].',
    'User \'[_1]\' trusted commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\' a accordé le statut Fiable à l\'auteur de commentaire \'[_2]\'.',
    'User \'[_1]\' banned commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\'  a banni l\'auteur de commentaire \'[_2]\'.',
    'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\'  a retiré le statu Banni à l\'auteur de commentaire \'[_2]\'.',
    'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\'  a retiré le statut Fiable à l\'auteur de commentaire \'[_2]\'.',
    'Need a status to update entries' => 'Statut nécessaire pour mettre à jour les notes',
    'Need entries to update status' => 'Notes nécessaires pour mettre à jour le statut',
    'One of the entries ([_1]) did not actually exist' => 'Une des notes ([_1]) n\'existait pas',
    'Some entries failed to save' => 'Certaines notes non pas été sauvegardées correctement',
    'You don\'t have permission to approve this TrackBack.' => 'Vous n\'avez pas l\'autorisation d\'approuver ce TrackBack.',
    'Comment on missing entry!' => 'Commentaire su une note maquante !',
    'You don\'t have permission to approve this comment.' => 'Vous n\'avez pas la permission d\'approuver ce commentaire.',
    'Comment Activity Feed' => 'Flux d\'activité des commentaires',
    'Orphaned' => 'Orphelin',
    'Orphaned comment' => 'Commentaire orphelin',
    'Plugin Set: [_1]' => 'Eventail de Plugin : [_1]',
    'TrackBack Activity Feed' => 'Flux d\'activité des TrackBacks ',
    'No Excerpt' => 'Pas d\'extrait',
    'No Title' => 'Pas de Titre',
    'Orphaned TrackBack' => 'TrackBack orphelin',
    'Tag' => 'Tag', # Translate - Previous (1)
    'Entry Activity Feed' => 'Flux d\'activité des notes',
    'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Date invalide \'[_1]\'; les dates doivent être au format AAAA-MM-JJ HH:MM:SS.',
    'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Date invalide \'[_1]\'; les dates de publication doivent être réelles.',
    'Saving entry \'[_1]\' failed: [_2]' => 'Echec \'[_1]\' lors de la sauvegarde de la Note : [_2]',
    'Removing placement failed: [_1]' => 'Echec lors de la suppression de l\'emplacement : [_1]',
    'No such entry.' => 'Aucune Note de ce type.',
    'Your weblog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Votre weblog n\'a pas été configuré avec un chemin et une URL. Vous ne pouvez pas publier de notes avant qu\'ils ne soient définis',
    'Entry \'[_1]\' (ID:[_2]) added by user \'[_3]\'' => 'Note \'[_1]\' (ID:[_2]) ajoutée par l\'utilisateur \'[_3]\'',
    'The category must be given a name!' => 'Vous devez donner un nom a votre catégorie.',
    'No permissions' => 'Aucun Droit',
    'yyyy/mm/entry_basename' => 'aaaa/mm/titre_de_la_note',
    'yyyy/mm/entry-basename' => 'aaaa/mm/titre-de-la-note',
    'yyyy/mm/entry_basename/' => 'aaaa/mm/titre_de_la_note/',
    'yyyy/mm/entry-basename/' => 'aaaa/mm/titre-de-la-note/',
    'yyyy/mm/dd/entry_basename' => 'aaaa/mm/jj/titre_de_la_note',
    'yyyy/mm/dd/entry-basename' => 'aaaa/mm/jj/titre-de-la-note',
    'yyyy/mm/dd/entry_basename/' => 'aaaa/mm/jj/titre_de_la_note/',
    'yyyy/mm/dd/entry-basename/' => 'aaaa/mm/jj/titre-de-la-note/',
    'category/sub_category/entry_basename' => 'categorie/sous_categorie/titre_de_la_note',
    'category/sub_category/entry_basename/' => 'categorie/sous_categorie/titre_de_la_note/',
    'category/sub-category/entry_basename' => 'categorie/sous-categorie/titre_de_la_note',
    'category/sub-category/entry-basename' => 'categorie/sous-categorie/titre-de-la-note',
    'category/sub-category/entry_basename/' => 'categorie/sous-categorie/titre_de_la_note/',
    'category/sub-category/entry-basename/' => 'categorie/sous-categorie/titre-de-la-note/',
    'primary_category/entry_basename' => 'categorie_principale/titre_de_la_note',
    'primary_category/entry_basename/' => 'categorie_principale/titre_de_la_note/',
    'primary-category/entry_basename' => 'categorie-principale/titre_de_la_note',
    'primary-category/entry-basename' => 'categorie-principale/titre-de-la-note',
    'primary-category/entry_basename/' => 'categorie-principale/titre_de_la_note/',
    'primary-category/entry-basename/' => 'categorie-principale/titre-de-la-note/',
    'yyyy/mm/' => 'aaaa/mm/',
    'yyyy_mm' => 'aaaa_mm',
    'yyyy/mm/dd/' => 'aaaa/mm/jj/',
    'yyyy_mm_dd' => 'aaaa_mm_jj',
    'yyyy/mm/dd-week/' => 'aaaa/mm/jj-semaine/',
    'week_yyyy_mm_dd' => 'semaine_aaaa_mm_jj',
    'category/sub_category/' => 'categorie/sous_categorie/',
    'category/sub-category/' => 'categorie/sous-categorie/',
    'cat_category' => 'cat_categorie',
    'Saving blog failed: [_1]' => 'Echec lors de la sauvegarde du blog : [_1]',
    'You do not have permission to configure the blog' => 'Vous n\'avez pas la permission de configurer le weblog.',
    'Saving map failed: [_1]' => 'Echec lors du rattachement: [_1]',
    'Invalid ID given for personal weblog clone source ID.' => 'Mauvais identifiant donné pour le weblog personnel cloné',
    'If personal weblog is set, the default site URL and root are required.' => 'Si un weblog personnel est en place, l\'URL par défaut et la racine son requises.',
    'Parse error: [_1]' => 'Erreur de parsing : [_1]',
    'Build error: [_1]' => 'Erreur de construction : [_1]',
    'Rebuild-option name must not contain special characters' => 'L option de reconstruction de nom ne doit pas contenir de caractères spéciaux',
    'index template \'[_1]\'' => 'index hbaillage \'[_1]\'',
    'entry \'[_1]\'' => 'note \'[_1]\'',
    'Ping \'[_1]\' failed: [_2]' => 'Le Ping \'[_1]\' n\'a pas fonctionné : [_2]',
    'Role name cannot be blank.' => 'Le role de peu pas être laissé vierge.',
    'Another role already exists by that name.' => 'Un autre role existe dejà avec ce nom.',
    'You cannot define a role without permissions.' => 'Vous ne pouvez pas définir un role sans autorisation.',
    'No entry ID provided' => 'Aucune ID de Note fournie',
    'No such entry \'[_1]\'' => 'Aucune Note du type \'[_1]\'',
    'No email address for user \'[_1]\'' => 'L\'utilisateur \'[_1]\' ne possède pas d\'adresse e-mail',
    'No valid recipients found for the entry notification.' => 'Aucun destinataire valide n\'a été trouvé pour la notification de cette note.',
    'Error sending mail ([_1]); try another MailTransfer setting?' => 'Erreur lors de l\'envoi de l\'e-mail ([_1]); essayer un autre paramètre de MailTransfer ?',
    'Bulk import cannot be used under external user management.' => 'Un import collectif ne peut pas être utilisé par un utilisateur externe.',
    'Bulk management' => 'Gestion collective',
    'You did not choose a file to upload.' => 'Vous n\'avez pas sélectionné de fichier à envoyer.',
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
    'Invalid date(s) specified for date range.' => 'Date(s) incorrecte(s) pour la sélection de calendrier.',
    'Error in search expression: [_1]' => 'Erreur dans la recherche de l expression : [_1]',
    'Saving object failed: [_2]' => 'La sauvegarde des objets a échoué : [_2]',
    'No blog ID' => 'Aucun blog ID',
    'You do not have export permissions' => 'Vous n\'avez pas les droits d\'exportation',
    'You do not have import permissions' => 'Vous n\'avez pas les droits d\'importation',
    'You do not have permission to create users' => 'Vous n\'avez pas la permission de créer des utilisateurs',
    'Preferences' => 'Préférences',
    'Add a Category' => 'Ajouter une Catégorie',
    'No label' => 'Pas d etiquette',
    'Category name cannot be blank.' => 'Vous devez nommer votre catégorie.',
    'That action ([_1]) is apparently not implemented!' => 'Cette action ([_1]) n\'est visiblement pas implémentée!',
    'Error saving entry: [_1]' => 'Erreur d\'enregistrement de la note: [_1]',
    'Select Weblog' => 'Selectionner un Weblog',
    'Selected Weblog' => 'Weblog sélectionné',
    'Type a weblog name to filter the choices below.' => 'Taper le nom d\'un weblog pour affiner les choix ci-dessous.',
    'Invalid group' => 'Groupe invalide',
    'Add Users to Group [_1]' => 'Ajouter un utilisateur au Groupe[_1]',
    'Select Users' => 'Utilisateurs sélectionnés',
    'Users Selected' => 'Utilisateurs sélectionnés',
    'Type a username to filter the choices below.' => 'Tapez un nom d\'utilisateur pour affiner les choix ci-dessous.',
    'Invalid user' => 'Utilisateur invalide',
    'Assign User [_1] to Groups' => 'Associer l\'utilisateur [_1] aux groupes',
    'Select Groups' => 'Selectionner les Groupes',
    'Group' => 'Groupe',
    'Groups Selected' => 'Groupes sélectionnés',
    'Type a group name to filter the choices below.' => 'Tapez le nom d\'un groupe pour affiner les choix ci-dessous.',
    'Select Weblogs' => 'Selectionner les weblogs',
    'Weblogs Selected' => 'Weblogs Selectionnés',
    'Select Roles' => 'Selectionnez des Roles',
    'Roles Selected' => 'Roles Selectionnés',
    'Create an Association' => 'Créer une Association',

    ## ./lib/MT/FileMgr/FTP.pm
    'Creating path \'[_1]\' failed: [_2]' => 'Création chemin \'[_1]\' a échouée : [_2]',
    'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Renommer \'[_1]\' vers \'[_2]\' a échoué : [_3]',
    'Deleting \'[_1]\' failed: [_2]' => 'Effacement \'[_1]\' echec : [_2]',

    ## ./lib/MT/FileMgr/SFTP.pm
    'SFTP connection failed: [_1]' => 'La connection SFTP a échoué : [_1]',
    'SFTP get failed: [_1]' => 'Obtention SFTP a échoué : [_1]',
    'SFTP put failed: [_1]' => 'Mettre SFTP a échoué : [_1]',

    ## ./lib/MT/FileMgr/DAV.pm
    'DAV connection failed: [_1]' => 'La connection DAV a échoué : [_1]',
    'DAV open failed: [_1]' => 'Ouverture DAV a échouée : [_1]',
    'DAV get failed: [_1]' => 'Obtention DAV a échouée : [_1]',
    'DAV put failed: [_1]' => 'Mettre DAV a échouée : [_1]',

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

    ## ./t/lib/Bar.pm

    ## ./t/lib/Foo.pm

    ## ./t/lib/Text/WikiFormat.pm

    ## ./t/lib/LWP/UserAgent/Local.pm

    ## ./t/lib/MT/Test.pm
    
    'Finished! You can <a href=\"javascript:void(0);\" onclick="closeDialog(\'[_1]\');\">return to the weblogs listing</a> or <a href=\"javascript:void(0);\" onclick="closeDialog(\'[_2]\');\">configure the Site root and URL of the new weblog</a>.' => 'Terminé! Vous pouvez <a href=\"javascript:void(0);\" en cliquant sur ="closeDialog(\'[_1]\');\">retourner à la liste de vos weblogs/a> ou <a href=\"javascript:void(0);\" onclick="closeDialog(\'[_2]\');\">configurer le site racine et l\'URL d\'un nouveau weblog</a>.', # Translate - New (35)
    'Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or \'all\' (include_blogs only) are acceptable values.' => 'Active l\'utilisation du  tag MTMultiBlog tag sans les attributs inclure_blogs/exclure_blogs. Les BlogIDs séparés par une virgule ou  \'all\' (inclure_blogs seulement) sont des valeurs acceptées.', # Translate - New (22)
    '* All Weblogs' => '* Tous les Weblogs', # Translate - New (3)
    'Select to apply this trigger to all weblogs' => 'Sélectionner l\'application que ce déclencheur sur tous les weblogs', # Translate - New (8)
    'MultiBlog' => 'MultiBlog', # Translate - New (1)
    'Create New Trigger' => 'Créer un nouveau déclencheur', # Translate - New (3)
    'Search Weblogs' => 'Rechercher des Weblogs', # Translate - New (2)
    'saves an entry' => 'enregistre une note', # Translate - New (3)
    'publishes an entry' => 'publie une note', # Translate - New (3)
    'publishes a comment' => 'publie un commentaire', # Translate - New (3)
    'publishes a ping' => 'publie un ping', # Translate - New (3)
    'rebuild indexes.' => 'reconstruit les index.', # Translate - New (2)
    'rebuild indexes and send pings.' => 'reconstruit les index et envoie des pings.', # Translate - New (5)
    '\'[_1]\' is a required argument of [_2]' => '\'[_1]\' est un argument nécessaire de [_2]', # Translate - New (8)
    'MT[_1] was not used in the proper context.' => 'Le [_1] MT n\'a pas été utilisé dans le bon contexte.', # Translate - New (9)
    'You used [_1] without a query.' => 'Vous avez utilisé [_1] sans requête.', # Translate - New (6)
    'You need a Google API key to use [_1]' => 'Vous avez besoin d\'une clef API Google API key pour utiliser[_1]', # Translate - New (9)
    'You used a non-existent property from the result structure.' => 'Vous avez utilisé une propriété non existante dans le structure de réponse.', # Translate - New (9) ???
    'Unable to create the theme root directory. Error: [_1]' => 'Impossibilité de créer le thème racine du répertoire. Erreurr: [_1]', # Translate - New (9)
    'Unable to write base-weblog.css to themeroot. File Manager gave the error: [_1]. Are you sure your theme root directory is web-server writable?' => 'Impossibilité d\écrire sur la racine du thème Base-weblog.css. Le gestionnaire de fichier renvoi l\'erreur: [_1]. Etes-vous sur que votre répertoire racine de thème sur le web-serveur est en accès écriture?', # Translate - New (23)
    'Failed to find WidgetManager::Plugin::[_1]' => 'Impossible de trouver le  WidgetManager::Plugin::[_1]', # Translate - New (6) 
);


1;

## New words: 1774
