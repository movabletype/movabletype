package MT::L10N::de;
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
    'Movable Type System Check' => 'Movable Type Systemüberprüfung',
    'This page provides you with information on your system\'s configuration and determines whether you have all of the components you need to run Movable Type.' => 'Auf dieser Seite finden Sie Informationen zu Ihrer Systemkonfiguration, damit festgestellt werden kann, ob Ihr Webserver über alle nötigen Komponenten zur Ausführung von Movable Type verfügt.',
    'System Information:' => 'Systeminformationen:',
    'Current working directory:' => 'Aktuelles Arbeitsverzeichnis:',
    'MT home directory:' => 'MT Home-Verzeichnis:',
    'Operating system:' => 'Betriebssystem:',
    'Perl version:' => 'Perl-Version:',
    'Perl include path:' => 'Perl-Include-Pfad:',
    'Web server:' => 'Webserver:',
    '(Probably) Running under cgiwrap or suexec' => '(Wahrscheinlich) ausgeführt unter cgiwrap oder suexec',
    'Checking for [_1] Modules:' => 'Überprüfung der [_1] Module:',
    'Some of the following modules are required by the various data storage options in Movable Type. In order run the system, your server needs to have either DB_File, or else DBI and at least one of the other modules installed.' => 'Movable Type benötigt, abhänging von der gewünschten Dantenbankkonfiguration, einige der folgenden Datenbankmodule. Ihr Server erfodert DB_File oder DBI gemeinsam mit einem weiternen spezifischen Modul.',
    'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'Entweder ist [_1] nicht auf Ihrem Webserver installiert, vielleicht ist die installierte Version zu alt oder [_1] benötigt ein weiteres Modul, welches nicht installiert ist.',
    'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => 'Entweder ist [_1] nicht auf Ihrem Webserver installiert oder [_1] benötigt ein weiteres Modul, welches nicht installiert ist.',
    'Please consult the installation instructions for help in installing [_1].' => 'Bitte beachten Sie die Installationsanleitung, um [_1] zu installieren.',
    'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN.' => 'Ihre DBD::mysql Version ist mit Movable Type nicht kompatibel. Bitte installieren Sie die aktuellen Version von CPAN.',
    'Your server has [_1] installed (version [_2]).' => 'Auf Ihrem Server ist [_1] installiert (Version [_2]).',
    'Movable Type System Check Successful' => 'Movable Type Systemüberprüfung erfolgreich',
    'You\'re ready to go!' => 'Ihr System ist jetzt bereit.',
    'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Alle erforderlichen Module sind auf Ihrem Server installiert. Sie müssen keine weiteren Modulinstallationen vornehmen. Fahren Sie mit den Installationsanweisungen fort.',

    ## ./search_templates/default.tmpl
    'Search Results' => 'Suchergebnisse',
    'Search this site:' => 'Site durchsuchen:',
    'Search' => 'Suchen',
    'Match case' => 'Groß-/Kleinschreibung',
    'Regex search' => 'Regex-Suche',
    'Search Results from' => 'Suchergebnisse von',
    'Posted in' => 'Geschrieben in',
    'on' => 'am',
    'Searched for' => 'Suche nach',
    'No pages were found containing' => 'Keine Einträge gefunden mit',
    'Instructions' => 'Anleitung',
    'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Diese Suche sucht nach allen Suchbegriffen, unabhängig von der Wortstellung. Wenn Sie nach einer bestimmten Wortfolge suchen, setzen Sie die Wörter in Anführungszeichen:',
    'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'Die Suche unterstützt AND, OR, und NOT für eine Boolean-Suche:',
    'personal OR publishing' => 'Schrank OR Schublade',
    'publishing NOT personal' => 'Regal NOT Schrank',

    ## ./search_templates/comments.tmpl
    'Search for new comments from:' => 'Suche nach Kommentaren:',
    'the beginning' => 'Gesamt',
    'one week back' => 'in der letzten Woche',
    'two weeks back' => 'in den letzten zwei Wochen',
    'one month back' => 'im letzten Monat',
    'two months back' => 'in den letzten zwei Monaten',
    'three months back' => 'in den letzten drei Monaten',
    'four months back' => 'in den letzten vier Monaten',
    'five months back' => 'in den letzten fünf Monaten',
    'six months back' => 'in den letzten sechs Monaten',
    'one year back' => 'im letzten Jahr',
    'Find new comments' => 'Neue Kommentare finden',
    'Posted in ' => 'Geschrieben zu ',
    'No results found' => 'Keine Suchergebnisse',
    'No new comments were found in the specified interval.' => 'Keine neuen Kommentare im Zeitraum.',

    ## ./default_templates/comment_error_template.tmpl
    'Comment Submission Error' => 'Kommentar-Fehler',
    'Your comment submission failed for the following reasons:' => 'Folgender Fehler ist beim Kommentieren aufgetreten:',

    ## ./default_templates/dynamic_pages_error_template.tmpl
    'Page Not Found' => 'Seite nicht gefunden',

    ## ./default_templates/trackback_listing_template.tmpl
    ': Discussion on [_1]' => ': Dikussion bei [_1]',
    'Trackbacks: [_1]' => 'Trackbacks: [_1]',
    'TrackBack' => 'TrackBack',
    'TrackBack URL for this entry:' => 'TrackBack-URL zu diesem Eintrag:',
    'Listed below are links to weblogs that reference' => 'Die folgenden Weblogs beziehen sich auf diesen Eintrag',
    'from' => 'von',
    'Read More' => 'Weiter lesen',
    'Tracked on [_1]' => 'Verlinkt am [_1]',
    'Search this blog:' => 'Dieses Weblog durchsuchen:',
    'Recent Posts' => 'Aktuelle Einträge',
    'Subscribe to this blog\'s feed' => 'Feed zu diesem Weblog abonnieren',
    'What is this?' => 'Was ist das?',
    'Creative Commons License' => 'Creative Commons Lizenz',
    'This weblog is licensed under a' => 'Zu diesem Weblog besteht folgende Lizenz:',

    ## ./default_templates/individual_entry_archive.tmpl
    'Main' => 'Hauptseite',
    'Posted by [_1] on [_2]' => 'Geschrieben von [_1] am [_2]',
    'Permalink' => 'Permalink',
    'Tracked on' => 'Verlinkt am',
    'Comments' => 'Kommentare',
    'Posted by:' => 'Verfasst von:',
    'Post a comment' => 'Kommentar schreiben',
    '(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(Wenn Du auf dieser Site noch nie kommentiert hast, wird Dein Kommentar eventuell erst zeitverzögert freigeschaltet werden. Danke für Deine Geduld.)',
    'Name:' => 'Name:',
    'Email Address:' => 'Email-Adresse:',
    'URL:' => 'URL:',
    'Remember personal info?' => 'Persönliche Angaben speichern?',
    'Comments:' => 'Kommentare:',
    '(you may use HTML tags for style)' => '(HTML erlaubt)',
    'Preview' => 'Vorschau',
    'Post' => 'Absenden',

    ## ./default_templates/main_index.tmpl
    'Continue reading' => 'Weiter lesen',
    'Posted by [_1] at [_2]' => 'Geschrieben von [_1] um [_2]',
    'TrackBacks' => 'TrackBacks',
    'Categories' => 'Kategorien',
    'Archives' => 'Archive',

    ## ./default_templates/dynamic_site_bootstrapper.tmpl

    ## ./default_templates/datebased_archive.tmpl
    'Posted by' => 'Verfasst von',
    'at' => 'um',

    ## ./default_templates/uploaded_image_popup_template.tmpl

    ## ./default_templates/category_archive.tmpl

    ## ./default_templates/master_archive_index.tmpl
    ': Archives' => ': Archive',

    ## ./default_templates/comment_listing_template.tmpl
    'Comment on' => 'Kommentar zu',

    ## ./default_templates/atom_index.tmpl

    ## ./default_templates/rsd.tmpl

    ## ./default_templates/stylesheet.tmpl

    ## ./default_templates/site_javascript.tmpl
    'Thanks for signing in,' => 'Hallo ', 
    '. Now you can comment. ' => '. Jetzt kannst Du kommentieren. ',
    'sign out' => 'abmelden',
    'You are not signed in. You need to be registered to comment on this site.' => 'Sie sind nicht angemeldet. Sie müssen sich registrieren, um hier zu kommentieren.',
    'Sign in' => 'Anmelden',
    'If you have a TypeKey identity, you can' => 'Wenn Sie TypeKey nutzen, können Sie sich',
    'sign in' => 'anmelden',
    'to use it here.' => ', um es hier zu verwenden.',

    ## ./default_templates/comment_preview_template.tmpl
    'Previewing your Comment' => 'Vorschau Ihres Kommentars',
    'Anonymous' => 'Anonym',
    'Cancel' => 'Abbrechen',

    ## ./default_templates/rss_20_index.tmpl

    ## ./default_templates/comment_pending_template.tmpl
    'Comment Pending' => 'Kommentar noch nicht freigegeben',
    'Thank you for commenting.' => 'Vielen Dank für den Kommentar.',
    'Your comment has been received and held for approval by the blog owner.' => 'Ihr Kommentar wurde gespeichert und muß nun vom Weblog-Betreiber freigegeben werden.',
    'Return to the original entry' => 'Zurück zum Eintrag',

    ## ./lib/MT/default-templates.pl

    ## ./plugins/nofollow/nofollow.pl

    ## ./plugins/spamlookup/spamlookup_words.pl

    ## ./plugins/spamlookup/spamlookup.pl

    ## ./plugins/spamlookup/spamlookup_urls.pl

    ## ./plugins/spamlookup/tmpl/url_config.tmpl
    'Less' => 'Schwächer',
    'Decrease' => 'Abschwächen',
    'Increase' => 'Verstärken',
    'More' => 'Stärker',

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
    'Missing Configuration File' => 'Fehlende Konfigurationsdatei',
    'Database Connection Error' => 'Verbindung mit Datenbank fehlgeschlagen',
    'CGI Path Configuration Required' => 'CGI-Pfad muß konfiguriert werden',
    'An error occurred' => 'Es ist ein Fehler aufgetreten',

    ## ./tmpl/cms/comment_table.tmpl
    'Status' => 'Status',
    'Comment' => 'Kommentar',
    'Commenter' => 'Kommentar-Autor',
    'Weblog' => 'Weblog',
    'Entry' => 'Eintrag',
    'Date' => 'Datum',
    'IP' => 'IP',
    'Only show published comments' => 'Nur veröffentlichte Kommentare anzeigen',
    'Published' => 'Veröffentlicht',
    'Only show pending comments' => 'Nur nicht veröffentlichte Kommentare anzeigen',
    'Pending' => 'Nicht veröffentlicht',
    'Edit this comment' => 'Kommentar bearbeiten',
    'Edit this commenter' => 'Kommentator bearbeiten',
    'Trusted' => 'vertraut',
    'Blocked' => 'Blockiert',
    'Authenticated' => 'Authentifiziert',
    'Search for comments by this commenter' => 'Nach Kommentaren von diesem Kommentator suchen',
    'Show all comments on this entry' => 'Alle Kommentare zu diesem Eintrag anzeigen', 
    'Search for all comments from this IP address' => 'Nach Kommentaren von dieser IP-Adresse suchen',

    ## ./tmpl/cms/notification_actions.tmpl
    'Delete' => 'Löschen',
    'notification address' => 'Adresse für Benachrichtigung',
    'notification addresses' => 'Adressen für Benachrichtigung',
    'Delete selected notification addresses (d)' => 'Löschen der gewählten Adressen (d)',

    ## ./tmpl/cms/edit_comment.tmpl
    'Edit Comment' => 'Kommentar bearbeiten',
    'Your changes have been saved.' => 'Die Änderungen wurden gespeichert.',
    'The comment has been approved.' => 'Der Kommentar wurde freigegeben.',
    'Previous' => 'Vorheriger',
    'List &amp; Edit Comments' => 'Kommentare auflisten &amp; bearbeiten',
    'Next' => 'Nchster',
    'View Entry' => 'Eintrag ansehen',
    'Pending Approval' => 'Freischaltung erwartet',
    'Junked Comment' => 'Junk-Kommentar',
    'Status:' => 'Status:',
    'Unpublished' => 'Nicht veröffentlicht',
    'Junk' => 'Junk',
    'View all comments with this status' => 'Alle Kommentare mit diesem Status ansehen',
    'Commenter:' => 'Kommentator:',
    '(Trusted)' => '(vertraut)',
    'Ban&nbsp;Commenter' => 'Kommentator&nbsp;sperren',
    'Untrust&nbsp;Commenter' => 'Kommentator&nbsp;nicht&nbsp;vertrauen',
    'Banned' => 'Gesperrt',
    '(Banned)' => '(gesperrt)',
    'Trust&nbsp;Commenter' => 'Kommentator&nbsp;vertrauen',
    'Unban&nbsp;Commenter' => 'Sperre&nbsp;aufheben', 
    'View all comments by this commenter' => 'Alle Kommentare von diesem Kommentator anzeigen',
    'Email:' => 'Email:',
    'None given' => 'leer',
    'Email' => 'Email',
    'View all comments with this email address' => 'Alle Kommentare mit dieser Email anzeigen',
    'Link' => 'Link',
    'View all comments with this URL' => 'Alle Kommentare mit dieser Email anzeigen',
    'Entry:' => 'Eintrag:',
    'Entry no longer exists' => 'Eintrag nicht mehr vorhanden',
    'No title' => 'Keine Überschrift',
    'View all comments on this entry' => 'Alle Kommentare zu diesem Eintrag anzeigen',
    'Date:' => 'Datum:',
    'View all comments posted on this day' => 'Alle Kommentare von diesem Tag anzeigen',
    'IP:' => 'IP:',
    'View all comments from this IP address' => 'Alle Kommentare von dieser IP-Adresse anzeigen',
    'Save Changes' => 'Änderungen speichern',
    'Save this comment (s)' => 'Kommentar(e) speichern',
    'Delete this comment (d)' => 'Kommentar löschen (d)',
    'Ban This IP' => 'Diese IP-Adresse sperren',
    'Final Feedback Rating' => 'Finales Feedback-Rating',
    'Test' => 'Test',
    'Score' => 'Score',
    'Results' => 'Ergebnis',
    'Plugin Actions' => 'Plugin-Aktionen',

    ## ./tmpl/cms/list_commenters.tmpl
    'Authenticated Commenters' => 'Authentifizierte Kommentatoren',
    'The selected commenter(s) has been given trusted status.' => 'Diese Kommentatoren haben den Status vertrauenswürdig.',
    'Trusted status has been removed from the selected commenter(s).' => 'Der Vertraut-Status wurde für die ausgewählten Kommentatoren aufgehoben.',
    'The selected commenter(s) have been blocked from commenting.' => 'Die ausgewählten Kommentatoren wurden für Kommentare gesperrt.',
    'The selected commenter(s) have been unbanned.' => 'Die Kommentarsperre wurde für die ausgewählten Kommentatoren aufgehoben.',
    'Go to Comment Listing' => 'Zur Kommentaranzeige wechseln',
    'Quickfilter:' => 'Quickfilter:',
    'Show unpublished comments.' => 'Zeige noch nicht veröffentlichte Kommentare.',
    'Reset' => 'Zurücksetzen',
    'Filter:' => 'Filter:',
    'Showing all commenters.' => 'Alle Kommentatoren anzeigen.',
    'Showing only commenters whose' => 'Zeigen Kommentatoren deren',
    'is' => 'ist',
    'Show' => 'Zeigen',
    'all' => 'alle',
    'only' => 'nur',
    'commenters.' => 'Kommentatoren.',
    'commenters where' => 'Kommentare die',
    'status' => 'Status',
    'commenter' => 'Kommentator',
    'trusted' => 'vertraut',
    'untrusted' => 'nicht vertraut',
    'banned' => 'gesperrt',
    'unauthenticated' => 'nicht authentifiziert',
    'authenticated' => 'authentifiziert',
    'Filter' => 'Filter',
    'No commenters could be found.' => 'Keine Kommentatoren gefunden.',

    ## ./tmpl/cms/bookmarklets.tmpl
    'QuickPost' => 'QuickPost',
    'Add QuickPost to Windows right-click menu' => 'QuickPost zum Kontextmenü von Windows hinzufügen',
    'Configure QuickPost' => 'QuickPost einrichten',
    'Include:' => 'Anzeigen:',
    'TrackBack Items' => 'TrackBack',
    'Category' => 'Kategorie',
    'Allow Comments' => 'Kommentare zulassen',
    'Allow TrackBacks' => 'TrackBacks zulassen',
    'Text Formatting' => 'Textformatierung',
    'Excerpt' => 'Zusammenfassung',
    'Extended Entry' => 'Erweiterter Eintrag',
    'Keywords' => 'Schlüsselwörter',
    'Basename' => 'Basename',
    'Create' => 'Neu',

    ## ./tmpl/cms/copyright.tmpl

    ## ./tmpl/cms/import.tmpl
    'Import / Export' => 'Import / Export',
    'System-wide' => 'Gesamtsystem',
    'Transfer weblog entries into Movable Type from other blogging tools or export your entries to create a backup or copy.' => 'Einträge aus einem anderen Weblog-System importieren oder für ein Backup exportieren.',
    'Import Entries' => 'Importieren von Einträgen',
    'Export Entries' => 'Einträge exportieren',
    'Import entries as me' => 'Einträge unter meinem Benutzernamen importieren',
    'Password (required if creating new authors):' => 'Passwort (erforderlich beim Erstellen neuer Autoren):',
    'You will be assigned the author of all imported entries.  If you wish the original authors to keep ownership, you must contact your MT system administrator to perform the import so that new authors can be created if necessary.' => 'Alle Import-Kommentare werden dem jetzt am System angemeldeteten Autoren zugeordnet.  Wenn andere / weitere Autoren benötigt werden, kontaktieren Sie bitte Ihren Movable Type-Systemadministrator.',
    'Default category for entries (optional):' => 'Standardkategorie für Einträge (optional):',
    'Select a category' => 'Kategorie auswählen',
    'Default post status for entries (optional):' => 'Standard-Eintragsstatus (optional):',
    'Select a post status' => 'Wählen Sie einen Eintragsstatus.',
    'Start title HTML (optional):' => 'Anfang HTML (optional):',
    'End title HTML (optional):' => 'Ende HTML (optional):',
    'Export Entries From [_1]' => 'Einträge exportieren von [_1]',
    'Export Entries to Tangent' => 'Einträge nach Tangent exportieren',

    ## ./tmpl/cms/commenter_actions.tmpl
    'Trust' => 'Vertrauen',
    'commenters' => 'Kommentatoren',
    'to act upon' => 'bearbeiten',
    'Trust commenter' => 'Kommentator vertrauen',
    'Untrust' => 'Nicht vertrauen',
    'Untrust commenter' => 'Kommentator nicht vertrauen',
    'Ban' => 'Sperren',
    'Ban commenter' => 'Kommentator sperren',
    'Unban' => 'Entsperren',
    'Unban commenter' => 'Sperre aufheben',
    'Trust selected commenters' => 'Ausgewählten Kommentatoren vertrauen',
    'Ban selected commenters' => 'Ausgewählte Kommentatoren sperren',

    ## ./tmpl/cms/list_author.tmpl
    'Authors' => 'Autoren',
    'You have successfully deleted the authors from the Movable Type system.' => 'Die Autoren wurden erfolgreich aus Movable Type entfernt.',
    'Create New Author' => 'Neuen Autor einrichten',
    'Username' => 'Benutzername',
    'Name' => 'Name',
    'URL' => 'URL',
    'Created By' => 'Erstellt von',
    'Entries' => 'Einträge',
    'Last Entry' => 'Letzter Eintrag',
    'System' => 'System',

    ## ./tmpl/cms/ping_actions.tmpl
    'pings' => 'Pings',
    'to publish' => 'zum Veröffentlichen',
    'Publish' => 'Veröffentlichen',
    'Publish selected TrackBacks (p)' => 'Ausgewählte TrackBacks veröffentlichen (p)',
    'Delete selected TrackBacks (d)' => 'Ausgewählte TrackBacks löschen (d)',
    'Junk selected TrackBacks (j)' => 'Ausgewählte TrackBacks sind Junk (j)',
    'Not Junk' => 'Kein Junk',
    'Recover selected TrackBacks (j)' => 'Ausgewählte TrackBacks wiederherstellen (j)',

    ## ./tmpl/cms/blog-left-nav.tmpl
    'Posting' => 'Einträge',
    'Create New Entry' => 'Neuen Eintrag schreiben',
    'New Entry' => 'Neuer Eintrag',
    'List Entries' => 'Einträge auflisten',
    'Upload File' => 'Dateiupload',
    'Community' => 'Community',
    'List Comments' => 'Kommentare auflisten',
    'List Commenters' => 'Kommentatoren auflisten',
    'Commenters' => 'Kommentar Autoren',
    'List TrackBacks' => 'TrackBacks auflisten',
    'Edit Notification List' => 'Mitteilungsliste bearbeiten',
    'Notifications' => 'Mitteilungen',
    'Configure' => 'Konfigurieren',
    'List &amp; Edit Templates' => 'Templates auflisten &amp; bearbeiten',
    'Templates' => 'Templates',
    'Edit Categories' => 'Kategorien bearbeiten',
    'Edit Weblog Configuration' => 'Weblog-Konfiguration bearbeiten',
    'Settings' => 'Einstellungen',
    'Utilities' => 'Hilfsmittel',
    'Search &amp; Replace' => 'Suchen &amp; Ersetzen',
    'View Activity Log' => 'Aktivitätsprotokoll anzeigen',
    'Activity Log' => 'Protokoll',
    'Import &amp; Export Entries' => 'Einträge importieren &amp; exportieren',
    'Rebuild Site' => 'Neu aufbauen',
    'View Site' => 'Ansehen',

    ## ./tmpl/cms/list_blog.tmpl
    'Movable Type News' => 'News von Movable Type',
    'System Shortcuts' => 'System-Shortcuts',
    'Weblogs' => 'Weblogs',
    'Concise listing of weblogs.' => 'Übersicht über alle Weblogs.',
    'Create, manage, set permissions.' => 'Berechtigungen verwalten.',
    'Plugins' => 'Plugins',
    'What\'s installed, access to more.' => 'Was ist installiert, Übersicht, etc.',
    'Multi-weblog entry listing.' => 'Multi-Weblog Eintragsliste.',
    'Multi-weblog comment listing.' => 'Multi-Weblog Kommentarliste.',
    'Multi-weblog TrackBack listing.' => 'Multi-Weblog TrackBackliste.',
    'System-wide configuration.' => 'Globale Systemkonfiguration.',
    'Find everything. Replace anything.' => 'Volles Suchen und Ersetzen.',
    'What\'s been happening.' => 'Was ist wann passiert.',
    'Status &amp; Info' => 'Status &amp; Info',
    'Server status and information.' => 'Serverstatus und Information.',
    'Set Up A QuickPost Bookmarklet' => 'QuickPost-Bookmarklet einrichten',
    'Enable one-click publishing.' => 'One-click-Publishing einrichten.',
    'My Weblogs' => 'Meine Weblogs',
    'Warning' => 'Warnung',
    'Important:' => 'Wichtig:',
    'Configure this weblog.' => 'Dieses Weblog konfigurieren.',
    'Create a new entry' => 'Eintrag schreiben',
    'on this weblog' => 'in diesem Weblog',
    'Show Display Options' => 'Anzeigeoptionen anpassen',
    'Display Options' => 'Anzeigeoptionen',
    'Sort By:' => 'Sortieren nach:',
    'Weblog Name' => 'Weblog-Name',
    'Creation Order' => 'Anlagedatum',
    'Last Updated' => 'Zuletzt aktualisiert',
    'Order:' => 'Reihenfolge:',
    'Ascending' => 'Aufsteigend',
    'Descending' => 'Absteigend',
    'View:' => 'Ansicht:',
    'Compact' => 'Kompakt',
    'Expanded' => 'Erweitert',
    'Save' => 'Speichern',

    ## ./tmpl/cms/reload_opener.tmpl

    ## ./tmpl/cms/edit_template.tmpl
    'Edit Template' => 'Templates bearbeiten',
    'Your template changes have been saved.' => 'Die Änderungen an dem Template wurden gespeichert.',
    'Rebuild this template' => 'Templates neu aufbauen',
    'Build Options' => 'Aufbauoptionen',
    'Enable dynamic building for this template' => 'Dynamisches Veröffentlichen für dieses Template aktivieren',
    'Rebuild this template automatically when rebuilding index templates' => 'Dieses Template sofort neu veröffentlichen, wenn Index-Templates neu aufgebaut werden',
    'Template Name' => 'Name des Templates',
    'Comment Listing Template' => 'Template für Kommentar-Liste',
    'Comment Preview Template' => 'Template für Kommentar-Vorschau',
    'Comment Error Template' => 'Template für Kommentar-Fehler',
    'Comment Pending Template' => 'Template für ausstehende Kommentare',
    'Commenter Registration Template' => 'Template für Registrierung von Kommentatoren',
    'TrackBack Listing Template' => 'Template für TrackBack-Liste',
    'Uploaded Image Popup Template' => 'Tempalte für hochgeladenes Bild-Popup',
    'Dynamic Pages Error Template' => 'Fehlertemplate für dynamische Seiten',
    'Output File' => 'Ausgabedatei',
    'Link this template to a file' => 'Dieses Template mit einer Datei verknüpfen',
    'Module Body' => 'Modulcode',
    'Template Body' => 'Templatecode',
    'Save this template (s)' => 'Template speichern (s)',
    'Save and Rebuild' => 'Speichern und neu veröffentlichen',
    'Save and rebuild this template (r)' => 'Template speichern und neu veröffentlichen (r)',

    ## ./tmpl/cms/junk_results.tmpl
    'Find Junk' => 'Junk finden',
    'Approved' => 'Freigeschaltet',
    'Registered Commenter' => 'Registrierter Kommentator',

    ## ./tmpl/cms/entry_actions.tmpl
    'Save these entries (s)' => 'Einträge speichern (s)',
    'Save this entry (s)' => 'Eintrag speichern (s)',
    'Preview this entry (p)' => 'Eintragsvorschau (p)',
    'entry' => 'Eintrag',
    'entries' => 'Einträge',
    'Delete this entry (d)' => 'Eintrag löschen (d)',
    'to rebuild' => 'zum erneuten Veröffentlichen',
    'Rebuild' => 'Neu aufbauen',
    'Rebuild selected entries (r)' => 'Einträge neu veröffentlichen (r)',
    'Delete selected entries (d)' => 'Einträge löschen (d)',

    ## ./tmpl/cms/edit_blog.tmpl
    'You must set your Local Site Path.' => 'Sie müssen den Pfad auf Ihr lokales Verzeichnis festlegen.',
    'You must set your Site URL.' => 'Sie müssen Ihre Webadresse (URL) festlegen.',
    'You did not select a timezone.' => 'Sie haben keine Zeitzone ausgewählt.',
    'New Weblog Settings' => 'Einstellungen für neues Weblog',
    'From this screen you can specify the basic information needed to create a weblog.  Once you click the save button, your weblog will be created and you can continue to customize its settings and templates, or just simply start posting.' => 'In diesem Menü legen Sie die Grundkonfiguration für ein neues Weblog fest. Sobald Sie die Einstellungen speichern, wird das Weblog angelegt. Sie können dann weitere Einstellungen vornehmen oder aber direkt einen Eintrag schreiben und veröffentlichen.',
    'Your weblog configuration has been saved.' => 'Ihre Weblog-Konfiguration wurde gespeichert.',
    'Weblog Name:' => 'Weblog-Name:',
    'Name your weblog. The weblog name can be changed at any time.' => 'Name Ihres Weblog. Der Weblog-Name kann jederzeit geändert werden.',
    'Site URL:' => 'Site-URL:',
    'Enter the URL of your public website. Do not include a filename (i.e. exclude index.html).' => 'Geben Sie die URL Ihrer öffentlichen Website ein. Sie sollte keinen Dateinamen enthalten (z. B. "index.html").',
    'Example:' => 'Beispiel:',
    'Site root:' => 'Site-Root:',
    'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'Geben Sie den Pfad ein, unter dem Ihre Hauptindexdatei gespeichert wird. Bevorzugt wird ein absoluter Pfad (der mit \'/\' beginnt), Sie können aber auch einen Pfad verwenden, der relativ zum Movable Type-Verzeichnis ist.',
    'Timezone:' => 'Zeitzone:',
    'Time zone not selected' => 'Es wurde keine Zeitzone ausgewählt',
    'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (Neuseeland Sommerzeit)',
    'UTC+12 (International Date Line East)' => 'UTC+12 (Internationale Datumslinie Ost)',
    'UTC+11' => 'Utc+11',
    'UTC+10 (East Australian Time)' => 'UTC+10 (Ost-Australische Zeit)',
    'UTC+9.5 (Central Australian Time)' => 'UTC+9,5 (Zentral-Australische Zeit)',
    'UTC+9 (Japan Time)' => 'UTC+9 (Japanische Zeit)',
    'UTC+8 (China Coast Time)' => 'UTC+8 (Chinesische Küstenzeit)',
    'UTC+7 (West Australian Time)' => 'UTC+7 (West-Australische Zeit)',
    'UTC+6.5 (North Sumatra)' => 'UTC+6.5 (Nord Sumatra-Zeit)',
    'UTC+6 (Russian Federation Zone 5)' => 'UTC+6 (Russische Föderationszone 5)',
    'UTC+5.5 (Indian)' => 'UTC+5,5 (Indische Zeit)',
    'UTC+5 (Russian Federation Zone 4)' => 'UTC+5 (Russische Föderationszone 4)',
    'UTC+4 (Russian Federation Zone 3)' => 'UTC+4 (Russische Föderationszone 3)',
    'UTC+3.5 (Iran)' => 'UTC+3,5 (Iranische Zeit)',
    'UTC+3 (Baghdad Time/Moscow Time)' => 'UTC+3 (Bagdad-/Moskau-Zeit)',
    'UTC+2 (Eastern Europe Time)' => 'UTC+2 (Osteuropische Zeit)',
    'UTC+1 (Central European Time)' => 'UTC+1 (Mitteleuropäische Zeit)',
    'UTC+0 (Universal Time Coordinated)' => 'UTC+0 (Universal Time Coordinated)',
    'UTC-1 (West Africa Time)' => 'UTC-1 (Westafrikanische Zeit)',
    'UTC-2 (Azores Time)' => 'UTC-2 (Azoren-Zeit)',
    'UTC-3 (Atlantic Time)' => 'UTC-3 (Atlantische Zeit)',
    'UTC-3.5 (Newfoundland)' => 'UTC-3,5 (Neufundland-Zeit)',
    'UTC-4 (Atlantic Time)' => 'UTC-4 (Atlantische Zeit)',
    'UTC-5 (Eastern Time)' => 'UTC-5 (Ostamerikanische Zeit)',
    'UTC-6 (Central Time)' => 'UTC-6 (Zentralamerikanische Zeit)',
    'UTC-7 (Mountain Time)' => 'UTC-7 (Amerikanische Gebirgszeit)',
    'UTC-8 (Pacific Time)' => 'UTC-8 (Pazifische Zeit)',
    'UTC-9 (Alaskan Time)' => 'UTC-9 (Alaska-Zeit)',
    'UTC-10 (Aleutians-Hawaii Time)' => 'UTC-10 (Aleuten-Hawaii-Zeit)',
    'UTC-11 (Nome Time)' => 'UTC-11 (Alaska, Nome-Zeit)',
    'Select your timezone from the pulldown menu.' => 'Wählen Sie Ihre Zeitzone aus dem Pulldown-Menü.',

    ## ./tmpl/cms/author_actions.tmpl
    'author' => 'Autor',
    'authors' => 'Autoren',
    'Delete selected authors (d)' => 'Autoren löschen (d)',

    ## ./tmpl/cms/search_replace.tmpl
    'You must select one or more item to replace.' => 'Wählen Sie mindestens ein Element aus.',
    'Search Again' => 'Erneut suchen',
    'Search:' => 'Suchen:',
    'Replace:' => 'Ersetzen:',
    'Replace Checked' => 'Markierung ersetzen',
    'Case Sensitive' => 'Groß/Kleinschreibung',
    'Regex Match' => 'Regex Match',
    'Limited Fields' => 'Felder eingrenzen',
    'Date Range' => 'Zeitspanne',
    'Is Junk?' => 'Ist Junk?',
    'Search Fields:' => 'Felder durchsuchen:',
    'Title' => 'Überschrift',
    'Entry Body' => 'Eintragstext',
    'Comment Text' => 'Kommentartext',
    'E-mail Address' => 'Email-Addresse',
    'IP Address' => 'IP-Adresse',
    'Email Address' => 'E-Mail-Adresse',
    'Source URL' => 'Quellen-URL',
    'Blog Name' => 'Weblog-Name',
    'Text' => 'Text',
    'Output Filename' => 'Output-Dateiname',
    'Linked Filename' => 'Verlinkter Dateiname',
    'Log Message' => 'Protokollnachricht',
    'Date Range:' => 'Zeitspanne:',
    'From:' => 'Von:',
    'To:' => 'Bis:',
    'Replaced [_1] records successfully.' => '[_1] Wörter ersetzt.',
    'No entries were found that match the given criteria.' => 'Keine Einträge gefunden, auf die der Suchfilter zutrifft.',
    'No comments were found that match the given criteria.' => 'Keine Kommentare gefunden, auf die der Suchfilter zutrifft.',
    'No TrackBacks were found that match the given criteria.' => 'Keine Kommentare gefunden, auf die der Suchfilter zutrifft.',
    'No commenters were found that match the given criteria.' => 'Keine Kommentatoren gefunden, auf die der Suchfilter zutrifft.',
    'No templates were found that match the given criteria.' => 'Keine Templates gefunden, auf die der Suchfilter zutrifft.',
    'No log messages were found that match the given criteria.' => 'Keine Logeinträge gefunden, auf die der Suchfilter zutrifft.',
    'Showing first [_1] results.' => 'Zeige die ersten [_1] Ergebnisse.',
    'Show all matches' => 'Zeige alle Ergebnisse',
    '[_1] result(s) found.' => '[_1] Ergebnisse gefunden.',

    ## ./tmpl/cms/import_start.tmpl
    'Importing...' => 'Importieren...',
    'Importing entries into blog' => 'Importiere Einrtäge ins Weblog',
    'Importing entries as author \'[_1]\'' => 'Importiere als Autor \'[_1]\'',
    'Creating new authors for each author found in the blog' => 'Neue Autoren anlegen für jeden Autor, der gefunden wird',

    ## ./tmpl/cms/log_actions.tmpl
    'Reset Activity Log' => 'Aktivitätsprotokoll zurücksetzen',

    ## ./tmpl/cms/log_table.tmpl

    ## ./tmpl/cms/edit_ping.tmpl
    'Edit TrackBack' => 'TrackBack bearbeiten',
    'The TrackBack has been approved.' => 'TrackBack wurde freigeschaltet.',
    'List &amp; Edit TrackBacks' => 'TrackBacks anzeigen &amp; bearbeiten',
    'Junked TrackBack' => 'Junk-TrackBacks',
    'View all TrackBacks with this status' => 'Alle TrackBacks mit diesem Status ansehen',
    'Source Site:' => 'Quelle:',
    'Search for other TrackBacks from this site' => 'Weitere TrackBacks von dieser Site suchen',
    'Source Title:' => 'Titel:',
    'Search for other TrackBacks with this title' => 'Weitere TrackBacks mit dieser Überschrift suchen',
    'Search for other TrackBacks with this status' => 'Weitere TrackBacks mit diesem Status suchen',
    'Target Entry:' => 'Bei Eintrag:',
    'View all TrackBacks on this entry' => 'Alle TrackBacks bei diesem Eintrag anzeigen',
    'Target Category:' => 'Zielkategorie:',
    'Category no longer exists' => 'Kategorie wurde gelöscht',
    'View all TrackBacks on this category' => 'Alle TrackBacks in dieser Kategorie anzeigen',
    'View all TrackBacks posted on this day' => 'Allen TrackBacks von diesem Tag anzeigen',
    'View all TrackBacks from this IP address' => 'Alle TrackBacks von dieser IP-Adrese anzeigen',
    'Save this TrackBack (s)' => 'TrackBack speichern (s)',
    'Delete this TrackBack (d)' => 'TrackBack löschen (d)',

    ## ./tmpl/cms/cfg_entries.tmpl
    'New Entry Default Settings' => 'Standardeinstellung für neue Einträge',
    'This screen allows you to control default settings for new entries as well as your publicity and remote interface settings.' => 'Hier legen Sie die Einstellungen fest, die bei neuen Einträgen standardmässig übernommen werden. Zudem konfigurieren Sie die Einstellungen zur Öffentlichkeit und zum Remote Interface.',
    'General' => 'Allgemein',
    'New Entry Defaults' => 'Standardwerte',
    'Feedback' => 'Feedback',
    'Publishing' => 'Veröffentlichen',
    'IP Banning' => 'IP-Adressen sperren',
    'Your blog preferences have been saved.' => 'Ihre Blog-Einstellungen wurden gespeichert.',
    'Default Settings for New Entries' => 'Standardeinstellung für neue Einträge',
    'Post Status' => 'Eintragsstatus',
    'Specifies the default Post Status when creating a new entry.' => 'Gibt an, welcher Standard-Eintragsstatus beim Erstellen eines neuen Eintrags verwendet werden soll.',
    'Specifies the default Text Formatting option when creating a new entry.' => 'Gibt an, welche Textformatierungsoption standardmäßig beim Erstellen eines neuen Eintrags verwendet werden soll.',
    'Accept Comments' => 'Kommentare zulassen',
    'Specifies the default Accept Comments setting when creating a new entry.' => 'Legt fest, ob bei neuen Einträgen Kommentare standardmässig aktiv sind.',
    'Setting Ignored' => 'Einstellung ignoriert',
    'Note: This option is currently ignored since comments are disabled either weblog or system-wide.' => 'Hinweis: Diese Einstellung wird derzeit ignoriert, da Kommentare für das Weblog bzw. global deaktiviert wurden.',
    'Accept TrackBacks:' => 'TrackBacks zulassen',
    'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Legt fest, ob bei neuen Einträgen TrackBack standardmässig aktiv ist.',
    'Note: This option is currently ignored since TrackBacks are disabled either weblog or system-wide.' => 'Hinweis: Diese Einstellung wird derzeit ignoriert, da TrackBacks für das Weblog bzw. global deaktiviert wurden.',
    'Basename Length:' => 'Basename Länge:',
    'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => 'Setzt den Wert für den automatisch generierten Basename des Eintrags. Mögliche Länge: 15 bis 250.',
    'Publicity/Remote Interfaces' => 'Öffentlichkeit/Remote Interfaces',
    'Notify the following sites upon weblog updates:' => 'Die folgenden Dienste bei Updates benachrichtigen:',
    'Others:' => 'Andere:',
    '(Separate URLs with a carriage return.)' => '(URLs durch Zeilenumbruch trennen.)',
    'When this weblog is updated, Movable Type will automatically notify the selected sites.' => 'Wenn ein neuer Eintrag veröffentlicht wird, werden die folgenden Dienste automatisch benachritigt.',
    'Setting Notice' => 'Hinweis zu der Einstellung',
    'Note: The above option may be affected since outbound pings are constrained system-wide.' => 'Hinweis: Die Option ist eventuell betroffen, da Einstellungen zu Pings (outbound) für das Gesamtsystem konfiguriert werden.',
    'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Hinweis: Diese Option wird derzeit ignoriert, da Pings (outbound) für das Gesamtsystem derzeit ausgeschaltet sind.',
    'Recently Updated Key:' => '"Kürzlich aktualisiert"-Code:',
    'If you have received a recently updated key (by virtue of your purchase or donation), enter it here.' => 'Wenn Sie einen "Kürzlich aktualisiert"-Code erhalten haben (aufgrund Ihres Kaufs oder Ihrer Spende), geben Sie diesen hier ein.',
    'TrackBack Auto-Discovery' => 'TrackBack Auto-Discovery',
    'Enable External TrackBack Auto-Discovery' => 'TrackBack Auto-Discovery (external) aktivieren',
    'Note: The above option is currently ignored since outbound pings are disabled system-wide.' => 'Hinweis: Diese Option wird ignoriert, da Pings (outbound) für das Gesamtsystem derzeit ausgeschaltet sind.',
    'Enable Internal TrackBack Auto-Discovery' => 'TrackBack Auto-Discovery (internal) aktivieren',
    'If you turn on auto-discovery, when you write a new post, any external links will be extracted and the appropriate sites automatically sent TrackBacks.' => 'Wenn Sie diese Option aktivieren, werden Einträge auf Links untersucht und den jeweiligen Sites automatisch ein TrackBack gesendet.',
    'Save changes (s)' => 'Änderungen speichern',

    ## ./tmpl/cms/header-popup.tmpl
    'Movable Type Publishing Platform' => 'Movable Type Publishing Platform',

    ## ./tmpl/cms/template_actions.tmpl
    'template' => 'Template',
    'templates' => 'Templates',

    ## ./tmpl/cms/list_entry.tmpl
    'Open power-editing mode' => 'Power-Modus öffnen',
    'Your entry has been deleted from the database.' => 'Ihr Eintrag wurde aus der Datenbank gelöscht.',
    'Show unpublished entries.' => 'Nicht veröffentlichte Einträge anzeigen.',
    'Showing all entries.' => 'Alle Einträge anzeigen.',
    'Showing only entries where' => 'Nur Einträge anzeigen bei denen',
    'entries.' => 'Einträge.',
    'entries where' => 'Einträge bei denen',
    'category' => 'Kategorie',
    'published' => 'veröffentlicht',
    'unpublished' => 'nicht veröffentlicht',
    'scheduled' => 'geplant',
    'No entries could be found.' => 'Keine Einträge gefunden.',

    ## ./tmpl/cms/edit_categories.tmpl
    'Your category changes and additions have been made.' => 'Änderungen und Hinzufgungen von Kategorien wurden vorgenommen.',
    'You have successfully deleted the selected categories.' => 'Sie haben die ausgewählten Kategorien erfolgreich gelöscht.',
    'Create new top level category' => 'Neue Kategorie der obersten Ebene erstellen',
    'Actions' => 'Aktionen',
    'Create Category' => 'Kategorie erstellen',
    'Top Level' => 'Oberste Ebene',
    'Collapse' => 'Reduzieren',
    'Expand' => 'Erweitern',
    'Create Subcategory' => 'Unterkategorie erstellen',
    'Move Category' => 'Kategorie verschieben',
    'Move' => 'Move',
    '[quant,_1,entry,entries]' => '[quant,_1,Eintrag,Einträge]',
    '[quant,_1,TrackBack]' => '[quant,_1,TrackBack]',
    'Delete selected categories (d)' => 'Ausgewählte Kategorien löschen (d)',

    ## ./tmpl/cms/pending_commenter.tmpl

    ## ./tmpl/cms/footer.tmpl

    ## ./tmpl/cms/pinging.tmpl
    'Pinging sites...' => 'Pings zu Sites senden...',

    ## ./tmpl/cms/edit_commenter.tmpl
    'Commenter Details' => 'Details zu Kommentator',
    'The commenter has been trusted.' => 'Sie vertrauen diesem Kommentator.',
    'The commenter has been banned.' => 'Dieser Kommentator wurde gesperrt.',
    'Junk Comments' => 'Junk-Kommentare',
    'View all comments with this name' => 'Alle Kommentare mit diesem Namen anzeigen',
    'Identity:' => 'Identität:',
    'Withheld' => 'Underdrückt',
    'View all comments with this URL address' => 'Alle Kommentare mit dieser URL anzeigen',
    'View all commenters with this status' => 'Alle Kommentatoren mit diesem Status ansehen',

    ## ./tmpl/cms/notification_table.tmpl
    'Date Added' => 'Hinzugefügt am',

    ## ./tmpl/cms/edit_placements.tmpl
    'The secondary categories for this entry have been updated. You will need to SAVE the entry for these changes to be reflected on your public site.' => 'Die sekundären Kategorien für diesen Eintrag wurden aktualisiert. Sie müssen den Eintrag für diese Änderungen SPEICHERN, damit sie auf der öffentlichen Site wirksam werden.',
    'Categories in your weblog:' => 'Kategorien in Ihrem Weblog:',
    'Secondary categories:' => 'Sekundäre Kategorien:',
    'Close' => 'Schließen',

    ## ./tmpl/cms/entry_prefs.tmpl
    'Your entry screen preferences have been saved.' => 'Die Einstellungen für die Eintragseingabe wurden gespeichert.',
    'Field Configuration' => 'Feldkonfiguration',
    '(Help?)' => '(Hilfe?)',
    'Basic' => 'Einfach',
    'Advanced' => 'Erweitert',
    'Custom: show the following fields:' => 'Angepasst: folgende Felder anzeigen:',
    'Editable Authored On Date' => 'Änderbares Erstellungsdatum',
    'Outbound TrackBack URLs' => 'TrackBack-URLs',
    'Button Bar Position' => 'Position der Symbolleiste',
    'Top of the page' => 'Seitenanfang',
    'Bottom of the page' => 'Seitenende',
    'Top and bottom of the page' => 'Seitenanfang und Seitenende',

    ## ./tmpl/cms/pager.tmpl
    'Show:' => 'Zeigen:',
    '[quant,_1,row]' => '[quant,_1,Reihe,Reihen]',
    'all rows' => 'Alle Reihen',
    'Another amount...' => 'Andere Anzahl...',
    'Actions:' => 'Aktionen:',
    'Below' => 'Unter',
    'Above' => 'Über',
    'Both' => 'Beides',
    'Date Display:' => 'Datumanzeige:',
    'Relative' => 'Relativ',
    'Full' => 'Voll',
    'Newer' => 'Neuer',
    'Showing:' => 'Anzeige:',
    'of' => 'von',
    'Older' => 'Älter',

    ## ./tmpl/cms/commenter_table.tmpl
    'Identity' => 'ID',
    'Most Recent Comment' => 'Aktuellster Kommentar',
    'Only show trusted commenters' => 'Nur vertrauenswürdige Kommentatoren anzeigen',
    'Only show banned commenters' => 'Nur gesperrte Kommentatoren anzeigen',
    'Only show neutral commenters' => 'Nur neutrale Kommentatoren anzeigen',
    'View this commenter\'s profile' => 'Kommentatorprofil anzeigen',

    ## ./tmpl/cms/rebuild-stub.tmpl
    'To see the changes reflected on your public site, you should rebuild your site now.' => 'Damit die Änderungen im Weblog sichtbar werden, sollten Sie die Site jetzt neu veröffentlichen.',
    'Rebuild my site' => 'Site neu veröffentlichen',

    ## ./tmpl/cms/cfg_prefs.tmpl
    'General Settings' => 'Allgemeine Einstellungen',
    'This screen allows you to control general weblog settings, default weblog display settings, and third-party service settings.' => 'Hier können Sie allgemeine Weblog-Einstellungen vornehmen, Anzeigeoptionen bearbeiten und Dienste von Drittanbietern konfigurieren',
    'Weblog Settings' => 'Weblog-Einstellungen',
    'Description:' => 'Beschreibung:',
    'Enter a description for your weblog.' => 'Geben Sie eine Beschreibung Ihres Weblog ein.',
    'Default Weblog Display Settings' => 'Weblog-Standardeinstellungen',
    'Entries to Display:' => 'Anzeige der Einträge:',
    'Days' => 'Tage',
    'Select the number of days\' entries or the exact number of entries you would like displayed on your weblog.' => 'Die Anzahl der Einträge auf der Startseite bzw. Anzahl der angezeigten Tage.',
    'Entry Order:' => 'Eintragssortierung:',
    'Select whether you want your posts displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Wählen Sie aus, ob Ihre Einträge in auf- (ältester ganz oben) oder absteigender (neuester ganz oben) Reihenfolge angezeigt werden sollen.',
    'Comment Order:' => 'Kommentarsortierung:',
    'Select whether you want visitor comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Wählen Sie aus, ob Kommentare von Besuchern in auf- (ältester ganz oben) oder absteigender (neuester ganz oben) Reihenfolge angezeigt werden sollen.',
    'Excerpt Length:' => 'Auszug Länge:',
    'Enter the number of words that should appear in an auto-generated excerpt.' => 'Anzahl der Wörter im automatisch generierten Textauszug.',
    'Date Language:' => 'Datum Sprache:',
    'Czech' => 'Tschechisch',
    'Danish' => 'Dänisch',
    'Dutch' => 'Holländisch',
    'English' => 'Englisch',
    'Estonian' => 'Estnisch',
    'French' => 'Französisch',
    'German' => 'Deutsch',
    'Icelandic' => 'Isländisch',
    'Italian' => 'Italienisch',
    'Japanese' => 'Japanisch',
    'Norwegian' => 'Norwegisch',
    'Polish' => 'Polnisch',
    'Portuguese' => 'Portugiesisch',
    'Slovak' => 'Slowakisch',
    'Slovenian' => 'Slovenisch',
    'Spanish' => 'Spanisch',
    'Suomi' => 'Finnisch',
    'Swedish' => 'Schwedisch',
    'Select the language in which you would like dates on your blog displayed.' => 'Wählen Sie die Sprache für die Datumsanzeige auf dem Blog.',
    'Limit HTML Tags:' => 'HTML-Tags limitieren:',
    'Use defaults' => 'Standardwerte verwenden',
    '([_1])' => '([_1])',
    'Use my settings' => 'Eigene Einstellungen',
    'Specifies the list of HTML tags allowed by default when cleaning an HTML string (a comment, for example).' => 'Liste der HTML-Tags, die standardmäßig beim Bereinigen von HTML-Zeichenfolgen (z. B. Kommentar) erlaubt sind.',
    'Third-Party Services' => 'Dienste von anderen Anbietern',
    'Creative Commons License:' => 'Creative Commons Lizenz:',
    'Your weblog is currently licensed under:' => 'Ihr Weblog ist derzeit lizenziert unter:',
    'Change your license' => 'Lizenz ändern',
    'Remove this license' => 'Lizenz entfernen',
    'Your weblog does not have an explicit Creative Commons license.' => 'Ihr Weblog hat keine explizite Creative Commons-Lizenz.',
    'Create a license now' => 'Jetzt eine Lizenz erstellen',
    'Select a Creative Commons license for the posts on your blog (optional).' => 'Wählen einer Creative Commons Lizenz für Ihre Inhalte (optional).',
    'Be sure that you understand these licenses before applying them to your own work.' => 'Sie sollten die Lizenzen verstehen, bevor Sie sie auf Ihre Arbeit anwenden.',
    'Read more.' => 'Weitere Informationen.',
    'Google API Key:' => 'Google API-Key:',
    'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.' => 'Um eine der API-Funktionen von Google nutzen zu können, benötigen Sie einen API-Code von Google. Fügen Sie diesen hier ein.',

    ## ./tmpl/cms/rebuild_confirm.tmpl
    'Select the type of rebuild you would like to perform. (Click the Cancel button if you do not want to rebuild any files.)' => 'Wählen Sie die Art der erneuten Veröffentlichung aus.',
    'Rebuild All Files' => 'Alle Dateien neu veröffentlichen',
    'Index Template: [_1]' => 'Index-Template: [_1]',
    'Rebuild Indexes Only' => 'Nur Index-Dateien neu veröffentlichen',
    'Rebuild [_1] Archives Only' => 'Nur [_1] Archive neu veröffentlichen',
    'Rebuild (r)' => 'Veröffentlichen (r)',

    ## ./tmpl/cms/ping_table.tmpl
    'From' => 'Von',
    'Target' => 'Auf',
    'Only show published TrackBacks' => 'Nur veröffentlichte TrackBacks anzeigen',
    'Only show pending TrackBacks' => 'Nur nicht veröffentlichte TrackBacks anzeigen',
    'Edit this TrackBack' => 'TrackBack bearbeiten',
    'Go to the source entry of this TrackBack' => 'Zum Eintrag wechseln, auf den sich das TrackBack bezieht',
    'View the [_1] for this TrackBack' => '[_1] zu dem TrackBack ansehen',

    ## ./tmpl/cms/edit_entry.tmpl
    'Add new category...' => 'Neue Kategorie hinzufügen...',
    'Edit Entry' => 'Eintrag bearbeiten',
    'Your entry has been saved. You can now make any changes to the entry itself, edit the authored-on date, edit comments, or send a notification.' => 'Ihr Eintrag wurde gespeichert. Sie können nun den Eintrag selbst beliebig ändern, das Erstellungsdatum bearbeiten, Kommentare verändern oder eine Benachrichtigung senden.',
    'One or more errors occurred when sending update pings or TrackBacks.' => 'Es sind ein oder mehrere Fehler beim Senden von TrackBacks aufgetreten.',
    'Your customization preferences have been saved, and are visible in the form below.' => 'Ihre Anpassungseinstellungen wurden gespeichert und werden im nachfolgenden Formular angezeigt.',
    'Your changes to the comment have been saved.' => 'Ihre am Kommentar vorgenommenen Änderungen wurden gespeichert.',
    'Your notification has been sent.' => 'Ihre Benachrichtigung wurde gesendet.',
    'You have successfully deleted the checked comment(s).' => 'Der bzw. die markierten Kommentare wurden erfolgreich gelöscht.',
    'You have successfully deleted the checked TrackBack(s).' => 'TrackBack(s) gelöscht.',
    'List &amp; Edit Entries' => 'Einträge auflisten &amp; bearbeiten',
    'Comments ([_1])' => 'Kommentare ([_1])',
    'TrackBacks ([_1])' => 'TrackBacks ([_1])',
    'Notification' => 'Benachrichtigung',
    'Scheduled' => 'Geplant',
    'Primary Category' => 'Primäre Kategorie',
    'Assign Multiple Categories' => 'Mehreren Kategorien zuweisen',
    'Bold' => 'Fett',
    'Italic' => 'Kursiv',
    'Underline' => 'Unterstrichen',
    'Insert Link' => 'Link einfügen',
    'Insert Email Link' => 'Email-Link einfügen',
    'Quote' => 'Zitat',
    'Authored On' => 'Erstellt am',
    'Unlock this entry\'s output filename for editing' => 'Dateiname zur Bearbeitung entsperren',
    'Warning: If you set the basename manually, it may conflict with another entry.' => 'Warnung: Wenn Sie den Basenamen manuell einstellen, ist es nicht auszuschließen, daß der gewählte Name bereits besteht.',
    'Warning: Changing this entry\'s basename may break inbound links.' => 'Warnung: Wenn Sie den Basename nachträglich ändern, können Links von Außen den Eintrag falsch verlinken.',
    'Accept TrackBacks' => 'TrackBacks zulassen',
    'View Previously Sent TrackBacks' => 'TrackBacks anzeigen',
    'Customize the display of this page.' => 'Anzeige der Seite anpassen.',
    'Manage Comments' => 'Kommentare verwalten',
    'Click on the author\'s name to edit the comment. To delete a comment, check the box to its right and then click the Delete button.' => 'Klicken Sie auf den Namen des Autors, um den Kommentar zu bearbeiten. Wenn Sie einen Kommentar löschen möchten, aktivieren Sie das Kontrollkästchen rechts daneben und klicken auf die Schaltfläche "löschen".',
    'No comments exist for this entry.' => 'Zu diesem Eintrag gibt es keine Kommentare.',
    'Manage TrackBacks' => 'TrackBacks verwalten',
    'Click on the TrackBack title to view the page. To delete a TrackBack, check the box to its right and then click the Delete button.' => 'Klicken Sie auf die Übersschrift des TrackBacks, um den TrackBack zu bearbeiten. Um den TrackBack zu löschen, markieren Sie den TrackBack und wählen Sie Löschen.',
    'No TrackBacks exist for this entry.' => 'Zu diesem Eintrag gibt es keine TrackBacks.',
    'Send a Notification' => 'Benachrichtigung senden',
    'You can send a notification message to your group of readers. Just enter the email message that you would like to insert below the weblog entry\'s link. You have the option of including the excerpt indicated above or the entry in its entirety.' => 'Sie können eine Benachrichtigungsmeldung an eine Gruppe von Lesern senden. Geben Sie einfach die E-Mail-Nachricht ein, die Sie unterhalb des Links für den Weblog-Eintrag einfügen möchten. Sie können den angezeigten Ausschnitt oder den gesamten Eintrag einfügen.',
    'Include excerpt' => 'Zusammenfassung verwenden',
    'Include entire entry body' => 'Gesamten Eintragstext verwenden',
    'Note: If you chose to send the weblog entry, all added HTML will be included in the email.' => 'Hinweis: Wenn Sie den gesamten Weblog-Eintrag senden möchten, ist sämtlicher hinzugefgter HTML-Code in der E-Mail enthalten.',
    'Send' => 'Senden',

    ## ./tmpl/cms/entry_table.tmpl
    'Author' => 'Autor',
    'Only show unpublished entries' => 'Nur nicht veröffentlichte Einträge anzeigen',
    'Only show published entries' => 'Nur veröffentlichte Einträge anzeigen',
    'Only show future entries' => 'Nur geplante Einträge anzeigen',
    'Future' => 'Zukünftiger',
    'None' => 'Kein(e)',

    ## ./tmpl/cms/pinged_urls.tmpl
    'Here is a list of the previous TrackBacks that were successfully sent:' => 'Liste aller bereits erfolgreich gesendeten TrackBacks:',

    ## ./tmpl/cms/view_log.tmpl
    'The Movable Type activity log contains a record of notable actions in the system.' => 'Das Movable Type Aktivitätsprotokoll zeichnet alle Systemvorgänge auf.',
    'All times are displayed in GMT' => 'Alle Zeiten sind in GMT',
    'All times are displayed in GMT.' => 'Alle Zeiten sind in GMT.',
    'Export in CSV format.' => 'Export im CSV-Format',
    'The activity log has been reset.' => 'Das Aktivitätsprotokoll wurde zurückgesetzt.',
    'No log entries could be found.' => 'Keine Einträge gefunden.',

    ## ./tmpl/cms/spam_confirm.tmpl
    'These domain names were found in the selected comments. Check the box at right to block comments and trackbacks containing that URL in the future.' => 'Diese Domainnamen wurden in den Kommentaren gefunden. Markieren Sie eine URL, um Kommentare und TrackBacks mit dieser URL in Zukunft zu sperren.',
    'Block' => 'Sperren',

    ## ./tmpl/cms/preview_entry.tmpl
    'Re-Edit this entry' => 'Eintrag neu bearbeiten',
    'Save this entry' => 'Eintrag speichern',

    ## ./tmpl/cms/delete_confirm.tmpl
    'Are you sure you want to permanently delete the [quant,_1,author] from the system?' => 'Sind Sie sicher, dass Sie den [quant,_1,Autor] dauerhaft aus dem System löschen möchten?',
    'Are you sure you want to delete the [quant,_1,comment]?' => 'Sind Sie sicher, dass Sie den [quant,_1,Kommentar] löschen möchten?',
    'Are you sure you want to delete the [quant,_1,TrackBack]?' => 'Sind Sie sicher, dass Sie [quant,_1,TrackBack] löschen möchten?',
    'Are you sure you want to delete the [quant,_1,entry,entries]?' => 'Sind Sie sicher, dass Sie diese [quant,_1,Eintrag,Einträge] löschen möchten?',
    'Are you sure you want to delete the [quant,_1,template]?' => 'Sind Sie sicher, dass Sie dieses [quant,_1,Template] löschen möchten?',
    'Are you sure you want to delete the [quant,_1,category,categories]? When you delete a category, all entries assigned to that category will be unassigned from that category.' => 'Sind Sie sicher, dass Sie diese [quant,_1,Kategorie,Kategorien] löschen möchten? Wenn Sie eine Kategorie löschen, werden alle dieser Kategorie zugewiesenen Einträge von der Kategorie getrennt.',
    'Are you sure you want to delete the [quant,_1,template] from the particular archive type(s)?' => 'Sind Sie sicher, dass Sie dieses [quant,_1,Template] aus dem/den bestimmten Archivierungstyp(en) löschen möchten?',
    'Are you sure you want to delete the [quant,_1,IP address,IP addresses] from your Banned IP List?' => 'Sind Sie sicher, dass Sie diese [quant,_1,IP-Adresse,IP-Adressen] aus Ihrer Liste mit gesperrten IP-Adressen löschen möchten?',
    'Are you sure you want to delete the [quant,_1,notification address,notification addresses]?' => 'Sind Sie sicher, dass Sie diese [quant,_1,Benachrichtigungsadresse,Benachrichtigungsadressen] löschen möchten?',
    'Are you sure you want to delete the [quant,_1,blocked item,blocked items]?' => 'Sind Sie sicher, dass Sie [quant,_1,blockiertes Element,blockierte Elemente] löschen möchten?',
    'Are you sure you want to delete the [quant,_1,weblog]? When you delete a weblog, all of the entries, comments, templates, notifications, and author permissions are deleted along with the weblog itself. Make sure that this is what you want, because this action is permanent.' => 'Sind Sie sicher, dass Sie das [quant,_1,Weblog] löschen möchten? Wenn Sie ein Weblog löschen, werden gleichzeitig alle Einträge, Kommentare, Templates, Benachrichtigungen und Autorenberechtigungen gelöscht. Überlegen Sie sich also gut, ob Sie das möchten, denn diese Aktion kann nicht rückgängig gemacht werden.',

    ## ./tmpl/cms/blog_actions.tmpl
    'weblog' => 'Weblog',
    'weblogs' => 'Weblogs',
    'Delete selected weblogs (d)' => 'Weblogs löschen (d)',

    ## ./tmpl/cms/edit_permissions.tmpl
    'Author Permissions' => 'Benutzerrechte',
    'Your changes to [_1]\'s permissions have been saved.' => 'Die Änderungen am Benutzer [_1] wurden gespeichert',
    '[_1] has been successfully added to [_2].' => '[_1] wurde erfolgreich zu [_2] hinzugefgt.',
    'Permissions' => 'Berechtigungen',
    'General Permissions' => 'Allgemeine Berechtigungen',
    'System Administrator' => 'Systemadministrator',
    'User can create weblogs' => 'Darf Weblogs anlegen',
    'User can view activity log' => 'Darf Protokoll einsehen',
    'Check All' => 'Alle markieren',
    'Uncheck All' => 'Alle deaktivieren',
    'Weblog:' => 'Weblog:',
    'Unheck All' => 'Markierungen aufheben',
    'Add user to an additional weblog:' => 'Benutzer zu weiterem Weblog hinzufügen:',
    'Select a weblog' => 'Weblog auswählen',
    'Add' => 'Hinzufügen',
    'Profile' => 'Profil',
    'Save permissions for this author (s)' => 'Änderungen speichern',

    ## ./tmpl/cms/cfg_feedback.tmpl
    'Feedback Settings' => 'Feedback-Einstellungen',
    'This screen allows you to control the feedback settings for this weblog, including comments and TrackBacks.' => 'Hier nehmen Sie alle Feedback-Einstellungen einschließlich der Kommentar- und TrackBackeinstellungen vor.',
    'Your feedback preferences have been saved.' => 'Ihre Feedback-Einstellungen wurden gespeichert.',
    'Rebuild indexes' => 'Index-Dateien neu veröffentlichen',
    'Note: Commenting is currently disabled at the system level.' => 'Hinweise: Die Kommentarfunktion ist derzeit für das Gesamtsystem ausgeschaltet.',
    'Comment authentication is not available because one of the needed modules, MIME::Base64 or LWP::UserAgent is not installed. Talk to your host about getting this module installed.' => 'Kommentarauthentifizierung ist derzeit nicht möglich. Ein erforderliches Modul, MIME::Base64 oder LWP::UserAgent ist nicht installiert. Ihr Administrator kann Ihnen vielleicht weiterhelfen.',
    'Accept comments from' => 'Kommentare akzeptieren von',
    'Anyone' => 'Jedermann',
    'Authenticated commenters only' => 'Nur authentifizierte Kommentatoren',
    'No one' => 'Niemandem',
    'Specify from whom Movable Type shall accept comments on this weblog.' => 'Legt fest, von wem Sie Kommentare zu Ihren Einträgen zulassen möchten.',
    'Authentication Status' => 'Authentifizierung',
    'Authentication Enabled' => 'Authentifitierung aktiviert',
    'Authentication is enabled.' => 'Authentifizierung ist aktiviert.',
    'Clear Authentication Token' => 'Authentifizierungs-Token zurücksetzen',
    'Authentication Token:' => 'Authentifizierungs-Token:',
    'Authentication Token Removed' => 'Authentifizierungs-Token entfernt',
    'Please click the Save Changes button below to disable authentication.' => 'Bitte speichern Sie die Einstellungen, um die Authentifizierung abzuschalten.',
    'Authentication Not Enabled' => 'Authentifizierung nicht aktiviert',
    'Note: You have selected to accept comments from authenticated commenters only but authentication is not enabled. In order to receive authenticated comments, you must enable authentication.' => 'Hinweis: Sie möchten Kommentare nur von authentifizierten Kommentatoren zulassen. Allerdings haben Sie die Authentifizierung nicht aktiviert.',
    'Authentication is not enabled.' => 'Authentifizierung nicht aktiviert.',
    'Setup Authentication' => 'Authentifizierungs-Setup',
    'Or, manually enter token:' => 'Oder: Token manuell eintragen:',
    'Authentication Token Inserted' => 'Authentifizierungs-Token eingefügt',
    'Please click the Save Changes button below to enable authentication.' => 'Bitte speichern Sie die Einstellungen, um die Authentifizierung zu aktivieren.',
    'Establish a link between your weblog and an authentication service. You may use TypeKey (a free service, available by default) or another compatible service.' => 'Einen Link zwischen Ihrem Weblog und einem Authentifizierungs-Dienst einrichten. Sie können TypeKey verwenden (Standard-Dienst von Six Apart, kostenlos) oder einen anderen Dienst.',
    'Require E-mail Address' => 'Email-Adresse Pflichtfeld',
    'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Wenn aktiv, dann müssen Kommentatoren eine gültige Email-Adresse angeben.',
    'Immediately publish comments from' => 'Kommentare sofort veröffentlichen von',
    'Trusted commenters only' => 'Nur vertrauten Kommentatoren',
    'Any authenticated commenters' => 'Allen authentifizierten Kommentatoren',
    'Specify what should happen to non-junk comments after submission.' => 'Legt fest, wie Kommentare, die nicht Junk sind, behandelt werden.',
    'Unpublished comments are held for moderation.' => 'Nicht veröffentlichte Kommentare werden zur Moderation bereitgestellt.',
    'E-mail Notification' => 'Email-Hinweis',
    'On' => 'Ein',
    'Only when attention is required' => 'Nur bei besonderen Vorfällen',
    'Off' => 'Aus',
    'Specify when Movable Type should notify you of new comments if at all.' => 'Legt fest, ob und wann Movable Type Emails bei neuen Kommentaren versendet.',
    'Allow HTML' => 'HTML zulassen',
    'If enabled, users will be able to enter a limited set of HTML in their comments. If not, all HTML will be stripped out.' => 'Wenn Sie HTML zulassen, dürfen Kommentatoren HTML verwenden. Wenn Sie HTML nicht zulassen, wird HTML in Kommentaren entfernt.',
    'Auto-Link URLs' => 'Automatisch Links für URLs erstellen',
    'If enabled, all non-linked URLs will be transformed into links to that URL.' => 'Legt fest, ob alle URLs in einen aktiven Link umgewandelt werden.',
    'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Legt fest, welche Textformatierungsoption standardmäßig für Kommentare verwendet werden soll.',
    'Note: TrackBacks are currently disabled at the system level.' => 'Hinweis: TrackBacks sind derzeit im Gesamtsystem deaktiviert.',
    'If enabled, TrackBacks will be accepted from any source.' => 'Legt fest, ob TrackBacks von allen Quellen zugelassen sind.',
    'Moderation' => 'Moderation',
    'Hold all TrackBacks for approval before they\'re published.' => 'Alle TrackBacks moderieren.',
    'Specify when Movable Type should notify you of new TrackBacks if at all.' => 'Legt fest, ob und wann Sie bei neuen TrackBacks benachrichtigt werden.',
    'Junk Score Threshold' => 'Junk-Score Grenzwert',
    'Less Aggressive' => 'weniger aggressiv',
    'More Aggressive' => 'aggressiver',
    'Comments and TrackBacks receive a junk score between -10 (complete junk) and +10 (not junk). Feedback with a score which is lower than the threshold shown above will be marked as junk.' => 'Kommentare und TrakBack erhalten einen Junk-Score zwischen -10 (totaler Junk) and +10 (kein Kunk). Feedback, dessen Score kleiner ist als Ihr Grenzwert, wird als Junk eingestuft.',
    'Auto-Delete Junk' => 'Auto-Löschen von Junk',
    'If enabled, junk feedback will be automatically erased after a number of days.' => 'Legt fest, ob und wann Junk automatisch gelöscht wird.',
    'Delete Junk After' => 'Junk löschen nach',
    'days' => 'Tagen',
    'When an item has been marked as junk for this many days, it is automatically deleted.' => 'Wenn ein Element als Junk eingestuft wurde, wird es nach dieser Anzahl von Tagen gelöscht.',

    ## ./tmpl/cms/list_notification.tmpl
    'Below is the list of people who wish to be notified when you post to your site. To delete an address, check the Delete box and press the Delete button.' => 'Nachfolgend sehen Sie die Liste der Benutzer, die benachrichtigt werden möchten, wenn Sie Einträge auf Ihrer Site posten. Aktivieren Sie das Kontrollkästchen "löschen", und klicken Sie dann auf die Schaltfläche "löschen", wenn Sie eine Adresse löschen möchten.',
    'You have [quant,_1,user,users,no users] in your notification list.' => 'Sie haben [quant,_1,Benutzer,Benutzer,keine Benutzer] in Ihrer Benachrichtigungsliste.',
    'You have added [_1] to your notification list.' => 'Sie haben [_1] zu Ihrer Benachrichtigungsliste hinzugefgt.',
    'You have successfully deleted the selected notifications from your notification list.' => 'Sie haben die ausgewählten Benachrichtigungen erfolgreich aus der Benachrichtigungsliste gelöscht.',
    'Create New Notification' => 'Neue Benachrichtigung einrichten',
    'URL (Optional):' => 'URL (optional):',
    'Add Recipient' => 'Empfänger hinzufügen',
    'No notifications could be found.' => 'Keine Benachrichtigung gefunden.',

    ## ./tmpl/cms/show_upload_html.tmpl
    'Copy and paste this HTML into your entry.' => 'Kopieren Sie den HTML-Code, und fügen Sie ihn in den Eintrag ein.',
    'Upload Another' => 'Weitere hochladen',

    ## ./tmpl/cms/template_table.tmpl
    'Dynamic' => 'Dynamisch',
    'Linked' => 'Verlinkt',
    'Built w/Indexes' => 'mit Index-Dateien',
    'Yes' => 'Ja',
    'No' => 'Nein',

    ## ./tmpl/cms/login.tmpl
    'Your Movable Type session has ended. If you wish to log in again, you can do so below.' => 'Ihre Movable Type-Sitzung ist abgelaufen. Sie können sich nachfolgend erneut anmelden.',
    'Your Movable Type session has ended. Please login again to continue this action.' => 'Ihre Movable Type-Session ist abgelaufen. Bitte melden Sie sich erneut an.',
    'Password' => 'Passwort',
    'Remember me?' => 'Benutzernamen speichern?',
    'Log In' => 'Anmelden',
    'Forgot your password?' => 'Passwort vergessen?',

    ## ./tmpl/cms/edit_category.tmpl
    'Use this page to edit the attributes of the category [_1]. You can set a description for your category to be used in your public pages, as well as configuring the TrackBack options for this category.' => 'Verwenden Sie diese Seite, um die Attribute der Kategorie [_1] zu bearbeiten. Sie können eine Beschreibung für die Kategorie festlegen, die auf den öffentlichen Seiten verwendet werden soll, und Sie können die TrackBack-Optionen für die Kategorie konfigurieren.',
    'Your category changes have been made.' => 'Die Kategorienderungen wurden vorgenommen.',
    'Category Label' => 'Kategorie-Label',
    'Category Description' => 'Beschreibung der Kategorie',
    'TrackBack Settings' => 'TrackBack-Einstellungen',
    'Outbound TrackBacks' => 'TrackBacks (outbound)',
    'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you post an entry in this category. (Separate URLs with a carriage return.)' => 'URL(s) der Websites, denen Sie ein TrackBack senden möchten, wenn Sie in dieser Kategorie einen Eintrag veröffentlichen. (Trennen Sie mehrere URLs durch einem Zeilenumbruch.)',
    'Inbound TrackBacks' => 'TrackBacks (inbound)',
    'Accept inbound TrackBacks?' => 'Akzeptiere inbound TrackBacks?',
    'View the inbound TrackBacks on this category.' => 'TrackBacks (inbound) zu dieser Kategorie anzeigen.',
    'Passphrase Protection (Optional)' => 'Passphrasen-Schutz (optional)',
    'TrackBack URL for this category' => 'TrackBack-URL für diese Kategorie',
    'This is the URL that others will use to send TrackBacks to your weblog. If you wish for anyone to send TrackBacks to your weblog when they have a post specific to this category, post this URL publicly. If you choose to only allow a select group of individuals to TrackBack, send this URL to them privately.' => 'An diese URL werden Dritte TrackBacks zu Ihrem Weblog senden. Wenn nur eine kleine Gruppen von Nutzern diese TrackBack-URL verwenden soll, veröffentlichen Sie diese URL bitte nicht.',
    'To include a list of incoming TrackBacks in your Main Index Template, check the documentation for template tags related to TrackBacks.' => 'Um eine Liste aller eingehenden (inbound) TrackBacks auf Ihrer Startseite anzuzeigen (Main Index Template), konsultieren Sie bitte die Template-Tag-Dokumentation für TrackBacks.',

    ## ./tmpl/cms/cc_return.tmpl

    ## ./tmpl/cms/bm_posted.tmpl
    'Your new entry has been saved to [_1]' => 'Ihr Eintrag wurde gespeichert unter [_1]',
    ', and it has been posted to your site' => ', und er wurde auf Ihrer Site gepostet.',
    'View your site' => 'Site anzeigen',
    'Edit this entry' => 'Eintrag bearbeiten',

    ## ./tmpl/cms/handshake_return.tmpl

    ## ./tmpl/cms/category_add.tmpl
    'Add A Category' => 'Kategorie hinzufügen',
    'To create a new category, enter a title in the field below, select a parent category, and click the Add button.' => 'Um eine neue Kategorie zu erstellen, geben Sie einen Titel im untenstehenden Feld ein, wählen Sie eine bergeordnete Kategorie und klicken Sie auf die Schaltfläche "Hinzufügen".',
    'Category Title:' => 'Kategorietitel:',
    'Parent Category:' => 'übergeordnete Kategorie:',

    ## ./tmpl/cms/list_banlist.tmpl
    'IP Banning Settings' => 'IP-Sperrung Einstellungen',
    'This screen allows you to ban comments and TrackBacks from specific IP addresses.' => 'Hier legen Sie fest, welche IP-Adressen für Kommentare und TrackBacks gesperrt werden sollen.',
    'You have banned [quant,_1,address,addresses].' => 'Sie haben [quant,_1,Adresse,Adressen] gesperrt.',
    'You have added [_1] to your list of banned IP addresses.' => 'Sie haben [_1] zur Liste mit gesperrten IP-Adressen hinzugefgt.',
    'You have successfully deleted the selected IP addresses from the list.' => 'Sie haben die ausgewählten IP-Adressen erfolgreich aus der Liste entfernt.',
    'Ban New IP Address' => 'Neue IP-Adresse sperren',
    'IP Address:' => 'IP-Adresse:',
    'Ban IP Address' => 'IP-Adresse sperren',
    'Date Banned' => 'gesperrt am',

    ## ./tmpl/cms/admin.tmpl
    'System Stats' => 'System-Stats',
    'Active Authors' => 'Aktive Autoren',
    'Version' => 'Version',
    'Essential Links' => 'Wichtige Links',
    'System Information' => 'Systeminformation',
    'Your Account' => 'Ihr Account',
    'Movable Type Home' => 'Movable Type Home',
    'Plugin Directory' => 'Plugin-Verzeichnis',
    'Knowledge Base' => 'Knowledge Base',
    'Support and Documentation' => 'Support und Dokumentation',
    'Professional Network' => 'Professional Network',
    'System Overview' => 'Systemübersicht',
    'From this screen, you can view information about and manage many aspects of your system across all weblogs.' => 'Hier können Sie Ihr Gesamtsystem verwalten und Einstellungen für alle Weblogs vornehmen.',

    ## ./tmpl/cms/list_ping.tmpl
    'Show pending TrackBacks' => 'Noch nicht veröffentlichte TrackBacks',
    'The selected TrackBack(s) has been published.' => 'TrackBack(s) jetzt veröffentlicht.',
    'The selected TrackBack(s) has been unpublished.' => 'TrackBack(s) jetzt nicht veröffentlicht.',
    'The selected TrackBack(s) has been junked.' => 'TrackBack(s) jetzt Junk.',
    'The selected TrackBack(s) has been unjunked.' => 'TrackBack(s) nicht mehr Junk.',
    'The selected TrackBack(s) has been deleted from the database.' => 'TrackBack(s) aus Datenbank gelöscht.',
    'No TrackBacks appeared to be junk.' => 'Keine TrackBacks sind Junk.',
    'Junk TrackBacks' => 'Junk TrackBacks',
    'Show unpublished TrackBacks.' => 'Nicht veröffentlichte TrackBacks anzeigen.',
    'Showing all TrackBacks.' => 'Alle TrackBacks anzeigen.',
    'Showing only TrackBacks where' => 'Nur TrackBacks anzeigen die',
    'TrackBacks.' => 'TrackBacks.',
    'TrackBacks where' => 'TrackBacks die',
    'No TrackBacks could be found.' => 'Keine TrackBacks gefunden.',
    'No junk TrackBacks could be found.' => 'Keine Junk-TrackBacks gefunden.',

    ## ./tmpl/cms/header.tmpl
    'Main Menu' => 'Hauptmenü',
    'Help' => 'Hilfe',
    'Welcome' => 'Willkommen',
    'Logout' => 'Abmelden',
    'Weblogs:' => 'Weblogs:',
    'Go' => 'Wechseln',
    'System-wide listing' => 'Gesamtsystem Auflistung',
    'Search (f)' => 'Suche (f)',

    ## ./tmpl/cms/list_plugin.tmpl
    'Are you sure you want to reset the settings for this plugin?' => 'Wollen Sie die Plugin-Einstellungen wirklich zurücksezten?',
    'Disable plugin system?' => 'Plugin-System ausschalten?',
    'Disable this plugin?' => 'Dieses Plugin ausschalten?',
    'Enable plugin system?' => 'Plugin-System einschalten?',
    'Enable this plugin?' => 'Dieses Plugin einschalten?',
    'Plugin Settings' => 'Plugin-Einstellungen',
    'This screen allows you to control the weblog-level settings of any configurable plugins you\'ve installed.' => 'Hier können Sie die Weblog-spezifischen Einstellungen aller konfigurierbaren Plugins vornehmen.',
    'Your plugin settings have been saved.' => 'Ihre Plugins-Einstellungen wurden gespeichert.',
    'Your plugin settings have been reset.' => 'Ihre Plugin-Einstellungen wurden zurückgesetzt.',
    'Your plugins have been reconfigured.' => 'Ihre Plugins wurden neu konfiguriert.',
    'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => 'Ihre Plugins wurden nue konfiguriert. Da Sie mod_perl verwenden, müssen Sie Ihren Webserver neu starten, damit die Änderungen wirksam werden.',
    'Registered Plugins' => 'Registrierte Plugins',
    'To download more plugins, check out the' => 'Mehr Plugins finden Sie im',
    'Six Apart Plugin Directory' => 'Six Apart Plugin Directory',
    'Disable Plugins' => 'Plugins ausschalten',
    'Enable Plugins' => 'Plugins einschalten',
    'Error' => 'Fehler',
    'Failed to Load' => 'Fehler beim Laden',
    'Disable' => 'Ausschalten',
    'Enabled' => 'Eingeschaltet',
    'Disabled' => 'Ausgeschaltet',
    'Enable' => 'Einschalten',
    'Documentation for [_1]' => 'Dokumentation zu [_1]',
    'Documentation' => 'Dokumentation',
    'Author of [_1]' => 'Autor von [_1]',
    'More about [_1]' => 'Mehr über [_1]',
    'Support' => 'Support',
    'Plugin Home' => 'Plugin Home',
    'Resources' => 'Resourcen',
    'Show Resources' => 'Resourcen anzeigen',
    'More Settings' => 'Mehr Einstellungen',
    'Show Settings' => 'Einstellungen zeigen',
    'Settings for [_1]' => 'Einstellungen von [_1]',
    'Resources Provided by [_1]' => 'Resourcen von [_1]',
    'Tags' => 'Tags',
    'Tag Attributes' => 'Tag-Attribute',
    'Text Filters' => 'Text-Filter',
    'Junk Filters' => 'Junk-Filter',
    '[_1] Settings' => '[_1] Einstellungne',
    'Reset to Defaults' => 'Standardwerte setzen',
    'Plugin error:' => 'Plugin-Fehler:',
    'No plugins with weblog-level configuration settings are installed.' => 'Es sind keine Plugins installiert, die am Gesamtsystem konfiguriert werden können.',

    ## ./tmpl/cms/error.tmpl
    'An error occurred:' => 'Es ist ein Fehler aufgetreten:',
    'Go Back' => 'Zurück',

    ## ./tmpl/cms/list_comment.tmpl
    'The selected comment(s) has been published.' => 'Kommentar(e) veröffentlicht.',
    'The selected comment(s) has been unpublished.' => 'Kommentar(e) nicht mehr veröffentlicht.',
    'The selected comment(s) has been junked.' => 'Kommentar(e) jetzt Junk.',
    'The selected comment(s) has been unjunked.' => 'Kommentar(e) jetzt nicht mehr Junk.',
    'The selected comment(s) has been deleted from the database.' => 'Kommentar(e) aus der Datenbank gelöscht.',
    'No comments appeared to be junk.' => 'Keine Kommentare sind Junk.', 
    'Go to Commenter Listing' => 'Zur Kommentatorenübersicht wechseln',
    'Showing all comments.' => 'Alle Kommentare anzeigen.',
    'Showing only comments where' => 'Nur Kommentare anzeigen die',
    'comments.' => 'Kommentare.',
    'comments where' => 'Kommentare die',
    'No comments could be found.' => 'Keine Kommentare gefunden.',
    'No junk comments could be found.' => 'Keine Junk-Kommentare gefunden.',

    ## ./tmpl/cms/system_info.tmpl
    'System Status and Information' => 'Systemstatus und -informationen',

    ## ./tmpl/cms/footer-popup.tmpl

    ## ./tmpl/cms/import_end.tmpl
    'All data imported successfully! Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Alle Daten erfolgreich importiert! Löschen Sie den Datei aus Ihrem Verzeichnis, damit die Einträge bei einem neuen Import nicht wieder importiert werden.',
    'An error occurred during the import process: [_1]. Please check your import file.' => 'Beim Import ist ein Fehler aufgetreten: [_1]. Bitte überprüfen Sie Ihre Import-Datei.',

    ## ./tmpl/cms/itemset_action_widget.tmpl
    'More actions...' => 'Weitere Aktionen...',
    'No actions' => 'Keine Aktionen',

    ## ./tmpl/cms/upload_confirm.tmpl
    'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'Eine Datei namens \'[_1]\' ist bereits vorhanden. Möchten Sie die Datei berschreiben?',

    ## ./tmpl/cms/recover.tmpl
    'Your password has been changed, and the new password has been sent to your email address ([_1]).' => 'Ihr Passwort wurde geändert, und das neue Passwort wurde an Ihre E-Mail-Adresse gesendet ([_1]).',
    'Enter your Movable Type username:' => 'Geben Sie Ihren Benutzernamen für Movable Type ein:',
    'Enter your password hint:' => 'Geben Sie Ihre Passwort-Frage ein:',
    'Recover' => 'Wiederherstellen',

    ## ./tmpl/cms/install.tmpl
    'Welcome to Movable Type!' => 'Willkommen bei Movable Type!',
    'Before you can begin blogging, we need to complete your installation by initializing your database.' => 'Wir müssen den Installationsvorgang beenden, indem wir Ihre Datenbank initialisieren. Dann können Sie mit dem Bloggen beginnen.',
    'Finish Install' => 'Installation beenden',

    ## ./tmpl/cms/rebuilt.tmpl
    'All of your files have been rebuilt.' => 'Es wurden alle Dateien neu veröffentlicht.',
    'Your [_1] has been rebuilt.' => '[_1] wurde neu veröffentlicht.',
    'Your [_1] pages have been rebuilt.' => '[_1] Seiten wurden neu veröffentlicht.',
    'View this page' => 'Diese Seite anzeigen',
    'Rebuild Again' => 'Neuaufbau erneut durchführen',

    ## ./tmpl/cms/upload_complete.tmpl
    'Your file has been uploaded. Size: [quant,_1,byte].' => 'Ihre Datei wurde hochgeladen. Größe: [quant,_1,Byte].',
    'Create a new entry using this uploaded file' => 'Erstellen Sie mit dieser Datei einen Eintrag.',
    'Show me the HTML' => 'HTML anzeigen',
    'Image Thumbnail' => 'Miniaturansicht',
    'Create a thumbnail for this image' => 'Erstellen Sie eine Miniaturansicht für das Bild.',
    'Width:' => 'Breite:',
    'Pixels' => 'Pixel',
    'Percent' => 'Prozent',
    'Height:' => 'Hhe:',
    'Constrain proportions' => 'Proportionen beibehalten',
    'Would you like this file to be a:' => 'Wie soll die Datei angezeigt werden:',
    'Popup Image' => 'Popup-Bild',
    'Embedded Image' => 'Eingebettetes Bild',

    ## ./tmpl/cms/list_template.tmpl
    'Index Templates' => 'Index-Templates',
    'Index templates produce single pages and can be used to publish Movable Type data or plain files with any type of content. These templates are typically rebuilt automatically upon saving entries, comments and TrackBacks.' => 'Index-Templates erzeugen Einzelseiten, die Movable Type-Inhalte anzeigen können. Normalerweise werden Index-Templates beim Veröffentlichen von Einträgen, Kommentaren und TrackBacks aktualisiert.',
    'Archive Templates' => 'Archiv-Templates',
    'Archive templates are used for producing multiple pages of the same archive type.  You can create new ones and map them to archive types on the publishing settings screen for this weblog.' => 'Archiv-Templates erzeugen Archivdateien vom jeweiligen Archivtypen.',
    'System Templates' => 'System-Templates',
    'System templates specify the layout and style of a small number of dynamic pages which perform specific system functions in Movable Type.' => 'System-Templates legen das Layout und den Stil von einigen dynamischen Seiten fest, die besondere Funktionen haben.',
    'Template Modules' => 'Template-Module',
    'Template modules are mini-templates that produce nothing on their own but instead can be included into other templates.  They are excellent for duplicated content (e.g. header or footer content) and can contain template tags or just static text.' => 'Template-Module sind Mini-Templates, die als Include in Ihren anderen Templates eingefügt bzw. verwendet werden können. Sie können z.B. für gleichbleibende Elemente wie Header oder Footer eingesetzt werden.',
    'You have successfully deleted the checked template(s).' => 'Template(s) erfolgreich gelöscht.',
    'Your settings have been saved.' => 'Die Einstellungen wurden gespeichert.',
    'Indexes' => 'Index-Dateien',
    'Modules' => 'Module',
    'Go to Publishing Settings' => 'Optionen bearbeiten',
    'Create new index template' => 'Neues Index-Template',
    'Create New Index Template' => 'Neues Index-Template',
    'Create new archive template' => 'Neues Archiv-Template',
    'Create New Archive Template' => 'Neues Archiv-Template',
    'Create new template module' => 'Neues Template-Modul',
    'Create New Template Module' => 'Neues Template-Modul', 
    'No index templates could be found.' => 'Keine Index-Tempaltes gefunden.',
    'No archive templates could be found.' => 'Keine Archiv-Templates geunden.',
    'Description' => 'Beschreibung',
    'No template modules could be found.' => 'Keine Template-Module gefunden.',

    ## ./tmpl/cms/cfg_system_feedback.tmpl
    'This screen allows you to configure feedback and outbound TrackBack settings for the entire installation.  These settings override any similar settings for individual weblogs.' => 'Hier konfigurieren Sie die Kommentar- und TrackBack-Einstellungen für das Gesamtsystem. Diese Einstellungen setzen die Einstellungen beim Einzelweblog außer Kraft.',
    'Feedback Master Switch' => 'Feedback-Hauptschalter',
    'Disable Comments' => 'Kommentare ausschalten',
    'Stop accepting comments on all weblogs' => 'Bei allen Weblogs Kommentare ausschalten',
    'This will override all individual weblog comment settings.' => 'Diese Einstellung setzt die Einstellung beim Einzelweblog außer Kraft.',
    'Disable TrackBacks' => 'TrackBacks ausschalten',
    'Stop accepting TrackBacks on all weblogs' => 'Bei allen Weblogs TrackBack ausschalten',
    'This will override all individual weblog TrackBack settings.' => 'Diese Einstellung setzt die Einstellung beim Einzelweblog außer Kraft.',
    'Outbound TrackBack Control' => 'TrackBack-Kontrolle (outbound)',
    'Allow outbound TrackBacks to:' => 'TrackBacks (outbound) zulassen:',
    'Any site' => 'zu beliebigen Sites',
    'No site' => 'zu keinen Sites',
    '(Disable all outbound TrackBacks.)' => '(Alle TrackBacks (outbound) ausschalten.)',
    'Only the weblogs on this installation' => 'nur zu Sites in dieser Installation',
    'Only the sites on the following domains:' => 'nur zu Sites mit den folgenden Domains:',
    'This feature allows you to limit outbound TrackBacks and TrackBack auto-discovery for the purposes of keeping your installation private.' => 'Um Ihre Installation nicht öffentlich zu machen, können Sie hier begrenzen, auf welche Sites TrackBacks (outbound) zugelassen sind.',

    ## ./tmpl/cms/edit_author.tmpl
    'Your API Password is currently' => 'Ihr API-Passwort ist derzeit',
    'Author Profile' => 'Autorenprofil',
    'Your profile has been updated.' => 'Ihr Profil wurde aktualisiert.',
    'Weblog Associations' => 'Weblog-Berechtigungen',
    'Create Weblogs' => 'Weblogs einrichten',
    'Username:' => 'Beutzername:',
    'The name used by this author to login.' => 'Der Name, um sich am System anzumelden.',
    'Display Name:' => 'Angezeigter Name:',
    'The author\'s published name.' => 'Der Name, der bei Einträgen angezeigt wird.',
    'The author\'s email address.' => 'Die Email-Adresse des Autors.',
    'Website URL:' => 'Website-URL:',
    'The URL of this author\'s website. (Optional)' => 'Die URL des Autors. (optional)',
    'Language:' => 'Sprache:',
    'The author\'s preferred language.' => 'Die bevorzugte Sprache des Autors.',
    'Current Password:' => 'Aktuelles Passwort:',
    'Enter the existing password to change it.' => 'Geben Sie das aktuelle Passwort ein, um es dann zu ändern.',
    'New Password:' => 'Neues Passwort:',
    'Initial Password:' => 'Anfangspasswort:',
    'Select a password for the author.' => 'Geben Sie ein Passwort für den Autor an.',
    'Password Confirm:' => 'Passwort wiederholen:',
    'Repeat the password for confirmation.' => 'Passwort zur Bestätigung wiederholen.',
    'Password hint:' => 'Passwort-Erinnerung:',
    'For password recovery.' => 'Um das Passwort anzufordern.',
    'API Password:' => 'API-Passwort:',
    'Reveal' => 'Anzeigen',
    'For use with XML-RPC and Atom-enabled clients.' => 'Zur Verwendung mit Clients via XML-RPC oder Atom-Schnittstelle.',
    'Save this author (s)' => 'Autor speichern',

    ## ./tmpl/cms/upgrade_runner.tmpl
    'Installation complete.' => 'Installierung abgeschlossen.',
    'Upgrade complete.' => 'Upgrade abgeschlossen.',
    'Initializing database...' => 'Initialisiere Datenbank...',
    'Upgrading database...' => 'Upgrade der Datenbank...',
    'Starting installation...' => 'Starte Install...',
    'Starting upgrade...' => 'Starte Upgrade...',
    'Error during installation:' => 'Fehler während Installierung:',
    'Error during upgrade:' => 'Fehler während Upgrade:',
    'Installation complete!' => 'Installierung fertig!',
    'Upgrade complete!' => 'Upgrade fertig!',
    'Login to Movable Type' => 'Bei Movable Type anmelden',
    'Return to Movable Type' => 'Zurück zu Movable Type',
    'Your database is already current.' => 'Ihre Datenbank ist bereits auf dem aktuellen Stand.',

    ## ./tmpl/cms/bm_entry.tmpl
    'Select' => 'Auswählen',
    'You must choose a weblog in which to post the new entry.' => 'Sie müssen ein Weblog auswählen, in dem der neue Eintrag gepostet wird.',
    'Send an outbound TrackBack:' => 'TrackBack (outbound) senden:',
    'Select an entry to send an outbound TrackBack:' => 'Eintrag wählen, zu dem Sie TrackBack senden möchten:',
    'Select a weblog for this post:' => 'Wählen Sie ein Weblog für diesen Eintrag:',
    'You do not have entry creation permission for any weblogs on this installation. Please contact your system administrator for access.' => 'Sie haben derzeit keine Rechte, Weblogs zu bearbeiten. Bitte kontaktieren Sie Ihren Administrator',

    ## ./tmpl/cms/overview-left-nav.tmpl
    'List Weblogs' => 'Weblogs anzeigen',
    'List Authors' => 'Autoren anzeigen',
    'List Plugins' => 'Plugins anzeigen',
    'Aggregate' => 'Übersicht',
    'Edit System Settings' => 'Systemeinstellungen bearbeiten',
    'Show Activity Log' => 'Aktivitätsprotokoll anzeigen',

    ## ./tmpl/cms/comment_actions.tmpl
    'comment' => 'Kommentar',
    'comments' => 'Kommentare',
    'Publish selected comments (p)' => 'Kommentare veröffentlichen (p)',
    'Delete selected comments (d)' => 'Kommentare löschen (d)',
    'Junk selected comments (j)' => 'Kommentare sind Junk (j)',
    'Recover selected comments (j)' => 'Kommentare wiederherstellen (j)',

    ## ./tmpl/cms/system_list_blog.tmpl
    'Below you find a list of all weblogs in the system with links to the main weblog page and individual settings pages for each.  You may also create or delete blogs from this screen.' => 'Unten finden Sie eine Liste mit allen Weblogs im Gesamtsystem mit Links zu der Weblog-Hauptseite und zu den Einstellungen für jedes Weblog. Sie können hier auch Weblogs anlegen oder löschen.',
    'You have successfully deleted the blogs from the Movable Type system.' => 'Die Weblogs wurden erfolgreich aus dem System gelöscht.',
    'Create New Weblog' => 'Neues Weblog anlegen',
    'No weblogs could be found.' => 'Keine Weblogs gefunden.',

    ## ./tmpl/cms/cfg_archives.tmpl
    'Publishing Settings' => 'Grundeinstellungen',
    'This screen allows you to control this weblog\'s publishing paths and preferences, as well as archive mapping settings.' => 'Hier können Sie alle Pfade und Archiveinstellungen vornehmen.',
    'Go to Templates Listing' => 'Zur Template-Anzeige wechslen',
    'Go to Template Listing' => 'Zur Template-Anzeige wechslen',
    'Error: Movable Type was not able to create a directory for publishing your weblog. If you create this directory yourself, assign sufficient permissions that allow Movable Type to create files within it.' => 'Fehler: Movable Type konnte das Weblog-Verzeichnis nicht automatisch anlegen. Wenn Sie die Rechte an dem Verzeichnis ändern können, konfigurieren Sie die Rechte bitte so, daß Movable Type das Verzeichnis anlegen darf.',
    'Your weblog\'s archive configuration has been saved.' => 'Die Archivierungskonfiguration Ihres Weblog wurde gespeichert.',
    'You may need to update your templates to account for your new archive configuration.' => 'Eventuell müssen Sie auch Ihre Templates anpassen, um die neue Archivkonfiguration entsprechend darzustellen.',
    'You have successfully added a new archive-template association.' => 'Sie haben erfolgreich eine neue Verknüpfung zwischen Archiv und Template hinzugefgt.',
    'You may need to update your \'Master Archive Index\' template to account for your new archive configuration.' => 'Eventuell müssen Sie Ihr \'Master Archive Index\' Template aktualisieren, um die neue Archiv-Konfiguration zu übernehmen.',
    'The selected archive-template associations have been deleted.' => 'Die ausgewählten Verknpfungen zwischen Archiv und Template wurden gelöscht.',
    'Publishing Paths' => 'System-Pfade',
    'Enter the URL of your website. Do not include a filename (i.e. exclude index.html).' => 'Geben Sie die URL Ihrer Website an - keinen Dateinamen (z.B. nicht index.html).',
    'Site Root:' => 'Site-Root:',
    'Enter the path where your index files will be published. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'Der Pfad zu dem Verzeichnis, in dem Ihre Index-Datei veröffentlicht wird. Ein absoluter Pfad (beginnened mit \'/\') wird bevorzugt. Sie können aber auch einen relativen Pfad zu Ihrem Movable Type-Verzeichnis eingeben.',
    'Advanced Archive Publishing:' => 'Erweiterte Archiveinstellungen:',
    'Publish archives to alternate root path' => 'Archive im alternativen Root-Pfad veröffentlichen',
    'Select this option only if you need to publish your archives outside of your Site Root.' => 'Wählen Sie diese Option nur, wenn Sie Ihre Archive außerhalb des Site-Root-Verzeichnisses veröffentlichen müssen.',
    'Archive URL:' => 'Archiv-URL:',
    'Enter the URL of the archives section of your website.' => 'Geben Sie die URL der Archive Ihres Weblogs an.',
    'Archive Root:' => 'Archiv-Root:',
    'Enter the path where your archive files will be published.' => 'Geben Sie den Pfad zu Ihren Archivdateien an.',
    'Publishing Preferences' => 'Weitere Einsellungen',
    'Preferred Archive Type:' => 'Bevorzugter Archivierungstyp:',
    'No Archives' => 'Keine Archive',
    'Individual' => 'Einzeln',
    'Daily' => 'Täglich',
    'Weekly' => 'Wöchentlich',
    'Monthly' => 'Monatlich',
    'When linking to an archived entry&#8212;for a permalink, for example&#8212;you must link to a particular archive type, even if you have chosen multiple archive types.' => 'Wenn Sie eine Verknüpfung zu einem archivierten Eintrag herstellen&#8212; wie einen Permalink&#8212; müssen Sie mit einem bestimmten Archivierungstyp verknüpfen, auch dann, wenn Sie mehrere Archivierungstypen ausgewählt haben.',
    'File Extension for Archive Files:' => 'Dateierweiterung für Archivierungsdateien:',
    'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'Geben Sie die Erweiterung für die Archivierungsdatei an. Möglich sind \'html\', \'shtml\', \'php\' usw. Hinweis: Geben Sie nicht den führenden Punkt (\'.\') ein.',
    'Dynamic Publishing:' => 'Dynamisches Veröffentlichen:',
    'Build all templates statically' => 'Alle Templates statisch aufbauen',
    'Build only Archive Templates dynamically' => 'Nur Archiv-Templates dynamisch aufbauen',
    'Set each template\'s Build Options separately' => 'Optionen für jedes Template einzeln setzen',
    'Archive Mapping' => 'Archiv-Mapping',
    '_USAGE_ARCHIVE_MAPS' => 'Diese fortgeschrittene Funktion erlaubt es Ihnen, ein Archiv-Template auf verschiedene Archivtypen zu mappen. So können Sie z.B. zwei unterschiedliche Views Ihrer monatlichen Archive erzeugen; einen als Liste und einen als Kalenderansicht.',
    'Create New Archive Mapping' => 'Neues Archiv-Mapping einrichten',
    'Archive Type:' => 'Archivierungstyp:',
    'INDIVIDUAL_ADV' => 'Einzeln',
    'DAILY_ADV' => 'Tägliches',
    'WEEKLY_ADV' => 'Wöchentliches',
    'MONTHLY_ADV' => 'Monatliches',
    'CATEGORY_ADV' => 'Kategorie',
    'Template:' => 'Template:',
    'Archive Types' => 'Archivierungstypen',
    'Template' => 'Templates',
    'Archive File Path' => 'Archivdatei-Pfad',
    'Preferred' => 'Bevorzugt',
    'Custom...' => 'Angepasst...',
    'archive map' => 'Archiv-Map',
    'archive maps' => 'Archiv-Maps',

    ## ./tmpl/cms/rebuilding.tmpl
    'Rebuilding [_1]' => 'Veröffentlichen von [_1]',
    'Rebuilding [_1] pages [_2]' => '[_1] Seiten neu aufbauen [_2]',
    'Rebuilding [_1] dynamic links' => 'Neuaufbau [_1] dynamische Links',
    'Rebuilding [_1] pages' => '[_1] Seiten neu aufbauen',

    ## ./tmpl/cms/upload.tmpl
    'Choose a File' => 'Datei auswählen',
    'To upload a file to your server, click on the browse button to locate the file on your hard drive.' => 'Klicken Sie auf die Schaltfläche zum Durchsuchen, um die Festplatte nach der Datei zu durchsuchen.',
    'File:' => 'Datei:',
    'Choose a Destination' => 'Ziel auswählen',
    'Upload Into:' => 'Hochladen in:',
    '(Optional)' => '(optional)',
    'Local Archive Path' => 'Lokaler Archivierungspfad',
    'Local Site Path' => 'Lokaler Sitepfad',
    'Upload' => 'Hochladen',

    ## ./tmpl/cms/upgrade.tmpl
    'Time to Upgrade!' => 'Zeit für Ihr Upgrade!',
    'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Es wurde eine neue Version von Movable Type installiert. Ihre Datenbank wird nun auf den aktuellen Stand gebracht.',
    'Begin Upgrade' => 'Upgrade durchführen',

    ## ./tmpl/cms/menu.tmpl
    'Five Most Recent Entries' => 'Die 5 aktuellsten Einträge',
    'View all Entries' => 'Alle Einträge anzeigen',
    'Five Most Recent Comments' => 'Die 5 aktuellsten Kommentare',
    'View all Comments' => 'Alle Kommentare anzeigen',
    'Five Most Recent TrackBacks' => 'Die 5 aktuellsten TrackBacks',
    'View all TrackBacks' => 'Alle TrackBacks anzeigen',
    'Welcome to [_1].' => 'Willkommen bei [_1].',
    'You can post to and manage your weblog by selecting an option from the menu located to the left of this message.' => 'Sie können Einträge veröffentlichen oder Ihr Weblog verwalten, indem Sie eine der links aufgeführten Optionen wählen.',
    'If you need assistance, try:' => 'Falls Sie Hilfe benötigen, stehen folgende Möglichkeiten zur Verfügung:',
    'Movable Type User Manual' => 'Movable Type Benutzerhandbuch',
    'Movable Type Technical Support' => 'Movable Type technischer Support',
    'Movable Type Support Forum' => 'Movable Type Support-Forum',
    'This welcome message is configurable.' => 'Die Willkommensnachricht kann konfiguriert werden.',
    'Change this message.' => 'Diese Nachricht ändern.',

    ## ./tmpl/email/new-ping.tmpl
    'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Ein nicht freigeschaltes TrackBack wurde bei Ihrem Weblog [_1] registriert - zu Eintrag #[_2] ([_3]). Sie müssen dieses TrackBack freischalten, damit es auf Ihrem Weblog erscheint.',
    'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Ein nicht freigeschaltes TrackBack wurde bei Ihrem Weblog [_1] - zu Kategorie #[_2], ([_3]). Sie müssen dieses TrackBack freischalten, damit es auf Ihrem Weblog erscheint.',
    'Approve this TrackBack:' => 'TrackBack freischalten:',
    'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Ein neues TrackBack wurde bei Ihrem Weblog [_1] registriert, zu Eintrag #[_2] ([_3]).',
    'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'Ein neues TrackBack wurde bei Ihrem Weblog [_1] - zu Kategorie #[_2] ([_3]).',
    'View this TrackBack:' => 'TrackBack ansehen:',
    'Edit this TrackBack:' => 'TrackBack bearbeiten:',
    'Title:' => 'Überschrift:',
    'Excerpt:' => 'Auszug:',

    ## ./tmpl/email/new-comment.tmpl
    'An unapproved comment has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => 'Ein nicht freigeschalter Kommentar wurde bei Ihrem Weblog [_1] registriert -  bei Eintrag #[_2] ([_3]). Sie müssen diesen Kommentar freischalten, damit er auf Ihrem Weblog erscheint.',
    'Approve this comment:' => 'Kommentar freischalten:',
    'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Ein neuer Kommentar wurde in Ihrem Weblog [_1] veröffentlicht - zu Eintrag #[_2] ([_3]).',
    'View this comment:' => 'Kommentar anzeigen:',
    'Edit this comment:' => 'Kommentar bearbeiten:',

    ## ./tmpl/email/verify-subscribe.tmpl
    'If the link is not clickable, just copy and paste it into your browser.' => 'Wenn Sie nicht auf den Link können, kopieren Sie den Link einfach und fügen Ihn in der Adresszeile Ihres Browers ein.',

    ## ./extras/examples/plugins/mirror/mirror.pl

    ## ./extras/examples/plugins/mirror/tmpl/mirror.tmpl

    ## Other phrases, with English translations.
    'WEEKLY_ADV' => 'Wöchentliches',
    'Unpublish Comment(s)' => 'Kommentar(e) nicht mehr veröffentlichen',
    '_SYSTEM_TEMPLATE_COMMENT_PENDING' => '_SYSTEM_TEMPLATE_COMMENT_PENDING',
    'RSS 1.0 Index' => 'RSS 1.0 Index',
    'Manage Categories' => 'Kategorien verwalten',
    '_USAGE_BOOKMARKLET_4' => 'Nach der Installation von QuickPost können Sie von jedem Ort im Web aus Einträge posten. Wenn Sie eine Seite anzeigen, ber die Sie einen Eintrag posten möchten, klicken Sie auf "QuickPost". Es wird ein Popup-Fenster mit einem Movable Type-Fenster zum Bearbeiten geffnet. In diesem Fenster können Sie ein Weblog auswählen, an das der Eintrag gepostet werden soll. Geben Sie dann den Eintrag ein, und veröffentlichen Sie ihn.',
    '_USAGE_ARCHIVING_2' => 'Wenn Sie mehrere Templates mit einem bestimmten Archivierungstyp verknüpfen  oder auch, wenn Sie nur ein Template verknüpfen  können Sie mit der Vorlage für die Archivierungsdatei den Ausgabepfad für die Archivierungsdateien anpassen.',
    'UTC+11' => 'Utc+11',
    'View Activity Log For This Weblog' => 'Aktivitätsprotokoll zu diesem Weblog ansehen',
    'DAILY_ADV' => 'Tägliches',
    '_USAGE_PERMISSIONS_3' => 'Sie haben zwei Möglichkeiten, Autoren zu bearbeiten und Zugriffsberechtigungen zu gewhren/widerrufen. Am schnellsten geht es, wenn Sie aus dem nachfolgenden Menü einen Benutzer auswählen und auf "Bearbeiten" klicken. Alternativ können Sie die vollstndige Liste mit Autoren durchsuchen und dort einen Autor auswählen, den Sie bearbeiten oder löschen möchten.',
    '_USAGE_NOTIFICATIONS' => 'Die Liste der Benutzer, die benachrichtigt werden möchten, wenn Sie Einträge auf Ihrer Site posten. Um einen neuen Benutzer hinzuzufügen, geben Sie dessen E-Mail-Adresse in das nachfolgende Formular ein. Das URL-Feld ist optional. Wenn Sie einen Benutzer löschen möchten, aktivieren Sie das Kontrollkästchen "löschen" in der nachfolgenden Tabelle, und klicken Sie auf die Schaltfläche LöSCHEN.',
    'Manage Notification List' => 'Benachrichtigungsliste bearbeiten',
    'Individual' => 'Einzeln',
    '_USAGE_COMMENTERS_LIST' => 'Eine Liste der Kommentatoren in [_1].',
    'RSS 2.0 Index' => 'RSS 2.0 Index',
    '_USAGE_LIST' => 'Eine Liste der Einträge in [_1]. Sie können alle Einträge bearbeiten, indem Sie auf den EINTRAGSNAMEN klicken. wählen Sie "Kategorie", "Autor" oder "Eintragsstatus" aus dem ersten Pulldown-Menü, um die Einträge zu FILTERN. Grenzen Sie anschließend die Auswahlmöglichkeiten mithilfe des zweiten Pulldown-Menüs weiter ein. Verwenden Sie das Pulldown-Menü unterhalb der Tabelle mit Einträgen, um die Anzahl angezeigter Einträge anzupassen.',
    '_USAGE_BANLIST' => 'Nachfolgend sehen Sie die Liste der IP-Adressen, die Sie für Kommentare auf Ihrer Site sowie für das Senden von TrackBack-Pings an Ihre Site gesperrt haben. Wenn Sie eine neue IP-Adresse hinzufügen möchten, geben Sie die Adresse in das nachfolgende Formular ein. Wenn Sie eine gesperrte IP-Adresse löschen möchten, aktivieren Sie das Kontrollkästchen "löschen" in der nachfolgenden Tabelle, und klicken Sie auf die Schaltfläche LöSCHEN.',
    '_ERROR_DATABASE_CONNECTION' => '_ERROR_DATABASE_CONNECTION',
    'Configure Weblog' => 'Weblog einrichten',
    '_USAGE_AUTHORS' => 'Eine Liste aller Benutzer im Movable Type-System. Sie können die Berechtigungen eines Autors bearbeiten, indem Sie auf dessen Namen klicken. Wenn Sie das Kontrollkästchen <b>löschen</b> aktivieren und anschließend auf LöSCHEN klicken, werden Autoren dauerhaft gelöscht. HINWEIS: Wenn Sie einen Autor lediglich aus einem bestimmmten Blog entfernen möchten, bearbeiten Sie die Berechtigungen des Autors, um ihn zu entfernen. Beim löschen von Autoren mithilfe von LöSCHEN werden sie komplett aus dem System entfernt.',
    '_USAGE_FEEDBACK_PREFS' => '_USAGE_FEEDBACK_PREFS',
    '_USAGE_COMMENTS_LIST_ALL_WEBLOGS' => 'Eine Liste der Kommentare für alle Weblogs. Sie können alle Kommentare bearbeiten, indem Sie auf den KOMMENTARTEXT klicken. Klicken Sie auf einen der auf der Liste angezeigten Werte, um die Einträge zu FILTERN.',
    '_USAGE_NEW_AUTHOR' => '_USAGE_NEW_AUTHOR',
    '_USAGE_FORGOT_PASSWORD_2' => 'Mit diesem neuen Passwort sollte die Anmeldung bei Movable Type funktionieren. Wenn Sie sich angemeldet haben, sollten Sie Ihr Passwort so ändern, dass Sie es sich merken können.',
    '_USAGE_COMMENT' => 'Bearbeiten Sie den ausgewählten Kommentar. Klicken Sie anschließend auf SPEICHERN. Sie müssen einen Neuaufbau durchfhren, damit die Änderungen wirksam werden.',
    '_USAGE_FORGOT_PASSWORD_1' => 'Sie haben eine Wiederherstellung Ihres Movable Type-Passworts angefordert. Ihr Passwort wurde im System geändert; Sie bekommen ein neues Passwort:',
    '_USAGE_EXPORT_2' => 'Um Ihre Einträge zu exportieren, klicken Sie auf den folgenden Link ("Einträge exportieren von [_1]"). Um die exportierten Daten in einer Datei zu speichern, klicken Sie auf den Link, während Sie <code>Option</code> auf dem Macintosh bzw. <code>Umschalt</code> auf dem PC gedrückt halten. Sie können auch sämtliche Daten auswählen und sie in ein anderes Dokument kopieren. (<a href="#" onclick="openManual(\'importing\', \'export_ie\');return false;">Exportieren aus dem Internet Explorer?</a>)',
    '_SYSTEM_TEMPLATE_POPUP_IMAGE' => '_SYSTEM_TEMPLATE_POPUP_IMAGE',
    '_USAGE_PING_LIST_ALL_WEBLOGS' => 'Eine Liste der Pings für alle Weblogs.',
    '_SYSTEM_TEMPLATE_DYNAMIC_ERROR' => '_SYSTEM_TEMPLATE_DYNAMIC_ERROR',
    'Publish Entries' => 'Einträge veröffentlichen',
    'Date-Based Archive' => 'Archiv: datumsbasiert',
    'Unban Commenter(s)' => 'Kommentatoren entsperren',
    'Individual Entry Archive' => 'Archiv: einzelne Einträge',
    'Daily' => 'Täglich',
    'Unpublish Entries' => 'Einräge nicht mehr veröffentlichen',
    '_USAGE_PING_LIST' => 'Eine Liste der Pings für [_1].',
    '_USAGE_UPLOAD' => 'Laden Sie die Datei dann hoch auf Ihren lokalen Sitepfad <a href="javascript:alert(\'[_1]\')">(?)</a> oder Ihren lokalen Archivierungspfad <a href="javascript:alert(\'[_2]\')">(?)</a>. Sie können die Datei auch in ein beliebiges Unterverzeichnis laden, indem Sie den Pfad in den Textfeldern auf der rechten Seite angeben (z. B. <i>Bilder</i>). Ist das Verzeichnis nicht vorhanden, wird es erstellt.',
    '_USAGE_LIST_ALL_WEBLOGS' => 'Eine Liste der Einträge in allen Weblogs. Sie können alle Einträge bearbeiten, indem Sie auf den EINTRAGSNAMEN klicken. wählen Sie "Kategorie", "Autor" oder "Eintragsstatus" aus dem ersten Pulldown-Menü, um die Einträge zu FILTERN. Grenzen Sie anschließend die Auswahlmöglichkeiten mithilfe des zweiten Pulldown-Menüs weiter ein. Verwenden Sie das Pulldown-Menü unterhalb der Tabelle mit Einträgen, um die Anzahl angezeigter Einträge anzupassen.',
    '_USAGE_REBUILD' => '<a href="#" onclick="doRebuild()">NEUAUFBAU</a>, damit die Änderungen auf der öffentlichen Site wirksam werden.',
    'Blog Administrator' => 'Weblog-Administrator',
    'CATEGORY_ADV' => 'Kategorie',
    'Dynamic Site Bootstrapper' => 'Dynamic Site Bootstrapper',
    '_USAGE_PLUGINS' => '_USAGE_PLUGINS',
    'Category Archive' => 'Kategorie-Archive',
    '_USAGE_PERMISSIONS_2' => 'Wenn Sie Berechtigungen für einen anderen Benutzer bearbeiten möchten, whlen Sie einen neuen Benutzer aus dem Pulldown-Menü, und klicken Sie auf BEARBEITEN.',
    '_USAGE_EXPORT_1' => 'Indem Sie Einträge aus Movable Type exportieren, erhalten Sie <b>persönliche Sicherungen</b> Ihrer Weblog-Einträge. Die Daten werden in einem Format exportiert, in dem sie auch mithilfe des zuvor beschriebenen Importmechanismus zurück in das System importiert werden können. Das Exportieren von Einträgen dient nicht nur der Sicherung, Sie können damit auch <b>Inhalte zwischen Blogs verschieben</b>.',
    'Untrust Commenter(s)' => 'Kommentatoren nicht mehr vertrauen',
    '_SYSTEM_TEMPLATE_PINGS' => '_SYSTEM_TEMPLATE_PINGS',
    'Entry Creation' => 'Anlegen von Einträgen',
    '_USAGE_PROFILE' => 'Hier können Sie Ihr Autorenprofil bearbeiten. Eine Änderung von Benutzernamen oder Passwort führt zu einer automatischen Aktualisierung Ihrer Anmeldeinformationen. Das heißt, Sie müssen sich nicht erneut anmelden.',
    'Category' => 'Kategorie',
    'Atom Index' => 'Atom Index',
    '_USAGE_PLACEMENTS' => 'Mit den nachfolgenden Tools zum Bearbeiten können Sie die sekundären Kategorien verwalten, denen dieser Eintrag zugewiesen wurde. Die Liste auf der linken Seite enthält die Kategorien, denen der Eintrag bisher weder als primäre noch als sekundäre Kategorie zugewiesen wurde. Die Liste auf der rechten Seite enthält die sekundären Kategorien, denen der Eintrag zugewiesen wurde.',
    '_USAGE_ENTRYPREFS' => 'Durch die Feldkonfiguration ist festgelegt, welche Eintragsfelder auf dem Bildschirm zum Erstellen oder Bearbeiten von Einträgen angezeigt werden. Sie können eine vorhandene Konfiguration auswählen ("Einfach" oder "Erweitert"), oder Sie können Ihr Fenster individuell anpassen, indem Sie auf "Angepasst" klicken und dann die gewünschten Felder auswählen.',
    '_USAGE_COMMENTS_LIST' => 'Eine Liste der Kommentare in [_1]. Sie können alle Kommentare bearbeiten, indem Sie auf den KOMMENTARTEXT klicken. Klicken Sie auf einen der auf der Liste angezeigten Werte, um die Einträge zu FILTERN.',
    '_THROTTLED_COMMENT_EMAIL' => 'Ein Besucher Ihres Weblogs [_1] wurde automatisch gesperrt, da er in den letzten [_2] Sekunden mehr als die erlaubte Anzahl Kommentare gepostet hat. Damit soll verhindert werden, dass ein schdliches Skript Ihr Weblog mit Kommentaren berschwemmt. Die gesperrte IP-Adresse lautet

    [_3]

Sollte dies ein Fehler sein, können Sie die IP-Adresse entsperren und dem Besucher das Posting erlauben. Melden Sie sich dazu in Ihrer Movable Type-Installation an und gehen Sie zu "Weblog-Konfiguration"  "IP-Adressen sperren" und löschen Sie die IP-Adresse [_4] aus der Liste der gesperrten Adressen.',
    'Stylesheet' => 'Stylesheet',
    'RSD' => 'RSD',
    'MONTHLY_ADV' => 'Monatliches',
    'Trust Commenter(s)' => 'Kommentator(en) vertrauen',
    '_SYSTEM_TEMPLATE_COMMENT_PREVIEW' => '_SYSTEM_TEMPLATE_COMMENT_PREVIEW',
    '_THROTTLED_COMMENT' => 'Um zu verhindern, dass bswillige Benutzer schdliche Kommentare posten, wurde die Funktion aktiviert, dass ein Kommentar-Autor eine kurze Zeit warten muss, bevor er erneut einen Kommentar posten kann. Warten Sie kurz, und versuchen Sie dann erneut, den Kommentar zu posten. Vielen Dank für Ihre Geduld.',
    'Manage Templates' => 'Templates verwalten',
    '_USAGE_BOOKMARKLET_3' => 'Wenn Sie das QuickPost-Lesezeichen von Movable Type installieren möchten, ziehen Sie folgenden Link in Ihr Browsermenü oder auf die Symbolleiste "Favoriten".',
    '_USAGE_SEARCH' => 'Mit dem Tool zum Suchen &amp; Ersetzen können Sie entweder alle Einträge durchsuchen oder jedes Vorkommen von einem Wort/Begriff/Zeichen durch ein anderes ersetzen. WICHTIG: Gehen Sie beim Ersetzen sorgfltig vor, da Vorgnge nicht mehr <b>rückgängig</b> gemacht werden können. Wenn Sie in vielen Einträgen Ersetzungen durchfhren werden, sollten Sie Ihre Einträge mit der Funktion zum Exportieren erst sichern.',
    '_USAGE_BOOKMARKLET_2' => 'QuickPost von Movable Type ermöglicht das Anpassen von Layout und Feldern auf der QuickPost-Seite. Sie könnten beispielsweise den Benutzern die Möglichkeit geben, im Fenster von QuickPost Zusammenfassungen hinzuzufügen. Standardmig bietet das QuickPost-Fenster folgende Optionen: ein Pulldown-Menü für das Weblog, an das Einträge gepostet werden; ein Pulldown-Menü, in dem der Eintragsstatus ("Entwurf" oder "Veröffentlichen") des neuen Eintrags ausgewählt wird; ein Texteingabefeld für die Überschrift des Eintrags und ein Eingabefeld für den Text des Eintrags.',
    '_USAGE_PERMISSIONS_1' => 'Sie bearbeiten die Berechtigungen von <b>[_1]</b>. Nachfolgend wird eine Liste mit Blogs angezeigt, auf die Sie zugreifen können, um Autoren zu bearbeiten. Für jedes Blog in der Liste können Sie Berechtigungen für <b>[_1]</b> zuweisen, indem Sie die Kontrollkästchen der gewünschten Zugriffsberechtigungen markieren.',
    '_AUTO' => '1',
    '_USAGE_LIST_POWER' => 'Eine Liste der Einträge in [_1] im Stapelverarbeitungsmodus. Im nachfolgenden Formular können Sie alle Werte für jeden angezeigten Eintrag ändern. Klicken Sie auf die Schaltfläche SPEICHERN, nachdem Sie die gewünschten Änderungen vorgenommen haben. Die standardmäßigen Steuerelemente für "Einträge auflisten &amp; bearbeiten" (Filter, Paging) arbeiten im Stapelverarbeitungsmodus, wie Sie es gewöhnt sind.',
    '_ERROR_CONFIG_FILE' => '_ERROR_CONFIG_FILE',
    'Monthly' => 'Monatlich',
    '_USAGE_ARCHIVING_1' => 'wählen Sie die Häufigkeiten/Typen der Archivierung, die Sie auf Ihrer Site durchfhren möchten. Für jeden gewhlten Archivierungstyp können Sie mehrere Archivierungsvorlagen zuweisen, die dann auf den bestimmten Typ angewendet werden. Zum Beispiel könnten Sie zwei Ansichten Ihrer monatlichen Archive erstellen: eine Seite mit jedem Eintrag für einen bestimmten Monat und eine Seite mit einer Kalenderansicht dieses Monats.',
    'Ban Commenter(s)' => 'Kommentator(en) sperren',
    '_USAGE_VIEW_LOG' => 'Aktivieren Sie das <a href="#" onclick="doViewLog()">Aktivitätsprotokoll</a> für den Fehler.',
    '_USAGE_PERMISSIONS_4' => 'Jedes Blog kann mehrere Autoren haben. Wenn Sie einen Autor hinzufügen möchten, geben Sie die Daten des Benutzers in das nachfolgende Formular ein. Wählen Sie dann die Blogs aus, für die der Autor bestimmte Autorenberechtigungen bekommen soll. Wenn Sie den Benutzer durch Klicken auf SPEICHERN in das System aufgenommen haben, können Sie die Berechtigungen des Autors ändern.',
    '_USAGE_BOOKMARKLET_1' => 'Wenn Sie QuickPost für das Posten mit Movable Type einrichten, können Sie mit einem Klick posten und veröffentlichen, ohne die Benutzeroberflche von Movable Type zu verwenden.',
    '_USAGE_ARCHIVING_3' => 'Wählen Sie den Archivierungstyp aus, für den Sie eine neue Archivierungsvorlage hinzufügen möchten. Klicken Sie anschließend auf das Template, die Sie mit dem Archivierungstyp verknüpfen möchten.',
    'UTC+10' => 'UTC+10',
    'INDIVIDUAL_ADV' => 'Einzelne',
    '_USAGE_BOOKMARKLET_5' => 'Falls Sie unter Windows mit dem Internet Explorer arbeiten, können Sie die Option "QuickPost" zum Kontextmenü von Windows hinzufügen. Klicken Sie auf den nachfolgenden Link, um die Eingabeaufforderung des Browsers zum öffnen der Datei zu akzeptieren. Beenden Sie das Programm, und starten Sie den Browser erneut, um den Link zum Kontextmen hinzuzufügen.',
    '_ERROR_CGI_PATH' => '_ERROR_CGI_PATH',
    '_USAGE_IMPORT' => 'Mit dem Mechanismus zum Importieren von Einträgen können Sie Einträge aus einem anderen Weblog-System (wie z.B. Blogger oder Greymatter) importieren. Dass Handbuch enthält ausführliche Anweisungen zum Importieren älterer Einträge mit diesem Mechanismus. Mit dem nachfolgenden Formular können Sie Einträge stapelweise importieren, nachdem Sie sie aus dem anderen CMS exportiert und die exportieren Dateien am richtigen Ort gespeichert haben, damit Movable Type sie auch findet. Lesen Sie vor der Verwendung des Formulars das Handbuch durch, damit Sie die Optionen verstehen.',
    'Main Index' => 'Haupt-Index',
    '_USAGE_CATEGORIES' => 'Fassen Sie Einträge in Kategorien zusammen, damit Sie sie leichter auffinden, besser archivieren und im Blog anzeigen können. Beim Erstellen oder Bearbeiten von Einträgen können Sie einem bestimmten Eintrag eine Kategorie zuweisen. Um eine vorhandene Kategorie zu bearbeiten, klicken Sie auf den Titel der Kategorie. Wenn Sie eine Unterkategorie erstellen wollen, klicken Sie auf die entsprechende "Neu"-Schaltfläche. Um eine Kategorie zu verschieben, klicken Sie auf die entsprechende "Move"-Schaltfläche.',
    '_SYSTEM_TEMPLATE_COMMENTS' => '_SYSTEM_TEMPLATE_COMMENTS',
    'Master Archive Index' => 'Haupt-Archiv-Index',
    'Weekly' => 'Wöchentlich',
    'Unpublish TrackBack(s)' => 'TrackBack(s) nicht mehr veröffentlichen',
    '_USAGE_EXPORT_3' => 'Durch Klicken auf den nachfolgenden Link werden alle aktuellen Weblog-Einträge auf den Tangent-Server exportiert. In der Regel ist das übertragen der Einträge ein einmaliger Vorgang, der nach der Installation des Tangent-Add-Ons für Movable Type ausgeführt wird. Sie können ihn aber jederzeit wiederholen.',
    'Send Notifications' => 'Benachrichtigungne versenden',
    'Edit All Entries' => 'Alle Einträge bearbeiten',
    '_USAGE_PREFS' => 'Auf diesem Bildschirm können Sie eine Reihe an optionalen Einstellungen zu Ihrem Blog, den Archiven, Ihren Kommentaren und den Einstellungen für Öffentlichkeit &amp; Benachrichtigung festlegen. Wenn Sie ein neues Blog erstellen, werden sinnvolle Standardwerte verwendet.',
    '_SYSTEM_TEMPLATE_COMMENT_ERROR' => '_SYSTEM_TEMPLATE_COMMENT_ERROR',
    'Rebuild Files' => 'Dateien neun veröffentlichen',

    ## Error messages, strings in the app code.

    ## ./mt-check.cgi.pre
    'CGI is required for all Movable Type application functionality.' => 'CGI ist für Movable Type zwingend erforderlich.',
    'HTML::Template is required for all Movable Type application functionality.' => 'HTML::Template ist für alle Anwendungsfunktionen von Movable Type erforderlich.',
    'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size ist für Datei-Uploads erforderlich (um die Größe der hochgeladenen Bilder in verschiedenen Formaten zu bestimmen).',
    'File::Spec is required for path manipulation across operating systems.' => 'File::Spec ist für Dateipfadänderungen unter allen Betriebssystemen erforderlich.',
    'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie ist für die Cookie-Authentifizierung erforderlich.',
    'DB_File is required if you want to use the Berkeley DB/DB_File backend.' => 'DB_File ist erforderlich, wenn Sie Berkeley DB/DB_File Backend einsetzen möchten.',
    'DBI is required if you want to use any of the SQL database drivers.' => 'DBI ist erforderlich, wenn Sie die SQL-Treiber verwenden.', 
    'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI und DBD::mysql sind erforderlich, wenn Sie eine MySQL-Datenbank einsetzen möchten.',
    'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI und DBD::Pg sind erforderlich, wenn Sie das PostgreSQL-Datenbank-Backend einsetzen möchten.',
    'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI und DBD::SQLite sind erforderlich, wenn Sie eine SQLite-Datenbank einsetzen möchten.',
    'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in mt.cfg.' => 'HTML::Entities ist zur Codierung einiger Sonderzeichen erforderlich. Diese Funktion kann jedoch mit der Option NoHTMLEntities in mt.cfg deaktiviert werden.',
    'LWP::UserAgent is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'LWP::UserAgent ist optional, und nur erforderlich, wenn Sie das TrackBack-System, den weblogs.com-Ping oder den "Kürzlich aktualisiert"-Ping von MT einsetzen möchten.',
    'SOAP::Lite is optional; It is needed if you wish to use the MT XML-RPC server implementation.' => 'SOAP::Lite ist optional, und nur erforderlich, wenn Sie die XML-RPC Server-Implementierung von MT einsetzen möchten',
    'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Temp ist optional, und nur erforderlich, wenn Sie vorhandene Dateien beim Hochladen überschreiben können möchten.',
    'Image::Magick is optional; It is needed if you would like to be able to create thumbnails of uploaded images.' => 'Image::Magick ist optional, und nur erforderlich, wenn Sie automatisch Miniaturansichten von hochgeladenen Bildern erzeugen möchten.',
    'Storable is optional; it is required by certain MT plugins available from third parties.' => 'Storable ist optional, und nur für gewisse MT-Plugins von Drittanbietern erforderlich.',
    'Crypt::DSA is optional; if it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSA ist optional. Durch die Installation wird der Anmeldevorgang für die Kommentarregistrierung beschleunigt.',
    'MIME::Base64 is required in order to enable comment registration.' => 'MIME::Base64 ist für die Aktivierung der Kommentarregistrierung erforderlich.',
    'XML::Atom is required in order to use the Atom API.' => 'XML::Atom ist für den Einsatz der Atom-API erforderlich.',
    'Data Storage' => 'Datenbank',
    'Required' => 'erforderlichen',
    'Optional' => 'optionalen',

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
    'Got an error: [_1]' => 'Got an error: [_1]',

    ## ./lib/MT/Category.pm

    ## ./lib/MT/Promise.pm

    ## ./lib/MT/App.pm
    'User \'[_1]\' (user #[_2]) logged in successfully' => 'Benutzer \'[_1]\' (Benutzer #[_2]) angemeldet',
    'Invalid login attempt from user \'[_1]\'' => 'Ungültiger Login-Versuch von Benutzer \'[_1]\'',
    'Invalid login.' => 'Ungültiger Login.',
    'User \'[_1]\' (user #[_2]) logged out' => 'Benutzer \'[_1]\' (Benutzer #[_2]) abgemeldet',
    'The file you uploaded is too large.' => 'Die hochgeladene Datei ist zu gross.',
    'Unknown action [_1]' => 'Unbekannte Aktion [_1]',
    'Loading template \'[_1]\' failed: [_2]' => 'Laden des Templates \'[_1]\' fehlgeschlagen: [_2]',

    ## ./lib/MT/Log.pm

    ## ./lib/MT/Image.pm
    'Can\'t load Image::Magick: [_1]' => 'Image::Magick kann nicht geladen werden: [_1]',
    'Reading file \'[_1]\' failed: [_2]' => 'Datei \'[_1]\' kann nicht gelesen werden: [_2]',
    'Reading image failed: [_1]' => 'Bild kann nicht geladen werden: [_1]',
    'Scaling to [_1]x[_2] failed: [_3]' => 'Skalieren auf [_1]x[_2] fehlgeschlagen: [_3]',
    'Can\'t load IPC::Run: [_1]' => 'IPC::Run kann nicht geladen werden: [_1]',
    'You do not have a valid path to the NetPBM tools on your machine.' => 'Kein gültiger Pfad auf die NetPBM-Tools auf Ihrem Computer.',

    ## ./lib/MT/Session.pm

    ## ./lib/MT/FileMgr.pm

    ## ./lib/MT/IPBanList.pm

    ## ./lib/MT/Trackback.pm

    ## ./lib/MT/Notification.pm

    ## ./lib/MT/Blocklist.pm

    ## ./lib/MT/Sanitize.pm

    ## ./lib/MT/AtomServer.pm

    ## ./lib/MT/Upgrade.pm
    'Running [_1]' => 'Running [_1]',
    'Invalid upgrade function: [_1].' => 'Invalid upgrade function: [_1].',
    'Error loading class: [_1].' => 'Error loading class: [_1].',
    'Creating initial weblog and author records...' => 'Lege erstes Weblog und Benutzer an...',
    'Error saving record: [_1].' => 'Error saving record: [_1].',
    'First Weblog' => 'Erstes Weblog',
    'Can\'t find default template list; where is \'default-templates.pl\'? Error: [_1]' => 'Can\'t find default template list; where is \'default-templates.pl\'? Error: [_1]',
    'Creating new template: \'[_1]\'.' => 'Lege neues Template an: \'[_1]\'.',
    'Mapping templates to blog archive types...' => 'Verknüpfung von Template mit Weblog-Archivierungstypen...',
    'Upgrading table for [_1]' => 'Upgrade Table [_1]',
    'Executing SQL: [_1];' => 'Executing SQL: [_1];',
    'Error during upgrade: [_1]' => 'Fehler beim Upgrade: [_1]',
    'Upgrading database from version [_1].' => 'Upgrade der Datenbank auf Version [_1].',
    'Database has been upgraded to version [_1].' => 'Databank ist nun Version [_1].',
    'Setting your permissions to administrator.' => 'Rechte auf Administrator gesetzt.',
    'Creating configuration record.' => 'Lege Configuration-Record an.',
    'Creating template maps...' => 'Lege Template-Maps an...',
    'Mapping template ID [_1] to [_2] ([_3]).' => 'Mapping Template ID [_1] auf [_2] ([_3]).',
    'Mapping template ID [_1] to [_2].' => 'Mapping Template ID [_1] auf [_2].',

    ## ./lib/MT/PluginData.pm

    ## ./lib/MT/DateTime.pm

    ## ./lib/MT/Plugin.pm

    ## ./lib/MT/Entry.pm
    'Load of blog failed: [_1]' => 'Laden des Weblogs fehlgeschlagen: [_1]',
    'Load of blog \'[_1]\' failed: [_2]' => 'Weblog \'[_1]\' konnte nicht geladen werden: [_2]',

    ## ./lib/MT/Author.pm

    ## ./lib/MT/Config.pm

    ## ./lib/MT/XMLRPC.pm
    'No WeblogsPingURL defined in mt.cfg' => 'Keine WeblogsPingURL definiert in mt.cfg',
    'No MTPingURL defined in mt.cfg' => 'Keine MTPingURL definiert in mt.cfg',
    'HTTP error: [_1]' => 'HTTP-Fehler: [_1]',
    'Ping error: [_1]' => 'Ping-Fehler: [_1]',

    ## ./lib/MT/TemplateMap.pm

    ## ./lib/MT/Template.pm
    'Parse error in template \'[_1]\': [_2]' => 'Parsing-Fehler im Template \'[_1]\': [_2]',
    'Build error in template \'[_1]\': [_2]' => 'Build-Fehler im Template \'[_1]\': [_2]',
    'You cannot use a [_1] extension for a linked file.' => 'Sie können keine [_1] Erweiterung für eine verlinkte Datei verwenden.',
    'Opening linked file \'[_1]\' failed: [_2]' => 'Öffenen von verlinkter Datei \'[_1]\' fehlgeschlagen: [_2]',

    ## ./lib/MT/ConfigMgr.pm
    'Error opening file \'[_1]\': [_2]' => 'Fehler beim Öffnen der Datei \'[_1]\': [_2]',
    'Config directive [_1] without value at [_2] line [_3]' => 'Config directive [_1] without value at [_2] line [_3]',
    'No such config variable \'[_1]\'' => 'Config-Variable \'[_1]\' unbekannt',

    ## ./lib/MT/ImportExport.pm
    'You need to provide a password if you are going to\n' => 'Passwort erforderlich, um\n',
    'Need either ImportAs or ParentAuthor' => 'Entweder ImportAs oder ParentAuthor',
    'Saving author failed: [_1]' => 'Speichern von Autor fehlgeschlagen: [_1]',
    'Saving permission failed: [_1]' => 'Speichern von Rechten fehlgeschlagen: [_1]',
    'Saving category failed: [_1]' => 'Speichern von Kategorie fehlgeschlagen: [_1]',
    'Invalid status value \'[_1]\'' => 'Kein gültiger Status-Wert \'[_1]\'',
    'Saving entry failed: [_1]' => 'Speichern von Eintrag fehlgeschlagen: [_1]',
    'Saving placement failed: [_1]' => 'Speichern von Plazierung fehlgeschlagen: [_1]',
    'Saving comment failed: [_1]' => 'Speichern von Kommentar fehlgeschlagen: [_1]',
    'Entry has no MT::Trackback object!' => 'Eintrag hat kein MT::Trackback-Objekt!',
    'Saving ping failed: [_1]' => 'Speichern von Ping fehlgeschlagen: [_1]',
    'Export failed on entry \'[_1]\': [_2]' => 'Export von \'[_1]\' fehlgeschlagen bei: [_2]',

    ## ./lib/MT/JunkFilter.pm
    'Action: Junked (score below threshold)' => 'Aktion: Junked (Score unterschreitet Grenzwert)',
    'Action: Published (default action)' => 'Aktion: Veröffentlicht (Standardaktion)',
    'Junk Filter [_1] died with: [_2]' => 'Junk-Filter [_1] died with: [_2]',
    'Unnamed Junk Filter' => 'Junk Filter ohne Namen',
    'Composite score: [_1]' => 'Gesamt-Score: [_1]',

    ## ./lib/MT/ObjectDriver.pm

    ## ./lib/MT/Mail.pm
    'Unknown MailTransfer method \'[_1]\'' => 'Unknown MailTransfer method \'[_1]\'',
    'Sending mail via SMTP requires that your server ' => 'Sending mail via SMTP requires that your server ',
    'Error sending mail: [_1]' => 'Fehler beim Versenden von Mail: [_1]',
    'You do not have a valid path to sendmail on your machine. ' => 'Kein gültiger Pfad zu sendmail auf dem Computer. ',
    'Exec of sendmail failed: [_1]' => 'Exec von sendmail fehlgeschlagen: [_1]',

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
    'Archive type \'[_1]\' is not a chosen archive type' => 'Archive type \'[_1]\' is not a chosen archive type',
    'Parameter \'[_1]\' is required' => 'Parameter \'[_1]\' is required',
    'Building category archives, but no category provided.' => 'Building category archives, but no category provided.',
    'You did not set your Local Archive Path' => 'You did not set your Local Archive Path',
    'Building category \'[_1]\' failed: [_2]' => 'Building category \'[_1]\' failed: [_2]',
    'Building entry \'[_1]\' failed: [_2]' => 'Building entry \'[_1]\' failed: [_2]',
    'Building date-based archive \'[_1]\' failed: [_2]' => 'Building date-based archive \'[_1]\' failed: [_2]',
    'You did not set your Local Site Path' => 'You did not set your Local Site Path',
    'Template \'[_1]\' does not have an Output File.' => 'Template \'[_1]\' hat keine Output-Datei.',

    ## ./lib/MT/Atom.pm

    ## ./lib/MT/Comment.pm
    'Load of entry \'[_1]\' failed: [_2]' => 'Load of entry \'[_1]\' failed: [_2]',

    ## ./lib/MT/L10N.pm

    ## ./lib/MT/Util.pm
    'Less than 1 minute from now' => 'In weniger als 1 Minute',
    'Less than 1 minute ago' => 'Vor weniger als 1 Minute',
    '[quant,_1,hour], [quant,_2,minute] from now' => 'In [quant,_1,Stunde,Stunden], [quant,_2,Minute,Minuten]',
    '[quant,_1,hour], [quant,_2,minute] ago' => 'Vor [quant,_1,Stunde,Stunden], [quant,_2,Minute,Minuten]',
    '[quant,_1,hour] from now' => 'In [quant,_1,Stunde,Stunden]',
    '[quant,_1,hour] ago' => 'Vor [quant,_1,Stunde,Stunden]',
    '[quant,_1,minute] from now' => 'In [quant,_1,Minute,Minuten]',
    '[quant,_1,minute] ago' => 'Vor [quant,_1,Minute,Minuten]',
    '[quant,_1,day], [quant,_2,hour] from now' => 'In [quant,_1,Tag,Tagen], [quant,_2,Stunde,Stunden]',
    '[quant,_1,day], [quant,_2,hour] ago' => 'Vor [quant,_1,Tag,Tagen], [quant,_2,Stunde,Stunden] ',
    '[quant,_1,day] from now' => 'In [quant,_1,Tag,Tagen]',
    '[quant,_1,day] ago' => 'Vor [quant,_1,Tag]',
    'Invalid Archive Type setting \'[_1]\'' => 'Ingültige Konfiguration des Archiv-Typs \'[_1]\'',

    ## ./lib/MT/BasicSession.pm

    ## ./lib/MT/ObjectDriver/DBI.pm

    ## ./lib/MT/ObjectDriver/DBM.pm
    'Your DataSource directory (\'[_1]\') does not exist.' => 'Das DataSource Verzeichnis (\'[_1]\') existiert nicht.',
    'Your DataSource directory (\'[_1]\') is not writable.' => 'Your DataSource directory (\'[_1]\') is not writable.',
    'Tie \'[_1]\' failed: [_2]' => 'Tie \'[_1]\' failed: [_2]',
    'Failed to generate unique ID: [_1]' => 'Failed to generate unique ID: [_1]',
    'Unlink of \'[_1]\' failed: [_2]' => 'Unlink of \'[_1]\' failed: [_2]',

    ## ./lib/MT/ObjectDriver/DBI/mysql.pm
    'Connection error: [_1]' => 'Connection error: [_1]',

    ## ./lib/MT/ObjectDriver/DBI/postgres.pm

    ## ./lib/MT/ObjectDriver/DBI/sqlite.pm
    'Can\'t open \'[_1]\': [_2]' => 'Can\'t open \'[_1]\': [_2]',
    'Your database file (\'[_1]\') is not writable.' => 'Your database file (\'[_1]\') is not writable.',
    'Your database directory (\'[_1]\') is not writable.' => 'Your database directory (\'[_1]\') is not writable.',

    ## ./lib/MT/FileMgr/FTP.pm

    ## ./lib/MT/FileMgr/DAV.pm

    ## ./lib/MT/FileMgr/Local.pm
    'Opening local file \'[_1]\' failed: [_2]' => 'Opening local file \'[_1]\' failed: [_2]',
    'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Umbenennen von \'[_1]\' auf \'[_2]\' fehlgeschlagen: [_3]',

    ## ./lib/MT/FileMgr/SFTP.pm

    ## ./lib/MT/Template/Context.pm

    ## ./lib/MT/Template/ContextHandlers.pm
    'Can\'t find included template module \'[_1]\'' => 'Can\'t find included template module \'[_1]\'',
    'Can\'t find included file \'[_1]\'' => 'Can\'t find included file \'[_1]\'',
    'Error opening included file \'[_1]\': [_2]' => 'Error opening included file \'[_1]\': [_2]',
    'Can\'t find template \'[_1]\'' => 'Can\'t find template \'[_1]\'',
    'Can\'t find entry \'[_1]\'' => 'Can\'t find entry \'[_1]\'',
    'You used a [_1] tag without any arguments.' => 'You used a [_1] tag without any arguments.',
    'No such category \'[_1]\'' => 'Keine Kategorie \'[_1]\'',
    'You can\'t use both AND and OR in the same expression ([_1]).' => 'You can\'t use both AND and OR in the same expression ([_1]).',
    'No such author \'[_1]\'' => 'Kein Autor \'[_1]\'',
    'You used an \'[_1]\' tag outside of the context of an entry; ' => 'Sie haben ein \'[_1]\' Tag ausserhalb eines Eintrags verwendet; ',
    'You used <$MTEntryFlag$> without a flag.' => 'You used <$MTEntryFlag$> without a flag.',
    'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.',
    'To enable comment registration, you ' => 'Um Kommetar-Registrierung zu aktivieren, müssen Sie ',
    '(You may use HTML tags for style)' => '(HTML-Tags sind gestattet)',
    'You used an [_1] tag without a date context set up.' => 'You used an [_1] tag without a date context set up.',
    'You used an \'[_1]\' tag outside of the context of a comment; ' => 'You used an \'[_1]\' tag outside of the context of a comment; ',
    'You used an [_1] without a date context set up.' => 'You used an [_1] without a date context set up.',
    '[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] kann nur mit täglichen, wöchentlichen oder monatlichen Archiven verwendet werden.',
    'You used an [_1] tag outside of the proper context.' => 'Das [_1] Tag wird in einem falschen Zusammenhang verwendet.',
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly ' => 'You used an [_1] tag outside of a Daily, Weekly, or Monthly ',
    'Invalid month format: must be YYYYMM' => 'Ungültiges Datumsformat: richtig ist JJJJMM',
    '[_1] can be used only if you have enabled Category archives.' => '[_1] kann nur bei aktiven Kategorie-Archiven verwendet werden.',
    'You used [_1] without a query.' => 'You used [_1] without a query.',
    'You need a Google API key to use [_1]' => 'Du benötigst einen Google-API-Key, um [_1] zu verwenden',
    'You used a non-existent property from the result structure.' => 'You used a non-existent property from the result structure.',

    ## ./lib/MT/App/NotifyList.pm
    'Please enter a valid email address.' => 'Bitte geben Sie eine gültige Email-Adresse an.',
    'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Missing required parameter: blog_id. Please consult the user manual to configure notifications.',
    'Email notifications have not been configured! The weblog owner needs to set the EmailVerificationSecret configuration variable in mt.cfg.' => 'Email-Benachrichtungen wurden nicht konfiguriert! Sie müssen EmailVerificationSecret in mt.cfg konfigurieren.',
    'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.',
    'The email address \'[_1]\' is already in the notification list for this weblog.' => 'Die Email-Adresse \'[_1]\' ist bereits in der Benachrichtigunsliste für dieses Weblog.',

    ## ./lib/MT/App/Trackback.pm
    'Invalid entry ID \'[_1]\'' => 'Ungültige Eintrags-ID \'[_1]\'',
    'You must define a Ping template in order to display pings.' => 'Du musst ein Ping-Template definieren, um Pings anzuzeigen.',
    'Trackback pings must use HTTP POST' => 'Trackback pings must use HTTP POST',
    'Need a TrackBack ID (tb_id).' => 'Benötige TrackBack ID (tb_id).',
    'Invalid TrackBack ID \'[_1]\'' => 'Ungültige TrackBack-ID \'[_1]\'',
    'You are not allowed to send TrackBack pings.' => 'Sie dürfen keine TrackBack-Pings senden.',
    'You are pinging trackbacks too quickly. Please try again later.' => 'Sie senden zu viele TrackBacks zu schnell hintereinander.',
    'Need a Source URL (url).' => 'Need a Source URL (url).',
    'Invalid URL \'[_1]\'' => 'Ungültige URL \'[_1]\'',
    'This TrackBack item is disabled.' => 'TrackBack hier nicht aktiv.',
    'This TrackBack item is protected by a passphrase.' => 'Dieser TrackBack-Eintrag ist passwortgeschützt.',
    'Rebuild failed: [_1]' => 'Rebuild fehlgeschlagen: [_1]',
    'Can\'t create RSS feed \'[_1]\': ' => 'RSS-Feed kann nicht angelegt werden \'[_1]\': ',
    'New TrackBack Ping to Entry [_1] ([_2])' => 'Neuer TrackBack-Ping bei Eintrag [_1] ([_2])',
    'New TrackBack Ping to Category [_1] ([_2])' => 'Neuer TrackBack-Ping bei Kategorie [_1] ([_2])',

    ## ./lib/MT/App/Comments.pm
    'IP Banned Due to Excessive Comments' => 'IP gesperrt - zu viele Kommentare',
    'No such entry \'[_1]\'.' => 'Kein Eintrag \'[_1]\'.',
    'You are not allowed to post comments.' => 'Kommentare sind nicht erlaubt.',
    'Comments are not allowed on this entry.' => 'Bei diesem Eintrag sind Kommentare nicht erlaubt.',
    'Comment text is required.' => 'Kommentartext ist Pflichtfeld.',
    'Registration is required.' => 'Registrierung ist erforderlich.',
    'Name and email address are required.' => 'Name und Email sind Pflichtfelder.',
    'Invalid email address \'[_1]\'' => 'Ungültige Email-Adresse \'[_1]\'',
    'New Comment Posted to \'[_1]\'' => 'Neuer Kommentar bei \'[_1]\'',
    'No public key could be found to validate registration.' => 'Kein Public-Key gefunden, um Registrierung zu validieren.',
    'Sign in requires a secure signature; logout requires the logout=1 parameter' => 'Sign in requires a secure signature; logout requires the logout=1 parameter',
    'The sign-in attempt was not successful; please try again.' => 'Sign-in war nicht erfolgreich; bitte erneut versuchen.',
    'The sign-in validation was not successful. Please make sure your weblog is properly configured and try again.' => 'Validierung des Sign-ins war nicht erfolgreich. Bitte Konfiguration überprüfen und erneut versuchen.',
    'No such entry ID \'[_1]\'' => 'Keine Eintrags-ID \'[_1]\'',
    'You must define an Individual template in order to ' => 'You must define an Individual template in order to ',
    'You must define a Comment Listing template in order to ' => 'You must define a Comment Listing template in order to ',
    'No entry was specified; perhaps there is a template problem?' => 'Es wurde kein Eintrag spezifiziert. Vielleicht gibt es ein Problem mit dem Template?',
    'Somehow, the entry you tried to comment on does not exist' => 'Der Eintrag, den Sie kommentieren möchten, existiert nicht.',
    'You must define a Comment Pending template.' => 'Sie müssen ein Template definieren für Kommentarmoderation.',
    'You must define a Comment Error template.' => 'Sie müssen ein Template definieren für Kommentarfehler.',
    'You must define a Comment Preview template.' => 'Sie müssen ein Template definieren für Kommentarvorschau.',

    ## ./lib/MT/App/Search.pm
    'You are currently performing a search. Please wait ' => 'Eine Suche ist bereits aktiv. Bitte warten ',
    'Search failed: [_1]' => 'Suche fehlgeschlagen: [_1]',
    'Building results failed: [_1]' => 'Building results failed: [_1]',
    'Search: query for \'[_1]\'' => 'Search: query for \'[_1]\'',

    ## ./lib/MT/App/Upgrader.pm
    'Invalid session.' => 'Ungültige Session.',
    'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Bitte kontaktieren Sie Ihren Administrator, um das Upgrade von Movable Type durchzuführe. Sie haben nicht die erforderlichen Rechte.',

    ## ./lib/MT/App/Viewer.pm

    ## ./lib/MT/App/CMS.pm
    'Convert Line Breaks' => 'Zeilenumbrüche konvertieren',
    'Password Recovery' => 'Passwort wird wiederhergestellt',
    'Invalid author name \'[_1]\' in password recovery attempt' => 'Invalid author name \'[_1]\' in password recovery attempt',
    'Author name or birthplace is incorrect.' => 'Der Benutzername oder der Geburtsort ist nicht korrekt.',
    'Author has not set birthplace; cannot recover password' => 'Geburtsort nicht angegeben; Passwort kann nicht versendet werden',
    'Invalid attempt to recover password (used birthplace \'[_1]\')' => 'Ungültiger Versuch, das Passwort anzufordern (Geburtsort \'[_1]\')',
    'Author does not have email address' => 'Autor hat keine Email-Adressse',
    'Password was reset for author \'[_1]\' (user #[_2])' => 'Passwort zurückgesetzt für Benutzer \'[_1]\' (Benutzer #[_2])',
    'Error sending mail ([_1]); please fix the problem, then ' => 'Error sending mail ([_1]); please fix the problem, then ',
    'You are not authorized to log in to this blog.' => 'Kein Zugang zu diesem Weblog.',
    'No such blog [_1]' => 'Kein Weblog [_1]',
    'Permission denied.' => 'Keine Berechtigung.',
    'log records' => 'log records',
    'Application log for blog \'[_1]\' reset by \'[_2]\' (user #[_3])' => 'Protokoll von Weblog \'[_1]\' zurückgesetzt von \'[_2]\' (Benutzer #[_3])',
    'Application log reset by \'[_1]\' (user #[_2])' => 'Protokoll zurückgesetzt von \'[_1]\' (Benutzer #[_2])',
    'Import/Export' => 'Import/Export',
    'No permissions' => 'Keine Berechtigung',
    'Permission denied. ' => 'Permission denied. ',
    'Load failed: [_1]' => 'Laden fehlgeschlagen: [_1]',
    '(untitled)' => '(ohne Überschrift)',
    'Create template requires type' => 'Create template requires type',
    'New Template' => 'Neues Template',
    'New Weblog' => 'Neues Weblog',
    'Author requires username' => 'Autor erfordert Benutzername',
    'Author requires password' => 'Autor erfodert Benutzername', 
    'Author requires password hint' => 'Autor erfodert Passwort-Erinnerungsfrage',
    'Email Address is required for password recovery' => 'Email-Adresse bei Passwort-Anfrage erforderlich',
    'The value you entered was not a valid email address' => 'Die Eingabe ist keine gültige Email-Adresse',
    'The e-mail address you entered is already on the Notification List for this weblog.' => 'Diese Email-Adresse ist bereits in der Benachrichtigungsliste für dieses Weblog.',
    'You did not enter an IP address to ban.' => 'Keine IP-Adresse angegeben.',
    'The IP you entered is already banned for this weblog.' => 'Die IP-Adresse wird bereits gesperrt.',
    'You did not specify a weblog name.' => 'Kein Weblog-Name angegeben.',
    'Site URL must be an absolute URL.' => 'Site-URL muß absolute URL sein.',
    'There is already a weblog by that name!' => 'Es besteht bereits ein Weblog mit diesem Namen!',
    'The name \'[_1]\' is too long!' => 'Der Name \'[_1]\' ist zu lang!',
    'No categories with the same name can have the same parent' => 'Kategorien mit dem selben Namen können nicht parallel bestehen',
    'Can\'t find default template list; where is ' => 'Can\'t find default template list; where is ',
    'Populating blog with default templates failed: [_1]' => 'Standard-Templates konnten nicht geladen werden: [_1]',
    'Setting up mappings failed: [_1]' => 'Setting up mappings failed: [_1]',
    'Weblog \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' angeleget von \'[_2]\' (Benutzer #[_3])',
    'Passwords do not match.' => 'Passwörter stimmen nicht überein.',
    'Failed to verify current password.' => 'Kann Passwort nicht überprüfen.',
    'Password hint is required.' => 'Passwort-Erinnerung ist erforderlich.',
    'An author by that name already exists.' => 'Ein Autor mit diesem Benutzernamen besteht bereits.',
    'Saving object failed: [_1]' => 'Speichern des Objekts fehlgeschlagen: [_1]',
    'No Name' => 'Kein Name',
    'Notification List' => 'Mitteilungssliste',
    'email addresses' => 'Email-Adressen',
    'IP addresses' => 'IP-Adressen',
    'Can\'t delete that way' => 'Can\'t delete that way',
    'Your login session has expired.' => 'Ihre Login-Session ist abgelaufen.',
    'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => 'Solange die Kategorie Unterkategorien hat, können Sie die Kategorie nicht löschen.',
    'Weblog \'[_1]\' deleted by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' gelöscht von \'[_2]\' (Benutzer #[_3])',
    'Unknown object type [_1]' => 'Unknown object type [_1]',
    'Loading object driver [_1] failed: [_2]' => 'Loading object driver [_1] failed: [_2]',
    'Invalid filename \'[_1]\'' => 'Invalid filename \'[_1]\'',
    'Reading \'[_1]\' failed: [_2]' => 'Reading \'[_1]\' failed: [_2]',
    'Thumbnail failed: [_1]' => 'Thumbnail fehlgeschlagen: [_1]',
    'Error writing to \'[_1]\': [_2]' => 'Error writing to \'[_1]\': [_2]',
    'Invalid basename \'[_1]\'' => 'Ungültiger Basename \'[_1]\'',
    'No such commenter [_1].' => 'Kein Kommentator [_1].',
    'Need a status to update entries' => 'Need a status to update entries',
    'Need entries to update status' => 'Need entries to update status',
    'One of the entries ([_1]) did not actually exist' => 'One of the entries ([_1]) did not actually exist',
    'Some entries failed to save' => 'Some entries failed to save',
    'You don\'t have permission to approve this TrackBack.' => 'Sie dürfen TrackBack nicht freischalten.',
    'You don\'t have permission to approve this comment.' => 'Diesen Kommentar dürfen Sie nicht freigeben.',
    'Orphaned comment' => 'Verwaister Kommentar',
    'Plugin Set: [_1]' => 'Plugin Set: [_1]',
    'No Excerpt' => 'Kein Auzzug',
    'No Title' => 'Keine Überschrift',
    'Orphaned TrackBack' => 'Verwaistes TrackBack',
    'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Datum \'[_1]\' ungültig; erforderliches Formst ist JJJJ-MM-TT SS:MM:SS.',
    'Saving entry \'[_1]\' failed: [_2]' => 'Speichern des Eintrags \'[_1]\' fehlgeschlagen: [_2]',
    'Removing placement failed: [_1]' => 'Removing placement failed: [_1]',
    'No such entry.' => 'Kein Eintrag.',
    'Your weblog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Sie haben noch keinen Site-Path und Site-URL konfiguriert. Sie können Einträge erst veröffentlichen, wenn Sie diese Einstellungen vorgenommen haben.',
    'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Ungültiges Datum \'[_1]\'; das Datum muss existieren.',
    '\'[_1]\' (user #[_2]) added entry #[_3]' => '\'[_1]\' (Benutzer #[_2]) veröffentlicht Eintrag #[_3]',
    'The category must be given a name!' => 'Die Kategorie muss einen Namen haben!',
    'yyyy/mm/entry_basename' => 'jjjj/mm/eintrag_basename',
    'yyyy/mm/entry_basename/' => 'jjjj/mm/eintrag_basename/',
    'yyyy/mm/dd/entry_basename' => 'jjjj/mm/tt/eintrag_basename',
    'yyyy/mm/dd/entry_basename/' => 'jjjj/mm/tt/eintrag_basename/',
    'category/sub_category/entry_basename' => 'kategorie/unterkategorie/eintrag_basename',
    'category/sub_category/entry_basename/' => 'kategorie/unterkategorie/eintrag_basename/',
    'category/sub-category/entry_basename' => 'kategorie/unterkategorie/entry_basename',
    'category/sub-category/entry_basename/' => 'kategorie/unterkategorie/entry_basename/',
    'primary_category/entry_basename' => 'hauptkategorie/eintrag_basename',
    'primary_category/entry_basename/' => 'hauptkategorie/eintrag_basename/',
    'primary-category/entry_basename' => 'hauptkategorie/eintrag_basename',
    'primary-category/entry_basename/' => 'hauptkategorie/eintrag_basename/',
    'yyyy/mm/' => 'jjjj/mm/',
    'yyyy_mm' => 'jjjj_mm',
    'yyyy/mm/dd/' => 'jjjj/mm/tt/',
    'yyyy_mm_dd' => 'jjjj_mm_tt',
    'yyyy/mm/dd-week/' => 'jjjj/mm/tt-woche/',
    'week_yyyy_mm_dd' => 'woche_jjjj_mm_tt',
    'category/sub_category/' => 'kategorie/unterkategorie/',
    'category/sub-category/' => 'kategorie/unterkategorie/',
    'cat_category' => 'cat_kategorie',
    'Saving blog failed: [_1]' => 'Speichern des Weblogs fehlgeschlagen: [_1]',
    'You do not have permission to configure the blog' => 'Sie haben nicht die Berechtigung, die Konfiguration zu ändern',
    'Saving map failed: [_1]' => 'Saving map failed: [_1]',
    'Parse error: [_1]' => 'Parse error: [_1]',
    'Build error: [_1]' => 'Build error: [_1]',
    'index template \'' => 'Index-Template \'',
    'entry \'' => 'Eintrag \'',
    'Ping \'[_1]\' failed: [_2]' => 'Ping \'[_1]\' fehlgeschlagen: [_2]',
    'Edit Permissions' => 'Rechte bearbeiten',
    'No entry ID provided' => 'Keine Eintrags-ID angegeben',
    'No such entry \'[_1]\'' => 'Kein Eintrag \'[_1]\'',
    'No email address for author \'[_1]\'' => 'Keine Email-Addresse für Autor \'[_1]\'',
    '[_1] Update: [_2]' => '[_1] Update: [_2]',
    'Error sending mail ([_1]); try another MailTransfer setting?' => 'Error sending mail ([_1]); try another MailTransfer setting?',
    'You did not choose a file to upload.' => 'Bitte wählen Sie eine Datei aus.',
    'Invalid extra path \'[_1]\'' => 'Invalid extra path \'[_1]\'',
    'Can\'t make path \'[_1]\': [_2]' => 'Can\'t make path \'[_1]\': [_2]',
    'Invalid temp file name \'[_1]\'' => 'Invalid temp file name \'[_1]\'',
    'Error opening \'[_1]\': [_2]' => 'Fehler beim Öffnen von \'[_1]\': [_2]',
    'Error deleting \'[_1]\': [_2]' => 'Fehler beim Löschen von \'[_1]\': [_2]',
    'File with name \'[_1]\' already exists. (Install ' => 'Datei mit dem Namen \'[_1]\' bereits vorhanden. (Installiern SIe ',
    'Error creating temporary file; please check your TempDir ' => 'Error creating temporary file; please check your TempDir ',
    'unassigned' => 'nicht vergeben',
    'File with name \'[_1]\' already exists; Tried to write ' => 'File with name \'[_1]\' already exists; Tried to write ',
    'Error writing upload to \'[_1]\': [_2]' => 'Error writing upload to \'[_1]\': [_2]',
    'Perl module Image::Size is required to determine ' => 'Perl module Image::Size is required to determine ',
    'Saving object failed: [_2]' => 'Saving object failed: [_2]',
    'Search & Replace' => 'Suchen & Ersetzen',
    'No blog ID' => 'Keine Weblog-ID',
    'You do not have export permissions' => 'Du hast keine Export-Rechte',
    'You do not have import permissions' => 'Du hast keine Import-Rechte',
    'You do not have permission to create authors' => 'Sie haben nicht das Recht, neue Autoren anzulegen',
    'Can\'t open directory \'[_1]\': [_2]' => 'Kann Verzeichnis \'[_1]\' nicht öffnen: [_2]',
    'No readable files could be found in your import directory [_1].' => 'No readable files could be found in your import directory [_1].',
    'Importing entries from file \'[_1]\'' => 'Importieren der Einträge aus Datei \'[_1]\'',
    'Can\'t open file \'[_1]\': [_2]' => 'Kann Datei \'[_1]\' nicht öffnen: [_2]',
    'Creating new author (\'' => 'Erstelle neuen Autor (\'',
    'ok\n' => 'ok\n',
    'failed\n' => 'fehlgeschlagen\n',
    'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Ungültiges Datumsformat \'[_1]\'; Format ist \'MM/TT/JJJJ SS:MM:SS AM|PM\' (AM|PM is optional)',
    'Preferences' => 'Einstellungen',
    'Saving permissions failed: [_1]' => 'Speichern von Rechten fehlgeschlagen: [_1]',
    'Add a Category' => 'Kategorie hinzufügen',
    'Category name cannot be blank.' => 'Der Name einer Kategorie darf nicht leer sein.',
    'That action ([_1]) is apparently not implemented!' => 'That action ([_1]) is apparently not implemented!',

    ## ./lib/MT/Plugin/JunkFilter.pm
    'from rule' => 'aus Regel',
    'from test' => 'aus Test',

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
    'You did not select any [_1] to delete.' => 'Sie haben keine(n) [_1] zum Löschen gewählt.',
    'Are you sure you want to delete this [_1]?' => '[_1] wirklich löschen?',
    'Are you sure you want to delete the [_1] selected [_2]?' => 'Die [_1] [_2] wirklich löschen?',
    'to delete' => 'zum Löschen',
    'You did not select any [_1] [_2].' => 'Sie haben keine [_1] [_2] gewählt.',
    'You must select an action.' => 'Sie müssen eine Aktion wählen.',
    'to mark as junk' => 'zum Junk markieren',
    'to remove "junk" status' => 'zum "Junk"-Status zurücksetzen',
    'Enter email address:' => 'Email-Adresse eingeben:',
    'Enter URL:' => 'URL eingeben:',

    ## ./extras/examples/plugins/mirror/lib/Mirror.pm
    
    '_SYSTEM_TEMPLATE_COMMENT_PREVIEW' => 'Wird verwendet, wenn ein Kommentator eine Kommentarvorschau anzeigt.',
    '_SYSTEM_TEMPLATE_COMMENT_PENDING' => 'Wird verwendet, wenn ein Kommentar nicht sofort veröffentlicht wird.',
    '_SYSTEM_TEMPLATE_COMMENT_ERROR' => 'Wird verwendet, wenn ein Kommentar nicht sofort validiert werden kan.',
    '_SYSTEM_TEMPLATE_POPUP_IMAGE' => 'Wird verwendet, wenn auf ein Popup Bild geklickt wird.',
    '_SYSTEM_TEMPLATE_COMMENTS' => 'Wird verwendet, wenn Kommentar-Popups eingesetzt werden (auslaufend).',
    '_SYSTEM_TEMPLATE_DYNAMIC_ERROR' => 'Wird verwendet, wenn es beim dynamischen Aufbau einer Seite zu einem Fehler kommt.',
    '_SYSTEM_TEMPLATE_PINGS' => 'Wird verwendet, wenn TrackBack-Popups eingesetzt werden (auslaufend).',

    '_ERROR_CONFIG_FILE' => 'Ihre Movable Type Konfigurationsdatei fehlt oder kann nicht gelesen werden. Bitte lesen Sie die Movable Type Dokumention: <a href="#">Installation and Configuration</a>.',
    '_ERROR_DATABASE_CONNECTION' => 'Ihre Datenbankkonfiguration ist fehlerhaft. Bitte lesen Sie die Movable Type Dokumention: <a href="#">Installation and Configuration</a>.',
    '_ERROR_CGI_PATH' => 'Ihre CGIPath-Konfiguration fehlt oder ist fehlerhaft. Bitte lesen Sie die Movable Type Dokumention: <a href="#">Installation and Configuration</a>.',
    '_USAGE_REBUILD' => '<a href="#" onclick="doRebuild()">NEU VERÖFFENTLICHEN</a>, damit die Änderungen sichtbar werden.',
    '_USAGE_VIEW_LOG' => 'Überprüfen Sie das <a href="[_1]">Aktivitätsprotokoll</a>, um den Fehler zu finden.',

    '_USAGE_FORGOT_PASSWORD_1' => 'Sie haben ein neues Movable Type Passwort angefordert. Ihr Passwort wurde automatisch geändert; das neue Passwort lautet:',
    '_USAGE_FORGOT_PASSWORD_2' => 'Mit diesem Passwort können Sie sich nun am System anmelden. Danach können Sie das Passwort ändern.',

    '_USAGE_BOOKMARKLET_1' => 'Wenn Sie QuickPost einrichten, können Sie einfach neue Einträge veröffentlichen, ohne direkt in Movable Type zu arbeiten.',
    '_USAGE_BOOKMARKLET_2' => 'Sie können die Bestandteile von QuickPost frei konfigurieren. Sie können die Schaltflächen aktivieren, die Sie häufig verwenden.',
    '_USAGE_BOOKMARKLET_3' => 'Um das QuickPost-Lesezeichen zu installieren, ziehen Sie den folgenden Link in Ihr Browsermenü oder auf die Symbolleiste der Favoriten:',
    '_USAGE_BOOKMARKLET_4' => 'Nachdem Sie das QuickPost-Lesezeichen installiert haben, können Sie jederzeit einen Eintrag veröffentlichen. Klicken Sie auf den QuickPost-Link und verwenden Sie das Popup-Fenster, um einen Eintrag zu schreiben und zu veröffentlichen.',
    '_USAGE_BOOKMARKLET_5' => 'Falls Sie unter Windows mit dem Internet Explorer arbeiten, können Sie die Option "QuickPost" zum Kontextmenü von Windows hinzufügen. Klicken Sie auf den nachfolgenden Link, um die Eingabeaufforderung des Browsers zum öffnen der Datei zu akzeptieren. Beenden Sie das Programm, und starten Sie den Browser erneut, um den Link zum Kontextmenü hinzuzufügen.',

    '_USAGE_ARCHIVING_1' => 'Wählen Sie die Archivtypen aus, die Sie für Ihr Weblog verwenden möchten. Sie können für jeden Archivtypen optional mehrere Archivtemplates verwenden.', 
    '_USAGE_ARCHIVING_2' => 'Sie können jedes Archivtemplate in Ihren Template-Einstellungen konfigurieren.',
    '_USAGE_ARCHIVING_3' => 'Wählen Sie den Archivtypen und ordnen Sie dann ein Archivtemplate zu.',

    '_USAGE_BANLIST' => 'Hier können Sie IP-Adressen dafür sperren, daß Kommentare abgegeben oder TrackBack-Pings an Ihr Weblog gesendet werden. Sie können der Sperrliste sowohl neue IP-Adressen hinzufügen oder gesperret IP-Adressen wieder löschen.',

    '_USAGE_PREFS' => 'Hier können Sie eine Anzahl von optionalen Einstellungen für Ihr Weblog, Ihre Archive und Kommentare, Ihre Feeds und für Benachrichtigungen vornehmen. Wenn Sie ein neues Weblog anlegen, werden diese Werte auf gängige Standardwerte gesetzt.',

    '_USAGE_FEEDBACK_PREFS' => 'Hier können Sie festlegen, ob und wie Feedback von Kommentatoren und TrackBacks auf Ihrem Weblog angezeigt wird.',

    '_USAGE_PROFILE' => 'Hier bearbeiten Sie Ihr Autorenprofil. Wenn Sie Ihren Benutzernamen und Ihr Passwort ändern, werden die Login-Informationen sofort aktualisiert, und Sie müssen sich nicht erneut anmelden.',
    '_USAGE_NEW_AUTHOR' => 'Hier können Sie einen neuen Autoren anlegen und einem oder mehreren Weblogs zuordnen.',

    '_USAGE_CATEGORIES' => 'Verwenden Sie Kategorien, um Einträge bestimmten Themen zuzuordnen oder Ihr Weblog zu ordnen. Sie können einen Eintrag einer Kategorie zuordnen, wenn Sie den Eintrag schreiben oder wenn Sie nachträglich bearbeiten. Sie können auch Unterkategorien verwenden und Kategorien verschieben.',

    '_USAGE_COMMENT' => 'Bearbeiten Sie den Kommentar. Speichern Sie die Änderungen, wenn Sie fertig sind. Um die Änderungen zu sehen, müssen Sie den Eintrag neu veröffentlichen.',

    '_USAGE_PERMISSIONS_1' => 'Sie bearbeiten die Autorenrechte von <b>[_1]</b>. Unten sehen Sie eine Liste der Weblogs, für die Sie Autorenrechte vergeben dürfen. Wählen Sie ein Weblog aus und vergeben Sie die entsprechenden Rechte für <b>[_1]</b>.',
    '_USAGE_PERMISSIONS_2' => 'Um einen anderen Autoren zu bearbeiten, wählen Sie den entsprechenden Autoren aus dem Menü aus.',
    '_USAGE_PERMISSIONS_3' => 'Sie können entweder einen Autoren aus dem Menü auswählen oder die komplette Liste aller Autoren ansehen und dann Autoren auswählen.',
    '_USAGE_PERMISSIONS_4' => 'Jedes Weblog kann mehrere Autoren haben. So können jedem Weblog Autoren hinzufügen. Legen Sie einen neuen Autoren an und vergeben Sie dann die benötigten Rechte.',

    '_USAGE_PLACEMENTS' => 'Verwenden Sie die untenstehenden Optionen, um die sekundären Kategorien zu bearbeiten, denen dieser Eintrag zugeordnet ist. Die linke Liste zeigt alle Kategorien an, denen der Eintrag noch nicht zugeordnet ist. Die rechte Liste zeigt die Kategorien an, denen der Eintrag bereits zugordnet ist.',

    '_USAGE_ENTRYPREFS' => 'Die Feldkonfiguration legt fest, welche Felder in Ihrer Eingabemaske für neue Einträge erscheinen. Sie könnnen die vordefinierten Einstellungen verwenden (Einfach oder Erweitert) oder die Felder frei auswählen.',

    '_USAGE_IMPORT' => 'Mit dem Mechanismus zum Importieren von Einträgen können Sie Einträge aus einem anderen Weblog-System importieren. Dass Handbuch enthält ausführliche Anweisungen zum Importieren.',
    '_USAGE_EXPORT_1' => 'Indem Sie Einträge aus Movable Type exportieren, erhalten Sie <b>persönliche Sicherungen</b> Ihrer Weblog-Einträge. Die Daten werden in einem Format exportiert, in dem sie jederzeit zurück in das System importiert werden können. Das Exportieren von Einträgen dient nicht nur der Sicherung, Sie können damit auch <b>Inhalte zwischen Weblogs verschieben</b>.',
    '_USAGE_EXPORT_2' => 'Um Ihre Einträge zu exportieren, klicken Sie auf den folgenden Link ("Einträge exportieren von [_1]"). Um die exportierten Daten in einer Datei zu speichern, klicken Sie auf den Link, whrend Sie <code>Option</code> auf dem Macintosh bzw. <code>Umschalt</code> auf dem PC gedrückt halten. Sie können auch sämtliche Daten auswählen und sie in ein anderes Dokument kopieren. (<a href="#" onclick="openManual(\'importing\', \'export_ie\');return false;">Exportieren aus dem Internet Explorer?</a>)',
    '_USAGE_EXPORT_3' => 'Durch Klicken auf den nachfolgenden Link werden alle aktuellen Weblog-Einträge exportiert. In der Regel ist das übertragen der Einträge ein einmaliger Vorgang. Sie können den Vorgang aber jederzeit wiederholen.',

    '_USAGE_AUTHORS' => 'Eine Liste aller Benutzer im Movable Type-System. Sie können die Berechtigungen eines Autors bearbeiten, indem Sie auf dessen Namen klicken. Wenn Sie das Kontrollkästchen <b>löschen</b> aktivieren und anschließend auf LöSCHEN klicken, werden Autoren dauerhaft gelöscht. HINWEIS: Wenn Sie einen Autor lediglich aus einem bestimmmten Blog entfernen möchten, bearbeiten Sie die Berechtigungen des Autors, um ihn zu entfernen. Beim löschen von Autoren unter Verwendung von LöSCHEN werden Autoren komplett aus dem System entfernt.',

    '_USAGE_PLUGINS' => 'Eine Liste aller Plugins, die derzeit im System registriert sind.',

    '_USAGE_LIST_POWER' => 'Eine Liste der Einträge in [_1] im Stapelverarbeitungsmodus. Im nachfolgenden Formular können Sie alle Werte für jeden angezeigten Eintrag ändern. Klicken Sie auf die Schaltfläche SPEICHERN, nachdem Sie die gewünschten Änderungen vorgenommen haben. Die standardmäßigen Steuerelemente für "Einträge auflisten &amp; bearbeiten" (Filter, Paging) arbeiten im Stapelverarbeitungsmodus, wie Sie es gewöhnt sind.',

    '_USAGE_LIST' => 'Eine Liste der Einträge in [_1], die Sie filtern, verwalten und bearbeiten können.',

    '_USAGE_LIST_ALL_WEBLOGS' => 'Eine Liste aller Einträge in allen Weblogs, die Sie filtern, verwalten und bearbeiten können.',
    
    '_USAGE_COMMENTS_LIST' => 'Eine Liste der Kommentare zu [_1], die Sie filtern, verwalten und bearbeiten können.',
    
    '_USAGE_COMMENTS_LIST_ALL_WEBLOGS' => 'Eine Liste aller Kommentare in allen Weblogs, die Sie filtern, verwalten und bearbeiten können.',

    '_USAGE_COMMENTERS_LIST' => 'Eine Liste der authentifizierten Kommentatoren bei [_1]. Die Kommentatoren können Sie unten bearbeiten.',

    '_USAGE_PING_LIST' => 'Eine Liste der TrackBack-Pings zu [_1], die Sie filtern, verwalten und bearbeiten können.',
    
    '_USAGE_PING_LIST_ALL_WEBLOGS' => 'Eine Liste aller TrackBack-Pings in allen Weblogs, die Sie filtern, verwalten und bearbeiten können.',

    '_USAGE_NOTIFICATIONS' => 'Eine Liste der Personen, die benachrichtigt werden, wenn Sie einen neuen Eintrag veröffentlichen. Um eine neue Person hinzuzufügen, geben Sie einfach die Email-Adresse ein. Das URL-Feld ist optional.',

    '_USAGE_SEARCH' => 'Sie können Suchen &amp; Ersetzen einsetzenm, um Daten in Weblogs zu finden und optional zu ersetzen. WICHTIG:  Verwenden Sie Suchen &amp; Ersetzen mit Vorsicht. Der Vorgang kann <b>nicht</b> rückgängig gemacht werden.',

    '_USAGE_UPLOAD' => 'Laden Sie diese Datei in Ihren lokalen Site-Pfad <a href="javascript:alert(\'[_1]\')">(?)</a>. Optional können Sie die Datei in ein beliebiges Unterverzeichnis laden und den Pfad dann in der Textbox eintragen. Wenn das Verzeichnis nicht besteht, wird es angelegt.',

    '_THROTTLED_COMMENT_EMAIL' => 'Ein Kommentator Ihres Weblogs [_1] wurde automatisch gesperrt. Der Kommentator hat mehr als die erlaubte Anzahl an Kommentaren in den letzten [_2] Sekunden veröffentlicht. Diese Sperre schützt Sie vor Spam-Skripts. Die gesperrte IP-Adresse ist

    [_3]

Wenn diese Sperrung ein Fehler war, können Sie die IP-Adresse wieder entsperren. Wählen Sie die IP-Adresse [_4] aus der IP-Sperrliste und löschen Sie die Adresse aus der Liste.',
     '_THROTTLED_COMMENT' => 'Um mein Weblog vor Spam-Skripten zu schützen, müssen Sie einen Moment warten, um erneut einen Kommentar zu hinterlassen. Bitte haben Sie ein wenig Geduld. Danke für Ihr Verständnis.',

    '_AUTO' => 1,
    'DAILY_ADV' => 'Täglich',
    'WEEKLY_ADV' => 'Wöchentlich',
    'MONTHLY_ADV' => 'Monatlich',
    'INDIVIDUAL_ADV' => 'Einzeln',
    'CATEGORY_ADV' => 'Kategorie',
    'Daily' => 'Täglich',
    'Weekly' => 'Wöchentlich',
    'Monthly' => 'Monatliche',
    'Individual' => 'Einzelne',
    'Category' => 'Kategorie',
    'Category Archive' => 'Kategorie-Archiv',   
    'Date-Based Archive' => 'Datumsbasiertes Archiv',   
    'Individual Entry Archive' => 'Einzelne Einträge Archiv',
    'Atom Index' => 'Atom Index',    
    'Dynamic Site Bootstrapper' => 'Dynamic Site Bootstrapper',    
    'Main Index' => 'Main Index',    
    'Master Archive Index' => 'Master Archiv Index',    
    'RSD' => 'RSD',    
    'RSS 1.0 Index' => 'RSS 1.0 Index', 
    'RSS 2.0 Index' => 'RSS 2.0 Index', 
    'Stylesheet' => 'Stylesheet',

    'UTC+11' => 'UTC+11 (East Australian Daylight Savings Time)',
    'UTC+10' => 'UTC+10 (East Australian Standard Time)',

    '_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.org/sitede/">Movable Type <$MTVersion$></a>',
    'Blog Administrator' => 'Blog-Administrator',
    'Entry Creation' => 'Neuer Eintrag',
    'Edit All Entries' => 'Alle Einträge bearbeiten',
    'Manage Templates' => 'Templates verwalten',
    'Configure Weblog' => 'Weblog einrichten',
    'Rebuild Files' => 'Dateien neu veröffentlichen',
    'Send Notifications' => 'Benachrichtigungen versenden',
    'Manage Categories' => 'Kategorien verwalten',
    'Manage Notification List' => 'Benachrichtigungen verwalten',
    'View Activity Log For This Weblog' => 'Protokoll ansehen',
    'Publish Entries' => 'Einträge veröffentlichen',
    'Unpublish Entries' => 'Einträge nicht mehr veröffentlichen',
    'Unpublish TrackBack(s)' => 'TrackBacks nicht mehr veröffentlichen',
    'Unpublish Comment(s)' => 'Kommentare nicht mehr veröffentlichen',
    'Trust Commenter(s)' => 'Kommentatoren vertrauen',
    'Untrust Commenter(s)' => 'Kommentatoren nicht mehr vertrauen',
    'Ban Commenter(s)' => 'Kommentatorsperre einrichten',
    'Unban Commenter(s)' => 'Kommentatorsperre aufheben',
    'Untrust Commenter(s)' => 'Kommentatoren nicht mehr vertrauen',
    'Unban Commenter(s)' => 'Kommentatorsperre aufheben',
);

1;
