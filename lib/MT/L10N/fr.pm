package MT::L10N::fr;
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
    'Movable Type System Check' => 'Vérification Système Movable Type',
    'This page provides you with information on your system\'s configuration and determines whether you have all of the components you need to run Movable Type.' => 'Cette page vous fournit des informations sur la configuration de votre système et vérifie que vous avez installé tous les composants nécessaires à l\'utilisation de Movable Type.',
    'System Information' => 'Informations système',
    'Current working directory:' => 'Répertoire actuellement en activité:',
    'MT home directory:' => 'MT Répertoire racine :',
    'Operating system:' => 'Système  d\'exploitation :',
    'Perl version:' => 'Version Perl :',
    'Perl include path:' => 'Chemin Perl inclus :',
    'Web server:' => 'Serveur Web :',
    '(Probably) Running under cgiwrap or suexec' => 'Tâche (probablement) lancée sous cgiwrap ou suexec',
    'Checking for [_1] Modules:' => 'Vérification des Modules [_1] :',
    'Some of the following modules are required by the various data storage options in Movable Type. In order run the system, your server needs to have either DB_File, or else DBI and at least one of the other modules installed.' => 'Certains des modules suivants sont nécessaires pour les options stockage de données de Movable Type. Pour faire tourner le système votre serveur doit être équipé de DB_File, ou bien de DBI et au moins l\'un des autres modules installés.',
    'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'Soit [_1] n\'est pas installé sur votre serveur, soit la version installée est trop ancienne, ou [_1] nécessite un autre module qui n\'est pas installé.',
    'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => '[_1] n\'est pas installé sur votre serveur, ou [_1] nécessite un autre module qui n\'est pas installé.',
    'Please consult the installation instructions for help in installing [_1].' => 'Merci de consulter les instructions d\'installation de [_1].',
    'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN.' => 'La version DBD::mysql qui est installée n\'est pas compatible avec Movable Type. Merci d\'installer la version actuelle disponible sur CPAN.',
    'The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements.' => 'Le $mod est installé correctement, mais nécessite une mise à jour du module DBI. Merci de consulter les information ci-dessus concernant les modules DBI.',
    'Your server has [_1] installed (version [_2]).' => '[_1] (version [_2]) est installé sur votre serveur.',
    'Movable Type System Check Successful' => 'Vérification Système Movable Type effectuée avec succès',
    'You\'re ready to go!' => 'Vous pouvez commencer !',
    'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Tous les modules requis sont installés sur votre serveur; vous n\'avez pas besoin d\'installer de modules additionnels. Continuez l\'installation.',

    ## ./extras/examples/plugins/mirror/mirror.pl

    ## ./extras/examples/plugins/mirror/tmpl/mirror.tmpl

    ## ./extras/examples/plugins/l10nsample/l10nsample.pl
    'l10nsample' => 'l10nsample', # Translate - Previous (2)
    'This description can be localized if there is l10n_class set.' => 'Cette description peut être localisée si un l10n_class est mis en place.',
    'Fumiaki Yoshimatsu' => 'Fumiaki Yoshimatsu', # Translate - Previous (2)

    ## ./extras/examples/plugins/l10nsample/tmpl/view.tmpl
    'This phrase is processed in template.' => 'Cette phrase est mise en place dans le template.',

    ## ./default_templates/individual_entry_archive.tmpl
    'Main' => 'Accueil',
    'Tags' => 'Tags', # Translate - Previous (1)
    'Posted by [_1] on [_2]' => 'Posté par [_1] dans [_2]',
    'Permalink' => 'Lien permanent',
    'TrackBack' => 'TrackBack', # Translate - Previous (1)
    'TrackBack URL for this entry:' => 'URL de TrackBack de cette note:',
    'Listed below are links to weblogs that reference' => 'Ci-dessous la liste des liens des weblogs qui référencent',
    'from' => 'de',
    'Read More' => 'Lire la suite',
    'Tracked on' => 'Trackbacké le',
    'Comments' => 'Commentaires',
    'Posted by' => 'Posted by', # Translate - New (2)
    'Anonymous' => 'Anonyme',
    'Posted on' => 'Publié le',
    'Permalink to this comment' => 'Permalien de ce commentaire',
    'Post a comment' => 'Poster un commentaire',
    '(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(Si vous n\'avez pas encore écrit de commentaire ici, vous devez être approuvé par le propriétaire du site avant que votre commentaire n\'apparaisse. En attendant, il n\'apparaîtra pas sur le site. Merci de patienter).',
    'Name' => 'Nom',
    'Email Address' => 'Adresse e-mail',
    'URL' => 'URL', # Translate - Previous (1)
    'Remember personal info?' => 'Mémoriser mes infos personnelles ?',
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
    'What is this?' => 'De quoi s\'agit-il ?',
    'This weblog is licensed under a' => 'Ce weblog est sujet à une licence',
    'Creative Commons License' => 'Licence Creative Commons',

    ## ./default_templates/stylesheet.tmpl

    ## ./default_templates/uploaded_image_popup_template.tmpl

    ## ./default_templates/comment_error_template.tmpl
    'Comment Submission Error' => 'Erreur d\'envoi de commentaire',
    'Your comment submission failed for the following reasons:' => 'Votre envoi de commentaire a échoué pour la raison suivante :',
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
    'sign in' => 'inscription',
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
    'Posted <MTIfNonEmpty tag=' => 'Publié <MTIfNonEmpty tag=',
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
    'If you use an RSS reader, you can subscribe to a feed of all future entries matching \'[_1]\'.' => 'Si vous utilisez un lecteur de flux RSS, vous pouvez souscrire au flux des notes futures dont les caractéristiques répondent à\'[_1]\'.',
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
    'Posted on [_1]' => 'Publié le [_1]',

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
    'Don\'t add nofollow to links in comments by authenticated commenters' => 'Ne pas ajouter No follow sur les liens des commentaires de auteurs de commentaires authentifiés',

    ## ./plugins/TemplateRefresh/TemplateRefresh.pl
    'Backup and refresh existing templates to Movable Type\'s default templates.' => 'Sauvegarder et rafraîchir les habillages existants dans les habillages par défaut de Movable Type.',

    ## ./plugins/TemplateRefresh/tmpl/results.tmpl
    'Backup and Refresh Templates' => 'Sauvegarder et rafraîchir les habillages',
    'No templates were selected to process.' => 'Aucun habillage sélectionné pour cette action.',
    'Return' => 'Retour',

    ## ./plugins/feeds-app-lite/mt-feeds.pl
    'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type?' => 'Feeds.App Lite vous permet de republier des flux sur vos blogs. Vous voulez en faire plus avec les flux de Movable Type ?',
    'Upgrade to Feeds.App' => 'Mettez les à jour avec Feeds.App',

    ## ./plugins/feeds-app-lite/tmpl/select.tmpl
    'Feeds.App Lite Widget Creator' => 'Créateur de widget Feeds.App',
    'Multiple feeds were discovered. Select the feed you wish to use. Feeds.App lite supports text-only RSS 1.0, 2.0 and Atom feeds.' => 'Plusieurs flux ont été détectés. Merci de sélectionner le flux que vous souhaitez utiliser. Feed.App Lite ne spporte que les flux en texte RSS 1.0, 2.0 et les flux Atom.',
    'Type' => 'Type', # Translate - Previous (1)
    'URI' => 'URI', # Translate - Previous (1)
    'Continue' => 'Continuer',

    ## ./plugins/feeds-app-lite/tmpl/msg.tmpl
    'No feeds could be discovered using [_1].' => 'Aucun flux n\'a été découvert avec [_1].',
    'An error occurred processing [_1]. Check <a href=' => 'Une erreur est survenue [_1]. Vérifiez <a href=',
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
    'Or return to the <a href=' => 'Ou retournez sur la <a href=',

    ## ./plugins/feeds-app-lite/tmpl/config.tmpl
    'Feed Configuration' => 'Configuration du flux',
    'Feed URL' => 'URL du flux',
    'Title' => 'Titre',
    'Enter a title for your widget.  This will also be displayed as the title of the feed when used on your published blog.' => 'Entrez un titre pour votre widget. Cela sera aussi utilisé comme titre pour le flux qui sera utilisé sur votre blog.',
    'Display' => 'Afficher',
    '3' => '3', # Translate - Previous (1)
    '5' => '5', # Translate - Previous (1)
    '10' => '10', # Translate - Previous (1)
    'All' => 'Tout',
    'Select the maximum number of entries to display.' => 'Sélectionnez le nom maximum de notes que vous voulez afficher.',
    'Save' => 'Enregistrer',

    ## ./plugins/spamlookup/spamlookup_words.pl
    'SpamLookup module for moderating and junking feedback using keyword filters.' => 'Module SpamLookup pour modérer et nettoyer les retours lecteurs en utilisant des filtres de mots clefs.',

    ## ./plugins/spamlookup/spamlookup_urls.pl
    'SpamLookup - Link' => 'SpamLookup - Lien',
    'SpamLookup module for junking and moderating feedback based on link filters.' => ' Module SpamLookup pour modérer et nettoyer les retours lecteurs en utilisant des filtres de liens.',

    ## ./plugins/spamlookup/spamlookup.pl
    'SpamLookup module for using blacklist lookup services to filter feedback.' => 'Module SpamLookup pour utiliser les services blacklist visant à filtrer les retours lecteurs.',

    ## ./plugins/spamlookup/tmpl/url_config.tmpl
    'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Les Filtres de Liens contrôlent le nombre d\'hyperliens dans les commentaires ou les TrackBacks. S\'ils contiennent beaucoup de liens, ils peuvent être considérés comme indésirables.  Dans le cas contraire, les retours avec peu de liens ou des liens déjà publiés seront acceptés. N\'activez cette fonction que si vous êtes certain que votre site est dénué de tout Spam.',
    'Link Limits:' => 'Limites de lien :',
    'Credit feedback rating when no hyperlinks are present' => 'Accorder un crédit aux retours dépourvus de liens',
    'Adjust scoring' => 'Ajuster la notation',
    'Score weight:' => 'Poids du score :',
    'Decrease' => 'Baisser',
    'Increase' => 'Augmenter',
    'Moderate when more than' => 'Modérer si plus de',
    'link(s) are given' => 'lien(s) sont donnés',
    'Junk when more than' => 'Rejeter si plus de',
    'Link Memory:' => 'Mémoire de Lien :',
    'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Accorder un crédit à un retour quand &quot;URL&quot; l\'élément du retour a été publié auparavant',
    'Only applied when no other links are present in message of feedback.' => 'Appliqué uniquement si aucun autre lien n\'est présent dans le message de retour.',
    'Exclude URLs from comments published within last [_1] days.' => 'Exclure les URLS des commentaires publiés lors des [_1] derniers jours.',
    'Email Memory:' => 'Mémoire Email :',
    'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Accorder un crédit au retour quand des commentaires préalablement publiés contiennent aussi &quot;Email&quot;',
    'Exclude Email addresses from comments published within last [_1] days.' => 'Exclure les adresses emails des commentaires publiés dans les  [_1] derniers jours.',

    ## ./plugins/spamlookup/tmpl/lookup_config.tmpl
    'Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog\'s Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.' => 'Les Lookups contrôlent les sources des adresses IP et les liens hypertextes de tous les retours lecteurs. Si un commentaire ou un TrackBack provient d\'une adresse IP blacklisté, ou contient un lien ou un domaine blacklisté, il pourra être automatiquement placé dans le dossier des élements indésirables.',
    'IP Address Lookups:' => 'Lookups Adresses IP :',
    'Off' => 'Désactivé',
    'Moderate feedback from blacklisted IP addresses' => 'Modérer les retours des adresses IP blacklistées',
    'Junk feedback from blacklisted IP addresses' => 'Rejeter les retours des adresses IP blacklistées',
    'Less' => 'Moins',
    'More' => 'Plus',
    'block' => 'bloquer',
    'none' => 'aucun',
    'IP Blacklist Services:' => 'Services de Blackliste d\'IP :',
    'Domain Name Lookups:' => 'Lookups Noms de Domaines :',
    'Moderate feedback containing blacklisted domains' => 'Modérer les retours lecteur contenant des domaines blacklistés',
    'Junk feedback containing blacklisted domains' => 'Rejeter les retours contenant des domaines blacklistés',
    'Domain Blacklist Services:' => ' Services de Blackliste des Domaines :',
    'Advanced TrackBack Lookups:' => 'Lookups Avancé des Trackbacks :',
    'Moderate TrackBacks from suspicious sources' => 'Modérer les TrackBacks provenant de sources douteuses',
    'Junk TrackBacks from suspicious sources' => 'Rejeter les TrackBacks provenant de sources douteuses',
    'To prevent lookups for some IP addresses or domains, list them below. Place each entry on a line by itself.' => 'Pour ne pas appliquer le LookUps sur certaines IP ou Domaines, les lister ci-dessous. Merci de saisir un élément par ligne.',
    'Lookup Whitelist:' => 'Lookup Whiteliste :',

    ## ./plugins/spamlookup/tmpl/word_config.tmpl
    'Incomming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Les retours des lecteurs peuvent être contrôlés sur un mot clef spécifique, un nom de domaine, et du contenu. La combinaison de critères permet de détecter les indésirables. Vous pouvez paramétrer vos pondérations pour définir un indésirable.',
    'Keywords to Moderate:' => 'Mots clefs à modérer :',
    'Keywords to Junk:' => 'Mots clefs à rejeter :',

    ## ./plugins/GoogleSearch/GoogleSearch.pl

    ## ./plugins/GoogleSearch/tmpl/config.tmpl
    'Google API Key:' => 'Clé d\'API Google :',
    'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.' => 'Vous devrez vous procurer une clé d\'API Google si vous souhaitez utiliser une des fonctionnalités de l\'API proposée par Google. Le cas échéant, collez cette clé dans cet espace.',

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
    'It will take a moment for themes to populate once you click \'Find Style\'.' => 'La mise à jour des themes prendra quelques temps à partir du moment où vous cliquerez sur  \'trouver un style\'.',
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
    'You don\'t appear to have any weblogs with a \'styles-site.css\' template that you have rights to edit. Please check your weblog(s) for this template.' => 'You don\'t appear to have any weblogs with a \'styles-site.css\' template that you have rights to edit. Please check your weblog(s) for this template.', # Translate - New (27)

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
    'Delete Selected' => 'Effacer les éléments sélectionnés',
    'Are you sure you wish to delete the selected Widget Manager(s)?' => 'Êtes-vous sur de vouloir supprimer le(s) Gestionnaire(s) de Widgets selectionné(s) ?',
    'WidgetManager Name' => 'Nom du Gestionnaire de Widget',
    'Installed Widgets' => 'Widgets installés',

    ## ./plugins/WidgetManager/tmpl/header.tmpl
    'Movable Type Publishing Platform' => 'Plateforme de publication Movable Type',
    'Weblogs' => 'Weblogs', # Translate - Previous (1)
    'Go' => 'OK',

    ## ./plugins/WidgetManager/tmpl/edit.tmpl
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

    ## ./build/exportmt.pl

    ## ./build/l10n/diff.pl

    ## ./build/l10n/wrap.pl

    ## ./build/l10n/trans.pl

    ## ./tmpl/error.tmpl
    'Missing Configuration File' => 'Fichier de configuration manquant',
    'Database Connection Error' => 'Erreur de connexion à la base de données',
    'CGI Path Configuration Required' => 'Configuration de chemin CGI requise',
    'An error occurred' => 'Une erreur s\'est produite',

    ## ./tmpl/cms/edit_entry.tmpl
    'You have unsaved changes to your entry that will be lost.' => 'Votre Note contient des changements non enregistrés qui seront perdus.',
    'Add new category...' => 'Ajouter une catégorie...',
    'Publish On' => 'Publié sur',
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
    'Click on a [_1] to edit it. To perform any other action, check the checkbox of one or more [_2] and click the appropriate button or select a choice of actions from the dropdown to the right.' => 'Cliquez sur un(e) [_1] pour l\'éditer. Pour éffectuer une autre action, cochez les cases pour un(e) ou plusieur(e)s [_2] et cliquez sur le bouton approprié ou sélectionez une action dans la liste déroulante de droite.',
    'No comments exist for this entry.' => 'Pas de commentaire sur cette note.',
    'Manage TrackBacks' => 'Gérer les TrackBacks',
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
    'Basic' => 'Basique',
    'Custom' => 'Personnalisé',
    'Editable Authored On Date' => 'Date de création modifiable',
    'Action Bar' => 'Barre d\'action',
    'Select the location of the entry editor\'s action bar.' => 'Choisissez l\'emplacement de la barre d\'action d\'édition de Notes.',
    'Below' => 'Sous',
    'Above' => 'Dessus',
    'Both' => 'Les deux',

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
    'Filter' => 'Filtrer',
    'None.' => 'Aucun',
    '(Showing all commenters.)' => '(Afficher tous les auteurs de commentaires).',
    'Showing only commenters whose [_1] is [_2].' => 'Ne montrer que les auteurs de commentaires dont [_1] est [_2].',
    'Commenter Feed' => 'Flux auteur de commentaire',
    'Commenter Feed (Disabled)' => 'Flux auteur de commentaire (Inactif)',
    'Disabled' => 'Désactivé',
    'Set Web Services Password' => 'Définir un mot de passe pour les services Web',
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
    'Quickfilter:' => 'Filtre Rapide :',
    'Show unpublished comments.' => 'Afficher les commentaires non publiés.',
    '(Showing all comments.)' => '(Affichage tous les commentaires).',
    'Showing only comments where [_1] is [_2].' => 'Affichage de tous les commentaires où [_1] est [_2].',
    'comments.' => 'les commentaires.',
    'comments where' => 'commentaires dont',
    'published' => 'publié',
    'unpublished' => 'non publié',
    'No comments could be found.' => 'Aucun commentaire n\'a été trouvé.',
    'No junk comments could be found.' => 'Aucun commentaire indésirable n\'a été trouvé.',

    ## ./tmpl/cms/show_upload_html.tmpl
    'Copy and paste this HTML into your entry.' => 'Copiez/collez ce code HTML dans votre note.',
    'Close' => 'Fermer',
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
    'Error' => 'Erreur',
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
    'Authorship of imported entries:' => 'Auteur des notes importées :',
    'Import as me' => 'Importer en me considérant comme auteur',
    'Preserve original author' => 'Conserver l\'auteur original',
    'If you choose to preserve the authorship of the imported entries and any of those authors must be created in this installation, you must define a default password for those new accounts.' => 'Si vous choisissez de garder l\'auteur original de chaque note importée, ils doivent être créés dans votre installation et vous devez définir un mot de passe par défaut pour ces nouveaux comptes.',
    'Default password for new authors:' => 'Mot de passe par défaut pour les nouveaux auteurs :',
    'Upload import file: (optional)' => 'Charger les fichiers importés : (optionnel)',
    'You will be assigned the author of all imported entries.  If you wish the original authors to keep ownership, you must contact your MT system administrator to perform the import so that new authors can be created if necessary.' => 'Vous serez considéré comme l\'auteur de toutes les notes importées. Si vous souhaitez conserver l\'attribution à l\'auteur original de ces notes, vous devez contacter votre administrateur système Movable Type pour effectuer l\'importation.',
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

    ## ./tmpl/cms/delete_confirm.tmpl
    'Are you sure you want to permanently delete the [quant,_1,author] from the system?' => 'Souhaitez-vous vraiment supprimer [quant,_1,auteur] de façon permanente du système ?',
    'Are you sure you want to delete the [quant,_1,comment]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,commentaire] ?',
    'Are you sure you want to delete the [quant,_1,TrackBack]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,TrackBack] ?',
    'Are you sure you want to delete the [quant,_1,entry,entries]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,note,notes] ?',
    'Are you sure you want to delete the [quant,_1,template]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,modèle] ?',
    'Are you sure you want to delete the [quant,_1,category,categories]? When you delete a category, all entries assigned to that category will be unassigned from that category.' => 'Souhaitez-vous vraiment supprimer [quant,_1,catégorie,catégories] ? L\'association entre une note et une catégorie est perdue lorsque vous supprimez une catégorie.',
    'Are you sure you want to delete the [quant,_1,template] from the particular archive type(s)?' => 'Souhaitez-vous vraiment supprimer [quant,_1,modèle] de ce(s) type(s) d\'archive ?',
    'Are you sure you want to delete the [quant,_1,IP address,IP addresses] from your Banned IP List?' => 'Souhaitez-vous vraiment supprimer [quant,_1,adresse IP,adresses IP] de la liste des adresses IP bannies ?',
    'Are you sure you want to delete the [quant,_1,notification address,notification addresses]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,adresse pour avis,adresses pour avis] ?',
    'Are you sure you want to delete the [quant,_1,blocked item,blocked items]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,élément bloqué,éléments bloqués] ?',
    'Are you sure you want to delete the [quant,_1,weblog]? When you delete a weblog, all of the entries, comments, templates, notifications, and author permissions are deleted along with the weblog itself. Make sure that this is what you want, because this action is permanent.' => 'Souhaitez-vous vraiment supprimer [quant,_1,weblog] ? Lorsque vous supprimez un weblog, les notes, les commentaires, les modèles, les avis, et les permissions affectées aux auteurs sont également supprimé(e)s. Notez également que le résultat de cette action est définitif.',
    'Delete' => 'Supprimer',

    ## ./tmpl/cms/cfg_system_feedback.tmpl
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
    'template' => 'Habillage',
    'templates' => 'Habillages',

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
    'author' => 'l\'auteur',
    'tag (exact match)' => 'le tag (exact)',
    'tag (fuzzy match)' => 'le tag (fuzzy match)',
    'category' => 'catégorie',
    'scheduled' => 'programmé',
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
    'Built w/Indexes' => 'Construits avec indexs',
    'Yes' => 'Oui',
    'No' => 'Non',
    'View Published Template' => 'Voir les habillages publiés',
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
    'Author Profile' => 'Profil de l\'auteur',
    'Create New Author' => 'Créer un nouvel auteur',
    'Profile' => 'Profil',
    'Permissions' => 'Autorisations',
    'Your profile has been updated.' => 'Votre profil a été mis à jour.',
    'Weblog Associations' => 'Associations de Weblogs',
    'General Permissions' => 'Autorisations générales',
    'System Administrator' => 'Administrateur Système',
    'Create Weblogs' => 'Créer des Weblogs',
    'View Activity Log' => 'Afficher le journal des activités',
    'Username' => 'Nom d\'utilisateur',
    'The name used by this author to login.' => 'Le nom utilisé par cet Auteur pour s\'enregistrer.',
    'Display Name' => 'Afficher le nom',
    'The author\'s published name.' => 'Nom publié de l\'auteur.',
    'The author\'s email address.' => 'Adresse email de l\'auteur .',
    'Website URL:' => 'URL du site :',
    'The URL of this author\'s website. (Optional)' => 'URL du site de  l\'auteur. (option)',
    'Language:' => 'Langue :',
    'The author\'s preferred language.' => 'Langue choisie par l\'auteur.',
    'Tag Delimiter:' => 'Séparateur de Tag :',
    'Comma' => 'Virgule',
    'Space' => 'Espace',
    'Other...' => 'Autre...',
    'The author\'s preferred delimiter for entering tags.' => 'Séparateur préconisé par l\'auteur pour les tag.',
    'Password' => 'Mot de passe',
    'Current Password:' => 'Mot de passe actuel :',
    'Enter the existing password to change it.' => 'Entrez le mot de passe actuel pour le changer.',
    'New Password:' => 'Nouveau Mot de Passe :',
    'Initial Password' => 'Initial Password', # Translate - New (2)
    'Select a password for the author.' => 'Choisissez un mot de passe pour  l\'auteur.',
    'Password Confirm:' => 'Confirmation du Mot de Passe:',
    'Repeat the password for confirmation.' => 'Répetez la confirmation de Mot de passe.',
    'Password recovery word/phrase' => 'Mot/Expression pour retrouver un mot de passe',
    'This word or phrase will be required to recover your password if you forget it.' => 'Ce mot ou cette expression vous seront nécessaires pour retrouver votre mot de passe. Ne les oubliez pas.',
    'Web Services Password:' => 'Mot de passe Service Web :',
    'Reveal' => 'Révélé',
    'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'Pour utilisation par les flux d\'activité et avec les clients XML-RPC ou ATOM.',
    'Save this author (s)' => 'Sauvegarder cet auteur (s)',

    ## ./tmpl/cms/notification_table.tmpl
    'Date Added' => 'Ajouté(e) le',

    ## ./tmpl/cms/overview-left-nav.tmpl
    'List Weblogs' => 'Liste des Weblogs',
    'List Authors' => 'Liste des Auteurs',
    'Authors' => 'Auteurs',
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
    'The Movable Type activity log contains a record of notable actions in the system.' => 'Le journal de l\'activité de Movable Type contient un enregistrement des actions principales dans le système.',
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

    ## ./tmpl/cms/admin.tmpl
    'System Stats' => 'Statistiques système',
    'Active Authors' => 'Auteurs Actifs',
    'Essential Links' => 'Liens essentiels',
    'Movable Type Home' => 'Accueil Movable Type',
    'Plugin Directory' => 'Annuaire des plugins',
    'Support and Documentation' => 'Support et Documentation',
    'https://secure.sixapart.com/t/account' => 'https://secure.sixapart.com/t/account?portal=fr',
    'Your Account' => 'Votre compte',
    'https://secure.sixapart.com/t/help?__mode=edit' => 'https://secure.sixapart.com/t/help?__mode=edit&portal=fr',
    'Open a Help Ticket' => 'Ouvrir un Ticket d\'Aide',
    'Paid License Required' => 'Une licence payante est nécessaire',
    'http://www.sixapart.com/movabletype/' => 'http://www.movabletype.fr',
    'http://www.sixapart.com/pronet/plugins/' => 'http://www.sixapart.com/pronet/plugins/', # Translate - Previous (6)
    'https://secure.sixapart.com/t/help?__mode=kb' => 'https://secure.sixapart.com/t/help?__mode=kb&portal=fr',
    'Knowledge Base' => 'Base de connaissance',
    'http://www.sixapart.com/pronet/' => 'http://www.sixapart.com/pronet/', # Translate - Previous (5)
    'Professional Network' => 'Réseau Professionnel',
    'From this screen, you can view information about and manage many aspects of your system across all weblogs.' => 'Cet écran vous permet de voir un certain nombre d\'informations concernant vos weblogs et le système dans leur ensemble.',
    'Movable Type News' => 'Infos Movable Type',

    ## ./tmpl/cms/entry_table.tmpl
    'Weblog' => 'Weblog', # Translate - Previous (1)
    'Only show unpublished entries' => 'N\'afficher que les notes non publiées',
    'Only show published entries' => 'Afficher uniquement les notes publiées',
    'Only show scheduled entries' => 'N\'afficher que les notes programmées dans le futur',
    'None' => 'Aucune',

    ## ./tmpl/cms/pinged_urls.tmpl
    'Here is a list of the previous TrackBacks that were successfully sent:' => 'Voici la liste des TrackBacks envoyés avec succès :',
    'Here is a list of the previous TrackBacks that failed. To retry these, include them in the Outbound TrackBack URLs list for your entry.:' => 'Voici la liste des Trackbacks précédents qui on échoué. Pour essayer à nouveau, il faut les inclure dans la liste des URL de TrackBack sortants de votre note :',

    ## ./tmpl/cms/edit_admin_permissions.tmpl
    'Your changes to [_1]\'s permissions have been saved.' => 'Vos modifications des autorisations accordés à  [_1] a été enregistré.',
    '[_1] has been successfully added to [_2].' => '[_1] a été ajouté(e) avec succès à [_2].',
    'User can create weblogs' => 'L\'utilisateur peut créer un weblog',
    'User can view activity log' => 'L\'utilisateur peut afficher le journal des activités',
    'Check All' => 'Sélectionner tout',
    'Uncheck All' => 'Désélectionner tout',
    'Unheck All' => 'Tout décocher',
    'Add user to an additional weblog:' => 'Ajouter l\'utilisateur à un weblog supplémentaire :',
    'Select a weblog' => 'Sélectionnez un weblog',
    'Add' => 'Ajouter',
    'Save permissions for this author (s)' => 'Enregistrer les autorisations accordées à cet auteur',

    ## ./tmpl/cms/log_actions.tmpl
    'Reset Activity Log' => 'Réinitialiser le journal des activités',

    ## ./tmpl/cms/rebuild_confirm.tmpl
    'Select the type of rebuild you would like to perform. (Click the Cancel button if you do not want to rebuild any files.)' => 'Sélectionnez le type d\'actualisation que vous souhaitez exécuter (cliquez sur Annuler si vous souhaitez annuler l\'actualisation des fichiers).',
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

    ## ./tmpl/cms/reload_opener.tmpl

    ## ./tmpl/cms/notification_actions.tmpl
    'notification address' => 'adresse de notification',
    'notification addresses' => 'adresses de notification',
    'Delete selected notification addresses (x)' => 'Effacer les adresses de notification sélectionnées (x)',

    ## ./tmpl/cms/cc_return.tmpl

    ## ./tmpl/cms/login.tmpl
    'Your Movable Type session has ended. If you wish to log in again, you can do so below.' => 'Votre session Movable Type a été fermée. Pour ouvrir une nouvelle session voir ci-dessous.',
    'Your Movable Type session has ended. Please login again to continue this action.' => 'Votre session Movable Type a expiré. Merci de vous enregistrer à nouveau pour poursuivre.',
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
    'No authors were selected to process.' => 'Aucun auteur sélectionné pour l\'opération.',

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

    ## ./tmpl/cms/log_table.tmpl
    'IP: [_1]' => 'IP : [_1]',

    ## ./tmpl/cms/edit_profile.tmpl
    'Author Permissions' => 'Autorisations des Auteurs',
    'A new password has been generated and sent to the email address [_1].' => 'Un nouveau mot de passe a été créé et envoyé à l\'adresse [_1].',
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

    ## ./tmpl/cms/author_actions.tmpl
    'authors' => 'auteurs',
    'Delete selected authors (x)' => 'Effacer les auteurs sélectionnés (x)',

    ## ./tmpl/cms/install.tmpl
    'Welcome to Movable Type!' => 'Bienvenue sur Movable Type !',
    'Do you want to proceed with the installation anyway?' => 'Voulez-vous tout de même poursuivre l\'installation ?',
    'Before you can begin blogging, we need to complete your installation by initializing your database.' => 'Avant de commencer à pouvoir bloguer vous devez terminer votre installation en initialisant votre base de données.',
    'You will need to select a username and password for the administrator account.' => 'Vous devrez choisir un nom d\'utilisateur et un mot de passe pour l\'administrateur du compte.',
    'Select a password for your account.' => 'Selectionnez un Mot de Passe pour votre compte.',
    'Password recovery word/phrase:' => 'Phrase pour la récupération du mot de passe :',
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
    'Importing entries as author \'[_1]\'' => 'Importation des notes en tant qu\'auteur \'[_1]\'',
    'Creating new authors for each author found in the blog' => 'Création de nouveaux auteur correspondant à chaque auteur trouvé dans le blog',

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
    'No actions' => 'Aucune action',

    ## ./tmpl/cms/edit_blog.tmpl
    'You must set your Local Site Path.' => 'Vous devez configurer le chemin local de votre site.',
    'You must set your Site URL.' => 'Vous devez configurer l\'URL de votre site.',
    'Your Site URL is not valid.' => 'L\'adresse URL de votre site n\'est pas valide.',
    'You can not have spaces in your Site URL.' => 'Vous ne pouvez pas avoir d\'espaces dans l\'adresse URL de votre site.',
    'You can not have spaces in your Local Site Path.' => 'Vous ne pouvez pas avoir d\'espaces dans le chemin local de votre site.',
    'Your Local Site Path is not valid.' => 'Le chemin local de votre site n\'est pas valide.',
    'New Weblog Settings' => 'Nouveaux paramètres du weblog',
    'From this screen you can specify the basic information needed to create a weblog.  Once you click the save button, your weblog will be created and you can continue to customize its settings and templates, or just simply start posting.' => 'A partir de cet écran vous pouvez spécifier les informations de base nécessaires pour créer un weblog. En cliquant sur le bouton Sauvegarder, votre weblog sera créé et vous pourrez poursuivre la personnalisation de ses paramètres et habillages, ou simplement commencer à publier.',
    'Your weblog configuration has been saved.' => 'La configuration de votre weblog a été enregistrée.',
    'Site URL:' => 'URL du site :',
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
    'List &amp; Edit Templates' => 'Lister &amp; Editer les habillages',
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
    'This is the URL that others will use to send TrackBacks to your weblog. If you wish for anyone to send TrackBacks to your weblog when they have a post specific to this category, post this URL publicly. If you choose to only allow a select group of individuals to TrackBack, send this URL to them privately. To include a list of incoming TrackBacks in your Main Index Template, check the documentation for template tags related to TrackBacks.' => 'Ceci est l\'adresse URL que les personnes vont voir sur votre blog afin de vous envoyer des TrackBacks. Si vous souhaitez que quiconque puisse vous envoyer des TrackBacks, rendez cette adresse publique. Si vous souhaitez seulement que certaines personnes vous envoient des TrackBacks, envoyez leur cette adresse en privé. Pour inclure une liste de tout les TrackBacks entrants sur votre modèle Main Index Template, consultez la documentation dans la partie relative aux TrackBacks.',
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
    'all rows' => 'toutes les lignes',
    'Another amount...' => 'Autre montant...',
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
    'Feedback Settings' => 'Paramétrages des Feedbacks',
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

    ## ./tmpl/cms/header.tmpl
    'Go to:' => 'Aller à :',
    'Select a blog' => 'Sélectionner un blog',
    'System-wide listing' => 'Listing sur la totalité du système',

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

    ## ./tmpl/cms/list_author.tmpl
    'You have successfully deleted the authors from the Movable Type system.' => 'Les auteurs ont été effacés du système Movable Type.',
    'Created By' => 'Créé par',
    'Last Entry' => 'Dernière Note',

    ## ./tmpl/cms/pending_commenter.tmpl

    ## ./tmpl/cms/header-popup.tmpl

    ## ./tmpl/cms/edit_ping.tmpl
    'The TrackBack has been approved.' => 'Le TrackBack a été approuvé.',
    'List &amp; Edit TrackBacks' => 'Lister &amp; Editer les TrackBacks',
    'Junked TrackBack' => 'TrackBacks indésirables',
    'Status:' => 'Statut :',
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
    'Upgrade complete!' => 'Mise à jour terminé e!',
    'Login to Movable Type' => 'S\'enregistrer dans Movable Type',
    'Return to Movable Type' => 'Retourner à Movable Type',
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
    'Create, manage, set permissions.' => 'Créer, gérer et accorder les autorisations.',
    'What\'s installed, access to more.' => 'Eléments installés, en installer de nouveaux.',
    'Multi-weblog entry listing.' => 'Liste des notes de tous les weblogs.',
    'Multi-weblog tag listing.' => 'Liste des tags de tous les weblogs.',
    'Multi-weblog comment listing.' => 'Liste des commentaires de tous les weblogs.',
    'Multi-weblog TrackBack listing.' => 'Liste des TrackBacks de tous les weblogs.',
    'System-wide configuration.' => 'Configuration générale du système.',
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
    'Create a new entry on this weblog' => 'Créer une nouvelle note sur ce weblog',
    'Sort By:' => 'Trié par :',
    'Creation Order' => 'Ordre de création',
    'Last Updated' => 'Dernière Mise à jour',
    'Order:' => 'Ordre :',
    'You currently have no blogs.' => 'Pour l\'instant vous n\'avez pas de blog.',
    'Please see your system administrator for access.' => 'Merci de consulter l\'administrateur système pour obtenir un accès.',

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

    ## ./tmpl/cms/search_replace.tmpl
    'You must select one or more item to replace.' => 'Vous devez sélectionner un ou plusieurs objets à remplacer.',
    'Search Again' => 'Chercher encore',
    'Search:' => 'Chercher:',
    'Replace:' => 'Remplacer:',
    'Replace Checked' => 'Remplacer les objets selectionnés',
    'Case Sensitive' => 'Respecter la casse',
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
    'From:' => 'De :',
    'To:' => 'A :',
    'Replaced [_1] records successfully.' => '[_1] enregistrements remplacés avec succès.',
    'No entries were found that match the given criteria.' => 'Aucune note ne correspond à votre recherche.',
    'No comments were found that match the given criteria.' => 'Aucun commentaire ne correspond à votre recherche.',
    'No TrackBacks were found that match the given criteria.' => 'Aucun TrackBack ne correspond à votre recherche.',
    'No commenters were found that match the given criteria.' => 'Aucun auteur de commentaires ne correspond à votre recherche.',
    'No templates were found that match the given criteria.' => 'Aucun habillage ne correspond à votre recherche.',
    'No log messages were found that match the given criteria.' => 'Aucun message de log ne correspond à votre recherche.',
    'No authors were found that match the given criteria.' => 'Aucun auteur ne correspond à votre recherche.',
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

    ## ./tmpl/cms/bm_entry.tmpl
    'Select' => 'Sélectionner',
    'You must choose a weblog in which to post the new entry.' => 'Vous devez sélectionner le weblog dans lequel publier cette note.',
    'Select a weblog for this post:' => 'Sélectionnez un weblog pour cette note :',
    'Send an outbound TrackBack:' => 'Envoyer un TrackBack :',
    'Select an entry to send an outbound TrackBack:' => 'Choisissez une note pour envoyer un TrackBack :',
    'Accept' => 'Accepter',
    'You do not have entry creation permission for any weblogs on this installation. Please contact your system administrator for access.' => 'Vous n\'avez pas accès à la création de weblog dans cette installation. Merci de contacter votre Administrateur Système pour avoir un accès.',

    ## ./tmpl/cms/cfg_archives.tmpl
    'Are you sure you want to delete this template map?' => 'Etes-vous sur de vouloir supprimer cette carte d\'habillage ?',
    'You must set a valid Site URL.' => 'Vous devez spécifier une URL valide.',
    'You must set a valid Local Site Path.' => 'Vous devez spécifier un chemin local d\'accès valide.',
    'Publishing Settings' => 'Paramètres de publication',
    'This screen allows you to control this weblog\'s publishing paths and preferences, as well as archive mapping settings.' => 'Cet écran vous permet de contrôler les chemins de publication, les préférences et les paramètres d\'archives de ce weblog.',
    'Error: Movable Type was not able to create a directory for publishing your weblog. If you create this directory yourself, assign sufficient permissions that allow Movable Type to create files within it.' => 'Erreur : Movable Type n\'a pas pu créer le dossier pour publier ce weblog.  Si vous créez ce dossier vous même, assigner suffisamment d\'autorisations à Movable Type pour y créer des fichiers.',
    'Your weblog\'s archive configuration has been saved.' => 'La configuration des archives de votre weblog a été enregistrée.',
    'You may need to update your templates to account for your new archive configuration.' => 'Vous devrez peut-être mettre à jour votre habillage pour pour obtenir votre nouvelle configuration d\'archives.',
    'You have successfully added a new archive-template association.' => 'L\'association modèle/archive a réussi.',
    'You may need to update your \'Master Archive Index\' template to account for your new archive configuration.' => 'Vous aurez peut-être besoin de mettre à jour votre habillage \'Index principal des archives\' pour activer la nouvelle configuration de vos archives.',
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
    'Individual' => 'Individuel',
    'Daily' => 'Quotidien',
    'Weekly' => 'Hebdomadaire',
    'Monthly' => 'Mensuel',
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
    'Upload' => 'Télécharger',

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
    'Step 1 of 3' => 'Étape 1 sur 3',
    'Requirements Check' => 'Vérifications des éléments indispensables',
    'One of the following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your weblog data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the \'Retry\' button.' => 'Un des modules Perl suivant est requis afin de faire une connexion à la base de données. Movable Type a besoin d\'une base de donnée pour stocker les données de votre blog. Merci d\'installer un ou plusieurs packages listés ici pour la base de données. Quand vous avez fait la modification cliquez sur le bouton \'Réessayer\'.',
    'Missing Database Packages' => 'Elément de base de données manquant',
    'The following optional, feature-enhancing Perl modules could not be found. You may install them now and click \'Retry\' or simply continue without them.  They can be installed at any time if needed.' => 'Les modules optionnels Perl suivants n\'ont pas été trouvés. Vous pouvez les installer maintenant puis cliquez sur \'Réessayer\' ou simplement continuer sans les installer. Ils peuvent aussi être installés ultérieurement.',
    'Missing Optional Packages' => 'Packages optionnels manquants',
    'The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the \'Retry\' button to re-test for these packages.' => 'Les modules Perl suivants sont indispenssables à Movable Type. Une fois que vous les avez installer correctement, cliquez sur le bouton \'Réessayer\' pour refaire le test.',
    'Missing Required Packages' => 'Packages obligatoires manquants',
    'Minimal version requirement:' => 'Version minimale requise :',
    'Installation instructions.' => 'Instruction d\'installation.',
    'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'Votre serveur contient tous les modules nécessaires installés; inutile de lancer une installation complémentaire.',
    'Back' => 'Retour',
    'Retry' => 'Recommencer',

    ## ./tmpl/wizard/optional.tmpl
    'Step 3 of 3' => 'Étape 3 sur 3',
    'Mail Configuration' => 'Configuration Email',
    'Your mail configuration is complete. To finish with the configuration wizard, press \'Continue\' below.' => 'Your mail configuration is complete. To finish with the configuration wizard, press \'Continue\' below.', # Translate - New (14)
    'You can configure you mail settings from here, or you can complete the configuration wizard by clicking \'Continue\'.' => 'Vous pouvez, à partir de là, configurer les paramètres email, ou le faire  avec le configurateur étpape par étape en cliquant sur \'Continuer\'.',
    'An error occurred while attempting to send mail: ' => 'Une erreur est intervenue lors de la tentative d\'envoi d\'email: ',
    'MailTransfer' => 'Transfert email',
    'Select One...' => 'Sélectionner un...',
    'SendMailPath' => 'Chemin d\'envoi email',
    'The physical file path for your sendmail.' => 'Le chemin physique pour votre SendMail.',
    'SMTP Server' => 'Serveur SMTP',
    'Address of your SMTP Server' => 'Addresse de votre serveur SMTP',
    'Mail address for test sending' => 'Addresse email pour envoi d\'un test',
    'Send Test Email' => 'Envoyer un email test',

    ## ./tmpl/wizard/complete.tmpl
    'Congratulations! You\'ve successfully configured [_1] [_2].' => 'Félicitations ! Vous avez configuré avec succès [_1] [_2].',
    'This is a copy of your configuration settings.' => 'Ceci est une copie de vos paramètres de configuration.',
    'We were unable to create your configuration file. If you would like to check the directory permissions and retry, click the \'Retry\' button.' => 'Nous n\'avons pas pu créer votre fichier de configuration. Merci de vérifier la bibliothèque des autorisations et d\'essayer à nouveau cliquez sur le bouton \'Recommencer\'.',
    'Install' => 'Installer',

    ## ./tmpl/wizard/header.tmpl
    'Movable Type' => 'Movable Type', # Translate - Previous (2)
    'Movable Type Configuration Wizard' => 'Configuration Movable Type pas à pas',

    ## ./tmpl/wizard/start.tmpl
    'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Movable Type nécessite l\'activation des Javascripts sur votre navigateur.  Merci de le faire et de rafraîchir la page pour commencer le processus',
    'Your Movable Type configuration file already exists. The Wizard cannot continue with this file present.' => 'Votre fichier de configuration Movable Type existe déjà. L\'installation pas à pas ne peut pas continuer avec ce fichier présent.',
    'This wizard will help you configure the basic settings needed to run Movable Type.' => 'L\'installation pas à pas va vous aider à configurer les paramètres de base nécéssaires à l\'installation de Movable Type.',
    'Static Web Path' => 'Chemin Web Statique',
    'Due to your server\'s configuration it is not accessible in its current location and must be moved to a web-accessible location (e.g. into your web document root directory).' => 'Avec la configuration actuelle de votre serveur le dossier n\'est pas accessible depuis son endroit actuel et doit être déplaçé dans un endroit accessible depuis Internet (par exemple dans le dossier racine de votre serveur web).',
    'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Ce dossier a soit été renommé ou déplacé dans un endroit en dehors du dossier Movable Type.',
    'Please specify the web-accessible URL to this directory below.' => 'Merci de spécifier l\'adresse URL accessible depuis Internet de ce répertoire.',
    'Static web path URL' => 'Adresse URL statique du chemin',
    'This can be in the form of http://example.com/mt-static/ or simply /mt-static' => 'Ceci peut avoir la forme de http://example.com/mt-static/ ou simplement /mt-static',
    'Begin' => 'Commencer',

    ## ./tmpl/wizard/configure.tmpl
    'Step 2 of 3' => 'Étape 2 sur 3',
    'Database Configuration' => 'Configuration Base de Données',
    'Your database configuration is complete. Click \'Continue\' below to configure your mail settings.' => 'La configuration de votre Base de Données est terminée.  Cliquez sur \'Continuer\' pour configurer les paramètres email',
    'Please enter the parameters necessary for connecting to your database.If your database type is not listed in the dropdown below, you may be missing the Perl module necessary to connect to your database.  If this is the case, please check your installation and click <a href=' => 'Merci de saisir les paramètres de connexion à votre base de données. Si votre base n\'eest pas listée dans le menu déroulant ci-dessous, c\'est probablement qu\'il vous manque un module Perl nécessaire pour effectuer cette connexion. Dans ce cas, merci de vérifier votre installation et cliquer sur <a href=',
    'An error occurred while attempting to connect to the database: ' => 'Une erreur s\'est produite lors de la tentative de connexion à votre base de données: ',
    'Database' => 'Base de données',
    'Database Path' => 'Chemin de Base de données',
    'The physical file path for your BerkeleyDB or SQLite database. ' => 'Le chemin physique d\'accès pour votre Base de données BerkeleyDB ou SQLite. ',
    'A default location of \'./db\' will store the database file(s) underneath your Movable Type directory.' => 'Une localisation par défaut de  \'./db\' archivera  les fichiers de Base de données dans votre librairie Movable Type.',
    'Database Name' => 'Nom de la Base de données',
    'The name of your SQL database (this database must already exist).' => 'Le nom de votre Base de données SQL (Cette base de données doit déjà exister).',
    'The username to login to your SQL database.' => 'Le nom d\'utilisateur pour s\'identifier dans votre Base de données.',
    'The password to login to your SQL database.' => 'Le mot de passe pour s\'identifier dans votre Base de données.',
    'Database Server' => 'Serveur de Base de données',
    'This is usually \'localhost\'.' => 'C\'est habituellement\'localhost\'.',
    'Database Port' => 'Port de la Base de données',
    'This can usually be left blank.' => 'Peut être habituellement laissé vide.',
    'Database Socket' => 'Socket de Base de Données',
    'Test Connection' => 'Test de Connexion',

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
    '_BLOG_CONFIG_MODE_DETAIL' => 'Mode détaillé',
    'The previous post in this blog was <a href="[_1]">[_2]</a>.' => 'La note précédente de ce blog est <a href="[_1]">[_2]</a>.',
    'RSS 1.0 Index' => 'Index RSS 1.0',
    '_USAGE_BOOKMARKLET_4' => 'QuickPost vous permet de publier vos notes à partir de n\'importe quel point du web. Vous pouvez, en cours de consultation d\'une page que vous souhaitez mentionner, cliquez sur QuickPost pour ouvrir une fenêtre popup contenant des options Movable Type spéciales. Cette fenêtre vous permet de sélectionner le weblog dans lequel vous souhaitez publier la note, puis de la créer et de la publier.',
    'Remove Tags...' => 'Enlever les Tags...',
    '_BLOG_CONFIG_MODE_BASIC' => 'Mode basique',
    'DAILY_ADV' => 'de façon quotidienne',
    '_USAGE_PERMISSIONS_3' => 'Il existe deux façons d\'accorder ou de révoquer les privilèges d\'accès affectés aux utilisateurs. La première est de sélectionner un utilisateur parmi ceux du menu ci-dessous et de cliquer sur Modifier. La seconde est de consulter la liste de tous les auteurs, puis de sélectionner l\'auteur que vous souhaitez modifier ou supprimer.',
    'Tags to remove from selected entries' => 'Tags à enlever des notes sélectionnées',
    '_NOTIFY_REQUIRE_CONFIRMATION' => 'Un email a été envoyé à [_1]. Pour valider votre inscription, merci de cliquer sur le lien qui figure dans cet email. Il permettra de vérifier que votre adresse email est valable.',
    'Manage Notification List' => 'Gérer la liste de notification',
    'Individual' => 'Individuel',
    '_USAGE_COMMENTS_LIST_ALL_WEBLOGS' => 'Voici la liste des commentaires de tous les weblogs que vous pouvez filtrer, gérer et éditer.',
    '_USAGE_FORGOT_PASSWORD_2' => 'Ce nouveau mot de passe devrait vous permettre d\'ouvrir une session Movable Type. Vous pourrez changer ce mot de passe une fois la session ouverte.',
    '_USAGE_COMMENT' => 'Modifiez le commentaire sélectionné. Cliquez sur Enregistrer une fois les modifications apportées. Vous devrez actualiser vos fichiers pour voir les modifications reflétées sur votre site.',
    '_SEARCH_SIDEBAR' => 'Rechercher',
    '_SYSTEM_TEMPLATE_DYNAMIC_ERROR' => 'Affiché quand une erreur est rencontrée dans une page blog dynamique',
    'An error occurred processing [_1]. Check <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">here</a> for more detail and please try again.' => 'Une erreur est survenue pendant le traitement [_1]. Consultez <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">cette page</a> pour plus de détails et réessayez après.',
    'Date-Based Archive' => 'Archivage par date',
    'Unban Commenter(s)' => 'Réautoriser cet auteur de commentaires',
    'Individual Entry Archive' => 'Archivage par note',
    'Daily' => 'Quotidien',
    'Unpublish Entries' => 'Annuler publication',
    'Create a feed widget' => 'Créer un nouveau widget de flux',
    '_USAGE_UPLOAD' => 'Vous pouvez télécharger le fichier ci-dessus dans le chemin local de votre site <a href="javascript:alert(\'[_1]\')">(?)</a> ou dans le chemin des archives de votre site <a href="javascript:alert(\'[_2]\')">(?)</a>. Vous pouvez également télécharger le fichier dans un répertoire compris dans les répertoires mentionnés ci-dessus, en spécifiant le chemin dans les champs de droite (<i>images</i>, par exemple). Les répertoires qui n\'existent pas encore seront créés.',
    '_USAGE_REBUILD' => 'Vous devrez cliquer sur <a href="#" onclick="doRebuild()">Actualiser</a> pour voir les modifications reflétées sur votre site publiî',
    'Blog Administrator' => 'Administrateur Blog',
    'CATEGORY_ADV' => 'par catégorie',
    '_WARNING_PASSWORD_RESET_MULTI' => 'Vous êtes sur le point de réinitialiser le mot de passe des utilisateurs sélectionnés. Les nouveaux mots de passe sont générés automatiquement et serront envoyés directement aux utilisateurs par e-mail.\n\nEtes-vous sûr de vouloir continuer ?',
    'Dynamic Site Bootstrapper' => 'Initialisateur de site dynamique',
    '_USAGE_COMMENTS_LIST_BLOG' => 'Voici la liste des Commentaires pour [_1] que vous pouvez filtrer, gérer et éditer.',
    'Category Archive' => 'Archivage par catégorie',
    '_USAGE_EXPORT_1' => 'L\'exportation de vos notes de Movable Type vous permet de créer une <b>version de sauvegarde</b> du contenu de votre weblog. Le format des notes exportées convient à leur importation dans le système à l\'aide du mécanisme d\'importation (voir ci-dessus), ce qui vous permet, en plus d\'exporter vos notes à des fins de sauvegarde, d\'utiliser cette fonction pour <b>transférer vos notes d\'un weblog à un autre</b>.',
    '_SYSTEM_TEMPLATE_PINGS' => 'Affiché quand les PopUps de Trackbacks sont désactivés',
    'Entry Creation' => 'Création d\'une note',
    'Atom Index' => 'Index Atom',
    '_USAGE_PLACEMENTS' => 'Les outils d\'édition permettent de gérer les catégories secondaires auxquelles cette note est associée. La liste de gauche contient les catégories auxquelles cette note n\'est pas encore associée en tant que catégorie principale ou catégorie secondaire ; la liste de droite contient les catégories secondaires auxquelles cette note est associée.',
    'Adds template tags to allow you to search for content from Google. You will need to configure this plugin using a <a href=\'http://www.google.com/apis/\'>license key.</a>' => 'Ajoute des tags aux modèles qui vous permettrons de rechercher du contenu sur Google. Vous aurez besoin de configurer ce plugin avec une <a href=\'http://www.google.com/apis/\'>clé de licence</a>.',
    'Add Tags...' => 'Ajouter des Tags...',
    'This page contains a single entry from the blog posted on <strong>[_1]</strong>.' => 'Cette page contient une note postée sur on <strong>[_1]</strong>.',
    '_THROTTLED_COMMENT_EMAIL' => 'Un visiteur de votre weblog [_1] a été automatiquement bannit après avoir publié une quantité de commentaires supérieure à la limite établie au cours des [_2] secondes. Cette opération est destinée à empêcher la publication automatisée de commentaires par des scripts. L\'adresse IP bannie est

    [_3]

