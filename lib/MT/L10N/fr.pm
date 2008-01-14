# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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

## php/lib/function.mtvar.php
	'You used a [_1] tag without a valid name attribute.' => 'Vous avez utilisé un tag [_1] sans un attribut de nom valide',
	'\'[_1]\' is not a valid function for a hash.' => '\'[_1]\' n\'est pas une fonction valide pour un hash',
	'\'[_1]\' is not a valid function for an array.' => '\'[_1]\' n\'est pas une fonction valide pour un tableau',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] est illégal.',

## php/lib/archive_lib.php
	'Page' => 'Page',
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

## php/lib/block.mtsethashvar.php

## php/lib/block.mtif.php

## php/lib/function.mtremotesigninlink.php
	'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'L\'authentification TypeKey n\'est pas activée sur ce blog.  MTRemoteSignInLink ne peut être utilisé.',

## php/lib/block.mtauthorhaspage.php
	'No author available' => 'Il n\'a pas d\'auteurs disponibles',

## php/lib/block.mtauthorhasentry.php

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Saisissez les caractères que vous voyez dans l\'image ci-dessus.',

## php/lib/function.mtsetvar.php
	'\'[_1]\' is not a hash.' => '\'[_1]\' n\'est pas un hash',
	'Invalid index.' => 'Index invalide',
	'\'[_1]\' is not an array.' => '\'[_1]\' n\'est pas un tableau',
	'\'[_1]\' is not a valid function.' => '\'[_1]\' n\'est pas une fonction valide',

## php/lib/block.mtassets.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" doit être utilisé en combinaison avec le namespace.',

## php/lib/block.mtsetvarblock.php

## php/lib/block.mtentries.php

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'userpic-[_1]-%wx%h%x',

## php/lib/function.mtauthordisplayname.php

## php/lib/function.mtentryclasslabel.php
	'page' => 'Page',
	'entry' => 'note',
	'Entry' => 'Note',

## default_templates/notify-entry.mtml
	'A new [lc,_3] entitled \'[_1]\' has been published to [_2].' => 'Une nouvelle [lc,_3] intitulée \'[_1]\' a été publiée sur [_2].',
	'View entry:' => 'Voir la note :',
	'View page:' => 'Voir la page :',
	'[_1] Title: [_2]' => 'Titre du [_1] : [_2]',
	'Publish Date: [_1]' => 'Date de publication : [_1]',
	'Message from Sender:' => 'Message de l\'expéditeur :',
	'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'Vous recevez cet email car vous avez demandé à recevoir les notifications de nouveau contenu sur [_1], ou l\'auteur de la note a pensé que vous seriez intéressé. Si vous ne souhaitez plus recevoir ces emails, merci de contacter la personne suivante:',

## default_templates/main_index.mtml
	'Header' => 'Entête',
	'Entry Summary' => 'Résumé de la note',
	'Archives' => 'Archives',

## default_templates/page.mtml
	'Page Detail' => 'Détails de la page',
	'TrackBacks' => 'Trackbacks',
	'Comments' => 'Commentaires',

## default_templates/entry_summary.mtml
	'Entry Metadata' => 'Metadonnées de la note',
	'Tags' => 'Tags',
	'Continue reading <a rel="bookmark" href="[_1]">[_2]</a>.' => 'Lire la suite de <a rel="bookmark" href="[_1]">[_2]</a>.',

## default_templates/comment_response.mtml
	'Comment Submitted' => 'Commentaire envoyé',
	'Confirmation...' => 'Confirmation...',
	'Your comment has been submitted!' => 'Votre commentaire a été envoyé !',
	'Comment Pending' => 'Commentaires en attente',
	'Thank you for commenting.' => 'Merci de votre commentaire.',
	'Your comment has been received and held for approval by the blog owner.' => 'Votre commentaire a été reçu et est en attente de validation par le propriétaire de ce blog.',
	'Comment Submission Error' => 'Erreur d\'envoi du commentaire',
	'Your comment submission failed for the following reasons:' => 'L\'envoi de votre commentaire a échoué pour les raisons suivantes :',
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

## default_templates/entry_detail.mtml
	'Categories' => 'Catégories',

## default_templates/verify-subscribe.mtml
	'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Merci d\'avoir pour votre inscription aux mises à jours [_1]. Cliquez sur le lien ci-dessous pour confirmer cette inscription :',
	'If the link is not clickable, just copy and paste it into your browser.' => 'Si le lien n\'est pas cliquable, faites simplement un copier-coller dans votre navigateur.',

## default_templates/new-ping.mtml
	'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Un TrackBack non-approuvé a été déposé sur votre blog [_1], pour la note #[_2] ([_3]). Vous devez approuver ce TrackBack pour qu\'il apparaisse sur votre site.',
	'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Un TrackBack non-approuvé a été déposé sur votre blog [_1], pour la catégorie #[_2] ([_3]). Vous devez approuver ce TrackBack pour qu\'il apparaisse sur votre site.',
	'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Un nouveau TrackBack a été déposé sur votre blog [_1], pour la note #[_2] ([_3]).',
	'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'Un nouveau TrackBack a été déposé sur votre blog [_1], pour la catégorie #[_2] ([_3]).',
	'Excerpt' => 'Extrait',
	'URL' => 'URL',
	'Title' => 'Titre',
	'Blog' => 'Blog',
	'IP address' => 'Adresse IP',
	'Approve TrackBack' => 'Approuver le TrackBack',
	'View TrackBack' => 'Voir le TrackBack',
	'Report TrackBack as spam' => 'Notifier le TrackBack comme spam',
	'Edit TrackBack' => 'Éditer les  trackbacks',

## default_templates/comment_detail.mtml
	'[_1] [_2] said:' => '[_1] [_2] a dit :',
	'<a href="[_1]" title="Permalink to this comment">[_2]</a>' => '<a href="[_1]" title="Lien permanent vers ce commentaire">[_2]</a>',

## default_templates/comment_form.mtml
	'Leave a comment' => 'Laisser un commentaire',
	'Name' => 'Nom',
	'Email Address' => 'Adresse e-mail',
	'Remember personal info?' => 'Mémoriser mes infos personnelles?',
	'(You may use HTML tags for style)' => '(Vous pouvez utiliser des balises HTML pour le style)',
	'Preview' => 'Aperçu',
	'Submit' => 'Envoyer',
	'Cancel' => 'Annuler',

## default_templates/comment_throttle.mtml
	'If this was a mistake, you can unblock the IP address and allow the visitor to add it again by logging in to your Movable Type installation, going to Blog Config - IP Banning, and deleting the IP address [_1] from the list of banned addresses.' => 'Si c\'était une erreur, vous pouvez débloquer l\'adresse IP et autoriser le visiteur à nouveau en vous identifiant dans Movable Type, dans Configuration du Blog - Blocage IP, et en effaçant l\'adresse IP [_1] de la liste des adresses bannies.',
	'A visitor to your blog [_1] has automatically been banned by adding more than the allowed number of comments in the last [_2] seconds.' => 'Un visiteur de votre blog [_1] a été automatiquement banni après avoir publié une quantité de commentaires supérieure à la limite établie au cours des [_2] secondes.',
	'This has been done to prevent a malicious script from overwhelming your weblog with comments. The banned IP address is' => 'Cette opération est destinée à empêcher la publication automatisée de commentaires par des scripts. L\'adresse IP bannie est',

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

## default_templates/entry_listing.mtml
	'[_1] Archives' => 'Archives [_1]',
	'Recently in <em>[_1]</em> Category' => 'Récemment dans la catégorie <em>[_1]</em>',
	'Recently by <em>[_1]</em>' => 'Récemment par <em>[_1]</em>',
	'Main Index' => 'Index principal',

## default_templates/footer.mtml
	'Sidebar' => 'Colonne latérale',
	'_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.org/"><$MTProductName$></a>',
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Ce blog possède une licence <a href="[_1]">Creative Commons</a>.',

## default_templates/tags.mtml

## default_templates/entry_metadata.mtml
	'By [_1] on [_2]' => 'Par [_1] le [_2]',
	'Permalink' => 'Lien permanent',
	'Comments ([_1])' => 'Commentaires ([_1])',
	'TrackBacks ([_1])' => 'Trackbacks ([_1])',

## default_templates/entry.mtml
	'Entry Detail' => 'Détails de la note',

## default_templates/recover-password.mtml
	'_USAGE_FORGOT_PASSWORD_1' => 'Vous avez demandé à récupérer votre mot de passe Movable Type. Votre mot de passe a été changé au niveau du système ; le nouveau mot de passe est le suivant:',
	'_USAGE_FORGOT_PASSWORD_2' => 'Ce nouveau mot de passe devrait vous permettre d\'ouvrir une session Movable Type. Vous pourrez changer ce mot de passe une fois la session ouverte.',
	'Mail Footer' => 'Pied des mails',

## default_templates/javascript.mtml
	'Thanks for signing in,' => 'Merci de vous être identifié,',
	'. Now you can comment.' => '. Maintenant vous pouvez commenter.',
	'sign out' => 'déconnexion',
	'You do not have permission to comment on this blog.' => 'Vous n\'avez pas la permission de commenter sur ce blog.',
	'Sign in' => 'Identification',
	' to comment on this entry.' => ' pour commenter cette note.',
	' to comment on this entry,' => ' pour commenter cette note,',
	'or ' => 'ou ',
	'comment anonymously.' => 'commentez anonymement.',

## default_templates/rss.mtml
	'Copyright [_1]' => 'Copyright [_1]',

## default_templates/archive_index.mtml
	'Monthly Archives' => 'Archives mensuelles',
	'Author Archives' => 'Archives par auteurs',
	'Category Monthly Archives' => 'Archives par catégories et mois',
	'Author Monthly Archives' => 'Archives par auteurs et mois',

## default_templates/trackbacks.mtml
	'[_1] TrackBacks' => '[_1] trackbacks',
	'Listed below are links to blogs that reference this entry: <a href="[_1]">[_2]</a>.' => 'Voici la liste des liens vers les blogs faisant référence à cette note : <a href="[_1]">[_2]</a>.',
	'TrackBack URL for this entry: <span id="trackbacks-link">[_1]</span>' => 'URL de trackback pour cette note : <span id="trackbacks-link">[_1]</span>',
	'&raquo; <a href="[_1]">[_2]</a> from [_3]' => '&raquo; <a href="[_1]">[_2]</a> de [_3]',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">Lire la suite</a>',
	'Tracked on <a href="[_1]">[_2]</a>' => 'Tracké le <a href="[_1]">[_2]</a>',

## default_templates/sidebar.mtml
	'2-column layout - Sidebar' => 'Mise en page à 2 colonnes - Barre latérale',
	'3-column layout - Primary Sidebar' => 'Mise en page à 3 colonnes - Première barre latérale',
	'3-column layout - Secondary Sidebar' => 'Mise en page à 3 colonnes - Seconde barre latérale',

## default_templates/categories.mtml

## default_templates/comments.mtml
	'Comment Form' => 'Formulaire de commentaire',
	'[_1] Comments' => '[_1] commentaires',
	'Comment Detail' => 'Détail du Commentaire',

## default_templates/search_results.mtml
	'Search Results' => 'Résultats de recherche',
	'Results matching &ldquo;[_1]&rdquo; from [_2]' => 'Résultats pour &ldquo;[_1]&rdquo; dans [_2]',
	'Results tagged &ldquo;[_1]&rdquo; from [_2]' => 'Résultats tagués &ldquo;[_1]&rdquo; dans [_2]',
	'Results matching &ldquo;[_1]&rdquo;' => 'Résultats pour &ldquo;[_1]&rdquo;',
	'Results tagged &ldquo;[_1]&rdquo;' => 'Résultats tagués &ldquo;[_1]&rdquo;',
	'No results found for &ldquo;[_1]&rdquo;.' => 'Aucun résultat pour &ldquo;[_1]&rdquo;.',
	'Instructions' => 'Instructions',
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Par défaut, ce moteur va rechercher tous les mots, quelque soit leur ordre. Pour lancer une recherche sur une phrase exacte, insérez la phrase entre des apostrophes : ',
	'movable type' => 'movable type',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'Le moteur de recherche supporte aussi les mot-clés AND, OR, NOT pour spécifier des expressions booléennes :',
	'personal OR publishing' => 'personnel OR publication',
	'publishing NOT personal' => 'publication NOT personnel',

## default_templates/sidebar_2col.mtml
	'Search' => 'Rechercher',
	'Case sensitive' => 'Sensible à la casse',
	'Regex search' => 'Expression générique',
	'[_1] ([_2])' => '[_1] ([_2])',
	'About this Entry' => 'À propos de cette note',
	'About this Archive' => 'À propos de cette archive',
	'About Archives' => 'À propos des archives',
	'This page contains links to all the archived content.' => 'Cette page contient des liens vers toutes les archives.',
	'This page contains a single entry by [_1] published on <em>[_2]</em>.' => 'Cette page contient une unique note de [_1] publiée le <em>[_2]</em>.',
	'<a href="[_1]">[_2]</a> was the previous entry in this blog.' => '<a href="[_1]">[_2]</a> est la note précédente de ce blog.',
	'<a href="[_1]">[_2]</a> is the next entry in this blog.' => '<a href="[_1]">[_2]</a> est la note suivante de ce blog.',
	'This page is a archive of entries in the <strong>[_1]</strong> category from <strong>[_2]</strong>.' => 'Cette page est une archive des notes dans la catégorie <strong>[_1]</strong> par <strong>[_2]</strong>.',
	'<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> est l\'archive précédente.',
	'<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> est l\'archive suivante.',
	'This page is a archive of recent entries in the <strong>[_1]</strong> category.' => 'Cette page est une archive des notes récentes dans la catégorie <strong>[_1]</strong>.',
	'<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> est la catégorie précédente.',
	'<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> est la catégorie suivante.',
	'This page is a archive of recent entries written by <strong>[_1]</strong> in <strong>[_2]</strong>.' => 'Cette page est une archive des notes récentes écrites par <strong>[_1]</strong> dans <strong>[_2]</strong>.',
	'This page is a archive of recent entries written by <strong>[_1]</strong>.' => 'Cette page est une archive des notes récentes écrites par <strong>[_1]</strong>.',
	'This page is an archive of entries from <strong>[_2]</strong> listed from newest to oldest.' => 'Cette page est une archive des notes de <strong>[_2]</strong> listées de la plus récente à la plus ancienne.',
	'Find recent content on the <a href="[_1]">main index</a>.' => 'Retrouvez le contenu récent sur <a href="[_1]">l\'index principal</a>.',
	'Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.' => 'Retrouvez le contenu récent sur <a href="[_1]">l\'index principal</a> ou allez dans les <a href="[_2]">archives</a> pour retrouver tout le contenu.',
	'Recent Entries' => 'Notes récentes',
	'Photos' => 'Photos',
	'Tag Cloud' => 'Nuage de tags',
	'[_1] <a href="[_2]">Archives</a>' => '<a href="[_2]">Archives</a> [_1]',
	'[_1]: Monthly Archives' => '[_1]: Archives Mensuelles',
	'Subscribe to feed' => 'S\'abonner au flux',
	'Subscribe to this blog\'s feed' => 'S\'abonner au flux de ce blog',
	'Search results matching &ldquo;<$MTSearchString$>&rdquo;' => 'Résultats de recherche pour &ldquo;<$MTSearchString$>&rdquo;',
	'_MTCOM_URL' => 'http://www.movabletype.com/',

## default_templates/sidebar_3col.mtml

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'Page Non Trouvée',

## default_templates/comment_preview.mtml
	'Comment on [_1]' => 'Commentaire sur [_1]',
	'Previewing your Comment' => 'Aperçu de votre commentaire',

## default_templates/commenter_confirm.mtml
	'Thank you registering for an account to comment on [_1].' => 'Merci de vous être enregistré pour commenter sur [_1].',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to comment on [_1].' => 'Pour votre propre sécurité et pour éviter les fraudes, nous vous demandons de confirmer votre compte et votre adresse email avant de continuer. Vous pourrez ensuite immédiatement commenter sur [_1].',
	'To confirm your account, please click on or cut and paste the following URL into a web browser:' => 'Pour confirmer votre compte, cliquez ou copiez-collez l\'adresse suivante dans un navigateur web:',
	'If you did not make this request, or you don\'t want to register for an account to comment on [_1], then no further action is required.' => 'Si vous n\'êtes pas à l\'origine de cette demande, ou si vous ne souhaitez pas vous enregistrer pour commenter sur [_1], alors aucune action n\'est nécessaire.',
	'Thank you very much for your understanding.' => 'Merci beaucoup pour votre compréhension.',
	'Sincerely,' => 'Cordialement,',

## lib/MT/Asset/Video.pm
	'Video' => 'Vidéo',
	'Videos' => 'Vidéos',
	'video' => 'Vidéo',

## lib/MT/Asset/Audio.pm
	'Audio' => 'Audio',
	'audio' => 'Audio',

## lib/MT/Asset/Image.pm
	'Image' => 'Image',
	'Images' => 'Images',
	'Actual Dimensions' => 'Dimensions réelles',
	'[_1] x [_2] pixels' => '[_1] x [_2] pixels',
	'Error cropping image: [_1]' => 'Erreur de retaillage de l\'image: [_1]',
	'Error scaling image: [_1]' => 'Erreur lors du redimentionnement de l\'image: [_1]',
	'Error converting image: [_1]' => 'Erreur pendant la conversion de l\'image: [_1]',
	'Error creating thumbnail file: [_1]' => 'Erreur lors de la création de la vignette: [_1]',
	'%f-thumb-%wx%h%x' => '%f-thumb-%wx%h%x',
	'Can\'t load image #[_1]' => 'Impossible de charger l\'image #[_1]',
	'View image' => 'Voir l\'image',
	'Permission denied setting image defaults for blog #[_1]' => 'Autorisation interdite de configurer les paramètres par défaut des images pour le blog #[_1]',
	'Thumbnail image for [_1]' => 'Miniature de l\'image pour [_1]',
	'Invalid basename \'[_1]\'' => 'Nom de base invalide \'[_1]\'',
	'Error writing to \'[_1]\': [_2]' => 'Erreur \'[_1]\' lors de l\'écriture de : [_2]',
	'Popup Page for [_1]' => 'Fenêtre popup pour [_1]',

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

## lib/MT/Util/Archive.pm
	'Type must be specified' => 'Le type doit être spécifié',
	'Registry could not be loaded' => 'Le registre n\'a pu être chargé',

## lib/MT/Util/Captcha.pm
	'Movable Type default CAPTCHA provider requires Image::Magick.' => 'Le fournisseur de CAPTCHA par défaut de Movable Type nécessite Image::Magick.',
	'You need to configure CaptchaSourceImageBase.' => 'Vous devez configurer CaptchaSourceImagebase.',
	'Image creation failed.' => 'Création de l\'image échouée.',
	'Image error: [_1]' => 'Erreur image : [_1]',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: [_2][_3] de la règle [_4][_5]',
	'[_1]: [_2][_3] from test [_4]' => '[_1]: [_2][_3] du test [_4]',

## lib/MT/Auth/TypeKey.pm
	'Sign in requires a secure signature.' => 'L\'identification nécessite une signature sécurisée.',
	'The sign-in validation failed.' => 'La validation de l\'enregistrement a échoué.',
	'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Les auteurs de commentaires de ce blog doivent donner une adresse email. Si vous souhaitez le faire il faut vous enregistrer à nouveau et donner l\'autorisation au système d\'identification de récupérer votre adresse email',
	'Couldn\'t save the session' => 'Impossible de sauvegarder la session',
	'This blog requires commenters to provide an email address' => 'Sur ce blog il est nécessaire de fournir un email pour pouvoir commenter',
	'Couldn\'t get public key from url provided' => 'Impossible d\'avoir une clef publique',
	'No public key could be found to validate registration.' => 'Aucune clé publique n\'a été trouvée pour valider l\'inscription.',
	'TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'La vérification de la signature Typekey retournée [_1] dans [_2] secondes en vérifiant [_3] avec [_4]',
	'The TypeKey signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'La signature Typekey est périmée depuis ([_1] secondes). Vérifier que votre serveur a une heure correcte',

## lib/MT/Auth/OpenID.pm
	'Invalid request.' => 'Demande invalide.',
	'The address entered does not appear to be an OpenID' => 'L\'adresse entrée ne semble pas être une adresse OpenID',
	'The text entered does not appear to be a web address' => 'L\'adresse entrée ne semble pas être une adresse de type URL',
	'Unable to connect to [_1]: [_2]' => 'Impossible de se connecter à [_1] : [_2]',
	'Could not verify the OpenID provided: [_1]' => 'La vérification de l\'OpenID entré a échoué : [_1]',

## lib/MT/Auth/MT.pm
	'Passwords do not match.' => 'Les mots de passe ne sont pas identiques.',
	'Failed to verify current password.' => 'Erreur lors de la vérification du mot de passe.',
	'Password hint is required.' => 'L\'indice de mot de passe est requis.',

## lib/MT/TheSchwartz/Error.pm
	'Job Error' => 'Erreur de tâche',

## lib/MT/TheSchwartz/FuncMap.pm
	'Job Function' => 'Fonction Tâche',

## lib/MT/TheSchwartz/Job.pm
	'Job' => 'Tâche',

## lib/MT/TheSchwartz/ExitStatus.pm
	'Job Exit Status' => 'Statut de fin de tâche',

## lib/MT/ObjectDriver/Driver/DBD/SQLite.pm
	'Can\'t open \'[_1]\': [_2]' => 'Impossible d\'ouvrir \'[_1]\' : [_2]',

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

## lib/MT/BackupRestore/ManifestFileHandler.pm
	'Uploaded file was not a valid Movable Type backup manifest file.' => 'Le fichier envoyé n\'était pas un fichier de sauvegarde manifest Movable Type valide.',

## lib/MT/BackupRestore/BackupFileHandler.pm
	'Uploaded file was backed up from Movable Type with the newer schema version ([_1]) than the one in this system ([_2]).  It is not safe to restore the file to this version of Movable Type.' => 'Le fichier envoyé a été sauvegardé à partir de Movable Type avec une version plus récente du schéma ([_1]) que celle de ce système ([_2]).  Il n\'est pas recommandé de restaurer ce fichier dans cette version de Movable Type.',
	'[_1] is not a subject to be restored by Movable Type.' => '[_1] n\'est pas un sujet qui peut être restauré par Movable Type.',
	'[_1] records restored.' => '[_1] enregistrements restaurés.',
	'Restoring [_1] records:' => 'Restauration de [_1] enregistrements:',
	'User with the same name as the name of the currently logged in ([_1]) found.  Skipped the record.' => 'Utilisateur avec le même nom que l\'utilisateur actuellement connecté ([_1]) trouvé',
	'User with the same name \'[_1]\' found (ID:[_2]).  Restore replaced this user with the data backed up.' => 'Utilisateur avec le même nom \'[_1]\' trouvé (ID:[_2]). La restauration a remplacé cet utilisateur par les données présentes dans la sauvegardes.',
	'Tag \'[_1]\' exists in the system.' => 'Le tag \'[_1]\' existe dans le système.',
	'[_1] records restored...' => '[_1] enregistrements restaurés...',

## lib/MT/Template/Context.pm
	'The attribute exclude_blogs cannot take \'all\' for a value.' => 'L\'attribut exclude_blogs ne peut pas prendre \'all\' comme valeur.',

## lib/MT/Template/ContextHandlers.pm
	'Remove this widget' => 'Supprimer ce widget',
	'[_1]Publish[_2] your site to see these changes take effect.' => '[_1]Publiez[_2] votre site pour que ces changements soient appliqués.',
	'Actions' => 'Actions',
	'Warning' => 'Attention',
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.org/documentation/appendices/tags/%t.html',
	'No [_1] could be found.' => 'Il n\'y a pas de [_1] trouvés.',
	'Invalid tag [_1] specified.' => 'Tag invalide [_1] spécifié.',
	'Recursion attempt on [_1]: [_2]' => 'Tentative de récursion sur [_1]: [_2]',
	'Can\'t find included template [_1] \'[_2]\'' => 'Impossible de trouver le gabarit inclus [_1] \'[_2]\'',
	'Can\'t find blog for id \'[_1]' => 'Impossible de trouver un blog pour le ID\'[_1]',
	'Can\'t find included file \'[_1]\'' => 'Impossible de trouver le fichier inclus \'[_1]\'',
	'Error opening included file \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture du fichier inclus \'[_1]\' : [_2]',
	'Recursion attempt on file: [_1]' => 'Tentative de récursion sur le fichier: [_1]',
	'Unspecified archive template' => 'Gabarit d\'archive non spécifié',
	'Error in file template: [_1]' => 'Erreur dans fichier gabarit : [_1]',
	'Can\'t load template' => 'Impossible de charger le gabarit',
	'Can\'t find template \'[_1]\'' => 'Impossible de trouver le gabarit \'[_1]\'',
	'Can\'t find entry \'[_1]\'' => 'Impossible de trouver la note \'[_1]\'',
	'[_1] is not a hash.' => '[_1] n\'est pas un hash',
	'You used an \'[_1]\' tag outside of the context of a author; perhaps you mistakenly placed it outside of an \'MTAuthors\' container?' => 'Vous avez utilisé un tag \'[_1]\' en dehors du contexte d\'un auteur; peut-être l\'avez-vous placé par erreur en dehors du conteneur \'MTAuthors\' ?',
	'You have an error in your \'[_2]\' attribute: [_1]' => 'Vous avez une erreur dans votre attribut \'[_2]\' : [_1]',
	'You have an error in your \'tag\' attribute: [_1]' => 'Vous avez une erreur dans votre attribut \'tag\': [_1]',
	'No such user \'[_1]\'' => 'L\'utilisateur \'[_1]\' n\'existe pas',
	'You used an \'[_1]\' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an \'MTEntries\' container?' => 'Vous avez utilisé une balise \'[_1]\' en dehors du contexte d\'une note; peut-être l\'avez-vous placé par erreur en dehors du conteneur \'MTEntries\' ?',
	'You used <$MTEntryFlag$> without a flag.' => 'Vous utilisez <$MTEntryFlag$> sans drapeau.',
	'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Vous avez utilisé un [_1] tag pour créer un lien vers \'[_2]\' archives, mais ce type d\'archive n\'est pas publié.',
	'Could not create atom id for entry [_1]' => 'Impossible de créer un ID Atom pour cette note [_1]',
	'To enable comment registration, you need to add a TypeKey token in your weblog config or user profile.' => 'Pour activer l\'enregistrement afin de commenter, vous devez ajouter une clé TypeKey dans le profil de votre blog ou celui de votre utilisateur.',
	'The MTCommentFields tag is no longer available; please include the [_1] template module instead.' => 'Le tag MTCommentFields n\'est plus disponible; merci d\'inclure le module de template [_1] à la place.',
	'You used an [_1] tag without a date context set up.' => 'Vous utilisez un tag [_1] sans avoir configuré la date.',
	'You used an \'[_1]\' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an \'MTComments\' container?' => 'Vous avez utilisé une balise \'[_1]\' en dehors du contexte d\'un commentaire; peut-être l\'avez-vous placé par erreur en dehors du conteneur \'MTComments\' ?',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] est valide uniquement avec des archives quotidiennes, hebdomadaires ou mensuelles.',
	'Group iterator failed.' => 'Le répétateur de groupe a échoué',
	'You used an [_1] tag outside of the proper context.' => 'Vous utilisez un tag [_1] en dehors de son contexte propre.',
	'Could not determine entry' => 'La note ne peut pas être déterminée',
	'Invalid month format: must be YYYYMM' => 'Le format du mois est invalide : Il doit être de la forme AAAAMM',
	'No such category \'[_1]\'' => 'La catégorie \'[_1]\' n\'existe pas',
	'[_1] cannot be used without publishing Category archive.' => '[_1] ne peut être utilisé sans la publication d\'archives par catégorie.',
	'<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> doit être utilisé dans le contexte d\'une catégorie, ou avec l\'attribut \'Catégorie\' dans le tag.',
	'You failed to specify the label attribute for the [_1] tag.' => 'Vous n\'avez pas spécifié l\'étiquette du tag [_1].',
	'You used an \'[_1]\' tag outside of the context of a ping; perhaps you mistakenly placed it outside of an \'MTPings\' container?' => 'Vous avez utilisé une balise \'[_1]\' en dehors d\'un contexte de ping; peut-être l\'avez-vous placé en dehors du conteneur \'MTPings\' ?',
	'[_1] used outside of [_2]' => '[_1] utilisé en dehors de [_2]',
	'MT[_1] must be used in a [_2] context' => 'MT[_1] doit être utilisé dans le contexte [_2]',
	'Cannot find package [_1]: [_2]' => 'Impossible de trouver le package [_1]: [_2]',
	'Error sorting [_2]: [_1]' => 'Erreur en classant [_2]: [_1]',
	'Edit' => 'Editer',
	'You used an \'[_1]\' tag outside of the context of an asset; perhaps you mistakenly placed it outside of an \'MTAssets\' container?' => 'Vous avez utilisé une balise \'[_1]\' en dehors du contexte d\'un élément; peut-être l\'avez-vous placé par erreur en dehors d\'un conteneur \'MTAssets\' ?',
	'You used an \'[_1]\' tag outside of the context of an page; perhaps you mistakenly placed it outside of an \'MTPages\' container?' => 'Vous avez utilisé une balise \'[_1]\' en dehors du contexte d\'une page; peut-être l\'avez-vous placé par erreur en dehors d\'un conteneur \'MTPages\' ?',
	'You used an [_1] without a author context set up.' => 'Vous avez utilisé un [_1] sans avoir configuré de contexte d\'auteur.',
	'Can\'t load user.' => 'Impossible de charger l\'utilisateur.',
	'Division by zero.' => 'Division par zéro.',

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
	'Successfully authenticated but signing up is not allowed.  Please contact system administrator.' => 'Indentification réussie mais l\'enregistrement n\'est pas autorisé. Merci de contacter votre administrateur système.',
	'You need to sign up first.' => 'Vous devez vous enregistrer d\'abord.',
	'Permission denied.' => 'Autorisation refusée.',
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
	'Invalid request' => 'Demande incorrecte',
	'No entry_id' => 'Pas de note_id',
	'No such entry \'[_1]\'.' => 'Aucune Note \'[_1]\'.',
	'You are not allowed to add comments.' => 'Vous n\'êtes pas autorisé à poster des commentaires.',
	'_THROTTLED_COMMENT' => 'Dans le but de réduire les possibilités d\'abus, Nous avons activé une fonction obligeant les auteurs de commentaires à attendre quelques instants avant de publier un autre commentaire. Veuillez attendre quelques instants avant de publier un autre commentaire. Merci.',
	'Comments are not allowed on this entry.' => 'Les commentaires ne sont pas autorisés sur cette Note.',
	'Comment text is required.' => 'Le texte de commentaire est requis.',
	'An error occurred: [_1]' => 'Une erreur s\'est produite: [_1]',
	'Registration is required.' => 'L\'inscription est requise.',
	'Name and email address are required.' => 'Le nom et l\'e-mail sont requis.',
	'Invalid email address \'[_1]\'' => 'Adresse e-mail invalide \'[_1]\'',
	'Invalid URL \'[_1]\'' => 'URL invalide \'[_1]\'',
	'Text entered was wrong.  Try again.' => 'Le texte saisi est erroné.  Essayez à nouveau',
	'Comment save failed with [_1]' => 'La sauvegarde du commentaire a échoué [_1]',
	'Comment on "[_1]" by [_2].' => 'Commentaire sur "[_1]" par [_2].',
	'Commenter save failed with [_1]' => 'L\'enregistrement de l\'auteur de commentaires a échoué [_1]',
	'Publish failed: [_1]' => 'Échec de la publication : [_1]',
	'Failed comment attempt by pending registrant \'[_1]\'' => 'Tentative de commentaire échouée par utilisateur  \'[_1]\' en cours d\'inscription',
	'Registered User' => 'Utilisateur enregistré',
	'The sign-in attempt was not successful; please try again.' => 'La tentative d\'enregistrement a échoué; veuillez essayer de nouveau.',
	'The sign-in validation was not successful. Please make sure your weblog is properly configured and try again.' => 'La procédure d\'enregistrement a échoué. Veuillez vérifier que votre blog est configuré correctement et essayez de nouveau.',
	'No such entry ID \'[_1]\'' => 'Aucune ID pour la Note \'[_1]\'',
	'No entry was specified; perhaps there is a template problem?' => 'Aucune note n\'a été spécifiée; peut-être y a-t-il un problème de gabarit?',
	'Somehow, the entry you tried to comment on does not exist' => 'Il semble que la note que vous souhaitez commenter n\'existe pas',
	'Invalid commenter ID' => 'ID de commentaire invalide',
	'No entry ID provided' => 'Aucune ID de note fournie',
	'Permission denied' => 'Autorisation refusée',
	'All required fields must have valid values.' => 'Tous les champs obligatoires doivent avoir des valeurs valides.',
	'Email Address is invalid.' => 'L\'adresse email n\'est pas valide.',
	'URL is invalid.' => 'L\'URL n\'est pas valide.',
	'Commenter profile has successfully been updated.' => 'Le profil de l\'auteur de commentaires a été modifié avec succès.',
	'Commenter profile could not be updated: [_1]' => 'Le profil de l\'auteur de commentaires n\'a pu être modifié: [_1]',

