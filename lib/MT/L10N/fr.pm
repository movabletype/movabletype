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

    ## ./mt-inbox.pl

    ## ./mt-check.cgi.pre
    'Movable Type System Check' => 'Vérification du système de Movable Type',
    'This page provides you with information on your system\'s configuration and determines whether you have all of the components you need to run Movable Type.' => 'Cette page vous fournit des informations sur la configuration de votre système et vérifie que vous avez installé tous les composants nécesaires à l\'utilisation de Movable Type.',
    'System Information:' => 'Information Système:',
    'Current working directory:' => 'Répertoire actuellement en activité:',
    'MT home directory:' => 'MT Répertoire racine:',
    'Operating system:' => 'Système  d\'exploitation :',
    'Perl version:' => 'Version Perl:',
    'Perl include path:' => 'Chemin Perl inclu:',
    'Web server:' => 'Serveur Web:',
    '(Probably) Running under cgiwrap or suexec' => '(Probablement) Tâche lancée sous cgiwrap ou suexec',
    'Checking for [_1] Modules:' => 'Vérification des Modules [_1]:',
    'Some of the following modules are required by the various data storage options in Movable Type. In order run the system, your server needs to have either DB_File, or else DBI and at least one of the other modules installed.' => 'Certains de ces modules sont nécessaires pour le stockage de données de Movable Type. Pour faire tourner le système votre serveur doit avoir soit DB_File, ou DBI ou au moins l\'un des autres modules installés.',
    'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'Soit [_1] n\'est pas installé sur votre serveur, soit la version installée est trop ancienne, ou [_1] nécessite un autre module qui n\'est pas installé.',
    'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => '[_1] n\'est pas installé sur votre serveur, ou [_1] nécessite un autre module qui n\'est pas installé.',
    'Please consult the installation instructions for help in installing [_1].' => 'Merci de consulter les instructions d\'installation de [_1].',
    'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN.' => 'La version DBD::mysql qui est installée n\'est pas compatible avec Movable Type. Merci d\'installer la version actuelle disponible sur CPAN.',
    'Your server has [_1] installed (version [_2]).' => '[_1] est installé sur votre serveur (version [_2]).',
    'Movable Type System Check Successful' => 'Vérification du système Movable Type effectuée avec succès',
    'You\'re ready to go!' => 'Vous pouvez commencer!',
    'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Tous les modules requis sont installés sur votre serveur; vous n\'avez pas besoin d\'installer de modules additionnels. Continuez l\'installation.',

    ## ./search_templates/default.tmpl
    'Search Results' => 'Résultats de recherche',
    'Search this site:' => 'Recherche sur ce site:',
    'Search' => 'Rechercher',
    'Match case' => 'Respecter la casse',
    'Regex search' => 'Expression générique',
    'Search Results from' => 'Résultats de la recherche depuis',
    'Posted in' => 'Postés dans',
    'on' => 'sur',
    'Searched for' => 'Recherché pour ',
    'No pages were found containing' => 'Aucune page n\'a été trouvée contenant',
    'Instructions' => 'Instructions',
    'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Par défault, ce moteur de recherche regarde tous les mots dans un ordre aléatoire. Pour rechercher une expression exacte, écrivez-là entre guillemets:',
    'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'Ce moteur de recherche permet les mots clés AND, OR et NOT pour des expressions booléennes spécifiques:',
    'personal OR publishing' => 'personnel OR publication',
    'publishing NOT personal' => 'personnel NOT publication',

    ## ./search_templates/comments.tmpl
    'Search for new comments from:' => 'Recherche de nouveaux commentaires depuis:',
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
    'Posted in ' => 'Postés dans ',
    'No results found' => 'Aucun résultat n\'a été trouvé',
    'No new comments were found in the specified interval.' => 'Aucun nouveau commentaire n\'a été trouvé dans l\'interval spécifié.',

    ## ./default_templates/comment_error_template.tmpl
    'Comment Submission Error' => 'Erreur de d\'envoi de commentaire',
    'Your comment submission failed for the following reasons:' => 'Votre envoi de commentaire a échoué pour la raison suivante:',

    ## ./default_templates/dynamic_pages_error_template.tmpl
    'Page Not Found' => 'Page Non Trouvée',

    ## ./default_templates/trackback_listing_template.tmpl
    ': Discussion on [_1]' => ': Discussion à propos de [_1]',
    'Trackbacks: [_1]' => 'Trackbacks: [_1]', 
    'TrackBack' => 'TrackBack', 
    'TrackBack URL for this entry:' => 'URL de TrackBack de cette note:',
    'Listed below are links to weblogs that reference' => 'Ci-dessous la liste des liens qui référencent',
    'from' => 'de',
    'Read More' => 'Lire la suite',
    'Tracked on [_1]' => 'Trackbacké sur [_1]',
    'Search this blog:' => 'Chercher dans ce blog:',
    'Recent Posts' => 'Notes récentes',
    'Subscribe to this blog\'s feed' => 'S\'abonner au flux de ce blog',
    'What is this?' => 'De quoi s\'agit-il?',
    'Creative Commons License' => 'Licence Creative Commons',
    'This weblog is licensed under a' => 'Ce weblog est sujet à une licence',

    ## ./default_templates/individual_entry_archive.tmpl
    'Main' => 'Accueil',
    'Posted by [_1] on [_2]' => 'Posté par [_1] dans [_2]',
    'Permalink' => 'Lien permanent',
    'Tracked on' => 'Trackbacké le',
    'Comments' => 'Commentaires',
    'Posted by:' => 'Postée le:',
    'Post a comment' => 'Poster un commentaire',
    '(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(Si vous n\'avez pas encore écrit de commentaire ici, vous devez être approuvé par le propriétaire du site avant que votre commentaire n\'apparaisse. En attendant, il n\'apparaîtra pas sur le site. Merci d\'attendre).',
    'Name:' => 'Nom:',
    'Email Address:' => 'Adresse e-mail:',
    'URL:' => 'URL:', 
    'Remember personal info?' => 'Mémoriser mes infos personnelles?',
    'Comments:' => 'Commentaires:',
    '(you may use HTML tags for style)' => '(vous pouvez utilisez des tags HTML pour modifier le style)',
    'Preview' => 'Aperçu',
    'Post' => 'Publier',

    ## ./default_templates/main_index.tmpl
    'Continue reading' => 'Lire la suite',
    'Posted by [_1] at [_2]' => 'Posté par [_1] à [_2]',
    'TrackBacks' => 'TrackBacks', 
    'Categories' => 'Catégories',
    'Archives' => 'Archives', 

    ## ./default_templates/dynamic_site_bootstrapper.tmpl

    ## ./default_templates/datebased_archive.tmpl
    'Posted by' => 'Publié par',
    'at' => 'à',

    ## ./default_templates/uploaded_image_popup_template.tmpl

    ## ./default_templates/category_archive.tmpl

    ## ./default_templates/master_archive_index.tmpl
    ': Archives' => ': Archives', 

    ## ./default_templates/comment_listing_template.tmpl
    'Comment on' => 'Commentaire sur',

    ## ./default_templates/atom_index.tmpl

    ## ./default_templates/rsd.tmpl

    ## ./default_templates/stylesheet.tmpl

    ## ./default_templates/site_javascript.tmpl
    'Thanks for signing in,' => 'Merci de vous être enregistré,',
    '. Now you can comment. ' => '. Maintenant vous pouvez commenter. ',
    'sign out' => 'déconnexion',
    'You are not signed in. You need to be registered to comment on this site.' => 'Vous n\'êtes pas enregistré.  Vous devez être enregistré pour pouvoir commenter sur ce site.',
    'Sign in' => 'Inscription',
    'If you have a TypeKey identity, you can' => 'Si vous avez un identifiant TypeKey, vous pouvez',
    'sign in' => 'inscription',
    'to use it here.' => 'pour l\'utiliser ici.',

    ## ./default_templates/comment_preview_template.tmpl
    'Previewing your Comment' => 'Aperçu',
    'Anonymous' => 'Anonyme',
    'Cancel' => 'Annuler',

    ## ./default_templates/rss_20_index.tmpl

    ## ./default_templates/comment_pending_template.tmpl
    'Comment Pending' => 'Commentaires en attente',
    'Thank you for commenting.' => 'Merci de votre commentaire.',
    'Your comment has been received and held for approval by the blog owner.' => 'Votre commentaire a été reçu et est en attente de validation par le propriétaire de ce blog.',
    'Return to the original entry' => 'Retourner à la note originale',

    ## ./lib/MT/default-templates.pl

    ## ./plugins/nofollow/nofollow.pl

    ## ./plugins/spamlookup/spamlookup_words.pl

    ## ./plugins/spamlookup/spamlookup.pl

    ## ./plugins/spamlookup/spamlookup_urls.pl

    ## ./plugins/spamlookup/tmpl/url_config.tmpl
    'Less' => 'Moins',
    'Decrease' => 'Baisser',
    'Increase' => 'Augmenter',
    'More' => 'Plus',

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
    'Missing Configuration File' => 'Fichier de configuration manquant',
    'Database Connection Error' => 'Erreur de connexion à la base de données',
    'CGI Path Configuration Required' => 'Configuration de chemin CGI requise',
    'An error occurred' => 'Une erreur s\'est produite',

    ## ./tmpl/cms/comment_table.tmpl
    'Status' => 'Statut',
    'Comment' => 'Commentaire',
    'Commenter' => 'Commentateur',
    'Weblog' => 'Weblog', 
    'Entry' => 'Note',
    'Date' => 'Date', 
    'IP' => 'IP', 
    'Only show published comments' => 'N\'afficher que les commentaires publiés',
    'Published' => 'Publié',
    'Only show pending comments' => 'N\'afficher que les commentaires en attente',
    'Pending' => 'En attente',
    'Edit this comment' => 'Editer ce commentaire',
    'Edit this commenter' => 'Editer ce commentateur',
    'Trusted' => 'Fiable',
    'Blocked' => 'Bloqué',
    'Authenticated' => 'Authentifié',
    'Search for comments by this commenter' => 'Chercher les commentaires de ce commentateur',
    'Show all comments on this entry' => 'Afficher tous les commentaires de cette note',
    'Search for all comments from this IP address' => 'Rechercher tous les commentaires associés à cette adresse IP',

    ## ./tmpl/cms/notification_actions.tmpl
    'Delete' => 'Supprimer',
    'notification address' => 'adresse de notification',
    'notification addresses' => 'adresses de notification',
    'Delete selected notification addresses (d)' => 'Effacer les adresses de notification sélectionnées (d)',

    ## ./tmpl/cms/edit_comment.tmpl
    'Edit Comment' => 'Modifier les commentaires',
    'Your changes have been saved.' => 'Les modifications ont été enregistrées.',
    'The comment has been approved.' => 'Le commentaire a été approuvé.',
    'Previous' => 'Précédent',
    'List &amp; Edit Comments' => 'Lister &amp; Editer les commentaires',
    'Next' => 'Suivant',
    'View Entry' => 'Afficher la note',
    'Pending Approval' => 'En attente d\'approbation',
    'Junked Comment' => 'Commentaire indésirable',
    'Status:' => 'Statut:',
    'Unpublished' => 'Non publié',
    'Junk' => 'Indésirable',
    'View all comments with this status' => 'Voir tous les commentaires avec ce statut',
    'Commenter:' => 'Commentateur:',
    '(Trusted)' => '(Fiable)',
    'Ban&nbsp;Commenter' => 'Bannir&nbsp;le&nbsp;Commentateur',
    'Untrust&nbsp;Commenter' => 'Commentateur non fiable',
    'Banned' => 'Banni',
    '(Banned)' => '(Banni)',
    'Trust&nbsp;Commenter' => 'Faire&nbsp;confiance&nbsp;au&nbsp;Commentateur',
    'Unban&nbsp;Commenter' => 'Commentateur autorisé à nouveau',
    'View all comments by this commenter' => 'Afficher tous les commentaires de ce commentateur',
    'Email:' => 'Adresse e-mail:',
    'None given' => 'Non fourni',
    'Email' => 'Adresse e-mail',
    'View all comments with this email address' => 'Afficher tous les commentaires associés à cette adresse email',
    'Link' => 'Lien',
    'View all comments with this URL' => 'Afficher tous les commentaires associés à cette URL',
    'Entry:' => 'Note:',
    'Entry no longer exists' => 'Cette note n\'existe plus',
    'No title' => 'Sans titre',
    'View all comments on this entry' => 'Afficher tous les commentaires associés à cette note',
    'Date:' => 'Date:', 
    'View all comments posted on this day' => 'Afficher tous les commentaires postés ce même jour',
    'IP:' => 'IP:', 
    'View all comments from this IP address' => 'Afficher tous les commentaires associés à cette adresse IP',
    'Save Changes' => 'Enregistrer les modifications',
    'Save this comment (s)' => 'Sauvegarder ce commentaire (s)',
    'Delete this comment (d)' => 'Effacer ce commentaire (d)',
    'Ban This IP' => 'Bannir cette adresse IP',
    'Final Feedback Rating' => 'Notation finale des Feedbacks',
    'Test' => 'Test', 
    'Score' => 'Score', 
    'Results' => 'Résultats',
    'Plugin Actions' => 'Actions du plugin',

    ## ./tmpl/cms/list_commenters.tmpl
    'Authenticated Commenters' => 'Commentateurs authentifiés',
    'The selected commenter(s) has been given trusted status.' => 'Le statut fiable a été accordé au(x) Commentateur(s) sélectionné(s).',
    'Trusted status has been removed from the selected commenter(s).' => 'Le(s) commentateur(s) sélectionné(s) n\'est plus en statut fiable.',
    'The selected commenter(s) have been blocked from commenting.' => 'Le(s) commentateur(s) sélectionné(s) ne peut plus commenter.',
    'The selected commenter(s) have been unbanned.' => 'Le(s) commentateur(s) sélectionné(s) n\'est plus bannis.',
    'Go to Comment Listing' => 'Aller à la liste des commentaires',
    'Quickfilter:' => 'Filtre Rapide:',
    'Show unpublished comments.' => 'Afficher les commentaires non publiés.',
    'Reset' => 'Effacer',
    'Filter:' => 'Filtrer:',
    'Showing all commenters.' => 'Afficher tous les commentateurs.',
    'Showing only commenters whose' => 'Afficher seulement les commentateurs dont le',
    'is' => 'est',
    'Show' => 'Afficher',
    'all' => 'tous/toutes',
    'only' => 'uniquement',
    'commenters.' => 'les commentateurs.',
    'commenters where' => 'les commentateurs dont',
    'status' => 'le statut',
    'commenter' => 'le commentateur',
    'trusted' => 'fiable',
    'untrusted' => 'non fiable',
    'banned' => 'banni',
    'unauthenticated' => 'non authentifié',
    'authenticated' => 'authentifié',
    'Filter' => 'Filtrer',
    'No commenters could be found.' => 'Aucun commentateur trouvé.',

    ## ./tmpl/cms/bookmarklets.tmpl
    'QuickPost' => 'QuickPost', 
    'Add QuickPost to Windows right-click menu' => 'Ajouter QuickPost au menu contextuel de Windows (clic droit)',
    'Configure QuickPost' => 'Configurer QuickPost',
    'Include:' => 'Inclure:',
    'TrackBack Items' => 'Eléments de TrackBack',
    'Category' => 'Catégorie',
    'Allow Comments' => 'Autoriser les commentaires',
    'Allow TrackBacks' => 'Autoriser les TrackBacks',
    'Text Formatting' => 'Mise en forme du texte',
    'Excerpt' => 'Extrait',
    'Extended Entry' => 'Suite de la note',
    'Keywords' => 'Mots-clés',
    'Basename' => 'Nom de base',
    'Create' => 'Créer',

    ## ./tmpl/cms/copyright.tmpl

    ## ./tmpl/cms/import.tmpl
    'Import / Export' => 'Importer / Exporter',
    'System-wide' => 'Dans tout le système',
    'Transfer weblog entries into Movable Type from other blogging tools or export your entries to create a backup or copy.' => 'Transférer les notes d\'un autre weblog vers Movable Type, ou exporter les notes en vue d\'une sauvegarde.',
    'Import Entries' => 'Importer des notes',
    'Export Entries' => 'Exporter des notes',
    'Import entries as me' => 'Importer les notes sous mon nom',
    'Password (required if creating new authors):' => 'Mot de passe (requis pour les nouveaux auteurs):',
    'You will be assigned the author of all imported entries.  If you wish the original authors to keep ownership, you must contact your MT system administrator to perform the import so that new authors can be created if necessary.' => 'Vous serez considéré comme l\'auteur de toutes les notes importées. Si vous souhaitez conserver l\'attribution à l\'auteur original de ces notes, vous devez contacter votre administrateur système Movable Type pour effectuer l\'importation.',
    'Default category for entries (optional):' => 'Catégorie par défaut des notes (facultatif):',
    'Select a category' => 'Sélectionnez une catégorie',
    'Default post status for entries (optional):' => 'Etat de publication par défaut des notes (facultatif):',
    'Select a post status' => 'Sélectionnez un état de publication',
    'Start title HTML (optional):' => 'Code HTML précédant le titre (facultatif):',
    'End title HTML (optional):' => 'Code HTML suivant le titre (facultatif):',
    'Export Entries From [_1]' => 'Exporter les notes de [_1]',
    'Export Entries to Tangent' => 'Exporter les notes vers Tangent',

    ## ./tmpl/cms/commenter_actions.tmpl
    'Trust' => 'Fiable',
    'commenters' => 'commentateurs',
    'to act upon' => 'pour agir sur',
    'Trust commenter' => 'Commentateur Fiable',
    'Untrust' => 'Non Fiable',
    'Untrust commenter' => 'Commentateur Non Fiable',
    'Ban' => 'Bannir',
    'Ban commenter' => 'Commentateur Banni',
    'Unban' => 'Non banni',
    'Unban commenter' => 'Commentateur réactivé',
    'Trust selected commenters' => 'Attribuer le statut Fiable au(x) Commentateur(s) sélectionné(s)',
    'Ban selected commenters' => 'Bannir le(s) Commentateurs sélectionné(s)',

    ## ./tmpl/cms/list_author.tmpl
    'Authors' => 'Auteurs',
    'You have successfully deleted the authors from the Movable Type system.' => 'Les auteurs ont été effacés du système Movable Type.',
    'Create New Author' => 'Créer un nouvel auteur',
    'Username' => 'Nom d\'utilisateur',
    'Name' => 'Nom',
    'URL' => 'URL', 
    'Created By' => 'Créé par',
    'Entries' => 'Notes',
    'Last Entry' => 'Dernière Note',
    'System' => 'Système',

    ## ./tmpl/cms/ping_actions.tmpl
    'pings' => 'pings',
    'to publish' => 'pour publier',
    'Publish' => 'Publier',
    'Publish selected TrackBacks (p)' => 'Publier les Trackbacks sélectionnés (p)',
    'Delete selected TrackBacks (d)' => 'Effacer les Trackbacks sélectionnés (d)',
    'Junk selected TrackBacks (j)' => 'Jeter les Trackbacks sélectionnés (j)',
    'Not Junk' => 'Non Indésirable',
    'Recover selected TrackBacks (j)' => 'Retrouver les Trackbacks sélectionnés (j)',

    ## ./tmpl/cms/blog-left-nav.tmpl
    'Posting' => 'Poster',
    'Create New Entry' => 'Créer  une nouvelle note', 
    'New Entry' => 'Nouvelle note',
    'List Entries' => 'Afficher les notes',
    'Upload File' => 'Télécharger un fichier',
    'Community' => 'Communauté',
    'List Comments' => 'Afficher les commentaires',
    'List Commenters' => 'Lister les commentateurs',
    'Commenters' => 'Commentateurs',
    'List TrackBacks' => 'Lister les TrackBacks',
    'Edit Notification List' => 'Modifier la liste des avis',
    'Notifications' => 'Notifications', 
    'Configure' => 'Configurer',
    'List &amp; Edit Templates' => 'Lister &amp; Editer les habillages',
    'Templates' => 'Modèles',
    'Edit Categories' => 'Modifier les catégories',
    'Edit Weblog Configuration' => 'Modifier la configuration du weblog',
    'Settings' => 'Paramètres',
    'Utilities' => 'Utilitaires',
    'Search &amp; Replace' => 'Chercher &amp; Remplacer',
    'View Activity Log' => 'Afficher le journal des activités',
    'Activity Log' => 'Journal des activités',
    'Import &amp; Export Entries' => 'Importer &amp; Exporter les Notes',
    'Rebuild Site' => 'Actualiser le site',
    'View Site' => 'Voir le site',

    ## ./tmpl/cms/list_blog.tmpl
    'Movable Type News' => 'News Movable Type',
    'System Shortcuts' => 'Raccourcis système',
    'Weblogs' => 'Weblogs', 
    'Concise listing of weblogs.' => 'Liste résumée des weblogs.',
    'Create, manage, set permissions.' => 'Créer, gérer et accorder les autorisations.',
    'Plugins' => 'Plugins', 
    'What\'s installed, access to more.' => 'Eléments installés, accéder à plus.',
    'Multi-weblog entry listing.' => 'Listing des notes des tous les weblogs.',
    'Multi-weblog comment listing.' => 'Listing des commentaires de tous les weblogs.',
    'Multi-weblog TrackBack listing.' => 'Listing des TrackBacks de tous les weblogs.',
    'System-wide configuration.' => 'Configuration générale du système.',
    'Find everything. Replace anything.' => 'Rechercher et/ou remplacer un élément.',
    'What\'s been happening.' => 'Historique des actions.',
    'Status &amp; Info' => 'Statut &amp; Info',
    'Server status and information.' => 'Information et statut serveur.',
    'Set Up A QuickPost Bookmarklet' => 'Installer le Bookmarklet QuickPost',
    'Enable one-click publishing.' => 'Activer la publication en un clic.',
    'My Weblogs' => 'Mes Weblogs',
    'Warning' => 'Attention',
    'Important:' => 'Important:', 
    'Configure this weblog.' => 'Configurer ce weblog.',
    'Create a new entry' => 'Créer une note',
    'on this weblog' => 'sur ce weblog',
    'Show Display Options' => 'Options d\'affichage',
    'Display Options' => 'Options d\'affichage',
    'Sort By:' => 'Trié par:',
    'Weblog Name' => 'Nom du Weblog',
    'Creation Order' => 'Ordre de création',
    'Last Updated' => 'Dernière Mise à jour',
    'Order:' => 'Ordre:',
    'Ascending' => 'Croissant',
    'Descending' => 'Décroissant',
    'View:' => 'Vue:',
    'Compact' => 'Compacte',
    'Expanded' => 'Etendue',
    'Save' => 'Enregistrer',

    ## ./tmpl/cms/reload_opener.tmpl

    ## ./tmpl/cms/edit_template.tmpl
    'Edit Template' => 'Modifier un modèle',
    'Your template changes have been saved.' => 'Les modifications apportées ont été enregistrées.',
    'Rebuild this template' => 'Actualiser ce modèle',
    'Build Options' => 'Options de compilation',
    'Enable dynamic building for this template' => 'Activer la compilation dynamique pour ce modèle',
    'Rebuild this template automatically when rebuilding index templates' => 'Actualiser ce modèle en même temps que les modèles d\'index',
    'Template Name' => 'Nom du modèle',
    'Comment Listing Template' => 'Modèle de liste des commentaires',
    'Comment Preview Template' => 'Modèle d\'aperçu des commentaires',
    'Comment Error Template' => 'Modèle d\'avertissement d\'erreur liée aux commentaires',
    'Comment Pending Template' => 'Modèle d\'avertissement de commentaires en attente',
    'Commenter Registration Template' => 'Modèle d\'inscription des auteurs de commentaires',
    'TrackBack Listing Template' => 'Modèle de liste TrackBack',
    'Uploaded Image Popup Template' => 'Modèle de fenêtre de téléchargement d\'images',
    'Dynamic Pages Error Template' => 'Modèle d\'erreur de page dynamique',
    'Output File' => 'Fichier de sortie',
    'Link this template to a file' => 'Lier ce modèle à un fichier',
    'Module Body' => 'Corps du module',
    'Template Body' => 'Corps du modèle',
    'Save this template (s)' => 'Sauvegarder ce modèle (s)',
    'Save and Rebuild' => 'Sauvegarder et Reconstruire',
    'Save and rebuild this template (r)' => 'Sauvegarder et reconstruire ce modèle (r)',

    ## ./tmpl/cms/junk_results.tmpl
    'Find Junk' => 'Trouver indésirable(s)',
    'Approved' => 'Approuvé',
    'Registered Commenter' => 'Commentateur inscrit',

    ## ./tmpl/cms/entry_actions.tmpl
    'Save these entries (s)' => 'Sauvegarder ces notes (s)',
    'Save this entry (s)' => 'Sauvegarder cette note (s)',
    'Preview this entry (p)' => 'Prévisualiser cette note (p)',
    'entry' => 'note',
    'entries' => 'notes',
    'Delete this entry (d)' => 'Effacer cette note (d)',
    'to rebuild' => 'pour reconstruire',
    'Rebuild' => 'Actualiser',
    'Rebuild selected entries (r)' => 'Reconstruire les notes sélectionnées (r)',
    'Delete selected entries (d)' => 'Effacer les notes sélectionnées (d)',

    ## ./tmpl/cms/edit_blog.tmpl
    'You must set your Local Site Path.' => 'Vous devez configurer le chemin local de votre site.',
    'You must set your Site URL.' => 'Vous devez configurer l\'URL de votre site.',
    'You did not select a timezone.' => 'Vous n\'avez pas sélectionné de fuseau horaire.',
    'New Weblog Settings' => 'Nouveaux paramètres du weblog',
    'From this screen you can specify the basic information needed to create a weblog.  Once you click the save button, your weblog will be created and you can continue to customize its settings and templates, or just simply start posting.' => 'A partir de cet écran vous pouvez spécifier les informations de base nécessaires pour créer un weblog. En cliquant sur le bouton Sauvegarder, votre weblog sera créé et vous pourrez poursuivre la personnalisation de ses paramètres et habillages, ou simplement commencer à publier.',
    'Your weblog configuration has been saved.' => 'La configuration de votre weblog a été enregistrée.',
    'Weblog Name:' => 'Nom du weblog:',
    'Name your weblog. The weblog name can be changed at any time.' => 'Indiquez le nom de votre weblog. Ce nom peut être modifié par la suite, si vous le souhaitez.',
    'Site URL:' => 'URL du site:',
    'Enter the URL of your public website. Do not include a filename (i.e. exclude index.html).' => 'Indiquez l\'URL de votre site web publiî N\'incluez pas de nom de fichier (excluez index.html).',
    'Example:' => 'Exemple:',
    'Site root:' => 'Site racine:',
    'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'Indiquez le chemin d\'accès à votre fichier d\'index principal. Un chemin absolu (qui débute par \'/\' est préférable, mais il est également possible d\'utiliser un chemin relatif au répertoire de Movable Type.',
    'Timezone:' => 'Fuseau horaire:',
    'Time zone not selected' => 'Vous n\'avez pas sélectionné de fuseau horaire',
    'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (Nouvelle-Zélande)',
    'UTC+12 (International Date Line East)' => 'UTC+12 (ligne internationale de changement de date)',
    'UTC+11' => 'UTC+11', 
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
    'UTC-7 (Mountain Time)' => 'UTC-7 (Etats-Unis, heure des montagnes)',
    'UTC-8 (Pacific Time)' => 'UTC-8 (Etats-Unis, heure du Pacifique)',
    'UTC-9 (Alaskan Time)' => 'UTC-9 (Alaska)',
    'UTC-10 (Aleutians-Hawaii Time)' => 'UTC-10 (HawaC/)',
    'UTC-11 (Nome Time)' => 'UTC-11 (Nome)',
    'Select your timezone from the pulldown menu.' => 'Veuillez sélectionner votre fuseau horaire dans la liste.',

    ## ./tmpl/cms/author_actions.tmpl
    'author' => 'l\'auteur',
    'authors' => 'auteurs',
    'Delete selected authors (d)' => 'Effacer les auteurs sélectionnés (d)',

    ## ./tmpl/cms/search_replace.tmpl
    'You must select one or more item to replace.' => 'Vous devez sélectionner un ou plusieurs objets à remplacer.',
    'Search Again' => 'Chercher encore',
    'Search:' => 'Chercher:',
    'Replace:' => 'Remplacer:',
    'Replace Checked' => 'Remplacer les objets selectionnés',
    'Case Sensitive' => 'Respecter la casse',
    'Regex Match' => 'Expression Régulière',
    'Limited Fields' => 'Champs limités',
    'Date Range' => 'Longueur de la Date',
    'Is Junk?' => 'Indésirable?',
    'Search Fields:' => 'Rechercher les champs:',
    'Title' => 'Titre',
    'Entry Body' => 'Corps de la note',
    'Comment Text' => 'Texte du commentaire',
    'E-mail Address' => 'Adresse email',
    'IP Address' => 'Adresse IP',
    'Email Address' => 'Adresse e-mail',
    'Source URL' => 'URL Source',
    'Blog Name' => 'Nom du Blog',
    'Text' => 'Texte',
    'Output Filename' => 'Nom du fichier de sortie',
    'Linked Filename' => 'Lien du fichier lié',
    'Log Message' => 'Message du journal',
    'Date Range:' => 'Longueur de la date:',
    'From:' => 'De:',
    'To:' => 'A:',
    'Replaced [_1] records successfully.' => '[_1] enregistrements remplacés avec succès.',
    'No entries were found that match the given criteria.' => 'Aucune note ne correspond à votre recherche.',
    'No comments were found that match the given criteria.' => 'Aucun commentaire ne correspond à votre recherche.',
    'No TrackBacks were found that match the given criteria.' => 'Aucun TrackBack ne correspond à votre recherche.',
    'No commenters were found that match the given criteria.' => 'Aucun commentateur ne correspond à votre recherche.',
    'No templates were found that match the given criteria.' => 'Aucun habillage ne correspond à votre recherche.',
    'No log messages were found that match the given criteria.' => 'Aucun message de log ne correspond à votre recherche.',
    'Showing first [_1] results.' => 'Afficher d\'abord [_1] résultats.',
    'Show all matches' => 'Afficher tous les résultats',
    '[_1] result(s) found.' => '[_1] resultat(s) trouvé(s).',

    ## ./tmpl/cms/import_start.tmpl
    'Importing...' => 'Importation...',
    'Importing entries into blog' => 'Importation de notes dans le blog',
    'Importing entries as author \'[_1]\'' => 'Importation des notes en tant qu\'auteur \'[_1]\'',
    'Creating new authors for each author found in the blog' => 'Création de nouveaux auteur correspondant à chaque auteur trouvé dans le blog',

    ## ./tmpl/cms/log_actions.tmpl
    'Reset Activity Log' => 'Réinitialiser le journal des activités',

    ## ./tmpl/cms/log_table.tmpl

    ## ./tmpl/cms/edit_ping.tmpl
    'Edit TrackBack' => 'Editer les  TrackBacks',
    'The TrackBack has been approved.' => 'Le TrackBack a été approuvé.',
    'List &amp; Edit TrackBacks' => 'Lister &amp; Editer les TrackBacks',
    'Junked TrackBack' => 'TrackBacks indésirables',
    'View all TrackBacks with this status' => 'Voir tous les Trackbacks avec ce statut',
    'Source Site:' => 'Site Source:',
    'Search for other TrackBacks from this site' => 'Rechercher d\'autres Trackbacks de ce site',
    'Source Title:' => 'Titre Source:',
    'Search for other TrackBacks with this title' => 'Rechercher d\'autres Trackbacks avec ce titre',
    'Search for other TrackBacks with this status' => 'Rechercher d\'autres Trackbacks avec ce statut',
    'Target Entry:' => 'Note cible:',
    'View all TrackBacks on this entry' => 'Voir tous les TrackBacks pour cette note',
    'Target Category:' => 'Catégorie cible:',
    'Category no longer exists' => 'La catégorie n\'existe plus',
    'View all TrackBacks on this category' => 'Afficher tous les TrackBacks des cette catégorie',
    'View all TrackBacks posted on this day' => 'Afficher tous les TrackBacks postés ce jour',
    'View all TrackBacks from this IP address' => 'Afficher tous les TrackBacks avec cette adresse IP',
    'Save this TrackBack (s)' => 'Sauvegarder ce Trackback (s)',
    'Delete this TrackBack (d)' => 'Effecer ce Trackback (d)',

    ## ./tmpl/cms/cfg_entries.tmpl
    'New Entry Default Settings' => 'Paramètres par défaut des nouvelle notes',
    'This screen allows you to control default settings for new entries as well as your publicity and remote interface settings.' => 'Cet écran vous permet de contrôler les paramètres par défaut des nouvelles entrées ainsi que la promotion et l\'interface de paramétrage à distance.',
    'General' => 'Général',
    'New Entry Defaults' => 'Nouvelle note par défaut',
    'Feedback' => 'Feedback', 
    'Publishing' => 'Publication',
    'IP Banning' => 'Bannissement d\'adresses IP',
    'Your blog preferences have been saved.' => 'Les préférences de votre weblog ont été enregistrées.',
    'Default Settings for New Entries' => 'Paramètres par défaut des nouvelles notes',
    'Post Status' => 'Etat de publication',
    'Specifies the default Post Status when creating a new entry.' => 'Spécifie l\'état de publication par défaut des nouvelles notes.',
    'Specifies the default Text Formatting option when creating a new entry.' => 'Spécifie l\'option par défaut de mise en forme du texte des nouvelles notes.',
    'Accept Comments' => 'Accepter commentaires',
    'Specifies the default Accept Comments setting when creating a new entry.' => 'Spécifie l\'option par défaut des commentaires acceptés lors de la création d\'une nouvelle note.',
    'Setting Ignored' => 'Paramétrage ignoré',
    'Note: This option is currently ignored since comments are disabled either weblog or system-wide.' => 'Note: Cette option est ignorée tant que les commentaires sont désactivés sur une note ou dans l\'ensemble du système.',
    'Accept TrackBacks:' => 'Accepter TrackBacks:',
    'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Spécifie l\'option par défaut des TrackBacks acceptés lors de la création d\'une nouvelle note.',
    'Note: This option is currently ignored since TrackBacks are disabled either weblog or system-wide.' => 'Note: Cette option est ignorée tant que les TrackBacks sont désactivés sur une note ou sur l\'ensemble du système.',
    'Basename Length:' => 'Longueur du nom de base:',
    'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => 'Spécifier la longueur par défaut du nom de base. peut être comprise entre 15 et 250.',
    'Publicity/Remote Interfaces' => 'Publicité/Interfaces distantes',
    'Notify the following sites upon weblog updates:' => 'Notifier les sites suivants lors des mises à jour du weblog:',
    'Others:' => 'Autres:',
    '(Separate URLs with a carriage return.)' => '(Séparer les URLs avec un retour chariot.)',
    'When this weblog is updated, Movable Type will automatically notify the selected sites.' => 'Lors des mises à jour de ce weblog Movable Type notifiera automatiquement les sites sélectionnés.',
    'Setting Notice' => 'Paramétrage des informations',
    'Note: The above option may be affected since outbound pings are constrained system-wide.' => 'Attention: L\'option ci-dessous peut être affectée si les pings sortant sont limités dans le système.',
    'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Attention: Cette option est ignorée car les pings sortants sont désactivés globalement.',
    'Recently Updated Key:' => 'Clé de mise à jour récente:',
    'If you have received a recently updated key (by virtue of your purchase or donation), enter it here.' => 'Cet espace vous permet d\'indiquer votre clé de mise à jour récente (que vous auriez pu recevoir en raison de votre achat ou de votre contribution financière).',
    'TrackBack Auto-Discovery' => 'Découverte automatique des TrackBacks',
    'Enable External TrackBack Auto-Discovery' => 'Activer Auto-découverte Trackback Externe',
    'Note: The above option is currently ignored since outbound pings are disabled system-wide.' => 'Attention: l\'option ci-dessus est ignorée si les pings sortants sont désactivés dans le système',
    'Enable Internal TrackBack Auto-Discovery' => 'Activer Auto-découverte Trackback Interne',
    'If you turn on auto-discovery, when you write a new post, any external links will be extracted and the appropriate sites automatically sent TrackBacks.' => 'Si vous activez la découverte automatique, quand vous écrirez une nouvelle note, les liens externes seront extraits et les sites concernés recevront automatiquement un TrackBack.',
    'Save changes (s)' => 'Enregistrer les modifications',

    ## ./tmpl/cms/header-popup.tmpl
    'Movable Type Publishing Platform' => 'Plateforme de publication Movable Type',

    ## ./tmpl/cms/template_actions.tmpl
    'template' => 'template', 
    'templates' => 'templates', 

    ## ./tmpl/cms/list_entry.tmpl
    'Open power-editing mode' => 'Passer en mode d\'édition avancée',
    'Your entry has been deleted from the database.' => 'Votre note a été supprimée de la base de données.',
    'Show unpublished entries.' => 'Montrer les notes non publiées.',
    'Showing all entries.' => 'Afficher toutes les notes.',
    'Showing only entries where' => 'Afficher uniquement les notes dont le',
    'entries.' => 'les notes.',
    'entries where' => 'notes dont',
    'category' => 'la catégorie',
    'published' => 'publié',
    'unpublished' => 'non publié',
    'scheduled' => 'programmé',
    'No entries could be found.' => 'Aucune note n\'a pu être trouvée.',

    ## ./tmpl/cms/edit_categories.tmpl
    'Your category changes and additions have been made.' => 'Les modifications apportées aux catégories ont été enregistrées.',
    'You have successfully deleted the selected categories.' => 'Les catégories sélectionnées ont été supprimées.',
    'Create new top level category' => 'Créer une nouvelle catégorie principale',
    'Actions' => 'Actions', 
    'Create Category' => 'Créer une catégorie',
    'Top Level' => 'Niveau racine',
    'Collapse' => 'Réduire',
    'Expand' => 'Développer',
    'Create Subcategory' => 'Créer une sous-catégorie',
    'Move Category' => 'Déplacer la catégorie',
    'Move' => 'Déplacer',
    '[quant,_1,entry,entries]' => '[quant,_1,note,notes]',
    '[quant,_1,TrackBack]' => '[quant,_1,TrackBack]', 
    'Delete selected categories (d)' => 'Effacer les catégories sélectionnées(d)',

    ## ./tmpl/cms/pending_commenter.tmpl

    ## ./tmpl/cms/footer.tmpl

    ## ./tmpl/cms/pinging.tmpl
    'Pinging sites...' => 'Envoi de ping(s)...',

    ## ./tmpl/cms/edit_commenter.tmpl
    'Commenter Details' => 'Détails sur le commentateur',
    'The commenter has been trusted.' => 'Le commentateur est fiable.',
    'The commenter has been banned.' => 'Le commentateur a été banni.',
    'Junk Comments' => 'Commentaires indésirables',
    'View all comments with this name' => 'Afficher tous les commentaires associés à ce nom',
    'Identity:' => 'Identité:',
    'Withheld' => 'Retenu',
    'View all comments with this URL address' => 'Afficher tous les commentaires associés à cette URL',
    'View all commenters with this status' => 'Afficher tous les commentateurs ayant ce statut',

    ## ./tmpl/cms/notification_table.tmpl
    'Date Added' => 'Ajouté(e) le',

    ## ./tmpl/cms/edit_placements.tmpl
    'The secondary categories for this entry have been updated. You will need to SAVE the entry for these changes to be reflected on your public site.' => 'Les catégories secondaires de cette note ont été mises à jour. Vous devez enregistrer la note pour voir les modifications reflétées sur votre site public',
    'Categories in your weblog:' => 'Catégories de votre weblog:',
    'Secondary categories:' => 'Catégories secondaires:',
    'Close' => 'Fermer',

    ## ./tmpl/cms/entry_prefs.tmpl
    'Your entry screen preferences have been saved.' => 'Vos préférences d\'édition ont été enregistrées.',
    'Field Configuration' => 'Configuration des champs',
    '(Help?)' => '(Aide?)',
    'Basic' => 'Basique',
    'Advanced' => 'Avancée',
    'Custom: show the following fields:' => 'Personnalisée. Afficher les champs suivants:',
    'Editable Authored On Date' => 'Date de création modifiable',
    'Outbound TrackBack URLs' => 'URLs TrackBacks sortants',
    'Button Bar Position' => 'Position de la barre de boutons',
    'Top of the page' => 'Haut de la page',
    'Bottom of the page' => 'Bas de la page',
    'Top and bottom of the page' => 'Haut et bas de la page',

    ## ./tmpl/cms/pager.tmpl
    'Show:' => 'Afficher:',
    '[quant,_1,row]' => '[quant,_1,ligne]',
    'all rows' => 'toutes les lignes',
    'Another amount...' => 'Autre montant...',
    'Actions:' => 'Actions:', 
    'Below' => 'Sous',
    'Above' => 'Dessus',
    'Both' => 'Les deux',
    'Date Display:' => 'Affichage de la date:',
    'Relative' => 'Relative', 
    'Full' => 'Entière',
    'Newer' => 'Le plus récent',
    'Showing:' => 'Affiche:',
    'of' => 'de',
    'Older' => 'Le plus ancien',

    ## ./tmpl/cms/commenter_table.tmpl
    'Identity' => 'Identité',
    'Most Recent Comment' => 'Commentaire le plus récent',
    'Only show trusted commenters' => 'Afficher uniquement les commentateurs fiable',
    'Only show banned commenters' => 'Afficher uniquement les commentateurs bannis',
    'Only show neutral commenters' => 'Afficher uniquement les commentateurs neutres',
    'View this commenter\'s profile' => 'Afficher le profil de ce commentateur',

    ## ./tmpl/cms/rebuild-stub.tmpl
    'To see the changes reflected on your public site, you should rebuild your site now.' => 'Vous pouvez actualiser votre site de façon à voir les modifications reflétées sur votre site publié',
    'Rebuild my site' => 'Actualiser le site',

    ## ./tmpl/cms/cfg_prefs.tmpl
    'General Settings' => 'Paramètres généraux',
    'This screen allows you to control general weblog settings, default weblog display settings, and third-party service settings.' => 'Cet écran vous permet de contrôler les paramètres généraux du weblog, les paramètres par défaut d\'affichage et les services de tiers.',
    'Weblog Settings' => 'Paramètres du weblog',
    'Description:' => 'Description:', 
    'Enter a description for your weblog.' => 'Entrer une description pour votre weblog.',
    'Default Weblog Display Settings' => 'Paramètres par défaut d\'affichage du weblog',
    'Entries to Display:' => 'Notes à afficher:',
    'Days' => 'Jours',
    'Select the number of days\' entries or the exact number of entries you would like displayed on your weblog.' => 'Sélectionnez le nombre exact de jours (notes des X derniers jours ) ou  le nombre de notes que vous souhaitez voir affichées sur votre weblogs.',
    'Entry Order:' => 'Ordre des notes:',
    'Select whether you want your posts displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Sélectionnez l\'ordre d\'affichage des notes, croissant (les plus anciennes en premier) ou décroissant (les plus récentes en premier).',
    'Comment Order:' => 'Ordre des commentaires:',
    'Select whether you want visitor comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Sélectionnez l\'ordre d\'affichage des commentaires publiés par les visiteurs: croissant (les plus anciens en premier) ou décroissant (les plus récents en premier).',
    'Excerpt Length:' => 'Longueur des extraits:',
    'Enter the number of words that should appear in an auto-generated excerpt.' => 'Entrez le nombre de mot à afficher pour les extraits de notes.',
    'Date Language:' => 'Langue de la date:',
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
    'Limit HTML Tags:' => 'Limiter les tags HTML:',
    'Use defaults' => 'Utiliser les valeurs par défaut',
    '([_1])' => '([_1])', 
    'Use my settings' => 'Utiliser mes paramétrages',
    'Specifies the list of HTML tags allowed by default when cleaning an HTML string (a comment, for example).' => 'Spécifie la liste des balises HTML autorisées par défaut lors du nettoyage d\'une chaîne HTML (un commentaire, par exemple).',
    'Third-Party Services' => 'Services tiers',
    'Creative Commons License:' => 'Licence B+ Creative Commons B:',
    'Your weblog is currently licensed under:' => 'Votre weblog est actuellement régi par:',
    'Change your license' => 'Changer la licence',
    'Remove this license' => 'Supprimer cette licence',
    'Your weblog does not have an explicit Creative Commons license.' => 'Votre weblog ne fait pas l\'objet d\'une licence B+ Creative Commons B explicite.',
    'Create a license now' => 'Créer une licence',
    'Select a Creative Commons license for the posts on your blog (optional).' => 'Choisissez une licence B+ Creative Commons B pour les notes de votre weblog (facultatif).',
    'Be sure that you understand these licenses before applying them to your own work.' => 'Nous vous recommandons de vous informer de la portée des clauses de cette licence avant de l\'appliquer à vos propres travaux.',
    'Read more.' => 'En savoir plus.',
    'Google API Key:' => 'Clé d\'API Google:',
    'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.' => 'Vous devrez vous procurer une clé d\'API Google si vous souhaitez utiliser les fonctions d\'API proposées par Google. Le cas échéant, collez cette clé dans cet espace.',

    ## ./tmpl/cms/rebuild_confirm.tmpl
    'Select the type of rebuild you would like to perform. (Click the Cancel button if you do not want to rebuild any files.)' => 'Sélectionnez le type d\'actualisation que vous souhaitez exécuter (cliquez sur Annuler si vous souhaitez annuler l\'actualisation des fichiers).',
    'Rebuild All Files' => 'Actualiser tous les fichiers',
    'Index Template: [_1]' => 'Modèle d\'index: [_1]',
    'Rebuild Indexes Only' => 'Actualiser les index uniquement',
    'Rebuild [_1] Archives Only' => 'Actualiser les archives [_1] uniquement',
    'Rebuild (r)' => 'Reconstruire (r)',

    ## ./tmpl/cms/ping_table.tmpl
    'From' => 'De',
    'Target' => 'Cible',
    'Only show published TrackBacks' => 'Afficher uniquement les TrackBacks publiés',
    'Only show pending TrackBacks' => 'Afficher uniquement les TrackBacks en attente',
    'Edit this TrackBack' => 'Editer ce TrackBack',
    'Go to the source entry of this TrackBack' => 'Aller à la note à l\'orgine de ce TrackBack',
    'View the [_1] for this TrackBack' => 'Voir [_1] pour ce TrackBack',

    ## ./tmpl/cms/edit_entry.tmpl
    'Add new category...' => 'Ajouter une catégorie...',
    'Edit Entry' => 'Modifier une note',
    'Your entry has been saved. You can now make any changes to the entry itself, edit the authored-on date, edit comments, or send a notification.' => 'Votre note a été enregistrée. Vous pouvez maintenant modifier le contenu de la note, changer la date de création, modifier les commentaires ou envoyer une notification.',
    'One or more errors occurred when sending update pings or TrackBacks.' => 'Erreur lors de l\'envoi des pings ou des TrackBacks.',
    'Your customization preferences have been saved, and are visible in the form below.' => 'Vos préférences ont été enregistrées et sont affichées dans le formulaire ci-dessous.',
    'Your changes to the comment have been saved.' => 'Les modifications apportées aux commentaires ont été enregistrées.',
    'Your notification has been sent.' => 'Votre notification a été envoyé.',
    'You have successfully deleted the checked comment(s).' => 'Les commentaires sélectionnés ont été supprimés.',
    'You have successfully deleted the checked TrackBack(s).' => 'Le(s) TrackBack(s) sélectionné(s) ont été correctement supprimé(s).',
    'List &amp; Edit Entries' => 'Lister &amp; Editer les  Notes',
    'Comments ([_1])' => 'Commentaires ([_1])',
    'TrackBacks ([_1])' => 'TrackBacks ([_1])', 
    'Notification' => 'Notification', 
    'Scheduled' => 'Programmé',
    'Primary Category' => 'Catégorie principale',
    'Assign Multiple Categories' => 'Affecter plusieurs catégories',
    'Bold' => 'Gras',
    'Italic' => 'Italique',
    'Underline' => 'Souligné',
    'Insert Link' => 'Insérer un lien',
    'Insert Email Link' => 'Insérer le lien vers l\'e-mail',
    'Quote' => 'Citation',
    'Authored On' => 'Créé le',
    'Unlock this entry\'s output filename for editing' => 'Dévérouiller le nom du fichier de  cette note pour l\'éditer ',
    'Warning: If you set the basename manually, it may conflict with another entry.' => 'ATTENTION: Editer le nom de base manuellement peut créer des conflits avec d\'autres notes.',
    'Warning: Changing this entry\'s basename may break inbound links.' => 'ATTENTION: Changer le nom de base de cette note peut casser des liens entrants.',
    'Accept TrackBacks' => 'Accepter TrackBacks',
    'View Previously Sent TrackBacks' => 'Afficher les TrackBacks envoyés précédemment',
    'Customize the display of this page.' => 'Personnaliser l\'affichage de cette page.',
    'Manage Comments' => 'Gérer les commentaires',
    'Click on the author\'s name to edit the comment. To delete a comment, check the box to its right and then click the Delete button.' => 'Cliquez sur le nom de l\'auteur pour modifier le commentaire. Vous pouvez supprimer un commentaire en cochant la case associée, puis en cliquant sur le bouton Supprimer les éléments sélectionnés.',
    'No comments exist for this entry.' => 'Pas de commentaire sur cette note.',
    'Manage TrackBacks' => 'Gérer les TrackBacks',
    'Click on the TrackBack title to view the page. To delete a TrackBack, check the box to its right and then click the Delete button.' => 'Cliquez sur le TrackBack pour voir la page. Pour effacer le TrackBack, cochez la case à droite du nom et cliquez que le bouton Supprimer.',
    'No TrackBacks exist for this entry.' => 'Aucun TrackBack n\'est associé à cette note.',
    'Send a Notification' => 'Envoyer un avis',
    'You can send a notification message to your group of readers. Just enter the email message that you would like to insert below the weblog entry\'s link. You have the option of including the excerpt indicated above or the entry in its entirety.' => 'Vous pouvez envoyer un message avisant un groupe de lecteurs de la publication d\'une note. Il vous suffit d\'indiquer le message que vous souhaitez insérer sous le lien de la note du weblog. Vous pouvez également inclure l\'extrait indiqué plus haut ou la note complète.',
    'Include excerpt' => 'Inclure l\'extrait',
    'Include entire entry body' => 'Inclure toute la note',
    'Note: If you chose to send the weblog entry, all added HTML will be included in the email.' => 'Remarque: si vous décidez d\'inclure tout le contenu de la note, les balises HTML qu\'elle contient seront également envoyées.',
    'Send' => 'Envoyer',

    ## ./tmpl/cms/entry_table.tmpl
    'Author' => 'Auteur',
    'Only show unpublished entries' => 'N\'afficher que les notes non publiées',
    'Only show published entries' => 'Afficher uniquement les notes publiées',
    'Only show future entries' => 'Afficher uniquement les notes futures',
    'Future' => 'Futur',
    'None' => 'Aucune',

    ## ./tmpl/cms/pinged_urls.tmpl
    'Here is a list of the previous TrackBacks that were successfully sent:' => 'Voici la liste des TrackBacks envoyés avec succès:',

    ## ./tmpl/cms/view_log.tmpl
    'The Movable Type activity log contains a record of notable actions in the system.' => 'Le journal de l\'activité de Movable Type contient un enregistrement des actions notables dans le système.',
    'All times are displayed in GMT' => 'Toutes les heures sont affichées GMT',
    'All times are displayed in GMT.' => 'Toutes les heures sont affichées GMT.',
    'Export in CSV format.' => 'Exporter en format CSV.',
    'The activity log has been reset.' => 'Le journal des activités a été réinitialisé.',
    'No log entries could be found.' => 'Aucun log d\'entrée n\'a été trouvé.',

    ## ./tmpl/cms/spam_confirm.tmpl
    'These domain names were found in the selected comments. Check the box at right to block comments and trackbacks containing that URL in the future.' => 'Ces noms de domaines ont été trouvés dans les commentaires. Cocher la boîte à droite pour bloquer ces url dans les commentaires et les trackbacks qui les contiendront à l\'avenir.',
    'Block' => 'Bloquer',

    ## ./tmpl/cms/preview_entry.tmpl
    'Re-Edit this entry' => 'Modifier cette note',
    'Save this entry' => 'Enregistrer cette note',

    ## ./tmpl/cms/delete_confirm.tmpl
    'Are you sure you want to permanently delete the [quant,_1,author] from the system?' => 'Souhaitez-vous vraiment supprimer [quant,_1,auteur] de façon permanente du système?',
    'Are you sure you want to delete the [quant,_1,comment]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,commentaire]?',
    'Are you sure you want to delete the [quant,_1,TrackBack]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,TrackBack]?',
    'Are you sure you want to delete the [quant,_1,entry,entries]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,note,notes]?',
    'Are you sure you want to delete the [quant,_1,template]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,modèle]?',
    'Are you sure you want to delete the [quant,_1,category,categories]? When you delete a category, all entries assigned to that category will be unassigned from that category.' => 'Souhaitez-vous vraiment supprimer [quant,_1,catégorie,catégories]? L\'association entre une note et une catégorie est perdue lorsque vous supprimez une catégorie.',
    'Are you sure you want to delete the [quant,_1,template] from the particular archive type(s)?' => 'Souhaitez-vous vraiment supprimer [quant,_1,modèle] de ce(s) type(s) d\'archive?',
    'Are you sure you want to delete the [quant,_1,IP address,IP addresses] from your Banned IP List?' => 'Souhaitez-vous vraiment supprimer [quant,_1,adresse IP,adresses IP] de la liste des adresses IP bannies?',
    'Are you sure you want to delete the [quant,_1,notification address,notification addresses]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,adresse pour avis,adresses pour avis]?',
    'Are you sure you want to delete the [quant,_1,blocked item,blocked items]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,élément bloqué,éléments bloqués]?',
    'Are you sure you want to delete the [quant,_1,weblog]? When you delete a weblog, all of the entries, comments, templates, notifications, and author permissions are deleted along with the weblog itself. Make sure that this is what you want, because this action is permanent.' => 'Souhaitez-vous vraiment supprimer [quant,_1,weblog]? Lorsque vous supprimez un weblog, les notes, les commentaires, les modèles, les avis, et les permissions affectées aux auteurs sont également supprimé(e)s. Notez également que le résultat de cette action est définitif.',

    ## ./tmpl/cms/blog_actions.tmpl
    'weblog' => 'weblog', 
    'weblogs' => 'weblogs', 
    'Delete selected weblogs (d)' => 'Effacer les weblogs sélectionnés (d)',

    ## ./tmpl/cms/edit_permissions.tmpl
    'Author Permissions' => 'Autorisations des Auteurs',
    'Your changes to [_1]\'s permissions have been saved.' => 'Vos modifications des autorisations accordés à  [_1] a été enregistré.',
    '[_1] has been successfully added to [_2].' => '[_1] a été ajouté(e) avec succès à [_2].',
    'Permissions' => 'Autorisations',
    'General Permissions' => 'Autorisations générales',
    'System Administrator' => 'Administrateur Système',
    'User can create weblogs' => 'L\'utilisateur peut créer un weblog',
    'User can view activity log' => 'L\'utilisateur peut afficher le journal des activités',
    'Check All' => 'Sélectionner tout',
    'Uncheck All' => 'Désélectionner tout',
    'Weblog:' => 'Weblog:', 
    'Unheck All' => 'Tout décocher',
    'Add user to an additional weblog:' => 'Ajouter l\'utilisateur à un weblog supplémentaire:',
    'Select a weblog' => 'Sélectionnez un weblog',
    'Add' => 'Ajouter',
    'Profile' => 'Profil',
    'Save permissions for this author (s)' => 'Enregistrer les autorisations accordées à cet auteur',

    ## ./tmpl/cms/cfg_feedback.tmpl
    'Feedback Settings' => 'Paramétrages des Feedbacks',
    'This screen allows you to control the feedback settings for this weblog, including comments and TrackBacks.' => 'Cet écran vous permet de contrôler le paramétrage des feedbacks incluant commentaires et TrackBacks.',
    'Your feedback preferences have been saved.' => 'Vos préférences feedback sont enregistrées.',
    'Rebuild indexes' => 'Reconstruire les index',
    'Note: Commenting is currently disabled at the system level.' => 'Note: Les commentaires sont actuellement désactivés au niveau système.',
    'Comment authentication is not available because one of the needed modules, MIME::Base64 or LWP::UserAgent is not installed. Talk to your host about getting this module installed.' => 'L\'authetification de commentaire n\'est pas active car le module MIME::Base64 or LWP::UserAgent est absent. Contactez votre hébergeur pour l\'installation de ce module.',
    'Accept comments from' => 'Accepter les commentaires de',
    'Anyone' => 'Tous',
    'Authenticated commenters only' => 'Commentateurs authentifiés uniquement',
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
    'Note: You have selected to accept comments from authenticated commenters only but authentication is not enabled. In order to receive authenticated comments, you must enable authentication.' => 'Attention: vous avez sélectionné d\'accepter uniquement les commentaires de commentateurs identifiés MAIS l\'authentification n\'est pas activée. Vous devez l\'activer pour recevoir les commentaire à autoriser.',
    'Authentication is not enabled.' => 'Authentification non activée.',
    'Setup Authentication' => 'Mise en place de l\'Authentification',
    'Or, manually enter token:' => 'Ou, entrez manuellement le jeton:',
    'Authentication Token Inserted' => 'Jeton d\'authentification inseré',
    'Please click the Save Changes button below to enable authentication.' => 'Cliquez sur le bouton Enregistrer ci-dessous pour activer l\'authentification.',
    'Establish a link between your weblog and an authentication service. You may use TypeKey (a free service, available by default) or another compatible service.' => 'Etablir un lien entre votre weblog et un système d\'authentification. Vous pouvez utiliser TypeKey (service gratuit disponible par défaut) ou un autre service compatible.',
    'Require E-mail Address' => 'Adresse email requise',
    'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Si activé, le visiteur doit donner une adresse email valide pour commenter.',
    'Immediately publish comments from' => 'Publier immédiatement les commentaires de(s)',
    'Trusted commenters only' => 'Commentateurs fiables uniquement',
    'Any authenticated commenters' => 'Tout commentateur authentifié',
    'Specify what should happen to non-junk comments after submission.' => 'Spécifier ce qui doit ce passer pour les commentaires désirés après leur enregistrement.',
    'Unpublished comments are held for moderation.' => 'Les commentaires non publiés sont retenus pour modération.',
    'E-mail Notification' => 'Notification par email',
    'On' => 'Activé',
    'Only when attention is required' => 'Uniquement quand l\'attention est requise',
    'Off' => 'Désactivé',
    'Specify when Movable Type should notify you of new comments if at all.' => 'Spécifier quand Movable Type doit vous notifier les nouveaux commentaires.',
    'Allow HTML' => 'Autoriser le HTML',
    'If enabled, users will be able to enter a limited set of HTML in their comments. If not, all HTML will be stripped out.' => 'Si activé, le commentateur pourra entrer du HTML de façon limitée dans son commentaire. Sinon, le html ne sera pas pris en compte.',
    'Auto-Link URLs' => 'Liaison automatique des URL',
    'If enabled, all non-linked URLs will be transformed into links to that URL.' => 'Si activé, toutes les urls non liés seront transformées en url actives.',
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

    ## ./tmpl/cms/list_notification.tmpl
    'Below is the list of people who wish to be notified when you post to your site. To delete an address, check the Delete box and press the Delete button.' => 'Les personnes suivantes souhaitent être averties de la publication d\'une nouvelle note sur votre site. Vous pouvez supprimer une adresse en cochant la case Supprimer, puis en cliquant sur le bouton Supprimer.',
    'You have [quant,_1,user,users,no users] in your notification list.' => 'Votre liste de notifications contient [quant,_1,utilisateur,utilisateurs,0 utilisateur].',
    'You have added [_1] to your notification list.' => 'Vous avez ajouté [_1] à votre liste de notifications.',
    'You have successfully deleted the selected notifications from your notification list.' => 'Les avis sélectionnés ont été supprimés de la liste de notifications.',
    'Create New Notification' => 'Créer une nouvelle notification',
    'URL (Optional):' => 'URL (facultatif):',
    'Add Recipient' => 'Ajouter',
    'No notifications could be found.' => 'Aucune notification n\'a été trouvée.',

    ## ./tmpl/cms/show_upload_html.tmpl
    'Copy and paste this HTML into your entry.' => 'Copiez/collez ce code HTML dans votre note.',
    'Upload Another' => 'Télécharger un autre fichier',

    ## ./tmpl/cms/template_table.tmpl
    'Dynamic' => 'Dynamique',
    'Linked' => 'Lié',
    'Built w/Indexes' => 'Construits avec indexs',
    'Yes' => 'Oui',
    'No' => 'Non',

    ## ./tmpl/cms/login.tmpl
    'Your Movable Type session has ended. If you wish to log in again, you can do so below.' => 'Votre session Movable Type a été fermée. Pour ouvrir une nouvelle session voir ci-dessous.',
    'Your Movable Type session has ended. Please login again to continue this action.' => 'Votre session Movable Type a expiré. Merci de vous enregistrer à nouveau pour poursuivre.',
    'Password' => 'Mot de passe',
    'Remember me?' => 'Mémoriser les informations de connexion?',
    'Log In' => 'Connexion',
    'Forgot your password?' => 'Vous avez oublié votre mot de passe?',

    ## ./tmpl/cms/edit_category.tmpl
    'Use this page to edit the attributes of the category [_1]. You can set a description for your category to be used in your public pages, as well as configuring the TrackBack options for this category.' => 'Cette page permet de modifier les attributs de la catégorie [_1]. Vous pouvez indiquer une description, qui sera affichée sur votre site public, et configurer les options TrackBack pour cette catégorie.',
    'Your category changes have been made.' => 'Les modifications apportées ont été enregistrées.',
    'Category Label' => 'Etiquette Catégorie',
    'Category Description' => 'Description de la catégorie',
    'TrackBack Settings' => 'Paramètres TrackBack',
    'Outbound TrackBacks' => 'TrackBacks sortants',
    'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you post an entry in this category. (Separate URLs with a carriage return.)' => 'Saisissez l\'URL(s) du ou des site(s) web à qui vous souhaitez envoyer un TrackBack chaque fois que vous publiez un note dans cette catégorie. (Faire un passage à la ligne entre chaque URL.)',
    'Inbound TrackBacks' => 'TrackBacks entrants',
    'Accept inbound TrackBacks?' => 'Accepter les TrackBacks entrants?',
    'View the inbound TrackBacks on this category.' => 'Afficher les  TrackBacks entrants de cette catégorie.',
    'Passphrase Protection (Optional)' => 'Protection par mot de passe (facultatif)',
    'TrackBack URL for this category' => 'URL TrackBack pour cette catégorie',
    'This is the URL that others will use to send TrackBacks to your weblog. If you wish for anyone to send TrackBacks to your weblog when they have a post specific to this category, post this URL publicly. If you choose to only allow a select group of individuals to TrackBack, send this URL to them privately.' => 'Voici l\'URL que vos lecteurs utiliseront pour envoyer des TrackBacks sur votre weblog. Si vous souhaitez que quiconque puisse envoyer un TrackBack à votre weblog spécifiquement 
dans cette catégorie, publiez ouvertement cette URL. Si vous souhaitez que seules certaines personnes puissent le faire, envoyez cette URL à chacune d\'entre elles en mode privé.',
    'To include a list of incoming TrackBacks in your Main Index Template, check the documentation for template tags related to TrackBacks.' => 'Pour inclure une liste de Trackbacks entrants dans votre modèle d\'Index Principal, consultez la documentation sur les balises de modèles liés aux Trackbacks.',

    ## ./tmpl/cms/cc_return.tmpl

    ## ./tmpl/cms/bm_posted.tmpl
    'Your new entry has been saved to [_1]' => 'Votre nouvelle note a été enregistrée dans [_1]',
    ', and it has been posted to your site' => 'et a été publiée sur votre site',
    'View your site' => 'Voir votre site',
    'Edit this entry' => 'Modifier cette note',

    ## ./tmpl/cms/handshake_return.tmpl

    ## ./tmpl/cms/category_add.tmpl
    'Add A Category' => 'Ajouter une catégorie',
    'To create a new category, enter a title in the field below, select a parent category, and click the Add button.' => 'Pour créer une catégorie, indiquez un titre dans le champ ci-dessous, sélectionnez une catégorie parente, puis cliquez sur Ajouter.',
    'Category Title:' => 'Titre de la catégorie:',
    'Parent Category:' => 'Catégorie parente:',

    ## ./tmpl/cms/list_banlist.tmpl
    'IP Banning Settings' => 'Paramétrages des IP bannies',
    'This screen allows you to ban comments and TrackBacks from specific IP addresses.' => 'Cet écran vous permet de bannir commentaires et TrackBacks provenant d\'une adresse IP donnée.',
    'You have banned [quant,_1,address,addresses].' => 'Vous avez banni [quant,_1,address,addresses].',
    'You have added [_1] to your list of banned IP addresses.' => 'L\'adresse [_1] a été ajoutée à la liste des adresses IP bannies.',
    'You have successfully deleted the selected IP addresses from the list.' => 'L\'adresse IP sélectionnée a été supprimée de la liste.',
    'Ban New IP Address' => 'Bannir une nouvelle adresse IP',
    'IP Address:' => 'Adresse IP:',
    'Ban IP Address' => 'Bannir l\'adresse IP',
    'Date Banned' => 'Bannie le:',

    ## ./tmpl/cms/admin.tmpl
    'System Stats' => 'Statistiques système',
    'Active Authors' => 'Auteurs Actifs',
    'Version' => 'Version', 
    'Essential Links' => 'Liens essentiels',
    'System Information' => 'Informations système',
    'Your Account' => 'Votre compte',
    'Movable Type Home' => 'Accueil Movable Type',
    'Plugin Directory' => 'Annuaire des plugins',
    'Knowledge Base' => 'Base de connaissance',
    'Support and Documentation' => 'Support et Documentation',
    'Professional Network' => 'Réseau Professionnel',
    'System Overview' => 'Aperçu général du système',
    'From this screen, you can view information about and manage many aspects of your system across all weblogs.' => 'Cet écran vous permet de voir un certain nombre d\'informations concernant vos weblogs et le système dans leur ensemble.',

    ## ./tmpl/cms/list_ping.tmpl
    'Show pending TrackBacks' => 'Afficher les TrackBacks en attente',
    'The selected TrackBack(s) has been published.' => 'Le(s) TrackBack(s) sélectionné(s) ont été publié(s).',
    'The selected TrackBack(s) has been unpublished.' => 'Le(s) TrackBack(s) sélectionné(s) ont été enlevé(s) de la publication.',
    'The selected TrackBack(s) has been junked.' => 'Le(s) TrackBack(s) sélectionné(s) sont marqués indésirable(s).',
    'The selected TrackBack(s) has been unjunked.' => 'Le(s) TrackBack(s) sélectionné(s) ne sont plus marqué(s) indésirable(s).',
    'The selected TrackBack(s) has been deleted from the database.' => 'Le(s) TrackBack(s) sélectionné(s) ont été supprimé(s) de la base de données.',
    'No TrackBacks appeared to be junk.' => 'Aucun TrackBack n\'est marqué indésirable.',
    'Junk TrackBacks' => 'TrackBacks indésirables',
    'Show unpublished TrackBacks.' => 'Afficher les TrackBacks non publiés.',
    'Showing all TrackBacks.' => 'Affichage de tous les TrackBacks.',
    'Showing only TrackBacks where' => 'Affichage des TrackBacks où',
    'TrackBacks.' => 'les TrackBacks.',
    'TrackBacks where' => 'les TrackBacks dont',
    'No TrackBacks could be found.' => 'Aucun TrackBack n\'a été trouvé.',
    'No junk TrackBacks could be found.' => 'Aucun TrackBack indésirable n\'a été trouvé.',

    ## ./tmpl/cms/header.tmpl
    'Main Menu' => 'Menu principal',
    'Help' => 'Aide',
    'Welcome' => 'Bienvenue',
    'Logout' => 'Déconnexion',
    'Weblogs:' => 'Weblogs:', 
    'Go' => 'OK',
    'System-wide listing' => 'Listing sur la totalité du système',
    'Search (f)' => 'Recherche (f)',

    ## ./tmpl/cms/list_plugin.tmpl
    'Are you sure you want to reset the settings for this plugin?' => 'Etes-vous sur de vouloir réinitialiser les paramètres pour ce plugin?',
    'Disable plugin system?' => 'Désactiver le système de plugin?',
    'Disable this plugin?' => 'Désactiver ce plugin?',
    'Enable plugin system?' => 'Activer le système de plugin?',
    'Enable this plugin?' => 'Activer ce plugin?',
    'Plugin Settings' => 'Paramètres des plugins',
    'This screen allows you to control the weblog-level settings of any configurable plugins you\'ve installed.' => 'Cet écran vous permet de contrôler le niveau du weblog en matière de plugin installés.',
    'Your plugin settings have been saved.' => 'Les paramètres de votre plugin ont été enregistrés.',
    'Your plugin settings have been reset.' => 'Les paramètres de votre plugin on été réinitialisés.',
    'Your plugins have been reconfigured.' => 'Votre plugin a été reconfiguré.',
    'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => 'Vos plugins ont été reconfigurés. Si vous êtes sous mod_perl vous devez redémarrer votre serveur web pour la prise en compte de ces changements.',
    'Registered Plugins' => 'Plugins enregistrés',
    'To download more plugins, check out the' => 'Pour télécharger plus de plugins, consultez',
    'Six Apart Plugin Directory' => 'l\'Annuaire des plugins Six Apart',
    'Disable Plugins' => 'Désactiver les plugins',
    'Enable Plugins' => 'Activer les plugins',
    'Error' => 'Erreur',
    'Failed to Load' => 'Erreur de chargement',
    'Disable' => 'Désactiver',
    'Enabled' => 'Activé',
    'Disabled' => 'Désactivé',
    'Enable' => 'Activer',
    'Documentation for [_1]' => 'Documentation pour [_1]',
    'Documentation' => 'Documentation', 
    'Author of [_1]' => 'Auteur de [_1]',
    'More about [_1]' => 'En savoir plus sur [_1]',
    'Support' => 'Support', 
    'Plugin Home' => 'Accueil Plugin',
    'Resources' => 'Ressources',
    'Show Resources' => 'Afficher les ressources',
    'More Settings' => 'Paramétrages additionnels',
    'Show Settings' => 'Afficher les paramétrages',
    'Settings for [_1]' => 'Paramètres pour [_1]',
    'Resources Provided by [_1]' => 'Ressources fournies par [_1]',
    'Tags' => 'Tags', 
    'Tag Attributes' => 'Attributs de tag ',
    'Text Filters' => 'Filtres de texte',
    'Junk Filters' => 'Filtres d\'indésirables',
    '[_1] Settings' => '[_1] Paramètres',
    'Reset to Defaults' => 'Rénitialiser pour remettre les paramètres par défaut',
    'Plugin error:' => 'Erreur plugin:',
    'No plugins with weblog-level configuration settings are installed.' => 'Aucun plugin avec une configuration au niveau du weblog n\'est installé.',

    ## ./tmpl/cms/error.tmpl
    'An error occurred:' => 'Une erreur s\'est produite:',
    'Go Back' => 'Retour',

    ## ./tmpl/cms/list_comment.tmpl
    'The selected comment(s) has been published.' => 'Le(s) commentaire(s) sélectionné(s) ont été publié(s) correctement.',
    'The selected comment(s) has been unpublished.' => 'Le (s) commentaire(s) sélectionné(s) n\'ont pas été publié(s).',
    'The selected comment(s) has been junked.' => 'Le(s) commentaire(s) sélectionné(s) sont marqué(s) indésirable(s).',
    'The selected comment(s) has been unjunked.' => 'Le(s) commentaire(s) sélectionné(s) ne sont plus marqué(s) indésirable(s).',
    'The selected comment(s) has been deleted from the database.' => 'Les commentaires sélectionnés ont été supprimés de la base de données.',
    'No comments appeared to be junk.' => 'Aucun commentaire marqué indésirable.',
    'Go to Commenter Listing' => 'Aller à la liste des commentateurs',
    'Showing all comments.' => 'Affichage de tous les commentaires.',
    'Showing only comments where' => 'Affichage des commentaires où',
    'comments.' => 'les commentaires.',
    'comments where' => 'commentaires dont',
    'No comments could be found.' => 'Aucun commentaire n\'a été trouvé.',
    'No junk comments could be found.' => 'Aucun commentaire indésirable n\'a été trouvé.',

    ## ./tmpl/cms/system_info.tmpl
    'System Status and Information' => 'Statut du système et information',

    ## ./tmpl/cms/footer-popup.tmpl

    ## ./tmpl/cms/import_end.tmpl
    'All data imported successfully! Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Toutes les données ont été importées correctement! Assurez-vous de supprimer les fichiers importés du dossier \'importation\' ainsi lorsque vous recommencerez un processus d\'importation ces fichiers ne seront pas à nouveau importés.',
    'An error occurred during the import process: [_1]. Please check your import file.' => 'Une erreur s\'est produite pendant le processus: [_1]. Merci de vérifier vos fichiers import.',

    ## ./tmpl/cms/itemset_action_widget.tmpl
    'More actions...' => 'Plus d\'actions...',
    'No actions' => 'Aucune action',

    ## ./tmpl/cms/upload_confirm.tmpl
    'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'Le fichier \'[_1]\' existe déjî Souhaitez-vous le remplacer?',

    ## ./tmpl/cms/recover.tmpl
    'Your password has been changed, and the new password has been sent to your email address ([_1]).' => 'Votre mot de passe a été modifié et a été envoyé à votre adresse e-mail([_1]).',
    'Enter your Movable Type username:' => 'Indiquez votre nom d\'utilisateur Movable Type:',
    'Enter your password hint:' => 'Entrer votre pense-bête Mot de Passe:',
    'Recover' => 'Récupérer',

    ## ./tmpl/cms/install.tmpl
    'Welcome to Movable Type!' => 'Bienvenue sur Movable Type!',
    'Before you can begin blogging, we need to complete your installation by initializing your database.' => 'Avant de commencer à pouvoir bloguer vous devez terminer votre installation en initialisation votre base de données.',
    'Finish Install' => 'Finir l\'installation ',

    ## ./tmpl/cms/rebuilt.tmpl
    'All of your files have been rebuilt.' => 'Tous vos fichiers ont été actualisés.',
    'Your [_1] has been rebuilt.' => 'Votre [_1] a été actualisé(e).',
    'Your [_1] pages have been rebuilt.' => 'Vos pages [_1] ont été actualisées.',
    'View this page' => 'Afficher cette page',
    'Rebuild Again' => 'Actualiser une nouvelle fois',

    ## ./tmpl/cms/upload_complete.tmpl
    'Your file has been uploaded. Size: [quant,_1,byte].' => 'Votre fichier a été téléchargé. Taille: [quant,_1,octet].',
    'Create a new entry using this uploaded file' => 'Créer une note à l\'aide de ce fichier téléchargé.',
    'Show me the HTML' => 'Afficher le code HTML',
    'Image Thumbnail' => 'Vignette',
    'Create a thumbnail for this image' => 'Créer une vignette pour cette image',
    'Width:' => 'Largeur:',
    'Pixels' => 'Pixels', 
    'Percent' => 'Pourcentage',
    'Height:' => 'Hauteur:',
    'Constrain proportions' => 'Contraindre les proportions',
    'Would you like this file to be a:' => 'Ce fichier doit être:',
    'Popup Image' => 'Image dans une fenêtre popup',
    'Embedded Image' => 'Image intégrée à la note',

    ## ./tmpl/cms/list_template.tmpl
    'Index Templates' => 'Modèles d\'index',
    'Index templates produce single pages and can be used to publish Movable Type data or plain files with any type of content. These templates are typically rebuilt automatically upon saving entries, comments and TrackBacks.' => 'Les modèle d\'Index génèrent des pages uniques et peuvent être utilisées pour publier des données Movable Type ou des fichiers quel que soit leur contenu. Ces modèles sont généralement reconstruits automatiquement en sauvegardant les notes, commentaires ou TrackBacks.',
    'Archive Templates' => 'Modèles d\'archives ',
    'Archive templates are used for producing multiple pages of the same archive type.  You can create new ones and map them to archive types on the publishing settings screen for this weblog.' => 'Les modèles d\'archives sont utilisés pour produire des pages multiples d\'un même type d\'archives. Vous pouvez en créer de nouvelles et les relier aux type d\'archives sur l\'écran des paramètres de publication de ce weblog.',
    'System Templates' => 'Modèles Système',
    'System templates specify the layout and style of a small number of dynamic pages which perform specific system functions in Movable Type.' => 'Les modèles Systèmes spécifient la mise en page d\'un petit nombre de pages dynamiques qui réalisent des fonctions système spécifiques à Movable Type.',
    'Template Modules' => 'Modules de modèles',
    'Template modules are mini-templates that produce nothing on their own but instead can be included into other templates.  They are excellent for duplicated content (e.g. header or footer content) and can contain template tags or just static text.' => 'Les modules de modèles sont des mini-modèles qui ne produisent rien en soi mais peuvent être inclus dans d\'autres modèles. Ils sont très utiles pour dupliquer un contenu (par exemple le contenu des entêtes et pieds de page) et peuvent inclure des tags de modèles ou simplement du texte.',
    'You have successfully deleted the checked template(s).' => 'Les modèles sélectionnés ont été supprimés.',
    'Your settings have been saved.' => 'Vos paramètres ont été enregistrés.',
    'Indexes' => 'Index',
    'Modules' => 'Modules', 
    'Go to Publishing Settings' => 'Aller aux paramètres de publication',
    'Create new index template' => 'Créer un nouveau modèle d\'index',
    'Create New Index Template' => 'Créer un nouveau Modèle d\'Index',
    'Create new archive template' => 'Créer un modèle d\'archive',
    'Create New Archive Template' => 'Créer un nouveau Modèle d\'Archives',
    'Create new template module' => 'Créer un module de modèle',
    'Create New Template Module' => 'Créer un nouveau Module de Modèle',
    'No index templates could be found.' => 'Aucun Modèle d\'Index n\'a été trouvé.',
    'No archive templates could be found.' => 'Aucun Modèle d\'Archives n\'a été trouvé.',
    'Description' => 'Description', 
    'No template modules could be found.' => 'Aucun Module de Modèle n\'a été trouvé.',

    ## ./tmpl/cms/cfg_system_feedback.tmpl
    'This screen allows you to configure feedback and outbound TrackBack settings for the entire installation.  These settings override any similar settings for individual weblogs.' => 'Cet écran vous permet de configurer les paramètres des feedbacks et des TrackBacks sortants pour l\'ensemble de l\'installation. Ces paramètres priment sur les paramétrages que vous auriez pu faire sur un weblog donné.',
    'Feedback Master Switch' => 'Contrôle principal des Feedbacks',
    'Disable Comments' => 'Désactiver les commentaires',
    'Stop accepting comments on all weblogs' => 'Ne plus accepter les commentaires sur TOUS les weblogs',
    'This will override all individual weblog comment settings.' => 'Cette action prime sur tout paramétrage des commentaires mis en place au niveau de chaque weblog.',
    'Disable TrackBacks' => 'Désactiver les TrackBacks',
    'Stop accepting TrackBacks on all weblogs' => 'Ne plus accepter les TrackBacks sur TOUS vos weblogs',
    'This will override all individual weblog TrackBack settings.' => 'Cette action prime sur tout paramétrage des TrackBacks mis en place au niveau de chaque weblog.',
    'Outbound TrackBack Control' => 'Contrôle des TrackBacks sortants',
    'Allow outbound TrackBacks to:' => 'Autoriser les TrackBacks sortant sur:',
    'Any site' => 'N\'importe quel site',
    'No site' => 'Aucun site',
    '(Disable all outbound TrackBacks.)' => '(Désactiver tous les TrackBacks sortants.)',
    'Only the weblogs on this installation' => 'Uniquement les weblogs sur cette installation',
    'Only the sites on the following domains:' => 'Uniquement les sites sur les domaines suivants:',
    'This feature allows you to limit outbound TrackBacks and TrackBack auto-discovery for the purposes of keeping your installation private.' => 'Cette fonctionnalité vous permet de limiter les TrackBacks sortants et la découverte automatique des TrackBacks pour conserver la confidentialité de votre installation.',

    ## ./tmpl/cms/edit_author.tmpl
    'Your API Password is currently' => 'Le mot de passe de votre API est',
    'Author Profile' => 'Profil de l\'auteur',
    'Your profile has been updated.' => 'Votre profil a été mis à jour.',
    'Weblog Associations' => 'Associations de Weblogs',
    'Create Weblogs' => 'Créer des Weblogs',
    'Username:' => 'Nom D\'utilisateur:',
    'The name used by this author to login.' => 'Le nom utilisé par cet Auteur pour s\'enregistrer.',
    'Display Name:' => 'Afficher nom:',
    'The author\'s published name.' => 'Nom publié de l\'auteur.',
    'The author\'s email address.' => 'Adresse email de l\'auteur .',
    'Website URL:' => 'URL du site:',
    'The URL of this author\'s website. (Optional)' => 'URL du site de  l\'auteur. (option)',
    'Language:' => 'Langue:',
    'The author\'s preferred language.' => 'Langue choisie par l\'auteur.',
    'Current Password:' => 'Mot de passe actuel:',
    'Enter the existing password to change it.' => 'Entrez le mot de passe actuel pour le changer.',
    'New Password:' => 'Nouveau Mot de Passe:',
    'Initial Password:' => 'Mot de Passe:',
    'Select a password for the author.' => 'Choisissez un mot de passe pour  l\'auteur.',
    'Password Confirm:' => 'Confirmation du Mot de Passe:',
    'Repeat the password for confirmation.' => 'Répetez la confirmation de Mot de passe.',
    'Password hint:' => 'Pense-bête du Mot de Passe :',
    'For password recovery.' => 'Pour récupérer votre mot de passe.',
    'API Password:' => 'Mot de Passe API:',
    'Reveal' => 'Révélé',
    'For use with XML-RPC and Atom-enabled clients.' => 'Pour une utilisation avec des clients XML-RPC et Atom.',
    'Save this author (s)' => 'Sauvegarder cet auteur (s)',

    ## ./tmpl/cms/upgrade_runner.tmpl
    'Installation complete.' => 'Installation terminée.',
    'Upgrade complete.' => 'Mise à jour terminée.',
    'Initializing database...' => 'Initialisation de la base de données...',
    'Upgrading database...' => 'Mise à jour de la base de données...',
    'Starting installation...' => 'Début de l\'installation...',
    'Starting upgrade...' => 'Début de la mise à jour...',
    'Error during installation:' => 'Erreur lors de l\'installation:',
    'Error during upgrade:' => 'Erreur lors de la mise à jour:',
    'Installation complete!' => 'Installation terminée!',
    'Upgrade complete!' => 'Mise à jour terminée!',
    'Login to Movable Type' => 'S\'enregistrer dans Movable Type',
    'Return to Movable Type' => 'Retourner à Movable Type',
    'Your database is already current.' => 'Votre base de données est déjà actualisée.',

    ## ./tmpl/cms/bm_entry.tmpl
    'Select' => 'Sélectionner',
    'You must choose a weblog in which to post the new entry.' => 'Vous devez sélectionner le weblog dans lequel publier cette note.',
    'Send an outbound TrackBack:' => 'Envoyer un TrackBack:',
    'Select an entry to send an outbound TrackBack:' => 'Choisissez une note pour envoyer un TrackBack:',
    'Select a weblog for this post:' => 'Sélectionnez un weblog pour cette note:',
    'You do not have entry creation permission for any weblogs on this installation. Please contact your system administrator for access.' => 'Vous n\'avez pas accès à la création de weblog dans cette installation. Merci de contacter votre Administrateur Système pour avoir un accès.',

    ## ./tmpl/cms/overview-left-nav.tmpl
    'List Weblogs' => 'Liste des Weblogs',
    'List Authors' => 'Liste des Auteurs',
    'List Plugins' => 'Liste des Plugins',
    'Aggregate' => 'Multi-Blogs',
    'Edit System Settings' => 'Editer les Paramètres Système',
    'Show Activity Log' => 'Afficher les logs d\'activité',

    ## ./tmpl/cms/comment_actions.tmpl
    'comment' => 'commentaire',
    'comments' => 'commentaires',
    'Publish selected comments (p)' => 'Publier les commentaires sélectionnés (p)',
    'Delete selected comments (d)' => 'Effacer les commentaires sélectionnés (d)',
    'Junk selected comments (j)' => 'Commentaires sélectionnés indésirables (j)',
    'Recover selected comments (j)' => 'Récupérer les commentaires sélectionnés (j)',

    ## ./tmpl/cms/system_list_blog.tmpl
    'Below you find a list of all weblogs in the system with links to the main weblog page and individual settings pages for each.  You may also create or delete blogs from this screen.' => 'Ci-dessous la liste des weblogs du système avec un lien vers leur page principale et leur page de paramètres individuels. Vous avez la possibilité de créer ou supprimer un weblog à partir de cette page.',
    'You have successfully deleted the blogs from the Movable Type system.' => 'Le blog a été correctement supprimé du système Movable Type.',
    'Create New Weblog' => 'Créer un nouveau Weblog',
    'No weblogs could be found.' => 'Aucun weblog n\'a été trouvé.',

    ## ./tmpl/cms/cfg_archives.tmpl
    'Publishing Settings' => 'Paramètres de publication',
    'This screen allows you to control this weblog\'s publishing paths and preferences, as well as archive mapping settings.' => 'Cet écran vous permet de contrôler les chemins de publication, les préférences et les paramètres d\'archives de ce weblog.',
    'Go to Templates Listing' => 'Aller à la liste des modèles',
    'Go to Template Listing' => 'Aller à la liste des modèles',
    'Error: Movable Type was not able to create a directory for publishing your weblog. If you create this directory yourself, assign sufficient permissions that allow Movable Type to create files within it.' => 'Erreur: Movable Type n\'a pas pu créer le dossier pour publier ce weblog.  Si vous créez ce dossier vous même, assigner suffisamment d\'autorisations à Movable Type pour y créer des fichiers.',
    'Your weblog\'s archive configuration has been saved.' => 'La configuration des archives de votre weblog a été enregistrée.',
    'You may need to update your templates to account for your new archive configuration.' => 'Vous devrez peut-être mettre à jour votre habillage pour pour obtenir votre nouvelle configuration d\'archives.',
    'You have successfully added a new archive-template association.' => 'L\'association modèle/archive a réussi.',
    'You may need to update your \'Master Archive Index\' template to account for your new archive configuration.' => 'Vous aurez peut-être besoin de mettre à jour votre habillage \'Index principal des archives\' pour activer la nouvelle configuration de vos archives.',
    'The selected archive-template associations have been deleted.' => 'Les associations modèle/archive sélectionnées ont été supprimées.',
    'Publishing Paths' => 'Chemins de publication',
    'Enter the URL of your website. Do not include a filename (i.e. exclude index.html).' => 'Entrer l\'url de votre site. Ne pas inclure le nom de fichier (ne pas mettre par exemple: index.html).',
    'Site Root:' => 'Racine site:',
    'Enter the path where your index files will be published. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'Entrer le chemin où votre fichier index sera publié. Un chemin absolu (commençant par \'/\') est recommandé, mais vous pouvez aussi utiliser un chemin relatif vers le repertoire Movable Type.',
    'Advanced Archive Publishing:' => 'Publication Avancée des Archives:',
    'Publish archives to alternate root path' => 'Publier les archives sur un chemin racine alternatif',
    'Select this option only if you need to publish your archives outside of your Site Root.' => 'Sélectionnez cette option si vous avez besoin de publier vos archives en dehors de la racine du Site.',
    'Archive URL:' => 'URL des archives:',
    'Enter the URL of the archives section of your website.' => 'Entrer l\'URL de la section Archives de votre site.',
    'Archive Root:' => 'Racine Archive:',
    'Enter the path where your archive files will be published.' => 'Entrer le chemin de l\'endroit où seront publiées vos archives.',
    'Publishing Preferences' => 'Préférences de Publication',
    'Preferred Archive Type:' => 'Type d\'archive préféré:',
    'No Archives' => 'Pas d\'archive',
    'Individual' => 'Individuel',
    'Daily' => 'Quotidien',
    'Weekly' => 'Hebdomadaire',
    'Monthly' => 'Mensuel',
    'When linking to an archived entry&#8212;for a permalink, for example&#8212;you must link to a particular archive type, even if you have chosen multiple archive types.' => 'Lorsque vous établissez un hyperlien vers une note archivée, comme pour un permalien, vous devez créer le lien vers un type d\'archive spécifique, même si vous avez choisi plusieurs types d\'archive.',
    'File Extension for Archive Files:' => 'Extension de fichier pour les archives:',
    'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'Entrez l\'extension du fichier d\'archive. Elle peut être au choix \'html\', \'shtml\', \'php\', etc. NB: Ne pas indiquer la période (\'.\').',
    'Dynamic Publishing:' => 'Publication Dynamique:',
    'Build all templates statically' => 'Construire chaque modèle de manière statique',
    'Build only Archive Templates dynamically' => 'Construire uniquement les Modèles d\'Archive dynamiquement',
    'Set each template\'s Build Options separately' => 'Mettre en place les Options de Construction des modèles individuellement',
    'Archive Mapping' => 'Table de correspondance des archives',
    '_USAGE_ARCHIVE_MAPS' => 'Cette fonctionnalité avancée vous permet de faire correspondre un modèle d\'archives à plusieurs types d\'archives. Par exemple, vous pouvez decider de créer deux vues différentes pour vos archives mensuelles : une pour les notes d\'un mois donné, présentées en liste, une autre affichant les notes sur un calendrier mensuel.',
    'Create New Archive Mapping' => 'Créer une nouvelle table de correspondance des archives',
    'Archive Type:' => 'Type d\'archive:',
    'INDIVIDUAL_ADV' => 'par note',
    'DAILY_ADV' => 'de façon quotidienne',
    'WEEKLY_ADV' => 'hebdomadaire',
    'MONTHLY_ADV' => 'par mois',
    'CATEGORY_ADV' => 'par catégorie',
    'Template:' => 'Modèle:',
    'Archive Types' => 'Types d\'archive',
    'Template' => 'Modèle',
    'Archive File Path' => 'Chemin vers les Fichiers Archive',
    'Preferred' => 'Préféré',
    'Custom...' => 'Personnalisé...',
    'archive map' => 'Association d\'archive',
    'archive maps' => 'Associations d\'archive',

    ## ./tmpl/cms/rebuilding.tmpl
    'Rebuilding [_1]' => 'Actualisation de [_1]',
    'Rebuilding [_1] pages [_2]' => 'Actualisation des pages [_1] [_2]',
    'Rebuilding [_1] dynamic links' => 'Recontruction [_1] des liens dynamiques',
    'Rebuilding [_1] pages' => 'Actualisation des pages [_1]',

    ## ./tmpl/cms/upload.tmpl
    'Choose a File' => 'Choisir un fichier',
    'To upload a file to your server, click on the browse button to locate the file on your hard drive.' => 'Cliquez sur le bouton Parcourir pour sélectionner un fichier de votre disque dur à télécharger vers le serveur.',
    'File:' => 'Fichier:',
    'Choose a Destination' => 'Choisir une destination',
    'Upload Into:' => 'Télécharger dans:',
    '(Optional)' => '(facultatif)',
    'Local Archive Path' => 'Chemin local des archives',
    'Local Site Path' => 'Chemin local du site',
    'Upload' => 'Télécharger',

    ## ./tmpl/cms/upgrade.tmpl
    'Time to Upgrade!' => 'Il est temps de mettre à jour!',
    'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Une nouvelle version de Movable Type a été installée. Nous avons besoin de faire quelques manipulations complémentaires pour mettre à jour votre base de données.',
    'Begin Upgrade' => 'Commencer la Mise à Jour',

    ## ./tmpl/cms/menu.tmpl
    'Five Most Recent Entries' => 'Les 5 notes les plus récentes',
    'View all Entries' => 'Afficher toutes les notes',
    'Five Most Recent Comments' => 'Cinq commentaires les plus récents',
    'View all Comments' => 'Afficher tous les commentaires',
    'Five Most Recent TrackBacks' => 'Cinq TrackBacks les plus récents',
    'View all TrackBacks' => 'Afficher tous les TrackBacks',
    'Welcome to [_1].' => 'Bienvenue sur [_1].',
    'You can post to and manage your weblog by selecting an option from the menu located to the left of this message.' => 'Vous pouvez publier sur votre weblog ou bien le gérer en sélectionnant une option du menu situé à gauche de ce message.',
    'If you need assistance, try:' => 'Si vous avez besoin d\'aide, vous pouvez consulter:',
    'Movable Type User Manual' => 'Mode d\'emploi de Movable Type',
    'Movable Type Technical Support' => 'Support Technique Movable Type',
    'Movable Type Support Forum' => 'Forum de support de Movable Type',
    'This welcome message is configurable.' => 'Vous pouvez modifier ce message d\'accueil.',
    'Change this message.' => 'Changer ce message.',

    ## ./tmpl/email/new-ping.tmpl
    'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Un Trackback non approuvé a été envoyé pour votre weblog [_1], pour la note #[_2] ([_3]). Vous devez l\'approuver pour qu\'il apparaisse sur votre blog.',
    'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Un Trackback non approuvé a été envoyé pour votre weblog [_1], pour la catégorie #[_2], ([_3]). Vous devez l\'approuver pour qu\'il apparaisse sur votre blog.',
    'Approve this TrackBack:' => 'Approuver ce TrackBack:',
    'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Un nouveau Trackback a été envoyé sur votre blog [_1], sur la note #[_2] ([_3]).',
    'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'Un nouveau Trackback a été envoyé sur votre blog [_1], sur la catégorie #[_2] ([_3]).',
    'View this TrackBack:' => 'Voir ce TrackBack:',
    'Edit this TrackBack:' => 'Modifier ce TrackBack:',
    'Title:' => 'Titre:',
    'Excerpt:' => 'Extrait:',

    ## ./tmpl/email/new-comment.tmpl
    'An unapproved comment has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => 'Un commentaire non approuvé a été envoyé sur votre blog [_1], pour la note #[_2] ([_3]). Vous devez l\'approuver pour qu\'il apparaisse sur votre blog.',
    'Approve this comment:' => 'Approuver ce commentaire:',
    'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Un nouveau commentaire a été publié sur votre weblog [_1], au sujet de la note [_2] ([_3]). ',
    'View this comment:' => 'Afficher ce commentaire:',
    'Edit this comment:' => 'Modifier ce commentaire:',

    ## ./tmpl/email/verify-subscribe.tmpl
    'If the link is not clickable, just copy and paste it into your browser.' => 'Si le lien n\'est pas cliquable, faites simplement un copier-coller dans votre navigateur.',

    ## ./extras/examples/plugins/mirror/mirror.pl

    ## ./extras/examples/plugins/mirror/tmpl/mirror.tmpl

    ## Other phrases, with English translations.
    'WEEKLY_ADV' => 'hebdomadaire',
    'Unpublish Comment(s)' => 'Annuler publication commentaire(s)',
    '_SYSTEM_TEMPLATE_COMMENT_PENDING' => 'Visible quand un commentateur fait un aperçu de son commentaire',
    'RSS 1.0 Index' => 'Index RSS 1.0',
    'Manage Categories' => 'Gérer les Catégories',
    '_USAGE_BOOKMARKLET_4' => 'QuickPost vous permet de publier vos notes à partir de n\'importe quel point du web. Vous pouvez, en cours de consultation d\'une page que vous souhaitez mentionner, cliquez sur QuickPost pour ouvrir une fenêtre popup contenant des options Movable Type spéciales. Cette fenêtre vous permet de sélectionner le weblog dans lequel vous souhaitez publier la note, puis de la créer et de la publier.',
    '_USAGE_ARCHIVING_2' => 'Lorsque vous associez plusieurs modèles à un type d\'archive particulier -- ou même lorsque vous n\'en associez qu\'un seul -- vous pouvez personnaliser le chemin des fichiers d\'archive à l\'aide des modèles correspondants.',
    'UTC+11' => 'UTC+11', 
    'View Activity Log For This Weblog' => 'Voir le journal d\'activité pour ce weblog',
    'DAILY_ADV' => 'de façon quotidienne',
    '_USAGE_PERMISSIONS_3' => 'Il existe deux façons d\'accorder ou de révoquer les privilèges d\'accès affectés aux utilisateurs. La première est de sélectionner un utilisateur parmi ceux du menu ci-dessous et de cliquer sur Modifier. La seconde est de consulter la liste de tous les auteurs, puis de sélectionner l\'auteur que vous souhaitez modifier ou supprimer.',
    '_USAGE_NOTIFICATIONS' => 'Les personnes suivantes souhaitent être averties de la publication d\'une nouvelle note sur votre site. Vous pouvez ajouter un utilisateur en indiquant son adresse e-mail dans le formulaire suivant. L\'adresse URL est facultative. Pour supprimer un utilisateur, cochez la case Supprimer dans le tableau ci-dessous, puis cliquez sur le bouton Supprimer.',
    'Manage Notification List' => 'Gérer la liste de notification',
    'Individual' => 'Individuel',
    '_USAGE_COMMENTERS_LIST' => 'Cette liste est la liste des auteurs de commentaires pour [_1].',
    'RSS 2.0 Index' => 'Index RSS 2.0',
    '_USAGE_LIST' => 'Cette liste est la liste des notes de [_1]. Vous pouvez modifier ces notes en cliquant sur le nom correspondant. Vous pouvez filtrer les notes en sélectionnant la catégorie, l\'auteur ou l\'état dans le premier menu déroulant. Utilisez ensuite le second menu déroulant pour mieux cibler la sélection. Utilisez le menu déroulant sous le tableau des notes pour sélectionner le nombre de notes à afficher.',
    '_USAGE_BANLIST' => 'Cette liste est la liste des adresses IP qui ne sont pas autorisées à publier de commentaires ou envoyer des pings TrackBack à votre site. Vous pouvez ajouter une nouvelle adresse IP dans le formulaire suivant. Pour supprimer une adresse de la liste des adresses IP bannies, cochez la case Supprimer dans le tableau ci-dessous, puis cliquez sur le bouton Supprimer.',
    '_ERROR_DATABASE_CONNECTION' => 'Les paramètres de votre base de données sont soit invalides, absents ou ne peuvent pas être lus correctement. Consultez la base de connaissances pour plus d\'informations.',
    'Configure Weblog' => 'Configurer le Weblog',
    '_USAGE_AUTHORS' => 'Cette liste est la liste de tous les utilisateurs du système Movable Type. Vous pouvez changer les droits accordés à un auteur en cliquant sur son nom et supprimer un auteur en cochant la case <b>Supprimer</b>, puis en cliquant sur Supprimer. Remarque: si vous ne souhaitez supprimer un auteur que d\'un weblog spécifique, il vous suffit de changer les droits qui lui sont accordés ; la suppression d\'un auteur affecte tout le système.',
    '_USAGE_FEEDBACK_PREFS' => 'Cette page vous permet de configurer les manières dont un lecteur peut contribuer sur votre weblog',
    '_USAGE_COMMENTS_LIST_ALL_WEBLOGS' => 'Voilà une liste de  commentaires pour tous les weblogs que vous pouvez filtrer, gérer et éditer.',
    '_USAGE_NEW_AUTHOR' => ' A partir de cette page vous pouvez créer de nouveaux auteurs dans le système et définir leurs accès dans les weblogs',
    '_USAGE_FORGOT_PASSWORD_2' => 'Ce nouveau mot de passe devrait vous permettre d\'ouvrir une session Movable Type. Vous pourrez changer ce mot de passe une fois la session ouverte.',
    '_USAGE_COMMENT' => 'Modifiez le commentaire sélectionné. Cliquez sur Enregistrer une fois les modifications apportées. Vous devrez actualiser vos fichiers pour voir les modifications reflétées sur votre site.',
    '_USAGE_FORGOT_PASSWORD_1' => 'Vous avez demandé à récupérer votre mot de passe Movable Type. Votre mot de passe a été changé au niveau du système ; le nouveau mot de passe est le suivant:',
    '_USAGE_EXPORT_2' => 'Pour exporter vos notes: cliquez sur le lien ci-dessous (Exporter les notes de [_1]). Pour enregistrer les données exportées dans un fichier, vous pouvez enfoncer la touche <code>option</code> (Macintosh) ou <code>Maj</code> (Windows) et la maintenir enfoncée tout en cliquant sur le lien. Vous pouvez également sélectionner toutes les données et les copier dans un autre document. <a href="#" onclick="openManual(\'importing\', \'export_ie\');return false;">Vous exportez des données depuis Internet Explorer?</a>',
    '_SYSTEM_TEMPLATE_POPUP_IMAGE' => 'Affiché quand un visiteur clique sur une image Pop up', 
    '_USAGE_PING_LIST_ALL_WEBLOGS' => 'Voici une liste de Ping de Trackback pour tous les weblogs que vous pouvez filtrer, gérer et éditer.',
    '_SYSTEM_TEMPLATE_DYNAMIC_ERROR' => 'Affiché quand une erreur est rencontrée dans une page blog dynamique',
    'Publish Entries' => 'Publier les notes',
    'Date-Based Archive' => 'Archivage par date',
    'Unban Commenter(s)' => 'Réautoriser le commentateur',
    'Individual Entry Archive' => 'Archivage par note',
    'Daily' => 'Quotidien',
    'Unpublish Entries' => 'Annuler publication',
    '_USAGE_PING_LIST' => 'Cette liste est la liste des pings pour [_1].',
    '_USAGE_UPLOAD' => 'Vous pouvez télécharger le fichier ci-dessus dans le chemin local de votre site <a href="javascript:alert(\'[_1]\')">(?)</a> ou dans le chemin des archives de votre site <a href="javascript:alert(\'[_2]\')">(?)</a>. Vous pouvez également télécharger le fichier dans un répertoire compris dans les répertoires mentionnés ci-dessus, en spécifiant le chemin dans les champs de droite (<i>images</i>, par exemple). Les répertoires qui n\'existent pas encore seront créés.',
    '_USAGE_LIST_ALL_WEBLOGS' => ' Voici la liste des notes pour tous les weblogs que vous pouvez filtrer, gérer et éditer.',
    '_USAGE_REBUILD' => 'Vous devrez cliquer sur <a href="#" onclick="doRebuild()">Actualiser</a> pour voir les modifications reflétées sur votre site publiî',
    'Blog Administrator' => 'Administrateur Blog',
    'CATEGORY_ADV' => 'par catégorie',
    'Dynamic Site Bootstrapper' => 'Initialisateur de site dynamique',
    '_USAGE_PLUGINS' => 'Voici la liste des tous les Plug Ins actuellement enregistrés avec Movable type.',
    'Category Archive' => 'Archivage par catégorie',
    '_USAGE_PERMISSIONS_2' => 'Vous pouvez modifier les permissions affectées à un utilisateur en sélectionnant ce dernier dans le menu déroulant, puis en cliquant sur Modifier.',
    '_USAGE_EXPORT_1' => 'L\'exportation de vos notes de Movable Type vous permet de créer une <b>version de sauvegarde</b> du contenu de votre weblog. Le format des notes exportées convient à leur importation dans le système à l\'aide du mécanisme d\'importation (voir ci-dessus), ce qui vous permet, en plus d\'exporter vos notes à des fins de sauvegarde, d\'utiliser cette fonction pour <b>transférer vos notes d\'un weblog à un autre</b>.',
    'Untrust Commenter(s)' => 'Retirer statut fiable au commentateur',
    '_SYSTEM_TEMPLATE_PINGS' => 'Affiché quand les PopUps de Trackbacks sont désactivés', 
    'Entry Creation' => 'Création d\'une note',
    '_USAGE_PROFILE' => 'Cet espace permet de changer votre profil d\'auteur. Les modifications apportées à votre nom d\'utilisateur et à votre mot de passe sont automatiquement mises à jour. En d\'autres termes, vous devrez ouvrir une nouvelle session.',
    'Category' => 'Catégorie',
    'Atom Index' => 'Index Atom',
    '_USAGE_PLACEMENTS' => 'Les outils d\'édition permettent de gérer les catégories secondaires auxquelles cette note est associée. La liste de gauche contient les catégories auxquelles cette note n\'est pas encore associée en tant que catégorie principale ou catégorie secondaire ; la liste de droite contient les catégories secondaires auxquelles cette note est associée.',
    '_USAGE_ENTRYPREFS' => 'La configuration des champs détermine les champs de saisie qui apparaîtront dans les écrans de création et de modification des notes. Vous pouvez sélectionner une configuration existante (basique ou avancée), ou personnaliser vos écrans en activant le bouton Personnalisée, puis en sélectionnant les champs que vous souhaitez voir apparaître.',
    '_USAGE_COMMENTS_LIST' => 'Cette liste est la liste des commentaires associés à [_1]. Vous pouvez modifier les commentaires en cliquant sur le texte correspondant. Vous pouvez cliquer sur une des valeurs affichées dans la liste pour filtrer les notes.',
    '_THROTTLED_COMMENT_EMAIL' => 'Un visiteur de votre weblog [_1] a été automatiquement bannit après avoir publié une quantité de commentaires supérieure à la limite établie au cours des [_2] secondes. Cette opération est destinée à empêcher la publication automatisée de commentaires par des scripts. L\'adresse IP bannie est

    [_3]

S\'il s\'agit d\'une erreur, vous pouvez annuler le bannissement de l\'adresse IP dans Movable Type, sous Configuration du weblog > Bannissement d\'adresses IP, et en supprimant l\'adresse IP [_4] de la liste des addresses bannies.',
    'Stylesheet' => 'Feuille de style',
    'RSD' => 'RSD', 
    'MONTHLY_ADV' => 'par mois',
    'Trust Commenter(s)' => 'Donner statut fiable au commentateur',
    '_SYSTEM_TEMPLATE_COMMENT_PREVIEW' => 'Affiché quand un commentateur consulte un aperçu de  son commentaire', 
    '_THROTTLED_COMMENT' => 'Dans le but de réduire les possibilités d\'abus, j\'ai activé une fonction obligeant les auteurs de commentaires à attendre quelques instants avant de publier un autre commentaire. Veuillez attendre quelques instants avant de publier un autre commentaire. Merci.',
    'Manage Templates' => 'Gérer les Modèles',
    '_USAGE_BOOKMARKLET_3' => 'Pour installer le signet QuickPost de Movable Type: déposez le lien suivant dans le menu ou la barre d\'outils des liens favoris de votre navigateur.',
    '_USAGE_SEARCH' => 'Vous pouvez utiliser l\'outil de recherche et de remplacement pour effectuer des recherches dans vos notes ou pour remplacer chaque occurrence d\'un mot, d\'une phrase ou d\'un caractère par un autre. Important: faites preuve de prudence, car <b>il n\'existe pas de fonction d\'annulation</b>. Nous vous recommandons même d\'exporter vos notes Movable Type, juste au cas où.',
    '_USAGE_BOOKMARKLET_2' => 'La structure de la fonction QuickPost de Movable Type vous permet de personnaliser la mise en page et les champs de votre page QuickPost. Par exemple, vous pouvez ajouter une option d\'ajout d\'extraits par l\'intermédiaire de la fenêtre QuickPost. Une fenêtre QuickPost comprend, par défaut, les éléments suivants: un menu déroulant permettant de sélectionner le weblog dans lequel publier la note ; un menu déroulant permettant de sélectionner l\'état de publication (brouillon ou publié) de la nouvelle note ; un champ de saisie du titre de la note ; et un champ de saisie du corps de la note.',
    '_USAGE_PERMISSIONS_1' => 'Vous à *tes en train de modifier les droits de <b>[_1]</b>. Vous trouverez ci-dessous la liste des weblogs pour lesquels vous pouvez contrC4ler les auteurs ; pour chaque weblog de la liste, vous pouvez affecter des droits à <b>[_1]</b> en cochant les cases correspondant aux options souhaitées.',
    '_AUTO' => '1',
    '_USAGE_LIST_POWER' => 'Cette liste est la liste des notes de [_1] en mode d\'édition par lots. Le formulaire ci-dessous vous permet de changer les valeurs des notes affichées ; cliquez sur le bouton Enregistrer une fois les modifications souhaitées effectuées. Les fonctions de la liste Notes existantes fonctionnent en mode de traitement par lots comme en mode standard.',
    '_ERROR_CONFIG_FILE' => 'Votre fichier configuration Movable type est absent ou ne peut pas être lu correctement. Merci de consulter la base de connaissances', 
    '_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.org/sitefr/">Movable Type <$MTVersion$></a>',
    'Monthly' => 'Mensuel',
    '_USAGE_ARCHIVING_1' => 'Sélectionnez les fréquences/types de mise en archives du contenu de votre site. Vous pouvez, pour chaque type de mise en archives que vous choisissez, affecter plusieurs modèles devant être appliqués. Par exemple, vous pouvez créer deux affichages différents de vos archives mensuelles: un contenant les notes d\'un mois particulier et l\'autre présentant les notes dans un calendrier.',
    'Ban Commenter(s)' => 'Bannir le commentateur',
    '_USAGE_VIEW_LOG' => 'L\'erreur est enregistrée dans le <a href="#" onclick="doViewLog()">journal des activité</a>.',
    '_USAGE_PERMISSIONS_4' => 'Chaque weblog peut être utilisé par plusieurs auteurs. Pour ajouter un auteur, vous entrerez les informations correspondantes dans les formulaires ci-dessous. Sélectionnez ensuite les weblogs dans lesquels l\'auteur pourra travailler. Vous pourrez modifier les droits accordés à l\'auteur une fois ce dernier enregistré dans le système.',
    '_USAGE_BOOKMARKLET_1' => 'La configuration de la fonction QuickPost vous permet de publier vos notes en un seul clic sans même utiliser l\'interface principale de Movable Type.',
    '_USAGE_ARCHIVING_3' => 'Sélectionnez le type d\'archive auquel vous souhaitez ajouter un modèle. Sélectionnez le modèle que vous souhaitez associer à ce type d\'archive.',
    'UTC+10' => 'UTC+10', 
    'INDIVIDUAL_ADV' => 'par note',
    '_USAGE_BOOKMARKLET_5' => 'Vous pouvez également, si vous utilisez Internet Explorer sous Windows, installer une option QuickPost dans le menu contextuel (clic droit) de Windows. Cliquez sur le lien ci-dessous et acceptez le message affiché pour ouvrir le fichier. Fermez et redémarrez votre navigateur pour ajouter le menu au système.',
    '_ERROR_CGI_PATH' => 'Votre configuration de chemin CGI est invalide ou absente de vos fichiers de configuration Movable Type. Merci de consulter la base de connaissance',
    '_USAGE_IMPORT' => 'Vous pouvez utiliser le mécanisme d\'importation de notes pour importer vos notes d\'un autre système de gestion de weblog (Blogger ou Greymatter, par exemple). Ce mode d\'emploi contient des instructions complètes pour l\'importation de vos notes; le formulaire suivant vous permet d\'importer tout un lot de notes déjC  exportées d\'un autre système, et d\'enregistrer les fichiers de façon à pouvoir les utiliser dans Movable Type. Consultez le mode d\'emploi avant d\'utiliser ce formulaire de façon à sélectionner les options adéquates.',
    'Main Index' => 'Index principal',
    '_USAGE_CATEGORIES' => 'Les catégories permettent de regrouper vos notes pour en faciliter la gestion, la mise en archives et l\'affichage dans votre weblog. Vous pouvez affecter une catégorie à chaque note que vous créez ou modifiez. Pour modifier une catégorie existante, cliquez sur son titre. Pour créer une sous-catégorie, cliquez sur le bouton Créer correspondant. Pour déplacer une catégorie, cliquez sur le bouton Déplacer correspondant.',
    '_SYSTEM_TEMPLATE_COMMENTS' => 'Affiché quand les commentaires en pop up sont activés', 
    'Master Archive Index' => 'Index principal des archives',
    'Weekly' => 'Hebdomadaire',
    'Unpublish TrackBack(s)' => 'TrackBack(s) non publié(s)',
    '_USAGE_EXPORT_3' => 'Le lien suivant entraîne l\'exportation de toutes les notes de votre weblog vers le serveur Tangent. Il s\'agit généralement d\'une opération ponctuelle, réalisée à la suite de l\'installation du module Tangent pour Movable Type.',
    'Send Notifications' => 'Envoyer des notifications',
    'Edit All Entries' => 'Modifier toutes les notes',
    '_USAGE_PREFS' => 'Cet écran vous permet de définir un grand nombre des paramètres de votre weblog, de vos archives, des commentaires et de communication de notifications. Ces paramètres ont tous des valeurs par défaut raisonnables lors de la création d\'un nouveau weblog.',
    '_SYSTEM_TEMPLATE_COMMENT_ERROR' => 'Affiché quand un commentaire ne peut être validé', 
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
    'Required' => 'Requise',
    'Optional' => 'Optionnel',

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
    'Got an error: [_1]' => 'Erreur de type: [_1]',

    ## ./lib/MT/Category.pm

    ## ./lib/MT/Promise.pm

    ## ./lib/MT/App.pm
    'User \'[_1]\' (user #[_2]) logged in successfully' => 'L\'utilisateur \'[_1]\' (user #[_2]) s\'est enregistré correctement',
    'Invalid login attempt from user \'[_1]\'' => 'Erreur d\'enregistrement pour l\'utilisateur \'[_1]\'',
    'Invalid login.' => 'Identifiant invalide.',
    'User \'[_1]\' (user #[_2]) logged out' => 'L\'utilisateur \'[_1]\' (user #[_2]) s\'est déconnecté',
    'The file you uploaded is too large.' => 'Le fichier que vous souhaitez envoyer est trop lourd.',
    'Unknown action [_1]' => 'Action inconnue [_1]',
    'Loading template \'[_1]\' failed: [_2]' => 'Echec lors du chargement du modèle \'[_1]\': [_2]',

    ## ./lib/MT/Log.pm

    ## ./lib/MT/Image.pm
    'Can\'t load Image::Magick: [_1]' => 'Impossible de charger Image::Magick: [_1]',
    'Reading file \'[_1]\' failed: [_2]' => 'La lecture du fichier \'[_1]\' a échoué: [_2]',
    'Reading image failed: [_1]' => 'Echec lors de la lecture de l\'image: [_1]',
    'Scaling to [_1]x[_2] failed: [_3]' => 'La mise à l\'échelle vers [_1]x[_2] a échoué: [_3]',
    'Can\'t load IPC::Run: [_1]' => 'Impossible de charger IPC::Run: [_1]',
    'You do not have a valid path to the NetPBM tools on your machine.' => 'Votre chemin d\'accès vers les outils NetPBM n\'est pas valide sur votre machine.',

    ## ./lib/MT/Session.pm

    ## ./lib/MT/FileMgr.pm

    ## ./lib/MT/IPBanList.pm

    ## ./lib/MT/Trackback.pm

    ## ./lib/MT/Notification.pm

    ## ./lib/MT/Blocklist.pm

    ## ./lib/MT/Sanitize.pm

    ## ./lib/MT/AtomServer.pm

    ## ./lib/MT/Upgrade.pm
    'Running [_1]' => 'Fonctionne avec [_1]',
    'Invalid upgrade function: [_1].' => 'Fonction de mise à jour invalide: [_1].',
    'Error loading class: [_1].' => 'Erreur de chargement de classe: [_1].',
    'Creating initial weblog and author records...' => 'Création du weblog initial et des informations auteur...',
    'Error saving record: [_1].' => 'Erreur de l\'enregistrement des informations: [_1].',
    'First Weblog' => 'Premier Weblog',
    'Can\'t find default template list; where is \'default-templates.pl\'? Error: [_1]' => 'Impossible de trouver la liste de modèles par défaut; où se trouve \'default-templates.pl\'? Erreur: [_1]',
    'Creating new template: \'[_1]\'.' => 'Creation d\'un nouveau modèle: \'[_1]\'.',
    'Mapping templates to blog archive types...' => 'Mapping des habillages vers les archives des blogs...',
    'Upgrading table for [_1]' => 'Mise à jour des tables pour [_1]',
    'Executing SQL: [_1];' => 'Exécution SQL: [_1];',
    'Error during upgrade: [_1]' => 'Erreur pendant la mise à jour: [_1]',
    'Upgrading database from version [_1].' => 'Mise à jour de la Base de données de la version [_1].',
    'Database has been upgraded to version [_1].' => 'La base de données a été mise à jour version [_1].',
    'Setting your permissions to administrator.' => 'Paramétrage des permissions pour administrateur.',
    'Creating configuration record.' => 'Création des infos de configuration.',
    'Creating template maps...' => 'Création des liens de modèles...',
    'Mapping template ID [_1] to [_2] ([_3]).' => 'Lien du modèle [_1] vers [_2] ([_3]).',
    'Mapping template ID [_1] to [_2].' => 'Lien du modèle [_1] vers [_2].',

    ## ./lib/MT/PluginData.pm

    ## ./lib/MT/DateTime.pm

    ## ./lib/MT/Plugin.pm

    ## ./lib/MT/Entry.pm
    'Load of blog failed: [_1]' => 'Echec lors du chargement du blog: [_1]',
    'Load of blog \'[_1]\' failed: [_2]' => 'Le chargement du blog \'[_1]\' a échoué: [_2]',

    ## ./lib/MT/Author.pm

    ## ./lib/MT/Config.pm

    ## ./lib/MT/XMLRPC.pm
    'No WeblogsPingURL defined in mt.cfg' => 'Le WeblogsPingURL n\'est pas défini dans le fichier mt.cfg',
    'No MTPingURL defined in mt.cfg' => 'Le MTPingURL  n\'est pas défini dans le fichier mt.cfg',
    'HTTP error: [_1]' => 'Erreur HTTP: [_1]',
    'Ping error: [_1]' => 'Erreur Ping: [_1]',

    ## ./lib/MT/TemplateMap.pm

    ## ./lib/MT/Template.pm
    'Parse error in template \'[_1]\': [_2]' => 'Erreur de parsing dans le modèle \'[_1]\': [_2]',
    'Build error in template \'[_1]\': [_2]' => 'Erreur de compilation dans le modèle \'[_1]\': [_2]',
    'You cannot use a [_1] extension for a linked file.' => 'Vous ne pouvez pas utiliser l\'extension [_1] pour un fichier joint.',
    'Opening linked file \'[_1]\' failed: [_2]' => 'L\'ouverture du fichier lié \'[_1]\' a échoué: [_2] ',

    ## ./lib/MT/ConfigMgr.pm
    'Error opening file \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture du fichier \'[_1]\': [_2]',
    'Config directive [_1] without value at [_2] line [_3]' => 'Config directive [_1] sans valeur sur [_2] ligne [_3]',
    'No such config variable \'[_1]\'' => 'La variable de configuration \'[_1]\' n\'existe pas',

    ## ./lib/MT/ImportExport.pm
    'You need to provide a password if you are going to\n' => 'Vous devez saisir un mot de passe si vous allez sur \n',
    'Need either ImportAs or ParentAuthor' => 'ImportAs ou ParentAuthor sont nécessaires',
    'Saving author failed: [_1]' => 'Echec lors de la sauvegarde de l\'Auteur: [_1]',
    'Saving permission failed: [_1]' => 'Echec lors de la sauvegarde des Droits des Auteurs: [_1]',
    'Saving category failed: [_1]' => 'Echec lors de la sauvegarde des Catégories: [_1]',
    'Invalid status value \'[_1]\'' => 'Valeur d\'état invalide \'[_1]\'',
    'Saving entry failed: [_1]' => 'Echec lors de la sauvegarde de la Note: [_1]',
    'Saving placement failed: [_1]' => 'Echec lors de la sauvegarde du Placement: [_1]',
    'Saving comment failed: [_1]' => 'Echec lors de la sauvegarde du Commentaire: [_1]',
    'Entry has no MT::Trackback object!' => 'La note n\'a pas d\'objet MT::Trackback !',
    'Saving ping failed: [_1]' => 'Echec lors de la sauvegarde du ping: [_1]',
    'Export failed on entry \'[_1]\': [_2]' => 'Echec lors de l\'export sur la Note \'[_1]\': [_2]',

    ## ./lib/MT/JunkFilter.pm
    'Action: Junked (score below threshold)' => 'Action: Indésirable (score ci-dessous)',
    'Action: Published (default action)' => 'Action: Pubblié (action par défaut)',
    'Junk Filter [_1] died with: [_2]' => 'Filtre indésirable [_1] mort avec: [_2]',
    'Unnamed Junk Filter' => 'Filtre indésirable sans nom',
    'Composite score: [_1]' => 'Score composite : [_1]',

    ## ./lib/MT/ObjectDriver.pm

    ## ./lib/MT/Mail.pm
    'Unknown MailTransfer method \'[_1]\'' => 'Méthode de transfert de mail inconnu \'[_1]\'',
    'Sending mail via SMTP requires that your server ' => 'L\'envoi de mail via SMTP nécessite que votre serveur ',
    'Error sending mail: [_1]' => 'Erreur lors de l\'envoi du mail: [_1]',
    'You do not have a valid path to sendmail on your machine. ' => 'Le chemin d\'accès vers sendmail n\'est pas valide sur votre machine. ',
    'Exec of sendmail failed: [_1]' => 'Echec lors de l\'exécution de sendmail: [_1]',

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
    'Archive type \'[_1]\' is not a chosen archive type' => 'Le Type d\'archive\'[_1]\' n\'est pas un type d\'archive sélectionné',
    'Parameter \'[_1]\' is required' => 'Le Paramètre \'[_1]\' est requis',
    'Building category archives, but no category provided.' => 'Construction des archives de catégorie, mais aucune catégorie n\'a été fournie.',
    'You did not set your Local Archive Path' => 'Vous n\'avez pas spécifié votre chemin local des Archives',
    'Building category \'[_1]\' failed: [_2]' => 'La construction de la catégorie\'[_1]\' a échoué: [_2]',
    'Building entry \'[_1]\' failed: [_2]' => 'La construction de la note \'[_1]\' a échoué: [_2]',
    'Building date-based archive \'[_1]\' failed: [_2]' => 'La construction des archives de la base de données \'[_1]\' a échoué: [_2]',
    'You did not set your Local Site Path' => 'Vous n\'avez pas spécifié votre chemin local du Site',
    'Template \'[_1]\' does not have an Output File.' => 'Le modèle \'[_1]\' n\'a pas de fichier de sortie.',

    ## ./lib/MT/Atom.pm

    ## ./lib/MT/Comment.pm
    'Load of entry \'[_1]\' failed: [_2]' => 'Le chargement de la note \'[_1]\' a échoué: [_2]',

    ## ./lib/MT/L10N.pm

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

    ## ./lib/MT/BasicSession.pm

    ## ./lib/MT/ObjectDriver/DBI.pm

    ## ./lib/MT/ObjectDriver/DBM.pm
    'Your DataSource directory (\'[_1]\') does not exist.' => 'Votre dossier de données (\'[_1]\') n\'existe pas.',
    'Your DataSource directory (\'[_1]\') is not writable.' => 'Votre dossier de données (\'[_1]\') est protégé en écriture.',
    'Tie \'[_1]\' failed: [_2]' => 'La création du lien \'[_1]\' a échoué: [_2]',
    'Failed to generate unique ID: [_1]' => 'Echec lors de la génération de l\'ID unique: [_1]',
    'Unlink of \'[_1]\' failed: [_2]' => 'La suppression du lien \'[_1]\' a échoué: [_2]',

    ## ./lib/MT/ObjectDriver/DBI/mysql.pm
    'Connection error: [_1]' => 'Erreur de connexion: [_1]',

    ## ./lib/MT/ObjectDriver/DBI/postgres.pm

    ## ./lib/MT/ObjectDriver/DBI/sqlite.pm
    'Can\'t open \'[_1]\': [_2]' => 'Impossible d\'ouvrir \'[_1]\': [_2]',
    'Your database file (\'[_1]\') is not writable.' => 'Votre fichier base de données (\'[_1]\') est interdit en écriture.',
    'Your database directory (\'[_1]\') is not writable.' => 'Le répertoire de votre Base de données(\'[_1]\') est interdit en écriture.',

    ## ./lib/MT/FileMgr/FTP.pm

    ## ./lib/MT/FileMgr/DAV.pm

    ## ./lib/MT/FileMgr/Local.pm
    'Opening local file \'[_1]\' failed: [_2]' => 'L\'ouverture du fichier local \'[_1]\' a échoué: [_2]',
    'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Renommer \'[_1]\' vers \'[_2]\' a échoué: [_3]',

    ## ./lib/MT/FileMgr/SFTP.pm

    ## ./lib/MT/Template/Context.pm

    ## ./lib/MT/Template/ContextHandlers.pm
    'Can\'t find included template module \'[_1]\'' => 'Impossible de trouver le module de modèle inclus \'[_1]\'',
    'Can\'t find included file \'[_1]\'' => 'Impossible de trouver le fichier inclus \'[_1]\'',
    'Error opening included file \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture du fichier inclus \'[_1]\': [_2]',
    'Can\'t find template \'[_1]\'' => 'Impossible de trouver le modèle \'[_1]\'',
    'Can\'t find entry \'[_1]\'' => 'Impossible de trouver la note \'[_1]\'',
    'You used a [_1] tag without any arguments.' => 'Vous utilisez un [_1] tag sans aucun argument.',
    'No such category \'[_1]\'' => 'La catégorie \'[_1]\' n\'existe pas',
    'You can\'t use both AND and OR in the same expression ([_1]).' => 'Vous ne pouvez utiliser à la fois ET et OU dans la même expression ([_1]).',
    'No such author \'[_1]\'' => 'L\'auteur \'[_1]\' n\'existe pas',
    'You used an \'[_1]\' tag outside of the context of an entry; ' => 'Vous utilisez un tag \'[_1]\' en dehors du contexte d\'une note; ',
    'You used <$MTEntryFlag$> without a flag.' => 'Vous utilisez <$MTEntryFlag$> sans drapeau.',
    'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Vous avez utilisé un [_1] tag pour créer un lien vers \'[_2]\' archives, mais le type d\'archive n\'est pas publié.',
    'To enable comment registration, you ' => 'Pour demander l\'enregistrement avant de pouvoir commenter, vous ',
    '(You may use HTML tags for style)' => '(Vous dpouvez utiliser des tags HTML pour le style)',
    'You used an [_1] tag without a date context set up.' => 'Vous utilisez un tag [_1] sans avoir configuré la date.',
    'You used an \'[_1]\' tag outside of the context of a comment; ' => 'Vous utilisez un tag \'[_1]\' en dehors du contexte d\'un commentaire; ',
    'You used an [_1] without a date context set up.' => 'Vous utilisez un [_1] sans avoir configurer la date.',
    '[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] est valide uniquement avec des archives quotidiennes, hebdomadaires ou mensuelles.',
    'You used an [_1] tag outside of the proper context.' => 'Vous utilisez un tag [_1] en dehors de son contexte propre.',
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly ' => 'Vous utilisez un tag [_1] en dehors d\'une utilisation quotidienne, hebdomadaire ou mensuelle ',
    'Invalid month format: must be YYYYMM' => 'Le format du mois est invalide: Il doit être de la forme AAAAAMM',
    '[_1] can be used only if you have enabled Category archives.' => '[_1] peut être utilisé seulement si vous avez activé l\'archivage par Catégories.',
    'You used [_1] without a query.' => 'Vous utilisez [_1] sans aucune requête.',
    'You need a Google API key to use [_1]' => 'You avez besoin d\'une clé Google API pour utiliser [_1]',
    'You used a non-existent property from the result structure.' => 'Vous utilisez une propriété inexistante de la structure de résultats.',

    ## ./lib/MT/App/NotifyList.pm
    'Please enter a valid email address.' => 'Veuillez entrer une adresse e-mail valide.',
    'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Il manque un paramètre requis : blog_id. Veuillez consulter le manuel d\'utilisateur pour configurer les notifications.',
    'Email notifications have not been configured! The weblog owner needs to set the EmailVerificationSecret configuration variable in mt.cfg.' => 'L\'avis par e-mail n\'a pas été configuré ! Le webmaster de la plateforme doit mettre la variable de configuration EmailVerificationSecret dans mt.cfg.',
    'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Vous avez fourni un paramètre de redirection non valide. Le propriétaire du weblog doit spécifier le chemin qui correspond au nom de domaine du weblog.',
    'The email address \'[_1]\' is already in the notification list for this weblog.' => 'L\'adresse e-mail \'[_1]\' fait déjà parti de la liste de notification pour ce weblog.',

    ## ./lib/MT/App/Trackback.pm
    'Invalid entry ID \'[_1]\'' => 'ID de Note invalide \'[_1]\'',
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
    'Rebuild failed: [_1]' => 'Echec lors de la recontruction: [_1]',
    'Can\'t create RSS feed \'[_1]\': ' => 'Impossible de créer le flux RSS \'[_1]\': ',
    'New TrackBack Ping to Entry [_1] ([_2])' => 'Nouveau TrackBack Ping pour la Note [_1] ([_2])',
    'New TrackBack Ping to Category [_1] ([_2])' => 'Nouveau TrackBack Ping pour la Catégorie [_1] ([_2])',

    ## ./lib/MT/App/Comments.pm
    'IP Banned Due to Excessive Comments' => 'IP bannie pour cause de commentaires excessifs',
    'No such entry \'[_1]\'.' => 'Aucune Note \'[_1]\'.',
    'You are not allowed to post comments.' => 'Vous n\'êtes pas autorisé à poster des commentaires.',
    'Comments are not allowed on this entry.' => 'Les commentaires ne sont pas autorisés sur cette Note.',
    'Comment text is required.' => 'Le texte de commentaire est requis.',
    'Registration is required.' => 'L\'inscription est requise.',
    'Name and email address are required.' => 'Le nom et l\'e-mail sont requis.',
    'Invalid email address \'[_1]\'' => 'Adresse e-mail invalide \'[_1]\'',
    'New Comment Posted to \'[_1]\'' => 'Nouveau commentaire posté sur \'[_1]\'',
    'No public key could be found to validate registration.' => 'Aucune clé publique n\'a été trouvée pour valider l\'inscription.',
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

    ## ./lib/MT/App/Search.pm
    'You are currently performing a search. Please wait ' => 'Une recherche est actuellement en cours. Merci de patienter ',
    'Search failed: [_1]' => 'Echec lors de la recherche: [_1]',
    'Building results failed: [_1]' => 'Echec lors de la construction des résultats: [_1]',
    'Search: query for \'[_1]\'' => 'Recherche: requête pour \'[_1]\'',

    ## ./lib/MT/App/Upgrader.pm
    'Invalid session.' => 'Session invalide.',
    'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Pas d\'autorisation. Contactez votre administrateur système Movable Type pour changer votre statut.',

    ## ./lib/MT/App/Viewer.pm

    ## ./lib/MT/App/CMS.pm
    'Convert Line Breaks' => 'Conversion retours ligne',
    'Password Recovery' => 'Récupération de mot de passe',
    'Invalid author name \'[_1]\' in password recovery attempt' => 'Nom d\'auteur invalide\'[_1]\' pour la recherche de mot de passe',
    'Author name or birthplace is incorrect.' => 'Le nom de l\'auteur ou son lieu de naissance est incorrect.',
    'Author has not set birthplace; cannot recover password' => 'L\'auteur n\'a pas spécifié son lieu de naissance; impossible de retrouver son mot de passe.',
    'Invalid attempt to recover password (used birthplace \'[_1]\')' => 'Tentative invalide de recherche de mot de passe (lieu de naissance utilisé \'[_1]\')',
    'Author does not have email address' => 'L\'auteur n\'a pas d\'adresse e-mail',
    'Password was reset for author \'[_1]\' (user #[_2])' => 'Le mot de passe à été réinitialisé pour l\'utilisateur \'[_1]\' (user #[_2])',
    'Error sending mail ([_1]); please fix the problem, then ' => 'Erreur lors de l\'envoi de l\'e-mail ([_1]); veuillez résoudre le problème puis ',
    'You are not authorized to log in to this blog.' => 'Vous n\'êtes pas autorisé à vous connecter sur ce weblog.',
    'No such blog [_1]' => 'Aucun weblog ne porte le nom [_1]',
    'Permission denied.' => 'Permission refusée.',
    'log records' => 'entrées du journal',
    'Application log for blog \'[_1]\' reset by \'[_2]\' (user #[_3])' => 'Journal du blog \'[_1]\' mis à zéro par \'[_2]\' (user #[_3])',
    'Application log reset by \'[_1]\' (user #[_2])' => 'Journal de l\'application mis à zéro par \'[_1]\' (user #[_2])',
    'Import/Export' => 'Importer / Exporter',
    'No permissions' => 'Aucun Droit',
    'Permission denied. ' => 'Autorisation refusée. ',
    'Load failed: [_1]' => 'Echec de chargement: [_1]',
    '(untitled)' => '(sans titre)',
    'Create template requires type' => 'La création d\'habillages nécessite un type',
    'New Template' => 'Nouveau modèle',
    'New Weblog' => 'Nouveau weblog',
    'Author requires username' => 'Un nom d\'utilisateur est nécessaire pour l\'auteur',
    'Author requires password' => 'L\'auteur a besoin d\'un mot de passe',
    'Author requires password hint' => 'L\'auteur a besoin d\'un pense bête de mot de passe',
    'Email Address is required for password recovery' => 'L\'adresse email est nécessaire pour récupérer le mot de passe',
    'The value you entered was not a valid email address' => 'Vous devez saisir une adresse e-mail valide',
    'The e-mail address you entered is already on the Notification List for this weblog.' => 'L\'adresse e-mail que vous avez entrée fait déjà parti de la liste de notification de ce weblog.',
    'You did not enter an IP address to ban.' => 'Vous devez saisir une adresse IP à bannir.',
    'The IP you entered is already banned for this weblog.' => 'L\'adresse IP que vous avez entrée a été bannie de ce weblog.',
    'You did not specify a weblog name.' => 'Vous devez  spécifier un nom de weblog.',
    'Site URL must be an absolute URL.' => 'L\'URL du site doit être une URL absolue.',
    'There is already a weblog by that name!' => 'Un weblog possède déjà ce nom.',
    'The name \'[_1]\' is too long!' => 'Le nom \'[_1]\' est trop long.',
    'No categories with the same name can have the same parent' => 'Les catégories portant le même nom ne peuvent avoir le même parent',
    'Can\'t find default template list; where is ' => 'Impossible de trouver la liste des modèles par défaut; où est ',
    'Populating blog with default templates failed: [_1]' => 'L\'activation sur le blog des modèles par défaut a échoué: [_1]',
    'Setting up mappings failed: [_1]' => 'La mise en oeuvre des mappings a échoué: [_1]',
    'Weblog \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' créé par \'[_2]\' (user #[_3])',
    'Passwords do not match.' => 'Les mots de passe ne sont pas conformes.',
    'Failed to verify current password.' => 'Erreur lors de la vérification du mot de passe.',
    'Password hint is required.' => 'Le pense bête mot de passe est nécessaire.',
    'An author by that name already exists.' => 'Un auteur ayant ce nom existe déjà.',
    'Saving object failed: [_1]' => 'Echec lors de la sauvegarde de l\'objet: [_1]',
    'No Name' => 'Pas de Nom',
    'Notification List' => 'Liste de notifications',
    'email addresses' => 'adresses email',
    'IP addresses' => 'adresses IP',
    'Can\'t delete that way' => 'Impossible de supprimer comme cela',
    'Your login session has expired.' => 'Votre session a expiré.',
    'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => 'Vous ne pouvez pas effacer cette catégorie car elle contient des sous-catégories. Déplacez ou supprimez d\'abord les sous-catégories pour pouvoir effacer cette catégorie.',
    'Weblog \'[_1]\' deleted by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' effacé par \'[_2]\' (user #[_3])',
    'Unknown object type [_1]' => 'Objet de type [_1] inconnu',
    'Loading object driver [_1] failed: [_2]' => 'Echec lors du chargement du driver [_1]: [_2]',
    'Invalid filename \'[_1]\'' => 'Nom de fichier invalide \'[_1]\'',
    'Reading \'[_1]\' failed: [_2]' => 'Echec \'[_1]\' lors de la lecture de: [_2]',
    'Thumbnail failed: [_1]' => 'Echec de a vignette: [_1]',
    'Error writing to \'[_1]\': [_2]' => 'Erreur \'[_1]\' lors de l\'écriture de: [_2]',
    'Invalid basename \'[_1]\'' => 'Nom de base invalide \'[_1]\'',
    'No such commenter [_1].' => 'Pas de commentateur [_1].',
    'Need a status to update entries' => 'Statut nécessaire pour mettre à jour les notes',
    'Need entries to update status' => 'Notes nécessaires pour mettre à jour le statut',
    'One of the entries ([_1]) did not actually exist' => 'Une des notes ([_1]) n\'existait pas',
    'Some entries failed to save' => 'Certaines notes non pas été sauvegardées correctement',
    'You don\'t have permission to approve this TrackBack.' => 'Vous n\'avez pas l\'autorisation d\'approuver ce TrackBack.',
    'You don\'t have permission to approve this comment.' => 'Vous n\'avez pas la permission d\'approuver ce commentaire.',
    'Orphaned comment' => 'Commentaire orphelin',
    'Plugin Set: [_1]' => 'Eventail de Plugin: [_1]',
    'No Excerpt' => 'Pas d\'extrait',
    'No Title' => 'Pas de Titre',
    'Orphaned TrackBack' => 'TrackBack orphelin',
    'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Date invalide \'[_1]\'; les dates doivent être au format YYYY-MM-DD HH:MM:SS.',
    'Saving entry \'[_1]\' failed: [_2]' => 'Echec \'[_1]\' lors de la sauvegarde de la Note: [_2]',
    'Removing placement failed: [_1]' => 'Echec lors de la suppression de l\'emplacement: [_1]',
    'No such entry.' => 'Aucune Note de ce type.',
    'Your weblog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Votre weblog n\'a pas été configuré avec un chemin et une URL. Vous ne pouvez pas publier de notes avant qu\'ils ne soient définis',
    'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Date invalide \'[_1]\'; les dates de publication doivent être réelles.',
    '\'[_1]\' (user #[_2]) added entry #[_3]' => '\'[_1]\' (user #[_2]) note ajoutée #[_3]',
    'The category must be given a name!' => 'Vous devez donner un nom a votre catégorie.',
    'yyyy/mm/entry_basename' => 'yyyy/mm/entry_basename', 
    'yyyy/mm/entry_basename/' => 'yyyy/mm/entry_basename/', 
    'yyyy/mm/dd/entry_basename' => 'yyyy/mm/dd/entry_basename', 
    'yyyy/mm/dd/entry_basename/' => 'yyyy/mm/dd/entry_basename/', 
    'category/sub_category/entry_basename' => 'category/sub_category/entry_basename', 
    'category/sub_category/entry_basename/' => 'category/sub_category/entry_basename/', 
    'category/sub-category/entry_basename' => 'category/sub-category/entry_basename', 
    'category/sub-category/entry_basename/' => 'category/sub-category/entry_basename/', 
    'primary_category/entry_basename' => 'primary_category/entry_basename', 
    'primary_category/entry_basename/' => 'primary_category/entry_basename/', 
    'primary-category/entry_basename' => 'primary-category/entry_basename', 
    'primary-category/entry_basename/' => 'primary-category/entry_basename/', 
    'yyyy/mm/' => 'yyyy/mm/', 
    'yyyy_mm' => 'yyyy_mm', 
    'yyyy/mm/dd/' => 'yyyy/mm/dd/', 
    'yyyy_mm_dd' => 'yyyy_mm_dd', 
    'yyyy/mm/dd-week/' => 'yyyy/mm/dd-week/', 
    'week_yyyy_mm_dd' => 'week_yyyy_mm_dd', 
    'category/sub_category/' => 'categorie/sous_categorie/', 
    'category/sub-category/' => 'categorie/sub-categorie/', 
    'cat_category' => 'cat_categorie',
    'Saving blog failed: [_1]' => 'Echec lors de la sauvegarde du blog: [_1]',
    'You do not have permission to configure the blog' => 'Vous n\'avez pas la permission de configurer le weblog.',
    'Saving map failed: [_1]' => 'Echec lors du rattachement: [_1]',
    'Parse error: [_1]' => 'Erreur de parsing: [_1]',
    'Build error: [_1]' => 'Erreur de construction: [_1]',
    'index template \'' => 'index de l\'habillage \'',
    'entry \'' => 'note \'',
    'Ping \'[_1]\' failed: [_2]' => 'Le Ping \'[_1]\' n\'a pas fonctionné: [_2]',
    'Edit Permissions' => 'Editer les Autorisations',
    'No entry ID provided' => 'Aucune ID de Note fournie',
    'No such entry \'[_1]\'' => 'Aucune Note du type \'[_1]\'',
    'No email address for author \'[_1]\'' => 'L\'auteur \'[_1]\' ne possède pas d\'adresse e-mail',
    '[_1] Update: [_2]' => '[_1] Mise à jour: [_2]',
    'Error sending mail ([_1]); try another MailTransfer setting?' => 'Erreur lors de l\'envoi de l\'e-mail ([_1]); essayer un autre paramètre de MailTransfer?',
    'You did not choose a file to upload.' => 'Vous n\'avez pas sélectionné de fichier à envoyer.',
    'Invalid extra path \'[_1]\'' => 'Chemin supplémentaire invalide \'[_1]\'',
    'Can\'t make path \'[_1]\': [_2]' => 'Impossible de créer le chemin \'[_1]\': [_2]',
    'Invalid temp file name \'[_1]\'' => 'Nom de fichier temporaire invalide \'[_1]\'',
    'Error opening \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture de \'[_1]\': [_2]',
    'Error deleting \'[_1]\': [_2]' => 'Erreur lors de la suppression de \'[_1]\': [_2]',
    'File with name \'[_1]\' already exists. (Install ' => 'Le fichier portant le nom \'[_1]\' existe déjà. (Installez ',
    'Error creating temporary file; please check your TempDir ' => 'Erreur lors de la création du fichier temporaire; veuillez vérifier votre répertoire temporaire (Temp) ',
    'unassigned' => 'non assigné',
    'File with name \'[_1]\' already exists; Tried to write ' => 'Le fichier portant le nom \'[_1]\' existe déjà; Essayez d\'écrire ',
    'Error writing upload to \'[_1]\': [_2]' => 'Erreur d\'écriture lors de l\'envoi de \'[_1]\': [_2]',
    'Perl module Image::Size is required to determine ' => 'le Module Perl Image::Size est requis pour déterminer ',
    'Saving object failed: [_2]' => 'La sauvegarde des objets a échoué: [_2]',
    'Search & Replace' => 'Rechercher et Remplacer',
    'No blog ID' => 'Aucun blog ID',
    'You do not have export permissions' => 'Vous n\'avez pas les droits d\'exportation',
    'You do not have import permissions' => 'Vous n\'avez pas les droits d\'importation',
    'You do not have permission to create authors' => 'Vous n\'êtes pas autorisé à créer des auteurs',
    'Can\'t open directory \'[_1]\': [_2]' => 'Impossible d\'ouvrir le dossier \'[_1]\': [_2]',
    'No readable files could be found in your import directory [_1].' => 'Aucun fichier lisible n\'a été trouvé dans le répertoire d\'importation [_1].',
    'Importing entries from file \'[_1]\'' => 'Importation des notes du fichier \'[_1]\'',
    'Can\'t open file \'[_1]\': [_2]' => 'Impossible d\'ouvrir le fichier \'[_1]\': [_2]',
    'Creating new author (\'' => 'Création d\'un nouvel auteur (\'',
    'ok\n' => 'ok\n', 
    'failed\n' => 'échoué\n',
    'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Date invalide\'[_1]\'; doit être \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM est optionnel)', 
    'Preferences' => 'Préférences',
    'Saving permissions failed: [_1]' => 'Echec lors de la sauvegarde des Autorisations: [_1]',
    'Add a Category' => 'Ajouter une Catégorie',
    'Category name cannot be blank.' => 'Vous devez nommer votre catégorie.',
    'That action ([_1]) is apparently not implemented!' => 'Cette action([_1]) n\'est visiblement pas implémentée!',

    ## ./lib/MT/Plugin/JunkFilter.pm
    'from rule' => 'de la règle',
    'from test' => 'du test',

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
    'You did not select any [_1] to delete.' => 'Vous n\'avez pas sélectionner de [_1] à effacer.',
    'Are you sure you want to delete this [_1]?' => 'Etes-vous sûr de vouloir effacer ce(cette) [_1]?',
    'Are you sure you want to delete the [_1] selected [_2]?' => 'Etes-vous sûr de vouloir effacer le(la) [_1] sélectionné(e) [_2]?',
    'to delete' => 'à effacer',
    'You did not select any [_1] [_2].' => 'Vous n\'avez pas sélectionné de [_1] [_2].',
    'You must select an action.' => 'Vous devez sélectionner une action.',
    'to mark as junk' => 'pour marquer indésirable',
    'to remove "junk" status' => 'pour retirer le statut "indésirable"',
    'Enter email address:' => 'Saisissez l\'adresse email:',
    'Enter URL:' => 'Saisissez l\'URL:',
        ## ./mt-check.cgi.pre
    'Movable Type System Check' => 'Vérification du système de Movable Type',
    'This page provides you with information on your system\'s configuration and determines whether you have all of the components you need to run Movable Type.' => 'Cette page vous fournit des informations sur la configuration de votre système et vérifie que vous avez installé tous les composants nécesaires à l\'utilisation de Movable Type.',
    'System Information:' => 'Information Système:',
    'Current working directory:' => 'Répertoire actuellement en activité:',
    'MT home directory:' => 'MT Répertoire racine:',
    'Operating system:' => 'Système  d\'exploitation :',
    'Perl version:' => 'Version Perl:',
    'Perl include path:' => 'Chemin Perl inclu:',
    'Web server:' => 'Serveur Web:',
    '(Probably) Running under cgiwrap or suexec' => '(Probablement) Tâche lancée sous cgiwrap ou suexec',
    'Checking for [_1] Modules:' => 'Vérification des Modules [_1]:',
    'Some of the following modules are required by the various data storage options in Movable Type. In order run the system, your server needs to have DBI and at least one of the other modules installed.' => 'Certains de ces modules sont nécessaires dans différentes options de stockage de Movable type. Pour que le système fonctionne, votre serveur doit avoir un DBI et au moins l\'un des autres modules installé.', # Translate
    'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'Soit [_1] n\'est pas installé sur votre serveur, soit la version installée est trop ancienne, ou [_1] nécessite un autre module qui n\'est pas installé.',
    'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => '[_1] n\'est pas installé sur votre serveur, ou [_1] nécessite un autre module qui n\'est pas installé.',
    'Please consult the installation instructions for help in installing [_1].' => 'Merci de consulter les instructions d\'installation de [_1].',
    'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN.' => 'La version DBD::mysql qui est installée n\'est pas compatible avec Movable Type. Merci d\'installer la version actuelle disponible sur CPAN.',
    'The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements.' => 'Le $mod est installé correctement, mais nécessite une mise à jour du module DBI. Merci de consulter les information ci-dessus concernant les modules DBI.', # Translate
    'Your server has [_1] installed (version [_2]).' => '[_1] est installé sur votre serveur (version [_2]).',
    'Movable Type System Check Successful' => 'Vérification du système Movable Type effectuée avec succès',
    'You\'re ready to go!' => 'Vous pouvez commencer!',
    'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Tous les modules requis sont installés sur votre serveur; vous n\'avez pas besoin d\'installer de modules additionnels. Continuez l\'installation.',

    ## ./search_templates/default.tmpl
    'Search Results' => 'Résultats de recherche',
    'Search this site:' => 'Recherche sur ce site:',
    'Search' => 'Rechercher',
    'Match case' => 'Respecter la casse',
    'Regex search' => 'Expression générique',
    'Search Results from' => 'Résultats de la recherche depuis',
    'Posted in [_1] on [_2]' => 'Publié dans [_1] sur [_2]', # Translate
    'Searched for' => 'Recherché pour ',
    'No pages were found containing "[_1]".' => 'Aucune page trouvée contenant "[_1]".', # Translate
    'Instructions' => 'Instructions', # Translate
    'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Par défault, ce moteur de recherche regarde tous les mots dans un ordre aléatoire. Pour rechercher une expression exacte, écrivez-là entre guillemets:',
    'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'Ce moteur de recherche permet les mots clés AND, OR et NOT pour des expressions booléennes spécifiques:',
    'personal OR publishing' => 'personnel OR publication',
    'publishing NOT personal' => 'personnel NOT publication',

    ## ./search_templates/comments.tmpl
    'Search for new comments from:' => 'Recherche de nouveaux commentaires depuis:',
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
    'Posted in ' => 'Postés dans ',
    'on' => 'sur',
    'No results found' => 'Aucun résultat n\'a été trouvé',
    'No new comments were found in the specified interval.' => 'Aucun nouveau commentaire n\'a été trouvé dans l\'interval spécifié.',
    'Select the time interval that you\'d like to search in, then click \'Find new comments\'' => 'Sélectionner l\'intervalle de temps pour la recharhce, puis cliquez sur \'Trouver de nouveaux commentaires\'', # Translate

    ## ./tools/l10n/trans.pl

    ## ./tools/l10n/diff.pl

    ## ./tools/l10n/wrap.pl

    ## ./default_templates/comment_error_template.tmpl
    'Comment Submission Error' => 'Erreur de d\'envoi de commentaire',
    'Your comment submission failed for the following reasons:' => 'Votre envoi de commentaire a échoué pour la raison suivante:',

    ## ./default_templates/dynamic_pages_error_template.tmpl
    'Page Not Found' => 'Page Non Trouvée',

    ## ./default_templates/trackback_listing_template.tmpl
    ': Discussion on [_1]' => ': Discussion à propos de [_1]',
    'Trackbacks: [_1]' => 'Trackbacks: [_1]', # Translate
    'TrackBack' => 'TrackBack', # Translate
    'TrackBack URL for this entry:' => 'URL de TrackBack de cette note:',
    'Listed below are links to weblogs that reference' => 'Ci-dessous la liste des liens qui référencent',
    'from' => 'de',
    'Read More' => 'Lire la suite',
    'Tracked on [_1]' => 'Trackbacké sur [_1]',
    'Search this blog:' => 'Chercher dans ce blog:',
    'Recent Posts' => 'Notes récentes',
    'Subscribe to this blog\'s feed' => 'S\'abonner au flux de ce blog',
    'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds', # Translate
    'What is this?' => 'De quoi s\'agit-il?',
    'Creative Commons License' => 'Licence Creative Commons',
    'This weblog is licensed under a' => 'Ce weblog est sujet à une licence',

    ## ./default_templates/individual_entry_archive.tmpl
    'Main' => 'Accueil',
    'Posted by [_1] on [_2]' => 'Posté par [_1] dans [_2]',
    'Permalink' => 'Lien permanent',
    'Tracked on' => 'Trackbacké le',
    'Comments' => 'Commentaires',
    'Posted by:' => 'Postée le:',
    'Post a comment' => 'Poster un commentaire',
    '(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(Si vous n\'avez pas encore écrit de commentaire ici, vous devez être approuvé par le propriétaire du site avant que votre commentaire n\'apparaisse. En attendant, il n\'apparaîtra pas sur le site. Merci d\'attendre).',
    'Name:' => 'Nom:',
    'Email Address:' => 'Adresse e-mail:',
    'URL:' => 'URL:', # Translate
    'Remember personal info?' => 'Mémoriser mes infos personnelles?',
    'Comments:' => 'Commentaires:',
    '(you may use HTML tags for style)' => '(vous pouvez utilisez des tags HTML pour modifier le style)',
    'Preview' => 'Aperçu',
    'Post' => 'Publier',

    ## ./default_templates/main_index.tmpl
    'Continue reading' => 'Lire la suite',
    'Posted by [_1] at [_2]' => 'Posté par [_1] à [_2]',
    'TrackBacks' => 'TrackBacks', # Translate
    'Categories' => 'Catégories',
    'Archives' => 'Archives', # Translate

    ## ./default_templates/dynamic_site_bootstrapper.tmpl

    ## ./default_templates/datebased_archive.tmpl
    'Posted by' => 'Publié par',
    'at' => 'à',

    ## ./default_templates/uploaded_image_popup_template.tmpl

    ## ./default_templates/category_archive.tmpl

    ## ./default_templates/search_results_template.tmpl

    ## ./default_templates/master_archive_index.tmpl
    ': Archives' => ': Archives', # Translate

    ## ./default_templates/atom_index.tmpl

    ## ./default_templates/rsd.tmpl

    ## ./default_templates/stylesheet.tmpl

    ## ./default_templates/site_javascript.tmpl
    'Thanks for signing in,' => 'Merci de vous être enregistré,',
    '. Now you can comment. ' => '. Maintenant vous pouvez commenter. ',
    'sign out' => 'déconnexion',
    'You are not signed in. You need to be registered to comment on this site.' => 'Vous n\'êtes pas enregistré.  Vous devez être enregistré pour pouvoir commenter sur ce site.',
    'Sign in' => 'Inscription',
    'If you have a TypeKey identity, you can' => 'Si vous avez un identifiant TypeKey, vous pouvez',
    'sign in' => 'inscription',
    'to use it here.' => 'pour l\'utiliser ici.',

    ## ./default_templates/comment_preview_template.tmpl
    'Comment on' => 'Commentaire sur',
    'Previewing your Comment' => 'Aperçu',
    'Anonymous' => 'Anonyme',
    'Cancel' => 'Annuler',

    ## ./default_templates/rss_20_index.tmpl

    ## ./default_templates/comment_pending_template.tmpl
    'Comment Pending' => 'Commentaires en attente',
    'Thank you for commenting.' => 'Merci de votre commentaire.',
    'Your comment has been received and held for approval by the blog owner.' => 'Votre commentaire a été reçu et est en attente de validation par le propriétaire de ce blog.',
    'Return to the original entry' => 'Retourner à la note originale',

    ## ./lib/MT/default-templates.pl

    ## ./extras/examples/plugins/mirror/mirror.pl

    ## ./extras/examples/plugins/mirror/tmpl/mirror.tmpl

    ## ./plugins/nofollow/nofollow.pl
    'Adds a \'nofollow\' relationship to comment and TrackBack hyperlinks to reduce spam.' => 'Ajoutez un  \'nofollow\'aux commentaires et aux trackbacks pour réduire le Spam.', # Translate
    'Restrict:' => 'Restreindre:', # Translate
    'Don\'t add nofollow to links in comments by authenticated commenters' => 'Ne pas ajouter No follow sur les liens des commentaires de commentateurs authetifiés', # Translate

    ## ./plugins/TemplateRefresh/TemplateRefresh.pl
    'Backup and refresh existing templates to Movable Type\'s default templates.' => 'Sauvegarder et Rafraichir les habillages existant dans les habillages par défaut de Movable Type.', # Translate

    ## ./plugins/TemplateRefresh/tmpl/results.tmpl
    'Backup and Refresh Templates' => 'Sauvegarder et Rafraichir les habillages', # Translate
    'No templates were selected to process.' => 'Acun habillage sélectionné pour cette action.', # Translate
    'Return' => 'Retour', # Translate

    ## ./plugins/spamlookup/spamlookup_words.pl
    'SpamLookup module for moderating and junking feedback using keyword filters.' => 'Module SpamLookup pour modérer et nettoyer les retours lecteurs en utilisant des mots clefs filtres.', # Translate

    ## ./plugins/spamlookup/spamlookup.pl
    'SpamLookup module for using blacklist lookup services to filter feedback.' => 'Module SpamLookup pour utiliser les services blacklist pour filtrer les retours lecteurs.', # Translate

    ## ./plugins/spamlookup/spamlookup_urls.pl
    'SpamLookup - Link' => 'SpamLookup - Lien', # Translate
    'SpamLookup module for junking and moderating feedback based on link filters.' => ' Module SpamLookup pour modérer et nettoyer les retours lecteurs en utilisant des filtres liens.', # Translate

    ## ./plugins/spamlookup/tmpl/url_config.tmpl
    'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Les Filtres Liens, controlent le nombre d\'hyperliens dans le commentaire ou le trackback. S\'il y a beaucoup de lien, cela pourra être considéré comme indésirable. Dans le cas contraire les retours avec peu de lien ou des liens d\'url déjà publiées seront acceptés. ( N\'activez cette fonction que si vous êtes sur que votre site est propre de tout Spam)', # Translate
    'Link Limits:' => 'Limite de liens:', # Translate
    'Credit feedback rating when no hyperlinks are present' => 'Définir la note pour un retour sans lien', # Translate
    'Adjust scoring' => 'Ajuster la notation', # Translate
    'Score weight:' => 'Poids de la note:', # Translate
    'Less' => 'Moins',
    'Decrease' => 'Baisser',
    'Increase' => 'Augmenter',
    'More' => 'Plus',
    'Moderate when more than' => 'Modérer si plus de', # Translate
    'link(s) are given' => 'lien(s) sont donnés', # Translate
    'Junk when more than' => 'Junk when more than', # Translate
    'Link Memory:' => 'Mémoire de Lien:', # Translate
    'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Attribuer une note à un retour quand &quot;URL&quot; l\'élement du retour a été publié auparavent', # Translate
    'Only applied when no other links are present in message of feedback.' => 'N\'appliquer que si aucun autre lien n\'est présent dans le message de retour.', # Translate
    'Email Memory:' => 'Mémoire Email:', # Translate
    'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Attribuer une note quand un commentaire a auparavent été publié en contenant l\'élement adresse &quot;Email&quot;', # Translate

    ## ./plugins/spamlookup/tmpl/lookup_config.tmpl
    'Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog\'s Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.' => 'Les Lookups controlent les sources des adresses IP et les liens hypertextes de tous les retours lecteurs. Si un commentaire ou un Trackback provient d\'une IP sur liste noire, ou contien un lien ou un domaine sur liste noire, il pourra être automatiquement placé dans le dossier des élements indésirables.', # Translate
    'IP Address Lookups:' => 'IP Addresses Lookups:', # Translate
    'Off' => 'Désactivé',
    'Moderate feedback from blacklisted IP addresses' => 'Modérer les retours des adresses IP en liste noire', # Translate
    'Junk feedback from blacklisted IP addresses' => 'Retours indésirables des adresses IP en liste noire', # Translate
    'block' => 'Bloquer', # Translate
    'none' => 'Aucun', # Translate
    'IP Blacklist Services:' => 'Services de Liste Noire IP:', # Translate
    'Domain Name Lookups:' => 'Lookups Noms de Domaines:', # Translate
    'Moderate feedback containing blacklisted domains' => 'Modérer les retours lecteur en provenance de domaines en liste noire', # Translate
    'Junk feedback containing blacklisted domains' => 'Retours indésirables des domaines en liste noire', # Translate
    'Domain Blacklist Services:' => ' Services de Liste Noire Domaines:', # Translate
    'Advanced TrackBack Lookups:' => 'Lookups Trackbacks:', # Translate
    'Moderate TrackBacks from suspicious sources' => 'Modérer les Trackbacks de sources douteuses', # Translate
    'Junk TrackBacks from suspicious sources' => 'Trackbacks indésirables de sources douteuses', # Translate
    'To prevent lookups for some IP addresses or domains, list them below. Place each entry on a line by itself.' => 'Pour ne pas appliquer le LookUps sur certaines IP ou Domaines, les lister ci-dessous. Une entrée par ligne.', # Translate
    'Lookup Whitelist:' => 'Lookup Liste Blanche:', # Translate

    ## ./plugins/spamlookup/tmpl/word_config.tmpl
    'Incomming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Les retours lecteurs peuvent être controles pour un mot clef spécifique, un nom de domaine, et du contenu. La combinaison de critère permet de détecter les indésirables. Vous pouvez paramétrer vos pondérations pour définir un indésirable.', # Translate
    'Keywords to Moderate:' => 'Mots clefs à modérer:', # Translate
    'Keywords to Junk:' => 'Mots clefs indésirables:', # Translate

    ## ./t/test-common.pl

    ## ./t/test.tmpl

    ## ./t/blog-common.pl

    ## ./t/driver-tests.pl

    ## ./t/plugins/testplug.pl

    ## ./tmpl/error.tmpl
    'Missing Configuration File' => 'Fichier de configuration manquant',
    'Database Connection Error' => 'Erreur de connexion à la base de données',
    'CGI Path Configuration Required' => 'Configuration de chemin CGI requise',
    'An error occurred' => 'Une erreur s\'est produite',

    ## ./tmpl/cms/install.tmpl
    'Welcome to Movable Type!' => 'Bienvenue sur Movable Type!',
    'Before you can begin blogging, we need to complete your installation by initializing your database.' => 'Avant de commencer à pouvoir bloguer vous devez terminer votre installation en initialisant votre base de données.',
    'You will need to select a username and password for the administrator account.' => 'Vous devrez choisir un nom d\'utilisateur et un mot de passe pour l\'administrateur du compte.', # Translate
    'To proceed, you must authenticate properly with your LDAP server.' => 'Pour mettre en place, vous devez vous authentifier correctement avec votre serveur LDAP.', # Translate
    'Title' => 'Titre',
    'Username:' => 'Nom D\'utilisateur:',
    'The name used by this author to login.' => 'Le nom utilisé par cet Auteur pour s\'enregistrer.',
    'Email:' => 'Adresse e-mail:',
    'The author\'s email address.' => 'Adresse email de l\'auteur .',
    'Password:' => 'Mot de Passe:', # Translate
    'Select a password for your account.' => 'Selectionnez un Mot de Passe pour votre compte.', # Translate
    'Password Confirm:' => 'Confirmation du Mot de Passe:',
    'Repeat the password for confirmation.' => 'Répetez la confirmation de Mot de passe.',
    'Your LDAP username.' => 'Votre nom d\'utilisateur LDAP.', # Translate
    'Enter your LDAP password.' => 'Entrez votre Mot de Passe LDAP.', # Translate
    'Finish Install' => 'Finir l\'installation ',

    ## ./tmpl/cms/notification_actions.tmpl
    'Delete' => 'Supprimer',
    'notification address' => 'adresse de notification',
    'notification addresses' => 'adresses de notification',
    'Delete selected notification addresses (d)' => 'Effacer les adresses de notification sélectionnées (d)',

    ## ./tmpl/cms/list_template.tmpl
    'Index Templates' => 'Modèles d\'index',
    'Index templates produce single pages and can be used to publish Movable Type data or plain files with any type of content. These templates are typically rebuilt automatically upon saving entries, comments and TrackBacks.' => 'Les modèle d\'Index génèrent des pages uniques et peuvent être utilisées pour publier des données Movable Type ou des fichiers quel que soit leur contenu. Ces modèles sont généralement reconstruits automatiquement en sauvegardant les notes, commentaires ou TrackBacks.',
    'Archive Templates' => 'Modèles d\'archives ',
    'Archive templates are used for producing multiple pages of the same archive type.  You can create new ones and map them to archive types on the publishing settings screen for this weblog.' => 'Les modèles d\'archives sont utilisés pour produire des pages multiples d\'un même type d\'archives. Vous pouvez en créer de nouvelles et les relier aux type d\'archives sur l\'écran des paramètres de publication de ce weblog.',
    'System Templates' => 'Modèles Système',
    'System templates specify the layout and style of a small number of dynamic pages which perform specific system functions in Movable Type.' => 'Les modèles Systèmes spécifient la mise en page d\'un petit nombre de pages dynamiques qui réalisent des fonctions système spécifiques à Movable Type.',
    'Template Modules' => 'Modules de modèles',
    'Template modules are mini-templates that produce nothing on their own but instead can be included into other templates.  They are excellent for duplicated content (e.g. header or footer content) and can contain template tags or just static text.' => 'Les modules de modèles sont des mini-modèles qui ne produisent rien en soi mais peuvent être inclus dans d\'autres modèles. Ils sont très utiles pour dupliquer un contenu (par exemple le contenu des entêtes et pieds de page) et peuvent inclure des tags de modèles ou simplement du texte.',
    'You have successfully deleted the checked template(s).' => 'Les modèles sélectionnés ont été supprimés.',
    'Your settings have been saved.' => 'Vos paramètres ont été enregistrés.',
    'Indexes' => 'Index',
    'System' => 'Système',
    'Modules' => 'Modules', # Translate
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
    'No index templates could be found.' => 'Aucun Modèle d\'Index n\'a été trouvé.',
    'No archive templates could be found.' => 'Aucun Modèle d\'Archives n\'a été trouvé.',
    'Description' => 'Description', # Translate
    'No template modules could be found.' => 'Aucun Module de Modèle n\'a été trouvé.',
    'Plugin Actions' => 'Actions du plugin',

    ## ./tmpl/cms/list_commenters.tmpl
    'Authenticated Commenters' => 'Commentateurs authentifiés',
    'The selected commenter(s) has been given trusted status.' => 'Le statut fiable a été accordé au(x) Commentateur(s) sélectionné(s).',
    'Trusted status has been removed from the selected commenter(s).' => 'Le(s) commentateur(s) sélectionné(s) n\'est plus en statut fiable.',
    'The selected commenter(s) have been blocked from commenting.' => 'Le(s) commentateur(s) sélectionné(s) ne peut plus commenter.',
    'The selected commenter(s) have been unbanned.' => 'Le(s) commentateur(s) sélectionné(s) n\'est plus bannis.',
    'Go to Comment Listing' => 'Aller à la liste des commentaires',
    'Quickfilter:' => 'Filtre Rapide:',
    'Show unpublished comments.' => 'Afficher les commentaires non publiés.',
    'Reset' => 'Effacer',
    'Filter:' => 'Filtrer:',
    'Showing all commenters.' => 'Afficher tous les commentateurs.',
    'Showing only commenters whose [_1] is [_2].' => 'Ne montrer que les commentateur dont  [_1] est [_2].', # Translate
    'Show' => 'Afficher',
    'all' => 'tous/toutes',
    'only' => 'uniquement',
    'commenters.' => 'les commentateurs.',
    'commenters where' => 'les commentateurs dont',
    'status' => 'le statut',
    'commenter' => 'le commentateur',
    'is' => 'est',
    'trusted' => 'fiable',
    'untrusted' => 'non fiable',
    'banned' => 'banni',
    'unauthenticated' => 'non authentifié',
    'authenticated' => 'authentifié',
    '.' => '.', # Translate
    'Filter' => 'Filtrer',
    'No commenters could be found.' => 'Aucun commentateur trouvé.',

    ## ./tmpl/cms/upload_confirm.tmpl
    'Upload File' => 'Télécharger un fichier',
    'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'Le fichier \'[_1]\' existe déjî Souhaitez-vous le remplacer?',

    ## ./tmpl/cms/show_upload_html.tmpl
    'Copy and paste this HTML into your entry.' => 'Copiez/collez ce code HTML dans votre note.',
    'Close' => 'Fermer',
    'Upload Another' => 'Télécharger un autre fichier',

    ## ./tmpl/cms/copyright.tmpl

    ## ./tmpl/cms/rebuilt.tmpl
    'Rebuild' => 'Actualiser',
    'All of your files have been rebuilt.' => 'Tous vos fichiers ont été actualisés.',
    'Your [_1] has been rebuilt.' => 'Votre [_1] a été actualisé(e).',
    'Your [_1] pages have been rebuilt.' => 'Vos pages [_1] ont été actualisées.',
    'View your site' => 'Voir votre site',
    'View this page' => 'Afficher cette page',
    'Rebuild Again' => 'Actualiser une nouvelle fois',

    ## ./tmpl/cms/commenter_actions.tmpl
    'Trust' => 'Fiable',
    'commenters' => 'commentateurs',
    'to act upon' => 'pour agir sur',
    'Trust commenter' => 'Commentateur Fiable',
    'Untrust' => 'Non Fiable',
    'Untrust commenter' => 'Commentateur Non Fiable',
    'Ban' => 'Bannir',
    'Ban commenter' => 'Commentateur Banni',
    'Unban' => 'Non banni',
    'Unban commenter' => 'Commentateur réactivé',
    'Trust selected commenters' => 'Attribuer le statut Fiable au(x) Commentateur(s) sélectionné(s)',
    'Ban selected commenters' => 'Bannir le(s) Commentateurs sélectionné(s)',

    ## ./tmpl/cms/author_table.tmpl
    'Username' => 'Nom d\'utilisateur',
    'Name' => 'Nom',
    'Email' => 'Adresse e-mail',
    'URL' => 'URL', # Translate
    'Link' => 'Lien',

    ## ./tmpl/cms/ping_actions.tmpl
    'to publish' => 'pour publier',
    'Publish' => 'Publier',
    'Publish selected TrackBacks (p)' => 'Publier les Trackbacks sélectionnés (p)',
    'Delete selected TrackBacks (d)' => 'Effacer les Trackbacks sélectionnés (d)',
    'Junk' => 'Indésirable',
    'Junk selected TrackBacks (j)' => 'Jeter les Trackbacks sélectionnés (j)',
    'Not Junk' => 'Non Indésirable',
    'Recover selected TrackBacks (j)' => 'Retrouver les Trackbacks sélectionnés (j)',
    'Are you sure you want to remove all junk TrackBacks?' => 'Etes-vous sur de vouloir supprimer tous les Trackbacks indésirables?', # Translate
    'Empty Junk Folder' => 'Dossier Indésirables vide', # Translate
    'Deletes all junk TrackBacks' => 'Effacer tous les TrackBacks indésirables', # Translate
    'Ban This IP' => 'Bannir cette adresse IP',

    ## ./tmpl/cms/bm_posted.tmpl
    'Your new entry has been saved to [_1]' => 'Votre nouvelle note a été enregistrée dans [_1]',
    ', and it has been posted to your site' => 'et a été publiée sur votre site',
    '. ' => '. ', # Translate
    'Edit this entry' => 'Modifier cette note',

    ## ./tmpl/cms/list_blog.tmpl
    'Movable Type News' => 'News Movable Type',
    'System Shortcuts' => 'Raccourcis système',
    'Weblogs' => 'Weblogs', # Translate
    'Concise listing of weblogs.' => 'Liste résumée des weblogs.',
    'Authors' => 'Auteurs',
    'Create, manage, set permissions.' => 'Créer, gérer et accorder les autorisations.',
    'Plugins' => 'Plugins', # Translate
    'What\'s installed, access to more.' => 'Eléments installés, accéder à plus.',
    'Entries' => 'Notes',
    'Multi-weblog entry listing.' => 'Listing des notes des tous les weblogs.',
    'Tags' => 'Tags', # Translate
    'Multi-weblog tag listing.' => 'Liste Multi-weblog tag .', # Translate
    'Multi-weblog comment listing.' => 'Listing des commentaires de tous les weblogs.',
    'Multi-weblog TrackBack listing.' => 'Listing des TrackBacks de tous les weblogs.',
    'Settings' => 'Paramètres',
    'System-wide configuration.' => 'Configuration générale du système.',
    'Search &amp; Replace' => 'Chercher &amp; Remplacer',
    'Find everything. Replace anything.' => 'Rechercher et/ou remplacer un élément.',
    'Activity Log' => 'Journal des activités',
    'What\'s been happening.' => 'Historique des actions.',
    'Status &amp; Info' => 'Statut &amp; Info',
    'Server status and information.' => 'Information et statut serveur.',
    'QuickPost' => 'QuickPost', # Translate
    'Set Up A QuickPost Bookmarklet' => 'Installer le Bookmarklet QuickPost',
    'Enable one-click publishing.' => 'Activer la publication en un clic.',
    'My Weblogs' => 'Mes Weblogs',
    'Warning' => 'Attention',
    'Important:' => 'Important:', # Translate
    'Configure this weblog.' => 'Configurer ce weblog.',
    'Create New Entry' => 'Créer  une nouvelle note',
    'Create a new entry' => 'Créer une note',
    'Create a new entry on this weblog' => 'Créer une nouvelle note sur ce weblog', # Translate
    'Templates' => 'Modèles',
    '_external_link_target' => '_cible_lien_externe', # Translate
    'View Site' => 'Voir le site',
    'Show Display Options' => 'Options d\'affichage',
    'Display Options' => 'Options d\'affichage',
    'Sort By:' => 'Trié par:',
    'Weblog Name' => 'Nom du Weblog',
    'Creation Order' => 'Ordre de création',
    'Last Updated' => 'Dernière Mise à jour',
    'Order:' => 'Ordre:',
    'Ascending' => 'Croissant',
    'Descending' => 'Décroissant',
    'View:' => 'Vue:',
    'Compact' => 'Compacte',
    'Expanded' => 'Etendue',
    'Save' => 'Enregistrer',

    ## ./tmpl/cms/upload_complete.tmpl
    'Your file has been uploaded. Size: [quant,_1,byte].' => 'Votre fichier a été téléchargé. Taille: [quant,_1,octet].',
    'Create a new entry using this uploaded file' => 'Créer une note à l\'aide de ce fichier téléchargé.',
    'Show me the HTML' => 'Afficher le code HTML',
    'Image Thumbnail' => 'Vignette',
    'Create a thumbnail for this image' => 'Créer une vignette pour cette image',
    'Width:' => 'Largeur:',
    'Pixels' => 'Pixels', # Translate
    'Percent' => 'Pourcentage',
    'Height:' => 'Hauteur:',
    'Constrain proportions' => 'Contraindre les proportions',
    'Would you like this file to be a:' => 'Ce fichier doit être:',
    'Popup Image' => 'Image dans une fenêtre popup',
    'Embedded Image' => 'Image intégrée à la note',

    ## ./tmpl/cms/feed_link.tmpl
    'Activity Feed' => 'Flux d\'activité', # Translate
    'Activity Feed (Disabled)' => 'Flux d\'activité (Désactivé)', # Translate
    'Disabled' => 'Désactivé',
    'Set Web Services Password' => 'Définir un mot de passe Web services', # Translate

    ## ./tmpl/cms/edit_author.tmpl
    'Your API Password is currently' => 'Le mot de passe de votre API est',
    'Author Profile' => 'Profil de l\'auteur',
    'Create New Author' => 'Créer un nouvel auteur',
    'Your profile has been updated.' => 'Votre profil a été mis à jour.',
    'Permissions' => 'Autorisations',
    'Weblog Associations' => 'Associations de Weblogs',
    'General Permissions' => 'Autorisations générales',
    'System Administrator' => 'Administrateur Système',
    'Create Weblogs' => 'Créer des Weblogs',
    'View Activity Log' => 'Afficher le journal des activités',
    'Profile' => 'Profil',
    'Username (*):' => 'Nom d\'utilisateur (*):', # Translate
    'Display Name:' => 'Afficher nom:',
    'The author\'s published name.' => 'Nom publié de l\'auteur.',
    'Email Address (*):' => 'Adresse Email (*):', # Translate
    'Website URL:' => 'URL du site:',
    'The URL of this author\'s website. (Optional)' => 'URL du site de  l\'auteur. (option)',
    'Language:' => 'Langue:',
    'The author\'s preferred language.' => 'Langue choisie par l\'auteur.',
    'Password' => 'Mot de passe',
    'Current Password:' => 'Mot de passe actuel:',
    'Enter the existing password to change it.' => 'Entrez le mot de passe actuel pour le changer.',
    'New Password:' => 'Nouveau Mot de Passe:',
    'Initial Password (*):' => 'Mot de Passe Initial (*):', # Translate
    'Select a password for the author.' => 'Choisissez un mot de passe pour  l\'auteur.',
    'Password hint (*):' => 'Aide Mémoire Mot de Passe (*):', # Translate
    'For password recovery.' => 'Pour récupérer votre mot de passe.',
    'API Password:' => 'Mot de Passe API:',
    'Reveal' => 'Révélé',
    'For use with XML-RPC and Atom-enabled clients.' => 'Pour une utilisation avec des clients XML-RPC et Atom.',
    'Password hint:' => 'Pense-bête du Mot de Passe :',
    'Save Changes' => 'Enregistrer les modifications',
    'Save this author (s)' => 'Sauvegarder cet auteur (s)',

    ## ./tmpl/cms/edit_template.tmpl
    'Edit Template' => 'Modifier un modèle',
    'Your template changes have been saved.' => 'Les modifications apportées ont été enregistrées.',
    'Rebuild this template' => 'Actualiser ce modèle',
    'Build Options' => 'Options de compilation',
    'Enable dynamic building for this template' => 'Activer la compilation dynamique pour ce modèle',
    'Rebuild this template automatically when rebuilding index templates' => 'Actualiser ce modèle en même temps que les modèles d\'index',
    'Comment Listing Template' => 'Modèle de liste des commentaires',
    'Comment Preview Template' => 'Modèle d\'aperçu des commentaires',
    'Comment Error Template' => 'Modèle d\'avertissement d\'erreur liée aux commentaires',
    'Comment Pending Template' => 'Modèle d\'avertissement de commentaires en attente',
    'Commenter Registration Template' => 'Modèle d\'inscription des auteurs de commentaires',
    'TrackBack Listing Template' => 'Modèle de liste TrackBack',
    'Uploaded Image Popup Template' => 'Modèle de fenêtre de téléchargement d\'images',
    'Dynamic Pages Error Template' => 'Modèle d\'erreur de page dynamique',
    'Link this template to a file' => 'Lier ce modèle à un fichier',
    'Module Body' => 'Corps du module',
    'Template Body' => 'Corps du modèle',
    'Save this template (s)' => 'Sauvegarder ce modèle (s)',
    'Save and Rebuild' => 'Sauvegarder et Reconstruire',
    'Save and rebuild this template (r)' => 'Sauvegarder et reconstruire ce modèle (r)',

    ## ./tmpl/cms/cfg_system_feedback.tmpl
    'System-wide' => 'Dans tout le système',
    'This screen allows you to configure feedback and outbound TrackBack settings for the entire installation.  These settings override any similar settings for individual weblogs.' => 'Cet écran vous permet de configurer les paramètres des feedbacks et des TrackBacks sortants pour l\'ensemble de l\'installation. Ces paramètres priment sur les paramétrages que vous auriez pu faire sur un weblog donné.',
    'Your feedback preferences have been saved.' => 'Vos préférences feedback sont enregistrées.',
    'Feedback Master Switch' => 'Contrôle principal des Feedbacks',
    'Disable Comments' => 'Désactiver les commentaires',
    'Stop accepting comments on all weblogs' => 'Ne plus accepter les commentaires sur TOUS les weblogs',
    'This will override all individual weblog comment settings.' => 'Cette action prime sur tout paramétrage des commentaires mis en place au niveau de chaque weblog.',
    'Disable TrackBacks' => 'Désactiver les TrackBacks',
    'Stop accepting TrackBacks on all weblogs' => 'Ne plus accepter les TrackBacks sur TOUS vos weblogs',
    'This will override all individual weblog TrackBack settings.' => 'Cette action prime sur tout paramétrage des TrackBacks mis en place au niveau de chaque weblog.',
    'Outbound TrackBack Control' => 'Contrôle des TrackBacks sortants',
    'Allow outbound TrackBacks to:' => 'Autoriser les TrackBacks sortant sur:',
    'Any site' => 'N\'importe quel site',
    'No site' => 'Aucun site',
    '(Disable all outbound TrackBacks.)' => '(Désactiver tous les TrackBacks sortants.)',
    'Only the weblogs on this installation' => 'Uniquement les weblogs sur cette installation',
    'Only the sites on the following domains:' => 'Uniquement les sites sur les domaines suivants:',
    'This feature allows you to limit outbound TrackBacks and TrackBack auto-discovery for the purposes of keeping your installation private.' => 'Cette fonctionnalité vous permet de limiter les TrackBacks sortants et la découverte automatique des TrackBacks pour conserver la confidentialité de votre installation.',
    'Save changes (s)' => 'Enregistrer les modifications',

    ## ./tmpl/cms/entry_actions.tmpl
    'Save these entries (s)' => 'Sauvegarder ces notes (s)',
    'Save this entry (s)' => 'Sauvegarder cette note (s)',
    'Preview this entry (p)' => 'Prévisualiser cette note (p)',
    'entry' => 'note',
    'entries' => 'notes',
    'Delete this entry (d)' => 'Effacer cette note (d)',
    'to rebuild' => 'pour reconstruire',
    'Rebuild selected entries (r)' => 'Reconstruire les notes sélectionnées (r)',
    'Delete selected entries (d)' => 'Effacer les notes sélectionnées (d)',

    ## ./tmpl/cms/edit_comment.tmpl
    'Edit Comment' => 'Modifier les commentaires',
    'Your changes have been saved.' => 'Les modifications ont été enregistrées.',
    'The comment has been approved.' => 'Le commentaire a été approuvé.',
    'Previous' => 'Précédent',
    'List &amp; Edit Comments' => 'Lister &amp; Editer les commentaires',
    'Next' => 'Suivant',
    'View Entry' => 'Afficher la note',
    'Pending Approval' => 'En attente d\'approbation',
    'Junked Comment' => 'Commentaire indésirable',
    'Status:' => 'Statut:',
    'Published' => 'Publié',
    'Unpublished' => 'Non publié',
    'View all comments with this status' => 'Voir tous les commentaires avec ce statut',
    'Commenter:' => 'Commentateur:',
    'Trusted' => 'Fiable',
    '(Trusted)' => '(Fiable)',
    'Ban&nbsp;Commenter' => 'Bannir&nbsp;le&nbsp;Commentateur',
    'Untrust&nbsp;Commenter' => 'Commentateur non fiable',
    'Banned' => 'Banni',
    '(Banned)' => '(Banni)',
    'Trust&nbsp;Commenter' => 'Faire&nbsp;confiance&nbsp;au&nbsp;Commentateur',
    'Unban&nbsp;Commenter' => 'Commentateur autorisé à nouveau',
    'Pending' => 'En attente',
    'View all comments by this commenter' => 'Afficher tous les commentaires de ce commentateur',
    'None given' => 'Non fourni',
    'View all comments with this email address' => 'Afficher tous les commentaires associés à cette adresse email',
    'View all comments with this URL' => 'Afficher tous les commentaires associés à cette URL',
    'Entry:' => 'Note:',
    'Entry no longer exists' => 'Cette note n\'existe plus',
    'No title' => 'Sans titre',
    'View all comments on this entry' => 'Afficher tous les commentaires associés à cette note',
    'Date:' => 'Date:', # Translate
    'View all comments posted on this day' => 'Afficher tous les commentaires postés ce même jour',
    'IP:' => 'IP:', # Translate
    'View all comments from this IP address' => 'Afficher tous les commentaires associés à cette adresse IP',
    'Save this comment (s)' => 'Sauvegarder ce commentaire (s)',
    'comment' => 'commentaire',
    'comments' => 'commentaires',
    'Delete this comment (d)' => 'Effacer ce commentaire (d)',
    'Final Feedback Rating' => 'Notation finale des Feedbacks',
    'Test' => 'Test', # Translate
    'Score' => 'Score', # Translate
    'Results' => 'Résultats',

    ## ./tmpl/cms/author_actions.tmpl
    'author' => 'l\'auteur',
    'authors' => 'auteurs',
    'Delete selected authors (d)' => 'Effacer les auteurs sélectionnés (d)',

    ## ./tmpl/cms/bm_entry.tmpl
    'Select' => 'Sélectionner',
    'Add new category...' => 'Ajouter une catégorie...',
    'You must choose a weblog in which to post the new entry.' => 'Vous devez sélectionner le weblog dans lequel publier cette note.',
    'Select a weblog for this post:' => 'Sélectionnez un weblog pour cette note:',
    'Select a weblog' => 'Sélectionnez un weblog',
    'Primary Category' => 'Catégorie principale',
    'Assign Multiple Categories' => 'Affecter plusieurs catégories',
    'Post Status' => 'Etat de publication',
    'Entry Body' => 'Corps de la note',
    'Bold' => 'Gras',
    'Italic' => 'Italique',
    'Underline' => 'Souligné',
    'Insert Link' => 'Insérer un lien',
    'Insert Email Link' => 'Insérer le lien vers l\'e-mail',
    'Quote' => 'Citation',
    'Extended Entry' => 'Suite de la note',
    'Excerpt' => 'Extrait',
    'Keywords' => 'Mots-clés',
    'Send an outbound TrackBack:' => 'Envoyer un TrackBack:',
    'Select an entry to send an outbound TrackBack:' => 'Choisissez une note pour envoyer un TrackBack:',
    'None' => 'Aucune',
    'Text Formatting' => 'Mise en forme du texte',
    'Accept' => 'Accepter', # Translate
    'Basename' => 'Nom de base',
    'Unlock this entry\'s output filename for editing' => 'Dévérouiller le nom du fichier de  cette note pour l\'éditer ',
    'Warning: If you set the basename manually, it may conflict with another entry.' => 'ATTENTION: Editer le nom de base manuellement peut créer des conflits avec d\'autres notes.',
    'Warning: Changing this entry\'s basename may break inbound links.' => 'ATTENTION: Changer le nom de base de cette note peut casser des liens entrants.',
    'You do not have entry creation permission for any weblogs on this installation. Please contact your system administrator for access.' => 'Vous n\'avez pas accès à la création de weblog dans cette installation. Merci de contacter votre Administrateur Système pour avoir un accès.',

    ## ./tmpl/cms/tag_table.tmpl
    'Date' => 'Date', # Translate
    'IP Address' => 'Adresse IP',
    'Log Message' => 'Message du journal',

    ## ./tmpl/cms/comment_actions.tmpl
    'Publish selected comments (p)' => 'Publier les commentaires sélectionnés (p)',
    'Delete selected comments (d)' => 'Effacer les commentaires sélectionnés (d)',
    'Junk selected comments (j)' => 'Commentaires sélectionnés indésirables (j)',
    'Recover selected comments (j)' => 'Récupérer les commentaires sélectionnés (j)',
    'Are you sure you want to remove all junk comments?' => 'Etes vous sur de vouloir supprimer tous les commentaires indésirables?', # Translate
    'Deletes all junk comments' => 'Efface tous les commentaires indésirables', # Translate

    ## ./tmpl/cms/import_start.tmpl
    'Importing...' => 'Importation...',
    'Importing entries into blog' => 'Importation de notes dans le blog',
    'Importing entries as author \'[_1]\'' => 'Importation des notes en tant qu\'auteur \'[_1]\'',
    'Creating new authors for each author found in the blog' => 'Création de nouveaux auteur correspondant à chaque auteur trouvé dans le blog',

    ## ./tmpl/cms/edit_author_bulk.tmpl
    'File From Your Computer:' => 'Fichier de votre ordinateur:', # Translate
    'To upload a file to your server, click on the browse button to locate the file on your hard drive.' => 'Cliquez sur le bouton Parcourir pour sélectionner un fichier de votre disque dur à télécharger vers le serveur.',
    'Encoding:' => 'Encodage:', # Translate
    'Choose an encoding method name of the file.' => 'Choisir le nom de la méthode d\'encodage pour le fichier.', # Translate
    'Upload' => 'Télécharger',

    ## ./tmpl/cms/cfg_entries.tmpl
    'New Entry Default Settings' => 'Paramètres par défaut des nouvelle notes',
    'This screen allows you to control default settings for new entries as well as your publicity and remote interface settings.' => 'Cet écran vous permet de contrôler les paramètres par défaut des nouvelles entrées ainsi que la promotion et l\'interface de paramétrage à distance.',
    'General' => 'Général',
    'New Entry Defaults' => 'Nouvelle note par défaut',
    'Feedback' => 'Feedback', # Translate
    'Publishing' => 'Publication',
    'IP Banning' => 'Bannissement d\'adresses IP',
    'Your blog preferences have been saved.' => 'Les préférences de votre weblog ont été enregistrées.',
    'Default Settings for New Entries' => 'Paramètres par défaut des nouvelles notes',
    'Specifies the default Post Status when creating a new entry.' => 'Spécifie l\'état de publication par défaut des nouvelles notes.',
    'Specifies the default Text Formatting option when creating a new entry.' => 'Spécifie l\'option par défaut de mise en forme du texte des nouvelles notes.',
    'Accept Comments' => 'Accepter commentaires',
    'Specifies the default Accept Comments setting when creating a new entry.' => 'Spécifie l\'option par défaut des commentaires acceptés lors de la création d\'une nouvelle note.',
    'Setting Ignored' => 'Paramétrage ignoré',
    'Note: This option is currently ignored since comments are disabled either weblog or system-wide.' => 'Note: Cette option est ignorée tant que les commentaires sont désactivés sur une note ou dans l\'ensemble du système.',
    'Accept TrackBacks:' => 'Accepter TrackBacks:',
    'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Spécifie l\'option par défaut des TrackBacks acceptés lors de la création d\'une nouvelle note.',
    'Note: This option is currently ignored since TrackBacks are disabled either weblog or system-wide.' => 'Note: Cette option est ignorée tant que les TrackBacks sont désactivés sur une note ou sur l\'ensemble du système.',
    'Basename Length:' => 'Longueur du nom de base:',
    'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => 'Spécifier la longueur par défaut du nom de base. peut être comprise entre 15 et 250.',
    'Publicity/Remote Interfaces' => 'Publicité/Interfaces distantes',
    'Notify the following sites upon weblog updates:' => 'Notifier les sites suivants lors des mises à jour du weblog:',
    'Others:' => 'Autres:',
    '(Separate URLs with a carriage return.)' => '(Séparer les URLs avec un retour chariot.)',
    'When this weblog is updated, Movable Type will automatically notify the selected sites.' => 'Lors des mises à jour de ce weblog Movable Type notifiera automatiquement les sites sélectionnés.',
    'Setting Notice' => 'Paramétrage des informations',
    'Note: The above option may be affected since outbound pings are constrained system-wide.' => 'Attention: L\'option ci-dessous peut être affectée si les pings sortant sont limités dans le système.',
    'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Attention: Cette option est ignorée car les pings sortants sont désactivés globalement.',
    'Recently Updated Key:' => 'Clé de mise à jour récente:',
    'If you have received a recently updated key (by virtue of your purchase or donation), enter it here.' => 'Cet espace vous permet d\'indiquer votre clé de mise à jour récente (que vous auriez pu recevoir en raison de votre achat ou de votre contribution financière).',
    'TrackBack Auto-Discovery' => 'Découverte automatique des TrackBacks',
    'Enable External TrackBack Auto-Discovery' => 'Activer Auto-découverte Trackback Externe',
    'Note: The above option is currently ignored since outbound pings are disabled system-wide.' => 'Attention: l\'option ci-dessus est ignorée si les pings sortants sont désactivés dans le système',
    'Enable Internal TrackBack Auto-Discovery' => 'Activer Auto-découverte Trackback Interne',
    'If you turn on auto-discovery, when you write a new post, any external links will be extracted and the appropriate sites automatically sent TrackBacks.' => 'Si vous activez la découverte automatique, quand vous écrirez une nouvelle note, les liens externes seront extraits et les sites concernés recevront automatiquement un TrackBack.',

    ## ./tmpl/cms/list_tags.tmpl
    'Your tag changes and additions have been made.' => 'Votre changement de tag et les compléments ont été faits.', # Translate
    'You have successfully deleted the selected tags.' => 'Vous avez effacé correctement les tags sélectionnés.', # Translate
    'Tag Name' => 'Nom du Tag', # Translate
    'Click to edit tag name' => 'Cliquez pour modifier le nom du tag', # Translate
    'Rename' => 'Changer le nom', # Translate
    'Show all entries with this tag' => 'Afficher toutes les notes pour ce tag', # Translate
    '[quant,_1,entry,entries]' => '[quant,_1,note,notes]',
    'tag' => 'tag', # Translate
    'tags' => 'tags', # Translate
    'Delete selected tags (d)' => 'Effacer les tags sélectionnés (d)', # Translate
    'No tags could be found.' => 'Aucun tag n\'a été trouvé.', # Translate

    ## ./tmpl/cms/log_table.tmpl

    ## ./tmpl/cms/comment_table.tmpl
    'Status' => 'Statut',
    'Comment' => 'Commentaire',
    'Commenter' => 'Commentateur',
    'Weblog' => 'Weblog', # Translate
    'Entry' => 'Note',
    'IP' => 'IP', # Translate
    'Only show published comments' => 'N\'afficher que les commentaires publiés',
    'Only show pending comments' => 'N\'afficher que les commentaires en attente',
    'Edit this comment' => 'Editer ce commentaire',
    'Edit this commenter' => 'Editer ce commentateur',
    'Blocked' => 'Bloqué',
    'Authenticated' => 'Authentifié',
    'Search for comments by this commenter' => 'Chercher les commentaires de ce commentateur',
    'Show all comments on this entry' => 'Afficher tous les commentaires de cette note',
    'Search for all comments from this IP address' => 'Rechercher tous les commentaires associés à cette adresse IP',

    ## ./tmpl/cms/template_actions.tmpl
    'template' => 'Habillage', # Translate
    'templates' => 'Habillages', # Translate

    ## ./tmpl/cms/list_author.tmpl
    'Open power-editing mode' => 'Passer en mode d\'édition avancée',
    'You have successfully deleted the authors from the Movable Type system.' => 'Les auteurs ont été effacés du système Movable Type.',
    'Download CSV' => 'Télécharger CSV', # Translate
    'Download a CSV file of this data.' => 'Télécharger un fichier CVS de ces données', # Translate
    'Created By' => 'Créé par',
    'Last Entry' => 'Dernière Note',

    ## ./tmpl/cms/list_entry.tmpl
    'Your entry has been deleted from the database.' => 'Votre note a été supprimée de la base de données.',
    'Show unpublished entries.' => 'Montrer les notes non publiées.',
    '(Showing all entries)' => '(En montrant toutes les notes)', # Translate
    'Showing only entries where [_1] is [_2].' => 'En affichant les notes où [_1] est [_2].', # Translate
    'entries.' => 'les notes.',
    'entries where' => 'notes dont',
    'category' => 'la catégorie',
    'published' => 'publié',
    'unpublished' => 'non publié',
    'scheduled' => 'programmé',
    'No entries could be found.' => 'Aucune note n\'a pu être trouvée.',

    ## ./tmpl/cms/import.tmpl
    'Import / Export' => 'Importer / Exporter',
    'Transfer weblog entries into Movable Type from other blogging tools or export your entries to create a backup or copy.' => 'Transférer les notes d\'un autre weblog vers Movable Type, ou exporter les notes en vue d\'une sauvegarde.',
    'Import Entries' => 'Importer des notes',
    'Export Entries' => 'Exporter des notes',
    'Import entries as me' => 'Importer les notes sous mon nom',
    'Password (required if creating new authors):' => 'Mot de passe (requis pour les nouveaux auteurs):',
    'You will be assigned the author of all imported entries.  If you wish the original authors to keep ownership, you must contact your MT system administrator to perform the import so that new authors can be created if necessary.' => 'Vous serez considéré comme l\'auteur de toutes les notes importées. Si vous souhaitez conserver l\'attribution à l\'auteur original de ces notes, vous devez contacter votre administrateur système Movable Type pour effectuer l\'importation.',
    'Default category for entries (optional):' => 'Catégorie par défaut des notes (facultatif):',
    'Select a category' => 'Sélectionnez une catégorie',
    'Default post status for entries (optional):' => 'Etat de publication par défaut des notes (facultatif):',
    'Select a post status' => 'Sélectionnez un état de publication',
    'Start title HTML (optional):' => 'Code HTML précédant le titre (facultatif):',
    'End title HTML (optional):' => 'Code HTML suivant le titre (facultatif):',
    'File From Your Computer (optional):' => 'Fichier de votre ordinateur (facultatif):', # Translate
    'Encoding (optional):' => 'Encodage (Facultatif):', # Translate
    'Export Entries From [_1]' => 'Exporter les notes de [_1]',
    'Export Entries to Tangent' => 'Exporter les notes vers Tangent',

    ## ./tmpl/cms/pending_commenter.tmpl

    ## ./tmpl/cms/bookmarklets.tmpl
    'Add QuickPost to Windows right-click menu' => 'Ajouter QuickPost au menu contextuel de Windows (clic droit)',
    'Configure QuickPost' => 'Configurer QuickPost',
    'Include:' => 'Inclure:',
    'TrackBack Items' => 'Eléments de TrackBack',
    'Category' => 'Catégorie',
    'Allow Comments' => 'Autoriser les commentaires',
    'Allow TrackBacks' => 'Autoriser les TrackBacks',
    'Create' => 'Créer',

    ## ./tmpl/cms/footer.tmpl

    ## ./tmpl/cms/upload.tmpl
    'Choose a File' => 'Choisir un fichier',
    'File:' => 'Fichier:',
    'Choose a Destination' => 'Choisir une destination',
    'Upload Into:' => 'Télécharger dans:',
    '(Optional)' => '(facultatif)',
    'Local Archive Path' => 'Chemin local des archives',
    'Local Site Path' => 'Chemin local du site',

    ## ./tmpl/cms/edit_commenter.tmpl
    'Commenter Details' => 'Détails sur le commentateur',
    'The commenter has been trusted.' => 'Le commentateur est fiable.',
    'The commenter has been banned.' => 'Le commentateur a été banni.',
    'Junk Comments' => 'Commentaires indésirables',
    'View all comments with this name' => 'Afficher tous les commentaires associés à ce nom',
    'Identity:' => 'Identité:',
    'Withheld' => 'Retenu',
    'View all comments with this URL address' => 'Afficher tous les commentaires associés à cette URL',
    'View all commenters with this status' => 'Afficher tous les commentateurs ayant ce statut',

    ## ./tmpl/cms/blog-left-nav.tmpl
    'Posting' => 'Poster',
    'New Entry' => 'Nouvelle note',
    'List Entries' => 'Afficher les notes',
    'Community' => 'Communauté',
    'List Comments' => 'Afficher les commentaires',
    'List Commenters' => 'Lister les commentateurs',
    'Commenters' => 'Commentateurs',
    'List TrackBacks' => 'Lister les TrackBacks',
    'Edit Notification List' => 'Modifier la liste des avis',
    'Notifications' => 'Notifications', # Translate
    'Configure' => 'Configurer',
    'List &amp; Edit Templates' => 'Lister &amp; Editer les habillages',
    'Edit Categories' => 'Modifier les catégories',
    'Edit Tags' => 'Editer les Tags', # Translate
    'Edit Weblog Configuration' => 'Modifier la configuration du weblog',
    'Utilities' => 'Utilitaires',
    'Import &amp; Export Entries' => 'Importer &amp; Exporter les Notes',
    'Rebuild Site' => 'Actualiser le site',

    ## ./tmpl/cms/entry_prefs.tmpl
    'Your entry screen preferences have been saved.' => 'Vos préférences d\'édition ont été enregistrées.',
    'Field Configuration' => 'Configuration des champs',
    '(Help?)' => '(Aide?)',
    'Basic' => 'Basique',
    'Advanced' => 'Avancée',
    'Custom: show the following fields:' => 'Personnalisée. Afficher les champs suivants:',
    'Editable Authored On Date' => 'Date de création modifiable',
    'Outbound TrackBack URLs' => 'URLs TrackBacks sortants',
    'Button Bar Position' => 'Position de la barre de boutons',
    'Top of the page' => 'Haut de la page',
    'Bottom of the page' => 'Bas de la page',
    'Top and bottom of the page' => 'Haut et bas de la page',

    ## ./tmpl/cms/upgrade.tmpl
    'Time to Upgrade!' => 'Il est temps de mettre à jour!',
    'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Une nouvelle version de Movable Type a été installée. Nous avons besoin de faire quelques manipulations complémentaires pour mettre à jour votre base de données.',
    'Begin Upgrade' => 'Commencer la Mise à Jour',

    ## ./tmpl/cms/edit_placements.tmpl
    'The secondary categories for this entry have been updated. You will need to SAVE the entry for these changes to be reflected on your public site.' => 'Les catégories secondaires de cette note ont été mises à jour. Vous devez enregistrer la note pour voir les modifications reflétées sur votre site public',
    'Categories in your weblog:' => 'Catégories de votre weblog:',
    'Secondary categories:' => 'Catégories secondaires:',
    'Assign &gt;&gt;' => 'Assigner &gt;&gt;', # Translate
    '&lt;&lt; Remove' => '&lt;&lt; Supprimer', # Translate

    ## ./tmpl/cms/junk_results.tmpl
    'Find Junk' => 'Trouver indésirable(s)',
    'The following items may be junk. Uncheck the box next to any items are NOT junk and hit JUNK to continue.' => 'Les élements suivants sont peut-être indésirables. Décochez les cases des élements qui ne sont pas indésirables et cliquez sur le bouton pour continuer.', # Translate
    'To return to the comment list without junking any items, click CANCEL.' => 'Pour retourner à la liste des commentaires sans sélectionner d\'élement indésirables clliquez sur annuler.', # Translate
    'Approved' => 'Approuvé',
    'Registered Commenter' => 'Commentateur inscrit',
    'Return to comment list' => 'Retourner à la liste des commentaires', # Translate

    ## ./tmpl/cms/commenter_table.tmpl
    'Identity' => 'Identité',
    'Most Recent Comment' => 'Commentaire le plus récent',
    'Only show trusted commenters' => 'Afficher uniquement les commentateurs fiable',
    'Only show banned commenters' => 'Afficher uniquement les commentateurs bannis',
    'Only show neutral commenters' => 'Afficher uniquement les commentateurs neutres',
    'View this commenter\'s profile' => 'Afficher le profil de ce commentateur',

    ## ./tmpl/cms/search_replace.tmpl
    'You must select one or more item to replace.' => 'Vous devez sélectionner un ou plusieurs objets à remplacer.',
    'Search Again' => 'Chercher encore',
    'Search:' => 'Chercher:',
    'Replace:' => 'Remplacer:',
    'Replace Checked' => 'Remplacer les objets selectionnés',
    'Case Sensitive' => 'Respecter la casse',
    'Regex Match' => 'Expression Régulière',
    'Limited Fields' => 'Champs limités',
    'Date Range' => 'Longueur de la Date',
    'Is Junk?' => 'Indésirable?',
    'Search Fields:' => 'Rechercher les champs:',
    'Comment Text' => 'Texte du commentaire',
    'E-mail Address' => 'Adresse email',
    'Email Address' => 'Adresse e-mail',
    'Source URL' => 'URL Source',
    'Blog Name' => 'Nom du Blog',
    'Text' => 'Texte',
    'Output Filename' => 'Nom du fichier de sortie',
    'Linked Filename' => 'Lien du fichier lié',
    'Date Range:' => 'Longueur de la date:',
    'From:' => 'De:',
    'To:' => 'A:',
    'Replaced [_1] records successfully.' => '[_1] enregistrements remplacés avec succès.',
    'No entries were found that match the given criteria.' => 'Aucune note ne correspond à votre recherche.',
    'No comments were found that match the given criteria.' => 'Aucun commentaire ne correspond à votre recherche.',
    'No TrackBacks were found that match the given criteria.' => 'Aucun TrackBack ne correspond à votre recherche.',
    'No commenters were found that match the given criteria.' => 'Aucun commentateur ne correspond à votre recherche.',
    'No templates were found that match the given criteria.' => 'Aucun habillage ne correspond à votre recherche.',
    'No log messages were found that match the given criteria.' => 'Aucun message de log ne correspond à votre recherche.',
    'No Author were found that match the given criteria.' => 'Aucun auteur n\'a été trouvé avec les critères donnés.', # Translate
    'Showing first [_1] results.' => 'Afficher d\'abord [_1] résultats.',
    'Show all matches' => 'Afficher tous les résultats',
    '[_1] result(s) found.' => '[_1] resultat(s) trouvé(s).',

    ## ./tmpl/cms/rebuild-stub.tmpl
    'To see the changes reflected on your public site, you should rebuild your site now.' => 'Vous pouvez actualiser votre site de façon à voir les modifications reflétées sur votre site publié',
    'Rebuild my site' => 'Actualiser le site',

    ## ./tmpl/cms/edit_blog.tmpl
    'You must set your Local Site Path.' => 'Vous devez configurer le chemin local de votre site.',
    'You must set your Site URL.' => 'Vous devez configurer l\'URL de votre site.',
    'You did not select a timezone.' => 'Vous n\'avez pas sélectionné de fuseau horaire.',
    'New Weblog Settings' => 'Nouveaux paramètres du weblog',
    'From this screen you can specify the basic information needed to create a weblog.  Once you click the save button, your weblog will be created and you can continue to customize its settings and templates, or just simply start posting.' => 'A partir de cet écran vous pouvez spécifier les informations de base nécessaires pour créer un weblog. En cliquant sur le bouton Sauvegarder, votre weblog sera créé et vous pourrez poursuivre la personnalisation de ses paramètres et habillages, ou simplement commencer à publier.',
    'Your weblog configuration has been saved.' => 'La configuration de votre weblog a été enregistrée.',
    'Weblog Name:' => 'Nom du weblog:',
    'Name your weblog. The weblog name can be changed at any time.' => 'Indiquez le nom de votre weblog. Ce nom peut être modifié par la suite, si vous le souhaitez.',
    'Site URL:' => 'URL du site:',
    'Enter the URL of your public website. Do not include a filename (i.e. exclude index.html).' => 'Indiquez l\'URL de votre site web publiî N\'incluez pas de nom de fichier (excluez index.html).',
    'Example:' => 'Exemple:',
    'Site root:' => 'Site racine:',
    'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'Indiquez le chemin d\'accès à votre fichier d\'index principal. Un chemin absolu (qui débute par \'/\' est préférable, mais il est également possible d\'utiliser un chemin relatif au répertoire de Movable Type.',
    'Timezone:' => 'Fuseau horaire:',
    'Time zone not selected' => 'Vous n\'avez pas sélectionné de fuseau horaire',
    'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (Nouvelle-Zélande)',
    'UTC+12 (International Date Line East)' => 'UTC+12 (ligne internationale de changement de date)',
    'UTC+11' => 'UTC+11', # Translate
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
    'UTC-7 (Mountain Time)' => 'UTC-7 (Etats-Unis, heure des montagnes)',
    'UTC-8 (Pacific Time)' => 'UTC-8 (Etats-Unis, heure du Pacifique)',
    'UTC-9 (Alaskan Time)' => 'UTC-9 (Alaska)',
    'UTC-10 (Aleutians-Hawaii Time)' => 'UTC-10 (HawaC/)',
    'UTC-11 (Nome Time)' => 'UTC-11 (Nome)',
    'Select your timezone from the pulldown menu.' => 'Veuillez sélectionner votre fuseau horaire dans la liste.',

    ## ./tmpl/cms/rebuild_confirm.tmpl
    'Select the type of rebuild you would like to perform. (Click the Cancel button if you do not want to rebuild any files.)' => 'Sélectionnez le type d\'actualisation que vous souhaitez exécuter (cliquez sur Annuler si vous souhaitez annuler l\'actualisation des fichiers).',
    'Rebuild All Files' => 'Actualiser tous les fichiers',
    'Index Template: [_1]' => 'Modèle d\'index: [_1]',
    'Rebuild Indexes Only' => 'Actualiser les index uniquement',
    'Rebuild [_1] Archives Only' => 'Actualiser les archives [_1] uniquement',
    'Rebuild (r)' => 'Reconstruire (r)',

    ## ./tmpl/cms/log_actions.tmpl
    'Reset Activity Log' => 'Réinitialiser le journal des activités',

    ## ./tmpl/cms/ping_table.tmpl
    'From' => 'De',
    'Target' => 'Cible',
    'Only show published TrackBacks' => 'Afficher uniquement les TrackBacks publiés',
    'Only show pending TrackBacks' => 'Afficher uniquement les TrackBacks en attente',
    'Edit this TrackBack' => 'Editer ce TrackBack',
    'Edit TrackBack' => 'Editer les  TrackBacks',
    'Go to the source entry of this TrackBack' => 'Aller à la note à l\'orgine de ce TrackBack',
    'View the [_1] for this TrackBack' => 'Voir [_1] pour ce TrackBack',

    ## ./tmpl/cms/edit_ping.tmpl
    'The TrackBack has been approved.' => 'Le TrackBack a été approuvé.',
    'List &amp; Edit TrackBacks' => 'Lister &amp; Editer les TrackBacks',
    'Junked TrackBack' => 'TrackBacks indésirables',
    'View all TrackBacks with this status' => 'Voir tous les Trackbacks avec ce statut',
    'Source Site:' => 'Site Source:',
    'Search for other TrackBacks from this site' => 'Rechercher d\'autres Trackbacks de ce site',
    'Source Title:' => 'Titre Source:',
    'Search for other TrackBacks with this title' => 'Rechercher d\'autres Trackbacks avec ce titre',
    'Search for other TrackBacks with this status' => 'Rechercher d\'autres Trackbacks avec ce statut',
    'Target Entry:' => 'Note cible:',
    'View all TrackBacks on this entry' => 'Voir tous les TrackBacks pour cette note',
    'Target Category:' => 'Catégorie cible:',
    'Category no longer exists' => 'La catégorie n\'existe plus',
    'View all TrackBacks on this category' => 'Afficher tous les TrackBacks des cette catégorie',
    'View all TrackBacks posted on this day' => 'Afficher tous les TrackBacks postés ce jour',
    'View all TrackBacks from this IP address' => 'Afficher tous les TrackBacks avec cette adresse IP',
    'Save this TrackBack (s)' => 'Sauvegarder ce Trackback (s)',
    'Delete this TrackBack (d)' => 'Effecer ce Trackback (d)',

    ## ./tmpl/cms/edit_entry.tmpl
    'Edit Entry' => 'Modifier une note',
    'Your entry has been saved. You can now make any changes to the entry itself, edit the authored-on date, edit comments, or send a notification.' => 'Votre note a été enregistrée. Vous pouvez maintenant modifier le contenu de la note, changer la date de création, modifier les commentaires ou envoyer une notification.',
    'One or more errors occurred when sending update pings or TrackBacks.' => 'Erreur lors de l\'envoi des pings ou des TrackBacks.',
    'Your customization preferences have been saved, and are visible in the form below.' => 'Vos préférences ont été enregistrées et sont affichées dans le formulaire ci-dessous.',
    'Your changes to the comment have been saved.' => 'Les modifications apportées aux commentaires ont été enregistrées.',
    'Your notification has been sent.' => 'Votre notification a été envoyé.',
    'You have successfully deleted the checked comment(s).' => 'Les commentaires sélectionnés ont été supprimés.',
    'You have successfully deleted the checked TrackBack(s).' => 'Le(s) TrackBack(s) sélectionné(s) ont été correctement supprimé(s).',
    'List &amp; Edit Entries' => 'Lister &amp; Editer les  Notes',
    'Comments ([_1])' => 'Commentaires ([_1])',
    'TrackBacks ([_1])' => 'TrackBacks ([_1])', # Translate
    'Notification' => 'Notification', # Translate
    'Scheduled' => 'Programmé',
    'Bigger' => 'Plus grand', # Translate
    'Smaller' => 'Plus petit', # Translate
    'Authored On' => 'Créé le',
    'Accept TrackBacks' => 'Accepter TrackBacks',
    'View Previously Sent TrackBacks' => 'Afficher les TrackBacks envoyés précédemment',
    'Customize the display of this page.' => 'Personnaliser l\'affichage de cette page.',
    'Manage Comments' => 'Gérer les commentaires',
    'Click on the author\'s name to edit the comment. To delete a comment, check the box to its right and then click the Delete button.' => 'Cliquez sur le nom de l\'auteur pour modifier le commentaire. Vous pouvez supprimer un commentaire en cochant la case associée, puis en cliquant sur le bouton Supprimer les éléments sélectionnés.',
    'No comments exist for this entry.' => 'Pas de commentaire sur cette note.',
    'Manage TrackBacks' => 'Gérer les TrackBacks',
    'Click on the TrackBack title to view the page. To delete a TrackBack, check the box to its right and then click the Delete button.' => 'Cliquez sur le TrackBack pour voir la page. Pour effacer le TrackBack, cochez la case à droite du nom et cliquez que le bouton Supprimer.',
    'No TrackBacks exist for this entry.' => 'Aucun TrackBack n\'est associé à cette note.',
    'Send a Notification' => 'Envoyer un avis',
    'You can send a notification message to your group of readers. Just enter the email message that you would like to insert below the weblog entry\'s link. You have the option of including the excerpt indicated above or the entry in its entirety.' => 'Vous pouvez envoyer un message avisant un groupe de lecteurs de la publication d\'une note. Il vous suffit d\'indiquer le message que vous souhaitez insérer sous le lien de la note du weblog. Vous pouvez également inclure l\'extrait indiqué plus haut ou la note complète.',
    'Include excerpt' => 'Inclure l\'extrait',
    'Include entire entry body' => 'Inclure toute la note',
    'Note: If you chose to send the weblog entry, all added HTML will be included in the email.' => 'Remarque: si vous décidez d\'inclure tout le contenu de la note, les balises HTML qu\'elle contient seront également envoyées.',
    'Additional notification lists:' => 'Liste additionnelle de notifications:', # Translate
    'Send notification to the above lists only' => 'Envoyer les notifications uniquement à la lisste ci-dessus', # Translate
    'Send' => 'Envoyer',

    ## ./tmpl/cms/entry_table.tmpl
    'Author' => 'Auteur',
    'Only show unpublished entries' => 'N\'afficher que les notes non publiées',
    'Only show published entries' => 'Afficher uniquement les notes publiées',
    'Only show future entries' => 'Afficher uniquement les notes futures',
    'Future' => 'Futur',

    ## ./tmpl/cms/pinged_urls.tmpl
    'Here is a list of the previous TrackBacks that were successfully sent:' => 'Voici la liste des TrackBacks envoyés avec succès:',
    'Here is a list of the previous TrackBacks that failed. To retry these, include them in the Outbound TrackBack URLs list for your entry.:' => 'Voici la liste des Trackbacks précédents qui on échoué. Pour essayer à nouveau, il faut les inclure dans la liste des URL de TrackBack sortants de votre note:', # Translate

    ## ./tmpl/cms/view_log.tmpl
    'The Movable Type activity log contains a record of notable actions in the system.' => 'Le journal de l\'activité de Movable Type contient un enregistrement des actions notables dans le système.',
    'All times are displayed in GMT[_1].' => 'Toutes les heures sont affichées en  GMT[_1].', # Translate
    'All times are displayed in GMT.' => 'Toutes les heures sont affichées GMT.',
    'The activity log has been reset.' => 'Le journal des activités a été réinitialisé.',
    'Show only errors.' => 'N\'afficher que les erreurs.', # Translate
    '(Showing all log records)' => '(Affichage des tous les enregistrements LOG)', # Translate
    'Showing only log records where' => 'Affichage de LOG où', # Translate
    'log records.' => 'Log.', # Translate
    'log records where' => 'log où', # Translate
    'level' => 'niveau', # Translate
    'classification' => 'classification', # Translate
    'information' => 'information', # Translate
    'warnings' => 'Mises en garde', # Translate
    'errors' => 'erreurs', # Translate
    'security' => 'securité', # Translate
    'debug messages' => 'debug messages', # Translate
    'info+warn' => 'info+warn', # Translate
    'info+warn+err' => 'info+warn+err', # Translate
    'info+warn+err+security' => 'info+warn+err+security', # Translate
    'Generate Feed' => 'Génerer Flux', # Translate
    'Generate a feed of this data.' => 'Generer un flux avec ces données.', # Translate
    'No log records could be found.' => 'Aucun enregistrement lof n\'a été trouvé.', # Translate

    ## ./tmpl/cms/spam_confirm.tmpl
    'These domain names were found in the selected comments. Check the box at right to block comments and trackbacks containing that URL in the future.' => 'Ces noms de domaines ont été trouvés dans les commentaires. Cocher la boîte à droite pour bloquer ces url dans les commentaires et les trackbacks qui les contiendront à l\'avenir.',
    'Block' => 'Bloquer',

    ## ./tmpl/cms/edit_categories.tmpl
    'Your category changes and additions have been made.' => 'Les modifications apportées aux catégories ont été enregistrées.',
    'You have successfully deleted the selected categories.' => 'Les catégories sélectionnées ont été supprimées.',
    'Create new top level category' => 'Créer une nouvelle catégorie principale',
    'Actions' => 'Actions', # Translate
    'Create Category' => 'Créer une catégorie',
    'Top Level' => 'Niveau racine',
    'Collapse' => 'Réduire',
    'Expand' => 'Développer',
    'Create Subcategory' => 'Créer une sous-catégorie',
    'Move Category' => 'Déplacer la catégorie',
    'Move' => 'Déplacer',
    '[quant,_1,TrackBack]' => '[quant,_1,TrackBack]', # Translate
    'categories' => 'categories', # Translate
    'Delete selected categories (d)' => 'Effacer les catégories sélectionnées(d)',

    ## ./tmpl/cms/delete_confirm.tmpl
    'Are you sure you want to permanently delete the [quant,_1,author] from the system?' => 'Souhaitez-vous vraiment supprimer [quant,_1,auteur] de façon permanente du système?',
    'Are you sure you want to delete the [quant,_1,comment]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,commentaire]?',
    'Are you sure you want to delete the [quant,_1,TrackBack]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,TrackBack]?',
    'Are you sure you want to delete the [quant,_1,entry,entries]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,note,notes]?',
    'Are you sure you want to delete the [quant,_1,template]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,modèle]?',
    'Are you sure you want to delete the [quant,_1,category,categories]? When you delete a category, all entries assigned to that category will be unassigned from that category.' => 'Souhaitez-vous vraiment supprimer [quant,_1,catégorie,catégories]? L\'association entre une note et une catégorie est perdue lorsque vous supprimez une catégorie.',
    'Are you sure you want to delete the [quant,_1,template] from the particular archive type(s)?' => 'Souhaitez-vous vraiment supprimer [quant,_1,modèle] de ce(s) type(s) d\'archive?',
    'Are you sure you want to delete the [quant,_1,IP address,IP addresses] from your Banned IP List?' => 'Souhaitez-vous vraiment supprimer [quant,_1,adresse IP,adresses IP] de la liste des adresses IP bannies?',
    'Are you sure you want to delete the [quant,_1,notification address,notification addresses]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,adresse pour avis,adresses pour avis]?',
    'Are you sure you want to delete the [quant,_1,blocked item,blocked items]?' => 'Souhaitez-vous vraiment supprimer [quant,_1,élément bloqué,éléments bloqués]?',
    'Are you sure you want to delete the [quant,_1,weblog]? When you delete a weblog, all of the entries, comments, templates, notifications, and author permissions are deleted along with the weblog itself. Make sure that this is what you want, because this action is permanent.' => 'Souhaitez-vous vraiment supprimer [quant,_1,weblog]? Lorsque vous supprimez un weblog, les notes, les commentaires, les modèles, les avis, et les permissions affectées aux auteurs sont également supprimé(e)s. Notez également que le résultat de cette action est définitif.',

    ## ./tmpl/cms/pinging.tmpl
    'Pinging sites...' => 'Envoi de ping(s)...',

    ## ./tmpl/cms/edit_permissions.tmpl
    'Author Permissions' => 'Autorisations des Auteurs',
    'Your changes to [_1]\'s permissions have been saved.' => 'Vos modifications des autorisations accordés à  [_1] a été enregistré.',
    '[_1] has been successfully added to [_2].' => '[_1] a été ajouté(e) avec succès à [_2].',
    'User can create weblogs' => 'L\'utilisateur peut créer un weblog',
    'User can view activity log' => 'L\'utilisateur peut afficher le journal des activités',
    'Check All' => 'Sélectionner tout',
    'Uncheck All' => 'Désélectionner tout',
    'Weblog:' => 'Weblog:', # Translate
    'Unheck All' => 'Tout décocher',
    'Add user to an additional weblog:' => 'Ajouter l\'utilisateur à un weblog supplémentaire:',
    'Add' => 'Ajouter',
    'Save permissions for this author (s)' => 'Enregistrer les autorisations accordées à cet auteur',

    ## ./tmpl/cms/notification_table.tmpl
    'Date Added' => 'Ajouté(e) le',

    ## ./tmpl/cms/list_notification.tmpl
    'Below is the list of people who wish to be notified when you post to your site. To delete an address, check the Delete box and press the Delete button.' => 'Les personnes suivantes souhaitent être averties de la publication d\'une nouvelle note sur votre site. Vous pouvez supprimer une adresse en cochant la case Supprimer, puis en cliquant sur le bouton Supprimer.',
    'You have [quant,_1,user,users,no users] in your notification list.' => 'Votre liste de notifications contient [quant,_1,utilisateur,utilisateurs,0 utilisateur].',
    'You have added [_1] to your notification list.' => 'Vous avez ajouté [_1] à votre liste de notifications.',
    'You have successfully deleted the selected notifications from your notification list.' => 'Les avis sélectionnés ont été supprimés de la liste de notifications.',
    'Create New Notification' => 'Créer une nouvelle notification',
    'URL (Optional):' => 'URL (facultatif):',
    'Add Recipient' => 'Ajouter',
    'No notifications could be found.' => 'Aucune notification n\'a été trouvée.',

    ## ./tmpl/cms/cfg_prefs.tmpl
    'General Settings' => 'Paramètres généraux',
    'This screen allows you to control general weblog settings, default weblog display settings, and third-party service settings.' => 'Cet écran vous permet de contrôler les paramètres généraux du weblog, les paramètres par défaut d\'affichage et les services de tiers.',
    'Weblog Settings' => 'Paramètres du weblog',
    'Description:' => 'Description:', # Translate
    'Enter a description for your weblog.' => 'Entrer une description pour votre weblog.',
    'Default Weblog Display Settings' => 'Paramètres par défaut d\'affichage du weblog',
    'Entries to Display:' => 'Notes à afficher:',
    'Days' => 'Jours',
    'Select the number of days\' entries or the exact number of entries you would like displayed on your weblog.' => 'Sélectionnez le nombre exact de jours (notes des X derniers jours ) ou  le nombre de notes que vous souhaitez voir affichées sur votre weblogs.',
    'Entry Order:' => 'Ordre des notes:',
    'Select whether you want your posts displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Sélectionnez l\'ordre d\'affichage des notes, croissant (les plus anciennes en premier) ou décroissant (les plus récentes en premier).',
    'Comment Order:' => 'Ordre des commentaires:',
    'Select whether you want visitor comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Sélectionnez l\'ordre d\'affichage des commentaires publiés par les visiteurs: croissant (les plus anciens en premier) ou décroissant (les plus récents en premier).',
    'Excerpt Length:' => 'Longueur des extraits:',
    'Enter the number of words that should appear in an auto-generated excerpt.' => 'Entrez le nombre de mot à afficher pour les extraits de notes.',
    'Date Language:' => 'Langue de la date:',
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
    'Limit HTML Tags:' => 'Limiter les tags HTML:',
    'Use defaults' => 'Utiliser les valeurs par défaut',
    '([_1])' => '([_1])', # Translate
    'Use my settings' => 'Utiliser mes paramétrages',
    'Specifies the list of HTML tags allowed by default when cleaning an HTML string (a comment, for example).' => 'Spécifie la liste des balises HTML autorisées par défaut lors du nettoyage d\'une chaîne HTML (un commentaire, par exemple).',
    'Third-Party Services' => 'Services tiers',
    'Creative Commons License:' => 'Licence B+ Creative Commons B:',
    'Your weblog is currently licensed under:' => 'Votre weblog est actuellement régi par:',
    'Change your license' => 'Changer la licence',
    'Remove this license' => 'Supprimer cette licence',
    'Your weblog does not have an explicit Creative Commons license.' => 'Votre weblog ne fait pas l\'objet d\'une licence B+ Creative Commons B explicite.',
    'Create a license now' => 'Créer une licence',
    'Select a Creative Commons license for the posts on your blog (optional).' => 'Choisissez une licence B+ Creative Commons B pour les notes de votre weblog (facultatif).',
    'Be sure that you understand these licenses before applying them to your own work.' => 'Nous vous recommandons de vous informer de la portée des clauses de cette licence avant de l\'appliquer à vos propres travaux.',
    'Read more.' => 'En savoir plus.',
    'Google API Key:' => 'Clé d\'API Google:',
    'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.' => 'Vous devrez vous procurer une clé d\'API Google si vous souhaitez utiliser les fonctions d\'API proposées par Google. Le cas échéant, collez cette clé dans cet espace.',

    ## ./tmpl/cms/edit_category.tmpl
    'Edit Category' => 'Editer les catégories', # Translate
    'Use this page to edit the attributes of the category [_1]. You can set a description for your category to be used in your public pages, as well as configuring the TrackBack options for this category.' => 'Cette page permet de modifier les attributs de la catégorie [_1]. Vous pouvez indiquer une description, qui sera affichée sur votre site public, et configurer les options TrackBack pour cette catégorie.',
    'Your category changes have been made.' => 'Les modifications apportées ont été enregistrées.',
    'Details' => 'Details', # Translate
    'Label' => 'Etiquette', # Translate
    'Unlock this category\'s output filename for editing' => 'Dévérouiller le fichier de cette catégorie pour l\'éditer', # Translate
    'Warning: Changing this category\'s basename may break inbound links.' => 'Attention: changer le nom de la catégorie risque de casser des liens entrants.', # Translate
    'Save this category (s)' => 'Sauvegarder cette catégorie', # Translate
    'Inbound TrackBacks' => 'TrackBacks entrants',
    'If enabled, TrackBacks will be accepted for this category from any source.' => 'Si activé, les TrackBacks seront acceptés pour cette catégorie quelle que soit la source.', # Translate
    'TrackBack URL for this category' => 'URL TrackBack pour cette catégorie',
    'This is the URL that others will use to send TrackBacks to your weblog. If you wish for anyone to send TrackBacks to your weblog when they have a post specific to this category, post this URL publicly. If you choose to only allow a select group of individuals to TrackBack, send this URL to them privately. To include a list of incoming TrackBacks in your Main Index Template, check the documentation for template tags related to TrackBacks.' => 'This is the URL that others will use to send TrackBacks to your weblog. If you wish for anyone to send TrackBacks to your weblog when they have a post specific to this category, post this URL publicly. If you choose to only allow a select group of individuals to TrackBack, send this URL to them privately. To include a list of incoming TrackBacks in your Main Index Template, check the documentation for template tags related to TrackBacks.', # Translate
    'Passphrase Protection' => 'Passphrase Protection', # Translate
    'Optional.' => 'Facultatif.', # Translate
    'Outbound TrackBacks' => 'TrackBacks sortants',
    'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you post an entry in this category. (Separate URLs with a carriage return.)' => 'Saisissez l\'URL(s) du ou des site(s) web à qui vous souhaitez envoyer un TrackBack chaque fois que vous publiez un note dans cette catégorie. (Faire un passage à la ligne entre chaque URL.)',

    ## ./tmpl/cms/pager.tmpl
    'Show:' => 'Afficher:',
    '[quant,_1,row]' => '[quant,_1,ligne]',
    'all rows' => 'toutes les lignes',
    'Another amount...' => 'Autre montant...',
    'Actions:' => 'Actions:', # Translate
    'Below' => 'Sous',
    'Above' => 'Dessus',
    'Both' => 'Les deux',
    'Date Display:' => 'Affichage de la date:',
    'Relative' => 'Relative', # Translate
    'Full' => 'Entière',
    'Newer' => 'Le plus récent',
    'Showing:' => 'Affiche:',
    'of' => 'de',
    'Older' => 'Le plus ancien',

    ## ./tmpl/cms/template_table.tmpl

    ## ./tmpl/cms/cc_return.tmpl

    ## ./tmpl/cms/preview_entry.tmpl
    'Re-Edit this entry' => 'Modifier cette note',
    'Save this entry' => 'Enregistrer cette note',

    ## ./tmpl/cms/handshake_return.tmpl

    ## ./tmpl/cms/category_add.tmpl
    'Add A Category' => 'Ajouter une catégorie',
    'To create a new category, enter a title in the field below, select a parent category, and click the Add button.' => 'Pour créer une catégorie, indiquez un titre dans le champ ci-dessous, sélectionnez une catégorie parente, puis cliquez sur Ajouter.',
    'Category Title:' => 'Titre de la catégorie:',
    'Parent Category:' => 'Catégorie parente:',

    ## ./tmpl/cms/list_banlist.tmpl
    'IP Banning Settings' => 'Paramétrages des IP bannies',
    'This screen allows you to ban comments and TrackBacks from specific IP addresses.' => 'Cet écran vous permet de bannir commentaires et TrackBacks provenant d\'une adresse IP donnée.',
    'You have banned [quant,_1,address,addresses].' => 'Vous avez banni [quant,_1,address,addresses].',
    'You have added [_1] to your list of banned IP addresses.' => 'L\'adresse [_1] a été ajoutée à la liste des adresses IP bannies.',
    'You have successfully deleted the selected IP addresses from the list.' => 'L\'adresse IP sélectionnée a été supprimée de la liste.',
    'Ban New IP Address' => 'Bannir une nouvelle adresse IP',
    'IP Address:' => 'Adresse IP:',
    'Ban IP Address' => 'Bannir l\'adresse IP',
    'Date Banned' => 'Bannie le:',
    'IP address' => 'IP addresse', # Translate
    'IP addresses' => 'adresses IP',

    ## ./tmpl/cms/list_ping.tmpl
    'The selected TrackBack(s) has been published.' => 'Le(s) TrackBack(s) sélectionné(s) ont été publié(s).',
    'All junked TrackBacks have been removed.' => 'Tous les Trackbcks indésirables on été enlevés .', # Translate
    'The selected TrackBack(s) has been unpublished.' => 'Le(s) TrackBack(s) sélectionné(s) ont été enlevé(s) de la publication.',
    'The selected TrackBack(s) has been junked.' => 'Le(s) TrackBack(s) sélectionné(s) sont marqués indésirable(s).',
    'The selected TrackBack(s) has been unjunked.' => 'Le(s) TrackBack(s) sélectionné(s) ne sont plus marqué(s) indésirable(s).',
    'The selected TrackBack(s) has been deleted from the database.' => 'Le(s) TrackBack(s) sélectionné(s) ont été supprimé(s) de la base de données.',
    'No TrackBacks appeared to be junk.' => 'Aucun TrackBack n\'est marqué indésirable.',
    'Junk TrackBacks' => 'TrackBacks indésirables',
    'Show unpublished TrackBacks.' => 'Afficher les TrackBacks non publiés.',
    '(Showing all TrackBacks)' => '(Affichage de tous les TrackBacks)', # Translate
    'Showing only TrackBacks where [_1] is [_2].' => 'Affichage uniquement des TrackBacks où [_1] est [_2].', # Translate
    'TrackBacks.' => 'les TrackBacks.',
    'TrackBacks where' => 'les TrackBacks dont',
    'No TrackBacks could be found.' => 'Aucun TrackBack n\'a été trouvé.',
    'No junk TrackBacks could be found.' => 'Aucun TrackBack indésirable n\'a été trouvé.',

    ## ./tmpl/cms/edit_profile.tmpl
    'Your password has been changed, and the new password has been sent to your email address ([_1]).' => 'Votre mot de passe a été modifié et a été envoyé à votre adresse e-mail([_1]).',
    'Password Recovery' => 'Récupération de mot de passe',

    ## ./tmpl/cms/list_plugin.tmpl
    'Are you sure you want to reset the settings for this plugin?' => 'Etes-vous sur de vouloir réinitialiser les paramètres pour ce plugin?',
    'Disable plugin system?' => 'Désactiver le système de plugin?',
    'Disable this plugin?' => 'Désactiver ce plugin?',
    'Enable plugin system?' => 'Activer le système de plugin?',
    'Enable this plugin?' => 'Activer ce plugin?',
    'Plugin Settings' => 'Paramètres des plugins',
    'This screen allows you to control the weblog-level settings of any configurable plugins you\'ve installed.' => 'Cet écran vous permet de contrôler le niveau du weblog en matière de plugin installés.',
    'Your plugin settings have been saved.' => 'Les paramètres de votre plugin ont été enregistrés.',
    'Your plugin settings have been reset.' => 'Les paramètres de votre plugin on été réinitialisés.',
    'Your plugins have been reconfigured.' => 'Votre plugin a été reconfiguré.',
    'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => 'Vos plugins ont été reconfigurés. Si vous êtes sous mod_perl vous devez redémarrer votre serveur web pour la prise en compte de ces changements.',
    'Registered Plugins' => 'Plugins enregistrés',
    'Disable Plugins' => 'Désactiver les plugins',
    'Enable Plugins' => 'Activer les plugins',
    'Error' => 'Erreur',
    'Failed to Load' => 'Erreur de chargement',
    'Disable' => 'Désactiver',
    'Enabled' => 'Activé',
    'Enable' => 'Activer',
    'Documentation for [_1]' => 'Documentation pour [_1]',
    'Documentation' => 'Documentation', # Translate
    'Author of [_1]' => 'Auteur de [_1]',
    'More about [_1]' => 'En savoir plus sur [_1]',
    'Support' => 'Support', # Translate
    'Plugin Home' => 'Accueil Plugin',
    'Resources' => 'Ressources',
    'Show Resources' => 'Afficher les ressources',
    'More Settings' => 'Paramétrages additionnels',
    'Show Settings' => 'Afficher les paramétrages',
    'Settings for [_1]' => 'Paramètres pour [_1]',
    'Version' => 'Version', # Translate
    'Resources Provided by [_1]' => 'Ressources fournies par [_1]',
    'Tag Attributes' => 'Attributs de tag ',
    'Text Filters' => 'Filtres de texte',
    'Junk Filters' => 'Filtres d\'indésirables',
    '[_1] Settings' => '[_1] Paramètres',
    'Reset to Defaults' => 'Rénitialiser pour remettre les paramètres par défaut',
    'Plugin error:' => 'Erreur plugin:',
    'No plugins with weblog-level configuration settings are installed.' => 'Aucun plugin avec une configuration au niveau du weblog n\'est installé.',

    ## ./tmpl/cms/error.tmpl
    'An error occurred:' => 'Une erreur s\'est produite:',
    'Go Back' => 'Retour',

    ## ./tmpl/cms/recover.tmpl
    'Enter your Movable Type username:' => 'Indiquez votre nom d\'utilisateur Movable Type:',
    'Enter your password hint:' => 'Entrer votre pense-bête Mot de Passe:',
    'Recover' => 'Récupérer',

    ## ./tmpl/cms/cfg_entries_edit_page.tmpl
    'Entry Page Default Settings' => 'Paramétrages par défaut de la page d\'entrée', # Translate

    ## ./tmpl/cms/list_comment.tmpl
    'The selected comment(s) has been published.' => 'Le(s) commentaire(s) sélectionné(s) ont été publié(s) correctement.',
    'All junked comments have been removed.' => 'Tous les commentaires indésirables on été supprimés.', # Translate
    'The selected comment(s) has been unpublished.' => 'Le (s) commentaire(s) sélectionné(s) n\'ont pas été publié(s).',
    'The selected comment(s) has been junked.' => 'Le(s) commentaire(s) sélectionné(s) sont marqué(s) indésirable(s).',
    'The selected comment(s) has been unjunked.' => 'Le(s) commentaire(s) sélectionné(s) ne sont plus marqué(s) indésirable(s).',
    'The selected comment(s) has been deleted from the database.' => 'Les commentaires sélectionnés ont été supprimés de la base de données.',
    'One or more comments you selected were submitted by an unauthenticated visitor. These commenters cannot be assigned trust (or marked as untrusted) without proper authentication.' => 'Un ou plusieurs des commentaires sélectionnés ont été crées par un commentateur on authentifié. Ces commentateurs ne peuvent pas être dans une catégorie (fiable ou non) sans être au préalable identifiés', # Translate
    'No comments appeared to be junk.' => 'Aucun commentaire marqué indésirable.',
    'Go to Commenter Listing' => 'Aller à la liste des commentateurs',
    '(Showing all comments)' => '(Affichage de tous les commentaires)', # Translate
    'Showing only comments where [_1] is [_2].' => 'Affichage de tous les commentaires où [_1] est [_2].', # Translate
    'comments.' => 'les commentaires.',
    'comments where' => 'commentaires dont',
    'No comments could be found.' => 'Aucun commentaire n\'a été trouvé.',
    'No junk comments could be found.' => 'Aucun commentaire indésirable n\'a été trouvé.',

    ## ./tmpl/cms/footer-popup.tmpl

    ## ./tmpl/cms/system_info.tmpl
    'System Status and Information' => 'Statut du système et information',
    'This page will soon contain information about the server environment availability of required perl modules, installed plugins and other information useful for expediting debugging in technical support requests.' => 'Cette page va regrouper les informations au sujet de la disponibilité de l\'environnement serveur des modules perl, des plugins installés et d\'autres informations utiles pour le debug dans les demandes de support technique.', # Translate

    ## ./tmpl/cms/import_end.tmpl
    'All data imported successfully! Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Toutes les données ont été importées correctement! Assurez-vous de supprimer les fichiers importés du dossier \'importation\' ainsi lorsque vous recommencerez un processus d\'importation ces fichiers ne seront pas à nouveau importés.',
    'An error occurred during the import process: [_1]. Please check your import file.' => 'Une erreur s\'est produite pendant le processus: [_1]. Merci de vérifier vos fichiers import.',

    ## ./tmpl/cms/cfg_feedback.tmpl
    'Feedback Settings' => 'Paramétrages des Feedbacks',
    'This screen allows you to control the feedback settings for this weblog, including comments and TrackBacks.' => 'Cet écran vous permet de contrôler le paramétrage des feedbacks incluant commentaires et TrackBacks.',
    'Rebuild indexes' => 'Reconstruire les index',
    'Note: Commenting is currently disabled at the system level.' => 'Note: Les commentaires sont actuellement désactivés au niveau système.',
    'Comment authentication is not available because one of the needed modules, MIME::Base64 or LWP::UserAgent is not installed. Talk to your host about getting this module installed.' => 'L\'authetification de commentaire n\'est pas active car le module MIME::Base64 or LWP::UserAgent est absent. Contactez votre hébergeur pour l\'installation de ce module.',
    'Accept comments from' => 'Accepter les commentaires de',
    'Anyone' => 'Tous',
    'Authenticated commenters only' => 'Commentateurs authentifiés uniquement',
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
    'Note: You have selected to accept comments from authenticated commenters only but authentication is not enabled. In order to receive authenticated comments, you must enable authentication.' => 'Attention: vous avez sélectionné d\'accepter uniquement les commentaires de commentateurs identifiés MAIS l\'authentification n\'est pas activée. Vous devez l\'activer pour recevoir les commentaire à autoriser.',
    'Authentication is not enabled.' => 'Authentification non activée.',
    'Setup Authentication' => 'Mise en place de l\'Authentification',
    'Or, manually enter token:' => 'Ou, entrez manuellement le jeton:',
    'Authentication Token Inserted' => 'Jeton d\'authentification inseré',
    'Please click the Save Changes button below to enable authentication.' => 'Cliquez sur le bouton Enregistrer ci-dessous pour activer l\'authentification.',
    'Establish a link between your weblog and an authentication service. You may use TypeKey (a free service, available by default) or another compatible service.' => 'Etablir un lien entre votre weblog et un système d\'authentification. Vous pouvez utiliser TypeKey (service gratuit disponible par défaut) ou un autre service compatible.',
    'Require E-mail Address' => 'Adresse email requise',
    'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Si activé, le visiteur doit donner une adresse email valide pour commenter.',
    'Immediately publish comments from' => 'Publier immédiatement les commentaires de(s)',
    'Trusted commenters only' => 'Commentateurs fiables uniquement',
    'Any authenticated commenters' => 'Tout commentateur authentifié',
    'Specify what should happen to non-junk comments after submission.' => 'Spécifier ce qui doit ce passer pour les commentaires désirés après leur enregistrement.',
    'Unpublished comments are held for moderation.' => 'Les commentaires non publiés sont retenus pour modération.',
    'E-mail Notification' => 'Notification par email',
    'On' => 'Activé',
    'Only when attention is required' => 'Uniquement quand l\'attention est requise',
    'Specify when Movable Type should notify you of new comments if at all.' => 'Spécifier quand Movable Type doit vous notifier les nouveaux commentaires.',
    'Allow HTML' => 'Autoriser le HTML',
    'If enabled, users will be able to enter a limited set of HTML in their comments. If not, all HTML will be stripped out.' => 'Si activé, le commentateur pourra entrer du HTML de façon limitée dans son commentaire. Sinon, le html ne sera pas pris en compte.',
    'Auto-Link URLs' => 'Liaison automatique des URL',
    'If enabled, all non-linked URLs will be transformed into links to that URL.' => 'Si activé, toutes les urls non liés seront transformées en url actives.',
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

    ## ./tmpl/cms/reload_opener.tmpl

    ## ./tmpl/cms/rebuilding.tmpl
    'Rebuilding [_1]' => 'Actualisation de [_1]',
    'Rebuilding [_1] pages [_2]' => 'Actualisation des pages [_1] [_2]',
    'Rebuilding [_1] dynamic links' => 'Recontruction [_1] des liens dynamiques',
    'Rebuilding [_1] pages' => 'Actualisation des pages [_1]',

    ## ./tmpl/cms/create_author_bulk_start.tmpl
    'Creating...' => 'En Création...', # Translate
    'Creating authors' => 'Auteurs en création', # Translate
    'Creating new authors by reading the uploaded CSV file' => 'Création de nouveaux auteurs à la lecture des fichiers CSV', # Translate

    ## ./tmpl/cms/blog_actions.tmpl
    'weblog' => 'weblog', # Translate
    'weblogs' => 'weblogs', # Translate
    'Delete selected weblogs (d)' => 'Effacer les weblogs sélectionnés (d)',

    ## ./tmpl/cms/overview-left-nav.tmpl
    'List Weblogs' => 'Liste des Weblogs',
    'List Authors' => 'Liste des Auteurs',
    'List Plugins' => 'Liste des Plugins',
    'Aggregate' => 'Multi-Blogs',
    'List Tags' => 'Liste de Tags', # Translate
    'Edit System Settings' => 'Editer les Paramètres Système',
    'Show Activity Log' => 'Afficher les logs d\'activité',

    ## ./tmpl/cms/menu.tmpl
    'Five Most Recent Entries' => 'Les 5 notes les plus récentes',
    'View all Entries' => 'Afficher toutes les notes',
    'Five Most Recent Comments' => 'Cinq commentaires les plus récents',
    'View all Comments' => 'Afficher tous les commentaires',
    'Five Most Recent TrackBacks' => 'Cinq TrackBacks les plus récents',
    'View all TrackBacks' => 'Afficher tous les TrackBacks',
    'Welcome to [_1].' => 'Bienvenue sur [_1].',
    'You can post to and manage your weblog by selecting an option from the menu located to the left of this message.' => 'Vous pouvez publier sur votre weblog ou bien le gérer en sélectionnant une option du menu situé à gauche de ce message.',
    'If you need assistance, try:' => 'Si vous avez besoin d\'aide, vous pouvez consulter:',
    'Movable Type User Manual' => 'Mode d\'emploi de Movable Type',
    'Movable Type Technical Support' => 'Support Technique Movable Type',
    'Movable Type Support Forum' => 'Forum de support de Movable Type',
    'This welcome message is configurable.' => 'Vous pouvez modifier ce message d\'accueil.',
    'Change this message.' => 'Changer ce message.',

    ## ./tmpl/cms/upgrade_runner.tmpl
    'Installation complete.' => 'Installation terminée.',
    'Upgrade complete.' => 'Mise à jour terminée.',
    'Initializing database...' => 'Initialisation de la base de données...',
    'Upgrading database...' => 'Mise à jour de la base de données...',
    'Starting installation...' => 'Début de l\'installation...',
    'Starting upgrade...' => 'Début de la mise à jour...',
    'Error during installation:' => 'Erreur lors de l\'installation:',
    'Error during upgrade:' => 'Erreur lors de la mise à jour:',
    'Installation complete!' => 'Installation terminée!',
    'Upgrade complete!' => 'Mise à jour terminée!',
    'Login to Movable Type' => 'S\'enregistrer dans Movable Type',
    'Return to Movable Type' => 'Retourner à Movable Type',
    'Your database is already current.' => 'Votre base de données est déjà actualisée.',

    ## ./tmpl/cms/login.tmpl
    'Your Movable Type session has ended. If you wish to log in again, you can do so below.' => 'Votre session Movable Type a été fermée. Pour ouvrir une nouvelle session voir ci-dessous.',
    'Your Movable Type session has ended. Please login again to continue this action.' => 'Votre session Movable Type a expiré. Merci de vous enregistrer à nouveau pour poursuivre.',
    'Remember me?' => 'Mémoriser les informations de connexion?',
    'Log In' => 'Connexion',
    'Forgot your password?' => 'Vous avez oublié votre mot de passe?',

    ## ./tmpl/cms/system_list_blog.tmpl
    'Are you sure you want to delete this weblog?' => 'Etes-vous certain de vouloir effacer ce weblog?', # Translate
    'Below you find a list of all weblogs in the system with links to the main weblog page and individual settings pages for each.  You may also create or delete blogs from this screen.' => 'Ci-dessous la liste des weblogs du système avec un lien vers leur page principale et leur page de paramètres individuels. Vous avez la possibilité de créer ou supprimer un weblog à partir de cette page.',
    'You have successfully deleted the blogs from the Movable Type system.' => 'Le blog a été correctement supprimé du système Movable Type.',
    'Create New Weblog' => 'Créer un nouveau Weblog',
    'No weblogs could be found.' => 'Aucun weblog n\'a été trouvé.',

    ## ./tmpl/cms/cfg_archives.tmpl
    'Are you sure you want to delete this template map?' => 'Etes-vous sur de vouloir supprimer cette carte d\'habillage?', # Translate
    'Publishing Settings' => 'Paramètres de publication',
    'This screen allows you to control this weblog\'s publishing paths and preferences, as well as archive mapping settings.' => 'Cet écran vous permet de contrôler les chemins de publication, les préférences et les paramètres d\'archives de ce weblog.',
    'Go to Templates Listing' => 'Aller à la liste des modèles',
    'Go to Template Listing' => 'Aller à la liste des modèles',
    'Error: Movable Type was not able to create a directory for publishing your weblog. If you create this directory yourself, assign sufficient permissions that allow Movable Type to create files within it.' => 'Erreur: Movable Type n\'a pas pu créer le dossier pour publier ce weblog.  Si vous créez ce dossier vous même, assigner suffisamment d\'autorisations à Movable Type pour y créer des fichiers.',
    'Your weblog\'s archive configuration has been saved.' => 'La configuration des archives de votre weblog a été enregistrée.',
    'You may need to update your templates to account for your new archive configuration.' => 'Vous devrez peut-être mettre à jour votre habillage pour pour obtenir votre nouvelle configuration d\'archives.',
    'You have successfully added a new archive-template association.' => 'L\'association modèle/archive a réussi.',
    'You may need to update your \'Master Archive Index\' template to account for your new archive configuration.' => 'Vous aurez peut-être besoin de mettre à jour votre habillage \'Index principal des archives\' pour activer la nouvelle configuration de vos archives.',
    'The selected archive-template associations have been deleted.' => 'Les associations modèle/archive sélectionnées ont été supprimées.',
    'Publishing Paths' => 'Chemins de publication',
    'Enter the URL of your website. Do not include a filename (i.e. exclude index.html).' => 'Entrer l\'url de votre site. Ne pas inclure le nom de fichier (ne pas mettre par exemple: index.html).',
    'Site Root:' => 'Racine site:',
    'Enter the path where your index files will be published. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'Entrer le chemin où votre fichier index sera publié. Un chemin absolu (commençant par \'/\') est recommandé, mais vous pouvez aussi utiliser un chemin relatif vers le repertoire Movable Type.',
    'Advanced Archive Publishing:' => 'Publication Avancée des Archives:',
    'Publish archives to alternate root path' => 'Publier les archives sur un chemin racine alternatif',
    'Select this option only if you need to publish your archives outside of your Site Root.' => 'Sélectionnez cette option si vous avez besoin de publier vos archives en dehors de la racine du Site.',
    'Archive URL:' => 'URL des archives:',
    'Enter the URL of the archives section of your website.' => 'Entrer l\'URL de la section Archives de votre site.',
    'Archive Root:' => 'Racine Archive:',
    'Enter the path where your archive files will be published.' => 'Entrer le chemin de l\'endroit où seront publiées vos archives.',
    'Publishing Preferences' => 'Préférences de Publication',
    'Preferred Archive Type:' => 'Type d\'archive préféré:',
    'No Archives' => 'Pas d\'archive',
    'Individual' => 'Individuel',
    'Daily' => 'Quotidien',
    'Weekly' => 'Hebdomadaire',
    'Monthly' => 'Mensuel',
    'When linking to an archived entry&#8212;for a permalink, for example&#8212;you must link to a particular archive type, even if you have chosen multiple archive types.' => 'Lorsque vous établissez un hyperlien vers une note archivée, comme pour un permalien, vous devez créer le lien vers un type d\'archive spécifique, même si vous avez choisi plusieurs types d\'archive.',
    'File Extension for Archive Files:' => 'Extension de fichier pour les archives:',
    'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'Entrez l\'extension du fichier d\'archive. Elle peut être au choix \'html\', \'shtml\', \'php\', etc. NB: Ne pas indiquer la période (\'.\').',
    'Dynamic Publishing:' => 'Publication Dynamique:',
    'Build all templates statically' => 'Construire chaque modèle de manière statique',
    'Build only Archive Templates dynamically' => 'Construire uniquement les Modèles d\'Archive dynamiquement',
    'Set each template\'s Build Options separately' => 'Mettre en place les Options de Construction des modèles individuellement',
    'Archive Mapping' => 'Table de correspondance des archives',
    'This advanced feature allows you to map any archive template to multiple archive types. For example, you may want to create two different views of your monthly archives: one in which the entries for a particular month are presented as a list, and the other representing the entries in a calendar view of that month.' => 'Cette fonctionnalité avancée vous permet de faire correspondre un modèle d\'archives à plusieurs types d\'archives. Par exemple, vous pouvez decider de créer deux vues différentes pour vos archives mensuelles : une pour les notes d\'un mois donné, présentées en liste, une autre affichant les notes sur un calendrier mensuel.',
    'Create New Archive Mapping' => 'Créer une nouvelle table de correspondance des archives',
    'Archive Type:' => 'Type d\'archive:',
    'INDIVIDUAL_ADV' => 'par note',
    'DAILY_ADV' => 'de façon quotidienne',
    'WEEKLY_ADV' => 'hebdomadaire',
    'MONTHLY_ADV' => 'par mois',
    'CATEGORY_ADV' => 'par catégorie',
    'Template:' => 'Modèle:',
    'Archive Types' => 'Types d\'archive',
    'Template' => 'Modèle',
    'Archive File Path' => 'Chemin vers les Fichiers Archive',
    'Preferred' => 'Préféré',
    'Custom...' => 'Personnalisé...',
    'archive map' => 'Association d\'archive',
    'archive maps' => 'Associations d\'archive',

    ## ./tmpl/cms/itemset_action_widget.tmpl
    'More actions...' => 'Plus d\'actions...',
    'Go' => 'OK',
    'No actions' => 'Aucune action',

    ## ./tmpl/cms/recover_password_result.tmpl
    'Recover Password' => 'Retrouver un Mot de Passe', # Translate

    ## ./tmpl/cms/create_author_bulk_end.tmpl
    'All authors created successfully!' => 'Tous les auteurs ont été crées avec succès!', # Translate
    'An error occurred during the creation process. Please check your CSV file.' => 'Une erreur s\'est prodtuite lors du processus de création.Merci de vérifier votre fichier CSV.', # Translate

    ## ./tmpl/cms/admin_essential_links_en_US.tmpl
    'Essential Links' => 'Liens essentiels',
    'System Information' => 'Informations système',
    'https://secure.sixapart.com/t/account' => 'https://secure.sixapart.com/t/account', # Translate
    'Your Account' => 'Votre compte',
    'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype/', # Translate
    'Movable Type Home' => 'Accueil Movable Type',
    'http://www.sixapart.com/pronet/plugins/' => 'http://www.sixapart.com/pronet/plugins/', # Translate
    'Plugin Directory' => 'Annuaire des plugins',
    'https://secure.sixapart.com/t/help?__mode=kb' => 'https://secure.sixapart.com/t/help?__mode=kb', # Translate
    'Knowledge Base' => 'Base de connaissance',
    'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.com/movabletype/support', # Translate
    'Support and Documentation' => 'Support et Documentation',
    'http://www.sixapart.com/pronet/' => 'http://www.sixapart.com/pronet/', # Translate
    'Professional Network' => 'Réseau Professionnel',

    ## ./tmpl/feeds/feed_entry.tmpl

    ## ./tmpl/feeds/feed_comment.tmpl
    'Edit' => 'Editer', # Translate

    ## ./tmpl/feeds/feed_system.tmpl

    ## ./tmpl/feeds/login.tmpl
    'Movable Type Activity Log' => 'Movable Type Log d\'activité', # Translate
    'Movable Type System Activity' => 'Movable Type activité du système', # Translate
    'This link is invalid. Please resubscribe to your activity feed.' => 'Ce lien n\'est pas valide. Merci de souscrire à nouveau à votre flux d\'activité.', # Translate

    ## ./tmpl/feeds/error.tmpl

    ## ./tmpl/feeds/feed_ping.tmpl

    ## ./tmpl/email/new-ping.tmpl
    'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Un Trackback non approuvé a été envoyé pour votre weblog [_1], pour la note #[_2] ([_3]). Vous devez l\'approuver pour qu\'il apparaisse sur votre blog.',
    'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Un Trackback non approuvé a été envoyé pour votre weblog [_1], pour la catégorie #[_2], ([_3]). Vous devez l\'approuver pour qu\'il apparaisse sur votre blog.',
    'Approve this TrackBack:' => 'Approuver ce TrackBack:',
    'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Un nouveau Trackback a été envoyé sur votre blog [_1], sur la note #[_2] ([_3]).',
    'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'Un nouveau Trackback a été envoyé sur votre blog [_1], sur la catégorie #[_2] ([_3]).',
    'View this TrackBack:' => 'Voir ce TrackBack:',
    'Edit this TrackBack:' => 'Modifier ce TrackBack:',
    'Title:' => 'Titre:',
    'Excerpt:' => 'Extrait:',

    ## ./tmpl/email/recover-password.tmpl

    ## ./tmpl/email/notify-entry.tmpl
    '[_1] Update: [_2]' => '[_1] Mise à jour: [_2]',
    '(This entry is unpublished.)' => '(Cette note n\'est pas publiée.)', # Translate

    ## ./tmpl/email/new-comment.tmpl
    'An unapproved comment has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => 'Un commentaire non approuvé a été envoyé sur votre blog [_1], pour la note #[_2] ([_3]). Vous devez l\'approuver pour qu\'il apparaisse sur votre blog.',
    'Approve this comment:' => 'Approuver ce commentaire:',
    'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Un nouveau commentaire a été publié sur votre weblog [_1], au sujet de la note [_2] ([_3]). ',
    'View this comment:' => 'Afficher ce commentaire:',
    'Edit this comment:' => 'Modifier ce commentaire:',

    ## ./tmpl/email/footer-email.tmpl
    'Powered by Movable Type' => 'Powered by Movable Type', # Translate
    'Version [_1]' => 'Version [_1]', # Translate

    ## ./tmpl/email/verify-subscribe.tmpl
    'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Merci d\'avoir pour votre inscription aux mises à jours [_1]. Cliquez sur le lien ci-dessous pour confirmer cette inscription:', # Translate
    'If the link is not clickable, just copy and paste it into your browser.' => 'Si le lien n\'est pas cliquable, faites simplement un copier-coller dans votre navigateur.',

    ## Other phrases, with English translations.
    'WEEKLY_ADV' => 'hebdomadaire',
    'Unpublish Comment(s)' => 'Annuler publication commentaire(s)',
    '_SYSTEM_TEMPLATE_COMMENT_PENDING' => 'Visible quand un commentateur fait un aperçu de son commentaire',
    '_USAGE_ENTRY_LIST_OVERVIEW' => 'Voici la liste des notes pour tous les weblogs que vous pouvez, filtre, gérer et éditer.', # Translate
    'RSS 1.0 Index' => 'Index RSS 1.0',
    'Manage Categories' => 'Gérer les Catégories',
    '_USAGE_BOOKMARKLET_4' => 'QuickPost vous permet de publier vos notes à partir de n\'importe quel point du web. Vous pouvez, en cours de consultation d\'une page que vous souhaitez mentionner, cliquez sur QuickPost pour ouvrir une fenêtre popup contenant des options Movable Type spéciales. Cette fenêtre vous permet de sélectionner le weblog dans lequel vous souhaitez publier la note, puis de la créer et de la publier.',
    '_USAGE_ARCHIVING_2' => 'Lorsque vous associez plusieurs modèles à un type d\'archive particulier -- ou même lorsque vous n\'en associez qu\'un seul -- vous pouvez personnaliser le chemin des fichiers d\'archive à l\'aide des modèles correspondants.',
    'UTC+11' => 'UTC+11', # Translate
    'View Activity Log For This Weblog' => 'Voir le journal d\'activité pour ce weblog',
    'DAILY_ADV' => 'de façon quotidienne',
    '_USAGE_PERMISSIONS_3' => 'Il existe deux façons d\'accorder ou de révoquer les privilèges d\'accès affectés aux utilisateurs. La première est de sélectionner un utilisateur parmi ceux du menu ci-dessous et de cliquer sur Modifier. La seconde est de consulter la liste de tous les auteurs, puis de sélectionner l\'auteur que vous souhaitez modifier ou supprimer.',
    '_NOTIFY_REQUIRE_CONFIRMATION' => 'Un email a été envoyé à [_1]. Pour valider votre inscription, merci de cliquer sur le lien qui figure dans cet email. Il permettra de vérifier que votre adresse email est valable.', # Translate
    '_USAGE_NOTIFICATIONS' => 'Les personnes suivantes souhaitent être averties de la publication d\'une nouvelle note sur votre site. Vous pouvez ajouter un utilisateur en indiquant son adresse e-mail dans le formulaire suivant. L\'adresse URL est facultative. Pour supprimer un utilisateur, cochez la case Supprimer dans le tableau ci-dessous, puis cliquez sur le bouton Supprimer.',
    'Manage Notification List' => 'Gérer la liste de notification',
    'Individual' => 'Individuel',
    '_USAGE_COMMENTERS_LIST' => 'Cette liste est la liste des auteurs de commentaires pour [_1].',
    'RSS 2.0 Index' => 'Index RSS 2.0',
    '_USAGE_BANLIST' => 'Cette liste est la liste des adresses IP qui ne sont pas autorisées à publier de commentaires ou envoyer des pings TrackBack à votre site. Vous pouvez ajouter une nouvelle adresse IP dans le formulaire suivant. Pour supprimer une adresse de la liste des adresses IP bannies, cochez la case Supprimer dans le tableau ci-dessous, puis cliquez sur le bouton Supprimer.',
    '_ERROR_DATABASE_CONNECTION' => 'Les paramètres de votre base de données sont soit invalides, absents ou ne peuvent pas être lus correctement. Consultez la base de connaissances pour plus d\'informations.',
    'Configure Weblog' => 'Configurer le Weblog',
    '_INDEX_INTRO' => '<p>Si vous ninstallez Movable Type, il vous sera certainement utile de consulter <a href="http://www.sixapart.com/movabletype/docs/mtinstall.html">la documentation d\'installation</a> et <a rel="nofollow" href="mt-check.cgi">le système de vérification de Movable Type</a> pour vérifier que votre système est conforme.</p>', # Translate
    '_USAGE_FEEDBACK_PREFS' => 'Cette page vous permet de configurer les manières dont un lecteur peut contribuer sur votre weblog',
    '_USAGE_COMMENTS_LIST_ALL_WEBLOGS' => 'Voilà une liste de  commentaires pour tous les weblogs que vous pouvez filtrer, gérer et éditer.',
    '_USAGE_NEW_AUTHOR' => ' A partir de cette page vous pouvez créer de nouveaux auteurs dans le système et définir leurs accès dans les weblogs',
    '_USAGE_FORGOT_PASSWORD_2' => 'Ce nouveau mot de passe devrait vous permettre d\'ouvrir une session Movable Type. Vous pourrez changer ce mot de passe une fois la session ouverte.',
    '_USAGE_COMMENT' => 'Modifiez le commentaire sélectionné. Cliquez sur Enregistrer une fois les modifications apportées. Vous devrez actualiser vos fichiers pour voir les modifications reflétées sur votre site.',
    '_USAGE_FORGOT_PASSWORD_1' => 'Vous avez demandé à récupérer votre mot de passe Movable Type. Votre mot de passe a été changé au niveau du système ; le nouveau mot de passe est le suivant:',
    '_USAGE_COMMENTS_LIST_OVERVIEW' => 'Voici la liste des commentaires pour tous vos weblogs, que vous pouvez filtrer, gérer et éditer', # Translate
    '_USAGE_EXPORT_2' => 'Pour exporter vos notes: cliquez sur le lien ci-dessous (Exporter les notes de [_1]). Pour enregistrer les données exportées dans un fichier, vous pouvez enfoncer la touche <code>option</code> (Macintosh) ou <code>Maj</code> (Windows) et la maintenir enfoncée tout en cliquant sur le lien. Vous pouvez également sélectionner toutes les données et les copier dans un autre document. <a href="#" onclick="openManual(\'importing\', \'export_ie\');return false;">Vous exportez des données depuis Internet Explorer?</a>',
    '_SYSTEM_TEMPLATE_POPUP_IMAGE' => 'Affiché quand un visiteur clique sur une image Pop up',
    '_USAGE_PING_LIST_ALL_WEBLOGS' => 'Voici une liste de Ping de Trackback pour tous les weblogs que vous pouvez filtrer, gérer et éditer.',
    '_SYSTEM_TEMPLATE_DYNAMIC_ERROR' => 'Affiché quand une erreur est rencontrée dans une page blog dynamique',
    'Publish Entries' => 'Publier les notes',
    'Date-Based Archive' => 'Archivage par date',
    'Unban Commenter(s)' => 'Réautoriser le commentateur',
    'Individual Entry Archive' => 'Archivage par note',
    'Daily' => 'Quotidien',
    '_USAGE_PING_LIST_OVERVIEW' => 'Voici la liste des tracbacks pour tous vos weblogs que vous pouvez filtrer, gérer et éditer', # Translate
    'Unpublish Entries' => 'Annuler publication',
    '_USAGE_UPLOAD' => 'Vous pouvez télécharger le fichier ci-dessus dans le chemin local de votre site <a href="javascript:alert(\'[_1]\')">(?)</a> ou dans le chemin des archives de votre site <a href="javascript:alert(\'[_2]\')">(?)</a>. Vous pouvez également télécharger le fichier dans un répertoire compris dans les répertoires mentionnés ci-dessus, en spécifiant le chemin dans les champs de droite (<i>images</i>, par exemple). Les répertoires qui n\'existent pas encore seront créés.',
    '_USAGE_REBUILD' => 'Vous devrez cliquer sur <a href="#" onclick="doRebuild()">Actualiser</a> pour voir les modifications reflétées sur votre site publiî',
    'Blog Administrator' => 'Administrateur Blog',
    'CATEGORY_ADV' => 'par catégorie',
    'Dynamic Site Bootstrapper' => 'Initialisateur de site dynamique',
    '_USAGE_PLUGINS' => 'Voici la liste des tous les Plug Ins actuellement enregistrés avec Movable type.',
    '_USAGE_COMMENTS_LIST_BLOG' => 'Voici la liste des Trackbacks pour tous vos weblogs que vous pouvez filtrer, gérer et éditer.', # Translate
    'Category Archive' => 'Archivage par catégorie',
    '_USAGE_PERMISSIONS_2' => 'Vous pouvez modifier les permissions affectées à un utilisateur en sélectionnant ce dernier dans le menu déroulant, puis en cliquant sur Modifier.',
    '_USAGE_EXPORT_1' => 'L\'exportation de vos notes de Movable Type vous permet de créer une <b>version de sauvegarde</b> du contenu de votre weblog. Le format des notes exportées convient à leur importation dans le système à l\'aide du mécanisme d\'importation (voir ci-dessus), ce qui vous permet, en plus d\'exporter vos notes à des fins de sauvegarde, d\'utiliser cette fonction pour <b>transférer vos notes d\'un weblog à un autre</b>.',
    'Untrust Commenter(s)' => 'Retirer statut fiable au commentateur',
    '_SYSTEM_TEMPLATE_PINGS' => 'Affiché quand les PopUps de Trackbacks sont désactivés',
    'Entry Creation' => 'Création d\'une note',
    '_USAGE_PROFILE' => 'Cet espace permet de changer votre profil d\'auteur. Les modifications apportées à votre nom d\'utilisateur et à votre mot de passe sont automatiquement mises à jour. En d\'autres termes, vous devrez ouvrir une nouvelle session.',
    'Category' => 'Catégorie',
    'Atom Index' => 'Index Atom',
    '_USAGE_PLACEMENTS' => 'Les outils d\'édition permettent de gérer les catégories secondaires auxquelles cette note est associée. La liste de gauche contient les catégories auxquelles cette note n\'est pas encore associée en tant que catégorie principale ou catégorie secondaire ; la liste de droite contient les catégories secondaires auxquelles cette note est associée.',
    '_USAGE_ENTRYPREFS' => 'La configuration des champs détermine les champs de saisie qui apparaîtront dans les écrans de création et de modification des notes. Vous pouvez sélectionner une configuration existante (basique ou avancée), ou personnaliser vos écrans en activant le bouton Personnalisée, puis en sélectionnant les champs que vous souhaitez voir apparaître.',
    '_THROTTLED_COMMENT_EMAIL' => 'Un visiteur de votre weblog [_1] a été automatiquement bannit après avoir publié une quantité de commentaires supérieure à la limite établie au cours des [_2] secondes. Cette opération est destinée à empêcher la publication automatisée de commentaires par des scripts. L\'adresse IP bannie est

    [_3]

S\'il s\'agit d\'une erreur, vous pouvez annuler le bannissement de l\'adresse IP dans Movable Type, sous Configuration du weblog > Bannissement d\'adresses IP, et en supprimant l\'adresse IP [_4] de la liste des addresses bannies.',
    'Stylesheet' => 'Feuille de style',
    'RSD' => 'RSD', # Translate
    'MONTHLY_ADV' => 'par mois',
    'Trust Commenter(s)' => 'Donner statut fiable au commentateur',
    'Manage Tags' => 'Gérer les Tags', # Translate
    '_SYSTEM_TEMPLATE_COMMENT_PREVIEW' => 'Affiché quand un commentateur consulte un aperçu de  son commentaire',
    '_THROTTLED_COMMENT' => 'Dans le but de réduire les possibilités d\'abus, j\'ai activé une fonction obligeant les auteurs de commentaires à attendre quelques instants avant de publier un autre commentaire. Veuillez attendre quelques instants avant de publier un autre commentaire. Merci.',
    'Manage Templates' => 'Gérer les Modèles',
    '_USAGE_BOOKMARKLET_3' => 'Pour installer le signet QuickPost de Movable Type: déposez le lien suivant dans le menu ou la barre d\'outils des liens favoris de votre navigateur.',
    '_USAGE_SEARCH' => 'Vous pouvez utiliser l\'outil de recherche et de remplacement pour effectuer des recherches dans vos notes ou pour remplacer chaque occurrence d\'un mot, d\'une phrase ou d\'un caractère par un autre. Important: faites preuve de prudence, car <b>il n\'existe pas de fonction d\'annulation</b>. Nous vous recommandons même d\'exporter vos notes Movable Type, juste au cas où.',
    '_external_link_target' => '_haut', # Translate
    '_USAGE_BOOKMARKLET_2' => 'La structure de la fonction QuickPost de Movable Type vous permet de personnaliser la mise en page et les champs de votre page QuickPost. Par exemple, vous pouvez ajouter une option d\'ajout d\'extraits par l\'intermédiaire de la fenêtre QuickPost. Une fenêtre QuickPost comprend, par défaut, les éléments suivants: un menu déroulant permettant de sélectionner le weblog dans lequel publier la note ; un menu déroulant permettant de sélectionner l\'état de publication (brouillon ou publié) de la nouvelle note ; un champ de saisie du titre de la note ; et un champ de saisie du corps de la note.',
    '_USAGE_PERMISSIONS_1' => 'Vous à *tes en train de modifier les droits de <b>[_1]</b>. Vous trouverez ci-dessous la liste des weblogs pour lesquels vous pouvez contrC4ler les auteurs ; pour chaque weblog de la liste, vous pouvez affecter des droits à <b>[_1]</b> en cochant les cases correspondant aux options souhaitées.',
    '_AUTO' => '1',
    'Add/Manage Categories' => 'Ajouter/Gérer des Categories', # Translate
    '_USAGE_LIST_POWER' => 'Cette liste est la liste des notes de [_1] en mode d\'édition par lots. Le formulaire ci-dessous vous permet de changer les valeurs des notes affichées ; cliquez sur le bouton Enregistrer une fois les modifications souhaitées effectuées. Les fonctions de la liste Notes existantes fonctionnent en mode de traitement par lots comme en mode standard.',
    '_ERROR_CONFIG_FILE' => 'Votre fichier configuration Movable type est absent ou ne peut pas être lu correctement. Merci de consulter la base de connaissances',
    '_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.org/sitefr/">Movable Type <$MTVersion$></a>',
    '_USAGE_PING_LIST_BLOG' => 'Voici la liste des Trackbacks pour [_1]  que vous pouvez filtrer, gérer et éditer.', # Translate
    'Monthly' => 'Mensuel',
    '_USAGE_ARCHIVING_1' => 'Sélectionnez les fréquences/types de mise en archives du contenu de votre site. Vous pouvez, pour chaque type de mise en archives que vous choisissez, affecter plusieurs modèles devant être appliqués. Par exemple, vous pouvez créer deux affichages différents de vos archives mensuelles: un contenant les notes d\'un mois particulier et l\'autre présentant les notes dans un calendrier.',
    'Ban Commenter(s)' => 'Bannir le commentateur',
    '_USAGE_VIEW_LOG' => 'L\'erreur est enregistrée dans le <a href="#" onclick="doViewLog()">journal des activité</a>.',
    '_USAGE_PERMISSIONS_4' => 'Chaque weblog peut être utilisé par plusieurs auteurs. Pour ajouter un auteur, vous entrerez les informations correspondantes dans les formulaires ci-dessous. Sélectionnez ensuite les weblogs dans lesquels l\'auteur pourra travailler. Vous pourrez modifier les droits accordés à l\'auteur une fois ce dernier enregistré dans le système.',
    '_USAGE_AUTHORS_1' => 'C\'est une liste des utilisateurs Movable Type.  Vous pouvez éditer les autorisations d\'un auteur en cliquant sur son nom. Vous pouvez définitivement effacer un auteur en cochant la cas à côté de son nom et en cliquant sur Supprimer. . Attention:  Si vous voulez simplement enlever un auteur sur un blog donné éditer les autorisations de l\'auteur, l\'option supprimer l\'effacera sinon de tous les blogs.  Vous pouvez créer, éditer ou effacer une auteur en utilisant aussi les fichier de commande CSV-based.', # Translate
    '_USAGE_BOOKMARKLET_1' => 'La configuration de la fonction QuickPost vous permet de publier vos notes en un seul clic sans même utiliser l\'interface principale de Movable Type.',
    '_USAGE_ARCHIVING_3' => 'Sélectionnez le type d\'archive auquel vous souhaitez ajouter un modèle. Sélectionnez le modèle que vous souhaitez associer à ce type d\'archive.',
    '_SYSTEM_TEMPLATE_SEARCH_TEMPLATE' => 'Visible quand un lecteur visite le weblog', # Translate
    'UTC+10' => 'UTC+10', # Translate
    '_USAGE_TAGS' => 'Utilisez les tags pour grouper vos notes sous un même mot clefs ce qui vous permettra de les retrouver plus facilement', # Translate
    'INDIVIDUAL_ADV' => 'par note',
    '_USAGE_BOOKMARKLET_5' => 'Vous pouvez également, si vous utilisez Internet Explorer sous Windows, installer une option QuickPost dans le menu contextuel (clic droit) de Windows. Cliquez sur le lien ci-dessous et acceptez le message affiché pour ouvrir le fichier. Fermez et redémarrez votre navigateur pour ajouter le menu au système.',
    '_ERROR_CGI_PATH' => 'Votre configuration de chemin CGI est invalide ou absente de vos fichiers de configuration Movable Type. Merci de consulter la base de connaissance',
    '_USAGE_IMPORT' => 'Vous pouvez utiliser le mécanisme d\'importation de notes pour importer vos notes d\'un autre système de gestion de weblog (Blogger ou Greymatter, par exemple). Ce mode d\'emploi contient des instructions complètes pour l\'importation de vos notes; le formulaire suivant vous permet d\'importer tout un lot de notes déjC  exportées d\'un autre système, et d\'enregistrer les fichiers de façon à pouvoir les utiliser dans Movable Type. Consultez le mode d\'emploi avant d\'utiliser ce formulaire de façon à sélectionner les options adéquates.',
    'Main Index' => 'Index principal',
    '_USAGE_CATEGORIES' => 'Les catégories permettent de regrouper vos notes pour en faciliter la gestion, la mise en archives et l\'affichage dans votre weblog. Vous pouvez affecter une catégorie à chaque note que vous créez ou modifiez. Pour modifier une catégorie existante, cliquez sur son titre. Pour créer une sous-catégorie, cliquez sur le bouton Créer correspondant. Pour déplacer une catégorie, cliquez sur le bouton Déplacer correspondant.',
    '_SYSTEM_TEMPLATE_COMMENTS' => 'Affiché quand les commentaires en pop up sont activés',
    '_USAGE_AUTHORS_2' => 'Vous pouvez enregristrer, editer ou effacer un auteur en utilisant les fichiers de commande CSV', # Translate
    '_USAGE_ENTRY_LIST_BLOG' => 'Voici la liste des notes pour [_1] que vous pouver filtrer, gérer et éditer.', # Translate
    'Master Archive Index' => 'Index principal des archives',
    'Weekly' => 'Hebdomadaire',
    'Unpublish TrackBack(s)' => 'TrackBack(s) non publié(s)',
    '_USAGE_EXPORT_3' => 'Le lien suivant entraîne l\'exportation de toutes les notes de votre weblog vers le serveur Tangent. Il s\'agit généralement d\'une opération ponctuelle, réalisée à la suite de l\'installation du module Tangent pour Movable Type.',
    'Send Notifications' => 'Envoyer des notifications',
    'Edit All Entries' => 'Modifier toutes les notes',
    '_USAGE_PREFS' => 'Cet écran vous permet de définir un grand nombre des paramètres de votre weblog, de vos archives, des commentaires et de communication de notifications. Ces paramètres ont tous des valeurs par défaut raisonnables lors de la création d\'un nouveau weblog.',
    '_SYSTEM_TEMPLATE_COMMENT_ERROR' => 'Affiché quand un commentaire ne peut être validé',
    'Rebuild Files' => 'Reconstruire les fichiers',

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
    'DBI and DBD::Oracle are required if you want to use the Oracle database backend.' => 'DBI et DBD::Oracle nécessaires si vous voulez utiliser un support Oracle.', # Translate
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
    'Required' => 'Requise',
    'Optional' => 'Optionnel',

    ## ./extlib/JSON.pm

    ## ./extlib/DateTimePP.pm

    ## ./extlib/DateTime.pm

    ## ./extlib/URI.pm

    ## ./extlib/DateTimePPExtra.pm

    ## ./extlib/CGI.pm

    ## ./extlib/LWP.pm

    ## ./extlib/I18N/LangTags.pm

    ## ./extlib/I18N/LangTags/List.pm

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

    ## ./extlib/File/Temp.pm

    ## ./extlib/File/Listing.pm

    ## ./extlib/File/Spec.pm

    ## ./extlib/File/Spec/VMS.pm

    ## ./extlib/File/Spec/Functions.pm

    ## ./extlib/File/Spec/Mac.pm

    ## ./extlib/File/Spec/Win32.pm

    ## ./extlib/File/Spec/OS2.pm

    ## ./extlib/File/Spec/Unix.pm

    ## ./extlib/Apache/SOAP.pm

    ## ./extlib/Apache/XMLRPC/Lite.pm

    ## ./extlib/Image/Size.pm

    ## ./extlib/Params/ValidateXS.pm

    ## ./extlib/Params/Validate.pm

    ## ./extlib/Params/ValidatePP.pm

    ## ./extlib/WWW/RobotRules.pm

    ## ./extlib/WWW/RobotRules/AnyDBM_File.pm

    ## ./extlib/Math/BigInt.pm

    ## ./extlib/Math/BigInt/Scalar.pm

    ## ./extlib/Math/BigInt/Trace.pm

    ## ./extlib/Math/BigInt/Calc.pm

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

    ## ./extlib/Locale/Maketext.pm

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

    ## ./extlib/URI/Heuristic.pm

    ## ./extlib/URI/snews.pm

    ## ./extlib/URI/https.pm

    ## ./extlib/URI/URL.pm

    ## ./extlib/URI/_userpass.pm

    ## ./extlib/URI/_login.pm

    ## ./extlib/URI/data.pm

    ## ./extlib/URI/file.pm

    ## ./extlib/URI/ldap.pm

    ## ./extlib/URI/gopher.pm

    ## ./extlib/URI/_foreign.pm

    ## ./extlib/URI/Fetch.pm

    ## ./extlib/URI/rlogin.pm

    ## ./extlib/URI/sip.pm

    ## ./extlib/URI/telnet.pm

    ## ./extlib/URI/ssh.pm

    ## ./extlib/URI/rsync.pm

    ## ./extlib/URI/Escape.pm

    ## ./extlib/URI/_segment.pm

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

    ## ./extlib/XML/XPath.pm

    ## ./extlib/XML/Elemental.pm

    ## ./extlib/XML/NamespaceSupport.pm

    ## ./extlib/XML/Simple.pm

    ## ./extlib/XML/SAX.pm

    ## ./extlib/XML/Atom.pm

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

    ## ./extlib/CGI/Carp.pm

    ## ./extlib/CGI/Pretty.pm

    ## ./extlib/CGI/Cookie.pm

    ## ./extlib/CGI/Fast.pm

    ## ./extlib/CGI/Util.pm

    ## ./extlib/CGI/Push.pm

    ## ./extlib/CGI/Apache.pm

    ## ./extlib/CGI/Switch.pm

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

    ## ./extlib/Attribute/Params/Validate.pm

    ## ./extlib/HTML/Template.pm

    ## ./extlib/Class/ErrorHandler.pm

    ## ./extlib/XMLRPC/Lite.pm

    ## ./extlib/XMLRPC/Test.pm

    ## ./extlib/XMLRPC/Transport/TCP.pm

    ## ./extlib/XMLRPC/Transport/HTTP.pm

    ## ./extlib/XMLRPC/Transport/POP3.pm

    ## ./extlib/IO/SessionData.pm

    ## ./extlib/IO/SessionSet.pm

    ## ./extlib/JSON/Converter.pm

    ## ./extlib/JSON/Parser.pm

    ## ./tools/Html.pm

    ## ./tools/Backup.pm

    ## ./tools/sample.pm

    ## ./tools/cwapi.pm

    ## ./lib/MT.pm
    'Message: [_1]' => 'Message: [_1]', # Translate
    '[_1] died with: [_2]' => '[_1] mort avec: [_2]', # Translate
    '[_1] returned error: [_2]' => '[_1] erreur retournée: [_2]', # Translate
    'Callback died: [_1]' => 'Callback died: [_1]', # Translate
    'Plugin error: [_1] [_2]' => 'Plugin erreur: [_1] [_2]', # Translate

    ## ./lib/MT/BasicAuthor.pm

    ## ./lib/MT/TaskMgr.pm
    'Error during task \'[_1]\': [_2]' => 'Error pendant la tache \'[_1]\': [_2]', # Translate
    'Task Update' => 'Mise à Jour de tache', # Translate

    ## ./lib/MT/Placement.pm

    ## ./lib/MT/TagMap.pm

    ## ./lib/MT/Category.pm
    'Categories must exist within the same blog' => 'Les categories doivent exister au sein du même blog ', # Translate
    'Category loop detected' => 'Loop de catégorie détecté', # Translate

    ## ./lib/MT/Bootstrap.pm
    'Got an error: [_1]' => 'Erreur de type: [_1]',

    ## ./lib/MT/ConfigMgr.pm
    'Error opening file \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture du fichier \'[_1]\': [_2]',
    'Config directive [_1] without value at [_2] line [_3]' => 'Config directive [_1] sans valeur sur [_2] ligne [_3]',
    'No such config variable \'[_1]\'' => 'La variable de configuration \'[_1]\' n\'existe pas',

    ## ./lib/MT/Image.pm
    'Can\'t load Image::Magick: [_1]' => 'Impossible de charger Image::Magick: [_1]',
    'Reading file \'[_1]\' failed: [_2]' => 'La lecture du fichier \'[_1]\' a échoué: [_2]',
    'Reading image failed: [_1]' => 'Echec lors de la lecture de l\'image: [_1]',
    'Scaling to [_1]x[_2] failed: [_3]' => 'La mise à l\'échelle vers [_1]x[_2] a échoué: [_3]',
    'Can\'t load IPC::Run: [_1]' => 'Impossible de charger IPC::Run: [_1]',
    'You do not have a valid path to the NetPBM tools on your machine.' => 'Votre chemin d\'accès vers les outils NetPBM n\'est pas valide sur votre machine.',

    ## ./lib/MT/Session.pm

    ## ./lib/MT/Trackback.pm

    ## ./lib/MT/FileMgr.pm

    ## ./lib/MT/Sanitize.pm

    ## ./lib/MT/Notification.pm

    ## ./lib/MT/Blocklist.pm

    ## ./lib/MT/Upgrade.pm
    'Running [_1]' => 'Fonctionne avec [_1]',
    'Invalid upgrade function: [_1].' => 'Fonction de mise à jour invalide: [_1].',
    'Error loading class: [_1].' => 'Erreur de chargement de classe: [_1].',
    'Creating initial weblog and author records...' => 'Création du weblog initial et des informations auteur...',
    'Error saving record: [_1].' => 'Erreur de l\'enregistrement des informations: [_1].',
    'First Weblog' => 'Premier Weblog',
    'Can\'t find default template list; where is \'default-templates.pl\'? Error: [_1]' => 'Impossible de trouver la liste de modèles par défaut; où se trouve \'default-templates.pl\'? Erreur: [_1]',
    'Creating new template: \'[_1]\'.' => 'Creation d\'un nouveau modèle: \'[_1]\'.',
    'Mapping templates to blog archive types...' => 'Mapping des habillages vers les archives des blogs...',
    'Upgrading table for [_1]' => 'Mise à jour des tables pour [_1]',
    'Executing SQL: [_1];' => 'Exécution SQL: [_1];',
    'Error during upgrade: [_1]' => 'Erreur pendant la mise à jour: [_1]',
    'Upgrading database from version [_1].' => 'Mise à jour de la Base de données de la version [_1].',
    'Database has been upgraded to version [_1].' => 'La base de données a été mise à jour version [_1].',
    'Setting your permissions to administrator.' => 'Paramétrage des permissions pour administrateur.',
    'Creating configuration record.' => 'Création des infos de configuration.',
    'Creating template maps...' => 'Création des liens de modèles...',
    'Mapping template ID [_1] to [_2] ([_3]).' => 'Lien du modèle [_1] vers [_2] ([_3]).',
    'Mapping template ID [_1] to [_2].' => 'Lien du modèle [_1] vers [_2].',

    ## ./lib/MT/DateTime.pm

    ## ./lib/MT/ObjectTag.pm

    ## ./lib/MT/Author.pm
    'Can\'t approve/ban non-COMMENTER author' => 'Un auteur non commentateur ne peut pas être approuvé ou banni', # Translate
    'The approval could not be committed: [_1]' => 'L\'aprobation ne peut être réalisée: [_1]', # Translate

    ## ./lib/MT/XMLRPC.pm
    'No WeblogsPingURL defined in mt.cfg' => 'Le WeblogsPingURL n\'est pas défini dans le fichier mt.cfg',
    'No MTPingURL defined in mt.cfg' => 'Le MTPingURL  n\'est pas défini dans le fichier mt.cfg',
    'HTTP error: [_1]' => 'Erreur HTTP: [_1]',
    'Ping error: [_1]' => 'Erreur Ping: [_1]',

    ## ./lib/MT/TemplateMap.pm

    ## ./lib/MT/I18N.pm

    ## ./lib/MT/TBPing.pm
    'Load of blog \'[_1]\' failed: [_2]' => 'Le chargement du blog \'[_1]\' a échoué: [_2]',

    ## ./lib/MT/Blog.pm

    ## ./lib/MT/BasicSession.pm

    ## ./lib/MT/Builder.pm
    '&lt;MT[_1]> with no &lt;/MT[_1]>' => '&lt;MT[_1]> with no &lt;/MT[_1]>', # Translate
    'Error in &lt;MT[_1]> tag: [_2]' => 'Erreur dans &lt;MT[_1]> tag: [_2]', # Translate

    ## ./lib/MT/Serialize.pm

    ## ./lib/MT/FileInfo.pm

    ## ./lib/MT/Callback.pm

    ## ./lib/MT/Atom.pm

    ## ./lib/MT/Object.pm
    '4th argument to add_callback must be a perl CODE reference' => '4th argument to add_callback must be a perl CODE reference', # Translate

    ## ./lib/MT/Tag.pm
    'Tag must have a valid name' => 'Le tag doit avoir un nom valide', # Translate
    'This tag is referenced by others.' => 'Ce Tag est référencé par d autres.', # Translate

    ## ./lib/MT/Promise.pm

    ## ./lib/MT/App.pm
    'Error loading [_1]: [_2]' => 'Erreur au chargement [_1]: [_2]', # Translate
    'User \'[_1]\' (user #[_2]) logged in successfully' => 'L\'utilisateur \'[_1]\' (user #[_2]) s\'est enregistré correctement',
    'Invalid login attempt from user \'[_1]\'' => 'Erreur d\'enregistrement pour l\'utilisateur \'[_1]\'',
    'Invalid login.' => 'Identifiant invalide.',
    'User \'[_1]\' (user #[_2]) logged out' => 'L\'utilisateur \'[_1]\' (user #[_2]) s\'est déconnecté',
    'The file you uploaded is too large.' => 'Le fichier que vous souhaitez envoyer est trop lourd.',
    'Unknown action [_1]' => 'Action inconnue [_1]',
    'Loading template \'[_1]\' failed: [_2]' => 'Echec lors du chargement du modèle \'[_1]\': [_2]',

    ## ./lib/MT/Log.pm
    'Entry # [_1] not found.' => 'Note # [_1] non trouvée.', # Translate
    'Junk Log (Score: [_1])' => 'Log indésirable (Score: [_1])', # Translate
    'Comment # [_1] not found.' => 'Commentaire # [_1] non trouvé.', # Translate
    'TrackBack # [_1] not found.' => 'TrackBack # [_1] non trouvé.', # Translate

    ## ./lib/MT/BulkCreation.pm
    'Format error at line [_1]: [_2]' => 'Erreur de format sur la ligne [_1]: [_2]', # Translate
    'Invalid command: [_1]' => 'Commande invalide: [_1]', # Translate
    'Invalid number of columns for [_1]' => 'Nombre de colonnes invalide pour [_1]', # Translate
    'Invalid user name: [_1]' => 'Nom utilisateur incorrect: [_1]', # Translate
    'Invalid display name: [_1]' => 'Nom affichage incorrect: [_1]', # Translate
    'Invalid email address: [_1]' => 'Adresse email incorrecte: [_1]', # Translate
    'Invalid language: [_1]' => 'Language incorrect: [_1]', # Translate
    'Invalid password: [_1]' => 'Mot de passe incorrect: [_1]', # Translate
    'Invalid password hint: [_1]' => 'Aide mémoire mot de passe incorrect: [_1]', # Translate
    'Invalid weblog name: [_1]' => 'Nom de weblog incorrect: [_1]', # Translate
    'Invalid weblog description: [_1]' => 'Description du weblog incorrecte: [_1]', # Translate
    'Invalid site url: [_1]' => 'URL du site incorrecte: [_1]', # Translate
    'Invalid site root: [_1]' => 'Racine site incorrecte: [_1]', # Translate
    'Invalid timezone: [_1]' => 'Zone horaire incorrecte: [_1]', # Translate
    'Invalid new user name: [_1]' => 'Nom de nouvel utilisateur incorrect: [_1]', # Translate
    'author with the same name found.  register was not processed: [_1]' => 'un auteur avec le même nom a été trouvé. L\'enregistrement n\'a pas été fait: [_1]', # Translate
    'author can not be created: [_1].' => 'l\'auteur ne peut pas être crée: [_1].', # Translate
    'author [_1] is created.' => 'l\'auteur [_1] est crée.', # Translate
    'author [_1] is created' => 'l\'auteur [_1] est crée', # Translate
    'blog with the same name found.  blog was not created: [_1]' => 'un blog avec le même nom a été trouvé. Le nouveau blog n\'a pas été crée: [_1]', # Translate
    'blog for author [_1] can not be created.' => 'le blog pour l\'auteur [_1] ne peut pas être crée.', # Translate
    'blog [_1] for author [_2] is created.' => 'le blog[_1] pour l\'auteur [_2] est crée.', # Translate
    'permission cannot be granted to author [_1].' => 'Une autorisation ne peut pas être donnée pour l\'auteur [_1].', # Translate
    'permission granted to [_1]' => 'Autorisation donnée pour l\'auteur [_1]', # Translate
    'author whose name is [_1] is found.  update was not processed: [_2]' => 'l\'auteur dont le nom est [_1] est trouvé.  La mise à jour N\'A PAS été faite: [_2]', # Translate
    'author can not be updated: [_1].' => 'l\'auteur ne peut pas être mis à jour: [_1].', # Translate
    'author [_1] not found.  update was not processed' => 'auteur [_1] non trouvé.  mise à jour non effectuée', # Translate
    'author [_1] is updated.' => 'auteur [_1] mis à jour.', # Translate
    'author [_1] was found, but delete was not processed' => 'auteur[_1] trouvé, mais NON effacé', # Translate
    'author [_1] not found.  delete was not processed' => 'auteur [_1] non trouvé.  NON effacé', # Translate
    'author [_1] is deleted.' => 'auteur [_1] effacé.', # Translate

    ## ./lib/MT/IPBanList.pm

    ## ./lib/MT/AtomServer.pm
    'User \'[_1]\' (user #[_2]) note  #[_3]' => 'Utilisateur \'[_1]\' (utilisateur #[_2]) note ajoutée #[_3]', # Translate

    ## ./lib/MT/PluginData.pm

    ## ./lib/MT/Plugin.pm

    ## ./lib/MT/Entry.pm
    'Load of blog failed: [_1]' => 'Echec lors du chargement du blog: [_1]',

    ## ./lib/MT/Task.pm

    ## ./lib/MT/Config.pm

    ## ./lib/MT/L10N.pm

    ## ./lib/MT/Template.pm
    'Parse error in template \'[_1]\': [_2]' => 'Erreur de parsing dans le modèle \'[_1]\': [_2]',
    'Build error in template \'[_1]\': [_2]' => 'Erreur de compilation dans le modèle \'[_1]\': [_2]',
    'You cannot use a [_1] extension for a linked file.' => 'Vous ne pouvez pas utiliser l\'extension [_1] pour un fichier joint.',
    'Opening linked file \'[_1]\' failed: [_2]' => 'L\'ouverture du fichier lié \'[_1]\' a échoué: [_2] ',

    ## ./lib/MT/ImportExport.pm
    'No Stream' => 'No Stream', # Translate
    'No Blog' => 'Pas de Blog', # Translate
    'Can\'t rewind' => 'Impossible de revenir en arrière', # Translate
    'Can\'t open \'[_1]\': [_2]' => 'Impossible d\'ouvrir \'[_1]\': [_2]',
    'Can\'t open directory \'[_1]\': [_2]' => 'Impossible d\'ouvrir le dossier \'[_1]\': [_2]',
    'No readable files could be found in your import directory [_1].' => 'Aucun fichier lisible n\'a été trouvé dans le répertoire d\'importation [_1].',
    'Importing entries from file \'[_1]\'' => 'Importation des notes du fichier \'[_1]\'',
    'You need to provide a password if you are going to\n' => 'Vous devez saisir un mot de passe si vous allez sur \n',
    'Need either ImportAs or ParentAuthor' => 'ImportAs ou ParentAuthor sont nécessaires',
    'Creating new author (\'[_1]\')...' => 'Creation d\'un nouvel auteur (\'[_1]\')...', # Translate
    'ok\n' => 'ok\n', # Translate
    'failed\n' => 'échoué\n',
    'Saving author failed: [_1]' => 'Echec lors de la sauvegarde de l\'Auteur: [_1]',
    'Assigning permissions for new author...' => 'Mise en place d\'autorisation pour un nouvel auteur...', # Translate
    'Saving permission failed: [_1]' => 'Echec lors de la sauvegarde des Droits des Auteurs: [_1]',
    'Creating new category (\'[_1]\')...' => 'Creation d\'une nouvelle catégorie (\'[_1]\')...', # Translate
    'Saving category failed: [_1]' => 'Echec lors de la sauvegarde des Catégories: [_1]',
    'Invalid status value \'[_1]\'' => 'Valeur d\'état invalide \'[_1]\'',
    'Invalid allow pings value \'[_1]\'' => 'Valeur Ping invalide\'[_1]\'', # Translate
    'Can\'t find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.\n' => 'Can\'t find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.\n', # Translate ??
    'Importing into existing entry [_1] (\'[_2]\')\n' => 'Importation dans la note [_1] (\'[_2]\')\n', # Translate
    'Saving entry (\'[_1]\')...' => 'Enregistrement de la note (\'[_1]\')...', # Translate
    'ok (ID [_1])\n' => 'ok (ID [_1])\n', # Translate
    'Saving entry failed: [_1]' => 'Echec lors de la sauvegarde de la Note: [_1]',
    'Saving placement failed: [_1]' => 'Echec lors de la sauvegarde du Placement: [_1]',
    'Creating new comment (from \'[_1]\')...' => 'Création d\'un nouveau commentaire (de \'[_1]\')...', # Translate
    'Saving comment failed: [_1]' => 'Echec lors de la sauvegarde du Commentaire: [_1]',
    'Entry has no MT::Trackback object!' => 'La note n\'a pas d\'objet MT::Trackback !',
    'Creating new ping (\'[_1]\')...' => 'Création d\'un nouveau ping (\'[_1]\')...', # Translate
    'Saving ping failed: [_1]' => 'Echec lors de la sauvegarde du ping: [_1]',
    'Export failed on entry \'[_1]\': [_2]' => 'Echec lors de l\'export sur la Note \'[_1]\': [_2]',
    'Invalid date format \'[_1]\'; must be ' => 'Format de date invalide \'[_1]\'; doit être ', # Translate

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

    ## ./lib/MT/JunkFilter.pm
    'Action: Junked (score below threshold)' => 'Action: Indésirable (score ci-dessous)',
    'Action: Published (default action)' => 'Action: Pubblié (action par défaut)',
    'Junk Filter [_1] died with: [_2]' => 'Filtre indésirable [_1] mort avec: [_2]',
    'Unnamed Junk Filter' => 'Filtre indésirable sans nom',
    'Composite score: [_1]' => 'Score composite : [_1]',

    ## ./lib/MT/ObjectDriver.pm

    ## ./lib/MT/Mail.pm
    'Unknown MailTransfer method \'[_1]\'' => 'Méthode de transfert de mail inconnu \'[_1]\'',
    'Sending mail via SMTP requires that your server ' => 'L\'envoi de mail via SMTP nécessite que votre serveur ',
    'Error sending mail: [_1]' => 'Erreur lors de l\'envoi du mail: [_1]',
    'You do not have a valid path to sendmail on your machine. ' => 'Le chemin d\'accès vers sendmail n\'est pas valide sur votre machine. ',
    'Exec of sendmail failed: [_1]' => 'Echec lors de l\'exécution de sendmail: [_1]',

    ## ./lib/MT/ErrorHandler.pm

    ## ./lib/MT/Request.pm

    ## ./lib/MT/Permission.pm

    ## ./lib/MT/XMLRPCServer.pm

    ## ./lib/MT/WeblogPublisher.pm
    'Archive type \'[_1]\' is not a chosen archive type' => 'Le Type d\'archive\'[_1]\' n\'est pas un type d\'archive sélectionné',
    'Parameter \'[_1]\' is required' => 'Le Paramètre \'[_1]\' est requis',
    'Building category archives, but no category provided.' => 'Construction des archives de catégorie, mais aucune catégorie n\'a été fournie.',
    'You did not set your Local Archive Path' => 'Vous n\'avez pas spécifié votre chemin local des Archives',
    'Building category \'[_1]\' failed: [_2]' => 'La construction de la catégorie\'[_1]\' a échoué: [_2]',
    'Building entry \'[_1]\' failed: [_2]' => 'La construction de la note \'[_1]\' a échoué: [_2]',
    'Building date-based archive \'[_1]\' failed: [_2]' => 'La construction des archives de la base de données \'[_1]\' a échoué: [_2]',
    'You did not set your Local Site Path' => 'Vous n\'avez pas spécifié votre chemin local du Site',
    'Template \'[_1]\' does not have an Output File.' => 'Le modèle \'[_1]\' n\'a pas de fichier de sortie.',
    'An error occurred while rebuilding to publish scheduled posts: [_1]' => 'Un erreur est intervenue pendant la reconstruction pour publier les notes futures: [_1]', # Translate

    ## ./lib/MT/Auth.pm
    'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Mauvaise authentification de config \'[_1]\': [_2]', # Translate

    ## ./lib/MT/Comment.pm
    'Load of entry \'[_1]\' failed: [_2]' => 'Le chargement de la note \'[_1]\' a échoué: [_2]',

    ## ./lib/MT/DefaultTemplates.pm

    ## ./lib/MT/I18N/default.pm

    ## ./lib/MT/I18N/en_us.pm

    ## ./lib/MT/I18N/ja.pm

    ## ./lib/MT/Plugin/L10N.pm

    ## ./lib/MT/Plugin/JunkFilter.pm
    'from rule' => 'de la règle',
    'from test' => 'du test',

    ## ./lib/MT/Auth/LDAP.pm
    'Loading Net::LDAP failed: [_1]' => 'Chargement Net::LDAP a échoué: [_1]', # Translate
    'LDAP user [_1] not found.' => 'Utilisateur LDAP  [_1] non trouvé.', # Translate
    'Invalid login attempt from user [_1]: [_2]' => 'Echec de la tentatice d\'enregistrement de l\'utilisateur [_1]: [_2]', # Translate
    'Binding to LDAP server failed: [_1]' => 'Binding to LDAP server failed: [_1]', # Translate ??
    'User not found on LDAP: [_1]' => 'Utilisateur non trouvé sur LDAP: [_1]', # Translate
    'More than one user with the same name found on LDAP: [_1]' => 'Plusieurs utilisateurs ont le même nom LDAP: [_1]', # Translate

    ## ./lib/MT/Auth/MT.pm
    'Passwords do not match.' => 'Les mots de passe ne sont pas conformes.',
    'Failed to verify current password.' => 'Erreur lors de la vérification du mot de passe.',
    'Password hint is required.' => 'Le pense bête mot de passe est nécessaire.',

    ## ./lib/MT/L10N/es.pm

    ## ./lib/MT/L10N/fr.pm

    ## ./lib/MT/L10N/de.pm

    ## ./lib/MT/L10N/en_us.pm

    ## ./lib/MT/L10N/nl.pm

    ## ./lib/MT/L10N/ja.pm

    ## ./lib/MT/ObjectDriver/DBI.pm
    'Loading data failed with SQL error [_1]' => 'Echec du Chargement des données SQL erreur [_1]', # Translate
    'Count [_1] failed on SQL error [_2]' => 'Echec Comptage [_1] sur erreur SQL [_2]', # Translate ??
    'Prepare failed' => 'Prepare failed', # Translate ??
    'Execute failed' => 'Execute failed', # Translate ??
    'existence test failed on SQL error [_1]' => 'existence test failed on SQL error [_1]', # Translate ??
    'Insertion test failed on SQL error [_1]' => 'Insertion test failed on SQL error [_1]', # Translate ??
    'Update failed on SQL error [_1]' => 'Echec de la mise à jour erreur SQL [_1]', # Translate ??
    'No such object.' => 'Objet inconnu.', # Translate
    'Remove failed on SQL error [_1]' => 'Remove failed on SQL error [_1]', # Translate??
    'Remove-all failed on SQL error [_1]' => 'Remove-all failed on SQL error [_1]', # Translate??

    ## ./lib/MT/ObjectDriver/DBM.pm
    'Your DataSource directory (\'[_1]\') does not exist.' => 'Votre dossier de données (\'[_1]\') n\'existe pas.',
    'Your DataSource directory (\'[_1]\') is not writable.' => 'Votre dossier de données (\'[_1]\') est protégé en écriture.',
    'Tie \'[_1]\' failed: [_2]' => 'La création du lien \'[_1]\' a échoué: [_2]',
    'Failed to generate unique ID: [_1]' => 'Echec lors de la génération de l\'ID unique: [_1]',
    'Unlink of \'[_1]\' failed: [_2]' => 'La suppression du lien \'[_1]\' a échoué: [_2]',

    ## ./lib/MT/ObjectDriver/DBI/mysql.pm
    'Connection error: [_1]' => 'Erreur de connexion: [_1]',
    'undefined type: [_1]' => 'Type indéfini: [_1]', # Translate

    ## ./lib/MT/ObjectDriver/DBI/oracle.pm

    ## ./lib/MT/ObjectDriver/DBI/postgres.pm

    ## ./lib/MT/ObjectDriver/DBI/sqlite.pm
    'Your database file (\'[_1]\') is not writable.' => 'Votre fichier base de données (\'[_1]\') est interdit en écriture.',
    'Your database directory (\'[_1]\') is not writable.' => 'Le répertoire de votre Base de données(\'[_1]\') est interdit en écriture.',

    ## ./lib/MT/FileMgr/FTP.pm

    ## ./lib/MT/FileMgr/DAV.pm

    ## ./lib/MT/FileMgr/Local.pm
    'Opening local file \'[_1]\' failed: [_2]' => 'L\'ouverture du fichier local \'[_1]\' a échoué: [_2]',
    'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Renommer \'[_1]\' vers \'[_2]\' a échoué: [_3]',
    'Deleting \'[_1]\' failed: [_2]' => 'Effacement \'[_1]\' echec: [_2]', # Translate

    ## ./lib/MT/FileMgr/SFTP.pm

    ## ./lib/MT/Template/Context.pm

    ## ./lib/MT/Template/ContextHandlers.pm
    'Can\'t find included template module \'[_1]\'' => 'Impossible de trouver le module de modèle inclus \'[_1]\'',
    'Can\'t find included file \'[_1]\'' => 'Impossible de trouver le fichier inclus \'[_1]\'',
    'Error opening included file \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture du fichier inclus \'[_1]\': [_2]',
    'Unspecified archive template' => 'Habillage d\'archive non spécifié', # Translate
    'Error in file template: [_1]' => 'Erreur dans fichier habillage: [_1]', # Translate
    'Can\'t find template \'[_1]\'' => 'Impossible de trouver le modèle \'[_1]\'',
    'Can\'t find entry \'[_1]\'' => 'Impossible de trouver la note \'[_1]\'',
    'You used a [_1] tag without any arguments.' => 'Vous utilisez un [_1] tag sans aucun argument.',
    'You have an error in your \'category\' attribute: [_1]' => 'Vous avez une erreur dans votre attribut \'categorie\' : [_1]', # Translate
    'You have an error in your \'tag\' attribute: [_1]' => 'Vous avez une erreur dans votre attribut \'tag\': [_1]', # Translate
    'No such author \'[_1]\'' => 'L\'auteur \'[_1]\' n\'existe pas',
    'You used an \'[_1]\' tag outside of the context of an entry; ' => 'Vous utilisez un tag \'[_1]\' en dehors du contexte d\'une note; ',
    'You used <$MTEntryFlag$> without a flag.' => 'Vous utilisez <$MTEntryFlag$> sans drapeau.',
    'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Vous avez utilisé un [_1] tag pour créer un lien vers \'[_2]\' archives, mais le type d\'archive n\'est pas publié.',
    'Could not create atom id for entry [_1]' => 'Impossible de créer un ID Atom pour cette note [_1]', # Translate ??
    'To enable comment registration, you ' => 'Pour demander l\'enregistrement avant de pouvoir commenter, vous ',
    '(You may use HTML tags for style)' => '(Vous dpouvez utiliser des tags HTML pour le style)',
    'You used an [_1] tag without a date context set up.' => 'Vous utilisez un tag [_1] sans avoir configuré la date.',
    'You used an \'[_1]\' tag outside of the context of a comment; ' => 'Vous utilisez un tag \'[_1]\' en dehors du contexte d\'un commentaire; ',
    'You used an [_1] without a date context set up.' => 'Vous utilisez un [_1] sans avoir configurer la date.',
    '[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] est valide uniquement avec des archives quotidiennes, hebdomadaires ou mensuelles.',
    'Couldn\'t get daily archive list' => 'Impossible de récupérer la liste des archives journalières', # Translate
    'Couldn\'t get monthly archive list' => 'Impossible de récupérer la liste des archives mensuelles', # Translate
    'Couldn\'t get weekly archive list' => 'Impossible de récupérer la liste des archives hebdomadaire', # Translate
    'Unknown archive type [_1] in <MTArchiveList>' => 'Type d\'archive inconnu [_1] in <MTArchiveList>', # Translate??
    'Group iterator failed.' => 'Group iterator failed.', # Translate ??
    'You used an [_1] tag outside of the proper context.' => 'Vous utilisez un tag [_1] en dehors de son contexte propre.',
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly ' => 'Vous utilisez un tag [_1] en dehors d\'une utilisation quotidienne, hebdomadaire ou mensuelle ',
    'Could not determine entry' => 'La note ne peut pas être déterminée', # Translate
    'Invalid month format: must be YYYYMM' => 'Le format du mois est invalide: Il doit être de la forme AAAAAMM',
    'No such category \'[_1]\'' => 'La catégorie \'[_1]\' n\'existe pas',
    'You used <$MTCategoryDescription$> outside of the proper context.' => 'Vous avez utilisé <$MTCategoryDescription$> en dehors de son contexte.', # Translate ??
    '[_1] can be used only if you have enabled Category archives.' => '[_1] peut être utilisé seulement si vous avez activé l\'archivage par Catégories.',
    '<$MTCategoryTrackbackLink$> must be ' => '<$MTCategoryTrackbackLink$> doit être ', # Translate
    'You used [_1] without a query.' => 'Vous utilisez [_1] sans aucune requête.',
    'You need a Google API key to use [_1]' => 'You avez besoin d\'une clé Google API pour utiliser [_1]',
    'You used a non-existent property from the result structure.' => 'Vous utilisez une propriété inexistante de la structure de résultats.',
    'You used an \'[_1]\' tag outside of the context of ' => 'Vous avez utilisé le tag \'[_1]\' en dehors du contexte de ', # Translate
    'MTSubCatsRecurse used outside of MTSubCategories' => 'MTSubCatsRecurse used outside of MTSubCategories', # Translate ??
    'MT[_1] must be used in a category context' => 'MT[_1] doit être utilisé dans le contexte d\'une catégorie', # Translate
    'Cannot find sort_method' => 'Cannot find sort_method', # Translate ??
    'Error sorting categories: [_1]' => 'Erreur en triant les catégories: [_1]', # Translate

    ## ./lib/MT/App/NotifyList.pm
    'Please enter a valid email address.' => 'Veuillez entrer une adresse e-mail valide.',
    'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Il manque un paramètre requis : blog_id. Veuillez consulter le manuel d\'utilisateur pour configurer les notifications.',
    'Email notifications have not been configured! The weblog owner needs to set the EmailVerificationSecret configuration variable in mt.cfg.' => 'L\'avis par e-mail n\'a pas été configuré ! Le webmaster de la plateforme doit mettre la variable de configuration EmailVerificationSecret dans mt.cfg.',
    'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Vous avez fourni un paramètre de redirection non valide. Le propriétaire du weblog doit spécifier le chemin qui correspond au nom de domaine du weblog.',
    'The email address \'[_1]\' is already in the notification list for this weblog.' => 'L\'adresse e-mail \'[_1]\' fait déjà parti de la liste de notification pour ce weblog.',
    'Please verify your email to subscribe' => 'Merci de vérifier votre email pour souscrire', # Translate
    'The address [_1] was not subscribed.' => 'L\'adresse [_1] n\'a pas été souscrite.', # Translate
    'The address [_1] has been unsubscribed.' => 'L\'adresse [_1] a été supprimée.', # Translate

    ## ./lib/MT/App/Comments.pm
    'No id' => 'pas d\'id', # Translate
    'No such comment' => 'Pas de commentaire de la sorte', # Translate
    'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'l\'IP [_1] a été bannie car elle emet plus de 8 commentaires en  [_2] seconds.', # Translate 
    'IP Banned Due to Excessive Comments' => 'IP bannie pour cause de commentaires excessifs',
    'No entry_id' => 'Pas de note_id', # Translate ??
    'No such entry \'[_1]\'.' => 'Aucune Note \'[_1]\'.',
    'You are not allowed to post comments.' => 'Vous n\'êtes pas autorisé à poster des commentaires.',
    'Comments are not allowed on this entry.' => 'Les commentaires ne sont pas autorisés sur cette Note.',
    'Comment text is required.' => 'Le texte de commentaire est requis.',
    'Registration is required.' => 'L\'inscription est requise.',
    'Name and email address are required.' => 'Le nom et l\'e-mail sont requis.',
    'Invalid email address \'[_1]\'' => 'Adresse e-mail invalide \'[_1]\'',
    'Invalid URL \'[_1]\'' => 'URL invalide \'[_1]\'',
    'Comment save failed with [_1]' => 'La sauvegarde du commentaire a échoué [_1]', # Translate
    'New comment for entry #[_1] \'[_2]\'.' => 'Nouveau commentaire pour la note #[_1] \'[_2]\'.', # Translate
    'Commenter save failed with [_1]' => 'L\'enregistrement du commentateur a échoué [_1]', # Translate
    'Rebuild failed: [_1]' => 'Echec lors de la recontruction: [_1]',
    'New Comment Posted to \'[_1]\'' => 'Nouveau commentaire posté sur \'[_1]\'',
    'The login could not be confirmed because of a database error ([_1])' => 'Le login ne peut pas être confirmé en raison d\'une erreur de base de données ([_1])', # Translate
    'Couldn\'t get public key from url provided' => 'Impossible d\'avoir une clef publique', # Translate ??
    'No public key could be found to validate registration.' => 'Aucune clé publique n\'a été trouvée pour valider l\'inscription.',
    'TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'La vérification de la signature Typekey retournée [_1] dans [_2] secondes en vérifiant [_3] avec [_4]', # Translate ??
    'The TypeKey signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'La signature Typekey est périmée depuis  ([_1] secondes). Vérifier que votre serveur a une heure correcte', # Translate
    'The sign-in validation failed.' => 'Cette validation pour enregistrement a échoué.', # Translate
    'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Les commentateurs de ce weblog doivent donner une adresse email. Si vous souhaitez le faire il faut vous enregistrer à nouveau et donner l\'autorisation au système d\'identification de récupérer votre adresse email', # Translate ??
    'Couldn\'t save the session' => 'Impossible de sauvegarder la session', # Translate
    'This weblog requires commenters to pass an email address' => 'Les commentateurs de ce weblog doivent donner une adresse email', # Translate
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

    ## ./lib/MT/App/Search.pm
    'You are currently performing a search. Please wait ' => 'Une recherche est actuellement en cours. Merci de patienter ',
    'Search failed. Invalid pattern given: [_1]' => 'Echec de la recherche. Comportement non valide: [_1]', # Translate??
    'Search failed: [_1]' => 'Echec lors de la recherche: [_1]',
    'No alternate template is specified for the Template \'[_1]\'' => 'Pas d\'habillage alternatif spécifié pour l\'habillage \'[_1]\'', # Translate
    'Building results failed: [_1]' => 'Echec lors de la construction des résultats: [_1]',
    'Search: query for \'[_1]\'' => 'Recherche: requête pour \'[_1]\'',
    'Search: new comment search' => 'Recherche: recherche de nouveaux commentaires', # Translate

    ## ./lib/MT/App/Trackback.pm
    'Invalid entry ID \'[_1]\'' => 'ID de Note invalide \'[_1]\'',
    'You must define a Ping template in order to display pings.' => 'Vous devez définir un modèle d\'affichage Ping pour les afficher.',
    'Trackback pings must use HTTP POST' => 'Les Pings Trackback doivent utiliser HTTP POST',
    'Need a TrackBack ID (tb_id).' => 'Un TrackBack ID est requis (tb_id).',
    'Invalid TrackBack ID \'[_1]\'' => 'TrackBack ID invalide \'[_1]\'',
    'You are not allowed to send TrackBack pings.' => 'You n\'êtes pas autorisé à envoyer des TrackBack pings.',
    'You are pinging trackbacks too quickly. Please try again later.' => 'Vous pinguez les trackbacks trop rapidement. Merci d\'essayer plus tard.',
    'Need a Source URL (url).' => 'Une source URL est requise (url).',
    'This TrackBack item is disabled.' => 'Cet élément TrackBack est désactivé.',
    'This TrackBack item is protected by a passphrase.' => 'Cet élément de TrackBack est protégé par un mot de passe.',
    'New TrackBack for entry #[_1] \'[_2]\'.' => 'Nouveau Tracback pour la note #[_1] \'[_2]\'.', # Translate
    'New TrackBack for category #[_1] \'[_2]\'.' => 'Nouveau Trackback pour la catégorie #[_1] \'[_2]\'.', # Translate
    'Can\'t create RSS feed \'[_1]\': ' => 'Impossible de créer le flux RSS \'[_1]\': ',
    'New TrackBack Ping to Entry [_1] ([_2])' => 'Nouveau TrackBack Ping pour la Note [_1] ([_2])',
    'New TrackBack Ping to Category [_1] ([_2])' => 'Nouveau TrackBack Ping pour la Catégorie [_1] ([_2])',

    ## ./lib/MT/App/Upgrader.pm
    'The initial account name is required.' => 'Le nom initial du compte est nécessaire.', # Translate
    'Failed to authenticate using given credentials: [_1].' => 'Echec d\'identification avec les données fournies: [_1].', # Translate
    'You failed to validate your password.' => 'Echec de la validation du mot de passe.', # Translate
    'You failed to supply a password.' => 'Vous n\'avez pas donné de mot de passe.', # Translate
    'The e-mail address is required.' => 'L\'adresse email est nécessaire.', # Translate
    'User [_1] upgraded database to version [_2]' => 'L\'utilisateur [_1] à mis à jour la base de données vers la version[_2]', # Translate
    'Invalid session.' => 'Session invalide.',
    'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Pas d\'autorisation. Contactez votre administrateur système Movable Type pour changer votre statut.',

    ## ./lib/MT/App/Viewer.pm
    'This is an experimental feature; turn off SafeMode (in mt.cfg) in order to use it.' => 'C\'est une fonctionnalité encore à l\'essai; Désactivez le  SafeMode (dans mt.cfg) pour pouvoir l\'utiliser.', # Translate
    'No blog_id' => 'Pas de blog_id', # Translate
    'Not allowed to view blog [_1]' => 'Non autorisé à voir ce blog [_1]', # Translate
    'Loading blog with ID [_1] failed' => 'Echec du chargement du blog avec ID [_1] ', # Translate
    'Can\'t load \'[_1]\' template.' => 'Impossible de charger l\'habillage \'[_1]\' .', # Translate
    'Building template failed: [_1]' => 'Echec de la construction de l\'habillage: [_1]', # Translate
    'Invalid date spec' => 'Spec de date incorrects', # Translate
    'Can\'t load template [_1]' => 'Impossible de charge l\'habillage [_1]', # Translate
    'Building archive failed: [_1]' => 'Echec de la construction des archives: [_1]', # Translate
    'Invalid entry ID [_1]' => ' ID [_1] de la note incorrect', # Translate
    'Entry [_1] is not published' => 'La note [_1] n\'est pas publiée', # Translate
    'Invalid category ID \'[_1]\'' => 'ID catégorie incorrect \'[_1]\'', # Translate

    ## ./lib/MT/App/CMS.pm
    'No permissions' => 'Aucun Droit',
    'Invalid blog' => 'Blog incorrect', # Translate
    'Convert Line Breaks' => 'Conversion retours ligne',
    'No birthplace, cannot recover password' => 'Pas de lieu de naissance, impossible de retrouver le mot de passe', # Translate
    'Invalid password recovery attempt; can\'t recover password in this configuration' => 'Echec de la tentative de récupération de Mot de Passe; impossible de retrouver le mot de passe dans cette configuration', # Translate
    'Invalid author_id' => 'auteur_id incorrect', # Translate
    'Can\'t recover password in this configuration' => 'Impossible de retrouver le mot de passe dans cette configuration', # Translate
    'Invalid author name \'[_1]\' in password recovery attempt' => 'Nom d\'auteur invalide\'[_1]\' pour la recherche de mot de passe',
    'Author name or birthplace is incorrect.' => 'Le nom de l\'auteur ou son lieu de naissance est incorrect.',
    'Author has not set birthplace; cannot recover password' => 'L\'auteur n\'a pas spécifié son lieu de naissance; impossible de retrouver son mot de passe.',
    'Invalid attempt to recover password (used birthplace \'[_1]\')' => 'Tentative invalide de recherche de mot de passe (lieu de naissance utilisé \'[_1]\')',
    'Author does not have email address' => 'L\'auteur n\'a pas d\'adresse e-mail',
    'Password was reset for author \'[_1]\' (user #[_2]). Password was sent to the following address: [_3]' => 'Mot de passe réinitialisé pour l\'auteur \'[_1]\' (utilisateur #[_2]). Le mot de passe a été envoyé à l\'adresse: [_3]', # Translate
    'Error sending mail ([_1]); please fix the problem, then ' => 'Erreur lors de l\'envoi de l\'e-mail ([_1]); veuillez résoudre le problème puis ',
    'Invalid type' => 'Type incorrect', # Translate
    'No such tag' => 'Pas de Tag de ce type', # Translate
    'You are not authorized to log in to this blog.' => 'Vous n\'êtes pas autorisé à vous connecter sur ce weblog.',
    'No such blog [_1]' => 'Aucun weblog ne porte le nom [_1]',
    'System Overview' => 'Aperçu général du système',
    'Main Menu' => 'Menu principal',
    'Weblog Activity Feed' => 'Flux d\'activité du weblog', # Translate
    '(author deleted)' => '(auteur effacé)', # Translate
    'Permission denied.' => 'Permission refusée.',
    'All Feedback' => 'Tous les retours lecteurs', # Translate
    'log records' => 'entrées du journal',
    'System Activity Feed' => 'Flux d\'activité du système', # Translate
    'Application log for blog \'[_1]\' reset by \'[_2]\' (user #[_3])' => 'Journal du blog \'[_1]\' mis à zéro par \'[_2]\' (user #[_3])',
    'Application log reset by \'[_1]\' (user #[_2])' => 'Journal de l\'application mis à zéro par \'[_1]\' (user #[_2])',
    'Import/Export' => 'Importer / Exporter',
    'Load failed: [_1]' => 'Echec de chargement: [_1]',
    '(no reason given)' => '(sans raison donnée)', # Translate
    '(untitled)' => '(sans titre)',
    'Create template requires type' => 'La création d\'habillages nécessite un type',
    'New Template' => 'Nouveau modèle',
    'New Weblog' => 'Nouveau weblog',
    'Author requires username' => 'Un nom d\'utilisateur est nécessaire pour l\'auteur',
    'Author requires password' => 'L\'auteur a besoin d\'un mot de passe',
    'Author requires password hint' => 'L\'auteur a besoin d\'un pense bête de mot de passe',
    'Email Address is required for password recovery' => 'L\'adresse email est nécessaire pour récupérer le mot de passe',
    'The value you entered was not a valid email address' => 'Vous devez saisir une adresse e-mail valide',
    'The e-mail address you entered is already on the Notification List for this weblog.' => 'L\'adresse e-mail que vous avez entrée fait déjà parti de la liste de notification de ce weblog.',
    'You did not enter an IP address to ban.' => 'Vous devez saisir une adresse IP à bannir.',
    'The IP you entered is already banned for this weblog.' => 'L\'adresse IP que vous avez entrée a été bannie de ce weblog.',
    'You did not specify a weblog name.' => 'Vous devez  spécifier un nom de weblog.',
    'Site URL must be an absolute URL.' => 'L\'URL du site doit être une URL absolue.',
    'The name \'[_1]\' is too long!' => 'Le nom \'[_1]\' est trop long.',
    'No categories with the same name can have the same parent' => 'Les catégories portant le même nom ne peuvent avoir le même parent',
    'Saving permissions failed: [_1]' => 'Echec lors de la sauvegarde des Autorisations: [_1]',
    'Can\'t find default template list; where is ' => 'Impossible de trouver la liste des modèles par défaut; où est ',
    'Populating blog with default templates failed: [_1]' => 'L\'activation sur le blog des modèles par défaut a échoué: [_1]',
    'Setting up mappings failed: [_1]' => 'La mise en oeuvre des mappings a échoué: [_1]',
    'Weblog \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' créé par \'[_2]\' (user #[_3])',
    'An author by that name already exists.' => 'Un auteur ayant ce nom existe déjà.',
    'Save failed: [_1]' => 'Echec sauvegarde: [_1]', # Translate
    'Saving object failed: [_1]' => 'Echec lors de la sauvegarde de l\'objet: [_1]',
    'No Name' => 'Pas de Nom',
    'Notification List' => 'Liste de notifications',
    'email addresses' => 'adresses email',
    'Can\'t delete that way' => 'Impossible de supprimer comme cela',
    'Your login session has expired.' => 'Votre session a expiré.',
    'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => 'Vous ne pouvez pas effacer cette catégorie car elle contient des sous-catégories. Déplacez ou supprimez d\'abord les sous-catégories pour pouvoir effacer cette catégorie.',
    'Weblog \'[_1]\' deleted by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' effacé par \'[_2]\' (user #[_3])',
    'Unknown object type [_1]' => 'Objet de type [_1] inconnu',
    'Loading object driver [_1] failed: [_2]' => 'Echec lors du chargement du driver [_1]: [_2]',
    'Invalid filename \'[_1]\'' => 'Nom de fichier invalide \'[_1]\'',
    'Reading \'[_1]\' failed: [_2]' => 'Echec \'[_1]\' lors de la lecture de: [_2]',
    'Thumbnail failed: [_1]' => 'Echec de a vignette: [_1]',
    'Error writing to \'[_1]\': [_2]' => 'Erreur \'[_1]\' lors de l\'écriture de: [_2]',
    'Invalid basename \'[_1]\'' => 'Nom de base invalide \'[_1]\'',
    'No such commenter [_1].' => 'Pas de commentateur [_1].',
    'User \'[_1]\' (#[_2]) approved commenter \'[_3]\' (#[_4]).' => 'L\'utilisateur \'[_1]\' (#[_2]) a approuvé le commentateur \'[_3]\' (#[_4]).', # Translate
    'User \'[_1]\' (#[_2]) banned commenter \'[_3]\' (#[_4]).' => 'L\'utilisateur \'[_1]\' (#[_2]) a banni le commentateur \'[_3]\' (#[_4]).', # Translate
    'User \'[_1]\' (#[_2]) unapproved commenter \'[_3]\' (#[_4]).' => 'L\'utilisateur \'[_1]\' (#[_2]) a désapprouvé le commentateur \'[_3]\' (#[_4]).', # Translate
    'Need a status to update entries' => 'Statut nécessaire pour mettre à jour les notes',
    'Need entries to update status' => 'Notes nécessaires pour mettre à jour le statut',
    'One of the entries ([_1]) did not actually exist' => 'Une des notes ([_1]) n\'existait pas',
    'Some entries failed to save' => 'Certaines notes non pas été sauvegardées correctement',
    'You don\'t have permission to approve this TrackBack.' => 'Vous n\'avez pas l\'autorisation d\'approuver ce TrackBack.',
    'Comment on missing entry!' => 'Commentaire su une note maquante!', # Translate
    'You don\'t have permission to approve this comment.' => 'Vous n\'avez pas la permission d\'approuver ce commentaire.',
    'Comment Activity Feed' => 'Flux d\'activité des commentaires', # Translate
    'Orphaned comment' => 'Commentaire orphelin',
    'Plugin Set: [_1]' => 'Eventail de Plugin: [_1]',
    'TrackBack Activity Feed' => 'Flux d\'activité des TrackBacks ', # Translate
    'No Excerpt' => 'Pas d\'extrait',
    'No Title' => 'Pas de Titre',
    'Orphaned TrackBack' => 'TrackBack orphelin',
    'Tag' => 'Tag', # Translate
    'Entry Activity Feed' => 'Flux d\'activité des notes', # Translate
    'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Date invalide \'[_1]\'; les dates doivent être au format YYYY-MM-DD HH:MM:SS.',
    'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Date invalide \'[_1]\'; les dates de publication doivent être réelles.',
    'Saving entry \'[_1]\' failed: [_2]' => 'Echec \'[_1]\' lors de la sauvegarde de la Note: [_2]',
    'Removing placement failed: [_1]' => 'Echec lors de la suppression de l\'emplacement: [_1]',
    'No such entry.' => 'Aucune Note de ce type.',
    'Your weblog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Votre weblog n\'a pas été configuré avec un chemin et une URL. Vous ne pouvez pas publier de notes avant qu\'ils ne soient définis',
    'PreSave failed [_1]' => 'Echec PreEnregistrement [_1]', # Translate
    'The category must be given a name!' => 'Vous devez donner un nom a votre catégorie.',
    'yyyy/mm/entry_basename' => 'yyyy/mm/entry_basename', # Translate ??
    'yyyy/mm/entry-basename' => 'yyyy/mm/entry-basename', # Translate ??
    'yyyy/mm/entry_basename/' => 'yyyy/mm/entry_basename/', # Translate ??
    'yyyy/mm/entry-basename/' => 'yyyy/mm/entry-basename/', # Translate ??
    'yyyy/mm/dd/entry_basename' => 'yyyy/mm/dd/entry_basename', # Translate ??
    'yyyy/mm/dd/entry-basename' => 'yyyy/mm/dd/entry-basename', # Translate ??
    'yyyy/mm/dd/entry_basename/' => 'yyyy/mm/dd/entry_basename/', # Translate ??
    'yyyy/mm/dd/entry-basename/' => 'yyyy/mm/dd/entry-basename/', # Translate ??
    'category/sub_category/entry_basename' => 'category/sub_category/entry_basename', # Translate ??
    'category/sub_category/entry_basename/' => 'category/sub_category/entry_basename/', # Translate ??
    'category/sub-category/entry_basename' => 'category/sub-category/entry_basename', # Translate ??
    'category/sub-category/entry-basename' => 'category/sub-category/entry-basename', # Translate ??
    'category/sub-category/entry_basename/' => 'category/sub-category/entry_basename/', # Translate ??
    'category/sub-category/entry-basename/' => 'category/sub-category/entry-basename/', # Translate ??
    'primary_category/entry_basename' => 'primary_category/entry_basename', # Translate ??
    'primary_category/entry_basename/' => 'primary_category/entry_basename/', # Translate ??
    'primary-category/entry_basename' => 'primary-category/entry_basename', # Translate ??
    'primary-category/entry-basename' => 'primary-category/entry-basename', # Translate ??
    'primary-category/entry_basename/' => 'primary-category/entry_basename/', # Translate ??
    'primary-category/entry-basename/' => 'primary-category/entry-basename/', # Translate ??
    'yyyy/mm/' => 'yyyy/mm/', # Translate
    'yyyy_mm' => 'yyyy_mm', # Translate
    'yyyy/mm/dd/' => 'yyyy/mm/dd/', # Translate
    'yyyy_mm_dd' => 'yyyy_mm_dd', # Translate
    'yyyy/mm/dd-week/' => 'yyyy/mm/dd-week/', # Translate ??
    'week_yyyy_mm_dd' => 'week_yyyy_mm_dd', # Translate ??
    'category/sub_category/' => 'categorie/sous_categorie/',
    'category/sub-category/' => 'categorie/sub-categorie/',
    'cat_category' => 'cat_categorie',
    'Saving blog failed: [_1]' => 'Echec lors de la sauvegarde du blog: [_1]',
    'You do not have permission to configure the blog' => 'Vous n\'avez pas la permission de configurer le weblog.',
    'Saving map failed: [_1]' => 'Echec lors du rattachement: [_1]',
    'Parse error: [_1]' => 'Erreur de parsing: [_1]',
    'Build error: [_1]' => 'Erreur de construction: [_1]',
    'Rebuild-option name must not contain special characters' => 'L option de reconstruction de nom ne doit pas contenir de caractères spéciaux', # Translate
    'index template \'[_1]\'' => 'index hbaillage \'[_1]\'', # Translate
    'entry \'[_1]\'' => 'note \'[_1]\'', # Translate
    'Ping \'[_1]\' failed: [_2]' => 'Le Ping \'[_1]\' n\'a pas fonctionné: [_2]',
    'You cannot modify your own permissions.' => 'Vous ne pouvez pas modifier vos propres permissions.', # Translate
    'You are not allowed to edit the permissions of this author.' => 'Vous n êtes pas autorisé à modifier les autorisations de cet auteur.', # Translate
    'Edit Permissions' => 'Editer les Autorisations',
    'Edit Profile' => 'Editer le profil', # Translate
    'No entry ID provided' => 'Aucune ID de Note fournie',
    'No such entry \'[_1]\'' => 'Aucune Note du type \'[_1]\'',
    'No email address for author \'[_1]\'' => 'L\'auteur \'[_1]\' ne possède pas d\'adresse e-mail',
    'Error sending mail ([_1]); try another MailTransfer setting?' => 'Erreur lors de l\'envoi de l\'e-mail ([_1]); essayer un autre paramètre de MailTransfer?',
    'You did not choose a file to upload.' => 'Vous n\'avez pas sélectionné de fichier à envoyer.',
    'Invalid extra path \'[_1]\'' => 'Chemin supplémentaire invalide \'[_1]\'',
    'Can\'t make path \'[_1]\': [_2]' => 'Impossible de créer le chemin \'[_1]\': [_2]',
    'Invalid temp file name \'[_1]\'' => 'Nom de fichier temporaire invalide \'[_1]\'',
    'Error opening \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture de \'[_1]\': [_2]',
    'Error deleting \'[_1]\': [_2]' => 'Erreur lors de la suppression de \'[_1]\': [_2]',
    'File with name \'[_1]\' already exists. (Install ' => 'Le fichier portant le nom \'[_1]\' existe déjà. (Installez ',
    'Error creating temporary file; please check your TempDir ' => 'Erreur lors de la création du fichier temporaire; veuillez vérifier votre répertoire temporaire (Temp) ',
    'unassigned' => 'non assigné',
    'File with name \'[_1]\' already exists; Tried to write ' => 'Le fichier portant le nom \'[_1]\' existe déjà; Essayez d\'écrire ',
    'Error writing upload to \'[_1]\': [_2]' => 'Erreur d\'écriture lors de l\'envoi de \'[_1]\': [_2]',
    'Perl module Image::Size is required to determine ' => 'le Module Perl Image::Size est requis pour déterminer ',
    'Invalid date(s) specified for date range.' => 'Date(s) incorrecte(s) pour la sélection de calendrier.', # Translate
    'Error in search expression: [_1]' => 'Erreur dans la recherche de l expression: [_1]', # Translate
    'Saving object failed: [_2]' => 'La sauvegarde des objets a échoué: [_2]',
    'Search & Replace' => 'Rechercher et Remplacer',
    'No blog ID' => 'Aucun blog ID',
    'You do not have export permissions' => 'Vous n\'avez pas les droits d\'exportation',
    'You do not have import permissions' => 'Vous n\'avez pas les droits d\'importation',
    'You do not have permission to create authors' => 'Vous n\'êtes pas autorisé à créer des auteurs',
    'Preferences' => 'Préférences',
    'Add a Category' => 'Ajouter une Catégorie',
    'No label' => 'Pas d etiquette', # Translate
    'Category name cannot be blank.' => 'Vous devez nommer votre catégorie.',
    'That action ([_1]) is apparently not implemented!' => 'Cette action([_1]) n\'est visiblement pas implémentée!',
    'Permission denied' => 'Autorisation refusée', # Translate

    ## ./lib/MT/App/ActivityFeeds.pm
    'TrackBacks for [_1]' => 'TrackBacks pour [_1]', # Translate
    'All TrackBacks' => 'Tous les TrackBacks', # Translate
    '[_1] Weblog TrackBacks' => 'TrackBacks du weblog [_1] ', # Translate
    'All Weblog TrackBacks' => 'Tous les TrackBacks du weblog', # Translate
    'Comments for [_1]' => 'Commentaires pour[_1]', # Translate
    'All Comments' => 'Tous les commentaires', # Translate
    '[_1] Weblog Comments' => 'Commentaires du weblog[_1] ', # Translate
    'All Weblog Comments' => 'Tous les commentaires du weblog', # Translate
    'Entries for [_1]' => 'Notes pour [_1]', # Translate
    'All Entries' => 'Toutes les notes', # Translate
    '[_1] Weblog Entries' => 'Notes du weblog[_1] ', # Translate
    'All Weblog Entries' => 'Toutes les notes du weblog ', # Translate
    '[_1] Weblog' => 'Weblog [_1] ', # Translate
    'All Weblogs' => 'Tous les weblogs', # Translate
    '[_1] Weblog Activity' => 'Activité du weblog [_1] ', # Translate
    'All Weblog Activity' => 'Toutes l activité du weblog', # Translate

    ## ./extras/examples/plugins/mirror/lib/Mirror.pm

    ## ./plugins/spamlookup/lib/spamlookup.pm
    'Failed to resolve IP address for source URL [_1]' => 'Impossible de trouver l adresse IP de l URL source [_1]', # Translate
    'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Modération: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]', # Translate ??
    'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]', # Translate ??
    'No links are present in feedback' => 'Pas de lien dans ce retour lecteur', # Translate
    'Number of links exceed junk limit ([_1])' => 'Le nombre de liens dépasse la limite des indésirables ([_1])', # Translate
    'Number of links exceed moderation limit ([_1])' => 'Le nombre de liens dépasse la limite de modération([_1])', # Translate
    'Link was previously published (comment id [_1]).' => 'Le lien a par le passé été publié (Id commentaire [_1]).', # Translate
    'Link was previously published (TrackBack id [_1]).' => 'Le lien a par le passé été publié (TrackBack id [_1]).', # Translate
    'E-mail was previously published (comment id [_1]).' => 'L E-mail a par le passé été publié (commentaire id [_1]).', # Translate
    'Word Filter match on \'[_1]\': \'[_2]\'.' => 'Le filtre de mot s accorde \'[_1]\': \'[_2]\'.', # Translate
    'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'La modération pour le filtre de mot s accorde \'[_1]\': \'[_2]\'.', # Translate
    'domain \'[_1]\' found on service [_2]' => 'Le domaine \'[_1]\' a été touvé sur le service [_2]', # Translate
    '[_1] found on service [_2]' => '[_1] trouvé sur le service [_2]', # Translate

    ## ./plugins/spamlookup/lib/spamlookup/L10N.pm

    ## ./t/Foo.pm

    ## ./t/Bar.pm

    ## ./t/lib/LWP/UserAgent/Local.pm

    ## ./t/lib/Text/WikiFormat.pm

    ## ./mt-static/mt.js
    'You did not select any [_1] to delete.' => 'Vous n\'avez pas sélectionner de [_1] à effacer.',
    'Are you sure you want to delete this [_1]?' => 'Etes-vous sûr de vouloir effacer ce(cette) [_1]?',
    'Are you sure you want to delete the [_1] selected [_2]?' => 'Etes-vous sûr de vouloir effacer le(la) [_1] sélectionné(e) [_2]?',
    'to delete' => 'à effacer',
    'You did not select any [_1] [_2].' => 'Vous n\'avez pas sélectionné de [_1] [_2].',
    'You must select an action.' => 'Vous devez sélectionner une action.',
    'to mark as junk' => 'pour marquer indésirable',
    'to remove "junk" status' => 'pour retirer le statut "indésirable"',
    'Enter email address:' => 'Saisissez l\'adresse email:',
    'Enter URL:' => 'Saisissez l\'URL:',

    ## ./extras/examples/plugins/mirror/lib/Mirror.pm
);

1;
