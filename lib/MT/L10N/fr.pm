# Movable Type (r) Open Source (C) 2005-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
#
# $Id$

package MT::L10N::fr;
use strict;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

## The following is the translation table.

%Lexicon = (

## php/lib/function.mtwidgetmanager.php
	'Error: widgetset [_1] is empty.' => 'Erreur: le groupe de widget [_1] est vide.',
	'Error compiling widgetset [_1]' => 'Erreur de compilation du groupe de widget [_1]',

## php/lib/function.mtvar.php
	'You used a [_1] tag without a valid name attribute.' => 'Vous avez utilise un tag [_1] sans un attribut de nom valide',
	'\'[_1]\' is not a valid function for a hash.' => '\'[_1]\' n\'est pas une fonction valide pour un hash',
	'\'[_1]\' is not a valid function for an array.' => '\'[_1]\' n\'est pas une fonction valide pour un tableau',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] est illegal.',

## php/lib/function.mtassettype.php
	'image' => 'image',
	'Image' => 'Image',
	'file' => 'fichier',
	'File' => 'Fichier',
	'audio' => 'Audio',
	'Audio' => 'Audio',
	'video' => 'Video',
	'Video' => 'Video',

## php/lib/thumbnail_lib.php
	'GD support has not been available. Please install GD support.' => 'Le support GP n\'est pas disponible. Veuillez installer le support GD.',

## php/lib/function.mtcommentauthor.php
	'Anonymous' => 'Anonyme',

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'userpic-[_1]-%wx%h%x',

## php/lib/archive_lib.php
	'Page' => 'Page',
	'Individual' => 'Individuel',
	'Yearly' => 'Annuelles',
	'Monthly' => 'Mensuelles',
	'Daily' => 'Journalieres',
	'Weekly' => 'Hebdomadaires',
	'Author' => 'Par auteurs',
	'(Display Name not set)' => '(Nom pas specifie)',
	'Author Yearly' => 'Par auteurs et annees',
	'Author Monthly' => 'Par auteurs et mois',
	'Author Daily' => 'Par auteurs et jours',
	'Author Weekly' => 'Par auteurs et semaines',
	'Category Yearly' => 'Par categories et annees',
	'Category Monthly' => 'Par categories et mois',
	'Category Daily' => 'Par categories et jours',
	'Category Weekly' => 'Par categories et semaines',

## php/lib/block.mtif.php

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'L\'authentification TypePad n\'est pas activee sur ce blog. MTRemoteSignInLink ne peut etre utilise.',

## php/lib/block.mtauthorhaspage.php
	'No author available' => 'Il n\'a pas d\'auteurs disponibles',

## php/lib/block.mtsethashvar.php

## php/lib/block.mtauthorhasentry.php

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtcommentauthorlink.php

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Saisissez les caracteres que vous voyez dans l\'image ci-dessus.',

## php/lib/function.mtsetvar.php
	'\'[_1]\' is not a hash.' => '\'[_1]\' n\'est pas un hash',
	'Invalid index.' => 'Index invalide',
	'\'[_1]\' is not an array.' => '\'[_1]\' n\'est pas un tableau',
	'\'[_1]\' is not a valid function.' => '\'[_1]\' n\'est pas une fonction valide',

## php/lib/block.mtassets.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" doit etre utilise en combinaison avec l\'espace de nom.',

## php/lib/block.mtsetvarblock.php

## php/lib/block.mtentries.php

## php/lib/function.mtauthordisplayname.php

## php/lib/function.mtentryclasslabel.php
	'page' => 'Page',
	'entry' => 'note',
	'Entry' => 'Note',

## php/lib/function.mtcommentreplytolink.php
	'Reply' => 'Repondre',

## php/mt.php.pre
	'Page not found - [_1]' => 'Page non trouvee - [_1]',

## default_templates/monthly_archive_dropdown.mtml
	'Archives' => 'Archives',
	'Select a Month...' => 'Selectionnez un Mois...',

## default_templates/notify-entry.mtml
	'A new [lc,_3] entitled \'[_1]\' has been published to [_2].' => 'Une nouvelle [lc,_3] intitulee \'[_1]\' a ete publiee sur [_2].',
	'View entry:' => 'Voir la note :',
	'View page:' => 'Voir la page :',
	'[_1] Title: [_2]' => 'Titre du [_1] : [_2]',
	'Publish Date: [_1]' => 'Date de publication : [_1]',
	'Message from Sender:' => 'Message de l\'expediteur :',
	'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'Vous recevez cet email car vous avez demande a recevoir les notifications de nouveau contenu sur [_1], ou l\'auteur de la note a pense que vous seriez interesse. Si vous ne souhaitez plus recevoir ces emails, merci de contacter la personne suivante:',

## default_templates/comments.mtml
	'1 Comment' => '1 Commentaire',
	'# Comments' => '# Commentaires',
	'No Comments' => 'Aucun Commentaire',
	'[_1] replied to <a href="[_2]">comment from [_3]</a>' => '[_1] en reponse au <a href="[_2]">commentaire de [_3]</a>',
	'Leave a comment' => 'Laisser un commentaire',
	'Name' => 'Nom',
	'Email Address' => 'Adresse e-mail',
	'URL' => 'URL',
	'Remember personal info?' => 'Memoriser mes infos personnelles ?',
	'Comments' => 'Commentaires',
	'(You may use HTML tags for style)' => '(Vous pouvez utiliser des balises HTML pour le style)',
	'Preview' => 'Apercu',
	'Submit' => 'Envoyer',

## default_templates/category_archive_list.mtml
	'Categories' => 'Categories',
	'[_1] ([_2])' => '[_1] ([_2])',

## default_templates/monthly_entry_listing.mtml
	'HTML Head' => 'En-tete HTML',
	'[_1] Archives' => 'Archives [_1]',
	'Banner Header' => 'Bloc de l\'En-tete',
	'Entry Summary' => 'Resume de la note',
	'Main Index' => 'Index principal',
	'Sidebar' => 'Colonne laterale',
	'Banner Footer' => 'Bloc du Pied de page',

## default_templates/current_author_monthly_archive_list.mtml
	'[_1]: Monthly Archives' => '[_1]: Archives Mensuelles',

## default_templates/main_index.mtml

## default_templates/page.mtml
	'Trackbacks' => 'Trackbacks',

## default_templates/search_results.mtml
	'Search Results' => 'Resultats de recherche',
	'Results matching &ldquo;[_1]&rdquo;' => 'Resultats pour &ldquo;[_1]&rdquo;',
	'Results tagged &ldquo;[_1]&rdquo;' => 'Resultats tagues &ldquo;[_1]&rdquo;',
	'Previous' => 'Precedent',
	'Next' => 'Suivant',
	'No results found for &ldquo;[_1]&rdquo;.' => 'Aucun resultat pour &ldquo;[_1]&rdquo;.',
	'Instructions' => 'Instructions',
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Par defaut, ce moteur va rechercher tous les mots, quelque soit leur ordre. Pour lancer une recherche sur une phrase exacte, inserez la phrase entre des apostrophes : ',
	'movable type' => 'movable type',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'Le moteur de recherche supporte aussi les mot-cles AND, OR, NOT pour specifier des expressions booleennes :',
	'personal OR publishing' => 'personnel OR publication',
	'publishing NOT personal' => 'publication NOT personnel',

## default_templates/main_index_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to only appear on the homepage (or "main_index"). More info: [_1]' => 'Ceci est un groupe de wigets personnalise qui est conditionne pour n\'apparaitre que sur la page d\'accueil (ou "main_index"). Plus d\'infos : [_1]',
	'Recent Comments' => 'Commentaires recents',
	'Recent Entries' => 'Notes recentes',
	'Recent Assets' => 'Elements recents',
	'Tag Cloud' => 'Nuage de tags',

## default_templates/entry_summary.mtml
	'By [_1] on [_2]' => 'Par [_1] le [_2]',
	'1 TrackBack' => '1 Trackback',
	'# TrackBacks' => '# Trackbacks',
	'No TrackBacks' => 'Aucun Trackback',
	'Tags' => 'Tags',
	'Continue reading <a href="[_1]" rel="bookmark">[_2]</a>.' => 'Lire la suite de <a href="[_1]" rel="bookmark">[_2]</a>.',

## default_templates/comment_response.mtml
	'Confirmation...' => 'Confirmation...',
	'Your comment has been submitted!' => 'Votre commentaire a ete envoye !',
	'Thank you for commenting.' => 'Merci de votre commentaire.',
	'Your comment has been received and held for approval by the blog owner.' => 'Votre commentaire a ete recu et est en attente de validation par le proprietaire de ce blog.',
	'Comment Submission Error' => 'Erreur d\'envoi du commentaire',
	'Your comment submission failed for the following reasons: [_1]' => 'La soumission de votre commentaire a echoue pour la raison suivante : [_1]',
	'Return to the <a href="[_1]">original entry</a>.' => 'Retourner a la <a href="[_1]">note originale</a>.',

## default_templates/commenter_notify.mtml
	'This email is to notify you that a new user has successfully registered on the blog \'[_1]\'. Listed below you will find some useful information about this new user.' => 'Un nouvel utilisateur s\'est enregistre sur le blog \'[_1]\'. Vous trouverez ci-dessous quelques informations utiles a propos de ce nouvel utilisateur.',
	'New User Information:' => 'Informations concernant ce nouvel utilisateur :',
	'Username: [_1]' => 'Identifiant : [_1]',
	'Full Name: [_1]' => 'Nom complet : [_1]',
	'Email: [_1]' => 'Email : [_1]',
	'To view or edit this user, please click on or cut and paste the following URL into a web browser:' => 'Pour voir ou modifier cet utilisateur, merci de cliquer ou copier-coller l\'adresse suivante dans votre navigateur web:',

## default_templates/footer-email.mtml
	'Powered by Movable Type [_1]' => 'Powered by Movable Type [_1]',

## default_templates/archive_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to serve different content based upon what type of archive it is included. More info: [_1]' => 'Ceci est un groupe de widgets personnalise qui est conditionne pour afficher un contenu different base sur le type d\'archives qui est inclue. Plus d\'infos : [_1]',
	'Current Category Monthly Archives' => 'Archives Mensuelles de la Categorie Courante',
	'Category Archives' => 'Archives par Categories',
	'Monthly Archives' => 'Archives mensuelles',

## default_templates/verify-subscribe.mtml
	'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Merci d\'avoir pour votre inscription aux mises a jours [_1]. Cliquez sur le lien ci-dessous pour confirmer cette inscription :',
	'If the link is not clickable, just copy and paste it into your browser.' => 'Si le lien n\'est pas cliquable, faites simplement un copier-coller dans votre navigateur.',

## default_templates/new-ping.mtml
	'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Un Trackback non-approuve a ete depose sur votre blog [_1], pour la note #[_2] ([_3]). Vous devez approuver ce Trackback pour qu\'il apparaisse sur votre site.',
	'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Un Trackback non-approuve a ete depose sur votre blog [_1], pour la categorie #[_2] ([_3]). Vous devez approuver ce Trackback pour qu\'il apparaisse sur votre site.',
	'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Un nouveau TrackBack a ete depose sur votre blog [_1], pour la note #[_2] ([_3]).',
	'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'Un nouveau TrackBack a ete depose sur votre blog [_1], pour la categorie #[_2] ([_3]).',
	'Excerpt' => 'Extrait',
	'Title' => 'Titre',
	'Blog' => 'Blog',
	'IP address' => 'Adresse IP',
	'Approve TrackBack' => 'Approuver le Trackback',
	'View TrackBack' => 'Voir le Trackback',
	'Report TrackBack as spam' => 'Notifier le Trackback comme spam',
	'Edit TrackBack' => 'Editer les Trackbacks',

## default_templates/syndication.mtml
	'Subscribe to feed' => 'S\'abonner au flux',
	'Subscribe to this blog\'s feed' => 'S\'abonner au flux de ce blog',
	'Subscribe to a feed of all future entries tagged &ldquo;[_1]&ldquo;' => 'S\'abonner au flux de toutes les futurs notes tagguees &ldquo;[_1]&ldquo;',
	'Subscribe to a feed of all future entries matching &ldquo;[_1]&ldquo;' => 'S\'abonner au flux de toutes les futurs notes contenant &ldquo;[_1]&ldquo;',
	'Feed of results tagged &ldquo;[_1]&ldquo;' => 'Flux des resultats tagges &ldquo;[_1]&ldquo;',
	'Feed of results matching &ldquo;[_1]&ldquo;' => 'Flux des resultats pour &ldquo;[_1]&ldquo;',

## default_templates/date_based_author_archives.mtml
	'Author Yearly Archives' => 'Archives Annuelles par Auteurs',
	'Author Monthly Archives' => 'Archives par auteurs et mois',
	'Author Weekly Archives' => 'Archives Hebdomadaires par Auteurs',
	'Author Daily Archives' => 'Archives Quotidiennes par Auteurs',

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'Page Non Trouvee',

## default_templates/current_category_monthly_archive_list.mtml
	'[_1]' => '[_1]',

## default_templates/creative_commons.mtml
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Ce blog possede une licence <a href="[_1]">Creative Commons</a>.',

## default_templates/recent_comments.mtml
	'<strong>[_1]:</strong> [_2] <a href="[_3]" title="full comment on: [_4]">read more</a>' => '<strong>[_1] :</strong> [_2] <a href="[_3]" title="commentaire complet sur : [_4]">lire la suite</a>',

## default_templates/author_archive_list.mtml
	'Authors' => 'Auteurs',

## default_templates/technorati_search.mtml
	'Technorati' => 'Technorati',
	'<a href=\'http://www.technorati.com/\'>Technorati</a> search' => 'Recherche <a href=\'http://www.technorati.com/\'>Technorati</a> ',
	'this blog' => 'ce blog',
	'all blogs' => 'tous les blogs',
	'Search' => 'Rechercher',
	'Blogs that link here' => 'Blogs pointant ici',

## default_templates/date_based_category_archives.mtml
	'Category Yearly Archives' => 'Archives Annuelles par Categories',
	'Category Monthly Archives' => 'Archives par categories et mois',
	'Category Weekly Archives' => 'Archives Hebdomadaires par Categories',
	'Category Daily Archives' => 'Archives Quotidiennes par Categories',

## default_templates/monthly_archive_list.mtml
	'[_1] <a href="[_2]">Archives</a>' => '<a href="[_2]">Archives</a> [_1]',

## default_templates/category_entry_listing.mtml
	'Recently in <em>[_1]</em> Category' => 'Recemment dans la categorie <em>[_1]</em>',

## default_templates/comment_throttle.mtml
	'If this was a mistake, you can unblock the IP address and allow the visitor to add it again by logging in to your Movable Type installation, going to Blog Config - IP Banning, and deleting the IP address [_1] from the list of banned addresses.' => 'Si c\'etait une erreur, vous pouvez debloquer l\'adresse IP et autoriser le visiteur a nouveau en vous identifiant dans Movable Type, dans Configuration du Blog - Blocage IP, et en effacant l\'adresse IP [_1] de la liste des adresses bannies.',
	'A visitor to your blog [_1] has automatically been banned by adding more than the allowed number of comments in the last [_2] seconds.' => 'Un visiteur de votre blog [_1] a ete automatiquement banni apres avoir publie une quantite de commentaires superieure a la limite etablie au cours des [_2] secondes.',
	'This has been done to prevent a malicious script from overwhelming your weblog with comments. The banned IP address is' => 'Cette operation est destinee a empecher la publication automatisee de commentaires par des scripts. L\'adresse IP bannie est',

## default_templates/signin.mtml
	'Sign In' => 'Connexion',
	'You are signed in as ' => 'Vous etes identifie en tant que ',
	'sign out' => 'deconnexion',
	'You do not have permission to sign in to this blog.' => 'Vous n\'avez pas l\'autorisation de vous identifier sur ce blog.',

## default_templates/new-comment.mtml
	'An unapproved comment has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => 'Un commentaire non approuve a ete envoye sur votre blog [_1], pour la note #[_2] ([_3]). Vous devez l\'approuver pour qu\'il apparaisse sur votre blog.',
	'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Un nouveau commentaire a ete publie sur votre blog [_1], au sujet de la note [_2] ([_3]). ',
	'Commenter name: [_1]' => 'Nom de l\'auteur de commentaires',
	'Commenter email address: [_1]' => 'Adresse email de l\'auteur de commentaires :  [_1]',
	'Commenter URL: [_1]' => 'URL de l\'auteur de commentaires : [_1]',
	'Commenter IP address: [_1]' => 'Adresse IP de l\'auteur de commentaires : [_1]',
	'Approve comment:' => 'Accepter le commentaire :',
	'View comment:' => 'Voir le commentaire :',
	'Edit comment:' => 'Editer le commentaire :',
	'Report comment as spam:' => 'Marquer le commentaire comme etant du spam :',

## default_templates/pages_list.mtml
	'Pages' => 'Pages',

## default_templates/commenter_confirm.mtml
	'Thank you registering for an account to comment on [_1].' => 'Merci de vous etre enregistre pour commenter sur [_1].',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to comment on [_1].' => 'Pour votre propre securite et pour eviter les fraudes, nous vous demandons de confirmer votre compte et votre adresse email avant de continuer. Vous pourrez ensuite immediatement commenter sur [_1].',
	'To confirm your account, please click on or cut and paste the following URL into a web browser:' => 'Pour confirmer votre compte, cliquez ou copiez-collez l\'adresse suivante dans un navigateur web:',
	'If you did not make this request, or you don\'t want to register for an account to comment on [_1], then no further action is required.' => 'Si vous n\'etes pas a l\'origine de cette demande, ou si vous ne souhaitez pas vous enregistrer pour commenter sur [_1], alors aucune action n\'est necessaire.',
	'Thank you very much for your understanding.' => 'Merci beaucoup pour votre comprehension.',
	'Sincerely,' => 'Cordialement,',

## default_templates/about_this_page.mtml
	'About this Entry' => 'A propos de cette note',
	'About this Archive' => 'A propos de cette archive',
	'About Archives' => 'A propos des archives',
	'This page contains links to all the archived content.' => 'Cette page contient des liens vers toutes les archives.',
	'This page contains a single entry by [_1] published on <em>[_2]</em>.' => 'Cette page contient une unique note de [_1] publiee le <em>[_2]</em>.',
	'<a href="[_1]">[_2]</a> was the previous entry in this blog.' => '<a href="[_1]">[_2]</a> est la note precedente de ce blog.',
	'<a href="[_1]">[_2]</a> is the next entry in this blog.' => '<a href="[_1]">[_2]</a> est la note suivante de ce blog.',
	'This page is an archive of entries in the <strong>[_1]</strong> category from <strong>[_2]</strong>.' => 'Cette page est une archive des notes dans la categorie <strong>[_1]</strong> de <strong>[_2]</strong>.',
	'<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> est l\'archive precedente.',
	'<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> est l\'archive suivante.',
	'This page is an archive of recent entries in the <strong>[_1]</strong> category.' => 'Cette page est une archive des notes recentes dans la categorie <strong>[_1]</strong>.',
	'<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> est la categorie precedente.',
	'<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> est la categorie suivante.',
	'This page is an archive of recent entries written by <strong>[_1]</strong> in <strong>[_2]</strong>.' => 'Cette page est une archive des notes recentes ecrites par <strong>[_1]</strong> dans <strong>[_2]</strong>.',
	'This page is an archive of recent entries written by <strong>[_1]</strong>.' => 'Cette page est une archive des notes recentes ecrites par <strong>[_1]</strong>.',
	'This page is an archive of entries from <strong>[_2]</strong> listed from newest to oldest.' => 'Cette page est une archive des notes de <strong>[_2]</strong> listees de la plus recente a la plus ancienne.',
	'Find recent content on the <a href="[_1]">main index</a>.' => 'Retrouvez le contenu recent sur <a href="[_1]">l\'index principal</a>.',
	'Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.' => 'Retrouvez le contenu recent sur <a href="[_1]">l\'index principal</a> ou allez dans les <a href="[_2]">archives</a> pour retrouver tout le contenu.',

## default_templates/entry.mtml

## default_templates/recover-password.mtml
	'A request has been made to change your password in Movable Type. To complete this process click on the link below to select a new password.' => 'Une requete a ete faite pour changer votre mot de passe dans Movable Type. Pour terminer cliquez sur le lien ci-dessous pour choisir un nouveau mot de passe.',
	'If you did not request this change, you can safely ignore this email.' => 'Si vous n\'avez pas demande ce changement, vous pouvez ignorer cet email.',

## default_templates/javascript.mtml
	'moments ago' => 'il y a quelques instants',
	'[quant,_1,hour,hours] ago' => 'il y a [quant,_1,heure,heures]',
	'[quant,_1,minute,minutes] ago' => 'il y a [quant,_1,minute,minutes]',
	'[quant,_1,day,days] ago' => 'il y a [quant,_1,jour,jours]',
	'Edit' => 'Editer',
	'Your session has expired. Please sign in again to comment.' => 'Votre session a expire. Veuillez vous identifier a nouveau pour commenter.',
	'Signing in...' => 'Identification ...',
	'You do not have permission to comment on this blog. ([_1]sign out[_2])' => 'Vous n\'avez pas la permission de commenter sur ce blog. ([_1]deconnexion[_2])',
	'Thanks for signing in, __NAME__. ([_1]sign out[_2])' => 'Merci de vous etre identifie(e) en tant que __NAME__. ([_1]fermer la session[_2])',
	'[_1]Sign in[_2] to comment.' => '[_1]Identifiez-vous[_2] pour commenter.',
	'[_1]Sign in[_2] to comment, or comment anonymously.' => '[_1]Identifiez-vous[_2] pour commenter, ou laissez un commentaire anonyme.',
	'Replying to <a href="[_1]" onclick="[_2]">comment from [_3]</a>' => 'En reponse au <a href="[_1]" onclick="[_2]">commentaire de [_3]</a>',

## default_templates/search.mtml
	'Case sensitive' => 'Sensible a la casse',
	'Regex search' => 'Expression rationnelle',

## default_templates/archive_index.mtml
	'Author Archives' => 'Archives par auteurs',

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
	'2-column layout - Sidebar' => 'Mise en page a 2 colonnes - Barre laterale',
	'3-column layout - Primary Sidebar' => 'Mise en page a 3 colonnes - Premiere barre laterale',
	'3-column layout - Secondary Sidebar' => 'Mise en page a 3 colonnes - Seconde barre laterale',

## default_templates/openid.mtml
	'[_1] accepted here' => '[_1] est accepte',
	'http://www.sixapart.com/labs/openid/' => 'http://www.sixapart.com/labs/openid/',
	'Learn more about OpenID' => 'Apprenez-en plus a propos d\'OpenID',

## default_templates/banner_footer.mtml
	'_POWERED_BY' => 'Powered by <a href="http://www.movabletype.org/"><$MTProductName$></a>',

## default_templates/powered_by.mtml
	'_MTCOM_URL' => 'http://www.movabletype.com/',

## default_templates/tag_cloud.mtml

## default_templates/recent_assets.mtml

## default_templates/comment_preview.mtml
	'Previewing your Comment' => 'Apercu de votre commentaire',
	'Replying to comment from [_1]' => 'En reponse au commentaire de [_1]',
	'Cancel' => 'Annuler',

## lib/MT/CMS/Search.pm
	'No [_1] were found that match the given criteria.' => 'Aucun [_1] n\'a ete trouve correspondant aux criteres fournis.',
	'No permissions' => 'Aucun droit',
	'Entry Body' => 'Corps de la note',
	'Extended Entry' => 'Suite de la note',
	'Keywords' => 'Mots-cles',
	'Basename' => 'Nom de base',
	'Comment Text' => 'Texte du commentaire',
	'IP Address' => 'Adresse IP',
	'Source URL' => 'URL Source',
	'Blog Name' => 'Nom du blog',
	'Page Body' => 'Corps de la page',
	'Extended Page' => 'Page etendue',
	'Template Name' => 'Nom du gabarit',
	'Text' => 'Texte',
	'Linked Filename' => 'Lien du fichier lie',
	'Output Filename' => 'Nom du fichier de sortie',
	'Filename' => 'Nom de fichier',
	'Description' => 'Description',
	'Label' => 'Etiquette',
	'Log Message' => 'Message du journal',
	'Username' => 'Nom d\'utilisateur',
	'Display Name' => 'Nom a afficher',
	'Site URL' => 'URL du site',
	'Site Root' => 'Site Racine',
	'Search & Replace' => 'Rechercher et Remplacer',
	'Invalid date(s) specified for date range.' => 'Date(s) incorrecte(s) pour la selection de calendrier.',
	'Permission denied.' => 'Autorisation refusee.',
	'Error in search expression: [_1]' => 'Erreur dans la recherche de l expression : [_1]',
	'Saving object failed: [_2]' => 'La sauvegarde des objets a echoue : [_2]',

## lib/MT/CMS/Import.pm
	'Can\'t load blog #[_1].' => 'Impossible de charger le blog #[_1].',
	'Import/Export' => 'Importer/Exporter',
	'Please select a blog.' => 'Merci de selectionner un blog.',
	'Load of blog \'[_1]\' failed: [_2]' => 'Le chargement du blog \'[_1]\' a echoue : [_2]',
	'You do not have import permissions' => 'Vous n\'avez pas les droits d\'importation',
	'You do not have permission to create users' => 'Vous n\'avez pas l\'autorisation de creer des utilisateurs',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'Vous devez fournir un mot de passe si vous allez creer de nouveaux utilisateurs pour chaque utilisateur liste dans votre blog.',
	'Importer type [_1] was not found.' => 'Type d\'importeur [_1] non trouve.',

## lib/MT/CMS/Folder.pm
	'The folder \'[_1]\' conflicts with another folder. Folders with the same parent must have unique basenames.' => 'Le repertoire \'[_1]\' est en conflit avec un autre repertoire. Les repertoires qui ont le meme repertoire parent doivent avoir un nom de base unique.',
	'Folder \'[_1]\' created by \'[_2]\'' => 'Repertoire \'[_1]\' cree par \'[_2]\'',
	'The name \'[_1]\' is too long!' => 'Le nom \'[_1]\' est trop long.',
	'Folder \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Repertoire \'[_1]\' (ID:[_2]) supprime par \'[_3]\'',

## lib/MT/CMS/Tag.pm
	'Invalid type' => 'Type incorrect',
	'New name of the tag must be specified.' => 'Le nouveau nom de ce tag doit etre specifie.',
	'No such tag' => 'Pas de tag de ce type',
	'Invalid request.' => 'Demande invalide.',
	'Error saving entry: [_1]' => 'Erreur d\'enregistrement de la note: [_1]',
	'Error saving file: [_1]' => 'Erreur en sauvegardant le fichier: [_1]',
	'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Tag \'[_1]\' (ID:[_2]) supprime par \'[_3]\'',
	'Entries' => 'Notes',

## lib/MT/CMS/Template.pm
	'index' => 'index',
	'archive' => 'archive',
	'module' => 'module',
	'widget' => 'widget',
	'email' => 'Adresse email',
	'system' => 'systeme',
	'Templates' => 'Gabarits',
	'One or more errors were found in this template.' => 'Une erreur ou plus ont ete trouvees dans ce gabarit.',
	'Create template requires type' => 'La creation de gabarits necessite un type',
	'Archive' => 'Archive',
	'Entry or Page' => 'Note ou Page',
	'New Template' => 'Nouveau gabarit',
	'Index Templates' => 'Gabarits d\'index',
	'Archive Templates' => 'Gabarits d\'archives',
	'Template Modules' => 'Modules de gabarits',
	'System Templates' => 'Gabarits systeme',
	'Email Templates' => 'Gabarits email',
	'Template Backups' => 'Sauvegardes de gabarit',
	'Can\'t locate host template to preview module/widget.' => 'Impossible de localiser le gabarit du serveur pour previsualiser de module/widget.',
	'Publish error: [_1]' => 'Erreur de publication: [_1]',
	'Unable to create preview file in this location: [_1]' => 'Impossible de creer le fichier de pre-visualisation a cet endroit : [_1]',
	'Lorem ipsum' => 'Lorem ipsum',
	'LOREM_IPSUM_TEXT' => 'LOREM_IPSUM_TEXT',
	'LORE_IPSUM_TEXT_MORE' => 'LORE_IPSUM_TEXT_MORE',
	'sample, entry, preview' => 'extrait, note, previsualisation',
	'Populating blog with default templates failed: [_1]' => 'L\'activation sur le blog des gabarits par defaut a echoue : [_1]',
	'Setting up mappings failed: [_1]' => 'La mise en oeuvre des mappings a echoue : [_1]',
	'Saving map failed: [_1]' => 'Echec lors du rattachement: [_1]',
	'You should not be able to enter 0 as the time.' => 'Vous ne devriez pas pouvoir saisir 0 comme heure.',
	'You must select at least one event checkbox.' => 'Vous devez selectionner au moins une case a cocher evenement.',
	'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Gabarit \'[_1]\' (ID:[_2]) cree par \'[_3]\'',
	'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Gabarit \'[_1]\' (ID:[_2]) supprime par \'[_3]\'',
	'No Name' => 'Pas de Nom',
	'Orphaned' => 'Orphelin',
	'Global Templates' => 'Gabarits globaux',
	' (Backup from [_1])' => ' (Sauvegarde depuis [_1])',
	'Error creating new template: ' => 'Erreur pendant la creation du nouveau gabarit : ',
	'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Saut du gabarit \'[_1]\' car c\'est un gabarit personnalise.',
	'Refreshing template <strong>[_3]</strong> with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>' => 'Reactualiser les gabarits <strong>[_3]</strong> depuis <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">la sauvegarde</a>',
	'Skipping template \'[_1]\' since it has not been changed.' => 'Saut du gabarit \'[_1]\' car il n\'a pas ete modifie',
	'Copy of [_1]' => 'Copie de [_1]',
	'Permission denied: [_1]' => 'Autorisation refusee: [_1]',
	'Save failed: [_1]' => 'Echec sauvegarde: [_1]',
	'Invalid ID [_1]' => 'ID invalide [_1]',
	'Saving object failed: [_1]' => 'Echec lors de la sauvegarde de l\'objet : [_1]',
	'Load failed: [_1]' => 'Echec de chargement : [_1]',
	'(no reason given)' => '(sans raison donnee)',
	'Removing [_1] failed: [_2]' => 'Suppression [_1] echouee: [_2]',
	'template' => 'gabarit',
	'Restoring widget set [_1]... ' => 'Restauration du set de widget [_1] en cours...',
	'Done.' => 'Termine.',
	'Failed.' => 'Echec.',

## lib/MT/CMS/Category.pm
	'Subfolder' => 'Sous-repertoire',
	'Subcategory' => 'Sous-categorie',
	'Saving [_1] failed: [_2]' => 'Enregistrement de [_1] a echoue: [_2]',
	'The [_1] must be given a name!' => 'Le [_1] doit avoir un nom!',
	'Add a [_1]' => 'Ajouter un [_1]',
	'No label' => 'Pas d\'etiquette',
	'Category name cannot be blank.' => 'Le nom de la categorie ne peut pas etre vide.',
	'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Le nom de categorie \'[_1]\' est en conflit avec une autre categorie. Les categories racines et les sous-categories qui ont le meme parent doivent avoir des noms uniques.',
	'The category basename \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => 'Le nom de base de la categorie \'[_1]\' est en conflit avec une autre categorie. Les categories racines et les sous-categories qui ont le meme parent doivent avoir des noms de base uniques.',
	'Category \'[_1]\' created by \'[_2]\'' => 'Categorie \'[_1]\' creee par \'[_2]\'',
	'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Categorie \'[_1]\' (ID:[_2]) supprimee par \'[_3]\'',

## lib/MT/CMS/User.pm
	'Users' => 'Utilisateurs',
	'Create User' => 'Creer un utilisateur',
	'Can\'t load role #[_1].' => 'Impossible de charger le role #[_1].',
	'Roles' => 'Roles',
	'Create Role' => 'Creer un role',
	'(user deleted)' => '(utilisateur efface)',
	'*User deleted*' => '*Utilisateur supprime*',
	'(newly created user)' => '(nouveaux utilisateurs)',
	'User Associations' => 'Associations d\'utilisateur',
	'Role Users & Groups' => 'Role Utilisateurs et Groupes',
	'Associations' => 'Associations',
	'(Custom)' => '(Personnalise)',
	'The user' => 'L\'utilisateur',
	'User' => 'Utilisateur',
	'Role name cannot be blank.' => 'Le role de peu pas etre laisse vierge.',
	'Another role already exists by that name.' => 'Un autre role existe deja avec ce nom.',
	'You cannot define a role without permissions.' => 'Vous ne pouvez pas definir un role sans autorisations.',
	'General Settings' => 'Parametres generaux',
	'Invalid ID given for personal blog clone source ID.' => 'ID invalide fourni pour l\'ID de la source de la duplication du blog personnel.',
	'If personal blog is set, the default site URL and root are required.' => 'Si le blog personnel est active, l\'URL du site par defaut et sa racine sont obligatoires.',
	'Select a entry author' => 'Selectionner l\'auteur de la note',
	'Selected author' => 'Auteur selectionne',
	'Type a username to filter the choices below.' => 'Tapez un nom d\'utilisateur pour affiner les choix ci-dessous.',
	'Entry author' => 'Auteur de la note',
	'Select a System Administrator' => 'Selectionner un administrateur systeme',
	'Selected System Administrator' => 'Administrateur systeme selectionne',
	'System Administrator' => 'Administrateur Systeme',
	'represents a user who will be created afterwards' => 'il s\'agit des nouveaux utilisateurs crees plus tard',
	'Select Blogs' => 'Selectionner des blogs',
	'Blogs Selected' => 'Blogs selectionnes',
	'Search Blogs' => 'Rechercher des blogs',
	'Select Users' => 'Utilisateurs selectionnes',
	'Users Selected' => 'Utilisateurs selectionnes',
	'Search Users' => 'Rechercher des utilisateurs',
	'Select Roles' => 'Selectionnez des roles',
	'Role Name' => 'Nom du role',
	'Roles Selected' => 'Roles selectionnes',
	'' => '', # Translate - New
	'Grant Permissions' => 'Ajouter des autorisations',
	'You cannot delete your own association.' => 'Vous ne pouvez pas supprimer votre propre association.',
	'You cannot delete your own user record.' => 'Vous ne pouvez pas effacer vos propres donnees Utilisateur.',
	'You have no permission to delete the user [_1].' => 'Vous n\'avez pas l\'autorisation d\'effacer l\'utilisateur [_1].',
	'User requires username' => 'Un nom d\'utilisateur est necessaire pour l\'utilisateur',
	'[_1] contains an invalid character: [_2]' => '[_1] contient un caractere invalide : [_2]',
	'User requires display name' => 'Un nom d\'affichage est necessaire pour l\'utilisateur',
	'A user with the same name already exists.' => 'Un utilisateur possedant ce nom existe deja.',
	'User requires password' => 'L\'utilisateur a besoin d\'un mot de passe',
	'Email Address is required for password recovery' => 'L\'adresse email est necessaire pour recuperer le mot de passe',
	'Email Address is invalid.' => 'L\'adresse email n\'est pas valide.',
	'URL is invalid.' => 'L\'URL n\'est pas valide.',
	'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) cree par \'[_3]\'',
	'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) supprime par \'[_3]\'',

## lib/MT/CMS/Asset.pm
	'Assets' => 'Elements',
	'Files' => 'Fichiers',
	'Upload File' => 'Telecharger un fichier',
	'Can\'t load file #[_1].' => 'Impossible de charger le fichier #[_1].',
	'File \'[_1]\' uploaded by \'[_2]\'' => 'Fichier \'[_1]\' envoye par \'[_2]\'',
	'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Fichier \'[_1]\' (ID:[_2]) supprime par \'[_3]\'',
	'All Assets' => 'Tous les Elements',
	'Untitled' => 'Sans nom',
	'Archive Root' => 'Archive Racine',
	'Please select a file to upload.' => 'Merci de selectionner un fichier a envoyer.',
	'Invalid filename \'[_1]\'' => 'Nom de fichier invalide \'[_1]\'',
	'Please select an audio file to upload.' => 'Merci de selectionner un fichier audio a envoyer.',
	'Please select an image to upload.' => 'Merci de selectionner une image a envoyer.',
	'Please select a video to upload.' => 'Merci de selectionner une video a envoyer.',
	'Before you can upload a file, you need to publish your blog.' => 'Avant de pouvoir envoyer un fichier, vous devez publier votre blog.',
	'Invalid extra path \'[_1]\'' => 'Chemin supplementaire invalide \'[_1]\'',
	'Can\'t make path \'[_1]\': [_2]' => 'Impossible de creer le chemin \'[_1]\' : [_2]',
	'Invalid temp file name \'[_1]\'' => 'Nom de fichier temporaire invalide \'[_1]\'',
	'Error opening \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture de \'[_1]\' : [_2]',
	'Error deleting \'[_1]\': [_2]' => 'Erreur lors de la suppression de \'[_1]\' : [_2]',
	'File with name \'[_1]\' already exists. (Install File::Temp if you\'d like to be able to overwrite existing uploaded files.)' => 'Le fichier dont le nom est \'[_1]\' existe deja. (Installez File::Temp si vous souhaitez pouvoir ecraser les fichiers deja charges.)',
	'Error creating temporary file; please check your TempDir setting in your coniguration file (currently \'[_1]\') this location should be writable.' => 'Erreur lors de la creation du fichier temporaire; merci de verifier votre reglage TempDir dans votre fichier de configuration (actuellement \'[_1]\') cet endroit doit etre accessible en ecriture.',
	'unassigned' => 'non assigne',
	'File with name \'[_1]\' already exists; Tried to write to tempfile, but open failed: [_2]' => 'Le fichier avec le nom \'[_1]\' existe deja; Tentative d\'ecriture dans un fichier temporaire, mais l\'ouverture a echoue : [_2]',
	'Could not create upload path \'[_1]\': [_2]' => 'Impossible de creer le repertoire d\'upload \'[_1]\': [_2]',
	'Error writing upload to \'[_1]\': [_2]' => 'Erreur d\'ecriture lors de l\'envoi de \'[_1]\' : [_2]',
	'Uploaded file is not an image.' => 'Le fichier telecharge n\'est pas une image',
	'<' => '<',
	'/' => '/',

## lib/MT/CMS/Log.pm
	'All Feedback' => 'Tous les retours lecteurs',
	'Publishing' => 'Publication',
	'Activity Log' => 'Journal (logs)',
	'System Activity Feed' => 'Flux d\'activite du systeme',
	'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'Journal (logs) pour le blog \'[_1]\' (ID:[_2]) reinitialise par \'[_3]\'',
	'Activity log reset by \'[_1]\'' => 'Journal (logs) reinitialise par \'[_1]\'',

## lib/MT/CMS/Export.pm
	'You do not have export permissions' => 'Vous n\'avez pas les droits d\'exportation',

## lib/MT/CMS/Blog.pm
	'Publishing Settings' => 'Parametres de publication',
	'Plugin Settings' => 'Parametres des plugins',
	'Settings' => 'Parametres',
	'New Blog' => 'Nouveau Blog',
	'Blogs' => 'Blogs',
	'Blog Activity Feed' => 'Flux Activite du Blog',
	'Go Back' => 'Retour',
	'Can\'t load entry #[_1].' => 'Impossible de charger la note #[_1].',
	'Can\'t load template #[_1].' => 'Impossible de charger le gabarit #[_1].',
	'index template \'[_1]\'' => 'gabarit d\'index \'[_1]\'',
	'[_1] \'[_2]\'' => '[_1] \'[_2]\'',
	'Publish Site' => 'Publier le site',
	'Invalid blog' => 'Blog incorrect',
	'Select Blog' => 'Selectionner un blog',
	'Selected Blog' => 'Blog selectionne',
	'Type a blog name to filter the choices below.' => 'Entrez le nom d\'un blog pour affiner les resultats ci-dessous.',
	'Saving permissions failed: [_1]' => 'Echec lors de la sauvegarde des Autorisations : [_1]',
	'Blog \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) cree par \'[_3]\'',
	'You did not specify a blog name.' => 'Vous n\'avez pas specifie de nom pour le blog.',
	'Site URL must be an absolute URL.' => 'L\'URL du site doit etre une URL absolue.',
	'Archive URL must be an absolute URL.' => 'Les URLs d\'archive doivent etre des URLs absolues.',
	'You did not specify an Archive Root.' => 'Vous n\'avez pas specifie une archive racine ',
	'Blog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) efface par \'[_3]\'',
	'Saving blog failed: [_1]' => 'Echec lors de la sauvegarde du blog : [_1]',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Erreur: Movable Type ne peut pas ecrire dans le repertoire de cache de gabarits. Merci de verifier les autorisations du repertoire <code>[_1]</code> situe dans le repertoire du blog.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Erreur: Movable Type n\'a pas pu creer un repertoire pour cacher vos gabarits dynamiques. Vous devez creer un repertoire nomme <code>[_1]</code> dans le repertoire de votre blog.',

## lib/MT/CMS/TrackBack.pm
	'TrackBacks' => 'Trackbacks',
	'Junk TrackBacks' => 'Trackbacks spam',
	'TrackBacks where <strong>[_1]</strong> is &quot;[_2]&quot;.' => 'Trackbacks ou <strong>[_1]</strong> est &quot;[_2]&quot;.',
	'TrackBack Activity Feed' => 'Flux d\'activite des trackbacks ',
	'(Unlabeled category)' => '(Categorie sans description)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) de \'[_2]\' supprime par \'[_3]\' de la categorie \'[_4]\'',
	'(Untitled entry)' => '(Note sans titre)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) de \'[_2]\' supprime par \'[_3]\' de la note \'[_4]\'',
	'No Excerpt' => 'Pas d\'extrait',
	'No Title' => 'Pas de Titre',
	'Orphaned TrackBack' => 'Trackback orphelin',
	'category' => 'categorie',

## lib/MT/CMS/Dashboard.pm
	'Better, Stronger, Faster' => 'Meilleur, Plus robuste, Plus Rapide',
	'Movable Type has undergone a significant overhaul in all aspects of performance. Memory utilization has been reduced, publishing times have been increased significantly and search is now 100x faster!' => 'Movable Type a subi des changements majeurs concernant ses performances. L\'utilisation de la memoire a ete reduite, les temps de publication sont significativement reduits et la recherche est desormais 100x plus rapide !',
	'Module Caching' => 'Cache des modules',
	'Template module and widget content can now be cached in the database to dramatically speed up publishing.' => 'Les gabarits de module et de widget peuvent desormais etre caches en base de donnees pour ameliorer le temps de publication.',
	'Improved Template and Design Management' => 'Gestion du design et des gabarits amelioree',
	'The template editing interface has been enhanced to make designers more efficient at updating their site\'s design. The default templates have also been dramatically simplified to make it easier for you to edit and create the site you want.' => 'L\'interface d\'edition des gabarits a ete amelioree pour permettre aux graphistes d\'etre plus efficace dans la mise a jour du design de leur site. Les gabarits par defaut ont ete grandement simplifies pour vous rendre plus simple l\'edition et la creation d\'un site sur mesure.',
	'Threaded Comments' => 'Commentaires en cascade',
	'Allow commenters on your blog to reply to each other increasing user engagement and creating more dynamic conversations.' => 'Permet a vos commentateurs de se repondre entre eux pour un engagement accru et des conversations plus dynamiques.',

## lib/MT/CMS/Common.pm
	'Permisison denied.' => 'Autorisation refusee.',
	'The Template Name and Output File fields are required.' => 'Le nom du gabarit et les champs du fichier de sortie sont obligatoires.',
	'Invalid type [_1]' => 'Type invalide [_1]',
	'Invalid parameter' => 'Parametre invalide',
	'Notification List' => 'Liste de notifications',
	'IP Banning' => 'Bannissement d\'adresses IP',
	'Removing tag failed: [_1]' => 'La suppression du tag a echouee: [_1]',
	'Loading MT::LDAP failed: [_1].' => 'Echec de Chargement MT::LDAP[_1]',
	'System templates can not be deleted.' => 'Les gabarits crees par le Systeme ne peuvent pas etre supprimes.',

## lib/MT/CMS/BanList.pm
	'You did not enter an IP address to ban.' => 'Vous devez saisir une adresse IP a bannir.',
	'The IP you entered is already banned for this blog.' => 'L\'adresse IP saisie est deja bannie pour ce blog.',

## lib/MT/CMS/Plugin.pm
	'Plugin Set: [_1]' => 'Eventail de plugins : [_1]',
	'Individual Plugins' => 'Plugins individuels',

## lib/MT/CMS/AddressBook.pm
	'No permissions.' => 'Pas d\'autorisations.',
	'No entry ID provided' => 'Aucune ID de note fournie',
	'No such entry \'[_1]\'' => 'Aucune note du type \'[_1]\'',
	'No email address for user \'[_1]\'' => 'L\'utilisateur \'[_1]\' ne possede pas d\'adresse e-mail',
	'No valid recipients found for the entry notification.' => 'Aucun destinataire valide n\'a ete trouve pour la notification de cette note.',
	'[_1] Update: [_2]' => '[_1] Mise a jour : [_2]',
	'Error sending mail ([_1]); try another MailTransfer setting?' => 'Erreur lors de l\'envoi de l\'e-mail ([_1]); Essayer avec d\'autres parametres pour MailTransfer ?',
	'The value you entered was not a valid email address' => 'Vous devez saisir une adresse email valide',
	'The value you entered was not a valid URL' => 'Vous devez saisir une URL valide',
	'The e-mail address you entered is already on the Notification List for this blog.' => 'L\'adresse email saisie est deja sur la liste de notification de ce blog.',
	'Subscriber \'[_1]\' (ID:[_2]) deleted from address book by \'[_3]\'' => 'Abonne \'[_1]\' (ID:[_2]) supprime du carnet d\'adresses par \'[_3]\'',

## lib/MT/CMS/Tools.pm
	'Password Recovery' => 'Recuperation de mot de passe',
	'Email Address is required for password recovery.' => 'Une adresse email est obligatoire pour recuperer le mot de passe.',
	'User not found' => 'Utilisateur introuvable',
	'Error sending mail ([_1]); please fix the problem, then try again to recover your password.' => 'Erreur d\'envoi du mail ([_1]); merci de corriger le probleme, puis essayez a nouveau de recuperer votre mot de passe.',
	'Password reset token not found' => 'Token de remise a zero du mot de passe introuvable',
	'Email address not found' => 'Adresse email introuvable',
	'Your request to change your password has expired.' => 'Votre demande de modification de mot de passe a expiree.',
	'Invalid password reset request' => 'Requete de modification de mot de passe invalide',
	'Please confirm your new password' => 'Merci de confirmer votre nouveau mot de passe',
	'Passwords do not match' => 'Les mots de passe ne correspondent pas',
	'That action ([_1]) is apparently not implemented!' => 'Cette action ([_1]) n\'est visiblement pas implementee!',
	'Invalid password recovery attempt; can\'t recover password in this configuration' => 'Tentative de recuperation de mot de passe invalide; impossible de recuperer le mot de passe dans cette configuration',
	'Invalid author_id' => 'auteur_id incorrect',
	'Backup' => 'Sauvegarder',
	'Backup & Restore' => 'Sauvegarder & Restaurer',
	'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.' => 'Le repertoire temporaire doit etre autorise en ecriture pour que la sauvegarde puisse fonctionner. Merci de verifier la directive de configuration TempDir.',
	'Temporary directory needs to be writable for restore to work correctly.  Please check TempDir configuration directive.' => 'Le repertoire temporaire doit etre autorise en ecriture pour que la restauration puisse fonctionner. Merci de verifier la directive de configuration TempDir.',
	'[_1] is not a number.' => '[_1] n\'est pas un nombre.',
	'Copying file [_1] to [_2] failed: [_3]' => 'La copie du fichier [_1] vers [_2] a echoue: [_3]',
	'Specified file was not found.' => 'Le fichier specifie n\'a pas ete trouve.',
	'[_1] successfully downloaded backup file ([_2])' => '[_1] a telecharge avec succes le fichier de sauvegarde ([_2])',
	'Restore' => 'Restaurer',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ',
	'Some of the actual files for assets could not be restored.' => 'Certains des fichiers des elements n\'ont pu etre restaures.',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Merci d\'utiliser xml, tar.gz, zip, ou manifest comme extension de fichier.',
	'Unknown file format' => 'Format de fichier inconnu',
	'Some objects were not restored because their parent objects were not restored.' => 'Certains objets n\'ont pas ete restaures car leurs objets parents n\'ont pas ete restaures.',
	'Detailed information is in the <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>activity log</a>.' => 'Des informations detaillees se trouvent dans le <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>journal (logs)</a>.',
	'[_1] has canceled the multiple files restore operation prematurely.' => '[_1] a annule prematurement l\'operation de restauration de plusieurs fichiers.',
	'Changing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Changement du chemin du site pour le blog \'[_1]\' (ID:[_2])...',
	'Removing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Suppression du chemin du site pour le blog \'[_1]\' (ID:[_2])...',
	'Changing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Changement du chemin d\'archive pour le blog \'[_1]\' (ID:[_2])...',
	'Removing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Suppression du chemin d\'archive pour le blog \'[_1]\' (ID:[_2])...',
	'failed' => 'echec',
	'ok' => 'ok',
	'Changing file path for the asset \'[_1]\' (ID:[_2])...' => 'Changement de chemin de fichier pour l\'element \'[_1]\' (ID:[_2])...',
	'Please upload [_1] in this page.' => 'Merci d\'envoyer [_1] dans cette page.',
	'File was not uploaded.' => 'Le fichier n\'a pas ete envoye.',
	'Restoring a file failed: ' => 'Echec lors de la restauration d\'un fichier : ',
	'Some of the files were not restored correctly.' => 'Certains fichiers n\'ont pas ete restaures correctement.',
	'Successfully restored objects to Movable Type system by user \'[_1]\'' => 'Restauration avec succes des objets dans Movable Type par utilisateur \'[_1]\'',
	'Can\'t recover password in this configuration' => 'Impossible de recuperer le mot de passe dans cette configuration',
	'Invalid user name \'[_1]\' in password recovery attempt' => 'Nom d\'utilisateur invalide \'[_1]\' lors de la tentative de recuperation du mot de passe',
	'User name or password hint is incorrect.' => 'Identifiant ou indice du mot de passe incorrect.',
	'User has not set pasword hint; cannot recover password' => 'L\'utilisateur n\'a pas fourni d\'indice de mot de passe; impossible de recuperer le mot de passe',
	'Invalid attempt to recover password (used hint \'[_1]\')' => 'Tentative invalide de recuperation du mot de passe (indice de \'utilisateur \'[_1]\')',
	'User does not have email address' => 'L\'utilisateur n\'a pas d\'adresse email',
	'A password reset link has been sent to [_3] for user  \'[_1]\' (user #[_2]).' => 'Un lien de reinitialisation du mot de passe a ete envoye a [_3] concernant l\'utilisateur \'[_1]\' (utilisateur #[_2]).', # Translate - New
	'Some objects were not restored because their parent objects were not restored.  Detailed information is in the <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">activity log</a>.' => 'Certains objets n\'ont pas ete restaures car leurs objets parents n\'ont pas ete restaures. Des informations detaillees se trouvent dans le <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">journal d\'activite</a>.',
	'[_1] is not a directory.' => '[_1] n\'est pas un repertoire.',
	'Error occured during restore process.' => 'Une erreur s\'est produite pendant la procedure de restauration.',
	'Some of files could not be restored.' => 'Certains fichiers n\'ont pu etre restaures.',
	'Uploaded file was not a valid Movable Type backup manifest file.' => 'Le fichier envoye n\'etait pas un fichier de sauvegarde manifest Movable Type valide.',
	'Blog(s) (ID:[_1]) was/were successfully backed up by user \'[_2]\'' => 'Blog(s) (ID:[_1]) a/ont ete sauvegarde(s) avec succes par l\'utilisateur \'[_2]\'',
	'Movable Type system was successfully backed up by user \'[_1]\'' => 'Movable Type a ete sauvegarde avec succes par l\'utilisateur \'[_1]\'',
	'Some [_1] were not restored because their parent objects were not restored.' => 'Certains [_1] n\'ont pas ete restaures car leurs objets parents n\'ont pas ete restaures.',

## lib/MT/CMS/Entry.pm
	'(untitled)' => '(sans titre)',
	'New Entry' => 'Nouvelle note',
	'New Page' => 'Nouvelle Page',
	'None' => 'Aucune',
	'pages' => 'Pages',
	'Category' => 'Categorie',
	'Asset' => 'Element',
	'Tag' => 'Tag',
	'Entry Status' => 'Statut par defaut',
	'[_1] Feed' => 'Flux [_1]',
	'Can\'t load template.' => 'Impossible de charger le gabarit',
	'New [_1]' => 'Nouveau [_1]',
	'No such [_1].' => 'Pas de [_1].',
	'Same Basename has already been used. You should use an unique basename.' => 'Ce nom de base est deja utilise. Vous devriez choisir un nom de base unique.',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Votre blog n\'a pas ete configure avec un chemin de site et une URL. Vous ne pourrez pas publier de notes tant qu\'ils ne seront pas definis.',
	'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Date invalide \'[_1]\'; les dates doivent etre au format AAAA-MM-JJ HH:MM:SS.',
	'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Date invalide \'[_1]\'; les dates de publication doivent etre reelles.',
	'[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) ajoute par utilisateur \'[_4]\'',
	'[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_1] \'[_2]\' (ID:[_3]) edite et son statut est passe de [_4] a [_5] par utilisateur \'[_6]\'',
	'[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) edite par utilisateur \'[_4]\'',
	'Saving placement failed: [_1]' => 'Echec lors de la sauvegarde du placement : [_1]',
	'Saving entry \'[_1]\' failed: [_2]' => 'Echec \'[_1]\' lors de la sauvegarde de la Note : [_2]',
	'Removing placement failed: [_1]' => 'Echec lors de la suppression de l\'emplacement : [_1]',
	'Ping \'[_1]\' failed: [_2]' => 'Le ping \'[_1]\' n\'a pas fonctionne : [_2]',
	'(user deleted - ID:[_1])' => '(utilisateur supprime - ID:[_1])',
	'<a href="[_1]">QuickPost to [_2]</a> - Drag this link to your browser\'s toolbar then click it when you are on a site you want to blog about.' => '<a href="[_1]">QuickPost vers [_2]</a> - Glissez ce lien vers la barre d\'outils de votre navigateur et cliquez dessus a chaque fois que vous etes sur un site dont vous voulez parler dans votre blog.',
	'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Note \'[_1]\' (ID:[_2]) supprimee par \'[_3]\'',
	'Need a status to update entries' => 'Statut necessaire pour mettre a jour les notes',
	'Need entries to update status' => 'Notes necessaires pour mettre a jour le statut',
	'One of the entries ([_1]) did not actually exist' => 'Une des notes ([_1]) n\'existait pas',
	'[_1] \'[_2]\' (ID:[_3]) status changed from [_4] to [_5]' => '[_1] \'[_2]\' (ID:[_3]) statut change de [_4] a [_5]',

## lib/MT/CMS/Comment.pm
	'Edit Comment' => 'Editer les commentaires',
	'Orphaned comment' => 'Commentaire orphelin',
	'Comments Activity Feed' => 'Flux d\'activite des commentaires',
	'Commenters' => 'Auteurs de commentaires',
	'Authenticated Commenters' => 'Auteurs de commentaires authentifies',
	'No such commenter [_1].' => 'Pas de d\'auteur de commentaires [_1].',
	'User \'[_1]\' trusted commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\' a accorde le statut Fiable a l\'auteur de commentaire \'[_2]\'.',
	'User \'[_1]\' banned commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\'  a banni l\'auteur de commentaire \'[_2]\'.',
	'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\'  a retire le statut Banni a l\'auteur de commentaire \'[_2]\'.',
	'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\'  a retire le statut Fiable a l\'auteur de commentaire \'[_2]\'.',
	'Feedback Settings' => 'Parametres des Feedbacks',
	'Invalid request' => 'Demande incorrecte',
	'An error occurred: [_1]' => 'Une erreur s\'est produite: [_1]',
	'Parent comment id was not specified.' => 'id du commentaire parent non specifie.',
	'Parent comment was not found.' => 'Commentaire parent non trouve.',
	'You can\'t reply to unapproved comment.' => 'Vous ne pouvez repondre a un commentaire non approuve.',
	'Publish failed: [_1]' => 'Echec de la publication : [_1]',
	'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Commentaire (ID:[_1]) de \'[_2]\' supprime par \'[_3]\' de la note \'[_4]\'',
	'You don\'t have permission to approve this comment.' => 'Vous n\'avez pas l\'autorisation d\'approuver ce commentaire.',
	'Comment on missing entry!' => 'Commentaire sur une note manquante !',
	'You can\'t reply to unpublished comment.' => 'Vous ne pouvez pas repondre a un commentaire non publie.',
	'Registered User' => 'Utilisateur enregistre',

## lib/MT/Comment.pm
	'Comment' => 'Commentaire',
	'Load of entry \'[_1]\' failed: [_2]' => 'Le chargement de la note \'[_1]\' a echoue : [_2]',

## lib/MT/BasicAuthor.pm
	'authors' => 'auteurs',

## lib/MT/Asset/Video.pm
	'Videos' => 'Videos',

## lib/MT/Asset/Audio.pm

## lib/MT/Asset/Image.pm
	'Images' => 'Images',
	'Actual Dimensions' => 'Dimensions reelles',
	'[_1] x [_2] pixels' => '[_1] x [_2] pixels',
	'Error cropping image: [_1]' => 'Erreur de rognage de l\'image: [_1]',
	'Error scaling image: [_1]' => 'Erreur lors du redimentionement de l\'image: [_1]',
	'Error converting image: [_1]' => 'Erreur pendant la conversion de l\'image: [_1]',
	'Error creating thumbnail file: [_1]' => 'Erreur lors de la creation de la vignette: [_1]',
	'%f-thumb-%wx%h-%i%x' => '%f-thumb-%wx%h-%i%x',
	'Can\'t load image #[_1]' => 'Impossible de charger l\'image #[_1]',
	'View image' => 'Voir l\'image',
	'Permission denied setting image defaults for blog #[_1]' => 'Autorisation interdite de configurer les parametres par defaut des images pour le blog #[_1]',
	'Thumbnail image for [_1]' => 'Miniature de l\'image pour [_1]',
	'Invalid basename \'[_1]\'' => 'Nom de base invalide \'[_1]\'',
	'Error writing to \'[_1]\': [_2]' => 'Erreur \'[_1]\' lors de l\'ecriture de : [_2]',
	'Popup Page for [_1]' => 'Fenetre popup pour [_1]',

## lib/MT/IPBanList.pm
	'IP Ban' => 'Interdiction IP',
	'IP Bans' => 'Interdictions IP',

## lib/MT/Placement.pm
	'Category Placement' => 'Gestion des categories',

## lib/MT/TaskMgr.pm
	'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'Impossible d\'assurer le verrouillage pour l\'execution de taches systeme. Verifiez que la zone TempDir ([_1]) est ouverte en ecriture.',
	'Error during task \'[_1]\': [_2]' => 'Erreur pendant la tache \'[_1]\' : [_2]',
	'Scheduled Tasks Update' => 'Mise a jour des taches planifiees',
	'The following tasks were run:' => 'Les taches suivantes ont ete executees :',

## lib/MT/BackupRestore/ManifestFileHandler.pm

## lib/MT/BackupRestore/BackupFileHandler.pm
	'Uploaded file was backed up from Movable Type but the different schema version ([_1]) from the one in this system ([_2]).  It is not safe to restore the file to this version of Movable Type.' => 'Le fichier telecharge a ete sauvegarde depuis Movable Type mais la version du schema ([_1]) est differente de celle du systeme ([_2]). Il n\'est pas conseille de restaurer le fichier vers cette version de Movable Type.',
	'[_1] is not a subject to be restored by Movable Type.' => '[_1] n\'est pas un sujet qui peut etre restaure par Movable Type.',
	'[_1] records restored.' => '[_1] enregistrements restaures.',
	'Restoring [_1] records:' => 'Restauration de [_1] enregistrements:',
	'User with the same name as the name of the currently logged in ([_1]) found.  Skipped the record.' => 'Utilisateur avec le meme nom que l\'utilisateur actuellement connecte ([_1]) trouve',
	'User with the same name \'[_1]\' found (ID:[_2]).  Restore replaced this user with the data backed up.' => 'Utilisateur avec le meme nom \'[_1]\' trouve (ID:[_2]). La restauration a remplace cet utilisateur par les donnees presentes dans la sauvegardes.',
	'Tag \'[_1]\' exists in the system.' => 'Le tag \'[_1]\' existe dans le systeme.',
	'[_1] records restored...' => '[_1] enregistrements restaures...',
	'The role \'[_1]\' has been renamed to \'[_2]\' because a role with the same name already exists.' => 'Le role \'[_1]\' a ete renomme \'[_2]\' car un autre role portant le meme nom existe deja.',

## lib/MT/Component.pm
	'Loading template \'[_1]\' failed: [_2]' => 'Echec lors du chargement du gabarit \'[_1]\': [_2]',

## lib/MT/Page.pm
	'Folder' => 'Repertoire',
	'Load of blog failed: [_1]' => 'Echec lors du chargement du blog : [_1]',

## lib/MT/AtomServer.pm
	'[_1]: Entries' => '[_1]: Notes',
	'PreSave failed [_1]' => 'Echec lors du pre-enregistrement [_1]',
	'User \'[_1]\' (user #[_2]) added [lc,_4] #[_3]' => 'L\'Utilisateur \'[_1]\' (utilisateur #[_2]) a ajoute [lc,_4] #[_3]',
	'User \'[_1]\' (user #[_2]) edited [lc,_4] #[_3]' => 'L\'Utilisateur \'[_1]\' (L\'Utilisateur #[_2]) a edite [lc,_4] #[_3]',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Le module Perl Image::Size est requis pour determiner la largeur et la hauteur des images telechargees.',

## lib/MT/Bootstrap.pm
	'Got an error: [_1]' => 'Erreur de type : [_1]',

## lib/MT/PluginData.pm
	'Plugin Data' => 'Donnees Plugin',

## lib/MT/Category.pm
	'Categories must exist within the same blog' => 'Les categories doivent exister au sein du meme blog ',
	'Category loop detected' => 'Boucle de categorie detectee',

## lib/MT/Asset.pm
	'Could not remove asset file [_1] from filesystem: [_2]' => 'Impossible de retirer le fichier [_1] du systeme : [_2]',
	'Location' => 'Adresse',

## lib/MT/Permission.pm
	'Permission' => 'Autorisation',
	'Permissions' => 'Autorisations',

## lib/MT/Image.pm
	'File size exceeds maximum allowed: [_1] > [_2]' => 'La taille du fichier depasse le maximum autorise: [_1] > [_2]',
	'Can\'t load Image::Magick: [_1]' => 'Impossible de charger Image::Magick : [_1]',
	'Reading file \'[_1]\' failed: [_2]' => 'La lecture du fichier \'[_1]\' a echoue : [_2]',
	'Reading image failed: [_1]' => 'Echec lors de la lecture de l\'image : [_1]',
	'Scaling to [_1]x[_2] failed: [_3]' => 'La mise a l\'echelle vers [_1]x[_2] a echoue : [_3]',
	'Cropping a [_1]x[_1] square at [_2],[_3] failed: [_4]' => 'Rognage d\'un carre [_1]x[_1] a [_2],[_3] echoue: [_4]',
	'Converting image to [_1] failed: [_2]' => 'Conversion de l\'image vers [_1] a echoue: [_2]',
	'Can\'t load IPC::Run: [_1]' => 'Impossible de charger IPC::Run : [_1]',
	'Unsupported image file type: [_1]' => 'Type de fichier image non supporte: [_1]',
	'Cropping to [_1]x[_1] failed: [_2]' => 'Rognage vers [_1]x[_1] echoue: [_2]',
	'Converting to [_1] failed: [_2]' => 'Conversion vers [_1] a echoue: [_2]',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'Votre chemin d\'acces vers les outils NetPBM n\'est pas valide sur votre machine.',
	'Can\'t load GD: [_1]' => 'Impossible de charger GD: [_1]',

## lib/MT/Template/Context.pm
	'The attribute exclude_blogs cannot take \'all\' for a value.' => 'L\'attribut exclude_blogs ne peut pas prendre \'all\' comme valeur.',
	'You used an \'[_1]\' tag outside of the context of a author; perhaps you mistakenly placed it outside of an \'MTAuthors\' container?' => 'Vous avez utilise un tag \'[_1]\' en dehors du contexte d\'un auteur; peut-etre l\'avez-vous place par erreur en dehors du conteneur \'MTAuthors\' ?',
	'You used an \'[_1]\' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an \'MTEntries\' container?' => 'Vous avez utilise une balise \'[_1]\' en dehors du contexte d\'une note; peut-etre l\'avez-vous place par erreur en dehors du conteneur \'MTEntries\' ?',
	'You used an \'[_1]\' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an \'MTComments\' container?' => 'Vous avez utilise une balise \'[_1]\' en dehors du contexte d\'un commentaire; peut-etre l\'avez-vous place par erreur en dehors du conteneur \'MTComments\' ?',
	'You used an \'[_1]\' tag outside of the context of a ping; perhaps you mistakenly placed it outside of an \'MTPings\' container?' => 'Vous avez utilise une balise \'[_1]\' en dehors d\'un contexte de ping; peut-etre l\'avez-vous place en dehors du conteneur \'MTPings\' ?',
	'You used an \'[_1]\' tag outside of the context of an asset; perhaps you mistakenly placed it outside of an \'MTAssets\' container?' => 'Vous avez utilise une balise \'[_1]\' en dehors du contexte d\'un element; peut-etre l\'avez-vous place par erreur en dehors d\'un conteneur \'MTAssets\' ?',
	'You used an \'[_1]\' tag outside of the context of a page; perhaps you mistakenly placed it outside of a \'MTPages\' container?' => 'Vous avez utilise un tag \'[_1]\' en dehors du contexte d\'une page; peut-etre l\'avez vous place par erreur en dehors d\'un bloc \'MTPages\' ?',

## lib/MT/Template/ContextHandlers.pm
	'All About Me' => 'Tout Sur Moi',
	'Remove this widget' => 'Supprimer ce widget',
	'[_1]Publish[_2] your site to see these changes take effect.' => '[_1]Publiez[_2] votre site pour que ces changements soient appliques.',
	'Actions' => 'Actions',
	'Warning' => 'Attention',
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.org/documentation/appendices/tags/%t.html',
	'No [_1] could be found.' => 'Il n\'y a pas de [_1] trouves.',
	'records' => 'enregistrements',
	'Invalid tag [_1] specified.' => 'Tag invalide [_1] specifie.',
	'No template to include specified' => 'Aucun gabarit specifie pour inclusion',
	'Recursion attempt on [_1]: [_2]' => 'Tentative de recursion sur [_1]: [_2]',
	'Can\'t find included template [_1] \'[_2]\'' => 'Impossible de trouver le gabarit inclus [_1] \'[_2]\'',
	'Error making path \'[_1]\': [_2]' => 'Erreur dans le chemin \'[_1]\' : [_2]',
	'Writing to \'[_1]\' failed: [_2]' => 'Ecriture sur\'[_1]\' a echoue: [_2]',
	'Can\'t find blog for id \'[_1]' => 'Impossible de trouver un blog pour le ID\'[_1]',
	'Can\'t find included file \'[_1]\'' => 'Impossible de trouver le fichier inclus \'[_1]\'',
	'Error opening included file \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture du fichier inclus \'[_1]\' : [_2]',
	'Recursion attempt on file: [_1]' => 'Tentative de recursion sur le fichier: [_1]',
	'Unspecified archive template' => 'Gabarit d\'archive non specifie',
	'Error in file template: [_1]' => 'Erreur dans fichier gabarit : [_1]',
	'Can\'t load template' => 'Impossible de charger le gabarit',
	'Can\'t find template \'[_1]\'' => 'Impossible de trouver le gabarit \'[_1]\'',
	'Can\'t find entry \'[_1]\'' => 'Impossible de trouver la note \'[_1]\'',
	'[_1] is not a hash.' => '[_1] n\'est pas un hash',
	'You have an error in your \'[_2]\' attribute: [_1]' => 'Vous avez une erreur dans votre attribut \'[_2]\' : [_1]',
	'No such user \'[_1]\'' => 'L\'utilisateur \'[_1]\' n\'existe pas',
	'You used <$MTEntryFlag$> without a flag.' => 'Vous utilisez <$MTEntryFlag$> sans drapeau.',
	'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Vous avez utilise un [_1] tag pour creer un lien vers \'[_2]\' archives, mais ce type d\'archive n\'est pas publie.',
	'Could not create atom id for entry [_1]' => 'Impossible de creer un ID Atom pour cette note [_1]',
	'To enable comment registration, you need to add a TypePad token in your weblog config or user profile.' => 'Pour activer l\'enregistrement pour les commentaires, vous devez ajouter le jeton TypePad a votre configuration de blog ou profil utilisateur.',
	'The MTCommentFields tag is no longer available; please include the [_1] template module instead.' => 'Le tag MTCommentFields n\'est plus disponible; merci d\'inclure le module de template [_1] a la place.',
	'Comment Form' => 'Formulaire de commentaire',
	'You used an [_1] tag without a date context set up.' => 'Vous utilisez un tag [_1] sans avoir configure la date.',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] est valide uniquement avec des archives quotidiennes, hebdomadaires ou mensuelles.',
	'Group iterator failed.' => 'Le repetateur de groupe a echoue',
	'You used an [_1] tag outside of the proper context.' => 'Vous utilisez un tag [_1] en dehors de son contexte propre.',
	'Could not determine entry' => 'La note ne peut pas etre determinee',
	'Invalid month format: must be YYYYMM' => 'Le format du mois est invalide : Il doit etre de la forme AAAAMM',
	'No such category \'[_1]\'' => 'La categorie \'[_1]\' n\'existe pas',
	'[_1] cannot be used without publishing Category archive.' => '[_1] ne peut etre utilise sans la publication d\'archives par categorie.',
	'<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> doit etre utilise dans le contexte d\'une categorie, ou avec l\'attribut \'Categorie\' dans le tag.',
	'[_1] used outside of [_2]' => '[_1] utilise en dehors de [_2]',
	'MT[_1] must be used in a [_2] context' => 'MT[_1] doit etre utilise dans le contexte [_2]',
	'Cannot find package [_1]: [_2]' => 'Impossible de trouver le package [_1]: [_2]',
	'Error sorting [_2]: [_1]' => 'Erreur en classant [_2]: [_1]',
	'You used an [_1] without a author context set up.' => 'Vous avez utilise un [_1] sans avoir configure de contexte d\'auteur.',
	'Can\'t load user.' => 'Impossible de charger l\'utilisateur.',
	'Division by zero.' => 'Division par zero.',
	'name is required.' => 'le nom est requis.',
	'Specified WidgetSet \'[_1]\' not found.' => 'Le groupe de widgets \'[_1]\' n\'a pas ete trouve',
	'Can\'t find included template widget \'[_1]\'' => 'Impossible de trouver le gabarit de widget inclus \'[_1]\'',

## lib/MT/Session.pm
	'Session' => 'Session',

## lib/MT/Plugin.pm
	'Publish' => 'Publier',
	'My Text Format' => 'Format de mon texte.',

## lib/MT/DefaultTemplates.pm
	'Archive Index' => 'Index d\'archive',
	'Stylesheet' => 'Feuille de style',
	'JavaScript' => 'JavaScript',
	'Feed - Recent Entries' => 'Flux - Notes Recentes',
	'RSD' => 'RSD',
	'Monthly Entry Listing' => 'Liste des notes mensuelle',
	'Category Entry Listing' => 'Liste des notes categorisees',
	'Comment Response' => 'Reponse au commentaire',
	'Displays error, pending or confirmation message for comments.' => 'Affiche les erreurs et les messages de moderation pour les commentaires.',
	'Comment Preview' => 'Pre visualisation du commentaire',
	'Displays preview of comment.' => 'Affiche la previsualisation du commentaire.',
	'Dynamic Error' => 'Erreur dynamique',
	'Displays errors for dynamically published templates.' => 'Affiche les erreurs pour les modeles publies dynamiquement.',
	'Popup Image' => 'Image dans une fenetre popup',
	'Displays image when user clicks a popup-linked image.' => 'Affiche l\'image quand l\'utilisateur clique sur une image pop-up.',
	'Displays results of a search.' => 'Affiche les resultats d\'une recherche.',
	'About This Page' => 'A propos de cette page',
	'Archive Widgets Group' => 'Archive du groupe des Widgets',
	'Current Author Monthly Archives' => 'Archives Mensuelles de l\'Auteur Courant',
	'Calendar' => 'Calendrier',
	'Creative Commons' => 'Creative Commons',
	'Home Page Widgets Group' => 'Page d\'accueil du groupe des Widgets',
	'Monthly Archives Dropdown' => 'Liste deroulante des Archives Mensuelles',
	'Page Listing' => 'Liste des Pages',
	'Powered By' => 'Anime Par',
	'Syndication' => 'Syndication',
	'Technorati Search' => 'Recherche Technorati',
	'Date-Based Author Archives' => 'Archives des Auteurs par Dates',
	'Date-Based Category Archives' => 'Archives des Categories par Dates',
	'OpenID Accepted' => 'OpenID Accepte',
	'Mail Footer' => 'Pied des mails',
	'Comment throttle' => 'Limitation des commentaires',
	'Commenter Confirm' => 'Confirmation du commentateur',
	'Commenter Notify' => 'Notification du commentateur',
	'New Comment' => 'Nouveau commentaire',
	'New Ping' => 'Nouveau ping',
	'Entry Notify' => 'Notification de note',
	'Subscribe Verify' => 'Verification d\'inscription',

## lib/MT/Trackback.pm
	'TrackBack' => 'Trackback',

## lib/MT/Role.pm
	'Role' => 'Role',

## lib/MT/Notification.pm
	'Contact' => 'Contact',
	'Contacts' => 'Contacts',

## lib/MT/Entry.pm
	'record does not exist.' => 'l\'enregistrement n\'existe pas.',
	'Draft' => 'Brouillon',
	'Review' => 'Verification',
	'Future' => 'Futur',
	'Spam' => 'Spam',

## lib/MT/Upgrade.pm
	'Comment Posted' => 'Commentaire envoye',
	'Your comment has been posted!' => 'Votre commentaire a ete envoye !',
	'Comment Pending' => 'Commentaires en attente',
	'Your comment submission failed for the following reasons:' => 'L\'envoi de votre commentaire a echoue pour les raisons suivantes :',
	'[_1]: [_2]' => '[_1]: [_2]',
	'Moving metadata storage for categories...' => 'Deplacement du stockage des metadonnees pour les categories en cours...',
	'Upgrading metadata storage for [_1]' => 'Mise a jour du stockage des metadonnees pour [_1]',
	'Updating password recover email template...' => 'Template de reinitialisation du mot de passe en cours de mise a jour...',
	'Migrating Nofollow plugin settings...' => 'Migration des parametres du plugin Nofollow...',
	'Updating system search template records...' => 'Mise a jour des donnees du gabarit de recherche du systeme...',
	'Custom ([_1])' => '([_1]) personnalise ',
	'This role was generated by Movable Type upon upgrade.' => 'Ce role a ete genere par Movable Type lors d\'une mise a jour.',
	'Migrating permission records to new structure...' => 'Migration des donnees d\'autorisation vers une nouvelle structure...',
	'Migrating role records to new structure...' => 'Migration des donnees de role vers la nouvelle structure...',
	'Migrating system level permissions to new structure...' => 'Migration des autorisations pour tout le systeme vers la nouvelle structure...',
	'Invalid upgrade function: [_1].' => 'Fonction de mise a jour invalide : [_1].',
	'Error loading class [_1].' => 'Erreur en chargeant la classe [_1].',
	'Creating initial blog and user records...' => 'Creation des donnees initiales du blog et de l\'utilisateur...',
	'Error saving record: [_1].' => 'Erreur de l\'enregistrement des informations : [_1].',
	'First Blog' => 'Premier blog',
	'I just finished installing Movable Type [_1]!' => 'Je viens d\'installer Movable Type [_1]!',
	'Welcome to my new blog powered by Movable Type. This is the first post on my blog and was created for me automatically when I finished the installation process. But that is ok, because I will soon be creating posts of my own!' => 'Bienvenue sur mon nouveau blog anime par Movable Type. Ceci est la premiere note de mon blog. Elle a ete creee automatiquement lorsque j\'ai termine mon installation. Mais je vais maintenant creer mes propres articles!',
	'Movable Type also created a comment for me as well so that I could see what a comment will look like on my blog once people start submitting comments on all the posts I will write.' => 'Movable Type a aussi cree un commentaire automatiquement pour me permettre de voir a quoi cela ressemblera lorsque mes lecteurs commenteront mes notes.',
	'Blog Administrator' => 'Administrateur du blog',
	'Can administer the blog.' => 'Peut administrer le blog.',
	'Editor' => 'Editeur',
	'Can upload files, edit all entries/categories/tags on a blog and publish the blog.' => 'Peut telecharger des fichiers, editer les notes/categories/tags sur un blog donne et le republier.',
	'Can create entries, edit their own, upload files and publish.' => 'Peut creer des notes, modifier ses notes, envoyer des fichiers et publier.',
	'Designer' => 'Designer',
	'Can edit, manage and publish blog templates.' => 'Peut editer, gerer et republier les templates des blogs.',
	'Webmaster' => 'Webmaster',
	'Can manage pages and publish blog templates.' => 'Peut gerer les pages et republier les templates des blogs.',
	'Contributor' => 'Contributeur',
	'Can create entries, edit their own and comment.' => 'Peut creer des notes, modifier ses notes et commenter.',
	'Moderator' => 'Moderateur',
	'Can comment and manage feedback.' => 'Peut commenter et gerer les commentaires.',
	'Commenter' => 'Auteur du commentaire',
	'Can comment.' => 'Peut commenter.',
	'Removing Dynamic Site Bootstrapper index template...' => 'Suppression du gabarit index Dynamic Site Bootstrapper',
	'Creating new template: \'[_1]\'.' => 'Creation d\'un nouveau gabarit: \'[_1]\'.',
	'Mapping templates to blog archive types...' => 'Mapping des gabarits vers les archives des blogs...',
	'Renaming PHP plugin file names...' => 'Renommage des noms de fichier des plugins php...',
	'Error renaming PHP files. Please check the Activity Log.' => 'Erreur pendant le renommage des fichiers PHP. Merci de verifier le journal (logs).',
	'Cannot rename in [_1]: [_2].' => 'Impossible de renommer dans [_1]: [_2].',
	'Removing unnecessary indexes...' => 'Suppression des index non necessaires...',
	'Upgrading table for [_1] records...' => 'Mise a jour des tables pour [_1] les enregistrements...',
	'Upgrading database from version [_1].' => 'Mise a jour de la Base de donnees de la version [_1].',
	'Database has been upgraded to version [_1].' => 'La base de donnees a ete mise a jour version [_1].',
	'User \'[_1]\' upgraded database to version [_2]' => 'L\'utilisateur \'[_1]\' a mis a jour la base de donnees avec la version [_2]',
	'Plugin \'[_1]\' upgraded successfully to version [_2] (schema version [_3]).' => 'Plugin \'[_1]\' mis a jour avec succes a la version [_2] (schema version [_3]).',
	'User \'[_1]\' upgraded plugin \'[_2]\' to version [_3] (schema version [_4]).' => 'Utilisateur \'[_1]\' a mis a jour le plugin \'[_2]\' vers la version [_3] (schema version [_4]).',
	'Plugin \'[_1]\' installed successfully.' => 'Le Plugin \'[_1]\' a ete installe correctement.',
	'User \'[_1]\' installed plugin \'[_2]\', version [_3] (schema version [_4]).' => 'Utilisateur \'[_1]\' a installe le plugin \'[_2]\', version [_3] (schema version [_4]).',
	'Setting your permissions to administrator.' => 'Parametre des autorisations pour l\'administrateur.',
	'Creating configuration record.' => 'Creation des infos de configuration.',
	'Creating template maps...' => 'Creation des tables de correspondances de gabarits...',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'Lien du gabarit [_1] vers [_2] ([_3]).',
	'Mapping template ID [_1] to [_2].' => 'Lien du gabarit [_1] vers [_2].',
	'Error loading class: [_1].' => 'Erreur de chargement de classe : [_1].',
	'Assigning entry comment and TrackBack counts...' => 'Attribution des nombres de commentaires et trackbacks...',
	'Error saving [_1] record # [_3]: [_2]...' => 'Erreur en enregistrant l\'enregistrement [_1] # [_3]: [_2]...',
	'Creating entry category placements...' => 'Creation des placements des categories des notes...',
	'Updating category placements...' => 'Modification des placements de categories...',
	'Assigning comment/moderation settings...' => 'Mise en place des parametres commentaire/moderation ...',
	'Setting blog basename limits...' => 'Specification des limites des noms de bases du blog...',
	'Setting default blog file extension...' => 'Ajout de l\'extension de fichier par defaut du blog...',
	'Updating comment status flags...' => 'Modification des statuts des commentaires...',
	'Updating commenter records...' => 'Modification des donnees des auteurs de commentaires...',
	'Assigning blog administration permissions...' => 'Ajout des autorisations d\'administration du blog...',
	'Setting blog allow pings status...' => 'Mise en place du statut d\'autorisation des pings...',
	'Updating blog comment email requirements...' => 'Mise a jour des prerequis des emails pour les commentaires du blog...',
	'Assigning entry basenames for old entries...' => 'Ajout des racines des notes pour les anciennes notes...',
	'Updating user web services passwords...' => 'Mise a jour des mots de passe des services web d\'utilisateur...',
	'Updating blog old archive link status...' => 'Modification de l\'ancien statut d\'archive du blog...',
	'Updating entry week numbers...' => 'Mise a jour des numeros des semaines de la note...',
	'Updating user permissions for editing tags...' => 'Modification des autorisations des utilisateurs pour modifier les balises...',
	'Setting new entry defaults for blogs...' => 'Reglage des valeurs par defaut des nouvelles notes pour les blogs...',
	'Migrating any "tag" categories to new tags...' => 'Migration des categories de "tag" vers de nouveaux tags...',
	'Assigning custom dynamic template settings...' => 'Attribution des parametres specifiques de gabarits dynamique...',
	'Assigning user types...' => 'Attribution des types d\'utilisateurs...',
	'Assigning category parent fields...' => 'Attribution des champs parents de la categorie...',
	'Assigning template build dynamic settings...' => 'Attribution des parametres de construction dynamique du gabarit...',
	'Assigning visible status for comments...' => 'Attribution du statut visible pour les commentaires...',
	'Assigning junk status for comments...' => 'Attribution du statut spam pour les commentaires...',
	'Assigning visible status for TrackBacks...' => 'Attribution du statut visible des trackbacks...',
	'Assigning junk status for TrackBacks...' => 'Attribution du statut spam pour les trackbacks...',
	'Assigning basename for categories...' => 'Attribution de racines aux categories...',
	'Assigning user status...' => 'Attribution du statut utilisateur...',
	'Migrating permissions to roles...' => 'Migration des autorisations vers les roles...',
	'Populating authored and published dates for entries...' => 'Mise en place des dates de creation et de publication des notes...',
	'Updating widget template records...' => 'Mise a jour des donnees du gabarit de widget...',
	'Classifying category records...' => 'Classement des donnees des categories...',
	'Classifying entry records...' => 'Classement des donnees des notes...',
	'Merging comment system templates...' => 'Assemblage des gabarits du systeme de commentaire...',
	'Populating default file template for templatemaps...' => 'Mise en place du fichier gabarit par defaut pour les tables de correspondances de gabarits...',
	'Removing unused template maps...' => 'Suppression des tables de correspondances de gabarits non-utilises...',
	'Assigning user authentication type...' => 'Attribution du type d\'authentification utilisateur...',
	'Adding new feature widget to dashboard...' => 'Ajout du nouveau widget au tableau de bord...',
	'Moving OpenID usernames to external_id fields...' => 'Deplacement des identifiants OpenID vers les champs external_id...',
	'Assigning blog template set...' => 'Attribution du groupe de gabarits de blogs...',
	'Assigning blog page layout...' => 'Attribution de la mise en page du blog...',
	'Assigning author basename...' => 'Attribution du nom de base de l\'auteur...',
	'Assigning embedded flag to asset placements...' => 'Attribution des drapeaux embarques vers la gestion d\'elements...',
	'Updating template build types...' => 'Mise a jour des types de construction de gabarits...',
	'Replacing file formats to use CategoryLabel tag...' => 'Remplacement des formats de fichiers pour utiliser le tag CategoryLabel...',

## lib/MT/Core.pm
	'Create Blogs' => 'Creer des blogs',
	'Manage Plugins' => 'Gerer les plugins',
	'Manage Templates' => 'Gerer les gabarits',
	'View System Activity Log' => 'Afficher le journal (logs) du systeme',
	'Configure Blog' => 'Configurer le blog',
	'Set Publishing Paths' => 'Regler les chemins de publication',
	'Manage Categories' => 'Gerer les categories',
	'Manage Tags' => 'Gerer les tags',
	'Manage Address Book' => 'Gestion de l\'annuaire',
	'View Activity Log' => 'Afficher le journal (logs)',
	'Manage Users' => 'Gerer les Utilisateurs',
	'Create Entries' => 'Creation d\'une note',
	'Publish Entries' => 'Publier les notes',
	'Send Notifications' => 'Envoyer des notifications',
	'Edit All Entries' => 'Editer toutes les entrees',
	'Manage Pages' => 'Gerer les pages',
	'Publish Blog' => 'Publier le Blog',
	'Save Image Defaults' => 'Enregistrer les parametres d\'images par defaut',
	'Manage Assets' => 'Gerer les Elements',
	'Post Comments' => 'Commentaires de la note',
	'Manage Feedback' => 'Gerer les retours',
	'Error creating performance logs directory, [_1]. Please either change the permissions to make it writable or specify an alternate using the PerformanceLoggingPath configuration directive: [_2]' => 'Erreur dans la creation du repertoire pour les logs de performance, [_1]. Vous pouvez soit changer ses permissions pour qu\'il soit accessible en ecriture, soit utiliser la directive de configuration PerformanceLoggingPath: [_2]',
	'Error creating performance logs: PerformanceLoggingPath setting must be a directory path, not a file: [_1]' => 'Erreur dans la creation de logs de performance : PerformanceLoggingPath doit etre un chemin de repertoire et non un fichier : [_1]',
	'Error creating performance logs: PerformanceLoggingPath directory exists but is not writeable: [_1]' => 'Erreur dans la creation de logs de performance : PerformanceLoggingPath existe mais n\'est pas accessible a  l\'ecriture : [_1]',
	'MySQL Database' => 'Base de donnees MySQL',
	'PostgreSQL Database' => 'Base de donnees PostgreSQL',
	'SQLite Database' => 'Base de donnees SQLite',
	'SQLite Database (v2)' => 'Base de donnees SQLite (v2)',
	'Convert Line Breaks' => 'Conversion retours ligne',
	'Rich Text' => 'Texte Enrichi',
	'Movable Type Default' => 'Valeur par Defaut Movable Type',
	'weblogs.com' => 'weblogs.com',
	'technorati.com' => 'technorati.com',
	'google.com' => 'google.com',
	'Classic Blog' => 'Blog classique',
	'Publishes content.' => 'Publication de contenu.',
	'Synchronizes content to other server(s).' => 'Synchronise le contenu vers d\'autres serveurs.',
	'zip' => 'zip',
	'tar.gz' => 'tar.gz',
	'Entries List' => 'Liste des notes',
	'Blog URL' => 'URL du blog',
	'Blog ID' => 'ID du blog',
	'Entry Excerpt' => 'Extrait de la note',
	'Entry Link' => 'Lien de la note',
	'Entry Extended Text' => 'Texte etendu de la note',
	'Entry Title' => 'Titre de la note',
	'If Block' => 'Bloc If',
	'If/Else Block' => 'Bloc If/Else',
	'Include Template Module' => 'Inclure un module de gabarit',
	'Include Template File' => 'Inclure un fichier de gabarit',
	'Get Variable' => 'Recuperer la variable',
	'Set Variable' => 'Specifier la variable',
	'Set Variable Block' => 'Specifier le bloc de variable',
	'Widget Set' => 'Groupe de widgets',
	'Publish Scheduled Entries' => 'Publier les notes planifiees',
	'Junk Folder Expiration' => 'Expiration du repertoire de spam',
	'Remove Temporary Files' => 'Supprimer les fichiers temporaires',
	'Remove Expired User Sessions' => 'Supprimer les sessions utilisateur expirees',
	'Remove Expired Search Caches' => 'Supprimer les caches des recherches expirees',

## lib/MT/App/NotifyList.pm
	'Please enter a valid email address.' => 'Veuillez entrer une adresse e-mail valide.',
	'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Il manque un parametre requis : blog_id. Veuillez consulter le manuel d\'utilisateur pour configurer les notifications.',
	'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Vous avez fourni un parametre de redirection non valide. Le proprietaire du blog doit specifier le chemin qui correspond au nom de domaine du blog.',
	'The email address \'[_1]\' is already in the notification list for this weblog.' => 'L\'adresse e-mail \'[_1]\' fait deja parti de la liste de notification pour ce blog.',
	'Please verify your email to subscribe' => 'Merci de verifier votre email pour souscrire',
	'_NOTIFY_REQUIRE_CONFIRMATION' => 'Un email a ete envoye a [_1]. Pour valider votre inscription, merci de cliquer sur le lien qui figure dans cet email. Il permettra de verifier que votre adresse email est valable.',
	'The address [_1] was not subscribed.' => 'L\'adresse [_1] n\'a pas ete souscrite.',
	'The address [_1] has been unsubscribed.' => 'L\'adresse [_1] a ete supprimee.',

## lib/MT/App/Comments.pm
	'Error assigning commenting rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable commenting role was found.' => 'Erreur en assignant les droits de commenter a l\'utilisateur \'[_1] (ID: [_2])\' pour le blog \'[_3] (ID: [_4])\'. Aucun role de commentaire adequat n\'a ete trouve.',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Tentative d\'identification echouee pour l\'auteur de commentaires [_1] sur le blog [_2](ID: [_3]) qui n\'autorise pas l\'authentification native de Movable Type.',
	'Invalid login.' => 'Identifiant invalide.',
	'Invalid login' => 'Login invalide',
	'Successfully authenticated but signing up is not allowed.  Please contact system administrator.' => 'Identification reussie mais l\'enregistrement n\'est pas autorise. Merci de contacter votre administrateur systeme.',
	'You need to sign up first.' => 'Vous devez vous enregistrer d\'abord.',
	'Login failed: permission denied for user \'[_1]\'' => 'Identification echouee: autorisation interdite pour l\'utilisateur \'[_1]\'',
	'Login failed: password was wrong for user \'[_1]\'' => 'Identification echouee: mot de passe incorrect pour l\'utilisateur \'[_1]\'',
	'Failed login attempt by disabled user \'[_1]\'' => 'Echec de tentative  d\'identification par utilisateur desactive \'[_1]\' ',
	'Failed login attempt by unknown user \'[_1]\'' => 'Echec de tentative d\'identification par utilisateur inconnu\'[_1]\'',
	'Signing up is not allowed.' => 'Enregistrement non autorisee.',
	'Movable Type Account Confirmation' => 'Confirmation de compte Movable Type',
	'System Email Address is not configured.' => 'Adresse Email du Systeme non configuree.',
	'Commenter \'[_1]\' (ID:[_2]) has been successfully registered.' => 'L\'auteur de commentaires \'[_1]\' (ID:[_2]) a ete enregistre avec succes.',
	'Thanks for the confirmation.  Please sign in to comment.' => 'Merci pour la confirmation. Merci de vous identifier pour commenter.',
	'[_1] registered to the blog \'[_2]\'' => '[_1] est enregistre sur le blog \'[_2]\'',
	'No id' => 'pas d\'id',
	'No such comment' => 'Pas de commentaire de la sorte',
	'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'l\'IP [_1] a ete bannie car elle a envoye plus de 8 commentaires en  [_2] seconds.',
	'IP Banned Due to Excessive Comments' => 'IP bannie pour cause de commentaires excessifs',
	'No entry_id' => 'Pas de note_id',
	'No such entry \'[_1]\'.' => 'Aucune Note \'[_1]\'.',
	'_THROTTLED_COMMENT' => 'Dans le but de reduire les possibilites d\'abus, Nous avons active une fonction obligeant les auteurs de commentaires a attendre quelques instants avant de publier un autre commentaire. Veuillez attendre quelques instants avant de publier un autre commentaire. Merci.',
	'Comments are not allowed on this entry.' => 'Les commentaires ne sont pas autorises sur cette Note.',
	'Comment text is required.' => 'Le texte de commentaire est requis.',
	'Registration is required.' => 'L\'inscription est requise.',
	'Name and email address are required.' => 'Le nom et l\'e-mail sont requis.',
	'Invalid email address \'[_1]\'' => 'Adresse e-mail invalide \'[_1]\'',
	'Invalid URL \'[_1]\'' => 'URL invalide \'[_1]\'',
	'Text entered was wrong.  Try again.' => 'Le texte saisi est errone.  Essayez a nouveau',
	'Comment save failed with [_1]' => 'La sauvegarde du commentaire a echoue [_1]',
	'Comment on "[_1]" by [_2].' => 'Commentaire sur "[_1]" par [_2].',
	'Failed comment attempt by pending registrant \'[_1]\'' => 'Tentative de commentaire echouee par utilisateur  \'[_1]\' en cours d\'inscription',
	'The sign-in attempt was not successful; please try again.' => 'La tentative d\'enregistrement a echoue; veuillez essayer de nouveau.',
	'No entry was specified; perhaps there is a template problem?' => 'Aucune note n\'a ete specifiee; peut-etre y a-t-il un probleme de gabarit?',
	'Somehow, the entry you tried to comment on does not exist' => 'Il semble que la note que vous souhaitez commenter n\'existe pas',
	'Invalid entry ID provided' => 'ID de note fourni invalide',
	'All required fields must have valid values.' => 'Tous les champs obligatoires doivent avoir des valeurs valides.',
	'Passwords do not match.' => 'Les mots de passe ne sont pas identiques.',
	'Commenter profile has successfully been updated.' => 'Le profil de l\'auteur de commentaires a ete modifie avec succes.',
	'Commenter profile could not be updated: [_1]' => 'Le profil de l\'auteur de commentaires n\'a pu etre modifie: [_1]',

## lib/MT/App/Search.pm
	'Invalid [_1] parameter.' => 'Parametre [_1] invalide',
	'Invalid type: [_1]' => 'Type invalide : [_1]',
	'Search: failed storing results in cache.  [_1] is not available: [_2]' => 'Recherche : echec sur stockage des resultats en cache. [_1] n\'est pas disponible : [_2]',
	'Invalid format: [_1]' => 'Format invalide : [_1]',
	'Unsupported type: [_1]' => 'Type non supporte : [_1]',
	'Invalid query: [_1]' => 'Requete non valide : [_1]',
	'Invalid value: [_1]' => 'Valeur invalide : [_1]',
	'No column was specified to search for [_1].' => 'Aucune colonne specifiee a la recherche de [_1].',
	'Search: query for \'[_1]\'' => 'Recherche : requete pour \'[_1]\'',
	'No alternate template is specified for the Template \'[_1]\'' => 'Pas de gabarit alternatif specifie pour le gabarit \'[_1]\'',
	'Opening local file \'[_1]\' failed: [_2]' => 'L\'ouverture du fichier local \'[_1]\' a echoue: [_2]',
	'The search you conducted has timed out.  Please simplify your query and try again.' => 'La recherche que vous avez effectue a expire. Merci de simplifier votre requete et reessayer.',

## lib/MT/App/Trackback.pm
	'Invalid entry ID \'[_1]\'' => 'ID de Note invalide \'[_1]\'',
	'You must define a Ping template in order to display pings.' => 'Vous devez definir un gabarit d\'affichage Ping pour les afficher.',
	'Trackback pings must use HTTP POST' => 'Les Pings trackback doivent utiliser HTTP POST',
	'Need a TrackBack ID (tb_id).' => 'Un ID de Trackback est requis (tb_id).',
	'Invalid TrackBack ID \'[_1]\'' => 'L\'ID de Trackback \'[_1]\' est invalide',
	'You are not allowed to send TrackBack pings.' => 'You n\'etes pas autorise a envoyer des pings trackback.',
	'You are pinging trackbacks too quickly. Please try again later.' => 'Vous pinguez les trackbacks trop rapidement. Merci d\'essayer plus tard.',
	'Need a Source URL (url).' => 'Une URL source est requise (url).',
	'This TrackBack item is disabled.' => 'Cet element trackback est desactive.',
	'This TrackBack item is protected by a passphrase.' => 'Cet element de trackback est protege par un mot de passe.',
	'TrackBack on "[_1]" from "[_2]".' => 'Trackback sur "[_1]" provenant de "[_2]".',
	'TrackBack on category \'[_1]\' (ID:[_2]).' => 'Trackback sur la categorie \'[_1]\' (ID:[_2]).',
	'Can\'t create RSS feed \'[_1]\': ' => 'Impossible de creer le flux RSS \'[_1]\': ',
	'New TrackBack Ping to Entry [_1] ([_2])' => 'Nouveau trackback pour la note [_1] ([_2])',
	'New TrackBack Ping to Category [_1] ([_2])' => 'Nouveau trackback pour la categorie [_1] ([_2])',

## lib/MT/App/Upgrader.pm
	'Failed to authenticate using given credentials: [_1].' => 'L\'authentification a echoue en utilisant les informations communiquees [_1].',
	'You failed to validate your password.' => 'Echec lors de la validation du mot de passe.',
	'You failed to supply a password.' => 'Vous n\'avez pas donne de mot de passe.',
	'The e-mail address is required.' => 'L\'adresse email est requise.',
	'The path provided below is not writable.' => 'Le chemin ci-dessous n\'est pas ouvert en ecriture',
	'Invalid session.' => 'Session invalide.',
	'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Pas d\'autorisation. Contactez votre administrateur systeme Movable Type pour modifier vos privileges.',
	'Movable Type has been upgraded to version [_1].' => 'Movable Type a ete mis a jour a la version [_1].',

## lib/MT/App/Search/Legacy.pm
	'You are currently performing a search. Please wait until your search is completed.' => 'Vous etes en train d\'effectuer une recherche. Merci d\'attendre que la recherche soit finie.',
	'Search failed. Invalid pattern given: [_1]' => 'Echec de la recherche. Comportement non valide : [_1]',
	'Search failed: [_1]' => 'Echec lors de la recherche : [_1]',
	'Publishing results failed: [_1]' => 'Echec de la publication des resultats: [_1]',
	'Search: new comment search' => 'Recherche : recherche de nouveaux commentaires',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearch fonctionne avec MT::App::Search.',

## lib/MT/App/Wizard.pm
	'The [_1] database driver is required to use [_2].' => 'Le driver de base de donnees [_1] est obligatoire pour utiliser [_2].',
	'The [_1] driver is required to use [_2].' => 'Le driver [_1] est obligatoire pour utiliser [_2].',
	'An error occurred while attempting to connect to the database.  Check the settings and try again.' => 'Une erreur s\'est produite en essayant de se connecter a la base de donnees. Verifiez les parametres et essayez a nouveau.',
	'SMTP Server' => 'Serveur SMTP',
	'Sendmail' => 'Sendmail',
	'Test email from Movable Type Configuration Wizard' => 'Test email a partir de l\'Assistant de Configuration de Movable Type',
	'This is the test email sent by your new installation of Movable Type.' => 'Ceci est un email de test envoye par votre nouvelle installation Movable Type.',
	'This module is needed to encode special characters, but this feature can be turned off using the NoHTMLEntities option in mt-config.cgi.' => 'Ce module est necessaire pour encoder les caracteres speciaux, mais cette option peut etre desactivee en utilisant NoHTMLEntities dans mt-config.cgi.',
	'This module is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'Ce module est necessaire si vous souhaitez utiliser le systeme de trackback, les pings weblogs.com, ou le ping Mises a jour recentes MT.',
	'HTML::Parser is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'HTML::Parser est optionnel. Il est utilisie si vous souhaitez utiliser le systeme de trackback, le ping weblogs.com ou le ping des mises a jours recentes MT.',
	'This module is needed if you wish to use the MT XML-RPC server implementation.' => 'Ce module est necessaire si vous souhaitez utiliser l\'implementation du serveur XML-RPC MT.',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Ce module est necessaire si vous voulez pouvoir ecraser les fichiers existants lorsque vous envoyez un nouveau fichier.',
	'List::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'List:Util est optionnel; Il est necessaire si vous souhaitez utiliser les possibilites de publications en mode file d\'attente',
	'Scalar::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'Scalar::Util est optionnel; Il est necessaire uniquement si vous souhaitez utiliser la fonction de file d\'attente de publication.',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Ce module est necessaire si vous souhaitez pouvoir creer des vignettes pour les images envoyees.',
	'This module is needed if you would like to be able to use NetPBM as the image driver for MT.' => 'Ce module est necessaire si vous souhaitez pouvoir utiliser NetPBM comme pilote d\'image pour MT.',
	'This module is required by certain MT plugins available from third parties.' => 'Ce module est necessaire pour certains plugins MT disponibles aupres de partenaires.',
	'This module accelerates comment registration sign-ins.' => 'Ce module accelere les enregistrements des auteurs de commentaires.',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers such as AOL and Yahoo! which require SSL support.' => 'Ce module et ses dependances sont necessaires afin de permettre aux auteurs de commentaires d\'etre authentifies par des fournisseurs OpenID comme AOL ou Yahoo! qui necessitent SSL.',
	'This module is needed to enable comment registration.' => 'Ce module est necessaire pour activer l\'enregistrement des auteurs de commentaires.',
	'This module enables the use of the Atom API.' => 'Ce module active l\'utilisation de l\'API Atom.',
	'This module is required in order to archive files in backup/restore operation.' => 'Ce module est necessaire pour archiver les fichiers lors des operations de sauvegarde/restauration.',
	'This module is required in order to compress files in backup/restore operation.' => 'Ce module est necessaire pour compresser les fichiers lors des operations de sauvegarde et restauration.',
	'This module is required in order to decompress files in backup/restore operation.' => 'Ce module est necessaire pour decompresser les fichiers lors d\'une operation de sauvegarde/restauration.',
	'This module and its dependencies are required in order to restore from a backup.' => 'Ce module et ses dependances sont necessaires pour restaurer les fichiers a partir d\'une sauvegarde.',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including Vox and LiveJournal.' => 'Ce module et ses dependances sont obligatoires pour permettre aux auteurs de commentaires d\'etre authentifies par des fournisseurs OpenID comme Vox et LiveJournal.',
	'This module is required for sending mail via SMTP Server.' => 'Ce module est necessaire pour envoyer des emails via un serveur SMTP.',
	'This module is used in test attribute of MTIf conditional tag.' => 'Ce module est utilise dans l\'attribut de test du tag conditionnel MTIf.',
	'This module is used by the Markdown text filter.' => 'Ce module est utilise par le filtre de texte Markdown',
	'This module is required in mt-search.cgi if you are running Movable Type on Perl older than Perl 5.8.' => 'Ce module est necessaire pour mt-search.cgi si vous utilisez Movable Type sur une version de Perl superieur a 5.8.',
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Ce module est necessaire pour les envois de fichiers (pour determiner la taille des images dans differents formats).',
	'This module is required for cookie authentication.' => 'Ce module est necessaire pour l\'authentification par cookies.',
	'DBI is required to store data in database.' => 'DBI est necessaire pour enregistrer les donnees en base de donnees.',
	'CGI is required for all Movable Type application functionality.' => 'CGI est necessaire pour toutes les fonctionnalites de l\'application Movable Type.',
	'File::Spec is required for path manipulation across operating systems.' => 'File::Spec est necessaire pour manipuler les chemins de fichiers sur differents systemes d\'exploitation.',

## lib/MT/App/Viewer.pm
	'Loading blog with ID [_1] failed' => 'Echec lors du chargement du blog ayant pour ID [_1] ',
	'Template publishing failed: [_1]' => 'Echec lors de la publication du gabarit : [_1]',
	'Invalid date spec' => 'Specifications de dates invalides',
	'Can\'t load templatemap' => 'Impossible de charger la table de correspondance des gabarits',
	'Can\'t load template [_1]' => 'Impossible de charger le gabarit [_1]',
	'Archive publishing failed: [_1]' => 'Echec lors de la publication de l\'archive : [_1]',
	'Invalid entry ID [_1]' => ' ID de la note invalide : [_1]',
	'Entry [_1] is not published' => 'La note [_1] n\'est pas publiee',
	'Invalid category ID \'[_1]\'' => 'ID de categorie invalide : \'[_1]\'',

## lib/MT/App/CMS.pm
	'_WARNING_PASSWORD_RESET_MULTI' => 'Vous etes sur le point d\'envoyer des emails pour permettre aux utilisateurs selectionnes de reinitialiser leurs mots de passe. Voulez-vous continuer ?',
	'_WARNING_DELETE_USER_EUM' => 'Supprimer un utilisateur est une action definitive qui va rendre des notes orphelines. Si vous voulez retirer un utilisateur ou lui supprimer ses acces nous vous recommandons de desactiver son compte. Etes-vous sur(e) de vouloir supprimer cet utilisateur ? Attention, il pourra se creer un nouvel acces s\'il existe encore dans le repertoire externe',
	'_WARNING_DELETE_USER' => 'Supprimer un utilisateur est une action definitive qui va rendre des notes orphelines. Si vous souhaitez retirer un utilisateur ou lui supprimer ses acces nous vous recommandons de desactiver son compte. Etes-vous sur(e) de vouloir supprimer cet utilisateur ?',
	'_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' => 'Cette action retablira les gabarits par defaut pour le(s) blog(s) selectionne(s). Etes-vous sur de vouloir rafraichir les gabarits de ce(s) blog(s) ?',
	'Published [_1]' => '[_1] publiees',
	'Unpublished [_1]' => '[_1] non-publiees',
	'Scheduled [_1]' => '[_1] programmees',
	'My [_1]' => 'Mes [_1]',
	'[_1] with comments in the last 7 days' => '[_1] avec des commentaires dans les 7 derniers jours',
	'[_1] posted between [_2] and [_3]' => '[_1] postees entre le [_2] et le [_3]',
	'[_1] posted since [_2]' => '[_1] postees depuis [_2]',
	'[_1] posted on or before [_2]' => '[_1] postees le ou avant le [_2]',
	'All comments by [_1] \'[_2]\'' => 'Tous les commentaires par [_1] \'[_2]\'',
	'All comments for [_1] \'[_2]\'' => 'Tous les commentaires pour [_1] \'[_2]\'',
	'Comments posted between [_1] and [_2]' => 'Commentaires postes entre [_1] et [_2]',
	'Comments posted since [_1]' => 'Commentaires deposes depuis [_1]',
	'Comments posted on or before [_1]' => 'Commentaires postes le ou avant le [_1]',
	'You are not authorized to log in to this blog.' => 'Vous n\'etes pas autorise a vous connecter sur ce blog.',
	'No such blog [_1]' => 'Aucun blog ne porte le nom [_1]',
	'Edit Template' => 'Modifier un gabarit',
	'Unknown object type [_1]' => 'Objet de type [_1] inconnu',
	'Error during publishing: [_1]' => 'Erreur pendant la publication : [_1]',
	'This is You' => 'C\'est vous',
	'Handy Shortcuts' => 'Raccourcis pratiques',
	'Movable Type News' => 'Actualites Movable Type',
	'Blog Stats' => 'Statistiques du blog',
	'Refresh Blog Templates' => 'Mettre a jour les gabarits du blog',
	'Refresh Global Templates' => 'Mettre a jour les gabarits globaux',
	'Use Publishing Profile' => 'Utiliser un Profil de Publication',
	'Unpublish Entries' => 'Annuler publication',
	'Add Tags...' => 'Ajouter des tags...',
	'Tags to add to selected entries' => 'Tags a ajouter aux notes selectionnees',
	'Remove Tags...' => 'Enlever les tags...',
	'Tags to remove from selected entries' => 'Tags a enlever des notes selectionnees',
	'Batch Edit Entries' => 'Modifier des notes par lot',
	'Unpublish Pages' => 'Depublier les pages',
	'Tags to add to selected pages' => 'Tags a ajouter aux pages selectionnees',
	'Tags to remove from selected pages' => 'Tags a supprimer des pages selectionnees',
	'Batch Edit Pages' => 'Modifier les pages en masse',
	'Tags to add to selected assets' => 'Tags a ajouter aux elements selectionnes',
	'Tags to remove from selected assets' => 'Tags a supprimer les elements selectionnes',
	'Unpublish TrackBack(s)' => 'Annuler la publication de ce (ou ces) trackbacks(s)',
	'Unpublish Comment(s)' => 'Annuler la publication de ce (ou ces) commentaire(s)',
	'Trust Commenter(s)' => 'Donner le statut fiable a cet auteur de commentaires',
	'Untrust Commenter(s)' => 'Retirer le statut fiable a cet auteur de commentaires',
	'Ban Commenter(s)' => 'Bannir cet auteur de commentaires',
	'Unban Commenter(s)' => 'Lever le bannissement cet auteur de commentaires',
	'Recover Password(s)' => 'Recuperer le(s) mot(s) de passe',
	'Delete' => 'Supprimer',
	'Refresh Template(s)' => 'Actualiser le(s) Gabarit(s)',
	'Publish Template(s)' => 'Publier le(s) Gabarit(s)',
	'Clone Template(s)' => 'Cloner le(s) Gabarit(s)',
	'Non-spam TrackBacks' => 'Trackbacks marques comme n\'etant pas du spam',
	'TrackBacks on my entries' => 'Trackbacks sur mes entrees',
	'Published TrackBacks' => 'Trackbacks publies',
	'Unpublished TrackBacks' => 'Tracbacks non publies',
	'TrackBacks marked as Spam' => 'Trackbacks marques comme spam',
	'All TrackBacks in the last 7 days' => 'Tous les trackbacks des 7 derniers jours',
	'Non-spam Comments' => 'Commentaires marques comme n\'etant pas du spam',
	'Comments on my entries' => 'Commentaires sur mes notes',
	'Pending comments' => 'Commentaires en attente',
	'Spam Comments' => 'Commentaires marques comme etant du spam',
	'Published comments' => 'Commentaires publies.',
	'Comments in the last 7 days' => 'Commentaires des 7 derniers jours',
	'Tags with entries' => 'Tags avec les notes',
	'Tags with pages' => 'Tags avec les pages',
	'Tags with assets' => 'Tags avec les elements',
	'Enabled Users' => 'Utilisateurs actives',
	'Disabled Users' => 'Utilisateurs desactives',
	'Pending Users' => 'Utilisateurs en attente',
	'Create' => 'Creer',
	'Manage' => 'Gerer',
	'Design' => 'Design',
	'Preferences' => 'Preferences',
	'Tools' => 'Outils',
	'Folders' => 'Repertoires',
	'Address Book' => 'Carnet d\'adresses',
	'Widgets' => 'Widgets',
	'General' => 'General',
	'Feedback' => 'Feedback',
	'Registration' => 'Enregistrement',
	'Web Services' => 'Services Web',
	'Plugins' => 'Plugins',
	'Import' => 'Importer',
	'Export' => 'Exporter',
	'System Information' => 'Informations systeme',
	'System Overview' => 'Vue d\'ensemble',

## lib/MT/App/ActivityFeeds.pm
	'Error loading [_1]: [_2]' => 'Erreur lors du chargement chargement [_1] : [_2]',
	'An error occurred while generating the activity feed: [_1].' => 'Une erreur est survenue lors de la generation du flux d\'activite : [_1].',
	'[_1] Weblog TrackBacks' => 'Trackbacks du blog [_1] ',
	'All Weblog TrackBacks' => 'Tous les trackbacks du blog',
	'[_1] Weblog Comments' => 'Commentaires du blog [_1] ',
	'All Weblog Comments' => 'Tous les commentaires du blog',
	'[_1] Weblog Entries' => 'Notes du blog [_1] ',
	'All Weblog Entries' => 'Toutes les notes du blog ',
	'[_1] Weblog Activity' => 'Activite du blog [_1] ',
	'All Weblog Activity' => 'Toutes l\'activite du blog',
	'Movable Type System Activity' => 'Activite du systeme Movable Type',
	'Movable Type Debug Activity' => 'Activite de debogage Movable Type',
	'[_1] Weblog Pages' => 'Pages du blog [_1]',
	'All Weblog Pages' => 'Toutes les pages du blog',

## lib/MT/ObjectTag.pm
	'Tag Placement' => 'Gestion des tags',
	'Tag Placements' => 'Gestions des tags',

## lib/MT/Author.pm
	'The approval could not be committed: [_1]' => 'L\'approbation ne peut etre realisee : [_1]',

## lib/MT/Util/Archive/Tgz.pm
	'Type must be tgz.' => 'Le type doit etre tgz.',
	'Could not read from filehandle.' => 'Impossible de lire le fichier.',
	'File [_1] is not a tgz file.' => 'Le fichier [_1] n\'est pas un fichier tgz.',
	'File [_1] exists; could not overwrite.' => 'Le fichier [_1] existe; impossible de l\'ecraser.',
	'Can\'t extract from the object' => 'Impossible d\'extraire l\'objet',
	'Can\'t write to the object' => 'Impossible d\'ecrire l\'objet',
	'Both data and file name must be specified.' => 'Les donnees et le fichier doivent etre specifies.',

## lib/MT/Util/Archive/Zip.pm
	'Type must be zip' => 'Le type doit etre zip',
	'File [_1] is not a zip file.' => 'Le fichier [_1] n\'est pas un fichier zip.',

## lib/MT/Util/Archive.pm
	'Type must be specified' => 'Le type doit etre specifie',
	'Registry could not be loaded' => 'Le registre n\'a pu etre charge',

## lib/MT/Util/Captcha.pm
	'Movable Type default CAPTCHA provider requires Image::Magick.' => 'Le fournisseur de CAPTCHA par defaut de Movable Type necessite Image::Magick.',
	'You need to configure CaptchaSourceImageBase.' => 'Vous devez configurer CaptchaSourceImagebase.',
	'Image creation failed.' => 'Creation de l\'image echouee.',
	'Image error: [_1]' => 'Erreur image : [_1]',

## lib/MT/Scorable.pm
	'Object must be saved first.' => 'L\'objet doit etre d\'abord sauvegarde.',
	'Already scored for this object.' => 'Cet objet a deja ete note',
	'Could not set score to the object \'[_1]\'(ID: [_2])' => 'Impossible de stocker le score de l\'objet \'[_1]\'(ID: [_2])',

## lib/MT/XMLRPC.pm
	'No WeblogsPingURL defined in the configuration file' => 'Pas de WeblogsPingURL defini dans le fichier de configuration',
	'No MTPingURL defined in the configuration file' => 'Pas de MTPingURL defini dans le fichier de configuration',
	'HTTP error: [_1]' => 'Erreur HTTP: [_1]',
	'Ping error: [_1]' => 'Erreur Ping: [_1]',

## lib/MT/Config.pm
	'Configuration' => 'Configuration',

## lib/MT/ObjectAsset.pm
	'Asset Placement' => 'Gestion des objets',

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
	'CATEGORY_ADV' => 'par categories',
	'category/sub-category/index.html' => 'categorie/sous-categorie/index.html',
	'category/sub_category/index.html' => 'categorie/sous_categorie/index.html',

## lib/MT/ArchiveType/AuthorMonthly.pm
	'AUTHOR-MONTHLY_ADV' => 'par auteurs et semaines',
	'author/author-display-name/yyyy/mm/index.html' => 'auteur/auteur-nom-affichage/aaaa/mm/index.html',
	'author/author_display_name/yyyy/mm/index.html' => 'auteur/auteur_nom_affichage/aaaa/mm/index.html',

## lib/MT/ArchiveType/AuthorWeekly.pm
	'AUTHOR-WEEKLY_ADV' => 'par auteurs et annees',
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
	'CATEGORY-MONTHLY_ADV' => 'par categories et mois',
	'category/sub-category/yyyy/mm/index.html' => 'categorie/sous-categorie/aaaa/mm/index.html',
	'category/sub_category/yyyy/mm/index.html' => 'categorie/sous_categorie/aaaa/mm/index.html',

## lib/MT/ArchiveType/AuthorYearly.pm
	'AUTHOR-YEARLY_ADV' => 'par auteurs et annees',
	'author/author-display-name/yyyy/index.html' => 'auteur/auteur-nom-affichage/aaaa/index.html',
	'author/author_display_name/yyyy/index.html' => 'auteur/auteur_nom_affichage/aaaa/index.html',

## lib/MT/ArchiveType/Monthly.pm
	'MONTHLY_ADV' => 'mensuelles',
	'yyyy/mm/index.html' => 'aaaa/mm/index.html',

## lib/MT/ArchiveType/CategoryWeekly.pm
	'CATEGORY-WEEKLY_ADV' => 'par categories et semaines',
	'category/sub-category/yyyy/mm/day-week/index.html' => 'categorie/sous-categorie/aaaa/mm/jour-semaine/index.html',
	'category/sub_category/yyyy/mm/day-week/index.html' => 'categorie/sous_categorie/aaaa/mm/jour-semaine/index.html',

## lib/MT/ArchiveType/Weekly.pm
	'WEEKLY_ADV' => 'hebdomadaires',
	'yyyy/mm/day-week/index.html' => 'aaaa/mm/jour-semaine/index.html',

## lib/MT/ArchiveType/CategoryDaily.pm
	'CATEGORY-DAILY_ADV' => 'par categories et jours',
	'category/sub-category/yyyy/mm/dd/index.html' => 'categorie/sous-categorie/aaaa/mm/jj/index.html',
	'category/sub_category/yyyy/mm/dd/index.html' => 'categorie/sous_categorie/aaa/mm/jj/index.html',

## lib/MT/ArchiveType/Daily.pm
	'DAILY_ADV' => 'journalieres',
	'yyyy/mm/dd/index.html' => 'aaaa/mm/jj/index.html',

## lib/MT/ArchiveType/Author.pm
	'AUTHOR_ADV' => 'par auteurs',
	'author/author-display-name/index.html' => 'auteur/auteur-nom-affichage/index.html',
	'author/author_display_name/index.html' => 'auteur/auteur_nom_affichage/index.html',

## lib/MT/ArchiveType/CategoryYearly.pm
	'CATEGORY-YEARLY_ADV' => 'par categories et annees',
	'category/sub-category/yyyy/index.html' => 'categorie/sous-categorie/aaaa/index.html',
	'category/sub_category/yyyy/index.html' => 'categorie/sous_categorie/aaaa/index.html',

## lib/MT/App.pm
	'Invalid request: corrupt character data for character set [_1]' => 'Requete invalide : les donnees de ces caracteres sont corrompues pour ce jeu de caracteres [_1]',
	'First Weblog' => 'Premier Blog',
	'Error loading blog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => 'Erreur de chargement #[_1] concernant la creation Utilisateur. Veuillez verifier vos parametres NewUserTemplateBlogId.',
	'Error provisioning blog for new user \'[_1]\' using template blog #[_2].' => 'Erreur de creation du blog pour le nouvel utilisateur  \'[_1]\' utilisant le template #[_2].',
	'Error creating directory [_1] for blog #[_2].' => 'Erreur lors de la creation de la liste [_1] pour le blog #[_2].',
	'Error provisioning blog for new user \'[_1] (ID: [_2])\'.' => 'Erreur de creation du blog pour le nouvel utilisateur \'[_1] (ID: [_2])\'.',
	'Blog \'[_1] (ID: [_2])\' for user \'[_3] (ID: [_4])\' has been created.' => 'Le blog \'[_1] (ID: [_2])\' pour l\'utilisateur \'[_3] (ID: [_4])\' a ete cree.',
	'Error assigning blog administration rights to user \'[_1] (ID: [_2])\' for blog \'[_3] (ID: [_4])\'. No suitable blog administrator role was found.' => 'Erreur d\'assignation des droits pour l\'utilisateur \'[_1] (ID: [_2])\' pour le blog \'[_3] (ID: [_4])\'. Aucun role d\'administrateur adequat n\'a ete trouve.',
	'The login could not be confirmed because of a database error ([_1])' => 'L\'identifiant ne peut pas etre confirme en raison d\'une erreur de base de donnees ([_1])',
	'Our apologies, but you do not have permission to access any blogs within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Desole, mais vous n\'avez pas l\'authorisation d\'acceder aux blogs de cette installation. Si vous pensez qu\'il s\'agit d\'une erreur, merci de contacter votre administrateur Movable Type.',
	'This account has been disabled. Please see your system administrator for access.' => 'Ce compte a ete desactive. Merci de contacter votre administrateur systeme.',
	'Failed login attempt by pending user \'[_1]\'' => 'Tentative d\'identification echouee par l\'utilisateur en attente \'[_1]\'',
	'This account has been deleted. Please see your system administrator for access.' => 'Ce compte a ete supprime. Merci de contacter votre administrateur systeme.',
	'User cannot be created: [_1].' => 'L\'utilisateur n\'a pu etre cree: [_1].',
	'User \'[_1]\' has been created.' => 'L\'utilisateur \'[_1]\' a ete cree ',
	'User \'[_1]\' (ID:[_2]) logged in successfully' => 'L\'utilisateur \'[_1]\' (ID:[_2]) s\'est identifie correctement',
	'Invalid login attempt from user \'[_1]\'' => 'Tentative d\'authentification invalide de l\'utilisateur \'[_1]\'',
	'User \'[_1]\' (ID:[_2]) logged out' => 'L\'utilisateur \'[_1]\' (ID:[_2]) s\'est deconnecte',
	'User requires password.' => 'L\'utilisateur doit avoir un mot de passe.',
	'User requires display name.' => 'L\'utilisateur doit avoir un nom public.',
	'User requires username.' => 'L\'utilisateur doit avoir un nom d\'utilisateur.',
	'Something wrong happened when trying to process signup: [_1]' => 'Un probleme s\'est produit en essayant de soumettre l\'inscription: [_1]',
	'New Comment Added to \'[_1]\'' => 'Nouveau commentaire ajoute a \'[_1]\'',
	'Close' => 'Fermer',
	'The file you uploaded is too large.' => 'Le fichier telecharge est trop lourd.',
	'Unknown action [_1]' => 'Action inconnue [_1]',
	'Warnings and Log Messages' => 'Mises en gardes et entrees du Journal (logs)',
	'Removed [_1].' => '[_1] supprimes.',

## lib/MT/BackupRestore.pm
	'Backing up [_1] records:' => 'Sauvegarde des enregistrements [_1]:',
	'[_1] records backed up...' => '[_1] enregistrements sauvegardes...',
	'[_1] records backed up.' => '[_1] enregistrements sauvegardes.',
	'There were no [_1] records to be backed up.' => 'Il n\'y a pas d\'enregistrements [_1] a sauvegarder.',
	'Can\'t open directory \'[_1]\': [_2]' => 'Impossible d\'ouvrir le repertoire \'[_1]\' : [_2]',
	'No manifest file could be found in your import directory [_1].' => 'Aucun fichier manifest n\'a ete trouve dans votre repertoire d\'import [_1].',
	'Can\'t open [_1].' => 'Impossible d\'ouvrir [_1].',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'Le fichier manifest [_1] n\'est pas un fichier manifest de sauvegarde Movable Type.',
	'Manifest file: [_1]' => 'Fichier manifest : [_1]',
	'Path was not found for the file ([_1]).' => 'Le chemin n\'a pas ete trouve pour le fichier ([_1]).',
	'[_1] is not writable.' => '[_1] non editable.',
	'Copying [_1] to [_2]...' => 'Copie de [_1] vers [_2]...',
	'Failed: ' => 'Echec: ',
	'Restoring asset associations ... ( [_1] )' => 'Restauration les associations d\'elements ... ([_1])',
	'Restoring asset associations in entry ... ( [_1] )' => 'Restauration des associations d\'elements dans la note ... ([_1])',
	'Restoring asset associations in page ... ( [_1] )' => 'Restauration des associations d\'elements dans la page... ([_1])',
	'Restoring url of the assets ( [_1] )...' => 'Restauration de l\'url de l\'element ([_1]) ...',
	'Restoring url of the assets in entry ( [_1] )...' => 'Restauration de l\'url de l\'element dans la note ([_1]) ...',
	'Restoring url of the assets in page ( [_1] )...' => 'Restauration de l\'url de l\'element dans la page ([_1]) ...',
	'ID for the file was not set.' => 'L\'ID pour le fichier n\'a pas ete specifie.',
	'The file ([_1]) was not restored.' => 'Le fichier ([_1]) n\'a pas ete restaure.',
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
	'No default templates were found.' => 'Aucun gabarit par defaut trouve.',
	'Cloned blog... new id is [_1].' => 'Le nouvel identifiant du blog clone est [_1]',
	'Cloning permissions for blog:' => 'Clonage des autorisations du blog:',
	'[_1] records processed...' => '[_1] enregistrements effectues...',
	'[_1] records processed.' => '[_1] enregistrements effectues.',
	'Cloning associations for blog:' => 'Clonage des associations du blog:',
	'Cloning entries and pages for blog...' => 'Clonage des notes et pages du blog en cours...',
	'Cloning categories for blog...' => 'Clonage des categories du blog...',
	'Cloning entry placements for blog...' => 'Clonage des placements de notes du blog...',
	'Cloning comments for blog...' => 'Clonage des commentaires de blog...',
	'Cloning entry tags for blog...' => 'Clonage des tags de notes du blog...',
	'Cloning TrackBacks for blog...' => 'Clonage des trackbacks du blog...',
	'Cloning TrackBack pings for blog...' => 'Clonage des pings de trackback du blog...',
	'Cloning templates for blog...' => 'Clonage des gabarits du blog...',
	'Cloning template maps for blog...' => 'Clonage des tables de correspondances de gabarit du blog...',
	'blog' => 'Blog',
	'blogs' => 'Blogs',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: [_2][_3] de la regle [_4][_5]',
	'[_1]: [_2][_3] from test [_4]' => '[_1]: [_2][_3] du test [_4]',

## lib/MT/XMLRPCServer.pm
	'Invalid timestamp format' => 'Format de date invalide',
	'No web services password assigned.  Please see your user profile to set it.' => 'Aucun mot de passe associe aux services web. Merci de verifier votre profil utilisateur pour le definir.',
	'Requested permalink \'[_1]\' is not available for this page' => 'Le lien permanent requis  \'[_1]\' n\'est pas disponible pour cette page',
	'Saving folder failed: [_1]' => 'Echec lors de la sauvegarde du repertoire : [_1]',
	'No blog_id' => 'Pas de blog_id',
	'Invalid blog ID \'[_1]\'' => 'ID du blog invalide \'[_1]\'',
	'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => 'Valeur pour \'mt_[_1]\' doit etre 1 ou 0 (etait \'[_2]\')',
	'Not privileged to edit entry' => 'Non detenteur des droits d\'edition de notes',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'La note \'[_1]\' ([lc,_5] #[_2]) a ete supprimee par \'[_3]\' (utilisateur #[_4]) depuis xml-rpc',
	'Not privileged to get entry' => 'Non detenteur des droits de possession de notes',
	'Not privileged to set entry categories' => 'Non detenteur des droits d\'affectation des categories d\'une note',
	'Not privileged to upload files' => 'Non detenteur des droits de telechargement de fichiers',
	'No filename provided' => 'Aucun nom de fichier',
	'Error writing uploaded file: [_1]' => 'Erreur lors de l\'ecriture du fichier telecharge : [_1]',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Les methodes de gabarit ne sont pas implementees en raison d\'une difference entre l\'API Blogger et l\'API Movable Type.',

## lib/MT/TBPing.pm

## lib/MT/Template.pm
	'Template' => 'gabarit',
	'File not found: [_1]' => 'Fichier non trouve : [_1]',
	'Error reading file \'[_1]\': [_2]' => 'Erreur a la lecture du fichier \'[_1]\': [_2]',
	'Publish error in template \'[_1]\': [_2]' => 'Erreur de publication dans le gabarit \'[_1]\': [_2]',
	'Template with the same name already exists in this blog.' => 'Un gabarit avec le meme nom existe deja dans ce blog.',
	'You cannot use a [_1] extension for a linked file.' => 'Vous ne pouvez pas utiliser l\'extension [_1] pour un fichier joint.',
	'Opening linked file \'[_1]\' failed: [_2]' => 'L\'ouverture du fichier lie \'[_1]\' a echoue : [_2] ',
	'Index' => 'Index',
	'Category Archive' => 'Archive de categorie',
	'Comment Listing' => 'Liste des commentaires',
	'Ping Listing' => 'Liste des pings',
	'Comment Error' => 'Erreur de commentaire',
	'Uploaded Image' => 'Image chargee',
	'Module' => 'Module',
	'Widget' => 'Widget',

## lib/MT/Auth/TypeKey.pm
	'Sign in requires a secure signature.' => 'L\'identification necessite une signature securisee.',
	'The sign-in validation failed.' => 'La validation de l\'enregistrement a echoue.',
	'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Les auteurs de commentaires de ce blog doivent donner une adresse email. Si vous souhaitez le faire il faut vous enregistrer a nouveau et donner l\'autorisation au systeme d\'identification de recuperer votre adresse email',
	'Couldn\'t save the session' => 'Impossible de sauvegarder la session',
	'Couldn\'t get public key from url provided' => 'Impossible d\'avoir une clef publique',
	'No public key could be found to validate registration.' => 'Aucune cle publique n\'a ete trouvee pour valider l\'inscription.',
	'TypePad signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'La verification de signature TypePad a retourne [_1] en [_2] secondes en verifiant [_3] avec [_4]',
	'The TypePad signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'La signature TypePad a expire (de [_1] secondes). Veuillez verifier que l\'horloge de votre serveur est correctement reglee.',

## lib/MT/Auth/OpenID.pm
	'Could not load Net::OpenID::Consumer.' => 'Impossible de charger Net::OpenID::Consumer.',
	'The address entered does not appear to be an OpenID' => 'L\'adresse entree ne semble pas etre une adresse OpenID',
	'The text entered does not appear to be a web address' => 'L\'adresse entree ne semble pas etre une adresse de type URL',
	'Unable to connect to [_1]: [_2]' => 'Impossible de se connecter a [_1] : [_2]',
	'Could not verify the OpenID provided: [_1]' => 'La verification de l\'OpenID entre a echoue : [_1]',

## lib/MT/Auth/MT.pm
	'Failed to verify current password.' => 'Erreur lors de la verification du mot de passe.',

## lib/MT/ImportExport.pm
	'No Blog' => 'Pas de Blog',
	'Need either ImportAs or ParentAuthor' => 'ImportAs ou ParentAuthor sont necessaires',
	'Importing entries from file \'[_1]\'' => 'Importation des notes du fichier \'[_1]\'',
	'Creating new user (\'[_1]\')...' => 'Creation d\'un nouvel utilisateur (\'[_1]\')...',
	'Saving user failed: [_1]' => 'Echec lors de la sauvegarde de l\'utilisateur : [_1]',
	'Assigning permissions for new user...' => 'Mise en place des autorisations pour le nouvel utilisateur...',
	'Saving permission failed: [_1]' => 'Echec lors de la sauvegarde des droits des utilisateurs : [_1]',
	'Creating new category (\'[_1]\')...' => 'Creation d\'une nouvelle categorie (\'[_1]\')...',
	'Saving category failed: [_1]' => 'Echec lors de la sauvegarde des categories : [_1]',
	'Invalid status value \'[_1]\'' => 'Valeur du statut invalide \'[_1]\'',
	'Invalid allow pings value \'[_1]\'' => 'Valeur du ping invalide\'[_1]\'',
	'Can\'t find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.' => 'Impossible de trouver une note avec la date \'[_1]\'... abandon de ces commentaires, et passage a la note suivante.',
	'Importing into existing entry [_1] (\'[_2]\')' => 'Importation dans la note existante [_1] (\'[_2]\')',
	'Saving entry (\'[_1]\')...' => 'Enregistrement de la note (\'[_1]\')...',
	'ok (ID [_1])' => 'ok (ID [_1])',
	'Saving entry failed: [_1]' => 'Echec lors de la sauvegarde de la Note: [_1]',
	'Creating new comment (from \'[_1]\')...' => 'Creation d\'un nouveau commentaire (de \'[_1]\')...',
	'Saving comment failed: [_1]' => 'Echec lors de la sauvegarde du commentaire : [_1]',
	'Entry has no MT::Trackback object!' => 'La note n\'a pas d\'objet MT::Trackback !',
	'Creating new ping (\'[_1]\')...' => 'Creation d\'un nouveau ping (\'[_1]\')...',
	'Saving ping failed: [_1]' => 'Echec lors de la sauvegarde du ping : [_1]',
	'Export failed on entry \'[_1]\': [_2]' => 'Echec lors de l\'exportation sur la Note \'[_1]\' : [_2]',
	'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Format de date invalide \'[_1]\'; doit etre \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM est optionnel)',

## lib/MT/Builder.pm
	'<[_1]> at line [_2] is unrecognized.' => '<[_1]> a la ligne [_2] n\'est pas reconnu.',
	'<[_1]> with no </[_1]> on line #' => '<[_1]> sans </[_1]> a la ligne #',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]> sans </[_1]> a la ligne [_2].',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]> sans </[_1]> a la ligne [_2]',
	'Error in <mt[_1]> tag: [_2]' => 'Erreur dans le tag <mt[_1]> : [_2]',
	'Unknown tag found: [_1]' => 'Un tag inconnu a ete trouve : [_1]',

## lib/MT/JunkFilter.pm
	'Action: Junked (score below threshold)' => 'Action : Indesirable (score ci-dessous)',
	'Action: Published (default action)' => 'Action : Publie (action par defaut)',
	'Junk Filter [_1] died with: [_2]' => 'Filtre indesirable [_1] mort avec : [_2]',
	'Unnamed Junk Filter' => 'Filtre indesirable sans nom',
	'Composite score: [_1]' => 'Score composite : [_1]',

## lib/MT/Util.pm
	'moments from now' => 'maintenant',
	'[quant,_1,hour,hours] from now' => 'dans [quant,_1,heure,heures]',
	'[quant,_1,minute,minutes] from now' => 'dans [quant,_1,minute,minutes]',
	'[quant,_1,day,days] from now' => 'dans [quant,_1,jour,jours]',
	'less than 1 minute from now' => 'moins d\'une minute a partir de maintenant',
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

## lib/MT/TheSchwartz/Error.pm
	'Job Error' => 'Erreur de tache',

## lib/MT/TheSchwartz/FuncMap.pm
	'Job Function' => 'Fonction Tache',

## lib/MT/TheSchwartz/Job.pm
	'Job' => 'Tache',

## lib/MT/TheSchwartz/ExitStatus.pm
	'Job Exit Status' => 'Statut de fin de tache',

## lib/MT/Mail.pm
	'Unknown MailTransfer method \'[_1]\'' => 'Methode de transfert de mail inconnu \'[_1]\'',
	'Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]' => 'Pour envoyer des mails via SMTP, votre serveur doit avoir Mail::Sendmail installe: [_1]',
	'Error sending mail: [_1]' => 'Erreur lors de l\'envoi du mail : [_1]',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'Vous n\'avez pas un chemin valide vers sendmail sur votre machine. Peut-etre devriez-vous essayer en utilisant SMTP?',
	'Exec of sendmail failed: [_1]' => 'Echec lors de l\'execution de sendmail : [_1]',

## lib/MT/ObjectScore.pm
	'Object Score' => 'Score Objet',
	'Object Scores' => 'Scores Objet',

## lib/MT/WeblogPublisher.pm
	'Archive type \'[_1]\' is not a chosen archive type' => 'Le Type d\'archive\'[_1]\' n\'est pas un type d\'archive selectionne',
	'Parameter \'[_1]\' is required' => 'Le parametre \'[_1]\' est requis',
	'You did not set your blog publishing path' => 'Vous n\'avez pas specifie le chemin de publication de votre blog',
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Le meme fichier d\'archive existe deja. Vous devez changer le nom de base ou le chemin de l\'archive ([_1])',
	'An error occurred publishing [_1] \'[_2]\': [_3]' => 'Une erreur s\'est produite lors de la publication [_1] \'[_2]\': [_3]',
	'An error occurred publishing date-based archive \'[_1]\': [_2]' => 'Une erreur s\'est produite en publiant l\'archive par dates \'[_1]\': [_2]',
	'Renaming tempfile \'[_1]\' failed: [_2]' => 'Le renommage de tempfile \'[_1]\' a echoue: [_2]',
	'Blog, BlogID or Template param must be specified.' => 'Les parametres Blog, BlogID ou Template doivent etre specifies.',
	'Template \'[_1]\' does not have an Output File.' => 'Le gabarit \'[_1]\' n\'a pas de fichier de sortie.',
	'An error occurred while publishing scheduled entries: [_1]' => 'Une erreur s\'est produite en publiant les notes planifiees: [_1]',

## lib/MT/ObjectDriver/Driver/DBD/SQLite.pm
	'Can\'t open \'[_1]\': [_2]' => 'Impossible d\'ouvrir \'[_1]\' : [_2]',

## lib/MT/Compat/v3.pm
	'uses: [_1], should use: [_2]' => 'utilise: [_1], devrait utiliser: [_2]',
	'uses [_1]' => 'utilise [_1]',
	'No executable code' => 'Pas de code executable',
	'Publish-option name must not contain special characters' => 'La personnalisation du nom de publication ne doit pas contenir de caracteres speciaux',

## lib/MT/Import.pm
	'Can\'t rewind' => 'Impossible de revenir en arriere',
	'No readable files could be found in your import directory [_1].' => 'Aucun fichier lisible n\'a ete trouve dans le repertoire d\'importation [_1].',
	'Couldn\'t resolve import format [_1]' => 'Impossible de detecter le format d\'import [_1]',
	'Movable Type' => 'Movable Type',
	'Another system (Movable Type format)' => 'Autre systeme (format Movable Type)',

## lib/MT/FileMgr/FTP.pm
	'Creating path \'[_1]\' failed: [_2]' => 'Creation du chemin \'[_1]\' a echouee : [_2]',
	'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Le renommage de \'[_1]\' a \'[_2]\' a echoue : [_3]',
	'Deleting \'[_1]\' failed: [_2]' => 'La suppression de \'[_1]\' a echoue : [_2]',

## lib/MT/FileMgr/DAV.pm
	'DAV connection failed: [_1]' => 'La connexion DAV a echoue : [_1]',
	'DAV open failed: [_1]' => 'L\'ouverture DAV a echouee : [_1]',
	'DAV get failed: [_1]' => 'La recuperation DAV a echouee : [_1]',
	'DAV put failed: [_1]' => 'L\'envoi DAV a echouee : [_1]',

## lib/MT/FileMgr/Local.pm

## lib/MT/FileMgr/SFTP.pm
	'SFTP connection failed: [_1]' => 'La connexion SFTP a echoue : [_1]',
	'SFTP get failed: [_1]' => 'La recuperation  SFTP a echoue : [_1]',
	'SFTP put failed: [_1]' => 'L\'envoi  SFTP a echoue : [_1]',

## lib/MT/Auth.pm
	'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Mauvaise configuration du module d\'authentification \'[_1]\': [_2]',
	'Bad AuthenticationModule config' => 'Mauvaise configuration du module d\'authentification',

## lib/MT/Folder.pm

## lib/MT/Tag.pm
	'Tag must have a valid name' => 'Le tag doit avoir un nom valide',
	'This tag is referenced by others.' => 'Ce tag est reference par d\'autres.',

## lib/MT/Worker/Publish.pm
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- configuration terminee ([quant,_1,fichier,fichiers] dans [_2] secondes)',

## lib/MT/Worker/Sync.pm
	'Synchrnizing Files Done' => 'Synchronisation des fichiers effectuee',
	'Done syncing files to [_1] ([_2])' => 'Synchronisation des fichiers de [_1] ([_2]) terminee',

## lib/MT/Log.pm
	'Log message' => 'Message du journal',
	'Log messages' => 'Messages du journal',
	'Page # [_1] not found.' => 'Page # [_1] non trouvee.',
	'Entry # [_1] not found.' => 'Note # [_1] non trouvee.',
	'Comment # [_1] not found.' => 'Commentaire # [_1] non trouve.',
	'TrackBack # [_1] not found.' => 'Trackback # [_1] non trouve.',

## lib/MT.pm.pre
	'Powered by [_1]' => 'Powered by [_1]',
	'Version [_1]' => 'Version [_1]',
	'http://www.sixapart.com/movabletype/' => 'http://www.movabletype.com/',
	'OpenID URL' => 'URL OpenID',
	'Sign in using your OpenID identity.' => 'Identifiez-vous avec votre identite OpenID.',
	'OpenID is an open and decentralized single sign-on identity system.' => 'OpenID est un systeme de gestion d\'identite ouvert et decentralise pour s\'identifiant une seule fois seulement.',
	'Sign in' => 'Identification',
	'Learn more about OpenID.' => 'En savoir plus sur OpenID.',
	'Your LiveJournal Username' => 'Votre identifiant LiveJournal',
	'Learn more about LiveJournal.' => 'En savoir plus sur LiveJournal.',
	'Your Vox Blog URL' => 'L\'URL de votre blog Vox',
	'Learn more about Vox.' => 'En savoir plus sur Vox.',
	'Sign in using your Gmail account' => 'Identifiez-vous en utilisant votre compte Gmail',
	'Sign in to Movable Type with your[_1] Account[_2]' => 'Identifiez-vous dans Movable Type avec votre compte [_1] [_2]',
	'Turn on OpenID for your Yahoo! account now' => 'Activer OpenID pour votre compte Yahoo! maintenant',
	'Your AIM or AOL Screen Name' => 'Votre pseudonyme AIM ou AOL.',
	'Sign in using your AIM or AOL screen name. Your screen name will be displayed publicly.' => 'Identifiez-vous en utilisant votre pseudonyme AIM ou AOL. Votre pseudonyme sera affiche publiquement.',
	'Your Wordpress.com Username' => 'Votre pseudonyme WordPress.com',
	'Sign in using your WordPress.com username.' => 'Identifiez-vous en utilisant votre pseudonyme WordPress.com',
	'TypePad is a free, open system providing you a central identity for posting comments on weblogs and logging into other websites. You can register for free.' => '
	TypePad est un systeme gratuit et ouvert vous proposant une identite centralisee pour commenter sur les blogs et vous identifier sur d\'autres sites. Vous pouvez vous enregistrer gratuitement.',
	'Sign in or register with TypePad.' => 'Identifiez-vous ou creer un compte sur TypePad.',
	'Turn on OpenID for your Yahoo! Japan account now' => 'Activer OpenID pour votre compte Yahoo! Japon maintenant',
	'Your Hatena ID' => 'Votre identifiant Hatena',
	'Hello, world' => 'Bonjour',
	'Hello, [_1]' => 'Bonjour, [_1]',
	'Message: [_1]' => 'Message: [_1]',
	'If present, 3rd argument to add_callback must be an object of type MT::Component or MT::Plugin' => 'Si present, le 3eme argument de add_callback doit etre un objet de type MT::Component ou MT:Plugin',
	'4th argument to add_callback must be a CODE reference.' => '4eme argument de add_callback doit etre une reference de CODE.',
	'Two plugins are in conflict' => 'Deux plugins sont en conflit',
	'Invalid priority level [_1] at add_callback' => 'Niveau de priorite invalide [_1] dans add_callback',
	'Unnamed plugin' => 'Plugin sans nom',
	'[_1] died with: [_2]' => '[_1] mort avec: [_2]',
	'Bad ObjectDriver config' => 'Mauvaise config ObjectDriver',
	'Bad CGIPath config' => 'Mauvaise config CGIPath',
	'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Fichier de configuration manquant. Avez-vous oublie de deplacer mt-config.cgi-original vers mt-config.cgi?',
	'Plugin error: [_1] [_2]' => 'Erreur de Plugin: [_1] [_2]',
	'Loading template \'[_1]\' failed.' => 'Le chargement du template \'[_1]\' a echoue.',
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
	'Yahoo! JAPAN' => 'Yahoo! Japon',
	'livedoor' => 'livedoor',
	'Hatena' => 'Hatena',
	'Movable Type default' => 'Valeur par defaut Movable Type',

## mt-static/mt.js
	'delete' => 'supprimer',
	'remove' => 'retirer',
	'enable' => 'activer',
	'disable' => 'desactiver',
	'You did not select any [_1] to [_2].' => 'Vous n\'avez pas selectionne de [_1] a [_2].',
	'Are you sure you want to [_2] this [_1]?' => 'Etes-vous sur(e) de vouloir [_2] : [_1]?',
	'Are you sure you want to [_3] the [_1] selected [_2]?' => 'Etes-vous sur(e) de vouloir [_3] les [_1] [_2] selectionne(e)s?',
	'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => 'Etes-vous sur(e) de vouloir supprimer ce role. En faisant cela vous allez supprimer les autorisations de tous les utilisateurs et groupes associes a ce role.',
	'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => 'Etes-vous sur(e) de vouloir supprimer les roles [_1] ? Avec cette actions vous allez supprimer les autorisations associees a tous les utilisateurs et groupes lies a ce role.',
	'You did not select any [_1] [_2].' => 'Vous n\'avez pas selectionne de [_1] [_2].',
	'You can only act upon a minimum of [_1] [_2].' => 'Vous ne pouvez agir que sur un minimum de [_1] [_2].',
	'You can only act upon a maximum of [_1] [_2].' => 'Vous ne pouvez agir que sur un maximum de [_1] [_2].',
	'You must select an action.' => 'Vous devez selectionner une action.',
	'to mark as spam' => 'pour classer comme spam',
	'to remove spam status' => 'pour retirer le statut de spam',
	'Enter email address:' => 'Saisissez l\'adresse email :',
	'Enter URL:' => 'Saisissez l\'URL :',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\'?' => 'Le tag \'[_2]\' existe deja. Etes-vous sur(e) de vouloir fusionner \'[_1]\' avec \'[_2]\'?',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all weblogs?' => 'Le tag \'[_2]\' existe deja. Etes-vous sur(e) de vouloir fusionner \'[_1]\' avec \'[_2]\' sur tous les blogs?',
	'Loading...' => 'Chargement...',
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] de [_3]',
	'[_1] &ndash; [_2]' => '[_1] &ndash; [_2]',

## mt-static/js/dialog.js
	'(None)' => '(Aucun)',

## mt-static/js/assetdetail.js
	'No Preview Available' => 'Pas de pre-visualisation possible',
	'View uploaded file' => 'Voir le fichier envoye',

## search_templates/default.tmpl
	'SEARCH FEED AUTODISCOVERY LINK PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'LE LIEN DU FLUX DE LA RECHERCHE AUTOMATISEE EST PUBLIE UNIQUEMENT APRES L\'EXECUTION D\'UNE RECHERCHE.',
	'Blog Search Results' => 'Resultats de la recherche',
	'Blog search' => 'Recherche de Blog',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'LES RECHERCHES SIMPLES ONT LE FORMULAIRE DE RECHERCHES',
	'Search this site' => 'Rechercher sur ce site',
	'Match case' => 'Respecter la casse',
	'SEARCH RESULTS DISPLAY' => 'AFFICHAGE DES RESULTATS DE LA RECHERCHE',
	'Matching entries from [_1]' => 'Notes correspondant a [_1]',
	'Entries from [_1] tagged with \'[_2]\'' => 'Notes a partir de [_1] taguees avec \'[_2]\'',
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Poste <MTIfNonEmpty tag="EntryAuthorDisplayName">par [_1] </MTIfNonEmpty>le [_2]',
	'Showing the first [_1] results.' => 'Afficher les premiers [_1] resultats.',
	'NO RESULTS FOUND MESSAGE' => 'MESSAGE AUCUN RESULTAT',
	'Entries matching \'[_1]\'' => 'Notes correspondant a \'[_1]\'',
	'Entries tagged with \'[_1]\'' => 'Notes taguees avec \'[_1]\'',
	'No pages were found containing \'[_1]\'.' => 'Aucune page trouvee contenant \'[_1]\'.',
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes' => 'Par defaut, ce moteur de recherche analyse l\'ensemble des mots sans se preoccuper de leur ordre. Pour lancer une recherche sur une phrase exacte, inserez-la entre guillemets.',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions' => 'Le moteur de recherche admet aussi AND, OR et NOT mais pas des mots clefs pour specifier des expressions particulieres',
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
	'Search Results for [_1]' => 'Resultats de la recherche sur [_1]',

## search_templates/comments.tmpl
	'Search for new comments from:' => 'Recherche de nouveaux commentaires depuis :',
	'the beginning' => 'le debut',
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
	'Posted in [_1] on [_2]' => 'Publie dans [_1] le [_2]',
	'No results found' => 'Aucun resultat n\'a ete trouve',
	'No new comments were found in the specified interval.' => 'Aucun nouveau commentaire n\'a ete trouve dans la periode specifiee.',
	'Select the time interval that you\'d like to search in, then click \'Find new comments\'' => 'Selectionner l\'intervalle de temps desire pour la recherche, puis cliquez sur \'Voir les nouveaux commentaires\'',

## search_templates/results_feed_rss2.tmpl

## tmpl/wizard/optional.tmpl
	'Mail Configuration' => 'Configuration Mail',
	'Your mail configuration is complete.' => 'Votre configuration email est complete.',
	'Check your email to confirm receipt of a test email from Movable Type and then proceed to the next step.' => 'Verifiez votre adresse email pour confirmer la reception d\'un email de test de Movable Type et ensuite passez a l\'etape suivante.',
	'Back' => 'Retour',
	'Continue' => 'Continuer',
	'Show current mail settings' => 'Montrer les parametres d\'email actuels',
	'Periodically Movable Type will send email to inform users of new comments as well as other other events. For these emails to be sent properly, you must instruct Movable Type how to send email.' => 'Movable Type va envoyer periodiquement des emails afin d\'informer les utilisateurs des nouveaux commentaires et autres evenements. Pour que ces emails puissent etre envoyes correctement, veuillez specifier la methode que Movable Type va utiliser.',
	'An error occurred while attempting to send mail: ' => 'Une erreur s\'est produite en essayant d\'envoyer un email: ',
	'Send email via:' => 'Envoyer email via :',
	'Select One...' => 'Selectionner un...',
	'sendmail Path' => 'Chemin sendmail',
	'The physical file path for your sendmail binary.' => 'Le chemin du fichier physique de votre binaire sendmail.',
	'Outbound Mail Server (SMTP)' => 'Serveur email sortant (SMTP)',
	'Address of your SMTP Server.' => 'Adresse de votre serveur SMTP.',
	'Mail address for test sending' => 'Adresse email pour envoi d\'un test',
	'Send Test Email' => 'Envoyer un email de test',

## tmpl/wizard/complete.tmpl
	'Configuration File' => 'Fichier de configuration',
	'The [_1] configuration file can\'t be located.' => 'Le fichier de configuration [_1] n\'a pas pu etre trouve',
	'Please use the configuration text below to create a file named \'mt-config.cgi\' in the root directory of [_1] (the same directory in which mt.cgi is found).' => 'Creez un fichier nomme dans le repertoire racine de [_1] (le meme qui contient mt.cgi) ayant pour contenu le texte de configuration ci-dessous.',
	'The wizard was unable to save the [_1] configuration file.' => 'L\'assistant n\'a pas pu enregistrer le fichier de configuration [_1]',
	'Confirm your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click \'Retry\'.' => 'Verifiez que votre repertoire [_1] (celui qui contient mt.cgi) est ouvert en ecriture pour votre serveur web et cliquez sur Recommencer',
	'Congratulations! You\'ve successfully configured [_1].' => 'Felicitations ! Vous avez configure [_1] avec succes.',
	'Your configuration settings have been written to the following file:' => 'Vos parametres de configuration ont ete ecrits dans le fichier suivant:',
	'To reconfigure the settings, click the \'Back\' button below.' => 'Pour reconfigurer vos parametres, cliquez sur le bouton \'Retour\' ci-dessous. Sinon, cliquez sur Continuer.',
	'Show the mt-config.cgi file generated by the wizard' => 'Afficher le fichier mt-config.cgi genere par l\'assistant',
	'The mt-config.cgi file has been created manually.' => 'Le fichier mt-config.cgi a ete cree manuellement.',
	'Retry' => 'Recommencer',

## tmpl/wizard/cfg_dir.tmpl
	'Temporary Directory Configuration' => 'Configuration du repertoire temporaire',
	'You should configure you temporary directory settings.' => 'Vous devriez configurer les parametres de votre repertoire temporaire.',
	'Your TempDir has been successfully configured. Click \'Continue\' below to continue configuration.' => 'Votre Tempdir a ete correctement configure. Cliquez sur \'Continuer\' ci-dessous pour continuer la configuration.',
	'[_1] could not be found.' => '[_1] introuvable.',
	'TempDir is required.' => 'TempDir est requis.',
	'TempDir' => 'TempDir',
	'The physical path for temporary directory.' => 'Chemin physique pour le repertoire temporaire.',
	'Test' => 'Test',

## tmpl/wizard/start.tmpl
	'Welcome to Movable Type' => 'Bienvenue dans Movable Type',
	'Configuration File Exists' => 'Le fichier de configuration existe',
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => 'Un fichier de configuration (mt-config.cgi) existe deja, <a href="[_1]">identifiez-vous</a> dans Movable Type.',
	'To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page' => 'Pour creer un nouveau fichier de configuration avec l\'assistant, supprimez le fichier de configuration actuel puis rechargez cette page',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Pour utiliser Movable Type, vous devez activer les JavaScript sur votre navigateur. Merci de les activer et de relancer le navigateur pour commencer.',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Vous allez maintenant, grace a cet assistant de configuration, mettre en place les parametres de base afin d\'assurer le fonctionnement de Movable Type.',
	'<strong>Error: \'[_1]\' could not be found.</strong>  Please move your static files to the directory first or correct the setting if it is incorrect.' => '<strong>Erreur: \'[_1]\' n\'a pas pu etre trouve(e).</strong>  Veuillez deplacer vos fichiers statiques vers le repertoire premier ou mettre a jour les parametres si necessaire.',
	'Configure Static Web Path' => 'Configurer le chemin web statique',
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type est fourni avec un repertoire nomme [_1] contenant un nombre important de fichiers comme des images, fichiers javascripts et feuilles de style.',
	'The [_1] directory is in the main Movable Type directory which this wizard script resides, but due to your web server\'s configuration, the [_1] directory is not accessible in this location and must be moved to a web-accessible location (e.g., your web document root directory).' => 'Le repertoire [_1] est le repertoire principal de Movable Type contenant les scripts de cet assistant, mais a cause de la configuration de votre serveur web, le repertoire [_1] n\'est pas accessible a cette adresse et doit etre deplace vers un serveur web (par exemple, le repertoire document a la racine). ',
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Ce repertoire a ete renomme ou deplace en dehors du repertoire Movable Type.',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => 'Deplacez ou creez un lien symbolique du repertoire [_1] dans un endroit accessible depuis le web et specifiez le chemin web statique dans le champs ci-dessous.',
	'This URL path can be in the form of [_1] or simply [_2]' => 'Ce chemin d\'URL peut etre de la forme [_1] ou simplement [_2]',
	'This path must be in the form of [_1]' => 'Ce chemin doit etre de la forme [_1]',
	'Static web path' => 'Chemin web statique',
	'Static file path' => 'Chemin fichier statique',
	'Begin' => 'Commencer',

## tmpl/wizard/packages.tmpl
	'Requirements Check' => 'Verifications des elements necessaires',
	'The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your blog\'s data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the \'Retry\' button.' => 'Les modules Perl suivants sont necessaires pour realiser une connexion a une base de donnees.  Movable Type necessite une base de donnees pour stocker les donnees de votre blog.  Merci d\'installer un des packages listes ici avant de continuer.  quand vous etes pret, cliquez sur le bouton \'Reessayer\'.',
	'All required Perl modules were found.' => 'Tous les modules Perl obligatoires ont ete trouves.',
	'You are ready to proceed with the installation of Movable Type.' => 'Vous etes pret a proceder a l\'installation de Movable Type.',
	'Some optional Perl modules could not be found. <a href="javascript:void(0)" onclick="[_1]">Display list of optional modules</a>' => 'Certains modules Perl optionnels ne peuvent etre trouves. <a href="javascript:void(0)" onclick="[_1]">Afficher la liste des modules optionnels</a>',
	'One or more Perl modules required by Movable Type could not be found.' => 'Un ou plusieurs modules Perl necessaires pour Movable Type n\'ont pu etre trouves.',
	'The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the \'Retry\' button to re-test for these packages.' => 'Les modules Perl suivants sont necessaires au bon fonctionnement de Movable Type. Des que vous disposez de ces elements, cliquez sur le bouton \'Recommencer\' pour verifier ces elements..',
	'Some optional Perl modules could not be found. You may continue without installing these optional Perl modules. They may be installed at any time if they are needed. Click \'Retry\' to test for the modules again.' => 'Certains modules Perl optionnels n\'ont pu etre trouves. Vous pouvez continuer sans installer ces modules Perl. Ils peuvent etre installes n\'importe quand si besoin. Cliquez \'Reessayer\' pour tester a nouveau ces modules.',
	'Missing Database Modules' => 'Modules de base de donnees manquants',
	'Missing Optional Modules' => 'Modules optionnels manquants',
	'Missing Required Modules' => 'Modules necessaires absents',
	'Minimal version requirement: [_1]' => 'Version minimale necessaire : [_1]',
	'Learn more about installing Perl modules.' => 'Plus d\'informations sur l\'installation de modules Perl.',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'Votre serveur possede tous les modules necessaires; vous n\'avez pas a proceder a des installations complementaires de modules',

## tmpl/wizard/configure.tmpl
	'Database Configuration' => 'Configuration de la Base de Donnees',
	'You must set your Database Path.' => 'Vous devez definir le Chemin de Base de Donnees.',
	'You must set your Database Name.' => 'Vous devez definir un Nom de Base de donnees.',
	'You must set your Username.' => 'Vous devez definir votre nom d\'utilisateur.',
	'You must set your Database Server.' => 'Vous devez definir votre serveur de Base de donnees.',
	'Your database configuration is complete.' => 'Votre configuration de base de donnees est terminee.',
	'You may proceed to the next step.' => 'Vous pouvez passer a l\'etape suivante.',
	'Please enter the parameters necessary for connecting to your database.' => 'Merci de saisir les parametres necessaires pour se connecter a votre base de donnees.',
	'Show Current Settings' => 'Montrer les parametres actuels',
	'Database Type' => 'Type de base de donnees',
	'http://www.movabletype.org/documentation/[_1]' => 'http://www.movabletype.org/documentation/[_1]',
	'Is your preferred database not listed? View the <a href="[_1]" target="_blank">Movable Type System Check</a> see if additional modules are necessary.' => 'Votre base de donnees preferee n\'est pas listee ? Regardez <a href="[_1]" target="_blank">Movable Type System Check</a> pour voir s\'il y a des modules additionnels necessaires pour permettre son utilisation.',
	'Once installed, <a href="javascript:void(0)" onclick="[_1]">click here to refresh this screen</a>.' => 'Une fois installe, <a href="javascript:void(0)" onclick="[_1]">cliquez ici pour reactualiser cette page</a>.',
	'Read more: <a href="[_1]" target="_blank">Setting Up Your Database</a>' => 'Apprenez-en plus : <a href="[_1]" target="_blank">Configurez votre base de donnees</a>',
	'Database Path' => 'Chemin de la Base de Donnees',
	'The physical file path for your SQLite database. ' => 'Le chemin du fichier physique de votre base de donnees SQLite. ',
	'A default location of \'./db/mt.db\' will store the database file underneath your Movable Type directory.' => 'Un endroit par defaut \'./db/mt.db\' stockera le fichier de base de donnees dans votre repertoire Movable Type.',
	'Database Server' => 'Serveur de Base de donnees',
	'This is usually \'localhost\'.' => 'C\'est generalement \'localhost\'.',
	'Database Name' => 'Nom de la Base de donnees',
	'The name of your SQL database (this database must already exist).' => 'Le nom de votre Base de donnees SQL (cette base de donnees doit etre deja presente).',
	'The username to login to your SQL database.' => 'Le nom d\'utilisateur pour acceder a la Base de donnees SQL.',
	'Password' => 'Mot de passe',
	'The password to login to your SQL database.' => 'Le mot de passe pour acceder a la Base de donnees SQL.',
	'Show Advanced Configuration Options' => 'Montrer les options avancees de configuration',
	'Database Port' => 'Port de la Base de donnees',
	'This can usually be left blank.' => 'Peut etre laisse vierge.',
	'Database Socket' => 'Socket de la Base de donnees',
	'Publish Charset' => 'Publier le  Charset',
	'MS SQL Server driver must use either Shift_JIS or ISO-8859-1.  MS SQL Server driver does not support UTF-8 or any other character set.' => 'Le driver  Serveur MS SQL doit utiliser Shift_JIS ou ISO-8859-1.  Le driver serveur MS SQL ne supporte pas UTF-8 ou tout autre jeu de caracteres.',
	'Test Connection' => 'Test de Connexion',

## tmpl/wizard/blog.tmpl
	'Setup Your First Blog' => 'Configurer votre premier blog',
	'In order to properly publish your blog, you must provide Movable Type with your blog\'s URL and the path on the filesystem where its files should be published.' => 'Pour pouvoir publier correctement votre blog, vous devez fournir a Movable Type l\'URL du blog et le chemin sur le disque ou les fichiers doivent etre publies.',
	'My First Blog' => 'Mon Premier Blog',
	'Publishing Path' => 'Chemin de publication',
	'Your \'Publishing Path\' is the path on your web server\'s file system where Movable Type will publish all the files for your blog. Your web server must have write access to this directory.' => 'Votre \'Chemin de publication\' est le chemin sur le disque de votre serveur web ou Movable Type va publier tous les fichiers de votre blog. Votre serveur web doit avoir un acces en ecriture a ce repertoire.',

## tmpl/cms/edit_role.tmpl
	'Edit Role' => 'Modifier le role',
	'Your changes have been saved.' => 'Les modifications ont ete enregistrees.',
	'List Roles' => 'Lister les roles',
	'[quant,_1,User,Users] with this role' => '[quant,_1,Utilisateur,Utilisateurs] avec ce role',
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'Vous avez change les privileges pour ce role. Cela va modifier ce que les utilisateurs associes a ce role ont la possibilite de faire. Si vous preferez, vous pouvez sauvegarder ce role avec un nom different.',
	'Role Details' => 'Details du role',
	'Created by' => 'Cree par',
	'System' => 'Systeme',
	'Privileges' => 'Privileges',
	'Check All' => 'Selectionner tout',
	'Uncheck All' => 'Deselectionner tout',
	'Administration' => 'Administration',
	'Authoring and Publishing' => 'Auteurs et Publication',
	'Designing' => 'Designer',
	'Commenting' => 'Commenter',
	'Duplicate Roles' => 'Dupliquer les roles',
	'These roles have the same privileges as this role' => 'Ces roles ont les meme privileges que ce role',
	'Save changes to this role (s)' => 'Enregistrer les modifications de ce role (s)',
	'Save Changes' => 'Enregistrer les modifications',

## tmpl/cms/list_category.tmpl
	'Your category changes and additions have been made.' => 'Vos modifications de la categorie ont bien ete apportees.',
	'You have successfully deleted the selected category.' => 'Vous avez supprime avec succes la categorie selectionnee',
	'categories' => 'Categories',
	'Delete selected category (x)' => 'Supprimer la categorie selectionnee (x)',
	'Create top level category' => 'Creer une categorie de premier niveau',
	'New Parent [_1]' => 'Nouveau [_1] parent',
	'Create Category' => 'Creer une Categorie',
	'Top Level' => 'Niveau racine',
	'Collapse' => 'Reduire',
	'Expand' => 'Developper',
	'Create Subcategory' => 'Creer une Sous-categorie',
	'Move Category' => 'Deplacer une Categorie',
	'Move' => 'Deplacer',
	'[quant,_1,entry,entries]' => '[quant,_1,note,notes]',
	'[quant,_1,TrackBack,TrackBacks]' => '[quant,_1,trackback,trackbacks]',
	'No categories could be found.' => 'Aucune categorie n\'a pu etre trouvee.',

## tmpl/cms/cfg_plugin.tmpl
	'System Plugin Settings' => 'Parametres du systeme de plugins',
	'Useful links' => 'Liens utiles',
	'http://plugins.movabletype.org/' => 'http://plugins.movabletype.org/',
	'Find Plugins' => 'Trouver des plugins',
	'Plugin System' => 'Systeme de plugins',
	'Manually enable or disable plugin-system functionality. Re-enabling plugin-system functionality, will return all plugins to their original state.' => 'Activer ou desactiver la prise en charge des plugins manuellement. La reactivation de cette prise en charge rendra a tous les plugins leur etat original',
	'Disable plugin functionality' => 'Desactiver la prise en charge des plugins',
	'Disable Plugins' => 'Desactiver les plugins',
	'Enable plugin functionality' => 'Activer la prise en charge des plugins',
	'Enable Plugins' => 'Activer les plugins',
	'Your plugin settings have been saved.' => 'Les parametres de votre plugin ont ete enregistres.',
	'Your plugin settings have been reset.' => 'Les parametres de votre plugin on ete reinitialises.',
	'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => 'Vos plugins ont ete reconfigures. Si vous etes sous mod_perl vous devez redemarrer votre serveur web pour la prise en compte de ces changements.',
	'Your plugins have been reconfigured.' => 'Votre plugin a ete reconfigure.',
	'Are you sure you want to reset the settings for this plugin?' => 'Etes-vous sur de vouloir re-initialiser les parametres pour ce plugin ?',
	'Are you sure you want to disable plugin functionality?' => 'Etes-vous sur de vouloir desactiver la prise en charge des plugins ?',
	'Disable this plugin?' => 'Desactiver ce plugin ?',
	'Are you sure you want to enable plugin functionality? (This will re-enable any plugins that were not individually disabled.)' => 'Etes-vous sur de vouloir activer les plugins ? (Cela re-activera tous les plugins qui n\'ont pas ete desactives manuellement)',
	'Enable this plugin?' => 'Activer ce plugin ?',
	'Failed to Load' => 'Erreur de chargement',
	'(Disable)' => '(Desactiver)',
	'Enabled' => 'Active',
	'Disabled' => 'Desactive',
	'(Enable)' => '(Activer)',
	'Settings for [_1]' => 'Parametres pour [_1]',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be 100% functional. Furthermore, it will require an upgrade once you have upgraded to the next Movable Type major release (when available).' => 'Ce plugin n\'a pas ete mis a jour pour supporter Movable Type [_1]. Ainsi, il n\'est peut-etre pas fonctionnel a 100%. De plus, il necessitera une mise a jour des que vous aurez mis a jour Movable Type a la prochaine version majeure (quand elle sera disponible).',
	'Plugin error:' => 'Erreur plugin :',
	'Info' => 'Info',
	'Resources' => 'Ressources',
	'Run [_1]' => 'Lancer [_1]',
	'Documentation for [_1]' => 'Documentation pour [_1]',
	'Documentation' => 'Documentation',
	'More about [_1]' => 'En savoir plus sur [_1]',
	'Plugin Home' => 'Accueil Plugin',
	'Author of [_1]' => 'Auteur de [_1]',
	'Tags:' => 'Tags:',
	'Tag Attributes:' => 'Attributs de tag:',
	'Text Filters' => 'Filtres de texte',
	'Junk Filters:' => 'Filtres de spam:',
	'Reset to Defaults' => 'Re-initialiser (retour aux parametres par defaut)',
	'No plugins with blog-level configuration settings are installed.' => 'Aucun plugin avec une configuration au niveau du blog n\'est installe.',
	'No plugins with configuration settings are installed.' => 'Aucun plugin avec une configuration n\'est installe',

## tmpl/cms/list_blog.tmpl
	'You have successfully deleted the blogs from the Movable Type system.' => 'Le blog a ete correctement supprime du systeme Movable Type.',
	'You have successfully refreshed your templates.' => 'Vous avez reactualise avec succes vos gabarits.',
	'You can not refresh templates: [_1]' => 'Vous ne pouvez pas reactualiser le(s) gabarit(s) : [_1]',
	'Create Blog' => 'Creer un blog',

## tmpl/cms/list_asset.tmpl
	'You have successfully deleted the asset(s).' => 'Vous avez efface les contenus.',
	'Quickfilters' => 'Filtres rapides',
	'Showing only: [_1]' => 'Montrer seulement : [_1]',
	'Remove filter' => 'Supprimer le filtre',
	'All [_1]' => 'Tous(tes) les [_1]',
	'change' => 'modifier',
	'[_1] where [_2] is [_3]' => '[_1] ou [_2] est [_3]',
	'Show only assets where' => 'Afficher seulement les elements ou',
	'type' => 'Type',
	'tag (exact match)' => 'le tag (exact)',
	'tag (fuzzy match)' => 'le tag (fuzzy match)',
	'is' => 'est',
	'Filter' => 'Filtre',

## tmpl/cms/edit_template.tmpl
	'Edit Widget' => 'Editer le Widget',
	'Create Widget' => 'Creer un Widget',
	'Create Template' => 'Creer le gabarit',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]">Recover auto-saved content</a>' => 'Une version de sauvegarde de [_1] a ete automatiquement sauvegardee [_3]. <a href="[_2]">Recuperer le contenu sauvegarde</a>',
	'You have successfully recovered your saved [_1].' => 'Vous avez recupere avec succes votre [_1] sauvegardee.',
	'An error occurred while trying to recover your saved [_1].' => 'Une erreur s\'est produite en essayant de recuperer votre [_1] sauvegardee.',
	'Your template changes have been saved.' => 'Les modifications apportees ont ete enregistrees.',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => '<a href="[_1]" class="rebuild-link">Publier</a> ce gabarit.',
	'Your [_1] has been published.' => 'Votre [_1] a ete publiee.',
	'Useful Links' => 'Liens utiles',
	'List [_1] templates' => 'Lister des gabarits de type [_1]',
	'List all templates' => 'Lister tous les gabarits',
	'_external_link_target' => '_blank',
	'View Published Template' => 'Voir le gabarit publie',
	'Included Templates' => 'Gabarits inclus',
	'create' => 'creer',
	'Template Tag Docs' => 'Docs des tags de gabarits',
	'Unrecognized Tags' => 'Tags non reconnus',
	'Save (s)' => 'Enregistrer (s)',
	'Save' => 'Enregistrer',
	'Save and Publish this template (r)' => 'Enregistrer et publier ce gabarit (r)',
	'Save &amp; Publish' => 'Enregistrer &amp; publier',
	'You have unsaved changes to this template that will be lost.' => 'Certains de vos changements n\'ont pas ete enregistres : ils seront perdus.',
	'You must set the Template Name.' => 'Vous devez mettre un nom de gabarit.',
	'You must set the template Output File.' => 'Vous devez configurer le fichier de sortie du gabarit.',
	'Processing request...' => 'Requete en cours d\'execution...',
	'Error occurred while updating archive maps.' => 'Une erreur s\'est produite en mettant a jour les archive maps.',
	'Archive map has been successfully updated.' => 'L\'archive map a ete modifiee avec succes.',
	'Are you sure you want to remove this template map?' => 'Etes-vous sur de vouloir supprimer cette table de correspondance de gabarit ?',
	'Module Body' => 'Corps du module',
	'Template Body' => 'Corps du gabarit',
	'Syntax Highlight On' => 'Coloriage de la syntaxe active',
	'Syntax Highlight Off' => 'Coloriage de la syntaxe desactive',
	'Insert...' => 'Insertion...',
	'Template Options' => 'Options de gabarit',
	'Output file: <strong>[_1]</strong>' => 'Fichier de sortie : <strong>[_1]</strong>',
	'Enabled Mappings: [_1]' => 'Tables de correspondances actives : [_1]',
	'Output File' => 'Fichier de sortie',
	'Template Type' => 'Type de gabarit',
	'Custom Index Template' => 'Gabarit d\'index personnalise',
	'Link to File' => 'Lien vers le fichier',
	'Learn more about <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publishing settings</a>' => 'Apprennez en plus a propos des <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">parametres de publication</a>',
	'Create Archive Mapping' => 'Creer une nouvelle table de correspondance des archives',
	'Type' => 'Type',
	'Add' => 'Ajouter',
	'Statically (default)' => 'Statique (defaut)',
	'Via Publish Queue' => 'Via une Publication en Mode File d\'Attente',
	'On a schedule' => 'Planifie',
	': every ' => ': chaque ',
	'minutes' => 'minutes',
	'hours' => 'heures',
	'days' => 'jours',
	'Dynamically' => 'Dynamique',
	'Manually' => 'Manuellement',
	'Do Not Publish' => 'Ne Pas Publier',
	'Server Side Include' => 'Server Side Include',
	'Process as <strong>[_1]</strong> include' => 'Traiter comme inclusion de <strong>[_1]</strong>',
	'Include cache path' => 'Inclure le chemin du cache',
	'Disabled (<a href="[_1]">change publishing settings</a>)' => 'Desactive (<a href="[_1]">changer les parametres de publication</a>)',
	'No caching' => 'Pas de cache',
	'Expire after' => 'Expire apres',
	'Expire upon creation or modification of:' => 'Expire lors de la creation ou modification de :',
	'Auto-saving...' => 'Sauvegarde automatique...',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Derniere sauvegarde automatique a [_1]:[_2]:[_3]',

## tmpl/cms/cfg_system_users.tmpl
	'System: User Settings' => 'Parametres des utilisateurs',
	'Your settings have been saved.' => 'Vos parametres ont ete enregistres.',
	'(No blog selected)' => '(Aucun blog selectionne)',
	'Select blog' => 'Selectionner le blog',
	'You must set a valid Default Site URL.' => 'Vous devez definir une URL par defaut valide pour le site.',
	'You must set a valid Default Site Root.' => 'Vous devez definir une URL par defaut valide pour la Racine du Site.',
	'(None selected)' => '(Aucune selection)',
	'User Registration' => 'Enregistrement utilisateur',
	'Allow Registration' => 'Autoriser les enregistrements',
	'Select a system administrator you wish to notify when commenters successfully registered themselves.' => 'Selectionnez un administrateur que vous souhaitez notifier quand les auteurs de commentaires s\'enregistrent avec succes.',
	'Allow commenters to register to Movable Type' => 'Autoriser les auteurs de commentaires a s\'enregistrer dans Movable Type',
	'Notify the following administrators upon registration:' => 'Notifier les administrateurs suivants lors de l\'enregistrement:',
	'Select Administrators' => 'Selectionner les administrateurs',
	'Clear' => 'Clair',
	'Note: System Email Address is not set. Emails will not be sent.' => 'Note: l\'adresse Email Systeme n\'est pas parametree.  Les emails ne seront pas envoyes.',
	'New User Defaults' => 'Parametres par defaut pour les nouveaux utilisateurs',
	'Personal blog' => 'Blog personnel',
	'Check to have the system automatically create a new personal blog when a user is created in the system. The user will be granted a blog administrator role on the blog.' => 'Verifier a ce que le systeme cree automatiquement un nouveau blog personnel lorsqu\'un utilisateur est cree. L\'utilisateur sera verra alors octroyer un role d\'administrateur sur ce blog',
	'Automatically create a new blog for each new user' => 'Creer automatiquement un nouveau blog pour chaque nouvel utilisateur',
	'Personal blog clone source' => 'Source du blog personnel a dupliquer',
	'Select a blog you wish to use as the source for new personal blogs. The new blog will be identical to the source except for the name, publishing paths and permissions.' => 'Selectionner le blog que vous souhaitez utiliser comme source pour les nouveau blogs personnels. Le nouveau blog sera ainsi identique a la source, excepte le nom, les chemins de publication et les autorisations.',
	'Change blog' => 'Changer de blog',
	'Default Site URL' => 'URL par defaut du site',
	'Define the default site URL for new blogs. This URL will be appended with a unique identifier for the blog.' => 'Specifie l\'URL par defaut pour les nouveaux blogs. Cette URL sera completee avec un identifiant unique pour le blog',
	'Default Site Root' => 'Racine du site par defaut',
	'Define the default site root for new blogs. This path will be appended with a unique identifier for the blog.' => 'Specifie le chemin de publication par defaut pour les nouveaux blogs. Ce chemin sera complete avec un identifiant unique pour le blog',
	'Default User Language' => 'Langue par defaut',
	'Define the default language to apply to all new users.' => 'Definir la langue par defaut a appliquer a chaque nouvel utilisateur',
	'Default Timezone' => 'Fuseau horaire par defaut',
	'Select your timezone from the pulldown menu.' => 'Veuillez selectionner votre fuseau horaire dans la liste.',
	'Time zone not selected' => 'Vous n\'avez pas selectionne de fuseau horaire',
	'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (Nouvelle-Zelande)',
	'UTC+12 (International Date Line East)' => 'UTC+12 (ligne internationale de changement de date)',
	'UTC+11' => 'UTC+11',
	'UTC+10 (East Australian Time)' => 'UTC+10 (Australie Est)',
	'UTC+9.5 (Central Australian Time)' => 'UTC+9,5 (Australie Centre)',
	'UTC+9 (Japan Time)' => 'UTC+9 (Japon)',
	'UTC+8 (China Coast Time)' => 'UTC+8 (Chine littorale)',
	'UTC+7 (West Australian Time)' => 'UTC+7 (Australie Ouest)',
	'UTC+6.5 (North Sumatra)' => 'UTC+6,5 (Sumatra Nord)',
	'UTC+6 (Russian Federation Zone 5)' => 'UTC+6 (Federation russe, zone 5)',
	'UTC+5.5 (Indian)' => 'UTC+5.5 (Inde)',
	'UTC+5 (Russian Federation Zone 4)' => 'UTC+5 (Federation russe, zone 4)',
	'UTC+4 (Russian Federation Zone 3)' => 'UTC+4 (Federation russe, zone 3)',
	'UTC+3.5 (Iran)' => 'UTC+3,5 (Iran)',
	'UTC+3 (Baghdad Time/Moscow Time)' => 'UTC+3 (Bagdad/Moscou)',
	'UTC+2 (Eastern Europe Time)' => 'UTC+2 (Europe de l\'Est)',
	'UTC+1 (Central European Time)' => 'UTC+1 (Europe centrale)',
	'UTC+0 (Universal Time Coordinated)' => 'UTC+0 (Temps universel coordonne)',
	'UTC-1 (West Africa Time)' => 'UTC-1 (Afrique de l\'Ouest)',
	'UTC-2 (Azores Time)' => 'UTC-2 (Acores)',
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
	'Default Tag Delimiter' => 'Delimiteur de tags par defaut',
	'Define the default delimiter for entering tags.' => 'Definir un delimiteur par defaut pour la saisie des tags.',
	'Comma' => 'Virgule',
	'Space' => 'Espace',
	'Save changes to these settings (s)' => 'Enregistrer les modifications de ces parametres (s)',

## tmpl/cms/dashboard.tmpl
	'Dashboard' => 'Tableau de bord',
	'Select a Widget...' => 'Selectionner un widget...',
	'Your Dashboard has been updated.' => 'Votre tableau de bord a ete mis a jour.',
	'You have attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'Vous avez essaye d\'acceder a une fonctionnalite a laquelle vous n\'avez pas le droit. Si vous pensez que cette erreur n\'est pas normale contactez votre administrateur systeme.',
	'The directory you have configured for uploading userpics is not writable. In order to enable users to upload userpics, please make the following directory writable by your web server: [_1]' => 'Le repertoire que vous avez configure pour l\'envoi de fichiers utilisateur n\'est pas accessible en ecriture. Afin de rendre ce telechargement possible a vos utilisateurs, merci de rendre le repertoire suivant accessible en ecriture : [_1]',
	'Image::Magick is either not present on your server or incorrectly configured. Due to that, you will not be able to use Movable Type\'s userpics feature. If you wish to use that feature, please install Image::Magick or use an alternative image driver.' => 'Image::Magick n\'est pas present sur votre serveur ou est mal configue. A cause de cela, vous ne pouvez pas utiliser les avatars dans Movable Type. Si vous souhaitez utiliser cette fonctionnalite, veuillez installer Image::Magick ou utiliser un pilote d\'image alternatif.',
	'Your dashboard is empty!' => 'Votre tableau de bord est vide !',

## tmpl/cms/cfg_trackbacks.tmpl
	'TrackBack Settings' => 'Parametres des trackbacks',
	'Your TrackBack preferences have been saved.' => 'Vos preferences de trackback ont ete sauvegardees.',
	'Note: TrackBacks are currently disabled at the system level.' => 'Note: Les trackbacks sont actuellement desactives au niveau systeme.',
	'Accept TrackBacks' => 'Accepter les trackbacks',
	'If enabled, TrackBacks will be accepted from any source.' => 'Si active, les trackbacks seront acceptes quelle que soit la source.',
	'TrackBack Policy' => 'Regles pour les trackbacks',
	'Moderation' => 'Moderation',
	'Hold all TrackBacks for approval before they\'re published.' => 'Retenir les trackbacks pour approbation avant publication.',
	'Apply \'nofollow\' to URLs' => 'Appliquer \'nofollow\' aux URLs',
	'This preference affects both comments and TrackBacks.' => 'Cette preference affecte les commentaires et les trackbacks.',
	'If enabled, all URLs in comments and TrackBacks will be assigned a \'nofollow\' link relation.' => 'Si active, toutes les URLs dans les commentaires et les trackbacks seront affectees d\'un attribut de lien \'nofollow\'.',
	'E-mail Notification' => 'Notification par email',
	'Specify when Movable Type should notify you of new TrackBacks if at all.' => 'Specifier quand Movable Type doit vous notifier les nouveaux trackbacks.',
	'On' => 'Activee',
	'Only when attention is required' => 'Uniquement quand l\'attention est requise',
	'Off' => 'Desactivee',
	'TrackBack Options' => 'Options de trackback',
	'TrackBack Auto-Discovery' => 'Activer la decouverte automatique des trackbacks',
	'If you turn on auto-discovery, when you write a new entry, any external links will be extracted and the appropriate sites automatically sent TrackBacks.' => 'Si vous activez la decouverte automatique, quand vous ecrivez une nouvelle note, tous les liens externes seront extraits et les sites correspondants recevront un trackback.',
	'Enable External TrackBack Auto-Discovery' => 'Pour les notes exterieures au blog',
	'Setting Notice' => 'Parametre des informations',
	'Note: The above option may be affected since outbound pings are constrained system-wide.' => 'Attention : L\'option ci-dessous peut etre affectee si les pings sortant sont limites dans le systeme.',
	'Setting Ignored' => 'Parametre ignore',
	'Note: The above option is currently ignored since outbound pings are disabled system-wide.' => 'Attention: l\'option ci-dessus est ignoree si les pings sortants sont desactives dans le systeme',
	'Enable Internal TrackBack Auto-Discovery' => 'Pour les notes interieures au blog',

## tmpl/cms/pinging.tmpl
	'Trackback' => 'Trackback',
	'Pinging sites...' => 'Envoi de ping(s)...',

## tmpl/cms/edit_widget.tmpl
	'Edit Widget Set' => 'Modifier le groupe de widgets',
	'Create Widget Set' => 'Creer un groupe de widgets',
	'Please use a unique name for this widget set.' => 'Merci d\'utiliser un nom unique pour ce groupe de widgets.',
	'Set Name' => 'Nom du groupe',
	'Drag and drop the widgets you want into the Installed column.' => 'Glissez-deposez les widgets que vous voulez dans la colonne de gauche.',
	'Installed Widgets' => 'Widgets installes',
	'edit' => 'Editer',
	'Available Widgets' => 'Widgets disponibles',
	'Save changes to this widget set (s)' => 'Enregistrer les modifications de ce groupe de widgets',

## tmpl/cms/recover_password_result.tmpl
	'Recover Passwords' => 'Retrouver les mots de passe',
	'No users were selected to process.' => 'Aucun utilisateur selectionne pour l\'operation.',
	'Return' => 'Retour',

## tmpl/cms/list_entry.tmpl
	'Manage Entries' => 'Gerer les notes',
	'Entries Feed' => 'Flux des Notes',
	'Pages Feed' => 'Flux des Pages',
	'The entry has been deleted from the database.' => 'Cette note a ete supprimee de la base de donnees.',
	'The page has been deleted from the database.' => 'Cette page a ete supprimee de la base de donnees.',
	'[_1] (Disabled)' => '[_1] (Desactive)',
	'Set Web Services Password' => 'Definir un mot de passe pour les services Web',
	'Show only entries where' => 'Afficher seulement les notes ou',
	'Show only pages where' => 'Afficher seulement les pages ou',
	'status' => 'le statut',
	'user' => 'utilisateur',
	'asset' => 'Element',
	'published' => 'publie',
	'unpublished' => 'non publie',
	'review' => 'Verification',
	'scheduled' => 'programme',
	'spam' => 'Spam',
	'Select A User:' => 'Selectionner un utilisateur',
	'User Search...' => 'Recherche utilisateur...',
	'Recent Users...' => 'Utilisateurs recents...',

## tmpl/cms/restore_start.tmpl
	'Restoring Movable Type' => 'Restauration de Movable Type',

## tmpl/cms/edit_commenter.tmpl
	'Commenter Details' => 'Details sur l\'auteur de commentaires',
	'The commenter has been trusted.' => 'L\'auteur de commentaires est fiable.',
	'The commenter has been banned.' => 'L\'auteur de commentaires a ete banni.',
	'Comments from [_1]' => 'Commentaires de [_1]',
	'commenter' => 'l\'auteur de commentaires',
	'commenters' => 'Auteurs de commentaire',
	'to act upon' => 'pour agir sur',
	'Trust user (t)' => 'Donner le statut fiable a cet utilisateur (t)',
	'Trust' => 'Fiable',
	'Untrust user (t)' => 'Donner le statut non fiable a cet utilisateur (t)',
	'Untrust' => 'Non Fiable',
	'Ban user (b)' => 'Donner le statut banni a cet utilisateur (t)',
	'Ban' => 'Bannir',
	'Unban user (b)' => 'Donner le statut non banni a cet utilisateur (t)',
	'Unban' => 'Non banni',
	'The Name of the commenter' => 'Le nom de l\'auteur de commentaires',
	'View all comments with this name' => 'Afficher tous les commentaires associes a ce nom',
	'Identity' => 'Identite',
	'The Identity of the commenter' => 'L\'identite de l\'auteur de commentaires',
	'Email' => 'Adresse email',
	'The Email of the commenter' => 'L\'adresse email de l\'auteur de commentaires',
	'Withheld' => 'Retenu',
	'View all comments with this email address' => 'Afficher tous les commentaires associes a cette adresse email',
	'The URL of the commenter' => 'URL de l\'auteur de commentaires',
	'View all comments with this URL address' => 'Afficher tous les commentaires associes a cette URL',
	'Status' => 'Statut',
	'The trusted status of the commenter' => 'Le statut de confiance de cet auteur de commentaires',
	'Trusted' => 'Fiable',
	'Banned' => 'Banni',
	'Authenticated' => 'Authentifie',
	'View all commenters' => 'Voir tous les commentaires',

## tmpl/cms/import.tmpl
	'You must select a blog to import.' => 'Vous devez selectionner un blog a importer.',
	'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Transferer les notes dans Movable Type depuis une autre installation Movable Type ou a partir d\'un autre outil de publication de blogs afin de creer une sauvegarde ou une copie.',
	'Import data into' => 'Importer les donnees dans',
	'Select a blog to import.' => 'Selectionner un blog a importer.',
	'Importing from' => 'Importation a partir de',
	'Ownership of imported entries' => 'Proprietaire des notes importees',
	'Import as me' => 'Importer en me considerant comme auteur',
	'Preserve original user' => 'Preserver l\'utilisateur initial',
	'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => 'Si vous choisissez de garder l\'auteur original de chaque note importee, ils doivent etre crees dans votre installation et vous devez definir un mot de passe par defaut pour ces nouveaux comptes.',
	'Default password for new users:' => 'Mot de passe par defaut pour un nouvel utilisateur:',
	'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'Vous serez designe comme auteur/utilisateur pour toutes les notes importees. Si vous voulez que l\'auteur initial en conserve la propriete, vous devez contacter votre administrateur MT pour qu\'il fasse l\'importation et le cas echeant qu\'il cree un nouvel utilisateur.',
	'Upload import file (optional)' => 'Envoyer le fichier d\'import (optionnel)',
	'If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the \'import\' folder of your Movable Type directory.' => 'Si votre fichier d\'import est situe sur votre ordinateur, vous pouvez l\'envoyer ici.  Sinon, Movable Type va automatiquement chercher dans le repertoire \'import\' de votre repertoire Movable Type.',
	'More options' => 'Plus d\'options',
	'Text Formatting' => 'Mise en forme du texte',
	'Import File Encoding' => 'Encodage du fichier d\'import',
	'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'Par defaut, Movable Type va essayer de detecter automatiquement l\'encodage des caracteres de vos fichiers importes.  Cependant, si vous rencontrez des difficultes, vous pouvez le parametrer de maniere explicite',
	'<mt:var name="display_name" escape="html">' => '<mt:var name="display_name" escape="html">',
	'Default category for entries (optional)' => 'Categorie par defaut pour les notes (optionnel)',
	'You can specify a default category for imported entries which have none assigned.' => 'Vous pouvez specifier une categorie par defaut pour les notes importees qui n\'ont pas ete assignees.',
	'Select a category' => 'Selectionnez une categorie',
	'Import Entries (s)' => 'Importer les notes (s)',
	'Import Entries' => 'Importer des notes',

## tmpl/cms/cfg_system_general.tmpl
	'System: General Settings' => 'Parametres generaux',
	'System Email' => 'Email systeme',
	'The email address used in the From: header of each email sent from the system.  The address is used in password recovery, commenter registration, comment, trackback notification and a few other minor events.' => 'Cette adresse email sera utilisee dans l\'en-tete From: des emails envoyes par le systeme. L\'adresse est utilisee dans la recuperation des mots de passe, l\'enregistrement d\'auteurs de commentaires, les notifications de commentaires, trackbacks, ainsi que certains autres evenements mineurs.',

## tmpl/cms/cfg_prefs.tmpl
	'Your preferences have been saved.' => 'Vos preferences ont ete sauvegardees.',
	'You must set your Blog Name.' => 'Vous devez configurer le nom du blog.',
	'You did not select a timezone.' => 'Vous n\'avez pas selectionne de fuseau horaire.',
	'Blog Settings' => 'Parametres du blog',
	'Name your blog. The blog name can be changed at any time.' => 'Nommez votre blog. Le nom du blog peut etre change a n\'importe quel moment.',
	'Enter a description for your blog.' => 'Saisissez une description pour votre blog.',
	'Timezone' => 'Fuseau horaire',
	'License' => 'Licence',
	'Your blog is currently licensed under:' => 'Votre blog est actuellement sous licence :',
	'Change license' => 'Changer licence',
	'Remove license' => 'Retirer licence',
	'Your blog does not have an explicit Creative Commons license.' => 'Votre blog n\'a pas de licence Creative Commons explicite.',
	'Select a license' => 'Selectionner une licence',

## tmpl/cms/list_member.tmpl
	'Are you sure you want to remove this role?' => 'Etes-vous sur(e) de vouloir supprimer ce role?',
	'Add a user to this blog' => 'Ajouter un utilisateur a ce blog',
	'Show only users where' => 'Afficher uniquement les utilisateurs ou',
	'role' => 'role',
	'enabled' => 'active',
	'disabled' => 'desactive',
	'pending' => 'en attente',

## tmpl/cms/cfg_comments.tmpl
	'Comment Settings' => 'Parametres des commentaires',
	'Note: Commenting is currently disabled at the system level.' => 'Note : Les commentaires sont actuellement desactives au niveau systeme.',
	'Comment authentication is not available because one of the needed modules, MIME::Base64 or LWP::UserAgent is not installed. Talk to your host about getting this module installed.' => 'L\'authetification de commentaire n\'est pas active car le module MIME::Base64 or LWP::UserAgent est absent. Contactez votre hebergeur pour l\'installation de ce module.',
	'Accept Comments' => 'Accepter les commentaires',
	'If enabled, comments will be accepted.' => 'Si active, les commentaires seront acceptes.',
	'Setup Registration' => 'Configuration de l\'enregistrement',
	'Commenting Policy' => 'Regles pour les commentaires',
	'Immediately approve comments from' => 'Approuver immediatement les commentaires de',
	'Specify what should happen to comments after submission. Unapproved comments are held for moderation.' => 'Specifiez ce qui doit se passer apres la soumission de commentaires. Les commentaires non-approuves sont retenus pour moderation.',
	'No one' => 'Personne',
	'Trusted commenters only' => 'Auteurs de commentaires fiables uniquement',
	'Any authenticated commenters' => 'Tout auteur de commentaire authentifie',
	'Anyone' => 'Tout le monde',
	'Allow HTML' => 'Autoriser le HTML',
	'If enabled, users will be able to enter a limited set of HTML in their comments. If not, all HTML will be stripped out.' => 'Si active, l\'auteur de commentaires pourra entrer du HTML de facon limitee dans son commentaire. Sinon, le html ne sera pas pris en compte.',
	'Limit HTML Tags' => 'Limiter les balises HTML',
	'Specifies the list of HTML tags allowed by default when cleaning an HTML string (a comment, for example).' => 'Specifie la liste des balises HTML autorisees par defaut lors du nettoyage d\'une chaine HTML (un commentaire, par exemple).',
	'Use defaults' => 'Utiliser les valeurs par defaut',
	'([_1])' => '([_1])',
	'Use my settings' => 'Utiliser mes parametres',
	'Disable \'nofollow\' for trusted commenters' => 'desactiver \'nofollow\' pour les auteurs de commentaires de confiance',
	'If enabled, the \'nofollow\' link relation will not be applied to any comments left by trusted commenters.' => 'Si active, l\'attribut de lien \'nofollow\' ne sera applique a aucun commentaire depose par un auteur de commentaires de confiance.',
	'Specify when Movable Type should notify you of new comments if at all.' => 'Specifier quand Movable Type doit vous notifier les nouveaux commentaires.',
	'Comment Display Options' => 'Options d\'affichage des commentaires',
	'Comment Order' => 'Ordre des commentaires',
	'Select whether you want visitor comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Selectionnez l\'ordre d\'affichage des commentaires publies par les visiteurs : croissant (les plus anciens en premier) ou decroissant (les plus recents en premier).',
	'Ascending' => 'Croissant',
	'Descending' => 'Decroissant',
	'Auto-Link URLs' => 'Liaison automatique des URL',
	'If enabled, all non-linked URLs will be transformed into links to that URL.' => 'Si active, toutes les urls non liees seront transformees en url actives.',
	'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Specifie les options de mise en forme du texte des commentaires publies par les visiteurs.',
	'CAPTCHA Provider' => 'Fournisseur de CAPTCHA',
	'none' => 'Aucun fournisseur',
	'No CAPTCHA provider available' => 'Aucun fournisseur de CAPTCHA disponible',
	'No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed, and CaptchaSourceImageBase directive points to captcha-source directory under mt-static/images.' => 'Aucun fournisseur de CAPTCHA n\'est disponible sur ce systeme. Merci de verifier si Image::Magick est installe, et si la directive CaptchaSourceImageBase contient le repertoire captcha-source dans mt-static/images.',
	'Use Comment Confirmation Page' => 'Utiliser la page de confirmation de commentaire',
	'Use comment confirmation page' => 'Utiliser la page de confirmation de commentaire',

## tmpl/cms/backup.tmpl
	'What to backup' => 'Ce qu\'il faut sauvegarder',
	'This option will backup Users, Roles, Associations, Blogs, Entries, Categories, Templates and Tags.' => 'Cette option va sauvegarder les utilisateurs, roles, associations, blogs, notes, categories, gabarits et tags.',
	'Everything' => 'Tout',
	'Reset' => 'Mettre a jour',
	'Choose blogs...' => 'Selectionner les blogs...',
	'Archive Format' => 'Format d\'archive',
	'The type of archive format to use.' => 'Le type de format d\'archive a utiliser.',
	'Don\'t compress' => 'Ne pas compresser',
	'Target File Size' => 'Limiter la taille du fichier cible',
	'Approximate file size per backup file.' => 'Taille de fichier approximative par fichier de sauvegarde.',
	'Don\'t Divide' => 'Pas de limitation',
	'Make Backup (b)' => 'Sauvegarder (b)',
	'Make Backup' => 'Sauvegarder',

## tmpl/cms/cfg_registration.tmpl
	'Registration Settings' => 'Parametres des enregistrements',
	'Your blog preferences have been saved.' => 'Les preferences de votre blog ont ete enregistrees.',
	'Allow registration for Movable Type.' => 'Autoriser les enregistrements pour Movable Type.',
	'Registration Not Enabled' => 'Enregistrement non active',
	'Note: Registration is currently disabled at the system level.' => 'Remarque : L\'enregistrement est actuellement desactive pour tout le systeme.',
	'Authentication Methods' => 'Methode d\'authentification',
	'Note: You have selected to accept comments from authenticated commenters only but authentication is not enabled. In order to receive authenticated comments, you must enable authentication.' => 'Attention: vous avez selectionne d\'accepter uniquement les commentaires de les auteurs de commentaires identifies MAIS l\'authentification n\'est pas activee. Vous devez l\'activer pour recevoir les commentaire a autoriser.',
	'Native' => 'Natif',
	'Require E-mail Address for Comments via TypePad' => 'Demander une adresse e-mail pour les commentaires via TypePad',
	'If enabled, visitors must allow their TypePad account to share e-mail address when commenting.' => 'Si active, les visiteurs devront autoriser leur compte TypePad a partager leur adresse e-mail lorsqu\'ils commentent.',
	'One or more Perl module may be missing to use this authentication method.' => 'Un ou plusieurs modules Perl manque peut-etre pour utiliser cette methode d\'authentification.',
	'Setup TypePad' => 'Configurer TypePad',
	'OpenID providers disabled' => 'Fournisseurs OpenID desactives',
	'Required module (Digest::SHA1) for OpenID commenter authentication is missing.' => 'Le module obligatoire (Digest::SHA1) pour l\'authentification des auteurs de commentaires avec OpenID est absent.',

## tmpl/cms/edit_entry.tmpl
	'Edit Page' => 'Editer une page',
	'Create Page' => 'Creer une Page',
	'Add folder' => 'Ajouter un repertoire',
	'Add folder name' => 'Ajouter un nom de repertoire',
	'Add new folder parent' => 'Ajouter un nouveau repertoire parent',
	'Save this page (s)' => 'Enregistrer cette page (s)',
	'Preview this page (v)' => 'Previsualiser cette page (v)',
	'Delete this page (x)' => 'Supprimer cette page (x)',
	'View Page' => 'Afficher une Page',
	'Edit Entry' => 'Editer une note',
	'Create Entry' => 'Creer une nouvelle note',
	'Add category' => 'Ajouter une categorie',
	'Add category name' => 'Ajouter un nom de categorie',
	'Add new category parent' => 'Ajouter une nouvelle categorie parente',
	'Save this entry (s)' => 'Enregistrer cette note (s)',
	'Preview this entry (v)' => 'Previsualiser cette note (v)',
	'Delete this entry (x)' => 'Supprimer cette note (x)',
	'View Entry' => 'Afficher la note',
	'A saved version of this entry was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Une version enregistree de cette note a ete sauvergardee automatiquement [_2]. <a href="[_1]">Recuperer le contenu sauvegarde automatiquement</a>',
	'A saved version of this page was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Une version enregistree de cette page a ete sauvergardee automatiquement [_2]. <a href="[_1]">Recuperer le contenu sauvegarde automatiquement</a>',
	'This entry has been saved.' => 'Cette note a ete enregistree.',
	'This page has been saved.' => 'Cette page a ete enregistree.',
	'One or more errors occurred when sending update pings or TrackBacks.' => 'Erreur lors de l\'envoi des pings ou des trackbacks.',
	'_USAGE_VIEW_LOG' => 'L\'erreur est enregistree dans le <a href="[_1]">journal (logs)</a>.',
	'Your customization preferences have been saved, and are visible in the form below.' => 'Vos preferences ont ete enregistrees et sont affichees dans le formulaire ci-dessous.',
	'Your changes to the comment have been saved.' => 'Les modifications apportees aux commentaires ont ete enregistrees.',
	'Your notification has been sent.' => 'Votre notification a ete envoyee.',
	'You have successfully recovered your saved entry.' => 'Vous avez recupere le contenu sauvegarde de votre note avec succes.',
	'You have successfully recovered your saved page.' => 'Vous avez recupere le contenu sauvegarde de votre page avec succes.',
	'An error occurred while trying to recover your saved entry.' => 'Une erreur est survenue lors de la tentative de recuperation de la note enregistree.',
	'An error occurred while trying to recover your saved page.' => 'Une erreur est survenue lors de la tentative de recuperation de la page enregistree.',
	'You have successfully deleted the checked comment(s).' => 'Les commentaires selectionnes ont ete supprimes.',
	'You have successfully deleted the checked TrackBack(s).' => 'Le(s) trackback(s) selectionne(s) ont ete correctement supprime(s).',
	'Change Folder' => 'Modifier le Dossier',
	'Stats' => 'Stats',
	'Unpublished (Draft)' => 'Non publie (Brouillon)',
	'Unpublished (Review)' => 'Non publie (Verification)',
	'Scheduled' => 'Planifie',
	'Published' => 'Publie',
	'Unpublished (Spam)' => 'Non publie (Spam)',
	'View' => 'Voir',
	'Share' => 'Partager',
	'<a href="[_2]">[quant,_1,comment,comments]</a>' => '<a href="[_2]">[quant,_1,commentaire,commentaires]</a>',
	'<a href="[_2]">[quant,_1,trackback,trackbacks]</a>' => '<a href="[_2]">[quant,_1,trackback,trackbacks]</a>',
	'Unpublished' => 'Non publie',
	'You must configure this blog before you can publish this entry.' => 'Vous devez configurer ce blog avant de publier cette note.',
	'You must configure this blog before you can publish this page.' => 'Vous devez configurer ce blog avant de publier cette page.',
	'[_1] - Created by [_2]' => '[_1] - a ete cree par [_2]',
	'[_1] - Published by [_2]' => '[_1] - a ete publie par [_2]',
	'[_1] - Edited by [_2]' => '[_1] - a ete edite par [_2]',
	'Publish On' => 'Publie le',
	'Publish Date' => 'Date de publication',
	'Select entry date' => 'Choisir la date de la note',
	'Unlock this entry&rsquo;s output filename for editing' => 'Deverrouiller le nom de fichier de la note pour le modifier',
	'Warning: If you set the basename manually, it may conflict with another entry.' => 'ATTENTION : Editer le nom de base manuellement peut creer des conflits avec d\'autres notes.',
	'Warning: Changing this entry\'s basename may break inbound links.' => 'ATTENTION : Changer le nom de base de cette note peut casser des liens entrants.',
	'close' => 'fermer',
	'Accept' => 'Accepter',
	'View Previously Sent TrackBacks' => 'Afficher les trackbacks envoyes precedemment',
	'Outbound TrackBack URLs' => 'URLs trackbacks sortants',
	'You have unsaved changes to this entry that will be lost.' => 'Certains de vos changements dans cette note n\'ont pas ete enregistres : ils seront perdus.',
	'You have unsaved changes to this page that will be lost.' => 'Certains de vos changements dans cette page n\'ont pas ete enregistres : ils seront perdus.',
	'Enter the link address:' => 'Saisissez l\'adresse du lien :',
	'Enter the text to link to:' => 'Saisissez le texte du lien :',
	'Your entry screen preferences have been saved.' => 'Vos preferences d\'edition ont ete enregistrees.',
	'Are you sure you want to use the Rich Text editor?' => 'Etes-vous sur de vouloir utiliser l\'editeur de texte enrichi ?',
	'Remove' => 'Retirer',
	'Make primary' => 'Rendre principal',
	'Display Options' => 'Options d\'affichage',
	'Fields' => 'Champs',
	'Metadata' => 'Metadonnees',
	'Top' => 'En haut',
	'Both' => 'En haut et en bas',
	'Bottom' => 'En bas',
	'Reset display options' => 'Re-initialiser les options d\'affichage',
	'Reset display options to blog defaults' => 'Re-initialiser les options d\'affichage avec les valeurs par defaut du blog',
	'Reset defaults' => 'Re-initialiser les valeurs par defaut',
	'Save display options' => 'Enregistrer les options d\'affichage',
	'OK' => 'OK',
	'Close display options' => 'Fermer les options d\'affichage',
	'This post was held for review, due to spam filtering.' => 'Cette note a ete retenue pour verification, a cause du filtrage spam.', # Translate - New
	'This post was classified as spam.' => 'Cette note a ete marquee comme etant du spam.',
	'Spam Details' => 'Details du spam',
	'Score' => 'Score',
	'Results' => 'Resultats',
	'Body' => 'Corps',
	'Extended' => 'Etendu',
	'Format:' => 'Format :',
	'(comma-delimited list)' => '(liste delimitee par virgule)',
	'(space-delimited list)' => '(liste delimitee par espace)',
	'(delimited by \'[_1]\')' => '(delimitee par \'[_1]\')',
	'Use <a href="http://blogit.typepad.com/">Blog It</a> to post to Movable Type from social networks like Facebook.' => 'Utiliser <a href="http://blogit.typepad.com/">Blog It</a> pour publier sur Movable Type depuis des reseaux sociaux comme Facebook.',
	'None selected' => 'Aucune selectionnee',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001-[_1] Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001-[_1] Six Apart. Tous droits reserves.',

## tmpl/cms/include/users_content_nav.tmpl
	'Profile' => 'Profil',
	'Details' => 'Details',

## tmpl/cms/include/comment_table.tmpl
	'comment' => 'commentaire',
	'comments' => 'commentaires',
	'to publish' => 'pour publier',
	'Publish selected comments (a)' => 'Publier les commentaires selectionnes (a)',
	'Delete selected comments (x)' => 'Supprimer les commentaires selectionnes (x)',
	'Report selected comments as Spam (j)' => 'Marquer les commentaires selectionnes comme etant du spam (j)',
	'Report selected comments as Not Spam and Publish (j)' => 'Marquer les commentaires selectionnes comme n\'etant pas du spam et les publier (j)',
	'Not Spam' => 'Non-spam',
	'Are you sure you want to remove all comments reported as spam?' => 'Etes-vous sur(e) de vouloir supprimer tous les commentaires notifies comme spam ?',
	'Delete all comments reported as Spam' => 'Supprimer tous les commentaires marques comme etant du spam',
	'Empty' => 'Vide',
	'Ban This IP' => 'Bannir cette adresse IP',
	'Entry/Page' => 'Note/Page',
	'Date' => 'Date',
	'IP' => 'IP',
	'Only show published comments' => 'N\'afficher que les commentaires publies',
	'Only show pending comments' => 'N\'afficher que les commentaires en attente',
	'Pending' => 'En attente',
	'Edit this comment' => 'Editer ce commentaire',
	'([quant,_1,reply,replies])' => '([quant,_1,reponse,reponses])',
	'Blocked' => 'Bloques',
	'Edit this [_1] commenter' => 'Modifier l\'auteur de commentaires de cette [_1]',
	'Search for comments by this commenter' => 'Chercher les commentaires de cet auteur de commentaires',
	'View this entry' => 'Voir cette note',
	'View this page' => 'Voir cette page',
	'Search for all comments from this IP address' => 'Rechercher tous les commentaires associes a cette adresse IP',

## tmpl/cms/include/member_table.tmpl
	'users' => 'utilisateurs',
	'Are you sure you want to remove the selected user from this blog?' => 'Etes-vous sur(e) de vouloir retirer l\'utilisateur selectionne de ce blog ?',
	'Are you sure you want to remove the [_1] selected users from this blog?' => 'Etes-vous sur(e) de vouloir retirer les [_1] utilisateurs selectionnes de ce blog ?',
	'Remove selected user(s) (r)' => 'Retirer l\'(es) utilisateur(s) selectionne(s) (r)',
	'_USER_ENABLED' => 'Utilisateur active',
	'Trusted commenter' => 'Auteur de commentaires fiable',
	'Link' => 'Lien',
	'Remove this role' => 'Retirer ce role',

## tmpl/cms/include/feed_link.tmpl
	'Activity Feed' => 'Flux d\'activite',

## tmpl/cms/include/import_end.tmpl
	'All data imported successfully!' => 'Toutes les donnees ont ete importees avec succes !',
	'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Assurez vous d\'avoir bien enleve les fichiers importes du repertoire \'import\', pour eviter une re-importation des memes fichiers a l\'avenir .',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Une erreur s\'est produite pendant le processus: [_1]. Merci de verifier vos fichiers import.',

## tmpl/cms/include/overview-left-nav.tmpl
	'List Weblogs' => 'Liste des Blogs',
	'Weblogs' => 'Blogs',
	'List Users and Groups' => 'Lister les Utilisateurs et les Groupes',
	'Users &amp; Groups' => 'Utilisateurs &amp; Groupes',
	'List Associations and Roles' => 'Lister les associations et les roles',
	'List Plugins' => 'Liste des Plugins',
	'Aggregate' => 'Multi-Blogs',
	'List Entries' => 'Afficher les notes',
	'List uploaded files' => 'Lister les fichiers envoyes',
	'List Tags' => 'Liste de tags',
	'List Comments' => 'Afficher les commentaires',
	'List TrackBacks' => 'Lister les trackbacks',
	'Configure' => 'Configurer',
	'Edit System Settings' => 'Editer les Parametres Systeme',
	'Utilities' => 'Utilitaires',
	'Search &amp; Replace' => 'Chercher &amp; Remplacer',
	'_SEARCH_SIDEBAR' => 'Rechercher',
	'Show Activity Log' => 'Afficher le journal (logs)',

## tmpl/cms/include/comment_detail.tmpl

## tmpl/cms/include/asset_table.tmpl
	'assets' => 'Elements',
	'Delete selected assets (x)' => 'Effacer les contenus selectionnes (x)',
	'Size' => 'Taille',
	'Created By' => 'Cree par',
	'Created On' => 'Cree le',
	'Asset Missing' => 'Element manquant',
	'No thumbnail image' => 'Pas de miniature',
	'[_1] is missing' => '[_1] est manquant',

## tmpl/cms/include/import_start.tmpl
	'Importing...' => 'Importation...',
	'Importing entries into blog' => 'Importation de notes dans le blog',
	'Importing entries as user \'[_1]\'' => 'Importation des notes en tant qu\'utilisateur \'[_1]\'',
	'Creating new users for each user found in the blog' => 'Creation de nouveaux utilisateur correspondant a chaque utilisateur trouve dans le blog',

## tmpl/cms/include/log_table.tmpl
	'No log records could be found.' => 'Aucune donnee du journal n\'a ete trouvee.',
	'_LOG_TABLE_BY' => 'Utilisateur',
	'IP: [_1]' => 'IP : [_1]',

## tmpl/cms/include/pagination.tmpl

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been backed up successfully!' => 'Toutes les donnees ont ete sauvegardees avec succes!',
	'Download This File' => 'Telecharger ce fichier',
	'_BACKUP_TEMPDIR_WARNING' => '_BACKUP_TEMPDIR_WARNING',
	'_BACKUP_DOWNLOAD_MESSAGE' => '_BACKUP_DOWNLOAD_MESSAGE',
	'An error occurred during the backup process: [_1]' => 'Une erreur est survenue pendant la sauvegarde: [_1]',

## tmpl/cms/include/cfg_system_content_nav.tmpl

## tmpl/cms/include/cfg_content_nav.tmpl

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Ajoute(e)',
	'Click to edit contact' => 'Cliquer pour modifier le contact',
	'Save changes' => 'Enregistrer les modifications',

## tmpl/cms/include/footer.tmpl
	'This is a beta version of Movable Type and is not recommended for production use.' => 'Ceci est une version beta de Movable Type et n\'est pas recommande pour une utilisation en production.',
	'http://www.movabletype.org' => 'http://www.movabletype.org',
	'MovableType.org' => 'MovableType.org',
	'http://wiki.movabletype.org/' => 'http://wiki.movabletype.org/',
	'Wiki' => 'Wiki',
	'http://www.movabletype.com/support/' => 'http://www.movabletype.com/support/',
	'Support' => 'Support',
	'http://www.movabletype.org/feedback.html' => 'http://www.movabletype.org/feedback.html',
	'Send us Feedback' => 'Faites nous part de vos retours',
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]',
	'with' => 'avec',

## tmpl/cms/include/tools_content_nav.tmpl

## tmpl/cms/include/commenter_table.tmpl
	'Last Commented' => 'Dernier commente',
	'Only show trusted commenters' => 'Afficher uniquement les auteurs de commentaires fiable',
	'Only show banned commenters' => 'Afficher uniquement les auteurs de commentaires bannis',
	'Only show neutral commenters' => 'Afficher uniquement les auteurs de commentaires neutres',
	'Edit this commenter' => 'Editer cet auteur de commentaires',
	'View this commenter&rsquo;s profile' => 'Voir le profil de cet auteur de commentaires',

## tmpl/cms/include/ping_table.tmpl
	'Publish selected [_1] (p)' => 'Publier le(s) [_1] selectionne(s) (p)',
	'Delete selected [_1] (x)' => 'Supprimer le(s) [_1] selectionne(s) (x)',
	'Report selected [_1] as Spam (j)' => 'Marquer le(s) [_1] selectionne(s) comme etant du spam (j)',
	'Report selected [_1] as Not Spam and Publish (j)' => 'Marquer le(s) [_1] selectionne(s) comme n\'etant pas du spam et les publier (j)',
	'Are you sure you want to remove all TrackBacks reported as spam?' => 'Etes-vous sur de vouloir supprimer tous les trackbacks notifies comme spam?',
	'Deletes all [_1] reported as Spam' => 'Supprimer tous les [_1] marques comme etant du spam',
	'From' => 'De',
	'Target' => 'Cible',
	'Only show published TrackBacks' => 'Afficher uniquement les trackbacks publies',
	'Only show pending TrackBacks' => 'Afficher uniquement les trackbacks en attente',
	'Edit this TrackBack' => 'Modifier ce trackback',
	'Go to the source entry of this TrackBack' => 'Aller a la note a l\'origine de ce trackback',
	'View the [_1] for this TrackBack' => 'Voir [_1] pour ce trackback',

## tmpl/cms/include/entry_table.tmpl
	'Save these entries (s)' => 'Enregistrer les notes selectionnees (s)',
	'Republish selected entries (r)' => 'Republier les notes selectionnees (r)',
	'Delete selected entries (x)' => 'Supprimer les notes selectionnees (x)',
	'Save these pages (s)' => 'Enregistrer les pages selectionnees (s)',
	'Republish selected pages (r)' => 'Republier les pages selectionnees (r)',
	'Delete selected pages (x)' => 'Supprimer les pages selectionnees (x)',
	'to republish' => 'pour republier',
	'Last Modified' => 'Derniere modification',
	'Created' => 'Cree',
	'Only show unpublished entries' => 'Afficher uniquement les notes non publiees',
	'Only show unpublished pages' => 'Afficher uniquement les pages non publiees',
	'Only show published entries' => 'Afficher uniquement les notes publiees',
	'Only show published pages' => 'Afficher uniquement les pages publiees',
	'Only show entries for review' => 'Afficher uniquement les notes a verifier',
	'Only show pages for review' => 'Afficher uniquement les pages a verifier',
	'Only show scheduled entries' => 'Afficher uniquement les notes planifiees',
	'Only show scheduled pages' => 'Afficher uniquement les pages planifiees',
	'Only show spam entries' => 'Afficher uniquement les notes indesirables (spam)',
	'Only show spam pages' => 'Afficher uniquement les pages indesirables (spam)',
	'View entry' => 'Afficher une note',
	'View page' => 'Afficher une page',
	'No entries could be found. <a href="[_1]">Create an entry</a> now.' => 'Aucune note n\'a ete trouvee. <a href="[_1]">Creer une note</a> maintenant.',
	'No page could be found. <a href="[_1]">Create a page</a> now.' => 'Aucune page n\'a ete trouvee. <a href="[_1]">Creer une page</a> maintenant.',

## tmpl/cms/include/login_mt.tmpl

## tmpl/cms/include/author_table.tmpl
	'_USER_DISABLED' => 'Utilisateur desactive',

## tmpl/cms/include/calendar.tmpl
	'_LOCALE_WEEK_START' => '1',
	'S|M|T|W|T|F|S' => 'D|L|M|M|J|V|S',
	'January' => 'Janvier',
	'Febuary' => 'Fevrier',
	'March' => 'Mars',
	'April' => 'Avril',
	'May' => 'Mai',
	'June' => 'Juin',
	'July' => 'Juillet',
	'August' => 'Aout',
	'September' => 'Septembre',
	'October' => 'Octobre',
	'November' => 'Novembre',
	'December' => 'Decembre',
	'Jan' => 'Jan',
	'Feb' => 'Fev',
	'Mar' => 'Mar',
	'Apr' => 'Avr',
	'_SHORT_MAY' => 'Mai',
	'Jun' => 'Juin',
	'Jul' => 'Juil',
	'Aug' => 'Aou',
	'Sep' => 'Sep',
	'Oct' => 'Oct',
	'Nov' => 'Nov',
	'Dec' => 'Dec',
	'[_1:calMonth] [_2:calYear]' => '[_1:calMonth] [_2:calYear]',

## tmpl/cms/include/itemset_action_widget.tmpl
	'More actions...' => 'Plus d\'actions...',
	'Plugin Actions' => 'Actions du plugin',
	'Go' => 'OK',

## tmpl/cms/include/anonymous_comment.tmpl
	'Anonymous Comments' => 'Commentaires anonymes',
	'Require E-mail Address for Anonymous Comments' => 'Necessite une adresse email pour les commentaires anonymes',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Si active, le visiteur doit donner une adresse email valide pour commenter.',

## tmpl/cms/include/category_selector.tmpl
	'Add sub category' => 'Ajouter une sous-categorie',
	'Add new' => 'Creer',

## tmpl/cms/include/list_associations/page_title.tmpl
	'Permissions for [_1]' => 'Autorisations pour [_1]',
	'Permissions: System-wide' => 'Autorisations : configuration globale',
	'Users for [_1]' => 'Utilisateurs pour [_1]',

## tmpl/cms/include/display_options.tmpl
	'_DISPLAY_OPTIONS_SHOW' => 'Afficher',
	'[quant,_1,row,rows]' => '[quant,_1,ligne,lignes]',
	'Compact' => 'Compacte',
	'Expanded' => 'Etendue',
	'Action Bar' => 'Barre d\'action',
	'Date Format' => 'Format date',
	'Relative' => 'Relative',
	'Full' => 'Entiere',

## tmpl/cms/include/backup_start.tmpl
	'Backing up Movable Type' => 'Sauvegarder Movable Type',

## tmpl/cms/include/template_table.tmpl
	'Create Archive Template:' => 'Creer un gabarit d\'archives',
	'Entry Listing' => 'Liste des notes',
	'Create template module' => 'Creer un module de gabarit',
	'Create index template' => 'Creer un gabarit index',
	'templates' => 'gabarits',
	'Publish selected templates (a)' => 'Publier les gabarits selectionnes (a)',
	'Archive Path' => 'Chemin d\'archive',
	'Cached' => 'Cache',
	'Linked Template' => 'Gabarit lie',
	'-' => '-',
	'Manual' => 'Manuellement',
	'Dynamic' => 'Dynamique',
	'Publish Queue' => 'Publication en mode File d\'Attente',
	'Static' => 'Statique',
	'Yes' => 'Oui',
	'No' => 'Non',

## tmpl/cms/include/asset_upload.tmpl
	'Before you can upload a file, you need to publish your blog. [_1]Configure your blog\'s publishing paths[_2] and rebuild your blog.' => 'Avant de pouvoir envoyer un fichier, vous devez publier votre blog. [_1]Configurez les chemins de publication de votre blog[_2] et republiez votre blog.',
	'Your system or blog administrator needs to publish the blog before you can upload files. Please contact your system or blog administrator.' => 'L\'administrateur du systeme ou du blog doit publier le blog avant que vous puissiez envoyer des fichiers.',
	'Close (x)' => 'Fermer (x)',
	'Select File to Upload' => 'Selectionnez le fichier a envoyer',
	'_USAGE_UPLOAD' => 'Vous pouvez telecharger le fichier ci-dessus dans le chemin local de votre site <a href="javascript:alert(\'[_1]\')">(?)</a> ou dans le chemin des archives de votre site <a href="javascript:alert(\'[_2]\')">(?)</a>. Vous pouvez egalement telecharger le fichier dans un repertoire compris dans les repertoires mentionnes ci-dessus, en specifiant le chemin dans les champs de droite (<i>images</i>, par exemple). Les repertoires qui n\'existent pas encore seront crees.',
	'Upload Destination' => 'Destination du fichier',
	'Choose Folder' => 'Choisir le Dossier',
	'Upload (s)' => 'Envoyer (s)',
	'Upload' => 'Envoyer',
	'Back (b)' => 'Retour (b)',
	'Cancel (x)' => 'Annuler (x)',

## tmpl/cms/include/listing_panel.tmpl
	'Step [_1] of [_2]' => 'Etape  [_1] sur [_2]',
	'Go to [_1]' => 'Aller a [_1]',
	'Sorry, there were no results for your search. Please try searching again.' => 'Desole, aucun resultat trouve pour cette recherche. Merci d\'essayer a nouveau.',
	'Sorry, there is no data for this object set.' => 'Desole, mais il n\'y a pas de donnees pour cet ensemble d\'objets.',
	'Confirm (s)' => 'Confirmer (s)',
	'Confirm' => 'Confirmer',
	'Continue (s)' => 'Continuer (s)(',

## tmpl/cms/include/header.tmpl
	'Help' => 'Aide',
	'Hi [_1],' => 'Bonjour [_1],',
	'Logout' => 'Deconnexion',
	'Select another blog...' => 'Selectionnez un autre blog...',
	'Create a new blog' => 'Creer un nouveau blog',
	'Write Entry' => 'Ecrire une note',
	'Blog Dashboard' => 'Tableau de bord du Blog',
	'View Site' => 'Voir le site',
	'Search (q)' => 'Recherche (q)',

## tmpl/cms/include/archetype_editor.tmpl
	'Decrease Text Size' => 'Diminuer la taille du texte',
	'Increase Text Size' => 'Augmenter la taille du texte',
	'Bold' => 'Gras',
	'Italic' => 'Italique',
	'Underline' => 'Souligne',
	'Strikethrough' => 'Raye',
	'Text Color' => 'Couleur du texte',
	'Email Link' => 'Lien email',
	'Begin Blockquote' => 'Commencer le texte en retrait',
	'End Blockquote' => 'Fin paragraphe en retrait ',
	'Bulleted List' => 'Liste a puces',
	'Numbered List' => 'Liste numerotee',
	'Left Align Item' => 'Aligner a gauche',
	'Center Item' => 'Centrer l\'element',
	'Right Align Item' => 'Aligner l\'element a droite',
	'Left Align Text' => 'Aligner le texte a gauche',
	'Center Text' => 'Centrer le texte',
	'Right Align Text' => 'Aligner le texte a droite',
	'Insert Image' => 'Inserer une image',
	'Insert File' => 'Inserer un fichier',
	'WYSIWYG Mode' => 'Mode WYSIWYG',
	'HTML Mode' => 'Mode HTML',

## tmpl/cms/include/blog_table.tmpl
	'Delete selected blogs (x)' => 'Effacer les blogs selectionnes (x)',

## tmpl/cms/include/blog-left-nav.tmpl
	'Creating' => 'Creer',
	'Community' => 'Communaute',
	'List Commenters' => 'Lister les auteurs de commentaires',
	'Edit Address Book' => 'Modifier le carnet d\'adresses',
	'List Users &amp; Groups' => 'Liste des utilisateurs &amp; Groupes',
	'List &amp; Edit Templates' => 'Lister &amp; Editer les gabarits',
	'Edit Categories' => 'Modifier les categories',
	'Edit Tags' => 'Editer les tags',
	'Edit Weblog Configuration' => 'Modifier la configuration du blog',
	'Backup this weblog' => 'Sauvegarder ce blog',
	'Import &amp; Export Entries' => 'Importer &amp; Exporter les Notes',
	'Import / Export' => 'Importer / Exporter',
	'Rebuild Site' => 'Actualiser le site',

## tmpl/cms/include/archive_maps.tmpl
	'Path' => 'Chemin',
	'Custom...' => 'Personnalise...',

## tmpl/cms/list_author.tmpl
	'Users: System-wide' => 'Utilisateurs : configuration globale',
	'You have successfully disabled the selected user(s).' => 'Vous avez desactive avec succes les utilisateurs selectionnes.',
	'You have successfully enabled the selected user(s).' => 'Vous avez active avec succes les utilisateurs selectionnes.',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'Vous avez supprime avec succes les utilisateurs dans le systeme.',
	'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Enterprise.' => 'Les utilisateurs effaces existent encore dans le repertoire externe. En consequence ils pourront encore s\'identifier dans Movable Type Entreprise',
	'You have successfully synchronized users\' information with the external directory.' => 'Vous avez synchronise avec succes les informations des utilisateurs avec le repertoire externe.',
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => 'Certains des utilisateurs selectionnes ([_1])ne peuvent pas etre re-actives car ils ne sont pas dans le repertoire externe.',
	'An error occured during synchronization.  See the <a href=\'[_1]\'>activity log</a> for detailed information.' => 'Une erreur s\'est produite durant la synchronisation.  Consultez le <a href=\'[_1]\'>journal (logs)</a> pour plus d\'informations.',
	'Enable selected users (e)' => 'Activer les utilisateurs selectionnes (e)',
	'_USER_ENABLE' => 'Activer',
	'_NO_SUPERUSER_DISABLE' => 'Puisque vous etes administrateur du systeme Movable Type, vous ne pouvez vous desactiver vous-meme.',
	'Disable selected users (d)' => 'Desactiver les utilisateurs selectionnes (d)',
	'_USER_DISABLE' => 'Desactiver',
	'Showing All Users' => 'Afficher tous les utilisateurs',

## tmpl/cms/view_log.tmpl
	'The activity log has been reset.' => 'Le journal (logs) a ete reinitialise.',
	'All times are displayed in GMT[_1].' => 'Toutes les heures sont affichees en GMT[_1].',
	'All times are displayed in GMT.' => 'Toutes les heures sont affichees en GMT.',
	'Show only errors' => 'Montrer uniquement les erreurs',
	'System Activity Log' => 'Journal (logs)',
	'Filtered' => 'Filtres',
	'Filtered Activity Feed' => 'Flux d\'activite filtre',
	'Download Filtered Log (CSV)' => 'Telecharger le journal filtre (CSV)',
	'Download Log (CSV)' => 'Telecharger le journal (CSV)',
	'Clear Activity Log' => 'Effacer le journal (logs)',
	'Are you sure you want to reset the activity log?' => 'Etes-vous sur(e) de vouloir re-initialiser le journal (logs) ?',
	'Showing all log records' => 'Affichage de toutes les donnees du journal',
	'Showing log records where' => 'Affichage des donnees du journal ou',
	'Show log records where' => 'Afficher les donnees du journal ou',
	'level' => 'le statut',
	'classification' => 'classification',
	'Security' => 'Securite',
	'Error' => 'Erreur',
	'Information' => 'Information',
	'Debug' => 'Debug',
	'Security or error' => 'Securite ou erreur',
	'Security/error/warning' => 'Securite/erreur/mise en garde',
	'Not debug' => 'Pas debugue',
	'Debug/error' => 'Debug/erreur',

## tmpl/cms/setup_initial_blog.tmpl
	'Create Your First Blog' => 'Creez votre premier blog',
	'The blog name is required.' => 'Le nom du blog est necessaire.',
	'The blog URL is required.' => 'L\'url du blog est obligatoire.',
	'The publishing path is required.' => 'Le chemin de publication est necessaire.',
	'The timezone is required.' => 'Le fuseau horaire est necessaire.',
	'Template Set' => 'Ensemble de modeles',
	'Select the templates you wish to use for this new blog.' => 'Selectionnez les modeles que vous souhaitez utiliser pour ce nouveau blog.',
	'Finish install (s)' => 'Terminer l\'installation',
	'Finish install' => 'Finir l\'installation',
	'Back (x)' => 'Retour',

## tmpl/cms/refresh_results.tmpl
	'Template Refresh' => 'Reactualiser les gabarits',
	'No templates were selected to process.' => 'Aucun gabarit selectionne pour cette action.',
	'Return to templates' => 'Retourner aux gabarits',

## tmpl/cms/cfg_spam.tmpl
	'Spam Settings' => 'Parametres du spam',
	'Your spam preferences have been saved.' => 'Vos preferences de spam ont ete sauvegardees.',
	'Auto-Delete Spam' => 'Effacer automatiquement le spam',
	'If enabled, feedback reported as spam will be automatically erased after a number of days.' => 'Si active, les commentaires notifies comme spam seront automatiquement effaces apres un certain nombre de jours.',
	'Delete Spam After' => 'Effacer le spam apres',
	'When an item has been reported as spam for this many days, it is automatically deleted.' => 'Quand un element a ete notifie comme spam depuis tant de jours, il est automatiquement efface.',
	'Spam Score Threshold' => 'Niveau de filtrage du spam',
	'Comments and TrackBacks receive a spam score between -10 (complete spam) and +10 (not spam). Feedback with a score which is lower than the threshold shown above will be reported as spam.' => 'Les commentaires et les trackbacks recoivent un score de spam entre -10 (spam assure) et +10 (non spam). Un commentaire avec un score qui est plus faible que le seuil ci-dessus sera notifie comme spam.',
	'Less Aggressive' => 'Moins agressif',
	'Decrease' => 'Baisser',
	'Increase' => 'Augmenter',
	'More Aggressive' => 'Plus agressif',

## tmpl/cms/cfg_entry.tmpl
	'Entry Settings' => 'Parametres des notes',
	'Display Settings' => 'Preferences d\'affichage',
	'Entry Listing Default' => 'Listage des notes par defaut',
	'Select the number of days of entries or the exact number of entries you would like displayed on your blog.' => 'Selectionner le nombre de jours de notes ou le nombre exact de notes que vous voulez afficher sur votre blog.',
	'Days' => 'Jours',
	'Entry Order' => 'Ordre des notes',
	'Select whether you want your entries displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Choisissez si vous voulez afficher vos notes en ascendant (les plus anciennes en haut) ou descendant (les plus recentes en haut).',
	'Excerpt Length' => 'Longueur de l\'extrait',
	'Enter the number of words that should appear in an auto-generated excerpt.' => 'Entrez le nombre de mot a afficher pour les extraits de notes.',
	'Date Language' => 'Langue de la date',
	'Select the language in which you would like dates on your blog displayed.' => 'Selectionnez la langue dans laquelle vous souhaitez afficher les dates sur votre blog.',
	'Czech' => 'Tcheque',
	'Danish' => 'Danois',
	'Dutch' => 'Neerlandais',
	'English' => 'Anglais',
	'Estonian' => 'Estonien',
	'French' => 'Francais',
	'German' => 'Allemand',
	'Icelandic' => 'Islandais',
	'Italian' => 'Italien',
	'Japanese' => 'Japonais',
	'Norwegian' => 'Norvegien',
	'Polish' => 'Polonais',
	'Portuguese' => 'Portugais',
	'Slovak' => 'Slovaque',
	'Slovenian' => 'Slovene',
	'Spanish' => 'Espagnol',
	'Suomi' => 'Finlandais',
	'Swedish' => 'Suedois',
	'Basename Length' => 'Longueur du nom de base',
	'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => 'Specifier la longueur par defaut du nom de base. peut etre comprise entre 15 et 250.',
	'New Entry Defaults' => 'Preferences pour les nouvelles notes',
	'Specifies the default Entry Status when creating a new entry.' => 'Specifie le statut de note par defaut quand une nouvelle note est creee.',
	'Specifies the default Text Formatting option when creating a new entry.' => 'Specifie l\'option par defaut de mise en forme du texte des nouvelles notes.',
	'Specifies the default Accept Comments setting when creating a new entry.' => 'Specifie l\'option par defaut des commentaires acceptes lors de la creation d\'une nouvelle note.',
	'Note: This option is currently ignored since comments are disabled either blog or system-wide.' => 'Remarque : Cette option est actuellement ignoree car les commentaires sont desactives sur le blog ou sur tout le systeme.',
	'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Specifie l\'option par defaut des trackbacks acceptes lors de la creation d\'une nouvelle note.',
	'Note: This option is currently ignored since TrackBacks are disabled either blog or system-wide.' => 'Remarque : Cette option est actuellement ignoree car les trackbacks sont desactives soit sur le blog, soit au niveau de tout le systeme.',
	'Replace Word Chars' => 'Remplacer les caracteres de Word',
	'Smart Replace' => 'Remplacer par',
	'Replace UTF-8 characters frequently used by word processors with their more common web equivalents.' => 'Remplacer les caracteres UTF-8 utilises frequemment par l\'editeur de texte par leur equivalent web le plus commun.',
	'No substitution' => 'Ne pas effectuer de remplacements',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'Entites de caracteres (&amp#8221;, &amp#8220;, etc.)',
	'ASCII equivalents (&quot;, \', ..., -, --)' => 'Equivalents ASCII (&quot;, \', ..., -, --)',
	'Replace Fields' => 'Appliquer le remplacement des caracteres dans les champs',
	'Extended entry' => 'Suite de la note',
	'Default Editor Fields' => 'Champs d\'edition par defaut',
	'Editor Fields' => 'Champs d\'edition',
	'_USAGE_ENTRYPREFS' => 'La configuration des champs determine les champs de saisie qui apparaitront dans les ecrans de creation et de modification des notes. Vous pouvez selectionner une configuration existante (basique ou avancee), ou personnaliser vos ecrans en activant le bouton Personnalisee, puis en selectionnant les champs que vous souhaitez voir apparaitre.',
	'Action Bars' => 'Barres de taches',
	'Select the location of the entry editor&rsquo;s action bar.' => 'Selectionner l\'emplacement de la barre d\'action de l\'editeur de note.',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Modifier le repertoire',
	'Your folder changes have been made.' => 'Vos modifications du repertoire ont ete faites.',
	'Manage Folders' => 'Gerer les Repertoires',
	'Manage pages in this folder' => 'Gerer les pages de ce dossier',
	'You must specify a label for the folder.' => 'Vous devez specifier un nom pour le repertoire.',
	'Save changes to this folder (s)' => 'Enregistrer les modifications de ce repertoire (s)',

## tmpl/cms/list_widget.tmpl
	'Widget Sets' => 'Groupes de widgets',
	'Delete selected Widget Sets (x)' => 'Effacer les groupes de widgets selectionnes (x)',
	'Helpful Tips' => 'Astuces',
	'To add a widget set to your templates, use the following syntax:' => 'Pour ajouter un groupe de widgets a vos gabarits, utilisez la syntaxe suivante :',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Nom du groupe de widgets&quot;$&gt;</strong>',
	'Your changes to the widget set have been saved.' => 'Les modifications apportees au widget ont ete enregistrees.',
	'You have successfully deleted the selected widget set(s) from your blog.' => 'Vous avez supprime de votre blog les groupes de widgets selectionnes.',
	'No Widget Sets could be found.' => 'Aucun groupe de widgets n\'a ete trouve',
	'Create widget template' => 'Creer un gabarit de widget',
	'Widget Template' => 'Gabarit de Widget',
	'Widget Templates' => 'Gabarits de Widget',

## tmpl/cms/list_notification.tmpl
	'You have added [_1] to your address book.' => 'Vous avez ajoute [_1] a votre carnet d\'adresses.',
	'You have successfully deleted the selected contacts from your address book.' => 'Vous avez supprime avec succes les contacts selectionnes de votre carnet d\'adresses.',
	'Download Address Book (CSV)' => 'Telecharger le carnet d\'adresses (CSV)',
	'contact' => 'contact',
	'contacts' => 'contacts',
	'Create Contact' => 'Creer un contact',
	'Website URL' => 'URL du site',
	'Add Contact' => 'Ajouter un contact',

## tmpl/cms/export.tmpl
	'You must select a blog to export.' => 'Vous devez selectionner un blog a exporter.',
	'_USAGE_EXPORT_1' => 'L\'exportation vous permet de sauvegarder le contenu de votre blog dans un fichier. Vous pourrez par la suite proceder a l\'importation de ce fichier si vous souhaitez restaurer vos notes ou transferer vos notes d\'un blog a un autre.',
	'Blog to Export' => 'Blog a exporter',
	'Select a blog for exporting.' => 'Selectionnez un blog a exporter.',
	'Export Blog (s)' => 'Exporter le blog (s)',
	'Export Blog' => 'Exporter le blog',

## tmpl/cms/upgrade_runner.tmpl
	'Initializing database...' => 'Initialisation de la base de donnees...',
	'Upgrading database...' => 'Mise a jour de la base de donnees...',
	'Installation complete!' => 'Installation terminee !',
	'Upgrade complete!' => 'Mise a jour terminee !',
	'Starting installation...' => 'Debut de l\'installation...',
	'Starting upgrade...' => 'Debut de la mise a jour...',
	'Error during installation:' => 'Erreur lors de l\'installation :',
	'Error during upgrade:' => 'Erreur lors de la mise a jour :',
	'Sign in to Movable Type (s)' => 'Connectez-vous sur Movable Type (s)',
	'Return to Movable Type (s)' => 'Retour vers Movable Type',
	'Sign in to Movable Type' => 'Connectez-vous sur Movable Type',
	'Return to Movable Type' => 'Retourner a Movable Type',
	'Your database is already current.' => 'Votre base de donnees est deja actualisee.',

## tmpl/cms/edit_category.tmpl
	'Edit Category' => 'Editer les categories',
	'Your category changes have been made.' => 'Les modifications apportees ont ete enregistrees.',
	'Manage entries in this category' => 'Gerer les notes dans cette categorie',
	'You must specify a label for the category.' => 'Vous devez specifier un titre pour cette categorie.',
	'_CATEGORY_BASENAME' => 'Nom de base',
	'This is the basename assigned to your category.' => 'Ceci est le nom de base assigne a votre categorie.',
	'Unlock this category&rsquo;s output filename for editing' => 'Deverrouiller le nom de fichier de cette categorie pour le modifier',
	'Warning: Changing this category\'s basename may break inbound links.' => 'Attention: changer le nom de la categorie risque de casser des liens entrants.',
	'Inbound TrackBacks' => 'Trackbacks entrants',
	'Accept Trackbacks' => 'Accepter trackbacks',
	'If enabled, TrackBacks will be accepted for this category from any source.' => 'Si active, les trackbacks seront acceptes pour cette categorie quelle que soit la source.',
	'View TrackBacks' => 'Voir les trackbacks',
	'TrackBack URL for this category' => 'URL trackback pour cette categorie',
	'_USAGE_CATEGORY_PING_URL' => 'Il s\'agit de l\'URL utilisee par vos lecteurs pour envoyer des trackbacks aux notes de votre blog. Si vous souhaitez permettre l\'envoi d\'un trackback a tous vos lecteurs, publiez cette URL. Si vous preferez reserver l\'envoi d\'un trackback a seulement certaines personnes, communiquez cette URL de maniere privee. Enfin, si vous souhaitez inclure la liste des trackbacks entrant dans l\'index de votre gabarit, consultez la documentation Movable Type.',
	'Passphrase Protection' => 'Protection Passphrase',
	'Optional' => 'Optionnels',
	'Outbound TrackBacks' => 'Trackbacks sortants',
	'Trackback URLs' => 'URLs de trackback',
	'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you create an entry in this category. (Separate URLs with a carriage return.)' => 'Saisir les URLs des sites web auxquels vous souhaitez envoyer un trackback chaque fois que vous creez une note dans cette categorie. (Separez les URLs avec un retour chariot.)',
	'Save changes to this category (s)' => 'Enregistrer les modifications de cette categorie (s)',

## tmpl/cms/dialog/recover.tmpl
	'The email address provided is not unique.  Please enter your username.' => 'L\'adresse email fournie n\'est pas unique. Merci de saisir votre nom d\'utilisateur.',
	'An email with a link to reset your password has been sent to your email address ([_1]).' => 'Un email contenant un lien pour reinitialiser votre mot de passe a ete envoye a votre adresse email ([_1]).',
	'Go Back (x)' => 'Retour (x)',
	'Recover (s)' => 'Recuperer (s)',
	'Recover' => 'Recuperer',

## tmpl/cms/dialog/restore_end.tmpl
	'An error occurred during the restore process: [_1] Please check your restore file.' => 'Une erreur s\'est produite pendant la procedure de restauration: [_1] Merci de verifier votre fichier de restauration.',
	'View Activity Log (v)' => 'Voir le journal (logs) (v)',
	'All data restored successfully!' => 'Toutes les donnees ont ete restaurees avec succes !',
	'Close (s)' => 'Fermer (s)',
	'Next Page' => 'Page suivante',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => 'Cette page va etre redirigee vers une nouvelle page dans 3 secondes. [_1]Arreter la redirection.[_2]',

## tmpl/cms/dialog/asset_replace.tmpl
	'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'Un fichier nomme \'[_1]\' existe deja. Souhaitez-vous le remplacer ?',
	'Yes (s)' => 'Oui (s)',

## tmpl/cms/dialog/asset_list.tmpl
	'Insert Asset' => 'Inserer un element',
	'Upload New File' => 'Envoyer un nouveau fichier',
	'Upload New Image' => 'Envoyer une nouvelle image',
	'Asset Name' => 'Nom de l\'element',
	'View Asset' => 'Apercu de l\'element',
	'Next (s)' => 'Suivant (s)',
	'Insert (s)' => 'Inserer (s)',
	'Insert' => 'Inserer',
	'No assets could be found.' => 'Aucun element n\'a ete trouve.',

## tmpl/cms/dialog/new_password.tmpl
	'Choose New Password' => 'Choisissez un nouveau mot de passe',
	'Confirm Password' => 'Mot de passe (confirmation) *',
	'Change Password' => 'Changer de Mot de passe',

## tmpl/cms/dialog/refresh_templates.tmpl
	'Refresh Template Set' => 'Reactualiser le Groupe de Gabarits',
	'Refresh [_1] template set' => 'Reactualiser le groupe de gabarits [_1]',
	'Refresh global templates' => 'Mettre a jour les gabarits generaux',
	'Updates current templates while retaining any user-created templates.' => 'Met a jour les gabarits courants tout en empechant la creation de gabarits par l\'utilisateur.',
	'Apply a new template set' => 'Appliquer un nouveau groupe de gabarits',
	'Deletes all existing templates and install the selected template set.' => 'Supprime tout les gabarits existants et installe le groupe de gabarits selectionne.',
	'Reset to factory defaults' => 'Remettre a zero les modifications',
	'Deletes all existing templates and installs factory default template set.' => 'Supprime tous les gabarits existants et installe les groupes de gabarits par defaut ',
	'Make backups of existing templates first' => 'Faire d\'abord des sauvegardes des gabarits existants',
	'You have requested to <strong>refresh the current template set</strong>. This action will:' => 'Vous avez demande a <strong>reactualiser le groupe de gabarit actuel</strong>. Cette action va :',
	'You have requested to <strong>refresh the global templates</strong>. This action will:' => 'Vous avez demande a <strong>rafraichir les gabarits generaux</strong>. Cette action va :',
	'make backups of your templates that can be accessed through your backup filter' => 'faire des copies de sauvegarde de vos gabarits qui pourront etre accessibles via votre filtre de sauvegarde',
	'potentially install new templates' => 'peut-etre installer de nouveaux gabarits',
	'overwrite some existing templates with new template code' => 'remplacer le code de certains gabarits par un nouveau code',
	'You have requested to <strong>apply a new template set</strong>. This action will:' => 'Vous avez demande d\'<strong>appliquer un nouveau groupe de gabarit</strong>. Cette action va :',
	'You have requested to <strong>reset to the default global templates</strong>. This action will:' => 'Vous avez demande a <strong>retablir les gabarits generaux par defaut</strong>. Cette action va :',
	'delete all of the templates in your blog' => 'supprimer tous les gabarits de votre blog',
	'install new templates from the selected template set' => 'installer de nouveaux gabarits depuis le groupe de gabarits selectionne',
	'delete all of your global templates' => 'supprimer tous vos gabarits generaux',
	'install new templates from the default global templates' => 'installer de nouveaux gabarits issus des gabarits generaux par defaut',
	'Are you sure you wish to continue?' => 'Etes-vous sur de vouloir continuer ?',

## tmpl/cms/dialog/comment_reply.tmpl
	'Reply to comment' => 'Repondre au commentaire',
	'On [_1], [_2] commented on [_3]' => 'Le [_1], [_2] a commente sur [_3]',
	'Preview of your comment' => 'Previsualisation de votre commentaire',
	'Your reply:' => 'Votre reponse :',
	'Submit reply (s)' => 'Envoyer la reponse (s)',
	'Preview reply (v)' => 'Previsualiser la reponse (v)',
	'Re-edit reply (r)' => 'Re-modifier la reponse (r)',
	'Re-edit' => 'Re-modifier',

## tmpl/cms/dialog/asset_upload.tmpl
	'You need to configure your blog.' => 'Vous devez configurer votre blog.',
	'Your blog has not been published.' => 'Votre blog n\'a pas ete publie.',

## tmpl/cms/dialog/publishing_profile.tmpl
	'Publishing Profile' => 'Profil de publication',
	'Choose the profile that best matches the requirements for this blog.' => 'Choisir le profil qui correspond le mieux aux besoins de ce blog',
	'Static Publishing' => 'Publication statique',
	'Immediately publish all templates statically.' => 'Publier immediatement tous les gabarits de maniere statique.',
	'Background Publishing' => 'Publication en arriere-plan',
	'All templates published statically via Publish Que.' => 'Tous les gabarits sont publies en statique via une publication en mode file d\'attente',
	'High Priority Static Publishing' => 'Publication statique prioritaire',
	'Immediately publish Main Index template, Entry archives, and Page archives statically. Use Publish Queue to publish all other templates statically.' => 'Publier immediatement les gabarits d\'index et d\'archives individuelles de notes et pages en statique. Utiliser une publication en mode file d\'attente pour tout le reste',
	'Dynamic Publishing' => 'Publication dynamique',
	'Publish all templates dynamically.' => 'Publier tous les gabarits en dynamique',
	'Dynamic Archives Only' => 'Archives dynamiques uniquement',
	'Publish all Archive templates dynamically. Immediately publish all other templates statically.' => 'Publier tous les gabarits d\'archives individuelles en dynamique. Publier immediatement tout les autres gabarits en statique.',
	'This new publishing profile will update all of your templates.' => 'Ce nouveau profil de publication mettra a jour tous vos gabarits.',

## tmpl/cms/dialog/restore_upload.tmpl
	'Restore: Multiple Files' => 'Restauration : Plusieurs fichiers',
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => 'L\'annulation de la procedure va creer des objets orphelins.  Etes-vous sur de vouloir annuler l\'operation de restauration ?',
	'Please upload the file [_1]' => 'Merci d\'envoyer le fichier [_1]',

## tmpl/cms/dialog/entry_notify.tmpl
	'Send a Notification' => 'Envoyer une notification',
	'You must specify at least one recipient.' => 'Vos devez definir au moins un destinataire.',
	'Your blog\'s name, this entry\'s title and a link to view it will be sent in the notification.  Additionally, you can add a  message, include an excerpt of the entry and/or send the entire entry.' => 'Le nom de votre blog, le titre de cette note et un lien pour la voir seront envoyes dans la notification. De plus, vous pouvez ajouter un message, inclure un extrait de la note et/ou envoyer la note entiere.',
	'Recipients' => 'Destinataires',
	'Enter email addresses on separate lines, or comma separated.' => 'Saisissez les adresses email sur des lignes separees, ou separees par une virgule.',
	'All addresses from Address Book' => 'Toutes les adresses du carnet d\'adresses',
	'Optional Message' => 'Message optionnel',
	'Optional Content' => 'Contenu optionnel',
	'(Entry Body will be sent without any text formatting applied)' => '(Le corps de la note sera envoye sans mise en forme du texte)',
	'Send notification (s)' => 'Envoyer la notification (s)',
	'Send' => 'Envoyer',

## tmpl/cms/dialog/asset_options.tmpl
	'File Options' => 'Options fichier',
	'Create entry using this uploaded file' => 'Creer une note a l\'aide de ce fichier',
	'Create a new entry using this uploaded file.' => 'Creer une nouvelle note avec ce fichier envoye.',
	'Finish (s)' => 'Terminer (s)',
	'Finish' => 'Terminer',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Confirm Publishing Configuration' => 'Confirmer la confirmation de publication',
	'URL is not valid.' => 'L\'URL n\'est pas valide.',
	'You can not have spaces in the URL.' => 'Vous ne pouvez pas avoir d\'espace dans l\'URL.',
	'You can not have spaces in the path.' => 'Vous ne pouvez pas avoir d\'espace dans le chemin.',
	'Path is not valid.' => 'Le chemin n\'est pas valide.',
	'Site Path' => 'Chemin du site',
	'Archive URL' => 'URL d\'archive',

## tmpl/cms/dialog/asset_options_image.tmpl
	'Display image in entry' => 'Afficher l\'image dans la note',
	'Alignment' => 'Alignement',
	'Left' => 'Gauche',
	'Center' => 'Centrer',
	'Right' => 'Droite',
	'Use thumbnail' => 'Utiliser une vignette',
	'width:' => 'largeur :',
	'pixels' => 'pixels',
	'Link image to full-size version in a popup window.' => 'Creer un lien vers l\'image originale dans une popup',
	'Remember these settings' => 'Se souvenir de ces parametres',

## tmpl/cms/dialog/create_association.tmpl
	'No roles exist in this installation. [_1]Create a role</a>' => 'Aucun role n\'existe dans cette installation. [_1]Creer un role</a>',
	'No groups exist in this installation. [_1]Create a group</a>' => 'Aucun groupe n\'existe dans cette installation. [_1]Creer un groupe</a>',
	'No users exist in this installation. [_1]Create a user</a>' => 'Aucun utilisateur n\'existe dans cette installation. [_1]Creer un utilisateur</a>',
	'No blogs exist in this installation. [_1]Create a blog</a>' => 'Aucun blog n\'existe dans cette installation. [_1]Creer un blog</a>',

## tmpl/cms/dialog/restore_start.tmpl
	'Restoring...' => 'Restauration...',

## tmpl/cms/import_others.tmpl
	'Start title HTML (optional)' => 'HTML de debut de titre (optionnel)',
	'End title HTML (optional)' => 'HTML de fin du titre (optionnel)',
	'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => 'Si le logiciel a partir duquel vous importez n\'a pas de champ Titre, vous pouvez utiliser ce parametre pour identifier un titre dans le corps de votre note.',
	'Default entry status (optional)' => 'Statut des notes par defaut (optionnel)',
	'If the software you are importing from does not specify an entry status in its export file, you can set this as the status to use when importing entries.' => 'Si le logiciel a partir duquel vous importez ne specifie pas un statut pour les notes dans son fichier d\'export, vous pouvez utiliser ce statut-ci lors de l\'importation des notes.',
	'Select an entry status' => 'Selectionner un statut de note',

## tmpl/cms/upgrade.tmpl
	'Time to Upgrade!' => 'Il est temps de mettre a jour !',
	'Upgrade Check' => 'Verification des mises a jour',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'La version Perl installee sur votre serveur ([_1]) es anterieure a la version minimale necessaire ([_2]).',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Meme si Movable Type semble fonctionner normalement, l\'application s\'execute <strong>dans un environnement non teste et non supporte</strong>.  Nous vous recommandons fortement d\'installer une version de Perl superieure ou egale a [_1].',
	'Do you want to proceed with the upgrade anyway?' => 'Voulez-vous quand meme continuer la mise a jour ?',
	'View MT-Check (x)' => 'Voir MT-Check (x)',
	'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Une nouvelle version de Movable Type a ete installee. Nous avons besoin de faire quelques manipulations complementaires pour mettre a jour votre base de donnees.',
	'Information about this upgrade can be found <a href=\'[_1]\' target=\'_blank\'>here</a>.' => 'Des informations a propos de cette mise a jour peuvent etre obtenue <a href=\'[_1]\' target=\'_blank\'>ici</a>.',
	'In addition, the following Movable Type components require upgrading or installation:' => 'De plus, les composants suivants de Movable Type necessitent une mise a jour ou une installation :',
	'The following Movable Type components require upgrading or installation:' => 'Les composants suivants de Movable Type necessitent une mise a jour ou une installation :',
	'Begin Upgrade' => 'Commencer la mise a jour',
	'Congratulations, you have successfully upgraded to Movable Type [_1].' => 'Felicitations, vous avez mis a jour Movable Type a la version [_1].',
	'Your Movable Type installation is already up to date.' => 'Vous disposez de la derniere version de Movable Type.',

## tmpl/cms/preview_entry.tmpl
	'Preview [_1]' => 'Pre-visualiser [_1]',
	'Re-Edit this [_1]' => 'Modifier a nouveau cette [_1]',
	'Re-Edit this [_1] (e)' => 'Modifier a nouveau cette [_1] (e)',
	'Save this [_1]' => 'Enregistrer cette [_1]',
	'Save this [_1] (s)' => 'Enregistrer cette [_1] (s)',
	'Cancel (c)' => 'Annuler (c)',

## tmpl/cms/list_banlist.tmpl
	'IP Banning Settings' => 'Parametres des IP bannies',
	'IP addresses' => 'Adresses IP',
	'Delete selected IP Address (x)' => 'Effacer les adresses IP selectionnees (x)',
	'You have added [_1] to your list of banned IP addresses.' => 'L\'adresse [_1] a ete ajoutee a la liste des adresses IP bannies.',
	'You have successfully deleted the selected IP addresses from the list.' => 'L\'adresse IP selectionnee a ete supprimee de la liste.',
	'Ban IP Address' => 'Bannir l\'adresse IP',
	'Date Banned' => 'Bannie le :',

## tmpl/cms/search_replace.tmpl
	'You must select one or more item to replace.' => 'Vous devez selectionner un ou plusieurs objets a remplacer.',
	'Search Again' => 'Chercher encore',
	'Submit search (s)' => 'Soumettre la recherche (s)',
	'Replace' => 'Remplacer',
	'Replace Checked' => 'Remplacer les objets selectionnes',
	'Case Sensitive' => 'Sensible a la casse',
	'Regex Match' => 'Expression Rationnelle',
	'Limited Fields' => 'Champs limites',
	'Date Range' => 'Periode (date)',
	'Reported as Spam?' => 'Notifie comme spam ?',
	'Search Fields:' => 'Rechercher les champs :',
	'_DATE_FROM' => 'Depuis le',
	'_DATE_TO' => 'jusqu\'au',
	'Successfully replaced [quant,_1,record,records].' => 'Remplacements effectues avec succes dans [quant,_1,enregistrement,enregistrements].',
	'Showing first [_1] results.' => 'Afficher d\'abord [_1] resultats.',
	'Show all matches' => 'Afficher tous les resultats',
	'[quant,_1,result,results] found' => '[quant,_1,resultat trouve,resultats trouves]',

## tmpl/cms/list_ping.tmpl
	'Manage Trackbacks' => 'Gerer les Trackbacks',
	'The selected TrackBack(s) has been approved.' => 'Les trackbacks selectionnes ont ete approuves.',
	'All TrackBacks reported as spam have been removed.' => 'Tous les trackbacks notifies comme spam ont ete supprimes.',
	'The selected TrackBack(s) has been unapproved.' => 'Les trackbacks suivants ont ete desapprouves.',
	'The selected TrackBack(s) has been reported as spam.' => 'Les trackbacks selectionnes ont ete notifies comme spam.',
	'The selected TrackBack(s) has been recovered from spam.' => 'Les trackbacks selectionnes ont ete recuperes du spam.',
	'The selected TrackBack(s) has been deleted from the database.' => 'Le(s) trackback(s) selectionne(s) ont ete supprime(s) de la base de donnees.',
	'No TrackBacks appeared to be spam.' => 'Aucun trackback ne semble etre du spam.',
	'Show only [_1] where' => 'Afficher seulement : [_1] ou',
	'approved' => 'Approuve',
	'unapproved' => 'non-approuve',

## tmpl/cms/preview_strip.tmpl
	'Save this entry' => 'Enregistrer cette note',
	'Re-Edit this entry' => 'Modifier a nouveau cette note',
	'Re-Edit this entry (e)' => 'Modifier a nouveau cette note (e)',
	'Save this page' => 'Enregistrer cette page',
	'Re-Edit this page' => 'Modifier a nouveau cette page',
	'Re-Edit this page (e)' => 'Modifier a nouveau cette page (e)',
	'You are previewing the entry titled &ldquo;[_1]&rdquo;' => 'Vous previsualisez la note suivante : &ldquo;[_1]&rdquo;',
	'You are previewing the page titled &ldquo;[_1]&rdquo;' => 'Vous previsualisez la page suivante : &ldquo;[_1]&rdquo;',

## tmpl/cms/error.tmpl
	'An error occurred' => 'Une erreur s\'est produite',

## tmpl/cms/popup/rebuilt.tmpl
	'Success' => 'Succes',
	'The files for [_1] have been published.' => 'Les fichiers pour [_1] ont ete publies.',
	'Your [_1] archives have been published.' => 'Vos archives [_1]  ont ete publiees.',
	'Your [_1] templates have been published.' => 'Vos gabarites [_1] ont ete publiees.',
	'Publish time: [_1].' => 'Temps de publication : [_1].',
	'View your site.' => 'Voir votre site.',
	'View this page.' => 'Voir cette page.',
	'Publish Again (s)' => 'Publier a nouveau',
	'Publish Again' => 'Publier a nouveau',

## tmpl/cms/popup/pinged_urls.tmpl
	'Successful Trackbacks' => 'Trackbacks reussis',
	'Failed Trackbacks' => 'Trackbacks echoues',
	'To retry, include these TrackBacks in the Outbound TrackBack URLs list for your entry.' => 'Pour re-essayer, incluez ces trackbacks dans la liste des URLs de trackbacks sortants pour cette note.',

## tmpl/cms/popup/rebuild_confirm.tmpl
	'Publish [_1]' => 'Publier [_1]',
	'Publish <em>[_1]</em>' => 'Publier <em>[_1]</em>',
	'_REBUILD_PUBLISH' => 'Publier',
	'All Files' => 'Tous les fichiers',
	'Index Template: [_1]' => 'Gabarit d\'index: [_1]',
	'Only Indexes' => 'Uniquement les Index',
	'Only [_1] Archives' => 'Uniquement les archives [_1]',
	'Publish (s)' => 'Publier',

## tmpl/cms/edit_ping.tmpl
	'Edit Trackback' => 'Editer les  Trackbacks',
	'The TrackBack has been approved.' => 'Le trackback a ete approuve.',
	'List &amp; Edit TrackBacks' => 'Lister &amp; editer les trackbacks',
	'Save changes to this TrackBack (s)' => 'Enregistrer les modifications de ce Trackback (s)',
	'Delete this TrackBack (x)' => 'Supprimer ce Trackback (x)',
	'Update the status of this TrackBack' => 'Modifier le statut de ce trackback',
	'Approved' => 'Approuve',
	'Unapproved' => 'Non-approuve',
	'Reported as Spam' => 'Notifie comme spam',
	'Junk' => 'Indesirable',
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
	'Target Category' => 'Categorie cible',
	'Category no longer exists' => 'La categorie n\'existe plus',
	'View all TrackBacks on this category' => 'Afficher tous les trackbacks des cette categorie',
	'View all TrackBacks created on this day' => 'Voir tous les trackbacks crees ce jour',
	'View all TrackBacks from this IP address' => 'Afficher tous les trackbacks avec cette adresse IP',
	'TrackBack Text' => 'Texte du trackback',
	'Excerpt of the TrackBack entry' => 'Extrait de la note du trackback',

## tmpl/cms/list_role.tmpl
	'Roles: System-wide' => 'Roles : configuration globale',
	'You have successfully deleted the role(s).' => 'Vous avez supprime avec succes le(s) role(s).',
	'roles' => 'roles',
	'_USER_STATUS_CAPTION' => 'Statut',
	'Members' => 'Membres',
	'Role Is Active' => 'Le role est actif',
	'Role Not Being Used' => 'Le role n\'est pas utilise',

## tmpl/cms/preview_template_strip.tmpl
	'You are previewing the template named &ldquo;[_1]&rdquo;' => 'Vous previsualisez le module nomme &ldquo;[_1]&rdquo;',
	'(Publish time: [_1] seconds)' => 'Temps de publication : [_1] secondes',
	'Save this template (s)' => 'Sauvegarder ce gabarit (s)',
	'Save this template' => 'Sauvegarder ce gabarit',
	'Re-Edit this template (e)' => 'Re-editer ce gabarit (e)',
	'Re-Edit this template' => 'Re-editer ce gabarit',

## tmpl/cms/list_folder.tmpl
	'Your folder changes and additions have been made.' => 'Vos modifications du repertoire ont bien ete apportees.',
	'You have successfully deleted the selected folder.' => 'Vous avez supprime avec succes le repertoire selectionne',
	'Delete selected folders (x)' => 'Supprimer les repertoires selectionnes (x)',
	'Create top level folder' => 'Creer un repertoire de premier niveau',
	'Create Folder' => 'Creer un Repertoire',
	'Create Subfolder' => 'Creer un Sous-repertoire',
	'Move Folder' => 'Deplacer un Repertoire',
	'[quant,_1,page,pages]' => '[quant,_1,page,pages]',
	'No folders could be found.' => 'Aucun dossier n\'a pu etre trouve.',

## tmpl/cms/list_comment.tmpl
	'Manage Comments' => 'Gerer les commentaires',
	'The selected comment(s) has been approved.' => 'Les commentaires suivants ont ete approuves.',
	'All comments reported as spam have been removed.' => 'Tous les commentaires notifies comme spam ont ete supprimes.',
	'The selected comment(s) has been unapproved.' => 'Les commentaires selectionnes ont ete approuves.',
	'The selected comment(s) has been reported as spam.' => 'Les commentaires selectionnes ont ete notifies comme spam.',
	'The selected comment(s) has been recovered from spam.' => 'Les commentaires suivants ont ete recuperes du spam.',
	'The selected comment(s) has been deleted from the database.' => 'Les commentaires selectionnes ont ete supprimes de la base de donnees.',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be Banned or Trusted.' => 'Un ou plusieurs commentaires selectionnes ont ete ecrits par un auteur de commentaires non authentifie. Ces auteurs de commentaires ne peuvent pas etre bannis ou valides.',
	'No comments appeared to be spam.' => 'Aucun commentaire ne semble etre du spam.',
	'[_1] on entries created within the last [_2] days' => '[_1] sur les notes creees dans les [_2] derniers jours',
	'[_1] on entries created more than [_2] days ago' => '[_1] sur les notes creees il y a plus de [_2] jours',

## tmpl/cms/cfg_web_services.tmpl
	'Web Services Settings' => 'Parametres des services Web',
	'Six Apart Services' => 'Services Six Apart',
	'Your TypePad token is used to access Six Apart services like its free Authentication service.' => 'Votre jeton TypePad est utilise pour acceder aux services Six Apart comme leur service gratuit d\'authentification.',
	'TypePad is enabled.' => 'TypePad est active.',
	'TypePad token:' => 'Jeton TypePad :',
	'Clear TypePad Token' => 'Effacer le jeton TypePad',
	'Please click the Save Changes button below to disable authentication.' => 'Cliquez sur le bouton Enregistrer ci-dessous pour DESACTIVER l\'authentification.',
	'TypePad is not enabled.' => 'TypePad est desactive.',
	'or' => 'ou',
	'Obtain TypePad token' => 'Obtenir un jeton TypePad',
	'Please click the Save Changes button below to enable TypePad.' => 'Veuillez cliquer sur le bouton Sauvegarder les modifications pour activer TypePad.',
	'External Notifications' => 'Notifications externes',
	'Notify of blog updates' => 'Pinguer les sites :',
	'When this blog is updated, Movable Type will automatically notify the selected sites.' => 'Quand ce blog est mis a jour, Movable Type notifiera automatiquement les sites suivants.',
	'Note: This option is currently ignored since outbound notification pings are disabled system-wide.' => 'Remarque : cette option est actuellement ignoree car les pings de notification sortants sont desactives pour tout le systeme.',
	'Others:' => 'Autres :',
	'(Separate URLs with a carriage return.)' => '(Separer les URLs avec un retour chariot.)',
	'Recently Updated Key' => 'Cle recemment mise a jour',
	'If you have received a recently updated key (by virtue of your purchase), enter it here.' => 'Si vous avez recu une mise a jour de la clef, saisissez-la ici.',

## tmpl/cms/edit_blog.tmpl
	'Your blog configuration has been saved.' => 'La configuration de votre blog a ete sauvegardee.',
	'You must set your Local Site Path.' => 'Vous devez configurer le chemin local de votre site.',
	'You must set your Site URL.' => 'Vous devez configurer l\'URL de votre site.',
	'Your Site URL is not valid.' => 'L\'adresse URL de votre site n\'est pas valide.',
	'You can not have spaces in your Site URL.' => 'Vous ne pouvez pas avoir d\'espaces dans l\'adresse URL de votre site.',
	'You can not have spaces in your Local Site Path.' => 'Vous ne pouvez pas avoir d\'espaces dans le chemin local de votre site.',
	'Your Local Site Path is not valid.' => 'Le chemin local de votre site n\'est pas valide.',
	'Blog Details' => 'Details du Blog',
	'Enter the URL of your public website. Do not include a filename (i.e. exclude index.html). Example: http://www.example.com/weblog/' => 'Saisir l\'URL de votre site web public. N\'incluez pas un nom de fichier (comme index.html). Exemple : http://www.exemple.com/blog/',
	'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/weblog' => 'Saisissez le chemin ou votre fichier d\'index principal sera situe. Un chemin absolu (qui commence par \'/\') est prefere, mais vous pouvez aussi utiliser un chemin relatif au repertoire Movable Type. Exemple : /home/melody/public_html/blog',
	'Language' => 'Langue',
	'Blog language.' => 'Langue du blog.',
	'Create Blog (s)' => 'Creer le Blog (s)',

## tmpl/cms/list_template.tmpl
	'Blog Templates' => 'Gabarits du blog',
	'Show All Templates' => 'Afficher tous les gabarits',
	'Blog Publishing Settings' => 'Parametres de publication du blog',
	'You have successfully deleted the checked template(s).' => 'Les gabarits selectionnes ont ete supprimes.',
	'Your templates have been published.' => 'Vos gabarits ont bien ete publies.',
	'Selected template(s) has been copied.' => 'Le(s) gabarit(s) selectionne(s) a (ont) ete copie(s).',

## tmpl/cms/list_tag.tmpl
	'Your tag changes and additions have been made.' => 'Votre changement de tag et les complements ont ete faits.',
	'You have successfully deleted the selected tags.' => 'Vous avez efface correctement les tags selectionnes.',
	'tag' => 'tag',
	'tags' => 'tags',
	'Specify new name of the tag.' => 'Specifier le nouveau nom du tag',
	'Tag Name' => 'Nom du tag',
	'Click to edit tag name' => 'Cliquez pour modifier le nom du tag',
	'Rename [_1]' => 'Renommer',
	'Rename' => 'Changer le nom',
	'Show all [_1] with this tag' => 'Montrer toutes les [_1] avec ce tag',
	'[quant,_1,_2,_3]' => '[quant,_1,_2,_3]',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all blogs?' => 'Le tag \'[_2]\' existe deja. Etes-vous sur de vouloir fusionner \'[_1]\' et \'[_2]\' sur tous les blogs ?',
	'An error occurred while testing for the new tag name.' => 'Une erreur est survenue en testant la nouvelle balise.',

## tmpl/cms/install.tmpl
	'Create Your Account' => 'Creez votre compte',
	'The initial account name is required.' => 'Le nom initial du compte est necessaire.',
	'The display name is required.' => 'Le nom d\'affichage est requis.',
	'Password recovery word/phrase is required.' => 'La phrase de recuperation de mot de passe est requise.',
	'Do you want to proceed with the installation anyway?' => 'Souhaitez-vous tout de meme poursuivre l\'installation ?',
	'Before you can begin blogging, you must create an administrator account for your system. When you are done, Movable Type will then initialize your database.' => 'Avant de pouvoir commencer a bloguer, vous devez creer un compte administrateur pour votre systeme. Une fois cela fait, Movable Type initialisera ensuite votre base de donnees.',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Pour poursuivre, vous devez vous authentifier correctement aupres de votre serveur LDAP.',
	'The name used by this user to login.' => 'Le nom utilise par cet utilisateur pour s\'enregistrer.',
	'The name used when published.' => 'Le nom utilise lors de la publication.',
	'The user&rsquo;s email address.' => 'Adresse email de l\'utilisateur',
	'The email address used in the From: header of each email sent from the system.' => 'L\'adresse e-mail utilisee dans l\'en-tete Expediteur de chaque e-mail envoye',
	'Use this as system email address' => 'Utiliser ceci comme adresse e-mail du systeme',
	'The user&rsquo;s preferred language.' => 'Langue preferee de l\'utilisateur.',
	'Select a password for your account.' => 'Selectionnez un Mot de Passe pour votre compte.',
	'Password Confirm' => 'Mot de passe (confirmation)',
	'Repeat the password for confirmation.' => 'Repetez votre mot de passe pour confirmer.',
	'Your LDAP username.' => 'Votre nom d\'utilisateur LDAP.',
	'Enter your LDAP password.' => 'Saisissez votre mot de passe LDAP.',

## tmpl/cms/edit_comment.tmpl
	'The comment has been approved.' => 'Ce commentaire a ete approuve.',
	'Save changes to this comment (s)' => 'Enregistrer les modifications de ce commentaire (s)',
	'Delete this comment (x)' => 'Supprimer ce commentaire (x)',
	'Previous Comment' => 'Commentaire precedent',
	'Next Comment' => 'Commentaire suivant',
	'View entry comment was left on' => 'Voir la note sur laquelle ce commentaire a ete depose',
	'Reply to this comment' => 'Repondre a ce commentaire',
	'Update the status of this comment' => 'Mettre a jour le statut de ce commentaire',
	'View all comments with this status' => 'Voir tous les commentaires avec ce statut',
	'The name of the person who posted the comment' => 'Le nom de la personne qui a poste le commentaire',
	'(Trusted)' => '(Fiable)',
	'Ban Commenter' => 'Bannir l\'auteur de commentaires',
	'Untrust Commenter' => 'Considerer l\'auteur de commentaires comme pas sur',
	'(Banned)' => '(Banni)',
	'Trust Commenter' => 'Considerer l\'auteur de commentaires comme sur',
	'Unban Commenter' => 'Lever le bannissement de l\'auteur de commentaires',
	'View all comments by this commenter' => 'Afficher tous les commentaires de cet auteur de commentaires',
	'Email address of commenter' => 'Adresse email de l\'auteur de commentaires',
	'None given' => 'Non fourni',
	'URL of commenter' => 'URL de l\'auteur de commentaires',
	'View all comments with this URL' => 'Afficher tous les commentaires associes a cette URL',
	'[_1] this comment was made on' => '[_1] ce commentaire a ete poste',
	'[_1] no longer exists' => '[_1] n\'existe plus',
	'View all comments on this [_1]' => 'Voir tous les commentaires sur cette [_1]',
	'Date this comment was made' => 'Date du commentaire',
	'View all comments created on this day' => 'Voir tous les commentaires crees ce jour',
	'IP Address of the commenter' => 'Adresse IP de l\'auteur de commentaires',
	'View all comments from this IP address' => 'Afficher tous les commentaires associes a cette adresse IP',
	'Fulltext of the comment entry' => 'Texte complet de ce commentaire',
	'Responses to this comment' => 'Reponses a ce commentaire',

## tmpl/cms/cfg_system_feedback.tmpl
	'System: Feedback Settings' => 'Parametres des feedbacks',
	'Your feedback preferences have been saved.' => 'Vos preferences feedback sont enregistrees.',
	'Feedback: Master Switch' => 'Feedback: parametres globaux (agit sur tous les blogs)',
	'This will override all individual blog settings.' => 'Cela va ecraser les parametres de tous les blogs individuels',
	'Disable comments for all blogs' => 'Desactiver les commentaires sur tous les blogs',
	'Disable TrackBacks for all blogs' => 'Desactiver les trackbacks sur tous les blogs',
	'Outbound Notifications' => 'Notifications sortantes',
	'Notification pings' => 'Pings de notification',
	'This feature allows you to disable sending notification pings when a new entry is created.' => 'Cette fonctionnalite vous permet de desactiver l\'envoi de pings de notification quand une nouvelle note est creee.',
	'Disable notification pings for all blogs' => 'Desactiver les pings de notification pour tous les blogs',
	'Limit outbound TrackBacks and TrackBack auto-discovery for the purposes of keeping your installation private.' => 'Limitez les trackbacks sortants et les trackbacks d\'autorecherche afin de conserver le caractere prive de votre installation. ',
	'Allow to any site' => 'Autoriser sur tous les sites',
	'(No outbound TrackBacks)' => '(Pas de trackbacks sortants)',
	'Only allow to blogs on this installation' => 'Autoriser uniquement vers les blogs de cette installation.',
	'Only allow the sites on the following domains:' => 'Autoriser uniquement sur les domaines suivants:',

## tmpl/cms/list_association.tmpl
	'permission' => 'Autorisation',
	'permissions' => 'Autorisations',
	'Remove selected permissions (x)' => 'Retirer les autorisations selectionnees (x)',
	'Revoke Permission' => 'Retirer l\'autorisation',
	'[_1] <em>[_2]</em> is currently disabled.' => '[_1] <em>[_2]</em> est actuellement desactive.',
	'Grant Permission' => 'Ajouter une autorisation',
	'You can not create permissions for disabled users.' => 'Vous ne pouvez pas creer d\'autorisations pour les utilisateurs desactives',
	'Assign Role to User' => 'Ajouter le role a l\'utilisateur',
	'Grant permission to a user' => 'Ajouter une autorisation a un utilisateur',
	'You have successfully revoked the given permission(s).' => 'Vous avez revoque avec succes les autorisations selectionnees.',
	'You have successfully granted the given permission(s).' => 'Vous avez attribue avec succes les autorisations selectionnees.',
	'No permissions could be found.' => 'Aucune autorisation n\'a pu etre trouvee.',

## tmpl/cms/edit_author.tmpl
	'Edit Profile' => 'Editer le Profil',
	'This profile has been updated.' => 'Ce profil a ete mis a jour.',
	'A new password has been generated and sent to the email address [_1].' => 'Un nouveau mot de passe a ete cree et envoye a l\'adresse [_1].',
	'Your Web services password is currently' => 'Votre mot de passe est actuellement',
	'_WARNING_PASSWORD_RESET_SINGLE' => '_WARNING_PASSWORD_RESET_SINGLE',
	'Error occurred while removing userpic.' => 'Une erreur est survenue lors du retrait de l\'avatar.',
	'Status of user in the system. Disabling a user removes their access to the system but preserves their content and history.' => 'Statut de l\'utilisateur dans le systeme. En desactivant un utilisateur, vous supprimez son acces au systeme mais ne detruisez pas ses contenus et son historique ',
	'_USER_PENDING' => 'Utilisateur en attente',
	'The username used to login.' => 'L\'identifiant utilise pour s\'identifier.',
	'External user ID' => 'ID utilisateur externe',
	'The email address associated with this user.' => 'L\'adresse email associee avec cet utilisateur.',
	'The URL of the site associated with this user. eg. http://www.movabletype.com/' => 'L\'URL du site associe a cet utilisateur. Exemple: http://www.movabletype.com/',
	'Userpic' => 'Image de l\'utilisateur',
	'The image associated with this user.' => 'L\'image associee a cet utilisateur.',
	'Select Userpic' => 'Selectionner l\'image de l\'utilisateur',
	'Remove Userpic' => 'Supprimer l\'image de l\'utilisateur',
	'Current Password' => 'Mot de passe actuel',
	'Existing password required to create a new password.' => 'Mot de passe actuel necessaire pour creer un nouveau mot de passe.',
	'Initial Password' => 'Mot de passe *',
	'Enter preferred password.' => 'Saisissez le mot de passe prefere.',
	'New Password' => 'Nouveau mot de passe',
	'Enter the new password.' => 'Saisissez le nouveau mot de passe.',
	'Password recovery word/phrase' => 'Indice de recuperation du mot de passe',
	'This word or phrase is not used in the password recovery.' => 'Ce mot ou cette phrase n\'est pas utilise dans la recuperation du mot de passe.', # Translate - New
	'Preferred language of this user.' => 'Langue preferee de cet utilisateur.',
	'Text Format' => 'Format du texte',
	'Preferred text format option.' => 'Option de format de texte prefere.',
	'(Use Blog Default)' => '(Utiliser la valeur par defaut du blog)',
	'Tag Delimiter' => 'Delimiteur de tags',
	'Preferred method of separating tags.' => 'Methode preferee pour separer les tags.',
	'Web Services Password' => 'Mot de passe Services Web',
	'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'Pour utilisation par les flux d\'activite et avec les clients XML-RPC ou ATOM.',
	'Reveal' => 'Reveler',
	'System Permissions' => 'Autorisations systeme',
	'Options' => 'Options',
	'Create personal blog for user' => 'Creer le blog personnel de l\'utilisateur',
	'Create User (s)' => 'Creer l\'Utilisateur (s)',
	'Save changes to this author (s)' => 'Enregistrer les modifications de cet auteur (s)',
	'_USAGE_PASSWORD_RESET' => 'Ci-dessous, vous pouvez re-initialiser le mot de passe pour cet utilisateur. Si vous faites cela un mot de passe genere aleatoirement sera cree et envoye par e-mail a : [_1].',
	'Initiate Password Recovery' => 'Recuperer le mot de passe',

## tmpl/cms/widget/new_user.tmpl
	'Welcome to Movable Type, the world\'s most powerful blogging, publishing and social media platform. To help you get started we have provided you with links to some of the more common tasks new users like to perform:' => 'Bienvenue dans Movable Type, la plateforme de blogs, de publication et de media social la plus puissante au monde. Afin de vous aider a demarrer avec Movable Type, nous vous proposons quelques liens vers les taches les plus courantes que les nouveaux utilisateurs souhaitent realiser :',
	'Write your first post' => 'Ecrivez votre premiere note',
	'What would a blog be without content? Start your Movable Type experience by creating your very first post.' => 'Que serait un blog sans contenu ? Debutez votre experience Movable Type en creant votre toute premiere note.',
	'Design your blog' => 'Choisissez l\'habillage de votre blog',
	'Customize the look and feel of your blog quickly by selecting a design from one of our professionally designed themes.' => 'Personnalisez votre blog en selectionnant un habillage cree par des professionnels.',
	'Explore what\'s new in Movable Type 4' => 'Decouvrez ce qui est nouveau dans Movable Type 4',
	'Whether you\'re new to Movable Type or using it for the first time, learn more about what this tool can do for you.' => 'Que vous decouvriez Movable Type ou que vous l\'utilisiez pour la premiere fois, decouvrez ce que cet outil peut faire pour vous.',

## tmpl/cms/widget/blog_stats_recent_entries.tmpl
	'[quant,_1,entry,entries] tagged &ldquo;[_2]&rdquo;' => '[quant,_1,note,notes] avec le tag &ldquo;[_2]&rdquo;',
	'...' => '...',
	'Posted by [_1] [_2] in [_3]' => 'Postee par [_1] [_2] dans [_3]',
	'Posted by [_1] [_2]' => 'Postee par [_1] [_2]',
	'Tagged: [_1]' => 'avec le tag : [_1]',
	'View all entries tagged &ldquo;[_1]&rdquo;' => 'Voir toutes les notes avec le tag &ldquo;[_1]&rdquo;',
	'No entries available.' => 'Aucune note disponible.',

## tmpl/cms/widget/mt_news.tmpl
	'News' => 'Actualite',
	'MT News' => 'Actualite Movable Type',
	'Learning MT' => 'Apprendre Movable Type',
	'Hacking MT' => 'Coder pour Movable Type',
	'Pronet' => 'Pronet',
	'No Movable Type news available.' => 'Aucune actualite Movable Type n\'est disponible.',
	'No Learning Movable Type news available.' => 'Pas d\'actualite Apprendre Movable Type disponible.',

## tmpl/cms/widget/custom_message.tmpl
	'This is you' => 'C\'est vous',
	'Welcome to [_1].' => 'Bienvenue sur [_1].',
	'You can manage your blog by selecting an option from the menu located to the left of this message.' => 'Vous pouvez gerer votre blog en selectionnant une option dans le menu situe a gauche de ce message.',
	'If you need assistance, try:' => 'Si vous avez besoin d\'aide, vous pouvez consulter :',
	'Movable Type User Manual' => 'Mode d\'emploi de Movable Type',
	'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.com/movabletype/support',
	'Movable Type Technical Support' => 'Support Technique Movable Type',
	'Movable Type Community Forums' => 'Forums de la communaute Movable Type ',
	'Save Changes (s)' => 'Sauvegarder les modifications',
	'Change this message.' => 'Changer ce message.',
	'Edit this message.' => 'Modifier ce message.',

## tmpl/cms/widget/mt_shortcuts.tmpl
	'Import Content' => 'Importer du contenu',
	'Blog Preferences' => 'Preferences du blog',

## tmpl/cms/widget/new_version.tmpl
	'What\'s new in Movable Type [_1]' => 'Quoi de neuf dans Movable Type [_1]',
	'Congratulations, you have successfully installed Movable Type [_1]. Listed below is an overview of the new features found in this release.' => 'Felicitations, vous avez installe Movable Type [_1] avec succes. Voici, entre autres, une vue d\'ensemble des nouveautes apportees par cette nouvelle version.',

## tmpl/cms/widget/this_is_you.tmpl
	'Your <a href="[_1]">last entry</a> was [_2] in <a href="[_3]">[_4]</a>.' => 'Votre <a href="[_1]">derniere note</a> a ete [_2] dans <a href="[_3]">[_4]</a>.',
	'You have <a href="[_1]">[quant,_2,draft,drafts]</a>.' => 'Vous avez <a href="[_1]">[quant,_2,brouillon,brouillons]</a>.',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a> with <a href="[_3]">[quant,_4,comment,comments]</a>.' => 'Vous avez ecrit <a href="[_1]">[quant,_2,note,notes]</a> avec <a href="[_3]">[quant,_4,commentaire,commentaires]</a>.',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>.' => 'Vous avez ecrit <a href="[_1]">[quant,_2,note,notes]</a>.',
	'Edit your profile' => 'Modifier votre profil',

## tmpl/cms/widget/new_install.tmpl
	'Thank you for installing Movable Type' => 'Merci d\'avoir installe Movable Type',
	'Congratulations on installing Movable Type, the world\'s most powerful blogging, publishing and social media platform. To help you get started we have provided you with links to some of the more common tasks new users like to perform:' => 'Felicitations, vous avez installe avec succes Movable Type, la plateforme de blogs, de publication et de media social la plus puissante au monde. Afin de vous aider a demarrer avec Movable Type, nous vous proposons quelques liens vers les taches les plus courantes que les nouveaux utilisateurs souhaitent realiser :',
	'Add more users to your blog' => 'Ajouter plus d\'utilisateurs a votre blog',
	'Start building your network of blogs and your community now. Invite users to join your blog and promote them to authors.' => 'Commencez a creer votre reseau de blogs et votre communaute des maintenant. Invitez des utilisateurs a joindre votre blog et donnez-leur le statut d\'auteurs.',

## tmpl/cms/widget/blog_stats.tmpl
	'Error retrieving recent entries.' => 'Erreur en recuperant les notes recentes.',
	'Loading recent entries...' => 'Chargement des notes recentes...',
	'Jan.' => 'Jan.',
	'Feb.' => 'Fev.',
	'July.' => 'Juil.',
	'Aug.' => 'Aout',
	'Sept.' => 'Sept.',
	'Oct.' => 'Oct.',
	'Nov.' => 'Nov.',
	'Dec.' => 'Dec.',
	'Movable Type was unable to locate your \'mt-static\' directory. Please configure the \'StaticFilePath\' configuration setting in your mt-config.cgi file, and create a writable \'support\' directory underneath your \'mt-static\' directory.' => 'Movable Type n\'a pas pu localiser votre repertoire \'mt-static\'. Merci de configurer la variable de configuration \'StaticFilePath\' dans votre fichier mt-config.cgi, et creez un repertoire \'support\' accessible en ecriture dans le repertoire \'mt-static\'.',
	'Movable Type was unable to write to its \'support\' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.' => 'Movable Type n\'a pas pu ecrire dans son repertoire \'support\'. Merci de creer un repertoire a cet endroit : [_1], et de lui ajouter des droits qui permettent au serveur web d\'ecrire dedans.',
	'[_1] [_2] - [_3] [_4]' => '[_1] [_2] - [_3] [_4]',
	'You have <a href=\'[_3]\'>[quant,_1,comment,comments] from [_2]</a>' => 'Vous avez <a href=\'[_3]\'>[quant,_1,commentaire,commentaires] de [_2]</a>',
	'You have <a href=\'[_3]\'>[quant,_1,entry,entries] from [_2]</a>' => 'Vous avez <a href=\'[_3]\'>[quant,_1,note,notes] de [_2]</a>',

## tmpl/cms/widget/blog_stats_entry.tmpl
	'Most Recent Entries' => 'Notes recentes',
	'View all entries' => 'Voir toutes les notes',

## tmpl/cms/widget/blog_stats_tag_cloud.tmpl

## tmpl/cms/widget/blog_stats_comment.tmpl
	'Most Recent Comments' => 'Commentaires recents',
	'[_1] [_2], [_3] on [_4]' => '[_1] [_2], [_3] sur [_4]',
	'View all comments' => 'Voir tous les commentaires',
	'No comments available.' => 'Aucune commentaire disponible.',

## tmpl/cms/restore_end.tmpl
	'Make sure that you remove the files that you restored from the \'import\' folder, so that if/when you run the restore process again, those files will not be re-restored.' => 'Assurez-vous d\'avoir supprime les fichiers que vous avez restaures dans le repertoire \'import\', ainsi, si vous restaurez a nouveau d\'autres fichiers plus tard, les fichiers actuels ne seront pas restaures une seconde fois.',
	'An error occurred during the restore process: [_1] Please check activity log for more details.' => 'Une erreur s\'est produite pendant la procedure de restauration : [_1] Merci de vous reporter au journal (logs) pour plus de details.',

## tmpl/cms/system_check.tmpl
	'User Counts' => 'Statistiques utilisateurs',
	'Number of users in this system.' => 'Nombre d\'utilisateurs enregistres',
	'Total Users' => 'Utilisateurs au total',
	'Active Users' => 'Utilisateurs actifs',
	'Users who have logged in within 90 days are considered <strong>active</strong> in Movable Type license agreement.' => 'Les utilisateurs qui se sont connectes dans les 90 derniers jours sont consideres comme <strong>actifs</strong> dans les accords de licence Movable Type',
	'Movable Type could not find the script named \'mt-check.cgi\'. To resolve this issue, please ensure that the mt-check.cgi script exists and/or the CheckScript configuration parameter references it properly.' => 'Movable Type n\'a pu trouver le script nomme \'mt-check.cgi\'. Pour resoudre ce probleme, assurez-vous que le script mt-check.cgi script existe et/ou que la configuration des parametres de MTCheckScript le reference convenablement.',

## tmpl/cms/restore.tmpl
	'Restore from a Backup' => 'Restaurer a partir d\'une sauvegarde',
	'Perl module XML::SAX and/or its dependencies are missing - Movable Type can not restore the system without it.' => 'Le module Perl XML::SAX et/ou ses dependances sont manquantes - Movable Type ne peut restaurer le systeme sans lui.',
	'Backup file' => 'Fichier de sauvegarde',
	'If your backup file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the \'import\' folder of your Movable Type directory.' => 'Si votre fichier de sauvegarde est situe sur votre ordinateur, vous pouvez l\'envoyer ici.  Autrement, Movable Type cherchera automatiquement dans le repertoire \'import\' de votre repertoire Movable Type.',
	'Check this and files backed up from newer versions can be restored to this system.  NOTE: Ignoring Schema Version can damage Movable Type permanently.' => 'Cochez ceci et les fichiers sauvegardes a partir d\'une version plus recente pourront etre restaures dans ce systeme. NOTE : Ignorer la version du schema peut endommager Movable Type de maniere permanente.',
	'Ignore schema version conflicts' => 'Ignorer les conflits de version de schema',
	'Check this and existing global templates will be overwritten from the backup file.' => 'Cochez ceci et les gabarits globaux existants seront ecrases par ceux de la sauvegarde.',
	'Overwrite global templates.' => 'Ecraser les gabarits globaux.',
	'Restore (r)' => 'Restaurer (r)',

## tmpl/cms/login.tmpl
	'Your Movable Type session has ended.' => 'Votre session Movable Type a ete fermee.',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Votre session Movable Type est terminee. Si vous souhaitez vous identifier a nouveau, vous pouvez le faire ci-dessous.',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Votre session Movable Type est terminee. Merci de vous identifier a nouveau pour continuer cette action.',
	'Forgot your password?' => 'Vous avez oublie votre mot de passe ?',
	'Sign In (s)' => 'Connexion (s)',

## tmpl/cms/cfg_archives.tmpl
	'Error: Movable Type was not able to create a directory for publishing your blog. If you create this directory yourself, assign sufficient permissions that allow Movable Type to create files within it.' => 'Erreur : Movable Type n\'a pas ete capable de creer un repertoire pour publier votre blog. Si vous creez ce repertoire vous-meme, assignez-lui des autorisations suffisantes pour que Movable Type puisse creer des fichiers dedans.',
	'Your blog\'s archive configuration has been saved.' => 'La configuration des archives de votre blog a ete sauvegardee.',
	'You have successfully added a new archive-template association.' => 'L\'association gabarit/archive a reussi.',
	'You may need to update your \'Master Archive Index\' template to account for your new archive configuration.' => 'Vous aurez peut-etre besoin de mettre a jour votre gabarit \'Index principal des archives\' pour activer la nouvelle configuration de vos archives.',
	'The selected archive-template associations have been deleted.' => 'Les associations gabarit/archive selectionnees ont ete supprimees.',
	'Warning: one or more of your templates is set to publish dynamically using PHP, however your server side include method may not be compatible with dynamic publishing.' => 'Attention : au moins un de vos gabarits est marque pour publication dynamique via PHP, cependant votre methode d\'inclusion cote serveur peut ne pas etre compatible avec une publication dynamique.',
	'You must set a valid Site URL.' => 'Vous devez specifier une URL valide.',
	'You must set a valid Local Site Path.' => 'Vous devez specifier un chemin local d\'acces valide.',
	'You must set Local Archive Path.' => 'Vous devez renseigner Local Archive Path.',
	'You must set a valid Archive URL.' => 'Vous devez renseigner une Archive URL valide.',
	'You must set a valid Local Archive Path.' => 'Vous devez renseigner un Local Archive Path valide.',
	'Publishing Paths' => 'Chemins de publication',
	'The URL of your website. Do not include a filename (i.e. exclude index.html). Example: http://www.example.com/blog/' => 'L\'URL de votre site web. Ne mettez pas un nom de fichier (par exemple excluez index.html). Exemple : http://www.exemple.com/blog/',
	'Unlock this blog&rsquo;s site URL for editing' => 'Deverrouillez l\'URL du site de ce blog pour le modifier',
	'Warning: Changing the site URL can result in breaking all the links in your blog.' => 'Attention : Modifier l\'URL du site peut rompre tous les liens de votre blog.',
	'The path where your index files will be published. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/blog' => 'Il s\'agit du chemin ou vos fichiers d\'index seront publies. Un chemin absolu (commencant par \'/\') est preferable, mais vous pouvez utiliser un chemin relatif au repertoire de Movable Type. Exemple : /home/melody/public_html/blog',
	'Unlock this blog&rsquo;s site path for editing' => 'Deverrouiller le chemin du site de ce blog pour le modifier',
	'Note: Changing your site root requires a complete publish of your site.' => 'Remarque : La modification de la racine de votre site necessite une publication complete de votre site.',
	'Advanced Archive Publishing' => 'Publication avancee des archives',
	'Select this option only if you need to publish your archives outside of your Site Root.' => 'Selectionnez cette option si vous avez besoin de publier vos archives en dehors de la racine du Site.',
	'Publish archives outside of Site Root' => 'Publier les archives en dehors de la racine du site',
	'Enter the URL of the archives section of your website. Example: http://archives.example.com/' => 'Saisissez l\'URL de la section des archives de votre site web. Exemple: http://archives.exemple.com/',
	'Unlock this blog&rsquo;s archive url for editing' => 'Deverrouillez l\'url de l\'archive du blog pour la modifier',
	'Warning: Changing the archive URL can result in breaking all the links in your blog.' => 'Attention : Si vous modifiez l\'URL d\'archive vous pouvez casser tous les liens dans votre blog.',
	'Enter the path where your archive files will be published. Example: /home/melody/public_html/archives' => 'Saisissez le chemin ou vos fichiers archives seront publies. Exemple : /home/melody/public_html/archives',
	'Warning: Changing the archive path can result in breaking all the links in your blog.' => 'Attention : Changer le chemin d\'archive peut casser tous les liens de votre blog.',
	'Asynchronous Job Queue' => 'File d\'attente asynchrone',
	'Use Publishing Queue' => 'Utiliser la publication en mode File d\'attente',
	'Requires the use of a cron job to publish pages in the background.' => 'Requiert l\'utilisation d\'un cron job pour publier en tache de fond.',
	'Use background publishing queue for publishing static pages for this blog' => 'Utiliser la publication en mode File d\'attente pour publier les pages statiques de ce blog',
	'Dynamic Publishing Options' => 'Options de publication dynamique',
	'Enable dynamic cache' => 'Activer le cache dynamique',
	'Enable conditional retrieval' => 'Activer la recuperation conditionnelle',
	'Archive Options' => 'Options d\'archive',
	'File Extension' => 'Extension de fichier',
	'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'Entrez l\'extension du fichier d\'archive. Elle peut etre au choix \'html\', \'shtml\', \'php\', etc. NB: Ne pas indiquer la periode (\'.\').',
	'Preferred Archive' => 'Archive preferee',
	'Used for creating links to an archived entry (permalink). Select from the archive types used in this blogs archive templates.' => 'Utilise pour creer des liens vers une note archivee (lien permanent). Selectionner parmi les types d\'archives utilises dans les gabarits d\'archives du blog.',
	'No archives are active' => 'Aucune archive n\'est active',
	'Module Options' => 'Options de module',
	'Enable template module caching' => 'Activer le cache des modules de gabarit',
	'Server Side Includes' => 'Service Side Includes',
	'None (disabled)' => 'Aucun (desactive)',
	'PHP Includes' => 'Inclusions PHP',
	'Apache Server-Side Includes' => 'Inclusions Apache Server-Side',
	'Active Server Page Includes' => 'Inclusions Active Server Page',
	'Java Server Page Includes' => 'Inclusions Java Server Page',

## tmpl/cms/rebuilding.tmpl
	'Publishing...' => 'Publication...',
	'Publishing [_1]...' => 'Publication [_1]...',
	'Publishing [_1] [_2]...' => 'Publication [_1] [_2]...',
	'Publishing [_1] dynamic links...' => 'Publication des liens dynamiques [_1]...',
	'Publishing [_1] archives...' => 'Publication des archives [_1]...',
	'Publishing [_1] templates...' => 'Publication des gabarits [_1]...',

## tmpl/cms/edit_asset.tmpl
	'Edit Asset' => 'Editer les Elements',
	'Your asset changes have been made.' => 'Vos modifications de l\'element ont bien ete apportees.',
	'[_1] - Modified by [_2]' => '[_1] - modifie par [_2]',
	'Appears in...' => 'Apparait dans...',
	'Published on [_1]' => 'Publie sur [_1]',
	'Show all entries' => 'Afficher toutes les notes',
	'Show all pages' => 'Afficher toutes les pages',
	'This asset has not been used.' => 'Cet element n\'est pas utilise.',
	'Related Assets' => 'Elements lies',
	'You must specify a label for the asset.' => 'Vous devez specifier un titre pour l\'element.',
	'Embed Asset' => 'Element embarque',
	'Save changes to this asset (s)' => 'Enregistrer les modifications de cet element (s)',

## tmpl/comment/register.tmpl
	'Create an account' => 'Creer un compte',
	'Your email address.' => 'Votre adresse email.',
	'Your login name.' => 'Votre nom d\'utilisateur.',
	'The name appears on your comment.' => 'Le nom apparait dans votre commentaire.',
	'Select a password for yourself.' => 'Selectionnez un mot de passe pour vous.',
	'The URL of your website. (Optional)' => 'URL de votre site internet (en option)',
	'Register' => 'S\'enregistrer',

## tmpl/comment/signup.tmpl

## tmpl/comment/login.tmpl
	'Sign in to comment' => 'Identifiez-vous pour commenter',
	'Sign in using' => 'S\'identifier en utilisant',
	'Remember me?' => 'Memoriser les informations de connexion ?',
	'Not a member?&nbsp;&nbsp;<a href="[_1]">Sign Up</a>!' => 'Pas encore membre?&nbsp;&nbsp;<a href="[_1]">Enregistrez-vous</a>!',

## tmpl/comment/error.tmpl
	'Go Back (s)' => 'Retour (s)',

## tmpl/comment/signup_thanks.tmpl
	'Thanks for signing up' => 'Merci de vous etre enregistre(e)',
	'Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].' => 'Avant de pouvoir deposer un commentaire vous devez terminer la prodecure d\'enregistrement en confirmant votre compte.  Un email a ete envoye a l\'adresse suivante : [_1].',
	'To complete the registration process you must first confirm your account. An email has been sent to [_1].' => 'Pour terminer la procedure d\'enregistrement vous devez confirmer votre compte. Un email a ete envoye a [_1].',
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'Pour confirmer et activer votre compte merci de verifier votre boite email et de cliquer sur le lien que nous venons de vous envoyer.',
	'Return to the original entry.' => 'Retour a la note originale.',
	'Return to the original page.' => 'Retour a la page originale.',

## tmpl/comment/profile.tmpl
	'Your Profile' => 'Votre profil',
	'Return to the <a href="[_1]">original page</a>.' => 'Retourner sur la <a href="[_1]">page originale</a>.',

## tmpl/include/chromeless_footer.tmpl
	'<a href="[_1]">Movable Type</a> version [_2]' => '<a href="[_1]">Movable Type</a> version [_2]',

## tmpl/error.tmpl
	'Missing Configuration File' => 'Fichier de configuration manquant',
	'_ERROR_CONFIG_FILE' => 'Votre fichier configuration Movable type est absent ou ne peut pas etre lu correctement. Merci de consulter la base de connaissances',
	'Database Connection Error' => 'Erreur de connexion a la base de donnees',
	'_ERROR_DATABASE_CONNECTION' => 'Les parametres de votre base de donnees sont soit invalides, absents ou ne peuvent pas etre lus correctement. Consultez la base de connaissances pour plus d\'informations.',
	'CGI Path Configuration Required' => 'Configuration de chemin CGI requise',
	'_ERROR_CGI_PATH' => 'Votre configuration de chemin CGI est invalide ou absente de vos fichiers de configuration Movable Type. Merci de consulter la base de connaissance',

## tmpl/feeds/feed_entry.tmpl
	'Unpublish' => 'De-publier',
	'More like this' => 'Plus du meme genre',
	'From this blog' => 'De ce blog',
	'From this author' => 'De cet auteur',
	'On this day' => 'Pendant cette journee',

## tmpl/feeds/feed_comment.tmpl
	'On this entry' => 'Sur cette note',
	'By commenter identity' => 'Par identite de l\'auteur de commentaires',
	'By commenter name' => 'Par nom de l\'auteur de commentaires',
	'By commenter email' => 'Par l\'e-mail de l\'auteur de commentaires',
	'By commenter URL' => 'Par URL de l\'auteur de commentaires',

## tmpl/feeds/login.tmpl
	'Movable Type Activity Log' => 'Journal (logs) de Movable Type',
	'This link is invalid. Please resubscribe to your activity feed.' => 'Ce lien n\'est pas valide. Merci de souscrire a nouveau a votre flux d\'activite.',

## tmpl/feeds/error.tmpl

## tmpl/feeds/feed_page.tmpl

## tmpl/feeds/feed_ping.tmpl
	'Source blog' => 'Blog source',
	'By source blog' => 'Par le blog source',
	'By source title' => 'Par le titre de la source',
	'By source URL' => 'Par l\'URL de la source',

## addons/Community.pack/config.yaml
	'Community Settings' => 'Reglages de la communaute',
	'Pending Entries' => 'Notes en attente', # Translate - New
	'Spam Entries' => 'Notes indesirables', # Translate - New
	'Following Users' => 'Utilisateurs suiveurs',
	'Being Followed' => 'Etre suivi',
	'Sanitize' => 'Nettoyer',
	'Recently Scored' => 'Note recemment',
	'Recent Submissions' => 'Soumissions recentes',
	'Most Popular Entries' => 'Notes les plus populaires',
	'Registrations' => 'Inscriptions',
	'Login Form' => 'Formulaire d\'identification',
	'Password Reset Form' => 'Formulaire de reinitialisation du mot de passe',
	'Registration Form' => 'Formulaire d\'enregistrement',
	'Registration Confirmation' => 'Confirmation d\'enregistrement',
	'Profile Error' => 'Erreur de profil',
	'Profile View' => 'Vue du profil',
	'Profile Edit Form' => 'Formulaire de modification du profil',
	'Profile Feed' => 'Flux du profil',
	'New Password Form' => 'Nouveau formulaire de mot de passe', # Translate - New
	'New Password Reset Form' => 'Nouveau formulaire de reinitialisation du mot de passe', # Translate - New
	'Form Field' => 'Champ de formulaire',
	'Status Message' => 'Message de statut',
	'Simple Header' => 'Tete de page simple',
	'Simple Footer' => 'Pied de page simple',
	'Navigation' => 'Navigation',
	'Header' => 'Entete',
	'Footer' => 'Pied',
	'GlobalJavaScript' => 'GlobalJavaScript',
	'Email verification' => 'Verification email',
	'Registration notification' => 'Notification enregistrement',
	'New entry notification' => 'Notification de nouvelle note',
	'Community Blog' => 'Blog de la communaute',
	'Atom ' => 'Atom',
	'Entry Response' => 'Reponse a la note',
	'Displays error, pending or confirmation message when submitting an entry.' => 'Afficher les erreurs et les messages de confirmation quand une note est ecrite.',
	'Comment Detail' => 'Detail du Commentaire',
	'Entry Detail' => 'Details de la note',
	'Entry Metadata' => 'Metadonnees de la note',
	'Page Detail' => 'Details de la page',
	'Entry Form' => 'Formulaire de note',
	'Content Navigation' => 'Navigation du contenu',
	'Activity Widgets' => 'Widgets d\'activite',
	'Archive Widgets' => 'Widgets d\'archive',
	'Community Forum' => 'Forum de la communaute',
	'Entry Feed' => 'Flux de la note',
	'Displays error, pending or confirmation message when submitting a entry.' => 'Affiche les messages d\'erreur, de validation et de confirmation quand une nouvelle note est creee.',
	'Popular Entry' => 'Note populaire',
	'Entry Table' => 'Tableau de note',
	'Content Header' => 'Entete du contenu',
	'Category Groups' => 'Groupes de categorie',
	'Default Widgets' => 'Widgets par defaut',

## addons/Community.pack/lib/MT/App/Community.pm
	'No login form template defined' => 'Aucun formulaire d\'identification de defini',
	'Before you can sign in, you must authenticate your email address. <a href="[_1]">Click here</a> to resend the verification email.' => 'Avant de pouvoir vous identifier, vous devez confirmer votre adresse email. <a href="[_1]">Cliquez ici</a> pour envoyer a nouveau l\'email de verification.',
	'Your confirmation have expired. Please register again.' => 'Votre confirmation a expire. Merci de vous inscrire a nouveau.',
	'User \'[_1]\' (ID:[_2]) has been successfully registered.' => 'L\'utilisateur \'[_1]\' (ID:[_2]) a ete enregistre avec succes.',
	'Thanks for the confirmation.  Please sign in.' => 'Merci pour la confirmation. Identifiez-vous.',
	'[_1] registered to Movable Type.' => '[_1] s\'est enregistre(e) a Movable Type.', # Translate - New
	'Login required' => 'Authentification obligatoire',
	'Title or Content is required.' => 'Le titre ou le contenu est requis.',
	'System template entry_response not found in blog: [_1]' => 'Gabarit systeme entry_response introuvable dans le blog: [_1]',
	'New entry \'[_1]\' added to the blog \'[_2]\'' => 'Nouvelle note \'[_1]\' ajoutee sur le blog \'[_2]\'',
	'Id or Username is required' => 'Id ou identifiant obligatoire',
	'Unknown user' => 'Utilisateur inconnu',
	'Recent Entries from [_1]' => 'Notes recentes de [_1]',
	'Responses to Comments from [_1]' => 'Reponses aux commentaires de [_1]',
	'Actions from [_1]' => 'Actions de [_1]',

## addons/Community.pack/lib/MT/Community/Tags.pm
	'You used an \'[_1]\' tag outside of the block of MTIfEntryRecommended; perhaps you mistakenly placed it outside of an \'MTIfEntryRecommended\' container?' => 'Vous avez utilise un tag \'[_1]\' en dehors d\'un bloc de MTIfEntryRecommended; Peut-etre l\'avez-vous place par erreur en dehors d\'un conteneur \'MTIfEntryRecommended\' ?',
	'Click here to recommend' => 'Cliquer ici pour recommander',
	'Click here to follow' => 'Cliquer ici pour suivre',
	'Click here to leave' => 'Cliquer ici pour quitter',

## addons/Community.pack/lib/MT/Community/CMS.pm
	'Users followed by [_1]' => 'Utilisateurs suivis par [_1]',
	'Users following [_1]' => 'Utilisateurs qui suivent [_1]',
	'Following' => 'Suit',
	'Followers' => 'Suiveurs',
	'Welcome to the Movable Type Community Solution' => 'Bienvenue dans Movable Type Community Solution',
	'The Community Solution gives you to the tools to build a successful community with active, engaged conversations. Some key features to explore:' => 'Le Community Solution vous offre les outils pour construire avec succes une communaute active avec des conversations engagees. Certaines fonctionnalites principales a explorer:',
	'Friends and Followers' => 'Amis et Suiveurs',
	'Allow registered members to maintain a list of friends across your community' => 'Permettez aux membres enregistres de maintenir une liste d\'amis dans votre communaute',

## addons/Community.pack/php/function.mtentryrecommendvotelink.php

## addons/Community.pack/tmpl/widget/blog_stats_registration.mtml
	'Recent Registrations' => 'Inscriptions recentes',
	'default userpic' => 'Image de l\'utilisateur par defaut',
	'You have [quant,_1,registration,registrations] from [_2]' => 'Vous avez [quant,_1,creation de compte,creations de compte] sur [_2]',

## addons/Community.pack/tmpl/widget/most_popular_entries.mtml
	'There are no popular entries.' => 'Il n\'y a pas de notes populaires.',

## addons/Community.pack/tmpl/widget/recent_submissions.mtml

## addons/Community.pack/tmpl/widget/recently_scored.mtml
	'There are no recently favorited entries.' => 'Il n\'y a pas de notes favorites recentes.',

## addons/Community.pack/tmpl/cfg_community_prefs.tmpl
	'Anonymous Recommendation' => 'Recommandation anonyme',
	'Check to allow anonymous users (users not logged in) to recommend discussion.  IP address is recorded and used to identify each user.' => 'Cocher pour autoriser les utilisateurs anonymes (non identifies) a recommander une discussion. L\'adresse IP est enregistree et utilisee pour identifier chaque utilisateur.',
	'Allow anonymous user to recommend' => 'Autoriser un utilisateur anonyme a recommander',
	'Save changes to blog (s)' => 'Sauvegarder les modifications du blog (s)',

## addons/Community.pack/templates/global/register_form.mtml
	'Sign up' => 'Enregistrez-vous',

## addons/Community.pack/templates/global/simple_footer.mtml

## addons/Community.pack/templates/global/profile_error.mtml
	'ERROR MSG HERE' => 'MSG ERREUR ICI',

## addons/Community.pack/templates/global/new_password.mtml

## addons/Community.pack/templates/global/new_entry_email.mtml
	'A new entry \'[_1]([_2])\' has been posted on your blog [_3].' => 'Une nouvelle note \'[_1]([_2])\' a ete postee sur votre blog [_3].',
	'Author name: [_1]' => 'Nom de l\'auteur: [_1]',
	'Author nickname: [_1]' => 'Surnom de l\'auteur: [_1]',
	'Title: [_1]' => 'Titre: [_1]',
	'Edit entry:' => 'Modifier la note:',

## addons/Community.pack/templates/global/profile_feed.mtml
	'Posted [_1] to [_2]' => 'A poste [_1] sur [_2]',
	'Commented on [_1] in [_2]' => 'A commente sur [_1] dans [_2]',
	'Voted on [_1] in [_2]' => 'A vote sur [_1] dans [_2]',
	'[_1] voted on <a href="[_2]">[_3]</a> in [_4]' => '[_1] a vote sur <a href="[_2]">[_3]</a> dans [_4]',

## addons/Community.pack/templates/global/password_reset_form.mtml
	'Reset Password' => 'Initialiser le mot de passe',
	'Your password has been changed, and the new password has been sent to your email address ([_1]).' => 'Votre mot de passe a ete modifie et a ete envoye a votre adresse e-mail([_1]).',
	'Back to the original page' => 'Retour a la page initiale',

## addons/Community.pack/templates/global/signin.mtml
	'You are signed in as <a href="[_1]">[_2]</a>' => 'Vous etes identifie(e) comme etant <a href="[_1]">[_2]</a>',
	'You are signed in as [_1]' => 'Vous etes identifie(e) comme etant [_1]',
	'Edit profile' => 'Editer le profil',
	'Sign out' => 'deconnexion',
	'Not a member? <a href="[_1]">Register</a>' => 'Pas encore membre? <a href="[_1]">Enregistrez-vous</a>',

## addons/Community.pack/templates/global/profile_edit_form.mtml
	'Go <a href="[_1]">back to the previous page</a> or <a href="[_2]">view your profile</a>.' => 'Retourner a  <a href="[_1]">la page precedente</a> ou <a href="[_2]">voir votre profil</a>.',
	'Upload New Userpic' => 'Charger une nouvelle photo utilisateur',

## addons/Community.pack/templates/global/header.mtml
	'Blog Description' => 'Description du blog',

## addons/Community.pack/templates/global/profile_view.mtml
	'User Profile' => 'Profil de l\'utilisateur',
	'Recent Actions from [_1]' => 'Actions recentes de [_1]',
	'You are following [_1].' => 'Vous suivez [_1]',
	'Unfollow' => 'Ne plus suivre',
	'Follow' => 'Suivre',
	'You are followed by [_1].' => 'Vous etes suivi par [_1].',
	'You are not followed by [_1].' => 'Vous n\'etes pas suivi par [_1].',
	'Website:' => 'Site Web:',
	'Recent Actions' => 'Actions recentes',
	'Comment Threads' => 'Fils de discussion',
	'Commented on [_1]' => 'A commente sur [_1]',
	'Favorited [_1] on [_2]' => 'A mis comme favori [_1] dans [_2]',
	'No recent actions.' => 'Plus d\'actions recentes.',
	'[_1] commented on ' => '[_1] a commente sur',
	'No responses to comments.' => 'Pas de reponse aux commentaires.',
	'Not following anyone' => 'Ne suit personne',
	'Not being followed' => 'N\'est pas suivi',

## addons/Community.pack/templates/global/login_form.mtml

## addons/Community.pack/templates/global/register_confirmation.mtml
	'Authentication Email Sent' => 'Email d\'authentification envoye',
	'Profile Created' => 'Profil cree',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Retourner a la page initiale</a>',

## addons/Community.pack/templates/global/footer.mtml

## addons/Community.pack/templates/global/navigation.mtml
	'Home' => 'Accueil',

## addons/Community.pack/templates/global/new_password_reset_form.mtml

## addons/Community.pack/templates/global/login_form_module.mtml
	'Logged in as <a href="[_1]">[_2]</a>' => 'Identifie comme <a href="[_1]">[_2]</a>',
	'Hello [_1]' => 'Bonjour [_1]',
	'Forgot Password' => 'Mot de passe oublie?',

## addons/Community.pack/templates/global/email_verification_email.mtml
	'Thank you registering for an account to [_1].' => 'Merci de creer un compte sur [_1].',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to sign in to [_1].' => 'Pour votre propre securite et pour prevenir la fraude, nous vous demandons de confirmer votre compte et adresse email avant de continuer. Une fois confirmes vous serez immediatement autorise a vous identifier sur [_1].',
	'If you did not make this request, or you don\'t want to register for an account to [_1], then no further action is required.' => 'Si vous n\'avez pas fait cette demande, ou que vous ne souhaitez pas creer un compte sur [_1], alors aucune action n\'est necessaire.',

## addons/Community.pack/templates/global/register_notification_email.mtml

## addons/Community.pack/templates/global/search.mtml

## addons/Community.pack/templates/global/javascript.mtml
	'Vote' => 'Vote',
	'Votes' => 'Votes',

## addons/Community.pack/templates/blog/category_archive_list.mtml

## addons/Community.pack/templates/blog/main_index.mtml

## addons/Community.pack/templates/blog/page.mtml

## addons/Community.pack/templates/blog/main_index_widgets_group.mtml

## addons/Community.pack/templates/blog/entry_summary.mtml

## addons/Community.pack/templates/blog/content_nav.mtml
	'Blog Home' => 'Accueil du blog',

## addons/Community.pack/templates/blog/entry_response.mtml
	'Thank you for posting an entry.' => 'Merci d\'avoir poste votre message.',
	'Entry Pending' => 'Message en attente',
	'Your entry has been received and held for approval by the blog owner.' => 'Votre message a ete recu et est en attente d\'approbation par le proprietaire du blog.',
	'Entry Posted' => 'Message poste',
	'Your entry has been posted.' => 'Votre message a bien ete poste.',
	'Your entry has been received.' => 'Votre message a ete recu.',
	'Return to the <a href="[_1]">blog\'s main index</a>.' => 'Retour a la <a href="[_1]">page principale du blog</a>.',

## addons/Community.pack/templates/blog/comment_response.mtml

## addons/Community.pack/templates/blog/archive_widgets_group.mtml

## addons/Community.pack/templates/blog/entry_detail.mtml

## addons/Community.pack/templates/blog/entry_form.mtml
	'In order to create an entry on this blog you must first register.' => 'Avant de creer une note sur ce blog, vous devez vous enregistrer.',
	'You don\'t have permission to post.' => 'Vous n\'avez pas la permission de poster.',
	'Sign in to create an entry.' => 'Identifiez-vous pour creer une note.',
	'Select Category...' => 'Selectionner la categorie...',

## addons/Community.pack/templates/blog/comment_detail.mtml

## addons/Community.pack/templates/blog/entry_create.mtml

## addons/Community.pack/templates/blog/syndication.mtml

## addons/Community.pack/templates/blog/current_category_monthly_archive_list.mtml

## addons/Community.pack/templates/blog/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] a commente sur [_3]</a> : [_4]',

## addons/Community.pack/templates/blog/comment_form.mtml

## addons/Community.pack/templates/blog/monthly_archive_list.mtml

## addons/Community.pack/templates/blog/pages_list.mtml

## addons/Community.pack/templates/blog/entry_listing.mtml
	'Recently by <em>[_1]</em>' => 'Recemment par <em>[_1]</em>',

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

## addons/Community.pack/templates/blog/search_results.mtml

## addons/Community.pack/templates/blog/dynamic_error.mtml

## addons/Community.pack/templates/blog/powered_by.mtml

## addons/Community.pack/templates/blog/tag_cloud.mtml

## addons/Community.pack/templates/blog/recent_assets.mtml

## addons/Community.pack/templates/blog/comment_preview.mtml
	'Comment on [_1]' => 'Commentaire sur [_1]',

## addons/Community.pack/templates/blog/search.mtml

## addons/Community.pack/templates/forum/main_index.mtml
	'Forum Home' => 'Accueil du forum',

## addons/Community.pack/templates/forum/page.mtml

## addons/Community.pack/templates/forum/entry_summary.mtml

## addons/Community.pack/templates/forum/content_nav.mtml
	'Start Topic' => 'Debuter un sujet',

## addons/Community.pack/templates/forum/entry_response.mtml
	'Thank you for posting a new topic to the forums.' => 'Merci d\'avoir cree un nouveau sujet dans le forum.',
	'Topic Pending' => 'Sujet en attente',
	'The topic you posted has been received and held for approval by the forum administrators.' => 'Le sujet que vous avez cree a bien ete recu et il est en attente de validation par les administrateurs du forum.',
	'Topic Posted' => 'Sujet poste',
	'The topic you posted has been received and published. Thank you for your submission.' => 'Le sujet que vous avez cree a bien ete recu et publie. Merci.',
	'Return to the <a href="[_1]">forum\'s homepage</a>.' => 'Retour a la <a href="[_1]">page d\'accueil du forum</a>.',

## addons/Community.pack/templates/forum/comment_response.mtml
	'Reply Submitted' => 'Reponse envoyee',
	'Your reply has been accepted.' => 'Votre reponse a ete acceptee.',
	'Thank you for replying.' => 'Merci pour votre reponse.',
	'Your reply has been received and held for approval by the forum administrator.' => 'Votre reponse a bien ete recue et est en attente d\'approbation par un administrateur du forum.',
	'Reply Submission Error' => 'Erreur lors de l\'envoi de la reponse',
	'Your reply submission failed for the following reasons: [_1]' => 'L\'envoi de la reponse a echoue pour les raisons suivantes : [_1]',
	'Return to the <a href="[_1]">original topic</a>.' => 'Retour au <a href="[_1]">sujet d\'origine</a>.',

## addons/Community.pack/templates/forum/content_header.mtml

## addons/Community.pack/templates/forum/entry_detail.mtml

## addons/Community.pack/templates/forum/comment_detail.mtml
	'[_1] replied to <a href="[_2]">[_3]</a>' => '[_1] a repondu a <a href="[_2]">[_3]</a>',

## addons/Community.pack/templates/forum/entry_create.mtml
	'Start a Topic' => 'Creer un nouveau sujet',

## addons/Community.pack/templates/forum/entry_form.mtml
	'Topic' => 'Sujet',
	'Select Forum...' => 'Selectionner un forum...',
	'Forum' => 'Forum',

## addons/Community.pack/templates/forum/syndication.mtml
	'All Forums' => 'Tous les forums',
	'[_1] Forum' => 'Forum [_1]',

## addons/Community.pack/templates/forum/comment_form.mtml
	'Add a Reply' => 'Ajouter une Reponse',

## addons/Community.pack/templates/forum/entry_listing.mtml

## addons/Community.pack/templates/forum/entry_metadata.mtml
	'1 Reply' => '1 Reponse',
	'# Replies' => '# Reponses',

## addons/Community.pack/templates/forum/entry.mtml

## addons/Community.pack/templates/forum/javascript.mtml
	'Thanks for signing in,' => 'Merci de vous etre identifie,',
	'. Now you can reply to this topic.' => '. Maintenant vous pouvez repondre a ce sujet.',
	'You do not have permission to comment on this blog.' => 'Vous n\'avez pas la permission de commenter sur ce blog.',
	' to reply to this topic.' => ' pour repondre a ce sujet.',
	' to reply to this topic,' => ' pour repondre a ce sujet,',
	'or ' => 'ou ',
	'reply anonymously.' => 'repondre anonymement.',

## addons/Community.pack/templates/forum/entry_table.mtml
	'Recent Topics' => 'Sujets recents',
	'Replies' => 'Reponses',
	'Last Reply' => 'Derniere reponse',
	'Permalink to this Reply' => 'Lien permanent vers cette reponse',
	'By [_1]' => 'Par [_1]',
	'Closed' => 'Ferme',
	'Post the first topic in this forum.' => 'Creez le premier sujet de ce forum.',

## addons/Community.pack/templates/forum/archive_index.mtml

## addons/Community.pack/templates/forum/sidebar.mtml

## addons/Community.pack/templates/forum/category_groups.mtml
	'Forum Groups' => 'Groupes de forums',
	'Last Topic: [_1] by [_2] on [_3]' => 'Dernier sujet: [_1] par [_2] sur [_3]',
	'Be the first to <a href="[_1]">post a topic in this forum</a>' => 'Soyez le premier a <a href="[_1]">creer un sujet dans ce forum</a>',

## addons/Community.pack/templates/forum/openid.mtml

## addons/Community.pack/templates/forum/comments.mtml
	'No Replies' => 'Pas de Reponses',

## addons/Community.pack/templates/forum/search_results.mtml
	'Topics matching &ldquo;[_1]&rdquo;' => 'Sujets correspondants a &ldquo;[_1]&rdquo;',
	'Topics tagged &ldquo;[_1]&rdquo;' => 'Sujets taggues &ldquo;[_1]&rdquo;',
	'Topics' => 'Sujets',

## addons/Community.pack/templates/forum/dynamic_error.mtml

## addons/Community.pack/templates/forum/entry_popular.mtml
	'Popular topics' => 'Sujets populaires',

## addons/Community.pack/templates/forum/comment_preview.mtml
	'Reply to [_1]' => 'Repondre a [_1]',
	'Previewing your Reply' => 'Previsualiser votre reponse',

## addons/Commercial.pack/config.yaml
	'Photo' => 'Photo',
	'Embed' => 'Embarque',
	'Custom Fields' => 'Champs personnalises',
	'Updating Universal Template Set to Professional Website set...' => 'Mise a jour du jeu de gabarits universel vers sites web professionnels...',
	'Professional Website' => 'Sites web professionnels',
	'Themes that are compatible with the Professional Website template set.' => 'Themes compatibles avec le jeu de gabarits Sites web professionnels',
	'Blog Index' => 'Index du Blog',
	'Blog Entry Listing' => 'Liste des Notes du Blog',
	'Header' => 'Entete',
	'Footer' => 'Pied',
	'Navigation' => 'Navigation',
	'Comment Detail' => 'Detail du Commentaire',
	'Entry Detail' => 'Details de la note',
	'Entry Metadata' => 'Metadonnees de la note',
	'Page Detail' => 'Details de la page',
	'Powered By (Footer)' => 'Powered By (Pied de Page)',
	'Recent Entries Expanded' => 'Entrees etendues recentes',
	'Footer Links' => 'Liens de Pied de Page',
	'Blog Activity' => 'Activite du blog',
	'Blog Archives' => 'Archives du blog',
	'Main Sidebar' => 'Colonne laterale principale',

## addons/Commercial.pack/lib/MT/Commercial/Util.pm
	'Could not install custom field [_1]: field attribute [_2] is required' => 'Impossible d\'installer le champs personnalise [_1] : l\'attribut [_2] du champ est requis.',
	'Could not install custom field [_1] on blog [_2]: the blog already has a field [_1] with a conflicting type' => 'Impossible d\'installer le champs personnalise [_1] sur le blog [_2] : le blog a deja un champ [_1] avec un type en conflit.',
	'Blog [_1] using template set [_2]' => 'Le blog [_1] utilisant le jeu de gabarits [_2]',
	'About' => 'A propos de',
	'_PTS_REPLACE_THIS' => '<p><strong>Remplacez ce texte d\'exemple par vos propres informations.</strong></p>',
	'_PTS_SAMPLE_ABOUT' => '
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In nec tellus sed turpis varius sagittis. Nullam pulvinar. Fusce dapibus neque pellentesque nulla. Maecenas condimentum quam. Vestibulum pretium fringilla quam. Nam elementum. Suspendisse odio magna, aliquam vitae, vulputate et, dignissim at, pede. Integer pellentesque orci at nibh. Morbi ante.</p>

<p>Maecenas convallis mattis justo. Ut mauris sapien, consequat a, bibendum vitae, sagittis ac, nisi. Nulla et sapien. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Ut condimentum turpis ut elit. Quisque ultricies sollicitudin justo. Duis vitae magna nec risus pulvinar ultricies.</p>
',
	'_PTS_EDIT_LINK' => '
<!-- retirer ce lien apres l\'edition -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl + \'?__mode=view&_type=page&id=\' + page_id + \'&blog_id=\' + blog_id; return false">Editer ce contenu</a>
</p>
',
	'Could not create page: [_1]' => 'Impossible de creer la page : [_1]',
	'Created page \'[_1]\'' => 'Page \'[_1]\' cree',
	'_PTS_CONTACT' => 'Contacter',
	'_PTS_SAMPLE_CONTACT' => '
<p>Nous adorerions avoir de vos nouvelles. Envoyez un email a email (at) nomdedomaine.com</p>
',
	'Welcome to our new website!' => 'Bienvenue sur notre nouveau site !',
	'_PTS_SAMPLE_WELCOME' => '
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In nec tellus sed turpis varius sagittis. Nullam pulvinar. Fusce dapibus neque pellentesque nulla. Maecenas condimentum quam. Aliquam erat volutpat. Ut placerat porta nibh. Donec vitae nulla. Pellentesque nisi leo, pretium a, gravida quis, sollicitudin non, eros. Vestibulum pretium fringilla quam. Nam elementum. Suspendisse odio magna, aliquam vitae, vulputate et, dignissim at, pede. Integer pellentesque orci at nibh. Morbi ante.</p>

<p>Maecenas convallis mattis justo. Ut mauris sapien, consequat a, bibendum vitae, sagittis ac, nisi. Nulla et sapien. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Ut condimentum turpis ut elit. Quisque ultricies sollicitudin justo. Duis vitae magna nec risus pulvinar ultricies. Aliquam sagittis volutpat metus.</p>

<p>Sed enim. Integer hendrerit, arcu ac pretium nonummy, velit turpis faucibus risus, pulvinar egestas enim elit sed ante. Curabitur orci diam, placerat a, faucibus id, condimentum vitae, magna. Etiam enim massa, convallis quis, rutrum vitae, porta quis, turpis.</p>
',
	'New design launched using Movable Type' => 'Nouveau design lance en utilisant Movable Type',
	'_PTS_SAMPLE_NEWDESIGN' => '
<p>Notre nouveau site internet est habille d\'un nouvel habillage grace a <a href="http://www.movabletype.com/">Movable Type</a> et les Groupes d\'Habillages Universels. Les Groupes d\'Habillages Universels rendent facile et accessible a n\'importe qui la mise en place et l\'animation d\'un site internet utilisant Movable Type. Et cela ne vous prendra que quelques instants#160;! Selectionnez-en un simplement pour votre nouveau site web et publiez. Voila#160;! Merci Movable Type#160;!</p> 
',
	'Could not create entry: [_1]' => 'Impossible de creer la note : [_1]',
	'John Doe' => 'John Doe',
	'Great new site. I can\'t wait to try Movable Type. Congrats!' => 'Super nouveau site. Je suis impatient d\'essayer Movable Type. Felicitations !',
	'Created entry and comment \'[_1]\'' => 'La note et les commentaires \'[_1]\' ont ete crees',

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Show' => 'Afficher',
	'Date & Time' => 'Date & heure',
	'Date Only' => 'Date seulement',
	'Time Only' => 'Heure seulement',
	'Please enter all allowable options for this field as a comma delimited list' => 'Merci de saisir toutes les options autorisees pour ce champ dans une liste delimitee par des virgules',
	'[_1] Fields' => '[_1] champs',
	'Edit Field' => 'Modifier le champ',
	'Invalid date \'[_1]\'; dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Date invalide \'[_1]\'; les dates doivent etre dans le format YYYY-MM-DD HH:MM:SS.',
	'Invalid date \'[_1]\'; dates should be real dates.' => 'Date invalide \'[_1]\'; les dates doivent etre de vraies dates.',
	'Please enter valid URL for the URL field: [_1]' => 'Merci de saisir une URL correcte pour le champ URL : [_1]',
	'Please enter some value for required \'[_1]\' field.' => 'Merci de saisir une valeur pour le champ obligatoire \'[_1]\'.',
	'Please ensure all required fields have been filled in.' => 'Merci de verifier que tous les champs obligatoires ont ete remplis.',
	'The template tag \'[_1]\' is an invalid tag name.' => 'Le tag de gabarit \'[_1]\' est un nom de tag invalide',
	'The template tag \'[_1]\' is already in use.' => 'Le tag de gabarit \'[_1]\' est deja utilise.',
	'The basename \'[_1]\' is already in use.' => 'Le nom de base \'[_1]\' est deja utilise.',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'Personnalisez les champs des notes, pages, repertoires, categories et auteurs pour stocker toutes les informations dont vous avez besoin.',
	' ' => ' ',
	'Single-Line Text' => 'Texte sur une ligne',
	'Multi-Line Text' => 'Texte multi-lignes',
	'Checkbox' => 'Case a cocher',
	'Date and Time' => 'Date et heure',
	'Drop Down Menu' => 'Menu deroulant',
	'Radio Buttons' => 'Boutons radio',
	'Embed Object' => 'Element externe',
	'Post Type' => 'Type de note',

## addons/Commercial.pack/lib/CustomFields/Upgrade.pm
	'Moving metadata storage for pages...' => 'Deplacement de l\'emplacement des metadonnees des pages en cours ...',

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Restoring custom fields data stored in MT::PluginData...' => 'Restauration des donnees des champs personnalises stockees dans MT:PluginData...',
	'Restoring asset associations found in custom fields ( [_1] ) ...' => 'Restauration des associations d\'elements trouves dans les champs personnalises ([_1]) ...',
	'Restoring url of the assets associated in custom fields ( [_1] )...' => 'Restauration des URLs des elements associes dans les champs personnalises ([_1]) ...',

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	'Are you sure you have used a \'[_1]\' tag in the correct context? We could not find the [_2]' => 'Etes-vous sur d\'avoir utilise un tag \'[_1]\' dans le contexte approprie ? Impossible de trouver le [_2]',
	'You used an \'[_1]\' tag outside of the context of the correct content; ' => 'Vous avez utilise un tag \'[_1]\' en dehors du contexte du contenu correct; ',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'Field' => 'Champ',

## addons/Commercial.pack/tmpl/date-picker.tmpl
	'Select date' => 'Selectionner la date',

## addons/Commercial.pack/tmpl/edit_field.tmpl
	'New Field' => 'Nouveau champ',
	'The selected fields(s) has been deleted from the database.' => 'Les champs selectionnes ont ete effaces de la base de donnees.',
	'Please ensure all required fields (highlighted) have been filled in.' => 'Merci de verifier que tous les champs obligatoires ont ete remplis.',
	'System Object' => 'Objet systeme',
	'Select the system object this field is for' => 'Selectionner l\'objet systeme auquel ce champ est rattache',
	'Select...' => 'Selectionnez...',
	'Required?' => 'Obligatoire?',
	'Should a value be chosen or entered into this field?' => 'Une valeur doit-elle etre choisie ou saisie dans ce champ?',
	'Default' => 'Defaut',
	'You will need to first save this field in order to set a default value' => 'Vous devez d\'abord enregistrer ce champ pour pouvoir mettre une valeur par defaut',
	'_CF_BASENAME' => 'Nom de base',
	'The basename is used for entering custom field data through a 3rd party client. It must be unique.' => 'Le nom de base est utilise pour entrer les donnees d\'un champs personnalise a travers un logiciel tiers. Il doit etre unique. ',
	'Unlock this for editing' => 'Deverrouiller pour modifier',
	'Warning: Changing this field\'s basename may require changes to existing templates.' => 'Attention : le changement de ce nom de base peut necessiter des changements additionnels dans vos gabarits existants.',
	'Template Tag' => 'Tag du gabarit',
	'Create a custom template tag for this field.' => 'Creer un tag de gabarit personnalise pour ce champ.',
	'Example Template Code' => 'Code de gabarit exemple',
	'Save this field (s)' => 'Enregistrer ce champs (s)',
	'field' => 'champ',
	'fields' => 'Champs',
	'Delete this field (x)' => 'Supprimer ce champs (x)',

## addons/Commercial.pack/tmpl/reorder_fields.tmpl
	'open' => 'ouvrir',
	'click-down and drag to move this field' => 'gardez le clic maintenu et glissez le curseur pour deplacer ce champs',
	'click to %toggle% this box' => 'cliquez pour %toggle% cette boite',
	'use the arrow keys to move this box' => 'utilisez les touches flechees de votre clavier pour deplacer cette boite',
	', or press the enter key to %toggle% it' => ', ou pressez la touche entree pour la %toggle%',

## addons/Commercial.pack/tmpl/list_field.tmpl
	'New [_1] Field' => 'Nouveau champ [_1]',
	'Delete selected fields (x)' => 'Effacer les champs selectionnes (x)',
	'No fields could be found.' => 'Aucun champ n\'a ete trouve.',
	'System-Wide' => 'sur tout le systeme',

## addons/Commercial.pack/tmpl/asset-chooser.tmpl
	'Choose [_1]' => 'Choisir [_1]',
	'Remove [_1]' => 'Supprimer [_1]',

## addons/Commercial.pack/templates/professional/notify-entry.mtml

## addons/Commercial.pack/templates/professional/category_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog_index.mtml

## addons/Commercial.pack/templates/professional/main_index.mtml

## addons/Commercial.pack/templates/professional/page.mtml

## addons/Commercial.pack/templates/professional/entry_summary.mtml

## addons/Commercial.pack/templates/professional/comment_response.mtml

## addons/Commercial.pack/templates/professional/commenter_notify.mtml

## addons/Commercial.pack/templates/professional/recent_entries_expanded.mtml
	'By [_1] | Comments ([_2])' => 'Par [_1] | Commentaires ([_1])',

## addons/Commercial.pack/templates/professional/footer-email.mtml

## addons/Commercial.pack/templates/professional/entry_detail.mtml

## addons/Commercial.pack/templates/professional/verify-subscribe.mtml

## addons/Commercial.pack/templates/professional/new-ping.mtml

## addons/Commercial.pack/templates/professional/comment_detail.mtml

## addons/Commercial.pack/templates/professional/comment_form.mtml

## addons/Commercial.pack/templates/professional/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] a commente sur [_3]</a> : [_4]',

## addons/Commercial.pack/templates/professional/monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/comment_throttle.mtml

## addons/Commercial.pack/templates/professional/signin.mtml

## addons/Commercial.pack/templates/professional/new-comment.mtml

## addons/Commercial.pack/templates/professional/entry_listing.mtml
	'Recently by <em>[_1]</em>' => 'Recemment par <em>[_1]</em>',

## addons/Commercial.pack/templates/professional/footer.mtml

## addons/Commercial.pack/templates/professional/tags.mtml

## addons/Commercial.pack/templates/professional/navigation.mtml
	'Home' => 'Accueil',

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
	'Links' => 'Liens',

## addons/Commercial.pack/templates/professional/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/recent_assets.mtml

## addons/Commercial.pack/templates/professional/comment_preview.mtml

## addons/Commercial.pack/templates/professional/search.mtml

## addons/Commercial.pack/templates/professional/commenter_confirm.mtml

## addons/Enterprise.pack/app-wizard.yaml
	'This module is required in order to use the LDAP Authentication.' => 'Ce module est necessaire pour utiliser l\'identification LDAP.',
	'This module is required in order to use SSL/TLS connection with the LDAP Authentication.' => 'Ce module est necessaire pour utiliser les connections SSL/TLS avec l\'identification LDAP.',

## addons/Enterprise.pack/app-cms.yaml
	'Are you sure you want to delete the selected group(s)?' => 'Etes-vous sur de vouloir effacer les groupes selectionnes?',
	'Group' => 'Groupe',
	'Groups' => 'Groupes',
	'Bulk Author Export' => 'Export auteurs en masse',
	'Bulk Author Import' => 'Importer les auteurs en masse',
	'Synchronize Users' => 'Synchroniser les utilisateurs',
	'Synchronize Groups' => 'Synchroniser les groupes',

## addons/Enterprise.pack/config.yaml
	'Enterprise Pack' => 'Enterprise Pack',
	'Oracle Database' => 'Base de donnees Oracle',
	'Microsoft SQL Server Database' => 'Base de donnees Microsoft SQL Server',
	'Microsoft SQL Server Database (UTF-8 support)' => 'Base de donnees Microsoft SQL Server (support UTF-8)',
	'External Directory Synchronization' => 'Synchronization repertoire externe',
	'Populating author\'s external ID to have lower case user name...' => 'Peuplement de l\'ID externe d\'auteur pour avoir des identifiants en minuscule...',

## addons/Enterprise.pack/lib/MT/Enterprise/Upgrade.pm
	'Fixing binary data for Microsoft SQL Server storage...' => 'Correction des donnees binaires pour le stockage Microsoft SQL Server...',

## addons/Enterprise.pack/lib/MT/Enterprise/Wizard.pm
	'PLAIN' => 'PLAIN',
	'CRAM-MD5' => 'CRAM-MD5',
	'Digest-MD5' => 'Digest-MD5',
	'Login' => 'Identifiant',
	'Found' => 'Trouve',
	'Not Found' => 'Non trouve',

## addons/Enterprise.pack/lib/MT/Enterprise/BulkCreation.pm
	'Format error at line [_1]: [_2]' => 'Erreur de format a la ligne [_1]: [_2]',
	'Invalid command: [_1]' => 'Commande invalide: [_1]',
	'Invalid number of columns for [_1]' => 'Nombre de colonnes invalide pour [_1]',
	'Invalid user name: [_1]' => 'Identifiant invalide: [_1]',
	'Invalid display name: [_1]' => 'Nom d\'affichage invalide: [_1]',
	'Invalid email address: [_1]' => 'Adresse email invalide: [_1]',
	'Invalid language: [_1]' => 'Langue invalide: [_1]',
	'Invalid password: [_1]' => 'Mot de passe invalide: [_1]',
	'Invalid password recovery phrase: [_1]' => 'Phrase de recuperation de mot de passe invalide: [_1]',
	'Invalid weblog name: [_1]' => 'Nom de weblog invalide: [_1]',
	'Invalid weblog description: [_1]' => 'Description de weblog invalide: [_1]',
	'Invalid site url: [_1]' => 'URL du site invalide: [_1]',
	'Invalid site root: [_1]' => 'Racine du site invalide: [_1]',
	'Invalid timezone: [_1]' => 'Fuseau horaire invalide: [_1]',
	'Invalid new user name: [_1]' => 'Nouvel identifiant invalide: [_1]',
	'A user with the same name was found.  Register was not processed: [_1]' => 'Un utilisateur avec le meme nom a ete trouve. L\'enregistrement n\'a pas ete effectue: [_1]',
	'Blog for user \'[_1]\' can not be created.' => 'Le blog pour l\'utilisateur \'[_1]\' ne peut etre cree.',
	'Blog \'[_1]\' for user \'[_2]\' has been created.' => 'Le blog \'[_1]\' pour l\'utilisateur \'[_2]\' a ete cree.',
	'Error assigning weblog administration rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable weblog administrator role was found.' => 'Erreur en tentant d\'assigner les droits d\'administration du blog a l\'utilisateur \'[_1] (ID: [_2])\' pour le weblog \'[_3] (ID: [_4])\'. Aucun role d\'administrateur de weblog adequat n\'a ete trouve.',
	'Permission granted to user \'[_1]\'' => 'Permission accordee a l\'utilisateur \'[_1]\'',
	'User \'[_1]\' already exists. Update was not processed: [_2]' => 'L\'utilisateur \'[_1]\' existe deja. La mise a jour n\'a pas eu lieu: [_2]',
	'User cannot be updated: [_1].' => 'Utilisateur ne peut etre mis a jour: [_1].',
	'User \'[_1]\' not found.  Update was not processed.' => 'L\'utilisateur \'[_1]\' n\'a pas ete trouve. La mise a jour n\'a pas eu lieu.',
	'User \'[_1]\' has been updated.' => 'L\'utilisateur \'[_1]\' a ete mis a jour.',
	'User \'[_1]\' was found, but delete was not processed' => 'L\'utilisateur \'[_1]\' a ete trouve, mais la suppression n\'a pas eu lieu.',
	'User \'[_1]\' not found.  Delete was not processed.' => 'L\'utilisateur \'[_1]\' n\'a pas ete trouve. La suppression n\'a pas eu lieu.',
	'User \'[_1]\' has been deleted.' => 'L\'utilisateur \'[_1]\' a ete supprime.',

## addons/Enterprise.pack/lib/MT/Enterprise/CMS.pm
	'Add [_1] to a blog' => 'Ajouter [_1] a un blog',
	'You can not create associations for disabled groups.' => 'Vous ne pouvez pas creer d\'association pour les groupes desactives.',
	'Assign Role to Group' => 'Ajouter le role au groupe',
	'Add a group to this blog' => 'Ajouter un groupe a ce blog',
	'Grant permission to a group' => 'Ajouter une autorisation a un groupe',
	'Movable Type Enterprise has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.' => 'Movable Type Enterprise vient de tenter de desactiver votre compte pendant la synchronisation avec l\'annuaire externe. Certains des parametres du systeme de gestion externe des utilisateurs doivent etre errones. Merci de corriger avant de poursuivre.',
	'Group requires name' => 'Le groupe necessite un nom.',
	'Invalid group' => 'Groupe invalide.',
	'Add Users to Group [_1]' => 'Ajouter les utilisateurs au groupe [_1]',
	'Users & Groups' => 'Utilisateurs et Groupes',
	'Group Members' => 'Membres du groupe',
	'User Groups' => 'Groupes de l\'utilisateur',
	'Group load failed: [_1]' => 'Chargement du groupe echoue: [_1]',
	'User load failed: [_1]' => 'Chargement de l\'utilisateur echoue: [_1]',
	'User \'[_1]\' (ID:[_2]) removed from group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) supprime du groupe \'[_3]\' (ID:[_4]) par \'[_5]\'',
	'User \'[_1]\' (ID:[_2]) was added to group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) a ete ajoute au groupe \'[_3]\' (ID:[_4]) par \'[_5]\'',
	'Group Profile' => 'Profil du Groupe',
	'Author load failed: [_1]' => 'Chargement de l\'auteur echoue: [_1]',
	'Invalid user' => 'Utilisateur invalide',
	'Assign User [_1] to Groups' => 'Assigner l\'utilisateur [_1] aux groupes.',
	'Select Groups' => 'Selectionner les groupes',
	'Groups Selected' => 'Groupes selectionnes',
	'Type a group name to filter the choices below.' => 'Tapez un nom de groupe pour filtrer les choix ci-dessous.',
	'Group Name' => 'Nom du groupe',
	'Search Groups' => 'Rechercher des groupes',
	'Bulk import cannot be used under external user management.' => 'L\'import en masse ne peut etre utilise avec la gestion externe des utilisateurs.',
	'Bulk management' => 'Gestion en masse',
	'No record found in the file.  Make sure the file uses CRLF as the line ending character.' => 'Aucune entree n\'a ete trouvee dans le fichier. Assurez-vous que le fichier utilise CRLF comme caractere de fin de ligne.',
	'Registered [quant,_1,user,users], updated [quant,_2,user,users], deleted [quant,_3,user,users].' => 'Creation de [quant,_1,utilisateur,utilisateurs], modification de [quant,_2, utilisateur, utilisateurs], suppression de [quant,_3, utilisateur, utilisateurs.',
	'The group' => 'Le groupe',
	'User/Group' => 'Utilisateur/Groupe',
	'A user can\'t change his/her own username in this environment.' => 'Un utilisateur ne peut pas changer son nom d\'utilisateur dans cet environnement',
	'An error occurred when enabling this user.' => 'Une erreur s\'est produite pendant l\'activation de cet utilisateur.',

## addons/Enterprise.pack/lib/MT/Auth/LDAP.pm
	'User [_1]([_2]) not found.' => 'Utilisateur [_1]([_2]) non trouve.',
	'User \'[_1]\' cannot be updated.' => 'Utilisateur \'[_1]\' ne peut etre mis a jour.',
	'User \'[_1]\' updated with LDAP login ID.' => 'Utilisateur \'[_1]\' mis a jour avec l\'ID de login LDAP.',
	'LDAP user [_1] not found.' => 'Utilisateur LDAP [_1] non trouve.',
	'User [_1] cannot be updated.' => 'Utilisateur [_1] ne peut etre mis a jour.',
	'Failed login attempt by user \'[_1]\' deleted from LDAP.' => 'Tentative de login echouee par utilisateur \'[_1]\' supprime de LDAP.',
	'User \'[_1]\' updated with LDAP login name \'[_2]\'.' => 'Utilisateur \'[_1]\' mis a jour avec l\'identifiant LDAP \'[_2]\'.',
	"Failed login attempt by user \'[_1]\'. A user with that\nusername already exists in the system with a different UUID." => "Echec de la connexion pour l\'utilisateur\'[_1]\'. Un utilisateur avec cet
identifiant existe mais avec un UUID different.",
	'User \'[_1]\' account is disabled.' => 'Le compte de l\'utilisateur \'[_1]\' est desactive.',
	'LDAP users synchronization interrupted.' => 'Synchronisation des utilisateurs LDAP interrompue.',
	'Loading MT::LDAP failed: [_1]' => 'Chargement de MT::LDAP echoue: [_1]',
	'External user synchronization failed.' => 'Synchronisation utilisateur externe echouee.',
	'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'Une tentative de desactivation de tous les administrateurs systeme a ete realisee. La synchronisation des utilisateurs a ete interrompue.',
	'The following users\' information were modified:' => 'Les informations suivantes des utilisateurs ont ete modifiees:',
	'The following users were disabled:' => 'Les utilisateurs suivants ont ete desactives:',
	'LDAP users synchronized.' => 'Utilisateurs LDAP synchronises.',
	'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute is set.' => 'La synchronisation des groupes ne peut avoir lieu sans LDAPGroupIdAttribute et/ou LDAPGroupNameAttribute parametre.',
	'LDAP groups synchronized with existing groups.' => 'Groupes LDAP synchronises avec les groupes existants.',
	'The following groups\' information were modified:' => 'Les informations suivantes des groupes ont ete modifiees:',
	'No LDAP group was found using given filter.' => 'Aucun groupe LDAP n\'a ete trouve avec le filtre fourni.',
	"Filter used to search for groups: [_1]\nSearch base: [_2]" => "Filtre utilise pour la recherche dans les groupes : [_1]
Base de recherche : [_2]",
	'(none)' => '(Aucun)',
	'The following groups were deleted:' => 'Les groupes suivants ont ete effaces:',
	'Failed to create a new group: [_1]' => 'Impossible de creer un nouveau groupe: [_1]',
	'[_1] directive must be set to synchronize members of LDAP groups to Movable Type Enterprise.' => 'La directive [_1] doit etre configuree pour synchroniser les membres des groupes LDAP avec Movable Type Enterprise.',
	'Members removed: ' => 'Membres supprimes:',
	'Members added: ' => 'Membres ajoutes:',
	'Memberships of the group \'[_2]\' (#[_3]) has been changed in synchronizing with external directory.' => 'Les membres du groupe \'[_2]\' (#[_3]) ont ete change en synchronisant avec l\'annuaire externe.',
	'LDAPUserGroupMemberAttribute must be set to enable synchronize members of groups.' => 'LDAPUserGroupMemberAttribute doit etre configure pour activer la synchronisation des membres des groupes.',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/MSSQLServer.pm
	'PublishCharset [_1] is not supported in this version of MS SQL Server Driver.' => 'PublishCharset [_1] n\'est pas supporte dans cette version de driver MS SQL Server.',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/UMSSQLServer.pm
	'This version of UMSSQLServer driver requires DBD::ODBC version 1.14.' => 'Cette version du driver UMSSQLServer necessite DBD::ODBC version 1.14.',
	'This version of UMSSQLServer driver requires DBD::ODBC compiled with Unicode support.' => 'Cette version du driver UMSSQLServer necessite DBD::ODBC compile avec le support de Unicode.',

## addons/Enterprise.pack/lib/MT/Group.pm

## addons/Enterprise.pack/lib/MT/LDAP.pm
	'Invalid LDAPAuthURL scheme: [_1].' => 'LDAPAuthURL invalide : [_1].',
	'Error connecting to LDAP server [_1]: [_2]' => 'Erreur de connection au serveur LDAP [_1]: [_2]',
	'User not found on LDAP: [_1]' => 'Utilisateur non trouve dans LDAP : [_1]',
	'Binding to LDAP server failed: [_1]' => 'Rattachement au serveur LDAP echoue: [_1]',
	'More than one user with the same name found on LDAP: [_1]' => 'Plus d\'un utilisateur avec le meme nom trouve dans LDAP: [_1]',

## addons/Enterprise.pack/tmpl/dialog/select_groups.tmpl
	'You need to create some groups.' => 'Vous devez creer des groupes',
	'Before you can do this, you need to create some groups. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a group.' => 'Avant de pouvoir faire ceci, vous devez creer des groupes. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Cliquez ici</a> pour creer un groupe.',

## addons/Enterprise.pack/tmpl/list_group.tmpl
	'[_1]: User&rsquo;s Groups' => '[_1]: Groupes de l\'utilisateur',
	'Groups: System Wide' => 'Groupes: Sur tout le systeme',
	'You have successfully disabled the selected group(s).' => 'Vous avez desactive les groupes selectionnes avec succes.',
	'You have successfully enabled the selected group(s).' => 'Vous avez active les groupes selectionnes avec succes.',
	'You have successfully deleted the groups from the Movable Type system.' => 'Vous avez supprime les groupes du systeme Movable Type avec succes.',
	'You have successfully synchronized groups\' information with the external directory.' => 'Vous avez synchronise avec succes les informations des groupes avec le repertoire externe.',
	'The user <em>[_1]</em> is currently disabled.' => 'L\'utilisateur <em>[_1]</em> est actuellement desactive',
	'You can not add disabled users to groups.' => 'Vous ne pouvez pas ajouter dans les groupes des utilisateurs desactives.',
	'Add [_1] to another group' => 'Ajouter [_1] a un autre groupe',
	'Create Group' => 'Creer un groupe',
	'You did not select any [_1] to remove.' => 'Vous n\'avez selectionne aucun [_1] a supprimer.',
	'Are you sure you want to remove this [_1]?' => 'Etes-vous sur de vouloir supprimer ce [_1]?',
	'Are you sure you want to remove the [_1] selected [_2]?' => 'Etes-vous sur de vouloir supprimer le [_1] selectionne [_2]?',
	'to remove' => 'a supprimer',

## addons/Enterprise.pack/tmpl/create_author_bulk_end.tmpl
	'All users updated successfully!' => 'Tous les utilisateurs ont ete mis a jour avec succes!',
	'An error occurred during the updating process. Please check your CSV file.' => 'Une erreur s\'est produite pendant la mise a jour. Merci de verifier votre fichier CSV.',

## addons/Enterprise.pack/tmpl/include/list_associations/page_title.group.tmpl
	'Users &amp; Groups for [_1]' => 'Utilisateurs &amp; groupes pour [_1]',
	'Group Associations for [_1]' => 'Associations de groupe pour [_1]',

## addons/Enterprise.pack/tmpl/include/users_content_nav.tmpl

## addons/Enterprise.pack/tmpl/include/group_table.tmpl
	'group' => 'groupe',
	'groups' => 'Groupes',
	'Enable selected group (e)' => 'Activer le groupe selectionne (e)',
	'Disable selected group (d)' => 'Desactiver le groupe selectionne (d)',
	'Remove selected group (d)' => 'Supprimer le groupe selectionne (d)',
	'Only show enabled groups' => 'Afficher uniquement les groupes actives',
	'Only show disabled groups' => 'Afficher uniquement les groupes desactives',

## addons/Enterprise.pack/tmpl/list_group_member.tmpl
	'[_1]: Group Members' => '[_1]: Membres du groupe',
	'<em>[_1]</em>: Group Members' => '<em>[_1]</em>: Membres du groupe',
	'You have successfully deleted the users.' => 'Vous avez supprime les utilisateurs avec succes.',
	'You have successfully added new users to this group.' => 'Vous avez ajoute les nouveaux utilisateurs dans ce groupe avec succes.',
	'You have successfully synchronized users\' information with external directory.' => 'Vous avez synchronise avec succes les informations des utilisateurs avec l\'annuaire externe.',
	'Some ([_1]) of the selected users could not be re-enabled because they were no longer found in LDAP.' => 'Certains ([_1]) utilisateurs selectionnes n\'ont pu etre reactives car ils ne sont plus dans LDAP.',
	'You have successfully removed the users from this group.' => 'Vous avez retires avec succes les utilisateurs de ce groupe.',
	'Group Disabled' => 'Groupe desactive',
	'You can not add users to a disabled group.' => 'Vous ne pouvez pas ajouter des utilisateurs a un groupe desactive.',
	'Add user to [_1]' => 'Ajouter utilisateur a [_1]',
	'member' => 'membre',
	'Show Enabled Members' => 'Afficher les membres actifs',
	'Show Disabled Members' => 'Afficher les membres desactives',
	'Show All Members' => 'Afficher tous les membres',
	'None.' => 'Aucun.',
	'(Showing all users.)' => '(Afficher tous les utilisateurs.)',
	'Showing only users whose [_1] is [_2].' => 'Afficher seulement les utilisateurs dont [_1] est [_2].',
	'Show' => 'Afficher',
	'all' => 'Toutes',
	'only' => 'seulement',
	'users where' => 'utilisateurs ou',
	'No members in group' => 'Aucun membre dans ce groupe',
	'Only show enabled users' => 'Afficher seulement les utilisateurs actifs',
	'Only show disabled users' => 'Afficher seulement les utilisateurs desactives.',
	'Are you sure you want to remove this [_1] from this group?' => 'Etes-vous sur des vouloir supprimer ce [_1] de ce groupe?',
	'Are you sure you want to remove the [_1] selected [_2] from this group?' => 'Etes-vous sur des vouloir supprimer le [_1] selectionne [_2] de ce groupe?',

## addons/Enterprise.pack/tmpl/author_bulk.tmpl
	'Manage Users in bulk' => 'Gerer les utilisateurs en masse',
	'_USAGE_AUTHORS_2' => 'Vous pouvez creer, modifier et effacer des utilisateurs en masse en chargeant un fichier CSV contenant ces commandes et les donnees associees.',
	'Upload source file' => 'Charger le fichier source',
	'Specify the CSV-formatted source file for upload' => 'Specifier le fichier source CSV a charger',
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
	'You can configure your LDAP settings from here if you would like to use LDAP-based authentication.' => 'Vous devez configurer vos reglages LDAP ici si vous souhaitez utiliser l\'identification LDAP.',
	'Your configuration was successful.' => 'Votre configuration est correcte.',
	'Click \'Continue\' below to configure the External User Management settings.' => 'Cliquez sur \'Continuer\' ci-dessous pour configurer les reglages de la gestion externe des utilisateurs.',
	'Click \'Continue\' below to configure your LDAP attribute mappings.' => 'Cliquez sur \'Continuer\' ci-dessous pour configurer vos rattachements des attributs LDAP.',
	'Your LDAP configuration is complete.' => 'Votre configuration LDAP est terminee.',
	'To finish with the configuration wizard, press \'Continue\' below.' => 'Pour finir l\'assistant de configuration, cliquez sur \'Continuer\' ci-dessous.',
	'An error occurred while attempting to connect to the LDAP server: ' => 'Une erreur s\'est produite en essayant de se connecter au serveur LDAP:',
	'Use LDAP' => 'Utiliser LDAP',
	'Authentication URL' => 'URL d\'identification',
	'The URL to access for LDAP authentication.' => 'L\'URL pour acceder a l\'identification LDAP.',
	'Authentication DN' => 'Identificatiin DN',
	'An optional DN used to bind to the LDAP directory when searching for a user.' => 'Un DN optionnel utilise pour rattacher a l\'annuaire LDAP lors d\'une recherche d\'utilisateur.',
	'Authentication password' => 'Mot de passe de l\'identification',
	'Used for setting the password of the LDAP DN.' => 'Utilise pour regler le mot de passe du DN LDAP.',
	'SASL Mechanism' => 'Mecanisme SASL',
	'The name of SASL Mechanism to use for both binding and authentication.' => 'Nom du mecanisme SASL a utiliser pour le rattachement et l\'identification.',
	'Test Username' => 'Identifiant de test',
	'Test Password' => 'Mot de passe de test',
	'Enable External User Management' => 'Activer les gestion externe des utilisateurs',
	'Synchronization Frequency' => 'Frequence de synchronisation',
	'Frequency of synchronization in minutes. (Default is 60 minutes)' => 'Frequence de synchronisation en minutes. (60 minutes par defaut)',
	'15 Minutes' => '15 Minutes',
	'30 Minutes' => '30 Minutes',
	'60 Minutes' => '60 Minutes',
	'90 Minutes' => '90 Minutes',
	'Group search base attribute' => 'Attribut de base de recherche du groupe',
	'Group filter attribute' => 'Attribut de filtre du groupe',
	'Search Results (max 10 entries)' => 'Resultats de recherche (maxi 10 entrees)',
	'CN' => 'CN',
	'No groups were found with these settings.' => 'Aucun groupe n\'a ete trouve avec ces reglages.',
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
	'Search result (max 10 entries)' => 'Resultat de recherche (maxi 10 entrees)',
	'Group Fullname' => 'Nom complet du groupe',
	'Group Member' => 'Membre du groupe',
	'No groups could be found.' => 'Aucun groupe n\'a ete trouve.',
	'User Fullname' => 'Nom complet utilisateur',
	'No users could be found.' => 'Aucun utilisateur n\'a ete trouve.',
	'Test connection to LDAP' => 'Tester la connection a LDAP',
	'Test search' => 'Tester la recherche',

## addons/Enterprise.pack/tmpl/create_author_bulk_start.tmpl

## addons/Enterprise.pack/tmpl/edit_group.tmpl
	'Edit Group' => 'Modifier le groupe',
	'Group profile has been updated.' => 'Le profil du groupe a ete modifie.',
	'LDAP Group ID' => 'Group ID LDAP',
	'The LDAP directory ID for this group.' => 'L\'ID de l\'annuaire LDAP pour ce groupe.',
	'Status of group in the system. Disabling a group removes its members&rsquo; access to the system but preserves their content and history.' => 'Statut du groupe dans le systeme. Desactiver un groupe supprime l\'acces de ses membres au systeme mais preserve leur contenu et historique.',
	'The name used for identifying this group.' => 'Le nom utilise pour identifier ce groupe.',
	'The display name for this group.' => 'Le nom d\'affichage de ce groupe.',
	'Enter a description for your group.' => 'Saisir une description pour votre groupe.',
	'Created on' => 'Cree le',
	'Save changes to this field (s)' => 'Sauvegarder les changements apportes a ce champ (s)',

## plugins/Cloner/cloner.pl
	'Clones a blog and all of its contents.' => 'Dupliquer un blog et tout son contenu',
	'Cloning blog \'[_1]\'...' => 'Duplication du blog...',
	'Finished! You can <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">return to the blog listing</a> or <a href="javascript:void(0);" onclick="closeDialog(\'[_2]\');">configure the Site root and URL of the new blog</a>.' => 'Termine ! Vous pouvez <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">retourner a la liste des blogs</a> ou <a href="javascript:void(0);" onclick="closeDialog(\'[_2]\');">configurer la racine du site et l\'URL du nouveau blog</a>.',
	'No blog was selected to clone.' => 'Aucun blog n\'a ete selectionne pour la duplication',
	'This action can only be run for a single blog at a time.' => 'Cette action ne peut etre executee que pour un blog a la fois',
	'Invalid blog_id' => 'Identifiant du blog non valide',
	'Clone Blog' => 'Dupliquer le blog',

## plugins/Markdown/SmartyPants.pl
	'Easily translates plain punctuation characters into \'smart\' typographic punctuation.' => 'Permet de convertir facilement des caracteres de ponctuation basiques vers une ponctuation plus complexe (comme les guillemets, tirets, etc...)',

## plugins/Markdown/Markdown.pl
	'A plain-text-to-HTML formatting plugin.' => 'Un plugin de formatage plain-text vers HTML',
	'Markdown' => 'Markdown',
	'Markdown With SmartyPants' => 'Markdown avec SmartyPants',

## plugins/WXRImporter/lib/WXRImporter/Import.pm

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'Le fichier n\'est pas dans le format WXR.',
	'Creating new tag (\'[_1]\')...' => 'Creation d\'un nouveau tag (\'[_1]\')...',
	'Saving tag failed: [_1]' => 'L\'enregistrement du tag a echoue : [_1]',
	'Duplicate asset (\'[_1]\') found.  Skipping.' => 'L\'element  (\'[_1]\') a ete trouve en double. Abandon.',
	'Saving asset (\'[_1]\')...' => 'Enregistrement de l\'element (\'[_1]\')...',
	' and asset will be tagged (\'[_1]\')...' => ' et l\'element sera taggue (\'[_1]\')...',
	'Duplicate entry (\'[_1]\') found.  Skipping.' => 'La note  (\'[_1]\') a ete trouvee en double. Abandon.',
	'Saving page (\'[_1]\')...' => 'Enregistrement de la page (\'[_1]\')...',

## plugins/WXRImporter/WXRImporter.pl
	'Import WordPress exported RSS into MT.' => 'Importer depuis WordPress exported RSS vers MT',
	'WordPress eXtended RSS (WXR)' => 'WordPress eXtended RSS (WXR)',
	'Download WP attachments via HTTP.' => 'Telecharger tous les fichiers attaches a un blog WordPress par HTTP',

## plugins/WXRImporter/tmpl/options.tmpl
	'Before you import WordPress posts to Movable Type, we recommend that you <a href=\'[_1]\'>configure your blog\'s publishing paths</a> first.' => 'Avant d\'importer des notes Wordpress dans Movable Type, nous vous recommandons d\'abord de <a href=\'[_1]\'>configurer les chemins de publication de votre blog</a>.',
	'Upload path for this WordPress blog' => 'Chemin d\'envoi pour ce blog WordPress',
	'Replace with' => 'Remplacer par',
	'Download attachments' => 'Telecharger les fichiers attaches',
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'L\'utilisation d\'un cron job est requis pour telecharger en arriere plan les fichiers attaches a un blog WordPress.',
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'Telecharger les fichiers attaches d\'un blog WordPress (images et autres documents).',

## plugins/TypePadAntiSpam/lib/MT/TypePadAntiSpam.pm
	'API key is a required parameter.' => 'La cle API est requise.',

## plugins/TypePadAntiSpam/tmpl/system.tmpl
	'API Key' => 'Cle API',
	'To enable this plugin, you\'ll need a free TypePad AntiSpam API key. You can <strong>get your free API key at [_1]antispam.typepad.com[_2]</strong>. Once you have your key, return to this page and enter it in the field below.' => 'Pour activer ce plugin, vous devez obtenir une cle API gratuite TypePad AntiSpam. Vous pouvez <strong>obtenir votre cle API gratuite sur [_1]antispam.typepad.com[_2]</strong>. Une fois votre cle obtenue, retournez sur cette page et entrez-la dans le champs ci-dessous.',
	'Service Host' => 'Hebergeur de service',
	'The default service host for TypePad AntiSpam is api.antispam.typepad.com. You should only change this if you are using a different service that is compatible with the TypePad AntiSpam API.' => 'L\'hebergeur de service par defaut pour TypePad AntiSpam est api.antispam.typepad.com. Vous ne devriez changer cela uniquement si vous utilisez un autre service compatible avec l\'API TypePad AntiSpam.',

## plugins/TypePadAntiSpam/tmpl/config.tmpl
	'Junk Score Weight' => 'Niveau du filtrage',
	'Least Weight' => 'Moins agressif',
	'Most Weight' => 'Plus agressif',
	'Comments and TrackBacks receive a junk score between -10 (definitely spam) and +10 (definitely not spam). This setting allows you to control the weight of the TypePad AntiSpam rating relative to other filters you may have installed to help you filter comments and TrackBacks.' => 'Les commentaires et trackbakcs recoivent une note de spam entre - 10 (tres forte probabilite d\'etre du spam) et +10 (tres forte probabilite de n\'etre pas du spam). Ces parametres vous permettent de controler la ponderation du filtre de TypePad AntiSpam vis-a-vis des autres filtres que vous pouvez avoir installe pour vous aider a filtrer les commentaires et trackbacks.',

## plugins/TypePadAntiSpam/tmpl/stats_widget.tmpl
	'widget_label_width' => 'widget_label_width',
	'widget_totals_width' => 'widget_totals_width',
	'TypePad AntiSpam' => 'TypePad AntiSpam',
	'Spam Blocked' => 'Spam bloque',
	'on this blog' => 'sur ce blog',
	'on this system' => 'sur ce systeme',

## plugins/TypePadAntiSpam/TypePadAntiSpam.pl
	'TypePad AntiSpam is a free service from Six Apart that helps protect your blog from comment and TrackBack spam. The TypePad AntiSpam plugin will send every comment or TrackBack submitted to your blog to the service for evaluation, and Movable Type will filter items if TypePad AntiSpam determines it is spam. If you discover that TypePad AntiSpam incorrectly classifies an item, simply change its classification by marking it as "Spam" or "Not Spam" from the Manage Comments screen, and TypePad AntiSpam will learn from your actions. Over time the service will improve based on reports from its users, so take care when marking items as "Spam" or "Not Spam."' => 'TypePad AntiSpam est un service gratuit de Six Apart vous aidant a proteger votre blog des commentaires et trackbacks de spam. Le plugin TypePad AntiSpam enverra chaque commentaire ou trackback recu sur votre blog au service pour un evaluation et Movable Type filtrera les elements si TypePad AntiSpam considere ces elements comme etant du spam. Si vous decouvrez un element que TypePad AntiSpam a mal filtre, changez simplement sa classification en le marquant comme "Spam" ou "Non-spam" dans la page Gerer les commentaires et TypePad AntiSpam apprendra de vos actions. Le service s\'ameliorera au fur et a mesure des notifications de ses utilisateurs, usez donc d\'une attention particuliere lorsque vous marquez un element comme etant du "spam" ou "non-spam".',
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] for this blog, and [quant,_2,message,messages] system-wide.' => 'Depuis le debut, TypePad AntiSpam a bloque [quant,_1,message,messages] sur ce blog et [quant,_2,message,messages] sur tout le systeme.',
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] system-wide.' => 'Depuis le debut, TypePad AntiSpam a bloque [quant,_1,message,messages] sur tout le systeme.',
	'Failed to verify your TypePad AntiSpam API key: [_1]' => 'Erreur lors de la verification de votre cle API TypePad AntiSpam : [_1]',
	'The TypePad AntiSpam API key provided is invalid.' => 'La cle API TypePad AntiSpam entree n\'est pas valide.',

## plugins/StyleCatcher/config.yaml
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.' => 'StyleCatcher vous permet de naviguer facilement a travers des styles et de les appliquer a votre blog en quelques clics seulement. Pour en savoir plus a propos des styles Movable Type, ou pour avoir de nouvelles sources de styles, visitez la page <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a>.',
	'MT 4 Style Library' => 'Bibliotheque MT4',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Une gamme de styles compatibles avec les gabarits MT4 par defaut',
	'Styles' => 'Habillages',

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'Le repertoire mt-static n\'a pas pu etre trouve. Veuillez configurer le \'StaticFilePath\' pour continuer.',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Impossible de creer le dossier [_1] - Verifiez que votre dossier \'themes\' et en mode webserveur/ecriture.',
	'Successfully applied new theme selection.' => 'Selection de nouveau Theme appliquee avec succes.',
	'Invalid URL: [_1]' => 'URL inaccessible : [_1]',

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a Style' => 'Habillages',
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
	'The selected theme has been applied, but as you have changed the layout, you will need to republish your blog to apply the new layout.' => 'L\'habillage selectionne a ete applique. Vous devez republier votre blog afin d\'appliquer la nouvelle mise en page.',
	'The selected theme has been applied!' => 'L\'habillage selectionne a ete applique!',
	'Error loading themes! -- [_1]' => 'Erreur lors du chargement des habillages ! -- [_1]',
	'Stylesheet or Repository URL' => 'URL de la feuille de style ou du repertoire',
	'Stylesheet or Repository URL:' => 'URL de la feuille de style ou du repertoire:',
	'Download Styles' => 'Telecharger des habillages',
	'Current theme for your weblog' => 'Theme actuel de votre weblog',
	'Current Style' => 'Habillage actuel',
	'Locally saved themes' => 'Themes enregistres localement',
	'Saved Styles' => 'Habillages enregistres',
	'Default Styles' => 'Habillages par defaut',
	'Single themes from the web' => 'Themes uniques venant du web',
	'More Styles' => 'Plus d\'habillages',
	'Selected Design' => 'Habillage selectionne',
	'Layout' => 'Mise en page',

## plugins/spamlookup/spamlookup_words.pl
	'SpamLookup module for moderating and junking feedback using keyword filters.' => 'SpamLookup module pour moderer et marquer comme spam les messages en utilisant des filtres de mots-cles.',
	'SpamLookup Keyword Filter' => 'SpamLookup filtre de mots-cles',

## plugins/spamlookup/spamlookup.pl
	'SpamLookup module for using blacklist lookup services to filter feedback.' => 'Module SpamLookup pour utiliser les services de verification de liste noire pour filtrer les commentaires.',
	'SpamLookup IP Lookup' => 'SpamLookup verification des IP',
	'SpamLookup Domain Lookup' => 'SpamLookup verification des domaines',
	'SpamLookup TrackBack Origin' => 'SpamLookup origine des trackbacks',
	'Despam Comments' => 'Commentaires non-spam',
	'Despam TrackBacks' => 'Trackbacks non-spam',
	'Despam' => 'Non-spam',

## plugins/spamlookup/lib/spamlookup.pm
	'Failed to resolve IP address for source URL [_1]' => 'Echec de la verification de l\'adresse IP pour l\'URL source [_1]',
	'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Moderation : l\IP du domaine ne correspond pas a l\'IP de ping pour l\'URL de la source [_1]; IP du domaine: [_2]; IP du ping: [_3]',
	'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'L\'IP du domaine ne correspond pas a l\'IP du ping pour l\'URL source [_1]; l\'IP du domaine: [_2]; IP du ping: [_3]',
	'No links are present in feedback' => 'Aucun lien n\'est present dans le message',
	'Number of links exceed junk limit ([_1])' => 'Le nombre de liens a depasse la limite de marquage comme spam ([_1])',
	'Number of links exceed moderation limit ([_1])' => 'Le nombre de liens a depasse la limite de moderation ([_1])',
	'Link was previously published (comment id [_1]).' => 'Le lien a ete publie precedemment (id de commentaire [_1]).',
	'Link was previously published (TrackBack id [_1]).' => 'Le lien a ete publie precedemment (id de trackback [_1]).',
	'E-mail was previously published (comment id [_1]).' => 'L\'email a ete publie precedemment (id de commentaire [_1]).',
	'Word Filter match on \'[_1]\': \'[_2]\'.' => 'Le filtre de mot correspond sur \'[_1]\': \'[_2]\'.',
	'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'Moderation pour filtre de mot sur \'[_1]\': \'[_2]\'.',
	'domain \'[_1]\' found on service [_2]' => 'domaine \'[_1]\' trouve sur le service [_2]',
	'[_1] found on service [_2]' => '[_1] trouve sur le service [_2]',

## plugins/spamlookup/spamlookup_urls.pl
	'SpamLookup - Link' => 'SpamLookup - Lien',
	'SpamLookup module for junking and moderating feedback based on link filters.' => 'SpamLookup module pour marquer comme spam et moderer les messages base sur les filtres de liens.',
	'SpamLookup Link Filter' => 'SpamLookup filtre de lien',
	'SpamLookup Link Memory' => 'SpamLookup memorisation des liens',
	'SpamLookup Email Memory' => 'SpamLookup memorisation des emails',

## plugins/spamlookup/tmpl/url_config.tmpl
	'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Les filtres de liens surveillent le nombre de liens hypertextes dans les messages entrants. Les messages avec beaucoup de liens peuvent etre retenus pour moderation ou marques comme spam. Inversement, les messages qui ne contiennent pas de liens ou lient seulement vers des URLs publiees precedemment peuvent etre notes positivement. (Activez cette option si vous etes sur que votre site est deja depourvu de spam.)',
	'Link Limits' => 'Limite de liens',
	'Credit feedback rating when no hyperlinks are present' => 'Crediter la notation du message quand aucun lien hypertexte n\'est present',
	'Adjust scoring' => 'Ajuster la notation',
	'Score weight:' => 'Poids de la notation:',
	'Moderate when more than' => 'Moderer quand plus de',
	'link(s) are given' => 'liens sont presents',
	'Junk when more than' => 'Marquer comme spam quand plus de',
	'Link Memory' => 'Memorisation des liens',
	'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Crediter la notation du message quand l\'element &quot;URL&quot; du message a ete publie precedemment',
	'Only applied when no other links are present in message of feedback.' => 'Appliquer seulement quand aucun autre lien n\'est present quand le texte du message.',
	'Exclude URLs from comments published within last [_1] days.' => 'Exclure les URLs des commentaires publies dans les [_1] derniers jours.',
	'Email Memory' => 'Memorisation des emails',
	'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Crediter la notation du message lorsque des commentaires publies precedemment contenaient l\'adresse &quot;email&quot;',
	'Exclude Email addresses from comments published within last [_1] days.' => 'Exclure les adresses email des commentaires publies dans les [_1] derniers jours.',

## plugins/spamlookup/tmpl/lookup_config.tmpl
	'Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog\'s Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.' => 'Lookups surveille les adresses IP sources et les liens hypertextes de tous les commentaires/trackbacks entrants. Si un commentaire ou un trackback provient d\'une adresse IP en liste noire ou contient un domaine banni, il peut etre retenu pour moderation ou note comme spam et place dans le repertoire de spam. De plus, des verifications avancees sur les donnees sources des trackbacks peuvent etre realises.',
	'IP Address Lookups' => 'Verifier une adresse IP',
	'Moderate feedback from blacklisted IP addresses' => 'Moderer les commentaires/trackbacks des adresses IP en liste noire',
	'Junk feedback from blacklisted IP addresses' => 'Marquer comme spam les commentaires/trackbacks des adresses IP en liste noire',
	'Less' => 'Moins',
	'More' => 'Plus',
	'block' => 'bloquer',
	'IP Blacklist Services' => 'Services de liste noire d\'IP',
	'Domain Name Lookups' => 'Verifier un nom de domaine',
	'Moderate feedback containing blacklisted domains' => 'Moderer le contenu des messages contenant des domaines en liste noire',
	'Junk feedback containing blacklisted domains' => 'Marquer comme spam les messages contenant les domaines en liste noire',
	'Domain Blacklist Services' => 'Services de liste noire de domaines',
	'Advanced TrackBack Lookups' => 'Verifications avancees des trackbacks',
	'Moderate TrackBacks from suspicious sources' => 'Moderer les trackbacks des sources suspectes',
	'Junk TrackBacks from suspicious sources' => 'Marquer comme spam les trackbacks des sources suspectes',
	'Lookup Whitelist' => 'Verifier la liste blanche',
	'To prevent lookups for specific IP addresses or domains, list each on a line by itself.' => 'Pour ne pas effectuer de verifications pour des noms de domaines ou addresses IP specifiques, listez-les ligne par ligne.',

## plugins/spamlookup/tmpl/word_config.tmpl
	'Incomming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Les messages entrant peuvent etre analyses a la recherche des mots-cles specifiques, de noms de domaines, et de gabarits. Les messages correspondants peuvent etre maintenus pour moderation ou marques comme spam. De plus, les notes de spam pour ces messages peuvent etre personnalises.',
	'Keywords to Moderate' => 'Mots-cles a moderer',
	'Keywords to Junk' => 'Mots-cles a marquer comme spam',

## plugins/MultiBlog/lib/MultiBlog.pm
	'The include_blogs, exclude_blogs, blog_ids and blog_id attributes cannot be used together.' => 'Les attributs include_blogs, exclude_blogs, blog_ids et blog_id ne peuvent pas etre utilises ensemble.',
	'The attribute exclude_blogs cannot take "all" for a value.' => 'L\'attribut exclude_blogs ne peut pas prendre "all" pour valeur.',
	'The value of the blog_id attribute must be a single blog ID.' => 'La valeur de l\'attribut blog_id doit etre un ID de blog unique.',
	'The value for the include_blogs/exclude_blogs attributes must be one or more blog IDs, separated by commas.' => 'La valeur des attributs include_blogs/exclude_blogs doit etre un ou plusieurs IDs de blogs, separes par des virgules.',

## plugins/MultiBlog/lib/MultiBlog/Tags.pm
	'MTMultiBlog tags cannot be nested.' => 'Les balises MTMultiBlog ne peuvent pas etre imbriquees.',
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Valeur de l\'attribut "mode" inconnue : [_1]. Les valeurs valides sont "loop" et "context".',

## plugins/MultiBlog/multiblog.pl
	'MultiBlog allows you to publish content from other blogs and define publishing rules and access controls between them.' => 'Multiblog vous permet de publier du contenu d\'autres blogs et de definir des regles de publication et de droit d\'acces entre eux.',
	'MultiBlog' => 'MultiBlog',
	'Create Trigger' => 'Creer un nouvel evenement',
	'Weblog Name' => 'Nom du blog',
	'Search Weblogs' => 'Rechercher les blogs',
	'When this' => 'quand ce',
	'* All Weblogs' => '* Tous les blogs',
	'Select to apply this trigger to all weblogs' => 'Selectionner pour appliquer cet evenement a tous les blogs',
	'saves an entry' => 'sauvegarde une note',
	'publishes an entry' => 'publie une note',
	'publishes a comment' => 'publie un commentaire',
	'publishes a TrackBack' => 'publie un trackback',
	'rebuild indexes.' => 'reconstruire les index.',
	'rebuild indexes and send pings.' => 'reconstruire les index et envoyer les pings.',

## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
	'Create MultiBlog Trigger' => 'Creer un evenement MultiBlog',

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'When' => 'Quand',
	'Any Weblog' => 'Tous les blogs',
	'Weblog' => 'Blog',
	'Trigger' => 'Evenement',
	'Action' => 'Action',
	'Content Privacy' => 'Protection du contenu',
	'Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.' => 'Indiquez si les autres blogs de cette installation peuvent publier du contenu de ce blog. Ce reglage prend le dessus sur la regle d\'agregation du systeme par defaut qui se trouve dans la configuration de MultiBlog pour tout le systeme.',
	'Use system default' => 'Utiliser la regle par defaut du systeme',
	'Allow' => 'Autoriser',
	'Disallow' => 'Interdire',
	'MTMultiBlog tag default arguments' => 'Arguments par defaut de la balise MTMultiBlog',
	'Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or \'all\' (include_blogs only) are acceptable values.' => 'Autorise l\'utilisation de la balise MTMultiBlog sans les attributs include_blogs/exclude_blogs. Les valeurs correctes sont une liste de BlogIDs separes par des virgules, ou \'all\' (seulement pour include_blogs).',
	'Include blogs' => 'Inclure les blogs',
	'Exclude blogs' => 'Exclure les blogs',
	'Rebuild Triggers' => 'Evenements de republication',
	'Create Rebuild Trigger' => 'Creer un evenement de republication ',
	'You have not defined any rebuild triggers.' => 'Vous n\'avez defini aucun evenement de republication.',

## plugins/MultiBlog/tmpl/system_config.tmpl
	'Default system aggregation policy' => 'Regle d\'agregation du systeme par defaut',
	'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'L\'agregation inter-blog sera activee par defaut. Les blogs individuels peuvent etre configures via les parametres MultiBlog du blog en question, pour restreindre l\'acces a leur contenu par les autres blogs.',
	'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'L\'agregation inter-blog sera desactivee par defaut. Les blogs individuels peuvent etre configures via les parametres MultiBlog du blog en question, pour autoriser l\'acces a leur contenu par les autres blogs.',

## plugins/Textile/textile2.pl
	'A humane web text generator.' => 'Generateur de texte user-friendly',
	'Textile 2' => 'Textile 2',

## plugins/WidgetManager/WidgetManager.pl
	'Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.' => 'Widget Manager version 1.1; Cette version est destinee a la mise a jour des donnees des versions plus anciennes de Widget Manager, delivre avec Movable Type. Aucune autre fonction n\'est incluse. Vous pouvez supprimer ce plugin apres avoir installe/mis a jour Movable Type.',
	'Moving storage of Widget Manager [_1]...' => 'Changement de l\'emplacement du Widget Manager [_1]...',

## plugins/feeds-app-lite/lib/MT/Feeds/Lite.pm
	'An error occurred processing [_1]. The previous version of the feed was used. A HTTP status of [_2] was returned.' => 'Une erreur s\'est produite en traitant [_1]. La version precedente du flux a ete utilisee. Un statut HTTP de [_2] a ete retourne.',
	'An error occurred processing [_1]. A previous version of the feed was not available.A HTTP status of [_2] was returned.' => 'Une erreur s\'est produite en traitant [_1]. Une version precedente du flux n\'est pas disponible. Un statut HTTP de [_2] a ete renvoye.',

## plugins/feeds-app-lite/lib/MT/Feeds/Tags.pm
	'\'[_1]\' is a required argument of [_2]' => '\'[_1]\' est un argument necessaire de [_2]',
	'MT[_1] was not used in the proper context.' => 'Le [_1] MT n\'a pas ete utilise dans le bon contexte.',

## plugins/feeds-app-lite/tmpl/config.tmpl
	'Feeds.App Lite Widget Creator' => 'Createur de widget de flux',
	'Configure feed widget settings' => 'Configurer les parametres du widget de flux',
	'Enter a title for your widget.  This will also be displayed as the title of the feed when used on your published blog.' => 'Saisissez un titre pour votre widget. Il sera aussi utilise comme titre pour le flux qui sera utilise sur votre blog.',
	'[_1] Feed Widget' => 'Widget de flux [_1]',
	'Select the maximum number of entries to display.' => 'Selectionnez le nombre maximum de notes que vous voulez afficher.',
	'3' => '3',
	'5' => '5',
	'10' => '10',
	'All' => 'Toutes',

## plugins/feeds-app-lite/tmpl/msg.tmpl
	'No feeds could be discovered using [_1]' => 'Aucun flux n\'a pu etre trouve en utilisant [_1]',
	'An error occurred processing [_1]. Check <a href="javascript:void(0)" onclick="closeDialog(\'http://www.feedvalidator.org/check.cgi?url=[_2]\')">here</a> for more detail and please try again.' => 'Une erreur s\'est produite en traitant [_1]. Verifiez <a href="javascript:void(0)" onclick="closeDialog(\'http://www.feedvalidator.org/check.cgi?url=[_2]\')">ici</a> pour plus de details et essayez a nouveau.',
	'A widget named <strong>[_1]</strong> has been created.' => 'Un widget nomme <strong>[_1]</strong> a ete cree.',
	'You may now <a href="javascript:void(0)" onclick="closeDialog(\'[_2]\')">edit &ldquo;[_1]&rdquo;</a> or include the widget in your blog using <a href="javascript:void(0)" onclick="closeDialog(\'[_3]\')">WidgetManager</a> or the following MTInclude tag:' => 'Vous pouvez maintenant <a href="javascript:void(0)" onclick="closeDialog(\'[_2]\')">modifier &ldquo;[_1]&rdquo;</a> ou inclure le widget dans votre blog en utilisant <a href="javascript:void(0)" onclick="closeDialog(\'[_3]\')">WidgetManager</a> ou la balise MTInclude suivante :',
	'You may now <a href="javascript:void(0)" onclick="closeDialog(\'[_2]\')">edit &ldquo;[_1]&rdquo;</a> or include the widget in your blog using the following MTInclude tag:' => 'Vous pouvez maintenant <a href="javascript:void(0)" onclick="closeDialog(\'[_2]\')">modifier &ldquo;[_1]&rdquo;</a> ou inclure le widget dans votre blog en utilisant la balise  MTInclude suivante :',
	'Create Another' => 'En creer un autre',

## plugins/feeds-app-lite/tmpl/start.tmpl
	'You must enter a feed or site URL to proceed' => 'Vous devez saisir l\'URL d\'un flux ou d\'un site pour poursuivre',
	'Create a widget from a feed' => 'Creer un widget a partir d\'un flux',
	'Feed or Site URL' => 'URL du site ou du flux',
	'Enter the URL of a feed, or the URL of a site that has a feed.' => 'Saisissez l\'adresse d\'un flux ou l\'adresse d\'un site possedant un flux.',

## plugins/feeds-app-lite/tmpl/select.tmpl
	'Multiple feeds were found' => 'Plusieurs flux ont ete trouves',
	'Select the feed you wish to use. <em>Feeds.App Lite supports text-only RSS 1.0, 2.0 and Atom feeds.</em>' => 'Selectionnez le flux que vous voulez utiliser. <em>Feeds.App Lite supporte les flux texte uniquement en RSS 1.0, 2.0 et Atom.</em>',
	'URI' => 'URI',

## plugins/feeds-app-lite/mt-feeds.pl
	'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type? <a href="http://code.appnel.com/feeds-app" target="_blank">Upgrade to Feeds.App</a>.' => 'Feeds.App Lite vous aide a republier les flux sur votre blog. Vous souhaitez en faire plus avec les flux dans Movable Type ? <a href="http://code.appnel.com/feeds-app" target="_blank">Evoluez vers Feeds.App</a>.',
	'Create a Feed Widget' => 'Creer un widget a partir d\'un flux',

	'A request has been made to change your password in Movable Type. To complete this process click on the link below to select a new password.' => 'Une requete a ete faite pour changer votre mot de passe dans Movable Type. Pour terminer cliquez sur le lien ci-dessous pour choisir un nouveau mot de passe.', # Translate - New
      'If you did not request this change, you can safely ignore this email.' => 'Si vous n\'avez pas demande ce changement, vous pouvez ignorer cet email.', # Translate - New
      '%f-thumb-%wx%h-%i%x' => '%f-thumb-%wx%h-%i%x', # Translate - New
      '[_1] contains an invalid character: [_2]' => '[_1] contient un caractere invalide : [_2]', # Translate - New
      'Email address is required.' => 'Adresse email obligatoire', # Translate - New
      'User not found' => 'Utilisateur introuvable', # Translate - New
      'Password reset token not found' => 'Token de remise a zero du mot de passe introuvable', # Translate - New
      'Email address not found' => 'Adresse email introuvable', # Translate - New
      'Your request to change your password has expired.' => 'Votre demande de modification de mot de passe a expiree.', # Translate - New
      'Invalid password reset request' => 'Requete de modification de mot de passe invalide', # Translate - New
      'Please confirm your new password' => 'Merci de confirmer votre nouveau mot de passe', # Translate - New
      'Password do not match' => 'Le mot de passe ne correspond pas', # Translate - New
      'Invalid [_1] parameter.' => 'Parametre [_1] invalide', # Translate - New
      'Blog, BlogID or Template param must be specified.' => 'Les parametres Blog, BlogID ou Template doivent etre specifies.', # Translate - New
      'Error saving [_1] record # [_3]: [_2]...' => 'Erreur en enregistrant l\'enregistrement [_1] # [_3]: [_2]...', # Translate - New
      'The email address provided is not unique.  Please enter your username.' => 'Une adresse  email n\'est pas unique. Merci de saisir votre nom de membre.', # Translate - New
      'An email with a link to reset your password has been sent to your email address ([_1]).' => 'Un email contenant un lien pour reinitialiser votre mot de passe a ete envoye a votre adresse email ([_1]).', # Translate - New
      'Choose New Password' => 'Choisissez un nouveau mot de passe', # Translate - New
      'You must set Local Archive Path.' => 'Vous devez renseigner Local Archive Path.', # Translate - New
      'You must set a valid Archive URL.' => 'Vous devez renseigner une Archive URL valide.', # Translate - New
      'You must set a valid Local Archive Path.' => 'Vous devez renseigner un Local Archive Path valide.', # Translate - New 
      'Passwords do not match' => 'Les mots de passe ne correspondent pas', # Translate - New
      'Password reset for user \'[_1]\' (user #[_2]) was successful. Recovery link sent to the following address: [_3]' => 'Reinitialisation du mot de passe pour l\'utilisateur \'[_1]\' (utilisateur #[_2]) a reussi. Lien envoye a l\'adresse suivante : [_3]', # Translate - New
      'Updating password recover email template...' => 'Template de reinitialisation du mot de passe en cours de mise a jour...', # Translate - New
      'The email address provided is not unique.  Please enter your username.' => 'L\'adresse email fournie n\'est pas unique. Merci de saisir votre nom d\'utilisateur.', # Translate - New
      '_WARNING_PASSWORD_RESET_MULTI' => 'Vous etes sur le point d\'envoyer des emails pour permettre aux utilisateurs selectionnes de reinitialiser leurs mots de passe. Voulez-vous continuer ?',
      "A password reset link has been sent to [_3] for user '[_1]' (user #[_2])." => 'Un lien de reinitialisation de mot de passe envoye a [_3] pour utilisateur \'[_1]\' (utilisateur #[_2]).', 

## plugins/CommunityActionStreams/config.yaml
	'Action streams for community events: add entry, add comment, add favorite, follow user.' => 'Flux d\'actions pour les evenements de la communaute : nouvelle note, nouveau commentaire, nouveau favori, suivi d\'un utilisateur.',

## plugins/Motion/config.yaml
	'A Movable Type theme with structured entries and action streams.' => 'Un theme Movable Type avec des notes structurees et des flux d\'actions.',
	'Adjusting field types for embed custom fields...' => 'Ajustement des types de champs pour les champs personnalises d\'elements embarques...',
	'Updating favoriting namespace for Motion...' => 'Mise a jour des espaces de nom favoris pour Motion...',
	'Reinstall Motion Templates' => 'Reinstaller les gabarits Motion',
	'Motion Themes' => 'Themes Motion',
	'Themes for Motion template set' => 'Themes pour le jeu de gabarits Motion',
	'Motion' => 'Motion',
	'Post Type' => 'Type de note',
	'Photo' => 'Photo',
	'Embed Object' => 'Element externe',
	'MT JavaScript' => 'Javascript MT',
	'Motion MT JavaScript' => 'JavaScript Motion MT',
	'Motion JavaScript' => 'JavaScript Motion',
	'Entry Listing: Monthly' => 'Liste des notes par mois',
	'Entry Listing: Category' => 'Liste des notes par categorie',
	'Entry Listing: Author' => 'Liste des notes par auteur',
	'Entry Response' => 'Reponse a la note',
	'Profile View' => 'Vue du profil',
	'Profile Edit Form' => 'Formulaire de modification du profil',
	'Profile Error' => 'Erreur de profil',
	'Profile Feed' => 'Flux du profil',
	'Login Form' => 'Formulaire d\'identification',
	'Register Confirmation' => 'Confirmation d\'inscription',
	'Password Reset' => 'Reinitialisation du mot de passe',
	'New Password Form' => 'Nouveau formulaire de mot de passe', # Translate - New
	'User Profile' => 'Profil de l\'utilisateur',
	'Actions (Local)' => 'Actions (locales)',
	'Comment Detail' => 'Detail du Commentaire',
	'Single Entry' => 'Note simple',
	'Messaging' => 'Messagerie',
	'Form Field' => 'Champ de formulaire',
	'About Pages' => 'A propos des pages',
	'About Site' => 'A propos du site',
	'Gallery' => 'Galerie',
	'Main Column Actions' => 'Actions de la colonne principale',
	'Main Column Posting Form (All Media)' => 'Formulaire de publication (Tous medias) de la colonne principale',
	'Main Column Posting Form (Text Only, Like Twitter)' => 'Formulaire de publication (Texte uniquement, comme Twitter) de la colonne principale',
	'Main Column Registration' => 'Inscription depuis la colonne principale',
	'Fans' => 'Fans',
	'Popular Entries' => 'Notes populaires',
	'Elsewhere' => 'Ailleurs',
	'Following' => 'Suit',
	'Followers' => 'Suiveurs',
	'User Archives' => 'Archives de l\'utilisateur',
	'Blogroll' => 'Blogs preferes',
	'Feeds' => 'Flux',
	'Main Column Content' => 'Contenu de la colonne principale',
	'Main Index Widgets' => 'Widgets de l\'index principal',
	'Archive Widgets' => 'Widgets d\'archive',
	'Entry Widgets' => 'Widgets de notes',
	'Footer Widgets' => 'Widgets de pieds',
	'Default Widgets' => 'Widgets par defaut',
	'Profile Widgets' => 'Widgets de profils',

## plugins/Motion/lib/Motion/Search.pm
	'This module works with MT::App::Search.' => 'Ce module fonctionne avec MT::App::Search.',
	'Specify the blog_id of a blog that has Motion template set.' => 'Indique le blog_id d\'un blog ayant un jeu de gabarits Motion.',
	'Error loading template: [_1]' => 'Erreur lors du chargement d\'un gabarit : [_1]',

## plugins/Motion/tmpl/edit_linkpost.tmpl

## plugins/Motion/tmpl/edit_videopost.tmpl
	'Embed code' => 'Code externe',

## plugins/Motion/templates/Motion/widget_search.mtml

## plugins/Motion/templates/Motion/banner_header.mtml
	'Home' => 'Accueil',

## plugins/Motion/templates/Motion/widget_recent_comments.mtml
	'<p>[_3]...</p><div class="comment-attribution">[_4]<br /><a href="[_1]">[_2]</a></div>' => '<p>[_3]...</p><div class="comment-attribution">[_4]<br /><a href="[_1]">[_2]</a></div>',

## plugins/Motion/templates/Motion/widget_popular_entries.mtml
	'posted by <a href="[_1]">[_2]</a> on [_3]' => 'redige par <a href="[_1]">[_2]</a> le [_3]',

## plugins/Motion/templates/Motion/widget_followers.mtml
	'Not being followed' => 'N\'est pas suivi',

## plugins/Motion/templates/Motion/entry_response.mtml

## plugins/Motion/templates/Motion/comment_response.mtml
	'<strong>Bummer....</strong> [_1]' => '<strong>Zut...</strong> [_1]',

## plugins/Motion/templates/Motion/widget_about_ssite.mtml
	'About' => 'A propos de',
	'The Motion Template Set is a great example of the type of site you can build with Movable Type.' => 'Le jeu de gabarits Motion est un bel exemple du type de site que vous pouvez concevoir avec Movable Type.',

## plugins/Motion/templates/Motion/comment_detail.mtml

## plugins/Motion/templates/Motion/register.mtml
	'Enter a password for yourself.' => 'Choisissez un mot de passe.',
	'The URL of your website.' => 'L\'URL de votre site.',

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
	'Note: This post is being held for approval by the site owner.' => 'Note : cette note est en attente d\'acceptation par le proprietaire du site.',
	'<a href="[_1]">Most recent comment by <strong>[_2]</strong> on [_3]</a>' => '<a href="[_1]">Commentaires les plus recents par <strong>[_2]</strong> sur [_3]</a>',
	'Posted to [_1]' => 'Publie sur [_1]',
	'[_1] posted [_2] on [_3]' => '[_1] a publie [_2] sur [_3]',

## plugins/Motion/templates/Motion/widget_tag_cloud.mtml

## plugins/Motion/templates/Motion/password_reset.mtml
	'Reset Password' => 'Initialiser le mot de passe',

## plugins/Motion/templates/Motion/form_field.mtml
	'(Optional)' => '(Optionnel)',

## plugins/Motion/templates/Motion/javascript.mtml
	'Please select a file to post.' => 'Veuillez selectionner un fichier a publier.',
	'You selected an unsupported file type.' => 'Vous avez selectionne un fichier de type non supporte.',

## plugins/Motion/templates/Motion/trackbacks.mtml

## plugins/Motion/templates/Motion/archive_index.mtml

## plugins/Motion/templates/Motion/new_password.mtml

## plugins/Motion/templates/Motion/entry_listing_author.mtml
	'Archived Entries from [_1]' => 'Notes archives de [_1]',
	'Recent Entries from [_1]' => 'Notes recentes de [_1]',

## plugins/Motion/templates/Motion/widget_categories.mtml

## plugins/Motion/templates/Motion/dynamic_error.mtml

## plugins/Motion/templates/Motion/widget_elsewhere.mtml
	'Are you sure you want to remove the [_1] from your profile?' => 'Etes-vous sur de vouloir retirer [_1] de votre profil ?',
	'Your user name or ID is required.' => 'Votre nom d\'utilisateur ou ID est requis.',
	'Add a Service' => 'Ajouter un service',
	'Service' => 'Service',
	'Select a service...' => 'Selectionnez un service...',
	'Your Other Profiles' => 'Vos autres profils',
	'Find [_1] Elsewhere' => 'Trouver [_1] ailleurs',
	'Remove service' => 'Retirer le service',

## plugins/Motion/templates/Motion/widget_main_column_registration.mtml
	'<a href="javascript:void(0)" onclick="[_1]">Sign In</a>' => '<a href="javascript:void(0)" onclick="[_1]">Identifiez-vous</a>', # Translate - New
	'Not a member? <a href="[_1]">Register</a>' => 'Pas encore membre? <a href="[_1]">Enregistrez-vous</a>',
	'(or <a href="javascript:void(0)" onclick="[_1]">Sign In</a>)' => '(ou <a href="javascript:void(0)" onclick="[_1]">Identifiez-vous</a>)',
	'No posting privileges.' => 'Pas les droits necessaires pour publier.',

## plugins/Motion/templates/Motion/widget_following.mtml
	'Not following anyone' => 'Ne suit personne',

## plugins/Motion/templates/Motion/widget_main_column_posting_form_text.mtml
	'QuickPost' => 'QuickPost',
	'Content' => 'Contenu',
	'more options' => 'Plus d\'options',
	'Post' => 'Publier',

## plugins/Motion/templates/Motion/comment_preview.mtml

## plugins/Motion/templates/Motion/actions_local.mtml
	'[_1] commented on [_2]' => '[_1] a commente sur [_2]',
	'[_1] favorited [_2]' => '[_1] apprecie [_2]', # Translate - New
	'No recent actions.' => 'Plus d\'actions recentes.',

## plugins/Motion/templates/Motion/main_index.mtml

## plugins/Motion/templates/Motion/page.mtml

## plugins/Motion/templates/Motion/entry_summary.mtml

## plugins/Motion/templates/Motion/widget_main_column_posting_form.mtml
	'Text post' => 'Texte',
	'Photo post' => 'Photo',
	'Link post' => 'Lien',
	'Embed post' => 'Element embarque',
	'Audio post' => 'Son',
	'URL of web page' => 'URL d\'une page Web',
	'Select photo file' => 'Selectionner une image ou photo',
	'Only GIF, JPEG and PNG image files are supported.' => 'Les types de fichiers supportes sont GIF, JPEG, et PNG.',
	'Select audio file' => 'Selectionner un fichier sonore',
	'Only MP3 audio files are supported.' => 'Le fichier doit etre au format MP3.',
	'Paste embed code' => 'Copiez le code de l\'element embarque',

## plugins/Motion/templates/Motion/widget_monthly_archives.mtml

## plugins/Motion/templates/Motion/profile_feed.mtml
	'Posted [_1] to [_2]' => 'A poste [_1] sur [_2]',
	'Commented on [_1] in [_2]' => 'A commente sur [_1] dans [_2]',
	'followed [_1]' => 'a suivi [_1]',

## plugins/Motion/templates/Motion/widget_user_archives.mtml
	'Recenty entries from [_1]' => 'Notes recentes de [_1]',

## plugins/Motion/templates/Motion/entry_listing_category.mtml

## plugins/Motion/templates/Motion/widget_signin.mtml
	'You are signed in as <a href="[_1]">[_2]</a>' => 'Vous etes identifie(e) comme etant <a href="[_1]">[_2]</a>',
	'You are signed in as [_1]' => 'Vous etes identifie(e) comme etant [_1]',
	'Edit profile' => 'Editer le profil',
	'Sign out' => 'deconnexion',

## plugins/Motion/templates/Motion/widget_fans.mtml

## plugins/Motion/templates/Motion/entry_listing_monthly.mtml

## plugins/Motion/templates/Motion/register_confirmation.mtml
	'Authentication Email Sent' => 'Email d\'authentification envoye',
	'Profile Created' => 'Profil cree',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Retourner a la page initiale</a>',

## plugins/Motion/templates/Motion/entry.mtml

## plugins/Motion/templates/Motion/widget_gallery.mtml
	'Recent Photos' => 'Photos recentes',

## plugins/Motion/templates/Motion/sidebar.mtml

## plugins/Motion/templates/Motion/widget_recent_entries.mtml
	'posted by [_1] on [_2]' => 'publie par [_1] sur [_2]',

## plugins/Motion/templates/Motion/banner_footer.mtml

## plugins/Motion/templates/Motion/widget_main_column_actions.mtml

## plugins/Motion/templates/Motion/comments.mtml
	'what will you say?' => 'que direz-vous ?',
	'[_1] [_2]in reply to comment from [_3][_4]' => '[_1] [_2] en reponse au commentaire de [_3][_4]',
	'Write a comment...' => 'Redigez un commentaire ...',

## plugins/Motion/templates/Motion/search_results.mtml

## plugins/Motion/templates/Motion/login_form.mtml
	'Forgot?' => 'Oublie ?',

## plugins/Motion/templates/Motion/widget_members.mtml

## plugins/Motion/templates/Motion/user_profile.mtml
	'Recent Actions from [_1]' => 'Actions recentes de [_1]',
	'Responses to Comments from [_1]' => 'Reponses aux commentaires de [_1]',
	'You are following [_1].' => 'Vous suivez [_1]',
	'Unfollow' => 'Ne plus suivre',
	'Follow' => 'Suivre',
	'Profile Data' => 'Donnees du profil',
	'More Entries by [_1]' => 'Plus de notes par [_1]',
	'Recent Actions' => 'Actions recentes',
	'_PROFILE_COMMENT_LENGTH' => '10',
	'Comment Threads' => 'Fils de discussion',
	'[_1] commented on ' => '[_1] a commente sur',
	'No responses to comments.' => 'Pas de reponse aux commentaires.',

## plugins/Motion/templates/Motion/actions.mtml
	'[_1] is now following [_2]' => '[_1] suit desormais [_2]',
	'[_1] favorited [_2] on [_3]' => '[_1] a ajoute [_2] de [_3] dans ses favoris',

## plugins/Motion/templates/Motion/motion_js.mtml
	'Add userpic' => 'Ajouter un avatar',

## plugins/Motion/templates/Motion/widget_powered_by.mtml

## plugins/Motion/templates/Motion/user_profile_edit.mtml
	'Go <a href="[_1]">back to the previous page</a> or <a href="[_2]">view your profile</a>.' => 'Retourner a  <a href="[_1]">la page precedente</a> ou <a href="[_2]">voir votre profil</a>.',
	'Change' => 'Modifier',

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm

## plugins/FacebookCommenters/plugin.pl
	'Provides commenter registration through Facebook Connect.' => 'Permet l\'enregistrement des auteurs de commentaires via Facebook Connect',
	'Set up Facebook Commenters plugin' => 'Configurer le plugin Facebook Commenters',
	'{*actor*} commented on the blog post <a href="{*post_url*}">{*post_title*}</a>.' => '{*actor*} a commente la note <a href="{*post_url*}">{*post_title*}</a>.',
	'Could not register story template with Facebook: [_1]. Did you enter the correct application secret?' => 'Impossible d\'enregistrer le modele d\'histoire avec Facebook : [_1]. Avez-vous correctement entre le secret de l\'application ?',
	'Could not register story template with Facebook: [_1]' => 'Impossible d\'enregistrer le modele d\'histoire avec Facebook : [_1].',
	'Facebook' => 'Facebook', # Translate - Case

## plugins/FacebookCommenters/tmpl/blog_config_template.tmpl
	'Facebook Application Key' => 'Cle Application Facebook',
	'The key for the Facebook application associated with your blog.' => 'La cle pour l\'application Facebook associee a votre blog.',
	'Edit Facebook App' => 'Editer l\'application Facebook',
	'Create Facebook App' => 'Creer une application Facebook', # Translate - New
	'Facebook Application Secret' => 'Secret Application Facebook',
	'The secret for the Facebook application associated with your blog.' => 'Le secret pour l\'application Facebook associee a votre blog.',

## plugins/mixiComment/mixiComment.pl
	'Allows commenters to sign in to Movable Type 4 using their own mixi username and password via OpenID.' => 'Permet aux auteurs de commentaires de s\'identifier sur Movable Type en utilisant leur nom d\'utilisateur mixi via OpenID.',
	'Sign in using your mixi ID' => 'S\'identifier en utilisant votre identifiant mixi',
	'Click the button to sign in using your mixi ID' => 'Cliquez sur le bouton pour vous identifier en utilisant votre identifiant mixi.',
	'mixi' => 'mixi',

## plugins/mixiComment/lib/mixiComment/App.pm
	'mixi reported that you failed to login.  Try again.' => 'mixi n\'a pas reussi a vous identifier. Veuillez reessayer.',

## plugins/mixiComment/tmpl/config.tmpl
	'A mixi ID has already been registered in this blog.  If you want to change the mixi ID for the blog, <a href="[_1]">click here</a> to sign in using your mixi account.  If you want all of the mixi users to comment to your blog (not only your my mixi users), click the reset button to remove the setting.' => 'Un ID mixi est deja enregistre sur ce blog. Si vous souhaitez modifier l\'ID mixi, <a href="[_1]">cliquez ici</a> pour vous identifier en utilisant votre compte mixi. Si vous souhaitez permettre a tous les utilisateurs mixi de commenter sur votre blog (et pas uniquement vos utilisateurs mixi), cliquez sur le bouton de reinitialisation pour retirer les parametres.',
	'If you want to restrict comments only from your my mixi users, <a href="[_1]">click here</a> to sign in using your mixi account.' => 'Si vous souhaitez restreindre les commentaires a uniquement vos utilisateurs mixi, <a href="[_1]">cliquez ici</a> pour vous identifier en utilisant votre compte mixi.',

## plugins/ActionStreams/blog_tmpl/sidebar.mtml

## plugins/ActionStreams/blog_tmpl/main_index.mtml

## plugins/ActionStreams/blog_tmpl/actions.mtml
	'Recent Actions' => 'Actions recentes',

## plugins/ActionStreams/blog_tmpl/archive.mtml

## plugins/ActionStreams/blog_tmpl/banner_footer.mtml

## plugins/ActionStreams/blog_tmpl/elsewhere.mtml
	'Find [_1] Elsewhere' => 'Trouver [_1] ailleurs',

## plugins/ActionStreams/streams.yaml
	'Currently Playing' => 'En train de jouer',
	'The games in your collection you\'re currently playing' => 'Les jeux de votre collection auxquels vous jouez en ce moment',
	'Comments you have made on the web' => 'Commentaires que vous avez ecrits sur le web',
	'Colors' => 'Couleurs',
	'Colors you saved' => 'Couleurs que vous avez sauvegardees',
	'Palettes' => 'Palettes',
	'Palettes you saved' => 'Palettes que vous avez sauvegardees',
	'Patterns' => 'Motifs',
	'Patterns you saved' => 'Motifs que vous avez sauvegardes',
	'Favorite Palettes' => 'Palettes favorites',
	'Palettes you saved as favorites' => 'Palettes que vous avez sauvegardees comme favorites',
	'Reviews' => 'Critiques',
	'Your wine reviews' => 'Vos critiques de vins',
	'Cellar' => 'Cellier',
	'Wines you own' => 'Vins que vous possedez',
	'Shopping List' => 'Liste de courses',
	'Wines you want to buy' => 'Vins que vous voulez acheter',
	'Links' => 'Liens',
	'Your public links' => 'Vos liens publics',
	'Dugg' => 'Dugg',
	'Links you dugg' => 'Liens postes sur Digg',
	'Submissions' => 'Soumissions',
	'Links you submitted' => 'Liens que vous avez soumis',
	'Found' => 'Trouve',
	'Photos you found' => 'Photos que vous avez trouvees',
	'Favorites' => 'Favorites',
	'Photos you marked as favorites' => 'Photos que vous avez marquees comme favorites',
	'Photos' => 'Photos',
	'Photos you posted' => 'Photos que vous avez postees',
	'Likes' => 'Likes',
	'Things from your friends that you "like"' => 'Infos de vos amis que vous avez aimees',
	'Leaderboard scores' => 'Scores',
	'Your high scores in games with leaderboards' => 'Vos meilleurs scores dans les jeux avec championnat',
	'Posts' => 'Notes',
	'Blog posts about your search term' => 'Notes du blog a propos de votre recherche',
	'Stories' => 'Articles',
	'News Stories matching your search' => 'Nouveaux articles correspondant a votre recherche',
	'To read' => 'A lire',
	'Books on your "to-read" shelf' => 'Livres dans votre liste "a lire"',
	'Reading' => 'En cours de lecture',
	'Books on your "currently-reading" shelf' => 'Livres dans votre liste "en cours de lecture"',
	'Read' => 'Lus',
	'Books on your "read" shelf' => 'Livres dans votre liste "lus"',
	'Shared' => 'Partages',
	'Your shared items' => 'Vos elemens partages',
	'Deliveries' => 'Livres',
	'Icon sets you were delivered' => 'Sets d\'icones livrees',
	'Notices' => 'Notices',
	'Notices you posted' => 'Notices postees',
	'Intas' => 'Intas',
	'Links you saved' => 'Liens sauvegardes',
	'Photos you posted that were approved' => 'Photos postees et approuvees',
	'Recent events' => 'Evenements recents',
	'Events from your recent events feed' => 'Evenements de votre flux des evenements recents',
	'Apps you use' => 'Applications que vous utilisez',
	'The applications you saved as ones you use' => 'Les applications que vous avez marquees comme utilisees',
	'Videos you saved as watched' => 'Videos que vous avez saugardees comme regardees',
	'Jaikus' => 'Jaikus',
	'Jaikus you posted' => 'Jaikus que vous avez postes',
	'Games you saved as favorites' => 'Jeux que vous avez sauvegardes comme favoris',
	'Achievements' => 'Realisations',
	'Achievements you won' => 'Realisations que vous avez atteintes',
	'Tracks' => 'Morceaux',
	'Songs you recently listened to (High spam potential!)' => 'Chansons que vous avez ecoutees recemment (spam potentiel!)',
	'Loved Tracks' => 'Morceaux aimes',
	'Songs you marked as "loved"' => 'Chansons que vous avez marquees comme "aimees"',
	'Journal Entries' => 'Notes du journal',
	'Your recent journal entries' => 'Les notes recentes de votre journal',
	'Events' => 'evenements',
	'The events you said you\'ll be attending' => 'Les evenements auquels vous allez assister',
	'Your public posts to your journal' => 'Les notes publiques sur votre journal',
	'Queue' => 'Liste d\'attente',
	'Movies you added to your rental queue' => 'Films que vous avez ajoutes a votre liste d\'attente',
	'Recent Movies' => 'Films recents',
	'Recent Rental Activity' => 'Films empreintes recemment',
	'Kudos' => 'Kudos',
	'Kudos you have received' => 'Kudos que vous avez recus',
	'Favorite Songs' => 'Chansons favorites',
	'Songs you marked as favorites' => 'Chansons que vous avez marquees comme favorites',
	'Favorite Artists' => 'Artistes favoris',
	'Artists you marked as favorites' => 'Artistes que vous avez marques comme favoris',
	'Stations' => 'Stations',
	'Radio stations you added' => 'Stations de radio que vous avez ajoutees',
	'List' => 'Liste',
	'Things you put in your list' => 'Choses que vous mettez sur votre liste',
	'Notes' => 'Notes',
	'Your public notes' => 'Vos notes publiques',
	'Comments you posted' => 'Commentaires que vous avez postes',
	'Articles you submitted' => 'Articles que vous avez soumis',
	'Articles you liked (your votes must be public)' => 'Articles que vous avez aimes (vos votes doivent etre publiques)',
	'Dislikes' => 'Pas aimes',
	'Articles you disliked (your votes must be public)' => 'Articles que vous n\'avez pas aimes (vos votes doivent etre publiques)',
	'Slideshows you saved as favorites' => 'Diaparamas que vous avez marques comme favoris',
	'Slideshows' => 'Diaporamas',
	'Slideshows you posted' => 'Diaporamas que vous avez postes',
	'Your achievements for achievement-enabled games' => 'Vos resultats pour les jeux avec des objectifs',
	'Stuff' => 'Trucs',
	'Things you posted' => 'Choses que vous avez postees',
	'Tweets' => 'Tweets',
	'Your public tweets' => 'Vos tweets publiques',
	'Public tweets you saved as favorites' => 'Tweets publiques que vous avez sauvegardes comme favoris',
	'Tweets about your search term' => 'Tweets contenant votre terme de recherche',
	'Saved' => 'Sauvegardes',
	'Things you saved as favorites' => 'Choses que vous avez sauvegardees comme favorites',
	'Events you are watching or attending' => 'Evenements que vous regardez ou auxquels vous assistez',
	'Videos you posted' => 'Videos que vous avez postees',
	'Videos you liked' => 'Videos que vous avez aimees',
	'Public assets you saved as favorites' => 'Assets publiques que vous avez sauvegardees comme favorites',
	'Your public photos in your Vox library' => 'Vos photos publiques dans votre librairie Vox',
	'Your public posts to your Vox' => 'Vos notes publiques dans votre Vox',
	'The posts available from the website\'s feed' => 'Les notes publiques disponibles dans le flux du site',
	'Wists' => 'Wists',
	'Stuff you saved' => 'Choses que vous avez sauvegardees',
	'Gamerscore' => 'Score du joueur',
	'Notes when your gamerscore passes an even number' => 'Notes quand votre score depasse un nombre pair',
	'Places you reviewed' => 'Places que vous avez critiquees',
	'Videos you saved as favorites' => 'Videos que vous avez sauvegardees comme favorites',

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
	'Sharing ID' => 'ID partage',
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
	'Social Network URL' => 'URL du reseau social',
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
	'Blank should be replaced by positive sign (+).' => 'Les espaces doivent etre remplaces par un signe plus (+)',
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
	'Website' => 'Website',
	'Xbox Live\'' => 'Xbox Live\'',
	'Gamertag' => 'Gamertag',
	'Yahoo! Messenger\'' => 'Yahoo! Messenger\'',
	'Yelp' => 'Yelp',
	'YouTube' => 'YouTube',
	'Zooomr' => 'Zooomr',

## plugins/ActionStreams/config.yaml
	'Manages authors\' accounts and actions on sites elsewhere around the web' => 'Gerer les comptes et les actions des utilisatreurs sur les sites ailleurs sur le web',
	'Are you sure you want to hide EVERY event in EVERY action stream?' => 'Etes-vous sur de vouloir masquer TOUS les evenement dans TOUS les flux d\'actions ?',
	'Are you sure you want to show EVERY event in EVERY action stream?' => 'Etes-vous sur de vouloir afficher TOUS les evenement dans TOUS les flux d\'actions ?',
	'Deleted events that are still available from the remote service will be added back in the next scan. Only events that are no longer available from your profile will remain deleted. Are you sure you want to delete the selected event(s)?' => 'Les evenements supprimes qui sont toujours disponibles sur le service distant seront ajoutes a nouveau dans le prochain scan. Seuls les evenements qui ne sont plus disponibles dans votre profil resteront supprimes. Etes-vous sur de vouloir supprimer les evenements selectionnes?',
	'Hide All' => 'Cacher tout',
	'Show All' => 'Tout afficher',
	'Poll for new events' => 'Emplacement pour les nouveaux evenements',
	'Update Events' => 'Mettre a jour les evenements',
	'Action Stream' => 'Action Stream',
	'Main Index (Recent Actions)' => 'Index principal (Actions recentes)',
	'Action Archive' => 'Archive des actions',
	'Feed - Recent Activity' => 'Flux - Activite recente',
	'Find Authors Elsewhere' => 'Trouver les auteurs ailleurs',
	'Enabling default action streams for selected profiles...' => 'Activer les flux d\'actions par defaut des profils selectionnes...',

## plugins/ActionStreams/lib/ActionStreams/Upgrade.pm
	'Updating classification of [_1] [_2] actions...' => 'Mise a jour de la classification des actions [_1] [_2]...',
	'Renaming "[_1]" data of [_2] [_3] actions...' => 'Renommage "[_1]" des donnees des actions [_1] [_2]...',

## plugins/ActionStreams/lib/ActionStreams/Worker.pm
	'No such author with ID [_1]' => 'Aucun auteur n\'a ete trouve avec l\'ID [_1]',

## plugins/ActionStreams/lib/ActionStreams/Plugin.pm
	'Other Profiles' => 'Autres profils',
	'Profiles' => 'Profiles',
	'Actions from the service [_1]' => 'Actions pour le service [_1]',
	'Actions that are shown' => 'Actions affichees',
	'Actions that are hidden' => 'Actions masquees',
	'No such event [_1]' => 'Aucun evenement [_1] trouve',
	'[_1] Profile' => 'Profil [_1]',

## plugins/ActionStreams/lib/ActionStreams/Tags.pm
	'No user [_1]' => 'Aucun utilisateur [_1]',

## plugins/ActionStreams/lib/ActionStreams/Event.pm
	'[_1] updating [_2] events for [_3]' => '[_1] mets a jour [_2] evenements pour [_3]',
	'Error updating events for [_1]\'s [_2] stream (type [_3] ident [_4]): [_5]' => 'Erreur lors de la mise a jour des evenements pour le flux [_2] de [_1] (type [_3] ident [_4]) : [_5]',
	'Could not load class [_1] for stream [_2] [_3]: [_4]' => 'Impossible de charger la classe [_1] pour le flux [_2] [_3] : [_4]',
	'No URL to fetch for [_1] results' => 'Aucune URL a joindre pour les resultats [_1]', # Translate - New
	'Could not fetch [_1]: [_2]' => 'Impossible de joindre [_1] : [_2]', # Translate - New
	'Aborted fetching [_1]: [_2]' => 'Operation abandonnee [_1] : [_2]', # Translate - New

## plugins/ActionStreams/tmpl/dialog_edit_profile.tmpl
	'Your user name or ID is required.' => 'Votre nom d\'utilisateur ou ID est requis.',
	'Edit a profile on a social networking or instant messaging service.' => 'Editer un profil sur un service de reseau social ou de messagerie instantanee.',
	'Service' => 'Service',
	'Enter your account on the selected service.' => 'Entrez votre compte sur le service selectionne.',
	'For example:' => 'Par exemple :',
	'Action Streams' => 'Flux d\'actions',
	'Select the action streams to collect from the selected service.' => 'Selectionner le flux d\'action pour collecter les donnees depuis les services selectionnees.',
	'No streams are available for this service.' => 'Aucun flux n\'est disponible pour ce service.',

## plugins/ActionStreams/tmpl/other_profiles.tmpl
	'The selected profile was added.' => 'Le profil selectionne a ete ajoute.',
	'The selected profiles were removed.' => 'Les profils selectionnes ont ete retires.',
	'The selected profiles were scanned for updates.' => 'La presence de nouveaux evenements sur les profils selectionnes a ete effectuee.',
	'The changes to the profile have been saved.' => 'Les modifications sur le profil ont ete enregistrees.',
	'Add Profile' => 'Ajouter un profil',
	'profile' => 'profil',
	'profiles' => 'profiles',
	'Delete selected profiles (x)' => 'Supprimer les profils selectionnes (x)',
	'to update' => 'a mettre a jour',
	'Scan now for new actions' => 'Verifier la presence de nouveaux evenements',
	'Update Now' => 'Mettre a jour maintenant',
	'No profiles were found.' => 'Aucun profil n\'a ete trouve.',
	'external_link_target' => 'external_link_target',
	'View Profile' => 'Voir le profil',

## plugins/ActionStreams/tmpl/dialog_add_profile.tmpl
	'Add a profile on a social networking or instant messaging service.' => 'Ajouter un profil sur un service de reseau social ou de messagerie instantanee.',
	'Select a service where you already have an account.' => 'Selectionnez un service ou vous avez deja un compte.',
	'Add Profile (s)' => 'Ajouter le Profil (s)', # Translate - New

## plugins/ActionStreams/tmpl/list_profileevent.tmpl
	'The selected events were deleted.' => 'Les evenements selectionnes ont ete supprimes.',
	'The selected events were hidden.' => 'Les evenements selectionnes ont ete masques.',
	'The selected events were shown.' => 'Les evenements selectionnes ont ete affiches.',
	'All action stream events were hidden.' => 'Tous les evenements du flux d\'activite ont ete masques.',
	'All action stream events were shown.' => 'Tous les evenements du flux d\'activite ont ete affiches.',
	'event' => 'evenement',
	'events' => 'evenements',
	'Hide selected events (h)' => 'Masquer les evenements selectionnes (h)',
	'Hide' => 'Masquer',
	'Show selected events (h)' => 'Afficher les evenements selectionnes (h)',
	'Show' => 'Afficher',
	'All stream actions' => 'Tous les flux d\'actions',
	'Show only actions where' => 'Afficher uniquement les actions ou',
	'service' => 'le service est',
	'visibility' => 'la visibilite est',
	'hidden' => 'masque',
	'shown' => 'affiche',
	'No events could be found.' => 'Aucun evenement n\'a ete trouve.',
	'Event' => 'Evenement',
	'Shown' => 'Affiche',
	'Hidden' => 'Masque',
	'View action link' => 'Voir le lien de l\'action',

## plugins/ActionStreams/tmpl/widget_recent.mtml
	'Your Recent Actions' => 'Votre activite recente',
	'blog this' => 'bloguer ceci',

## plugins/ActionStreams/tmpl/blog_config_template.tmpl
	'Rebuild Indexes' => 'Republier les index',
	'If selected, this blog\'s indexes will be rebuilt when new action stream events are discovered.' => 'Si selectionner, les index des blogs seront republies lorsque de nouveaux evenements du flux d\'activite seront decouverts.',
	'Enable rebuilding' => 'Activer la republication',

);

## New words: 91

1;
