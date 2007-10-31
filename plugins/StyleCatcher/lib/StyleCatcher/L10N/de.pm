package StyleCatcher::L10N::de;

use strict;
use base 'StyleCatcher::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
    'StyleCatcher must first be configured system-wide before it can be used.' => 'StyleCatcher muss erst global konfiguriert werden, bevor es benutzt werden kann:',
    'Configure plugin' => 'Plugin konfigurieren',
    'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Konnte den Ordner [_1] nicht anlegen. Stellen Sie sicher, daß der Webserver Schreibrechte auf dem \'themes\'-Ordner hat.',
    'Successfully applied new theme selection.' => 'Neue Themenauswahl erfolgreich angewendet.',
    '<p>You must define a global theme repository where themes can be stored locally.  If a particular blog has not been configured for it\'s own theme paths, it will use these settings directly. If a blog has it\'s own theme paths, then the theme will be copied to that location when applied to that weblog. The paths defined here must physically exist and be writable by the webserver.</p>' => '<p>StyleCatcher erfordert ein globales Theme Repository, in dem die Designvorlagen gespeichert werden. Wird bei einem Blog kein Theme-Pfad angegeben, wird auf den hier angegebenen Pfad zurückgegriffen. Andernfalls werden verwendete Designvorlagen in den entsprechenden Ordner kopiert. Die hier angegebenen Ordner müssen bereits vorhanden und mit Schreibrechten ausgestattet sein.</p>',
    'Select a Design using StyleCatcher' => 'Design per StyleCatcher aussuchen',
    'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.' => 'Mit StyleCatchter können Sie spielend leicht neue Designvorlagen für Ihre Blogs finden und mit wenigen Klicks direkt aus dem Internet installieren. Mehr dazu auf der <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type Styles</a>-Seite.',
    'Theme Root URL:' => 'Wurzeladresse für Themes:',
    'Theme Root Path:' => 'Wurzelverzeichnis für Themes:',
    'Style Library URL:' => 'Adresse der Style Library:',
    'View Site' => 'Ansehen',
    'Please select a weblog to apply this theme.' => 'Weblog, auf den das Theme angewendet werden soll, wählen',
    'Please click on a theme before attempting to apply a new design to your blog.' => 'Um ein Design anzuwenden, klicken Sie bitte zuerst auf ein Theme.',
    'Applying...' => 'Wende an...',
    'Choose this Design' => 'Dieses Design wählen',
    'Find Style' => 'Style finden',
    'Loading...' => 'Lade...',
    'StyleCatcher user script.' => 'StyleCatcher-User Script installieren',
    'Theme or Repository URL:' => 'Theme- oder Repository-Adresse:',
    'Find Styles' => 'Styles finden',
    'NOTE:' => 'HINWEIS:',
    'It will take a moment for themes to populate once you click \'Find Style\'.' => 'Es kann einige Momente dauern, bis nach Klick auf \'Styles finden\' Suchergebnisse erscheinen.',
    'Current theme for your weblog' => 'Aktuelles Theme Ihres Weblogs',
    'Current Theme' => 'Aktuelles Theme',
    'Current themes for your weblogs' => 'Aktuelle Themes Ihrer Weblogs',
    'Current Themes' => 'Aktuelle Themes',
    'Locally saved themes' => 'Lokal gespeicherte Themes',
    'Saved Themes' => 'Vorhandene Themes',
    'Single themes from the web' => 'Einzelne Themes aus dem Web',
    'More Themes' => 'Weitere Themes',
    'Templates' => 'Templates', # Translate - Previous (1)
    'Details' => 'Details', # Translate - Previous (1)
    'Show Details' => 'Details anzeigen',
    'Hide Details' => 'Details ausblenden',
    'Select a Weblog...' => 'Weblog wählen...',
    'Apply Selected Design' => 'Gewähltes Design anwenden',
    'You don\'t appear to have any weblogs with a \'styles-site.css\' template that you have rights to edit. Please check your weblog(s) for this template.' => 'Es scheint kein Blog, auf das Sie Zugriff haben, mit einem \'styles-site.css\'-Template zu geben. Bitte überprüfen Sie Ihre(n) Blog(s) auf dieses Template.',
);

1;