## lib/MT/App/Search.pm
	'You are currently performing a search. Please wait until your search is completed.' => 'Vous êtes en train d\'effectuer une recherche. Merci d\'attendre que la recherche soit finie.',
	'Search failed. Invalid pattern given: [_1]' => 'Échec de la recherche. Comportement non valide : [_1]',
	'Search failed: [_1]' => 'Échec lors de la recherche : [_1]',
	'No alternate template is specified for the Template \'[_1]\'' => 'Pas de gabarit alternatif spécifié pour le gabarit \'[_1]\'',
	'Publishing results failed: [_1]' => 'Échec de la publication des résultats: [_1]',
	'Search: query for \'[_1]\'' => 'Recherche : requête pour \'[_1]\'',
	'Search: new comment search' => 'Recherche : recherche de nouveaux commentaires',

## lib/MT/App/Trackback.pm
	'Invalid entry ID \'[_1]\'' => 'ID de Note invalide \'[_1]\'',
	'You must define a Ping template in order to display pings.' => 'Vous devez définir un gabarit d\'affichage Ping pour les afficher.',
	'Trackback pings must use HTTP POST' => 'Les Pings trackback doivent utiliser HTTP POST',
	'Need a TrackBack ID (tb_id).' => 'Un trackback ID est requis (tb_id).',
	'Invalid TrackBack ID \'[_1]\'' => 'Trackback ID invalide \'[_1]\'',
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
	'Failed to authenticate using given credentials: [_1].' => 'L\'authentification a échoué en utilisant les informations communiquées [_1].',
	'You failed to validate your password.' => 'Échec lors de la validation du mot de passe.',
	'You failed to supply a password.' => 'Vous n\'avez pas donné de mot de passe.',
	'The e-mail address is required.' => 'L\'adresse email est requise.',
	'The path provided below is not writable.' => 'Le chemin ci-dessous n\'est pas ouvert en écriture',
	'Invalid session.' => 'Session invalide.',
	'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Pas d\'autorisation. Contactez votre administrateur système Movable Type pour modifier vos privilèges.',
	'Movable Type has been upgraded to version [_1].' => 'Movable Type a été mis à jour à la version [_1].',

## lib/MT/App/Wizard.pm
	'The [_1] database driver is required to use [_2].' => 'Le driver de base de données [_1] est obligatoire pour utiliser [_2].',
	'The [_1] driver is required to use [_2].' => 'Le driver [_1] est obligatoire pour utiliser [_2].',
	'An error occurred while attempting to connect to the database.  Check the settings and try again.' => 'Une erreur s\'est produite en essayant de se connecter à la base de données. Vérifiez les paramètres et essayez à nouveau.',
	'SMTP Server' => 'Serveur SMTP',
	'Sendmail' => 'Sendmail',
	'Test email from Movable Type Configuration Wizard' => 'Test email à partir de l\'Assistant de Configuration de Movable Type',
	'This is the test email sent by your new installation of Movable Type.' => 'Ceci est un email de test envoyé par votre nouvelle installation Movable Type.',
	'This module is needed to encode special characters, but this feature can be turned off using the NoHTMLEntities option in mt-config.cgi.' => 'Ce module est nécessaire pour encoder les caractères spéciaux, mais cette option peut être désactivée en utilisant NoHTMLEntities dans mt-config.cgi.',
	'This module is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'Ce module est nécessaire si vous souhaitez utiliser le système de trackback, les pings weblogs.com, ou le ping Mises à jour récentes MT.',
	'This module is needed if you wish to use the MT XML-RPC server implementation.' => 'Ce module est nécessaire si vous souhaitez utiliser l\'implémentation du serveur XML-RPC MT.',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Ce module est nécessaire si vous voulez pouvoir écraser les fichiers existants lorsque vous envoyez un nouveau fichier.',
	'List::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'List:Util est optionnel; Il est nécessaire si vous souhaitez utiliser les possibilités de publications en mode file d\'attente',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Ce module est nécessaire si vous souhaitez pouvoir créer des vignettes pour les images envoyées.',
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
	'This module is used in test attribute of MTIf conditional tag.' => 'Ce module est utilisé dans l\'attribut de test du tag conditionnel MTIf.',
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Ce module est nécessaire pour les envois de fichiers (pour déterminer la taille des images dans différents formats).',
	'This module is required for cookie authentication.' => 'Ce module est nécessaire pour l\'authentification par cookies.',
	'DBI is required to store data in database.' => 'DBI est nécessaire pour enregistrer les données en base de données.',
	'CGI is required for all Movable Type application functionality.' => 'CGI est nécessaire pour toutes les fonctionnalités de l\'application Movable Type.',
	'File::Spec is required for path manipulation across operating systems.' => 'File::Spec est nécessaire pour manipuler les chemins de fichiers sur différents systèmes d\'exploitation.',

## lib/MT/App/Viewer.pm
	'Loading blog with ID [_1] failed' => 'Échec lors du chargement du blog ayant pour ID [_1] ',
	'Template publishing failed: [_1]' => 'Échec lors de la publication du gabarit : [_1]',
	'Invalid date spec' => 'Spécifications de dates invalides',
	'Can\'t load template [_1]' => 'Impossible de charger le gabarit [_1]',
	'Archive publishing failed: [_1]' => 'Échec lors de la publication de l\'archive : [_1]',
	'Invalid entry ID [_1]' => ' ID de la note invalide : [_1]',
	'Entry [_1] is not published' => 'La note [_1] n\'est pas publiée',
	'Invalid category ID \'[_1]\'' => 'ID de catégorie invalide : \'[_1]\'',

## lib/MT/App/CMS.pm
	'No [_1] were found that match the given criteria.' => 'Aucun [_1] n\'a été trouvé correspondant aux critères fournis.',
	'This action will restore your global templates to factory settings without creating a backup. Click OK to continue or Cancel to abort.' => 'Cette action va restaurer vos gabarits globaux aux valeurs d\'origine sans créer de sauvegarde. Cliquez OK pour continuer ou Annuler pour annuler',
	'_WARNING_PASSWORD_RESET_MULTI' => 'Vous êtes sur le point de ré-initialiser le mot de passe des utilisateurs sélectionnés. Les nouveaux mots de passe sont générés automatiquement et seront envoyés directement aux utilisateurs par e-mail. Êtes-vous sûr de vouloir continuer ?',
	'_WARNING_DELETE_USER_EUM' => 'Supprimer un utilisateur est une action définitive qui va rendre des notes orphelines. Si vous voulez retirer un utilisateur ou lui supprimer ses accès nous vous recommandons de désactiver son compte. Êtes-vous sûr(e) de vouloir supprimer cet utilisateur ? Attention, il pourra se créer un nouvel accès s\'il existe encore dans le répertoire externe',
	'_WARNING_DELETE_USER' => 'Supprimer un utilisateur est une action définitive qui va rendre des notes orphelines. Si vous souhaitez retirer un utilisateur ou lui supprimer ses accès nous vous recommandons de désactiver son compte. Êtes-vous sûr(e) de vouloir supprimer cet utilisateur ?',
	'All Assets' => 'Tous les Éléments',
	'Published [_1]' => '[_1] publiées',
	'Unpublished [_1]' => '[_1] non-publiées',
	'Scheduled [_1]' => '[_1] programmées',
	'My [_1]' => 'Mes [_1]',
	'[_1] with comments in the last 7 days' => '[_1] avec des commentaires dans les 7 derniers jours',
	'[_1] posted between [_2] and [_3]' => '[_1] postées entre le [_2] et le [_3]',
	'[_1] posted since [_2]' => '[_1] postées depuis [_2]',
	'[_1] posted on or before [_2]' => '[_1] postées le ou avant le [_2]',
	'All comments by [_1] \'[_2]\'' => 'Tous les commentaires par [_1] \'[_2]\'',
	'Commenter' => 'Auteur du commentaire',
	'All comments for [_1] \'[_2]\'' => 'Tous les commentaires pour [_1] \'[_2]\'',
	'Comments posted between [_1] and [_2]' => 'Commentaires postés entre [_1] et [_2]',
	'Comments posted since [_1]' => 'Commentaires déposés depuis [_1]',
	'Comments posted on or before [_1]' => 'Commentaires postés le ou avant le [_1]',
	'Invalid blog' => 'Blog incorrect',
	'Password Recovery' => 'Récupération de mot de passe',
	'Invalid password recovery attempt; can\'t recover password in this configuration' => 'Tentative de récupération de mot de passe invalide; impossible de récupérer le mot de passe dans cette configuration',
	'Invalid author_id' => 'auteur_id incorrect',
	'Can\'t recover password in this configuration' => 'Impossible de récupérer le mot de passe dans cette configuration',
	'Invalid user name \'[_1]\' in password recovery attempt' => 'Nom d\'utilisateur invalide \'[_1]\' lors de la tentative de récupération du mot de passe',
	'User name or password hint is incorrect.' => 'Identifiant ou indice du mot de passe incorrect.',
	'User has not set pasword hint; cannot recover password' => 'L\'utilisateur n\'a pas fourni d\'indice de mot de passe; impossible de récupérer le mot de passe',
	'Invalid attempt to recover password (used hint \'[_1]\')' => 'Tentative invalide de récupération du mot de passe (indice de \'utilisateur \'[_1]\')',
	'User does not have email address' => 'L\'utilisateur n\'a pas d\'adresse email',
	'Password was reset for user \'[_1]\' (user #[_2]). Password was sent to the following address: [_3]' => 'Le mot de passe a été réinitialisé pour l\'utilisateur \'[_1]\' (utilisateur #[_2]). Le mot de passe a été envoyé à l\'adresse suivante: [_3]',
	'Error sending mail ([_1]); please fix the problem, then try again to recover your password.' => 'Erreur d\'envoi du mail ([_1]); merci de corriger le problème, puis essayez à nouveau de récupérer votre mot de passe.',
	'(newly created user)' => '(utilisateur nouvellement créé)',
	'Untitled' => 'Sans nom',
	'Files' => 'Fichiers',
	'Roles' => 'Rôles',
	'Users' => 'Utilisateurs',
	'User Associations' => 'Associations d\'utilisateur',
	'Role Users & Groups' => 'Rôle Utilisateurs et Groupes',
	'Associations' => 'Associations',
	'(Custom)' => '(Personnalisé)',
	'(user deleted)' => '(utilisateur effacé)',
	'The user' => 'L\'utilisateur',
	'User' => 'Utilisateur',
	'Invalid type' => 'Type incorrect',
	'New name of the tag must be specified.' => 'Le nouveau nom de ce tag doit être spécifié.',
	'No such tag' => 'Pas de tag de ce type',
	'None' => 'Aucune',
	'You are not authorized to log in to this blog.' => 'Vous n\'êtes pas autorisé à vous connecter sur ce blog.',
	'No such blog [_1]' => 'Aucun blog ne porte le nom [_1]',
	'Shared Template Modules' => 'Modules de gabarits partagés',
	'Reuse elements of your site design or layout across all the blogs and sites managed within Movable Type.' => 'Réutilisez des éléments du design de votre site ou mises en pages sur tous les blogs et sites gérés par Movable Type',
	'Userpics' => 'Avatars',
	'Allow authors and commenters to upload a photo of themselves to be displayed alongside their comments.' => 'Permettre aux auteurs et auteurs de commentaires de télécharger une photo d\'eux pour l\'afficher à côté de leurs commentaires',
	'Template Sets' => 'Groupes de gabarits',
	'Template sets provide an easy way to bundle an entire design and install it into Movable Type.' => 'Les groupes de gabartis permettent de créer facilement un paquet contenant un design en entier et de l\'installer dans Movable Type',
	'Blogs' => 'Blogs',
	'Blog Activity Feed' => 'Flux Activité du Blog',
	'*User deleted*' => '*Utilisateur supprimé*',
	'All Feedback' => 'Tous les retours lecteurs',
	'Publishing' => 'Publication',
	'Activity Log' => 'Journal (logs)',
	'System Activity Feed' => 'Flux d\'activité du système',
	'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'Journal (logs) pour le blog \'[_1]\' (ID:[_2]) réinitialisé par \'[_3]\'',
	'Activity log reset by \'[_1]\'' => 'Journal (logs) réinitialisé par \'[_1]\'',
	'Please select a blog.' => 'Merci de sélectionner un blog.',
	'Edit Template' => 'Modifier un gabarit',
	'Go Back' => 'Retour',
	'Import/Export' => 'Importer/Exporter',
	'Invalid parameter' => 'Paramètre invalide',
	'Permission denied: [_1]' => 'Autorisation refusée: [_1]',
	'Load failed: [_1]' => 'Échec de chargement : [_1]',
	'(no reason given)' => '(sans raison donnée)',
	'Entries' => 'Notes',
	'Pages' => 'Pages',
	'(untitled)' => '(sans titre)',
	'index' => 'index',
	'archive' => 'archive',
	'module' => 'module',
	'widget' => 'widget',
	'email' => 'Adresse email',
	'system' => 'système',
	'Templates' => 'Gabarits',
	'One or more errors were found in this template.' => 'Une erreur ou plus ont été trouvées dans ce gabarit.',
	'General Settings' => 'Paramètres généraux',
	'Publishing Settings' => 'Paramètres de publication',
	'Plugin Settings' => 'Paramètres des plugins',
	'Settings' => 'Paramètres',
	'Edit Comment' => 'Éditer les commentaires',
	'Authenticated Commenters' => 'Auteurs de commentaires authentifiés',
	'Commenter Details' => 'Détails sur l\'auteur de commentaires',
	'Assets' => 'Éléments',
	'New Entry' => 'Nouvelle note',
	'New Page' => 'Nouvelle Page',
	'Create template requires type' => 'La création de gabarits nécessite un type',
	'Archive' => 'Archive',
	'Entry or Page' => 'Note ou Page',
	'New Template' => 'Nouveau gabarit',
	'New Blog' => 'Nouveau Blog',
	'pages' => 'Pages',
	'Create User' => 'Créer un utilisateur',
	'User requires username' => 'Un nom d\'utilisateur est nécessaire pour l\'utilisateur',
	'A user with the same name already exists.' => 'Un utilisateur possédant ce nom existe déjà.',
	'User requires password' => 'L\'utilisateur a besoin d\'un mot de passe',
	'User requires password recovery word/phrase' => 'L\'utilisateur a besoin d\'une phrase de récupération de mot de passe',
	'Email Address is required for password recovery' => 'L\'adresse email est nécessaire pour récupérer le mot de passe',
	'Website URL is imperfect' => 'L\'URL du site web n\'est pas valide',
	'The value you entered was not a valid email address' => 'Vous devez saisir une adresse email valide',
	'The e-mail address you entered is already on the Notification List for this blog.' => 'L\'adresse email saisie est déjà sur la liste de notification de ce blog.',
	'You did not enter an IP address to ban.' => 'Vous devez saisir une adresse IP à bannir.',
	'The IP you entered is already banned for this blog.' => 'L\'adresse IP saisie est déjà bannie pour ce blog.',
	'You did not specify a blog name.' => 'Vous n\'avez pas spécifié de nom pour le blog.',
	'Site URL must be an absolute URL.' => 'L\'URL du site doit être une URL absolue.',
	'Archive URL must be an absolute URL.' => 'Les URLs d\'archive doivent être des URLs absolues.',
	'You did not specify an Archive Root.' => 'Vous n\'avez pas spécifié une archive racine ',
	'The name \'[_1]\' is too long!' => 'Le nom \'[_1]\' est trop long.',
	'Folder \'[_1]\' created by \'[_2]\'' => 'Répertoire \'[_1]\' créé par \'[_2]\'',
	'Category \'[_1]\' created by \'[_2]\'' => 'Catégorie \'[_1]\' créée par \'[_2]\'',
	'The folder \'[_1]\' conflicts with another folder. Folders with the same parent must have unique basenames.' => 'Le répertoire \'[_1]\' est en conflit avec un autre répertoire. Les répertoires qui ont le même répertoire parent doivent avoir un nom de base unique.',
	'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Le nom de catégorie \'[_1]\' est en conflit avec une autre catégorie. Les catégories racines et les sous-catégories qui ont le même parent doivent avoir des noms uniques.',
	'The category basename \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => 'Le nom de base de la catégorie \'[_1]\' est en conflit avec une autre catégorie. Les catégories racines et les sous-catégories qui ont le même parent doivent avoir des noms de base uniques.',
	'Saving permissions failed: [_1]' => 'Échec lors de la sauvegarde des Autorisations : [_1]',
	'Blog \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) créé par \'[_3]\'',
	'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) créé par \'[_3]\'',
	'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Gabarit \'[_1]\' (ID:[_2]) créé par \'[_3]\'',
	'You cannot delete your own association.' => 'Vous ne pouvez pas supprimer votre propre association.',
	'You cannot delete your own user record.' => 'Vous ne pouvez pas effacer vos propres données Utilisateur.',
	'You have no permission to delete the user [_1].' => 'Vous n\'avez pas l\'autorisation d\'effacer l\'utilisateur [_1].',
	'Blog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) effacé par \'[_3]\'',
	'Subscriber \'[_1]\' (ID:[_2]) deleted from address book by \'[_3]\'' => 'Abonné \'[_1]\' (ID:[_2]) supprimé du carnet d\'adresses par \'[_3]\'',
	'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
	'Folder \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Répertoire \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
	'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Catégorie \'[_1]\' (ID:[_2]) supprimée par \'[_3]\'',
	'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Commentaire (ID:[_1]) de \'[_2]\' supprimé par \'[_3]\' de la note \'[_4]\'',
	'Page \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Page \'[_1]\' (ID:[_2]) supprimée par \'[_3]\'',
	'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Note \'[_1]\' (ID:[_2]) supprimée par \'[_3]\'',
	'(Unlabeled category)' => '(Catégorie sans description)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) de \'[_2]\' supprimé par \'[_3]\' de la catégorie \'[_4]\'',
	'(Untitled entry)' => '(Note sans titre)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) de \'[_2]\' supprimé par \'[_3]\' de la note \'[_4]\'',
	'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Gabarit \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
	'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Tag \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
	'File \'[_1]\' uploaded by \'[_2]\'' => 'Fichier \'[_1]\' envoyé par \'[_2]\'',
	'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Fichier \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
	'Permisison denied.' => 'Autorisation refusée.',
	'The Template Name and Output File fields are required.' => 'Le nom du gabarit et les champs du fichier de sortie sont obligatoires.',
	'Invalid type [_1]' => 'Type invalide [_1]',
	'Save failed: [_1]' => 'Échec sauvegarde: [_1]',
	'Saving object failed: [_1]' => 'Échec lors de la sauvegarde de l\'objet : [_1]',
	'No Name' => 'Pas de Nom',
	'Notification List' => 'Liste de notifications',
	'IP Banning' => 'Bannissement d\'adresses IP',
	'Removing tag failed: [_1]' => 'La suppression du tag a échouée: [_1]',
	'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => 'Vous ne pouvez pas effacer cette catégorie car elle contient des sous-catégories. Déplacez ou supprimez d\'abord les sous-catégories puis effacez cette catégorie.',
	'Loading MT::LDAP failed: [_1].' => 'Échec de Chargement MT::LDAP[_1]',
	'Removing [_1] failed: [_2]' => 'Suppression [_1] échouée: [_2]',
	'System templates can not be deleted.' => 'Les gabarits créés par le Système ne peuvent pas être supprimés.',
	'Unknown object type [_1]' => 'Objet de type [_1] inconnu',
	'Can\'t load file #[_1].' => 'Impossible de charger le fichier #[_1].',
	'No such commenter [_1].' => 'Pas de d\'auteur de commentaires [_1].',
	'User \'[_1]\' trusted commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\' a accordé le statut Fiable à l\'auteur de commentaire \'[_2]\'.',
	'User \'[_1]\' banned commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\'  a banni l\'auteur de commentaire \'[_2]\'.',
	'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\'  a retiré le statut Banni à l\'auteur de commentaire \'[_2]\'.',
	'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\'  a retiré le statut Fiable à l\'auteur de commentaire \'[_2]\'.',
	'Need a status to update entries' => 'Statut nécessaire pour mettre à jour les notes',
	'Need entries to update status' => 'Notes nécessaires pour mettre à jour le statut',
	'One of the entries ([_1]) did not actually exist' => 'Une des notes ([_1]) n\'existait pas',
	'[_1] \'[_2]\' (ID:[_3]) status changed from [_4] to [_5]' => '[_1] \'[_2]\' (ID:[_3]) statut changé de [_4] à [_5]',
	'You don\'t have permission to approve this comment.' => 'Vous n\'avez pas l\'autorisation d\'approuver ce commentaire.',
	'Comment on missing entry!' => 'Commentaire sur une note manquante !',
	'Commenters' => 'Auteurs de commentaires',
	'Orphaned comment' => 'Commentaire orphelin',
	'Comments Activity Feed' => 'Flux d\'activité des commentaires',
	'Orphaned' => 'Orphelin',
	'Global Templates' => 'Gabarits globaux',
	'Plugin Set: [_1]' => 'Éventail de plugins : [_1]',
	'Individual Plugins' => 'Plugins individuels',
	'Junk TrackBacks' => 'Trackbacks spam',
	'TrackBacks where <strong>[_1]</strong> is &quot;[_2]&quot;.' => 'Trackbacks où <strong>[_1]</strong> est &quot;[_2]&quot;.',
	'TrackBack Activity Feed' => 'Flux d\'activité des trackbacks ',
	'No Excerpt' => 'Pas d\'extrait',
	'No Title' => 'Pas de Titre',
	'Orphaned TrackBack' => 'Trackback orphelin',
	'category' => 'catégorie',
	'Category' => 'Catégorie',
	'Asset' => 'Élément',
	'Tag' => 'Tag',
	'Entry Status' => 'Statut par défaut',
	'[_1] Feed' => 'Flux [_1]',
	'(user deleted - ID:[_1])' => '(utilisateur supprimé - ID:[_1])',
	'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Date invalide \'[_1]\'; les dates doivent être au format AAAA-MM-JJ HH:MM:SS.',
	'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Date invalide \'[_1]\'; les dates de publication doivent être réelles.',
	'Saving [_1] failed: [_2]' => 'Enregistrement de [_1] a échoué: [_2]',
	'Saving entry \'[_1]\' failed: [_2]' => 'Échec \'[_1]\' lors de la sauvegarde de la Note : [_2]',
	'Removing placement failed: [_1]' => 'Échec lors de la suppression de l\'emplacement : [_1]',
	'Saving placement failed: [_1]' => 'Échec lors de la sauvegarde du placement : [_1]',
	'[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_1] \'[_2]\' (ID:[_3]) édité et son statut est passé de [_4] a [_5] par utilisateur \'[_6]\'',
	'[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) édité par utilisateur \'[_4]\'',
	'No such [_1].' => 'Pas de [_1].',
	'Same Basename has already been used. You should use an unique basename.' => 'Ce nom de base est déjà utilisé. Vous devriez choisir un nom de base unique.',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Votre blog n\'a pas été configuré avec un chemin de site et une URL. Vous ne pourrez pas publier de notes tant qu\'ils ne seront pas définis.',
	'[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) ajouté par utilisateur \'[_4]\'',
	'Error during publishing: [_1]' => 'Erreur pendant la publication : [_1]',
	'Subfolder' => 'Sous-répertoire',
	'Subcategory' => 'Sous-catégorie',
	'Saving category failed: [_1]' => 'Échec lors de la sauvegarde des catégories : [_1]',
	'The [_1] must be given a name!' => 'Le [_1] doit avoir un nom!',
	'Saving blog failed: [_1]' => 'Échec lors de la sauvegarde du blog : [_1]',
	'Invalid ID given for personal blog clone source ID.' => 'ID invalide fourni pour l\'ID de la source de la duplication du blog personnel.',
	'If personal blog is set, the default site URL and root are required.' => 'Si le blog personnel est activé, l\'URL du site par défaut et sa racine sont obligatoires.',
	'Feedback Settings' => 'Paramètres des Feedbacks',
	'Publish error: [_1]' => 'Erreur de publication: [_1]',
	'Unable to create preview file in this location: [_1]' => 'Impossible de créer le fichier de pré-visualisation à cet endroit : [_1]',
	'New [_1]' => 'Nouveau [_1]',
	'Publish Site' => 'Publier le site',
	'index template \'[_1]\'' => 'gabarit d\'index \'[_1]\'',
	'[_1] \'[_2]\'' => '[_1] \'[_2]\'',
	'No permissions' => 'Aucun droit',
	'Ping \'[_1]\' failed: [_2]' => 'Le ping \'[_1]\' n\'a pas fonctionné : [_2]',
	'Create Role' => 'Créer un rôle',
	'Role name cannot be blank.' => 'Le rôle de peu pas être laissé vierge.',
	'Another role already exists by that name.' => 'Un autre rôle existe déjà avec ce nom.',
	'You cannot define a role without permissions.' => 'Vous ne pouvez pas définir un rôle sans autorisations.',
	'No permissions.' => 'Pas d\'autorisations.',
	'No such entry \'[_1]\'' => 'Aucune note du type \'[_1]\'',
	'No email address for user \'[_1]\'' => 'L\'utilisateur \'[_1]\' ne possède pas d\'adresse e-mail',
	'No valid recipients found for the entry notification.' => 'Aucun destinataire valide n\'a été trouvé pour la notification de cette note.',
	'[_1] Update: [_2]' => '[_1] Mise à jour : [_2]',
	'Error sending mail ([_1]); try another MailTransfer setting?' => 'Erreur lors de l\'envoi de l\'e-mail ([_1]); Essayer avec d\'autres paramètres pour MailTransfer ?',
	'Archive Root' => 'Archive Racine',
	'Site Root' => 'Site Racine',
	'Upload File' => 'Télécharger un fichier',
	'Can\'t load blog #[_1].' => 'Impossible de charger le blog #[_1].',
	'Please select a file to upload.' => 'Merci de sélectionner un fichier à envoyer.',
	'Invalid filename \'[_1]\'' => 'Nom de fichier invalide \'[_1]\'',
	'Please select an audio file to upload.' => 'Merci de sélectionner un fichier audio à envoyer.',
	'Please select an image to upload.' => 'Merci de sélectionner une image à envoyer.',
	'Please select a video to upload.' => 'Merci de sélectionner une vidéo à envoyer.',
	'Before you can upload a file, you need to publish your blog.' => 'Avant de pouvoir envoyer un fichier, vous devez publier votre blog.',
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
	'Search & Replace' => 'Rechercher et Remplacer',
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
	'Invalid date(s) specified for date range.' => 'Date(s) incorrecte(s) pour la sélection de calendrier.',
	'Error in search expression: [_1]' => 'Erreur dans la recherche de l expression : [_1]',
	'Saving object failed: [_2]' => 'La sauvegarde des objets a échoué : [_2]',
	'Load of blog \'[_1]\' failed: [_2]' => 'Le chargement du blog \'[_1]\' a échoué : [_2]',
	'You do not have export permissions' => 'Vous n\'avez pas les droits d\'exportation',
	'You do not have import permissions' => 'Vous n\'avez pas les droits d\'importation',
	'You do not have permission to create users' => 'Vous n\'avez pas l\'autorisation de créer des utilisateurs',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'Vous devez fournir un mot de passe si vous allez créer de nouveaux utilisateurs pour chaque utilisateur listé dans votre blog.',
	'Importer type [_1] was not found.' => 'Type d\'importeur [_1] non trouvé.',
	'Saving map failed: [_1]' => 'Échec lors du rattachement: [_1]',
	'Add a [_1]' => 'Ajouter un [_1]',
	'No label' => 'Pas d\'étiquette',
	'Category name cannot be blank.' => 'Le nom de la catégorie ne peut pas être vide.',
	'Populating blog with default templates failed: [_1]' => 'L\'activation sur le blog des gabarits par défaut a échoué : [_1]',
	'Setting up mappings failed: [_1]' => 'La mise en oeuvre des mappings a échoué : [_1]',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Erreur: Movable Type ne peut pas écrire dans le répertoire de cache de gabarits. Merci de vérifier les autorisations du répertoire <code>[_1]</code> situé dans le répertoire du blog.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Erreur: Movable Type n\'a pas pu créer un répertoire pour cacher vos gabarits dynamiques. Vous devez créer un répertoire nommé <code>[_1]</code> dans le répertoire de votre blog.',
	'That action ([_1]) is apparently not implemented!' => 'Cette action ([_1]) n\'est visiblement pas implémentée!',
	'Error saving entry: [_1]' => 'Erreur d\'enregistrement de la note: [_1]',
	'Select Blog' => 'Sélectionner un blog',
	'Selected Blog' => 'Blog sélectionné',
	'Type a blog name to filter the choices below.' => 'Entrez le nom d\'un blog pour affiner les résultats ci-dessous.',
	'Select a System Administrator' => 'Sélectionner un administrateur système',
	'Selected System Administrator' => 'Administrateur système sélectionné',
	'Type a username to filter the choices below.' => 'Tapez un nom d\'utilisateur pour affiner les choix ci-dessous.',
	'System Administrator' => 'Administrateur Système',
	'Error saving file: [_1]' => 'Erreur en sauvegardant le fichier: [_1]',
	'represents a user who will be created afterwards' => 'représente un utilisateur qui sera créé ensuite',
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
	'Backup' => 'Sauvegarder',
	'Backup & Restore' => 'Sauvegarder & Restaurer',
	'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.' => 'Le répertoire temporaire doit être autorisé en écriture pour que la sauvegarde puisse fonctionner. Merci de vérifier la directive de configuration TempDir.',
	'Temporary directory needs to be writable for restore to work correctly.  Please check TempDir configuration directive.' => 'Le répertoire temporaire doit être autorisé en écriture pour que la restauration puisse fonctionner. Merci de vérifier la directive de configuration TempDir.',
	'Blog(s) (ID:[_1]) was/were successfully backed up by user \'[_2]\'' => 'Blog(s) (ID:[_1]) a/ont été sauvegardé(s) avec succès par l\'utilisateur \'[_2]\'',
	'Movable Type system was successfully backed up by user \'[_1]\'' => 'Movable Type a été sauvegardé avec succès par l\'utilisateur \'[_1]\'',
	'[_1] is not a number.' => '[_1] n\'est pas un nombre.',
	'Copying file [_1] to [_2] failed: [_3]' => 'La copie du fichier [_1] vers [_2] a échoué: [_3]',
	'Specified file was not found.' => 'Le fichier spécifié n\'a pas été trouvé.',
	'[_1] successfully downloaded backup file ([_2])' => '[_1] a téléchargé avec succès le fichier de sauvegarde ([_2])',
	'Restore' => 'Restaurer',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Merci d\'utiliser xml, tar.gz, zip, ou manifest comme extension de fichier.',
	'Unknown file format' => 'Format de fichier inconnu',
	'Some [_1] were not restored because their parent objects were not restored.' => 'Certains [_1] n\'ont pas été restaurés car leurs objets parents n\'ont pas été restaurés.',
	'Some objects were not restored because their parent objects were not restored.  Detailed information is in the <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">activity log</a>.' => 'Certains objets n\'ont pas été restaurés car leurs objets parents n\'ont pas été restaurés. Des informations détaillées se trouvent dans le <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">journal d\'activité</a>.',
	'Successfully restored objects to Movable Type system by user \'[_1]\'' => 'Restauration avec succès des objets dans Movable Type par utilisateur \'[_1]\'',
	'[_1] is not a directory.' => '[_1] n\'est pas un répertoire.',
	'Error occured during restore process.' => 'Une erreur s\'est produite pendant la procédure de restauration.',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ',
	'Some of files could not be restored.' => 'Certains fichiers n\'ont pu être restaurés.',
	'Please upload [_1] in this page.' => 'Merci d\'envoyer [_1] dans cette page.',
	'File was not uploaded.' => 'Le fichier n\'a pas été envoyé.',
	'Restoring a file failed: ' => 'Échec lors de la restauration d\'un fichier : ',
	'Some objects were not restored because their parent objects were not restored.' => 'Certains objets n\'ont pas été restaurés car leurs objets parents n\'ont pas été restaurés.',
	'Some of the files were not restored correctly.' => 'Certains fichiers n\'ont pas été restaurés correctement.',
	'Detailed information is in the <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>activity log</a>.' => 'Des informations détaillées se trouvent dans le <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>journal (logs)</a>.',
	'[_1] has canceled the multiple files restore operation prematurely.' => '[_1] a annulé prématurément l\'opération de restauration de plusieurs fichiers.',
	'Changing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Changement du chemin du site pour le blog \'[_1]\' (ID:[_2])...',
	'Removing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Suppression du chemin du site pour le blog \'[_1]\' (ID:[_2])...',
	'Changing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Changement du chemin d\'archive pour le blog \'[_1]\' (ID:[_2])...',
	'Removing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Suppression du chemin d\'archive pour le blog \'[_1]\' (ID:[_2])...',
	'failed' => 'échec',
	'ok' => 'ok',
	'Changing file path for the asset \'[_1]\' (ID:[_2])...' => 'Changement de chemin de fichier pour l\'élément \'[_1]\' (ID:[_2])...',
	'Some of the actual files for assets could not be restored.' => 'Certains des fichiers des éléments n\'ont pu être restaurés.',
	'Parent comment id was not specified.' => 'id du commentaire parent non spécifié.',
	'Parent comment was not found.' => 'Commentaire parent non trouvé.',
	'You can\'t reply to unapproved comment.' => 'Vous ne pouvez répondre à un commentaire non approuvé.',
	'You can\'t reply to unpublished comment.' => 'Vous ne pouvez pas répondre à un commentaire non publié.',
	'Error creating new template: ' => 'Erreur pendant la création du nouveau gabarit : ',
	'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Saut du gabarit \'[_1]\' car c\'est un gabarit personnalisé.',
	'Refreshing template <strong>[_3]</strong> with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>' => 'Réactualiser les gabarits <strong>[_3]</strong> depuis <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">la sauvegarde</a>',
	'Skipping template \'[_1]\' since it has not been changed.' => 'Saut du gabarit \'[_1]\' car il n\'a pas été modifié',
	'entries' => 'notes',
	'This is You' => 'C\'est vous',
	'Handy Shortcuts' => 'Raccourcis pratiques',
	'Movable Type News' => 'Actualités Movable Type',
	'Blog Stats' => 'Statistiques du blog',
	'Refresh Blog Templates' => 'Mettre à jour les gabarits du blog',
	'Refresh Global Templates' => 'Mettre à jour les gabarits globaux',
	'Publish Entries' => 'Publier les notes',
	'Unpublish Entries' => 'Annuler publication',
	'Add Tags...' => 'Ajouter des tags...',
	'Tags to add to selected entries' => 'Tags à ajouter aux notes sélectionnées',
	'Remove Tags...' => 'Enlever les tags...',
	'Tags to remove from selected entries' => 'Tags à enlever des notes sélectionnées',
	'Batch Edit Entries' => 'Modifier des notes par lot',
	'Publish Pages' => 'Publier les pages',
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
	'Publish Template(s)' => 'Publier le(s) Gabarit(s)',
	'Non-spam TrackBacks' => 'Trackbacks marqués comme n\'étant pas du spam',
	'TrackBacks on my entries' => 'Trackbacks sur mes entrées',
	'Published TrackBacks' => 'Trackbacks publiés',
	'Unpublished TrackBacks' => 'Tracbacks non publiés',
	'TrackBacks marked as Spam' => 'Trackbacks marqués comme spam',
	'All TrackBacks in the last 7 days' => 'Tous les trackbacks des 7 derniers jours',
	'Non-spam Comments' => 'Commentaires marqués comme n\'étant pas du spam',
	'Comments on my entries' => 'Commentaires sur mes notes',
	'Pending comments' => 'Commentaires en attente',
	'Spam Comments' => 'Commentaires marqués comme étant du spam',
	'Published comments' => 'Commentaires publiés.',
	'My comments' => 'Mes commentaires',
	'Comments in the last 7 days' => 'Commentaires des 7 derniers jours',
	'All comments in the last 24 hours' => 'Tous les commentaires dans les dernières 24 heures',
	'Index Templates' => 'Gabarits d\'index',
	'Archive Templates' => 'Gabarits d\'archives',
	'Template Modules' => 'Modules de gabarits',
	'E-mail Templates' => 'Gabarits des emails',
	'Backup Templates' => 'Gabartis des sauvegardes',
	'System Templates' => 'Gabarits système',
	'Tags with entries' => 'Tags avec les notes',
	'Tags with pages' => 'Tags avec les pages',
	'Tags with assets' => 'Tags avec les éléments',
	'Enabled Users' => 'Utilisateurs activés',
	'Disabled Users' => 'Utilisateurs désactivés',
	'Pending Users' => 'Utilisateurs en attente',
	'Authors' => 'Auteurs',
	'Create' => 'Créer',
	'Manage' => 'Gérer',
	'Design' => 'Design',
	'Preferences' => 'Préférences',
	'Tools' => 'Outils',
	'Folders' => 'Répertoires',
	'General' => 'Général',
	'Feedback' => 'Feedback',
	'Plugins' => 'Plugins',
	'Blog Settings' => 'Paramètres du blog',
	'Address Book' => 'Carnet d\'adresses',
	'System Information' => 'Informations système',
	'Import' => 'Importer',
	'Export' => 'Exporter',
	'System Overview' => 'Vue d\'ensemble',
	'/' => '/',
	'<' => '<',

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
	'Publishing: [quant,_1,file,files]...' => 'Publication : [quant,_1,fichier,fichiers]',
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- configuration terminée ([quant,_1,fichier,fichiers] dans [_2] secondes)',