S\'il s\'agit d\'une erreur, vous pouvez annuler le bannissement de l\'adresse IP dans Movable Type, sous Configuration du weblog > Bannissement d\'adresses IP, et en supprimant l\'adresse IP [_4] de la liste des addresses bannies.',
    'MONTHLY_ADV' => 'par mois',
    'It can be included onto your published blog using <a href="[_1]">WidgetManager</a> or this MTInclude tag' => 'Cela peut être intégré dans votre blog en utilisant le <a href="[_1]">Gestionnaire de Widgets</a> ou grâce au tag MTInclude',
    'Manage Tags' => 'Gérer les Tags',
    '_SYSTEM_TEMPLATE_COMMENT_PREVIEW' => 'Affiché quand un auteur de commentaires consulte un aperçu de  son commentaire',
    '_USAGE_BOOKMARKLET_3' => 'Pour installer le signet QuickPost de Movable Type: déposez le lien suivant dans le menu ou la barre d\'outils des liens favoris de votre navigateur.',
    '_USAGE_PASSWORD_RESET' => 'Ci-dessous, vous pouvez réinitialiser le mot de passe pour cet utilisateur. Si vous faites cela un mot de passe généré aléatoirement sera créé et envoyé par e-mail à : [_1].',
    '_USAGE_LIST_POWER' => 'Cette liste est la liste des notes de [_1] en mode d\'édition par lots. Le formulaire ci-dessous vous permet de changer les valeurs des notes affichées ; cliquez sur le bouton Enregistrer une fois les modifications souhaitées effectuées. Les fonctions de la liste possibles avec les Notes existantes fonctionnent en mode de traitement par lots comme en mode standard.',
    'Or return to the <a href="[_1]">Main Menu</a> or <a href="[_2]">System Overview</a>.' => 'Ou retournez au <a href="[_1]">Menu Principal</a> ou à l\'<a href="[_2]">Aperçu du général du Système</a>.',
    '_ERROR_CONFIG_FILE' => 'Votre fichier configuration Movable type est absent ou ne peut pas être lu correctement. Merci de consulter la base de connaissances',
    '_WARNING_PASSWORD_RESET_SINGLE' => '_WARNING_PASSWORD_RESET_SINGLE', # Translate - Previous (5)
    '_USAGE_PING_LIST_BLOG' => 'Voici la liste des Trackbacks pour [_1]  que vous pouvez filtrer, gérer et éditer.',
    'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.' => 'StyleCatcher vous permet de naviguer facilement à travers des styles et de les appliquer à votre blog en quelques clics seulement. Pour en savoir plus à propos des styles Movable Type, ou pour avoir de nouvelles sources de styles, visitez la page <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a>.',
    'Monthly' => 'Mensuel',
    'If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the <code>import</code> folder of your Movable Type directory.' => 'If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the <code>import</code> folder of your Movable Type directory.', # Translate - New (31)
    'Tags to add to selected entries' => 'Tags à ajouter aux notes séléctionnées',
    'Ban Commenter(s)' => 'Bannir cet auteur de commentaires',
    '_USAGE_VIEW_LOG' => 'L\'erreur est enregistrée dans le <a href="#" onclick="doViewLog()">journal des activité</a>.',
    '_USAGE_BOOKMARKLET_1' => 'La configuration de la fonction QuickPost vous permet de publier vos notes en un seul clic sans même utiliser l\'interface principale de Movable Type.',
    '_USAGE_ARCHIVING_3' => 'Sélectionnez le type d\'archive auquel vous souhaitez ajouter un modèle. Sélectionnez le modèle que vous souhaitez associer à ce type d\'archive.',
    '_SYSTEM_TEMPLATE_SEARCH_TEMPLATE' => 'Visible quand un lecteur visite le weblog',
    'UTC+10' => 'UTC+10', # Translate - Previous (2)
    'INDIVIDUAL_ADV' => 'par note',
    'The above settings have been written to the file <tt>[_1]</tt>. If any of these settings are incorrect, you may click the \'Back\' button below to reconfigure them.' => 'The above settings have been written to the file <tt>[_1]</tt>. If any of these settings are incorrect, you may click the \'Back\' button below to reconfigure them.', # Translate - New (29)
    '_ERROR_CGI_PATH' => 'Votre configuration de chemin CGI est invalide ou absente de vos fichiers de configuration Movable Type. Merci de consulter la base de connaissance',
    '_SYSTEM_TEMPLATE_COMMENTS' => 'Affiché quand les commentaires en pop up sont activés',
    '_USAGE_CATEGORIES' => 'Les catégories permettent de regrouper vos notes pour en faciliter la gestion, la mise en archives et l\'affichage dans votre weblog. Vous pouvez affecter une catégorie à chaque note que vous créez ou modifiez. Pour modifier une catégorie existante, cliquez sur son titre. Pour créer une sous-catégorie, cliquez sur le bouton Créer correspondant. Pour déplacer une catégorie, cliquez sur le bouton Déplacer correspondant.',
    'Master Archive Index' => 'Index principal des archives',
    'Weekly' => 'Hebdomadaire',
    'Unpublish TrackBack(s)' => 'TrackBack(s) non publié(s)',
    'Many more can be found on the <a href="[_1]">main index page</a> or by looking through <a href="[_2]">the archives</a>.' => 'Beaucoup d\'autres peuvent être trouvés sur la page <a href="[_1]">d\'accueil principale</a> ou en cherchant dans <a href="[_2]">les archives</a>.',
    '_USAGE_PREFS' => 'Cet écran vous permet de définir un grand nombre des paramètres de votre weblog, de vos archives, des commentaires et de communication de notifications. Ces paramètres ont tous des valeurs par défaut raisonnables lors de la création d\'un nouveau weblog.',
    'WEEKLY_ADV' => 'hebdomadaire',
    '_SYSTEM_TEMPLATE_COMMENT_PENDING' => 'Visible quand un auteur de commentaires fait un aperçu de son commentaire',
    'Unpublish Comment(s)' => 'Annuler publication commentaire(s)',
    'The next post in this blog is <a href="[_1]">[_2]</a>.' => 'La note suivante de ce blog est <a href="[_1]">[_2]</a>.',
    '_USAGE_ENTRY_LIST_OVERVIEW' => 'Voici la liste des notes de tous les weblogs que vous pouvez filtrer, gérer et éditer.',
    'Please enter the parameters necessary for connecting to your database.If your database type is not listed in the dropdown below, you may be missing the Perl module necessary to connect to your database.  If this is the case, please check your installation and click <a href="?__mode=configure">here</a> to re-test your installation.' => 'Please enter the parameters necessary for connecting to your database.If your database type is not listed in the dropdown below, you may be missing the Perl module necessary to connect to your database.  If this is the case, please check your installation and click <a href="?__mode=configure">here</a> to re-test your installation.', # Translate - New (55)
    'Drag and drop the widgets you want into the <strong>Installed</strong> column.' => 'Drag and drop the widgets you want into the <strong>Installed</strong> column.', # Translate - New (13)
    'Manage Categories' => 'Gérer les Catégories',
    '_USAGE_ARCHIVING_2' => 'Lorsque vous associez plusieurs modèles à un type d\'archive particulier -- ou même lorsque vous n\'en associez qu\'un seul -- vous pouvez personnaliser le chemin des fichiers d\'archive à l\'aide des modèles correspondants.',
    'UTC+11' => 'UTC+11', # Translate - Previous (2)
    'View Activity Log For This Weblog' => 'Voir le journal d\'activité pour ce weblog',
    'Refresh Template(s)' => 'Refresh Template(s)', # Translate - New (3)
    '_USAGE_NOTIFICATIONS' => 'Les personnes suivantes souhaitent être averties de la publication d\'une nouvelle note sur votre site. Vous pouvez ajouter un utilisateur en indiquant son adresse e-mail dans le formulaire suivant. L\'adresse URL est facultative. Pour supprimer un utilisateur, cochez la case Supprimer dans le tableau ci-dessous, puis cliquez sur le bouton Supprimer.',
    '_USAGE_COMMENTERS_LIST' => 'Cette liste est la liste des auteurs de commentaires pour [_1].',
    '_ERROR_DATABASE_CONNECTION' => 'Les paramètres de votre base de données sont soit invalides, absents ou ne peuvent pas être lus correctement. Consultez la base de connaissances pour plus d\'informations.',
    '_USAGE_BANLIST' => 'Cette liste est la liste des adresses IP qui ne sont pas autorisées à publier de commentaires ou envoyer des pings TrackBack à votre site. Vous pouvez ajouter une nouvelle adresse IP dans le formulaire suivant. Pour supprimer une adresse de la liste des adresses IP bannies, cochez la case Supprimer dans le tableau ci-dessous, puis cliquez sur le bouton Supprimer.',
    'RSS 2.0 Index' => 'Index RSS 2.0',
    '_USAGE_FEEDBACK_PREFS' => 'Cette page vous permet de configurer les manières dont un lecteur peut contribuer sur votre weblog',
    '_USAGE_AUTHORS' => 'Cette liste est la liste de tous les utilisateurs du système Movable Type. Vous pouvez changer les droits accordés à un auteur en cliquant sur son nom et supprimer un auteur en cochant la case adéquate, puis en cliquant sur <b>Supprimer</b>. Remarque : si vous ne souhaitez supprimer un auteur que d\'un weblog spécifique, il vous suffit de changer les droits qui lui sont accordés ; la suppression d\'un auteur affecte tout le système.',
    '_INDEX_INTRO' => '<p>Si vous ninstallez Movable Type, il vous sera certainement utile de consulter <a href="http://www.sixapart.com/movabletype/docs/mtinstall.html">la documentation d\'installation</a> et <a rel="nofollow" href="mt-check.cgi">le système de vérification de Movable Type</a> pour vérifier que votre système est conforme.</p>',
    'Configure Weblog' => 'Configurer le Weblog',
    'Select a Design using StyleCatcher' => 'Sélectionner un  habillage via StyleCatcher',
    '_USAGE_NEW_AUTHOR' => ' A partir de cette page vous pouvez créer de nouveaux auteurs dans le système et définir leurs accès dans les weblogs',
    'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides.' => 'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides.', # Translate - New (31)
    '_USAGE_FORGOT_PASSWORD_1' => 'Vous avez demandé à récupérer votre mot de passe Movable Type. Votre mot de passe a été changé au niveau du système ; le nouveau mot de passe est le suivant:',
    '_USAGE_COMMENTS_LIST_OVERVIEW' => 'Voici la liste des commentaires de tous vos weblogs, que vous pouvez filtrer, gérer et éditer',
    '_SYSTEM_TEMPLATE_POPUP_IMAGE' => 'Affiché quand un visiteur clique sur une image Pop up',
    '_USAGE_EXPORT_2' => 'Pour exporter vos notes: cliquez sur le lien ci-dessous (Exporter les notes de [_1]). Pour enregistrer les données exportées dans un fichier, vous pouvez enfoncer la touche <code>option</code> (Macintosh) ou <code>Maj</code> (Windows) et la maintenir enfoncée tout en cliquant sur le lien. Vous pouvez également sélectionner toutes les données et les copier dans un autre document. <a href="#" onclick="openManual(\'importing\', \'export_ie\');return false;">Vous exportez des données depuis Internet Explorer ?</a>',
    '_USAGE_PING_LIST_ALL_WEBLOGS' => 'Voici une liste de Ping de Trackback de tous les weblogs que vous pouvez filtrer, gérer et éditer.',
    'Manage my Widgets' => 'Gérer mes Widgets',
    'Publish Entries' => 'Publier les notes',
    '_USAGE_PING_LIST_OVERVIEW' => 'Voici la liste des Trackbacks de tous vos weblogs que vous pouvez filtrer, gérer et éditer',
    'AUTO DETECT' => 'DETECTION AUTOMATIQUE',
    '<em><strong>Please Note:</strong> The Movable Type export format is not comprehensive and is not suitable for creating full-fidelity backups. Please see the Movable Type manual for full details.</em>' => '<em><strong>Please Note:</strong> The Movable Type export format is not comprehensive and is not suitable for creating full-fidelity backups. Please see the Movable Type manual for full details.</em>', # Translate - New (32)
    'Install <a href=\'http://greasemonkey.mozdev.org/\'>GreaseMonkey</a>' => 'Installer <a href=\'http://greasemonkey.mozdev.org/\'>GreaseMonkey</a>',
    '_USAGE_PLUGINS' => 'Voici la liste de tous les plugins actuellement enregistrés avec Movable type.',
    '_USAGE_PERMISSIONS_2' => 'Vous pouvez modifier les permissions affectées à un utilisateur en sélectionnant ce dernier dans le menu déroulant, puis en cliquant sur Modifier.',
    'Untrust Commenter(s)' => 'Retirer le statut fiable à cet auteur de commentaires',
    '_USAGE_PROFILE' => 'Cet espace permet de changer votre profil d\'auteur. Les modifications apportées à votre nom d\'utilisateur et à votre mot de passe sont automatiquement mises à jour. En d\'autres termes, vous devrez ouvrir une nouvelle session.',
    'Congratulations! A template module Widget named <strong>[_1]</strong> has been created which you can further <a href="[_2]">edit</a> to customize its display.' => 'Félicitations ! Un modèle de Widget nommé <strong>[_1]</strong> a bien été créé, vous pouvez le <a href="[_2]">modifier</a> ultérieurement pour personnaliser son affichage.',
    'Category' => 'Catégorie',
    '_USAGE_ENTRYPREFS' => 'La configuration des champs détermine les champs de saisie qui apparaîtront dans les écrans de création et de modification des notes. Vous pouvez sélectionner une configuration existante (basique ou avancée), ou personnaliser vos écrans en activant le bouton Personnalisée, puis en sélectionnant les champs que vous souhaitez voir apparaître.',
    'To download more plugins, check out the <a href="http://www.sixapart.com/pronet/plugins/">Six Apart Plugin Directory</a>.' => 'Pour télécharger plus de plugins, visitez la page <a href="http://www.sixapart.com/pronet/plugins/">Six Apart Plugin Directory</a>.',
    'Stylesheet' => 'Feuille de style',
    'RSD' => 'RSD', # Translate - Previous (1)
    '_USAGE_ARCHIVE_MAPS' => 'Cette fonctionnalité avancée vous permet de faire correspondre un modèle d\'archives à plusieurs types d\'archives. Par exemple, vous pouvez decider de créer deux vues différentes pour vos archives mensuelles : une pour les notes d\'un mois donné, présentées en liste, une autre affichant les notes sur un calendrier mensuel.',
    '_THROTTLED_COMMENT' => 'Dans le but de réduire les possibilités d\'abus, j\'ai activé une fonction obligeant les auteurs de commentaires à attendre quelques instants avant de publier un autre commentaire. Veuillez attendre quelques instants avant de publier un autre commentaire. Merci.',
    'Trust Commenter(s)' => 'Donner statut fiable à cet auteur de commentaires',
    '_USAGE_SEARCH' => 'Vous pouvez utiliser l\'outil de recherche et de remplacement pour effectuer des recherches dans vos notes ou pour remplacer chaque occurrence d\'un mot, d\'une phrase ou d\'un caractère par un autre. Important: faites preuve de prudence, car <b>il n\'existe pas de fonction d\'annulation</b>. Nous vous recommandons même d\'exporter vos notes Movable Type avant, juste au cas où.',
    'Manage Templates' => 'Gérer les Modèles',
    '_USAGE_PERMISSIONS_1' => 'Vous à êtes en train de modifier les droits de <b>[_1]</b>. Vous trouverez ci-dessous la liste des weblogs pour lesquels vous pouvez contrôler les auteurs ; pour chaque weblog de la liste, vous pouvez affecter des droits à <b>[_1]</b> en cochant les cases correspondant aux options souhaitées.',
    '_USAGE_BOOKMARKLET_2' => 'La structure de la fonction QuickPost de Movable Type vous permet de personnaliser la mise en page et les champs de votre page QuickPost. Par exemple, vous pouvez ajouter une option d\'ajout d\'extraits par l\'intermédiaire de la fenêtre QuickPost. Une fenêtre QuickPost comprend, par défaut, les éléments suivants: un menu déroulant permettant de sélectionner le weblog dans lequel publier la note ; un menu déroulant permettant de sélectionner l\'état de publication (brouillon ou publié) de la nouvelle note ; un champ de saisie du titre de la note ; et un champ de saisie du corps de la note.',
    '_external_link_target' => '_haut',
    '_AUTO' => '1',
    'Add/Manage Categories' => 'Ajouter/Gérer des Categories',
    'Recover Password(s)' => 'Recover Password(s)', # Translate - New (3)
    '_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.org/sitefr/">Movable Type <$MTVersion$></a>',
    '_USAGE_ARCHIVING_1' => 'Sélectionnez les fréquences/types de mise en archives du contenu de votre site. Vous pouvez, pour chaque type de mise en archives que vous choisissez, affecter plusieurs modèles devant être appliqués. Par exemple, vous pouvez créer deux affichages différents de vos archives mensuelles: un contenant les notes d\'un mois particulier et l\'autre présentant les notes dans un calendrier.',
    '_USAGE_PERMISSIONS_4' => 'Chaque weblog peut être utilisé par plusieurs auteurs. Pour ajouter un auteur, vous entrerez les informations correspondantes dans les formulaires ci-dessous. Sélectionnez ensuite les weblogs dans lesquels l\'auteur pourra travailler. Vous pourrez modifier les droits accordés à l\'auteur une fois ce dernier enregistré dans le système.',
    '_USAGE_TAGS' => 'Utilisez les tags pour grouper vos notes sous un même mot clef ce qui vous permettra de les retrouver plus facilement',
    '_USAGE_BOOKMARKLET_5' => 'Vous pouvez également, si vous utilisez Internet Explorer sous Windows, installer une option QuickPost dans le menu contextuel (clic droit) de Windows. Cliquez sur le lien ci-dessous et acceptez le message affiché pour ouvrir le fichier. Fermez et redémarrez votre navigateur pour ajouter le menu au système.',
    '_USAGE_IMPORT' => 'Vous pouvez utiliser le mécanisme d\'importation de notes pour importer vos notes d\'un autre système de gestion de weblog (Blogger ou Greymatter, par exemple). Ce mode d\'emploi contient des instructions complètes pour l\'importation de vos notes; le formulaire suivant vous permet d\'importer tout un lot de notes déjC  exportées d\'un autre système, et d\'enregistrer les fichiers de façon à pouvoir les utiliser dans Movable Type. Consultez le mode d\'emploi avant d\'utiliser ce formulaire de façon à sélectionner les options adéquates.',
    'Main Index' => 'Index principal',
    '_USAGE_ENTRY_LIST_BLOG' => 'Voici la liste des notes pour [_1] que vous pouver filtrer, gérer et éditer.',
    '<p>You must define a global theme repository where themes can be stored locally.  If a particular blog has not been configured for it\'s own theme paths, it will use these settings directly. If a blog has it\'s own theme paths, then the theme will be copied to that location when applied to that weblog. The paths defined here must physically exist and be writable by the webserver.</p>' => '<p>You must define a global theme repository where themes can be stored locally.  If a particular blog has not been configured for it\'s own theme paths, it will use these settings directly. If a blog has it\'s own theme paths, then the theme will be copied to that location when applied to that weblog. The paths defined here must physically exist and be writable by the webserver.</p>', # Translate - New (72)
    '_USAGE_EXPORT_3' => 'Le lien suivant entraîne l\'exportation de toutes les notes de votre weblog vers le serveur Tangent. Il s\'agit généralement d\'une opération ponctuelle, réalisée à la suite de l\'installation du module Tangent pour Movable Type.',
    'Send Notifications' => 'Envoyer des notifications',
    '_SYSTEM_TEMPLATE_COMMENT_ERROR' => 'Affiché quand un commentaire ne peut être validé',
    'Edit All Entries' => 'Modifier toutes les notes',
    'Rebuild Files' => 'Reconstruire les fichiers',

    ## Error messages, strings in the app code.

    ## ./mt-check.cgi.pre
    'CGI is required for all Movable Type application functionality.' => 'CGI est requis pour toutes les fonctionnalités de l\'application Movable Type.',
    'HTML::Template is required for all Movable Type application functionality.' => 'HTML::Template est requis pour toutes les fonctionnalités de l\'application Movable Type.',
    'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size est requis pour les uploads de fichiers (pour déterminer la taille des images uploadées dans plusieurs formats différents).',
    'File::Spec is required for path manipulation across operating systems.' => 'File::Spec est requis pour la manipulation du chemin (path) à travers les systèmes d\'exploitation.',
    'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie est requis pour l\'authentication du cookie.',
    'DB_File is required if you want to use the Berkeley DB/DB_File backend.' => 'DB_File est requis si vous souhaitez utiliser le backend DB/DB_File de Berkeley.',
    'DBI is required if you want to use any of the SQL database drivers.' => 'DBI est nécessaire pour utiliser les drivers SQL de la base de données.',
    'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI et DBD::mysql sont requis si vous souhaitez utiliser la base de données MySQL.',
    'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI et DBD::Pg sont requis si vous souhaitez utiliser la base de données PostgreSQL.',
    'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI et DBD::SQLite sont requis si vous souhaitez utiliser la base de données SQLite.',
    'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI et DBD::SQLite2 sont requis si vous souhaitez utiliser SQLite 2.x comme base de données.',
    'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in mt.cfg.' => 'HTML::Entities est requis pour encoder certains caractères, mais cette fonction peut être coupée si vous utilisez l\'option NoHTMLEntities dans mt.cfg.',
    'LWP::UserAgent is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'LWP::UserAgent est optionel; Cette fonction est nécessaire si vous souhaitez utiliser le système de TrackBack, le ping sur weblogs.com, ou le ping des derniers sites MT mis à jour.',
    'SOAP::Lite is optional; It is needed if you wish to use the MT XML-RPC server implementation.' => 'SOAP::Lite n\'est pas obligatoire; il est requis si vous souhaitez utiliser l\'implémentation du serveur MT XML-RPC.',
    'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Temp n\'est pas obligatoire; il est requis si vous souhaitez pouvoir écraser des fichiers déjà existants quand vous uploadez.',
    'Image::Magick is optional; It is needed if you would like to be able to create thumbnails of uploaded images.' => 'Image::Magick n\'est pas obligatoire; il est requis si vous souhaitez pouvoir créer des thumbnails des images uploadées.',
    'Storable is optional; it is required by certain MT plugins available from third parties.' => 'Storable n\'est pas obligatoire; il est requis par certains plugins de MT disponibles à partir de la troisième partie.',
    'Crypt::DSA is optional; if it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSA n\'est pas obligatoire; s\'il est installé, l\'autentification lors des commentaires sera plus rapide.',
    'MIME::Base64 is required in order to enable comment registration.' => 'MIME::Base64 est nécessaire afin de permettre l\'enregistrement des commentaires.',
    'XML::Atom is required in order to use the Atom API.' => 'XML::Atom est nécessaire pour utiliser l\'API Atom.',
    'Data Storage' => 'Stockage des données',
    'Required' => 'Requis',
    'Optional' => 'Optionnels',

    ## ./extras/examples/plugins/mirror/lib/Mirror.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample.pm
    'This is localized in perl module' => 'Ceci est localisé dans le module perl',

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N/ja.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N/en_us.pm

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

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/ja.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/en_us.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher.pm
    'StyleCatcher must first be configured system-wide before it can be used.' => 'StyleCatcher doit être configuré avant de pouvoir être utilisé.',
    'Configure plugin' => 'Configurer le plugin',
    'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Impossible de créer le dossier [_1] - Vérifiez que votre dossier \'themes\' et en mode webserveur/écriture.',
    'Successfully applied new theme selection.' => 'Sélection de nouveau Thème appliquée avec succès.',

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/ja.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/en_us.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/Plugin.pm
    'Can\'t find included template module \'[_1]\'' => 'Impossible de trouver le module de modèle inclus \'[_1]\'',

    ## ./plugins/WidgetManager/lib/WidgetManager/Util.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/App.pm
    'Loading template \'[_1]\' failed: [_2]' => 'Echec lors du chargement du modèle \'[_1]\': [_2]',
    'Permission denied.' => 'Permission refusée.',
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
    'You did not select any [_1] to delete.' => 'Vous n\'avez pas sélectionné de [_1] à effacer.',
    'Are you sure you want to delete this [_1]?' => 'Êtes-vous sûr de vouloir supprimer ce(tte) [_1] ?',
    'Are you sure you want to delete the [_1] selected [_2]?' => 'Êtes-vous sûr de vouloir supprimer les [_1] sélectionné(e)s [_2] ?',
    'to delete' => 'à effacer',
    'You did not select any [_1] [_2].' => 'Vous n\'avez pas sélectionné de [_1] [_2].',
    'You must select an action.' => 'Vous devez sélectionner une action.',
    'to mark as junk' => 'pour marquer indésirable',
    'to remove "junk" status' => 'pour retirer le statut "indésirable"',
    'Enter email address:' => 'Saisissez l\'adresse email :',
    'Enter URL:' => 'Saisissez l\'URL :',

    ## ./lib/MT.pm
    'Message: [_1]' => 'Message : [_1]',
    'Unnamed plugin' => 'Plugin sans nom',
    '[_1] died with: [_2]' => '[_1] mort avec: [_2]',
    'Plugin error: [_1] [_2]' => 'Erreur Plugin: [_1] [_2]',

    ## ./lib/MT/Comment.pm
    'Load of entry \'[_1]\' failed: [_2]' => 'Le chargement de la note \'[_1]\' a échoué : [_2]',
    'Load of blog \'[_1]\' failed: [_2]' => 'Le chargement du blog \'[_1]\' a échoué : [_2]',

    ## ./lib/MT/Author.pm
    'Can\'t approve/ban non-COMMENTER author' => 'Un auteur non commentateur ne peut pas être approuvé ou banni',
    'The approval could not be committed: [_1]' => 'L\'aprobation ne peut être réalisée : [_1]',

    ## ./lib/MT/TemplateMap.pm

    ## ./lib/MT/Bootstrap.pm
    'Got an error: [_1]' => 'Erreur de type : [_1]',

    ## ./lib/MT/Callback.pm

    ## ./lib/MT/Serialize.pm

    ## ./lib/MT/Permission.pm

    ## ./lib/MT/WeblogPublisher.pm
    'Archive type \'[_1]\' is not a chosen archive type' => 'Le Type d\'archive\'[_1]\' n\'est pas un type d\'archive sélectionné',
    'Parameter \'[_1]\' is required' => 'Le Paramètre \'[_1]\' est requis',
    'Building category archives, but no category provided.' => 'Construction des archives de catégorie, mais aucune catégorie n\'a été fournie.',
    'You did not set your Local Archive Path' => 'Vous n\'avez pas spécifié votre chemin local des Archives',
    'Building category \'[_1]\' failed: [_2]' => 'La construction de la catégorie\'[_1]\' a échoué : [_2]',
    'Building entry \'[_1]\' failed: [_2]' => 'La construction de la note \'[_1]\' a échoué : [_2]',
    'Building date-based archive \'[_1]\' failed: [_2]' => 'La construction des archives de la base de données \'[_1]\' a échoué : [_2]',
    'You did not set your Local Site Path' => 'Vous n\'avez pas spécifié votre chemin local du Site',
    'Template \'[_1]\' does not have an Output File.' => 'Le modèle \'[_1]\' n\'a pas de fichier de sortie.',
    'An error occurred while rebuilding to publish scheduled posts: [_1]' => 'Un erreur est intervenue pendant la reconstruction pour publier les notes futures : [_1]',

    ## ./lib/MT/Session.pm

    ## ./lib/MT/Sanitize.pm

    ## ./lib/MT/TaskMgr.pm
    'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'Impossible d\'assurer le vérrouillage pour l\'éxécution de tâches système. Vérifiez que la zone TempDir ([_1]) est en mode écriture.',
    'Error during task \'[_1]\': [_2]' => 'Erreur pendant la tâche \'[_1]\' : [_2]',
    'Scheduled Tasks Update' => 'Scheduled Tasks Update', # Translate - New (3)
    'The following tasks were run:' => 'Les tâches suivantes ont été exécutées :',

    ## ./lib/MT/IPBanList.pm

    ## ./lib/MT/FileMgr.pm

    ## ./lib/MT/Category.pm
    'Categories must exist within the same blog' => 'Les categories doivent exister au sein du même blog ',
    'Category loop detected' => 'Loop de catégorie détecté',

    ## ./lib/MT/ErrorHandler.pm

    ## ./lib/MT/ObjectDriver.pm

    ## ./lib/MT/Object.pm
    '4th argument to add_callback must be a perl CODE reference' => 'Le 4ème argument de add_callback doit être une référence CODE perl',

    ## ./lib/MT/Upgrade.pm
    'Invalid upgrade function: [_1].' => 'Fonction de mise à jour invalide : [_1].',
    'Error loading class: [_1].' => 'Erreur de chargement de classe : [_1].',
    'Creating initial weblog and author records...' => 'Création du weblog initial et des informations auteur...',
    'Error saving record: [_1].' => 'Erreur de l\'enregistrement des informations : [_1].',
    'First Weblog' => 'Premier Weblog',
    'Can\'t find default template list; where is \'default-templates.pl\'? Error: [_1]' => 'Impossible de trouver la liste de modèles par défaut; où se trouve \'default-templates.pl\'? Erreur : [_1]',
    'Creating new template: \'[_1]\'.' => 'Creation d\'un nouveau modèle: \'[_1]\'.',
    'Mapping templates to blog archive types...' => 'Mapping des habillages vers les archives des blogs...',
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

    ## ./lib/MT/DateTime.pm

    ## ./lib/MT/TBPing.pm

    ## ./lib/MT/DefaultTemplates.pm

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
    'Creating new author (\'[_1]\')...' => 'Creation d\'un nouvel auteur (\'[_1]\')...',
    'ok\n' => 'ok\n', # Translate - Previous (2)
    'failed\n' => 'échoué\n',
    'Saving author failed: [_1]' => 'Echec lors de la sauvegarde de l\'Auteur : [_1]',
    'Assigning permissions for new author...' => 'Mise en place d\'autorisation pour un nouvel auteur...',
    'Saving permission failed: [_1]' => 'Echec lors de la sauvegarde des Droits des Auteurs : [_1]',
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
    'Config directive [_1] without value at [_2] line [_3]' => 'Config directive [_1] sans valeur sur [_2] ligne [_3]',
    'No such config variable \'[_1]\'' => 'Pas de variable de configuration de ce type \'[_1]\'',

    ## ./lib/MT/XMLRPCServer.pm
    'Invalid timestamp format' => 'Format de date invalide',
    'No web services password assigned.  Please see your author profile to set it.' => 'Aucun mot de passe associé au service web. Merci de vérifier votre profil Auteur pour le définir.',
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
    'Author does not have privileges' => 'L\'auteur n\'est pas détenteur de droits',
    'Not privileged to set entry categories' => 'Pas détenteur de droit pour choisir la catégorie d\'une Note',
    'Publish failed: [_1]' => 'Echec de la publication : [_1]',
    'Not privileged to upload files' => 'Pas détenteur de droit pour télécharger des fichiers',
    'No filename provided' => 'Aucun nom de fichier',
    'Invalid filename \'[_1]\'' => 'Nom de fichier invalide \'[_1]\'',
    'Error making path \'[_1]\': [_2]' => 'Erreur dans le chemin \'[_1]\' : [_2]',
    'Error writing uploaded file: [_1]' => 'Erreur écriture fichier téléchargé : [_1]',
    'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Les méthodes d\'habillage ne sont pas implémentée en raison d\'une différence entre l\'API Blogger et l\'API Movable Type.',

    ## ./lib/MT/App.pm
    'Error loading [_1]: [_2]' => 'Erreur au chargement [_1] : [_2]',
    'Failed login attempt by unknown user \'[_1]\'' => 'Failed login attempt by unknown user \'[_1]\'', # Translate - New (7)
    'Failed login attempt with incorrect password by user \'[_1]\' (ID: [_2])' => 'Failed login attempt with incorrect password by user \'[_1]\' (ID: [_2])', # Translate - New (11)
    'User \'[_1]\' (ID:[_2]) logged in successfully' => 'User \'[_1]\' (ID:[_2]) logged in successfully', # Translate - New (7)
    'Invalid login.' => 'Identifiant invalide.',
    'User \'[_1]\' (ID:[_2]) logged out' => 'User \'[_1]\' (ID:[_2]) logged out', # Translate - New (6)
    'The file you uploaded is too large.' => 'Le fichier que vous souhaitez envoyer est trop lourd.',
    'Unknown action [_1]' => 'Action inconnue [_1]',

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

    ## ./lib/MT/Template/ContextHandlers.pm
    'Can\'t find included file \'[_1]\'' => 'Impossible de trouver le fichier inclus \'[_1]\'',
    'Error opening included file \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture du fichier inclus \'[_1]\' : [_2]',
    'Unspecified archive template' => 'Habillage d\'archive non spécifié',
    'Error in file template: [_1]' => 'Erreur dans fichier habillage : [_1]',
    'Can\'t find template \'[_1]\'' => 'Impossible de trouver le modèle \'[_1]\'',
    'Can\'t find entry \'[_1]\'' => 'Impossible de trouver la note \'[_1]\'',
    '[_1] [_2]' => '[_1] [_2]', # Translate - Previous (3)
    'You used a [_1] tag without any arguments.' => 'Vous utilisez un [_1] tag sans aucun argument.',
    'You have an error in your \'category\' attribute: [_1]' => 'Vous avez une erreur dans votre attribut \'catégorie\' : [_1]',
    'You have an error in your \'tag\' attribute: [_1]' => 'Vous avez une erreur dans votre attribut \'tag\': [_1]',
    'No such author \'[_1]\'' => 'L\'auteur \'[_1]\' n\'existe pas',
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

    ## ./lib/MT/Plugin/L10N.pm

    ## ./lib/MT/Plugin/JunkFilter.pm
    'from rule' => 'de la règle',
    'from test' => 'du test',

    ## ./lib/MT/App/Viewer.pm
    'This is an experimental feature; turn off SafeMode (in mt.cfg) in order to use it.' => 'C\'est une fonctionnalité encore à l\'essai; Désactivez le  SafeMode (dans mt.cfg) pour pouvoir l\'utiliser.',
    'Not allowed to view blog [_1]' => 'Non autorisé à voir ce blog [_1]',
    'Loading blog with ID [_1] failed' => 'Echec du chargement du blog avec ID [_1] ',
    'Can\'t load \'[_1]\' template.' => 'Impossible de charger l\'habillage \'[_1]\' .',
    'Building template failed: [_1]' => 'Echec de la construction de l\'habillage: [_1]',
    'Invalid date spec' => 'Spec de date incorrects',
    'Can\'t load template [_1]' => 'Impossible de charge l\'habillage [_1]',
    'Building archive failed: [_1]' => 'Echec de la construction des archives: [_1]',
    'Invalid entry ID [_1]' => ' ID [_1] de la note incorrect',
    'Entry [_1] is not published' => 'La note [_1] n\'est pas publiée',
    'Invalid category ID \'[_1]\'' => 'ID catégorie incorrect \'[_1]\'',

    ## ./lib/MT/App/NotifyList.pm
    'Please enter a valid email address.' => 'Veuillez entrer une adresse e-mail valide.',
    'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Il manque un paramètre requis : blog_id. Veuillez consulter le manuel d\'utilisateur pour configurer les notifications.',
    'Email notifications have not been configured! The weblog owner needs to set the EmailVerificationSecret configuration variable in mt.cfg.' => 'L\'avis par e-mail n\'a pas été configuré ! Le webmaster de la plateforme doit mettre la variable de configuration EmailVerificationSecret dans mt.cfg.',
    'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Vous avez fourni un paramètre de redirection non valide. Le propriétaire du weblog doit spécifier le chemin qui correspond au nom de domaine du weblog.',
    'The email address \'[_1]\' is already in the notification list for this weblog.' => 'L\'adresse e-mail \'[_1]\' fait déjà parti de la liste de notification pour ce weblog.',
    'Please verify your email to subscribe' => 'Merci de vérifier votre email pour souscrire',
    'The address [_1] was not subscribed.' => 'L\'adresse [_1] n\'a pas été souscrite.',
    'The address [_1] has been unsubscribed.' => 'L\'adresse [_1] a été supprimée.',

    ## ./lib/MT/App/Search.pm
    'You are currently performing a search. Please wait ' => 'Une recherche est actuellement en cours. Merci de patienter ',
    'Search failed. Invalid pattern given: [_1]' => 'Echec de la recherche. Comportement non valide : [_1]',
    'Search failed: [_1]' => 'Echec lors de la recherche : [_1]',
    'No alternate template is specified for the Template \'[_1]\'' => 'Pas d\'habillage alternatif spécifié pour l\'habillage \'[_1]\'',
    'Opening local file \'[_1]\' failed: [_2]' => 'L\'ouverture du fichier local \'[_1]\' a échoué: [_2]',
    'Building results failed: [_1]' => 'Echec lors de la construction des résultats: [_1]',
    'Search: query for \'[_1]\'' => 'Recherche : requête pour \'[_1]\'',
    'Search: new comment search' => 'Recherche : recherche de nouveaux commentaires',

    ## ./lib/MT/App/Upgrader.pm
    'The initial account name is required.' => 'Le nom initial du compte est nécessaire.',
    'You failed to validate your password.' => 'Echec de la validation du mot de passe.',
    'You failed to supply a password.' => 'Vous n\'avez pas donné de mot de passe.',
    'The value you entered was not a valid email address' => 'Vous devez saisir une adresse e-mail valide',
    'Password recovery word/phrase is required.' => 'La phrase de récupération de mot de passe est requise.',
    'User \'[_1]\' upgraded database to version [_2]' => 'User \'[_1]\' upgraded database to version [_2]', # Translate - New (7)
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
    'TrackBack on category \'[_1]\' (ID:[_2]).' => 'TrackBack on category \'[_1]\' (ID:[_2]).', # Translate - New (6)
    'Rebuild failed: [_1]' => 'Echec lors de la recontruction: [_1]',
    'Can\'t create RSS feed \'[_1]\': ' => 'Can\'t create RSS feed \'[_1]\': ', # Translate - New (6)
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
    'Comment on "[_1]" by [_2].' => 'Comment on "[_1]" by [_2].', # Translate - New (5)
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
    'Sendmail' => 'Envoyer d\'email',
    'Test email from Movable Type Configuration Wizard' => 'E-mail de test de l\'assistant de configuration Movable Type',
    'This is the test email sent by your new installation of Movable Type.' => 'Ceci est un e-mail de test envoyé par votre nouvelle installation Movable Type.',

    ## ./lib/MT/App/ActivityFeeds.pm
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
    'No permissions' => 'Aucun Droit',
    'Invalid blog' => 'Blog incorrect',
    'Convert Line Breaks' => 'Conversion retours ligne',
    'Invalid author_id' => 'auteur_id incorrect',
    'Invalid username \'[_1]\' in password recovery attempt' => 'Invalid username \'[_1]\' in password recovery attempt', # Translate - New (7)
    'Username or password recovery phrase is incorrect.' => 'Username or password recovery phrase is incorrect.', # Translate - New (7)
    'Password recovery for user \'[_1]\' failed due to lack of recovery phrase specified in profile.' => 'Password recovery for user \'[_1]\' failed due to lack of recovery phrase specified in profile.', # Translate - New (15)
    'No password recovery phrase set in user profile. Please see your system administrator for password recovery.' => 'No password recovery phrase set in user profile. Please see your system administrator for password recovery.', # Translate - New (16)
    'Invalid attempt to recover password (used recovery phrase \'[_1]\')' => 'Invalid attempt to recover password (used recovery phrase \'[_1]\')', # Translate - New (9)
    'Password recovery for user \'[_1]\' failed due to lack of email specified in profile.' => 'Password recovery for user \'[_1]\' failed due to lack of email specified in profile.', # Translate - New (14)
    'No email specified in user profile.  Please see your system administrator for password recovery.' => 'No email specified in user profile.  Please see your system administrator for password recovery.', # Translate - New (14)
    'Password was reset for user \'[_1]\' (ID:[_2]) and sent to address: [_3]' => 'Password was reset for user \'[_1]\' (ID:[_2]) and sent to address: [_3]', # Translate - New (13)
    'Error sending mail ([_1]); please fix the problem, then ' => 'Erreur lors de l\'envoi de l\'e-mail ([_1]); veuillez résoudre le problème puis ',
    'Invalid type' => 'Type incorrect',
    'No such tag' => 'Pas de Tag de ce type',
    'You are not authorized to log in to this blog.' => 'Vous n\'êtes pas autorisé à vous connecter sur ce weblog.',
    'No such blog [_1]' => 'Aucun weblog ne porte le nom [_1]',
    'Weblog Activity Feed' => 'Flux d\'activité du weblog',
    '(author deleted)' => '(auteur effacé)',
    'All Feedback' => 'Tous les retours lecteurs',
    'log records' => 'entrées du journal',
    'System Activity Feed' => 'Flux d\'activité du système',
    'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'', # Translate - New (10)
    'Activity log reset by \'[_1]\'' => 'Activity log reset by \'[_1]\'', # Translate - New (5)
    'Import/Export' => 'Importer / Exporter',
    'Invalid blog id [_1].' => 'ID du blog invalide [_1].',
    'Invalid parameter' => 'Paramètre Invalide',
    'Load failed: [_1]' => 'Echec de chargement : [_1]',
    '(no reason given)' => '(sans raison donnée)',
    '(untitled)' => '(sans titre)',
    'Create template requires type' => 'La création d\'habillages nécessite un type',
    'New Template' => 'Nouveau modèle',
    'New Weblog' => 'Nouveau weblog',
    'Author requires username' => 'Un nom d\'utilisateur est nécessaire pour l\'auteur',
    'Author requires password' => 'L\'auteur a besoin d\'un mot de passe',
    'Author requires password recovery word/phrase' => 'L\'auteur demande la phrase de récupération de mot de passe',
    'Email Address is required for password recovery' => 'L\'adresse email est nécessaire pour récupérer le mot de passe',
    'The e-mail address you entered is already on the Notification List for this weblog.' => 'L\'adresse e-mail que vous avez entrée fait déjà parti de la liste de notification de ce weblog.',
    'You did not enter an IP address to ban.' => 'Vous devez saisir une adresse IP à bannir.',
    'The IP you entered is already banned for this weblog.' => 'L\'adresse IP que vous avez entrée a été bannie de ce weblog.',
    'You did not specify a weblog name.' => 'Vous devez  spécifier un nom de weblog.',
    'Site URL must be an absolute URL.' => 'L\'URL du site doit être une URL absolue.',
    'Archive URL must be an absolute URL.' => 'Les URL d\'archive doivent être des URL absolues.',
    'The name \'[_1]\' is too long!' => 'Le nom \'[_1]\' est trop long.',
    'Category \'[_1]\' created by \'[_2]\'' => 'Category \'[_1]\' created by \'[_2]\'', # Translate - New (5)
    'The category label \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Le nom de catégorie \'[_1]\' est en conflit avec une autre catégorie. Les catégories et les sous-catégories doivent avoir un nom unique.',
    'Saving permissions failed: [_1]' => 'Echec lors de la sauvegarde des Autorisations : [_1]',
    'Can\'t find default template list; where is ' => 'Impossible de trouver la liste des modèles par défaut; où est ',
    'Populating blog with default templates failed: [_1]' => 'L\'activation sur le blog des modèles par défaut a échoué : [_1]',
    'Setting up mappings failed: [_1]' => 'La mise en oeuvre des mappings a échoué : [_1]',
    'Weblog \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Weblog \'[_1]\' (ID:[_2]) created by \'[_3]\'', # Translate - New (7)
    'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'User \'[_1]\' (ID:[_2]) created by \'[_3]\'', # Translate - New (7)
    'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'', # Translate - New (7)
    'You cannot delete your own author record.' => 'Vous ne pouvez pas effacer vos propres données Auteur.',
    'You have no permission to delete the author [_1].' => 'Vous n\'avez pas l\'autorisation d\'effacer l\'auteur [_1].',
    'Weblog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Weblog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'', # Translate - New (7)
    'Subscriber \'[_1]\' (ID:[_2]) deleted from notification list by \'[_3]\'' => 'Subscriber \'[_1]\' (ID:[_2]) deleted from notification list by \'[_3]\'', # Translate - New (10)
    'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'', # Translate - New (7)
    'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'', # Translate - New (7)
    'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'', # Translate - New (11)
    'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'', # Translate - New (7)
    '(Unlabeled category)' => '(Unlabeled category)', # Translate - New (3)
    'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'', # Translate - New (11)
    '(Untitled entry)' => '(Untitled entry)', # Translate - New (3)
    'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'', # Translate - New (11)
    'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'', # Translate - New (7)
    'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'', # Translate - New (7)
    'Passwords do not match.' => 'Les mots de passe ne sont pas conformes.',
    'Failed to verify current password.' => 'Erreur lors de la vérification du mot de passe.',
    'An author by that name already exists.' => 'Un auteur ayant ce nom existe déjà.',
    'Save failed: [_1]' => 'Echec sauvegarde: [_1]',
    'Saving object failed: [_1]' => 'Echec lors de la sauvegarde de l\'objet : [_1]',
    'No Name' => 'Pas de Nom',
    'Notification List' => 'Liste de notifications',
    'email addresses' => 'adresses email',
    'Can\'t delete that way' => 'Impossible de supprimer comme cela',
    'Your login session has expired.' => 'Votre session a expiré.',
    'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => 'Vous ne pouvez pas effacer cette catégorie car elle contient des sous-catégories. Déplacez ou supprimez d\'abord les sous-catégories pour pouvoir effacer cette catégorie.',
    'System templates can not be deleted.' => 'System templates can not be deleted.', # Translate - New (6)
    'Unknown object type [_1]' => 'Objet de type [_1] inconnu',
    'Loading object driver [_1] failed: [_2]' => 'Echec lors du chargement du driver [_1] : [_2]',
    'Reading \'[_1]\' failed: [_2]' => 'Echec \'[_1]\' lors de la lecture de : [_2]',
    'Thumbnail failed: [_1]' => 'Echec de a vignette: [_1]',
    'Error writing to \'[_1]\': [_2]' => 'Erreur \'[_1]\' lors de l\'écriture de : [_2]',
    'Invalid basename \'[_1]\'' => 'Nom de base invalide \'[_1]\'',
    'No such commenter [_1].' => 'Pas de d\'auteur de commentaires [_1].',
    'User \'[_1]\' trusted commenter \'[_2]\'.' => 'User \'[_1]\' trusted commenter \'[_2]\'.', # Translate - New (5)
    'User \'[_1]\' banned commenter \'[_2]\'.' => 'User \'[_1]\' banned commenter \'[_2]\'.', # Translate - New (5)
    'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'User \'[_1]\' unbanned commenter \'[_2]\'.', # Translate - New (5)
    'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'User \'[_1]\' untrusted commenter \'[_2]\'.', # Translate - New (5)
    'Need a status to update entries' => 'Statut nécessaire pour mettre à jour les notes',
    'Need entries to update status' => 'Notes nécessaires pour mettre à jour le statut',
    'One of the entries ([_1]) did not actually exist' => 'Une des notes ([_1]) n\'existait pas',
    'Some entries failed to save' => 'Certaines notes non pas été sauvegardées correctement',
    'You don\'t have permission to approve this TrackBack.' => 'Vous n\'avez pas l\'autorisation d\'approuver ce TrackBack.',
    'Comment on missing entry!' => 'Commentaire su une note maquante !',
    'You don\'t have permission to approve this comment.' => 'Vous n\'avez pas la permission d\'approuver ce commentaire.',
    'Comment Activity Feed' => 'Flux d\'activité des commentaires',
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
    'Entry \'[_1]\' (ID:[_2]) added by user \'[_3]\'' => 'Entry \'[_1]\' (ID:[_2]) added by user \'[_3]\'', # Translate - New (8)
    'The category must be given a name!' => 'Vous devez donner un nom a votre catégorie.',
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
    'Parse error: [_1]' => 'Erreur de parsing : [_1]',
    'Build error: [_1]' => 'Erreur de construction : [_1]',
    'Rebuild-option name must not contain special characters' => 'L option de reconstruction de nom ne doit pas contenir de caractères spéciaux',
    'index template \'[_1]\'' => 'index hbaillage \'[_1]\'',
    'entry \'[_1]\'' => 'note \'[_1]\'',
    'Ping \'[_1]\' failed: [_2]' => 'Le Ping \'[_1]\' n\'a pas fonctionné : [_2]',
    'You cannot modify your own permissions.' => 'Vous ne pouvez pas modifier vos propres permissions.',
    'You are not allowed to edit the permissions of this author.' => 'Vous n êtes pas autorisé à modifier les autorisations de cet auteur.',
    'Edit Permissions' => 'Editer les Autorisations',
    'Edit Profile' => 'Editer le profil',
    'No entry ID provided' => 'Aucune ID de Note fournie',
    'No such entry \'[_1]\'' => 'Aucune Note du type \'[_1]\'',
    'No email address for author \'[_1]\'' => 'L\'auteur \'[_1]\' ne possède pas d\'adresse e-mail',
    'No valid recipients found for the entry notification.' => 'Aucun destinataire valide n\'a été trouvé pour la notification de cette note.',
    'Error sending mail ([_1]); try another MailTransfer setting?' => 'Erreur lors de l\'envoi de l\'e-mail ([_1]); essayer un autre paramètre de MailTransfer ?',
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
    'Invalid date(s) specified for date range.' => 'Date(s) incorrecte(s) pour la sélection de calendrier.',
    'Error in search expression: [_1]' => 'Erreur dans la recherche de l expression : [_1]',
    'Saving object failed: [_2]' => 'La sauvegarde des objets a échoué : [_2]',
    'Search & Replace' => 'Rechercher et Remplacer',
    'No blog ID' => 'Aucun blog ID',
    'You do not have export permissions' => 'Vous n\'avez pas les droits d\'exportation',
    'You do not have import permissions' => 'Vous n\'avez pas les droits d\'importation',
    'You do not have permission to create authors' => 'Vous n\'êtes pas autorisé à créer des auteurs',
    'Preferences' => 'Préférences',
    'Add a Category' => 'Ajouter une Catégorie',
    'No label' => 'Pas d etiquette',
    'Category name cannot be blank.' => 'Vous devez nommer votre catégorie.',
    'That action ([_1]) is apparently not implemented!' => 'Cette action ([_1]) n\'est visiblement pas implémentée!',
    'Permission denied' => 'Autorisation refusée',

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

    ## ./t/Bar.pm

    ## ./t/Foo.pm

    ## ./t/lib/Text/WikiFormat.pm

    ## ./t/lib/LWP/UserAgent/Local.pm

    'This page contains an archive of all entries posted to [_1] in the <strong>[_2]</strong> category.  They are listed from oldest to newest.' => 'This page contains an archive of all entries posted to [_1] in the <strong>[_2]</strong> category.  They are listed from oldest to newest.', # Translate - New (24)
    '<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> is the next archive.', # Translate - New (10)
    'Refreshing (with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>) template \'[_3]\'.' => 'Refreshing (with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>) template \'[_3]\'.', # Translate - New (20)
    '<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> is the previous category.', # Translate - New (10)
    'Deleting an author is an irrevocable action which creates orphans of the author\'s entries.  If you wish to retire an author or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete this author?' => 'Deleting an author is an irrevocable action which creates orphans of the author\'s entries.  If you wish to retire an author or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete this author?', # Translate - New (49)
    'Refreshing template \'[_1]\'.' => 'Refreshing template \'[_1]\'.', # Translate - New (3)
    'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Skipping template \'[_1]\' since it appears to be a custom template.', # Translate - New (11)
    'Deleting an author is an irrevocable action which creates orphans of the author\'s entries.  If you wish to retire an author or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete the [_1] selected authors?' => 'Deleting an author is an irrevocable action which creates orphans of the author\'s entries.  If you wish to retire an author or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete the [_1] selected authors?', # Translate - New (51)
    '<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> is the previous archive.', # Translate - New (10)
    'This page contains all entries posted to [_1] in <strong>[_2]</strong>. They are listed from oldest to newest.' => 'This page contains all entries posted to [_1] in <strong>[_2]</strong>. They are listed from oldest to newest.', # Translate - New (19)
    '<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> is the next category.', # Translate - New (10)
    'Can\'t duplicate the existing \'[_1]\' Widget Manager. Please go back and enter a unique name.' => 'Can\'t duplicate the existing \'[_1]\' Widget Manager. Please go back and enter a unique name.', # Translate - New (16)

);


1;

## New words: 633
