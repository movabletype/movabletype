# Movable Type (r) Open Source (C) 2005-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
#
# $Id$

package MT::L10N::fr;
use strict;
use utf8;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

## The following is the translation table.

%Lexicon = (

## php/lib/block.mtsethashvar.php
	'You used a [_1] tag without a valid name attribute.' => 'Vous avez utilisé un tag [_1] sans un attribut de nom valide',

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '\'[_1]\' n\'est pas une fonction valide pour un hash',
	'\'[_1]\' is not a valid function for an array.' => '\'[_1]\' n\'est pas une fonction valide pour un tableau',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] est illégal.',

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'userpic-[_1]-%wx%h%x',

## php/lib/function.mtsetvar.php
	'\'[_1]\' is not a hash.' => '\'[_1]\' n\'est pas un hash',
	'Invalid index.' => 'Index invalide',
	'\'[_1]\' is not an array.' => '\'[_1]\' n\'est pas un tableau',
	'\'[_1]\' is not a valid function.' => '\'[_1]\' n\'est pas une fonction valide',

## php/lib/function.mtcommentauthorlink.php
	'Anonymous' => 'Anonyme',

## php/lib/block.mtsetvarblock.php

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/block.mtentries.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" doit être utilisé en combinaison avec l\'espace de nom.',

## php/lib/function.mtcommentreplytolink.php
	'Reply' => 'Répondre',

## php/lib/function.mtentryclasslabel.php
	'page' => 'Page',
	'entry' => 'note',
	'Page' => 'Page',
	'Entry' => 'Note',

## php/lib/function.mtassettype.php
	'image' => 'image',
	'Image' => 'Image',
	'file' => 'fichier',
	'File' => 'Fichier',
	'audio' => 'Audio',
	'Audio' => 'Audio',
	'video' => 'Vidéo',
	'Video' => 'Vidéo',

## php/lib/function.mtwidgetmanager.php
	'Error: widgetset [_1] is empty.' => 'Erreur: le groupe de widget [_1] est vide.',
	'Error compiling widgetset [_1]' => 'Erreur de compilation du groupe de widget [_1]',

## php/lib/function.mtcommentauthor.php

## php/lib/archive_lib.php
	'Individual' => 'Individuel',
	'Yearly' => 'Annuelles',
	'Monthly' => 'Mensuelles',
	'Daily' => 'Journalières',
	'Weekly' => 'Hebdomadaires',
	'Author' => 'Par auteurs',
	'(Display Name not set)' => '(Nom pas spécifié)',
	'Author Yearly' => 'Par auteurs et années',
	'Author Monthly' => 'Par auteurs et mois',
	'Author Daily' => 'Par auteurs et jours',
	'Author Weekly' => 'Par auteurs et semaines',
	'Category Yearly' => 'Par catégories et années',
	'Category Monthly' => 'Par catégories et mois',
	'Category Daily' => 'Par catégories et jours',
	'Category Weekly' => 'Par catégories et semaines',

## php/lib/block.mtauthorhaspage.php
	'No author available' => 'Il n\'a pas d\'auteurs disponibles',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Saisissez les caractères que vous voyez dans l\'image ci-dessus.',

## php/lib/block.mtif.php

## php/lib/block.mtauthorhasentry.php

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'L\'authentification TypePad n\'est pas activée sur ce blog. MTRemoteSignInLink ne peut être utilisé.',

## php/lib/block.mtassets.php

## php/lib/function.mtauthordisplayname.php

## php/mt.php
	'Page not found - [_1]' => 'Page non trouvée - [_1]',

## mt-check.cgi
	'Movable Type System Check' => 'Vérification du système Movable Type',
	'The mt-check.cgi script provides you with information on your system\'s configuration and determines whether you have all of the components you need to run Movable Type.' => 'Le script mt-check.cgi vous fourni des informations sur la configuration de votre système et détermine si vous avez tous les composants nécessaire pour exécuter Movable Type.',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). Please upgrade to at least Perl [_2].' => 'La version de Perl installée sur votre serveur ([_1]) est inférieur au minimum requis ([_2]). Veuillez mettre à jour vers, au moins, Perl [_2].',
	'Movable Type configuration file was not found.' => 'Le fichier de configuration Movable Type n\'a pas été trouvé.',
	'System Information' => 'Informations système',
	'Movable Type version:' => 'Version de Movable Type :',
	'Current working directory:' => 'Répertoire courant :',
	'MT home directory:' => 'Répertoire d\'accueil MT :',
	'Operating system:' => 'Système d\'exploitation :',
	'Perl version:' => 'Version de Perl :',
	'Perl include path:' => 'Chemin d\'inclusion Perl :',
	'Web server:' => 'Serveur Web :',
	'(Probably) Running under cgiwrap or suexec' => 'Exécuté (probablement) sous cgiwrap ou suexec',
	'[_1] [_2] Modules' => 'Modules [_2] [_1]',
	'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides.' => 'Les modules suivants sont <strong>optionnels</strong. Si votre serveur ne possède pas ces modules, vous devriez installé ces modules que si vous avez besoin des fonctionnalités apportés par le module.',
	'Some of the following modules are required by the various data storage options in Movable Type. In order run the system, your server needs to have DBI and at least one of the other modules installed.' => 'Les modules suivants sont requis par certaines options de stockage dans Movable Type. Afin d\'exécuter le système, votre serveur a besoin d\'avoir DBI et au moins l\'un des autres modules d\'installé.',
	'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'Soit votre serveur n\'a pas [_1] d\'installé, soit la version installée est trop vieille, ou [_1] nécessite un autre module qui n\'est pas installé',
	'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => 'Votre serveur n\'a pas [_1] d\'installé ou [_1] nécessite un autre module qui n\'est pas installé.',
	'Please consult the installation instructions for help in installing [_1].' => 'Veuillez consulter les instructions d\'installation pour obtenir de l\'aide pour installer [_1].',
	'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN.' => 'La version de DBD::mysqel que vous avez installé est connue pour être incompatible avec Movable Type. Veuillez installer l\'édition actuellement disponible sur CPAN.',
	'The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements.' => 'Le $mod est installé correctement mais nécessite un module DBI mis à jour. Veuillez lire la note ci-dessous concernant les conditions requises pour le module DBI.',
	'Your server has [_1] installed (version [_2]).' => 'Votre serveur possède [_1] (version [_2]).',
	'Movable Type System Check Successful' => 'Vérification du système Movable Type terminé avec succès.',
	'You\'re ready to go!' => 'Vous êtes prêt à continuer !',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Votre serveur dispose de tous les modules requis; vous n\'avez pas besoin d\'installer autre chose. Continuer avec les instruction d\'installation.',
	'CGI is required for all Movable Type application functionality.' => 'CGI est nécessaire pour toutes les fonctionnalités de l\'application Movable Type.',
	'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size est nécessaire pour l\'envoi de fichiers (afin de téterminer la taille des images envoyées dans différents formats).',
	'File::Spec is required for path manipulation across operating systems.' => 'File::Spec est nécessaire pour manipuler les chemins de fichiers sur différents systèmes d\'exploitation.',
	'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie est nécessaire pour l\'authentification via un cookie.',
	'DBI is required to store data in database.' => 'DBI est nécessaire pour enregistrer les données en base de données.',
	'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI et DBD::mysql sont nécessaires si vous voulez utiliser une base de données MySQL.',
	'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI et DBD::Pg sont nécessaires si vous voulez utiliser une base de données PostgreSQL.',
	'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI et DBD::SQLite sont nécessaires si vous voulez utiliser une base de données SQLite.',
	'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI et DBD::SQLite2 sont nécessaires si vous voulez utiliser une base de données SQLite 2.x.',
	'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in the configuration file.' => 'HTML::Entities est nécessaire pour encoder certains caractères mais cette fonctionnalité peut être désactivé en utilisant l\'option NoHTMLEntities dans le fichier de configuration.',
	'LWP::UserAgent is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'LQP::UserAgent est optionnel. Il est nécessaire si vous souhaitez utiliser le système de trackback, ping weblogs.com ou le ping des mises à jours récentes MT',
	'HTML::Parser is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'HTML::Parser est optionnel. Il est nécessaire si vous souhaitez utiliser le système de trackback, le ping weblogs.com ou le ping des mises à jours récentes MT.',
	'SOAP::Lite is optional; It is needed if you wish to use the MT XML-RPC server implementation.' => 'SOAP::Lite est optionnel; Il est nécessaire si vous souhaitez utiliser l\'implementation serveur MT XML-RPC.',
	'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Temp est optionnel; Il est nécessaire si vous souhaitez être capable de ré-écrire certains fichiers lors d\'envois.',
	'Scalar::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'Scalar::Util est optionnel; Il est nécessaire uniquement si vous souhaitez utiliser la fonction de file d\'attente de publication.',
	'List::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'List:Util est optionnel; Il est nécessaire si vous souhaitez utiliser les possibilités de publications en mode file d\'attente',
	'Image::Magick is optional; It is needed if you would like to be able to create thumbnails of uploaded images.' => 'Image::Magick est optionnel; Il est nécessaire si vous souhaitez être capable de créer des miniatures d\'images envoyés.',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Ce module est nécessaire si vous souhaitez pouvoir créer des vignettes pour les images envoyées.',
	'This module is needed if you would like to be able to use NetPBM as the image driver for MT.' => 'Ce module est nécessaire si vous souhaitez pouvoir utiliser NetPBM comme pilote d\'image pour MT.',
	'Storable is optional; it is required by certain MT plugins available from third parties.' => 'Storable est optionnel; il est nécessaire par certains plugins MT disponibles auprès de tierces parties.',
	'Crypt::DSA is optional; if it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSA est optionnel; S\'il est installé, les créations de comptes d\'auteurs de commemtaires seront plus rapides.',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers such as AOL and Yahoo! which require SSL support.' => 'Ce module et ses dépendances sont nécessaires afin de permettre aux auteurs de commentaires d\'être authentifiés par des fournisseurs OpenID comme AOL ou Yahoo! qui nécessitent SSL.',
	'MIME::Base64 is required in order to enable comment registration.' => 'MIME::Base64 est nécessaire afin de permettre les créations de comptes d\'auteurs de commentaires.',
	'XML::Atom is required in order to use the Atom API.' => 'XML::Atom est nécessaire afin d\'utiliser l\'API Atom.',
	'Cache::Memcached and memcached server/daemon is required in order to use memcached as caching mechanism used by Movable Type.' => 'Cache::Memcached et memcached server/daemon sont nécessaires afin d\'utiliser memcached en tant que système de cache utilisé par Movable Type.',
	'Archive::Tar is required in order to archive files in backup/restore operation.' => 'Archive::Tar est nécessaire afin d\'archiver les fichiers lors des opérations de sauvegarde et de restauration.',
	'IO::Compress::Gzip is required in order to compress files in backup/restore operation.' => 'IO::Compress:Gzip est nécessaire afin de compresser les fichiers lors les opérations de sauvegarde et de restauration.',
	'IO::Uncompress::Gunzip is required in order to decompress files in backup/restore operation.' => 'IO::Uncompress::Gunzip est nécessaire afin de décompresser les fichiers lors des opérations de sauvegarde et de restoration.',
	'Archive::Zip is required in order to archive files in backup/restore operation.' => 'Archive::Zip est nécessaire afin d\'arciver les fichiers lors des opérations de sauvegarde et de restauration.',
	'XML::SAX and/or its dependencies is required in order to restore.' => 'XML::SAX et/ou ses dépendancwes sont nécessaires lors des operations de restauration.',
	'Digest::SHA1 and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including Vox and LiveJournal.' => 'Digest::SHA1 et ses dépendances sont nécessaires afin de permettre aux auteurs de commentaires d\'être identifiés par les fournisseurs OpenID comme Vox ou LiveJournal.',
	'Mail::Sendmail is required for sending mail via SMTP Server.' => 'Mail::Sendmail est nécessaire afin d\'envoyer des e-mails via un serveur SMTP.',
	'This module is used in test attribute of MTIf conditional tag.' => 'Ce module est utilisé dans l\'attribut de test du tag conditionnel MTIf.',
	'This module is used by the Markdown text filter.' => 'Ce module est utilisé par le filtre de texte Markdown',
	'This module is required in mt-search.cgi if you are running Movable Type on Perl older than Perl 5.8.' => 'Ce module est nécessaire pour mt-search.cgi si vous utilisez Movable Type sur une version de Perl supérieur à 5.8.',
	'This module required for action streams.' => 'Ce module est nécessaire pour les action streams.',
	'The [_1] database driver is required to use [_2].' => 'Le driver de base de données [_1] est obligatoire pour utiliser [_2].',
	'Checking for' => 'Vérification de l\'état de',
	'Installed' => 'Installé',
	'Data Storage' => 'Stockage des données',
	'Required' => 'Nécessaire',
	'Optional' => 'Optionnel',

## default_templates/recent_assets.mtml
	'Recent Assets' => 'Éléments récents',

## default_templates/monthly_archive_dropdown.mtml
	'Archives' => 'Archives',
	'Select a Month...' => 'Sélectionnez un Mois...',

## default_templates/notify-entry.mtml
	'A new [lc,_3] entitled \'[_1]\' has been published to [_2].' => 'Une nouvelle [lc,_3] intitulée \'[_1]\' a été publiée sur [_2].',
	'View entry:' => 'Voir la note :',
	'View page:' => 'Voir la page :',
	'[_1] Title: [_2]' => 'Titre du [_1] : [_2]',
	'Publish Date: [_1]' => 'Date de publication : [_1]',
	'Message from Sender:' => 'Message de l\'expéditeur :',
	'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'Vous recevez cet email car vous avez demandé à recevoir les notifications de nouveau contenu sur [_1], ou l\'auteur de la note a pensé que vous seriez intéressé. Si vous ne souhaitez plus recevoir ces emails, merci de contacter la personne suivante:',

## default_templates/tag_cloud.mtml
	'Tag Cloud' => 'Nuage de tags',

## default_templates/category_archive_list.mtml
	'Categories' => 'Catégories',
	'[_1] ([_2])' => '[_1] ([_2])',

## default_templates/current_author_monthly_archive_list.mtml
	'[_1]: Monthly Archives' => '[_1]: Archives Mensuelles',

## default_templates/main_index.mtml
	'HTML Head' => 'En-tête HTML',
	'Banner Header' => 'Bloc de l\'En-tête',
	'Entry Summary' => 'Résumé de la note',
	'Sidebar' => 'Colonne latérale',
	'Banner Footer' => 'Bloc du Pied de page',

## default_templates/page.mtml
	'Trackbacks' => 'Trackbacks',
	'Comments' => 'Commentaires',

## default_templates/main_index_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to only appear on the homepage (or "main_index"). More info: [_1]' => 'Ceci est un groupe de wigets personnalisé qui est conditionné pour n\'apparaître que sur la page d\'accueil (ou "main_index"). Plus d\'infos : [_1]',
	'Recent Comments' => 'Commentaires récents',
	'Recent Entries' => 'Notes récentes',

## default_templates/entry_summary.mtml
	'By [_1] on [_2]' => 'Par [_1] le [_2]',
	'1 Comment' => '1 Commentaire',
	'# Comments' => '# Commentaires',
	'No Comments' => 'Aucun Commentaire',
	'1 TrackBack' => '1 Trackback',
	'# TrackBacks' => '# Trackbacks',
	'No TrackBacks' => 'Aucun Trackback',
	'Tags' => 'Tags',
	'Continue reading <a href="[_1]" rel="bookmark">[_2]</a>.' => 'Lire la suite de <a href="[_1]" rel="bookmark">[_2]</a>.',

## default_templates/comment_response.mtml
	'Confirmation...' => 'Confirmation...',
	'Your comment has been submitted!' => 'Votre commentaire a été envoyé !',
	'Thank you for commenting.' => 'Merci de votre commentaire.',
	'Your comment has been received and held for approval by the blog owner.' => 'Votre commentaire a été reçu et est en attente de validation par le propriétaire de ce blog.',
	'Comment Submission Error' => 'Erreur d\'envoi du commentaire',
	'Your comment submission failed for the following reasons: [_1]' => 'La soumission de votre commentaire a échoué pour la raison suivante : [_1]',
	'Return to the <a href="[_1]">original entry</a>.' => 'Retourner à la <a href="[_1]">note originale</a>.',

## default_templates/commenter_notify.mtml
	'This email is to notify you that a new user has successfully registered on the blog \'[_1]\'. Listed below you will find some useful information about this new user.' => 'Un nouvel utilisateur s\'est enregistré sur le blog \'[_1]\'. Vous trouverez ci-dessous quelques informations utiles à propos de ce nouvel utilisateur.',
	'New User Information:' => 'Informations concernant ce nouvel utilisateur :',
	'Username: [_1]' => 'Identifiant : [_1]',
	'Full Name: [_1]' => 'Nom complet : [_1]',
	'Email: [_1]' => 'Email : [_1]',
	'To view or edit this user, please click on or cut and paste the following URL into a web browser:' => 'Pour voir ou modifier cet utilisateur, merci de cliquer ou copier-coller l\'adresse suivante dans votre navigateur web:',

## default_templates/footer-email.mtml
	'Powered by Movable Type [_1]' => 'Powered by Movable Type [_1]',

## default_templates/archive_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to serve different content based upon what type of archive it is included. More info: [_1]' => 'Ceci est un groupe de widgets personnalisé qui est conditionné pour afficher un contenu différent basé sur le type d\'archives qui est inclue. Plus d\'infos : [_1]',
	'Current Category Monthly Archives' => 'Archives Mensuelles de la Catégorie Courante',
	'Category Archives' => 'Archives par Catégories',
	'Monthly Archives' => 'Archives mensuelles',

## default_templates/verify-subscribe.mtml
	'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Merci d\'avoir pour votre inscription aux mises à jours [_1]. Cliquez sur le lien ci-dessous pour confirmer cette inscription :',
	'If the link is not clickable, just copy and paste it into your browser.' => 'Si le lien n\'est pas cliquable, faites simplement un copier-coller dans votre navigateur.',

## default_templates/new-ping.mtml
	'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Un Trackback non-approuvé a été déposé sur votre blog [_1], pour la note #[_2] ([_3]). Vous devez approuver ce Trackback pour qu\'il apparaisse sur votre site.',
	'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Un Trackback non-approuvé a été déposé sur votre blog [_1], pour la catégorie #[_2] ([_3]). Vous devez approuver ce Trackback pour qu\'il apparaisse sur votre site.',
	'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Un nouveau TrackBack a été déposé sur votre blog [_1], pour la note #[_2] ([_3]).',
	'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'Un nouveau TrackBack a été déposé sur votre blog [_1], pour la catégorie #[_2] ([_3]).',
	'Excerpt' => 'Extrait',
	'URL' => 'URL',
	'Title' => 'Titre',
	'Blog' => 'Blog',
	'IP address' => 'Adresse IP',
	'Approve TrackBack' => 'Approuver le Trackback',
	'View TrackBack' => 'Voir le Trackback',
	'Report TrackBack as spam' => 'Notifier le Trackback comme spam',
	'Edit TrackBack' => 'Éditer les Trackbacks',

## default_templates/syndication.mtml
	'Subscribe to feed' => 'S\'abonner au flux',
	'Subscribe to this blog\'s feed' => 'S\'abonner au flux de ce blog',
	'Subscribe to a feed of all future entries tagged &ldquo;[_1]&ldquo;' => 'S\'abonner au flux de toutes les futurs notes tagguées &ldquo;[_1]&ldquo;',
	'Subscribe to a feed of all future entries matching &ldquo;[_1]&ldquo;' => 'S\'abonner au flux de toutes les futurs notes contenant &ldquo;[_1]&ldquo;',
	'Feed of results tagged &ldquo;[_1]&ldquo;' => 'Flux des résultats taggés &ldquo;[_1]&ldquo;',
	'Feed of results matching &ldquo;[_1]&ldquo;' => 'Flux des résultats pour &ldquo;[_1]&ldquo;',

## default_templates/comment_detail.mtml
	'[_1] replied to <a href="[_2]">comment from [_3]</a>' => '[_1] en réponse au <a href="[_2]">commentaire de [_3]</a>',

## default_templates/author_archive_list.mtml
	'Authors' => 'Auteurs',

## default_templates/current_category_monthly_archive_list.mtml
	'[_1]' => '[_1]',

## default_templates/recent_comments.mtml
	'<strong>[_1]:</strong> [_2] <a href="[_3]" title="full comment on: [_4]">read more</a>' => '<strong>[_1] :</strong> [_2] <a href="[_3]" title="commentaire complet sur : [_4]">lire la suite</a>',

## default_templates/technorati_search.mtml
	'Technorati' => 'Technorati',
	'<a href=\'http://www.technorati.com/\'>Technorati</a> search' => 'Recherche <a href=\'http://www.technorati.com/\'>Technorati</a> ',
	'this blog' => 'ce blog',
	'all blogs' => 'tous les blogs',
	'Search' => 'Rechercher',
	'Blogs that link here' => 'Blogs pointant ici',

## default_templates/monthly_archive_list.mtml
	'[_1] <a href="[_2]">Archives</a>' => '<a href="[_2]">Archives</a> [_1]',

## default_templates/category_entry_listing.mtml
	'[_1] Archives' => 'Archives [_1]',
	'Recently in <em>[_1]</em> Category' => 'Récemment dans la catégorie <em>[_1]</em>',
	'Main Index' => 'Index principal',

## default_templates/comment_throttle.mtml
	'If this was a mistake, you can unblock the IP address and allow the visitor to add it again by logging in to your Movable Type installation, going to Blog Config - IP Banning, and deleting the IP address [_1] from the list of banned addresses.' => 'Si c\'était une erreur, vous pouvez débloquer l\'adresse IP et autoriser le visiteur à nouveau en vous identifiant dans Movable Type, dans Configuration du Blog - Blocage IP, et en effaçant l\'adresse IP [_1] de la liste des adresses bannies.',
	'A visitor to your blog [_1] has automatically been banned by adding more than the allowed number of comments in the last [_2] seconds.' => 'Un visiteur de votre blog [_1] a été automatiquement banni après avoir publié une quantité de commentaires supérieure à la limite établie au cours des [_2] secondes.',
	'This has been done to prevent a malicious script from overwhelming your weblog with comments. The banned IP address is' => 'Cette opération est destinée à empêcher la publication automatisée de commentaires par des scripts. L\'adresse IP bannie est',

## default_templates/signin.mtml
	'Sign In' => 'Connexion',
	'You are signed in as ' => 'Vous êtes identifié en tant que ',
	'sign out' => 'déconnexion',
	'You do not have permission to sign in to this blog.' => 'Vous n\'avez pas l\'autorisation de vous identifier sur ce blog.',

## default_templates/new-comment.mtml
	'An unapproved comment has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => 'Un commentaire non approuvé a été envoyé sur votre blog [_1], pour la note #[_2] ([_3]). Vous devez l\'approuver pour qu\'il apparaisse sur votre blog.',
	'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Un nouveau commentaire a été publié sur votre blog [_1], au sujet de la note [_2] ([_3]). ',
	'Commenter name: [_1]' => 'Nom de l\'auteur de commentaires',
	'Commenter email address: [_1]' => 'Adresse email de l\'auteur de commentaires :  [_1]',
	'Commenter URL: [_1]' => 'URL de l\'auteur de commentaires : [_1]',
	'Commenter IP address: [_1]' => 'Adresse IP de l\'auteur de commentaires : [_1]',
	'Approve comment:' => 'Accepter le commentaire :',
	'View comment:' => 'Voir le commentaire :',
	'Edit comment:' => 'Éditer le commentaire :',
	'Report comment as spam:' => 'Marquer le commentaire comme étant du spam :',

## default_templates/pages_list.mtml
	'Pages' => 'Pages',

## default_templates/about_this_page.mtml
	'About this Entry' => 'À propos de cette note',
	'About this Archive' => 'À propos de cette archive',
	'About Archives' => 'À propos des archives',
	'This page contains links to all the archived content.' => 'Cette page contient des liens vers toutes les archives.',
	'This page contains a single entry by [_1] published on <em>[_2]</em>.' => 'Cette page contient une unique note de [_1] publiée le <em>[_2]</em>.',
	'<a href="[_1]">[_2]</a> was the previous entry in this blog.' => '<a href="[_1]">[_2]</a> est la note précédente de ce blog.',
	'<a href="[_1]">[_2]</a> is the next entry in this blog.' => '<a href="[_1]">[_2]</a> est la note suivante de ce blog.',
	'This page is an archive of entries in the <strong>[_1]</strong> category from <strong>[_2]</strong>.' => 'Cette page est une archive des notes dans la catégorie <strong>[_1]</strong> de <strong>[_2]</strong>.',
	'<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> est l\'archive précédente.',
	'<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> est l\'archive suivante.',
	'This page is an archive of recent entries in the <strong>[_1]</strong> category.' => 'Cette page est une archive des notes récentes dans la catégorie <strong>[_1]</strong>.',
	'<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> est la catégorie précédente.',
	'<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> est la catégorie suivante.',
	'This page is an archive of recent entries written by <strong>[_1]</strong> in <strong>[_2]</strong>.' => 'Cette page est une archive des notes récentes écrites par <strong>[_1]</strong> dans <strong>[_2]</strong>.',
	'This page is an archive of recent entries written by <strong>[_1]</strong>.' => 'Cette page est une archive des notes récentes écrites par <strong>[_1]</strong>.',
	'This page is an archive of entries from <strong>[_2]</strong> listed from newest to oldest.' => 'Cette page est une archive des notes de <strong>[_2]</strong> listées de la plus récente à la plus ancienne.',
	'Find recent content on the <a href="[_1]">main index</a>.' => 'Retrouvez le contenu récent sur <a href="[_1]">l\'index principal</a>.',
	'Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.' => 'Retrouvez le contenu récent sur <a href="[_1]">l\'index principal</a> ou allez dans les <a href="[_2]">archives</a> pour retrouver tout le contenu.',

## default_templates/entry.mtml

## default_templates/recover-password.mtml
	'A request has been made to change your password in Movable Type. To complete this process click on the link below to select a new password.' => 'Une requête a été faite pour changer votre mot de passe dans Movable Type. Pour terminer cliquez sur le lien ci-dessous pour choisir un nouveau mot de passe.',
	'If you did not request this change, you can safely ignore this email.' => 'Si vous n\'avez pas demandé ce changement, vous pouvez ignorer cet email.',

## default_templates/javascript.mtml
	'moments ago' => 'il y a quelques instants',
	'[quant,_1,hour,hours] ago' => 'il y a [quant,_1,heure,heures]',
	'[quant,_1,minute,minutes] ago' => 'il y a [quant,_1,minute,minutes]',
	'[quant,_1,day,days] ago' => 'il y a [quant,_1,jour,jours]',
	'Edit' => 'Editer',
	'Your session has expired. Please sign in again to comment.' => 'Votre session a expiré. Veuillez vous identifier à nouveau pour commenter.',
	'Signing in...' => 'Identification ...',
	'You do not have permission to comment on this blog. ([_1]sign out[_2])' => 'Vous n\'avez pas la permission de commenter sur ce blog. ([_1]déconnexion[_2])',
	'Thanks for signing in, __NAME__. ([_1]sign out[_2])' => 'Merci de vous être identifié(e) en tant que __NAME__. ([_1]fermer la session[_2])',
	'[_1]Sign in[_2] to comment.' => '[_1]Identifiez-vous[_2] pour commenter.',
	'[_1]Sign in[_2] to comment, or comment anonymously.' => '[_1]Identifiez-vous[_2] pour commenter, ou laissez un commentaire anonyme.',
	'Replying to <a href="[_1]" onclick="[_2]">comment from [_3]</a>' => 'En réponse au <a href="[_1]" onclick="[_2]">commentaire de [_3]</a>',

## default_templates/archive_index.mtml
	'Author Archives' => 'Archives par auteurs',
	'Category Monthly Archives' => 'Archives par catégories et mois',
	'Author Monthly Archives' => 'Archives par auteurs et mois',

## default_templates/trackbacks.mtml
	'TrackBack URL: [_1]' => 'URL de Trackback : [_1]',
	'<a href="[_1]">[_2]</a> from [_3] on <a href="[_4]">[_5]</a>' => '<a href="[_1]">[_2]</a> depuis [_3] sur <a href="[_4]">[_5]</a>',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">Lire la suite</a>',

## default_templates/calendar.mtml
	'Monthly calendar with links to daily posts' => 'Calendrier mensuel avec des liens vers les notes du jour',
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

## default_templates/recent_entries.mtml

## default_templates/sidebar.mtml
	'2-column layout - Sidebar' => 'Mise en page à 2 colonnes - Barre latérale',
	'3-column layout - Primary Sidebar' => 'Mise en page à 3 colonnes - Première barre latérale',
	'3-column layout - Secondary Sidebar' => 'Mise en page à 3 colonnes - Seconde barre latérale',

## default_templates/openid.mtml
	'[_1] accepted here' => '[_1] est accepté',
	'http://www.sixapart.com/labs/openid/' => 'http://www.sixapart.com/labs/openid/',
	'Learn more about OpenID' => 'Apprenez-en plus à propos d\'OpenID',

## default_templates/date_based_author_archives.mtml
	'Author Yearly Archives' => 'Archives Annuelles par Auteurs',
	'Author Weekly Archives' => 'Archives Hebdomadaires par Auteurs',
	'Author Daily Archives' => 'Archives Quotidiennes par Auteurs',

## default_templates/banner_footer.mtml
	'_POWERED_BY' => 'Powered by <a href="http://www.movabletype.org/"><$MTProductName$></a>',
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Ce blog possède une licence <a href="[_1]">Creative Commons</a>.',

## default_templates/comments.mtml
	'Older Comments' => 'Anciens commentaires',
	'Newer Comments' => 'Nouveaux commentaires',
	'Comment Detail' => 'Détail du Commentaire',
	'The data is modified by the paginate script' => 'Les données sont modifiés par le script de pagination',
	'Leave a comment' => 'Laisser un commentaire',
	'Name' => 'Nom',
	'Email Address' => 'Adresse e-mail',
	'Remember personal info?' => 'Mémoriser mes infos personnelles ?',
	'(You may use HTML tags for style)' => '(Vous pouvez utiliser des balises HTML pour le style)',
	'Preview' => 'Aperçu',
	'Submit' => 'Envoyer',

## default_templates/search_results.mtml
	'Search Results' => 'Résultats de recherche',
	'Results matching &ldquo;[_1]&rdquo;' => 'Résultats pour &ldquo;[_1]&rdquo;',
	'Results tagged &ldquo;[_1]&rdquo;' => 'Résultats tagués &ldquo;[_1]&rdquo;',
	'Previous' => 'Précédent',
	'Next' => 'Suivant',
	'No results found for &ldquo;[_1]&rdquo;.' => 'Aucun résultat pour &ldquo;[_1]&rdquo;.',
	'Instructions' => 'Instructions',
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Par défaut, ce moteur va rechercher tous les mots, quelque soit leur ordre. Pour lancer une recherche sur une phrase exacte, insérez la phrase entre des apostrophes : ',
	'movable type' => 'movable type',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'Le moteur de recherche supporte aussi les mot-clés AND, OR, NOT pour spécifier des expressions booléennes :',
	'personal OR publishing' => 'personnel OR publication',
	'publishing NOT personal' => 'publication NOT personnel',

## default_templates/comment_listing.mtml

## default_templates/date_based_category_archives.mtml
	'Category Yearly Archives' => 'Archives Annuelles par Catégories',
	'Category Weekly Archives' => 'Archives Hebdomadaires par Catégories',
	'Category Daily Archives' => 'Archives Quotidiennes par Catégories',

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'Page Non Trouvée',

## default_templates/creative_commons.mtml

## default_templates/powered_by.mtml
	'_MTCOM_URL' => 'http://www.movabletype.com/',

## default_templates/comment_preview.mtml
	'Previewing your Comment' => 'Aperçu de votre commentaire',
	'Replying to comment from [_1]' => 'En réponse au commentaire de [_1]',
	'Cancel' => 'Annuler',

## default_templates/monthly_entry_listing.mtml

## default_templates/search.mtml
	'Case sensitive' => 'Sensible à la casse',
	'Regex search' => 'Expression rationnelle',

## default_templates/commenter_confirm.mtml
	'Thank you registering for an account to comment on [_1].' => 'Merci de vous être enregistré pour commenter sur [_1].',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to comment on [_1].' => 'Pour votre propre sécurité et pour éviter les fraudes, nous vous demandons de confirmer votre compte et votre adresse email avant de continuer. Vous pourrez ensuite immédiatement commenter sur [_1].',
	'To confirm your account, please click on or cut and paste the following URL into a web browser:' => 'Pour confirmer votre compte, cliquez ou copiez-collez l\'adresse suivante dans un navigateur web:',
	'If you did not make this request, or you don\'t want to register for an account to comment on [_1], then no further action is required.' => 'Si vous n\'êtes pas à l\'origine de cette demande, ou si vous ne souhaitez pas vous enregistrer pour commenter sur [_1], alors aucune action n\'est nécessaire.',
	'Thank you very much for your understanding.' => 'Merci beaucoup pour votre compréhension.',
	'Sincerely,' => 'Cordialement,',

## lib/MT/Asset/Video.pm
	'Videos' => 'Vidéos',

## lib/MT/Asset/Audio.pm

## lib/MT/Asset/Image.pm
	'Images' => 'Images',
	'Actual Dimensions' => 'Dimensions réelles',
	'[_1] x [_2] pixels' => '[_1] x [_2] pixels',
	'Error cropping image: [_1]' => 'Erreur de rognage de l\'image: [_1]',
	'Error scaling image: [_1]' => 'Erreur lors du redimentionement de l\'image: [_1]',
	'Error converting image: [_1]' => 'Erreur pendant la conversion de l\'image: [_1]',
	'Error creating thumbnail file: [_1]' => 'Erreur lors de la création de la vignette: [_1]',
	'%f-thumb-%wx%h-%i%x' => '%f-thumb-%wx%h-%i%x',
	'Can\'t load image #[_1]' => 'Impossible de charger l\'image #[_1]',
	'View image' => 'Voir l\'image',
	'Permission denied setting image defaults for blog #[_1]' => 'Autorisation interdite de configurer les paramètres par défaut des images pour le blog #[_1]',
	'Thumbnail image for [_1]' => 'Miniature de l\'image pour [_1]',
	'Invalid basename \'[_1]\'' => 'Nom de base invalide \'[_1]\'',
	'Error writing to \'[_1]\': [_2]' => 'Erreur \'[_1]\' lors de l\'écriture de : [_2]',
	'Popup Page for [_1]' => 'Fenêtre popup pour [_1]',

## lib/MT/Upgrade/v1.pm
	'Creating template maps...' => 'Création des tables de correspondances de gabarits...',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'Lien du gabarit [_1] vers [_2] ([_3]).',
	'Mapping template ID [_1] to [_2].' => 'Lien du gabarit [_1] vers [_2].',
	'Error saving record: [_1].' => 'Erreur de l\'enregistrement des informations : [_1].',
	'Creating entry category placements...' => 'Création des placements des catégories des notes...',

## lib/MT/Upgrade/v2.pm
	'Updating category placements...' => 'Modification des placements de catégories...',
	'Assigning comment/moderation settings...' => 'Mise en place des paramètres commentaire/modération ...',

## lib/MT/Upgrade/Core.pm
	'Creating initial website and user records...' => 'Création des enregistrements sites web et utilisateur initiaux...',
	'Error creating role record: [_1].' => 'Erreur lors de la création du rôle d\'enregistrement : [_1]',
	'First Website' => 'Premier Site Web',
	'Creating new template: \'[_1]\'.' => 'Création d\'un nouveau gabarit: \'[_1]\'.',
	'Mapping templates to blog archive types...' => 'Mapping des gabarits vers les archives des blogs...',
	'Assigning custom dynamic template settings...' => 'Attribution des paramètres spécifiques de gabarits dynamique...',
	'Assigning user types...' => 'Attribution des types d\'utilisateurs...',
	'Assigning category parent fields...' => 'Attribution des champs parents de la catégorie...',
	'Assigning template build dynamic settings...' => 'Attribution des paramètres de construction dynamique du gabarit...',
	'Assigning visible status for comments...' => 'Attribution du statut visible pour les commentaires...',
	'Assigning visible status for TrackBacks...' => 'Attribution du statut visible des trackbacks...',

## lib/MT/Upgrade/v3.pm
	'Custom ([_1])' => '([_1]) personnalisé ',
	'This role was generated by Movable Type upon upgrade.' => 'Ce rôle a été généré par Movable Type lors d\'une mise à jour.',
	'Removing Dynamic Site Bootstrapper index template...' => 'Suppression du gabarit index Dynamic Site Bootstrapper',
	'Creating configuration record.' => 'Création des infos de configuration.',
	'Setting blog basename limits...' => 'Spécification des limites des noms de bases du blog...',
	'Setting default blog file extension...' => 'Ajout de l\'extension de fichier par défaut du blog...',
	'Updating comment status flags...' => 'Modification des statuts des commentaires...',
	'Updating commenter records...' => 'Modification des données des auteurs de commentaires...',
	'Assigning blog administration permissions...' => 'Ajout des autorisations d\'administration du blog...',
	'Setting blog allow pings status...' => 'Mise en place du statut d\'autorisation des pings...',
	'Updating blog comment email requirements...' => 'Mise à jour des prérequis des emails pour les commentaires du blog...',
	'Assigning entry basenames for old entries...' => 'Ajout des racines des notes pour les anciennes notes...',
	'Updating user web services passwords...' => 'Mise à jour des mots de passe des services web d\'utilisateur...',
	'Updating blog old archive link status...' => 'Modification de l\'ancien statut d\'archive du blog...',
	'Updating entry week numbers...' => 'Mise à jour des numéros des semaines de la note...',
	'Updating user permissions for editing tags...' => 'Modification des autorisations des utilisateurs pour modifier les balises...',
	'Setting new entry defaults for blogs...' => 'Réglage des valeurs par défaut des nouvelles notes pour les blogs...',
	'Migrating any "tag" categories to new tags...' => 'Migration des catégories de "tag" vers de nouveaux tags...',
	'Assigning basename for categories...' => 'Attribution de racines aux catégories...',
	'Assigning user status...' => 'Attribution du statut utilisateur...',
	'Migrating permissions to roles...' => 'Migration des autorisations vers les rôles...',

## lib/MT/Upgrade/v4.pm
	'Comment Posted' => 'Commentaire envoyé',
	'Your comment has been posted!' => 'Votre commentaire a été envoyé !',
	'Comment Pending' => 'Commentaires en attente',
	'Your comment submission failed for the following reasons:' => 'L\'envoi de votre commentaire a échoué pour les raisons suivantes :',
	'[_1]: [_2]' => '[_1]: [_2]',
	'Migrating permission records to new structure...' => 'Migration des données d\'autorisation vers une nouvelle structure...',
	'Migrating role records to new structure...' => 'Migration des données de rôle vers la nouvelle structure...',
	'Migrating system level permissions to new structure...' => 'Migration des autorisations pour tout le système vers la nouvelle structure...',
	'Updating system search template records...' => 'Mise à jour des données du gabarit de recherche du système...',
	'Renaming PHP plugin file names...' => 'Renommage des noms de fichier des plugins php...',
	'Error renaming PHP files. Please check the Activity Log.' => 'Erreur pendant le renommage des fichiers PHP. Merci de vérifier le journal (logs).',
	'Cannot rename in [_1]: [_2].' => 'Impossible de renommer dans [_1]: [_2].',
	'Migrating Nofollow plugin settings...' => 'Migration des paramètres du plugin Nofollow...',
	'Comment Response' => 'Réponse au commentaire',
	'Removing unnecessary indexes...' => 'Suppression des index non nécessaires...',
	'Moving metadata storage for categories...' => 'Déplacement du stockage des métadonnées pour les catégories en cours...',
	'Upgrading metadata storage for [_1]' => 'Mise à jour du stockage des métadonnées pour [_1]',
	'Error loading class: [_1].' => 'Erreur de chargement de classe : [_1].',
	'Assigning entry comment and TrackBack counts...' => 'Attribution des nombres de commentaires et trackbacks...',
	'Updating password recover email template...' => 'Template de réinitialisation du mot de passe en cours de mise à jour...',
	'Assigning junk status for comments...' => 'Attribution du statut spam pour les commentaires...',
	'Assigning junk status for TrackBacks...' => 'Attribution du statut spam pour les trackbacks...',
	'Populating authored and published dates for entries...' => 'Mise en place des dates de création et de publication des notes...',
	'Updating widget template records...' => 'Mise à jour des données du gabarit de widget...',
	'Classifying category records...' => 'Classement des données des catégories...',
	'Classifying entry records...' => 'Classement des données des notes...',
	'Merging comment system templates...' => 'Assemblage des gabarits du système de commentaire...',
	'Populating default file template for templatemaps...' => 'Mise en place du fichier gabarit par défaut pour les tables de correspondances de gabarits...',
	'Removing unused template maps...' => 'Suppression des tables de correspondances de gabarits non-utilisés...',
	'Assigning user authentication type...' => 'Attribution du type d\'authentification utilisateur...',
	'Adding new feature widget to dashboard...' => 'Ajout du nouveau widget au tableau de bord...',
	'Moving OpenID usernames to external_id fields...' => 'Déplacement des identifiants OpenID vers les champs external_id...',
	'Assigning blog template set...' => 'Attribution du groupe de gabarits de blogs...',
	'Assigning blog page layout...' => 'Attribution de la mise en page du blog...',
	'Assigning author basename...' => 'Attribution du nom de base de l\'auteur...',
	'Assigning embedded flag to asset placements...' => 'Attribution des drapeaux embarqués vers la gestion d\'éléments...',
	'Updating template build types...' => 'Mise à jour des types de construction de gabarits...',
	'Replacing file formats to use CategoryLabel tag...' => 'Remplacement des formats de fichiers pour utiliser le tag CategoryLabel...',

## lib/MT/Upgrade/v5.pm
	'Populating generic website for current blogs...' => 'Génération d\'un site web générique pour les blogs actuels...',
	'Generic Website' => 'Site Web Générique',
	'Migrating [_1]([_2]).' => 'Migration [_1] ([_2])',
	'Granting new role to system administrator...' => 'Élévation du nouveau rôle vers administrateur système...',
	'Updating existing role name...' => 'Mise à jour du nom de rôle existant...',
	'_WEBMASTER_MT4' => 'Webmaster',
	'Webmaster (MT4)' => 'Webmaster (MT4)',
	'Populating new role for website...' => 'Génération du nouveau rôle pour le site web...',
	'Website Administrator' => 'Administrateur du Site Web',
	'Can administer the website.' => 'Peut administrer le site web.',
	'Webmaster' => 'Webmaster',
	'Can manage pages, Upload files and publish blog templates.' => 'Peut gérer les pages, télécharger des fichiers et publiuer les gabarits du blog.',
	'Designer' => 'Designer',
	'Designer (MT4)' => 'Designer (MT4)',
	'Populating new role for theme...' => 'Génération du nouveau rôle pour le thème...',
	'Can edit, manage and publish blog templates and themes.' => 'Peut modifier, gérer et publier les gabarits et thèmes du blog.',
	'Assigning new system privilege for system administrator...' => 'Assignation des nouveaux privilèges système pour l\'administrateur système...',
	'Assigning to  [_1]...' => 'Assignation pour [_1]...',
	'Migrating mtview.php to MT5 style...' => 'Migration de mtview.php vers le style MT5...',
	'Migrating DefaultSiteURL/DefaultSiteRoot to website...' => 'Migration de DefaultSiteURL/DefaultSiteRoot vers site web...',
	'New user\'s website' => 'Site web du nouvel utilisateur',
	'Migrating existing [quant,_1,blog,blogs] into websites and its children...' => 'Migration des [quant,_1,blog,blogs] existants vers des sites web et leurs enfants...',
	'Error loading role: [_1].' => 'Erreur lors du chargement d\'un rôle : [_1].',
	'New WebSite [_1]' => 'Nouveau site web [_1]',
	'An error occured during generating a website upon upgrade: [_1]' => 'Une erreur est survenue lors de la génération d\'un site web avant la mise à jour : [_1]',
	'Generated a website [_1]' => 'A généré un site web [_1]',
	'An error occured during migrating a blog\'s site_url: [_1]' => 'Une erreur est survenue lors de la migration de l\'URL d\'un blog : [_1]',
	'Moved blog [_1] ([_2]) under website [_3]' => 'A déplacé le blog [_1] ([_2]) sous le site web  [_3]',
	'Merging dashboard settings...' => 'Fusion des paramètres du tableau de bord...',
	'Classifying blogs...' => 'Classification des blogs...',
	'Rebuilding permissions...' => 'Republication des permissions...',

## lib/MT/Util/Archive/Tgz.pm
	'Type must be tgz.' => 'Le type doit être tgz.',
	'Could not read from filehandle.' => 'Impossible de lire le fichier.',
	'File [_1] is not a tgz file.' => 'Le fichier [_1] n\'est pas un fichier tgz.',
	'File [_1] exists; could not overwrite.' => 'Le fichier [_1] existe; impossible de l\'écraser.',
	'Can\'t extract from the object' => 'Impossible d\'extraire l\'objet',
	'Can\'t write to the object' => 'Impossible d\'écrire l\'objet',
	'Both data and file name must be specified.' => 'Les données et le fichier doivent être spécifiés.',

## lib/MT/Util/Archive/Zip.pm
	'Type must be zip' => 'Le type doit être zip',
	'File [_1] is not a zip file.' => 'Le fichier [_1] n\'est pas un fichier zip.',

## lib/MT/Util/YAML/Syck.pm
	'File not found: [_1]' => 'Fichier non trouvé : [_1]',

## lib/MT/Util/YAML/Tiny.pm

## lib/MT/Util/Archive.pm
	'Type must be specified' => 'Le type doit être spécifié',
	'Registry could not be loaded' => 'Le registre n\'a pu être chargé',

## lib/MT/Util/Captcha.pm
	'Movable Type default CAPTCHA provider requires Image::Magick.' => 'Le fournisseur de CAPTCHA par défaut de Movable Type nécessite Image::Magick.',
	'You need to configure CaptchaSourceImageBase.' => 'Vous devez configurer CaptchaSourceImagebase.',
	'Image creation failed.' => 'Création de l\'image échouée.',
	'Image error: [_1]' => 'Erreur image : [_1]',

## lib/MT/ArchiveType/Yearly.pm
	'YEARLY_ADV' => 'annuelles',
	'yyyy/index.html' => 'aaaa/index.html',

## lib/MT/ArchiveType/Page.pm
	'PAGE_ADV' => 'par pages',
	'folder-path/page-basename.html' => 'chemin-repertoire/nomdebase-page.html',
	'folder-path/page-basename/index.html' => 'chemin-repertoire/nomdebase-page/index.html',
	'folder_path/page_basename.html' => 'chemin_repertoire/nomdebase_page.html',
	'folder_path/page_basename/index.html' => 'chemin_repertoire/nomdebase_page/index.html',

## lib/MT/ArchiveType/Category.pm
	'CATEGORY_ADV' => 'par catégories',
	'category/sub-category/index.html' => 'categorie/sous-categorie/index.html',
	'category/sub_category/index.html' => 'categorie/sous_categorie/index.html',

## lib/MT/ArchiveType/AuthorMonthly.pm
	'AUTHOR-MONTHLY_ADV' => 'par auteurs et semaines',
	'author/author-display-name/yyyy/mm/index.html' => 'auteur/auteur-nom-affichage/aaaa/mm/index.html',
	'author/author_display_name/yyyy/mm/index.html' => 'auteur/auteur_nom_affichage/aaaa/mm/index.html',

## lib/MT/ArchiveType/AuthorWeekly.pm
	'AUTHOR-WEEKLY_ADV' => 'par auteurs et années',
	'author/author-display-name/yyyy/mm/day-week/index.html' => 'auteur/auteur-nom-affichage/aaaa/mm/jour-semaine/index.html',
	'author/author_display_name/yyyy/mm/day-week/index.html' => 'auteur/auteur_nom_affichage/aaaa/mm/jour-semaine/index.html',

## lib/MT/ArchiveType/AuthorDaily.pm
	'AUTHOR-DAILY_ADV' => 'par auteurs et jours',
	'author/author-display-name/yyyy/mm/dd/index.html' => 'auteur/afficher-nom-auteur/aaaa/mm/jj/index.html',
	'author/author_display_name/yyyy/mm/dd/index.html' => 'auteur/afficher_nom_auteur/aaaa/mm/jj/index.html',

## lib/MT/ArchiveType/Individual.pm
	'INDIVIDUAL_ADV' => 'par notes',
	'yyyy/mm/entry-basename.html' => 'aaaa/mm/nomdebase-note.html',
	'yyyy/mm/entry_basename.html' => 'aaaa/mm/nomdebase_note.html',
	'yyyy/mm/entry-basename/index.html' => 'aaaa/mm/nomdebase-note/index.html',
	'yyyy/mm/entry_basename/index.html' => 'aaaa/mm/nomdebase_note/index.html',
	'yyyy/mm/dd/entry-basename.html' => 'aaaa/mm/jj/nomdebase-note.html',
	'yyyy/mm/dd/entry_basename.html' => 'aaaa/mm/jj/nomdebase_note.html',
	'yyyy/mm/dd/entry-basename/index.html' => 'aaaa/mm/jj/nomdebase-note/index.html',
	'yyyy/mm/dd/entry_basename/index.html' => 'aaaa/mm/jj/nomdebase_note/index.html',
	'category/sub-category/entry-basename.html' => 'categorie/sous-categorie/nomdebase-note.html',
	'category/sub-category/entry-basename/index.html' => 'categorie/sous-categorie/nomdebase-note/index.html',
	'category/sub_category/entry_basename.html' => 'categorie/sous_categorie/nomdebase_note.html',
	'category/sub_category/entry_basename/index.html' => 'categorie/sous_categorie/nomdebase_note/index.html',

## lib/MT/ArchiveType/CategoryMonthly.pm
	'CATEGORY-MONTHLY_ADV' => 'par catégories et mois',
	'category/sub-category/yyyy/mm/index.html' => 'categorie/sous-categorie/aaaa/mm/index.html',
	'category/sub_category/yyyy/mm/index.html' => 'categorie/sous_categorie/aaaa/mm/index.html',

## lib/MT/ArchiveType/AuthorYearly.pm
	'AUTHOR-YEARLY_ADV' => 'par auteurs et années',
	'author/author-display-name/yyyy/index.html' => 'auteur/auteur-nom-affichage/aaaa/index.html',
	'author/author_display_name/yyyy/index.html' => 'auteur/auteur_nom_affichage/aaaa/index.html',

## lib/MT/ArchiveType/Monthly.pm
	'MONTHLY_ADV' => 'mensuelles',
	'yyyy/mm/index.html' => 'aaaa/mm/index.html',

## lib/MT/ArchiveType/CategoryWeekly.pm
	'CATEGORY-WEEKLY_ADV' => 'par catégories et semaines',
	'category/sub-category/yyyy/mm/day-week/index.html' => 'categorie/sous-categorie/aaaa/mm/jour-semaine/index.html',
	'category/sub_category/yyyy/mm/day-week/index.html' => 'categorie/sous_categorie/aaaa/mm/jour-semaine/index.html',

## lib/MT/ArchiveType/Weekly.pm
	'WEEKLY_ADV' => 'hebdomadaires',
	'yyyy/mm/day-week/index.html' => 'aaaa/mm/jour-semaine/index.html',

## lib/MT/ArchiveType/CategoryDaily.pm
	'CATEGORY-DAILY_ADV' => 'par catégories et jours',
	'category/sub-category/yyyy/mm/dd/index.html' => 'categorie/sous-categorie/aaaa/mm/jj/index.html',
	'category/sub_category/yyyy/mm/dd/index.html' => 'categorie/sous_categorie/aaa/mm/jj/index.html',

## lib/MT/ArchiveType/Daily.pm
	'DAILY_ADV' => 'journalières',
	'yyyy/mm/dd/index.html' => 'aaaa/mm/jj/index.html',

## lib/MT/ArchiveType/Author.pm
	'AUTHOR_ADV' => 'par auteurs',
	'author/author-display-name/index.html' => 'auteur/auteur-nom-affichage/index.html',
	'author/author_display_name/index.html' => 'auteur/auteur_nom_affichage/index.html',

## lib/MT/ArchiveType/CategoryYearly.pm
	'CATEGORY-YEARLY_ADV' => 'par catégories et années',
	'category/sub-category/yyyy/index.html' => 'categorie/sous-categorie/aaaa/index.html',
	'category/sub_category/yyyy/index.html' => 'categorie/sous_categorie/aaaa/index.html',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: [_2][_3] de la règle [_4][_5]',
	'[_1]: [_2][_3] from test [_4]' => '[_1]: [_2][_3] du test [_4]',

## lib/MT/Auth/TypeKey.pm
	'Sign in requires a secure signature.' => 'L\'identification nécessite une signature sécurisée.',
	'The sign-in validation failed.' => 'La validation de l\'enregistrement a échoué.',
	'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Les auteurs de commentaires de ce blog doivent donner une adresse email. Si vous souhaitez le faire il faut vous enregistrer à nouveau et donner l\'autorisation au système d\'identification de récupérer votre adresse email',
	'Couldn\'t save the session' => 'Impossible de sauvegarder la session',
	'Couldn\'t get public key from url provided' => 'Impossible d\'avoir une clef publique',
	'No public key could be found to validate registration.' => 'Aucune clé publique n\'a été trouvée pour valider l\'inscription.',
	'TypePad signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'La vérification de signature TypePad a retourné [_1] en [_2] secondes en vérifiant [_3] avec [_4]',
	'The TypePad signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'La signature TypePad a expiré (de [_1] secondes). Veuillez vérifier que l\'horloge de votre serveur est correctement réglée.',

## lib/MT/Auth/OpenID.pm
	'Could not load Net::OpenID::Consumer.' => 'Impossible de charger Net::OpenID::Consumer.',
	'The address entered does not appear to be an OpenID' => 'L\'adresse entrée ne semble pas être une adresse OpenID',
	'The text entered does not appear to be a web address' => 'L\'adresse entrée ne semble pas être une adresse de type URL',
	'Unable to connect to [_1]: [_2]' => 'Impossible de se connecter à [_1] : [_2]',
	'Could not verify the OpenID provided: [_1]' => 'La vérification de l\'OpenID entré a échoué : [_1]',

## lib/MT/Auth/MT.pm
	'Passwords do not match.' => 'Les mots de passe ne sont pas identiques.',
	'Failed to verify current password.' => 'Erreur lors de la vérification du mot de passe.',

## lib/MT/TheSchwartz/Error.pm
	'Job Error' => 'Erreur de tâche',

## lib/MT/TheSchwartz/FuncMap.pm
	'Job Function' => 'Fonction Tâche',

## lib/MT/TheSchwartz/Job.pm
	'Job' => 'Tâche',

## lib/MT/TheSchwartz/ExitStatus.pm
	'Job Exit Status' => 'Statut de fin de tâche',

## lib/MT/L10N/es.pm
	'Sin tÃ­tulo' => 'Sin tÃ­tulo',

## lib/MT/ObjectDriver/Driver/DBD/SQLite.pm
	'Can\'t open \'[_1]\': [_2]' => 'Impossible d\'ouvrir \'[_1]\' : [_2]',

## lib/MT/CMS/Search.pm
	'No [_1] were found that match the given criteria.' => 'Aucun [_1] n\'a été trouvé correspondant aux critères fournis.',
	'No permissions' => 'Aucun droit',
	'Entry Body' => 'Corps de la note',
	'Extended Entry' => 'Suite de la note',
	'Keywords' => 'Mots-clés',
	'Basename' => 'Nom de base',
	'Comment Text' => 'Texte du commentaire',
	'IP Address' => 'Adresse IP',
	'Source URL' => 'URL Source',
	'Blog Name' => 'Nom du blog',
	'Page Body' => 'Corps de la page',
	'Extended Page' => 'Page étendue',
	'Template Name' => 'Nom du gabarit',
	'Text' => 'Texte',
	'Linked Filename' => 'Lien du fichier lié',
	'Output Filename' => 'Nom du fichier de sortie',
	'Filename' => 'Nom de fichier',
	'Description' => 'Description',
	'Label' => 'Etiquette',
	'Log Message' => 'Message du journal',
	'Username' => 'Nom d\'utilisateur',
	'Display Name' => 'Nom à afficher',
	'Site URL' => 'URL du site',
	'Site Root' => 'Site Racine',
	'Search & Replace' => 'Rechercher et Remplacer',
	'Invalid date(s) specified for date range.' => 'Date(s) incorrecte(s) pour la sélection de calendrier.',
	'Permission denied.' => 'Autorisation refusée.',
	'Error in search expression: [_1]' => 'Erreur dans la recherche de l expression : [_1]',
	'Saving object failed: [_2]' => 'La sauvegarde des objets a échoué : [_2]',
	'Entries' => 'Notes',
	'TrackBacks' => 'Trackbacks',
	'Templates' => 'Gabarits',
	'Assets' => 'Éléments',
	'Activity Log' => 'Journal (logs)',
	'Users' => 'Utilisateurs',
	'Blogs' => 'Blogs',
	'Websites' => 'Sites Web',

## lib/MT/CMS/RptLog.pm
	'RPT Log' => 'Journal RPT',
	'System RPT Feed' => 'Flux RPT du système',

## lib/MT/CMS/Import.pm
	'Can\'t load blog #[_1].' => 'Impossible de charger le blog #[_1].',
	'Import/Export' => 'Importer/Exporter',
	'Load of blog \'[_1]\' failed: [_2]' => 'Le chargement du blog \'[_1]\' a échoué : [_2]',
	'You do not have import permission' => 'Vous n\'avez pas le droit d\'importer',
	'You do not have permission to create users' => 'Vous n\'avez pas l\'autorisation de créer des utilisateurs',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'Vous devez fournir un mot de passe si vous allez créer de nouveaux utilisateurs pour chaque utilisateur listé dans votre blog.',
	'Importer type [_1] was not found.' => 'Type d\'importeur [_1] non trouvé.',

## lib/MT/CMS/Folder.pm
	'The folder \'[_1]\' conflicts with another folder. Folders with the same parent must have unique basenames.' => 'Le répertoire \'[_1]\' est en conflit avec un autre répertoire. Les répertoires qui ont le même répertoire parent doivent avoir un nom de base unique.',
	'Folder \'[_1]\' created by \'[_2]\'' => 'Répertoire \'[_1]\' créé par \'[_2]\'',
	'The name \'[_1]\' is too long!' => 'Le nom \'[_1]\' est trop long.',
	'Folder \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Répertoire \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',

## lib/MT/CMS/Tag.pm
	'Invalid type' => 'Type incorrect',
	'New name of the tag must be specified.' => 'Le nouveau nom de ce tag doit être spécifié.',
	'No such tag' => 'Pas de tag de ce type',
	'Invalid request.' => 'Demande invalide.',
	'Error saving entry: [_1]' => 'Erreur d\'enregistrement de la note: [_1]',
	'Error saving file: [_1]' => 'Erreur en sauvegardant le fichier: [_1]',
	'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Tag \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',

## lib/MT/CMS/Template.pm
	'index' => 'index',
	'archive' => 'archive',
	'module' => 'module',
	'widget' => 'widget',
	'email' => 'Adresse email',
	'backup' => 'sauvegarder',
	'system' => 'système',
	'One or more errors were found in this template.' => 'Une erreur ou plus ont été trouvées dans ce gabarit.',
	'One or more errors were found in included template module ([_1]).' => 'Une erreur ou plus ont été trouvées dans un module de gabarit inclu ([_1]).', # Translate - New
	'Create template requires type' => 'La création de gabarits nécessite un type',
	'Archive' => 'Archive',
	'Entry or Page' => 'Note ou Page',
	'New Template' => 'Nouveau gabarit',
	'Index Templates' => 'Gabarits d\'index',
	'Archive Templates' => 'Gabarits d\'archives',
	'Template Modules' => 'Modules de gabarits',
	'System Templates' => 'Gabarits système',
	'Email Templates' => 'Gabarits email',
	'Template Backups' => 'Sauvegardes de gabarit',
	'Can\'t locate host template to preview module/widget.' => 'Impossible de localiser le gabarit du serveur pour prévisualiser de module/widget.',
	'Publish error: [_1]' => 'Erreur de publication: [_1]',
	'Unable to create preview file in this location: [_1]' => 'Impossible de créer le fichier de pré-visualisation à cet endroit : [_1]',
	'Lorem ipsum' => 'Lorem ipsum',
	'LOREM_IPSUM_TEXT' => 'LOREM_IPSUM_TEXT',
	'LORE_IPSUM_TEXT_MORE' => 'LORE_IPSUM_TEXT_MORE',
	'sample, entry, preview' => 'extrait, note, prévisualisation',
	'Populating blog with default templates failed: [_1]' => 'L\'activation sur le blog des gabarits par défaut a échoué : [_1]',
	'Setting up mappings failed: [_1]' => 'La mise en oeuvre des mappings a échoué : [_1]',
	'Saving map failed: [_1]' => 'Échec lors du rattachement: [_1]',
	'You should not be able to enter 0 as the time.' => 'Vous ne devriez pas pouvoir saisir 0 comme heure.',
	'You must select at least one event checkbox.' => 'Vous devez sélectionner au moins une case à cocher événement.',
	'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Gabarit \'[_1]\' (ID:[_2]) créé par \'[_3]\'',
	'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Gabarit \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
	'No Name' => 'Pas de Nom',
	'Orphaned' => 'Orphelin',
	'Global Templates' => 'Gabarits globaux',
	' (Backup from [_1])' => ' (Sauvegarde depuis [_1])',
	'Error creating new template: ' => 'Erreur pendant la création du nouveau gabarit : ',
	'Template Referesh' => 'Réactualisation de gabarits',
	'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Saut du gabarit \'[_1]\' car c\'est un gabarit personnalisé.',
	'Refreshing template <strong>[_3]</strong> with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>' => 'Réactualiser les gabarits <strong>[_3]</strong> depuis <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">la sauvegarde</a>',
	'Saving [_1] failed: [_2]' => 'Enregistrement de [_1] a échoué: [_2]',
	'Skipping template \'[_1]\' since it has not been changed.' => 'Saut du gabarit \'[_1]\' car il n\'a pas été modifié',
	'Copy of [_1]' => 'Copie de [_1]',
	'Cannot publish a global template.' => 'Ne peut pas publier un gabarit global.',
	'Permission denied: [_1]' => 'Autorisation refusée: [_1]',
	'Save failed: [_1]' => 'Échec sauvegarde: [_1]',
	'Invalid ID [_1]' => 'ID invalide [_1]',
	'Saving object failed: [_1]' => 'Échec lors de la sauvegarde de l\'objet : [_1]',
	'Load failed: [_1]' => 'Échec de chargement : [_1]',
	'(no reason given)' => '(sans raison donnée)',
	'Widget Template' => 'Gabarit de Widget',
	'Widget Templates' => 'Gabarits de Widget',
	'Removing [_1] failed: [_2]' => 'Suppression [_1] échouée: [_2]',
	'template' => 'gabarit',
	'Restoring widget set [_1]... ' => 'Restauration du set de widget [_1] en cours...',
	'Done.' => 'Terminé.',
	'Failed.' => 'Echec.',

## lib/MT/CMS/Category.pm
	'Subfolder' => 'Sous-répertoire',
	'Subcategory' => 'Sous-catégorie',
	'The [_1] must be given a name!' => 'Le [_1] doit avoir un nom!',
	'Add a [_1]' => 'Ajouter un [_1]',
	'No label' => 'Pas d\'étiquette',
	'Category name cannot be blank.' => 'Le nom de la catégorie ne peut pas être vide.',
	'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Le nom de catégorie \'[_1]\' est en conflit avec une autre catégorie. Les catégories racines et les sous-catégories qui ont le même parent doivent avoir des noms uniques.',
	'The category basename \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => 'Le nom de base de la catégorie \'[_1]\' est en conflit avec une autre catégorie. Les catégories racines et les sous-catégories qui ont le même parent doivent avoir des noms de base uniques.',
	'Category \'[_1]\' created by \'[_2]\'' => 'Catégorie \'[_1]\' créée par \'[_2]\'',
	'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Catégorie \'[_1]\' (ID:[_2]) supprimée par \'[_3]\'',

## lib/MT/CMS/User.pm
	'Create User' => 'Créer un utilisateur',
	'Can\'t load role #[_1].' => 'Impossible de charger le rôle #[_1].',
	'Roles' => 'Rôles',
	'Create Role' => 'Créer un rôle',
	'(user deleted)' => '(utilisateur effacé)',
	'*User deleted*' => '*Utilisateur supprimé*',
	'Permission denied' => 'Permission refusée',
	'(newly created user)' => '(nouveaux utilisateurs)',
	'User Associations' => 'Associations d\'utilisateur',
	'Role Users & Groups' => 'Rôle Utilisateurs et Groupes',
	'Associations' => 'Associations',
	'(Custom)' => '(Personnalisé)',
	'The user' => 'L\'utilisateur',
	'User' => 'Utilisateur',
	'Role name cannot be blank.' => 'Le rôle de peu pas être laissé vierge.',
	'Another role already exists by that name.' => 'Un autre rôle existe déjà avec ce nom.',
	'You cannot define a role without permissions.' => 'Vous ne pouvez pas définir un rôle sans autorisations.',
	'General Settings' => 'Paramètres généraux',
	'Invalid ID given for personal blog theme.' => 'L\'ID communiqué est invalide pour un thème de blog personnel.',
	'Invalid ID given for personal blog clone location ID.' => 'L\'ID communiqué est invalide pour un ID de localisation de blog clone personnel.',
	'If personal blog is set, the personal blog location are required.' => 'Si un blog personnel est indiqué, la localisation du blog est nécessaire.',
	'Select a entry author' => 'Sélectionner l\'auteur de la note',
	'Select a page author' => 'Sélectionner l\'auteur de la page',
	'Selected author' => 'Auteur sélectionné',
	'Type a username to filter the choices below.' => 'Tapez un nom d\'utilisateur pour affiner les choix ci-dessous.',
	'Entry author' => 'Auteur de la note',
	'Page author' => 'Auteur de la page',
	'Select a System Administrator' => 'Sélectionner un administrateur système',
	'Selected System Administrator' => 'Administrateur système sélectionné',
	'System Administrator' => 'Administrateur Système',
	'represents a user who will be created afterwards' => 'il s\'agit des nouveaux utilisateurs créés plus tard',
	'Select Website' => 'Sélectionner des sites web',
	'Website Name' => 'Nom du site web',
	'Websites Selected' => 'Sites web sélectionnés',
	'Search Websites' => 'Rechercher des sites webs',
	'Select Blogs' => 'Sélectionner des blogs',
	'Blogs Selected' => 'Blogs sélectionnés',
	'Search Blogs' => 'Rechercher des blogs',
	'Select Users' => 'Utilisateurs sélectionnés',
	'Users Selected' => 'Utilisateurs sélectionnés',
	'Search Users' => 'Rechercher des utilisateurs',
	'Select Roles' => 'Sélectionnez des rôles',
	'Role Name' => 'Nom du rôle',
	'Roles Selected' => 'Rôles sélectionnés',
	'' => '', # Translate - New
	'Grant Permissions' => 'Ajouter des autorisations',
	'You cannot delete your own association.' => 'Vous ne pouvez pas supprimer votre propre association.',
	'You cannot delete your own user record.' => 'Vous ne pouvez pas effacer vos propres données Utilisateur.',
	'You have no permission to delete the user [_1].' => 'Vous n\'avez pas l\'autorisation d\'effacer l\'utilisateur [_1].',
	'User requires username' => 'Un nom d\'utilisateur est nécessaire pour l\'utilisateur',
	'[_1] contains an invalid character: [_2]' => '[_1] contient un caractère invalide : [_2]',
	'User requires display name' => 'Un nom d\'affichage est nécessaire pour l\'utilisateur',
	'A user with the same name already exists.' => 'Un utilisateur possédant ce nom existe déjà.',
	'User requires password' => 'L\'utilisateur a besoin d\'un mot de passe',
	'Email Address is required for password recovery' => 'L\'adresse email est nécessaire pour récupérer le mot de passe',
	'Email Address is invalid.' => 'L\'adresse email n\'est pas valide.',
	'URL is invalid.' => 'L\'URL n\'est pas valide.',
	'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) créé par \'[_3]\'',
	'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',

## lib/MT/CMS/Asset.pm
	'Files' => 'Fichiers',
	'Extension changed from [_1] to [_2]' => 'Extensions changés de [_1] vers [_2]',
	'Upload File' => 'Télécharger un fichier',
	'Can\'t load file #[_1].' => 'Impossible de charger le fichier #[_1].',
	'File \'[_1]\' uploaded by \'[_2]\'' => 'Fichier \'[_1]\' envoyé par \'[_2]\'',
	'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Fichier \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
	'[_1] of this website' => '[_1] de ce site web',
	'All Assets' => 'Tous les Éléments',
	'Untitled' => 'Sans nom',
	'Archive Root' => 'Archive Racine',
	'Please select a file to upload.' => 'Merci de sélectionner un fichier à envoyer.',
	'Invalid filename \'[_1]\'' => 'Nom de fichier invalide \'[_1]\'',
	'Please select an audio file to upload.' => 'Merci de sélectionner un fichier audio à envoyer.',
	'Please select an image to upload.' => 'Merci de sélectionner une image à envoyer.',
	'Please select a video to upload.' => 'Merci de sélectionner une vidéo à envoyer.',
	'Movable Type was unable to write on the "Upload Destination". Please make sure that the folder is writable from the web server.' => 'Movable Type n\'a pas réussi à écrire dans la destination du téléchargement. Veuillez vérifier que le répertoire de destination est ouvert en écriture au niveau du serveur web.',
	'Invalid extra path \'[_1]\'' => 'Chemin supplémentaire invalide \'[_1]\'',
	'Can\'t make path \'[_1]\': [_2]' => 'Impossible de créer le chemin \'[_1]\' : [_2]',
	'Invalid temp file name \'[_1]\'' => 'Nom de fichier temporaire invalide \'[_1]\'',
	'Error opening \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture de \'[_1]\' : [_2]',
	'Error deleting \'[_1]\': [_2]' => 'Erreur lors de la suppression de \'[_1]\' : [_2]',
	'File with name \'[_1]\' already exists. (Install File::Temp if you\'d like to be able to overwrite existing uploaded files.)' => 'Le fichier dont le nom est \'[_1]\' existe déjà. (Installez File::Temp si vous souhaitez pouvoir écraser les fichiers déjà chargés.)',
	'Error creating temporary file; please check your TempDir setting in your coniguration file (currently \'[_1]\') this location should be writable.' => 'Erreur lors de la création du fichier temporaire; merci de vérifier votre réglage TempDir dans votre fichier de configuration (actuellement \'[_1]\') cet endroit doit être accessible en écriture.',
	'unassigned' => 'non assigné',
	'File with name \'[_1]\' already exists; Tried to write to tempfile, but open failed: [_2]' => 'Le fichier avec le nom \'[_1]\' existe déjà; Tentative d\'écriture dans un fichier temporaire, mais l\'ouverture a échoué : [_2]',
	'Could not create upload path \'[_1]\': [_2]' => 'Impossible de créer le répertoire d\'upload \'[_1]\': [_2]',
	'Error writing upload to \'[_1]\': [_2]' => 'Erreur d\'écriture lors de l\'envoi de \'[_1]\' : [_2]',
	'Uploaded file is not an image.' => 'Le fichier téléchargé n\'est pas une image',
	'<' => '<',
	'/' => '/',

## lib/MT/CMS/Log.pm
	'All Feedback' => 'Tous les retours lecteurs',
	'Publishing' => 'Publication',
	'System Activity Feed' => 'Flux d\'activité du système',
	'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'Journal (logs) pour le blog \'[_1]\' (ID:[_2]) réinitialisé par \'[_3]\'',
	'Activity log reset by \'[_1]\'' => 'Journal (logs) réinitialisé par \'[_1]\'',

## lib/MT/CMS/Export.pm
	'Please select a blog.' => 'Merci de sélectionner un blog.',
	'You do not have export permissions' => 'Vous n\'avez pas les droits d\'exportation',

## lib/MT/CMS/Blog.pm
	'Cloning blog \'[_1]\'...' => 'Duplication du blog...',
	'Error' => 'Erreur',
	'Finished! You can <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">return to the blog listing</a>.' => 'Terminé ! Vous pouvez <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">retourner à la liste des blogs</a>.',
	'Close' => 'Fermer',
	'Plugin Settings' => 'Paramètres des plugins',
	'Settings' => 'Paramètres',
	'New Blog' => 'Nouveau Blog',
	'[_1] Activity Feed' => 'Flux d\'activité [_1]',
	'Go Back' => 'Retour',
	'Can\'t load entry #[_1].' => 'Impossible de charger la note #[_1].',
	'Can\'t load template #[_1].' => 'Impossible de charger le gabarit #[_1].',
	'index template \'[_1]\'' => 'gabarit d\'index \'[_1]\'',
	'[_1] \'[_2]\'' => '[_1] \'[_2]\'',
	'Publish Site' => 'Publier le site',
	'Invalid blog' => 'Blog incorrect',
	'Select Blog' => 'Sélectionner un blog',
	'Selected Blog' => 'Blog sélectionné',
	'Type a blog name to filter the choices below.' => 'Entrez le nom d\'un blog pour affiner les résultats ci-dessous.',
	'[_1] changed from [_2] to [_3]' => '[_1] a changé de [_2] à [_3]',
	'Saved [_1] Changes' => 'Enregistrer les changements de [_1]',
	'Saving permissions failed: [_1]' => 'Échec lors de la sauvegarde des Autorisations : [_1]',
	'[_1] \'[_2]\' (ID:[_3]) created by \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) a été créé par \'[_4]\'',
	'You did not specify a blog name.' => 'Vous n\'avez pas spécifié de nom pour le blog.',
	'Site URL must be an absolute URL.' => 'L\'URL du site doit être une URL absolue.',
	'Archive URL must be an absolute URL.' => 'Les URLs d\'archive doivent être des URLs absolues.',
	'You did not specify an Archive Root.' => 'Vous n\'avez pas spécifié une archive racine ',
	'The number of revisions to store must be a positive integer.' => 'Le nombre de révisions à stocker doit être un entier positif.',
	'Blog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) effacé par \'[_3]\'',
	'Saving blog failed: [_1]' => 'Échec lors de la sauvegarde du blog : [_1]',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Erreur: Movable Type ne peut pas écrire dans le répertoire de cache de gabarits. Merci de vérifier les autorisations du répertoire <code>[_1]</code> situé dans le répertoire du blog.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Erreur: Movable Type n\'a pas pu créer un répertoire pour cacher vos gabarits dynamiques. Vous devez créer un répertoire nommé <code>[_1]</code> dans le répertoire de votre blog.',
	'No blog was selected to clone.' => 'Aucun blog n\'a été sélectionné pour la duplication',
	'This action can only be run on a single blog at a time.' => 'Cette action ne peut être exécutée sur un seul blog à la fois.',
	'Invalid blog_id' => 'Identifiant du blog non valide',
	'This action cannot clone website.' => 'Cette action ne peut pas cloner un site web',
	'Clone of [_1]' => 'Clone de [_1]',
	'Entries must be cloned if comments and trackbacks are cloned' => 'Les notes doivent être clonées si les commentaires et les trackbacks le sont',
	'Entries must be cloned if comments are cloned' => 'Les notes doivent être clonées si les commentaires le sont',
	'Entries must be cloned if trackbacks are cloned' => 'Les notes doivent être clonées si les trackbacks le sont',
	'Clone Blog' => 'Dupliquer le blog',

## lib/MT/CMS/TrackBack.pm
	'Junk TrackBacks' => 'Trackbacks spam',
	'TrackBacks where <strong>[_1]</strong> is &quot;[_2]&quot;.' => 'Trackbacks où <strong>[_1]</strong> est &quot;[_2]&quot;.',
	'TrackBack Activity Feed' => 'Flux d\'activité des trackbacks ',
	'(Unlabeled category)' => '(Catégorie sans description)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) de \'[_2]\' supprimé par \'[_3]\' de la catégorie \'[_4]\'',
	'(Untitled entry)' => '(Note sans titre)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) de \'[_2]\' supprimé par \'[_3]\' de la note \'[_4]\'',
	'No Excerpt' => 'Pas d\'extrait',
	'No Title' => 'Pas de Titre',
	'Orphaned TrackBack' => 'Trackback orphelin',
	'category' => 'catégorie',

## lib/MT/CMS/Dashboard.pm
	'Error: This blog doesn\'t have a parent website.' => 'Erreur : ce blog n\'a pas de site web parent.',
	'Design with Themes' => 'Habillage avec thèmes',
	'Create and apply a theme to change blog templates, categories and other configurations.' => 'Créer et appliquer un thème en modifiant la configuration des gabarits, catégories et autres.',
	'Website Management' => 'Gestion des sites web',
	'Manage multiple blogs for each website. Now, it\'s much easier to create a portal with MultiBlog.' => 'Gérer de multiples blogs pour chaque site. Il est maintenant beaucoup plus facile de créer un portail multi-blog.',
	'Revision History' => 'Historique de révisions',
	'The revision history for entries and templates protects users from unexpected modification.' => 'L\'historique de révisions pour les notes et gabarits protège les utilisateurs des modifications indésirables.',

## lib/MT/CMS/Common.pm
	'Permisison denied.' => 'Autorisation refusée.',
	'The Template Name and Output File fields are required.' => 'Le nom du gabarit et les champs du fichier de sortie sont obligatoires.',
	'Invalid type [_1]' => 'Type invalide [_1]',
	'\'[_1]\' edited the template \'[_2]\' in the blog \'[_3]\'' => '\'[_1]\' a édité le gabarit \'[_2]\' du blog \'[_3]\'',
	'\'[_1]\' edited the global template \'[_2]\'' => '\'[_1]\' a édité le gabarit global\'[_2]\'',
	'Invalid parameter' => 'Paramètre invalide',
	'Notification List' => 'Liste de notifications',
	'IP Banning' => 'Bannissement d\'adresses IP',
	'Removing tag failed: [_1]' => 'La suppression du tag a échouée: [_1]',
	'Loading MT::LDAP failed: [_1].' => 'Échec de Chargement MT::LDAP[_1]',
	'System templates can not be deleted.' => 'Les gabarits créés par le Système ne peuvent pas être supprimés.',
	'Can\'t load [_1] #[_1].' => 'Ne peut pas charger [_1] #[_1].',
	'Saving snapshot failed: [_1]' => 'Enregistrement de l\'instantanné échoué : [_1]',

## lib/MT/CMS/BanList.pm
	'You did not enter an IP address to ban.' => 'Vous devez saisir une adresse IP à bannir.',
	'The IP you entered is already banned for this blog.' => 'L\'adresse IP saisie est déjà bannie pour ce blog.',

## lib/MT/CMS/Plugin.pm
	'Plugin Set: [_1]' => 'Éventail de plugins : [_1]',
	'Individual Plugins' => 'Plugins individuels',

## lib/MT/CMS/AddressBook.pm
	'No permissions.' => 'Pas d\'autorisations.',
	'No entry ID provided' => 'Aucune ID de note fournie',
	'No such entry \'[_1]\'' => 'Aucune note du type \'[_1]\'',
	'No email address for user \'[_1]\'' => 'L\'utilisateur \'[_1]\' ne possède pas d\'adresse e-mail',
	'No valid recipients found for the entry notification.' => 'Aucun destinataire valide n\'a été trouvé pour la notification de cette note.',
	'[_1] Update: [_2]' => '[_1] Mise à jour : [_2]',
	'Error sending mail ([_1]); try another MailTransfer setting?' => 'Erreur lors de l\'envoi de l\'e-mail ([_1]); Essayer avec d\'autres paramètres pour MailTransfer ?',
	'The value you entered was not a valid email address' => 'Vous devez saisir une adresse email valide',
	'The value you entered was not a valid URL' => 'Vous devez saisir une URL valide',
	'The e-mail address you entered is already on the Notification List for this blog.' => 'L\'adresse email saisie est déjà sur la liste de notification de ce blog.',
	'Subscriber \'[_1]\' (ID:[_2]) deleted from address book by \'[_3]\'' => 'Abonné \'[_1]\' (ID:[_2]) supprimé du carnet d\'adresses par \'[_3]\'',

## lib/MT/CMS/Tools.pm
	'Password Recovery' => 'Récupération de mot de passe',
	'Email Address is required for password recovery.' => 'Une adresse email est obligatoire pour récupérer le mot de passe.',
	'User not found' => 'Utilisateur introuvable',
	'Error sending mail ([_1]); please fix the problem, then try again to recover your password.' => 'Erreur d\'envoi du mail ([_1]); merci de corriger le problème, puis essayez à nouveau de récupérer votre mot de passe.',
	'Password reset token not found' => 'Token de remise à zéro du mot de passe introuvable',
	'Email address not found' => 'Adresse email introuvable',
	'Your request to change your password has expired.' => 'Votre demande de modification de mot de passe a expirée.',
	'Invalid password reset request' => 'Requête de modification de mot de passe invalide',
	'Please confirm your new password' => 'Merci de confirmer votre nouveau mot de passe',
	'Passwords do not match' => 'Les mots de passe ne correspondent pas',
	'That action ([_1]) is apparently not implemented!' => 'Cette action ([_1]) n\'est visiblement pas implémentée!',
	'You don\'t have a system email address configured.  Please set this first, save it, then try the test email again.' => 'Vous n\'avez pas d\'adresse e-mail système configurée. Veuillez le faire d\'abord, enregistrez, et testez à nouveau.',
	'Please enter a valid email address' => 'Veuillez entrer une adresse e-mail valide',
	'Test email from Movable Type' => 'Tester l\'e-mail depuis Movable Type',
	'This is the test email sent by your installation of Movable Type.' => 'Cet e-mail a été envoyé par votre installation de Movable Type.',
	'Mail was not properly sent' => 'L\'e-mail n\'a pas été envoyé correctement',
	'Test e-mail was successfully sent to [_1]' => 'L\'e-mail de test a été envoyé avec succès vers [_1]',
	'These setting(s) are overridden by a value in the MT configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.' => 'Ces paramètres ont été surchargés par une valeur dans le fichier de configuration MT : [_1]. Veuillez retirer la valeur dans le fichier de configuration afin de contrôler cette valeur depuis cette page.',
	'Email address is [_1]' => 'L\'e-mail est [_1]',
	'Debug mode is [_1]' => 'Le mode de débuggage est [_1]',
	'Performance logging is on' => 'La journalisation des performances est activée',
	'Performance logging is off' => 'La journalisation des performances est désactivée',
	'Performance log path is [_1]' => 'Le chemin d\'accès à la journalisation des perfomances est [_1]',
	'Performance log threshold is [_1]' => 'La limite de la journalisation des performances est [_1]',
	'System Settings Changes Took Place' => 'Les changements aux paramètres systèmes ont pris place',
	'Invalid password recovery attempt; can\'t recover password in this configuration' => 'Tentative de récupération de mot de passe invalide; impossible de récupérer le mot de passe dans cette configuration',
	'Invalid author_id' => 'auteur_id incorrect',
	'Backup' => 'Sauvegarder',
	'Backup & Restore' => 'Sauvegarder & Restaurer',
	'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.' => 'Le répertoire temporaire doit être autorisé en écriture pour que la sauvegarde puisse fonctionner. Merci de vérifier la directive de configuration TempDir.',
	'Temporary directory needs to be writable for restore to work correctly.  Please check TempDir configuration directive.' => 'Le répertoire temporaire doit être autorisé en écriture pour que la restauration puisse fonctionner. Merci de vérifier la directive de configuration TempDir.',
	'No website could be found. You must create a website first.' => 'Aucun site web ne peut être trouvé. Vous devez créer un site web en premier lieu.',
	'[_1] is not a number.' => '[_1] n\'est pas un nombre.',
	'Copying file [_1] to [_2] failed: [_3]' => 'La copie du fichier [_1] vers [_2] a échoué: [_3]',
	'Specified file was not found.' => 'Le fichier spécifié n\'a pas été trouvé.',
	'[_1] successfully downloaded backup file ([_2])' => '[_1] a téléchargé avec succès le fichier de sauvegarde ([_2])',
	'Restore' => 'Restaurer',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ',
	'Some of the actual files for assets could not be restored.' => 'Certains des fichiers des éléments n\'ont pu être restaurés.',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Merci d\'utiliser xml, tar.gz, zip, ou manifest comme extension de fichier.',
	'Unknown file format' => 'Format de fichier inconnu',
	'Some objects were not restored because their parent objects were not restored.' => 'Certains objets n\'ont pas été restaurés car leurs objets parents n\'ont pas été restaurés.',
	'Detailed information is in the <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>activity log</a>.' => 'Des informations détaillées se trouvent dans le <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>journal (logs)</a>.',
	'[_1] has canceled the multiple files restore operation prematurely.' => '[_1] a annulé prématurément l\'opération de restauration de plusieurs fichiers.',
	'Changing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Changement du chemin du site pour le blog \'[_1]\' (ID:[_2])...',
	'Removing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Suppression du chemin du site pour le blog \'[_1]\' (ID:[_2])...',
	'Changing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Changement du chemin d\'archive pour le blog \'[_1]\' (ID:[_2])...',
	'Removing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Suppression du chemin d\'archive pour le blog \'[_1]\' (ID:[_2])...',
	'failed' => 'échec',
	'ok' => 'ok',
	'Changing file path for the asset \'[_1]\' (ID:[_2])...' => 'Changement de chemin de fichier pour l\'élément \'[_1]\' (ID:[_2])...',
	'Please upload [_1] in this page.' => 'Merci d\'envoyer [_1] dans cette page.',
	'File was not uploaded.' => 'Le fichier n\'a pas été envoyé.',
	'Restoring a file failed: ' => 'Échec lors de la restauration d\'un fichier : ',
	'Some of the files were not restored correctly.' => 'Certains fichiers n\'ont pas été restaurés correctement.',
	'Successfully restored objects to Movable Type system by user \'[_1]\'' => 'Restauration avec succès des objets dans Movable Type par utilisateur \'[_1]\'',
	'Can\'t recover password in this configuration' => 'Impossible de récupérer le mot de passe dans cette configuration',
	'Invalid user name \'[_1]\' in password recovery attempt' => 'Nom d\'utilisateur invalide \'[_1]\' lors de la tentative de récupération du mot de passe',
	'User name or password hint is incorrect.' => 'Identifiant ou indice du mot de passe incorrect.',
	'User has not set pasword hint; cannot recover password' => 'L\'utilisateur n\'a pas fourni d\'indice de mot de passe; impossible de récupérer le mot de passe',
	'Invalid attempt to recover password (used hint \'[_1]\')' => 'Tentative invalide de récupération du mot de passe (indice de \'utilisateur \'[_1]\')',
	'User \'[_1]\' (user #[_2]) does not have email address' => 'L\'utilisateur \'[_1]\' (utilisateur #[_2]) n\'a pas d\'adresse e-mail',
	'A password reset link has been sent to [_3] for user  \'[_1]\' (user #[_2]).' => 'Un lien de réinitialisation du mot de passe a été envoyé à [_3] concernant l\'utilisateur \'[_1]\' (utilisateur #[_2]).',
	'Some objects were not restored because their parent objects were not restored.  Detailed information is in the <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">activity log</a>.' => 'Certains objets n\'ont pas été restaurés car leurs objets parents n\'ont pas été restaurés. Des informations détaillées se trouvent dans le <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">journal d\'activité</a>.',
	'[_1] is not a directory.' => '[_1] n\'est pas un répertoire.',
	'Error occured during restore process.' => 'Une erreur s\'est produite pendant la procédure de restauration.',
	'Some of files could not be restored.' => 'Certains fichiers n\'ont pu être restaurés.',
	'Uploaded file was not a valid Movable Type backup manifest file.' => 'Le fichier envoyé n\'était pas un fichier de sauvegarde manifest Movable Type valide.',
	'Blog(s) (ID:[_1]) was/were successfully backed up by user \'[_2]\'' => 'Blog(s) (ID:[_1]) a/ont été sauvegardé(s) avec succès par l\'utilisateur \'[_2]\'',
	'Movable Type system was successfully backed up by user \'[_1]\'' => 'Movable Type a été sauvegardé avec succès par l\'utilisateur \'[_1]\'',
	'Some [_1] were not restored because their parent objects were not restored.' => 'Certains [_1] n\'ont pas été restaurés car leurs objets parents n\'ont pas été restaurés.',

## lib/MT/CMS/Entry.pm
	'(untitled)' => '(sans titre)',
	'New Entry' => 'Nouvelle note',
	'New Page' => 'Nouvelle Page',
	'None' => 'Aucune',
	'pages' => 'Pages',
	'Category' => 'Catégorie',
	'Asset' => 'Élément',
	'Tag' => 'Tag',
	'Entry Status' => 'Statut par défaut',
	'[_1] Feed' => 'Flux [_1]',
	'Can\'t load template.' => 'Impossible de charger le gabarit',
	'New [_1]' => 'Nouveau [_1]',
	'No such [_1].' => 'Pas de [_1].',
	'Same Basename has already been used. You should use an unique basename.' => 'Ce nom de base est déjà utilisé. Vous devriez choisir un nom de base unique.',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Votre blog n\'a pas été configuré avec un chemin de site et une URL. Vous ne pourrez pas publier de notes tant qu\'ils ne seront pas définis.',
	'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Date invalide \'[_1]\'; les dates doivent être au format AAAA-MM-JJ HH:MM:SS.',
	'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Date invalide \'[_1]\'; les dates de publication doivent être réelles.',
	'[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) ajouté par utilisateur \'[_4]\'',
	'[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_1] \'[_2]\' (ID:[_3]) édité et son statut est passé de [_4] a [_5] par utilisateur \'[_6]\'',
	'[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) édité par utilisateur \'[_4]\'',
	'Saving placement failed: [_1]' => 'Échec lors de la sauvegarde du placement : [_1]',
	'Saving entry \'[_1]\' failed: [_2]' => 'Échec \'[_1]\' lors de la sauvegarde de la Note : [_2]',
	'Removing placement failed: [_1]' => 'Échec lors de la suppression de l\'emplacement : [_1]',
	'Ping \'[_1]\' failed: [_2]' => 'Le ping \'[_1]\' n\'a pas fonctionné : [_2]',
	'(user deleted - ID:[_1])' => '(utilisateur supprimé - ID:[_1])',
	'<a href="[_1]">QuickPost to [_2]</a> - Drag this link to your browser\'s toolbar, then click it when you are visiting a site that you want to blog about.' => '<a href="[_1]">QuickPost vers [_2]</a> - Glissez-déposez ce lien vers la barre des signets de votre navigateur puis cliquez dessus lorsque vous visitez un site que vous voudriez bloguer.',
	'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Note \'[_1]\' (ID:[_2]) supprimée par \'[_3]\'',
	'Need a status to update entries' => 'Statut nécessaire pour mettre à jour les notes',
	'Need entries to update status' => 'Notes nécessaires pour mettre à jour le statut',
	'One of the entries ([_1]) did not actually exist' => 'Une des notes ([_1]) n\'existait pas',
	'[_1] \'[_2]\' (ID:[_3]) status changed from [_4] to [_5]' => '[_1] \'[_2]\' (ID:[_3]) statut changé de [_4] à [_5]',

## lib/MT/CMS/Comment.pm
	'Edit Comment' => 'Éditer les commentaires',
	'Orphaned comment' => 'Commentaire orphelin',
	'Comments Activity Feed' => 'Flux d\'activité des commentaires',
	'Commenters' => 'Auteurs de commentaires',
	'Authenticated Commenters' => 'Auteurs de commentaires authentifiés',
	'No such commenter [_1].' => 'Pas de d\'auteur de commentaires [_1].',
	'User \'[_1]\' trusted commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\' a accordé le statut Fiable à l\'auteur de commentaire \'[_2]\'.',
	'User \'[_1]\' banned commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\'  a banni l\'auteur de commentaire \'[_2]\'.',
	'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\'  a retiré le statut Banni à l\'auteur de commentaire \'[_2]\'.',
	'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\'  a retiré le statut Fiable à l\'auteur de commentaire \'[_2]\'.',
	'Invalid request' => 'Demande incorrecte',
	'An error occurred: [_1]' => 'Une erreur s\'est produite: [_1]',
	'Parent comment id was not specified.' => 'id du commentaire parent non spécifié.',
	'Parent comment was not found.' => 'Commentaire parent non trouvé.',
	'You can\'t reply to unapproved comment.' => 'Vous ne pouvez répondre à un commentaire non approuvé.',
	'Publish failed: [_1]' => 'Échec de la publication : [_1]',
	'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Commentaire (ID:[_1]) de \'[_2]\' supprimé par \'[_3]\' de la note \'[_4]\'',
	'You don\'t have permission to approve this trackback.' => 'Vous n\'avez pas la permission d\'approuver ce trackback.',
	'Comment on missing entry!' => 'Commentaire sur une note manquante !',
	'You don\'t have permission to approve this comment.' => 'Vous n\'avez pas l\'autorisation d\'approuver ce commentaire.',
	'You can\'t reply to unpublished comment.' => 'Vous ne pouvez pas répondre à un commentaire non publié.',
	'Registered User' => 'Utilisateur enregistré',

## lib/MT/CMS/Theme.pm
	'Themes' => 'Thèmes',
	'Theme not found' => 'Thème introuvable',
	'Failed to uninstall theme' => 'Désinstallation du thème échouée',
	'Failed to uninstall theme: [_1]' => 'Désinstallation du thème écouchée : [_1]',
	'Theme from [_1]' => 'Thème de [_1]',
	'Install into themes directory' => 'Installer dans le répertoire des thèmes',
	'Download [_1] archive' => 'Télécharger l\'archive [_1]',
	'Failed to save theme export info: [_1]' => 'Sauvegarde des informations d\'exportation de thème echouée : [_1]',
	'Themes Directory [_1] is not writable.' => 'Le répertoire de thèmes [_1] n\'est pas ouvert en écriture.',
	'Error occurred during exporting [_1]: [_2]' => 'Erreur lors de l\'exportation de [_1] : [_2]',
	'Error occurred during finalizing [_1]: [_2]' => 'Erreur lors de la finalisation de [_1] : [_2]',
	'Error occurred while publishing theme: [_1]' => 'Erreur pendant la publication du thème : [_1]',

## lib/MT/CMS/Website.pm
	'New Website' => 'Nouveau site web',
	'Website \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Site web \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
	'Selected Website' => 'Sélectionner des sites web',
	'Type a website name to filter the choices below.' => 'Entrez un nom de site web pour filtrer les choix ci-dessous.',
	'Can\'t load website #[_1].' => 'Impossible de charger le site web #[_1].',
	'Blog \'[_1]\' (ID:[_2]) moved from \'[_3]\' to \'[_4]\' by \'[_5]\'' => 'Blog \'[_1]\' (ID:[_2]) déplacé de \'[_3]\' à \'[_4]\' par \'[_5]\'',

## lib/MT/Compat/v3.pm
	'uses: [_1], should use: [_2]' => 'utilise: [_1], devrait utiliser: [_2]',
	'uses [_1]' => 'utilise [_1]',
	'No executable code' => 'Pas de code exécutable',
	'Publish-option name must not contain special characters' => 'La personnalisation du nom de publication ne doit pas contenir de caractères spéciaux',

## lib/MT/FileMgr/FTP.pm
	'Creating path \'[_1]\' failed: [_2]' => 'Création du chemin \'[_1]\' a échouée : [_2]',
	'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Le renommage de \'[_1]\' à \'[_2]\' a échoué : [_3]',
	'Deleting \'[_1]\' failed: [_2]' => 'La suppression de \'[_1]\' a échoué : [_2]',

## lib/MT/FileMgr/DAV.pm
	'DAV connection failed: [_1]' => 'La connexion DAV a échoué : [_1]',
	'DAV open failed: [_1]' => 'L\'ouverture DAV a échouée : [_1]',
	'DAV get failed: [_1]' => 'La récupération DAV a échouée : [_1]',
	'DAV put failed: [_1]' => 'L\'envoi DAV a échouée : [_1]',

## lib/MT/FileMgr/Local.pm
	'Opening local file \'[_1]\' failed: [_2]' => 'L\'ouverture du fichier local \'[_1]\' a échoué: [_2]',

## lib/MT/FileMgr/SFTP.pm
	'SFTP connection failed: [_1]' => 'La connexion SFTP a échoué : [_1]',
	'SFTP get failed: [_1]' => 'La récupération  SFTP a échoué : [_1]',
	'SFTP put failed: [_1]' => 'L\'envoi  SFTP a échoué : [_1]',

## lib/MT/Theme/TemplateSet.pm
	'A template set containing [_1] templates, [_2] widgets, and [_3] widget sets.' => 'Un groupe de gabarits contient [_1] gabarits, [_2] widgets, et [_3] groupes de widgets.',
	'Widget Sets' => 'Groupes de widgets',
	'Failed to make templates directory: [_1]' => 'Échec lors de la création des gabarits de répertoires : [_1]',
	'Failed to publish template file: [_1]' => 'Échec lors de la publication du fichier de gabarit : [_1]',
	'exported_template set' => 'Groupe exported_template',

## lib/MT/Theme/Element.pm
	'Component \'[_1]\' is not found.' => 'Le composant \'[_1]\' est introuvable.',
	'Internal error: the importer is not found.' => 'Erreur interne : l\'importateur est introuvable.',
	'Compatibility error occured while applying \'[_1]\': [_2].' => 'Erreur de compatibilité lors de l\'application \'[_1]\' : [_2].',
	'Fatal error occured while applying \'[_1]\': [_2].' => 'Erreur fatale lors de l\'application \'[_1]\' : [_2].',
	'Importer for \'[_1]\' is too old.' => 'L\'importateur pour \'[_1]\' est trop vieux.',
	'Theme element \'[_1]\' is too old for this environment.' => 'L\'élément de thème \'[_1]\' est trop vieuz pour cet environnement',

## lib/MT/Theme/StaticFiles.pm
	'List the name of one directory to be included in your theme on each line.' => 'Lister le nom d\'un répertoire devant être inclu dans votre thème sur chaque ligne.',

## lib/MT/Theme/Pref.pm
	'this element cannot apply for non blog object.' => 'cet élément ne peut pas s\'appliquer sur un objet autre que blog.',
	'default settings for [_1]' => 'paramètres par défaut pour [_1]',
	'default settings' => 'paramètres par défaut',

## lib/MT/Theme/Category.pm
	'[_1] top level and [_2] sub categories.' => 'Niveau parent [_1] et catégories enfants[_2].',
	'[_1] top level and [_2] sub folders.' => 'Niveau parent [_1] et répertoires enfants[_2].',

## lib/MT/Theme/Entry.pm
	'[_1] pages' => 'Pages [_1]',

## lib/MT/BackupRestore/ManifestFileHandler.pm

## lib/MT/BackupRestore/BackupFileHandler.pm
	'Uploaded file was backed up from Movable Type but the different schema version ([_1]) from the one in this system ([_2]).  It is not safe to restore the file to this version of Movable Type.' => 'Le fichier téléchargé a été sauvegardé depuis Movable Type mais la version du schéma ([_1]) est différente de celle du système ([_2]). Il n\'est pas conseillé de restaurer le fichier vers cette version de Movable Type.',
	'[_1] is not a subject to be restored by Movable Type.' => '[_1] n\'est pas un sujet qui peut être restauré par Movable Type.',
	'[_1] records restored.' => '[_1] enregistrements restaurés.',
	'Restoring [_1] records:' => 'Restauration de [_1] enregistrements:',
	'User with the same name as the name of the currently logged in ([_1]) found.  Skipped the record.' => 'Utilisateur avec le même nom que l\'utilisateur actuellement connecté ([_1]) trouvé',
	'User with the same name \'[_1]\' found (ID:[_2]).  Restore replaced this user with the data backed up.' => 'Utilisateur avec le même nom \'[_1]\' trouvé (ID:[_2]). La restauration a remplacé cet utilisateur par les données présentes dans la sauvegardes.',
	'Tag \'[_1]\' exists in the system.' => 'Le tag \'[_1]\' existe dans le système.',
	'[_1] records restored...' => '[_1] enregistrements restaurés...',
	'The role \'[_1]\' has been renamed to \'[_2]\' because a role with the same name already exists.' => 'Le rôle \'[_1]\' a été renommé \'[_2]\' car un autre rôle portant le même nom existe déjà.',

## lib/MT/Template/Tags/Calendar.pm
	'You used an [_1] tag without a date context set up.' => 'Vous utilisez un tag [_1] sans avoir configuré la date.',
	'Invalid month format: must be YYYYMM' => 'Le format du mois est invalide : Il doit être de la forme AAAAMM',
	'No such category \'[_1]\'' => 'La catégorie \'[_1]\' n\'existe pas',
	'You used an [_1] tag outside of the proper context.' => 'Vous utilisez un tag [_1] en dehors de son contexte propre.',

## lib/MT/Template/Tags/Folder.pm

## lib/MT/Template/Tags/Category.pm
	'MT[_1] must be used in a [_2] context' => 'MT[_1] doit être utilisé dans le contexte [_2]',
	'Cannot find package [_1]: [_2]' => 'Impossible de trouver le package [_1]: [_2]',
	'Error sorting [_2]: [_1]' => 'Erreur en classant [_2]: [_1]',
	'[_1] cannot be used without publishing Category archive.' => '[_1] ne peut être utilisé sans la publication d\'archives par catégorie.',
	'[_1] used outside of [_2]' => '[_1] utilisé en dehors de [_2]',

## lib/MT/Template/Tags/Asset.pm
	'No such user \'[_1]\'' => 'L\'utilisateur \'[_1]\' n\'existe pas',
	'You have an error in your \'[_2]\' attribute: [_1]' => 'Vous avez une erreur dans votre attribut \'[_2]\' : [_1]',

## lib/MT/Template/Tags/Archive.pm
	'Group iterator failed.' => 'Le répétateur de groupe a échoué',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] est valide uniquement avec des archives quotidiennes, hebdomadaires ou mensuelles.',
	'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Vous avez utilisé un [_1] tag pour créer un lien vers \'[_2]\' archives, mais ce type d\'archive n\'est pas publié.',
	'Could not determine entry' => 'La note ne peut pas être déterminée',

## lib/MT/Template/Tags/Commenter.pm

## lib/MT/Template/Tags/Misc.pm
	'name is required.' => 'le nom est requis.',
	'Specified WidgetSet \'[_1]\' not found.' => 'Le groupe de widgets \'[_1]\' n\'a pas été trouvé',
	'' => '', # Translate - New

## lib/MT/Template/Tags/Ping.pm
	'<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> doit être utilisé dans le contexte d\'une catégorie, ou avec l\'attribut \'Catégorie\' dans le tag.',

## lib/MT/Template/Tags/Entry.pm
	'You used <$MTEntryFlag$> without a flag.' => 'Vous utilisez <$MTEntryFlag$> sans drapeau.',
	'Could not create atom id for entry [_1]' => 'Impossible de créer un ID Atom pour cette note [_1]',

## lib/MT/Template/Tags/Comment.pm
	'The MTCommentFields tag is no longer available; please include the [_1] template module instead.' => 'Le tag MTCommentFields n\'est plus disponible; merci d\'inclure le module de template [_1] à la place.',
	'Comment Form' => 'Formulaire de commentaire',
	'To enable comment registration, you need to add a TypePad token in your weblog config or user profile.' => 'Pour activer l\'enregistrement pour les commentaires, vous devez ajouter le jeton TypePad à votre configuration de blog ou profil utilisateur.',

## lib/MT/Template/Tags/Author.pm
	'The \'[_2]\' attribute will only accept an integer: [_1]' => 'L\'attribut \'[_2]\' n\'accepte que des entiers : [_1]',
	'You used an [_1] without a author context set up.' => 'Vous avez utilisé un [_1] sans avoir configuré de contexte d\'auteur.',

## lib/MT/Template/Context.pm
	'The attribute exclude_blogs cannot take \'[_1]\' for a value.' => 'L\'attribut exclude_blogs ne peut pas prendre \'[_1]\' pour valeur.', # Translate - New
	'You used an \'[_1]\' tag outside of the context of a author; perhaps you mistakenly placed it outside of an \'MTAuthors\' container?' => 'Vous avez utilisé un tag \'[_1]\' en dehors du contexte d\'un auteur; peut-être l\'avez-vous placé par erreur en dehors du conteneur \'MTAuthors\' ?',
	'You used an \'[_1]\' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an \'MTEntries\' container?' => 'Vous avez utilisé une balise \'[_1]\' en dehors du contexte d\'une note; peut-être l\'avez-vous placé par erreur en dehors du conteneur \'MTEntries\' ?',
	'You used an \'[_1]\' tag outside of the context of the website; perhaps you mistakenly placed it outside of an \'MTWebsites\' container?' => 'Vous avez utilisé une balise \'[_1]\' en dehors du contexte d\'un site web; peut-être l\'avez-vous placé par erreur en dehors du conteneur \'MTWebsites\' ?',
	'You used an \'[_1]\' tag outside of the context of the blog; perhaps you mistakenly placed it outside of an \'MTBlogs\' container?' => 'Vous avez utilisé une balise \'[_1]\' en dehors du contexte d\'un blog; peut-être l\'avez-vous placé par erreur en dehors du conteneur \'MTBlogs\'',
	'You used an \'[_1]\' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an \'MTComments\' container?' => 'Vous avez utilisé une balise \'[_1]\' en dehors du contexte d\'un commentaire; peut-être l\'avez-vous placé par erreur en dehors du conteneur \'MTComments\' ?',
	'You used an \'[_1]\' tag outside of the context of a ping; perhaps you mistakenly placed it outside of an \'MTPings\' container?' => 'Vous avez utilisé une balise \'[_1]\' en dehors d\'un contexte de ping; peut-être l\'avez-vous placé en dehors du conteneur \'MTPings\' ?',
	'You used an \'[_1]\' tag outside of the context of an asset; perhaps you mistakenly placed it outside of an \'MTAssets\' container?' => 'Vous avez utilisé une balise \'[_1]\' en dehors du contexte d\'un élément; peut-être l\'avez-vous placé par erreur en dehors d\'un conteneur \'MTAssets\' ?',
	'You used an \'[_1]\' tag outside of the context of a page; perhaps you mistakenly placed it outside of a \'MTPages\' container?' => 'Vous avez utilisé un tag \'[_1]\' en dehors du contexte d\'une page; peut-être l\'avez vous placé par erreur en dehors d\'un bloc \'MTPages\' ?',

## lib/MT/Template/ContextHandlers.pm
	'Warning' => 'Attention',
	'All About Me' => 'Tout Sur Moi',
	'Remove this widget' => 'Supprimer ce widget',
	'[_1]Publish[_2] your site to see these changes take effect.' => '[_1]Publiez[_2] votre site pour que ces changements soient appliqués.',
	'Actions' => 'Actions',
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.org/documentation/appendices/tags/%t.html',
	'Division by zero.' => 'Division par zéro.',
	'[_1] is not a hash.' => '[_1] n\'est pas un hash',
	'No [_1] could be found.' => 'Il n\'y a pas de [_1] trouvés.',
	'records' => 'enregistrements',
	'No template to include specified' => 'Aucun gabarit spécifié pour inclusion',
	'Recursion attempt on [_1]: [_2]' => 'Tentative de récursion sur [_1]: [_2]',
	'Can\'t find included template [_1] \'[_2]\'' => 'Impossible de trouver le gabarit inclus [_1] \'[_2]\'',
	'Error making path \'[_1]\': [_2]' => 'Erreur dans le chemin \'[_1]\' : [_2]',
	'Writing to \'[_1]\' failed: [_2]' => 'Ecriture sur\'[_1]\' a échoué: [_2]',
	'Can\'t find blog for id \'[_1]' => 'Impossible de trouver un blog pour le ID\'[_1]',
	'Can\'t find included file \'[_1]\'' => 'Impossible de trouver le fichier inclus \'[_1]\'',
	'Error opening included file \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture du fichier inclus \'[_1]\' : [_2]',
	'Recursion attempt on file: [_1]' => 'Tentative de récursion sur le fichier: [_1]',
	'Can\'t load user.' => 'Impossible de charger l\'utilisateur.',
	'Can\'t find template \'[_1]\'' => 'Impossible de trouver le gabarit \'[_1]\'',
	'Can\'t find entry \'[_1]\'' => 'Impossible de trouver la note \'[_1]\'',
	'Unspecified archive template' => 'Gabarit d\'archive non spécifié',
	'Error in file template: [_1]' => 'Erreur dans fichier gabarit : [_1]',
	'Can\'t load template' => 'Impossible de charger le gabarit',

## lib/MT/App/Search/Legacy.pm
	'You are currently performing a search. Please wait until your search is completed.' => 'Vous êtes en train d\'effectuer une recherche. Merci d\'attendre que la recherche soit finie.',
	'Search failed. Invalid pattern given: [_1]' => 'Échec de la recherche. Comportement non valide : [_1]',
	'Search failed: [_1]' => 'Échec lors de la recherche : [_1]',
	'No alternate template is specified for the Template \'[_1]\'' => 'Pas de gabarit alternatif spécifié pour le gabarit \'[_1]\'',
	'Publishing results failed: [_1]' => 'Échec de la publication des résultats: [_1]',
	'Search: query for \'[_1]\'' => 'Recherche : requête pour \'[_1]\'',
	'Search: new comment search' => 'Recherche : recherche de nouveaux commentaires',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearch fonctionne avec MT::App::Search.',

## lib/MT/App/NotifyList.pm
	'Please enter a valid email address.' => 'Veuillez entrer une adresse e-mail valide.',
	'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Il manque un paramètre requis : blog_id. Veuillez consulter le manuel d\'utilisateur pour configurer les notifications.',
	'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Vous avez fourni un paramètre de redirection non valide. Le propriétaire du blog doit spécifier le chemin qui correspond au nom de domaine du blog.',
	'The email address \'[_1]\' is already in the notification list for this weblog.' => 'L\'adresse e-mail \'[_1]\' fait déjà parti de la liste de notification pour ce blog.',
	'Please verify your email to subscribe' => 'Merci de vérifier votre email pour souscrire',
	'_NOTIFY_REQUIRE_CONFIRMATION' => 'Un email a été envoyé à [_1]. Pour valider votre inscription, merci de cliquer sur le lien qui figure dans cet email. Il permettra de vérifier que votre adresse email est valable.',
	'The address [_1] was not subscribed.' => 'L\'adresse [_1] n\'a pas été souscrite.',
	'The address [_1] has been unsubscribed.' => 'L\'adresse [_1] a été supprimée.',

## lib/MT/App/Comments.pm
	'Error assigning commenting rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable commenting role was found.' => 'Erreur en assignant les droits de commenter à l\'utilisateur \'[_1] (ID: [_2])\' pour le blog \'[_3] (ID: [_4])\'. Aucun rôle de commentaire adéquat n\'a été trouvé.',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Tentative d\'identification échouée pour l\'auteur de commentaires [_1] sur le blog [_2](ID: [_3]) qui n\'autorise pas l\'authentification native de Movable Type.',
	'Invalid login.' => 'Identifiant invalide.',
	'Invalid login' => 'Login invalide',
	'Successfully authenticated but signing up is not allowed.  Please contact system administrator.' => 'Identification réussie mais l\'enregistrement n\'est pas autorisé. Merci de contacter votre administrateur système.',
	'You need to sign up first.' => 'Vous devez vous enregistrer d\'abord.',
	'Login failed: permission denied for user \'[_1]\'' => 'Identification échouée: autorisation interdite pour l\'utilisateur \'[_1]\'',
	'Login failed: password was wrong for user \'[_1]\'' => 'Identification échouée: mot de passe incorrect pour l\'utilisateur \'[_1]\'',
	'Failed login attempt by disabled user \'[_1]\'' => 'Échec de tentative  d\'identification par utilisateur désactivé \'[_1]\' ',
	'Failed login attempt by unknown user \'[_1]\'' => 'Échec de tentative d\'identification par utilisateur inconnu\'[_1]\'',
	'Signing up is not allowed.' => 'Enregistrement non autorisée.',
	'Movable Type Account Confirmation' => 'Confirmation de compte Movable Type',
	'System Email Address is not configured.' => 'Adresse Email du Système non configurée.',
	'Commenter \'[_1]\' (ID:[_2]) has been successfully registered.' => 'L\'auteur de commentaires \'[_1]\' (ID:[_2]) a été enregistré avec succès.',
	'Thanks for the confirmation.  Please sign in to comment.' => 'Merci pour la confirmation. Merci de vous identifier pour commenter.',
	'[_1] registered to the blog \'[_2]\'' => '[_1] est enregistré sur le blog \'[_2]\'',
	'No id' => 'pas d\'id',
	'No such comment' => 'Pas de commentaire de la sorte',
	'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'l\'IP [_1] a été bannie car elle a envoyé plus de 8 commentaires en  [_2] seconds.',
	'IP Banned Due to Excessive Comments' => 'IP bannie pour cause de commentaires excessifs',
	'No entry_id' => 'Pas de note_id',
	'No such entry \'[_1]\'.' => 'Aucune Note \'[_1]\'.',
	'_THROTTLED_COMMENT' => 'Dans le but de réduire les possibilités d\'abus, Nous avons activé une fonction obligeant les auteurs de commentaires à attendre quelques instants avant de publier un autre commentaire. Veuillez attendre quelques instants avant de publier un autre commentaire. Merci.',
	'Comments are not allowed on this entry.' => 'Les commentaires ne sont pas autorisés sur cette Note.',
	'Comment text is required.' => 'Le texte de commentaire est requis.',
	'Registration is required.' => 'L\'inscription est requise.',
	'Name and email address are required.' => 'Le nom et l\'e-mail sont requis.',
	'Invalid email address \'[_1]\'' => 'Adresse e-mail invalide \'[_1]\'',
	'Invalid URL \'[_1]\'' => 'URL invalide \'[_1]\'',
	'Text entered was wrong.  Try again.' => 'Le texte saisi est erroné.  Essayez à nouveau',
	'Comment save failed with [_1]' => 'La sauvegarde du commentaire a échoué [_1]',
	'Comment on "[_1]" by [_2].' => 'Commentaire sur "[_1]" par [_2].',
	'Failed comment attempt by pending registrant \'[_1]\'' => 'Tentative de commentaire échouée par utilisateur  \'[_1]\' en cours d\'inscription',
	'The sign-in attempt was not successful; please try again.' => 'La tentative d\'enregistrement a échoué; veuillez essayer de nouveau.',
	'No entry was specified; perhaps there is a template problem?' => 'Aucune note n\'a été spécifiée; peut-être y a-t-il un problème de gabarit?',
	'Somehow, the entry you tried to comment on does not exist' => 'Il semble que la note que vous souhaitez commenter n\'existe pas',
	'Invalid entry ID provided' => 'ID de note fourni invalide',
	'All required fields must have valid values.' => 'Tous les champs obligatoires doivent avoir des valeurs valides.',
	'Commenter profile has successfully been updated.' => 'Le profil de l\'auteur de commentaires a été modifié avec succès.',
	'Commenter profile could not be updated: [_1]' => 'Le profil de l\'auteur de commentaires n\'a pu être modifié: [_1]',

## lib/MT/App/Search.pm
	'Invalid [_1] parameter.' => 'Paramètre [_1] invalide',
	'Invalid type: [_1]' => 'Type invalide : [_1]',
	'Search: failed storing results in cache.  [_1] is not available: [_2]' => 'Recherche : échec sur stockage des résultats en cache. [_1] n\'est pas disponible : [_2]',
	'Invalid format: [_1]' => 'Format invalide : [_1]',
	'Unsupported type: [_1]' => 'Type non supporté : [_1]',
	'Invalid query: [_1]' => 'Requête non valide : [_1]',
	'Invalid archive type' => 'Type d\'archive non valide',
	'Invalid value: [_1]' => 'Valeur invalide : [_1]',
	'No column was specified to search for [_1].' => 'Aucune colonne spécifiée à la recherche de [_1].',
	'No such template' => 'Aucun template trouvé',
	'template_id cannot be a global template' => 'template_id ne peut pas être un gabarit global',
	'Output file cannot be asp or php' => 'Le fichier de sortie ne peut pas être asp ou php',
	'You must pass a valid archive_type with the template_id' => 'Vous devez indiquer un archive_type valide avec le template_id',
	'Template must have identifier entry_listing for non-Index archive types' => 'Le gabarit doit avoir l\'identifieur entry-listing pour un type d\'archive non-Index',
	'Blog file extension cannot be asp or php for these archives' => 'Le fichier d\'extension de blog ne peut pas être asp ou php pour ces archives',
	'Template must have identifier main_index for Index archive type' => 'Le gabarit doit avoir l\'identifieur main_index pour un type d\'archive Index',
	'The search you conducted has timed out.  Please simplify your query and try again.' => 'La recherche que vous avez effectué a expiré. Merci de simplifier votre requête et réessayer.',

## lib/MT/App/Trackback.pm
	'Invalid entry ID \'[_1]\'' => 'ID de Note invalide \'[_1]\'',
	'You must define a Ping template in order to display pings.' => 'Vous devez définir un gabarit d\'affichage Ping pour les afficher.',
	'Trackback pings must use HTTP POST' => 'Les Pings trackback doivent utiliser HTTP POST',
	'Need a TrackBack ID (tb_id).' => 'Un ID de Trackback est requis (tb_id).',
	'Invalid TrackBack ID \'[_1]\'' => 'L\'ID de Trackback \'[_1]\' est invalide',
	'You are not allowed to send TrackBack pings.' => 'You n\'êtes pas autorisé à envoyer des pings trackback.',
	'You are pinging trackbacks too quickly. Please try again later.' => 'Vous pinguez les trackbacks trop rapidement. Merci d\'essayer plus tard.',
	'Need a Source URL (url).' => 'Une URL source est requise (url).',
	'This TrackBack item is disabled.' => 'Cet élément trackback est désactivé.',
	'This TrackBack item is protected by a passphrase.' => 'Cet élément de trackback est protégé par un mot de passe.',
	'TrackBack on "[_1]" from "[_2]".' => 'Trackback sur "[_1]" provenant de "[_2]".',
	'TrackBack on category \'[_1]\' (ID:[_2]).' => 'Trackback sur la catégorie \'[_1]\' (ID:[_2]).',
	'Can\'t create RSS feed \'[_1]\': ' => 'Impossible de créer le flux RSS \'[_1]\': ',
	'New TrackBack Ping to Entry [_1] ([_2])' => 'Nouveau trackback pour la note [_1] ([_2])',
	'New TrackBack Ping to Category [_1] ([_2])' => 'Nouveau trackback pour la catégorie [_1] ([_2])',

## lib/MT/App/Upgrader.pm
	'Could not authenticate using the credentials provided: [_1].' => 'Ne peut pas s\'identifier en utilisant les identifiants communiqués : [_1].',
	'Both passwords must match.' => 'Les deux mots de passe doivent être identiques.',
	'You must supply a password.' => 'Vous devez indiquer un mot de passe.',
	'An e-mail address is required.' => 'Une adresse e-mail est requise.',
	'The \'Publishing Path\' provided below is not writable by the web server.  Change the ownership or permissions on this directory, then click \'Finish Install\' again.' => 'Le \'chemin de publication\' indiqué ci-dessous n\'est pas ouvert en écriture sur le serveur web. Veuillez changer le propriétaire ou les permissions de ce répertoire puis cliquez sur \'Terminer l\'installation\' à nouveau.',
	'Invalid session.' => 'Session invalide.',
	'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Pas d\'autorisation. Contactez votre administrateur système Movable Type pour modifier vos privilèges.',
	'Movable Type has been upgraded to version [_1].' => 'Movable Type a été mis à jour à la version [_1].',

## lib/MT/App/Wizard.pm
	'The [_1] driver is required to use [_2].' => 'Le driver [_1] est obligatoire pour utiliser [_2].',
	'An error occurred while attempting to connect to the database.  Check the settings and try again.' => 'Une erreur s\'est produite en essayant de se connecter à la base de données. Vérifiez les paramètres et essayez à nouveau.',
	'Please select database from the list of database and try again.' => 'Veuillez sélectionner une base de données dans la liste des bases de données et réessayez.',
	'SMTP Server' => 'Serveur SMTP',
	'Sendmail' => 'Sendmail',
	'Test email from Movable Type Configuration Wizard' => 'Test email à partir de l\'Assistant de Configuration de Movable Type',
	'This is the test email sent by your new installation of Movable Type.' => 'Ceci est un email de test envoyé par votre nouvelle installation Movable Type.',
	'This module is needed to encode special characters, but this feature can be turned off using the NoHTMLEntities option in mt-config.cgi.' => 'Ce module est nécessaire pour encoder les caractères spéciaux, mais cette option peut être désactivée en utilisant NoHTMLEntities dans mt-config.cgi.',
	'This module is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'Ce module est nécessaire si vous souhaitez utiliser le système de trackback, les pings weblogs.com, ou le ping Mises à jour récentes MT.',
	'This module is needed if you wish to use the MT XML-RPC server implementation.' => 'Ce module est nécessaire si vous souhaitez utiliser l\'implémentation du serveur XML-RPC MT.',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Ce module est nécessaire si vous voulez pouvoir écraser les fichiers existants lorsque vous envoyez un nouveau fichier.',
	'This module is required by certain MT plugins available from third parties.' => 'Ce module est nécessaire pour certains plugins MT disponibles auprès de partenaires.',
	'This module accelerates comment registration sign-ins.' => 'Ce module accélère les enregistrements des auteurs de commentaires.',
	'This module is needed to enable comment registration.' => 'Ce module est nécessaire pour activer l\'enregistrement des auteurs de commentaires.',
	'This module enables the use of the Atom API.' => 'Ce module active l\'utilisation de l\'API Atom.',
	'This module is required in order to archive files in backup/restore operation.' => 'Ce module est nécessaire pour archiver les fichiers lors des opérations de sauvegarde/restauration.',
	'This module is required in order to compress files in backup/restore operation.' => 'Ce module est nécessaire pour compresser les fichiers lors des opérations de sauvegarde et restauration.',
	'This module is required in order to decompress files in backup/restore operation.' => 'Ce module est nécessaire pour décompresser les fichiers lors d\'une opération de sauvegarde/restauration.',
	'This module and its dependencies are required in order to restore from a backup.' => 'Ce module et ses dépendances sont nécessaires pour restaurer les fichiers à partir d\'une sauvegarde.',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including Vox and LiveJournal.' => 'Ce module et ses dépendances sont obligatoires pour permettre aux auteurs de commentaires d\'être authentifiés par des fournisseurs OpenID comme Vox et LiveJournal.',
	'This module is required for sending mail via SMTP Server.' => 'Ce module est nécessaire pour envoyer des emails via un serveur SMTP.',
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Ce module est nécessaire pour les envois de fichiers (pour déterminer la taille des images dans différents formats).',
	'This module is required for cookie authentication.' => 'Ce module est nécessaire pour l\'authentification par cookies.',

## lib/MT/App/Viewer.pm
	'Loading blog with ID [_1] failed' => 'Échec lors du chargement du blog ayant pour ID [_1] ',
	'Template publishing failed: [_1]' => 'Échec lors de la publication du gabarit : [_1]',
	'Invalid date spec' => 'Spécifications de dates invalides',
	'Can\'t load templatemap' => 'Impossible de charger la table de correspondance des gabarits',
	'Can\'t load template [_1]' => 'Impossible de charger le gabarit [_1]',
	'Archive publishing failed: [_1]' => 'Échec lors de la publication de l\'archive : [_1]',
	'Invalid entry ID [_1]' => ' ID de la note invalide : [_1]',
	'Entry [_1] is not published' => 'La note [_1] n\'est pas publiée',
	'Invalid category ID \'[_1]\'' => 'ID de catégorie invalide : \'[_1]\'',

## lib/MT/App/CMS.pm
	'_WARNING_PASSWORD_RESET_MULTI' => 'Vous êtes sur le point d\'envoyer des emails pour permettre aux utilisateurs sélectionnés de réinitialiser leurs mots de passe. Voulez-vous continuer ?',
	'_WARNING_DELETE_USER_EUM' => 'Supprimer un utilisateur est une action définitive qui va rendre des notes orphelines. Si vous voulez retirer un utilisateur ou lui supprimer ses accès nous vous recommandons de désactiver son compte. Êtes-vous sûr(e) de vouloir supprimer cet utilisateur ? Attention, il pourra se créer un nouvel accès s\'il existe encore dans le répertoire externe',
	'_WARNING_DELETE_USER' => 'Supprimer un utilisateur est une action définitive qui va rendre des notes orphelines. Si vous souhaitez retirer un utilisateur ou lui supprimer ses accès nous vous recommandons de désactiver son compte. Êtes-vous sûr(e) de vouloir supprimer cet utilisateur ?',
	'_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' => 'Cette action rétablira les gabarits par défaut pour le(s) blog(s) sélectionné(s). Etes-vous sûr de vouloir rafraîchir les gabarits de ce(s) blog(s) ?',
	'My [_1] of this [_2]' => 'Mon [_1] de ces [_2]',
	'Published [_1]' => '[_1] publiées',
	'Unpublished [_1]' => '[_1] non-publiées',
	'Scheduled [_1]' => '[_1] programmées',
	'My [_1]' => 'Mes [_1]',
	'[_1] with comments in the last 7 days' => '[_1] avec des commentaires dans les 7 derniers jours',
	'[_1] posted between [_2] and [_3]' => '[_1] postées entre le [_2] et le [_3]',
	'[_1] posted since [_2]' => '[_1] postées depuis [_2]',
	'[_1] posted on or before [_2]' => '[_1] postées le ou avant le [_2]',
	'Non-spam TrackBacks on this website' => 'Trackbacks non-indésirables sur ce site web',
	'Non-spam Comments on this website' => 'Commentaires non-indésirables sur ce site web',
	'Comments on my entries of [_1]' => 'Commentaires sur mes notes de [_1]',
	'All comments by [_1] \'[_2]\'' => 'Tous les commentaires par [_1] \'[_2]\'',
	'Commenter' => 'Auteur du commentaire',
	'All comments for [_1] \'[_2]\'' => 'Tous les commentaires pour [_1] \'[_2]\'',
	'Comments posted between [_1] and [_2]' => 'Commentaires postés entre [_1] et [_2]',
	'Comments posted since [_1]' => 'Commentaires déposés depuis [_1]',
	'Comments posted on or before [_1]' => 'Commentaires postés le ou avant le [_1]',
	'You are not authorized to log in to this blog.' => 'Vous n\'êtes pas autorisé à vous connecter sur ce blog.',
	'No such blog [_1]' => 'Aucun blog ne porte le nom [_1]',
	'Edit Template' => 'Modifier un gabarit',
	'Unknown object type [_1]' => 'Objet de type [_1] inconnu',
	'Error during publishing: [_1]' => 'Erreur pendant la publication : [_1]',
	'This is You' => 'C\'est vous',
	'Movable Type News' => 'Actualités Movable Type',
	'Blog Stats' => 'Statistiques du blog',
	'Websites and Blogs' => 'Sites web et blogs',
	'Refresh Templates' => 'Réactualiser les gabarits',
	'Use Publishing Profile' => 'Utiliser un Profil de Publication',
	'Unpublish Entries' => 'Annuler publication',
	'Add Tags...' => 'Ajouter des tags...',
	'Tags to add to selected entries' => 'Tags à ajouter aux notes sélectionnées',
	'Remove Tags...' => 'Enlever les tags...',
	'Tags to remove from selected entries' => 'Tags à enlever des notes sélectionnées',
	'Batch Edit Entries' => 'Modifier des notes par lot',
	'Unpublish Pages' => 'Dépublier les pages',
	'Tags to add to selected pages' => 'Tags à ajouter aux pages sélectionnées',
	'Tags to remove from selected pages' => 'Tags à supprimer des pages sélectionnées',
	'Batch Edit Pages' => 'Modifier les pages en masse',
	'Tags to add to selected assets' => 'Tags à ajouter aux éléments sélectionnés',
	'Tags to remove from selected assets' => 'Tags à supprimer les éléments sélectionnés',
	'Unpublish TrackBack(s)' => 'Annuler la publication de ce (ou ces) trackbacks(s)',
	'Unpublish Comment(s)' => 'Annuler la publication de ce (ou ces) commentaire(s)',
	'Trust Commenter(s)' => 'Donner le statut fiable à cet auteur de commentaires',
	'Untrust Commenter(s)' => 'Retirer le statut fiable à cet auteur de commentaires',
	'Ban Commenter(s)' => 'Bannir cet auteur de commentaires',
	'Unban Commenter(s)' => 'Lever le bannissement cet auteur de commentaires',
	'Recover Password(s)' => 'Récupérer le(s) mot(s) de passe',
	'Delete' => 'Supprimer',
	'Refresh Template(s)' => 'Actualiser le(s) Gabarit(s)',
	'Move blog(s) ' => 'Déplacer les blog(s)',
	'Publish Template(s)' => 'Publier le(s) Gabarit(s)',
	'Clone Template(s)' => 'Cloner le(s) Gabarit(s)',
	'Non-spam TrackBacks' => 'Trackbacks marqués comme n\'étant pas du spam',
	'Pending TrackBacks' => 'Trackbacks en attente',
	'Published TrackBacks' => 'Trackbacks publiés',
	'TrackBacks on my entries' => 'Trackbacks sur mes entrées',
	'TrackBacks in the last 7 days' => 'Trackbacks des 7 derniers jours',
	'Spam TrackBacks' => 'Trackbacks indésirables',
	'Non-spam Comments' => 'Commentaires marqués comme n\'étant pas du spam',
	'Pending comments' => 'Commentaires en attente',
	'Published comments' => 'Commentaires publiés.',
	'Comments on my entries' => 'Commentaires sur mes notes',
	'Comments in the last 7 days' => 'Commentaires des 7 derniers jours',
	'Spam Comments' => 'Commentaires marqués comme étant du spam',
	'Tags with entries' => 'Tags avec les notes',
	'Tags with pages' => 'Tags avec les pages',
	'Tags with assets' => 'Tags avec les éléments',
	'Enabled Users' => 'Utilisateurs activés',
	'Disabled Users' => 'Utilisateurs désactivés',
	'Pending Users' => 'Utilisateurs en attente',
	'Design' => 'Design',
	'Tools' => 'Outils',
	'Manage' => 'Gérer',
	'New' => 'Nouveau',
	'Folders' => 'Répertoires',
	'Widgets' => 'Widgets',
	'General' => 'Général',
	'Compose' => 'Rédiger',
	'Feedback' => 'Feedback',
	'Registration' => 'Enregistrement',
	'Web Services' => 'Services Web',
	'Permissions' => 'Autorisations',
	'Search &amp; Replace' => 'Chercher &amp; Remplacer',
	'Plugins' => 'Plugins',
	'Import Entries' => 'Importer des notes',
	'Export Entries' => 'Exporter des notes',
	'Export Theme' => 'Exporter le thème',
	'Address Book' => 'Carnet d\'adresses',
	'Create New' => 'Créer un nouveau',
	'Website' => 'Website',

## lib/MT/App/ActivityFeeds.pm
	'Error loading [_1]: [_2]' => 'Erreur lors du chargement chargement [_1] : [_2]',
	'An error occurred while generating the activity feed: [_1].' => 'Une erreur est survenue lors de la génération du flux d\'activité : [_1].',
	'[_1] Weblog TrackBacks' => 'Trackbacks du blog [_1] ',
	'All Weblog TrackBacks' => 'Tous les trackbacks du blog',
	'[_1] Weblog Comments' => 'Commentaires du blog [_1] ',
	'All Weblog Comments' => 'Tous les commentaires du blog',
	'[_1] Weblog Entries' => 'Notes du blog [_1] ',
	'All Weblog Entries' => 'Toutes les notes du blog ',
	'[_1] Weblog Activity' => 'Activité du blog [_1] ',
	'All Weblog Activity' => 'Toutes l\'activité du blog',
	'Movable Type System Activity' => 'Activité du système Movable Type',
	'Movable Type Debug Activity' => 'Activité de débogage Movable Type',
	'[_1] Weblog Pages' => 'Pages du blog [_1]',
	'All Weblog Pages' => 'Toutes les pages du blog',

## lib/MT/Worker/Publish.pm
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- configuration terminée ([quant,_1,fichier,fichiers] dans [_2] secondes)',

## lib/MT/Worker/Sync.pm
	'Synchrnizing Files Done' => 'Synchronisation des fichiers effectuée',
	'Done syncing files to [_1] ([_2])' => 'Synchronisation des fichiers de [_1] ([_2]) terminée',

## lib/MT/Revisable/Local.pm
	'string(255)' => 'phrase(255)',

## lib/MT/Role.pm
	'Role' => 'Rôle',
	'Blog Administrator' => 'Administrateur du blog',
	'Can administer the blog.' => 'Peut administrer le blog.',
	'Editor' => 'Éditeur',
	'Can upload files, edit all entries(categories), pages(folders), tags and publish the site.' => 'Peut télécharger des fichiers, éditer toutes les notes (catégories), pages (répertoires), tags et publier le site.',
	'Can create entries, edit their own entries, upload files and publish.' => 'Peut créer des notes, éditer ses propres notes, télecharger des fichiers et publier.',
	'Can edit, manage, and publish blog templates and themes.' => 'Peut éditer, gérer et publier les gabarits du blog et les thèmes.',
	'Can manage pages, upload files and publish blog templates.' => 'Peut gérer les pages, télécharger des fichiers et publier les gabarits du blog.',
	'Contributor' => 'Contributeur',
	'Can create entries, edit their own entries, and comment.' => 'Peut créer des notes, éditer ses propres notes et commenter.',
	'Moderator' => 'Modérateur',
	'Can comment and manage feedback.' => 'Peut commenter et gérer les commentaires.',
	'Can comment.' => 'Peut commenter.',

## lib/MT/BasicAuthor.pm
	'authors' => 'auteurs',

## lib/MT/Placement.pm
	'Category Placement' => 'Gestion des catégories',

## lib/MT/Permission.pm
	'Permission' => 'Autorisation',

## lib/MT/TaskMgr.pm
	'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'Impossible d\'assurer le verrouillage pour l\'exécution de tâches système. Vérifiez que la zone TempDir ([_1]) est ouverte en écriture.',
	'Error during task \'[_1]\': [_2]' => 'Erreur pendant la tâche \'[_1]\' : [_2]',
	'Scheduled Tasks Update' => 'Mise à jour des tâches planifiées',
	'The following tasks were run:' => 'Les tâches suivantes ont été exécutées :',

## lib/MT/Page.pm
	'Folder' => 'Répertoire',
	'Load of blog failed: [_1]' => 'Échec lors du chargement du blog : [_1]',

## lib/MT/Bootstrap.pm
	'Got an error: [_1]' => 'Erreur de type : [_1]',

## lib/MT/Scorable.pm
	'Object must be saved first.' => 'L\'objet doit être d\'abord sauvegardé.',
	'Already scored for this object.' => 'Cet objet a déjà été noté',
	'Could not set score to the object \'[_1]\'(ID: [_2])' => 'Impossible de stocker le score de l\'objet \'[_1]\'(ID: [_2])',

## lib/MT/Category.pm
	'Categories must exist within the same blog' => 'Les catégories doivent exister au sein du même blog ',
	'Category loop detected' => 'Boucle de catégorie détectée',
	'string(100) not null' => 'chaine(100) non null',

## lib/MT/Asset.pm
	'Could not remove asset file [_1] from filesystem: [_2]' => 'Impossible de retirer le fichier [_1] du système : [_2]',
	'Location' => 'Adresse',

## lib/MT/Image.pm
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Le module Perl Image::Size est requis pour déterminer la largeur et la hauteur des images téléchargées.',
	'File size exceeds maximum allowed: [_1] > [_2]' => 'La taille du fichier dépasse le maximum autorisé: [_1] > [_2]',
	'Can\'t load Image::Magick: [_1]' => 'Impossible de charger Image::Magick : [_1]',
	'Reading file \'[_1]\' failed: [_2]' => 'La lecture du fichier \'[_1]\' a échoué : [_2]',
	'Reading image failed: [_1]' => 'Échec lors de la lecture de l\'image : [_1]',
	'Scaling to [_1]x[_2] failed: [_3]' => 'La mise à l\'échelle vers [_1]x[_2] a échoué : [_3]',
	'Cropping a [_1]x[_1] square at [_2],[_3] failed: [_4]' => 'Rognage d\'un carré [_1]x[_1] à [_2],[_3] échoué: [_4]',
	'Converting image to [_1] failed: [_2]' => 'Conversion de l\'image vers [_1] a échoué: [_2]',
	'Can\'t load IPC::Run: [_1]' => 'Impossible de charger IPC::Run : [_1]',
	'Unsupported image file type: [_1]' => 'Type de fichier image non supporté: [_1]',
	'Cropping to [_1]x[_1] failed: [_2]' => 'Rognage vers [_1]x[_1] échoué: [_2]',
	'Converting to [_1] failed: [_2]' => 'Conversion vers [_1] a échoué: [_2]',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'Votre chemin d\'accès vers les outils NetPBM n\'est pas valide sur votre machine.',
	'Can\'t load GD: [_1]' => 'Impossible de charger GD: [_1]',

## lib/MT/XMLRPCServer.pm
	'Invalid timestamp format' => 'Format de date invalide',
	'No web services password assigned.  Please see your user profile to set it.' => 'Aucun mot de passe associé aux services web. Merci de vérifier votre profil utilisateur pour le définir.',
	'Requested permalink \'[_1]\' is not available for this page' => 'Le lien permanent requis  \'[_1]\' n\'est pas disponible pour cette page',
	'Saving folder failed: [_1]' => 'Echec lors de la sauvegarde du répertoire : [_1]',
	'No blog_id' => 'Pas de blog_id',
	'Invalid blog ID \'[_1]\'' => 'ID du blog invalide \'[_1]\'',
	'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => 'Valeur pour \'mt_[_1]\' doit être 1 ou 0 (était \'[_2]\')',
	'PreSave failed [_1]' => 'Échec lors du pré-enregistrement [_1]',
	'User \'[_1]\' (user #[_2]) added [lc,_4] #[_3]' => 'L\'Utilisateur \'[_1]\' (utilisateur #[_2]) a ajouté [lc,_4] #[_3]',
	'Not privileged to edit entry' => 'Non détenteur des droits d\'édition de notes',
	'User \'[_1]\' (user #[_2]) edited [lc,_4] #[_3]' => 'L\'Utilisateur \'[_1]\' (L\'Utilisateur #[_2]) a édité [lc,_4] #[_3]',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'La note \'[_1]\' ([lc,_5] #[_2]) a été supprimée par \'[_3]\' (utilisateur #[_4]) depuis xml-rpc',
	'Not privileged to get entry' => 'Non détenteur des droits de possession de notes',
	'Not privileged to set entry categories' => 'Non détenteur des droits d\'affectation des catégories d\'une note',
	'Not privileged to upload files' => 'Non détenteur des droits de téléchargement de fichiers',
	'No filename provided' => 'Aucun nom de fichier',
	'Error writing uploaded file: [_1]' => 'Erreur lors de l\'écriture du fichier téléchargé : [_1]',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Les méthodes de gabarit ne sont pas implémentées en raison d\'une différence entre l\'API Blogger et l\'API Movable Type.',

## lib/MT/Session.pm
	'Session' => 'Session',

## lib/MT/WeblogPublisher.pm
	'Archive type \'[_1]\' is not a chosen archive type' => 'Le Type d\'archive\'[_1]\' n\'est pas un type d\'archive sélectionné',
	'Parameter \'[_1]\' is required' => 'Le paramètre \'[_1]\' est requis',
	'You did not set your blog publishing path' => 'Vous n\'avez pas spécifié le chemin de publication de votre blog',
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Le même fichier d\'archive existe déjà. Vous devez changer le nom de base ou le chemin de l\'archive ([_1])',
	'An error occurred publishing [_1] \'[_2]\': [_3]' => 'Une erreur s\'est produite lors de la publication [_1] \'[_2]\': [_3]',
	'An error occurred publishing date-based archive \'[_1]\': [_2]' => 'Une erreur s\'est produite en publiant l\'archive par dates \'[_1]\': [_2]',
	'Renaming tempfile \'[_1]\' failed: [_2]' => 'Le renommage de tempfile \'[_1]\' a échoué: [_2]',
	'Blog, BlogID or Template param must be specified.' => 'Les paramètres Blog, BlogID ou Template doivent être spécifiés.',
	'Template \'[_1]\' does not have an Output File.' => 'Le gabarit \'[_1]\' n\'a pas de fichier de sortie.',
	'An error occurred while publishing scheduled entries: [_1]' => 'Une erreur s\'est produite en publiant les notes planifiées: [_1]',

## lib/MT/Trackback.pm
	'TrackBack' => 'Trackback',

## lib/MT/Auth.pm
	'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Mauvaise configuration du module d\'authentification \'[_1]\': [_2]',
	'Bad AuthenticationModule config' => 'Mauvaise configuration du module d\'authentification',

## lib/MT/Notification.pm
	'Contact' => 'Contact',
	'Contacts' => 'Contacts',

## lib/MT/Comment.pm
	'Comment' => 'Commentaire',
	'Load of entry \'[_1]\' failed: [_2]' => 'Le chargement de la note \'[_1]\' a échoué : [_2]',

## lib/MT/Component.pm
	'Loading template \'[_1]\' failed: [_2]' => 'Échec lors du chargement du gabarit \'[_1]\': [_2]',

## lib/MT/Theme.pm
	'Failed to load theme [_1].' => 'Echec lors du chargement du thème [_1].',
	'A fatal error occurred while applying element [_1]: [_2].' => 'Une erreur fatale est survenue lors de l\'application de l\'élément [_1] : [_2].',
	'An error occurred while applying element [_1]: [_2].' => 'Une erreur est survenue lors de l\'application de l\'élément [_1] : [_2].',
	'Component \'[_1]\' version [_2] or greater is needed to use this theme, but is not installed.' => 'Le composant \'[_1]\' version [_2] ou supérieur est nécessaire pour utiliser ce thème mais n\'est pas installé.',
	'Component \'[_1]\' version [_2] or greater is needed to use this theme, but the installed version is [_3].' => 'Le composant \'[_1]\' version [_2] ou supérieur est nécessaire pour utiliser ce thème mais la version installée est [_3].',
	'Element \'[_1]\' cannot be applied because [_2]' => 'L\'élément \'[_1] ne peut pas être appliqué à cause de [_2]',
	'There was an error scaling image [_1].' => 'Il y a eu une erreur lors du redimensionnement de l\'image [_1].',
	'There was an error converting image [_1].' => 'Il y a eu une erreur lors de la conversion de l\'image [_1].',
	'There was an error creating thumbnail file [_1].' => 'Il y a eu une erreur lors de la création de la miniature de l\'image [_1].',
	'Default Prefs' => 'Préférences par défaut',
	'Template Set' => 'Ensemble de modèles',
	'Static Files' => 'Fichiers statiques',
	'Default Pages' => 'Pages par défaut',

## lib/MT/Upgrade.pm
	'Invalid upgrade function: [_1].' => 'Fonction de mise à jour invalide : [_1].',
	'Error loading class [_1].' => 'Erreur en chargeant la classe [_1].',
	'Upgrading table for [_1] records...' => 'Mise à jour des tables pour [_1] les enregistrements...',
	'Upgrading database from version [_1].' => 'Mise à jour de la Base de données de la version [_1].',
	'Database has been upgraded to version [_1].' => 'La base de données a été mise à jour version [_1].',
	'User \'[_1]\' upgraded database to version [_2]' => 'L\'utilisateur \'[_1]\' a mis à jour la base de données avec la version [_2]',
	'Plugin \'[_1]\' upgraded successfully to version [_2] (schema version [_3]).' => 'Plugin \'[_1]\' mis à jour avec succès à la version [_2] (schéma version [_3]).',
	'User \'[_1]\' upgraded plugin \'[_2]\' to version [_3] (schema version [_4]).' => 'Utilisateur \'[_1]\' a mis à jour le plugin \'[_2]\' vers la version [_3] (schéma version [_4]).',
	'Plugin \'[_1]\' installed successfully.' => 'Le Plugin \'[_1]\' a été installé correctement.',
	'User \'[_1]\' installed plugin \'[_2]\', version [_3] (schema version [_4]).' => 'Utilisateur \'[_1]\' a installé le plugin \'[_2]\', version [_3] (schéma version [_4]).',
	'Error saving [_1] record # [_3]: [_2]...' => 'Erreur en enregistrant l\'enregistrement [_1] # [_3]: [_2]...',

## lib/MT/Core.pm
	'Error creating performance logs directory, [_1]. Please either change the permissions to make it writable or specify an alternate using the PerformanceLoggingPath configuration directive: [_2]' => 'Erreur dans la création du répertoire pour les logs de performance, [_1]. Vous pouvez soit changer ses permissions pour qu\'il soit accessible en écriture, soit utiliser la directive de configuration PerformanceLoggingPath: [_2]',
	'Error creating performance logs: PerformanceLoggingPath setting must be a directory path, not a file: [_1]' => 'Erreur dans la création de logs de performance : PerformanceLoggingPath doit être un chemin de répertoire et non un fichier : [_1]',
	'Error creating performance logs: PerformanceLoggingPath directory exists but is not writeable: [_1]' => 'Erreur dans la création de logs de performance : PerformanceLoggingPath existe mais n\'est pas accessible à  l\'écriture : [_1]',
	'MySQL Database (Recommended)' => 'Base de données MySQL (recommandé)',
	'PostgreSQL Database' => 'Base de données PostgreSQL',
	'SQLite Database' => 'Base de données SQLite',
	'SQLite Database (v2)' => 'Base de données SQLite (v2)',
	'Convert Line Breaks' => 'Conversion retours ligne',
	'Rich Text' => 'Texte Enrichi',
	'Movable Type Default' => 'Valeur par Défaut Movable Type',
	'weblogs.com' => 'weblogs.com',
	'technorati.com' => 'technorati.com',
	'google.com' => 'google.com',
	'Classic Blog' => 'Blog classique',
	'Publishes content.' => 'Publication de contenu.',
	'Synchronizes content to other server(s).' => 'Synchronise le contenu vers d\'autres serveurs.',
	'Refreshes object summaries.' => 'Réactualise les résumés des objets',
	'Adds Summarize workers to queue.' => 'Ajoute les robots de résumés à la queue.',
	'zip' => 'zip',
	'tar.gz' => 'tar.gz',
	'Entries List' => 'Liste des notes',
	'Blog URL' => 'URL du blog',
	'Blog ID' => 'ID du blog',
	'Entry Excerpt' => 'Extrait de la note',
	'Entry Link' => 'Lien de la note',
	'Entry Extended Text' => 'Texte étendu de la note',
	'Entry Title' => 'Titre de la note',
	'If Block' => 'Bloc If',
	'If/Else Block' => 'Bloc If/Else',
	'Include Template Module' => 'Inclure un module de gabarit',
	'Include Template File' => 'Inclure un fichier de gabarit',
	'Get Variable' => 'Récupérer la variable',
	'Set Variable' => 'Spécifier la variable',
	'Set Variable Block' => 'Spécifier le bloc de variable',
	'Widget Set' => 'Groupe de widgets',
	'Publish Scheduled Entries' => 'Publier les notes planifiées',
	'Add Summary Watcher to queue' => 'Ajoute les voyeurs de résumés à la queue',
	'Junk Folder Expiration' => 'Expiration du répertoire de spam',
	'Remove Temporary Files' => 'Supprimer les fichiers temporaires',
	'Purge Stale Session Records' => 'Purger les enregistrements des sessions périmées',
	'Manage Website' => 'Gérer un site web',
	'Manage Blog' => 'Gérer un blog',
	'Manage Website with Blogs' => 'Gérer un site web avec des blogs',
	'Post Comments' => 'Commentaires de la note',
	'Create Entries' => 'Création d\'une note',
	'Edit All Entries' => 'Éditer toutes les entrées',
	'Manage Assets' => 'Gérer les Élements',
	'Manage Categories' => 'Gérer les catégories',
	'Change Settings' => 'Changer les paramètres',
	'Manage Address Book' => 'Gestion de l\'annuaire',
	'Manage Tags' => 'Gérer les tags',
	'Manage Templates' => 'Gérer les gabarits',
	'Manage Feedback' => 'Gérer les retours',
	'Manage Pages' => 'Gérer les pages',
	'Manage Users' => 'Gérer les utilisateurs',
	'Manage Themes' => 'Gérer les thèmes',
	'Publish Entries' => 'Publier les notes',
	'Save Image Defaults' => 'Enregistrer les paramètres d\'images par défaut',
	'Send Notifications' => 'Envoyer des notifications',
	'Set Publishing Paths' => 'Régler les chemins de publication',
	'View Activity Log' => 'Afficher le journal (logs)',
	'Create Blogs' => 'Créer des blogs',
	'Create Websites' => 'Créer des sites web',
	'Manage Plugins' => 'Gérer les plugins',
	'View System Activity Log' => 'Afficher le journal (logs) du système',

## lib/MT/DefaultTemplates.pm
	'Archive Index' => 'Index d\'archive',
	'Stylesheet' => 'Feuille de style',
	'JavaScript' => 'JavaScript',
	'Feed - Recent Entries' => 'Flux - Notes Récentes',
	'RSD' => 'RSD',
	'Monthly Entry Listing' => 'Liste des notes mensuelle',
	'Category Entry Listing' => 'Liste des notes catégorisées',
	'Comment Listing' => 'Liste des commentaires',
	'Improved listing of comments.' => 'Liste des commentaires améliorée',
	'Displays error, pending or confirmation message for comments.' => 'Affiche les erreurs et les messages de modération pour les commentaires.',
	'Comment Preview' => 'Pré visualisation du commentaire',
	'Displays preview of comment.' => 'Affiche la prévisualisation du commentaire.',
	'Dynamic Error' => 'Erreur dynamique',
	'Displays errors for dynamically published templates.' => 'Affiche les erreurs pour les modèles publiés dynamiquement.',
	'Popup Image' => 'Image dans une fenêtre popup',
	'Displays image when user clicks a popup-linked image.' => 'Affiche l\'image quand l\'utilisateur clique sur une image pop-up.',
	'Displays results of a search.' => 'Affiche les résultats d\'une recherche.',
	'About This Page' => 'À propos de cette page',
	'Archive Widgets Group' => 'Archive du groupe des Widgets',
	'Current Author Monthly Archives' => 'Archives Mensuelles de l\'Auteur Courant',
	'Calendar' => 'Calendrier',
	'Creative Commons' => 'Creative Commons',
	'Home Page Widgets Group' => 'Page d\'accueil du groupe des Widgets',
	'Monthly Archives Dropdown' => 'Liste déroulante des Archives Mensuelles',
	'Page Listing' => 'Liste des Pages',
	'Powered By' => 'Animé Par',
	'Syndication' => 'Syndication',
	'Technorati Search' => 'Recherche Technorati',
	'Date-Based Author Archives' => 'Archives des Auteurs par Dates',
	'Date-Based Category Archives' => 'Archives des Catégories par Dates',
	'OpenID Accepted' => 'OpenID Accepté',
	'Mail Footer' => 'Pied des mails',
	'Comment throttle' => 'Limitation des commentaires',
	'Commenter Confirm' => 'Confirmation du commentateur',
	'Commenter Notify' => 'Notification du commentateur',
	'New Comment' => 'Nouveau commentaire',
	'New Ping' => 'Nouveau ping',
	'Entry Notify' => 'Notification de note',
	'Subscribe Verify' => 'Vérification d\'inscription',

## lib/MT/ObjectTag.pm
	'Tag Placement' => 'Gestion des tags',
	'Tag Placements' => 'Gestions des tags',

## lib/MT/Author.pm
	'The approval could not be committed: [_1]' => 'L\'approbation ne peut être réalisée : [_1]',

## lib/MT/XMLRPC.pm
	'No WeblogsPingURL defined in the configuration file' => 'Pas de WeblogsPingURL défini dans le fichier de configuration',
	'No MTPingURL defined in the configuration file' => 'Pas de MTPingURL défini dans le fichier de configuration',
	'HTTP error: [_1]' => 'Erreur HTTP: [_1]',
	'Ping error: [_1]' => 'Erreur Ping: [_1]',

## lib/MT/ObjectAsset.pm
	'Asset Placement' => 'Gestion des objets',

## lib/MT/BackupRestore.pm
	'Backing up [_1] records:' => 'Sauvegarde des enregistrements [_1]:',
	'[_1] records backed up...' => '[_1] enregistrements sauvegardés...',
	'[_1] records backed up.' => '[_1] enregistrements sauvegardés.',
	'There were no [_1] records to be backed up.' => 'Il n\'y a pas d\'enregistrements [_1] à sauvegarder.',
	'Can\'t open directory \'[_1]\': [_2]' => 'Impossible d\'ouvrir le répertoire \'[_1]\' : [_2]',
	'No manifest file could be found in your import directory [_1].' => 'Aucun fichier manifest n\'a été trouvé dans votre répertoire d\'import [_1].',
	'Can\'t open [_1].' => 'Impossible d\'ouvrir [_1].',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'Le fichier manifest [_1] n\'est pas un fichier manifest de sauvegarde Movable Type.',
	'Manifest file: [_1]' => 'Fichier manifest : [_1]',
	'Path was not found for the file ([_1]).' => 'Le chemin n\'a pas été trouvé pour le fichier ([_1]).',
	'[_1] is not writable.' => '[_1] non éditable.',
	'Copying [_1] to [_2]...' => 'Copie de [_1] vers [_2]...',
	'Failed: ' => 'Échec: ',
	'Restoring asset associations ... ( [_1] )' => 'Restauration les associations d\'éléments ... ([_1])',
	'Restoring asset associations in entry ... ( [_1] )' => 'Restauration des associations d\'éléments dans la note ... ([_1])',
	'Restoring asset associations in page ... ( [_1] )' => 'Restauration des associations d\'éléments dans la page... ([_1])',
	'Restoring url of the assets ( [_1] )...' => 'Restauration de l\'url de l\'élément ([_1]) ...',
	'Restoring url of the assets in entry ( [_1] )...' => 'Restauration de l\'url de l\'élément dans la note ([_1]) ...',
	'Restoring url of the assets in page ( [_1] )...' => 'Restauration de l\'url de l\'élément dans la page ([_1]) ...',
	'ID for the file was not set.' => 'L\'ID pour le fichier n\'a pas été spécifié.',
	'The file ([_1]) was not restored.' => 'Le fichier ([_1]) n\'a pas été restauré.',
	'Changing path for the file \'[_1]\' (ID:[_2])...' => 'Changement du chemin du fichier \'[_1]\' (ID:[_2])...',

## lib/MT/TemplateMap.pm
	'Archive Mapping' => 'Table de correspondance des archives',
	'Archive Mappings' => 'Tables de correspondance des archives',

## lib/MT/ConfigMgr.pm
	'Alias for [_1] is looping in the configuration.' => 'L alias pour [_1] fait une boucle dans la configuration ',
	'Error opening file \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture du fichier \'[_1]\': [_2]',
	'Config directive [_1] without value at [_2] line [_3]' => 'Directive de Config  [_1] sans valeur sur [_2] ligne [_3]',
	'No such config variable \'[_1]\'' => 'Pas de variable de Config de ce type \'[_1]\'',

## lib/MT/Association.pm
	'Association' => 'Association',
	'association' => 'association',
	'associations' => 'associations',

## lib/MT/Blog.pm
	'First Blog' => 'Premier blog',
	'No default templates were found.' => 'Aucun gabarit par défaut trouvé.',
	'Cloned blog... new id is [_1].' => 'Le nouvel identifiant du blog cloné est [_1]',
	'Cloning permissions for blog:' => 'Clonage des autorisations du blog:',
	'[_1] records processed...' => '[_1] enregistrements effectués...',
	'[_1] records processed.' => '[_1] enregistrements effectués.',
	'Cloning associations for blog:' => 'Clonage des associations du blog:',
	'Cloning entries and pages for blog...' => 'Clonage des notes et pages du blog en cours...',
	'Cloning categories for blog...' => 'Clonage des catégories du blog...',
	'Cloning entry placements for blog...' => 'Clonage des placements de notes du blog...',
	'Cloning comments for blog...' => 'Clonage des commentaires de blog...',
	'Cloning entry tags for blog...' => 'Clonage des tags de notes du blog...',
	'Cloning TrackBacks for blog...' => 'Clonage des trackbacks du blog...',
	'Cloning TrackBack pings for blog...' => 'Clonage des pings de trackback du blog...',
	'Cloning templates for blog...' => 'Clonage des gabarits du blog...',
	'Cloning template maps for blog...' => 'Clonage des tables de correspondances de gabarit du blog...',
	'blog' => 'Blog',
	'blogs' => 'Blogs',
	'Failed to load theme [_1]: [_2]' => 'Echec lors du chargement du thème [_1] : [_2]',
	'Failed to apply theme [_1]: [_2]' => 'Echec lors de l\'application du thème [_1] : [_2]',

## lib/MT/TBPing.pm

## lib/MT/Builder.pm
	'<[_1]> at line [_2] is unrecognized.' => '<[_1]> à la ligne [_2] n\'est pas reconnu.',
	'<[_1]> with no </[_1]> on line #' => '<[_1]> sans </[_1]> à la ligne #',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]> sans </[_1]> à la ligne [_2].',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]> sans </[_1]> à la ligne [_2]',
	'Error in <mt[_1]> tag: [_2]' => 'Erreur dans le tag <mt[_1]> : [_2]',
	'Unknown tag found: [_1]' => 'Un tag inconnu a été trouvé : [_1]',

## lib/MT/ObjectScore.pm
	'Object Score' => 'Score Objet',
	'Object Scores' => 'Scores Objet',

## lib/MT/Website.pm

## lib/MT/Import.pm
	'Can\'t rewind' => 'Impossible de revenir en arrière',
	'No readable files could be found in your import directory [_1].' => 'Aucun fichier lisible n\'a été trouvé dans le répertoire d\'importation [_1].',
	'Importing entries from file \'[_1]\'' => 'Importation des notes du fichier \'[_1]\'',
	'Couldn\'t resolve import format [_1]' => 'Impossible de détecter le format d\'import [_1]',
	'Movable Type' => 'Movable Type',
	'Another system (Movable Type format)' => 'Autre système (format Movable Type)',

## lib/MT/Folder.pm

## lib/MT/Tag.pm
	'Tag must have a valid name' => 'Le tag doit avoir un nom valide',
	'This tag is referenced by others.' => 'Ce tag est référencé par d\'autres.',

## lib/MT/App.pm
	'Invalid request: corrupt character data for character set [_1]' => 'Requête invalide : les données de ces caractères sont corrompues pour ce jeu de caractères [_1]',
	'Error loading website #[_1] for user provisioning. Check your NewUserefaultWebsiteId setting.' => 'Erreur lors du chargement du site web #[_1] pour l\'approvisionnement de l\'utilisateur. Vérifiez vos paramètres NewUserefaultWebsiteId.',
	'First Weblog' => 'Premier Blog',
	'Error loading blog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => 'Erreur de chargement #[_1] concernant la création Utilisateur. Veuillez vérifier vos paramètres NewUserTemplateBlogId.',
	'Error provisioning blog for new user \'[_1]\' using template blog #[_2].' => 'Erreur de création du blog pour le nouvel utilisateur  \'[_1]\' utilisant le template #[_2].',
	'Error creating directory [_1] for blog #[_2].' => 'Erreur lors de la création de la liste [_1] pour le blog #[_2].',
	'Error provisioning blog for new user \'[_1] (ID: [_2])\'.' => 'Erreur de création du blog pour le nouvel utilisateur \'[_1] (ID: [_2])\'.',
	'Blog \'[_1] (ID: [_2])\' for user \'[_3] (ID: [_4])\' has been created.' => 'Le blog \'[_1] (ID: [_2])\' pour l\'utilisateur \'[_3] (ID: [_4])\' a été créé.',
	'Error assigning blog administration rights to user \'[_1] (ID: [_2])\' for blog \'[_3] (ID: [_4])\'. No suitable blog administrator role was found.' => 'Erreur d\'assignation des droits pour l\'utilisateur \'[_1] (ID: [_2])\' pour le blog \'[_3] (ID: [_4])\'. Aucun rôle d\'administrateur adéquat n\'a été trouvé.',
	'Internal Error: Login user is not initialized.' => 'Erreur interne : Identifiant utilisateur non initialisé.',
	'The login could not be confirmed because of a database error ([_1])' => 'L\'identifiant ne peut pas être confirmé en raison d\'une erreur de base de données ([_1])',
	'Our apologies, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Désolé mais vous n\'avez pas la permission d\'accéder aux blogs ou aux sites web de cette installation. Si vous pensez qu\'il s\'agit d\'une erreur, veuillez contacter votre administrateur système Movable Type.',
	'This account has been disabled. Please see your system administrator for access.' => 'Ce compte a été désactivé. Merci de contacter votre administrateur système.',
	'Failed login attempt by pending user \'[_1]\'' => 'Tentative d\'identification échouée par l\'utilisateur en attente \'[_1]\'',
	'This account has been deleted. Please see your system administrator for access.' => 'Ce compte a été supprimé. Merci de contacter votre administrateur système.',
	'User cannot be created: [_1].' => 'L\'utilisateur n\'a pu être créé: [_1].',
	'User \'[_1]\' has been created.' => 'L\'utilisateur \'[_1]\' a été créé ',
	'User \'[_1]\' (ID:[_2]) logged in successfully' => 'L\'utilisateur \'[_1]\' (ID:[_2]) s\'est identifié correctement',
	'Invalid login attempt from user \'[_1]\'' => 'Tentative d\'authentification invalide de l\'utilisateur \'[_1]\'',
	'User \'[_1]\' (ID:[_2]) logged out' => 'L\'utilisateur \'[_1]\' (ID:[_2]) s\'est déconnecté',
	'User requires password.' => 'L\'utilisateur doit avoir un mot de passe.',
	'User requires display name.' => 'L\'utilisateur doit avoir un nom public.',
	'User requires username.' => 'L\'utilisateur doit avoir un nom d\'utilisateur.',
	'Something wrong happened when trying to process signup: [_1]' => 'Un problème s\'est produit en essayant de soumettre l\'inscription: [_1]',
	'New Comment Added to \'[_1]\'' => 'Nouveau commentaire ajouté à \'[_1]\'',
	'The file you uploaded is too large.' => 'Le fichier téléchargé est trop lourd.',
	'Unknown action [_1]' => 'Action inconnue [_1]',
	'Warnings and Log Messages' => 'Mises en gardes et entrées du Journal (logs)',
	'Removed [_1].' => '[_1] supprimés.',

## lib/MT/Log.pm
	'Log message' => 'Message du journal',
	'Log messages' => 'Messages du journal',
	'Page # [_1] not found.' => 'Page # [_1] non trouvée.',
	'Entry # [_1] not found.' => 'Note # [_1] non trouvée.',
	'Comment # [_1] not found.' => 'Commentaire # [_1] non trouvé.',
	'TrackBack # [_1] not found.' => 'Trackback # [_1] non trouvé.',

## lib/MT/IPBanList.pm
	'IP Ban' => 'Interdiction IP',
	'IP Bans' => 'Interdictions IP',

## lib/MT/AtomServer.pm
	'[_1]: Entries' => '[_1]: Notes',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from atom api' => 'Note \'[_1]\' ([lc,_5] #[_2]) supprimée par \'[_3]\' (utilisateur #[_4]) depuis l\'api atom.',

## lib/MT/PluginData.pm
	'Plugin Data' => 'Données Plugin',

## lib/MT/Plugin.pm
	'Publish' => 'Publier',
	'My Text Format' => 'Format de mon texte.',

## lib/MT/Entry.pm
	'record does not exist.' => 'l\'enregistrement n\'existe pas.',
	'Draft' => 'Brouillon',
	'Review' => 'Vérification',
	'Future' => 'Futur',
	'Spam' => 'Spam',
	'Status' => 'Statut',
	'Accept Comments' => 'Accepter les commentaires',
	'Body' => 'Corps',
	'Extended' => 'Etendu',
	'Format' => 'Format',
	'Accept Trackbacks' => 'Accepter trackbacks',
	'Publish Date' => 'Date de publication',

## lib/MT/Config.pm
	'Configuration' => 'Configuration',

## lib/MT/Template.pm
	'Template' => 'gabarit',
	'Error reading file \'[_1]\': [_2]' => 'Erreur à la lecture du fichier \'[_1]\': [_2]',
	'Publish error in template \'[_1]\': [_2]' => 'Erreur de publication dans le gabarit \'[_1]\': [_2]',
	'Template with the same name already exists in this blog.' => 'Un gabarit avec le même nom existe déjà dans ce blog.',
	'You cannot use a [_1] extension for a linked file.' => 'Vous ne pouvez pas utiliser l\'extension [_1] pour un fichier joint.',
	'Opening linked file \'[_1]\' failed: [_2]' => 'L\'ouverture du fichier lié \'[_1]\' a échoué : [_2] ',
	'Index' => 'Index',
	'Category Archive' => 'Archive de catégorie',
	'Ping Listing' => 'Liste des pings',
	'Comment Error' => 'Erreur de commentaire',
	'Uploaded Image' => 'Image chargée',
	'Module' => 'Module',
	'Widget' => 'Widget',
	'Output File' => 'Fichier de sortie',
	'Template Text' => 'Texte de gabarit',
	'Rebuild with Indexes' => 'Republier avec les index',
	'Dynamicity' => 'Dynamiquement',
	'Build Type' => 'Type de publication',
	'Interval' => 'Interval',

## lib/MT/ImportExport.pm
	'No Blog' => 'Pas de Blog',
	'Need either ImportAs or ParentAuthor' => 'ImportAs ou ParentAuthor sont nécessaires',
	'Creating new user (\'[_1]\')...' => 'Création d\'un nouvel utilisateur (\'[_1]\')...',
	'Saving user failed: [_1]' => 'Échec lors de la sauvegarde de l\'utilisateur : [_1]',
	'Assigning permissions for new user...' => 'Mise en place des autorisations pour le nouvel utilisateur...',
	'Saving permission failed: [_1]' => 'Échec lors de la sauvegarde des droits des utilisateurs : [_1]',
	'Creating new category (\'[_1]\')...' => 'Création d\'une nouvelle catégorie (\'[_1]\')...',
	'Saving category failed: [_1]' => 'Échec lors de la sauvegarde des catégories : [_1]',
	'Invalid status value \'[_1]\'' => 'Valeur du statut invalide \'[_1]\'',
	'Invalid allow pings value \'[_1]\'' => 'Valeur du ping invalide\'[_1]\'',
	'Can\'t find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.' => 'Impossible de trouver une note avec la date \'[_1]\'... abandon de ces commentaires, et passage à la note suivante.',
	'Importing into existing entry [_1] (\'[_2]\')' => 'Importation dans la note existante [_1] (\'[_2]\')',
	'Saving entry (\'[_1]\')...' => 'Enregistrement de la note (\'[_1]\')...',
	'ok (ID [_1])' => 'ok (ID [_1])',
	'Saving entry failed: [_1]' => 'Échec lors de la sauvegarde de la Note: [_1]',
	'Creating new comment (from \'[_1]\')...' => 'Création d\'un nouveau commentaire (de \'[_1]\')...',
	'Saving comment failed: [_1]' => 'Échec lors de la sauvegarde du commentaire : [_1]',
	'Entry has no MT::Trackback object!' => 'La note n\'a pas d\'objet MT::Trackback !',
	'Creating new ping (\'[_1]\')...' => 'Création d\'un nouveau ping (\'[_1]\')...',
	'Saving ping failed: [_1]' => 'Échec lors de la sauvegarde du ping : [_1]',
	'Export failed on entry \'[_1]\': [_2]' => 'Échec lors de l\'exportation sur la Note \'[_1]\' : [_2]',
	'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Format de date invalide \'[_1]\'; doit être \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM est optionnel)',

## lib/MT/Revisable.pm
	'Bad RevisioningDriver config \'[_1]\': [_2]' => 'Mauvaise configuration de pilote de révision \'[_1]\': [_2]',
	'Revision not found: [_1]' => 'Révision non trouvée : [_1]',
	'There aren\'t the same types of objects, expecting two [_1]' => 'Ils ne sont pas les mêmes types d\'objets, deux [_2] sont attendus',
	'Did not get two [_1]' => 'N\'a pas pu obtenir deux [_1]',
	'Unknown method [_1]' => 'Méthode [_1] inconnue',
	'Revision Number' => 'Numéro de révision',

## lib/MT/JunkFilter.pm
	'Action: Junked (score below threshold)' => 'Action : Indésirable (score ci-dessous)',
	'Action: Published (default action)' => 'Action : Publié (action par défaut)',
	'Junk Filter [_1] died with: [_2]' => 'Filtre indésirable [_1] mort avec : [_2]',
	'Unnamed Junk Filter' => 'Filtre indésirable sans nom',
	'Composite score: [_1]' => 'Score composite : [_1]',

## lib/MT/Util.pm
	'moments from now' => 'maintenant',
	'[quant,_1,hour,hours] from now' => 'dans [quant,_1,heure,heures]',
	'[quant,_1,minute,minutes] from now' => 'dans [quant,_1,minute,minutes]',
	'[quant,_1,day,days] from now' => 'dans [quant,_1,jour,jours]',
	'less than 1 minute from now' => 'moins d\'une minute à partir de maintenant',
	'less than 1 minute ago' => 'il y a moins d\'une minute',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => 'dans [quant,_1,heure,heures], [quant,_2,minute,minutes]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => 'il y a [quant,_1,heure,heures], [quant,_2,minute,minutes]',
	'[quant,_1,day,days], [quant,_2,hour,hours] from now' => 'dans [quant,_1,jour,jours], [quant,_2,heure,heures]',
	'[quant,_1,day,days], [quant,_2,hour,hours] ago' => 'il y a [quant,_1,jour,jours], [quant,_2,heure,heures]',
	'[quant,_1,second,seconds] from now' => 'dans [quant,_1,seconde,secondes]',
	'[quant,_1,second,seconds]' => '[quant,_1,seconde,secondes]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => 'dans [quant,_1,minute,minutes], [quant,_2,seconde,secondes]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,minute,minutes], [quant,_2,seconde,secondes]',
	'[quant,_1,minute,minutes]' => '[quant,_1,minute,minutes]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,heure,heures], [quant,_2,minute,minutes]',
	'[quant,_1,hour,hours]' => '[quant,_1,heure,heures]',
	'[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,jour,jours], [quant,_2,heure,heures]',
	'[quant,_1,day,days]' => '[quant,_1,jour,jours]',
	'Invalid domain: \'[_1]\'' => 'Domaine invalide : \'[_1]\'',

## lib/MT/Mail.pm
	'Unknown MailTransfer method \'[_1]\'' => 'Méthode de transfert de mail inconnu \'[_1]\'',
	'Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]' => 'Pour envoyer des mails via SMTP, votre serveur doit avoir Mail::Sendmail installé: [_1]',
	'Error sending mail: [_1]' => 'Erreur lors de l\'envoi du mail : [_1]',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'Vous n\'avez pas un chemin valide vers sendmail sur votre machine. Peut-être devriez-vous essayer en utilisant SMTP?',
	'Exec of sendmail failed: [_1]' => 'Échec lors de l\'exécution de sendmail : [_1]',

## lib/MT.pm
	'Powered by [_1]' => 'Powered by [_1]',
	'Version [_1]' => 'Version [_1]',
	'http://www.sixapart.com/movabletype/' => 'http://www.movabletype.com/',
	'Hello, world' => 'Bonjour',
	'Hello, [_1]' => 'Bonjour, [_1]',
	'Message: [_1]' => 'Message: [_1]',
	'If present, 3rd argument to add_callback must be an object of type MT::Component or MT::Plugin' => 'Si présent, le 3ème argument de add_callback doit être un objet de type MT::Component ou MT:Plugin',
	'4th argument to add_callback must be a CODE reference.' => '4ème argument de add_callback doit être une référence de CODE.',
	'Two plugins are in conflict' => 'Deux plugins sont en conflit',
	'Invalid priority level [_1] at add_callback' => 'Niveau de priorité invalide [_1] dans add_callback',
	'Unnamed plugin' => 'Plugin sans nom',
	'[_1] died with: [_2]' => '[_1] mort avec: [_2]',
	'Bad ObjectDriver config' => 'Mauvaise config ObjectDriver',
	'Bad CGIPath config' => 'Mauvaise config CGIPath',
	'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Fichier de configuration manquant. Avez-vous oublié de déplacer mt-config.cgi-original vers mt-config.cgi?',
	'Plugin error: [_1] [_2]' => 'Erreur de Plugin: [_1] [_2]',
	'Loading template \'[_1]\' failed.' => 'Le chargement du template \'[_1]\' a échoué.',
	'http://www.movabletype.org/documentation/' => 'http://www.movabletype.org/documentation/',
	'OpenID' => 'OpenID',
	'LiveJournal' => 'LiveJournal',
	'Vox' => 'Vox',
	'Google' => 'Google',
	'Yahoo!' => 'Yahoo!',
	'AIM' => 'AIM',
	'WordPress.com' => 'WordPress.com',
	'TypePad' => 'TypePad',
	'Yahoo! JAPAN' => 'Yahoo! Japon',
	'livedoor' => 'livedoor',
	'Hatena' => 'Hatena',
	'Movable Type default' => 'Valeur par défaut Movable Type',

## mt-static/jquery/jquery.mt.js

## mt-static/js/tc/mixer/display.js
	'Title:' => 'Titre :',
	'Description:' => 'Description :',
	'Author:' => 'Auteur :',
	'Tags:' => 'Tags :',
	'URL:' => 'URL :',

## mt-static/js/dialog.js
	'(None)' => '(Aucun)',

## mt-static/js/assetdetail.js
	'No Preview Available' => 'Pas de pré-visualisation possible',
	'View uploaded file' => 'Voir le fichier envoyé',

## mt-static/mt.js
	'delete' => 'supprimer',
	'remove' => 'retirer',
	'enable' => 'activer',
	'disable' => 'désactiver',
	'You did not select any [_1] to [_2].' => 'Vous n\'avez pas sélectionné de [_1] à [_2].',
	'Are you sure you want to [_2] this [_1]?' => 'Êtes-vous sûr(e) de vouloir [_2] : [_1]?',
	'Are you sure you want to [_3] the [_1] selected [_2]?' => 'Êtes-vous sûr(e) de vouloir [_3] les [_1] [_2] sélectionné(e)s?',
	'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => 'Êtes-vous sûr(e) de vouloir supprimer ce rôle. En faisant cela vous allez supprimer les autorisations de tous les utilisateurs et groupes associés à ce rôle.',
	'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => 'Êtes-vous sûr(e) de vouloir supprimer les rôles [_1] ? Avec cette actions vous allez supprimer les autorisations associées à tous les utilisateurs et groupes liés à ce rôle.',
	'You did not select any [_1] [_2].' => 'Vous n\'avez pas sélectionné de [_1] [_2].',
	'You can only act upon a minimum of [_1] [_2].' => 'Vous ne pouvez agir que sur un minimum de [_1] [_2].',
	'You can only act upon a maximum of [_1] [_2].' => 'Vous ne pouvez agir que sur un maximum de [_1] [_2].',
	'You must select an action.' => 'Vous devez sélectionner une action.',
	'to mark as spam' => 'pour classer comme spam',
	'to remove spam status' => 'pour retirer le statut de spam',
	'Enter email address:' => 'Saisissez l\'adresse email :',
	'Enter URL:' => 'Saisissez l\'URL :',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\'?' => 'Le tag \'[_2]\' existe déjà. Êtes-vous sûr(e) de vouloir fusionner \'[_1]\' avec \'[_2]\'?',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all weblogs?' => 'Le tag \'[_2]\' existe déjà. Êtes-vous sûr(e) de vouloir fusionner \'[_1]\' avec \'[_2]\' sur tous les blogs?',
	'Loading...' => 'Chargement...',
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] de [_3]',
	'[_1] &ndash; [_2]' => '[_1] &ndash; [_2]',

## themes/classic_website/templates/notify-entry.mtml

## themes/classic_website/templates/main_index.mtml

## themes/classic_website/templates/page.mtml

## themes/classic_website/templates/main_index_widgets_group.mtml

## themes/classic_website/templates/entry_summary.mtml

## themes/classic_website/templates/comment_response.mtml

## themes/classic_website/templates/commenter_notify.mtml

## themes/classic_website/templates/footer-email.mtml

## themes/classic_website/templates/verify-subscribe.mtml

## themes/classic_website/templates/new-ping.mtml

## themes/classic_website/templates/comment_detail.mtml

## themes/classic_website/templates/syndication.mtml
	'Subscribe to this website\'s feed' => 'Souscrire au flux du site web',

## themes/classic_website/templates/recent_comments.mtml

## themes/classic_website/templates/technorati_search.mtml

## themes/classic_website/templates/comment_throttle.mtml

## themes/classic_website/templates/signin.mtml

## themes/classic_website/templates/new-comment.mtml

## themes/classic_website/templates/pages_list.mtml

## themes/classic_website/templates/about_this_page.mtml

## themes/classic_website/templates/entry.mtml

## themes/classic_website/templates/recover-password.mtml

## themes/classic_website/templates/javascript.mtml

## themes/classic_website/templates/trackbacks.mtml

## themes/classic_website/templates/recent_entries.mtml

## themes/classic_website/templates/sidebar.mtml

## themes/classic_website/templates/openid.mtml

## themes/classic_website/templates/banner_footer.mtml

## themes/classic_website/templates/comments.mtml

## themes/classic_website/templates/search_results.mtml

## themes/classic_website/templates/comment_listing.mtml

## themes/classic_website/templates/creative_commons.mtml

## themes/classic_website/templates/dynamic_error.mtml

## themes/classic_website/templates/powered_by.mtml

## themes/classic_website/templates/tag_cloud.mtml

## themes/classic_website/templates/recent_assets.mtml

## themes/classic_website/templates/comment_preview.mtml

## themes/classic_website/templates/search.mtml

## themes/classic_website/templates/blogs.mtml

## themes/classic_website/templates/commenter_confirm.mtml

## themes/classic_website/theme.yaml
	'Create a blog portal that aggregates contents from blogs under the website.' => 'Créer un portail de blogs qui aggrège le contenu de différents blogs du dit site web.',
	'Classic Website' => 'Site web classique',
	'Feed - Recent Entries\'' => 'Flux - Notes récentes\'',
	'Displays error, pending or confirmation message for comments.\'' => 'Affiche les erreur, messages de confirmations et d\'attente de validation des commentaires.\'',
	'2-column layout - Sidebar\'' => 'Format 2 colonnes - Colonne latérale\'',
	'3-column layout - Primary Sidebar\'' => 'Format 3 colonnes - Première colonne latérale\'',
	'3-column layout - Secondary Sidebar\'' => 'Format 3 colonnes- Seconde colonne latérale\'',

## themes/classic_blog/templates/tag_cloud.mtml

## themes/classic_blog/templates/monthly_archive_dropdown.mtml

## themes/classic_blog/templates/notify-entry.mtml

## themes/classic_blog/templates/recent_assets.mtml

## themes/classic_blog/templates/category_archive_list.mtml

## themes/classic_blog/templates/current_author_monthly_archive_list.mtml

## themes/classic_blog/templates/main_index.mtml

## themes/classic_blog/templates/page.mtml

## themes/classic_blog/templates/comment_preview.mtml

## themes/classic_blog/templates/main_index_widgets_group.mtml

## themes/classic_blog/templates/entry_summary.mtml

## themes/classic_blog/templates/comment_response.mtml

## themes/classic_blog/templates/commenter_notify.mtml

## themes/classic_blog/templates/footer-email.mtml

## themes/classic_blog/templates/archive_widgets_group.mtml

## themes/classic_blog/templates/verify-subscribe.mtml

## themes/classic_blog/templates/new-ping.mtml

## themes/classic_blog/templates/syndication.mtml

## themes/classic_blog/templates/comment_detail.mtml

## themes/classic_blog/templates/author_archive_list.mtml

## themes/classic_blog/templates/current_category_monthly_archive_list.mtml

## themes/classic_blog/templates/recent_comments.mtml

## themes/classic_blog/templates/technorati_search.mtml

## themes/classic_blog/templates/monthly_archive_list.mtml

## themes/classic_blog/templates/category_entry_listing.mtml

## themes/classic_blog/templates/comment_throttle.mtml

## themes/classic_blog/templates/signin.mtml

## themes/classic_blog/templates/new-comment.mtml

## themes/classic_blog/templates/pages_list.mtml

## themes/classic_blog/templates/about_this_page.mtml

## themes/classic_blog/templates/entry.mtml

## themes/classic_blog/templates/recover-password.mtml

## themes/classic_blog/templates/javascript.mtml

## themes/classic_blog/templates/archive_index.mtml

## themes/classic_blog/templates/trackbacks.mtml

## themes/classic_blog/templates/calendar.mtml

## themes/classic_blog/templates/recent_entries.mtml

## themes/classic_blog/templates/sidebar.mtml

## themes/classic_blog/templates/openid.mtml

## themes/classic_blog/templates/date_based_author_archives.mtml

## themes/classic_blog/templates/banner_footer.mtml

## themes/classic_blog/templates/comments.mtml

## themes/classic_blog/templates/search_results.mtml

## themes/classic_blog/templates/comment_listing.mtml

## themes/classic_blog/templates/date_based_category_archives.mtml

## themes/classic_blog/templates/dynamic_error.mtml

## themes/classic_blog/templates/creative_commons.mtml

## themes/classic_blog/templates/powered_by.mtml

## themes/classic_blog/templates/monthly_entry_listing.mtml

## themes/classic_blog/templates/search.mtml

## themes/classic_blog/templates/commenter_confirm.mtml

## themes/classic_blog/theme.yaml
	'Typical and authentic blogging design comes with plenty of styles and the selection of 2 column / 3 column layout. Best for all the bloggers.' => 'Les habillages de blogs sont généralement conçu pour un format de 2 ou 3 colonnes. Cela convient à la plupart des blogeurs.',

## search_templates/default.tmpl
	'SEARCH FEED AUTODISCOVERY LINK PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'LE LIEN DU FLUX DE LA RECHERCHE AUTOMATISÉE EST PUBLIÉ UNIQUEMENT APRES L\'EXÉCUTION D\'UNE RECHERCHE.',
	'Blog Search Results' => 'Résultats de la recherche',
	'Blog search' => 'Recherche de Blog',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'LES RECHERCHES SIMPLES ONT LE FORMULAIRE DE RECHERCHES',
	'Search this site' => 'Rechercher sur ce site',
	'Match case' => 'Respecter la casse',
	'SEARCH RESULTS DISPLAY' => 'AFFICHAGE DES RESULTATS DE LA RECHERCHE',
	'Matching entries from [_1]' => 'Notes correspondant à [_1]',
	'Entries from [_1] tagged with \'[_2]\'' => 'Notes à partir de [_1] taguées avec \'[_2]\'',
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Posté <MTIfNonEmpty tag="EntryAuthorDisplayName">par [_1] </MTIfNonEmpty>le [_2]',
	'Showing the first [_1] results.' => 'Afficher les premiers [_1] resultats.',
	'NO RESULTS FOUND MESSAGE' => 'MESSAGE AUCUN RÉSULTAT',
	'Entries matching \'[_1]\'' => 'Notes correspondant à \'[_1]\'',
	'Entries tagged with \'[_1]\'' => 'Notes taguées avec \'[_1]\'',
	'No pages were found containing \'[_1]\'.' => 'Aucune page trouvée contenant \'[_1]\'.',
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes' => 'Par défaut, ce moteur de recherche analyse l\'ensemble des mots sans se préoccuper de leur ordre. Pour lancer une recherche sur une phrase exacte, insérez-la entre guillemets.',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions' => 'Le moteur de recherche admet aussi AND, OR et NOT mais pas des mots clefs pour spécifier des expressions particulières',
	'END OF ALPHA SEARCH RESULTS DIV' => 'FIN DE LA RECHERCHE ALPHA RESULTATS DIV',
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'DEBUT DE LA COLONNE BETA POUR AFFICHAGE DES INFOS DE RECHERCHE',
	'SET VARIABLES FOR SEARCH vs TAG information' => 'DEFINIT LES VARIABLES DE RECHERCHE vs informations TAGS',
	'If you use an RSS reader, you can subscribe to a feed of all future entries tagged \'[_1]\'.' => 'Si vous utilisez un lecteur de flux RSS, vous pouvez souscrire au flux de toutes notes futures dont le tag sera \'[_1]\'.',
	'If you use an RSS reader, you can subscribe to a feed of all future entries matching \'[_1]\'.' => 'Si vous utilisez un lecteur de flux RSS, vous pouvez souscrire au flux des futures notes contenant le mot \'[_1]\'.',
	'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'RECHERCHE/INFORMATION D\'ABONNEMENT AU FLUX',
	'Feed Subscription' => 'Abonnement au flux',
	'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds',
	'What is this?' => 'De quoi s\'agit-il?',
	'TAG LISTING FOR TAG SEARCH ONLY' => 'LISTE DES TAGS UNIQUEMENT POUR LA RECHERCHE DE TAG',
	'Other Tags' => 'Autres tags',
	'END OF PAGE BODY' => 'FIN DU CORPS DE LA PAGE',
	'END OF CONTAINER' => 'FIN DU CONTENU',

## search_templates/results_feed.tmpl
	'Search Results for [_1]' => 'Résultats de la recherche sur [_1]',

## search_templates/comments.tmpl
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
	'Find new comments' => 'Voir les nouveaux commentaires',
	'Posted in [_1] on [_2]' => 'Publié dans [_1] le [_2]',
	'No results found' => 'Aucun résultat n\'a été trouvé',
	'No new comments were found in the specified interval.' => 'Aucun nouveau commentaire n\'a été trouvé dans la période spécifiée.',
	'Select the time interval that you\'d like to search in, then click \'Find new comments\'' => 'Sélectionner l\'intervalle de temps désiré pour la recherche, puis cliquez sur \'Voir les nouveaux commentaires\'',

## search_templates/results_feed_rss2.tmpl

## tmpl/wizard/optional.tmpl
	'Mail Configuration' => 'Configuration Mail',
	'Your mail configuration is complete.' => 'Votre configuration email est complète.',
	'Check your email to confirm receipt of a test email from Movable Type and then proceed to the next step.' => 'Vérifiez votre adresse email pour confirmer la réception d\'un email de test de Movable Type et ensuite passez à l\'étape suivante.',
	'Continue' => 'Continuer',
	'Back' => 'Retour',
	'Show current mail settings' => 'Montrer les paramètres d\'email actuels',
	'Periodically Movable Type will send email to inform users of new comments as well as other other events. For these emails to be sent properly, you must instruct Movable Type how to send email.' => 'Movable Type va envoyer périodiquement des emails afin d\'informer les utilisateurs des nouveaux commentaires et autres événements. Pour que ces emails puissent être envoyés correctement, veuillez spécifier la méthode que Movable Type va utiliser.',
	'An error occurred while attempting to send mail: ' => 'Une erreur s\'est produite en essayant d\'envoyer un email: ',
	'Send email via:' => 'Envoyer email via :',
	'Select One...' => 'Sélectionner un...',
	'sendmail Path' => 'Chemin sendmail',
	'The physical file path for your sendmail binary.' => 'Le chemin du fichier physique de votre binaire sendmail.',
	'Outbound Mail Server (SMTP)' => 'Serveur email sortant (SMTP)',
	'Address of your SMTP Server.' => 'Adresse de votre serveur SMTP.',
	'Mail address to which test email should be sent' => 'L\'adresse e-mail à laquelle l\'e-mail de test devrait être envoyé',
	'From mail address' => 'E-mail expéditeur',
	'Send Test Email' => 'Envoyer un e-mail de test',

## tmpl/wizard/complete.tmpl
	'Configuration File' => 'Fichier de configuration',
	'The [_1] configuration file can\'t be located.' => 'Le fichier de configuration [_1] n\'a pas pu être trouvé',
	'Please use the configuration text below to create a file named \'mt-config.cgi\' in the root directory of [_1] (the same directory in which mt.cgi is found).' => 'Créez un fichier nommé dans le répertoire racine de [_1] (le même qui contient mt.cgi) ayant pour contenu le texte de configuration ci-dessous.',
	'The wizard was unable to save the [_1] configuration file.' => 'L\'assistant n\'a pas pu enregistrer le fichier de configuration [_1]',
	'Confirm that your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click \'Retry\'.' => 'Vérifiez que votre répertoire [_1] d\'accueil (celui contenant mt.cgi) est ouvert en écriture pour le serveur web et cliquez sur \'Ré-essayer\'.',
	'Congratulations! You\'ve successfully configured [_1].' => 'Félicitations ! Vous avez configuré [_1] avec succès.',
	'Your configuration settings have been written to the following file:' => 'Vos paramètres de configuration ont été écrits dans le fichier suivant:',
	'To change the settings, click the \'Back\' button below.' => 'Pour modifier les paramètres, cliquez sur le bouton \'Précédent\' ci-dessous.',
	'Show the mt-config.cgi file generated by the wizard' => 'Afficher le fichier mt-config.cgi généré par l\'assistant',
	'The mt-config.cgi file has been created manually.' => 'Le fichier mt-config.cgi a été créé manuellement.',
	'Retry' => 'Recommencer',

## tmpl/wizard/cfg_dir.tmpl
	'Temporary Directory Configuration' => 'Configuration du répertoire temporaire',
	'You should configure you temporary directory settings.' => 'Vous devriez configurer les paramètres de votre répertoire temporaire.',
	'Your TempDir has been successfully configured. Click \'Continue\' below to continue configuration.' => 'Votre Tempdir a été correctement configuré. Cliquez sur \'Continuer\' ci-dessous pour continuer la configuration.',
	'[_1] could not be found.' => '[_1] introuvable.',
	'TempDir is required.' => 'TempDir est requis.',
	'TempDir' => 'TempDir',
	'The physical path for temporary directory.' => 'Chemin physique pour le répertoire temporaire.',
	'Test' => 'Test',

## tmpl/wizard/start.tmpl
	'Welcome to Movable Type' => 'Bienvenue dans Movable Type',
	'Configuration File Exists' => 'Le fichier de configuration existe',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Pour utiliser Movable Type, vous devez activer les JavaScript sur votre navigateur. Merci de les activer et de relancer le navigateur pour commencer.',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Vous allez maintenant, grâce à cet assistant de configuration, mettre en place les paramètres de base afin d\'assurer le fonctionnement de Movable Type.',
	'Language' => 'Langue',
	'Default language.' => 'Langue par défaut.',
	'<strong>Error: \'[_1]\' could not be found.</strong>  Please move your static files to the directory first or correct the setting if it is incorrect.' => '<strong>Erreur: \'[_1]\' ne peut pas être trouvé.</strong>  Veuillez d\'abord déplacer vos fichiers statiques dans le répertoire ou corriger les paramètres s\'ils sont incorrects.',
	'Configure Static Web Path' => 'Configurer le chemin web statique',
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type est fourni avec un répertoire nommé [_1] contenant un nombre important de fichiers comme des images, fichiers javascripts et feuilles de style.',
	'The [_1] directory is in the main Movable Type directory which this wizard script resides, but due to your web server\'s configuration, the [_1] directory is not accessible in this location and must be moved to a web-accessible location (e.g., your web document root directory).' => 'Le répertoire [_1] est le répertoire principal de Movable Type contenant les scripts de cet assistant, mais à cause de la configuration de votre serveur web, le répertoire [_1] n\'est pas accessible à cette adresse et doit être déplacé vers un serveur web (par exemple, le répertoire document à la racine). ',
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Ce répertoire a été renommé ou déplacé en dehors du répertoire Movable Type.',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => 'Déplacez ou créez un lien symbolique du répertoire [_1] dans un endroit accessible depuis le web et spécifiez le chemin web statique dans le champs ci-dessous.',
	'This URL path can be in the form of [_1] or simply [_2]' => 'Ce chemin d\'URL peut être de la forme [_1] ou simplement [_2]',
	'This path must be in the form of [_1]' => 'Ce chemin doit être de la forme [_1]',
	'Static web path' => 'Chemin web statique',
	'Static file path' => 'Chemin fichier statique',
	'Begin' => 'Commencer',
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => 'Un fichier de configuration (mt-config.cgi) existe déjà, <a href="[_1]">identifiez-vous</a> dans Movable Type.',
	'To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page' => 'Pour créer un nouveau fichier de configuration avec l\'assistant, supprimez le fichier de configuration actuel puis rechargez cette page',

## tmpl/wizard/packages.tmpl
	'Requirements Check' => 'Vérifications des éléments nécessaires',
	'The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your blog\'s data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the \'Retry\' button.' => 'Les modules Perl suivants sont nécessaires pour réaliser une connexion à une base de données.  Movable Type nécessite une base de données pour stocker les données de votre blog.  Merci d\'installer un des packages listés ici avant de continuer.  quand vous êtes prêt, cliquez sur le bouton \'Réessayer\'.',
	'All required Perl modules were found.' => 'Tous les modules Perl obligatoires ont été trouvés.',
	'You are ready to proceed with the installation of Movable Type.' => 'Vous êtes prêt à procéder à l\'installation de Movable Type.',
	'Some optional Perl modules could not be found. <a href="javascript:void(0)" onclick="[_1]">Display list of optional modules</a>' => 'Certains modules Perl optionnels ne peuvent être trouvés. <a href="javascript:void(0)" onclick="[_1]">Afficher la liste des modules optionnels</a>',
	'One or more Perl modules required by Movable Type could not be found.' => 'Un ou plusieurs modules Perl nécessaires pour Movable Type n\'ont pu être trouvés.',
	'The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the \'Retry\' button to re-test for these packages.' => 'Les modules Perl suivants sont nécessaires au bon fonctionnement de Movable Type. Dès que vous disposez de ces éléments, cliquez sur le bouton \'Recommencer\' pour vérifier ces éléments..',
	'Some optional Perl modules could not be found. You may continue without installing these optional Perl modules. They may be installed at any time if they are needed. Click \'Retry\' to test for the modules again.' => 'Certains modules Perl optionnels n\'ont pu être trouvés. Vous pouvez continuer sans installer ces modules Perl. Ils peuvent être installés n\'importe quand si besoin. Cliquez \'Réessayer\' pour tester à nouveau ces modules.',
	'Missing Database Modules' => 'Modules de base de données manquants',
	'Missing Optional Modules' => 'Modules optionnels manquants',
	'Missing Required Modules' => 'Modules nécessaires absents',
	'Minimal version requirement: [_1]' => 'Version minimale nécessaire : [_1]',
	'Learn more about installing Perl modules.' => 'Plus d\'informations sur l\'installation de modules Perl.',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'Votre serveur possède tous les modules nécessaires; vous n\'avez pas à procéder à des installations complémentaires de modules',

## tmpl/wizard/configure.tmpl
	'Database Configuration' => 'Configuration de la Base de Données',
	'Details' => 'Détails',
	'Your database configuration is complete.' => 'Votre configuration de base de données est terminée.',
	'You may proceed to the next step.' => 'Vous pouvez passer à l\'étape suivante.',
	'Please enter the parameters necessary for connecting to your database.' => 'Merci de saisir les paramètres nécessaires pour se connecter à votre base de données.',
	'Show Current Settings' => 'Montrer les paramètres actuels',
	'Database Type' => 'Type de base de données',
	'http://www.movabletype.org/documentation/[_1]' => 'http://www.movabletype.org/documentation/[_1]',
	'Is your preferred database not listed? View the <a href="[_1]" target="_blank">Movable Type System Check</a> see if additional modules are necessary.' => 'Votre base de données préférée n\'est pas listée ? Regardez <a href="[_1]" target="_blank">Movable Type System Check</a> pour voir s\'il y a des modules additionnels nécessaires pour permettre son utilisation.',
	'Once installed, <a href="javascript:void(0)" onclick="[_1]">click here to refresh this screen</a>.' => 'Une fois installé, <a href="javascript:void(0)" onclick="[_1]">cliquez ici pour réactualiser cette page</a>.',
	'Read more: <a href="[_1]" target="_blank">Setting Up Your Database</a>' => 'Apprenez-en plus : <a href="[_1]" target="_blank">Configurez votre base de données</a>',
	'Database Path' => 'Chemin de la Base de Données',
	'The physical file path for your SQLite database. ' => 'Le chemin du fichier physique de votre base de données SQLite. ',
	'A default location of \'./db/mt.db\' will store the database file underneath your Movable Type directory.' => 'Un endroit par défaut \'./db/mt.db\' stockera le fichier de base de données dans votre répertoire Movable Type.',
	'Database Server' => 'Serveur de Base de données',
	'This is usually \'localhost\'.' => 'C\'est généralement \'localhost\'.',
	'Database Name' => 'Nom de la Base de données',
	'The name of your SQL database (this database must already exist).' => 'Le nom de votre Base de données SQL (cette base de données doit être déjà présente).',
	'The username to login to your SQL database.' => 'Le nom d\'utilisateur pour accéder à la Base de données SQL.',
	'Password' => 'Mot de passe',
	'The password to login to your SQL database.' => 'Le mot de passe pour accéder à la Base de données SQL.',
	'Show Advanced Configuration Options' => 'Montrer les options avancées de configuration',
	'Database Port' => 'Port de la Base de données',
	'This can usually be left blank.' => 'Peut être laissé vierge.',
	'Database Socket' => 'Socket de la Base de données',
	'Publish Charset' => 'Publier le  Charset',
	'MS SQL Server driver must use either Shift_JIS or ISO-8859-1.  MS SQL Server driver does not support UTF-8 or any other character set.' => 'Le driver  Serveur MS SQL doit utiliser Shift_JIS ou ISO-8859-1.  Le driver serveur MS SQL ne supporte pas UTF-8 ou tout autre jeu de caractères.',
	'Test Connection' => 'Test de Connexion',
	'You must set your Database Path.' => 'Vous devez définir le Chemin de Base de Données.',
	'You must set your Username.' => 'Vous devez définir votre nom d\'utilisateur.',
	'You must set your Database Server.' => 'Vous devez définir votre serveur de Base de données.',

## tmpl/wizard/blog.tmpl
	'Setup Your First Blog' => 'Configurer votre premier blog',
	'In order to properly publish your blog, you must provide Movable Type with your blog\'s URL and the path on the filesystem where its files should be published.' => 'Pour pouvoir publier correctement votre blog, vous devez fournir à Movable Type l\'URL du blog et le chemin sur le disque où les fichiers doivent être publiés.',
	'My First Blog' => 'Mon Premier Blog',
	'Publishing Path' => 'Chemin de publication',
	'Your \'Publishing Path\' is the path on your web server\'s file system where Movable Type will publish all the files for your blog. Your web server must have write access to this directory.' => 'Votre \'Chemin de publication\' est le chemin sur le disque de votre serveur web où Movable Type va publier tous les fichiers de votre blog. Votre serveur web doit avoir un accès en écriture à ce répertoire.',

## tmpl/cms/include/list_associations/page_title.tmpl
	'Permissions for [_1]' => 'Autorisations pour [_1]',
	'Manage Permissions' => 'Gérer les autorisations',
	'Users for [_1]' => 'Utilisateurs pour [_1]',

## tmpl/cms/include/theme_exporters/templateset.tmpl
	'<span class="count">[_1]</span> templates are included' => '<span class="count">[_1]</span> gabarits sont inclus',
	'Archive Path' => 'Chemin d\'archive',
	'_external_link_target' => '_blank',
	'View Published Template' => 'Voir le gabarit publié',
	'-' => '-',

## tmpl/cms/include/theme_exporters/static_files.tmpl
	'Files types that will be included in the theme are: [_1].' => 'Les types de fichiers qui seront inclus dans le thème seront : [_1].',
	'Included Directories' => 'Répertoires inclus',
	'List the directories that contain the static files that you want to be included in your theme.' => 'Listez les répertoires contenant les fichiers statiques que vous voulez inclure dans votre thème.',

## tmpl/cms/include/theme_exporters/folder.tmpl
	'Folder Name' => 'Nom du répertoire',
	'Path' => 'Chemin',

## tmpl/cms/include/theme_exporters/category.tmpl
	'Category Name' => 'Nom de la catégorie',

## tmpl/cms/include/revision_table.tmpl
	'No revisions could be found.' => 'Aucune révision n\'a été trouvée.',
	'Date' => 'Date',
	'Note' => 'Note',
	'Saved By' => 'Enregistré par',
	'Scheduled' => 'Planifié',
	'Published' => 'Publié',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001-[_1] Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001-[_1] Six Apart. Tous droits réservés.',

## tmpl/cms/include/comment_table.tmpl
	'comment' => 'commentaire',
	'comments' => 'commentaires',
	'to publish' => 'pour publier',
	'Publish selected comments (a)' => 'Publier les commentaires sélectionnés (a)',
	'Delete selected comments (x)' => 'Supprimer les commentaires sélectionnés (x)',
	'Report selected comments as Spam (j)' => 'Marquer les commentaires sélectionnés comme étant du spam (j)',
	'Report selected comments as Not Spam and Publish (j)' => 'Marquer les commentaires sélectionnés comme n\'étant pas du spam et les publier (j)',
	'Not Spam' => 'Non-spam',
	'Are you sure you want to remove all comments reported as spam?' => 'Êtes-vous sûr(e) de vouloir supprimer tous les commentaires notifiés comme spam ?',
	'Delete all comments reported as Spam' => 'Supprimer tous les commentaires marqués comme étant du spam',
	'Empty' => 'Vide',
	'Ban This IP' => 'Bannir cette adresse IP',
	'Website/Blog' => 'Site web/Blog',
	'Entry/Page' => 'Note/Page',
	'IP' => 'IP',
	'Only show published comments' => 'N\'afficher que les commentaires publiés',
	'Only show pending comments' => 'N\'afficher que les commentaires en attente',
	'Pending' => 'En attente',
	'Edit this comment' => 'Editer ce commentaire',
	'([quant,_1,reply,replies])' => '([quant,_1,réponse,réponses])',
	'Trusted' => 'Fiable',
	'Blocked' => 'Bloqués',
	'Authenticated' => 'Authentifié',
	'Edit this [_1] commenter' => 'Modifier l\'auteur de commentaires de cette [_1]',
	'Search for comments by this commenter' => 'Chercher les commentaires de cet auteur de commentaires',
	'View this entry' => 'Voir cette note',
	'View this page' => 'Voir cette page',
	'Search for all comments from this IP address' => 'Rechercher tous les commentaires associés à cette adresse IP',

## tmpl/cms/include/asset_replace.tmpl
	'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'Un fichier nommé \'[_1]\' existe déjà. Souhaitez-vous le remplacer ?',
	'Yes (s)' => 'Oui (s)',
	'Yes' => 'Oui',
	'No' => 'Non',

## tmpl/cms/include/rpt_log_table.tmpl
	'No log records could be found.' => 'Aucune donnée du journal n\'a été trouvée.',
	'Schwartz Message' => 'Message Schwartz',

## tmpl/cms/include/member_table.tmpl
	'user' => 'utilisateur',
	'users' => 'utilisateurs',
	'Are you sure you want to remove the selected user from this blog?' => 'Êtes-vous sûr(e) de vouloir retirer l\'utilisateur sélectionné de ce blog ?',
	'Are you sure you want to remove the [_1] selected users from this blog?' => 'Êtes-vous sûr(e) de vouloir retirer les [_1] utilisateurs sélectionnés de ce blog ?',
	'Remove selected user(s) (r)' => 'Retirer l\'(es) utilisateur(s) sélectionné(s) (r)',
	'Remove' => 'Retirer',
	'_USER_ENABLED' => 'Utilisateur activé',
	'Trusted commenter' => 'Auteur de commentaires fiable',
	'Email' => 'Adresse email',
	'Link' => 'Lien',
	'Remove this role' => 'Retirer ce rôle',

## tmpl/cms/include/feed_link.tmpl
	'Activity Feed' => 'Flux d\'activité',
	'Disabled' => 'Désactivé',
	'Set Web Services Password' => 'Définir un mot de passe pour les services Web',

## tmpl/cms/include/comment_detail.tmpl

## tmpl/cms/include/asset_table.tmpl
	'Delete selected assets (x)' => 'Effacer les contenus sélectionnés (x)',
	'Size' => 'Taille',
	'Created By' => 'Créé par',
	'Created On' => 'Créé le',
	'Asset Missing' => 'Élément manquant',
	'No thumbnail image' => 'Pas de miniature',
	'[_1] is missing' => '[_1] est manquant',
	'System' => 'Système',

## tmpl/cms/include/import_start.tmpl
	'Importing...' => 'Importation...',
	'Importing entries into blog' => 'Importation de notes dans le blog',
	'Importing entries as user \'[_1]\'' => 'Importation des notes en tant qu\'utilisateur \'[_1]\'',
	'Creating new users for each user found in the blog' => 'Création de nouveaux utilisateur correspondant à chaque utilisateur trouvé dans le blog',

## tmpl/cms/include/log_table.tmpl
	'_LOG_TABLE_BY' => 'Utilisateur',
	'Show Datail' => 'Plus d\'infos',
	'IP: [_1]' => 'IP : [_1]',

## tmpl/cms/include/pagination.tmpl

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been backed up successfully!' => 'Toutes les données ont été sauvegardées avec succès!',
	'Download This File' => 'Télécharger ce fichier',
	'_BACKUP_TEMPDIR_WARNING' => '_BACKUP_TEMPDIR_WARNING',
	'_BACKUP_DOWNLOAD_MESSAGE' => '_BACKUP_DOWNLOAD_MESSAGE',
	'An error occurred during the backup process: [_1]' => 'Une erreur est survenue pendant la sauvegarde: [_1]',

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Ajouté(e)',
	'Click to edit contact' => 'Cliquer pour modifier le contact',
	'Save changes' => 'Enregistrer les modifications',
	'Save' => 'Enregistrer',

## tmpl/cms/include/footer.tmpl
	'This is a beta version of Movable Type and is not recommended for production use.' => 'Ceci est une version beta de Movable Type et n\'est pas recommandé pour une utilisation en production.',
	'http://www.movabletype.org' => 'http://www.movabletype.org',
	'MovableType.org' => 'MovableType.org',
	'http://plugins.movabletype.org/' => 'http://plugins.movabletype.org/',
	'Documentation' => 'Documentation',
	'http://wiki.movabletype.org/' => 'http://wiki.movabletype.org/',
	'Wiki' => 'Wiki',
	'http://www.movabletype.com/support/' => 'http://www.movabletype.com/support/',
	'Support' => 'Support',
	'http://forums.movabletype.org/' => 'http://forums.movabletype.org/',
	'Forums' => 'Forums',
	'http://www.movabletype.org/feedback.html' => 'http://www.movabletype.org/feedback.html',
	'Send Us Feedback' => 'Faites nous part de vos remarques',
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]',
	'with' => 'avec',
	'Your Dashboard' => 'Votre tableau de bord',

## tmpl/cms/include/commenter_table.tmpl
	'Identity' => 'Identité',
	'Last Commented' => 'Dernier commenté',
	'Only show trusted commenters' => 'Afficher uniquement les auteurs de commentaires fiable',
	'Only show banned commenters' => 'Afficher uniquement les auteurs de commentaires bannis',
	'Banned' => 'Banni',
	'Only show neutral commenters' => 'Afficher uniquement les auteurs de commentaires neutres',
	'Edit this commenter' => 'Editer cet auteur de commentaires',
	'View this commenter&rsquo;s profile' => 'Voir le profil de cet auteur de commentaires',

## tmpl/cms/include/ping_table.tmpl
	'Publish selected [_1] (p)' => 'Publier le(s) [_1] sélectionné(s) (p)',
	'Delete selected [_1] (x)' => 'Supprimer le(s) [_1] sélectionné(s) (x)',
	'Report selected [_1] as Spam (j)' => 'Marquer le(s) [_1] sélectionné(s) comme étant du spam (j)',
	'Report selected [_1] as Not Spam and Publish (j)' => 'Marquer le(s) [_1] sélectionné(s) comme n\'étant pas du spam et les publier (j)',
	'Are you sure you want to remove all TrackBacks reported as spam?' => 'Êtes-vous sûr de vouloir supprimer tous les trackbacks notifiés comme spam?',
	'Deletes all [_1] reported as Spam' => 'Supprimer tous les [_1] marqués comme étant du spam',
	'From' => 'De',
	'Target' => 'Cible',
	'Only show published TrackBacks' => 'Afficher uniquement les trackbacks publiés',
	'Only show pending TrackBacks' => 'Afficher uniquement les trackbacks en attente',
	'Edit this TrackBack' => 'Modifier ce trackback',
	'Go to the source entry of this TrackBack' => 'Aller à la note à l\'origine de ce trackback',
	'View the [_1] for this TrackBack' => 'Voir [_1] pour ce trackback',

## tmpl/cms/include/login_mt.tmpl

## tmpl/cms/include/entry_table.tmpl
	'Save these [_1] (s)' => 'Sauvegarder ces [_1] (s)',
	'Republish selected [_1] (r)' => 'Republier les [_1] sélectionné(e)s (r)',
	'Last Modified' => 'Dernière modification',
	'Created' => 'Créé',
	'View' => 'Voir',
	'Unpublished (Draft)' => 'Non publié (Brouillon)',
	'Unpublished (Review)' => 'Non publié (Vérification)',
	'Only show unpublished entries' => 'Afficher uniquement les notes non publiées',
	'Only show unpublished pages' => 'Afficher uniquement les pages non publiées',
	'Only show published entries' => 'Afficher uniquement les notes publiées',
	'Only show published pages' => 'Afficher uniquement les pages publiées',
	'Only show entries for review' => 'Afficher uniquement les notes à vérifier',
	'Only show pages for review' => 'Afficher uniquement les pages à vérifier',
	'Only show scheduled entries' => 'Afficher uniquement les notes planifiées',
	'Only show scheduled pages' => 'Afficher uniquement les pages planifiées',
	'Only show spam entries' => 'Afficher uniquement les notes indésirables (spam)',
	'Only show spam pages' => 'Afficher uniquement les pages indésirables (spam)',
	'Edit Entry' => 'Éditer une note',
	'Edit Page' => 'Éditer une page',
	'View entry' => 'Afficher une note',
	'View page' => 'Afficher une page',
	'No entries could be found.' => 'Aucune note n\'a été trouvée.',
	'<a href="[_1]">Create an entry</a> now.' => '<a href="[_1]">Créer une note</a> maintenant.',
	'No page could be found. <a href="[_1]">Create a page</a> now.' => 'Aucune page n\'a été trouvée. <a href="[_1]">Créer une page</a> maintenant.',
	'to republish' => 'pour republier',
	'to act upon' => 'pour agir sur',

## tmpl/cms/include/author_table.tmpl
	'_USER_DISABLED' => 'Utilisateur désactivé',

## tmpl/cms/include/calendar.tmpl
	'_LOCALE_WEEK_START' => '1',
	'S|M|T|W|T|F|S' => 'D|L|M|M|J|V|S',
	'January' => 'Janvier',
	'Febuary' => 'Février',
	'March' => 'Mars',
	'April' => 'Avril',
	'May' => 'Mai',
	'June' => 'Juin',
	'July' => 'Juillet',
	'August' => 'Août',
	'September' => 'Septembre',
	'October' => 'Octobre',
	'November' => 'Novembre',
	'December' => 'Décembre',
	'Jan' => 'Jan',
	'Feb' => 'Fév',
	'Mar' => 'Mar',
	'Apr' => 'Avr',
	'_SHORT_MAY' => 'Mai',
	'Jun' => 'Juin',
	'Jul' => 'Juil',
	'Aug' => 'Aoû',
	'Sep' => 'Sep',
	'Oct' => 'Oct',
	'Nov' => 'Nov',
	'Dec' => 'Déc',
	'OK' => 'OK',
	'[_1:calMonth] [_2:calYear]' => '[_1:calMonth] [_2:calYear]',

## tmpl/cms/include/itemset_action_widget.tmpl
	'More actions...' => 'Plus d\'actions...',
	'Plugin Actions' => 'Actions du plugin',
	'Go' => 'OK',

## tmpl/cms/include/anonymous_comment.tmpl
	'Allow comments from anonymous or unauthenticated users.' => 'Permettre les commentaires anonymes pour les utilisateurs non identifiés.',
	'Require E-mail Address for Anonymous Comments' => 'Nécessite une adresse email pour les commentaires anonymes',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Si activé, le visiteur doit donner une adresse email valide pour commenter.',

## tmpl/cms/include/category_selector.tmpl
	'Add sub category' => 'Ajouter une sous-catégorie',
	'Add' => 'Ajouter',
	'Add sub folder' => 'Ajouter un sous-dossier',

## tmpl/cms/include/display_options.tmpl
	'Display Options' => 'Options d\'affichage',
	'_DISPLAY_OPTIONS_SHOW' => 'Afficher',
	'[quant,_1,row,rows]' => '[quant,_1,ligne,lignes]',
	'Compact' => 'Compacte',
	'Expanded' => 'Etendue',
	'Date Format' => 'Format date',
	'Relative' => 'Relative',
	'Full' => 'Entière',
	'Save display options' => 'Enregistrer les options d\'affichage',

## tmpl/cms/include/backup_start.tmpl
	'Backing up Movable Type' => 'Sauvegarder Movable Type',

## tmpl/cms/include/template_table.tmpl
	'Create Archive Template:' => 'Créer un gabarit d\'archives',
	'Entry Listing' => 'Liste des notes',
	'Create template module' => 'Créer un module de gabarit',
	'Create index template' => 'Créer un gabarit index',
	'Publish selected templates (a)' => 'Publier les gabarits sélectionnés (a)',
	'SSI' => 'SSI',
	'Cached' => 'Caché',
	'Linked Template' => 'Gabarit lié',
	'Manual' => 'Manuellement',
	'Dynamic' => 'Dynamique',
	'Publish Queue' => 'Publication en mode File d\'Attente',
	'Static' => 'Statique',
	'templates' => 'gabarits',
	'<mt:var name="object_label_plural" escape="js">' => '<mt:var name="object_label_plural" escape="js">',

## tmpl/cms/include/asset_upload.tmpl
	'You must set a valid destination.' => 'Vous devez indiquer une destination valide.',
	'Before you can upload a file, you need to publish your [_1]. [_2]Configure your [_1]\'s publishing paths[_3] and republish your [_1].' => 'Avant de pouvoir envoyer un fichier, vous devez publier votre [_1]. [_2]Configurez vos chemins de publication[_3] de votre [_1] et republiez-le.',
	'Your system or [_1] administrator needs to publish the [_1] before you can upload files. Please contact your system or [_1] administrator.' => '
	Votre administrateur système ou [_1] a besoin de publier le [_1] avant que vous puissiez télécharger des fichiers. Veuillez contacter votre administrateur système ou [_1].',
	'Close (x)' => 'Fermer (x)',
	'Asset file(\'[_1]\') has been uploaded.' => 'Le fichier de l\'élément (\'[_1]\') a été envoyé.',
	'Select File to Upload' => 'Sélectionnez le fichier à envoyer',
	'_USAGE_UPLOAD' => 'Vous pouvez télécharger le fichier ci-dessus dans le chemin local de votre site <a href="javascript:alert(\'[_1]\')">(?)</a> ou dans le chemin des archives de votre site <a href="javascript:alert(\'[_2]\')">(?)</a>. Vous pouvez également télécharger le fichier dans un répertoire compris dans les répertoires mentionnés ci-dessus, en spécifiant le chemin dans les champs de droite (<i>images</i>, par exemple). Les répertoires qui n\'existent pas encore seront créés.',
	'Upload Destination' => 'Destination du fichier',
	'Choose Folder' => 'Choisir le Dossier',
	'Upload (s)' => 'Envoyer (s)',
	'Upload' => 'Envoyer',
	'Cancel (x)' => 'Annuler (x)',
	'Back (b)' => 'Retour (b)',

## tmpl/cms/include/listing_panel.tmpl
	'Step [_1] of [_2]' => 'Étape  [_1] sur [_2]',
	'Reset' => 'Mettre à jour',
	'Go to [_1]' => 'Aller à [_1]',
	'Sorry, there were no results for your search. Please try searching again.' => 'Désolé, aucun résultat trouvé pour cette recherche. Merci d\'essayer à nouveau.',
	'Sorry, there is no data for this object set.' => 'Désolé, mais il n\'y a pas de données pour cet ensemble d\'objets.',
	'OK (s)' => 'Ok (s)',
	'Continue (s)' => 'Continuer (s)(',

## tmpl/cms/include/header.tmpl
	'Signed in as [_1]' => 'Identifié comme étant [_1]',
	'Help' => 'Aide',
	'Sign out' => 'déconnexion',
	'User Dashboard' => 'Tableau de bord de l\'utilisateur',
	'System Overview' => 'Vue d\'ensemble',
	'Select another website...' => 'Sélectionner un autre site web...',
	'(on [_1])' => '(sur [_1])',
	'Select another blog...' => 'Sélectionnez un autre blog...',
	'Create Website' => 'Créer un site web',
	'Create Blog (on [_1])' => 'Créer un blog (sur [_1])',
	'View Site' => 'Voir le site',
	'View [_1]' => 'Voir [_1]',
	'Search (q)' => 'Recherche (q)',
	'This website was created during the version-up from the previous version of Movable Type. \'Site Root\' and \'Site URL\' are left blank to retain \'Publishing Paths\' compatibility for blogs those were created at the previous version. You can post and publish on existing blogs, but you cannot publish this website itself because of the blank \'Site Root\' and \'Site URL\'.' => '
	Ce site web a été créé sur une version précédente de Movable Type. La racine du site et l\'URL du site sont laissés blancs afin de laisser les chemins de publication compatibles pour les blogs créés sur la version précédente. Vous pouvez rédiger et publier sur les blogs existants mais vous ne pouvez pas publier ce site web parce que ces champs sont vides.',
	'from Revision History' => 'depuis l\'historique de révision',

## tmpl/cms/include/archetype_editor.tmpl
	'Decrease Text Size' => 'Diminuer la taille du texte',
	'Increase Text Size' => 'Augmenter la taille du texte',
	'Bold' => 'Gras',
	'Italic' => 'Italique',
	'Underline' => 'Souligné',
	'Strikethrough' => 'Rayé',
	'Text Color' => 'Couleur du texte',
	'Email Link' => 'Lien email',
	'Begin Blockquote' => 'Commencer le texte en retrait',
	'End Blockquote' => 'Fin paragraphe en retrait ',
	'Bulleted List' => 'Liste à puces',
	'Numbered List' => 'Liste numérotée',
	'Left Align Item' => 'Aligner à gauche',
	'Center Item' => 'Centrer l\'élément',
	'Right Align Item' => 'Aligner l\'élément à droite',
	'Left Align Text' => 'Aligner le texte à gauche',
	'Center Text' => 'Centrer le texte',
	'Right Align Text' => 'Aligner le texte à droite',
	'Insert Image' => 'Insérer une image',
	'Insert File' => 'Insérer un fichier',
	'WYSIWYG Mode' => 'Mode WYSIWYG',
	'HTML Mode' => 'Mode HTML',

## tmpl/cms/include/blog_table.tmpl
	'[_1] Name' => 'Nom [_1]',

## tmpl/cms/include/users_content_nav.tmpl
	'Profile' => 'Profil',

## tmpl/cms/include/import_end.tmpl
	'All data imported successfully!' => 'Toutes les données ont été importées avec succès !',
	'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Assurez vous d\'avoir bien enlevé les fichiers importés du répertoire \'import\', pour éviter une ré-importation des mêmes fichiers à l\'avenir .',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Une erreur s\'est produite pendant le processus: [_1]. Merci de vérifier vos fichiers import.',

## tmpl/cms/include/archive_maps.tmpl
	'Type' => 'Type',
	'Custom...' => 'Personnalisé...',
	'Statically (default)' => 'Statique (défaut)',
	'Via Publish Queue' => 'Via une Publication en Mode File d\'Attente',
	'On a schedule' => 'Planifié',
	': every ' => ': chaque ',
	'minutes' => 'minutes',
	'hours' => 'heures',
	'days' => 'jours',
	'Dynamically' => 'Dynamique',
	'Manually' => 'Manuellement',
	'Do Not Publish' => 'Ne Pas Publier',

## tmpl/cms/dialog/recover.tmpl
	'The email address provided is not unique.  Please enter your username.' => 'L\'adresse email fournie n\'est pas unique. Merci de saisir votre nom d\'utilisateur.',
	'An email with a link to reset your password has been sent to your email address ([_1]).' => 'Un email contenant un lien pour réinitialiser votre mot de passe a été envoyé à votre adresse email ([_1]).',
	'Go Back (x)' => 'Retour (x)',
	'Sign in to Movable Type (s)' => 'Connectez-vous sur Movable Type (s)',
	'Sign in to Movable Type' => 'Connectez-vous sur Movable Type',
	'Recover (s)' => 'Récupérer (s)',
	'Recover' => 'Récupérer',

## tmpl/cms/dialog/restore_end.tmpl
	'An error occurred during the restore process: [_1] Please check your restore file.' => 'Une erreur s\'est produite pendant la procédure de restauration: [_1] Merci de vérifier votre fichier de restauration.',
	'View Activity Log (v)' => 'Voir le journal (logs) (v)',
	'All data restored successfully!' => 'Toutes les données ont été restaurées avec succès !',
	'Close (s)' => 'Fermer (s)',
	'Next Page' => 'Page suivante',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => 'Cette page va être redirigée vers une nouvelle page dans 3 secondes. [_1]Arrêter la redirection.[_2]',

## tmpl/cms/dialog/asset_replace.tmpl

## tmpl/cms/dialog/asset_list.tmpl
	'Insert Asset' => 'Insérer un élément',
	'Upload New File' => 'Envoyer un nouveau fichier',
	'Upload New Image' => 'Envoyer une nouvelle image',
	'Asset Name' => 'Nom de l\'élément',
	'View Asset' => 'Aperçu de l\'élément',
	'Next (s)' => 'Suivant (s)',
	'Insert (s)' => 'Insérer (s)',
	'Insert' => 'Insérer',
	'No assets could be found.' => 'Aucun élément n\'a été trouvé.',

## tmpl/cms/dialog/new_password.tmpl
	'Change Password' => 'Changer de Mot de passe',
	'New Password' => 'Nouveau mot de passe',
	'Confirm New Password' => 'Confirmer le nouveau mot de passe',
	'Change' => 'Modifier',

## tmpl/cms/dialog/refresh_templates.tmpl
	'Refresh Global Templates' => 'Mettre à jour les gabarits globaux',
	'Cannot find template set. Please apply [_1]theme[_2] to refresh your templates.' => 'Impossible de trouver le groupe de gabarits. Veuillez appliquer [_1]theme[_2] pour mettre à jour vos gabarits.',
	'Revert modifications of theme templates' => 'Annuler les modifications des gabarits de thème',
	'Reset to theme defaults' => 'Réinitialiser les thèmes comme à l\'origine',
	'Deletes all existing templates and install the selected theme\'s default.' => 'Supprimer tous les gabarits existants et installer les gabarits par défaut pour les thèmes sélectionnés.',
	'Refresh global templates' => 'Mettre à jour les gabarits généraux',
	'Reset to factory defaults' => 'Remettre à zéro les modifications',
	'Deletes all existing templates and installs factory default template set.' => 'Supprime tous les gabarits existants et installe les groupes de gabarits par défaut ',
	'Updates current templates while retaining any user-created templates.' => 'Met à jour les gabarits courants tout en empêchant la création de gabarits par l\'utilisateur.',
	'Make backups of existing templates first' => 'Faire d\'abord des sauvegardes des gabarits existants',
	'You have requested to <strong>refresh the current template set</strong>. This action will:' => 'Vous avez demandé à <strong>réactualiser le groupe de gabarit actuel</strong>. Cette action va :',
	'You have requested to <strong>refresh the global templates</strong>. This action will:' => 'Vous avez demandé à <strong>rafraîchir les gabarits généraux</strong>. Cette action va :',
	'make backups of your templates that can be accessed through your backup filter' => 'faire des copies de sauvegarde de vos gabarits qui pourront être accessibles via votre filtre de sauvegarde',
	'potentially install new templates' => 'peut-être installer de nouveaux gabarits',
	'overwrite some existing templates with new template code' => 'remplacer le code de certains gabarits par un nouveau code',
	'You have requested to <strong>apply a new template set</strong>. This action will:' => 'Vous avez demandé d\'<strong>appliquer un nouveau groupe de gabarit</strong>. Cette action va :',
	'You have requested to <strong>reset to the default global templates</strong>. This action will:' => 'Vous avez demandé à <strong>rétablir les gabarits généraux par défaut</strong>. Cette action va :',
	'delete all of the templates in your blog' => 'supprimer tous les gabarits de votre blog',
	'install new templates from the selected template set' => 'installer de nouveaux gabarits depuis le groupe de gabarits sélectionné',
	'delete all of your global templates' => 'supprimer tous vos gabarits généraux',
	'install new templates from the default global templates' => 'installer de nouveaux gabarits issus des gabarits généraux par défaut',
	'Are you sure you wish to continue?' => 'Êtes-vous sûr de vouloir continuer ?',
	'Confirm' => 'Confirmer',

## tmpl/cms/dialog/comment_reply.tmpl
	'Reply to comment' => 'Répondre au commentaire',
	'On [_1], [_2] commented on [_3]' => 'Le [_1], [_2] a commenté sur [_3]',
	'Preview of your comment' => 'Prévisualisation de votre commentaire',
	'Your reply:' => 'Votre réponse :',
	'Submit reply (s)' => 'Envoyer la réponse (s)',
	'Preview reply (v)' => 'Prévisualiser la réponse (v)',
	'Re-edit reply (r)' => 'Re-modifier la réponse (r)',
	'Re-edit' => 'Re-modifier',

## tmpl/cms/dialog/asset_upload.tmpl
	'You need to configure your blog.' => 'Vous devez configurer votre blog.',
	'Your blog has not been published.' => 'Votre blog n\'a pas été publié.',

## tmpl/cms/dialog/publishing_profile.tmpl
	'Publishing Profile' => 'Profil de publication',
	'Choose the profile that best matches the requirements for this blog.' => 'Choisir le profil qui correspond le mieux aux besoins de ce blog',
	'Static Publishing' => 'Publication statique',
	'Immediately publish all templates statically.' => 'Publier immédiatement tous les gabarits de manière statique.',
	'Background Publishing' => 'Publication en arrière-plan',
	'All templates published statically via Publish Que.' => 'Tous les gabarits sont publiés en statique via une publication en mode file d\'attente',
	'High Priority Static Publishing' => 'Publication statique prioritaire',
	'Immediately publish Main Index template, Entry archives, and Page archives statically. Use Publish Queue to publish all other templates statically.' => 'Publier immédiatement les gabarits d\'index et d\'archives individuelles de notes et pages en statique. Utiliser une publication en mode file d\'attente pour tout le reste.',
	'Immediately publish Main Index template, Page archives statically. Use Publish Queue to publish all other templates statically.' => 'Publier immédiatement les gabarit d\'index et d\'archives individuelles en statique. Utiliser une publication en mode file d\'attente pour tout le reste.',
	'Dynamic Publishing' => 'Publication dynamique',
	'Publish all templates dynamically.' => 'Publier tous les gabarits en dynamique',
	'Dynamic Archives Only' => 'Archives dynamiques uniquement',
	'Publish all Archive templates dynamically. Immediately publish all other templates statically.' => 'Publier tous les gabarits d\'archives individuelles en dynamique. Publier immédiatement tout les autres gabarits en statique.',
	'This new publishing profile will update all of your templates.' => 'Ce nouveau profil de publication mettra à jour tous vos gabarits.',

## tmpl/cms/dialog/restore_upload.tmpl
	'Restore: Multiple Files' => 'Restauration : Plusieurs fichiers',
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => 'L\'annulation de la procédure va créer des objets orphelins.  Êtes-vous sûr de vouloir annuler l\'opération de restauration ?',
	'Please upload the file [_1]' => 'Merci d\'envoyer le fichier [_1]',

## tmpl/cms/dialog/list_revision.tmpl
	'Select the revision to populate the values of the Edit screen.' => 'Sélectionner la révision à utiliser pour construire les valeurs de l\'éditeur.',

## tmpl/cms/dialog/entry_notify.tmpl
	'Send a Notification' => 'Envoyer une notification',
	'You must specify at least one recipient.' => 'Vos devez définir au moins un destinataire.',
	'Your [_1]\'s name, title, and a link to view it will be sent in the notification. Additionally, you can add a message, include an excerpt and/or send the entire body.' => 'Votre nom de [_1], titre et un lien pour le voir sera envoyé dans la notification. De plus, vous pouvez ajouter un message, inclure un extrait et/ou envoyer le contenu en entier.',
	'Recipients' => 'Destinataires',
	'Enter email addresses on separate lines or separated by commas.' => 'Entrez les adresses e-mail, une sur chaque ligne ou séparées par des virgules.',
	'All addresses from Address Book' => 'Toutes les adresses du carnet d\'adresses',
	'Optional Message' => 'Message optionnel',
	'Optional Content' => 'Contenu optionnel',
	'(Body will be sent without any text formatting applied.)' => '(Le contenu sera envoyé sans aucun formattage).',
	'Send notification (s)' => 'Envoyer la notification (s)',
	'Send' => 'Envoyer',

## tmpl/cms/dialog/asset_options.tmpl
	'File Options' => 'Options fichier',
	'Create entry using this uploaded file' => 'Créer une note à l\'aide de ce fichier',
	'Create a new entry using this uploaded file.' => 'Créer une nouvelle note avec ce fichier envoyé.',
	'Finish (s)' => 'Terminer (s)',
	'Finish' => 'Terminer',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Confirm Publishing Configuration' => 'Confirmer la confirmation de publication',
	'Site Path' => 'Chemin du site',
	'Parent Website' => 'Site web parent',
	'Please choose parent website.' => 'Veuillez choisir un site web parent',
	'Use subdomain' => 'Utiliser un sous-domaine',
	'Archive URL' => 'URL d\'archive',
	'You must set a valid Site URL.' => 'Vous devez spécifier une URL valide.',
	'You must set your Local Site Path.' => 'Vous devez configurer le chemin local de votre site.',
	'You must set a valid Local Site Path.' => 'Vous devez spécifier un chemin local d\'accès valide.',
	'You must select a parent website.' => 'Vous devez choisir un site web parent',

## tmpl/cms/dialog/move_blogs.tmpl
	'Warning: You need to copy uploaded assets to the new path manually. It is also recommended not to delete files in the old path to avoid broken links.' => 'Attention : Vous devez copier les éléments envoyés vers le nouveau chemin manuellement. Il est également recommendé de ne pas supprimer les anciens fichiers afin d\'éviter les liens morts.',

## tmpl/cms/dialog/asset_options_image.tmpl
	'Display image in entry/page' => 'Afficher l\'image dans la note/page',
	'Alignment' => 'Alignement',
	'Left' => 'Gauche',
	'Center' => 'Centrer',
	'Right' => 'Droite',
	'Use thumbnail' => 'Utiliser une vignette',
	'width:' => 'largeur :',
	'pixels' => 'pixels',
	'Link image to full-size version in a popup window.' => 'Créer un lien vers l\'image originale dans une popup',
	'Remember these settings' => 'Se souvenir de ces paramètres',

## tmpl/cms/dialog/theme_element_detail.tmpl
	'Include in Theme: [_1]' => 'Inclure dans le thème : [_1]',

## tmpl/cms/dialog/create_association.tmpl
	'No roles exist in this installation. [_1]Create a role</a>' => 'Aucun rôle n\'existe dans cette installation. [_1]Créer un rôle</a>',
	'No groups exist in this installation. [_1]Create a group</a>' => 'Aucun groupe n\'existe dans cette installation. [_1]Créer un groupe</a>',
	'No users exist in this installation. [_1]Create a user</a>' => 'Aucun utilisateur n\'existe dans cette installation. [_1]Créer un utilisateur</a>',
	'No blogs exist in this installation. [_1]Create a blog</a>' => 'Aucun blog n\'existe dans cette installation. [_1]Créer un blog</a>',

## tmpl/cms/dialog/restore_start.tmpl
	'Restoring...' => 'Restauration...',

## tmpl/cms/dialog/select_theme.tmpl
	'Select Personal blog theme' => 'Sélectionner un thème pour le blog personnel',
	'Apply' => 'Appliquer',

## tmpl/cms/dialog/clone_blog.tmpl
	'Verify Clone Blog Settings' => 'Vérifier les paramètres de duplication de blog',
	'Blog Details' => 'Détails du Blog',
	'This is set to the same URL as the original blog.' => 'Cela est configuré vers la même URL que le blog original.',
	'This will overwrite the original blog.' => 'Cela réécrira sur le blog original.',
	'Exclusions' => 'Exclusions',
	'Exclude Entries/Pages' => 'Exclure les notes/pages',
	'Exclude Comments' => 'Exclure les commentaires',
	'Exclude Trackbacks' => 'Exclure les trackbacks',
	'Exclude Categories/Folders' => 'Exclure les catégories/répertoires',
	'Clone' => 'Dupliquer',
	'Clone Blog Settings' => 'Paramètres de duplication de blogs',
	'Enter the new URL of your public website. Example: http://www.example.com/weblog/' => 'Entrez la nouvelle URL de votre site web pulic. Exemple : http://www.exemple.com/weblog/',
	'Enter a new path where your main index file will be located. Example: /home/melody/public_html/weblog' => 'Entrez un chemin d\'accès où votre fichier d\'index se trouvera. Exemple : /home/melody/public_html/blog',
	'Mark the settings that you want cloning to skip' => 'Marquez les paramètres que vous ne souhaitez pas dupliquer',
	'Entries/Pages' => 'Notes/Pages',
	'Categories/Folders' => 'Catégories/Répertoires',

## tmpl/cms/dialog/asset_insert.tmpl

## tmpl/cms/widget/favorite_blogs.tmpl
	'Your recent websites and blogs' => 'Vos sites web et blogs récents',
	'[quant,_1,blog,blogs]' => '[quant,_1,blog,blogs]',
	'[quant,_1,page,pages]' => '[quant,_1,page,pages]',
	'[quant,_1,comment,comments]' => '[quant,_1,commentaire,commentaires]',
	'No website could be found. [_1]' => 'Aucun site web trouvé. [_1]',
	'Create a new' => 'Créer un nouveau',
	'[quant,_1,entry,entries]' => '[quant,_1,note,notes]',
	'No blog could be found.' => 'Aucun blog trouvé.',

## tmpl/cms/widget/recent_websites.tmpl

## tmpl/cms/widget/recent_blogs.tmpl
	'No blogs could be found. [_1]' => 'Aucun blog trouvé. [_1]',

## tmpl/cms/widget/new_user.tmpl
	'Welcome to Movable Type, the world\'s most powerful blogging, publishing and social media platform:' => 'Bienvenue dans Movable Type, la plateforme de blogs, de publication et de média social la plus puissante au monde.',
	'Movable Type Online Manual' => 'Manuel en ligne Movable Type',
	'Whether you\'re new to Movable Type or using it for the first time, learn more about what this tool can do for you.' => 'Que vous découvriez Movable Type ou que vous l\'utilisiez pour la première fois, découvrez ce que cet outil peut faire pour vous.',

## tmpl/cms/widget/blog_stats_recent_entries.tmpl
	'[quant,_1,entry,entries] tagged &ldquo;[_2]&rdquo;' => '[quant,_1,note,notes] avec le tag &ldquo;[_2]&rdquo;',
	'...' => '...',
	'Posted by [_1] [_2] in [_3]' => 'Postée par [_1] [_2] dans [_3]',
	'Posted by [_1] [_2]' => 'Postée par [_1] [_2]',
	'Tagged: [_1]' => 'avec le tag : [_1]',
	'View all entries' => 'Voir toutes les notes',
	'No entries available.' => 'Aucune note disponible.',

## tmpl/cms/widget/mt_news.tmpl
	'News' => 'Actualité',
	'MT News' => 'Actualité Movable Type',
	'Learning MT' => 'Apprendre Movable Type',
	'Hacking MT' => 'Coder pour Movable Type',
	'Pronet' => 'Pronet',
	'No Movable Type news available.' => 'Aucune actualité Movable Type n\'est disponible.',
	'No Learning Movable Type news available.' => 'Pas d\'actualité Apprendre Movable Type disponible.',

## tmpl/cms/widget/custom_message.tmpl
	'This is you' => 'C\'est vous',
	'Welcome to [_1].' => 'Bienvenue sur [_1].',
	'You can manage your blog by selecting an option from the menu located to the left of this message.' => 'Vous pouvez gérer votre blog en sélectionnant une option dans le menu situé à gauche de ce message.',
	'If you need assistance, try:' => 'Si vous avez besoin d\'aide, vous pouvez consulter :',
	'Movable Type User Manual' => 'Mode d\'emploi de Movable Type',
	'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.com/movabletype/support',
	'Movable Type Technical Support' => 'Support Technique Movable Type',
	'Movable Type Community Forums' => 'Forums de la communauté Movable Type ',
	'Save Changes (s)' => 'Sauvegarder les modifications',
	'Save Changes' => 'Enregistrer les modifications',
	'Change this message.' => 'Changer ce message.',
	'Edit this message.' => 'Modifier ce message.',

## tmpl/cms/widget/mt_shortcuts.tmpl
	'Handy Shortcuts' => 'Raccourcis pratiques',
	'Import Content' => 'Importer du contenu',
	'Blog Preferences' => 'Préférences du blog',

## tmpl/cms/widget/new_version.tmpl
	'What\'s new in Movable Type [_1]' => 'Quoi de neuf dans Movable Type [_1]',

## tmpl/cms/widget/this_is_you.tmpl
	'Your <a href="[_1]">last entry</a> was [_2] in <a href="[_3]">[_4]</a>.' => 'Votre <a href="[_1]">dernière note</a> a été [_2] dans <a href="[_3]">[_4]</a>.',
	'Your last entry was [_1] in <a href="[_2]">[_3]</a>.' => 'Votre dernière note a été [_1] dans <a href="[_2]">[_3]</a>.',
	'You have <a href="[_1]">[quant,_2,draft,drafts]</a>.' => 'Vous avez <a href="[_1]">[quant,_2,brouillon,brouillons]</a>.',
	'You have [quant,_1,draft,drafts].' => 'Vous avez [quant,_1,brouillon,brouillons]',
	'You\'ve written <a href="[_1][_2]">[quant,_3,entry,entries]</a>, <a href="[_1][_4]">[quant,_5,page,pages]</a> with <a href="[_1][_6]">[quant,_7,comment,comments]</a>.' => 'Vous avez rédigé <a href="[_1][_2]">[quant,_3,note,notes]</a>, <a href="[_1][_4]">[quant,_5,page,pages]</a> avec <a href="[_1][_6]">[quant,_7,commentaire,commentaires]</a>.',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, <a href="[_3]">[quant,_4,page,pages]</a> with [quant,_5,comment,comments].' => 'Vous avez rédigé <a href="[_1]">[quant,_2,note,notes]</a>, <a href="[_3]">[quant,_4,page,pages]</a> avec [quant,_5,commentaire,commentaires].',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, [quant,_3,page,pages] with <a href="[_4]">[quant,_5,comment,comments]</a>.' => 'Vous avez rédigé<a href="[_1]">[quant,_2,note,notes]</a>, [quant,_3,page,pages] avec <a href="[_4]">[quant,_5,commentaire,commentaires]</a>.',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, [quant,_3,page,pages] with [quant,_4,comment,comments].' => 'Vous avez rédigé <a href="[_1]">[quant,_2,note,notes]</a>, [quant,_3,page,pages] avec [quant,_4,commentaire,commentaires].',
	'You\'ve written [quant,_1,entry,entries], <a href="[_2]">[quant,_3,page,pages]</a> with <a href="[_4]">[quant,_5,comment,comments]</a>.' => 'Vous avez rédigé [quant,_1,note,notes], <a href="[_2]">[quant,_3,page,pages]</a> avec <a href="[_4]">[quant,_5,commentaire,commentaires]</a>.',
	'You\'ve written [quant,_1,entry,entries], <a href="[_2]">[quant,_3,page,pages]</a> with [quant,_4,comment,comments].' => 'Vous avez rédigé [quant,_1,note,notes], <a href="[_2]">[quant,_3,page,pages]</a> avec [quant,_4,commentaire,commentaires].',
	'You\'ve written [quant,_1,entry,entries], [quant,_2,page,pages] with <a href="[_3]">[quant,_4,comment,comments]</a>.' => 'Vous avez rédigé [quant,_1,note,entries], [quant,_2,page,pages] avec <a href="[_3]">[quant,_4,commentaire,commentaires]</a>.',
	'You\'ve written [quant,_1,entry,entries], [quant,_2,page,pages] with [quant,_3,comment,comments].' => 'Vous avez rédigé [quant,_1,note,entries], [quant,_2,page,pages] avec [quant,_3,commentaire,commentaires].',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, <a href="[_3]">[quant,_4,page,pages]</a>.' => 'Vous avez rédigé <a href="[_1]">[quant,_2,note,entries]</a>, <a href="[_3]">[quant,_4,page,pages]</a>.',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, [quant,_3,page,pages].' => 'Vous avez rédigé <a href="[_1]">[quant,_2,note,entries]</a>, [quant,_3,page,pages].',
	'You\'ve written [quant,_1,entry,entries], <a href="[_2]">[quant,_3,page,pages]</a>.' => 'Vous avez rédigé [quant,_1,note,entries], <a href="[_2]">[quant,_3,page,pages]</a>.',
	'You\'ve written [quant,_1,entry,entries], [quant,_2,page,pages].' => 'Vous avez rédigé [quant,_1,note,entries], [quant,_2,page,pages].',
	'You\'ve written <a href="[_1]">[quant,_2,page,pages]</a> with <a href="[_3]">[quant,_4,comment,comments]</a>.' => 'Vous avez rédigé <a href="[_1]">[quant,_2,page,pages]</a> avec <a href="[_3]">[quant,_4,commentaire,commentaires]</a>.',
	'You\'ve written <a href="[_1]">[quant,_2,page,pages]</a> with [quant,_3,comment,comments].' => 'Vous avez rédigé <a href="[_1]">[quant,_2,page,pages]</a> avec [quant,_3,commentaire,commentaires].',
	'You\'ve written [quant,_1,page,pages] with <a href="[_2]">[quant,_3,comment,comments]</a>.' => 'Vous avez rédigé [quant,_1,page,pages] avec <a href="[_2]">[quant,_3,commentaire,commentaires]</a>.',
	'You\'ve written [quant,_1,page,pages] with [quant,_2,comment,comments].' => 'Vous avez rédigé [quant,_1,page,pages] avec [quant,_2,commentaire,commentaires].',
	'Edit your profile' => 'Modifier votre profil',

## tmpl/cms/widget/new_install.tmpl
	'Thank you for installing Movable Type' => 'Merci d\'avoir installé Movable Type',
	'You are now ready to:' => 'Vous êtes maintenant prêt(e) à :',
	'Create a new page on your website' => 'Créer une nouvelle page sur votre site web',
	'Create a blog on your website' => 'Créer un blog sur votre site web',
	'Create a blog (many blogs can exist in one website) to start posting.' => 'Créer un blog (plusieurs blogs peuvent exister dans un seul site web) pour commencer à publier.',

## tmpl/cms/widget/blog_stats.tmpl
	'Error retrieving recent entries.' => 'Erreur en récupérant les notes récentes.',
	'Loading recent entries...' => 'Chargement des notes récentes...',
	'Jan.' => 'Jan.',
	'Feb.' => 'Fév.',
	'July.' => 'Juil.',
	'Aug.' => 'Août',
	'Sept.' => 'Sept.',
	'Oct.' => 'Oct.',
	'Nov.' => 'Nov.',
	'Dec.' => 'Déc.',
	'[_1] [_2] - [_3] [_4]' => '[_1] [_2] - [_3] [_4]',
	'You have <a href=\'[_3]\'>[quant,_1,comment,comments] from [_2]</a>' => 'Vous avez <a href=\'[_3]\'>[quant,_1,commentaire,commentaires] de [_2]</a>',
	'You have <a href=\'[_3]\'>[quant,_1,entry,entries] from [_2]</a>' => 'Vous avez <a href=\'[_3]\'>[quant,_1,note,notes] de [_2]</a>',

## tmpl/cms/widget/blog_stats_entry.tmpl
	'Most Recent Entries' => 'Notes récentes',
	'No entries have been created in this blog. <a href="[_1]">Create a entry</a>' => 'Aucune note n\'a été créé dans ce blog. <a href="[_1]">Créer une note</a>',

## tmpl/cms/widget/blog_stats_tag_cloud.tmpl

## tmpl/cms/widget/blog_stats_comment.tmpl
	'Most Recent Comments' => 'Commentaires récents',
	'[_1] [_2], [_3] on [_4]' => '[_1] [_2], [_3] sur [_4]',
	'View all comments' => 'Voir tous les commentaires',
	'No comments available.' => 'Aucune commentaire disponible.',

## tmpl/cms/popup/rebuilt.tmpl
	'Success' => 'Succès',
	'The files for [_1] have been published.' => 'Les fichiers pour [_1] ont été publiés.',
	'Your [_1] has been published.' => 'Votre [_1] a été publiée.',
	'Your [_1] archives have been published.' => 'Vos archives [_1]  ont été publiées.',
	'Your [_1] templates have been published.' => 'Vos gabarites [_1] ont été publiées.',
	'Publish time: [_1].' => 'Temps de publication : [_1].',
	'View your site.' => 'Voir votre site.',
	'View this page.' => 'Voir cette page.',
	'Publish Again (s)' => 'Publier à nouveau',
	'Publish Again' => 'Publier à nouveau',

## tmpl/cms/popup/pinged_urls.tmpl
	'Successful Trackbacks' => 'Trackbacks réussis',
	'Failed Trackbacks' => 'Trackbacks échoués',
	'To retry, include these TrackBacks in the Outbound TrackBack URLs list for your entry.' => 'Pour ré-essayer, incluez ces trackbacks dans la liste des URLs de trackbacks sortants pour cette note.',

## tmpl/cms/popup/rebuild_confirm.tmpl
	'Publish [_1]' => 'Publier [_1]',
	'Publish <em>[_1]</em>' => 'Publier <em>[_1]</em>',
	'_REBUILD_PUBLISH' => 'Publier',
	'All Files' => 'Tous les fichiers',
	'Index Template: [_1]' => 'Gabarit d\'index: [_1]',
	'Only Indexes' => 'Uniquement les Index',
	'Only [_1] Archives' => 'Uniquement les archives [_1]',
	'Publish (s)' => 'Publier',

## tmpl/cms/edit_role.tmpl
	'Edit Role' => 'Modifier le rôle',
	'Your changes have been saved.' => 'Les modifications ont été enregistrées.',
	'List Roles' => 'Lister les rôles',
	'[quant,_1,User,Users] with this role' => '[quant,_1,Utilisateur,Utilisateurs] avec ce rôle',
	'Useful links' => 'Liens utiles',
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'Vous avez changé les privilèges pour ce rôle. Cela va modifier ce que les utilisateurs associés à ce rôle ont la possibilité de faire. Si vous préférez, vous pouvez sauvegarder ce rôle avec un nom différent.',
	'Role Details' => 'Détails du rôle',
	'Created by' => 'Créé par',
	'Privileges' => 'Privilèges',
	'Administration' => 'Administration',
	'Authoring and Publishing' => 'Auteurs et Publication',
	'Designing' => 'Designer',
	'Commenting' => 'Commenter',
	'Duplicate Roles' => 'Dupliquer les rôles',
	'These roles have the same privileges as this role' => 'Ces rôles ont les même privilèges que ce rôle',
	'Save changes to this role (s)' => 'Enregistrer les modifications de ce rôle (s)',

## tmpl/cms/edit_website.tmpl
	'Your blog configuration has been saved.' => 'La configuration de votre blog a été sauvegardée.',
	'Website Theme' => 'Thème du site web',
	'Select the theme you wish to use for this website.' => 'Sélectionner le thème que vous voudriez utiliser pour ce site web.',
	'Name your website. The website name can be changed at any time.' => 'Nommez votre site web. Le nom du site web peut être changé à tout moment.',
	'Website URL' => 'URL du site',
	'Enter the URL of your website. Exclude the filename (i.e. index.html). Example: http://www.example.com/weblog/' => 'Entrez l\'URL du site web. Excluez le nom de fichier (comme index.html). Exemple : http://www.example.com/weblog/',
	'Website Root' => 'Racine du site web',
	'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/weblog' => 'Saisissez le chemin où votre fichier d\'index principal sera situé. Un chemin absolu (qui commence par \'/\') est préféré, mais vous pouvez aussi utiliser un chemin relatif au répertoire Movable Type. Exemple : /home/melody/public_html/blog',
	'Time Zone' => 'Fuseau horaire',
	'Select your timezone from the pulldown menu.' => 'Veuillez sélectionner votre fuseau horaire dans la liste.',
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
	'UTC+0 (Universal Time Coordinated)' => 'UTC+0 (Temps universel coordonné)',
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
	'Blog language.' => 'Langue du blog.',
	'If you choose a different language than the default language defined at the system level, you may need to change module names in certain templates to include different global modules.' => 'Si vous choisissez une langue différente que la langue du système, vous pourriez avoir à modifier le nom de module dans certain gabarits pour inclure différents modules globaux.',
	'Create Website (s)' => 'Créer site web (s)',
	'You must set your Blog Name.' => 'Vous devez configurer le nom du blog.',
	'You did not select a timezone.' => 'Vous n\'avez pas sélectionné de fuseau horaire.',

## tmpl/cms/cfg_plugin.tmpl
	'[_1] Plugin Settings' => 'Paramètres du plugin [_1]',
	'Find Plugins' => 'Trouver des plugins',
	'Plugin System' => 'Système de plugins',
	'Enable or disable plugin functionality for the entire Movable Type installation.' => 'Activer ou désactiuver la fonction plugin pour l\'installation Movable Type toute entière.',
	'Disable plugin functionality' => 'Désactiver la prise en charge des plugins',
	'Disable Plugins' => 'Désactiver les plugins',
	'Enable plugin functionality' => 'Activer la prise en charge des plugins',
	'Enable Plugins' => 'Activer les plugins',
	'Your plugin settings have been saved.' => 'Les paramètres de votre plugin ont été enregistrés.',
	'Your plugin settings have been reset.' => 'Les paramètres de votre plugin on été réinitialisés.',
	'Your plugins have been reconfigured. Since you\'re running mod_perl, you must restart your web server for these changes to take effect.' => 'Vos plugins ont été reconfigurés. Puisque vous exécutez mod_perl, vous devez redémarrer votre serveur web pour que les changements soient pris en compte.',
	'Your plugins have been reconfigured.' => 'Votre plugin a été reconfiguré.',
	'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => 'Vos plugins ont été reconfigurés. Si vous êtes sous mod_perl vous devez redémarrer votre serveur web pour la prise en compte de ces changements.',
	'Are you sure you want to reset the settings for this plugin?' => 'Êtes-vous sûr de vouloir ré-initialiser les paramètres pour ce plugin ?',
	'Are you sure you want to disable plugins for the entire Movable Type installation?' => 'Êtes-vous sûr de vouloir désactiver les plugins pour l\'installation Movable Type tout entière ?',
	'Are you sure you want to disable this plugin?' => 'Êtes-vous sûr de vouloir désactiver ce plugin ?',
	'Are you sure you want to enable plugins for the entire Movable Type installation? (This will restore plugin settings that were in place before all plugins were disabled.)' => 'Êtes-vous sûr de vouloir activer les plugins pour l\'installation Movable Type toute entière ? (Cela restaurera les paramètres déjà en place avant la désactivation de ceux-ci.)',
	'Are you sure you want to enable this plugin?' => 'Êtes vous sûr de vouloir activer ce plugin ?',
	'Settings for [_1]' => 'Paramètres pour [_1]',
	'Failed to Load' => 'Erreur de chargement',
	'Disable' => 'Désactiver',
	'Enabled' => 'Activé',
	'Enable' => 'Activer',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be completely functional.' => 'Ce plugin n\'a pas été mis à jour afin de supporter Movable Type [_1]. À cause de cela, il pourrait ne pas fonctionner correctement.',
	'Plugin error:' => 'Erreur plugin :',
	'Info' => 'Info',
	'Resources' => 'Ressources',
	'Run [_1]' => 'Lancer [_1]',
	'Documentation for [_1]' => 'Documentation pour [_1]',
	'More about [_1]' => 'En savoir plus sur [_1]',
	'Plugin Home' => 'Accueil Plugin',
	'Author of [_1]' => 'Auteur de [_1]',
	'Tag Attributes:' => 'Attributs de tag:',
	'Text Filters' => 'Filtres de texte',
	'Junk Filters:' => 'Filtres de spam:',
	'Reset to Defaults' => 'Ré-initialiser (retour aux paramètres par défaut)',
	'No plugins with blog-level configuration settings are installed.' => 'Aucun plugin avec une configuration au niveau du blog n\'est installé.',
	'No plugins with configuration settings are installed.' => 'Aucun plugin avec une configuration n\'est installé',

## tmpl/cms/list_blog.tmpl
	'Manage [_1]' => 'Gérer [_1]',
	'You have successfully deleted the website from the Movable Type system.' => 'Vous avez supprimé avec succès le site web de Movable Type.',
	'You have successfully deleted the blog from the website.' => 'Vous avez supprimé avec succès le blog du site.',
	'You have successfully refreshed your templates.' => 'Vous avez réactualisé avec succès vos gabarits.',
	'You have successfully moved selected blogs to another website.' => 'Vous avez déplacé avec succès les blogs sélectionnez vers un autre site web.',
	'Warning: You need to copy uploaded assets to new locations manually. You should consider maintaining copies of uploaded assets in their original locations to avoid broken links.' => 'Attention : Vous devez copiuer les éléments envoyés vers le nouvel emplacement manuellement. Vous devriez maintenir des copies des éléments envoyés à leurs emplacements originaux afin d\'éviter tout risque de lien mort.',
	'You can not refresh templates: [_1]' => 'Vous ne pouvez pas réactualiser le(s) gabarit(s) : [_1]',
	'The website was not deleted. You need to delete blogs under the website.' => 'Le site web n\'a pas été supprimé. Vous devez supprimer les blogs sous le site web.',
	'Create Blog' => 'Créer un blog',

## tmpl/cms/cfg_system_users.tmpl
	'User Settings' => 'Paramètres utilisateur',
	'Your settings have been saved.' => 'Vos paramètres ont été enregistrés.',
	'(No website selected)' => '(Aucun site web sélectionné)',
	'Select website' => 'Sélectionner un site web',
	'(None selected)' => '(Aucune sélection)',
	'User Registration' => 'Enregistrement utilisateur',
	'Allow Registration' => 'Autoriser les enregistrements',
	'Select a system administrator you wish to notify when commenters successfully registered themselves.' => 'Sélectionnez un administrateur que vous souhaitez notifier quand les auteurs de commentaires s\'enregistrent avec succès.',
	'Allow commenters to register with blogs on this system.' => 'Autoriser les auteurs de commenter à s\'enregistrer sur les blogs de ce système.',
	'Notify the following system administrators when a commenter registers:' => 'Notifier les administrateurs ci-dessous lorsqu\'un auteur de commentaires s\'enregistre :',
	'Select system administrators' => 'Sélectionner des administrateur système',
	'Clear' => 'Effacer',
	'Note: System Email Address is not set in System > General Settings. Emails will not be sent.' => 'Note : L\'adresse e-mail système n\'est pas configurée dans Système > Paramètres généraux. Les e-mails ne seront donc pas envoyés.',
	'New User Defaults' => 'Paramètres par défaut pour les nouveaux utilisateurs',
	'Personal Blog' => 'Blog personnel',
	'Have the system automatically create a new personal blog when a user is created. The user will be granted the blog administrator role on this blog.' => 'Le système va créer un nouveau blog personnel à chaque fois qu\'un utilisateur est créé. Cet utilisateur sera administrateur de ce blog.',
	'Automatically create a new blog for each new user.' => 'Créé automatiquement un nouveau blog pour chaque nouvel utilisateur.',
	'Personal Blog Location' => 'Emplacement du blog personnel',
	'Select a website you wish to use as the location of new personal blogs.' => 'Sélectionner un site web que vous voudriez utiliser comme emplacement pour les nouveaux blogs personnels.',
	'Change website' => 'Changer le site web',
	'Personal Blog Theme' => 'Thème de blog personnel',
	'Select the theme that should be used for new personal blogs.' => 'Sélectionner le thème qui devrait être utilisé pour les nouveaux blogs personnels.',
	'(No theme selected)' => '(Aucun thème sélectionné)',
	'Change theme' => 'Changer le thème',
	'Select theme' => 'Sélectionner le thème',
	'Default User Language' => 'Langue par défaut',
	'Choose the default language to apply to all new users.' => 'Choisissez la langue par défaut pour les nouveaux utilisateurs.',
	'Default Time Zone' => 'Fuseau horaire par défaut',
	'Select your time zone from the pulldown menu.' => 'Sélectionnez votre fuseau horaire dans la liste déroulante.',
	'Default Tag Delimiter' => 'Délimiteur de tags par défaut',
	'Define the default delimiter for entering tags.' => 'Définir un délimiteur par défaut pour la saisie des tags.',
	'Comma' => 'Virgule',
	'Space' => 'Espace',
	'Save changes to these settings (s)' => 'Enregistrer les modifications de ces paramètres (s)',

## tmpl/cms/edit_template.tmpl
	'Edit Widget' => 'Editer le Widget',
	'Create Widget' => 'Créer un Widget',
	'Create Template' => 'Créer le gabarit',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]">Recover auto-saved content</a>' => 'Une version de sauvegarde de [_1] a été automatiquement sauvegardée [_3]. <a href="[_2]">Récupérer le contenu sauvegardé</a>',
	'You have successfully recovered your saved [_1].' => 'Vous avez récupéré avec succès votre [_1] sauvegardée.',
	'An error occurred while trying to recover your saved [_1].' => 'Une erreur s\'est produite en essayant de récupérer votre [_1] sauvegardée.',
	'Restored revision (Date:[_1]).' => 'Révision restaurée (Date : [_1]).',
	'Your template changes have been saved.' => 'Les modifications apportées ont été enregistrées.',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => '<a href="[_1]" class="rebuild-link">Publier</a> ce gabarit.',
	'Revision: <strong>[_1]</strong>' => 'Révision : <strong>[_1]</strong>',
	'View revisions of this template' => 'Voir les révisions de ce gabarit',
	'View revisions' => 'Voir les révisions',
	'No revision(s) associated with this template' => 'Aucune révision associé avec ce gabarit',
	'Useful Links' => 'Liens utiles',
	'Module Option Settings' => 'Paramètres des options de module',
	'List [_1] templates' => 'Lister des gabarits de type [_1]',
	'List all templates' => 'Lister tous les gabarits',
	'Included Templates' => 'Gabarits inclus',
	'create' => 'créer',
	'Template Tag Docs' => 'Docs des tags de gabarits',
	'Unrecognized Tags' => 'Tags non reconnus',
	'Save (s)' => 'Enregistrer (s)',
	'Save and Publish this template (r)' => 'Enregistrer et publier ce gabarit (r)',
	'Save &amp; Publish' => 'Enregistrer &amp; publier',
	'You have unsaved changes to this template that will be lost.' => 'Certains de vos changements n\'ont pas été enregistrés : ils seront perdus.',
	'You must set the Template Name.' => 'Vous devez mettre un nom de gabarit.',
	'You must set the template Output File.' => 'Vous devez configurer le fichier de sortie du gabarit.',
	'Processing request...' => 'Requête en cours d\'exécution...',
	'Error occurred while updating archive maps.' => 'Une erreur s\'est produite en mettant à jour les archive maps.',
	'Archive map has been successfully updated.' => 'L\'archive map a été modifiée avec succès.',
	'Are you sure you want to remove this template map?' => 'Êtes-vous sûr de vouloir supprimer cette table de correspondance de gabarit ?',
	'Module Body' => 'Corps du module',
	'Template Body' => 'Corps du gabarit',
	'Template Options' => 'Options de gabarit',
	'Output file: <strong>[_1]</strong>' => 'Fichier de sortie : <strong>[_1]</strong>',
	'Enabled Mappings: [_1]' => 'Tables de correspondances activés : [_1]',
	'Template Type' => 'Type de gabarit',
	'Custom Index Template' => 'Gabarit d\'index personnalisé',
	'Link to File' => 'Lien vers le fichier',
	'Learn more about <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publishing settings</a>' => 'Apprennez en plus à propos des <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">paramètres de publication</a>',
	'Create Archive Mapping' => 'Créer une nouvelle table de correspondance des archives',
	'Server Side Include' => 'Server Side Include',
	'Process as <strong>[_1]</strong> include' => 'Traiter comme inclusion de <strong>[_1]</strong>',
	'Include cache path' => 'Inclure le chemin du cache',
	'Module Caching' => 'Cache des modules',
	'Disabled (<a href="[_1]">change publishing settings</a>)' => 'Désactivé (<a href="[_1]">changer les paramètres de publication</a>)',
	'No caching' => 'Pas de cache',
	'Expire after' => 'Expire après',
	'Expire upon creation or modification of:' => 'Expire lors de la création ou modification de :',
	'Change note' => 'Changer la note',
	'Auto-saving...' => 'Sauvegarde automatique...',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Dernière sauvegarde automatique à [_1]:[_2]:[_3]',

## tmpl/cms/dashboard.tmpl
	'Dashboard' => 'Tableau de bord',
	'Hi, [_1]' => 'Bonjour [_1]',
	'Select a Widget...' => 'Sélectionner un widget...',
	'Your Dashboard has been updated.' => 'Votre tableau de bord a été mis à jour.',
	'You have attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'Vous avez essayé d\'accéder à une fonctionnalité à laquelle vous n\'avez pas le droit. Si vous pensez que cette erreur n\'est pas normale contactez votre administrateur système.',
	'Support directory is not writable.' => 'Le répertoire support n\'est pas ouvert en écriture.',
	'Detail' => 'Détail',
	'Movable Type was unable to write to its \'support\' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.' => 'Movable Type n\'a pas pu écrire dans son répertoire \'support\'. Merci de créer un répertoire à cet endroit : [_1], et de lui ajouter des droits qui permettent au serveur web d\'écrire dedans.',
	'Image::Magick is not configured.' => 'Image::Magick n\'est pas configuré.',
	'Image::Magick is either not present on your server or incorrectly configured. Due to that, you will not be able to use Movable Type\'s userpics feature. If you wish to use that feature, please install Image::Magick or use an alternative image driver.' => 'Image::Magick n\'est pas présent sur votre serveur ou est mal configué. À cause de cela, vous ne pouvez pas utiliser les avatars dans Movable Type. Si vous souhaitez utiliser cette fonctionnalité, veuillez installer Image::Magick ou utiliser un pilote d\'image alternatif.',

## tmpl/cms/edit_widget.tmpl
	'Edit Widget Set' => 'Modifier le groupe de widgets',
	'Create Widget Set' => 'Créer un groupe de widgets',
	'Your widget set changes have been saved.' => 'Les changements de votre groupe de widgets ont été sauvegardés.',
	'Widget Set Name' => 'Nom du groupe de widget',
	'Drag and drop the widgets that belong in this Widget Set into the \'Installed Widgets\' column.' => 'Glissez-déposez les widgets destinés à ce groupe de widgets dans la colonne Widgets installés.',
	'Installed Widgets' => 'Widgets installés',
	'edit' => 'Editer',
	'Available Widgets' => 'Widgets disponibles',
	'Save changes to this widget set (s)' => 'Enregistrer les modifications de ce groupe de widgets',
	'You must set Widget Set Name.' => 'Vous devez nommer ce groupe de widgets.',

## tmpl/cms/list_entry.tmpl
	'Manage Entries' => 'Gérer les notes',
	'Entries Feed' => 'Flux des Notes',
	'Pages Feed' => 'Flux des Pages',
	'The entry has been deleted from the database.' => 'Cette note a été supprimée de la base de données.',
	'The page has been deleted from the database.' => 'Cette page a été supprimée de la base de données.',
	'Quickfilters' => 'Filtres rapides',
	'[_1] (Disabled)' => '[_1] (Désactivé)',
	'Showing only: [_1]' => 'Montrer seulement : [_1]',
	'Remove filter' => 'Supprimer le filtre',
	'All [_1]' => 'Tous(tes) les [_1]',
	'change' => 'modifier',
	'[_1] where [_2] is [_3]' => '[_1] où [_2] est [_3]',
	'Show only entries where' => 'Afficher seulement les notes où',
	'Show only pages where' => 'Afficher seulement les pages où',
	'status' => 'le statut',
	'tag (exact match)' => 'le tag (exact)',
	'tag (fuzzy match)' => 'le tag (fuzzy match)',
	'asset' => 'Élément',
	'is' => 'est',
	'published' => 'publié',
	'unpublished' => 'non publié',
	'review' => 'Vérification',
	'scheduled' => 'programmé',
	'spam' => 'Spam',
	'Select A User:' => 'Sélectionner un utilisateur',
	'User Search...' => 'Recherche utilisateur...',
	'Recent Users...' => 'Utilisateurs récents...',
	'Filter' => 'Filtre',

## tmpl/cms/recover_password_result.tmpl
	'Recover Passwords' => 'Retrouver les mots de passe',
	'No users were selected to process.' => 'Aucun utilisateur sélectionné pour l\'opération.',
	'Return' => 'Retour',

## tmpl/cms/edit_commenter.tmpl
	'Commenter Details' => 'Détails sur l\'auteur de commentaires',
	'The commenter has been trusted.' => 'L\'auteur de commentaires est fiable.',
	'The commenter has been banned.' => 'L\'auteur de commentaires a été banni.',
	'Comments from [_1]' => 'Commentaires de [_1]',
	'commenter' => 'l\'auteur de commentaires',
	'commenters' => 'Auteurs de commentaire',
	'Trust user (t)' => 'Donner le statut fiable à cet utilisateur (t)',
	'Trust' => 'Fiable',
	'Untrust user (t)' => 'Donner le statut non fiable à cet utilisateur (t)',
	'Untrust' => 'Non Fiable',
	'Ban user (b)' => 'Donner le statut banni à cet utilisateur (t)',
	'Ban' => 'Bannir',
	'Unban user (b)' => 'Donner le statut non banni à cet utilisateur (t)',
	'Unban' => 'Non banni',
	'The Name of the commenter' => 'Le nom de l\'auteur de commentaires',
	'View all comments with this name' => 'Afficher tous les commentaires associés à ce nom',
	'The Identity of the commenter' => 'L\'identité de l\'auteur de commentaires',
	'The Email of the commenter' => 'L\'adresse email de l\'auteur de commentaires',
	'Withheld' => 'Retenu',
	'View all comments with this email address' => 'Afficher tous les commentaires associés à cette adresse email',
	'The URL of the commenter' => 'URL de l\'auteur de commentaires',
	'View all comments with this URL address' => 'Afficher tous les commentaires associés à cette URL',
	'The trusted status of the commenter' => 'Le statut de confiance de cet auteur de commentaires',
	'View all commenters' => 'Voir tous les commentaires',

## tmpl/cms/cfg_registration.tmpl
	'Registration Settings' => 'Paramètres des enregistrements',
	'Your blog preferences have been saved.' => 'Les préférences de votre blog ont été enregistrées.',
	'Allow registration for this website.' => 'Permettre les enregistrements pour ce site web.',
	'Registration Not Enabled' => 'Enregistrement non activé',
	'Note: Registration is currently disabled at the system level.' => 'Remarque : L\'enregistrement est actuellement désactivé pour tout le système.',
	'Allow visitors to register as members of this website using one of the Authentication Methods selected below.' => 'Permettre aux visiteurs de s\'enregistrer en tant que membre de ce site en utilisant les méthodes d\'authentification sélectionnées ci-dessous.',
	'Authentication Methods' => 'Méthode d\'authentification',
	'Note: You have selected to accept comments from authenticated commenters only but authentication is not enabled. In order to receive authenticated comments, you must enable authentication.' => 'Attention: vous avez sélectionné d\'accepter uniquement les commentaires de les auteurs de commentaires identifiés MAIS l\'authentification n\'est pas activée. Vous devez l\'activer pour recevoir les commentaire à autoriser.',
	'Require E-mail Address for Comments via TypePad' => 'Demander une adresse e-mail pour les commentaires via TypePad',
	'Visitors must allow their TypePad account to share their e-mail address when commenting.' => 'Les visiteurs doivent autoriser leur compte TypePad à partager leur adresse e-mail lorsqu\'ils commentent.',
	'One or more Perl modules may be missing to use this authentication method.' => 'Un ou plusieurs modules Perl manquent peut-être pour utiliser cette méthode d\'authentification.',
	'Setup TypePad authentication' => 'Configurer l\'authentification TypePad',
	'on the Web Services Settings page.' => 'sur la page des paramètres des services web.',
	'OpenID providers disabled' => 'Fournisseurs OpenID désactivés',
	'The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.' => 'Le module Perl nécessaire pour l\'authentification OpenID (Digest::SHA1) est manquant.',

## tmpl/cms/theme_export_replace.tmpl
	'Export theme folder already exists \'[_1]\'. You can overwrite a existing theme, or cancel to change the Basename?' => 'Le répertoire d\'export \'[_1]\' existe déjà. Vous pouvez le remplacer ou entrer un autre nom de répertoire.',
	'Overwrite' => 'Remplacer',

## tmpl/cms/list_theme.tmpl
	'[_1] Themes' => 'Thèmes [_1]',
	'All Themes' => 'Tous les thèmes',
	'Theme [_1] has been uninstalled.' => 'Le thème [_1] a été désinstallé.',
	'Theme [_1] has been applied.' => 'Le thème [_1] a été appliqué.',
	'Failed' => 'Échec',
	'Current Theme' => 'Thème actuel',
	'In Use' => 'Utilisé',
	'Uninstall' => 'Désinstaller',
	'Author: ' => 'Auteur',
	'This theme cannot be applied to the website due to [_1] errors' => 'Ce thème ne peut pas être appliqué à ce site web suite à [_1] erreurs',
	'Errors' => 'Erreurs',
	'Warnings' => 'Alertes',
	'Theme Errors' => 'Erreurs du thème',
	'Theme Warnings' => 'Alertes du thème',
	'Portions of this theme cannot be applied to the website. [_1] elements will be skipped.' => 'Les portions de ce thème ne peuvent pas être appliqués au site web. [_1] éléments seront ignorés.',
	'Theme Information' => 'Informations sur le thème',
	'No themes are installed.' => 'Aucun thème n\'est installé.',
	'Themes for Both Blogs and Websites' => 'Thèmes pour blogs et sites web',
	'Themes for Blogs' => 'Thèmes pour blogs',
	'Themes for Websites' => 'Thèmes pour sites web',

## tmpl/cms/cfg_system_general.tmpl
	'A test email was sent.' => 'Un e-mail de test a été envoyé.',
	'System Email' => 'Email système',
	'This email address is used in the \'From:\' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, and a few other minor events.' => 'Cette adresse e-mail est utilisé dans l\'en-tête \'Expéditeur\' de chaque e-mail envoyé par Movable Type. Les emails peuvent être envoyés pour des rappels de mots de passe, des enregistrement de nouveaux utilisateurs, des notifications de commentaires ou de trackbacks et d\'autres événements mineurs.',
	'Debug Mode' => 'Mode debug',
	'Values other than zero provide additional diagnostic information for troubleshooting problems with your Movable Type installation.  More information is available in the <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">Debug Mode documentation</a>.' => 'Les valeurs autres que zéro fournissent des informations de diagnostique supplémentaires pour la résolution de problèmes avec votre installation Movable Type. Plus d\'informations dans la <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">documentation du mode debug</a>.',
	'Performance Logging' => 'Journalisation des performances',
	'Turn on performance logging, which will report any system event that takes the number of seconds specified below.' => 'Activer la journalisation des performances, cela notera tout événement système prenant le nombre de secondes spécifié ci-dessous.',
	'Log Path' => 'Chemin du journal',
	'The filesystem directory where performance logs are written.  The web server must have write permission in this directory.' => 'Le répertoire où le journal est écrit doit être ouvert en écriture pour le serveur web.',
	'Logging Threshold' => 'Seuil de journalisation',
	'The time limit for unlogged events in seconds. Any event that takes this amount of time or longer will be reported.' => 'La limite des événements non inscrits dans le journal en secondes. Tout événement prenant ce temps ou plus long sera reporté.',
	'Enable this setting to have Movable Type track revisions made by users to entries, pages and templates.' => 'Activer ce paramètre pour que Movable Type enregistre les révisions faites par les utilisateurs aux notes, pages et gabarits.',
	'Track revision history' => 'Historique d\'enregistrement des révisions',
	'System-wide Feedback Controls' => 'Contrôles de commentaires et trackback du système',
	'Prohibit Comments' => 'Refuser les commentaires',
	'This will override all individual blog settings.' => 'Cela va écraser les paramètres de tous les blogs individuels',
	'Disable comments for all blogs.' => 'Désactivier les commentaires pour tous les blogs',
	'Prohibit TrackBacks' => 'Refuser les trackbacks',
	'Disable receipt of TrackBacks for all blogs.' => 'Désactiver la réception de trackback pour tout les blogs',
	'Outbound Notifications' => 'Notifications sortantes',
	'Prohibit Notification Pings' => 'Refuser les pings de notification',
	'Disable sending notification pings when a new entry is created in any blog on the system.' => 'Désactiver l\'envoi de pings lorsqu\'une nouvelle note est créée sur un blog',
	'Disable notification pings for all blogs.' => 'Désasctiver les pings de notification pour tous les blogs',
	'Send Outbound TrackBacks to' => 'Envoyer les trackbacks sortant vers',
	'Do not send outbound TrackBacks or use TrackBack auto-discovery if your installation is intended to be private.' => 'Ne pas envoyer de trackbacks sortant ou utiliser la découvertue automatique lorsque l\'installation est censée être privée.',
	'Any site' => 'Tout site',
	'(No Outbound TrackBacks)' => '(Pas de trackbacks sortants)',
	'Only to blogs within this system' => 'Seulement vers les blogs de ce système',
	'Only to websites on the following domains:' => 'Seulement vers les blogs de ces domaines :',
	'Send Email To' => 'Envoyer un e-mail vers',
	'The email address that should receive a test email from Movable Type.' => 'Cette adresse e-mail devrait recevoir un e-mail de teste de Movable Type',

## tmpl/cms/view_rpt_log.tmpl
	'Schwartz Error Log' => 'Journal des erreurs Schwartz',
	'The activity log has been reset.' => 'Le journal (logs) a été réinitialisé.',
	'All times are displayed in GMT[_1].' => 'Toutes les heures sont affichées en GMT[_1].',
	'All times are displayed in GMT.' => 'Toutes les heures sont affichées en GMT.',
	'Are you sure you want to reset the activity log?' => 'Êtes-vous sûr(e) de vouloir ré-initialiser le journal (logs) ?',
	'Showing all Schwartz errors' => 'Affichage de toutes les erreurs Shwartz',

## tmpl/cms/list_member.tmpl
	'Are you sure you want to remove the user from this role?' => 'Êtes-vous sûr de vouloir retirer l\'utilisateur de ce rôle ?',
	'Add a user to this blog' => 'Ajouter un utilisateur à ce blog',
	'Add a user to this website' => 'Ajouter un utilisateur à ce site web',
	'Show only users where' => 'Afficher uniquement les utilisateurs où',
	'role' => 'rôle',
	'enabled' => 'activé',
	'disabled' => 'désactivé',
	'pending' => 'en attente',

## tmpl/cms/export_theme.tmpl
	'Export [_1] Themes' => 'Exporter les [_1] thèmes',
	'Theme package have been saved.' => 'L\'archive du thème a été enregistrée.',
	'The name of your theme.' => 'Le nom de votre thème.',
	'Use letters, numbers, dash or underscore only (a-z, A-Z, 0-9, \'-\' or \'_\').' => 'Utiliser des lettres, chiffres, tirets ou tirets bas seulement (a-z, A-Z, 0-9, \'-\' or \'_\').',
	'Version' => 'Version',
	'A version number for this theme.' => 'Numéro de version de ce thème.',
	'A description for this theme.' => 'Description du thème.',
	'_THEME_AUTHOR' => 'Auteur',
	'The author of this theme.' => 'Nom de l\'auteur de ce thème',
	'Author link' => 'Site de l\'auteur',
	'The author\'s website.' => 'Lien vers le site web de l\'auteur.',
	'Options' => 'Options',
	'Additional assets to be included in the theme.' => 'Éléments additionnels destinés à être inclus dans ce thème',
	'Destination' => 'Destination',
	'Select How to get theme.' => 'Sélectionnez comment récupérer le thème',
	'Setting for [_1]' => 'Paramètres pour [_1]',
	'You must set Theme Name.' => 'Vous devez entrer un nom de thème',
	'Basename may only contain letters, numbers, and the dash or underscore character. The basename must begin with a letter.' => 'Le nom de base ne peut contenir que des lettres, chiffres tirets et tirets bas. Il doit commencer par une lettre.',
	'Cannot install new theme with existing (and protected) theme\'s basename.' => 'Impossible d\'installer un nouveau thème avec un nom de base existant (et protégé).',
	'You must set Author Name.' => 'Vous devez entrer un nom d\'auteur.',
	'Theme version may only contain letters, numbers, and the dash or underscore character.' => 'La version du thème ne peut contenir que des lettres, chiffres, tirets et tirets bas.',

## tmpl/cms/backup.tmpl
	'Backup [_1]' => 'Sauvegarder [_1]',
	'What to Backup' => 'Ce qu\'il faut sauvegarder',
	'This option will backup Users, Roles, Associations, Blogs, Entries, Categories, Templates and Tags.' => 'Cette option va sauvegarder les utilisateurs, rôles, associations, blogs, notes, catégories, gabarits et tags.',
	'Everything' => 'Tout',
	'Choose websites...' => 'Sélectionner des sites webs...',
	'Archive Format' => 'Format d\'archive',
	'The type of archive format to use.' => 'Le type de format d\'archive à utiliser.',
	'Don\'t compress' => 'Ne pas compresser',
	'Target File Size' => 'Limiter la taille du fichier cible',
	'Approximate file size per backup file.' => 'Taille de fichier approximative par fichier de sauvegarde.',
	'No size limit' => 'Aucune limite de taille',
	'Make Backup (b)' => 'Sauvegarder (b)',
	'Make Backup' => 'Sauvegarder',

## tmpl/cms/edit_entry.tmpl
	'Create Page' => 'Créer une Page',
	'Add folder' => 'Ajouter un répertoire',
	'Add folder name' => 'Ajouter un nom de répertoire',
	'Add new folder parent' => 'Ajouter un nouveau répertoire parent',
	'Preview this page (v)' => 'Prévisualiser cette page (v)',
	'Delete this page (x)' => 'Supprimer cette page (x)',
	'View Page' => 'Afficher une Page',
	'Create Entry' => 'Créer une nouvelle note',
	'Add category' => 'Ajouter une catégorie',
	'Add category name' => 'Ajouter un nom de catégorie',
	'Add new category parent' => 'Ajouter une nouvelle catégorie parente',
	'Preview this entry (v)' => 'Prévisualiser cette note (v)',
	'Delete this entry (x)' => 'Supprimer cette note (x)',
	'View Entry' => 'Afficher la note',
	'A saved version of this entry was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Une version enregistrée de cette note a été sauvergardée automatiquement [_2]. <a href="[_1]">Récupérer le contenu sauvegardé automatiquement</a>',
	'A saved version of this page was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Une version enregistrée de cette page a été sauvergardée automatiquement [_2]. <a href="[_1]">Récupérer le contenu sauvegardé automatiquement</a>',
	'This entry has been saved.' => 'Cette note a été enregistrée.',
	'This page has been saved.' => 'Cette page a été enregistrée.',
	'One or more errors occurred when sending update pings or TrackBacks.' => 'Erreur lors de l\'envoi des pings ou des trackbacks.',
	'_USAGE_VIEW_LOG' => 'L\'erreur est enregistrée dans le <a href="[_1]">journal (logs)</a>.',
	'Your customization preferences have been saved, and are visible in the form below.' => 'Vos préférences ont été enregistrées et sont affichées dans le formulaire ci-dessous.',
	'Your changes to the comment have been saved.' => 'Les modifications apportées aux commentaires ont été enregistrées.',
	'Your notification has been sent.' => 'Votre notification a été envoyée.',
	'You have successfully recovered your saved entry.' => 'Vous avez récupéré le contenu sauvegardé de votre note avec succès.',
	'You have successfully recovered your saved page.' => 'Vous avez récupéré le contenu sauvegardé de votre page avec succès.',
	'An error occurred while trying to recover your saved entry.' => 'Une erreur est survenue lors de la tentative de récupération de la note enregistrée.',
	'An error occurred while trying to recover your saved page.' => 'Une erreur est survenue lors de la tentative de récupération de la page enregistrée.',
	'You have successfully deleted the checked comment(s).' => 'Les commentaires sélectionnés ont été supprimés.',
	'You have successfully deleted the checked TrackBack(s).' => 'Le(s) trackback(s) sélectionné(s) ont été correctement supprimé(s).',
	'Restored revision (Date:[_1]).  The current status is: [_2]' => 'Révision (Date :[_1]) restaurée. Le statut actuel est : [_2].',
	'Some of tags in the revision could not be loaded because they have been removed.' => 'Certaines balises dans cette révisin ne peuvent pas être chargées car elles ont été retirées.',
	'Some [_1] in the revision could not be loaded because they have been removed.' => 'Certain(e)s [_1] dans cette révisin ne peuvent pas être chargées car elles ont été retirées.',
	'Change Folder' => 'Modifier le Dossier',
	'Unpublished (Spam)' => 'Non publié (Spam)',
	'View revisions of this [_1]' => 'Voir les révisions de ce [_1]',
	'No revision(s) associated with this [_1]' => 'Aucune révision n\'est associée à ce [_1]',
	'[_1] - Created by [_2]' => '[_1] - a été créé par [_2]',
	'[_1] - Published by [_2]' => '[_1] - a été publié par [_2]',
	'[_1] - Edited by [_2]' => '[_1] - a été édité par [_2]',
	'Save Draft' => 'Enregistrer en tant que brouillon',
	'Draft this [_1]' => 'Mettre ce [_1] en brouillon',
	'Publish this [_1]' => 'Publier cette [_1]',
	'Update' => 'Mettre à jour',
	'Update this [_1]' => 'Mettre à jour cette [_1]',
	'Unpublish' => 'Dé-publier',
	'Unpublish this [_1]' => 'Dé-publier cette [_1]',
	'Save this [_1]' => 'Enregistrer cette [_1]',
	'Publish On' => 'Publié le',
	'Warning: If you set the basename manually, it may conflict with another entry.' => 'ATTENTION : Editer le nom de base manuellement peut créer des conflits avec d\'autres notes.',
	'Warning: Changing this entry\'s basename may break inbound links.' => 'ATTENTION : Changer le nom de base de cette note peut casser des liens entrants.',
	'You must configure this blog before you can publish this entry.' => 'Vous devez configurer ce blog avant de publier cette note.',
	'You must configure this blog before you can publish this page.' => 'Vous devez configurer ce blog avant de publier cette page.',
	'close' => 'fermer',
	'Accept' => 'Accepter',
	'<a href="[_2]">[_1]</a>' => '<a href="[_2]">[_1]</a>',
	'View Previously Sent TrackBacks' => 'Afficher les trackbacks envoyés précédemment',
	'Outbound TrackBack URLs' => 'URLs trackbacks sortants',
	'[_1] Assets' => 'Éléments [_1]',
	'Remove this asset.' => 'Supprimer cet élément',
	'No assets' => 'Aucun éléments',
	'You have unsaved changes to this entry that will be lost.' => 'Certains de vos changements dans cette note n\'ont pas été enregistrés : ils seront perdus.',
	'You have unsaved changes to this page that will be lost.' => 'Certains de vos changements dans cette page n\'ont pas été enregistrés : ils seront perdus.',
	'Enter the link address:' => 'Saisissez l\'adresse du lien :',
	'Enter the text to link to:' => 'Saisissez le texte du lien :',
	'Your entry screen preferences have been saved.' => 'Vos préférences d\'édition ont été enregistrées.',
	'Are you sure you want to use the Rich Text editor?' => 'Êtes-vous sûr de vouloir utiliser l\'éditeur de texte enrichi ?',
	'Make primary' => 'Rendre principal',
	'Fields' => 'Champs',
	'Metadata' => 'Métadonnées',
	'Reset display options' => 'Ré-initialiser les options d\'affichage',
	'Reset display options to blog defaults' => 'Ré-initialiser les options d\'affichage avec les valeurs par défaut du blog',
	'Reset defaults' => 'Ré-initialiser les valeurs par défaut',
	'This post was held for review, due to spam filtering.' => 'Cette note a été retenue pour vérification, à cause du filtrage spam.',
	'This post was classified as spam.' => 'Cette note a été marquée comme étant du spam.',
	'Spam Details' => 'Détails du spam',
	'Score' => 'Score',
	'Results' => 'Résultats',
	'Permalink:' => 'Lien permanent :',
	'Share' => 'Partager',
	'Format:' => 'Format :',
	'(comma-delimited list)' => '(liste délimitée par virgule)',
	'(space-delimited list)' => '(liste délimitée par espace)',
	'(delimited by \'[_1]\')' => '(délimitée par \'[_1]\')',
	'None selected' => 'Aucune sélectionnée',

## tmpl/cms/view_log.tmpl
	'Show only errors' => 'Montrer uniquement les erreurs',
	'System Activity Log' => 'Journal (logs)',
	'Filtered' => 'Filtrés',
	'Filtered Activity Feed' => 'Flux d\'activité filtré',
	'Download Filtered Log (CSV)' => 'Télécharger le journal filtré (CSV)',
	'Download Log (CSV)' => 'Télécharger le journal (CSV)',
	'Clear Activity Log' => 'Effacer le journal (logs)',
	'Showing all log records' => 'Affichage de toutes les données du journal',
	'Showing log records where' => 'Affichage des données du journal où',
	'Show log records where' => 'Afficher les données du journal où',
	'level' => 'le statut',
	'classification' => 'classification',
	'Security' => 'Sécurité',
	'Information' => 'Information',
	'Debug' => 'Debug',
	'Security or error' => 'Sécurité ou erreur',
	'Security/error/warning' => 'Sécurité/erreur/mise en garde',
	'Not debug' => 'Pas débugué',
	'Debug/error' => 'Debug/erreur',

## tmpl/cms/list_author.tmpl
	'You have successfully disabled the selected user(s).' => 'Vous avez désactivé avec succès les utilisateurs sélectionnés.',
	'You have successfully enabled the selected user(s).' => 'Vous avez activé avec succès les utilisateurs sélectionnés.',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'Vous avez supprimé avec succès les utilisateurs dans le système.',
	'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Enterprise.' => 'Les utilisateurs effacés existent encore dans le répertoire externe. En conséquence ils pourront encore s\'identifier dans Movable Type Entreprise',
	'You have successfully synchronized users\' information with the external directory.' => 'Vous avez synchronisé avec succès les informations des utilisateurs avec le répertoire externe.',
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => 'Certains des utilisateurs sélectionnés ([_1])ne peuvent pas être ré-activés car ils ne sont pas dans le répertoire externe.',
	'An error occured during synchronization.  See the <a href=\'[_1]\'>activity log</a> for detailed information.' => 'Une erreur s\'est produite durant la synchronisation.  Consultez le <a href=\'[_1]\'>journal (logs)</a> pour plus d\'informations.',
	'User properties' => 'Propriétés de l\'utilisateur',
	'Enable selected users (e)' => 'Activer les utilisateurs sélectionnés (e)',
	'_USER_ENABLE' => 'Activer',
	'Disable selected users (d)' => 'Désactiver les utilisateurs sélectionnés (d)',
	'_USER_DISABLE' => 'Désactiver',
	'Showing All Users' => 'Afficher tous les utilisateurs',
	'_NO_SUPERUSER_DISABLE' => 'Puisque vous êtes administrateur du système Movable Type, vous ne pouvez vous désactiver vous-même.',

## tmpl/cms/refresh_results.tmpl
	'Template Refresh' => 'Réactualiser les gabarits',
	'No templates were selected to process.' => 'Aucun gabarit sélectionné pour cette action.',
	'Return to templates' => 'Retourner aux gabarits',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Modifier le répertoire',
	'Your folder changes have been made.' => 'Vos modifications du répertoire ont été faites.',
	'Manage Folders' => 'Gérer les Répertoires',
	'Manage pages in this folder' => 'Gérer les pages de ce dossier',
	'You must specify a label for the folder.' => 'Vous devez spécifier un nom pour le répertoire.',
	'Save changes to this folder (s)' => 'Enregistrer les modifications de ce répertoire (s)',

## tmpl/cms/import_others.tmpl
	'Start title HTML (optional)' => 'HTML de début de titre (optionnel)',
	'End title HTML (optional)' => 'HTML de fin du titre (optionnel)',
	'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => 'Si le logiciel à partir duquel vous importez n\'a pas de champ Titre, vous pouvez utiliser ce paramètre pour identifier un titre dans le corps de votre note.',
	'Default entry status (optional)' => 'Statut des notes par défaut (optionnel)',
	'If the software you are importing from does not specify an entry status in its export file, you can set this as the status to use when importing entries.' => 'Si le logiciel à partir duquel vous importez ne spécifie pas un statut pour les notes dans son fichier d\'export, vous pouvez utiliser ce statut-ci lors de l\'importation des notes.',
	'Select an entry status' => 'Sélectionner un statut de note',
	'Unpublished' => 'Non publié',

## tmpl/cms/list_notification.tmpl
	'Manage [_1] Address Book' => 'Gérer le carnet d\'adresses [_1]',
	'You have added [_1] to your address book.' => 'Vous avez ajouté [_1] à votre carnet d\'adresses.',
	'You have successfully deleted the selected contacts from your address book.' => 'Vous avez supprimé avec succès les contacts sélectionnés de votre carnet d\'adresses.',
	'Download Address Book (CSV)' => 'Télécharger le carnet d\'adresses (CSV)',
	'contact' => 'contact',
	'contacts' => 'contacts',
	'Create Contact' => 'Créer un contact',
	'Add Contact' => 'Ajouter un contact',

## tmpl/cms/export.tmpl
	'Export Blog Entries' => 'Exporter les notes du blog',
	'You must select a blog to export.' => 'Vous devez sélectionner un blog à exporter.',
	'_USAGE_EXPORT_1' => 'L\'exportation vous permet de sauvegarder le contenu de votre blog dans un fichier. Vous pourrez par la suite procéder à l\'importation de ce fichier si vous souhaitez restaurer vos notes ou transférer vos notes d\'un blog à un autre.',
	'Blog to Export' => 'Blog à exporter',
	'Select a blog for exporting.' => 'Sélectionnez un blog à exporter.',
	'Change blog' => 'Changer de blog',
	'Select blog' => 'Sélectionner le blog',
	'Export Blog (s)' => 'Exporter le blog (s)',
	'Export Blog' => 'Exporter le blog',

## tmpl/cms/search_replace.tmpl
	'You must select one or more item to replace.' => 'Vous devez sélectionner un ou plusieurs objets à remplacer.',
	'Search Again' => 'Chercher encore',
	'Case Sensitive' => 'Sensible à la casse',
	'Regex Match' => 'Expression Rationnelle',
	'Limited Fields' => 'Champs limités',
	'Date Range' => 'Période (date)',
	'Reported as Spam?' => 'Notifié comme spam ?',
	'Search Fields:' => 'Rechercher les champs :',
	'_DATE_FROM' => 'Depuis le',
	'_DATE_TO' => 'jusqu\'au',
	'Submit search (s)' => 'Soumettre la recherche (s)',
	'Replace' => 'Remplacer',
	'Replace Checked' => 'Remplacer les objets sélectionnés',
	'Successfully replaced [quant,_1,record,records].' => 'Remplacements effectués avec succès dans [quant,_1,enregistrement,enregistrements].',
	'Showing first [_1] results.' => 'Afficher d\'abord [_1] résultats.',
	'Show all matches' => 'Afficher tous les résultats',
	'[quant,_1,result,results] found' => '[quant,_1,résultat trouvé,résultats trouvés]',

## tmpl/cms/edit_category.tmpl
	'Edit Category' => 'Editer les catégories',
	'Your category changes have been made.' => 'Les modifications apportées ont été enregistrées.',
	'Manage entries in this category' => 'Gérer les notes dans cette catégorie',
	'You must specify a label for the category.' => 'Vous devez spécifier un titre pour cette catégorie.',
	'_CATEGORY_BASENAME' => 'Nom de base',
	'This is the basename assigned to your category.' => 'Ceci est le nom de base assigné à votre catégorie.',
	'Warning: Changing this category\'s basename may break inbound links.' => 'Attention: changer le nom de la catégorie risque de casser des liens entrants.',
	'Inbound TrackBacks' => 'Trackbacks entrants',
	'If enabled, TrackBacks will be accepted for this category from any source.' => 'Si activé, les trackbacks seront acceptés pour cette catégorie quelle que soit la source.',
	'View TrackBacks' => 'Voir les trackbacks',
	'TrackBack URL for this category' => 'URL trackback pour cette catégorie',
	'_USAGE_CATEGORY_PING_URL' => 'Il s\'agit de l\'URL utilisée par vos lecteurs pour envoyer des trackbacks aux notes de votre blog. Si vous souhaitez permettre l\'envoi d\'un trackback à tous vos lecteurs, publiez cette URL. Si vous préférez réserver l\'envoi d\'un trackback à seulement certaines personnes, communiquez cette URL de manière privée. Enfin, si vous souhaitez inclure la liste des trackbacks entrant dans l\'index de votre gabarit, consultez la documentation Movable Type.',
	'Passphrase Protection' => 'Protection Passphrase',
	'Outbound TrackBacks' => 'Trackbacks sortants',
	'Trackback URLs' => 'URLs de trackback',
	'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you create an entry in this category. (Separate URLs with a carriage return.)' => 'Saisir les URLs des sites web auxquels vous souhaitez envoyer un trackback chaque fois que vous créez une note dans cette catégorie. (Séparez les URLs avec un retour chariot.)',
	'Save changes to this category (s)' => 'Enregistrer les modifications de cette catégorie (s)',

## tmpl/cms/preview_strip.tmpl
	'Return to the compose screen' => 'Retourner sur l\'éditeur',
	'Return to the compose screen (e)' => 'Retourner sur l\'éditeur (e)',
	'You are previewing the entry entitled &ldquo;[_1]&rdquo;' => 'Vous prévisualisez la note &ldquo;[_1]&rdquo;',
	'You are previewing the page entitled &ldquo;[_1]&rdquo;' => 'Vous prévisualisez la page &ldquo;[_1]&rdquo;',

## tmpl/cms/list_banlist.tmpl
	'IP Banning Settings' => 'Paramètres des IP bannies',
	'IP addresses' => 'Adresses IP',
	'Delete selected IP Address (x)' => 'Effacer les adresses IP sélectionnées (x)',
	'You have added [_1] to your list of banned IP addresses.' => 'L\'adresse [_1] a été ajoutée à la liste des adresses IP bannies.',
	'You have successfully deleted the selected IP addresses from the list.' => 'L\'adresse IP sélectionnée a été supprimée de la liste.',
	'Ban IP Address' => 'Bannir l\'adresse IP',
	'Date Banned' => 'Bannie le :',

## tmpl/cms/list_ping.tmpl
	'Manage TrackBacks' => 'Gérer les trackbacks',
	'The selected TrackBack(s) has been approved.' => 'Les trackbacks sélectionnés ont été approuvés.',
	'All TrackBacks reported as spam have been removed.' => 'Tous les trackbacks notifiés comme spam ont été supprimés.',
	'The selected TrackBack(s) has been unapproved.' => 'Les trackbacks suivants ont été désapprouvés.',
	'The selected TrackBack(s) has been reported as spam.' => 'Les trackbacks sélectionnés ont été notifiés comme spam.',
	'The selected TrackBack(s) has been recovered from spam.' => 'Les trackbacks sélectionnés ont été récupérés du spam.',
	'The selected TrackBack(s) has been deleted from the database.' => 'Le(s) trackback(s) sélectionné(s) ont été supprimé(s) de la base de données.',
	'No TrackBacks appeared to be spam.' => 'Aucun trackback ne semble être du spam.',
	'Show only [_1] where' => 'Afficher seulement : [_1] où',
	'approved' => 'Approuvé',
	'unapproved' => 'non-approuvé',

## tmpl/cms/error.tmpl
	'An error occurred' => 'Une erreur s\'est produite',

## tmpl/cms/cfg_entry.tmpl
	'Compose Settings' => 'Paramètres d\'édition',
	'Your preferences have been saved.' => 'Vos préférences ont été sauvegardées.',
	'Publishing Defaults' => 'Préférences de publication',
	'Listing Default' => 'Préférences de liste',
	'Select the number of days of entries or the exact number of entries you would like displayed on your blog.' => 'Sélectionner le nombre de jours de notes ou le nombre exact de notes que vous voulez afficher sur votre blog.',
	'Days' => 'Jours',
	'Posts' => 'Notes',
	'Order' => 'Ordre',
	'Select whether you want your entries displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Choisissez si vous voulez afficher vos notes en ascendant (les plus anciennes en haut) ou descendant (les plus récentes en haut).',
	'Ascending' => 'Croissant',
	'Descending' => 'Décroissant',
	'Excerpt Length' => 'Longueur de l\'extrait',
	'Enter the number of words that should appear in an auto-generated excerpt.' => 'Entrez le nombre de mot à afficher pour les extraits de notes.',
	'Date Language' => 'Langue de la date',
	'Select the language in which you would like dates on your blog displayed.' => 'Sélectionnez la langue dans laquelle vous souhaitez afficher les dates sur votre blog.',
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
	'Basename Length' => 'Longueur du nom de base',
	'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => 'Spécifier la longueur par défaut du nom de base. peut être comprise entre 15 et 250.',
	'Compose Defaults' => 'Préférences d\'édition',
	'Text Formatting' => 'Mise en forme du texte',
	'Specifies the default Text Formatting option when creating a new entry.' => 'Spécifie l\'option par défaut de mise en forme du texte des nouvelles notes.',
	'Specifies the default Accept Comments setting when creating a new entry.' => 'Spécifie l\'option par défaut des commentaires acceptés lors de la création d\'une nouvelle note.',
	'Setting Ignored' => 'Paramètre ignoré',
	'Note: This option is currently ignored since comments are disabled either blog or system-wide.' => 'Remarque : Cette option est actuellement ignorée car les commentaires sont désactivés sur le blog ou sur tout le système.',
	'Accept TrackBacks' => 'Accepter les trackbacks',
	'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Spécifie l\'option par défaut des trackbacks acceptés lors de la création d\'une nouvelle note.',
	'Note: This option is currently ignored since TrackBacks are disabled either blog or system-wide.' => 'Remarque : Cette option est actuellement ignorée car les trackbacks sont désactivés soit sur le blog, soit au niveau de tout le système.',
	'Entry Fields' => 'Champs des notes',
	'_USAGE_ENTRYPREFS' => 'La configuration des champs détermine les champs de saisie qui apparaîtront dans les écrans de création et de modification des notes. Vous pouvez sélectionner une configuration existante (basique ou avancée), ou personnaliser vos écrans en activant le bouton Personnalisée, puis en sélectionnant les champs que vous souhaitez voir apparaître.',
	'Page Fields' => 'Champs des pages',
	'Punctuation Replacement' => 'Remplacement de la ponctuation',
	'Replace UTF-8 characters frequently used by word processors with their more common web equivalents.' => 'Remplacer les caractères UTF-8 utilisés fréquemment par l\'éditeur de texte par leur équivalent web le plus commun.',
	'No substitution' => 'Ne pas effectuer de remplacements',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'Entités de caractères (&amp#8221;, &amp#8220;, etc.)',
	'ASCII equivalents (&quot;, \', ..., -, --)' => 'Equivalents ASCII (&quot;, \', ..., -, --)',
	'Replace Fields' => 'Appliquer le remplacement des caractères dans les champs',

## tmpl/cms/list_role.tmpl
	'Manage Roles' => 'Gérer les rôles',
	'You have successfully deleted the role(s).' => 'Vous avez supprimé avec succès le(s) rôle(s).',
	'roles' => 'rôles',
	'_USER_STATUS_CAPTION' => 'Statut',
	'Members' => 'Membres',
	'Role Is Active' => 'Le rôle est actif',
	'Role Not Being Used' => 'Le rôle n\'est pas utilisé',

## tmpl/cms/cfg_prefs.tmpl
	'Error: Movable Type was not able to create a directory for publishing your blog. If you create this directory yourself, grant write permission to the web server.' => 'Erreur : Movable Type n\'a pas pu créer un répertoire de publication pour votre blog. Si vous créez ce répertoire vous-même, donnez la permission au serveur web.',
	'[_1] Settings' => 'Paramètres de [_1]',
	'Name your blog. The name can be changed at any time.' => 'Nommez votre blog. Cela pourra être changé à tout moment.',
	'Enter a description for your blog.' => 'Saisissez une description pour votre blog.',
	'License' => 'Licence',
	'Your blog is currently licensed under:' => 'Votre blog est actuellement sous licence :',
	'Change license' => 'Changer licence',
	'Remove license' => 'Retirer licence',
	'Your blog does not have an explicit Creative Commons license.' => 'Votre blog n\'a pas de licence Creative Commons explicite.',
	'Select a license' => 'Sélectionner une licence',
	'Publishing Paths' => 'Chemins de publication',
	'Warning: Changing the site URL can result in breaking all the links in your blog.' => 'Attention : Modifier l\'URL du site peut rompre tous les liens de votre blog.',
	'The URL of your blog. Exclude the filename (i.e. index.html). End with \'/\'. Example: http://www.example.com/blog/' => 'L\'URL de votre blog en excluant les noms de fichier (comme index.html) et se termine par \'/\'. Exemple : http://www.exemple.com/blog/',
	'The URL of your website. Exclude the filename (i.e. index.html).  End with \'/\'. Example: http://www.example.com/' => 'L\'URL de votre site web en excluant les noms de fichier (comme index.html) et se termine par \'/\'. Exemple : http://www.exemple.com/',
	'Note: Changing your site root requires a complete publish of your site.' => 'Remarque : La modification de la racine de votre site nécessite une publication complète de votre site.',
	'The path where your index files will be published. Do not end with \'/\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog' => 'Le chemin de publication de vos fichiers d\'index. Ne pas terminer par \'/\'. Exemple: /home/mt/public_html/blog ou C:\www\public_html\blog',
	'The path where your index files will be published. An absolute path (starting with \'/\' for Linux or \'C:\' for Windows) is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/mt/public_html or C:\www\public_html' => 'Le chemin de publication de vos fichiers d\'index. Un chemin absolu (commençant par \'/\' sur Linux ou \'C:\'sur Windows) est recommandé, mais vous pouvez également utiliser un chemin relatif vers le répertoire Movable Type . Exemple: /home/mt/public_html ou C:\www\public_html', # Translate - New
	'Advanced Archive Publishing' => 'Publication avancée des archives',
	'Select this option only if you need to publish your archives outside of your Site Root.' => 'Sélectionnez cette option si vous avez besoin de publier vos archives en dehors de la racine du Site.',
	'Publish archives outside of Site Root' => 'Publier les archives en dehors de la racine du site',
	'Enter the URL of the archives section of your blog. Example: http://www.example.com/blog/archives/' => 'Entrez l\'URL des archives de votre blog. Exemple : http://www.exemple.com/blog/archives/',
	'Warning: Changing the archive URL can result in breaking all the links in your blog.' => 'Attention : Si vous modifiez l\'URL d\'archive vous pouvez casser tous les liens dans votre blog.',
	'Enter the path where your archive files will be published. Example: /home/mt/public_html/blog/archives or C:\www\public_html\blog\archives' => 'Entrez le chemin où les archives devront être publiées. Exemple : /home/mt/public_html/blog/archives ou C:\www\public_html\blog\archives',
	'Warning: Changing the archive path can result in breaking all the links in your blog.' => 'Attention : Changer le chemin d\'archive peut casser tous les liens de votre blog.',
	'Asynchronous Job Queue' => 'File d\'attente asynchrone',
	'Use Publishing Queue' => 'Utiliser la publication en mode File d\'attente',
	'Requires the use of a cron job or a scheduled task on your server to publish pages in the background.' => 'L\'utilisateur devra créer une tâche cron sur votre serveur pour publier les pages en arrière-plan.',
	'Use background publishing queue for publishing static pages for this blog' => 'Utiliser la publication en mode File d\'attente pour publier les pages statiques de ce blog',
	'Dynamic Publishing Options' => 'Options de publication dynamique',
	'Enable dynamic cache' => 'Activer le cache dynamique',
	'Enable conditional retrieval' => 'Activer la récupération conditionnelle',
	'Archive Settings' => 'Paramètres d\'archive', # Translate - New
	'File Extension' => 'Extension de fichier',
	'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'Entrez l\'extension du fichier d\'archive. Elle peut être au choix \'html\', \'shtml\', \'php\', etc. NB: Ne pas indiquer la période (\'.\').',
	'Preferred Archive' => 'Archive préférée',
	'Used to generate URLs (permalinks) for this blog\'s archived entries. Choose one of the archives type used in this blog\'s archive templates.' => 'Utilisé pour générer des URLs (liens permanents) pour les notes archivés de ce blog. Sélectionnez un type d\'archive utilisé dans les gabarits d\'archives de ce blog.',
	'No archives are active' => 'Aucune archive n\'est active',
	'Module Settings' => 'Paramètres de module', # Translate - New
	'Server Side Includes' => 'Service Side Includes',
	'None (disabled)' => 'Aucun (désactivé)',
	'PHP Includes' => 'Inclusions PHP',
	'Apache Server-Side Includes' => 'Inclusions Apache Server-Side',
	'Active Server Page Includes' => 'Inclusions Active Server Page',
	'Java Server Page Includes' => 'Inclusions Java Server Page',
	'Allow properly configured template modules to be cached to enhance publishing performance.' => 'Permettre aux modules de gabarits optimisés pour le cache à augmenter les performances de publications.',
	'Note: Revision History is currently disabled at the system level.' => '
	Note : L\'historique de révision est actuellement désactivé au niveau système.',
	'Revision history' => 'Historique de révision',
	'Enable revision history' => 'Activer l\'historique de révision',
	'Number of revisions per entry/page' => 'Nombre de révisions par notes/pages',
	'Number of revisions per page' => 'Nombre de révisions par pages',
	'Number of revisions per template' => 'Nombres de révisions par gabarit',
	'You did not select a time zone.' => 'Vous n\'avez pas sélectionné de fuseau horaire.',
	'You must set a valid Archive URL.' => 'Vous devez renseigner une Archive URL valide.',
	'You must set Local Archive Path.' => 'Vous devez renseigner Local Archive Path.',
	'You must set a valid Local Archive Path.' => 'Vous devez renseigner un Local Archive Path valide.',

## tmpl/cms/preview_template_strip.tmpl
	'You are previewing the template named &ldquo;[_1]&rdquo;' => 'Vous prévisualisez le module nommé &ldquo;[_1]&rdquo;',
	'(Publish time: [_1] seconds)' => 'Temps de publication : [_1] secondes',
	'Return to the template editor (e)' => 'Retourner à l\'editeur de gabarits (e)',
	'Return to the template editor' => 'Retourner à l\'éditeur de gabarits',

## tmpl/cms/list_comment.tmpl
	'Manage Comments' => 'Gérer les commentaires',
	'The selected comment(s) has been approved.' => 'Les commentaires suivants ont été approuvés.',
	'All comments reported as spam have been removed.' => 'Tous les commentaires notifiés comme spam ont été supprimés.',
	'The selected comment(s) has been unapproved.' => 'Les commentaires sélectionnés ont été approuvés.',
	'The selected comment(s) has been reported as spam.' => 'Les commentaires sélectionnés ont été notifiés comme spam.',
	'The selected comment(s) has been recovered from spam.' => 'Les commentaires suivants ont été récupérés du spam.',
	'The selected comment(s) has been deleted from the database.' => 'Les commentaires sélectionnés ont été supprimés de la base de données.',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be Banned or Trusted.' => 'Un ou plusieurs commentaires sélectionnés ont été écrits par un auteur de commentaires non authentifié. Ces auteurs de commentaires ne peuvent pas être bannis ou validés.',
	'No comments appeared to be spam.' => 'Aucun commentaire ne semble être du spam.',
	'[_1] on entries created within the last [_2] days' => '[_1] sur les notes créées dans les [_2] derniers jours',
	'[_1] on entries created more than [_2] days ago' => '[_1] sur les notes créées il y a plus de [_2] jours',

## tmpl/cms/edit_ping.tmpl
	'Edit Trackback' => 'Éditer les trackbacks',
	'The TrackBack has been approved.' => 'Le trackback a été approuvé.',
	'Save changes to this TrackBack (s)' => 'Enregistrer les modifications de ce Trackback (s)',
	'Delete this TrackBack (x)' => 'Supprimer ce Trackback (x)',
	'Update the status of this TrackBack' => 'Modifier le statut de ce trackback',
	'Approved' => 'Approuvé',
	'Unapproved' => 'Non-approuvé',
	'Reported as Spam' => 'Notifié comme spam',
	'Junk' => 'Indésirable',
	'View all TrackBacks with this status' => 'Voir tous les trackbacks avec ce statut',
	'Total Feedback Rating: [_1]' => 'Note globale de Feedback: [_1]',
	'Source Site' => 'Site source',
	'Search for other TrackBacks from this site' => 'Rechercher d\'autres trackbacks de ce site',
	'Source Title' => 'Titre de la source',
	'Search for other TrackBacks with this title' => 'Rechercher d\'autres trackbacks avec ce titre',
	'Search for other TrackBacks with this status' => 'Rechercher d\'autres trackbacks avec ce statut',
	'Target Entry' => 'Note cible',
	'Entry no longer exists' => 'Cette note n\'existe plus',
	'No title' => 'Sans titre',
	'View all TrackBacks on this entry' => 'Voir tous les trackbacks pour cette note',
	'Target Category' => 'Catégorie cible',
	'Category no longer exists' => 'La catégorie n\'existe plus',
	'View all TrackBacks on this category' => 'Afficher tous les trackbacks des cette catégorie',
	'View all TrackBacks created on this day' => 'Voir tous les trackbacks créés ce jour',
	'View all TrackBacks from this IP address' => 'Afficher tous les trackbacks avec cette adresse IP',
	'TrackBack Text' => 'Texte du trackback',
	'Excerpt of the TrackBack entry' => 'Extrait de la note du trackback',

## tmpl/cms/cfg_web_services.tmpl
	'Web Services Settings' => 'Paramètres des services web',
	'Web Services from Six Apart' => 'Services web de Six Apart',
	'Your TypePad token is used to access services from Six Apart like TypePad Connect and TypePad AntiSpam.' => 'Votre jeton TypePad est utilisé pour accéder aux services Six Apart comme TypePad Connect ou TypePad AntiSpam.',
	'TypePad is enabled.' => 'TypePad est activé.',
	'TypePad token:' => 'Jeton TypePad :',
	'Clear TypePad Token' => 'Effacer le jeton TypePad',
	'Please click the Save Changes button below to disable authentication.' => 'Cliquez sur le bouton Enregistrer ci-dessous pour DESACTIVER l\'authentification.',
	'TypePad is not enabled.' => 'TypePad est désactivé.',
	'&nbsp;or&nbsp;[_1]obtain a TypePad token[_2] from TypePad.com.' => '&nbsp;or&nbsp;[_1]obtenier un jeton TypePad[_2] depuis TypePad.com.',
	'Please click the \'Save Changes\' button below to enable TypePad.' => 'Veuillez cliquer sur Enregistrer les modifications ci-dessous pour activer TypePad',
	'External Notifications' => 'Notifications externes',
	'Notify ping services of website updates' => 'Notifier les services de ping des mises à jour du site web.',
	'When this website is updated, Movable Type will automatically notify the selected sites.' => 'Lorsque ce site web est mis à jour, Movable Type va automatiquement notifier les sites sélectionnés.',
	'Note: This option is currently ignored because outbound notification pings are disabled system-wide.' => 'Note : Cette option est actuellement ignorée parce que les notifications sortantes sont désactivés au niveau du système.',
	'Others:' => 'Autres :',
	'(Separate URLs with a carriage return.)' => '(Séparer les URLs avec un retour chariot.)',
	'Recently Updated Key' => 'Clé récemment mise à jour',
	'If you received a Recently Updated Key with the purchase of a Movable Type license, enter it here.' => 'Si vous avez reçu une clé de mise à jour récente avec l\'achat d\'une licence Movable Type, entrez-là ici.',

## tmpl/cms/list_template.tmpl
	'Manage [_1] Templates' => 'Gérer les gabarits [_1]',
	'Show All Templates' => 'Afficher tous les gabarits',
	'Publishing Settings' => 'Paramètres de publication',
	'You have successfully deleted the checked template(s).' => 'Les gabarits sélectionnés ont été supprimés.',
	'Your templates have been published.' => 'Vos gabarits ont bien été publiés.',
	'Selected template(s) has been copied.' => 'Le(s) gabarit(s) sélectionné(s) a (ont) été copié(s).',

## tmpl/cms/list_tag.tmpl
	'Your tag changes and additions have been made.' => 'Votre changement de tag et les compléments ont été faits.',
	'You have successfully deleted the selected tags.' => 'Vous avez effacé correctement les tags sélectionnés.',
	'tag' => 'tag',
	'tags' => 'tags',
	'Specify new name of the tag.' => 'Spécifier le nouveau nom du tag',
	'Tag Name' => 'Nom du tag',
	'Click to edit tag name' => 'Cliquez pour modifier le nom du tag',
	'Rename [_1]' => 'Renommer',
	'Rename' => 'Changer le nom',
	'Show all [_1] with this tag' => 'Montrer toutes les [_1] avec ce tag',
	'[quant,_1,_2,_3]' => '[quant,_1,_2,_3]',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all blogs?' => 'Le tag \'[_2]\' existe déjà. Êtes-vous sûr de vouloir fusionner \'[_1]\' et \'[_2]\' sur tous les blogs ?',
	'An error occurred while testing for the new tag name.' => 'Une erreur est survenue en testant la nouvelle balise.',

## tmpl/cms/install.tmpl
	'Create Your Account' => 'Créez votre compte',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'La version Perl installée sur votre serveur ([_1]) es antérieure à la version minimale nécessaire ([_2]).',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Même si Movable Type semble fonctionner normalement, l\'application s\'exécute <strong>dans un environnement non testé et non supporté</strong>.  Nous vous recommandons fortement d\'installer une version de Perl supérieure ou égale à [_1].',
	'Do you want to proceed with the installation anyway?' => 'Souhaitez-vous tout de même poursuivre l\'installation ?',
	'View MT-Check (x)' => 'Voir MT-Check (x)',
	'Please create an administrator account for your system. When you are done, Movable Type will initialize your database.' => 'Veuillez crér un compte administrateur pour votre système. Lorsque cela sera fait, Movable Type va initialiser votre base de données.',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Pour poursuivre, vous devez vous authentifier correctement auprès de votre serveur LDAP.',
	'The name used by this user to login.' => 'Le nom utilisé par cet utilisateur pour s\'enregistrer.',
	'The name used when published.' => 'Le nom utilisé lors de la publication.',
	'The user&rsquo;s email address.' => 'Adresse email de l\'utilisateur',
	'The email address used in the From: header of each email sent from the system.' => 'L\'adresse e-mail utilisée dans l\'en-tête Expéditeur de chaque e-mail envoyé',
	'Use this as system email address' => 'Utiliser ceci comme adresse e-mail du système',
	'The user&rsquo;s preferred language.' => 'Langue préférée de l\'utilisateur.',
	'Select a password for your account.' => 'Sélectionnez un Mot de Passe pour votre compte.',
	'Confirm Password' => 'Mot de passe (confirmation) *',
	'Repeat the password for confirmation.' => 'Répétez votre mot de passe pour confirmer.',
	'Your LDAP username.' => 'Votre nom d\'utilisateur LDAP.',
	'Enter your LDAP password.' => 'Saisissez votre mot de passe LDAP.',
	'The initial account name is required.' => 'Le nom initial du compte est nécessaire.',
	'The display name is required.' => 'Le nom d\'affichage est requis.',
	'The e-mail address is required.' => 'L\'adresse email est requise.',
	'Password recovery word/phrase is required.' => 'La phrase de récupération de mot de passe est requise.',

## tmpl/cms/edit_author.tmpl
	'Edit Profile' => 'Editer le Profil',
	'This profile has been updated.' => 'Ce profil a été mis à jour.',
	'A new password has been generated and sent to the email address [_1].' => 'Un nouveau mot de passe a été créé et envoyé à l\'adresse [_1].',
	'Your web services password is currently' => 'Votre mot de passe est actuellement',
	'_WARNING_PASSWORD_RESET_SINGLE' => '_WARNING_PASSWORD_RESET_SINGLE',
	'Error occurred while removing userpic.' => 'Une erreur est survenue lors du retrait de l\'avatar.',
	'Status of user in the system. Disabling a user prevents that person from using the system but preserves their content and history.' => 'Statut d\'un utilisateur dans le système. Désactiver un utilisateur évite que cette personne utilise le système mais garde son contenu et ses historiques.',
	'_USER_PENDING' => 'Utilisateur en attente',
	'The username used to login.' => 'L\'identifiant utilisé pour s\'identifier.',
	'External user ID' => 'ID utilisateur externe',
	'The name displayed when content from this user is published.' => 'Le nom affiché lorsque le contenu de cet utilisateur est publié.',
	'The email address associated with this user.' => 'L\'adresse email associée avec cet utilisateur.',
	'This User\'s website (e.g. http://www.movabletype.com/).  If the Website URL and Display Name fields are both populated, Movable Type will by default publish entries and comments with bylines linked to this URL.' => 'Le site web de cet utilisateur. Si le site web et le nom affiché sont tous les deux remplis, Movable Type publiera par défaut les notes et commentaires avec un lien vers cette URL.',
	'Userpic' => 'Image de l\'utilisateur',
	'The image associated with this user.' => 'L\'image associée à cet utilisateur.',
	'Select Userpic' => 'Sélectionner l\'image de l\'utilisateur',
	'Remove Userpic' => 'Supprimer l\'image de l\'utilisateur',
	'Current Password' => 'Mot de passe actuel',
	'Existing password required to create a new password.' => 'Mot de passe actuel nécessaire pour créer un nouveau mot de passe.',
	'Initial Password' => 'Mot de passe *',
	'Enter preferred password.' => 'Saisissez le mot de passe préféré.',
	'Enter the new password.' => 'Saisissez le nouveau mot de passe.',
	'Password recovery word/phrase' => 'Indice de récupération du mot de passe',
	'This word or phrase is not used in the password recovery.' => 'Ce mot ou cette phrase n\'est pas utilisé dans la récupération du mot de passe.',
	'Preferences' => 'Préférences',
	'Display language for the Movable Type interface.' => 'Langue d\'affichage pour l\'interface Movable Type.',
	'Text Format' => 'Format du texte',
	'Default text formatting filter when creating new entries and new pages.' => 'Filtres de mise en forme par défaut lors de la création d\'une nouvelle note ou page',
	'(Use Website/Blog Default)' => '(Utiliser les paramètres du site web/blog)',
	'Tag Delimiter' => 'Délimiteur de tags',
	'Preferred method of separating tags.' => 'Méthode préférée pour séparer les tags.',
	'Web Services Password' => 'Mot de passe Services Web',
	'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'Pour utilisation par les flux d\'activité et avec les clients XML-RPC ou ATOM.',
	'Reveal' => 'Révéler',
	'System Permissions' => 'Autorisations système',
	'Create personal blog for user' => 'Créer le blog personnel de l\'utilisateur',
	'Create User (s)' => 'Créer l\'Utilisateur (s)',
	'Save changes to this author (s)' => 'Enregistrer les modifications de cet auteur (s)',
	'_USAGE_PASSWORD_RESET' => 'Ci-dessous, vous pouvez ré-initialiser le mot de passe pour cet utilisateur. Si vous faites cela un mot de passe généré aléatoirement sera créé et envoyé par e-mail à : [_1].',
	'Initiate Password Recovery' => 'Récupérer le mot de passe',

## tmpl/cms/edit_comment.tmpl
	'The comment has been approved.' => 'Ce commentaire a été approuvé.',
	'Save changes to this comment (s)' => 'Enregistrer les modifications de ce commentaire (s)',
	'Delete this comment (x)' => 'Supprimer ce commentaire (x)',
	'View entry comment was left on' => 'Voir la note sur laquelle ce commentaire a été déposé',
	'Reply to this comment' => 'Répondre à ce commentaire',
	'Update the status of this comment' => 'Mettre à jour le statut de ce commentaire',
	'View all comments with this status' => 'Voir tous les commentaires avec ce statut',
	'The name of the person who posted the comment' => 'Le nom de la personne qui a posté le commentaire',
	'View this commenter detail' => 'Voir les détails de l\'auteur de commentaires',
	'(Trusted)' => '(Fiable)',
	'Untrust Commenter' => 'Considérer l\'auteur de commentaires comme pas sûr',
	'Ban Commenter' => 'Bannir l\'auteur de commentaires',
	'(Banned)' => '(Banni)',
	'Trust Commenter' => 'Considérer l\'auteur de commentaires comme sûr',
	'Unban Commenter' => 'Lever le bannissement de l\'auteur de commentaires',
	'(Pending)' => '(En attente)',
	'View all comments by this commenter' => 'Afficher tous les commentaires de cet auteur de commentaires',
	'Email address of commenter' => 'Adresse email de l\'auteur de commentaires',
	'Unavailable for OpenID user' => 'Non disponible pour les utilisateurs OpenID',
	'URL of commenter' => 'URL de l\'auteur de commentaires',
	'No url in profile' => 'Pas d\'URL dans le profil',
	'View all comments with this URL' => 'Afficher tous les commentaires associés à cette URL',
	'[_1] this comment was made on' => '[_1] ce commentaire a été posté',
	'[_1] no longer exists' => '[_1] n\'existe plus',
	'View all comments on this [_1]' => 'Voir tous les commentaires sur cette [_1]',
	'Date this comment was made' => 'Date du commentaire',
	'View all comments created on this day' => 'Voir tous les commentaires créés ce jour',
	'IP Address of the commenter' => 'Adresse IP de l\'auteur de commentaires',
	'View all comments from this IP address' => 'Afficher tous les commentaires associés à cette adresse IP',
	'Fulltext of the comment entry' => 'Texte complet de ce commentaire',
	'Responses to this comment' => 'Réponses à ce commentaire',

## tmpl/cms/restore_end.tmpl
	'Make sure that you remove the files that you restored from the \'import\' folder, so that if/when you run the restore process again, those files will not be re-restored.' => 'Assurez-vous d\'avoir supprimé les fichiers que vous avez restaurés dans le répertoire \'import\', ainsi, si vous restaurez à nouveau d\'autres fichiers plus tard, les fichiers actuels ne seront pas restaurés une seconde fois.',
	'An error occurred during the restore process: [_1] Please check activity log for more details.' => 'Une erreur s\'est produite pendant la procédure de restauration : [_1] Merci de vous reporter au journal (logs) pour plus de détails.',

## tmpl/cms/list_asset.tmpl
	'You have successfully deleted the asset(s).' => 'Vous avez effacé les contenus.',
	'New Asset' => 'Nouvel élément',
	'Show only assets where' => 'Afficher seulement les éléments où',
	'type' => 'Type',

## tmpl/cms/asset_replace.tmpl
	'Upload New Asset' => 'Télécharger un nouvel élément',

## tmpl/cms/import.tmpl
	'Import Blog Entries' => 'Importer les notes du blog',
	'You must select a blog to import.' => 'Vous devez sélectionner un blog à importer.',
	'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Transférer les notes dans Movable Type depuis une autre installation Movable Type ou à partir d\'un autre outil de publication de blogs afin de créer une sauvegarde ou une copie.',
	'Import data into' => 'Importer les données dans',
	'Select a blog to import.' => 'Sélectionner un blog à importer.',
	'Importing from' => 'Importation à partir de',
	'Ownership of imported entries' => 'Propriétaire des notes importées',
	'Import as me' => 'Importer en me considérant comme auteur',
	'Preserve original user' => 'Préserver l\'utilisateur initial',
	'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => 'Si vous choisissez de garder l\'auteur original de chaque note importée, ils doivent être créés dans votre installation et vous devez définir un mot de passe par défaut pour ces nouveaux comptes.',
	'Default password for new users:' => 'Mot de passe par défaut pour un nouvel utilisateur:',
	'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'Vous serez désigné comme auteur/utilisateur pour toutes les notes importées. Si vous voulez que l\'auteur initial en conserve la propriété, vous devez contacter votre administrateur MT pour qu\'il fasse l\'importation et le cas échéant qu\'il crée un nouvel utilisateur.',
	'Upload import file (optional)' => 'Envoyer le fichier d\'import (optionnel)',
	'If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the \'import\' folder of your Movable Type directory.' => 'Si votre fichier d\'import est situé sur votre ordinateur, vous pouvez l\'envoyer ici.  Sinon, Movable Type va automatiquement chercher dans le répertoire \'import\' de votre répertoire Movable Type.',
	'Import File Encoding' => 'Encodage du fichier d\'import',
	'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'Par défaut, Movable Type va essayer de détecter automatiquement l\'encodage des caractères de vos fichiers importés.  Cependant, si vous rencontrez des difficultés, vous pouvez le paramétrer de manière explicite',
	'<mt:var name="display_name" escape="html">' => '<mt:var name="display_name" escape="html">',
	'Default category for entries (optional)' => 'Catégorie par défaut pour les notes (optionnel)',
	'You can specify a default category for imported entries which have none assigned.' => 'Vous pouvez spécifier une catégorie par défaut pour les notes importées qui n\'ont pas été assignées.',
	'Select a category' => 'Sélectionnez une catégorie',
	'Import Entries (s)' => 'Importer les notes (s)',

## tmpl/cms/list_widget.tmpl
	'Manage [_1] Widgets' => 'Gérer les widgets [_1]',
	'Delete selected Widget Sets (x)' => 'Effacer les groupes de widgets sélectionnés (x)',
	'Helpful Tips' => 'Astuces',
	'To add a widget set to your templates, use the following syntax:' => 'Pour ajouter un groupe de widgets à vos gabarits, utilisez la syntaxe suivante :',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Nom du groupe de widgets&quot;$&gt;</strong>',
	'Your changes to the widget set have been saved.' => 'Les modifications apportées au widget ont été enregistrées.',
	'You have successfully deleted the selected widget set(s) from your blog.' => 'Vous avez supprimé de votre blog les groupes de widgets sélectionnés.',
	'No Widget Sets could be found.' => 'Aucun groupe de widgets n\'a été trouvé',
	'Create widget template' => 'Créer un gabarit de widget',

## tmpl/cms/upgrade_runner.tmpl
	'Initializing database...' => 'Initialisation de la base de données...',
	'Upgrading database...' => 'Mise à jour de la base de données...',
	'Error during installation:' => 'Erreur lors de l\'installation :',
	'Error during upgrade:' => 'Erreur lors de la mise à jour :',
	'Return to Movable Type (s)' => 'Retour vers Movable Type',
	'Return to Movable Type' => 'Retourner à Movable Type',
	'Your database is already current.' => 'Votre base de données est déjà actualisée.',
	'Installation complete!' => 'Installation terminée !',
	'Upgrade complete!' => 'Mise à jour terminée !',

## tmpl/cms/system_check.tmpl
	'User Counts' => 'Statistiques utilisateurs',
	'Number of users registered in this system.' => 'Nombre d\'utilisateurs enregistrés sur ce système',
	'Total Users' => 'Utilisateurs au total',
	'Active Users' => 'Utilisateurs actifs',
	'Users who have logged in within the past 90 days are considered <strong>active</strong>.' => 'Utilisateurs s\'étant identifiés dans les 90 derniers jours sont considérés comme étant <strong>actifs</strong>.',
	'Memcache Status' => 'Statut Memcache',
	'Memcache is [_1].' => 'Memcache est [_1].', # Translate - New
	'Memcache Server is [_1].' => 'Le serveur Memcache est [_1].', # Translate - New
	'Server Model' => 'Modèle du serveur',
	'Movable Type could not find the script named \'mt-check.cgi\'. To resolve this issue, ensure that the mt-check.cgi script exists and that the CheckScript configuration parameter (if it is necessary) references it properly.' => 'Movable Type ne trouve pas le script nommé \'mt-check.cgi\'. Pour résoudre ce problème, vérifiez que le script mt-check.cgi existe et que le paramètre de configuration CheckScript (s\'il est nécessaire) le référence correctement.',

## tmpl/cms/restore.tmpl
	'Restore from a Backup' => 'Restaurer à partir d\'une sauvegarde',
	'Perl module XML::SAX and/or some of its dependencies are missing.  Movable Type cannot restore the system without these modules.' => 'Le module Perl XML::SAX et/ou ses dépendances sont introuvables. Movable Type ne peut pas restaurer le système sans ces modules.',
	'Backup File' => 'Fichier de sauvegarde',
	'If your backup file is located on a remote computer, you can upload it here.  Otherwise, Movable Type will automatically look in the \'import\' folder within your Movable Type directory.' => 'Si votre fichier de sauvegarde est localisé sur un ordinateur distant, vous pouvez le télécharger ici. Sinon, Movable Type regardera automatiquement dans le dossier \'import\' dans votre répertoire Movable Type.',
	'Check this and files backed up from newer versions can be restored to this system.  NOTE: Ignoring Schema Version can damage Movable Type permanently.' => 'Cochez ceci et les fichiers sauvegardés à partir d\'une version plus récente pourront être restaurés dans ce système. NOTE : Ignorer la version du schéma peut endommager Movable Type de manière permanente.',
	'Ignore schema version conflicts' => 'Ignorer les conflits de version de schéma',
	'Allow existing global templates to be overwritten by global templates in the backup file.' => 'Permettre aux gabarits globaux existants d\'être réécrits par les gabarits dans le fichier de sauvegarde.',
	'Overwrite global templates.' => 'Ecraser les gabarits globaux.',
	'Restore (r)' => 'Restaurer (r)',

## tmpl/cms/rebuilding.tmpl
	'Publishing...' => 'Publication...',
	'Publishing [_1]...' => 'Publication [_1]...',
	'Publishing [_1] [_2]...' => 'Publication [_1] [_2]...',
	'Publishing [_1] dynamic links...' => 'Publication des liens dynamiques [_1]...',
	'Publishing [_1] archives...' => 'Publication des archives [_1]...',
	'Publishing [_1] templates...' => 'Publication des gabarits [_1]...',
	'[_1]% Complete' => '[_1]% terminé(s)',

## tmpl/cms/edit_asset.tmpl
	'Edit Asset' => 'Éditer les Éléments',
	'Your asset changes have been made.' => 'Vos modifications de l\'élément ont bien été apportées.',
	'Stats' => 'Stats',
	'[_1] - Modified by [_2]' => '[_1] - modifié par [_2]',
	'Appears in...' => 'Apparaît dans...',
	'Show all entries' => 'Afficher toutes les notes',
	'Show all pages' => 'Afficher toutes les pages',
	'This asset has not been used.' => 'Cet élément n\'est pas utilisé.',
	'Related Assets' => 'Éléments liés',
	'You must specify a label for the asset.' => 'Vous devez spécifier un titre pour l\'élément.',
	'Embed Asset' => 'Élément embarqué',
	'View this asset.' => 'Voir cet élément.',
	'Save changes to this asset (s)' => 'Enregistrer les modifications de cet élément (s)',

## tmpl/cms/upgrade.tmpl
	'Time to Upgrade!' => 'Il est temps de mettre à jour !',
	'Upgrade Check' => 'Vérification des mises à jour',
	'Do you want to proceed with the upgrade anyway?' => 'Voulez-vous quand même continuer la mise a jour ?',
	'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Une nouvelle version de Movable Type a été installée. Nous avons besoin de faire quelques manipulations complémentaires pour mettre à jour votre base de données.',
	'The Movable Type Upgrade Guide can be found <a href=\'[_1]\' target=\'_blank\'>here</a>.' => 'Le guide de mise à jour Movable Type peut être trouvé <a href=\'[_1]\' target=\'_blank\'>ici</a>.',
	'In addition, the following Movable Type components require upgrading or installation:' => 'De plus, les composants suivants de Movable Type nécessitent une mise à jour ou une installation :',
	'The following Movable Type components require upgrading or installation:' => 'Les composants suivants de Movable Type nécessitent une mise à jour ou une installation :',
	'Begin Upgrade' => 'Commencer la mise à jour',
	'Congratulations, you have successfully upgraded to Movable Type [_1].' => 'Félicitations, vous avez mis à jour Movable Type à la version [_1].',
	'Your Movable Type installation is already up to date.' => 'Vous disposez de la dernière version de Movable Type.',

## tmpl/cms/edit_blog.tmpl
	'Blog Theme' => 'Thème du blog',
	'Select the theme you wish to use for this blog.' => 'Sélectionnez le thème que vous voudriez utiliser pour ce blog.',
	'Name your blog. The blog name can be changed at any time.' => 'Nommez votre blog. Le nom du blog peut être changé à n\'importe quel moment.',
	'Create Blog (s)' => 'Créer le Blog (s)',

## tmpl/cms/pinging.tmpl
	'Trackback' => 'Trackback',
	'Pinging sites...' => 'Envoi de ping(s)...',

## tmpl/cms/asset_upload.tmpl
	'Upload Asset' => 'Envoyer Élément',

## tmpl/cms/setup_initial_website.tmpl
	'Create Your First Website' => 'Créez vore premier site web',
	'In order to properly publish your website, you must provide Movable Type with your website\'s URL and the filesystem path where its files should be published.' => 'Afin de publier correctement votre site web, vous devez fournir à Movable Type l\'URL de votre site web ainsi que le chemin d\'accès où le site devra être publié.',
	'My First Website' => 'Mon premier site web',
	'The \'Publishing Path\' is the directory in your web server\'s filesystem where Movable Type will publish the files for your website. The web server must have write access to this directory.' => 'Le \'Chemin de publication\' est le répertoire dans lequel Movable Type publiera les fichiers de votre site web. LE serveur web doit avoir les autorisations d\'écriture et d\'accès à ce répertoire.',
	'Theme' => 'Thème',
	'Select the theme you wish to use for this new website.' => 'Sélectionnez le thème que vous voulez utiliser pour ce nouveau site web.',
	'Finish install (s)' => 'Terminer l\'installation',
	'Finish install' => 'Finir l\'installation',
	'Back (x)' => 'Retour',
	'The website name is required.' => 'Le nom du site web est requis.',
	'The website URL is required.' => 'L\'URL du site web est requise.',
	'The publishing path is required.' => 'Le chemin de publication est nécessaire.',
	'The timezone is required.' => 'Le fuseau horaire est nécessaire.',

## tmpl/cms/restore_start.tmpl
	'Restoring Movable Type' => 'Restauration de Movable Type',

## tmpl/cms/preview_entry.tmpl
	'Preview [_1]' => 'Pré-visualiser [_1]',
	'Re-Edit this [_1]' => 'Modifier à nouveau cette [_1]',
	'Re-Edit this [_1] (e)' => 'Modifier à nouveau cette [_1] (e)',
	'Save this [_1] (s)' => 'Enregistrer cette [_1] (s)',
	'Cancel (c)' => 'Annuler (c)',

## tmpl/cms/cfg_feedback.tmpl
	'Feedback Settings' => 'Paramètres des Feedbacks',
	'Spam Settings' => 'Paramètres du spam',
	'Automatic Deletion' => 'Supression automatique',
	'Automatically delete spam feedback after the time period shown below.' => 'Supprime automatiquement le spam après la période décrite ci-dessous.',
	'Delete Spam After' => 'Effacer le spam après',
	'When an item has been reported as spam for this many days, it is automatically deleted.' => 'Quand un élément a été notifié comme spam depuis tant de jours, il est automatiquement effacé.',
	'Spam Score Threshold' => 'Niveau de filtrage du spam',
	'Comments and TrackBacks receive a spam score between -10 (complete spam) and +10 (not spam). Feedback with a score which is lower than the threshold shown above will be reported as spam.' => 'Les commentaires et les trackbacks reçoivent un score de spam entre -10 (spam assuré) et +10 (non spam). Un commentaire avec un score qui est plus faible que le seuil ci-dessus sera notifié comme spam.',
	'Less Aggressive' => 'Moins agressif',
	'Decrease' => 'Baisser',
	'Increase' => 'Augmenter',
	'More Aggressive' => 'Plus agressif',
	'Include \'nofollow\' in URLs' => 'Inclure \'nofollow\' dans les URLs',
	'Include the \'nofollow\' attribute in URLs submitted in feedback.' => 'Inclut l\'attribut \'nofollow\' dans les URLs envoyés dans les commentaires ou trackback.',
	'\'nofollow\' exception for trusted commenters' => 'Ne pas utiliser \'unfollow\' pour les auteurs de commentaires de confiance',
	'Do not add the \'nofollow\' attribute when a comment is submitted by a trusted commenter.' => 'Ne pas ajouter l\'attribut \'unfollow\' lorsqu\'un commentaire est envoyé par un auteur de commentaires de confiance.',
	'Comment Settings' => 'Paramètres des commentaires',
	'Note: Commenting is currently disabled at the system level.' => 'Note : Les commentaires sont actuellement désactivés au niveau système.',
	'Comment authentication is not available because at least one of the required Perl modules, MIME::Base64 and LWP::UserAgent, are not installed. Install the missing modules and reload this page to configure comment authentication.' => 'L\'identification pour les commentaires n\'est pas disponible parce qu\'au moins un module Perl requis, MIME::Base64 et LWP::UserAgent, n\'est pas installé. Installez les modules manquant et rechargez cette page pour configurer l\'identification pour les commentaires.',
	'Accept comments according to the policies shown below.' => 'Accepter les commentaires selon les politiques choisies ci-dessous.',
	'Setup Registration' => 'Configuration de l\'enregistrement',
	'Commenting Policy' => 'Règles pour les commentaires',
	'Immediately approve comments from' => 'Approuver immédiatement les commentaires de',
	'Specify what should happen to comments after submission. Unapproved comments are held for moderation.' => 'Spécifiez ce qui doit se passer après la soumission de commentaires. Les commentaires non-approuvés sont retenus pour modération.',
	'No one' => 'Personne',
	'Trusted commenters only' => 'Auteurs de commentaires fiables uniquement',
	'Any authenticated commenters' => 'Tout auteur de commentaire authentifié',
	'Anyone' => 'Tout le monde',
	'Allow HTML' => 'Autoriser le HTML',
	'Allow commenters to include a limited set of HTML tags in their comments. Otherwise all HTML will be stripped out.' => 'Permettre aux autenrs de commentaires d\'inclure une série limitée de balises HTML dans leurs commentaires. Sinon, tous les tags HTML seront supprimés.',
	'Limit HTML Tags' => 'Limiter les balises HTML',
	'Specify the list of HTML tags to allow when accepting a comment.' => 'Indiquez la liste des balises HTML autorisées lorsqu\'ils sont acceptés dans les commentaires.',
	'Use defaults' => 'Utiliser les valeurs par défaut',
	'([_1])' => '([_1])',
	'Use my settings' => 'Utiliser mes paramètres',
	'E-mail Notification' => 'Notification par email',
	'Specify when Movable Type should notify you of new comments.' => 'Indiquez lorsque Movable Type devrait vous notifier des nouveaux commentaires.',
	'On' => 'Activée',
	'Only when attention is required' => 'Uniquement quand l\'attention est requise',
	'Off' => 'Désactivée',
	'Comment Display Settings' => 'Paramètres d\'affichage des commentaires', # Translate - New
	'Comment Order' => 'Ordre des commentaires',
	'Select whether you want comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Sélectionnez si vous souhaitez afficher les commentaires selon un ordre chronologique (nouveaux commentaires en bas) ou anté-chronologique (nouveaux commentaires en haut)',
	'Auto-Link URLs' => 'Liaison automatique des URL',
	'Transform URLs in comment text into HTML links.' => 'Transformer les URLs dans les commentaires en liens',
	'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Spécifie les options de mise en forme du texte des commentaires publiés par les visiteurs.',
	'CAPTCHA Provider' => 'Fournisseur de CAPTCHA',
	'none' => 'Aucun fournisseur',
	'No CAPTCHA provider available' => 'Aucun fournisseur de CAPTCHA disponible',
	'No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed and if the CaptchaSourceImageBase configuration directive points to a valid captcha-source directory within the \'mt-static/images\' directory.' => 'Aucun fournisseur de CAPTCHA n\'est disponible pour ce système. Veuillez vérifier sir Image::Magick est installé et si les directives de configuration CaptchaSourceImageBase pointent une source valide de captcha dans le répertoire \'mt-static/images\'.',
	'Use Comment Confirmation Page' => 'Utiliser la page de confirmation de commentaire',
	'Use comment confirmation page' => 'Utiliser la page de confirmation de commentaire',
	'Each commenter\'s browser will be redirected to a comment confirmation page after their comment is accepted.' => 'Rediriger les auteurs de commentaires vers une page de confirmation lorsque leur commentaire est accepté. ',
	'Trackback Settings' => 'Paramètres des trackbacks', # Translate - New
	'Note: TrackBacks are currently disabled at the system level.' => 'Note: Les trackbacks sont actuellement désactivés au niveau système.',
	'Accept TrackBacks from any source.' => 'Accepter les trackbacks de n\'importe quelle source.',
	'TrackBack Policy' => 'Règles pour les trackbacks',
	'Moderation' => 'Modération',
	'Hold all TrackBacks for approval before they are published.' => 'Attendre la validation des trackback avant de les publier',
	'Specify when Movable Type should notify you of new TrackBacks.' => 'Spécifie lorsque Movable Type devrait vous notifier des nouveaux trackbacks.',
	'TrackBack Options' => 'Options de trackback',
	'TrackBack Auto-Discovery' => 'Activer la découverte automatique des trackbacks',
	'When auto-discovery is turned on, any external HTML links in new entries will be extracted and the appropriate sites will automatically be sent a TrackBack ping.' => 'Lorsque la découverte automatique est activée, tout lien HTML externe dans les notes sera extrait et un ping de trackback leur sera envoyé.',
	'Enable External TrackBack Auto-Discovery' => 'Pour les notes extérieures au blog',
	'Setting Notice' => 'Paramètre des informations',
	'Note: This option may be affected since outbound pings are constrained system-wide.' => 'Note : Cette option pourrait être affectée puisque les pings sont restreints au niveau du système.',
	'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Note : Cette option est actuellement ingorée puisque les pings sortant sont désactivés au niveau du système.',
	'Enable Internal TrackBack Auto-Discovery' => 'Pour les notes intérieures au blog',

## tmpl/cms/list_folder.tmpl
	'Your folder changes and additions have been made.' => 'Vos modifications du répertoire ont bien été apportées.',
	'You have successfully deleted the selected folder.' => 'Vous avez supprimé avec succès le répertoire sélectionné',
	'Delete selected folders (x)' => 'Supprimer les répertoires sélectionnés (x)',
	'Create top level folder' => 'Créer un répertoire de premier niveau',
	'Top Level' => 'Niveau racine',
	'New Parent [_1]' => 'Nouveau [_1] parent',
	'Create Folder' => 'Créer un Répertoire',
	'Create' => 'Créer',
	'Create Subfolder' => 'Créer un Sous-répertoire',
	'Move Folder' => 'Déplacer un Répertoire',
	'Move' => 'Déplacer',
	'No folders could be found.' => 'Aucun dossier n\'a pu être trouvé.',

## tmpl/cms/list_association.tmpl
	'permission' => 'Autorisation',
	'permissions' => 'Autorisations',
	'Remove selected permissions (x)' => 'Retirer les autorisations sélectionnées (x)',
	'Revoke Permission' => 'Retirer l\'autorisation',
	'[_1] <em>[_2]</em> is currently disabled.' => '[_1] <em>[_2]</em> est actuellement désactivé.',
	'Grant Website Permission' => 'Ajouter l\'autorisation pour le site web',
	'Grant Blog Permission' => 'Ajouter l\'autorisation pour le blog',
	'You can not create permissions for disabled users.' => 'Vous ne pouvez pas créer d\'autorisations pour les utilisateurs désactivés',
	'Grant Permission' => 'Ajouter une autorisation',
	'Assign Website Role to User' => 'Assigner le role Site web à l\'utilisateur',
	'Assign Blog Role to User' => 'Assigner le role Blog à l\'utilisateur',
	'Grant website permission to a user' => 'Ajouter l\'autorisation pour le site web à l\'utilisateur',
	'Grant blog permission to a user' => 'Ajouter l\'autorisation pour le blog à l\'utilisateur',
	'You have successfully revoked the given permission(s).' => 'Vous avez révoqué avec succès les autorisations sélectionnées.',
	'You have successfully granted the given permission(s).' => 'Vous avez attribué avec succès les autorisations sélectionnées.',
	'No permissions could be found.' => 'Aucune autorisation n\'a pu être trouvée.',

## tmpl/cms/login.tmpl
	'Sign in' => 'Identification',
	'Your Movable Type session has ended.' => 'Votre session Movable Type a été fermée.',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Votre session Movable Type est terminée. Si vous souhaitez vous identifier à nouveau, vous pouvez le faire ci-dessous.',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Votre session Movable Type est terminée. Merci de vous identifier à nouveau pour continuer cette action.',
	'Sign In (s)' => 'Connexion (s)',
	'Forgot your password?' => 'Vous avez oublié votre mot de passe ?',

## tmpl/cms/list_category.tmpl
	'Your category changes and additions have been made.' => 'Vos modifications de la catégorie ont bien été apportées.',
	'You have successfully deleted the selected category.' => 'Vous avez supprimé avec succès la catégorie sélectionnée',
	'categories' => 'Catégories',
	'Delete selected category (x)' => 'Supprimer la catégorie sélectionnée (x)',
	'Create top level category' => 'Créer une catégorie de premier niveau',
	'Create Category' => 'Créer une Catégorie',
	'Collapse' => 'Réduire',
	'Expand' => 'Développer',
	'Create Subcategory' => 'Créer une Sous-catégorie',
	'Move Category' => 'Déplacer une Catégorie',
	'[quant,_1,TrackBack,TrackBacks]' => '[quant,_1,trackback,trackbacks]',
	'No categories could be found.' => 'Aucune catégorie n\'a pu être trouvée.',

## tmpl/comment/auth_livedoor.tmpl

## tmpl/comment/signup.tmpl
	'Create an account' => 'Créer un compte',
	'The name appears on your comment.' => 'Le nom apparaît dans votre commentaire.',
	'Your email address.' => 'Votre adresse email.',
	'Your login name.' => 'Votre nom d\'utilisateur.',
	'Select a password for yourself.' => 'Sélectionnez un mot de passe pour vous.',
	'Password Confirm' => 'Mot de passe (confirmation)',
	'The URL of your website. (Optional)' => 'URL de votre site internet (en option)',
	'Register' => 'S\'enregistrer',

## tmpl/comment/login.tmpl
	'Sign in to comment' => 'Identifiez-vous pour commenter',
	'Sign in using' => 'S\'identifier en utilisant',
	'Remember me?' => 'Mémoriser les informations de connexion ?',
	'Not a member? <a href="[_1]">Sign Up</a>!' => 'Pas encore membre ? <a href="[_1]">Inscrivez-vous</a> !',

## tmpl/comment/auth_wordpress.tmpl
	'Your Wordpress.com Username' => 'Votre pseudonyme WordPress.com',
	'Sign in using your WordPress.com username.' => 'Identifiez-vous en utilisant votre pseudonyme WordPress.com',

## tmpl/comment/auth_yahoojapan.tmpl
	'Turn on OpenID for your Yahoo! Japan account now' => 'Activer OpenID pour votre compte Yahoo! Japon maintenant',

## tmpl/comment/auth_livejournal.tmpl
	'Your LiveJournal Username' => 'Votre identifiant LiveJournal',
	'Learn more about LiveJournal.' => 'En savoir plus sur LiveJournal.',

## tmpl/comment/signup_thanks.tmpl
	'Thanks for signing up' => 'Merci de vous être enregistré(e)',
	'Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].' => 'Avant de pouvoir déposer un commentaire vous devez terminer la prodécure d\'enregistrement en confirmant votre compte.  Un email a été envoyé à l\'adresse suivante : [_1].',
	'To complete the registration process you must first confirm your account. An email has been sent to [_1].' => 'Pour terminer la procédure d\'enregistrement vous devez confirmer votre compte. Un email a été envoyé à [_1].',
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'Pour confirmer et activer votre compte merci de vérifier votre boite email et de cliquer sur le lien que nous venons de vous envoyer.',
	'Return to the original entry.' => 'Retour à la note originale.',
	'Return to the original page.' => 'Retour à la page originale.',

## tmpl/comment/auth_hatena.tmpl
	'Your Hatena ID' => 'Votre identifiant Hatena',

## tmpl/comment/register.tmpl

## tmpl/comment/auth_typepad.tmpl
	'TypePad is a free, open system providing you a central identity for posting comments on weblogs and logging into other websites. You can register for free.' => '
	TypePad est un système gratuit et ouvert vous proposant une identité centralisée pour commenter sur les blogs et vous identifier sur d\'autres sites. Vous pouvez vous enregistrer gratuitement.',

## tmpl/comment/auth_aim.tmpl
	'Your AIM or AOL Screen Name' => 'Votre pseudonyme AIM ou AOL.',
	'Sign in using your AIM or AOL screen name. Your screen name will be displayed publicly.' => 'Identifiez-vous en utilisant votre pseudonyme AIM ou AOL. Votre pseudonyme sera affiché publiquement.',

## tmpl/comment/error.tmpl
	'Go Back (s)' => 'Retour (s)',

## tmpl/comment/auth_googleopenid.tmpl
	'Sign in using your Gmail account' => 'Identifiez-vous en utilisant votre compte Gmail',
	'Sign in to Movable Type with your[_1] Account[_2]' => 'Identifiez-vous dans Movable Type avec votre compte [_1] [_2]',

## tmpl/comment/auth_vox.tmpl
	'Your Vox Blog URL' => 'L\'URL de votre blog Vox',
	'Learn more about Vox.' => 'En savoir plus sur Vox.',

## tmpl/comment/auth_openid.tmpl
	'OpenID URL' => 'URL OpenID',
	'Sign in using your OpenID identity.' => 'Identifiez-vous avec votre identité OpenID.',
	'Sign in with one of your existing third party OpenID accounts.' => 'Identifiez-vous avec l\'une de vos identités OpenID tierce partie.',
	'Learn more about OpenID.' => 'En savoir plus sur OpenID.',

## tmpl/comment/profile.tmpl
	'Your Profile' => 'Votre profil',
	'Return to the <a href="[_1]">original page</a>.' => 'Retourner sur la <a href="[_1]">page originale</a>.',

## tmpl/comment/auth_yahoo.tmpl
	'Turn on OpenID for your Yahoo! account now' => 'Activer OpenID pour votre compte Yahoo! maintenant',

## tmpl/include/chromeless_header.tmpl

## tmpl/feeds/feed_entry.tmpl
	'More like this' => 'Plus du même genre',
	'From this blog' => 'De ce blog',
	'From this author' => 'De cet auteur',
	'On this day' => 'Pendant cette journée',

## tmpl/feeds/feed_comment.tmpl
	'On this entry' => 'Sur cette note',
	'By commenter identity' => 'Par identité de l\'auteur de commentaires',
	'By commenter name' => 'Par nom de l\'auteur de commentaires',
	'By commenter email' => 'Par l\'e-mail de l\'auteur de commentaires',
	'By commenter URL' => 'Par URL de l\'auteur de commentaires',

## tmpl/feeds/login.tmpl
	'Movable Type Activity Log' => 'Journal (logs) de Movable Type',
	'This link is invalid. Please resubscribe to your activity feed.' => 'Ce lien n\'est pas valide. Merci de souscrire à nouveau à votre flux d\'activité.',

## tmpl/feeds/error.tmpl

## tmpl/feeds/feed_page.tmpl

## tmpl/feeds/feed_ping.tmpl
	'Source blog' => 'Blog source',
	'By source blog' => 'Par le blog source',
	'By source title' => 'Par le titre de la source',
	'By source URL' => 'Par l\'URL de la source',

## tmpl/error.tmpl
	'Missing Configuration File' => 'Fichier de configuration manquant',
	'_ERROR_CONFIG_FILE' => 'Votre fichier configuration Movable type est absent ou ne peut pas être lu correctement. Merci de consulter la base de connaissances',
	'Database Connection Error' => 'Erreur de connexion à la base de données',
	'_ERROR_DATABASE_CONNECTION' => 'Les paramètres de votre base de données sont soit invalides, absents ou ne peuvent pas être lus correctement. Consultez la base de connaissances pour plus d\'informations.',
	'CGI Path Configuration Required' => 'Configuration de chemin CGI requise',
	'_ERROR_CGI_PATH' => 'Votre configuration de chemin CGI est invalide ou absente de vos fichiers de configuration Movable Type. Merci de consulter la base de connaissance',

## addons/Community.pack/lib/MT/App/Community.pm
	'No login form template defined' => 'Aucun formulaire d\'identification de défini',
	'Before you can sign in, you must authenticate your email address. <a href="[_1]">Click here</a> to resend the verification email.' => 'Avant de pouvoir vous identifier, vous devez confirmer votre adresse email. <a href="[_1]">Cliquez ici</a> pour envoyer à nouveau l\'email de vérification.',
	'Your confirmation have expired. Please register again.' => 'Votre confirmation a expiré. Merci de vous inscrire à nouveau.',
	'User \'[_1]\' (ID:[_2]) has been successfully registered.' => 'L\'utilisateur \'[_1]\' (ID:[_2]) a été enregistré avec succès.',
	'Thanks for the confirmation.  Please sign in.' => 'Merci pour la confirmation. Identifiez-vous.',
	'[_1] registered to Movable Type.' => '[_1] s\'est enregistré(e) à Movable Type.',
	'Login required' => 'Authentification obligatoire',
	'Title or Content is required.' => 'Le titre ou le contenu est requis.',
	'System template entry_response not found in blog: [_1]' => 'Gabarit système entry_response introuvable dans le blog: [_1]',
	'New entry \'[_1]\' added to the blog \'[_2]\'' => 'Nouvelle note \'[_1]\' ajoutée sur le blog \'[_2]\'',
	'Id or Username is required' => 'Id ou identifiant obligatoire',
	'Unknown user' => 'Utilisateur inconnu',
	'Recent Entries from [_1]' => 'Notes récentes de [_1]',
	'Responses to Comments from [_1]' => 'Réponses aux commentaires de [_1]',
	'Actions from [_1]' => 'Actions de [_1]',

## addons/Community.pack/lib/MT/Community/Tags.pm
	'You used an \'[_1]\' tag outside of the block of MTIfEntryRecommended; perhaps you mistakenly placed it outside of an \'MTIfEntryRecommended\' container?' => 'Vous avez utilisé un tag \'[_1]\' en dehors d\'un bloc de MTIfEntryRecommended; Peut-être l\'avez-vous placé par erreur en dehors d\'un conteneur \'MTIfEntryRecommended\' ?',
	'Click here to recommend' => 'Cliquer ici pour recommander',
	'Click here to follow' => 'Cliquer ici pour suivre',
	'Click here to leave' => 'Cliquer ici pour quitter',

## addons/Community.pack/lib/MT/Community/CMS.pm
	'Community' => 'Communauté',
	'Users followed by [_1]' => 'Utilisateurs suivis par [_1]',
	'Users following [_1]' => 'Utilisateurs qui suivent [_1]',
	'Following' => 'Suit',
	'Followers' => 'Suiveurs',

## addons/Community.pack/php/function.mtentryrecommendvotelink.php

## addons/Community.pack/tmpl/widget/blog_stats_registration.mtml
	'Registrations' => 'Inscriptions',
	'Recent Registrations' => 'Inscriptions récentes',
	'default userpic' => 'Image de l\'utilisateur par défaut',
	'You have [quant,_1,registration,registrations] from [_2]' => 'Vous avez [quant,_1,création de compte,créations de compte] sur [_2]',

## addons/Community.pack/tmpl/widget/most_popular_entries.mtml
	'Most Popular Entries' => 'Notes les plus populaires',
	'There are no popular entries.' => 'Il n\'y a pas de notes populaires.',

## addons/Community.pack/tmpl/widget/recent_submissions.mtml
	'Recent Submissions' => 'Soumissions récentes',

## addons/Community.pack/tmpl/widget/recently_scored.mtml
	'Recently Scored' => 'Noté récemment',
	'There are no recently favorited entries.' => 'Il n\'y a pas de notes favorites récentes.',

## addons/Community.pack/tmpl/cfg_community_prefs.tmpl
	'Community Settings' => 'Réglages de la communauté',
	'Anonymous Recommendation' => 'Recommandation anonyme',
	'Check to allow anonymous users (users not logged in) to recommend discussion.  IP address is recorded and used to identify each user.' => 'Cocher pour autoriser les utilisateurs anonymes (non identifiés) à recommander une discussion. L\'adresse IP est enregistrée et utilisée pour identifier chaque utilisateur.',
	'Allow anonymous user to recommend' => 'Autoriser un utilisateur anonyme à recommander',
	'Save changes to blog (s)' => 'Sauvegarder les modifications du blog (s)',

## addons/Community.pack/templates/global/register_form.mtml
	'Sign up' => 'Enregistrez-vous',
	'Simple Header' => 'Tête de page simple',
	'Simple Footer' => 'Pied de page simple',

## addons/Community.pack/templates/global/profile_error.mtml
	'Profile Error' => 'Erreur de profil',
	'Header' => 'Entête',
	'ERROR MSG HERE' => 'MSG ERREUR ICI',
	'Status Message' => 'Message de statut',
	'Footer' => 'Pied',

## addons/Community.pack/templates/global/new_password.mtml

## addons/Community.pack/templates/global/new_entry_email.mtml
	'A new entry \'[_1]([_2])\' has been posted on your blog [_3].' => 'Une nouvelle note \'[_1]([_2])\' a été postée sur votre blog [_3].',
	'Author name: [_1]' => 'Nom de l\'auteur: [_1]',
	'Author nickname: [_1]' => 'Surnom de l\'auteur: [_1]',
	'Title: [_1]' => 'Titre: [_1]',
	'Edit entry:' => 'Modifier la note:',

## addons/Community.pack/templates/global/profile_feed.mtml
	'Posted [_1] to [_2]' => 'A posté [_1] sur [_2]',
	'Commented on [_1] in [_2]' => 'A commenté sur [_1] dans [_2]',
	'Voted on [_1] in [_2]' => 'A voté sur [_1] dans [_2]',
	'[_1] voted on <a href="[_2]">[_3]</a> in [_4]' => '[_1] a voté sur <a href="[_2]">[_3]</a> dans [_4]',

## addons/Community.pack/templates/global/signin.mtml
	'You are signed in as <a href="[_1]">[_2]</a>' => 'Vous êtes identifié(e) comme étant <a href="[_1]">[_2]</a>',
	'You are signed in as [_1]' => 'Vous êtes identifié(e) comme étant [_1]',
	'Edit profile' => 'Editer le profil',
	'Not a member? <a href="[_1]">Register</a>' => 'Pas encore membre? <a href="[_1]">Enregistrez-vous</a>',

## addons/Community.pack/templates/global/profile_edit_form.mtml
	'Go <a href="[_1]">back to the previous page</a> or <a href="[_2]">view your profile</a>.' => 'Retourner à  <a href="[_1]">la page précédente</a> ou <a href="[_2]">voir votre profil</a>.',
	'Form Field' => 'Champ de formulaire',

## addons/Community.pack/templates/global/header.mtml
	'Blog Description' => 'Description du blog',
	'GlobalJavaScript' => 'GlobalJavaScript',
	'Navigation' => 'Navigation',

## addons/Community.pack/templates/global/profile_view.mtml
	'User Profile' => 'Profil de l\'utilisateur',
	'Recent Actions from [_1]' => 'Actions récentes de [_1]',
	'You are following [_1].' => 'Vous suivez [_1]',
	'Unfollow' => 'Ne plus suivre',
	'Follow' => 'Suivre',
	'You are followed by [_1].' => 'Vous êtes suivi par [_1].',
	'You are not followed by [_1].' => 'Vous n\'êtes pas suivi par [_1].',
	'Website:' => 'Site Web:',
	'Recent Actions' => 'Actions récentes',
	'Comment Threads' => 'Fils de discussion',
	'Commented on [_1]' => 'A commenté sur [_1]',
	'Favorited [_1] on [_2]' => 'A mis comme favori [_1] dans [_2]',
	'No recent actions.' => 'Plus d\'actions récentes.',
	'[_1] commented on ' => '[_1] a commenté sur',
	'No responses to comments.' => 'Pas de réponse aux commentaires.',
	'Not following anyone' => 'Ne suit personne',
	'Not being followed' => 'N\'est pas suivi',

## addons/Community.pack/templates/global/login_form.mtml
	'Not a member?&nbsp;&nbsp;<a href="[_1]">Sign Up</a>!' => 'Pas encore membre?&nbsp;&nbsp;<a href="[_1]">Enregistrez-vous</a>!',

## addons/Community.pack/templates/global/register_confirmation.mtml
	'Authentication Email Sent' => 'Email d\'authentification envoyé',
	'Profile Created' => 'Profil créé',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Retourner à la page initiale</a>',

## addons/Community.pack/templates/global/footer.mtml

## addons/Community.pack/templates/global/navigation.mtml
	'Home' => 'Accueil',

## addons/Community.pack/templates/global/new_password_reset_form.mtml
	'Reset Password' => 'Initialiser le mot de passe',

## addons/Community.pack/templates/global/login_form_module.mtml
	'Logged in as <a href="[_1]">[_2]</a>' => 'Identifié comme <a href="[_1]">[_2]</a>',
	'Logout' => 'Déconnexion',
	'Hello [_1]' => 'Bonjour [_1]',
	'Forgot Password' => 'Mot de passe oublié?',

## addons/Community.pack/templates/global/email_verification_email.mtml
	'Thank you registering for an account to [_1].' => 'Merci de créer un compte sur [_1].',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to sign in to [_1].' => 'Pour votre propre sécurité et pour prévenir la fraude, nous vous demandons de confirmer votre compte et adresse email avant de continuer. Une fois confirmés vous serez immédiatement autorisé à vous identifier sur [_1].',
	'If you did not make this request, or you don\'t want to register for an account to [_1], then no further action is required.' => 'Si vous n\'avez pas fait cette demande, ou que vous ne souhaitez pas créer un compte sur [_1], alors aucune action n\'est nécessaire.',

## addons/Community.pack/templates/global/register_notification_email.mtml

## addons/Community.pack/templates/global/search.mtml

## addons/Community.pack/templates/global/javascript.mtml
	'Vote' => 'Vote',
	'Votes' => 'Votes',

## addons/Community.pack/templates/blog/category_archive_list.mtml

## addons/Community.pack/templates/blog/main_index.mtml
	'Content Navigation' => 'Navigation du contenu',

## addons/Community.pack/templates/blog/page.mtml
	'Page Detail' => 'Détails de la page',

## addons/Community.pack/templates/blog/main_index_widgets_group.mtml

## addons/Community.pack/templates/blog/entry_summary.mtml
	'Entry Metadata' => 'Metadonnées de la note',

## addons/Community.pack/templates/blog/content_nav.mtml
	'Blog Home' => 'Accueil du blog',

## addons/Community.pack/templates/blog/entry_response.mtml
	'Thank you for posting an entry.' => 'Merci d\'avoir posté votre message.',
	'Entry Pending' => 'Message en attente',
	'Your entry has been received and held for approval by the blog owner.' => 'Votre message a été reçu et est en attente d\'approbation par le propriétaire du blog.',
	'Entry Posted' => 'Message posté',
	'Your entry has been posted.' => 'Votre message a bien été posté.',
	'Your entry has been received.' => 'Votre message a été reçu.',
	'Return to the <a href="[_1]">blog\'s main index</a>.' => 'Retour à la <a href="[_1]">page principale du blog</a>.',

## addons/Community.pack/templates/blog/comment_response.mtml

## addons/Community.pack/templates/blog/entry_detail.mtml

## addons/Community.pack/templates/blog/archive_widgets_group.mtml

## addons/Community.pack/templates/blog/entry_form.mtml
	'In order to create an entry on this blog you must first register.' => 'Avant de créer une note sur ce blog, vous devez vous enregistrer.',
	'You don\'t have permission to post.' => 'Vous n\'avez pas la permission de poster.',
	'Sign in to create an entry.' => 'Identifiez-vous pour créer une note.',
	'Select Category...' => 'Sélectionner la catégorie...',

## addons/Community.pack/templates/blog/comment_detail.mtml

## addons/Community.pack/templates/blog/entry_create.mtml
	'Entry Form' => 'Formulaire de note',

## addons/Community.pack/templates/blog/syndication.mtml

## addons/Community.pack/templates/blog/current_category_monthly_archive_list.mtml

## addons/Community.pack/templates/blog/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] a commenté sur [_3]</a> : [_4]',

## addons/Community.pack/templates/blog/comment_form.mtml

## addons/Community.pack/templates/blog/monthly_archive_list.mtml

## addons/Community.pack/templates/blog/pages_list.mtml

## addons/Community.pack/templates/blog/entry_listing.mtml
	'Recently by <em>[_1]</em>' => 'Récemment par <em>[_1]</em>',

## addons/Community.pack/templates/blog/about_this_page.mtml

## addons/Community.pack/templates/blog/tags.mtml

## addons/Community.pack/templates/blog/entry_metadata.mtml

## addons/Community.pack/templates/blog/entry.mtml
	'Entry Detail' => 'Détails de la note',

## addons/Community.pack/templates/blog/javascript.mtml

## addons/Community.pack/templates/blog/archive_index.mtml

## addons/Community.pack/templates/blog/trackbacks.mtml

## addons/Community.pack/templates/blog/recent_entries.mtml

## addons/Community.pack/templates/blog/sidebar.mtml
	'Activity Widgets' => 'Widgets d\'activité',
	'Archive Widgets' => 'Widgets d\'archive',

## addons/Community.pack/templates/blog/openid.mtml

## addons/Community.pack/templates/blog/categories.mtml

## addons/Community.pack/templates/blog/comments.mtml
	'The data in #comments-content will be replaced by some calls to paginate script' => 'Les données dans #comments-content seront remplacées par des appels aux scripts de pagination.',

## addons/Community.pack/templates/blog/search_results.mtml

## addons/Community.pack/templates/blog/comment_listing.mtml

## addons/Community.pack/templates/blog/dynamic_error.mtml

## addons/Community.pack/templates/blog/powered_by.mtml

## addons/Community.pack/templates/blog/tag_cloud.mtml

## addons/Community.pack/templates/blog/recent_assets.mtml

## addons/Community.pack/templates/blog/comment_preview.mtml
	'Comment on [_1]' => 'Commentaire sur [_1]',

## addons/Community.pack/templates/blog/search.mtml

## addons/Community.pack/templates/forum/main_index.mtml
	'Forum Home' => 'Accueil du forum',
	'Content Header' => 'Entête du contenu',
	'Popular Entry' => 'Note populaire',
	'Entry Table' => 'Tableau de note',

## addons/Community.pack/templates/forum/page.mtml

## addons/Community.pack/templates/forum/entry_summary.mtml

## addons/Community.pack/templates/forum/content_nav.mtml
	'Start Topic' => 'Débuter un sujet',

## addons/Community.pack/templates/forum/entry_response.mtml
	'Thank you for posting a new topic to the forums.' => 'Merci d\'avoir créé un nouveau sujet dans le forum.',
	'Topic Pending' => 'Sujet en attente',
	'The topic you posted has been received and held for approval by the forum administrators.' => 'Le sujet que vous avez créé a bien été reçu et il est en attente de validation par les administrateurs du forum.',
	'Topic Posted' => 'Sujet posté',
	'The topic you posted has been received and published. Thank you for your submission.' => 'Le sujet que vous avez créé a bien été reçu et publié. Merci.',
	'Return to the <a href="[_1]">forum\'s homepage</a>.' => 'Retour à la <a href="[_1]">page d\'accueil du forum</a>.',

## addons/Community.pack/templates/forum/comment_response.mtml
	'Reply Submitted' => 'Réponse envoyée',
	'Your reply has been accepted.' => 'Votre réponse a été acceptée.',
	'Thank you for replying.' => 'Merci pour votre réponse.',
	'Your reply has been received and held for approval by the forum administrator.' => 'Votre réponse a bien été reçue et est en attente d\'approbation par un administrateur du forum.',
	'Reply Submission Error' => 'Erreur lors de l\'envoi de la réponse',
	'Your reply submission failed for the following reasons: [_1]' => 'L\'envoi de la réponse a échoué pour les raisons suivantes : [_1]',
	'Return to the <a href="[_1]">original topic</a>.' => 'Retour au <a href="[_1]">sujet d\'origine</a>.',

## addons/Community.pack/templates/forum/content_header.mtml

## addons/Community.pack/templates/forum/entry_detail.mtml

## addons/Community.pack/templates/forum/comment_detail.mtml
	'[_1] replied to <a href="[_2]">[_3]</a>' => '[_1] a répondu à <a href="[_2]">[_3]</a>',

## addons/Community.pack/templates/forum/entry_create.mtml
	'Start a Topic' => 'Créer un nouveau sujet',

## addons/Community.pack/templates/forum/entry_form.mtml
	'Topic' => 'Sujet',
	'Select Forum...' => 'Sélectionner un forum...',
	'Forum' => 'Forum',

## addons/Community.pack/templates/forum/syndication.mtml
	'All Forums' => 'Tous les forums',
	'[_1] Forum' => 'Forum [_1]',

## addons/Community.pack/templates/forum/comment_form.mtml
	'Add a Reply' => 'Ajouter une Réponse',

## addons/Community.pack/templates/forum/entry_listing.mtml

## addons/Community.pack/templates/forum/entry_metadata.mtml
	'1 Reply' => '1 Réponse',
	'# Replies' => '# Réponses',

## addons/Community.pack/templates/forum/entry.mtml

## addons/Community.pack/templates/forum/javascript.mtml
	'Thanks for signing in,' => 'Merci de vous être identifié,',
	'. Now you can reply to this topic.' => '. Maintenant vous pouvez répondre à ce sujet.',
	'You do not have permission to comment on this blog.' => 'Vous n\'avez pas la permission de commenter sur ce blog.',
	' to reply to this topic.' => ' pour répondre à ce sujet.',
	' to reply to this topic,' => ' pour répondre à ce sujet,',
	'or ' => 'ou ',
	'reply anonymously.' => 'répondre anonymement.',

## addons/Community.pack/templates/forum/entry_table.mtml
	'Recent Topics' => 'Sujets récents',
	'Replies' => 'Réponses',
	'Last Reply' => 'Dernière réponse',
	'Permalink to this Reply' => 'Lien permanent vers cette réponse',
	'By [_1]' => 'Par [_1]',
	'Closed' => 'Fermé',
	'Post the first topic in this forum.' => 'Créez le premier sujet de ce forum.',

## addons/Community.pack/templates/forum/archive_index.mtml

## addons/Community.pack/templates/forum/sidebar.mtml
	'Category Groups' => 'Groupes de catégorie',
	'Default Widgets' => 'Widgets par défaut',

## addons/Community.pack/templates/forum/category_groups.mtml
	'Forum Groups' => 'Groupes de forums',
	'Last Topic: [_1] by [_2] on [_3]' => 'Dernier sujet: [_1] par [_2] sur [_3]',
	'Be the first to <a href="[_1]">post a topic in this forum</a>' => 'Soyez le premier à <a href="[_1]">créer un sujet dans ce forum</a>',

## addons/Community.pack/templates/forum/openid.mtml

## addons/Community.pack/templates/forum/comments.mtml
	'No Replies' => 'Pas de Réponses',

## addons/Community.pack/templates/forum/search_results.mtml
	'Topics matching &ldquo;[_1]&rdquo;' => 'Sujets correspondants à &ldquo;[_1]&rdquo;',
	'Topics tagged &ldquo;[_1]&rdquo;' => 'Sujets taggués &ldquo;[_1]&rdquo;',
	'Topics' => 'Sujets',

## addons/Community.pack/templates/forum/comment_listing.mtml

## addons/Community.pack/templates/forum/dynamic_error.mtml

## addons/Community.pack/templates/forum/entry_popular.mtml
	'Popular topics' => 'Sujets populaires',

## addons/Community.pack/templates/forum/comment_preview.mtml
	'Reply to [_1]' => 'Répondre à [_1]',
	'Previewing your Reply' => 'Prévisualiser votre réponse',

## addons/Community.pack/config.yaml
	'Increase reader engagement - deploy features to your website that make it easier for your readers to engage with your content and your company.' => 'Accroître l\'implication du lecteur - en ajoutant des fonctionnalités sur votre site web rendant facile pour vos lecteurs de s\'impliquer sur le contenu et votre société.',
	'Create forums where users can post topics and responses to topics.' => 'Créer des forums où les utilisateurs peuvent publier des sujets et des réponses aux sujets.', # Translate - New
	'Pending Entries' => 'Notes en attente',
	'Spam Entries' => 'Notes indésirables',
	'Following Users' => 'Utilisateurs suiveurs',
	'Being Followed' => 'Être suivi',
	'Sanitize' => 'Nettoyer',
	'Login Form' => 'Formulaire d\'identification',
	'Registration Form' => 'Formulaire d\'enregistrement',
	'Registration Confirmation' => 'Confirmation d\'enregistrement',
	'Profile View' => 'Vue du profil',
	'Profile Edit Form' => 'Formulaire de modification du profil',
	'Profile Feed' => 'Flux du profil',
	'New Password Form' => 'Nouveau formulaire de mot de passe',
	'New Password Reset Form' => 'Nouveau formulaire de réinitialisation du mot de passe',
	'Email verification' => 'Vérification email',
	'Registration notification' => 'Notification enregistrement',
	'New entry notification' => 'Notification de nouvelle note',
	'Community Themes' => 'Thèmes de communautés',
	'Themes that are compatible with the Community themes.' => 'Thèmes compatibles avec les thèmes de communauté.',
	'Community Blog' => 'Blog de la communauté',
	'Atom ' => 'Atom',
	'Entry Response' => 'Réponse à la note',
	'Displays error, pending or confirmation message when submitting an entry.' => 'Afficher les erreurs et les messages de confirmation quand une note est écrite.',
	'Community Forum' => 'Forum de la communauté',
	'Entry Feed' => 'Flux de la note',
	'Displays error, pending or confirmation message when submitting a entry.' => 'Affiche les messages d\'erreur, de validation et de confirmation quand une nouvelle note est créée.',

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Show' => 'Afficher',
	'Date & Time' => 'Date & heure',
	'Date Only' => 'Date seulement',
	'Time Only' => 'Heure seulement',
	'Please enter all allowable options for this field as a comma delimited list' => 'Merci de saisir toutes les options autorisées pour ce champ dans une liste délimitée par des virgules',
	'Custom Fields' => 'Champs personnalisés',
	'[_1] Fields' => '[_1] champs',
	'Edit Field' => 'Modifier le champ',
	'Invalid date \'[_1]\'; dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Date invalide \'[_1]\'; les dates doivent être dans le format YYYY-MM-DD HH:MM:SS.',
	'Invalid date \'[_1]\'; dates should be real dates.' => 'Date invalide \'[_1]\'; les dates doivent être de vraies dates.',
	'Please enter valid URL for the URL field: [_1]' => 'Merci de saisir une URL correcte pour le champ URL : [_1]',
	'Please enter some value for required \'[_1]\' field.' => 'Merci de saisir une valeur pour le champ obligatoire \'[_1]\'.',
	'Please ensure all required fields have been filled in.' => 'Merci de vérifier que tous les champs obligatoires ont été remplis.',
	'The template tag \'[_1]\' is an invalid tag name.' => 'Le tag de gabarit \'[_1]\' est un nom de tag invalide',
	'The template tag \'[_1]\' is already in use.' => 'Le tag de gabarit \'[_1]\' est déjà utilisé.',
	'The basename \'[_1]\' is already in use.' => 'Le nom de base \'[_1]\' est déjà utilisé.',
	'You must select other type if object is the comment.' => 'Vous devez sélectionner d\'autre types si l\'objet est dans les commentaires.',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'Personnalisez les champs des notes, pages, répertoires, catégories et auteurs pour stocker toutes les informations dont vous avez besoin.',
	' ' => ' ',
	'Single-Line Text' => 'Texte sur une ligne',
	'Multi-Line Text' => 'Texte multi-lignes',
	'Checkbox' => 'Case à cocher',
	'Date and Time' => 'Date et heure',
	'Drop Down Menu' => 'Menu déroulant',
	'Radio Buttons' => 'Boutons radio',
	'Embed Object' => 'Élément externe',
	'Post Type' => 'Type de note',

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	'Are you sure you have used a \'[_1]\' tag in the correct context? We could not find the [_2]' => 'Etes-vous sûr d\'avoir utilisé un tag \'[_1]\' dans le contexte approprié ? Impossible de trouver le [_2]',
	'You used an \'[_1]\' tag outside of the context of the correct content; ' => 'Vous avez utilisé un tag \'[_1]\' en dehors du contexte du contenu correct; ',

## addons/Commercial.pack/lib/CustomFields/Upgrade.pm
	'Moving metadata storage for pages...' => 'Déplacement de l\'emplacement des métadonnées des pages en cours ...',

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Restoring custom fields data stored in MT::PluginData...' => 'Restauration des données des champs personnalisés stockées dans MT:PluginData...',
	'Restoring asset associations found in custom fields ( [_1] ) ...' => 'Restauration des associations d\'éléments trouvés dans les champs personnalisés ([_1]) ...',
	'Restoring url of the assets associated in custom fields ( [_1] )...' => 'Restauration des URLs des éléments associés dans les champs personnalisés ([_1]) ...',

## addons/Commercial.pack/lib/CustomFields/Theme.pm
	'[_1] custom fields' => 'Champs personnalisés [_1]',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'Field' => 'Champ',

## addons/Commercial.pack/tmpl/export_field.tmpl
	'Object' => 'Objet',

## addons/Commercial.pack/tmpl/edit_field.tmpl
	'Edit Custom Field' => 'Éditer le champs personnalisé',
	'Create Custom Field' => 'Créer une champ personnalisé',
	'The selected fields(s) has been deleted from the database.' => 'Les champs sélectionnés ont été effacés de la base de données.',
	'You must enter information into the required fields highlighted below before the Custom Field can be created.' => 'Vous devez entrer des informations dans le champs requis indiqué avant que le champs personnalisé soit créé.',
	'System Object' => 'Objet système',
	'Choose the system object where this Custom Field should appear.' => 'Sélectionnez l\'objet système dans lequel le champs devra apparaître.',
	'Select...' => 'Sélectionnez...',
	'Required?' => 'Obligatoire?',
	'Is data entry required in this Custom Field?' => 'Est-ce qu\'une donnée est requise dans ce champs personnalisé ?',
	'Must the user enter data into this Custom Field before the object may be saved?' => 'L\'utilisateur doit-il entrer quelque chose dans ce champs avant que l\'objet puisse être enregistré ?',
	'Default' => 'Défaut',
	'You must save this Custom Field before setting a default value.' => 'Vous devez sauvegarder ce champs personnalisé avant d\'indiquer une valeur par défaut.',
	'_CF_BASENAME' => 'Nom de base',
	'The basename must be unique within this installation of Movable Type.' => 'Le nom de base doit être unique dans toute cette installation Movable Type.',
	'Warning: Changing this field\'s basename may require changes to existing templates.' => 'Attention : le changement de ce nom de base peut nécessiter des changements additionnels dans vos gabarits existants.',
	'Template Tag' => 'Tag du gabarit',
	'Example Template Code' => 'Code de gabarit exemple',
	'Show In These [_1]' => 'Afficher dans ces [_1]',
	'Save this field (s)' => 'Enregistrer ce champs (s)',
	'field' => 'champ',
	'fields' => 'Champs',
	'Delete this field (x)' => 'Supprimer ce champs (x)',

## addons/Commercial.pack/tmpl/reorder_fields.tmpl
	'open' => 'ouvrir',
	'click-down and drag to move this field' => 'gardez le clic maintenu et glissez le curseur pour déplacer ce champs',
	'click to %toggle% this box' => 'cliquez pour %toggle% cette boîte',
	'use the arrow keys to move this box' => 'utilisez les touches flêchées de votre clavier pour déplacer cette boîte',
	', or press the enter key to %toggle% it' => ', ou pressez la touche entrée pour la %toggle%',

## addons/Commercial.pack/tmpl/list_field.tmpl
	'Manage Custom Fields' => 'Gérer les champs personnalisés',
	'New [_1] Field' => 'Nouveau champ [_1]',
	'Delete selected fields (x)' => 'Effacer les champs sélectionnés (x)',
	'No fields could be found.' => 'Aucun champ n\'a été trouvé.',
	'Display on' => 'Affucher sur',
	'System-Wide' => 'sur tout le système',

## addons/Commercial.pack/tmpl/asset-chooser.tmpl
	'Choose [_1]' => 'Choisir [_1]',
	'Remove [_1]' => 'Supprimer [_1]',

## addons/Commercial.pack/tmpl/cfg_customfields.tmpl
	'Data have been saved to custom fields.' => 'Les données ont été enregistrées pour les champs personnalisés.',
	'Save changes to blog (s)' => 'Sauvegarder les modifications du blog (s)',
	'No custom fileds could be found. <a href="[_1]">Create a field</a> now.' => 'Aucun champs personnalisé ne peut être trouvé. <a href="[_!]">Créer un champs</a> maintenant.',

## addons/Commercial.pack/tmpl/category_fields.tmpl
	'Show These Fields' => 'Afficher ces champs',

## addons/Commercial.pack/templates/professional/website/blog_index.mtml
	'Header' => 'Entête',
	'Footer' => 'Pied',

## addons/Commercial.pack/templates/professional/website/main_index.mtml

## addons/Commercial.pack/templates/professional/website/page.mtml
	'Page Detail' => 'Détails de la page',

## addons/Commercial.pack/templates/professional/website/entry_summary.mtml
	'Entry Metadata' => 'Metadonnées de la note',

## addons/Commercial.pack/templates/professional/website/comment_response.mtml

## addons/Commercial.pack/templates/professional/website/recent_entries_expanded.mtml
	'on [_1]' => 'sur [_1]', # Translate - New
	'By [_1] | Comments ([_2])' => 'Par [_1] | Commentaires ([_1])',

## addons/Commercial.pack/templates/professional/website/syndication.mtml

## addons/Commercial.pack/templates/professional/website/comment_detail.mtml

## addons/Commercial.pack/templates/professional/website/comment_form.mtml

## addons/Commercial.pack/templates/professional/website/signin.mtml

## addons/Commercial.pack/templates/professional/website/footer.mtml
	'Powered By (Footer)' => 'Powered By (Pied de Page)',
	'Footer Links' => 'Liens de Pied de Page',

## addons/Commercial.pack/templates/professional/website/tags.mtml

## addons/Commercial.pack/templates/professional/website/navigation.mtml
	'Home' => 'Accueil',

## addons/Commercial.pack/templates/professional/website/entry_metadata.mtml

## addons/Commercial.pack/templates/professional/website/javascript.mtml

## addons/Commercial.pack/templates/professional/website/trackbacks.mtml

## addons/Commercial.pack/templates/professional/website/sidebar.mtml
	'Main Sidebar' => 'Colonne latérale principale',
	'Blog Activity' => 'Activité du blog',

## addons/Commercial.pack/templates/professional/website/powered_by_footer.mtml

## addons/Commercial.pack/templates/professional/website/openid.mtml

## addons/Commercial.pack/templates/professional/website/comments.mtml

## addons/Commercial.pack/templates/professional/website/search_results.mtml

## addons/Commercial.pack/templates/professional/website/header.mtml
	'Navigation' => 'Navigation',

## addons/Commercial.pack/templates/professional/website/comment_listing.mtml

## addons/Commercial.pack/templates/professional/website/dynamic_error.mtml

## addons/Commercial.pack/templates/professional/website/footer_links.mtml
	'Links' => 'Liens',

## addons/Commercial.pack/templates/professional/website/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/website/comment_preview.mtml

## addons/Commercial.pack/templates/professional/website/search.mtml

## addons/Commercial.pack/templates/professional/website/blogs.mtml
	'Entries ([_1]) Comments ([_2])' => 'Notes ([_1]) Commentaires ([_2])',

## addons/Commercial.pack/templates/professional/blog/monthly_archive_dropdown.mtml

## addons/Commercial.pack/templates/professional/blog/category_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/search.mtml

## addons/Commercial.pack/templates/professional/blog/current_author_monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/main_index.mtml

## addons/Commercial.pack/templates/professional/blog/page.mtml

## addons/Commercial.pack/templates/professional/blog/main_index_widgets_group.mtml

## addons/Commercial.pack/templates/professional/blog/entry_summary.mtml

## addons/Commercial.pack/templates/professional/blog/comment_response.mtml

## addons/Commercial.pack/templates/professional/blog/entry_detail.mtml

## addons/Commercial.pack/templates/professional/blog/archive_widgets_group.mtml

## addons/Commercial.pack/templates/professional/blog/comment_detail.mtml

## addons/Commercial.pack/templates/professional/blog/syndication.mtml

## addons/Commercial.pack/templates/professional/blog/comment_form.mtml

## addons/Commercial.pack/templates/professional/blog/comment_preview.mtml

## addons/Commercial.pack/templates/professional/blog/current_category_monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] a commenté sur [_3]</a> : [_4]',

## addons/Commercial.pack/templates/professional/blog/monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/signin.mtml

## addons/Commercial.pack/templates/professional/blog/entry_listing.mtml
	'Recently by <em>[_1]</em>' => 'Récemment par <em>[_1]</em>',

## addons/Commercial.pack/templates/professional/blog/about_this_page.mtml

## addons/Commercial.pack/templates/professional/blog/footer.mtml

## addons/Commercial.pack/templates/professional/blog/tags.mtml

## addons/Commercial.pack/templates/professional/blog/navigation.mtml

## addons/Commercial.pack/templates/professional/blog/entry_metadata.mtml

## addons/Commercial.pack/templates/professional/blog/entry.mtml
	'Entry Detail' => 'Détails de la note',

## addons/Commercial.pack/templates/professional/blog/javascript.mtml

## addons/Commercial.pack/templates/professional/blog/archive_index.mtml

## addons/Commercial.pack/templates/professional/blog/trackbacks.mtml

## addons/Commercial.pack/templates/professional/blog/calendar.mtml

## addons/Commercial.pack/templates/professional/blog/recent_entries.mtml

## addons/Commercial.pack/templates/professional/blog/sidebar.mtml
	'Blog Archives' => 'Archives du blog',

## addons/Commercial.pack/templates/professional/blog/powered_by_footer.mtml

## addons/Commercial.pack/templates/professional/blog/openid.mtml

## addons/Commercial.pack/templates/professional/blog/date_based_author_archives.mtml

## addons/Commercial.pack/templates/professional/blog/categories.mtml

## addons/Commercial.pack/templates/professional/blog/comments.mtml

## addons/Commercial.pack/templates/professional/blog/search_results.mtml

## addons/Commercial.pack/templates/professional/blog/header.mtml

## addons/Commercial.pack/templates/professional/blog/comment_listing.mtml

## addons/Commercial.pack/templates/professional/blog/date_based_category_archives.mtml

## addons/Commercial.pack/templates/professional/blog/dynamic_error.mtml

## addons/Commercial.pack/templates/professional/blog/creative_commons.mtml

## addons/Commercial.pack/templates/professional/blog/footer_links.mtml

## addons/Commercial.pack/templates/professional/blog/author_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/blog/recent_assets.mtml

## addons/Commercial.pack/config.yaml
	'Professional designed, well structured and easily adaptable web site. You can customize default pages, footer and top navigation easily.' => 'Conçu pour les professionnels, bien structué et facilement adaptable, vous pouvez personnaliser les pages par défaut, le pied de page et la navigation facilement.',
	'_PWT_ABOUT_BODY' => '_PWT_ABOUT_BODY',
	'_PWT_CONTACT_BODY' => '_PWT_CONTACT_BODY',
	'Welcome to our new website!' => 'Bienvenue sur notre nouveau site !',
	'_PWT_HOME_BODY' => '_PWT_HOME_BODY',
	'Create a blog as a part of structured website. This works best with Professional Website theme.' => 'Créer un blog en tant que partie d\'un site web. Cela fonctionne mieux avec un thème de sites web profeesionnels.', # Translate - New
	'Photo' => 'Photo',
	'Embed' => 'Embarqué',
	'Updating Universal Template Set to Professional Website set...' => 'Mise à jour du jeu de gabarits universel vers sites web professionnels...',
	'Professional Website' => 'Sites web professionnels',
	'Themes that are compatible with the Professional Website template set.' => 'Thèmes qui sont compatible avec le jeu de gabarits sites web professionels.', # Translate - New
	'Blog Index' => 'Index du Blog',
	'Recent Entries Expanded' => 'Entrées étendues récentes',
	'Professional Blog' => 'Blog professionel', # Translate - New

## addons/Enterprise.pack/lib/MT/Enterprise/Upgrade.pm
	'Fixing binary data for Microsoft SQL Server storage...' => 'Correction des données binaires pour le stockage Microsoft SQL Server...',

## addons/Enterprise.pack/lib/MT/Enterprise/Wizard.pm
	'PLAIN' => 'PLAIN',
	'CRAM-MD5' => 'CRAM-MD5',
	'Digest-MD5' => 'Digest-MD5',
	'Login' => 'Identifiant',
	'Found' => 'Trouvé',
	'Not Found' => 'Non trouvé',

## addons/Enterprise.pack/lib/MT/Enterprise/BulkCreation.pm
	'Format error at line [_1]: [_2]' => 'Erreur de format à la ligne [_1]: [_2]',
	'Invalid command: [_1]' => 'Commande invalide: [_1]',
	'Invalid number of columns for [_1]' => 'Nombre de colonnes invalide pour [_1]',
	'Invalid user name: [_1]' => 'Identifiant invalide: [_1]',
	'Invalid display name: [_1]' => 'Nom d\'affichage invalide: [_1]',
	'Invalid email address: [_1]' => 'Adresse email invalide: [_1]',
	'Invalid language: [_1]' => 'Langue invalide: [_1]',
	'Invalid password: [_1]' => 'Mot de passe invalide: [_1]',
	'Invalid password recovery phrase: [_1]' => 'Phrase de récupération de mot de passe invalide: [_1]',
	'Invalid weblog name: [_1]' => 'Nom de weblog invalide: [_1]',
	'Invalid weblog description: [_1]' => 'Description de weblog invalide: [_1]',
	'Invalid site url: [_1]' => 'URL du site invalide: [_1]',
	'Invalid site root: [_1]' => 'Racine du site invalide: [_1]',
	'Invalid timezone: [_1]' => 'Fuseau horaire invalide: [_1]',
	'Invalid new user name: [_1]' => 'Nouvel identifiant invalide: [_1]',
	'A user with the same name was found.  Register was not processed: [_1]' => 'Un utilisateur avec le même nom a été trouvé. L\'enregistrement n\'a pas été effectué: [_1]',
	'Blog for user \'[_1]\' can not be created.' => 'Le blog pour l\'utilisateur \'[_1]\' ne peut être créé.',
	'Blog \'[_1]\' for user \'[_2]\' has been created.' => 'Le blog \'[_1]\' pour l\'utilisateur \'[_2]\' a été créé.',
	'Error assigning weblog administration rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable weblog administrator role was found.' => 'Erreur en tentant d\'assigner les droits d\'administration du blog à l\'utilisateur \'[_1] (ID: [_2])\' pour le weblog \'[_3] (ID: [_4])\'. Aucun rôle d\'administrateur de weblog adéquat n\'a été trouvé.',
	'Permission granted to user \'[_1]\'' => 'Permission accordée à l\'utilisateur \'[_1]\'',
	'User \'[_1]\' already exists. Update was not processed: [_2]' => 'L\'utilisateur \'[_1]\' existe déjà. La mise a jour n\'a pas eu lieu: [_2]',
	'User cannot be updated: [_1].' => 'Utilisateur ne peut être mis à jour: [_1].',
	'User \'[_1]\' not found.  Update was not processed.' => 'L\'utilisateur \'[_1]\' n\'a pas été trouvé. La mise à jour n\'a pas eu lieu.',
	'User \'[_1]\' has been updated.' => 'L\'utilisateur \'[_1]\' a été mis à jour.',
	'User \'[_1]\' was found, but delete was not processed' => 'L\'utilisateur \'[_1]\' a été trouvé, mais la suppression n\'a pas eu lieu.',
	'User \'[_1]\' not found.  Delete was not processed.' => 'L\'utilisateur \'[_1]\' n\'a pas été trouvé. La suppression n\'a pas eu lieu.',
	'User \'[_1]\' has been deleted.' => 'L\'utilisateur \'[_1]\' a été supprimé.',

## addons/Enterprise.pack/lib/MT/Enterprise/CMS.pm
	'Add [_1] to a blog' => 'Ajouter [_1] à un blog',
	'You can not create associations for disabled groups.' => 'Vous ne pouvez pas créer d\'association pour les groupes désactivés.',
	'Assign Role to Group' => 'Ajouter le rôle au groupe',
	'Add a group to this blog' => 'Ajouter un groupe à ce blog',
	'Grant permission to a group' => 'Ajouter une autorisation à un groupe',
	'Movable Type Enterprise has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.' => 'Movable Type Enterprise vient de tenter de désactiver votre compte pendant la synchronisation avec l\'annuaire externe. Certains des paramètres du système de gestion externe des utilisateurs doivent être erronés. Merci de corriger avant de poursuivre.',
	'Group requires name' => 'Le groupe nécessite un nom.',
	'Invalid group' => 'Groupe invalide.',
	'Add Users to Group [_1]' => 'Ajouter les utilisateurs au groupe [_1]',
	'Groups' => 'Groupes',
	'Users & Groups' => 'Utilisateurs et Groupes',
	'User Groups' => 'Groupes de l\'utilisateur',
	'Group load failed: [_1]' => 'Chargement du groupe échoué: [_1]',
	'User load failed: [_1]' => 'Chargement de l\'utilisateur échoué: [_1]',
	'User \'[_1]\' (ID:[_2]) removed from group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) supprimé du groupe \'[_3]\' (ID:[_4]) par \'[_5]\'',
	'User \'[_1]\' (ID:[_2]) was added to group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) a été ajouté au groupe \'[_3]\' (ID:[_4]) par \'[_5]\'',
	'Group Profile' => 'Profil du Groupe',
	'Author load failed: [_1]' => 'Chargement de l\'auteur échoué: [_1]',
	'Invalid user' => 'Utilisateur invalide',
	'Assign User [_1] to Groups' => 'Assigner l\'utilisateur [_1] aux groupes.',
	'Select Groups' => 'Sélectionner les groupes',
	'Group' => 'Groupe',
	'Groups Selected' => 'Groupes sélectionnés',
	'Type a group name to filter the choices below.' => 'Tapez un nom de groupe pour filtrer les choix ci-dessous.',
	'Group Name' => 'Nom du groupe',
	'Search Groups' => 'Rechercher des groupes',
	'Bulk import cannot be used under external user management.' => 'L\'import en masse ne peut être utilisé avec la gestion externe des utilisateurs.',
	'Bulk management' => 'Gestion en masse',
	'No record found in the file.  Make sure the file uses CRLF as the line ending character.' => 'Aucune entrée n\'a été trouvée dans le fichier. Assurez-vous que le fichier utilise CRLF comme caractère de fin de ligne.',
	'Registered [quant,_1,user,users], updated [quant,_2,user,users], deleted [quant,_3,user,users].' => 'Création de [quant,_1,utilisateur,utilisateurs], modification de [quant,_2, utilisateur, utilisateurs], suppression de [quant,_3, utilisateur, utilisateurs.',
	'The group' => 'Le groupe',
	'User/Group' => 'Utilisateur/Groupe',
	'A user can\'t change his/her own username in this environment.' => 'Un utilisateur ne peut pas changer son nom d\'utilisateur dans cet environnement',
	'An error occurred when enabling this user.' => 'Une erreur s\'est produite pendant l\'activation de cet utilisateur.',

## addons/Enterprise.pack/lib/MT/Auth/LDAP.pm
	'User [_1]([_2]) not found.' => 'Utilisateur [_1]([_2]) non trouvé.',
	'User \'[_1]\' cannot be updated.' => 'Utilisateur \'[_1]\' ne peut être mis à jour.',
	'User \'[_1]\' updated with LDAP login ID.' => 'Utilisateur \'[_1]\' mis à jour avec l\'ID de login LDAP.',
	'LDAP user [_1] not found.' => 'Utilisateur LDAP [_1] non trouvé.',
	'User [_1] cannot be updated.' => 'Utilisateur [_1] ne peut être mis à jour.',
	'Failed login attempt by user \'[_1]\' deleted from LDAP.' => 'Tentative de login échouée par utilisateur \'[_1]\' supprimé de LDAP.',
	'User \'[_1]\' updated with LDAP login name \'[_2]\'.' => 'Utilisateur \'[_1]\' mis à jour avec l\'identifiant LDAP \'[_2]\'.',
	"Failed login attempt by user \'[_1]\'. A user with that\nusername already exists in the system with a different UUID." => "Echec de la connexion pour l\'utilisateur\'[_1]\'. Un utilisateur avec cet
identifiant existe mais avec un UUID différent.",
	'User \'[_1]\' account is disabled.' => 'Le compte de l\'utilisateur \'[_1]\' est désactivé.',
	'LDAP users synchronization interrupted.' => 'Synchronisation des utilisateurs LDAP interrompue.',
	'Loading MT::LDAP failed: [_1]' => 'Chargement de MT::LDAP échoué: [_1]',
	'External user synchronization failed.' => 'Synchronisation utilisateur externe échouée.',
	'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'Une tentative de désactivation de tous les administrateurs système a été réalisée. La synchronisation des utilisateurs a été interrompue.',
	'The following users\' information were modified:' => 'Les informations suivantes des utilisateurs ont été modifiées:',
	'The following users were disabled:' => 'Les utilisateurs suivants ont été désactivés:',
	'LDAP users synchronized.' => 'Utilisateurs LDAP synchronisés.',
	'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute is set.' => 'La synchronisation des groupes ne peut avoir lieu sans LDAPGroupIdAttribute et/ou LDAPGroupNameAttribute paramétré.',
	'LDAP groups synchronized with existing groups.' => 'Groupes LDAP synchronisés avec les groupes existants.',
	'The following groups\' information were modified:' => 'Les informations suivantes des groupes ont été modifiées:',
	'No LDAP group was found using given filter.' => 'Aucun groupe LDAP n\'a été trouvé avec le filtre fourni.',
	"Filter used to search for groups: [_1]\nSearch base: [_2]" => "Filtre utilisé pour la recherche dans les groupes : [_1]
Base de recherche : [_2]",
	'(none)' => '(Aucun)',
	'The following groups were deleted:' => 'Les groupes suivants ont été effacés:',
	'Failed to create a new group: [_1]' => 'Impossible de créer un nouveau groupe: [_1]',
	'[_1] directive must be set to synchronize members of LDAP groups to Movable Type Enterprise.' => 'La directive [_1] doit être configurée pour synchroniser les membres des groupes LDAP avec Movable Type Enterprise.',
	'Members removed: ' => 'Membres supprimés:',
	'Members added: ' => 'Membres ajoutés:',
	'Memberships of the group \'[_2]\' (#[_3]) has been changed in synchronizing with external directory.' => 'Les membres du groupe \'[_2]\' (#[_3]) ont été changé en synchronisant avec l\'annuaire externe.',
	'LDAPUserGroupMemberAttribute must be set to enable synchronize members of groups.' => 'LDAPUserGroupMemberAttribute doit être configuré pour activer la synchronisation des membres des groupes.',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/MSSQLServer.pm
	'PublishCharset [_1] is not supported in this version of MS SQL Server Driver.' => 'PublishCharset [_1] n\'est pas supporté dans cette version de driver MS SQL Server.',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/UMSSQLServer.pm
	'This version of UMSSQLServer driver requires DBD::ODBC version 1.14.' => 'Cette version du driver UMSSQLServer nécessite DBD::ODBC version 1.14.',
	'This version of UMSSQLServer driver requires DBD::ODBC compiled with Unicode support.' => 'Cette version du driver UMSSQLServer nécessite DBD::ODBC compilé avec le support de Unicode.',

## addons/Enterprise.pack/lib/MT/Group.pm

## addons/Enterprise.pack/lib/MT/LDAP.pm
	'Invalid LDAPAuthURL scheme: [_1].' => 'LDAPAuthURL invalide : [_1].',
	'Error connecting to LDAP server [_1]: [_2]' => 'Erreur de connection au serveur LDAP [_1]: [_2]',
	'User not found on LDAP: [_1]' => 'Utilisateur non trouvé dans LDAP : [_1]',
	'Binding to LDAP server failed: [_1]' => 'Rattachement au serveur LDAP échoué: [_1]',
	'More than one user with the same name found on LDAP: [_1]' => 'Plus d\'un utilisateur avec le même nom trouvé dans LDAP: [_1]',

## addons/Enterprise.pack/tmpl/dialog/select_groups.tmpl
	'You need to create some groups.' => 'Vous devez créer des groupes',
	'Before you can do this, you need to create some groups. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a group.' => 'Avant de pouvoir faire ceci, vous devez créer des groupes. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Cliquez ici</a> pour créer un groupe.',

## addons/Enterprise.pack/tmpl/include/list_associations/page_title.group.tmpl
	'Users &amp; Groups for [_1]' => 'Utilisateurs &amp; groupes pour [_1]',
	'Group Associations for [_1]' => 'Associations de groupe pour [_1]',

## addons/Enterprise.pack/tmpl/include/users_content_nav.tmpl
	'Users &amp; Groups' => 'Utilisateurs &amp; Groupes',

## addons/Enterprise.pack/tmpl/include/group_table.tmpl
	'group' => 'groupe',
	'groups' => 'Groupes',
	'Enable selected group (e)' => 'Activer le groupe sélectionné (e)',
	'Disable selected group (d)' => 'Désactiver le groupe sélectionné (d)',
	'Remove selected group (d)' => 'Supprimer le groupe sélectionné (d)',
	'Only show enabled groups' => 'Afficher uniquement les groupes activés',
	'Only show disabled groups' => 'Afficher uniquement les groupes désactivés',

## addons/Enterprise.pack/tmpl/list_group.tmpl
	'[_1]: User&rsquo;s Groups' => '[_1]: Groupes de l\'utilisateur',
	'Manage Groups' => 'Gérer les groupes', # Translate - New
	'You have successfully disabled the selected group(s).' => 'Vous avez désactivé les groupes sélectionnés avec succès.',
	'You have successfully enabled the selected group(s).' => 'Vous avez activé les groupes sélectionnés avec succès.',
	'You have successfully deleted the groups from the Movable Type system.' => 'Vous avez supprimé les groupes du système Movable Type avec succès.',
	'You have successfully synchronized groups\' information with the external directory.' => 'Vous avez synchronisé avec succès les informations des groupes avec le répertoire externe.',
	'The user <em>[_1]</em> is currently disabled.' => 'L\'utilisateur <em>[_1]</em> est actuellement désactivé',
	'You can not add disabled users to groups.' => 'Vous ne pouvez pas ajouter dans les groupes des utilisateurs désactivés.',
	'Add [_1] to another group' => 'Ajouter [_1] à un autre groupe',
	'Create Group' => 'Créer un groupe',
	'You did not select any [_1] to remove.' => 'Vous n\'avez sélectionné aucun [_1] à supprimer.',
	'Are you sure you want to remove this [_1]?' => 'Etes-vous sûr de vouloir supprimer ce [_1]?',
	'Are you sure you want to remove the [_1] selected [_2]?' => 'Etes-vous sûr de vouloir supprimer le [_1] sélectionné [_2]?',
	'to remove' => 'à supprimer',

## addons/Enterprise.pack/tmpl/create_author_bulk_end.tmpl
	'All users updated successfully!' => 'Tous les utilisateurs ont été mis à jour avec succès!',
	'An error occurred during the updating process. Please check your CSV file.' => 'Une erreur s\'est produite pendant la mise à jour. Merci de vérifier votre fichier CSV.',

## addons/Enterprise.pack/tmpl/list_group_member.tmpl
	'[_1]: Group Members' => '[_1]: Membres du groupe',
	'<em>[_1]</em>: Group Members' => '<em>[_1]</em>: Membres du groupe',
	'You have successfully deleted the users.' => 'Vous avez supprimé les utilisateurs avec succès.',
	'You have successfully added new users to this group.' => 'Vous avez ajouté les nouveaux utilisateurs dans ce groupe avec succès.',
	'You have successfully synchronized users\' information with external directory.' => 'Vous avez synchronisé avec succès les informations des utilisateurs avec l\'annuaire externe.',
	'Some ([_1]) of the selected users could not be re-enabled because they were no longer found in LDAP.' => 'Certains ([_1]) utilisateurs sélectionnés n\'ont pu être réactivés car ils ne sont plus dans LDAP.',
	'You have successfully removed the users from this group.' => 'Vous avez retirés avec succès les utilisateurs de ce groupe.',
	'Group Disabled' => 'Groupe désactivé',
	'You can not add users to a disabled group.' => 'Vous ne pouvez pas ajouter des utilisateurs à un groupe désactivé.',
	'Add user to [_1]' => 'Ajouter utilisateur à [_1]',
	'member' => 'membre',
	'Show Enabled Members' => 'Afficher les membres actifs',
	'Show Disabled Members' => 'Afficher les membres désactivés',
	'Show All Members' => 'Afficher tous les membres',
	'None.' => 'Aucun.',
	'(Showing all users.)' => '(Afficher tous les utilisateurs.)',
	'Showing only users whose [_1] is [_2].' => 'Afficher seulement les utilisateurs dont [_1] est [_2].',
	'Show' => 'Afficher',
	'all' => 'Toutes',
	'only' => 'seulement',
	'users where' => 'utilisateurs où',
	'No members in group' => 'Aucun membre dans ce groupe',
	'Only show enabled users' => 'Afficher seulement les utilisateurs actifs',
	'Only show disabled users' => 'Afficher seulement les utilisateurs désactivés.',
	'Are you sure you want to remove this [_1] from this group?' => 'Etes-vous sûr des vouloir supprimer ce [_1] de ce groupe?',
	'Are you sure you want to remove the [_1] selected [_2] from this group?' => 'Etes-vous sûr des vouloir supprimer le [_1] sélectionné [_2] de ce groupe?',

## addons/Enterprise.pack/tmpl/author_bulk.tmpl
	'Manage Users in bulk' => 'Gérer les utilisateurs en masse',
	'_USAGE_AUTHORS_2' => 'Vous pouvez créer, modifier et effacer des utilisateurs en masse en chargeant un fichier CSV contenant ces commandes et les données associées.',
	'Upload source file' => 'Charger le fichier source',
	'Specify the CSV-formatted source file for upload' => 'Spécifier le fichier source CSV à charger',
	'Source File Encoding' => 'Encodage du fichier source',
	'Upload (u)' => 'Charger (u)',

## addons/Enterprise.pack/tmpl/cfg_ldap.tmpl
	'Authentication Configuration' => 'Configuration de l\'identification',
	'You must set your Authentication URL.' => 'Vous devez configurer votre URL d\'identification.',
	'You must set your Group search base.' => 'Vous devez configurer votre base de recherche de groupes.',
	'You must set your UserID attribute.' => 'Vous devez configurer votre attribut UserID.',
	'You must set your email attribute.' => 'Vous devez configurer votre attribut email.',
	'You must set your user fullname attribute.' => 'Vous devez configurer votre attribut nom complet de l\'utilisateur.',
	'You must set your user member attribute.' => 'Vous devez configurer votre attribut de membre de l\'utilisateur.',
	'You must set your GroupID attribute.' => 'Vous devez configurer votre attribut GroupID.',
	'You must set your group name attribute.' => 'Vous devez configurer votre attribut nom de groupe.',
	'You must set your group fullname attribute.' => 'Vous devez configurer votre attribut nom complet du groupe.',
	'You must set your group member attribute.' => 'Vous devez configurer votre attribut member du groupe.',
	'You can configure your LDAP settings from here if you would like to use LDAP-based authentication.' => 'Vous devez configurer vos réglages LDAP ici si vous souhaitez utiliser l\'identification LDAP.',
	'Your configuration was successful.' => 'Votre configuration est correcte.',
	'Click \'Continue\' below to configure the External User Management settings.' => 'Cliquez sur \'Continuer\' ci-dessous pour configurer les réglages de la gestion externe des utilisateurs.',
	'Click \'Continue\' below to configure your LDAP attribute mappings.' => 'Cliquez sur \'Continuer\' ci-dessous pour configurer vos rattachements des attributs LDAP.',
	'Your LDAP configuration is complete.' => 'Votre configuration LDAP est terminée.',
	'To finish with the configuration wizard, press \'Continue\' below.' => 'Pour finir l\'assistant de configuration, cliquez sur \'Continuer\' ci-dessous.',
	'An error occurred while attempting to connect to the LDAP server: ' => 'Une erreur s\'est produite en essayant de se connecter au serveur LDAP:',
	'Use LDAP' => 'Utiliser LDAP',
	'Authentication URL' => 'URL d\'identification',
	'The URL to access for LDAP authentication.' => 'L\'URL pour accéder à l\'identification LDAP.',
	'Authentication DN' => 'Identificatiin DN',
	'An optional DN used to bind to the LDAP directory when searching for a user.' => 'Un DN optionnel utilisé pour rattacher à l\'annuaire LDAP lors d\'une recherche d\'utilisateur.',
	'Authentication password' => 'Mot de passe de l\'identification',
	'Used for setting the password of the LDAP DN.' => 'Utilisé pour régler le mot de passe du DN LDAP.',
	'SASL Mechanism' => 'Mécanisme SASL',
	'The name of SASL Mechanism to use for both binding and authentication.' => 'Nom du mécanisme SASL à utiliser pour le rattachement et l\'identification.',
	'Test Username' => 'Identifiant de test',
	'Test Password' => 'Mot de passe de test',
	'Enable External User Management' => 'Activer les gestion externe des utilisateurs',
	'Synchronization Frequency' => 'Fréquence de synchronisation',
	'Frequency of synchronization in minutes. (Default is 60 minutes)' => 'Fréquence de synchronisation en minutes. (60 minutes par défaut)',
	'15 Minutes' => '15 Minutes',
	'30 Minutes' => '30 Minutes',
	'60 Minutes' => '60 Minutes',
	'90 Minutes' => '90 Minutes',
	'Group search base attribute' => 'Attribut de base de recherche du groupe',
	'Group filter attribute' => 'Attribut de filtre du groupe',
	'Search Results (max 10 entries)' => 'Résultats de recherche (maxi 10 entrées)',
	'CN' => 'CN',
	'No groups were found with these settings.' => 'Aucun groupe n\'a été trouvé avec ces réglages.',
	'Attribute mapping' => 'Rattachement d\'attribut',
	'LDAP Server' => 'Serveur LDAP',
	'Other' => 'Autre',
	'User ID attribute' => 'Attribut ID utilisateur',
	'Email Attribute' => 'Attribut email',
	'User fullname attribute' => 'Attribut nom complet utilisateur',
	'User member attribute' => 'Attribut membre utilisateur',
	'GroupID attribute' => 'Attribut GroupID',
	'Group name attribute' => 'Attribut nom du groupe',
	'Group fullname attribute' => 'Attribut nom complet du groupe',
	'Group member attribute' => 'Attribut membre du groupe',
	'Search result (max 10 entries)' => 'Résultat de recherche (maxi 10 entrées)',
	'Group Fullname' => 'Nom complet du groupe',
	'Group Member' => 'Membre du groupe',
	'No groups could be found.' => 'Aucun groupe n\'a été trouvé.',
	'User Fullname' => 'Nom complet utilisateur',
	'No users could be found.' => 'Aucun utilisateur n\'a été trouvé.',
	'Test connection to LDAP' => 'Tester la connection à LDAP',
	'Test search' => 'Tester la recherche',

## addons/Enterprise.pack/tmpl/create_author_bulk_start.tmpl
	'Bulk Author Import' => 'Importer les auteurs en masse',

## addons/Enterprise.pack/tmpl/edit_group.tmpl
	'Edit Group' => 'Modifier le groupe',
	'Group profile has been updated.' => 'Le profil du groupe a été modifié.',
	'LDAP Group ID' => 'Group ID LDAP',
	'The LDAP directory ID for this group.' => 'L\'ID de l\'annuaire LDAP pour ce groupe.',
	'Status of group in the system. Disabling a group removes its members&rsquo; access to the system but preserves their content and history.' => 'Statut du groupe dans le système. Désactiver un groupe supprime l\'accès de ses membres au système mais préserve leur contenu et historique.',
	'The name used for identifying this group.' => 'Le nom utilisé pour identifier ce groupe.',
	'The display name for this group.' => 'Le nom d\'affichage de ce groupe.',
	'Enter a description for your group.' => 'Saisir une description pour votre groupe.',
	'Created on' => 'Créé le',
	'Save changes to this field (s)' => 'Sauvegarder les changements apportés à ce champ (s)',

## addons/Enterprise.pack/app-wizard.yaml
	'This module is required in order to use the LDAP Authentication.' => 'Ce module est nécessaire pour utiliser l\'identification LDAP.',
	'This module is required in order to use SSL/TLS connection with the LDAP Authentication.' => 'Ce module est nécessaire pour utiliser les connections SSL/TLS avec l\'identification LDAP.',

## addons/Enterprise.pack/app-cms.yaml
	'Are you sure you want to delete the selected group(s)?' => 'Etes-vous sûr de vouloir effacer les groupes sélectionnés?',
	'Bulk Author Export' => 'Export auteurs en masse',
	'Synchronize Users' => 'Synchroniser les utilisateurs',
	'Synchronize Groups' => 'Synchroniser les groupes',

## addons/Enterprise.pack/config.yaml
	'Enterprise Pack' => 'Enterprise Pack',
	'Oracle Database' => 'Base de données Oracle',
	'Microsoft SQL Server Database' => 'Base de données Microsoft SQL Server',
	'Microsoft SQL Server Database (UTF-8 support)' => 'Base de données Microsoft SQL Server (support UTF-8)',
	'External Directory Synchronization' => 'Synchronization répertoire externe',
	'Populating author\'s external ID to have lower case user name...' => 'Peuplement de l\'ID externe d\'auteur pour avoir des identifiants en minuscule...',

## plugins/Markdown/SmartyPants.pl
	'Easily translates plain punctuation characters into \'smart\' typographic punctuation.' => 'Permet de convertir facilement des caractères de ponctuation basiques vers une ponctuation plus complexe (comme les guillemets, tirets, etc...)',

## plugins/Markdown/Markdown.pl
	'A plain-text-to-HTML formatting plugin.' => 'Un plugin de formatage plain-text vers HTML',
	'Markdown' => 'Markdown',
	'Markdown With SmartyPants' => 'Markdown avec SmartyPants',

## plugins/WXRImporter/lib/WXRImporter/Import.pm

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'Le fichier n\'est pas dans le format WXR.',
	'Creating new tag (\'[_1]\')...' => 'Création d\'un nouveau tag (\'[_1]\')...',
	'Saving tag failed: [_1]' => 'L\'enregistrement du tag a échoué : [_1]',
	'Duplicate asset (\'[_1]\') found.  Skipping.' => 'L\'élément  (\'[_1]\') a été trouvé en double. Abandon.',
	'Saving asset (\'[_1]\')...' => 'Enregistrement de l\'élément (\'[_1]\')...',
	' and asset will be tagged (\'[_1]\')...' => ' et l\'élément sera taggué (\'[_1]\')...',
	'Duplicate entry (\'[_1]\') found.  Skipping.' => 'La note  (\'[_1]\') a été trouvée en double. Abandon.',
	'Saving page (\'[_1]\')...' => 'Enregistrement de la page (\'[_1]\')...',

## plugins/WXRImporter/tmpl/options.tmpl
	'Before you import WordPress posts to Movable Type, we recommend that you <a href=\'[_1]\'>configure your blog\'s publishing paths</a> first.' => 'Avant d\'importer des notes Wordpress dans Movable Type, nous vous recommandons d\'abord de <a href=\'[_1]\'>configurer les chemins de publication de votre blog</a>.',
	'Upload path for this WordPress blog' => 'Chemin d\'envoi pour ce blog WordPress',
	'Replace with' => 'Remplacer par',
	'Download attachments' => 'Télécharger les fichiers attachés',
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'L\'utilisation d\'un cron job est requis pour télécharger en arrière plan les fichiers attachés à un blog WordPress.',
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'Télécharger les fichiers attachés d\'un blog WordPress (images et autres documents).',

## plugins/WXRImporter/WXRImporter.pl
	'Import WordPress exported RSS into MT.' => 'Importer depuis WordPress exported RSS vers MT',
	'WordPress eXtended RSS (WXR)' => 'WordPress eXtended RSS (WXR)',
	'Download WP attachments via HTTP.' => 'Télécharger tous les fichiers attachés à un blog WordPress par HTTP',

## plugins/TypePadAntiSpam/lib/MT/TypePadAntiSpam.pm
	'API key is a required parameter.' => 'La clé API est requise.',

## plugins/TypePadAntiSpam/tmpl/system.tmpl
	'API Key' => 'Clé API',
	'To enable this plugin, you\'ll need a free TypePad AntiSpam API key. You can <strong>get your free API key at [_1]antispam.typepad.com[_2]</strong>. Once you have your key, return to this page and enter it in the field below.' => 'Pour activer ce plugin, vous devez obtenir une clé API gratuite TypePad AntiSpam. Vous pouvez <strong>obtenir votre clé API gratuite sur [_1]antispam.typepad.com[_2]</strong>. Une fois votre clé obtenue, retournez sur cette page et entrez-là dans le champs ci-dessous.',
	'Service Host' => 'Hébergeur de service',
	'The default service host for TypePad AntiSpam is api.antispam.typepad.com. You should only change this if you are using a different service that is compatible with the TypePad AntiSpam API.' => 'L\'hébergeur de service par défaut pour TypePad AntiSpam est api.antispam.typepad.com. Vous ne devriez changer cela uniquement si vous utilisez un autre service compatible avec l\'API TypePad AntiSpam.',

## plugins/TypePadAntiSpam/tmpl/config.tmpl
	'Junk Score Weight' => 'Niveau du filtrage',
	'Least Weight' => 'Moins agressif',
	'Most Weight' => 'Plus agressif',
	'Comments and TrackBacks receive a junk score between -10 (definitely spam) and +10 (definitely not spam). This setting allows you to control the weight of the TypePad AntiSpam rating relative to other filters you may have installed to help you filter comments and TrackBacks.' => 'Les commentaires et trackbakcs reçoivent une note de spam entre - 10 (très forte probabilité d\'être du spam) et +10 (très forte probabilité de n\'être pas du spam). Ces paramètres vous permettent de contrôler la pondération du filtre de TypePad AntiSpam vis-à-vis des autres filtres que vous pouvez avoir installé pour vous aider à filtrer les commentaires et trackbacks.',

## plugins/TypePadAntiSpam/tmpl/stats_widget.tmpl
	'TypePad AntiSpam' => 'TypePad AntiSpam',
	'Spam Blocked' => 'Spam bloqué',
	'on this blog' => 'sur ce blog',
	'on this system' => 'sur ce système',

## plugins/TypePadAntiSpam/TypePadAntiSpam.pl
	'TypePad AntiSpam is a free service from Six Apart that helps protect your blog from comment and TrackBack spam. The TypePad AntiSpam plugin will send every comment or TrackBack submitted to your blog to the service for evaluation, and Movable Type will filter items if TypePad AntiSpam determines it is spam. If you discover that TypePad AntiSpam incorrectly classifies an item, simply change its classification by marking it as "Spam" or "Not Spam" from the Manage Comments screen, and TypePad AntiSpam will learn from your actions. Over time the service will improve based on reports from its users, so take care when marking items as "Spam" or "Not Spam."' => 'TypePad AntiSpam est un service gratuit de Six Apart vous aidant à protéger votre blog des commentaires et trackbacks de spam. Le plugin TypePad AntiSpam enverra chaque commentaire ou trackback reçu sur votre blog au service pour un évaluation et Movable Type filtrera les éléments si TypePad AntiSpam considère ces éléments comme étant du spam. Si vous découvrez un élément que TypePad AntiSpam a mal filtré, changez simplement sa classification en le marquant comme "Spam" ou "Non-spam" dans la page Gérer les commentaires et TypePad AntiSpam apprendra de vos actions. Le service s\'améliorera au fur et à mesure des notifications de ses utilisateurs, usez donc d\'une attention particulière lorsque vous marquez un élément comme étant du "spam" ou "non-spam".',
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] for this blog, and [quant,_2,message,messages] system-wide.' => 'Depuis le début, TypePad AntiSpam a bloqué [quant,_1,message,messages] sur ce blog et [quant,_2,message,messages] sur tout le système.',
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] system-wide.' => 'Depuis le début, TypePad AntiSpam a bloqué [quant,_1,message,messages] sur tout le système.',
	'Failed to verify your TypePad AntiSpam API key: [_1]' => 'Erreur lors de la vérification de votre clé API TypePad AntiSpam : [_1]',
	'The TypePad AntiSpam API key provided is invalid.' => 'La clé API TypePad AntiSpam entrée n\'est pas valide.',

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'Le répertoire mt-static n\'a pas pu être trouvé. Veuillez configurer le \'StaticFilePath\' pour continuer.',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Impossible de créer le dossier [_1] - Vérifiez que votre dossier \'themes\' et en mode webserveur/écriture.',
	'Successfully applied new theme selection.' => 'Sélection de nouveau Thème appliquée avec succès.',
	'Invalid URL: [_1]' => 'URL inaccessible : [_1]',
	'(Untitled)' => '(Sans Titre)',

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a [_1] Style' => 'Sélectionner un style [_1]',
	'3-Columns, Wide, Thin, Thin' => '3-colonnes, large, fin, fin',
	'3-Columns, Thin, Wide, Thin' => '3-colonnes, fin, large, fin',
	'3-Columns, Thin, Thin, Wide' => '3 colonnes (fin, fin, large)',
	'2-Columns, Thin, Wide' => '2-colonnes, fin, large',
	'2-Columns, Wide, Thin' => '2-colonnes, large, fin',
	'2-Columns, Wide, Medium' => '2-Colonnes, Large, Moyen',
	'2-Columns, Medium, Wide' => '2 colonnes (moyen, large)',
	'1-Column, Wide, Bottom' => '1 colonne (large, pied)',
	'None available' => 'Aucun disponible',
	'Applying...' => 'Appliquer...',
	'Apply Design' => 'Appliquer l\'habillage',
	'Error applying theme: ' => 'Erreur en appliquant l\'habillage:',
	'The selected theme has been applied, but as you have changed the layout, you will need to republish your blog to apply the new layout.' => 'L\'habillage sélectionné a été appliqué. Vous devez republier votre blog afin d\'appliquer la nouvelle mise en page.',
	'The selected theme has been applied!' => 'L\'habillage sélectionné a été appliqué!',
	'Error loading themes! -- [_1]' => 'Erreur lors du chargement des habillages ! -- [_1]',
	'Stylesheet or Repository URL' => 'URL de la feuille de style ou du répertoire',
	'Stylesheet or Repository URL:' => 'URL de la feuille de style ou du répertoire:',
	'Download Styles' => 'Télécharger des habillages',
	'Current theme for your weblog' => 'Thème actuel de votre weblog',
	'Current Style' => 'Habillage actuel',
	'Locally saved themes' => 'Thèmes enregistrés localement',
	'Saved Styles' => 'Habillages enregistrés',
	'Default Styles' => 'Habillages par défaut',
	'Single themes from the web' => 'Thèmes uniques venant du web',
	'More Styles' => 'Plus d\'habillages',
	'Selected Design' => 'Habillage sélectionné',
	'Layout' => 'Mise en page',

## plugins/StyleCatcher/config.yaml
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks.' => 'StyleCatcher vous permet de parcourir facilement les styles et les appliquer ensuite à votre blog en quelques clics.',
	'MT 4 Style Library' => 'Bibliothèque MT4',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Une gamme de styles compatibles avec les gabarits MT4 par défaut',
	'Styles' => 'Habillages',

## plugins/spamlookup/lib/spamlookup.pm
	'Failed to resolve IP address for source URL [_1]' => 'Échec de la vérification de l\'adresse IP pour l\'URL source [_1]',
	'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Modération : l\IP du domaine ne correspond pas à l\'IP de ping pour l\'URL de la source [_1]; IP du domaine: [_2]; IP du ping: [_3]',
	'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'L\'IP du domaine ne correspond pas à l\'IP du ping pour l\'URL source [_1]; l\'IP du domaine: [_2]; IP du ping: [_3]',
	'No links are present in feedback' => 'Aucun lien n\'est présent dans le message',
	'Number of links exceed junk limit ([_1])' => 'Le nombre de liens a dépassé la limite de marquage comme spam ([_1])',
	'Number of links exceed moderation limit ([_1])' => 'Le nombre de liens a dépassé la limite de modération ([_1])',
	'Link was previously published (comment id [_1]).' => 'Le lien a été publié précédemment (id de commentaire [_1]).',
	'Link was previously published (TrackBack id [_1]).' => 'Le lien a été publié précédemment (id de trackback [_1]).',
	'E-mail was previously published (comment id [_1]).' => 'L\'email a été publié précédemment (id de commentaire [_1]).',
	'Word Filter match on \'[_1]\': \'[_2]\'.' => 'Le filtre de mot correspond sur \'[_1]\': \'[_2]\'.',
	'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'Modération pour filtre de mot sur \'[_1]\': \'[_2]\'.',
	'domain \'[_1]\' found on service [_2]' => 'domaine \'[_1]\' trouvé sur le service [_2]',
	'[_1] found on service [_2]' => '[_1] trouvé sur le service [_2]',

## plugins/spamlookup/tmpl/url_config.tmpl
	'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Les filtres de liens surveillent le nombre de liens hypertextes dans les messages entrants. Les messages avec beaucoup de liens peuvent être retenus pour modération ou marqués comme spam. Inversement, les messages qui ne contiennent pas de liens ou lient seulement vers des URLs publiées précédemment peuvent être notés positivement. (Activez cette option si vous êtes sûr que votre site est déjà dépourvu de spam.)',
	'Link Limits' => 'Limite de liens',
	'Credit feedback rating when no hyperlinks are present' => 'Créditer la notation du message quand aucun lien hypertexte n\'est présent',
	'Adjust scoring' => 'Ajuster la notation',
	'Score weight:' => 'Poids de la notation:',
	'Moderate when more than' => 'Modérer quand plus de',
	'link(s) are given' => 'liens sont présents',
	'Junk when more than' => 'Marquer comme spam quand plus de',
	'Link Memory' => 'Mémorisation des liens',
	'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Créditer la notation du message quand l\'élément &quot;URL&quot; du message a été publié précédemment',
	'Only applied when no other links are present in message of feedback.' => 'Appliquer seulement quand aucun autre lien n\'est présent quand le texte du message.',
	'Exclude URLs from comments published within last [_1] days.' => 'Exclure les URLs des commentaires publiés dans les [_1] derniers jours.',
	'Email Memory' => 'Mémorisation des emails',
	'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Créditer la notation du message lorsque des commentaires publiés précédemment contenaient l\'adresse &quot;email&quot;',
	'Exclude Email addresses from comments published within last [_1] days.' => 'Exclure les adresses email des commentaires publiés dans les [_1] derniers jours.',

## plugins/spamlookup/tmpl/lookup_config.tmpl
	'Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog\'s Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.' => 'Lookups surveille les adresses IP sources et les liens hypertextes de tous les commentaires/trackbacks entrants. Si un commentaire ou un trackback provient d\'une adresse IP en liste noire ou contient un domaine banni, il peut être retenu pour modération ou noté comme spam et placé dans le répertoire de spam. De plus, des vérifications avancées sur les données sources des trackbacks peuvent être réalisés.',
	'IP Address Lookups' => 'Vérifier une adresse IP',
	'Moderate feedback from blacklisted IP addresses' => 'Modérer les commentaires/trackbacks des adresses IP en liste noire',
	'Junk feedback from blacklisted IP addresses' => 'Marquer comme spam les commentaires/trackbacks des adresses IP en liste noire',
	'Less' => 'Moins',
	'More' => 'Plus',
	'block' => 'bloquer',
	'IP Blacklist Services' => 'Services de liste noire d\'IP',
	'Domain Name Lookups' => 'Vérifier un nom de domaine',
	'Moderate feedback containing blacklisted domains' => 'Modérer le contenu des messages contenant des domaines en liste noire',
	'Junk feedback containing blacklisted domains' => 'Marquer comme spam les messages contenant les domaines en liste noire',
	'Domain Blacklist Services' => 'Services de liste noire de domaines',
	'Advanced TrackBack Lookups' => 'Vérifications avancées des trackbacks',
	'Moderate TrackBacks from suspicious sources' => 'Modérer les trackbacks des sources suspectes',
	'Junk TrackBacks from suspicious sources' => 'Marquer comme spam les trackbacks des sources suspectes',
	'Lookup Whitelist' => 'Vérifier la liste blanche',
	'To prevent lookups for specific IP addresses or domains, list each on a line by itself.' => 'Pour ne pas effectuer de vérifications pour des noms de domaines ou addresses IP spécifiques, listez-les ligne par ligne.',

## plugins/spamlookup/tmpl/word_config.tmpl
	'Incomming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Les messages entrant peuvent être analysés à la recherche des mots-clés spécifiques, de noms de domaines, et de gabarits. Les messages correspondants peuvent être maintenus pour modération ou marqués comme spam. De plus, les notes de spam pour ces messages peuvent être personnalisés.',
	'Keywords to Moderate' => 'Mots-clés à modérer',
	'Keywords to Junk' => 'Mots-clés à marquer comme spam',

## plugins/spamlookup/spamlookup_words.pl
	'SpamLookup module for moderating and junking feedback using keyword filters.' => 'SpamLookup module pour modérer et marquer comme spam les messages en utilisant des filtres de mots-clés.',
	'SpamLookup Keyword Filter' => 'SpamLookup filtre de mots-clés',

## plugins/spamlookup/spamlookup.pl
	'SpamLookup module for using blacklist lookup services to filter feedback.' => 'Module SpamLookup pour utiliser les services de vérification de liste noire pour filtrer les commentaires.',
	'SpamLookup IP Lookup' => 'SpamLookup vérification des IP',
	'SpamLookup Domain Lookup' => 'SpamLookup vérification des domaines',
	'SpamLookup TrackBack Origin' => 'SpamLookup origine des trackbacks',
	'Despam Comments' => 'Commentaires non-spam',
	'Despam TrackBacks' => 'Trackbacks non-spam',
	'Despam' => 'Non-spam',

## plugins/spamlookup/spamlookup_urls.pl
	'SpamLookup module for junking and moderating feedback based on link filters.' => 'SpamLookup module pour marquer comme spam et modérer les messages basé sur les filtres de liens.',
	'SpamLookup Link Filter' => 'SpamLookup filtre de lien',
	'SpamLookup Link Memory' => 'SpamLookup mémorisation des liens',
	'SpamLookup Email Memory' => 'SpamLookup mémorisation des emails',

## plugins/MultiBlog/lib/MultiBlog/Tags.pm
	'MTMultiBlog tags cannot be nested.' => 'Les balises MTMultiBlog ne peuvent pas être imbriquées.',
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Valeur de l\'attribut "mode" inconnue : [_1]. Les valeurs valides sont "loop" et "context".',

## plugins/MultiBlog/lib/MultiBlog.pm
	'The include_blogs, exclude_blogs, blog_ids and blog_id attributes cannot be used together.' => 'Les attributs include_blogs, exclude_blogs, blog_ids et blog_id ne peuvent pas être utilisés ensemble.',
	'The value of the blog_id attribute must be a single blog ID.' => 'La valeur de l\'attribut blog_id doit être un ID de blog unique.',
	'The value for the include_blogs/exclude_blogs attributes must be one or more blog IDs, separated by commas.' => 'La valeur des attributs include_blogs/exclude_blogs doit être un ou plusieurs IDs de blogs, séparés par des virgules.',
	'Restoring MultiBlog rebuild trigger for blog #[_1]...' => 'Restauration du compteur de republication MutliBlog pour le blog #[_1]...',

## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
	'Create MultiBlog Trigger' => 'Créer un événement MultiBlog',

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'When' => 'Quand',
	'Weblog' => 'Blog',
	'Trigger' => 'Evénement',
	'Action' => 'Action',
	'Content Privacy' => 'Protection du contenu',
	'Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.' => 'Indiquez si les autres blogs de cette installation peuvent publier du contenu de ce blog. Ce réglage prend le dessus sur la règle d\'agrégation du système par défaut qui se trouve dans la configuration de MultiBlog pour tout le système.',
	'Use system default' => 'Utiliser la règle par défaut du système',
	'Allow' => 'Autoriser',
	'Disallow' => 'Interdire',
	'MTMultiBlog tag default arguments' => 'Arguments par défaut de la balise MTMultiBlog',
	'Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or \'all\' (include_blogs only) are acceptable values.' => 'Autorise l\'utilisation de la balise MTMultiBlog sans les attributs include_blogs/exclude_blogs. Les valeurs correctes sont une liste de BlogIDs séparés par des virgules, ou \'all\' (seulement pour include_blogs).',
	'Include blogs' => 'Inclure les blogs',
	'Exclude blogs' => 'Exclure les blogs',
	'Rebuild Triggers' => 'Événements de republication',
	'Create Rebuild Trigger' => 'Créer un événement de republication ',
	'You have not defined any rebuild triggers.' => 'Vous n\'avez défini aucun événement de republication.',

## plugins/MultiBlog/tmpl/system_config.tmpl
	'Default system aggregation policy' => 'Règle d\'agrégation du système par défaut',
	'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'L\'agrégation inter-blog sera activée par défaut. Les blogs individuels peuvent être configurés via les paramètres MultiBlog du blog en question, pour restreindre l\'accès à leur contenu par les autres blogs.',
	'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'L\'agrégation inter-blog sera désactivée par défaut. Les blogs individuels peuvent être configurés via les paramètres MultiBlog du blog en question, pour autoriser l\'accès à leur contenu par les autres blogs.',

## plugins/MultiBlog/multiblog.pl
	'MultiBlog allows you to publish content from other blogs and define publishing rules and access controls between them.' => 'Multiblog vous permet de publier du contenu d\'autres blogs et de définir des règles de publication et de droit d\'accès entre eux.',
	'MultiBlog' => 'MultiBlog',
	'Create Trigger' => 'Créer un nouvel événement',
	'Search Weblogs' => 'Rechercher les blogs',
	'When this' => 'quand ce',
	'* All blogs in this website' => '* Tous les blogs de ce site web',
	'Select to apply this trigger to all blogs in this website.' => 'Sélectionner pour appliquer cela à tous les blogs de ce site web.',
	'* All websites and blogs in this system' => '* Tous les sites web et blogs de ce systèmes',
	'Select to apply this trigger to all websites and blogs in this system.' => 'Sélectionner pour appliquer cela à tous les sites web et blog de ce système.',
	'saves an entry/page' => 'sauvegarde une note/page',
	'publishes an entry/page' => 'publie une note/page',
	'publishes a comment' => 'publie un commentaire',
	'publishes a TrackBack' => 'publie un trackback',
	'rebuild indexes.' => 'reconstruire les index.',
	'rebuild indexes and send pings.' => 'reconstruire les index et envoyer les pings.',

## plugins/Textile/textile2.pl
	'A humane web text generator.' => 'Générateur de texte user-friendly',
	'Textile 2' => 'Textile 2',

## plugins/WidgetManager/WidgetManager.pl
	'Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.' => 'Widget Manager version 1.1; Cette version est destinée à la mise à jour des données des versions plus anciennes de Widget Manager, délivré avec Movable Type. Aucune autre fonction n\'est incluse. Vous pouvez supprimer ce plugin après avoir installé/mis à jour Movable Type.',
	'Moving storage of Widget Manager [_2]...' => 'Déplacement de l\'emplacement du gestionnaire de wiget [_2]...',

## plugins/ActionStreams/blog_tmpl/sidebar.mtml

## plugins/ActionStreams/blog_tmpl/comment_listing.mtml

## plugins/ActionStreams/blog_tmpl/main_index.mtml

## plugins/ActionStreams/blog_tmpl/actions.mtml
	'Recent Actions' => 'Actions récentes',

## plugins/ActionStreams/blog_tmpl/archive.mtml

## plugins/ActionStreams/blog_tmpl/banner_footer.mtml

## plugins/ActionStreams/blog_tmpl/elsewhere.mtml
	'Find [_1] Elsewhere' => 'Trouver [_1] ailleurs',

## plugins/ActionStreams/lib/ActionStreams/Upgrade.pm
	'Updating classification of [_1] [_2] actions...' => 'Mise à jour de la classification des actions [_1] [_2]...',
	'Renaming "[_1]" data of [_2] [_3] actions...' => 'Renommage "[_1]" des données des actions [_1] [_2]...',

## plugins/ActionStreams/lib/ActionStreams/Worker.pm
	'No such author with ID [_1]' => 'Aucun auteur n\'a été trouvé avec l\'ID [_1]',

## plugins/ActionStreams/lib/ActionStreams/Plugin.pm
	'Other Profiles' => 'Autres profils',
	'Action Stream' => 'Action Stream',
	'Profiles' => 'Profiles',
	'Actions from the service [_1]' => 'Actions pour le service [_1]',
	'Actions that are shown' => 'Actions affichées',
	'Actions that are hidden' => 'Actions masquées',
	'No such event [_1]' => 'Aucun événement [_1] trouvé',
	'[_1] Profile' => 'Profil [_1]',

## plugins/ActionStreams/lib/ActionStreams/Tags.pm
	'No user [_1]' => 'Aucun utilisateur [_1]',

## plugins/ActionStreams/lib/ActionStreams/Event.pm
	'[_1] updating [_2] events for [_3]' => '[_1] mets à jour [_2] événements pour [_3]',
	'Error updating events for [_1]\'s [_2] stream (type [_3] ident [_4]): [_5]' => 'Erreur lors de la mise à jour des événements pour le flux [_2] de [_1] (type [_3] ident [_4]) : [_5]',
	'Could not load class [_1] for stream [_2] [_3]: [_4]' => 'Impossible de charger la classe [_1] pour le flux [_2] [_3] : [_4]',
	'No URL to fetch for [_1] results' => 'Aucune URL à joindre pour les résultats [_1]',
	'Could not fetch [_1]: [_2]' => 'Impossible de joindre [_1] : [_2]',
	'Aborted fetching [_1]: [_2]' => 'Opération abandonnée [_1] : [_2]',

## plugins/ActionStreams/tmpl/dialog_edit_profile.tmpl
	'Your user name or ID is required.' => 'Votre nom d\'utilisateur ou ID est requis.',
	'Edit a profile on a social networking or instant messaging service.' => 'Editer un profil sur un service de réseau social ou de messagerie instantanée.',
	'Service' => 'Service',
	'Enter your account on the selected service.' => 'Entrez votre compte sur le service sélectionné.',
	'For example:' => 'Par exemple :',
	'Action Streams' => 'Flux d\'actions',
	'Select the action streams to collect from the selected service.' => 'Sélectionner le flux d\'action pour collecter les données depuis les services sélectionnées.',
	'No streams are available for this service.' => 'Aucun flux n\'est disponible pour ce service.',

## plugins/ActionStreams/tmpl/other_profiles.tmpl
	'The selected profile was added.' => 'Le profil sélectionné a été ajouté.',
	'The selected profiles were removed.' => 'Les profils sélectionnés ont été retirés.',
	'The selected profiles were scanned for updates.' => 'La présence de nouveaux événements sur les profils sélectionnés a été effectuée.',
	'The changes to the profile have been saved.' => 'Les modifications sur le profil ont été enregistrées.',
	'Add Profile' => 'Ajouter un profil',
	'profile' => 'profil',
	'profiles' => 'profiles',
	'Delete selected profiles (x)' => 'Supprimer les profils sélectionnés (x)',
	'to update' => 'à mettre à jour',
	'Scan now for new actions' => 'Vérifier la présence de nouveaux événements',
	'Update Now' => 'Mettre à jour maintenant',
	'No profiles were found.' => 'Aucun profil n\'a été trouvé.',
	'external_link_target' => 'external_link_target',
	'View Profile' => 'Voir le profil',

## plugins/ActionStreams/tmpl/dialog_add_profile.tmpl
	'Add a profile on a social networking or instant messaging service.' => 'Ajouter un profil sur un service de réseau social ou de messagerie instantanée.',
	'Select a service where you already have an account.' => 'Sélectionnez un service où vous avez déjà un compte.',
	'Add Profile (s)' => 'Ajouter le Profil (s)',

## plugins/ActionStreams/tmpl/list_profileevent.tmpl
	'The selected events were deleted.' => 'Les événements sélectionnés ont été supprimés.',
	'The selected events were hidden.' => 'Les événements sélectionnés ont été masqués.',
	'The selected events were shown.' => 'Les événements sélectionnés ont été affichés.',
	'All action stream events were hidden.' => 'Tous les événements du flux d\'activité ont été masqués.',
	'All action stream events were shown.' => 'Tous les événements du flux d\'activité ont été affichés.',
	'event' => 'événement',
	'events' => 'événéments',
	'Hide selected events (h)' => 'Masquer les événements sélectionnés (h)',
	'Hide' => 'Masquer',
	'Show selected events (h)' => 'Afficher les événements sélectionnés (h)',
	'Show' => 'Afficher',
	'All stream actions' => 'Tous les flux d\'actions',
	'Show only actions where' => 'Afficher uniquement les actions où',
	'service' => 'le service est',
	'visibility' => 'la visibilité est',
	'hidden' => 'masqué',
	'shown' => 'affiché',
	'No events could be found.' => 'Aucun événement n\'a été trouvé.',
	'Event' => 'Événement',
	'Shown' => 'Affiché',
	'Hidden' => 'Masqué',
	'View action link' => 'Voir le lien de l\'action',

## plugins/ActionStreams/tmpl/widget_recent.mtml
	'Your Recent Actions' => 'Votre activité récente',
	'blog this' => 'bloguer ceci',
	'No actions could be found.' => 'Aucune action trouvée.',

## plugins/ActionStreams/tmpl/blog_config_template.tmpl
	'Rebuild Indexes' => 'Republier les index',
	'If selected, this blog\'s indexes will be rebuilt when new action stream events are discovered.' => 'Si sélectionner, les index des blogs seront republiés lorsque de nouveaux événements du flux d\'activité seront découverts.',
	'Enable rebuilding' => 'Activer la republication',

## plugins/ActionStreams/streams.yaml
	'Currently Playing' => 'En train de jouer',
	'The games in your collection you\'re currently playing' => 'Les jeux de votre collection auxquels vous jouez en ce moment',
	'Comments you have made on the web' => 'Commentaires que vous avez écrits sur le web',
	'Colors' => 'Couleurs',
	'Colors you saved' => 'Couleurs que vous avez sauvegardées',
	'Palettes' => 'Palettes',
	'Palettes you saved' => 'Palettes que vous avez sauvegardées',
	'Patterns' => 'Motifs',
	'Patterns you saved' => 'Motifs que vous avez sauvegardés',
	'Favorite Palettes' => 'Palettes favorites',
	'Palettes you saved as favorites' => 'Palettes que vous avez sauvegardées comme favorites',
	'Reviews' => 'Critiques',
	'Your wine reviews' => 'Vos critiques de vins',
	'Cellar' => 'Cellier',
	'Wines you own' => 'Vins que vous possédez',
	'Shopping List' => 'Liste de courses',
	'Wines you want to buy' => 'Vins que vous voulez acheter',
	'Links' => 'Liens',
	'Your public links' => 'Vos liens publics',
	'Dugg' => 'Dugg',
	'Links you dugg' => 'Liens postés sur Digg',
	'Submissions' => 'Soumissions',
	'Links you submitted' => 'Liens que vous avez soumis',
	'Found' => 'Trouvé',
	'Photos you found' => 'Photos que vous avez trouvées',
	'Favorites' => 'Favorites',
	'Photos you marked as favorites' => 'Photos que vous avez marquées comme favorites',
	'Photos' => 'Photos',
	'Photos you posted' => 'Photos que vous avez postées',
	'Likes' => 'Likes',
	'Things from your friends that you "like"' => 'Infos de vos amis que vous avez aimées',
	'Leaderboard scores' => 'Scores',
	'Your high scores in games with leaderboards' => 'Vos meilleurs scores dans les jeux avec championnat',
	'Blog posts about your search term' => 'Notes du blog à propos de votre recherche',
	'Stories' => 'Articles',
	'News Stories matching your search' => 'Nouveaux articles correspondant à votre recherche',
	'To read' => 'A lire',
	'Books on your "to-read" shelf' => 'Livres dans votre liste "à lire"',
	'Reading' => 'En cours de lecture',
	'Books on your "currently-reading" shelf' => 'Livres dans votre liste "en cours de lecture"',
	'Read' => 'Lus',
	'Books on your "read" shelf' => 'Livres dans votre liste "lus"',
	'Shared' => 'Partagés',
	'Your shared items' => 'Vos élémens partagés',
	'Deliveries' => 'Livrés',
	'Icon sets you were delivered' => 'Sets d\'icones livrées',
	'Notices' => 'Notices',
	'Notices you posted' => 'Notices postées',
	'Intas' => 'Intas',
	'Links you saved' => 'Liens sauvegardés',
	'Photos you posted that were approved' => 'Photos postées et approuvées',
	'Recent events' => 'Evénements récents',
	'Events from your recent events feed' => 'Evénements de votre flux des événements récents',
	'Apps you use' => 'Applications que vous utilisez',
	'The applications you saved as ones you use' => 'Les applications que vous avez marquées comme utilisées',
	'Videos you saved as watched' => 'Videos que vous avez saugardées comme regardées',
	'Jaikus' => 'Jaikus',
	'Jaikus you posted' => 'Jaikus que vous avez postés',
	'Games you saved as favorites' => 'Jeux que vous avez sauvegardés comme favoris',
	'Achievements' => 'Réalisations',
	'Achievements you won' => 'Réalisations que vous avez atteintes',
	'Tracks' => 'Morceaux',
	'Songs you recently listened to (High spam potential!)' => 'Chansons que vous avez écoutées récemment (spam potentiel!)',
	'Loved Tracks' => 'Morceaux aimés',
	'Songs you marked as "loved"' => 'Chansons que vous avez marquées comme "aimées"',
	'Journal Entries' => 'Notes du journal',
	'Your recent journal entries' => 'Les notes récentes de votre journal',
	'Events' => 'événéments',
	'The events you said you\'ll be attending' => 'Les événements auquels vous allez assister',
	'Your public posts to your journal' => 'Les notes publiques sur votre journal',
	'Queue' => 'Liste d\'attente',
	'Movies you added to your rental queue' => 'Films que vous avez ajoutés à votre liste d\'attente',
	'Recent Movies' => 'Films récents',
	'Recent Rental Activity' => 'Films empreintés récemment',
	'Kudos' => 'Kudos',
	'Kudos you have received' => 'Kudos que vous avez reçus',
	'Favorite Songs' => 'Chansons favorites',
	'Songs you marked as favorites' => 'Chansons que vous avez marquées comme favorites',
	'Favorite Artists' => 'Artistes favoris',
	'Artists you marked as favorites' => 'Artistes que vous avez marqués comme favoris',
	'Stations' => 'Stations',
	'Radio stations you added' => 'Stations de radio que vous avez ajoutées',
	'List' => 'Liste',
	'Things you put in your list' => 'Choses que vous mettez sur votre liste',
	'Notes' => 'Notes',
	'Your public notes' => 'Vos notes publiques',
	'Comments you posted' => 'Commentaires que vous avez postés',
	'Articles you submitted' => 'Articles que vous avez soumis',
	'Articles you liked (your votes must be public)' => 'Articles que vous avez aimés (vos votes doivent être publiques)',
	'Dislikes' => 'Pas aimés',
	'Articles you disliked (your votes must be public)' => 'Articles que vous n\'avez pas aimés (vos votes doivent être publiques)',
	'Slideshows you saved as favorites' => 'Diaparamas que vous avez marqués comme favoris',
	'Slideshows' => 'Diaporamas',
	'Slideshows you posted' => 'Diaporamas que vous avez postés',
	'Your achievements for achievement-enabled games' => 'Vos résultats pour les jeux avec des objectifs',
	'Stuff' => 'Trucs',
	'Things you posted' => 'Choses que vous avez postées',
	'Tweets' => 'Tweets',
	'Your public tweets' => 'Vos tweets publiques',
	'Public tweets you saved as favorites' => 'Tweets publiques que vous avez sauvegardés comme favoris',
	'Tweets about your search term' => 'Tweets contenant votre terme de recherche',
	'Saved' => 'Sauvegardés',
	'Things you saved as favorites' => 'Choses que vous avez sauvegardées comme favorites',
	'Events you are watching or attending' => 'Evénements que vous regardez ou auxquels vous assistez',
	'Videos you posted' => 'Videos que vous avez postées',
	'Videos you liked' => 'Videos que vous avez aimées',
	'Public assets you saved as favorites' => 'Assets publiques que vous avez sauvegardées comme favorites',
	'Your public photos in your Vox library' => 'Vos photos publiques dans votre librairie Vox',
	'Your public posts to your Vox' => 'Vos notes publiques dans votre Vox',
	'The posts available from the website\'s feed' => 'Les notes publiques disponibles dans le flux du site',
	'Wists' => 'Wists',
	'Stuff you saved' => 'Choses que vous avez sauvegardées',
	'Gamerscore' => 'Score du joueur',
	'Notes when your gamerscore passes an even number' => 'Notes quand votre score dépasse un nombre pair',
	'Places you reviewed' => 'Places que vous avez critiquées',
	'Videos you saved as favorites' => 'Videos que vous avez sauvegardées comme favorites',

## plugins/ActionStreams/services.yaml
	'1up.com' => '1up.com',
	'43Things' => '43Things',
	'Screen name' => 'Pseudonyme',
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
	'User ID' => 'ID d\'utilisateur',
	'You can find your Facebook userid within your profile URL.  For example, http://www.facebook.com/profile.php?id=24400320.' => 'Vous pouvez trouver votre userid Facebook dans l\'URL de votre profil. Par exemple, http://www.facebook.com/profile.php?id=24400320.',
	'FFFFOUND!' => 'FFFFOUND!',
	'Flickr' => 'Flickr',
	'Enter your Flickr userid which contains "@" in it, e.g. 36381329@N00.  Flickr userid is NOT the username in the URL of your photostream.' => 'Saisissez votre userid Flickr',
	'FriendFeed' => 'FriendFeed',
	'Gametap' => 'Gametap',
	'Google Blogs' => 'Google Blogs',
	'Search term' => 'Rerchercher le terme',
	'Google News' => 'Google News',
	'Search for' => 'Rechercher',
	'Goodreads' => 'Goodreads',
	'You can find your Goodreads userid within your profile URL. For example, http://www.goodreads.com/user/show/123456.' => 'Vous pouvez trouver votre userid Giidreads dans votre URL de profil. Par exemple, http://www.goodreads.com/user/show/123456.',
	'Google Reader' => 'Google Reader',
	'Sharing ID' => 'ID partagé',
	'Hi5' => 'Hi5',
	'IconBuffet' => 'IconBuffet',
	'ICQ' => 'ICQ',
	'UIN' => 'UIN',
	'Identi.ca' => 'Identi.ca',
	'Iminta' => 'Iminta',
	'iStockPhoto' => 'iStockPhoto',
	'You can find your istockphoto userid within your profile URL.  For example, http://www.istockphoto.com/user_view.php?id=1234567.' => 'Vous pouvez trouver votre userid istockphoto dans l\'URL de votre profil. Par exemple, http://www.istockphoto.com/user_view.php?id=1234567.',
	'IUseThis' => 'IUseThis',
	'iwatchthis' => 'iwatchthis',
	'Jabber' => 'Jabber',
	'Jabber ID' => 'ID Jabber',
	'Jaiku' => 'Jaiku',
	'Kongregate' => 'Kongregate',
	'Last.fm' => 'Last.fm',
	'LinkedIn' => 'LinkedIn',
	'Profile URL' => 'URL du profil',
	'Ma.gnolia' => 'Ma.gnolia',
	'MOG' => 'MOG',
	'MSN Messenger\'' => 'MSN Messenger\'',
	'Multiply' => 'Multiply',
	'MySpace' => 'MySpace',
	'Netflix' => 'Netflix',
	'Netflix RSS ID' => 'ID Netflix RSS',
	'To find your Netflix RSS ID, click "RSS" at the bottom of any page on the Netflix site, then copy and paste in your "Queue" link.' => 'Pour trouver votre RSS ID Netflix, cliquez sur "RSS" en bas de n\'importe quelle page sur le site de Netflix, puis copiez-collez le votre lien "Queue".',
	'Netvibes' => 'Netvibes',
	'Newsvine' => 'Newsvine',
	'Ning' => 'Ning',
	'Social Network URL' => 'URL du réseau social',
	'Ohloh' => 'Ohloh',
	'Orkut' => 'Orkut',
	'You can find your orkut uid within your profile URL. For example, http://www.orkut.com/Main#Profile.aspx?rl=ls&uid=1234567890123456789' => 'Vous pouvez trouver votre userid orkut dans l\'URL de votre profil. Par exemple, http://www.orkut.com/Main#Profile.aspx?rl=ls&uid=1234567890123456789',
	'Pandora' => 'Pandora',
	'Picasa Web Albums' => 'Picasa Web Albums',
	'p0pulist' => 'p0pulist',
	'You can find your p0pulist user id within your Hot List URL. for example, http://p0pulist.com/list/hot_list/10000' => 'Vous pouvez trouver votre user id p0pulist dans votre URL Hot List. Par exemple, http://p0pulist.com/list/hot_list/10000',
	'Pownce' => 'Pownce',
	'Reddit' => 'Reddit',
	'Skype' => 'Skype',
	'SlideShare' => 'SlideShare',
	'Smugmug' => 'Smugmug',
	'SonicLiving' => 'SonicLiving',
	'You can find your SonicLiving userid within your share&subscribe URL. For example, http://sonicliving.com/user/12345/feeds' => 'Vous pouvez trouver votre userid SonicLiving dans votre URL share&subscribe. Par exemple, http://sonicliving.com/user/12345/feeds',
	'Steam' => 'Steam',
	'StumbleUpon' => 'StumbleUpon',
	'Tabblo' => 'Tabblo',
	'Blank should be replaced by positive sign (+).' => 'Les espaces doivent être remplacés par un signe plus (+)',
	'Tribe' => 'Tribe',
	'You can find your tribe userid within your profile URL.  For example, http://people.tribe.net/dcdc61ed-696a-40b5-80c1-e9a9809a726a.' => 'Vous pouvez trouver votre userid tribe dans l\'URL de votre profil. Par exemple, http://people.tribe.net/dcdc61ed-696a-40b5-80c1-e9a9809a726a.',
	'Tumblr' => 'Tumblr',
	'Twitter' => 'Twitter',
	'TwitterSearch' => 'TwitterSearch',
	'Uncrate' => 'Uncrate',
	'Upcoming' => 'Upcoming',
	'Viddler' => 'Viddler',
	'Vimeo' => 'Vimeo',
	'Virb' => 'Virb',
	'You can find your VIRB userid within your home URL.  For example, http://www.virb.com/backend/2756504321310091/your_home.' => 'Vous pouvez trouver votre userid VIRB dans l\'URL d\'accueil. Par exemple, http://www.virb.com/backend/2756504321310091/your_home.',
	'Vox name' => 'Nom Vox',
	'Xbox Live\'' => 'Xbox Live\'',
	'Gamertag' => 'Gamertag',
	'Yahoo! Messenger\'' => 'Yahoo! Messenger\'',
	'Yelp' => 'Yelp',
	'YouTube' => 'YouTube',
	'Zooomr' => 'Zooomr',

## plugins/ActionStreams/config.yaml
	'Manages authors\' accounts and actions on sites elsewhere around the web' => 'Gérer les comptes et les actions des utilisatreurs sur les sites ailleurs sur le web',
	'Are you sure you want to hide EVERY event in EVERY action stream?' => 'Êtes-vous sûr de vouloir masquer TOUS les événement dans TOUS les flux d\'actions ?',
	'Are you sure you want to show EVERY event in EVERY action stream?' => 'Êtes-vous sûr de vouloir afficher TOUS les événement dans TOUS les flux d\'actions ?',
	'Deleted events that are still available from the remote service will be added back in the next scan. Only events that are no longer available from your profile will remain deleted. Are you sure you want to delete the selected event(s)?' => 'Les événements supprimés qui sont toujours disponibles sur le service distant seront ajoutés à nouveau dans le prochain scan. Seuls les événements qui ne sont plus disponibles dans votre profil resteront supprimés. Etes-vous sûr de vouloir supprimer les événements sélectionnés?',
	'Hide All' => 'Cacher tout',
	'Show All' => 'Tout afficher',
	'Poll for new events' => 'Emplacement pour les nouveaux événements',
	'Update Events' => 'Mettre à jour les événements',
	'Main Index (Recent Actions)' => 'Index principal (Actions récentes)',
	'Action Archive' => 'Archive des actions',
	'Feed - Recent Activity' => 'Flux - Activité récente',
	'Find Authors Elsewhere' => 'Trouver les auteurs ailleurs',
	'Enabling default action streams for selected profiles...' => 'Activer les flux d\'actions par défaut des profils sélectionnés...',

## plugins/CommunityActionStreams/config.yaml
	'Action streams for community events: add entry, add comment, add favorite, follow user.' => 'Flux d\'actions pour les événements de la communauté : nouvelle note, nouveau commentaire, nouveau favori, suivi d\'un utilisateur.',

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm

## plugins/FacebookCommenters/tmpl/blog_config_template.tmpl
	'Facebook Application Key' => 'Clé Application Facebook',
	'The key for the Facebook application associated with your blog.' => 'La clé pour l\'application Facebook associée à votre blog.',
	'Edit Facebook App' => 'Éditer l\'application Facebook',
	'Create Facebook App' => 'Créer une application Facebook',
	'Facebook Application Secret' => 'Secret Application Facebook',
	'The secret for the Facebook application associated with your blog.' => 'Le secret pour l\'application Facebook associée à votre blog.',

## plugins/FacebookCommenters/plugin.pl
	'Provides commenter registration through Facebook Connect.' => 'Permet l\'enregistrement des auteurs de commentaires via Facebook Connect',
	'Set up Facebook Commenters plugin' => 'Configurer le plugin Facebook Commenters',
	'{*actor*} commented on the blog post <a href="{*post_url*}">{*post_title*}</a>.' => '{*actor*} a commenté la note <a href="{*post_url*}">{*post_title*}</a>.',
	'Could not register story template with Facebook: [_1]. Did you enter the correct application secret?' => 'Impossible d\'enregistrer le modèle d\'histoire avec Facebook : [_1]. Avez-vous correctement entré le secret de l\'application ?',
	'Could not register story template with Facebook: [_1]' => 'Impossible d\'enregistrer le modèle d\'histoire avec Facebook : [_1].',
	'Facebook' => 'Facebook',

## plugins/Motion/lib/Motion/Search.pm
	'This module works with MT::App::Search.' => 'Ce module fonctionne avec MT::App::Search.',
	'Specify the blog_id of a blog that has Motion template set.' => 'Indique le blog_id d\'un blog ayant un jeu de gabarits Motion.',
	'Error loading template: [_1]' => 'Erreur lors du chargement d\'un gabarit : [_1]',

## plugins/Motion/tmpl/edit_linkpost.tmpl

## plugins/Motion/tmpl/edit_videopost.tmpl
	'Embed code' => 'Code externe',

## plugins/Motion/templates/Motion/widget_user_archives.mtml
	'Recenty entries from [_1]' => 'Notes récentes de [_1]',

## plugins/Motion/templates/Motion/widget_search.mtml

## plugins/Motion/templates/Motion/banner_header.mtml
	'Home' => 'Accueil',

## plugins/Motion/templates/Motion/search_results.mtml

## plugins/Motion/templates/Motion/widget_popular_entries.mtml
	'Popular Entries' => 'Notes populaires',
	'posted by <a href="[_1]">[_2]</a> on [_3]' => 'rédigé par <a href="[_1]">[_2]</a> le [_3]',

## plugins/Motion/templates/Motion/widget_followers.mtml
	'Followers' => 'Suiveurs',
	'Not being followed' => 'N\'est pas suivi',

## plugins/Motion/templates/Motion/entry_response.mtml
	'Single Entry' => 'Note simple',

## plugins/Motion/templates/Motion/comment_response.mtml
	'<strong>Bummer....</strong> [_1]' => '<strong>Zut...</strong> [_1]',

## plugins/Motion/templates/Motion/widget_about_ssite.mtml
	'About' => 'A propos de',
	'The Motion Template Set is a great example of the type of site you can build with Movable Type.' => 'Le jeu de gabarits Motion est un bel exemple du type de site que vous pouvez concevoir avec Movable Type.',

## plugins/Motion/templates/Motion/register.mtml
	'Messaging' => 'Messagerie',
	'Form Field' => 'Champ de formulaire',
	'Enter a password for yourself.' => 'Choisissez un mot de passe.',
	'The URL of your website.' => 'L\'URL de votre site.',

## plugins/Motion/templates/Motion/comment_detail.mtml

## plugins/Motion/templates/Motion/member_index.mtml

## plugins/Motion/templates/Motion/single_entry.mtml
	'By [_1] <span class="date">on [_2]</span>' => 'Par [_1] <span class="date">sur [_2]</span>',
	'Unpublish this post' => 'Mettre cette note hors-ligne',
	'1 <span>Comment</span>' => '1 <span>commentaire</span>',
	'# <span>Comments</span>' => '# <span>commentaires</span>',
	'0 <span>Comments</span>' => '0 <span>commentaires</span>',
	'1 <span>TrackBack</span>' => '1 <span>trackback</span>',
	'# <span>TrackBacks</span>' => '# <span>trackbacks</span>',
	'0 <span>TrackBacks</span>' => '0 <span>trackbacks</span>',
	'Note: This post is being held for approval by the site owner.' => 'Note : cette note est en attente d\'acceptation par le propriétaire du site.',
	'Photo' => 'Photo',
	'<a href="[_1]">Most recent comment by <strong>[_2]</strong> on [_3]</a>' => '<a href="[_1]">Commentaires les plus récents par <strong>[_2]</strong> sur [_3]</a>',
	'Posted to [_1]' => 'Publié sur [_1]',
	'[_1] posted [_2] on [_3]' => '[_1] a publié [_2] sur [_3]',

## plugins/Motion/templates/Motion/widget_tag_cloud.mtml

## plugins/Motion/templates/Motion/password_reset.mtml
	'Reset Password' => 'Initialiser le mot de passe',

## plugins/Motion/templates/Motion/form_field.mtml
	'(Optional)' => '(Optionnel)',

## plugins/Motion/templates/Motion/javascript.mtml
	'Please select a file to post.' => 'Veuillez sélectionner un fichier à publier.',
	'You selected an unsupported file type.' => 'Vous avez sélectionné un fichier de type non supporté.',

## plugins/Motion/templates/Motion/trackbacks.mtml

## plugins/Motion/templates/Motion/archive_index.mtml

## plugins/Motion/templates/Motion/new_password.mtml
	'Choose New Password' => 'Choisissez un nouveau mot de passe',

## plugins/Motion/templates/Motion/entry_listing_author.mtml
	'Archived Entries from [_1]' => 'Notes archivés de [_1]',
	'Recent Entries from [_1]' => 'Notes récentes de [_1]',

## plugins/Motion/templates/Motion/widget_categories.mtml

## plugins/Motion/templates/Motion/dynamic_error.mtml

## plugins/Motion/templates/Motion/widget_main_column_registration.mtml
	'<a href="javascript:void(0)" onclick="[_1]">Sign In</a>' => '<a href="javascript:void(0)" onclick="[_1]">Identifiez-vous</a>',
	'Not a member? <a href="[_1]">Register</a>' => 'Pas encore membre? <a href="[_1]">Enregistrez-vous</a>',
	'(or <a href="javascript:void(0)" onclick="[_1]">Sign In</a>)' => '(ou <a href="javascript:void(0)" onclick="[_1]">Identifiez-vous</a>)',
	'No posting privileges.' => 'Pas les droits nécessaires pour publier.',

## plugins/Motion/templates/Motion/widget_elsewhere.mtml
	'Are you sure you want to remove the [_1] from your profile?' => 'Êtes-vous sûr de vouloir retirer [_1] de votre profil ?',
	'Your user name or ID is required.' => 'Votre nom d\'utilisateur ou ID est requis.',
	'Add a Service' => 'Ajouter un service',
	'Service' => 'Service',
	'Select a service...' => 'Sélectionnez un service...',
	'Your Other Profiles' => 'Vos autres profils',
	'Find [_1] Elsewhere' => 'Trouver [_1] ailleurs',
	'Remove service' => 'Retirer le service',

## plugins/Motion/templates/Motion/widget_main_column_posting_form_text.mtml
	'QuickPost' => 'QuickPost',
	'Content' => 'Contenu',
	'more options' => 'Plus d\'options',
	'Post' => 'Publier',

## plugins/Motion/templates/Motion/comment_preview.mtml

## plugins/Motion/templates/Motion/actions_local.mtml
	'[_1] commented on [_2]' => '[_1] a commenté sur [_2]',
	'[_1] favorited [_2]' => '[_1] apprécie [_2]',
	'No recent actions.' => 'Plus d\'actions récentes.',

## plugins/Motion/templates/Motion/main_index.mtml
	'Main Column Content' => 'Contenu de la colonne principale',

## plugins/Motion/templates/Motion/page.mtml

## plugins/Motion/templates/Motion/entry_summary.mtml

## plugins/Motion/templates/Motion/widget_recent_comments.mtml
	'<p>[_3]...</p><div class="comment-attribution">[_4]<br /><a href="[_1]">[_2]</a></div>' => '<p>[_3]...</p><div class="comment-attribution">[_4]<br /><a href="[_1]">[_2]</a></div>',

## plugins/Motion/templates/Motion/widget_monthly_archives.mtml

## plugins/Motion/templates/Motion/profile_feed.mtml
	'Posted [_1] to [_2]' => 'A posté [_1] sur [_2]',
	'Commented on [_1] in [_2]' => 'A commenté sur [_1] dans [_2]',
	'followed [_1]' => 'a suivi [_1]',

## plugins/Motion/templates/Motion/widget_main_column_posting_form.mtml
	'Text post' => 'Texte',
	'Photo post' => 'Photo',
	'Link post' => 'Lien',
	'Embed post' => 'Élément embarqué',
	'Audio post' => 'Son',
	'URL of web page' => 'URL d\'une page Web',
	'Select photo file' => 'Sélectionner une image ou photo',
	'Only GIF, JPEG and PNG image files are supported.' => 'Les types de fichiers supportés sont GIF, JPEG, et PNG.',
	'Select audio file' => 'Sélectionner un fichier sonore',
	'Only MP3 audio files are supported.' => 'Le fichier doit être au format MP3.',
	'Paste embed code' => 'Copiez le code de l\'élément embarqué',

## plugins/Motion/templates/Motion/entry_listing_category.mtml

## plugins/Motion/templates/Motion/widget_signin.mtml
	'You are signed in as <a href="[_1]">[_2]</a>' => 'Vous êtes identifié(e) comme étant <a href="[_1]">[_2]</a>',
	'You are signed in as [_1]' => 'Vous êtes identifié(e) comme étant [_1]',
	'Edit profile' => 'Editer le profil',

## plugins/Motion/templates/Motion/widget_fans.mtml
	'Fans' => 'Fans',

## plugins/Motion/templates/Motion/comment_listing.mtml

## plugins/Motion/templates/Motion/register_confirmation.mtml
	'Authentication Email Sent' => 'Email d\'authentification envoyé',
	'Profile Created' => 'Profil créé',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Retourner à la page initiale</a>',

## plugins/Motion/templates/Motion/entry.mtml

## plugins/Motion/templates/Motion/widget_gallery.mtml
	'Recent Photos' => 'Photos récentes',

## plugins/Motion/templates/Motion/sidebar.mtml
	'Profile Widgets' => 'Widgets de profils',
	'Main Index Widgets' => 'Widgets de l\'index principal',
	'Archive Widgets' => 'Widgets d\'archive',
	'Entry Widgets' => 'Widgets de notes',
	'Default Widgets' => 'Widgets par défaut',

## plugins/Motion/templates/Motion/user_profile_edit.mtml
	'Go <a href="[_1]">back to the previous page</a> or <a href="[_2]">view your profile</a>.' => 'Retourner à  <a href="[_1]">la page précédente</a> ou <a href="[_2]">voir votre profil</a>.',

## plugins/Motion/templates/Motion/widget_recent_entries.mtml
	'posted by [_1] on [_2]' => 'publié par [_1] sur [_2]',

## plugins/Motion/templates/Motion/banner_footer.mtml
	'Footer Widgets' => 'Widgets de pieds',

## plugins/Motion/templates/Motion/entry_listing_monthly.mtml

## plugins/Motion/templates/Motion/widget_main_column_actions.mtml
	'Actions (Local)' => 'Actions (locales)',

## plugins/Motion/templates/Motion/comments.mtml
	'what will you say?' => 'que direz-vous ?',
	'[_1] [_2]in reply to comment from [_3][_4]' => '[_1] [_2] en réponse au commentaire de [_3][_4]',
	'Write a comment...' => 'Rédigez un commentaire ...',

## plugins/Motion/templates/Motion/login_form.mtml
	'Not a member?&nbsp;&nbsp;<a href="[_1]">Sign Up</a>!' => 'Pas encore membre?&nbsp;&nbsp;<a href="[_1]">Enregistrez-vous</a>!',
	'Forgot?' => 'Oublié ?',

## plugins/Motion/templates/Motion/widget_members.mtml

## plugins/Motion/templates/Motion/user_profile.mtml
	'Recent Actions from [_1]' => 'Actions récentes de [_1]',
	'Responses to Comments from [_1]' => 'Réponses aux commentaires de [_1]',
	'You are following [_1].' => 'Vous suivez [_1]',
	'Unfollow' => 'Ne plus suivre',
	'Follow' => 'Suivre',
	'Profile Data' => 'Données du profil',
	'More Entries by [_1]' => 'Plus de notes par [_1]',
	'Recent Actions' => 'Actions récentes',
	'_PROFILE_COMMENT_LENGTH' => '10',
	'Comment Threads' => 'Fils de discussion',
	'[_1] commented on ' => '[_1] a commenté sur',
	'No responses to comments.' => 'Pas de réponse aux commentaires.',

## plugins/Motion/templates/Motion/actions.mtml
	'[_1] is now following [_2]' => '[_1] suit désormais [_2]',
	'[_1] favorited [_2] on [_3]' => '[_1] a ajouté [_2] de [_3] dans ses favoris',

## plugins/Motion/templates/Motion/motion_js.mtml
	'Add userpic' => 'Ajouter un avatar',

## plugins/Motion/templates/Motion/widget_powered_by.mtml

## plugins/Motion/templates/Motion/widget_following.mtml
	'Following' => 'Suit',
	'Not following anyone' => 'Ne suit personne',

## plugins/Motion/config.yaml
	'A Movable Type theme with structured entries and action streams.' => 'Un thème Movable Type avec des notes structurées et des flux d\'actions.',
	'Adjusting field types for embed custom fields...' => 'Ajustement des types de champs pour les champs personnalisés d\'éléments embarqués...',
	'Updating favoriting namespace for Motion...' => 'Mise à jour des espaces de nom favoris pour Motion...',
	'Motion Themes' => 'Thèmes Motion',
	'Themes for Motion template set' => 'Thèmes pour le jeu de gabarits Motion',
	'Motion' => 'Motion',
	'Post Type' => 'Type de note',
	'Embed Object' => 'Élément externe',
	'MT JavaScript' => 'Javascript MT',
	'Motion MT JavaScript' => 'JavaScript Motion MT',
	'Motion JavaScript' => 'JavaScript Motion',
	'Entry Listing: Monthly' => 'Liste des notes par mois',
	'Entry Listing: Category' => 'Liste des notes par catégorie',
	'|' => '|',
	'Entry Response' => 'Réponse à la note',
	'Profile View' => 'Vue du profil',
	'Profile Edit Form' => 'Formulaire de modification du profil',
	'Profile Error' => 'Erreur de profil',
	'Profile Feed' => 'Flux du profil',
	'Login Form' => 'Formulaire d\'identification',
	'Register Confirmation' => 'Confirmation d\'inscription',
	'New Password Reset Form' => 'Nouveau formulaire de réinitialisation du mot de passe',
	'New Password Form' => 'Nouveau formulaire de mot de passe',
	'User Profile' => 'Profil de l\'utilisateur',
	'About Pages' => 'À propos des pages',
	'About Site' => 'À propos du site',
	'Gallery' => 'Galerie',
	'Main Column Actions' => 'Actions de la colonne principale',
	'Main Column Posting Form (All Media)' => 'Formulaire de publication (Tous médias) de la colonne principale',
	'Main Column Posting Form (Text Only, Like Twitter)' => 'Formulaire de publication (Texte uniquement, comme Twitter) de la colonne principale',
	'Main Column Registration' => 'Inscription depuis la colonne principale',
	'Elsewhere' => 'Ailleurs',
	'User Archives' => 'Archives de l\'utilisateur',
	'Blogroll' => 'Blogs préférés',
	'Feeds' => 'Flux',

## plugins/feeds-app-lite/lib/MT/Feeds/Lite.pm
	'An error occurred processing [_1]. The previous version of the feed was used. A HTTP status of [_2] was returned.' => 'Une erreur s\'est produite en traitant [_1]. La version précédente du flux a été utilisée. Un statut HTTP de [_2] a été retourné.',
	'An error occurred processing [_1]. A previous version of the feed was not available.A HTTP status of [_2] was returned.' => 'Une erreur s\'est produite en traitant [_1]. Une version précédente du flux n\'est pas disponible. Un statut HTTP de [_2] a été renvoyé.',

## plugins/feeds-app-lite/lib/MT/Feeds/Tags.pm
	'\'[_1]\' is a required argument of [_2]' => '\'[_1]\' est un argument nécessaire de [_2]',
	'MT[_1] was not used in the proper context.' => 'Le [_1] MT n\'a pas été utilisé dans le bon contexte.',

## plugins/feeds-app-lite/tmpl/config.tmpl
	'Feeds.App Lite Widget Creator' => 'Créateur de widget de flux',
	'Configure feed widget settings' => 'Configurer les paramètres du widget de flux',
	'Enter a title for your widget.  This will also be displayed as the title of the feed when used on your published blog.' => 'Saisissez un titre pour votre widget. Il sera aussi utilisé comme titre pour le flux qui sera utilisé sur votre blog.',
	'[_1] Feed Widget' => 'Widget de flux [_1]',
	'Select the maximum number of entries to display.' => 'Sélectionnez le nombre maximum de notes que vous voulez afficher.',
	'3' => '3',
	'5' => '5',
	'10' => '10',
	'All' => 'Toutes',

## plugins/feeds-app-lite/tmpl/msg.tmpl
	'No feeds could be discovered using [_1]' => 'Aucun flux n\'a pu être trouvé en utilisant [_1]',
	'An error occurred processing [_1]. Check <a href="javascript:void(0)" onclick="closeDialog(\'http://www.feedvalidator.org/check.cgi?url=[_2]\')">here</a> for more detail and please try again.' => 'Une erreur s\'est produite en traitant [_1]. Vérifiez <a href="javascript:void(0)" onclick="closeDialog(\'http://www.feedvalidator.org/check.cgi?url=[_2]\')">ici</a> pour plus de détails et essayez à nouveau.',
	'A widget named <strong>[_1]</strong> has been created.' => 'Un widget nommé <strong>[_1]</strong> a été créé.',
	'You may now <a href="javascript:void(0)" onclick="closeDialog(\'[_2]\')">edit &ldquo;[_1]&rdquo;</a> or include the widget in your blog using <a href="javascript:void(0)" onclick="closeDialog(\'[_3]\')">WidgetManager</a> or the following MTInclude tag:' => 'Vous pouvez maintenant <a href="javascript:void(0)" onclick="closeDialog(\'[_2]\')">modifier &ldquo;[_1]&rdquo;</a> ou inclure le widget dans votre blog en utilisant <a href="javascript:void(0)" onclick="closeDialog(\'[_3]\')">WidgetManager</a> ou la balise MTInclude suivante :',
	'You may now <a href="javascript:void(0)" onclick="closeDialog(\'[_2]\')">edit &ldquo;[_1]&rdquo;</a> or include the widget in your blog using the following MTInclude tag:' => 'Vous pouvez maintenant <a href="javascript:void(0)" onclick="closeDialog(\'[_2]\')">modifier &ldquo;[_1]&rdquo;</a> ou inclure le widget dans votre blog en utilisant la balise  MTInclude suivante :',
	'Create Another' => 'En créer un autre',

## plugins/feeds-app-lite/tmpl/start.tmpl
	'You must enter a feed or site URL to proceed' => 'Vous devez saisir l\'URL d\'un flux ou d\'un site pour poursuivre',
	'Create a widget from a feed' => 'Créer un widget à partir d\'un flux',
	'Feed or Site URL' => 'URL du site ou du flux',
	'Enter the URL of a feed, or the URL of a site that has a feed.' => 'Saisissez l\'adresse d\'un flux ou l\'adresse d\'un site possédant un flux.',

## plugins/feeds-app-lite/tmpl/select.tmpl
	'Multiple feeds were found' => 'Plusieurs flux ont été trouvés',
	'Select the feed you wish to use. <em>Feeds.App Lite supports text-only RSS 1.0, 2.0 and Atom feeds.</em>' => 'Sélectionnez le flux que vous voulez utiliser. <em>Feeds.App Lite supporte les flux texte uniquement en RSS 1.0, 2.0 et Atom.</em>',
	'URI' => 'URI',

## plugins/feeds-app-lite/mt-feeds.pl
	'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type? <a href="http://code.appnel.com/feeds-app" target="_blank">Upgrade to Feeds.App</a>.' => 'Feeds.App Lite vous aide à republier les flux sur votre blog. Vous souhaitez en faire plus avec les flux dans Movable Type ? <a href="http://code.appnel.com/feeds-app" target="_blank">Évoluez vers Feeds.App</a>.',
	'Create a Feed Widget' => 'Créer un widget à partir d\'un flux',

## plugins/mixiComment/lib/mixiComment/App.pm
	'mixi reported that you failed to login.  Try again.' => 'mixi n\'a pas réussi à vous identifier. Veuillez réessayer.',

## plugins/mixiComment/tmpl/config.tmpl
	'A mixi ID has already been registered in this blog.  If you want to change the mixi ID for the blog, <a href="[_1]">click here</a> to sign in using your mixi account.  If you want all of the mixi users to comment to your blog (not only your my mixi users), click the reset button to remove the setting.' => 'Un ID mixi est déjà enregistré sur ce blog. Si vous souhaitez modifier l\'ID mixi, <a href="[_1]">cliquez ici</a> pour vous identifier en utilisant votre compte mixi. Si vous souhaitez permettre à tous les utilisateurs mixi de commenter sur votre blog (et pas uniquement vos utilisateurs mixi), cliquez sur le bouton de réinitialisation pour retirer les paramètres.',
	'If you want to restrict comments only from your my mixi users, <a href="[_1]">click here</a> to sign in using your mixi account.' => 'Si vous souhaitez restreindre les commentaires à uniquement vos utilisateurs mixi, <a href="[_1]">cliquez ici</a> pour vous identifier en utilisant votre compte mixi.',

## plugins/mixiComment/mixiComment.pl
	'Allows commenters to sign in to Movable Type using their own mixi username and password via OpenID.' => 'Permet aux auteurs de commentaires de s\'identifier sur Movable Type en utilisant leur nom d\'utilisateur mixi via OpenID.',
	'Sign in using your mixi ID' => 'S\'identifier en utilisant votre identifiant mixi',
	'Click the button to sign in using your mixi ID' => 'Cliquez sur le bouton pour vous identifier en utilisant votre identifiant mixi.',
	'mixi' => 'mixi',

);

## New words: 125

1;