## lib/MT/BasicAuthor.pm
	'authors' => 'auteurs',

## lib/MT/Placement.pm
	'Category Placement' => 'Gestion des catégories',

## lib/MT/TaskMgr.pm
	'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'Impossible d\'assurer le vérrouillage pour l\'éxécution de tâches système. Vérifiez que la zone TempDir ([_1]) est ouverte en écriture.',
	'Error during task \'[_1]\': [_2]' => 'Erreur pendant la tâche \'[_1]\' : [_2]',
	'Scheduled Tasks Update' => 'Mise à jour des tâches planifiées',
	'The following tasks were run:' => 'Les tâches suivantes ont été exécutées :',

## lib/MT/Page.pm
	'Folder' => 'Répertoire',
	'Load of blog failed: [_1]' => 'Échec lors du chargement du blog : [_1]',

## lib/MT/Bootstrap.pm
	'Got an error: [_1]' => 'Erreur de type : [_1]',

## lib/MT/Category.pm
	'Categories must exist within the same blog' => 'Les catégories doivent exister au sein du même blog ',
	'Category loop detected' => 'Boucle de catégorie détectée',

## lib/MT/Asset.pm
	'Location' => 'Adresse',

## lib/MT/Image.pm
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Le module Perl Image::Size est requis pour déterminer la largeur et la hauteur des images téléchargées.',
	'File size exceeds maximum allowed: [_1] > [_2]' => 'La taille du fichier dépasse le maximum autorisé: [_1] > [_2]',
	'Can\'t load Image::Magick: [_1]' => 'Impossible de charger Image::Magick : [_1]',
	'Reading file \'[_1]\' failed: [_2]' => 'La lecture du fichier \'[_1]\' a échoué : [_2]',
	'Reading image failed: [_1]' => 'Échec lors de la lecture de l\'image : [_1]',
	'Scaling to [_1]x[_2] failed: [_3]' => 'La mise à l\'échelle vers [_1]x[_2] a échoué : [_3]',
	'Cropping a [_1]x[_1] square at [_2],[_3] failed: [_4]' => 'Retaillage d\'un carré [_1]x[_1] à [_2],[_3] échoué: [_4]',
	'Converting image to [_1] failed: [_2]' => 'Conversion de l\'image vers [_1] a échoué: [_2]',
	'Can\'t load IPC::Run: [_1]' => 'Impossible de charger IPC::Run : [_1]',
	'Cropping to [_1]x[_1] failed: [_2]' => 'Retaillage vers [_1]x[_1] échoué: [_2]',
	'Converting to [_1] failed: [_2]' => 'Conversion vers [_1] a échoué: [_2]',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'Votre chemin d\'accès vers les outils NetPBM n\'est pas valide sur votre machine.',

## lib/MT/Session.pm
	'Session' => 'Session',

## lib/MT/Trackback.pm
	'TrackBack' => 'Trackback',

## lib/MT/Notification.pm
	'Contact' => 'Contact',
	'Contacts' => 'Contacts',

## lib/MT/Upgrade.pm
	'Comment Posted' => 'Commentaire envoyé',
	'Your comment has been posted!' => 'Votre commentaire a été envoyé !',
	'[_1]: [_2]' => '[_1]: [_2]',
	'Migrating Nofollow plugin settings...' => 'Migration des paramètres du plugin Nofollow...',
	'Updating system search template records...' => 'Mise à jour des données du gabarit de recherche du système...',
	'Custom ([_1])' => '([_1]) personnalisé ',
	'This role was generated by Movable Type upon upgrade.' => 'Ce rôle a été généré par Movable Type lors d\'une mise à jour.',
	'Migrating permission records to new structure...' => 'Migration des données d\'autorisation vers une nouvelle structure...',
	'Migrating role records to new structure...' => 'Migration des données de rôle vers la nouvelle structure...',
	'Migrating system level permissions to new structure...' => 'Migration des autorisations pour tout le système vers la nouvelle structure...',
	'Invalid upgrade function: [_1].' => 'Fonction de mise à jour invalide : [_1].',
	'Error loading class [_1].' => 'Erreur en chargeant la classe [_1].',
	'Creating initial blog and user records...' => 'Création des données initiales du blog et de l\'utilisateur...',
	'Error saving record: [_1].' => 'Erreur de l\'enregistrement des informations : [_1].',
	'First Blog' => 'Premier blog',
	'I just finished installing Movable Type [_1]!' => 'Je viens d\'installer Movable Type [_1]!',
	'Welcome to my new blog powered by Movable Type. This is the first post on my blog and was created for me automatically when I finished the installation process. But that is ok, because I will soon be creating posts of my own!' => 'Bienvenue sur mon nouveau blog animé par Movable Type. Ceci est la première note de mon blog. Elle a été créée automatiquement lorsque j\'ai terminé mon installation. Mais je vais maintenant créer mes propres articles!',
	'Movable Type also created a comment for me as well so that I could see what a comment will look like on my blog once people start submitting comments on all the posts I will write.' => 'Movable Type a aussi créé un commentaire automatiquement pour me permettre de voir à quoi cela ressemblera lorsque mes lecteurs commenteront mes notes.',
	'Blog Administrator' => 'Administrateur du blog',
	'Can administer the blog.' => 'Peut administrer le blog.',
	'Editor' => 'Éditeur',
	'Can upload files, edit all entries/categories/tags on a blog and publish the blog.' => 'Peut télécharger des fichiers, éditer les notes/catégories/tags sur un blog donné et le republier.',
	'Can create entries, edit their own, upload files and publish.' => 'Peut créer des notes, modifier ses notes, envoyer des fichiers et publier.',
	'Designer' => 'Designer',
	'Can edit, manage and publish blog templates.' => 'Peut éditer, gérer et republier les templates des blogs.',
	'Webmaster' => 'Webmaster',
	'Can manage pages and publish blog templates.' => 'Peut gérer les pages et republier les templates des blogs.',
	'Contributor' => 'Contributeur',
	'Can create entries, edit their own and comment.' => 'Peut créer des notes, modifier ses notes et commenter.',
	'Moderator' => 'Modérateur',
	'Can comment and manage feedback.' => 'Peut commenter et gérer les commentaires.',
	'Can comment.' => 'Peut commenter.',
	'Removing Dynamic Site Bootstrapper index template...' => 'Suppression du gabarit index Dynamic Site Bootstrapper',
	'Creating new template: \'[_1]\'.' => 'Creation d\'un nouveau gabarit: \'[_1]\'.',
	'Mapping templates to blog archive types...' => 'Mapping des gabarits vers les archives des blogs...',
	'Renaming PHP plugin file names...' => 'Renommage des noms de fichier des plugins php...',
	'Error renaming PHP files. Please check the Activity Log.' => 'Erreur pendant le renommage des fichiers PHP. Merci de vérifier le journal (logs).',
	'Cannot rename in [_1]: [_2].' => 'Impossible de renommer dans [_1]: [_2].',
	'Updating widget template records...' => 'Mise à jour des données du gabarit de widget...',
	'Removing unused template maps...' => 'Suppression des mappages de gabarits non-utilisés...',
	'Upgrading table for [_1] records...' => 'Mise à jour des tables pour [_1] les enregistrements...',
	'Upgrading database from version [_1].' => 'Mise à jour de la Base de données de la version [_1].',
	'Database has been upgraded to version [_1].' => 'La base de données a été mise à jour version [_1].',
	'User \'[_1]\' upgraded database to version [_2]' => 'L\'utilisateur \'[_1]\' a mis à jour la base de données avec la version [_2]',
	'Plugin \'[_1]\' upgraded successfully to version [_2] (schema version [_3]).' => 'Plugin \'[_1]\' mis à jour avec succès à la version [_2] (schéma version [_3]).',
	'User \'[_1]\' upgraded plugin \'[_2]\' to version [_3] (schema version [_4]).' => 'Utilisateur \'[_1]\' a mis à jour le plugin \'[_2]\' vers la version [_3] (schéma version [_4]).',
	'Plugin \'[_1]\' installed successfully.' => 'Le Plugin \'[_1]\' a été installé correctement.',
	'User \'[_1]\' installed plugin \'[_2]\', version [_3] (schema version [_4]).' => 'Utilisateur \'[_1]\' a installé le plugin \'[_2]\', version [_3] (schéma version [_4]).',
	'Setting your permissions to administrator.' => 'Paramètre des autorisations pour l\'administrateur.',
	'Comment Response' => 'Réponse au commentaire',
	'Creating configuration record.' => 'Création des infos de configuration.',
	'Creating template maps...' => 'Création des mappages de gabarits...',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'Lien du gabarit [_1] vers [_2] ([_3]).',
	'Mapping template ID [_1] to [_2].' => 'Lien du gabarit [_1] vers [_2].',
	'Error loading class: [_1].' => 'Erreur de chargement de classe : [_1].',
	'Error saving [_1] record # [_3]: [_2]... [_4].' => 'Erreur de sauvegarde [_1] enregistrement # [_3]: [_2]... [_4]',
	'Creating entry category placements...' => 'Création des placements des catégories des notes...',
	'Updating category placements...' => 'Modification des placements de catégories...',
	'Assigning comment/moderation settings...' => 'Mise en place des paramètres commentaire/modération ...',
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
	'Assigning custom dynamic template settings...' => 'Attribution des paramètres spécifiques de template dynamique...',
	'Assigning user types...' => 'Attribution des types d\'utilisateurs...',
	'Assigning category parent fields...' => 'Attribution des champs parents de la catégorie...',
	'Assigning template build dynamic settings...' => 'Attribution des paramètres de construction dynamique du template...',
	'Assigning visible status for comments...' => 'Attribution du statut visible pour les commentaires...',
	'Assigning junk status for comments...' => 'Attribution du statut spam pour les commentaires...',
	'Assigning visible status for TrackBacks...' => 'Attribution du statut visible des trackbacks...',
	'Assigning junk status for TrackBacks...' => 'Attribution du statut spam pour les trackbacks...',
	'Assigning basename for categories...' => 'Attribution de racines aux catégories...',
	'Assigning user status...' => 'Attribution du statut utilisateur...',
	'Migrating permissions to roles...' => 'Migration des autorisations vers les rôles...',
	'Populating authored and published dates for entries...' => 'Mise en place des dates de création et de publication des notes...',
	'Classifying category records...' => 'Classement des données des catégories...',
	'Classifying entry records...' => 'Classement des données des notes...',
	'Merging comment system templates...' => 'Assemblage des gabarits du système de commentaire...',
	'Populating default file template for templatemaps...' => 'Mise en place du fichier gabarit par défaut pour les templatemaps...',
	'Assigning user authentication type...' => 'Attribution du type d\'authentification utilisateur...',
	'Adding new feature widget to dashboard...' => 'Ajout du nouveau widget au tableau de bord...',
	'Moving OpenID usernames to external_id fields...' => 'Déplacement des identifiants OpenID vers les champs external_id...',
	'Assigning blog template set...' => 'Attribution du groupe de gabarits de blogs',

## lib/MT/Core.pm
	'Create Blogs' => 'Créer des blogs',
	'Manage Plugins' => 'Gérer les plugins',
	'Manage Templates' => 'Gérer les gabarits',
	'View System Activity Log' => 'Afficher le journal (logs) du système',
	'Configure Blog' => 'Configurer le blog',
	'Set Publishing Paths' => 'Régler les chemins de publication',
	'Manage Categories' => 'Gérer les catégories',
	'Manage Tags' => 'Gérer les tags',
	'Manage Address Book' => 'Gestion de l\'annuaire',
	'View Activity Log' => 'Afficher le journal (logs)',
	'Create Entries' => 'Création d\'une note',
	'Send Notifications' => 'Envoyer des notifications',
	'Edit All Entries' => 'Éditer toutes les entrées',
	'Manage Pages' => 'Gérer les pages',
	'Publish Blog' => 'Publier le Blog',
	'Save Image Defaults' => 'Enregistrer les paramètres d\'images par défaut',
	'Manage Assets' => 'Gérer les Élements',
	'Post Comments' => 'Commentaires de la note',
	'Manage Feedback' => 'Gérer les retours',
	'MySQL Database' => 'Base de données MySQL',
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
	'Include Template Module' => 'Inclure un gabarit de module',
	'Include Template File' => 'Inclure un gabarit de fichier',
	'Get Variable' => 'Récupérer la variable',
	'Set Variable' => 'Spécifier la variable',
	'Set Variable Block' => 'Spécifier le bloc de variable',
	'Publish Scheduled Entries' => 'Publier les notes planifiées',
	'Junk Folder Expiration' => 'Expiration du répertoire de spam',
	'Remove Temporary Files' => 'Supprimer les fichiers temporaires',
	'Remove Expired User Sessions' => 'Supprimer les sessions utilisateur expirées',

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
	'Error making path \'[_1]\': [_2]' => 'Erreur dans le chemin \'[_1]\' : [_2]',
	'Copying [_1] to [_2]...' => 'Copie de [_1] vers [_2]...',
	'Failed: ' => 'Échec: ',
	'Done.' => 'Terminé.',
	'Restoring asset associations ... ( [_1] )' => 'Restauration les associations d\'élements ... ([_1])',
	'Restoring asset associations in entry ... ( [_1] )' => 'Restauration des associations d\'élements dans la note ... ([_1])',
	'Restoring asset associations in page ... ( [_1] )' => 'Restauration des associations d\'élements dans la page... ([_1])',
	'Restoring url of the assets ( [_1] )...' => 'Restauration de l\'url de l\'élement ([_1]) ...',
	'Restoring url of the assets in entry ( [_1] )...' => 'Restauration de l\'url de l\'élement dans la note ([_1]) ...',
	'Restoring url of the assets in page ( [_1] )...' => 'Restauration de l\'url de l\'élement dans la page ([_1]) ...',
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
	'No default templates were found.' => 'Aucun gabarit par défaut trouvé.',
	'Cloned blog... new id is [_1].' => 'Le nouvel identifiant du blog cloné est [_1]',
	'Cloning permissions for blog:' => 'Clonage des autorisations du blog:',
	'[_1] records processed...' => '[_1] enregistrements effectués...',
	'[_1] records processed.' => '[_1] enregistrements effectués.',
	'Cloning associations for blog:' => 'Clonage des associations du blog:',
	'Cloning entries for blog...' => 'Clonage des notes du blog...',
	'Cloning categories for blog...' => 'Clonage des catégories du blog...',
	'Cloning entry placements for blog...' => 'Clonage des placements de notes du blog...',
	'Cloning comments for blog...' => 'Clonage des commentaires de blog...',
	'Cloning entry tags for blog...' => 'Clonage des tags de notes du blog...',
	'Cloning TrackBacks for blog...' => 'Clonage des trackbacks du blog...',
	'Cloning TrackBack pings for blog...' => 'Clonage des pings de trackback du blog...',
	'Cloning templates for blog...' => 'Clonage des gabarits du blog...',
	'Cloning template maps for blog...' => 'Clonage des mappages de gabarit du blog...',
	'blog' => 'Blog',
	'blogs' => 'Blogs',

## lib/MT/TBPing.pm

## lib/MT/Builder.pm
	'<[_1]> at line [_2] is unrecognized.' => '<[_1]> à la ligne [_2] n\'est pas reconnu.',
	'<[_1]> with no </[_1]> on line #' => '<[_1]> sans </[_1]> à la ligne #',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]> sans </[_1]> à la ligne [_2].',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]> sans </[_1]> à la ligne [_2]',
	'Error in <mt:[_1]> tag: [_2]' => 'Erreur dans balise <mt:[_1]> : [_2]',
	'Unknown tag found: [_1]' => 'Un tag inconnu a été trouvé : [_1]',

## lib/MT/ObjectScore.pm
	'Object Score' => 'Score Objet',
	'Object Scores' => 'Scores Objet',

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
	'First Weblog' => 'Premier Blog',
	'Error loading blog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => 'Erreur de chargement #[_1] concernant la création Utilisateur. Veuillez vérifier vos paramètres NewUserTemplateBlogId.',
	'Error provisioning blog for new user \'[_1]\' using template blog #[_2].' => 'Erreur de création du blog pour le nouvel utilisateur  \'[_1]\' utilisant le template #[_2].',
	'Error creating directory [_1] for blog #[_2].' => 'Erreur lors de la création de la liste [_1] pour le blog #[_2].',
	'Error provisioning blog for new user \'[_1] (ID: [_2])\'.' => 'Erreur de création du blog pour le nouvel utilisateur \'[_1] (ID: [_2])\'.',
	'Blog \'[_1] (ID: [_2])\' for user \'[_3] (ID: [_4])\' has been created.' => 'Le blog \'[_1] (ID: [_2])\' pour l\'utilisateur \'[_3] (ID: [_4])\' a été créé.',
	'Error assigning blog administration rights to user \'[_1] (ID: [_2])\' for blog \'[_3] (ID: [_4])\'. No suitable blog administrator role was found.' => 'Erreur d\'assignation des droits pour l\'utilisateur \'[_1] (ID: [_2])\' pour le blog \'[_3] (ID: [_4])\'. Aucun rôle d\'administrateur adéquat n\'a été trouvé.',
	'The login could not be confirmed because of a database error ([_1])' => 'L\'identifiant ne peut pas être confirmé en raison d\'une erreur de base de données ([_1])',
	'Our apologies, but you do not have permission to access any blogs within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Désolé, mais vous n\'avez pas l\'authorisation d\'accéder aux blogs de cette installation. Si vous pensez qu\'il s\'agit d\'une erreur, merci de contacter votre administrateur Movable Type.',
	'This account has been disabled. Please see your system administrator for access.' => 'Ce compte a été désactivé. Merci de contacter votre administrateur système.',
	'Failed login attempt by pending user \'[_1]\'' => 'Tentative d\'identification échouée par l\'utilisateur en attente \'[_1]\'',
	'This account has been deleted. Please see your system administrator for access.' => 'Ce compte a été supprimé. Merci de contacter votre administrateur système.',
	'User cannot be created: [_1].' => 'L\'utilisateur n\'a pu être créé: [_1].',
	'User \'[_1]\' has been created.' => 'L\'utilisateur \'[_1]\' a été créé ',
	'User \'[_1]\' (ID:[_2]) logged in successfully' => 'L\'utilisateur \'[_1]\' (ID:[_2]) s\'est identifié correctement',
	'Invalid login attempt from user \'[_1]\'' => 'Tentative d\'authentification invalide de l\'utilisateur \'[_1]\'',
	'User \'[_1]\' (ID:[_2]) logged out' => 'L\'utilisateur \'[_1]\' (ID:[_2]) s\'est déconnecté',
	'User requires password.' => 'L\'utilisateur doit avoir un mot de passe.',
	'User requires password recovery word/phrase.' => 'L\'utilisateur doit avoir un indice de récupération du mot de passe.',
	'User requires username.' => 'L\'utilisateur doit avoir un nom d\'utilisateur.',
	'User requires display name.' => 'L\'utilisateur doit avoir un nom public.',
	'Email Address is required for password recovery.' => 'Une adresse email est obligatoire pour récupérer le mot de passe.',
	'Something wrong happened when trying to process signup: [_1]' => 'Un problème s\'est produit en essayant de soumettre l\'inscription: [_1]',
	'New Comment Added to \'[_1]\'' => 'Nouveau commentaire ajouté à \'[_1]\'',
	'Close' => 'Fermer',
	'The file you uploaded is too large.' => 'Le fichier téléchargé est trop lourd.',
	'Unknown action [_1]' => 'Action inconnue [_1]',
	'Warnings and Log Messages' => 'Mises en gardes et entrées du Journal (logs)',
	'Removed [_1].' => '[_1] supprimés.',

## lib/MT/Log.pm
	'System' => 'Système',
	'Page # [_1] not found.' => 'Page # [_1] non trouvée.',
	'Entry # [_1] not found.' => 'Note # [_1] non trouvée.',
	'Comment # [_1] not found.' => 'Commentaire # [_1] non trouvé.',
	'TrackBack # [_1] not found.' => 'Trackback # [_1] non trouvé.',

## lib/MT/IPBanList.pm
	'IP Ban' => 'Interdiction IP',
	'IP Bans' => 'Interdictions IP',

## lib/MT/AtomServer.pm
	'PreSave failed [_1]' => 'Échec lors du pré-enregistrement [_1]',
	'User \'[_1]\' (user #[_2]) added [lc,_4] #[_3]' => 'L\'Utilisateur \'[_1]\' (utilisateur #[_2]) a ajouté [lc,_4] #[_3]',
	'User \'[_1]\' (user #[_2]) edited [lc,_4] #[_3]' => 'L\'Utilisateur \'[_1]\' (L\'Utilisateur #[_2]) a édité [lc,_4] #[_3]',

## lib/MT/PluginData.pm
	'Plugin Data' => 'Données Plugin',

## lib/MT/Plugin.pm
	'Publish' => 'Publier',
	'My Text Format' => 'Format de mon texte.',

## lib/MT/Role.pm
	'Role' => 'Rôle',

## lib/MT/Entry.pm
	'Draft' => 'Brouillon',
	'Review' => 'Vérification',
	'Future' => 'Futur',

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
	'Comment Listing' => 'Liste des commentaires',
	'Ping Listing' => 'Liste des pings',
	'Comment Preview' => 'Pré visualisation du commentaire',
	'Comment Error' => 'Erreur de commentaire',
	'Dynamic Error' => 'Erreur dynamique',
	'Uploaded Image' => 'Image chargée',
	'Module' => 'Module',
	'Widget' => 'Widget',

## lib/MT/ImportExport.pm
	'No Blog' => 'Pas de Blog',
	'Need either ImportAs or ParentAuthor' => 'ImportAs ou ParentAuthor sont nécessaires',
	'Creating new user (\'[_1]\')...' => 'Création d\'un nouvel utilisateur (\'[_1]\')...',
	'Saving user failed: [_1]' => 'Échec lors de la sauvegarde de l\'utilisateur : [_1]',
	'Assigning permissions for new user...' => 'Mise en place des autorisations pour le nouvel utilisateur...',
	'Saving permission failed: [_1]' => 'Échec lors de la sauvegarde des droits des utilisateurs : [_1]',
	'Creating new category (\'[_1]\')...' => 'Création d\'une nouvelle catégorie (\'[_1]\')...',
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

## lib/MT/JunkFilter.pm
	'Action: Junked (score below threshold)' => 'Action : Indésirable (score ci-dessous)',
	'Action: Published (default action)' => 'Action : Publié (action par défaut)',
	'Junk Filter [_1] died with: [_2]' => 'Filtre indésirable [_1] mort avec : [_2]',
	'Unnamed Junk Filter' => 'Filtre indésirable sans nom',
	'Composite score: [_1]' => 'Score composite : [_1]',

## lib/MT/Util.pm
	'moments from now' => 'maintenant',
	'moments ago' => 'il y a quelques instants',
	'[quant,_1,hour,hours] from now' => 'dans [quant,_1,heure,heures]',
	'[quant,_1,hour,hours] ago' => 'il y a [quant,_1,heure,heures]',
	'[quant,_1,minute,minutes] from now' => 'dans [quant,_1,minute,minutes]',
	'[quant,_1,minute,minutes] ago' => 'il y a [quant,_1,minute,minutes]',
	'[quant,_1,day,days] from now' => 'dans [quant,_1,jour,jours]',
	'[quant,_1,day,days] ago' => 'il y a [quant,_1,jour,jours]',
	'less than 1 minute from now' => 'moins d\'une minute à partir de maintenant',
	'less than 1 minute ago' => 'il y a moins d\'une minute',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => 'dans [quant,_1,heure,heures], [quant,_2,minute,minutes]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => 'il y a [quant,_1,heure,heures], [quant,_2,minute,minutes]',
	'[quant,_1,day,days], [quant,_2,hour,hours] from now' => 'dans [quant,_1,jour,jours], [quant,_2,heure,heures]',
	'[quant,_1,day,days], [quant,_2,hour,hours] ago' => 'il y a [quant,_1,jour,jours], [quant,_2,heure,heures]',

## lib/MT/Mail.pm
	'Unknown MailTransfer method \'[_1]\'' => 'Méthode de transfert de mail inconnu \'[_1]\'',
	'Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]' => 'Pour envoyer des mails via SMTP, votre serveur doit avoir Mail::Sendmail installé: [_1]',
	'Error sending mail: [_1]' => 'Erreur lors de l\'envoi du mail : [_1]',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'Vous n\'avez pas un chemin valide vers sendmail sur votre machine. Peut-être devriez-vous essayer en utilisant SMTP?',
	'Exec of sendmail failed: [_1]' => 'Échec lors de l\'exécution de sendmail : [_1]',

## lib/MT/Permission.pm
	'Permission' => 'Autorisation',
	'Permissions' => 'Autorisations',

## lib/MT/Scorable.pm
	'Object must be saved first.' => 'L\'objet doit être d\'abord sauvegardé.',
	'Already scored for this object.' => 'Cet objet a déjà été noté',
	'Could not set score to the object \'[_1]\'(ID: [_2])' => 'Impossible de stocker le score de l\'objet \'[_1]\'(ID: [_2])',

## lib/MT/XMLRPCServer.pm
	'Invalid timestamp format' => 'Format de date invalide',
	'No web services password assigned.  Please see your user profile to set it.' => 'Aucun mot de passe associé aux services web. Merci de vérifier votre profil utilisateur pour le définir.',
	'Requested permalink \'[_1]\' is not available for this page' => 'Le lien permanent requis  \'[_1]\' n\'est pas disponible pour cette page',
	'Saving folder failed: [_1]' => 'Echec lors de la sauvegarde du répertoire : [_1]',
	'No blog_id' => 'Pas de blog_id',
	'Invalid blog ID \'[_1]\'' => 'ID du blog invalide \'[_1]\'',
	'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => 'Valeur pour \'mt_[_1]\' doit être 1 ou 0 (était \'[_2]\')',
	'Not privileged to edit entry' => 'Non détenteur des droits d\'édition de notes',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'La note \'[_1]\' ([lc,_5] #[_2]) a été supprimée par \'[_3]\' (utilisateur #[_4]) depuis xml-rpc',
	'Not privileged to get entry' => 'Non détenteur des droits de possession de notes',
	'Not privileged to set entry categories' => 'Non détenteur des droits d\'affectation des catégories d\'une note',
	'Not privileged to upload files' => 'Non détenteur des droits de téléchargement de fichiers',
	'No filename provided' => 'Aucun nom de fichier',
	'Error writing uploaded file: [_1]' => 'Erreur lors de l\'écriture du fichier téléchargé : [_1]',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Les méthodes de gabarit ne sont pas implémentée en raison d\'une différence entre l\'API Blogger et l\'API Movable Type.',

