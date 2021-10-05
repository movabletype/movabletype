# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id:$

package MT::L10N::fr;
use strict;
use utf8;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

## The following is the translation table.

%Lexicon = (

## addons/Commercial.pack/config.yaml
	'A collection of styles compatible with Professional themes.' => 'Une collection de styles compatible avec des thèmes professionnels',
	'About This Page' => 'À propos de cette page',
	'Archive Widgets Group' => 'Archive du groupe des widgets',
	'Are you sure you want to delete the selected CustomFields?' => 'Voulez-vous vraiment supprimer les champs personnalisés séléctionnés ?',
	'Audio' => 'Audio',
	'Author Archives' => 'Archives par auteurs',
	'Basename' => 'Nom de base',
	'Blog Activity' => 'Activité du blog',
	'Blog Archives' => 'Archives du blog',
	'Blog Index' => 'Index du Blog',
	'Blogs' => 'Blogs',
	'Calendar' => 'Calendrier',
	'Categories' => 'Catégories',
	'Category Archives' => 'Archives par catégories',
	'Comment Detail' => 'Détail du commentaire',
	'Comment Form' => 'Formulaire de commentaire',
	'Comment Listing' => 'Liste des commentaires',
	'Comment Preview' => 'Prévisualisation du commentaire',
	'Comment Response' => 'Réponse au commentaire',
	'Comments' => 'Commentaires',
	'Contact' => 'Contact',
	'Converting CustomField type...' => 'Conversion du type CustomField...',
	'Creative Commons' => 'Creative Commons',
	'Current Category Monthly Archives' => 'Archives mensuelles de la catégorie courante',
	'Custom Fields' => 'Champs personnalisés',
	'Date-Based Author Archives' => 'Archives des auteurs par dates',
	'Date-Based Category Archives' => 'Archives des catégories par dates',
	'Delete' => 'Supprimer',
	'Description' => 'Description',
	'Dynamic Error' => 'Erreur dynamique',
	'Embed' => 'Embarqué',
	'Entry Detail' => 'Détails de la note',
	'Entry Listing' => 'Liste des notes',
	'Entry Metadata' => 'Metadonnées de la note',
	'Entry Summary' => 'Résumé de la note',
	'Entry' => 'Note',
	'Feed - Recent Entries' => 'Flux - Notes récentes',
	'Field' => 'Champ',
	'Footer Links' => 'Liens de Pied de Page',
	'Footer' => 'Pied',
	'Header' => 'Entête',
	'JavaScript' => 'JavaScript',
	'Link' => 'Lien',
	'Main Index' => 'Index principal',
	'Main Sidebar' => 'Colonne latérale principale',
	'Manage' => 'Gérer',
	'Migrating CustomFields type...' => 'Migration du type de Champ Personnalisé en cours',
	'Monthly Archives Dropdown' => 'Liste déroulante des archives mensuelles',
	'Monthly Archives' => 'Archives mensuelles',
	'Name' => 'Nom',
	'New' => 'Créer',
	'No Name' => 'Pas de nom',
	'Not Required' => 'Non requis',
	'OpenID Accepted' => 'OpenID accepté',
	'Page Detail' => 'Détails de la page',
	'Page Listing' => 'Liste des pages',
	'Page' => 'Page',
	'Photo' => 'Photo',
	'Popup Image' => 'Image dans une fenêtre surgissante',
	'Powered By (Footer)' => 'Powered By (Pied de Page)',
	'Professional Blog' => 'Blog professionel',
	'Professional Styles' => 'Styles professionnels',
	'Professional Website' => 'Sites web professionnels',
	'Professional designed, well structured and easily adaptable web site. You can customize default pages, footer and top navigation easily.' => 'Conçu pour les professionnels, bien structué et facilement adaptable, vous pouvez personnaliser les pages par défaut, le pied de page et la navigation facilement.',
	'RSD' => 'RSD',
	'Recent Assets' => 'Éléments récents',
	'Recent Comments' => 'Commentaires récents',
	'Recent Entries Expanded' => 'Entrées étendues récentes',
	'Recent Entries' => 'Notes récentes',
	'Required' => 'Requis',
	'Search Results' => 'Résultats de recherche',
	'Search' => 'Rechercher',
	'Sidebar' => 'Colonne latérale',
	'Sign In' => 'Connexion',
	'Stylesheet' => 'Feuille de style',
	'Syndication' => 'Syndication',
	'System Object' => 'Objet système',
	'Tag Cloud' => 'Nuage de tags',
	'Tag' => 'Tag',
	'Tags' => 'Tags',
	'Template tag' => 'Tag du gabarit',
	'TrackBacks' => 'TrackBacks',
	'Type' => 'Type',
	'Unknown Object' => 'Objet inconnu',
	'Unknown Type' => 'Type inconnu',
	'Updating Universal Template Set to Professional Website set...' => 'Mise à jour du jeu de gabarits universel vers sites web professionnels...',
	'Website/Blog Name' => 'Nom du site/blog',
	'Welcome to our new website!' => 'Bienvenue sur notre nouveau site !',
	'[_1] [_3] [_2]' => '[_1] [_3] [_2]',
	'__SELECT_FILTER_VERB' => 'est',
	'http://www.sixapart.com/movabletype/' => 'http://www.movabletype.com/',
	q{Archive Index} => q{Index d'archive},
	q{Create a blog as a part of structured website. This works best with Professional Website theme.} => q{Créer un blog en tant que partie d'un site web. Cela fonctionne mieux avec un thème de sites web profeesionnels.},
	q{Current Author Monthly Archives} => q{Archives mensuelles de l'auteur courant},
	q{Home Page Widgets Group} => q{Page d'accueil du groupe des widgets},
	q{_PWT_ABOUT_BODY} => q{
<p><strong>Remplacez par vos propres informations. </strong></p>
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In nec tellus sed turpis varius sagittis. Nullam pulvinar. Fusce dapibus neque pellentesque nulla. Maecenas condimentum quam. Vestibulum pretium fringilla quam. Nam elementum. Suspendisse odio magna, aliquam vitae, vulputate et, dignissim at, pede. Integer pellentesque orci at nibh. Morbi ante.</p>

<p>Maecenas convallis mattis justo. Ut mauris sapien, consequat a, bibendum vitae, sagittis ac, nisi. Nulla et sapien. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Ut condimentum turpis ut elit. Quisque ultricies sollicitudin justo. Duis vitae magna nec risus pulvinar ultricies.</p>
<!-- supprimez ce lien après l'édition -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl + '?__mode=view&_type=page&id=' + page_id + '&blog_id=' + blog_id; return false">Modifier ce contenu</a>
</p>
	},
	q{_PWT_CONTACT_BODY} => q{
<p><strong>Remplacez par vos propres informations.</strong></p>

<p>Contactez-nous. Envoyez un email à email (at) domainname.com</p>

<!-- remove this link after editing -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl + '?__mode=view&_type=page&id=' + page_id + '&blog_id=' + blog_id; return false">Modifier ce contenu</a>
</p>
	},
	q{_PWT_HOME_BODY} => q{
<p><strong>Remplacez par vos propres informations.</strong></p>
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In nec tellus sed turpis varius sagittis. Nullam pulvinar. Fusce dapibus neque pellentesque nulla. Maecenas condimentum quam. Aliquam erat volutpat. Ut placerat porta nibh. Donec vitae nulla. Pellentesque nisi leo, pretium a, gravida quis, sollicitudin non, eros. Vestibulum pretium fringilla quam. Nam elementum. Suspendisse odio magna, aliquam vitae, vulputate et, dignissim at, pede. Integer pellentesque orci at nibh. Morbi ante.</p>

<p>Maecenas convallis mattis justo. Ut mauris sapien, consequat a, bibendum vitae, sagittis ac, nisi. Nulla et sapien. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Ut condimentum turpis ut elit. Quisque ultricies sollicitudin justo. Duis vitae magna nec risus pulvinar ultricies. Aliquam sagittis volutpat metus.</p>

<p>Sed enim. Integer hendrerit, arcu ac pretium nonummy, velit turpis faucibus risus, pulvinar egestas enim elit sed ante. Curabitur orci diam, placerat a, faucibus id, condimentum vitae, magna. Etiam enim massa, convallis quis, rutrum vitae, porta quis, turpis.</p>
<!-- supprimez ce lien après l'édition -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl + '?__mode=view&_type=page&id=' + page_id + '&blog_id=' + blog_id; return false">Modifier ce contenu</a>
</p>
	},

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Checkbox' => 'Case à cocher',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'Personnalisez les champs des notes, pages, répertoires, catégories et auteurs pour stocker toutes les informations dont vous avez besoin.',
	'Date & Time' => 'Date & heure',
	'Date Only' => 'Date seulement',
	'Date and Time' => 'Date et heure',
	'Drop Down Menu' => 'Menu déroulant',
	'Edit Field' => 'Modifier le champ',
	'Embed Object' => 'Élément externe',
	'Exclude Custom Fields' => 'Exclure les champs personnalisés',
	'Invalid request.' => 'Demande invalide.',
	'Movable Type' => 'Movable Type',
	'Multi-Line Text' => 'Texte multi-lignes',
	'Permission denied.' => 'Permission refusée.',
	'Please ensure all required fields have been filled in.' => 'Merci de vérifier que tous les champs requis ont été renseignés.',
	'Please enter all allowable options for this field as a comma delimited list' => 'Merci de saisir toutes les options autorisées pour ce champ dans une liste délimitée par des virgules',
	'Please enter valid URL for the URL field: [_1]' => 'Merci de saisir une URL correcte pour le champ URL : [_1]',
	'Post Type' => 'Type de note',
	'Radio Buttons' => 'Boutons radio',
	'Saving permissions failed: [_1]' => 'La sauvegarde des autorisations a échoué : [_1]',
	'Show' => 'Afficher',
	'Single-Line Text' => 'Texte sur une ligne',
	'Time Only' => 'Heure seulement',
	'URL' => 'URL',
	'[_1] Fields' => 'Champs des [_1]',
	'blog and the system' => 'blog et le système',
	'blog' => 'blog',
	'type' => 'Type',
	'website and the system' => 'site web et le système',
	'website' => 'site web',
	q{Invalid date '[_1]'; dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Date invalide '[_1]'. Les dates doivent être dans le format YYYY-MM-DD HH:MM:SS.},
	q{Invalid date '[_1]'; dates should be real dates.} => q{Date invalide '[_1]'. Les dates doivent être de vraies dates.},
	q{Please enter some value for required '[_1]' field.} => q{Merci de saisir une valeur pour le champ requis '[_1]'.},
	q{The basename '[_1]' is already in use. It must be unique within this [_2].} => q{Le nom de base '[_1]' est déjà utilisé. Il doit être unique dans ce [_2]},
	q{The template tag '[_1]' is already in use.} => q{Le tag de gabarit '[_1]' est déjà utilisé.},
	q{The template tag '[_1]' is an invalid tag name.} => q{Le tag de gabarit '[_1]' est un nom de tag invalide},
	q{View image} => q{Voir l'image},
	q{You must select other type if object is the comment.} => q{Vous devez sélectionner d'autre types si l'objet est dans les commentaires.},
	q{[_1] '[_2]' (ID:[_3]) added by user '[_4]'} => q{[_1] '[_2]' (ID:[_3]) ajouté par utilisateur '[_4]'},
	q{[_1] '[_2]' (ID:[_3]) deleted by '[_4]'} => q{[_1] '[_2]' (ID:[_3]) supprimée par '[_4]'},

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Done.' => 'Terminé.',
	'Restoring custom fields data stored in MT::PluginData...' => 'Restauration des données des champs personnalisés stockées dans MT:PluginData...',
	'Restoring url of the assets associated in custom fields ( [_1] )...' => 'Restauration des URLs des éléments associés dans les champs personnalisés ([_1])...',
	q{Restoring asset associations found in custom fields ( [_1] ) ...} => q{Restauration des associations d'éléments trouvés dans les champs personnalisés ([_1])...},

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback.pm
	'Please enter valid option for the [_1] field: [_2]' => 'Veuillez saisir une option valide pour le champ [_1] : [_2]',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback/Field.pm
	'A parameter "[_1]" is required.' => 'Un paramètre "[_1]" est requis.',
	'The systemObject "[_1]" is invalid.' => 'Le paramètre systemObject "[_1]" est invalide.',
	'The type "[_1]" is invalid.' => 'Le type "[_1]" est invalide.',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Endpoint/v2/Field.pm
	'Invalid includeShared parameter provided: [_1]' => 'Le paramètre includeShared fourni est invalide : [_1]',
	'Removing [_1] failed: [_2]' => 'La suppression de [_1] a échoué : [_2]',
	q{Saving [_1] failed: [_2]} => q{L'enregistrement de [_1] a échoué : [_2]},

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'Fields' => 'Champs',
	'_CF_BASENAME' => 'Nom de base',
	'__CF_REQUIRED_VALUE__' => 'Valeur requise',
	q{The '[_1]' of the template tag '[_2]' that is already in use in [_3] is [_4].} => q{Le [_1] du tag de gabarit '[_2]' qui est déjà utilisé dans [_3] est [_3].},
	q{The template tag '[_1]' is already in use in [_2]} => q{Le tag de gabarit '[_1]' est déjà dans [_2]},
	q{The template tag '[_1]' is already in use in the system level} => q{Le tag de gabarit '[_1]' est déjà utilisé au niveau du système},
	q{The template tag '[_1]' is already in use in this blog} => q{Le tag de gabarit '[_1]' est déjà dans ce blog},

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	q{Are you sure you have used a '[_1]' tag in the correct context? We could not find the [_2]} => q{Etes-vous sûr d'avoir utilisé un tag '[_1]' dans le contexte approprié ? Impossible de trouver le [_2]},
	q{You used an '[_1]' tag outside of the context of the correct content; } => q{Vous avez utilisé un tag '[_1]' en dehors du contexte de contenu correct ; },

## addons/Commercial.pack/lib/CustomFields/Theme.pm
	'Conflict of [_1] "[_2]" with [_3]' => 'Conflit de [_1] "[_2]" avec [_3]',
	'Template Tag' => 'Tag de gabarit',
	'[_1] custom fields' => 'Champs personnalisés [_1]',
	'a field on system wide' => 'un champ sur tout le système',
	'a field on this blog' => 'un champ sur ce blog',

## addons/Commercial.pack/lib/CustomFields/Upgrade.pm
	'Removing unlinked CustomFields...' => 'Retrait des champs personnalisés sans lien en cours...',
	q{Moving metadata storage for pages...} => q{Déplacement de l'emplacement des métadonnées des pages en cours...},
	q{Removing CustomFields display-order from plugin data...} => q{Retrait de l'ordre d'affichage des champs personnalisés des données du plugin en cours...},

## addons/Commercial.pack/lib/CustomFields/Util.pm
	'Cloning fields for blog:' => 'Clonage des champs du blog :',
	'[_1] records processed.' => '[_1] enregistrements effectués.',
	'[_1] records processed...' => '[_1] enregistrements effectués...',

## addons/Commercial.pack/templates/professional/blog/about_this_page.mtml
	'<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> est la catégorie suivante.',
	'<a href="[_1]">[_2]</a> is the next entry in this blog.' => '<a href="[_1]">[_2]</a> est la note suivante de ce blog.',
	'<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> est la catégorie précédente.',
	'<a href="[_1]">[_2]</a> was the previous entry in this blog.' => '<a href="[_1]">[_2]</a> est la note précédente de ce blog.',
	'About Archives' => 'À propos des archives',
	'About this Archive' => 'À propos de cette archive',
	'About this Entry' => 'À propos de cette note',
	'This page contains a single entry by [_1] published on <em>[_2]</em>.' => 'Cette page contient une unique note de [_1] publiée le <em>[_2]</em>.',
	'This page contains links to all of the archived content.' => 'Cette page contient des liens vers tous les contenus archivés.',
	'This page is an archive of entries from <strong>[_2]</strong> listed from newest to oldest.' => 'Cette page est une archive des notes de <strong>[_2]</strong> listées de la plus récente à la plus ancienne.',
	'This page is an archive of entries in the <strong>[_1]</strong> category from <strong>[_2]</strong>.' => 'Cette page est une archive des notes dans la catégorie <strong>[_1]</strong> de <strong>[_2]</strong>.',
	'This page is an archive of recent entries in the <strong>[_1]</strong> category.' => 'Cette page est une archive des notes récentes dans la catégorie <strong>[_1]</strong>.',
	'This page is an archive of recent entries written by <strong>[_1]</strong> in <strong>[_2]</strong>.' => 'Cette page est une archive des notes récentes écrites par <strong>[_1]</strong> dans <strong>[_2]</strong>.',
	'This page is an archive of recent entries written by <strong>[_1]</strong>.' => 'Cette page est une archive des notes récentes écrites par <strong>[_1]</strong>.',
	q{<a href="[_1]">[_2]</a> is the next archive.} => q{<a href="[_1]">[_2]</a> est l'archive suivante.},
	q{<a href="[_1]">[_2]</a> is the previous archive.} => q{<a href="[_1]">[_2]</a> est l'archive précédente.},
	q{Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.} => q{Retrouvez le contenu récent sur <a href="[_1]">l'index principal</a> ou allez dans les <a href="[_2]">archives</a> pour retrouver tout le contenu.},
	q{Find recent content on the <a href="[_1]">main index</a>.} => q{Retrouvez le contenu récent sur <a href="[_1]">l'index principal</a>.},

## addons/Commercial.pack/templates/professional/blog/archive_index.mtml
	'Archives' => 'Archives',

## addons/Commercial.pack/templates/professional/blog/archive_widgets_group.mtml
	q{This is a custom set of widgets that serve different content depending on the type of archive in which it is included. More info: [_1]} => q{Ceci est un ensemble de widgets servant différents contenus en fonction de l'archive qui les contient. Pour plus d'information : [_1]},

## addons/Commercial.pack/templates/professional/blog/author_archive_list.mtml
	'Authors' => 'Auteurs',
	'[_1] ([_2])' => '[_1] ([_2])',

## addons/Commercial.pack/templates/professional/blog/calendar.mtml
	'Fri' => 'Ven',
	'Friday' => 'Vendredi',
	'Mon' => 'Lun',
	'Monday' => 'Lundi',
	'Monthly calendar with links to daily posts' => 'Calendrier mensuel avec des liens vers les notes du jour',
	'Sat' => 'Sam',
	'Saturday' => 'Samedi',
	'Sun' => 'Dim',
	'Sunday' => 'Dimanche',
	'Thu' => 'Jeu',
	'Thursday' => 'Jeudi',
	'Tue' => 'Mar',
	'Tuesday' => 'Mar',
	'Wed' => 'Mer',
	'Wednesday' => 'Mercredi',

## addons/Commercial.pack/templates/professional/blog/comment_detail.mtml
	'[_1] replied to <a href="[_2]">comment from [_3]</a>' => '[_1] en réponse au <a href="[_2]">commentaire de [_3]</a>',

## addons/Commercial.pack/templates/professional/blog/comment_form.mtml
	'(You may use HTML tags for style)' => '(vous pouvez utiliser des balises HTML pour le style)',
	'Cancel' => 'Annuler',
	'Email Address' => 'Adresse e-mail',
	'Leave a comment' => 'Laisser un commentaire',
	'Preview' => 'Aperçu',
	'Remember personal info?' => 'Mémoriser ces infos personnelles ?',
	'Replying to comment from [_1]' => 'En réponse au commentaire de [_1]',
	'Submit' => 'Envoyer',

## addons/Commercial.pack/templates/professional/blog/comment_preview.mtml
	'Previewing your Comment' => 'Aperçu de votre commentaire',

## addons/Commercial.pack/templates/professional/blog/comment_response.mtml
	'Back' => 'Retour',
	'Confirmation...' => 'Confirmation...',
	'Your comment has been received and held for review by a blog administrator.' => 'Votre commentaire a été reçu et est en attente de validation par un administrateur du blog.',
	'Your comment has been submitted!' => 'Votre commentaire a été envoyé !',
	q{Comment Submission Error} => q{Erreur d'envoi du commentaire},
	q{Return to the <a href="[_1]">original entry</a>.} => q{Retourner à la <a href="[_1]">note d'origine</a>.},
	q{Thank you for commenting.} => q{Merci d'avoir commenté.},
	q{Your comment submission failed for the following reasons: [_1]} => q{L'envoi de votre commentaire a échoué pour la raison suivante : [_1]},

## addons/Commercial.pack/templates/professional/blog/comments.mtml
	'# Comments' => '# commentaires',
	'1 Comment' => 'Un commentaire',
	'Next' => 'Suivant',
	'No Comments' => 'Aucun commentaire',
	'Previous' => 'Précédent',
	'The data is modified by the paginate script' => 'Les données sont modifiées par le script de pagination',

## addons/Commercial.pack/templates/professional/blog/creative_commons.mtml
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Ce blog est publié sous licence <a href="[_1]">Creative Commons</a>.',

## addons/Commercial.pack/templates/professional/blog/current_author_monthly_archive_list.mtml
	'[_1]: Monthly Archives' => '[_1] : Archives mensuelles',

## addons/Commercial.pack/templates/professional/blog/current_category_monthly_archive_list.mtml
	'[_1]' => '[_1]',

## addons/Commercial.pack/templates/professional/blog/date_based_author_archives.mtml
	'Author Daily Archives' => 'Archives quotidiennes par auteurs',
	'Author Monthly Archives' => 'Archives par auteurs et mois',
	'Author Weekly Archives' => 'Archives hebdomadaires par auteurs',
	'Author Yearly Archives' => 'Archives annuelles par auteurs',

## addons/Commercial.pack/templates/professional/blog/date_based_category_archives.mtml
	'Category Daily Archives' => 'Archives quotidiennes par catégories',
	'Category Monthly Archives' => 'Archives par catégories et mois',
	'Category Weekly Archives' => 'Archives hebdomadaires par catégories',
	'Category Yearly Archives' => 'Archives annuelles par catégories',

## addons/Commercial.pack/templates/professional/blog/dynamic_error.mtml
	'Page Not Found' => 'Page non trouvée',

## addons/Commercial.pack/templates/professional/blog/entry_listing.mtml
	'Recently by <em>[_1]</em>' => 'Récemment par <em>[_1]</em>',
	'Recently in <em>[_1]</em> Category' => 'Récemment dans la catégorie <em>[_1]</em>',
	'[_1] Archives' => 'Archives [_1]',

## addons/Commercial.pack/templates/professional/blog/entry_metadata.mtml
	'# TrackBacks' => '# TrackBacks',
	'1 TrackBack' => 'Un TrackBack',
	'By [_1] on [_2]' => 'Par [_1] le [_2]',

## addons/Commercial.pack/templates/professional/blog/entry_summary.mtml
	'Continue reading <a href="[_1]" rel="bookmark">[_2]</a>.' => 'Lire la suite de <a href="[_1]" rel="bookmark">[_2]</a>.',

## addons/Commercial.pack/templates/professional/blog/footer_links.mtml
	'Home' => 'Accueil',
	'Links' => 'Liens',

## addons/Commercial.pack/templates/professional/blog/javascript.mtml
	'Edit' => 'Éditer',
	'Replying to <a href="[_1]" onclick="[_2]">comment from [_3]</a>' => 'En réponse au <a href="[_1]" onclick="[_2]">commentaire de [_3]</a>',
	'Signing in...' => 'Identification...',
	'Thanks for signing in, __NAME__. ([_1]sign out[_2])' => 'Merci de vous être identifié(e) en tant que __NAME__. ([_1]Fermer la session[_2])',
	'Your session has expired. Please sign in again to comment.' => 'Votre session a expiré. Veuillez vous identifier à nouveau pour commenter.',
	'[_1]Sign in[_2] to comment, or comment anonymously.' => '[_1]Identifiez-vous[_2] pour commenter, ou laissez un commentaire anonyme.',
	'[_1]Sign in[_2] to comment.' => '[_1]Identifiez-vous[_2] pour commenter.',
	'[quant,_1,day,days] ago' => 'il y a [quant,_1,jour,jours]',
	'[quant,_1,hour,hours] ago' => 'il y a [quant,_1,heure,heures]',
	'[quant,_1,minute,minutes] ago' => 'il y a [quant,_1,minute,minutes]',
	'moments ago' => 'il y a quelques instants',
	q{The sign-in attempt was not successful; Please try again.} => q{La tentative d'enregistrement a échoué. Veuillez réessayer.},
	q{You do not have permission to comment on this blog. ([_1]sign out[_2])} => q{Vous n'avez pas la permission de commenter sur ce blog. ([_1]Déconnexion[_2])},

## addons/Commercial.pack/templates/professional/blog/main_index_widgets_group.mtml
	q{This is a custom set of widgets that only appear on the homepage (or "main_index"). More info: [_1]} => q{Ceci est un groupe de widgets personnalisés qui n'apparaissent que sur la page d'accueil (ou "main_index").},

## addons/Commercial.pack/templates/professional/blog/monthly_archive_dropdown.mtml
	'Select a Month...' => 'Sélectionnez un mois...',

## addons/Commercial.pack/templates/professional/blog/monthly_archive_list.mtml
	'[_1] <a href="[_2]">Archives</a>' => '<a href="[_2]">Archives</a> [_1]',

## addons/Commercial.pack/templates/professional/blog/openid.mtml
	'[_1] accepted here' => '[_1] est accepté',
	'http://www.sixapart.com/labs/openid/' => 'http://www.sixapart.com/labs/openid/',
	q{Learn more about OpenID} => q{Apprenez-en plus à propos d'OpenID},

## addons/Commercial.pack/templates/professional/blog/pages_list.mtml
	'Pages' => 'Pages',

## addons/Commercial.pack/templates/professional/blog/powered_by_footer.mtml
	'_POWERED_BY' => 'Motorisé par <a href="https://www.movabletype.org/"><$MTProductName$></a>',

## addons/Commercial.pack/templates/professional/blog/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] a commenté sur [_3]</a> : [_4]',

## addons/Commercial.pack/templates/professional/blog/search_results.mtml
	'By default, this search engine looks for all of the specified words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Par défaut, ce moteur va rechercher tous les mots dans le désordre. Pour chercher une expression exacte, placez-la entre apostrophes :',
	'Instructions' => 'Instructions',
	'No results found for &ldquo;[_1]&rdquo;.' => 'Aucun résultat pour &laquo; [_1] &raquo;.',
	'Results matching &ldquo;[_1]&rdquo;' => 'Résultats pour &laquo; [_1] &raquo;',
	'Results tagged &ldquo;[_1]&rdquo;' => 'Résultats tagués &laquo; [_1] &raquo;',
	'The search engine also supports the AND, OR, and NOT boolean operators:' => 'Le moteur de recherche comprend aussi les opérateurs booléens AND, OR et NOT :',
	'movable type' => 'movable type',
	'personal OR publishing' => 'personnelle OR publication',
	'publishing NOT personal' => 'publication NOT personnelle',

## addons/Commercial.pack/templates/professional/blog/signin.mtml
	'You are signed in as ' => 'Vous êtes identifié en tant que ',
	'sign out' => 'déconnexion',
	q{You do not have permission to sign in to this blog.} => q{Vous n'avez pas l'autorisation de vous identifier sur ce blog.},

## addons/Commercial.pack/templates/professional/blog/syndication.mtml
	'Feed of results matching &ldquo;[_1]&ldquo;' => 'Flux des résultats pour &ldquo; [_1] &ldquo;',
	'Feed of results tagged &ldquo;[_1]&ldquo;' => 'Flux des résultats tagués &ldquo; [_1] &ldquo;',
	q{Subscribe to a feed of all future entries matching &ldquo;[_1]&ldquo;} => q{S'abonner au flux de toutes les futurs notes contenant &ldquo; [_1] &ldquo;},
	q{Subscribe to a feed of all future entries tagged &ldquo;[_1]&ldquo;} => q{S'abonner au flux de toutes les futures notes taguées &laquo; [_1] &raquo;},
	q{Subscribe to feed} => q{S'abonner au flux},
	q{Subscribe to this blog's feed} => q{S'abonner au flux de ce blog},

## addons/Commercial.pack/templates/professional/blog/trackbacks.mtml
	'<a href="[_1]">[_2]</a> from [_3] on <a href="[_4]">[_5]</a>' => '<a href="[_1]">[_2]</a> depuis [_3] sur <a href="[_4]">[_5]</a>',
	'No TrackBacks' => 'Aucun TrackBack',
	'TrackBack URL: [_1]' => 'URL de TrackBack : [_1]',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">Lire la suite</a>',

## addons/Commercial.pack/templates/professional/website/blogs.mtml
	'Entries ([_1]) Comments ([_2])' => 'Notes ([_1]) Commentaires ([_2])',

## addons/Commercial.pack/templates/professional/website/comment_response.mtml
	q{Return to the <a href="[_1]">original page</a>.} => q{Retourner sur la <a href="[_1]">page d'origine</a>.},

## addons/Commercial.pack/templates/professional/website/recent_entries_expanded.mtml
	'By [_1] | Comments ([_2])' => 'Par [_1] | Commentaires ([_1])',
	'on [_1]' => 'sur [_1]',

## addons/Commercial.pack/templates/professional/website/search.mtml
	'Case sensitive' => 'Sensible à la casse',
	'Regex search' => 'Expression rationnelle',

## addons/Commercial.pack/templates/professional/website/search_results.mtml
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Par défaut, ce moteur va rechercher tous les mots dans le désordre. Pour chercher une expression exacte, placez-la entre apostrophes :',

## addons/Commercial.pack/templates/professional/website/syndication.mtml
	q{Subscribe to this website's feed} => q{Souscrire au flux du site web},

## addons/Commercial.pack/tmpl/asset-chooser.tmpl
	'Choose [_1]' => 'Choisir [_1]',
	'Remove [_1]' => 'Supprimer [_1]',
	'View' => 'Voir',

## addons/Commercial.pack/tmpl/category_fields.tmpl
	'Show These Fields' => 'Afficher ces champs',

## addons/Commercial.pack/tmpl/cfg_customfields.tmpl
	'Data have been saved to custom fields.' => 'Les données ont été enregistrées pour les champs personnalisés.',
	'Save Changes' => 'Enregistrer les modifications',
	'Save changes to blog (s)' => 'Sauvegarder les modifications du blog (s)',
	q{No custom fileds could be found. <a href="[_1]">Create a field</a> now.} => q{Aucun champ personnalisé n'a été trouvé. <a href="[_1]">Créer un champ</a> maintenant.},

## addons/Commercial.pack/tmpl/edit_field.tmpl
	'Create Custom Field' => 'Créer un champ personnalisé',
	'Default' => 'Défaut',
	'Delete this field (x)' => 'Supprimer ce champ (x)',
	'Edit Custom Field' => 'Éditer le champ personnalisé',
	'Example Template Code' => 'Code de gabarit exemple',
	'Options' => 'Options',
	'Required?' => 'Requis ?',
	'Save this field (s)' => 'Enregistrer ce champ (s)',
	'Save' => 'Enregistrer',
	'Select...' => 'Sélectionnez...',
	'Show In These [_1]' => 'Afficher dans ces [_1]',
	'The basename must be unique within this [_1].' => 'Le nom de base doit être unique dans ce [_1]',
	'The selected field(s) has been deleted from the database.' => 'Les champs sélectionnés ont été effacés de la base de données.',
	'You must enter information into the required fields highlighted below before the custom field can be created.' => 'Vous devez entrer des informations dans le champ requis indiqué avant que le champ personnalisé soit créé.',
	'Your changes have been saved.' => 'Les modifications ont été enregistrées.',
	'field' => 'champ',
	'fields' => 'Champs',
	q{Choose the system object where this custom field should appear.} => q{Sélectionnez l'objet système dans lequel le champ devra apparaître.},
	q{Is data entry required in this custom field?} => q{Est-ce qu'une donnée est requise dans ce champ personnalisé ?},
	q{Must the user enter data into this custom field before the object may be saved?} => q{L'utilisateur doit-il entrer quelque chose dans ce champ avant que l'objet puisse être enregistré ?},
	q{Warning: Changing this field's basename may require changes to existing templates.} => q{Attention : le changement de ce nom de base peut nécessiter des changements additionnels dans vos gabarits existants.},
	q{You must save this custom field before setting a default value.} => q{Vous devez sauvegarder ce champ personnalisé avant d'indiquer une valeur par défaut.},

## addons/Commercial.pack/tmpl/export_field.tmpl
	'Object' => 'Objet',

## addons/Commercial.pack/tmpl/reorder_fields.tmpl
	', or press the enter key to %toggle% it' => ', ou pressez la touche entrée pour la %toggle%',
	'click to %toggle% this box' => 'cliquez pour %toggle% cette boîte',
	'click-down and drag to move this field' => 'gardez le clic maintenu et glissez le curseur pour déplacer ce champ',
	'close' => 'fermer',
	'open' => 'ouvrir',
	'use the arrow keys to move this box' => 'utilisez les touches flêchées de votre clavier pour déplacer cette boîte',

## addons/Community.pack/config.yaml
	'A collection of styles compatible with Community themes.' => 'Une collection de styles compatibles avec les thèmes communauté',
	'Atom ' => 'Atom',
	'Category Groups' => 'Groupes de catégorie',
	'Community Blog' => 'Blog de la communauté',
	'Community Forum' => 'Forum de la communauté',
	'Community Styles' => 'Styles communautés',
	'Community' => 'Communauté',
	'Content Header' => 'Entête du contenu',
	'Content Navigation' => 'Navigation du contenu',
	'Create Entry' => 'Créer une nouvelle note',
	'Create forums where users can post topics and responses to topics.' => 'Créer des forums où les utilisateurs peuvent publier des sujets et des réponses aux sujets.',
	'Default Widgets' => 'Widgets par défaut',
	'Displays error, pending or confirmation message for comments.' => 'Affiche les erreurs et les messages de modération pour les commentaires.',
	'Displays error, pending or confirmation message when submitting an entry.' => 'Afficher les erreurs et les messages de confirmation quand une note est écrite.',
	'Displays errors for dynamically-published templates.' => 'Affiche les erreurs pour les gabarits publiés dynamiquement.',
	'Displays preview of comment.' => 'Affiche la prévisualisation du commentaire.',
	'Email verification' => 'Vérification email',
	'Entry Feed' => 'Flux de la note',
	'Entry Form' => 'Formulaire de note',
	'Entry Response' => 'Réponse à la note',
	'Entry Table' => 'Tableau de note',
	'Followed by' => 'Suivit par',
	'Followers' => 'Suiveurs',
	'Following' => 'Suit',
	'Form Field' => 'Champ de formulaire',
	'GlobalJavaScript' => 'GlobalJavaScript',
	'Improved listing of comments.' => 'Liste améliorée des commentaires',
	'Most Popular Entries' => 'Notes les plus populaires',
	'New Password Form' => 'Nouveau formulaire de mot de passe',
	'New Password Reset Form' => 'Nouveau formulaire de réinitialisation du mot de passe',
	'New entry notification' => 'Notification de nouvelle note',
	'Pending Entries' => 'Notes en attente',
	'Popular Entry' => 'Note populaire',
	'Powered By' => 'Motorisé par',
	'Profile Edit Form' => 'Formulaire de modification du profil',
	'Profile Feed' => 'Flux du profil',
	'Profile View' => 'Vue du profil',
	'Recent Submissions' => 'Soumissions récentes',
	'Recently Scored' => 'Noté récemment',
	'Registration notification' => 'Notification enregistrement',
	'Registrations' => 'Inscriptions',
	'Sanitize' => 'Nettoyer',
	'Simple Footer' => 'Pied de page simple',
	'Simple Header' => 'Tête de page simple',
	'Spam Entries' => 'Notes indésirables',
	'Status Message' => 'Message de statut',
	'Users followed by [_1]' => 'Utilisateurs suivis par [_1]',
	'Users following [_1]' => 'Utilisateurs qui suivent [_1]',
	q{Activity Widgets} => q{Widgets d'activité},
	q{Archive Widgets} => q{Widgets d'archive},
	q{Displays error, pending or confirmation message when submitting a entry.} => q{Affiche les messages d'erreur, de validation et de confirmation quand une nouvelle note est créée.},
	q{Displays image when user clicks a popup-linked image.} => q{Affiche l'image quand l'utilisateur clique sur une image pop-up.},
	q{Displays results of a search.} => q{Affiche les résultats d'une recherche.},
	q{Increase reader engagement - deploy features to your website that make it easier for your readers to engage with your content and your company.} => q{Accroître l'implication du lecteur - en ajoutant des fonctionnalités sur votre site web rendant facile pour vos lecteurs de s'impliquer sur le contenu et votre société.},
	q{Login Form} => q{Formulaire d'identification},
	q{Registration Confirmation} => q{Confirmation d'enregistrement},
	q{Registration Form} => q{Formulaire d'enregistrement},
	q{Userpic} => q{Image de l'utilisateur},

## addons/Community.pack/lib/MT/App/Community.pm
	'(Display Name not set)' => '(Nom pas spécifié)',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Retourner à la page initiale</a>',
	'Actions from [_1]' => 'Actions de [_1]',
	'All required fields must have valid values.' => 'Tous les champs requis doivent avoir des valeurs valides.',
	'Cannot load blog #[_1].' => 'Impossible de charger le blog #[_1].',
	'Comments from [_1]' => 'Commentaires de [_1]',
	'Display Name' => 'Nom affiché',
	'Failed to verify the current password.' => 'La vérification du mot de passe a échoué.',
	'For improved security, please change your password' => 'Pour plus de sécurité, veuillez changer votre mot de passe',
	'Invalid login' => 'Login invalide',
	'Invalid login.' => 'Identifiant invalide.',
	'Invalid parameter' => 'Paramètre invalide',
	'Invalid request' => 'Demande incorrecte',
	'Login required' => 'Authentification requise',
	'Movable Type Account Confirmation' => 'Confirmation de compte Movable Type',
	'Password contains invalid character.' => 'Le mot de passe contient des caractères invalides.',
	'Passwords do not match.' => 'Les mots de passe ne correspondent pas.',
	'Please select a video to upload.' => 'Merci de sélectionner une vidéo à télécharger.',
	'Please select an audio file to upload.' => 'Merci de sélectionner un fichier audio à télécharger.',
	'Please select an image to upload.' => 'Merci de sélectionner une image à télécharger.',
	'Publish failed: [_1]' => 'Échec de la publication : [_1]',
	'Recent Entries from [_1]' => 'Notes récentes de [_1]',
	'Responses to Comments from [_1]' => 'Réponses aux commentaires de [_1]',
	'Signing up is not allowed.' => 'Enregistrement non autorisée.',
	'System Email Address is not configured.' => 'Adresse e-mail du système non configurée.',
	'System template entry_response not found in blog: [_1]' => 'Gabarit système entry_response introuvable dans le blog: [_1]',
	'Thanks for the confirmation.  Please sign in.' => 'Merci pour la confirmation. Identifiez-vous.',
	'The login could not be confirmed because of a database error ([_1])' => 'Login invérifiable suite à une erreur de base de données ([_1])',
	'This account has been disabled. Please see your Movable Type system administrator for access.' => 'Ce compte a été désactivé. Veuillez contacter votre administrateur Movable Type pour obtenir un accès.',
	'Title or Content is required.' => 'Le titre ou le contenu est requis.',
	'Unknown user' => 'Utilisateur inconnu',
	'You are trying to redirect to external resources: [_1]' => 'Vous tentez une redirection vers des ressources externes: [_1]',
	'Your confirmation have expired. Please register again.' => 'Votre confirmation a expiré. Merci de vous inscrire à nouveau.',
	'[_1] contains an invalid character: [_2]' => '[_1] contient un caractère invalide : [_2]',
	q{'[_1]' is not allowed to upload by system settings.: [_2]} => q{'[_1]' n'est pas autorisé à télécharger par les paramètres système : [_2]},
	q{(No email address)} => q{(pas d'adresse e-mail)},
	q{Before you can sign in, you must authenticate your email address. <a href="[_1]">Click here</a> to resend the verification email.} => q{Avant de pouvoir vous identifier, vous devez confirmer votre adresse email. <a href="[_1]">Cliquez ici</a> pour envoyer à nouveau l'email de vérification.},
	q{Cannot load entry #[_1].} => q{Impossible de charger l'entrée #[_1].},
	q{Email Address is invalid.} => q{L'adresse e-mail est invalide.},
	q{Error assigning commenting rights to user '[_1] (ID: [_2])' for weblog '[_3] (ID: [_4])'. No suitable commenting role was found.} => q{Erreur en assignant les droits de commenter à l'utilisateur '[_1] (ID:[_2])' pour le blog '[_3] (ID:[_4])'. Aucun rôle de commentateur adéquat n'a été trouvé.},
	q{Error writing upload to '[_1]': [_2]} => q{Erreur d'écriture lors de l'envoi de '[_1]' : [_2]},
	q{Failed comment attempt by pending registrant '[_1]'} => q{Tentative de commentaire échoué par utilisateur  '[_1]' en cours d'inscription},
	q{Failed login attempt by disabled user '[_1]'} => q{Tentative de connexion par un utilisateur désactivé '[_1]'},
	q{Failed login attempt by pending user '[_1]'} => q{Tentative d'identification échoué par l'utilisateur en attente '[_1]'},
	q{Failed login attempt by unknown user '[_1]'} => q{Tentative de connexion par un utilisateur inconnu '[_1]'},
	q{Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.} => q{Tentative d'identification échoué pour le commentateur [_1] sur le blog [_2] (ID:[_3]) qui n'autorise pas l'authentification native de Movable Type.},
	q{Invalid filename '[_1]'} => q{Nom de fichier invalide '[_1]'},
	q{Login failed: password was wrong for user '[_1]'} => q{Identification échoué : mot de passe incorrect pour l'utilisateur '[_1]'},
	q{Login failed: permission denied for user '[_1]'} => q{Identification échoué : accès interdit pour l'utilisateur '[_1]'},
	q{New entry '[_1]' added to the blog '[_2]'} => q{Nouvelle note '[_1]' ajoutée sur le blog '[_2]'},
	q{No login form template defined} => q{Aucun formulaire d'identification de défini},
	q{Saving object failed: [_1]} => q{Échec de la sauvegarde de l'objet : [_1]},
	q{Successfully authenticated but signing up is not allowed.  Please contact system administrator.} => q{Identification réussie mais l'enregistrement n'est pas autorisé. Merci de contacter l'administrateur système.},
	q{URL is invalid.} => q{L'URL est invalide.},
	q{User '[_1]' (ID:[_2]) has been successfully registered.} => q{L'utilisateur '[_1]' (ID:[_2]) a été enregistré avec succès.},
	q{You need to sign up first.} => q{Vous devez vous enregistrer d'abord.},
	q{[_1] registered to Movable Type.} => q{[_1] s'est enregistré(e) à Movable Type.},
	q{[_1] registered to the blog '[_2]'} => q{[_1] est enregistré sur le blog '[_2]'},

## addons/Community.pack/lib/MT/Community/CMS.pm
	q{Cannot make path '[_1]': [_2]} => q{Impossible de créer le chemin '[_1]' : [_2]},
	q{Invalid extra path '[_1]'} => q{Chemin supplémentaire invalide '[_1]'},
	q{Movable Type was unable to write on the "Upload Destination". Please make sure that the folder is writable from the web server.} => q{Movable Type n'a pas réussi à écrire dans la destination du téléchargement. Veuillez vérifier que le répertoire de destination est ouvert en écriture au niveau du serveur web.},

## addons/Community.pack/lib/MT/Community/Tags.pm
	'Click here to follow' => 'Cliquer ici pour suivre',
	'Click here to leave' => 'Cliquer ici pour quitter',
	'Click here to recommend' => 'Cliquer ici pour recommander',
	q{You used an '[_1]' tag outside of the block of MTIfEntryRecommended; perhaps you mistakenly placed it outside of an 'MTIfEntryRecommended' container?} => q{Vous avez utilisé un tag '[_1]' en dehors d'un bloc de MTIfEntryRecommended; Peut-être l'avez-vous placé par erreur en dehors d'un conteneur 'MTIfEntryRecommended' ?},

## addons/Community.pack/lib/MT/Community/Upgrade.pm
	'Removing Profile Error global system template...' => 'Suppression du gabarit global Erreur de profil...',

## addons/Community.pack/templates/blog/about_this_page.mtml
	'This page contains a single entry by <a href="[_1]">[_2]</a> published on <em>[_3]</em>.' => 'Cette page contient une unique note de <a href="[_1]">[_2]</a> publiée le <em>[_3]</em>.',

## addons/Community.pack/templates/blog/archive_widgets_group.mtml
	q{This is a custom set of widgets that are conditioned to serve different content based upon what type of archive it is included. More info: [_1]} => q{Ceci est un groupe de widgets personnalisé qui est conditionné pour afficher un contenu différent en fonction du type d'archive dans lequel il est inclus. Plus d'infos : [_1]},

## addons/Community.pack/templates/blog/comment_preview.mtml
	'Comment on [_1]' => 'Commentaire sur [_1]',

## addons/Community.pack/templates/blog/comments.mtml
	'The data in #comments-content will be replaced by some calls to paginate script' => 'Les données dans #comments-content seront remplacées par des appels aux scripts de pagination.',

## addons/Community.pack/templates/blog/content_nav.mtml
	'Blog Home' => 'Accueil du blog',

## addons/Community.pack/templates/blog/entry_form.mtml
	'Body' => 'Corps',
	'Category' => 'Catégorie',
	'In order to create an entry on this blog you must first register.' => 'Avant de créer une note sur ce blog, vous devez vous enregistrer.',
	'Select Category...' => 'Sélectionner la catégorie...',
	'Sign in to create an entry.' => 'Identifiez-vous pour créer une note.',
	'Title' => 'Titre',
	q{You don't have permission to post.} => q{Vous n'avez pas la permission de poster.},

## addons/Community.pack/templates/blog/entry_metadata.mtml
	'Vote' => 'Vote',
	'Votes' => 'Votes',

## addons/Community.pack/templates/blog/entry_response.mtml
	'Entry Pending' => 'Message en attente',
	'Entry Posted' => 'Message posté',
	'Your entry has been posted.' => 'Votre message a bien été posté.',
	'Your entry has been received.' => 'Votre message a été reçu.',
	q{Return to the <a href="[_1]">blog's main index</a>.} => q{Retour à la <a href="[_1]">page principale du blog</a>.},
	q{Thank you for posting an entry.} => q{Merci d'avoir posté votre message.},
	q{Your entry has been received and held for approval by the blog owner.} => q{Votre message a été reçu et est en attente d'approbation par le propriétaire du blog.},

## addons/Community.pack/templates/blog/main_index_widgets_group.mtml
	q{This is a custom set of widgets that are conditioned to only appear on the homepage (or "main_index"). More info: [_1]} => q{Ceci est un groupe de wigets personnalisé qui est conditionné pour n'apparaître que sur la page d'accueil (ou "main_index"). Plus d'infos : [_1]},

## addons/Community.pack/templates/blog/powered_by.mtml
	'Powered by Movable Type [_1]' => 'Motorisé par Movable Type [_1]',
	'_MTCOM_URL' => 'https://www.movabletype.com/',

## addons/Community.pack/templates/forum/category_groups.mtml
	'Be the first to <a href="[_1]">post a topic in this forum</a>' => 'Soyez le premier à <a href="[_1]">créer un sujet dans ce forum</a>',
	'Forum Groups' => 'Groupes de forums',
	'Last Topic: [_1] by [_2] on [_3]' => 'Dernier sujet: [_1] par [_2] sur [_3]',

## addons/Community.pack/templates/forum/comment_detail.mtml
	'[_1] replied to <a href="[_2]">[_3]</a>' => '[_1] a répondu à <a href="[_2]">[_3]</a>',

## addons/Community.pack/templates/forum/comment_form.mtml
	'Add a Reply' => 'Ajouter une Réponse',
	'Reply' => 'Répondre',

## addons/Community.pack/templates/forum/comment_preview.mtml
	'Previewing your Reply' => 'Prévisualiser votre réponse',
	'Reply to [_1]' => 'Répondre à [_1]',

## addons/Community.pack/templates/forum/comment_response.mtml
	'Reply Submitted' => 'Réponse envoyée',
	'Thank you for replying.' => 'Merci pour votre réponse.',
	'Your reply has been accepted.' => 'Votre réponse a été acceptée.',
	q{Reply Submission Error} => q{Erreur lors de l'envoi de la réponse},
	q{Return to the <a href="[_1]">original topic</a>.} => q{Retour au <a href="[_1]">sujet d'origine</a>.},
	q{Your reply has been received and held for approval by the forum administrator.} => q{Votre réponse a bien été reçue et est en attente d'approbation par un administrateur du forum.},
	q{Your reply submission failed for the following reasons: [_1]} => q{L'envoi de la réponse a échoué pour les raisons suivantes : [_1]},

## addons/Community.pack/templates/forum/comments.mtml
	'# Replies' => '# Réponses',
	'1 Reply' => '1 Réponse',
	'No Replies' => 'Pas de Réponses',

## addons/Community.pack/templates/forum/content_header.mtml
	'Start Topic' => 'Débuter un sujet',

## addons/Community.pack/templates/forum/entry_create.mtml
	'Start a Topic' => 'Créer un nouveau sujet',

## addons/Community.pack/templates/forum/entry_form.mtml
	'Forum' => 'Forum',
	'Select Forum...' => 'Sélectionner un forum...',
	'Topic' => 'Sujet',

## addons/Community.pack/templates/forum/entry_popular.mtml
	'By [_1]' => 'Par [_1]',
	'Last Reply' => 'Dernière réponse',
	'Permalink to this Reply' => 'Lien permanent vers cette réponse',
	'Popular topics' => 'Sujets populaires',

## addons/Community.pack/templates/forum/entry_response.mtml
	'The topic you posted has been received and held for approval by the forum administrators.' => 'Le sujet que vous avez créé a bien été reçu et il est en attente de validation par les administrateurs du forum.',
	'The topic you posted has been received and published. Thank you for your submission.' => 'Le sujet que vous avez créé a bien été reçu et publié. Merci.',
	'Topic Pending' => 'Sujet en attente',
	'Topic Posted' => 'Sujet posté',
	q{Return to the <a href="[_1]">forum's homepage</a>.} => q{Retour à la <a href="[_1]">page d'accueil du forum</a>.},
	q{Thank you for posting a new topic to the forums.} => q{Merci d'avoir créé un nouveau sujet dans le forum.},

## addons/Community.pack/templates/forum/entry_table.mtml
	'Closed' => 'Fermé',
	'Post the first topic in this forum.' => 'Créez le premier sujet de ce forum.',
	'Recent Topics' => 'Sujets récents',
	'Replies' => 'Réponses',

## addons/Community.pack/templates/forum/javascript.mtml
	' to reply to this topic,' => ' pour répondre à ce sujet,',
	' to reply to this topic.' => ' pour répondre à ce sujet.',
	'. Now you can reply to this topic.' => '. Maintenant vous pouvez répondre à ce sujet.',
	'Sign in' => 'Identification',
	'Thanks for signing in,' => 'Merci de vous être identifié,',
	'or ' => 'ou ',
	'reply anonymously.' => 'répondre anonymement.',
	q{You do not have permission to comment on this blog.} => q{Vous n'avez pas la permission de commenter sur ce blog.},

## addons/Community.pack/templates/forum/main_index.mtml
	'Forum Home' => 'Accueil du forum',

## addons/Community.pack/templates/forum/search_results.mtml
	'Topics matching &ldquo;[_1]&rdquo;' => 'Sujets correspondants à &ldquo;[_1]&rdquo;',
	'Topics tagged &ldquo;[_1]&rdquo;' => 'Sujets taggués &ldquo;[_1]&rdquo;',
	'Topics' => 'Sujets',

## addons/Community.pack/templates/forum/syndication.mtml
	'All Forums' => 'Tous les forums',
	'[_1] Forum' => 'Forum [_1]',

## addons/Community.pack/templates/global/email_verification_email.mtml
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to sign in to [_1].' => 'Pour votre propre sécurité et pour prévenir la fraude, nous vous demandons de confirmer votre compte et adresse email avant de continuer. Une fois confirmés vous serez immédiatement autorisé à vous identifier sur [_1].',
	'Mail Footer' => 'Pied des e-mails',
	'Sincerely,' => 'Cordialement,',
	'Thank you for registering an account to [_1].' => 'Merci de créer un compte sur [_1].',
	'Thank you very much for your understanding.' => 'Merci beaucoup pour votre compréhension.',
	q{If you did not make this request, or you don't want to register for an account to [_1], then no further action is required.} => q{Si vous n'avez pas fait cette demande, ou que vous ne souhaitez pas créer un compte sur [_1], alors aucune action n'est nécessaire.},
	q{To confirm your account, please click on or cut and paste the following URL into a web browser:} => q{Pour confirmer votre compte, cliquez ou copiez-collez l'adresse suivante dans un navigateur web :},

## addons/Community.pack/templates/global/header.mtml
	'Blog Description' => 'Description du blog',
	'Blog Name' => 'Nom du blog',

## addons/Community.pack/templates/global/login_form.mtml
	'Forgot your password?' => 'Vous avez oublié votre mot de passe ?',
	'Not a member?&nbsp;&nbsp;<a href="[_1]">Sign Up</a>!' => 'Pas encore membre?&nbsp;&nbsp;<a href="[_1]">Enregistrez-vous</a> !',
	'Password' => 'Mot de passe',
	'Remember me?' => 'Mémoriser mes informations de connexion ?',
	q{Sign in using} => q{S'identifier en utilisant},
	q{Username} => q{Nom d'utilisateur},

## addons/Community.pack/templates/global/login_form_module.mtml
	'Edit Profile' => 'Éditer le profil',
	'Forgot Password' => 'Mot de passe oublié ?',
	'Hello [_1]' => 'Bonjour [_1]',
	'Logged in as <a href="[_1]">[_2]</a>' => 'Identifié comme <a href="[_1]">[_2]</a>',
	'Logout' => 'Déconnexion',
	'Sign up' => 'Enregistrez-vous',

## addons/Community.pack/templates/global/new_entry_email.mtml
	'Edit entry:' => 'Modifier la note :',
	'Publish Date: [_1]' => 'Date de publication : [_1]',
	'Title: [_1]' => 'Titre : [_1]',
	'View entry:' => 'Voir la note :',
	q{A new entry '[_1]([_2])' has been posted on your blog [_3].} => q{Une nouvelle note '[_1]([_2])' a été postée sur votre blog [_3].},
	q{Author name: [_1]} => q{Nom de l'auteur : [_1]},
	q{Author nickname: [_1]} => q{Surnom de l'auteur : [_1]},

## addons/Community.pack/templates/global/new_password.mtml
	'Change Password' => 'Changer le mot de passe',
	'Change' => 'Modifier',
	'Confirm New Password' => 'Confirmer le nouveau mot de passe',
	'Enter the new password.' => 'Saisissez le nouveau mot de passe.',
	'New Password' => 'Nouveau mot de passe',

## addons/Community.pack/templates/global/new_password_reset_form.mtml
	'An email with a link to reset your password has been sent to your email address ([_1]).' => 'Un e-mail contenant un lien pour réinitialiser votre mot de passe a été envoyé à votre adresse e-mail ([_1]).',
	'Back (x)' => 'Retour',
	'Go Back (x)' => 'Retour (x)',
	'Reset (s)' => 'Réinitialiser (s)',
	'Reset Password' => 'Réinitialiser le mot de passe',
	'Reset' => 'Mettre à jour',
	'Sign in to Movable Type (s)' => 'Connectez-vous sur Movable Type (s)',
	'Sign in to Movable Type' => 'Connectez-vous sur Movable Type',
	q{The email address provided is not unique.  Please enter your username.} => q{L'adresse e-mail fournie n'est pas unique. Merci de saisir votre nom d'utilisateur.},

## addons/Community.pack/templates/global/profile_edit_form.mtml
	'Confirm Password' => 'Confirmation du mot de passe',
	'Current Password' => 'Mot de passe actuel',
	'Go <a href="[_1]">back to the previous page</a> or <a href="[_2]">view your profile</a>.' => 'Retourner à  <a href="[_1]">la page précédente</a> ou <a href="[_2]">voir votre profil</a>.',
	'Save (s)' => 'Enregistrer (s)',
	'This profile has been updated.' => 'Ce profil a été mis à jour.',
	'Website URL' => 'URL du site',

## addons/Community.pack/templates/global/profile_feed.mtml
	'Commented on [_1] in [_2]' => 'A commenté sur [_1] dans [_2]',
	'Posted [_1] to [_2]' => 'A posté [_1] sur [_2]',
	'Voted on [_1] in [_2]' => 'A voté sur [_1] dans [_2]',
	'[_1] voted on <a href="[_2]">[_3]</a> in [_4]' => '[_1] a voté sur <a href="[_2]">[_3]</a> dans [_4]',

## addons/Community.pack/templates/global/profile_view.mtml
	'Comment Threads' => 'Fils de discussion',
	'Commented on [_1]' => 'A commenté sur [_1]',
	'Favorited [_1] on [_2]' => 'A mis comme favori [_1] dans [_2]',
	'Follow' => 'Suivre',
	'No responses to comments.' => 'Pas de réponse aux commentaires.',
	'Not following anyone' => 'Ne suit personne',
	'Recent Actions from [_1]' => 'Actions récentes de [_1]',
	'Recent Actions' => 'Actions récentes',
	'Unfollow' => 'Ne plus suivre',
	'Website:' => 'Site web :',
	'You are followed by [_1].' => 'Vous êtes suivi par [_1].',
	'You are following [_1].' => 'Vous suivez [_1]',
	'[_1] commented on ' => '[_1] a commenté sur',
	q{No recent actions.} => q{Plus d'actions récentes.},
	q{Not being followed} => q{N'est pas suivi},
	q{User Profile} => q{Profil de l'utilisateur},
	q{You are not followed by [_1].} => q{Vous n'êtes pas suivi par [_1].},

## addons/Community.pack/templates/global/register_confirmation.mtml
	'Profile Created' => 'Profil créé',
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'Pour confirmer et activer votre compte merci de vérifier votre boîte e-mail et de cliquer sur le lien que nous venons de vous envoyer.',
	q{Authentication Email Sent} => q{Email d'authentification envoyé},
	q{To complete the registration process you must first confirm your account. An email has been sent to [_1].} => q{Pour terminer la procédure d'enregistrement vous devez confirmer votre compte. Un e-mail a été envoyé à [_1].},

## addons/Community.pack/templates/global/register_form.mtml
	'Initial Password' => 'Mot de passe *',
	'Password Confirm' => 'Mot de passe (confirmation)',
	'Repeat the password for confirmation.' => 'Répétez votre mot de passe pour confirmer.',
	'Select a password for yourself.' => 'Sélectionnez un mot de passe pour vous.',
	'The URL of your website. (Optional)' => 'URL de votre site internet (optionnel)',
	'The name appears on your comment.' => 'Le nom apparaît dans votre commentaire.',
	'Your email address.' => 'Votre adresse e-mail.',
	q{Your login name.} => q{Votre nom d'utilisateur.},

## addons/Community.pack/templates/global/register_notification_email.mtml
	'Email: [_1]' => 'E-mail : [_1]',
	'Full Name: [_1]' => 'Nom complet : [_1]',
	'New User Information:' => 'Informations concernant ce nouvel utilisateur :',
	'Username: [_1]' => 'Identifiant : [_1]',
	q{This email is to notify you that a new user has successfully registered on the blog '[_1]'. Listed below you will find some useful information about this new user.} => q{Un nouvel utilisateur s'est enregistré sur le blog '[_1]'. Vous trouverez ci-dessous quelques informations utiles à propos de ce nouvel utilisateur.},
	q{To view or edit this user, please click on or cut and paste the following URL into a web browser:} => q{Pour voir ou modifier cet utilisateur, merci de cliquer ou copier-coller l'adresse suivante dans votre navigateur web :},

## addons/Community.pack/templates/global/search.mtml
	'Go' => 'OK',

## addons/Community.pack/templates/global/signin.mtml
	'Edit profile' => 'Editer le profil',
	'Not a member? <a href="[_1]">Register</a>' => 'Pas encore membre ? <a href="[_1]">Enregistrez-vous</a>',
	'Sign out' => 'Déconnexion',
	'You are signed in as <a href="[_1]">[_2]</a>' => 'Vous êtes identifié(e) comme étant <a href="[_1]">[_2]</a>',
	'You are signed in as [_1]' => 'Vous êtes identifié(e) comme étant [_1]',

## addons/Community.pack/tmpl/cfg_community_prefs.tmpl
	'Allow anonymous user to recommend' => 'Autoriser un utilisateur anonyme à recommander',
	'Anonymous Recommendation' => 'Recommandation anonyme',
	'Community Settings' => 'Réglages de la communauté',
	'If enabled, all moderated entries will be filtered by Junk Filter.' => 'Si activé, toutes les notes modérées seront filtrés par le filtre de spam',
	'Junk Filter' => 'Filtre de spam',
	'Site Root' => 'Racine du site',
	'Upload Destination' => 'Destination du fichier',
	'You must set a valid path.' => 'Vous devez définir un chemin valide.',
	'Your preferences have been saved.' => 'Vos préférences ont été sauvegardées.',
	q{Archive Root} => q{Racine de l'archive},
	q{Check to allow anonymous users (users not logged in) to recommend discussion.  IP address is recorded and used to identify each user.} => q{Cocher pour autoriser les utilisateurs anonymes (non identifiés) à recommander une discussion. L'adresse IP est enregistrée et utilisée pour identifier chaque utilisateur.},

## addons/Community.pack/tmpl/widget/blog_stats_registration.mtml
	'Author' => 'par auteurs',
	'Recent Registrations' => 'Inscriptions récentes',
	'You have [quant,_1,registration,registrations] from [_2]' => 'Vous avez [quant,_1,création de compte,créations de compte] sur [_2]',
	q{default userpic} => q{Image de l'utilisateur par défaut},

## addons/Community.pack/tmpl/widget/most_popular_entries.mtml
	q{There are no popular entries.} => q{Il n'y a pas de notes populaires.},

## addons/Community.pack/tmpl/widget/recent_submissions.mtml
	'No Title' => 'sans titre',
	'No entries available.' => 'Aucune note disponible.',
	'Posted by [_1] [_2] in [_3]' => 'Postée par [_1] [_2] dans [_3]',
	'Posted by [_1] [_2]' => 'Postée par [_1] [_2]',
	'Tagged: [_1]' => 'Avec le tag : [_1]',

## addons/Community.pack/tmpl/widget/recently_scored.mtml
	q{There are no recently favorited entries.} => q{Il n'y a pas de notes favorites récentes.},

## addons/Enterprise.pack/app-cms.yaml
	'Are you sure you want to delete the selected group(s)?' => 'Etes-vous sûr de vouloir effacer les groupes sélectionnés ?',
	'Are you sure you want to remove the selected member(s) from the group?' => 'Voulez-vous vraiment retirer les groupes sélectionnés ?',
	'Bulk Author Export' => 'Export auteurs en masse',
	'Bulk Author Import' => 'Importer les auteurs en masse',
	'Disable' => 'Désactiver',
	'Enable' => 'Activer',
	'Groups ([_1])' => 'Groupes ([_1])',
	'Groups' => 'Groupes',
	'Manage Member' => 'Gérer le membre',
	'Remove' => 'Retirer',
	'Synchronize Groups' => 'Synchroniser les groupes',
	'Synchronize Users' => 'Synchroniser les utilisateurs',
	q{Add user to group} => q{Ajouter l'utilisateur au groupe},
	q{[_1]'s Group} => q{Le Groupe de [_1]},

## addons/Enterprise.pack/app-wizard.yaml
	q{This module is required in order to use the LDAP Authentication.} => q{Ce module est nécessaire pour utiliser l'identification LDAP.},

## addons/Enterprise.pack/config.yaml
	'Active Groups' => 'Groupes actifs',
	'Active' => 'Actif',
	'Advanced Pack' => 'Advanced Pack',
	'Disabled Groups' => 'Groupes inactifs',
	'Disabled Users' => 'Utilisateurs désactivés',
	'Disabled' => 'Désactivé',
	'Email' => 'Adresse e-mail',
	'Enabled Users' => 'Utilisateurs actifs',
	'Enabled' => 'Activé',
	'External Directory Synchronization' => 'Synchronization répertoire externe',
	'Group Member' => 'Membre du groupe',
	'Group Members' => ' Membres du groupe',
	'Group Name' => 'Nom du groupe',
	'Group' => 'Groupe',
	'Inactive' => 'Inactif',
	'Invalid parameter.' => 'Paramètre invalide.',
	'Manage Group Members' => 'Gérer les membres du groupe',
	'Members of group: [_1]' => 'Membres du groupe : [_1]',
	'Microsoft SQL Server Database UTF-8 support (Recommended)' => 'Support UTF-8 Base de données Microsoft SQL Server (recommendé)',
	'Microsoft SQL Server Database' => 'Base de données Microsoft SQL Server',
	'My Groups' => 'Mes groupes',
	'ODBC Driver' => 'Pilote ODBC',
	'Oracle Database (Recommended)' => 'Base de données Oracle (Recommendé)',
	'Pending' => 'En attente',
	'Permissions for Groups' => 'Permissions pour les groupes',
	'Permissions for Users' => 'Permissions pour les utilisateurs',
	'Permissions of group: [_1]' => 'Permissions du groupe [_1]',
	'Publish Charset' => 'Publier le  Charset',
	'Status' => 'Statut',
	'User' => 'Utilisateur',
	'User/Group' => 'Utilisateur/Groupe',
	'__COMMENT_COUNT' => 'Nombre de commentaires',
	'__ENTRY_COUNT' => 'Nombre de notes',
	'__GROUP_MEMBER_COUNT' => 'Nombre de membres du groupe',
	q{Groups associated with author: [_1]} => q{Groupes associés avec l'auteur : [_1]},
	q{Populating author's external ID to have lower case user name...} => q{Peuplement de l'ID externe d'auteur pour avoir des identifiants en minuscule...},
	q{User Info} => q{Infos de l'utilisateur},
	q{User/Group Name} => q{Nom d'utilisateur/groupe},

## addons/Enterprise.pack/lib/MT/Auth/LDAP.pm
	'(none)' => '(Aucun)',
	'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'Une tentative de désactivation de tous les administrateurs système a été réalisée. La synchronisation des utilisateurs a été interrompue.',
	'Cannot connect to LDAP server.' => 'Impossible de se connecter au serveur LDAP.',
	'Cannot synchronize LDAP groups members.' => 'Impossible de synchroniser les membres des groupes LDAP.',
	'External user synchronization failed.' => 'Synchronisation utilisateur externe échouée.',
	'Failed to create a new group: [_1]' => 'Impossible de créer un nouveau groupe : [_1]',
	'Information about the following groups was modified:' => 'Une information à propos des groupes suivants a été modifiée :',
	'Information about the following users was modified:' => 'Une information à propos des utilisateurs suivants a été modifiée :',
	'LDAP groups synchronized with existing groups.' => 'Groupes LDAP synchronisés avec les groupes existants.',
	'LDAP user [_1] not found.' => 'Utilisateur LDAP [_1] non trouvé.',
	'LDAP users synchronization interrupted.' => 'Synchronisation des utilisateurs LDAP interrompue.',
	'LDAP users synchronized.' => 'Utilisateurs LDAP synchronisés.',
	'LDAPUserGroupMemberAttribute must be set to enable synchronizing of members of groups.' => 'LDAPUserGroupMemberAttribute doit être configuré pour permettre la synchronisation des membres des groupes.',
	'Loading MT::LDAP::Multi failed: [_1]' => 'Le chargement de MT::LDAP::Multi a échoué : [_1]',
	'Members added: ' => 'Membres ajoutés :',
	'Members removed: ' => 'Membres supprimés :',
	'Primary group members cannot be synchronized with Active Directory.' => 'Les membres du groupe principal ne peuvent être synchronisés avec Active Directory.',
	'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute being set.' => 'La synchronisation des groupes ne peut pas être faite sans la configuration de LDAPGroupIdAttribute et/ou LDAPGroupNameAttribute.',
	'The following groups were deleted:' => 'Les groupes suivants ont été effacés :',
	'The following users were disabled:' => 'Les utilisateurs suivants ont été désactivés:',
	'User [_1] cannot be updated.' => 'Utilisateur [_1] ne peut être mis à jour.',
	'User [_1]([_2]) not found.' => 'Utilisateur [_1]([_2]) non trouvé.',
	'User cannot be updated: [_1].' => 'Utilisateur ne peut être mis à jour : [_1].',
	'[_1] directive must be set to synchronize members of LDAP groups to Movable Type Advanced.' => 'La directive [_1] doit être configurée pour synchroniser les membres des groupes LDAP avec Movable Type Advanced.',
	q{Cannot get group '[_1]' (#[_2]) entry and its all member attributes from external directory.} => q{Impossible d'obtenir le groupe '[_1]' (#[_2]) et tous ses attributs membres depuis l'annuaire externe.},
	q{Cannot get member entries of group '[_1]' (#[_2]) from external directory.} => q{Impossible d'obtenir les entrées membres du groupe '[_1]' (#[_2]) depuis l'annuaire externe.},
	q{Failed login attempt by user '[_1]' who was deleted from LDAP.} => q{Échec lors de la tentative d'identification de l'utilisateur '[_1]' qui a été supprimé de LDAP},
	q{Failed login attempt by user '[_1]'. A user with that username already exists in the system with a different UUID.} => q{Échec lors de la tentative d'identification de l'utilisateur '[_1]'. Un utilisateur avec ce nom d'utilisateur existe déjà dans le système avec un UUID différent.},
	q{Memberships in the group '[_2]' (#[_3]) were changed as a result of synchronizing with the external directory.} => q{Les appartenances au groupe '[_2] (#[_3]) ont été changées par la synchronisation avec l'annuaire externe.},
	q{No LDAP group was found using the filter provided.} => q{Aucun groupe LDAP n'a été trouvé en utilisant le filtre indiqué.},
	q{The filter used to search for groups was: '[_1]'. Search base was: '[_2]'} => q{Le filtre utilisé pour la recherche dans les groupes était : '[_1]'. La base de la recherche était : '[_2]'},
	q{User '[_1]' account is disabled.} => q{Le compte de l'utilisateur '[_1]' est désactivé.},
	q{User '[_1]' cannot be updated.} => q{Utilisateur '[_1]' ne peut être mis à jour.},
	q{User '[_1]' updated with LDAP login ID.} => q{Utilisateur '[_1]' mis à jour avec l'ID de login LDAP.},
	q{User '[_1]' updated with LDAP login name '[_2]'.} => q{Utilisateur '[_1]' mis à jour avec l'identifiant LDAP '[_2]'.},
	q{User cannot be created: [_1].} => q{L'utilisateur n'a pu être créé : [_1].},
	q{User filter was not built: [_1]} => q{Le filtre utilisateur n'a pas été construit : [_1]},

## addons/Enterprise.pack/lib/MT/Enterprise/Author.pm
	'Loading MT::LDAP failed: [_1].' => 'Échec de chargement MT::LDAP[_1]',

## addons/Enterprise.pack/lib/MT/Enterprise/BulkCreation.pm
	'Formatting error at line [_1]: [_2]' => 'Erreur de formattage à la ligne [_1] : [_2]',
	'Invalid blog URL: [_1]' => 'URL de blog invalide : [_1]',
	'Invalid command: [_1]' => 'Commande invalide : [_1]',
	'Invalid email address: [_1]' => 'Adresse e-mail invalide : [_1]',
	'Invalid language: [_1]' => 'Paramètre "language" invalide : [_1]',
	'Invalid number of columns for [_1]' => 'Nombre de colonnes invalide pour [_1]',
	'Invalid password: [_1]' => 'Mot de passe invalide : [_1]',
	'Invalid site root: [_1]' => 'Racine du site invalide : [_1]',
	'Invalid theme ID: [_1]' => 'ID de thème invalide : [_1]',
	'Invalid timezone: [_1]' => 'Fuseau horaire invalide : [_1]',
	'Invalid user name: [_1]' => 'Identifiant invalide : [_1]',
	'Invalid weblog name: [_1]' => 'Nom de weblog invalide : [_1]',
	q{'Personal Blog Location' setting is required to create new user blogs.} => q{Le paramètre 'Localisation du blog personnel' est nécessaire pour créer de nouveaux blogs utilisateur},
	q{A theme '[_1]' was not found.} => q{Un thème '[_1]' est introuvable.},
	q{A user with the same name was found.  The registration was not processed: [_1]} => q{Un utilisateur avec le même nom a été trouvé. L'entregistrement n'a pas été effectué : [_1]},
	q{Blog '[_1]' for user '[_2]' has been created.} => q{Le blog '[_1]' pour l'utilisateur '[_2]' a été créé.},
	q{Blog for user '[_1]' can not be created.} => q{Le blog pour l'utilisateur '[_1]' ne peut être créé.},
	q{Error assigning weblog administration rights to user '[_1] (ID: [_2])' for weblog '[_3] (ID: [_4])'. No suitable weblog administrator role was found.} => q{Erreur en tentant d'assigner les droits d'administration du blog à l'utilisateur '[_1] (ID: [_2])' pour le weblog '[_3] (ID: [_4])'. Aucun rôle d'administrateur de weblog adéquat n'a été trouvé.},
	q{Invalid display name: [_1]} => q{Nom d'affichage invalide : [_1]},
	q{Permission granted to user '[_1]'} => q{Permission accordée à l'utilisateur '[_1]'},
	q{User '[_1]' already exists. The update was not processed: [_2]} => q{L'utilisateur '[_1] existe déjà. La mise à jour n'a pas continué : [_2]},
	q{User '[_1]' has been created.} => q{L'utilisateur '[_1]' a été créé.},
	q{User '[_1]' has been deleted.} => q{L'utilisateur '[_1]' a été supprimé.},
	q{User '[_1]' has been updated.} => q{L'utilisateur '[_1]' a été mis à jour.},
	q{User '[_1]' not found.  The deletion was not processed.} => q{L'utilisateur '[_1] n'a pas trouvé. La suppression n'a pas été effectuée.},
	q{User '[_1]' not found.  The update was not processed.} => q{L'utilisateur '[_1] n'a pas trouvé. La mise à jour n'a pas continué.},
	q{User '[_1]' was found, but the deletion was not processed} => q{L'utilisateur '[_1] a été trouvé, mais la suppression n'a pas été effectuée.},

## addons/Enterprise.pack/lib/MT/Enterprise/CMS.pm
	'(no reason given)' => '(sans raison donnée)',
	'Add Users to Group [_1]' => 'Ajouter les utilisateurs au groupe [_1]',
	'Add Users to Groups' => 'Ajouter des utilisateurs aux groupes',
	'Bulk management' => 'Gestion en masse',
	'Cannot rewind' => 'Impossible de revenir en arrière',
	'Each group must have a name.' => 'Chaque groupe doit avoir un nom.',
	'Group Profile' => 'Profil du Groupe',
	'Group load failed: [_1]' => 'Chargement du groupe échoué : [_1]',
	'Groups Selected' => 'Groupes sélectionnés',
	'Invalid group' => 'Groupe invalide.',
	'Invalid user' => 'Utilisateur invalide',
	'Load failed: [_1]' => 'Échec du chargement : [_1]',
	'Please select a file to upload.' => 'Merci de sélectionner un fichier à télécharger.',
	'Registered [quant,_1,user,users], updated [quant,_2,user,users], deleted [quant,_3,user,users].' => 'Création de [quant,_1,utilisateur,utilisateurs], modification de [quant,_2, utilisateur, utilisateurs], suppression de [quant,_3, utilisateur, utilisateurs].',
	'Search Groups' => 'Rechercher des groupes',
	'Search Users' => 'Rechercher des utilisateurs',
	'Select Groups' => 'Sélectionner les groupes',
	'Select Users' => 'Utilisateurs sélectionnés',
	'Type a group name to filter the choices below.' => 'Tapez un nom de groupe pour filtrer les choix ci-dessous.',
	'Users & Groups' => 'Utilisateurs et Groupes',
	'Users Selected' => 'Utilisateurs sélectionnés',
	'Users' => 'Utilisateurs',
	q{A user cannot change his/her own username in this environment.} => q{Un utilisateur ne peut pas changer son nom d'utilisateur dans cet environnement},
	q{An error occurred when enabling this user.} => q{Une erreur s'est produite pendant l'activation de cet utilisateur.},
	q{Assign User [_1] to Groups} => q{Assigner l'utilisateur [_1] aux groupes.},
	q{Author load failed: [_1]} => q{Chargement de l'auteur échoué : [_1]},
	q{Bulk author export cannot be used under external user management.} => q{L'exportation par lot ne peut pas être utilisé lors d'une gestion des utilisateurs externe.},
	q{Bulk import cannot be used under external user management.} => q{L'import en masse ne peut être utilisé avec la gestion externe des utilisateurs.},
	q{Movable Type Advanced has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.} => q{Movable Type Advanced vient de tenter de désactiver votre compte pendant la synchronisation avec l'annuaire externe. Certains des paramètres du système de gestion externe des utilisateurs doivent être erronés. Merci de corriger avant de poursuivre.},
	q{No records were found in the file.  Make sure the file uses CRLF as the line-ending characters.} => q{Aucun enregistrement n'a été trouvé dans le fichier. Veuillez vous assurer que le fichier utilise CRLF comme caractère de fin de ligne.},
	q{Type a username to filter the choices below.} => q{Tapez un nom d'utilisateur pour affiner les choix ci-dessous.},
	q{User '[_1]' (ID:[_2]) removed from group '[_3]' (ID:[_4]) by '[_5]'} => q{Utilisateur '[_1]' (ID:[_2]) supprimé du groupe '[_3]' (ID:[_4]) par '[_5]'},
	q{User '[_1]' (ID:[_2]) was added to group '[_3]' (ID:[_4]) by '[_5]'} => q{Utilisateur '[_1]' (ID:[_2]) a été ajouté au groupe '[_3]' (ID:[_4]) par '[_5]'},
	q{User load failed: [_1]} => q{Chargement de l'utilisateur échoué : [_1]},

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Callback/Group.pm
	'A parameter "[_1]" is invalid.' => 'Un paramètre "[_1]" est invalide.',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/Group.pm
	'A resource "member" is required.' => 'Une ressource "membre" est requise.',
	'Creating group failed: ExternalGroupManagement is enabled.' => 'La création du groupe a échoué : ExternalGroupManagement est activé.',
	'Group not found' => 'Groupe introuvable',
	'Member not found' => 'Membre introuvable',
	q{Adding member to group failed: [_1]} => q{L'ajout du membre au groupe a échoué : [_1]},
	q{Cannot add member to inactive group.} => q{Impossible d'ajouter un membre à un groupe inactif.},
	q{Removing member from group failed: [_1]} => q{Le membre n'a pas pu être retiré du groupe : [_1]},

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/Permission.pm
	'Association not found' => 'Association introuvable',
	q{Granting permission failed: [_1]} => q{L'autorisation n'a pas pu être attribuée : [_1]},

## addons/Enterprise.pack/lib/MT/Enterprise/Upgrade.pm
	'Fixing binary data for Microsoft SQL Server storage...' => 'Correction des données binaires pour le stockage Microsoft SQL Server...',

## addons/Enterprise.pack/lib/MT/Enterprise/Wizard.pm
	'CRAM-MD5' => 'CRAM-MD5',
	'Digest-MD5' => 'Digest-MD5',
	'Found' => 'Trouvé',
	'Login' => 'Identifiant',
	'Not Found' => 'Non trouvé',
	'PLAIN' => 'PLAIN',

## addons/Enterprise.pack/lib/MT/Group.pm
	'Backing up [_1] records:' => 'Sauvegarde des enregistrements [_1] :',
	'[_1] records backed up.' => '[_1] enregistrements sauvegardés.',

## addons/Enterprise.pack/lib/MT/LDAP.pm
	'Binding to LDAP server failed: [_1]' => 'Le rattachement au serveur LDAP a échoué : [_1]',
	'Entry not found in LDAP: [_1]' => 'Entrée introuvable dans LDAP : [_1]',
	'Error connecting to LDAP server [_1]: [_2]' => 'Erreur de connection au serveur LDAP [_1] : [_2]',
	'Invalid LDAPAuthURL scheme: [_1].' => 'LDAPAuthURL invalide : [_1].',
	q{Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.} => q{Soit votre serveur n'a pas [_1] d'installé, soit la version installée est trop vieille, ou [_1] nécessite un autre module qui n'est pas installé},
	q{More than one user with the same name found in LDAP: [_1]} => q{Plus d'un utilisateur avec le même nom a été trouvé dans LDAP : [_1]},
	q{User not found in LDAP: [_1]} => q{L'utilisateur n'a pas été trouvé dans LDAP : [_1]},

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/MSSQLServer.pm
	q{PublishCharset [_1] is not supported in this version of the MS SQL Server Driver.} => q{PublishCharset [_1] n'est pas supporté dans cette version du pilote MS SQL Server.},

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/UMSSQLServer.pm
	'This version of UMSSQLServer driver requires DBD::ODBC compiled with Unicode support.' => 'Cette version du driver UMSSQLServer nécessite DBD::ODBC compilé avec le support de Unicode.',
	'This version of UMSSQLServer driver requires DBD::ODBC version 1.14.' => 'Cette version du driver UMSSQLServer nécessite DBD::ODBC version 1.14.',

## addons/Enterprise.pack/tmpl/author_bulk.tmpl
	'Cancel (x)' => 'Annuler (x)',
	'Manage Users in bulk' => 'Gérer les utilisateurs en masse',
	'Source File Encoding' => 'Encodage du fichier source',
	'Specify the CSV-formatted source file for upload' => 'Spécifier le fichier source CSV à charger',
	'Upload (u)' => 'Charger (u)',
	'Upload source file' => 'Charger le fichier source',
	'Upload' => 'Envoyer',
	'[_1] Edit</a>' => 'Éditer du [_1]',
	'[_1] Setting</a>' => 'Paramètre du [_1]',
	'_USAGE_AUTHORS_2' => 'Vous pouvez créer, modifier et effacer des utilisateurs en masse en chargeant un fichier CSV contenant ces commandes et les données associées.',
	q{Movable Type will automatically try to detect the character encoding of your import file.  However, if you experience difficulties, you can set the character encoding explicitly.} => q{Movable Type va automatiquement essayer de détecter le système d'encodage de votre fichier d'importation. Cependant, si cela ne fonctionne pas, vous pouvez spécifier explicitement le système d'encodage.},
	q{New user blog would be created on '[_1]'.} => q{Un nouveau blog d'utilisateur serait créé sur '[_1]'.},
	q{You must set 'Personal Blog Location' to create a new blog for each new user.} => q{Vous devez paramétrer 'L'emplacement du blog persomnel' pour créer un blog pour chaque utilisateur.},

## addons/Enterprise.pack/tmpl/cfg_ldap.tmpl
	'(and [_1] more groups)' => '(et [_2] groupes en plus)',
	'(and [_1] more members)' => '(et [_1] membres en plus)',
	'15 Minutes' => '15 Minutes',
	'30 Minutes' => '30 Minutes',
	'60 Minutes' => '60 Minutes',
	'90 Minutes' => '90 Minutes',
	'Authentication DN' => 'Identificatiin DN',
	'CN' => 'CN',
	'Continue' => 'Continuer',
	'Email Attribute' => 'Attribut email',
	'Enable External User Management' => 'Activer les gestion externe des utilisateurs',
	'Group Filter Attribute' => 'Attribut de filtre du groupe',
	'Group Fullname Attribute' => 'Attribut nom complet du groupe',
	'Group Fullname' => 'Nom complet du groupe',
	'Group Member Attribute' => 'Attribut membre du groupe',
	'Group Name Attribute' => 'Attribut nom du groupe',
	'Group Search Base Attribute' => 'Attribut de base de recherche du groupe',
	'GroupID Attribute' => 'Attribut GroupID',
	'LDAP Server' => 'Serveur LDAP',
	'Other' => 'Autre',
	'SASL Mechanism' => 'Mécanisme SASL',
	'Search Result (max 10 entries)' => 'Résultat de recherche (maxi 10 entrées)',
	'Search Results (max 10 entries)' => 'Résultats de recherche (maxi 10 entrées)',
	'Select One...' => 'Sélectionner...',
	'Synchronization Frequency' => 'Fréquence de synchronisation',
	'Test Password' => 'Mot de passe de test',
	'Test Username' => 'Identifiant de test',
	'Test connection to LDAP' => 'Tester la connection à LDAP',
	'Test search' => 'Tester la recherche',
	'The frequency of synchronization in minutes. (Default is 60 minutes)' => 'La fréquence de synchronisation en minutes. (60 minutes par défaut).',
	'Use LDAP' => 'Utiliser LDAP',
	'Used for setting the password of the LDAP DN.' => 'Utilisé pour régler le mot de passe du DN LDAP.',
	'User Fullname Attribute' => 'Attribut nom complet utilisateur',
	'User Fullname' => 'Nom complet utilisateur',
	'User ID Attribute' => 'Attribut ID utilisateur',
	'User Member Attribute' => 'Attribut membre utilisateur',
	'You must set your Group search base.' => 'Vous devez configurer votre base de recherche de groupes.',
	'You must set your GroupID attribute.' => 'Vous devez configurer votre attribut GroupID.',
	'You must set your UserID attribute.' => 'Vous devez configurer votre attribut UserID.',
	'You must set your email attribute.' => 'Vous devez configurer votre attribut email.',
	'You must set your group fullname attribute.' => 'Vous devez configurer votre attribut nom complet du groupe.',
	'You must set your group member attribute.' => 'Vous devez configurer votre attribut member du groupe.',
	'You must set your group name attribute.' => 'Vous devez configurer votre attribut nom de groupe.',
	'Your LDAP configuration is complete.' => 'Votre configuration LDAP est terminée.',
	'Your configuration was successful.' => 'Votre configuration est correcte.',
	q{An error occurred while attempting to connect to the LDAP server: } => q{Une erreur s'est produite en essayant de se connecter au serveur LDAP :},
	q{An optional DN used to bind to the LDAP directory when searching for a user.} => q{Un DN optionnel utilisé pour rattacher à l'annuaire LDAP lors d'une recherche d'utilisateur.},
	q{Attribute mapping} => q{Rattachement d'attribut},
	q{Authentication Configuration} => q{Configuration de l'identification},
	q{Authentication URL} => q{URL d'identification},
	q{Authentication password} => q{Mot de passe de l'identification},
	q{Cannot locate Net::LDAP. Net::LDAP module is required to use LDAP authentication.} => q{Net::LDAP impossible à localiser. Le module Net::LDAP est requis pour l'authentification LDAP.},
	q{Click 'Continue' below to configure the External User Management settings.} => q{Cliquez sur 'Continuer' ci-dessous pour configurer les réglages de la gestion externe des utilisateurs.},
	q{Click 'Continue' below to configure your LDAP attribute mappings.} => q{Cliquez sur 'Continuer' ci-dessous pour configurer vos rattachements des attributs LDAP.},
	q{No groups could be found.} => q{Aucun groupe n'a été trouvé.},
	q{No groups were found with these settings.} => q{Aucun groupe n'a été trouvé avec ces réglages.},
	q{No users could be found.} => q{Aucun utilisateur n'a été trouvé.},
	q{The URL to access for LDAP authentication.} => q{L'URL pour accéder à l'identification LDAP.},
	q{The name of the SASL Mechanism used for both binding and authentication.} => q{Le nom du mécanisme SASL est utilisé pour l'association et l'authentification.},
	q{To finish with the configuration wizard, press 'Continue' below.} => q{Pour finir l'assistant de configuration, cliquez sur 'Continuer' ci-dessous.},
	q{You can configure your LDAP settings from here if you would like to use LDAP-based authentication.} => q{Vous devez configurer vos réglages LDAP ici si vous souhaitez utiliser l'identification LDAP.},
	q{You must set your Authentication URL.} => q{Vous devez configurer votre URL d'identification.},
	q{You must set your user fullname attribute.} => q{Vous devez configurer votre attribut nom complet de l'utilisateur.},
	q{You must set your user member attribute.} => q{Vous devez configurer votre attribut de membre de l'utilisateur.},

## addons/Enterprise.pack/tmpl/create_author_bulk_end.tmpl
	'All users were updated successfully.' => 'Tous les utilisateurs ont été mis à jour avec succès',
	'An error occurred during the update process. Please check your CSV file.' => 'Une erreur est apparue lors du processus de mise à jour. Veuillez vérifier votre fichier CSV.',
	'Close' => 'Fermer',

## addons/Enterprise.pack/tmpl/dialog/dialog_select_group_user.tmpl
	'Close (x)' => 'Fermer (x)',
	q{No groups exist in this installation. [_1]Create a group</a>} => q{Aucun groupe n'existe dans cette installation. [_1]Créer un groupe</a>},
	q{No users exist in this installation. [_1]Create a user</a>} => q{Aucun utilisateur n'existe dans cette installation. [_1]Créer un utilisateur</a>},

## addons/Enterprise.pack/tmpl/dialog/select_groups.tmpl
	'You need to create some groups.' => 'Vous devez créer des groupes',
	q{Before you can do this, you need to create some groups. <a href="javascript:void(0);" onclick="closeDialog('[_1]');">Click here</a> to create a group.} => q{Avant de pouvoir faire ceci, vous devez créer des groupes. <a href="javascript:void(0);" onclick="closeDialog('[_1]');">Cliquez ici</a> pour créer un groupe.},

## addons/Enterprise.pack/tmpl/edit_group.tmpl
	'Create Group' => 'Créer un groupe',
	'Created By' => 'Créé par',
	'Created On' => 'Créé le',
	'Edit Group' => 'Modifier le groupe',
	'LDAP Group ID' => 'Group ID LDAP',
	'Member ([_1])' => 'Membre ([_1])',
	'Members ([_1])' => 'Membres ([_1])',
	'Permission ([_1])' => 'Permission ([_1])',
	'Permissions ([_1])' => 'Permissions ([_1])',
	'Save changes to this field (s)' => 'Sauvegarder les changements apportés à ce champ (s)',
	'System' => 'Système',
	'The description for this group.' => 'La description de ce groupe.',
	'The name used for identifying this group.' => 'Le nom utilisé pour identifier ce groupe.',
	'This group profile has been updated.' => 'Ce profil de groupe a été mis à jour.',
	'This group was classified as disabled.' => 'Ce groupe a été classé comme désactivé.',
	'This group was classified as pending.' => 'Ce groupe a été classé comme en attente.',
	'Useful links' => 'Liens utiles',
	'_USER_DISABLED' => 'Utilisateur désactivé',
	'_USER_ENABLED' => 'Utilisateur activé',
	'_USER_STATUS_CAPTION' => 'Statut',
	q{Status of this group in the system. Disabling a group prohibits its members&rsquo; from accessing the system but preserves their content and history.} => q{Le statut de ce groupe dans le système. Désactiver un groupe empêche ses membres d'accéder au système mais conserve leur contenu et leur historique.},
	q{The LDAP directory ID for this group.} => q{L'ID de l'annuaire LDAP pour ce groupe.},
	q{The display name for this group.} => q{Le nom d'affichage de ce groupe.},

## addons/Enterprise.pack/tmpl/include/group_table.tmpl
	'Disable selected group (d)' => 'Désactiver le groupe sélectionné (d)',
	'Enable selected group (e)' => 'Activer le groupe sélectionné (e)',
	'Members' => 'Membres',
	'Remove selected group (d)' => 'Supprimer le groupe sélectionné (d)',
	'_USER_DISABLE' => 'Désactiver',
	'_USER_ENABLE' => 'Activer',
	'group' => 'groupe',
	'groups' => 'Groupes',
	'to act upon' => 'pour agir sur',

## addons/Enterprise.pack/tmpl/include/list_associations/page_title.group.tmpl
	'Permissions for [_1]' => 'Autorisations pour [_1]',
	'Users &amp; Groups for [_1]' => 'Utilisateurs &amp; groupes pour [_1]',

## addons/Enterprise.pack/tmpl/listing/group_list_header.tmpl
	'You successfully deleted the groups from the Movable Type system.' => 'Vous avez supprimé les groupes du système Movable Type.',
	'You successfully disabled the selected group(s).' => 'Vous avez désactivé les groupes sélectionnés avec succès.',
	'You successfully enabled the selected group(s).' => 'Vous avez activé les groupes sélectionnés avec succès.',
	q{An error occurred during synchronization.  See the <a href='[_1]'>activity log</a> for detailed information.} => q{Une erreur s'est produite durant la synchronisation. Consultez le <a href='[_1]'>journal d'activité</a> pour plus d'informations.},
	q{You successfully synchronized the groups' information with the external directory.} => q{Vous avez synchronisé les informations des groupes avec l'annuaire externe avec succès.},

## addons/Enterprise.pack/tmpl/listing/group_member_list_header.tmpl
	'Some ([_1]) of the selected users could not be re-enabled because they are no longer found in LDAP.' => 'Quelques ([_1]) des utilisateurs sélectionnés ne peuvent pas être réactivés car ils ne sont plus trouvés dans LDAP',
	'You successfully added new users to this group.' => 'Vous avez ajouté de nouveaux utilisateurs dans ce groupe avec succès.',
	'You successfully deleted the users.' => 'Vous avez supprimé avec succès les utilisateurs.',
	'You successfully removed the users from this group.' => 'Vous avez retiré avec succès les utilisateurs de ce groupe.',
	q{You successfully synchronized users' information with the external directory.} => q{Vous avez synchronisé les informations des utilisateurs avec l'annuaire externe avec succès.},

## addons/Sync.pack/config.yaml
	'Contents Sync' => 'Synchronisation des contenus',
	'Create new sync setting' => 'Créer un paramètre de synchronisation',
	'Manage Sync Settings' => 'Gérer les paramètres de synchronisation',
	'Migrated sync setting' => 'Paramètres de synchronisation migrés',
	'Migrating settings of contents sync on blog...' => 'Migration des paramètres de synchronisation des contenus sur le blog...',
	'Migrating settings of contents sync on website...' => 'Migration des paramètres de synchronisation des contenus sur le site...',
	'Re-creating job of contents sync...' => 'Recréation de la tâche de synchronisation de contenu...',
	'Remove sync PID files' => 'Supprimer les fichiers PID de synchronisation',
	'Remove unnecessary sync file list' => '',
	'Sync Datetime' => 'Horodatage de synchronisation',
	'Sync Log' => '',
	'Sync Name' => 'Nom de synchronisation',
	'Sync Setting' => 'Paramètre de synchronisation',
	'Sync Settings' => 'Paramètres de synchronisation',
	'Sync' => 'Synchronisation',
	'Updating MT::SyncSetting table...' => 'Mise à jour de la table MT::SyncSetting...',
	'https://www.sixapart.com/movabletype/' => '',

## addons/Sync.pack/lib/MT/FileSynchronizer.pm
	'Cannot load template.' => 'Impossible de charger le gabarit',
	'Synchronization start notification' => '',
	'Synchronization success notification' => 'Notification de succès de la synchronisation',
	q{Cannot find author for id '[_1]'} => q{Impossible de trouver un auteur pour l'id '[_1]'},
	q{Error sending mail ([_1]); try another MailTransfer setting?} => q{Erreur d'envoi d'e-mail ([_1]). Tentez avec un autre paramètre MailTransfer.},
	q{Synchronization error notification} => q{Notification d'échec de la synchronisation},

## addons/Sync.pack/lib/MT/FileSynchronizer/FTPBase.pm
	'  tried [_1] times but failed. ([_2]): [_3]' => '',
	'Failed to create sync list.' => 'Impossible de créer la liste de synchronisation.',
	'Some files/directories are not removed from [_1]: [_2]' => '',
	q{Cannot access to remote directory '[_1]'} => q{Impossible d'accéder au répertoire distant '[_1]'},
	q{Directory or file by which end of name is dot(.) or blank exists. Cannot synchronize these files.: "[_1]"} => q{Il existe un dossier ou fichier dont le suffixe est vide ou se termine par '.'. Ces fichiers ne peuvent pas être synchronisés : "[_1]"},
	q{Failed to remove sync list. (ID:'[_1]')} => q{Impossible de supprimer la liste de synchronisation. (ID:'[_1]')},
	q{Failed to update sync list. (ID:'[_1]')} => q{Impossible de mettre la liste de synchronisation à jour. (ID:'[_1]')},
	q{Unable to write remote files ([_1]): [_2]} => q{Impossible d'écrire les fichiers distants ([_1]) : [_2]},

## addons/Sync.pack/lib/MT/FileSynchronizer/Rsync.pm
	'Error during rsync: Command (exit code [_1]): [_2]' => 'Erreur à la synchronisation : commande (code de retour [_1]) : [_2]',
	'Error switching directory.' => 'Erreur au changement de répertoire.',
	'Failed to remove "[_1]": [_2]' => 'Impossible de supprimer "[_1]" : [_2]',
	'Incomplete file copy to Temp Directory.' => 'Copie de fichier incomplète vers le répertoire temporaire.',
	q{Temp Directory [_1] is not writable.} => q{Le répertoire Temp [_1] n'est pas ouvert en écriture.},

## addons/Sync.pack/lib/MT/MergedSyncStatus.pm
	'Failed to update sync file status.: "[_1]"' => '',

## addons/Sync.pack/lib/MT/SyncFileList.pm
	'Sync file list' => 'Liste des fichiers à synchroniser',

## addons/Sync.pack/lib/MT/SyncLog.pm
	'*Sync setting deleted*' => '*Paramètre de synchronisation supprimé*',
	'*User deleted*' => '*Utilisateur supprimé*',
	'Are you sure you want to reset the sync log?' => 'Voulez-vous vraiment réinitialiser le log de synchronisation ?',
	'By' => 'Par',
	'Clear Sync Log' => 'Vider le log de synchronisation',
	'Destination Name' => 'Nom de destination',
	'Download Sync Log (CSV)' => 'Télécharger le log de synchronisation (CSV)',
	'Error' => 'Erreur',
	'FTP Server' => 'Serveur FTP',
	'FTP' => 'FTP',
	'Finish Date' => 'Date de fin',
	'Finish Time' => 'Horaire de fin',
	'Message' => 'Message',
	'Notify To' => '',
	'Parallel' => 'Parallèle',
	'Port' => 'Port',
	'Rsync Additional Options' => 'Options rsync aditionnelles',
	'Rsync Destination' => 'Répertoire de destination',
	'Rsync' => 'Rsync',
	'Scheduled' => 'Planifiée',
	'Site Path' => 'Chemin du site',
	'Start Date' => 'Date de démarrage',
	'Start Directory' => 'Répertoire de départ',
	'Start Time' => 'Horaire de démarrage',
	'Success' => 'Succès',
	'Suspended' => '',
	'Sync Logs' => 'Logs de synchronisation',
	'Sync Result' => 'Résultat de synchronisation',
	'Sync Type' => 'Type de synchronisation',
	'Trigger' => 'Événement',
	'[_1] in [_2]: [_3]' => '[_1] dans [_2] : [_3]',
	q{Showing only ID: [_1]} => q{Afficher seulement l'ID : [_1]},

## addons/Sync.pack/lib/MT/SyncQueue.pm
	'Sync Queue' => '', # Translate - New

## addons/Sync.pack/lib/MT/SyncSetting.pm
	'Sync settings' => 'Paramètres de synchronisation',

## addons/Sync.pack/lib/MT/SyncStatus.pm
	'Sync Status' => '', # Translate - New

## addons/Sync.pack/lib/MT/Worker/ContentsSync.pm
	', Error: [_1]' => '',
	'Date: [_1], Blog: [_2]' => '',
	'Date: [_1], Website: [_2]' => '',
	'Failed to Synchronization([_1]) with an external server([_2]).' => 'Impossible de synchroniser ([_1]) avec un serveur externe ([_2]).',
	'Failed to insert a new job for ([_1])' => '',
	'Sync setting # [_1] not found.' => 'Paramètre de synchronisation # [_1] introuvable.',
	'Sync setting ([_1]) is being processed already.' => '',
	'Synchronization has successfully suspended.' => '',
	'Synchronization([_1]) with an external server([_2]) has successfully finished.' => '',
	'Synchronization([_1]) with an external server([_2]) has successfully resumed.' => '',
	'Synchronization([_1]) with an external server([_2]) has successfully started.' => '',
	'Synchronization([_1]) with an external server([_2]) has successfully suspended.' => '',
	q{Failed to save sync list. (ID:'[_1]')} => q{Impossible de sauvegarder la liste de synchronisation. (ID:'[_1]')},
	q{Synchronization has successfully finished.} => q{La synchronisation s'est correctement terminée.},

## addons/Sync.pack/lib/Sync/App/CMS.pm
	'Deleting sync file list failed "[_1]": [_2]' => 'La suppression de la liste des fichiers à synchroniser a échoué "[_1]" : [_2]',
	'Immediate sync job for [_1] is registered by [_2]' => '',
	'Permission denied: [_1]' => 'Autorisation refusée : [_1]',
	'Save failed: [_1]' => 'Échec de la sauvegarde : [_1]',
	'Saving sync settings failed: [_1]' => 'La sauvegarde des paramètres de synchronisation a échoué : [_1]',
	'The previous synchronization file list has been cleared. [_1] by [_2].' => 'La précédente liste des fichiers à synchroniser a été supprimée. [_1] par [_2].',
	'The sync setting with the same name already exists.' => 'Un paramètre de synchronisation avec le même nom existe déjà.',
	'[_1] (copy)' => '', # Translate - New
	q{An error occurred while attempting to connect to the FTP server '[_1]': [_2]} => q{Une erreur est survenue lors de la connexion avec le serveur FTP '[_1]' : [_2]},
	q{An error occurred while attempting to retrieve the current directory from '[_1]': [_2]} => q{}, # Translate - New
	q{An error occurred while attempting to retrieve the list of directories from '[_1]': [_2]} => q{}, # Translate - New
	q{Error saving Sync Setting. No response from FTP server '[_1]'.} => q{}, # Translate - New
	q{Queued items for destination '[_1]' is removed by [_2].} => q{},
	q{Sync setting '[_1]' (ID: [_2]) deleted by [_3].} => q{Paramètre de synchronisation '[_1]' (ID : [_2]) supprimé par [_3].},
	q{Sync setting '[_1]' (ID: [_2]) edited by [_3].} => q{Paramètre de synchronisation '[_1]' (ID : [_2]) édité par [_3].},
	q{Synchronization log for blog '[_1]' (ID:[_2]) reset by '[_3]'} => q{},
	q{Synchronization log for website '[_1]' (ID:[_2]) reset by '[_3]'} => q{},
	q{Synchronization log reset by '[_1]'} => q{Log de synchronisation réinitialisé par '[_1]'},
	q{Synchronization status information for destination '[_1]' is removed by [_2].} => q{},

## addons/Sync.pack/lib/Sync/Upgrade.pm
	'Removing all jobs of contents sync...' => 'Suppression des tâches de synchronisation de contenu...',

## addons/Sync.pack/tmpl/cfg_contents_sync.tmpl
	'@' => '@',
	'A duplicate destination name exists.' => 'Le nom de destination existe déjà.',
	'Add destination' => 'Ajouter une destination',
	'Are you sure you want to clear synchronization queue of this destination?' => '',
	'Are you sure you want to clear synchronization status of this destination?' => '',
	'Are you sure you want to clear the previous synchronization file list?' => 'Vouslez-vous vraiment supprimer la précédente liste des fichiers à synchroniser ?',
	'Are you sure you want to register immediate sync job?' => '',
	'Are you sure you want to remove this settings?' => 'Voulez-vous vraiment supprimer ces paramètres ?',
	'Clear synchronization queue' => '',
	'Clear synchronization status' => '',
	'Clear the previous synchronization file list' => 'Vider la précédente liste des fichiers à synchroniser',
	'Contents Sync Settings' => 'Paramètres de synchronisation des contenus',
	'Contents sync settings has been saved.' => 'Les paramètres de synchronisation ont été sauvegardés.',
	'Copy this sync setting' => 'Copier ce paramètre de synchronisation',
	'Deleting...' => 'Suppression…',
	'Destination ID' => '',
	'Destination name should be shorter than [_1] characters.' => 'Le nom de destination devrait faire moins de [_1] caractères.',
	'Destinations' => 'Destinations',
	'Do not send .htaccess and .htpasswd file' => 'Ne pas envoyer les fichiers .htaccess et .htpasswd',
	'Enable SSL' => 'Activer SSL',
	'Immediate sync job is being registered. This job will be executed in next run-periodic-tasks execution.' => '',
	'Invalid date.' => 'Date invalide.',
	'Invalid time.' => 'Temps invalide.',
	'Loading...' => 'Chargement...',
	'OK' => 'OK',
	'One or more templates are set to the Dynamic Publishing. Dynamic Publishing may not work properly on the destination server.' => 'Un ou plusieurs gabarits sont en publication dynamique. La publication dynamique peut ne pas fonctionner correctement sur le serveur distant.',
	'Please select a sync type.' => 'Sélectionnez un type de synchronisation.',
	'Recipient for Notification' => 'Destinataire des notifications',
	'Register immediate sync job' => '',
	'Remove queued items to abort synchronization.' => '',
	'Remove synchronization status information.' => '',
	'SSL is not available.' => '',
	'SSL' => 'SSL',
	'Save changes to these settings (s)' => 'Enregistrer les modifications de ces paramètres (s)',
	'Sync Date' => 'Date de synchronisation',
	'Sync Type *' => 'Type de synchronisation *',
	'Sync all files' => 'Synchroniser tous les fichiers',
	'Sync name is required.' => 'Un nom de synchronisation est requis.',
	'Sync name should be shorter than [_1] characters.' => 'Le nom de synchronisation doit faire moins de [_1] caractères.',
	'Sync setting is not saved yet' => '',
	'Sync type not selected' => 'Type de synchronisation non sélectionné',
	'The previous synchronization file list has been cleared.' => 'La précédente liste des fichiers à synchroniser a été vidée.',
	'The sync date must be in the future.' => 'La date de synchronisation doit être dans le futur.',
	'The sync settings has been copied but not saved yet.' => 'Les paramètres de synchronisation ont été copiés mais pas encore sauvegardés.',
	'This destination has been synchronized before.' => '',
	'This destination has never been synchronized.' => '',
	'This destination is queued to be synchronized.' => '',
	'This destination will be fully synchronized next time.' => '',
	'View sync log' => 'Voir le log de synchronisation',
	'You must make one or more destination settings.' => 'Vous devez créer au moins une destination.',
	'htaccess' => 'htaccess',
	q{After a sync job is executed, an email notification will be sent to the user who registered the job, and to the system administrator (default) or the recipient specified above.} => q{Après qu'une synchronisation a été effectuée, un e-mail de notification sera envoyé à l'utilisateur qui l'a déclenchée, et à l'administrateur système (par défaut) ou le destinataire spécifié ci-dessus.},
	q{Queued items for destination '[_1]' has been removed} => q{},
	q{Receive only error notification} => q{Ne recevoir que les notifications d'erreur.},
	q{Sync status information for destination '[_1]' has been removed} => q{},

## addons/Sync.pack/tmpl/mail_contents_sync.tmpl
	'Executer' => 'Éxecuter',
	'Site' => '',

## default_templates/archive_index.mtml
	'Banner Footer' => 'Bloc du pied de page',
	'HTML Head' => 'Entête HTML',
	q{Banner Header} => q{Bloc de l'entête},

## default_templates/comment_throttle.mtml
	'A visitor to your blog [_1] has automatically been banned by adding more than the allowed number of comments in the last [_2] seconds.' => 'Un visiteur de votre blog [_1] a été automatiquement banni après avoir publié une quantité de commentaires supérieure à la limite établie au cours des dernières [_2] secondes.',
	'This was done to prevent a malicious script from overwhelming your weblog with comments. The banned IP address is' => 'Ceci a été fait pour prévenir un assaut de commentaires sur votre blog par un script malicieux.',
	q{If this was an error, you can unblock the IP address and allow the visitor to add it again by logging in to your Movable Type installation, choosing Blog Config - IP Banning, and deleting the IP address [_1] from the list of banned addresses.} => q{En cas d'erreur, vous pouvez débloquer l'adresse IP et permettre au visiteur de la rajouter et se reconnectant à votre installation Movable Type. Choisir Configuration du blog - Blocage IP, et en supprimant l'adresse IP [_1] de la liste des adresses bloquées.},

## default_templates/commenter_confirm.mtml
	'For your security and to prevent fraud, we ask you to confirm your account and email address before continuing. Once your account is confirmed, you will immediately be allowed to comment on [_1].' => 'Pour votre sécurité et lutter contre la fraude, nous vous prions de confirmer votre compte et adresse e-mail avant de continuer. Une fois votre compte confirmé, vous pourrez commenter immédiatement sur [_1].',
	'Thank you for registering an account to comment on [_1].' => 'Merci de vous être enregistré pour commenter sur [_1].',
	q{If you did not make this request, or you don't want to register for an account to comment on [_1], then no further action is required.} => q{Si vous n'êtes pas à l'origine de cette demande, ou si vous ne souhaitez pas vous enregistrer pour commenter sur [_1], alors aucune action n'est nécessaire.},
	q{To confirm your account, please click on the following URL, or cut and paste this URL into a web browser:} => q{Veuillez cliquer sur le lien suivant ou copier/coller l'adresse URL dans un navigateur :},

## default_templates/commenter_notify.mtml
	q{This email is to notify you that a new user has successfully registered on the blog '[_1]'. Here is some information about this new user.} => q{Un nouvel utilisateur s\'est enregistré sur le blog '[_1]'. Voici quelques informations sur ce nouvel utilisateur.},

## default_templates/entry.mtml
	'Trackbacks' => 'TrackBacks',

## default_templates/lockout-ip.mtml
	'IP Address: [_1]' => 'Adresse IP : [_1]',
	'Recovery: [_1]' => 'Déverrouiller : [_1]',
	q{This email is to notify you that an IP address has been locked out.} => q{Cet e-mail est pour vous notifier qu'une adresse IP a été verrouillée.},

## default_templates/lockout-user.mtml
	'Display Name: [_1]' => 'Nom affiché : [_1]',
	'If you want to permit this user to participate again, click the link below.' => 'Si voulez permettre à cet utilisateur de participer à nouveau, cliquez sur le lien ci-dessous.',
	q{This email is to notify you that a Movable Type user account has been locked out.} => q{Cet e-mail est pour vous notifier qu'un compte Movable Type a été verrouillé.},

## default_templates/new-comment.mtml
	'Approve comment:' => 'Approuver le commentaire :',
	'Commenter IP address: [_1]' => 'Adresse IP du commentateur : [_1]',
	'Commenter URL: [_1]' => 'URL du commentateur : [_1]',
	'Commenter email address: [_1]' => 'Adresse e-mail du commentateur :  [_1]',
	'Commenter name: [_1]' => 'Nom du commentateur : [_1]',
	'Edit comment:' => 'Éditer le commentaire :',
	'Report the comment as spam:' => 'Signaler le commentaire comme spam :',
	'View comment:' => 'Voir le commentaire :',
	q{A new comment has been posted on your site '[_1]', on entry #[_2] ([_3]).} => q{Un commentaire en attente de modération a été posté sur votre site '[_1]', sur la note #[_2] ([_3]).},
	q{A new comment has been posted on your site '[_1]', on page #[_2] ([_3]).} => q{Un commentaire en attente de modération a été posté sur votre site '[_1]', sur la page #[_2] ([_3]).},
	q{An unapproved comment has been posted on your site '[_1]', on entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.} => q{Un commentaire en attente de modération a été posté sur votre site '[_1]', sur la note #[_2] ([_3]). Vous devez l'approuver pour qu'il apparaisse sur votre site.},
	q{An unapproved comment has been posted on your site '[_1]', on page #[_2] ([_3]). You need to approve this comment before it will appear on your site.} => q{Un commentaire en attente de modération a été posté sur votre site '[_1]', sur la page #[_2] ([_3]). Vous devez l'approuver pour qu'il apparaisse sur votre site.},

## default_templates/new-ping.mtml
	'Approve TrackBack' => 'Approuver le TrackBack',
	'Blog' => 'Blog',
	'Edit TrackBack' => 'Éditer les TrackBacks',
	'Excerpt' => 'Extrait',
	'IP address' => 'Adresse IP',
	'Report TrackBack as spam' => 'Signaler le TrackBack comme spam',
	'View TrackBack' => 'Voir le TrackBack',
	q{A new TrackBack has been posted on your site '[_1]', on category #[_2] ([_3]).} => q{Un TrackBack en attente de modération a été posté sur votre site '[_1]', sur la catégorie #[_2] ([_3]).},
	q{A new TrackBack has been posted on your site '[_1]', on entry #[_2] ([_3]).} => q{Un TrackBack en attente de modération a été posté sur votre site '[_1]', sur la note #[_2] ([_3]).},
	q{A new TrackBack has been posted on your site '[_1]', on page #[_2] ([_3]).} => q{Un TrackBack en attente de modération a été posté sur votre site '[_1]', sur la page #[_2] ([_3]).},
	q{An unapproved TrackBack has been posted on your site '[_1]', on category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Un TrackBack en attente de modération a été posté sur votre site '[_1]', sur la catégorie #[_2] ([_3]). Vous devez l'approuver pour qu'il apparaisse sur votre site.},
	q{An unapproved TrackBack has been posted on your site '[_1]', on entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Un TrackBack en attente de modération a été posté sur votre site '[_1]', sur la note #[_2] ([_3]). Vous devez l'approuver pour qu'il apparaisse sur votre site.},
	q{An unapproved TrackBack has been posted on your site '[_1]', on page #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Un TrackBack en attente de modération a été posté sur votre site '[_1]', sur la page #[_2] ([_3]). Vous devez l'approuver pour qu'il apparaisse sur votre site.},

## default_templates/notify-entry.mtml
	'View page:' => 'Voir la page :',
	'[_1] Title: [_2]' => 'Titre du [_1] : [_2]',
	q{A new [lc,_3] entitled '[_1]' has been published to [_2].} => q{Une nouvelle [lc,_3] intitulée '[_1]' a été publiée sur [_2].},
	q{Message from Sender:} => q{Message de l'expéditeur :},
	q{You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:} => q{Vous recevez cet e-mail car vous avez demandé à recevoir les notifications de nouveau contenu sur [_1], ou l'auteur de la note a pensé que vous seriez intéressé. Si vous ne souhaitez plus recevoir ces e-mails, merci de contacter la personne suivante :},

## default_templates/recent_comments.mtml
	'<strong>[_1]:</strong> [_2] <a href="[_3]" title="full comment on: [_4]">read more</a>' => '<strong>[_1] :</strong> [_2] <a href="[_3]" title="commentaire complet sur : [_4]">lire la suite</a>',

## default_templates/recover-password.mtml
	'A request was made to change your Movable Type password. To complete this process click on the link below to select a new password.' => 'Une demande de réinitialisation de votre mot de passe Movable Type a été faite. Pour compléter cette demande, cliquez sur le lien ci-dessous pour choisir un nouveau mot de passe.',
	q{If you did not request this change, you can safely ignore this email.} => q{Si vous n'avez pas demandé ce changement, vous pouvez simplement ignorer cet e-mail.},

## default_templates/sidebar.mtml
	'2-column layout - Sidebar' => 'Mise en page à 2 colonnes - Barre latérale',
	'3-column layout - Primary Sidebar' => 'Mise en page à 3 colonnes - Première barre latérale',
	'3-column layout - Secondary Sidebar' => 'Mise en page à 3 colonnes - Seconde barre latérale',

## lib/MT.pm
	'AIM' => 'AIM',
	'An error occurred: [_1]' => 'Une erreur est survenue : [_1]',
	'Bad CGIPath config' => 'Mauvaise configuration CGIPath',
	'Bad LocalLib config ([_1]): [_2]' => 'Mauvaise configuration LocalLib ([_1]) : [_2]',
	'Bad ObjectDriver config' => 'Mauvaise configuration ObjectDriver',
	'Fourth argument to add_callback must be a CODE reference.' => 'Le quatrième argument de add_callback doit être une référence CODE.',
	'Google' => 'Google',
	'Hatena' => 'Hatena',
	'Hello, [_1]' => 'Bonjour, [_1]',
	'Hello, world' => 'Bonjour tout le monde',
	'Internal callback' => 'Callback interne',
	'Invalid priority level [_1] at add_callback' => 'Niveau de priorité invalide [_1] dans add_callback',
	'LiveJournal' => 'LiveJournal',
	'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Fichier de configuration manquant. Auriez-vous oublié de déplacer mt-config.cgi-original vers mt-config.cgi ?',
	'Movable Type default' => 'Valeur par défaut Movable Type',
	'OpenID' => 'OpenID',
	'Plugin error: [_1] [_2]' => 'Erreur de plugin : [_1] [_2]',
	'Powered by [_1]' => 'Motorisé par [_1]',
	'Two plugins are in conflict' => 'Deux plugins sont en conflit',
	'TypePad' => 'TypePad',
	'Unnamed plugin' => 'Plugin sans nom',
	'Version [_1]' => 'Version [_1]',
	'Vox' => 'Vox',
	'WordPress.com' => 'WordPress.com',
	'Yahoo! JAPAN' => 'Yahoo! Japon',
	'Yahoo!' => 'Yahoo!',
	'[_1] died with: [_2]' => '[_1] mort avec : [_2]',
	'http://www.movabletype.com/' => 'http://www.movabletype.com/',
	'http://www.movabletype.org/documentation/' => 'http://www.movabletype.org/documentation/',
	'livedoor' => 'livedoor',
	q{A Perl module required for Google ID commenter authentication is missing: [_1].} => q{Le module Perl nécessaire pour l'authentification de commentateur par Google ID est manquant : [_1].},
	q{Error while creating email: [_1]} => q{Erreur à la création de l'e-mail : [_1]},
	q{Got an error: [_1]} => q{Une erreur s'est produite : [_1]},
	q{If it is present, the third argument to add_callback must be an object of type MT::Component or MT::Plugin} => q{S'il est présent, le troisième argument de add_callback doit être un objet de type MT::Component ou MT::Plugin},
	q{Loading of blog '[_1]' failed: [_2]} => q{Le chargement du blog '[_1]' a échoué : [_2]},
	q{Loading template '[_1]' failed.} => q{Le chargement du template '[_1]' a échoué.},
	q{The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.} => q{Le module Perl nécessaire pour l'authentification OpenID (Digest::SHA1) est manquant.},

## lib/MT/AccessToken.pm
	q{AccessToken} => q{Clé d'accès},

## lib/MT/App.pm
	'A user with the same name already exists.' => 'Un utilisateur possédant ce nom existe déjà.',
	'Cannot load blog (ID:[_1])' => 'Impossible de charger le blog (ID:[_1])',
	'First Weblog' => 'Premier blog',
	'Internal Error: Login user is not initialized.' => 'Erreur interne : identifiant utilisateur non initialisé.',
	'Password should be longer than [_1] characters' => 'Le mot de passe doit faire plus de [_1] caractères',
	'Password should contain symbols such as #!$%' => 'Le mot de passe doit contenir des caractères spéciaux comme #!$%',
	'Password should include letters and numbers' => 'Le mot de passe doit être composé de lettres et de chiffres',
	'Password should include lowercase and uppercase letters' => 'Le mot de passe doit être composé de lettres en minuscule et majuscule',
	'Problem with this request: corrupt character data for character set [_1]' => 'Requête erronée : jeu de caractères corrompu [_1]',
	'Removed [_1].' => '[_1] supprimés.',
	'Text entered was wrong.  Try again.' => 'Le texte entré est invalide. Réessayez.',
	'The file you uploaded is too large.' => 'Le fichier téléchargé est trop lourd.',
	'This account has been deleted. Please see your Movable Type system administrator for access.' => 'Ce compte a été supprimé. Veuillez contacter votre administrateur Movable Type pour obtenir un accès.',
	'Unknown action [_1]' => 'Action inconnue [_1]',
	'Unknown error' => '', # Translate - New
	q{An error occurred while trying to process signup: [_1]} => q{Une erreur est survenue lors de l'enregistrement : [_1]},
	q{Blog '[_1]' (ID: [_2]) for user '[_3]' (ID: [_4]) has been created.} => q{Le blog '[_1]' (ID: [_2]) pour l'utilisateur '[_3]' (ID:[_4]) a été créé.},
	q{Email Address is required for password reset.} => q{L'adresse e-mail est requise pour la réinitialisation du mot de passe},
	q{Error assigning blog administration rights to user '[_1]' (ID: [_2]) for blog '[_3]' (ID: [_4]). No suitable blog administrator role was found.} => q{Erreur d'assignation des droits pour l'utilisateur '[_1]' (ID:[_2]) pour le blog '[_3]' (ID:[_4]). Aucun rôle d'administrateur adéquat n'a été trouvé.},
	q{Error loading blog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.} => q{Erreur de chargement #[_1] concernant la création de l'utilisateur. Veuillez vérifier vos paramètres NewUserTemplateBlogId.},
	q{Error loading website #[_1] for user provisioning. Check your NewUserefaultWebsiteId setting.} => q{Erreur lors du chargement du site web #[_1] pour la création de l'utilisateur. Vérifiez vos paramètres NewUserefaultWebsiteId.},
	q{Error provisioning blog for new user '[_1]' (ID: [_2]).} => q{Erreur de création du blog pour le nouvel utilisateur '[_1]' (ID:[_2]).},
	q{Error provisioning blog for new user '[_1]' using template blog #[_2].} => q{Erreur de création du blog pour le nouvel utilisateur '[_1]' utilisant le template #[_2].},
	q{Error sending mail: [_1]} => q{Erreur de l'envoi de l'e-mail : [_1]},
	q{Failed to open monitoring file that specified by IISFastCGIMonitoringFilePath directive '[_1]': [_2]} => q{Impossible d'ouvrir le fichier spécifié par la directive IISFastCGIMonitoringFilePath '[_1]' : [_2]},
	q{Failed to open pid file [_1]: [_2]} => q{Impossible d'ouvrir le fichier pid [_1] : [_2]},
	q{Failed to send reboot signal: [_1]} => q{Impossible d'envoyer un signal de redémarrage : [_1]},
	q{Invalid login attempt from user '[_1]'} => q{Tentative d'authentification invalide de l'utilisateur '[_1]'},
	q{New Comment Added to '[_1]'} => q{Nouveau commentaire ajouté à '[_1]'},
	q{Our apologies, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.} => q{Désolé mais vous n'avez pas la permission d'accéder aux blogs ou aux sites web de cette installation. Si vous pensez qu'il s'agit d'une erreur, veuillez contacter votre administrateur système Movable Type.},
	q{Password should not include your Username} => q{Le mot de passe ne doit pas être composé de votre nom d'utilisateur},
	q{Sorry, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.} => q{Désolé, mais vous n'avez pas l'autorisation d'accéder aux sites et blogs de cette installation. Si vous pensez qu'il s'agit d'une erreur, veuillez contacter votre administrateur Movable Type.},
	q{User '[_1]' (ID:[_2]) logged in successfully} => q{L'utilisateur '[_1]' (ID:[_2]) s'est identifié correctement},
	q{User '[_1]' (ID:[_2]) logged out} => q{L'utilisateur '[_1]' (ID:[_2]) s'est déconnecté},
	q{User requires display name.} => q{L'utilisateur doit avoir un nom public.},
	q{User requires password.} => q{L'utilisateur doit avoir un mot de passe.},
	q{User requires username.} => q{L'utilisateur doit avoir un nom d'utilisateur.},
	q{Warnings and Log Messages} => q{Mises en garde et entrées du journal d'activité},
	q{You did not have permission for this action.} => q{Vous n'avez pas la permission pour cette action.},

## lib/MT/App/ActivityFeeds.pm
	'All Comments' => 'Tous les commentaires',
	'All Entries' => 'Toutes les notes',
	'All Pages' => 'Toutes les pages',
	'All TrackBacks' => 'Tous les TrackBacks',
	'Error loading [_1]: [_2]' => 'Erreur lors du chargement [_1] : [_2]',
	'Movable Type Debug Activity' => 'Activité de débogage Movable Type',
	'Movable Type System Activity' => 'Activité du système Movable Type',
	'[_1] Activity' => '[_1] activité',
	'[_1] Comments' => '[_1] commentaires',
	'[_1] Entries' => '[_1] notes',
	'[_1] Pages' => '[_1] pages',
	'[_1] TrackBacks' => '[_1] TrackBacks',
	q{All Activity} => q{Toute l'activité},
	q{An error occurred while generating the activity feed: [_1].} => q{Une erreur est survenue lors de la génération du flux d'activité : [_1].},
	q{No permissions.} => q{Pas d'autorisations.},

## lib/MT/App/CMS.pm
	'Add Contact' => 'Ajouter un contact',
	'Add IP Address' => 'Ajouter une adresse IP',
	'Add Tags...' => 'Ajouter des tags...',
	'Add a user to this [_1]' => 'Ajouter un utilisateur à ce [_1]',
	'Are you sure you want to remove all comments reported as spam?' => 'Voulez-vous vraiment supprimer tous les commentaires reportés comme spam ?',
	'Are you sure you want to remove all trackbacks reported as spam?' => 'Voulez-vous vraiment supprimer tous les TrackBacks reportés comme spam ?',
	'Asset' => 'Élément',
	'Assets' => 'Éléments',
	'Backup' => 'Sauvegarder',
	'Ban Commenter(s)' => 'Bannir ce commentateur',
	'Batch Edit Entries' => 'Modifier des notes par lot',
	'Batch Edit Pages' => 'Modifier les pages par lot',
	'Blog Stats' => 'Statistiques du blog',
	'Can verify SSL certificate, but verification is disabled.' => 'Le certificat SSL pourrait être vérifié mais la vérification est désactivée.',
	'Cannot verify SSL certificate.' => 'Impossible de vérifier le certificat SSL.',
	'Clone Blog' => 'Dupliquer le blog',
	'Clone Template(s)' => 'Cloner le(s) gabarit(s)',
	'Commenters' => 'Commentateurs',
	'Compose' => 'Rédiger',
	'Create Role' => 'Créer un rôle',
	'Delete all Spam comments' => 'Supprimer tous les commentaires marqués comme indésirables',
	'Delete all Spam trackbacks' => 'Supprimer tous les TrackBacks marqués comme indésirables',
	'Design' => 'Design',
	'Download Log (CSV)' => 'Télécharger le journal (CSV)',
	'Edit Template' => 'Modifier un gabarit',
	'Entries' => 'Notes',
	'Error during publishing: [_1]' => 'Erreur pendant la publication : [_1]',
	'Export Entries' => 'Exporter des notes',
	'Export Theme' => 'Exporter le thème',
	'Feedback' => 'Feedback',
	'Folders' => 'Répertoires',
	'General' => 'Général',
	'Grant Permission' => 'Ajouter une autorisation',
	'IP Banning' => 'Blockage IP',
	'Import Entries' => 'Importer des notes',
	'Listing Filters' => 'Lister les filtres',
	'Mark as Spam' => 'Considérer comme spam',
	'Movable Type News' => 'Actualités Movable Type',
	'Move blog(s) ' => 'Déplacer le(s) blog(s)',
	'No such blog [_1]' => 'Aucun blog ne porte le nom [_1]',
	'None' => 'Aucun',
	'Notification Dashboard' => 'Tableau des notifications',
	'Permissions' => 'Autorisations',
	'Personal Stats' => 'Statistiques personnelles',
	'Please contact your Movable Type system administrator.' => 'Veuillez contacter votre administrateur système Movable Type',
	'Plugins' => 'Plugins',
	'Profile' => 'Profil',
	'Publish Template(s)' => 'Publier le(s) gabarit(s)',
	'Publish' => 'Publier',
	'Recover Password(s)' => 'Récupérer le mot de passe',
	'Refresh Template(s)' => 'Actualiser le(s) gabarit(s)',
	'Refresh Templates' => 'Réactualiser les gabarits',
	'Registration' => 'Enregistrement',
	'Remove Spam status' => 'Ne plus considérer comme spam',
	'Remove Tags...' => 'Enlever des tags...',
	'Restore' => 'Restaurer',
	'Roles' => 'Rôles',
	'Search &amp; Replace' => 'Chercher &amp; remplacer',
	'Settings' => 'Paramètres',
	'Site Stats' => 'Statistiques du site',
	'System Information' => 'Informations système',
	'Tags to add to selected assets' => 'Tags à ajouter aux éléments sélectionnés',
	'Tags to add to selected entries' => 'Tags à ajouter aux notes sélectionnées',
	'Tags to add to selected pages' => 'Tags à ajouter aux pages sélectionnées',
	'Tags to remove from selected assets' => 'Tags à supprimer les éléments sélectionnés',
	'Tags to remove from selected entries' => 'Tags à enlever des notes sélectionnées',
	'Tags to remove from selected pages' => 'Tags à supprimer des pages sélectionnées',
	'Templates' => 'Gabarits',
	'Themes' => 'Thèmes',
	'Tools' => 'Outils',
	'Trust Commenter(s)' => 'Donner le statut fiable à ce commentateur',
	'Unban Commenter(s)' => 'Lever le bannissement de ce commentateur',
	'Unknown object type [_1]' => 'Objet de type [_1] inconnu',
	'Unlock' => 'Déverrouiller',
	'Unpublish Comment(s)' => 'Annuler la publication de ce (ou ces) commentaire(s)',
	'Unpublish Entries' => 'Annuler la publication',
	'Unpublish Pages' => 'Dépublier les pages',
	'Unpublish TrackBack(s)' => 'Annuler la publication de ce (ou ces) TrackBacks(s)',
	'Untrust Commenter(s)' => 'Retirer le statut fiable à ce commentateur',
	'Use Publishing Profile' => 'Utiliser un profil de publication',
	'Web Services' => 'Services web',
	'Website' => 'Site web',
	'Websites and Blogs' => 'Sites web et blogs',
	'Websites' => 'Sites web',
	'Widgets' => 'Widgets',
	'You should remove "SSLVerifyNone 1" in mt-config.cgi.' => 'Vous devriez supprimer "SSLVerifyNone 1" dans mt-config.cgi.',
	'_WARNING_DELETE_USER' => 'Supprimer un utilisateur est une action définitive qui va rendre des notes orphelines. Si vous souhaitez supprimer un utilisateur ou lui retirer ses accès nous vous recommandons de désactiver son compte. Voulez-vous vraiment supprimer cet utilisateur ?',
	'_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' => 'Cette action rétablira les gabarits par défaut pour le(s) blog(s) sélectionné(s). Voulez-vous vraiment rafraîchir les gabarits de ce(s) blog(s) ?',
	'entry' => 'note',
	q{Activity Log} => q{Journal d'activité},
	q{Address Book} => q{Carnet d'adresses},
	q{An image processing toolkit, often specified by the ImageDriver configuration directive, is not present on your server or is configured incorrectly. A toolkit must be installed to ensure proper operation of the userpics feature. Please install Graphics::Magick, Image::Magick, NetPBM, GD, or Imager, then set the ImageDriver configuration directive accordingly.} => q{Un outil de traitement d'image, souvent spécifié par la directive de configuration ImageDriver, n'est pas présent sur votre serveur ou n'est pas configuré correctement. Un outil doit être installé pour permettre l'utilisation correcte de la fonctionnalité des images d'utilsateurs. Veuillez installer Graphics::Magick Image::Magick, NetPBM, GD ou Imager, puis spécifiez la directive de configuration ImageDriver.},
	q{Are you sure you want to reset the activity log?} => q{Voulez-vous vraiment réinitialiser le journal d'activité ?},
	q{Clear Activity Log} => q{Effacer le journal d'activité},
	q{Download Address Book (CSV)} => q{Télécharger le carnet d'adresses (CSV)},
	q{ImageDriver is not configured.} => q{ImageDriver n'est pas configuré.},
	q{Movable Type was unable to write to its 'support' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.} => q{Movable Type n'a pas pu écrire dans son répertoire 'support'. Merci de créer un répertoire à cet endroit : [_1], et de lui ajouter des droits qui permettent au serveur web d'écrire dedans.},
	q{Please install Mozilla::CA module. Writing "SSLVerifyNone 1" in mt-config.cgi can hide this warning, but this is not recommended.} => q{Veuillez installer le module Mozilla::CA. Ajouter "SSLVerifyNone 1" dans mt-config.cgi masque cet avertissement, mais ce n'est pas recommandé.},
	q{Revoke Permission} => q{Révoquer l'autorisation},
	q{The System Email Address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events. Please confirm your <a href="[_1]">settings.</a>} => q{L'adresse e-mail du système est utilisée comme entête de l'expéditeur de chaque e-mail envoyé par Movable Type (récupération de mot de passe, enregistrement de commentateur, notification de commentaire ou de TrackBack, blocage d'un utilisateur ou d'une adresse IP, et d'autres événements mineurs). Veuillez confirmer vos <a href="[_1]">paramètres</a>.},
	q{The support directory is not writable.} => q{Le répertoire support n'est pas ouvert en écriture.},
	q{_WARNING_DELETE_USER_EUM} => q{Supprimer un utilisateur est une action définitive qui va rendre des notes orphelines. Si vous voulez retirer un utilisateur ou supprimer ses accès nous vous recommandons de désactiver son compte. Voulez-vous vraiment supprimer cet utilisateur ? Attention, il pourra se créer un nouvel accès s'il existe encore dans le répertoire externe.},
	q{_WARNING_PASSWORD_RESET_MULTI} => q{Vous êtes sur le point d'envoyer des e-mails pour permettre aux utilisateurs sélectionnés de réinitialiser leur mot de passe. Voulez-vous continuer ?},

## lib/MT/App/CMS/Common.pm
	q{Some websites were not deleted. You need to delete blogs under the website first.} => q{Quelques sites n'ont pas été supprimés. Vous devez supprimer les blogs de ces sites avant de supprimer ces sites.},

## lib/MT/App/Comments.pm
	'All required fields must be populated.' => 'Tous les champs requis doivent être renseignés.',
	'Cannot load template' => 'Impossible de charger le gabarit',
	'Comment on "[_1]" by [_2].' => 'Commentaire sur « [_1] » par [_2].',
	'Comment save failed with [_1]' => 'La sauvegarde du commentaire a échoué [_1]',
	'Comment text is required.' => 'Le texte de commentaire est requis.',
	'Commenter profile has successfully been updated.' => 'Le profil du commentateur a été modifié avec succès.',
	'Comments are not allowed on this entry.' => 'Les commentaires ne sont pas autorisés sur cette note.',
	'IP Banned Due to Excessive Comments' => 'IP bannie pour cause de commentaires excessifs',
	'Invalid entry ID provided' => 'ID de note fourni invalide',
	'No entry_id' => 'Aucun entry_id',
	'No such comment' => 'Pas de tel commentaire',
	'Publishing failed: [_1]' => 'La publication a échoué : [_1]',
	'Registered User' => 'Utilisateur enregistré',
	'Thanks for the confirmation.  Please sign in to comment.' => 'Merci pour la confirmation. Merci de vous identifier pour commenter.',
	'You are trying to redirect to external resources. If you trust the site, please click the link: [_1]' => 'Vous tentez de rediriger vers une resource extérieure. Si vous faites confiance à ce site, cliquez sur ce lien : [_1]',
	'Your confirmation has expired. Please register again.' => 'Votre confirmation a expirée. Veuillez vous enregistrer à nouveau.',
	'_THROTTLED_COMMENT' => 'Afin de réduire les abus, nous avons activé une fonction obligeant les auteurs de commentaire à attendre quelques instants avant de publier un autre commentaire. Veuillez attendre quelques instants avant de publier un autre commentaire. Merci.',
	q{Commenter '[_1]' (ID:[_2]) has been successfully registered.} => q{Le commentateur '[_1]' (ID:[_2]) a été enregistré avec succès.},
	q{Commenter profile could not be updated: [_1]} => q{Le profil du commentateur n'a pu être modifié : [_1]},
	q{IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.} => q{l'IP [_1] a été bannie car elle a envoyé plus de 8 commentaires en  [_2] seconds.},
	q{Invalid URL '[_1]'} => q{URL invalide '[_1]'},
	q{Invalid email address '[_1]'} => q{Adresse e-mail invalide '[_1]'},
	q{Name and E-mail address are required.} => q{Le nom et l'adresse e-mail sont requis.},
	q{No entry was specified; perhaps there is a template problem?} => q{Aucune note n'a été spécifiée, peut-être y a-t-il un problème de gabarit ?},
	q{No id} => q{Pas d'id},
	q{No such entry '[_1]'.} => q{Aucune note '[_1]'.},
	q{Registration is required.} => q{L'inscription est requise.},
	q{Somehow, the entry you tried to comment on does not exist} => q{Il semble que la note que vous souhaitez commenter n'existe pas},
	q{Successfully authenticated, but signing up is not allowed.  Please contact your Movable Type system administrator.} => q{Authentification réussie, mais l'enregistrement est interdit. Veuillez contacter votre administrateur Movable Type.},

## lib/MT/App/DataAPI.pm
	'[_1] must be a number.' => '[_1] doit être un nombre.',
	'[_1] must be an integer and between [_2] and [_3].' => '_1] doit être un entier entre [_2] et [_3].',

## lib/MT/App/Search.pm
	'Failed to cache search results.  [_1] is not available: [_2]' => 'Impossible de cacher les résultats de recherche. [_1] est indisponible : [_2]',
	'Invalid [_1] parameter.' => 'Paramètre [_1] invalide',
	'Invalid format: [_1]' => 'Format invalide : [_1]',
	'Invalid query: [_1]' => 'Requête non valide : [_1]',
	'Invalid type: [_1]' => 'Type invalide : [_1]',
	'Invalid value: [_1]' => 'Valeur invalide : [_1]',
	'No column was specified to search for [_1].' => 'Aucune colonne spécifiée à la recherche de [_1].',
	'No such template' => 'Aucun gabarit trouvé',
	'Output file cannot be of the type asp or php' => 'Le fichier de sortie ne peut pas être de type asp ou php',
	'The search you conducted has timed out.  Please simplify your query and try again.' => 'La recherche que vous avez effectuée a expiré. Merci de simplifier votre requête et réessayer.',
	'Unsupported type: [_1]' => 'Type non supporté : [_1]',
	'You must pass a valid archive_type with the template_id' => 'Vous devez indiquer un archive_type valide avec le template_id',
	'template_id cannot refer to a global template' => 'template_id ne peut pas représenter un gabarit global',
	q{Filename extension cannot be asp or php for these archives} => q{L'extension de fichier ne peut pas être asp ou php pour ces archives},
	q{Invalid archive type} => q{Type d'archive non valide},
	q{No alternate template is specified for template '[_1]'} => q{Aucun gabarit alternatif n'est spécifié pour le gabarit '[_1]'},
	q{Opening local file '[_1]' failed: [_2]} => q{L'ouverture du fichier local '[_1]' a échoué : [_2]},
	q{Search: query for '[_1]'} => q{Recherche : requête pour '[_1]'},
	q{Template must be a main_index for Index archive type} => q{Le gabarit doit être un main_index pour une archive d'index},
	q{Template must be an entry_listing for non-Index archive types} => q{Le gabarit doit être un entry_listing pour les gabarits d'archive n'étant pas des index.},

## lib/MT/App/Search/Legacy.pm
	'A search is in progress. Please wait until it is completed and try again.' => 'Une recherche est en cours. Veuillez en attendre la fin avant de recommencer.',
	'File not found: [_1]' => 'Fichier introuvable : [_1]',
	'Publishing results failed: [_1]' => 'Échec de la publication des résultats : [_1]',
	'Search failed. Invalid pattern given: [_1]' => 'Échec de la recherche. Requête invalide : [_1]',
	'Search failed: [_1]' => 'Échec de la recherche : [_1]',
	'Search: new comment search' => 'Recherche : recherche de nouveaux commentaires',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearch fonctionne avec MT::App::Search.',

## lib/MT/App/Trackback.pm
	'This TrackBack item is disabled.' => 'Cet élément TrackBack est désactivé.',
	'This TrackBack item is protected by a passphrase.' => 'Cet élément de TrackBack est protégé par un mot de passe.',
	'TrackBack on "[_1]" from "[_2]".' => 'TrackBack sur "[_1]" provenant de "[_2]".',
	'Trackback pings must use HTTP POST' => 'Les Pings TrackBack doivent utiliser HTTP POST',
	'You are sending TrackBack pings too quickly. Please try again later.' => 'Vous envoyez des pings TrackBack trop rapidement. Veuillez réessayer plus tard.',
	'You need to provide a Source URL (url).' => 'Vous devez fournir une URL source (url).',
	q{Cannot create RSS feed '[_1]': } => q{Impossible de créer le flux RSS '[_1]' : },
	q{Invalid TrackBack ID '[_1]'} => q{L'ID de TrackBack '[_1]' est invalide},
	q{Invalid entry ID '[_1]'} => q{ID de note '[_1]' invalide},
	q{New TrackBack ping to '[_1]'} => q{Nouveau TrackBack vers '[_1]'},
	q{New TrackBack ping to category '[_1]'} => q{Nouveau TrackBack vers la catégorie '[_1]'},
	q{TrackBack ID (tb_id) is required.} => q{L'ID de TrackBack (tb_id) est requis.},
	q{TrackBack on category '[_1]' (ID:[_2]).} => q{TrackBack sur la catégorie '[_1]' (ID:[_2]).},
	q{You are not allowed to send TrackBack pings.} => q{You n'êtes pas autorisé à envoyer des pings TrackBack.},
	q{You must define a Ping template in order to display pings.} => q{Vous devez définir un gabarit d'affichage Ping pour les afficher.},

## lib/MT/App/Upgrader.pm
	'Both passwords must match.' => 'Les deux mots de passe doivent être identiques.',
	'Invalid session.' => 'Session invalide.',
	'Movable Type has been upgraded to version [_1].' => 'Movable Type a été mis à jour en version [_1].',
	'No permissions. Please contact your Movable Type administrator for assistance with upgrading Movable Type.' => 'Sans permission. Veuillez contacter votre administrateur Movable Type pour la mise à jour de Movable Type.',
	'You must supply a password.' => 'Vous devez indiquer un mot de passe.',
	q{Could not authenticate using the credentials provided: [_1].} => q{Ne peut pas s'identifier en utilisant les identifiants communiqués : [_1].},
	q{The 'Website Root' provided below is not allowed} => q{La 'Racine du site web' fournie ci-dessous est interdite},
	q{The 'Website Root' provided below is not writable by the web server.  Change the ownership or permissions on this directory, then click 'Finish Install' again.} => q{La 'Racine du site web' fournie ci-dessous n'est pas accessible en écriture pour le serveur web. Changez la propriété ou les permissions sur le serveur puis recliquez sur 'Terminer l'installation'.},

## lib/MT/App/Wizard.pm
	'An error occurred while trying to connect to the database.  Check the settings and try again.' => 'Une erreur est survenue lors de la connexion à la base de données. Vérifiez les paramètres et réessayez.',
	'DBI is required to work with most supported databases.' => 'DBI est nécessaire pour fonctionner avec la plupart des bases de données supportées.',
	'Digest::SHA is required in order to provide enhanced protection of user passwords.' => 'Digest::SHA est requis pour améliorer la protection des mots de passe des utilisateurs.',
	'HTML::Parser is optional; It is needed if you want to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'HTML::Parser est optionnel. Il est nécessaire si vous souhaitez utiliser le système de TrackBack, le ping weblogs.com ou le ping des mises à jour récentes MT.',
	'Net::SMTP is required in order to send mail using an SMTP server.' => 'Net::SMTP est nécessaire pour envoyer des e-mails via un serveur SMTP.',
	'Please select a database from the list of available databases and try again.' => 'Veuillez choisir une base de données parmi celles disponibles dans la liste, et réessayez.',
	'SMTP Server' => 'Serveur SMTP',
	'Sendmail' => 'Sendmail',
	'The [_1] database driver is required to use [_2].' => 'Le driver de base de données [_1] est requis pour utiliser [_2].',
	'The [_1] driver is required to use [_2].' => 'Le pilote [_1] est requis pour utiliser [_2].',
	'This is the test email sent by your new installation of Movable Type.' => 'Ceci est un e-mail de test envoyé par votre nouvelle installation Movable Type.',
	'This module accelerates comment registration sign-ins.' => 'Ce module accélère les enregistrements des auteurs de commentaire.',
	'This module and its dependencies are required in order to support CRAM-MD5, DIGEST-MD5 or LOGIN SASL mechanisms.' => 'Ce module et ses dépendances sont requis pour utiliser les mécanismes CRAM-MD5, DIGEST-MD5 ou LOGIN SASL.',
	'This module and its dependencies are required to run Movable Type under psgi.' => 'Ce module et ses dépendances sont nécessaires pour faire fonctionner Movable Type en mode PSGI.',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Ce module est nécessaire si vous souhaitez pouvoir créer des vignettes pour les images envoyées.',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Ce module est nécessaire si vous voulez pouvoir écraser les fichiers existants lorsque vous envoyez un nouveau fichier.',
	'This module is needed to encode special characters, but this feature can be turned off using the NoHTMLEntities option in mt-config.cgi.' => 'Ce module est nécessaire pour encoder les caractères spéciaux, mais cette option peut être désactivée en utilisant NoHTMLEntities dans mt-config.cgi.',
	'This module is required by certain MT plugins available from third parties.' => 'Ce module est nécessaire pour certains plugins MT disponibles auprès de partenaires.',
	'This module is required by mt-search.cgi if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'Ce module est nécessaire pour mt-search.cgi si vous utilisez Movable Type sur une version de Perl supérieure à 5.8.',
	'This module is required for Google Analytics site statistics and for verification of SSL certificates.' => 'Ce module est requis pour les statistiques Google Analytics ainsi que pour la vérification des certificats SSL.',
	'This module is required for XML-RPC API.' => 'Ce module est nécessaire pour XML-RPC API.',
	'This module is required for executing run-periodic-tasks.' => 'Ce module est  requis pour exécuter run-periodic-tasks.',
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Ce module est nécessaire pour les envois de fichiers (pour déterminer la taille des images dans différents formats).',
	'This module is required in order to archive files in backup/restore operation.' => 'Ce module est nécessaire pour archiver les fichiers lors des opérations de sauvegarde/restauration.',
	'This module is required in order to compress files in backup/restore operation.' => 'Ce module est nécessaire pour compresser les fichiers lors des opérations de sauvegarde/restauration.',
	'This module is used by the Markdown text filter.' => 'Ce module est utilisé par le filtre de texte Markdown',
	'This module is used in a test attribute for the MTIf conditional tag.' => 'Ce module est utilisé dans attribut de test pour la balise conditionnelle MTIf.',
	q{CGI is required for all Movable Type application functionality.} => q{CGI est nécessaire pour toutes les fonctionnalités de l'application Movable Type.},
	q{Cache::File is required if you would like to be able to allow commenters to be authenticated by Yahoo! Japan as OpenID.} => q{Cache::File est requis si vous voulez permettre aux auteurs de commentaire l'utilisation de Yahoo! Japon comme moyen d'authentification OpenId.},
	q{File::Spec is required to work with file system path information on all supported operating systems.} => q{File::Spec est nécessaire pour gérer les chemins de fichiers sur les systèmes d'exploitation supportés.},
	q{IO::Socket::SSL is required in all of the SSL/TLS connection, such as Google Analytics site statistics or SMTP Auth over SSL/TLS.} => q{IO::Socket::SSL est requis pour les connexions SSL/TLS, telles que les statistiques Google Analytics ou l'authentification SMTP via SSL/TLS.},
	q{LWP::UserAgent is required for creating Movable Type configuration files using the installation wizard.} => q{LWP::UserAgent est requis pour que l'assistant de configuration puisse créer les fichiers de configuration de Movable Type.},
	q{List::Util is optional; It is needed if you want to use the Publish Queue feature.} => q{List::Util est optionnel. Il est nécessaire si vous souhaitez utiliser les possibilités de publications en mode file d'attente.},
	q{Net::SSLeay is required to use SMTP Auth over an SSL connection, or to use it with a STARTTLS command.} => q{Net::SSLeay est requis pour l'authentification SMTP via une connexion SSL ou par la commande STARTTLS.},
	q{Scalar::Util is required for initializing Movable Type application.} => q{Scalar::Util est requis pour initialiser l'application Movable Type.},
	q{Test email from Movable Type Configuration Wizard} => q{Test e-mail à partir de l'assistant de configuration de Movable Type},
	q{This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.} => q{Ce module et ses dépendances sont requises afin de permettre aux auteurs de commentaire d'être identifiés en utilisant les fournisseurs OpenID, comme LiveJournal.},
	q{This module and its dependencies are required in order to restore from a backup.} => q{Ce module et ses dépendances sont nécessaires pour restaurer les fichiers à partir d'une sauvegarde.},
	q{This module enables the use of the Atom API.} => q{Ce module active l'utilisation de l'API Atom.},
	q{This module is needed if you want to use the MT XML-RPC server implementation.} => q{Ce module est nécessaire si vous souhaitez utiliser l'implémentation serveur MT XML-RPC.},
	q{This module is needed if you would like to be able to use NetPBM as the image driver for MT.} => q{Ce module est nécessaire si vous souhaitez pouvoir utiliser NetPBM comme pilote d'image pour MT.},
	q{This module is needed to enable comment registration. Also, required in order to send mail via an SMTP Server.} => q{Ce module est requis pour permettre l'enregistrement des commentateurs, ainsi que pour envoyer des e-mails via un serveur SMTP.},
	q{This module is required for cookie authentication.} => q{Ce module est nécessaire pour l'authentification par cookies.},
	q{This module is required in order to decompress files in backup/restore operation.} => q{Ce module est nécessaire pour décompresser les fichiers lors d'une opération de sauvegarde/restauration.},
	q{This module is required in order to use memcached as caching mechanism used by Movable Type.} => q{Ce module est requis afin d'utiliser memcached comme méchanisme de cache utilisé par Movable Type.},
	q{XML::LibXML::SAX is optional; It is one of the modules required to restore a backup created in a backup/restore operation.} => q{XML::LibXML::SAX est optionnel. C'est l'un des modules nécessaires pour restaurer les fichiers à partir d'une sauvegarde.},
	q{XML::SAX::Expat is optional; It is one of the modules required to restore a backup created in a backup/restore operation.} => q{XML::SAX::Expat est optionnel. C'est l'un des modules nécessaires pour restaurer les fichiers à partir d'une sauvegarde.},
	q{XML::SAX::ExpatXS is optional; It is one of the modules required to restore a backup created in a backup/restore operation.} => q{XML::SAX::ExpatXS est optionnel. C'est l'un des modules nécessaires pour restaurer les fichiers à partir d'une sauvegarde.},
	q{YAML::Syck is optional; It is a better, fast and lightweight alternative to YAML::Tiny for YAML file handling.} => q{YAML::Syck est optionnel. C'est une meilleure alternative, plus rapide et plus légère, à YAML::Tiny pour le traitement des fichiers YAML.},

## lib/MT/ArchiveType/Author.pm
	'AUTHOR_ADV' => 'Auteur',
	'author/author-basename/index.html' => 'auteur/nomdebase-auteur/index.html',
	'author/author_basename/index.html' => 'auteur/nomdebase_auteur/index.html',

## lib/MT/ArchiveType/AuthorDaily.pm
	'AUTHOR-DAILY_ADV' => 'Par auteurs et jours',
	'author/author-basename/yyyy/mm/dd/index.html' => 'auteur/nomdebase-auteur/aaaa/mm/jj/index.html',
	'author/author_basename/yyyy/mm/dd/index.html' => 'auteur/nomdebase_auteur/aaaa/mm/jj/index.html',

## lib/MT/ArchiveType/AuthorMonthly.pm
	'AUTHOR-MONTHLY_ADV' => 'Par auteurs et mois',
	'author/author-basename/yyyy/mm/index.html' => 'auteur/nomdebase-auteur/aaaa/mm/index.html',
	'author/author_basename/yyyy/mm/index.html' => 'auteur/nomdebase_auteur/aaaa/mm/index.html',

## lib/MT/ArchiveType/AuthorWeekly.pm
	'AUTHOR-WEEKLY_ADV' => 'Par auteurs et semaines',
	'author/author-basename/yyyy/mm/day-week/index.html' => 'auteur/nomdebase-auteur/aaaa/mm/jour-semaine/index.html',
	'author/author_basename/yyyy/mm/day-week/index.html' => 'auteur/nomdebase_auteur/aaaa/mm/jour-semaine/index.html',

## lib/MT/ArchiveType/AuthorYearly.pm
	'AUTHOR-YEARLY_ADV' => 'Par auteurs et années',
	'author/author-basename/yyyy/index.html' => 'auteur/nomdebase-auteur/aaaa/index.html',
	'author/author_basename/yyyy/index.html' => 'auteur/nomdebase_auteur/aaaa/index.html',

## lib/MT/ArchiveType/Category.pm
	'CATEGORY_ADV' => 'Catégorie',
	'category/sub-category/index.html' => 'categorie/sous-categorie/index.html',
	'category/sub_category/index.html' => 'categorie/sous_categorie/index.html',

## lib/MT/ArchiveType/CategoryDaily.pm
	'CATEGORY-DAILY_ADV' => 'Par catégories et jours',
	'category/sub-category/yyyy/mm/dd/index.html' => 'categorie/sous-categorie/aaaa/mm/jj/index.html',
	'category/sub_category/yyyy/mm/dd/index.html' => 'categorie/sous_categorie/aaa/mm/jj/index.html',

## lib/MT/ArchiveType/CategoryMonthly.pm
	'CATEGORY-MONTHLY_ADV' => 'Par catégories et mois',
	'category/sub-category/yyyy/mm/index.html' => 'categorie/sous-categorie/aaaa/mm/index.html',
	'category/sub_category/yyyy/mm/index.html' => 'categorie/sous_categorie/aaaa/mm/index.html',

## lib/MT/ArchiveType/CategoryWeekly.pm
	'CATEGORY-WEEKLY_ADV' => 'Par catégories et semaines',
	'category/sub-category/yyyy/mm/day-week/index.html' => 'categorie/sous-categorie/aaaa/mm/jour-semaine/index.html',
	'category/sub_category/yyyy/mm/day-week/index.html' => 'categorie/sous_categorie/aaaa/mm/jour-semaine/index.html',

## lib/MT/ArchiveType/CategoryYearly.pm
	'CATEGORY-YEARLY_ADV' => 'Par catégories et années',
	'category/sub-category/yyyy/index.html' => 'categorie/sous-categorie/aaaa/index.html',
	'category/sub_category/yyyy/index.html' => 'categorie/sous_categorie/aaaa/index.html',

## lib/MT/ArchiveType/Daily.pm
	'DAILY_ADV' => 'Journalières',
	'yyyy/mm/dd/index.html' => 'aaaa/mm/jj/index.html',

## lib/MT/ArchiveType/Individual.pm
	'INDIVIDUAL_ADV' => 'Individuelles',
	'category/sub-category/entry-basename.html' => 'categorie/sous-categorie/nomdebase-note.html',
	'category/sub-category/entry-basename/index.html' => 'categorie/sous-categorie/nomdebase-note/index.html',
	'category/sub_category/entry_basename.html' => 'categorie/sous_categorie/nomdebase_note.html',
	'category/sub_category/entry_basename/index.html' => 'categorie/sous_categorie/nomdebase_note/index.html',
	'yyyy/mm/dd/entry-basename.html' => 'aaaa/mm/jj/nomdebase-note.html',
	'yyyy/mm/dd/entry-basename/index.html' => 'aaaa/mm/jj/nomdebase-note/index.html',
	'yyyy/mm/dd/entry_basename.html' => 'aaaa/mm/jj/nomdebase_note.html',
	'yyyy/mm/dd/entry_basename/index.html' => 'aaaa/mm/jj/nomdebase_note/index.html',
	'yyyy/mm/entry-basename.html' => 'aaaa/mm/nomdebase-note.html',
	'yyyy/mm/entry-basename/index.html' => 'aaaa/mm/nomdebase-note/index.html',
	'yyyy/mm/entry_basename.html' => 'aaaa/mm/nomdebase_note.html',
	'yyyy/mm/entry_basename/index.html' => 'aaaa/mm/nomdebase_note/index.html',

## lib/MT/ArchiveType/Monthly.pm
	'MONTHLY_ADV' => 'Mensuelles',
	'yyyy/mm/index.html' => 'aaaa/mm/index.html',

## lib/MT/ArchiveType/Page.pm
	'PAGE_ADV' => 'Page',
	'folder-path/page-basename.html' => 'chemin-repertoire/nomdebase-page.html',
	'folder-path/page-basename/index.html' => 'chemin-repertoire/nomdebase-page/index.html',
	'folder_path/page_basename.html' => 'chemin_repertoire/nomdebase_page.html',
	'folder_path/page_basename/index.html' => 'chemin_repertoire/nomdebase_page/index.html',

## lib/MT/ArchiveType/Weekly.pm
	'WEEKLY_ADV' => 'Hebdomadaires',
	'yyyy/mm/day-week/index.html' => 'aaaa/mm/jour-semaine/index.html',

## lib/MT/ArchiveType/Yearly.pm
	'YEARLY_ADV' => 'Annuelles',
	'yyyy/index.html' => 'aaaa/index.html',

## lib/MT/Asset.pm
	'Assets of this website' => 'Éléments de ce site',
	'Assets with Extant File' => 'Éléments avec fichier existant',
	'Assets with Missing File' => 'Éléments sans fichier',
	'Could not create asset cache path: [_1]' => 'Impossible de créer le chemin du cache des éléments : [_1]',
	'Could not remove asset file [_1] from the filesystem: [_2]' => 'Impossible de supprimer le fichier [_1] du système : [_2]',
	'Deleted' => 'Supprimé',
	'Except Userpic' => 'Exclure les photos des utilisateurs',
	'File Extension' => 'Extension de fichier',
	'File' => 'Fichier',
	'Filename' => 'Nom de fichier',
	'Image' => 'Image',
	'Label' => 'Étiquette',
	'Location' => 'Adresse',
	'Missing File' => 'Fichier manquant',
	'Pixel height' => 'Hauteur en pixel',
	'Pixel width' => 'Largeur en pixel',
	'Video' => 'Vidéo',
	'extant' => 'existant',
	'missing' => 'manquant',
	q{Author Status} => q{Status de l'auteur},

## lib/MT/Asset/Audio.pm
	'audio' => 'audio',

## lib/MT/Asset/Image.pm
	'%f-thumb-%wx%h-%i%x' => '%f-thumb-%wx%h-%i%x',
	'Actual Dimensions' => 'Dimensions réelles',
	'Error creating thumbnail file: [_1]' => 'Erreur lors de la création de la vignette : [_1]',
	'Images' => 'Images',
	'Permission denied setting image defaults for blog #[_1]' => 'Autorisation refusée de configurer les paramètres par défaut des images pour le blog #[_1]',
	'Popup page for [_1]' => 'Fenêtre surgissante pour [_1]',
	'Thumbnail image for [_1]' => 'Vignette de [_1]',
	'[_1] x [_2] pixels' => '[_1] x [_2] pixels',
	q{Cannot load image #[_1]} => q{Impossible de charger l'image #[_1]},
	q{Cropping image failed: Invalid parameter.} => q{L'image n'a pu être retaillée : paramètre invalide.},
	q{Error converting image: [_1]} => q{Erreur pendant la conversion de l'image : [_1]},
	q{Error cropping image: [_1]} => q{Erreur de rognage de l'image : [_1]},
	q{Error scaling image: [_1]} => q{Erreur lors du redimensionnement de l'image : [_1]},
	q{Error writing metadata to '[_1]': [_2]} => q{Erreur d'écriture des métadonnées vers '[_1]' : [_2]},
	q{Error writing to '[_1]': [_2]} => q{Erreur d'écriture sur '[_1]' : [_2]},
	q{Extracting image metadata failed: [_1]} => q{L'extraction des métadonnées image a échoué : [_1]},
	q{Invalid basename '[_1]'} => q{Nom de base invalide '[_1]'},
	q{Rotating image failed: Invalid parameter.} => q{L'image n'a pu être pivotée : paramètre invalide.},
	q{Scaling image failed: Invalid parameter.} => q{L'image n'a pu être redimensionnée : paramètre invalide.},
	q{Writing image metadata failed: [_1]} => q{L'écriture des métadonnées image a échoué : [_1]},
	q{Writing metadata failed: [_1]} => q{L'écriture des métadonnées a échoué : [_1]},

## lib/MT/Asset/Video.pm
	'Videos' => 'Vidéos',
	'video' => 'vidéo',

## lib/MT/Association.pm
	'Association' => 'Association',
	'Associations' => 'Associations',
	'Permissions with role: [_1]' => 'Autorisations avec rôle : [_1]',
	'Role Detail' => 'Détails du rôle',
	'Role Name' => 'Nom du rôle',
	'Role' => 'Rôle',
	'__WEBSITE_BLOG_NAME' => 'Nom du site/blog',
	'association' => 'association',
	'associations' => 'associations',
	q{User Name} => q{Nom d'utilisateur},
	q{User is [_1]} => q{L'utilisateur est [_1]},

## lib/MT/AtomServer.pm
	'Invalid image file format.' => 'Le format du fichier image est invalide.',
	'Perl module Image::Size is required to determine the width and height of uploaded images.' => 'Le module Perl Image::Size est requis pour déterminer la hauteur et la largeur des images téléchargées.',
	'PreSave failed [_1]' => 'Échec lors du pré-enregistrement [_1]',
	'Removing stats cache failed.' => 'La suppression du cache des statistiques a échoué',
	'[_1]: Entries' => '[_1] : Notes',
	q{Entry '[_1]' ([lc,_5] #[_2]) deleted by '[_3]' (user #[_4]) from atom api} => q{Note '[_1]' ([lc,_5] #[_2]) supprimée par '[_3]' (utilisateur #[_4]) depuis l'API Atom.},
	q{Invalid blog ID '[_1]'} => q{ID du blog invalide '[_1]'},
	q{User '[_1]' (user #[_2]) added [lc,_4] #[_3]} => q{L'utilisateur '[_1]' (utilisateur #[_2]) a ajouté [lc,_4] #[_3]},
	q{User '[_1]' (user #[_2]) edited [lc,_4] #[_3]} => q{L'utilisateur '[_1]' (L'utilisateur #[_2]) a édité [lc,_4] #[_3]},

## lib/MT/Auth.pm
	q{Bad AuthenticationModule config '[_1]': [_2]} => q{Mauvaise configuration du module d'authentification '[_1]' : [_2]},
	q{Bad AuthenticationModule config} => q{Mauvaise configuration du module d'authentification},

## lib/MT/Auth/MT.pm
	'Missing required module' => 'Un module requis est manquant',

## lib/MT/Auth/OpenID.pm
	'Could not load Net::OpenID::Consumer.' => 'Impossible de charger Net::OpenID::Consumer.',
	'Could not save the session' => 'Impossible de sauver la session',
	'The text entered does not appear to be a valid web address.' => 'Le texte entré ne semble pas être une adresse web valide.',
	'Unable to connect to [_1]: [_2]' => 'Impossible de se connecter à [_1] : [_2]',
	q{Could not verify the OpenID provided: [_1]} => q{La vérification de l'OpenID entré a échoué : [_1]},
	q{The address entered does not appear to be an OpenID endpoint.} => q{L'adresse entrée ne semble pas être un service OpenID},

## lib/MT/Auth/TypeKey.pm
	'INVALID' => 'INVALIDE',
	'TypePad signature verification returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'La vérification de la signature TypePad a renvoyé [_1] en [_2] secondes pour vérifier [_3] avec [_4]',
	'VALID' => 'VALIDE',
	q{Could not get public key from the URL provided.} => q{Impossible d'obtenir une clef publique depuis l'URL fournie.},
	q{No public key could be found to validate registration.} => q{Aucune clé publique n'a été trouvée pour valider l'inscription.},
	q{Sign in requires a secure signature.} => q{L'identification nécessite une signature sécurisée.},
	q{The TypePad signature is out of date ([_1] seconds old). Ensure that your server's clock is correct.} => q{La signature TypePad est dépassée (vieille de [_1] secondes). Vérifiez que l'horloge de votre serveur est correcte.},
	q{The sign-in validation failed.} => q{La validation de l'enregistrement a échoué.},
	q{This weblog requires commenters to pass an email address. If you would like to do so you may log in again, and give the authentication service permission to pass your email address.} => q{Ce blog requiert l'adresse e-mail des commentateurs. Si vous souhaitez poursuivre, vous pouvez vous réauthentifier en autorisant sa transmission.},

## lib/MT/Author.pm
	'Banned' => 'Banni',
	'Created by' => 'Créé par',
	'Disabled Commenters' => 'Auteurs de commentaire désactivés',
	'Enabled Commenters' => 'Auteurs de commentaire actifs',
	'Externally Authenticated Commenters' => 'Utilisateurs avec authentification externe',
	'Locked Out' => 'Verrouillé',
	'Locked out Users' => 'Utilisateurs déverrouillés',
	'Lockout' => 'Verrouillé',
	'MT Native Users' => 'Utilisateurs natifs MT',
	'MT Users' => 'Utilisateurs MT',
	'Not Locked Out' => 'Pas verrouillé',
	'Pending Commenters' => 'Auteurs de commentaire en attente',
	'Pending Users' => 'Utilisateurs en attente',
	'Privilege' => 'Privilège',
	'__COMMENTER_APPROVED' => 'Approuvé',
	'userpic-[_1]-%wx%h%x' => 'userpic-[_1]-%wx%h%x',
	q{The approval could not be committed: [_1]} => q{L'approbation ne peut être réalisée : [_1]},

## lib/MT/BackupRestore.pm
	'Copying [_1] to [_2]...' => 'Copie de [_1] vers [_2]...',
	'Failed: ' => 'Échec : ',
	'Manifest file: [_1]' => 'Fichier manifeste : [_1]',
	'Path was not found for the file, [_1].' => 'Chemin introuvable pour le fichier, [_1].',
	'[_1] is not writable.' => '[_1] non éditable.',
	'[_1] records backed up...' => '[_1] enregistrements sauvegardés...',
	'failed' => 'échec',
	'ok' => 'OK',
	qq{\nCannot write file. Disk full.} => qq{\nImpossible d'enregistrer le fichier. Le disque est plein.},
	q{Cannot open [_1].} => q{Impossible d'ouvrir [_1].},
	q{Cannot open directory '[_1]': [_2]} => q{Impossible d'ouvrir le répertoire '[_1]' : [_2]},
	q{Changing path for the file '[_1]' (ID:[_2])...} => q{Changement du chemin du fichier '[_1]' (ID:[_2])...},
	q{Error making path '[_1]': [_2]} => q{Erreur dans le chemin '[_1]' : [_2]},
	q{ID for the file was not set.} => q{L'ID pour le fichier n'a pas été spécifié.},
	q{Manifest file [_1] was not a valid Movable Type backup manifest file.} => q{Le fichier manifest [_1] n'est pas un fichier manifeste de sauvegarde Movable Type.},
	q{No manifest file could be found in your import directory [_1].} => q{Aucun fichier manifeste n'a été trouvé dans votre répertoire d'import [_1].},
	q{Restoring asset associations ... ( [_1] )} => q{Restauration des associations d'éléments... ([_1])},
	q{Restoring asset associations in entry ... ( [_1] )} => q{Restauration des associations d'éléments dans la note... ([_1])},
	q{Restoring asset associations in page ... ( [_1] )} => q{Restauration des associations d'éléments dans la page... ([_1])},
	q{Restoring url of the assets ( [_1] )...} => q{Restauration de l'url de l'élément ([_1])...},
	q{Restoring url of the assets in entry ( [_1] )...} => q{Restauration de l'url de l'élément dans la note ([_1])...},
	q{Restoring url of the assets in page ( [_1] )...} => q{Restauration de l'url de l'élément dans la page ([_1])...},
	q{The file ([_1]) was not restored.} => q{Le fichier ([_1]) n'a pas été restauré.},
	q{There were no [_1] records to be backed up.} => q{Il n'y a pas d'enregistrements [_1] à sauvegarder.},

## lib/MT/BackupRestore/BackupFileHandler.pm
	'Invalid serializer version was specified.' => 'La version fournie du sérialiseur est invalide.',
	'Restoring [_1] records:' => 'Restauration de [_1] enregistrements :',
	'The uploaded backup manifest file was created with Movable Type, but the schema version ([_1]) differs from the one used by this system ([_2]).  You should not restore this backup to this version of Movable Type.' => 'Le fichier manifeste de sauvegarde envoyé a été créé par Movable Type, mais la version du schéma ([_1]) diffère de celle utilisée sur ce système. Vous ne devriez pas restaurer cette sauvegarde sur cette version de Movable Type.',
	'[_1] records restored.' => '[_1] enregistrements restaurés.',
	'[_1] records restored...' => '[_1] enregistrements restaurés...',
	q{A user with the same name '[_1]' was found in the backup (ID:[_2]).  Restore replaced this user with the data from the backup.} => q{Un utilisateur de même nom '[_1]' a été trouvé dans la sauvegarde (ID:[_2]). Les données de cet utilisateur ont été remplacées par celles de la sauvegarde.},
	q{A user with the same name as the current user ([_1]) was found in the backup.  Skipping this user record.} => q{Un utilisateur avec le même nom que l'actuel ([_1]) a été trouvé dans la sauvegarde. Son enregistrement est ignoré.},
	q{Tag '[_1]' exists in the system.} => q{Le tag '[_1]' existe dans le système.},
	q{The role '[_1]' has been renamed to '[_2]' because a role with the same name already exists.} => q{Le rôle '[_1]' a été renommé '[_2]' car un autre rôle portant le même nom existe déjà.},
	q{The system level settings for plugin '[_1]' already exist.  Skipping this record.} => q{
	Le paramètre au niveau du système pour le plugin '[_1]' existe déjà. Enregistrement ignoré.},
	q{The uploaded file was not a valid Movable Type backup manifest file.} => q{Le fichier envoyé n'était pas un manifeste de sauvegarde Movable Type valide.},
	q{[_1] is not a subject to be restored by Movable Type.} => q{[_1] n'est pas un sujet qui peut être restauré par Movable Type.},

## lib/MT/BackupRestore/BackupFileScanner.pm
	'Cannot restore requested file because doing so requires the Digest::SHA Perl module. Please contact your Movable Type system administrator.' => 'Ce fichier ne peut être restauré car le module Perl Digest::SHA est manquant. Veuillez contacter votre administrateur Movable Type',
	q{Cannot restore requested file because a website was not found in either the existing Movable Type system or the backup data. A website must be created first.} => q{Impossible de restaurer ce fichier car aucun site web n'y est présent ou dans le système Movable Type. Vous devez d'abord créer un site web.},

## lib/MT/BasicAuthor.pm
	'authors' => 'auteurs',

## lib/MT/Blog.pm
	'*Website/Blog deleted*' => '*Site/blog supprimé*',
	'Clone of [_1]' => 'Clone de [_1]',
	'Cloned blog... new id is [_1].' => 'Le nouvel identifiant du blog cloné est [_1]',
	'Cloning TrackBack pings for blog...' => 'Clonage des pings de TrackBack du blog...',
	'Cloning TrackBacks for blog...' => 'Clonage des TrackBacks du blog...',
	'Cloning associations for blog:' => 'Clonage des associations du blog :',
	'Cloning categories for blog...' => 'Clonage des catégories du blog...',
	'Cloning comments for blog...' => 'Clonage des commentaires de blog...',
	'Cloning entries and pages for blog...' => 'Clonage des notes et pages du blog en cours...',
	'Cloning entry placements for blog...' => 'Clonage des placements de notes du blog...',
	'Cloning entry tags for blog...' => 'Clonage des tags de notes du blog...',
	'Cloning permissions for blog:' => 'Clonage des autorisations du blog :',
	'Cloning template maps for blog...' => 'Clonage des tables de correspondances des gabarits du blog...',
	'Cloning templates for blog...' => 'Clonage des gabarits du blog...',
	'Failed to load theme [_1]: [_2]' => 'Échec lors du chargement du thème [_1] : [_2]',
	'First Blog' => 'Premier blog',
	'No default templates were found.' => 'Aucun gabarit par défaut trouvé.',
	'Theme' => 'Thème',
	'__PAGE_COUNT' => 'Nombre de pages',
	q{Failed to apply theme [_1]: [_2]} => q{Échec de l'application du thème [_1] : [_2]},
	q{__ASSET_COUNT} => q{Nombre d'éléments},

## lib/MT/Builder.pm
	'<[_1]> with no </[_1]> on line #' => '<[_1]> sans </[_1]> à la ligne #',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]> sans </[_1]> à la ligne [_2]',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]> sans </[_1]> à la ligne [_2].',
	'Error in <mt[_1]> tag: [_2]' => 'Erreur dans la balise <mt[_1]> : [_2]',
	'Unknown tag found: [_1]' => 'Une balise inconnue a été trouvée : [_1]',
	q{<[_1]> at line [_2] is unrecognized.} => q{<[_1]> à la ligne [_2] n'est pas reconnu.},

## lib/MT/CMS/AddressBook.pm
	'No valid recipients were found for the entry notification.' => 'Aucun destinataire valide trouvé pour la notification de la note.',
	'Please select a blog.' => 'Merci de sélectionner un blog.',
	'[_1] Update: [_2]' => '[_1] Mise à jour : [_2]',
	q{Error sending mail ([_1]): Try another MailTransfer setting?} => q{Erreur lors de l'envoi de l'e-mail ([_1]). Essayez de modifier le paramètre MailTransfer.},
	q{No entry ID was provided} => q{L'ID de la note est manquant},
	q{No such entry '[_1]'} => q{Aucune note du type '[_1]'},
	q{Subscriber '[_1]' (ID:[_2]) deleted from address book by '[_3]'} => q{Abonné '[_1]' (ID:[_2]) supprimé du carnet d'adresses par '[_3]'},
	q{The e-mail address you entered is already on the Notification List for this blog.} => q{L'adresse e-mail saisie est déjà sur la liste de notification de ce blog.},
	q{The text you entered is not a valid URL.} => q{Le texte entré n'est pas une adresse URL valide.},
	q{The text you entered is not a valid email address.} => q{Le texte entré n'est pas une adresse e-mail valide.},

## lib/MT/CMS/Asset.pm
	'(user deleted)' => '(utilisateur effacé)',
	'/' => '/',
	'<' => '<',
	'<[_1] Root>' => '<Racine du [_1]>',
	'<[_1] Root>/[_2]' => '<Racine du [_1]>/[_2]',
	'Archive' => 'Archive',
	'Cannot load file #[_1].' => 'Impossible de charger le fichier #[_1].',
	'Cannot overwrite an existing file with a file of a different type. Original: [_1] Uploaded: [_2]' => 'Impossible de remplacer un fichier avec un autre de type différent. Original : [_1] / Téléchargé : [_2]',
	'Custom...' => 'Personnalisé...',
	'Extension changed from [_1] to [_2]' => 'Extensions changées de [_1] vers [_2]',
	'Failed to create thumbnail file because [_1] could not handle this image type.' => 'Impossible de créer la vignette car [_1] ne gère pas ce type de fichier.',
	'Files' => 'Fichiers',
	'Invalid Request.' => 'Requête invalide.',
	'No permissions' => 'Aucun droit',
	'Untitled' => 'Sans nom',
	'Upload File' => 'Télécharger un fichier',
	'none' => 'aucun fournisseur',
	'unassigned' => 'non assigné',
	q{Cannot load asset #[_1].} => q{Impossible de charger l'élément #[_1].},
	q{Cannot load asset #[_1]} => q{Impossible de charger l'élément #[_1]},
	q{Could not create upload path '[_1]': [_2]} => q{Impossible de créer le répertoire d'upload '[_1]' : [_2]},
	q{Error creating a temporary file; The webserver should be able to write to this folder.  Please check the TempDir setting in your configuration file, it is currently '[_1]'. } => q{Impossible de créer un fichier temporaire. Le serveur devrait pouvoir écrire dans ce répertoire. Veuillez vérifier la directive TempDir dans votre fichier de configuration, sa valeur actuelle est '[_1]'.},
	q{Error deleting '[_1]': [_2]} => q{Erreur lors de la suppression de '[_1]' : [_2]},
	q{Error opening '[_1]': [_2]} => q{Erreur lors de l'ouverture de '[_1]' : [_2]},
	q{File '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Fichier '[_1]' (ID:[_2]) supprimé par '[_3]'},
	q{File '[_1]' uploaded by '[_2]'} => q{Fichier '[_1]' envoyé par '[_2]'},
	q{File with name '[_1]' already exists. (Install the File::Temp Perl module if you would like to be able to overwrite existing uploaded files.)} => q{Un fichier nommé '[_1]' existe déjà. (Installez le module Perl File::Temp si vous souhaitez pouvoir écraser des fichiers existants.)},
	q{File with name '[_1]' already exists. Upload has been cancelled.} => q{Un fichier nommé '[_1]' existe déjà. Le téléchargement a été annulé.},
	q{File with name '[_1]' already exists.} => q{Un fichier nommé '[_1]' existe déjà.},
	q{File with name '[_1]' already exists; Tried to write to a tempfile, but the webserver could not open it: [_2]} => q{Un fichier nommé '[_1]' existe déjà. Une tentative de création d'un fichier temporaire a échoué, le serveur web n'a pas pu l'ouvrir : [_2]},
	q{Invalid temp file name '[_1]'} => q{Nom de fichier temporaire invalide '[_1]'},
	q{Movable Type was unable to write to the "Upload Destination". Please make sure that the webserver can write to this folder.} => q{Movable Type n'a pas pu écrire dans la destination de téléchargement. Assurez-vous que Movable Type peut écrire dans ce répertoire.},
	q{Transforming image failed: [_1]} => q{La transformation de l'image a échoué : [_1]},
	q{Uploaded file is not an image.} => q{Le fichier téléchargé n'est pas une image.},
	q{basename of user} => q{nom de base de l'utilisateur},

## lib/MT/CMS/BanList.pm
	'You did not enter an IP address to ban.' => 'Vous devez saisir une adresse IP à bannir.',
	q{The IP you entered is already banned for this blog.} => q{L'adresse IP saisie est déjà bannie pour ce blog.},

## lib/MT/CMS/Blog.pm
	'Blog Root' => 'Racine du blog',
	'Cannot load template #[_1].' => 'Impossible de charger le gabarit #[_1].',
	'Entries must be cloned if comments and trackbacks are cloned' => 'Les notes doivent être clonées si les commentaires et les TrackBacks le sont',
	'Entries must be cloned if comments are cloned' => 'Les notes doivent être clonées si les commentaires le sont',
	'Entries must be cloned if trackbacks are cloned' => 'Les notes doivent être clonées si les TrackBacks le sont',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Erreur : Movable Type ne peut pas écrire dans le répertoire de cache de gabarits. Merci de vérifier les autorisations du répertoire <code>[_1]</code> situé dans le répertoire du blog.',
	'Finished!' => 'Terminé !',
	'General Settings' => 'Paramètres généraux',
	'Invalid blog' => 'Blog incorrect',
	'Invalid blog_id' => 'Identifiant du blog invalide',
	'New Blog' => 'Nouveau blog',
	'Plugin Settings' => 'Paramètres des plugins',
	'Publish Site' => 'Publier le site',
	'Saved [_1] Changes' => 'Changements de [_1] enregistrés',
	'Saving blog failed: [_1]' => 'Échec de la sauvegarde du blog : [_1]',
	'Select Blog' => 'Sélectionner un blog',
	'Selected Blog' => 'Blog sélectionné',
	'The number of revisions to store must be a positive integer.' => 'Le nombre de révisions à stocker doit être un entier positif.',
	'These setting(s) are overridden by a value in the Movable Type configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.' => 'Ce ou ces paramètres sont invalidés par une valeur dans le fichier de configuration de MT : [_1]. Supprimez la valeur du fichier de configuration afin de la contrôler depuis cette page.',
	'This action can only be run on a single blog at a time.' => 'Cette action ne peut être exécutée que sur un seul blog à la fois.',
	'This action cannot clone website.' => 'Cette action ne peut pas cloner un site web.',
	'Website Root' => 'Racine du site web',
	q{'[_1]' (ID:[_2]) has been copied as '[_3]' (ID:[_4]) by '[_5]' (ID:[_6]).} => q{'[_1]' (ID:[_2]) a été copié comme '[_3]' (ID:[_4]) par '[_5]' (ID:[_6]).},
	q{Archive URL must be an absolute URL.} => q{Les URLs d'archive doivent être des URLs absolues.},
	q{Blog '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Blog '[_1]' (ID:[_2]) supprimé par '[_3]'},
	q{Cloning blog '[_1]'...} => q{Duplication du blog...},
	q{Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.} => q{Erreur : Movable Type n'a pas pu créer un répertoire pour cacher vos gabarits dynamiques. Vous devez créer un répertoire nommé <code>[_1]</code> dans le répertoire de votre blog.},
	q{No blog was selected to clone.} => q{Aucun blog à cloner n'a été sélectionné.},
	q{Please choose a preferred archive type.} => q{Veuillez choisir le type d'archive préférée.},
	q{Site URL must be an absolute URL.} => q{L'URL du site doit être une URL absolue.},
	q{The '[_1]' provided below is not writable by the web server. Change the directory ownership or permissions and try again.} => q{Le '[_1]' fourni ci-dessous n'est pas accessible en écriture pour le serveur web. Modifiez les droits du répertoire et réessayez.},
	q{Type a blog name to filter the choices below.} => q{Entrez le nom d'un blog pour affiner les résultats ci-dessous.},
	q{You did not specify a blog name.} => q{Vous n'avez pas spécifié de nom pour le blog.},
	q{You did not specify an Archive Root.} => q{Vous n'avez pas spécifié une racine d'archive.},
	q{[_1] '[_2]' (ID:[_3]) created by '[_4]'} => q{[_1] '[_2]' (ID:[_3]) a été créé par '[_4]'},
	q{[_1] '[_2]'} => q{[_1] '[_2]'},
	q{[_1] changed from [_2] to [_3]} => q{[_1] a changé de '[_2]' à '[_3]'},
	q{index template '[_1]'} => q{gabarit d'index '[_1]'},

## lib/MT/CMS/Category.pm
	'Add a [_1]' => 'Ajouter un [_1]',
	'Failed to update [_1]: Some of [_2] were changed after you opened this page.' => 'Impossible de mettre à jour [_1] : certains [_2] ont été modifiés après que vous avez ouvert cette page.',
	'The [_1] must be given a name!' => 'Le [_1] doit avoir un nom !',
	'The category name cannot be blank.' => 'Le nom de la catégorie ne peut pas être vide.',
	'Your changes have been made (added [_1], edited [_2] and deleted [_3]). <a href="#" onclick="[_4]" class="mt-rebuild">Publish your site</a> to see these changes take effect.' => 'Vos changements ont été effectués ([_1] ajoutés, [_2] édités et [_3] supprimés). <a href="#" onclick="[_4]" class="mt-rebuild">Publiez votre site</a> pour voir les changements.',
	q{Category '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Catégorie '[_1]' (ID:[_2]) supprimée par '[_3]'},
	q{Category '[_1]' (ID:[_2]) edited by '[_3]'} => q{Catégorie '[_1]' (ID:[_2]) éditée par '[_3]'},
	q{Category '[_1]' created by '[_2]'.} => q{Catégorie '[_1]' créée par '[_2]'.},
	q{No label} => q{Pas d'étiquette},
	q{The category basename '[_1]' conflicts with the basename of another category. Top-level categories and sub-categories with the same parent must have unique basenames.} => q{Le nom de base de la catégorie '[_1]' entre en conflit avec celui d'une autre. Les catégories principales et celles secondaires du même parent doivent avoir un nom de base distinct.},
	q{The category name '[_1]' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.} => q{Le nom de catégorie '[_1]' est en conflit avec une autre catégorie. Les catégories racines et les sous-catégories qui ont le même parent doivent avoir un nom distinct.},
	q{The category name '[_1]' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.} => q{Le nom de la catégorie '[_1]' entre en conflit avec celui d'une autre. Les catégories principales et celles secondaires du même parent doivent avoir un nom distinct.},
	q{The name '[_1]' is too long!} => q{Le nom '[_1]' est trop long.},
	q{Tried to update [_1]([_2]), but the object was not found.} => q{Tentative de mise à jour [_1] ([_2]), mais l'objet est introuvable.},
	q{[_1] order has been edited by '[_2]'.} => q{L'ordre de [_1] a été édité par '[_2]'.},

## lib/MT/CMS/Comment.pm
	'(untitled)' => '(sans titre)',
	'Edit Comment' => 'Éditer le commentaire',
	'No such commenter [_1].' => 'Aucun commentateur [_1].',
	'Orphaned comment' => 'Commentaire orphelin',
	'The entry corresponding to this comment is missing.' => 'La note correspondante à ce commentaire est manquante.',
	'The parent comment was not found.' => 'Le commentaire parent est introuvable.',
	'You cannot create a comment for an unpublished entry.' => 'Vous ne pouvez pas créer un commentaire sur une note non publiée.',
	'You cannot reply to unapproved comment.' => 'Vous ne pouvez répondre à un commentaire non approuvé.',
	'You cannot reply to unpublished comment.' => 'Vous ne pouvez pas répondre à un commentaire non publié.',
	q{Comment (ID:[_1]) by '[_2]' deleted by '[_3]' from entry '[_4]'} => q{Commentaire (ID:[_1]) de '[_2]' supprimé par '[_3]' de la note '[_4]'},
	q{The parent comment id was not specified.} => q{L'ID du commentaire parent est manquante.},
	q{User '[_1]' banned commenter '[_2]'.} => q{L'utilisateur '[_1]' a banni le commentateur '[_2]'.},
	q{User '[_1]' trusted commenter '[_2]'.} => q{L'utilisateur '[_1]' a considéré comme fiable le commentateur '[_2]'.},
	q{User '[_1]' unbanned commenter '[_2]'.} => q{L'utilisateur '[_1]' a retiré le statut Banni à le commentateur '[_2]'.},
	q{User '[_1]' untrusted commenter '[_2]'.} => q{L'utilisateur '[_1]' a retiré le statut Fiable à le commentateur '[_2]'.},
	q{You do not have permission to approve this comment.} => q{Vous n'avez pas la permission d'approuver ce commentaire.},
	q{You do not have permission to approve this trackback.} => q{Vous n'avez pas la permission d'approuver ce TrackBack.},

## lib/MT/CMS/Common.pm
	'All [_1]' => 'Totalité des [_1]',
	'An error occurred while counting objects: [_1]' => 'Une erreur est survenue au décompte des objets : [_1]',
	'An error occurred while loading objects: [_1]' => 'Une erreur est survenue au chargement des objets : [_1]',
	'Error occurred during permission check: [_1]' => 'Erreur lors de la vérification des permissions : [_1]',
	'Invalid ID [_1]' => 'ID invalide [_1]',
	'Invalid filter terms: [_1]' => 'Filtre invalide : [_1]',
	'Invalid filter: [_1]' => 'Filtre invalide : [_1]',
	'Invalid type [_1]' => 'Type invalide [_1]',
	'New Filter' => 'Nouveau filtre',
	'Removing tag failed: [_1]' => 'La suppression du tag a échoué : [_1]',
	'System templates cannot be deleted.' => 'Les gabarits système ne peuvent pas être supprimés.',
	'The Template Name and Output File fields are required.' => 'Le nom du gabarit et celui du fichier de sortie sont requis.',
	'The blog root directory must be within [_1].' => 'Le répertoire racine du blog doit être dans [_1].',
	'The selected [_1] has been deleted from the database.' => 'Le [_1] sélectionné a été supprimé de la base de données.',
	'The website root directory must be within [_1].' => 'Le répertoire racine du site doit être dans [_1].',
	'Unknown list type' => 'Type de liste inconnu',
	'[_1] Feed' => 'Flux [_1]',
	'[_1] broken revisions of [_2](id:[_3]) are removed.' => '[_1] révisions corrompues de [_2] (id: [_3]) ont été supprimées.',
	q{'[_1]' edited the global template '[_2]'} => q{'[_1]' a édité le gabarit global '[_2]'},
	q{'[_1]' edited the template '[_2]' in the blog '[_3]'} => q{'[_1]' a édité le gabarit '[_2]' du blog '[_3]'},
	q{Saving snapshot failed: [_1]} => q{L'enregistrement de l'instantané a échoué : [_1]},

## lib/MT/CMS/Dashboard.pm
	'Not configured' => 'Non configuré',
	'Page Views' => 'Page vues',
	q{Error: This blog does not have a parent website.} => q{Erreur : ce blog n'a pas de site web parent.},

## lib/MT/CMS/Entry.pm
	'(user deleted - ID:[_1])' => '(utilisateur supprimé - ID : [_1])',
	'Entry Status' => 'Statut par défaut',
	'Need a status to update entries' => 'Un statut est nécessaire pour mettre à jour les notes',
	'Need entries to update status' => 'Des notes sont nécessaires pour mettre à jour le statut',
	'New Entry' => 'Nouvelle note',
	'New Page' => 'Nouvelle page',
	'New [_1]' => 'Nouvelle [_1]',
	'No such [_1].' => 'Pas de [_1].',
	'Publish error: [_1]' => 'Erreur de publication : [_1]',
	'Saving placement failed: [_1]' => 'Échec de la sauvegarde du placement : [_1]',
	'This basename has already been used. You should use an unique basename.' => 'Ce nom de base a déjà été utilisé. Vous devez utiliser un nom de base distinct.',
	'Unable to create preview files in this location: [_1]' => 'Impossible de créer les fichiers de prévisualisation à cet emplacement : [_1]',
	'authored on' => 'créée le',
	'modified on' => 'modifiée le',
	q{<a href="[_1]">QuickPost to [_2]</a> - Drag this bookmarklet to your browser's toolbar, then click it when you are visiting a site that you want to blog about.} => q{<a href="[_1]">Publication rapide vers [_2]</a> — Glisser ce bookmarklet dans la barre de signets de votre navigateur et cliquez-le quand vous visitez un site que vous voulez mentionner sur votre blog.},
	q{Invalid date '[_1]'; 'Published on' dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Date invalide '[_1]'. Une date de publication doit être au format AAAA-MM-JJ HH:MM:SS.},
	q{Invalid date '[_1]'; 'Published on' dates should be earlier than the corresponding 'Unpublished on' date '[_2]'.} => q{Date invalide '[_1]'. La date 'Publiée le' doit être antérieure à la date 'Dépubliée le' '[_2]' correspondante.},
	q{Invalid date '[_1]'; 'Published on' dates should be real dates.} => q{Date invalide '[_1]'. Les dates de publication doivent être des dates réelles.},
	q{Invalid date '[_1]'; 'Unpublished on' dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Date invalide '[_1]'. La date de dépublication doit avoir pour format YYYY-MM-DD HH:MM:SS.},
	q{Invalid date '[_1]'; 'Unpublished on' dates should be dates in the future.} => q{Date invalide '[_1]'. La date de dépublication doit être dans le futur.},
	q{Invalid date '[_1]'; 'Unpublished on' dates should be later than the corresponding 'Published on' date.} => q{Date invalide '[_1]'. La date de dépublication doit être postérieure à celle de publication.},
	q{Invalid date '[_1]'; 'Unpublished on' dates should be real dates.} => q{Date invalide '[_1]'. La date de dépublication doit être une date réelle.},
	q{Invalid date '[_1]'; [_2] dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Date invalide '[_1]'. Les dates [_2] doivent être au format AAAA-MM-JJ HH:MM:SS.},
	q{Invalid date '[_1]'; [_2] dates should be real dates.} => q{Date invalide '[_1]'. Les dates [_2] doivent être des dates réelles.},
	q{One of the entries ([_1]) did not exist} => q{Une des notes ([_1]) n'existe pas.},
	q{Ping '[_1]' failed: [_2]} => q{Le ping '[_1]' n'a pas fonctionné : [_2]},
	q{Removing placement failed: [_1]} => q{Échec de la suppression de l'emplacement : [_1]},
	q{Saving entry '[_1]' failed: [_2]} => q{La sauvegarde de la note '[_1]' a échoué : [_2]},
	q{Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.} => q{Votre blog n'a pas été configuré avec un chemin de site et une URL. Vous ne pourrez pas publier de notes tant qu'ils ne seront pas définis.},
	q{[_1] '[_2]' (ID:[_3]) edited and its status changed from [_4] to [_5] by user '[_6]'} => q{[_1] '[_2]' (ID:[_3]) édité et son statut est passé de [_4] à [_5] par utilisateur '[_6]'},
	q{[_1] '[_2]' (ID:[_3]) edited by user '[_4]'} => q{[_1] '[_2]' (ID:[_3]) édité par utilisateur '[_4]'},
	q{[_1] '[_2]' (ID:[_3]) status changed from [_4] to [_5]} => q{[_1] '[_2]' (ID:[_3]) statut changé de [_4] à [_5]},

## lib/MT/CMS/Export.pm
	q{Loading blog '[_1]' failed: [_2]} => q{Le chargement du blog '[_1]' a échoué : [_2]},
	q{You do not have export permissions} => q{Vous n'avez pas les droits d'exportation},

## lib/MT/CMS/Filter.pm
	'(Legacy) ' => '(obsolète) ',
	'Failed to delete filter(s): [_1]' => 'Échec de la suppression des filtres : [_1]',
	'Failed to save filter:  Label "[_1]" is duplicated.' => 'Échec de la sauvegarde du filtre : le label "[_1]" est dupliqué.',
	'Failed to save filter: Label is required.' => 'Échec de la sauvegarde du filtre : le label est requis.',
	'Failed to save filter: [_1]' => 'Échec de la sauvegarde du filtre : [_1]',
	'No such filter' => 'Pas de tel filtre',
	'Permission denied' => 'Permission refusée',
	'Removed [_1] filters successfully.' => 'Retrait de [_1] filtres avec succès.',
	'[_1] ( created by [_2] )' => '[_1] ( créé par [_2] )',

## lib/MT/CMS/Folder.pm
	q{Folder '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Répertoire '[_1]' (ID:[_2]) supprimé par '[_3]'},
	q{Folder '[_1]' (ID:[_2]) edited by '[_3]'} => q{Répertoire '[_1]' (ID:[_2]) édité par '[_3]'},
	q{Folder '[_1]' created by '[_2]'} => q{Répertoire '[_1]' créé par '[_2]'},
	q{The folder '[_1]' conflicts with another folder. Folders with the same parent must have unique basenames.} => q{Le répertoire '[_1]' est en conflit avec un autre répertoire. Les répertoires qui ont le même répertoire parent doivent avoir un nom de base distinct.},

## lib/MT/CMS/Import.pm
	'Import/Export' => 'Importer/Exporter',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'Vous devez fournir un mot de passe si vous allez créer de nouveaux utilisateurs pour chaque utilisateur listé dans votre blog.',
	q{Importer type [_1] was not found.} => q{Type d'importateur [_1] non trouvé.},
	q{You do not have import permission} => q{Vous n'avez pas le droit d'importer},
	q{You do not have permission to create users} => q{Vous n'avez pas l'autorisation de créer des utilisateurs},

## lib/MT/CMS/Log.pm
	'All Feedback' => 'Tous les retours lecteurs',
	'Publishing' => 'Publication',
	q{Activity log for blog '[_1]' (ID:[_2]) reset by '[_3]'} => q{Journal d'activité pour le blog '[_1]' (ID:[_2]) réinitialisé par '[_3]'},
	q{Activity log reset by '[_1]'} => q{Journal d'activité réinitialisé par '[_1]'},
	q{System Activity Feed} => q{Flux d'activité du système},

## lib/MT/CMS/Plugin.pm
	'Error saving plugin settings: [_1]' => 'Erreur à la sauvegarde des paramètres du plugin : [_1]',
	'Individual Plugins' => 'Plugins individuels',
	'Plugin Set: [_1]' => 'Éventail de plugins : [_1]',
	'Plugins are disabled by [_1]' => '', # Translate - New
	'Plugins are enabled by [_1]' => '', # Translate - New
	q{Plugin '[_1]' is disabled by [_2]} => q{}, # Translate - New
	q{Plugin '[_1]' is enabled by [_2]} => q{}, # Translate - New

## lib/MT/CMS/Search.pm
	'Comment Text' => 'Texte du commentaire',
	'Entry Body' => 'Corps de la note',
	'Extended Entry' => 'Suite de la note',
	'Extended Page' => 'Page étendue',
	'IP Address' => 'Adresse IP',
	'Invalid date(s) specified for date range.' => 'Date(s) incorrecte(s) pour la sélection de calendrier.',
	'Keywords' => 'Mots-clés',
	'Linked Filename' => 'Lien du fichier lié',
	'Log Message' => 'Message du journal',
	'Output Filename' => 'Nom du fichier de sortie',
	'Page Body' => 'Corps de la page',
	'Search & Replace' => 'Rechercher et Remplacer',
	'Site URL' => 'URL du site',
	'Source URL' => 'URL Source',
	'Template Name' => 'Nom du gabarit',
	'Text' => 'Texte',
	q{Error in search expression: [_1]} => q{Erreur dans l'expression de recherche : [_1]},
	q{No [_1] were found that match the given criteria.} => q{Aucun [_1] correspondant aux critères fournis n'a été trouvé.},
	q{Searched for: '[_1]' Replaced with: '[_2]'} => q{Recherché : '[_1]' Remplacé par : '[_2]'},
	q{[_1] '[_2]' (ID:[_3]) updated by user '[_4]' using Search & Replace.} => q{[_1] '[_2]' (ID:[_3]) mis à jour par l'utilisateur '[_4]' via Chercher/Remplacer.},

## lib/MT/CMS/Tag.pm
	'A new name for the tag must be specified.' => 'Un nouveau nom doit être spécifié pour ce tag.',
	'Error saving file: [_1]' => 'Erreur en sauvegardant le fichier : [_1]',
	'No such tag' => 'Pas de tag de ce type',
	'Successfully added [_1] tags for [_2] entries.' => '[_1] tags ont bien été ajoutés à [_2] notes.',
	'The tag was successfully renamed' => 'Le tag a bien été renommé.',
	q{Error saving entry: [_1]} => q{Erreur d'enregistrement de la note : [_1]},
	q{Tag '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Tag '[_1]' (ID:[_2]) supprimé par '[_3]'},

## lib/MT/CMS/Template.pm
	' (Backup from [_1])' => ' (Sauvegarde depuis [_1])',
	'Cannot load templatemap' => 'Impossible de charger la table de correspondance des gabarits',
	'Cannot locate host template to preview module/widget.' => 'Impossible de localiser le gabarit du serveur pour prévisualiser le module/widget.',
	'Cannot preview without a template map!' => 'Prévisualisation impossible sans une carte de gabarit !',
	'Cannot publish a global template.' => 'Ne peut pas publier un gabarit global.',
	'Copy of [_1]' => 'Copie de [_1]',
	'Email Templates' => 'Gabarits e-mail',
	'Entry or Page' => 'Note ou page',
	'Error creating new template: ' => 'Erreur pendant la création du nouveau gabarit : ',
	'Global Template' => 'Gabarit global',
	'Global Templates' => 'Gabarits globaux',
	'Global' => 'global',
	'Invalid Blog' => 'Blog incorrect',
	'LOREM_IPSUM_TEXT' => 'LOREM_IPSUM_TEXT',
	'LORE_IPSUM_TEXT_MORE' => 'LORE_IPSUM_TEXT_MORE',
	'Lorem ipsum' => 'Lorem ipsum',
	'New Template' => 'Nouveau gabarit',
	'One or more errors were found in the included template module ([_1]).' => 'Une ou plusieurs erreurs ont été trouvées dans le module de gabarit inclus ([_1]).',
	'One or more errors were found in this template.' => 'Une ou plusieurs erreurs ont été trouvées dans ce gabarit.',
	'Orphaned' => 'Orphelin',
	'Refreshing template <strong>[_3]</strong> after making <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>.' => 'Réactualiser les gabarits <strong>[_3]</strong> depuis <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">la sauvegarde</a>',
	'Saving map failed: [_1]' => 'Échec lors du rattachement : [_1]',
	'Setting up mappings failed: [_1]' => 'La mise en oeuvre des mappings a échoué : [_1]',
	'System Templates' => 'Gabarits système',
	'Template Backups' => 'Sauvegardes de gabarit',
	'Template Modules' => 'Modules de gabarits',
	'Template Referesh' => 'Réactualisation de gabarit',
	'Unable to create preview file in this location: [_1]' => 'Impossible de créer le fichier de pré-visualisation à cet endroit : [_1]',
	'Unknown blog' => 'Blog inconnu',
	'Widget Template' => 'Gabarit de widget',
	'Widget Templates' => 'Gabarits de widget',
	'You must select at least one event checkbox.' => 'Vous devez cocher au moins une case événement.',
	'You must specify a template type when creating a template' => 'Vous devez spécifier un type de gabarit lors de sa création',
	'You should not be able to enter zero (0) as the time.' => 'Vous ne pouvez pas entrer zéro (0) comme heure.',
	'archive' => 'archive',
	'backup' => 'sauvegarder',
	'email' => 'Adresse e-mail',
	'index' => 'index',
	'module' => 'module',
	'sample, entry, preview' => 'extrait, note, prévisualisation',
	'system' => 'système',
	'template' => 'gabarit',
	'widget' => 'widget',
	q{Archive Templates} => q{Gabarits d'archives},
	q{Index Templates} => q{Gabarits d'index},
	q{Populating blog with default templates failed: [_1]} => q{L'activation sur le blog des gabarits par défaut a échoué : [_1]},
	q{Skipping template '[_1]' since it appears to be a custom template.} => q{Saut du gabarit '[_1]' car c'est un gabarit personnalisé.},
	q{Skipping template '[_1]' since it has not been changed.} => q{Saut du gabarit '[_1]' car il n'a pas été modifié.},
	q{Template '[_1]' (ID:[_2]) created by '[_3]'} => q{Gabarit '[_1]' (ID:[_2]) créé par '[_3]'},
	q{Template '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Gabarit '[_1]' (ID:[_2]) supprimé par '[_3]'},

## lib/MT/CMS/Theme.pm
	'All themes directories are not writable.' => 'Les répertoires des thèmes ne sont pas modifiables.',
	'Error occurred during finalizing [_1]: [_2]' => 'Erreur lors de la finalisation de [_1] : [_2]',
	'Error occurred while publishing theme: [_1]' => 'Erreur pendant la publication du thème : [_1]',
	'Failed to uninstall theme' => 'Impossible de désinstaller le thème',
	'Failed to uninstall theme: [_1]' => 'Impossible de désinstaller le thème : [_1]',
	'Install into themes directory' => 'Installer dans le répertoire des thèmes',
	'Theme from [_1]' => 'Thème de [_1]',
	'Theme not found' => 'Thème introuvable',
	q{Download [_1] archive} => q{Télécharger l'archive [_1]},
	q{Error occurred during exporting [_1]: [_2]} => q{Erreur lors de l'exportation de [_1] : [_2]},
	q{Failed to load theme export template for [_1]: [_2]} => q{Le chargement des gabarits d'exportation de thème a échoué pour [_1] : [_2]},
	q{Failed to save theme export info: [_1]} => q{La sauvegarde des informations d'exportation de thème a échoué : [_1]},
	q{Themes Directory [_1] is not writable.} => q{Le répertoire des thèmes [_1] n'est pas modifiable.},
	q{Themes directory [_1] is not writable.} => q{Le répertoire des thèmes [_1] n'est pas modifiable.},

## lib/MT/CMS/Tools.pm
	'Any site' => 'Tout site',
	'Backup & Restore' => 'Sauvegarder & Restaurer',
	'Cannot recover password in this configuration' => 'Impossible de récupérer le mot de passe dans cette configuration',
	'Copying file [_1] to [_2] failed: [_3]' => 'La copie du fichier [_1] vers [_2] a échoué : [_3]',
	'Could not remove backup file [_1] from the filesystem: [_2]' => 'Impossible de supprimer le fichier de sauvegarde [_1] du système de fichiers : [_2]',
	'Debug mode is [_1]' => 'Le mode de débogage est [_1]',
	'Email address not found' => 'Adresse e-mail introuvable',
	'Error occurred during restore process.' => 'Une erreur est survenue pendant la restauration.',
	'IP address lockout interval' => 'Intervalle de verrouillage pour les adresses IP',
	'IP address lockout limit' => 'Limite de verrouillage pour les adresses IP',
	'Invalid SitePath.  The SitePath should be valid and absolute, not relative' => 'SitePath invalide. Ce chemin doit être valide et absolu, pas relatif.',
	'Invalid author_id' => 'auteur_id incorrect',
	'Invalid email address' => 'Adresse e-mail invalide.',
	'Invalid password recovery attempt; Cannot recover the password in this configuration' => 'Tentative de récupération de mot de passe invalide. Impossible de recouvrer le mot de passe avec cette configuration.',
	'Invalid password recovery attempt; cannot recover password in this configuration' => 'Tentative de récupération de mot de passe invalide. Impossible de récupérer le mot de passe dans cette configuration',
	'Invalid password reset request' => 'Requête de réinitialisation de mot de passe invalide',
	'Lockout IP address whitelist' => 'Liste blanche de verrouillage pour les adresses IP',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1] : ',
	'Only to blogs within this system' => 'Seulement vers les blogs de ce système',
	'Outbound trackback limit is [_1]' => 'La limite de trackbacks sortants est [_1]',
	'Password Recovery' => 'Récupération de mot de passe',
	'Password reset token not found' => 'Jeton de réinitialisation du mot de passe introuvable',
	'Passwords do not match' => 'Les mots de passe ne correspondent pas',
	'Performance log threshold is [_1]' => 'La limite de la journalisation des performances est [_1]',
	'Performance logging is off' => 'La journalisation des performances est désactivée',
	'Performance logging is on' => 'La journalisation des performances est activée',
	'Please confirm your new password' => 'Merci de confirmer votre nouveau mot de passe',
	'Please enter a valid email address.' => 'Veuillez entrer une adresse e-mail valide.',
	'Please upload [_1] in this page.' => 'Merci de télécharger [_1] dans cette page.',
	'Prohibit comments is off' => 'Interdire les commentaires est inactif',
	'Prohibit comments is on' => 'Interdire les commentaires est actif',
	'Prohibit notification pings is off' => 'Interdire les notifications est inactif',
	'Prohibit notification pings is on' => 'Interdire les notifications est actif',
	'Prohibit trackbacks is off' => 'Interdire les trackbacks est inactif',
	'Prohibit trackbacks is on' => 'Interdire les trackbacks est actif',
	'Recipients for lockout notification' => 'Destinataires des notifications de verrouillage',
	'Specified file was not found.' => 'Le fichier spécifié est introuvable.',
	'Started restoring' => '', # Translate - New
	'Started restoring: [_1]' => '', # Translate - New
	'System Settings Changes Took Place' => 'Les changements des paramètres système ont pris place',
	'Temporary directory needs to be writable for backup to work correctly.  Please check (Export)TempDir configuration directive.' => 'Le répertoire temporaire doit être autorisé en écriture pour que la sauvegarde puisse fonctionner. Merci de vérifier la directive de configuration (Export)TempDir.',
	'Temporary directory needs to be writable for restore to work correctly.  Please check (Export)TempDir configuration directive.' => 'Le répertoire temporaire doit être autorisé en écriture pour que la restauration puisse fonctionner. Merci de vérifier la directive de configuration (Export)TempDir.',
	'This is the test email sent by Movable Type.' => 'Ceci est un e-mail de test envoyé par Movable Type.',
	'User lockout interval' => 'Intervalle de verrouillage pour les utilisateurs',
	'User lockout limit' => 'Limite de verrouillage pour les utilisateurs',
	'User not found' => 'Utilisateur introuvable',
	'Your request to change your password has expired.' => 'Votre demande de réinitialisation de mot de passe a expiré.',
	'[_1] is [_2]' => '[_1] est [_2]',
	'[_1] successfully downloaded backup file ([_2])' => '[_1] a téléchargé avec succès le fichier de sauvegarde ([_2])',
	q{A password reset link has been sent to [_3] for user  '[_1]' (user #[_2]).} => q{Un lien de réinitialisation du mot de passe a été envoyé à [_3] concernant l'utilisateur '[_1]' (utilisateur #[_2]).},
	q{Blog(s) (ID:[_1]) was/were successfully backed up by user '[_2]'} => q{Blog(s) (ID:[_1]) a/ont été sauvegardé(s) avec succès par l'utilisateur '[_2]'},
	q{Changing Archive Path for the blog '[_1]' (ID:[_2])...} => q{Changement du chemin d'archive pour le blog '[_1]' (ID:[_2])...},
	q{Changing Site Path for the blog '[_1]' (ID:[_2])...} => q{Changement du chemin du site pour le blog '[_1]' (ID:[_2])...},
	q{Changing URL for FileInfo record (ID:[_1])...} => q{Modification d'URL de l'enregistrement FileInfo (ID:[_1])...},
	q{Changing file path for FileInfo record (ID:[_1])...} => q{Modification du chemin de fichier de l'enregistrement FileInfo (ID:[_1])...},
	q{Changing file path for the asset '[_1]' (ID:[_2])...} => q{Changement de chemin de fichier pour l'élément '[_1]' (ID:[_2])...},
	q{Changing image quality is [_1]} => q{Le changement de qualité d'image est [_1]},
	q{Detailed information is in the activity log.} => q{Des informations détaillées se trouvent dans le journal d'activité.},
	q{E-mail was not properly sent. [_1]} => q{L'e-mail de test n'a pas pu être envoyé. [_1]},
	q{Email address is [_1]} => q{L'e-mail est [_1]},
	q{Email address is required for password reset.} => q{L'adresse e-mail est requise pour la réinitialisation du mot de passe.},
	q{Error occurred while attempting to [_1]: [_2]} => q{Une erreur s'est produite en essayant de [_1] : [_2]},
	q{Error sending e-mail ([_1]); Please fix the problem, then try again to recover your password.} => q{Impossible d'envoyer l'e-mail ([_1]). Veuillez corriger le problème puis réessayez de récupérer votre mot de passe.},
	q{File was not uploaded.} => q{Le fichier n'a pas été envoyé.},
	q{Image quality(JPEG) is [_1]} => q{La qualité d'image JPEG est [_1]},
	q{Image quality(PNG) is [_1]} => q{La qualité d'image PNG est [_1]},
	q{Manifest file '[_1]' is too large. Please use import direcotry for restore.} => q{Le fichier manifest '[_1]' est trop grand. Veuillez utiliser un répertoire d'importation pour la restauration.},
	q{Movable Type system was successfully backed up by user '[_1]'} => q{Movable Type a été sauvegardé avec succès par l'utilisateur '[_1]'},
	q{Performance log path is [_1]} => q{Le chemin d'accès à la journalisation des perfomances est [_1]},
	q{Please use xml, tar.gz, zip, or manifest as a file extension.} => q{Merci d'utiliser xml, tar.gz, zip, ou manifest comme extension de fichier.},
	q{Removing Archive Path for the blog '[_1]' (ID:[_2])...} => q{Suppression du chemin d'archive pour le blog '[_1]' (ID:[_2])...},
	q{Removing Site Path for the blog '[_1]' (ID:[_2])...} => q{Suppression du chemin du site pour le blog '[_1]' (ID:[_2])...},
	q{Restoring a file failed: } => q{Échec de la restauration d'un fichier : },
	q{Some [_1] were not restored because their parent objects were not restored.} => q{Certains [_1] n'ont pas été restaurés car leurs objets parents n'ont pas été restaurés.},
	q{Some objects were not restored because their parent objects were not restored.  Detailed information is in the activity log.} => q{Certains objets n'ont pas été restaurés car leurs objets parents n'ont pas été restaurés. Des informations détaillées se trouvent dans le journal d'activité.},
	q{Some objects were not restored because their parent objects were not restored.} => q{Certains objets n'ont pas été restaurés car leurs objets parents n'ont pas été restaurés.},
	q{Some of files could not be restored.} => q{Certains fichiers n'ont pu être restaurés.},
	q{Some of the actual files for assets could not be restored.} => q{Certains des fichiers des éléments n'ont pu être restaurés.},
	q{Some of the backup files could not be removed.} => q{Certains fichiers de sauvegarde n'ont pu être supprimés.},
	q{Some of the files were not restored correctly.} => q{Certains fichiers n'ont pas été restaurés correctement.},
	q{Successfully restored objects to Movable Type system by user '[_1]'} => q{Restauration avec succès des objets dans Movable Type par l'utilisateur '[_1]'},
	q{Test e-mail was successfully sent to [_1]} => q{L'e-mail de test a été envoyé avec succès à [_1]},
	q{Test email from Movable Type} => q{Tester l'e-mail depuis Movable Type},
	q{That action ([_1]) is apparently not implemented!} => q{Cette action ([_1]) n'est visiblement pas implémentée !},
	q{Uploaded file was not a valid Movable Type backup manifest file.} => q{Le fichier envoyé n'était pas un manifeste de sauvegarde Movable Type valide.},
	q{User '[_1]' (user #[_2]) does not have email address} => q{L'utilisateur '[_1]' (utilisateur #[_2]) n'a pas d'adresse e-mail},
	q{You do not have a system email address configured.  Please set this first, save it, then try the test email again.} => q{L'adresse e-mail système n'est pas configurée. Veuillez la configurer puis réessayez d'envoyer l'e-mail de test.},
	q{[_1] has canceled the multiple files restore operation prematurely.} => q{[_1] a annulé prématurément l'opération de restauration de plusieurs fichiers.},
	q{[_1] is not a directory.} => q{[_1] n'est pas un répertoire.},
	q{[_1] is not a number.} => q{[_1] n'est pas un nombre.},

## lib/MT/CMS/TrackBack.pm
	'(Unlabeled category)' => '(Catégorie sans description)',
	'(Untitled entry)' => '(Note sans titre)',
	'Orphaned TrackBack' => 'TrackBack orphelin',
	'category' => 'catégorie',
	q{No Excerpt} => q{Pas d'extrait},
	q{Ping (ID:[_1]) from '[_2]' deleted by '[_3]' from category '[_4]'} => q{Ping (ID:[_1]) de '[_2]' supprimé par '[_3]' de la catégorie '[_4]'},
	q{Ping (ID:[_1]) from '[_2]' deleted by '[_3]' from entry '[_4]'} => q{Ping (ID:[_1]) de '[_2]' supprimé par '[_3]' de la note '[_4]'},

## lib/MT/CMS/User.pm
	'(newly created user)' => '(utilisateur nouvellement créé)',
	'Another role already exists by that name.' => 'Un autre rôle existe déjà avec ce nom.',
	'Blogs Selected' => 'Blogs sélectionnés',
	'Cannot load role #[_1].' => 'Impossible de charger le rôle #[_1].',
	'Create User' => 'Créer un utilisateur',
	'Grant Permissions' => 'Ajouter des autorisations',
	'If personal blog is set, the personal blog location are required.' => 'Si un blog personnel est indiqué, la localisation du blog est nécessaire.',
	'Invalid type' => 'Type incorrect',
	'Minimum password length must be an integer and greater than zero.' => 'La longueur minimale du mot de passe doit être un entier supérieur à zéro.',
	'Role name cannot be blank.' => 'Le rôle ne peut pas être laissé vierge.',
	'Roles Selected' => 'Rôles sélectionnés',
	'Select Blogs' => 'Sélectionner des blogs',
	'Select Roles' => 'Sélectionnez des rôles',
	'Select Website' => 'Sélectionner des sites web',
	'Select a System Administrator' => 'Sélectionner un administrateur système',
	'Selected System Administrator' => 'Administrateur système sélectionné',
	'Selected author' => 'Auteur sélectionné',
	'System Administrator' => 'Administrateur système',
	'Website Name' => 'Nom du site web',
	'Websites Selected' => 'Sites web sélectionnés',
	'You cannot define a role without permissions.' => 'Vous ne pouvez pas définir un rôle sans autorisations.',
	'You cannot delete your own association.' => 'Vous ne pouvez pas supprimer votre propre association.',
	'You cannot delete your own user record.' => 'Vous ne pouvez pas effacer votre propre profil utilisateur.',
	'represents a user who will be created afterwards' => 'représente un utilisateur qui sera créé plus tard',
	q{Invalid ID given for personal blog clone location ID.} => q{L'ID communiqué est invalide pour un ID de localisation de blog clone personnel.},
	q{Invalid ID given for personal blog theme.} => q{L'ID communiqué est invalide pour un thème de blog personnel.},
	q{Select a entry author} => q{Sélectionner l'auteur de la note},
	q{Select a page author} => q{Sélectionner l'auteur de la page},
	q{User '[_1]' (ID:[_2]) could not be re-enabled by '[_3]'} => q{L'utilisateur '[_1]' (ID:[_2]) n'a pas pu être réactivé par '[_3]'},
	q{User '[_1]' (ID:[_2]) created by '[_3]'} => q{Utilisateur '[_1]' (ID:[_2]) créé par '[_3]'},
	q{User '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Utilisateur '[_1]' (ID:[_2]) supprimé par '[_3]'},
	q{User requires display name} => q{Un nom d'affichage est nécessaire pour l'utilisateur},
	q{User requires password} => q{L'utilisateur a besoin d'un mot de passe},
	q{User requires username} => q{Un nom d'utilisateur est nécessaire pour l'utilisateur},
	q{You have no permission to delete the user [_1].} => q{Vous n'avez pas l'autorisation d'effacer l'utilisateur [_1].},
	q{[_1]'s Associations} => q{Associations de [_1]},

## lib/MT/CMS/Website.pm
	'Cannot load website #[_1].' => 'Impossible de charger le site web #[_1].',
	'New Website' => 'Nouveau site web',
	'Selected Website' => 'Site web sélectionné',
	'Type a website name to filter the choices below.' => 'Entrez un nom de site web pour filtrer les choix ci-dessous.',
	q{Blog '[_1]' (ID:[_2]) moved from '[_3]' to '[_4]' by '[_5]'} => q{Blog '[_1]' (ID:[_2]) déplacé de '[_3]' à '[_4]' par '[_5]'},
	q{Website '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Site web '[_1]' (ID:[_2]) supprimé par '[_3]'},

## lib/MT/Category.pm
	'Categories must exist within the same blog' => 'Les catégories doivent exister au sein du même blog',
	'Category loop detected' => 'Boucle de catégorie détectée',
	'Parent' => 'Parent',
	'[quant,_1,entry,entries,No entries]' => '[quant,_1,note,notes,Pas de note]',
	'[quant,_1,page,pages,No pages]' => '[quant,_1,page,pages,Pas de page]',

## lib/MT/Comment.pm
	'(Deleted)' => '(supprimé)',
	'Approved' => 'Approuvé',
	'Comment' => 'Commentaire',
	'Commenter Status' => 'Status du commentateur',
	'Commenter' => 'Commentateur',
	'Comments in This Website' => 'Commentaires dans ce site web',
	'Comments in the last 7 days' => 'Commentaires des 7 derniers jours',
	'Comments on My Entries/Pages' => 'Commentaires sur mes notes/pages',
	'Comments on [_1]: [_2]' => 'Commentaires sur [_1] : [_2]',
	'Comments on my entries/pages' => 'Commentaires sur mes notes/pages',
	'Edit this [_1] commenter.' => 'Supprimer ce commentateur [_1]',
	'Entry/Page Status' => '', # Translate - New
	'Entry/Page' => 'Note/Page',
	'Not spam' => 'Non spam',
	'Pending comments' => 'Commentaires en attente',
	'Published comments' => 'Commentaires publiés',
	'Reported as spam' => 'Notifié comme spam',
	'Spam comments' => 'Commentaires marqués comme étant du spam',
	'Unapproved' => 'Non-approuvé',
	'__ANONYMOUS_COMMENTER' => 'Anonyme',
	q{All comments by [_1] '[_2]'} => q{Tous les commentaires par [_1] '[_2]'},
	q{Loading entry '[_1]' failed: [_2]} => q{La chargement de la note '[_1]' a échoué : [_2]},
	q{Non-spam comments on this website} => q{Commentaires n'étant pas du spam sur ce site web},
	q{Non-spam comments} => q{Commentaires marqués comme n'étant pas du spam},
	q{Search for other comments from anonymous commenters} => q{Chercher d'autres commentaires anynomes},
	q{Search for other comments from this deleted commenter} => q{Chercher d'autres commentaires de ce commentateur supprimé},

## lib/MT/Compat/v3.pm
	'No executable code' => 'Pas de code exécutable',
	'Publish-option name must not contain special characters' => 'La personnalisation du nom de publication ne doit pas contenir de caractères spéciaux',
	'uses [_1]' => 'utilise [_1]',
	'uses: [_1], should use: [_2]' => 'utilise : [_1], devrait utiliser : [_2]',

## lib/MT/Component.pm
	q{Loading template '[_1]' failed: [_2]} => q{Échec lors du chargement du gabarit '[_1]' : [_2]},

## lib/MT/Config.pm
	'Configuration' => 'Configuration',

## lib/MT/ConfigMgr.pm
	'Config directive [_1] without value at [_2] line [_3]' => 'Directive de Config  [_1] sans valeur sur [_2] ligne [_3]',
	q{Alias for [_1] is looping in the configuration.} => q{L'alias pour [_1] fait une boucle dans la configuration.},
	q{Error opening file '[_1]': [_2]} => q{Erreur lors de l'ouverture du fichier '[_1]' : [_2]},
	q{No such config variable '[_1]'} => q{Pas de telle variable de configuration '[_1]'},

## lib/MT/Core.pm
	'(system)' => '(système)',
	'<mt:var name="[_1]"> [_2] [_3] [_4]' => '<mt:var name="[_1]"> [_2] [_3] [_4]',
	'Add Summary Watcher to queue' => 'Ajoute un surveillant de résumés à la queue',
	'Adds Summarize workers to queue.' => 'Ajoute les robots de résumés à la queue.',
	'Blog ID' => 'ID du blog',
	'Blog URL' => 'URL du blog',
	'Change Settings' => 'Changer les paramètres',
	'Classic Blog' => 'Blog classique',
	'Convert Line Breaks' => 'Conversion retours ligne',
	'Create Blogs' => 'Créer des blogs',
	'Create Websites' => 'Créer des sites web',
	'Database Name' => 'Nom de la base de données',
	'Database Path' => 'Chemin de la base de données',
	'Database Port' => 'Port de la base de données',
	'Database Server' => 'Serveur de base de données',
	'Database Socket' => 'Socket de la base de données',
	'Date Created' => 'Date de création',
	'Date Modified' => 'Date de modification',
	'Days must be a number.' => 'Les jours doivent être un nombre.',
	'Edit All Entries' => 'Éditer toutes les entrées',
	'Entries List' => 'Liste des notes',
	'Entry Excerpt' => 'Extrait de la note',
	'Entry Extended Text' => 'Texte étendu de la note',
	'Entry Link' => 'Lien de la note',
	'Entry Title' => 'Titre de la note',
	'Filter' => 'Filtre',
	'Folder' => 'Répertoire',
	'Get Variable' => 'Récupérer la variable',
	'ID' => 'ID',
	'IP Banlist is disabled by system configuration.' => 'La configuration système a désactivé le banissement par adresse IP.',
	'IP Banning Settings' => 'Paramètres des IP bannies',
	'IP addresses' => 'Adresses IP',
	'If Block' => 'Bloc If',
	'If/Else Block' => 'Bloc If/Else',
	'Include Template File' => 'Inclure un fichier de gabarit',
	'Include Template Module' => 'Inclure un module de gabarit',
	'Junk Folder Expiration' => 'Expiration du répertoire de spam',
	'Log' => 'Journal',
	'Manage Assets' => 'Gérer les élements',
	'Manage Blog' => 'Gérer un blog',
	'Manage Categories' => 'Gérer les catégories',
	'Manage Commenters' => 'Gérer les auteurs de commentaire',
	'Manage Feedback' => 'Gérer les retours',
	'Manage Pages' => 'Gérer les pages',
	'Manage Plugins' => 'Gérer les plugins',
	'Manage Tags' => 'Gérer les tags',
	'Manage Templates' => 'Gérer les gabarits',
	'Manage Themes' => 'Gérer les thèmes',
	'Manage Users' => 'Gérer les utilisateurs',
	'Manage Website with Blogs' => 'Gérer un site web avec des blogs',
	'Manage Website' => 'Gérer un site web',
	'Member' => 'membre',
	'Movable Type Default' => 'Valeur par défaut Movable Type',
	'My Items' => 'Mes items',
	'My [_1]' => 'Mes [_1]',
	'MySQL Database (Recommended)' => 'Base de données MySQL (recommandée)',
	'Permission' => 'Autorisation',
	'Post Comments' => 'Commentaires de la note',
	'PostgreSQL Database' => 'Base de données PostgreSQL',
	'Publish Entries' => 'Publier les notes',
	'Publish Scheduled Entries' => 'Publier les notes planifiées',
	'Publishes content.' => 'Publication de contenu.',
	'Purge Stale DataAPI Session Records' => 'Purger les enregistrements des sessions DataAPI périmées',
	'Purge Stale Session Records' => 'Purger les enregistrements des sessions périmées',
	'Purge Unused FileInfo Records' => 'Vider les enregistrements d’informations de fichier inutilisés',
	'Refreshes object summaries.' => 'Réactualise les résumés des objets.',
	'Remove Compiled Template Files' => 'Supprimer les fichiers de gabarits compilés',
	'Remove Temporary Files' => 'Supprimer les fichiers temporaires',
	'Remove expired lockout data' => 'Supprimer les données des verrouillages expirés',
	'Rich Text' => 'Texte enrichi',
	'SQLite Database (v2)' => 'Base de données SQLite (v2)',
	'SQLite Database' => 'Base de données SQLite',
	'Send Notifications' => 'Envoyer des notifications',
	'Set Publishing Paths' => 'Régler les chemins de publication',
	'Set Variable Block' => 'Spécifier le bloc de variable',
	'Set Variable' => 'Spécifier la variable',
	'The physical file path for your SQLite database. ' => 'Le chemin du fichier physique de votre base de données SQLite. ',
	'Trackback' => 'TrackBack',
	'Unpublish Past Entries' => 'Dépublier les notes précédentes',
	'Widget Set' => 'Groupe de widgets',
	'[_1] [_2] between [_3] and [_4]' => '[_1] [_2] entre [_3] et [_4]',
	'[_1] [_2] future' => '[_1] [_2] futur',
	'[_1] [_2] or before [_3]' => '[_1] [_2] ou avant [_3]',
	'[_1] [_2] past' => '[_1] [_2] passé',
	'[_1] [_2] since [_3]' => '[_1] [_2] depuis [_3]',
	'[_1] [_2] these [_3] days' => '[_1] [_2] ces [_3] jours',
	'[_1] of this Website' => '[_1] de ce site web',
	'tar.gz' => 'tar.gz',
	'zip' => 'zip',
	q{Activity Feed} => q{Flux d'activité},
	q{Address Book is disabled by system configuration.} => q{La configuration système a désactivé le carnet d'adresse.},
	q{Author Name} => q{Nom de l'auteur},
	q{Create Entries} => q{Création d'une note},
	q{Error creating performance logs directory, [_1]. Please either change the permissions to make it writable or specify an alternate using the PerformanceLoggingPath configuration directive. [_2]} => q{Impossible de créer le répertoire des logs de performance, [_1]. Veuillez changer ses permissions pour qu'il soit modifiale ou spécifiez-en un autre via la directive de configuration PerformanceLoggingPath. [_2]},
	q{Error creating performance logs: PerformanceLoggingPath directory exists but is not writeable. [_1]} => q{Impossible de créer les logs de performance : le répertoire PerformanceLoggingPath existe mais n'est pas modifiable.},
	q{Error creating performance logs: PerformanceLoggingPath setting must be a directory path, not a file. [_1]} => q{Impossible de créer les logs de performance : PerformanceLoggingPath doit être le chemin d'un répertoire, pas d'un fichier. [_1]},
	q{Legacy Quick Filter} => q{Filtre rapide d'obsolescence},
	q{Manage Address Book} => q{Gérer l'annuaire},
	q{No Label} => q{Pas d'étiquette},
	q{Save Image Defaults} => q{Enregistrer les paramètres d'images par défaut},
	q{Synchronizes content to other server(s).} => q{Synchronise le contenu vers d'autres serveurs.},
	q{This is often 'localhost'.} => q{C'est généralement 'localhost'.},
	q{View Activity Log} => q{Afficher le journal d'activité},
	q{View System Activity Log} => q{Afficher le journal d'activité du système},
	q{option is required} => q{L'option est requise},

## lib/MT/DataAPI/Callback/Blog.pm
	'Invalid theme_id: [_1]' => 'theme_id invalide : [_1]',
	'The website root directory must be an absolute path: [_1]' => 'Le répertoire racine du site doit être un chemin absolu : [_1]',
	q{Cannot apply website theme to blog: [_1]} => q{Impossible d'appliquer le thème du site au blog : [_1]},

## lib/MT/DataAPI/Callback/Category.pm
	'Parent [_1] (ID:[_2]) not found.' => '[_1] parent (ID:[_2]) introuvable.',
	q{The label '[_1]' is too long.} => q{Le label '[_1]' est trop long.},

## lib/MT/DataAPI/Callback/Log.pm
	'A paramter "[_1]" is required.' => 'Un paramètre "[_1]" est requis.',
	'author_id (ID:[_1]) is invalid.' => 'author_id (ID:[_1]) est invalide.',
	q{Log (ID:[_1]) deleted by '[_2]'} => q{Log (ID:[_1]) supprimé par '[_2]'},
	'log' => 'Journal',

## lib/MT/DataAPI/Callback/Tag.pm
	'Invalid tag name: [_1]' => 'Nom de tag invalide : [_1]',

## lib/MT/DataAPI/Callback/TemplateMap.pm
	q{Invalid archive type: [_1]} => q{Type d'archive invalide : [_1]},

## lib/MT/DataAPI/Callback/User.pm
	'Invalid dateFormat: [_1]' => 'Paramètre "dateFormat" invalide : [_1]',
	'Invalid textFormat: [_1]' => 'Paramètre "textFormat" invalide : [_1]',

## lib/MT/DataAPI/Endpoint/Common.pm
	'Invalid dateFrom parameter: [_1]' => 'Le paramètre dateFrom est invalide : [_1]',
	'Invalid dateTo parameter: [_1]' => 'Le paramètre dateTo est invalide : [_1]',

## lib/MT/DataAPI/Endpoint/v2/Asset.pm
	'Invalid height: [_1]' => 'Hauteur invalide : [_1]',
	'Invalid scale: [_1]' => 'Échelle invalide : [_1]',
	'Invalid width: [_1]' => 'Largeur invalide : [_1]',
	'The asset does not support generating a thumbnail file.' => 'Cet élément ne permet pas de générer une vignette.',

## lib/MT/DataAPI/Endpoint/v2/BackupRestore.pm
	'An error occurred during the backup process: [_1]' => 'Une erreur est survenue pendant la sauvegarde : [_1]',
	'Invalid backup_archive_format: [_1]' => 'backup_archive_format invalide : [_1]',
	'Invalid backup_what: [_1]' => 'backup_what invalide : [_1]',
	'Invalid limit_size: [_1]' => 'limit_size invalide : [_1]',
	q{An error occurred during the restore process: [_1] Please check activity log for more details.} => q{Une erreur s'est produite pendant la procédure de restauration : [_1]. Merci de vous reporter au journal d\'activité pour plus de détails.},
	q{Make sure that you remove the files that you restored from the 'import' folder, so that if/when you run the restore process again, those files will not be re-restored.} => q{Assurez-vous d'avoir supprimé les fichiers que vous avez restaurés dans le répertoire 'import', ainsi, si vous restaurez à nouveau d'autres fichiers plus tard, les fichiers actuels ne seront pas restaurés une seconde fois.},

## lib/MT/DataAPI/Endpoint/v2/Blog.pm
	'Cannot create a blog under blog (ID:[_1]).' => 'Impossible de créer un blog sous le blog (ID:[_1]).',
	'Site not found' => 'Site introuvable',
	q{Either parameter of "url" or "subdomain" is required.} => q{L'un des paramètres "url" ou "subdomain" est requis.},
	q{Website "[_1]" (ID:[_2]) was not deleted. You need to delete the blogs under the website first.} => q{Le site web "[_1]" (ID:[_2]) n'a pas été supprimé. Vous devez d'abord supprimer tous les blogs qu'il contient.},

## lib/MT/DataAPI/Endpoint/v2/Entry.pm
	'A resource "[_1_]" is required.' => 'Une ressource "[_1_]" est requise.',
	'Invalid convert_breaks: [_1]' => 'Paramètre "convert_breaks" invalide [_1]',
	'Invalid default_cat_id: [_1]' => 'Paramètre "default_cat_id" invalide [_1]',
	'Invalid encoding: [_1]' => 'Paramètre "encoding" invalide [_1]',
	'Invalid import_type: [_1]' => 'Paramètre "import_type" invalide : [_1]',
	'Preview data not found.' => 'Données de prévisualisation introuvables.',
	'You need to provide a parameter "password" if you are going to create new users for each user listed in your blog.' => 'Vous devez fournir un paramètre "password" si vous voulez créer de nouveaux utilisateurs pour chaque utilisateur présent dans votre blog.',
	q{An error occurred during the import process: [_1]. Please check your import file.} => q{Une erreur s'est produite pendant le processus: [_1]. Merci de vérifier le fichier d'import.},
	q{Could not found archive template for [_1].} => q{Impossible de trouver un gabarit d'archive pour [_1].},
	q{Make sure that you remove the files that you imported from the 'import' folder, so that if/when you run the import process again, those files will not be re-imported.} => q{Assurez vous d'avoir bien enlevé les fichiers importés du répertoire 'import', pour éviter une ré-importation des mêmes fichiers à l'avenir.},

## lib/MT/DataAPI/Endpoint/v2/Log.pm
	'Log message' => 'Message du journal',

## lib/MT/DataAPI/Endpoint/v2/Page.pm
	q{'folder' parameter is invalid.} => q{Le paramètre 'folder' est invalide.},

## lib/MT/DataAPI/Endpoint/v2/Permission.pm
	'Role not found' => 'Rôle introuvable',
	q{Revoking permission failed: [_1]} => q{L'autorisation n'a pas pu être révoquée : [_1]},

## lib/MT/DataAPI/Endpoint/v2/Plugin.pm
	'Plugin not found' => 'Plugin introuvable',

## lib/MT/DataAPI/Endpoint/v2/Tag.pm
	'Cannot delete private tag associated with objects in system scope.' => 'Impossible de supprimer un tag privé associé à des objets au niveau système.',
	'Cannot delete private tag in system scope.' => 'Impossible de supprimer un tag privé au niveau système.',
	'Tag not found' => 'Tag introuvable',

## lib/MT/DataAPI/Endpoint/v2/Template.pm
	'A parameter "refresh_type" is invalid: [_1]' => 'Un paramètre "refresh_type" est invalide : [_1]',
	'A resource "template" is required.' => 'Une ressource "template" est requise.',
	'Cannot clone [_1] template.' => 'Impossible de dupliquer un gabarit [_1]',
	'Cannot delete [_1] template.' => 'Impossible de supprimer le gabarit [_1].',
	'Cannot publish [_1] template.' => 'Impossible de publier le gabarit [_1].',
	'Template not found' => 'Gabarit introuvable',

## lib/MT/DataAPI/Endpoint/v2/TemplateMap.pm
	q{Template "[_1]" is not an archive template.} => q{Le gabarit "[_1]" n'est pas un gabarit d'archive.},

## lib/MT/DataAPI/Endpoint/v2/Theme.pm
	'Cannot uninstall theme because the theme is in use.' => 'Impossible de désinstaller ce thème car il est utilisé.',
	'Cannot uninstall this theme.' => 'Impossible de désinstaller ce thème.',
	'Changing site theme failed: [_1]' => 'Impossible de changer le thème du site : [_1]',
	'theme_id may only contain letters, numbers, and the dash or underscore character. The theme_id must begin with a letter.' => 'theme_id ne peut contenir que des lettres, des chiffres et les caractères - et _.',
	'theme_version may only contain letters, numbers, and the dash or underscore character.' => 'theme_version ne peut contenir que des lettres, des chiffres et les caractères - et _.',
	q{Applying theme failed: [_1]} => q{Impossible d'appliquer le thème du site : [_1]},
	q{Cannot apply website theme to blog.} => q{Impossible d'appliquer le thème du site au blog.},
	q{Cannot install new theme with existing (and protected) theme's basename: [_1]} => q{Impossible d'installer un nouveau thème ayant le nom de base, protégé, d'un thème existant : [_1]},
	q{Export theme folder already exists '[_1]'. You can overwrite an existing theme with 'overwrite_yes=1' parameter, or change the Basename.} => q{Le dossier d'export du thème existe déjà '[_1]'. Vous pouvez l'écraser en ajoutant le paramètre 'overwrite_yes=1', ou changer le nom de base.},
	q{Unknown archiver type : $arctype} => q{Type d'archive inconnu : $arctype},

## lib/MT/DataAPI/Endpoint/v2/User.pm
	q{The email address provided is not unique. Please enter your username by "name" parameter.} => q{L'adresse e-mail fournie n'est pas unique. Entrez votre nom d'utilisateur via le paramètre "name".},

## lib/MT/DataAPI/Endpoint/v2/Widget.pm
	'Widget not found' => 'Widget introuvable',
	'Widgetset not found' => 'Ensemble de widgets introuvable',
	q{Removing Widget failed: [_1]} => q{Le widget n'a pas pu être supprimé : [_1]},

## lib/MT/DataAPI/Endpoint/v2/WidgetSet.pm
	'A resource "widgetset" is required.' => 'Une ressource "widgetset" est requise.',
	q{Removing Widgetset failed: [_1]} => q{L'ensemble de widgets n'a pas pu être supprimé : [_1]},

## lib/MT/DataAPI/Resource.pm
	q{Cannot parse "[_1]" as an ISO 8601 datetime} => q{Impossible d'interprêter "[_1]" comme une date ISO 8601},

## lib/MT/DefaultTemplates.pm
	'Category Entry Listing' => 'Liste des notes catégorisées',
	'Comment throttle' => 'Limitation des commentaires',
	'Commenter Confirm' => 'Confirmation du commentateur',
	'Commenter Notify' => 'Notification du commentateur',
	'Entry Notify' => 'Notification de note',
	'Monthly Entry Listing' => 'Liste des notes mensuelles',
	'New Comment' => 'Nouveau commentaire',
	'New Ping' => 'Nouveau ping',
	q{IP Address Lockout} => q{Verrouillage de l'adresse IP},
	q{User Lockout} => q{Verrouillage de l'utilisateur},

## lib/MT/Entry.pm
	'-' => '-',
	'Accept Comments' => 'Accepter les commentaires',
	'Accept Trackbacks' => 'Accepter les TrackBacks',
	'Date Commented' => 'Date du commentaire',
	'Draft Entries' => 'Brouillons de notes',
	'Draft' => 'Brouillon',
	'Entries by [_1]' => 'Notes de [_1]',
	'Entries from category: [_1]' => 'Notes de la catégorie : [_1]',
	'Entries in This Website' => 'Notes de ce site web',
	'Entries with Comments Within the Last 7 Days' => 'Notes avec commentaires ces 7 derniers jours',
	'Extended' => 'Étendu',
	'Format' => 'Format',
	'Future' => 'Futur',
	'Invalid arguments. They all need to be saved MT::Asset objects.' => 'Arguments invalides. Tous doivent être des objects MT::Asset sauvegardés.',
	'Invalid arguments. They all need to be saved MT::Category objects.' => 'Arguments invalides. Tous doivent être des objects MT::Category sauvegardés.',
	'Junk' => 'Indésirable',
	'My Entries' => 'Mes notes',
	'NONE' => 'Aucun fournisseur',
	'Primary Category' => 'Catégorie primaire',
	'Publish Date' => 'Date de publication',
	'Published Entries' => 'Notes publiées',
	'Published' => 'Publiée',
	'Review' => 'Vérification',
	'Reviewing' => 'En cours de relecture',
	'Scheduled Entries' => 'Notes en publication planifiée',
	'Spam' => 'Spam',
	'Unpublish Date' => 'Date de dépublication',
	'Unpublished (End)' => 'Dépubliées (Fin)',
	'Unpublished Entries' => 'Notes non publiées',
	'View [_1]' => 'Voir [_1]',
	'__PING_COUNT' => 'Nombre de pings',
	'basename is too long.' => '', # Translate - New
	q{Author ID} => q{ID de l'auteur},
	q{[_1] ( id:[_2] ) does not exists.} => q{[_1] (ID:[_2]) n'existe pas.},
	q{record does not exist.} => q{l'enregistrement n'existe pas.},

## lib/MT/FileMgr/DAV.pm
	'DAV connection failed: [_1]' => 'La connexion DAV a échoué : [_1]',
	'DAV get failed: [_1]' => 'La récupération DAV a échoué : [_1]',
	q{Creating path '[_1]' failed: [_2]} => q{Création du chemin '[_1]' a échoué : [_2]},
	q{DAV open failed: [_1]} => q{L'ouverture DAV a échoué : [_1]},
	q{DAV put failed: [_1]} => q{L'envoi DAV a échoué : [_1]},
	q{Deleting '[_1]' failed: [_2]} => q{La suppression de '[_1]' a échoué : [_2]},
	q{Renaming '[_1]' to '[_2]' failed: [_3]} => q{Le renommage de '[_1]' en '[_2]' a échoué : [_3]},

## lib/MT/FileMgr/SFTP.pm
	'SFTP connection failed: [_1]' => 'La connexion SFTP a échoué : [_1]',
	'SFTP get failed: [_1]' => 'La récupération SFTP a échoué : [_1]',
	q{SFTP put failed: [_1]} => q{L'envoi SFTP a échoué : [_1]},

## lib/MT/Filter.pm
	'"editable_terms" and "editable_filters" cannot be specified at the same time.' => '"editable_terms" et "editable_filters" ne peuvent pas être spécifiés en même temps.',
	'Filters' => 'Filtres',
	'Invalid filter type [_1]:[_2]' => 'Type de filtre invalide [_1] : [_2]',
	'Invalid sort key [_1]:[_2]' => 'Clé de tri invalide [_1] : [_2]',

## lib/MT/IPBanList.pm
	'IP Ban' => 'Interdiction IP',
	'IP Bans' => 'Interdictions IP',

## lib/MT/Image.pm
	'File size exceeds maximum allowed: [_1] > [_2]' => 'La taille du fichier dépasse le maximum autorisé : [_1] > [_2]',
	q{Invalid Image Driver [_1]} => q{Pilote d'image invalide [_1]},
	q{Saving [_1] failed: Invalid image file format.} => q{Échec de la sauvegarde [_1] : format d'image invalide.},

## lib/MT/Image/GD.pm
	'Cannot load GD: [_1]' => 'Impossible de charger GD : [_1]',
	'Rotate (degrees: [_1]) is not supported' => 'La rotation ([_1] degrés) est non supportée',
	'Unsupported image file type: [_1]' => 'Type de fichier image non supporté : [_1]',
	q{Reading file '[_1]' failed: [_2]} => q{La lecture du fichier '[_1]' a échoué : [_2]},
	q{Reading image failed: [_1]} => q{Échec de la lecture de l'image : [_1]},

## lib/MT/Image/ImageMagick.pm
	'Cannot load [_1]: [_2]' => '', # Translate - New
	'Flip horizontal failed: [_1]' => 'La symétrie horizontale a échoué : [_1]',
	'Flip vertical failed: [_1]' => 'La symétrie verticale a échoué : [_1]',
	'Rotate (degrees: [_1]) failed: [_2]' => 'La rotation ([_1] degrés) a échoué : [_2]',
	q{Converting image to [_1] failed: [_2]} => q{La conversion de l'image vers [_1] a échoué : [_2]},
	q{Cropping a [_1]x[_2] square at [_3],[_4] failed: [_5]} => q{Le retaillage d'un carré de [_1]x[_2] à [_3],[_4] a échoué : [_5]},
	q{Outputting image failed: [_1]} => q{La génération de l'image a échoué : [_1]},
	q{Scaling to [_1]x[_2] failed: [_3]} => q{La mise à l'échelle vers [_1]x[_2] a échoué : [_3]},

## lib/MT/Image/Imager.pm
	'Cannot load Imager: [_1]' => 'Impossible de charger Imager : [_1]',

## lib/MT/Image/NetPBM.pm
	'Cannot load IPC::Run: [_1]' => 'Impossible de charger IPC::Run : [_1]',
	'Cropping to [_1]x[_2] failed: [_3]' => 'Le retaillage vers [_1]x[_2] a échoué : [_3]',
	q{Reading alpha channel of image failed: [_1]} => q{La lecture du canal alpha de l'image a échoué : [_1]},
	q{You do not have a valid path to the NetPBM tools on your machine.} => q{Votre chemin d'accès vers les outils NetPBM est invalide sur votre machine.},

## lib/MT/Import.pm
	'Another system (Movable Type format)' => 'Autre système (format Movable Type)',
	q{Cannot open '[_1]': [_2]} => q{Impossible d'ouvrir '[_1]' : [_2]},
	q{Could not resolve import format [_1]} => q{Impossible de déterminer le format du fichier d'importation [_1]},
	q{Importing entries from file '[_1]'} => q{Importation des notes du fichier '[_1]'},
	q{No readable files could be found in your import directory [_1].} => q{Aucun fichier lisible n'a été trouvé dans le répertoire d'importation [_1].},

## lib/MT/ImportExport.pm
	'Need either ImportAs or ParentAuthor' => 'Soit ImportAs soit ParentAuthor est nécessaire',
	'No Blog' => 'Pas de blog',
	'Saving category failed: [_1]' => 'Échec de la sauvegarde de la catégorie : [_1]',
	'Saving comment failed: [_1]' => 'Échec de la sauvegarde du commentaire : [_1]',
	'Saving entry failed: [_1]' => 'Échec de la sauvegarde de la note : [_1]',
	'Saving ping failed: [_1]' => 'Échec de la sauvegarde du ping : [_1]',
	'ok (ID [_1])' => 'ok (ID [_1])',
	q{Cannot find existing entry with timestamp '[_1]'... skipping comments, and moving on to next entry.} => q{Impossible de trouver une note avec la date '[_1]'... abandon de ces commentaires, et passage à la note suivante.},
	q{Creating new category ('[_1]')...} => q{Création d'une nouvelle catégorie ('[_1]')...},
	q{Creating new comment (from '[_1]')...} => q{Création d'un nouveau commentaire (de '[_1]')...},
	q{Creating new ping ('[_1]')...} => q{Création d'un nouveau ping ('[_1]')...},
	q{Creating new user ('[_1]')...} => q{Création d'un nouvel utilisateur ('[_1]')...},
	q{Export failed on entry '[_1]': [_2]} => q{Échec de l'exportation sur la note '[_1]': [_2]},
	q{Importing into existing entry [_1] ('[_2]')} => q{Importation dans la note existante [_1] ('[_2]')},
	q{Invalid allow pings value '[_1]'} => q{Valeur du ping invalide '[_1]'},
	q{Invalid date format '[_1]'; must be 'MM/DD/YYYY HH:MM:SS AM|PM' (AM|PM is optional)} => q{Format de date invalide '[_1]'. Il doit être 'MM/JJ/AAAA HH:MM:SS AM|PM' (AM|PM est optionnel)},
	q{Invalid status value '[_1]'} => q{Valeur du statut invalide '[_1]'},
	q{Saving entry ('[_1]')...} => q{Enregistrement de la note ('[_1]')...},
	q{Saving user failed: [_1]} => q{Échec de la sauvegarde de l'utilisateur : [_1]},

## lib/MT/JunkFilter.pm
	'Action: Junked (score below threshold)' => 'Action : indésirable (score ci-dessous)',
	'Action: Published (default action)' => 'Action : publié (action par défaut)',
	'Composite score: [_1]' => 'Score composite : [_1]',
	'Junk Filter [_1] died with: [_2]' => 'Filtre indésirable [_1] mort avec : [_2]',
	'Unnamed Junk Filter' => 'Filtre indésirable sans nom',

## lib/MT/ListProperty.pm
	q{Cannot initialize list property [_1].[_2].} => q{Impossible d'initialiser la propriété de liste [_1].[_2].},
	q{Failed to initialize auto list property [_1].[_2]: Cannot find definition of column [_3].} => q{Impossible d'initialiser la propriété de liste automatique [_1].[_2] : la définition de la colonne [_3] est introuvable.},
	q{Failed to initialize auto list property [_1].[_2]: unsupported column type.} => q{Impossible d'initialiser la propriété de liste automatique [_1].[_2] : type de colonne non supporté.},

## lib/MT/Lockout.pm
	'IP Address Was Locked Out' => 'Cette adresse IP a été verrouillée',
	'User Was Locked Out' => 'Cet utilisateur a été verrouillé',
	q{IP address was locked out. IP address: [_1], Username: [_2]} => q{Cette adresse IP a été verrouillée. Adresse IP : [_1], Nom d'utilisateur : [_2]},
	q{User has been unlocked. Username: [_1]} => q{Cet utilisateur a été déverrouillé. Nom d'utilisateur : [_1]},
	q{User was locked out. IP address: [_1], Username: [_2]} => q{Cet utilisateur a été verrouillé. Adresse IP : [_1], Nom d'utilisateur : [_2]},

## lib/MT/Log.pm
	'Class' => 'Classe',
	'Comment # [_1] not found.' => 'Commentaire #[_1] introuvable.',
	'Debug' => 'Debug',
	'Debug/error' => 'Debug/erreur',
	'Entry # [_1] not found.' => 'Note #[_1] introuvable.',
	'Information' => 'Information',
	'Level' => 'Niveau',
	'Log messages' => 'Messages du journal',
	'Logs on This Website' => 'Journaux sur ce site',
	'Metadata' => 'Métadonnées',
	'Not debug' => 'Non debug',
	'Notice' => 'Information importante',
	'Page # [_1] not found.' => 'Page #[_1] introuvable.',
	'Security or error' => 'Sécurité ou erreur',
	'Security' => 'Sécurité',
	'Security/error/warning' => 'Sécurité/erreur/mise en garde',
	'Show only errors' => 'Montrer uniquement les erreurs',
	'TrackBack # [_1] not found.' => 'TrackBack #[_1] introuvable.',
	'Warning' => 'Attention',
	'author' => 'par auteurs',
	'folder' => 'répertoire',
	'page' => 'Page',
	'ping' => 'ping',
	'plugin' => 'plugin',
	'search' => 'rechercher',
	'theme' => 'thème',

## lib/MT/Mail.pm
	'Error connecting to SMTP server [_1]:[_2]' => 'Erreur de connexion au serveur SMTP [_1] : [_2]',
	'Following required module(s) were not found: ([_1])' => 'Module(s) requis introuvable(s) : ([_1])',
	q{Authentication failure: [_1]} => q{Échec de l'authentification : [_1]},
	q{Exec of sendmail failed: [_1]} => q{Échec de l'exécution de sendmail : [_1]},
	q{Unknown MailTransfer method '[_1]'} => q{Méthode de transfert d'e-mail inconnue '[_1]'},
	q{Username and password is required for SMTP authentication.} => q{Le nom utilisateur et le mot de passe sont requis pour l'authentification SMTP.},
	q{You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?} => q{Vous n'avez pas un chemin valide vers sendmail sur votre machine. Peut-être devriez-vous essayer en utilisant SMTP ?},

## lib/MT/Notification.pm
	'Click to edit contact' => 'Cliquer pour modifier le contact',
	'Contacts' => 'Contacts',

## lib/MT/ObjectAsset.pm
	'Asset Placement' => 'Gestion des éléments',

## lib/MT/ObjectScore.pm
	'Object Score' => 'Score Objet',
	'Object Scores' => 'Scores Objet',

## lib/MT/ObjectTag.pm
	'Tag Placement' => 'Gestion des tags',
	'Tag Placements' => 'Gestion des tags',

## lib/MT/Page.pm
	'(root)' => '(racine)',
	'Draft Pages' => 'Brouillons de pages',
	'Loading blog failed: [_1]' => 'Impossible de charger le blog : [_1]',
	'My Pages' => 'Mes pages',
	'Pages in This Website' => 'Pages dans ce site',
	'Pages in folder: [_1]' => 'Pages dans le dossier : [_1]',
	'Pages with comments in the last 7 days' => 'Pages commentées ces 7 derniers jours',
	'Published Pages' => 'Pages publiées',
	'Scheduled Pages' => 'Pages planifiées pour publication',
	'Unpublished Pages' => 'Pages non publiées',

## lib/MT/ParamValidator.pm
	'Invalid validation rules: [_1]' => '', # Translate - New
	'Unknown validation rule: [_1]' => '', # Translate - New
	q{'[_1]' has multiple values} => q{}, # Translate - New
	q{'[_1]' is required} => q{}, # Translate - New
	q{'[_1]' requires a valid ID} => q{}, # Translate - New
	q{'[_1]' requires a valid email} => q{}, # Translate - New
	q{'[_1]' requires a valid integer} => q{}, # Translate - New
	q{'[_1]' requires a valid number} => q{}, # Translate - New
	q{'[_1]' requires a valid objtype} => q{}, # Translate - New
	q{'[_1]' requires a valid string} => q{}, # Translate - New
	q{'[_1]' requires a valid text} => q{}, # Translate - New
	q{'[_1]' requires a valid word} => q{}, # Translate - New
	q{'[_1]' requires a valid xdigit value} => q{}, # Translate - New
	q{'[_1]' requires valid (concatenated) IDs} => q{}, # Translate - New
	q{'[_1]' requires valid (concatenated) words} => q{}, # Translate - New

## lib/MT/Placement.pm
	'Category Placement' => 'Gestion des catégories',

## lib/MT/Plugin.pm
	'My Text Format' => 'Format de mon texte.',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1] : [_2][_3] de la règle [_4][_5]',
	'[_1]: [_2][_3] from test [_4]' => '[_1] : [_2][_3] du test [_4]',

## lib/MT/PluginData.pm
	'Plugin Data' => 'Données plugin',

## lib/MT/Revisable.pm
	'Revision Number' => 'Numéro de révision',
	'Revision not found: [_1]' => 'Révision introuvable : [_1]',
	'Unknown method [_1]' => 'Méthode [_1] inconnue',
	q{Bad RevisioningDriver config '[_1]': [_2]} => q{Mauvaise configuration du pilote de révision '[_1]' : [_2]},
	q{Did not get two [_1]} => q{N'a pas obtenu deux [_1]},
	q{There are not the same types of objects, expecting two [_1]} => q{Ce ne sont pas les mêmes types d'objets, deux [_1] sont attendus},

## lib/MT/Role.pm
	'Blog Administrator' => 'Administrateur du blog',
	'Can administer the blog.' => 'Peut administrer le blog.',
	'Can administer the website.' => 'Peut administrer le site web.',
	'Can comment and manage feedback.' => 'Peut commenter et gérer les commentaires.',
	'Can comment.' => 'Peut commenter.',
	'Can create entries, edit their own entries, and comment.' => 'Peut créer des notes, éditer ses propres notes et commenter.',
	'Can create entries, edit their own entries, upload files and publish.' => 'Peut créer des notes, éditer ses propres notes, télécharger des fichiers et publier.',
	'Can edit, manage, and publish blog templates and themes.' => 'Peut éditer, gérer et publier les gabarits du blog et les thèmes.',
	'Can manage pages, upload files and publish blog templates.' => 'Peut gérer les pages, télécharger des fichiers et publier les gabarits du blog.',
	'Can upload files, edit all entries(categories), pages(folders), tags and publish the site.' => 'Peut télécharger des fichiers, éditer toutes les notes (catégories), pages (répertoires), tags et publier le site.',
	'Contributor' => 'Contributeur',
	'Designer' => 'Designer',
	'Editor' => 'Éditeur',
	'Moderator' => 'Modérateur',
	'Webmaster' => 'Webmaster',
	'Website Administrator' => 'Administrateur du site web',
	'__ROLE_ACTIVE' => 'En usage',
	'__ROLE_INACTIVE' => 'Pas en usage',
	'__ROLE_STATUS' => 'Statut',

## lib/MT/Scorable.pm
	'Already scored for this object.' => 'Cet objet a déjà été noté.',
	q{Could not set score to the object '[_1]'(ID: [_2])} => q{Impossible de stocker le score de l'objet '[_1]' (ID:[_2])},
	q{Object must be saved first.} => q{L'objet doit être d'abord sauvegardé.},

## lib/MT/Session.pm
	'Session' => 'Session',

## lib/MT/TBPing.pm
	'<a href="[_1]">Ping from: [_2] - [_3]</a>' => '<a href="[_1]">Ping de : [_2] - [_3]</a>',
	'From' => 'De',
	'Pending trackbacks' => 'TrackBacks en attente',
	'Published trackbacks' => 'TrackBacks publiés',
	'Source Site' => 'Site source',
	'Source Title' => 'Titre de la source',
	'Spam trackbacks' => 'TrackBacks indésirables',
	'Target' => 'Cible',
	'TrackBack' => 'TrackBack',
	'Trackback Text' => 'Texte du TrackBack',
	'Trackbacks in the last 7 days' => 'TrackBacks des 7 derniers jours',
	'Trackbacks on My Entries/Pages' => 'TrackBacks sur mes notes/pages',
	'Trackbacks on [_1]: [_2]' => 'TrackBacks sur [_1] : [_2]',
	'Trackbacks on my entries/pages' => 'TrackBacks sur mes notes/pages',
	q{Non-spam trackbacks on this website} => q{TrackBacks n'étant pas du spam sur ce site web},
	q{Non-spam trackbacks} => q{TrackBacks n'étant pas du spam},

## lib/MT/Tag.pm
	'Not Private' => 'Public',
	'Private' => 'Privé',
	'Tag must have a valid name' => 'Le tag doit avoir un nom valide',
	'Tags with Assets' => 'Tags avec éléments',
	'Tags with Entries' => 'Tags avec notes',
	'Tags with Pages' => 'Tags avec pages',
	q{This tag is referenced by others.} => q{Ce tag est référencé par d'autres.},

## lib/MT/TaskMgr.pm
	'Scheduled Tasks Update' => 'Mise à jour des tâches planifiées',
	'The following tasks were run:' => 'Les tâches suivantes ont été exécutées :',
	q{Error during task '[_1]': [_2]} => q{Erreur pendant la tâche '[_1]' : [_2]},
	q{Unable to secure a lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.} => q{Impossible d'obtenir un verrou pour l'exécution des tâches système. Vérifiez que le répertoire défini par TempDir ([_1]) est modifiable.},

## lib/MT/Template.pm
	'Build Type' => 'Type de publication',
	'Category Archive' => 'Archive de catégorie',
	'Comment Error' => 'Erreur de commentaire',
	'Comment Pending' => 'Commentaire en attente',
	'Dynamicity' => 'Dynamicité',
	'Index' => 'Index',
	'Individual' => '', # Translate - New
	'Interval' => 'Interval',
	'Module' => 'Module',
	'Output File' => 'Fichier de sortie',
	'Ping Listing' => 'Liste des pings',
	'Rebuild with Indexes' => 'Republier avec les index',
	'Template Text' => 'Texte de gabarit',
	'Template load error: [_1]' => 'Erreur de chargement de gabarit : [_1]',
	'Template name must be unique within this [_1].' => 'Le nom du gabarit doit être unique dans ce [_1].',
	'Template' => 'gabarit',
	'Uploaded Image' => 'Image téléchargée',
	'Widget' => 'Widget',
	q{Error reading file '[_1]': [_2]} => q{Erreur à la lecture du fichier '[_1]' : [_2]},
	q{Load of blog '[_1]' failed: [_2]} => q{Le chargement du blog '[_1]' a échoué : [_2]},
	q{Opening linked file '[_1]' failed: [_2]} => q{L'ouverture du fichier lié '[_1]' a échoué : [_2] },
	q{Publish error in template '[_1]': [_2]} => q{Erreur de publication dans le gabarit '[_1]': [_2]},
	q{Tried to load the template file from outside of the include path '[_1]'} => q{Tentative de chargement du gabarit en dehors du chemin d’inclusion '[_1]'},
	q{You cannot use a [_1] extension for a linked file.} => q{Vous ne pouvez pas utiliser l'extension [_1] pour un fichier joint.},

## lib/MT/Template/Context.pm
	'When the same blog IDs are simultaneously listed in the include_blogs and exclude_blogs attributes, those blogs are excluded.' => 'Lorsque les mêmes IDs de blog sont listés simultanément dans les attributs include_blogs et exclude_blogs, ces blogs sont exclus.',
	q{The attribute exclude_blogs cannot take '[_1]' for a value.} => q{L'attribut exclude_blogs ne peut pas prendre '[_1]' pour valeur.},
	q{You have an error in your '[_2]' attribute: [_1]} => q{Vous avez une erreur dans votre attribut '[_2]' : [_1]},
	q{You used an '[_1]' tag inside of the context of a blog which has no parent website; Perhaps your blog record is broken?} => q{Vous avez utilisé une balise '[_1]' dans le  contexte d'un blog sans site web parent. L'enregistrement de ce blog est peut-être endommagé.},
	q{You used an '[_1]' tag outside of the context of a author; Perhaps you mistakenly placed it outside of an 'MTAuthors' container tag?} => q{Vous avez utilisé une balise '[_1]' en dehors d'un contexte auteur. Peut-être l'avez-vous placée par erreur en dehors d'un bloc 'MTAuthors' ?},
	q{You used an '[_1]' tag outside of the context of a comment; Perhaps you mistakenly placed it outside of an 'MTComments' container tag?} => q{Vous avez utilisé une balise '[_1]' en dehors d'un contexte de commentaire. Peut-être l'avez-vous placée par erreur en dehors d'un bloc 'MTComments' ?},
	q{You used an '[_1]' tag outside of the context of a page; Perhaps you mistakenly placed it outside of a 'MTPages' container tag?} => q{Vous avez utilisé une balise '[_1]' en dehors d'un contexte de page. Peut-être l'avez-vous placée par erreur en dehors d'un bloc 'MTPages' ?},
	q{You used an '[_1]' tag outside of the context of a ping; Perhaps you mistakenly placed it outside of an 'MTPings' container tag?} => q{Vous avez utilisé une balise '[_1]' en dehors d'un contexte de ping. Peut-être l'avez-vous placée par erreur en dehors d'un bloc 'MTPings' ?},
	q{You used an '[_1]' tag outside of the context of an asset; Perhaps you mistakenly placed it outside of an 'MTAssets' container tag?} => q{Vous avez utilisé une balise '[_1]' en dehors d'un contexte d'élément. Peut-être l'avez-vous placée par erreur en dehors d'un bloc 'MTAssets' ?},
	q{You used an '[_1]' tag outside of the context of an entry; Perhaps you mistakenly placed it outside of an 'MTEntries' container tag?} => q{Vous avez utilisé une balise '[_1]' en dehors d'un contexte de note. Peut-être l'avez-vous placée par erreur en dehors d'un bloc 'MTEntries' ?},
	q{You used an '[_1]' tag outside of the context of the blog; Perhaps you mistakenly placed it outside of an 'MTBlogs' container tag?} => q{Vous avez utilisé une balise '[_1]' en dehors d'un contexte de blog. Peut-être l'avez-vous placée par erreur en dehors d'un bloc 'MTBlogs' ?},
	q{You used an '[_1]' tag outside of the context of the website; Perhaps you mistakenly placed it outside of an 'MTWebsites' container tag?} => q{Vous avez utilisé une balise '[_1]' en dehors d'un contexte de site web. Peut-être l'avez-vous placée par erreur en dehors d'un bloc 'MTWebsites' ?},

## lib/MT/Template/ContextHandlers.pm
	', letters and numbers' => ', lettres et chiffres',
	', symbols (such as #!$%)' => ', caractères spéciaux (comme #!$%)',
	', uppercase and lowercase letters' => ', lettres en minuscule et majuscule',
	'Actions' => 'Actions',
	'All About Me' => 'Tout sur moi',
	'Division by zero.' => 'Division par zéro.',
	'Error in [_1] [_2]: [_3]' => 'Erreur dans [_1] [_2] : [_3]',
	'Error in file template: [_1]' => 'Erreur dans fichier gabarit : [_1]',
	'Invalid index.' => 'Index invalide',
	'No [_1] could be found.' => 'Pas trouvé de [_1].',
	'No template to include was specified' => 'Aucun gabarit spécifié pour inclusion',
	'Recursion attempt on [_1]: [_2]' => 'Tentative de récursion sur [_1] : [_2]',
	'Recursion attempt on file: [_1]' => 'Tentative de récursion sur le fichier : [_1]',
	'Remove this widget' => 'Supprimer ce widget',
	'You used a [_1] tag without a valid name attribute.' => 'Vous avez utilisé une balise [_1] sans un attribut de nom valide',
	'You used an [_1] tag without a valid [_2] attribute.' => 'Vous avez utilisé une balise [_1] sans un attribut [_2] valide.',
	'[_1] [_2]' => '[_1] [_2]',
	'[_1]Publish[_2] your [_3] to see these changes take effect.' => '[_1]Publiez[_2] votre [_3] pour que ces changements soient appliqués.',
	'[_1]Publish[_2] your site to see these changes take effect, even when publishing profile is dynamic publishing.' => '', # Translate - New
	'[_1]Publish[_2] your site to see these changes take effect.' => '[_1]Publiez[_2] votre site pour que ces changements soient appliqués.',
	'blog(s)' => 'blog(s)',
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.org/documentation/appendices/tags/%t.html',
	'minimum length of [_1]' => 'longueur minimum de [_1]',
	'records' => 'enregistrements',
	'website(s)' => 'site(s) web',
	q{'[_1]' is not a hash.} => q{'[_1]' n'est pas un hash},
	q{'[_1]' is not a valid function for a hash.} => q{'[_1]' n'est pas une fonction valide pour un hash},
	q{'[_1]' is not a valid function for an array.} => q{'[_1]' n'est pas une fonction valide pour un tableau},
	q{'[_1]' is not a valid function.} => q{'[_1]' n'est pas une fonction valide},
	q{'[_1]' is not an array.} => q{'[_1]' n'est pas un tableau},
	q{'parent' modifier cannot be used with '[_1]'} => q{Le modifieur 'parent' ne peut pas être utilisé avec '[_1]'},
	q{Cannot find blog for id '[_1]} => q{Impossible de trouver un blog ayant pour ID '[_1]},
	q{Cannot find entry '[_1]'} => q{Impossible de trouver la note '[_1]'},
	q{Cannot find included file '[_1]'} => q{Impossible de trouver le fichier inclus '[_1]'},
	q{Cannot find included template [_1] '[_2]'} => q{Impossible de trouver le gabarit inclus [_1] '[_2]'},
	q{Cannot find template '[_1]'} => q{Impossible de trouver le gabarit '[_1]'},
	q{Cannot load user.} => q{Impossible de charger l'utilisateur.},
	q{Error opening included file '[_1]': [_2]} => q{Erreur à l'ouverture du fichier inclus '[_1]' : [_2]},
	q{File inclusion is disabled by "AllowFileInclude" config directive.} => q{L'inclusion de fichier est désactivée par la directive de configuration "AllowFileInclude".},
	q{Unspecified archive template} => q{Gabarit d'archive non spécifié},
	q{Writing to '[_1]' failed: [_2]} => q{L'écriture sur '[_1]' a échoué : [_2]},
	q{You used an [_1] tag without a date context set up.} => q{Vous utilisez une balise [_1] hors d'un contexte de date.},
	q{[_1] is not a hash.} => q{[_1] n'est pas un hash},

## lib/MT/Template/Tags/Archive.pm
	'Group iterator failed.' => 'Le répéteur de groupe a échoué.',
	'You used an [_1] tag outside of the proper context.' => 'Vous avez utilisé une balise [_1] en dehors de son contexte propre.',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] est valide uniquement avec des archives quotidiennes, hebdomadaires ou mensuelles.',
	q{Could not determine entry} => q{La note n'a pu être déterminée},
	q{You used an [_1] tag for linking into '[_2]' archives, but that archive type is not published.} => q{Vous avez utilisé une balise [_1] pour créer un lien vers des archives '[_2]' , mais ce type d'archive n'est pas publié.},

## lib/MT/Template/Tags/Asset.pm
	q{No such user '[_1]'} => q{L'utilisateur '[_1]' n'existe pas},
	q{sort_by="score" must be used in combination with namespace.} => q{sort_by="score" doit être utilisé en combinaison avec l'espace de nom.},

## lib/MT/Template/Tags/Author.pm
	q{The '[_2]' attribute will only accept an integer: [_1]} => q{L'attribut '[_2]' n'accepte qu'un entier : [_1]},
	q{You used an [_1] without a author context set up.} => q{Vous avez utilisé un [_1] sans avoir configuré de contexte d'auteur.},

## lib/MT/Template/Tags/Calendar.pm
	'Invalid month format: must be YYYYMM' => 'Le format du mois est invalide : il doit être de la forme AAAAMM',
	'Invalid weeks_start_with format: must be Sun|Mon|Tue|Wed|Thu|Fri|Sat' => 'Format weeks_start_with invalide : doit être Sun|Mon|Tue|Wed|Thu|Fri|Sat',
	q{No such category '[_1]'} => q{La catégorie '[_1]' n'existe pas},

## lib/MT/Template/Tags/Category.pm
	'Cannot find package [_1]: [_2]' => 'Impossible de trouver le package [_1] : [_2]',
	'Error sorting [_2]: [_1]' => 'Erreur en classant [_2] : [_1]',
	'MT[_1] must be used in a [_2] context' => 'MT[_1] doit être utilisé dans le contexte [_2]',
	'[_1] used outside of [_2]' => '[_1] utilisé en dehors de [_2]',
	q{Cannot use sort_by and sort_method together in [_1]} => q{Impossible d'utiliser sort_by et sort_method ensemble dans ce [_1]},
	q{[_1] cannot be used without publishing Category archive.} => q{[_1] ne peut être utilisé sans la publication d'archives par catégorie.},

## lib/MT/Template/Tags/Comment.pm
	'Anonymous' => 'Anonyme',
	q{The MTCommentFields tag is no longer available.  Please include the [_1] template module instead.} => q{La balise MTCommentFields n'est plus disponible. Veuillez inclure le module de gabarit [_1] à la place.},
	q{To enable comment registration, you need to add a TypePad token in your weblog config or user profile.} => q{Pour activer l'enregistrement pour les commentaires, vous devez ajouter le jeton TypePad à votre configuration de blog ou profil utilisateur.},
	q{TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can not be used.} => q{L'authentification TypePad n'est pas activée sur ce blog. MTRemoteSignInLink ne peut être utilisé.},

## lib/MT/Template/Tags/Commenter.pm
	q{This '[_1]' tag has been deprecated. Please use '[_2]' instead.} => q{La balise '[_1]' est obsolète. Veuillez utiliser '[_2]' à la place.},

## lib/MT/Template/Tags/Entry.pm
	'Could not create atom id for entry [_1]' => 'Impossible de créer un ID Atom pour cette note [_1]',
	'You used <$MTEntryFlag$> without a flag.' => 'Vous utilisez <$MTEntryFlag$> sans drapeau.',

## lib/MT/Template/Tags/Misc.pm
	'name is required.' => 'le nom est requis.',
	q{Specified WidgetSet '[_1]' not found.} => q{Le groupe de widgets '[_1]' est introuvable.},

## lib/MT/Template/Tags/Ping.pm
	q{<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the 'category' attribute to the tag.} => q{<\$MTCategoryTrackbackLink\$> doit être utilisé dans le contexte d'une catégorie, ou avec l'attribut 'category' dans la balise.},

## lib/MT/TemplateMap.pm
	'Archive Mapping' => 'Table de correspondance des archives',
	'Archive Mappings' => 'Tables de correspondance des archives',

## lib/MT/TheSchwartz/Error.pm
	'Job Error' => 'Erreur de tâche',

## lib/MT/TheSchwartz/ExitStatus.pm
	'Job Exit Status' => 'Statut de fin de tâche',

## lib/MT/TheSchwartz/FuncMap.pm
	'Job Function' => 'Fonction de tâche',

## lib/MT/TheSchwartz/Job.pm
	'Job' => 'Tâche',

## lib/MT/Theme.pm
	'Default Pages' => 'Pages par défaut',
	'Default Prefs' => 'Préférences par défaut',
	'Failed to copy file [_1]:[_2]' => 'Échec de la copie du fichier [_1] : [_2]',
	'Failed to load theme [_1].' => 'Échec lors du chargement du thème [_1].',
	'Static Files' => 'Fichiers statiques',
	'Template Set' => 'Groupe de gabarits',
	q{A fatal error occurred while applying element [_1]: [_2].} => q{Une erreur fatale est survenue lors de l'application de l'élément [_1] : [_2].},
	q{An error occurred while applying element [_1]: [_2].} => q{Une erreur est survenue lors de l'application de l'élément [_1] : [_2].},
	q{Component '[_1]' version [_2] or greater is needed to use this theme, but is not installed.} => q{Le composant '[_1]' version [_2] ou supérieur est requis pour utiliser ce thème mais n'est pas installé.},
	q{Component '[_1]' version [_2] or greater is needed to use this theme, but the installed version is [_3].} => q{Le composant '[_1]' version [_2] ou supérieur est requis pour utiliser ce thème mais la version installée est [_3].},
	q{Element '[_1]' cannot be applied because [_2]} => q{L'élément '[_1] ne peut pas être appliqué à cause de [_2]},
	q{There was an error converting image [_1].} => q{Il y a eu une erreur lors de la conversion de l'image [_1].},
	q{There was an error creating thumbnail file [_1].} => q{Il y a eu une erreur lors de la création de la miniature de l'image [_1].},
	q{There was an error scaling image [_1].} => q{Il y a eu une erreur lors du redimensionnement de l'image [_1].},

## lib/MT/Theme/Category.pm
	'[_1] top level and [_2] sub categories.' => 'Niveau parent [_1] et catégories enfants [_2].',
	'[_1] top level and [_2] sub folders.' => 'Niveau parent [_1] et répertoires enfants [_2].',

## lib/MT/Theme/Element.pm
	q{An Error occurred while applying '[_1]': [_2].} => q{Une erreur est survenue en appliquant '[_1]' : [_2].},
	q{Compatibility error occurred while applying '[_1]': [_2].} => q{Une erreur de compatibilité est survenue en appliquant '[_1]' : [_2].},
	q{Component '[_1]' is not found.} => q{Le composant '[_1]' est introuvable.},
	q{Fatal error occurred while applying '[_1]': [_2].} => q{Une erreur fatale est survenue en appliquant '[_1]' : [_2].},
	q{Importer for '[_1]' is too old.} => q{L'importateur pour '[_1]' est trop vieux.},
	q{Internal error: the importer is not found.} => q{Erreur interne : l'importateur est introuvable.},
	q{Theme element '[_1]' is too old for this environment.} => q{L'élément de thème '[_1]' est trop vieux pour cet environnement.},

## lib/MT/Theme/Entry.pm
	'[_1] pages' => 'Pages [_1]',

## lib/MT/Theme/Pref.pm
	'default settings for [_1]' => 'paramètres par défaut pour [_1]',
	'default settings' => 'paramètres par défaut',
	q{Failed to save blog object: [_1]} => q{Échec de la sauvegarde de l'objet : [_1]},
	q{this element cannot apply for non blog object.} => q{cet élément ne peut pas s'appliquer sur un objet autre que blog.},

## lib/MT/Theme/TemplateSet.pm
	'A template set containing [quant,_1,template,templates], [quant,_2,widget,widgets], and [quant,_3,widget set,widget sets].' => 'Un ensemble de gabarits contenant [quant,_1,gabarit,gabarits], [quant,_2,widget,widgets], and [quant,_3,ensemble de widgets set,ensembles de widgets].',
	'Failed to make templates directory: [_1]' => 'Échec de la création des gabarits de répertoires : [_1]',
	'Failed to publish template file: [_1]' => 'Échec de la publication du fichier de gabarit : [_1]',
	'Widget Sets' => 'Groupes de widgets',
	'exported_template set' => 'Groupe exported_template',

## lib/MT/Upgrade.pm
	'Assigning entry comment and TrackBack counts...' => 'Attribution des nombres de commentaires et TrackBacks...',
	'Database has been upgraded to version [_1].' => 'La base de données a été mise à jour en version [_1].',
	'Error loading class [_1].' => 'Erreur en chargeant la classe [_1].',
	'Error loading class: [_1].' => 'Erreur de chargement de la classe : [_1].',
	'Invalid upgrade function: [_1].' => 'Fonction de mise à jour invalide : [_1].',
	'Upgrading database from version [_1].' => 'Mise à jour de la base de données depuis la version [_1].',
	'Upgrading table for [_1] records...' => 'Mise à jour des tables pour les enregistrements [_1]...',
	q{Error saving [_1] record # [_3]: [_2]...} => q{Erreur en sauvegardant l'enregistrement [_1] # [_3] : [_2]...},
	q{Plugin '[_1]' installed successfully.} => q{Le plugin '[_1]' a été installé correctement.},
	q{Plugin '[_1]' upgraded successfully to version [_2] (schema version [_3]).} => q{Plugin '[_1]' mis à jour avec succès en version [_2] (schéma version [_3]).},
	q{User '[_1]' installed plugin '[_2]', version [_3] (schema version [_4]).} => q{L'utilisateur '[_1]' a installé le plugin '[_2]', version [_3] (schéma version [_4]).},
	q{User '[_1]' upgraded database to version [_2]} => q{L'utilisateur '[_1]' a mis à jour la base de données en version [_2]},
	q{User '[_1]' upgraded plugin '[_2]' to version [_3] (schema version [_4]).} => q{L'utilisateur '[_1]' a mis à jour le plugin '[_2]' en version [_3] (schéma version [_4]).},

## lib/MT/Upgrade/Core.pm
	'Assigning category parent fields...' => 'Attribution des champs parents de la catégorie...',
	'Assigning custom dynamic template settings...' => 'Attribution des paramètres spécifiques de gabarit dynamique...',
	'Assigning template build dynamic settings...' => 'Attribution des paramètres de construction dynamique de gabarit...',
	'Assigning visible status for TrackBacks...' => 'Attribution du statut visible des TrackBacks...',
	'Assigning visible status for comments...' => 'Attribution du statut visible pour les commentaires...',
	'Creating initial website and user records...' => 'Création des enregistrements sites web et utilisateur initiaux...',
	'Expiring cached MT News widget...' => 'Invalidation du cache du widget MT News...',
	'First Website' => 'Premier site web',
	'Mapping templates to blog archive types...' => 'Mapping des gabarits vers les archives des blogs...',
	'Upgrading asset path information...' => 'Mise à jour du chemin des éléments...',
	q{Assigning user types...} => q{Attribution des types d'utilisateurs...},
	q{Creating new template: '[_1]'.} => q{Création d'un nouveau gabarit : '[_1]'.},
	q{Error creating role record: [_1].} => q{Erreur lors de la création de l'enregistrement du rôle : [_1]},
	q{Error saving record: [_1].} => q{Erreur d'enregistrement des informations : [_1].},

## lib/MT/Upgrade/v1.pm
	'Creating entry category placements...' => 'Création des placements des catégories des notes...',
	'Creating template maps...' => 'Création des tables de correspondances de gabarits...',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'Lien du gabarit [_1] vers [_2] ([_3]).',
	'Mapping template ID [_1] to [_2].' => 'Lien du gabarit [_1] vers [_2].',

## lib/MT/Upgrade/v2.pm
	'Assigning comment/moderation settings...' => 'Mise en place des paramètres commentaires/modération ...',
	'Updating category placements...' => 'Modification des placements de catégories...',

## lib/MT/Upgrade/v3.pm
	'Assigning basename for categories...' => 'Attribution de noms de base aux catégories...',
	'Assigning entry basenames for old entries...' => 'Ajout des racines des notes pour les anciennes notes...',
	'Assigning user status...' => 'Attribution du statut utilisateur...',
	'Creating configuration record.' => 'Création des infos de configuration.',
	'Custom ([_1])' => '([_1]) personnalisé',
	'Migrating any "tag" categories to new tags...' => 'Migration des catégories de "tag" vers de nouveaux tags...',
	'Migrating permissions to roles...' => 'Migration des autorisations vers les rôles...',
	'Removing Dynamic Site Bootstrapper index template...' => 'Suppression du gabarit index "Dynamic Site Bootstrapper"',
	'Setting blog basename limits...' => 'Spécification des limites des noms de base du blog...',
	'Setting new entry defaults for blogs...' => 'Réglage des valeurs par défaut des nouvelles notes pour les blogs...',
	'Updating blog comment email requirements...' => 'Mise à jour des prérequis des e-mails pour les commentaires du blog...',
	'Updating comment status flags...' => 'Modification des statuts des commentaires...',
	'Updating commenter records...' => 'Modification des données des auteurs de commentaire...',
	'Updating entry week numbers...' => 'Mise à jour des numéros des semaines de la note...',
	'Updating user permissions for editing tags...' => 'Modification des autorisations des utilisateurs pour modifier les balises...',
	q{Assigning blog administration permissions...} => q{Ajout des autorisations d'administration du blog...},
	q{Setting blog allow pings status...} => q{Mise en place du statut d'autorisation des pings...},
	q{Setting default blog file extension...} => q{Ajout de l'extension de fichier par défaut du blog...},
	q{Setting your permissions to administrator.} => q{Spécification des autorisations d'administrateur.},
	q{This role was generated by Movable Type upon upgrade.} => q{Ce rôle a été généré par Movable Type lors d'une mise à jour.},
	q{Updating blog old archive link status...} => q{Modification de l'ancien statut d'archive du blog...},
	q{Updating user web services passwords...} => q{Mise à jour des mots de passe des services web d'utilisateur...},

## lib/MT/Upgrade/v4.pm
	'Adding new feature widget to dashboard...' => 'Ajout du nouveau widget au tableau de bord...',
	'Assigning blog page layout...' => 'Attribution de la mise en page du blog...',
	'Assigning blog template set...' => 'Attribution du groupe de gabarits de blogs...',
	'Assigning junk status for TrackBacks...' => 'Attribution du statut spam pour les TrackBacks...',
	'Assigning junk status for comments...' => 'Attribution du statut spam pour les commentaires...',
	'Cannot rename in [_1]: [_2].' => 'Impossible de renommer dans [_1] : [_2].',
	'Classifying category records...' => 'Classement des données des catégories...',
	'Classifying entry records...' => 'Classement des données des notes...',
	'Comment Posted' => 'Commentaire envoyé',
	'Merging comment system templates...' => 'Assemblage des gabarits du système de commentaire...',
	'Migrating Nofollow plugin settings...' => 'Migration des paramètres du plugin Nofollow...',
	'Migrating role records to new structure...' => 'Migration des données de rôle vers la nouvelle structure...',
	'Migrating system level permissions to new structure...' => 'Migration des autorisations pour tout le système vers la nouvelle structure...',
	'Moving OpenID usernames to external_id fields...' => 'Déplacement des identifiants OpenID vers les champs external_id...',
	'Moving metadata storage for categories...' => 'Déplacement du stockage des métadonnées pour les catégories en cours...',
	'Populating authored and published dates for entries...' => 'Mise en place des dates de création et de publication des notes...',
	'Populating default file template for templatemaps...' => 'Mise en place du fichier gabarit par défaut pour les tables de correspondances de gabarits...',
	'Removing unnecessary indexes...' => 'Suppression des index non nécessaires...',
	'Removing unused template maps...' => 'Suppression des tables de correspondances de gabarits non utilisées...',
	'Renaming PHP plugin file names...' => 'Renommage des noms de fichier des plugins php...',
	'Replacing file formats to use CategoryLabel tag...' => 'Remplacement des formats de fichiers pour utiliser la balise CategoryLabel...',
	'Updating password recover email template...' => 'Template de réinitialisation du mot de passe en cours de mise à jour...',
	'Updating system search template records...' => 'Mise à jour des données du gabarit de recherche du système...',
	'Updating template build types...' => 'Mise à jour des types de construction de gabarits...',
	'Updating widget template records...' => 'Mise à jour des données des gabarits de widget...',
	'Upgrading metadata storage for [_1]' => 'Mise à jour du stockage des métadonnées pour [_1]',
	'Your comment has been posted!' => 'Votre commentaire a été envoyé !',
	'[_1]: [_2]' => '[_1] : [_2]',
	q{Assigning author basename...} => q{Attribution du nom de base de l'auteur...},
	q{Assigning embedded flag to asset placements...} => q{Attribution des drapeaux embarqués vers la gestion d'éléments...},
	q{Assigning user authentication type...} => q{Attribution du type d'authentification utilisateur...},
	q{Error renaming PHP files. Please check the Activity Log.} => q{Erreur pendant le renommage des fichiers PHP. Merci de vérifier le journal d'activité.},
	q{Migrating permission records to new structure...} => q{Migration des données d'autorisation vers la nouvelle structure...},
	q{Your comment submission failed for the following reasons:} => q{L'envoi de votre commentaire a échoué pour les raisons suivantes :},

## lib/MT/Upgrade/v5.pm
	'Adding notification dashboard widget...' => 'Ajout du widget de notification au tableau de bord...',
	'Assigning a language to each blog to help choose appropriate display format for dates...' => 'Assignation de la langue pour chaque blog afin de fciliter le choix du format des dates...',
	'Assigning to  [_1]...' => 'Assignation pour [_1]...',
	'Can edit, manage and publish blog templates and themes.' => 'Peut modifier, gérer et publier les gabarits et thèmes du blog.',
	'Can manage pages, Upload files and publish blog templates.' => 'Peut gérer les pages, télécharger des fichiers et publiuer les gabarits du blog.',
	'Classifying blogs...' => 'Classification des blogs...',
	'Designer (MT4)' => 'Designer (MT4)',
	'Generated a website [_1]' => 'Site web généré [_1]',
	'Generic Website' => 'Site web générique',
	'Granting new role to system administrator...' => 'Élévation du nouveau rôle vers administrateur système...',
	'Merging dashboard settings...' => 'Fusion des paramètres du tableau de bord...',
	'Migrating DefaultSiteURL/DefaultSiteRoot to website...' => 'Migration de DefaultSiteURL/DefaultSiteRoot vers site web...',
	'Migrating [_1]([_2]).' => 'Migration [_1] ([_2])',
	'Migrating existing [quant,_1,blog,blogs] into websites and their children...' => 'Migration de [quant,_1,blog,blogs] en sites web et leurs enfants...',
	'Migrating mtview.php to MT5 style...' => 'Migration de mtview.php vers le style MT5...',
	'Moved blog [_1] ([_2]) under website [_3]' => 'A déplacé le blog [_1] ([_2]) sous le site web [_3]',
	'New WebSite [_1]' => 'Nouveau site web [_1]',
	'Ordering Categories and Folders of Blogs...' => 'Tri des catégories et dossiers de blogs...',
	'Ordering Folders of Websites...' => 'Tri des dossiers de sites...',
	'Populating new role for theme...' => 'Génération du nouveau rôle pour le thème...',
	'Populating new role for website...' => 'Génération du nouveau rôle pour le site web...',
	'Rebuilding permissions...' => 'Republication des permissions...',
	'Removing technorati update-ping service from [_1] (ID:[_2]).' => 'Retrait du service de mise à jour ping Technorati de [_1] (ID:[_2]).',
	'Removing widget from dashboard...' => 'Retrait du widget du tableau de bord...',
	'Updating existing role name...' => 'Mise à jour du nom de rôle existant...',
	'Webmaster (MT4)' => 'Webmaster (MT4)',
	'_WEBMASTER_MT4' => 'Webmaster',
	q{An error occurred during generating a website upon upgrade: [_1]} => q{Une erreur est survenue lors de la génération d'un site web pendant la mise à jour : [_1]},
	q{An error occurred during migrating a blog's site_url: [_1]} => q{Une erreur est survenue pendant la migration de l'URL de site d'un blog : [_1]},
	q{Assigning ID of author for entries...} => q{Assignation de l'ID d'auteur pour les notes...},
	q{Assigning new system privilege for system administrator...} => q{Assignation des nouveaux privilèges système pour l'administrateur système...},
	q{Error loading role: [_1].} => q{Erreur lors du chargement d'un rôle : [_1].},
	q{New user's website} => q{Site web du nouvel utilisateur},
	q{Populating generic website for current blogs...} => q{Génération d'un site web générique pour les blogs actuels...},
	q{Recovering type of author...} => q{Récupération du type d'auteur...},
	q{Setting the 'created by' ID for any user for whom this field is not defined...} => q{Création de l'ID 'created by' pour chaque utilisateur pour qui ce champ est indéfini...},

## lib/MT/Upgrade/v6.pm
	'Adding "Site stats" dashboard widget...' => 'Ajout du widget "Statistiques du site" au tableau de bord...',
	'Adding Website Administrator role...' => 'Ajout du rôle Administrateur du blog...',
	'Fixing MTReleaseNumber...' => '', # Translate - New
	'Fixing TheSchwartz::Error table...' => 'Réparation de la table TheSchwartz::Error...',
	'Migrating current blog to a website...' => 'Migration du blog courant dans un site web...',
	'Migrating the record for recently accessed blogs...' => 'Migration des enregistrements des blogs récemments vus...',
	'Rebuilding permission records...' => 'Reconstruction des autorisations...',
	'Remove SQLSetNames...' => '', # Translate - New
	'Reorder DEBUG level' => '', # Translate - New
	'Reorder SECURITY level' => '', # Translate - New
	'Reorder WARNING level' => '', # Translate - New
	'Reordering dashboard widgets...' => 'Réarrangement des widgets du tableau de bord...',
	q{Migrating "This is you" dashboard widget...} => q{Migration du widget de tableau de bord "C'est vous"},

## lib/MT/Util.pm
	'[quant,_1,day,days] from now' => 'dans [quant,_1,jour,jours]',
	'[quant,_1,day,days]' => '[quant,_1,jour,jours]',
	'[quant,_1,day,days], [quant,_2,hour,hours] ago' => 'il y a [quant,_1,jour,jours], [quant,_2,heure,heures]',
	'[quant,_1,day,days], [quant,_2,hour,hours] from now' => 'dans [quant,_1,jour,jours], [quant,_2,heure,heures]',
	'[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,jour,jours], [quant,_2,heure,heures]',
	'[quant,_1,hour,hours] from now' => 'dans [quant,_1,heure,heures]',
	'[quant,_1,hour,hours]' => '[quant,_1,heure,heures]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => 'il y a [quant,_1,heure,heures], [quant,_2,minute,minutes]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => 'dans [quant,_1,heure,heures], [quant,_2,minute,minutes]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,heure,heures], [quant,_2,minute,minutes]',
	'[quant,_1,minute,minutes] from now' => 'dans [quant,_1,minute,minutes]',
	'[quant,_1,minute,minutes]' => '[quant,_1,minute,minutes]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => 'dans [quant,_1,minute,minutes], [quant,_2,seconde,secondes]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,minute,minutes], [quant,_2,seconde,secondes]',
	'[quant,_1,second,seconds] from now' => 'dans [quant,_1,seconde,secondes]',
	'[quant,_1,second,seconds]' => '[quant,_1,seconde,secondes]',
	'moments from now' => 'maintenant',
	q{Invalid domain: '[_1]'} => q{Domaine invalide: '[_1]'},
	q{less than 1 minute ago} => q{il y a moins d'une minute},
	q{less than 1 minute from now} => q{moins d'une minute à partir de maintenant},

## lib/MT/Util/Archive.pm
	'Type must be specified' => 'Le type doit être spécifié',
	q{Registry could not be loaded} => q{Le registre n'a pu être chargé},

## lib/MT/Util/Archive/BinTgz.pm
	'Both data and file name must be specified.' => 'Les données et le fichier doivent être spécifiés.',
	'Cannot find external archiver: [_1]' => '', # Translate - New
	'Failed to create an archive [_1]: [_2]' => '', # Translate - New
	'Type must be tgz.' => 'Le type doit être tgz.',
	q{Cannot extract from the object} => q{Impossible d'extraire l'objet},
	q{Cannot write to the object} => q{Impossible d'écrire l'objet},
	q{File [_1] exists; could not overwrite.} => q{Le fichier [_1] existe, impossible de l'écraser.},
	q{[_1] in the archive contains ..} => q{[_1] dans l'archive contient },
	q{[_1] in the archive is an absolute path} => q{[_1] dans l'archive est un chemin absolu},
	q{[_1] in the archive is not a regular file} => q{[_1] dans l'archive n'est pas un fichier valide},

## lib/MT/Util/Archive/BinZip.pm
	'Failed to rename an archive [_1]: [_2]' => '', # Translate - New
	'Type must be zip' => 'Le type doit être zip',

## lib/MT/Util/Archive/Tgz.pm
	'Could not read from filehandle.' => 'Impossible de lire le fichier.',
	q{File [_1] is not a tgz file.} => q{Le fichier [_1] n'est pas un fichier tgz.},

## lib/MT/Util/Archive/Zip.pm
	q{File [_1] is not a zip file.} => q{Le fichier [_1] n'est pas un fichier zip.},

## lib/MT/Util/Captcha.pm
	'Captcha' => 'CAPTCHA',
	'Image error: [_1]' => 'Erreur image : [_1]',
	'Movable Type default CAPTCHA provider requires Image::Magick.' => 'Le fournisseur de CAPTCHA par défaut de Movable Type nécessite Image::Magick.',
	'You need to configure CaptchaSourceImageBase.' => 'Vous devez configurer CaptchaSourceImagebase.',
	q{Image creation failed.} => q{Création de l'image échoué.},
	q{Type the characters you see in the picture above.} => q{Saisissez les caractères que vous voyez dans l'image ci-dessus.},

## lib/MT/Util/Log.pm
	'Cannot load Log module: [_1]' => 'Impossible de charger le module de journalisation : [_1]',
	'Logger configuration for Log module [_1] seems problematic' => '', # Translate - New
	'Unknown Logger Level: [_1]' => 'Niveau de journalisation inconnu : [_1]',

## lib/MT/Util/YAML.pm
	'Cannot load YAML module: [_1]' => 'Impossible de charger le module YAML : [_1]',
	'Invalid YAML module' => 'Module YAML invalide',

## lib/MT/WeblogPublisher.pm
	'Blog, BlogID or Template param must be specified.' => 'Les paramètres Blog, BlogID ou Template doivent être spécifiés.',
	'Scheduled publishing.' => 'Publication programmée.',
	q{An error occurred publishing [_1] '[_2]': [_3]} => q{Une erreur s'est produite lors de la publication [_1] '[_2]' : [_3]},
	q{An error occurred publishing date-based archive '[_1]': [_2]} => q{Une erreur s'est produite en publiant l'archive par dates '[_1]': [_2]},
	q{An error occurred while publishing scheduled entries: [_1]} => q{Une erreur s'est produite en publiant les notes planifiées : [_1]},
	q{An error occurred while unpublishing past entries: [_1]} => q{Une erreur s'est produite lors de la dépublication de notes passées : [_1]},
	q{Archive type '[_1]' is not a chosen archive type} => q{Le Type d'archive'[_1]' n'est pas un type d'archive sélectionné},
	q{Parameter '[_1]' is required} => q{Le paramètre '[_1]' est requis},
	q{Renaming tempfile '[_1]' failed: [_2]} => q{Le renommage de tempfile '[_1]' a échoué : [_2]},
	q{Template '[_1]' does not have an Output File.} => q{Le gabarit '[_1]' n'a pas de fichier de sortie.},
	q{The same archive file exists. You should change the basename or the archive path. ([_1])} => q{Le même fichier d'archive existe déjà. Vous devez changer le nom de base ou le chemin de l'archive. ([_1])},
	q{You did not set your blog publishing path} => q{Vous n'avez pas spécifié le chemin de publication de votre blog},
	'unpublish' => 'Dé-publier',

## lib/MT/Website.pm
	'__BLOG_COUNT' => 'Nombre de blogs',

## lib/MT/Worker/Publish.pm
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- configuration terminée ([quant,_1,fichier,fichiers] en [_2] secondes)',
	'Background Publishing Done' => 'Publication en tâche de fond terminée',
	'Error rebuilding file [_1]:[_2]' => 'Erreur lors de la reconstruction du fichier [_1] : [_2]',
	'Published: [_1]' => 'Publié : [_1]',

## lib/MT/Worker/Sync.pm
	'Done Synchornizing Files' => 'Synchronisation des fichiers effectuée',
	'Done syncing files to [_1] ([_2])' => 'Synchronisation des fichiers de [_1] ([_2]) terminée',
	qq{Error during rsync of files in [_1]:\n} => qq{Erreur lors de la synchronisation rsync des fichiers dans [_1] :\n},

## lib/MT/XMLRPC.pm
	'HTTP error: [_1]' => 'Erreur HTTP : [_1]',
	'No MTPingURL defined in the configuration file' => 'Pas de MTPingURL défini dans le fichier de configuration',
	'No WeblogsPingURL defined in the configuration file' => 'Pas de WeblogsPingURL défini dans le fichier de configuration',
	'Ping error: [_1]' => 'Erreur Ping : [_1]',

## lib/MT/XMLRPCServer.pm
	'Invalid timestamp format' => 'Format de date invalide',
	'No blog_id' => 'Pas de blog_id',
	'No filename provided' => 'Aucun nom de fichier',
	'No web services password assigned.  Please see your user profile to set it.' => 'Aucun mot de passe associé aux services web. Merci de vérifier votre profil utilisateur pour le définir.',
	'Not allowed to edit entry' => 'Non autorisé à modifier la note',
	'Not allowed to get entry' => 'Non autorisé à afficher la note',
	'Not allowed to set entry categories' => 'Non autorisé à modifier les catégories de la note',
	'Not allowed to upload files' => 'Non autorisé à télécharger des fichiers',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Le module Perl Image::Size est requis pour déterminer la largeur et la hauteur des images téléchargées.',
	'Saving folder failed: [_1]' => 'Échec de la sauvegarde du répertoire : [_1]',
	q{Entry '[_1]' ([lc,_5] #[_2]) deleted by '[_3]' (user #[_4]) from xml-rpc} => q{La note '[_1]' ([lc,_5] #[_2]) a été supprimée par '[_3]' (utilisateur #[_4]) depuis XML-RPC},
	q{Error writing uploaded file: [_1]} => q{Erreur lors de l'écriture du fichier téléchargé : [_1]},
	q{Requested permalink '[_1]' is not available for this page} => q{Le lien permanent requis '[_1]' n'est pas disponible pour cette page},
	q{Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.} => q{Les méthodes de gabarit ne sont pas implémentées en raison d'une différence entre l'API Blogger et l'API Movable Type.},
	q{Value for 'mt_[_1]' must be either 0 or 1 (was '[_2]')} => q{La valeur pour 'mt_[_1]' doit être 0 ou 1 (était '[_2]')},

## mt-check.cgi
	'(Probably) running under cgiwrap or suexec' => 'Exécuté (probablement) sous cgiwrap ou suexec',
	'Archive::Tar is required in order to manipulate files during backup and restore operations.' => 'Archive::Tar est nécessaire pour manipuler les fichiers lors des opérations de sauvegarde et de restauration.',
	'Archive::Zip is required in order to manipulate files during backup and restore operations.' => 'Archive::Zip est nécessaire pour manipuler les fichiers lors des opérations de sauvegarde et de restauration.',
	'Cache::Memcached and a memcached server are required to use in-memory object caching on the servers where Movable Type is deployed.' => 'Cache::Memcached et un serveur memcached sont nécessaires pour utiliser le cache mémoire des objets sur les serveurs où Movable Type est déployé.',
	'Checking for' => 'Vérification des',
	'Current working directory:' => 'Répertoire de travail courant :',
	'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI et DBD::Pg sont nécessaires si vous voulez utiliser une base de données PostgreSQL.',
	'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI et DBD::SQLite sont nécessaires si vous voulez utiliser une base de données SQLite.',
	'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI et DBD::SQLite2 sont nécessaires si vous voulez utiliser une base de données SQLite 2.x.',
	'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI et DBD::mysql sont nécessaires si vous voulez utiliser une base de données MySQL.',
	'DBI is required to store data in database.' => 'DBI est nécessaire pour enregistrer les données en base de données.',
	'Data Storage' => 'Stockage des données',
	'Details' => 'Détails',
	'IO::Compress::Gzip is required in order to compress files during backup operations.' => 'IO::Compress::Gzip est nécessaire pour comprimer les fichiers lors des opérations de sauvegarde.',
	'IO::Uncompress::Gunzip is required in order to decompress files during restore operation.' => 'IO::Uncompress::Gunzip est nécessaire pour décomprimer les fichiers lors des opérations de restauration.',
	'Installed' => 'Installé',
	'Movable Type System Check Successful' => 'Vérification du système Movable Type terminée avec succès.',
	'Movable Type System Check' => 'Vérification du système Movable Type',
	'Movable Type version:' => 'Version de Movable Type :',
	'Net::SMTP is required in order to send mail via an SMTP Server.' => 'Net::SMTP est nécessaire pour envoyer des e-mails via un serveur SMTP.',
	'Optional' => 'Optionnel',
	'Perl version:' => 'Version de Perl :',
	'Storable is optional; It is required by certain Movable Type plugins available from third-party developers.' => 'Storable est optionnel, ce module est requis par certains plugins de développeurs tiers.',
	'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the most current release available.' => 'La version installée de DBD::mysql est connue pour être incompatible avec Movable Type. Veuillez installer la dernière version disponible.',
	'The MT-Check report is disabled when Movable Type has a valid configuration file (mt-config.cgi)' => 'Le rapport MT-Check est désactivé lorsque Movable Type a un fichier de configuration (mt-config.cgi) valide',
	'The [_1] is installed properly, but requires an updated DBI module. Please see the note above regarding the DBI module requirements.' => '[_1] est installé correctement mais nécessite une version plus récente de DBI. Veuillez vous reporter à la note précédente concernant les pré-requis du module DBI.',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). Please upgrade to at least Perl [_2].' => 'La version de Perl installée sur votre serveur ([_1]) est inférieure au minimum requis ([_2]). Veuillez mettre à jour vers, au moins, Perl [_2].',
	'This module and its dependencies are required in order to operate Movable Type under psgi.' => 'Ce module et ses dépendances sont nécessaires pour faire fonctionner Movable Type en mode PSGI.',
	'This module is required by mt-search.cgi, if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'Ce module est requis par mt-search.cgi si vous faites fonctionner Movable Type avec une version de Perl antérieure à 5.8.',
	'This module required for action streams.' => '', # Translate - New
	'Web server:' => 'Serveur web :',
	'Your server has [_1] installed (version [_2]).' => 'Votre serveur possède [_1] (version [_2]).',
	'[_1] [_2] Modules' => '[_1] modules [_2]',
	'unknown' => 'inconnu',
	q{CGI::Cookie is required for cookie authentication.} => q{CGI::Cookie est nécessaire pour l'authentification via un cookie.},
	q{Cache::File is required if you would like to be able to allow commenters to authenticate via OpenID using Yahoo! Japan.} => q{Cache::File est requis si vous souhaitez autoriser les commentateurs à s'authentifier via OpenID depuis Yahoo! Japon.},
	q{Crypt::DSA is optional; If it is installed, comment registration sign-ins will be accelerated.} => q{Crypt::DSA est optionnel. S'il est installé, les créations de comptes d'auteurs de commemtaires seront plus rapides.},
	q{Digest::SHA1 and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.} => q{Digest::SHA1 et ses dépendances sont requises afin de permettre aux auteurs de commentaire d'être identifiés en utilisant les fournisseurs OpenID, comme LiveJournal.},
	q{File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.} => q{File::Temp est optionnel. Il est nécessaire si vous souhaitez être capable de ré-écrire certains fichiers lors d'envois.},
	q{HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in the configuration file.} => q{HTML::Entities est nécessaire pour encoder certains caractères mais cette fonctionnalité peut être désactivée en utilisant l'option NoHTMLEntities dans le fichier de configuration.},
	q{IPC::Run is optional; It is needed if you would like to use NetPBM as the image processor for Movable Type.} => q{IPC::Run est optionnel, c'est l'une des librairies graphiques permettant de créer des vignettes des images téléchargées.},
	q{Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).} => q{Image::Size est nécessaire pour l'envoi de fichiers (afin de déterminer la taille des images envoyées dans différents formats).},
	q{MIME::Base64 is required in order to enable comment registration and in order to send mail via an SMTP Server.} => q{MIME::Base64 est nécessaire pour autoriser l'enregistrement des commentaires et envoyer des e-mails via un serveur SMTP.},
	q{MT home directory:} => q{Répertoire d'accueil MT :},
	q{Operating system:} => q{Système d'exploitation :},
	q{Perl include path:} => q{Chemin d'inclusion Perl :},
	q{Please consult the installation instructions for help in installing [_1].} => q{Veuillez consulter les instructions d'installation pour obtenir de l'aide pour installer [_1].},
	q{SOAP::Lite is optional; It is needed if you want to use the MT XML-RPC server implementation.} => q{SOAP::Lite est optionnel. Il est nécessaire si vous souhaitez utiliser l'implementation serveur MT XML-RPC.},
	q{The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that they provide.} => q{Les modules suivants sont <strong>optionnels</strong>. Si votre serveur ne dispose pas de ces modules, vous n'avez besoin de les installer que si vous avez besoin de leurs fonctionnalités.},
	q{The following modules are required by databases that can be used with Movable Type. Your server must have DBI and at least one of these related modules installed for the application to work properly.} => q{Les modules suivants sont requis par les bases de données utilisables par Movable Type. DBI et au moins l'un des modules idoines doivent être installés sur votre serveur pour que l'application fonctionne.},
	q{The mt-check.cgi script provides you with information about your system's configuration and determines whether you have all of the components you need to run Movable Type.} => q{Le script mt-check.cgi vous fournit des informations sur la configuration de votre système et détermine si vous avez tous les composants nécessaires pour exécuter Movable Type.},
	q{XML::Atom is required in order to use the Atom API.} => q{XML::Atom est nécessaire afin d'utiliser l'API Atom.},
	q{XML::SAX and its dependencies are required to restore a backup created in a backup/restore operation.} => q{XML::SAX et ses dépendances sont nécessaires pour restaurer un fichier créé lors d'une opération de sauvegarde.},
	q{You attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.} => q{Vous avez tenté d'accéder à une fonctionnalité à laquelle vous n'avez pas droit. Si vous pensez que cette erreur n'est pas normale contactez votre administrateur système.},
	q{You're ready to go!} => q{Vous êtes prêt à continuer !},
	q{Your server does not have [_1] installed, or [_1] requires another module that is not installed.} => q{Votre serveur n'a pas [_1] d'installé ou [_1] nécessite un autre module qui n'est pas installé.},
	q{Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.} => q{Votre serveur dispose de tous les modules requis, vous n'avez pas besoin d'installer autre chose. Continuez avec les instructions d'installation.},
	q{[_1] is optional; It is a better, fast and lightweight alternative to YAML::Tiny for YAML file handling.} => q{[_1] est optionnel. C'est une meilleure alternative, plus rapide et plus légère, à YAML::Tiny pour le traitement des fichiers YAML.},
	q{[_1] is optional; It is one of the image processors that you can use to create thumbnails of uploaded images.} => q{[_1] est optionnel, c'est l'une des librairies graphiques permettant de créer des vignettes des images téléchargées.},
	q{[_1] is optional; It is one of the modules required to restore a backup created in a backup/restore operation} => q{[_1] est optionnel. C'est l'un des modules requis pour restaurer une sauvegarde créée par une opération de sauvegarde.},

## mt-static/jquery/jquery.mt.js
	'Invalid URL' => 'URL incorrecte',
	'Invalid date format' => 'Format de date incorrect',
	'Invalid value' => 'Valeur incorrecte',
	'This field is required' => 'Ce champ est requis',
	'This field must be a number' => 'Ce champ doit être un nombre',
	'This field must be an integer' => 'Ce champ doit être un entier',
	'You have an error in your input.' => 'Il y a une erreur dans votre entrée.',

## mt-static/js/assetdetail.js
	'Dimensions' => 'Dimensions',
	'File Name' => 'Nom de fichier',
	'No Preview Available.' => 'Pas de prévisualisation disponible',

## mt-static/js/dialog.js
	'(None)' => '(Aucun)',

## mt-static/js/tc/mixer/display.js
	'Author:' => 'Auteur :',
	'Description:' => 'Description :',
	'Tags:' => 'Tags :',
	'Title:' => 'Titre :',
	'URL:' => 'URL :',

## mt-static/js/upload_settings.js
	'You must set a path begining with %s or %a.' => 'Vous devez définir un chemin commençant par %s ou %a.',

## mt-static/mt.js
	'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => 'Voulez-vous vraiment supprimer les rôles [_1] ? Avec cette action vous allez supprimer les autorisations associées à tous les utilisateurs et groupes liés à ce rôle.',
	'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => 'Voulez-vous vraiment supprimer ce rôle ? En faisant cela vous allez supprimer les autorisations de tous les utilisateurs et groupes associés à ce rôle.',
	'Are you sure you want to [_2] this [_1]?' => 'Voulez-vous vraiment [_2] ce(tte) [_1] ?',
	'Are you sure you want to [_3] the [_1] selected [_2]?' => 'Voulez-vous vraiment [_3] les [_1] [_2] sélectionné(e)s ?',
	'First' => 'Premier',
	'Last' => 'Dernier',
	'Prev' => 'Précédent',
	'You can only act upon a maximum of [_1] [_2].' => 'Vous ne pouvez agir que sur un maximum de [_1] [_2].',
	'You can only act upon a minimum of [_1] [_2].' => 'Vous ne pouvez agir que sur un minimum de [_1] [_2].',
	'You must select an action.' => 'Vous devez sélectionner une action.',
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] de [_3]',
	'[_1] &ndash; [_2]' => '[_1] &ndash; [_2]',
	'delete' => 'supprimer',
	'disable' => 'désactiver',
	'enable' => 'activer',
	'publish' => 'publier',
	'remove' => 'retirer',
	'to mark as spam' => 'pour classer comme spam',
	'to remove spam status' => 'pour retirer le statut de spam',
	'unlock' => 'déverrouiller',
	q{Enter URL:} => q{Saisissez l'URL :},
	q{Enter email address:} => q{Saisissez l'adresse e-mail :},
	q{The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]' across all weblogs?} => q{Le tag '[_2]' existe déjà. Voulez-vous vraiment fusionner '[_1]' avec '[_2]' sur tous les blogs ?},
	q{The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]'?} => q{Le tag '[_2]' existe déjà. Voulez-vous vraiment fusionner '[_1]' avec '[_2]' ?},
	q{You did not select any [_1] [_2].} => q{Vous n'avez pas sélectionné de [_1] [_2].},
	q{You did not select any [_1] to [_2].} => q{Vous n'avez pas sélectionné de [_1] à [_2].},

## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => 'Insérez le texte formaté',

## mt-static/plugins/FormattedTextForTinyMCE/langs/template.js
	'Boilerplate' => 'Texte formaté',
	'Select Boilerplate' => 'Sélectionnez le texte formaté',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/advanced.js
	'Align Center' => 'Aligner au centre',
	'Align Left' => 'Aligner à gauche',
	'Align Right' => 'Aligner à droite',
	'Block Quotation' => 'Bloc de citation',
	'Bold (Ctrl+B)' => 'Gras (Ctrl+B)',
	'Horizontal Line' => 'Ligne horizontale',
	'Indent' => 'Indenter',
	'Insert/Edit Link' => 'Insérer/éditer un lien',
	'Italic (Ctrl+I)' => 'Italique (Ctrl+I)',
	'Ordered List' => 'Liste ordonnée',
	'Outdent' => 'Désindenter',
	'Redo (Ctrl+Y)' => 'Refaire (Ctrl+Y)',
	'Remove Formatting' => 'Supprimer le formatage',
	'Select Background Color' => 'Choisir la couleur du fond',
	'Select Text Color' => 'Choisir la couleur du texte',
	'Strikethrough' => 'Rayé',
	'Underline (Ctrl+U)' => 'Souligné (Ctrl+U)',
	'Undo (Ctrl+Z)' => 'Annuler (Ctrl+Z)',
	'Unlink' => 'Délier',
	'Unordered List' => 'Liste non ordonnée',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/core.js
	'Class Name' => 'Nom de la classe',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/insert_html.js
	'Insert HTML' => 'Insérer du HTML',
	'Source' => 'Source',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/plugin.js
	'Emphasis' => 'Emphase',
	'Insert Asset Link' => 'Insérer un lien de fichier',
	'Insert Image Asset' => 'Insérer une image',
	'Insert Link' => 'Insérer un lien',
	'List Item' => 'Item de liste',
	'Strong Emphasis' => 'Forte emphase',
	'Toggle Fullscreen Mode' => 'Bascule plein écran',
	'Toggle HTML Edit Mode' => 'Bascule mode code HTML',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/langs/plugin.js
	'Fullscreen' => 'Plein écran',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/paste/editor_plugin.js
	'paste.plaintext_mode' => 'paste.plaintext_mode',
	'paste.plaintext_mode_sticky' => 'paste.plaintext_mode_sticky',

## mt-static/plugins/TinyMCE/tiny_mce/themes/advanced/editor_template.js
	'advanced.path' => 'advanced.path',

## mt-static/plugins/TinyMCE/tiny_mce/themes/advanced/js/charmap.js
	'advanced_dlg.charmap_usage' => 'advanced_dlg.charmap_usage',

## mt-static/plugins/TinyMCE/tiny_mce/utils/editable_selects.js
	'value' => 'valeur',

## mt-static/plugins/TinyMCE5/lib/js/tinymce/plugins/mt/langs/plugin.js
	'Copy column' => '', # Translate - New
	'Cut column' => '', # Translate - New
	'Horizontal align' => '', # Translate - New
	'Paste column after' => '', # Translate - New
	'Paste column before' => '', # Translate - New
	'Vertical align' => '', # Translate - New

## mt-static/plugins/TinyMCE5/lib/js/tinymce/plugins/mt/plugin.js
	'HTML' => '', # Translate - New

## php/lib/block.mtassets.php
	'sort_by="score" must be used together with a namespace.' => 'sort_by="score" doit être utilisé avec un espace de noms.',

## php/lib/block.mtauthorhasentry.php
	'No author available' => 'Aucun auteur disponible',

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without establishing a date context.' => 'Vous avez utilisé une balise [_1] sans établir un contexte de date.',

## php/lib/block.mtif.php
	'You used an [_1] tag without a valid name attribute.' => 'Vous avez utilisé une balise [_1] sans attribut de nom valide.',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] est illégal.',

## php/lib/captcha_lib.php
	q{Type the characters shown in the picture above.} => q{Tapez les caractères affichés dans l'image ci-dessus.},

## php/lib/function.mtassettype.php
	'file' => 'fichier',
	'image' => 'image',

## php/lib/function.mtcommenternamethunk.php
	q{The '[_1]' tag has been deprecated. Please use the '[_2]' tag in its place.} => q{La balise '[_1]' est obsolète. Veuillez utiliser la balise '[_2]' à la place.},

## php/lib/function.mtremotesigninlink.php
	q{TypePad authentication is not enabled for this blog.  MTRemoteSignInLink cannot be used.} => q{L'authentification TypePad n'est pas activée pour ce blog. MTRemoteSignInLink ne peut pas être utilisé.},

## php/lib/mtdb.base.php
	'When the exclude_blogs and include_blogs attributes are used together, the same blog IDs should not be listed as parameters to both of them.' => 'Quand les attributs exclude_blogs et include_blogs sont utilisés ensemble, les mêmes identifiants de blog ne peuvent être fournis en paramètre de ces deux attributs.',

## php/mt.php
	'Page not found - [_1]' => 'Page non trouvée - [_1]',

## plugins/FacebookCommenters/config.yaml
	'Facebook' => '',
	'Provides commenter registration through Facebook Connect.' => '',

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm
	'Authentication failure: [_1], reason:[_2]' => '',
	'Could not verify this app with Facebook: [_1]' => '',
	'Facebook Commenters needs IO::Socket::SSL installed to communicate with Facebook.' => '',
	'Failed to create a session.' => '',
	'Failed to created commenter.' => '',
	'Please enter your Facebook App key and secret.' => '',
	'Set up Facebook Commenters plugin' => '',
	'The login could not be confirmed because of no/invalid blog_id' => '', # Translate - New

## plugins/FacebookCommenters/tmpl/blog_config_template.tmpl
	'Create Facebook App' => '',
	'Edit Facebook App' => '',
	'Facebook App ID' => '',
	'Facebook Application Secret' => '',
	'OAuth Redirect URL of Facebook Login' => '',
	'Please set this URL to "Valid OAuth redirect URIs" field of Facebook Login.' => '',
	'The key for the Facebook application associated with your blog.' => '',
	'The secret for the Facebook application associated with your blog.' => '',

## plugins/FormattedText/config.yaml
	'Manage boilerplate.' => 'Gérer le texte formaté',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected boilerplates?' => 'Voulez-vous vraiment supprimer les textes formatés sélectionnés ?',
	'Create New' => 'Créer...',
	'My Boilerplate' => 'Mon texte formaté',

## plugins/FormattedText/lib/FormattedText/DataAPI/Callback/FormattedText.pm
	q{The boilerplate '[_1]' is already in use in this site.} => q{Le texte formaté '[_1]' est déjà utilisé sur ce site.},

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'Boilerplates' => 'Textes formatés',
	q{The boilerplate '[_1]' is already in use in this blog.} => q{Le texte formaté '[_1]' est déjà utilisé sur ce blog.},

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Create Boilerplate' => 'Créer un texte formaté',
	'Edit Boilerplate' => 'Éditer le texte formaté',
	'Save changes to this boilerplate (s)' => 'Enregistrer les modifications de ce texte formaté (s)',
	'This boilerplate has been saved.' => 'Ce texte formaté a été enregistré.',

## plugins/FormattedText/tmpl/cms/list_formatted_text.tmpl
	'The boilerplate has been deleted from the database.' => 'Le texte formaté a été supprimé de la base de données.',

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => 'Ajoute le bouton "Insérer du texte formaté" à TinyMCE.',

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'Impossible de charger le texte formaté.',

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Select a Boilerplate' => 'Sélectionnez un texte formaté',

## plugins/GoogleAnalytics/config.yaml
	'Site statistics plugin using Google Analytics.' => 'Statistiques du site via Google Analytics.',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/App.pm
	'The name of the profile' => 'Le nom du profil',
	q{A Perl module required for using Google Analytics API is missing: [_1].} => q{Un module Perl requis pour utiliser l'API Google Analytics API est manquant : [_1].},
	q{The web property ID of the profile} => q{L'ID de propriété web du profil},
	q{You did not specify a client ID.} => q{Vous n'avez pas fourni d'ID client.},
	q{You did not specify a code.} => q{Vous n'avez pas fourni de code.},

## plugins/GoogleAnalytics/lib/GoogleAnalytics/OAuth2.pm
	'An error occurred when getting accounts: [_1]: [_2]' => 'Une erreur est survenue à la récupération des compte : [_1] : [_2]s',
	'An error occurred when getting profiles: [_1]: [_2]' => 'Une erreur est survenue à la récupération des profils : [_1] : [_2]',
	'An error occurred when getting token: [_1]: [_2]' => 'Une erreur est survenue à la récupération du jeton [_1] : [_2]',
	q{An error occurred when refreshing access token: [_1]: [_2]} => q{Une erreur est survenue au rafraîchissement du jeton d'accès : [_1] : [_2]},

## plugins/GoogleAnalytics/lib/GoogleAnalytics/Provider.pm
	'An error occurred when retrieving statistics data: [_1]: [_2]' => 'Une erreur est survenue à la récupération des données statistiques : [_1] : [_2]',

## plugins/GoogleAnalytics/tmpl/api_error.tmpl
	'API error' => 'Erreur API',

## plugins/GoogleAnalytics/tmpl/select_profile.tmpl
	'Select profile' => 'Sélectionner un profil',

## plugins/GoogleAnalytics/tmpl/web_service_config.tmpl
	'(No profile selected)' => '(Aucun profil sélectionné)',
	'Google Analytics 4 (GA4) is not supported.' => '',
	'Google Analytics profile' => 'Profil Google Analytics',
	'Google Analytics' => 'Google Analytics',
	'OAuth2 settings' => 'Paramètres OAuth2',
	'Other Google account' => 'Autre compte Google',
	'Select Google Analytics profile' => 'Sélectionnez le profil Google Analytics',
	'This [_2] is using the settings of [_1].' => 'Ce [_2] utilise les paramètres de [_1].',
	q{Client ID of the OAuth2 application} => q{ID Client de l'application OAuth2},
	q{Client ID or client secret for Google Analytics was changed, but profile was not updated. Are you sure you want to save these settings?} => q{L'ID ou le secret client de l'application OAuth2 a été modifié mais le profil n'a pas été mis à jour. Êtes-vous sûr de vouloir sauvegarder ces paramètres ?},
	q{Client secret of the OAuth2 application} => q{Secret Client de l'application OAuth2},
	q{Create an OAuth2 application's Client ID for web applications with this redirect URI via <a href="https://cloud.google.com/console" target="_blank">Google Cloud Platform</a> before selecting profile.} => q{Créez un ID client d'application OAuth2 pour application web avec cette URI de redirection via <a href="https://cloud.google.com/console" target="_blank">la plateforme Google Cloud/a> avant de sélectionner un profil.},
	q{Redirect URI of the OAuth2 application} => q{URL de redirection de l'application OAuth2},

## plugins/Markdown/Markdown.pl
	'A plain-text-to-HTML formatting plugin.' => 'Un plugin de formatage de texte brut vers HTML',
	'Markdown With SmartyPants' => 'Markdown avec SmartyPants',
	'Markdown' => 'Markdown',

## plugins/Markdown/SmartyPants.pl
	q{Easily translates plain punctuation characters into 'smart' typographic punctuation.} => q{Permet de convertir facilement des caractères de ponctuation basiques vers une ponctuation plus complexe (comme les guillemets, tirets, etc...)},

## plugins/MultiBlog/lib/MultiBlog.pm
	'Restoring MultiBlog rebuild trigger for blog #[_1]...' => 'Restauration du compteur de republication MultiBlog pour le blog #[_1]...',

## plugins/MultiBlog/lib/MultiBlog/Tags.pm
	'MTMultiBlog tags cannot be nested.' => 'Les balises MTMultiBlog ne peuvent pas être imbriquées.',
	q{Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".} => q{Valeur de l'attribut "mode" inconnue : [_1]. Les valeurs valides sont "loop" et "context".},

## plugins/MultiBlog/multiblog.pl
	'(All blogs in this website)' => '(Tous les blogs de ce site web)',
	'(All websites and blogs in this system)' => '(Tous les sites web et blogs de ce système)',
	'Create Trigger' => 'Créer un nouveau déclencheur',
	'MultiBlog' => 'MultiBlog',
	'Search Weblogs' => 'Rechercher les blogs',
	'Select to apply this trigger to all blogs in this website.' => 'Sélectionner pour appliquer ce déclencheur à tous les blogs de ce site web.',
	'Select to apply this trigger to all websites and blogs in this system.' => 'Sélectionner pour appliquer ce déclencheur à tous les sites web et blog de ce système.',
	'Updating the MultiBlog trigger cache...' => 'Mise à jour du cache des déclencheurs MultiBlog...',
	'Website/Blog' => 'Site web/blog',
	'When this' => 'Quand',
	'publishes a TrackBack' => 'un Trackback est publié',
	'publishes a comment' => 'un commentaire est publié',
	'publishes an entry/page' => 'une note/page est publiée',
	'rebuild indexes and send pings.' => 'reconstruire les index et envoyer les pings.',
	'rebuild indexes.' => 'reconstruire les index.',
	'saves an entry/page' => 'une note/page est sauvegardée',
	'unpublishes an entry/page' => 'une note/page est dépubliée',
	q{MultiBlog allows you to publish content from other blogs and define publishing rules and access controls between them.} => q{Multiblog vous permet de publier du contenu d'autres blogs et de définir des règles de publication et de droit d'accès entre eux.},

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'Action' => 'Action',
	'Allow' => 'Autoriser',
	'Content Privacy' => 'Protection du contenu',
	'Create Rebuild Trigger' => 'Créer un événement de republication ',
	'Disallow' => 'Interdire',
	'Exclude blogs' => 'Exclure les blogs',
	'Include blogs' => 'Inclure les blogs',
	'MTMultiBlog tag default arguments' => 'Arguments par défaut de la balise MTMultiBlog',
	'Rebuild Triggers' => 'Événements de republication',
	'Use system default' => 'Utiliser la règle par défaut du système',
	'When' => 'Quand',
	q{Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or 'all' (include_blogs only) are acceptable values.} => q{Autorise l'utilisation de la balise MTMultiBlog sans les attributs include_blogs/exclude_blogs. Les valeurs correctes sont une liste de BlogIDs séparés par des virgules, ou 'all' (seulement pour include_blogs).},
	q{Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.} => q{Indiquez si les autres blogs de cette installation peuvent publier du contenu de ce blog. Ce réglage prend le dessus sur la règle d'agrégation du système par défaut qui se trouve dans la configuration de MultiBlog pour tout le système.},
	q{You have not defined any rebuild triggers.} => q{Vous n'avez défini aucun événement de republication.},

## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
	'Create MultiBlog Trigger' => 'Créer un événement MultiBlog',

## plugins/MultiBlog/tmpl/system_config.tmpl
	q{Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.} => q{L'agrégation inter-blogs sera activée par défaut. Les blogs individuels peuvent être configurés via les paramètres MultiBlog du blog en question, pour restreindre l'accès à leur contenu par les autres blogs.},
	q{Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.} => q{L'agrégation inter-blogs sera désactivée par défaut. Les blogs individuels peuvent être configurés via les paramètres MultiBlog du blog en question, pour autoriser l'accès à leur contenu par les autres blogs.},
	q{Default system aggregation policy} => q{Règle d'agrégation du système par défaut},

## plugins/SmartphoneOption/config.yaml
	'Android' => '',
	'Desktop' => '',
	'Provides an iPhone, iPad and Android touch-friendly UI for Movable Type. Once enabled, navigate to your MT installation from your mobile to use this interface.' => '',
	'iPad' => '',
	'iPhone' => '',

## plugins/SmartphoneOption/lib/Smartphone/CMS.pm
	'Mobile Dashboard' => '',
	'Rich text editor is not supported by your browser. Continue with  HTML editor ?' => '',
	'Syntax highlight is not supported by your browser. Disable to continue ?' => '',
	'This function is not supported by [_1].' => '',
	'This function is not supported by your browser.' => '',
	'[_1] View' => '',

## plugins/SmartphoneOption/lib/Smartphone/CMS/Entry.pm
	'Publish (s)' => 'Publier',
	'Re-Edit (e)' => '',
	'Re-Edit' => '',
	'Rich Text(HTML mode)' => '',

## plugins/SmartphoneOption/lib/Smartphone/CMS/Listing.pm
	'All' => '',
	'Filters which you created from PC.' => '',
	'_DISPLAY_OPTIONS_SHOW' => 'Afficher',

## plugins/SmartphoneOption/lib/Smartphone/CMS/Search.pm
	'Search [_1]' => 'Rechercher [_1]',

## plugins/SmartphoneOption/smartphone.yaml
	'Revision: <strong>[_1]</strong>' => 'Révision : <strong>[_1]</strong>',
	'Smartphone Main' => '',
	'Smartphone Sub' => '',
	'Unpublish' => 'Dé-publier',
	'View revisions of this [_1]' => 'Voir les révisions de ce [_1]',
	'View revisions' => 'Voir les révisions',
	'to [_1]' => '',

## plugins/SmartphoneOption/tmpl/cms/dialog/select_formatted_text.tmpl
	'Continue (s)' => 'Continuer (s)',
	'No boilerplate could be found.' => '',

## plugins/StyleCatcher/config.yaml
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Une gamme de styles compatibles avec les gabarits MT4 par défaut',
	'MT 4 Style Library' => 'Bibliothèque MT4',
	'Moving current style to blog_meta for blog...' => 'Déplacement du style courant du blog vers blog_meta...',
	'Moving current style to blog_meta for website...' => 'Déplacement du style courant du site web vers blog_meta...',
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks.' => 'StyleCatcher vous permet de parcourir facilement les styles et les appliquer ensuite à votre blog en quelques clics.',
	'Styles' => 'Habillages',

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Permission Denied.' => 'Autorisation refusée.',
	'Successfully applied new theme selection.' => 'Le nouveau thème sélectionné a été appliqué avec succès.',
	q{Your mt-static directory could not be found. Please configure 'StaticFilePath' to continue.} => q{Le répertoire mt-static n'a pas pu être trouvé. Veuillez configurer le 'StaticFilePath' pour continuer.},

## plugins/StyleCatcher/lib/StyleCatcher/Library/Default.pm
	'Invalid URL: [_1]' => 'URL invalide : [_1]',
	q{Could not create [_1] folder - Check that your 'themes' folder is webserver-writable.} => q{Impossible de créer le dossier [_1] - Vérifiez que votre dossier 'themes' et en mode webserveur/écriture.},

## plugins/StyleCatcher/lib/StyleCatcher/Library/Local.pm
	'Failed to load StyleCatcher Library: [_1]' => 'Impossible de charger la bibliothèque : [_1]',

## plugins/StyleCatcher/lib/StyleCatcher/Util.pm
	'(Untitled)' => '(Sans titre)',

## plugins/StyleCatcher/tmpl/view.tmpl
	'1-Column, Wide, Bottom' => '1 colonne (large, pied)',
	'2-Columns, Medium, Wide' => '2 colonnes (moyen, large)',
	'2-Columns, Thin, Wide' => '2-colonnes, fin, large',
	'2-Columns, Wide, Medium' => '2-Colonnes, Large, Moyen',
	'2-Columns, Wide, Thin' => '2-colonnes, large, fin',
	'3-Columns, Thin, Thin, Wide' => '3 colonnes (fin, fin, large)',
	'3-Columns, Thin, Wide, Thin' => '3-colonnes, fin, large, fin',
	'3-Columns, Wide, Thin, Thin' => '3-colonnes, large, fin, fin',
	'Applying...' => 'Appliquer...',
	'Current Style' => 'Habillage actuel',
	'Current theme for your weblog' => 'Thème actuel de votre weblog',
	'Default Styles' => 'Habillages par défaut',
	'Download Styles' => 'Télécharger des habillages',
	'Error loading themes! -- [_1]' => 'Erreur lors du chargement des habillages ! -- [_1]',
	'Layout' => 'Mise en page',
	'Locally saved themes' => 'Thèmes enregistrés localement',
	'None available' => 'Aucun disponible',
	'Saved Styles' => 'Habillages enregistrés',
	'Select a [_1] Style' => 'Sélectionner un style [_1]',
	'Selected Design' => 'Habillage sélectionné',
	'Single themes from the web' => 'Thèmes uniques venant du web',
	'Stylesheet or Repository URL' => 'URL de la feuille de style ou du répertoire',
	'Stylesheet or Repository URL:' => 'URL de la feuille de style ou du répertoire :',
	q{Apply Design} => q{Appliquer l'habillage},
	q{Error applying theme: } => q{Erreur en appliquant l'habillage :},
	q{More Styles} => q{Plus d'habillages},
	q{The selected theme has been applied!} => q{L'habillage sélectionné a été appliqué !},
	q{The selected theme has been applied, but as you have changed the layout, you will need to republish your blog to apply the new layout.} => q{L'habillage sélectionné a été appliqué. Vous devez republier votre blog afin d'appliquer la nouvelle mise en page.},

## plugins/Textile/textile2.pl
	'A humane web text generator.' => 'Générateur de texte convivial',
	'Textile 2' => 'Textile 2',

## plugins/TinyMCE/config.yaml
	'Default WYSIWYG editor.' => 'Éditeur riche par défaut',
	'TinyMCE' => 'TinyMCE',

## plugins/WXRImporter/config.yaml
	'"Download WP attachments via HTTP."' => '"Télécharger les pièces jointes WP via HTTP."',
	'"WordPress eXtended RSS (WXR)"' => '"WordPress eXtended RSS (WXR)"',
	'Import WordPress exported RSS into MT.' => 'Importer depuis un export RSS WordPress vers MT',

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'Assigning permissions for new user...' => 'Mise en place des autorisations pour le nouvel utilisateur...',
	'Saving permission failed: [_1]' => 'Échec de la sauvegarde des droits des utilisateurs : [_1]',
	q{ and asset will be tagged ('[_1]')...} => q{ et l'élément sera taggué ('[_1]')...},
	q{Creating new tag ('[_1]')...} => q{Création d'un nouveau tag ('[_1]')...},
	q{Duplicate asset ('[_1]') found.  Skipping.} => q{L'élément  ('[_1]') a été trouvé en double. Ignoré.},
	q{Duplicate entry ('[_1]') found.  Skipping.} => q{La note  ('[_1]') a été trouvée en double. Ignorée.},
	q{Entry has no MT::Trackback object!} => q{La note n'a pas d'objet MT::Trackback !},
	q{File is not in WXR format.} => q{Le fichier n'est pas dans le format WXR.},
	q{Saving asset ('[_1]')...} => q{Enregistrement de l'élément ('[_1]')...},
	q{Saving page ('[_1]')...} => q{Enregistrement de la page ('[_1]')...},
	q{Saving tag failed: [_1]} => q{L'enregistrement du tag a échoué : [_1]},

## plugins/WXRImporter/tmpl/options.tmpl
	'Download attachments' => 'Télécharger les fichiers attachés',
	'Replace with' => 'Remplacer par',
	q{Before you import WordPress posts to Movable Type, we recommend that you <a href='[_1]'>configure your blog's publishing paths</a> first.} => q{Avant d'importer des notes Wordpress dans Movable Type, nous vous recommandons d'abord de <a href='[_1]'>configurer les chemins de publication de votre blog</a>.},
	q{Download attachments (images and files) from the imported WordPress powered blog.} => q{Télécharger les fichiers attachés d'un blog WordPress (images et autres documents).},
	q{Requires the use of a cron job to download attachments from WordPress powered blog in the background.} => q{L'utilisation d'un cron job est requis pour télécharger en arrière plan les fichiers attachés à un blog WordPress.},
	q{Upload path for this WordPress blog} => q{Chemin d'envoi pour ce blog WordPress},

## plugins/WidgetManager/WidgetManager.pl
	'Failed.' => 'Échec.',
	q{Moving storage of Widget Manager [_2]...} => q{Déplacement de l'emplacement du gestionnaire de wiget [_2]...},
	q{Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.} => q{Widget Manager version 1.1. Cette version est destinée à la mise à jour des données des versions plus anciennes de Widget Manager, livré avec Movable Type. Aucune autre fonction n'est incluse. Vous pouvez supprimer ce plugin après avoir installé/mis à jour Movable Type.},

## plugins/feeds-app-lite/lib/MT/Feeds/Lite.pm
	'An error occurred processing [_1]. A previous version of the feed was not available.A HTTP status of [_2] was returned.' => '', # Translate - New
	'An error occurred processing [_1]. The previous version of the feed was used. A HTTP status of [_2] was returned.' => '', # Translate - New

## plugins/feeds-app-lite/lib/MT/Feeds/Tags.pm
	'MT[_1] was not used in the proper context.' => '',
	q{'[_1]' is a required argument of [_2]} => q{},

## plugins/feeds-app-lite/mt-feeds.pl
	'Create a Feed Widget' => '',
	'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type? <a href="http://code.appnel.com/feeds-app" target="_blank">Upgrade to Feeds.App</a>.' => '',

## plugins/feeds-app-lite/tmpl/config.tmpl
	'10' => '',
	'3' => '',
	'5' => '',
	'Configure feed widget settings' => '',
	'Enter a title for your widget.  This will also be displayed as the title of the feed when used on your published blog.' => '',
	'Feeds.App Lite Widget Creator' => '',
	'Select the maximum number of entries to display.' => '',
	'[_1] Feed Widget' => '',

## plugins/feeds-app-lite/tmpl/msg.tmpl
	'A widget named <strong>[_1]</strong> has been created.' => '',
	'Create Another' => '',
	'Finish (s)' => 'Terminer (s)',
	'Finish' => 'Terminer',
	'No feeds could be discovered using [_1]' => '',
	q{An error occurred processing [_1]. Check <a href="javascript:void(0)" onclick="closeDialog('http://www.feedvalidator.org/check.cgi?url=[_2]')">here</a> for more detail and please try again.} => q{},
	q{You may now <a href="javascript:void(0)" onclick="closeDialog('[_2]')">edit &ldquo;[_1]&rdquo;</a> or include the widget in your blog using <a href="javascript:void(0)" onclick="closeDialog('[_3]')">WidgetManager</a> or the following MTInclude tag:} => q{},
	q{You may now <a href="javascript:void(0)" onclick="closeDialog('[_2]')">edit &ldquo;[_1]&rdquo;</a> or include the widget in your blog using the following MTInclude tag:} => q{},

## plugins/feeds-app-lite/tmpl/select.tmpl
	'Multiple feeds were found' => '',
	'Select the feed you wish to use. <em>Feeds.App Lite supports text-only RSS 1.0, 2.0 and Atom feeds.</em>' => '',
	'URI' => '',

## plugins/feeds-app-lite/tmpl/start.tmpl
	'Create a widget from a feed' => '',
	'Enter the URL of a feed, or the URL of a site that has a feed.' => '',
	'Feed or Site URL' => '',
	'You must enter a feed or site URL to proceed' => '',

## plugins/mixiComment/lib/mixiComment/App.pm
	'mixi reported that you failed to login.  Try again.' => '',

## plugins/mixiComment/mixiComment.pl
	'Allows commenters to sign in to Movable Type using their own mixi username and password via OpenID.' => '',
	'mixi' => '',

## plugins/mixiComment/tmpl/config.tmpl
	'A mixi ID has already been registered in this blog.  If you want to change the mixi ID for the blog, <a href="[_1]">click here</a> to sign in using your mixi account.  If you want all of the mixi users to comment to your blog (not only your my mixi users), click the reset button to remove the setting.' => '',
	'If you want to restrict comments only from your my mixi users, <a href="[_1]">click here</a> to sign in using your mixi account.' => '',

## plugins/spamlookup/lib/spamlookup.pm
	'Link was previously published (TrackBack id [_1]).' => 'Le lien a été publié précédemment (ID de trackback [_1]).',
	'Link was previously published (comment id [_1]).' => 'Le lien a été publié précédemment (ID de commentaire [_1]).',
	'Number of links exceed junk limit ([_1])' => 'Le nombre de liens a dépassé la limite de marquage comme spam ([_1])',
	'Number of links exceed moderation limit ([_1])' => 'Le nombre de liens a dépassé la limite de modération ([_1])',
	'[_1] found on service [_2]' => '[_1] trouvé sur le service [_2]',
	q{Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]} => q{L'IP du domaine ne correspond pas à l'IP du ping pour l'URL source [_1], l'IP du domaine : [_2], IP du ping : [_3]},
	q{E-mail was previously published (comment id [_1]).} => q{L'e-mail a été publié précédemment (ID de commentaire [_1]).},
	q{Failed to resolve IP address for source URL [_1]} => q{Échec de la vérification de l'adresse IP pour l'URL source [_1]},
	q{Moderating for Word Filter match on '[_1]': '[_2]'.} => q{Modération pour filtre de mot sur '[_1]' : '[_2]'.},
	q{Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]} => q{Modération : l'IP du domaine ne correspond pas à l'IP de ping pour l'URL de la source [_1], IP du domaine : [_2], IP du ping : [_3]},
	q{No links are present in feedback} => q{Aucun lien n'est présent dans le message},
	q{Word Filter match on '[_1]': '[_2]'.} => q{Le filtre de mot correspond sur '[_1]' : '[_2]'.},
	q{domain '[_1]' found on service [_2]} => q{domaine '[_1]' trouvé sur le service [_2]},

## plugins/spamlookup/spamlookup.pl
	'Despam Comments' => 'Commentaires non-spam',
	'Despam TrackBacks' => 'TrackBacks non-spam',
	'Despam' => 'Non-spam',
	'SpamLookup Domain Lookup' => 'SpamLookup vérification des domaines',
	'SpamLookup IP Lookup' => 'SpamLookup vérification des IP',
	'SpamLookup TrackBack Origin' => 'SpamLookup origine des TrackBacks',
	'SpamLookup module for using blacklist lookup services to filter feedback.' => 'Module SpamLookup pour utiliser les services de vérification de liste noire pour filtrer les commentaires.',

## plugins/spamlookup/spamlookup_urls.pl
	'SpamLookup Email Memory' => 'SpamLookup mémorisation des emails',
	'SpamLookup Link Filter' => 'SpamLookup filtre de lien',
	'SpamLookup Link Memory' => 'SpamLookup mémorisation des liens',
	'SpamLookup module for junking and moderating feedback based on link filters.' => 'Module SpamLookup pour marquer comme spam et modérer les messages basé sur les filtres de liens.',

## plugins/spamlookup/spamlookup_words.pl
	'SpamLookup Keyword Filter' => 'SpamLookup filtre de mots-clés',
	'SpamLookup module for moderating and junking feedback using keyword filters.' => 'Module SpamLookup pour modérer et marquer comme spam les messages en utilisant des filtres de mots-clés.',

## plugins/spamlookup/tmpl/lookup_config.tmpl
	'Adjust scoring' => 'Ajuster la notation',
	'Advanced TrackBack Lookups' => 'Vérifications avancées des TrackBacks',
	'Decrease' => 'Baisser',
	'Domain Blacklist Services' => 'Services de liste noire de domaines',
	'Domain Name Lookups' => 'Vérifier un nom de domaine',
	'IP Address Lookups' => 'Vérifier une adresse IP',
	'Increase' => 'Augmenter',
	'Junk TrackBacks from suspicious sources' => 'Marquer comme spam les TrackBacks de sources suspectes',
	'Junk feedback containing blacklisted domains' => 'Marquer comme spam les messages contenant des domaines en liste noire',
	'Junk feedback from blacklisted IP addresses' => 'Marquer comme spam les commentaires/TrackBacks des adresses IP en liste noire',
	'Less' => 'Moins',
	'Lookup Whitelist' => 'Vérifier la liste blanche',
	'Moderate TrackBacks from suspicious sources' => 'Modérer les TrackBacks de sources suspectes',
	'Moderate feedback containing blacklisted domains' => 'Modérer le contenu des messages contenant des domaines en liste noire',
	'Moderate feedback from blacklisted IP addresses' => 'Modérer les commentaires/TrackBacks des adresses IP en liste noire',
	'More' => 'Plus',
	'Off' => 'Désactivée',
	'Score weight:' => 'Poids de la notation :',
	'To prevent lookups for specific IP addresses or domains, list each on a line by itself.' => 'Pour ne pas effectuer de vérifications pour des noms de domaines ou addresses IP spécifiques, listez-les ligne par ligne.',
	'block' => 'bloquer',
	q{IP Blacklist Services} => q{Services de liste noire d'IP},
	q{Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog's Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.} => q{Lookups surveille les adresses IP sources et les liens hypertextes de tous les commentaires/TrackBacks entrants. Si un commentaire ou un TrackBack provient d'une adresse IP en liste noire ou contient un domaine banni, il peut être retenu pour modération ou noté comme spam et placé dans le répertoire de spam. De plus, des vérifications avancées sur les données sources des TrackBacks peuvent être réalisés.},

## plugins/spamlookup/tmpl/url_config.tmpl
	'Email Memory' => 'Mémorisation des e-mails',
	'Exclude Email addresses from comments published within last [_1] days.' => 'Exclure les adresses e-mail des commentaires publiés dans les [_1] derniers jours.',
	'Exclude URLs from comments published within last [_1] days.' => 'Exclure les URLs des commentaires publiés dans les [_1] derniers jours.',
	'Junk when more than' => 'Marquer comme spam quand plus de',
	'Link Limits' => 'Limite de liens',
	'Link Memory' => 'Mémorisation des liens',
	'Moderate when more than' => 'Modérer quand plus de',
	'link(s) are given' => 'liens sont présents',
	q{Credit feedback rating when &quot;URL&quot; element of feedback has been published before} => q{Créditer la notation du message quand l'élément &quot;URL&quot; du message a été publié précédemment},
	q{Credit feedback rating when no hyperlinks are present} => q{Créditer la notation du message quand aucun lien hypertexte n'est présent},
	q{Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address} => q{Créditer la notation du message lorsque des commentaires publiés précédemment contenaient l'adresse &quot;e-mail&quot;},
	q{Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)} => q{Les filtres de liens surveillent le nombre de liens hypertextes dans les messages entrants. Les messages avec beaucoup de liens peuvent être retenus pour modération ou marqués comme spam. Inversement, les messages qui ne contiennent pas de liens ou lient seulement vers des URLs publiées précédemment peuvent être notés positivement. (N'activez cette option que si vous êtes sûr que votre site est déjà dépourvu de spam.)},
	q{Only applied when no other links are present in message of feedback.} => q{Appliquer seulement quand aucun autre lien n'est présent quand le texte du message.},

## plugins/spamlookup/tmpl/word_config.tmpl
	'Incoming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Les messages entrant peuvent être analysés pour détecter des mots-clés spécifiques, des noms de domaines et des modèles. Les messages correspondants peuvent être retenus pour modération ou marqués comme spam. De plus, les notes de spam pour ces messages peuvent être personnalisées.',
	'Keywords to Junk' => 'Mots-clés à marquer comme spam',
	'Keywords to Moderate' => 'Mots-clés à modérer',

## search_templates/comments.tmpl
	'Find new comments' => 'Voir les nouveaux commentaires',
	'Posted in [_1] on [_2]' => 'Publié dans [_1] le [_2]',
	'Search for new comments from:' => 'Recherche de nouveaux commentaires depuis :',
	'five months ago' => 'il y a cinq mois',
	'four months ago' => 'il y a quatre mois',
	'one month ago' => 'il y a un mois',
	'one week ago' => 'il y a une semaine',
	'one year ago' => 'il y a un an',
	'six months ago' => 'il y a six mois',
	'the beginning' => 'le début',
	'three months ago' => 'il y a trois mois',
	'two months ago' => 'il y a deux mois',
	'two weeks ago' => 'il y a deux semaines',
	q{No new comments were found in the specified interval.} => q{Aucun nouveau commentaire n'a été trouvé dans la période spécifiée.},
	q{No results found} => q{Aucun résultat n'a été trouvé},
	q{Select the time interval that you'd like to search in, then click 'Find new comments'} => q{Sélectionner l'intervalle de temps désiré pour la recherche, puis cliquez sur 'Voir les nouveaux commentaires'},

## search_templates/default.tmpl
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'DEBUT DE LA COLONNE BETA POUR AFFICHAGE DES INFOS DE RECHERCHE',
	'Blog Search Results' => 'Résultats de la recherche',
	'Blog search' => 'Recherche de Blog',
	'END OF ALPHA SEARCH RESULTS DIV' => 'FIN DE LA DIV ALPHA RÉSULTATS RECHERCHE',
	'END OF CONTAINER' => 'FIN DU CONTENU',
	'END OF PAGE BODY' => 'FIN DU CORPS DE LA PAGE',
	'Feed Subscription' => 'Abonnement au flux',
	'Match case' => 'Respecter la casse',
	'Matching entries from [_1]' => 'Notes correspondant à [_1]',
	'NO RESULTS FOUND MESSAGE' => 'Aucun résultat.',
	'Other Tags' => 'Autres tags',
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Posté <MTIfNonEmpty tag="EntryAuthorDisplayName">par [_1] </MTIfNonEmpty>le [_2]',
	'SEARCH RESULTS DISPLAY' => 'Affichage des résultats de la recherche',
	'SET VARIABLES FOR SEARCH vs TAG information' => 'DEFINIT LES VARIABLES DE RECHERCHE vs TAGS',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'les recherches simples obtiennent le formulaire de recherche',
	'Search this site' => 'Rechercher sur ce site',
	'Showing the first [_1] results.' => 'Afficher les premiers [_1] résultats.',
	'TAG LISTING FOR TAG SEARCH ONLY' => 'LISTE DES TAGS UNIQUEMENT POUR LA RECHERCHE DE TAG',
	'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds',
	q{Entries from [_1] tagged with '[_2]'} => q{Notes de [_1] taguées avec '[_2]'},
	q{Entries matching '[_1]'} => q{Notes correspondant à '[_1]'},
	q{Entries tagged with '[_1]'} => q{Notes taguées avec '[_1]'},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries matching '[_1]'.} => q{Si vous utilisez un lecteur de flux RSS, vous pouvez souscrire au flux des futures notes contenant le mot '[_1]'.},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries tagged '[_1]'.} => q{Si vous utilisez un lecteur de flux RSS, vous pouvez souscrire au flux de toutes notes futures dont le tag sera '[_1]'.},
	q{No pages were found containing '[_1]'.} => q{Aucune page trouvée contenant '[_1]'.},
	q{SEARCH FEED AUTODISCOVERY LINK IS PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED} => q{Le lien du flux de la recherche automatisée est publié uniquement après l'exécution d'une recherche.},
	q{SEARCH/TAG FEED SUBSCRIPTION INFORMATION} => q{INFORMATION D'ABONNEMENT AU FLUX RECHERCHE/TAG},
	q{What is this?} => q{De quoi s'agit-il?},

## search_templates/results_feed.tmpl
	'Search Results for [_1]' => 'Résultats de la recherche pour [_1]',

## themes/classic_blog/theme.yaml
	'A traditional blogging design that comes with plenty of styles and a selection of 2 column / 3 column layouts. Best for use in standard blog publishing applications.' => 'Un design traditionnel de blog livré avec plusieurs styles et une variante de gabarits à 2 et 3 colonnes. Adapté à la publication de blogs standards.',

## themes/classic_website/templates/about_this_page.mtml
	'<a href="[_1]">[_2]</a> is the next entry in this website.' => '<a href="[_1]">[_2]</a> est la note suivante de ce site web.',
	'<a href="[_1]">[_2]</a> was the previous entry in this website.' => '<a href="[_1]">[_2]</a> est la note précédente de ce site web.',

## themes/classic_website/theme.yaml
	'Classic Website' => 'Site web classique',
	'Create a blog portal that aggregates contents from several blogs in one website.' => 'Crée un portail de blogs qui agrège les contenus de plusieurs blogs sur un site web.',

## tmpl/cms/asset_replace.tmpl
	'Upload New Asset' => 'Télécharger un nouvel élément',

## tmpl/cms/asset_upload.tmpl
	'Upload Asset' => 'Télécharger un élément',

## tmpl/cms/backup.tmpl
	'Approximate file size per backup file.' => 'Taille de fichier approximative par fichier de sauvegarde.',
	'Backup [_1]' => 'Sauvegarder [_1]',
	'Choose websites...' => 'Sélectionner des sites web...',
	'Everything' => 'Tout',
	'Make Backup (b)' => 'Sauvegarder (b)',
	'Make Backup' => 'Sauvegarder',
	'No size limit' => 'Aucune limite de taille',
	'Target File Size' => 'Limiter la taille du fichier cible',
	'This option will backup Users, Roles, Associations, Blogs, Entries, Categories, Templates and Tags.' => 'Cette option va sauvegarder les utilisateurs, rôles, associations, blogs, notes, catégories, gabarits et tags.',
	q{Archive Format} => q{Format d'archive},
	q{Don't compress} => q{Ne pas compresser},
	q{The type of archive format to use.} => q{Le type de format d'archive à utiliser.},
	q{What to Backup} => q{Ce qu'il faut sauvegarder},

## tmpl/cms/cfg_entry.tmpl
	'Accept TrackBacks' => 'Accepter les TrackBacks',
	'Alignment' => 'Alignement',
	'Ascending' => 'Croissant',
	'Basename Length' => 'Longueur du nom de base',
	'Center' => 'Au centre',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'Entités de caractères (&amp#8221;, &amp#8220;, etc.)',
	'Content CSS' => 'CSS pour le contenu',
	'Czech' => 'Tchèque',
	'Danish' => 'Danois',
	'Date Language' => 'Langue de la date',
	'Days' => 'Jours',
	'Descending' => 'Décroissant',
	'Dutch' => 'Néerlandais',
	'English' => 'Anglais',
	'Enter the number of words that should appear in an auto-generated excerpt.' => 'Entrez le nombre de mot à afficher pour les extraits automatiques de notes.',
	'Entry Fields' => 'Champs des notes',
	'Estonian' => 'Estonien',
	'French' => 'Français',
	'German' => 'Allemand',
	'Icelandic' => 'Islandais',
	'Italian' => 'Italien',
	'Japanese' => 'Japonais',
	'Left' => 'À gauche',
	'Link to popup window' => 'Lien vers fenêtre surgissante',
	'Listing Default' => 'Préférences de liste',
	'No substitution' => 'Ne pas effectuer de remplacements',
	'Norwegian' => 'Norvégien',
	'Note: This option is currently ignored since TrackBacks are disabled either blog or system-wide.' => 'Remarque : cette option est actuellement ignorée car les TrackBacks sont désactivés sur le blog ou sur tout le système.',
	'Note: This option is currently ignored since TrackBacks are disabled either website or system-wide.' => 'Note : cette option est actuellement ignorée car les TrackBacks sont désactivés soit au niveau du site soit au niveau système.',
	'Note: This option is currently ignored since comments are disabled either blog or system-wide.' => 'Remarque : cette option est actuellement ignorée car les commentaires sont désactivés sur le blog ou sur tout le système.',
	'Note: This option is currently ignored since comments are disabled either website or system-wide.' => 'Note : cette option est actuellement ignorée car les commentaires sont désactivés soit au niveau du site soit au niveau système.',
	'Order' => 'Ordre',
	'Page Fields' => 'Champs des pages',
	'Polish' => 'Polonais',
	'Portuguese' => 'Portugais',
	'Posts' => 'Notes',
	'Publishing Defaults' => 'Préférences de publication',
	'Punctuation Replacement Setting' => 'Paramètre de remplacement de la ponctuation',
	'Punctuation Replacement' => 'Remplacement de la ponctuation',
	'Replace Fields' => 'Appliquer le remplacement des caractères dans les champs',
	'Right' => 'À droite',
	'Select the language in which you would like dates on your blog displayed.' => 'Sélectionnez la langue dans laquelle vous souhaitez afficher les dates sur votre blog.',
	'Select the number of days of entries or the exact number of entries you would like displayed on your blog.' => 'Sélectionner le nombre de jours de notes ou le nombre exact de notes que vous voulez afficher sur votre blog.',
	'Select whether you want your entries displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Choisissez si vous voulez afficher vos notes en ordre croissant (les plus anciennes en haut) ou décroissant (les plus récentes en haut).',
	'Setting Ignored' => 'Paramètre ignoré',
	'Slovak' => 'Slovaque',
	'Slovenian' => 'Slovène',
	'Spanish' => 'Espagnol',
	'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => 'Spécifiez la longueur par défaut du nom de base. Peut être comprise entre 15 et 250.',
	'Suomi' => 'Finlandais',
	'Swedish' => 'Suédois',
	'Text Formatting' => 'Mise en forme du texte',
	'The range for Basename Length is 15 to 250.' => 'La longueur du nom de base va de 15 à 250.',
	'Unpublished' => 'Non publiée',
	'Use thumbnail' => 'Utiliser une vignette',
	'You must set valid default thumbnail width.' => 'Vous devez définir une largeur de vignette par défaut valide.',
	'_USAGE_ENTRYPREFS' => 'La configuration des champs détermine les champs de saisie qui apparaîtront dans les écrans de création et de modification des notes. Vous pouvez sélectionner une configuration existante (basique ou avancée), ou personnaliser vos écrans en activant le bouton Personnalisée, puis en sélectionnant les champs que vous souhaitez voir apparaître.',
	'pixels' => 'pixels',
	'width:' => 'largeur :',
	q{ASCII equivalents (&quot;, ', ..., -, --)} => q{Équivalents ASCII (&quot;, ', ..., -, --)},
	q{Compose Defaults} => q{Préférences d'édition},
	q{Compose Settings} => q{Paramètres d'édition},
	q{Content CSS will be applied when WYSIWYG editor does support. You can specify CSS file by URL or \{\{theme_static\}\} placeholder. Example: \{\{theme_static\}\}path/to/cssfile.css} => q{Des styles CSS pour le contenu seront appliqués si l'éditeur riche le supporte. Vous pouvez spécifier un fichier CSS par URL ou dans l'emplacement \{\{theme_static\}\}. Exemple : \{\{theme_static\}\}chemin/vers/fichiercss.css},
	q{Excerpt Length} => q{Longueur de l'extrait},
	q{Image default insertion options} => q{Options d'insertion d'image par défaut},
	q{Link image to full-size version in a popup window.} => q{Créer un lien vers l'image originale dans une fenêtre surgissante},
	q{Replace UTF-8 characters frequently used by word processors with their more common web equivalents.} => q{Remplacer les caractères UTF-8 utilisés fréquemment par l'éditeur de texte par leur équivalent web le plus commun.},
	q{Specifies the default Accept Comments setting when creating a new entry.} => q{Spécifie l'option par défaut pour l'acceptation des commentaires lors de la création d'une nouvelle note.},
	q{Specifies the default Accept TrackBacks setting when creating a new entry.} => q{Spécifie l'option par défaut pour l'acceptation des TrackBacks lors de la création d'une nouvelle note.},
	q{Specifies the default Post Status when creating a new entry.} => q{Spéficie le statut de publication par défaut lors de la création d'une nouvelle note.},
	q{Specifies the default Text Formatting option when creating a new entry.} => q{Spécifie l'option par défaut de mise en forme du texte des nouvelles notes.},
	q{WYSIWYG Editor Setting} => q{Préférences de l'éditeur riche},

## tmpl/cms/cfg_feedback.tmpl
	'([_1])' => '([_1])',
	'Accept comments according to the policies shown below.' => 'Accepter les commentaires selon les politiques choisies ci-dessous.',
	'Allow HTML' => 'Autoriser le HTML',
	'Any authenticated commenters' => 'Tout commentateur authentifié',
	'Anyone' => 'Tout le monde',
	'Auto-Link URLs' => 'Liaison automatique des URL',
	'Automatic Deletion' => 'Supression automatique',
	'Automatically delete spam feedback after the time period shown below.' => 'Supprime automatiquement le spam après la période décrite ci-dessous.',
	'CAPTCHA Provider' => 'Fournisseur de CAPTCHA',
	'Comment Order' => 'Ordre des commentaires',
	'Comment Settings' => 'Paramètres des commentaires',
	'Commenting Policy' => 'Règles pour les commentaires',
	'Comments and TrackBacks receive a spam score between -10 (complete spam) and +10 (not spam). Feedback with a score which is lower than the threshold shown above will be reported as spam.' => 'Les commentaires et les TrackBacks reçoivent un score de spam entre -10 (spam assuré) et +10 (non spam). Un commentaire avec un score qui est plus faible que le seuil ci-dessus sera notifié comme spam.',
	'Delete Spam After' => 'Effacer le spam après',
	'E-mail Notification' => 'Notification par e-mail',
	'Enable External TrackBack Auto-Discovery' => 'Pour les notes extérieures au blog',
	'Enable Internal TrackBack Auto-Discovery' => 'Pour les notes intérieures au blog',
	'Feedback Settings' => 'Paramètres des feedbacks',
	'Hold all TrackBacks for approval before they are published.' => 'Attendre la validation des TrackBacks avant de les publier',
	'Immediately approve comments from' => 'Approuver immédiatement les commentaires de',
	'Less Aggressive' => 'Moins agressif',
	'Limit HTML Tags' => 'Limiter les balises HTML',
	'Moderation' => 'Modération',
	'More Aggressive' => 'Plus agressif',
	'No CAPTCHA provider available' => 'Aucun fournisseur de CAPTCHA disponible',
	'No one' => 'Personne',
	'Note: Commenting is currently disabled at the system level.' => 'Note : les commentaires sont actuellement désactivés au niveau système.',
	'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Note : cette option est actuellement ignorée puisque les pings sortant sont désactivés au niveau du système.',
	'Note: This option may be affected since outbound pings are constrained system-wide.' => 'Note : cette option pourrait être affectée puisque les pings sont restreints au niveau du système.',
	'Note: TrackBacks are currently disabled at the system level.' => 'Note : Les Trackbacks sont actuellement désactivés au niveau système.',
	'On' => 'Activée',
	'Select whether you want comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Sélectionnez si vous souhaitez afficher les commentaires selon un ordre chronologique (nouveaux commentaires en bas) ou anté-chronologique (nouveaux commentaires en haut)',
	'Setting Notice' => 'Paramètre des informations',
	'Spam Score Threshold' => 'Niveau de filtrage du spam',
	'Spam Settings' => 'Paramètres du spam',
	'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Spécifie les options de mise en forme du texte des commentaires publiés par les visiteurs.',
	'Specify what should happen to comments after submission. Unapproved comments are held for moderation.' => 'Spécifiez ce qui doit se passer après la soumission de commentaires. Les commentaires non-approuvés sont retenus pour modération.',
	'Specify when Movable Type should notify you of new TrackBacks.' => 'Spécifie lorsque Movable Type devrait vous notifier des nouveaux TrackBacks.',
	'Specify when Movable Type should notify you of new comments.' => 'Indiquez lorsque Movable Type devrait vous notifier des nouveaux commentaires.',
	'TrackBack Auto-Discovery' => 'Activer la découverte automatique des TrackBacks',
	'TrackBack Options' => 'Options de TrackBack',
	'TrackBack Policy' => 'Règles pour les TrackBacks',
	'Trackback Settings' => 'Paramètres des TrackBacks',
	'Transform URLs in comment text into HTML links.' => 'Transformer les URLs dans les commentaires en liens',
	'Trusted commenters only' => 'Commentateurs fiables uniquement',
	'Use Comment Confirmation Page' => 'Utiliser la page de confirmation de commentaire',
	'Use comment confirmation page' => 'Utiliser la page de confirmation de commentaire',
	'Use defaults' => 'Utiliser les valeurs par défaut',
	'Use my settings' => 'Utiliser mes paramètres',
	'When an item has been reported as spam for this many days, it is automatically deleted.' => 'Quand un élément a été notifié comme spam depuis tant de jours, il est automatiquement effacé.',
	'When auto-discovery is turned on, any external HTML links in new entries will be extracted and the appropriate sites will automatically be sent a TrackBack ping.' => 'Lorsque la découverte automatique est activée, tout lien HTML externe dans les notes sera extrait et un ping de TrackBack leur sera envoyé.',
	'days' => 'jours',
	q{'nofollow' exception for trusted commenters} => q{Ne pas utiliser 'nofollow' pour les auteurs de commentaire fiables},
	q{Accept TrackBacks from any source.} => q{Accepter les TrackBacks de n'importe quelle source.},
	q{Allow commenters to include a limited set of HTML tags in their comments. Otherwise all HTML will be stripped out.} => q{Permettre aux auteurs de commentaire d'inclure une série limitée de balises HTML dans leurs commentaires. Sinon, tous les tags HTML seront supprimés.},
	q{Apply 'nofollow' to URLs} => q{Appliquer 'nofollow' aux URLs},
	q{Comment Display Settings} => q{Paramètres d'affichage des commentaires},
	q{Comment authentication is not available because at least one of the required Perl modules, MIME::Base64 and LWP::UserAgent, are not installed. Install the missing modules and reload this page to configure comment authentication.} => q{L'identification pour les commentaires n'est pas disponible parce qu'au moins un module Perl requis, MIME::Base64 et LWP::UserAgent, n'est pas installé. Installez les modules manquants et rechargez cette page pour configurer l'identification pour les commentaires.},
	q{Do not add the 'nofollow' attribute when a comment is submitted by a trusted commenter.} => q{Ne pas ajouter l'attribut 'nofollow' lorsqu'un commentaire est envoyé par un commentateur fiable.},
	q{Each commenter's browser will be redirected to a comment confirmation page after their comment is accepted.} => q{Rediriger les auteurs de commentaire vers une page de confirmation lorsque leur commentaire est accepté.},
	q{If enabled, all URLs in comments and TrackBacks will be assigned a 'nofollow' link relation.} => q{Si activé, toutes les URLs dans les commentaires et TrackBacks se verront attribuer un attribut 'nofollow'.},
	q{No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed and if the CaptchaSourceImageBase configuration directive points to a valid captcha-source directory within the 'mt-static/images' directory.} => q{Aucun fournisseur de CAPTCHA n'est disponible pour ce système. Veuillez vérifier si Image::Magick est installé et si les directives de configuration CaptchaSourceImageBase pointent une source valide de captcha dans le répertoire 'mt-static/images'.},
	q{Only when attention is required} => q{Uniquement quand l'attention est requise},
	q{Setup Registration} => q{Configuration de l'enregistrement},
	q{Specify the list of HTML tags to allow when accepting a comment.} => q{Indiquez la liste des balises HTML autorisées lorsqu'ils sont acceptés dans les commentaires.},

## tmpl/cms/cfg_plugin.tmpl
	'Are you sure you want to disable this plugin?' => 'Voulez-vous vraiment désactiver ce plugin ?',
	'Are you sure you want to enable this plugin?' => 'Voulez-vous vraiment activer ce plugin ?',
	'Are you sure you want to reset the settings for this plugin?' => 'Voulez-vous vraiment réinitialiser les paramètres pour ce plugin ?',
	'Author of [_1]' => 'Auteur de [_1]',
	'Disable Plugins' => 'Désactiver les plugins',
	'Disable plugin functionality' => 'Désactiver la prise en charge des plugins',
	'Documentation for [_1]' => 'Documentation pour [_1]',
	'Documentation' => 'Documentation',
	'Enable Plugins' => 'Activer les plugins',
	'Enable plugin functionality' => 'Activer la prise en charge des plugins',
	'Failed to Load' => 'Erreur de chargement',
	'Find Plugins' => 'Trouver des plugins',
	'Info' => 'Info',
	'Junk Filters:' => 'Filtres de spam :',
	'More about [_1]' => 'En savoir plus sur [_1]',
	'Plugin Home' => 'Accueil plugin',
	'Plugin System' => 'Système de plugins',
	'Plugin error:' => 'Erreur de plugin :',
	'Reset to Defaults' => 'Réinitialiser (retour aux paramètres par défaut)',
	'Resources' => 'Ressources',
	'Run [_1]' => 'Lancer [_1]',
	'Settings for [_1]' => 'Paramètres pour [_1]',
	'Tag Attributes:' => 'Attributs de tag :',
	'Text Filters' => 'Filtres de texte',
	'Your plugin settings have been reset.' => 'Les paramètres de votre plugin on été réinitialisés.',
	'Your plugin settings have been saved.' => 'Les paramètres de votre plugin ont été enregistrés.',
	'Your plugins have been reconfigured.' => 'Votre plugin a été reconfiguré.',
	'[_1] Plugin Settings' => 'Paramètres des plugins du [_1]',
	'_PLUGIN_DIRECTORY_URL' => 'https://plugins.movabletype.org/',
	q{Are you sure you want to disable plugins for the entire Movable Type installation?} => q{Voulez-vous vraiment désactiver les plugins pour l'installation Movable Type tout entière ?},
	q{Are you sure you want to enable plugins for the entire Movable Type installation? (This will restore plugin settings that were in place before all plugins were disabled.)} => q{Voulez-vous vraiment activer les plugins pour l'installation Movable Type toute entière ? (Cela restaurera les paramètres déjà en place avant la désactivation de ceux-ci.)},
	q{Enable or disable plugin functionality for the entire Movable Type installation.} => q{Activer ou désactiver la fonction plugin pour l'installation Movable Type toute entière.},
	q{No plugins with blog-level configuration settings are installed.} => q{Aucun plugin avec une configuration au niveau du blog n'est installé.},
	q{No plugins with configuration settings are installed.} => q{Aucun plugin avec une configuration n'est installé.},
	q{This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be completely functional.} => q{Ce plugin n'a pas été mis à jour afin de supporter Movable Type [_1]. À cause de cela, il pourrait ne pas fonctionner correctement.},
	q{Your plugins have been reconfigured. Since you're running mod_perl, you must restart your web server for these changes to take effect.} => q{Vos plugins ont été reconfigurés. Puisque vous utilisez mod_perl, vous devez redémarrer votre serveur web pour que les changements soient pris en compte.},
	q{Your plugins have been reconfigured. Since you're running mod_perl, you will need to restart your web server for these changes to take effect.} => q{Vos plugins ont été reconfigurés. Puisque vous utilisez mod_perl vous devez redémarrer votre serveur web pour la prise en compte de ces changements.},

## tmpl/cms/cfg_prefs.tmpl
	'Active Server Page Includes' => 'Inclusions Active Server Page',
	'Advanced Archive Publishing' => 'Publication avancée des archives',
	'Allow to change at upload' => 'Permettre la modification lors du téléchargement',
	'Apache Server-Side Includes' => 'Inclusions Apache Server-Side',
	'Blog root must be under [_1]' => 'La racine du blog doit être sous [_1]',
	'Cancel upload' => 'Annuler le chargement',
	'Change license' => 'Changer la licence',
	'Dynamic Publishing Options' => 'Options de publication dynamique',
	'Enable conditional retrieval' => 'Activer la récupération conditionnelle',
	'Enable dynamic cache' => 'Activer le cache dynamique',
	'Enter a description for your blog.' => 'Saisissez une description pour votre blog.',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your site directory.' => 'Erreur : Movable Type ne peut pas écrire dans le répertoire de cache des gabarits. Vérifez les permissions du répertoire nommé <code>[_1]</code> sous celui du site.',
	'If you choose a different language than the default language defined at the system level, you may need to change module names in certain templates to include different global modules.' => 'Si vous choisissez une langue différente de la langue du système, vous pourriez avoir à modifier le nom de module dans certains gabarits pour inclure différents modules globaux.',
	'Java Server Page Includes' => 'Inclusions Java Server Page',
	'Language' => 'Langue',
	'License' => 'Licence',
	'Module Caching' => 'Cache des modules',
	'Module Settings' => 'Paramètres du module',
	'Name your blog. The name can be changed at any time.' => 'Nommez votre blog. Cela pourra être changé à tout moment.',
	'None (disabled)' => 'Aucune (désactivées)',
	'Number of revisions per entry/page' => 'Nombre de révisions par note/page',
	'Number of revisions per template' => 'Nombres de révisions par gabarit',
	'Operation if a file exists' => 'Que faire si un fichier existe',
	'Overwrite existing file' => 'Écraser le fichier existant',
	'PHP Includes' => 'Inclusions PHP',
	'Preferred Archive' => 'Archive préférée',
	'Publish With No Entries' => 'Publier sans notes',
	'Publish archives outside of [_1] Root' => 'Publier les archives en dehors de la racine du [_1]',
	'Publishing Paths' => 'Chemins de publication',
	'Remove license' => 'Retirer la licence',
	'Rename filename' => 'Renommer le fichier',
	'Rename non-ascii filename automatically' => 'Renommer le nom de fichier (avec caractères non-ASCII) automatiquement',
	'Revision History' => 'Historique de révisions',
	'Revision history' => 'Historique de révision',
	'Select a license' => 'Sélectionner une licence',
	'Select this option only if you need to publish your archives outside of your Blog Root.' => 'Sélectionnez cette option si vous avez besoin de publier vos archives en dehors de la racine du blog.',
	'Select your time zone from the pulldown menu.' => 'Sélectionnez votre fuseau horaire dans la liste déroulante.',
	'Server Side Includes' => 'Inclusions côté serveur (SSI)',
	'Time Zone' => 'Fuseau horaire',
	'UTC+0 (Universal Time Coordinated)' => 'UTC+0 (Temps universel coordonné)',
	'UTC+1 (Central European Time)' => 'UTC+1 (Europe centrale)',
	'UTC+10 (East Australian Time)' => 'UTC+10 (Australie Est)',
	'UTC+11' => 'UTC+11 (Nouvelle-Calédonie)',
	'UTC+12 (International Date Line East)' => 'UTC+12 (ligne internationale de changement de date)',
	'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (Nouvelle-Zélande)',
	'UTC+3 (Baghdad Time/Moscow Time)' => 'UTC+3 (Bagdad/Moscou)',
	'UTC+3.5 (Iran)' => 'UTC+3,5 (Iran)',
	'UTC+4 (Russian Federation Zone 3)' => 'UTC+4 (Fédération russe, zone 3)',
	'UTC+5 (Russian Federation Zone 4)' => 'UTC+5 (Fédération russe, zone 4)',
	'UTC+5.5 (Indian)' => 'UTC+5.5 (Inde)',
	'UTC+6 (Russian Federation Zone 5)' => 'UTC+6 (Fédération russe, zone 5)',
	'UTC+6.5 (North Sumatra)' => 'UTC+6,5 (Sumatra Nord)',
	'UTC+7 (West Australian Time)' => 'UTC+7 (Australie Ouest)',
	'UTC+8 (China Coast Time)' => 'UTC+8 (Chine littorale)',
	'UTC+9 (Japan Time)' => 'UTC+9 (Japon)',
	'UTC+9.5 (Central Australian Time)' => 'UTC+9,5 (Australie Centre)',
	'UTC-10 (Aleutians-Hawaii Time)' => 'UTC-10 (Hawaii)',
	'UTC-11 (Nome Time)' => 'UTC-11 (Nome)',
	'UTC-2 (Azores Time)' => 'UTC-2 (Açores)',
	'UTC-3 (Atlantic Time)' => 'UTC-3 (Atlantique)',
	'UTC-3.5 (Newfoundland)' => 'UTC-3,5 (Terre-Neuve)',
	'UTC-4 (Atlantic Time)' => 'UTC-4 (Atlantique)',
	'UTC-6 (Central Time)' => 'UTC-6 (Etats-Unis, heure centrale)',
	'UTC-7 (Mountain Time)' => 'UTC-7 (Etats-Unis, heure des rocheuses)',
	'UTC-8 (Pacific Time)' => 'UTC-8 (Etats-Unis, heure du Pacifique)',
	'UTC-9 (Alaskan Time)' => 'UTC-9 (Alaska)',
	'Upload and rename' => 'Charger et renommer',
	'Use absolute path' => 'Utiliser le chemin absolu',
	'Use subdomain' => 'Utiliser un sous-domaine',
	'Warning: Changing the [_1] URL requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'Warning: Changing the [_1] root requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'Warning: Changing the archive URL requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'Warning: Changing the archive path requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'Website root must be under [_1]' => 'La racine du site web doit être sous [_1]',
	'You must set a valid Local file Path.' => 'Vous devez entrer un chemin de fichier local valide.',
	'You must set a valid URL.' => 'Vous devez entrer une URL valide.',
	'You must set your Blog Name.' => 'Vous devez configurer le nom du blog.',
	'You must set your Local file Path.' => 'Vous devez entrer un chemin de fichier local.',
	'Your blog is currently licensed under:' => 'Votre blog est actuellement sous licence:',
	'Your website is currently licensed under:' => 'Votre site web a actuellement comme licence :',
	'[_1] Root' => 'Racine du [_1]',
	'[_1] Settings' => 'Paramètres du [_1]',
	'[_1] URL' => 'URL du [_1]',
	q{Allow properly configured template modules to be cached to enhance publishing performance.} => q{Permettre aux modules de gabarits optimisés pour le cache d'augmenter les performances de publication.},
	q{Archive Settings} => q{Paramètres d'archive},
	q{Archive URL} => q{URL d'archive},
	q{Choose archive type} => q{Choisir le type d'archive},
	q{Enable orientation normalization} => q{Activer la normalisation de l'orientation},
	q{Enable revision history} => q{Activer l'historique de révision},
	q{Enter the archive file extension. This can take the form of 'html', 'shtml', 'php', etc. Note: Do not enter the leading period ('.').} => q{Entrez l'extension du fichier d'archive. Elle peut être au choix 'html', 'shtml', 'php', etc. N.B. : ne pas ajouter le point séparateur ('.').},
	q{Error: Movable Type was not able to create a directory for publishing your [_1]. If you create this directory yourself, grant write permission to the web server.} => q{Erreur : Movable Type n'a pas pu créer un répertoire pour la publication de votre [_1]. Si vous avez créé ce répertoire vous-même, ajoutez les autorisations d'écriture sur le serveur.},
	q{Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your site directory.} => q{Erreur : Movable Type n'a pas pu créer un répertoire pour cacher vos gabarits dynamiques. Vous devriez créer un répertoire nommé <code>[_1]</code> sous celui de votre site.},
	q{No archives are active} => q{Aucune archive n'est active},
	q{Normalize orientation} => q{Normaliser l'orientation},
	q{Note: Revision History is currently disabled at the system level.} => q{
	Note : l'historique de révision est actuellement désactivé au niveau système.},
	q{Publish category archive without entries} => q{Publier l'archive de catégorie sans notes},
	q{The URL of the archives section of your blog. Example: http://www.example.com/blog/archives/} => q{L'URL de la section des archives de votre blog. Exemple : http://www.exemple.com/blog/archives/},
	q{The URL of the archives section of your website. Example: http://www.example.com/archives/} => q{L'URL de la section des archives de votre site web. Exemple : http://www.exemple.com/archives/},
	q{The URL of your blog. Exclude the filename (i.e. index.html). End with '/'. Example: http://www.example.com/blog/} => q{L'URL de votre blog en excluant les noms de fichier (comme index.html) et se terminant par '/'. Exemple : http://www.exemple.com/blog/},
	q{The URL of your website. Exclude the filename (i.e. index.html).  End with '/'. Example: http://www.example.com/} => q{L'URL de votre site web en excluant les noms de fichier (comme index.html) et se terminant par '/'. Exemple : http://www.exemple.com/},
	q{The path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Le chemin où les fichiers d'index de votre section des archives seront publiés. Un chemin absolu (commençant par '/' pour Linux ou 'C:\' pour Windows) est conseillé.  Ne pas terminer par '/' ou '\'. Exemple : /home/mt/public_html ou C:\www\public_html},
	q{The path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Le chemin où les fichiers d'index de votre section des archives seront publiés. Ne pas terminer par '/' ou '\''. Exemple : /home/mt/public_html/blog ou C:\www\public_html\blog},
	q{The path where your index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Le chemin où vos fichiers d'index seront publiés. Un chemin absolu (commençant par '/' pour Linux ou 'C:\' pour Windows) est conseillé. Ne pas commencer par '/' ou '\'. Exemple : /home/mt/public_html ou C:\www\public_html},
	q{The path where your index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Le chemin où vos fichiers d'index seront publiés. Ne pas terminer par '/' ou '\'.  Exemple : /home/mt/public_html/blog ou C:\www\public_html\blog},
	q{Time zone not selected} => q{Vous n'avez pas sélectionné de fuseau horaire},
	q{UTC+2 (Eastern Europe Time)} => q{UTC+2 (Europe de l'Est)},
	q{UTC-1 (West Africa Time)} => q{UTC-1 (Afrique de l'Ouest)},
	q{UTC-5 (Eastern Time)} => q{UTC-5 (Etats-Unis, heure de l'Est)},
	q{Used to generate URLs (permalinks) for this blog's archived entries. Choose one of the archive types used in this blog's archive templates.} => q{Utilisé pour générer des URLs (liens permanents) pour les notes archivées de ce blog. Sélectionnez un type d'archive utilisé dans les gabarits d'archives de ce blog.},
	q{Used to generate URLs (permalinks) for this website's archived entries. Choose one of the archive types used in this website's archive templates.} => q{Utilisé pour générer des URLs (liens permanents) pour les notes archivées de ce site web. Sélectionnez un type d'archive utilisé dans les gabarits d'archives de ce site.},
	q{You did not select a time zone.} => q{Vous n'avez pas sélectionné de fuseau horaire.},
	q{You must set a valid Archive URL.} => q{Vous devez renseigner une URL d'archive valide.},
	q{You must set a valid Local Archive Path.} => q{Vous devez spécifier un chemin d'archive local valide.},
	q{You must set your Local Archive Path.} => q{Vous devez spécifier votre chemin d'archive local.},
	q{Your blog does not have an explicit Creative Commons license.} => q{Votre blog n'a pas de licence Creative Commons explicite.},
	q{Your website does not have an explicit Creative Commons license.} => q{Votre site web n'a pas de licence Creative Commons explicite.},

## tmpl/cms/cfg_registration.tmpl
	'(No role selected)' => '(aucun role sélectionné)',
	'Allow registration for this website.' => 'Permettre les enregistrements pour ce site web.',
	'New Created User' => 'Nouvel utilisateur créé',
	'Registration Not Enabled' => 'Enregistrement non activé',
	'Registration Settings' => 'Paramètres des enregistrements',
	'Select a role that you want assigned to users that are created in the future.' => 'Sélectionnez un role que vous voulez assigner aux utilisateurs créés à partir de maintenant.',
	'Select roles' => 'Sélectionnez des rôles',
	'User Registration' => 'Enregistrement utilisateur',
	'Your blog preferences have been saved.' => 'Les préférences de votre blog ont été enregistrées.',
	'Your website preferences have been saved.' => 'Les préférences de votre site web ont été enregistrées.',
	q{Allow visitors to register as members of this website using one of the Authentication Methods selected below.} => q{Permettre aux visiteurs de s'enregistrer en tant que membres de ce site en utilisant les méthodes d'authentification sélectionnées ci-dessous.},
	q{Authentication Methods} => q{Méthode d'authentification},
	q{Note: Registration is currently disabled at the system level.} => q{Remarque : l'enregistrement est actuellement désactivé pour tout le système.},
	q{One or more Perl modules may be missing to use this authentication method.} => q{Un ou plusieurs modules Perl manquent peut-être pour utiliser cette méthode d'authentification.},
	q{Please select authentication methods to accept comments.} => q{Veuillez sélectionner les méthodes d'authorisation acceptées pour les commentaires.},

## tmpl/cms/cfg_system_general.tmpl
	'(No Outbound TrackBacks)' => '(Pas de TrackBacks sortants)',
	'(None selected)' => '(Aucune sélection)',
	'A test mail was sent.' => 'Un e-mail de test a été envoyé.',
	'Base Site Path' => 'Chemin de base du site',
	'Clear' => 'Effacer',
	'Debug Mode' => 'Mode debug',
	'Disable comments for all websites and blogs.' => 'Désactiver les commentaires pour tous les sites web et les blogs.',
	'Disable notification pings for all websites and blogs.' => 'Désactiver les notifications pour tous les sites web et les blogs.',
	'Disable receipt of TrackBacks for all websites and blogs.' => 'Désactiver la réception des TrackBacks pour tous les sites web et les blogs.',
	'Enable this setting to have Movable Type track revisions made by users to entries, pages and templates.' => 'Activer ce paramètre pour que Movable Type enregistre les révisions faites par les utilisateurs aux notes, pages et gabarits.',
	'IP address lockout policy' => 'Politique de verrouillage des adresses IP',
	'Imager does not support ImageQualityPng.' => 'Imager ne gère pas ImageQualityPng.',
	'Lockout Settings' => 'Paramètres de verrouillage',
	'Log Path' => 'Chemin du journal',
	'Logging Threshold' => 'Seuil de journalisation',
	'One or more of your websites or blogs are not following the base site path (value of BaseSitePath) restriction.' => 'Au moins un des sites ou des blogs ne respecte pas la restriction du chemin de base (BaseSitePath).',
	'Only to websites on the following domains:' => 'Seulement vers les blogs de ces domaines :',
	'Outbound Notifications' => 'Notifications sortantes',
	'Performance Logging' => 'Journalisation des performances',
	'Prohibit Comments' => 'Refuser les commentaires',
	'Prohibit Notification Pings' => 'Refuser les pings de notification',
	'Prohibit TrackBacks' => 'Refuser les TrackBacks',
	'Select' => 'Sélectionner',
	'Send Mail To' => 'Envoyer un e-mail à',
	'Send Outbound TrackBacks to' => 'Envoyer les TrackBacks sortant vers',
	'Send Test Mail' => 'Envoyer un e-mail de test',
	'Send' => 'Envoyer',
	'Site Path Limitation' => 'Limitation du chemin du site',
	'System Email Address' => 'Adresse e-mail du système',
	'System-wide Feedback Controls' => 'Contrôles de commentaires et TrackBack du système',
	'The email address that should receive a test email from Movable Type.' => 'Cette adresse e-mail devrait recevoir un e-mail de test de Movable Type',
	'The filesystem directory where performance logs are written.  The web server must have write permission in this directory.' => 'Le répertoire où le journal est écrit doit être ouvert en écriture pour le serveur web.',
	'The time limit for unlogged events in seconds. Any event that takes this amount of time or longer will be reported.' => 'La limite des événements non inscrits dans le journal en secondes. Tout événement prenant ce temps ou plus long sera reporté.',
	'This will override all individual blog settings.' => 'Cela va écraser les paramètres de tous les blogs individuels.',
	'Turn on performance logging' => 'Activer la journalisation des performances',
	'Turn on performance logging, which will report any system event that takes the number of seconds specified by Logging Threshold.' => 'Activer la journalisation des performances, qui va reporter tout événement système prenant le nombre de secondes specifié par le seuil de journalisation.',
	'User lockout policy' => 'Politique de verrouillage des utilisateurs',
	'You must set a valid absolute Path.' => 'Vous devez définir un chemin absolu valide.',
	'You must set an integer value between 0 and 100.' => 'Entrez un nombre entier entre 0 et 100.',
	'You must set an integer value between 0 and 9.' => 'Entrez un nombre entier entre 0 et 9.',
	'Your settings have been saved.' => 'Vos paramètres ont été enregistrés.',
	q{A Movable Type user will be locked out if he or she submits an incorrect password [_1] or more times within [_2] seconds.} => q{Un utilisateur Movable Type sera verrouillé s'il ou elle essaye un mot de passe incorrect [_1] ou plus en moins de [_2] secondes.},
	q{Allow sites to be placed only under this directory} => q{Autoriser les sites à n'être placés que sous ce répertoire},
	q{An IP address will be locked out if [_1] or more incorrect login attempts are made within [_2] seconds from the same IP address.} => q{Une adresse IP sera verrouillée si [_1] tentatives d'identification incorrecte sont effectuées depuis cette même adresse IP en moins de [_2] secondes.},
	q{Changing image quality} => q{Changement de qualité d'image},
	q{Disable sending notification pings when a new entry is created in any blog on the system.} => q{Désactiver l'envoi de pings lorsqu'une nouvelle note est créée sur un blog.},
	q{Do not send outbound TrackBacks or use TrackBack auto-discovery if your installation is intended to be private.} => q{Ne pas envoyer de TrackBacks sortant ou utiliser la découverte automatique lorsque l'installation est censée être privée.},
	q{Enable image quality changing.} => q{Activer le changement de qualité d'image.},
	q{However, the following IP addresses are 'whitelisted' and will never be locked out:} => q{Cependant, les adresses IP suivantes ne seront jamais verrouillées car elles sont dans la liste blanche :},
	q{Image Quality Settings} => q{Paramètres de qualité d'image},
	q{Image quality of uploaded JPEG image and its thumbnail. This value can be set an integer value between 0 and 100. Default value is 85.} => q{Qualité d'image JPEG téléchargée et de sa vignette. Cette valeur entière est comprise entre 0 et 100, 85 étant la valeur par défaut.},
	q{Image quality of uploaded PNG image and its thumbnail. This value can be set an integer value between 0 and 9. Default value is 7.} => q{Qualité d'image PNG téléchargée et de sa vignette. Cette valeur entière est comprise entre 0 et 9, 7 étant la valeur par défaut.},
	q{Image quality(JPEG)} => q{Qualité d'image (JPEG)},
	q{Image quality(PNG)} => q{Qualité d'image (PNG)},
	q{The list of IP addresses. If a remote IP address is included in this list, the failed login will not recorded. You can specify multiple IP addresses separated by commas or line breaks.} => q{La liste des adresses IP. Si une adresse IP distante est incluse dans cette liste, une tentative d'identification infructueuse ne sera pas enregistrée. Vous pouvez spécifier plusieurs adresses IP séparées par des virgules ou des sauts de ligne},
	q{The system administrators whom you wish to notify if a user or an IP address is locked out.  If no administrators are selected, notifications will be sent to the 'System Email' address.} => q{Les administrateur système que vous souhaitez voir notifiés si un utilisateur ou une adresse IP est verrouillée. Si aucun des administrateurs n'est sélectioné, les notifications seront envoyées à l'adresse e-mail système.},
	q{This email address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events.} => q{Cette adresse e-mail est utilisée comme celle de l'expéditeur des e-mails envoyés par Movable Type pour la récupération des mots de passe, l'enregistrement des commentateurs, les notifications de commentaires et de TrackBacks, le blocage d'un utilisateur ou d'une adresse IP, et quelques autres événements mineurs.},
	q{Track revision history} => q{Historique d'enregistrement des révisions},
	q{Values other than zero provide additional diagnostic information for troubleshooting problems with your Movable Type installation.  More information is available in the <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">Debug Mode documentation</a>.} => q{Les valeurs autres que zéro fournissent des informations de diagnostique supplémentaires pour la résolution de problèmes avec votre installation Movable Type. Plus d'informations dans la <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">documentation du mode debug</a>.},

## tmpl/cms/cfg_system_users.tmpl
	'(No theme selected)' => '(Aucun thème sélectionné)',
	'(No website selected)' => '(Aucun site web sélectionné)',
	'Allow Registration' => 'Autoriser les enregistrements',
	'Automatically create a new blog for each new user.' => 'Créer automatiquement un nouveau blog pour chaque nouvel utilisateur.',
	'Change theme' => 'Changer le thème',
	'Change website' => 'Changer le site web',
	'Choose the default language to apply to all new users.' => 'Choisissez la langue par défaut pour les nouveaux utilisateurs.',
	'Comma' => 'Virgule',
	'Default Tag Delimiter' => 'Délimiteur de tags par défaut',
	'Default Time Zone' => 'Fuseau horaire par défaut',
	'Default User Language' => 'Langue par défaut',
	'Define the default delimiter for entering tags.' => 'Définir un délimiteur par défaut pour la saisie des tags.',
	'Minimun Length' => 'Longueur minimum',
	'New User Defaults' => 'Paramètres par défaut pour les nouveaux utilisateurs',
	'Password Validation' => 'Validation du mot de passe',
	'Personal Blog Location' => 'Emplacement du blog personnel',
	'Personal Blog Theme' => 'Thème de blog personnel',
	'Personal Blog' => 'Blog personnel',
	'Select a website you wish to use as the location of new personal blogs.' => 'Sélectionner un site web que vous voudriez utiliser comme emplacement pour les nouveaux blogs personnels.',
	'Select system administrators' => 'Sélectionner des administrateurs système',
	'Select the theme that should be used for new personal blogs.' => 'Sélectionner le thème qui devrait être utilisé pour les nouveaux blogs personnels.',
	'Select theme' => 'Sélectionner le thème',
	'Select website' => 'Sélectionner un site web',
	'Should contain letters and numbers.' => 'Doit contenir des lettres et des chiffres',
	'Should contain special characters.' => 'Doit contenir des caractères spéciaux',
	'Should contain uppercase and lowercase letters.' => 'Doit contenir des lettres en minuscule et majuscule',
	'Space' => 'Espace',
	'This field must be a positive integer.' => 'Ce champ doit être un entier positif.',
	'User Settings' => 'Paramètres utilisateur',
	q{Allow commenters to register on this system.} => q{Autoriser les commentateurs à s'enregistrer sur ce système.},
	q{Have the system automatically create a new personal blog when a user is created. The user will be granted the blog administrator role on this blog.} => q{Le système va créer un nouveau blog personnel à chaque fois qu'un utilisateur est créé. Cet utilisateur sera administrateur de ce blog.},
	q{Note: System Email Address is not set in System > General Settings. Emails will not be sent.} => q{Note : L'adresse e-mail système n'est pas configurée dans Système > Paramètres généraux. Les e-mails ne seront donc pas envoyés.},
	q{Notify the following system administrators when a commenter registers:} => q{Notifier les administrateurs ci-dessous lorsqu'un commentateur s'enregistre :},
	q{Select a system administrator you wish to notify when commenters successfully registered themselves.} => q{Sélectionnez un administrateur que vous souhaitez notifier quand les auteurs de commentaire s'enregistrent avec succès.},

## tmpl/cms/cfg_web_services.tmpl
	'(Separate URLs with a carriage return.)' => '(Séparer les URLs avec un retour chariot.)',
	'Data API' => 'API Data',
	'External Notifications' => 'Notifications externes',
	'Note: This option is currently ignored because outbound notification pings are disabled system-wide.' => 'Note : cette option est actuellement ignorée parce que les notifications sortantes sont désactivés au niveau du système.',
	'Notify ping services of website updates' => 'Notifier les services de ping des mises à jour du site web.',
	'Others:' => 'Autres :',
	'Web Services Settings' => 'Paramètres des services web',
	'When this website is updated, Movable Type will automatically notify the selected sites.' => 'Lorsque ce site web est mis à jour, Movable Type va automatiquement notifier les sites sélectionnés.',
	q{Data API Settings} => q{Paramètres de l'API Data},
	q{Enable Data API in system scope.} => q{Activer l'API Data au niveau système.},
	q{Enable Data API in this site.} => q{Activer l'API Data pour ce site.},

## tmpl/cms/dashboard.tmpl
	'Add' => 'Ajouter',
	'Dashboard' => 'Tableau de bord',
	'Select a Widget...' => 'Sélectionner un widget...',
	'Your Dashboard has been updated.' => 'Votre tableau de bord a été mis à jour.',
	q{System Overview} => q{Vue d'ensemble},

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Back (b)' => 'Retour (b)',
	'Confirm Publishing Configuration' => 'Confirmer la configuration de publication',
	'Enter the new URL of the archives section of your blog. Example: http://www.example.com/blog/archives/' => 'Entrer la nouvelle URL de la section des archives de votre blog. Exemple : http://www.exemple.com/blog/archives/',
	'Parent Website' => 'Site web parent',
	'Please choose parent website.' => 'Veuillez choisir un site web parent',
	'You must select a parent website.' => 'Vous devez choisir un site web parent',
	'You must set a valid Site URL.' => 'Vous devez spécifier une URL valide.',
	'You must set a valid local site path.' => 'Vous devez spécifier un chemin local de site valide.',
	q{Enter the new URL of your public blog. End with '/'. Example: http://www.example.com/blog/} => q{Entrez la nouvelle URL de votre blog public. Terminer par '/'. Exemple : http://www.example.com/blog/},
	q{Enter the new path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Entrer le nouveau chemin où vos fichiers d'index de la section des archives seront publiés. Un chemin absolu (commençant par '/' pour Linux ou 'C:\' pour Windows) is conseillé.  Ne pas terminer par '/' ou '\'. Exemple : /home/mt/public_html ou C:\www\public_html},
	q{Enter the new path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Entrer le nouveau chemin où vos fichiers d'index de la section des archives seront publiés. Ne pas terminer par '/' ou '\'.  Exemple : /home/mt/public_html/blog ou C:\www\public_html\blog},
	q{Enter the new path where your main index file will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Entrez un nouveau chemin où votre fichier d'index sera localisé. Ne pas commencer par '/' ou '\'.  Exemple : /home/mt/public_html/blog ou C:\www\public_html\blog},
	q{Enter the new path where your main index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Entrez un nouveau chemin où votre fichier d'index sera localisé. Un chemin absolu (commençant par '/' pour Linux ou 'C:\' pour Windows) is conseillé.  Ne pas terminer par '/' ou '\'. Exemple : /home/mt/public_html ou C:\www\public_html},

## tmpl/cms/dialog/asset_edit.tmpl
	'An error occurred.' => 'Une erreur est survenue.',
	'Error creating thumbnail file.' => 'Erreur à la création du fichier de la vignette.',
	'Save changes to this asset (s)' => 'Enregistrer les modifications de cet élément (s)',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to close this dialog?' => 'Les modifications en cours sur cet élément seront perdues. Voulez-vous vraiment fermer ce formulaire ?',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to edit image?' => 'Les modifications en cours sur cet élément seront perdues. Voulez-vous vraiment éditer cette image ?',
	'Your edited image has been saved.' => 'Votre image éditée a été sauvegardée.',
	q{Edit Image} => q{Éditer l'image},
	q{File Size} => q{Taille de l'image},
	q{Metadata cannot be updated because Metadata in this image seems to be broken.} => q{Les métadonnées ne peuvent être mises à jour car celles présentes dans l'image semblent erronées.},

## tmpl/cms/dialog/asset_list.tmpl
	'Insert (s)' => 'Insérer (s)',
	'Insert Asset' => 'Insérer un élément',
	'Insert Image' => 'Insérer une image',
	'Insert' => 'Insérer',
	'Next (s)' => 'Suivant (s)',
	'Size' => 'Taille',
	'Upload New File' => 'Envoyer un nouveau fichier',
	'Upload New Image' => 'Envoyer une nouvelle image',
	q{Asset Name} => q{Nom de l'élément},
	q{No assets could be found.} => q{Aucun élément n'a été trouvé.},

## tmpl/cms/dialog/asset_modal.tmpl
	'Library' => 'Bibliothèque',

## tmpl/cms/dialog/asset_options.tmpl
	'Create a new entry using this uploaded file.' => 'Créer une nouvelle note avec ce fichier envoyé.',
	'File Options' => 'Options fichier',
	q{Create entry using this uploaded file} => q{Créer une note à l'aide de ce fichier},

## tmpl/cms/dialog/asset_options_image.tmpl
	'Remember these settings' => 'Mémoriser ces paramètres',
	q{Display image in entry/page} => q{Afficher l'image dans la note/page},

## tmpl/cms/dialog/asset_upload.tmpl
	'You need to configure your blog.' => 'Vous devez configurer votre blog.',
	q{Your blog has not been published.} => q{Votre blog n'a pas été publié.},

## tmpl/cms/dialog/clone_blog.tmpl
	'Blog Details' => 'Détails du blog',
	'Categories/Folders' => 'Catégories/Répertoires',
	'Clone' => 'Dupliquer',
	'Confirm' => 'Confirmer',
	'Entries/Pages' => 'Notes/Pages',
	'Exclude Categories/Folders' => 'Exclure les catégories/répertoires',
	'Exclude Comments' => 'Exclure les commentaires',
	'Exclude Entries/Pages' => 'Exclure les notes/pages',
	'Exclude Trackbacks' => 'Exclure les TrackBacks',
	'Exclusions' => 'Exclusions',
	'Mark the settings that you want cloning to skip' => 'Marquez les paramètres que vous ne souhaitez pas dupliquer',
	'Publish archives outside of Blog Root' => 'Publier les archives en dehors de la racine du blog',
	'This is set to the same URL as the original blog.' => 'Cela est configuré vers la même URL que le blog original.',
	'This will overwrite the original blog.' => 'Cela réécrira sur le blog original.',
	q{Warning: Changing the archive URL can result in breaking all links in your blog.} => q{Attention : si vous modifiez l'URL d'archive vous pouvez casser tous les liens dans votre blog.},
	q{Warning: Changing the archive path can result in breaking all links in your blog.} => q{Attention : changer le chemin d'archive peut casser tous les liens de votre blog.},

## tmpl/cms/dialog/comment_reply.tmpl
	'On [_1], [_2] commented on [_3]' => 'Le [_1], [_2] a commenté sur [_3]',
	'Reply to comment' => 'Répondre au commentaire',
	'Submit reply (s)' => 'Envoyer la réponse (s)',
	'Your reply:' => 'Votre réponse :',

## tmpl/cms/dialog/create_association.tmpl
	q{No blogs exist in this installation. [_1]Create a blog</a>} => q{Aucun blog n'existe dans cette installation. [_1]Créer un blog</a>},
	q{No roles exist in this installation. [_1]Create a role</a>} => q{Aucun rôle n'existe dans cette installation. [_1]Créer un rôle</a>},
	q{No websites exist in this installation. [_1]Create a website</a>} => q{Aucun site web n'existe dans cette installation. [_1]Créer un site web</a>},

## tmpl/cms/dialog/edit_image.tmpl
	'Apply' => 'Appliquer',
	'Crop' => 'Retailler',
	'Flip horizontal' => 'Inverser horizontalement',
	'Flip vertical' => 'Inverser verticalement',
	'H:' => 'H :',
	'Redo' => 'Refaire',
	'Remove All metadata' => 'Supprimer toutes les métadonnées',
	'Remove GPS metadata' => 'Supprimer les métadonnées GPS',
	'Rotate left' => 'Pivoter à gauche',
	'Rotate right' => 'Pivoter à droite',
	'Undo' => 'Annuler',
	'W:' => 'L :',
	'You have unsaved changes to this image that will be lost. Are you sure you want to close this dialog?' => 'Les modifications apportées à cette image seront perdues. Voulez-vous vraiment fermer cette fenêtre?',
	q{Keep aspect ratio} => q{Conserver le ratio d'aspect},

## tmpl/cms/dialog/entry_notify.tmpl
	'(Body will be sent without any text formatting applied.)' => '(Le contenu sera envoyé sans aucun formattage).',
	'Enter email addresses on separate lines or separated by commas.' => 'Entrez les adresses e-mail, une sur chaque ligne ou séparées par des virgules.',
	'Optional Content' => 'Contenu optionnel',
	'Optional Message' => 'Message optionnel',
	'Recipients' => 'Destinataires',
	'Send a Notification' => 'Envoyer une notification',
	'Send notification (s)' => 'Envoyer la notification (s)',
	'You must specify at least one recipient.' => 'Vos devez définir au moins un destinataire.',
	q{All addresses from Address Book} => q{Toutes les adresses du carnet d'adresses},
	q{Your [_1]'s name, title, and a link to view it will be sent in the notification. Additionally, you can add a message, include an excerpt and/or send the entire body.} => q{Votre nom de [_1], titre et un lien pour le voir seront envoyés dans la notification. De plus, vous pouvez ajouter un message, inclure un extrait et/ou envoyer le contenu en entier.},

## tmpl/cms/dialog/list_revision.tmpl
	q{Select the revision to populate the values of the Edit screen.} => q{Sélectionner la révision à utiliser pour remplir les champs de l'éditeur.},

## tmpl/cms/dialog/move_blogs.tmpl
	q{Warning: You need to copy uploaded assets to the new path manually. It is also recommended not to delete files in the old path to avoid broken links.} => q{Attention : Vous devez copier les éléments envoyés vers le nouveau chemin manuellement. Il est également recommendé de ne pas supprimer les anciens fichiers afin d'éviter les liens morts.},

## tmpl/cms/dialog/multi_asset_options.tmpl
	'Display [_1] in entry/page' => 'Afficher [_1] dans la note/page',
	q{Insert Options} => q{Options d'insertion},

## tmpl/cms/dialog/new_password.tmpl
	'The password for the user \'[_1]\' has been recovered.' => '', # Translate - New

## tmpl/cms/dialog/publishing_profile.tmpl
	'Are you sure you wish to continue?' => 'Voulez-vous vraiment continuer ?',
	'Background Publishing' => 'Publication en arrière-plan',
	'Choose the profile that best matches the requirements for this blog.' => 'Choisir le profil qui correspond le mieux aux besoins de ce blog.',
	'Choose the profile that best matches the requirements for this website.' => '', # Translate - New
	'Dynamic Archives Only' => 'Archives dynamiques uniquement',
	'Dynamic Publishing' => 'Publication dynamique',
	'Execute' => '', # Translate - New
	'High Priority Static Publishing' => 'Publication statique prioritaire',
	'Immediately publish Main Index and Feed templates, preferred Individual and Page archives statically. Use Publish Queue to publish all other templates statically.' => '', # Translate - New
	'Immediately publish all templates statically.' => 'Publier immédiatement tous les gabarits de manière statique.',
	'Publish all templates dynamically.' => 'Publier tous les gabarits en dynamique',
	'Publishing Profile' => 'Profil de publication',
	'Static Publishing' => 'Publication statique',
	'This new publishing profile will update your publishing settings.' => 'Ce nouveau profil de publication va mettre à jour vos paramètres de publication.',
	q{All templates published statically via Publish Que.} => q{Tous les gabarits sont publiés en statique via une publication en mode file d'attente.},
	q{Publish all Archive templates dynamically. Immediately publish all other templates statically.} => q{Publier tous les gabarits d'archives individuelles en dynamique. Publier immédiatement tous les autres gabarits en statique.},

## tmpl/cms/dialog/refresh_templates.tmpl
	'Cannot find template set. Please apply [_1]theme[_2] to refresh your templates.' => 'Impossible de trouver le groupe de gabarits. Veuillez appliquer [_1]theme[_2] pour mettre à jour vos gabarits.',
	'Deletes all existing templates and installs factory default template set.' => 'Supprime tous les gabarits existants et installe les groupes de gabarits par défaut.',
	'Refresh Global Templates' => 'Mettre à jour les gabarits globaux',
	'Refresh global templates' => 'Mettre à jour les gabarits globaux',
	'Reset to factory defaults' => 'Remettre à zéro les modifications',
	'Revert modifications of theme templates' => 'Annuler les modifications des gabarits de thème',
	'You have requested to <strong>refresh the current template set</strong>. This action will:' => 'Vous avez demandé à <strong>réactualiser le groupe de gabarit actuel</strong>. Cette action va :',
	'You have requested to <strong>refresh the global templates</strong>. This action will:' => 'Vous avez demandé à <strong>rafraîchir les gabarits globaux</strong>. Cette action va :',
	'You have requested to <strong>reset to the default global templates</strong>. This action will:' => 'Vous avez demandé à <strong>rétablir les gabarits globaux par défaut</strong>. Cette action va :',
	'delete all of the templates in your blog' => 'supprimer tous les gabarits de votre blog',
	'delete all of your global templates' => 'supprimer tous vos gabarits globaux',
	'install new templates from the default global templates' => 'installer de nouveaux gabarits issus des gabarits globaux par défaut',
	'install new templates from the selected template set' => 'installer de nouveaux gabarits depuis le groupe de gabarits sélectionné',
	'make backups of your templates that can be accessed through your backup filter' => 'faire des copies de sauvegarde de vos gabarits qui pourront être accessibles via votre filtre de sauvegarde',
	'overwrite some existing templates with new template code' => 'remplacer le code de certains gabarits par un nouveau code',
	'potentially install new templates' => 'potentiellement installer de nouveaux gabarits',
	q{Deletes all existing templates and install the selected theme's default.} => q{Supprimer tous les gabarits existants et installer les gabarits par défaut pour les thèmes sélectionnés.},
	q{Make backups of existing templates first} => q{Faire d'abord des sauvegardes des gabarits existants},
	q{Reset to theme defaults} => q{Réinitialiser les thèmes comme à l'origine},
	q{Updates current templates while retaining any user-created templates.} => q{Met à jour les gabarits courants tout en conservant les gabarits créés par l'utilisateur.},
	q{You have requested to <strong>apply a new template set</strong>. This action will:} => q{Vous avez demandé d'<strong>appliquer un nouveau groupe de gabarits</strong>. Cette action va :},

## tmpl/cms/dialog/restore_end.tmpl
	'All data restored successfully!' => 'Toutes les données ont été restaurées avec succès !',
	'Close (s)' => 'Fermer (s)',
	'Next Page' => 'Page suivante',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => 'Cette page va être redirigée vers une nouvelle page dans 3 secondes. [_1]Arrêter la redirection.[_2]',
	q{An error occurred during the restore process: [_1] Please check your restore file.} => q{Une erreur s'est produite pendant la procédure de restauration : [_1] Merci de vérifier votre fichier de restauration.},
	q{View Activity Log (v)} => q{Voir le journal d'activité (v)},

## tmpl/cms/dialog/restore_start.tmpl
	'Restoring...' => 'Restauration...',

## tmpl/cms/dialog/restore_upload.tmpl
	'Please upload the file [_1]' => 'Veuillez télécharger le fichier [_1]',
	'Restore: Multiple Files' => 'Restauration : plusieurs fichiers',
	q{Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?} => q{L'annulation de la procédure va créer des objets orphelins.  Voulez-vous vraiment annuler l'opération de restauration ?},

## tmpl/cms/dialog/select_association_type.tmpl
	'Grant blog permission to group' => 'Ajouter une autorisation de groupe sur un blog',
	'Grant blog permission to user' => 'Ajouter une autorisation utilisateur sur un blog',
	'Grant website permission to group' => 'Ajouter une autorisation de groupe sur un site',
	'Grant website permission to user' => 'Ajouter une autorisation utilisateur sur un site',

## tmpl/cms/dialog/select_theme.tmpl
	'Select Personal blog theme' => 'Sélectionner un thème de blog personnel',

## tmpl/cms/edit_asset.tmpl
	'Appears in...' => 'Apparaît dans...',
	'Copy' => '', # Translate - New
	'Edit Asset' => 'Éditer les éléments',
	'Related Assets' => 'Éléments liés',
	'Stats' => 'Stats',
	'You have unsaved changes to this asset that will be lost.' => 'Des modifications en cours sur cet élément seront perdues.',
	'[_1] - Created by [_2]' => '[_1] - a été créé par [_2]',
	'[_1] - Modified by [_2]' => '[_1] - modifié par [_2]',
	'[_1] is missing' => '[_1] est manquant',
	q{Embed Asset} => q{Adresse pour embarquer l'élément},
	q{This asset has been used by other users.} => q{Cet élément a été utilisé par d'autres utilisateurs.},
	q{You must specify a name for the asset.} => q{Vous devez spécifier un nom pour l'élément.},

## tmpl/cms/edit_author.tmpl
	'(Use Website/Blog Default)' => '(Utiliser les paramètres du site web/blog)',
	'Date Format' => 'Format de date',
	'Enter preferred password.' => 'Saisissez le mot de passe préféré.',
	'Existing password required to create a new password.' => 'Mot de passe actuel nécessaire pour créer un nouveau mot de passe.',
	'External user ID' => 'ID utilisateur externe',
	'Full' => 'Entière',
	'Initiate Password Recovery' => 'Récupérer le mot de passe',
	'Password recovery word/phrase' => 'Indice de récupération du mot de passe',
	'Preferences' => 'Préférences',
	'Preferred method of separating tags.' => 'Méthode préférée pour séparer les tags.',
	'Relative' => 'Relative',
	'Reveal' => 'Révéler',
	'Save changes to this author (s)' => 'Enregistrer les modifications de cet auteur (s)',
	'System Permissions' => 'Autorisations système',
	'Tag Delimiter' => 'Délimiteur de tags',
	'Text Format' => 'Format du texte',
	'The name displayed when content from this user is published.' => 'Le nom affiché lorsque le contenu de cet utilisateur est publié.',
	'This profile has been unlocked.' => 'Ce profil á été déverrouillé.',
	'This user was classified as disabled.' => 'Cet utilisateur a été marqué comme désactivé.',
	'This user was classified as pending.' => 'Cet utilisateur a été marqué comme en attente.',
	'This user was locked out.' => 'Cet utilisateur a été verrouillé.',
	'Web Services Password' => 'Mot de passe des services web',
	'You must use half-width character for password.' => 'Vous devez utiliser des caractères de demi-largeur pour le mot de passe.',
	'Your web services password is currently' => 'Votre mot de passe des services web est actuellement',
	'_USAGE_PASSWORD_RESET' => 'Ci-dessous, vous pouvez réinitialiser le mot de passe pour cet utilisateur. Si vous faites cela un mot de passe généré aléatoirement sera créé et envoyé par e-mail à : [_1].',
	'_USER_PENDING' => 'Utilisateur en attente',
	'_WARNING_PASSWORD_RESET_SINGLE' => 'Vous êtes sur le point de réinitialiser le mot de passe pour "[_1]". Un nouveau mot de passe sera généré aléatoirement et envoyé directement à leur adresse e-mail ([_2]). Voulez-vous continuer ?',
	q{A new password has been generated and sent to the email address [_1].} => q{Un nouveau mot de passe a été créé et envoyé à l'adresse [_1].},
	q{Create User (s)} => q{Créer l'utilisateur (s)},
	q{Create personal blog for user} => q{Créer le blog personnel de l'utilisateur},
	q{Default date formatting in the Movable Type interface.} => q{Le format de date par défaut dans l'interface Movable Type.},
	q{Default text formatting filter when creating new entries and new pages.} => q{Filtres de mise en forme par défaut lors de la création d'une nouvelle note ou page},
	q{Display language for the Movable Type interface.} => q{Langue d'affichage pour l'interface Movable Type.},
	q{Error occurred while removing userpic.} => q{Une erreur est survenue lors du retrait de l'avatar.},
	q{For use by Activity feeds and with XML-RPC and Atom-enabled clients.} => q{Pour utilisation par les flux d'activité et avec les clients XML-RPC ou Atom.},
	q{If you want to unlock this user click the 'Unlock' link. <a href="[_1]">Unlock</a>} => q{Si vous souhaitez déverrouiller cet utilisateur, cliquez sur le lien 'Déverrouiller'. <a href="[_1]">Déverrouiller</a>},
	q{Remove Userpic} => q{Supprimer l'image de l'utilisateur},
	q{Select Userpic} => q{Sélectionner l'image de l'utilisateur},
	q{Status of user in the system. Disabling a user prevents that person from using the system but preserves their content and history.} => q{Statut d'un utilisateur dans le système. Désactiver un utilisateur évite que cette personne utilise le système mais garde son contenu et ses historiques.},
	q{The email address associated with this user.} => q{L'adresse e-mail associée à cet utilisateur.},
	q{The image associated with this user.} => q{L'image associée à cet utilisateur.},
	q{The username used to login.} => q{L'identifiant utilisé pour s'identifier.},
	q{This User's website (e.g. http://www.movabletype.com/).  If the Website URL and Display Name fields are both populated, Movable Type will by default publish entries and comments with bylines linked to this URL.} => q{Le site web de cet utilisateur. Si le site web et le nom affiché sont tous les deux remplis, Movable Type publiera par défaut les notes et commentaires avec un lien vers cette URL.},
	q{This word or phrase is not used in the password recovery.} => q{Ce mot ou cette phrase n'est pas utilisé dans la récupération du mot de passe.},
	q{User properties} => q{Propriétés de l'utilisateur},

## tmpl/cms/edit_blog.tmpl
	'Blog Theme' => 'Thème du blog',
	'Create Blog (s)' => 'Créer le blog (s)',
	'Create Blog' => 'Créer un blog',
	'Name your blog. The blog name can be changed at any time.' => 'Nommez votre blog. Le nom peut être changé à tout moment.',
	'Select the theme you wish to use for this blog.' => 'Sélectionnez le thème que vous voudriez utiliser pour ce blog.',
	'Select your timezone from the pulldown menu.' => 'Veuillez sélectionner votre fuseau horaire dans la liste.',
	'You must set your Local Site Path.' => 'Vous devez configurer le chemin local de votre site.',
	'Your blog configuration has been saved.' => 'La configuration de votre blog a été sauvegardée.',
	q{Enter the URL of your Blog. Exclude the filename (i.e. index.html). Example: http://www.example.com/blog/} => q{Entrez l'URL de votre blog. Excluez le nom de fichier (comme index.html). Exemple : http://www.exemple.com/blog/},
	q{The path where your index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Le chemin où vos fichiers d'index seront situés. Un chemin absolu (commençant par '/' pour Linux ou 'C:\' pour Windows) est conseillé. Ne pas terminer par '/' ou '\'. Exemple : /home/mt/public_html ou C:\www\public_html},
	q{The path where your index files will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Le chemin où vos fichiers d'index seront situés. Ne pas terminer par '/' ou '\'.  Exemple : /home/mt/public_html/blog ou C:\www\public_html\blog},

## tmpl/cms/edit_category.tmpl
	'Edit Category' => 'Éditer les catégories',
	'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you create an entry in this category. (Separate URLs with a carriage return.)' => 'Saisir les URLs des sites web auxquels vous souhaitez envoyer un TrackBack chaque fois que vous créez une note dans cette catégorie. (Séparez les URLs avec un retour chariot.)',
	'If enabled, TrackBacks will be accepted for this category from any source.' => 'Si activé, les TrackBacks seront acceptés pour cette catégorie quelle que soit la source.',
	'Inbound TrackBacks' => 'TrackBacks entrants',
	'Manage entries in this category' => 'Gérer les notes dans cette catégorie',
	'Outbound TrackBacks' => 'TrackBacks sortants',
	'Passphrase Protection' => 'Protection par une phrase',
	'Please enter a valid basename.' => 'Veuillez entrer un nom de base valide.',
	'Save changes to this category (s)' => 'Enregistrer les modifications de cette catégorie (s)',
	'This is the basename assigned to your category.' => 'Ceci est le nom de base assigné à votre catégorie.',
	'TrackBack URL for this category' => 'URL de TrackBack pour cette catégorie',
	'Trackback URLs' => 'URLs de TrackBack',
	'View TrackBacks' => 'Voir les TrackBacks',
	'You must specify a basename for the category.' => 'Vous devez spécifier un nom de base pour cette catégorie.',
	'You must specify a label for the category.' => 'Vous devez spécifier un label pour cette catégorie.',
	'_CATEGORY_BASENAME' => 'Nom de base',
	q{Warning: Changing this category's basename may break inbound links.} => q{Attention : changer le nom de base de la catégorie risque de casser des liens entrants.},
	q{_USAGE_CATEGORY_PING_URL} => q{Il s'agit de l'URL utilisée par vos lecteurs pour envoyer des TrackBacks aux notes de votre blog. Si vous souhaitez permettre l'envoi de TrackBack par tout le monde, publiez cette URL. Si vous préférez réserver l'envoi de TrackBack à seulement certaines personnes, communiquez cette URL de manière privée. Enfin, si vous souhaitez inclure la liste des TrackBacks entrants dans l'index de votre gabarit, consultez la documentation Movable Type.},

## tmpl/cms/edit_comment.tmpl
	'(Banned)' => '(Banni)',
	'(Pending)' => '(En attente)',
	'(Trusted)' => '(Fiable)',
	'Ban Commenter' => 'Bannir le commentateur',
	'Date this comment was made' => 'Date du commentaire',
	'Date' => 'Date',
	'Delete this comment (x)' => 'Supprimer ce commentaire (x)',
	'Email address of commenter' => 'Adresse e-mail du commentateur',
	'Fulltext of the comment entry' => 'Texte complet de ce commentaire',
	'IP Address of the commenter' => 'Adresse IP du commentateur',
	'Manage Comments' => 'Gérer les commentaires',
	'Reply to this comment' => 'Répondre à ce commentaire',
	'Reported as Spam' => 'Notifié comme spam',
	'Responses to this comment' => 'Réponses à ce commentaire',
	'Results' => 'Résultats',
	'Save changes to this comment (s)' => 'Enregistrer les modifications de ce commentaire (s)',
	'Score' => 'Score',
	'Test' => 'Test',
	'The comment has been approved.' => 'Ce commentaire a été approuvé.',
	'The name of the person who posted the comment' => 'Le nom de la personne qui a posté le commentaire',
	'This comment was classified as spam.' => 'Ce commentaire a été marqué comme spam',
	'Total Feedback Rating: [_1]' => 'Note globale de feedback : [_1]',
	'Trust Commenter' => 'Considérer le commentateur comme fiable',
	'Trusted' => 'Fiable',
	'URL of commenter' => 'URL du commentateur',
	'Unavailable for OpenID user' => 'Non disponible pour les utilisateurs OpenID',
	'Unban Commenter' => 'Lever le bannissement du commentateur',
	'Untrust Commenter' => 'Considérer le commentateur comme pas sûr',
	'Update the status of this comment' => 'Mettre à jour le statut de ce commentaire',
	'View [_1] comment was left on' => 'Voir la [_1] qui a reçu ce commentaire',
	'View all comments by this commenter' => 'Afficher tous les commentaires de ce commentateur',
	'View all comments created on this day' => 'Voir tous les commentaires créés ce jour',
	'View all comments from this IP Address' => 'Afficher tous les commentaires associés à cette adresse IP',
	'View all comments on this [_1]' => 'Voir tous les commentaires sur cette [_1]',
	'View all comments with this URL' => 'Afficher tous les commentaires associés à cette URL',
	'View all comments with this email address' => 'Afficher tous les commentaires associés à cette adresse e-mail',
	'View all comments with this status' => 'Voir tous les commentaires avec ce statut',
	'View this commenter detail' => 'Voir les détails du commentateur',
	'[_1] this comment was made on' => '[_1] où ce commentaire a été posté',
	'_external_link_target' => '_blank',
	'comment' => 'commentaire',
	'comments' => 'commentaires',
	q{No url in profile} => q{Pas d'URL dans le profil},
	q{[_1] no longer exists} => q{[_1] n'existe plus},

## tmpl/cms/edit_commenter.tmpl
	'Authenticated' => 'Authentifié',
	'Ban user (b)' => 'Bannir cet utilisateur (t)',
	'Ban' => 'Bannir',
	'Commenter Details' => 'Détails sur le commentateur',
	'Identity' => 'Identité',
	'The Name of the commenter' => 'Le nom du commentateur',
	'The commenter has been banned.' => 'Le commentateur a été banni.',
	'The commenter has been trusted.' => 'Le commentateur est fiable.',
	'The trusted status of the commenter' => 'Le statut de confiance de ce commentateur',
	'Trust user (t)' => 'Donner le statut fiable à cet utilisateur (t)',
	'Trust' => 'Fiable',
	'Unban user (b)' => 'Annuler le bannissement de cet utilisateur (t)',
	'Unban' => 'Non banni',
	'Untrust user (t)' => 'Donner le statut non fiable à cet utilisateur (t)',
	'Untrust' => 'Non fiable',
	'View all comments with this name' => 'Afficher tous les commentaires associés à ce nom',
	'Withheld' => 'Retenu',
	'commenter' => 'le commentateur',
	'commenters' => 'Commentateurs',
	q{The Email Address of the commenter} => q{L'adresse e-mail du commentateur},
	q{The Identity of the commenter} => q{L'identité du commentateur},
	q{The Website URL of the commenter} => q{L'URL du site du commentateur},

## tmpl/cms/edit_entry.tmpl
	'(comma-delimited list)' => '(liste délimitée par virgule)',
	'(space-delimited list)' => '(liste délimitée par espace)',
	'<a href="[_2]">[_1]</a>' => '<a href="[_2]">[_1]</a>',
	'A saved version of this entry was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Une version enregistrée de cette note a été sauvegardée automatiquement [_2]. <a href="[_1]">Récupérer le contenu sauvegardé automatiquement</a>',
	'A saved version of this page was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Une version enregistrée de cette page a été sauvegardée automatiquement [_2]. <a href="[_1]">Récupérer le contenu sauvegardé automatiquement</a>',
	'Accept' => 'Accepter',
	'Add category' => 'Ajouter une catégorie',
	'Add new category parent' => 'Ajouter une nouvelle catégorie parente',
	'Add new folder parent' => 'Ajouter un nouveau répertoire parent',
	'An error occurred while trying to recover your saved entry.' => 'Une erreur est survenue lors de la tentative de récupération de la note enregistrée.',
	'An error occurred while trying to recover your saved page.' => 'Une erreur est survenue lors de la tentative de récupération de la page enregistrée.',
	'Auto-saving...' => 'Sauvegarde automatique...',
	'Category Name' => 'Nom de la catégorie',
	'Change Folder' => 'Modifier le dossier',
	'Change note' => 'Commentaire sur la modification',
	'Converting to rich text may result in changes to your current document.' => 'Convertir en texte riche peut entraîner des modifications au document actuel.',
	'Create Page' => 'Créer une page',
	'Delete this entry (x)' => 'Supprimer cette note (x)',
	'Delete this page (x)' => 'Supprimer cette page (x)',
	'Draft this [_1]' => 'Mettre cette [_1] en brouillon',
	'Edit Entry' => 'Éditer une note',
	'Edit Page' => 'Éditer une page',
	'Enter the text to link to:' => 'Saisissez le texte du lien :',
	'Format:' => 'Format :',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Dernière sauvegarde automatique à [_1] : [_2] : [_3]',
	'Make primary' => 'Rendre principal',
	'Manage Entries' => 'Gérer les notes',
	'No assets' => 'Aucun élément',
	'None selected' => 'Aucune sélectionnée',
	'Not specified' => 'Non spécifiée',
	'Outbound TrackBack URLs' => 'URLs des TrackBacks sortants',
	'Permalink:' => 'Lien permanent :',
	'Preview this entry (v)' => 'Prévisualiser cette note (v)',
	'Preview this page (v)' => 'Prévisualiser cette page (v)',
	'Publish On' => 'Publiée le',
	'Publish this [_1]' => 'Publier cette [_1]',
	'Remove this asset.' => 'Supprimer cet élément.',
	'Reset defaults' => 'Réinitialiser les valeurs par défaut',
	'Restored revision (Date:[_1]).  The current status is: [_2]' => 'Révision (date : [_1]) restaurée. Le statut actuel est : [_2].',
	'Save this [_1]' => 'Enregistrer cette [_1]',
	'Schedule' => 'Planifier',
	'Share' => 'Partager',
	'Some [_1] in the revision could not be loaded because they have been removed.' => 'Certain(e)s [_1] dans cette révision ne peuvent pas être chargées car elles ont été retirées.',
	'Some of tags in the revision could not be loaded because they have been removed.' => 'Certains tags dans cette révision ne peuvent pas être chargés car ils ont été retirés.',
	'This entry has been saved.' => 'Cette note a été enregistrée.',
	'This page has been saved.' => 'Cette page a été enregistrée.',
	'This post was classified as spam.' => 'Cette note a été marquée comme étant du spam.',
	'This post was held for review, due to spam filtering.' => 'Cette note a été retenue pour vérification, à cause du filtrage spam.',
	'Unpublish this [_1]' => 'Dépublier cette [_1]',
	'Unpublished (Draft)' => 'Non publiée (Brouillon)',
	'Unpublished (Review)' => 'Non publiée (Vérification)',
	'Unpublished (Spam)' => 'Non publié (spam)',
	'Update this [_1]' => 'Mettre à jour cette [_1]',
	'Update' => 'Mettre à jour',
	'View Entry' => 'Afficher la note',
	'View Page' => 'Afficher une Page',
	'View Previously Sent TrackBacks' => 'Voir les TrackBacks envoyés précédemment',
	'You have successfully deleted the checked TrackBack(s).' => 'Le ou les TrackBacks sélectionnés ont été correctement supprimés.',
	'You have successfully deleted the checked comment(s).' => 'Les commentaires sélectionnés ont été supprimés.',
	'You have successfully recovered your saved entry.' => 'Vous avez récupéré le contenu sauvegardé de votre note avec succès.',
	'You have successfully recovered your saved page.' => 'Vous avez récupéré le contenu sauvegardé de votre page avec succès.',
	'You must configure this blog before you can publish this entry.' => 'Vous devez configurer ce blog avant de publier cette note.',
	'You must configure this blog before you can publish this page.' => 'Vous devez configurer ce blog avant de publier cette page.',
	'Your changes to the comment have been saved.' => 'Les modifications apportées aux commentaires ont été enregistrées.',
	'Your customization preferences have been saved, and are visible in the form below.' => 'Vos préférences ont été enregistrées et sont affichées dans le formulaire ci-dessous.',
	'Your notification has been sent.' => 'Votre notification a été envoyée.',
	'[_1] - Edited by [_2]' => '[_1] - a été édité par [_2]',
	'[_1] - Published by [_2]' => '[_1] - a été publié par [_2]',
	'[_1] Assets' => 'Éléments de la [_1]',
	'edit' => 'éditer',
	q{(delimited by '[_1]')} => q{(délimitée par '[_1]')},
	q{Enter the link address:} => q{Saisissez l'adresse du lien :},
	q{No revision(s) associated with this [_1]} => q{Aucune révision n'est associée à ce [_1]},
	q{One or more errors occurred when sending update pings or TrackBacks.} => q{Erreur lors de l'envoi des pings ou des TrackBacks.},
	q{Reset display options to blog defaults} => q{Réinitialiser les options d'affichage avec les valeurs par défaut du blog},
	q{Warning: Changing this entry's basename may break inbound links.} => q{Attention : changer le nom de base de cette note peut casser des liens entrants.},
	q{Warning: If you set the basename manually, it may conflict with another entry.} => q{Attention : éditer le nom de base manuellement peut créer des conflits avec d'autres notes.},
	q{You have unsaved changes to this entry that will be lost.} => q{Certains de vos changements dans cette note n'ont pas été enregistrés, ils seront perdus.},
	q{You have unsaved changes to this page that will be lost.} => q{Certains de vos changements dans cette page n'ont pas été enregistrés, ils seront perdus.},
	q{_USAGE_VIEW_LOG} => q{L'erreur est enregistrée dans le <a href="[_1]">journal d\'activité</a>.},

## tmpl/cms/edit_entry_batch.tmpl
	'Published Date' => 'Date de publication',
	'Save these [_1] (s)' => 'Sauvegarder ces [_1] (s)',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Modifier le répertoire',
	'Manage Folders' => 'Gérer les répertoires',
	'Manage pages in this folder' => 'Gérer les pages de ce dossier',
	'Path' => 'Chemin',
	'Save changes to this folder (s)' => 'Enregistrer les modifications de ce répertoire (s)',
	'You must specify a label for the folder.' => 'Vous devez spécifier un nom pour le répertoire.',

## tmpl/cms/edit_ping.tmpl
	'Delete this TrackBack (x)' => 'Supprimer ce TrackBack (x)',
	'Edit Trackback' => 'Éditer le TrackBack',
	'Excerpt of the TrackBack entry' => 'Extrait de la note du TrackBack',
	'Manage TrackBacks' => 'Gérer les TrackBacks',
	'No title' => 'Sans titre',
	'Save changes to this TrackBack (s)' => 'Enregistrer les modifications de ce TrackBack (s)',
	'Target Category' => 'Catégorie cible',
	'Target [_1]' => 'Cible [_1]',
	'The TrackBack has been approved.' => 'Le TrackBack a été approuvé.',
	'This trackback was classified as spam.' => 'Ce TrackBack a été marqué comme spam.',
	'TrackBack Text' => 'Texte du TrackBack',
	'Update the status of this TrackBack' => 'Modifier le statut de ce TrackBack',
	'View all TrackBacks created on this day' => 'Voir tous les TrackBacks créés ce jour',
	'View all TrackBacks from this IP address' => 'Afficher tous les TrackBacks avec cette adresse IP',
	'View all TrackBacks on this category' => 'Afficher tous les TrackBacks de cette catégorie',
	'View all TrackBacks on this entry' => 'Voir tous les TrackBacks pour cette note',
	'View all TrackBacks with this status' => 'Voir tous les TrackBacks avec ce statut',
	q{Category no longer exists} => q{La catégorie n'existe plus},
	q{Entry no longer exists} => q{Cette note n'existe plus},
	q{Search for other TrackBacks from this site} => q{Rechercher d'autres TrackBacks de ce site},
	q{Search for other TrackBacks with this status} => q{Rechercher d'autres TrackBacks avec ce statut},
	q{Search for other TrackBacks with this title} => q{Rechercher d'autres TrackBacks avec ce titre},

## tmpl/cms/edit_role.tmpl
	'Administration' => 'Administration',
	'Association (1)' => 'Association (1)',
	'Associations ([_1])' => 'Associations ([_1])',
	'Authoring and Publishing' => 'Édition et Publication',
	'Commenting' => 'Commenter',
	'Designing' => 'Design',
	'Duplicate Roles' => 'Dupliquer les rôles',
	'Edit Role' => 'Modifier le rôle',
	'Privileges' => 'Privilèges',
	'Role Details' => 'Détails du rôle',
	'Save changes to this role (s)' => 'Enregistrer les modifications de ce rôle (s)',
	'These roles have the same privileges as this role' => 'Ces rôles ont les mêmes privilèges que ce rôle',
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'Vous avez changé les privilèges pour ce rôle. Cela va modifier ce que les utilisateurs associés à ce rôle ont la possibilité de faire. Si vous préférez, vous pouvez sauvegarder ce rôle avec un nom différent.',

## tmpl/cms/edit_template.tmpl
	': every ' => ': chaque ',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => '<a href="[_1]" class="rebuild-link">Publier</a> ce gabarit.',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]">Recover auto-saved content</a>' => 'Une version de sauvegarde de [_1] a été automatiquement sauvegardée [_3]. <a href="[_2]">Récupérer le contenu sauvegardé</a>',
	'Archive map has been successfully updated.' => 'La table de correspondance des archives a été modifiée avec succès.',
	'Are you sure you want to remove this template map?' => 'Voulez-vous vraiment supprimer cette table de correspondance de gabarit ?',
	'Create Archive Mapping' => 'Créer une nouvelle table de correspondance des archives',
	'Create Template' => 'Créer un gabarit',
	'Create Widget' => 'Créer un widget',
	'Disabled (<a href="[_1]">change publishing settings</a>)' => 'Désactivé (<a href="[_1]">changer les paramètres de publication</a>)',
	'Do Not Publish' => 'Ne pas publier',
	'Dynamically' => 'Dynamique',
	'Edit Widget' => 'Éditer le widget',
	'Enabled Mappings: [_1]' => 'Tables des correspondances activées : [_1]',
	'Expire after' => 'Expire après',
	'Expire upon creation or modification of:' => 'Expire lors de la création ou modification de :',
	'Include cache path' => 'Inclure le chemin du cache',
	'Included Templates' => 'Gabarits inclus',
	'Learn more about <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publishing settings</a>' => 'Apprennez en plus à propos des <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">paramètres de publication</a>',
	'Link to File' => 'Lien vers le fichier',
	'List [_1] templates' => 'Lister les gabarits de type [_1]',
	'List all templates' => 'Lister tous les gabarits',
	'Manually' => 'Manuellement',
	'Module Body' => 'Corps du module',
	'Module Option Settings' => 'Paramètres des options de module',
	'No caching' => 'Pas de cache',
	'No revision(s) associated with this template' => 'Aucune révision associée à ce gabarit',
	'On a schedule' => 'Planifié',
	'Output file: <strong>[_1]</strong>' => 'Fichier de sortie : <strong>[_1]</strong>',
	'Process as <strong>[_1]</strong> include' => 'Traiter comme inclusion de <strong>[_1]</strong>',
	'Restored revision (Date:[_1]).' => 'Révision restaurée (date : [_1]).',
	'Save &amp; Publish' => 'Enregistrer &amp; publier',
	'Save Changes (s)' => 'Sauvegarder les modifications',
	'Save and Publish this template (r)' => 'Enregistrer et publier ce gabarit (r)',
	'Server Side Include' => 'Inclusion côté serveur (SSI)',
	'Statically (default)' => 'Statique (défaut)',
	'Syntax highlighting Off' => 'Coloration syntaxique désactivée',
	'Syntax highlighting On' => 'Coloration syntaxique activée',
	'Template Body' => 'Corps du gabarit',
	'Template Options' => 'Options de gabarit',
	'Template Tag Docs' => 'Docs des balises de gabarits',
	'Template Type' => 'Type de gabarit',
	'Unrecognized Tags' => 'Balises non reconnues',
	'Useful Links' => 'Liens utiles',
	'View Published Template' => 'Voir le gabarit publié',
	'View revisions of this template' => 'Voir les révisions de ce gabarit',
	'You have successfully recovered your saved [_1].' => 'Vous avez récupéré avec succès votre [_1] sauvegardé.',
	'You must set the Template Name.' => 'Vous devez fournir un nom de gabarit.',
	'You must set the template Output File.' => 'Vous devez configurer le fichier de sortie du gabarit.',
	'Your [_1] has been published.' => 'Votre [_1] a été publié.',
	'create' => 'créer',
	'hours' => 'heures',
	'minutes' => 'minutes',
	q{An error occurred while trying to recover your saved [_1].} => q{Une erreur s'est produite en essayant de récupérer votre [_1] sauvegardée.},
	q{Custom Index Template} => q{Gabarit d'index personnalisé},
	q{Error occurred while updating archive maps.} => q{Une erreur s'est produite en mettant à jour les tables de correspondance des archives.},
	q{Processing request...} => q{Requête en cours d'exécution...},
	q{Via Publish Queue} => q{Via une publication en mode file d'attente},
	q{You have unsaved changes to this template that will be lost.} => q{Certains de vos changements à ce gabarit n'ont pas été enregistrés, ils seront perdus.},

## tmpl/cms/edit_website.tmpl
	'Create Website (s)' => 'Créer un site web (s)',
	'Create Website' => 'Créer un site web',
	'Name your website. The website name can be changed at any time.' => 'Nommez votre site web. Ce nom peut être changé à tout moment.',
	'Please enter a valid URL.' => 'Veuillez entrer une URL valide.',
	'Please enter a valid site path.' => 'Veuillez entrer un chemin de site valide.',
	'Select the theme you wish to use for this website.' => 'Sélectionnez le thème que vous voudriez utiliser pour ce site web.',
	'This field is required.' => 'Ce champ est requis.',
	'Website Theme' => 'Thème du site web',
	q{Enter the URL of your website. Exclude the filename (i.e. index.html). Example: http://www.example.com/} => q{Entrez l'URL de votre site web, sans nom de fichier (comme index.html). Exemple : http://www.exemple.com/},
	q{Enter the path where your main index file will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/ or C:\www\public_html} => q{Entrez le chemin où vos fichiers d'index seront situés. Un chemin absolu (commençant par '/' pour Linux ou 'C:\' pour Windows) est conseillé, mais vous pouvez également utiliser un chemin relatif au répertoire Movable Type. Exemple : /home/melody/public_html/ ou C:\www\public_html},
	q{You did not select a timezone.} => q{Vous n'avez pas sélectionné de fuseau horaire.},

## tmpl/cms/edit_widget.tmpl
	'Available Widgets' => 'Widgets disponibles',
	'Create Widget Set' => 'Créer un groupe de widgets',
	'Edit Widget Set' => 'Modifier le groupe de widgets',
	'Installed Widgets' => 'Widgets installés',
	'Save changes to this widget set (s)' => 'Enregistrer les modifications de ce groupe de widgets',
	'Widget Set Name' => 'Nom du groupe de widget',
	'You must set Widget Set Name.' => 'Vous devez nommer ce groupe de widgets.',
	q{Drag and drop the widgets that belong in this Widget Set into the 'Installed Widgets' column.} => q{Glissez-déposez les widgets destinés à ce groupe de widgets dans la colonne 'Widgets installés'.},

## tmpl/cms/error.tmpl
	q{An error occurred} => q{Une erreur s'est produite},

## tmpl/cms/export.tmpl
	'Export [_1] Entries' => 'Exporter [_1] notes',
	'Export [_1]' => 'Exporter le [_1]',
	'[_1] to Export' => '[_1] à exporter',
	q{_USAGE_EXPORT_1} => q{L'exportation vous permet de sauvegarder le contenu de votre blog dans un fichier. Vous pourrez par la suite procéder à l'importation de ce fichier si vous souhaitez restaurer vos notes ou transférer vos notes d'un blog à un autre.},

## tmpl/cms/export_theme.tmpl
	'A description for this theme.' => 'Description du thème.',
	'A version number for this theme.' => 'Numéro de version de ce thème.',
	'Additional assets to be included in the theme.' => 'Éléments additionnels destinés à être inclus dans ce thème',
	'Basename may only contain letters, numbers, and the dash or underscore character. The basename must begin with a letter.' => 'Le nom de base ne peut contenir que des lettres, chiffres, tirets et tirets bas. Il doit commencer par une lettre.',
	'Destination' => 'Destination',
	'Export [_1] Themes' => 'Exporter les [_1] thèmes',
	'Select How to get theme.' => 'Sélectionnez comment récupérer le thème.',
	'Setting for [_1]' => 'Paramètres pour [_1]',
	'The name of your theme.' => 'Le nom de votre thème.',
	'Theme version may only contain letters, numbers, and the dash or underscore character.' => 'La version du thème ne peut contenir que des lettres, chiffres, tirets et tirets bas.',
	'Version' => 'Version',
	'You must set Theme Name.' => 'Vous devez entrer un nom de thème',
	'_THEME_AUTHOR' => 'Auteur',
	q{Author link} => q{Site de l'auteur},
	q{Cannot install new theme with existing (and protected) theme's basename.} => q{Impossible d'installer un nouveau thème avec un nom de base existant (et protégé).},
	q{The author of this theme.} => q{Nom de l'auteur de ce thème},
	q{The author's website.} => q{Lien vers le site web de l'auteur.},
	q{Theme package have been saved.} => q{L'archive du thème a été enregistrée.},
	q{Use letters, numbers, dash or underscore only (a-z, A-Z, 0-9, '-' or '_').} => q{Utiliser des lettres, chiffres, tirets ou tirets bas seulement (a-z, A-Z, 0-9, '-' ou '_').},

## tmpl/cms/import.tmpl
	'<mt:var name="display_name" escape="html">' => '<mt:var name="display_name" escape="html">',
	'Apply this formatting if text format is not set on each entry.' => 'Appliquer ce format si le format de texte est indéfini sur chaque note.',
	'Default category for entries (optional)' => 'Catégorie par défaut pour les notes (optionnel)',
	'Default password for new users:' => 'Mot de passe par défaut pour un nouvel utilisateur :',
	'Enter a default password for new users.' => 'Entrez un mot de passe par défaut pour les nouveaux utilisateurs.',
	'Import Entries (s)' => 'Importer les notes (s)',
	'Import [_1] Entries' => 'Importer [_1] notes',
	'Import as me' => 'Importer en me considérant comme auteur',
	'Importing from' => 'Importation à partir de',
	'Ownership of imported entries' => 'Propriétaire des notes importées',
	'Select a category' => 'Sélectionnez une catégorie',
	'You must select a blog to import.' => 'Vous devez sélectionner un blog à importer.',
	q{By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.} => q{Par défaut, Movable Type va essayer de détecter automatiquement l'encodage des caractères de vos fichiers importés.  Cependant, si vous rencontrez des difficultés, vous pouvez l'indiquer de manière explicite},
	q{If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.} => q{Si vous choisissez de garder les auteurs originaux des notes importées et qu'ils doivent être créés dans votre installation, vous devez définir un mot de passe par défaut pour ces nouveaux comptes.},
	q{If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the 'import' folder of your Movable Type directory.} => q{Si votre fichier d'import est situé sur votre ordinateur, vous pouvez le télécharger ici.  Sinon, Movable Type va automatiquement chercher dans le répertoire 'import' de votre répertoire Movable Type.},
	q{Import File Encoding} => q{Encodage du fichier d'import},
	q{Preserve original user} => q{Préserver l'utilisateur original},
	q{Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.} => q{Transférer les notes dans Movable Type depuis une autre installation Movable Type ou à partir d'un autre outil de publication de blogs afin de créer une sauvegarde ou une copie.},
	q{Upload import file (optional)} => q{Envoyer le fichier d'import (optionnel)},
	q{You can specify a default category for imported entries which have none assigned.} => q{Vous pouvez spécifier une catégorie par défaut pour les notes importées qui n'ont pas été assignées.},
	q{You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.} => q{Vous serez désigné comme auteur pour toutes les notes importées. Si vous voulez que l'auteur original en conserve la propriété, vous devez contacter votre administrateur MT pour qu'il fasse l'importation et le cas échéant qu'il crée un nouvel utilisateur.},

## tmpl/cms/import_others.tmpl
	'Default entry status (optional)' => 'Statut des notes par défaut (optionnel)',
	'End title HTML (optional)' => 'HTML de fin du titre (optionnel)',
	'Select an entry status' => 'Sélectionner un statut de note',
	'Start title HTML (optional)' => 'HTML de début de titre (optionnel)',
	q{If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.} => q{Si le logiciel à partir duquel vous importez n'a pas de champ titre, vous pouvez utiliser ce paramètre pour identifier un titre dans le corps de votre note.},
	q{If the software you are importing from does not specify an entry status in its export file, you can set this as the status to use when importing entries.} => q{Si le logiciel à partir duquel vous importez ne spécifie pas un statut pour les notes dans son fichier d'export, vous pouvez utiliser ce statut-ci lors de l'importation des notes.},

## tmpl/cms/include/anonymous_comment.tmpl
	'Allow comments from anonymous or unauthenticated users.' => 'Permettre les commentaires anonymes pour les utilisateurs non identifiés.',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Si activé, le visiteur doit donner une adresse e-mail valide pour commenter.',
	'Require name and E-mail Address for Anonymous Comments' => 'Nécessite une adresse e-mail pour les commentaires anonymes',

## tmpl/cms/include/archetype_editor.tmpl
	'Begin Blockquote' => 'Ajouter un bloc de citation',
	'Bold' => 'Gras',
	'Bulleted List' => 'Liste à puces',
	'Center Text' => 'Centrer le texte',
	'Decrease Text Size' => 'Diminuer la taille du texte',
	'Email Link' => 'Lien e-mail',
	'End Blockquote' => 'Retirer un bloc de citation',
	'HTML Mode' => 'Mode HTML',
	'Increase Text Size' => 'Augmenter la taille du texte',
	'Insert File' => 'Insérer un fichier',
	'Italic' => 'Italique',
	'Left Align Text' => 'Aligner le texte à gauche',
	'Numbered List' => 'Liste numérotée',
	'Right Align Text' => 'Aligner le texte à droite',
	'Text Color' => 'Couleur du texte',
	'Underline' => 'Souligné',
	'WYSIWYG Mode' => 'Mode WYSIWYG',
	q{Center Item} => q{Centrer l'élément},
	q{Check Spelling} => q{Vérifier l'orthographe},
	q{Left Align Item} => q{Aligner l'élément à gauche},
	q{Right Align Item} => q{Aligner l'élément à droite},

## tmpl/cms/include/asset_replace.tmpl
	'No' => 'Non',
	'Yes (s)' => 'Oui (s)',
	'Yes' => 'Oui',
	q{A file named '[_1]' already exists. Do you want to overwrite this file?} => q{Un fichier nommé '[_1]' existe déjà. Souhaitez-vous le remplacer ?},

## tmpl/cms/include/asset_table.tmpl
	'Asset Missing' => 'Élément manquant',
	'Delete selected assets (x)' => 'Effacer les contenus sélectionnés (x)',
	'No thumbnail image' => 'Pas de miniature',

## tmpl/cms/include/asset_upload.tmpl
	'Choose Folder' => 'Choisir le répertoire',
	'Select File to Upload' => 'Sélectionnez le fichier à télécharger',
	'Upload (s)' => 'Envoyer (s)',
	'Your system or [_1] administrator needs to publish the [_1] before you can upload files. Please contact your system or [_1] administrator.' => '
	Votre administrateur système ou de [_1] a besoin de publier le [_1] avant que vous puissiez télécharger des fichiers. Veuillez contacter votre administrateur système ou de [_1].',
	'[_1] contains a character that is invalid when used in a directory name: [_2]' => '[_1] contient un caractère invalide pour un nom de répertoire : [_2]',
	q{Asset file('[_1]') has been uploaded.} => q{Le fichier de l'élément ('[_1]') a été envoyé.},
	q{Before you can upload a file, you need to publish your [_1]. [_2]Configure your [_1]'s publishing paths[_3] and republish your [_1].} => q{Avant de pouvoir télécharger un fichier, vous devez publier votre [_1]. [_2]Configurez les chemins de publication[_3] de votre [_1] et republiez-le.},
	q{Cannot write to '[_1]'. Image upload is possible, but thumbnail is not created.} => q{Impossible d'écrire sur '[_1]'. L'envoi d'image est possible mais la vignette ne sera pas créée.},
	q{_USAGE_UPLOAD} => q{Vous pouvez télécharger le fichier ci-dessus dans le chemin local de votre site. Vous pouvez également télécharger le fichier dans un répertoire compris dans les répertoires mentionnés ci-dessus, en spécifiant le chemin dans le champ de droite (<i>images</i>, par exemple). Les répertoires qui n'existent pas encore seront créés.},

## tmpl/cms/include/async_asset_list.tmpl
	'All Types' => 'Tous les types',
	'[_1] - [_2] of [_3]' => '[_1] - [_2] sur [_3]',
	'label' => 'étiquette',
	q{Asset Type: } => q{Type d'élément : },

## tmpl/cms/include/async_asset_upload.tmpl
	'Cancelled: [_1]' => 'Annulé : [_1]',
	'Choose file to upload or drag file.' => 'Choisissez ou glissez le fichier à télécharger.',
	'Choose files to upload or drag files.' => 'Choisissez ou glissez les fichiers à télécharger.',
	'Drag and drop here' => 'Glissez et déposez ici',
	'Operation for a file exists' => 'Que faire si un fichier existe',
	'The file you tried to upload is too large: [_1]' => 'Le fichier que vous tentez de charger est trop volumineux : [_1]',
	'Upload Options' => 'Options de téléchargement',
	'Upload new asset' => 'Télécharger un nouvel élément',
	'Upload new image' => 'Envoyer une nouvelle image',
	q{[_1] is not a valid [_2] file.} => q{[_1] n'est pas un fichier [_2] valide.},

## tmpl/cms/include/author_table.tmpl
	'Disable selected users (d)' => 'Désactiver les utilisateurs sélectionnés (d)',
	'Enable selected users (e)' => 'Activer les utilisateurs sélectionnés (e)',
	'_NO_SUPERUSER_DISABLE' => 'Puisque vous êtes administrateur du système Movable Type, vous ne pouvez vous désactiver vous-même.',
	'user' => 'utilisateur',
	'users' => 'utilisateurs',

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been backed up successfully!' => 'Toutes les données ont été sauvegardées avec succès !',
	'Backup Files' => 'Fichiers de sauvegarde',
	'Download This File' => 'Télécharger ce fichier',
	'Download: [_1]' => 'Télécharger : [_1]',
	'_BACKUP_TEMPDIR_WARNING' => 'Les données demandées ont été sauvegardées avec succès dans le répertoire [_1]. Assurez-vous que vous téléchargez  <strong>puis supprimez</ strong> les fichiers mentionnés ci-dessus à partir de [_1] <strong>immédiatement</ strong> car les fichiers de sauvegarde contiennent des informations sensibles.',
	q{_BACKUP_DOWNLOAD_MESSAGE} => q{Le téléchargement du fichier de sauvegarde démarre automatiquement en quelques secondes. Si ce n'est pas le cas, <a href="javascript:(void)" onclick="submit_form()">cliquez  ici</ a> pour commencer à télécharger manuellement. Notez que vous pouvez télécharger le fichier de sauvegarde une seule fois par session.},

## tmpl/cms/include/backup_start.tmpl
	'Backing up Movable Type' => 'Sauvegarde de Movable Type',

## tmpl/cms/include/basic_filter_forms.tmpl
	'[_1] [_2] [_3]' => '[_1] [_2] [_3]',
	'[_1] and [_2]' => '[_1] et [_2]',
	'_FILTER_DATE_DAYS' => '[_1] jours',
	'__FILTER_DATE_ORIGIN' => '[_1]',
	'__INTEGER_FILTER_EQUAL' => 'est',
	'__INTEGER_FILTER_NOT_EQUAL' => 'est',
	'__STRING_FILTER_EQUAL' => 'est',
	'contains' => 'contient',
	'does not contain' => 'ne contient pas',
	'ends with' => 'se termine par',
	'is after now' => 'est après maintenant',
	'is after' => 'est après',
	'is before now' => 'est avant maintenant',
	'is before' => 'est avant',
	'is between' => 'est entre',
	'is greater than or equal to' => 'est plus grand ou égal à',
	'is greater than' => 'est plus grand que',
	'is less than or equal to' => 'est plus petit ou égal à',
	'is less than' => 'est plus petit que',
	'is within the last' => 'est dans les derniers',
	'starts with' => 'commence par',

## tmpl/cms/include/blog_table.tmpl
	'Delete selected [_1] (x)' => 'Supprimer le(s) [_1] sélectionné(s) (x)',
	'[_1] Name' => 'Nom [_1]',
	q{Some templates were not refreshed.} => q{Certains gabarits n'ont pas été mis à jour.},

## tmpl/cms/include/category_selector.tmpl
	'Add sub category' => 'Ajouter une sous-catégorie',
	'Add sub folder' => 'Ajouter un sous-dossier',

## tmpl/cms/include/comment_table.tmpl
	'([quant,_1,reply,replies])' => '([quant,_1,réponse,réponses])',
	'Blocked' => 'Bloqués',
	'Delete selected comments (x)' => 'Supprimer les commentaires sélectionnés (x)',
	'Edit this [_1] commenter' => 'Modifier le commentateur de cette [_1]',
	'Edit this comment' => 'Éditer ce commentaire',
	'Publish selected comments (a)' => 'Publier les commentaires sélectionnés (a)',
	'Search for all comments from this IP address' => 'Rechercher tous les commentaires associés à cette adresse IP',
	'Search for comments by this commenter' => 'Chercher les commentaires de ce commentateur',
	'View this entry' => 'Voir cette note',
	'View this page' => 'Voir cette page',
	'to republish' => 'pour republier',

## tmpl/cms/include/commenter_table.tmpl
	'Edit this commenter' => 'Éditer ce commentateur',
	'Last Commented' => 'Dernier commenté',
	'View this commenter&rsquo;s profile' => 'Voir le profil de ce commentateur',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001 Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001 Six Apart. Tous droits réservés.',

## tmpl/cms/include/display_options.tmpl
	'Compact' => 'Compacte',
	'Expanded' => 'Étendue',
	'[quant,_1,row,rows]' => '[quant,_1,ligne,lignes]',
	q{Display Options} => q{Options d'affichage},
	q{Save display options} => q{Enregistrer les options d'affichage},

## tmpl/cms/include/entry_table.tmpl
	'<a href="[_1]">Create an entry</a> now.' => '<a href="[_1]">Créer une note</a> maintenant.',
	'Created' => 'Créé',
	'Last Modified' => 'Dernière modification',
	'Republish selected [_1] (r)' => 'Republier les [_1] sélectionné(e)s (r)',
	'View entry' => 'Afficher une note',
	'View page' => 'Afficher une page',
	q{No entries could be found.} => q{Aucune note n'a été trouvée.},
	q{No pages could be found. <a href="[_1]">Create a page</a> now.} => q{Aucune page n'a été trouvée. <a href="[_1]">Créer une page</a> maintenant.},

## tmpl/cms/include/feed_link.tmpl
	'Set Web Services Password' => 'Définir un mot de passe pour les services web',

## tmpl/cms/include/footer.tmpl
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]',
	'Forums' => 'Forums',
	'MovableType.org' => 'MovableType.org',
	'Send Us Feedback' => 'Faites-nous part de vos remarques',
	'Support' => 'Support',
	'Wiki' => 'Wiki',
	'Your Dashboard' => 'Votre tableau de bord',
	'http://forums.movabletype.org/' => 'http://forums.movabletype.org/',
	'http://plugins.movabletype.org/' => 'http://plugins.movabletype.org/',
	'http://wiki.movabletype.org/' => 'http://wiki.movabletype.org/',
	'http://www.movabletype.org' => 'http://www.movabletype.org/',
	'with' => 'avec',
	q{This is a beta version of Movable Type and is not recommended for production use.} => q{Ceci est une version beta de Movable Type et n'est pas recommandée pour une utilisation en production.},
	q{_LOCALE_CALENDAR_HEADER_} => q{'D', 'L', 'M', 'M', 'J', 'V', 'S'},

## tmpl/cms/include/header.tmpl
	'Help' => 'Aide',
	'Search (q)' => 'Recherche (q)',
	'Select an action' => 'Sélectionner une action',
	'View Site' => 'Voir le site',
	'You have <strong>[quant,_1,message,messages]</strong> from the system.' => 'Vous avez <strong>[quant,_1,message,messages]</strong> du système.',
	q{This website was created during the upgrade from a previous version of Movable Type. 'Site Root' and 'Site URL' are left blank to retain 'Publishing Paths' compatibility for blogs that were created in a previous version. You can post and publish on existing blogs, but you cannot publish this website itself because of the blank 'Site Root' and 'Site URL'.} => q{
	Ce site a été créé durant une mise à jour d'une version précédente de Movable Type. 'Racine du site' et 'URL du site' sont laissés en blanc afin de garder la compatibilité des 'Chemins de publication' pour les blogs créés dans une version précédente. Vous pouvez poster et publier sur les blogs existants mais vous ne pouvez pas publier ce site en lui-même car 'Racine du site' et 'URL du site' sont laissés en blanc.},
	q{from Revision History} => q{depuis l'historique de révision},

## tmpl/cms/include/import_end.tmpl
	'<a href="#" onclick="[_1]" class="mt-build">Publish your site</a> to see these changes take effect.' => '<a href="#" onclick="[_1]" class="mt-build">Publiez votre site</a> pour appliquer ces modifications en ligne.',
	'All data imported successfully!' => 'Toutes les données ont été importées avec succès !',

## tmpl/cms/include/import_start.tmpl
	'Creating new users for each user found in the [_1]' => 'Création de nouveaux utilisateur correspondant à chaque utilisateur trouvé dans le [_1]',
	'Importing entries into [_1]' => 'Importation de notes dans le [_1]',
	'Importing...' => 'Importation...',
	q{Importing entries as user '[_1]'} => q{Importation des notes en tant qu'utilisateur '[_1]'},

## tmpl/cms/include/itemset_action_widget.tmpl
	'Plugin Actions' => 'Actions du plugin',
	q{More actions...} => q{Plus d'actions...},

## tmpl/cms/include/list_associations/page_title.tmpl
	'Manage Permissions' => 'Gérer les autorisations',
	'Users for [_1]' => 'Utilisateurs pour [_1]',

## tmpl/cms/include/listing_panel.tmpl
	'Go to [_1]' => 'Aller à [_1]',
	'OK (s)' => 'OK (s)',
	'Step [_1] of [_2]' => 'Étape [_1] sur [_2]',
	q{Sorry, there is no data for this object set.} => q{Désolé, il n'y a pas de données pour cet ensemble d'objets.},
	q{Sorry, there were no results for your search. Please try searching again.} => q{Désolé, aucun résultat trouvé pour cette recherche. Merci d'essayer à nouveau.},

## tmpl/cms/include/log_table.tmpl
	'IP: [_1]' => 'IP : [_1]',
	'_LOG_TABLE_BY' => 'Utilisateur',
	q{No log records could be found.} => q{Aucune donnée du journal n'a été trouvée.},

## tmpl/cms/include/member_table.tmpl
	'Are you sure you want to remove the [_1] selected users from this [_2]?' => 'Voulez-vous vraiment retirer les [_1] utilisateurs sélectionnés de ce [_2] ?',
	'Remove selected user(s) (r)' => 'Retirer le ou les utilisateurs sélectionnés (r)',
	'Remove this role' => 'Retirer ce rôle',
	'Trusted commenter' => 'Commentateur fiable',
	q{Are you sure you want to remove the selected user from this [_1]?} => q{Voulez-vous vraiment retirer l'utilisateur sélectionné de ce [_1] ?},

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Ajouté(e)',
	'Save changes' => 'Enregistrer les modifications',

## tmpl/cms/include/ping_table.tmpl
	'Edit this TrackBack' => 'Modifier ce TrackBack',
	'Publish selected [_1] (p)' => 'Publier le(s) [_1] sélectionné(s) (p)',
	'View the [_1] for this TrackBack' => 'Voir [_1] pour ce TrackBack',
	q{Go to the source entry of this TrackBack} => q{Aller à la note à l'origine de ce TrackBack},

## tmpl/cms/include/revision_table.tmpl
	'Note' => 'Note',
	'Saved By' => 'Enregistré par',
	'_REVISION_DATE_' => 'Date',
	q{*Deleted due to data breakage*} => q{*Supprimé en raison d'une rupture de données*},
	q{No revisions could be found.} => q{Aucune révision n'a été trouvée.},

## tmpl/cms/include/rpt_log_table.tmpl
	'Schwartz Message' => 'Message Schwartz',

## tmpl/cms/include/scope_selector.tmpl
	'(on [_1])' => '(sur [_1])',
	'Create Blog (on [_1])' => 'Créer un blog (sur [_1])',
	'Select another blog...' => 'Sélectionner un autre blog...',
	'Select another website...' => 'Sélectionner un autre site web...',
	q{User Dashboard} => q{Tableau de bord de l'utilisateur},

## tmpl/cms/include/template_table.tmpl
	'Cached' => 'Caché',
	'Create template module' => 'Créer un module de gabarit',
	'Dynamic' => 'Dynamique',
	'Linked Template' => 'Gabarit lié',
	'Manual' => 'Manuellement',
	'Publish selected templates (a)' => 'Publier les gabarits sélectionnés (a)',
	'SSI' => 'SSI',
	'Static' => 'Statique',
	'templates' => 'gabarits',
	'to publish' => 'pour publier',
	q{Archive Path} => q{Chemin d'archive},
	q{Create Archive Template:} => q{Créer un gabarit d'archives},
	q{Create index template} => q{Créer un gabarit d'index},
	q{Publish Queue} => q{Publication en mode file d'attente},

## tmpl/cms/include/theme_exporters/folder.tmpl
	'<mt:if name="is_blog">Blog URL<mt:else>Site URL</mt:if>' => '<mt:if name="is_blog">URL du blog<mt:else>URL du site</mt:if>',
	'Folder Name' => 'Nom du répertoire',

## tmpl/cms/include/theme_exporters/static_files.tmpl
	'In the specified directories, files of the following types will be included in the theme: [_1]. Other file types will be ignored.' => 'Dans les répertoires spécifiés, les fichiers des types suivant seront inclus dans le thème : [_1]. Les autres seront ignorés.',
	'List directories (one per line) in the Site Root directory which contain the static files to be included in the theme. Common directories might be: css, images, js, etc.' => 'Lister les répertoire (un par ligne) dans le répertoire racine du site contenant les fichiers statiques devant être inclus dans le thème. Les répertoires communs sont par exemple : css, images, js, etc.',
	'Specify directories' => 'Spécifier les répertoires',

## tmpl/cms/include/theme_exporters/templateset.tmpl
	'<span class="count">[_1]</span> [_2] are included' => '<span class="count">[_1]</span> [_2] sont inclus',
	'modules' => 'modules',
	'widget sets' => 'groupe de widgets',

## tmpl/cms/install.tmpl
	'Create Your Account' => 'Créez votre compte',
	'Enter your LDAP password.' => 'Saisissez votre mot de passe LDAP.',
	'Please create an administrator account for your system. When you are done, Movable Type will initialize your database.' => 'Veuillez créer un compte administrateur pour votre système. Lorsque cela sera fait, Movable Type  initialisera votre base de données.',
	'Select a password for your account.' => 'Sélectionnez un mot de passe pour votre compte.',
	'System Email' => 'Adresse e-mail système',
	'The initial account name is required.' => 'Le nom initial du compte est nécessaire.',
	'The name used when published.' => 'Le nom utilisé lors de la publication.',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'La version Perl installée sur votre serveur ([_1]) est antérieure à la version minimale nécessaire ([_2]).',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Pour poursuivre, vous devez vous authentifier correctement auprès de votre serveur LDAP.',
	'Use this as system email address' => 'Utiliser ceci comme adresse e-mail du système',
	'View MT-Check (x)' => 'Voir MT-Check (x)',
	'Welcome to Movable Type' => 'Bienvenue dans Movable Type',
	q{Do you want to proceed with the installation anyway?} => q{Souhaitez-vous tout de même poursuivre l'installation ?},
	q{The display name is required.} => q{Le nom d'affichage est requis.},
	q{The e-mail address is required.} => q{L'adresse e-mail est requise.},
	q{The name used by this user to login.} => q{Le nom utilisé par cet utilisateur pour s'enregistrer.},
	q{The user&rsquo;s email address.} => q{Adresse e-mail de l'utilisateur},
	q{The user&rsquo;s preferred language.} => q{Langue préférée de l'utilisateur.},
	q{While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].} => q{Même si Movable Type semble fonctionner normalement, l'application s'exécute <strong>dans un environnement non testé et non supporté</strong>.  Nous vous recommandons fortement d'installer une version de Perl supérieure ou égale à [_1].},
	q{Your LDAP username.} => q{Votre nom d'utilisateur LDAP.},

## tmpl/cms/list_category.tmpl
	'Add child [_1]' => 'Ajouter un enfant [_1]',
	'Alert' => 'Alerte',
	'Are you sure you want to remove [_1] [_2] with [_3] sub [_4]?' => 'Voulez-vous vraiment retirer [_1] [_2] avec [_3] sous [_4] ?',
	'Are you sure you want to remove [_1] [_2]?' => 'Voulez-vous vraiment retirer [_1] [_2] ?',
	'Basename is required.' => 'Le nom de base est requis.',
	'Change and move' => 'Changer et déplacer',
	'Duplicated basename on this level.' => 'Des noms de base dupliqués sont sur ce niveau.',
	'Duplicated label on this level.' => 'Des labels dupliqués sont sur ce niveau.',
	'Invalid Basename.' => 'Le nom de base est invalide.',
	'Label is required.' => 'Le label est requis',
	'Label is too long.' => 'Le label est trop long.',
	'Manage [_1]' => 'Gérer les [_1]',
	'Rename' => 'Renommer',
	'Top Level' => 'Niveau principal',
	'[_1] label' => 'Label de [_1]',
	q{[_1] '[_2]' already exists.} => q{[_1] '[_2]' existe déjà.},

## tmpl/cms/list_common.tmpl
	'100 rows' => '100 lignes',
	'200 rows' => '200 lignes',
	'25 rows' => '25 lignes',
	'50 rows' => '50 lignes',
	'<mt:var name="js_message">' => '<mt:var name="js_message">',
	'All [_1] items are selected' => 'Tous les [_1] éléments sont sélectionnés',
	'Built in Filters' => 'Filtres disponibles',
	'Column' => 'Colonnes',
	'Communication Error (HTTP status code: [_1]. Message: [_2])' => 'Erreur de communication (status HTTP : [_1]. Message : [_2])',
	'Filter Label' => 'Filtrer par label',
	'Filter:' => 'Filtre :',
	'My Filters' => 'Mes filtres',
	'Remove Filter' => 'Supprimer le filtre',
	'Save As Filter' => 'Enregistrer comme filtre',
	'Save As' => 'Enregistrer sous',
	'Save Filter' => 'Enregistrer le filtre',
	'Select Filter Item...' => 'Sélectionner un élément de filtre...',
	'Select Filter' => 'Sélectionner un filtre',
	'Select Filter...' => 'Sélectionner un filtre...',
	'Select all [_1] items' => 'Sélectionner tous les [_1] éléments',
	'Unknown Filter' => 'Filtre inconnu',
	'[_1] - Filter [_2]' => '[_1] - Filtre [_2]',
	'[_1] Filter Items have errors' => '[_1] éléments du filtre comportent des erreurs',
	'act upon' => 'agir sur',
	q{Are you sure you want to remove the filter '[_1]'?} => q{Voulez-vous vraiment retirer le filtre '[_1]' ?},
	q{Label "[_1]" is already in use.} => q{Le label "[_1]" est déjà en cours d'utilisation},
	q{Remove item} => q{Retirer l'élément},

## tmpl/cms/list_entry.tmpl
	'Entries Feed' => 'Flux des notes',
	'Pages Feed' => 'Flux des pages',
	'Quickfilters' => 'Filtres rapides',
	'Recent Users...' => 'Utilisateurs récents...',
	'Remove filter' => 'Supprimer le filtre',
	'Select A User:' => 'Sélectionner un utilisateur',
	'Show only entries where' => 'Afficher seulement les notes où',
	'Show only pages where' => 'Afficher seulement les pages où',
	'Showing only: [_1]' => 'Montrer seulement : [_1]',
	'The entry has been deleted from the database.' => 'Cette note a été supprimée de la base de données.',
	'The page has been deleted from the database.' => 'Cette page a été supprimée de la base de données.',
	'User Search...' => 'Recherche utilisateur...',
	'[_1] (Disabled)' => '[_1] (Désactivé)',
	'[_1] where [_2] is [_3]' => '[_1] où [_2] est [_3]',
	'asset' => 'élément',
	'change' => 'modifier',
	'is' => 'est',
	'published' => 'publié',
	'review' => 'vérification',
	'scheduled' => 'programmé',
	'spam' => 'spam',
	'status' => 'le statut',
	'tag (exact match)' => 'le tag (est exactement)',
	'tag (fuzzy match)' => 'le tag (ressemble à)',
	'unpublished' => 'non publié',

## tmpl/cms/list_template.tmpl
	'Manage Global Templates' => 'Gérer les gabarits globaux',
	'Manage [_1] Templates' => 'Gérer les gabarits [_1]',
	'Publishing Settings' => 'Paramètres de publication',
	'Selected template(s) has been copied.' => 'Le ou les gabarits sélectionnés ont été copiés.',
	'Show All Templates' => 'Afficher tous les gabarits',
	'You have successfully deleted the checked template(s).' => 'Le ou les gabarits sélectionnés ont été supprimés.',
	'You have successfully refreshed your templates.' => 'Vous avez réactualisé vos gabarits avec succès.',
	'Your templates have been published.' => 'Vos gabarits ont bien été publiés.',

## tmpl/cms/list_theme.tmpl
	'All Themes' => 'Tous les thèmes',
	'Author: ' => 'Auteur :',
	'Available Themes' => 'Thèmes disponibles',
	'Current Theme' => 'Thème actuel',
	'Errors' => 'Erreurs',
	'Failed' => 'Échec',
	'Find Themes' => 'Trouver des thèmes',
	'Portions of this theme cannot be applied to the website. [_1] elements will be skipped.' => 'Les portions de ce thème ne peuvent pas être appliqués au site web. [_1] éléments seront ignorés.',
	'Reapply' => 'Réappliquer',
	'Theme Errors' => 'Erreurs du thème',
	'Theme Information' => 'Informations sur le thème',
	'Theme Warnings' => 'Alertes du thème',
	'Theme [_1] has been applied (<a href="[_2]">[quant,_3,warning,warnings]</a>).' => 'Le thème [_1] a été appliqué (<a href="[_2]">[quant,_3,alerte,alertes]</a>)',
	'Theme [_1] has been applied.' => 'Le thème [_1] a été appliqué.',
	'Theme [_1] has been uninstalled.' => 'Le thème [_1] a été désinstallé.',
	'Themes in Use' => 'Thèmes utilisés',
	'This theme cannot be applied to the website due to [_1] errors' => 'Ce thème ne peut pas être appliqué à ce site web suite à [_1] erreurs',
	'Uninstall' => 'Désinstaller',
	'Warnings' => 'Alertes',
	'[_1] Themes' => 'Thèmes [_1]',
	'[quant,_1,warning,warnings]' => '[quant,_1,alerte,alertes]',
	'_THEME_DIRECTORY_URL' => 'https://plugins.movabletype.org/',
	q{No themes are installed.} => q{Aucun thème n'est installé.},

## tmpl/cms/list_widget.tmpl
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Nom du groupe de widgets&quot;$&gt;</strong>',
	'Create widget template' => 'Créer un gabarit de widget',
	'Delete selected Widget Sets (x)' => 'Effacer les groupes de widgets sélectionnés (x)',
	'Helpful Tips' => 'Astuces',
	'Manage Global Widgets' => 'Gérer les widgets globaux',
	'Manage [_1] Widgets' => 'Gérer les widgets [_1]',
	'To add a widget set to your templates, use the following syntax:' => 'Pour ajouter un groupe de widgets à vos gabarits, utilisez la syntaxe suivante :',
	'You have successfully deleted the selected widget set(s) from your blog.' => 'Vous avez supprimé de votre blog le ou les groupes de widgets sélectionnés.',
	'Your changes to the widget set have been saved.' => 'Les modifications apportées au groupe de widgets ont été enregistrées.',
	q{No widget sets could be found.} => q{Aucun groupe de widgets n'a été trouvé.},

## tmpl/cms/listing/asset_list_header.tmpl
	'You have successfully deleted the asset(s).' => 'Vous avez effacé le ou les éléments.',
	q{Cannot write to '[_1]'. Thumbnail of items may not be displayed.} => q{Impossible d'écrire sur '[_1]'. La vignette de ces éléments peut ne pas s'afficher.},

## tmpl/cms/listing/association_list_header.tmpl
	'You have successfully granted the given permission(s).' => 'Vous avez attribué avec succès la ou les autorisations sélectionnées.',
	'You have successfully revoked the given permission(s).' => 'Vous avez révoqué avec succès la ou les autorisations sélectionnées.',

## tmpl/cms/listing/author_list_header.tmpl
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => 'Certains des utilisateurs sélectionnés ([_1]) ne peuvent pas être ré-activés car ils ne sont pas dans le répertoire externe.',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'Vous avez supprimé avec succès le ou les utilisateurs dans le système.',
	'You have successfully disabled the selected user(s).' => 'Vous avez désactivé avec succès le ou les utilisateurs sélectionnés.',
	'You have successfully enabled the selected user(s).' => 'Vous avez activé avec succès le ou les utilisateurs sélectionnés.',
	'You have successfully unlocked the selected user(s).' => 'Vous avez déverrouiller avec succès le ou les utilisateurs sélectionnés.',
	q{Some ([_1]) of the selected user(s) could not be re-enabled because they had some invalid parameter(s). Please check the <a href='[_2]'>activity log</a> for more details.} => q{Certains ([_1]) des utilisateurs sélectionnés n'ont pu être réactivés à cause de paramètres invalides. Veuillez vérifier le <a href='[_2]'>journal d'activité</a> pour plus de détails.},
	q{The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Advanced.} => q{Le ou les utilisateurs effacés existent encore dans le répertoire externe. En conséquence ils pourront encore s'identifier dans Movable Type Advanced},
	q{You have successfully synchronized users' information with the external directory.} => q{Vous avez synchronisé avec succès les informations des utilisateurs avec le répertoire externe.},

## tmpl/cms/listing/banlist_list_header.tmpl
	'Invalid IP address.' => 'Adresse IP invalide.',
	'You have successfully deleted the selected IP addresses from the list.' => 'La ou les adresses IP sélectionnées ont été supprimées de la liste.',
	q{You have added [_1] to your list of banned IP addresses.} => q{L'adresse [_1] a été ajoutée à la liste des adresses IP bannies.},

## tmpl/cms/listing/blog_list_header.tmpl
	'You have successfully moved selected blogs to another website.' => 'Vous avez déplacé avec succès les blogs sélectionnés vers un autre site web.',
	q{Warning: You need to copy uploaded assets to new locations manually. You should consider maintaining copies of uploaded assets in their original locations to avoid broken links.} => q{Attention : vous devez copier les éléments envoyés vers le nouvel emplacement manuellement. Vous devriez maintenir des copies des éléments envoyés à leur emplacement original afin d'éviter tout risque de lien mort.},
	q{You have successfully deleted the blog from the website. The files still exist in the site path. Please delete files if not needed.} => q{Vous avez supprimé le blog du système de Movable Type. Les fichiers sont toujours présents dans le répertoire du blog. Vous pouvez les supprimer s'ils sont inutiles.},
	q{You have successfully deleted the website from the Movable Type system. The files still exist in the site path. Please delete files if not needed.} => q{Vous avez supprimé le site web du système de Movable Type. Les fichiers sont toujours présents dans le répertoire du site. Vous pouvez les supprimer s'ils sont inutiles.},

## tmpl/cms/listing/comment_list_header.tmpl
	'All comments reported as spam have been removed.' => 'Tous les commentaires notifiés comme spam ont été supprimés.',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be banned or trusted.' => 'Un ou plusieurs commentaires sélectionnés ont été écrits par un commentateur non authentifié. Ces auteurs de commentaire ne peuvent pas être bannis ou validés.',
	'The selected comment(s) has been approved.' => 'Le ou les commentaires sélectionnés ont été approuvés.',
	'The selected comment(s) has been deleted from the database.' => 'Le ou les commentaires sélectionnés ont été supprimés de la base de données.',
	'The selected comment(s) has been recovered from spam.' => 'Le ou les commentaires sélectionnés ont été récupérés du spam.',
	'The selected comment(s) has been reported as spam.' => 'Le ou les commentaires sélectionnés ont été notifiés comme spam.',
	'The selected comment(s) has been unapproved.' => 'Le ou les commentaires sélectionnés ont été approuvés.',
	q{No comments appear to be spam.} => q{Aucun commentaire n'est marqué comme spam.},

## tmpl/cms/listing/log_list_header.tmpl
	'All times are displayed in GMT.' => 'Toutes les heures sont affichées en GMT.',
	'All times are displayed in GMT[_1].' => 'Toutes les heures sont affichées en GMT[_1].',

## tmpl/cms/listing/notification_list_header.tmpl
	q{You have added [_1] to your address book.} => q{Vous avez ajouté [_1] à votre carnet d'adresses.},
	q{You have successfully deleted the selected contacts from your address book.} => q{Vous avez supprimé avec succès les contacts sélectionnés de votre carnet d'adresses.},

## tmpl/cms/listing/ping_list_header.tmpl
	'All TrackBacks reported as spam have been removed.' => 'Tous les TrackBacks notifiés comme spam ont été supprimés.',
	'No TrackBacks appeared to be spam.' => 'Aucun TrackBack ne semble être du spam.',
	'The selected TrackBack(s) has been approved.' => 'Le ou les TrackBacks sélectionnés ont été approuvés.',
	'The selected TrackBack(s) has been deleted from the database.' => 'Le ou les TrackBacks sélectionnés ont été supprimés de la base de données.',
	'The selected TrackBack(s) has been recovered from spam.' => 'Le ou les TrackBacks sélectionnés ont été récupérés du spam.',
	'The selected TrackBack(s) has been reported as spam.' => 'Le ou les TrackBacks sélectionnés ont été notifiés comme spam.',
	'The selected TrackBack(s) has been unapproved.' => 'Le ou les TrackBacks sélectionnés ont été désapprouvés.',

## tmpl/cms/listing/role_list_header.tmpl
	'You have successfully deleted the role(s).' => 'Vous avez supprimé avec succès le(s) rôle(s).',

## tmpl/cms/listing/tag_list_header.tmpl
	'Specify new name of the tag.' => 'Spécifier le nouveau nom du tag',
	'You have successfully deleted the selected tags.' => 'Vous avez effacé correctement les tags sélectionnés.',
	'Your tag changes and additions have been made.' => 'Votre changements et additions de tag ont été faits.',
	q{The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]' across all blogs?} => q{Le tag '[_2]' existe déjà. Voulez-vous vraiment fusionner '[_1]' et '[_2]' sur tous les blogs ?},

## tmpl/cms/login.tmpl
	'Sign In (s)' => 'Connexion (s)',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Votre session Movable Type est terminée. Si vous souhaitez vous identifier à nouveau, vous pouvez le faire ci-dessous.',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Votre session Movable Type est terminée. Merci de vous identifier à nouveau pour continuer cette action.',
	'Your Movable Type session has ended.' => 'Votre session Movable Type est terminée.',

## tmpl/cms/pinging.tmpl
	'Pinging sites...' => 'Envoi de ping(s)...',

## tmpl/cms/popup/pinged_urls.tmpl
	'Failed Trackbacks' => 'TrackBacks échoués',
	'Successful Trackbacks' => 'TrackBacks réussis',
	'To retry, include these TrackBacks in the Outbound TrackBack URLs list for your entry.' => 'Pour ré-essayer, incluez ces TrackBacks dans la liste des URLs de TrackBacks sortants pour cette note.',

## tmpl/cms/popup/rebuild_confirm.tmpl
	'All Files' => 'Tous les fichiers',
	'Only Indexes' => 'Uniquement les index',
	'Only [_1] Archives' => 'Uniquement les archives [_1]',
	'Publish <em>[_1]</em>' => 'Publier <em>[_1]</em>',
	'Publish [_1]' => 'Publier [_1]',
	'_REBUILD_PUBLISH' => 'Publier',
	q{Index Template: [_1]} => q{Gabarit d'index : [_1]},

## tmpl/cms/popup/rebuilt.tmpl
	'Publish Again (s)' => 'Publier à nouveau (s)',
	'Publish Again' => 'Publier à nouveau',
	'Publish time: [_1].' => 'Temps de publication : [_1].',
	'The files for [_1] have been published.' => 'Les fichiers pour [_1] ont été publiés.',
	'View this page.' => 'Voir cette page.',
	'View your site.' => 'Voir votre site.',
	'Your [_1] archives have been published.' => 'Vos archives [_1] ont été publiées.',
	'Your [_1] templates have been published.' => 'Vos gabarits [_1] ont été publiés.',

## tmpl/cms/preview_entry.tmpl
	'Preview [_1] Content' => 'Prévisualiser le contenu [_1]',
	'Re-Edit this entry (e)' => 'Ré-éditer cette note (e)',
	'Re-Edit this entry' => 'Ré-éditer cette note',
	'Re-Edit this page (e)' => 'Ré-éditer cette page (e)',
	'Re-Edit this page' => 'Ré-éditer cette page',
	'Save this entry (s)' => 'Sauvegarder cette note (s)',
	'Save this entry' => 'Sauvegarder cette note',
	'Save this page (s)' => 'Sauvegarder cette page (s)',
	'Save this page' => 'Sauvegarder cette page',
	q{Return to the compose screen (e)} => q{Retourner sur l'éditeur (e)},
	q{Return to the compose screen} => q{Retourner sur l'éditeur},

## tmpl/cms/preview_strip.tmpl
	'Publish this entry (s)' => 'Publier cette note (s)',
	'Publish this entry' => 'Publier cette note',
	'Publish this page (s)' => 'Publier cette page (s)',
	'Publish this page' => 'Publier cette page',
	'You are previewing the entry entitled &ldquo;[_1]&rdquo;' => 'Vous prévisualisez la note &laquo; [_1] &raquo;',
	'You are previewing the page entitled &ldquo;[_1]&rdquo;' => 'Vous prévisualisez la page &laquo; [_1] &raquo;',

## tmpl/cms/preview_template_strip.tmpl
	'(Publish time: [_1] seconds)' => 'Temps de publication : [_1] secondes',
	'Re-Edit this template (e)' => 'Ré-éditer ce gabarit (e)',
	'Re-Edit this template' => 'Ré-éditer ce gabarit',
	'Save this template (s)' => 'Sauvegarder ce gabarit (s)',
	'Save this template' => 'Sauvegarder ce gabarit',
	'You are previewing the template named &ldquo;[_1]&rdquo;' => 'Vous prévisualisez le module nommé &laquo; [_1] &raquo;',
	q{There are no categories in this blog.  Limited preview of category archive templates is possible with a virtual category displayed.  Normal, non-preview output cannot be generated by this template unless at least one category is created.} => q{Il n'y a pas de catégories dans ce blog. Une prévisualisation limitée du gabarit d'achive d'une catégorie est possible avec une catégorie virtuelle. Une publication normale, hors prévisualisation, ne peut être faite avec ce gabarit que si au moins une catégorie est présente.},

## tmpl/cms/rebuilding.tmpl
	'Complete [_1]%' => 'Terminé à [_1]%',
	'Publishing <em>[_1]</em>...' => 'Publication <em>[_1]</em>...',
	'Publishing [_1] [_2]...' => 'Publication [_1] [_2]...',
	'Publishing [_1] archives...' => 'Publication des archives [_1]...',
	'Publishing [_1] dynamic links...' => 'Publication des liens dynamiques [_1]...',
	'Publishing [_1] templates...' => 'Publication des gabarits [_1]...',
	'Publishing [_1]...' => 'Publication [_1]...',
	'Publishing...' => 'Publication...',

## tmpl/cms/recover_lockout.tmpl
	'Recovered from lockout' => 'Déverrouiller',
	q{User '[_1]' has been unlocked.} => q{L'utilisateur '[_1]' a été déverrouillé.'},

## tmpl/cms/recover_password_result.tmpl
	'Recover Passwords' => 'Retrouver les mots de passe',
	'Return' => 'Retour',
	q{No users were selected to process.} => q{Aucun utilisateur sélectionné pour l'opération.},

## tmpl/cms/refresh_results.tmpl
	'No templates were selected to process.' => 'Aucun gabarit sélectionné pour cette action.',
	'Return to templates' => 'Retourner aux gabarits',
	'Template Refresh' => 'Réactualiser les gabarits',

## tmpl/cms/restore.tmpl
	'Backup File' => 'Fichier de sauvegarde',
	'Ignore schema version conflicts' => 'Ignorer les conflits de version de schéma',
	'Overwrite global templates.' => 'Écraser les gabarits globaux.',
	'Perl module XML::SAX and/or some of its dependencies are missing.  Movable Type cannot restore the system without these modules.' => 'Le module Perl XML::SAX et/ou ses dépendances sont introuvables. Movable Type ne peut pas restaurer le système sans ces modules.',
	'Restore (r)' => 'Restaurer (r)',
	q{Allow existing global templates to be overwritten by global templates in the backup file.} => q{Permettre aux gabarits globaux existants d'être réécrits par les gabarits dans le fichier de sauvegarde.},
	q{Check this and files backed up from newer versions can be restored to this system.  NOTE: Ignoring Schema Version can damage Movable Type permanently.} => q{Cochez ceci et les fichiers sauvegardés à partir d'une version plus récente pourront être restaurés dans ce système. NOTE : ignorer la version du schéma peut endommager Movable Type de manière permanente.},
	q{If your backup file is located on a remote computer, you can upload it here.  Otherwise, Movable Type will automatically look in the 'import' folder within your Movable Type directory.} => q{Si votre fichier de sauvegarde est localisé sur un ordinateur distant, vous pouvez le télécharger ici. Sinon, Movable Type regardera automatiquement dans le dossier 'import' dans votre répertoire Movable Type.},
	q{Restore from a Backup} => q{Restaurer à partir d'une sauvegarde},

## tmpl/cms/restore_start.tmpl
	'Restoring Movable Type' => 'Restauration de Movable Type',

## tmpl/cms/search_replace.tmpl
	'Case Sensitive' => 'Sensible à la casse',
	'Date Range' => 'Période (date)',
	'Limited Fields' => 'Champs limités',
	'Regex Match' => 'Expression rationnelle',
	'Replace Checked' => 'Remplacer dans la sélection',
	'Replace With' => 'Remplacer par',
	'Reported as Spam?' => 'Notifié comme spam ?',
	'Search Again' => 'Chercher encore',
	'Search For' => 'Rechercher',
	'Show all matches' => 'Afficher tous les résultats',
	'Submit search (s)' => 'Soumettre la recherche (s)',
	'Successfully replaced [quant,_1,record,records].' => 'Remplacements effectués avec succès dans [quant,_1,enregistrement,enregistrements].',
	'You must select one or more item to replace.' => 'Vous devez sélectionner un ou plusieurs objets à remplacer.',
	'[quant,_1,result,results] found' => '[quant,_1,résultat trouvé,résultats trouvés]',
	'_DATE_FROM' => 'Depuis le ',
	q{Showing first [_1] results.} => q{Afficher d'abord [_1] résultats.},
	q{_DATE_TO} => q{jusqu'au },

## tmpl/cms/setup_initial_website.tmpl
	'Create Your First Website' => 'Créez votre premier site web',
	'My First Website' => 'Mon premier site web',
	'Select the theme you wish to use for this new website.' => 'Sélectionnez le thème que vous voulez utiliser pour ce nouveau site web.',
	'The publishing path is required.' => 'Le chemin de publication est requis.',
	'The timezone is required.' => 'Le fuseau horaire est requis.',
	'The website name is required.' => 'Le nom du site web est requis.',
	q{Finish install (s)} => q{Finir l'installation},
	q{Finish install} => q{Finir l'installation},
	q{In order to properly publish your website, you must provide Movable Type with your website's URL and the filesystem path where its files should be published.} => q{Afin de publier correctement votre site web, vous devez fournir à Movable Type l'URL de votre site web ainsi que le chemin d'accès où le site devra être publié.},
	q{Support directory does not exists or not writable by the web server. Change the ownership or permissions on this directory} => q{Le répertoire de support n'existe pas ou n'est pas ouvert en écriture pour le serveur web. Modifiez les autorisations pour ce répertoire.},
	q{The 'Website Root' is the directory in your web server's filesystem where Movable Type will publish the files for your website. The web server must have write access to this directory.} => q{La racine du site est le répertoire du système de fichiers du serveur web dans lequel Movable Type va publier les fichiers de votre site. Le serveur web doit avoir les droits d'écriture dans ce répertoire.},
	q{The website URL is required.} => q{L'URL du site web est requise.},
	q{Your website URL is not valid.} => q{L'URL du site web n'est pas valide.},

## tmpl/cms/system_check.tmpl
	'Memcache Server is [_1].' => 'Le serveur Memcache est [_1].',
	'Memcache Status' => 'Statut Memcache',
	'Memcache is [_1].' => 'Memcache est [_1].',
	'Server Model' => 'Modèle du serveur',
	'Total Users' => 'Utilisateurs au total',
	'available' => 'disponible',
	'configured' => 'configuré',
	'disabled' => 'désactivé',
	'unavailable' => 'indisponible',
	q{Movable Type could not find the script named 'mt-check.cgi'. To resolve this issue, ensure that the mt-check.cgi script exists and that the CheckScript configuration parameter (if it is necessary) references it properly.} => q{Movable Type ne trouve pas le script nommé 'mt-check.cgi'. Pour résoudre ce problème, vérifiez que le script mt-check.cgi existe et que le paramètre de configuration CheckScript (s'il est nécessaire) le référence correctement.},

## tmpl/cms/theme_export_replace.tmpl
	'Overwrite' => 'Remplacer',
	q{Export theme folder already exists '[_1]'. You can overwrite a existing theme, or cancel to change the Basename?} => q{Le répertoire d'export '[_1]' existe déjà. Vous pouvez le remplacer ou entrer un autre nom de répertoire.},

## tmpl/cms/upgrade.tmpl
	'Begin Upgrade' => 'Commencer la mise à jour',
	'Congratulations, you have successfully upgraded to Movable Type [_1].' => 'Félicitations, vous avez mis à jour Movable Type à la version [_1].',
	'Do you want to proceed with the upgrade anyway?' => 'Voulez-vous quand même procéder à la mise à jour ?',
	'In addition, the following Movable Type components require upgrading or installation:' => 'De plus, les composants suivants de Movable Type nécessitent une mise à jour ou une installation :',
	'Return to Movable Type' => 'Retour vers Movable Type',
	'The following Movable Type components require upgrading or installation:' => 'Les composants suivants de Movable Type nécessitent une mise à jour ou une installation :',
	'Time to Upgrade!' => 'Il est temps de mettre à jour !',
	'Upgrade Check' => 'Vérification des mises à jour',
	'Your Movable Type installation is already up to date.' => 'Vous disposez de la dernière version de Movable Type.',
	q{A new version of Movable Type has been installed.  We'll need to complete a few tasks to update your database.} => q{Une nouvelle version de Movable Type a été installée. Nous avons besoin de faire quelques manipulations complémentaires pour mettre à jour votre base de données.},
	q{The Movable Type Upgrade Guide can be found <a href='[_1]' target='_blank'>here</a>.} => q{Le guide de mise à jour Movable Type peut être trouvé <a href='[_1]' target='_blank'>ici</a>.},

## tmpl/cms/upgrade_runner.tmpl
	'Error during upgrade:' => 'Erreur lors de la mise à jour :',
	'Initializing database...' => 'Initialisation de la base de données...',
	'Installation complete!' => 'Installation terminée !',
	'Return to Movable Type (s)' => 'Retour vers Movable Type (s)',
	'Upgrade complete!' => 'Mise à jour terminée !',
	'Upgrading database...' => 'Mise à jour de la base de données...',
	'Your database is already current.' => 'Votre base de données est déjà à jour.',
	q{Error during installation:} => q{Erreur lors de l'installation :},

## tmpl/cms/view_log.tmpl
	'Download Filtered Log (CSV)' => 'Télécharger le journal filtré (CSV)',
	'Filtered' => 'Filtrés',
	'Show log records where' => 'Afficher les données du journal où',
	'Showing all log records' => 'Affichage de toutes les données du journal',
	'Showing log records where' => 'Affichage des données du journal où',
	'classification' => 'classification',
	'level' => 'le statut',
	q{Filtered Activity Feed} => q{Flux d'activité filtré},
	q{System Activity Log} => q{Journal d'activité},
	q{The activity log has been reset.} => q{Le journal d'activité a été réinitialisé.},

## tmpl/cms/view_rpt_log.tmpl
	'Schwartz Error Log' => 'Journal des erreurs Schwartz',
	'Showing all Schwartz errors' => 'Affichage de toutes les erreurs Schwartz',

## tmpl/cms/widget/blog_stats.tmpl
	'April' => 'Avril',
	'Aug.' => 'Août',
	'Dec.' => 'Déc.',
	'Error retrieving recent entries.' => 'Erreur en récupérant les notes récentes.',
	'Feb.' => 'Fév.',
	'Jan.' => 'Jan.',
	'July.' => 'Juil.',
	'June' => 'Juin',
	'Loading recent entries...' => 'Chargement des notes récentes...',
	'March' => 'Mars',
	'May' => 'Mai',
	'Nov.' => 'Nov.',
	'Oct.' => 'Oct.',
	'Sept.' => 'Sept.',
	'[_1] [_2] - [_3] [_4]' => '[_1] [_2] - [_3] [_4]',
	q{You have <a href='[_3]'>[quant,_1,comment,comments] from [_2]</a>} => q{Vous avez <a href='[_3]'>[quant,_1,commentaire,commentaires] de [_2]</a>},
	q{You have <a href='[_3]'>[quant,_1,entry,entries] from [_2]</a>} => q{Vous avez <a href='[_3]'>[quant,_1,note,notes] de [_2]</a>},

## tmpl/cms/widget/blog_stats_comment.tmpl
	'Most Recent Comments' => 'Commentaires récents',
	'No comments available.' => 'Aucune commentaire disponible.',
	'View all comments' => 'Voir tous les commentaires',
	'[_1] [_2], [_3] on [_4]' => '[_1] [_2], [_3] sur [_4]',

## tmpl/cms/widget/blog_stats_entry.tmpl
	'Most Recent Entries' => 'Notes récentes',
	'View all entries' => 'Voir toutes les notes',
	q{No entries have been created in this blog. <a href="[_1]">Create a entry</a>} => q{Aucune note n'a été créée dans ce blog. <a href="[_1]">Créer une note</a>},

## tmpl/cms/widget/blog_stats_recent_entries.tmpl
	'[quant,_1,entry,entries] tagged &ldquo;[_2]&rdquo;' => '[quant,_1,note,notes] avec le tag &laquo; [_2] &raquo;',

## tmpl/cms/widget/custom_message.tmpl
	'Change this message.' => 'Changer ce message.',
	'Edit this message.' => 'Modifier ce message.',
	'Movable Type Community Forums' => 'Forums de la communauté Movable Type ',
	'Movable Type Technical Support' => 'Support technique Movable Type',
	'Welcome to [_1].' => 'Bienvenue sur [_1].',
	'You can manage your blog by selecting an option from the menu located to the left of this message.' => 'Vous pouvez gérer votre blog en sélectionnant une option dans le menu situé à gauche de ce message.',
	'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.com/movabletype/support',
	q{If you need assistance, try:} => q{Si vous avez besoin d'aide, vous pouvez consulter :},
	q{Movable Type User Manual} => q{Mode d'emploi de Movable Type},
	q{This is you} => q{C'est vous},

## tmpl/cms/widget/favorite_blogs.tmpl
	'Create a new' => 'Créer',
	'No blogs could be found.' => 'Aucun blog trouvé.',
	'No website could be found. [_1]' => 'Aucun site web trouvé. [_1]',
	'Your recent websites and blogs' => 'Vos sites web et blogs récents',

## tmpl/cms/widget/mt_news.tmpl
	'News' => 'Actualité',
	q{No Movable Type news available.} => q{Aucune actualité Movable Type n'est disponible.},

## tmpl/cms/widget/mt_shortcuts.tmpl
	'Blog Preferences' => 'Préférences du blog',
	'Handy Shortcuts' => 'Raccourcis pratiques',
	'Import Content' => 'Importer du contenu',

## tmpl/cms/widget/notification_dashboard.tmpl
	'Messages from the system' => 'Messages du système',

## tmpl/cms/widget/personal_stats.tmpl
	'<a href="[_1]">[quant,_2,comment,comments]</a>' => '<a href="[_1]">[quant,_2,commentaire,commentaires]</a>',
	'<a href="[_1]">[quant,_2,draft,drafts]</a>' => '<a href="[_1]">[quant,_2,brouillon,brouillons]</a>',
	'<a href="[_1]">[quant,_2,entry,entries]</a>' => '<a href="[_1]">[quant,_2,note,notes]</a>',
	'<a href="[_1]">[quant,_2,page,pages]</a>' => '<a href="[_1]">[quant,_2,page,pages]</a>',
	'Your <a href="[_1]">last entry</a> was [_2] in <a href="[_3]">[_4]</a>.' => 'Votre <a href="[_1]">dernière note</a> a été [_2] dans <a href="[_3]">[_4]</a>.',
	'Your last entry was [_1] in <a href="[_2]">[_3]</a>.' => 'Votre dernière note date du [_1] dans <a href="[_2]">[_3]</a>.',
	'[quant,_1,comment,comments]' => '[quant,_1,commentaire,commentaires]',
	'[quant,_1,draft,drafts]' => '[quant,_1,brouillon,brouillons]',
	'[quant,_1,entry,entries]' => '[quant,_1,note,notes]',
	'[quant,_1,page,pages]' => '[quant,_1,page,pages]',

## tmpl/cms/widget/recent_blogs.tmpl
	'No blogs could be found. [_1]' => 'Aucun blog trouvé. [_1]',

## tmpl/cms/widget/recent_websites.tmpl
	'[quant,_1,blog,blogs]' => '[quant,_1,blog,blogs]',

## tmpl/cms/widget/site_stats.tmpl
	'Statistics Settings' => 'Paramètres des statistiques',
	'Stats for [_1]' => 'Statistiques pour [_1]',

## tmpl/comment/auth_aim.tmpl
	'Sign in using your AIM or AOL screen name. Your screen name will be displayed publicly.' => 'Identifiez-vous en utilisant votre pseudonyme AIM ou AOL. Votre pseudonyme sera affiché publiquement.',
	'Your AIM or AOL Screen Name' => 'Votre pseudonyme AIM ou AOL.',

## tmpl/comment/auth_googleopenid.tmpl
	'Sign in to Movable Type with your[_1] Account[_2]' => 'Identifiez-vous dans Movable Type avec votre compte [_1] [_2]',
	'Sign in using your Gmail account' => 'Identifiez-vous en utilisant votre compte Gmail',

## tmpl/comment/auth_hatena.tmpl
	'Your Hatena ID' => 'Votre identifiant Hatena',

## tmpl/comment/auth_livejournal.tmpl
	'Learn more about LiveJournal.' => 'En savoir plus sur LiveJournal.',
	'Your LiveJournal Username' => 'Votre identifiant LiveJournal',

## tmpl/comment/auth_openid.tmpl
	'Learn more about OpenID.' => 'En savoir plus sur OpenID.',
	'OpenID URL' => 'URL OpenID',
	'http://www.openid.net/' => 'http://www.openid.net/',
	q{Sign in with one of your existing third party OpenID accounts.} => q{Identifiez-vous avec l'une de vos identités OpenID tierce partie.},

## tmpl/comment/auth_typepad.tmpl
	'Sign in or register with TypePad.' => 'Identifiez-vous ou enregistrez-vous avec TypePad.',
	q{TypePad is a free, open system providing you a central identity for posting comments on weblogs and logging into other websites. You can register for free.} => q{
	TypePad est un système gratuit et ouvert vous proposant une identité centralisée pour commenter sur les blogs et vous identifier sur d'autres sites. Vous pouvez vous enregistrer gratuitement.},

## tmpl/comment/auth_vox.tmpl
	'Learn more about Vox.' => 'En savoir plus sur Vox.',
	q{Your Vox Blog URL} => q{L'URL de votre blog Vox},

## tmpl/comment/auth_wordpress.tmpl
	'Sign in using your WordPress.com username.' => 'Identifiez-vous en utilisant votre pseudonyme WordPress.com',
	'Your Wordpress.com Username' => 'Votre pseudonyme WordPress.com',

## tmpl/comment/auth_yahoo.tmpl
	'Turn on OpenID for your Yahoo! account now' => 'Activer OpenID pour votre compte Yahoo! maintenant',

## tmpl/comment/auth_yahoojapan.tmpl
	'Turn on OpenID for your Yahoo! Japan account now' => 'Activer OpenID pour votre compte Yahoo! Japon maintenant',

## tmpl/comment/error.tmpl
	'Back (s)' => 'Retour (s)',

## tmpl/comment/login.tmpl
	'Not a member? <a href="[_1]">Sign Up</a>!' => 'Pas encore membre ? <a href="[_1]">Inscrivez-vous</a> !',
	'Sign in to comment' => 'Identifiez-vous pour commenter',

## tmpl/comment/profile.tmpl
	'Your Profile' => 'Votre profil',

## tmpl/comment/register.tmpl
	'Create an account' => 'Créer un compte',
	q{Register} => q{S'enregistrer},

## tmpl/comment/signup_thanks.tmpl
	'Thanks for signing up' => 'Merci de vous être enregistré(e)',
	q{Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].} => q{Avant de pouvoir déposer un commentaire vous devez terminer la prodécure d'enregistrement en confirmant votre compte.  Un e-mail a été envoyé à l'adresse suivante : [_1].},
	q{Return to the original entry.} => q{Retour à la note d'origine.},
	q{Return to the original page.} => q{Retour à la page d'origine.},

## tmpl/error.tmpl
	'CGI Path Configuration Required' => 'Configuration de chemin CGI requise',
	'Database Connection Error' => 'Erreur de connexion à la base de données',
	'Missing Configuration File' => 'Fichier de configuration manquant',
	'_ERROR_CGI_PATH' => 'Votre configuration de chemin CGI est invalide ou absente de vos fichiers de configuration Movable Type. Merci de consulter la base de connaissance',
	'_ERROR_CONFIG_FILE' => 'Votre fichier configuration Movable type est absent ou ne peut pas être lu correctement. Merci de consulter la base de connaissances',
	q{_ERROR_DATABASE_CONNECTION} => q{Les paramètres de votre base de données sont soit invalides, absents ou ne peuvent pas être lus correctement. Consultez la base de connaissances pour plus d'informations.},

## tmpl/feeds/error.tmpl
	q{Movable Type Activity Log} => q{Journal d'activité de Movable Type},

## tmpl/feeds/feed_comment.tmpl
	'By commenter URL' => 'Par URL du commentateur',
	'By commenter email' => 'Par e-mail du commentateur',
	'By commenter identity' => 'Par identité du commentateur',
	'By commenter name' => 'Par nom du commentateur',
	'From this blog' => 'De ce blog',
	'More like this' => 'Plus du même genre',
	'On this day' => 'Pendant cette journée',
	'On this entry' => 'Sur cette note',

## tmpl/feeds/feed_entry.tmpl
	'From this author' => 'De cet auteur',

## tmpl/feeds/feed_ping.tmpl
	'By source blog' => 'Par le blog source',
	'By source title' => 'Par le titre de la source',
	'Source blog' => 'Blog source',
	q{By source URL} => q{Par l'URL de la source},

## tmpl/feeds/login.tmpl
	q{This link is invalid. Please resubscribe to your activity feed.} => q{Ce lien n'est pas valide. Merci de souscrire à nouveau à votre flux d'activité.},

## tmpl/wizard/blog.tmpl
	'My First Blog' => 'Mon premier blog',
	'Publishing Path' => 'Chemin de publication',
	'Setup Your First Blog' => 'Configurer votre premier blog',
	q{In order to properly publish your blog, you must provide Movable Type with your blog's URL and the path on the filesystem where its files should be published.} => q{Pour pouvoir publier correctement votre blog, vous devez fournir à Movable Type l'URL du blog et le chemin sur le disque où les fichiers doivent être publiés.},
	q{Your 'Publishing Path' is the path on your web server's file system where Movable Type will publish all the files for your blog. Your web server must have write access to this directory.} => q{Votre 'Chemin de publication' est le chemin sur le disque de votre serveur web où Movable Type va publier tous les fichiers de votre blog. Votre serveur web doit avoir un accès en écriture à ce répertoire.},

## tmpl/wizard/cfg_dir.tmpl
	'TempDir is required.' => 'TempDir est requis.',
	'TempDir' => 'TempDir',
	'Temporary Directory Configuration' => 'Configuration du répertoire temporaire',
	'The physical path for temporary directory.' => 'Chemin physique pour le répertoire temporaire.',
	'You should configure you temporary directory settings.' => 'Vous devriez configurer les paramètres de votre répertoire temporaire.',
	'[_1] could not be found.' => '[_1] introuvable.',
	q{Your TempDir has been successfully configured. Click 'Continue' below to continue configuration.} => q{Votre Tempdir a été correctement configuré. Cliquez sur 'Continuer' ci-dessous pour continuer la configuration.},

## tmpl/wizard/complete.tmpl
	'Configuration File' => 'Fichier de configuration',
	'Retry' => 'Recommencer',
	'The mt-config.cgi file has been created manually.' => 'Le fichier mt-config.cgi a été créé manuellement.',
	q{Confirm that your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click 'Retry'.} => q{Vérifiez que votre répertoire [_1] d'accueil (celui contenant mt.cgi) est ouvert en écriture pour le serveur web et cliquez sur 'Recommencer'.},
	q{Congratulations! You've successfully configured [_1].} => q{Félicitations ! Vous avez configuré [_1] avec succès.},
	q{Please use the configuration text below to create a file named 'mt-config.cgi' in the root directory of [_1] (the same directory in which mt.cgi is found).} => q{Créez un fichier nommé dans le répertoire racine de [_1] (le même qui contient mt.cgi) ayant pour contenu le texte de configuration ci-dessous.},
	q{Show the mt-config.cgi file generated by the wizard} => q{Afficher le fichier mt-config.cgi généré par l'assistant},
	q{The [_1] configuration file cannot be located.} => q{Le fichier de configuration [_1] n'a pas pu être trouvé},
	q{The wizard was unable to save the [_1] configuration file.} => q{L'assistant n'a pas pu enregistrer le fichier de configuration [_1].},

## tmpl/wizard/configure.tmpl
	'Database Configuration' => 'Configuration de la base de données',
	'Database Type' => 'Type de base de données',
	'Once installed, <a href="javascript:void(0)" onclick="[_1]">click here to refresh this screen</a>.' => 'Une fois installé, <a href="javascript:void(0)" onclick="[_1]">cliquez ici pour réactualiser cette page</a>.',
	'Please enter the parameters necessary for connecting to your database.' => 'Merci de saisir les paramètres nécessaires pour se connecter à votre base de données.',
	'Read more: <a href="[_1]" target="_blank">Setting Up Your Database</a>' => 'Apprenez-en plus : <a href="[_1]" target="_blank">Configurez votre base de données</a>',
	'Show Advanced Configuration Options' => 'Montrer les options avancées de configuration',
	'Show Current Settings' => 'Montrer les paramètres actuels',
	'Test Connection' => 'Test de connexion',
	'You must set your Database Path.' => 'Vous devez définir le chemin de base de données.',
	'You must set your Database Server.' => 'Vous devez définir votre serveur de base de données.',
	'Your database configuration is complete.' => 'La configuration de votre base de données est terminée.',
	'http://www.movabletype.org/documentation/[_1]' => 'http://www.movabletype.org/documentation/[_1]',
	q{Is your preferred database not listed? View the <a href="[_1]" target="_blank">Movable Type System Check</a> see if additional modules are necessary.} => q{Votre base de données préférée n'est pas listée ? Regardez <a href="[_1]" target="_blank">Movable Type System Check</a> pour voir s'il y a des modules additionnels nécessaires pour permettre son utilisation.},
	q{You may proceed to the next step.} => q{Vous pouvez passer à l'étape suivante.},
	q{You must set your Username.} => q{Vous devez définir votre nom d'utilisateur.},

## tmpl/wizard/optional.tmpl
	'Address of your SMTP Server.' => 'Adresse de votre serveur SMTP.',
	'Do not use SSL' => 'Ne pas utiliser SSL',
	'Mail Configuration' => 'Configuration e-mail',
	'Outbound Mail Server (SMTP)' => 'Serveur e-mail sortant (SMTP)',
	'Password for your SMTP Server.' => 'Mot de passe pour le serveur SMTP',
	'Port number for Outbound Mail Server' => 'Port du serveur e-mail sortant',
	'Port number of your SMTP Server.' => 'Port du serveur SMTP',
	'SSL Connection' => 'Connexion SSL',
	'Send Test Email' => 'Envoyer un e-mail de test',
	'Send mail via:' => 'Envoyer les e-mails via :',
	'Sendmail Path' => 'Chemin sendmail',
	'Show current mail settings' => 'Montrer les paramètres e-mail actuels',
	'Skip' => 'Ignorer',
	'The physical file path for your Sendmail binary.' => 'Le chemin du fichier physique de votre exécutable sendmail.',
	'This field must be an integer.' => 'Ce champ doit être un entier',
	'Use SSL' => 'Utiliser SSL',
	'Use STARTTLS' => 'Utiliser STARTTLS',
	'You must set a password for the SMTP server.' => 'Vous devez fournir un mot de passe pour le serveur SMTP',
	'You must set the SMTP server port number.' => 'Vous devez spécifier le port du serveur SMTP',
	'You must set the Sendmail path.' => 'Vous devez sépcifier le chemin Sendmail',
	'Your mail configuration is complete.' => 'La configuration e-mail est terminée.',
	q{An error occurred while attempting to send mail: } => q{Une erreur s'est produite en essayant d'envoyer un e-mail : },
	q{Cannot use [_1].} => q{Impossible d'utiliser [_1].},
	q{Check your email to confirm receipt of a test email from Movable Type and then proceed to the next step.} => q{Vérifiez votre adresse e-mail pour confirmer la réception d'un e-mail de test de Movable Type et ensuite passez à l'étape suivante.},
	q{Mail address to which test email should be sent} => q{L'adresse e-mail à laquelle l'e-mail de test doit être envoyé},
	q{Periodically Movable Type will send email for password recovery, to inform authors of new comments, and other events. If not using Sendmail (default on unix servers), an SMTP Server must be specified.} => q{Movable Type va envoyer périodiquement des e-mails afin d'informer les utilisateurs des nouveaux commentaires et autres événements. Pour que ces e-mails puissent être envoyés correctement, veuillez spécifier la méthode que Movable Type va utiliser.},
	q{SMTP Auth Password} => q{Mot de passe pour l'authentification SMTP},
	q{SMTP Auth Username} => q{Nom d'utilisateur pour l'authentification SMTP},
	q{Use SMTP Auth} => q{Utiliser l'authentification SMTP},
	q{Username for your SMTP Server.} => q{Nom d'utilisateur pour le serveur SMTP},
	q{You must set a username for the SMTP server.} => q{Vous devez fournir un nom d'utilisateur pour le serveur SMTP},
	q{You must set the SMTP server address.} => q{Vous devez spécifier l'adresse du serveur SMTP},
	q{You must set the system email address.} => q{Vous devez définir l'adresse e-mail du système.},

## tmpl/wizard/packages.tmpl
	'All required Perl modules were found.' => 'Tous les modules Perl requis ont été trouvés.',
	'Minimal version requirement: [_1]' => 'Version minimale nécessaire : [_1]',
	'Missing Database Modules' => 'Modules de base de données manquants',
	'Missing Optional Modules' => 'Modules optionnels manquants',
	'Missing Required Modules' => 'Modules nécessaires manquants',
	'One or more Perl modules required by Movable Type could not be found.' => 'Un ou plusieurs modules Perl nécessaires pour Movable Type sont introuvables.',
	'Requirements Check' => 'Vérification des éléments nécessaires',
	'Some optional Perl modules could not be found. <a href="javascript:void(0)" onclick="[_1]">Display list of optional modules</a>' => 'Certains modules Perl optionnels sont introuvables. <a href="javascript:void(0)" onclick="[_1]">Afficher la liste des modules optionnels</a>',
	'http://www.movabletype.org/documentation/installation/perl-modules.html' => 'http://www.movabletype.org/documentation/installation/perl-modules.html',
	q{Learn more about installing Perl modules.} => q{Plus d'informations sur l'installation de modules Perl.},
	q{Some optional Perl modules could not be found. You may continue without installing these optional Perl modules. They may be installed at any time if they are needed. Click 'Retry' to test for the modules again.} => q{Certains modules Perl optionnels sont introuvables. Vous pouvez continuer sans installer ces modules Perl. Ils peuvent être installés n'importe quand si besoin. Cliquez sur 'Recommencer' pour tester à nouveau ces modules.},
	q{The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the 'Retry' button to re-test for these packages.} => q{Les modules Perl suivants sont nécessaires au bon fonctionnement de Movable Type. Dès que vous disposez de ces éléments, cliquez sur le bouton 'Recommencer' pour vérifier ces éléments..},
	q{The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your blog's data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the 'Retry' button.} => q{Les modules Perl suivants sont nécessaires pour réaliser une connexion à une base de données.  Movable Type nécessite une base de données pour stocker les données de votre blog.  Merci d'installer un des packages listés ici avant de continuer.  quand vous êtes prêt, cliquez sur le bouton 'Recommencer'.},
	q{You are ready to proceed with the installation of Movable Type.} => q{Vous êtes prêt à procéder à l'installation de Movable Type.},
	q{Your server has all of the required modules installed; you do not need to perform any additional module installations.} => q{Votre serveur possède tous les modules nécessaires, vous n'avez pas à procéder à des installations complémentaires de modules},

## tmpl/wizard/start.tmpl
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => 'Un fichier de configuration (mt-config.cgi) existe déjà, <a href="[_1]">identifiez-vous</a> dans Movable Type.',
	'Begin' => 'Commencer',
	'Configuration File Exists' => 'Le fichier de configuration existe',
	'Configure Static Web Path' => 'Configurer le chemin web statique',
	'Default language.' => 'Langue par défaut.',
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type est fourni avec un répertoire nommé [_1] contenant un nombre important de fichiers comme des images, fichiers javascript et feuilles de style.',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => 'Déplacez ou créez un lien symbolique du répertoire [_1] dans un endroit accessible depuis le web et spécifiez le chemin web statique dans le champ ci-dessous.',
	'Static file path' => 'Chemin fichier statique',
	'Static web path' => 'Chemin web statique',
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Ce répertoire a été renommé ou déplacé en dehors du répertoire Movable Type.',
	'This path must be in the form of [_1]' => 'Ce chemin doit être de la forme [_1]',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Vous allez maintenant, grâce à cet assistant de configuration, configurer les paramètres de base nécessaires au fonctionnement de Movable Type.',
	q{<strong>Error: '[_1]' could not be found.</strong>  Please move your static files to the directory first or correct the setting if it is incorrect.} => q{<strong>Erreur : '[_1]' ne peut pas être trouvé.</strong>  Veuillez d'abord déplacer vos fichiers statiques dans le répertoire ou en corriger le chemin s'il est incorrect.},
	q{Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.} => q{Pour utiliser Movable Type, vous devez activer le JavaScript sur votre navigateur. Merci de l'activer et de rafraîchir cette page pour commencer.},
	q{The [_1] directory is in the main Movable Type directory which this wizard script resides, but due to your web server's configuration, the [_1] directory is not accessible in this location and must be moved to a web-accessible location (e.g., your web document root directory).} => q{Le répertoire [_1] est le répertoire principal de Movable Type contenant les scripts de cet assistant, mais à cause de la configuration de votre serveur web, le répertoire [_1] n'est pas accessible à cette adresse et doit être déplacé vers un serveur web (par exemple, le répertoire racine des documents web).},
	q{This URL path can be in the form of [_1] or simply [_2]} => q{Ce chemin d'URL peut être de la forme [_1] ou simplement [_2]},
	q{To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page} => q{Pour créer un nouveau fichier de configuration avec l'assistant, supprimez le fichier de configuration actuel puis rechargez cette page},
);

1;
