# Plugin Gestionnaires de Widget pour Movable Type
# Auteur: Byrne Reese, Six Apart (http://www.sixapart.com)
# Propos� sous License Artistique
#
package WidgetManager::L10N::fr;

use strict;
use base 'WidgetManager::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
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
	'Current Category Monthly Archives' => 'Archives Mensuelles de la Catégorie Courante',

## plugins/WidgetManager/default_widgets/date_based_category_archives.mtml
	'Category Yearly Archives' => 'Archives Annuelles par Catégories',
	'Category Weekly Archives' => 'Archives Hebdomadaires par Catégories',
	'Category Daily Archives' => 'Archives Quotidiennes par Catégories',

## plugins/WidgetManager/default_widgets/widgets.cfg
	'About This Page' => 'À propos de cette page',
	'Current Author Monthly Archives' => 'Archives Mensuelles de l\'Auteur Courant',
	'Calendar' => 'Calendrier',
	'Creative Commons' => 'Creative Commons',
	'Home Page Widgets' => 'Widgets de Page d\'Accueil',
	'Monthly Archives Dropdown' => 'Liste déroulante des Archives Mensuelles',
	'Page Listing' => 'Liste des Pages', # Translate - New
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
1;