## lib/MT/WeblogPublisher.pm
	'yyyy/index.html' => 'aaaa/index.html',
	'yyyy/mm/index.html' => 'aaaa/mm/index.html',
	'yyyy/mm/day-week/index.html' => 'aaaa/mm/jour-semaine/index.html',
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
	'folder-path/page-basename.html' => 'chemin-repertoire/nomdebase-page.html',
	'folder-path/page-basename/index.html' => 'chemin-repertoire/nomdebase-page/index.html',
	'folder_path/page_basename.html' => 'chemin_repertoire/nomdebase_page.html',
	'folder_path/page_basename/index.html' => 'chemin_repertoire/nomdebase_page/index.html',
	'folder/sub_folder/index.html' => 'repertoire/sous_repertoire/index.html',
	'folder/sub-folder/index.html' => 'repertoire/sous-repertoire/index.html',
	'yyyy/mm/dd/index.html' => 'aaaa/mm/jj/index.html',
	'category/sub-category/index.html' => 'categorie/sous-categorie/index.html',
	'category/sub_category/index.html' => 'categorie/sous_categorie/index.html',
	'Archive type \'[_1]\' is not a chosen archive type' => 'Le Type d\'archive\'[_1]\' n\'est pas un type d\'archive sélectionné',
	'Parameter \'[_1]\' is required' => 'Le paramètre \'[_1]\' est requis',
	'You did not set your blog publishing path' => 'Vous n\'avez pas spécifié le chemin de publication de votre blog',
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Le même fichier d\'archive existe déjà. Vous devez changer le nom de base ou le chemin de l\'archive ([_1])',
	'An error occurred publishing [_1] \'[_2]\': [_3]' => 'Une erreur s\'est produite lors de la publication [_1] \'[_2]\': [_3]',
	'An error occurred publishing date-based archive \'[_1]\': [_2]' => 'Une erreur s\'est produite en publiant l\'archive par dates \'[_1]\': [_2]',
	'Writing to \'[_1]\' failed: [_2]' => 'Ecriture sur\'[_1]\' a échoué: [_2]',
	'Renaming tempfile \'[_1]\' failed: [_2]' => 'Le renommage de tempfile \'[_1]\' a échoué: [_2]',
	'Template \'[_1]\' does not have an Output File.' => 'Le gabarit \'[_1]\' n\'a pas de fichier de sortie.',
	'An error occurred while publishing scheduled entries: [_1]' => 'Une erreur s\'est produite en publiant les notes planifiées: [_1]',
	'YEARLY_ADV' => 'annuelles',
	'MONTHLY_ADV' => 'mensuelles',
	'CATEGORY_ADV' => 'par catégories',
	'PAGE_ADV' => 'par pages',
	'INDIVIDUAL_ADV' => 'par notes',
	'DAILY_ADV' => 'journalières',
	'WEEKLY_ADV' => 'hebdomadaires',
	'Author (#[_1])' => 'Auteur (#[_1])',
	'AUTHOR_ADV' => 'par auteurs',
	'AUTHOR-YEARLY_ADV' => 'par auteurs et années',
	'AUTHOR-MONTHLY_ADV' => 'par auteurs et semaines',
	'AUTHOR-WEEKLY_ADV' => 'par auteurs et années',
	'AUTHOR-DAILY_ADV' => 'par auteurs et jours',
	'CATEGORY-YEARLY_ADV' => 'par catégories et années',
	'CATEGORY-MONTHLY_ADV' => 'par catégories et mois',
	'CATEGORY-DAILY_ADV' => 'par catégories et jours',
	'CATEGORY-WEEKLY_ADV' => 'par catégories et semaines',
	'author-display-name/index.html' => 'auteur-nom-affichage/index.html',
	'author_display_name/index.html' => 'nom_public_auteur/index.html',
	'author-display-name/yyyy/index.html' => 'auteur-nom-affichage/aaaa/index.html',
	'author_display_name/yyyy/index.html' => 'auteur_nom_affichage/aaaa/index.html',
	'author-display-name/yyyy/mm/index.html' => 'auteur-nom-affichage/aaaa/mm/index.html',
	'author_display_name/yyyy/mm/index.html' => 'auteur_nom_affichage/aaaa/mm/index.html',
	'author-display-name/yyyy/mm/day-week/index.html' => 'auteur-nom-affichage/aaaa/mm/jour-semaine/index.html',
	'author_display_name/yyyy/mm/day-week/index.html' => 'auteur_nom_affichage/aaa/mm/jour-semaine/index.html',
	'author-display-name/yyyy/mm/dd/index.html' => 'auteur-nom-affichage/aaaa/mm/jj/index.html',
	'author_display_name/yyyy/mm/dd/index.html' => 'auteur_nom_affichage/aaaa/mm/jj/index.html',
	'category/sub-category/yyyy/index.html' => 'categorie/sous-categorie/aaaa/index.html',
	'category/sub_category/yyyy/index.html' => 'categorie/sous_categorie/aaaa/index.html',
	'category/sub-category/yyyy/mm/index.html' => 'categorie/sous-categorie/aaaa/mm/index.html',
	'category/sub_category/yyyy/mm/index.html' => 'categorie/sous_categorie/aaaa/mm/index.html',
	'category/sub-category/yyyy/mm/dd/index.html' => 'categorie/sous-categorie/aaaa/mm/jj/index.html',
	'category/sub_category/yyyy/mm/dd/index.html' => 'categorie/sous_categorie/aaa/mm/jj/index.html',
	'category/sub-category/yyyy/mm/day-week/index.html' => 'categorie/sous-categorie/aaaa/mm/jour-semaine/index.html',
	'category/sub_category/yyyy/mm/day-week/index.html' => 'categorie/sous_categorie/aaaa/mm/jour-semaine/index.html',

## lib/MT/Auth.pm
	'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Mauvaise configuration du module d\'authentification \'[_1]\': [_2]',
	'Bad AuthenticationModule config' => 'Mauvaise configuration du module d\'authentification',

## lib/MT/Comment.pm
	'Comment' => 'Commentaire',
	'Load of entry \'[_1]\' failed: [_2]' => 'Le chargement de la note \'[_1]\' a échoué : [_2]',

## lib/MT/Component.pm
	'Loading template \'[_1]\' failed: [_2]' => 'Échec lors du chargement du gabarit \'[_1]\': [_2]',

## lib/MT/DefaultTemplates.pm
	'Archive Index' => 'Index d\'archive',
	'Stylesheet' => 'Feuille de style',
	'JavaScript' => 'JavaScript',
	'RSD' => 'RSD',
	'Atom' => 'Atom',
	'RSS' => 'RSS',
	'Entry Listing' => 'Liste des notes',
	'Displays error, pending or confirmation message for comments.' => 'Affiche les erreurs et les messages de modération pour les commentaires.',
	'Displays preview of comment.' => 'Affiche la prévisualisation du commentaire.',
	'Displays errors for dynamically published templates.' => 'Affiche les erreurs pour les modèles publiés dynamiquement.',
	'Popup Image' => 'Image dans une fenêtre popup',
	'Displays image when user clicks a popup-linked image.' => 'Affiche l\'image quand l\'utilisateur clique sur une image pop-up.',
	'Displays results of a search.' => 'Affiche les résultats d\'une recherche.',
	'Footer' => 'Pied',
	'Sidebar - 2 Column Layout' => 'Colonne latérale - Mise en page 2 colonnes',
	'Sidebar - 3 Column Layout' => 'Colonne latérale - Mise en page 3 colonnes',
	'Comment throttle' => 'Limitation des commentaires',
	'Commenter Confirm' => 'Confirmation du commentateur',
	'Commenter Notify' => 'Notification du commentateur',
	'New Comment' => 'Nouveau commentaire',
	'New Ping' => 'Nouveau ping',
	'Entry Notify' => 'Notification de note',
	'Subscribe Verify' => 'Vérification d\'inscription',

## lib/MT.pm.pre
	'Powered by [_1]' => 'Powered by [_1]',
	'Version [_1]' => 'Version [_1]',
	'http://www.sixapart.com/movabletype/' => 'http://www.movabletype.org',
	'OpenID URL' => 'URL OpenID',
	'Sign in using your OpenID identity.' => 'Identifiez-vous avec votre identité OpenID.',
	'OpenID is an open and decentralized single sign-on identity system.' => 'OpenID est un système de gestion d\'identité ouvert et décentralisé pour s\'identifiant une seule fois seulement.',
	'Sign In' => 'Connexion',
	'Learn more about OpenID.' => 'En savoir plus sur OpenID.',
	'Your LiveJournal Username' => 'Votre identifiant LiveJournal',
	'Sign in using your Vox blog URL' => 'Identifiez-vous en utilisant votre URL Vox',
	'Learn more about LiveJournal.' => 'En savoir plus sur LiveJournal.',
	'Your Vox Blog URL' => 'L\'URL de votre blog Vox',
	'Learn more about Vox.' => 'En savoir plus sur Vox.',
	'TypeKey is a free, open system providing you a central identity for posting comments on weblogs and logging into other websites. You can register for free.' => 'TypeKey est un système gratuit et ouvert qui fournit une identité centralisée pour poster des commentaires sur les blogs et vous identifier sur d\'autres sites web. Vous pouvez créer un compte gratuitement.',
	'Sign in or register with TypeKey.' => 'Identifiez-vous ou enregistrez-vous avec TypeKey.',
	'Hello, world' => 'Bonjour,',
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
	'__PORTAL_URL__' => '__PORTAL_URL__',
	'http://www.movabletype.org/documentation/' => 'http://www.movabletype.org/documentation/',
	'OpenID' => 'OpenID',
	'LiveJournal' => 'LiveJournal',
	'Vox' => 'Vox',
	'TypeKey' => 'TypeKey',
	'Movable Type default' => 'Valeur par défaut Movable Type',

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
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes' => 'Par défaut, ce moteur de recherche analyse l\'ensemble des mots sans se préocupper de leur ordre. Pour lancer une recherche sur une phrase exacte, insérez-la entre guillemets.',
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
	'Back' => 'Retour',
	'Continue' => 'Continuer',
	'Show current mail settings' => 'Montrer les paramètres d\'email actuels',
	'Periodically Movable Type will send email to inform users of new comments as well as other other events. For these emails to be sent properly, you must instruct Movable Type how to send email.' => 'Movable Type va envoyer périodiquement des emails afin d\'informer les utilisateurs de nouveaux commentaires et autres événements. Pour que ces emails puissent être envoyés correctement, veuillez spécifier la méthode que Movable Type va utiliser.',
	'An error occurred while attempting to send mail: ' => 'Une erreur s\'est produite en essayant d\'envoyer un email: ',
	'Send email via:' => 'Envoyer email via :',
	'Select One...' => 'Sélectionner un...',
	'sendmail Path' => 'Chemin sendmail',
	'The physical file path for your sendmail binary.' => 'Le chemin du fichier physique de votre binaire sendmail.',
	'Outbound Mail Server (SMTP)' => 'Serveur email sortant (SMTP)',
	'Address of your SMTP Server.' => 'Adresse de votre serveur SMTP.',
	'Mail address for test sending' => 'Adresse email pour envoi d\'un test',
	'Send Test Email' => 'Envoyer un email de test',

## tmpl/wizard/complete.tmpl
	'Configuration File' => 'Fichier de configuration',
	'The [_1] configuration file can\'t be located.' => 'Le fichier de configuration [_1] n\'a pas pu être trouvé',
	'Please use the configuration text below to create a file named \'mt-config.cgi\' in the root directory of [_1] (the same directory in which mt.cgi is found).' => 'Créez un fichier nommé dans le répertoire racine de [_1] (le même qui contient mt.cgi) ayant pour contenu le texte de configuration ci-dessous.',
	'The wizard was unable to save the [_1] configuration file.' => 'L\'assistant n\'a pas pu enregistrer le fichier de configuration [_1]',
	'Confirm your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click \'Retry\'.' => 'Vérifiez que votre répertoire [_1] (celui qui contient mt.cgi) est ouvert en écriture pour votre serveur web et cliquez sur Recommencer',
	'Congratulations! You\'ve successfully configured [_1].' => 'Félicitations ! Vous avez configuré [_1] avec succès.',
	'Your configuration settings have been written to the following file:' => 'Vos paramètres de configuration ont été écrit dans le fichier suivant:',
	'To reconfigure the settings, click the \'Back\' button below.' => 'Pour reconfigurer vos paramètres, cliquez sur le bouton \'Retour\' ci-dessous. Sinon, cliquez sur Continuer.',
	'Show the mt-config.cgi file generated by the wizard' => 'Afficher le fichier mt-config.cgi généré par l\'assistant',
	'I will create the mt-config.cgi file manually.' => 'Je vais créer le fichier mt-config.cgi manuellement.',
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
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => 'Un fichier de configuration (mt-config.cgi) existe déjà, <a href="[_1]">identifiez-vous</a> dans Movable Type.',
	'To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page' => 'Pour créer un nouveau fichier de configuration avec l\'assistant, supprimez le fichier de configuration actuel puis rechargez cette page',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Pour utiliser Movable Type, vous devez activer les JavaScript sur votre navigateur. Merci de les activer et de relancer le navigateur pour commencer.',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Vous allez maintenant, grâce à cet assistant de configuration, mettre en place les paramètres de base afin d\'assurer le fonctionnement de Movable Type.',
	'<strong>Error: \'[_1]\' could not be found.</strong>  Please move your static files to the directory first or correct the setting if it is incorrect.' => '<strong>Erreur: \'[_1]\' n\'a pas pu être trouvé(e).</strong>  Veuillez déplacer vos fichiers statiques vers le répertoire premier ou mettre à jour les paramètres si nécessaire.',
	'Configure Static Web Path' => 'Configurer le chemin web statique',
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type est fourni avec un répertoire nommé [_1] contenant un nombre important de fichiers comme des images, fichiers javascripts et feuilles de style.',
	'The [_1] directory is in the main Movable Type directory which this wizard script resides, but due to your web server\'s configuration, the [_1] directory is not accessible in this location and must be moved to a web-accessible location (e.g., your web document root directory).' => 'Le répertoire [_1] est le répertoire principal de Movable Type contenant les scripts de cet assistant, mais à cause de la configuration de votre serveur web, le répertoire [_1] n\'est pas accessible à cette adresse et doit être déplacé vers un serveur web (par exemple, le répertoire document à la racine). ',
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Ce répertoire a été renommé ou déplacé en dehors du répertoire Movable Type.',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => 'Déplacez ou créez un lien symbolique du répertoire [_1] dans un endroit accessible depuis le web et spécifiez le chemin web statique dans le champs ci-dessous.',
	'This URL path can be in the form of [_1] or simply [_2]' => 'Ce chemin d\'URL peut être de la forme [_1] ou simplement [_2]',
	'This path must be in the form of [_1]' => '', # Translate - New
	'Static web path' => 'Chemin web statique',
	'Static file path' => 'Chemin fichier statique',
	'Begin' => 'Commencer',

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
	'You must set your Database Path.' => 'Vous devez définir le Chemin de Base de Données.',
	'You must set your Database Name.' => 'Vous devez définir un Nom de Base de données.',
	'You must set your Username.' => 'Vous devez définir votre nom d\'utilisateur.',
	'You must set your Database Server.' => 'Vous devez définir votre serveur de Base de données.',
	'Your database configuration is complete.' => 'Votre configuration de base de données est complète.',
	'You may proceed to the next step.' => 'Vous pouvez passer à l\'étape suivante.',
	'Please enter the parameters necessary for connecting to your database.' => 'Merci de saisir les paramètres nécessaires pour se connecter à votre base de données.',
	'Show Current Settings' => 'Montrer les paramètres actuels',
	'Database Type' => 'Type de base de données',
	'If your database type is not listed in the menu above, then you need to <a target="help" href="[_1]">install the Perl module necessary to connect to your database</a>.  If this is the case, please check your installation and <a href="javascript:void(0)" onclick="[_2]">re-test your installation</a>.' => 'Si le type de votre base de données n\'est pas listé dans le menu ci-dessus, vous devez <a target="help" href="[_1]">installer le module Perl nécessaire pour se connecter à votre base</a>. Si c\'est déjà le cas, merci de vérifier votre installation et <a href="javascript:void(0)" onclick="[_2]">testez-la à nouveau</a>.',
	'Database Path' => 'Chemin de la Base de Données',
	'The physical file path for your SQLite database. ' => 'Le chemin du fichier physique de votre base de données SQLite. ',
	'A default location of \'./db/mt.db\' will store the database file underneath your Movable Type directory.' => 'Un endroit par défaut \'./db/mt.db\' stockera le fichier de base de données dans votre répertoire Movable Type.',
	'Database Server' => 'Serveur de Base de données',
	'This is usually \'localhost\'.' => 'C\'est généralement \'localhost\'.',
	'Database Name' => 'Nom de la Base de données',
	'The name of your SQL database (this database must already exist).' => 'Le nom de votre Base de données SQL (cette base de données doit être déjà présente).',
	'The username to login to your SQL database.' => 'Le nom d\'utilisateur pour accèder à la Base de données SQL.',
	'Password' => 'Mot de passe',
	'The password to login to your SQL database.' => 'Le mot de passe pour accèder à la Base de données SQL.',
	'Show Advanced Configuration Options' => 'Montrer les options avancées de configuration',
	'Database Port' => 'Port de la Base de données',
	'This can usually be left blank.' => 'Peut être laissé vierge.',
	'Database Socket' => 'Socket de la Base de données',
	'Publish Charset' => 'Publier le  Charset',
	'MS SQL Server driver must use either Shift_JIS or ISO-8859-1.  MS SQL Server driver does not support UTF-8 or any other character set.' => 'Le driver  Serveur MS SQL doit utiliser Shift_JIS ou ISO-8859-1.  Le driver serveur MS SQL ne supporte pas UTF-8 ou tout autre jeu de caractères.',
	'Test Connection' => 'Test de Connexion',

## tmpl/wizard/blog.tmpl
	'Setup Your First Blog' => 'Configurer votre premier blog',
	'In order to properly publish your blog, you must provide Movable Type with your blog\'s URL and the path on the filesystem where its files should be published.' => 'Pour pouvoir publier correctement votre blog, vous devez fournir à Movable Type l\'URL du blog et le chemin sur le disque où les fichiers doivent être publiés.',
	'My First Blog' => 'Mon Premier Blog',
	'Publishing Path' => 'Chemin de publication',
	'Your \'Publishing Path\' is the path on your web server\'s file system where Movable Type will publish all the files for your blog. Your web server must have write access to this directory.' => 'Votre \'Chemin de publication\' est le chemin sur le disque de votre serveur web où Movable Type va publier tous les fichiers de votre blog. Votre serveur web doit avoir un accès en écriture à ce répertoire.',

## tmpl/cms/include/list_associations/page_title.tmpl
	'Permissions for [_1]' => 'Autorisations pour [_1]',
	'Permissions: System-wide' => 'Autorisations : configuration globale',
	'Users for [_1]' => 'Utilisateurs pour [_1]',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001-[_1] Six Apart. All Rights Reserved.' => '', # Translate - New

## tmpl/cms/include/comment_table.tmpl
	'comment' => 'commentaire',
	'comments' => 'commentaires',
	'to publish' => 'pour publier',
	'Publish selected comments (a)' => 'Publier les commentaires sélectionnés (a)',
	'Delete selected comments (x)' => 'Supprimer les commentaires sélectionnés (x)',
	'Report selected comments as Spam (j)' => 'Marquer les commentaires sélectionnés comme étant du spam (j)',
	'Spam' => 'Spam',
	'Report selected comments as Not Spam and Publish (j)' => 'Marquer les commentaires sélectionnés comme n\'étant pas du spam et les publier (j)',
	'Not Spam' => 'Non-spam',
	'Are you sure you want to remove all comments reported as spam?' => 'Êtes-vous sûr(e) de vouloir supprimer tous les commentaires notifiés comme spam ?',
	'Delete all comments reported as Spam' => 'Supprimer tous les commentaires marqués comme étant du spam',
	'Empty' => 'Vide',
	'Ban This IP' => 'Bannir cette adresse IP',
	'Status' => 'Statut',
	'Entry/Page' => 'Note/Page',
	'Date' => 'Date',
	'IP' => 'IP',
	'Only show published comments' => 'N\'afficher que les commentaires publiés',
	'Published' => 'Publié',
	'Only show pending comments' => 'N\'afficher que les commentaires en attente',
	'Pending' => 'En attente',
	'Edit this comment' => 'Editer ce commentaire',
	'([quant,_1,reply,replies])' => '([quant,_1,réponse,réponses])',
	'Reply' => 'Répondre',
	'Trusted' => 'Fiable',
	'Blocked' => 'Bloqués',
	'Authenticated' => 'Authentifié',
	'Edit this [_1] commenter' => 'Modifier l\'auteur de commentaires de cette [_1]',
	'Search for comments by this commenter' => 'Chercher les commentaires de cet auteur de commentaires',
	'Anonymous' => 'Anonyme',
	'View this entry' => 'Voir cette note',
	'View this page' => 'Voir cette page',
	'Search for all comments from this IP address' => 'Rechercher tous les commentaires associés à cette adresse IP',

## tmpl/cms/include/member_table.tmpl
	'user' => 'utilisateur',
	'users' => 'utilisateurs',
	'Are you sure you want to remove the selected user from this blog?' => 'Êtes-vous sûr(e) de vouloir retirer l\'utilisateur sélectionné de ce blog?',
	'Are you sure you want to remove the [_1] selected users from this blog?' => 'Êtes-vous sûr(e) de vouloir retirer les [_1] utilisateurs sélectionnés de ce blog?',
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

## tmpl/cms/include/overview-left-nav.tmpl
	'List Weblogs' => 'Liste des Blogs',
	'Weblogs' => 'Blogs',
	'List Users and Groups' => 'Lister les Utilisateurs et les Groupes',
	'Users &amp; Groups' => 'Utilisateurs &amp; Groupes',
	'List Associations and Roles' => 'Lister les associations et les rôles',
	'Privileges' => 'Privilèges',
	'List Plugins' => 'Liste des Plugins',
	'Aggregate' => 'Multi-Blogs',
	'List Entries' => 'Afficher les notes',
	'List uploaded files' => 'Lister les fichiers envoyés',
	'List Tags' => 'Liste de tags',
	'List Comments' => 'Afficher les commentaires',
	'List TrackBacks' => 'Lister les trackbacks',
	'Configure' => 'Configurer',
	'Edit System Settings' => 'Editer les Paramètres Système',
	'Utilities' => 'Utilitaires',
	'Search &amp; Replace' => 'Chercher &amp; Remplacer',
	'_SEARCH_SIDEBAR' => 'Rechercher',
	'Show Activity Log' => 'Afficher le journal (logs)',

## tmpl/cms/include/asset_table.tmpl
	'asset' => 'Élément',
	'assets' => 'Éléments',
	'Delete selected assets (x)' => 'Effacer les contenus sélectionnés (x)',
	'Size' => 'Taille',
	'Created By' => 'Créé par',
	'Created On' => 'Créé le',
	'View' => 'Voir',
	'Asset Missing' => 'Élément manquant',
	'No thumbnail image' => 'Pas de miniature',
	'[_1] is missing' => '[_1] est manquant',

## tmpl/cms/include/import_start.tmpl
	'Importing...' => 'Importation...',
	'Importing entries into blog' => 'Importation de notes dans le blog',
	'Importing entries as user \'[_1]\'' => 'Importation des notes en tant qu\'utilisateur \'[_1]\'',
	'Creating new users for each user found in the blog' => 'Création de nouveaux utilisateur correspondant à chaque utilisateur trouvé dans le blog',

## tmpl/cms/include/log_table.tmpl
	'No log records could be found.' => 'Aucune donnée du journal n\'a été trouvée.',
	'_LOG_TABLE_BY' => 'Utilisateur',
	'IP: [_1]' => 'IP : [_1]',
	'[_1]' => '[_1]',

## tmpl/cms/include/pagination.tmpl

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been backed up successfully!' => 'Toutes les données ont été sauvegardées avec succès!',
	'_external_link_target' => '_haut',
	'Download This File' => 'Télécharger ce fichier',
	'_BACKUP_TEMPDIR_WARNING' => '_BACKUP_TEMPDIR_WARNING',
	'_BACKUP_DOWNLOAD_MESSAGE' => '_BACKUP_DOWNLOAD_MESSAGE',
	'An error occurred during the backup process: [_1]' => 'Une erreur est survenue pendant la sauvegarde: [_1]',

## tmpl/cms/include/cfg_content_nav.tmpl
	'Registration' => 'Enregistrement',
	'Web Services' => 'Services Web',

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Ajouté(e)',
	'Click to edit contact' => 'Cliquer pour modifier le contact',
	'Save changes' => 'Enregistrer les modifications',
	'Save' => 'Enregistrer',

## tmpl/cms/include/footer.tmpl
	'Hey, this is a Beta version of MT: Don\'t use it in production! And you\'ll want to upgrade to the release version by January 31, 2008. (<a href="[_1]" target="_blank">License details</a>)' => 'Hey, c\'est une version beta de MT : Ne l\'utilisez pas en production ! Et vous aurez à mettre à jour vers la version Release le 31 Janvier 2008. (<a href="[_1]" target="_blank">Détails de la licence</a>)',
	'Dashboard' => 'Tableau de bord',
	'Compose Entry' => 'Ecrire une note',
	'Manage Entries' => 'Gérer les notes',
	'System Settings' => 'Paramètres du système',
	'Help' => 'Aide',
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]',
	'with' => 'avec',

## tmpl/cms/include/tools_content_nav.tmpl

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

## tmpl/cms/include/entry_table.tmpl
	'Save these entries (s)' => 'Enregistrer les notes sélectionnées (s)',
	'Republish selected entries (r)' => 'Republier les notes sélectionnées (r)',
	'Delete selected entries (x)' => 'Supprimer les notes sélectionnées (x)',
	'Save these pages (s)' => 'Enregistrer les pages sélectionnées (s)',
	'Republish selected pages (r)' => 'Republier les pages sélectionnées (r)',
	'Delete selected pages (x)' => 'Supprimer les pages sélectionnées (x)',
	'to republish' => 'pour republier',
	'Republish' => 'Republier',
	'Last Modified' => 'Dernière modification',
	'Created' => 'Créé',
	'Unpublished (Draft)' => 'Non publié (Brouillon)',
	'Unpublished (Review)' => 'Non publié (Vérification)',
	'Scheduled' => 'Planifié',
	'Only show unpublished entries' => 'Afficher uniquement les notes non publiées',
	'Only show unpublished pages' => 'Afficher uniquement les pages non publiées',
	'Only show published entries' => 'Afficher uniquement les notes publiées',
	'Only show published pages' => 'Afficher uniquement les pages publiées',
	'Only show entries for review' => 'Afficher uniquement les notes à vérifier',
	'Only show pages for review' => 'Afficher uniquement les pages à vérifier',
	'Only show scheduled entries' => 'Afficher uniquement les notes planifiées',
	'Only show scheduled pages' => 'Afficher uniquement les pages planifiées',
	'Edit Entry' => 'Éditer une note',
	'Edit Page' => 'Éditer une page',
	'View entry' => 'Afficher une note',
	'View page' => 'Afficher une page',
	'No entries could be found. <a href="[_1]">Create Entry</a>' => '', # Translate - New
	'No page could be found. <a href="[_1]">Create Page</a>' => '', # Translate - New

## tmpl/cms/include/login_mt.tmpl

## tmpl/cms/include/author_table.tmpl
	'_USER_DISABLED' => 'Utilisateur désactivé',

## tmpl/cms/include/calendar.tmpl
	'_LOCALE_WEEK_START' => '1',
	'Sunday' => 'Dimanche',
	'Monday' => 'Lundi',
	'Tuesday' => 'Mar',
	'Wednesday' => 'Mercredi',
	'Thursday' => 'Jeudi',
	'Friday' => 'Vendredi',
	'Saturday' => 'Samedi',
	'S|M|T|W|T|F|S' => 'L|M|M|J|V|S|D',
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
	'to act upon' => 'pour agir sur',
	'Go' => 'OK',

## tmpl/cms/include/anonymous_comment.tmpl
	'Anonymous Comments' => 'Commentaires anonymes',
	'Require E-mail Address for Anonymous Comments' => 'Nécessite une adresse email pour les commentaires anonymes',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Si activé, le visiteur doit donner une adresse email valide pour commenter.',

## tmpl/cms/include/category_selector.tmpl
	'Add sub category' => 'Ajouter une sous-catégorie',

## tmpl/cms/include/display_options.tmpl
	'Display Options' => 'Options d\'affichage',
	'_DISPLAY_OPTIONS_SHOW' => 'Afficher',
	'[quant,_1,row,rows]' => '[quant,_1,ligne,lignes]',
	'Compact' => 'Compacte',
	'Expanded' => 'Etendue',
	'Action Bar' => 'Barre d\'action',
	'Top' => 'En haut',
	'Both' => 'En haut et en bas',
	'Bottom' => 'En bas',
	'Date Format' => 'Format date',
	'Relative' => 'Relative',
	'Full' => 'Entière',
	'Save display options' => 'Enregistrer les options d\'affichage',
	'Close display options' => 'Fermer les options d\'affichage',

## tmpl/cms/include/backup_start.tmpl
	'Backing up Movable Type' => 'Sauvegarder Movable Type',

## tmpl/cms/include/chromeless_footer.tmpl
	'<a href="[_1]">Movable Type</a> version [_2]' => '<a href="[_1]">Movable Type</a> version [_2]',

## tmpl/cms/include/template_table.tmpl
	'template' => 'gabarit',
	'templates' => 'gabarits',
	'Output File' => 'Fichier de sortie',
	'Type' => 'Type',
	'Linked' => 'Lié',
	'Linked Template' => 'Gabarit lié',
	'Dynamic' => 'Dynamique',
	'Dynamic Template' => 'Gabarit dynamique',
	'Published w/Indexes' => 'Publication',
	'Published Template w/Indexes' => 'Publication du gabarit',
	'-' => '-',
	'Yes' => 'Oui',
	'No' => 'Non',
	'View Published Template' => 'Voir le gabarit publié',

## tmpl/cms/include/asset_upload.tmpl
	'Before you can upload a file, you need to publish your blog. [_1]Configure your blog\'s publishing paths[_2] and rebuild your blog.' => 'Avant de pouvoir envoyer un fichier, vous devez publier votre blog. [_1]Configurez les chemins de publication de votre blog[_2] et republiez votre blog.',
	'Your system or blog administrator needs to publish the blog before you can upload files. Please contact your system or blog administrator.' => 'L\'administrateur du système ou du blog doit publier le blog avant que vous puissiez envoyer des fichiers.',
	'Close (x)' => 'Fermer (x)',
	'Select File to Upload' => 'Sélectionnez le fichier à envoyer',
	'_USAGE_UPLOAD' => 'Vous pouvez télécharger le fichier ci-dessus dans le chemin local de votre site <a href="javascript:alert(\'[_1]\')">(?)</a> ou dans le chemin des archives de votre site <a href="javascript:alert(\'[_2]\')">(?)</a>. Vous pouvez également télécharger le fichier dans un répertoire compris dans les répertoires mentionnés ci-dessus, en spécifiant le chemin dans les champs de droite (<i>images</i>, par exemple). Les répertoires qui n\'existent pas encore seront créés.',
	'Upload Destination' => 'Destination du fichier',
	'Choose Folder' => 'Choisir le Dossier',
	'Upload (s)' => 'Envoyer (s)',
	'Upload' => 'Envoyer',
	'Back (b)' => 'Retour (b)',
	'Cancel (x)' => 'Annuler (x)',
	'Add [lc,_1] name' => 'Ajouter le nom [lc,_1]',

## tmpl/cms/include/header.tmpl
	'Hi [_1],' => 'Bonjour [_1],',
	'Logout' => 'Déconnexion',
	'Select another blog...' => 'Sélectionnez un autre blog...',
	'Create a new blog' => 'Créer un nouveau blog',
	'Write Entry' => 'Ecrire une note',
	'Blog Dashboard' => 'Tableau de bord du Blog',
	'View Site' => 'Voir le site',
	'Search (q)' => 'Recherche (q)',

## tmpl/cms/include/listing_panel.tmpl
	'Step [_1] of [_2]' => 'Étape  [_1] sur [_2]',
	'Reset' => 'Mettre à jour',
	'Go to [_1]' => 'Aller à [_1]',
	'Sorry, there were no results for your search. Please try searching again.' => 'Désolé, aucun résultat trouvé pour cette recherche. Merci d\'essayer à nouveau.',
	'Sorry, there is no data for this object set.' => 'Désolé, mais il n\'y a pas de données pour cet ensemble d\'objets.',
	'Confirm (s)' => 'Confirmer (s)',
	'Confirm' => 'Confirmer',
	'Continue (s)' => 'Continuer (s)(',

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
	'Delete selected blogs (x)' => 'Effacer les blogs sélectionnés (x)',

## tmpl/cms/include/blog-left-nav.tmpl
	'Creating' => 'Créer',
	'Create Entry' => 'Créer une nouvelle note',
	'Community' => 'Communauté',
	'List Commenters' => 'Lister les auteurs de commentaires',
	'Edit Address Book' => 'Modifier le carnet d\'adresses',
	'List Users &amp; Groups' => 'Liste des utilisateurs &amp; Groupes',
	'List &amp; Edit Templates' => 'Lister &amp; Editer les gabarits',
	'Edit Categories' => 'Modifier les catégories',
	'Edit Tags' => 'Editer les tags',
	'Edit Weblog Configuration' => 'Modifier la configuration du blog',
	'Backup this weblog' => 'Sauvegarder ce blog',
	'Import &amp; Export Entries' => 'Importer &amp; Exporter les Notes',
	'Import / Export' => 'Importer / Exporter',
	'Rebuild Site' => 'Actualiser le site',

## tmpl/cms/include/users_content_nav.tmpl
	'Profile' => 'Profil',
	'Details' => 'Détails',

## tmpl/cms/include/import_end.tmpl
	'All data imported successfully!' => 'Toutes les données ont été importées avec succès !',
	'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Assurez vous d\'avoir bien enlevé les fichiers importés du répertoire \'import\', pour éviter une ré-importation des mêmes fichiers à l\'avenir .',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Une erreur s\'est produite pendant le processus: [_1]. Merci de vérifier vos fichiers import.',

## tmpl/cms/include/archive_maps.tmpl
	'Path' => 'Chemin',
	'Custom...' => 'Personnalisé...',

## tmpl/cms/include/cfg_system_content_nav.tmpl

## tmpl/cms/dialog/recover.tmpl
	'Your password has been changed, and the new password has been sent to your email address ([_1]).' => 'Votre mot de passe a été modifié et a été envoyé à votre adresse e-mail([_1]).',
	'Sign in to Movable Type (s)' => 'Connectez-vous sur Movable Type (s)',
	'Sign in to Movable Type' => 'Connectez-vous sur Movable Type',
	'Password recovery word/phrase' => 'Indice de récupération du mot de passe',
	'Recover (s)' => 'Récupérer (s)',
	'Recover' => 'Récupérer',
	'Go Back (x)' => 'Retour (x)',

## tmpl/cms/dialog/restore_end.tmpl
	'An error occurred during the restore process: [_1] Please check your restore file.' => 'Une erreur s\'est produite pendant la procédure de restauration: [_1] Merci de vérifier votre fichier de restauration.',
	'View Activity Log (v)' => 'Voir le journal (logs) (v)',
	'All data restored successfully!' => 'Toutes les données ont été restaurées avec succès !',
	'Close (s)' => 'Fermer (s)',
	'Next Page' => 'Page suivante',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => 'Cette page va être redirigée vers une nouvelle page dans 3 secondes. [_1]Arrêter la redirection.[_2]',

## tmpl/cms/dialog/asset_replace.tmpl
	'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'Un fichier nommé \'[_1]\' existe déjà. Souhaitez-vous le remplacer ?',
	'Yes (s)' => 'Oui (s)',

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

## tmpl/cms/dialog/refresh_templates.tmpl
	'Refresh Template Set' => '', # Translate - New
	'Refresh [_1] template set' => '', # Translate - New
	'Updates current templates while retaining any user-created or user-modified templates.' => '
	Met à jour les gabarits actuels en conservant les gabarits créés ou modifiés par n\'import quel utilisateur.',
	'Apply a new template set' => '', # Translate - New
	'Deletes all existing templates and installs factory default template set.' => 'Supprime tous les gabartis existants et installe les groupes de gabarits par défaut ',
	'Make backups of existing templates first' => 'Faire d\'abord des sauvegardes des gabarits existants',
	'You have requested to <strong>refresh the current template set</strong>. This action will:' => '', # Translate - New
	'potentially install new templates' => 'peut-être installer de nouveaux gabarits',
	'overwrite some existing templates with new template code' => 'remplacer le code de certains gabarits par un nouveau code',
	'backups will be made of your templates and can be accessed through your backup filter' => 'créer des sauvegardes de vos gabarits (qui pourront être accessibles grâce au filtre "sauvegardes")',
	'You have requested to <strong>apply a new template set</strong>. This action will:' => '', # Translate - New
	'delete all of the templates in your blog' => 'supprimer tous les gabarits de votre blog',
	'install new templates from the selected template set' => 'installer de nouveaux gabarits depuis le groupe de gabarits sélectionné',
	'Are you sure you wish to continue?' => 'Êtes-vous sûr de vouloir continuer ?',

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

## tmpl/cms/dialog/restore_upload.tmpl
	'Restore: Multiple Files' => 'Restauration : Plusieurs fichiers',
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => 'L\'annulation de la procédure va créer des objets orphelins.  Êtes-vous sûr de vouloir annuler l\'opération de restauration ?',
	'Please upload the file [_1]' => 'Merci d\'envoyer le fichier [_1]',

## tmpl/cms/dialog/entry_notify.tmpl
	'Send a Notification' => 'Envoyer une notification',
	'You must specify at least one recipient.' => 'Vos devez définir au moins un destinataire.',
	'Your blog\'s name, this entry\'s title and a link to view it will be sent in the notification.  Additionally, you can add a  message, include an excerpt of the entry and/or send the entire entry.' => 'Le nom de votre blog, le titre de cette note et un lien pour la voir seront envoyés dans la notification. De plus, vous pouvez ajouter un message, inclure un extrait de la note et/ou envoyer la note entière.',
	'Recipients' => 'Destinataires',
	'Enter email addresses on separate lines, or comma separated.' => 'Saisissez les adresses email sur des lignes séparées, ou séparées par une virgule.',
	'All addresses from Address Book' => 'Toutes les adresses de carnet d\'adresses',
	'Optional Message' => 'Message optionnel',
	'Optional Content' => 'Contenu optionnel',
	'(Entry Body will be sent without any text formatting applied)' => '(Le corps de la note sera envoyé sans mise en forme du texte)',
	'Send notification (s)' => 'Envoyer la notification (s)',
	'Send' => 'Envoyer',

## tmpl/cms/dialog/asset_options.tmpl
	'File Options' => 'Options fichier',
	'The file named \'[_1]\' has been uploaded. Size: [quant,_2,byte,bytes].' => 'Le fichier nommé \'[_1]\' a été téléchargé. Taille : [quant,_2,octet,octets].',
	'Create entry using this uploaded file' => 'Créer une note à l\'aide de ce fichier',
	'Create a new entry using this uploaded file.' => 'Créer une nouvelle note avec ce fichier envoyé.',
	'Finish (s)' => 'Terminer (s)',
	'Finish' => 'Terminer',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Confirm Publishing Configuration' => 'Confirmer la confirmation de publication',
	'URL is not valid.' => 'L\'URL n\'est pas valide.',
	'You can not have spaces in the URL.' => 'Vous ne pouvez pas avoir d\'espace dans l\'URL.',
	'You can not have spaces in the path.' => 'Vous ne pouvez pas avoir d\'espace dans le chemin.',
	'Path is not valid.' => 'Le chemin n\'est pas valide.',
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
	'Link image to full-size version in a popup window.' => 'Créer un lien vers l\'image originale dans une popup',
	'Remember these settings' => 'Se souvenir de ces paramètres',

## tmpl/cms/dialog/create_association.tmpl
	'No roles exist in this installation. [_1]Create a role</a>' => 'Aucun rôle n\'existe dans cette installation. [_1]Créer un rôle</a>',
	'No groups exist in this installation. [_1]Create a group</a>' => 'Aucun groupe n\'existe dans cette installation. [_1]Créer un groupe</a>',
	'No users exist in this installation. [_1]Create a user</a>' => 'Aucun utilisateur n\'existe dans cette installation. [_1]Créer un utilisateur</a>',
	'No blogs exist in this installation. [_1]Create a blog</a>' => 'Aucun blog n\'existe dans cette installation. [_1]Créer un blog</a>',

## tmpl/cms/dialog/restore_start.tmpl
	'Restoring...' => 'Restauration...',

## tmpl/cms/widget/new_user.tmpl
	'Welcome to Movable Type, the world\'s most powerful blogging, publishing and social media platform. To help you get started we have provided you with links to some of the more common tasks new users like to perform:' => 'Bienvenue dans Movable Type, la plateforme de blogs, de publication et de média social la plus puissante au monde. Afin de vous aider à démarrer avec Movable Type, nous vous proposons quelques liens vers les tâches les plus courantes que les nouveaux utilisateurs souhaitent réaliser :',
	'Write your first post' => 'Écrivez votre première note',
	'What would a blog be without content? Start your Movable Type experience by creating your very first post.' => 'Que serait un blog sans contenu ? Débutez votre expérience Movable Type en créant votre toute première note.',
	'Design your blog' => 'Choisissez l\'habillage de votre blog',
	'Customize the look and feel of your blog quickly by selecting a design from one of our professionally designed themes.' => 'Personnalisez votre blog en sélectionnant un habillage créé par des professionnels.',
	'Explore what\'s new in Movable Type 4' => 'Découvrez ce qui est nouveau dans Movable Type 4',
	'Whether you\'re new to Movable Type or using it for the first time, learn more about what this tool can do for you.' => 'Que vous découvriez Movable Type ou que vous l\'utilisiez pour la première fois, découvrez ce que cet outil peut faire pour vous.',

## tmpl/cms/widget/blog_stats_recent_entries.tmpl
	'[quant,_1,entry,entries] tagged &ldquo;[_2]&rdquo;' => '[quant,_1,note,notes] avec le tag &ldquo;[_2]&rdquo;',
	'Posted by [_1] [_2] in [_3]' => 'Postée par [_1] [_2] dans [_3]',
	'Posted by [_1] [_2]' => 'Postée par [_1] [_2]',
	'Tagged: [_1]' => 'avec le tag : [_1]',
	'View all entries tagged &ldquo;[_1]&rdquo;' => 'Voir toutes les notes avec le tag &ldquo;[_1]&rdquo;',
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
	'Trackbacks' => 'Trackbacks',
	'Import Content' => 'Importer du contenu',
	'Blog Preferences' => 'Préférences du blog',

## tmpl/cms/widget/new_version.tmpl
	'What\'s new in Movable Type [_1]' => 'Quoi de neuf dans Movable Type [_1]',
	'Congratulations, you have successfully installed Movable Type [_1]. Listed below is an overview of the new features found in this release.' => 'Félicitations, vous avez installé Movable Type [_1] avec succès. Voici, entre autres, une vue d\'ensemble des nouveautés apportées par cette nouvelle version.',

## tmpl/cms/widget/this_is_you.tmpl
	'Your <a href="[_1]">last entry</a> was [_2] in <a href="[_3]">[_4]</a>.' => 'Votre <a href="[_1]">dernière note</a> a été [_2] dans <a href="[_3]">[_4]</a>.',
	'You have <a href="[_1]">[quant,_2,draft,drafts]</a>.' => 'Vous avez <a href="[_1]">[quant,_2,brouillon,brouillons]</a>.',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a> with <a href="[_3]">[quant,_4,comment,comments]</a>.' => 'Vous avez écrit <a href="[_1]">[quant,_2,note,notes]</a> avec <a href="[_3]">[quant,_4,commentaire,commentaires]</a>.',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>.' => 'Vous avez écrit <a href="[_1]">[quant,_2,note,notes]</a>.',
	'Edit your profile' => 'Modifier votre profil',

## tmpl/cms/widget/new_install.tmpl
	'Thank you for installing Movable Type' => 'Merci d\'avoir installé Movable Type',
	'Congratulations on installing Movable Type, the world\'s most powerful blogging, publishing and social media platform. To help you get started we have provided you with links to some of the more common tasks new users like to perform:' => 'Félicitations, vous avez installé avec succès Movable Type, la plateforme de blogs, de publication et de média social la plus puissante au monde. Afin de vous aider à démarrer avec Movable Type, nous vous proposons quelques liens vers les tâches les plus courantes que les nouveaux utilisateurs souhaitent réaliser :',
	'Add more users to your blog' => 'Ajouter plus d\'utilisateurs à votre blog',
	'Start building your network of blogs and your community now. Invite users to join your blog and promote them to authors.' => 'Commencez à créer votre réseau de blogs et votre communauté dès maintenant. Invitez des utilisateurs à joindre votre blog et donnez-leur le statut d\'auteurs.',

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
	'Movable Type was unable to locate your \'mt-static\' directory. Please configure the \'StaticFilePath\' configuration setting in your mt-config.cgi file, and create a writable \'support\' directory underneath your \'mt-static\' directory.' => 'Movable Type n\'a pas pu localiser votre répertoire \'mt-static\'. Merci de configurer la variable de configuration \'StaticFilePath\' dans votre fichier mt-config.cgi, et créez un répertoire \'support\' accessible en écriture dans le répertoire \'mt-static\'.',
	'Movable Type was unable to write to its \'support\' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.' => 'Movable Type n\'a pas pu écrire dans son répertoire \'support\'. Merci de créer un répertoire à cet endroit : [_1], et de lui ajouter des droits qui permettent au serveur web d\'écrire dedans.',
	'[_1] [_2] - [_3] [_4]' => '[_1] [_2] - [_3] [_4]',
	'You have <a href=\'[_3]\'>[quant,_1,comment,comments] from [_2]</a>' => 'Vous avez <a href=\'[_3]\'>[quant,_1,commentaire,commentaires] de [_2]</a>',
	'You have <a href=\'[_3]\'>[quant,_1,entry,entries] from [_2]</a>' => 'Vous avez <a href=\'[_3]\'>[quant,_1,note,notes] de [_2]</a>',

## tmpl/cms/widget/blog_stats_entry.tmpl
	'Most Recent Entries' => 'Notes récentes',
	'...' => '...',
	'View all entries' => 'Voir toutes les notes',

## tmpl/cms/widget/blog_stats_tag_cloud.tmpl

## tmpl/cms/widget/blog_stats_comment.tmpl
	'Most Recent Comments' => 'Commentaires récents',
	'[_1] [_2], [_3] on [_4]' => '[_1] [_2], [_3] sur [_4]',
	'View all comments' => 'Voir tous les commentaires',
	'No comments available.' => 'Aucune commentaire disponible.',

## tmpl/cms/popup/rebuilt.tmpl
	'Success' => 'Succès',
	'All of your files have been published.' => 'Tous vos fichiers ont été publiés.',
	'Your [_1] has been published.' => 'Votre [_1] a été publiée.',
	'Your [_1] archives have been published.' => 'Vos archives [_1]  ont été publiées.',
	'Your [_1] templates have been published.' => 'Vos gabarites [_1] ont été publiées.',
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
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'Vous avez changé les privilèges pour ce rôle. Cela va modifier ce que les utilisateurs associés à ce rôle ont la possibilité de faire. Si vous préférez, vous pouvez sauvegarder ce rôle avec un nom différent.',
	'Role Details' => 'Détails du rôle',
	'Created by' => 'Créé par',
	'Check All' => 'Sélectionner tout',
	'Uncheck All' => 'Désélectionner tout',
	'Administration' => 'Administration',
	'Authoring and Publishing' => 'Auteurs et Publication',
	'Designing' => 'Designer',
	'Commenting' => 'Commenter',
	'Duplicate Roles' => 'Dupliquer les rôles',
	'These roles have the same privileges as this role' => 'Ces rôles ont les même privilèges que ce rôle',
	'Save changes to this role (s)' => 'Enregistrer les modifications de ce rôle (s)',

## tmpl/cms/cfg_plugin.tmpl
	'System Plugin Settings' => 'Paramètres du système de plugins',
	'Useful links' => 'Liens utiles',
	'http://plugins.movabletype.org/' => 'http://plugins.movabletype.org/',
	'Find Plugins' => 'Trouver des plugins',
	'Plugin System' => 'Système de plugins',
	'Manually enable or disable plugin-system functionality. Re-enabling plugin-system functionality, will return all plugins to their original state.' => 'Activer ou désactiver la prise en charge des plugins manuellement. La réactivation de cette prise en charge rendra à tous les plugins leur état original',
	'Disable plugin functionality' => 'Désactiver la prise en charge des plugins',
	'Disable Plugins' => 'Désactiver les plugins',
	'Enable plugin functionality' => 'Activer la prise en charge des plugins',
	'Enable Plugins' => 'Activer les plugins',
	'Your plugin settings have been saved.' => 'Les paramètres de votre plugin ont été enregistrés.',
	'Your plugin settings have been reset.' => 'Les paramètres de votre plugin on été réinitialisés.',
	'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => 'Vos plugins ont été reconfigurés. Si vous êtes sous mod_perl vous devez redémarrer votre serveur web pour la prise en compte de ces changements.',
	'Your plugins have been reconfigured.' => 'Votre plugin a été reconfiguré.',
	'Are you sure you want to reset the settings for this plugin?' => 'Êtes-vous sûr de vouloir ré-initialiser les paramètres pour ce plugin ?',
	'Are you sure you want to disable plugin functionality?' => 'Êtes-vous sûr de vouloir désactiver la prise en charge des plugins ?',
	'Disable this plugin?' => 'Désactiver ce plugin ?',
	'Are you sure you want to enable plugin functionality? (This will re-enable any plugins that were not individually disabled.)' => 'Êtes-vous sûr de vouloir activer les plugins ? (Cela ré-activera tous les plugins qui n\'ont pas été désactivés manuellement)',
	'Enable this plugin?' => 'Activer ce plugin ?',
	'Failed to Load' => 'Erreur de chargement',
	'(Disable)' => '(Désactiver)',
	'Enabled' => 'Activé',
	'(Enable)' => '(Activer)',
	'Settings for [_1]' => 'Paramètres pour [_1]',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be 100% functional. Furthermore, it will require an upgrade once you have upgraded to the next Movable Type major release (when available).' => 'Ce plugin n\'a pas été mis à jour pour supporter Movable Type [_1]. Ainsi, il n\'est peut-être pas fonctionnel à 100%. De plus, il nécessitera une mise à jour dès que vous aurez mis à jour Movable Type à la prochaine version majeure (quand elle sera disponible).',
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
	'Reset to Defaults' => 'Ré-initialiser (retour aux paramètres par défaut)',
	'No plugins with blog-level configuration settings are installed.' => 'Aucun plugin avec une configuration au niveau du blog n\'est installé.',
	'No plugins with configuration settings are installed.' => 'Aucun plugin avec une configuration n\'est installé',

## tmpl/cms/list_blog.tmpl
	'You have successfully deleted the blogs from the Movable Type system.' => 'Le blog a été correctement supprimé du système Movable Type.',
	'Create Blog' => 'Créer un blog',
	'Are you sure you want to delete this blog?' => 'Êtes-vous sûr de vouloir effacer ce blog ?',

## tmpl/cms/edit_template.tmpl
	'Create Template' => 'Créer le gabarit',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]">Recover auto-saved content</a>' => 'Une version de sauvegarde de [_1] a été automatiquement sauvegardée [_3]. <a href="[_2]">Récupérer le contenu sauvegardé</a>',
	'You have successfully recovered your saved [_1].' => 'Vous avez récupéré avec succès votre [_1] sauvegardée.',
	'An error occurred while trying to recover your saved [_1].' => 'Une erreur s\'est produite en essayant de récupérer votre [_1] sauvegardée.',
	'Your template changes have been saved.' => 'Les modifications apportées ont été enregistrées.',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => '<a href="[_1]" class="rebuild-link">Publier</a> ce gabarit.',
	'Useful Links' => 'Liens utiles',
	'List [_1] templates' => 'Lister des gabarits de type [_1]',
	'Template tag reference' => 'Référence des balises de gabarits',
	'Includes and Widgets' => 'Includes et Widgets',
	'create' => 'créer',
	'Tag Documentation' => 'Documentation des tags',
	'Unrecognized Tags' => 'Tags non reconnus',
	'Save (s)' => 'Enregistrer (s)',
	'Save and Publish this template (r)' => 'Enregistrer et publier ce gabarit (r)',
	'Save &amp; Publish' => 'Enregistrer &amp; publier',
	'You have unsaved changes to this template that will be lost.' => 'Certains de vos changements n\'ont pas été enregistrés : ils seront perdus.',
	'You must set the Template Name.' => 'Vous devez mettre un nom de gabarit.',
	'You must set the template Output File.' => 'Vous devez configurer le fichier de sortie du gabarit.',
	'Please wait...' => 'Merci de patienter...',
	'Error occurred while updating archive maps.' => 'Une erreur s\'est produite en mettant à jour les archive maps.',
	'Archive map has been successfully updated.' => 'L\'archive map a été modifiée avec succès.',
	'Are you sure you want to remove this template map?' => 'Êtes-vous sûr de vouloir supprimer ce mappage de gabarit ?',
	'Module Body' => 'Corps du module',
	'Template Body' => 'Corps du gabarit',
	'Syntax Highlight On' => 'Coloriage de la syntaxe activé',
	'Syntax Highlight Off' => 'Coloriage de la syntaxe désactivé',
	'Insert...' => 'Insertion...',
	'Template Type' => 'Type de gabarit',
	'Custom Index Template' => 'Gabarit d\'index personnalisé',
	'Publish Options' => 'Options de publication',
	'Enable dynamic publishing for this template' => 'Activer la publication dynamique pour ce gabarit',
	'Publish this template automatically when rebuilding index templates' => 'Publier ce gabarit automatiquement lorsque les gabarits d\'index sont republiés.',
	'Link to File' => 'Lien vers le fichier',
	'Create Archive Mapping' => 'Créer une nouvelle table de correspondance des archives',
	'Add' => 'Ajouter',
	'Auto-saving...' => 'Sauvegarde automatique...',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Dernière sauvegarde automatique à [_1]:[_2]:[_3]',

## tmpl/cms/dashboard.tmpl
	'Select a Widget...' => 'Sélectionner un widget...',
	'Your Dashboard has been updated.' => 'Votre tableau de bord a été mis à jour.',
	'You have attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'Vous avez essayé d\'accéder à une fonctionnalité à laquelle vous n\'avez pas le droit. Si vous pensez que cette erreur n\'est pas normale contactez votre administrateur système.',
	'The directory you have configured for uploading avatars is not writable. In order to enable users to upload userpics, please make the following directory writable by your web server: [_1]' => 'Le répertoire que vous avez configuré pour mettre les avatars n\'est pas accessible en écriture. Pour permettre aux utilisateurs de mettre leur propre icône, merci de rendre ce répertoire accessible en écriture par le serveur web: [_1]',
	'Your dashboard is empty!' => 'Votre tableau de bord est vide !',

## tmpl/cms/cfg_trackbacks.tmpl
	'TrackBack Settings' => 'Paramètres des trackbacks',
	'Your TrackBack preferences have been saved.' => 'Vos préférences de trackback ont été sauvegardées.',
	'Note: TrackBacks are currently disabled at the system level.' => 'Note: Les trackbacks sont actuellement désactivés au niveau système.',
	'Accept TrackBacks' => 'Accepter les trackbacks',
	'If enabled, TrackBacks will be accepted from any source.' => 'Si activé, les trackbacks seront acceptés quelle que soit la source.',
	'TrackBack Policy' => 'Règles pour les trackbacks',
	'Moderation' => 'Modération',
	'Hold all TrackBacks for approval before they\'re published.' => 'Retenir les trackbacks pour approbation avant publication.',
	'Apply \'nofollow\' to URLs' => 'Appliquer \'nofollow\' aux URLs',
	'This preference affects both comments and TrackBacks.' => 'Cette préférence affecte les commentaires et les trackbacks.',
	'If enabled, all URLs in comments and TrackBacks will be assigned a \'nofollow\' link relation.' => 'Si activé, toutes les URLs dans les commentaires et les trackbacks seront affectées d\'un attribut de lien \'nofollow\'.',
	'E-mail Notification' => 'Notification par email',
	'Specify when Movable Type should notify you of new TrackBacks if at all.' => 'Spécifier quand Movable Type doit vous notifier les nouveaux trackbacks.',
	'On' => 'Activée',
	'Only when attention is required' => 'Uniquement quand l\'attention est requise',
	'Off' => 'Désactivée',
	'TrackBack Options' => 'Options de trackback',
	'TrackBack Auto-Discovery' => 'Activer la découverte automatique des trackbacks',
	'If you turn on auto-discovery, when you write a new entry, any external links will be extracted and the appropriate sites automatically sent TrackBacks.' => 'Si vous activez la découverte automatique, quand vous écrivez une nouvelle note, tous les liens externes seront extraits et les sites correspondants recevront un trackback.',
	'Enable External TrackBack Auto-Discovery' => 'Pour les notes extérieures au blog',
	'Setting Notice' => 'Paramètre des informations',
	'Note: The above option may be affected since outbound pings are constrained system-wide.' => 'Attention : L\'option ci-dessous peut être affectée si les pings sortant sont limités dans le système.',
	'Setting Ignored' => 'Paramètre ignoré',
	'Note: The above option is currently ignored since outbound pings are disabled system-wide.' => 'Attention: l\'option ci-dessus est ignorée si les pings sortants sont désactivés dans le système',
	'Enable Internal TrackBack Auto-Discovery' => 'Pour les notes intérieures au blog',
	'Save changes to these settings (s)' => 'Enregistrer les modifications de ces paramètres (s)',

## tmpl/cms/list_entry.tmpl
	'Entries Feed' => 'Flux des Notes',
	'Pages Feed' => 'Flux des Pages',
	'The entry has been deleted from the database.' => 'Cette note a été supprimée de la base de données.',
	'The page has been deleted from the database.' => 'Cette page a été supprimée de la base de données.',
	'Quickfilters' => 'Filtres rapides',
	'[_1] (Disabled)' => '[_1] (Désactivé)',
	'Go back' => 'Retour',
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
	'is' => 'est',
	'published' => 'publié',
	'unpublished' => 'non publié',
	'scheduled' => 'programmé',
	'Select An Asset:' => 'Sélectionner Un Élément :',
	'Asset Search...' => 'Rechercher un Élément...',
	'Recent Assets...' => 'Éléments récents...',
	'Select A User:' => 'Sélectionner un utilisateur',
	'User Search...' => 'Recherche utilisateur...',
	'Recent Users...' => 'Utilisateurs récents...',
	'Filter' => 'Filtre',

## tmpl/cms/edit_commenter.tmpl
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

## tmpl/cms/cfg_system_general.tmpl
	'System: General Settings' => 'Paramètres généraux',
	'Your settings have been saved.' => 'Vos paramètres ont été enregistrés.',
	'(No blog selected)' => '(Aucun blog sélectionné)',
	'Select blog' => 'Sélectionner le blog',
	'You must set a valid Default Site URL.' => 'Vous devez définir une URL par défaut valide pour le site.',
	'You must set a valid Default Site Root.' => 'Vous devez définir une URL par défaut valide pour la Racine du Site.',
	'System Email' => 'Email système',
	'The email address used in the From: header of each email sent from the system.  The address is used in password recovery, commenter registration, comment, trackback notification and a few other minor events.' => 'Cette adresse email sera utilisée dans l\'en-tête From: des emails envoyés par le système. L\'adresse est utilisée dans la récupération des mots de passe, l\'enregistrement d\'auteurs de commentaires, les notifications de commentaires, trackbacks, ainsi que certains autres événements mineurs.',

## tmpl/cms/list_member.tmpl
	'Manage Users' => 'Gérer les Utilisateurs',
	'Are you sure you want to remove this role?' => 'Êtes-vous sûr(e) de vouloir supprimer ce rôle?',
	'Add a user to this blog' => 'Ajouter un utilisateur à ce blog',
	'Show only users where' => 'Afficher uniquement les utilisateurs où',
	'role' => 'rôle',
	'enabled' => 'activé',
	'disabled' => 'désactivé',
	'pending' => 'en attente',

## tmpl/cms/cfg_comments.tmpl
	'Comment Settings' => 'Paramètres des commentaires',
	'Your preferences have been saved.' => 'Vos préférences ont été sauvegardées.',
	'Note: Commenting is currently disabled at the system level.' => 'Note : Les commentaires sont actuellement désactivés au niveau système.',
	'Comment authentication is not available because one of the needed modules, MIME::Base64 or LWP::UserAgent is not installed. Talk to your host about getting this module installed.' => 'L\'authetification de commentaire n\'est pas active car le module MIME::Base64 or LWP::UserAgent est absent. Contactez votre hébergeur pour l\'installation de ce module.',
	'Accept Comments' => 'Accepter les commentaires',
	'If enabled, comments will be accepted.' => 'Si activé, les commentaires seront acceptés.',
	'Commenting Policy' => 'Règles pour les commentaires',
	'Immediately approve comments from' => 'Approuver immédiatement les commentaires de',
	'Specify what should happen to comments after submission. Unapproved comments are held for moderation.' => 'Spécifiez ce qui doit se passer après la soumission de commentaires. Les commentaires non-approuvés sont retenus pour modération.',
	'No one' => 'Personne',
	'Trusted commenters only' => 'Auteurs de commentaires fiables uniquement',
	'Any authenticated commenters' => 'Tout auteur de commentaire authentifié',
	'Anyone' => 'Tout le monde',
	'Allow HTML' => 'Autoriser le HTML',
	'If enabled, users will be able to enter a limited set of HTML in their comments. If not, all HTML will be stripped out.' => 'Si activé, l\'auteur de commentaires pourra entrer du HTML de façon limitée dans son commentaire. Sinon, le html ne sera pas pris en compte.',
	'Limit HTML Tags' => 'Limiter les balises HTML',
	'Specifies the list of HTML tags allowed by default when cleaning an HTML string (a comment, for example).' => 'Spécifie la liste des balises HTML autorisées par défaut lors du nettoyage d\'une chaîne HTML (un commentaire, par exemple).',
	'Use defaults' => 'Utiliser les valeurs par défaut',
	'([_1])' => '([_1])',
	'Use my settings' => 'Utiliser mes paramètres',
	'Disable \'nofollow\' for trusted commenters' => 'désactiver \'nofollow\' pour les auteurs de commentaires de confiance',
	'If enabled, the \'nofollow\' link relation will not be applied to any comments left by trusted commenters.' => 'Si activé, l\'attribut de lien \'nofollow\' ne sera appliqué à aucun commentaire déposé par un auteur de commentaires de confiance.',
	'Specify when Movable Type should notify you of new comments if at all.' => 'Spécifier quand Movable Type doit vous notifier les nouveaux commentaires.',
	'Comment Display Options' => 'Options d\'affichage des commentaires',
	'Comment Order' => 'Ordre des commentaires',
	'Select whether you want visitor comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Sélectionnez l\'ordre d\'affichage des commentaires publiés par les visiteurs : croissant (les plus anciens en premier) ou décroissant (les plus récents en premier).',
	'Ascending' => 'Croissant',
	'Descending' => 'Décroissant',
	'Auto-Link URLs' => 'Liaison automatique des URL',
	'If enabled, all non-linked URLs will be transformed into links to that URL.' => 'Si activé, toutes les urls non liées seront transformées en url actives.',
	'Text Formatting' => 'Mise en forme du texte',
	'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Spécifie les options de mise en forme du texte des commentaires publiés par les visiteurs.',
	'CAPTCHA Provider' => 'Fournisseur de CAPTCHA',
	'none' => 'aucune',
	'No CAPTCHA provider available' => 'Aucun fournisseur de CAPTCHA disponible',
	'No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed, and CaptchaSourceImageBase directive points to captcha-source directory under mt-static/images.' => 'Aucun fournisseur de CAPTCHA n\'est disponible sur ce système. Merci de vérifier si Image::Magick est installé, et si la directive CaptchaSourceImageBase contient le répertoire captcha-source dans mt-static/images.',
	'Use Comment Confirmation Page' => 'Utiliser la page de confirmation de commentaire',
	'Use comment confirmation page' => 'Utiliser la page de confirmation de commentaire',

## tmpl/cms/backup.tmpl
	'What to backup' => 'Ce qu\'il faut sauvegarder',
	'This option will backup Users, Roles, Associations, Blogs, Entries, Categories, Templates and Tags.' => 'Cette option va sauvegarder les utilisateurs, rôles, associations, blogs, notes, catégories, gabarits et tags.',
	'Everything' => 'Tout',
	'Choose blogs...' => 'Sélectionner les blogs...',
	'Archive Format' => 'Format d\'archive',
	'The type of archive format to use.' => 'Le type de format d\'archive à utiliser.',
	'Don\'t compress' => 'Ne pas compresser',
	'Target File Size' => 'Limiter la taille du fichier cible',
	'Approximate file size per backup file.' => 'Taille de fichier approximative par fichier de sauvegarde.',
	'Don\'t Divide' => 'Pas de limitation',
	'Make Backup (b)' => 'Sauvegarder (b)',
	'Make Backup' => 'Sauvegarder',

## tmpl/cms/edit_entry.tmpl
	'Create Page' => 'Créer une Page',
	'Add folder' => 'Ajouter un répertoire',
	'Add folder name' => 'Ajouter un nom de répertoire',
	'Add new folder parent' => 'Ajouter un nouveau répertoire parent',
	'Save this page (s)' => 'Enregistrer cette page (s)',
	'Preview this page (v)' => 'Prévisualiser cette page (v)',
	'Delete this page (x)' => 'Supprimer cette page (x)',
	'Add category' => 'Ajouter une catégorie',
	'Add category name' => 'Ajouter un nom de catégorie',
	'Add new category parent' => 'Ajouter une nouvelle catégorie parente',
	'Save this entry (s)' => 'Enregistrer cette note (s)',
	'Preview this entry (v)' => 'Prévisualiser cette note (v)',
	'Delete this entry (x)' => 'Supprimer cette note (x)',
	'A saved version of this entry was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Une version enregistrée de cette note a été sauvergardée automatiquement [_2]. <a href="[_1]">Récupérer le contenu sauvegardé automatiquement</a>',
	'A saved version of this page was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Une version enregistrée de cette page a été sauvergardée automatiquement [_2]. <a href="[_1]">Récupérer le contenu sauvegardé automatiquement</a>',
	'This entry has been saved.' => 'Cette note a été enregistrée',
	'This page has been saved.' => 'Cette page a été enregistrée',
	'One or more errors occurred when sending update pings or TrackBacks.' => 'Erreur lors de l\'envoi des pings ou des trackbacks.',
	'_USAGE_VIEW_LOG' => 'L\'erreur est enregistrée dans le <a href="[_1]">journal (logs)</a>.',
	'Your customization preferences have been saved, and are visible in the form below.' => 'Vos préférences ont été enregistrées et sont affichées dans le formulaire ci-dessous.',
	'Your changes to the comment have been saved.' => 'Les modifications apportées aux commentaires ont été enregistrées.',
	'Your notification has been sent.' => 'Votre notification a été envoyé.',
	'You have successfully recovered your saved entry.' => 'Vous avez récupéré le contenu sauvegardé de votre note avec succès.',
	'You have successfully recovered your saved page.' => 'Vous avez récupéré le contenu sauvegardé de votre page avec succès.',
	'An error occurred while trying to recover your saved entry.' => 'Une erreur est survenue lors de la tentative de récupération de la note enregistrée.',
	'An error occurred while trying to recover your saved page.' => 'Une erreur est survenue lors de la tentative de récupération de la page enregistrée.',
	'You have successfully deleted the checked comment(s).' => 'Les commentaires sélectionnés ont été supprimés.',
	'You have successfully deleted the checked TrackBack(s).' => 'Le(s) trackback(s) sélectionné(s) ont été correctement supprimé(s).',
	'Stats' => 'Stats',
	'Share' => 'Partager',
	'<a href="[_2]">[quant,_1,comment,comments]</a>' => '<a href="[_2]">[quant,_1,commentaire,commentaires]</a>',
	'<a href="[_2]">[quant,_1,trackback,trackbacks]</a>' => '<a href="[_2]">[quant,_1,trackback,trackbacks]</a>',
	'Unpublished' => 'Non publié',
	'You must configure this blog before you can publish this entry.' => 'Vous devez configurer ce blog avant de publier cette note.',
	'You must configure this blog before you can publish this page.' => 'Vous devez configurer ce blog avant de publier cette page.',
	'[_1] - Created by [_2]' => '[_1] - a été créé par [_2]',
	'[_1] - Published by [_2]' => '[_1] - a été publié par [_2]',
	'[_1] - Edited by [_2]' => '[_1] - a été édité par [_2]',
	'Publish On' => 'Publié le',
	'Publish Date' => 'Date de publication',
	'Select entry date' => 'Choisir la date de la note',
	'Unlock this entry&rsquo;s output filename for editing' => 'Déverrouiller le nom de fichier de la note pour le modifier',
	'Warning: If you set the basename manually, it may conflict with another entry.' => 'ATTENTION : Editer le nom de base manuellement peut créer des conflits avec d\'autres notes.',
	'Warning: Changing this entry\'s basename may break inbound links.' => 'ATTENTION : Changer le nom de base de cette note peut casser des liens entrants.',
	'Accept' => 'Accepter',
	'Outbound TrackBack URLs' => 'URLs trackbacks sortants',
	'View Previously Sent TrackBacks' => 'Afficher les trackbacks envoyés précédemment',
	'You have unsaved changes to this entry that will be lost.' => 'Certains de vos changements dans cette note n\'ont pas été enregistrés : ils seront perdus.',
	'You have unsaved changes to this page that will be lost.' => 'Certains de vos changements dans cette page n\'ont pas été enregistrés : ils seront perdus.',
	'Enter the link address:' => 'Saisissez l\'adresse du lien :',
	'Enter the text to link to:' => 'Saisissez le texte du lien :',
	'Your entry screen preferences have been saved.' => 'Vos préférences d\'édition ont été enregistrées.',
	'Your entry screen preferences have been saved. Please refresh the page to reorder the custom fields.' => 'Vos préférences d\'édition ont été enregistrées. Merci de recharger la page pour réordonner les champs personnalisés.',
	'Are you sure you want to use the Rich Text editor?' => 'Êtes-vous sûr de vouloir utiliser l\'éditeur de texte enrichi ?',
	'Make primary' => 'Rendre principal',
	'Add new' => 'Créer',
	'Fields' => 'Champs',
	'Body' => 'Corps',
	'Reset display options' => 'Ré-initialiser les options d\'affichage',
	'Reset display options to blog defaults' => 'Ré-initialiser les options d\'affichage avec les valeurs par défaut du blog',
	'Reset defaults' => 'Ré-initialiser les valeurs par défaut',
	'Previous' => 'Précédent',
	'Next' => 'Suivant',
	'Extended' => 'Etendu',
	'Format:' => 'Format :',
	'(comma-delimited list)' => '(liste délimitée par virgule)',
	'(space-delimited list)' => '(liste délimitée par espace)',
	'(delimited by \'[_1]\')' => '(délimitée par \'[_1]\')',
	'<a href="[_1]">QuickPost to [_2]</a> - Drag this link to your browser\'s toolbar then click it when you are on a site you want to blog about.' => '<a href="[_1]">QuickPost vers [_2]</a> - Glissez ce lien vers la barre d\'outils de votre navigateur et cliquez dessus à chaque fois que vous êtes sur un site dont vous voulez parler dans votre blog.',
	'None selected' => 'Aucune sélectionnée',

## tmpl/cms/view_log.tmpl
	'The activity log has been reset.' => 'Le journal (logs) a été réinitialisé.',
	'All times are displayed in GMT[_1].' => 'Toutes les heures sont affichées en GMT[_1].',
	'All times are displayed in GMT.' => 'Toutes les heures sont affichées en GMT.',
	'Show only errors' => 'Montrer uniquement les erreurs',
	'System Activity Log' => 'Journal (logs)',
	'Filtered' => 'Filtrés',
	'Filtered Activity Feed' => 'Flux d\'activité filtré',
	'Download Filtered Log (CSV)' => 'Télécharger le journal filtré (CSV)',
	'Download Log (CSV)' => 'Télécharger le journal (CSV)',
	'Clear Activity Log' => 'Effacer le journal (logs)',
	'Are you sure you want to reset the activity log?' => 'Êtes-vous sûr(e) de vouloir ré-initialiser le journal (logs) ?',
	'Showing all log records' => 'Affichage de toutes les données du journal',
	'Showing log records where' => 'Affichage des données du journal où',
	'Show log records where' => 'Afficher les données du journal où',
	'level' => 'le statut',
	'classification' => 'classification',
	'Security' => 'Sécurité',
	'Error' => 'Erreur',
	'Information' => 'Information',
	'Debug' => 'Debug',
	'Security or error' => 'Sécurité ou erreur',
	'Security/error/warning' => 'Sécurité/erreur/mise en garde',
	'Not debug' => 'Pas débugué',
	'Debug/error' => 'Debug/erreur',

## tmpl/cms/setup_initial_blog.tmpl
	'Create Your First Blog' => 'Créez votre premier blog',
	'The blog name is required.' => 'Le nom du blog est nécessaire.',
	'The blog URL is required.' => 'L\'url du blog est obligatoire.',
	'The publishing path is required.' => 'Le chemin de publication est nécessaire.',
	'The timezone is required.' => 'Le fuseau horaire est nécessaire.',
	'Template Set' => 'Ensemble de modèles',
	'Select the templates you wish to use for this new blog.' => 'Sélectionnez les modèles que vous souhaitez utiliser pour ce nouveau blog.',
	'Timezone' => 'Fuseau horaire',
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
	'Finish install (s)' => 'Terminer l\'installation',
	'Finish install' => 'Finir l\'installation',
	'Back (x)' => 'Retour',

## tmpl/cms/refresh_results.tmpl
	'Template Refresh' => 'Réactualiser les gabarits',
	'No templates were selected to process.' => 'Aucun gabarit sélectionné pour cette action.',
	'Return to templates' => 'Retourner aux gabarits',

## tmpl/cms/cfg_spam.tmpl
	'Spam Settings' => 'Paramètres du spam',
	'Your spam preferences have been saved.' => 'Vos préférences de spam ont été sauvegardées.',
	'Auto-Delete Spam' => 'Effacer automatiquement le spam',
	'If enabled, feedback reported as spam will be automatically erased after a number of days.' => 'Si activé, les commentaires notifiés comme spam seront automatiquement effacés après un certain nombre de jours.',
	'Delete Spam After' => 'Effacer le spam après',
	'When an item has been reported as spam for this many days, it is automatically deleted.' => 'Quand un élément a été notifié comme spam depuis tant de jours, il est automatiquement effacé.',
	'days' => 'jours',
	'Spam Score Threshold' => 'Niveau de filtrage du spam',
	'Comments and TrackBacks receive a spam score between -10 (complete spam) and +10 (not spam). Feedback with a score which is lower than the threshold shown above will be reported as spam.' => 'Les commentaires et les trackbacks reçoivent un score de spam entre -10 (spam assuré) et +10 (non spam). Un commentaire avec un score qui est plus faible que le seuil ci-dessus sera notifié comme spam.',
	'Less Aggressive' => 'Moins agressif',
	'Decrease' => 'Baisser',
	'Increase' => 'Augmenter',
	'More Aggressive' => 'Plus agressif',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Modifier le répertoire',
	'Your folder changes have been made.' => 'Vos modifications du répertoire ont été faites.',
	'You must specify a label for the folder.' => 'Vous devez spécifier un nom pour le répertoire.',
	'Save changes to this folder (s)' => 'Enregistrer les modifications de ce répertoire (s)',

## tmpl/cms/list_notification.tmpl
	'You have added [_1] to your address book.' => 'Vous avez ajouté [_1] à votre carnet d\'adresses.',
	'You have successfully deleted the selected contacts from your address book.' => 'Vous avez supprimé avec succès les contacts sélectionnés de votre carnet d\'adresses.',
	'Download Address Book (CSV)' => 'Télécharger le carnet d\'adresses (CSV)',
	'contact' => 'contact',
	'contacts' => 'contacts',
	'Create Contact' => 'Créer un contact',
	'Website URL' => 'URL du site',
	'Add Contact' => 'Ajouter un contact',

## tmpl/cms/export.tmpl
	'You must select a blog to export.' => 'Vous devez sélectionner un blog à exporter.',
	'_USAGE_EXPORT_1' => 'L\'exportation vous permet de sauvegarder le contenu de votre blog dans un fichier. Vous pourrez par la suite procéder à l\'importation de ce fichier si vous souhaitez restaurer vos notes ou transférer vos notes d\'un blog à un autre.',
	'Blog to Export' => 'Blog à exporter',
	'Select a blog for exporting.' => 'Sélectionnez un blog à exporter.',
	'Change blog' => 'Changer de blog',
	'Export Blog (s)' => 'Exporter le blog (s)',
	'Export Blog' => 'Exporter le blog',

## tmpl/cms/edit_category.tmpl
	'Edit Category' => 'Editer les catégories',
	'Your category changes have been made.' => 'Les modifications apportées ont été enregistrées.',
	'You must specify a label for the category.' => 'Vous devez spécifier un titre pour cette catégorie.',
	'_CATEGORY_BASENAME' => 'Nom de base',
	'This is the basename assigned to your category.' => 'Ceci est le nom de base assigné à votre catégorie.',
	'Unlock this category&rsquo;s output filename for editing' => 'Déverrouiller le nom de fichier de cette catégorie pour le modifier',
	'Warning: Changing this category\'s basename may break inbound links.' => 'Attention: changer le nom de la catégorie risque de casser des liens entrants.',
	'Inbound TrackBacks' => 'Trackbacks entrants',
	'Accept Trackbacks' => 'Accepter trackbacks',
	'If enabled, TrackBacks will be accepted for this category from any source.' => 'Si activé, les trackbacks seront acceptés pour cette catégorie quelle que soit la source.',
	'View TrackBacks' => 'Voir les trackbacks',
	'TrackBack URL for this category' => 'URL trackback pour cette catégorie',
	'_USAGE_CATEGORY_PING_URL' => 'Il s\'agit de l\'URL utilisée par vos lecteurs pour envoyer des trackbacks aux notes de votre blog. Si vous souhaitez permettre l\'envoi d\'un trackback à tous vos lecteurs, publiez cette URL. Si vous préférez réserver l\'envoi d\'un trackback à seulement certaines personnes, communiquez cette URL de manière privée. Enfin, si vous souhaitez inclure la liste des trackbacks entrant dans l\'index de votre gabarit, consultez la documentation Movable Type.',
	'Passphrase Protection' => 'Protection Passphrase',
	'Optional' => 'Optionnels',
	'Outbound TrackBacks' => 'Trackbacks sortants',
	'Trackback URLs' => 'URLs de trackback',
	'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you create an entry in this category. (Separate URLs with a carriage return.)' => 'Saisir les URLs des sites web auxquels vous souhaitez envoyer un trackback chaque fois que vous créez une note dans cette catégorie. (Séparez les URLs avec un retour chariot.)',
	'Save changes to this category (s)' => 'Enregistrer les modifications de cette catégorie (s)',

## tmpl/cms/list_banlist.tmpl
	'IP Banning Settings' => 'Paramètres des IP bannies',
	'IP addresses' => 'Adresses IP',
	'Delete selected IP Address (x)' => 'Effacer les adresses IP sélectionnées (x)',
	'You have added [_1] to your list of banned IP addresses.' => 'L\'adresse [_1] a été ajoutée à la liste des adresses IP bannies.',
	'You have successfully deleted the selected IP addresses from the list.' => 'L\'adresse IP sélectionnée a été supprimée de la liste.',
	'Ban IP Address' => 'Bannir l\'adresse IP',
	'Date Banned' => 'Bannie le :',

## tmpl/cms/list_ping.tmpl
	'Manage Trackbacks' => 'Gérer les Trackbacks',
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

## tmpl/cms/list_role.tmpl
	'Roles: System-wide' => 'Rôles : configuration globale',
	'You have successfully deleted the role(s).' => 'Vous avez supprimé avec succès le(s) rôle(s).',
	'roles' => 'rôles',
	'_USER_STATUS_CAPTION' => 'Statut',
	'Members' => 'Membres',
	'Role Is Active' => 'Le rôle est actif',
	'Role Not Being Used' => 'Le rôle n\'est pas utilisé',

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
	'[_1] where [_2] [_3]' => '[_1] où [_2] [_3]',

## tmpl/cms/cfg_web_services.tmpl
	'Web Services Settings' => 'Paramètres des services Web',
	'Your blog preferences have been saved.' => 'Les préférences de votre blog ont été enregistrées.',
	'Six Apart Services' => 'Services Six Apart',
	'Your TypeKey token is used to access Six Apart services like its free Authentication service.' => 'Votre code TypeKey est utilisé pour accéder aux services de Six Apart et notamment son service d\'authentification gratuit.',
	'TypeKey is enabled.' => 'TypeKey est activé.',
	'TypeKey token:' => 'Code TypeKey',
	'Clear TypeKey Token' => 'Effacer le code TypeKey',
	'Please click the Save Changes button below to disable authentication.' => 'Cliquez sur le bouton Enregistrer ci-dessous pour DESACTIVER l\'authentification.',
	'TypeKey is not enabled.' => 'TypeKey n\'est pas activé.',
	'or' => 'ou',
	'Obtain TypeKey token' => 'Obtenir le code TypeKey',
	'Please click the Save Changes button below to enable TypeKey.' => 'Merci de cliquer sur le bouton Enregistrer les modifications ci-dessous pour activer TypeKey.',
	'External Notifications' => 'Notifications externes',
	'Notify of blog updates' => 'Pinguer les sites :',
	'When this blog is updated, Movable Type will automatically notify the selected sites.' => 'Quand ce blog est mis à jour, Movable Type notifiera automatiquement les sites suivants.',
	'Note: This option is currently ignored since outbound notification pings are disabled system-wide.' => 'Remarque : cette option est actuellement ignorée car les pings de notification sortants sont désactivés pour tout le système.',
	'Others:' => 'Autres :',
	'(Separate URLs with a carriage return.)' => '(Séparer les URLs avec un retour chariot.)',
	'Recently Updated Key' => 'Clé récemment mise à jour',
	'If you have received a recently updated key (by virtue of your purchase), enter it here.' => 'Si vous avez reçu une mise à jour de la clef, saisissez-la ici.',

## tmpl/cms/list_template.tmpl
	'Blog Templates' => 'Gabarits du blog',
	'Blog Publishing Settings' => 'Paramètres de publication du blog',
	'All Templates' => 'Tous les gabarits',
	'You have successfully deleted the checked template(s).' => 'Les gabarits sélectionnés ont été supprimés.',
	'You have successfully refreshed your templates.' => 'Vous avez réactualisé avec succès vos gabarits.',
	'Your templates have been published.' => 'Vos gabarits ont bien été publiés.',
	'Create Archive Template:' => 'Créer une archive de gabarit',
	'Create [_1] template' => 'Créer un nouveau gabarit de [_1]',

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
	'[quant,_1,_2,_3]' => '[quant,_1,_2,_3',
	'[quant,_1,entry,entries]' => '[quant,_1,note,notes]',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all blogs?' => 'Le tag \'[_2]\' existe déjà. Êtes-vous sûr de vouloir fusionner \'[_1]\' et \'[_2]\' sur tous les blogs ?',
	'An error occurred while testing for the new tag name.' => 'Une erreur est survenue en testant la nouvelle balise.',

## tmpl/cms/install.tmpl
	'Create Your Account' => 'Créez votre compte',
	'The initial account name is required.' => 'Le nom initial du compte est nécessaire.',
	'Password recovery word/phrase is required.' => 'La phrase de récupération de mot de passe est requise.',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'La version Perl installée sur votre serveur ([_1]) es antérieure à la version minimale nécessaire ([_2]).',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Même si Movable Type semble fonctionner normalement, l\'application s\'exécute <strong>dans un environnement non testé et non supporté</strong>.  Nous vous recommandons fortement d\'installer une version de Perl supérieure ou égale à [_1].',
	'Do you want to proceed with the installation anyway?' => 'Souhaitez-vous tout de même poursuivre l\'installation ?',
	'View MT-Check (x)' => 'Voir MT-Check (x)',
	'Before you can begin blogging, you must create an administrator account for your system. When you are done, Movable Type will then initialize your database.' => 'Avant de pouvoir commencer à bloguer, vous devez créer un compte administrateur pour votre système. Une fois cela fait, Movable Type initialisera ensuite votre base de données.',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Pour poursuivre, vous devez vous authentifier correctement auprès de votre serveur LDAP.',
	'The name used by this user to login.' => 'Le nom utilisé par cet utilisateur pour s\'enregistrer.',
	'The name used when published.' => 'Le nom utilisé lors de la publication.',
	'The user&rsquo;s email address.' => 'Adresse email de l\'utilisateur',
	'Language' => 'Langue',
	'The user&rsquo;s preferred language.' => 'Langue préférée de l\'utilisateur.',
	'Select a password for your account.' => 'Sélectionnez un Mot de Passe pour votre compte.',
	'Password Confirm' => 'Mot de passe (confirmation)',
	'Repeat the password for confirmation.' => 'Répétez votre mot de passe pour confirmer.',
	'This word or phrase will be required to recover your password if you forget it.' => 'Ce mot ou cette expression vous seront nécessaires pour retrouver votre mot de passe. Ne les oubliez pas.',
	'Your LDAP username.' => 'Votre nom d\'utilisateur LDAP.',
	'Enter your LDAP password.' => 'Saisissez votre mot de passe LDAP.',

## tmpl/cms/cfg_system_feedback.tmpl
	'System: Feedback Settings' => 'Paramètres des feedbacks',
	'Your feedback preferences have been saved.' => 'Vos préférences feedback sont enregistrées.',
	'Feedback: Master Switch' => 'Feedback: paramètres globaux (agit sur tous les blogs)',
	'This will override all individual blog settings.' => 'Cela va écraser les paramètres de tous les blogs individuels',
	'Disable comments for all blogs' => 'Désactiver les commentaires sur tous les blogs',
	'Disable TrackBacks for all blogs' => 'Désactiver les trackbacks sur tous les blogs',
	'Outbound Notifications' => 'Notifications sortantes',
	'Notification pings' => 'Pings de notification',
	'This feature allows you to disable sending notification pings when a new entry is created.' => 'Cette fonctionnalité vous permet de désactiver l\'envoi de pings de notification quand une nouvelle note est créée.',
	'Disable notification pings for all blogs' => 'Désactiver les pings de notification pour tous les blogs',
	'Limit outbound TrackBacks and TrackBack auto-discovery for the purposes of keeping your installation private.' => 'Limiter les trackbacks sortants et les trackbacks d\'autorecherche dans le but de conserver le caractère privé de votre installation. ',
	'Allow to any site' => 'Autoriser sur tous les sites',
	'(No outbound TrackBacks)' => '(Pas de trackbacks sortants)',
	'Only allow to blogs on this installation' => 'Autoriser uniquement vers les blogs de cette installation.',
	'Only allow the sites on the following domains:' => 'Autoriser uniquement sur les domaines suivants:',

## tmpl/cms/edit_author.tmpl
	'Edit Profile' => 'Editer le Profil',
	'This profile has been updated.' => 'Ce profil a été mis à jour.',
	'A new password has been generated and sent to the email address [_1].' => 'Un nouveau mot de passe a été créé et envoyé à l\'adresse [_1].',
	'Your Web services password is currently' => 'Votre mot de passe est actuellement',
	'_WARNING_PASSWORD_RESET_SINGLE' => '_WARNING_PASSWORD_RESET_SINGLE',
	'Error occurred while removing userpic.' => 'Une erreur est survenue lors du retrait de l\'avatar.',
	'Status of user in the system. Disabling a user removes their access to the system but preserves their content and history.' => 'Statut de l\'utilisateur dans le système. En désactivant un utilisateur, vous supprimez son accès au système mais ne détruisez pas ses contenus et son historique ',
	'_USER_PENDING' => 'Utilisateur en attente',
	'The username used to login.' => 'L\'identifiant utilisé pour s\'identifier.',
	'External user ID' => 'ID utilisateur externe',
	'The email address associated with this user.' => 'L\'adresse email associée avec cet utilisateur.',
	'The URL of the site associated with this user. eg. http://www.movabletype.com/' => 'L\'URL du site associé à cet utilisateur. Exemple: http://www.movabletype.com/',
	'Userpic' => 'Image de l\'utilisateur',
	'The image associated with this user.' => 'L\'image associée à cet utilisateur.',
	'Select Userpic' => 'Sélectionner l\'image de l\'utilisateur',
	'Remove Userpic' => 'Supprimer l\'image de l\'utilisateur',
	'Change Password' => 'Changer de Mot de passe',
	'Current Password' => 'Mot de passe actuel',
	'Existing password required to create a new password.' => 'Mot de passe actuel nécessaire pour créer un nouveau mot de passe.',
	'Initial Password' => 'Mot de passe *',
	'Enter preferred password.' => 'Saisissez le mot de passe préféré.',
	'New Password' => 'Nouveau mot de passe',
	'Enter the new password.' => 'Saisissez le nouveau mot de passe.',
	'Confirm Password' => 'Mot de passe (confirmation) *',
	'This word or phrase will be required to recover a forgotten password.' => 'Ce mot ou cette phrase sera nécessaire pour récupérer un mot de passe oublié.',
	'Preferred language of this user.' => 'Langue préférée de cet utilisateur.',
	'Text Format' => 'Format du texte',
	'Preferred text format option.' => 'Option de format de texte préféré.',
	'(Use Blog Default)' => '(Utiliser la valeur par défaut du blog)',
	'Tag Delimiter' => 'Délimiteur de tags',
	'Preferred method of separating tags.' => 'Méthode préférée pour séparer les tags.',
	'Comma' => 'Virgule',
	'Space' => 'Espace',
	'Web Services Password' => 'Mot de passe Services Web',
	'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'Pour utilisation par les flux d\'activité et avec les clients XML-RPC ou ATOM.',
	'Reveal' => 'Révéler',
	'System Permissions' => 'Autorisations système',
	'Options' => 'Options',
	'Create personal blog for user' => 'Créer le blog personnel de l\'utilisateur',
	'Create User (s)' => 'Créer l\'Utilisateur (s)',
	'Save changes to this author (s)' => 'Enregistrer les modifications de cet auteur (s)',
	'_USAGE_PASSWORD_RESET' => 'Ci-dessous, vous pouvez ré-initialiser le mot de passe pour cet utilisateur. Si vous faites cela un mot de passe généré aléatoirement sera créé et envoyé par e-mail à : [_1].',
	'Initiate Password Recovery' => 'Récupérer le mot de passe',

## tmpl/cms/edit_comment.tmpl
	'The comment has been approved.' => 'Ce commentaire a été approuvé.',
	'Save changes to this comment (s)' => 'Enregistrer les modifications de ce commentaire (s)',
	'Delete this comment (x)' => 'Supprimer ce commentaire (x)',
	'Previous Comment' => 'Commentaire précédent',
	'Next Comment' => 'Commentaire suivant',
	'View entry comment was left on' => 'Voir la note sur laquelle ce commentaire a été déposé',
	'Reply to this comment' => 'Répondre à ce commentaire',
	'Update the status of this comment' => 'Mettre à jour le statut de ce commentaire',
	'Approved' => 'Approuvé',
	'Unapproved' => 'Non-approuvé',
	'Reported as Spam' => 'Notifié comme spam',
	'View all comments with this status' => 'Voir tous les commentaires avec ce statut',
	'Spam Details' => 'Détails du spam',
	'Total Feedback Rating: [_1]' => 'Note globale de Feedback: [_1]',
	'Score' => 'Score',
	'Results' => 'Résultats',
	'The name of the person who posted the comment' => 'Le nom de la personne qui a posté le commentaire',
	'(Trusted)' => '(Fiable)',
	'Ban Commenter' => 'Bannir l\'auteur de commentaires',
	'Untrust Commenter' => 'Considérer l\'auteur de commentaires comme pas sûr',
	'(Banned)' => '(Banni)',
	'Trust Commenter' => 'Considérer l\'auteur de commentaires comme sûr',
	'Unban Commenter' => 'Lever le bannissement de l\'auteur de commentaires',
	'View all comments by this commenter' => 'Afficher tous les commentaires de cet auteur de commentaires',
	'Email address of commenter' => 'Adresse email de l\'auteur de commentaires',
	'None given' => 'Non fourni',
	'URL of commenter' => 'URL de l\'auteur de commentaires',
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
	'Show only assets where' => 'Afficher seulement les éléments où',
	'type' => 'Type',

## tmpl/cms/import.tmpl
	'You must select a blog to import.' => 'Vous devez sélectionner un blog à importer.',
	'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Transférer les notes dans Movable Type depuis une autre installation Movable Type ou à partir d\'un autre outil de publication de blogs afin de créer une sauvegarde ou une copie.',
	'Blog to Import' => 'Blog à importer',
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
	'More options' => 'Plus d\'options',
	'Import File Encoding' => 'Encodage du fichier d\'import',
	'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'Par défaut, Movable Type va essayer de détecter automatiquement l\'encodage des caractères de vos fichiers importés.  Cependant, si vous rencontrez des difficultés, vous pouvez le paramétrer de manière explicite',
	'<mt:var name="display_name">' => '<mt:var name="display_name">',
	'Default category for entries (optional)' => 'Catégorie par défaut pour les notes (optionnel)',
	'You can specify a default category for imported entries which have none assigned.' => 'Vous pouvez spécifier une catégorie par défaut pour les notes importées qui n\'ont pas été assignées.',
	'Select a category' => 'Sélectionnez une catégorie',
	'Import Entries (s)' => 'Importer les notes (s)',
	'Import Entries' => 'Importer des notes',

## tmpl/cms/upgrade_runner.tmpl
	'Initializing database...' => 'Initialisation de la base de données...',
	'Upgrading database...' => 'Mise à jour de la base de données...',
	'Installation complete!' => 'Installation terminée !',
	'Upgrade complete!' => 'Mise à jour terminée !',
	'Starting installation...' => 'Début de l\'installation...',
	'Starting upgrade...' => 'Début de la mise à jour...',
	'Error during installation:' => 'Erreur lors de l\'installation :',
	'Error during upgrade:' => 'Erreur lors de la mise à jour :',
	'Return to Movable Type (s)' => 'Retour vers Movable Type',
	'Return to Movable Type' => 'Retourner à Movable Type',
	'Your database is already current.' => 'Votre base de données est déjà actualisée.',

## tmpl/cms/system_check.tmpl
	'User Counts' => 'Statistiques utilisateurs',
	'Number of users in this system.' => 'Nombre d\'utilisateurs enregistrés',
	'Total Users' => 'Utilisateurs au total',
	'Active Users' => 'Utilisateurs actifs',
	'Users who have logged in within 90 days are considered <strong>active</strong> in Movable Type license agreement.' => 'Les utilisateurs qui se sont connectés dans les 90 derniers jours sont considérés comme <strong>actifs</strong> dans les accords de licence Movable Type',
	'Movable Type could not find the script named \'mt-check.cgi\'. To resolve this issue, please ensure that the mt-check.cgi script exists and/or the CheckScript configuration parameter references it properly.' => 'Movable Type n\'a pu trouver le script nommé \'mt-check.cgi\'. Pour résoudre ce problème, assurez-vous que le script mt-check.cgi script existe et/ou que la configuration des paramètres de MTCheckScript le référence convenablement.',

## tmpl/cms/restore.tmpl
	'Restore from a Backup' => 'Restaurer à partir d\'une sauvegarde',
	'Perl module XML::SAX and/or its dependencies are missing - Movable Type can not restore the system without it.' => 'Le module Perl XML::SAX et/ou ses dépendances sont manquantes - Movable Type ne peut restaurer le système sans lui.',
	'Backup file' => 'Fichier de sauvegarde',
	'If your backup file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the \'import\' folder of your Movable Type directory.' => 'Si votre fichier de sauvegarde est situé sur votre ordinateur, vous pouvez l\'envoyer ici.  Autrement, Movable Type cherchera automatiquement dans le répertoire \'import\' de votre répertoire Movable Type.',
	'Check this and files backed up from newer versions can be restored to this system.  NOTE: Ignoring Schema Version can damage Movable Type permanently.' => 'Cochez ceci et les fichiers sauvegardés à partir d\'une version plus récente pourront être restaurés dans ce système. NOTE : Ignorer la version du schéma peut endommager Movable Type de manière permanente.',
	'Ignore schema version conflicts' => 'Ignorer les conflits de version de schéma',
	'Check this and existing global templates will be overwritten from the backup file.' => 'Cochez ceci et les gabarits globaux existants seront écrasés par ceux de la sauvegarde.',
	'Overwrite global templates.' => 'Ecraser les gabarits globaux.',
	'Restore (r)' => 'Restaurer (r)',

## tmpl/cms/cfg_archives.tmpl
	'Error: Movable Type was not able to create a directory for publishing your blog. If you create this directory yourself, assign sufficient permissions that allow Movable Type to create files within it.' => 'Erreur : Movable Type n\'a pas été capable de créer un répertoire pour publier votre blog. Si vous créez ce répertoire vous-même, assignez-lui des autorisations suffisantes pour que Movable Type puisse créer des fichiers dedans.',
	'Your blog\'s archive configuration has been saved.' => 'La configuration des archives de votre blog a été sauvegardée.',
	'You have successfully added a new archive-template association.' => 'L\'association gabarit/archive a réussi.',
	'You may need to update your \'Master Archive Index\' template to account for your new archive configuration.' => 'Vous aurez peut-être besoin de mettre à jour votre gabarit \'Index principal des archives\' pour activer la nouvelle configuration de vos archives.',
	'The selected archive-template associations have been deleted.' => 'Les associations gabarit/archive sélectionnées ont été supprimées.',
	'You must set your Local Site Path.' => 'Vous devez configurer le chemin local de votre site.',
	'You must set a valid Site URL.' => 'Vous devez spécifier une URL valide.',
	'You must set a valid Local Site Path.' => 'Vous devez spécifier un chemin local d\'accès valide.',
	'Publishing Paths' => 'Chemins de publication',
	'The URL of your website. Do not include a filename (i.e. exclude index.html). Example: http://www.example.com/blog/' => 'L\'URL de votre site web. Ne mettez pas un nom de fichier (par exemple excluez index.html). Exemple : http://www.exemple.com/blog/',
	'Unlock this blog&rsquo;s site URL for editing' => 'Déverrouillez l\'URL du site de ce blog pour le modifier',
	'Warning: Changing the site URL can result in breaking all the links in your blog.' => 'Attention : Modifier l\'URL du site peut rompre tous les liens de votre blog.',
	'The path where your index files will be published. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/blog' => 'Le chemin où votre fichiers d\'index seront publiés. Un chemin absolu (commençant par \'/\') est préférable, mais vous pouvez utiliser un chemin relatif au répertoire de Movable Type. Exemple : /home/melody/public_html/blog',
	'Unlock this blog&rsquo;s site path for editing' => 'Déverrouiller le chemin du site de ce blog pour le modifier',
	'Note: Changing your site root requires a complete publish of your site.' => 'Remarque : La modification de la racine de votre site nécessite une publication complète de votre site.',
	'Advanced Archive Publishing' => 'Publication avancée des archives',
	'Select this option only if you need to publish your archives outside of your Site Root.' => 'Sélectionnez cette option si vous avez besoin de publier vos archives en dehors de la racine du Site.',
	'Publish archives outside of Site Root' => 'Publier les archives en dehors de la racine du site',
	'Enter the URL of the archives section of your website. Example: http://archives.example.com/' => 'Saisissez l\'URL de la section des archives de votre site web. Exemple: http://archives.exemple.com/',
	'Unlock this blog&rsquo;s archive url for editing' => 'Déverrouillez l\'url de l\'archive du blog pour la modifier',
	'Warning: Changing the archive URL can result in breaking all the links in your blog.' => 'Attention : Si vous modifiez l\'URL d\'archive vous pouvez casser tous les liens dans votre blog.',
	'Enter the path where your archive files will be published. Example: /home/melody/public_html/archives' => 'Saisissez le chemin où vos fichiers archives seront publiés. Exemple : /home/melody/public_html/archives',
	'Warning: Changing the archive path can result in breaking all the links in your blog.' => 'Attention : Changer le chemin d\'archive peut casser tous les liens de votre blog.',
	'Publishing Options' => 'Options de publication',
	'Preferred Archive Type' => 'Type d\'archive préféré',
	'Used for creating links to an archived entry (permalink). Select from the archive types used in this blogs archive templates.' => 'Utilisé pour créer des liens vers une note archivée (lien permanent). Sélectionner parmi les types d\'archives utilisée dans les templates d\'archive du blog.',
	'No archives are active' => 'Aucune archive n\'est active',
	'Publishing Method' => 'Méthode de publication',
	'Publish all templates statically' => 'Publier tous les gabarits en statique',
	'Publish only Archive Templates dynamically' => 'Publier en dynamique seulement les gabarits d\'archive',
	'Set each template\'s Publish Options separately' => 'Régler les options de publication de chaque gabarit séparément',
	'Publish all templates dynamically' => 'Publier tous les gabarits dynamiquement',
	'Use Publishing Queue' => 'Utiliser la publication en mode File d\'attente',
	'Requires the use of a cron job to publish pages in the background.' => 'Requiert l\'utilisation d\'un cron job pour publier en tâche de fond.',
	'Use background publishing queue for publishing static pages for this blog' => 'Utiliser la publication en mode File d\'attente pour publier les pages statiques de ce blog',
	'Enable Dynamic Cache' => 'Activer le cache dynamique',
	'Turn on caching.' => 'Activer la mise en cache.',
	'Enable caching' => 'Activer le cache',
	'Enable Conditional Retrieval' => 'Activer la récupération conditionnelle',
	'Turn on conditional retrieval of cached content.' => 'Activer la récupération conditionnelle des contenus en cache.',
	'Enable conditional retrieval' => 'Activer la récupération conditionnelle',
	'File Extension for Archive Files' => 'Extension de fichier pour les fichiers d\'archives',
	'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'Entrez l\'extension du fichier d\'archive. Elle peut être au choix \'html\', \'shtml\', \'php\', etc. NB: Ne pas indiquer la période (\'.\').',

## tmpl/cms/rebuilding.tmpl
	'Publishing...' => 'Publication...',
	'Publishing [_1]...' => 'Publication [_1]...',
	'Publishing [_1] [_2]...' => 'Publication [_1] [_2]...',
	'Publishing [_1] dynamic links...' => 'Publication des liens dynamiques [_1]...',
	'Publishing [_1] archives...' => 'Publication des archives [_1]...',
	'Publishing [_1] templates...' => 'Publication des gabarits [_1]...',

## tmpl/cms/edit_asset.tmpl
	'Edit Asset' => 'Éditer les Éléments',
	'Your asset changes have been made.' => 'Vos modifications de l\'élément ont bien été apportées.',
	'[_1] - Modified by [_2]' => '[_1] - modifié par [_2]',
	'Appears in...' => 'Apparaît dans...',
	'Published on [_1]' => 'Publié sur [_1]',
	'Show all entries' => 'Afficher toutes les notes',
	'Show all pages' => 'Afficher toutes les pages',
	'This asset has not been used.' => 'Cet élément n\'est pas utilisé.',
	'Related Assets' => 'Éléments liés',
	'You must specify a label for the asset.' => 'Vous devez spécifier un titre pour l\'élément.',
	'Embed Asset' => 'Élément embarqué',
	'Save changes to this asset (s)' => 'Enregistrer les modifications de cet élément (s)',

## tmpl/cms/upgrade.tmpl
	'Time to Upgrade!' => 'Il est temps de mettre à jour !',
	'Upgrade Check' => 'Vérification des mises à jour',
	'Do you want to proceed with the upgrade anyway?' => 'Voulez-vous quand même continuer la mise a jour ?',
	'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Une nouvelle version de Movable Type a été installée. Nous avons besoin de faire quelques manipulations complémentaires pour mettre à jour votre base de données.',
	'Information about this upgrade can be found <a href=\'[_1]\' target=\'_blank\'>here</a>.' => 'Des informations à propos de cette mise à jour peuvent être obtenue <a href=\'[_1]\' target=\'_blank\'>ici</a>.',
	'In addition, the following Movable Type components require upgrading or installation:' => 'De plus, les composants suivants de Movable Type nécessitent une mise à jour ou une installation :',
	'The following Movable Type components require upgrading or installation:' => 'Les composants suivants de Movable Type nécessitent une mise à jour ou une installation :',
	'Begin Upgrade' => 'Commencer la mise à jour',
	'Congratulations, you have successfully upgraded to Movable Type [_1].' => 'Félicitations, vous avez mis à jour Movable Type à la version [_1].',
	'Your Movable Type installation is already up to date.' => 'Vous disposez de la dernière version de Movable Type.',

## tmpl/cms/edit_blog.tmpl
	'Your blog configuration has been saved.' => 'La configuration de votre blog a été sauvegardée.',
	'You must set your Blog Name.' => 'Vous devez configurer le nom du blog.',
	'You did not select a timezone.' => 'Vous n\'avez pas sélectionné de fuseau horaire.',
	'You must set your Site URL.' => 'Vous devez configurer l\'URL de votre site.',
	'Your Site URL is not valid.' => 'L\'adresse URL de votre site n\'est pas valide.',
	'You can not have spaces in your Site URL.' => 'Vous ne pouvez pas avoir d\'espaces dans l\'adresse URL de votre site.',
	'You can not have spaces in your Local Site Path.' => 'Vous ne pouvez pas avoir d\'espaces dans le chemin local de votre site.',
	'Your Local Site Path is not valid.' => 'Le chemin local de votre site n\'est pas valide.',
	'Blog Details' => 'Détails du Blog',
	'Name your blog. The blog name can be changed at any time.' => 'Nommez votre blog. Le nom du blog peut être changé à n\'importe quel moment.',
	'Enter the URL of your public website. Do not include a filename (i.e. exclude index.html). Example: http://www.example.com/weblog/' => 'Saisir l\'URL de votre site web public. N\'incluez pas un nom de fichier (comme index.html). Exemple : http://www.exemple.com/blog/',
	'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/weblog' => 'Saisissez le chemin où votre fichier d\'index principal sera situé. Un chemin absolu (qui commence par \'/\') est préféré, mais vous pouvez aussi utiliser un chemin relatif au répertoire Movable Type. Exemple : /home/melody/public_html/blog',
	'Create Blog (s)' => 'Créer le Blog (s)',

## tmpl/cms/pinging.tmpl
	'Trackback' => 'Trackback',
	'Pinging sites...' => 'Envoi de ping(s)...',

## tmpl/cms/cfg_prefs.tmpl
	'Enter a description for your blog.' => 'Saisissez une description pour votre blog.',
	'License' => 'Licence',
	'Your blog is currently licensed under:' => 'Votre blog est actuellement sous licence :',
	'Change license' => 'Changer licence',
	'Remove license' => 'Retirer licence',
	'Your blog does not have an explicit Creative Commons license.' => 'Votre blog n\'a pas de licence Creative Commons explicite.',
	'Select a license' => 'Sélectionner une licence',

## tmpl/cms/restore_start.tmpl
	'Restoring Movable Type' => 'Restauration de Movable Type',

## tmpl/cms/preview_entry.tmpl
	'Preview [_1]' => 'Pré-visualiser [_1]',
	'Re-Edit this [_1]' => 'Modifier à nouveau cette [_1]',
	'Re-Edit this [_1] (e)' => 'Modifier à nouveau cette [_1] (e)',
	'Save this [_1]' => 'Enregistrer cette [_1]',
	'Save this [_1] (s)' => 'Enregistrer cette [_1] (s)',
	'Cancel (c)' => 'Annuler (c)',

## tmpl/cms/list_folder.tmpl
	'Manage Folders' => 'Gérer les Répertoires',
	'Your folder changes and additions have been made.' => 'Vos modifications du répertoire ont bien été apportées.',
	'You have successfully deleted the selected folder.' => 'Vous avez supprimé avec succès le répertoire sélectionné',
	'Delete selected folders (x)' => 'Supprimer les répertoires sélectionnés (x)',
	'Create top level folder' => 'Créer un répertoire de premier niveau',
	'New Parent [_1]' => 'Nouveau [_1] parent',
	'Create Folder' => 'Créer un Répertoire',
	'Top Level' => 'Niveau racine',
	'Create Subfolder' => 'Créer un Sous-répertoire',
	'Move Folder' => 'Déplacer un Répertoire',
	'Move' => 'Déplacer',
	'[quant,_1,page,pages]' => '[quant,_1,page,pages]',
	'No folders could be found.' => '', # Translate - New

## tmpl/cms/list_association.tmpl
	'permission' => 'Autorisation',
	'permissions' => 'Autorisations',
	'Remove selected permissions (x)' => 'Retirer les autorisations sélectionnées (x)',
	'Revoke Permission' => 'Retirer l\'autorisation',
	'[_1] <em>[_2]</em> is currently disabled.' => '[_1] <em>[_2]</em> est actuellement désactivé.',
	'Grant Permission' => 'Ajouter une autorisation',
	'You can not create permissions for disabled users.' => 'Vous ne pouvez pas créer d\'autorisations pour les utilisateurs désactivés',
	'Assign Role to User' => 'Ajouter le rôle à l\'utilisateur',
	'Grant permission to a user' => 'Ajouter une autorisation à un utilisateur',
	'You have successfully revoked the given permission(s).' => 'Vous avez révoqué avec succès les autorisations sélectionnées.',
	'You have successfully granted the given permission(s).' => 'Vous avez attribué avec succès les autorisations sélectionnées.',
	'No permissions could be found.' => 'Aucune autorisation n\'a pu être trouvée.',

## tmpl/cms/login.tmpl
	'Your Movable Type session has ended.' => 'Votre session Movable Type a été fermée.',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Votre session Movable Type est terminée. Si vous souhaitez vous identifier à nouveau, vous pouvez le faire ci-dessous.',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Votre session Movable Type est terminée. Merci de vous identifier à nouveau pour continuer cette action.',
	'Forgot your password?' => 'Vous avez oublié votre mot de passe ?',
	'Sign In (s)' => 'Connexion (s)',

## tmpl/cms/list_category.tmpl
	'Your category changes and additions have been made.' => 'Vos modifications de la catégorie ont bien été apportées.',
	'You have successfully deleted the selected category.' => 'Vous avez supprimé avec succès la catégorie sélectionnée',
	'categories' => 'Catégories',
	'Delete selected category (x)' => 'Supprimer la catégorie sélectionnée (x)',
	'Create top level category' => 'Créer une catégorie de premier niveau',
	'Create Category' => 'Créer une Catégorie',
	'Collapse' => 'Réduire',
	'Expand' => 'Développer',
	'Move Category' => 'Déplacer une Catégorie',
	'[quant,_1,TrackBack,TrackBacks]' => '[quant,_1,trackback,trackbacks]',
	'No categories could be found.' => '', # Translate - New

## tmpl/cms/cfg_entry.tmpl
	'Entry Settings' => 'Paramètres des notes',
	'Display Settings' => 'Préférences d\'affichage',
	'Entry Listing Default' => 'Listage des notes par défaut',
	'Select the number of days of entries or the exact number of entries you would like displayed on your blog.' => 'Sélectionner le nombre de jours de notes ou le nombre exact de notes que vous voulez afficher sur votre blog.',
	'Days' => 'Jours',
	'Entry Order' => 'Ordre des notes',
	'Select whether you want your entries displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Choisissez si vous voulez afficher vos notes en ascendant (les plus anciennes en haut) ou descendant (les plus récentes en haut).',
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
	'New Entry Defaults' => 'Préférences pour les nouvelles notes',
	'Specifies the default Entry Status when creating a new entry.' => 'Spécifie le statut de note par défaut quand une nouvelle note est créée.',
	'Specifies the default Text Formatting option when creating a new entry.' => 'Spécifie l\'option par défaut de mise en forme du texte des nouvelles notes.',
	'Specifies the default Accept Comments setting when creating a new entry.' => 'Spécifie l\'option par défaut des commentaires acceptés lors de la création d\'une nouvelle note.',
	'Note: This option is currently ignored since comments are disabled either blog or system-wide.' => 'Remarque : Cette option est actuellement ignorée car les commentaires sont désactivés sur le blog ou sur tout le système.',
	'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Spécifie l\'option par défaut des trackbacks acceptés lors de la création d\'une nouvelle note.',
	'Note: This option is currently ignored since TrackBacks are disabled either blog or system-wide.' => 'Remarque : Cette option est actuellement ignorée car les trackbacks sont désactivés soit sur le blog, soit au niveau de tout le système.',
	'Replace Word Chars' => 'Remplacer les caractères de Word',
	'Smart Replace' => 'Remplacer par',
	'Replace UTF-8 characters frequently used by word processors with their more common web equivalents.' => 'Remplacer les caractères UTF-8 utilisés fréquemment par l\'éditeur de texte par leur équivalent web le plus commun.',
	'No substitution' => 'Ne pas effectuer de remplacements',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'Entités de caractères (&amp#8221;, &amp#8220;, etc.)',
	'ASCII equivalents (&quot;, \', ..., -, --)' => 'Equivalents ASCII (&quot;, \', ..., -, --)',
	'Replace Fields' => 'Appliquer le remplacement des caractères dans les champs',
	'Extended entry' => 'Suite de la note',
	'Default Editor Fields' => 'Champs d\'édition par défaut',
	'Editor Fields' => 'Champs d\'édition',
	'_USAGE_ENTRYPREFS' => 'La configuration des champs détermine les champs de saisie qui apparaîtront dans les écrans de création et de modification des notes. Vous pouvez sélectionner une configuration existante (basique ou avancée), ou personnaliser vos écrans en activant le bouton Personnalisée, puis en sélectionnant les champs que vous souhaitez voir apparaître.',
	'Action Bars' => 'Barres de tâches',
	'Select the location of the entry editor&rsquo;s action bar.' => 'Sélectionner l\'emplacement de la barre d\'action de l\'éditeur de note.',

## tmpl/cms/cfg_system_users.tmpl
	'System: User Settings' => 'Paramètres des utilisateurs',
	'(None selected)' => '(Aucune sélection)',
	'User Registration' => 'Enregistrement utilisateur',
	'Allow Registration' => 'Autoriser les enregistrements',
	'Select a system administrator you wish to notify when commenters successfully registered themselves.' => 'Sélectionnez un administrateur que vous souhaitez notifier quand les auteurs de commentaires s\'enregistrent avec succès.',
	'Allow commenters to register to Movable Type' => 'Autoriser les auteurs de commentaires à s\'enregistrer dans Movable Type',
	'Notify the following administrators upon registration:' => 'Notifier les administrateurs suivants lors de l\'enregistrement:',
	'Select Administrators' => 'Sélectionner les administrateurs',
	'Clear' => 'Clair',
	'Note: System Email Address is not set. Emails will not be sent.' => 'Note: l\'adresse Email Système n\'est pas paramètrée.  Les emails ne seront pas envoyés.',
	'New User Defaults' => 'Paramètres par défaut pour les nouveaux utilisateurs',
	'Personal blog' => 'Blog personnel',
	'Check to have the system automatically create a new personal blog when a user is created in the system. The user will be granted a blog administrator role on the blog.' => 'Vérifier à ce que le système créé automatiquement un nouveau blog personnel lorsqu\'un utilisateur est créé. L\'utilisateur sera verra alors octroyer un rôle d\'administrateur sur ce blog',
	'Automatically create a new blog for each new user' => 'Créer automatiquement un nouveau blog pour chaque nouvel utilisateur',
	'Personal blog clone source' => 'Source du blog personnel à dupliquer',
	'Select a blog you wish to use as the source for new personal blogs. The new blog will be identical to the source except for the name, publishing paths and permissions.' => 'Sélectionner le blog que vous souhaitez utiliser comme source pour les nouveau blogs personnels. Le nouveau blog sera ainsi identique à la source, excepté le nom, les chemins de publication et les autorisations.',
	'Default Site URL' => 'URL par défaut du site',
	'Define the default site URL for new blogs. This URL will be appended with a unique identifier for the blog.' => 'Spécifie l\'URL par défaut pour les nouveaux blogs. Cette URL sera complétée avec un identifiant unique pour le blog',
	'Default Site Root' => 'Racine du site par défaut',
	'Define the default site root for new blogs. This path will be appended with a unique identifier for the blog.' => 'Spécifie le chemin de publication par défaut pour les nouveaux blogs. Ce chemin sera complété avec un identifiant unique pour le blog',
	'Default User Language' => 'Langue par défaut',
	'Define the default language to apply to all new users.' => 'Définir la langue par défaut à appliquer à chaque nouvel utilisateur',
	'Default Timezone' => 'Fuseau horaire par défaut',
	'Default Tag Delimiter' => 'Délimiteur de tags par défaut',
	'Define the default delimiter for entering tags.' => 'Définir un délimiteur par défaut pour la saisie des tags.',

## tmpl/cms/recover_password_result.tmpl
	'Recover Passwords' => 'Retrouver les mots de passe',
	'No users were selected to process.' => 'Aucun utilisateur sélectionné pour l\'opération.',
	'Return' => 'Retour',

## tmpl/cms/cfg_registration.tmpl
	'Registration Settings' => 'Paramètres des enregistrements',
	'Allow registration for Movable Type.' => 'Autoriser les enregistrements pour Movable Type.',
	'Registration Not Enabled' => 'Enregistrement non activé',
	'Note: Registration is currently disabled at the system level.' => 'Remarque : L\'enregistrement est actuellement désactivé pour tout le système.',
	'Authentication Methods' => 'Méthode d\'authentification',
	'Note: You have selected to accept comments from authenticated commenters only but authentication is not enabled. In order to receive authenticated comments, you must enable authentication.' => 'Attention: vous avez sélectionné d\'accepter uniquement les commentaires de les auteurs de commentaires identifiés MAIS l\'authentification n\'est pas activée. Vous devez l\'activer pour recevoir les commentaire à autoriser.',
	'Native' => 'Natif',
	'Require E-mail Address for Comments via TypeKey' => 'Oblige à saisir l\'adresse email pour les commentaires avec TypeKey',
	'If enabled, visitors must allow their TypeKey account to share e-mail address when commenting.' => 'Si activé, les visiteurs doivent autoriser leur compte TypeKey à partager leur adresse email lorsqu\'ils commentent.',
	'Setup TypeKey' => 'Installation TypeKey',
	'OpenID providers disabled' => 'Fournisseurs OpenID désactivés',
	'Required module (Digest::SHA1) for OpenID commenter authentication is missing.' => 'Le module obligatoire (Digest::SHA1) pour l\'authentification des auteurs de commentaires avec OpenID est absent.',

## tmpl/cms/list_author.tmpl
	'Users: System-wide' => 'Utilisateurs : configuration globale',
	'_USAGE_AUTHORS_LDAP' => 'Voici la liste de tous les utilisateurs de Movable Type dans le système. Vous pouvez modifier les autorisations accordées à un utilisateur en cliquant sur son nom. Vous pouvez désactiver un utilisateur en cochant la case à coté de son nom, puis en cliquant sur DÉSACTIVER. L\'utilisateur ne pourra plus s\'identifier sur Movable Type.',
	'You have successfully disabled the selected user(s).' => 'Vous avez désactivé avec succès les utilisateurs sélectionnés.',
	'You have successfully enabled the selected user(s).' => 'Vous avez activé avec succès les utilisateurs sélectionnés.',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'Vous avez supprimé avec succès les utilisateurs dans le système.',
	'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Enterprise.' => 'Les utilisateurs effacés existent encore dans le répertoire externe. En conséquence ils pourront encore s\'identifier dans Movable Type Entreprise',
	'You have successfully synchronized users\' information with the external directory.' => 'Vous avez synchronisé avec succès les informations des utilisateurs avec le répertoire externe.',
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => 'Certains des utilisateurs sélectionnés ([_1])ne peuvent pas être ré-activés car ils ne sont pas dans le répertoire externe.',
	'An error occured during synchronization.  See the <a href=\'[_1]\'>activity log</a> for detailed information.' => 'Une erreur s\'est produite durant la synchronisation.  Consultez le <a href=\'[_1]\'>journal (logs)</a> pour plus d\'informations.',
	'Enable selected users (e)' => 'Activer les utilisateurs sélectionnés (e)',
	'_USER_ENABLE' => 'Activer',
	'_NO_SUPERUSER_DISABLE' => 'Puisque vous êtes administrateur du système Movable Type, vous ne pouvez vous désactiver vous-même.',
	'Disable selected users (d)' => 'Désactiver les utilisateurs sélectionnés (d)',
	'_USER_DISABLE' => 'Désactiver',
	'Showing All Users' => 'Afficher tous les utilisateurs',

## tmpl/cms/import_others.tmpl
	'Start title HTML (optional)' => 'HTML de début de titre (optionnel)',
	'End title HTML (optional)' => 'HTML de fin du titre (optionnel)',
	'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => 'Si le logiciel à partir duquel vous importez n\'a pas de champ Titre, vous pouvez utiliser ce paramètre pour identifier un titre dans le corps de votre note.',
	'Default entry status (optional)' => 'Statut des notes par défaut (optionnel)',
	'If the software you are importing from does not specify an entry status in its export file, you can set this as the status to use when importing entries.' => 'Si le logiciel à partir duquel vous importez ne spécifie pas un statut pour les notes dans son fichier d\'export, vous pouvez utiliser ce statut-ci lors de l\'importation des notes.',
	'Select an entry status' => 'Sélectionner un statut de note',

## tmpl/cms/search_replace.tmpl
	'You must select one or more item to replace.' => 'Vous devez sélectionner un ou plusieurs objets à remplacer.',
	'Search Again' => 'Chercher encore',
	'Submit search (s)' => 'Soumettre la recherche (s)',
	'Replace' => 'Remplacer',
	'Replace Checked' => 'Remplacer les objets sélectionnés',
	'Case Sensitive' => 'Sensible à la casse',
	'Regex Match' => 'Expression Régulière',
	'Limited Fields' => 'Champs limités',
	'Date Range' => 'Période (date)',
	'Reported as Spam?' => 'Notifié comme spam ?',
	'Search Fields:' => 'Rechercher les champs :',
	'_DATE_FROM' => 'Depuis le',
	'_DATE_TO' => 'jusqu\'au',
	'Successfully replaced [quant,_1,record,records].' => 'Remplacements effectués avec succès dans [quant,_1,enregistrement,enregistrements].',
	'Showing first [_1] results.' => 'Afficher d\'abord [_1] résultats.',
	'Show all matches' => 'Afficher tous les résultats',
	'[quant,_1,result,results] found' => '[quant,_1,résultat trouvé,résultats trouvés]',

## tmpl/cms/preview_strip.tmpl
	'Save this entry' => 'Enregistrer cette note',
	'Save this page' => 'Enregistrer cette page',
	'You are previewing the entry titled &ldquo;[_1]&rdquo;' => 'Vous prévisualisez la note suivante : &ldquo;[_1]&rdquo;',
	'You are previewing the page titled &ldquo;[_1]&rdquo;' => 'Vous prévisualisez la page suivante : &ldquo;[_1]&rdquo;',

## tmpl/cms/edit_ping.tmpl
	'Edit Trackback' => 'Éditer les  Trackbacks',
	'The TrackBack has been approved.' => 'Le trackback a été approuvé.',
	'List &amp; Edit TrackBacks' => 'Lister &amp; éditer les trackbacks',
	'View Entry' => 'Afficher la note',
	'Save changes to this TrackBack (s)' => 'Enregistrer les modifications de ce Trackback (s)',
	'Delete this TrackBack (x)' => 'Supprimer ce Trackback (x)',
	'Update the status of this TrackBack' => 'Modifier le statut de ce trackback',
	'Junk' => 'Indésirable',
	'View all TrackBacks with this status' => 'Voir tous les trackbacks avec ce statut',
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

## tmpl/comment/register.tmpl
	'Create an account' => 'Créer un compte',
	'Your email address.' => 'Votre adresse email.',
	'Your login name.' => 'Votre nom d\'utilisateur.',
	'The name appears on your comment.' => 'Le nom apparaît dans votre commentaire.',
	'Select a password for yourself.' => 'Sélectionnez un mot de passe pour vous.',
	'This word or phrase will be required to recover the password if you forget it.' => 'Ce mot ou cette expression vous seront demandés pour retrouver le mot de passe si vous l\'oubliez.',
	'The URL of your website. (Optional)' => 'URL de votre site internet (en option)',
	'Register' => 'S\'enregistrer',

## tmpl/comment/signup.tmpl

## tmpl/comment/login.tmpl
	'Sign in to comment' => 'Identifiez-vous pour commenter',
	'Sign in using' => 'S\'identifier en utilisant',
	'Remember me?' => 'Mémoriser les informations de connexion ?',
	'Not a member?&nbsp;&nbsp;<a href="[_1]">Sign Up</a>!' => 'Pas encore membre?&nbsp;&nbsp;<a href="[_1]">Enregistrez-vous</a>!',

## tmpl/comment/error.tmpl
	'Go Back (s)' => 'Retour (s)',

## tmpl/comment/signup_thanks.tmpl
	'Thanks for signing up' => 'Merci de vous être enregistré(e)',
	'Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].' => 'Avant de pouvoir déposer un commentaire vous devez terminer la prodécure d\'enregistrement en confirmant votre compte.  Un email a été envoyé à l\'adresse suivante : [_1].',
	'To complete the registration process you must first confirm your account. An email has been sent to [_1].' => 'Pour terminer la procédure d\'enregistrement vous devez confirmer votre compte. Un email a été envoyé à [_1].',
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'Pour confirmer et activer votre compte merci de vérifier votre boite email et de cliquer sur le lien que nous venons de vous envoyer.',
	'Return to the original entry.' => 'Retour à la note originale.',
	'Return to the original page.' => 'Retour à la page originale.',

## tmpl/comment/profile.tmpl
	'Your Profile' => 'Votre profil',
	'Password recovery' => 'Récupération de mot de passe',
	'Return to the <a href="[_1]">original page</a>.' => 'Retourner sur la <a href="[_1]">page originale</a>.',

## tmpl/feeds/feed_entry.tmpl
	'Unpublish' => 'Dé-publier',
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
	'Please enter some value for required \'[_1]\' field.' => 'Merci de saisir une valeur pour le champ obligatoire \'[_1]\'.',
	'Please ensure all required fields have been filled in.' => 'Merci de vérifier que tous les champs obligatoires ont été remplis.',
	'The template tag \'[_1]\' is an invalid tag name.' => 'Le tag de gabarit \'[_1]\' est un nom de tag invalide',
	'The template tag \'[_1]\' is already in use.' => 'Le tag de gabarit \'[_1]\' est déjà utilisé.',
	'The basename \'[_1]\' is already in use.' => 'Le nom de base \'[_1]\' est déjà utilisé.',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'Personnalisez les champs des notes, pages, répertoires, catégories et auteurs pour stocker toutes les informations dont vous avez besoin.',
	' ' => ' ', # Translate - Case
	'Single-Line Text' => 'Texte sur une ligne',
	'Multi-Line Textfield' => 'Champ texte de plusieurs lignes',
	'Checkbox' => 'Case à cocher',
	'Date and Time' => 'Date et heure',
	'Drop Down Menu' => 'Menu déroulant',
	'Radio Buttons' => 'Boutons radio',

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	'Are you sure you have used a \'[_1]\' tag in the correct context? We could not find the [_2]' => 'Etes-vous sûr d\'avoir utilisé un tag \'[_1]\' dans le contexte approprié ? Impossible de trouver le [_2]',
	'You used an \'[_1]\' tag outside of the context of the correct content; ' => 'Vous avez utilisé un tag \'[_1]\' en dehors du contexte du contenu correct; ',

## addons/Commercial.pack/lib/CustomFields/Upgrade.pm
	'Moving metadata storage for pages...' => 'Déplacement de l\'emplacement des métadonnées des pages en cours ...',

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Restoring custom fields data stored in MT::PluginData...' => 'Restauration des données des champs personnalisés stockées dans MT:PluginData...',
	'Restoring asset associations found in custom fields ( [_1] ) ...' => 'Restauration des associations d\'éléments trouvés dans les champs personnalisés ([_1]) ...',
	'Restoring url of the assets associated in custom fields ( [_1] )...' => 'Restauration des URLs des éléments associés dans les champs personnalisés ([_1]) ...',

## addons/Commercial.pack/lib/CustomFields/Util.pm
	'Failed to find [_1]::[_2]' => 'Impossible de trouver [_1]::[_2]',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'Field' => 'Champ',

## addons/Commercial.pack/tmpl/date-picker.tmpl
	'Select date' => 'Sélectionner la date',

## addons/Commercial.pack/tmpl/edit_field.tmpl
	'New Field' => 'Nouveau champ',
	'The selected fields(s) has been deleted from the database.' => 'Les champs sélectionnés ont été effacés de la base de données.',
	'Please ensure all required fields (highlighted) have been filled in.' => 'Merci de vérifier que tous les champs obligatoires ont été remplis.',
	'System Object' => 'Objet système',
	'Select the system object this field is for' => 'Sélectionner l\'objet système auquel ce champ est rattaché',
	'Select...' => 'Sélectionnez...',
	'Required?' => 'Obligatoire?',
	'Should a value be chosen or entered into this field?' => 'Une valeur doit-elle être choisie ou saisie dans ce champ?',
	'Default' => 'Défaut',
	'You will need to first save this field in order to set a default value' => 'Vous devez d\'abord enregistrer ce champ pour pouvoir mettre une valeur par défaut',
	'_CF_BASENAME' => 'Nom de base',
	'The basename is used for entering custom field data through a 3rd party client. It must be unique.' => 'Le nom de base est utilisé pour entrer les données d\'un champs personnalisé à travers un logiciel tiers. Il doit être unique. ',
	'Unlock this for editing' => 'Déverrouiller pour modifier',
	'Warning: Changing this field\'s basename may cause serious data loss.' => 'Attention: Changer le nom de base du champ peut causer des pertes de données sérieuses.',
	'Template Tag' => 'Tag du gabarit',
	'Create a custom template tag for this field.' => 'Créer un tag de gabarit personnalisé pour ce champ.',
	'Example Template Code' => 'Code de gabarit exemple',
	'Save this field (s)' => 'Enregistrer ce champs (s)',
	'field' => 'champ',
	'fields' => 'Champs',
	'Delete this field (x)' => 'Supprimer ce champs (x)',

## addons/Commercial.pack/tmpl/reorder_fields.tmpl
	'Your field order has been saved. Please refresh this page to see the new order.' => 'L\'ordre des champs a été sauvegardé. Merci de recharger cette page pour voir le nouvel ordre.',
	'Reorder Fields' => 'Réordonner les champs',
	'Save field order' => 'Enregistrer l\'ordre des champs',
	'Close field order widget' => 'Fermer le module de changement d\'ordre des champs',
	'open' => 'ouvrir',
	'close' => 'fermer',
	'click-down and drag to move this field' => 'gardez le clic maintenu et glissez le curseur pour déplacer ce champs',
	'click to %toggle% this box' => 'cliquez pour %toggle% cette boîte',
	'use the arrow keys to move this box' => 'utilisez les touches flêchées de votre clavier pour déplacer cette boîte',
	', or press the enter key to %toggle% it' => ', ou pressez la touche entrée pour la %toggle%',

## addons/Commercial.pack/tmpl/list_field.tmpl
	'New [_1] Field' => 'Nouveau champ [_1]',
	'Delete selected fields (x)' => 'Effacer les champs sélectionnés (x)',
	'No fields could be found.' => 'Aucun champ n\'a été trouvé.',
	'System-Wide' => 'sur tout le système',

## addons/Commercial.pack/tmpl/asset-chooser.tmpl
	'Choose [_1]' => 'Choisir [_1]',
	'Remove [_1]' => 'Supprimer [_1]',

## addons/Commercial.pack/config.yaml

## addons/Community.pack/lib/MT/App/Community.pm
	'No login form template defined' => 'Aucun formulaire d\'identification de défini',
	'Before you can sign in, you must authenticate your email address. <a href="[_1]">Click here</a> to resend the verification email.' => 'Avant de pouvoir vous identifier, vous devez confirmer votre adresse email. <a href="[_1]">Cliquez ici</a> pour envoyer à nouveau l\'email de vérification.',
	'Your confirmation have expired. Please register again.' => 'Votre confirmation a expiré. Merci de vous inscrire à nouveau.',
	'User \'[_1]\' (ID:[_2]) has been successfully registered.' => 'L\'utilisateur \'[_1]\' (ID:[_2]) a été enregistré avec succès.',
	'Thanks for the confirmation.  Please sign in.' => 'Merci pour la confirmation. Identifiez-vous.',
	'Login required' => 'Authentification obligatoire',
	'System template entry_response not found in blog: [_1]' => 'Gabarit système entry_response introuvable dans le blog: [_1]',
	'Posting a new entry failed.' => 'Echec de saisie d\'une nouvelle note.',
	'New entry \'[_1]\' added to the blog \'[_2]\'' => 'Nouvelle note \'[_1]\' ajoutée sur le blog \'[_2]\'',
	'Id or Username is required' => 'Id ou identifiant obligatoire',
	'Unknown user' => 'Utilisateur inconnu',
	'Cannot edit profile.' => 'Impossible de modifier le profil.',
	'Recent Entries from [_1]' => 'Notes récentes de [_1]',
	'Responses to Comments from [_1]' => 'Réponses aux commentaires de [_1]',

## addons/Community.pack/lib/MT/Community/Tags.pm
	'You used an \'[_1]\' tag outside of the block of MTIfEntryRecommended; perhaps you mistakenly placed it outside of an \'MTIfEntryRecommended\' container?' => 'Vous avez utilisé un tag \'[_1]\' en dehors d\'un bloc de MTIfEntryRecommended; Peut-être l\'avez-vous placé par erreur en dehors d\'un conteneur \'MTIfEntryRecommended\' ?',
	'Click here to recommend' => 'Cliquer ici pour recommander',

## addons/Community.pack/lib/MT/Community/CMS.pm
	'Welcome to the Movable Type Community Solution' => 'Bienvenue dans Movable Type Community Solution',
	'The Community Solution gives you to the tools to build a successful community with active, engaged conversations. Some key features to explore:' => 'Le Community Solution vous offre les outils pour construire avec succès une communauté active avec des conversations engagées. Certaines fonctionnalités principales à explorer:',
	'Member Profiles' => 'Profils des membres',
	'Allow registered members of your community to create and customize profiles, including user pictures' => 'Permettez aux membres enregistrés de votre communauté de créer et personnaliser leur profil, avec leur photo',
	'Favoriting, Recommendations and User Voting' => 'Favoris, recommandations et votes',
	'Your community can vote for its favorite content, making it easy for your readers and authors to see what\'s most popular' => 'Votre communauté peut voter pour son contenu favori, ainsi vos lecteurs et auteurs peuvent voir facilement ce qui est populaire',
	'User-Contributed Content' => 'Contenu généré par les utilisateurs',
	'Registered users can submit content to your site, and administrators have full control over what gets published' => 'Les utilisateurs enregistrés peuvent soumettre du contenu dans votre site, et les administrateurs ont un contrôle complet sur ce qui sera publié',
	'Forums and Community Blogs' => 'Forums et blogs communautaires',
	'Add forums and group blogs to your site with just a few clicks' => 'Ajoutez des forums et des blogs collectifs à votre site avec quelques clics.',
	'Completely Customizable Design' => 'Design complétement personnalisable',
	'Every element of your site experience is customizable, including login screens, registration forms, profile editing, and even email messages' => 'Chaque élément de votre site est personnalisable, ce qui inclut les écrans d\'identification, les formulaires d\'inscription, la modification des profils, et même les corps des emails',

## addons/Community.pack/php/function.mtentryrecommendvotelink.php

## addons/Community.pack/tmpl/widget/blog_stats_registration.mtml
	'Registrations' => 'Inscriptions',
	'Recent Registrations' => 'Inscriptions récentes',
	'default userpic' => 'Image de l\'utilisateur par défaut',
	'You have [quant,_1,registration,registrations] from [_2]' => 'Vous avez [quant,_1,inscription,inscriptions] depuis [_2]',

## addons/Community.pack/tmpl/widget/most_popular_entries.mtml
	'Most Popular Entries' => 'Notes les plus populaires',
	'There are no popular entries.' => 'Il n\'y a pas de notes populaires.',

## addons/Community.pack/tmpl/widget/recent_submissions.mtml
	'Recent Submissions' => 'Soumissions récentes',

## addons/Community.pack/tmpl/widget/recent_favorites.mtml
	'Recent Favorites' => 'Favoris récents',
	'There are no recently favorited entries.' => 'Il n\'y a pas de notes favorites récentes.',

## addons/Community.pack/tmpl/cfg_community_prefs.tmpl
	'Community Settings' => 'Réglages de la communauté',
	'Anonymous Recommendation' => 'Recommandation anonyme',
	'Check to allow anonymous users (users not logged in) to recommend discussion.  IP address is recorded and used to identify each user.' => 'Cocher pour autoriser les utilisateurs anonymes (non identifiés) à recommander une discussion. L\'adresse IP est enregistrée et utilisée pour identifier chaque utilisateur.',
	'Allow anonymous user to recommend' => 'Autoriser un utilisateur anonyme à recommander',
	'Save changes to blog (s)' => 'Enregistrer les modifications du blog (s)',

## addons/Community.pack/templates/global/register_form.mtml
	'Sign up' => 'Enregistrez-vous',
	'Simple Header' => 'Tête de page simple',

## addons/Community.pack/templates/global/simple_footer.mtml

## addons/Community.pack/templates/global/profile_error.mtml
	'Profile Error' => 'Erreur de profil',
	'Status Message' => 'Message de statut',

## addons/Community.pack/templates/global/profile_feed_rss.mtml

## addons/Community.pack/templates/global/userpic.mtml

## addons/Community.pack/templates/global/new_entry_email.mtml
	'A new entry \'[_1]([_2])\' has been posted on your blog [_3].' => 'Une nouvelle note \'[_1]([_2])\' a été postée sur votre blog [_3].',
	'Author name: [_1]' => 'Nom de l\'auteur: [_1]',
	'Author nickname: [_1]' => 'Surnom de l\'auteur: [_1]',
	'Title: [_1]' => 'Titre: [_1]',
	'Edit entry:' => 'Modifier la note:',

## addons/Community.pack/templates/global/password_reset_form.mtml
	'Reset Password' => 'Initialiser le mot de passe',
	'Back to the original page' => 'Retour à la page initiale',
	'Simple Footer' => 'Pied de page simple',

## addons/Community.pack/templates/global/profile_edit_form.mtml
	'Go <a href="[_1]">back to the previous page</a> or <a href="[_2]">view your profile</a>.' => 'Retourner à  <a href="[_1]">la page précédente</a> ou <a href="[_2]">voir votre profil</a>.',
	'Form Field' => 'Champ de formulaire',
	'User Name' => 'Identifiant',
	'Upload New Userpic' => 'Charger une nouvelle photo utilisateur',

## addons/Community.pack/templates/global/header.mtml
	'Blog Description' => 'Description du blog',
	'GlobalJavaScript' => 'GlobalJavaScript',
	'Navigation' => 'Navigation',
	'User Navigation' => 'Navigation utilisateur',

## addons/Community.pack/templates/global/profile_view.mtml
	'User Profile' => 'Profil de l\'utilisateur',
	'Website:' => 'Site Web:',
	'Recent Comments' => 'Commentaires récents',
	'Responses to Comments' => 'Réponses aux commentaires',
	'Favorites' => 'Favoris',
	'No recent entries.' => 'Pas de notes récentes.',
	'Recents Comments from [_1]' => 'Commentaires récents de [_1]',
	'(posted to [_1])' => '(posté sur [_1])',
	'No recent comments.' => 'Pas de commentaires récents.',
	'No responses to comments.' => 'Pas de réponse aux commentaires.',
	'Favorites of [_1]' => 'Favoris de [_1]',
	'[_1] has not added any favorites yet.' => '[_1] n\'a pas encore ajouté de favoris.',

## addons/Community.pack/templates/global/login_form.mtml

## addons/Community.pack/templates/global/register_confirmation.mtml
	'Authentication Email Sent' => 'Email d\'authentification envoyé',
	'Profile Created' => 'Profil créé',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Retourner à la page initiale</a>',

## addons/Community.pack/templates/global/user_navigation.mtml
	'Logged in as <a href="[_1]">[_2]</a>' => 'Identifié comme <a href="[_1]">[_2]</a>',
	'Sign out' => 'déconnexion',
	'Not a member? <a href="[_1]">Register</a>' => 'Pas encore membre? <a href="[_1]">Enregistrez-vous</a>',

## addons/Community.pack/templates/global/footer.mtml

## addons/Community.pack/templates/global/navigation.mtml
	'Home' => 'Accueil',

## addons/Community.pack/templates/global/login_form_module.mtml
	'Hello [_1]' => 'Bonjour [_1]',
	'Forgot Password' => 'Mot de passe oublié?',

## addons/Community.pack/templates/global/email_verification_email.mtml
	'Thank you registering for an account to [_1].' => 'Merci de créer un compte sur [_1].',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to sign in to [_1].' => 'Pour votre propre sécurité et pour prévenir la fraude, nous vous demandons de confirmer votre compte et adresse email avant de continuer. Une fois confirmés vous serez immédiatement autorisé à vous identifier sur [_1].',
	'If you did not make this request, or you don\'t want to register for an account to [_1], then no further action is required.' => 'Si vous n\'avez pas fait cette demande, ou que vous ne souhaitez pas créer un compte sur [_1], alors aucune action n\'est nécessaire.',

## addons/Community.pack/templates/global/register_notification_email.mtml

## addons/Community.pack/templates/global/search.mtml

## addons/Community.pack/templates/blog/rss.mtml

## addons/Community.pack/templates/blog/archive_index.mtml
	'Content Navigation' => 'Navigation du contenu',

## addons/Community.pack/templates/blog/trackbacks.mtml

## addons/Community.pack/templates/blog/main_index.mtml

## addons/Community.pack/templates/blog/page.mtml

## addons/Community.pack/templates/blog/content_nav.mtml
	'Blog Home' => 'Accueil du blog',

## addons/Community.pack/templates/blog/entry_summary.mtml
	'A favorite' => 'Un favori',
	'Favorite' => 'Favori',

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

## addons/Community.pack/templates/blog/entry_form.mtml
	'You don\'t have permission to post.' => 'Vous n\'avez pas la permission de poster.',
	'<a href="[_1]">Sign in</a> to create an entry.' => '<a href="[_1]">Identifiez-vous</a> pour créer une note.',
	'Select Category...' => 'Sélectionner la catégorie...',

## addons/Community.pack/templates/blog/entry_create.mtml
	'Entry Form' => 'Formulaire de note',

## addons/Community.pack/templates/blog/comment_detail.mtml

## addons/Community.pack/templates/blog/comments.mtml

## addons/Community.pack/templates/blog/comment_form.mtml

## addons/Community.pack/templates/blog/categories.mtml

## addons/Community.pack/templates/blog/search_results.mtml

## addons/Community.pack/templates/blog/sidebar_2col.mtml
	'Subscribe icon' => 'Icône d\'abonnement',
	'Subscribe' => 'Abonnement',

## addons/Community.pack/templates/blog/sidebar_3col.mtml

## addons/Community.pack/templates/blog/entry_listing.mtml

## addons/Community.pack/templates/blog/dynamic_error.mtml

## addons/Community.pack/templates/blog/tags.mtml

## addons/Community.pack/templates/blog/entry_metadata.mtml

## addons/Community.pack/templates/blog/entry.mtml

## addons/Community.pack/templates/blog/comment_preview.mtml

## addons/Community.pack/templates/blog/javascript.mtml

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
	'Your reply has been accepted' => 'Votre réponse a été acceptée',
	'Thank you for your reply. It has been accepted and should appear momentarily.' => 'Merci pour votre réponse. Elle a été acceptée et devrait apparaître dans un instant.',
	'Reply Pending' => 'Réponse en attente',
	'Your reply has been received' => 'Votre réponse a été reçue',
	'Thank you for your reply. However, your reply is currently being held for approval by the forum\'s administrator.' => 'Merci pour votre réponse. Cependant, votre réponse est actuellement en attente de validation par l\'administrateur du forum.',
	'Reply Submission Error' => 'Erreur lors de l\'envoi de la réponse',
	'Your reply submission failed for the following reasons:' => 'L\'envoi de votre réponse a échoué pour les raisons suivantes:',
	'Return to the <a href="[_1]">original topic</a>.' => 'Retour au <a href="[_1]">sujet d\'origine</a>.',

## addons/Community.pack/templates/forum/content_header.mtml

## addons/Community.pack/templates/forum/entry_detail.mtml

## addons/Community.pack/templates/forum/entry_form.mtml
	'<a href="[_1]">Sign in</a> to create a topic.' => '<a href="[_1]">Identifiez-vous</a> pour créer un sujet.',
	'Topic' => 'Sujet',
	'Select Forum...' => 'Sélectionner un forum...',
	'Forum' => 'Forum',

## addons/Community.pack/templates/forum/comment_detail.mtml

## addons/Community.pack/templates/forum/entry_create.mtml
	'Start a Topic' => 'Créer un nouveau sujet',

## addons/Community.pack/templates/forum/comment_form.mtml

## addons/Community.pack/templates/forum/entry_listing.mtml

## addons/Community.pack/templates/forum/entry_metadata.mtml
	'Replies ([_1])' => 'Réponses ([_1])',

## addons/Community.pack/templates/forum/entry.mtml

## addons/Community.pack/templates/forum/javascript.mtml
	'. Now you can reply to this topic.' => '. Maintenant vous pouvez répondre à ce sujet.',
	' to comment on this topic.' => ' pour commenter sur ce sujet.',
	' to comment on this topic,' => ' pour commenter sur ce sujet,',

## addons/Community.pack/templates/forum/rss.mtml

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
	'All Forums' => 'Tous les forums',
	'[_1] Forum' => '[_1] forum',

## addons/Community.pack/templates/forum/category_groups.mtml
	'Forum Groups' => 'Groupes de forums',
	'Last Topic: [_1] by [_2] on [_3]' => 'Dernier sujet: [_1] par [_2] sur [_3]',

## addons/Community.pack/templates/forum/comments.mtml
	'[_1] Replies' => '[_1] réponses',
	'_NUM_FAVORITES' => 'Marquer comme favori',
	'Favorite This' => 'Marquer comme favori',

## addons/Community.pack/templates/forum/search_results.mtml

## addons/Community.pack/templates/forum/dynamic_error.mtml

## addons/Community.pack/templates/forum/entry_popular.mtml
	'Popular topics' => 'Sujets populaires',
	'No Reply' => 'Aucune réponse',

## addons/Community.pack/templates/forum/comment_preview.mtml
	'Reply on [_1]' => 'Réponse sur [_1]',
	'Previewing your Reply' => 'Prévisualiser votre réponse',

## addons/Community.pack/config.yaml
	'Login Form' => 'Formulaire d\'identification',
	'Password Reset Form' => 'Formulaire de réinitialisation du mot de passe',
	'Registration Form' => 'Formulaire d\'enregistrement',
	'Registration Confirmation' => 'Confirmation d\'enregistrement',
	'Profile View' => 'Vue du profil',
	'Profile Edit Form' => 'Formulaire de modification du profil',
	'Profile Feed (Atom)' => 'Flux de profil (Atom)',
	'Profile Feed (RSS)' => 'Flux de profil (RSS)',
	'Email verification' => 'Vérification email',
	'Registration notification' => 'Notification enregistrement',
	'New entry notification' => 'Notification de nouvelle note',
	'Community Blog' => 'Blog de la communauté',
	'Entry Response' => 'Réponse à la note',
	'Displays error, pending or confirmation message when submitting an entry.' => 'Afficher les erreurs et les messages de confirmation quand une note est écrite.',
	'Community Forum' => 'Forum de la communauté',
	'Entry Feed (Atom)' => 'Flux de note (Atom)',
	'Entry Feed (RSS)' => 'Flux de note (RSS)',
	'Displays error, pending or confirmation message when submitting a entry.' => 'Affiche les messages d\'erreur, de validation et de confirmation quand une nouvelle note est créée.',

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
	'Users & Groups' => 'Utilisateurs et Groupes',
	'Group Members' => 'Membres du groupe',
	'Groups' => 'Groupes',
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
	"Failed login attempt by user \'[_1]\'. A user with that\nusername already exists in the system with a different UUID." => "Tentative de login échouée par utilisateur \'[_1]\'. Un utilisateur avec cet
identifiant existe déjà dans le système avec un UUID différent.",
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
	"Filter used to search for groups: [_1]\nSearch base: [_2]" => "Filtre utilisé pour rechercher les groupes: [_1]
Base de recherche: [_2]",
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

## addons/Enterprise.pack/tmpl/include/group_table.tmpl
	'group' => 'groupe',
	'groups' => 'Groupes',
	'Enable selected group (e)' => 'Activer les groupes sélectionnés (e)',
	'Disable selected group (d)' => 'Désactiver les groupes sélectionnés (d)',
	'Remove selected group (d)' => 'Retirer les groupes sélectionnés (d)',
	'Only show enabled groups' => 'Afficher uniquement les groupes activés',
	'Only show disabled groups' => 'Afficher uniquement les groupes désactivés',

## addons/Enterprise.pack/tmpl/list_group.tmpl
	'[_1]: User&rsquo;s Groups' => '[_1]: Groupes de l\'utilisateur',
	'Groups: System Wide' => 'Groupes: Sur tout le système',
	'The user <em>[_1]</em> is currently disabled.' => 'L\'utilisateur <em>[_1]</em> est actuellement désactivé',
	'Synchronize groups now' => 'Synchroniser les groupes maintenant',
	'You have successfully disabled the selected group(s).' => 'Vous avez désactivé les groupes sélectionnés avec succès.',
	'You have successfully enabled the selected group(s).' => 'Vous avez activé les groupes sélectionnés avec succès.',
	'You have successfully deleted the groups from the Movable Type system.' => 'Vous avez supprimé les groupes du système Movable Type avec succès.',
	'You have successfully synchronized groups\' information with the external directory.' => 'Vous avez synchronisé avec succès les informations des groupes avec le répertoire externe.',
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
	'Group Disabled' => 'Groupe désactivé',
	'You have successfully deleted the users.' => 'Vous avez supprimé les utilisateurs avec succès.',
	'You have successfully added new users to this group.' => 'Vous avez ajouté les nouveaux utilisateurs dans ce groupe avec succès.',
	'You have successfully synchronized users\' information with external directory.' => 'Vous avez synchronisé avec succès les informations des utilisateurs avec l\'annuaire externe.',
	'Some ([_1]) of the selected users could not be re-enabled because they were no longer found in LDAP.' => 'Certains ([_1]) utilisateurs sélectionnés n\'ont pu être réactivés car ils ne sont plus dans LDAP.',
	'You have successfully removed the users from this group.' => 'Vous avez retirés avec succès les utilisateurs de ce groupe.',
	'member' => 'membre',
	'Show Enabled Members' => 'Afficher les membres actifs',
	'Show Disabled Members' => 'Afficher les membres désactivés',
	'Show All Members' => 'Afficher tous les membres',
	'You can not add users to a disabled group.' => 'Vous ne pouvez pas ajouter des utilisateurs à un groupe désactivé.',
	'Add user to [_1]' => 'Ajouter utilisateur à [_1]',
	'None.' => 'Aucun.',
	'(Showing all users.)' => '(Afficher tous les utilisateurs.)',
	'Showing only users whose [_1] is [_2].' => 'Afficher seulement les utilisateurs dont [_1] est [_2].',
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
	'Updating...' => 'Mise à jour...',

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
	'Save changes to this field (s)' => 'Enregistrer les modifications de ce champs (s)',

## addons/Enterprise.pack/app-wizard.yaml
	'This module is required in order to use the LDAP Authentication.' => 'Ce module est nécessaire pour utiliser l\'identification LDAP.',
	'This module is required in order to use SSL/TLS connection with the LDAP Authentication.' => 'Ce module est nécessaire pour utiliser les connections SSL/TLS avec l\'identification LDAP.',

## addons/Enterprise.pack/app-cms.yaml
	'Are you sure you want to delete the selected group(s)?' => 'Etes-vous sûr de vouloir effacer les groupes sélectionnés?',
	'Bulk Author Export' => 'Export auteurs en masse',
	'Synchronize Users' => 'Synchroniser les utilisateurs',

## addons/Enterprise.pack/config.yaml
	'Enterprise Pack' => 'Enterprise Pack',
	'Oracle Database' => 'Base de données Oracle',
	'Microsoft SQL Server Database' => 'Base de données Microsoft SQL Server',
	'Microsoft SQL Server Database (UTF-8 support)' => 'Base de données Microsoft SQL Server (support UTF-8)',
	'External Directory Synchronization' => 'Synchronization répertoire externe',
	'Populating author\'s external ID to have lower case user name...' => 'Création de l\'ID externe de l\'auteur pour avoir un identifiant en minuscules...',

## plugins/Cloner/cloner.pl
	'Clones a blog and all of its contents.' => 'Dupliquer un blog et tout son contenu',
	'Cloning blog \'[_1]\'...' => 'Duplication du blog...',
	'Finished! You can <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">return to the blog listing</a> or <a href="javascript:void(0);" onclick="closeDialog(\'[_2]\');">configure the Site root and URL of the new blog</a>.' => 'Terminé ! Vous pouvez <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">retourner à la liste des blogs</a> ou <a href="javascript:void(0);" onclick="closeDialog(\'[_2]\');">configurer la racine du site et l\'URL du nouveau blog</a>.',
	'No blog was selected to clone.' => 'Aucun blog n\'a été sélectionné pour la duplication',
	'This action can only be run for a single blog at a time.' => 'Cette action ne peut être exécutée que pour un blog à la fois',
	'Invalid blog_id' => 'Identifiant du blog non valide',
	'Clone Blog' => 'Dupliquer le blog',

## plugins/Markdown/SmartyPants.pl
	'Easily translates plain punctuation characters into \'smart\' typographic punctuation.' => 'Permet de convertir facilement des caractères de ponctuation basiques vers une ponctuation plus complexe (comme les guillemets, tirets, etc...)',
	'Markdown With SmartyPants' => 'Markdown avec SmartyPants',

## plugins/Markdown/Markdown.pl
	'A plain-text-to-HTML formatting plugin.' => 'Un plugin de formatage plain-text vers HTML',
	'Markdown' => 'Markdown',

## plugins/WXRImporter/lib/WXRImporter/Import.pm

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'Le fichier n\'est pas dans le format WXR.',
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

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'Le répertoire mt-static n\'a pas pu être trouvé. Veuillez configurer le \'StaticFilePath\' pour continuer.',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Impossible de créer le dossier [_1] - Vérifiez que votre dossier \'themes\' et en mode webserveur/écriture.',
	'Error downloading image: [_1]' => 'Erreur en téléchargeant l\'image : [_1]',
	'Successfully applied new theme selection.' => 'Sélection de nouveau Thème appliquée avec succès.',
	'Invalid URL: [_1]' => 'URL inaccessible : [_1]',

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a Style' => 'Habillages',
	'3-Columns, Wide, Thin, Thin' => '3-colonnes, large, fin, fin',
	'3-Columns, Thin, Wide, Thin' => '3-colonnes, fin, large, fin',
	'2-Columns, Thin, Wide' => '2-colonnes, fin, large',
	'2-Columns, Wide, Thin' => '2-colonnes, large, fin',
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

## plugins/StyleCatcher/stylecatcher.pl
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.' => 'StyleCatcher vous permet de naviguer facilement à travers des styles et de les appliquer à votre blog en quelques clics seulement. Pour en savoir plus à propos des styles Movable Type, ou pour avoir de nouvelles sources de styles, visitez la page <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a>.',
	'MT 4 Style Library' => 'Bibliothèque MT4',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Une gamme de styles compatibles avec les gabarits MT4 par défaut',
	'MT 3 Style Library' => 'Bibliothèque MT3',
	'A collection of styles compatible with Movable Type 3.3+ default templates.' => 'Une gamme de styles compatibles avec les gabarits MT3.3+ par défaut',
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
	'To prevent lookups for some IP addresses or domains, list them below. Place each entry on a line by itself.' => 'Pour éviter les vérifications pour certaines adresses IP ou certains domaines, listez-les ci-dessous. Placez chaque entrée sur une seule ligne.',

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
	'SpamLookup - Link' => 'SpamLookup - Lien',
	'SpamLookup module for junking and moderating feedback based on link filters.' => 'SpamLookup module pour marquer comme spam et modérer les messages basé sur les filtres de liens.',
	'SpamLookup Link Filter' => 'SpamLookup filtre de lien',
	'SpamLookup Link Memory' => 'SpamLookup mémorisation des liens',
	'SpamLookup Email Memory' => 'SpamLookup mémorisation des emails',

## plugins/MultiBlog/lib/MultiBlog/Tags.pm
	'MTMultiBlog tags cannot be nested.' => 'Les balises MTMultiBlog ne peuvent pas être imbriquées.',
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Valeur de l\'attribut "mode" inconnue : [_1]. Les valeurs valides sont "loop" et "context".',

## plugins/MultiBlog/lib/MultiBlog.pm
	'The include_blogs, exclude_blogs, blog_ids and blog_id attributes cannot be used together.' => 'Les attributs include_blogs, exclude_blogs, blog_ids et blog_id ne peuvent pas être utilisés ensemble.',
	'The attribute exclude_blogs cannot take "all" for a value.' => 'L\'attribut exclude_blogs ne peut pas prendre "all" pour valeur.',
	'The value of the blog_id attribute must be a single blog ID.' => 'La valeur de l\'attribut blog_id doit être un ID de blog unique.',
	'The value for the include_blogs/exclude_blogs attributes must be one or more blog IDs, separated by commas.' => 'La valeur des attributs include_blogs/exclude_blogs doit être un ou plusieurs IDs de blogs, séparés par des virgules.',

## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
	'Create MultiBlog Trigger' => 'Créer un événement MultiBlog',

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'When' => 'Quand',
	'Any Weblog' => 'Tous les blogs',
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
	'Weblog Name' => 'Nom du blog',
	'Search Weblogs' => 'Rechercher les blogs',
	'When this' => 'quand ce',
	'* All Weblogs' => '* Tous les blogs',
	'Select to apply this trigger to all weblogs' => 'Sélectionner pour appliquer cet événement à tous les blogs',
	'saves an entry' => 'sauvegarde une note',
	'publishes an entry' => 'publie une note',
	'publishes a comment' => 'publie un commentaire',
	'publishes a TrackBack' => 'publie un trackback',
	'rebuild indexes.' => 'reconstruire les index.',
	'rebuild indexes and send pings.' => 'reconstruire les index et envoyer les pings.',

## plugins/Textile/textile2.pl
	'A humane web text generator.' => 'Générateur de texte user-friendly',
	'Textile 2' => 'Textile 2',

## plugins/WidgetManager/lib/WidgetManager/Plugin.pm
	'Can\'t find included template widget \'[_1]\'' => 'Impossible de trouver le gabarit de widget inclus \'[_1]\'',
	'Cloning Widgets for blog...' => 'Cloner les widgets pour le blog...',

## plugins/WidgetManager/lib/WidgetManager/CMS.pm
	'Can\'t duplicate the existing \'[_1]\' Widget Manager. Please go back and enter a unique name.' => 'Impossible de dupliquer le gestionnaire de Widgets \'[_1]\' existant. Merci de revenir à la page précédente et de saisir un nom unique.',
	'Main Menu' => 'Menu principal',
	'Widget Manager' => 'Gestionnaire de Widget',
	'New Widget Set' => 'Nouveau groupe de widgets',

## plugins/WidgetManager/default_widgets/monthly_archive_dropdown.mtml
	'Select a Month...' => 'Sélectionnez un Mois...',

## plugins/WidgetManager/default_widgets/category_archive_list.mtml

## plugins/WidgetManager/default_widgets/calendar.mtml
	'Monthly calendar with links to daily posts' => 'Calendrier mensuel avec des liens vers les notes du jour',
	'Sun' => 'Dim',
	'Mon' => 'Lun',
	'Tue' => 'Mar',
	'Wed' => 'Mer',
	'Thu' => 'Jeu',
	'Fri' => 'Ven',
	'Sat' => 'Sam',

## plugins/WidgetManager/default_widgets/recent_entries.mtml

## plugins/WidgetManager/default_widgets/current_author_monthly_archive_list.mtml

## plugins/WidgetManager/default_widgets/date_based_author_archives.mtml
	'Author Yearly Archives' => 'Archives Annuelles par Auteurs',
	'Author Weekly Archives' => 'Archives Hebdomadaires par Auteurs',
	'Author Daily Archives' => 'Archives Quotidiennes par Auteurs',

## plugins/WidgetManager/default_widgets/main_index_meta_widget.mtml
	'This is a custom set of widgets that are conditioned to only appear on the homepage (or "main_index"). More info: [_1]' => 'Ceci est un groupe de wigets personnalisé qui est conditioné pour n\'apparaître que sur la page d\'accueil (ou "main_index"). Plus d\'infos : [_1]',

## plugins/WidgetManager/default_widgets/syndication.mtml
	'Search results matching &ldquo;<$mt:SearchString$>&rdquo;' => 'Résultats de la recherche pour la requête &ldquo;<$mt:SearchString$>&rdquo;',

## plugins/WidgetManager/default_widgets/current_category_monthly_archive_list.mtml

## plugins/WidgetManager/default_widgets/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] a commenté sur [_3]</a>: [_4]',

## plugins/WidgetManager/default_widgets/technorati_search.mtml
	'Technorati' => 'Technorati',
	'<a href=\'http://www.technorati.com/\'>Technorati</a> search' => 'Recherche <a href=\'http://www.technorati.com/\'>Technorati</a> ',
	'this blog' => 'ce blog',
	'all blogs' => 'tous les blogs',
	'Blogs that link here' => 'Blogs pointant ici',

## plugins/WidgetManager/default_widgets/monthly_archive_list.mtml

## plugins/WidgetManager/default_widgets/signin.mtml
	'You are signed in as ' => 'Vous êtes identifié en tant que ',
	'You do not have permission to sign in to this blog.' => 'Vous n\'avez pas l\'autorisation de vous identifier sur ce blog.',

## plugins/WidgetManager/default_widgets/pages_list.mtml

## plugins/WidgetManager/default_widgets/archive_meta_widget.mtml
	'This is a custom set of widgets that are conditioned to serve different content based upon what type of archive it is included. More info: [_1]' => 'Ceci est un groupe de widgets personnalisé qui est conditioné pour afficher un contenu différent basé sur le type d\'archives qui est inclu. Plus d\'infos : [_1]',

## plugins/WidgetManager/default_widgets/date_based_category_archives.mtml
	'Category Yearly Archives' => 'Archives Annuelles par Catégories',
	'Category Weekly Archives' => 'Archives Hebdomadaires par Catégories',
	'Category Daily Archives' => 'Archives Quotidiennes par Catégories',

## plugins/WidgetManager/default_widgets/widgets.cfg
	'About This Page' => 'À propos de cette page',
	'Current Author Monthly Archives' => 'Archives Mensuelles de l\'Auteur Courant',
	'Calendar' => 'Calendrier',
	'Category Archives' => 'Archives par Catégories',
	'Current Category Monthly Archives' => 'Archives Mensuelles de la Catégorie Courante',
	'Creative Commons' => 'Creative Commons',
	'Home Page Widgets' => 'Widgets de Page d\'Accueil',
	'Monthly Archives Dropdown' => 'Liste déroulante des Archives Mensuelles',
	'Recent Assets' => 'Éléments récents',
	'Powered By' => 'Animé Par',
	'Syndication' => 'Syndication',
	'Technorati Search' => 'Recherche Technorati',
	'Date-Based Author Archives' => 'Archives des Auteurs par Dates',
	'Date-Based Category Archives' => 'Archives des Catégories par Dates',

## plugins/WidgetManager/default_widgets/creative_commons.mtml
	'This weblog is licensed under a' => 'Ce blog est sujet à une licence',
	'Creative Commons License' => 'Creative Commons',

## plugins/WidgetManager/default_widgets/about_this_page.mtml

## plugins/WidgetManager/default_widgets/author_archive_list.mtml

## plugins/WidgetManager/default_widgets/powered_by.mtml

## plugins/WidgetManager/default_widgets/tag_cloud.mtml

## plugins/WidgetManager/default_widgets/recent_assets.mtml

## plugins/WidgetManager/default_widgets/search.mtml

## plugins/WidgetManager/tmpl/edit.tmpl
	'Edit Widget Set' => 'Modifier le groupe de widgets',
	'Please use a unique name for this widget set.' => 'Merci d\'utiliser un nom unique pour ce groupe de widgets.',
	'You already have a widget set named \'[_1].\' Please use a unique name for this widget set.' => 'Vous avez déjà un widget nommé \'[_1].\' Merci d\'utiliser un nom unique pour ce groupe de widgets.',
	'Your changes to the Widget Set have been saved.' => 'Les modifications apportées au groupe de widgets ont été enregistrées.',
	'Set Name' => 'Nom du groupe',
	'Drag and drop the widgets you want into the Installed column.' => 'Glissez-déposez les widgets que vous voulez dans la colonne de gauche.',
	'Installed Widgets' => 'Widgets installés',
	'edit' => 'Editer',
	'Available Widgets' => 'Widgets disponibles',
	'Save changes to this widget set (s)' => 'Enregistrer les modifications de ce groupe de widgets',

## plugins/WidgetManager/tmpl/list.tmpl
	'Widget Sets' => 'Groupes de widgets',
	'Widget Set' => 'Groupe de widgets',
	'Delete selected Widget Sets (x)' => 'Effacer les groupes de widgets sélectionnés (x)',
	'Helpful Tips' => 'Astuces',
	'To add a widget set to your templates, use the following syntax:' => 'Pour ajouter un groupe de widgets à vos gabarits, utilisez la syntaxe suivante :',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Nom du groupe de widgets&quot;$&gt;</strong>',
	'Edit Widget Templates' => 'Éditer les gabarits de widget',
	'Your changes to the widget set have been saved.' => 'Les modifications apportées au widget ont été enregistrées.',
	'You have successfully deleted the selected widget set(s) from your blog.' => 'Vous avez supprimé de votre blog les groupes de widgets sélectionnés.',
	'Create Widget Set' => 'Créer un groupe de widgets',
	'No Widget Sets could be found.' => 'Aucun groupe de widgets n\'a été trouvé',

## plugins/WidgetManager/WidgetManager.pl
	'Maintain your blog\'s widget content using a handy drag and drop interface.' => 'Organisez les widgets de votre blog via une interface de type glissez-déposez.',
	'Widgets' => 'Widgets',

);

## New words: 91

1;
